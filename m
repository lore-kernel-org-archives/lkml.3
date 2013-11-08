Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172Ab3KHCVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:21:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34780 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757139Ab3KHCU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:20:56 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>, Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 44/91] mac80211: update sta->last_rx on acked tx frames
Date: Thu,  7 Nov 2013 18:14:59 -0800
Message-Id: <1383876946-2396-45-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/status.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 07d9957..f3a2898 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -180,6 +180,9 @@ static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 
+	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
+		sta->last_rx = jiffies;
+
 	if (ieee80211_is_data_qos(mgmt->frame_control)) {
 		struct ieee80211_hdr *hdr = (void *) skb->data;
 		u8 *qc = ieee80211_get_qos_ctl(hdr);
-- 
1.8.1.2

