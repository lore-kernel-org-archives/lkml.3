Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbaHTMI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:08:27 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58904 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752499AbaHTLoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 027/104] Revert "mac80211: move "bufferable MMPDU" check to fix AP mode scan"
Date: Wed, 20 Aug 2014 13:42:50 +0200
Message-Id: <3516cca653f2c410b8f736a73daf8089f7a18628.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 08b9939997df30e42a228e1ecb97f99e9c8ea84e upstream.

This reverts commit 277d916fc2e959c3f106904116bb4f7b1148d47a as it was
at least breaking iwlwifi by setting the IEEE80211_TX_CTL_NO_PS_BUFFER
flag in all kinds of interface modes, not only for AP mode where it is
appropriate.

To avoid reintroducing the original problem, explicitly check for probe
request frames in the multicast buffering code.

Fixes: 277d916fc2e9 ("mac80211: move "bufferable MMPDU" check to fix AP mode scan")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/mac80211/tx.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 267bc8e4b8b6..c2785b2af97c 100644
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
@@ -530,22 +543,8 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_ps_buf(struct ieee80211_tx_data *tx)
 {
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
-
 	if (unlikely(tx->flags & IEEE80211_TX_PS_BUFFERED))
 		return TX_CONTINUE;
-
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
2.0.4

