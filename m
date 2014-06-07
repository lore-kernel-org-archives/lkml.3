Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbaFGQ0M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 12:26:12 -0400
Received: from mout.web.de ([212.227.15.3]:64036 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104AbaFGQ0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 12:26:06 -0400
From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
To: netdev@vger.kernel.org
Cc: bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
Subject: [PATCHv4 net-next 3/4] bridge: add export of multicast database adjacent to net_dev
Date: Sat,  7 Jun 2014 18:26:28 +0200
Message-Id: <1402158389-13239-4-git-send-email-linus.luessing@web.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402158389-13239-1-git-send-email-linus.luessing@web.de>
References: <1402158389-13239-1-git-send-email-linus.luessing@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:NQdUTGPzeDCnOpoDVvdUN8cGa0W1JDaBshw2qhn/2cW8MpOVhST
 PjRgElXeT12g0CX874L3KzMROOeh8Vuj4q3BuJ0n3UlbBAdpdep5VoPZMONJ81ivIgXAH9j
 DbvHCFgXNGl3w6PFkprp7y22HW+Sbom4ifiSWdL8xQ2qUyosSMH4h8z828zund8j748/s6M
 0QtsDGceAeheX//+Mc1Kg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this new, exported function br_multicast_list_adjacent(net_dev) a
list of IPv4/6 addresses is returned. This list contains all multicast
addresses sensed by the bridge multicast snooping feature on all bridge
ports of the bridge interface of net_dev, excluding addresses from the
specified net_device itself.

Adding bridge support to the batman-adv multicast optimization requires
batman-adv knowing about the existence of bridged-in multicast
listeners to be able to reliably serve them with multicast packets.

Signed-off-by: Linus Lüssing <linus.luessing@web.de>
---
 include/linux/if_bridge.h |   18 ++++++++++++++
 net/bridge/br_multicast.c |   58 +++++++++++++++++++++++++++++++++++++++++++++
 net/bridge/br_private.h   |   12 ----------
 3 files changed, 76 insertions(+), 12 deletions(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 1085ffe..44d6eb0 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -16,9 +16,27 @@
 #include <linux/netdevice.h>
 #include <uapi/linux/if_bridge.h>
 
+struct br_ip {
+	union {
+		__be32	ip4;
+#if IS_ENABLED(CONFIG_IPV6)
+		struct in6_addr ip6;
+#endif
+	} u;
+	__be16		proto;
+	__u16           vid;
+};
+
+struct br_ip_list {
+	struct list_head list;
+	struct br_ip addr;
+};
+
 extern void brioctl_set(int (*ioctl_hook)(struct net *, unsigned int, void __user *));
 
 typedef int br_should_route_hook_t(struct sk_buff *skb);
 extern br_should_route_hook_t __rcu *br_should_route_hook;
+int br_multicast_list_adjacent(struct net_device *dev,
+			       struct list_head *br_ip_list);
 
 #endif
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index b3f17c9..772476b 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/err.h>
+#include <linux/export.h>
 #include <linux/if_ether.h>
 #include <linux/igmp.h>
 #include <linux/jhash.h>
@@ -2141,3 +2142,60 @@ unlock:
 
 	return err;
 }
+
+/**
+ * br_multicast_list_adjacent - Returns snooped multicast addresses
+ * @dev:	The bridge port adjacent to which to retrieve addresses
+ * @br_ip_list:	The list to store found, snooped multicast IP addresses in
+ *
+ * Creates a list of IP addresses (struct br_ip_list) sensed by the multicast
+ * snooping feature on all bridge ports of dev's bridge device, excluding
+ * the addresses from dev itself.
+ *
+ * Returns the number of items added to br_ip_list.
+ *
+ * Notes:
+ * - br_ip_list needs to be initialized by caller
+ * - br_ip_list might contain duplicates in the end
+ *   (needs to be taken care of by caller)
+ * - br_ip_list needs to be freed by caller
+ */
+int br_multicast_list_adjacent(struct net_device *dev,
+			       struct list_head *br_ip_list)
+{
+	struct net_bridge *br;
+	struct net_bridge_port *port;
+	struct net_bridge_port_group *group;
+	struct br_ip_list *entry;
+	int count = 0;
+
+	rcu_read_lock();
+	if (!br_ip_list || !br_port_exists(dev))
+		goto unlock;
+
+	port = br_port_get_rcu(dev);
+	if (!port || !port->br)
+		goto unlock;
+
+	br = port->br;
+
+	list_for_each_entry_rcu(port, &br->port_list, list) {
+		if (!port->dev || port->dev == dev)
+			continue;
+
+		hlist_for_each_entry_rcu(group, &port->mglist, mglist) {
+			entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
+			if (!entry)
+				goto unlock;
+
+			entry->addr = group->addr;
+			list_add(&entry->list, br_ip_list);
+			count++;
+		}
+	}
+
+unlock:
+	rcu_read_unlock();
+	return count;
+}
+EXPORT_SYMBOL_GPL(br_multicast_list_adjacent);
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 97c5e46..50e2ab0 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -54,18 +54,6 @@ struct mac_addr
 	unsigned char	addr[ETH_ALEN];
 };
 
-struct br_ip
-{
-	union {
-		__be32	ip4;
-#if IS_ENABLED(CONFIG_IPV6)
-		struct in6_addr ip6;
-#endif
-	} u;
-	__be16		proto;
-	__u16		vid;
-};
-
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
 /* our own querier */
 struct bridge_mcast_own_query {
-- 
1.7.10.4

