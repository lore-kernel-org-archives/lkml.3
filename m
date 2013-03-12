Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273Ab3CLSTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:19:23 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:48326 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932456Ab3CLSTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:19:21 -0400
Date: Tue, 12 Mar 2013 11:19:17 -0700
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com
Subject: [PATCH v2 14/31] workqueue: replace POOL_MANAGING_WORKERS flag with
 worker_pool->manager_mutex
Message-ID: <20130312181917.GC25266@htj.dyndns.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
 <1362194662-2344-15-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362194662-2344-15-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 45fcfc6da599d190fc6355f046ef1e63d89475e4 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Tue, 12 Mar 2013 11:14:47 -0700

POOL_MANAGING_WORKERS is used to synchronize the manager role.
Synchronizing among workers doesn't need blocking and that's why it's
implemented as a flag.

It got converted to a mutex a while back to add blocking wait from CPU
hotplug path - 6037315269 ("workqueue: use mutex for global_cwq
manager exclusion").  Later it turned out that synchronization among
workers and cpu hotplug need to be done separately.  Eventually,
POOL_MANAGING_WORKERS is restored and workqueue->manager_mutex got
morphed into workqueue->assoc_mutex - 552a37e936 ("workqueue: restore
POOL_MANAGING_WORKERS") and b2eb83d123 ("workqueue: rename
manager_mutex to assoc_mutex").

Now, we're gonna need to be able to lock out managers from
destroy_workqueue() to support multiple unbound pools with custom
attributes making it again necessary to be able to block on the
manager role.  This patch replaces POOL_MANAGING_WORKERS with
worker_pool->manager_arb.

This patch doesn't introduce any behavior changes.

v2: s/manager_mutex/manager_arb/

Signed-off-by: Tejun Heo <tj@kernel.org>
---
manager_mutex renamed to manager_arb.  assoc_mutex will later be
renamed to manager_mutex along with other locking cleanups.

Thanks.

 kernel/workqueue.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 4638149..16f7f8d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -64,7 +64,6 @@ enum {
 	 * create_worker() is in progress.
 	 */
 	POOL_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
-	POOL_MANAGING_WORKERS   = 1 << 1,       /* managing workers */
 	POOL_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
 	POOL_FREEZING		= 1 << 3,	/* freeze in progress */
 
@@ -145,6 +144,7 @@ struct worker_pool {
 	DECLARE_HASHTABLE(busy_hash, BUSY_WORKER_HASH_ORDER);
 						/* L: hash of busy workers */
 
+	struct mutex		manager_arb;	/* manager arbitration */
 	struct mutex		assoc_mutex;	/* protect POOL_DISASSOCIATED */
 	struct ida		worker_ida;	/* L: for worker IDs */
 
@@ -706,7 +706,7 @@ static bool need_to_manage_workers(struct worker_pool *pool)
 /* Do we have too many workers and should some go away? */
 static bool too_many_workers(struct worker_pool *pool)
 {
-	bool managing = pool->flags & POOL_MANAGING_WORKERS;
+	bool managing = mutex_is_locked(&pool->manager_arb);
 	int nr_idle = pool->nr_idle + managing; /* manager is considered idle */
 	int nr_busy = pool->nr_workers - nr_idle;
 
@@ -2029,19 +2029,17 @@ static bool manage_workers(struct worker *worker)
 	struct worker_pool *pool = worker->pool;
 	bool ret = false;
 
-	if (pool->flags & POOL_MANAGING_WORKERS)
+	if (!mutex_trylock(&pool->manager_arb))
 		return ret;
 
-	pool->flags |= POOL_MANAGING_WORKERS;
-
 	/*
 	 * To simplify both worker management and CPU hotplug, hold off
 	 * management while hotplug is in progress.  CPU hotplug path can't
-	 * grab %POOL_MANAGING_WORKERS to achieve this because that can
-	 * lead to idle worker depletion (all become busy thinking someone
-	 * else is managing) which in turn can result in deadlock under
-	 * extreme circumstances.  Use @pool->assoc_mutex to synchronize
-	 * manager against CPU hotplug.
+	 * grab @pool->manager_arb to achieve this because that can lead to
+	 * idle worker depletion (all become busy thinking someone else is
+	 * managing) which in turn can result in deadlock under extreme
+	 * circumstances.  Use @pool->assoc_mutex to synchronize manager
+	 * against CPU hotplug.
 	 *
 	 * assoc_mutex would always be free unless CPU hotplug is in
 	 * progress.  trylock first without dropping @pool->lock.
@@ -2077,8 +2075,8 @@ static bool manage_workers(struct worker *worker)
 	ret |= maybe_destroy_workers(pool);
 	ret |= maybe_create_worker(pool);
 
-	pool->flags &= ~POOL_MANAGING_WORKERS;
 	mutex_unlock(&pool->assoc_mutex);
+	mutex_unlock(&pool->manager_arb);
 	return ret;
 }
 
@@ -3806,6 +3804,7 @@ static int __init init_workqueues(void)
 			setup_timer(&pool->mayday_timer, pool_mayday_timeout,
 				    (unsigned long)pool);
 
+			mutex_init(&pool->manager_arb);
 			mutex_init(&pool->assoc_mutex);
 			ida_init(&pool->worker_ida);
 
-- 
1.8.1.4

