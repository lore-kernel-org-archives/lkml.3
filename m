Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbaD0Tok (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 15:44:40 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:40225 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbaD0Toc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 15:44:32 -0400
From: Larry Bassel <larry.bassel@linaro.org>
To: catalin.marinas@arm.com, will.deacon@arm.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, khilman@linaro.org,
        Larry Bassel <larry.bassel@linaro.org>
Subject: [PATCH 1/3] arm64: adjust el0_sync so that a function can be called
Date: Sun, 27 Apr 2014 12:44:12 -0700
Message-Id: <1398627854-9617-2-git-send-email-larry.bassel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398627854-9617-1-git-send-email-larry.bassel@linaro.org>
References: <1398627854-9617-1-git-send-email-larry.bassel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To implement the context tracker properly on arm64,
a function call needs to be made after debugging and
interrupts are turned on, but before the lr is changed
to point to ret_from_exception(). If the function call
is made after the lr is changed the function will not
return to the correct place. For similar reasons, defer
the setting of x0 so that it doesn't need to be saved
around the function call.

Signed-off-by: Larry Bassel <larry.bassel@linaro.org>
Reviewed-by: Kevin Hilman <khilman@linaro.org>
---
 arch/arm64/kernel/entry.S | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 39ac630..eda7755 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -349,11 +349,11 @@ el0_sync:
 	lsr	x24, x25, #ESR_EL1_EC_SHIFT	// exception class
 	cmp	x24, #ESR_EL1_EC_SVC64		// SVC in 64-bit state
 	b.eq	el0_svc
-	adr	lr, ret_from_exception
 	cmp	x24, #ESR_EL1_EC_DABT_EL0	// data abort in EL0
 	b.eq	el0_da
 	cmp	x24, #ESR_EL1_EC_IABT_EL0	// instruction abort in EL0
 	b.eq	el0_ia
+	adr	lr, ret_from_exception
 	cmp	x24, #ESR_EL1_EC_FP_ASIMD	// FP/ASIMD access
 	b.eq	el0_fpsimd_acc
 	cmp	x24, #ESR_EL1_EC_FP_EXC64	// FP/ASIMD exception
@@ -378,11 +378,11 @@ el0_sync_compat:
 	lsr	x24, x25, #ESR_EL1_EC_SHIFT	// exception class
 	cmp	x24, #ESR_EL1_EC_SVC32		// SVC in 32-bit state
 	b.eq	el0_svc_compat
-	adr	lr, ret_from_exception
 	cmp	x24, #ESR_EL1_EC_DABT_EL0	// data abort in EL0
 	b.eq	el0_da
 	cmp	x24, #ESR_EL1_EC_IABT_EL0	// instruction abort in EL0
 	b.eq	el0_ia
+	adr	lr, ret_from_exception
 	cmp	x24, #ESR_EL1_EC_FP_ASIMD	// FP/ASIMD access
 	b.eq	el0_fpsimd_acc
 	cmp	x24, #ESR_EL1_EC_FP_EXC32	// FP/ASIMD exception
@@ -421,28 +421,30 @@ el0_da:
 	/*
 	 * Data abort handling
 	 */
-	mrs	x0, far_el1
-	bic	x0, x0, #(0xff << 56)
 	disable_step x1
 	isb
 	enable_dbg
 	// enable interrupts before calling the main handler
 	enable_irq
+	mrs	x0, far_el1
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
 	disable_step x1
 	isb
 	enable_dbg
 	// enable interrupts before calling the main handler
 	enable_irq
+	mrs	x0, far_el1
 	orr	x1, x25, #1 << 24		// use reserved ISS bit for instruction aborts
 	mov	x2, sp
+	adr	lr, ret_from_exception
 	b	do_mem_abort
 el0_fpsimd_acc:
 	/*
-- 
1.8.3.2

