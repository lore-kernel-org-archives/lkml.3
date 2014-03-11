Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbaCKVdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 17:33:16 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:64060 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbaCKVdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 17:33:14 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org
Cc: Stefani Seibold <stefani@seibold.net>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] x86: Dynamically relocate the compat vdso
Date: Tue, 11 Mar 2014 14:33:09 -0700
Message-Id: <7708c7e74155af17548b3737de81495888685760.1394573523.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the compat vdso from the fixmap and instead relocates
it each time it's mapped.  It also documents the reason for the
compat vDSO.

Before this patch, using the compat vDSO partially defeated ASLR.
With this patch, ASLR is left alone, but starting a 32-bit process
with the compat vDSO enabled takes slightly longer and consumes one
additional page of memory.

IMO this makes the code cleaner.  There are currently two separate
code paths to set up the 32-bit vDSO depending on the compat
setting.  This removes the fixmap version.

The main observable effect should be that CONFIG_COMPAT_VDSO users
get an extra line in their kernel log at startup.  Perhaps a few
of them will stop using CONFIG_COMPAT_VDSO as a result.

This does not actually add support for vDSO images >4k, but it
will make it much easier to do so in the future.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 Documentation/kernel-parameters.txt  |  18 +++-
 arch/x86/Kconfig                     |  24 +++--
 arch/x86/include/asm/elf.h           |   4 -
 arch/x86/include/asm/fixmap.h        |   8 --
 arch/x86/include/asm/pgtable_types.h |   7 +-
 arch/x86/include/asm/vdso.h          |   5 +-
 arch/x86/vdso/vdso-layout.lds.S      |   2 +-
 arch/x86/vdso/vdso32-setup.c         | 173 ++++++++++++++++-------------------
 arch/x86/vdso/vdso32/vdso32.lds.S    |   2 -
 9 files changed, 111 insertions(+), 132 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7116fda..3d33150 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3409,14 +3409,22 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 					of CONFIG_HIGHPTE.
 
 	vdso=		[X86,SH]
-			vdso=2: enable compat VDSO (default with COMPAT_VDSO)
+			On x86_32, this is an alias for vdso32=.  Otherwise:
+
 			vdso=1: enable VDSO (default)
 			vdso=0: disable VDSO mapping
 
-	vdso32=		[X86]
-			vdso32=2: enable compat VDSO (default with COMPAT_VDSO)
-			vdso32=1: enable 32-bit VDSO (default)
-			vdso32=0: disable 32-bit VDSO mapping
+	vdso32=		[X86] Control the 32-bit vDSO
+			vdso=2: enable VDSO with workaround
+			vdso=1: enable VDSO (default unless CONFIG_COMPAT_VDSO)
+			vdso=0: disable VDSO mapping
+
+			See the help text for CONFIG_COMPAT_VDSO for more
+			details.  If CONFIG_COMPAT_VDSO is set, the default
+			changes to 2.  vdso32=1 is the best choice unless you
+			experience crashes that say:
+
+			dl_main: Assertion `(void *) ph->p_vaddr == _rtld_local._dl_sysinfo_dso' failed!
 
 	vector=		[IA-64,SMP]
 			vector=percpu: enable percpu vector domain
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0af5250..e91d770 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1837,16 +1837,28 @@ config DEBUG_HOTPLUG_CPU0
 
 config COMPAT_VDSO
 	def_bool y
-	prompt "Compat VDSO support"
+	prompt "Compatibility with 32-bit glibc 2.3.3"
 	depends on X86_32 || IA32_EMULATION
 	---help---
-	  Map the 32-bit VDSO to the predictable old-style address too.
+	  Certain buggy versions of glibc will crash if they are
+          presented with a 32-bit vDSO that not mapped at the address
+          indicated in its segment table.
 
-	  Say N here if you are running a sufficiently recent glibc
-	  version (2.3.3 or later), to remove the high-mapped
-	  VDSO mapping and to exclusively use the randomized VDSO.
+	  The bug was introduced by f866314b89d56845f55e6f365e18b31ec978ec3a
+	  and fixed by 3b3ddb4f7db98ec9e912ccdf54d35df4aa30e04a and
+	  49ad572a70b8aeb91e57483a11dd1b77e31c4468.  Glibc 2.3.3 is
+	  the only released version with the bug, but OpenSUSE 9
+	  contains a buggy "glibc 2.3.2".
 
-	  If unsure, say Y.
+	  The symptom of the bug is that everything crashes on startup, saying:
+	  dl_main: Assertion `(void *) ph->p_vaddr == _rtld_local._dl_sysinfo_dso' failed!
+
+	  This option changes the default value of the vdso32 boot option
+	  from 1 to 2, which enables a workaround.  This workaround causes
+	  every 32-bit process to use an additional 4k of memory.
+
+	  If unsure, say N: if you are compiling your own kernel, you
+	  are unlikely to be using a buggy version of glibc.
 
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
index d6bfb87..d2ea495 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -16,6 +16,7 @@
 #include <linux/mm.h>
 #include <linux/err.h>
 #include <linux/module.h>
+#include <linux/highmem.h>
 
 #include <asm/cpufeature.h>
 #include <asm/msr.h>
@@ -44,13 +45,6 @@ enum {
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
@@ -76,7 +70,27 @@ __setup_param("vdso=", vdso32_setup, vdso_setup, 0);
 EXPORT_SYMBOL_GPL(vdso_enabled);
 #endif
 
-static __init void reloc_symtab(Elf32_Ehdr *ehdr,
+static short __read_mostly vdso_relocs[128];
+static int num_vdso_relocs;
+
+static __init void add_vdso_reloc(const Elf32_Ehdr *ehdr, const Elf32_Addr *ptr)
+{
+	int offset = (int)((long)ptr - (long)ehdr);
+
+	/*
+	 * Regardless of the size of the vDSO, we do not support
+	 * relocations past the first page.  (Since we're only
+	 * relocating headers, it would be very surprising if
+	 * this were a problem.
+	 */
+	BUG_ON(offset < 0 || offset >= PAGE_SIZE);
+
+	BUG_ON(num_vdso_relocs >= ARRAY_SIZE(vdso_relocs));
+	vdso_relocs[num_vdso_relocs] = offset;
+	num_vdso_relocs++;
+}
+
+static __init void find_reloc_symtab(const Elf32_Ehdr *ehdr,
 				unsigned offset, unsigned size)
 {
 	Elf32_Sym *sym = (void *)ehdr + offset;
@@ -99,14 +113,14 @@ static __init void reloc_symtab(Elf32_Ehdr *ehdr,
 		case STT_FUNC:
 		case STT_SECTION:
 		case STT_FILE:
-			sym->st_value += VDSO_ADDR_ADJUST;
+			add_vdso_reloc(ehdr, &sym->st_value);
 		}
 	}
 }
 
-static __init void reloc_dyn(Elf32_Ehdr *ehdr, unsigned offset)
+static __init void find_reloc_dyn(const Elf32_Ehdr *ehdr, unsigned offset)
 {
-	Elf32_Dyn *dyn = (void *)ehdr + offset;
+	const Elf32_Dyn *dyn = (const void *)ehdr + offset;
 
 	for(; dyn->d_tag != DT_NULL; dyn++)
 		switch(dyn->d_tag) {
@@ -125,7 +139,7 @@ static __init void reloc_dyn(Elf32_Ehdr *ehdr, unsigned offset)
 		case DT_VERNEED:
 		case DT_ADDRRNGLO ... DT_ADDRRNGHI:
 			/* definitely pointers needing relocation */
-			dyn->d_un.d_ptr += VDSO_ADDR_ADJUST;
+			add_vdso_reloc(ehdr, &dyn->d_un.d_ptr);
 			break;
 
 		case DT_ENCODING ... OLD_DT_LOOS-1:
@@ -134,7 +148,7 @@ static __init void reloc_dyn(Elf32_Ehdr *ehdr, unsigned offset)
 			   they're even */
 			if (dyn->d_tag >= DT_ENCODING &&
 			    (dyn->d_tag & 1) == 0)
-				dyn->d_un.d_ptr += VDSO_ADDR_ADJUST;
+				add_vdso_reloc(ehdr, &dyn->d_un.d_ptr);
 			break;
 
 		case DT_VERDEFNUM:
@@ -156,26 +170,26 @@ static __init void reloc_dyn(Elf32_Ehdr *ehdr, unsigned offset)
 		}
 }
 
-static __init void relocate_vdso(Elf32_Ehdr *ehdr)
+static __init void find_vdso_relocs(const Elf32_Ehdr *ehdr)
 {
-	Elf32_Phdr *phdr;
-	Elf32_Shdr *shdr;
+	const Elf32_Phdr *phdr;
+	const Elf32_Shdr *shdr;
 	int i;
 
 	BUG_ON(memcmp(ehdr->e_ident, ELFMAG, SELFMAG) != 0 ||
 	       !elf_check_arch_ia32(ehdr) ||
 	       ehdr->e_type != ET_DYN);
 
-	ehdr->e_entry += VDSO_ADDR_ADJUST;
+	add_vdso_reloc(ehdr, &ehdr->e_entry);
 
 	/* rebase phdrs */
 	phdr = (void *)ehdr + ehdr->e_phoff;
 	for (i = 0; i < ehdr->e_phnum; i++) {
-		phdr[i].p_vaddr += VDSO_ADDR_ADJUST;
+		add_vdso_reloc(ehdr, &phdr[i].p_vaddr);
 
 		/* relocate dynamic stuff */
 		if (phdr[i].p_type == PT_DYNAMIC)
-			reloc_dyn(ehdr, phdr[i].p_offset);
+			find_reloc_dyn(ehdr, phdr[i].p_offset);
 	}
 
 	/* rebase sections */
@@ -184,13 +198,37 @@ static __init void relocate_vdso(Elf32_Ehdr *ehdr)
 		if (!(shdr[i].sh_flags & SHF_ALLOC))
 			continue;
 
-		shdr[i].sh_addr += VDSO_ADDR_ADJUST;
+		add_vdso_reloc(ehdr, &shdr[i].sh_addr);
 
 		if (shdr[i].sh_type == SHT_SYMTAB ||
 		    shdr[i].sh_type == SHT_DYNSYM)
-			reloc_symtab(ehdr, shdr[i].sh_offset,
-				     shdr[i].sh_size);
+			find_reloc_symtab(ehdr, shdr[i].sh_offset,
+					  shdr[i].sh_size);
 	}
+
+#ifdef CONFIG_COMPAT_VDSO
+	if (vdso_enabled == VDSO_COMPAT)
+		pr_info("32-bit vDSO workaround enabled with %d relocs; turn off CONFIG_COMPAT_VDSO if you do not need this.\n",
+		       num_vdso_relocs);
+#endif
+}
+
+int relocate_vdso(struct mm_struct *mm, unsigned long addr)
+{
+	struct page *page;
+	char *map;
+	unsigned int offset = addr;
+	int i;
+
+	if (get_user_pages(current, mm, addr, 1, 1, 1, &page, NULL) != 1)
+		return -EFAULT;
+
+	map = kmap(page);
+	for (i = 0; i < num_vdso_relocs; i++)
+		*(unsigned int *)(map + vdso_relocs[i]) += offset;
+
+	put_page(page);
+	return 0;
 }
 
 static struct page *vdso32_pages[1];
@@ -212,12 +250,6 @@ void syscall32_cpu_init(void)
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
@@ -241,37 +273,6 @@ void enable_sep_cpu(void)
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
@@ -282,10 +283,6 @@ int __init sysenter_setup(void)
 
 	vdso32_pages[0] = virt_to_page(syscall_page);
 
-#ifdef CONFIG_X86_32
-	gate_vma_init();
-#endif
-
 	if (vdso32_syscall()) {
 		vsyscall = &vdso32_syscall_start;
 		vsyscall_len = &vdso32_syscall_end - &vdso32_syscall_start;
@@ -298,7 +295,7 @@ int __init sysenter_setup(void)
 	}
 
 	memcpy(syscall_page, vsyscall, vsyscall_len);
-	relocate_vdso(syscall_page);
+	find_vdso_relocs(syscall_page);
 
 	return 0;
 }
@@ -309,7 +306,6 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	struct mm_struct *mm = current->mm;
 	unsigned long addr;
 	int ret = 0;
-	bool compat;
 
 #ifdef CONFIG_X86_X32_ABI
 	if (test_thread_flag(TIF_X32))
@@ -321,33 +317,26 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 
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
+	/*
+	 * MAYWRITE to allow gdb to COW and set breakpoints
+	 */
+	ret = install_special_mapping(mm, addr, PAGE_SIZE,
+				      VM_READ|VM_EXEC|
+				      VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
+				      vdso32_pages);
+	if (ret)
+		goto up_fail;
 
+	if (vdso_enabled == VDSO_COMPAT) {
+		ret = relocate_vdso(mm, addr);
 		if (ret)
 			goto up_fail;
 	}
@@ -411,20 +400,12 @@ const char *arch_vma_name(struct vm_area_struct *vma)
 
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

