Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbaHaIjN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 04:39:13 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:58825 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaHaIjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 04:39:06 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 5/9] staging: rtl8188eu: Rework function writeOFDMPowerReg88E()
Date: Sun, 31 Aug 2014 14:08:25 +0530
Message-Id: <1409474309-24362-5-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409474309-24362-1-git-send-email-navin.patidar@gmail.com>
References: <1409474309-24362-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CamelCase variables and function name.
Remove a block of the code which is executed only if RF type is T2R2 but
rtl8188eu's RF is a T1R1 type, so driver doesn't need that code.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c |   50 +++++++----------------
 1 file changed, 15 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c b/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
index d63529b..7797b38 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188e_rf6052.c
@@ -253,55 +253,35 @@ static void get_rx_power_val_by_reg(struct adapter *Adapter, u8 Channel,
 		*(pOutWriteVal+rf) = writeVal;
 	}
 }
-static void writeOFDMPowerReg88E(struct adapter *Adapter, u8 index, u32 *pValue)
+
+static void write_ofdm_pwr_reg(struct adapter *adapt, u8 index, u32 *pvalue)
 {
-	struct hal_data_8188e *pHalData = GET_HAL_DATA(Adapter);
-	u16 regoffset_a[6] = {
-		rTxAGC_A_Rate18_06, rTxAGC_A_Rate54_24,
-		rTxAGC_A_Mcs03_Mcs00, rTxAGC_A_Mcs07_Mcs04,
-		rTxAGC_A_Mcs11_Mcs08, rTxAGC_A_Mcs15_Mcs12};
-	u16 regoffset_b[6] = {
-		rTxAGC_B_Rate18_06, rTxAGC_B_Rate54_24,
-		rTxAGC_B_Mcs03_Mcs00, rTxAGC_B_Mcs07_Mcs04,
-		rTxAGC_B_Mcs11_Mcs08, rTxAGC_B_Mcs15_Mcs12};
+	u16 regoffset_a[6] = { rTxAGC_A_Rate18_06, rTxAGC_A_Rate54_24,
+			       rTxAGC_A_Mcs03_Mcs00, rTxAGC_A_Mcs07_Mcs04,
+			       rTxAGC_A_Mcs11_Mcs08, rTxAGC_A_Mcs15_Mcs12 };
+	u16 regoffset_b[6] = { rTxAGC_B_Rate18_06, rTxAGC_B_Rate54_24,
+			       rTxAGC_B_Mcs03_Mcs00, rTxAGC_B_Mcs07_Mcs04,
+			       rTxAGC_B_Mcs11_Mcs08, rTxAGC_B_Mcs15_Mcs12 };
 	u8 i, rf, pwr_val[4];
-	u32 writeVal;
+	u32 write_val;
 	u16 regoffset;
 
 	for (rf = 0; rf < 2; rf++) {
-		writeVal = pValue[rf];
+		write_val = pvalue[rf];
 		for (i = 0; i < 4; i++) {
-			pwr_val[i] = (u8)((writeVal & (0x7f<<(i*8)))>>(i*8));
+			pwr_val[i] = (u8)((write_val & (0x7f<<(i*8)))>>(i*8));
 			if (pwr_val[i]  > RF6052_MAX_TX_PWR)
 				pwr_val[i]  = RF6052_MAX_TX_PWR;
 		}
-		writeVal = (pwr_val[3]<<24) | (pwr_val[2]<<16) | (pwr_val[1]<<8) | pwr_val[0];
+		write_val = (pwr_val[3]<<24) | (pwr_val[2]<<16) |
+			    (pwr_val[1]<<8) | pwr_val[0];
 
 		if (rf == 0)
 			regoffset = regoffset_a[index];
 		else
 			regoffset = regoffset_b[index];
 
-		phy_set_bb_reg(Adapter, regoffset, bMaskDWord, writeVal);
-
-		/*  201005115 Joseph: Set Tx Power diff for Tx power training mechanism. */
-		if (((pHalData->rf_type == RF_2T2R) &&
-		     (regoffset == rTxAGC_A_Mcs15_Mcs12 || regoffset == rTxAGC_B_Mcs15_Mcs12)) ||
-		    ((pHalData->rf_type != RF_2T2R) &&
-		     (regoffset == rTxAGC_A_Mcs07_Mcs04 || regoffset == rTxAGC_B_Mcs07_Mcs04))) {
-			writeVal = pwr_val[3];
-			if (regoffset == rTxAGC_A_Mcs15_Mcs12 || regoffset == rTxAGC_A_Mcs07_Mcs04)
-				regoffset = 0xc90;
-			if (regoffset == rTxAGC_B_Mcs15_Mcs12 || regoffset == rTxAGC_B_Mcs07_Mcs04)
-				regoffset = 0xc98;
-			for (i = 0; i < 3; i++) {
-				if (i != 2)
-					writeVal = (writeVal > 8) ? (writeVal-8) : 0;
-				else
-					writeVal = (writeVal > 6) ? (writeVal-6) : 0;
-				usb_write8(Adapter, (u32)(regoffset+i), (u8)writeVal);
-			}
-		}
+		phy_set_bb_reg(adapt, regoffset, bMaskDWord, write_val);
 	}
 }
 
@@ -332,6 +312,6 @@ void rtl88eu_phy_rf6052_set_ofdm_txpower(struct adapter *adapt,
 			write_val[0] -= pwrtrac_value;
 			write_val[1] -= pwrtrac_value;
 		}
-		writeOFDMPowerReg88E(adapt, index, &write_val[0]);
+		write_ofdm_pwr_reg(adapt, index, &write_val[0]);
 	}
 }
-- 
1.7.10.4

