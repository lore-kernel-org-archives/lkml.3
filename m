Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934957Ab3IDO4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:56:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17769 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762830Ab3IDO4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:56:45 -0400
X-Authority-Analysis: v=2.0 cv=DqnUCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=TKhX5mLeURAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=ftMOpXKlpS4A:10 a=VnNF1IyMAAAA:8 a=sQNCpU6w5R_T-ydTkxoA:9 a=jeBq3FmKZ4MA:10 a=XRkXRusqWGjDEmJ2:21 a=AkA9etonYUd58gPi:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130904143703.256708017@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 04 Sep 2013 10:36:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [for-next][PATCH 18/18] ftrace: Print a message when the rcu checker is disabled
References: <20130904143552.456506259@goodmis.org>
Content-Disposition: inline; filename=0017-ftrace-Print-a-message-when-the-rcu-checker-is-disab.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Let the user know that the RCU safety checker for function tracing
has been disabled. The checker only runs when the user specifically
configures it in the kernel, and this is done to search for locations
in the kernel that may be unsafe for a function trace callback to
use rcu_read_lock()s. But if things like function graph tracing is
started, which can live lock the machine when the checker is running,
it is disabled. It would be nice if the kernel let the user know that
the checker is disabled, and when it is re-enabled again.

As the checker only gets disabled and re-enabled by user actions
(starting and stoping the function graph tracer or the irqsoff tracer)
it is fine to have a printk display that it is disabled or not.

Suggested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 1dec979..57e32e6 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -569,6 +569,8 @@ void ftrace_unsafe_rcu_checker_disable(void)
 	atomic_inc(&ftrace_unsafe_rcu_disabled);
 	/* Make sure the update is seen immediately */
 	smp_mb__after_atomic_inc();
+	pr_info("Disabled FTRACE RCU checker (%pS)\n",
+		__builtin_return_address(0));
 }
 
 void ftrace_unsafe_rcu_checker_enable(void)
@@ -576,6 +578,8 @@ void ftrace_unsafe_rcu_checker_enable(void)
 	atomic_dec(&ftrace_unsafe_rcu_disabled);
 	/* Make sure the update is seen immediately */
 	smp_mb__after_atomic_dec();
+	pr_info("Enabled FTRACE RCU checker (%pS)\n",
+		__builtin_return_address(0));
 }
 
 static DEFINE_PER_CPU(unsigned long, ftrace_rcu_func);
-- 
1.7.10.4


