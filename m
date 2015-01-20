Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbbATQvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:51:55 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:33539 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbbATQvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:51:53 -0500
Date: Tue, 20 Jan 2015 11:51:47 -0500
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: [GIT PULL] workqueue fixes for v3.19-rc5
Message-ID: <20150120165147.GB8684@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

xfs folks have been running into weird and very rare lockups for some
time now.  I didn't think this could have been from workqueue side
because no one else was reporting it.  This time, Eric had a kdump
which we looked into and it turned out this actually was a workqueue
bug and the bug has been there since the beginning of concurrency
managed workqueue.

A worker pool ensures forward progress of the workqueues associated
with it by always having at least one worker reserved from executing
work items.  When the pool is under contention, the idle one tries to
create more workers for the pool and if that doesn't succeed quickly
enough, it calls the rescuers to the pool.

This logic had a subtle race condition in an early exit path.  When a
worker invokes this manager function, the function may return %false
indicating that the caller may proceed to executing work items either
because another worker is already performing the role or conditions
have changed and the pool is no longer under contention.  The latter
part depended on the assumption that whether more workers are
necessary or not remains stable while the pool is locked; however,
pool->nr_running (concurrency count) may change asynchronously and it
getting bumped from zero asynchronously could send off the last idle
worker to execute work items.

The race window is fairly narrow, and, even when it gets triggered,
the pool deadlocks iff if all work items get blocked on pending work
items of the pool, which is highly unlikely but can be triggered by
xfs.

The patch removes the race window by removing the early exit path,
which doesn't server any purpose anymore anyway.

Thanks.

The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:

  Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.19-fixes

for you to fetch changes up to 29187a9eeaf362d8422e62e17a22a6e115277a49:

  workqueue: fix subtle pool management issue which can stall whole worker_pool (2015-01-16 14:21:16 -0500)

----------------------------------------------------------------
Tejun Heo (1):
      workqueue: fix subtle pool management issue which can stall whole worker_pool

 kernel/workqueue.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 6202b08..beeeac9 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1841,17 +1841,11 @@ static void pool_mayday_timeout(unsigned long __pool)
  * spin_lock_irq(pool->lock) which may be released and regrabbed
  * multiple times.  Does GFP_KERNEL allocations.  Called only from
  * manager.
- *
- * Return:
- * %false if no action was taken and pool->lock stayed locked, %true
- * otherwise.
  */
-static bool maybe_create_worker(struct worker_pool *pool)
+static void maybe_create_worker(struct worker_pool *pool)
 __releases(&pool->lock)
 __acquires(&pool->lock)
 {
-	if (!need_to_create_worker(pool))
-		return false;
 restart:
 	spin_unlock_irq(&pool->lock);
 
@@ -1877,7 +1871,6 @@ restart:
 	 */
 	if (need_to_create_worker(pool))
 		goto restart;
-	return true;
 }
 
 /**
@@ -1897,16 +1890,14 @@ restart:
  * multiple times.  Does GFP_KERNEL allocations.
  *
  * Return:
- * %false if the pool don't need management and the caller can safely start
- * processing works, %true indicates that the function released pool->lock
- * and reacquired it to perform some management function and that the
- * conditions that the caller verified while holding the lock before
- * calling the function might no longer be true.
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
 	 * Anyone who successfully grabs manager_arb wins the arbitration
@@ -1919,12 +1910,12 @@ static bool manage_workers(struct worker *worker)
 	 * actual management, the pool may stall indefinitely.
 	 */
 	if (!mutex_trylock(&pool->manager_arb))
-		return ret;
+		return false;
 
-	ret |= maybe_create_worker(pool);
+	maybe_create_worker(pool);
 
 	mutex_unlock(&pool->manager_arb);
-	return ret;
+	return true;
 }
 
 /**
