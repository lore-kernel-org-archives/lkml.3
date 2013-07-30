Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784Ab3G3S5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:57:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56537 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756732Ab3G3Spd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:45:33 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 53/75] neighbour: fix a race in neigh_destroy()
Date: Tue, 30 Jul 2013 11:44:57 -0700
Message-Id: <1375209919-1768-20-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/core/neighbour.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index c815f28..8f9a6c6 100644
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
1.8.1.2

