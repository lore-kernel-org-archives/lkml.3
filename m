Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbaFWJMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:12:25 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:56207 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753806AbaFWJMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:12:23 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 095/111] bridge: Prevent insertion of FDB entry with disallowed vlan
Date: Mon, 23 Jun 2014 10:32:10 +0200
Message-Id: <3ed50132d6a8244a14f9896e897464c099809462.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit e0d7968ab6c8bce2437b36fa7f04117e333f196d ]

br_handle_local_finish() is allowing us to insert an FDB entry with
disallowed vlan. For example, when port 1 and 2 are communicating in
vlan 10, and even if vlan 10 is disallowed on port 3, port 3 can
interfere with their communication by spoofed src mac address with
vlan id 10.

Note: Even if it is judged that a frame should not be learned, it should
not be dropped because it is destined for not forwarding layer but higher
layer. See IEEE 802.1Q-2011 8.13.10.

Signed-off-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Acked-by: Vlad Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/bridge/br_input.c   |  4 ++--
 net/bridge/br_private.h |  7 +++++++
 net/bridge/br_vlan.c    | 28 ++++++++++++++++++++++++++++
 3 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index c378750602cd..1f59299921f8 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -146,8 +146,8 @@ static int br_handle_local_finish(struct sk_buff *skb)
 	struct net_bridge_port *p = br_port_get_rcu(skb->dev);
 	u16 vid = 0;
 
-	br_vlan_get_tag(skb, &vid);
-	if (p->flags & BR_LEARNING)
+	/* check if vlan is allowed, to avoid spoofing */
+	if (p->flags & BR_LEARNING && br_should_learn(p, skb, &vid))
 		br_fdb_update(p->br, p, eth_hdr(skb)->h_source, vid);
 	return 0;	 /* process further */
 }
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 9a63c4206e4a..de50e79b9c34 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -605,6 +605,7 @@ extern bool br_allowed_ingress(struct net_bridge *br, struct net_port_vlans *v,
 extern bool br_allowed_egress(struct net_bridge *br,
 			      const struct net_port_vlans *v,
 			      const struct sk_buff *skb);
+bool br_should_learn(struct net_bridge_port *p, struct sk_buff *skb, u16 *vid);
 extern struct sk_buff *br_handle_vlan(struct net_bridge *br,
 				      const struct net_port_vlans *v,
 				      struct sk_buff *skb);
@@ -671,6 +672,12 @@ static inline bool br_allowed_egress(struct net_bridge *br,
 	return true;
 }
 
+static inline bool br_should_learn(struct net_bridge_port *p,
+				   struct sk_buff *skb, u16 *vid)
+{
+	return true;
+}
+
 static inline struct sk_buff *br_handle_vlan(struct net_bridge *br,
 					     const struct net_port_vlans *v,
 					     struct sk_buff *skb)
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 45a26debe64e..12ce54c0e8ed 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -260,6 +260,34 @@ bool br_allowed_egress(struct net_bridge *br,
 	return false;
 }
 
+/* Called under RCU */
+bool br_should_learn(struct net_bridge_port *p, struct sk_buff *skb, u16 *vid)
+{
+	struct net_bridge *br = p->br;
+	struct net_port_vlans *v;
+
+	if (!br->vlan_enabled)
+		return true;
+
+	v = rcu_dereference(p->vlan_info);
+	if (!v)
+		return false;
+
+	br_vlan_get_tag(skb, vid);
+	if (!*vid) {
+		*vid = br_get_pvid(v);
+		if (*vid == VLAN_N_VID)
+			return false;
+
+		return true;
+	}
+
+	if (test_bit(*vid, v->vlan_bitmap))
+		return true;
+
+	return false;
+}
+
 /* Must be protected by RTNL.
  * Must be called with vid in range from 1 to 4094 inclusive.
  */
-- 
2.0.0

