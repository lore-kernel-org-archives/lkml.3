Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585AbaEGNRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:17:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45664 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933410AbaEGNPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:15:20 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vineet Gupta <vgupta@synopsys.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 64/70] ARC: Entry Handler tweaks: Optimize away redundant IRQ_DISABLE_SAVE
Date: Wed,  7 May 2014 14:13:07 +0100
Message-Id: <1399468393-10140-65-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
References: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineet Gupta <vgupta@synopsys.com>

commit fce16bc35ae4a45634f3dc348d8d297a25c277cf upstream.

In the exception return path, for both U/K cases, intr are already
disabled (for various existing reasons). So when we drop down to
@restore_regs, we need not redo that.

There was subtle issue - when intr were NOT being disabled for
ret-to-kernel-but-no-preemption case - now fixed by moving the
IRQ_DISABLE further up in @resume_kernel_mode.

So what do we gain:

* Shaves off a few insn in return path.

* Eliminates the need for IRQ_DISABLE_SAVE assembler macro for ARCv2
  hence allows for entry code sharing.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arc/include/asm/irqflags.h |  7 -------
 arch/arc/kernel/entry.S         | 10 +++++-----
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/arch/arc/include/asm/irqflags.h b/arch/arc/include/asm/irqflags.h
index d99f79b..b68b53f 100644
--- a/arch/arc/include/asm/irqflags.h
+++ b/arch/arc/include/asm/irqflags.h
@@ -157,13 +157,6 @@ static inline void arch_unmask_irq(unsigned int irq)
 	flag	\scratch
 .endm
 
-.macro IRQ_DISABLE_SAVE  scratch, save
-	lr	\scratch, [status32]
-	mov	\save, \scratch		/* Make a copy */
-	bic	\scratch, \scratch, (STATUS_E1_MASK | STATUS_E2_MASK)
-	flag	\scratch
-.endm
-
 .macro IRQ_ENABLE  scratch
 	lr	\scratch, [status32]
 	or	\scratch, \scratch, (STATUS_E1_MASK | STATUS_E2_MASK)
diff --git a/arch/arc/kernel/entry.S b/arch/arc/kernel/entry.S
index 1d71651..89f7961 100644
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -642,6 +642,9 @@ resume_kernel_mode:
 
 #ifdef CONFIG_PREEMPT
 
+	; This is a must for preempt_schedule_irq()
+	IRQ_DISABLE	r9
+
 	; Can't preempt if preemption disabled
 	GET_CURR_THR_INFO_FROM_SP   r10
 	ld  r8, [r10, THREAD_INFO_PREEMPT_COUNT]
@@ -651,8 +654,6 @@ resume_kernel_mode:
 	ld  r9, [r10, THREAD_INFO_FLAGS]
 	bbit0  r9, TIF_NEED_RESCHED, restore_regs
 
-	IRQ_DISABLE	r9
-
 	; Invoke PREEMPTION
 	bl      preempt_schedule_irq
 
@@ -665,12 +666,11 @@ resume_kernel_mode:
 ;
 ; Restore the saved sys context (common exit-path for EXCPN/IRQ/Trap)
 ; IRQ shd definitely not happen between now and rtie
+; All 2 entry points to here already disable interrupts
 
 restore_regs :
 
-	; Disable Interrupts while restoring reg-file back
-	; XXX can this be optimised out
-	IRQ_DISABLE_SAVE    r9, r10	;@r10 has prisitine (pre-disable) copy
+	lr	r10, [status32]
 
 	; Restore REG File. In case multiple Events outstanding,
 	; use the same priorty as rtie: EXCPN, L2 IRQ, L1 IRQ, None
-- 
1.9.1

