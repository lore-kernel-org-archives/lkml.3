Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbaFGBoM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:44:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35977 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752547AbaFGBXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.740292954@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 72/92] x86-64, modify_ldt: Make support for 16-bit
 segments a runtime option
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/ldt.c        | 4 +++-
 arch/x86/vdso/vdso32-setup.c | 8 ++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -21,6 +21,8 @@
 #include <asm/mmu_context.h>
 #include <asm/syscalls.h>
 
+int sysctl_ldt16 = 0;
+
 #ifdef CONFIG_SMP
 static void flush_ldt(void *current_mm)
 {
@@ -235,7 +237,7 @@ static int write_ldt(void __user *ptr, u
 	 * IRET leaking the high bits of the kernel stack address.
 	 */
 #ifdef CONFIG_X86_64
-	if (!ldt_info.seg_32bit) {
+	if (!ldt_info.seg_32bit && !sysctl_ldt16) {
 		error = -EINVAL;
 		goto out_unlock;
 	}
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -41,6 +41,7 @@ enum {
 #ifdef CONFIG_X86_64
 #define vdso_enabled			sysctl_vsyscall32
 #define arch_setup_additional_pages	syscall32_setup_pages
+extern int sysctl_ldt16;
 #endif
 
 /*
@@ -387,6 +388,13 @@ static ctl_table abi_table2[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec
+	},
+	{
+		.procname	= "ldt16",
+		.data		= &sysctl_ldt16,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec
 	},
 	{}
 };

