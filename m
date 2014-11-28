Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaK1SZD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:25:03 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:55763 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbaK1SY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:24:58 -0500
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
Subject: [RFC PATCH 26/30] cputime: Push time to account_user_time() in nanosecs
Date: Fri, 28 Nov 2014 19:23:56 +0100
Message-Id: <1417199040-21044-27-git-send-email-fweisbec@gmail.com>
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
 arch/ia64/kernel/time.c     |  5 ++++-
 arch/powerpc/kernel/time.c  |  3 ++-
 arch/s390/kernel/vtime.c    |  6 ++++--
 include/linux/kernel_stat.h |  2 +-
 kernel/sched/cputime.c      | 24 +++++++++++++++---------
 kernel/sched/stats.h        |  4 ++--
 6 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 9a0104a..0518131 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -89,8 +89,11 @@ void vtime_account_user(struct task_struct *tsk)
 	struct thread_info *ti = task_thread_info(tsk);
 
 	if (ti->ac_utime) {
+		u64 utime;
+		//TODO: cycle_to_nsec()
 		delta_utime = cycle_to_cputime(ti->ac_utime);
-		account_user_time(tsk, delta_utime, delta_utime);
+		utime = cputime_to_nsecs(delta_utime);
+		account_user_time(tsk, utime, utime);
 		ti->ac_utime = 0;
 	}
 }
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 7505599..c69c8cc 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -376,7 +376,8 @@ void vtime_account_user(struct task_struct *tsk)
 	get_paca()->user_time = 0;
 	get_paca()->user_time_scaled = 0;
 	get_paca()->utime_sspurr = 0;
-	account_user_time(tsk, utime, utimescaled);
+	account_user_time(tsk, cputime_to_nsecs(utime),
+			  cputime_to_nsecs(utimescaled));
 }
 
 #else /* ! CONFIG_VIRT_CPU_ACCOUNTING_NATIVE */
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index 7f0089d..0ec68b8 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -60,7 +60,7 @@ static inline int virt_timer_forward(u64 elapsed)
 static int do_account_vtime(struct task_struct *tsk, int hardirq_offset)
 {
 	struct thread_info *ti = task_thread_info(tsk);
-	u64 timer, clock, user, system, steal;
+	u64 timer, clock, user, system, steal, nsecs;
 
 	timer = S390_lowcore.last_update_timer;
 	clock = S390_lowcore.last_update_clock;
@@ -79,11 +79,13 @@ static int do_account_vtime(struct task_struct *tsk, int hardirq_offset)
 	user = S390_lowcore.user_timer - ti->user_timer;
 	S390_lowcore.steal_timer -= user;
 	ti->user_timer = S390_lowcore.user_timer;
-	account_user_time(tsk, user, user);
+	nsecs = cputime_to_nsecs(user);
+	account_user_time(tsk, nsecs, nsecs);
 
 	system = S390_lowcore.system_timer - ti->system_timer;
 	S390_lowcore.steal_timer -= system;
 	ti->system_timer = S390_lowcore.system_timer;
+	nsecs = cputime_to_nsecs(system);
 	account_system_time(tsk, hardirq_offset, system, system);
 
 	steal = S390_lowcore.steal_timer;
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 585ced4..9ec9881 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -84,7 +84,7 @@ static inline unsigned int kstat_cpu_irqs_sum(unsigned int cpu)
  */
 extern unsigned long long task_delta_exec(struct task_struct *);
 
-extern void account_user_time(struct task_struct *, cputime_t, cputime_t);
+extern void account_user_time(struct task_struct *, u64, u64);
 extern void account_system_time(struct task_struct *, int, cputime_t, cputime_t);
 extern void account_steal_time(cputime_t);
 extern void account_idle_time(cputime_t);
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index f675008..02fd2e7 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -124,20 +124,19 @@ static inline void task_group_account_field(struct task_struct *p, int index,
  * @cputime: the cpu time spent in user space since the last update
  * @cputime_scaled: cputime scaled by cpu frequency
  */
-void account_user_time(struct task_struct *p, cputime_t cputime,
-		       cputime_t cputime_scaled)
+void account_user_time(struct task_struct *p, u64 cputime, u64 cputime_scaled)
 {
 	int index;
 
 	/* Add user time to process. */
-	p->utime += cputime_to_nsecs(cputime);
-	p->utimescaled += cputime_to_nsecs(cputime_scaled);
+	p->utime += cputime;
+	p->utimescaled += cputime_scaled;
 	account_group_user_time(p, cputime);
 
 	index = (task_nice(p) > 0) ? CPUTIME_NICE : CPUTIME_USER;
 
 	/* Add user time to cpustat. */
-	task_group_account_field(p, index, cputime_to_nsecs(cputime));
+	task_group_account_field(p, index, cputime);
 
 	/* Account for user time used */
 	acct_account_cputime(p);
@@ -157,7 +156,7 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 	/* Add guest time to process. */
 	p->utime += cputime_to_nsecs(cputime);
 	p->utimescaled += cputime_to_nsecs(cputime_scaled);
-	account_group_user_time(p, cputime);
+	account_group_user_time(p, cputime_to_nsecs(cputime));
 	p->gtime += cputime_to_nsecs(cputime);
 
 	/* Add guest time to cpustat. */
@@ -333,7 +332,7 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 {
 	cputime_t scaled = cputime_to_scaled(cputime_one_jiffy);
 	u64 cputime = (__force u64) cputime_one_jiffy;
-	u64 nsec = cputime_to_nsecs(cputime); //TODO: make that build time
+	u64 nsec, nsec_scaled;
 
 	if (steal_account_process_tick())
 		return;
@@ -341,6 +340,9 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 	cputime *= ticks;
 	scaled *= ticks;
 
+	nsec = cputime_to_nsecs(cputime);
+	nsec_scaled = cputime_to_nsecs(scaled);
+
 	if (irqtime_skip_tick(nsec))
 		return;
 
@@ -352,7 +354,7 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
 		 */
 		__account_system_time(p, cputime, scaled, CPUTIME_SOFTIRQ);
 	} else if (user_tick) {
-		account_user_time(p, cputime, scaled);
+		account_user_time(p, nsec, nsec_scaled);
 	} else if (p == rq->idle) {
 		account_idle_time(cputime);
 	} else if (p->flags & PF_VCPU) { /* System time or guest time */
@@ -454,11 +456,15 @@ void thread_group_cputime_adjusted(struct task_struct *p, u64 *ut, u64 *st)
 void account_process_tick(struct task_struct *p, int user_tick)
 {
 	cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
+	u64 nsec, nsec_scaled;
 	struct rq *rq = this_rq();
 
 	if (vtime_accounting_enabled())
 		return;
 
+	nsec = cputime_to_nsecs(cputime_one_jiffy); //TODO: Make that build time
+	nsec_scaled = cputime_to_nsecs(one_jiffy_scaled); //Ditto
+
 	if (sched_clock_irqtime) {
 		irqtime_account_process_tick(p, user_tick, rq, 1);
 		return;
@@ -468,7 +474,7 @@ void account_process_tick(struct task_struct *p, int user_tick)
 		return;
 
 	if (user_tick)
-		account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
+		account_user_time(p, nsec, nsec_scaled);
 	else if ((p != rq->idle) || (irq_count() != HARDIRQ_OFFSET))
 		account_system_time(p, HARDIRQ_OFFSET, cputime_one_jiffy,
 				    one_jiffy_scaled);
diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index 4ab7043..649b38c 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -208,7 +208,7 @@ static inline bool cputimer_running(struct task_struct *tsk)
  * running CPU and update the utime field there.
  */
 static inline void account_group_user_time(struct task_struct *tsk,
-					   cputime_t cputime)
+					   u64 cputime)
 {
 	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
 
@@ -216,7 +216,7 @@ static inline void account_group_user_time(struct task_struct *tsk,
 		return;
 
 	raw_spin_lock(&cputimer->lock);
-	cputimer->cputime.utime += cputime;
+	cputimer->cputime.utime += nsecs_to_cputime(cputime);
 	raw_spin_unlock(&cputimer->lock);
 }
 
-- 
2.1.3

