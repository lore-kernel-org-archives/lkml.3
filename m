Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbaKYKna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:43:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59092 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbaKYKnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 217/254] sit: Use ipip6_tunnel_init as the ndo_init function.
Date: Tue, 25 Nov 2014 10:39:27 +0000
Message-Id: <1416912004-5928-218-git-send-email-luis.henriques@canonical.com>
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

commit ebe084aafb7e93adf210e80043c9f69adf56820d upstream.

ipip6_tunnel_init() sets the dev->iflink via a call to
ipip6_tunnel_bind_dev(). After that, register_netdevice()
sets dev->iflink = -1. So we loose the iflink configuration
for ipv6 tunnels. Fix this by using ipip6_tunnel_init() as the
ndo_init function. Then ipip6_tunnel_init() is called after
dev->iflink is set to -1 from register_netdevice().

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/sit.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 9906535ce9de..051e9c508933 100644
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
@@ -1313,6 +1312,7 @@ static int ipip6_tunnel_change_mtu(struct net_device *dev, int new_mtu)
 }
 
 static const struct net_device_ops ipip6_netdev_ops = {
+	.ndo_init	= ipip6_tunnel_init,
 	.ndo_uninit	= ipip6_tunnel_uninit,
 	.ndo_start_xmit	= sit_tunnel_xmit,
 	.ndo_do_ioctl	= ipip6_tunnel_ioctl,
@@ -1358,9 +1358,7 @@ static int ipip6_tunnel_init(struct net_device *dev)
 
 	tunnel->dev = dev;
 	tunnel->net = dev_net(dev);
-
-	memcpy(dev->dev_addr, &tunnel->parms.iph.saddr, 4);
-	memcpy(dev->broadcast, &tunnel->parms.iph.daddr, 4);
+	strcpy(tunnel->parms.name, dev->name);
 
 	ipip6_tunnel_bind_dev(dev);
 	dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
@@ -1385,7 +1383,6 @@ static int __net_init ipip6_fb_tunnel_init(struct net_device *dev)
 
 	tunnel->dev = dev;
 	tunnel->net = dev_net(dev);
-	strcpy(tunnel->parms.name, dev->name);
 
 	iph->version		= 4;
 	iph->protocol		= IPPROTO_IPV6;
-- 
2.1.0

