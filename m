Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbaHaIjQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 04:39:16 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:45359 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaHaIi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 04:38:59 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 4/9] staging: rtl8188eu: Rework function rtl8188e_PHY_RF6052SetOFDMTxPower()
Date: Sun, 31 Aug 2014 14:08:24 +0530
Message-Id: <1409474309-24362-4-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409474309-24362-1-git-send-email-navin.patidar@gmail.com>
References: <1409474309-24362-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CamelCase variables and function name.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/phy.c             |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c |   61 +++++++----------------
 drivers/staging/rtl8188eu/include/rf.h          |    4 ++
 drivers/staging/rtl8188eu/include/rtl8188e_rf.h |    2 -
 4 files changed, 22 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/phy.c b/drivers/staging/rtl8188eu/hal/phy.c
index a918dfa..7291b46 100644
--- a/drivers/staging/rtl8188eu/hal/phy.c
+++ b/drivers/staging/rtl8188eu/hal/phy.c
@@ -238,7 +238,7 @@ void phy_set_tx_power_level(struct adapter *adapt, u8 channel)
 			      &bw20_pwr[0], &bw40_pwr[0]);
 
 	rtl88eu_phy_rf6052_set_cck_txpower(adapt, &cck_pwr[0]);
-	rtl8188e_PHY_RF6052SetOFDMTxPower(adapt, &ofdm_pwr[0], &bw20_pwr[0],
+	rtl88eu_phy_rf6052_set_ofdm_txpower(adapt, &ofdm_pwr[0], &bw20_pwr[0],
 					  &bw40_pwr[0], channel);
 }
 
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c b/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
index 6a1731c..d63529b 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
@@ -305,60 +305,33 @@ static void writeOFDMPowerReg88E(struct adapter *Adapter, u8 index, u32 *pValue)
 	}
 }
 
-/*-----------------------------------------------------------------------------
- * Function:	PHY_RF6052SetOFDMTxPower
- *
- * Overview:	For legacy and HY OFDM, we must read EEPROM TX power index for
- *			different channel and read original value in TX power register area from
- *			0xe00. We increase offset and original value to be correct tx pwr.
- *
- * Input:       NONE
- *
- * Output:      NONE
- *
- * Return:      NONE
- *
- * Revised History:
- * When			Who		Remark
- * 11/05/2008	MHC		Simulate 8192 series method.
- * 01/06/2009	MHC		1. Prevent Path B tx power overflow or underflow dure to
- *						A/B pwr difference or legacy/HT pwr diff.
- *						2. We concern with path B legacy/HT OFDM difference.
- * 01/22/2009	MHC		Support new EPRO format from SD3.
- *
- *---------------------------------------------------------------------------*/
-
-void
-rtl8188e_PHY_RF6052SetOFDMTxPower(
-		struct adapter *Adapter,
-		u8 *pPowerLevelOFDM,
-		u8 *pPowerLevelBW20,
-		u8 *pPowerLevelBW40,
-		u8 Channel)
+void rtl88eu_phy_rf6052_set_ofdm_txpower(struct adapter *adapt,
+					 u8 *pwr_level_ofdm,
+					 u8 *pwr_level_bw20,
+					 u8 *pwr_level_bw40, u8 channel)
 {
-	struct hal_data_8188e *pHalData = GET_HAL_DATA(Adapter);
-	u32 writeVal[2], powerBase0[2], powerBase1[2], pwrtrac_value;
+	struct hal_data_8188e *hal_data = GET_HAL_DATA(adapt);
+	u32 write_val[2], powerbase0[2], powerbase1[2], pwrtrac_value;
 	u8 direction;
 	u8 index = 0;
 
-	getpowerbase88e(Adapter, pPowerLevelOFDM, pPowerLevelBW20, pPowerLevelBW40, Channel, &powerBase0[0], &powerBase1[0]);
+	getpowerbase88e(adapt, pwr_level_ofdm, pwr_level_bw20, pwr_level_bw40,
+			channel, &powerbase0[0], &powerbase1[0]);
 
-	/*  2012/04/23 MH According to power tracking value, we need to revise OFDM tx power. */
-	/*  This is ued to fix unstable power tracking mode. */
-	ODM_TxPwrTrackAdjust88E(&pHalData->odmpriv, 0, &direction, &pwrtrac_value);
+	ODM_TxPwrTrackAdjust88E(&hal_data->odmpriv, 0, &direction, &pwrtrac_value);
 
 	for (index = 0; index < 6; index++) {
-		get_rx_power_val_by_reg(Adapter, Channel, index,
-					&powerBase0[0], &powerBase1[0],
-					&writeVal[0]);
+		get_rx_power_val_by_reg(adapt, channel, index,
+					&powerbase0[0], &powerbase1[0],
+					&write_val[0]);
 
 		if (direction == 1) {
-			writeVal[0] += pwrtrac_value;
-			writeVal[1] += pwrtrac_value;
+			write_val[0] += pwrtrac_value;
+			write_val[1] += pwrtrac_value;
 		} else if (direction == 2) {
-			writeVal[0] -= pwrtrac_value;
-			writeVal[1] -= pwrtrac_value;
+			write_val[0] -= pwrtrac_value;
+			write_val[1] -= pwrtrac_value;
 		}
-		writeOFDMPowerReg88E(Adapter, index, &writeVal[0]);
+		writeOFDMPowerReg88E(adapt, index, &write_val[0]);
 	}
 }
diff --git a/drivers/staging/rtl8188eu/include/rf.h b/drivers/staging/rtl8188eu/include/rf.h
index 82bd076..3b97ee3 100644
--- a/drivers/staging/rtl8188eu/include/rf.h
+++ b/drivers/staging/rtl8188eu/include/rf.h
@@ -2,3 +2,7 @@ void rtl88eu_phy_rf6052_set_bandwidth(struct adapter *adapt,
 				      enum ht_channel_width bandwidth);
 void rtl88eu_phy_rf6052_set_cck_txpower(struct adapter *adapt,
 				       u8 *powerlevel);
+void rtl88eu_phy_rf6052_set_ofdm_txpower(struct adapter *adapt,
+					 u8 *powerlevel_ofdm,
+					 u8 *powerlevel_bw20,
+					 u8 *powerlevel_bw40, u8 channel);
diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_rf.h b/drivers/staging/rtl8188eu/include/rtl8188e_rf.h
index 22a70d0..445f123 100644
--- a/drivers/staging/rtl8188eu/include/rtl8188e_rf.h
+++ b/drivers/staging/rtl8188eu/include/rtl8188e_rf.h
@@ -28,7 +28,5 @@
 void rtl8188e_RF_ChangeTxPath(struct adapter *Adapter, u16 DataRate);
 void rtl8188e_PHY_RF6052SetBandwidth(struct adapter *Adapter,
 				     enum ht_channel_width Bandwidth);
-void	rtl8188e_PHY_RF6052SetOFDMTxPower(struct adapter *Adapter, u8 *ofdm,
-					  u8 *pwrbw20, u8 *pwrbw40, u8 channel);
 
 #endif/* __RTL8188E_RF_H__ */
-- 
1.7.10.4

