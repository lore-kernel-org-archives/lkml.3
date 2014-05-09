Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbaEIVwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:52:12 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:57074 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757479AbaEIVwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:52:08 -0400
From: Larry Bassel <larry.bassel@linaro.org>
To: catalin.marinas@arm.com, will.deacon@arm.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, khilman@linaro.org,
        Larry Bassel <larry.bassel@linaro.org>
Subject: [PATCH v3 1/2] arm64: adjust el0_sync so that a function can be called
Date: Fri,  9 May 2014 14:51:49 -0700
Message-Id: <1399672310-9061-2-git-send-email-larry.bassel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399672310-9061-1-git-send-email-larry.bassel@linaro.org>
References: <1399672310-9061-1-git-send-email-larry.bassel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To implement the context tracker properly on arm64,
a function call needs to be made after debugging and
interrupts are turned on, but before the lr is changed
to point to ret_from_exception(). If the function call
is made after the lr is changed the function will not
return to the correct place.

For similar reasons, defer the setting of x0 so that
it doesn't need to be saved around the function call
(save far_el1 in x26 temporarily instead).

Signed-off-by: Larry Bassel <larry.bassel@linaro.org>
Reviewed-by: Kevin Hilman <khilman@linaro.org>
---
 arch/arm64/kernel/entry.S | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 39ac630..136bb7d 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -349,7 +349,6 @@ el0_sync:
 	lsr	x24, x25, #ESR_EL1_EC_SHIFT	// exception class
 	cmp	x24, #ESR_EL1_EC_SVC64		// SVC in 64-bit state
 	b.eq	el0_svc
-	adr	lr, ret_from_exception
 	cmp	x24, #ESR_EL1_EC_DABT_EL0	// data abort in EL0
 	b.eq	el0_da
 	cmp	x24, #ESR_EL1_EC_IABT_EL0	// instruction abort in EL0
@@ -378,7 +377,6 @@ el0_sync_compat:
 	lsr	x24, x25, #ESR_EL1_EC_SHIFT	// exception class
 	cmp	x24, #ESR_EL1_EC_SVC32		// SVC in 32-bit state
 	b.eq	el0_svc_compat
-	adr	lr, ret_from_exception
 	cmp	x24, #ESR_EL1_EC_DABT_EL0	// data abort in EL0
 	b.eq	el0_da
 	cmp	x24, #ESR_EL1_EC_IABT_EL0	// instruction abort in EL0
@@ -421,28 +419,32 @@ el0_da:
 	/*
 	 * Data abort handling
 	 */
-	mrs	x0, far_el1
-	bic	x0, x0, #(0xff << 56)
+	mrs	x26, far_el1
 	disable_step x1
 	isb
 	enable_dbg
 	// enable interrupts before calling the main handler
 	enable_irq
+	mov	x0, x26
+	bic	x0, x0, #(0xff << 56)
 	mov	x1, x25
 	mov	x2, sp
+	adr	lr, ret_from_exception
 	b	do_mem_abort
 el0_ia:
 	/*
 	 * Instruction abort handling
 	 */
-	mrs	x0, far_el1
+	mrs	x26, far_el1
 	disable_step x1
 	isb
 	enable_dbg
 	// enable interrupts before calling the main handler
 	enable_irq
+	mov	x0, x26
 	orr	x1, x25, #1 << 24		// use reserved ISS bit for instruction aborts
 	mov	x2, sp
+	adr	lr, ret_from_exception
 	b	do_mem_abort
 el0_fpsimd_acc:
 	/*
@@ -450,6 +452,7 @@ el0_fpsimd_acc:
 	 */
 	mov	x0, x25
 	mov	x1, sp
+	adr	lr, ret_from_exception
 	b	do_fpsimd_acc
 el0_fpsimd_exc:
 	/*
@@ -457,42 +460,50 @@ el0_fpsimd_exc:
 	 */
 	mov	x0, x25
 	mov	x1, sp
+	adr	lr, ret_from_exception
 	b	do_fpsimd_exc
 el0_sp_pc:
 	/*
 	 * Stack or PC alignment exception handling
 	 */
-	mrs	x0, far_el1
+	mrs	x26, far_el1
 	disable_step x1
 	isb
 	enable_dbg
 	// enable interrupts before calling the main handler
 	enable_irq
+	mov	x0, x26
 	mov	x1, x25
 	mov	x2, sp
+	adr	lr, ret_from_exception
 	b	do_sp_pc_abort
 el0_undef:
 	/*
 	 * Undefined instruction
 	 */
-	mov	x0, sp
+	mov	x26, sp
 	// enable interrupts before calling the main handler
 	enable_irq
+	mov	x0, x26
+	adr	lr, ret_from_exception
 	b	do_undefinstr
 el0_dbg:
 	/*
 	 * Debug exception handling
 	 */
 	tbnz	x24, #0, el0_inv		// EL0 only
-	mrs	x0, far_el1
+	mrs	x26, far_el1
 	disable_step x1
+	mov	x0, x26
 	mov	x1, x25
 	mov	x2, sp
+	adr	lr, ret_from_exception
 	b	do_debug_exception
 el0_inv:
 	mov	x0, sp
 	mov	x1, #BAD_SYNC
 	mrs	x2, esr_el1
+	adr	lr, ret_from_exception
 	b	bad_mode
 ENDPROC(el0_sync)
 
-- 
1.8.3.2

