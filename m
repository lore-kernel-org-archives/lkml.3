Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab3KYN3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:29:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56959 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab3KYNHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:07:18 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>, Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 05/78] mac80211: update sta->last_rx on acked tx frames
Date: Mon, 25 Nov 2013 13:05:52 +0000
Message-Id: <1385384825-21681-6-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/mac80211/status.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index f98b326..619badc 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -183,6 +183,9 @@ static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 
+	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
+		sta->last_rx = jiffies;
+
 	if (ieee80211_is_data_qos(mgmt->frame_control)) {
 		struct ieee80211_hdr *hdr = (void *) skb->data;
 		u8 *qc = ieee80211_get_qos_ctl(hdr);
-- 
1.8.3.2

