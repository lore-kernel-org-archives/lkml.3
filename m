Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080Ab3KIHES (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:04:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33420 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932841Ab3KIGw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:52:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Huehn <thomas@net.t-labs.tu-berlin.de>,
        Felix Fietkau <nbd@openwrt.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.11 16/94] mac80211: drop spoofed packets in ad-hoc mode
Date: Fri,  8 Nov 2013 22:51:22 -0800
Message-Id: <20131109065205.394035755@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/rx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3014,6 +3014,9 @@ static int prepare_for_handlers(struct i
 	case NL80211_IFTYPE_ADHOC:
 		if (!bssid)
 			return 0;
+		if (ether_addr_equal(sdata->vif.addr, hdr->addr2) ||
+		    ether_addr_equal(sdata->u.ibss.bssid, hdr->addr2))
+			return 0;
 		if (ieee80211_is_beacon(hdr->frame_control)) {
 			return 1;
 		} else if (!ieee80211_bssid_match(bssid, sdata->u.ibss.bssid)) {


