Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbaJZOMY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 10:12:24 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:64733 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaJZOMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 10:12:23 -0400
From: linyongting@gmail.com
To: linux@arm.linux.org.uk, stefano.stabellini@eu.citrix.com,
        haojian.zhuang@gmail.com, christoffer.dall@linaro.org, nsekhar@ti.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linyongting@huawei.com, linyongting@gmail.com
Subject: [PATCH] ARM: Add unwinding support for memset function
Date: Sun, 26 Oct 2014 22:11:25 +0800
Message-Id: <1414332685-22774-1-git-send-email-linyongting@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lin Yongting <linyongting@gmail.com>

The memset function never had unwinding annotations added.
Currently, when accessing NULL pointer by memset occurs the
backtrace shown will stop at memset or some completely unrelated
function. Add unwinding annotations in hopes of getting a more
useful backtrace when accessing NULL pointer by memset, kprobe
or interrupt.

Signed-off-by: Lin Yongting <linyongting@gmail.com>
---
 arch/arm/lib/memset.S |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/lib/memset.S b/arch/arm/lib/memset.S
index 671455c..a4ee97b 100644
--- a/arch/arm/lib/memset.S
+++ b/arch/arm/lib/memset.S
@@ -11,11 +11,13 @@
  */
 #include <linux/linkage.h>
 #include <asm/assembler.h>
+#include <asm/unwind.h>
 
 	.text
 	.align	5
 
 ENTRY(memset)
+UNWIND( .fnstart         )
 	ands	r3, r0, #3		@ 1 unaligned?
 	mov	ip, r0			@ preserve r0 as return value
 	bne	6f			@ 1
@@ -34,6 +36,9 @@ ENTRY(memset)
  * We need 2 extra registers for this loop - use r8 and the LR
  */
 	stmfd	sp!, {r8, lr}
+UNWIND( .fnend              )
+UNWIND( .fnstart            )
+UNWIND( .save {r8, lr}      )
 	mov	r8, r1
 	mov	lr, r1
 
@@ -53,6 +58,7 @@ ENTRY(memset)
 	tst	r2, #16
 	stmneia	ip!, {r1, r3, r8, lr}
 	ldmfd	sp!, {r8, lr}
+UNWIND( .fnend              )
 
 #else
 
@@ -62,6 +68,9 @@ ENTRY(memset)
  */
 
 	stmfd	sp!, {r4-r8, lr}
+UNWIND( .fnend                 )
+UNWIND( .fnstart               )
+UNWIND( .save {r4-r8, lr}      )
 	mov	r4, r1
 	mov	r5, r1
 	mov	r6, r1
@@ -94,9 +103,11 @@ ENTRY(memset)
 	tst	r2, #16
 	stmneia	ip!, {r4-r7}
 	ldmfd	sp!, {r4-r8, lr}
+UNWIND( .fnend                 )
 
 #endif
 
+UNWIND( .fnstart            )
 4:	tst	r2, #8
 	stmneia	ip!, {r1, r3}
 	tst	r2, #4
@@ -120,4 +131,5 @@ ENTRY(memset)
 	strb	r1, [ip], #1		@ 1
 	add	r2, r2, r3		@ 1 (r2 = r2 - (4 - r3))
 	b	1b
+UNWIND( .fnend   )
 ENDPROC(memset)
-- 
1.7.9.5

