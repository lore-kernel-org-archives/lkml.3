Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaEYFDP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 01:03:15 -0400
Received: from mout.web.de ([212.227.15.3]:57215 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbaEYFDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 01:03:06 -0400
From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
To: netdev@vger.kernel.org
Cc: bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
Subject: [PATCHv2 net-next 4/4] bridge: memorize and export selected IGMP/MLD querier port
Date: Sun, 25 May 2014 07:03:25 +0200
Message-Id: <1400994205-31165-5-git-send-email-linus.luessing@web.de>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1400994205-31165-1-git-send-email-linus.luessing@web.de>
References: <1400994205-31165-1-git-send-email-linus.luessing@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:ew7UAZyqf044UHC7uImK+HDpgrWJy6tQVLGsj8AiTgU4htFZ1Qy
 EpIISV5UBnQNTxisJ3TlI18U/P/dWcC7Qf7gA6gBlVKMfi3wg9Wit60cklY1cn9h199cWcF
 OHWtuaCKC8E6guf0+RrkodZ2MmwAhT6VA/e1CC9h5O6Xfg3ivRrQvYIrTXtvjqKGMt0LyRB
 BOu0bnqz1ggkgkydoKgbw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding bridge support to the batman-adv multicast optimization requires
batman-adv knowing about the existence of bridged-in IGMP/MLD queriers
to be able to reliably serve any multicast listener behind this same
bridge.

Signed-off-by: Linus Lüssing <linus.luessing@web.de>
---
 include/linux/if_bridge.h |    1 +
 net/bridge/br_multicast.c |   72 +++++++++++++++++++++++++++++++++++++++++----
 net/bridge/br_private.h   |    1 +
 3 files changed, 68 insertions(+), 6 deletions(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 44d6eb0..fd22789 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -38,5 +38,6 @@ typedef int br_should_route_hook_t(struct sk_buff *skb);
 extern br_should_route_hook_t __rcu *br_should_route_hook;
 int br_multicast_list_adjacent(struct net_device *dev,
 			       struct list_head *br_ip_list);
+bool br_multicast_has_querier_adjacent(struct net_device *dev, int proto);
 
 #endif
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 807e535..3c9b405 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1081,6 +1081,7 @@ static int br_ip6_multicast_mld2_report(struct net_bridge *br,
 #endif
 
 static bool br_ip4_multicast_select_querier(struct net_bridge *br,
+					    struct net_bridge_port *port,
 					    __be32 saddr)
 {
 	if (!timer_pending(&br->ip4_own_query.timer) &&
@@ -1098,11 +1099,15 @@ static bool br_ip4_multicast_select_querier(struct net_bridge *br,
 update:
 	br->ip4_querier.addr.u.ip4 = saddr;
 
+	/* update protected by general multicast_lock by caller */
+	rcu_assign_pointer(br->ip4_querier.port, port);
+
 	return true;
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
 static bool br_ip6_multicast_select_querier(struct net_bridge *br,
+					    struct net_bridge_port *port,
 					    struct in6_addr *saddr)
 {
 	if (!timer_pending(&br->ip6_own_query.timer) &&
@@ -1117,19 +1122,23 @@ static bool br_ip6_multicast_select_querier(struct net_bridge *br,
 update:
 	br->ip6_querier.addr.u.ip6 = *saddr;
 
+	/* update protected by general multicast_lock by caller */
+	rcu_assign_pointer(br->ip6_querier.port, port);
+
 	return true;
 }
 #endif
 
 static bool br_multicast_select_querier(struct net_bridge *br,
+					struct net_bridge_port *port,
 					struct br_ip *saddr)
 {
 	switch (saddr->proto) {
 	case htons(ETH_P_IP):
-		return br_ip4_multicast_select_querier(br, saddr->u.ip4);
+		return br_ip4_multicast_select_querier(br, port, saddr->u.ip4);
 #if IS_ENABLED(CONFIG_IPV6)
 	case htons(ETH_P_IPV6):
-		return br_ip6_multicast_select_querier(br, &saddr->u.ip6);
+		return br_ip6_multicast_select_querier(br, port, &saddr->u.ip6);
 #endif
 	}
 
@@ -1201,7 +1210,7 @@ static void br_multicast_query_received(struct net_bridge *br,
 					struct br_ip *saddr,
 					unsigned long max_delay)
 {
-	if (!br_multicast_select_querier(br, saddr))
+	if (!br_multicast_select_querier(br, port, saddr))
 		return;
 
 	br_multicast_update_query_timer(br, query, max_delay);
@@ -1804,12 +1813,14 @@ int br_multicast_rcv(struct net_bridge *br, struct net_bridge_port *port,
 }
 
 static void br_multicast_query_expired(struct net_bridge *br,
-				       struct bridge_mcast_own_query *query)
+				       struct bridge_mcast_own_query *query,
+				       struct bridge_mcast_querier *querier)
 {
 	spin_lock(&br->multicast_lock);
 	if (query->startup_sent < br->multicast_startup_query_count)
 		query->startup_sent++;
 
+	rcu_assign_pointer(querier, NULL);
 	br_multicast_send_query(br, NULL, query);
 	spin_unlock(&br->multicast_lock);
 }
@@ -1818,7 +1829,7 @@ static void br_ip4_multicast_query_expired(unsigned long data)
 {
 	struct net_bridge *br = (void *)data;
 
-	br_multicast_query_expired(br, &br->ip4_own_query);
+	br_multicast_query_expired(br, &br->ip4_own_query, &br->ip4_querier);
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -1826,7 +1837,7 @@ static void br_ip6_multicast_query_expired(unsigned long data)
 {
 	struct net_bridge *br = (void *)data;
 
-	br_multicast_query_expired(br, &br->ip6_own_query);
+	br_multicast_query_expired(br, &br->ip6_own_query, &br->ip6_querier);
 }
 #endif
 
@@ -1849,8 +1860,10 @@ void br_multicast_init(struct net_bridge *br)
 	br->multicast_membership_interval = 260 * HZ;
 
 	br->ip4_other_query.delay_time = 0;
+	br->ip4_querier.port = NULL;
 #if IS_ENABLED(CONFIG_IPV6)
 	br->ip6_other_query.delay_time = 0;
+	br->ip6_querier.port = NULL;
 #endif
 
 	spin_lock_init(&br->multicast_lock);
@@ -2199,3 +2212,50 @@ unlock:
 	return count;
 }
 EXPORT_SYMBOL(br_multicast_list_adjacent);
+
+/**
+ * br_multicast_has_querier_adjacent - Checks for a querier behind a bridge port
+ * @dev: The bridge port adjacent to which to check for a querier
+ * @proto: The protocol family to check for: IGMP -> ETH_P_IP, MLD -> ETH_P_IPV6
+ *
+ * Checks whether the given interface has a bridge on top and if so returns
+ * true if a selected querier is behind one of the other ports of this
+ * bridge. Otherwise returns false.
+ */
+bool br_multicast_has_querier_adjacent(struct net_device *dev, int proto)
+{
+	struct net_bridge *br;
+	struct net_bridge_port *port;
+	bool ret = false;
+
+	rcu_read_lock();
+	if (!br_port_exists(dev))
+		goto unlock;
+
+	port = br_port_get_rcu(dev);
+	if (!port || !port->br)
+		goto unlock;
+
+	br = port->br;
+
+	switch (proto) {
+	case ETH_P_IP:
+		if (!timer_pending(&br->ip4_other_query.timer) ||
+		    rcu_dereference(br->ip4_querier.port) == port)
+			goto unlock;
+		break;
+	case ETH_P_IPV6:
+		if (!timer_pending(&br->ip6_other_query.timer) ||
+		    rcu_dereference(br->ip6_querier.port) == port)
+			goto unlock;
+		break;
+	default:
+		goto unlock;
+	}
+
+	ret = true;
+unlock:
+	rcu_read_unlock();
+	return ret;
+}
+EXPORT_SYMBOL(br_multicast_has_querier_adjacent);
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index cb704a6..625d1bf 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -70,6 +70,7 @@ struct bridge_mcast_other_query {
 /* selected querier */
 struct bridge_mcast_querier {
 	struct br_ip addr;
+	struct net_bridge_port __rcu	*port;
 };
 #endif
 
-- 
1.7.10.4

