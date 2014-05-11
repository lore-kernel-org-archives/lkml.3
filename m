Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964887AbaEKTrD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:47:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933290AbaEKTXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:23:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 3.10 19/48] ARC: Entry Handler tweaks: Optimize away redundant IRQ_DISABLE_SAVE
Date: Sun, 11 May 2014 21:19:53 +0200
Message-Id: <20140511191950.724190228@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191948.079900414@linuxfoundation.org>
References: <20140511191948.079900414@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/include/asm/irqflags.h |    7 -------
 arch/arc/kernel/entry.S         |   10 +++++-----
 2 files changed, 5 insertions(+), 12 deletions(-)

--- a/arch/arc/include/asm/irqflags.h
+++ b/arch/arc/include/asm/irqflags.h
@@ -137,13 +137,6 @@ static inline void arch_unmask_irq(unsig
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
--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -653,6 +653,9 @@ resume_kernel_mode:
 
 #ifdef CONFIG_PREEMPT
 
+	; This is a must for preempt_schedule_irq()
+	IRQ_DISABLE	r9
+
 	; Can't preempt if preemption disabled
 	GET_CURR_THR_INFO_FROM_SP   r10
 	ld  r8, [r10, THREAD_INFO_PREEMPT_COUNT]
@@ -662,8 +665,6 @@ resume_kernel_mode:
 	ld  r9, [r10, THREAD_INFO_FLAGS]
 	bbit0  r9, TIF_NEED_RESCHED, restore_regs
 
-	IRQ_DISABLE	r9
-
 	; Invoke PREEMPTION
 	bl      preempt_schedule_irq
 
@@ -676,12 +677,11 @@ resume_kernel_mode:
 ;
 ; Restore the saved sys context (common exit-path for EXCPN/IRQ/Trap)
 ; IRQ shd definitely not happen between now and rtie
+; All 2 entry points to here already disable interrupts
 
 restore_regs :
 
-	; Disable Interrupts while restoring reg-file back
-	; XXX can this be optimised out
-	IRQ_DISABLE_SAVE    r9, r10	;@r10 has prisitine (pre-disable) copy
+	lr	r10, [status32]
 
 #ifdef CONFIG_ARC_CURR_IN_REG
 	; Restore User R25


