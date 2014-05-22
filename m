Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaEVT16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 15:27:58 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:65513 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbaEVT14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 15:27:56 -0400
From: Larry Bassel <larry.bassel@linaro.org>
To: catalin.marinas@arm.com, will.deacon@arm.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, khilman@linaro.org,
        Larry Bassel <larry.bassel@linaro.org>
Subject: [PATCH v4 1/2] arm64: adjust el0_sync so that a function can be called
Date: Thu, 22 May 2014 12:27:34 -0700
Message-Id: <1400786855-32656-2-git-send-email-larry.bassel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400786855-32656-1-git-send-email-larry.bassel@linaro.org>
References: <1400786855-32656-1-git-send-email-larry.bassel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To implement the context tracker properly on arm64,
a function call needs to be made after debugging and
interrupts are turned on, but before the lr is changed
to point to ret_to_user(). If the function call
is made after the lr is changed the function will not
return to the correct place.

For similar reasons, defer the setting of x0 so that
it doesn't need to be saved around the function call
(save far_el1 in x26 temporarily instead).

Signed-off-by: Larry Bassel <larry.bassel@linaro.org>
---
 arch/arm64/kernel/entry.S | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index e8b23a3..20b336e 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -354,7 +354,6 @@ el0_sync:
 	lsr	x24, x25, #ESR_EL1_EC_SHIFT	// exception class
 	cmp	x24, #ESR_EL1_EC_SVC64		// SVC in 64-bit state
 	b.eq	el0_svc
-	adr	lr, ret_to_user
 	cmp	x24, #ESR_EL1_EC_DABT_EL0	// data abort in EL0
 	b.eq	el0_da
 	cmp	x24, #ESR_EL1_EC_IABT_EL0	// instruction abort in EL0
@@ -383,7 +382,6 @@ el0_sync_compat:
 	lsr	x24, x25, #ESR_EL1_EC_SHIFT	// exception class
 	cmp	x24, #ESR_EL1_EC_SVC32		// SVC in 32-bit state
 	b.eq	el0_svc_compat
-	adr	lr, ret_to_user
 	cmp	x24, #ESR_EL1_EC_DABT_EL0	// data abort in EL0
 	b.eq	el0_da
 	cmp	x24, #ESR_EL1_EC_IABT_EL0	// instruction abort in EL0
@@ -426,22 +424,26 @@ el0_da:
 	/*
 	 * Data abort handling
 	 */
-	mrs	x0, far_el1
-	bic	x0, x0, #(0xff << 56)
+	mrs	x26, far_el1
 	// enable interrupts before calling the main handler
 	enable_dbg_and_irq
+	mov	x0, x26
+	bic	x0, x0, #(0xff << 56)
 	mov	x1, x25
 	mov	x2, sp
+	adr	lr, ret_to_user
 	b	do_mem_abort
 el0_ia:
 	/*
 	 * Instruction abort handling
 	 */
-	mrs	x0, far_el1
+	mrs	x26, far_el1
 	// enable interrupts before calling the main handler
 	enable_dbg_and_irq
+	mov	x0, x26
 	orr	x1, x25, #1 << 24		// use reserved ISS bit for instruction aborts
 	mov	x2, sp
+	adr	lr, ret_to_user
 	b	do_mem_abort
 el0_fpsimd_acc:
 	/*
@@ -450,6 +452,7 @@ el0_fpsimd_acc:
 	enable_dbg
 	mov	x0, x25
 	mov	x1, sp
+	adr	lr, ret_to_user
 	b	do_fpsimd_acc
 el0_fpsimd_exc:
 	/*
@@ -458,16 +461,19 @@ el0_fpsimd_exc:
 	enable_dbg
 	mov	x0, x25
 	mov	x1, sp
+	adr	lr, ret_to_user
 	b	do_fpsimd_exc
 el0_sp_pc:
 	/*
 	 * Stack or PC alignment exception handling
 	 */
-	mrs	x0, far_el1
+	mrs	x26, far_el1
 	// enable interrupts before calling the main handler
 	enable_dbg_and_irq
+	mov	x0, x26
 	mov	x1, x25
 	mov	x2, sp
+	adr	lr, ret_to_user
 	b	do_sp_pc_abort
 el0_undef:
 	/*
@@ -476,23 +482,27 @@ el0_undef:
 	// enable interrupts before calling the main handler
 	enable_dbg_and_irq
 	mov	x0, sp
+	adr	lr, ret_to_user
 	b	do_undefinstr
 el0_dbg:
 	/*
 	 * Debug exception handling
 	 */
 	tbnz	x24, #0, el0_inv		// EL0 only
-	mrs	x0, far_el1
+	mrs	x26, far_el1
+	mov	x0, x26
 	mov	x1, x25
 	mov	x2, sp
 	bl	do_debug_exception
 	enable_dbg
+	mov	x0, x26
 	b	ret_to_user
 el0_inv:
 	enable_dbg
 	mov	x0, sp
 	mov	x1, #BAD_SYNC
 	mrs	x2, esr_el1
+	adr	lr, ret_to_user
 	b	bad_mode
 ENDPROC(el0_sync)
 
-- 
1.8.3.2

