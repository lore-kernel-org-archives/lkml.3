Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762905Ab3IDOk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:40:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9684 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762790Ab3IDOhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:37:05 -0400
X-Authority-Analysis: v=2.0 cv=DqnUCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=foXRB9sBt20A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=8eAZA3Ftb1EA:10 a=F7sj4GA4NglSa3_kcFAA:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130904143702.622711865@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 04 Sep 2013 10:36:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [for-next][PATCH 14/18] ftrace: Disable the RCU unsafe checker when irqsoff is enabled
References: <20130904143552.456506259@goodmis.org>
Content-Disposition: inline; filename=0013-ftrace-Disable-the-RCU-unsafe-checker-when-irqsoff-i.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The irqsoff tracer can be called during some of the RCU unsafe
regions. The problem is that some of the internal calls that it
makes may also be traced. For example, it uses spin locks. But if
the spin lock gets traced and the RCU unsafe checker runs, it will
trigger that RCU is not safe to use. But the only reason a spin lock
is being used in an RCU unsafe region is because the irqsoff trace
uses it, and causes a false positive.

Disable the unsafe RCU checker when irqsoff is enabled.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_irqsoff.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 2aefbee..62d603c 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -584,9 +584,14 @@ static int start_irqsoff_tracer(struct trace_array *tr, int graph)
 
 	ret = register_irqsoff_function(graph, 0);
 
-	if (!ret && tracing_is_enabled())
+	if (!ret && tracing_is_enabled()) {
+		/*
+		 * irqsoff tracer can cause unsafe rcu checker
+		 * to have false positives.
+		 */
+		ftrace_unsafe_rcu_checker_disable();
 		tracer_enabled = 1;
-	else
+	} else
 		tracer_enabled = 0;
 
 	return ret;
@@ -594,6 +599,9 @@ static int start_irqsoff_tracer(struct trace_array *tr, int graph)
 
 static void stop_irqsoff_tracer(struct trace_array *tr, int graph)
 {
+	if (tracer_enabled)
+		ftrace_unsafe_rcu_checker_enable();
+
 	tracer_enabled = 0;
 
 	unregister_irqsoff_function(graph);
@@ -630,11 +638,15 @@ static void irqsoff_tracer_reset(struct trace_array *tr)
 
 static void irqsoff_tracer_start(struct trace_array *tr)
 {
+	if (!tracer_enabled)
+		ftrace_unsafe_rcu_checker_disable();
 	tracer_enabled = 1;
 }
 
 static void irqsoff_tracer_stop(struct trace_array *tr)
 {
+	if (tracer_enabled)
+		ftrace_unsafe_rcu_checker_enable();
 	tracer_enabled = 0;
 }
 
-- 
1.7.10.4


