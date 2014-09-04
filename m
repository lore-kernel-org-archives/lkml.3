Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbaIDQhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:37:36 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:52259 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754239AbaIDQhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:37:33 -0400
X-Yandex-Uniq: 9d065cd2-cdc4-4054-8e26-f876ae9c2b2d
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: klamm@yandex-team.ru
To: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Cc: stfomichev@yandex-team.ru, Roman Gushchin <klamm@yandex-team.ru>
Subject: [PATCH 11/19] smart: smart debug
Date: Thu,  4 Sep 2014 20:30:57 +0400
Message-Id: <1409848265-17150-11-git-send-email-klamm@yandex-team.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
References: <77161409833206@webcorp01h.yandex-team.ru>
 <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Gushchin <klamm@yandex-team.ru>

This patch introduces debug infrastructure for smart.
The infrastructure contains a number of per-cpu counters,
smart_event() function to register smart-related events and procfs
interface to read and reset these counters.

The following events are counting:
pull - smart pull
balance_local - local cpu selection
balance_remote - remote cpu selection
select_core - free local core selected
select_rcore - free remote core selected
select_thread - free local cpu selected
select_rthread - free remote cpu selected
select_busy - busy cpu selected
select_busy_curr - current busy cpu selected
select_fallback - select_fallback_rq() called
rt_pull - rt push
rt_push - rt pull

Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
---
 init/Kconfig         |  8 +++++
 kernel/sched/core.c  |  3 ++
 kernel/sched/rt.c    | 85 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sched/sched.h | 38 +++++++++++++++++++++++
 4 files changed, 133 insertions(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index 98dd173..d936b49 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -813,6 +813,14 @@ config SMART
 	  enabled hyper-threading.
 	  Do not use for hard real-time purposes.
 
+config SMART_DEBUG
+	bool "Enable SMART debug features"
+	default y
+	depends on SMART
+	help
+	  This option adds gathering of SMART statistics. It's
+	  available via /proc/smart_stat interface.
+
 menuconfig CGROUPS
 	boolean "Control Group support"
 	depends on EVENTFD
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5954f48..c2b988c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1180,6 +1180,9 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 	enum { cpuset, possible, fail } state = cpuset;
 	int dest_cpu;
 
+	if (smart_enabled() && task_has_rt_policy(p))
+		smart_event(select_fallback);
+
 	/*
 	 * If the node that the cpu is on has been offlined, cpu_to_node()
 	 * will return -1. There is no cpu on the node, and we should
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 8621443..14acd51 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -9,8 +9,69 @@
 
 #ifdef CONFIG_SMART
 #include <linux/workqueue.h>
+#include <linux/proc_fs.h>
+
+#ifdef CONFIG_SMART_DEBUG
+#include <linux/seq_file.h>
 #include <linux/jump_label.h>
 
+DEFINE_PER_CPU(struct smart_stat, smart_stat);
+
+static struct proc_dir_entry *smart_pde;
+
+static ssize_t smart_proc_write(struct file *file, const char __user *buffer,
+				size_t count, loff_t *ppos)
+{
+	int c;
+
+	for_each_possible_cpu(c)
+		memset(&per_cpu(smart_stat, c), 0, sizeof(struct smart_stat));
+
+	return count;
+}
+
+#define smart_stat_print(m, field)				\
+	({							\
+		u64 res = 0;					\
+		unsigned int c;					\
+		for_each_possible_cpu(c)			\
+			res += per_cpu(smart_stat, c).field;	\
+		seq_printf(m, "%-16s %llu\n", #field, res);	\
+	})
+
+static int smart_proc_show(struct seq_file *m, void *arg)
+{
+	smart_stat_print(m, pull);
+	smart_stat_print(m, balance_local);
+	smart_stat_print(m, balance_remote);
+	smart_stat_print(m, select_core);
+	smart_stat_print(m, select_rcore);
+	smart_stat_print(m, select_thread);
+	smart_stat_print(m, select_rthread);
+	smart_stat_print(m, select_busy);
+	smart_stat_print(m, select_busy_curr);
+	smart_stat_print(m, select_fallback);
+	smart_stat_print(m, rt_pull);
+	smart_stat_print(m, rt_push);
+
+	return 0;
+}
+
+static int smart_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, smart_proc_show, NULL);
+}
+
+static const struct file_operations smart_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= smart_proc_open,
+	.read		= seq_read,
+	.write          = smart_proc_write,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+#endif
+
 struct static_key __smart_initialized = STATIC_KEY_INIT_FALSE;
 struct static_key __smart_enabled = STATIC_KEY_INIT_TRUE;
 DEFINE_MUTEX(smart_mutex);
@@ -1773,6 +1834,9 @@ retry:
 out:
 	put_task_struct(next_task);
 
+	if (ret)
+		smart_event(rt_push);
+
 	return ret;
 }
 
@@ -1859,6 +1923,9 @@ skip:
 		double_unlock_balance(this_rq, src_rq);
 	}
 
+	if (ret)
+		smart_event(rt_pull);
+
 	return ret;
 }
 
@@ -2270,6 +2337,13 @@ void build_smart_topology(void)
 	if (was_initialized)
 		printk(KERN_INFO "smart: disabled\n");
 
+#ifdef CONFIG_SMART_DEBUG
+	if (!smart_pde)
+		smart_pde = proc_create("smart_stat",
+					S_IWUSR | S_IRUSR | S_IRGRP | S_IROTH,
+					NULL, &smart_proc_fops);
+#endif
+
 	get_online_cpus();
 	for_each_online_cpu(cpu) {
 		/* __cpu_core_id */
@@ -2369,6 +2443,9 @@ static int smart_find_lowest_rq(struct task_struct *task, bool wakeup)
 				prev_cpu = core_node_sibling(prev_cpu);
 			}
 		}
+
+		smart_event_node(task_cpu(task), prev_cpu,
+				 balance_local, balance_remote);
 	}
 
 	for (attempts = 3; attempts; attempts--) {
@@ -2376,14 +2453,20 @@ static int smart_find_lowest_rq(struct task_struct *task, bool wakeup)
 		if (best_cpu == -1) {
 			best_cpu = find_rt_best_thread(prev_cpu, task);
 
+			smart_event_node(task_cpu(task), best_cpu,
+					 select_thread, select_rthread);
+
 			break;
 		}
 
 		if (!acquire_core(best_cpu))
 			continue;
 
-		if (likely(core_is_rt_free(best_cpu)))
+		if (likely(core_is_rt_free(best_cpu))) {
+			smart_event_node(task_cpu(task), best_cpu,
+					 select_core, select_rcore);
 			break;
+		}
 
 		release_core(best_cpu);
 	}
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 80d202e..d450b8f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1380,6 +1380,38 @@ static inline u64 irq_time_read(int cpu)
 #endif /* CONFIG_64BIT */
 #endif /* CONFIG_IRQ_TIME_ACCOUNTING */
 
+#ifdef CONFIG_SMART_DEBUG
+struct smart_stat {
+	u64 pull;
+	u64 balance_local;
+	u64 balance_remote;
+	u64 select_core;
+	u64 select_rcore;
+	u64 select_thread;
+	u64 select_rthread;
+	u64 select_busy;
+	u64 select_busy_curr;
+	u64 select_fallback;
+	u64 rt_pull;
+	u64 rt_push;
+};
+
+DECLARE_PER_CPU(struct smart_stat, smart_stat);
+#define smart_event(e) do { __get_cpu_var(smart_stat).e++; } while (0)
+#define smart_event_node(prev_cpu, next_cpu, local_event, remote_event) \
+	do {								\
+		if (prev_cpu >= 0 && next_cpu >= 0 &&			\
+		    cpu_to_node(prev_cpu) == cpu_to_node(next_cpu))	\
+			smart_event(local_event);			\
+		else							\
+			smart_event(remote_event);			\
+	} while (0)
+#else
+#define smart_event(e) do { } while (0)
+#define smart_event_node(prev_cpu, next_cpu, local_event, remote_event) \
+	do { } while (0)
+#endif /* CONFIG_SMART_DEBUG */
+
 #ifdef CONFIG_SMART
 struct smart_core_data {
 	int cpu_core_id;
@@ -1417,6 +1449,7 @@ static inline int cpu_core_id(int cpu)
 #define smart_data(cpu) per_cpu(smart_core_data, cpu_core_id(cpu))
 #define smart_node_ptr(cpu) smart_node_data[cpu_to_node(cpu)]
 #define smart_gathering_data(cpu) per_cpu(smart_gathering_data, cpu)
+#define smart_stats(cpu) per_cpu(smart_core_data, cpu_core_id(cpu)).stats
 
 static inline bool smart_enabled(void)
 {
@@ -1587,6 +1620,11 @@ static inline int find_rt_best_thread(int start_cpu, struct task_struct *task)
 	    min_running == cpu_rq(start_cpu)->rt.rt_nr_running)
 		best_cpu = -1;
 
+	if (best_cpu == -1 || best_cpu == start_cpu)
+		smart_event(select_busy_curr);
+	else
+		smart_event(select_busy);
+
 	return best_cpu;
 }
 
-- 
1.9.3

