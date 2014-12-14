Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbaLNQs1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 11:48:27 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:28954 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751998AbaLNQsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 11:48:17 -0500
Message-Id: <20141214164803.991954802@goodmis.org>
User-Agent: quilt/0.61-1
Date: Sun, 14 Dec 2014 11:41:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 1/3] tracepoints: Do not use call_rcu_sched() before early_initcall()
References: <20141214164104.307127356@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-tracepoints-Do-not-use-call_rcu_sched-before-early_i.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

In order to move enabling of trace events to just after mm_init(), the
tracepoint enable code can not use call_rcu_sched() because rcu isn't
even initialized yet.  Since this can only happen before SMP is set up
(and even before interrupts are set up), there's no reason to use
call_rcu_sched() at this point.

Instead, create a variable called tracepoint_rcu_safe that gets enabled
via early_initcall() and if that is not set, free the code directly
instead of using call_rcu_sched().

This allows us to enable tracepoints early without issues.

Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/tracepoint.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 3490407dc7b7..9b90ef0ac731 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -33,6 +33,15 @@ extern struct tracepoint * const __stop___tracepoints_ptrs[];
 /* Set to 1 to enable tracepoint debug output */
 static const int tracepoint_debug;
 
+/*
+ * traceoint_rcu_is_safe is set to true at early_initcall().
+ * Tracepoints can be enabled before rcu is initialized.
+ * When that happens, there's no reason to free via call_rcu()
+ * because the system isn't even in SMP mode yet, and rcu isn't
+ * initialized. Just directly free the old tracepoints instead.
+ */
+static bool tracepoint_rcu_is_safe;
+
 #ifdef CONFIG_MODULES
 /*
  * Tracepoint module list mutex protects the local module list.
@@ -76,7 +85,16 @@ static inline void release_probes(struct tracepoint_func *old)
 	if (old) {
 		struct tp_probes *tp_probes = container_of(old,
 			struct tp_probes, probes[0]);
-		call_rcu_sched(&tp_probes->rcu, rcu_free_old_probes);
+		/*
+		 * Tracepoints can be enabled before RCU is initialized
+		 * at boot up. If that is the case, do not bother using
+		 * call_rcu() (because that will fail), but instead just
+		 * free directly.
+		 */
+		if (likely(tracepoint_rcu_is_safe))
+			call_rcu_sched(&tp_probes->rcu, rcu_free_old_probes);
+		else
+			rcu_free_old_probes(&tp_probes->rcu);
 	}
 }
 
@@ -518,3 +536,10 @@ void syscall_unregfunc(void)
 	}
 }
 #endif
+
+static __init int init_tracepoint_rcu(void)
+{
+	tracepoint_rcu_is_safe = true;
+	return 0;
+}
+early_initcall(init_tracepoint_rcu);
-- 
2.1.3


