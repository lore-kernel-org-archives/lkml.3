Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbaHESOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:14:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52418 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167AbaHESOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:14:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.14 33/39] Revert "mac80211: move "bufferable MMPDU" check to fix AP mode scan"
Date: Tue,  5 Aug 2014 11:14:10 -0700
Message-Id: <20140805181337.039808792@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805181336.030349158@linuxfoundation.org>
References: <20140805181336.030349158@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 net/mac80211/tx.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -414,6 +414,9 @@ ieee80211_tx_h_multicast_ps_buf(struct i
 	if (ieee80211_has_order(hdr->frame_control))
 		return TX_CONTINUE;
 
+	if (ieee80211_is_probe_req(hdr->frame_control))
+		return TX_CONTINUE;
+
 	if (tx->local->hw.flags & IEEE80211_HW_QUEUE_CONTROL)
 		info->hw_queue = tx->sdata->vif.cab_queue;
 
@@ -464,6 +467,7 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 {
 	struct sta_info *sta = tx->sta;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 	struct ieee80211_local *local = tx->local;
 
 	if (unlikely(!sta))
@@ -474,6 +478,15 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
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
@@ -532,22 +545,8 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
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


