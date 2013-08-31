Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab3HaFUR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 01:20:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23824 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393Ab3HaFRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 01:17:04 -0400
X-Authority-Analysis: v=2.0 cv=DqnUCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=EzP5xR4ZXSYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=XdHNiPHiZPIA:10 a=F7sj4GA4NglSa3_kcFAA:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130831051702.596618450@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 31 Aug 2013 01:11:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [RFC][PATCH 13/18 v2] ftrace: Disable the RCU unsafe checker when irqsoff is enabled
References: <20130831051117.884125230@goodmis.org>
Content-Disposition: inline; filename=0013-ftrace-Disable-the-RCU-unsafe-checker-when-irqsoff-i.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The irqsoff tracer can be called during some of the RCU unsafe
regions. The proble is that some of the internal calls that it
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


