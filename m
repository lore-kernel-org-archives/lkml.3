Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965625AbaFQQgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:36:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50942 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965189AbaFQQ0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:26:02 -0400
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
Subject: [PATCH 3.8 066/121] Revert "macvlan : fix checksums error when we are in bridge mode"
Date: Tue, 17 Jun 2014 09:17:24 -0700
Message-Id: <1403021899-16708-39-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021899-16708-2-git-send-email-kamal@canonical.com>
References: <1403021899-16708-2-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevic@redhat.com>

[ Upstream commit f114890cdf84d753f6b41cd0cc44ba51d16313da ]

This reverts commit 12a2856b604476c27d85a5f9a57ae1661fc46019.
The commit above doesn't appear to be necessary any more as the
checksums appear to be correctly computed/validated.

Additionally the above commit breaks kvm configurations where
one VM is using a device that support checksum offload (virtio) and
the other VM does not.
In this case, packets leaving virtio device will have CHECKSUM_PARTIAL
set.  The packets is forwarded to a macvtap that has offload features
turned off.  Since we use CHECKSUM_UNNECESSARY, the host does does not
update the checksum and thus a bad checksum is passed up to
the guest.

CC: Daniel Lezcano <daniel.lezcano@free.fr>
CC: Patrick McHardy <kaber@trash.net>
CC: Andrian Nord <nightnord@gmail.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Michael S. Tsirkin <mst@redhat.com>
CC: Jason Wang <jasowang@redhat.com>
Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/macvlan.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 931a4d7..acef63d 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -236,11 +236,9 @@ static int macvlan_queue_xmit(struct sk_buff *skb, struct net_device *dev)
 	const struct macvlan_dev *vlan = netdev_priv(dev);
 	const struct macvlan_port *port = vlan->port;
 	const struct macvlan_dev *dest;
-	__u8 ip_summed = skb->ip_summed;
 
 	if (vlan->mode == MACVLAN_MODE_BRIDGE) {
 		const struct ethhdr *eth = (void *)skb->data;
-		skb->ip_summed = CHECKSUM_UNNECESSARY;
 
 		/* send to other bridge ports directly */
 		if (is_multicast_ether_addr(eth->h_dest)) {
@@ -258,7 +256,6 @@ static int macvlan_queue_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 xmit_world:
-	skb->ip_summed = ip_summed;
 	skb->dev = vlan->lowerdev;
 	return dev_queue_xmit(skb);
 }
-- 
1.9.1

