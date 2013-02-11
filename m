Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab3BKOWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 09:22:41 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45174 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757383Ab3BKOWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 09:22:24 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 2/4] x86: Detect CPUID support early at boot
Date: Mon, 11 Feb 2013 15:22:16 +0100
Message-Id: <1360592538-10643-3-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1360592538-10643-1-git-send-email-bp@alien8.de>
References: <1360592538-10643-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

We detect CPUID function support on each CPU and save it for later use,
obviating the need to play the toggle EFLAGS.ID game every time. C code
is looking at ->cpuid_level anyway.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/head_32.S | 50 +++++++++++++++++++++++------------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index f4d919e2cd2b..73e084a6d2c5 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -318,30 +318,39 @@ default_entry:
 	movl %eax,%cr0
 
 /*
- *	New page tables may be in 4Mbyte page mode and may
- *	be using the global pages. 
+ * We want to start out with EFLAGS unambiguously cleared. Some BIOSes leave
+ * bits like NT set. This would confuse the debugger if this code is traced. So
+ * initialize them properly now before switching to protected mode. That means
+ * DF in particular (even though we have cleared it earlier after copying the
+ * command line) because GCC expects it.
+ */
+	pushl $0
+	popfl
+
+/*
+ * New page tables may be in 4Mbyte page mode and may be using the global pages.
  *
- *	NOTE! If we are on a 486 we may have no cr4 at all!
- *	Specifically, cr4 exists if and only if CPUID exists
- *	and has flags other than the FPU flag set.
+ * NOTE! If we are on a 486 we may have no cr4 at all! Specifically, cr4 exists
+ * if and only if CPUID exists and has flags other than the FPU flag set.
  */
+	movl $-1,pa(X86_CPUID)		# preset CPUID level
 	movl $X86_EFLAGS_ID,%ecx
 	pushl %ecx
-	popfl
-	pushfl
-	popl %eax
-	pushl $0
-	popfl
+	popfl				# set EFLAGS=ID
 	pushfl
-	popl %edx
-	xorl %edx,%eax
-	testl %ecx,%eax
-	jz 6f			# No ID flag = no CPUID = no CR4
+	popl %eax			# get EFLAGS
+	testl $X86_EFLAGS_ID,%eax	# did EFLAGS.ID remained set?
+	jz 6f				# hw disallowed setting of ID bit
+					# which means no CPUID and no CR4
+
+	xorl %eax,%eax
+	cpuid
+	movl %eax,pa(X86_CPUID)		# save largest std CPUID function
 
 	movl $1,%eax
 	cpuid
-	andl $~1,%edx		# Ignore CPUID.FPU
-	jz 6f			# No flags or only CPUID.FPU = no CR4
+	andl $~1,%edx			# Ignore CPUID.FPU
+	jz 6f				# No flags or only CPUID.FPU = no CR4
 
 	movl pa(mmu_cr4_features),%eax
 	movl %eax,%cr4
@@ -389,14 +398,6 @@ default_entry:
 	addl $__PAGE_OFFSET, %esp
 
 /*
- * Initialize eflags.  Some BIOS's leave bits like NT set.  This would
- * confuse the debugger if this code is traced.
- * XXX - best to initialize before switching to protected mode.
- */
-	pushl $0
-	popfl
-
-/*
  * start system 32-bit setup. We need to re-do some of the things done
  * in 16-bit mode for the "real" operations.
  */
@@ -472,7 +473,6 @@ is486:	movl $0x50022,%ecx	# set AM, WP, NE and MP
 	xorl %eax,%eax			# Clear LDT
 	lldt %ax
 
-	cld			# gcc2 wants the direction flag cleared at all times
 	pushl $0		# fake return address for unwinder
 	jmp *(initial_code)
 
-- 
1.8.1.3.535.ga923c31

