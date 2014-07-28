Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbaG1RiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:38:04 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:38233 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaG1Rh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:37:56 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 04/10] nohz: Appropriate timekeeper kick on sysidle break
Date: Mon, 28 Jul 2014 19:37:30 +0200
Message-Id: <1406569056-30217-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1406569056-30217-1-git-send-email-fweisbec@gmail.com>
References: <1406569056-30217-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a CPU wakes up from idle and finds out that the timekeeper is
sleeping, we need to kick it such that it switches from dynticks to
periodic mode to maintain its timekeeping duty on behalf of the newly
awoken CPU.

However we aren't using the right API for that. rcu_kick_nohz_cpu() is
aimed at waking full dynticks CPUs and not the timekeeper.

Moreover the timekeeper must perform a new dynticks cycle to check the
new sysidle state and restart the tick if necessary. A simple call
to irq_exit() isn't enough.

wake_up_nohz_cpu() is a good fit for that job because it pulls the
target out of the idle loop and restart the tick. Then if no other
task waits for the CPU, it will reenter the idle loop and then the
new sysidle state will be visible and well handled.

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/rcu/tree_plugin.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 551398b..477d81f 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2494,7 +2494,7 @@ void rcu_sysidle_force_exit(void)
 				      oldstate, RCU_SYSIDLE_NOT);
 		if (oldstate == newoldstate &&
 		    oldstate == RCU_SYSIDLE_FULL_NOTED) {
-			rcu_kick_nohz_cpu(tick_do_timer_cpu);
+			wake_up_nohz_cpu(tick_do_timer_cpu);
 			return; /* We cleared it, done! */
 		}
 		oldstate = newoldstate;
-- 
1.8.3.1

