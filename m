Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab3LQWyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 17:54:43 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:40141 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3LQWvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 17:51:43 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>, Alex Shi <alex.shi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 05/13] rcu: Fix unraised IPI to timekeeping CPU
Date: Tue, 17 Dec 2013 23:51:24 +0100
Message-Id: <1387320692-28460-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The plan with full system idle detection is to allow the timekeeper
to sleep when all full dynticks CPUs are sleeping.

Then when a full dynticks CPU wakes up while the whole system is idle,
it sends an IPI to the timekeeping CPU which then restarts its tick
and polls on its timekeeping duty on behalf of all other CPUs in the
system.

But we are using rcu_kick_nohz_cpu() to raise this IPI, which is wrong
because this function is used to kick full dynticks CPUs when they run
in the kernel for too long without reporting a quiescent state. And
this function ignores targets that are not full dynticks, like our
timekeeper.

To fix this, use the smp_send_reschedule() function directly.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Alex Shi <alex.shi@linaro.org>
Cc: Kevin Hilman <khilman@linaro.org>
---
 kernel/rcu/tree_plugin.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 08004da..84d90c8 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2488,7 +2488,7 @@ void rcu_sysidle_force_exit(void)
 				      oldstate, RCU_SYSIDLE_NOT);
 		if (oldstate == newoldstate &&
 		    oldstate == RCU_SYSIDLE_FULL_NOTED) {
-			rcu_kick_nohz_cpu(tick_do_timer_cpu);
+			smp_send_reschedule(tick_do_timer_cpu);
 			return; /* We cleared it, done! */
 		}
 		oldstate = newoldstate;
-- 
1.8.3.1

