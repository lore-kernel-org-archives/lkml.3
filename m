Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734AbbAIKi3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:38:29 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44594 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757498AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Andreas=20M=C3=BCller?= <goo@stapelspeicher.org>,
        Johannes Berg <johannes.berg@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 51/78] mac80211: fix multicast LED blinking and counter
Date: Fri,  9 Jan 2015 11:32:00 +0100
Message-Id: <a4346dd0a57d96e9f7c3d0cfafeda2a5568eb685.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Müller <goo@stapelspeicher.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/mac80211/rx.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 275cb85bfa31..ef3bdba9309e 100644
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
2.2.1

