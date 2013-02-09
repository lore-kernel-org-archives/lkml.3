Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947398Ab3BIXQI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 18:16:08 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56935 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832Ab3BIXQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 18:16:06 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 2/5 -v2.1] x86: Detect CPUID support early at boot
Date: Sun, 10 Feb 2013 00:16:02 +0100
Message-Id: <1360451762-10175-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <20130209231351.GB5556@pd.tnic>
References: <20130209231351.GB5556@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

We detect CPUID function support on each CPU and save it for later use,
obviating the need to play the toggle EFLAGS.ID game every time. C code
is looking at ->cpuid_level anyway.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/head_32.S | 48 +++++++++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index f4d919e2cd2b..534397ba226c 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -318,30 +318,37 @@ default_entry:
 	movl %eax,%cr0
 
 /*
- *	New page tables may be in 4Mbyte page mode and may
- *	be using the global pages. 
+ * Initialize EFLAGS. Some BIOSes leave bits like NT set. This would confuse the
+ * debugger if this code is traced. Best to initialize before switching to
+ * protected mode. As a side effect, we clear DF too because GCC expects it so.
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
@@ -389,14 +396,6 @@ default_entry:
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
@@ -472,7 +471,6 @@ is486:	movl $0x50022,%ecx	# set AM, WP, NE and MP
 	xorl %eax,%eax			# Clear LDT
 	lldt %ax
 
-	cld			# gcc2 wants the direction flag cleared at all times
 	pushl $0		# fake return address for unwinder
 	jmp *(initial_code)
 
-- 
1.8.1.3.535.ga923c31

