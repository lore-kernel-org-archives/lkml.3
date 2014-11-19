Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505AbaKSVE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:04:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933341AbaKSVEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:04:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 003/122] vti6: Use vti6_dev_init as the ndo_init function.
Date: Wed, 19 Nov 2014 12:50:53 -0800
Message-Id: <20141119205208.953422924@linuxfoundation.org>
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

[ Upstream commit 16a0231bf7dc3fb37e9b1f1cb1a277dc220b5c5e ]

vti6_dev_init() sets the dev->iflink via a call to
vti6_link_config(). After that, register_netdevice()
sets dev->iflink = -1. So we loose the iflink configuration
for vti6 tunnels. Fix this by using vti6_dev_init() as the
ndo_init function. Then vti6_dev_init() is called after
dev->iflink is set to -1 from register_netdevice().

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_vti.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -172,10 +172,6 @@ static int vti6_tnl_create2(struct net_d
 	struct vti6_net *ip6n = net_generic(net, vti6_net_id);
 	int err;
 
-	err = vti6_dev_init(dev);
-	if (err < 0)
-		goto out;
-
 	err = register_netdevice(dev);
 	if (err < 0)
 		goto out;
@@ -693,6 +689,7 @@ static int vti6_change_mtu(struct net_de
 }
 
 static const struct net_device_ops vti6_netdev_ops = {
+	.ndo_init	= vti6_dev_init,
 	.ndo_uninit	= vti6_dev_uninit,
 	.ndo_start_xmit = vti6_tnl_xmit,
 	.ndo_do_ioctl	= vti6_ioctl,
@@ -772,16 +769,10 @@ static int __net_init vti6_fb_tnl_dev_in
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


