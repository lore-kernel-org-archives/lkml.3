Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933631Ab3GZVmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:42:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50772 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932334Ab3GZUsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joe Jin <joe.jin@oracle.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 04/79] neighbour: fix a race in neigh_destroy()
Date: Fri, 26 Jul 2013 13:46:54 -0700
Message-Id: <20130726204722.376058298@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/neighbour.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -231,7 +231,7 @@ static void neigh_flush_dev(struct neigh
 				   we must kill timers etc. and move
 				   it to safe state.
 				 */
-				skb_queue_purge(&n->arp_queue);
+				__skb_queue_purge(&n->arp_queue);
 				n->arp_queue_len_bytes = 0;
 				n->output = neigh_blackhole;
 				if (n->nud_state & NUD_VALID)
@@ -286,7 +286,7 @@ static struct neighbour *neigh_alloc(str
 	if (!n)
 		goto out_entries;
 
-	skb_queue_head_init(&n->arp_queue);
+	__skb_queue_head_init(&n->arp_queue);
 	rwlock_init(&n->lock);
 	seqlock_init(&n->ha_lock);
 	n->updated	  = n->used = now;
@@ -708,7 +708,9 @@ void neigh_destroy(struct neighbour *nei
 	if (neigh_del_timer(neigh))
 		pr_warn("Impossible event\n");
 
-	skb_queue_purge(&neigh->arp_queue);
+	write_lock_bh(&neigh->lock);
+	__skb_queue_purge(&neigh->arp_queue);
+	write_unlock_bh(&neigh->lock);
 	neigh->arp_queue_len_bytes = 0;
 
 	if (dev->netdev_ops->ndo_neigh_destroy)
@@ -858,7 +860,7 @@ static void neigh_invalidate(struct neig
 		neigh->ops->error_report(neigh, skb);
 		write_lock(&neigh->lock);
 	}
-	skb_queue_purge(&neigh->arp_queue);
+	__skb_queue_purge(&neigh->arp_queue);
 	neigh->arp_queue_len_bytes = 0;
 }
 
@@ -1210,7 +1212,7 @@ int neigh_update(struct neighbour *neigh
 
 			write_lock_bh(&neigh->lock);
 		}
-		skb_queue_purge(&neigh->arp_queue);
+		__skb_queue_purge(&neigh->arp_queue);
 		neigh->arp_queue_len_bytes = 0;
 	}
 out:


