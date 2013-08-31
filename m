Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab3HaFRP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 01:17:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32184 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab3HaFRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 01:17:06 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=9S8HIjYI5LQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=NQVHccLqZjsA:10 a=jREKiASAg2tDcGA6ehgA:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130831051702.436132384@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 31 Aug 2013 01:11:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [RFC][PATCH 12/18 v2] ftrace: Disable RCU unsafe checker when function graph is enabled
References: <20130831051117.884125230@goodmis.org>
Content-Disposition: inline; filename=0012-ftrace-Disable-RCU-unsafe-checker-when-function-grap.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Having the RCU unsafe checker running when function graph is enabled
can cause a live lock. That's because the RCU unsafe checker enables
full lockdep debugging on RCU which does a lot of interal calls that
may be traced by the function graph tacer. This adds quite a bit of
overhead and can possibly live lock the system.

Just do not do the RCU unsafe checks when function graph tracer is
enabled.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 69b7f62..310b727 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5118,6 +5118,12 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 		goto out;
 	}
 
+	/*
+	 * The Unsafe RCU checker can live lock function graph tracing.
+	 * It's best to just disable it while doing the fgraph tracing.
+	 */
+	ftrace_unsafe_rcu_checker_disable();
+
 	ftrace_graph_return = retfunc;
 	ftrace_graph_entry = entryfunc;
 
@@ -5141,6 +5147,7 @@ void unregister_ftrace_graph(void)
 	ftrace_shutdown(&global_ops, FTRACE_STOP_FUNC_RET);
 	unregister_pm_notifier(&ftrace_suspend_notifier);
 	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch, NULL);
+	ftrace_unsafe_rcu_checker_enable();
 
  out:
 	mutex_unlock(&ftrace_lock);
-- 
1.7.10.4


