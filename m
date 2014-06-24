Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272AbaFXPxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:53:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32890 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763AbaFXPxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:53:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 16/68] bridge: Prevent insertion of FDB entry with disallowed vlan
Date: Tue, 24 Jun 2014 11:50:35 -0400
Message-Id: <20140624154724.648102964@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154723.907894814@linuxfoundation.org>
References: <20140624154723.907894814@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_input.c   |    4 ++--
 net/bridge/br_private.h |    7 +++++++
 net/bridge/br_vlan.c    |   28 ++++++++++++++++++++++++++++
 3 files changed, 37 insertions(+), 2 deletions(-)

--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -147,8 +147,8 @@ static int br_handle_local_finish(struct
 	struct net_bridge_port *p = br_port_get_rcu(skb->dev);
 	u16 vid = 0;
 
-	br_vlan_get_tag(skb, &vid);
-	if (p->flags & BR_LEARNING)
+	/* check if vlan is allowed, to avoid spoofing */
+	if (p->flags & BR_LEARNING && br_should_learn(p, skb, &vid))
 		br_fdb_update(p->br, p, eth_hdr(skb)->h_source, vid, false);
 	return 0;	 /* process further */
 }
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -581,6 +581,7 @@ bool br_allowed_ingress(struct net_bridg
 			struct sk_buff *skb, u16 *vid);
 bool br_allowed_egress(struct net_bridge *br, const struct net_port_vlans *v,
 		       const struct sk_buff *skb);
+bool br_should_learn(struct net_bridge_port *p, struct sk_buff *skb, u16 *vid);
 struct sk_buff *br_handle_vlan(struct net_bridge *br,
 			       const struct net_port_vlans *v,
 			       struct sk_buff *skb);
@@ -647,6 +648,12 @@ static inline bool br_allowed_egress(str
 {
 	return true;
 }
+
+static inline bool br_should_learn(struct net_bridge_port *p,
+				   struct sk_buff *skb, u16 *vid)
+{
+	return true;
+}
 
 static inline struct sk_buff *br_handle_vlan(struct net_bridge *br,
 					     const struct net_port_vlans *v,
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -241,6 +241,34 @@ bool br_allowed_egress(struct net_bridge
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


