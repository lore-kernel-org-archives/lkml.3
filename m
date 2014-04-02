Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693AbaDBRaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 13:30:12 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:61872 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758816AbaDBRaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 13:30:08 -0400
Message-Id: <20140402173007.015989386@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 02 Apr 2014 13:26:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] x86: Fix dumpstack_64 to keep state of "used" variable in loop
References: <20140402172639.994587272@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-x86-Fix-dumpstack_64-to-keep-state-of-used-variable-.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Commit 2223f6f6eeaa "x86: Clean up dumpstack_64.c code" moved the used
variable to a local within the loop, but the in_exception_stack()
depended on being non-volatile with the ability to change it.

By always re-initializing the "used" variable to zero, it would cause
the in_exception_stack() to return the same thing each time, and
cause the dump_stack loop to go into an infinite loop.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/dumpstack_64.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 346b1df..74c262a 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -115,19 +115,18 @@ enum stack_type {
 };
 
 static enum stack_type
-analyze_stack(int cpu, struct task_struct *task,
-	      unsigned long *stack, unsigned long **stack_end, char **id)
+analyze_stack(int cpu, struct task_struct *task, unsigned long *stack,
+	      unsigned long **stack_end, unsigned *used, char **id)
 {
 	unsigned long *irq_stack;
 	unsigned long addr;
-	unsigned used = 0;
 
 	addr = ((unsigned long)stack & (~(THREAD_SIZE - 1)));
 	if ((unsigned long)task_stack_page(task) == addr)
 		return STACK_IS_NORMAL;
 
 	*stack_end = in_exception_stack(cpu, (unsigned long)stack,
-					 &used, id);
+					used, id);
 	if (*stack_end)
 		return STACK_IS_EXCEPTION;
 
@@ -158,6 +157,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	struct thread_info *tinfo;
 	unsigned long *irq_stack;
 	unsigned long dummy;
+	unsigned used = 0;
 	int graph = 0;
 	int done = 0;
 
@@ -186,7 +186,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		enum stack_type stype;
 		char *id;
 
-		stype = analyze_stack(cpu, task, stack, &stack_end, &id);
+		stype = analyze_stack(cpu, task, stack, &stack_end, &used, &id);
 
 		/* Default finish unless specified to continue */
 		done = 1;
-- 
1.8.5.3


