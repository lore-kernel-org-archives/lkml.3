Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674AbaE2Efn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:35:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57992 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932498AbaE2Efe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Patrick McHardy <kaber@trash.net>, Andrian Nord <nightnord@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 102/140] mactap: Fix checksum errors for non-gso packets in bridge mode
Date: Wed, 28 May 2014 21:34:01 -0700
Message-Id: <20140529043102.685907360@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macvtap.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -322,6 +322,15 @@ static rx_handler_result_t macvtap_handl
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
 


