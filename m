Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaK1S0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:26:18 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:45832 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaK1SZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:25:00 -0500
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
Subject: [RFC PATCH 27/30] cputime: Push time to account_steal_time() in nanosecs
Date: Fri, 28 Nov 2014 19:23:57 +0100
Message-Id: <1417199040-21044-28-git-send-email-fweisbec@gmail.com>
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
 arch/powerpc/kernel/time.c  |  2 +-
 arch/s390/kernel/vtime.c    |  2 +-
 include/linux/kernel_stat.h |  2 +-
 kernel/sched/cputime.c      | 20 ++++++--------------
 4 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index c69c8cc..e44558c 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -346,7 +346,7 @@ void vtime_account_system(struct task_struct *tsk)
 	delta = vtime_delta(tsk, &sys_scaled, &stolen);
 	account_system_time(tsk, 0, delta, sys_scaled);
 	if (stolen)
-		account_steal_time(stolen);
+		account_steal_time(cputime_to_nsecs(stolen));
 }
 EXPORT_SYMBOL_GPL(vtime_account_system);
 
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index 0ec68b8..a2dfba1 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -91,7 +91,7 @@ static int do_account_vtime(struct task_struct *tsk, int hardirq_offset)
 	steal = S390_lowcore.steal_timer;
 	if ((s64) steal > 0) {
 		S390_lowcore.steal_timer = 0;
-		account_steal_time(steal);
+		account_steal_time(cputime_to_nsecs(steal));
 	}
 
 	return virt_timer_forward(user + system);
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 9ec9881..b164be9 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -86,7 +86,7 @@ extern unsigned long long task_delta_exec(struct task_struct *);
 
 extern void account_user_time(struct task_struct *, u64, u64);
 extern void account_system_time(struct task_struct *, int, cputime_t, cputime_t);
-extern void account_steal_time(cputime_t);
+extern void account_steal_time(u64);
 extern void account_idle_time(cputime_t);
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 02fd2e7..ee8a9bf 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -223,11 +223,11 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
  * Account for involuntary wait time.
  * @cputime: the cpu time spent in involuntary wait
  */
-void account_steal_time(cputime_t cputime)
+void account_steal_time(u64 cputime)
 {
 	u64 *cpustat = kcpustat_this_cpu->cpustat;
 
-	cpustat[CPUTIME_STEAL] += cputime_to_nsecs(cputime);
+	cpustat[CPUTIME_STEAL] += cputime;
 }
 
 /*
@@ -250,21 +250,13 @@ static __always_inline bool steal_account_process_tick(void)
 #ifdef CONFIG_PARAVIRT
 	if (static_key_false(&paravirt_steal_enabled)) {
 		u64 steal;
-		cputime_t steal_ct;
 
 		steal = paravirt_steal_clock(smp_processor_id());
 		steal -= this_rq()->prev_steal_time;
+		this_rq()->prev_steal_time += steal;
+		account_steal_time(steal);
 
-		/*
-		 * cputime_t may be less precise than nsecs (eg: if it's
-		 * based on jiffies). Lets cast the result to cputime
-		 * granularity and account the rest on the next rounds.
-		 */
-		steal_ct = nsecs_to_cputime(steal);
-		this_rq()->prev_steal_time += cputime_to_nsecs(steal_ct);
-
-		account_steal_time(steal_ct);
-		return steal_ct;
+		return steal;
 	}
 #endif
 	return false;
@@ -489,7 +481,7 @@ void account_process_tick(struct task_struct *p, int user_tick)
  */
 void account_steal_ticks(unsigned long ticks)
 {
-	account_steal_time(jiffies_to_cputime(ticks));
+	account_steal_time(jiffies_to_nsecs(ticks));
 }
 
 /*
-- 
2.1.3

