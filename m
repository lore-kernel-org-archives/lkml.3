Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbaEXHDX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 03:03:23 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:61129 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaEXHC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 03:02:26 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 18/24] ARM64: Add loading of ILP32 binaries.
Date: Sat, 24 May 2014 00:02:13 -0700
Message-Id: <1400914939-9708-19-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1400914939-9708-1-git-send-email-apinski@cavium.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds loading of the ILP32 binary, we set/clear the TIF_32BIT_AARCH64 for each personality.  We also use the non-compat DLINFO and setup_additional_pages as ILP32 uses a vdso just like LP64.

After this patch the kernel can load and execute simple programs including a "Hello World" with shard libraries.

Thanks,
Andrew Pinski

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 arch/arm64/include/asm/elf.h |   66 +++++++++++++++++++++++++++++++++++------
 1 files changed, 56 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index 4106386..3f979b5 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -135,7 +135,11 @@ extern unsigned long randomize_et_dyn(unsigned long base);
  */
 #define ELF_PLAT_INIT(_r, load_addr)	(_r)->regs[0] = 0
 
-#define SET_PERSONALITY(ex)		clear_thread_flag(TIF_32BIT);
+#define SET_PERSONALITY(ex)			\
+do {						\
+	clear_thread_flag(TIF_32BIT_AARCH64);	\
+	clear_thread_flag(TIF_32BIT);		\
+} while (0)
 
 #define ARCH_DLINFO							\
 do {									\
@@ -185,25 +189,28 @@ typedef compat_a32_elf_greg_t		compat_a32_elf_gregset_t[COMPAT_A32_ELF_NGREG];
 					 ((x)->e_flags & EF_ARM_EABI_MASK))
 
 #define compat_start_thread		compat_start_thread
-#define COMPAT_SET_PERSONALITY(ex)	set_thread_flag(TIF_32BIT);
-#define COMPAT_ARCH_DLINFO
+#define COMPAT_A32_SET_PERSONALITY(ex)		\
+do {						\
+	clear_thread_flag(TIF_32BIT_AARCH64);	\
+	set_thread_flag(TIF_32BIT);		\
+} while (0)
+#define COMPAT_A32_ARCH_DLINFO		do {} while (0)
 
 
 extern int aarch32_setup_vectors_page(struct linux_binprm *bprm,
 				      int uses_interp);
-#define compat_arch_setup_additional_pages \
-					aarch32_setup_vectors_page
 
 #else
-
 typedef elf_greg_t			compat_elf_greg_t;
 typedef elf_gregset_t			compat_elf_gregset_t;
 #define compat_a32_elf_check_arch(x)	0
-#define COMPAT_SET_PERSONALITY(ex)
-#define COMPAT_ARCH_DLINFO
-
+#define COMPAT_A32_SET_PERSONALITY(ex)	do {} while (0)
+#define COMPAT_A32_ARCH_DLINFO		do {} while (0)
+#define aarch32_setup_vectors_page(x, y) -EINVAL
 #endif
 
+
+
 /* If ILP32 is turned on, we want to define the compat_elf_greg_t to the non compat
    one and define PR_REG_SIZE/PRSTATUS_SIZE/SET_PR_FPVALID so we pick up the correct
    ones for AARCH32. Note also the definition of the macros have to be correct for
@@ -222,7 +229,46 @@ typedef compat_a32_elf_greg_t compat_elf_greg_t;
 typedef compat_a32_elf_gregset_t compat_elf_gregset_t;
 #endif
 
-#define compat_elf_check_arch(x)	compat_a32_elf_check_arch(x)
+#ifdef CONFIG_ARM64_ILP32
+#define compat_ilp32_elf_check_arch(x) ((x)->e_machine == EM_AARCH64)
+#define COMPAT_ILP32_SET_PERSONALITY(ex)	\
+do {						\
+	set_thread_flag(TIF_32BIT_AARCH64);	\
+	clear_thread_flag(TIF_32BIT);		\
+} while (0)
+#define COMPAT_ILP32_ARCH_DLINFO					\
+do {									\
+	NEW_AUX_ENT(AT_SYSINFO_EHDR,					\
+		    (elf_addr_t)(long)current->mm->context.vdso);	\
+} while (0)
+#else
+#define compat_ilp32_elf_check_arch(x) 0
+#define COMPAT_ILP32_SET_PERSONALITY(ex)	do {} while (0)
+#define COMPAT_ILP32_ARCH_DLINFO		do {} while (0)
+#endif
+
+#define compat_elf_check_arch(x)	(compat_a32_elf_check_arch(x) || compat_ilp32_elf_check_arch(x))
+#define COMPAT_SET_PERSONALITY(ex)			\
+do {							\
+	if (compat_a32_elf_check_arch(&ex))		\
+		COMPAT_A32_SET_PERSONALITY(ex);		\
+	else						\
+		COMPAT_ILP32_SET_PERSONALITY(ex);	\
+} while (0)
+
+/* ILP32 uses the "LP64-like" vdso pages */
+#define compat_arch_setup_additional_pages	\
+	(is_a32_compat_task()			\
+	 ? &aarch32_setup_vectors_page		\
+	 : &(arch_setup_additional_pages))
+
+#define COMPAT_ARCH_DLINFO			\
+do {						\
+	if (is_a32_compat_task())		\
+		COMPAT_A32_ARCH_DLINFO;		\
+	else					\
+		COMPAT_ILP32_ARCH_DLINFO;	\
+} while (0)
 
 #endif /* CONFIG_COMPAT */
 
-- 
1.7.2.5

