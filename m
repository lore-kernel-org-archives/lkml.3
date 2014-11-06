Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbaKFXVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:21:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58498 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaKFWic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:38:32 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 133/162] mac80211: add vif to flush call
Date: Thu,  6 Nov 2014 14:36:37 -0800
Message-Id: <1415313426-9622-134-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 77be2c54c5bd26279abc13807398771d80cda37a upstream.

This will allow the low level driver to make decision based
on the vif such as queues etc...
Since the vif might be NULL, we can't add it to the tracing
functions.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
[fix staging rtl8821ae driver]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ kamal: 3.13-stable prereq backport (omitted rtl8821ae) for
  a085505 iwlwifi: dvm: drop non VO frames when flushing ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/ath/ar5523/ar5523.c              | 3 ++-
 drivers/net/wireless/ath/ath10k/mac.c                 | 3 ++-
 drivers/net/wireless/ath/ath9k/main.c                 | 3 ++-
 drivers/net/wireless/ath/carl9170/main.c              | 4 +++-
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c | 3 ++-
 drivers/net/wireless/cw1200/sta.c                     | 3 ++-
 drivers/net/wireless/cw1200/sta.h                     | 3 ++-
 drivers/net/wireless/iwlegacy/common.c                | 3 ++-
 drivers/net/wireless/iwlegacy/common.h                | 3 ++-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c           | 3 ++-
 drivers/net/wireless/mac80211_hwsim.c                 | 4 +++-
 drivers/net/wireless/p54/main.c                       | 3 ++-
 drivers/net/wireless/rt2x00/rt2x00.h                  | 3 ++-
 drivers/net/wireless/rt2x00/rt2x00mac.c               | 3 ++-
 drivers/net/wireless/rtlwifi/core.c                   | 3 ++-
 drivers/net/wireless/ti/wlcore/main.c                 | 3 ++-
 include/net/mac80211.h                                | 4 +++-
 net/mac80211/driver-ops.h                             | 8 +++++++-
 net/mac80211/util.c                                   | 2 +-
 19 files changed, 45 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index 9cc2b91..5d219a4 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -1091,7 +1091,8 @@ static int ar5523_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 	return ret;
 }
 
-static void ar5523_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
+static void ar5523_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			 u32 queues, bool drop)
 {
 	struct ar5523 *ar = hw->priv;
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 97ac8c8..6f8e6ad 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2939,7 +2939,8 @@ static int ath10k_set_frag_threshold(struct ieee80211_hw *hw, u32 value)
 	return ret;
 }
 
-static void ath10k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
+static void ath10k_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			 u32 queues, bool drop)
 {
 	struct ath10k *ar = hw->priv;
 	bool skip;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 21aa09e..5db6849 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1818,7 +1818,8 @@ static void ath9k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
 	mutex_unlock(&sc->mutex);
 }
 
-static void ath9k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
+static void ath9k_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			u32 queues, bool drop)
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 349fa22..b795b18 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1708,7 +1708,9 @@ found:
 	return 0;
 }
 
-static void carl9170_op_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
+static void carl9170_op_flush(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif,
+			      u32 queues, bool drop)
 {
 	struct ar9170 *ar = hw->priv;
 	unsigned int vid;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index edc5d10..778f593 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -899,7 +899,8 @@ static bool brcms_tx_flush_completed(struct brcms_info *wl)
 	return result;
 }
 
-static void brcms_ops_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
+static void brcms_ops_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			    u32 queues, bool drop)
 {
 	struct brcms_info *wl = hw->priv;
 	int ret;
diff --git a/drivers/net/wireless/cw1200/sta.c b/drivers/net/wireless/cw1200/sta.c
index 010b252..949dc4e 100644
--- a/drivers/net/wireless/cw1200/sta.c
+++ b/drivers/net/wireless/cw1200/sta.c
@@ -935,7 +935,8 @@ static int __cw1200_flush(struct cw1200_common *priv, bool drop)
 	return ret;
 }
 
-void cw1200_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
+void cw1200_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		  u32 queues, bool drop)
 {
 	struct cw1200_common *priv = hw->priv;
 
diff --git a/drivers/net/wireless/cw1200/sta.h b/drivers/net/wireless/cw1200/sta.h
index 35babb6..b7e386b 100644
--- a/drivers/net/wireless/cw1200/sta.h
+++ b/drivers/net/wireless/cw1200/sta.h
@@ -40,7 +40,8 @@ int cw1200_set_key(struct ieee80211_hw *dev, enum set_key_cmd cmd,
 
 int cw1200_set_rts_threshold(struct ieee80211_hw *hw, u32 value);
 
-void cw1200_flush(struct ieee80211_hw *hw, u32 queues, bool drop);
+void cw1200_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		  u32 queues, bool drop);
 
 u64 cw1200_prepare_multicast(struct ieee80211_hw *hw,
 			     struct netdev_hw_addr_list *mc_list);
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index b03e22e..d9d22e5 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -4702,7 +4702,8 @@ out:
 }
 EXPORT_SYMBOL(il_mac_change_interface);
 
-void il_mac_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
+void il_mac_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		  u32 queues, bool drop)
 {
 	struct il_priv *il = hw->priv;
 	unsigned long timeout = jiffies + msecs_to_jiffies(500);
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index ad123d6..108e037 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1722,7 +1722,8 @@ void il_mac_remove_interface(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif);
 int il_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			    enum nl80211_iftype newtype, bool newp2p);
-void il_mac_flush(struct ieee80211_hw *hw, u32 queues, bool drop);
+void il_mac_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		  u32 queues, bool drop);
 int il_alloc_txq_mem(struct il_priv *il);
 void il_free_txq_mem(struct il_priv *il);
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index d6e6405..bf1107a 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -1099,7 +1099,8 @@ static void iwlagn_configure_filter(struct ieee80211_hw *hw,
 			FIF_BCN_PRBRESP_PROMISC | FIF_CONTROL;
 }
 
-static void iwlagn_mac_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
+static void iwlagn_mac_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			     u32 queues, bool drop)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index a1b32ee..1a0c2bb 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1466,7 +1466,9 @@ static int mac80211_hwsim_ampdu_action(struct ieee80211_hw *hw,
 	return 0;
 }
 
-static void mac80211_hwsim_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
+static void mac80211_hwsim_flush(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif,
+				 u32 queues, bool drop)
 {
 	/* Not implemented, queues only on kernel side */
 }
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 067e6f2..c214332 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -670,7 +670,8 @@ static unsigned int p54_flush_count(struct p54_common *priv)
 	return total;
 }
 
-static void p54_flush(struct ieee80211_hw *dev, u32 queues, bool drop)
+static void p54_flush(struct ieee80211_hw *dev, struct ieee80211_vif *vif,
+		      u32 queues, bool drop)
 {
 	struct p54_common *priv = dev->priv;
 	unsigned int total, i;
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index c06ffb7..6a64211 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -1451,7 +1451,8 @@ int rt2x00mac_conf_tx(struct ieee80211_hw *hw,
 		      struct ieee80211_vif *vif, u16 queue,
 		      const struct ieee80211_tx_queue_params *params);
 void rt2x00mac_rfkill_poll(struct ieee80211_hw *hw);
-void rt2x00mac_flush(struct ieee80211_hw *hw, u32 queues, bool drop);
+void rt2x00mac_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		     u32 queues, bool drop);
 int rt2x00mac_set_antenna(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant);
 int rt2x00mac_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant);
 void rt2x00mac_get_ringparam(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index bc21fae..04896fa 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -753,7 +753,8 @@ void rt2x00mac_rfkill_poll(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_rfkill_poll);
 
-void rt2x00mac_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
+void rt2x00mac_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		     u32 queues, bool drop)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct data_queue *queue;
diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index 2d337a0..2b16dfb 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -1309,7 +1309,8 @@ static void rtl_op_rfkill_poll(struct ieee80211_hw *hw)
  * before switch channel or power save, or tx buffer packet
  * maybe send after offchannel or rf sleep, this may cause
  * dis-association by AP */
-static void rtl_op_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
+static void rtl_op_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			 u32 queues, bool drop)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 0368b9c..8f63463 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5147,7 +5147,8 @@ out:
 	mutex_unlock(&wl->mutex);
 }
 
-static void wlcore_op_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
+static void wlcore_op_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			    u32 queues, bool drop)
 {
 	struct wl1271 *wl = hw->priv;
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7ceed99..3e95bff 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2546,6 +2546,7 @@ enum ieee80211_roc_type {
  *	of queues to flush, which is useful if different virtual interfaces
  *	use different hardware queues; it may also indicate all queues.
  *	If the parameter @drop is set to %true, pending frames may be dropped.
+ *	Note that vif can be NULL.
  *	The callback can sleep.
  *
  * @channel_switch: Drivers that need (or want) to offload the channel
@@ -2809,7 +2810,8 @@ struct ieee80211_ops {
 			     struct netlink_callback *cb,
 			     void *data, int len);
 #endif
-	void (*flush)(struct ieee80211_hw *hw, u32 queues, bool drop);
+	void (*flush)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		      u32 queues, bool drop);
 	void (*channel_switch)(struct ieee80211_hw *hw,
 			       struct ieee80211_channel_switch *ch_switch);
 	int (*napi_poll)(struct ieee80211_hw *hw, int budget);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 5d03c47..8f12800 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -722,13 +722,19 @@ static inline void drv_rfkill_poll(struct ieee80211_local *local)
 }
 
 static inline void drv_flush(struct ieee80211_local *local,
+			     struct ieee80211_sub_if_data *sdata,
 			     u32 queues, bool drop)
 {
+	struct ieee80211_vif *vif = sdata ? &sdata->vif : NULL;
+
 	might_sleep();
 
+	if (sdata)
+		check_sdata_in_driver(sdata);
+
 	trace_drv_flush(local, queues, drop);
 	if (local->ops->flush)
-		local->ops->flush(&local->hw, queues, drop);
+		local->ops->flush(&local->hw, vif, queues, drop);
 	trace_drv_return_void(local);
 }
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 9f9b9bd..32cbc9e 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -558,7 +558,7 @@ void ieee80211_flush_queues(struct ieee80211_local *local,
 	ieee80211_stop_queues_by_reason(&local->hw, IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_FLUSH);
 
-	drv_flush(local, queues, false);
+	drv_flush(local, sdata, queues, false);
 
 	ieee80211_wake_queues_by_reason(&local->hw, IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_FLUSH);
-- 
1.9.1

