Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaFGBZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:25:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36181 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752712AbaFGBXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:40 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Patrick McHardy" <kaber@trash.net>,
        "Daniel Lezcano" <daniel.lezcano@free.fr>,
        "Jason Wang" <jasowang@redhat.com>,
        "Andrian Nord" <nightnord@gmail.com>,
        "Vlad Yasevich" <vyasevic@redhat.com>
Date: Sat, 07 Jun 2014 02:26:28 +0100
Message-ID: <lsq.1402104388.775889089@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 18/92] Revert "macvlan : fix checksums error when we
 are in  bridge mode"
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/macvlan.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 301b39e..ab5786b 100644
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

