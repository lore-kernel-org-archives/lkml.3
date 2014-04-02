Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656AbaDBRaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 13:30:10 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:9901 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758799AbaDBRaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 13:30:08 -0400
Message-Id: <20140402173007.164964686@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 02 Apr 2014 13:26:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] x86: Fix dumpstack_64 irq stack handling
References: <20140402172639.994587272@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-x86-Fix-dumpstack_64-irq-stack-handling.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Commit 2223f6f6eeaa "x86: Clean up dumpstack_64.c code" changed
the irq_stack processing a little from what it was before.
The irq_stack_end variable needed to be cleared after its first
use. By setting irq_stack to the per cpu irq_stack and passing
that to analyze_stack(), and then clearing it after it is processed,
we can get back the original behavior.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/dumpstack_64.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 74c262a..1abcb50 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -116,9 +116,9 @@ enum stack_type {
 
 static enum stack_type
 analyze_stack(int cpu, struct task_struct *task, unsigned long *stack,
-	      unsigned long **stack_end, unsigned *used, char **id)
+	      unsigned long **stack_end, unsigned long *irq_stack,
+	      unsigned *used, char **id)
 {
-	unsigned long *irq_stack;
 	unsigned long addr;
 
 	addr = ((unsigned long)stack & (~(THREAD_SIZE - 1)));
@@ -130,11 +130,11 @@ analyze_stack(int cpu, struct task_struct *task, unsigned long *stack,
 	if (*stack_end)
 		return STACK_IS_EXCEPTION;
 
-	*stack_end = (unsigned long *)per_cpu(irq_stack_ptr, cpu);
-	if (!*stack_end)
-		return STACK_IS_UNKNOWN;
+	if (!irq_stack)
+		return STACK_IS_NORMAL;
 
-	irq_stack = *stack_end - irq_stack_size;
+	*stack_end = irq_stack;
+	irq_stack = irq_stack - irq_stack_size;
 
 	if (in_irq_stack(stack, irq_stack, *stack_end))
 		return STACK_IS_IRQ;
@@ -155,7 +155,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 {
 	const unsigned cpu = get_cpu();
 	struct thread_info *tinfo;
-	unsigned long *irq_stack;
+	unsigned long *irq_stack = (unsigned long *)per_cpu(irq_stack_ptr, cpu);
 	unsigned long dummy;
 	unsigned used = 0;
 	int graph = 0;
@@ -186,7 +186,8 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		enum stack_type stype;
 		char *id;
 
-		stype = analyze_stack(cpu, task, stack, &stack_end, &used, &id);
+		stype = analyze_stack(cpu, task, stack, &stack_end,
+				      irq_stack, &used, &id);
 
 		/* Default finish unless specified to continue */
 		done = 1;
@@ -226,7 +227,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 			 * pointer (index -1 to end) in the IRQ stack:
 			 */
 			stack = (unsigned long *) (stack_end[-1]);
-			irq_stack = stack_end - irq_stack_size;
+			irq_stack = NULL;
 			ops->stack(data, "EOI");
 			done = 0;
 			break;
-- 
1.8.5.3


