Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab3IKFdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:33:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5606 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab3IKE5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:20 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=aUH1c8bMH4cA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=fSso2nbfxG8A:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042915.255208251@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [138/251] mac80211: fix duplicate retransmission detection
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0138-mac80211-fix-duplicate-retransmission-detection.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 6b0f32745dcfba01d7be33acd1b40306c7a914c6 ]

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

Cc: stable@vger.kernel.org [all versions]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/mac80211/rx.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index bd11c1c..56515ef 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -805,8 +805,14 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
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
-- 
1.7.10.4


