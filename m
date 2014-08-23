Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaHWOUn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 10:20:43 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:63038 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbaHWOUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 10:20:37 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 12/20] staging: rtl8188eu: Rework function _PHY_SetBWMode92C()
Date: Sat, 23 Aug 2014 19:48:33 +0530
Message-Id: <1408803521-13715-12-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
References: <1408803521-13715-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CamelCase variables and function name.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c |   98 +++++++++--------------
 1 file changed, 37 insertions(+), 61 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
index c33da36..89ec958 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
@@ -259,102 +259,78 @@ PHY_SetTxPowerLevel8188E(
 	rtl8188e_PHY_RF6052SetOFDMTxPower(Adapter, &ofdmPowerLevel[0], &BW20PowerLevel[0], &BW40PowerLevel[0], channel);
 }
 
-/*-----------------------------------------------------------------------------
- * Function:    PHY_SetBWModeCallback8192C()
- *
- * Overview:    Timer callback function for SetSetBWMode
- *
- * Input:		PRT_TIMER		pTimer
- *
- * Output:      NONE
- *
- * Return:      NONE
- *
- * Note:		(1) We do not take j mode into consideration now
- *			(2) Will two workitem of "switch channel" and "switch channel bandwidth" run
- *			     concurrently?
- *---------------------------------------------------------------------------*/
-static void
-_PHY_SetBWMode92C(
-		struct adapter *Adapter
-)
+static void phy_set_bw_mode_callback(struct adapter *adapt)
 {
-	struct hal_data_8188e *pHalData = GET_HAL_DATA(Adapter);
-	u8 regBwOpMode;
-	u8 regRRSR_RSC;
+	struct hal_data_8188e *hal_data = GET_HAL_DATA(adapt);
+	u8 reg_bw_opmode;
+	u8 reg_prsr_rsc;
 
-	if (pHalData->rf_chip == RF_PSEUDO_11N)
+	if (hal_data->rf_chip == RF_PSEUDO_11N)
 		return;
 
 	/*  There is no 40MHz mode in RF_8225. */
-	if (pHalData->rf_chip == RF_8225)
+	if (hal_data->rf_chip == RF_8225)
 		return;
 
-	if (Adapter->bDriverStopped)
+	if (adapt->bDriverStopped)
 		return;
 
-	/* 3 */
-	/* 3<1>Set MAC register */
-	/* 3 */
+	/* Set MAC register */
 
-	regBwOpMode = usb_read8(Adapter, REG_BWOPMODE);
-	regRRSR_RSC = usb_read8(Adapter, REG_RRSR+2);
+	reg_bw_opmode = usb_read8(adapt, REG_BWOPMODE);
+	reg_prsr_rsc = usb_read8(adapt, REG_RRSR+2);
 
-	switch (pHalData->CurrentChannelBW) {
+	switch (hal_data->CurrentChannelBW) {
 	case HT_CHANNEL_WIDTH_20:
-		regBwOpMode |= BW_OPMODE_20MHZ;
-		/*  2007/02/07 Mark by Emily because we have not verify whether this register works */
-		usb_write8(Adapter, REG_BWOPMODE, regBwOpMode);
+		reg_bw_opmode |= BW_OPMODE_20MHZ;
+		usb_write8(adapt, REG_BWOPMODE, reg_bw_opmode);
 		break;
 	case HT_CHANNEL_WIDTH_40:
-		regBwOpMode &= ~BW_OPMODE_20MHZ;
-		/*  2007/02/07 Mark by Emily because we have not verify whether this register works */
-		usb_write8(Adapter, REG_BWOPMODE, regBwOpMode);
-		regRRSR_RSC = (regRRSR_RSC&0x90) | (pHalData->nCur40MhzPrimeSC<<5);
-		usb_write8(Adapter, REG_RRSR+2, regRRSR_RSC);
+		reg_bw_opmode &= ~BW_OPMODE_20MHZ;
+		usb_write8(adapt, REG_BWOPMODE, reg_bw_opmode);
+		reg_prsr_rsc = (reg_prsr_rsc&0x90) |
+			       (hal_data->nCur40MhzPrimeSC<<5);
+		usb_write8(adapt, REG_RRSR+2, reg_prsr_rsc);
 		break;
 	default:
 		break;
 	}
 
-	/* 3  */
-	/* 3 <2>Set PHY related register */
-	/* 3 */
-	switch (pHalData->CurrentChannelBW) {
-	/* 20 MHz channel*/
+	/* Set PHY related register */
+	switch (hal_data->CurrentChannelBW) {
 	case HT_CHANNEL_WIDTH_20:
-		phy_set_bb_reg(Adapter, rFPGA0_RFMOD, bRFMOD, 0x0);
-		phy_set_bb_reg(Adapter, rFPGA1_RFMOD, bRFMOD, 0x0);
+		phy_set_bb_reg(adapt, rFPGA0_RFMOD, bRFMOD, 0x0);
+		phy_set_bb_reg(adapt, rFPGA1_RFMOD, bRFMOD, 0x0);
 		break;
-	/* 40 MHz channel*/
 	case HT_CHANNEL_WIDTH_40:
-		phy_set_bb_reg(Adapter, rFPGA0_RFMOD, bRFMOD, 0x1);
-		phy_set_bb_reg(Adapter, rFPGA1_RFMOD, bRFMOD, 0x1);
-		/*  Set Control channel to upper or lower. These settings are required only for 40MHz */
-		phy_set_bb_reg(Adapter, rCCK0_System, bCCKSideBand, (pHalData->nCur40MhzPrimeSC>>1));
-		phy_set_bb_reg(Adapter, rOFDM1_LSTF, 0xC00, pHalData->nCur40MhzPrimeSC);
-		phy_set_bb_reg(Adapter, 0x818, (BIT26 | BIT27),
-			     (pHalData->nCur40MhzPrimeSC == HAL_PRIME_CHNL_OFFSET_LOWER) ? 2 : 1);
+		phy_set_bb_reg(adapt, rFPGA0_RFMOD, bRFMOD, 0x1);
+		phy_set_bb_reg(adapt, rFPGA1_RFMOD, bRFMOD, 0x1);
+		/* Set Control channel to upper or lower.
+		 * These settings are required only for 40MHz
+		 */
+		phy_set_bb_reg(adapt, rCCK0_System, bCCKSideBand,
+		    (hal_data->nCur40MhzPrimeSC>>1));
+		phy_set_bb_reg(adapt, rOFDM1_LSTF, 0xC00,
+			       hal_data->nCur40MhzPrimeSC);
+		phy_set_bb_reg(adapt, 0x818, (BIT26 | BIT27),
+		   (hal_data->nCur40MhzPrimeSC == HAL_PRIME_CHNL_OFFSET_LOWER) ? 2 : 1);
 		break;
 	default:
 		break;
 	}
-	/* Skip over setting of J-mode in BB register here. Default value is "None J mode". Emily 20070315 */
 
-	/* 3<3>Set RF related register */
-	switch (pHalData->rf_chip) {
+	/* Set RF related register */
+	switch (hal_data->rf_chip) {
 	case RF_8225:
 		break;
 	case RF_8256:
-		/*  Please implement this function in Hal8190PciPhy8256.c */
 		break;
 	case RF_8258:
-		/*  Please implement this function in Hal8190PciPhy8258.c */
 		break;
 	case RF_PSEUDO_11N:
 		break;
 	case RF_6052:
-		rtl8188e_PHY_RF6052SetBandwidth(Adapter, pHalData->CurrentChannelBW);
+		rtl8188e_PHY_RF6052SetBandwidth(adapt, hal_data->CurrentChannelBW);
 		break;
 	default:
 		break;
@@ -386,7 +362,7 @@ void PHY_SetBWMode8188E(struct adapter *Adapter, enum ht_channel_width Bandwidth
 	pHalData->nCur40MhzPrimeSC = Offset;
 
 	if ((!Adapter->bDriverStopped) && (!Adapter->bSurpriseRemoved))
-		_PHY_SetBWMode92C(Adapter);
+		phy_set_bw_mode_callback(Adapter);
 	else
 		pHalData->CurrentChannelBW = tmpBW;
 }
-- 
1.7.10.4

