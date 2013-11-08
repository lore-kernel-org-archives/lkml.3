Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab3KHC2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:28:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34849 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932634Ab3KHCVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:21:36 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>, Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 42/91] mac80211: drop spoofed packets in ad-hoc mode
Date: Thu,  7 Nov 2013 18:14:57 -0800
Message-Id: <1383876946-2396-43-git-send-email-kamal@canonical.com>
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

commit 6329b8d917adc077caa60c2447385554130853a3 upstream.

If an Ad-Hoc node receives packets with the Cell ID or its own MAC
address as source address, it hits a WARN_ON in sta_info_insert_check()
With many packets, this can massively spam the logs. One way that this
can easily happen is through having Cisco APs in the area with rouge AP
detection and countermeasures enabled.
Such Cisco APs will regularly send fake beacons, disassoc and deauth
packets that trigger these warnings.

To fix this issue, drop such spoofed packets early in the rx path.

Reported-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/rx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 87f76fa..b1e5e03 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2916,6 +2916,9 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 	case NL80211_IFTYPE_ADHOC:
 		if (!bssid)
 			return 0;
+		if (ether_addr_equal(sdata->vif.addr, hdr->addr2) ||
+		    ether_addr_equal(sdata->u.ibss.bssid, hdr->addr2))
+			return 0;
 		if (ieee80211_is_beacon(hdr->frame_control)) {
 			return 1;
 		} else if (!ieee80211_bssid_match(bssid, sdata->u.ibss.bssid)) {
-- 
1.8.1.2

