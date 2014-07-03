Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288AbaGCJVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:21:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51588 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758234AbaGCJVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:21:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 037/198] ARM: stacktrace: avoid listing stacktrace functions in stacktrace
Date: Thu,  3 Jul 2014 10:18:00 +0100
Message-Id: <1404379241-8590-38-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 3683f44c42e991d313dc301504ee0fca1aeb8580 upstream.

While debugging the FEC ethernet driver using stacktrace, it was noticed
that the stacktraces always begin as follows:

 [<c00117b4>] save_stack_trace_tsk+0x0/0x98
 [<c0011870>] save_stack_trace+0x24/0x28
 ...

This is because the stack trace code includes the stack frames for itself.
This is incorrect behaviour, and also leads to "skip" doing the wrong
thing (which is the number of stack frames to avoid recording.)

Perversely, it does the right thing when passed a non-current thread.  Fix
this by ensuring that we have a known constant number of frames above the
main stack trace function, and always skip these.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/kernel/stacktrace.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/stacktrace.c b/arch/arm/kernel/stacktrace.c
index af4e8c8a5422..6582c4adc182 100644
--- a/arch/arm/kernel/stacktrace.c
+++ b/arch/arm/kernel/stacktrace.c
@@ -83,13 +83,16 @@ static int save_trace(struct stackframe *frame, void *d)
 	return trace->nr_entries >= trace->max_entries;
 }
 
-void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
+/* This must be noinline to so that our skip calculation works correctly */
+static noinline void __save_stack_trace(struct task_struct *tsk,
+	struct stack_trace *trace, unsigned int nosched)
 {
 	struct stack_trace_data data;
 	struct stackframe frame;
 
 	data.trace = trace;
 	data.skip = trace->skip;
+	data.no_sched_functions = nosched;
 
 	if (tsk != current) {
 #ifdef CONFIG_SMP
@@ -102,7 +105,6 @@ void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 			trace->entries[trace->nr_entries++] = ULONG_MAX;
 		return;
 #else
-		data.no_sched_functions = 1;
 		frame.fp = thread_saved_fp(tsk);
 		frame.sp = thread_saved_sp(tsk);
 		frame.lr = 0;		/* recovered from the stack */
@@ -111,11 +113,12 @@ void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 	} else {
 		register unsigned long current_sp asm ("sp");
 
-		data.no_sched_functions = 0;
+		/* We don't want this function nor the caller */
+		data.skip += 2;
 		frame.fp = (unsigned long)__builtin_frame_address(0);
 		frame.sp = current_sp;
 		frame.lr = (unsigned long)__builtin_return_address(0);
-		frame.pc = (unsigned long)save_stack_trace_tsk;
+		frame.pc = (unsigned long)__save_stack_trace;
 	}
 
 	walk_stackframe(&frame, save_trace, &data);
@@ -123,9 +126,14 @@ void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
 
+void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
+{
+	__save_stack_trace(tsk, trace, 1);
+}
+
 void save_stack_trace(struct stack_trace *trace)
 {
-	save_stack_trace_tsk(current, trace);
+	__save_stack_trace(current, trace, 0);
 }
 EXPORT_SYMBOL_GPL(save_stack_trace);
 #endif
-- 
1.9.1

