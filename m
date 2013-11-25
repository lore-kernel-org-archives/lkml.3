Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928Ab3KYOSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:18:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58870 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754066Ab3KYNxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:41 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johannes Berg" <johannes.berg@intel.com>,
        "Felix Fietkau" <nbd@openwrt.org>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.158285689@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 39/87] mac80211: update sta->last_rx on acked tx frames
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/mac80211/status.c | 3 +++
 1 file changed, 3 insertions(+)

--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -181,6 +181,9 @@ static void ieee80211_frame_acked(struct
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 
+	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
+		sta->last_rx = jiffies;
+
 	if (ieee80211_is_data_qos(mgmt->frame_control)) {
 		struct ieee80211_hdr *hdr = (void *) skb->data;
 		u8 *qc = ieee80211_get_qos_ctl(hdr);

