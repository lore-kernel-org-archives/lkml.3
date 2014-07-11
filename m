Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbaGKUaE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 16:30:04 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:33916 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaGKUaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 16:30:01 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Josh Triplett <josh@freedesktop.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Iulia Manda <iulia.manda21@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Cc: Joe Perches <joe@perches.com>
Subject: [PATCH 1/1] rcutorture: fixes for printing message buffer
Date: Fri, 11 Jul 2014 16:30:14 -0400
Message-Id: <1405110617-16498-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use snprintf() instead of sprintf() for writing to the message buffer.
Also use vmalloc() for the allocation of the message buffer. Since pr_alert() is
limited to print LOG_LINE_MAX characters at a time, we print the buffer in a
loop one line at a time.

I tested this using the parse-torture.sh script as follows:

$ dmesg | grep torture > log.txt
$ bash parse-torture.sh log.txt test
$

There were no warnings which means that parsing went fine.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
cc: Joe Perches <joe@perches.com>
Link: https://lkml.org/lkml/2014/6/18/604
---
 include/linux/torture.h |  2 +-
 kernel/rcu/rcutorture.c | 95 +++++++++++++++++++++++++++++++------------------
 kernel/torture.c        |  7 ++--
 3 files changed, 66 insertions(+), 38 deletions(-)

diff --git a/include/linux/torture.h b/include/linux/torture.h
index 5ca58fc..1e47ec7 100644
--- a/include/linux/torture.h
+++ b/include/linux/torture.h
@@ -51,7 +51,7 @@
 
 /* Definitions for online/offline exerciser. */
 int torture_onoff_init(long ooholdoff, long oointerval);
-char *torture_onoff_stats(char *page);
+int torture_onoff_stats(char *page, int size);
 bool torture_onoff_failures(void);
 
 /* Low-rider random number generator. */
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 5ec0452..ab2cfbd 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -242,7 +242,7 @@ struct rcu_torture_ops {
 	void (*call)(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
 	void (*cb_barrier)(void);
 	void (*fqs)(void);
-	void (*stats)(char *page);
+	int (*stats)(char *page, int size);
 	int irq_capable;
 	int can_boost;
 	const char *name;
@@ -525,21 +525,23 @@ static void srcu_torture_barrier(void)
 	srcu_barrier(&srcu_ctl);
 }
 
-static void srcu_torture_stats(char *page)
+static int srcu_torture_stats(char *page, int size)
 {
-	int cpu;
+	int cpu, used;
 	int idx = srcu_ctl.completed & 0x1;
 
-	page += sprintf(page, "%s%s per-CPU(idx=%d):",
+	used = snprintf(page, size, "%s%s per-CPU(idx=%d):",
 		       torture_type, TORTURE_FLAG, idx);
 	for_each_possible_cpu(cpu) {
 		long c0, c1;
 
 		c0 = (long)per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[!idx];
 		c1 = (long)per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[idx];
-		page += sprintf(page, " %d(%ld,%ld)", cpu, c0, c1);
+		used += snprintf(page + used, size - used,
+				" %d(%ld,%ld)", cpu, c0, c1);
 	}
-	sprintf(page, "\n");
+	used += snprintf(page + used, size - used, "\n");
+	return used;
 }
 
 static void srcu_torture_synchronize_expedited(void)
@@ -1033,10 +1035,10 @@ rcu_torture_reader(void *arg)
 /*
  * Create an RCU-torture statistics message in the specified buffer.
  */
-static void
-rcu_torture_printk(char *page)
+static int
+rcu_torture_printk(char *page, int size)
 {
-	int cpu;
+	int cpu, used = 0;
 	int i;
 	long pipesummary[RCU_TORTURE_PIPE_LEN + 1] = { 0 };
 	long batchsummary[RCU_TORTURE_PIPE_LEN + 1] = { 0 };
@@ -1052,8 +1054,9 @@ rcu_torture_printk(char *page)
 		if (pipesummary[i] != 0)
 			break;
 	}
-	page += sprintf(page, "%s%s ", torture_type, TORTURE_FLAG);
-	page += sprintf(page,
+	used += snprintf(page + used, size - used,
+			"%s%s ", torture_type, TORTURE_FLAG);
+	used += snprintf(page + used, size - used,
 		       "rtc: %p ver: %lu tfle: %d rta: %d rtaf: %d rtf: %d ",
 		       rcu_torture_current,
 		       rcu_torture_current_version,
@@ -1061,46 +1064,54 @@ rcu_torture_printk(char *page)
 		       atomic_read(&n_rcu_torture_alloc),
 		       atomic_read(&n_rcu_torture_alloc_fail),
 		       atomic_read(&n_rcu_torture_free));
-	page += sprintf(page, "rtmbe: %d rtbke: %ld rtbre: %ld ",
+	used += snprintf(page + used, size - used,
+		       "rtmbe: %d rtbke: %ld rtbre: %ld ",
 		       atomic_read(&n_rcu_torture_mberror),
 		       n_rcu_torture_boost_ktrerror,
 		       n_rcu_torture_boost_rterror);
-	page += sprintf(page, "rtbf: %ld rtb: %ld nt: %ld ",
+	used += snprintf(page + used, size - used,
+		       "rtbf: %ld rtb: %ld nt: %ld ",
 		       n_rcu_torture_boost_failure,
 		       n_rcu_torture_boosts,
 		       n_rcu_torture_timers);
-	page = torture_onoff_stats(page);
-	page += sprintf(page, "barrier: %ld/%ld:%ld",
+	used += torture_onoff_stats(page + used, size - used);
+	used += snprintf(page + used, size - used,
+		       "barrier: %ld/%ld:%ld",
 		       n_barrier_successes,
 		       n_barrier_attempts,
 		       n_rcu_torture_barrier_error);
-	page += sprintf(page, "\n%s%s ", torture_type, TORTURE_FLAG);
+	used += snprintf(page + used, size - used,
+			"\n%s%s ", torture_type, TORTURE_FLAG);
 	if (atomic_read(&n_rcu_torture_mberror) != 0 ||
 	    n_rcu_torture_barrier_error != 0 ||
 	    n_rcu_torture_boost_ktrerror != 0 ||
 	    n_rcu_torture_boost_rterror != 0 ||
 	    n_rcu_torture_boost_failure != 0 ||
 	    i > 1) {
-		page += sprintf(page, "!!! ");
+		used += snprintf(page + used, size - used, "!!! ");
 		atomic_inc(&n_rcu_torture_error);
 		WARN_ON_ONCE(1);
 	}
-	page += sprintf(page, "Reader Pipe: ");
+	used += snprintf(page + used, size - used, "Reader Pipe: ");
 	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++)
-		page += sprintf(page, " %ld", pipesummary[i]);
-	page += sprintf(page, "\n%s%s ", torture_type, TORTURE_FLAG);
-	page += sprintf(page, "Reader Batch: ");
+		used += snprintf(page + used, size - used,
+				" %ld", pipesummary[i]);
+	used += snprintf(page + used, size - used,
+			"\n%s%s ", torture_type, TORTURE_FLAG);
+	used += snprintf(page + used, size - used, "Reader Batch: ");
 	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++)
-		page += sprintf(page, " %ld", batchsummary[i]);
-	page += sprintf(page, "\n%s%s ", torture_type, TORTURE_FLAG);
-	page += sprintf(page, "Free-Block Circulation: ");
+		used += snprintf(page + used, size - used,
+				" %ld", batchsummary[i]);
+	used += snprintf(page + used, size - used,
+			"\n%s%s ", torture_type, TORTURE_FLAG);
+	used += snprintf(page + used, size - used, "Free-Block Circulation: ");
 	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++) {
-		page += sprintf(page, " %d",
+		used += snprintf(page + used, size - used, " %d",
 			       atomic_read(&rcu_torture_wcount[i]));
 	}
-	page += sprintf(page, "\n");
+	used += snprintf(page + used, size - used, "\n");
 	if (cur_ops->stats)
-		cur_ops->stats(page);
+		used += cur_ops->stats(page + used, size - used);
 	if (rtcv_snap == rcu_torture_current_version &&
 	    rcu_torture_current != NULL) {
 		int __maybe_unused flags;
@@ -1109,7 +1120,7 @@ rcu_torture_printk(char *page)
 
 		rcutorture_get_gp_data(cur_ops->ttype,
 				       &flags, &gpnum, &completed);
-		page += sprintf(page,
+		used += snprintf(page + used, size - used,
 				"??? Writer stall state %d g%lu c%lu f%#x\n",
 				rcu_torture_writer_state,
 				gpnum, completed, flags);
@@ -1117,6 +1128,8 @@ rcu_torture_printk(char *page)
 		rcutorture_trace_dump();
 	}
 	rtcv_snap = rcu_torture_current_version;
+
+	return used;
 }
 
 /*
@@ -1130,17 +1143,31 @@ rcu_torture_printk(char *page)
 static void
 rcu_torture_stats_print(void)
 {
-	int size = nr_cpu_ids * 200 + 8192;
-	char *buf;
+	int size = nr_cpu_ids * 200 + 8192, used, marker;
+	char *buf, *tmpbuf, c;
 
-	buf = kmalloc(size, GFP_KERNEL);
+	buf = vmalloc(size);
 	if (!buf) {
 		pr_err("rcu-torture: Out of memory, need: %d", size);
 		return;
 	}
-	rcu_torture_printk(buf);
-	pr_alert("%s", buf);
-	kfree(buf);
+	used = rcu_torture_printk(buf, size);
+
+	tmpbuf = buf;
+
+	/* printk() can print only LOG_LINE_MAX chars at a time
+	 * so print the buffer in a loop, one line at a time
+	 */
+	while (used > 0) {
+		marker = strcspn(tmpbuf, "\n") + 1;
+		c = tmpbuf[marker];
+		tmpbuf[marker] = '\0';
+		pr_alert("%s", tmpbuf);
+		tmpbuf[marker] = c;
+		used   -= marker;
+		tmpbuf += marker;
+	}
+	vfree(buf);
 }
 
 /*
diff --git a/kernel/torture.c b/kernel/torture.c
index d600af2..83de502 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -211,10 +211,11 @@ EXPORT_SYMBOL_GPL(torture_onoff_cleanup);
 /*
  * Print online/offline testing statistics.
  */
-char *torture_onoff_stats(char *page)
+int torture_onoff_stats(char *page, int size)
 {
+	int used = 0;
 #ifdef CONFIG_HOTPLUG_CPU
-	page += sprintf(page,
+	used = snprintf(page, size,
 		       "onoff: %ld/%ld:%ld/%ld %d,%d:%d,%d %lu:%lu (HZ=%d) ",
 		       n_online_successes, n_online_attempts,
 		       n_offline_successes, n_offline_attempts,
@@ -222,7 +223,7 @@ char *torture_onoff_stats(char *page)
 		       min_offline, max_offline,
 		       sum_online, sum_offline, HZ);
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
-	return page;
+	return used;
 }
 EXPORT_SYMBOL_GPL(torture_onoff_stats);
 
-- 
1.9.1

