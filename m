Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab3LBUzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:55:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38475 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab3LBTNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:13:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <andreas@biessmann.de>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>
Subject: [PATCH 3.10 090/173] avr32: setup crt for early panic()
Date: Mon,  2 Dec 2013 11:11:13 -0800
Message-Id: <20131202191154.020671630@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Bießmann <andreas@biessmann.de>

commit 7a2a74f4b856993218aa7cdeeb6c3103101340db upstream.

Before the CRT was (fully) set up in kernel_entry (bss cleared before in
_start, but also not before jump to panic() in no_tag_table case).

This patch fixes this up to have a fully working CRT when branching to panic()
in no_tag_table.

Signed-off-by: Andreas Bießmann <andreas@biessmann.de>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/avr32/boot/u-boot/head.S |   30 +++++++++++++++++++++++++-----
 arch/avr32/kernel/head.S      |   20 --------------------
 2 files changed, 25 insertions(+), 25 deletions(-)

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


