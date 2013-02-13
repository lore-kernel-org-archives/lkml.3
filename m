Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257Ab3BMAJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 19:09:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58524 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758071Ab3BMAJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 19:09:52 -0500
Date: Tue, 12 Feb 2013 16:07:55 -0800
From: tip-bot for Borislav Petkov <bp@suse.de>
Message-ID: <tip-166df91daf38f619d4ca90b58ff90983de6e40d2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de, hpa@linux.intel.com
In-Reply-To: <1360592538-10643-2-git-send-email-bp@alien8.de>
References: <1360592538-10643-2-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86, head_32: Remove i386 pieces
Git-Commit-ID: 166df91daf38f619d4ca90b58ff90983de6e40d2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 12 Feb 2013 16:08:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  166df91daf38f619d4ca90b58ff90983de6e40d2
Gitweb:     http://git.kernel.org/tip/166df91daf38f619d4ca90b58ff90983de6e40d2
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Mon, 11 Feb 2013 15:22:15 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 12 Feb 2013 15:48:40 -0800

x86, head_32: Remove i386 pieces

Remove code fragments detecting a 386 CPU since we don't support those
anymore. Also, do not do alignment checks because they're done only at
CPL3. Also, no need to preserve EFLAGS.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1360592538-10643-2-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/head_32.S | 22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index c8932c7..a9c5cc8 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -394,30 +394,21 @@ default_entry:
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
 
@@ -445,10 +436,7 @@ default_entry:
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
