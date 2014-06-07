Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbaFGQZz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 12:25:55 -0400
Received: from mout.web.de ([212.227.17.11]:57574 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930AbaFGQZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 12:25:53 -0400
From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
To: netdev@vger.kernel.org
Cc: bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
Subject: [PATCHv4 net-next 1/4] bridge: rename struct bridge_mcast_query/querier
Date: Sat,  7 Jun 2014 18:26:26 +0200
Message-Id: <1402158389-13239-2-git-send-email-linus.luessing@web.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402158389-13239-1-git-send-email-linus.luessing@web.de>
References: <1402158389-13239-1-git-send-email-linus.luessing@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:s46cmRAU7CyIDTLbUqcKDZw796cwBhzhMQK+s178Qt20euHPFEK
 Wy5Pe82ULAMJRBZDeVj3PQyeZJmwkVZUG2oAJfQYK30aIHcuA+SIT/pSh3Zxu+PcJTNClBt
 yWzoA5J25yEZn/aU3b32MZFQMRW2RJwHrZXRrMn6MGZZKson8uvzuB5DFcLBKXFhcJCc1vd
 gA9uAagu3gNFN9sVaFTCg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current naming of these two structs is very random, in that
reversing their naming would not make any semantical difference.

This patch tries to make the naming less confusing by giving them a more
specific, distinguishable naming.

This is also useful for the upcoming patches reintroducing the
"struct bridge_mcast_querier" but for storing information about the
selected querier (no matter if our own or a foreign querier).

Signed-off-by: Linus Lüssing <linus.luessing@web.de>
---
 net/bridge/br_mdb.c       |    4 +-
 net/bridge/br_multicast.c |  169 +++++++++++++++++++++++----------------------
 net/bridge/br_private.h   |   22 +++---
 3 files changed, 100 insertions(+), 95 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index b7b1914..5df0526 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -418,13 +418,13 @@ static int __br_mdb_del(struct net_bridge *br, struct br_mdb_entry *entry)
 
 	ip.proto = entry->addr.proto;
 	if (ip.proto == htons(ETH_P_IP)) {
-		if (timer_pending(&br->ip4_querier.timer))
+		if (timer_pending(&br->ip4_other_query.timer))
 			return -EBUSY;
 
 		ip.u.ip4 = entry->addr.u.ip4;
 #if IS_ENABLED(CONFIG_IPV6)
 	} else {
-		if (timer_pending(&br->ip6_querier.timer))
+		if (timer_pending(&br->ip6_other_query.timer))
 			return -EBUSY;
 
 		ip.u.ip6 = entry->addr.u.ip6;
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 7b757b5..5ccac62 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -35,7 +35,7 @@
 #include "br_private.h"
 
 static void br_multicast_start_querier(struct net_bridge *br,
-				       struct bridge_mcast_query *query);
+				       struct bridge_mcast_own_query *query);
 unsigned int br_mdb_rehash_seq;
 
 static inline int br_ip_equal(const struct br_ip *a, const struct br_ip *b)
@@ -761,7 +761,7 @@ static void br_multicast_local_router_expired(unsigned long data)
 }
 
 static void br_multicast_querier_expired(struct net_bridge *br,
-					 struct bridge_mcast_query *query)
+					 struct bridge_mcast_own_query *query)
 {
 	spin_lock(&br->multicast_lock);
 	if (!netif_running(br->dev) || br->multicast_disabled)
@@ -777,7 +777,7 @@ static void br_ip4_multicast_querier_expired(unsigned long data)
 {
 	struct net_bridge *br = (void *)data;
 
-	br_multicast_querier_expired(br, &br->ip4_query);
+	br_multicast_querier_expired(br, &br->ip4_own_query);
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -785,7 +785,7 @@ static void br_ip6_multicast_querier_expired(unsigned long data)
 {
 	struct net_bridge *br = (void *)data;
 
-	br_multicast_querier_expired(br, &br->ip6_query);
+	br_multicast_querier_expired(br, &br->ip6_own_query);
 }
 #endif
 
@@ -810,11 +810,11 @@ static void __br_multicast_send_query(struct net_bridge *br,
 
 static void br_multicast_send_query(struct net_bridge *br,
 				    struct net_bridge_port *port,
-				    struct bridge_mcast_query *query)
+				    struct bridge_mcast_own_query *own_query)
 {
 	unsigned long time;
 	struct br_ip br_group;
-	struct bridge_mcast_querier *querier = NULL;
+	struct bridge_mcast_other_query *other_query = NULL;
 
 	if (!netif_running(br->dev) || br->multicast_disabled ||
 	    !br->multicast_querier)
@@ -822,31 +822,32 @@ static void br_multicast_send_query(struct net_bridge *br,
 
 	memset(&br_group.u, 0, sizeof(br_group.u));
 
-	if (port ? (query == &port->ip4_query) :
-		   (query == &br->ip4_query)) {
-		querier = &br->ip4_querier;
+	if (port ? (own_query == &port->ip4_own_query) :
+		   (own_query == &br->ip4_own_query)) {
+		other_query = &br->ip4_other_query;
 		br_group.proto = htons(ETH_P_IP);
 #if IS_ENABLED(CONFIG_IPV6)
 	} else {
-		querier = &br->ip6_querier;
+		other_query = &br->ip6_other_query;
 		br_group.proto = htons(ETH_P_IPV6);
 #endif
 	}
 
-	if (!querier || timer_pending(&querier->timer))
+	if (!other_query || timer_pending(&other_query->timer))
 		return;
 
 	__br_multicast_send_query(br, port, &br_group);
 
 	time = jiffies;
-	time += query->startup_sent < br->multicast_startup_query_count ?
+	time += own_query->startup_sent < br->multicast_startup_query_count ?
 		br->multicast_startup_query_interval :
 		br->multicast_query_interval;
-	mod_timer(&query->timer, time);
+	mod_timer(&own_query->timer, time);
 }
 
-static void br_multicast_port_query_expired(struct net_bridge_port *port,
-					    struct bridge_mcast_query *query)
+static void
+br_multicast_port_query_expired(struct net_bridge_port *port,
+				struct bridge_mcast_own_query *query)
 {
 	struct net_bridge *br = port->br;
 
@@ -868,7 +869,7 @@ static void br_ip4_multicast_port_query_expired(unsigned long data)
 {
 	struct net_bridge_port *port = (void *)data;
 
-	br_multicast_port_query_expired(port, &port->ip4_query);
+	br_multicast_port_query_expired(port, &port->ip4_own_query);
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -876,7 +877,7 @@ static void br_ip6_multicast_port_query_expired(unsigned long data)
 {
 	struct net_bridge_port *port = (void *)data;
 
-	br_multicast_port_query_expired(port, &port->ip6_query);
+	br_multicast_port_query_expired(port, &port->ip6_own_query);
 }
 #endif
 
@@ -886,11 +887,11 @@ void br_multicast_add_port(struct net_bridge_port *port)
 
 	setup_timer(&port->multicast_router_timer, br_multicast_router_expired,
 		    (unsigned long)port);
-	setup_timer(&port->ip4_query.timer, br_ip4_multicast_port_query_expired,
-		    (unsigned long)port);
+	setup_timer(&port->ip4_own_query.timer,
+		    br_ip4_multicast_port_query_expired, (unsigned long)port);
 #if IS_ENABLED(CONFIG_IPV6)
-	setup_timer(&port->ip6_query.timer, br_ip6_multicast_port_query_expired,
-		    (unsigned long)port);
+	setup_timer(&port->ip6_own_query.timer,
+		    br_ip6_multicast_port_query_expired, (unsigned long)port);
 #endif
 }
 
@@ -899,7 +900,7 @@ void br_multicast_del_port(struct net_bridge_port *port)
 	del_timer_sync(&port->multicast_router_timer);
 }
 
-static void br_multicast_enable(struct bridge_mcast_query *query)
+static void br_multicast_enable(struct bridge_mcast_own_query *query)
 {
 	query->startup_sent = 0;
 
@@ -916,9 +917,9 @@ void br_multicast_enable_port(struct net_bridge_port *port)
 	if (br->multicast_disabled || !netif_running(br->dev))
 		goto out;
 
-	br_multicast_enable(&port->ip4_query);
+	br_multicast_enable(&port->ip4_own_query);
 #if IS_ENABLED(CONFIG_IPV6)
-	br_multicast_enable(&port->ip6_query);
+	br_multicast_enable(&port->ip6_own_query);
 #endif
 
 out:
@@ -938,9 +939,9 @@ void br_multicast_disable_port(struct net_bridge_port *port)
 	if (!hlist_unhashed(&port->rlist))
 		hlist_del_init_rcu(&port->rlist);
 	del_timer(&port->multicast_router_timer);
-	del_timer(&port->ip4_query.timer);
+	del_timer(&port->ip4_own_query.timer);
 #if IS_ENABLED(CONFIG_IPV6)
-	del_timer(&port->ip6_query.timer);
+	del_timer(&port->ip6_own_query.timer);
 #endif
 	spin_unlock(&br->multicast_lock);
 }
@@ -1065,14 +1066,14 @@ static int br_ip6_multicast_mld2_report(struct net_bridge *br,
 #endif
 
 static void
-br_multicast_update_querier_timer(struct net_bridge *br,
-				  struct bridge_mcast_querier *querier,
-				  unsigned long max_delay)
+br_multicast_update_query_timer(struct net_bridge *br,
+				struct bridge_mcast_other_query *query,
+				unsigned long max_delay)
 {
-	if (!timer_pending(&querier->timer))
-		querier->delay_time = jiffies + max_delay;
+	if (!timer_pending(&query->timer))
+		query->delay_time = jiffies + max_delay;
 
-	mod_timer(&querier->timer, jiffies + br->multicast_querier_interval);
+	mod_timer(&query->timer, jiffies + br->multicast_querier_interval);
 }
 
 /*
@@ -1125,14 +1126,14 @@ timer:
 
 static void br_multicast_query_received(struct net_bridge *br,
 					struct net_bridge_port *port,
-					struct bridge_mcast_querier *querier,
+					struct bridge_mcast_other_query *query,
 					int saddr,
 					bool is_general_query,
 					unsigned long max_delay)
 {
 	if (saddr && is_general_query)
-		br_multicast_update_querier_timer(br, querier, max_delay);
-	else if (timer_pending(&querier->timer))
+		br_multicast_update_query_timer(br, query, max_delay);
+	else if (timer_pending(&query->timer))
 		return;
 
 	br_multicast_mark_router(br, port);
@@ -1190,8 +1191,8 @@ static int br_ip4_multicast_query(struct net_bridge *br,
 		goto out;
 	}
 
-	br_multicast_query_received(br, port, &br->ip4_querier, !!iph->saddr,
-				    !group, max_delay);
+	br_multicast_query_received(br, port, &br->ip4_other_query,
+				    !!iph->saddr, !group, max_delay);
 
 	if (!group)
 		goto out;
@@ -1282,7 +1283,7 @@ static int br_ip6_multicast_query(struct net_bridge *br,
 		goto out;
 	}
 
-	br_multicast_query_received(br, port, &br->ip6_querier,
+	br_multicast_query_received(br, port, &br->ip6_other_query,
 				    !ipv6_addr_any(&ip6h->saddr),
 				    is_general_query, max_delay);
 
@@ -1315,11 +1316,12 @@ out:
 }
 #endif
 
-static void br_multicast_leave_group(struct net_bridge *br,
-				     struct net_bridge_port *port,
-				     struct br_ip *group,
-				     struct bridge_mcast_querier *querier,
-				     struct bridge_mcast_query *query)
+static void
+br_multicast_leave_group(struct net_bridge *br,
+			 struct net_bridge_port *port,
+			 struct br_ip *group,
+			 struct bridge_mcast_other_query *other_query,
+			 struct bridge_mcast_own_query *own_query)
 {
 	struct net_bridge_mdb_htable *mdb;
 	struct net_bridge_mdb_entry *mp;
@@ -1330,7 +1332,7 @@ static void br_multicast_leave_group(struct net_bridge *br,
 	spin_lock(&br->multicast_lock);
 	if (!netif_running(br->dev) ||
 	    (port && port->state == BR_STATE_DISABLED) ||
-	    timer_pending(&querier->timer))
+	    timer_pending(&other_query->timer))
 		goto out;
 
 	mdb = mlock_dereference(br->mdb, br);
@@ -1344,7 +1346,7 @@ static void br_multicast_leave_group(struct net_bridge *br,
 		time = jiffies + br->multicast_last_member_count *
 				 br->multicast_last_member_interval;
 
-		mod_timer(&query->timer, time);
+		mod_timer(&own_query->timer, time);
 
 		for (p = mlock_dereference(mp->ports, br);
 		     p != NULL;
@@ -1425,17 +1427,19 @@ static void br_ip4_multicast_leave_group(struct net_bridge *br,
 					 __u16 vid)
 {
 	struct br_ip br_group;
-	struct bridge_mcast_query *query = port ? &port->ip4_query :
-						  &br->ip4_query;
+	struct bridge_mcast_own_query *own_query;
 
 	if (ipv4_is_local_multicast(group))
 		return;
 
+	own_query = port ? &port->ip4_own_query : &br->ip4_own_query;
+
 	br_group.u.ip4 = group;
 	br_group.proto = htons(ETH_P_IP);
 	br_group.vid = vid;
 
-	br_multicast_leave_group(br, port, &br_group, &br->ip4_querier, query);
+	br_multicast_leave_group(br, port, &br_group, &br->ip4_other_query,
+				 own_query);
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -1445,18 +1449,19 @@ static void br_ip6_multicast_leave_group(struct net_bridge *br,
 					 __u16 vid)
 {
 	struct br_ip br_group;
-	struct bridge_mcast_query *query = port ? &port->ip6_query :
-						  &br->ip6_query;
-
+	struct bridge_mcast_own_query *own_query;
 
 	if (ipv6_addr_is_ll_all_nodes(group))
 		return;
 
+	own_query = port ? &port->ip6_own_query : &br->ip6_own_query;
+
 	br_group.u.ip6 = *group;
 	br_group.proto = htons(ETH_P_IPV6);
 	br_group.vid = vid;
 
-	br_multicast_leave_group(br, port, &br_group, &br->ip6_querier, query);
+	br_multicast_leave_group(br, port, &br_group, &br->ip6_other_query,
+				 own_query);
 }
 #endif
 
@@ -1723,7 +1728,7 @@ int br_multicast_rcv(struct net_bridge *br, struct net_bridge_port *port,
 }
 
 static void br_multicast_query_expired(struct net_bridge *br,
-				       struct bridge_mcast_query *query)
+				       struct bridge_mcast_own_query *query)
 {
 	spin_lock(&br->multicast_lock);
 	if (query->startup_sent < br->multicast_startup_query_count)
@@ -1737,7 +1742,7 @@ static void br_ip4_multicast_query_expired(unsigned long data)
 {
 	struct net_bridge *br = (void *)data;
 
-	br_multicast_query_expired(br, &br->ip4_query);
+	br_multicast_query_expired(br, &br->ip4_own_query);
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -1745,7 +1750,7 @@ static void br_ip6_multicast_query_expired(unsigned long data)
 {
 	struct net_bridge *br = (void *)data;
 
-	br_multicast_query_expired(br, &br->ip6_query);
+	br_multicast_query_expired(br, &br->ip6_own_query);
 }
 #endif
 
@@ -1767,28 +1772,28 @@ void br_multicast_init(struct net_bridge *br)
 	br->multicast_querier_interval = 255 * HZ;
 	br->multicast_membership_interval = 260 * HZ;
 
-	br->ip4_querier.delay_time = 0;
+	br->ip4_other_query.delay_time = 0;
 #if IS_ENABLED(CONFIG_IPV6)
-	br->ip6_querier.delay_time = 0;
+	br->ip6_other_query.delay_time = 0;
 #endif
 
 	spin_lock_init(&br->multicast_lock);
 	setup_timer(&br->multicast_router_timer,
 		    br_multicast_local_router_expired, 0);
-	setup_timer(&br->ip4_querier.timer, br_ip4_multicast_querier_expired,
-		    (unsigned long)br);
-	setup_timer(&br->ip4_query.timer, br_ip4_multicast_query_expired,
+	setup_timer(&br->ip4_other_query.timer,
+		    br_ip4_multicast_querier_expired, (unsigned long)br);
+	setup_timer(&br->ip4_own_query.timer, br_ip4_multicast_query_expired,
 		    (unsigned long)br);
 #if IS_ENABLED(CONFIG_IPV6)
-	setup_timer(&br->ip6_querier.timer, br_ip6_multicast_querier_expired,
-		    (unsigned long)br);
-	setup_timer(&br->ip6_query.timer, br_ip6_multicast_query_expired,
+	setup_timer(&br->ip6_other_query.timer,
+		    br_ip6_multicast_querier_expired, (unsigned long)br);
+	setup_timer(&br->ip6_own_query.timer, br_ip6_multicast_query_expired,
 		    (unsigned long)br);
 #endif
 }
 
 static void __br_multicast_open(struct net_bridge *br,
-				struct bridge_mcast_query *query)
+				struct bridge_mcast_own_query *query)
 {
 	query->startup_sent = 0;
 
@@ -1800,9 +1805,9 @@ static void __br_multicast_open(struct net_bridge *br,
 
 void br_multicast_open(struct net_bridge *br)
 {
-	__br_multicast_open(br, &br->ip4_query);
+	__br_multicast_open(br, &br->ip4_own_query);
 #if IS_ENABLED(CONFIG_IPV6)
-	__br_multicast_open(br, &br->ip6_query);
+	__br_multicast_open(br, &br->ip6_own_query);
 #endif
 }
 
@@ -1815,11 +1820,11 @@ void br_multicast_stop(struct net_bridge *br)
 	int i;
 
 	del_timer_sync(&br->multicast_router_timer);
-	del_timer_sync(&br->ip4_querier.timer);
-	del_timer_sync(&br->ip4_query.timer);
+	del_timer_sync(&br->ip4_other_query.timer);
+	del_timer_sync(&br->ip4_own_query.timer);
 #if IS_ENABLED(CONFIG_IPV6)
-	del_timer_sync(&br->ip6_querier.timer);
-	del_timer_sync(&br->ip6_query.timer);
+	del_timer_sync(&br->ip6_other_query.timer);
+	del_timer_sync(&br->ip6_own_query.timer);
 #endif
 
 	spin_lock_bh(&br->multicast_lock);
@@ -1923,7 +1928,7 @@ unlock:
 }
 
 static void br_multicast_start_querier(struct net_bridge *br,
-				       struct bridge_mcast_query *query)
+				       struct bridge_mcast_own_query *query)
 {
 	struct net_bridge_port *port;
 
@@ -1934,11 +1939,11 @@ static void br_multicast_start_querier(struct net_bridge *br,
 		    port->state == BR_STATE_BLOCKING)
 			continue;
 
-		if (query == &br->ip4_query)
-			br_multicast_enable(&port->ip4_query);
+		if (query == &br->ip4_own_query)
+			br_multicast_enable(&port->ip4_own_query);
 #if IS_ENABLED(CONFIG_IPV6)
 		else
-			br_multicast_enable(&port->ip6_query);
+			br_multicast_enable(&port->ip6_own_query);
 #endif
 	}
 }
@@ -1974,9 +1979,9 @@ rollback:
 			goto rollback;
 	}
 
-	br_multicast_start_querier(br, &br->ip4_query);
+	br_multicast_start_querier(br, &br->ip4_own_query);
 #if IS_ENABLED(CONFIG_IPV6)
-	br_multicast_start_querier(br, &br->ip6_query);
+	br_multicast_start_querier(br, &br->ip6_own_query);
 #endif
 
 unlock:
@@ -2001,16 +2006,16 @@ int br_multicast_set_querier(struct net_bridge *br, unsigned long val)
 
 	max_delay = br->multicast_query_response_interval;
 
-	if (!timer_pending(&br->ip4_querier.timer))
-		br->ip4_querier.delay_time = jiffies + max_delay;
+	if (!timer_pending(&br->ip4_other_query.timer))
+		br->ip4_other_query.delay_time = jiffies + max_delay;
 
-	br_multicast_start_querier(br, &br->ip4_query);
+	br_multicast_start_querier(br, &br->ip4_own_query);
 
 #if IS_ENABLED(CONFIG_IPV6)
-	if (!timer_pending(&br->ip6_querier.timer))
-		br->ip6_querier.delay_time = jiffies + max_delay;
+	if (!timer_pending(&br->ip6_other_query.timer))
+		br->ip6_other_query.delay_time = jiffies + max_delay;
 
-	br_multicast_start_querier(br, &br->ip6_query);
+	br_multicast_start_querier(br, &br->ip6_own_query);
 #endif
 
 unlock:
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index bc17210..2469aee 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -68,13 +68,13 @@ struct br_ip
 
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
 /* our own querier */
-struct bridge_mcast_query {
+struct bridge_mcast_own_query {
 	struct timer_list	timer;
 	u32			startup_sent;
 };
 
 /* other querier */
-struct bridge_mcast_querier {
+struct bridge_mcast_other_query {
 	struct timer_list		timer;
 	unsigned long			delay_time;
 };
@@ -178,9 +178,9 @@ struct net_bridge_port
 #define BR_PROMISC		0x00000080
 
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
-	struct bridge_mcast_query	ip4_query;
+	struct bridge_mcast_own_query	ip4_own_query;
 #if IS_ENABLED(CONFIG_IPV6)
-	struct bridge_mcast_query	ip6_query;
+	struct bridge_mcast_own_query	ip6_own_query;
 #endif /* IS_ENABLED(CONFIG_IPV6) */
 	unsigned char			multicast_router;
 	struct timer_list		multicast_router_timer;
@@ -282,11 +282,11 @@ struct net_bridge
 	struct hlist_head		router_list;
 
 	struct timer_list		multicast_router_timer;
-	struct bridge_mcast_querier	ip4_querier;
-	struct bridge_mcast_query	ip4_query;
+	struct bridge_mcast_other_query	ip4_other_query;
+	struct bridge_mcast_own_query	ip4_own_query;
 #if IS_ENABLED(CONFIG_IPV6)
-	struct bridge_mcast_querier	ip6_querier;
-	struct bridge_mcast_query	ip6_query;
+	struct bridge_mcast_other_query	ip6_other_query;
+	struct bridge_mcast_own_query	ip6_own_query;
 #endif /* IS_ENABLED(CONFIG_IPV6) */
 #endif
 
@@ -493,7 +493,7 @@ static inline bool br_multicast_is_router(struct net_bridge *br)
 
 static inline bool
 __br_multicast_querier_exists(struct net_bridge *br,
-			      struct bridge_mcast_querier *querier)
+			      struct bridge_mcast_other_query *querier)
 {
 	return time_is_before_jiffies(querier->delay_time) &&
 	       (br->multicast_querier || timer_pending(&querier->timer));
@@ -504,10 +504,10 @@ static inline bool br_multicast_querier_exists(struct net_bridge *br,
 {
 	switch (eth->h_proto) {
 	case (htons(ETH_P_IP)):
-		return __br_multicast_querier_exists(br, &br->ip4_querier);
+		return __br_multicast_querier_exists(br, &br->ip4_other_query);
 #if IS_ENABLED(CONFIG_IPV6)
 	case (htons(ETH_P_IPV6)):
-		return __br_multicast_querier_exists(br, &br->ip6_querier);
+		return __br_multicast_querier_exists(br, &br->ip6_other_query);
 #endif
 	default:
 		return false;
-- 
1.7.10.4

