Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbaFEOnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:43:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48565 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaFEOid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:38:33 -0400
Date: Thu, 5 Jun 2014 07:37:43 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-67b9ca70c3030e832999e8d1cdba2984c7bb5bfc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        rafael.j.wysocki@intel.com, luto@amacapital.net, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        rafael.j.wysocki@intel.com, luto@amacapital.net, tglx@linutronix.de
In-Reply-To: <922f00761445a830ebb23d058e2ae53956ce2d73.1401902905.git.luto@amacapital.net>
References: <922f00761445a830ebb23d058e2ae53956ce2d73.1401902905.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/idle: Simplify wake_up_idle_cpu()
Git-Commit-ID: 67b9ca70c3030e832999e8d1cdba2984c7bb5bfc
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

Commit-ID:  67b9ca70c3030e832999e8d1cdba2984c7bb5bfc
Gitweb:     http://git.kernel.org/tip/67b9ca70c3030e832999e8d1cdba2984c7bb5bfc
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Wed, 4 Jun 2014 10:31:17 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 12:09:52 +0200

sched/idle: Simplify wake_up_idle_cpu()

Now that rq->idle's polling bit is a reliable indication that the cpu is
polling, use it.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: nicolas.pitre@linaro.org
Cc: daniel.lezcano@linaro.org
Cc: umgwanakikbuti@gmail.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Link: http://lkml.kernel.org/r/922f00761445a830ebb23d058e2ae53956ce2d73.1401902905.git.luto@amacapital.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e4c0ddd..6afbfee 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -628,26 +628,7 @@ static void wake_up_idle_cpu(int cpu)
 	if (cpu == smp_processor_id())
 		return;
 
-	/*
-	 * This is safe, as this function is called with the timer
-	 * wheel base lock of (cpu) held. When the CPU is on the way
-	 * to idle and has not yet set rq->curr to idle then it will
-	 * be serialized on the timer wheel base lock and take the new
-	 * timer into account automatically.
-	 */
-	if (rq->curr != rq->idle)
-		return;
-
-	/*
-	 * We can set TIF_RESCHED on the idle task of the other CPU
-	 * lockless. The worst case is that the other CPU runs the
-	 * idle task through an additional NOOP schedule()
-	 */
-	set_tsk_need_resched(rq->idle);
-
-	/* NEED_RESCHED must be visible before we test polling */
-	smp_mb();
-	if (!tsk_is_polling(rq->idle))
+	if (set_nr_and_not_polling(rq->idle))
 		smp_send_reschedule(cpu);
 	else
 		trace_sched_wake_idle_without_ipi(cpu);
