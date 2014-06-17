Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967630AbaFQW2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:28:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54230 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966436AbaFQVtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:49:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Lezcano <daniel.lezcano@free.fr>, Patrick McHardy <kaber@trash.net>,
        Andrian Nord <nightnord@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 038/212] mactap: Fix checksum errors for non-gso packets in bridge mode
Date: Tue, 17 Jun 2014 14:42:12 -0700
Message-Id: <1403041506-13646-39-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevic@redhat.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/macvtap.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 2a89da0..73ffad8 100644
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
1.9.1

