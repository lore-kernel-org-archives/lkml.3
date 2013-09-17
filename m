Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab3IQSxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 14:53:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:54499 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab3IQSxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 14:53:10 -0400
Message-Id: <20130917183628.857145384@linutronix.de>
User-Agent: quilt/0.60-1
Date: Tue, 17 Sep 2013 18:53:08 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [patch 4/6] ia64: Use preempt_schedule_irq
References: <20130917082838.218329307@infradead.org>
 <20130917182350.449685712@linutronix.de>
Content-Disposition: inline; filename=ia64-use-preempt-schedule-irq.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the proper core function instead of fiddling with PREEMPT_ACTIVE
and enable/disable interrupts in the low level code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org

---
 arch/ia64/kernel/entry.S |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

Index: linux-2.6/arch/ia64/kernel/entry.S
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/entry.S
+++ linux-2.6/arch/ia64/kernel/entry.S
@@ -1169,21 +1169,8 @@ skip_rbs_switch:
 .work_pending:
 	tbit.z p6,p0=r31,TIF_NEED_RESCHED	// is resched not needed?
 (p6)	br.cond.sptk.few .notify
-#ifdef CONFIG_PREEMPT
-(pKStk) dep r21=-1,r0,PREEMPT_ACTIVE_BIT,1
-	;;
-(pKStk) st4 [r20]=r21
-#endif
-	SSM_PSR_I(p0, p6, r2)	// enable interrupts
-	br.call.spnt.many rp=schedule
+	br.call.spnt.many rp=preempt_schedule_irq
 .ret9:	cmp.eq p6,p0=r0,r0	// p6 <- 1 (re-check)
-	RSM_PSR_I(p0, r2, r20)	// disable interrupts
-	;;
-#ifdef CONFIG_PREEMPT
-(pKStk)	adds r20=TI_PRE_COUNT+IA64_TASK_SIZE,r13
-	;;
-(pKStk)	st4 [r20]=r0		// preempt_count() <- 0
-#endif
 (pLvSys)br.cond.sptk.few  __paravirt_pending_syscall_end
 	br.cond.sptk.many .work_processed_kernel
 


