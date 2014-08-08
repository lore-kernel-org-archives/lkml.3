Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988AbaHHUrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:47:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40507 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbaHHUrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:47:09 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: John Stultz <john.stultz@linaro.org>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Bohac <jbohac@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 198/259] printk: rename printk_sched to printk_deferred
Date: Fri,  8 Aug 2014 13:40:21 -0700
Message-Id: <1407530482-4483-199-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

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

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/printk.h | 6 +++---
 kernel/printk/printk.c | 2 +-
 kernel/sched/core.c    | 2 +-
 kernel/sched/rt.c      | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 6949258..1864d94 100644
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
index 97fb834..9dbf3a1 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2469,7 +2469,7 @@ void wake_up_klogd(void)
 	preempt_enable();
 }
 
-int printk_sched(const char *fmt, ...)
+int printk_deferred(const char *fmt, ...)
 {
 	unsigned long flags;
 	va_list args;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c677510..0a90d12 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1321,7 +1321,7 @@ out:
 		 * leave kernel.
 		 */
 		if (p->mm && printk_ratelimit()) {
-			printk_sched("process %d (%s) no longer affine to cpu%d\n",
+			printk_deferred("process %d (%s) no longer affine to cpu%d\n",
 					task_pid_nr(p), p->comm, cpu);
 		}
 	}
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 1c40655..721d4c0 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -829,7 +829,7 @@ static int sched_rt_runtime_exceeded(struct rt_rq *rt_rq)
 
 			if (!once) {
 				once = true;
-				printk_sched("sched: RT throttling activated\n");
+				printk_deferred("sched: RT throttling activated\n");
 			}
 		} else {
 			/*
-- 
1.9.1

