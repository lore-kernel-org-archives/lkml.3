Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbaANAgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:36:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54486 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaANA3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:29:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.12 68/77] mac80211: move "bufferable MMPDU" check to fix AP mode scan
Date: Mon, 13 Jan 2014 16:28:29 -0800
Message-Id: <20140114002754.425585764@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002752.497010554@linuxfoundation.org>
References: <20140114002752.497010554@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 277d916fc2e959c3f106904116bb4f7b1148d47a upstream.

The check needs to apply to both multicast and unicast packets,
otherwise probe requests on AP mode scans are sent through the multicast
buffer queue, which adds long delays (often longer than the scanning
interval).

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/tx.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -463,7 +463,6 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 {
 	struct sta_info *sta = tx->sta;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 	struct ieee80211_local *local = tx->local;
 
 	if (unlikely(!sta))
@@ -474,15 +473,6 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 		     !(info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER))) {
 		int ac = skb_get_queue_mapping(tx->skb);
 
-		/* only deauth, disassoc and action are bufferable MMPDUs */
-		if (ieee80211_is_mgmt(hdr->frame_control) &&
-		    !ieee80211_is_deauth(hdr->frame_control) &&
-		    !ieee80211_is_disassoc(hdr->frame_control) &&
-		    !ieee80211_is_action(hdr->frame_control)) {
-			info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER;
-			return TX_CONTINUE;
-		}
-
 		ps_dbg(sta->sdata, "STA %pM aid %d: PS buffer for AC %d\n",
 		       sta->sta.addr, sta->sta.aid, ac);
 		if (tx->local->total_ps_buffered >= TOTAL_MAX_TX_BUFFER)
@@ -525,9 +515,22 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_ps_buf(struct ieee80211_tx_data *tx)
 {
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
+
 	if (unlikely(tx->flags & IEEE80211_TX_PS_BUFFERED))
 		return TX_CONTINUE;
 
+	/* only deauth, disassoc and action are bufferable MMPDUs */
+	if (ieee80211_is_mgmt(hdr->frame_control) &&
+	    !ieee80211_is_deauth(hdr->frame_control) &&
+	    !ieee80211_is_disassoc(hdr->frame_control) &&
+	    !ieee80211_is_action(hdr->frame_control)) {
+		if (tx->flags & IEEE80211_TX_UNICAST)
+			info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER;
+		return TX_CONTINUE;
+	}
+
 	if (tx->flags & IEEE80211_TX_UNICAST)
 		return ieee80211_tx_h_unicast_ps_buf(tx);
 	else


