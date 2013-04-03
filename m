Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab3DCTY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 15:24:59 -0400
Received: from mail-qe0-f47.google.com ([209.85.128.47]:59401 "EHLO
	mail-qe0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932267Ab3DCTY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 15:24:57 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, akpm@linux-foundation.org
Cc: jack@suse.cz, david@fromorbit.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 2/3] workqueue: include workqueue info when printing debug dump of a worker task
Date: Wed,  3 Apr 2013 12:24:31 -0700
Message-Id: <1365017072-32213-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365017072-32213-1-git-send-email-tj@kernel.org>
References: <1365017072-32213-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the problems that arise when converting dedicated custom
threadpool to workqueue is that the shared worker pool used by
workqueue anonimizes each worker making it more difficult to identify
what the worker was doing on which target from the output of sysrq-t
or debug dump from oops, BUG() and friends.

This patch implements set_worker_desc() which can be called from any
workqueue work function to set its description.  When the worker task
is dumped for whatever reason - sysrq-t, WARN, BUG, oops, lockdep
assertion and so on - the description will be printed out together
with the workqueue name and the worker function pointer.

The printing side is implemented by print_worker_info() which is
called from functions in task dump paths - sched_show_task() and
dump_stack_print_info().  print_worker_info() can be safely called on
any task in any state as long as the task struct itself is accessible.
It uses probe_*() functions to access worker fields.  It may print
garbage if something went very wrong, but it wouldn't cause (another)
oops.

The description is currently limited to 24bytes including the
terminating \0.  worker->desc_valid and workder->desc[] are added and
the 64 bytes marker which was already incorrect before adding the new
fields is moved to the correct position.

Here's an example dump with writeback updated to set the bdi name as
worker desc.

 Hardware name: Bochs
 Modules linked in:
 Pid: 7, comm: kworker/u9:0 Not tainted 3.9.0-rc1-work+ #1
 Workqueue: writeback bdi_writeback_workfn (flush-8:0)
  ffffffff820a3ab0 ffff88000f6e9cb8 ffffffff81c61845 ffff88000f6e9cf8
  ffffffff8108f50f 0000000000000000 0000000000000000 ffff88000cde16b0
  ffff88000cde1aa8 ffff88001ee19240 ffff88000f6e9fd8 ffff88000f6e9d08
 Call Trace:
  [<ffffffff81c61845>] dump_stack+0x19/0x1b
  [<ffffffff8108f50f>] warn_slowpath_common+0x7f/0xc0
  [<ffffffff8108f56a>] warn_slowpath_null+0x1a/0x20
  [<ffffffff81200150>] bdi_writeback_workfn+0x2a0/0x3b0
 ...

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>
---
 include/linux/workqueue.h   |  5 +++
 kernel/printk.c             |  2 ++
 kernel/sched/core.c         |  1 +
 kernel/workqueue.c          | 79 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/workqueue_internal.h | 12 ++++++-
 5 files changed, 98 insertions(+), 1 deletion(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 7179756..623488f 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -92,6 +92,9 @@ enum {
 	/* bit mask for work_busy() return values */
 	WORK_BUSY_PENDING	= 1 << 0,
 	WORK_BUSY_RUNNING	= 1 << 1,
+
+	/* maximum string length for set_worker_desc() */
+	WORKER_DESC_LEN		= 24,
 };
 
 struct work_struct {
@@ -447,6 +450,8 @@ extern void workqueue_set_max_active(struct workqueue_struct *wq,
 extern bool current_is_workqueue_rescuer(void);
 extern bool workqueue_congested(int cpu, struct workqueue_struct *wq);
 extern unsigned int work_busy(struct work_struct *work);
+extern __printf(1, 2) void set_worker_desc(const char *fmt, ...);
+extern void print_worker_info(const char *log_lvl, struct task_struct *task);
 
 /**
  * queue_work - queue work on a workqueue
diff --git a/kernel/printk.c b/kernel/printk.c
index 48bad34..36d5869 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -2892,6 +2892,8 @@ void dump_stack_print_info(const char *log_lvl)
 	if (dump_stack_arch_desc_str[0] != '\0')
 		printk("%sHardware name: %s\n",
 		       log_lvl, dump_stack_arch_desc_str);
+
+	print_worker_info(log_lvl, current);
 }
 
 /**
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 286066e..d6e4bb7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4634,6 +4634,7 @@ void sched_show_task(struct task_struct *p)
 		task_pid_nr(p), ppid,
 		(unsigned long)task_thread_info(p)->flags);
 
+	print_worker_info(KERN_INFO, p);
 	show_stack(p, NULL);
 }
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index dd2a4c4..0c01710 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -46,6 +46,7 @@
 #include <linux/rculist.h>
 #include <linux/nodemask.h>
 #include <linux/moduleparam.h>
+#include <linux/uaccess.h>
 
 #include "workqueue_internal.h"
 
@@ -2197,6 +2198,7 @@ __acquires(&pool->lock)
 	worker->current_work = NULL;
 	worker->current_func = NULL;
 	worker->current_pwq = NULL;
+	worker->desc_valid = false;
 	pwq_dec_nr_in_flight(pwq, work_color);
 }
 
@@ -4365,6 +4367,83 @@ unsigned int work_busy(struct work_struct *work)
 }
 EXPORT_SYMBOL_GPL(work_busy);
 
+/**
+ * set_worker_desc - set description for the current work item
+ * @fmt: printf-style format string
+ * @...: arguments for the format string
+ *
+ * This function can be called by a running work function to describe what
+ * the work item is about.  If the worker task gets dumped, this
+ * information will be printed out together to help debugging.  The
+ * description can be at most WORKER_DESC_LEN including the trailing '\0'.
+ */
+void set_worker_desc(const char *fmt, ...)
+{
+	struct worker *worker = current_wq_worker();
+	va_list args;
+
+	if (worker) {
+		va_start(args, fmt);
+		vsnprintf(worker->desc, sizeof(worker->desc), fmt, args);
+		va_end(args);
+		worker->desc_valid = true;
+	}
+}
+
+/**
+ * print_worker_info - print out worker information and description
+ * @log_lvl: the log level to use when printing
+ * @task: target task
+ *
+ * If @task is a worker and currently executing a work item, print out the
+ * name of the workqueue being serviced and worker description set with
+ * set_worker_desc() by the currently executing work item.
+ *
+ * This function can be safely called on any task as long as the
+ * task_struct itself is accessible.  While safe, this function isn't
+ * synchronized and may print out mixups or garbages of limited length.
+ */
+void print_worker_info(const char *log_lvl, struct task_struct *task)
+{
+	work_func_t *fn = NULL;
+	char name[WQ_NAME_LEN] = { };
+	char desc[WORKER_DESC_LEN] = { };
+	struct pool_workqueue *pwq = NULL;
+	struct workqueue_struct *wq = NULL;
+	bool desc_valid = false;
+	struct worker *worker;
+
+	if (!(task->flags & PF_WQ_WORKER))
+		return;
+
+	/*
+	 * This function is called without any synchronization and @task
+	 * could be in any state.  Be careful with dereferences.
+	 */
+	worker = probe_kthread_data(task);
+
+	/*
+	 * Carefully copy the associated workqueue's workfn and name.  Keep
+	 * the original last '\0' in case the original contains garbage.
+	 */
+	probe_kernel_read(&fn, &worker->current_func, sizeof(fn));
+	probe_kernel_read(&pwq, &worker->current_pwq, sizeof(pwq));
+	probe_kernel_read(&wq, &pwq->wq, sizeof(wq));
+	probe_kernel_read(name, wq->name, sizeof(name) - 1);
+
+	/* copy worker description */
+	probe_kernel_read(&desc_valid, &worker->desc_valid, sizeof(desc_valid));
+	if (desc_valid)
+		probe_kernel_read(desc, worker->desc, sizeof(desc) - 1);
+
+	if (fn || name[0] || desc[0]) {
+		printk("%sWorkqueue: %s %pf", log_lvl, name, fn);
+		if (desc[0])
+			pr_cont(" (%s)", desc);
+		pr_cont("\n");
+	}
+}
+
 /*
  * CPU hotplug.
  *
diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
index 84ab6e1..ad83c96 100644
--- a/kernel/workqueue_internal.h
+++ b/kernel/workqueue_internal.h
@@ -29,15 +29,25 @@ struct worker {
 	struct work_struct	*current_work;	/* L: work being processed */
 	work_func_t		current_func;	/* L: current_work's fn */
 	struct pool_workqueue	*current_pwq; /* L: current_work's pwq */
+	bool			desc_valid;	/* ->desc is valid */
 	struct list_head	scheduled;	/* L: scheduled works */
+
+	/* 64 bytes boundary on 64bit, 32 on 32bit */
+
 	struct task_struct	*task;		/* I: worker task */
 	struct worker_pool	*pool;		/* I: the associated pool */
 						/* L: for rescuers */
-	/* 64 bytes boundary on 64bit, 32 on 32bit */
+
 	unsigned long		last_active;	/* L: last active timestamp */
 	unsigned int		flags;		/* X: flags */
 	int			id;		/* I: worker id */
 
+	/*
+	 * Opaque string set with work_set_desc().  Printed out with task
+	 * dump for debugging - WARN, BUG, panic or sysrq.
+	 */
+	char			desc[WORKER_DESC_LEN];
+
 	/* used only by rescuers to point to the target workqueue */
 	struct workqueue_struct	*rescue_wq;	/* I: the workqueue to rescue */
 };
-- 
1.8.1.4

