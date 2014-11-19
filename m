Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868AbaKSWIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:08:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56491 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933355AbaKSVEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:04:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 002/122] ip6_tunnel: Use ip6_tnl_dev_init as the ndo_init function.
Date: Wed, 19 Nov 2014 12:50:52 -0800
Message-Id: <20141119205208.916426805@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205208.812884198@linuxfoundation.org>
References: <20141119205208.812884198@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 6c6151daaf2d8dc2046d9926539feed5f66bf74e ]

ip6_tnl_dev_init() sets the dev->iflink via a call to
ip6_tnl_link_config(). After that, register_netdevice()
sets dev->iflink = -1. So we loose the iflink configuration
for ipv6 tunnels. Fix this by using ip6_tnl_dev_init() as the
ndo_init function. Then ip6_tnl_dev_init() is called after
dev->iflink is set to -1 from register_netdevice().

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_tunnel.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -272,9 +272,6 @@ static int ip6_tnl_create2(struct net_de
 	int err;
 
 	t = netdev_priv(dev);
-	err = ip6_tnl_dev_init(dev);
-	if (err < 0)
-		goto out;
 
 	err = register_netdevice(dev);
 	if (err < 0)
@@ -1456,6 +1453,7 @@ ip6_tnl_change_mtu(struct net_device *de
 
 
 static const struct net_device_ops ip6_tnl_netdev_ops = {
+	.ndo_init	= ip6_tnl_dev_init,
 	.ndo_uninit	= ip6_tnl_dev_uninit,
 	.ndo_start_xmit = ip6_tnl_xmit,
 	.ndo_do_ioctl	= ip6_tnl_ioctl,
@@ -1547,16 +1545,10 @@ static int __net_init ip6_fb_tnl_dev_ini
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


