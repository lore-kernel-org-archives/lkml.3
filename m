Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbaDWDhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 23:37:50 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:58734 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662AbaDWDhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 23:37:09 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Bohac <jbohac@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC][PATCH 1/3] printk: Rename printk_sched to printk_deferred
Date: Tue, 22 Apr 2014 20:36:56 -0700
Message-Id: <1398224218-4429-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398224218-4429-1-git-send-email-john.stultz@linaro.org>
References: <1398224218-4429-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After learning we'll need some sort of deferred printk functionality
in the timekeeping core, Peter suggested we rename the printk_sched
function so it can be reused by needed subsystems.

This only changes the function name and name of the associated buffer.
No logic changes.

Cc: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/printk.h  | 6 +++---
 kernel/printk/printk.c  | 8 ++++----
 kernel/sched/core.c     | 2 +-
 kernel/sched/deadline.c | 2 +-
 kernel/sched/rt.c       | 2 +-
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 8752f75..7847301 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -128,9 +128,9 @@ asmlinkage __printf(1, 2) __cold
 int printk(const char *fmt, ...);
 
 /*
- * Special printk facility for scheduler use only, _DO_NOT_USE_ !
+ * Special printk facility for scheduler/timekeeping use only, _DO_NOT_USE_ !
  */
-__printf(1, 2) __cold int printk_sched(const char *fmt, ...);
+__printf(1, 2) __cold int printk_deferred(const char *fmt, ...);
 
 /*
  * Please don't use printk_ratelimit(), because it shares ratelimiting state
@@ -165,7 +165,7 @@ int printk(const char *s, ...)
 	return 0;
 }
 static inline __printf(1, 2) __cold
-int printk_sched(const char *s, ...)
+int printk_deferred(const char *s, ...)
 {
 	return 0;
 }
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index a45b509..a9763e4 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2443,14 +2443,14 @@ late_initcall(printk_late_init);
 #define PRINTK_PENDING_SCHED	0x02
 
 static DEFINE_PER_CPU(int, printk_pending);
-static DEFINE_PER_CPU(char [PRINTK_BUF_SIZE], printk_sched_buf);
+static DEFINE_PER_CPU(char [PRINTK_BUF_SIZE], printk_deferred_buf);
 
 static void wake_up_klogd_work_func(struct irq_work *irq_work)
 {
 	int pending = __this_cpu_xchg(printk_pending, 0);
 
 	if (pending & PRINTK_PENDING_SCHED) {
-		char *buf = __get_cpu_var(printk_sched_buf);
+		char *buf = __get_cpu_var(printk_deferred_buf);
 		pr_warn("[sched_delayed] %s", buf);
 	}
 
@@ -2473,7 +2473,7 @@ void wake_up_klogd(void)
 	preempt_enable();
 }
 
-int printk_sched(const char *fmt, ...)
+int printk_deferred(const char *fmt, ...)
 {
 	unsigned long flags;
 	va_list args;
@@ -2481,7 +2481,7 @@ int printk_sched(const char *fmt, ...)
 	int r;
 
 	local_irq_save(flags);
-	buf = __get_cpu_var(printk_sched_buf);
+	buf = __get_cpu_var(printk_deferred_buf);
 
 	va_start(args, fmt);
 	r = vsnprintf(buf, PRINTK_BUF_SIZE, fmt, args);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 268a45e..423704c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1320,7 +1320,7 @@ out:
 		 * leave kernel.
 		 */
 		if (p->mm && printk_ratelimit()) {
-			printk_sched("process %d (%s) no longer affine to cpu%d\n",
+			printk_deferred("process %d (%s) no longer affine to cpu%d\n",
 					task_pid_nr(p), p->comm, cpu);
 		}
 	}
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index b080957..657ed68 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -352,7 +352,7 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se,
 
 		if (!lag_once) {
 			lag_once = true;
-			printk_sched("sched: DL replenish lagged to much\n");
+			printk_deferred("sched: DL replenish lagged to much\n");
 		}
 		dl_se->deadline = rq_clock(rq) + pi_se->dl_deadline;
 		dl_se->runtime = pi_se->dl_runtime;
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index bd2267a..c19b3cc 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -857,7 +857,7 @@ static int sched_rt_runtime_exceeded(struct rt_rq *rt_rq)
 
 			if (!once) {
 				once = true;
-				printk_sched("sched: RT throttling activated\n");
+				printk_deferred("sched: RT throttling activated\n");
 			}
 		} else {
 			/*
-- 
1.8.3.2

