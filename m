Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761162Ab3LIOs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 09:48:59 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:55649 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754965Ab3LIOs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 09:48:56 -0500
Date: Mon, 9 Dec 2013 09:48:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Clark Williams <williams@redhat.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Subject: Re: [BUG] stable v3.10.16+ introduced by "ip6tnl: allow to use rtnl
 ops on fb tunnel"
Message-ID: <20131209094850.4e97e370@gandalf.local.home>
In-Reply-To: <20131209002531.GB14382@kroah.com>
References: <20131113211430.1ad3bb7d@gandalf.local.home>
	<20131209002531.GB14382@kroah.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Dec 2013 16:25:31 -0800
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:


> > Which, when applied to 3.10.18, fixes the bug. Was there a reason that
> > this part of the commit wasn't backported? or was this just an oversight?
> 
> It looks like it was left out to me as well.
> 
> David, any objection to me making this fixup in the 3.10-stable tree?

I'm not sure my fix up was the right thing to do. I believe upstream
commit 1e9f3d6f1c403 "ip6tnl: fix use after free of fb_tnl_dev" which
was ported back to 3.12 stable, is the correct fix.

I even backported that commit to 3.10 and tested it, and the bug did
indeed go away.

-- Steve

ip6tnl: fix use after free of fb_tnl_dev

commit 1e9f3d6f1c403dd2b6270f654b4747147aa2306f upstream.

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
---
 net/ipv6/ip6_tunnel.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

Index: linux-trace.git/net/ipv6/ip6_tunnel.c
===================================================================
--- linux-trace.git.orig/net/ipv6/ip6_tunnel.c
+++ linux-trace.git/net/ipv6/ip6_tunnel.c
@@ -1617,6 +1617,15 @@ static int ip6_tnl_changelink(struct net
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
@@ -1681,6 +1690,7 @@ static struct rtnl_link_ops ip6_link_ops
 	.validate	= ip6_tnl_validate,
 	.newlink	= ip6_tnl_newlink,
 	.changelink	= ip6_tnl_changelink,
+	.dellink	= ip6_tnl_dellink,
 	.get_size	= ip6_tnl_get_size,
 	.fill_info	= ip6_tnl_fill_info,
 };
@@ -1697,10 +1707,11 @@ static struct xfrm6_tunnel ip6ip6_handle
 	.priority	=	1,
 };
 
-static void __net_exit ip6_tnl_destroy_tunnels(struct ip6_tnl_net *ip6n)
+static void __net_exit ip6_tnl_destroy_tunnels(struct net *net)
 {
 	int h;
 	struct ip6_tnl *t;
+	struct ip6_tnl_net *ip6n = net_generic(net, ip6_tnl_net_id);
 	LIST_HEAD(list);
 
 	for (h = 0; h < HASH_SIZE; h++) {
@@ -1755,10 +1766,8 @@ err_alloc_dev:
 
 static void __net_exit ip6_tnl_exit_net(struct net *net)
 {
-	struct ip6_tnl_net *ip6n = net_generic(net, ip6_tnl_net_id);
-
 	rtnl_lock();
-	ip6_tnl_destroy_tunnels(ip6n);
+	ip6_tnl_destroy_tunnels(net);
 	rtnl_unlock();
 }
 
