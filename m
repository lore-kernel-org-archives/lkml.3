Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab3ERCW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:22:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14784 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab3ERCQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:52 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=v0x9YhvvHwgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=_oFXO-w7mCoA:10 a=VwQbUJbxAAAA:8 a=2x_WxHEYObsG1DZEiU8A:9 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021646.390640694@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [ 029/136 ] tracing: Use stack of calling function for stack tracer
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0029-tracing-Use-stack-of-calling-function-for-stack-trac.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

[ Upstream commit 87889501d0adfae10e3b0f0e6f2d7536eed9ae84 ]

Use the stack of stack_trace_call() instead of check_stack() as
the test pointer for max stack size. It makes it a bit cleaner
and a little more accurate.

Adding stable, as a later fix depends on this patch.

Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_stack.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index aa4270a..6ee97e5 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -40,20 +40,21 @@ static DEFINE_MUTEX(stack_sysctl_mutex);
 int stack_tracer_enabled;
 static int last_stack_tracer_enabled;
 
-static inline void check_stack(void)
+static inline void
+check_stack(unsigned long *stack)
 {
 	unsigned long this_size, flags;
 	unsigned long *p, *top, *start;
 	int i;
 
-	this_size = ((unsigned long)&this_size) & (THREAD_SIZE-1);
+	this_size = ((unsigned long)stack) & (THREAD_SIZE-1);
 	this_size = THREAD_SIZE - this_size;
 
 	if (this_size <= max_stack_size)
 		return;
 
 	/* we do not handle interrupt stacks yet */
-	if (!object_is_on_stack(&this_size))
+	if (!object_is_on_stack(stack))
 		return;
 
 	local_irq_save(flags);
@@ -74,7 +75,7 @@ static inline void check_stack(void)
 	 * Now find where in the stack these are.
 	 */
 	i = 0;
-	start = &this_size;
+	start = stack;
 	top = (unsigned long *)
 		(((unsigned long)start & ~(THREAD_SIZE-1)) + THREAD_SIZE);
 
@@ -113,6 +114,7 @@ static inline void check_stack(void)
 static void
 stack_trace_call(unsigned long ip, unsigned long parent_ip)
 {
+	unsigned long stack;
 	int cpu;
 
 	if (unlikely(!ftrace_enabled || stack_trace_disabled))
@@ -125,7 +127,7 @@ stack_trace_call(unsigned long ip, unsigned long parent_ip)
 	if (per_cpu(trace_active, cpu)++ != 0)
 		goto out;
 
-	check_stack();
+	check_stack(&stack);
 
  out:
 	per_cpu(trace_active, cpu)--;
-- 
1.7.10.4


