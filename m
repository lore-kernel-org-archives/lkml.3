Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaBKMT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:19:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46601 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbaBKMTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:19:23 -0500
Date: Tue, 11 Feb 2014 04:18:49 -0800
From: tip-bot for Nicolas Pitre <tipbot@zytor.com>
Message-ID: <tip-cf37b6b48428d6be8f8762b3599d529c44644fb2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        nicolas.pitre@linaro.org, akpm@linux-foundation.org, nico@linaro.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        nicolas.pitre@linaro.org, akpm@linux-foundation.org, nico@linaro.org,
        tglx@linutronix.de
In-Reply-To: <alpine.LFD.2.11.1401301102210.1652@knanqh.ubzr>
References: <alpine.LFD.2.11.1401301102210.1652@knanqh.ubzr>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/idle: Move cpu/idle.c to sched/idle.c
Git-Commit-ID: cf37b6b48428d6be8f8762b3599d529c44644fb2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 11 Feb 2014 04:18:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf37b6b48428d6be8f8762b3599d529c44644fb2
Gitweb:     http://git.kernel.org/tip/cf37b6b48428d6be8f8762b3599d529c44644fb2
Author:     Nicolas Pitre <nicolas.pitre@linaro.org>
AuthorDate: Sun, 26 Jan 2014 23:42:01 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Feb 2014 09:58:30 +0100

sched/idle: Move cpu/idle.c to sched/idle.c

Integration of cpuidle with the scheduler requires that the idle loop be
closely integrated with the scheduler proper. Moving cpu/idle.c into the
sched directory will allow for a smoother integration, and eliminate a
subdirectory which contained only one source file.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/alpine.LFD.2.11.1401301102210.1652@knanqh.ubzr
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/Makefile              |  1 -
 kernel/cpu/Makefile          |  1 -
 kernel/sched/Makefile        |  2 +-
 kernel/{cpu => sched}/idle.c | 17 +++++++----------
 4 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index bc010ee..6f1c7e5 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -22,7 +22,6 @@ obj-y += sched/
 obj-y += locking/
 obj-y += power/
 obj-y += printk/
-obj-y += cpu/
 obj-y += irq/
 obj-y += rcu/
 
diff --git a/kernel/cpu/Makefile b/kernel/cpu/Makefile
deleted file mode 100644
index 59ab052..0000000
--- a/kernel/cpu/Makefile
+++ /dev/null
@@ -1 +0,0 @@
-obj-y	= idle.o
diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
index 9a95c8c..ab32b7b 100644
--- a/kernel/sched/Makefile
+++ b/kernel/sched/Makefile
@@ -13,7 +13,7 @@ endif
 
 obj-y += core.o proc.o clock.o cputime.o
 obj-y += idle_task.o fair.o rt.o deadline.o stop_task.o
-obj-y += wait.o completion.o
+obj-y += wait.o completion.o idle.o
 obj-$(CONFIG_SMP) += cpupri.o cpudeadline.o
 obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
 obj-$(CONFIG_SCHEDSTATS) += stats.o
diff --git a/kernel/cpu/idle.c b/kernel/sched/idle.c
similarity index 91%
copy from kernel/cpu/idle.c
copy to kernel/sched/idle.c
index b7976a1..14ca434 100644
--- a/kernel/cpu/idle.c
+++ b/kernel/sched/idle.c
@@ -108,17 +108,14 @@ static void cpu_idle_loop(void)
 				__current_set_polling();
 			}
 			arch_cpu_idle_exit();
+			/*
+			 * We need to test and propagate the TIF_NEED_RESCHED
+			 * bit here because we might not have send the
+			 * reschedule IPI to idle tasks.
+			 */
+			if (tif_need_resched())
+				set_preempt_need_resched();
 		}
-
-		/*
-		 * Since we fell out of the loop above, we know
-		 * TIF_NEED_RESCHED must be set, propagate it into
-		 * PREEMPT_NEED_RESCHED.
-		 *
-		 * This is required because for polling idle loops we will
-		 * not have had an IPI to fold the state for us.
-		 */
-		preempt_set_need_resched();
 		tick_nohz_idle_exit();
 		schedule_preempt_disabled();
 	}
