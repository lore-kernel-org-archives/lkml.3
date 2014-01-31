Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbaAaIYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 03:24:20 -0500
Received: from 33.106-14-84.ripe.coltfrance.com ([84.14.106.33]:41037 "EHLO
	proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaAaIYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 03:24:16 -0500
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        stable@vger.kernel.org, williams@redhat.com, lclaudio@uudg.org,
        jkacur@redhat.com, willemb@google.com,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH linux-3.10.y v2 1/3] sit: fix double free of fb_tunnel_dev on exit
Date: Fri, 31 Jan 2014 09:24:04 +0100
Message-Id: <1391156646-11981-1-git-send-email-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <20140130171029.01cd80ca@gandalf.local.home>
References: <20140130171029.01cd80ca@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This problem was fixed upstream by commit 9434266f2c64 ("sit: fix use after free
of fb_tunnel_dev").
The upstream patch depends on upstream commit 5e6700b3bf98 ("sit: add support of
x-netns"), which was not backported into 3.10 branch.

First, explain the problem: when the sit module is unloaded, sit_cleanup() is
called.
rmmod sit
=> sit_cleanup()
  => rtnl_link_unregister()
    => __rtnl_kill_links()
      => for_each_netdev(net, dev) {
        if (dev->rtnl_link_ops == ops)
        	ops->dellink(dev, &list_kill);
        }
At this point, the FB device is deleted (and all sit tunnels).
  => unregister_pernet_device()
    => unregister_pernet_operations()
      => ops_exit_list()
        => sit_exit_net()
          => sit_destroy_tunnels()
          In this function, no tunnel is found.
          => unregister_netdevice_queue(sitn->fb_tunnel_dev, &list);
We delete the FB device a second time here!

Because we cannot simply remove the second deletion (sit_exit_net() must remove
the FB device when a netns is deleted), we add an rtnl ops which delete all sit
device excepting the FB device and thus we can keep the explicit deletion in
sit_exit_net().

CC: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Reported-by: Steven Rostedt <srostedt@redhat.com>
Tested-by: Steven Rostedt <srostedt@redhat.com> (and our entire MRG team)
Tested-by: "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Tested-by: John Kacur <jkacur@redhat.com>
---

v2: add Steven's tags

 net/ipv6/sit.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 0491264b8bfc..620d326e8fdd 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1507,6 +1507,15 @@ static const struct nla_policy ipip6_policy[IFLA_IPTUN_MAX + 1] = {
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
@@ -1517,6 +1526,7 @@ static struct rtnl_link_ops sit_link_ops __read_mostly = {
 	.changelink	= ipip6_changelink,
 	.get_size	= ipip6_get_size,
 	.fill_info	= ipip6_fill_info,
+	.dellink	= ipip6_dellink,
 };
 
 static struct xfrm_tunnel sit_handler __read_mostly = {
-- 
1.8.4.1

