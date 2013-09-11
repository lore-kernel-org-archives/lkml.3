Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab3IKEaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:30:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31136 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab3IKE3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:29:04 -0400
X-Authority-Analysis: v=2.0 cv=R/aB6KtX c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=H7h884vEg0sA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=gUvNr4Q5nGcA:10 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=VKxeULUk18AnFodGohwA:9 a=MSl-tDqOz04A:10 a=7DSvI1NPTFQA:10 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042858.584010996@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:27:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Joe Jin <joe.jin@oracle.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [038/251] neighbour: fix a race in neigh_destroy()
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0038-neighbour-fix-a-race-in-neigh_destroy.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/core/neighbour.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 058bb1e..f7ffed1 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -239,7 +239,7 @@ static void neigh_flush_dev(struct neigh_table *tbl, struct net_device *dev)
 				   we must kill timers etc. and move
 				   it to safe state.
 				 */
-				skb_queue_purge(&n->arp_queue);
+				__skb_queue_purge(&n->arp_queue);
 				n->arp_queue_len_bytes = 0;
 				n->output = neigh_blackhole;
 				if (n->nud_state & NUD_VALID)
@@ -302,7 +302,7 @@ static struct neighbour *neigh_alloc(struct neigh_table *tbl, struct net_device
 	if (!n)
 		goto out_entries;
 
-	skb_queue_head_init(&n->arp_queue);
+	__skb_queue_head_init(&n->arp_queue);
 	rwlock_init(&n->lock);
 	seqlock_init(&n->ha_lock);
 	n->updated	  = n->used = now;
@@ -724,7 +724,9 @@ void neigh_destroy(struct neighbour *neigh)
 	if (neigh_del_timer(neigh))
 		pr_warn("Impossible event\n");
 
-	skb_queue_purge(&neigh->arp_queue);
+	write_lock_bh(&neigh->lock);
+	__skb_queue_purge(&neigh->arp_queue);
+	write_unlock_bh(&neigh->lock);
 	neigh->arp_queue_len_bytes = 0;
 
 	if (dev->netdev_ops->ndo_neigh_destroy)
@@ -870,7 +872,7 @@ static void neigh_invalidate(struct neighbour *neigh)
 		neigh->ops->error_report(neigh, skb);
 		write_lock(&neigh->lock);
 	}
-	skb_queue_purge(&neigh->arp_queue);
+	__skb_queue_purge(&neigh->arp_queue);
 	neigh->arp_queue_len_bytes = 0;
 }
 
@@ -1222,7 +1224,7 @@ int neigh_update(struct neighbour *neigh, const u8 *lladdr, u8 new,
 
 			write_lock_bh(&neigh->lock);
 		}
-		skb_queue_purge(&neigh->arp_queue);
+		__skb_queue_purge(&neigh->arp_queue);
 		neigh->arp_queue_len_bytes = 0;
 	}
 out:
-- 
1.7.10.4


