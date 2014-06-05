Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbaFEEYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:24:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44622 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbaFEEWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:22:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Huehn <thomas@net.t-labs.tu-berlin.de>,
        Felix Fietkau <nbd@openwrt.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 205/214] mac80211: drop spoofed packets in ad-hoc mode
Date: Wed,  4 Jun 2014 21:19:28 -0700
Message-Id: <20140605041707.003026585@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: use compare_ether_addr() instead of ether_addr_equal()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/rx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2828,6 +2828,9 @@ static int prepare_for_handlers(struct i
 	case NL80211_IFTYPE_ADHOC:
 		if (!bssid)
 			return 0;
+		if (compare_ether_addr(sdata->vif.addr, hdr->addr2) == 0 ||
+		    compare_ether_addr(sdata->u.ibss.bssid, hdr->addr2) == 0)
+			return 0;
 		if (ieee80211_is_beacon(hdr->frame_control)) {
 			return 1;
 		}


