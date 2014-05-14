Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaENXn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 19:43:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34344 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaENXnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 19:43:24 -0400
Date: Wed, 14 May 2014 16:43:01 -0700
From: tip-bot for Linus Torvalds <tipbot@zytor.com>
Message-ID: <tip-fa81511bb0bbb2b1aace3695ce869da9762624ff@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        stable@vger.kernel.org, hpa@linux.intel.com
In-Reply-To: <CA+55aFw9BPoD10U1LfHbOMpHWZkvJTkMcfCs9s3urPr1YyWBxw@mail.gmail.com>
References: <CA+55aFw9BPoD10U1LfHbOMpHWZkvJTkMcfCs9s3urPr1YyWBxw@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-64, modify_ldt:
  Make support for 16-bit segments a runtime option
Git-Commit-ID: fa81511bb0bbb2b1aace3695ce869da9762624ff
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa81511bb0bbb2b1aace3695ce869da9762624ff
Gitweb:     http://git.kernel.org/tip/fa81511bb0bbb2b1aace3695ce869da9762624ff
Author:     Linus Torvalds <torvalds@linux-foundation.org>
AuthorDate: Wed, 14 May 2014 16:33:54 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 14 May 2014 16:33:54 -0700

x86-64, modify_ldt: Make support for 16-bit segments a runtime option

Checkin:

b3b42ac2cbae x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels

disabled 16-bit segments on 64-bit kernels due to an information
leak.  However, it does seem that people are genuinely using Wine to
run old 16-bit Windows programs on Linux.

A proper fix for this ("espfix64") is coming in the upcoming merge
window, but as a temporary fix, create a sysctl to allow the
administrator to re-enable support for 16-bit segments.

It adds a "/proc/sys/abi/ldt16" sysctl that defaults to zero (off). If
you hit this issue and care about your old Windows program more than
you care about a kernel stack address information leak, you can do

   echo 1 > /proc/sys/abi/ldt16

as root (add it to your startup scripts), and you should be ok.

The sysctl table is only added if you have COMPAT support enabled on
x86-64, but I assume anybody who runs old windows binaries very much
does that ;)

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/CA%2B55aFw9BPoD10U1LfHbOMpHWZkvJTkMcfCs9s3urPr1YyWBxw@mail.gmail.com
Cc: <stable@vger.kernel.org>
---
 arch/x86/kernel/ldt.c        | 4 +++-
 arch/x86/vdso/vdso32-setup.c | 8 ++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index af1d14a..dcbbaa1 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -20,6 +20,8 @@
 #include <asm/mmu_context.h>
 #include <asm/syscalls.h>
 
+int sysctl_ldt16 = 0;
+
 #ifdef CONFIG_SMP
 static void flush_ldt(void *current_mm)
 {
@@ -234,7 +236,7 @@ static int write_ldt(void __user *ptr, unsigned long bytecount, int oldmode)
 	 * IRET leaking the high bits of the kernel stack address.
 	 */
 #ifdef CONFIG_X86_64
-	if (!ldt_info.seg_32bit) {
+	if (!ldt_info.seg_32bit && !sysctl_ldt16) {
 		error = -EINVAL;
 		goto out_unlock;
 	}
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 0034898..e1f220e 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -39,6 +39,7 @@
 #ifdef CONFIG_X86_64
 #define vdso_enabled			sysctl_vsyscall32
 #define arch_setup_additional_pages	syscall32_setup_pages
+extern int sysctl_ldt16;
 #endif
 
 /*
@@ -249,6 +250,13 @@ static struct ctl_table abi_table2[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec
 	},
+	{
+		.procname	= "ldt16",
+		.data		= &sysctl_ldt16,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec
+	},
 	{}
 };
 
