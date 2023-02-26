////////////////////////////////////
////////////   MEDICINE   /////////
//////////////////////////////////
/datum/reagent/claridyl
	name = "Claridyl Natural Remedy"
	id = "claridyl"
	description = "Claridyl is an advanced medicine that cures all of your problems. Notice: Clarydil does not claim to fix marriages, car loans, student debt or insomnia and may cause severe pain."
	taste_description = "sugar"
	reagent_state = LIQUID
	color = "#AAAAFF"
	overdose = REAGENTS_OVERDOSE * 100
	metabolism = REM * 0.1
	scannable = 1

/datum/reagent/claridyl/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien != IS_DIONA)
		M.add_chemical_effect(CE_STABLE, 30)
		M.add_chemical_effect(CE_PAINKILLER, 40)
		if(M.getBruteLoss())
			M.adjustBruteLoss(-1)
			M.adjustHalLoss(1.5)
		if(prob(0.0001))
			M.adjustToxLoss(50)//instant crit for tesh

		if(prob(0.1))
			pick(M.custom_pain("You suddenly feel inexplicably angry!",30),
			M.custom_pain("You suddenly lose your train of thought!",30),
			M.custom_pain("Your mouth feels dry!",30),
			M.make_dizzy(2),
			M.AdjustWeakened(10),
			M.AdjustStunned(1),
			M.AdjustParalysis(0.1),
			M.hallucination = max(M.hallucination, 2),
			M.flash_eyes(),
			M.custom_pain("Your vision becomes blurred!",30),
			M.add_chemical_effect(CE_ALCOHOL, 5),)

/datum/reagent/claridyl/bloodburn/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.bloodstr)//No seriously dont inject this wtf is wrong with you.
		for(var/datum/reagent/R in M.bloodstr.reagent_list)
			if(istype(R, /datum/reagent/blood))
				R.remove_self(removed * 15)

/datum/reagent/claridyl/bloodburn/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.ingested)
		for(var/datum/reagent/R in M.ingested.reagent_list)
			if(istype(R, /datum/reagent/ethanol))
				R.remove_self(removed * 5)

/datum/reagent/claridyl/bloodburn
	name = "Bloodburn"
	id = "bloodburn"
	description = "A chemical used to soak up any reagents inside someones stomach, injection is not advised, if you need to ask why please seek a new job."
	taste_description = "liquid void"
	color = "#000000"
	metabolism = REM * 5

/datum/reagent/eden
	name = "Eden"
	id = "eden"
	description = "The ultimate anti toxin unrivaled, it corrects impurities within the body but punishes those who attain them with a burning sensation"
	taste_description = "peace"
	color = "#00FFBE"
	overdose = REAGENTS_OVERDOSE * 1
	metabolism = 0

/datum/reagent/eden/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_SLIME || alien == IS_DIONA)
		return
	if(M.getToxLoss())
		M.adjustFireLoss(1.2)
		M.adjustToxLoss(-1)

/datum/reagent/eden/snake
	name = "Tainted Eden"
	id = "eden_snake"
	metabolism = 0.1
	description = "It used to be an anti toxin until it was tainted."
	taste_description = "hellfire"
	color = "#FF0000"

/datum/reagent/eden/snake/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustOxyLoss(1)
	M.adjustFireLoss(1)
	M.adjustBruteLoss(1)
	M.adjustToxLoss(1)

/datum/reagent/tercozolam
	name = "Tercozolam"
	id = "tercozolam"
	color = "#afeb17"
	metabolism = 0.05
	description = "A well respected drug used for treatment of schizophrenia in specific."
	overdose = REAGENTS_OVERDOSE * 2

///SAP REAGENTS////
//This is all a direct port from aeiou.

/datum/reagent/hannoa
	name = "Hannoa"
	id = "hannoa"
	description = "A powerful clotting agent that treats brute damage very quickly but takes a long time to be metabolised. Overdoses easily, reacts badly with other chemicals."
	taste_description = "paint"
	reagent_state = LIQUID
	color = "#163851"
	overdose = 8
	scannable = 1
	metabolism = 0.03

/datum/reagent/hannoa/overdose(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(ishuman(M))
		var/wound_heal = 1.5 * removed
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/external/O in H.bad_external_organs)
			for(var/datum/wound/W in O.wounds)
				if(W.bleeding())
					W.damage = max(W.damage - wound_heal, 0)
					if(W.damage <= 0)
						O.wounds -= W
		M.take_organ_damage(3 * removed, 0)
		if(M.losebreath < 15)
			M.AdjustLosebreath(1)
		H.custom_pain("It feels as if your veins are fusing shut!",60)

/datum/reagent/hannoa/affect_blood(var/mob/living/carbon/M, var/alien, var/removed) //Sleepy if not overdosing.
	..()
	var/effective_dose = dose
	if(effective_dose < 2)
		if(effective_dose == metabolism * 2 || prob(5))
			M.emote("yawn")
		else if(effective_dose < 5)
			M.eye_blurry = max(M.eye_blurry, 10)
		else if(effective_dose < 20)
			if(prob(50))
				M.Weaken(2)
			M.drowsyness = max(M.drowsyness, 20)
	else
		M.sleeping = max(M.sleeping, 20)


/datum/reagent/bullvalene //This is for the third sap. It converts Brute Oxy and burn into slightly less toxins.
	name = "bullvalene"
	id = "bullvalene"
	description = "A catalytic chemical that can treat a wide variety of ailments at the cost of toxifying the host's body."
	taste_description = "sulfur"
	reagent_state = LIQUID
	color = "#163851"
	overdose = 8 //This many units starts killing you.
	scannable = 1 // Mechs can scan this ye
	metabolism = 0.03 //Slow metabolism. This value was plucked out of nowhere. Can be changed.

/datum/reagent/bullvalene/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_SLIME || alien == IS_DIONA)
		return
	if(M.getBruteLoss() || M.getFireLoss() || M.getOxyLoss())
		M.adjustOxyLoss(-1)
		M.adjustFireLoss(-1)
		M.adjustBruteLoss(-1)
		M.adjustToxLoss(0.8)

/////SERAZINE REAGENTS///////

/datum/reagent/serazine
	name = "Serazine"
	id = "serazine"
	description = "A sweet tasting flower extract, it has very mild anti toxic properties, help with hallucinations and drowsyness, and can be used to make potent drugs."
	taste_description = "sweet nectar"
	reagent_state = LIQUID
	color = "#df9898"
	scannable = 1

/datum/reagent/serazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1
	if(alien != IS_DIONA)
		M.drowsyness = max(0, M.drowsyness - 3 * removed * chem_effective)
		M.hallucination = max(0, M.hallucination - 6 * removed * chem_effective)
		M.adjustToxLoss(-2 * removed * chem_effective)

/datum/reagent/alizene
	name = "Alizene"
	id = "alizene"
	description = "A derivative from bicaridine enhanced by serazine to more effectively mend flesh, but is ineffective against internal hemorrhage."
	taste_description = "bittersweet"
	taste_mult = 3
	reagent_state = LIQUID
	color = "#b37979"
	overdose = REAGENTS_OVERDOSE
	scannable = 1

/datum/reagent/alizene/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/chem_effective = 1
	if(alien == IS_SLIME)
		chem_effective = 0.75
	if(alien != IS_DIONA)
		M.heal_organ_damage(12 * removed * chem_effective, 0)

/datum/reagent/nutriment/glucose/galactose
	name = "Galactose"
	id = "galactose"
	description = "A clear sweet tasting fluid derived from lactose that is not as dense as glucose for IV application, restores blood less than glucose"
	nutriment_factor = 5 //1/6 of glucose but heals at half their effectiveness for some reason
	taste_description = "sweetness"
	color = "#ffffff"
	scannable = 1
	overdose = 45 //Prevents injecting yourself with too much and never bleed out again

/datum/reagent/nutriment/glucose/galactose/overdose(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.eye_blurry = min(20, max(0, M.eye_blurry + 10))
	if(prob(10)) // 1 in 10 per tick
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/brain/br = H.internal_organs_by_name[O_BRAIN] //Give brain damage spaceman, AKA no change at all
		br?.take_damage(1)
		to_chat(M, "<span class='warning'>You feel extremely jittery!</span>")

/datum/reagent/bathsalts
	name = "Bath Salts"
	id = "bathsalts"
	description = "An inpure concoction of various chemicals and stimulants that makes you impervious to stuns and grants a stamina regeneration buff, but will also cause massive neural degradation."
	taste_description = "salt"//salt is salty
	reagent_state = LIQUID
	color = "#e2e2e2"
	overdose = 15

/datum/reagent/bathsalts/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_SLIME || alien == IS_DIONA)
		return
	var/mob/living/carbon/human/H = M
	var/obj/item/organ/internal/brain/br = H.internal_organs_by_name[O_BRAIN] //This drug will make you immune to nearly all stuns and pain, but your brain will get FRIED. Intended for those 'last resort' moments.... or florida man shenanigans
	br?.take_damage(2) //Changed from 4 to 2 because polaris everything dies faster. 2 Brain damage a tick, 10u can still kill you.
	M.stuttering = max(M.stuttering, 4)
	M.add_chemical_effect(CE_PAINKILLER, 200)
	M.make_jittery(5)
	M.eye_blurry = min(20, max(0, M.eye_blurry + 10))
	//M.disable_duration_percent = 0 //immune to litterally any and all stun,sleep,halloss, etcetc. Idk how to do this so take this instead
	M.AdjustStunned(-25)
	M.AdjustWeakened(-25)
	M.AdjustParalysis(-25)
	M.drowsyness = 0
	M.SetSleeping(0)
	M.halloss = 0
	M.shock_stage = 0
	if(prob(15))
		to_chat(M, pick("<span class='notice'>You feel amped up.</span>","<span class='notice'>You feel ready..</span>","<span class='notice'>You feel like you can push it to the limit..</span>"))

/datum/reagent/bathsalts/overdose(var/mob/living/carbon/M, var/alien, var/removed) //You will twitch, laugh, drop shit, and have your brain deleted if you OD on this. You fucked up now
	..()
	var/mob/living/carbon/human/H = M
	var/obj/item/organ/internal/brain/br = H.internal_organs_by_name[O_BRAIN]
	br?.take_damage(8)
	if(alien == IS_SLIME || alien == IS_DIONA)
		return
	if(prob(15))
		M.emote(pick("twitch", "moan", "drool", "laugh"))
	if(prob(28))
		M.drop_r_hand()
		M.drop_l_hand()
	if(prob(25))
		M.Confuse(5)
