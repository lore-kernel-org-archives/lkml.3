Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759860AbaCTWBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 18:01:30 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:50475 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758484AbaCTWB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 18:01:28 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Stefani Seibold <stefani@seibold.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] x86: Load the 32-bit vdso in place, just like the 64-bit vdsos
Date: Thu, 20 Mar 2014 15:01:21 -0700
Message-Id: <b8093933fad09ce181edb08a61dcd5d2592e9814.1395352498.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <CALCETrWR-2DpSorAaQpru5u9igNXCqP66=43a+_bRs3F0q8KOA@mail.gmail.com>
References: <CALCETrWR-2DpSorAaQpru5u9igNXCqP66=43a+_bRs3F0q8KOA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This replaces a decent amount of incomprehensible and buggy code
with much more straightforward code.  It also brings the 32-bit vdso
more in line with the 64-bit vdsos, so maybe someday they can share
even more code.

This wastes a small amount of kernel .data and .text space, but it
avoids a couple of allocations on startup, so it should be more or
less a wash memory-wise.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/vdso.h  |  8 -------
 arch/x86/vdso/vdso.S         | 22 ++-----------------
 arch/x86/vdso/vdso32-setup.c | 50 +++++++++++++++++++++++++-------------------
 arch/x86/vdso/vdso32.S       | 21 ++++---------------
 arch/x86/vdso/vdso_image.h   | 30 ++++++++++++++++++++++++++
 arch/x86/vdso/vdsox32.S      | 22 ++-----------------
 arch/x86/vdso/vma.c          |  8 +++----
 7 files changed, 70 insertions(+), 91 deletions(-)
 create mode 100644 arch/x86/vdso/vdso_image.h

diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index bde4359..0301d78 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -25,14 +25,6 @@ extern const char VDSO32_PRELINK[];
 extern void __user __kernel_sigreturn;
 extern void __user __kernel_rt_sigreturn;
 
-/*
- * These symbols are defined by vdso32.S to mark the bounds
- * of the ELF DSO images included therein.
- */
-extern const char vdso32_int80_start, vdso32_int80_end;
-extern const char vdso32_syscall_start, vdso32_syscall_end;
-extern const char vdso32_sysenter_start, vdso32_sysenter_end;
-
 void __init patch_vdso32(void *vdso, size_t len);
 
 #endif /* _ASM_X86_VDSO_H */
diff --git a/arch/x86/vdso/vdso.S b/arch/x86/vdso/vdso.S
index 1e13eb8..c749d15 100644
--- a/arch/x86/vdso/vdso.S
+++ b/arch/x86/vdso/vdso.S
@@ -1,21 +1,3 @@
-#include <asm/page_types.h>
-#include <linux/linkage.h>
+#include "vdso_image.h"
 
-__PAGE_ALIGNED_DATA
-
-	.globl vdso_start, vdso_end
-	.align PAGE_SIZE
-vdso_start:
-	.incbin "arch/x86/vdso/vdso.so"
-vdso_end:
-	.align PAGE_SIZE /* extra data here leaks to userspace. */
-
-.previous
-
-	.globl vdso_pages
-	.bss
-	.align 8
-	.type vdso_pages, @object
-vdso_pages:
-	.zero (vdso_end - vdso_start + PAGE_SIZE - 1) / PAGE_SIZE * 8
-	.size vdso_pages, .-vdso_pages
+DEFINE_VDSO_IMAGE(vdso, "arch/x86/vdso/vdso.so")
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 5b4aaef..b45528e 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -29,6 +29,7 @@
 #include <asm/fixmap.h>
 #include <asm/hpet.h>
 #include <asm/vvar.h>
+#include "vdso_image.h"
 
 #ifdef CONFIG_COMPAT_VDSO
 #define VDSO_DEFAULT	0
@@ -41,6 +42,12 @@
 #define arch_setup_additional_pages	syscall32_setup_pages
 #endif
 
+DECLARE_VDSO_IMAGE(vdso32_int80);
+#ifdef CONFIG_COMPAT
+DECLARE_VDSO_IMAGE(vdso32_syscall);
+#endif
+DECLARE_VDSO_IMAGE(vdso32_sysenter);
+
 /*
  * Should the kernel map a VDSO page into processes and pass its
  * address down to glibc upon exec()?
@@ -71,7 +78,7 @@ EXPORT_SYMBOL_GPL(vdso_enabled);
 #endif
 
 static struct page **vdso32_pages;
-static unsigned int vdso32_size;
+static unsigned vdso32_size;
 
 #ifdef CONFIG_X86_64
 
@@ -117,31 +124,32 @@ void enable_sep_cpu(void)
 
 int __init sysenter_setup(void)
 {
-	void *vdso_pages;
-	const void *vdso;
-	size_t vdso_len;
-	unsigned int i;
+	char *vdso32_start, *vdso32_end;
+	int npages, i;
 
+#ifdef CONFIG_COMPAT
 	if (vdso32_syscall()) {
-		vdso = &vdso32_syscall_start;
-		vdso_len = &vdso32_syscall_end - &vdso32_syscall_start;
-	} else if (vdso32_sysenter()){
-		vdso = &vdso32_sysenter_start;
-		vdso_len = &vdso32_sysenter_end - &vdso32_sysenter_start;
+		vdso32_start = vdso32_syscall_start;
+		vdso32_end = vdso32_syscall_end;
+		vdso32_pages = vdso32_syscall_pages;
+	} else
+#endif
+	if (vdso32_sysenter()) {
+		vdso32_start = vdso32_sysenter_start;
+		vdso32_end = vdso32_sysenter_end;
+		vdso32_pages = vdso32_sysenter_pages;
 	} else {
-		vdso = &vdso32_int80_start;
-		vdso_len = &vdso32_int80_end - &vdso32_int80_start;
+		vdso32_start = vdso32_int80_start;
+		vdso32_end = vdso32_int80_end;
+		vdso32_pages = vdso32_int80_pages;
 	}
 
-	vdso32_size = (vdso_len + PAGE_SIZE - 1) / PAGE_SIZE;
-	vdso32_pages = kmalloc(sizeof(*vdso32_pages) * vdso32_size, GFP_ATOMIC);
-	vdso_pages = kmalloc(VDSO_OFFSET(vdso32_size), GFP_ATOMIC);
-
-	for(i = 0; i != vdso32_size; ++i)
-		vdso32_pages[i] = virt_to_page(vdso_pages + VDSO_OFFSET(i));
+	npages = ((vdso32_end - vdso32_start) + PAGE_SIZE - 1) / PAGE_SIZE;
+	vdso32_size = npages << PAGE_SHIFT;
+	for (i = 0; i < npages; i++)
+		vdso32_pages[i] = virt_to_page(vdso32_start + i*PAGE_SIZE);
 
-	memcpy(vdso_pages, vdso, vdso_len);
-	patch_vdso32(vdso_pages, vdso_len);
+	patch_vdso32(vdso32_start, vdso32_size);
 
 	return 0;
 }
@@ -177,7 +185,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	 */
 	ret = install_special_mapping(mm,
 			addr,
-			VDSO_OFFSET(vdso32_size),
+			vdso32_size,
 			VM_READ|VM_EXEC|
 			VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
 			vdso32_pages);
diff --git a/arch/x86/vdso/vdso32.S b/arch/x86/vdso/vdso32.S
index 2ce5f82..cfa6add 100644
--- a/arch/x86/vdso/vdso32.S
+++ b/arch/x86/vdso/vdso32.S
@@ -1,22 +1,9 @@
-#include <linux/init.h>
+#include "vdso_image.h"
 
-__INITDATA
+DEFINE_VDSO_IMAGE(vdso32_int80, "arch/x86/vdso/vdso32-int80.so")
 
-	.globl vdso32_int80_start, vdso32_int80_end
-vdso32_int80_start:
-	.incbin "arch/x86/vdso/vdso32-int80.so"
-vdso32_int80_end:
-
-	.globl vdso32_syscall_start, vdso32_syscall_end
-vdso32_syscall_start:
 #ifdef CONFIG_COMPAT
-	.incbin "arch/x86/vdso/vdso32-syscall.so"
+DEFINE_VDSO_IMAGE(vdso32_syscall, "arch/x86/vdso/vdso32-syscall.so")
 #endif
-vdso32_syscall_end:
-
-	.globl vdso32_sysenter_start, vdso32_sysenter_end
-vdso32_sysenter_start:
-	.incbin "arch/x86/vdso/vdso32-sysenter.so"
-vdso32_sysenter_end:
 
-__FINIT
+DEFINE_VDSO_IMAGE(vdso32_sysenter, "arch/x86/vdso/vdso32-sysenter.so")
diff --git a/arch/x86/vdso/vdso_image.h b/arch/x86/vdso/vdso_image.h
new file mode 100644
index 0000000..1baa6bc
--- /dev/null
+++ b/arch/x86/vdso/vdso_image.h
@@ -0,0 +1,30 @@
+#ifndef _VDSO_IMAGE_H
+#define _VDSO_IMAGE_H
+
+#include <asm/page_types.h>
+#include <linux/linkage.h>
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
+#define DECLARE_VDSO_IMAGE(symname)				\
+	extern char symname##_start[], symname##_end[];		\
+	extern struct page *symname##_pages[]
+
+#endif /* _VDSO_IMAGE_H */
diff --git a/arch/x86/vdso/vdsox32.S b/arch/x86/vdso/vdsox32.S
index 295f1c7..19a6927 100644
--- a/arch/x86/vdso/vdsox32.S
+++ b/arch/x86/vdso/vdsox32.S
@@ -1,21 +1,3 @@
-#include <asm/page_types.h>
-#include <linux/linkage.h>
+#include "vdso_image.h"
 
-__PAGE_ALIGNED_DATA
-
-	.globl vdsox32_start, vdsox32_end
-	.align PAGE_SIZE
-vdsox32_start:
-	.incbin "arch/x86/vdso/vdsox32.so"
-vdsox32_end:
-	.align PAGE_SIZE /* extra data here leaks to userspace. */
-
-.previous
-
-	.globl vdsox32_pages
-	.bss
-	.align 8
-	.type vdsox32_pages, @object
-vdsox32_pages:
-	.zero (vdsox32_end - vdsox32_start + PAGE_SIZE - 1) / PAGE_SIZE * 8
-	.size vdsox32_pages, .-vdsox32_pages
+DEFINE_VDSO_IMAGE(vdsox32, "arch/x86/vdso/vdsox32.so")
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 7345bc9..6db0bbd 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -15,19 +15,17 @@
 #include <asm/proto.h>
 #include <asm/vdso.h>
 #include <asm/page.h>
+#include "vdso_image.h"
 
 #if defined(CONFIG_X86_64)
 unsigned int __read_mostly vdso_enabled = 1;
 
-extern char vdso_start[], vdso_end[];
+DECLARE_VDSO_IMAGE(vdso);
 extern unsigned short vdso_sync_cpuid;
-
-extern struct page *vdso_pages[];
 static unsigned vdso_size;
 
 #ifdef CONFIG_X86_X32_ABI
-extern char vdsox32_start[], vdsox32_end[];
-extern struct page *vdsox32_pages[];
+DECLARE_VDSO_IMAGE(vdsox32);
 static unsigned vdsox32_size;
 #endif
 #endif
-- 
1.8.5.3

