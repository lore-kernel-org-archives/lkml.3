Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbaDALQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:16:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42146 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbaDALQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:16:17 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 017/144] iwlwifi: fix TX status for aggregated packets
Date: Tue,  1 Apr 2014 12:13:41 +0100
Message-Id: <1396350948-29910-18-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 143582c6847cb285b361804c613127c25de60ca4 upstream.

Only the first packet is currently handled correctly, but then
all others are assumed to have failed which is problematic. Fix
this, marking them all successful instead (since if they're not
then the firmware will have transmitted them as single frames.)

This fixes the lost packet reporting.

Also do a tiny variable scoping cleanup.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[Add the dvm part]
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlwifi/dvm/tx.c | 14 +++++++++-----
 drivers/net/wireless/iwlwifi/mvm/tx.c | 18 +++++++++---------
 2 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index 42f64b5..adfbe0b 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -1310,8 +1310,6 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 	struct iwl_compressed_ba_resp *ba_resp = (void *)pkt->data;
 	struct iwl_ht_agg *agg;
 	struct sk_buff_head reclaimed_skbs;
-	struct ieee80211_tx_info *info;
-	struct ieee80211_hdr *hdr;
 	struct sk_buff *skb;
 	int sta_id;
 	int tid;
@@ -1398,22 +1396,28 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 	freed = 0;
 
 	skb_queue_walk(&reclaimed_skbs, skb) {
-		hdr = (struct ieee80211_hdr *)skb->data;
+		struct ieee80211_hdr *hdr = (void *)skb->data;
+		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
 		if (ieee80211_is_data_qos(hdr->frame_control))
 			freed++;
 		else
 			WARN_ON_ONCE(1);
 
-		info = IEEE80211_SKB_CB(skb);
 		iwl_trans_free_tx_cmd(priv->trans, info->driver_data[1]);
 
+		memset(&info->status, 0, sizeof(info->status));
+		/* Packet was transmitted successfully, failures come as single
+		 * frames because before failing a frame the firmware transmits
+		 * it without aggregation at least once.
+		 */
+		info->flags |= IEEE80211_TX_STAT_ACK;
+
 		if (freed == 1) {
 			/* this is the first skb we deliver in this batch */
 			/* put the rate scaling data there */
 			info = IEEE80211_SKB_CB(skb);
 			memset(&info->status, 0, sizeof(info->status));
-			info->flags |= IEEE80211_TX_STAT_ACK;
 			info->flags |= IEEE80211_TX_STAT_AMPDU;
 			info->status.ampdu_ack_len = ba_resp->txed_2_done;
 			info->status.ampdu_len = ba_resp->txed;
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index f0e96a9..7252110 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -818,16 +818,12 @@ int iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	struct iwl_mvm_ba_notif *ba_notif = (void *)pkt->data;
 	struct sk_buff_head reclaimed_skbs;
 	struct iwl_mvm_tid_data *tid_data;
-	struct ieee80211_tx_info *info;
 	struct ieee80211_sta *sta;
 	struct iwl_mvm_sta *mvmsta;
-	struct ieee80211_hdr *hdr;
 	struct sk_buff *skb;
 	int sta_id, tid, freed;
-
 	/* "flow" corresponds to Tx queue */
 	u16 scd_flow = le16_to_cpu(ba_notif->scd_flow);
-
 	/* "ssn" is start of block-ack Tx window, corresponds to index
 	 * (in Tx queue's circular buffer) of first TFD/frame in window */
 	u16 ba_resp_scd_ssn = le16_to_cpu(ba_notif->scd_ssn);
@@ -884,22 +880,26 @@ int iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	freed = 0;
 
 	skb_queue_walk(&reclaimed_skbs, skb) {
-		hdr = (struct ieee80211_hdr *)skb->data;
+		struct ieee80211_hdr *hdr = (void *)skb->data;
+		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
 		if (ieee80211_is_data_qos(hdr->frame_control))
 			freed++;
 		else
 			WARN_ON_ONCE(1);
 
-		info = IEEE80211_SKB_CB(skb);
 		iwl_trans_free_tx_cmd(mvm->trans, info->driver_data[1]);
 
+		memset(&info->status, 0, sizeof(info->status));
+		/* Packet was transmitted successfully, failures come as single
+		 * frames because before failing a frame the firmware transmits
+		 * it without aggregation at least once.
+		 */
+		info->flags |= IEEE80211_TX_STAT_ACK;
+
 		if (freed == 1) {
 			/* this is the first skb we deliver in this batch */
 			/* put the rate scaling data there */
-			info = IEEE80211_SKB_CB(skb);
-			memset(&info->status, 0, sizeof(info->status));
-			info->flags |= IEEE80211_TX_STAT_ACK;
 			info->flags |= IEEE80211_TX_STAT_AMPDU;
 			info->status.ampdu_ack_len = ba_notif->txed_2_done;
 			info->status.ampdu_len = ba_notif->txed;
-- 
1.9.1

