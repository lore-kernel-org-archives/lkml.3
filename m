Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbaFZJRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 05:17:32 -0400
Received: from fgwmail2.fujitsu.co.jp ([164.71.1.135]:57614 "EHLO
	fgwmail2.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbaFZJRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 05:17:31 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <53ABE50F.3040900@jp.fujitsu.com>
Date: Thu, 26 Jun 2014 18:17:03 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 8/8] cputime: iowait aware idle tick accounting
References: <53ABE28F.6010402@jp.fujitsu.com>
In-Reply-To: <53ABE28F.6010402@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By changes in vtime* codes by previous patches, now account_idle_time()
become a function to be called only from tick-accounting codes.

Introduce __account_idle_ticks() to do iowait accounting in ticks
properly. For this purpose record jiffies at end of iowait.

Not-Tested-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 include/linux/kernel_stat.h |    1 +
 kernel/sched/core.c         |    1 +
 kernel/sched/cputime.c      |   68 +++++++++++++++++++++++++++++-------------
 kernel/sched/sched.h        |    1 +
 4 files changed, 50 insertions(+), 21 deletions(-)

diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index ecbc52f..bdea2f7 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -85,6 +85,7 @@ extern unsigned long long task_delta_exec(struct task_struct *);
 extern void account_user_time(struct task_struct *, cputime_t, cputime_t);
 extern void account_system_time(struct task_struct *, int, cputime_t, cputime_t);
 extern void account_steal_time(cputime_t);
+extern void account_iowait_time(cputime_t);
 extern void account_idle_time(cputime_t);
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f8eec61..5d3ebc3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4347,6 +4347,7 @@ static inline void iowait_stop(struct rq *rq)
 	if (!rq->nr_iowait && rq != this_rq()) {
 		vtime_iowait_exit(rq->cpu);
 		rq->last_iowait = ktime_get();
+		rq->last_iowait_jiffies = jiffies;
 	}
 	raw_spin_unlock(&rq->iowait_lock);
 }
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 866a3ff..42a0e99 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -240,40 +240,65 @@ void account_steal_time(cputime_t cputime)
 }
 
 /*
+ * Account for iowait time.
+ * @cputime: the cpu time spent in io wait
+ */
+void account_iowait_time(cputime_t cputime)
+{
+	u64 *cpustat = kcpustat_this_cpu->cpustat;
+
+	cpustat[CPUTIME_IOWAIT] += (__force u64) cputime;
+}
+
+/*
+ * Account for idle time.
+ * @cputime: the cpu time spent in idle wait
+ */
+void account_idle_time(cputime_t cputime)
+{
+	u64 *cpustat = kcpustat_this_cpu->cpustat;
+
+	cpustat[CPUTIME_IDLE] += (__force u64) cputime;
+}
+
+/*
  * Account for idle and iowait time in a dulation.
  * @idle_enter: time stamp at idle entry
  * @iowait_exit: time stamp when nr_iowait dropped to 0
  * @idle_exit: time stamp at idle exit
  */
-void account_idle_and_iowait(cputime_t idle_enter, cputime_t iowait_exit, cputime_t idle_exit)
+void account_idle_and_iowait(cputime_t idle_enter, cputime_t iowait_exit,
+			     cputime_t idle_exit)
 {
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
 	struct rq *rq = this_rq();
 
 	if (rq->nr_iowait > 0 || iowait_exit > idle_exit) {
-		cpustat[CPUTIME_IOWAIT] += (__force u64) idle_exit - idle_enter;
+		account_iowait_time(idle_exit - idle_enter);
 	} else if (iowait_exit > idle_enter) {
-		cpustat[CPUTIME_IOWAIT] += (__force u64) iowait_exit - idle_enter;
-		cpustat[CPUTIME_IDLE] += (__force u64) idle_exit - iowait_exit;
+		account_iowait_time(iowait_exit - idle_enter);
+		account_idle_time(idle_exit - iowait_exit);
 	} else {
-		cpustat[CPUTIME_IDLE] += (__force u64) idle_exit - idle_enter;
+		account_idle_time(idle_exit - idle_enter);
 	}
 }
 
 /*
- * Account for idle time.
- * @cputime: the cpu time spent in idle wait (sometimes include iowait time)
+ * Account for idle and iowait time.
+ * @ticks: ticks spent in idle/io wait
  */
-void account_idle_time(cputime_t cputime)
+static void __account_idle_ticks(int ticks)
 {
-	u64 *cpustat = kcpustat_this_cpu->cpustat;
 	struct rq *rq = this_rq();
+	unsigned long no_io_ticks = jiffies - rq->last_iowait_jiffies;
 
-	/* FIXME */
-	if (rq->nr_iowait > 0)
-		cpustat[CPUTIME_IOWAIT] += (__force u64) cputime;
-	else
-		cpustat[CPUTIME_IDLE] += (__force u64) cputime;
+	if (rq->nr_iowait > 0) {
+		account_iowait_time(jiffies_to_cputime(ticks));
+	} else if (no_io_ticks < ticks) {
+		account_iowait_time(jiffies_to_cputime(ticks - no_io_ticks));
+		account_idle_time(jiffies_to_cputime(no_io_ticks));
+	} else {
+		account_idle_time(jiffies_to_cputime(ticks));
+	}
 }
 
 static __always_inline bool steal_account_process_tick(void)
@@ -380,11 +405,11 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 	} else if (user_tick) {
 		account_user_time(p, cputime, scaled);
 	} else if (p == rq->idle) {
-		account_idle_time(cputime);
+		__account_idle_ticks(ticks);
 	} else if (p->flags & PF_VCPU) { /* System time or guest time */
 		account_guest_time(p, cputime, scaled);
 	} else {
-		__account_system_time(p, cputime, scaled,	CPUTIME_SYSTEM);
+		__account_system_time(p, cputime, scaled, CPUTIME_SYSTEM);
 	}
 }
 
@@ -396,7 +421,8 @@ static void irqtime_account_idle_ticks(int ticks)
 }
 #else /* CONFIG_IRQ_TIME_ACCOUNTING */
 static inline void irqtime_account_idle_ticks(int ticks) {}
-static inline void irqtime_account_process_tick(struct task_struct *p, int user_tick,
+static inline void irqtime_account_process_tick(struct task_struct *p,
+						int user_tick,
 						struct rq *rq, int nr_ticks) {}
 #endif /* CONFIG_IRQ_TIME_ACCOUNTING */
 
@@ -499,7 +525,7 @@ void account_process_tick(struct task_struct *p, int user_tick)
 		account_system_time(p, HARDIRQ_OFFSET, cputime_one_jiffy,
 				    one_jiffy_scaled);
 	else
-		account_idle_time(cputime_one_jiffy);
+		__account_idle_ticks(1);
 }
 
 /*
@@ -514,7 +540,7 @@ void account_steal_ticks(unsigned long ticks)
 
 /*
  * Account multiple ticks of idle time.
- * @ticks: number of stolen ticks
+ * @ticks: number of idle ticks
  */
 void account_idle_ticks(unsigned long ticks)
 {
@@ -524,7 +550,7 @@ void account_idle_ticks(unsigned long ticks)
 		return;
 	}
 
-	account_idle_time(jiffies_to_cputime(ticks));
+	__account_idle_ticks(ticks);
 }
 
 /*
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 4ddfddc..e5fb7b5 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -564,6 +564,7 @@ struct rq {
 	raw_spinlock_t	iowait_lock ____cacheline_aligned;
 	unsigned int	nr_iowait;
 	ktime_t		last_iowait;
+	unsigned long	last_iowait_jiffies;
 
 #ifdef CONFIG_SMP
 	struct root_domain *rd;
-- 
1.7.1


