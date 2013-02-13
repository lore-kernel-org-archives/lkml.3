Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303Ab3BMAML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 19:12:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58569 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab3BMAMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 19:12:09 -0500
Date: Tue, 12 Feb 2013 16:10:13 -0800
From: tip-bot for Borislav Petkov <bp@suse.de>
Message-ID: <tip-c3a22a26d07d928e2b74b58e2f9d2436958620f0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de, hpa@linux.intel.com
In-Reply-To: <1360592538-10643-4-git-send-email-bp@alien8.de>
References: <1360592538-10643-4-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86, head_32:
  Remove second CPUID detection from default_entry
Git-Commit-ID: c3a22a26d07d928e2b74b58e2f9d2436958620f0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 12 Feb 2013 16:10:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c3a22a26d07d928e2b74b58e2f9d2436958620f0
Gitweb:     http://git.kernel.org/tip/c3a22a26d07d928e2b74b58e2f9d2436958620f0
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Mon, 11 Feb 2013 15:22:17 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 12 Feb 2013 15:48:42 -0800

x86, head_32: Remove second CPUID detection from default_entry

We do that once earlier now and cache it into new_cpu_data.cpuid_level
so no need for the EFLAGS.ID toggling dance anymore.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1360592538-10643-4-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/head_32.S | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index e3725a0..2e8532e 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -399,18 +399,7 @@ default_entry:
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
@@ -436,7 +425,9 @@ default_entry:
 	movb %cl,X86_MASK
 	movl %edx,X86_CAPABILITY
 
-is486:	movl $0x50022,%ecx	# set AM, WP, NE and MP
+is486:
+	movb $4,X86
+	movl $0x50022,%ecx	# set AM, WP, NE and MP
 	movl %cr0,%eax
 	andl $0x80000011,%eax	# Save PG,PE,ET
 	orl %ecx,%eax
