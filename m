Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762864Ab3IDOj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:39:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22259 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762797Ab3IDOhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:37:06 -0400
X-Authority-Analysis: v=2.0 cv=DqnUCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=OsAn8lYQ4r0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=yQ1OjE58qXcA:10 a=VnNF1IyMAAAA:8 a=e9oh1CpYr6fI9J_si7kA:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130904143702.945736860@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 04 Sep 2013 10:36:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [for-next][PATCH 16/18] ftrace/rcu: Mark functions that are RCU unsafe
References: <20130904143552.456506259@goodmis.org>
Content-Disposition: inline; filename=0015-ftrace-rcu-Mark-functions-that-are-RCU-unsafe.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Some callbacks of the function tracer use rcu_read_lock(). This means that
there's places that can not be traced because RCU is not tracking the CPU
for various reasons (like NO_HZ_FULL and coming back from userspace).

These functions need to be marked so that callbacks that use RCU do not
trace them.

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/rcutiny.c |    1 +
 kernel/rcutree.c |    7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index aa34411..911a61c 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -173,6 +173,7 @@ void rcu_irq_enter(void)
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(rcu_irq_enter);
+FTRACE_UNSAFE_RCU(rcu_irq_enter);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 068de3a..ca53562 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -53,6 +53,7 @@
 #include <linux/delay.h>
 #include <linux/stop_machine.h>
 #include <linux/random.h>
+#include <linux/ftrace.h>
 
 #include "rcutree.h"
 #include <trace/events/rcu.h>
@@ -373,6 +374,7 @@ static void rcu_eqs_enter_common(struct rcu_dynticks *rdtp, long long oldval,
 	rcu_lockdep_assert(!lock_is_held(&rcu_sched_lock_map),
 			   "Illegal idle entry in RCU-sched read-side critical section.");
 }
+FTRACE_UNSAFE_RCU(rcu_eqs_enter_common);
 
 /*
  * Enter an RCU extended quiescent state, which can be either the
@@ -392,6 +394,7 @@ static void rcu_eqs_enter(bool user)
 		rdtp->dynticks_nesting -= DYNTICK_TASK_NEST_VALUE;
 	rcu_eqs_enter_common(rdtp, oldval, user);
 }
+FTRACE_UNSAFE_RCU(rcu_eqs_enter);
 
 /**
  * rcu_idle_enter - inform RCU that current CPU is entering idle
@@ -513,6 +516,7 @@ static void rcu_eqs_exit_common(struct rcu_dynticks *rdtp, long long oldval,
 			  idle->pid, idle->comm); /* must be idle task! */
 	}
 }
+FTRACE_UNSAFE_RCU(rcu_eqs_exit_common);
 
 /*
  * Exit an RCU extended quiescent state, which can be either the
@@ -553,6 +557,7 @@ void rcu_idle_exit(void)
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_exit);
+FTRACE_UNSAFE_RCU(rcu_idle_exit);
 
 #ifdef CONFIG_RCU_USER_QS
 /**
@@ -565,6 +570,7 @@ void rcu_user_exit(void)
 {
 	rcu_eqs_exit(1);
 }
+FTRACE_UNSAFE_RCU(rcu_user_exit);
 
 /**
  * rcu_user_exit_after_irq - inform RCU that we won't resume to userspace
@@ -625,6 +631,7 @@ void rcu_irq_enter(void)
 		rcu_eqs_exit_common(rdtp, oldval, true);
 	local_irq_restore(flags);
 }
+FTRACE_UNSAFE_RCU(rcu_irq_enter);
 
 /**
  * rcu_nmi_enter - inform RCU of entry to NMI context
-- 
1.7.10.4


