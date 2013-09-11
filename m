Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab3IKE3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:29:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7273 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab3IKE3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:29:00 -0400
X-Authority-Analysis: v=2.0 cv=R/aB6KtX c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=87s40ppL47gA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Ze9momzLAUEA:10 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=vmLDa1wCAAAA:8 a=O4hWxVBIvsPn1Sn08iQA:9 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042855.437244622@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:27:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [020/251] ath9k_hw: Assign default xlna config for AR9485
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0020-ath9k_hw-Assign-default-xlna-config-for-AR9485.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

[ Upstream commit 30d5b709da23f4ab9836c7f66d2d2e780a69cf12 ]

For AR9485 boards with XLNA, the default gpio config
is not set correctly, fix this.

Cc: stable@vger.kernel.org
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    8 ++++++--
 drivers/net/wireless/ath/ath9k/ar9003_phy.h    |    2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index d066f25..e8e3929 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3562,7 +3562,7 @@ static u16 ar9003_hw_ant_ctrl_chain_get(struct ath_hw *ah, int chain,
 static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 {
 	int chain;
-	u32 regval;
+	u32 regval, value;
 	u32 ant_div_ctl1;
 	static const u32 switch_chain_reg[AR9300_MAX_CHAINS] = {
 			AR_PHY_SWITCH_CHAIN_0,
@@ -3570,7 +3570,11 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
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
index 84d3d49..3dead81 100644
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
1.7.10.4


