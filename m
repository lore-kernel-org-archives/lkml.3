Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbaDALkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:40:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42602 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbaDALST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:18:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 104/144] iwlwifi: disable TX AMPDU by default for iwldvm
Date: Tue,  1 Apr 2014 12:15:08 +0100
Message-Id: <1396350948-29910-105-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 205e2210daa975d92ace485a65a31ccc4077fe1a upstream.

NICs supported by iwldvm don't handle well TX AMPDU.
Disable it by default, still leave the possibility to
the user to force enable it with a debug parameter.

NICs supported by iwlmvm don't suffer from the same issue,
leave TX AMPDU enabled by default for these.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c  | 22 ++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-drv.c       |  2 +-
 drivers/net/wireless/iwlwifi/iwl-modparams.h | 11 +++++++----
 drivers/net/wireless/iwlwifi/mvm/mac80211.c  | 22 ++++++++++++++++++++--
 4 files changed, 48 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index 3193872..63c67bb 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -748,6 +748,24 @@ static int iwlagn_mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	return ret;
 }
 
+static inline bool iwl_enable_rx_ampdu(const struct iwl_cfg *cfg)
+{
+	if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_RXAGG)
+		return false;
+	return true;
+}
+
+static inline bool iwl_enable_tx_ampdu(const struct iwl_cfg *cfg)
+{
+	if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_TXAGG)
+		return false;
+	if (iwlwifi_mod_params.disable_11n & IWL_ENABLE_HT_TXAGG)
+		return true;
+
+	/* disabled by default */
+	return false;
+}
+
 static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif,
 				   enum ieee80211_ampdu_mlme_action action,
@@ -769,7 +787,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
-		if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_RXAGG)
+		if (!iwl_enable_rx_ampdu(priv->cfg))
 			break;
 		IWL_DEBUG_HT(priv, "start Rx\n");
 		ret = iwl_sta_rx_agg_start(priv, sta, tid, *ssn);
@@ -781,7 +799,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_TX_START:
 		if (!priv->trans->ops->txq_enable)
 			break;
-		if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_TXAGG)
+		if (!iwl_enable_tx_ampdu(priv->cfg))
 			break;
 		IWL_DEBUG_HT(priv, "start Tx\n");
 		ret = iwlagn_tx_agg_start(priv, vif, sta, tid, ssn);
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index d0162d4..b2a7552 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -1208,7 +1208,7 @@ module_param_named(swcrypto, iwlwifi_mod_params.sw_crypto, int, S_IRUGO);
 MODULE_PARM_DESC(swcrypto, "using crypto in software (default 0 [hardware])");
 module_param_named(11n_disable, iwlwifi_mod_params.disable_11n, uint, S_IRUGO);
 MODULE_PARM_DESC(11n_disable,
-	"disable 11n functionality, bitmap: 1: full, 2: agg TX, 4: agg RX");
+	"disable 11n functionality, bitmap: 1: full, 2: disable agg TX, 4: disable agg RX, 8 enable agg TX");
 module_param_named(amsdu_size_8K, iwlwifi_mod_params.amsdu_size_8K,
 		   int, S_IRUGO);
 MODULE_PARM_DESC(amsdu_size_8K, "enable 8K amsdu size (default 0)");
diff --git a/drivers/net/wireless/iwlwifi/iwl-modparams.h b/drivers/net/wireless/iwlwifi/iwl-modparams.h
index a1f580c..4c6cff4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-modparams.h
+++ b/drivers/net/wireless/iwlwifi/iwl-modparams.h
@@ -79,9 +79,12 @@ enum iwl_power_level {
 	IWL_POWER_NUM
 };
 
-#define IWL_DISABLE_HT_ALL	BIT(0)
-#define IWL_DISABLE_HT_TXAGG	BIT(1)
-#define IWL_DISABLE_HT_RXAGG	BIT(2)
+enum iwl_disable_11n {
+	IWL_DISABLE_HT_ALL	 = BIT(0),
+	IWL_DISABLE_HT_TXAGG	 = BIT(1),
+	IWL_DISABLE_HT_RXAGG	 = BIT(2),
+	IWL_ENABLE_HT_TXAGG	 = BIT(3),
+};
 
 /**
  * struct iwl_mod_params
@@ -90,7 +93,7 @@ enum iwl_power_level {
  *
  * @sw_crypto: using hardware encryption, default = 0
  * @disable_11n: disable 11n capabilities, default = 0,
- *	use IWL_DISABLE_HT_* constants
+ *	use IWL_[DIS,EN]ABLE_HT_* constants
  * @amsdu_size_8K: enable 8K amsdu size, default = 0
  * @restart_fw: restart firmware, default = 1
  * @wd_disable: enable stuck queue check, default = 0
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index f19baf0..ae9a593 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -292,6 +292,24 @@ static void iwl_mvm_mac_tx(struct ieee80211_hw *hw,
 	ieee80211_free_txskb(hw, skb);
 }
 
+static inline bool iwl_enable_rx_ampdu(const struct iwl_cfg *cfg)
+{
+	if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_RXAGG)
+		return false;
+	return true;
+}
+
+static inline bool iwl_enable_tx_ampdu(const struct iwl_cfg *cfg)
+{
+	if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_TXAGG)
+		return false;
+	if (iwlwifi_mod_params.disable_11n & IWL_ENABLE_HT_TXAGG)
+		return true;
+
+	/* enabled by default */
+	return true;
+}
+
 static int iwl_mvm_mac_ampdu_action(struct ieee80211_hw *hw,
 				    struct ieee80211_vif *vif,
 				    enum ieee80211_ampdu_mlme_action action,
@@ -311,7 +329,7 @@ static int iwl_mvm_mac_ampdu_action(struct ieee80211_hw *hw,
 
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
-		if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_RXAGG) {
+		if (!iwl_enable_rx_ampdu(mvm->cfg)) {
 			ret = -EINVAL;
 			break;
 		}
@@ -321,7 +339,7 @@ static int iwl_mvm_mac_ampdu_action(struct ieee80211_hw *hw,
 		ret = iwl_mvm_sta_rx_agg(mvm, sta, tid, 0, false);
 		break;
 	case IEEE80211_AMPDU_TX_START:
-		if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_TXAGG) {
+		if (!iwl_enable_tx_ampdu(mvm->cfg)) {
 			ret = -EINVAL;
 			break;
 		}
-- 
1.9.1

