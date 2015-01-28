Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965210AbbA1EZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:25:30 -0500
Received: from mail.kernel.org ([198.145.29.136]:41092 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934567AbbA1EZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:25:25 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 150/177] mac80211: fix use-after-free in defragmentation
Date: Wed, 28 Jan 2015 12:10:08 +0800
Message-Id: <1422418236-12852-241-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 net/mac80211/rx.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index f5ed863..32929b0 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1486,11 +1486,14 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
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
@@ -1583,10 +1586,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
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
1.9.1

