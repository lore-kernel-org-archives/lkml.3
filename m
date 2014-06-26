Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbaFZJQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 05:16:28 -0400
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:39299 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbaFZJQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 05:16:26 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <53ABE4D4.1020308@jp.fujitsu.com>
Date: Thu, 26 Jun 2014 18:16:04 +0900
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
Subject: [PATCH 7/8] cputime: generic iowait accounting for VIRT_CPU_ACCOUNTING
References: <53ABE28F.6010402@jp.fujitsu.com>
In-Reply-To: <53ABE28F.6010402@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get iowait's timestamp for accounting w/ VIRT_CPU_ACCOUNTING_GEN.
(currently arm is only user of this?)

At last of this series of changes, introduce common function
vtime_iowait_exit to replace all arch_record_iowait_exit.

Not-tested-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/ia64/include/asm/cputime.h    |    2 --
 arch/ia64/kernel/time.c            |    2 +-
 arch/powerpc/include/asm/cputime.h |    3 ---
 arch/powerpc/kernel/time.c         |    2 +-
 arch/s390/include/asm/cputime.h    |    2 --
 arch/s390/kernel/vtime.c           |    2 +-
 include/linux/vtime.h              |    3 +++
 kernel/sched/core.c                |    4 +---
 kernel/sched/cputime.c             |   25 +++++++++++++++++++++++--
 9 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/arch/ia64/include/asm/cputime.h b/arch/ia64/include/asm/cputime.h
index 6089cbd..e2d3f5b 100644
--- a/arch/ia64/include/asm/cputime.h
+++ b/arch/ia64/include/asm/cputime.h
@@ -24,8 +24,6 @@
 # include <asm/processor.h>
 # include <asm-generic/cputime_nsecs.h>
 extern void arch_vtime_task_switch(struct task_struct *tsk);
-extern void ia64_record_iowait_exit(int cpu);
-# define arch_record_iowait_exit(cpu) ia64_record_iowait_exit(cpu)
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
 
 #endif /* __IA64_CPUTIME_H */
diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 37c907d..4b34346 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -143,7 +143,7 @@ EXPORT_SYMBOL_GPL(vtime_account_system);
  */
 DEFINE_PER_CPU(u64, ia64_iowait_exit);
 
-void ia64_record_iowait_exit(int cpu)
+void vtime_iowait_exit(int cpu)
 {
 	/* FIXME: ITC might not synchronized between cpus/sockets */
         per_cpu(ia64_iowait_exit, cpu) = ia64_get_itc();
diff --git a/arch/powerpc/include/asm/cputime.h b/arch/powerpc/include/asm/cputime.h
index f33a801..607559a 100644
--- a/arch/powerpc/include/asm/cputime.h
+++ b/arch/powerpc/include/asm/cputime.h
@@ -230,9 +230,6 @@ static inline cputime_t clock_t_to_cputime(const unsigned long clk)
 
 static inline void arch_vtime_task_switch(struct task_struct *tsk) { }
 
-void ppc_record_iowait_exit(int cpu);
-#define arch_record_iowait_exit(cpu) ppc_record_iowait_exit(cpu)
-
 #endif /* __KERNEL__ */
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
 #endif /* __POWERPC_CPUTIME_H */
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 879d97a..7afddc1 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -355,7 +355,7 @@ EXPORT_SYMBOL_GPL(vtime_account_system);
 
 DEFINE_PER_CPU(u64, vtime_iowait_exit);
 
-void ppc_record_iowait_exit(int cpu)
+void vtime_iowait_exit(int cpu)
 {
 	per_cpu(vtime_iowait_exit, cpu) = mftb();
 }
diff --git a/arch/s390/include/asm/cputime.h b/arch/s390/include/asm/cputime.h
index f4f882d..e136328 100644
--- a/arch/s390/include/asm/cputime.h
+++ b/arch/s390/include/asm/cputime.h
@@ -180,10 +180,8 @@ struct s390_idle_data {
 DECLARE_PER_CPU(struct s390_idle_data, s390_idle);
 
 void s390_get_idle_and_iowait(int cpu, cputime64_t reti, cputime64_t retw);
-void s390_record_iowait_exit(int cpu);
 
 #define arch_idle_and_iowait(cpu, i, w) s390_get_idle_and_iowait(cpu, i, w)
-#define arch_record_iowait_exit(cpu) s390_save_iowait_exit(cpu)
 
 static inline int s390_nohz_delay(int cpu)
 {
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index f945cbd..123fa74 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -214,7 +214,7 @@ void s390_get_idle_and_iowait(int cpu, cputime64_t *reti, cputime64_t *retw)
 	}
 }
 
-void s390_record_iowait_exit(int cpu)
+void vtime_iowait_exit(int cpu)
 {
 	struct s390_idle_data *idle = &per_cpu(s390_idle, cpu);
 
diff --git a/include/linux/vtime.h b/include/linux/vtime.h
index c5165fd..7f4632a 100644
--- a/include/linux/vtime.h
+++ b/include/linux/vtime.h
@@ -49,6 +49,7 @@ static inline void vtime_task_switch(struct task_struct *prev)
 }
 #endif /* __ARCH_HAS_VTIME_TASK_SWITCH */
 
+extern void vtime_iowait_exit(int cpu);
 extern void vtime_account_system(struct task_struct *tsk);
 extern void vtime_account_idle(struct task_struct *tsk);
 extern void vtime_account_user(struct task_struct *tsk);
@@ -66,8 +67,10 @@ static inline void vtime_account_irq_enter(struct task_struct *tsk)
 
 #else /* !CONFIG_VIRT_CPU_ACCOUNTING */
 
+static inline void vtime_iowait_exit(int cpu) { }
 static inline void vtime_task_switch(struct task_struct *prev) { }
 static inline void vtime_account_system(struct task_struct *tsk) { }
+static inline void vtime_account_idle(struct task_struct *tsk) { }
 static inline void vtime_account_user(struct task_struct *tsk) { }
 static inline void vtime_account_irq_enter(struct task_struct *tsk) { }
 #endif /* !CONFIG_VIRT_CPU_ACCOUNTING */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 52abf79..f8eec61 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4345,9 +4345,7 @@ static inline void iowait_stop(struct rq *rq)
 	raw_spin_lock(&rq->iowait_lock);
 	rq->nr_iowait--;
 	if (!rq->nr_iowait && rq != this_rq()) {
-#ifdef arch_record_iowait_exit
-		arch_record_iowait_exit(rq->cpu);
-#endif
+		vtime_iowait_exit(rq->cpu);
 		rq->last_iowait = ktime_get();
 	}
 	raw_spin_unlock(&rq->iowait_lock);
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 283e011..866a3ff 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -741,11 +741,32 @@ void vtime_guest_exit(struct task_struct *tsk)
 }
 EXPORT_SYMBOL_GPL(vtime_guest_exit);
 
+DEFINE_PER_CPU(unsigned long long, vtime_exit_iowait);
+
+void vtime_iowait_exit(int cpu)
+{
+	/* FIXME: don't compare local clock on different cpus */
+	per_cpu(vtime_exit_iowait, cpu) = local_clock();
+}
+
 void vtime_account_idle(struct task_struct *tsk)
 {
-	cputime_t delta_cpu = get_vtime_delta(tsk);
+	unsigned long long now, delta;
+	cputime_t delta_cpu, idle_cpu;
+
+	now = local_clock();
+	if (now < tsk->vtime_snap)
+		return;
+
+	delta = now - tsk->vtime_snap;
+
+	WARN_ON_ONCE(tsk->vtime_snap_whence == VTIME_SLEEPING);
+	tsk->vtime_snap += delta;
+
+	delta_cpu = nsecs_to_cputime(delta);
+	idle_cpu = nsecs_to_cputime(now - per_cpu_var(vtime_exit_iowait));
 
-	account_idle_time(delta_cpu);
+	account_idle_and_iowait(0, delta_cpu - idle_cpu, delta_cpu);
 }
 
 void arch_vtime_task_switch(struct task_struct *prev)
-- 
1.7.1


