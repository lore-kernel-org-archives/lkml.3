Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057Ab3LFVwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:52:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab3LFVwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 22/83] ip6tnl: fix use after free of fb_tnl_dev
Date: Fri,  6 Dec 2013 13:51:12 -0800
Message-Id: <20131206214642.135915718@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ Upstream commit 1e9f3d6f1c403dd2b6270f654b4747147aa2306f ]

Bug has been introduced by commit bb8140947a24 ("ip6tnl: allow to use rtnl ops
on fb tunnel").

When ip6_tunnel.ko is unloaded, FB device is delete by rtnl_link_unregister()
and then we try to use the pointer in ip6_tnl_destroy_tunnels().

Let's add an handler for dellink, which will never remove the FB tunnel. With
this patch it will no more be possible to remove it via 'ip link del ip6tnl0',
but it's safer.

The same fix was already proposed by Willem de Bruijn <willemb@google.com> for
sit interfaces.

CC: Willem de Bruijn <willemb@google.com>
Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_tunnel.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1635,6 +1635,15 @@ static int ip6_tnl_changelink(struct net
 	return ip6_tnl_update(t, &p);
 }
 
+static void ip6_tnl_dellink(struct net_device *dev, struct list_head *head)
+{
+	struct net *net = dev_net(dev);
+	struct ip6_tnl_net *ip6n = net_generic(net, ip6_tnl_net_id);
+
+	if (dev != ip6n->fb_tnl_dev)
+		unregister_netdevice_queue(dev, head);
+}
+
 static size_t ip6_tnl_get_size(const struct net_device *dev)
 {
 	return
@@ -1699,6 +1708,7 @@ static struct rtnl_link_ops ip6_link_ops
 	.validate	= ip6_tnl_validate,
 	.newlink	= ip6_tnl_newlink,
 	.changelink	= ip6_tnl_changelink,
+	.dellink	= ip6_tnl_dellink,
 	.get_size	= ip6_tnl_get_size,
 	.fill_info	= ip6_tnl_fill_info,
 };
@@ -1715,9 +1725,9 @@ static struct xfrm6_tunnel ip6ip6_handle
 	.priority	=	1,
 };
 
-static void __net_exit ip6_tnl_destroy_tunnels(struct ip6_tnl_net *ip6n)
+static void __net_exit ip6_tnl_destroy_tunnels(struct net *net)
 {
-	struct net *net = dev_net(ip6n->fb_tnl_dev);
+	struct ip6_tnl_net *ip6n = net_generic(net, ip6_tnl_net_id);
 	struct net_device *dev, *aux;
 	int h;
 	struct ip6_tnl *t;
@@ -1785,10 +1795,8 @@ err_alloc_dev:
 
 static void __net_exit ip6_tnl_exit_net(struct net *net)
 {
-	struct ip6_tnl_net *ip6n = net_generic(net, ip6_tnl_net_id);
-
 	rtnl_lock();
-	ip6_tnl_destroy_tunnels(ip6n);
+	ip6_tnl_destroy_tunnels(net);
 	rtnl_unlock();
 }
 


