Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab3BCQO6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 11:14:58 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42595 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102Ab3BCQOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 11:14:47 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 3/4] x86, head_32: Remove CPUID detection from default_entry
Date: Sun,  3 Feb 2013 17:14:38 +0100
Message-Id: <1359908079-10469-4-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.2.422.g08c0e7f
In-Reply-To: <1359908079-10469-1-git-send-email-bp@alien8.de>
References: <1359908079-10469-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

We do that once earlier now and cache it into boot_cpu_data.cpuid_level
so no need for the EFLAGS.ID toggling dance anymore.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/head_32.S | 40 +++++++---------------------------------
 1 file changed, 7 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index ce6b557017f4..0dba3598cf02 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -334,25 +334,14 @@ default_entry:
 	movl %eax,%cr0
 
 /*
- *	New page tables may be in 4Mbyte page mode and may
- *	be using the global pages. 
+ * New page tables may be in 4Mbyte page mode and may be using the global pages.
  *
- *	NOTE! If we are on a 486 we may have no cr4 at all!
- *	Specifically, cr4 exists if and only if CPUID exists
- *	and has flags other than the FPU flag set.
+ * NOTE! If we are on a 486 we may have no cr4 at all! Specifically, cr4 exists
+ * if and only if CPUID exists (which has been checked above) and has flags
+ * other than the FPU flag set.
  */
-	movl $X86_EFLAGS_ID,%ecx
-	pushl %ecx
-	popfl
-	pushfl
-	popl %eax
-	pushl $0
-	popfl
-	pushfl
-	popl %edx
-	xorl %edx,%eax
-	testl %ecx,%eax
-	jz 6f			# No ID flag = no CPUID = no CR4
+	cmpl $-1, pa(X86_CPUID)
+	je 6f			# No CPUID = no CR4
 
 	movl $1,%eax
 	cpuid
@@ -389,7 +378,6 @@ default_entry:
 	btsl $_EFER_NX, %eax
 	/* Make changes effective */
 	wrmsr
-
 6:
 
 /*
@@ -417,21 +405,7 @@ default_entry:
 	call *%eax
 1:
 
-/*
- * Check if it is 486
- */
-	movl $-1,X86_CPUID	# -1 for no CPUID initially
-	movb $4,X86		# at least 486
-	pushfl			# push EFLAGS
-	popl %eax		# get EFLAGS
-	movl %eax,%ecx		# save original EFLAGS
-	xorl $0x200000,%eax	# flip ID bit in EFLAGS
-	pushl %eax		# copy to EFLAGS
-	popfl			# set EFLAGS
-	pushfl			# get new EFLAGS
-	popl %eax		# put it in eax
-	xorl %ecx,%eax		# change in flags
-	testl $0x200000,%eax	# check if ID bit changed
+	cmpl $-1,X86_CPUID
 	je is486
 
 	/* get vendor info */
-- 
1.8.1.2.422.g08c0e7f

