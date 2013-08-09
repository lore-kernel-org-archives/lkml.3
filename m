Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967582Ab3HIB65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:58:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55705 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967503Ab3HIB6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:58:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 040/102] mac80211: fix duplicate retransmission detection
Date: Thu,  8 Aug 2013 18:57:16 -0700
Message-Id: <20130809015019.228287060@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/rx.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -932,8 +932,14 @@ ieee80211_rx_h_check(struct ieee80211_rx
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


