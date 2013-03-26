Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab3CZRy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:54:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12154 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab3CZRgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:15 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=3dcJXnRxQPYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=wffjaLXMhXgA:10 a=Q-fNiiVtAAAA:8 a=J1Y8HTJGAAAA:8 a=Y3BqsesFQtT865wjlaoA:9 a=lcTMV_K9oDIA:10 a=4N9Db7Z2_RYA:10 a=TrEL0cNkpSv0VGY-:21 a=dll4yOP598Hua-rB:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173605.530721648@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 35/86] tg3: Fix crc errors on jumbo frame receive
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0035-tg3-Fix-crc-errors-on-jumbo-frame-receive.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Nithin Nayak Sujir <nsujir@broadcom.com>

[ Upstream commit daf3ec688e057f6060fb9bb0819feac7a8bbf45c ]

TG3_PHY_AUXCTL_SMDSP_ENABLE/DISABLE macros do a blind write to the phy
auxiliary control register and overwrite the EXT_PKT_LEN (bit 14) resulting
in intermittent crc errors on jumbo frames with some link partners. Change
the code to do a read/modify/write.

Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/ethernet/broadcom/tg3.c |   58 +++++++++++++++++++++--------------
 1 file changed, 35 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 5c2bae8..3756278 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -1245,14 +1245,26 @@ static int tg3_phy_auxctl_write(struct tg3 *tp, int reg, u32 set)
 	return tg3_writephy(tp, MII_TG3_AUX_CTRL, set | reg);
 }
 
-#define TG3_PHY_AUXCTL_SMDSP_ENABLE(tp) \
-	tg3_phy_auxctl_write((tp), MII_TG3_AUXCTL_SHDWSEL_AUXCTL, \
-			     MII_TG3_AUXCTL_ACTL_SMDSP_ENA | \
-			     MII_TG3_AUXCTL_ACTL_TX_6DB)
+static int tg3_phy_toggle_auxctl_smdsp(struct tg3 *tp, bool enable)
+{
+	u32 val;
+	int err;
+
+	err = tg3_phy_auxctl_read(tp, MII_TG3_AUXCTL_SHDWSEL_AUXCTL, &val);
 
-#define TG3_PHY_AUXCTL_SMDSP_DISABLE(tp) \
-	tg3_phy_auxctl_write((tp), MII_TG3_AUXCTL_SHDWSEL_AUXCTL, \
-			     MII_TG3_AUXCTL_ACTL_TX_6DB);
+	if (err)
+		return err;
+	if (enable)
+
+		val |= MII_TG3_AUXCTL_ACTL_SMDSP_ENA;
+	else
+		val &= ~MII_TG3_AUXCTL_ACTL_SMDSP_ENA;
+
+	err = tg3_phy_auxctl_write((tp), MII_TG3_AUXCTL_SHDWSEL_AUXCTL,
+				   val | MII_TG3_AUXCTL_ACTL_TX_6DB);
+
+	return err;
+}
 
 static int tg3_bmcr_reset(struct tg3 *tp)
 {
@@ -2185,7 +2197,7 @@ static void tg3_phy_apply_otp(struct tg3 *tp)
 
 	otp = tp->phy_otp;
 
-	if (TG3_PHY_AUXCTL_SMDSP_ENABLE(tp))
+	if (tg3_phy_toggle_auxctl_smdsp(tp, true))
 		return;
 
 	phy = ((otp & TG3_OTP_AGCTGT_MASK) >> TG3_OTP_AGCTGT_SHIFT);
@@ -2210,7 +2222,7 @@ static void tg3_phy_apply_otp(struct tg3 *tp)
 	      ((otp & TG3_OTP_RCOFF_MASK) >> TG3_OTP_RCOFF_SHIFT);
 	tg3_phydsp_write(tp, MII_TG3_DSP_EXP97, phy);
 
-	TG3_PHY_AUXCTL_SMDSP_DISABLE(tp);
+	tg3_phy_toggle_auxctl_smdsp(tp, false);
 }
 
 static void tg3_phy_eee_adjust(struct tg3 *tp, u32 current_link_up)
@@ -2246,9 +2258,9 @@ static void tg3_phy_eee_adjust(struct tg3 *tp, u32 current_link_up)
 
 	if (!tp->setlpicnt) {
 		if (current_link_up == 1 &&
-		   !TG3_PHY_AUXCTL_SMDSP_ENABLE(tp)) {
+		   !tg3_phy_toggle_auxctl_smdsp(tp, true)) {
 			tg3_phydsp_write(tp, MII_TG3_DSP_TAP26, 0x0000);
-			TG3_PHY_AUXCTL_SMDSP_DISABLE(tp);
+			tg3_phy_toggle_auxctl_smdsp(tp, false);
 		}
 
 		val = tr32(TG3_CPMU_EEE_MODE);
@@ -2264,11 +2276,11 @@ static void tg3_phy_eee_enable(struct tg3 *tp)
 	    (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5717 ||
 	     GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5719 ||
 	     tg3_flag(tp, 57765_CLASS)) &&
-	    !TG3_PHY_AUXCTL_SMDSP_ENABLE(tp)) {
+	    !tg3_phy_toggle_auxctl_smdsp(tp, true)) {
 		val = MII_TG3_DSP_TAP26_ALNOKO |
 		      MII_TG3_DSP_TAP26_RMRXSTO;
 		tg3_phydsp_write(tp, MII_TG3_DSP_TAP26, val);
-		TG3_PHY_AUXCTL_SMDSP_DISABLE(tp);
+		tg3_phy_toggle_auxctl_smdsp(tp, false);
 	}
 
 	val = tr32(TG3_CPMU_EEE_MODE);
@@ -2412,7 +2424,7 @@ static int tg3_phy_reset_5703_4_5(struct tg3 *tp)
 		tg3_writephy(tp, MII_CTRL1000,
 			     CTL1000_AS_MASTER | CTL1000_ENABLE_MASTER);
 
-		err = TG3_PHY_AUXCTL_SMDSP_ENABLE(tp);
+		err = tg3_phy_toggle_auxctl_smdsp(tp, true);
 		if (err)
 			return err;
 
@@ -2433,7 +2445,7 @@ static int tg3_phy_reset_5703_4_5(struct tg3 *tp)
 	tg3_writephy(tp, MII_TG3_DSP_ADDRESS, 0x8200);
 	tg3_writephy(tp, MII_TG3_DSP_CONTROL, 0x0000);
 
-	TG3_PHY_AUXCTL_SMDSP_DISABLE(tp);
+	tg3_phy_toggle_auxctl_smdsp(tp, false);
 
 	tg3_writephy(tp, MII_CTRL1000, phy9_orig);
 
@@ -2522,10 +2534,10 @@ static int tg3_phy_reset(struct tg3 *tp)
 
 out:
 	if ((tp->phy_flags & TG3_PHYFLG_ADC_BUG) &&
-	    !TG3_PHY_AUXCTL_SMDSP_ENABLE(tp)) {
+	    !tg3_phy_toggle_auxctl_smdsp(tp, true)) {
 		tg3_phydsp_write(tp, 0x201f, 0x2aaa);
 		tg3_phydsp_write(tp, 0x000a, 0x0323);
-		TG3_PHY_AUXCTL_SMDSP_DISABLE(tp);
+		tg3_phy_toggle_auxctl_smdsp(tp, false);
 	}
 
 	if (tp->phy_flags & TG3_PHYFLG_5704_A0_BUG) {
@@ -2534,14 +2546,14 @@ out:
 	}
 
 	if (tp->phy_flags & TG3_PHYFLG_BER_BUG) {
-		if (!TG3_PHY_AUXCTL_SMDSP_ENABLE(tp)) {
+		if (!tg3_phy_toggle_auxctl_smdsp(tp, true)) {
 			tg3_phydsp_write(tp, 0x000a, 0x310b);
 			tg3_phydsp_write(tp, 0x201f, 0x9506);
 			tg3_phydsp_write(tp, 0x401f, 0x14e2);
-			TG3_PHY_AUXCTL_SMDSP_DISABLE(tp);
+			tg3_phy_toggle_auxctl_smdsp(tp, false);
 		}
 	} else if (tp->phy_flags & TG3_PHYFLG_JITTER_BUG) {
-		if (!TG3_PHY_AUXCTL_SMDSP_ENABLE(tp)) {
+		if (!tg3_phy_toggle_auxctl_smdsp(tp, true)) {
 			tg3_writephy(tp, MII_TG3_DSP_ADDRESS, 0x000a);
 			if (tp->phy_flags & TG3_PHYFLG_ADJUST_TRIM) {
 				tg3_writephy(tp, MII_TG3_DSP_RW_PORT, 0x110b);
@@ -2550,7 +2562,7 @@ out:
 			} else
 				tg3_writephy(tp, MII_TG3_DSP_RW_PORT, 0x010b);
 
-			TG3_PHY_AUXCTL_SMDSP_DISABLE(tp);
+			tg3_phy_toggle_auxctl_smdsp(tp, false);
 		}
 	}
 
@@ -3967,7 +3979,7 @@ static int tg3_phy_autoneg_cfg(struct tg3 *tp, u32 advertise, u32 flowctrl)
 	tw32(TG3_CPMU_EEE_MODE,
 	     tr32(TG3_CPMU_EEE_MODE) & ~TG3_CPMU_EEEMD_LPI_ENABLE);
 
-	err = TG3_PHY_AUXCTL_SMDSP_ENABLE(tp);
+	err = tg3_phy_toggle_auxctl_smdsp(tp, true);
 	if (!err) {
 		u32 err2;
 
@@ -4000,7 +4012,7 @@ static int tg3_phy_autoneg_cfg(struct tg3 *tp, u32 advertise, u32 flowctrl)
 						 MII_TG3_DSP_CH34TP2_HIBW01);
 		}
 
-		err2 = TG3_PHY_AUXCTL_SMDSP_DISABLE(tp);
+		err2 = tg3_phy_toggle_auxctl_smdsp(tp, false);
 		if (!err)
 			err = err2;
 	}
-- 
1.7.10.4


