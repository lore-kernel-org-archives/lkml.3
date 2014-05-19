Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268AbaESFpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 01:45:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55154 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaESFpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 01:45:23 -0400
Date: Sun, 18 May 2014 22:44:31 -0700
Message-Id: <201405190544.s4J5iVVB021832@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for 3.15-rc6
Cc: <stable@vger.kernel.org>,
        Anthony Iliopoulos <anthony.iliopoulos@huawei.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shay Goikhman <shay.goikhman@huawei.com>,
        Stephan Mueller <smueller@chronox.de>, "Theodore Ts'o" <tytso@mit.edu>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit d6d211db37e75de2ddc3a4f979038c40df7cc79c:

  Linux 3.15-rc5 (2014-05-09 13:10:52 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

for you to fetch changes up to fa81511bb0bbb2b1aace3695ce869da9762624ff:

  x86-64, modify_ldt: Make support for 16-bit segments a runtime option (2014-05-14 16:33:54 -0700)

----------------------------------------------------------------
Anthony Iliopoulos (1):
      x86, mm, hugetlb: Add missing TLB page invalidation for hugetlb_cow()

H. Peter Anvin (1):
      x86, rdrand: When nordrand is specified, disable RDSEED as well

Linus Torvalds (1):
      x86-64, modify_ldt: Make support for 16-bit segments a runtime option

 Documentation/kernel-parameters.txt | 8 ++++----
 arch/x86/include/asm/hugetlb.h      | 1 +
 arch/x86/kernel/cpu/rdrand.c        | 1 +
 arch/x86/kernel/ldt.c               | 4 +++-
 arch/x86/vdso/vdso32-setup.c        | 8 ++++++++
 5 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 43842177b771..30a8ad0dae53 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2218,10 +2218,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	noreplace-smp	[X86-32,SMP] Don't replace SMP instructions
 			with UP alternatives
 
-	nordrand	[X86] Disable the direct use of the RDRAND
-			instruction even if it is supported by the
-			processor.  RDRAND is still available to user
-			space applications.
+	nordrand	[X86] Disable kernel use of the RDRAND and
+			RDSEED instructions even if they are supported
+			by the processor.  RDRAND and RDSEED are still
+			available to user space applications.
 
 	noresume	[SWSUSP] Disables resume and restores original swap
 			space.
diff --git a/arch/x86/include/asm/hugetlb.h b/arch/x86/include/asm/hugetlb.h
index a8091216963b..68c05398bba9 100644
--- a/arch/x86/include/asm/hugetlb.h
+++ b/arch/x86/include/asm/hugetlb.h
@@ -52,6 +52,7 @@ static inline pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
 static inline void huge_ptep_clear_flush(struct vm_area_struct *vma,
 					 unsigned long addr, pte_t *ptep)
 {
+	ptep_clear_flush(vma, addr, ptep);
 }
 
 static inline int huge_pte_none(pte_t pte)
diff --git a/arch/x86/kernel/cpu/rdrand.c b/arch/x86/kernel/cpu/rdrand.c
index 384df5105fbc..136ac74dee82 100644
--- a/arch/x86/kernel/cpu/rdrand.c
+++ b/arch/x86/kernel/cpu/rdrand.c
@@ -27,6 +27,7 @@
 static int __init x86_rdrand_setup(char *s)
 {
 	setup_clear_cpu_cap(X86_FEATURE_RDRAND);
+	setup_clear_cpu_cap(X86_FEATURE_RDSEED);
 	return 1;
 }
 __setup("nordrand", x86_rdrand_setup);
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
index 00348980a3a6..e1f220e3ca68 100644
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
 
