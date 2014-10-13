Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbaJMC5B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:57:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45674 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbaJMC0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:26:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vladislav Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 17/37] bridge: Check if vlan filtering is enabled only once.
Date: Mon, 13 Oct 2014 04:24:14 +0200
Message-Id: <20141013022401.025688717@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022400.286360067@linuxfoundation.org>
References: <20141013022400.286360067@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_private.h |    3 +++
 net/bridge/br_vlan.c    |   15 +++++++++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -302,6 +302,9 @@ struct br_input_skb_cb {
 	int igmp;
 	int mrouters_only;
 #endif
+#ifdef CONFIG_BRIDGE_VLAN_FILTERING
+	bool vlan_filtered;
+#endif
 };
 
 #define BR_INPUT_SKB_CB(__skb)	((struct br_input_skb_cb *)(__skb)->cb)
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -125,7 +125,8 @@ struct sk_buff *br_handle_vlan(struct ne
 {
 	u16 vid;
 
-	if (!br->vlan_enabled)
+	/* If this packet was not filtered at input, let it pass */
+	if (!BR_INPUT_SKB_CB(skb)->vlan_filtered)
 		goto out;
 
 	/* Vlan filter table must be configured at this point.  The
@@ -163,8 +164,10 @@ bool br_allowed_ingress(struct net_bridg
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
@@ -172,6 +175,8 @@ bool br_allowed_ingress(struct net_bridg
 	if (!v)
 		goto drop;
 
+	BR_INPUT_SKB_CB(skb)->vlan_filtered = true;
+
 	/* If vlan tx offload is disabled on bridge device and frame was
 	 * sent from vlan device on the bridge device, it does not have
 	 * HW accelerated vlan tag.
@@ -228,7 +233,8 @@ bool br_allowed_egress(struct net_bridge
 {
 	u16 vid;
 
-	if (!br->vlan_enabled)
+	/* If this packet was not filtered at input, let it pass */
+	if (!BR_INPUT_SKB_CB(skb)->vlan_filtered)
 		return true;
 
 	if (!v)
@@ -247,7 +253,8 @@ bool br_should_learn(struct net_bridge_p
 	struct net_bridge *br = p->br;
 	struct net_port_vlans *v;
 
-	if (!br->vlan_enabled)
+	/* If filtering was disabled at input, let it pass. */
+	if (!BR_INPUT_SKB_CB(skb)->vlan_filtered)
 		return true;
 
 	v = rcu_dereference(p->vlan_info);


