Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933812AbaE2OBI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:01:08 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59451 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933400AbaE2Ntc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vlad Yasevich <vyasevic@redhat.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Patrick McHardy <kaber@trash.net>, Andrian Nord <nightnord@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 087/103] mactap: Fix checksum errors for non-gso packets in bridge mode
Date: Thu, 29 May 2014 15:49:12 +0200
Message-Id: <e8d41427c79ff1d922120faf7e4b46a060a3eed6.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vlad Yasevich <vyasevic@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit cbdb04279ccaefcc702c8757757eea8ed76e50cf ]

The following is a problematic configuration:

 VM1: virtio-net device connected to macvtap0@eth0
 VM2: e1000 device connect to macvtap1@eth0

The problem is is that virtio-net supports checksum offloading
and thus sends the packets to the host with CHECKSUM_PARTIAL set.
On the other hand, e1000 does not support any acceleration.

For small TCP packets (and this includes the 3-way handshake),
e1000 ends up receiving packets that only have a partial checksum
set.  This causes TCP to fail checksum validation and to drop
packets.  As a result tcp connections can not be established.

Commit 3e4f8b787370978733ca6cae452720a4f0c296b8
	macvtap: Perform GSO on forwarding path.
fixes this issue for large packets wthat will end up undergoing GSO.
This commit adds a check for the non-GSO case and attempts to
compute the checksum for partially checksummed packets in the
non-GSO case.

CC: Daniel Lezcano <daniel.lezcano@free.fr>
CC: Patrick McHardy <kaber@trash.net>
CC: Andrian Nord <nightnord@gmail.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Michael S. Tsirkin <mst@redhat.com>
CC: Jason Wang <jasowang@redhat.com>
Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/macvtap.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 5895e4dbbf2a..d0f165f2877b 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -315,6 +315,15 @@ static int macvtap_forward(struct net_device *dev, struct sk_buff *skb)
 			segs = nskb;
 		}
 	} else {
+		/* If we receive a partial checksum and the tap side
+		 * doesn't support checksum offload, compute the checksum.
+		 * Note: it doesn't matter which checksum feature to
+		 *        check, we either support them all or none.
+		 */
+		if (skb->ip_summed == CHECKSUM_PARTIAL &&
+		    !(features & NETIF_F_ALL_CSUM) &&
+		    skb_checksum_help(skb))
+			goto drop;
 		skb_queue_tail(&q->sk.sk_receive_queue, skb);
 	}
 
-- 
1.9.3

