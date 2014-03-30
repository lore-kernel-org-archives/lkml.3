Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbaC3Xln (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:41:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36422 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753055AbaC3XZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:02 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
        "Johannes Berg" <johannes.berg@intel.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.351725412@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 147/200] iwlwifi: fix TX status for aggregated packets
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Drop the mvm part
 - Adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -854,8 +854,6 @@ int iwlagn_rx_reply_compressed_ba(struct
 	struct iwl_compressed_ba_resp *ba_resp = &pkt->u.compressed_ba;
 	struct iwl_ht_agg *agg;
 	struct sk_buff_head reclaimed_skbs;
-	struct ieee80211_tx_info *info;
-	struct ieee80211_hdr *hdr;
 	struct sk_buff *skb;
 	unsigned long flags;
 	int sta_id;
@@ -941,24 +939,32 @@ int iwlagn_rx_reply_compressed_ba(struct
 			  0, &reclaimed_skbs);
 	freed = 0;
 	while (!skb_queue_empty(&reclaimed_skbs)) {
+		struct ieee80211_hdr *hdr;
+		struct ieee80211_tx_info *info;
 
 		skb = __skb_dequeue(&reclaimed_skbs);
-		hdr = (struct ieee80211_hdr *)skb->data;
+		hdr = (void *)skb->data;
+		info = IEEE80211_SKB_CB(skb);
 
 		if (ieee80211_is_data_qos(hdr->frame_control))
 			freed++;
 		else
 			WARN_ON_ONCE(1);
 
-		info = IEEE80211_SKB_CB(skb);
 		kmem_cache_free(priv->tx_cmd_pool, (info->driver_data[1]));
 
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

