Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbaIOWUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:20:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51348 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758538AbaIOWUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:20:32 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ilan Peer <ilan.peer@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 049/187] iwlwifi: mvm: Add a missed beacons threshold
Date: Mon, 15 Sep 2014 15:07:39 -0700
Message-Id: <1410818997-9432-50-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilan Peer <ilan.peer@intel.com>

commit 12d423e816c69b0b4457bc047dda9a0a1c1a53c1 upstream.

Instead of always calling ieee80211_beacon_loss() on every missed
beacons notification, call this function only if the number of
consecutive missed beacons from last rx is higher than a predefined
threshold.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 25 ++++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  1 +
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 1fc0332..07d78ac 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -1148,10 +1148,18 @@ int iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
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
 
@@ -1160,12 +1168,19 @@ int iwl_mvm_rx_missed_beacons_notif(struct iwl_mvm *mvm,
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
index 17f1096..0f0de23 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -81,6 +81,7 @@
 #define IWL_MVM_MAX_ADDRESSES		5
 /* RSSI offset for WkP */
 #define IWL_RSSI_OFFSET 50
+#define IWL_MVM_MISSED_BEACONS_THRESHOLD 8
 
 enum iwl_mvm_tx_fifo {
 	IWL_MVM_TX_FIFO_BK = 0,
-- 
1.9.1

