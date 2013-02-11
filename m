Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab3BKOWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 09:22:45 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45171 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757232Ab3BKOWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 09:22:24 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 1/4] x86, head_32: Remove i386 pieces
Date: Mon, 11 Feb 2013 15:22:15 +0100
Message-Id: <1360592538-10643-2-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1360592538-10643-1-git-send-email-bp@alien8.de>
References: <1360592538-10643-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Remove code fragments detecting a 386 CPU since we don't support those
anymore. Also, do not do alignment checks because they're done only at
CPL3. Also, no need to preserve EFLAGS.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/head_32.S | 22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 0b8c825fc264..f4d919e2cd2b 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -405,30 +405,21 @@ default_entry:
 	jz 1f				# Did we do this already?
 	call *%eax
 1:
-	
-/* check if it is 486 or 386. */
+
 /*
- * XXX - this does a lot of unnecessary setup.  Alignment checks don't
- * apply at our cpl of 0 and the stack ought to be aligned already, and
- * we don't need to preserve eflags.
+ * Check if it is 486
  */
 	movl $-1,X86_CPUID	# -1 for no CPUID initially
-	movb $3,X86		# at least 386
+	movb $4,X86		# at least 486
 	pushfl			# push EFLAGS
 	popl %eax		# get EFLAGS
 	movl %eax,%ecx		# save original EFLAGS
-	xorl $0x240000,%eax	# flip AC and ID bits in EFLAGS
+	xorl $0x200000,%eax	# flip ID bit in EFLAGS
 	pushl %eax		# copy to EFLAGS
 	popfl			# set EFLAGS
 	pushfl			# get new EFLAGS
 	popl %eax		# put it in eax
 	xorl %ecx,%eax		# change in flags
-	pushl %ecx		# restore original EFLAGS
-	popfl
-	testl $0x40000,%eax	# check if AC bit changed
-	je is386
-
-	movb $4,X86		# at least 486
 	testl $0x200000,%eax	# check if ID bit changed
 	je is486
 
@@ -456,10 +447,7 @@ default_entry:
 	movl %edx,X86_CAPABILITY
 
 is486:	movl $0x50022,%ecx	# set AM, WP, NE and MP
-	jmp 2f
-
-is386:	movl $2,%ecx		# set MP
-2:	movl %cr0,%eax
+	movl %cr0,%eax
 	andl $0x80000011,%eax	# Save PG,PE,ET
 	orl %ecx,%eax
 	movl %eax,%cr0
-- 
1.8.1.3.535.ga923c31

