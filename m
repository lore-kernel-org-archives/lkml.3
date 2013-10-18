Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab3JRLyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 07:54:15 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:34023 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab3JRLxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 07:53:50 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@kernel.org,
        pjt@google.com, Morten.Rasmussen@arm.com, cmetcalf@tilera.com,
        tony.luck@intel.com, alex.shi@intel.com, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org
Cc: rjw@sisk.pl, paulmck@linux.vnet.ibm.com, corbet@lwn.net,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, l.majewski@samsung.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC][PATCH v5 05/14] sched: add a packing level knob
Date: Fri, 18 Oct 2013 13:52:18 +0200
Message-Id: <1382097147-30088-5-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The knob is used to set an average load threshold that will be used to trig
the inclusion/removal of CPUs in the packing effort list.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 include/linux/sched/sysctl.h |    9 +++++++++
 kernel/sched/fair.c          |   26 ++++++++++++++++++++++++++
 kernel/sysctl.c              |   17 +++++++++++++++++
 3 files changed, 52 insertions(+)

diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index bf8086b..f41afa5 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -44,6 +44,14 @@ enum sched_tunable_scaling {
 };
 extern enum sched_tunable_scaling sysctl_sched_tunable_scaling;
 
+#ifdef CONFIG_SCHED_PACKING_TASKS
+extern int  __read_mostly sysctl_sched_packing_level;
+
+int sched_proc_update_packing(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos);
+#endif
+
 extern unsigned int sysctl_numa_balancing_scan_delay;
 extern unsigned int sysctl_numa_balancing_scan_period_min;
 extern unsigned int sysctl_numa_balancing_scan_period_max;
@@ -61,6 +69,7 @@ extern unsigned int sysctl_sched_shares_window;
 int sched_proc_update_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *length,
 		loff_t *ppos);
+
 #endif
 #ifdef CONFIG_SCHED_DEBUG
 static inline unsigned int get_sysctl_timer_migration(void)
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7149f38..5568980 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -186,6 +186,32 @@ void sched_init_granularity(void)
  */
 DEFINE_PER_CPU(int, sd_pack_buddy);
 
+/*
+ * The packing level of the scheduler
+ *
+ * This level define the activity % above which we should add another CPU to
+ * participate to the packing effort of the tasks
+ */
+#define DEFAULT_PACKING_LEVEL 80
+int __read_mostly sysctl_sched_packing_level = DEFAULT_PACKING_LEVEL;
+
+unsigned int sd_pack_threshold = (100 * 1024) / DEFAULT_PACKING_LEVEL;
+
+
+int sched_proc_update_packing(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos)
+{
+	int ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	if (ret || !write)
+		return ret;
+
+	if (sysctl_sched_packing_level)
+		sd_pack_threshold = (100 * 1024) / sysctl_sched_packing_level;
+
+	return 0;
+}
+
 static inline bool is_packing_cpu(int cpu)
 {
 	int my_buddy = per_cpu(sd_pack_buddy, cpu);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index b2f06f3..77383fc 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -255,11 +255,17 @@ static struct ctl_table sysctl_base_table[] = {
 	{ }
 };
 
+#ifdef CONFIG_SCHED_PACKING_TASKS
+static int min_sched_packing_level;
+static int max_sched_packing_level = 100;
+#endif /* CONFIG_SMP */
+
 #ifdef CONFIG_SCHED_DEBUG
 static int min_sched_granularity_ns = 100000;		/* 100 usecs */
 static int max_sched_granularity_ns = NSEC_PER_SEC;	/* 1 second */
 static int min_wakeup_granularity_ns;			/* 0 usecs */
 static int max_wakeup_granularity_ns = NSEC_PER_SEC;	/* 1 second */
+
 #ifdef CONFIG_SMP
 static int min_sched_tunable_scaling = SCHED_TUNABLESCALING_NONE;
 static int max_sched_tunable_scaling = SCHED_TUNABLESCALING_END-1;
@@ -279,6 +285,17 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+#ifdef CONFIG_SCHED_PACKING_TASKS
+	{
+		.procname	= "sched_packing_level",
+		.data		= &sysctl_sched_packing_level,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= sched_proc_update_packing,
+		.extra1		= &min_sched_packing_level,
+		.extra2		= &max_sched_packing_level,
+	},
+#endif
 #ifdef CONFIG_SCHED_DEBUG
 	{
 		.procname	= "sched_min_granularity_ns",
-- 
1.7.9.5

