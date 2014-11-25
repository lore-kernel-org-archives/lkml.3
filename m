Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbaKYKza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:55:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59086 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaKYKnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 215/254] ip6_tunnel: Use ip6_tnl_dev_init as the ndo_init function.
Date: Tue, 25 Nov 2014 10:39:25 +0000
Message-Id: <1416912004-5928-216-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Klassert <steffen.klassert@secunet.com>

commit 6c6151daaf2d8dc2046d9926539feed5f66bf74e upstream.

ip6_tnl_dev_init() sets the dev->iflink via a call to
ip6_tnl_link_config(). After that, register_netdevice()
sets dev->iflink = -1. So we loose the iflink configuration
for ipv6 tunnels. Fix this by using ip6_tnl_dev_init() as the
ndo_init function. Then ip6_tnl_dev_init() is called after
dev->iflink is set to -1 from register_netdevice().

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/ip6_tunnel.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index afa082458360..9fd04fff7fea 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -272,9 +272,6 @@ static int ip6_tnl_create2(struct net_device *dev)
 	int err;
 
 	t = netdev_priv(dev);
-	err = ip6_tnl_dev_init(dev);
-	if (err < 0)
-		goto out;
 
 	err = register_netdevice(dev);
 	if (err < 0)
@@ -1456,6 +1453,7 @@ ip6_tnl_change_mtu(struct net_device *dev, int new_mtu)
 
 
 static const struct net_device_ops ip6_tnl_netdev_ops = {
+	.ndo_init	= ip6_tnl_dev_init,
 	.ndo_uninit	= ip6_tnl_dev_uninit,
 	.ndo_start_xmit = ip6_tnl_xmit,
 	.ndo_do_ioctl	= ip6_tnl_ioctl,
@@ -1540,16 +1538,10 @@ static int __net_init ip6_fb_tnl_dev_init(struct net_device *dev)
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
2.1.0

