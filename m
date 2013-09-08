Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759824Ab3IHDjX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:39:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56125 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756344Ab3IHDTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:19 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johannes Berg" <johannes.berg@intel.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.374721875@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [026/121] mac80211: fix duplicate retransmission detection
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 6b0f32745dcfba01d7be33acd1b40306c7a914c6 upstream.

The duplicate retransmission detection code in mac80211
erroneously attempts to do the check for every frame,
even frames that don't have a sequence control field or
that don't use it (QoS-Null frames.)

This is problematic because it causes the code to access
data beyond the end of the SKB and depending on the data
there will drop packets erroneously.

Correct the code to not do duplicate detection for such
frames.

I found this error while testing AP powersave, it lead
to retransmitted PS-Poll frames being dropped entirely
as the data beyond the end of the SKB was always zero.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/mac80211/rx.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -821,8 +821,14 @@ ieee80211_rx_h_check(struct ieee80211_rx
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 
-	/* Drop duplicate 802.11 retransmissions (IEEE 802.11 Chap. 9.2.9) */
-	if (rx->sta && !is_multicast_ether_addr(hdr->addr1)) {
+	/*
+	 * Drop duplicate 802.11 retransmissions
+	 * (IEEE 802.11-2012: 9.3.2.10 "Duplicate detection and recovery")
+	 */
+	if (rx->skb->len >= 24 && rx->sta &&
+	    !ieee80211_is_ctl(hdr->frame_control) &&
+	    !ieee80211_is_qos_nullfunc(hdr->frame_control) &&
+	    !is_multicast_ether_addr(hdr->addr1)) {
 		if (unlikely(ieee80211_has_retry(hdr->frame_control) &&
 			     rx->sta->last_seq_ctrl[rx->seqno_idx] ==
 			     hdr->seq_ctrl)) {

