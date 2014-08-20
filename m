Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbaHTL6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:58:19 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58965 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752575AbaHTLoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 059/104] iwlwifi: mvm: Add a missed beacons threshold
Date: Wed, 20 Aug 2014 13:43:22 +0200
Message-Id: <acee73bbc5ac9a93eef85dbe244fda641eab6f96.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 12d423e816c69b0b4457bc047dda9a0a1c1a53c1 upstream.

Instead of always calling ieee80211_beacon_loss() on every missed
beacons notification, call this function only if the number of
consecutive missed beacons from last rx is higher than a predefined
threshold.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 25 ++++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  1 +
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 5fe23a5ea9b6..72c64152f48e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -1102,10 +1102,18 @@ int iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
 static void iwl_mvm_beacon_loss_iterator(void *_data, u8 *mac,
 					 struct ieee80211_vif *vif)
 {
-	u16 *id = _data;
+	struct iwl_missed_beacons_notif *missed_beacons = _data;
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
-	if (mvmvif->id == *id)
+	if (mvmvif->id != (u16)le32_to_cpu(missed_beacons->mac_id))
+		return;
+
+	/*
+	 * TODO: the threshold should be adjusted based on latency conditions,
+	 * and/or in case of a CS flow on one of the other AP vifs.
+	 */
+	if (le32_to_cpu(missed_beacons->consec_missed_beacons_since_last_rx) >
+	     IWL_MVM_MISSED_BEACONS_THRESHOLD)
 		ieee80211_beacon_loss(vif);
 }
 
@@ -1114,12 +1122,19 @@ int iwl_mvm_rx_missed_beacons_notif(struct iwl_mvm *mvm,
 				    struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_missed_beacons_notif *missed_beacons = (void *)pkt->data;
-	u16 id = (u16)le32_to_cpu(missed_beacons->mac_id);
+	struct iwl_missed_beacons_notif *mb = (void *)pkt->data;
+
+	IWL_DEBUG_INFO(mvm,
+		       "missed bcn mac_id=%u, consecutive=%u (%u, %u, %u)\n",
+		       le32_to_cpu(mb->mac_id),
+		       le32_to_cpu(mb->consec_missed_beacons),
+		       le32_to_cpu(mb->consec_missed_beacons_since_last_rx),
+		       le32_to_cpu(mb->num_recvd_beacons),
+		       le32_to_cpu(mb->num_expected_beacons));
 
 	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
 						   IEEE80211_IFACE_ITER_NORMAL,
 						   iwl_mvm_beacon_loss_iterator,
-						   &id);
+						   mb);
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index c86663ebb493..210344766438 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -82,6 +82,7 @@
 #define IWL_MVM_MAX_ADDRESSES		5
 /* RSSI offset for WkP */
 #define IWL_RSSI_OFFSET 50
+#define IWL_MVM_MISSED_BEACONS_THRESHOLD 8
 
 enum iwl_mvm_tx_fifo {
 	IWL_MVM_TX_FIFO_BK = 0,
-- 
2.0.4

