Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbaLOTus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:50:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40621 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaLOT1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:27:12 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 14/96] vti6: Use vti6_dev_init as the ndo_init function.
Date: Mon, 15 Dec 2014 11:25:34 -0800
Message-Id: <1418671616-25482-15-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 16a0231bf7dc3fb37e9b1f1cb1a277dc220b5c5e ]

vti6_dev_init() sets the dev->iflink via a call to
vti6_link_config(). After that, register_netdevice()
sets dev->iflink = -1. So we loose the iflink configuration
for vti6 tunnels. Fix this by using vti6_dev_init() as the
ndo_init function. Then vti6_dev_init() is called after
dev->iflink is set to -1 from register_netdevice().

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/ip6_vti.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 7b42d5e..bcf7d17 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -173,10 +173,6 @@ static int vti6_tnl_create2(struct net_device *dev)
 	struct vti6_net *ip6n = net_generic(net, vti6_net_id);
 	int err;
 
-	err = vti6_dev_init(dev);
-	if (err < 0)
-		goto out;
-
 	err = register_netdevice(dev);
 	if (err < 0)
 		goto out;
@@ -694,6 +690,7 @@ static int vti6_change_mtu(struct net_device *dev, int new_mtu)
 }
 
 static const struct net_device_ops vti6_netdev_ops = {
+	.ndo_init	= vti6_dev_init,
 	.ndo_uninit	= vti6_dev_uninit,
 	.ndo_start_xmit = vti6_tnl_xmit,
 	.ndo_do_ioctl	= vti6_ioctl,
@@ -773,16 +770,10 @@ static int __net_init vti6_fb_tnl_dev_init(struct net_device *dev)
 	struct ip6_tnl *t = netdev_priv(dev);
 	struct net *net = dev_net(dev);
 	struct vti6_net *ip6n = net_generic(net, vti6_net_id);
-	int err = vti6_dev_init_gen(dev);
-
-	if (err)
-		return err;
 
 	t->parms.proto = IPPROTO_IPV6;
 	dev_hold(dev);
 
-	vti6_link_config(t);
-
 	rcu_assign_pointer(ip6n->tnls_wc[0], t);
 	return 0;
 }
-- 
1.9.1

