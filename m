Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaJVN6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 09:58:05 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:37324 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbaJVN6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:58:00 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, rafael.j.wysocki@intel.com, mingo@kernel.org,
        peterz@infradead.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, mturquette@linaro.org,
        tuukka.tikkanen@linaro.org, nicolas.pitre@linaro.org,
        patches@linaro.org
Subject: [RFD PATCH 01/10] sched: add io latency framework
Date: Wed, 22 Oct 2014 15:57:44 +0200
Message-Id: <1413986273-28522-2-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413986273-28522-1-git-send-email-daniel.lezcano@linaro.org>
References: <1413986273-28522-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to have a good prediction of when will occur the next event,
the cpuidle menu governor does some statistics about the occurences of
an event waking up a cpu. For more details, refer to the menu.c's
header file located in drivers/cpuidle/governors.

A part of the prediction is taking into account the number of pending
IO on the cpu and depending on this number it will use a 'magic'
number to force the selection of shallow states. It makes sense and
provided a good improvement in terms of system latencies for
server. Unfortunately there are some drawbacks of this approach. The
first one is the empirical approach, based on measurements for a
specific hardware and architecture giving the magic 'performance
multiplier' which may not fit well for different architecture as well
as new hardware which evolve during time. The second one is the mix of
all the wakeup sources making impossible to track when a task is
migrated across the cpus. And the last one, is the lack of correctly
tracking what is happening on the system.

In order to improve that, we can classify three kind of events:

1. totally predictable events : this is the case for the timers

2. partially predictable events : for example: hard disk accesses with
sleep time which are more or less inside a reasonable interval, the
same for SSD or SD-card

3. difficult to predict events : network incoming packet, keyboard or
mouse event. These ones need a statistical approach.

At this moment, 1., 2. and 3. are all mixed in the governors
statistics.

This patchset provides a simplified version of an io latency tracking
mechanism in order to separate and improve the category 2, that is the
partially predictable events. As the scheduler is a good place to
measure how long a task is blocked in an IO, all the code of this
patchset is tied with it.

The sched entity and the io latency tracking share the same design:

There is a rb tree per cpu. Each time a task is blocked on an IO, it
is inserted into the tree. When the IO is complete and the task is
woken up, its avg latency is updated with the time spent to wait the
IO and it is removed from the tree. The next time, it will be inserted
into the tree again in case of io_schedule.

If there are several tasks blocked on an IO, the left most node of the
tree is the minimal latency, in other words it gives for the IO the
next event. This information may need to be balanced regarding the
number of pendings IO (the more the disk is accessing, the slower it
is).

By splitting the three kind of categories we can guess more accurately
the next event on the system in conjunction with the next timer and
some simplified statistics from the menu governor. Furthermore, that
has the benefit to take into account a task migration as the information
is embedded with it.

This is a simplified version because the tracking could be greatly
improved by a polynomial regression like the sched entity tracking and
the latencies should also be per device but that implies a bigger
impact as the different callers of io_schedule have to provide the
dev_t parameter. A too complex patch won't help the understanding.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 include/linux/sched.h     |  13 ++++
 init/Kconfig              |  11 +++
 kernel/fork.c             |   4 +-
 kernel/sched/Makefile     |   1 +
 kernel/sched/core.c       |   6 ++
 kernel/sched/io_latency.c | 174 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/io_latency.h |  38 ++++++++++
 7 files changed, 246 insertions(+), 1 deletion(-)
 create mode 100644 kernel/sched/io_latency.c
 create mode 100644 kernel/sched/io_latency.h

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5c2c885..6af032b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1221,6 +1221,16 @@ enum perf_event_task_context {
 	perf_nr_task_contexts,
 };
 
+
+#ifdef CONFIG_SCHED_IO_LATENCY
+struct io_latency_node {
+	struct rb_node node;
+	unsigned int avg_latency;
+	ktime_t start_time;
+	ktime_t end_time;
+};
+#endif
+
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	void *stack;
@@ -1644,6 +1654,9 @@ struct task_struct {
 	unsigned int	sequential_io;
 	unsigned int	sequential_io_avg;
 #endif
+#ifdef CONFIG_SCHED_IO_LATENCY
+	struct io_latency_node io_latency;
+#endif
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
diff --git a/init/Kconfig b/init/Kconfig
index e84c642..b6d2387 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1228,6 +1228,17 @@ config SCHED_AUTOGROUP
 	  desktop applications.  Task group autogeneration is currently based
 	  upon task session.
 
+config SCHED_IO_LATENCY
+	bool "IO latency tracking for the scheduler"
+	depends on SMP
+	help
+	  This option tracks for each task the io latency average time it has
+	  been blocked on for each cpu. It helps to have more information
+	  regarding how long a cpu will be idle and to take better scheduling
+	  decision.
+
+	  If unsure, say Y.
+
 config SYSFS_DEPRECATED
 	bool "Enable deprecated sysfs features to support old userspace tools"
 	depends on SYSFS
diff --git a/kernel/fork.c b/kernel/fork.c
index 0cf9cdb..7201bc4 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -345,7 +345,9 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 #endif
 	tsk->splice_pipe = NULL;
 	tsk->task_frag.page = NULL;
-
+#ifdef CONFIG_SCHED_IO_LATENCY
+	tsk->io_latency.avg_latency = 0;
+#endif
 	account_kernel_stack(ti, 1);
 
 	return tsk;
diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
index ab32b7b..4197807 100644
--- a/kernel/sched/Makefile
+++ b/kernel/sched/Makefile
@@ -19,3 +19,4 @@ obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
 obj-$(CONFIG_SCHEDSTATS) += stats.o
 obj-$(CONFIG_SCHED_DEBUG) += debug.o
 obj-$(CONFIG_CGROUP_CPUACCT) += cpuacct.o
+obj-$(CONFIG_SCHED_IO_LATENCY) += io_latency.o
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ec1a286..64181f6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -84,6 +84,7 @@
 #endif
 
 #include "sched.h"
+#include "io_latency.h"
 #include "../workqueue_internal.h"
 #include "../smpboot.h"
 
@@ -4338,7 +4339,9 @@ void __sched io_schedule(void)
 	atomic_inc(&rq->nr_iowait);
 	blk_flush_plug(current);
 	current->in_iowait = 1;
+	io_latency_begin(rq, current);
 	schedule();
+	io_latency_end(rq, current);
 	current->in_iowait = 0;
 	atomic_dec(&rq->nr_iowait);
 	delayacct_blkio_end();
@@ -4354,7 +4357,9 @@ long __sched io_schedule_timeout(long timeout)
 	atomic_inc(&rq->nr_iowait);
 	blk_flush_plug(current);
 	current->in_iowait = 1;
+	io_latency_begin(rq, current);
 	ret = schedule_timeout(timeout);
+	io_latency_end(rq, current);
 	current->in_iowait = 0;
 	atomic_dec(&rq->nr_iowait);
 	delayacct_blkio_end();
@@ -7030,6 +7035,7 @@ void __init sched_init(void)
 #endif
 		init_rq_hrtick(rq);
 		atomic_set(&rq->nr_iowait, 0);
+		io_latency_init(rq);
 	}
 
 	set_load_weight(&init_task);
diff --git a/kernel/sched/io_latency.c b/kernel/sched/io_latency.c
new file mode 100644
index 0000000..2d56a38
--- /dev/null
+++ b/kernel/sched/io_latency.c
@@ -0,0 +1,174 @@
+/*
+ * Copyright (c) 2014 ARM/Linaro
+ *
+ * Author: Daniel Lezcano <daniel.lezcano@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/percpu.h>
+#include <linux/ktime.h>
+#include <linux/rbtree.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+#include "sched.h"
+
+struct io_latency_tree {
+	spinlock_t lock;
+	struct rb_root tree;
+	struct io_latency_node *left_most;
+};
+
+static DEFINE_PER_CPU(struct io_latency_tree, latency_trees);
+
+/**
+ * io_latency_init : initialization routine to be called for each possible cpu.
+ *
+ * @rq: the runqueue associated with the cpu
+ *
+ */
+void io_latency_init(struct rq *rq)
+{
+	int cpu = rq->cpu;
+	struct io_latency_tree *latency_tree = &per_cpu(latency_trees, cpu);
+	struct rb_root *root = &latency_tree->tree;
+
+	spin_lock_init(&latency_tree->lock);
+	latency_tree->left_most = NULL;
+	root->rb_node = NULL;
+}
+
+/**
+ * io_latency_get_sleep_length: compute the expected sleep time
+ *
+ * @rq: the runqueue associated with the cpu
+ *
+ * Returns the minimal estimated remaining sleep time for the pending IOs
+ */
+s64 io_latency_get_sleep_length(struct rq *rq)
+{
+	int cpu = rq->cpu;
+	struct io_latency_tree *latency_tree = &per_cpu(latency_trees, cpu);
+	struct io_latency_node *node;
+	ktime_t now = ktime_get();
+	s64 diff;
+
+	node = latency_tree->left_most;
+
+	if (!node)
+		return 0;
+
+	diff = ktime_to_us(ktime_sub(now, node->start_time));
+	diff = node->avg_latency - diff;
+
+	/* Estimation was wrong, return 0 */
+	if (diff < 0)
+		return 0;
+
+	return diff;
+}
+
+/**
+ * io_latency_avg: compute the io latency sliding average value
+ *
+ * @node: a rb tree node belonging to a task
+ *
+ */
+static void io_latency_avg(struct io_latency_node *node)
+{
+	/* MA*[i]= MA*[i-1] + X[i] - MA*[i-1]/N */
+	s64 latency = ktime_to_us(ktime_sub(node->end_time, node->start_time));
+	s64 diff = latency - node->avg_latency;
+
+	node->avg_latency = node->avg_latency + (diff >> 6);
+}
+
+/**
+ * io_latency_begin - insert the node in the rb tree
+ *
+ * @rq: the runqueue the task is running on
+ * @task: the task being blocked on an IO
+ *
+ * Inserts the node in the rbtree in an ordered manner. If this task
+ * has the minimal io latency of all the tasks blocked on IO, it falls
+ * at the left most node and a shortcut is used.  Stores the start
+ * time of the io schedule.
+ *
+ */
+int io_latency_begin(struct rq *rq, struct task_struct *tsk)
+{
+	int cpu = rq->cpu;
+	struct io_latency_tree *latency_tree = &per_cpu(latency_trees, cpu);
+	struct rb_root *root = &latency_tree->tree;
+	struct io_latency_node *node = &tsk->io_latency;
+	struct rb_node **new = &root->rb_node, *parent = NULL;
+	struct io_latency_node *lat;
+	int leftmost = 1;
+
+	node->start_time = ktime_get();
+
+	spin_lock(&latency_tree->lock);
+
+	while (*new) {
+		lat = rb_entry(*new, struct io_latency_node, node);
+
+		parent = *new;
+
+		if (lat->avg_latency > node->avg_latency)
+			new = &parent->rb_left;
+		else {
+			new = &parent->rb_right;
+			leftmost = 0;
+		}
+	}
+
+	if (leftmost)
+		latency_tree->left_most = node;
+
+	rb_link_node(&node->node, parent, new);
+	rb_insert_color(&node->node, root);
+
+	spin_unlock(&latency_tree->lock);
+
+	return 0;
+}
+
+/**
+ * io_latency_end - Removes the node from the rb tree
+ *
+ * @rq: the runqueue the task belongs to
+ * @tsk: the task woken up after an IO completion
+ *
+ * Removes the node for the rb tree for this cpu. Update the left most
+ * node with the next node if itself it is the left most
+ * node. Retrieves the end time after the io has complete and update
+ * the io latency average time
+ */
+void io_latency_end(struct rq *rq, struct task_struct *tsk)
+{
+	int cpu = rq->cpu;
+	struct io_latency_tree *latency_tree = &per_cpu(latency_trees, cpu);
+	struct rb_root *root = &latency_tree->tree;
+	struct io_latency_node *old = &tsk->io_latency;
+
+	old->end_time = ktime_get();
+
+	spin_lock(&latency_tree->lock);
+
+	if (latency_tree->left_most == old) {
+		struct rb_node *next_node =
+			rb_next(&latency_tree->left_most->node);
+		latency_tree->left_most =
+			rb_entry(next_node, struct io_latency_node, node);
+	}
+
+	rb_erase(&old->node, root);
+
+	spin_unlock(&latency_tree->lock);
+
+	io_latency_avg(old);
+}
diff --git a/kernel/sched/io_latency.h b/kernel/sched/io_latency.h
new file mode 100644
index 0000000..62ece7c
--- /dev/null
+++ b/kernel/sched/io_latency.h
@@ -0,0 +1,38 @@
+/*
+ * Copyright (c) 2014 ARM/Linaro
+ *
+ * Author: Daniel Lezcano <daniel.lezcano@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Maintainer: Daniel Lezcano <daniel.lezcano@linaro.org>
+ */
+
+#ifdef CONFIG_SCHED_IO_LATENCY
+extern void io_latency_init(struct rq *rq);
+extern int  io_latency_begin(struct rq *rq, struct task_struct *tsk);
+extern void io_latency_end(struct rq *rq, struct task_struct *tsk);
+extern int  io_latency_get_sleep_length(struct rq *rq);
+#else
+static inline void io_latency_init(struct rq *rq)
+{
+	;
+}
+
+static inline int io_latency_begin(struct rq *rq, struct task_struct *tsk)
+{
+	return 0;
+}
+
+static inline void io_latency_end(struct rq *rq, struct task_struct *tsk)
+{
+	;
+}
+
+static inline int io_latency_get_sleep_length(struct rq *rq)
+{
+	return 0;
+}
+#endif
-- 
1.9.1

