Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbaG1W11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 18:27:27 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:47434 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbaG1W1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 18:27:23 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/2] staging: vt6655: remove typedef enum __device_init_type
Date: Mon, 28 Jul 2014 23:26:25 +0100
Message-Id: <1406586386-2789-1-git-send-email-tvboxspy@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The value is either DEVICE_INIT_COLD or DEVICE_INIT_DXPL making no
difference to code.

Remove typedef and remove if statement in device_init_registers
pulling the code in.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h      |   6 -
 drivers/staging/vt6655/device_main.c | 412 +++++++++++++++++++----------------
 2 files changed, 225 insertions(+), 193 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index b36c631..9bf0ea9 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -185,12 +185,6 @@ typedef enum __device_msg_level {
 	MSG_LEVEL_DEBUG = 4           //Only for debug purpose.
 } DEVICE_MSG_LEVEL, *PDEVICE_MSG_LEVEL;
 
-typedef enum __device_init_type {
-	DEVICE_INIT_COLD = 0,         // cold init
-	DEVICE_INIT_RESET,          // reset init or Dx to D0 power remain init
-	DEVICE_INIT_DXPL            // Dx to D0 power lost init
-} DEVICE_INIT_TYPE, *PDEVICE_INIT_TYPE;
-
 //++ NDIS related
 
 #define MAX_BSSIDINFO_4_PMKID   16
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 926c0d9..0ecc99b 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -304,7 +304,7 @@ static int  ethtool_ioctl(struct net_device *dev, void __user *useraddr);
 static int  device_rx_srv(PSDevice pDevice, unsigned int uIdx);
 static int  device_tx_srv(PSDevice pDevice, unsigned int uIdx);
 static bool device_alloc_rx_buf(PSDevice pDevice, PSRxDesc pDesc);
-static void device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType);
+static void device_init_registers(PSDevice pDevice);
 static void device_free_tx_buf(PSDevice pDevice, PSTxDesc pDesc);
 static void device_free_td0_ring(PSDevice pDevice);
 static void device_free_td1_ring(PSDevice pDevice);
@@ -453,7 +453,7 @@ static void s_vCompleteCurrentMeasure(PSDevice pDevice, unsigned char byResult)
 // Initialisation of MAC & BBP registers
 //
 
-static void device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
+static void device_init_registers(PSDevice pDevice)
 {
 	unsigned int ii;
 	unsigned char byValue;
@@ -466,239 +466,276 @@ static void device_init_registers(PSDevice pDevice, DEVICE_INIT_TYPE InitType)
 	MACbShutdown(pDevice->PortOffset);
 	BBvSoftwareReset(pDevice->PortOffset);
 
-	if ((InitType == DEVICE_INIT_COLD) ||
-	    (InitType == DEVICE_INIT_DXPL)) {
-		// Do MACbSoftwareReset in MACvInitialize
-		MACbSoftwareReset(pDevice->PortOffset);
-		// force CCK
-		pDevice->bCCK = true;
-		pDevice->bAES = false;
-		pDevice->bProtectMode = false;      //Only used in 11g type, sync with ERP IE
-		pDevice->bNonERPPresent = false;
-		pDevice->bBarkerPreambleMd = false;
-		pDevice->wCurrentRate = RATE_1M;
-		pDevice->byTopOFDMBasicRate = RATE_24M;
-		pDevice->byTopCCKBasicRate = RATE_1M;
+	/* Do MACbSoftwareReset in MACvInitialize */
+	MACbSoftwareReset(pDevice->PortOffset);
 
-		pDevice->byRevId = 0;                   //Target to IF pin while programming to RF chip.
+	/* force CCK */
+	pDevice->bCCK = true;
+	pDevice->bAES = false;
 
-		// init MAC
-		MACvInitialize(pDevice->PortOffset);
+	/* Only used in 11g type, sync with ERP IE */
+	pDevice->bProtectMode = false;
 
-		// Get Local ID
-		VNSvInPortB(pDevice->PortOffset + MAC_REG_LOCALID, &(pDevice->byLocalID));
+	pDevice->bNonERPPresent = false;
+	pDevice->bBarkerPreambleMd = false;
+	pDevice->wCurrentRate = RATE_1M;
+	pDevice->byTopOFDMBasicRate = RATE_24M;
+	pDevice->byTopCCKBasicRate = RATE_1M;
 
-		spin_lock_irq(&pDevice->lock);
-		SROMvReadAllContents(pDevice->PortOffset, pDevice->abyEEPROM);
+	/* Target to IF pin while programming to RF chip. */
+	pDevice->byRevId = 0;
 
-		spin_unlock_irq(&pDevice->lock);
+	/* init MAC */
+	MACvInitialize(pDevice->PortOffset);
+
+	/* Get Local ID */
+	VNSvInPortB(pDevice->PortOffset + MAC_REG_LOCALID, &pDevice->byLocalID);
+
+	spin_lock_irq(&pDevice->lock);
 
-		// Get Channel range
+	SROMvReadAllContents(pDevice->PortOffset, pDevice->abyEEPROM);
 
-		pDevice->byMinChannel = 1;
-		pDevice->byMaxChannel = CB_MAX_CHANNEL;
+	spin_unlock_irq(&pDevice->lock);
+
+	/* Get Channel range */
+	pDevice->byMinChannel = 1;
+	pDevice->byMaxChannel = CB_MAX_CHANNEL;
 
-		// Get Antena
-		byValue = SROMbyReadEmbedded(pDevice->PortOffset, EEP_OFS_ANTENNA);
-		if (byValue & EEP_ANTINV)
-			pDevice->bTxRxAntInv = true;
+	/* Get Antena */
+	byValue = SROMbyReadEmbedded(pDevice->PortOffset, EEP_OFS_ANTENNA);
+	if (byValue & EEP_ANTINV)
+		pDevice->bTxRxAntInv = true;
+	else
+		pDevice->bTxRxAntInv = false;
+
+	byValue &= (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN);
+	/* if not set default is All */
+	if (byValue == 0)
+		byValue = (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN);
+
+	pDevice->ulDiversityNValue = 100*260;
+	pDevice->ulDiversityMValue = 100*16;
+	pDevice->byTMax = 1;
+	pDevice->byTMax2 = 4;
+	pDevice->ulSQ3TH = 0;
+	pDevice->byTMax3 = 64;
+
+	if (byValue == (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN)) {
+		pDevice->byAntennaCount = 2;
+		pDevice->byTxAntennaMode = ANT_B;
+		pDevice->dwTxAntennaSel = 1;
+		pDevice->dwRxAntennaSel = 1;
+
+		if (pDevice->bTxRxAntInv)
+			pDevice->byRxAntennaMode = ANT_A;
 		else
-			pDevice->bTxRxAntInv = false;
+			pDevice->byRxAntennaMode = ANT_B;
+
+		byValue1 = SROMbyReadEmbedded(pDevice->PortOffset,
+					      EEP_OFS_ANTENNA);
 
-		byValue &= (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN);
-		if (byValue == 0) // if not set default is All
-			byValue = (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN);
+		if ((byValue1 & 0x08) == 0)
+			pDevice->bDiversityEnable = false;
+		else
+			pDevice->bDiversityEnable = true;
+	} else  {
+		pDevice->bDiversityEnable = false;
+		pDevice->byAntennaCount = 1;
+		pDevice->dwTxAntennaSel = 0;
+		pDevice->dwRxAntennaSel = 0;
 
-		pDevice->ulDiversityNValue = 100*260;
-		pDevice->ulDiversityMValue = 100*16;
-		pDevice->byTMax = 1;
-		pDevice->byTMax2 = 4;
-		pDevice->ulSQ3TH = 0;
-		pDevice->byTMax3 = 64;
+		if (byValue & EEP_ANTENNA_AUX) {
+			pDevice->byTxAntennaMode = ANT_A;
 
-		if (byValue == (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN)) {
-			pDevice->byAntennaCount = 2;
+			if (pDevice->bTxRxAntInv)
+				pDevice->byRxAntennaMode = ANT_B;
+			else
+				pDevice->byRxAntennaMode = ANT_A;
+		} else {
 			pDevice->byTxAntennaMode = ANT_B;
-			pDevice->dwTxAntennaSel = 1;
-			pDevice->dwRxAntennaSel = 1;
+
 			if (pDevice->bTxRxAntInv)
 				pDevice->byRxAntennaMode = ANT_A;
 			else
 				pDevice->byRxAntennaMode = ANT_B;
-			// chester for antenna
-			byValue1 = SROMbyReadEmbedded(pDevice->PortOffset, EEP_OFS_ANTENNA);
-			if ((byValue1 & 0x08) == 0)
-				pDevice->bDiversityEnable = false;
-			else
-				pDevice->bDiversityEnable = true;
-		} else  {
-			pDevice->bDiversityEnable = false;
-			pDevice->byAntennaCount = 1;
-			pDevice->dwTxAntennaSel = 0;
-			pDevice->dwRxAntennaSel = 0;
-			if (byValue & EEP_ANTENNA_AUX) {
-				pDevice->byTxAntennaMode = ANT_A;
-				if (pDevice->bTxRxAntInv)
-					pDevice->byRxAntennaMode = ANT_B;
-				else
-					pDevice->byRxAntennaMode = ANT_A;
-			} else {
-				pDevice->byTxAntennaMode = ANT_B;
-				if (pDevice->bTxRxAntInv)
-					pDevice->byRxAntennaMode = ANT_A;
-				else
-					pDevice->byRxAntennaMode = ANT_B;
-			}
 		}
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "bDiversityEnable=[%d],NValue=[%d],MValue=[%d],TMax=[%d],TMax2=[%d]\n",
-			pDevice->bDiversityEnable, (int)pDevice->ulDiversityNValue, (int)pDevice->ulDiversityMValue, pDevice->byTMax, pDevice->byTMax2);
-
-//2008-8-4 <add> by chester
-//zonetype initial
-		pDevice->byOriginalZonetype = pDevice->abyEEPROM[EEP_OFS_ZONETYPE];
-		zonetype = Config_FileOperation(pDevice, false, NULL);
-		if (zonetype >= 0) {         //read zonetype file ok!
-			if ((zonetype == 0) &&
-			    (pDevice->abyEEPROM[EEP_OFS_ZONETYPE] != 0x00)) {          //for USA
-				pDevice->abyEEPROM[EEP_OFS_ZONETYPE] = 0;
-				pDevice->abyEEPROM[EEP_OFS_MAXCHANNEL] = 0x0B;
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Init Zone Type :USA\n");
-			} else if ((zonetype == 1) &&
-				 (pDevice->abyEEPROM[EEP_OFS_ZONETYPE] != 0x01)) {   //for Japan
-				pDevice->abyEEPROM[EEP_OFS_ZONETYPE] = 0x01;
-				pDevice->abyEEPROM[EEP_OFS_MAXCHANNEL] = 0x0D;
-			} else if ((zonetype == 2) &&
-				 (pDevice->abyEEPROM[EEP_OFS_ZONETYPE] != 0x02)) {   //for Europe
-				pDevice->abyEEPROM[EEP_OFS_ZONETYPE] = 0x02;
-				pDevice->abyEEPROM[EEP_OFS_MAXCHANNEL] = 0x0D;
-				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Init Zone Type :Europe\n");
-			}
+	}
 
-			else {
-				if (zonetype != pDevice->abyEEPROM[EEP_OFS_ZONETYPE])
-					pr_debug("zonetype in file[%02x] mismatch with in EEPROM[%02x]\n", zonetype, pDevice->abyEEPROM[EEP_OFS_ZONETYPE]);
-				else
-					pr_debug("Read Zonetype file success,use default zonetype setting[%02x]\n", zonetype);
-			}
-		} else
-			pr_debug("Read Zonetype file fail,use default zonetype setting[%02x]\n", SROMbyReadEmbedded(pDevice->PortOffset, EEP_OFS_ZONETYPE));
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+		"bDiversityEnable=[%d],NValue=[%d],MValue=[%d],TMax=[%d],TMax2=[%d]\n",
+		pDevice->bDiversityEnable, (int)pDevice->ulDiversityNValue,
+		(int)pDevice->ulDiversityMValue, pDevice->byTMax, pDevice->byTMax2);
+
+	/* zonetype initial */
+	pDevice->byOriginalZonetype = pDevice->abyEEPROM[EEP_OFS_ZONETYPE];
+	zonetype = Config_FileOperation(pDevice, false, NULL);
+
+	if (zonetype >= 0) {
+		if ((zonetype == 0) &&
+		    (pDevice->abyEEPROM[EEP_OFS_ZONETYPE] != 0x00)) {
+			/* for USA */
+			pDevice->abyEEPROM[EEP_OFS_ZONETYPE] = 0;
+			pDevice->abyEEPROM[EEP_OFS_MAXCHANNEL] = 0x0B;
+
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Init Zone Type :USA\n");
+		} else if ((zonetype == 1) &&
+			 (pDevice->abyEEPROM[EEP_OFS_ZONETYPE] != 0x01)) {
+			/* for Japan */
+			pDevice->abyEEPROM[EEP_OFS_ZONETYPE] = 0x01;
+			pDevice->abyEEPROM[EEP_OFS_MAXCHANNEL] = 0x0D;
+		} else if ((zonetype == 2) &&
+			  (pDevice->abyEEPROM[EEP_OFS_ZONETYPE] != 0x02)) {
+			/* for Europe */
+			pDevice->abyEEPROM[EEP_OFS_ZONETYPE] = 0x02;
+			pDevice->abyEEPROM[EEP_OFS_MAXCHANNEL] = 0x0D;
+
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Init Zone Type :Europe\n");
+		} else {
+			if (zonetype != pDevice->abyEEPROM[EEP_OFS_ZONETYPE])
+				pr_debug("zonetype in file[%02x] mismatch with in EEPROM[%02x]\n",
+					 zonetype,
+					 pDevice->abyEEPROM[EEP_OFS_ZONETYPE]);
+			else
+				pr_debug("Read Zonetype file success,use default zonetype setting[%02x]\n",
+					 zonetype);
+		}
+	} else {
+		pr_debug("Read Zonetype file fail,use default zonetype setting[%02x]\n",
+			 SROMbyReadEmbedded(pDevice->PortOffset, EEP_OFS_ZONETYPE));
+	}
 
-		// Get RFType
-		pDevice->byRFType = SROMbyReadEmbedded(pDevice->PortOffset, EEP_OFS_RFTYPE);
+	/* Get RFType */
+	pDevice->byRFType = SROMbyReadEmbedded(pDevice->PortOffset, EEP_OFS_RFTYPE);
 
-		if ((pDevice->byRFType & RF_EMU) != 0) {
-			// force change RevID for VT3253 emu
+	/* force change RevID for VT3253 emu */
+	if ((pDevice->byRFType & RF_EMU) != 0)
 			pDevice->byRevId = 0x80;
-		}
 
-		pDevice->byRFType &= RF_MASK;
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pDevice->byRFType = %x\n", pDevice->byRFType);
+	pDevice->byRFType &= RF_MASK;
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pDevice->byRFType = %x\n", pDevice->byRFType);
 
-		if (!pDevice->bZoneRegExist)
-			pDevice->byZoneType = pDevice->abyEEPROM[EEP_OFS_ZONETYPE];
+	if (!pDevice->bZoneRegExist)
+		pDevice->byZoneType = pDevice->abyEEPROM[EEP_OFS_ZONETYPE];
 
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pDevice->byZoneType = %x\n", pDevice->byZoneType);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pDevice->byZoneType = %x\n", pDevice->byZoneType);
 
-		//Init RF module
-		RFbInit(pDevice);
+	/* Init RF module */
+	RFbInit(pDevice);
 
-		//Get Desire Power Value
-		pDevice->byCurPwr = 0xFF;
-		pDevice->byCCKPwr = SROMbyReadEmbedded(pDevice->PortOffset, EEP_OFS_PWR_CCK);
-		pDevice->byOFDMPwrG = SROMbyReadEmbedded(pDevice->PortOffset, EEP_OFS_PWR_OFDMG);
+	/* Get Desire Power Value */
+	pDevice->byCurPwr = 0xFF;
+	pDevice->byCCKPwr = SROMbyReadEmbedded(pDevice->PortOffset, EEP_OFS_PWR_CCK);
+	pDevice->byOFDMPwrG = SROMbyReadEmbedded(pDevice->PortOffset, EEP_OFS_PWR_OFDMG);
 
-		// Load power Table
+	/* Load power Table */
+	for (ii = 0; ii < CB_MAX_CHANNEL_24G; ii++) {
+		pDevice->abyCCKPwrTbl[ii + 1] =
+			SROMbyReadEmbedded(pDevice->PortOffset,
+					   (unsigned char)(ii + EEP_OFS_CCK_PWR_TBL));
+		if (pDevice->abyCCKPwrTbl[ii + 1] == 0)
+			pDevice->abyCCKPwrTbl[ii+1] = pDevice->byCCKPwr;
 
-		for (ii = 0; ii < CB_MAX_CHANNEL_24G; ii++) {
-			pDevice->abyCCKPwrTbl[ii + 1] = SROMbyReadEmbedded(pDevice->PortOffset, (unsigned char)(ii + EEP_OFS_CCK_PWR_TBL));
-			if (pDevice->abyCCKPwrTbl[ii + 1] == 0)
-				pDevice->abyCCKPwrTbl[ii+1] = pDevice->byCCKPwr;
+		pDevice->abyOFDMPwrTbl[ii + 1] =
+			SROMbyReadEmbedded(pDevice->PortOffset,
+					   (unsigned char)(ii + EEP_OFS_OFDM_PWR_TBL));
+		if (pDevice->abyOFDMPwrTbl[ii + 1] == 0)
+			pDevice->abyOFDMPwrTbl[ii + 1] = pDevice->byOFDMPwrG;
 
-			pDevice->abyOFDMPwrTbl[ii + 1] = SROMbyReadEmbedded(pDevice->PortOffset, (unsigned char)(ii + EEP_OFS_OFDM_PWR_TBL));
-			if (pDevice->abyOFDMPwrTbl[ii + 1] == 0)
-				pDevice->abyOFDMPwrTbl[ii + 1] = pDevice->byOFDMPwrG;
+		pDevice->abyCCKDefaultPwr[ii + 1] = byCCKPwrdBm;
+		pDevice->abyOFDMDefaultPwr[ii + 1] = byOFDMPwrdBm;
+	}
 
-			pDevice->abyCCKDefaultPwr[ii + 1] = byCCKPwrdBm;
-			pDevice->abyOFDMDefaultPwr[ii + 1] = byOFDMPwrdBm;
-		}
-		//2008-8-4 <add> by chester
-		//recover 12,13 ,14channel for EUROPE by 11 channel
-		if (((pDevice->abyEEPROM[EEP_OFS_ZONETYPE] == ZoneType_Japan) ||
-		     (pDevice->abyEEPROM[EEP_OFS_ZONETYPE] == ZoneType_Europe)) &&
-		    (pDevice->byOriginalZonetype == ZoneType_USA)) {
-			for (ii = 11; ii < 14; ii++) {
-				pDevice->abyCCKPwrTbl[ii] = pDevice->abyCCKPwrTbl[10];
-				pDevice->abyOFDMPwrTbl[ii] = pDevice->abyOFDMPwrTbl[10];
+	/* recover 12,13 ,14channel for EUROPE by 11 channel */
+	if (((pDevice->abyEEPROM[EEP_OFS_ZONETYPE] == ZoneType_Japan) ||
+	     (pDevice->abyEEPROM[EEP_OFS_ZONETYPE] == ZoneType_Europe)) &&
+	    (pDevice->byOriginalZonetype == ZoneType_USA)) {
+		for (ii = 11; ii < 14; ii++) {
+			pDevice->abyCCKPwrTbl[ii] = pDevice->abyCCKPwrTbl[10];
+			pDevice->abyOFDMPwrTbl[ii] = pDevice->abyOFDMPwrTbl[10];
 
-			}
 		}
+	}
 
-		// Load OFDM A Power Table
-		for (ii = 0; ii < CB_MAX_CHANNEL_5G; ii++) { //RobertYu:20041224, bug using CB_MAX_CHANNEL
-			pDevice->abyOFDMPwrTbl[ii + CB_MAX_CHANNEL_24G + 1] = SROMbyReadEmbedded(pDevice->PortOffset, (unsigned char)(ii + EEP_OFS_OFDMA_PWR_TBL));
-			pDevice->abyOFDMDefaultPwr[ii + CB_MAX_CHANNEL_24G + 1] = SROMbyReadEmbedded(pDevice->PortOffset, (unsigned char)(ii + EEP_OFS_OFDMA_PWR_dBm));
-		}
-		init_channel_table((void *)pDevice);
+	/* Load OFDM A Power Table */
+	for (ii = 0; ii < CB_MAX_CHANNEL_5G; ii++) {
+		pDevice->abyOFDMPwrTbl[ii + CB_MAX_CHANNEL_24G + 1] =
+			SROMbyReadEmbedded(pDevice->PortOffset,
+					   (unsigned char)(ii + EEP_OFS_OFDMA_PWR_TBL));
 
-		if (pDevice->byLocalID > REV_ID_VT3253_B1) {
-			MACvSelectPage1(pDevice->PortOffset);
-			VNSvOutPortB(pDevice->PortOffset + MAC_REG_MSRCTL + 1, (MSRCTL1_TXPWR | MSRCTL1_CSAPAREN));
-			MACvSelectPage0(pDevice->PortOffset);
-		}
+		pDevice->abyOFDMDefaultPwr[ii + CB_MAX_CHANNEL_24G + 1] =
+			SROMbyReadEmbedded(pDevice->PortOffset,
+					   (unsigned char)(ii + EEP_OFS_OFDMA_PWR_dBm));
+	}
+
+	init_channel_table((void *)pDevice);
+
+	if (pDevice->byLocalID > REV_ID_VT3253_B1) {
+		MACvSelectPage1(pDevice->PortOffset);
 
-		// use relative tx timeout and 802.11i D4
-		MACvWordRegBitsOn(pDevice->PortOffset, MAC_REG_CFG, (CFG_TKIPOPT | CFG_NOTXTIMEOUT));
+		VNSvOutPortB(pDevice->PortOffset + MAC_REG_MSRCTL + 1,
+			     (MSRCTL1_TXPWR | MSRCTL1_CSAPAREN));
 
-		// set performance parameter by registry
-		MACvSetShortRetryLimit(pDevice->PortOffset, pDevice->byShortRetryLimit);
-		MACvSetLongRetryLimit(pDevice->PortOffset, pDevice->byLongRetryLimit);
+		MACvSelectPage0(pDevice->PortOffset);
+	}
 
-		// reset TSF counter
-		VNSvOutPortB(pDevice->PortOffset + MAC_REG_TFTCTL, TFTCTL_TSFCNTRST);
-		// enable TSF counter
-		VNSvOutPortB(pDevice->PortOffset + MAC_REG_TFTCTL, TFTCTL_TSFCNTREN);
+	/* use relative tx timeout and 802.11i D4 */
+	MACvWordRegBitsOn(pDevice->PortOffset,
+			  MAC_REG_CFG, (CFG_TKIPOPT | CFG_NOTXTIMEOUT));
 
-		// initialize BBP registers
-		BBbVT3253Init(pDevice);
+	/* set performance parameter by registry */
+	MACvSetShortRetryLimit(pDevice->PortOffset, pDevice->byShortRetryLimit);
+	MACvSetLongRetryLimit(pDevice->PortOffset, pDevice->byLongRetryLimit);
 
-		if (pDevice->bUpdateBBVGA) {
-			pDevice->byBBVGACurrent = pDevice->abyBBVGA[0];
-			pDevice->byBBVGANew = pDevice->byBBVGACurrent;
-			BBvSetVGAGainOffset(pDevice, pDevice->abyBBVGA[0]);
-		}
-		BBvSetRxAntennaMode(pDevice->PortOffset, pDevice->byRxAntennaMode);
-		BBvSetTxAntennaMode(pDevice->PortOffset, pDevice->byTxAntennaMode);
+	/* reset TSF counter */
+	VNSvOutPortB(pDevice->PortOffset + MAC_REG_TFTCTL, TFTCTL_TSFCNTRST);
+	/* enable TSF counter */
+	VNSvOutPortB(pDevice->PortOffset + MAC_REG_TFTCTL, TFTCTL_TSFCNTREN);
 
-		pDevice->byCurrentCh = 0;
+	/* initialize BBP registers */
+	BBbVT3253Init(pDevice);
 
-		// Set BB and packet type at the same time.
-		// Set Short Slot Time, xIFS, and RSPINF.
-		if (pDevice->uConnectionRate == RATE_AUTO)
-			pDevice->wCurrentRate = RATE_54M;
-		else
-			pDevice->wCurrentRate = (unsigned short)pDevice->uConnectionRate;
+	if (pDevice->bUpdateBBVGA) {
+		pDevice->byBBVGACurrent = pDevice->abyBBVGA[0];
+		pDevice->byBBVGANew = pDevice->byBBVGACurrent;
+		BBvSetVGAGainOffset(pDevice, pDevice->abyBBVGA[0]);
+	}
+
+	BBvSetRxAntennaMode(pDevice->PortOffset, pDevice->byRxAntennaMode);
+	BBvSetTxAntennaMode(pDevice->PortOffset, pDevice->byTxAntennaMode);
+
+	pDevice->byCurrentCh = 0;
 
-		// default G Mode
-		VNTWIFIbConfigPhyMode(pDevice->pMgmt, PHY_TYPE_11G);
-		VNTWIFIbConfigPhyMode(pDevice->pMgmt, PHY_TYPE_AUTO);
+	/* Set BB and packet type at the same time. */
+	/* Set Short Slot Time, xIFS, and RSPINF. */
+	if (pDevice->uConnectionRate == RATE_AUTO)
+		pDevice->wCurrentRate = RATE_54M;
+	else
+		pDevice->wCurrentRate = (unsigned short)pDevice->uConnectionRate;
+
+	/* default G Mode */
+	VNTWIFIbConfigPhyMode(pDevice->pMgmt, PHY_TYPE_11G);
+	VNTWIFIbConfigPhyMode(pDevice->pMgmt, PHY_TYPE_AUTO);
 
-		pDevice->bRadioOff = false;
+	pDevice->bRadioOff = false;
 
-		pDevice->byRadioCtl = SROMbyReadEmbedded(pDevice->PortOffset, EEP_OFS_RADIOCTL);
-		pDevice->bHWRadioOff = false;
+	pDevice->byRadioCtl = SROMbyReadEmbedded(pDevice->PortOffset,
+						 EEP_OFS_RADIOCTL);
+	pDevice->bHWRadioOff = false;
 
-		if (pDevice->byRadioCtl & EEP_RADIOCTL_ENABLE) {
-			// Get GPIO
-			MACvGPIOIn(pDevice->PortOffset, &pDevice->byGPIO);
-//2008-4-14 <add> by chester for led issue
-		if (((pDevice->byGPIO & GPIO0_DATA) && !(pDevice->byRadioCtl & EEP_RADIOCTL_INV)) ||
-		    (!(pDevice->byGPIO & GPIO0_DATA) && (pDevice->byRadioCtl & EEP_RADIOCTL_INV))) {
+	if (pDevice->byRadioCtl & EEP_RADIOCTL_ENABLE) {
+		/* Get GPIO */
+		MACvGPIOIn(pDevice->PortOffset, &pDevice->byGPIO);
+
+		if (((pDevice->byGPIO & GPIO0_DATA) &&
+		     !(pDevice->byRadioCtl & EEP_RADIOCTL_INV)) ||
+		     (!(pDevice->byGPIO & GPIO0_DATA) &&
+		     (pDevice->byRadioCtl & EEP_RADIOCTL_INV)))
 			pDevice->bHWRadioOff = true;
-		}
 	}
+
 	if (pDevice->bHWRadioOff || pDevice->bRadioControlOff)
 		CARDbRadioPowerOff(pDevice);
-}
+
 pMgmt->eScanType = WMAC_SCAN_PASSIVE;
 // get Permanent network address
 SROMvReadEtherAddress(pDevice->PortOffset, pDevice->abyCurrentNetAddr);
@@ -1642,7 +1679,8 @@ static int  device_open(struct net_device *dev)
 	vMgrTimerInit(pDevice);
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "call device_init_registers\n");
-	device_init_registers(pDevice, DEVICE_INIT_COLD);
+	device_init_registers(pDevice);
+
 	MACvReadEtherAddress(pDevice->PortOffset, pDevice->abyCurrentNetAddr);
 	memcpy(pDevice->pMgmt->abyMACAddr, pDevice->abyCurrentNetAddr, ETH_ALEN);
 	device_set_multi(pDevice->dev);
@@ -3187,7 +3225,7 @@ viawget_resume(struct pci_dev *pcid)
 	if (netif_running(pDevice->dev)) {
 		spin_lock_irq(&pDevice->lock);
 		MACvRestoreContext(pDevice->PortOffset, pDevice->abyMacContext);
-		device_init_registers(pDevice, DEVICE_INIT_DXPL);
+		device_init_registers(pDevice);
 		if (pMgmt->sNodeDBTable[0].bActive) { // Assoc with BSS
 			pMgmt->sNodeDBTable[0].bActive = false;
 			pDevice->bLinkPass = false;
-- 
1.9.1

