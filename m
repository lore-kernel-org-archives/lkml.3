Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbaBGL4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:56:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42555 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430AbaBGLwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:52:53 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Willem de Bruijn <willemb@google.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 226/233] ip6tnl: fix double free of fb_tnl_dev on exit
Date: Fri,  7 Feb 2014 11:47:25 +0000
Message-Id: <1391773652-25214-227-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ No relevant upstream commit. ]

This problem was fixed upstream by commit 1e9f3d6f1c40 ("ip6tnl: fix use after
free of fb_tnl_dev").
The upstream patch depends on upstream commit 0bd8762824e7 ("ip6tnl: add x-netns
support"), which was not backported into 3.10 branch.

First, explain the problem: when the ip6_tunnel module is unloaded,
ip6_tunnel_cleanup() is called.
rmmod ip6_tunnel
=> ip6_tunnel_cleanup()
  => rtnl_link_unregister()
    => __rtnl_kill_links()
      => for_each_netdev(net, dev) {
        if (dev->rtnl_link_ops == ops)
        	ops->dellink(dev, &list_kill);
        }
At this point, the FB device is deleted (and all ip6tnl tunnels).
  => unregister_pernet_device()
    => unregister_pernet_operations()
      => ops_exit_list()
        => ip6_tnl_exit_net()
          => ip6_tnl_destroy_tunnels()
            => t = rtnl_dereference(ip6n->tnls_wc[0]);
               unregister_netdevice_queue(t->dev, &list);
We delete the FB device a second time here!

The previous fix removes these lines, which fix this double free. But the patch
introduces a memory leak when a netns is destroyed, because the FB device is
never deleted. By adding an rtnl ops which delete all ip6tnl device excepting
the FB device, we can keep this exlicit removal in ip6_tnl_destroy_tunnels().

CC: Steven Rostedt <rostedt@goodmis.org>
CC: Willem de Bruijn <willemb@google.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reported-by: Steven Rostedt <srostedt@redhat.com>
Tested-by: Steven Rostedt <srostedt@redhat.com> (and our entire MRG team)
Tested-by: "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Tested-by: John Kacur <jkacur@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/ip6_tunnel.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index cf5d490..7839b9d 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1623,6 +1623,15 @@ static int ip6_tnl_changelink(struct net_device *dev, struct nlattr *tb[],
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
@@ -1687,6 +1696,7 @@ static struct rtnl_link_ops ip6_link_ops __read_mostly = {
 	.validate	= ip6_tnl_validate,
 	.newlink	= ip6_tnl_newlink,
 	.changelink	= ip6_tnl_changelink,
+	.dellink	= ip6_tnl_dellink,
 	.get_size	= ip6_tnl_get_size,
 	.fill_info	= ip6_tnl_fill_info,
 };
-- 
1.8.3.2

