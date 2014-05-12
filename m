Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbaELBof (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:44:35 -0400
Received: from 1wt.eu ([62.212.114.60]:34802 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050AbaELBoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:44:32 -0400
Message-Id: <20140512003202.754255797@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:51 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 051/143] neighbour: fix a race in neigh_destroy()
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

[ Upstream commit c9ab4d85de222f3390c67aedc9c18a50e767531e ]

There is a race in neighbour code, because neigh_destroy() uses
skb_queue_purge(&neigh->arp_queue) without holding neighbour lock,
while other parts of the code assume neighbour rwlock is what
protects arp_queue

Convert all skb_queue_purge() calls to the __skb_queue_purge() variant

Use __skb_queue_head_init() instead of skb_queue_head_init()
to make clear we do not use arp_queue.lock

And hold neigh->lock in neigh_destroy() to close the race.

Reported-by: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/core/neighbour.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index e696250..fc9feaa 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -222,7 +222,7 @@ static void neigh_flush_dev(struct neigh_table *tbl, struct net_device *dev)
 				   we must kill timers etc. and move
 				   it to safe state.
 				 */
-				skb_queue_purge(&n->arp_queue);
+				__skb_queue_purge(&n->arp_queue);
 				n->output = neigh_blackhole;
 				if (n->nud_state & NUD_VALID)
 					n->nud_state = NUD_NOARP;
@@ -276,7 +276,7 @@ static struct neighbour *neigh_alloc(struct neigh_table *tbl)
 	if (!n)
 		goto out_entries;
 
-	skb_queue_head_init(&n->arp_queue);
+	__skb_queue_head_init(&n->arp_queue);
 	rwlock_init(&n->lock);
 	n->updated	  = n->used = now;
 	n->nud_state	  = NUD_NONE;
@@ -646,7 +646,9 @@ void neigh_destroy(struct neighbour *neigh)
 			kfree(hh);
 	}
 
-	skb_queue_purge(&neigh->arp_queue);
+	write_lock_bh(&neigh->lock);
+	__skb_queue_purge(&neigh->arp_queue);
+	write_unlock_bh(&neigh->lock);
 
 	dev_put(neigh->dev);
 	neigh_parms_put(neigh->parms);
@@ -789,7 +791,7 @@ static void neigh_invalidate(struct neighbour *neigh)
 		neigh->ops->error_report(neigh, skb);
 		write_lock(&neigh->lock);
 	}
-	skb_queue_purge(&neigh->arp_queue);
+	__skb_queue_purge(&neigh->arp_queue);
 }
 
 /* Called when a timer expires for a neighbour entry. */
@@ -1105,7 +1107,7 @@ int neigh_update(struct neighbour *neigh, const u8 *lladdr, u8 new,
 			n1->output(skb);
 			write_lock_bh(&neigh->lock);
 		}
-		skb_queue_purge(&neigh->arp_queue);
+		__skb_queue_purge(&neigh->arp_queue);
 	}
 out:
 	if (update_isrouter) {
-- 
1.7.12.2.21.g234cd45.dirty



