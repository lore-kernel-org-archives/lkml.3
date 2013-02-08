Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760114Ab3BHOIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:08:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32856 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759982Ab3BHOIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:08:11 -0500
Date: Fri, 8 Feb 2013 06:07:49 -0800
From: tip-bot for Clark Williams <williams@redhat.com>
Message-ID: <tip-ce0dbbbb30aee6a835511d5be446462388ba9eee@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, williams@redhat.com, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        williams@redhat.com, rostedt@goodmis.org, peterz@infradead.org,
        tglx@linutronix.de
In-Reply-To: <20130207094704.13751796@riff.lan>
References: <20130207094704.13751796@riff.lan>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt:
  Add a tuning knob to allow changing SCHED_RR timeslice
Git-Commit-ID: ce0dbbbb30aee6a835511d5be446462388ba9eee
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 08 Feb 2013 06:07:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ce0dbbbb30aee6a835511d5be446462388ba9eee
Gitweb:     http://git.kernel.org/tip/ce0dbbbb30aee6a835511d5be446462388ba9eee
Author:     Clark Williams <williams@redhat.com>
AuthorDate: Thu, 7 Feb 2013 09:47:04 -0600
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 7 Feb 2013 20:51:07 +0100

sched/rt: Add a tuning knob to allow changing SCHED_RR timeslice

Add a /proc/sys/kernel scheduler knob named
sched_rr_timeslice_ms that allows global changing of the
SCHED_RR timeslice value. User visable value is in milliseconds
but is stored as jiffies.  Setting to 0 (zero) resets to the
default (currently 100ms).

Signed-off-by: Clark Williams <williams@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20130207094704.13751796@riff.lan
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched/sysctl.h | 15 ++++++++++++++-
 kernel/sched/core.c          | 19 +++++++++++++++++++
 kernel/sched/rt.c            |  6 ++++--
 kernel/sysctl.c              |  7 +++++++
 4 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index bac914e..d2bb0ae 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -73,6 +73,13 @@ static inline unsigned int get_sysctl_timer_migration(void)
 	return 1;
 }
 #endif
+
+/*
+ *  control realtime throttling:
+ *
+ *  /proc/sys/kernel/sched_rt_period_us
+ *  /proc/sys/kernel/sched_rt_runtime_us
+ */
 extern unsigned int sysctl_sched_rt_period;
 extern int sysctl_sched_rt_runtime;
 
@@ -90,7 +97,13 @@ extern unsigned int sysctl_sched_autogroup_enabled;
  */
 #define RR_TIMESLICE		(100 * HZ / 1000)
 
-int sched_rt_handler(struct ctl_table *table, int write,
+extern int sched_rr_timeslice;
+
+extern int sched_rr_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos);
+
+extern int sched_rt_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos);
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1dff78a..4a88f1d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7509,6 +7509,25 @@ static int sched_rt_global_constraints(void)
 }
 #endif /* CONFIG_RT_GROUP_SCHED */
 
+int sched_rr_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp,
+		loff_t *ppos)
+{
+	int ret;
+	static DEFINE_MUTEX(mutex);
+
+	mutex_lock(&mutex);
+	ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	/* make sure that internally we keep jiffies */
+	/* also, writing zero resets timeslice to default */
+	if (!ret && write) {
+		sched_rr_timeslice = sched_rr_timeslice <= 0 ?
+			RR_TIMESLICE : msecs_to_jiffies(sched_rr_timeslice);
+	}
+	mutex_unlock(&mutex);
+	return ret;
+}
+
 int sched_rt_handler(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos)
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index c25de14..fb0f77e 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -7,6 +7,8 @@
 
 #include <linux/slab.h>
 
+int sched_rr_timeslice = RR_TIMESLICE;
+
 static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun);
 
 struct rt_bandwidth def_rt_bandwidth;
@@ -2016,7 +2018,7 @@ static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
 	if (--p->rt.time_slice)
 		return;
 
-	p->rt.time_slice = RR_TIMESLICE;
+	p->rt.time_slice = sched_rr_timeslice;
 
 	/*
 	 * Requeue to the end of queue if we (and all of our ancestors) are the
@@ -2047,7 +2049,7 @@ static unsigned int get_rr_interval_rt(struct rq *rq, struct task_struct *task)
 	 * Time slice is 0 for SCHED_FIFO tasks
 	 */
 	if (task->policy == SCHED_RR)
-		return RR_TIMESLICE;
+		return sched_rr_timeslice;
 	else
 		return 0;
 }
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 7357e23..4fc9be9 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -404,6 +404,13 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= sched_rt_handler,
 	},
+	{
+		.procname	= "sched_rr_timeslice_ms",
+		.data		= &sched_rr_timeslice,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= sched_rr_handler,
+	},
 #ifdef CONFIG_SCHED_AUTOGROUP
 	{
 		.procname	= "sched_autogroup_enabled",
