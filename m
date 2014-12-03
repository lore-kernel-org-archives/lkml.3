Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbaLCMBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:01:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54635 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbaLCL1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:08 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 003/101] sit: Use ipip6_tunnel_init as the ndo_init function.
Date: Wed,  3 Dec 2014 12:25:25 +0100
Message-Id: <e053cab2408920963e9e121a60f1ca949c269a96.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit ebe084aafb7e93adf210e80043c9f69adf56820d ]

ipip6_tunnel_init() sets the dev->iflink via a call to
ipip6_tunnel_bind_dev(). After that, register_netdevice()
sets dev->iflink = -1. So we loose the iflink configuration
for ipv6 tunnels. Fix this by using ipip6_tunnel_init() as the
ndo_init function. Then ipip6_tunnel_init() is called after
dev->iflink is set to -1 from register_netdevice().

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv6/sit.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index ebdf18bbcc02..8e8fc32a080f 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -195,10 +195,8 @@ static int ipip6_tunnel_create(struct net_device *dev)
 	struct sit_net *sitn = net_generic(net, sit_net_id);
 	int err;
 
-	err = ipip6_tunnel_init(dev);
-	if (err < 0)
-		goto out;
-	ipip6_tunnel_clone_6rd(dev, sitn);
+	memcpy(dev->dev_addr, &t->parms.iph.saddr, 4);
+	memcpy(dev->broadcast, &t->parms.iph.daddr, 4);
 
 	if ((__force u16)t->parms.i_flags & SIT_ISATAP)
 		dev->priv_flags |= IFF_ISATAP;
@@ -207,7 +205,8 @@ static int ipip6_tunnel_create(struct net_device *dev)
 	if (err < 0)
 		goto out;
 
-	strcpy(t->parms.name, dev->name);
+	ipip6_tunnel_clone_6rd(dev, sitn);
+
 	dev->rtnl_link_ops = &sit_link_ops;
 
 	dev_hold(dev);
@@ -1279,6 +1278,7 @@ static int ipip6_tunnel_change_mtu(struct net_device *dev, int new_mtu)
 }
 
 static const struct net_device_ops ipip6_netdev_ops = {
+	.ndo_init	= ipip6_tunnel_init,
 	.ndo_uninit	= ipip6_tunnel_uninit,
 	.ndo_start_xmit	= sit_tunnel_xmit,
 	.ndo_do_ioctl	= ipip6_tunnel_ioctl,
@@ -1313,9 +1313,7 @@ static int ipip6_tunnel_init(struct net_device *dev)
 
 	tunnel->dev = dev;
 	tunnel->net = dev_net(dev);
-
-	memcpy(dev->dev_addr, &tunnel->parms.iph.saddr, 4);
-	memcpy(dev->broadcast, &tunnel->parms.iph.daddr, 4);
+	strcpy(tunnel->parms.name, dev->name);
 
 	ipip6_tunnel_bind_dev(dev);
 	dev->tstats = alloc_percpu(struct pcpu_tstats);
@@ -1334,7 +1332,6 @@ static int __net_init ipip6_fb_tunnel_init(struct net_device *dev)
 
 	tunnel->dev = dev;
 	tunnel->net = dev_net(dev);
-	strcpy(tunnel->parms.name, dev->name);
 
 	iph->version		= 4;
 	iph->protocol		= IPPROTO_IPV6;
-- 
2.1.3

