Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab3L2Cbx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:31:53 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55401 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752819Ab3L2CKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:48 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Blaise Gassend" <blaise@suitabletech.com>,
        "Johannes Berg" <johannes.berg@intel.com>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.377669219@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 090/185] mac80211: don't attempt to reorder multicast
 frames
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/mac80211/rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -764,7 +764,8 @@ static void ieee80211_rx_reorder_ampdu(s
 	u16 sc;
 	int tid;
 
-	if (!ieee80211_is_data_qos(hdr->frame_control))
+	if (!ieee80211_is_data_qos(hdr->frame_control) ||
+	    is_multicast_ether_addr(hdr->addr1))
 		goto dont_reorder;
 
 	/*

