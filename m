Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaFEOie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:38:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48560 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaFEOic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:38:32 -0400
Date: Thu, 5 Jun 2014 07:37:31 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-82c65d60d64401aedc1006d6572469bbfdf148de@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        rafael.j.wysocki@intel.com, luto@amacapital.net, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        rafael.j.wysocki@intel.com, luto@amacapital.net, tglx@linutronix.de
In-Reply-To: <b2059fcb4c613d520cb503b6fad6e47033c7c203.1401902905.git.luto@amacapital.net>
References: <b2059fcb4c613d520cb503b6fad6e47033c7c203.1401902905.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/idle:
  Clear polling before descheduling the idle thread
Git-Commit-ID: 82c65d60d64401aedc1006d6572469bbfdf148de
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  82c65d60d64401aedc1006d6572469bbfdf148de
Gitweb:     http://git.kernel.org/tip/82c65d60d64401aedc1006d6572469bbfdf148de
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Wed, 4 Jun 2014 10:31:16 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 12:09:51 +0200

sched/idle: Clear polling before descheduling the idle thread

Currently, the only real guarantee provided by the polling bit is
that, if you hold rq->lock and the polling bit is set, then you can
set need_resched to force a reschedule.

The only reason the lock is needed is that the idle thread might not
be running at all when setting its need_resched bit, and rq->lock
keeps it pinned.

This is easy to fix: just clear the polling bit before scheduling.
Now the idle thread's polling bit is only ever set when
rq->curr == rq->idle.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: nicolas.pitre@linaro.org
Cc: daniel.lezcano@linaro.org
Cc: umgwanakikbuti@gmail.com
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Link: http://lkml.kernel.org/r/b2059fcb4c613d520cb503b6fad6e47033c7c203.1401902905.git.luto@amacapital.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/idle.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 25b9423..fe4b24b 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -67,6 +67,10 @@ void __weak arch_cpu_idle(void)
  * cpuidle_idle_call - the main idle function
  *
  * NOTE: no locks or semaphores should be used here
+ *
+ * On archs that support TIF_POLLING_NRFLAG, is called with polling
+ * set, and it returns with polling set.  If it ever stops polling, it
+ * must clear the polling bit.
  */
 static void cpuidle_idle_call(void)
 {
@@ -175,10 +179,22 @@ exit_idle:
 
 /*
  * Generic idle loop implementation
+ *
+ * Called with polling cleared.
  */
 static void cpu_idle_loop(void)
 {
 	while (1) {
+		/*
+		 * If the arch has a polling bit, we maintain an invariant:
+		 *
+		 * Our polling bit is clear if we're not scheduled (i.e. if
+		 * rq->curr != rq->idle).  This means that, if rq->idle has
+		 * the polling bit set, then setting need_resched is
+		 * guaranteed to cause the cpu to reschedule.
+		 */
+
+		__current_set_polling();
 		tick_nohz_idle_enter();
 
 		while (!need_resched()) {
@@ -218,6 +234,15 @@ static void cpu_idle_loop(void)
 		 */
 		preempt_set_need_resched();
 		tick_nohz_idle_exit();
+		__current_clr_polling();
+
+		/*
+		 * We promise to reschedule if need_resched is set while
+		 * polling is set.  That means that clearing polling
+		 * needs to be visible before rescheduling.
+		 */
+		smp_mb__after_atomic();
+
 		schedule_preempt_disabled();
 	}
 }
@@ -239,7 +264,6 @@ void cpu_startup_entry(enum cpuhp_state state)
 	 */
 	boot_init_stack_canary();
 #endif
-	__current_set_polling();
 	arch_cpu_idle_prepare();
 	cpu_idle_loop();
 }
