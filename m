Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967068AbaFQWuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:50:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53683 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965513AbaFQVpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:45:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Kozlov <xeb@mail.ru>, Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 015/212] ip6_gre: don't allow to remove the fb_tunnel_dev
Date: Tue, 17 Jun 2014 14:41:49 -0700
Message-Id: <1403041506-13646-16-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/ip6_gre.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 8acb286..01ee297 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1569,6 +1569,15 @@ static int ip6gre_changelink(struct net_device *dev, struct nlattr *tb[],
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
@@ -1646,6 +1655,7 @@ static struct rtnl_link_ops ip6gre_link_ops __read_mostly = {
 	.validate	= ip6gre_tunnel_validate,
 	.newlink	= ip6gre_newlink,
 	.changelink	= ip6gre_changelink,
+	.dellink	= ip6gre_dellink,
 	.get_size	= ip6gre_get_size,
 	.fill_info	= ip6gre_fill_info,
 };
-- 
1.9.1

