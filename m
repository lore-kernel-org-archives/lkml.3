Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737AbbA1UXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:23:16 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:36494 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756663AbbA1UXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:23:11 -0500
Date: Wed, 28 Jan 2015 10:07:01 -0500
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3.18 11/61] workqueue: fix subtle pool management issue
 which can stall whole worker_pool
Message-ID: <20150128150701.GA3199@htj.dyndns.org>
References: <20150128012636.936333725@linuxfoundation.org>
 <20150128012638.187292688@linuxfoundation.org>
 <54C840BA.7020207@cn.fujitsu.com>
 <20150128022456.GF12314@htj.dyndns.org>
 <54C85454.6070303@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C85454.6070303@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 11:15:32AM +0800, Lai Jiangshan wrote:
> Was the bug introduced at the first time when maybe_create_worker() was
> introduced?  Although manage_workers()/maybe_create_worker() was changed a bit,
> the stable-tree team can simply make manage_workers() return true to fix
> this bug for the very old kernel versions.

Yes, this bug has been there from the beginning of cmwq.  I'm
attaching a patch which is for before the removal of
maybe_destory_worker().

Thanks.

Subject: [PATCH] workqueue: fix subtle pool management issue which can stall whole worker_pool

A worker_pool's forward progress is guaranteed by the fact that the
last idle worker assumes the manager role to create more workers and
summon the rescuers if creating workers doesn't succeed in timely
manner before proceeding to execute work items.

This manager role is implemented in manage_workers(), which indicates
whether the worker may proceed to work item execution with its return
value.  This is necessary because multiple workers may contend for the
manager role, and, if there already is a manager, others should
proceed to work item execution.

Unfortunately, the function also indicates that the worker may proceed
to work item execution if need_to_create_worker() is false at the head
of the function.  need_to_create_worker() tests the following
conditions.

	pending work items && !nr_running && !nr_idle

The first and third conditions are protected by pool->lock and thus
won't change while holding pool->lock; however, nr_running can change
asynchronously as other workers block and resume and while it's likely
to be zero, as someone woke this worker up in the first place, some
other workers could have become runnable inbetween making it non-zero.

If this happens, manage_worker() could return false even with zero
nr_idle making the worker, the last idle one, proceed to execute work
items.  If then all workers of the pool end up blocking on a resource
which can only be released by a work item which is pending on that
pool, the whole pool can deadlock as there's no one to create more
workers or summon the rescuers.

This patch fixes the problem by removing the early exit condition from
maybe_create_worker() and making manage_workers() return false iff
there's already another manager, which ensures that the last worker
doesn't start executing work items.

We can leave the early exit condition alone and just ignore the return
value but the only reason it was put there is because the
manage_workers() used to perform both creations and destructions of
workers and thus the function may be invoked while the pool is trying
to reduce the number of workers.  Now that manage_workers() is called
only when more workers are needed, the only case this early exit
condition is triggered is rare race conditions rendering it pointless.

Tested with simulated workload and modified workqueue code which
trigger the pool deadlock reliably without this patch.

tj: Updated to v3.10 where manage_workers() is responsible not only
    for creating more workers but also destroying surplus ones.
    maybe_create_worker() needs to keep its early exit condition to
    avoid creating a new worker when manage_workers() is called to
    destroy surplus ones.  Other than that, the adaptabion is
    straight-forward.  Both maybe_{create|destroy}_worker() functions
    are converted to return void and manage_workers() returns %false
    iff it lost manager arbitration.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Eric Sandeen <sandeen@sandeen.net>
Link: http://lkml.kernel.org/g/54B019F4.8030009@sandeen.net
Cc: Dave Chinner <david@fromorbit.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: stable@vger.kernel.org
---
 kernel/workqueue.c |   39 +++++++++++++--------------------------
 1 file changed, 13 insertions(+), 26 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 14a7163..e117fa3 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1921,17 +1921,13 @@ static void pool_mayday_timeout(unsigned long __pool)
  * spin_lock_irq(pool->lock) which may be released and regrabbed
  * multiple times.  Does GFP_KERNEL allocations.  Called only from
  * manager.
- *
- * RETURNS:
- * %false if no action was taken and pool->lock stayed locked, %true
- * otherwise.
  */
-static bool maybe_create_worker(struct worker_pool *pool)
+static void maybe_create_worker(struct worker_pool *pool)
 __releases(&pool->lock)
 __acquires(&pool->lock)
 {
 	if (!need_to_create_worker(pool))
-		return false;
+		return;
 restart:
 	spin_unlock_irq(&pool->lock);
 
@@ -1948,7 +1944,7 @@ restart:
 			start_worker(worker);
 			if (WARN_ON_ONCE(need_to_create_worker(pool)))
 				goto restart;
-			return true;
+			return;
 		}
 
 		if (!need_to_create_worker(pool))
@@ -1965,7 +1961,7 @@ restart:
 	spin_lock_irq(&pool->lock);
 	if (need_to_create_worker(pool))
 		goto restart;
-	return true;
+	return;
 }
 
 /**
@@ -1978,15 +1974,9 @@ restart:
  * LOCKING:
  * spin_lock_irq(pool->lock) which may be released and regrabbed
  * multiple times.  Called only from manager.
- *
- * RETURNS:
- * %false if no action was taken and pool->lock stayed locked, %true
- * otherwise.
  */
-static bool maybe_destroy_workers(struct worker_pool *pool)
+static void maybe_destroy_workers(struct worker_pool *pool)
 {
-	bool ret = false;
-
 	while (too_many_workers(pool)) {
 		struct worker *worker;
 		unsigned long expires;
@@ -2000,10 +1990,7 @@ static bool maybe_destroy_workers(struct worker_pool *pool)
 		}
 
 		destroy_worker(worker);
-		ret = true;
 	}
-
-	return ret;
 }
 
 /**
@@ -2023,13 +2010,14 @@ static bool maybe_destroy_workers(struct worker_pool *pool)
  * multiple times.  Does GFP_KERNEL allocations.
  *
  * RETURNS:
- * spin_lock_irq(pool->lock) which may be released and regrabbed
- * multiple times.  Does GFP_KERNEL allocations.
+ * %false if the pool doesn't need management and the caller can safely
+ * start processing works, %true if management function was performed and
+ * the conditions that the caller verified before calling the function may
+ * no longer be true.
  */
 static bool manage_workers(struct worker *worker)
 {
 	struct worker_pool *pool = worker->pool;
-	bool ret = false;
 
 	/*
 	 * Managership is governed by two mutexes - manager_arb and
@@ -2053,7 +2041,7 @@ static bool manage_workers(struct worker *worker)
 	 * manager_mutex.
 	 */
 	if (!mutex_trylock(&pool->manager_arb))
-		return ret;
+		return false;
 
 	/*
 	 * With manager arbitration won, manager_mutex would be free in
@@ -2063,7 +2051,6 @@ static bool manage_workers(struct worker *worker)
 		spin_unlock_irq(&pool->lock);
 		mutex_lock(&pool->manager_mutex);
 		spin_lock_irq(&pool->lock);
-		ret = true;
 	}
 
 	pool->flags &= ~POOL_MANAGE_WORKERS;
@@ -2072,12 +2059,12 @@ static bool manage_workers(struct worker *worker)
 	 * Destroy and then create so that may_start_working() is true
 	 * on return.
 	 */
-	ret |= maybe_destroy_workers(pool);
-	ret |= maybe_create_worker(pool);
+	maybe_destroy_workers(pool);
+	maybe_create_worker(pool);
 
 	mutex_unlock(&pool->manager_mutex);
 	mutex_unlock(&pool->manager_arb);
-	return ret;
+	return true;
 }
 
 /**
