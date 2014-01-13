Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbaAMO3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:29:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51640 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbaAMO1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:27:16 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>, Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 95/96] mac80211: move "bufferable MMPDU" check to fix AP mode scan
Date: Mon, 13 Jan 2014 14:24:58 +0000
Message-Id: <1389623099-18783-96-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 277d916fc2e959c3f106904116bb4f7b1148d47a upstream.

The check needs to apply to both multicast and unicast packets,
otherwise probe requests on AP mode scans are sent through the multicast
buffer queue, which adds long delays (often longer than the scanning
interval).

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/mac80211/tx.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 83755a5..79cfca3 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -446,7 +446,6 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 {
 	struct sta_info *sta = tx->sta;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 	struct ieee80211_local *local = tx->local;
 
 	if (unlikely(!sta))
@@ -457,15 +456,6 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
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
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 		printk(KERN_DEBUG "STA %pM aid %d: PS buffer for AC %d\n",
 		       sta->sta.addr, sta->sta.aid, ac);
@@ -514,9 +504,22 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
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
-- 
1.8.3.2

