Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab3LRVNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:13:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36401 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab3LRVNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Blaise Gassend <blaise@suitabletech.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.12 057/118] mac80211: dont attempt to reorder multicast frames
Date: Wed, 18 Dec 2013 13:11:34 -0800
Message-Id: <20131218211221.077675111@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 051a41fa4ee14f5c39668f0980973b9a195de560 upstream.

Multicast frames can't be transmitted as part of an aggregation
session (such a session couldn't even be set up) so don't try to
reorder them. Trying to do so would cause the reorder to stop
working correctly since multicast QoS frames (as transmitted by
the Aruba APs this was found with) would cause sequence number
confusion in the buffer.

Reported-by: Blaise Gassend <blaise@suitabletech.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/rx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -911,7 +911,8 @@ static void ieee80211_rx_reorder_ampdu(s
 	u16 sc;
 	u8 tid, ack_policy;
 
-	if (!ieee80211_is_data_qos(hdr->frame_control))
+	if (!ieee80211_is_data_qos(hdr->frame_control) ||
+	    is_multicast_ether_addr(hdr->addr1))
 		goto dont_reorder;
 
 	/*


