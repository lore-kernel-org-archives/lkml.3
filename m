Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbaDAQXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:23:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44682 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbaDAQQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:16:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 28/86] iwlwifi: fix TX status for aggregated packets
Date: Tue,  1 Apr 2014 09:07:41 -0700
Message-Id: <1396368519-12728-29-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

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
[ kamal: backport to 3.8 (only the dvm part) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/iwlwifi/dvm/tx.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index 2797964..855def9 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -1253,8 +1253,6 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 	struct iwl_compressed_ba_resp *ba_resp = (void *)pkt->data;
 	struct iwl_ht_agg *agg;
 	struct sk_buff_head reclaimed_skbs;
-	struct ieee80211_tx_info *info;
-	struct ieee80211_hdr *hdr;
 	struct sk_buff *skb;
 	int sta_id;
 	int tid;
@@ -1341,22 +1339,28 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
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
-- 
1.8.3.2

