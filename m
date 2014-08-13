Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaHMIXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:23:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51970 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbaHMIXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:23:03 -0400
Date: Wed, 13 Aug 2014 01:22:03 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-fadfe7be6e50de7f03913833b33c56cd8fb66bac@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, mark.rutland@arm.com, acme@kernel.org,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        mark.rutland@arm.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1406896382-18404-4-git-send-email-jolsa@kernel.org>
References: <1406896382-18404-4-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Add queued work to remove orphaned child events
Git-Commit-ID: fadfe7be6e50de7f03913833b33c56cd8fb66bac
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fadfe7be6e50de7f03913833b33c56cd8fb66bac
Gitweb:     http://git.kernel.org/tip/fadfe7be6e50de7f03913833b33c56cd8fb66bac
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Fri, 1 Aug 2014 14:33:02 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Aug 2014 07:51:04 +0200

perf: Add queued work to remove orphaned child events

In cases when the  owner task exits before the workload and the
workload made some forks, all the events stay in until the last
workload process exits. Thats' because each child event holds
parent reference.

We want to release all children events once the parent is gone,
because at that time there's no process to read them anyway, so
they're just eating resources.

This removal  races with process exit, which removes all events
and fork, which clone events.  To be clear of those two, adding
work queue to remove orphaned child for context in case such
event is detected.

Using delayed work queue (with delay == 1), because we queue this
work under perf scheduler callbacks. Normal work queue tries to wake
up the queue process, which deadlocks on rq->lock in this place.

Also preventing clones from abandoned parent event.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1406896382-18404-4-git-send-email-jolsa@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/perf_event.h |  4 +++
 kernel/events/core.c       | 87 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 90 insertions(+), 1 deletion(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 707617a..ef5b62b 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -52,6 +52,7 @@ struct perf_guest_info_callbacks {
 #include <linux/atomic.h>
 #include <linux/sysfs.h>
 #include <linux/perf_regs.h>
+#include <linux/workqueue.h>
 #include <asm/local.h>
 
 struct perf_callchain_entry {
@@ -507,6 +508,9 @@ struct perf_event_context {
 	int				nr_cgroups;	 /* cgroup evts */
 	int				nr_branch_stack; /* branch_stack evt */
 	struct rcu_head			rcu_head;
+
+	struct delayed_work		orphans_remove;
+	bool				orphans_remove_sched;
 };
 
 /*
diff --git a/kernel/events/core.c b/kernel/events/core.c
index bbb3ca2..a254605 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -46,6 +46,8 @@
 
 #include <asm/irq_regs.h>
 
+static struct workqueue_struct *perf_wq;
+
 struct remote_function_call {
 	struct task_struct	*p;
 	int			(*func)(void *info);
@@ -1381,6 +1383,45 @@ out:
 		perf_event__header_size(tmp);
 }
 
+/*
+ * User event without the task.
+ */
+static bool is_orphaned_event(struct perf_event *event)
+{
+	return event && !is_kernel_event(event) && !event->owner;
+}
+
+/*
+ * Event has a parent but parent's task finished and it's
+ * alive only because of children holding refference.
+ */
+static bool is_orphaned_child(struct perf_event *event)
+{
+	return is_orphaned_event(event->parent);
+}
+
+static void orphans_remove_work(struct work_struct *work);
+
+static void schedule_orphans_remove(struct perf_event_context *ctx)
+{
+	if (!ctx->task || ctx->orphans_remove_sched || !perf_wq)
+		return;
+
+	if (queue_delayed_work(perf_wq, &ctx->orphans_remove, 1)) {
+		get_ctx(ctx);
+		ctx->orphans_remove_sched = true;
+	}
+}
+
+static int __init perf_workqueue_init(void)
+{
+	perf_wq = create_singlethread_workqueue("perf");
+	WARN(!perf_wq, "failed to create perf workqueue\n");
+	return perf_wq ? 0 : -1;
+}
+
+core_initcall(perf_workqueue_init);
+
 static inline int
 event_filter_match(struct perf_event *event)
 {
@@ -1430,6 +1471,9 @@ event_sched_out(struct perf_event *event,
 	if (event->attr.exclusive || !cpuctx->active_oncpu)
 		cpuctx->exclusive = 0;
 
+	if (is_orphaned_child(event))
+		schedule_orphans_remove(ctx);
+
 	perf_pmu_enable(event->pmu);
 }
 
@@ -1732,6 +1776,9 @@ event_sched_in(struct perf_event *event,
 	if (event->attr.exclusive)
 		cpuctx->exclusive = 1;
 
+	if (is_orphaned_child(event))
+		schedule_orphans_remove(ctx);
+
 out:
 	perf_pmu_enable(event->pmu);
 
@@ -3074,6 +3121,7 @@ static void __perf_event_init_context(struct perf_event_context *ctx)
 	INIT_LIST_HEAD(&ctx->flexible_groups);
 	INIT_LIST_HEAD(&ctx->event_list);
 	atomic_set(&ctx->refcount, 1);
+	INIT_DELAYED_WORK(&ctx->orphans_remove, orphans_remove_work);
 }
 
 static struct perf_event_context *
@@ -3405,6 +3453,42 @@ static int perf_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+/*
+ * Remove all orphanes events from the context.
+ */
+static void orphans_remove_work(struct work_struct *work)
+{
+	struct perf_event_context *ctx;
+	struct perf_event *event, *tmp;
+
+	ctx = container_of(work, struct perf_event_context,
+			   orphans_remove.work);
+
+	mutex_lock(&ctx->mutex);
+	list_for_each_entry_safe(event, tmp, &ctx->event_list, event_entry) {
+		struct perf_event *parent_event = event->parent;
+
+		if (!is_orphaned_child(event))
+			continue;
+
+		perf_remove_from_context(event, true);
+
+		mutex_lock(&parent_event->child_mutex);
+		list_del_init(&event->child_list);
+		mutex_unlock(&parent_event->child_mutex);
+
+		free_event(event);
+		put_event(parent_event);
+	}
+
+	raw_spin_lock_irq(&ctx->lock);
+	ctx->orphans_remove_sched = false;
+	raw_spin_unlock_irq(&ctx->lock);
+	mutex_unlock(&ctx->mutex);
+
+	put_ctx(ctx);
+}
+
 u64 perf_event_read_value(struct perf_event *event, u64 *enabled, u64 *running)
 {
 	struct perf_event *child;
@@ -7709,7 +7793,8 @@ inherit_event(struct perf_event *parent_event,
 	if (IS_ERR(child_event))
 		return child_event;
 
-	if (!atomic_long_inc_not_zero(&parent_event->refcount)) {
+	if (is_orphaned_event(parent_event) ||
+	    !atomic_long_inc_not_zero(&parent_event->refcount)) {
 		free_event(child_event);
 		return NULL;
 	}
