Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933240Ab3GKOhh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:37:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43167 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932976Ab3GKO0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:26:45 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 70/98] ath9k_hw: Assign default xlna config for AR9485
Date: Thu, 11 Jul 2013 15:24:40 +0100
Message-Id: <1373552708-15235-71-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

commit 30d5b709da23f4ab9836c7f66d2d2e780a69cf12 upstream.

For AR9485 boards with XLNA, the default gpio config
is not set correctly, fix this.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 8 ++++++--
 drivers/net/wireless/ath/ath9k/ar9003_phy.h    | 2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index dfb0441..535c2b1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3578,7 +3578,7 @@ static u16 ar9003_hw_ant_ctrl_chain_get(struct ath_hw *ah,
 static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 {
 	int chain;
-	u32 regval;
+	u32 regval, value;
 	u32 ant_div_ctl1;
 	static const u32 switch_chain_reg[AR9300_MAX_CHAINS] = {
 			AR_PHY_SWITCH_CHAIN_0,
@@ -3586,7 +3586,11 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 			AR_PHY_SWITCH_CHAIN_2,
 	};
 
-	u32 value = ar9003_hw_ant_ctrl_common_get(ah, is2ghz);
+	if (AR_SREV_9485(ah) && (ar9003_hw_get_rx_gain_idx(ah) == 0))
+		ath9k_hw_cfg_output(ah, AR9300_EXT_LNA_CTL_GPIO_AR9485,
+				    AR_GPIO_OUTPUT_MUX_AS_PCIE_ATTENTION_LED);
+
+	value = ar9003_hw_ant_ctrl_common_get(ah, is2ghz);
 
 	if (AR_SREV_9462(ah)) {
 		REG_RMW_FIELD(ah, AR_PHY_SWITCH_COM,
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 7268a48..230f869 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -339,6 +339,8 @@
 
 #define AR_PHY_CCA_NOM_VAL_9330_2GHZ          -118
 
+#define AR9300_EXT_LNA_CTL_GPIO_AR9485 9
+
 /*
  * AGC Field Definitions
  */
-- 
1.8.1.2

