Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbaEBUP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 16:15:58 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:65153 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbaEBUPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 16:15:55 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v3 1/6] x86: Clean up 32-bit vs 64-bit vdso params
Date: Fri,  2 May 2014 13:15:43 -0700
Message-Id: <f1ec339c1cbc02d3e4a6747336ebffd79838962f.1399061075.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <cover.1399061075.git.luto@amacapital.net>
References: <cover.1399061075.git.luto@amacapital.net>
In-Reply-To: <cover.1399061075.git.luto@amacapital.net>
References: <cover.1399061075.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than using 'vdso_enabled' and an awful #define, just call the
parameters vdso32_enabled and vdso64_enabled.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/elf.h   | 20 +++++++++++++-------
 arch/x86/um/vdso/vma.c       |  2 +-
 arch/x86/vdso/vdso32-setup.c | 19 ++++++++-----------
 arch/x86/vdso/vma.c          |  6 +++---
 kernel/sysctl.c              |  5 +++++
 5 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 2c71182..e96df2c 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -75,7 +75,12 @@ typedef struct user_fxsr_struct elf_fpxregset_t;
 
 #include <asm/vdso.h>
 
-extern unsigned int vdso_enabled;
+#ifdef CONFIG_X86_64
+extern unsigned int vdso64_enabled;
+#endif
+#if defined(CONFIG_X86_32) || defined(CONFIG_COMPAT)
+extern unsigned int vdso32_enabled;
+#endif
 
 /*
  * This is used to ensure we don't load something for the wrong architecture.
@@ -269,9 +274,9 @@ extern int force_personality32;
 
 struct task_struct;
 
-#define	ARCH_DLINFO_IA32(vdso_enabled)					\
+#define	ARCH_DLINFO_IA32						\
 do {									\
-	if (vdso_enabled) {						\
+	if (vdso32_enabled) {						\
 		NEW_AUX_ENT(AT_SYSINFO,	VDSO_ENTRY);			\
 		NEW_AUX_ENT(AT_SYSINFO_EHDR, VDSO_CURRENT_BASE);	\
 	}								\
@@ -281,7 +286,7 @@ do {									\
 
 #define STACK_RND_MASK (0x7ff)
 
-#define ARCH_DLINFO		ARCH_DLINFO_IA32(vdso_enabled)
+#define ARCH_DLINFO		ARCH_DLINFO_IA32
 
 /* update AT_VECTOR_SIZE_ARCH if the number of NEW_AUX_ENT entries changes */
 
@@ -292,14 +297,15 @@ do {									\
 
 #define ARCH_DLINFO							\
 do {									\
-	if (vdso_enabled)						\
+	if (vdso64_enabled)						\
 		NEW_AUX_ENT(AT_SYSINFO_EHDR,				\
 			    (unsigned long)current->mm->context.vdso);	\
 } while (0)
 
+/* As a historical oddity, the x32 and x86_64 vDSOs are controlled together. */
 #define ARCH_DLINFO_X32							\
 do {									\
-	if (vdso_enabled)						\
+	if (vdso64_enabled)						\
 		NEW_AUX_ENT(AT_SYSINFO_EHDR,				\
 			    (unsigned long)current->mm->context.vdso);	\
 } while (0)
@@ -310,7 +316,7 @@ do {									\
 if (test_thread_flag(TIF_X32))						\
 	ARCH_DLINFO_X32;						\
 else									\
-	ARCH_DLINFO_IA32(sysctl_vsyscall32)
+	ARCH_DLINFO_IA32
 
 #define COMPAT_ELF_ET_DYN_BASE	(TASK_UNMAPPED_BASE + 0x1000000)
 
diff --git a/arch/x86/um/vdso/vma.c b/arch/x86/um/vdso/vma.c
index af91901..916cda4 100644
--- a/arch/x86/um/vdso/vma.c
+++ b/arch/x86/um/vdso/vma.c
@@ -12,7 +12,7 @@
 #include <asm/page.h>
 #include <linux/init.h>
 
-unsigned int __read_mostly vdso_enabled = 1;
+static unsigned int __read_mostly vdso_enabled = 1;
 unsigned long um_vdso_addr;
 
 extern unsigned long task_size;
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 0034898..5a657d9 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -37,7 +37,6 @@
 #endif
 
 #ifdef CONFIG_X86_64
-#define vdso_enabled			sysctl_vsyscall32
 #define arch_setup_additional_pages	syscall32_setup_pages
 #endif
 
@@ -45,13 +44,13 @@
  * Should the kernel map a VDSO page into processes and pass its
  * address down to glibc upon exec()?
  */
-unsigned int __read_mostly vdso_enabled = VDSO_DEFAULT;
+unsigned int __read_mostly vdso32_enabled = VDSO_DEFAULT;
 
-static int __init vdso_setup(char *s)
+static int __init vdso32_setup(char *s)
 {
-	vdso_enabled = simple_strtoul(s, NULL, 0);
+	vdso32_enabled = simple_strtoul(s, NULL, 0);
 
-	if (vdso_enabled > 1)
+	if (vdso32_enabled > 1)
 		pr_warn("vdso32 values other than 0 and 1 are no longer allowed; vdso disabled\n");
 
 	return 1;
@@ -62,12 +61,10 @@ static int __init vdso_setup(char *s)
  * behavior on both 64-bit and 32-bit kernels.
  * On 32-bit kernels, vdso=[012] means the same thing.
  */
-__setup("vdso32=", vdso_setup);
+__setup("vdso32=", vdso32_setup);
 
 #ifdef CONFIG_X86_32
-__setup_param("vdso=", vdso32_setup, vdso_setup, 0);
-
-EXPORT_SYMBOL_GPL(vdso_enabled);
+__setup_param("vdso=", vdso_setup, vdso32_setup, 0);
 #endif
 
 static struct page **vdso32_pages;
@@ -160,7 +157,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 		return x32_setup_additional_pages(bprm, uses_interp);
 #endif
 
-	if (vdso_enabled != 1)  /* Other values all mean "disabled" */
+	if (vdso32_enabled != 1)  /* Other values all mean "disabled" */
 		return 0;
 
 	down_write(&mm->mmap_sem);
@@ -244,7 +241,7 @@ subsys_initcall(sysenter_setup);
 static struct ctl_table abi_table2[] = {
 	{
 		.procname	= "vsyscall32",
-		.data		= &sysctl_vsyscall32,
+		.data		= &vdso32_enabled,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 1ad1026..8b79039 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -17,7 +17,7 @@
 #include <asm/page.h>
 
 #if defined(CONFIG_X86_64)
-unsigned int __read_mostly vdso_enabled = 1;
+unsigned int __read_mostly vdso64_enabled = 1;
 
 DECLARE_VDSO_IMAGE(vdso);
 extern unsigned short vdso_sync_cpuid;
@@ -160,7 +160,7 @@ static int setup_additional_pages(struct linux_binprm *bprm,
 	unsigned long addr;
 	int ret;
 
-	if (!vdso_enabled)
+	if (!vdso64_enabled)
 		return 0;
 
 	down_write(&mm->mmap_sem);
@@ -203,7 +203,7 @@ int x32_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 
 static __init int vdso_setup(char *s)
 {
-	vdso_enabled = simple_strtoul(s, NULL, 0);
+	vdso64_enabled = simple_strtoul(s, NULL, 0);
 	return 0;
 }
 __setup("vdso=", vdso_setup);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 74f5b58..420d77a 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1418,8 +1418,13 @@ static struct ctl_table vm_table[] = {
    (defined(CONFIG_SUPERH) && defined(CONFIG_VSYSCALL))
 	{
 		.procname	= "vdso_enabled",
+#ifdef CONFIG_X86_32
+		.data		= &vdso32_enabled,
+		.maxlen		= sizeof(vdso32_enabled),
+#else
 		.data		= &vdso_enabled,
 		.maxlen		= sizeof(vdso_enabled),
+#endif
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 		.extra1		= &zero,
-- 
1.9.0

