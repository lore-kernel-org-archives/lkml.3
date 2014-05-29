Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934765AbaE2OBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:01:19 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59439 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933353AbaE2Ntc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Cong Wang <amwang@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 066/103] vti: don't allow to add the same tunnel twice
Date: Thu, 29 May 2014 15:48:51 +0200
Message-Id: <8e41d3a008374022b116ed4434dec644fef3e676.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 8d89dcdf80d88007647945a753821a06eb6cc5a5 ]

Before the patch, it was possible to add two times the same tunnel:
ip l a vti1 type vti remote 10.16.0.121 local 10.16.0.249 key 41
ip l a vti2 type vti remote 10.16.0.121 local 10.16.0.249 key 41

It was possible, because ip_tunnel_newlink() calls ip_tunnel_find() with the
argument dev->type, which was set only later (when calling ndo_init handler
in register_netdevice()). Let's set this type in the setup handler, which is
called before newlink handler.

Introduced by commit b9959fd3b0fa ("vti: switch to new ip tunnel code").

CC: Cong Wang <amwang@redhat.com>
CC: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv4/ip_vti.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 26847e189c04..33e2bf806249 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -271,6 +271,7 @@ static const struct net_device_ops vti_netdev_ops = {
 static void vti_tunnel_setup(struct net_device *dev)
 {
 	dev->netdev_ops		= &vti_netdev_ops;
+	dev->type		= ARPHRD_TUNNEL;
 	ip_tunnel_setup(dev, vti_net_id);
 }
 
@@ -282,7 +283,6 @@ static int vti_tunnel_init(struct net_device *dev)
 	memcpy(dev->dev_addr, &iph->saddr, 4);
 	memcpy(dev->broadcast, &iph->daddr, 4);
 
-	dev->type		= ARPHRD_TUNNEL;
 	dev->hard_header_len	= LL_MAX_HEADER + sizeof(struct iphdr);
 	dev->mtu		= ETH_DATA_LEN;
 	dev->flags		= IFF_NOARP;
-- 
1.9.3

