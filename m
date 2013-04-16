Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965629Ab3DPXTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 19:19:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49366 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965598Ab3DPXTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 19:19:48 -0400
Date: Tue, 16 Apr 2013 16:19:36 -0700
From: tip-bot for Kees Cook <tipbot@zytor.com>
Message-ID: <tip-946166af95d1defacfbc21e7c902d0556a2a7660@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        keescook@chromium.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1365797627-20874-4-git-send-email-keescook@chromium.org>
References: <1365797627-20874-4-git-send-email-keescook@chromium.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/kaslr] x86, relocs:
  Add 64-bit ELF support to relocs tool
Git-Commit-ID: 946166af95d1defacfbc21e7c902d0556a2a7660
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 16 Apr 2013 16:19:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  946166af95d1defacfbc21e7c902d0556a2a7660
Gitweb:     http://git.kernel.org/tip/946166af95d1defacfbc21e7c902d0556a2a7660
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Fri, 12 Apr 2013 13:13:44 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 16 Apr 2013 15:19:22 -0700

x86, relocs: Add 64-bit ELF support to relocs tool

This adds the ability to process relocations from the 64-bit kernel ELF,
if built with ELF_BITS=64 defined. The special case for the percpu area is
handled, along with some other symbols specific to the 64-bit kernel.

Based on work by Neill Clift and Michael Davidson.

Signed-off-by: Kees Cook <keescook@chromium.org>
Link: http://lkml.kernel.org/r/1365797627-20874-4-git-send-email-keescook@chromium.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/tools/relocs.c | 267 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 261 insertions(+), 6 deletions(-)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index bdc5930..1f7ff3d 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -17,19 +17,39 @@
 #define _ElfW(bits, type)	__ElfW(bits, type)
 #define __ElfW(bits, type)	Elf##bits##_##type
 
+#ifndef ELF_BITS
 #define ELF_BITS		32
+#endif
+
+#if (ELF_BITS == 64)
+#define ELF_MACHINE             EM_X86_64
+#define ELF_MACHINE_NAME        "x86_64"
+#define SHT_REL_TYPE            SHT_RELA
+#define Elf_Rel                 Elf64_Rela
+#else
 #define ELF_MACHINE		EM_386
 #define ELF_MACHINE_NAME	"i386"
 #define SHT_REL_TYPE		SHT_REL
+#define Elf_Rel			ElfW(Rel)
+#endif
 
+#if (ELF_BITS == 64)
+#define ELF_CLASS               ELFCLASS64
+#define ELF_R_SYM(val)          ELF64_R_SYM(val)
+#define ELF_R_TYPE(val)         ELF64_R_TYPE(val)
+#define ELF_ST_TYPE(o)          ELF64_ST_TYPE(o)
+#define ELF_ST_BIND(o)          ELF64_ST_BIND(o)
+#define ELF_ST_VISIBILITY(o)    ELF64_ST_VISIBILITY(o)
+#else
 #define ELF_CLASS		ELFCLASS32
 #define ELF_R_SYM(val)		ELF32_R_SYM(val)
 #define ELF_R_TYPE(val)		ELF32_R_TYPE(val)
 #define ELF_ST_TYPE(o)		ELF32_ST_TYPE(o)
 #define ELF_ST_BIND(o)		ELF32_ST_BIND(o)
 #define ELF_ST_VISIBILITY(o)	ELF32_ST_VISIBILITY(o)
+#endif
 
-#define Elf_Rel			ElfW(Rel)
+#define Elf_Addr		ElfW(Addr)
 #define Elf_Ehdr		ElfW(Ehdr)
 #define Elf_Phdr		ElfW(Phdr)
 #define Elf_Shdr		ElfW(Shdr)
@@ -48,6 +68,7 @@ struct relocs {
 
 static struct relocs relocs16;
 static struct relocs relocs32;
+static struct relocs relocs64;
 
 struct section {
 	Elf_Shdr       shdr;
@@ -77,6 +98,9 @@ static const char * const sym_regex_kernel[S_NSYMTYPES] = {
 	"^(xen_irq_disable_direct_reloc$|"
 	"xen_save_fl_direct_reloc$|"
 	"VDSO|"
+#if (ELF_BITS == 64)
+	"__vvar_page|"
+#endif
 	"__crc_)",
 
 /*
@@ -100,6 +124,11 @@ static const char * const sym_regex_kernel[S_NSYMTYPES] = {
 	"__end_rodata|"
 	"__initramfs_start|"
 	"(jiffies|jiffies_64)|"
+#if (ELF_BITS == 64)
+	"__per_cpu_load|"
+	"init_per_cpu__.*|"
+	"__end_rodata_hpage_align|"
+#endif
 	"_end)$"
 };
 
@@ -226,6 +255,24 @@ static const char *rel_type(unsigned type)
 {
 	static const char *type_name[] = {
 #define REL_TYPE(X) [X] = #X
+#if (ELF_BITS == 64)
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
@@ -241,6 +288,7 @@ static const char *rel_type(unsigned type)
 		REL_TYPE(R_386_PC8),
 		REL_TYPE(R_386_16),
 		REL_TYPE(R_386_PC16),
+#endif
 #undef REL_TYPE
 	};
 	const char *name = "unknown type rel type name";
@@ -281,15 +329,42 @@ static const char *sym_name(const char *sym_strtab, Elf_Sym *sym)
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
 
+		if (sec->shdr.sh_type != SHT_SYMTAB)
+			continue;
+
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
@@ -304,9 +379,20 @@ static uint32_t elf32_to_cpu(uint32_t val)
 
 #define elf_half_to_cpu(x)	elf16_to_cpu(x)
 #define elf_word_to_cpu(x)	elf32_to_cpu(x)
+
+#if (ELF_BITS == 64)
+static uint64_t elf64_to_cpu(uint64_t val)
+{
+        return le64_to_cpu(val);
+}
+#define elf_addr_to_cpu(x)	elf64_to_cpu(x)
+#define elf_off_to_cpu(x)	elf64_to_cpu(x)
+#define elf_xword_to_cpu(x)	elf64_to_cpu(x)
+#else
 #define elf_addr_to_cpu(x)	elf32_to_cpu(x)
 #define elf_off_to_cpu(x)	elf32_to_cpu(x)
 #define elf_xword_to_cpu(x)	elf32_to_cpu(x)
+#endif
 
 static void read_ehdr(FILE *fp)
 {
@@ -483,6 +569,9 @@ static void read_relocs(FILE *fp)
 			Elf_Rel *rel = &sec->reltab[j];
 			rel->r_offset = elf_addr_to_cpu(rel->r_offset);
 			rel->r_info   = elf_xword_to_cpu(rel->r_info);
+#if (SHT_REL_TYPE == SHT_RELA)
+			rel->r_addend = elf_xword_to_cpu(rel->r_addend);
+#endif
 		}
 	}
 }
@@ -491,6 +580,13 @@ static void read_relocs(FILE *fp)
 static void print_absolute_symbols(void)
 {
 	int i;
+	const char *format;
+
+	if (ehdr.e_ident[EI_CLASS] == ELFCLASS64)
+		format = "%5d %016"PRIx64" %5"PRId64" %10s %10s %12s %s\n";
+	else
+		format = "%5d %08"PRIx32"  %5"PRId32" %10s %10s %12s %s\n";
+
 	printf("Absolute symbols\n");
 	printf(" Num:    Value Size  Type       Bind        Visibility  Name\n");
 	for (i = 0; i < ehdr.e_shnum; i++) {
@@ -510,7 +606,7 @@ static void print_absolute_symbols(void)
 			if (sym->st_shndx != SHN_ABS) {
 				continue;
 			}
-			printf("%5d %08x %5d %10s %10s %12s %s\n",
+			printf(format,
 				j, sym->st_value, sym->st_size,
 				sym_type(ELF_ST_TYPE(sym->st_info)),
 				sym_bind(ELF_ST_BIND(sym->st_info)),
@@ -524,6 +620,12 @@ static void print_absolute_symbols(void)
 static void print_absolute_relocs(void)
 {
 	int i, printed = 0;
+	const char *format;
+
+	if (ehdr.e_ident[EI_CLASS] == ELFCLASS64)
+		format = "%016"PRIx64" %016"PRIx64" %10s %016"PRIx64"  %s\n";
+	else
+		format = "%08"PRIx32" %08"PRIx32" %10s %08"PRIx32"  %s\n";
 
 	for (i = 0; i < ehdr.e_shnum; i++) {
 		struct section *sec = &secs[i];
@@ -576,7 +678,7 @@ static void print_absolute_relocs(void)
 				printed = 1;
 			}
 
-			printf("%08x %08x %10s %08x  %s\n",
+			printf(format,
 				rel->r_offset,
 				rel->r_info,
 				rel_type(ELF_R_TYPE(rel->r_info)),
@@ -636,8 +738,140 @@ static void walk_relocs(int (*process)(struct section *sec, Elf_Rel *rel,
 	}
 }
 
-static int do_reloc(struct section *sec, Elf_Rel *rel, Elf_Sym *sym,
-		    const char *symname)
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
+
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
+				break;
+
+			die("Invalid absolute %s relocation: %s\n",
+			    rel_type(r_type), symname);
+			break;
+		}
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
+	}
+
+	return 0;
+}
+
+
+static int do_reloc32(struct section *sec, Elf_Rel *rel, Elf_Sym *sym,
+		      const char *symname)
 {
 	unsigned r_type = ELF32_R_TYPE(rel->r_info);
 	int shn_abs = (sym->st_shndx == SHN_ABS) && !is_reloc(S_REL, symname);
@@ -779,9 +1013,18 @@ static void emit_relocs(int as_text, int use_real_mode)
 {
 	int i;
 	int (*write_reloc)(uint32_t, FILE *) = write32;
+	int (*do_reloc)(struct section *sec, Elf_Rel *rel, Elf_Sym *sym,
+			const char *symname);
+
+	if (ehdr.e_ident[EI_CLASS] == ELFCLASS64)
+		do_reloc = do_reloc64;
+	else if (!use_real_mode)
+		do_reloc = do_reloc32;
+	else
+		do_reloc = do_reloc_real;
 
 	/* Collect up the relocations */
-	walk_relocs(use_real_mode ? do_reloc_real : do_reloc);
+	walk_relocs(do_reloc);
 
 	if (relocs16.count && !use_real_mode)
 		die("Segment relocations found but --realmode not specified\n");
@@ -789,6 +1032,7 @@ static void emit_relocs(int as_text, int use_real_mode)
 	/* Order the relocations for more efficient processing */
 	sort_relocs(&relocs16);
 	sort_relocs(&relocs32);
+	sort_relocs(&relocs64);
 
 	/* Print the relocations */
 	if (as_text) {
@@ -809,6 +1053,15 @@ static void emit_relocs(int as_text, int use_real_mode)
 		for (i = 0; i < relocs32.count; i++)
 			write_reloc(relocs32.offset[i], stdout);
 	} else {
+		if (ehdr.e_ident[EI_CLASS] == ELFCLASS64) {
+			/* Print a stop */
+			write_reloc(0, stdout);
+
+			/* Now print each relocation */
+			for (i = 0; i < relocs64.count; i++)
+				write_reloc(relocs64.offset[i], stdout);
+		}
+
 		/* Print a stop */
 		write_reloc(0, stdout);
 
@@ -876,6 +1129,8 @@ int main(int argc, char **argv)
 	read_strtabs(fp);
 	read_symtabs(fp);
 	read_relocs(fp);
+	if (ehdr.e_ident[EI_CLASS] == ELFCLASS64)
+		percpu_init();
 	if (show_absolute_syms) {
 		print_absolute_symbols();
 		goto out;
