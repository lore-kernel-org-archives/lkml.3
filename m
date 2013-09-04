Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761604Ab3IDAOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 20:14:25 -0400
Received: from mout.web.de ([212.227.17.11]:56814 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761416Ab3IDAOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 20:14:23 -0400
From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
To: netdev@vger.kernel.org
Cc: bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Cong Wang <amwang@redhat.com>, Adam Baker <linux@baker-net.org.uk>,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
Subject: [PATCH net-next 2/2] bridge: apply multicast snooping to IPv6 link-local, too
Date: Wed,  4 Sep 2013 02:13:39 +0200
Message-Id: <1378253619-23918-3-git-send-email-linus.luessing@web.de>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1378253619-23918-1-git-send-email-linus.luessing@web.de>
References: <1378253619-23918-1-git-send-email-linus.luessing@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:qiVNFmAhFvoy4ovsJ0xivL1TJnt7He38dcKHHwicjzrh6zuLsFl
 UwcPyvpVtO0J74WHAFZ2tjiT7kknNySQ0ZB/K4VogvGzwyBiEs9tA48cSqCouXAtZeBBzWD
 Np7gk5xA5E2K2ABZvivKF0V2V3NDbKhbjZMJEXUPaTtfqsRN2ATXlFgBfx92GXoiCckGdGN
 2B4szK9N/iwOpYMTeOAVA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The multicast snooping code should have matured enough to be safely
applicable to IPv6 link-local multicast addresses (excluding the
link-local all nodes address, ff02::1), too.

Signed-off-by: Linus Lüssing <linus.luessing@web.de>
---
 net/bridge/br_mdb.c       |    3 ++-
 net/bridge/br_multicast.c |    7 ++++---
 net/bridge/br_private.h   |   10 ----------
 3 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index a7c6cd0..85a09bb 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -9,6 +9,7 @@
 #include <net/netlink.h>
 #if IS_ENABLED(CONFIG_IPV6)
 #include <net/ipv6.h>
+#include <net/addrconf.h>
 #endif
 
 #include "br_private.h"
@@ -254,7 +255,7 @@ static bool is_valid_mdb_entry(struct br_mdb_entry *entry)
 			return false;
 #if IS_ENABLED(CONFIG_IPV6)
 	} else if (entry->addr.proto == htons(ETH_P_IPV6)) {
-		if (!ipv6_is_transient_multicast(&entry->addr.u.ip6))
+		if (ipv6_addr_is_ll_all_nodes(&entry->addr.u.ip6))
 			return false;
 #endif
 	} else
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 662ba7b..3b0ed99 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -29,6 +29,7 @@
 #include <net/ipv6.h>
 #include <net/mld.h>
 #include <net/ip6_checksum.h>
+#include <net/addrconf.h>
 #endif
 
 #include "br_private.h"
@@ -724,7 +725,7 @@ static int br_ip6_multicast_add_group(struct net_bridge *br,
 {
 	struct br_ip br_group;
 
-	if (!ipv6_is_transient_multicast(group))
+	if (ipv6_addr_is_ll_all_nodes(group))
 		return 0;
 
 	br_group.u.ip6 = *group;
@@ -1410,7 +1411,7 @@ static void br_ip6_multicast_leave_group(struct net_bridge *br,
 						  &br->ip6_query;
 
 
-	if (!ipv6_is_transient_multicast(group))
+	if (ipv6_addr_is_ll_all_nodes(group))
 		return;
 
 	br_group.u.ip6 = *group;
@@ -1551,7 +1552,7 @@ static int br_multicast_ipv6_rcv(struct net_bridge *br,
 		return 0;
 
 	/* Prevent flooding this packet if there is no listener present */
-	if (ipv6_is_transient_multicast(&ip6h->daddr))
+	if (!ipv6_addr_is_ll_all_nodes(&ip6h->daddr))
 		BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
 
 	if (ip6h->nexthdr != IPPROTO_HOPOPTS ||
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index f225fb6..598cb0b 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -494,16 +494,6 @@ extern void br_mdb_notify(struct net_device *dev, struct net_bridge_port *port,
 #define mlock_dereference(X, br) \
 	rcu_dereference_protected(X, lockdep_is_held(&br->multicast_lock))
 
-#if IS_ENABLED(CONFIG_IPV6)
-#include <net/addrconf.h>
-static inline int ipv6_is_transient_multicast(const struct in6_addr *addr)
-{
-	if (ipv6_addr_is_multicast(addr) && IPV6_ADDR_MC_FLAG_TRANSIENT(addr))
-		return 1;
-	return 0;
-}
-#endif
-
 static inline bool br_multicast_is_router(struct net_bridge *br)
 {
 	return br->multicast_router == 2 ||
-- 
1.7.10.4

