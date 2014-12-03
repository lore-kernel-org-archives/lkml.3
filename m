Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbaLCMBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:01:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54634 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbaLCL1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:08 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 002/101] ip6_tunnel: Use ip6_tnl_dev_init as the ndo_init function.
Date: Wed,  3 Dec 2014 12:25:24 +0100
Message-Id: <c024c280512fc4a76237b647218366bdef6f3fe4.1417605922.git.jslaby@suse.cz>
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

[ Upstream commit 6c6151daaf2d8dc2046d9926539feed5f66bf74e ]

ip6_tnl_dev_init() sets the dev->iflink via a call to
ip6_tnl_link_config(). After that, register_netdevice()
sets dev->iflink = -1. So we loose the iflink configuration
for ipv6 tunnels. Fix this by using ip6_tnl_dev_init() as the
ndo_init function. Then ip6_tnl_dev_init() is called after
dev->iflink is set to -1 from register_netdevice().

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv6/ip6_tunnel.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 7c26d8a3fa1b..f8a70a120e75 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -266,9 +266,6 @@ static int ip6_tnl_create2(struct net_device *dev)
 	int err;
 
 	t = netdev_priv(dev);
-	err = ip6_tnl_dev_init(dev);
-	if (err < 0)
-		goto out;
 
 	err = register_netdevice(dev);
 	if (err < 0)
@@ -1448,6 +1445,7 @@ ip6_tnl_change_mtu(struct net_device *dev, int new_mtu)
 
 
 static const struct net_device_ops ip6_tnl_netdev_ops = {
+	.ndo_init	= ip6_tnl_dev_init,
 	.ndo_uninit	= ip6_tnl_dev_uninit,
 	.ndo_start_xmit = ip6_tnl_xmit,
 	.ndo_do_ioctl	= ip6_tnl_ioctl,
@@ -1532,16 +1530,10 @@ static int __net_init ip6_fb_tnl_dev_init(struct net_device *dev)
 	struct ip6_tnl *t = netdev_priv(dev);
 	struct net *net = dev_net(dev);
 	struct ip6_tnl_net *ip6n = net_generic(net, ip6_tnl_net_id);
-	int err = ip6_tnl_dev_init_gen(dev);
-
-	if (err)
-		return err;
 
 	t->parms.proto = IPPROTO_IPV6;
 	dev_hold(dev);
 
-	ip6_tnl_link_config(t);
-
 	rcu_assign_pointer(ip6n->tnls_wc[0], t);
 	return 0;
 }
-- 
2.1.3

