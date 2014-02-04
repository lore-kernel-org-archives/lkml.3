Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935628AbaBDWln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:41:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56358 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933487AbaBDVCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:02:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Willem de Bruijn <willemb@google.com>,
        Steven Rostedt <srostedt@redhat.com>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH 3.10 087/104] sit: fix double free of fb_tunnel_dev on exit
Date: Tue,  4 Feb 2014 13:02:30 -0800
Message-Id: <20140204210225.173554786@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210222.731641778@linuxfoundation.org>
References: <20140204210222.731641778@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ No relevant upstream commit. ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/sit.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1507,6 +1507,15 @@ static const struct nla_policy ipip6_pol
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
@@ -1517,6 +1526,7 @@ static struct rtnl_link_ops sit_link_ops
 	.changelink	= ipip6_changelink,
 	.get_size	= ipip6_get_size,
 	.fill_info	= ipip6_fill_info,
+	.dellink	= ipip6_dellink,
 };
 
 static struct xfrm_tunnel sit_handler __read_mostly = {


