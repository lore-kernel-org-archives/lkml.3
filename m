Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254AbaICVUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:20:18 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:59094 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584AbaICVTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:19:30 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pinskia@gmail.com
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 17/24] ARM64: Add loading of ILP32 binaries
Date: Wed,  3 Sep 2014 14:19:11 -0700
Message-Id: <1409779158-30963-18-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1409779158-30963-1-git-send-email-apinski@cavium.com>
References: <1409779158-30963-1-git-send-email-apinski@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 arch/arm64/include/asm/elf.h |   59 +++++++++++++++++++++++++++++++++++------
 1 files changed, 50 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index 795dc9f..52083cd 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -16,6 +16,7 @@
 #ifndef __ASM_ELF_H
 #define __ASM_ELF_H
 
+#include <asm/errno.h>
 #include <asm/hwcap.h>
 
 /*
@@ -188,25 +189,26 @@ typedef compat_a32_elf_greg_t		compat_a32_elf_gregset_t[COMPAT_A32_ELF_NGREG];
 					 ((x)->e_flags & EF_ARM_EABI_MASK))
 
 #define compat_start_thread		compat_start_thread
-#define COMPAT_SET_PERSONALITY(ex)		\
+#define COMPAT_A32_SET_PERSONALITY(ex)		\
 do {						\
 	set_thread_flag(TIF_AARCH32);		\
 	set_thread_flag(TIF_32BIT);		\
 } while (0)
-#define COMPAT_ARCH_DLINFO
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
+static inline int aarch32_setup_vectors_page(struct linux_binprm *bprm,
+					     int uses_interp)
+{
+	return -EINVAL;
+}
 #endif
 
 /*
@@ -228,7 +230,46 @@ typedef compat_a32_elf_greg_t compat_elf_greg_t;
 typedef compat_a32_elf_gregset_t compat_elf_gregset_t;
 #endif
 
-#define compat_elf_check_arch(x)	compat_a32_elf_check_arch(x)
+#ifdef CONFIG_ARM64_ILP32
+#define compat_ilp32_elf_check_arch(x) ((x)->e_machine == EM_AARCH64)
+#define COMPAT_ILP32_SET_PERSONALITY(ex)	\
+do {						\
+	clear_thread_flag(TIF_AARCH32);		\
+	set_thread_flag(TIF_32BIT);		\
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

