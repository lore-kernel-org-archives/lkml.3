Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599AbaFII6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:58:55 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58560 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932179AbaFIIv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 112/146] x86-64, modify_ldt: Make support for 16-bit segments a runtime option
Date: Mon,  9 Jun 2014 10:50:47 +0200
Message-Id: <8591de4d1bf97dffbcbedda237a78639a0d1f393.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/kernel/ldt.c        | 4 +++-
 arch/x86/vdso/vdso32-setup.c | 8 ++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index af1d14a9ebda..dcbbaa165bde 100644
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
index d6bfb876cfb0..f1d633a43f8e 100644
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
1.9.3

