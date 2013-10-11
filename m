Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114Ab3JKUNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:13:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46096 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325Ab3JKTlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hong Zhiguo <zhiguohong@tencent.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 024/135] bridge: use br_port_get_rtnl within rtnl lock
Date: Fri, 11 Oct 2013 12:38:25 -0700
Message-Id: <20131011193947.851751846@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hong Zhiguo <zhiguohong@tencent.com>

[ Upstream commit 1fb1754a8c70d69ab480763c423e0a74369c4a67 ]

current br_port_get_rcu is problematic in bridging path
(NULL deref). Change these calls in netlink path first.

Signed-off-by: Hong Zhiguo <zhiguohong@tencent.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_netlink.c |    4 ++--
 net/bridge/br_private.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -207,7 +207,7 @@ int br_getlink(struct sk_buff *skb, u32
 	       struct net_device *dev, u32 filter_mask)
 {
 	int err = 0;
-	struct net_bridge_port *port = br_port_get_rcu(dev);
+	struct net_bridge_port *port = br_port_get_rtnl(dev);
 
 	/* not a bridge port and  */
 	if (!port && !(filter_mask & RTEXT_FILTER_BRVLAN))
@@ -451,7 +451,7 @@ static size_t br_get_link_af_size(const
 	struct net_port_vlans *pv;
 
 	if (br_port_exists(dev))
-		pv = nbp_get_vlan_info(br_port_get_rcu(dev));
+		pv = nbp_get_vlan_info(br_port_get_rtnl(dev));
 	else if (dev->priv_flags & IFF_EBRIDGE)
 		pv = br_get_vlan_info((struct net_bridge *)netdev_priv(dev));
 	else
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -208,7 +208,7 @@ static inline struct net_bridge_port *br
 	return br_port_exists(dev) ? port : NULL;
 }
 
-static inline struct net_bridge_port *br_port_get_rtnl(struct net_device *dev)
+static inline struct net_bridge_port *br_port_get_rtnl(const struct net_device *dev)
 {
 	return br_port_exists(dev) ?
 		rtnl_dereference(dev->rx_handler_data) : NULL;


