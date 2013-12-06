Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162024Ab3LFXPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:15:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48531 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161223Ab3LFXPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:15:15 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <andreas@biessmann.de>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 140/152] avr32: setup crt for early panic()
Date: Fri,  6 Dec 2013 15:11:04 -0800
Message-Id: <1386371476-2477-141-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <andreas@biessmann.de>

commit 7a2a74f4b856993218aa7cdeeb6c3103101340db upstream.

Before the CRT was (fully) set up in kernel_entry (bss cleared before in
_start, but also not before jump to panic() in no_tag_table case).

This patch fixes this up to have a fully working CRT when branching to panic()
in no_tag_table.

Signed-off-by: Andreas Bießmann <andreas@biessmann.de>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/avr32/boot/u-boot/head.S | 30 +++++++++++++++++++++++++-----
 arch/avr32/kernel/head.S      | 20 --------------------
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
1.8.3.2

