Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab3HEALk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 20:11:40 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37180 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab3HEALj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 20:11:39 -0400
Date: Sun, 4 Aug 2013 20:11:35 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] workqueue fixes for 3.11-rc4
Message-ID: <20130805001135.GB12029@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

A lockdep notation update so that nested work_on_cpu() invocations
don't lead to spurious lockdep warnings and fix for an unbound attr
bug which made what's shown in sysfs deviate from the actual ones.
Both patches have pretty limited scope.

The two patches are available in the following branch

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.11-fixes

for you to fetch changes up to 2865a8fb44cc32420407362cbda80c10fa09c6b2:

  workqueue: copy workqueue_attrs with all fields (2013-08-01 08:36:40 -0400)

Thanks.

----------------------------------------------------------------
Lai Jiangshan (1):
      workqueue: allow work_on_cpu() to be called recursively

Shaohua Li (1):
      workqueue: copy workqueue_attrs with all fields

 kernel/workqueue.c | 44 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 10 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f02c4a4..726adc8 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2817,6 +2817,19 @@ already_gone:
 	return false;
 }
 
+static bool __flush_work(struct work_struct *work)
+{
+	struct wq_barrier barr;
+
+	if (start_flush_work(work, &barr)) {
+		wait_for_completion(&barr.done);
+		destroy_work_on_stack(&barr.work);
+		return true;
+	} else {
+		return false;
+	}
+}
+
 /**
  * flush_work - wait for a work to finish executing the last queueing instance
  * @work: the work to flush
@@ -2830,18 +2843,10 @@ already_gone:
  */
 bool flush_work(struct work_struct *work)
 {
-	struct wq_barrier barr;
-
 	lock_map_acquire(&work->lockdep_map);
 	lock_map_release(&work->lockdep_map);
 
-	if (start_flush_work(work, &barr)) {
-		wait_for_completion(&barr.done);
-		destroy_work_on_stack(&barr.work);
-		return true;
-	} else {
-		return false;
-	}
+	return __flush_work(work);
 }
 EXPORT_SYMBOL_GPL(flush_work);
 
@@ -3411,6 +3416,12 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
 {
 	to->nice = from->nice;
 	cpumask_copy(to->cpumask, from->cpumask);
+	/*
+	 * Unlike hash and equality test, this function doesn't ignore
+	 * ->no_numa as it is used for both pool and wq attrs.  Instead,
+	 * get_unbound_pool() explicitly clears ->no_numa after copying.
+	 */
+	to->no_numa = from->no_numa;
 }
 
 /* hash value of the content of @attr */
@@ -3578,6 +3589,12 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 	lockdep_set_subclass(&pool->lock, 1);	/* see put_pwq() */
 	copy_workqueue_attrs(pool->attrs, attrs);
 
+	/*
+	 * no_numa isn't a worker_pool attribute, always clear it.  See
+	 * 'struct workqueue_attrs' comments for detail.
+	 */
+	pool->attrs->no_numa = false;
+
 	/* if cpumask is contained inside a NUMA node, we belong to that node */
 	if (wq_numa_enabled) {
 		for_each_node(node) {
@@ -4756,7 +4773,14 @@ long work_on_cpu(int cpu, long (*fn)(void *), void *arg)
 
 	INIT_WORK_ONSTACK(&wfc.work, work_for_cpu_fn);
 	schedule_work_on(cpu, &wfc.work);
-	flush_work(&wfc.work);
+
+	/*
+	 * The work item is on-stack and can't lead to deadlock through
+	 * flushing.  Use __flush_work() to avoid spurious lockdep warnings
+	 * when work_on_cpu()s are nested.
+	 */
+	__flush_work(&wfc.work);
+
 	return wfc.ret;
 }
 EXPORT_SYMBOL_GPL(work_on_cpu);

-- 
tejun
