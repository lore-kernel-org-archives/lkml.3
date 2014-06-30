Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbaF3McL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:32:11 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755311AbaF3McG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:32:06 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Russell King <rmk+kernel@arm.linux.org.uk>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 144/181] ARM: stacktrace: avoid listing stacktrace functions in stacktrace
Date: Mon, 30 Jun 2014 13:52:45 +0200
Message-Id: <5601173d9841808954ee1ee77c9bad1dcaef0c89.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk+kernel@arm.linux.org.uk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.0.0

