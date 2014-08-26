Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934206AbaHZIao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 04:30:44 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53428 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932744AbaHZIam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 04:30:42 -0400
From: kpark3469@gmail.com
To: linux@arm.linux.org.uk
Cc: keun-o.park@windriver.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, afzal.mohd.ma@gmail.com
Subject: [PATCH] ARM: compressed/head.S: use addruart properly
Date: Tue, 26 Aug 2014 17:30:15 +0900
Message-Id: <1409041815-8766-1-git-send-email-kpark3469@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sahara <keun-o.park@windriver.com>

This patch fixes compile error in compressed/head.S, when DEBUG
is defined. Since addruart macro accepts 3 params, rp, rv, and tmp,
loadsp macro also needs to be fixed. Or you will meet the following
error messages:
Error: ARM register expected -- `mov ,#(5<<1)'
Error: shift expression expected -- `add r3,r3,'

Signed-off-by: Sahara <keun-o.park@windriver.com>
---
 arch/arm/boot/compressed/head.S |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 413fd94..9f1a6cd 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -24,19 +24,19 @@
 #if defined(CONFIG_DEBUG_ICEDCC)
 
 #if defined(CONFIG_CPU_V6) || defined(CONFIG_CPU_V6K) || defined(CONFIG_CPU_V7)
-		.macro	loadsp, rb, tmp
+		.macro	loadsp, rp, rv, tmp
 		.endm
 		.macro	writeb, ch, rb
 		mcr	p14, 0, \ch, c0, c5, 0
 		.endm
 #elif defined(CONFIG_CPU_XSCALE)
-		.macro	loadsp, rb, tmp
+		.macro	loadsp, rp, rv, tmp
 		.endm
 		.macro	writeb, ch, rb
 		mcr	p14, 0, \ch, c8, c0, 0
 		.endm
 #else
-		.macro	loadsp, rb, tmp
+		.macro	loadsp, rp, rv, tmp
 		.endm
 		.macro	writeb, ch, rb
 		mcr	p14, 0, \ch, c1, c0, 0
@@ -52,17 +52,17 @@
 		.endm
 
 #if defined(CONFIG_ARCH_SA1100)
-		.macro	loadsp, rb, tmp
-		mov	\rb, #0x80000000	@ physical base address
+		.macro	loadsp, rp, rv, tmp
+		mov	\rp, #0x80000000	@ physical base address
 #ifdef CONFIG_DEBUG_LL_SER3
-		add	\rb, \rb, #0x00050000	@ Ser3
+		add	\rp, \rp, #0x00050000	@ Ser3
 #else
-		add	\rb, \rb, #0x00010000	@ Ser1
+		add	\rp, \rp, #0x00010000	@ Ser1
 #endif
 		.endm
 #else
-		.macro	loadsp,	rb, tmp
-		addruart \rb, \tmp
+		.macro	loadsp,	rp, rv, tmp
+		addruart \rp, \rv, \tmp
 		.endm
 #endif
 #endif
@@ -1209,7 +1209,7 @@ phex:		adr	r3, phexbuf
 		b	1b
 
 @ puts corrupts {r0, r1, r2, r3}
-puts:		loadsp	r3, r1
+puts:		loadsp	r3, r2, r1
 1:		ldrb	r2, [r0], #1
 		teq	r2, #0
 		moveq	pc, lr
@@ -1225,9 +1225,9 @@ puts:		loadsp	r3, r1
 		mov	pc, lr
 @ putc corrupts {r0, r1, r2, r3}
 putc:
+		loadsp	r3, r2, r1
 		mov	r2, r0
 		mov	r0, #0
-		loadsp	r3, r1
 		b	2b
 
 @ memdump corrupts {r0, r1, r2, r3, r10, r11, r12, lr}
-- 
1.7.9.5

