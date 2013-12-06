Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759641Ab3LFWjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:39:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758882Ab3LFVwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 20/83] sit: fix use after free of fb_tunnel_dev
Date: Fri,  6 Dec 2013 13:51:10 -0800
Message-Id: <20131206214641.950695318@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 9434266f2c645d4fcf62a03a8e36ad8075e37943 ]

Bug: The fallback device is created in sit_init_net and assumed to be
freed in sit_exit_net. First, it is dereferenced in that function, in
sit_destroy_tunnels:

        struct net *net = dev_net(sitn->fb_tunnel_dev);

Prior to this, rtnl_unlink_register has removed all devices that match
rtnl_link_ops == sit_link_ops.

Commit 205983c43700 added the line

+       sitn->fb_tunnel_dev->rtnl_link_ops = &sit_link_ops;

which cases the fallback device to match here and be freed before it
is last dereferenced.

Fix: This commit adds an explicit .delllink callback to sit_link_ops
that skips deallocation at rtnl_unlink_register for the fallback
device. This mechanism is comparable to the one in ip_tunnel.

It also modifies sit_destroy_tunnels and its only caller sit_exit_net
to avoid the offending dereference in the first place. That double
lookup is more complicated than required.

Test: The bug is only triggered when CONFIG_NET_NS is enabled. It
causes a GPF only when CONFIG_DEBUG_SLAB is enabled. Verified that
this bug exists at the mentioned commit, at davem-net HEAD and at
3.11.y HEAD. Verified that it went away after applying this patch.

Fixes: 205983c43700 ("sit: allow to use rtnl ops on fb tunnel")

Signed-off-by: Willem de Bruijn <willemb@google.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/sit.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1594,6 +1594,15 @@ static const struct nla_policy ipip6_pol
 #endif
 };
 
+static void ipip6_dellink(struct net_device *dev, struct list_head *head)
+{
+	struct net *net = dev_net(dev);
+	struct sit_net *sitn = net_generic(net, sit_net_id);
+
+	if (dev != sitn->fb_tunnel_dev)
+		unregister_netdevice_queue(dev, head);
+}
+
 static struct rtnl_link_ops sit_link_ops __read_mostly = {
 	.kind		= "sit",
 	.maxtype	= IFLA_IPTUN_MAX,
@@ -1605,6 +1614,7 @@ static struct rtnl_link_ops sit_link_ops
 	.changelink	= ipip6_changelink,
 	.get_size	= ipip6_get_size,
 	.fill_info	= ipip6_fill_info,
+	.dellink	= ipip6_dellink,
 };
 
 static struct xfrm_tunnel sit_handler __read_mostly = {
@@ -1619,9 +1629,10 @@ static struct xfrm_tunnel ipip_handler _
 	.priority	=	2,
 };
 
-static void __net_exit sit_destroy_tunnels(struct sit_net *sitn, struct list_head *head)
+static void __net_exit sit_destroy_tunnels(struct net *net,
+					   struct list_head *head)
 {
-	struct net *net = dev_net(sitn->fb_tunnel_dev);
+	struct sit_net *sitn = net_generic(net, sit_net_id);
 	struct net_device *dev, *aux;
 	int prio;
 
@@ -1696,11 +1707,10 @@ err_alloc_dev:
 
 static void __net_exit sit_exit_net(struct net *net)
 {
-	struct sit_net *sitn = net_generic(net, sit_net_id);
 	LIST_HEAD(list);
 
 	rtnl_lock();
-	sit_destroy_tunnels(sitn, &list);
+	sit_destroy_tunnels(net, &list);
 	unregister_netdevice_many(&list);
 	rtnl_unlock();
 }


