Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410Ab3FRX6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 19:58:38 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:58435 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932687Ab3FRX6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 19:58:37 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linaro-kernel@lists.linaro.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Kevin Hilman <khilman@linaro.org>, Tony Luck <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/2] sched/nohz: add sysctl control over sched_tick_max_deferment
Date: Tue, 18 Jun 2013 16:58:28 -0700
Message-Id: <1371599913-1232-1-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow sysctl override of sched_tick_max_deferment in order to ease
finding/fixing the remaining issues with full nohz.

The value to be written is in jiffies, and -1 means the max deferment
is disabled (scheduler_tick_max_deferment() returns KTIME_MAX.)

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 include/linux/sched/sysctl.h | 3 +++
 kernel/sched/core.c          | 6 +++++-
 kernel/sched/debug.c         | 1 +
 kernel/sysctl.c              | 9 +++++++++
 4 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index bf8086b..2ad07bb 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -57,6 +57,9 @@ extern unsigned int sysctl_sched_nr_migrate;
 extern unsigned int sysctl_sched_time_avg;
 extern unsigned int sysctl_timer_migration;
 extern unsigned int sysctl_sched_shares_window;
+#ifdef CONFIG_NO_HZ_FULL
+extern unsigned int sysctl_sched_tick_max_deferment;
+#endif
 
 int sched_proc_update_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *length,
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e1a27f9..b5d3f99 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2751,12 +2751,16 @@ void scheduler_tick(void)
  * balancing, etc... continue to move forward, even
  * with a very low granularity.
  */
+unsigned int sysctl_sched_tick_max_deferment = HZ;
 u64 scheduler_tick_max_deferment(void)
 {
 	struct rq *rq = this_rq();
 	unsigned long next, now = ACCESS_ONCE(jiffies);
 
-	next = rq->last_sched_tick + HZ;
+	if (sysctl_sched_tick_max_deferment == -1)
+		return KTIME_MAX;
+
+	next = rq->last_sched_tick + sysctl_sched_tick_max_deferment;
 
 	if (time_before_eq(next, now))
 		return 0;
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 75024a6..f445ab9 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -374,6 +374,7 @@ static void sched_debug_header(struct seq_file *m)
 	PN(sysctl_sched_wakeup_granularity);
 	P(sysctl_sched_child_runs_first);
 	P(sysctl_sched_features);
+	P(sysctl_sched_tick_max_deferment);
 #undef PN
 #undef P
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 9edcf45..fb0b7d8 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -393,6 +393,15 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif /* CONFIG_NUMA_BALANCING */
+#ifdef CONFIG_NO_HZ_FULL
+	{
+		.procname	= "sched_tick_max_deferment",
+		.data		= &sysctl_sched_tick_max_deferment,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif /* CONFIG_NO_HZ_FULL */
 #endif /* CONFIG_SCHED_DEBUG */
 	{
 		.procname	= "sched_rt_period_us",
-- 
1.8.3

