Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaK1SZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:25:35 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:46982 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbaK1SZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:25:06 -0500
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
Subject: [RFC PATCH 30/30] cputime: Push time to account_system_time() in nanosecs
Date: Fri, 28 Nov 2014 19:24:00 +0100
Message-Id: <1417199040-21044-31-git-send-email-fweisbec@gmail.com>
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
 arch/powerpc/kernel/time.c  |  3 ++-
 arch/s390/kernel/vtime.c    |  7 ++++---
 include/linux/kernel_stat.h |  2 +-
 kernel/sched/cputime.c      | 22 +++++++++++-----------
 kernel/sched/stats.h        |  4 ++--
 6 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 2f9e8f0..f01bb2a 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -135,7 +135,7 @@ static cputime_t vtime_delta(struct task_struct *tsk)
 
 void vtime_account_system(struct task_struct *tsk)
 {
-	cputime_t delta = vtime_delta(tsk);
+	u64 delta = cputime_to_nsecs(vtime_delta(tsk));
 
 	account_system_time(tsk, 0, delta, delta);
 }
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index cdd78a2..bb839fb 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -344,7 +344,8 @@ void vtime_account_system(struct task_struct *tsk)
 	u64 delta, sys_scaled, stolen;
 
 	delta = vtime_delta(tsk, &sys_scaled, &stolen);
-	account_system_time(tsk, 0, delta, sys_scaled);
+	account_system_time(tsk, 0, cputime_to_nsecs(delta),
+			    cputime_to_nsecs(sys_scaled));
 	if (stolen)
 		account_steal_time(cputime_to_nsecs(stolen));
 }
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index a2dfba1..0780700 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -86,7 +86,7 @@ static int do_account_vtime(struct task_struct *tsk, int hardirq_offset)
 	S390_lowcore.steal_timer -= system;
 	ti->system_timer = S390_lowcore.system_timer;
 	nsecs = cputime_to_nsecs(system);
-	account_system_time(tsk, hardirq_offset, system, system);
+	account_system_time(tsk, hardirq_offset, nsecs, nsecs);
 
 	steal = S390_lowcore.steal_timer;
 	if ((s64) steal > 0) {
@@ -128,7 +128,7 @@ void vtime_account_user(struct task_struct *tsk)
 void vtime_account_irq_enter(struct task_struct *tsk)
 {
 	struct thread_info *ti = task_thread_info(tsk);
-	u64 timer, system;
+	u64 timer, system, nsecs;
 
 	WARN_ON_ONCE(!irqs_disabled());
 
@@ -139,7 +139,8 @@ void vtime_account_irq_enter(struct task_struct *tsk)
 	system = S390_lowcore.system_timer - ti->system_timer;
 	S390_lowcore.steal_timer -= system;
 	ti->system_timer = S390_lowcore.system_timer;
-	account_system_time(tsk, 0, system, system);
+	nsecs = cputime_to_nsecs(system);
+	account_system_time(tsk, 0, nsecs, nsecs);
 
 	virt_timer_forward(system);
 }
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 2b26786..ec7d6f0 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -85,7 +85,7 @@ static inline unsigned int kstat_cpu_irqs_sum(unsigned int cpu)
 extern unsigned long long task_delta_exec(struct task_struct *);
 
 extern void account_user_time(struct task_struct *, u64, u64);
-extern void account_system_time(struct task_struct *, int, cputime_t, cputime_t);
+extern void account_system_time(struct task_struct *, int, u64, u64);
 extern void account_steal_time(u64);
 extern void account_idle_time(u64);
 
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 9d002f5..5f3ff5c 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -177,16 +177,16 @@ static void account_guest_time(struct task_struct *p, u64 cputime,
  * @target_cputime64: pointer to cpustat field that has to be updated
  */
 static inline
-void __account_system_time(struct task_struct *p, cputime_t cputime,
-			cputime_t cputime_scaled, int index)
+void __account_system_time(struct task_struct *p, u64 cputime,
+			   u64 cputime_scaled, int index)
 {
 	/* Add system time to process. */
-	p->stime += cputime_to_nsecs(cputime);
-	p->stimescaled += cputime_to_nsecs(cputime_scaled);
+	p->stime += cputime;
+	p->stimescaled += cputime_scaled;
 	account_group_system_time(p, cputime);
 
 	/* Add system time to cpustat. */
-	task_group_account_field(p, index, cputime_to_nsecs(cputime));
+	task_group_account_field(p, index, cputime);
 
 	/* Account for system time used */
 	acct_account_cputime(p);
@@ -200,12 +200,12 @@ void __account_system_time(struct task_struct *p, cputime_t cputime,
  * @cputime_scaled: cputime scaled by cpu frequency
  */
 void account_system_time(struct task_struct *p, int hardirq_offset,
-			 cputime_t cputime, cputime_t cputime_scaled)
+			 u64 cputime, u64 cputime_scaled)
 {
 	int index;
 
 	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0)) {
-		account_guest_time(p, cputime_to_nsecs(cputime), cputime_to_nsecs(cputime_scaled));
+		account_guest_time(p, cputime, cputime_scaled);
 		return;
 	}
 
@@ -344,7 +344,7 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 		 * So, we have to handle it separately here.
 		 * Also, p->stime needs to be updated for ksoftirqd.
 		 */
-		__account_system_time(p, cputime, scaled, CPUTIME_SOFTIRQ);
+		__account_system_time(p, nsec, nsec_scaled, CPUTIME_SOFTIRQ);
 	} else if (user_tick) {
 		account_user_time(p, nsec, nsec_scaled);
 	} else if (p == rq->idle) {
@@ -352,7 +352,7 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 	} else if (p->flags & PF_VCPU) { /* System time or guest time */
 		account_guest_time(p, nsec, nsec_scaled);
 	} else {
-		__account_system_time(p, cputime, scaled,	CPUTIME_SYSTEM);
+		__account_system_time(p, nsec, nsec_scaled, CPUTIME_SYSTEM);
 	}
 }
 
@@ -468,8 +468,8 @@ void account_process_tick(struct task_struct *p, int user_tick)
 	if (user_tick)
 		account_user_time(p, nsec, nsec_scaled);
 	else if ((p != rq->idle) || (irq_count() != HARDIRQ_OFFSET))
-		account_system_time(p, HARDIRQ_OFFSET, cputime_one_jiffy,
-				    one_jiffy_scaled);
+		account_system_time(p, HARDIRQ_OFFSET, nsec,
+				    nsec_scaled);
 	else
 		account_idle_time(cputime_one_jiffy);
 }
diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index 649b38c..0c88cbe 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -231,7 +231,7 @@ static inline void account_group_user_time(struct task_struct *tsk,
  * running CPU and update the stime field there.
  */
 static inline void account_group_system_time(struct task_struct *tsk,
-					     cputime_t cputime)
+					     u64 cputime)
 {
 	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
 
@@ -239,7 +239,7 @@ static inline void account_group_system_time(struct task_struct *tsk,
 		return;
 
 	raw_spin_lock(&cputimer->lock);
-	cputimer->cputime.stime += cputime;
+	cputimer->cputime.stime += nsecs_to_cputime(cputime);
 	raw_spin_unlock(&cputimer->lock);
 }
 
-- 
2.1.3

