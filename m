Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934804AbaE2ODv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:03:51 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59438 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933348AbaE2Ntc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Dmitry Kozlov <xeb@mail.ru>, "David S. Miller" <davem@davemloft.net>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 069/103] ip6_gre: don't allow to remove the fb_tunnel_dev
Date: Thu, 29 May 2014 15:48:54 +0200
Message-Id: <3565e1853b7ac1104a1eb56360c3bf1d4419660b.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 54d63f787b652755e66eb4dd8892ee6d3f5197fc ]

It's possible to remove the FB tunnel with the command 'ip link del ip6gre0' but
this is unsafe, the module always supposes that this device exists. For example,
ip6gre_tunnel_lookup() may use it unconditionally.

Let's add a rtnl handler for dellink, which will never remove the FB tunnel (we
let ip6gre_destroy_tunnels() do the job).

Introduced by commit c12b395a4664 ("gre: Support GRE over IPv6").

CC: Dmitry Kozlov <xeb@mail.ru>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv6/ip6_gre.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index bf4a9a084de5..994d73cc2fe0 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1554,6 +1554,15 @@ static int ip6gre_changelink(struct net_device *dev, struct nlattr *tb[],
 	return 0;
 }
 
+static void ip6gre_dellink(struct net_device *dev, struct list_head *head)
+{
+	struct net *net = dev_net(dev);
+	struct ip6gre_net *ign = net_generic(net, ip6gre_net_id);
+
+	if (dev != ign->fb_tunnel_dev)
+		unregister_netdevice_queue(dev, head);
+}
+
 static size_t ip6gre_get_size(const struct net_device *dev)
 {
 	return
@@ -1631,6 +1640,7 @@ static struct rtnl_link_ops ip6gre_link_ops __read_mostly = {
 	.validate	= ip6gre_tunnel_validate,
 	.newlink	= ip6gre_newlink,
 	.changelink	= ip6gre_changelink,
+	.dellink	= ip6gre_dellink,
 	.get_size	= ip6gre_get_size,
 	.fill_info	= ip6gre_fill_info,
 };
-- 
1.9.3

