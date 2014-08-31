Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275AbaHaIi5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 04:38:57 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:64589 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaHaIip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 04:38:45 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 2/9] staging: rtl8188eu: Rework function rtl8188e_PHY_RF6052SetCckTxPower()
Date: Sun, 31 Aug 2014 14:08:22 +0530
Message-Id: <1409474309-24362-2-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409474309-24362-1-git-send-email-navin.patidar@gmail.com>
References: <1409474309-24362-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CamelCase variables and function name.
Remove redundant variable TurboScanOff.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/phy.c             |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c |  124 ++++++++---------------
 drivers/staging/rtl8188eu/include/rf.h          |    2 +
 drivers/staging/rtl8188eu/include/rtl8188e_rf.h |    1 -
 4 files changed, 48 insertions(+), 81 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/phy.c b/drivers/staging/rtl8188eu/hal/phy.c
index b67b91e..a918dfa 100644
--- a/drivers/staging/rtl8188eu/hal/phy.c
+++ b/drivers/staging/rtl8188eu/hal/phy.c
@@ -237,7 +237,7 @@ void phy_set_tx_power_level(struct adapter *adapt, u8 channel)
 	phy_power_index_check(adapt, channel, &cck_pwr[0], &ofdm_pwr[0],
 			      &bw20_pwr[0], &bw40_pwr[0]);
 
-	rtl8188e_PHY_RF6052SetCckTxPower(adapt, &cck_pwr[0]);
+	rtl88eu_phy_rf6052_set_cck_txpower(adapt, &cck_pwr[0]);
 	rtl8188e_PHY_RF6052SetOFDMTxPower(adapt, &ofdm_pwr[0], &bw20_pwr[0],
 					  &bw40_pwr[0], channel);
 }
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c b/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
index bd90068..8959ac3 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
@@ -45,119 +45,85 @@ void rtl88eu_phy_rf6052_set_bandwidth(struct adapter *adapt,
 	}
 }
 
-/*-----------------------------------------------------------------------------
- * Function:	PHY_RF6052SetCckTxPower
- *
- * Overview:
- *
- * Input:       NONE
- *
- * Output:      NONE
- *
- * Return:      NONE
- *
- * Revised History:
- * When			Who		Remark
- * 11/05/2008	MHC		Simulate 8192series..
- *
- *---------------------------------------------------------------------------*/
-
-void
-rtl8188e_PHY_RF6052SetCckTxPower(
-		struct adapter *Adapter,
-		u8 *pPowerlevel)
+void rtl88eu_phy_rf6052_set_cck_txpower(struct adapter *adapt, u8 *powerlevel)
 {
-	struct hal_data_8188e *pHalData = GET_HAL_DATA(Adapter);
-	struct dm_priv *pdmpriv = &pHalData->dmpriv;
-	struct mlme_ext_priv *pmlmeext = &Adapter->mlmeextpriv;
-	u32 TxAGC[2] = {0, 0}, tmpval = 0, pwrtrac_value;
-	bool TurboScanOff = false;
+	struct hal_data_8188e *hal_data = GET_HAL_DATA(adapt);
+	struct dm_priv *pdmpriv = &hal_data->dmpriv;
+	struct mlme_ext_priv *pmlmeext = &adapt->mlmeextpriv;
+	u32 tx_agc[2] = {0, 0}, tmpval = 0, pwrtrac_value;
 	u8 idx1, idx2;
 	u8 *ptr;
 	u8 direction;
-	/* FOR CE ,must disable turbo scan */
-	TurboScanOff = true;
 
 
 	if (pmlmeext->sitesurvey_res.state == SCAN_PROCESS) {
-		TxAGC[RF_PATH_A] = 0x3f3f3f3f;
-		TxAGC[RF_PATH_B] = 0x3f3f3f3f;
-
-		TurboScanOff = true;/* disable turbo scan */
-
-		if (TurboScanOff) {
-			for (idx1 = RF_PATH_A; idx1 <= RF_PATH_B; idx1++) {
-				TxAGC[idx1] =
-					pPowerlevel[idx1] | (pPowerlevel[idx1]<<8) |
-					(pPowerlevel[idx1]<<16) | (pPowerlevel[idx1]<<24);
-				/*  2010/10/18 MH For external PA module. We need to limit power index to be less than 0x20. */
-				if (TxAGC[idx1] > 0x20 && pHalData->ExternalPA)
-					TxAGC[idx1] = 0x20;
-			}
+		tx_agc[RF_PATH_A] = 0x3f3f3f3f;
+		tx_agc[RF_PATH_B] = 0x3f3f3f3f;
+		for (idx1 = RF_PATH_A; idx1 <= RF_PATH_B; idx1++) {
+			tx_agc[idx1] = powerlevel[idx1] |
+				      (powerlevel[idx1]<<8) |
+				      (powerlevel[idx1]<<16) |
+				      (powerlevel[idx1]<<24);
+			if (tx_agc[idx1] > 0x20 && hal_data->ExternalPA)
+				tx_agc[idx1] = 0x20;
 		}
 	} else {
-		/* Driver dynamic Tx power shall not affect Tx power.
-		 * It shall be determined by power training mechanism.
-i		 *  Currently, we cannot fully disable driver dynamic
-		 * tx power mechanism because it is referenced by BT
-		 * coexist mechanism.
-		 * In the future, two mechanism shall be separated from
-		 * each other and maintained independently. */
 		if (pdmpriv->DynamicTxHighPowerLvl == TxHighPwrLevel_Level1) {
-			TxAGC[RF_PATH_A] = 0x10101010;
-			TxAGC[RF_PATH_B] = 0x10101010;
+			tx_agc[RF_PATH_A] = 0x10101010;
+			tx_agc[RF_PATH_B] = 0x10101010;
 		} else if (pdmpriv->DynamicTxHighPowerLvl == TxHighPwrLevel_Level2) {
-			TxAGC[RF_PATH_A] = 0x00000000;
-			TxAGC[RF_PATH_B] = 0x00000000;
+			tx_agc[RF_PATH_A] = 0x00000000;
+			tx_agc[RF_PATH_B] = 0x00000000;
 		} else {
 			for (idx1 = RF_PATH_A; idx1 <= RF_PATH_B; idx1++) {
-				TxAGC[idx1] =
-					pPowerlevel[idx1] | (pPowerlevel[idx1]<<8) |
-					(pPowerlevel[idx1]<<16) | (pPowerlevel[idx1]<<24);
+				tx_agc[idx1] = powerlevel[idx1] |
+					       (powerlevel[idx1]<<8) |
+					       (powerlevel[idx1]<<16) |
+					       (powerlevel[idx1]<<24);
 			}
-			if (pHalData->EEPROMRegulatory == 0) {
-				tmpval = (pHalData->MCSTxPowerLevelOriginalOffset[0][6]) +
-						(pHalData->MCSTxPowerLevelOriginalOffset[0][7]<<8);
-				TxAGC[RF_PATH_A] += tmpval;
-
-				tmpval = (pHalData->MCSTxPowerLevelOriginalOffset[0][14]) +
-						(pHalData->MCSTxPowerLevelOriginalOffset[0][15]<<24);
-				TxAGC[RF_PATH_B] += tmpval;
+			if (hal_data->EEPROMRegulatory == 0) {
+				tmpval = hal_data->MCSTxPowerLevelOriginalOffset[0][6] +
+					 (hal_data->MCSTxPowerLevelOriginalOffset[0][7]<<8);
+				tx_agc[RF_PATH_A] += tmpval;
+
+				tmpval = hal_data->MCSTxPowerLevelOriginalOffset[0][14] +
+					 (hal_data->MCSTxPowerLevelOriginalOffset[0][15]<<24);
+				tx_agc[RF_PATH_B] += tmpval;
 			}
 		}
 	}
 	for (idx1 = RF_PATH_A; idx1 <= RF_PATH_B; idx1++) {
-		ptr = (u8 *)(&(TxAGC[idx1]));
+		ptr = (u8 *)(&(tx_agc[idx1]));
 		for (idx2 = 0; idx2 < 4; idx2++) {
 			if (*ptr > RF6052_MAX_TX_PWR)
 				*ptr = RF6052_MAX_TX_PWR;
 			ptr++;
 		}
 	}
-	ODM_TxPwrTrackAdjust88E(&pHalData->odmpriv, 1, &direction, &pwrtrac_value);
+	ODM_TxPwrTrackAdjust88E(&hal_data->odmpriv, 1, &direction, &pwrtrac_value);
 
 	if (direction == 1) {
 		/*  Increase TX power */
-		TxAGC[0] += pwrtrac_value;
-		TxAGC[1] += pwrtrac_value;
+		tx_agc[0] += pwrtrac_value;
+		tx_agc[1] += pwrtrac_value;
 	} else if (direction == 2) {
 		/*  Decrease TX power */
-		TxAGC[0] -=  pwrtrac_value;
-		TxAGC[1] -=  pwrtrac_value;
+		tx_agc[0] -=  pwrtrac_value;
+		tx_agc[1] -=  pwrtrac_value;
 	}
 
 	/*  rf-A cck tx power */
-	tmpval = TxAGC[RF_PATH_A]&0xff;
-	phy_set_bb_reg(Adapter, rTxAGC_A_CCK1_Mcs32, bMaskByte1, tmpval);
-	tmpval = TxAGC[RF_PATH_A]>>8;
-	phy_set_bb_reg(Adapter, rTxAGC_B_CCK11_A_CCK2_11, 0xffffff00, tmpval);
+	tmpval = tx_agc[RF_PATH_A]&0xff;
+	phy_set_bb_reg(adapt, rTxAGC_A_CCK1_Mcs32, bMaskByte1, tmpval);
+	tmpval = tx_agc[RF_PATH_A]>>8;
+	phy_set_bb_reg(adapt, rTxAGC_B_CCK11_A_CCK2_11, 0xffffff00, tmpval);
 
 	/*  rf-B cck tx power */
-	tmpval = TxAGC[RF_PATH_B]>>24;
-	phy_set_bb_reg(Adapter, rTxAGC_B_CCK11_A_CCK2_11, bMaskByte0, tmpval);
-	tmpval = TxAGC[RF_PATH_B]&0x00ffffff;
-	phy_set_bb_reg(Adapter, rTxAGC_B_CCK1_55_Mcs32, 0xffffff00, tmpval);
-}	/* PHY_RF6052SetCckTxPower */
+	tmpval = tx_agc[RF_PATH_B]>>24;
+	phy_set_bb_reg(adapt, rTxAGC_B_CCK11_A_CCK2_11, bMaskByte0, tmpval);
+	tmpval = tx_agc[RF_PATH_B]&0x00ffffff;
+	phy_set_bb_reg(adapt, rTxAGC_B_CCK1_55_Mcs32, 0xffffff00, tmpval);
+}
 
 /*  */
 /*  powerbase0 for OFDM rates */
diff --git a/drivers/staging/rtl8188eu/include/rf.h b/drivers/staging/rtl8188eu/include/rf.h
index ca0d28d..82bd076 100644
--- a/drivers/staging/rtl8188eu/include/rf.h
+++ b/drivers/staging/rtl8188eu/include/rf.h
@@ -1,2 +1,4 @@
 void rtl88eu_phy_rf6052_set_bandwidth(struct adapter *adapt,
 				      enum ht_channel_width bandwidth);
+void rtl88eu_phy_rf6052_set_cck_txpower(struct adapter *adapt,
+				       u8 *powerlevel);
diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_rf.h b/drivers/staging/rtl8188eu/include/rtl8188e_rf.h
index 20b5ba0..22a70d0 100644
--- a/drivers/staging/rtl8188eu/include/rtl8188e_rf.h
+++ b/drivers/staging/rtl8188eu/include/rtl8188e_rf.h
@@ -28,7 +28,6 @@
 void rtl8188e_RF_ChangeTxPath(struct adapter *Adapter, u16 DataRate);
 void rtl8188e_PHY_RF6052SetBandwidth(struct adapter *Adapter,
 				     enum ht_channel_width Bandwidth);
-void	rtl8188e_PHY_RF6052SetCckTxPower(struct adapter *Adapter, u8 *level);
 void	rtl8188e_PHY_RF6052SetOFDMTxPower(struct adapter *Adapter, u8 *ofdm,
 					  u8 *pwrbw20, u8 *pwrbw40, u8 channel);
 
-- 
1.7.10.4

