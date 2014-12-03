Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbaLCLzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:55:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54706 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbaLCL1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:14 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 033/101] mac80211: fix use-after-free in defragmentation
Date: Wed,  3 Dec 2014 12:25:55 +0100
Message-Id: <8384cbafb34d6abfe75dbc2d9b4f42302ad3edae.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b8fff407a180286aa683d543d878d98d9fc57b13 upstream.

Upon receiving the last fragment, all but the first fragment
are freed, but the multicast check for statistics at the end
of the function refers to the current skb (the last fragment)
causing a use-after-free bug.

Since multicast frames cannot be fragmented and we check for
this early in the function, just modify that check to also
do the accounting to fix the issue.

Reported-by: Yosef Khyal <yosefx.khyal@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/mac80211/rx.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 1e5bd0d75732..275cb85bfa31 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1646,11 +1646,14 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 	sc = le16_to_cpu(hdr->seq_ctrl);
 	frag = sc & IEEE80211_SCTL_FRAG;
 
-	if (likely((!ieee80211_has_morefrags(fc) && frag == 0) ||
-		   is_multicast_ether_addr(hdr->addr1))) {
-		/* not fragmented */
+	if (likely(!ieee80211_has_morefrags(fc) && frag == 0))
+		goto out;
+
+	if (is_multicast_ether_addr(hdr->addr1)) {
+		rx->local->dot11MulticastReceivedFrameCount++;
 		goto out;
 	}
+
 	I802_DEBUG_INC(rx->local->rx_handlers_fragments);
 
 	if (skb_linearize(rx->skb))
@@ -1743,10 +1746,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
  out:
 	if (rx->sta)
 		rx->sta->rx_packets++;
-	if (is_multicast_ether_addr(hdr->addr1))
-		rx->local->dot11MulticastReceivedFrameCount++;
-	else
-		ieee80211_led_rx(rx->local);
+	ieee80211_led_rx(rx->local);
 	return RX_CONTINUE;
 }
 
-- 
2.1.3

