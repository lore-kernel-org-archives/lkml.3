Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab3LQS12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:27:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:32803 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755830Ab3LQSPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:15:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 066/103] mac80211: don't attempt to reorder multicast frames
Date: Tue, 17 Dec 2013 18:12:55 +0000
Message-Id: <1387304012-23805-67-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/mac80211/rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ee8f525a..02e3f9a 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -764,7 +764,8 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
 	u16 sc;
 	u8 tid, ack_policy;
 
-	if (!ieee80211_is_data_qos(hdr->frame_control))
+	if (!ieee80211_is_data_qos(hdr->frame_control) ||
+	    is_multicast_ether_addr(hdr->addr1))
 		goto dont_reorder;
 
 	/*
-- 
1.8.3.2

