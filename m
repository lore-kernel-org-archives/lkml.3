Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761651Ab3IDBLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 21:11:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18489 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485Ab3IDBLb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 21:11:31 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=BtX7XYNuJWsA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=2FbpPqRdQ64A:10 a=VnNF1IyMAAAA:8 a=DRmndHFa2ojEJvqwo1wA:9 a=CjuIK1q_8ugA:10 a=jeBq3FmKZ4MA:10 a=6unOcP8uajYgLsZ1:21 a=9v34MD2GPJo-9LP0:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 3 Sep 2013 21:11:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [RFC][PATCH 19/18] ftrace: Print a message when the rcu checker is
 disabled
Message-ID: <20130903211127.1d09c66e@gandalf.local.home>
In-Reply-To: <20130903201831.2ae872e4@gandalf.local.home>
References: <20130831051117.884125230@goodmis.org>
	<20130831051700.601365837@goodmis.org>
	<20130903171516.16290c47@gandalf.local.home>
	<20130903221808.GH3871@linux.vnet.ibm.com>
	<20130903195705.3ba3442f@gandalf.local.home>
	<20130903201831.2ae872e4@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f8f5d278e272c42349b3cd32485faf426d0c459e Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Date: Tue, 3 Sep 2013 20:47:59 -0400
Subject: [PATCH] ftrace: Print a message when the rcu checker is disabled

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index 0883069..dd59827 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -569,6 +569,8 @@ void ftrace_unsafe_rcu_checker_disable(void)
 	atomic_inc(&ftrace_unsafe_rcu_disabled);
 	/* Make sure the update is seen immediately */
 	smp_wmb();
+	pr_info("Disabled FTRACE RCU checker (%pS)\n",
+		__builtin_return_address(0));
 }
 
 void ftrace_unsafe_rcu_checker_enable(void)
@@ -576,6 +578,8 @@ void ftrace_unsafe_rcu_checker_enable(void)
 	atomic_dec(&ftrace_unsafe_rcu_disabled);
 	/* Make sure the update is seen immediately */
 	smp_wmb();
+	pr_info("Enabled FTRACE RCU checker (%pS)\n",
+		__builtin_return_address(0));
 }
 
 static DEFINE_PER_CPU(unsigned long, ftrace_rcu_func);
-- 
1.8.1.4

