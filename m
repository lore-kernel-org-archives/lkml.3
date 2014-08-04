Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbaHDUQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 16:16:58 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47134 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbaHDUQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 16:16:56 -0400
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, CPU: Call verify_cpu after having entered long mode
Date: Mon,  4 Aug 2014 22:16:53 +0200
Message-Id: <1407183413-14408-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

When we get loaded by a 64-bit bootloader, kernel entry point is
startup_64 in head_64.S. We don't trust any and all bootloaders for
fiddling with CPU configuration so we go ahead and massage each CPU
again into how we'd like it configured.

For that, make verify_cpu() callable in 64-bit mode too.

Requested-by: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/head_64.S    |  8 ++++++++
 arch/x86/kernel/verify_cpu.S | 12 +++++++-----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index a468c0a65c42..26b5c0dd0f72 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -65,6 +65,9 @@ startup_64:
 	 * tables and then reload them.
 	 */
 
+	/* Sanitize CPU configuration */
+	call verify_cpu
+
 	/*
 	 * Compute the delta between the address I am compiled to run at and the
 	 * address I am actually running at.
@@ -174,6 +177,9 @@ ENTRY(secondary_startup_64)
 	 * after the boot processor executes this code.
 	 */
 
+	/* Sanitize CPU configuration */
+	call verify_cpu
+
 	movq	$(init_level4_pgt - __START_KERNEL_map), %rax
 1:
 
@@ -288,6 +294,8 @@ ENTRY(secondary_startup_64)
 	pushq	%rax		# target address in negative space
 	lretq
 
+#include "verify_cpu.S"
+
 #ifdef CONFIG_HOTPLUG_CPU
 /*
  * Boot CPU0 entry point. It's called from play_dead(). Everything has been set
diff --git a/arch/x86/kernel/verify_cpu.S b/arch/x86/kernel/verify_cpu.S
index b9242bacbe59..c6f6603af2ff 100644
--- a/arch/x86/kernel/verify_cpu.S
+++ b/arch/x86/kernel/verify_cpu.S
@@ -34,10 +34,11 @@
 #include <asm/msr-index.h>
 
 verify_cpu:
-	pushfl				# Save caller passed flags
-	pushl	$0			# Kill any dangerous flags
-	popfl
+	pushf				# Save caller passed flags
+	push	$0			# Kill any dangerous flags
+	popf
 
+#ifndef __x86_64__
 	pushfl				# standard way to check for cpuid
 	popl	%eax
 	movl	%eax,%ebx
@@ -53,6 +54,7 @@ verify_cpu:
 	cpuid
 	cmpl	$0x1,%eax
 	jb	verify_cpu_no_longmode	# no cpuid 1
+#endif
 
 	xor	%di,%di
 	cmpl	$0x68747541,%ebx	# AuthenticAMD
@@ -130,10 +132,10 @@ verify_cpu_sse_test:
 	jmp	verify_cpu_sse_test	# try again
 
 verify_cpu_no_longmode:
-	popfl				# Restore caller passed flags
+	popf				# Restore caller passed flags
 	movl $1,%eax
 	ret
 verify_cpu_sse_ok:
-	popfl				# Restore caller passed flags
+	popf				# Restore caller passed flags
 	xorl %eax, %eax
 	ret
-- 
2.0.0

