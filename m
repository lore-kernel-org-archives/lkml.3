Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab3H0B3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:29:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab3H0BGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:06:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Andrey Isakov <andy51@gmx.ru>,
        Li Zefan <lizefan@huawei.com>
Subject: [ 02/13] workqueue: consider work function when searching for busy work items
Date: Mon, 26 Aug 2013 18:08:34 -0700
Message-Id: <20130827010310.032641422@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010309.850395966@linuxfoundation.org>
References: <20130827010309.850395966@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit a2c1c57be8d9fd5b716113c8991d3d702eeacf77 upstream.

To avoid executing the same work item concurrenlty, workqueue hashes
currently busy workers according to their current work items and looks
up the the table when it wants to execute a new work item.  If there
already is a worker which is executing the new work item, the new item
is queued to the found worker so that it gets executed only after the
current execution finishes.

Unfortunately, a work item may be freed while being executed and thus
recycled for different purposes.  If it gets recycled for a different
work item and queued while the previous execution is still in
progress, workqueue may make the new work item wait for the old one
although the two aren't really related in any way.

In extreme cases, this false dependency may lead to deadlock although
it's extremely unlikely given that there aren't too many self-freeing
work item users and they usually don't wait for other work items.

To alleviate the problem, record the current work function in each
busy worker and match it together with the work item address in
find_worker_executing_work().  While this isn't complete, it ensures
that unrelated work items don't interact with each other and in the
very unlikely case where a twisted wq user triggers it, it's always
onto itself making the culprit easy to spot.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Andrey Isakov <andy51@gmx.ru>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=51701
[lizf: Backported to 3.4:
 - Adjust context
 - Incorporate earlier logging cleanup in process_one_work() from
   044c782ce3a9 ('workqueue: fix checkpatch issues')]
Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/workqueue.c |   42 +++++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 11 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -128,6 +128,7 @@ struct worker {
 	};
 
 	struct work_struct	*current_work;	/* L: work being processed */
+	work_func_t		current_func;	/* L: current_work's fn */
 	struct cpu_workqueue_struct *current_cwq; /* L: current_work's cwq */
 	struct list_head	scheduled;	/* L: scheduled works */
 	struct task_struct	*task;		/* I: worker task */
@@ -838,7 +839,8 @@ static struct worker *__find_worker_exec
 	struct hlist_node *tmp;
 
 	hlist_for_each_entry(worker, tmp, bwh, hentry)
-		if (worker->current_work == work)
+		if (worker->current_work == work &&
+		    worker->current_func == work->func)
 			return worker;
 	return NULL;
 }
@@ -848,9 +850,27 @@ static struct worker *__find_worker_exec
  * @gcwq: gcwq of interest
  * @work: work to find worker for
  *
- * Find a worker which is executing @work on @gcwq.  This function is
- * identical to __find_worker_executing_work() except that this
- * function calculates @bwh itself.
+ * Find a worker which is executing @work on @gcwq by searching
+ * @gcwq->busy_hash which is keyed by the address of @work.  For a worker
+ * to match, its current execution should match the address of @work and
+ * its work function.  This is to avoid unwanted dependency between
+ * unrelated work executions through a work item being recycled while still
+ * being executed.
+ *
+ * This is a bit tricky.  A work item may be freed once its execution
+ * starts and nothing prevents the freed area from being recycled for
+ * another work item.  If the same work item address ends up being reused
+ * before the original execution finishes, workqueue will identify the
+ * recycled work item as currently executing and make it wait until the
+ * current execution finishes, introducing an unwanted dependency.
+ *
+ * This function checks the work item address, work function and workqueue
+ * to avoid false positives.  Note that this isn't complete as one may
+ * construct a work function which can introduce dependency onto itself
+ * through a recycled work item.  Well, if somebody wants to shoot oneself
+ * in the foot that badly, there's only so much we can do, and if such
+ * deadlock actually occurs, it should be easy to locate the culprit work
+ * function.
  *
  * CONTEXT:
  * spin_lock_irq(gcwq->lock).
@@ -1811,7 +1831,6 @@ __acquires(&gcwq->lock)
 	struct global_cwq *gcwq = cwq->gcwq;
 	struct hlist_head *bwh = busy_worker_head(gcwq, work);
 	bool cpu_intensive = cwq->wq->flags & WQ_CPU_INTENSIVE;
-	work_func_t f = work->func;
 	int work_color;
 	struct worker *collision;
 #ifdef CONFIG_LOCKDEP
@@ -1840,6 +1859,7 @@ __acquires(&gcwq->lock)
 	debug_work_deactivate(work);
 	hlist_add_head(&worker->hentry, bwh);
 	worker->current_work = work;
+	worker->current_func = work->func;
 	worker->current_cwq = cwq;
 	work_color = get_work_color(work);
 
@@ -1877,7 +1897,7 @@ __acquires(&gcwq->lock)
 	lock_map_acquire_read(&cwq->wq->lockdep_map);
 	lock_map_acquire(&lockdep_map);
 	trace_workqueue_execute_start(work);
-	f(work);
+	worker->current_func(work);
 	/*
 	 * While we must be careful to not use "work" after this, the trace
 	 * point will only record its address.
@@ -1887,11 +1907,10 @@ __acquires(&gcwq->lock)
 	lock_map_release(&cwq->wq->lockdep_map);
 
 	if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {
-		printk(KERN_ERR "BUG: workqueue leaked lock or atomic: "
-		       "%s/0x%08x/%d\n",
-		       current->comm, preempt_count(), task_pid_nr(current));
-		printk(KERN_ERR "    last function: ");
-		print_symbol("%s\n", (unsigned long)f);
+		pr_err("BUG: workqueue leaked lock or atomic: %s/0x%08x/%d\n"
+		       "     last function: %pf\n",
+		       current->comm, preempt_count(), task_pid_nr(current),
+		       worker->current_func);
 		debug_show_held_locks(current);
 		dump_stack();
 	}
@@ -1905,6 +1924,7 @@ __acquires(&gcwq->lock)
 	/* we're done with it, release */
 	hlist_del_init(&worker->hentry);
 	worker->current_work = NULL;
+	worker->current_func = NULL;
 	worker->current_cwq = NULL;
 	cwq_dec_nr_in_flight(cwq, work_color, false);
 }


