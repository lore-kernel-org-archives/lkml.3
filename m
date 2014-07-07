Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbaGGDlR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 23:41:17 -0400
Received: from mout.web.de ([212.227.15.4]:61658 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbaGGDlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 23:41:11 -0400
From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
To: netdev@vger.kernel.org
Cc: bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@web.de>
Subject: [PATCH net-next 2/2] bridge: export knowledge about the presence of IGMP/MLD queriers
Date: Mon,  7 Jul 2014 05:41:17 +0200
Message-Id: <1404704477-19448-3-git-send-email-linus.luessing@web.de>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404704477-19448-1-git-send-email-linus.luessing@web.de>
References: <1404704477-19448-1-git-send-email-linus.luessing@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:0an6Hyz0LxU9AD3N4MsgBCRL2fN2eRIiPZ82jLNGnRW471MOv5t
 gCf1d4H2wBYNgM07rzhtHHQg0LhRkiD5sQ3xaSMXmc0ihmTjmqPq2kxxZpJtURSkyZZeJmY
 kI+u9TiszxRzLZy0QUOaSHD3eCtI8sMCifZu/j1RXpJzzTJEuWlSpDaPhgyt2v8bIKoYvD0
 SlZImgAzhrrTAbSRzop7w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch other modules are able to ask the bridge whether an
IGMP or MLD querier exists on the according, bridged link layer.

Multicast snooping can only be performed if a valid, selected querier
exists on a link.

Just like the bridge only enables its multicast snooping if a querier
exists, e.g. batman-adv too can only activate its multicast
snooping in bridged scenarios if a querier is present.

For instance this export avoids having to reimplement IGMP/MLD
querier message snooping and parsing in e.g. batman-adv, when
multicast optimizations for bridged scenarios are added in the
future.

Signed-off-by: Linus Lüssing <linus.luessing@web.de>
---
 include/linux/if_bridge.h |    6 ++++++
 net/bridge/br_multicast.c |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index e0c575c..808dcb8 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -40,6 +40,7 @@ extern br_should_route_hook_t __rcu *br_should_route_hook;
 #if IS_ENABLED(CONFIG_BRIDGE) && IS_ENABLED(CONFIG_BRIDGE_IGMP_SNOOPING)
 int br_multicast_list_adjacent(struct net_device *dev,
 			       struct list_head *br_ip_list);
+bool br_multicast_has_querier_anywhere(struct net_device *dev, int proto);
 bool br_multicast_has_querier_adjacent(struct net_device *dev, int proto);
 #else
 static inline int br_multicast_list_adjacent(struct net_device *dev,
@@ -47,6 +48,11 @@ static inline int br_multicast_list_adjacent(struct net_device *dev,
 {
 	return 0;
 }
+static inline bool br_multicast_has_querier_anywhere(struct net_device *dev,
+						     int proto)
+{
+	return false;
+}
 static inline bool br_multicast_has_querier_adjacent(struct net_device *dev,
 						     int proto)
 {
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index abfa0b65..b4845f4 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -2216,6 +2216,43 @@ unlock:
 EXPORT_SYMBOL_GPL(br_multicast_list_adjacent);
 
 /**
+ * br_multicast_has_querier_anywhere - Checks for a querier on a bridge
+ * @dev: The bridge port providing the bridge on which to check for a querier
+ * @proto: The protocol family to check for: IGMP -> ETH_P_IP, MLD -> ETH_P_IPV6
+ *
+ * Checks whether the given interface has a bridge on top and if so returns
+ * true if a valid querier exists anywhere on the bridged link layer.
+ * Otherwise returns false.
+ */
+bool br_multicast_has_querier_anywhere(struct net_device *dev, int proto)
+{
+	struct net_bridge *br;
+	struct net_bridge_port *port;
+	struct ethhdr eth;
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
+	memset(&eth, 0, sizeof(eth));
+	eth.h_proto = htons(proto);
+
+	ret = br_multicast_querier_exists(br, &eth);
+
+unlock:
+	rcu_read_unlock();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(br_multicast_has_querier_anywhere);
+
+/**
  * br_multicast_has_querier_adjacent - Checks for a querier behind a bridge port
  * @dev: The bridge port adjacent to which to check for a querier
  * @proto: The protocol family to check for: IGMP -> ETH_P_IP, MLD -> ETH_P_IPV6
-- 
1.7.10.4

