Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369Ab3BMAKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 19:10:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58545 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758451Ab3BMAKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 19:10:18 -0500
Date: Tue, 12 Feb 2013 16:09:04 -0800
From: tip-bot for Borislav Petkov <bp@suse.de>
Message-ID: <tip-9efb58de919efa8312861d454be014094f6f0ffc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de, hpa@linux.intel.com
In-Reply-To: <1360592538-10643-3-git-send-email-bp@alien8.de>
References: <1360592538-10643-3-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Detect CPUID support early at boot
Git-Commit-ID: 9efb58de919efa8312861d454be014094f6f0ffc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 12 Feb 2013 16:09:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9efb58de919efa8312861d454be014094f6f0ffc
Gitweb:     http://git.kernel.org/tip/9efb58de919efa8312861d454be014094f6f0ffc
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Mon, 11 Feb 2013 15:22:16 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 12 Feb 2013 15:48:41 -0800

x86: Detect CPUID support early at boot

We detect CPUID function support on each CPU and save it for later use,
obviating the need to play the toggle EFLAGS.ID game every time. C code
is looking at ->cpuid_level anyway.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1360592538-10643-3-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/head_32.S | 50 +++++++++++++++++++++++------------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index a9c5cc8..e3725a0 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -307,30 +307,39 @@ default_entry:
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
@@ -378,14 +387,6 @@ default_entry:
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
@@ -461,7 +462,6 @@ is486:	movl $0x50022,%ecx	# set AM, WP, NE and MP
 	xorl %eax,%eax			# Clear LDT
 	lldt %ax
 
-	cld			# gcc2 wants the direction flag cleared at all times
 	pushl $0		# fake return address for unwinder
 	jmp *(initial_code)
 
