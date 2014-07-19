Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965011AbaGSAqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 20:46:46 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:40366 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253AbaGSAog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 20:44:36 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 04/10] nohz: Appropriate timekeeper kick on sysidle break
Date: Sat, 19 Jul 2014 02:44:15 +0200
Message-Id: <1405730661-9355-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1405730661-9355-1-git-send-email-fweisbec@gmail.com>
References: <1405730661-9355-1-git-send-email-fweisbec@gmail.com>
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

Cc: Ingo Molnar <mingo@kernel.org>
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
index 395c14d..b65da1a 100644
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

