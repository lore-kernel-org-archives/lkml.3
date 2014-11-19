Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbaKSRG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 12:06:26 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34155 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829AbaKSRGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 12:06:25 -0500
From: Lin Yongting <linyongting@gmail.com>
To: linux@arm.linux.org.uk, stefano.stabellini@eu.citrix.com,
        haojian.zhuang@gmail.com, christoffer.dall@linaro.org, nsekhar@ti.com,
        linux-arm-kernel@lists.infradead.org, will.deacon@arm.com
Cc: linux-kernel@vger.kernel.org, linyongting@gmail.com,
        linyongting@huawei.com
Subject: [PATCH] ARM: Add unwinding support for __memzero function
Date: Thu, 20 Nov 2014 01:06:05 +0800
Message-Id: <1416416765-10217-1-git-send-email-linyongting@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __memzero function never had unwinding annotations added.
Currently, when accessing invalid pointer by __memzero occurs the
backtrace shown will stop at __memzero or some completely unrelated
function. Add unwinding annotations in hopes of getting a more
useful backtrace in following cases:
1. die on accessing invalid pointer by __memzero
2. kprobe trapped at any instruction within __memzero
3. interrupted at any instruction within __memzero

Signed-off-by: Lin Yongting <linyongting@gmail.com>
---
 arch/arm/lib/memzero.S |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/lib/memzero.S b/arch/arm/lib/memzero.S
index 385ccb3..0eded95 100644
--- a/arch/arm/lib/memzero.S
+++ b/arch/arm/lib/memzero.S
@@ -9,6 +9,7 @@
  */
 #include <linux/linkage.h>
 #include <asm/assembler.h>
+#include <asm/unwind.h>
 
 	.text
 	.align	5
@@ -18,6 +19,7 @@
  * mis-aligned by, and r1 is the number of bytes.  If r1 < 4, then we
  * don't bother; we use byte stores instead.
  */
+UNWIND(	.fnstart			)
 1:	subs	r1, r1, #4		@ 1 do we have enough
 	blt	5f			@ 1 bytes to align with?
 	cmp	r3, #2			@ 1
@@ -47,6 +49,9 @@ ENTRY(__memzero)
  * use the LR
  */
 	str	lr, [sp, #-4]!		@ 1
+UNWIND(	.fnend				)
+UNWIND(	.fnstart			)
+UNWIND(	.save 	{lr}			)
 	mov	ip, r2			@ 1
 	mov	lr, r2			@ 1
 
@@ -66,6 +71,7 @@ ENTRY(__memzero)
 	tst	r1, #16			@ 1 16 bytes or more?
 	stmneia	r0!, {r2, r3, ip, lr}	@ 4
 	ldr	lr, [sp], #4		@ 1
+UNWIND(	.fnend				)
 
 #else
 
@@ -75,6 +81,9 @@ ENTRY(__memzero)
  */
 
 	stmfd	sp!, {r4-r7, lr}
+UNWIND(	.fnend		       )
+UNWIND(	.fnstart	       )
+UNWIND(	.save 	{r4-r7, lr}    )
 	mov	r4, r2
 	mov	r5, r2
 	mov	r6, r2
@@ -105,9 +114,11 @@ ENTRY(__memzero)
 	tst	r1, #16
 	stmneia	r0!, {r4-r7}
 	ldmfd	sp!, {r4-r7, lr}
+UNWIND(	.fnend		       )
 
 #endif
 
+UNWIND(	.fnstart			)
 4:	tst	r1, #8			@ 1 8 bytes or more?
 	stmneia	r0!, {r2, r3}		@ 2
 	tst	r1, #4			@ 1 4 bytes or more?
@@ -122,4 +133,5 @@ ENTRY(__memzero)
 	tst	r1, #1			@ 1 a byte left over
 	strneb	r2, [r0], #1		@ 1
 	ret	lr			@ 1
+UNWIND(	.fnend				)
 ENDPROC(__memzero)
-- 
1.7.9.5

