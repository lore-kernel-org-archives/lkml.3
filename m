Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab3JXKhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 06:37:18 -0400
Received: from cyclops.biessmann.org ([134.0.25.77]:38258 "EHLO
	cyclops.biessmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab3JXKhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 06:37:16 -0400
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Oct 2013 06:37:16 EDT
From: =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <andreas@biessmann.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <andreas@biessmann.de>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: [PATCH 1/2] avr32: setup crt for early panic()
Date: Thu, 24 Oct 2013 12:31:03 +0200
Message-Id: <1382610664-1195-1-git-send-email-andreas@biessmann.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before the CRT was (fully) set up in kernel_entry (bss cleared before in
_start, but also not before jump to panic() in no_tag_table case).

This patch fixes this up to have a fully working CRT when branching to panic()
in no_tag_table.

Signed-off-by: Andreas Bießmann <andreas@biessmann.de>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
---
 arch/avr32/boot/u-boot/head.S |   30 +++++++++++++++++++++++++-----
 arch/avr32/kernel/head.S      |   20 --------------------
 2 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/arch/avr32/boot/u-boot/head.S b/arch/avr32/boot/u-boot/head.S
index 4488fa2..d36d865 100644
--- a/arch/avr32/boot/u-boot/head.S
+++ b/arch/avr32/boot/u-boot/head.S
@@ -8,6 +8,8 @@
  * published by the Free Software Foundation.
  */
 #include <asm/setup.h>
+#include <asm/thread_info.h>
+#include <asm/sysreg.h>
 
 	/*
 	 * The kernel is loaded where we want it to be and all caches
@@ -20,11 +22,6 @@
 	.section .init.text,"ax"
 	.global _start
 _start:
-	/* Check if the boot loader actually provided a tag table */
-	lddpc	r0, magic_number
-	cp.w	r12, r0
-	brne	no_tag_table
-
 	/* Initialize .bss */
 	lddpc	r2, bss_start_addr
 	lddpc   r3, end_addr
@@ -34,6 +31,25 @@ _start:
 	cp      r2, r3
 	brlo    1b
 
+	/* Initialize status register */
+	lddpc	r0, init_sr
+	mtsr	SYSREG_SR, r0
+
+	/* Set initial stack pointer */
+	lddpc	sp, stack_addr
+	sub	sp, -THREAD_SIZE
+
+#ifdef CONFIG_FRAME_POINTER
+	/* Mark last stack frame */
+	mov	lr, 0
+	mov	r7, 0
+#endif
+
+	/* Check if the boot loader actually provided a tag table */
+	lddpc	r0, magic_number
+	cp.w	r12, r0
+	brne	no_tag_table
+
 	/*
 	 * Save the tag table address for later use. This must be done
 	 * _after_ .bss has been initialized...
@@ -53,6 +69,10 @@ bss_start_addr:
 	.long   __bss_start
 end_addr:
 	.long   _end
+init_sr:
+	.long	0x007f0000	/* Supervisor mode, everything masked */
+stack_addr:
+	.long	init_thread_union
 
 no_tag_table:
 	sub	r12, pc, (. - 2f)
diff --git a/arch/avr32/kernel/head.S b/arch/avr32/kernel/head.S
index 6163bd0..59eae6d 100644
--- a/arch/avr32/kernel/head.S
+++ b/arch/avr32/kernel/head.S
@@ -10,33 +10,13 @@
 #include <linux/linkage.h>
 
 #include <asm/page.h>
-#include <asm/thread_info.h>
-#include <asm/sysreg.h>
 
 	.section .init.text,"ax"
 	.global kernel_entry
 kernel_entry:
-	/* Initialize status register */
-	lddpc   r0, init_sr
-	mtsr	SYSREG_SR, r0
-
-	/* Set initial stack pointer */
-	lddpc   sp, stack_addr
-	sub	sp, -THREAD_SIZE
-
-#ifdef CONFIG_FRAME_POINTER
-	/* Mark last stack frame */
-	mov	lr, 0
-	mov	r7, 0
-#endif
-
 	/* Start the show */
 	lddpc   pc, kernel_start_addr
 
 	.align  2
-init_sr:
-	.long   0x007f0000	/* Supervisor mode, everything masked */
-stack_addr:
-	.long   init_thread_union
 kernel_start_addr:
 	.long   start_kernel
-- 
1.7.10.4

