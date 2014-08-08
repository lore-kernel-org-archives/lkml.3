Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933643AbaHHVIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:08:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41269 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257AbaHHUxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:53:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 210/259] bridge: Prevent insertion of FDB entry with disallowed vlan
Date: Fri,  8 Aug 2014 13:40:33 -0700
Message-Id: <1407530482-4483-211-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/bridge/br_input.c   |  4 ++--
 net/bridge/br_private.h |  7 +++++++
 net/bridge/br_vlan.c    | 28 ++++++++++++++++++++++++++++
 3 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index fa29179..2bc64f8 100644
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
index 045d56e..280f601 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -587,6 +587,7 @@ bool br_allowed_ingress(struct net_bridge *br, struct net_port_vlans *v,
 			struct sk_buff *skb, u16 *vid);
 bool br_allowed_egress(struct net_bridge *br, const struct net_port_vlans *v,
 		       const struct sk_buff *skb);
+bool br_should_learn(struct net_bridge_port *p, struct sk_buff *skb, u16 *vid);
 struct sk_buff *br_handle_vlan(struct net_bridge *br,
 			       const struct net_port_vlans *v,
 			       struct sk_buff *skb);
@@ -653,6 +654,12 @@ static inline bool br_allowed_egress(struct net_bridge *br,
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
index 9bddc9b..4f5341a 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -252,6 +252,34 @@ bool br_allowed_egress(struct net_bridge *br,
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
1.9.1

