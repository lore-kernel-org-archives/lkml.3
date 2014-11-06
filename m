Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaKFWhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:37:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58460 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaKFWhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:37:32 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vladislav Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 013/162] bridge: Check if vlan filtering is enabled only once.
Date: Thu,  6 Nov 2014 14:34:37 -0800
Message-Id: <1415313426-9622-14-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevich@gmail.com>

[ Upstream commit 20adfa1a81af00bf2027644507ad4fa9cd2849cf ]

The bridge code checks if vlan filtering is enabled on both
ingress and egress.   When the state flip happens, it
is possible for the bridge to currently be forwarding packets
and forwarding behavior becomes non-deterministic.  Bridge
may drop packets on some interfaces, but not others.

This patch solves this by caching the filtered state of the
packet into skb_cb on ingress.  The skb_cb is guaranteed to
not be over-written between the time packet entres bridge
forwarding path and the time it leaves it.  On egress, we
can then check the cached state to see if we need to
apply filtering information.

Signed-off-by: Vladislav Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/bridge/br_private.h |  3 +++
 net/bridge/br_vlan.c    | 15 +++++++++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 280f601..cd37763 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -309,6 +309,9 @@ struct br_input_skb_cb {
 	int igmp;
 	int mrouters_only;
 #endif
+#ifdef CONFIG_BRIDGE_VLAN_FILTERING
+	bool vlan_filtered;
+#endif
 };
 
 #define BR_INPUT_SKB_CB(__skb)	((struct br_input_skb_cb *)(__skb)->cb)
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 4f5341a..f71b4d8 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -141,7 +141,8 @@ struct sk_buff *br_handle_vlan(struct net_bridge *br,
 {
 	u16 vid;
 
-	if (!br->vlan_enabled)
+	/* If this packet was not filtered at input, let it pass */
+	if (!BR_INPUT_SKB_CB(skb)->vlan_filtered)
 		goto out;
 
 	/* At this point, we know that the frame was filtered and contains
@@ -186,8 +187,10 @@ bool br_allowed_ingress(struct net_bridge *br, struct net_port_vlans *v,
 	/* If VLAN filtering is disabled on the bridge, all packets are
 	 * permitted.
 	 */
-	if (!br->vlan_enabled)
+	if (!br->vlan_enabled) {
+		BR_INPUT_SKB_CB(skb)->vlan_filtered = false;
 		return true;
+	}
 
 	/* If there are no vlan in the permitted list, all packets are
 	 * rejected.
@@ -195,6 +198,8 @@ bool br_allowed_ingress(struct net_bridge *br, struct net_port_vlans *v,
 	if (!v)
 		goto drop;
 
+	BR_INPUT_SKB_CB(skb)->vlan_filtered = true;
+
 	err = br_vlan_get_tag(skb, vid);
 	if (!*vid) {
 		u16 pvid = br_get_pvid(v);
@@ -239,7 +244,8 @@ bool br_allowed_egress(struct net_bridge *br,
 {
 	u16 vid;
 
-	if (!br->vlan_enabled)
+	/* If this packet was not filtered at input, let it pass */
+	if (!BR_INPUT_SKB_CB(skb)->vlan_filtered)
 		return true;
 
 	if (!v)
@@ -258,7 +264,8 @@ bool br_should_learn(struct net_bridge_port *p, struct sk_buff *skb, u16 *vid)
 	struct net_bridge *br = p->br;
 	struct net_port_vlans *v;
 
-	if (!br->vlan_enabled)
+	/* If filtering was disabled at input, let it pass. */
+	if (!BR_INPUT_SKB_CB(skb)->vlan_filtered)
 		return true;
 
 	v = rcu_dereference(p->vlan_info);
-- 
1.9.1

