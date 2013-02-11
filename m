Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab3BKOWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 09:22:43 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45172 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757359Ab3BKOWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 09:22:24 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 3/4] x86, head_32: Remove second CPUID detection from default_entry
Date: Mon, 11 Feb 2013 15:22:17 +0100
Message-Id: <1360592538-10643-4-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1360592538-10643-1-git-send-email-bp@alien8.de>
References: <1360592538-10643-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

We do that once earlier now and cache it into new_cpu_data.cpuid_level
so no need for the EFLAGS.ID toggling dance anymore.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/head_32.S | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 73e084a6d2c5..e893ac09ca03 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -410,18 +410,7 @@ default_entry:
 /*
  * Check if it is 486
  */
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
@@ -447,7 +436,9 @@ default_entry:
 	movb %cl,X86_MASK
 	movl %edx,X86_CAPABILITY
 
-is486:	movl $0x50022,%ecx	# set AM, WP, NE and MP
+is486:
+	movb $4,X86
+	movl $0x50022,%ecx	# set AM, WP, NE and MP
 	movl %cr0,%eax
 	andl $0x80000011,%eax	# Save PG,PE,ET
 	orl %ecx,%eax
-- 
1.8.1.3.535.ga923c31

