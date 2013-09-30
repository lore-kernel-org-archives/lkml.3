Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab3I3WZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 18:25:54 -0400
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:42522 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756506Ab3I3WZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 18:25:46 -0400
To: akpm@linux-foundation.org
Cc: normalperson@yhbt.net, nzimmer@sgi.com, viro@zeniv.linux.org.uk,
        nelhage@nelhage.com, davidel@xmailserver.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Message-Id: <968a95ca45c21520c3d0b4a8f3ffc0f269bf4ef3.1380577995.git.jbaron@akamai.com>
In-Reply-To: <cover.1380577995.git.jbaron@akamai.com>
References: <cover.1380577995.git.jbaron@akamai.com>
From: Jason Baron <jbaron@akamai.com>
Subject: [PATCH 3/3] epoll: restore 'struct epitem' size
Date: Mon, 30 Sep 2013 22:25:46 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch entitled 'epoll: optimize EPOLL_CTL_DEL using rcu', increases the
size of 'struct epitem' over 128 bytes as it adds a 'struct rcu_head' field
to 'struct epitem', in order to make use of RCU. This patch restores the size
of 'struct epitem' back to <= 128 bytes. This size restriction and enforcement
was orignally brought in by commit 39732ca5af4b09f4db561149041ddad7211019a5.

The idea of this patch is to use the 'struct rb_node rbn', which is embedded in
the 'stuct epitem' as the 'rcu_head' callback point. This is ok, since the 'rbn'
is no longer in use when we schedule the item to be freed with RCU and its
access is guarded by ep->mtx. Further, the RCU reader does not access the rbn
field.

I've also added a build-time check to ensure that 'struct rb_node' is >= 'struct
rcu_head'.

Note, I've kept this separate from 'epoll: optimize EPOLL_CTL_DEL using rcu'
in order to make clear the hack-ish nature of this thing.

Tested-by: Nathan Zimmer <nzimmer@sgi.com>
Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 fs/eventpoll.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index daaec16..2f06737 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -168,11 +168,7 @@ struct epitem {
 	/* The structure that describe the interested events and the source fd */
 	struct epoll_event event;
 
-	/*
-	 * Free the epitem using rcu to enable a CTL_DEL to happen in parallel
-	 * with reverse path checks.
-	 */
-	struct rcu_head rcu;
+	/* The fllink is in use. Since rcu can't do 'list_del_init()' */
 	int on_list;
 };
 
@@ -682,9 +678,10 @@ static int ep_scan_ready_list(struct eventpoll *ep,
 	return error;
 }
 
-static void epi_rcu_free(struct rcu_head *head)
+static void epi_rcu_free(struct rcu_head *rcu)
 {
-	struct epitem *epi = container_of(head, struct epitem, rcu);
+	struct epitem *epi = (struct epitem *)((char *)rcu -
+					offsetof(struct epitem, rbn));
 	kmem_cache_free(epi_cache, epi);
 }
 
@@ -723,9 +720,15 @@ static int ep_remove(struct eventpoll *ep, struct epitem *epi)
 	spin_unlock_irqrestore(&ep->lock, flags);
 
 	wakeup_source_unregister(ep_wakeup_source(epi));
-
-	/* At this point it is safe to free the eventpoll item */
-	call_rcu(&epi->rcu, epi_rcu_free);
+	/*
+	 * At this point it is safe to free the eventpoll item.
+	 * Use epi->rbn, instead of struct rcu_head, since we
+	 * are trying to minimize the size of 'struct epitem'.
+	 * The 'rbn' field is no longer in use. Protected
+	 * by ep->mtx. the rcu read side, reverse_path_check_proc(),
+	 * does not make use of the rbn field.
+	 */
+	call_rcu((struct rcu_head *)&epi->rbn, epi_rcu_free);
 
 	atomic_long_dec(&ep->user->epoll_watches);
 
@@ -2126,6 +2129,15 @@ static int __init eventpoll_init(void)
 	/* Initialize the structure used to perform file's f_op->poll() calls */
 	ep_nested_calls_init(&poll_readywalk_ncalls);
 
+	/*
+	 * We can have many thousands of epitems, so prevent this from
+	 * using an extra cache line on 64-bit (and smaller) CPUs
+	 */
+	BUILD_BUG_ON(sizeof(void *) <= 8 && sizeof(struct epitem) > 128);
+
+	/* make sure the overloading continues to work */
+	BUILD_BUG_ON(sizeof(struct rb_node) < sizeof(struct rcu_head));
+
 	/* Allocates slab cache used to allocate "struct epitem" items */
 	epi_cache = kmem_cache_create("eventpoll_epi", sizeof(struct epitem),
 			0, SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
-- 
1.8.2

