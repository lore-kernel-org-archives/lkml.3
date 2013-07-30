Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab3G3Jus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:50:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53140 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932376Ab3G3JdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:33:04 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 048/106] neighbour: fix a race in neigh_destroy()
Date: Tue, 30 Jul 2013 10:31:07 +0100
Message-Id: <1375176725-5825-49-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

commit c9ab4d85de222f3390c67aedc9c18a50e767531e upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/core/neighbour.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 5c2dac3..c09f82b 100644
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
@@ -722,7 +722,9 @@ void neigh_destroy(struct neighbour *neigh)
 	if (neigh_del_timer(neigh))
 		pr_warn("Impossible event\n");
 
-	skb_queue_purge(&neigh->arp_queue);
+	write_lock_bh(&neigh->lock);
+	__skb_queue_purge(&neigh->arp_queue);
+	write_unlock_bh(&neigh->lock);
 	neigh->arp_queue_len_bytes = 0;
 
 	if (dev->netdev_ops->ndo_neigh_destroy)
@@ -868,7 +870,7 @@ static void neigh_invalidate(struct neighbour *neigh)
 		neigh->ops->error_report(neigh, skb);
 		write_lock(&neigh->lock);
 	}
-	skb_queue_purge(&neigh->arp_queue);
+	__skb_queue_purge(&neigh->arp_queue);
 	neigh->arp_queue_len_bytes = 0;
 }
 
@@ -1207,7 +1209,7 @@ int neigh_update(struct neighbour *neigh, const u8 *lladdr, u8 new,
 
 			write_lock_bh(&neigh->lock);
 		}
-		skb_queue_purge(&neigh->arp_queue);
+		__skb_queue_purge(&neigh->arp_queue);
 		neigh->arp_queue_len_bytes = 0;
 	}
 out:
-- 
1.8.3.2

