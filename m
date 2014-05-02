Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbaEBUQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 16:16:05 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:46841 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbaEBUQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 16:16:02 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v3 4/6] x86: Move the 32-bit vdso special pages after the text
Date: Fri,  2 May 2014 13:15:46 -0700
Message-Id: <9191937b0a9c1548ad0dbddf872127073c1926aa.1399061075.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <cover.1399061075.git.luto@amacapital.net>
References: <cover.1399061075.git.luto@amacapital.net>
In-Reply-To: <cover.1399061075.git.luto@amacapital.net>
References: <cover.1399061075.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This unifies the vdso mapping code and teaches it how to map special
pages at addresses corresponding to symbols in the vdso image.  The
new code is used for all vdso variants, but so far only the 32-bit
variants use the new vvar page position.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/elf.h      |   8 +--
 arch/x86/include/asm/vdso.h     |   4 ++
 arch/x86/include/asm/vdso32.h   |  11 ----
 arch/x86/vdso/vdso-layout.lds.S |  42 ++++++++-----
 arch/x86/vdso/vdso2c.c          |  14 +++++
 arch/x86/vdso/vdso2c.h          |  17 ++++++
 arch/x86/vdso/vdso32-setup.c    | 115 +-----------------------------------
 arch/x86/vdso/vma.c             | 128 +++++++++++++++++++++++++++++++++-------
 8 files changed, 173 insertions(+), 166 deletions(-)
 delete mode 100644 arch/x86/include/asm/vdso32.h

diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 65b21bc..1a055c8 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -333,11 +333,9 @@ struct linux_binprm;
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
 extern int arch_setup_additional_pages(struct linux_binprm *bprm,
 				       int uses_interp);
-extern int x32_setup_additional_pages(struct linux_binprm *bprm,
-				      int uses_interp);
-
-extern int syscall32_setup_pages(struct linux_binprm *, int exstack);
-#define compat_arch_setup_additional_pages	syscall32_setup_pages
+extern int compat_arch_setup_additional_pages(struct linux_binprm *bprm,
+					      int uses_interp);
+#define compat_arch_setup_additional_pages compat_arch_setup_additional_pages
 
 extern unsigned long arch_randomize_brk(struct mm_struct *mm);
 #define arch_randomize_brk arch_randomize_brk
diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index 389fe2c..d0a2c90 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -14,6 +14,10 @@ struct vdso_image {
 
 	unsigned long alt, alt_len;
 
+	unsigned long sym_end_mapping;  /* Total size of the mapping */
+
+	unsigned long sym_vvar_page;
+	unsigned long sym_hpet_page;
 	unsigned long sym_VDSO32_NOTE_MASK;
 	unsigned long sym___kernel_sigreturn;
 	unsigned long sym___kernel_rt_sigreturn;
diff --git a/arch/x86/include/asm/vdso32.h b/arch/x86/include/asm/vdso32.h
deleted file mode 100644
index 7efb701..0000000
--- a/arch/x86/include/asm/vdso32.h
+++ /dev/null
@@ -1,11 +0,0 @@
-#ifndef _ASM_X86_VDSO32_H
-#define _ASM_X86_VDSO32_H
-
-#define VDSO_BASE_PAGE	0
-#define VDSO_VVAR_PAGE	1
-#define VDSO_HPET_PAGE	2
-#define VDSO_PAGES	3
-#define VDSO_PREV_PAGES	2
-#define VDSO_OFFSET(x)	((x) * PAGE_SIZE)
-
-#endif
diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index 9df017a..e177c08 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -1,3 +1,5 @@
+#include <asm/vdso.h>
+
 /*
  * Linker script for vDSO.  This is an ELF shared object prelinked to
  * its virtual address, and with only one read-only segment.
@@ -6,20 +8,6 @@
 
 SECTIONS
 {
-#ifdef BUILD_VDSO32
-#include <asm/vdso32.h>
-
-	hpet_page = . - VDSO_OFFSET(VDSO_HPET_PAGE);
-
-	vvar = . - VDSO_OFFSET(VDSO_VVAR_PAGE);
-
-	/* Place all vvars at the offsets in asm/vvar.h. */
-#define EMIT_VVAR(name, offset) vvar_ ## name = vvar + offset;
-#define __VVAR_KERNEL_LDS
-#include <asm/vvar.h>
-#undef __VVAR_KERNEL_LDS
-#undef EMIT_VVAR
-#endif
 	. = SIZEOF_HEADERS;
 
 	.hash		: { *(.hash) }			:text
@@ -59,11 +47,33 @@ SECTIONS
 
 	.text		: { *(.text*) }			:text	=0x90909090,
 
+#ifdef BUILD_VDSO32
 	/*
-	 * The comma above works around a bug in gold:
-	 * https://sourceware.org/bugzilla/show_bug.cgi?id=16804
+	 * The remainder of the vDSO consists of special pages that are
+	 * shared between the kernel and userspace.  It needs to be at the
+	 * end so that it doesn't overlap the mapping of the actual
+	 * vDSO image.
 	 */
 
+	. = ALIGN(PAGE_SIZE);
+	vvar_page = .;
+
+	/* Place all vvars at the offsets in asm/vvar.h. */
+#define EMIT_VVAR(name, offset) vvar_ ## name = vvar_page + offset;
+#define __VVAR_KERNEL_LDS
+#include <asm/vvar.h>
+#undef __VVAR_KERNEL_LDS
+#undef EMIT_VVAR
+
+	. = vvar_page + PAGE_SIZE;
+
+	hpet_page = .;
+	. = . + PAGE_SIZE;
+#endif
+
+	. = ALIGN(PAGE_SIZE);
+	end_mapping = .;
+
 	/DISCARD/ : {
 		*(.discard)
 		*(.discard.*)
diff --git a/arch/x86/vdso/vdso2c.c b/arch/x86/vdso/vdso2c.c
index 976e8e4..81edd1e 100644
--- a/arch/x86/vdso/vdso2c.c
+++ b/arch/x86/vdso/vdso2c.c
@@ -15,7 +15,21 @@
 #include <linux/types.h>
 
 /* Symbols that we need in vdso2c. */
+enum {
+	sym_vvar_page,
+	sym_hpet_page,
+	sym_end_mapping,
+};
+
+const int special_pages[] = {
+	sym_vvar_page,
+	sym_hpet_page,
+};
+
 char const * const required_syms[] = {
+	[sym_vvar_page] = "vvar_page",
+	[sym_hpet_page] = "hpet_page",
+	[sym_end_mapping] = "end_mapping",
 	"VDSO32_NOTE_MASK",
 	"VDSO32_SYSENTER_RETURN",
 	"__kernel_vsyscall",
diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
index 9276e52..ed2e894 100644
--- a/arch/x86/vdso/vdso2c.h
+++ b/arch/x86/vdso/vdso2c.h
@@ -87,6 +87,23 @@ static int GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 		}
 	}
 
+	/* Validate mapping addresses. */
+	for (i = 0; i < sizeof(special_pages) / sizeof(special_pages[0]); i++) {
+		if (!syms[i])
+			continue;  /* The mapping isn't used; ignore it. */
+
+		if (syms[i] % 4096)
+			fail("%s must be a multiple of 4096\n",
+			     required_syms[i]);
+		if (syms[i] < data_size)
+			fail("%s must be after the text mapping\n",
+			     required_syms[i]);
+		if (syms[sym_end_mapping] < syms[i] + 4096)
+			fail("%s overruns end_mapping\n", required_syms[i]);
+	}
+	if (syms[sym_end_mapping] % 4096)
+		fail("end_mapping must be a multiple of 4096\n");
+
 	/* Remove sections. */
 	hdr->e_shoff = 0;
 	hdr->e_shentsize = 0;
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index d414601..c3ed708 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -8,28 +8,12 @@
 
 #include <linux/init.h>
 #include <linux/smp.h>
-#include <linux/thread_info.h>
-#include <linux/sched.h>
-#include <linux/gfp.h>
-#include <linux/string.h>
-#include <linux/elf.h>
-#include <linux/mm.h>
-#include <linux/err.h>
-#include <linux/module.h>
-#include <linux/slab.h>
+#include <linux/kernel.h>
+#include <linux/mm_types.h>
 
 #include <asm/cpufeature.h>
-#include <asm/msr.h>
-#include <asm/pgtable.h>
-#include <asm/unistd.h>
-#include <asm/elf.h>
-#include <asm/tlbflush.h>
+#include <asm/processor.h>
 #include <asm/vdso.h>
-#include <asm/proto.h>
-#include <asm/fixmap.h>
-#include <asm/hpet.h>
-#include <asm/vvar.h>
-#include <asm/vdso32.h>
 
 #ifdef CONFIG_COMPAT_VDSO
 #define VDSO_DEFAULT	0
@@ -37,10 +21,6 @@
 #define VDSO_DEFAULT	1
 #endif
 
-#ifdef CONFIG_X86_64
-#define arch_setup_additional_pages	syscall32_setup_pages
-#endif
-
 /*
  * Should the kernel map a VDSO page into processes and pass its
  * address down to glibc upon exec()?
@@ -101,95 +81,6 @@ int __init sysenter_setup(void)
 	return 0;
 }
 
-/* Setup a VMA at program startup for the vsyscall page */
-int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
-{
-	struct mm_struct *mm = current->mm;
-	unsigned long addr;
-	int ret = 0;
-	struct vm_area_struct *vma;
-	unsigned long vdso32_size = selected_vdso32->size;
-
-#ifdef CONFIG_X86_X32_ABI
-	if (test_thread_flag(TIF_X32))
-		return x32_setup_additional_pages(bprm, uses_interp);
-#endif
-
-	if (vdso32_enabled != 1)  /* Other values all mean "disabled" */
-		return 0;
-
-	down_write(&mm->mmap_sem);
-
-	addr = get_unmapped_area(NULL, 0, vdso32_size + VDSO_OFFSET(VDSO_PREV_PAGES), 0, 0);
-	if (IS_ERR_VALUE(addr)) {
-		ret = addr;
-		goto up_fail;
-	}
-
-	addr += VDSO_OFFSET(VDSO_PREV_PAGES);
-
-	current->mm->context.vdso = (void __user *)addr;
-
-	/*
-	 * MAYWRITE to allow gdb to COW and set breakpoints
-	 */
-	ret = install_special_mapping(mm,
-			addr,
-			vdso32_size,
-			VM_READ|VM_EXEC|
-			VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
-			selected_vdso32->pages);
-
-	if (ret)
-		goto up_fail;
-
-	vma = _install_special_mapping(mm,
-			addr -  VDSO_OFFSET(VDSO_PREV_PAGES),
-			VDSO_OFFSET(VDSO_PREV_PAGES),
-			VM_READ,
-			NULL);
-
-	if (IS_ERR(vma)) {
-		ret = PTR_ERR(vma);
-		goto up_fail;
-	}
-
-	ret = remap_pfn_range(vma,
-		addr - VDSO_OFFSET(VDSO_VVAR_PAGE),
-		__pa_symbol(&__vvar_page) >> PAGE_SHIFT,
-		PAGE_SIZE,
-		PAGE_READONLY);
-
-	if (ret)
-		goto up_fail;
-
-#ifdef CONFIG_HPET_TIMER
-	if (hpet_address) {
-		ret = io_remap_pfn_range(vma,
-			addr - VDSO_OFFSET(VDSO_HPET_PAGE),
-			hpet_address >> PAGE_SHIFT,
-			PAGE_SIZE,
-			pgprot_noncached(PAGE_READONLY));
-
-		if (ret)
-			goto up_fail;
-	}
-#endif
-
-	if (selected_vdso32->sym_VDSO32_SYSENTER_RETURN)
-		current_thread_info()->sysenter_return =
-			current->mm->context.vdso +
-			selected_vdso32->sym_VDSO32_SYSENTER_RETURN;
-
-  up_fail:
-	if (ret)
-		current->mm->context.vdso = NULL;
-
-	up_write(&mm->mmap_sem);
-
-	return ret;
-}
-
 #ifdef CONFIG_X86_64
 
 subsys_initcall(sysenter_setup);
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index cf21762..e915eae 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -15,6 +15,7 @@
 #include <asm/proto.h>
 #include <asm/vdso.h>
 #include <asm/page.h>
+#include <asm/hpet.h>
 
 #if defined(CONFIG_X86_64)
 unsigned int __read_mostly vdso64_enabled = 1;
@@ -36,7 +37,6 @@ void __init init_vdso_image(const struct vdso_image *image)
 						image->alt_len));
 }
 
-
 #if defined(CONFIG_X86_64)
 static int __init init_vdso(void)
 {
@@ -49,13 +49,16 @@ static int __init init_vdso(void)
 	return 0;
 }
 subsys_initcall(init_vdso);
+#endif
 
 struct linux_binprm;
 
 /* Put the vdso above the (randomized) stack with another randomized offset.
    This way there is no hole in the middle of address space.
    To save memory make sure it is still in the same PTE as the stack top.
-   This doesn't give that many random bits */
+   This doesn't give that many random bits.
+
+   Only used for the 64-bit and x32 vdsos. */
 static unsigned long vdso_addr(unsigned long start, unsigned len)
 {
 	unsigned long addr, end;
@@ -81,23 +84,23 @@ static unsigned long vdso_addr(unsigned long start, unsigned len)
 	return addr;
 }
 
-/* Setup a VMA at program startup for the vsyscall page.
-   Not called for compat tasks */
-static int setup_additional_pages(struct linux_binprm *bprm,
-				  int uses_interp,
-				  struct page **pages,
-				  unsigned size)
+static int map_vdso(const struct vdso_image *image, bool calculate_addr)
 {
 	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma;
 	unsigned long addr;
-	int ret;
+	int ret = 0;
 
-	if (!vdso64_enabled)
-		return 0;
+	if (calculate_addr) {
+		addr = vdso_addr(current->mm->start_stack,
+				 image->sym_end_mapping);
+	} else {
+		addr = 0;
+	}
 
 	down_write(&mm->mmap_sem);
-	addr = vdso_addr(mm->start_stack, size);
-	addr = get_unmapped_area(NULL, addr, size, 0, 0);
+
+	addr = get_unmapped_area(NULL, addr, image->sym_end_mapping, 0, 0);
 	if (IS_ERR_VALUE(addr)) {
 		ret = addr;
 		goto up_fail;
@@ -105,34 +108,115 @@ static int setup_additional_pages(struct linux_binprm *bprm,
 
 	current->mm->context.vdso = (void __user *)addr;
 
-	ret = install_special_mapping(mm, addr, size,
+	/*
+	 * MAYWRITE to allow gdb to COW and set breakpoints
+	 */
+	ret = install_special_mapping(mm,
+				      addr,
+				      image->size,
 				      VM_READ|VM_EXEC|
 				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
-				      pages);
-	if (ret) {
-		current->mm->context.vdso = NULL;
+				      image->pages);
+
+	if (ret)
+		goto up_fail;
+
+	vma = _install_special_mapping(mm,
+				       addr + image->size,
+				       image->sym_end_mapping - image->size,
+				       VM_READ,
+				       NULL);
+
+	if (IS_ERR(vma)) {
+		ret = PTR_ERR(vma);
 		goto up_fail;
 	}
 
+	if (image->sym_vvar_page)
+		ret = remap_pfn_range(vma,
+				      addr + image->sym_vvar_page,
+				      __pa_symbol(&__vvar_page) >> PAGE_SHIFT,
+				      PAGE_SIZE,
+				      PAGE_READONLY);
+
+	if (ret)
+		goto up_fail;
+
+#ifdef CONFIG_HPET_TIMER
+	if (hpet_address && image->sym_hpet_page) {
+		ret = io_remap_pfn_range(vma,
+			addr + image->sym_hpet_page,
+			hpet_address >> PAGE_SHIFT,
+			PAGE_SIZE,
+			pgprot_noncached(PAGE_READONLY));
+
+		if (ret)
+			goto up_fail;
+	}
+#endif
+
 up_fail:
+	if (ret)
+		current->mm->context.vdso = NULL;
+
 	up_write(&mm->mmap_sem);
 	return ret;
 }
 
+#if defined(CONFIG_X86_32) || defined(CONFIG_COMPAT)
+static int load_vdso32(void)
+{
+	int ret;
+
+	if (vdso32_enabled != 1)  /* Other values all mean "disabled" */
+		return 0;
+
+	ret = map_vdso(selected_vdso32, false);
+	if (ret)
+		return ret;
+
+	if (selected_vdso32->sym_VDSO32_SYSENTER_RETURN)
+		current_thread_info()->sysenter_return =
+			current->mm->context.vdso +
+			selected_vdso32->sym_VDSO32_SYSENTER_RETURN;
+
+	return 0;
+}
+#endif
+
+#ifdef CONFIG_X86_64
 int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 {
-	return setup_additional_pages(bprm, uses_interp, vdso_image_64.pages,
-				      vdso_image_64.size);
+	if (!vdso64_enabled)
+		return 0;
+
+	return map_vdso(&vdso_image_64, true);
 }
 
+#ifdef CONFIG_COMPAT
+int compat_arch_setup_additional_pages(struct linux_binprm *bprm,
+				       int uses_interp)
+{
 #ifdef CONFIG_X86_X32_ABI
-int x32_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
+	if (test_thread_flag(TIF_X32)) {
+		if (!vdso64_enabled)
+			return 0;
+
+		return map_vdso(&vdso_image_x32, true);
+	}
+#endif
+
+	return load_vdso32();
+}
+#endif
+#else
+int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 {
-	return setup_additional_pages(bprm, uses_interp, vdso_image_x32.pages,
-				      vdso_image_x32.size);
+	return load_vdso32();
 }
 #endif
 
+#ifdef CONFIG_X86_64
 static __init int vdso_setup(char *s)
 {
 	vdso64_enabled = simple_strtoul(s, NULL, 0);
-- 
1.9.0

