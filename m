Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbaAMQTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:19:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53646 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427AbaAMQEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:04:45 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 166/208] net: clear local_df when passing skb between namespaces
Date: Mon, 13 Jan 2014 16:00:07 +0000
Message-Id: <1389628849-1614-167-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

commit 239c78db9c41a8f524cce60507440d72229d73bc upstream.

We must clear local_df when passing the skb between namespaces as the
packet is not local to the new namespace any more and thus may not get
fragmented by local rules. Fred Templin noticed that other namespaces
do fragment IPv6 packets while forwarding. Instead they should have send
back a PTB.

The same problem should be present when forwarding DF-IPv4 packets
between namespaces.

Reported-by: Templin, Fred L <Fred.L.Templin@boeing.com>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/core/skbuff.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index a75022e..b2cd9a4 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3511,6 +3511,7 @@ void skb_scrub_packet(struct sk_buff *skb)
 	skb->tstamp.tv64 = 0;
 	skb->pkt_type = PACKET_HOST;
 	skb->skb_iif = 0;
+	skb->local_df = 0;
 	skb_dst_drop(skb);
 	skb->mark = 0;
 	secpath_reset(skb);
-- 
1.8.3.2

