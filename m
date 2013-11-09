Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933429Ab3KIHkZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:40:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32859 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756976Ab3KIGuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:50:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.10 13/74] mac80211: update sta->last_rx on acked tx frames
Date: Fri,  8 Nov 2013 22:51:18 -0800
Message-Id: <20131109065114.485793211@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065113.502217951@linuxfoundation.org>
References: <20131109065113.502217951@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 0c5b93290b2f3c7a376567c03ae8d385b0e99851 upstream.

When clients are idle for too long, hostapd sends nullfunc frames for
probing. When those are acked by the client, the idle time needs to be
updated.

To make this work (and to avoid unnecessary probing), update sta->last_rx
whenever an ACK was received for a tx packet. Only do this if the flag
IEEE80211_HW_REPORTS_TX_ACK_STATUS is set.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/status.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -180,6 +180,9 @@ static void ieee80211_frame_acked(struct
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 
+	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
+		sta->last_rx = jiffies;
+
 	if (ieee80211_is_data_qos(mgmt->frame_control)) {
 		struct ieee80211_hdr *hdr = (void *) skb->data;
 		u8 *qc = ieee80211_get_qos_ctl(hdr);


