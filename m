Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbaE2EwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:52:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58579 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933167AbaE2Eif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:38:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dmitry Kozlov <xeb@mail.ru>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 51/86] ip6_gre: dont allow to remove the fb_tunnel_dev
Date: Wed, 28 May 2014 21:37:26 -0700
Message-Id: <20140529043520.404997873@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043513.451722422@linuxfoundation.org>
References: <20140529043513.451722422@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_gre.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1549,6 +1549,15 @@ static int ip6gre_changelink(struct net_
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
@@ -1626,6 +1635,7 @@ static struct rtnl_link_ops ip6gre_link_
 	.validate	= ip6gre_tunnel_validate,
 	.newlink	= ip6gre_newlink,
 	.changelink	= ip6gre_changelink,
+	.dellink	= ip6gre_dellink,
 	.get_size	= ip6gre_get_size,
 	.fill_info	= ip6gre_fill_info,
 };


