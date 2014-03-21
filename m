Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964953AbaCUDW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 23:22:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59150 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758747AbaCUDWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 23:22:24 -0400
Date: Thu, 20 Mar 2014 20:21:40 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-9e6f450f946d35d585798da268d45c679632fe05@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, stefani@seibold.net, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, stefani@seibold.net, tglx@linutronix.de
In-Reply-To: <1df77311795aff75f5742c787d277518314a38d3.1395366931.git.luto@amacapital.net>
References: <1df77311795aff75f5742c787d277518314a38d3.1395366931.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso: Move more vdso definitions into vdso.h
Git-Commit-ID: 9e6f450f946d35d585798da268d45c679632fe05
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

Commit-ID:  9e6f450f946d35d585798da268d45c679632fe05
Gitweb:     http://git.kernel.org/tip/9e6f450f946d35d585798da268d45c679632fe05
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Thu, 20 Mar 2014 18:57:18 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 20 Mar 2014 20:20:08 -0700

x86, vdso: Move more vdso definitions into vdso.h

This fixes the Xen build and gets rid of a silly header file.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Cc: Stefani Seibold <stefani@seibold.net>
Link: http://lkml.kernel.org/r/1df77311795aff75f5742c787d277518314a38d3.1395366931.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/vdso.h  | 38 ++++++++++++++++++++++++++++++++++++++
 arch/x86/vdso/vdso.S         |  2 +-
 arch/x86/vdso/vdso32-setup.c |  7 -------
 arch/x86/vdso/vdso32.S       |  2 +-
 arch/x86/vdso/vdso_image.h   | 30 ------------------------------
 arch/x86/vdso/vdsox32.S      |  2 +-
 arch/x86/vdso/vma.c          |  1 -
 7 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index 0301d78..7622a65 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -1,10 +1,46 @@
 #ifndef _ASM_X86_VDSO_H
 #define _ASM_X86_VDSO_H
 
+#include <asm/page_types.h>
+#include <linux/linkage.h>
+
+#ifdef __ASSEMBLER__
+
+#define DEFINE_VDSO_IMAGE(symname, filename)				\
+__PAGE_ALIGNED_DATA ;							\
+	.globl symname##_start, symname##_end ;				\
+	.align PAGE_SIZE ;						\
+	symname##_start: ;						\
+	.incbin filename ;						\
+	symname##_end: ;						\
+	.align PAGE_SIZE /* extra data here leaks to userspace. */ ;	\
+									\
+.previous ;								\
+									\
+	.globl symname##_pages ;					\
+	.bss ;								\
+	.align 8 ;							\
+	.type symname##_pages, @object ;				\
+	symname##_pages: ;						\
+	.zero (symname##_end - symname##_start + PAGE_SIZE - 1) / PAGE_SIZE * (BITS_PER_LONG / 8) ; \
+	.size symname##_pages, .-symname##_pages
+
+#else
+
+#define DECLARE_VDSO_IMAGE(symname)				\
+	extern char symname##_start[], symname##_end[];		\
+	extern struct page *symname##_pages[]
+
 #if defined CONFIG_X86_32 || defined CONFIG_COMPAT
 
 #include <asm/vdso32.h>
 
+DECLARE_VDSO_IMAGE(vdso32_int80);
+#ifdef CONFIG_COMPAT
+DECLARE_VDSO_IMAGE(vdso32_syscall);
+#endif
+DECLARE_VDSO_IMAGE(vdso32_sysenter);
+
 extern const char VDSO32_PRELINK[];
 
 /*
@@ -27,4 +63,6 @@ extern void __user __kernel_rt_sigreturn;
 
 void __init patch_vdso32(void *vdso, size_t len);
 
+#endif /* __ASSEMBLER__ */
+
 #endif /* _ASM_X86_VDSO_H */
diff --git a/arch/x86/vdso/vdso.S b/arch/x86/vdso/vdso.S
index c749d15..be3f23b 100644
--- a/arch/x86/vdso/vdso.S
+++ b/arch/x86/vdso/vdso.S
@@ -1,3 +1,3 @@
-#include "vdso_image.h"
+#include <asm/vdso.h>
 
 DEFINE_VDSO_IMAGE(vdso, "arch/x86/vdso/vdso.so")
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index b45528e..791c1cb 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -29,7 +29,6 @@
 #include <asm/fixmap.h>
 #include <asm/hpet.h>
 #include <asm/vvar.h>
-#include "vdso_image.h"
 
 #ifdef CONFIG_COMPAT_VDSO
 #define VDSO_DEFAULT	0
@@ -42,12 +41,6 @@
 #define arch_setup_additional_pages	syscall32_setup_pages
 #endif
 
-DECLARE_VDSO_IMAGE(vdso32_int80);
-#ifdef CONFIG_COMPAT
-DECLARE_VDSO_IMAGE(vdso32_syscall);
-#endif
-DECLARE_VDSO_IMAGE(vdso32_sysenter);
-
 /*
  * Should the kernel map a VDSO page into processes and pass its
  * address down to glibc upon exec()?
diff --git a/arch/x86/vdso/vdso32.S b/arch/x86/vdso/vdso32.S
index cfa6add..018bcd9 100644
--- a/arch/x86/vdso/vdso32.S
+++ b/arch/x86/vdso/vdso32.S
@@ -1,4 +1,4 @@
-#include "vdso_image.h"
+#include <asm/vdso.h>
 
 DEFINE_VDSO_IMAGE(vdso32_int80, "arch/x86/vdso/vdso32-int80.so")
 
diff --git a/arch/x86/vdso/vdso_image.h b/arch/x86/vdso/vdso_image.h
deleted file mode 100644
index 1baa6bc..0000000
--- a/arch/x86/vdso/vdso_image.h
+++ /dev/null
@@ -1,30 +0,0 @@
-#ifndef _VDSO_IMAGE_H
-#define _VDSO_IMAGE_H
-
-#include <asm/page_types.h>
-#include <linux/linkage.h>
-
-#define DEFINE_VDSO_IMAGE(symname, filename)				\
-__PAGE_ALIGNED_DATA ;							\
-	.globl symname##_start, symname##_end ;				\
-	.align PAGE_SIZE ;						\
-	symname##_start: ;						\
-	.incbin filename ;						\
-	symname##_end: ;						\
-	.align PAGE_SIZE /* extra data here leaks to userspace. */ ;	\
-									\
-.previous ;								\
-									\
-	.globl symname##_pages ;					\
-	.bss ;								\
-	.align 8 ;							\
-	.type symname##_pages, @object ;				\
-	symname##_pages: ;						\
-	.zero (symname##_end - symname##_start + PAGE_SIZE - 1) / PAGE_SIZE * (BITS_PER_LONG / 8) ; \
-	.size symname##_pages, .-symname##_pages
-
-#define DECLARE_VDSO_IMAGE(symname)				\
-	extern char symname##_start[], symname##_end[];		\
-	extern struct page *symname##_pages[]
-
-#endif /* _VDSO_IMAGE_H */
diff --git a/arch/x86/vdso/vdsox32.S b/arch/x86/vdso/vdsox32.S
index 19a6927..f4aa34e 100644
--- a/arch/x86/vdso/vdsox32.S
+++ b/arch/x86/vdso/vdsox32.S
@@ -1,3 +1,3 @@
-#include "vdso_image.h"
+#include <asm/vdso.h>
 
 DEFINE_VDSO_IMAGE(vdsox32, "arch/x86/vdso/vdsox32.so")
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 6db0bbd..1ad1026 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -15,7 +15,6 @@
 #include <asm/proto.h>
 #include <asm/vdso.h>
 #include <asm/page.h>
-#include "vdso_image.h"
 
 #if defined(CONFIG_X86_64)
 unsigned int __read_mostly vdso_enabled = 1;
