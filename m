Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935335Ab3FTH3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:29:10 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:35672 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab3FTH3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:29:08 -0400
Message-ID: <1371713342.3252.371.camel@edumazet-glaptop>
Subject: Re: [PATCH] net bridge: add null pointer check, fix panic
From: Eric Dumazet <eric.dumazet@gmail.com>
To: xiaoming gao <gxm.linux.kernel@gmail.com>
Cc: stephen@networkplumber.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 20 Jun 2013 00:29:02 -0700
In-Reply-To: <51C2A8AA.5010902@gmail.com>
References: <51C2710D.2060405@gmail.com> <51C2721B.9050603@gmail.com>
	 <1371704129.3252.356.camel@edumazet-glaptop> <51C2A8AA.5010902@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-20 at 15:00 +0800, xiaoming gao wrote:

> HI Eric
> the problem is as follow:
> br_del_if()-->del_nbp():
> 
> list_del_rcu(&p->list);
> dev->priv_flags &= ~IFF_BRIDGE_PORT;
> 
> ------>at this point, the nic be deleting still have rx_handler , so , may in br_handle_frame()
> ------>br_port_exists() will return false,so br_get_port_rcu() will return NULL
> ------>so in br_handle_frame , there will be a null panic.
> 
> netdev_rx_handler_unregister(dev);
> synchronize_net();

This code is no longer like that in current tree.
Check commit 4a0b5ec12f0ffc3024616e6dc62cf8a04c54edcd
("bridge: remove a redundant synchronize_net()")

> 
> 
> i have checked commit 00cfec37484761a44, i think it didn't fix this bug..

I claim adding NULL tests is not needed in the fast path, it was clearly
stated in the changelog.

I would change the dismantle path to make sure br_get_port_rcu() does
not return NULL in the fast path, and remove the test on FF_BRIDGE_PORT

Try something like that :

diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 1b8b8b8..2edfb80 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -60,7 +60,7 @@ static int br_pass_frame_up(struct sk_buff *skb)
 int br_handle_frame_finish(struct sk_buff *skb)
 {
 	const unsigned char *dest = eth_hdr(skb)->h_dest;
-	struct net_bridge_port *p = br_port_get_rcu(skb->dev);
+	struct net_bridge_port *p = __br_port_get_rcu(skb->dev);
 	struct net_bridge *br;
 	struct net_bridge_fdb_entry *dst;
 	struct net_bridge_mdb_entry *mdst;
@@ -68,7 +68,7 @@ int br_handle_frame_finish(struct sk_buff *skb)
 	bool unicast = true;
 	u16 vid = 0;
 
-	if (!p || p->state == BR_STATE_DISABLED)
+	if (p->state == BR_STATE_DISABLED)
 		goto drop;
 
 	if (!br_allowed_ingress(p->br, nbp_get_vlan_info(p), skb, &vid))
@@ -142,7 +142,7 @@ drop:
 /* note: already called with rcu_read_lock */
 static int br_handle_local_finish(struct sk_buff *skb)
 {
-	struct net_bridge_port *p = br_port_get_rcu(skb->dev);
+	struct net_bridge_port *p = __br_port_get_rcu(skb->dev);
 	u16 vid = 0;
 
 	br_vlan_get_tag(skb, &vid);
@@ -172,7 +172,7 @@ rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
 	if (!skb)
 		return RX_HANDLER_CONSUMED;
 
-	p = br_port_get_rcu(skb->dev);
+	p = __br_port_get_rcu(skb->dev);
 
 	if (unlikely(is_link_local_ether_addr(dest))) {
 		/*
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 3be89b3..9fdd467 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -184,6 +184,11 @@ struct net_bridge_port
 
 #define br_port_exists(dev) (dev->priv_flags & IFF_BRIDGE_PORT)
 
+static inline struct net_bridge_port *__br_port_get_rcu(const struct net_device *dev)
+{
+	return rcu_dereference(dev->rx_handler_data);
+}
+
 static inline struct net_bridge_port *br_port_get_rcu(const struct net_device *dev)
 {
 	struct net_bridge_port *port =


