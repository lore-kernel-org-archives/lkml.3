Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754Ab3BSSyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:54:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54517 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933268Ab3BSSyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:54:37 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 71/81] tg3: Fix crc errors on jumbo frame receive
Date: Tue, 19 Feb 2013 15:49:34 -0300
Message-Id: <1361299784-8830-72-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nithin Nayak Sujir <nsujir@broadcom.com>

commit daf3ec688e057f6060fb9bb0819feac7a8bbf45c upstream.

TG3_PHY_AUXCTL_SMDSP_ENABLE/DISABLE macros do a blind write to the phy
auxiliary control register and overwrite the EXT_PKT_LEN (bit 14) resulting
in intermittent crc errors on jumbo frames with some link partners. Change
the code to do a read/modify/write.

Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/ethernet/broadcom/tg3.c |   58 +++++++++++++++++++++--------------
 1 file changed, 35 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 82a8ed2..4da6a86 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -1136,14 +1136,26 @@ static int tg3_phy_auxctl_write(struct tg3 *tp, int reg, u32 set)
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
@@ -2076,7 +2088,7 @@ static void tg3_phy_apply_otp(struct tg3 *tp)
 
 	otp = tp->phy_otp;
 
-	if (TG3_PHY_AUXCTL_SMDSP_ENABLE(tp))
+	if (tg3_phy_toggle_auxctl_smdsp(tp, true))
 		return;
 
 	phy = ((otp & TG3_OTP_AGCTGT_MASK) >> TG3_OTP_AGCTGT_SHIFT);
@@ -2101,7 +2113,7 @@ static void tg3_phy_apply_otp(struct tg3 *tp)
 	      ((otp & TG3_OTP_RCOFF_MASK) >> TG3_OTP_RCOFF_SHIFT);
 	tg3_phydsp_write(tp, MII_TG3_DSP_EXP97, phy);
 
-	TG3_PHY_AUXCTL_SMDSP_DISABLE(tp);
+	tg3_phy_toggle_auxctl_smdsp(tp, false);
 }
 
 static void tg3_phy_eee_adjust(struct tg3 *tp, u32 current_link_up)
@@ -2137,9 +2149,9 @@ static void tg3_phy_eee_adjust(struct tg3 *tp, u32 current_link_up)
 
 	if (!tp->setlpicnt) {
 		if (current_link_up == 1 &&
-		   !TG3_PHY_AUXCTL_SMDSP_ENABLE(tp)) {
+		   !tg3_phy_toggle_auxctl_smdsp(tp, true)) {
 			tg3_phydsp_write(tp, MII_TG3_DSP_TAP26, 0x0000);
-			TG3_PHY_AUXCTL_SMDSP_DISABLE(tp);
+			tg3_phy_toggle_auxctl_smdsp(tp, false);
 		}
 
 		val = tr32(TG3_CPMU_EEE_MODE);
@@ -2155,11 +2167,11 @@ static void tg3_phy_eee_enable(struct tg3 *tp)
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
@@ -2303,7 +2315,7 @@ static int tg3_phy_reset_5703_4_5(struct tg3 *tp)
 		tg3_writephy(tp, MII_CTRL1000,
 			     CTL1000_AS_MASTER | CTL1000_ENABLE_MASTER);
 
-		err = TG3_PHY_AUXCTL_SMDSP_ENABLE(tp);
+		err = tg3_phy_toggle_auxctl_smdsp(tp, true);
 		if (err)
 			return err;
 
@@ -2324,7 +2336,7 @@ static int tg3_phy_reset_5703_4_5(struct tg3 *tp)
 	tg3_writephy(tp, MII_TG3_DSP_ADDRESS, 0x8200);
 	tg3_writephy(tp, MII_TG3_DSP_CONTROL, 0x0000);
 
-	TG3_PHY_AUXCTL_SMDSP_DISABLE(tp);
+	tg3_phy_toggle_auxctl_smdsp(tp, false);
 
 	tg3_writephy(tp, MII_CTRL1000, phy9_orig);
 
@@ -2413,10 +2425,10 @@ static int tg3_phy_reset(struct tg3 *tp)
 
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
@@ -2425,14 +2437,14 @@ out:
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
@@ -2441,7 +2453,7 @@ out:
 			} else
 				tg3_writephy(tp, MII_TG3_DSP_RW_PORT, 0x010b);
 
-			TG3_PHY_AUXCTL_SMDSP_DISABLE(tp);
+			tg3_phy_toggle_auxctl_smdsp(tp, false);
 		}
 	}
 
@@ -3858,7 +3870,7 @@ static int tg3_phy_autoneg_cfg(struct tg3 *tp, u32 advertise, u32 flowctrl)
 	tw32(TG3_CPMU_EEE_MODE,
 	     tr32(TG3_CPMU_EEE_MODE) & ~TG3_CPMU_EEEMD_LPI_ENABLE);
 
-	err = TG3_PHY_AUXCTL_SMDSP_ENABLE(tp);
+	err = tg3_phy_toggle_auxctl_smdsp(tp, true);
 	if (!err) {
 		u32 err2;
 
@@ -3891,7 +3903,7 @@ static int tg3_phy_autoneg_cfg(struct tg3 *tp, u32 advertise, u32 flowctrl)
 						 MII_TG3_DSP_CH34TP2_HIBW01);
 		}
 
-		err2 = TG3_PHY_AUXCTL_SMDSP_DISABLE(tp);
+		err2 = tg3_phy_toggle_auxctl_smdsp(tp, false);
 		if (!err)
 			err = err2;
 	}
-- 
1.7.9.5

