Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbaAFDfB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 22:35:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbaAFDfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 22:35:00 -0500
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mst@redhat.com, Jason Wang <jasowang@redhat.com>,
        John Fastabend <john.r.fastabend@intel.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH net 1/2] macvlan: forbid L2 fowarding offload for macvtap
Date: Mon,  6 Jan 2014 11:21:06 +0800
Message-Id: <1388978467-2075-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

L2 fowarding offload will bypass the rx handler of real device. This will make
the packet could not be forwarded to macvtap device. Another problem is the
dev_hard_start_xmit() called for macvtap does not have any synchronization.

Fix this by forbidding L2 forwarding for macvtap.

Cc: John Fastabend <john.r.fastabend@intel.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/macvlan.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 60406b0..5360f73 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -338,6 +338,8 @@ static const struct header_ops macvlan_hard_header_ops = {
 	.cache_update	= eth_header_cache_update,
 };
 
+static struct rtnl_link_ops macvlan_link_ops;
+
 static int macvlan_open(struct net_device *dev)
 {
 	struct macvlan_dev *vlan = netdev_priv(dev);
@@ -353,7 +355,8 @@ static int macvlan_open(struct net_device *dev)
 		goto hash_add;
 	}
 
-	if (lowerdev->features & NETIF_F_HW_L2FW_DOFFLOAD) {
+	if (lowerdev->features & NETIF_F_HW_L2FW_DOFFLOAD &&
+	    dev->rtnl_link_ops == &macvlan_link_ops) {
 		vlan->fwd_priv =
 		      lowerdev->netdev_ops->ndo_dfwd_add_station(lowerdev, dev);
 
-- 
1.7.1

