Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306Ab3D3IJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 04:09:30 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:48786 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759171Ab3D3IJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 04:09:25 -0400
Date: Tue, 30 Apr 2013 10:09:20 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 KASLR changes for v3.10
Message-ID: <20130430080920.GA21638@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-kaslr-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-kaslr-for-linus

   HEAD: c889ba801dc3b3a0155fa77d567f2c3a6097de1c x86, relocs: Refactor the relocs tool to merge 32- and 64-bit ELF

This merge contains changes from the ongoing KASLR work, by Kees Cook.

The main changes are the use of a read-only IDT on x86 (which decouples 
the userspace visible virtual IDT address from the physical address), and 
a rework of ELF relocation support, in preparation of random, boot-time 
kernel image relocation.

 Thanks,

	Ingo

------------------>
H. Peter Anvin (1):
      x86, relocs: Refactor the relocs tool to merge 32- and 64-bit ELF

Kees Cook (5):
      x86: Use a read-only IDT alias on all CPUs
      x86, relocs: Generalize ELF structure names
      x86, relocs: Consolidate processing logic
      x86, relocs: Add 64-bit ELF support to relocs tool
      x86, relocs: Build separate 32/64-bit tools


 arch/x86/include/asm/fixmap.h  |   4 +-
 arch/x86/kernel/cpu/intel.c    |  18 +-
 arch/x86/kernel/traps.c        |   9 +
 arch/x86/tools/Makefile        |   1 +
 arch/x86/tools/relocs.c        | 783 ++++++++++++++++++++++++++---------------
 arch/x86/tools/relocs.h        |  36 ++
 arch/x86/tools/relocs_32.c     |  17 +
 arch/x86/tools/relocs_64.c     |  17 +
 arch/x86/tools/relocs_common.c |  76 ++++
 arch/x86/xen/mmu.c             |   4 +-
 10 files changed, 660 insertions(+), 305 deletions(-)
 create mode 100644 arch/x86/tools/relocs.h
 create mode 100644 arch/x86/tools/relocs_32.c
 create mode 100644 arch/x86/tools/relocs_64.c
 create mode 100644 arch/x86/tools/relocs_common.c

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index a09c285..51b9e32 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -104,9 +104,7 @@ enum fixed_addresses {
 	FIX_LI_PCIA,	/* Lithium PCI Bridge A */
 	FIX_LI_PCIB,	/* Lithium PCI Bridge B */
 #endif
-#ifdef CONFIG_X86_F00F_BUG
-	FIX_F00F_IDT,	/* Virtual mapping for IDT */
-#endif
+	FIX_RO_IDT,	/* Virtual mapping for read-only IDT */
 #ifdef CONFIG_X86_CYCLONE_TIMER
 	FIX_CYCLONE_TIMER, /*cyclone timer register*/
 #endif
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 1905ce9..7170024 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -164,20 +164,6 @@ int __cpuinit ppro_with_ram_bug(void)
 	return 0;
 }
 
-#ifdef CONFIG_X86_F00F_BUG
-static void __cpuinit trap_init_f00f_bug(void)
-{
-	__set_fixmap(FIX_F00F_IDT, __pa_symbol(idt_table), PAGE_KERNEL_RO);
-
-	/*
-	 * Update the IDT descriptor and reload the IDT so that
-	 * it uses the read-only mapped virtual address.
-	 */
-	idt_descr.address = fix_to_virt(FIX_F00F_IDT);
-	load_idt(&idt_descr);
-}
-#endif
-
 static void __cpuinit intel_smp_check(struct cpuinfo_x86 *c)
 {
 	/* calling is from identify_secondary_cpu() ? */
@@ -206,8 +192,7 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 	/*
 	 * All current models of Pentium and Pentium with MMX technology CPUs
 	 * have the F0 0F bug, which lets nonprivileged users lock up the
-	 * system.
-	 * Note that the workaround only should be initialized once...
+	 * system. Announce that the fault handler will be checking for it.
 	 */
 	c->f00f_bug = 0;
 	if (!paravirt_enabled() && c->x86 == 5) {
@@ -215,7 +200,6 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 
 		c->f00f_bug = 1;
 		if (!f00f_workaround_enabled) {
-			trap_init_f00f_bug();
 			printk(KERN_NOTICE "Intel Pentium with F0 0F bug - workaround enabled.\n");
 			f00f_workaround_enabled = 1;
 		}
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 68bda7a..10e2446 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -56,6 +56,7 @@
 #include <asm/fpu-internal.h>
 #include <asm/mce.h>
 #include <asm/context_tracking.h>
+#include <asm/fixmap.h>
 
 #include <asm/mach_traps.h>
 
@@ -753,6 +754,14 @@ void __init trap_init(void)
 #endif
 
 	/*
+	 * Set the IDT descriptor to a fixed read-only location, so that the
+	 * "sidt" instruction will not leak the location of the kernel, and
+	 * to defend the IDT against arbitrary memory write vulnerabilities.
+	 * It will be reloaded in cpu_init() */
+	__set_fixmap(FIX_RO_IDT, __pa_symbol(idt_table), PAGE_KERNEL_RO);
+	idt_descr.address = fix_to_virt(FIX_RO_IDT);
+
+	/*
 	 * Should be a barrier for any external CPU state:
 	 */
 	cpu_init();
diff --git a/arch/x86/tools/Makefile b/arch/x86/tools/Makefile
index bae601f..e812034 100644
--- a/arch/x86/tools/Makefile
+++ b/arch/x86/tools/Makefile
@@ -39,4 +39,5 @@ $(obj)/insn_sanity.o: $(srctree)/arch/x86/lib/insn.c $(srctree)/arch/x86/lib/ina
 
 HOST_EXTRACFLAGS += -I$(srctree)/tools/include
 hostprogs-y	+= relocs
+relocs-objs     := relocs_32.o relocs_64.o relocs_common.o
 relocs: $(obj)/relocs
diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index 79d67bd..590be10 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -1,43 +1,36 @@
-#include <stdio.h>
-#include <stdarg.h>
-#include <stdlib.h>
-#include <stdint.h>
-#include <string.h>
-#include <errno.h>
-#include <unistd.h>
-#include <elf.h>
-#include <byteswap.h>
-#define USE_BSD
-#include <endian.h>
-#include <regex.h>
-#include <tools/le_byteshift.h>
-
-static void die(char *fmt, ...);
-
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
-static Elf32_Ehdr ehdr;
-static unsigned long reloc_count, reloc_idx;
-static unsigned long *relocs;
-static unsigned long reloc16_count, reloc16_idx;
-static unsigned long *relocs16;
+/* This is included from relocs_32/64.c */
+
+#define ElfW(type)		_ElfW(ELF_BITS, type)
+#define _ElfW(bits, type)	__ElfW(bits, type)
+#define __ElfW(bits, type)	Elf##bits##_##type
+
+#define Elf_Addr		ElfW(Addr)
+#define Elf_Ehdr		ElfW(Ehdr)
+#define Elf_Phdr		ElfW(Phdr)
+#define Elf_Shdr		ElfW(Shdr)
+#define Elf_Sym			ElfW(Sym)
+
+static Elf_Ehdr ehdr;
+
+struct relocs {
+	uint32_t	*offset;
+	unsigned long	count;
+	unsigned long	size;
+};
+
+static struct relocs relocs16;
+static struct relocs relocs32;
+static struct relocs relocs64;
 
 struct section {
-	Elf32_Shdr     shdr;
+	Elf_Shdr       shdr;
 	struct section *link;
-	Elf32_Sym      *symtab;
-	Elf32_Rel      *reltab;
+	Elf_Sym        *symtab;
+	Elf_Rel        *reltab;
 	char           *strtab;
 };
 static struct section *secs;
 
-enum symtype {
-	S_ABS,
-	S_REL,
-	S_SEG,
-	S_LIN,
-	S_NSYMTYPES
-};
-
 static const char * const sym_regex_kernel[S_NSYMTYPES] = {
 /*
  * Following symbols have been audited. There values are constant and do
@@ -49,6 +42,9 @@ static const char * const sym_regex_kernel[S_NSYMTYPES] = {
 	"^(xen_irq_disable_direct_reloc$|"
 	"xen_save_fl_direct_reloc$|"
 	"VDSO|"
+#if ELF_BITS == 64
+	"__vvar_page|"
+#endif
 	"__crc_)",
 
 /*
@@ -72,6 +68,11 @@ static const char * const sym_regex_kernel[S_NSYMTYPES] = {
 	"__end_rodata|"
 	"__initramfs_start|"
 	"(jiffies|jiffies_64)|"
+#if ELF_BITS == 64
+	"__per_cpu_load|"
+	"init_per_cpu__.*|"
+	"__end_rodata_hpage_align|"
+#endif
 	"_end)$"
 };
 
@@ -132,15 +133,6 @@ static void regex_init(int use_real_mode)
         }
 }
 
-static void die(char *fmt, ...)
-{
-	va_list ap;
-	va_start(ap, fmt);
-	vfprintf(stderr, fmt, ap);
-	va_end(ap);
-	exit(1);
-}
-
 static const char *sym_type(unsigned type)
 {
 	static const char *type_name[] = {
@@ -198,6 +190,24 @@ static const char *rel_type(unsigned type)
 {
 	static const char *type_name[] = {
 #define REL_TYPE(X) [X] = #X
+#if ELF_BITS == 64
+		REL_TYPE(R_X86_64_NONE),
+		REL_TYPE(R_X86_64_64),
+		REL_TYPE(R_X86_64_PC32),
+		REL_TYPE(R_X86_64_GOT32),
+		REL_TYPE(R_X86_64_PLT32),
+		REL_TYPE(R_X86_64_COPY),
+		REL_TYPE(R_X86_64_GLOB_DAT),
+		REL_TYPE(R_X86_64_JUMP_SLOT),
+		REL_TYPE(R_X86_64_RELATIVE),
+		REL_TYPE(R_X86_64_GOTPCREL),
+		REL_TYPE(R_X86_64_32),
+		REL_TYPE(R_X86_64_32S),
+		REL_TYPE(R_X86_64_16),
+		REL_TYPE(R_X86_64_PC16),
+		REL_TYPE(R_X86_64_8),
+		REL_TYPE(R_X86_64_PC8),
+#else
 		REL_TYPE(R_386_NONE),
 		REL_TYPE(R_386_32),
 		REL_TYPE(R_386_PC32),
@@ -213,6 +223,7 @@ static const char *rel_type(unsigned type)
 		REL_TYPE(R_386_PC8),
 		REL_TYPE(R_386_16),
 		REL_TYPE(R_386_PC16),
+#endif
 #undef REL_TYPE
 	};
 	const char *name = "unknown type rel type name";
@@ -240,7 +251,7 @@ static const char *sec_name(unsigned shndx)
 	return name;
 }
 
-static const char *sym_name(const char *sym_strtab, Elf32_Sym *sym)
+static const char *sym_name(const char *sym_strtab, Elf_Sym *sym)
 {
 	const char *name;
 	name = "<noname>";
@@ -253,15 +264,42 @@ static const char *sym_name(const char *sym_strtab, Elf32_Sym *sym)
 	return name;
 }
 
+static Elf_Sym *sym_lookup(const char *symname)
+{
+	int i;
+	for (i = 0; i < ehdr.e_shnum; i++) {
+		struct section *sec = &secs[i];
+		long nsyms;
+		char *strtab;
+		Elf_Sym *symtab;
+		Elf_Sym *sym;
+
+		if (sec->shdr.sh_type != SHT_SYMTAB)
+			continue;
 
+		nsyms = sec->shdr.sh_size/sizeof(Elf_Sym);
+		symtab = sec->symtab;
+		strtab = sec->link->strtab;
+
+		for (sym = symtab; --nsyms >= 0; sym++) {
+			if (!sym->st_name)
+				continue;
+			if (strcmp(symname, strtab + sym->st_name) == 0)
+				return sym;
+		}
+	}
+	return 0;
+}
 
 #if BYTE_ORDER == LITTLE_ENDIAN
 #define le16_to_cpu(val) (val)
 #define le32_to_cpu(val) (val)
+#define le64_to_cpu(val) (val)
 #endif
 #if BYTE_ORDER == BIG_ENDIAN
 #define le16_to_cpu(val) bswap_16(val)
 #define le32_to_cpu(val) bswap_32(val)
+#define le64_to_cpu(val) bswap_64(val)
 #endif
 
 static uint16_t elf16_to_cpu(uint16_t val)
@@ -274,6 +312,23 @@ static uint32_t elf32_to_cpu(uint32_t val)
 	return le32_to_cpu(val);
 }
 
+#define elf_half_to_cpu(x)	elf16_to_cpu(x)
+#define elf_word_to_cpu(x)	elf32_to_cpu(x)
+
+#if ELF_BITS == 64
+static uint64_t elf64_to_cpu(uint64_t val)
+{
+        return le64_to_cpu(val);
+}
+#define elf_addr_to_cpu(x)	elf64_to_cpu(x)
+#define elf_off_to_cpu(x)	elf64_to_cpu(x)
+#define elf_xword_to_cpu(x)	elf64_to_cpu(x)
+#else
+#define elf_addr_to_cpu(x)	elf32_to_cpu(x)
+#define elf_off_to_cpu(x)	elf32_to_cpu(x)
+#define elf_xword_to_cpu(x)	elf32_to_cpu(x)
+#endif
+
 static void read_ehdr(FILE *fp)
 {
 	if (fread(&ehdr, sizeof(ehdr), 1, fp) != 1) {
@@ -283,8 +338,8 @@ static void read_ehdr(FILE *fp)
 	if (memcmp(ehdr.e_ident, ELFMAG, SELFMAG) != 0) {
 		die("No ELF magic\n");
 	}
-	if (ehdr.e_ident[EI_CLASS] != ELFCLASS32) {
-		die("Not a 32 bit executable\n");
+	if (ehdr.e_ident[EI_CLASS] != ELF_CLASS) {
+		die("Not a %d bit executable\n", ELF_BITS);
 	}
 	if (ehdr.e_ident[EI_DATA] != ELFDATA2LSB) {
 		die("Not a LSB ELF executable\n");
@@ -293,36 +348,36 @@ static void read_ehdr(FILE *fp)
 		die("Unknown ELF version\n");
 	}
 	/* Convert the fields to native endian */
-	ehdr.e_type      = elf16_to_cpu(ehdr.e_type);
-	ehdr.e_machine   = elf16_to_cpu(ehdr.e_machine);
-	ehdr.e_version   = elf32_to_cpu(ehdr.e_version);
-	ehdr.e_entry     = elf32_to_cpu(ehdr.e_entry);
-	ehdr.e_phoff     = elf32_to_cpu(ehdr.e_phoff);
-	ehdr.e_shoff     = elf32_to_cpu(ehdr.e_shoff);
-	ehdr.e_flags     = elf32_to_cpu(ehdr.e_flags);
-	ehdr.e_ehsize    = elf16_to_cpu(ehdr.e_ehsize);
-	ehdr.e_phentsize = elf16_to_cpu(ehdr.e_phentsize);
-	ehdr.e_phnum     = elf16_to_cpu(ehdr.e_phnum);
-	ehdr.e_shentsize = elf16_to_cpu(ehdr.e_shentsize);
-	ehdr.e_shnum     = elf16_to_cpu(ehdr.e_shnum);
-	ehdr.e_shstrndx  = elf16_to_cpu(ehdr.e_shstrndx);
+	ehdr.e_type      = elf_half_to_cpu(ehdr.e_type);
+	ehdr.e_machine   = elf_half_to_cpu(ehdr.e_machine);
+	ehdr.e_version   = elf_word_to_cpu(ehdr.e_version);
+	ehdr.e_entry     = elf_addr_to_cpu(ehdr.e_entry);
+	ehdr.e_phoff     = elf_off_to_cpu(ehdr.e_phoff);
+	ehdr.e_shoff     = elf_off_to_cpu(ehdr.e_shoff);
+	ehdr.e_flags     = elf_word_to_cpu(ehdr.e_flags);
+	ehdr.e_ehsize    = elf_half_to_cpu(ehdr.e_ehsize);
+	ehdr.e_phentsize = elf_half_to_cpu(ehdr.e_phentsize);
+	ehdr.e_phnum     = elf_half_to_cpu(ehdr.e_phnum);
+	ehdr.e_shentsize = elf_half_to_cpu(ehdr.e_shentsize);
+	ehdr.e_shnum     = elf_half_to_cpu(ehdr.e_shnum);
+	ehdr.e_shstrndx  = elf_half_to_cpu(ehdr.e_shstrndx);
 
 	if ((ehdr.e_type != ET_EXEC) && (ehdr.e_type != ET_DYN)) {
 		die("Unsupported ELF header type\n");
 	}
-	if (ehdr.e_machine != EM_386) {
-		die("Not for x86\n");
+	if (ehdr.e_machine != ELF_MACHINE) {
+		die("Not for %s\n", ELF_MACHINE_NAME);
 	}
 	if (ehdr.e_version != EV_CURRENT) {
 		die("Unknown ELF version\n");
 	}
-	if (ehdr.e_ehsize != sizeof(Elf32_Ehdr)) {
+	if (ehdr.e_ehsize != sizeof(Elf_Ehdr)) {
 		die("Bad Elf header size\n");
 	}
-	if (ehdr.e_phentsize != sizeof(Elf32_Phdr)) {
+	if (ehdr.e_phentsize != sizeof(Elf_Phdr)) {
 		die("Bad program header entry\n");
 	}
-	if (ehdr.e_shentsize != sizeof(Elf32_Shdr)) {
+	if (ehdr.e_shentsize != sizeof(Elf_Shdr)) {
 		die("Bad section header entry\n");
 	}
 	if (ehdr.e_shstrndx >= ehdr.e_shnum) {
@@ -333,7 +388,7 @@ static void read_ehdr(FILE *fp)
 static void read_shdrs(FILE *fp)
 {
 	int i;
-	Elf32_Shdr shdr;
+	Elf_Shdr shdr;
 
 	secs = calloc(ehdr.e_shnum, sizeof(struct section));
 	if (!secs) {
@@ -349,16 +404,16 @@ static void read_shdrs(FILE *fp)
 		if (fread(&shdr, sizeof shdr, 1, fp) != 1)
 			die("Cannot read ELF section headers %d/%d: %s\n",
 			    i, ehdr.e_shnum, strerror(errno));
-		sec->shdr.sh_name      = elf32_to_cpu(shdr.sh_name);
-		sec->shdr.sh_type      = elf32_to_cpu(shdr.sh_type);
-		sec->shdr.sh_flags     = elf32_to_cpu(shdr.sh_flags);
-		sec->shdr.sh_addr      = elf32_to_cpu(shdr.sh_addr);
-		sec->shdr.sh_offset    = elf32_to_cpu(shdr.sh_offset);
-		sec->shdr.sh_size      = elf32_to_cpu(shdr.sh_size);
-		sec->shdr.sh_link      = elf32_to_cpu(shdr.sh_link);
-		sec->shdr.sh_info      = elf32_to_cpu(shdr.sh_info);
-		sec->shdr.sh_addralign = elf32_to_cpu(shdr.sh_addralign);
-		sec->shdr.sh_entsize   = elf32_to_cpu(shdr.sh_entsize);
+		sec->shdr.sh_name      = elf_word_to_cpu(shdr.sh_name);
+		sec->shdr.sh_type      = elf_word_to_cpu(shdr.sh_type);
+		sec->shdr.sh_flags     = elf_xword_to_cpu(shdr.sh_flags);
+		sec->shdr.sh_addr      = elf_addr_to_cpu(shdr.sh_addr);
+		sec->shdr.sh_offset    = elf_off_to_cpu(shdr.sh_offset);
+		sec->shdr.sh_size      = elf_xword_to_cpu(shdr.sh_size);
+		sec->shdr.sh_link      = elf_word_to_cpu(shdr.sh_link);
+		sec->shdr.sh_info      = elf_word_to_cpu(shdr.sh_info);
+		sec->shdr.sh_addralign = elf_xword_to_cpu(shdr.sh_addralign);
+		sec->shdr.sh_entsize   = elf_xword_to_cpu(shdr.sh_entsize);
 		if (sec->shdr.sh_link < ehdr.e_shnum)
 			sec->link = &secs[sec->shdr.sh_link];
 	}
@@ -412,12 +467,12 @@ static void read_symtabs(FILE *fp)
 			die("Cannot read symbol table: %s\n",
 				strerror(errno));
 		}
-		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf32_Sym); j++) {
-			Elf32_Sym *sym = &sec->symtab[j];
-			sym->st_name  = elf32_to_cpu(sym->st_name);
-			sym->st_value = elf32_to_cpu(sym->st_value);
-			sym->st_size  = elf32_to_cpu(sym->st_size);
-			sym->st_shndx = elf16_to_cpu(sym->st_shndx);
+		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf_Sym); j++) {
+			Elf_Sym *sym = &sec->symtab[j];
+			sym->st_name  = elf_word_to_cpu(sym->st_name);
+			sym->st_value = elf_addr_to_cpu(sym->st_value);
+			sym->st_size  = elf_xword_to_cpu(sym->st_size);
+			sym->st_shndx = elf_half_to_cpu(sym->st_shndx);
 		}
 	}
 }
@@ -428,7 +483,7 @@ static void read_relocs(FILE *fp)
 	int i,j;
 	for (i = 0; i < ehdr.e_shnum; i++) {
 		struct section *sec = &secs[i];
-		if (sec->shdr.sh_type != SHT_REL) {
+		if (sec->shdr.sh_type != SHT_REL_TYPE) {
 			continue;
 		}
 		sec->reltab = malloc(sec->shdr.sh_size);
@@ -445,10 +500,13 @@ static void read_relocs(FILE *fp)
 			die("Cannot read symbol table: %s\n",
 				strerror(errno));
 		}
-		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf32_Rel); j++) {
-			Elf32_Rel *rel = &sec->reltab[j];
-			rel->r_offset = elf32_to_cpu(rel->r_offset);
-			rel->r_info   = elf32_to_cpu(rel->r_info);
+		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf_Rel); j++) {
+			Elf_Rel *rel = &sec->reltab[j];
+			rel->r_offset = elf_addr_to_cpu(rel->r_offset);
+			rel->r_info   = elf_xword_to_cpu(rel->r_info);
+#if (SHT_REL_TYPE == SHT_RELA)
+			rel->r_addend = elf_xword_to_cpu(rel->r_addend);
+#endif
 		}
 	}
 }
@@ -457,6 +515,13 @@ static void read_relocs(FILE *fp)
 static void print_absolute_symbols(void)
 {
 	int i;
+	const char *format;
+
+	if (ELF_BITS == 64)
+		format = "%5d %016"PRIx64" %5"PRId64" %10s %10s %12s %s\n";
+	else
+		format = "%5d %08"PRIx32"  %5"PRId32" %10s %10s %12s %s\n";
+
 	printf("Absolute symbols\n");
 	printf(" Num:    Value Size  Type       Bind        Visibility  Name\n");
 	for (i = 0; i < ehdr.e_shnum; i++) {
@@ -468,19 +533,19 @@ static void print_absolute_symbols(void)
 			continue;
 		}
 		sym_strtab = sec->link->strtab;
-		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf32_Sym); j++) {
-			Elf32_Sym *sym;
+		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf_Sym); j++) {
+			Elf_Sym *sym;
 			const char *name;
 			sym = &sec->symtab[j];
 			name = sym_name(sym_strtab, sym);
 			if (sym->st_shndx != SHN_ABS) {
 				continue;
 			}
-			printf("%5d %08x %5d %10s %10s %12s %s\n",
+			printf(format,
 				j, sym->st_value, sym->st_size,
-				sym_type(ELF32_ST_TYPE(sym->st_info)),
-				sym_bind(ELF32_ST_BIND(sym->st_info)),
-				sym_visibility(ELF32_ST_VISIBILITY(sym->st_other)),
+				sym_type(ELF_ST_TYPE(sym->st_info)),
+				sym_bind(ELF_ST_BIND(sym->st_info)),
+				sym_visibility(ELF_ST_VISIBILITY(sym->st_other)),
 				name);
 		}
 	}
@@ -490,14 +555,20 @@ static void print_absolute_symbols(void)
 static void print_absolute_relocs(void)
 {
 	int i, printed = 0;
+	const char *format;
+
+	if (ELF_BITS == 64)
+		format = "%016"PRIx64" %016"PRIx64" %10s %016"PRIx64"  %s\n";
+	else
+		format = "%08"PRIx32" %08"PRIx32" %10s %08"PRIx32"  %s\n";
 
 	for (i = 0; i < ehdr.e_shnum; i++) {
 		struct section *sec = &secs[i];
 		struct section *sec_applies, *sec_symtab;
 		char *sym_strtab;
-		Elf32_Sym *sh_symtab;
+		Elf_Sym *sh_symtab;
 		int j;
-		if (sec->shdr.sh_type != SHT_REL) {
+		if (sec->shdr.sh_type != SHT_REL_TYPE) {
 			continue;
 		}
 		sec_symtab  = sec->link;
@@ -507,12 +578,12 @@ static void print_absolute_relocs(void)
 		}
 		sh_symtab  = sec_symtab->symtab;
 		sym_strtab = sec_symtab->link->strtab;
-		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf32_Rel); j++) {
-			Elf32_Rel *rel;
-			Elf32_Sym *sym;
+		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf_Rel); j++) {
+			Elf_Rel *rel;
+			Elf_Sym *sym;
 			const char *name;
 			rel = &sec->reltab[j];
-			sym = &sh_symtab[ELF32_R_SYM(rel->r_info)];
+			sym = &sh_symtab[ELF_R_SYM(rel->r_info)];
 			name = sym_name(sym_strtab, sym);
 			if (sym->st_shndx != SHN_ABS) {
 				continue;
@@ -542,10 +613,10 @@ static void print_absolute_relocs(void)
 				printed = 1;
 			}
 
-			printf("%08x %08x %10s %08x  %s\n",
+			printf(format,
 				rel->r_offset,
 				rel->r_info,
-				rel_type(ELF32_R_TYPE(rel->r_info)),
+				rel_type(ELF_R_TYPE(rel->r_info)),
 				sym->st_value,
 				name);
 		}
@@ -555,19 +626,34 @@ static void print_absolute_relocs(void)
 		printf("\n");
 }
 
-static void walk_relocs(void (*visit)(Elf32_Rel *rel, Elf32_Sym *sym),
-			int use_real_mode)
+static void add_reloc(struct relocs *r, uint32_t offset)
+{
+	if (r->count == r->size) {
+		unsigned long newsize = r->size + 50000;
+		void *mem = realloc(r->offset, newsize * sizeof(r->offset[0]));
+
+		if (!mem)
+			die("realloc of %ld entries for relocs failed\n",
+                                newsize);
+		r->offset = mem;
+		r->size = newsize;
+	}
+	r->offset[r->count++] = offset;
+}
+
+static void walk_relocs(int (*process)(struct section *sec, Elf_Rel *rel,
+			Elf_Sym *sym, const char *symname))
 {
 	int i;
 	/* Walk through the relocations */
 	for (i = 0; i < ehdr.e_shnum; i++) {
 		char *sym_strtab;
-		Elf32_Sym *sh_symtab;
+		Elf_Sym *sh_symtab;
 		struct section *sec_applies, *sec_symtab;
 		int j;
 		struct section *sec = &secs[i];
 
-		if (sec->shdr.sh_type != SHT_REL) {
+		if (sec->shdr.sh_type != SHT_REL_TYPE) {
 			continue;
 		}
 		sec_symtab  = sec->link;
@@ -577,101 +663,281 @@ static void walk_relocs(void (*visit)(Elf32_Rel *rel, Elf32_Sym *sym),
 		}
 		sh_symtab = sec_symtab->symtab;
 		sym_strtab = sec_symtab->link->strtab;
-		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf32_Rel); j++) {
-			Elf32_Rel *rel;
-			Elf32_Sym *sym;
-			unsigned r_type;
-			const char *symname;
-			int shn_abs;
+		for (j = 0; j < sec->shdr.sh_size/sizeof(Elf_Rel); j++) {
+			Elf_Rel *rel = &sec->reltab[j];
+			Elf_Sym *sym = &sh_symtab[ELF_R_SYM(rel->r_info)];
+			const char *symname = sym_name(sym_strtab, sym);
 
-			rel = &sec->reltab[j];
-			sym = &sh_symtab[ELF32_R_SYM(rel->r_info)];
-			r_type = ELF32_R_TYPE(rel->r_info);
-
-			shn_abs = sym->st_shndx == SHN_ABS;
-
-			switch (r_type) {
-			case R_386_NONE:
-			case R_386_PC32:
-			case R_386_PC16:
-			case R_386_PC8:
-				/*
-				 * NONE can be ignored and and PC relative
-				 * relocations don't need to be adjusted.
-				 */
-				break;
+			process(sec, rel, sym, symname);
+		}
+	}
+}
 
-			case R_386_16:
-				symname = sym_name(sym_strtab, sym);
-				if (!use_real_mode)
-					goto bad;
-				if (shn_abs) {
-					if (is_reloc(S_ABS, symname))
-						break;
-					else if (!is_reloc(S_SEG, symname))
-						goto bad;
-				} else {
-					if (is_reloc(S_LIN, symname))
-						goto bad;
-					else
-						break;
-				}
-				visit(rel, sym);
-				break;
+/*
+ * The .data..percpu section is a special case for x86_64 SMP kernels.
+ * It is used to initialize the actual per_cpu areas and to provide
+ * definitions for the per_cpu variables that correspond to their offsets
+ * within the percpu area. Since the values of all of the symbols need
+ * to be offsets from the start of the per_cpu area the virtual address
+ * (sh_addr) of .data..percpu is 0 in SMP kernels.
+ *
+ * This means that:
+ *
+ *	Relocations that reference symbols in the per_cpu area do not
+ *	need further relocation (since the value is an offset relative
+ *	to the start of the per_cpu area that does not change).
+ *
+ *	Relocations that apply to the per_cpu area need to have their
+ *	offset adjusted by by the value of __per_cpu_load to make them
+ *	point to the correct place in the loaded image (because the
+ *	virtual address of .data..percpu is 0).
+ *
+ * For non SMP kernels .data..percpu is linked as part of the normal
+ * kernel data and does not require special treatment.
+ *
+ */
+static int per_cpu_shndx	= -1;
+Elf_Addr per_cpu_load_addr;
 
-			case R_386_32:
-				symname = sym_name(sym_strtab, sym);
-				if (shn_abs) {
-					if (is_reloc(S_ABS, symname))
-						break;
-					else if (!is_reloc(S_REL, symname))
-						goto bad;
-				} else {
-					if (use_real_mode &&
-					    !is_reloc(S_LIN, symname))
-						break;
-				}
-				visit(rel, sym);
-				break;
-			default:
-				die("Unsupported relocation type: %s (%d)\n",
-				    rel_type(r_type), r_type);
+static void percpu_init(void)
+{
+	int i;
+	for (i = 0; i < ehdr.e_shnum; i++) {
+		ElfW(Sym) *sym;
+		if (strcmp(sec_name(i), ".data..percpu"))
+			continue;
+
+		if (secs[i].shdr.sh_addr != 0)	/* non SMP kernel */
+			return;
+
+		sym = sym_lookup("__per_cpu_load");
+		if (!sym)
+			die("can't find __per_cpu_load\n");
+
+		per_cpu_shndx = i;
+		per_cpu_load_addr = sym->st_value;
+		return;
+	}
+}
+
+#if ELF_BITS == 64
+
+/*
+ * Check to see if a symbol lies in the .data..percpu section.
+ * For some as yet not understood reason the "__init_begin"
+ * symbol which immediately preceeds the .data..percpu section
+ * also shows up as it it were part of it so we do an explict
+ * check for that symbol name and ignore it.
+ */
+static int is_percpu_sym(ElfW(Sym) *sym, const char *symname)
+{
+	return (sym->st_shndx == per_cpu_shndx) &&
+		strcmp(symname, "__init_begin");
+}
+
+
+static int do_reloc64(struct section *sec, Elf_Rel *rel, ElfW(Sym) *sym,
+		      const char *symname)
+{
+	unsigned r_type = ELF64_R_TYPE(rel->r_info);
+	ElfW(Addr) offset = rel->r_offset;
+	int shn_abs = (sym->st_shndx == SHN_ABS) && !is_reloc(S_REL, symname);
+
+	if (sym->st_shndx == SHN_UNDEF)
+		return 0;
+
+	/*
+	 * Adjust the offset if this reloc applies to the percpu section.
+	 */
+	if (sec->shdr.sh_info == per_cpu_shndx)
+		offset += per_cpu_load_addr;
+
+	switch (r_type) {
+	case R_X86_64_NONE:
+	case R_X86_64_PC32:
+		/*
+		 * NONE can be ignored and PC relative relocations don't
+		 * need to be adjusted.
+		 */
+		break;
+
+	case R_X86_64_32:
+	case R_X86_64_32S:
+	case R_X86_64_64:
+		/*
+		 * References to the percpu area don't need to be adjusted.
+		 */
+		if (is_percpu_sym(sym, symname))
+			break;
+
+		if (shn_abs) {
+			/*
+			 * Whitelisted absolute symbols do not require
+			 * relocation.
+			 */
+			if (is_reloc(S_ABS, symname))
 				break;
-			bad:
-				symname = sym_name(sym_strtab, sym);
-				die("Invalid %s %s relocation: %s\n",
-				    shn_abs ? "absolute" : "relative",
-				    rel_type(r_type), symname);
-			}
+
+			die("Invalid absolute %s relocation: %s\n",
+			    rel_type(r_type), symname);
+			break;
 		}
+
+		/*
+		 * Relocation offsets for 64 bit kernels are output
+		 * as 32 bits and sign extended back to 64 bits when
+		 * the relocations are processed.
+		 * Make sure that the offset will fit.
+		 */
+		if ((int32_t)offset != (int64_t)offset)
+			die("Relocation offset doesn't fit in 32 bits\n");
+
+		if (r_type == R_X86_64_64)
+			add_reloc(&relocs64, offset);
+		else
+			add_reloc(&relocs32, offset);
+		break;
+
+	default:
+		die("Unsupported relocation type: %s (%d)\n",
+		    rel_type(r_type), r_type);
+		break;
 	}
+
+	return 0;
 }
 
-static void count_reloc(Elf32_Rel *rel, Elf32_Sym *sym)
+#else
+
+static int do_reloc32(struct section *sec, Elf_Rel *rel, Elf_Sym *sym,
+		      const char *symname)
 {
-	if (ELF32_R_TYPE(rel->r_info) == R_386_16)
-		reloc16_count++;
-	else
-		reloc_count++;
+	unsigned r_type = ELF32_R_TYPE(rel->r_info);
+	int shn_abs = (sym->st_shndx == SHN_ABS) && !is_reloc(S_REL, symname);
+
+	switch (r_type) {
+	case R_386_NONE:
+	case R_386_PC32:
+	case R_386_PC16:
+	case R_386_PC8:
+		/*
+		 * NONE can be ignored and PC relative relocations don't
+		 * need to be adjusted.
+		 */
+		break;
+
+	case R_386_32:
+		if (shn_abs) {
+			/*
+			 * Whitelisted absolute symbols do not require
+			 * relocation.
+			 */
+			if (is_reloc(S_ABS, symname))
+				break;
+
+			die("Invalid absolute %s relocation: %s\n",
+			    rel_type(r_type), symname);
+			break;
+		}
+
+		add_reloc(&relocs32, rel->r_offset);
+		break;
+
+	default:
+		die("Unsupported relocation type: %s (%d)\n",
+		    rel_type(r_type), r_type);
+		break;
+	}
+
+	return 0;
 }
 
-static void collect_reloc(Elf32_Rel *rel, Elf32_Sym *sym)
+static int do_reloc_real(struct section *sec, Elf_Rel *rel, Elf_Sym *sym,
+			 const char *symname)
 {
-	/* Remember the address that needs to be adjusted. */
-	if (ELF32_R_TYPE(rel->r_info) == R_386_16)
-		relocs16[reloc16_idx++] = rel->r_offset;
-	else
-		relocs[reloc_idx++] = rel->r_offset;
+	unsigned r_type = ELF32_R_TYPE(rel->r_info);
+	int shn_abs = (sym->st_shndx == SHN_ABS) && !is_reloc(S_REL, symname);
+
+	switch (r_type) {
+	case R_386_NONE:
+	case R_386_PC32:
+	case R_386_PC16:
+	case R_386_PC8:
+		/*
+		 * NONE can be ignored and PC relative relocations don't
+		 * need to be adjusted.
+		 */
+		break;
+
+	case R_386_16:
+		if (shn_abs) {
+			/*
+			 * Whitelisted absolute symbols do not require
+			 * relocation.
+			 */
+			if (is_reloc(S_ABS, symname))
+				break;
+
+			if (is_reloc(S_SEG, symname)) {
+				add_reloc(&relocs16, rel->r_offset);
+				break;
+			}
+		} else {
+			if (!is_reloc(S_LIN, symname))
+				break;
+		}
+		die("Invalid %s %s relocation: %s\n",
+		    shn_abs ? "absolute" : "relative",
+		    rel_type(r_type), symname);
+		break;
+
+	case R_386_32:
+		if (shn_abs) {
+			/*
+			 * Whitelisted absolute symbols do not require
+			 * relocation.
+			 */
+			if (is_reloc(S_ABS, symname))
+				break;
+
+			if (is_reloc(S_REL, symname)) {
+				add_reloc(&relocs32, rel->r_offset);
+				break;
+			}
+		} else {
+			if (is_reloc(S_LIN, symname))
+				add_reloc(&relocs32, rel->r_offset);
+			break;
+		}
+		die("Invalid %s %s relocation: %s\n",
+		    shn_abs ? "absolute" : "relative",
+		    rel_type(r_type), symname);
+		break;
+
+	default:
+		die("Unsupported relocation type: %s (%d)\n",
+		    rel_type(r_type), r_type);
+		break;
+	}
+
+	return 0;
 }
 
+#endif
+
 static int cmp_relocs(const void *va, const void *vb)
 {
-	const unsigned long *a, *b;
+	const uint32_t *a, *b;
 	a = va; b = vb;
 	return (*a == *b)? 0 : (*a > *b)? 1 : -1;
 }
 
-static int write32(unsigned int v, FILE *f)
+static void sort_relocs(struct relocs *r)
+{
+	qsort(r->offset, r->count, sizeof(r->offset[0]), cmp_relocs);
+}
+
+static int write32(uint32_t v, FILE *f)
 {
 	unsigned char buf[4];
 
@@ -679,33 +945,40 @@ static int write32(unsigned int v, FILE *f)
 	return fwrite(buf, 1, 4, f) == 4 ? 0 : -1;
 }
 
+static int write32_as_text(uint32_t v, FILE *f)
+{
+	return fprintf(f, "\t.long 0x%08"PRIx32"\n", v) > 0 ? 0 : -1;
+}
+
 static void emit_relocs(int as_text, int use_real_mode)
 {
 	int i;
-	/* Count how many relocations I have and allocate space for them. */
-	reloc_count = 0;
-	walk_relocs(count_reloc, use_real_mode);
-	relocs = malloc(reloc_count * sizeof(relocs[0]));
-	if (!relocs) {
-		die("malloc of %d entries for relocs failed\n",
-			reloc_count);
-	}
+	int (*write_reloc)(uint32_t, FILE *) = write32;
+	int (*do_reloc)(struct section *sec, Elf_Rel *rel, Elf_Sym *sym,
+			const char *symname);
+
+#if ELF_BITS == 64
+	if (!use_real_mode)
+		do_reloc = do_reloc64;
+	else
+		die("--realmode not valid for a 64-bit ELF file");
+#else
+	if (!use_real_mode)
+		do_reloc = do_reloc32;
+	else
+		do_reloc = do_reloc_real;
+#endif
 
-	relocs16 = malloc(reloc16_count * sizeof(relocs[0]));
-	if (!relocs16) {
-		die("malloc of %d entries for relocs16 failed\n",
-			reloc16_count);
-	}
 	/* Collect up the relocations */
-	reloc_idx = 0;
-	walk_relocs(collect_reloc, use_real_mode);
+	walk_relocs(do_reloc);
 
-	if (reloc16_count && !use_real_mode)
+	if (relocs16.count && !use_real_mode)
 		die("Segment relocations found but --realmode not specified\n");
 
 	/* Order the relocations for more efficient processing */
-	qsort(relocs, reloc_count, sizeof(relocs[0]), cmp_relocs);
-	qsort(relocs16, reloc16_count, sizeof(relocs16[0]), cmp_relocs);
+	sort_relocs(&relocs16);
+	sort_relocs(&relocs32);
+	sort_relocs(&relocs64);
 
 	/* Print the relocations */
 	if (as_text) {
@@ -714,114 +987,60 @@ static void emit_relocs(int as_text, int use_real_mode)
 		 */
 		printf(".section \".data.reloc\",\"a\"\n");
 		printf(".balign 4\n");
-		if (use_real_mode) {
-			printf("\t.long %lu\n", reloc16_count);
-			for (i = 0; i < reloc16_count; i++)
-				printf("\t.long 0x%08lx\n", relocs16[i]);
-			printf("\t.long %lu\n", reloc_count);
-			for (i = 0; i < reloc_count; i++) {
-				printf("\t.long 0x%08lx\n", relocs[i]);
-			}
-		} else {
-			/* Print a stop */
-			printf("\t.long 0x%08lx\n", (unsigned long)0);
-			for (i = 0; i < reloc_count; i++) {
-				printf("\t.long 0x%08lx\n", relocs[i]);
-			}
-		}
-
-		printf("\n");
+		write_reloc = write32_as_text;
 	}
-	else {
-		if (use_real_mode) {
-			write32(reloc16_count, stdout);
-			for (i = 0; i < reloc16_count; i++)
-				write32(relocs16[i], stdout);
-			write32(reloc_count, stdout);
 
-			/* Now print each relocation */
-			for (i = 0; i < reloc_count; i++)
-				write32(relocs[i], stdout);
-		} else {
+	if (use_real_mode) {
+		write_reloc(relocs16.count, stdout);
+		for (i = 0; i < relocs16.count; i++)
+			write_reloc(relocs16.offset[i], stdout);
+
+		write_reloc(relocs32.count, stdout);
+		for (i = 0; i < relocs32.count; i++)
+			write_reloc(relocs32.offset[i], stdout);
+	} else {
+		if (ELF_BITS == 64) {
 			/* Print a stop */
-			write32(0, stdout);
+			write_reloc(0, stdout);
 
 			/* Now print each relocation */
-			for (i = 0; i < reloc_count; i++) {
-				write32(relocs[i], stdout);
-			}
+			for (i = 0; i < relocs64.count; i++)
+				write_reloc(relocs64.offset[i], stdout);
 		}
+
+		/* Print a stop */
+		write_reloc(0, stdout);
+
+		/* Now print each relocation */
+		for (i = 0; i < relocs32.count; i++)
+			write_reloc(relocs32.offset[i], stdout);
 	}
 }
 
-static void usage(void)
-{
-	die("relocs [--abs-syms|--abs-relocs|--text|--realmode] vmlinux\n");
-}
+#if ELF_BITS == 64
+# define process process_64
+#else
+# define process process_32
+#endif
 
-int main(int argc, char **argv)
+void process(FILE *fp, int use_real_mode, int as_text,
+	     int show_absolute_syms, int show_absolute_relocs)
 {
-	int show_absolute_syms, show_absolute_relocs;
-	int as_text, use_real_mode;
-	const char *fname;
-	FILE *fp;
-	int i;
-
-	show_absolute_syms = 0;
-	show_absolute_relocs = 0;
-	as_text = 0;
-	use_real_mode = 0;
-	fname = NULL;
-	for (i = 1; i < argc; i++) {
-		char *arg = argv[i];
-		if (*arg == '-') {
-			if (strcmp(arg, "--abs-syms") == 0) {
-				show_absolute_syms = 1;
-				continue;
-			}
-			if (strcmp(arg, "--abs-relocs") == 0) {
-				show_absolute_relocs = 1;
-				continue;
-			}
-			if (strcmp(arg, "--text") == 0) {
-				as_text = 1;
-				continue;
-			}
-			if (strcmp(arg, "--realmode") == 0) {
-				use_real_mode = 1;
-				continue;
-			}
-		}
-		else if (!fname) {
-			fname = arg;
-			continue;
-		}
-		usage();
-	}
-	if (!fname) {
-		usage();
-	}
 	regex_init(use_real_mode);
-	fp = fopen(fname, "r");
-	if (!fp) {
-		die("Cannot open %s: %s\n",
-			fname, strerror(errno));
-	}
 	read_ehdr(fp);
 	read_shdrs(fp);
 	read_strtabs(fp);
 	read_symtabs(fp);
 	read_relocs(fp);
+	if (ELF_BITS == 64)
+		percpu_init();
 	if (show_absolute_syms) {
 		print_absolute_symbols();
-		goto out;
+		return;
 	}
 	if (show_absolute_relocs) {
 		print_absolute_relocs();
-		goto out;
+		return;
 	}
 	emit_relocs(as_text, use_real_mode);
-out:
-	fclose(fp);
-	return 0;
 }
diff --git a/arch/x86/tools/relocs.h b/arch/x86/tools/relocs.h
new file mode 100644
index 0000000..07cdb1e
--- /dev/null
+++ b/arch/x86/tools/relocs.h
@@ -0,0 +1,36 @@
+#ifndef RELOCS_H
+#define RELOCS_H
+
+#include <stdio.h>
+#include <stdarg.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <inttypes.h>
+#include <string.h>
+#include <errno.h>
+#include <unistd.h>
+#include <elf.h>
+#include <byteswap.h>
+#define USE_BSD
+#include <endian.h>
+#include <regex.h>
+#include <tools/le_byteshift.h>
+
+void die(char *fmt, ...);
+
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+
+enum symtype {
+	S_ABS,
+	S_REL,
+	S_SEG,
+	S_LIN,
+	S_NSYMTYPES
+};
+
+void process_32(FILE *fp, int use_real_mode, int as_text,
+		int show_absolute_syms, int show_absolute_relocs);
+void process_64(FILE *fp, int use_real_mode, int as_text,
+		int show_absolute_syms, int show_absolute_relocs);
+
+#endif /* RELOCS_H */
diff --git a/arch/x86/tools/relocs_32.c b/arch/x86/tools/relocs_32.c
new file mode 100644
index 0000000..b2ade2b
--- /dev/null
+++ b/arch/x86/tools/relocs_32.c
@@ -0,0 +1,17 @@
+#include "relocs.h"
+
+#define ELF_BITS 32
+
+#define ELF_MACHINE		EM_386
+#define ELF_MACHINE_NAME	"i386"
+#define SHT_REL_TYPE		SHT_REL
+#define Elf_Rel			ElfW(Rel)
+
+#define ELF_CLASS		ELFCLASS32
+#define ELF_R_SYM(val)		ELF32_R_SYM(val)
+#define ELF_R_TYPE(val)		ELF32_R_TYPE(val)
+#define ELF_ST_TYPE(o)		ELF32_ST_TYPE(o)
+#define ELF_ST_BIND(o)		ELF32_ST_BIND(o)
+#define ELF_ST_VISIBILITY(o)	ELF32_ST_VISIBILITY(o)
+
+#include "relocs.c"
diff --git a/arch/x86/tools/relocs_64.c b/arch/x86/tools/relocs_64.c
new file mode 100644
index 0000000..56b61b7
--- /dev/null
+++ b/arch/x86/tools/relocs_64.c
@@ -0,0 +1,17 @@
+#include "relocs.h"
+
+#define ELF_BITS 64
+
+#define ELF_MACHINE             EM_X86_64
+#define ELF_MACHINE_NAME        "x86_64"
+#define SHT_REL_TYPE            SHT_RELA
+#define Elf_Rel                 Elf64_Rela
+
+#define ELF_CLASS               ELFCLASS64
+#define ELF_R_SYM(val)          ELF64_R_SYM(val)
+#define ELF_R_TYPE(val)         ELF64_R_TYPE(val)
+#define ELF_ST_TYPE(o)          ELF64_ST_TYPE(o)
+#define ELF_ST_BIND(o)          ELF64_ST_BIND(o)
+#define ELF_ST_VISIBILITY(o)    ELF64_ST_VISIBILITY(o)
+
+#include "relocs.c"
diff --git a/arch/x86/tools/relocs_common.c b/arch/x86/tools/relocs_common.c
new file mode 100644
index 0000000..44d3968
--- /dev/null
+++ b/arch/x86/tools/relocs_common.c
@@ -0,0 +1,76 @@
+#include "relocs.h"
+
+void die(char *fmt, ...)
+{
+	va_list ap;
+	va_start(ap, fmt);
+	vfprintf(stderr, fmt, ap);
+	va_end(ap);
+	exit(1);
+}
+
+static void usage(void)
+{
+	die("relocs [--abs-syms|--abs-relocs|--text|--realmode] vmlinux\n");
+}
+
+int main(int argc, char **argv)
+{
+	int show_absolute_syms, show_absolute_relocs;
+	int as_text, use_real_mode;
+	const char *fname;
+	FILE *fp;
+	int i;
+	unsigned char e_ident[EI_NIDENT];
+
+	show_absolute_syms = 0;
+	show_absolute_relocs = 0;
+	as_text = 0;
+	use_real_mode = 0;
+	fname = NULL;
+	for (i = 1; i < argc; i++) {
+		char *arg = argv[i];
+		if (*arg == '-') {
+			if (strcmp(arg, "--abs-syms") == 0) {
+				show_absolute_syms = 1;
+				continue;
+			}
+			if (strcmp(arg, "--abs-relocs") == 0) {
+				show_absolute_relocs = 1;
+				continue;
+			}
+			if (strcmp(arg, "--text") == 0) {
+				as_text = 1;
+				continue;
+			}
+			if (strcmp(arg, "--realmode") == 0) {
+				use_real_mode = 1;
+				continue;
+			}
+		}
+		else if (!fname) {
+			fname = arg;
+			continue;
+		}
+		usage();
+	}
+	if (!fname) {
+		usage();
+	}
+	fp = fopen(fname, "r");
+	if (!fp) {
+		die("Cannot open %s: %s\n", fname, strerror(errno));
+	}
+	if (fread(&e_ident, 1, EI_NIDENT, fp) != EI_NIDENT) {
+		die("Cannot read %s: %s", fname, strerror(errno));
+	}
+	rewind(fp);
+	if (e_ident[EI_CLASS] == ELFCLASS64)
+		process_64(fp, use_real_mode, as_text,
+			   show_absolute_syms, show_absolute_relocs);
+	else
+		process_32(fp, use_real_mode, as_text,
+			   show_absolute_syms, show_absolute_relocs);
+	fclose(fp);
+	return 0;
+}
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 6afbb2c..8bc4dec 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2039,9 +2039,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 
 	switch (idx) {
 	case FIX_BTMAP_END ... FIX_BTMAP_BEGIN:
-#ifdef CONFIG_X86_F00F_BUG
-	case FIX_F00F_IDT:
-#endif
+	case FIX_RO_IDT:
 #ifdef CONFIG_X86_32
 	case FIX_WP_TEST:
 	case FIX_VDSO:
