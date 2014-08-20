Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbaHTL7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:59:45 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58946 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752555AbaHTLoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Jan Kara <jack@suse.cz>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Bohac <jbohac@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 017/104] printk: rename printk_sched to printk_deferred
Date: Wed, 20 Aug 2014 13:42:40 +0200
Message-Id: <d6a1cfb5f64485010bb0429a7bcb899b96ee92e9.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <john.stultz@linaro.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/printk.h | 6 +++---
 kernel/printk/printk.c | 2 +-
 kernel/sched/core.c    | 2 +-
 kernel/sched/rt.c      | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 694925837a16..1864d94d1a89 100644
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
index c59896c65ac3..0f9149036885 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2470,7 +2470,7 @@ void wake_up_klogd(void)
 	preempt_enable();
 }
 
-int printk_sched(const char *fmt, ...)
+int printk_deferred(const char *fmt, ...)
 {
 	unsigned long flags;
 	va_list args;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 07039cba59d9..f09e22163be3 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1224,7 +1224,7 @@ out:
 		 * leave kernel.
 		 */
 		if (p->mm && printk_ratelimit()) {
-			printk_sched("process %d (%s) no longer affine to cpu%d\n",
+			printk_deferred("process %d (%s) no longer affine to cpu%d\n",
 					task_pid_nr(p), p->comm, cpu);
 		}
 	}
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index ff04e1a06412..e849d4070c7f 100644
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
2.0.4

