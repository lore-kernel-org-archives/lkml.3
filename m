Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760800AbaLLGhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:37:36 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51889 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759296AbaLLGQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:56 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Yosef Khyal" <yosefx.khyal@intel.com>,
        "Johannes Berg" <johannes.berg@intel.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.301168300@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 108/164] mac80211: fix use-after-free in defragmentation
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/mac80211/rx.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1470,11 +1470,14 @@ ieee80211_rx_h_defragment(struct ieee802
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
@@ -1567,10 +1570,7 @@ ieee80211_rx_h_defragment(struct ieee802
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
 

