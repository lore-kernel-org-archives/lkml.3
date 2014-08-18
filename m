Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbaHRJoB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:44:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43046 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaHRJgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:36:09 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: John Stultz <john.stultz@linaro.org>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Bohac <jbohac@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 104/137] printk: rename printk_sched to printk_deferred
Date: Mon, 18 Aug 2014 10:32:45 +0100
Message-Id: <1408354398-10226-105-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Stultz <john.stultz@linaro.org>

commit aac74dc495456412c4130a1167ce4beb6c1f0b38 upstream.

After learning we'll need some sort of deferred printk functionality in
the timekeeping core, Peter suggested we rename the printk_sched function
so it can be reused by needed subsystems.

This only changes the function name. No logic changes.

Signed-off-by: John Stultz <john.stultz@linaro.org>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ luis: prereq for 504d58745c9c ("timer: Fix lock inversion between
  hrtimer_bases.lock and scheduler locks"); backported to 3.11:
  - dropped changes to kernel/sched/deadline.c ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/printk.h | 6 +++---
 kernel/printk/printk.c | 2 +-
 kernel/sched/core.c    | 2 +-
 kernel/sched/rt.c      | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 22c7052e9372..708b8a84f6c0 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -124,9 +124,9 @@ asmlinkage __printf(1, 2) __cold
 int printk(const char *fmt, ...);
 
 /*
- * Special printk facility for scheduler use only, _DO_NOT_USE_ !
+ * Special printk facility for scheduler/timekeeping use only, _DO_NOT_USE_ !
  */
-__printf(1, 2) __cold int printk_sched(const char *fmt, ...);
+__printf(1, 2) __cold int printk_deferred(const char *fmt, ...);
 
 /*
  * Please don't use printk_ratelimit(), because it shares ratelimiting state
@@ -161,7 +161,7 @@ int printk(const char *s, ...)
 	return 0;
 }
 static inline __printf(1, 2) __cold
-int printk_sched(const char *s, ...)
+int printk_deferred(const char *s, ...)
 {
 	return 0;
 }
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 41832ed685a9..385d33583931 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2463,7 +2463,7 @@ void wake_up_klogd(void)
 	preempt_enable();
 }
 
-int printk_sched(const char *fmt, ...)
+int printk_deferred(const char *fmt, ...)
 {
 	unsigned long flags;
 	va_list args;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 68924be0e1e1..65f48e3b7100 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1239,7 +1239,7 @@ out:
 		 * leave kernel.
 		 */
 		if (p->mm && printk_ratelimit()) {
-			printk_sched("process %d (%s) no longer affine to cpu%d\n",
+			printk_deferred("process %d (%s) no longer affine to cpu%d\n",
 					task_pid_nr(p), p->comm, cpu);
 		}
 	}
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 417b1b3fd7e9..8d5724775918 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -827,7 +827,7 @@ static int sched_rt_runtime_exceeded(struct rt_rq *rt_rq)
 
 			if (!once) {
 				once = true;
-				printk_sched("sched: RT throttling activated\n");
+				printk_deferred("sched: RT throttling activated\n");
 			}
 		} else {
 			/*
-- 
1.9.1

