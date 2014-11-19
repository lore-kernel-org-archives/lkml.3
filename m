Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934383AbaKSW37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:29:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56055 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349AbaKSUx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:53:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 006/141] sit: Use ipip6_tunnel_init as the ndo_init function.
Date: Wed, 19 Nov 2014 12:50:29 -0800
Message-Id: <20141119205150.897143111@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit ebe084aafb7e93adf210e80043c9f69adf56820d ]

ipip6_tunnel_init() sets the dev->iflink via a call to
ipip6_tunnel_bind_dev(). After that, register_netdevice()
sets dev->iflink = -1. So we loose the iflink configuration
for ipv6 tunnels. Fix this by using ipip6_tunnel_init() as the
ndo_init function. Then ipip6_tunnel_init() is called after
dev->iflink is set to -1 from register_netdevice().

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/sit.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -195,10 +195,8 @@ static int ipip6_tunnel_create(struct ne
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
@@ -207,7 +205,8 @@ static int ipip6_tunnel_create(struct ne
 	if (err < 0)
 		goto out;
 
-	strcpy(t->parms.name, dev->name);
+	ipip6_tunnel_clone_6rd(dev, sitn);
+
 	dev->rtnl_link_ops = &sit_link_ops;
 
 	dev_hold(dev);
@@ -1314,6 +1313,7 @@ static int ipip6_tunnel_change_mtu(struc
 }
 
 static const struct net_device_ops ipip6_netdev_ops = {
+	.ndo_init	= ipip6_tunnel_init,
 	.ndo_uninit	= ipip6_tunnel_uninit,
 	.ndo_start_xmit	= sit_tunnel_xmit,
 	.ndo_do_ioctl	= ipip6_tunnel_ioctl,
@@ -1359,9 +1359,7 @@ static int ipip6_tunnel_init(struct net_
 
 	tunnel->dev = dev;
 	tunnel->net = dev_net(dev);
-
-	memcpy(dev->dev_addr, &tunnel->parms.iph.saddr, 4);
-	memcpy(dev->broadcast, &tunnel->parms.iph.daddr, 4);
+	strcpy(tunnel->parms.name, dev->name);
 
 	ipip6_tunnel_bind_dev(dev);
 	dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
@@ -1386,7 +1384,6 @@ static int __net_init ipip6_fb_tunnel_in
 
 	tunnel->dev = dev;
 	tunnel->net = dev_net(dev);
-	strcpy(tunnel->parms.name, dev->name);
 
 	iph->version		= 4;
 	iph->protocol		= IPPROTO_IPV6;


