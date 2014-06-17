Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967209AbaFQWPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:15:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54559 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966775AbaFQVvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:51:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 123/212] x86-64, modify_ldt: Make support for 16-bit segments a runtime option
Date: Tue, 17 Jun 2014 14:43:37 -0700
Message-Id: <1403041506-13646-124-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit fa81511bb0bbb2b1aace3695ce869da9762624ff upstream.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
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
index d6bfb87..f1d633a 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -41,6 +41,7 @@ enum {
 #ifdef CONFIG_X86_64
 #define vdso_enabled			sysctl_vsyscall32
 #define arch_setup_additional_pages	syscall32_setup_pages
+extern int sysctl_ldt16;
 #endif
 
 /*
@@ -380,6 +381,13 @@ static struct ctl_table abi_table2[] = {
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
 
-- 
1.9.1

