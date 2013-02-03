Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab3BCQP3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 11:15:29 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42597 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424Ab3BCQOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 11:14:48 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 2/4] x86: Detect CPUID support early at boot
Date: Sun,  3 Feb 2013 17:14:37 +0100
Message-Id: <1359908079-10469-3-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.2.422.g08c0e7f
In-Reply-To: <1359908079-10469-1-git-send-email-bp@alien8.de>
References: <1359908079-10469-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

We detect CPUID function support on the boot CPU and save it for later
use, obviating the need to play the toggle EFLAGS.ID game every time. C
code is looking at ->cpuid_level anyway.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/head_32.S | 36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index a9c5cc851285..ce6b557017f4 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -29,16 +29,16 @@
 /*
  * References to members of the new_cpu_data structure.
  */
-
 #define X86		new_cpu_data+CPUINFO_x86
 #define X86_VENDOR	new_cpu_data+CPUINFO_x86_vendor
 #define X86_MODEL	new_cpu_data+CPUINFO_x86_model
 #define X86_MASK	new_cpu_data+CPUINFO_x86_mask
 #define X86_HARD_MATH	new_cpu_data+CPUINFO_hard_math
-#define X86_CPUID	new_cpu_data+CPUINFO_cpuid_level
 #define X86_CAPABILITY	new_cpu_data+CPUINFO_x86_capability
 #define X86_VENDOR_ID	new_cpu_data+CPUINFO_x86_vendor_id
 
+#define X86_CPUID	boot_cpu_data+CPUINFO_cpuid_level
+
 /*
  * This is how much memory in addition to the memory covered up to
  * and including _end we need mapped initially.
@@ -263,6 +263,33 @@ subarch_entries:
 num_subarch_entries = (. - subarch_entries) / 4
 .previous
 #else
+
+/*
+ * Initialize EFLAGS. Some BIOS's leave bits like NT set. This would confuse the
+ * debugger if this code is traced.
+ */
+	pushl $0
+	popfl
+
+/*
+ * Check whether this CPU supports CPUID, and, if so, save the highest standard
+ * CPUID function number for later.
+ */
+	movl $X86_EFLAGS_ID,%ecx	/* EFLAGS.ID */
+	pushl %ecx
+	popfl				/* set EFLAGS=ID */
+	pushfl				/* get EFLAGS */
+	popl %eax
+	xorl %ecx,%eax
+	jnz 1f				/* hw disallowed setting of ID bit */
+
+	xorl %eax,%eax
+	cpuid
+	movl %eax,pa(X86_CPUID)		/* save largest std CPUID function */
+	jmp default_entry
+
+1:
+	movl $-1,pa(X86_CPUID)
 	jmp default_entry
 #endif /* CONFIG_PARAVIRT */
 
@@ -377,11 +404,6 @@ default_entry:
 	/* Shift the stack pointer to a virtual address */
 	addl $__PAGE_OFFSET, %esp
 
-/*
- * Initialize eflags.  Some BIOS's leave bits like NT set.  This would
- * confuse the debugger if this code is traced.
- * XXX - best to initialize before switching to protected mode.
- */
 	pushl $0
 	popfl
 
-- 
1.8.1.2.422.g08c0e7f

