Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbbALTAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:00:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58047 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943AbbALS34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:29:56 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Andreas=20M=C3=BCller?= <goo@stapelspeicher.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 131/216] mac80211: fix multicast LED blinking and counter
Date: Mon, 12 Jan 2015 18:28:29 +0000
Message-Id: <1421087394-2712-19-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Andreas=20M=C3=BCller?= <goo@stapelspeicher.org>

commit d025933e29872cb1fe19fc54d80e4dfa4ee5779c upstream.

As multicast-frames can't be fragmented, "dot11MulticastReceivedFrameCount"
stopped being incremented after the use-after-free fix. Furthermore, the
RX-LED will be triggered by every multicast frame (which wouldn't happen
before) which wouldn't allow the LED to rest at all.

Fixes https://bugzilla.kernel.org/show_bug.cgi?id=89431 which also had the
patch.

Fixes: b8fff407a180 ("mac80211: fix use-after-free in defragmentation")
Signed-off-by: Andreas Müller <goo@stapelspeicher.org>
[rewrite commit message]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/mac80211/rx.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index e3f758a14387..dfa42b016992 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1646,14 +1646,14 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 	sc = le16_to_cpu(hdr->seq_ctrl);
 	frag = sc & IEEE80211_SCTL_FRAG;
 
-	if (likely(!ieee80211_has_morefrags(fc) && frag == 0))
-		goto out;
-
 	if (is_multicast_ether_addr(hdr->addr1)) {
 		rx->local->dot11MulticastReceivedFrameCount++;
-		goto out;
+		goto out_no_led;
 	}
 
+	if (likely(!ieee80211_has_morefrags(fc) && frag == 0))
+		goto out;
+
 	I802_DEBUG_INC(rx->local->rx_handlers_fragments);
 
 	if (skb_linearize(rx->skb))
@@ -1744,9 +1744,10 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 	status->rx_flags |= IEEE80211_RX_FRAGMENTED;
 
  out:
+	ieee80211_led_rx(rx->local);
+ out_no_led:
 	if (rx->sta)
 		rx->sta->rx_packets++;
-	ieee80211_led_rx(rx->local);
 	return RX_CONTINUE;
 }
 
-- 
2.1.4

