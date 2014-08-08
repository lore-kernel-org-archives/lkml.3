Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071AbaHHUrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:47:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40566 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758021AbaHHUre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:47:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 178/259] Revert "mac80211: move "bufferable MMPDU" check to fix AP mode scan"
Date: Fri,  8 Aug 2014 13:40:01 -0700
Message-Id: <1407530482-4483-179-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 08b9939997df30e42a228e1ecb97f99e9c8ea84e upstream.

This reverts commit 277d916fc2e959c3f106904116bb4f7b1148d47a as it was
at least breaking iwlwifi by setting the IEEE80211_TX_CTL_NO_PS_BUFFER
flag in all kinds of interface modes, not only for AP mode where it is
appropriate.

To avoid reintroducing the original problem, explicitly check for probe
request frames in the multicast buffering code.

Fixes: 277d916fc2e9 ("mac80211: move "bufferable MMPDU" check to fix AP mode scan")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ luis: backported to 3.11: based on Johannes' backport for 3.10 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/tx.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c45f75f..101bccf 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -413,6 +413,9 @@ ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
 	if (ieee80211_has_order(hdr->frame_control))
 		return TX_CONTINUE;
 
+	if (ieee80211_is_probe_req(hdr->frame_control))
+		return TX_CONTINUE;
+
 	if (tx->local->hw.flags & IEEE80211_HW_QUEUE_CONTROL)
 		info->hw_queue = tx->sdata->vif.cab_queue;
 
@@ -463,6 +466,7 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 {
 	struct sta_info *sta = tx->sta;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 	struct ieee80211_local *local = tx->local;
 
 	if (unlikely(!sta))
@@ -473,6 +477,15 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 		     !(info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER))) {
 		int ac = skb_get_queue_mapping(tx->skb);
 
+		/* only deauth, disassoc and action are bufferable MMPDUs */
+		if (ieee80211_is_mgmt(hdr->frame_control) &&
+		    !ieee80211_is_deauth(hdr->frame_control) &&
+		    !ieee80211_is_disassoc(hdr->frame_control) &&
+		    !ieee80211_is_action(hdr->frame_control)) {
+			info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER;
+			return TX_CONTINUE;
+		}
+
 		ps_dbg(sta->sdata, "STA %pM aid %d: PS buffer for AC %d\n",
 		       sta->sta.addr, sta->sta.aid, ac);
 		if (tx->local->total_ps_buffered >= TOTAL_MAX_TX_BUFFER)
@@ -530,22 +543,9 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_ps_buf(struct ieee80211_tx_data *tx)
 {
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
-
 	if (unlikely(tx->flags & IEEE80211_TX_PS_BUFFERED))
 		return TX_CONTINUE;
 
-	/* only deauth, disassoc and action are bufferable MMPDUs */
-	if (ieee80211_is_mgmt(hdr->frame_control) &&
-	    !ieee80211_is_deauth(hdr->frame_control) &&
-	    !ieee80211_is_disassoc(hdr->frame_control) &&
-	    !ieee80211_is_action(hdr->frame_control)) {
-		if (tx->flags & IEEE80211_TX_UNICAST)
-			info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER;
-		return TX_CONTINUE;
-	}
-
 	if (tx->flags & IEEE80211_TX_UNICAST)
 		return ieee80211_tx_h_unicast_ps_buf(tx);
 	else
-- 
1.9.1

