Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbaLHRrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 12:47:39 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:63303 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaLHRrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 12:47:37 -0500
Date: Mon, 8 Dec 2014 12:47:33 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH wq/for-3.19 3/3] workqueue: dump workqueues on sysrq-t
Message-ID: <20141208174733.GD12274@htj.dyndns.org>
References: <20141208174326.GB12274@htj.dyndns.org>
 <20141208174406.GC12274@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141208174406.GC12274@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workqueues are used extensively throughout the kernel but sometimes
it's difficult to debug stalls involving work items because visibility
into its inner workings is fairly limited.  Although sysrq-t task dump
annotates each active worker task with the information on the work
item being executed, it is challenging to find out which work items
are pending or delayed on which queues and how pools are being
managed.

This patch implements show_workqueue_state() which dumps all busy
workqueues and pools and is called from the sysrq-t handler.  At the
end of sysrq-t dump, something like the following is printed.

 Showing busy workqueues and worker pools:
 ...
 workqueue filler_wq: flags=0x0
   pwq 2: cpu=1 flags=0x0 nice=0 active=2/256
     in-flight: 491:filler_workfn, 507:filler_workfn
   pwq 0: cpu=0 flags=0x0 nice=0 active=2/256
     in-flight: 501:filler_workfn
     pending: filler_workfn
 ...
 workqueue test_wq: flags=0x8
   pwq 2: cpu=1 flags=0x0 nice=0 active=1/1
     in-flight: 510(RESCUER):test_workfn BAR(69) BAR(500)
     delayed: test_workfn1 BAR(492), test_workfn2
 ...
 pool 0: cpu=0 flags=0x0 nice=0 workers=2 manager: 137
 pool 2: cpu=1 flags=0x0 nice=0 workers=3 manager: 469
 pool 3: cpu=1 flags=0x0 nice=-20 workers=2 idle: 16
 pool 8: cpumask=0f flags=0x4 nice=0 workers=2 manager: 62

The above shows that test_wq is executing test_workfn() on pid 510
which is the rescuer and also that there are two tasks 69 and 500
waiting for the work item to finish in flush_work().  As test_wq has
max_active of 1, there are two work items for test_workfn1() and
test_workfn2() which are delayed till the current work item is
finished.  In addition, pid 492 is flushing test_workfn1().

The work item for test_workfn() is being executed on pwq of pool 2
which is the normal priority per-cpu pool for CPU 1.  The pool has
three workers, two of which are executing filler_workfn() for
filler_wq and the last one is assuming the manager role trying to
create more workers.

This extra workqueue state dump will hopefully help chasing down hangs
involving workqueues.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@redhat.com>
---
Hello,

If nobody objects, I'll push these three patches to print workqueue
information at the end of sysrq-t dump through wq/for-3.19.

Thanks.

 drivers/tty/sysrq.c       |    1 
 include/linux/workqueue.h |    1 
 kernel/workqueue.c        |  168 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 170 insertions(+)

--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -275,6 +275,7 @@ static struct sysrq_key_op sysrq_showreg
 static void sysrq_handle_showstate(int key)
 {
 	show_state();
+	show_workqueue_state();
 }
 static struct sysrq_key_op sysrq_showstate_op = {
 	.handler	= sysrq_handle_showstate,
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -457,6 +457,7 @@ extern bool workqueue_congested(int cpu,
 extern unsigned int work_busy(struct work_struct *work);
 extern __printf(1, 2) void set_worker_desc(const char *fmt, ...);
 extern void print_worker_info(const char *log_lvl, struct task_struct *task);
+extern void show_workqueue_state(void);
 
 /**
  * queue_work - queue work on a workqueue
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4419,6 +4419,174 @@ void print_worker_info(const char *log_l
 	}
 }
 
+static void pr_cont_pool_info(struct worker_pool *pool)
+{
+	if (pool->cpu >= 0)
+		pr_cont(" cpu=%d", pool->cpu);
+	else if (pool->node != NUMA_NO_NODE)
+		pr_cont(" node=%d", pool->node);
+
+	if (pool->cpu < 0) {
+		static char cpus_buf[PAGE_SIZE];
+
+		cpumask_scnprintf(cpus_buf, sizeof(cpus_buf),
+				  pool->attrs->cpumask);
+		pr_cont(" cpumask=%s", cpus_buf);
+	}
+	pr_cont(" flags=0x%x nice=%d", pool->flags, pool->attrs->nice);
+}
+
+static void pr_cont_work(bool comma, struct work_struct *work)
+{
+	if (work->func == wq_barrier_func) {
+		struct wq_barrier *barr =
+			container_of(work, struct wq_barrier, work);
+
+		pr_cont("%s BAR(%d)", comma ? "," : "",
+			task_pid_nr(barr->task));
+	} else {
+		pr_cont("%s %pf", comma ? "," : "", work->func);
+	}
+}
+
+static void show_pwq(struct pool_workqueue *pwq)
+{
+	struct worker_pool *pool = pwq->pool;
+	struct work_struct *work;
+	struct worker *worker;
+	bool has_in_flight = false, has_pending = false;
+	int bkt;
+
+	printk("  pwq %d:", pool->id);
+	pr_cont_pool_info(pool);
+
+	pr_cont(" active=%d/%d%s\n", pwq->nr_active, pwq->max_active,
+		!list_empty(&pwq->mayday_node) ? " MAYDAY" : "");
+
+	hash_for_each(pool->busy_hash, bkt, worker, hentry) {
+		if (worker->current_pwq == pwq) {
+			has_in_flight = true;
+			break;
+		}
+	}
+	if (has_in_flight) {
+		bool comma = false;
+
+		printk("    in-flight:");
+		hash_for_each(pool->busy_hash, bkt, worker, hentry) {
+			if (worker->current_pwq != pwq)
+				continue;
+
+			pr_cont("%s %d%s:%pf", comma ? "," : "",
+				task_pid_nr(worker->task),
+				worker == pwq->wq->rescuer ? "(RESCUER)" : "",
+				worker->current_func);
+			list_for_each_entry(work, &worker->scheduled, entry)
+				pr_cont_work(false, work);
+			comma = true;
+		}
+		pr_cont("\n");
+	}
+
+	list_for_each_entry(work, &pool->worklist, entry) {
+		if (get_work_pwq(work) == pwq) {
+			has_pending = true;
+			break;
+		}
+	}
+	if (has_pending) {
+		bool comma = false;
+
+		printk("    pending:");
+		list_for_each_entry(work, &pool->worklist, entry) {
+			if (get_work_pwq(work) != pwq)
+				continue;
+
+			pr_cont_work(comma, work);
+			comma = !(*work_data_bits(work) & WORK_STRUCT_LINKED);
+		}
+		pr_cont("\n");
+	}
+
+	if (!list_empty(&pwq->delayed_works)) {
+		bool comma = false;
+
+		printk("    delayed:");
+		list_for_each_entry(work, &pwq->delayed_works, entry) {
+			pr_cont_work(comma, work);
+			comma = !(*work_data_bits(work) & WORK_STRUCT_LINKED);
+		}
+		pr_cont("\n");
+	}
+}
+
+/**
+ * show_workqueue_state - dump workqueue state
+ *
+ * Called from a sysrq handler and prints out all busy workqueues and
+ * pools.
+ */
+void show_workqueue_state(void)
+{
+	struct workqueue_struct *wq;
+	struct worker_pool *pool;
+	unsigned long flags;
+	int pi;
+
+	rcu_read_lock_sched();
+
+	printk("Showing busy workqueues and worker pools:\n");
+
+	list_for_each_entry_rcu(wq, &workqueues, list) {
+		struct pool_workqueue *pwq;
+		bool idle = true;
+
+		for_each_pwq(pwq, wq) {
+			if (pwq->nr_active || !list_empty(&pwq->delayed_works)) {
+				idle = false;
+				break;
+			}
+		}
+		if (idle)
+			continue;
+
+		printk("workqueue %s: flags=0x%x\n", wq->name, wq->flags);
+
+		for_each_pwq(pwq, wq) {
+			spin_lock_irqsave(&pwq->pool->lock, flags);
+			if (pwq->nr_active || !list_empty(&pwq->delayed_works))
+				show_pwq(pwq);
+			spin_unlock_irqrestore(&pwq->pool->lock, flags);
+		}
+	}
+
+	for_each_pool(pool, pi) {
+		struct worker *worker;
+		bool first = true;
+
+		spin_lock_irqsave(&pool->lock, flags);
+		if (pool->nr_workers == pool->nr_idle)
+			goto next_pool;
+
+		printk("pool %d:", pool->id);
+		pr_cont_pool_info(pool);
+		pr_cont(" workers=%d", pool->nr_workers);
+		if (pool->manager)
+			pr_cont(" manager: %d",
+				task_pid_nr(pool->manager->task));
+		list_for_each_entry(worker, &pool->idle_list, entry) {
+			pr_cont(" %s%d", first ? "idle: " : "",
+				task_pid_nr(worker->task));
+			first = false;
+		}
+		pr_cont("\n");
+	next_pool:
+		spin_unlock_irqrestore(&pool->lock, flags);
+	}
+
+	rcu_read_unlock_sched();
+}
+
 /*
  * CPU hotplug.
  *
