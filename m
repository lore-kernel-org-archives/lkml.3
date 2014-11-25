Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbaKYKn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:43:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59090 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbaKYKnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 216/254] vti6: Use vti6_dev_init as the ndo_init function.
Date: Tue, 25 Nov 2014 10:39:26 +0000
Message-Id: <1416912004-5928-217-git-send-email-luis.henriques@canonical.com>
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

commit 16a0231bf7dc3fb37e9b1f1cb1a277dc220b5c5e upstream.

vti6_dev_init() sets the dev->iflink via a call to
vti6_link_config(). After that, register_netdevice()
sets dev->iflink = -1. So we loose the iflink configuration
for vti6 tunnels. Fix this by using vti6_dev_init() as the
ndo_init function. Then vti6_dev_init() is called after
dev->iflink is set to -1 from register_netdevice().

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/ip6_vti.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index 9aaa6bb229e4..f3ce1cbc0bc5 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -172,10 +172,6 @@ static int vti6_tnl_create2(struct net_device *dev)
 	struct vti6_net *ip6n = net_generic(net, vti6_net_id);
 	int err;
 
-	err = vti6_dev_init(dev);
-	if (err < 0)
-		goto out;
-
 	err = register_netdevice(dev);
 	if (err < 0)
 		goto out;
@@ -779,6 +775,7 @@ static int vti6_change_mtu(struct net_device *dev, int new_mtu)
 }
 
 static const struct net_device_ops vti6_netdev_ops = {
+	.ndo_init	= vti6_dev_init,
 	.ndo_uninit	= vti6_dev_uninit,
 	.ndo_start_xmit = vti6_tnl_xmit,
 	.ndo_do_ioctl	= vti6_ioctl,
@@ -848,16 +845,10 @@ static int __net_init vti6_fb_tnl_dev_init(struct net_device *dev)
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
2.1.0

