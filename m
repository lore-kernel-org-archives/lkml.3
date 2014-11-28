Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaK1SZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:25:58 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:64528 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbaK1SZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:25:02 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC PATCH 28/30] cputime: Push time to account_idle_time() in nanosecs
Date: Fri, 28 Nov 2014 19:23:58 +0100
Message-Id: <1417199040-21044-29-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/ia64/kernel/time.c     |  2 +-
 arch/powerpc/kernel/time.c  |  2 +-
 arch/s390/kernel/idle.c     |  2 +-
 include/linux/kernel_stat.h |  2 +-
 kernel/sched/cputime.c      | 10 +++++-----
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 0518131..2f9e8f0 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -143,7 +143,7 @@ EXPORT_SYMBOL_GPL(vtime_account_system);
 
 void vtime_account_idle(struct task_struct *tsk)
 {
-	account_idle_time(vtime_delta(tsk));
+	account_idle_time(cputime_to_nsecs(vtime_delta(tsk)));
 }
 
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index e44558c..cdd78a2 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -355,7 +355,7 @@ void vtime_account_idle(struct task_struct *tsk)
 	u64 delta, sys_scaled, stolen;
 
 	delta = vtime_delta(tsk, &sys_scaled, &stolen);
-	account_idle_time(delta + stolen);
+	account_idle_time(cputime_to_nsecs(delta + stolen));
 }
 
 /*
diff --git a/arch/s390/kernel/idle.c b/arch/s390/kernel/idle.c
index 9b75577..d2130ed 100644
--- a/arch/s390/kernel/idle.c
+++ b/arch/s390/kernel/idle.c
@@ -41,7 +41,7 @@ void __kprobes enabled_wait(void)
 	idle->clock_idle_enter = idle->clock_idle_exit = 0ULL;
 	idle->idle_time += idle_time;
 	idle->idle_count++;
-	account_idle_time(idle_time);
+	account_idle_time(cputime_to_nsecs(idle_time));
 	write_seqcount_end(&idle->seqcount);
 }
 
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index b164be9..2b26786 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -87,7 +87,7 @@ extern unsigned long long task_delta_exec(struct task_struct *);
 extern void account_user_time(struct task_struct *, u64, u64);
 extern void account_system_time(struct task_struct *, int, cputime_t, cputime_t);
 extern void account_steal_time(u64);
-extern void account_idle_time(cputime_t);
+extern void account_idle_time(u64);
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
 static inline void account_process_tick(struct task_struct *tsk, int user)
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index ee8a9bf..7d818bb 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -234,15 +234,15 @@ void account_steal_time(u64 cputime)
  * Account for idle time.
  * @cputime: the cpu time spent in idle wait
  */
-void account_idle_time(cputime_t cputime)
+void account_idle_time(u64 cputime)
 {
 	u64 *cpustat = kcpustat_this_cpu->cpustat;
 	struct rq *rq = this_rq();
 
 	if (atomic_read(&rq->nr_iowait) > 0)
-		cpustat[CPUTIME_IOWAIT] += cputime_to_nsecs(cputime);
+		cpustat[CPUTIME_IOWAIT] += cputime;
 	else
-		cpustat[CPUTIME_IDLE] += cputime_to_nsecs(cputime);
+		cpustat[CPUTIME_IDLE] += cputime;
 }
 
 static __always_inline bool steal_account_process_tick(void)
@@ -348,7 +348,7 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 	} else if (user_tick) {
 		account_user_time(p, nsec, nsec_scaled);
 	} else if (p == rq->idle) {
-		account_idle_time(cputime);
+		account_idle_time(nsec);
 	} else if (p->flags & PF_VCPU) { /* System time or guest time */
 		account_guest_time(p, cputime, scaled);
 	} else {
@@ -496,7 +496,7 @@ void account_idle_ticks(unsigned long ticks)
 		return;
 	}
 
-	account_idle_time(jiffies_to_cputime(ticks));
+	account_idle_time(jiffies_to_nsecs(ticks));
 }
 
 /*
-- 
2.1.3

