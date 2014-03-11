Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbaCKAMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 20:12:37 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:52756 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbaCKAMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 20:12:35 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org
Cc: Stefani Seibold <stefani@seibold.net>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] x86: Remove compat vdso support
Date: Mon, 10 Mar 2014 17:12:31 -0700
Message-Id: <775280bd6cab6345a1d340e7038d2011763bf81b.1394492341.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compat vDSO is a complicated hack that's needed to maintain
compatibility with a small range of never-released glibc versions.

This removes it and replaces it with a much simpler hack: a config
option to disable the 32-bit vDSO by default.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

This applies to Linus' tree.  It does not apply to tip/x86/vdso (and IMO
if it's accepted then the 32-bit vDSO stuff should be rebased on top,
since a couple of the 32-bit vDSO changes will be unnecessary).

I've tested this lightly in 32-bit and 64-bit configurations.  It might
be nice to get this into -next to see what shakes loose.

The renaming of the config option is very much intentional --
CONFIG_COMPAT_VDSO currently defaults to y and I want everyone to
rethink their default, since I suspect that >99% of people using the
default are doing so incorrectly.

If something like this works, it has a major benefit: we never have to
think about the compat vDSO again :)

 Documentation/kernel-parameters.txt  |  11 +-
 arch/x86/Kconfig                     |  24 ++--
 arch/x86/include/asm/elf.h           |   4 -
 arch/x86/include/asm/fixmap.h        |   8 --
 arch/x86/include/asm/pgtable_types.h |   7 +-
 arch/x86/include/asm/vdso.h          |   5 +-
 arch/x86/vdso/vdso-layout.lds.S      |   2 +-
 arch/x86/vdso/vdso32-setup.c         | 234 ++++-------------------------------
 arch/x86/vdso/vdso32/vdso32.lds.S    |   2 -
 9 files changed, 48 insertions(+), 249 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7116fda..67d8e7b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3409,14 +3409,15 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 					of CONFIG_HIGHPTE.
 
 	vdso=		[X86,SH]
-			vdso=2: enable compat VDSO (default with COMPAT_VDSO)
-			vdso=1: enable VDSO (default)
+			On X86_32, this is an alias for vdso32=.  Otherwise:
+
+			vdso=1: enable VDSO (the default)
 			vdso=0: disable VDSO mapping
 
 	vdso32=		[X86]
-			vdso32=2: enable compat VDSO (default with COMPAT_VDSO)
-			vdso32=1: enable 32-bit VDSO (default)
-			vdso32=0: disable 32-bit VDSO mapping
+			vdso32=1: enable 32-bit VDSO (default if
+			                              ENABLE_VDSO32_BY_DEFAULT)
+			vdso32=0: disable 32-bit VDSO
 
 	vector=		[IA-64,SMP]
 			vector=percpu: enable percpu vector domain
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0af5250..e6c4cb0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1835,18 +1835,28 @@ config DEBUG_HOTPLUG_CPU0
 
 	  If unsure, say N.
 
-config COMPAT_VDSO
+config ENABLE_VDSO32_BY_DEFAULT
 	def_bool y
-	prompt "Compat VDSO support"
+	prompt "Enable the 32-bit vDSO by default"
 	depends on X86_32 || IA32_EMULATION
 	---help---
-	  Map the 32-bit VDSO to the predictable old-style address too.
+	  Certain buggy versions of glibc (those that support a vDSO but
+          do not include commit 49ad572a70b8aeb91e57483a11dd1b) will
+          crash if they are presented with a 32-bit vDSO that not mapped
+          at the address indicated in its segment table.
 
-	  Say N here if you are running a sufficiently recent glibc
-	  version (2.3.3 or later), to remove the high-mapped
-	  VDSO mapping and to exclusively use the randomized VDSO.
+	  There is no released version of glibc that has this problem.
+	  There may, however, be some Linux distributions circa 2004
+	  that include a buggy prerelease version of glibc.
 
-	  If unsure, say Y.
+	  While it is theoretically possible for the kernel to provide a
+	  usable vDSO for these versions of glibc, doing so is not
+	  currently supported.
+
+	  Disiabling this option will change the kernel's default to
+	  vdso32=0 to workaround the problem.  Doing so may cause a
+	  performance loss on all system calls.  Unless you have a buggy
+	  glibc, say Y.
 
 config CMDLINE_BOOL
 	bool "Built-in kernel command line"
diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 9c999c1..2c71182 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -281,16 +281,12 @@ do {									\
 
 #define STACK_RND_MASK (0x7ff)
 
-#define VDSO_HIGH_BASE		(__fix_to_virt(FIX_VDSO))
-
 #define ARCH_DLINFO		ARCH_DLINFO_IA32(vdso_enabled)
 
 /* update AT_VECTOR_SIZE_ARCH if the number of NEW_AUX_ENT entries changes */
 
 #else /* CONFIG_X86_32 */
 
-#define VDSO_HIGH_BASE		0xffffe000U /* CONFIG_COMPAT_VDSO address */
-
 /* 1GB for 64bit, 8MB for 32bit */
 #define STACK_RND_MASK (test_thread_flag(TIF_ADDR32) ? 0x7ff : 0x3fffff)
 
diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 7252cd3..2377f56 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -40,15 +40,8 @@
  */
 extern unsigned long __FIXADDR_TOP;
 #define FIXADDR_TOP	((unsigned long)__FIXADDR_TOP)
-
-#define FIXADDR_USER_START     __fix_to_virt(FIX_VDSO)
-#define FIXADDR_USER_END       __fix_to_virt(FIX_VDSO - 1)
 #else
 #define FIXADDR_TOP	(VSYSCALL_END-PAGE_SIZE)
-
-/* Only covers 32bit vsyscalls currently. Need another set for 64bit. */
-#define FIXADDR_USER_START	((unsigned long)VSYSCALL32_VSYSCALL)
-#define FIXADDR_USER_END	(FIXADDR_USER_START + PAGE_SIZE)
 #endif
 
 
@@ -74,7 +67,6 @@ extern unsigned long __FIXADDR_TOP;
 enum fixed_addresses {
 #ifdef CONFIG_X86_32
 	FIX_HOLE,
-	FIX_VDSO,
 #else
 	VSYSCALL_LAST_PAGE,
 	VSYSCALL_FIRST_PAGE = VSYSCALL_LAST_PAGE
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 1aa9ccd..943f166 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -214,13 +214,8 @@
 #ifdef CONFIG_X86_64
 #define __PAGE_KERNEL_IDENT_LARGE_EXEC	__PAGE_KERNEL_LARGE_EXEC
 #else
-/*
- * For PDE_IDENT_ATTR include USER bit. As the PDE and PTE protection
- * bits are combined, this will alow user to access the high address mapped
- * VDSO in the presence of CONFIG_COMPAT_VDSO
- */
 #define PTE_IDENT_ATTR	 0x003		/* PRESENT+RW */
-#define PDE_IDENT_ATTR	 0x067		/* PRESENT+RW+USER+DIRTY+ACCESSED */
+#define PDE_IDENT_ATTR	 0x063		/* PRESENT+RW+USER+DIRTY+ACCESSED */
 #define PGD_IDENT_ATTR	 0x001		/* PRESENT (no other attributes) */
 #endif
 
diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index fddb53d..5594e84 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -2,8 +2,6 @@
 #define _ASM_X86_VDSO_H
 
 #if defined CONFIG_X86_32 || defined CONFIG_COMPAT
-extern const char VDSO32_PRELINK[];
-
 /*
  * Given a pointer to the vDSO image, find the pointer to VDSO32_name
  * as that symbol is defined in the vDSO sources or linker script.
@@ -11,8 +9,7 @@ extern const char VDSO32_PRELINK[];
 #define VDSO32_SYMBOL(base, name)					\
 ({									\
 	extern const char VDSO32_##name[];				\
-	(void __user *)(VDSO32_##name - VDSO32_PRELINK +		\
-			(unsigned long)(base));				\
+	(void __user *)(VDSO32_##name + (unsigned long)(base));		\
 })
 #endif
 
diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index 634a2cf..8c550c1 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -6,7 +6,7 @@
 
 SECTIONS
 {
-	. = VDSO_PRELINK + SIZEOF_HEADERS;
+	. = SIZEOF_HEADERS;
 
 	.hash		: { *(.hash) }			:text
 	.gnu.hash	: { *(.gnu.hash) }
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index d6bfb87..4290ff7 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -26,16 +26,10 @@
 #include <asm/vdso.h>
 #include <asm/proto.h>
 
-enum {
-	VDSO_DISABLED = 0,
-	VDSO_ENABLED = 1,
-	VDSO_COMPAT = 2,
-};
-
-#ifdef CONFIG_COMPAT_VDSO
-#define VDSO_DEFAULT	VDSO_COMPAT
+#ifdef CONFIG_ENABLE_VDSO32_BY_DEFAULT
+#define VDSO_DEFAULT	1
 #else
-#define VDSO_DEFAULT	VDSO_ENABLED
+#define VDSO_DEFAULT	0
 #endif
 
 #ifdef CONFIG_X86_64
@@ -44,13 +38,6 @@ enum {
 #endif
 
 /*
- * This is the difference between the prelinked addresses in the vDSO images
- * and the VDSO_HIGH_BASE address where CONFIG_COMPAT_VDSO places the vDSO
- * in the user address space.
- */
-#define VDSO_ADDR_ADJUST	(VDSO_HIGH_BASE - (unsigned long)VDSO32_PRELINK)
-
-/*
  * Should the kernel map a VDSO page into processes and pass its
  * address down to glibc upon exec()?
  */
@@ -60,6 +47,9 @@ static int __init vdso_setup(char *s)
 {
 	vdso_enabled = simple_strtoul(s, NULL, 0);
 
+	if (vdso_enabled > 1)
+		printk(KERN_WARNING "vdso32 values other than 0 and 1 are no longer allowed; vdso disabled\n");
+
 	return 1;
 }
 
@@ -76,123 +66,6 @@ __setup_param("vdso=", vdso32_setup, vdso_setup, 0);
 EXPORT_SYMBOL_GPL(vdso_enabled);
 #endif
 
-static __init void reloc_symtab(Elf32_Ehdr *ehdr,
-				unsigned offset, unsigned size)
-{
-	Elf32_Sym *sym = (void *)ehdr + offset;
-	unsigned nsym = size / sizeof(*sym);
-	unsigned i;
-
-	for(i = 0; i < nsym; i++, sym++) {
-		if (sym->st_shndx == SHN_UNDEF ||
-		    sym->st_shndx == SHN_ABS)
-			continue;  /* skip */
-
-		if (sym->st_shndx > SHN_LORESERVE) {
-			printk(KERN_INFO "VDSO: unexpected st_shndx %x\n",
-			       sym->st_shndx);
-			continue;
-		}
-
-		switch(ELF_ST_TYPE(sym->st_info)) {
-		case STT_OBJECT:
-		case STT_FUNC:
-		case STT_SECTION:
-		case STT_FILE:
-			sym->st_value += VDSO_ADDR_ADJUST;
-		}
-	}
-}
-
-static __init void reloc_dyn(Elf32_Ehdr *ehdr, unsigned offset)
-{
-	Elf32_Dyn *dyn = (void *)ehdr + offset;
-
-	for(; dyn->d_tag != DT_NULL; dyn++)
-		switch(dyn->d_tag) {
-		case DT_PLTGOT:
-		case DT_HASH:
-		case DT_STRTAB:
-		case DT_SYMTAB:
-		case DT_RELA:
-		case DT_INIT:
-		case DT_FINI:
-		case DT_REL:
-		case DT_DEBUG:
-		case DT_JMPREL:
-		case DT_VERSYM:
-		case DT_VERDEF:
-		case DT_VERNEED:
-		case DT_ADDRRNGLO ... DT_ADDRRNGHI:
-			/* definitely pointers needing relocation */
-			dyn->d_un.d_ptr += VDSO_ADDR_ADJUST;
-			break;
-
-		case DT_ENCODING ... OLD_DT_LOOS-1:
-		case DT_LOOS ... DT_HIOS-1:
-			/* Tags above DT_ENCODING are pointers if
-			   they're even */
-			if (dyn->d_tag >= DT_ENCODING &&
-			    (dyn->d_tag & 1) == 0)
-				dyn->d_un.d_ptr += VDSO_ADDR_ADJUST;
-			break;
-
-		case DT_VERDEFNUM:
-		case DT_VERNEEDNUM:
-		case DT_FLAGS_1:
-		case DT_RELACOUNT:
-		case DT_RELCOUNT:
-		case DT_VALRNGLO ... DT_VALRNGHI:
-			/* definitely not pointers */
-			break;
-
-		case OLD_DT_LOOS ... DT_LOOS-1:
-		case DT_HIOS ... DT_VALRNGLO-1:
-		default:
-			if (dyn->d_tag > DT_ENCODING)
-				printk(KERN_INFO "VDSO: unexpected DT_tag %x\n",
-				       dyn->d_tag);
-			break;
-		}
-}
-
-static __init void relocate_vdso(Elf32_Ehdr *ehdr)
-{
-	Elf32_Phdr *phdr;
-	Elf32_Shdr *shdr;
-	int i;
-
-	BUG_ON(memcmp(ehdr->e_ident, ELFMAG, SELFMAG) != 0 ||
-	       !elf_check_arch_ia32(ehdr) ||
-	       ehdr->e_type != ET_DYN);
-
-	ehdr->e_entry += VDSO_ADDR_ADJUST;
-
-	/* rebase phdrs */
-	phdr = (void *)ehdr + ehdr->e_phoff;
-	for (i = 0; i < ehdr->e_phnum; i++) {
-		phdr[i].p_vaddr += VDSO_ADDR_ADJUST;
-
-		/* relocate dynamic stuff */
-		if (phdr[i].p_type == PT_DYNAMIC)
-			reloc_dyn(ehdr, phdr[i].p_offset);
-	}
-
-	/* rebase sections */
-	shdr = (void *)ehdr + ehdr->e_shoff;
-	for(i = 0; i < ehdr->e_shnum; i++) {
-		if (!(shdr[i].sh_flags & SHF_ALLOC))
-			continue;
-
-		shdr[i].sh_addr += VDSO_ADDR_ADJUST;
-
-		if (shdr[i].sh_type == SHT_SYMTAB ||
-		    shdr[i].sh_type == SHT_DYNSYM)
-			reloc_symtab(ehdr, shdr[i].sh_offset,
-				     shdr[i].sh_size);
-	}
-}
-
 static struct page *vdso32_pages[1];
 
 #ifdef CONFIG_X86_64
@@ -212,12 +85,6 @@ void syscall32_cpu_init(void)
 	wrmsrl(MSR_CSTAR, ia32_cstar_target);
 }
 
-#define compat_uses_vma		1
-
-static inline void map_compat_vdso(int map)
-{
-}
-
 #else  /* CONFIG_X86_32 */
 
 #define vdso32_sysenter()	(boot_cpu_has(X86_FEATURE_SEP))
@@ -241,37 +108,6 @@ void enable_sep_cpu(void)
 	put_cpu();	
 }
 
-static struct vm_area_struct gate_vma;
-
-static int __init gate_vma_init(void)
-{
-	gate_vma.vm_mm = NULL;
-	gate_vma.vm_start = FIXADDR_USER_START;
-	gate_vma.vm_end = FIXADDR_USER_END;
-	gate_vma.vm_flags = VM_READ | VM_MAYREAD | VM_EXEC | VM_MAYEXEC;
-	gate_vma.vm_page_prot = __P101;
-
-	return 0;
-}
-
-#define compat_uses_vma		0
-
-static void map_compat_vdso(int map)
-{
-	static int vdso_mapped;
-
-	if (map == vdso_mapped)
-		return;
-
-	vdso_mapped = map;
-
-	__set_fixmap(FIX_VDSO, page_to_pfn(vdso32_pages[0]) << PAGE_SHIFT,
-		     map ? PAGE_READONLY_EXEC : PAGE_NONE);
-
-	/* flush stray tlbs */
-	flush_tlb_all();
-}
-
 #endif	/* CONFIG_X86_64 */
 
 int __init sysenter_setup(void)
@@ -282,10 +118,6 @@ int __init sysenter_setup(void)
 
 	vdso32_pages[0] = virt_to_page(syscall_page);
 
-#ifdef CONFIG_X86_32
-	gate_vma_init();
-#endif
-
 	if (vdso32_syscall()) {
 		vsyscall = &vdso32_syscall_start;
 		vsyscall_len = &vdso32_syscall_end - &vdso32_syscall_start;
@@ -298,7 +130,6 @@ int __init sysenter_setup(void)
 	}
 
 	memcpy(syscall_page, vsyscall, vsyscall_len);
-	relocate_vdso(syscall_page);
 
 	return 0;
 }
@@ -309,48 +140,35 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	struct mm_struct *mm = current->mm;
 	unsigned long addr;
 	int ret = 0;
-	bool compat;
 
 #ifdef CONFIG_X86_X32_ABI
 	if (test_thread_flag(TIF_X32))
 		return x32_setup_additional_pages(bprm, uses_interp);
 #endif
 
-	if (vdso_enabled == VDSO_DISABLED)
+	if (vdso_enabled != 1)  /* Other values all mean "disabled" */
 		return 0;
 
 	down_write(&mm->mmap_sem);
 
-	/* Test compat mode once here, in case someone
-	   changes it via sysctl */
-	compat = (vdso_enabled == VDSO_COMPAT);
-
-	map_compat_vdso(compat);
-
-	if (compat)
-		addr = VDSO_HIGH_BASE;
-	else {
-		addr = get_unmapped_area(NULL, 0, PAGE_SIZE, 0, 0);
-		if (IS_ERR_VALUE(addr)) {
-			ret = addr;
-			goto up_fail;
-		}
+	addr = get_unmapped_area(NULL, 0, PAGE_SIZE, 0, 0);
+	if (IS_ERR_VALUE(addr)) {
+		ret = addr;
+		goto up_fail;
 	}
 
 	current->mm->context.vdso = (void *)addr;
 
-	if (compat_uses_vma || !compat) {
-		/*
-		 * MAYWRITE to allow gdb to COW and set breakpoints
-		 */
-		ret = install_special_mapping(mm, addr, PAGE_SIZE,
-					      VM_READ|VM_EXEC|
-					      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
-					      vdso32_pages);
-
-		if (ret)
-			goto up_fail;
-	}
+	/*
+	 * MAYWRITE to allow gdb to COW and set breakpoints
+	 */
+	ret = install_special_mapping(mm, addr, PAGE_SIZE,
+				      VM_READ|VM_EXEC|
+				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
+				      vdso32_pages);
+
+	if (ret)
+		goto up_fail;
 
 	current_thread_info()->sysenter_return =
 		VDSO32_SYMBOL(addr, SYSENTER_RETURN);
@@ -411,20 +229,12 @@ const char *arch_vma_name(struct vm_area_struct *vma)
 
 struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
 {
-	/*
-	 * Check to see if the corresponding task was created in compat vdso
-	 * mode.
-	 */
-	if (mm && mm->context.vdso == (void *)VDSO_HIGH_BASE)
-		return &gate_vma;
 	return NULL;
 }
 
 int in_gate_area(struct mm_struct *mm, unsigned long addr)
 {
-	const struct vm_area_struct *vma = get_gate_vma(mm);
-
-	return vma && addr >= vma->vm_start && addr < vma->vm_end;
+	return 0;
 }
 
 int in_gate_area_no_mm(unsigned long addr)
diff --git a/arch/x86/vdso/vdso32/vdso32.lds.S b/arch/x86/vdso/vdso32/vdso32.lds.S
index 976124b..90e7aa9 100644
--- a/arch/x86/vdso/vdso32/vdso32.lds.S
+++ b/arch/x86/vdso/vdso32/vdso32.lds.S
@@ -8,7 +8,6 @@
  * values visible using the asm-x86/vdso.h macros from the kernel proper.
  */
 
-#define VDSO_PRELINK 0
 #include "../vdso-layout.lds.S"
 
 /* The ELF entry point can be used to set the AT_SYSINFO value.  */
@@ -31,7 +30,6 @@ VERSION
 /*
  * Symbols we define here called VDSO* get their values into vdso32-syms.h.
  */
-VDSO32_PRELINK		= VDSO_PRELINK;
 VDSO32_vsyscall		= __kernel_vsyscall;
 VDSO32_sigreturn	= __kernel_sigreturn;
 VDSO32_rt_sigreturn	= __kernel_rt_sigreturn;
-- 
1.8.5.3

