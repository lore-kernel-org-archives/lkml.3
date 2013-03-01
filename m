Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab3CAIjH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 03:39:07 -0500
Received: from mga14.intel.com ([143.182.124.37]:20889 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab3CAIjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 03:39:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,760,1355126400"; 
   d="scan'208";a="207668105"
Subject: [PATCH] Notify and correct preempt count if irq/x86 handler change
 it
From: channing <chao.bi@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, liu chuansheng <chuansheng.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Mar 2013 16:57:58 +0800
Message-ID: <1362128278.31563.22.camel@bichao>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On x86 platform, irq handler might runs in hardirq stack per cpu,
or kernel stack, it's possible that any irq handler modify
preempt count by mistake, and it would bring badly impact in below
3 scenarios:

1) irq interrupt a process in user mode, then irq handler will be
carry out in kernel stack, if handler changed preempt count, it will
impact the blocked process;

2) irq A's handler is executing on irq stack, it changes preempt
count and set IF EFLAG to enable local interrupt, then irq B is
coming and nest in hard irq stack, whose preempt count was fault
modified by irq A handler, then irq B's handler may hit preempt
count related issues.

3) irq handler changes preempt count's NMI bit by mistake, NMI may
come at this point and executed in hard irq stack or kernel stack,
and it would find that it's inside NMI context, and report a BUG().

This patch is to print out a notification when hardirq handler
change preempt count, it would helpful to faster debuger to find
misbehavior irq handler; On the other hand, when above case happen,
set back current preempt count to its previous value, to avoid
impacting on blocked process or other irq handler.

Signed-off-by: channing <chao.bi@intel.com>
Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 arch/x86/kernel/irq_32.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 344faf8..c92ab44 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -82,6 +82,7 @@ execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq)
 {
 	union irq_ctx *curctx, *irqctx;
 	u32 *isp, arg1, arg2;
+	int prev_count;
 
 	curctx = (union irq_ctx *) current_thread_info();
 	irqctx = __this_cpu_read(hardirq_ctx);
@@ -102,6 +103,7 @@ execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq)
 
 	/* Copy the preempt_count so that the [soft]irq checks work. */
 	irqctx->tinfo.preempt_count = curctx->tinfo.preempt_count;
+	prev_count = irqctx->tinfo.preempt_count;
 
 	if (unlikely(overflow))
 		call_on_stack(print_stack_overflow, isp);
@@ -113,6 +115,12 @@ execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq)
 		     :  "0" (irq),   "1" (desc),  "2" (isp),
 			"D" (desc->handle_irq)
 		     : "memory", "cc", "ecx");
+
+	if (unlikely(prev_count != irqctx->tinfo.preempt_count)) {
+		pr_err("huh, enterd irq %u handler with preempt_count %08x,exited with %08x?\n"
+			, irq, prev_count, irqctx->tinfo.preempt_count);
+		irqctx->tinfo.preempt_count = prev_count;
+	}
 	return 1;
 }
 
@@ -184,6 +192,7 @@ bool handle_irq(unsigned irq, struct pt_regs *regs)
 {
 	struct irq_desc *desc;
 	int overflow;
+	int prev_count;
 
 	overflow = check_stack_overflow();
 
@@ -194,7 +203,13 @@ bool handle_irq(unsigned irq, struct pt_regs *regs)
 	if (user_mode_vm(regs) || !execute_on_irq_stack(overflow, desc, irq)) {
 		if (unlikely(overflow))
 			print_stack_overflow();
+		prev_count = preempt_count();
 		desc->handle_irq(irq, desc);
+		if (unlikely(prev_count != preempt_count())) {
+			pr_err("huh, enterd irq %u handler with preempt_count %08x,exited with %08x?\n"
+				, irq, prev_count, preempt_count());
+			preempt_count() = prev_count;
+		}
 	}
 
 	return true;
-- 
1.7.1



