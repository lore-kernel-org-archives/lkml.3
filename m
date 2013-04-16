Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965645Ab3DPXWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 19:22:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49402 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965609Ab3DPXWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 19:22:17 -0400
Date: Tue, 16 Apr 2013 16:22:00 -0700
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-c889ba801dc3b3a0155fa77d567f2c3a6097de1c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        keescook@chromium.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1365797627-20874-5-git-send-email-keescook@chromium.org>
References: <1365797627-20874-5-git-send-email-keescook@chromium.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/kaslr] x86, relocs:
  Refactor the relocs tool to merge 32- and 64-bit ELF
Git-Commit-ID: c889ba801dc3b3a0155fa77d567f2c3a6097de1c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 16 Apr 2013 16:22:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c889ba801dc3b3a0155fa77d567f2c3a6097de1c
Gitweb:     http://git.kernel.org/tip/c889ba801dc3b3a0155fa77d567f2c3a6097de1c
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Tue, 16 Apr 2013 16:02:58 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 16 Apr 2013 16:02:58 -0700

x86, relocs: Refactor the relocs tool to merge 32- and 64-bit ELF

Refactor the relocs tool so that the same tool can handle 32- and
64-bit ELF.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>
Link: http://lkml.kernel.org/r/1365797627-20874-5-git-send-email-keescook@chromium.org
---
 arch/x86/boot/compressed/Makefile |   2 +-
 arch/x86/realmode/rm/Makefile     |   2 +-
 arch/x86/tools/.gitignore         |   3 +-
 arch/x86/tools/Makefile           |  21 +----
 arch/x86/tools/relocs.c           | 162 ++++++++------------------------------
 arch/x86/tools/relocs.h           |  36 +++++++++
 arch/x86/tools/relocs_32.c        |  17 ++++
 arch/x86/tools/relocs_64.c        |  17 ++++
 arch/x86/tools/relocs_common.c    |  76 ++++++++++++++++++
 9 files changed, 183 insertions(+), 153 deletions(-)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 0dac175..5ef205c 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -44,7 +44,7 @@ $(obj)/vmlinux.bin: vmlinux FORCE
 
 targets += $(patsubst $(obj)/%,%,$(VMLINUX_OBJS)) vmlinux.bin.all vmlinux.relocs
 
-CMD_RELOCS = arch/x86/tools/relocs_$(BITS)
+CMD_RELOCS = arch/x86/tools/relocs
 quiet_cmd_relocs = RELOCS  $@
       cmd_relocs = $(CMD_RELOCS) $< > $@;$(CMD_RELOCS) --abs-relocs $<
 $(obj)/vmlinux.relocs: vmlinux FORCE
diff --git a/arch/x86/realmode/rm/Makefile b/arch/x86/realmode/rm/Makefile
index 2b1e429..8869287 100644
--- a/arch/x86/realmode/rm/Makefile
+++ b/arch/x86/realmode/rm/Makefile
@@ -56,7 +56,7 @@ $(obj)/realmode.bin: $(obj)/realmode.elf $(obj)/realmode.relocs
 	$(call if_changed,objcopy)
 
 quiet_cmd_relocs = RELOCS  $@
-      cmd_relocs = arch/x86/tools/relocs_32 --realmode $< > $@
+      cmd_relocs = arch/x86/tools/relocs --realmode $< > $@
 
 targets += realmode.relocs
 $(obj)/realmode.relocs: $(obj)/realmode.elf FORCE
diff --git a/arch/x86/tools/.gitignore b/arch/x86/tools/.gitignore
index 2b45d5f..be0ed06 100644
--- a/arch/x86/tools/.gitignore
+++ b/arch/x86/tools/.gitignore
@@ -1,2 +1 @@
-relocs_32*
-relocs_64*
+relocs
diff --git a/arch/x86/tools/Makefile b/arch/x86/tools/Makefile
index a8cb70c..e812034 100644
--- a/arch/x86/tools/Makefile
+++ b/arch/x86/tools/Makefile
@@ -37,22 +37,7 @@ $(obj)/test_get_len.o: $(srctree)/arch/x86/lib/insn.c $(srctree)/arch/x86/lib/in
 
 $(obj)/insn_sanity.o: $(srctree)/arch/x86/lib/insn.c $(srctree)/arch/x86/lib/inat.c $(srctree)/arch/x86/include/asm/inat_types.h $(srctree)/arch/x86/include/asm/inat.h $(srctree)/arch/x86/include/asm/insn.h $(objtree)/arch/x86/lib/inat-tables.c
 
-HOSTCFLAGS_relocs_32.o += -DELF_BITS=32
-HOSTCFLAGS_relocs_64.o += -DELF_BITS=64
-
-quiet_cmd_cp_reloc = GEN     $@
-      cmd_cp_reloc = cp $< $@
-
-$(obj)/relocs_%.c: $(srctree)/arch/x86/tools/relocs.c
-	$(call cmd,cp_reloc)
-
 HOST_EXTRACFLAGS += -I$(srctree)/tools/include
-hostprogs-y    += relocs_$(BITS)
-relocs_binaries = relocs_$(BITS)
-ifeq ($(CONFIG_64BIT),y)
-	hostprogs-y  += relocs_32
-	relocs_binaries += relocs_32
-endif
-relocs: $(relocs_binaries)
-relocs_32: $(obj)/relocs_32
-relocs_64: $(obj)/relocs_64
+hostprogs-y	+= relocs
+relocs-objs     := relocs_32.o relocs_64.o relocs_common.o
+relocs: $(obj)/relocs
diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index 1f7ff3d..590be10 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -1,63 +1,15 @@
-#include <stdio.h>
-#include <stdarg.h>
-#include <stdlib.h>
-#include <stdint.h>
-#include <inttypes.h>
-#include <string.h>
-#include <errno.h>
-#include <unistd.h>
-#include <elf.h>
-#include <byteswap.h>
-#define USE_BSD
-#include <endian.h>
-#include <regex.h>
-#include <tools/le_byteshift.h>
+/* This is included from relocs_32/64.c */
 
 #define ElfW(type)		_ElfW(ELF_BITS, type)
 #define _ElfW(bits, type)	__ElfW(bits, type)
 #define __ElfW(bits, type)	Elf##bits##_##type
 
-#ifndef ELF_BITS
-#define ELF_BITS		32
-#endif
-
-#if (ELF_BITS == 64)
-#define ELF_MACHINE             EM_X86_64
-#define ELF_MACHINE_NAME        "x86_64"
-#define SHT_REL_TYPE            SHT_RELA
-#define Elf_Rel                 Elf64_Rela
-#else
-#define ELF_MACHINE		EM_386
-#define ELF_MACHINE_NAME	"i386"
-#define SHT_REL_TYPE		SHT_REL
-#define Elf_Rel			ElfW(Rel)
-#endif
-
-#if (ELF_BITS == 64)
-#define ELF_CLASS               ELFCLASS64
-#define ELF_R_SYM(val)          ELF64_R_SYM(val)
-#define ELF_R_TYPE(val)         ELF64_R_TYPE(val)
-#define ELF_ST_TYPE(o)          ELF64_ST_TYPE(o)
-#define ELF_ST_BIND(o)          ELF64_ST_BIND(o)
-#define ELF_ST_VISIBILITY(o)    ELF64_ST_VISIBILITY(o)
-#else
-#define ELF_CLASS		ELFCLASS32
-#define ELF_R_SYM(val)		ELF32_R_SYM(val)
-#define ELF_R_TYPE(val)		ELF32_R_TYPE(val)
-#define ELF_ST_TYPE(o)		ELF32_ST_TYPE(o)
-#define ELF_ST_BIND(o)		ELF32_ST_BIND(o)
-#define ELF_ST_VISIBILITY(o)	ELF32_ST_VISIBILITY(o)
-#endif
-
 #define Elf_Addr		ElfW(Addr)
 #define Elf_Ehdr		ElfW(Ehdr)
 #define Elf_Phdr		ElfW(Phdr)
 #define Elf_Shdr		ElfW(Shdr)
 #define Elf_Sym			ElfW(Sym)
 
-static void die(char *fmt, ...);
-
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 static Elf_Ehdr ehdr;
 
 struct relocs {
@@ -79,14 +31,6 @@ struct section {
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
@@ -98,7 +42,7 @@ static const char * const sym_regex_kernel[S_NSYMTYPES] = {
 	"^(xen_irq_disable_direct_reloc$|"
 	"xen_save_fl_direct_reloc$|"
 	"VDSO|"
-#if (ELF_BITS == 64)
+#if ELF_BITS == 64
 	"__vvar_page|"
 #endif
 	"__crc_)",
@@ -124,7 +68,7 @@ static const char * const sym_regex_kernel[S_NSYMTYPES] = {
 	"__end_rodata|"
 	"__initramfs_start|"
 	"(jiffies|jiffies_64)|"
-#if (ELF_BITS == 64)
+#if ELF_BITS == 64
 	"__per_cpu_load|"
 	"init_per_cpu__.*|"
 	"__end_rodata_hpage_align|"
@@ -189,15 +133,6 @@ static void regex_init(int use_real_mode)
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
@@ -255,7 +190,7 @@ static const char *rel_type(unsigned type)
 {
 	static const char *type_name[] = {
 #define REL_TYPE(X) [X] = #X
-#if (ELF_BITS == 64)
+#if ELF_BITS == 64
 		REL_TYPE(R_X86_64_NONE),
 		REL_TYPE(R_X86_64_64),
 		REL_TYPE(R_X86_64_PC32),
@@ -380,7 +315,7 @@ static uint32_t elf32_to_cpu(uint32_t val)
 #define elf_half_to_cpu(x)	elf16_to_cpu(x)
 #define elf_word_to_cpu(x)	elf32_to_cpu(x)
 
-#if (ELF_BITS == 64)
+#if ELF_BITS == 64
 static uint64_t elf64_to_cpu(uint64_t val)
 {
         return le64_to_cpu(val);
@@ -582,7 +517,7 @@ static void print_absolute_symbols(void)
 	int i;
 	const char *format;
 
-	if (ehdr.e_ident[EI_CLASS] == ELFCLASS64)
+	if (ELF_BITS == 64)
 		format = "%5d %016"PRIx64" %5"PRId64" %10s %10s %12s %s\n";
 	else
 		format = "%5d %08"PRIx32"  %5"PRId32" %10s %10s %12s %s\n";
@@ -622,7 +557,7 @@ static void print_absolute_relocs(void)
 	int i, printed = 0;
 	const char *format;
 
-	if (ehdr.e_ident[EI_CLASS] == ELFCLASS64)
+	if (ELF_BITS == 64)
 		format = "%016"PRIx64" %016"PRIx64" %10s %016"PRIx64"  %s\n";
 	else
 		format = "%08"PRIx32" %08"PRIx32" %10s %08"PRIx32"  %s\n";
@@ -785,6 +720,8 @@ static void percpu_init(void)
 	}
 }
 
+#if ELF_BITS == 64
+
 /*
  * Check to see if a symbol lies in the .data..percpu section.
  * For some as yet not understood reason the "__init_begin"
@@ -798,6 +735,7 @@ static int is_percpu_sym(ElfW(Sym) *sym, const char *symname)
 		strcmp(symname, "__init_begin");
 }
 
+
 static int do_reloc64(struct section *sec, Elf_Rel *rel, ElfW(Sym) *sym,
 		      const char *symname)
 {
@@ -869,6 +807,7 @@ static int do_reloc64(struct section *sec, Elf_Rel *rel, ElfW(Sym) *sym,
 	return 0;
 }
 
+#else
 
 static int do_reloc32(struct section *sec, Elf_Rel *rel, Elf_Sym *sym,
 		      const char *symname)
@@ -984,6 +923,8 @@ static int do_reloc_real(struct section *sec, Elf_Rel *rel, Elf_Sym *sym,
 	return 0;
 }
 
+#endif
+
 static int cmp_relocs(const void *va, const void *vb)
 {
 	const uint32_t *a, *b;
@@ -1016,12 +957,17 @@ static void emit_relocs(int as_text, int use_real_mode)
 	int (*do_reloc)(struct section *sec, Elf_Rel *rel, Elf_Sym *sym,
 			const char *symname);
 
-	if (ehdr.e_ident[EI_CLASS] == ELFCLASS64)
+#if ELF_BITS == 64
+	if (!use_real_mode)
 		do_reloc = do_reloc64;
-	else if (!use_real_mode)
+	else
+		die("--realmode not valid for a 64-bit ELF file");
+#else
+	if (!use_real_mode)
 		do_reloc = do_reloc32;
 	else
 		do_reloc = do_reloc_real;
+#endif
 
 	/* Collect up the relocations */
 	walk_relocs(do_reloc);
@@ -1053,7 +999,7 @@ static void emit_relocs(int as_text, int use_real_mode)
 		for (i = 0; i < relocs32.count; i++)
 			write_reloc(relocs32.offset[i], stdout);
 	} else {
-		if (ehdr.e_ident[EI_CLASS] == ELFCLASS64) {
+		if (ELF_BITS == 64) {
 			/* Print a stop */
 			write_reloc(0, stdout);
 
@@ -1071,76 +1017,30 @@ static void emit_relocs(int as_text, int use_real_mode)
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
-	if (ehdr.e_ident[EI_CLASS] == ELFCLASS64)
+	if (ELF_BITS == 64)
 		percpu_init();
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
