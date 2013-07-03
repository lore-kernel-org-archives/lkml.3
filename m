Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965450Ab3GCTTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:19:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20027 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933297Ab3GCTAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:10 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=Gx-0yxZvRxsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=iSE1Itgoo4QA:10 a=VwQbUJbxAAAA:8 a=wMNdZWldAAAA:8 a=vwYKb_VxwG-5AH5Ip-gA:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184109.522293453@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:41:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [137/141] powerpc: Fix stack overflow crash in resume_kernel when ftracing
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0137-powerpc-Fix-stack-overflow-crash-in-resume_kernel-wh.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <michael@ellerman.id.au>

[ Upstream commit 0e37739b1c96d65e6433998454985de994383019 ]

It's possible for us to crash when running with ftrace enabled, eg:

  Bad kernel stack pointer bffffd12 at c00000000000a454
  cpu 0x3: Vector: 300 (Data Access) at [c00000000ffe3d40]
      pc: c00000000000a454: resume_kernel+0x34/0x60
      lr: c00000000000335c: performance_monitor_common+0x15c/0x180
      sp: bffffd12
     msr: 8000000000001032
     dar: bffffd12
   dsisr: 42000000

If we look at current's stack (paca->__current->stack) we see it is
equal to c0000002ecab0000. Our stack is 16K, and comparing to
paca->kstack (c0000002ecab3e30) we can see that we have overflowed our
kernel stack. This leads to us writing over our struct thread_info, and
in this case we have corrupted thread_info->flags and set
_TIF_EMULATE_STACK_STORE.

Dumping the stack we see:

  3:mon> t c0000002ecab0000
  [c0000002ecab0000] c00000000002131c .performance_monitor_exception+0x5c/0x70
  [c0000002ecab0080] c00000000000335c performance_monitor_common+0x15c/0x180
  --- Exception: f01 (Performance Monitor) at c0000000000fb2ec .trace_hardirqs_off+0x1c/0x30
  [c0000002ecab0370] c00000000016fdb0 .trace_graph_entry+0xb0/0x280 (unreliable)
  [c0000002ecab0410] c00000000003d038 .prepare_ftrace_return+0x98/0x130
  [c0000002ecab04b0] c00000000000a920 .ftrace_graph_caller+0x14/0x28
  [c0000002ecab0520] c0000000000d6b58 .idle_cpu+0x18/0x90
  [c0000002ecab05a0] c00000000000a934 .return_to_handler+0x0/0x34
  [c0000002ecab0620] c00000000001e660 .timer_interrupt+0x160/0x300
  [c0000002ecab06d0] c0000000000025dc decrementer_common+0x15c/0x180
  --- Exception: 901 (Decrementer) at c0000000000104d4 .arch_local_irq_restore+0x74/0xa0
  [c0000002ecab09c0] c0000000000fe044 .trace_hardirqs_on+0x14/0x30 (unreliable)
  [c0000002ecab0fb0] c00000000016fe3c .trace_graph_entry+0x13c/0x280
  [c0000002ecab1050] c00000000003d038 .prepare_ftrace_return+0x98/0x130
  [c0000002ecab10f0] c00000000000a920 .ftrace_graph_caller+0x14/0x28
  [c0000002ecab1160] c0000000000161f0 .__ppc64_runlatch_on+0x10/0x40
  [c0000002ecab11d0] c00000000000a934 .return_to_handler+0x0/0x34
  --- Exception: 901 (Decrementer) at c0000000000104d4 .arch_local_irq_restore+0x74/0xa0

  ... and so on

__ppc64_runlatch_on() is called from RUNLATCH_ON in the exception entry
path. At that point the irq state is not consistent, ie. interrupts are
hard disabled (by the exception entry), but the paca soft-enabled flag
may be out of sync.

This leads to the local_irq_restore() in trace_graph_entry() actually
enabling interrupts, which we do not want. Because we have not yet
reprogrammed the decrementer we immediately take another decrementer
exception, and recurse.

The fix is twofold. Firstly make sure we call DISABLE_INTS before
calling RUNLATCH_ON. The badly named DISABLE_INTS actually reconciles
the irq state in the paca with the hardware, making it safe again to
call local_irq_save/restore().

Although that should be sufficient to fix the bug, we also mark the
runlatch routines as notrace. They are called very early in the
exception entry and we are asking for trouble tracing them. They are
also fairly uninteresting and tracing them just adds unnecessary
overhead.

[ This regression was introduced by fe1952fc0afb9a2e4c79f103c08aef5d13db1873
  "powerpc: Rework runlatch code" by myself --BenH
]

CC: <stable@vger.kernel.org> [v3.4+]
Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/powerpc/include/asm/exception-64s.h |    2 +-
 arch/powerpc/kernel/process.c            |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/exception-64s.h b/arch/powerpc/include/asm/exception-64s.h
index a43c147..3166d5e 100644
--- a/arch/powerpc/include/asm/exception-64s.h
+++ b/arch/powerpc/include/asm/exception-64s.h
@@ -320,7 +320,7 @@ label##_common:							\
  */
 #define STD_EXCEPTION_COMMON_ASYNC(trap, label, hdlr)		  \
 	EXCEPTION_COMMON(trap, label, hdlr, ret_from_except_lite, \
-			 FINISH_NAP;RUNLATCH_ON;DISABLE_INTS)
+			 FINISH_NAP;DISABLE_INTS;RUNLATCH_ON)
 
 /*
  * When the idle code in power4_idle puts the CPU into NAP mode,
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 1a1f2dd..b1e4ac1 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1221,7 +1221,7 @@ EXPORT_SYMBOL(dump_stack);
 
 #ifdef CONFIG_PPC64
 /* Called with hard IRQs off */
-void __ppc64_runlatch_on(void)
+void notrace __ppc64_runlatch_on(void)
 {
 	struct thread_info *ti = current_thread_info();
 	unsigned long ctrl;
@@ -1234,7 +1234,7 @@ void __ppc64_runlatch_on(void)
 }
 
 /* Called with hard IRQs off */
-void __ppc64_runlatch_off(void)
+void notrace __ppc64_runlatch_off(void)
 {
 	struct thread_info *ti = current_thread_info();
 	unsigned long ctrl;
-- 
1.7.10.4


