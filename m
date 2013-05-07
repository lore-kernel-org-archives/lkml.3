Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082Ab3EGNlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:41:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42356 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933059Ab3EGNla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:30 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 061/118] tracing: Use stack of calling function for stack tracer
Date: Tue,  7 May 2013 14:38:27 +0100
Message-Id: <1367933964-1564-62-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 87889501d0adfae10e3b0f0e6f2d7536eed9ae84 upstream.

Use the stack of stack_trace_call() instead of check_stack() as
the test pointer for max stack size. It makes it a bit cleaner
and a little more accurate.

Adding stable, as a later fix depends on this patch.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/trace/trace_stack.c | 12 +++++++-----
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
1.8.1.2

