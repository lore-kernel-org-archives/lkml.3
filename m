Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbaFZJMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 05:12:38 -0400
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:37790 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbaFZJMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 05:12:37 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <53ABE3ED.4000901@jp.fujitsu.com>
Date: Thu, 26 Jun 2014 18:12:13 +0900
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
Subject: [PATCH 4/8] cputime, s390: introduce s390_get_idle_and_iowait
References: <53ABE28F.6010402@jp.fujitsu.com>
In-Reply-To: <53ABE28F.6010402@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s390_get_idle_time give us the duration from idle entry to now.
But it does not tell us how to divide it to idle and iowait.

Modify this function to return 2 values. To realize this, s390's
cputime accounting also requires timestamp at end of iowait.

Not-Tested-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/s390/include/asm/cputime.h |    7 ++++-
 arch/s390/kernel/vtime.c        |   40 ++++++++++++++++++++++++++++++++------
 fs/proc/stat.c                  |   20 +++++++++++-------
 kernel/sched/core.c             |    6 ++++-
 4 files changed, 55 insertions(+), 18 deletions(-)

diff --git a/arch/s390/include/asm/cputime.h b/arch/s390/include/asm/cputime.h
index f65bd36..f4f882d 100644
--- a/arch/s390/include/asm/cputime.h
+++ b/arch/s390/include/asm/cputime.h
@@ -174,13 +174,16 @@ struct s390_idle_data {
 	unsigned long long clock_idle_exit;
 	unsigned long long timer_idle_enter;
 	unsigned long long timer_idle_exit;
+	unsigned long long clock_iowait_exit;
 };
 
 DECLARE_PER_CPU(struct s390_idle_data, s390_idle);
 
-cputime64_t s390_get_idle_time(int cpu);
+void s390_get_idle_and_iowait(int cpu, cputime64_t reti, cputime64_t retw);
+void s390_record_iowait_exit(int cpu);
 
-#define arch_idle_time(cpu) s390_get_idle_time(cpu)
+#define arch_idle_and_iowait(cpu, i, w) s390_get_idle_and_iowait(cpu, i, w)
+#define arch_record_iowait_exit(cpu) s390_save_iowait_exit(cpu)
 
 static inline int s390_nohz_delay(int cpu)
 {
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index 8c34363..f945cbd 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -155,7 +155,7 @@ EXPORT_SYMBOL_GPL(vtime_account_system);
 void __kprobes vtime_stop_cpu(void)
 {
 	struct s390_idle_data *idle = &__get_cpu_var(s390_idle);
-	unsigned long long idle_time;
+	unsigned long long idle_enter, idle_exit, iowait_exit;
 	unsigned long psw_mask;
 
 	trace_hardirqs_on();
@@ -171,19 +171,21 @@ void __kprobes vtime_stop_cpu(void)
 	/* Account time spent with enabled wait psw loaded as idle time. */
 	idle->sequence++;
 	smp_wmb();
-	idle_time = idle->clock_idle_exit - idle->clock_idle_enter;
+	idle_enter = idle->clock_idle_enter;
+	idle_exit = idle->clock_idle_exit;
+	iowait_exit = idle->clock_iowait_exit;
 	idle->clock_idle_enter = idle->clock_idle_exit = 0ULL;
-	idle->idle_time += idle_time;
+	idle->idle_time += idle_exit - idle_enter;
 	idle->idle_count++;
-	account_idle_time(idle_time);
+	account_idle_and_iowait(idle_enter, iowait_exit, idle_exit);
 	smp_wmb();
 	idle->sequence++;
 }
 
-cputime64_t s390_get_idle_time(int cpu)
+void s390_get_idle_and_iowait(int cpu, cputime64_t *reti, cputime64_t *retw)
 {
 	struct s390_idle_data *idle = &per_cpu(s390_idle, cpu);
-	unsigned long long now, idle_enter, idle_exit;
+	unsigned long long now, idle_enter, idle_exit, iowait_exit;
 	unsigned int sequence;
 
 	do {
@@ -191,8 +193,32 @@ cputime64_t s390_get_idle_time(int cpu)
 		sequence = ACCESS_ONCE(idle->sequence);
 		idle_enter = ACCESS_ONCE(idle->clock_idle_enter);
 		idle_exit = ACCESS_ONCE(idle->clock_idle_exit);
+		iowait_exit = ACCESS_ONCE(idle->clock_iowait_exit);
 	} while ((sequence & 1) || (ACCESS_ONCE(idle->sequence) != sequence));
-	return idle_enter ? ((idle_exit ?: now) - idle_enter) : 0;
+
+	if (!idle_enter) {
+		*reti = *retw = 0ULL;
+	} else {
+		if (!idle_exit)
+			idle_exit = now;
+		if (nr_iowait_cpu(cpu)) {
+			*retw = idle_exit - idle_enter;
+			*reti = 0ULL;
+		} else if (iowait_exit > idle_enter) {
+			*retw = iowait_exit - idle_enter;
+			*reti = idle_exit - iowait_exit;
+		} else {
+			*retw = 0ULL;
+			*reti = idle_exit - idle_enter;
+		}
+	}
+}
+
+void s390_record_iowait_exit(int cpu)
+{
+	struct s390_idle_data *idle = &per_cpu(s390_idle, cpu);
+
+	idle->clock_iowait_exit = get_tod_clock();
 }
 
 /*
diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 9d231e9..6b23a89 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -19,25 +19,29 @@
 #define arch_irq_stat() 0
 #endif
 
-#ifdef arch_idle_time
+#ifdef arch_idle_and_iowait
 
 static cputime64_t get_idle_time(int cpu)
 {
-	cputime64_t idle;
+	cputime64_t idle, idle_not_accounted_yet, unused;
 
 	idle = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE];
-	if (cpu_online(cpu) && !nr_iowait_cpu(cpu))
-		idle += arch_idle_time(cpu);
+	if (cpu_online(cpu)) {
+		arch_idle_and_iowait(cpu, &idle_not_accounted_yet, &unused);
+		idle += idle_not_accounted_yet;
+	}
 	return idle;
 }
 
 static cputime64_t get_iowait_time(int cpu)
 {
-	cputime64_t iowait;
+	cputime64_t iowait, iowait_not_accounted_yet, unused;
 
 	iowait = kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT];
-	if (cpu_online(cpu) && nr_iowait_cpu(cpu))
-		iowait += arch_idle_time(cpu);
+	if (cpu_online(cpu)) {
+		arch_idle_and_iowait(cpu, &unused, &iowait_not_accounted_yet);
+		iowait += iowait_not_accounted_yet;
+	}
 	return iowait;
 }
 
@@ -75,7 +79,7 @@ static u64 get_iowait_time(int cpu)
 	return iowait;
 }
 
-#endif
+#endif /* arch_idle_and_iowait */
 
 static int show_stat(struct seq_file *p, void *v)
 {
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 814ee2e..52abf79 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4344,8 +4344,12 @@ static inline void iowait_stop(struct rq *rq)
 	current->in_iowait = 0;
 	raw_spin_lock(&rq->iowait_lock);
 	rq->nr_iowait--;
-	if (!rq->nr_iowait && rq != this_rq())
+	if (!rq->nr_iowait && rq != this_rq()) {
+#ifdef arch_record_iowait_exit
+		arch_record_iowait_exit(rq->cpu);
+#endif
 		rq->last_iowait = ktime_get();
+	}
 	raw_spin_unlock(&rq->iowait_lock);
 }
 
-- 
1.7.1


