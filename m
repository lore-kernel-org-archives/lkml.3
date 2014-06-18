Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbaFRXAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:00:18 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:62501 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125AbaFRXAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:00:12 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Josh Boyer <jwboyer@fedoraproject.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 3/5] x86,vdso: Improve the fake section headers
Date: Wed, 18 Jun 2014 15:59:48 -0700
Message-Id: <0e546a5eeaafdf1840e6ee654a55c1e727c26663.1403129369.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1403129369.git.luto@amacapital.net>
References: <cover.1403129369.git.luto@amacapital.net>
In-Reply-To: <cover.1403129369.git.luto@amacapital.net>
References: <cover.1403129369.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fully stripping the vDSO has other unfortunate side effects:

 - binutils is unable to find ELF notes without a SHT_NOTE section.

 - Even elfutils has trouble: it can find ELF notes without a section
   table at all, but if a section table is present, it won't look for
   PT_NOTE.

 - gdb wants section names to match between stripped DSOs and their
   symbols; otherwise it will corrupt symbol addresses.

We're also breaking the rules: section 0 is supposed to be SHT_NULL.

Fix these problems by building a better fake section table.  While
we're at it, we might as well let buggy Go versions keep working well
by giving the SHT_DYNSYM entry the correct size.

This is a bit unfortunate: it adds quite a bit of size to the vdso
image.

If/when binutils improves and the improved versions become widespread,
it would be worth considering dropping most of this.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/vdso/Makefile                   |   4 +-
 arch/x86/vdso/vdso-fakesections.c        |  44 ++++----
 arch/x86/vdso/vdso-layout.lds.S          |  40 +++++--
 arch/x86/vdso/vdso.lds.S                 |   2 +
 arch/x86/vdso/vdso2c.c                   |  31 ++++--
 arch/x86/vdso/vdso2c.h                   | 180 +++++++++++++++++++++++++++----
 arch/x86/vdso/vdso32/vdso-fakesections.c |   1 +
 arch/x86/vdso/vdsox32.lds.S              |   2 +
 8 files changed, 237 insertions(+), 67 deletions(-)
 create mode 100644 arch/x86/vdso/vdso32/vdso-fakesections.c

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 3c0809a..2c1ca98 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -11,7 +11,6 @@ VDSO32-$(CONFIG_COMPAT)		:= y
 
 # files to link into the vdso
 vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o vdso-fakesections.o
-vobjs-nox32 := vdso-fakesections.o
 
 # files to link into kernel
 obj-y				+= vma.o
@@ -134,7 +133,7 @@ override obj-dirs = $(dir $(obj)) $(obj)/vdso32/
 
 targets += vdso32/vdso32.lds
 targets += vdso32/note.o vdso32/vclock_gettime.o $(vdso32.so-y:%=vdso32/%.o)
-targets += vdso32/vclock_gettime.o
+targets += vdso32/vclock_gettime.o vdso32/vdso-fakesections.o
 
 $(obj)/vdso32.o: $(vdso32-images:%=$(obj)/%)
 
@@ -155,6 +154,7 @@ $(vdso32-images:%=$(obj)/%.dbg): KBUILD_CFLAGS = $(KBUILD_CFLAGS_32)
 $(vdso32-images:%=$(obj)/%.dbg): $(obj)/vdso32-%.so.dbg: FORCE \
 				 $(obj)/vdso32/vdso32.lds \
 				 $(obj)/vdso32/vclock_gettime.o \
+				 $(obj)/vdso32/vdso-fakesections.o \
 				 $(obj)/vdso32/note.o \
 				 $(obj)/vdso32/%.o
 	$(call if_changed,vdso)
diff --git a/arch/x86/vdso/vdso-fakesections.c b/arch/x86/vdso/vdso-fakesections.c
index cb8a8d7..56927a7 100644
--- a/arch/x86/vdso/vdso-fakesections.c
+++ b/arch/x86/vdso/vdso-fakesections.c
@@ -2,31 +2,23 @@
  * Copyright 2014 Andy Lutomirski
  * Subject to the GNU Public License, v.2
  *
- * Hack to keep broken Go programs working.
- *
- * The Go runtime had a couple of bugs: it would read the section table to try
- * to figure out how many dynamic symbols there were (it shouldn't have looked
- * at the section table at all) and, if there were no SHT_SYNDYM section table
- * entry, it would use an uninitialized value for the number of symbols.  As a
- * workaround, we supply a minimal section table.  vdso2c will adjust the
- * in-memory image so that "vdso_fake_sections" becomes the section table.
- *
- * The bug was introduced by:
- * https://code.google.com/p/go/source/detail?r=56ea40aac72b (2012-08-31)
- * and is being addressed in the Go runtime in this issue:
- * https://code.google.com/p/go/issues/detail?id=8197
+ * String table for loadable section headers.  See vdso2c.h for why
+ * this exists.
  */
 
-#ifndef __x86_64__
-#error This hack is specific to the 64-bit vDSO
-#endif
-
-#include <linux/elf.h>
-
-extern const __visible struct elf64_shdr vdso_fake_sections[];
-const __visible struct elf64_shdr vdso_fake_sections[] = {
-	{
-		.sh_type = SHT_DYNSYM,
-		.sh_entsize = sizeof(Elf64_Sym),
-	}
-};
+const char fake_shstrtab[] __attribute__((section(".fake_shstrtab"))) =
+	".hash\0"
+	".dynsym\0"
+	".dynstr\0"
+	".gnu.version\0"
+	".gnu.version_d\0"
+	".dynamic\0"
+	".rodata\0"
+	".fake_shstrtab\0"  /* Yay, self-referential code. */
+	".note\0"
+	".data\0"
+	".altinstructions\0"
+	".altinstr_replacement\0"
+	".eh_frame_hdr\0"
+	".eh_frame\0"
+	".text";
diff --git a/arch/x86/vdso/vdso-layout.lds.S b/arch/x86/vdso/vdso-layout.lds.S
index c84166c..e4cbc21 100644
--- a/arch/x86/vdso/vdso-layout.lds.S
+++ b/arch/x86/vdso/vdso-layout.lds.S
@@ -6,6 +6,16 @@
  * This script controls its layout.
  */
 
+#if defined(BUILD_VDSO64)
+# define SHDR_SIZE 64
+#elif defined(BUILD_VDSO32) || defined(BUILD_VDSOX32)
+# define SHDR_SIZE 40
+#else
+# error unknown VDSO target
+#endif
+
+#define NUM_FAKE_SHDRS 16
+
 SECTIONS
 {
 	. = SIZEOF_HEADERS;
@@ -25,15 +35,29 @@ SECTIONS
 
 	.dynamic	: { *(.dynamic) }		:text	:dynamic
 
-	.rodata		: { *(.rodata*) }		:text
+	.rodata		: {
+		*(.rodata*)
+
+		/*
+		 * Ideally this would live in a C file, but that won't
+		 * work cleanly for x32 until we start building the x32
+		 * C code using an x32 toolchain.
+		 */
+		VDSO_FAKE_SECTION_TABLE_START = .;
+		. = . + NUM_FAKE_SHDRS * SHDR_SIZE;
+		VDSO_FAKE_SECTION_TABLE_END = .;
+	}						:text
+
+	.fake_shstrtab	: { *(.fake_shstrtab) }		:text
+
 	.data		: {
-	      *(.data*)
-	      *(.sdata*)
-	      *(.got.plt) *(.got)
-	      *(.gnu.linkonce.d.*)
-	      *(.bss*)
-	      *(.dynbss*)
-	      *(.gnu.linkonce.b.*)
+		*(.data*)
+		*(.sdata*)
+		*(.got.plt) *(.got)
+		*(.gnu.linkonce.d.*)
+		*(.bss*)
+		*(.dynbss*)
+		*(.gnu.linkonce.b.*)
 	}
 
 	.altinstructions	: { *(.altinstructions) }
diff --git a/arch/x86/vdso/vdso.lds.S b/arch/x86/vdso/vdso.lds.S
index 75e3404..6807932 100644
--- a/arch/x86/vdso/vdso.lds.S
+++ b/arch/x86/vdso/vdso.lds.S
@@ -6,6 +6,8 @@
  * the DSO.
  */
 
+#define BUILD_VDSO64
+
 #include "vdso-layout.lds.S"
 
 /*
diff --git a/arch/x86/vdso/vdso2c.c b/arch/x86/vdso/vdso2c.c
index 7343899..238dbe82 100644
--- a/arch/x86/vdso/vdso2c.c
+++ b/arch/x86/vdso/vdso2c.c
@@ -23,6 +23,8 @@ enum {
 	sym_vvar_page,
 	sym_hpet_page,
 	sym_end_mapping,
+	sym_VDSO_FAKE_SECTION_TABLE_START,
+	sym_VDSO_FAKE_SECTION_TABLE_END,
 };
 
 const int special_pages[] = {
@@ -30,15 +32,26 @@ const int special_pages[] = {
 	sym_hpet_page,
 };
 
-char const * const required_syms[] = {
-	[sym_vvar_page] = "vvar_page",
-	[sym_hpet_page] = "hpet_page",
-	[sym_end_mapping] = "end_mapping",
-	"VDSO32_NOTE_MASK",
-	"VDSO32_SYSENTER_RETURN",
-	"__kernel_vsyscall",
-	"__kernel_sigreturn",
-	"__kernel_rt_sigreturn",
+struct vdso_sym {
+	const char *name;
+	bool export;
+};
+
+struct vdso_sym required_syms[] = {
+	[sym_vvar_page] = {"vvar_page", true},
+	[sym_hpet_page] = {"hpet_page", true},
+	[sym_end_mapping] = {"end_mapping", true},
+	[sym_VDSO_FAKE_SECTION_TABLE_START] = {
+		"VDSO_FAKE_SECTION_TABLE_START", false
+	},
+	[sym_VDSO_FAKE_SECTION_TABLE_END] = {
+		"VDSO_FAKE_SECTION_TABLE_END", false
+	},
+	{"VDSO32_NOTE_MASK", true},
+	{"VDSO32_SYSENTER_RETURN", true},
+	{"__kernel_vsyscall", true},
+	{"__kernel_sigreturn", true},
+	{"__kernel_rt_sigreturn", true},
 };
 
 __attribute__((format(printf, 1, 2))) __attribute__((noreturn))
diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
index 8e185ce..f01ed4b 100644
--- a/arch/x86/vdso/vdso2c.h
+++ b/arch/x86/vdso/vdso2c.h
@@ -4,6 +4,116 @@
  * are built for 32-bit userspace.
  */
 
+/*
+ * We're writing a section table for a few reasons:
+ *
+ * The Go runtime had a couple of bugs: it would read the section
+ * table to try to figure out how many dynamic symbols there were (it
+ * shouldn't have looked at the section table at all) and, if there
+ * were no SHT_SYNDYM section table entry, it would use an
+ * uninitialized value for the number of symbols.  An empty DYNSYM
+ * table would work, but I see no reason not to write a valid one (and
+ * keep full performance for old Go programs).  This hack is only
+ * needed on x86_64.
+ *
+ * The bug was introduced on 2012-08-31 by:
+ * https://code.google.com/p/go/source/detail?r=56ea40aac72b
+ * and was fixed on 2014-06-13 by:
+ * https://code.google.com/p/go/source/detail?r=fc1cd5e12595
+ *
+ * Binutils has issues debugging the vDSO: it reads the section table to
+ * find SHT_NOTE; it won't look at PT_NOTE for the in-memory vDSO, which
+ * would break build-id if we removed the section table.  Binutils
+ * also requires that shstrndx != 0.  See:
+ * https://sourceware.org/bugzilla/show_bug.cgi?id=17064
+ *
+ * elfutils might not look for PT_NOTE if there is a section table at
+ * all.  I don't know whether this matters for any practical purpose.
+ *
+ * For simplicity, rather than hacking up a partial section table, we
+ * just write a mostly complete one.  We omit non-dynamic symbols,
+ * though, since they're rather large.
+ *
+ * Once binutils gets fixed, we might be able to drop this for all but
+ * the 64-bit vdso, since build-id only works in kernel RPMs, and
+ * systems that update to new enough kernel RPMs will likely update
+ * binutils in sync.  build-id has never worked for home-built kernel
+ * RPMs without manual symlinking, and I suspect that no one ever does
+ * that.
+ */
+struct BITSFUNC(fake_sections)
+{
+	ELF(Shdr) *table;
+	unsigned long table_offset;
+	int count, max_count;
+
+	int in_shstrndx;
+	unsigned long shstr_offset;
+	const char *shstrtab;
+	size_t shstrtab_len;
+
+	int out_shstrndx;
+};
+
+static unsigned int BITSFUNC(find_shname)(struct BITSFUNC(fake_sections) *out,
+					  const char *name)
+{
+	const char *outname = out->shstrtab;
+	while (outname - out->shstrtab < out->shstrtab_len) {
+		if (!strcmp(name, outname))
+			return (outname - out->shstrtab) + out->shstr_offset;
+		outname += strlen(outname) + 1;
+	}
+
+	if (*name)
+		printf("Warning: could not find output name \"%s\"\n", name);
+	return out->shstr_offset + out->shstrtab_len - 1;  /* Use a null. */
+}
+
+static void BITSFUNC(init_sections)(struct BITSFUNC(fake_sections) *out)
+{
+	if (!out->in_shstrndx)
+		fail("didn't find the fake shstrndx\n");
+
+	memset(out->table, 0, out->max_count * sizeof(ELF(Shdr)));
+
+	if (out->max_count < 1)
+		fail("we need at least two fake output sections\n");
+
+	PUT_LE(&out->table[0].sh_type, SHT_NULL);
+	PUT_LE(&out->table[0].sh_name, BITSFUNC(find_shname)(out, ""));
+
+	out->count = 1;
+}
+
+static void BITSFUNC(copy_section)(struct BITSFUNC(fake_sections) *out,
+				   int in_idx, const ELF(Shdr) *in,
+				   const char *name)
+{
+	uint64_t flags = GET_LE(&in->sh_flags);
+
+	bool copy = flags & SHF_ALLOC;
+
+	if (!copy)
+		return;
+
+	if (out->count >= out->max_count)
+		fail("too many copied sections (max = %d)\n", out->max_count);
+
+	if (in_idx == out->in_shstrndx)
+		out->out_shstrndx = out->count;
+
+	out->table[out->count] = *in;
+	PUT_LE(&out->table[out->count].sh_name,
+	       BITSFUNC(find_shname)(out, name));
+
+	/* elfutils requires that a strtab have the correct type. */
+	if (!strcmp(name, ".fake_shstrtab"))
+		PUT_LE(&out->table[out->count].sh_type, SHT_STRTAB);
+
+	out->count++;
+}
+
 static void BITSFUNC(go)(void *addr, size_t len,
 			 FILE *outfile, const char *name)
 {
@@ -19,7 +129,7 @@ static void BITSFUNC(go)(void *addr, size_t len,
 	const char *secstrings;
 	uint64_t syms[NSYMS] = {};
 
-	uint64_t fake_sections_value = 0, fake_sections_size = 0;
+	struct BITSFUNC(fake_sections) fake_sections = {};
 
 	ELF(Phdr) *pt = (ELF(Phdr) *)(addr + GET_LE(&hdr->e_phoff));
 
@@ -89,23 +199,57 @@ static void BITSFUNC(go)(void *addr, size_t len,
 			GET_LE(&sym->st_name);
 
 		for (k = 0; k < NSYMS; k++) {
-			if (!strcmp(name, required_syms[k])) {
+			if (!strcmp(name, required_syms[k].name)) {
 				if (syms[k]) {
 					fail("duplicate symbol %s\n",
-					     required_syms[k]);
+					     required_syms[k].name);
 				}
 				syms[k] = GET_LE(&sym->st_value);
 			}
 		}
 
-		if (!strcmp(name, "vdso_fake_sections")) {
-			if (fake_sections_value)
-				fail("duplicate vdso_fake_sections\n");
-			fake_sections_value = GET_LE(&sym->st_value);
-			fake_sections_size = GET_LE(&sym->st_size);
+		if (!strcmp(name, "fake_shstrtab")) {
+			ELF(Shdr) *sh;
+
+			fake_sections.in_shstrndx = GET_LE(&sym->st_shndx);
+			fake_sections.shstrtab = addr + GET_LE(&sym->st_value);
+			fake_sections.shstrtab_len = GET_LE(&sym->st_size);
+			sh = addr + GET_LE(&hdr->e_shoff) +
+				GET_LE(&hdr->e_shentsize) *
+				fake_sections.in_shstrndx;
+			fake_sections.shstr_offset = GET_LE(&sym->st_value) -
+				GET_LE(&sh->sh_addr);
 		}
 	}
 
+	/* Build the output section table. */
+	if (!syms[sym_VDSO_FAKE_SECTION_TABLE_START] ||
+	    !syms[sym_VDSO_FAKE_SECTION_TABLE_END])
+		fail("couldn't find fake section table\n");
+	if ((syms[sym_VDSO_FAKE_SECTION_TABLE_END] -
+	     syms[sym_VDSO_FAKE_SECTION_TABLE_START]) % sizeof(ELF(Shdr)))
+		fail("fake section table size isn't a multiple of sizeof(Shdr)\n");
+	fake_sections.table = addr + syms[sym_VDSO_FAKE_SECTION_TABLE_START];
+	fake_sections.table_offset = syms[sym_VDSO_FAKE_SECTION_TABLE_START];
+	fake_sections.max_count = (syms[sym_VDSO_FAKE_SECTION_TABLE_END] -
+				   syms[sym_VDSO_FAKE_SECTION_TABLE_START]) /
+		sizeof(ELF(Shdr));
+
+	BITSFUNC(init_sections)(&fake_sections);
+	for (i = 0; i < GET_LE(&hdr->e_shnum); i++) {
+		ELF(Shdr) *sh = addr + GET_LE(&hdr->e_shoff) +
+			GET_LE(&hdr->e_shentsize) * i;
+		BITSFUNC(copy_section)(&fake_sections, i, sh,
+				       secstrings + GET_LE(&sh->sh_name));
+	}
+	if (!fake_sections.out_shstrndx)
+		fail("didn't generate shstrndx?!?\n");
+
+	PUT_LE(&hdr->e_shoff, fake_sections.table_offset);
+	PUT_LE(&hdr->e_shentsize, sizeof(ELF(Shdr)));
+	PUT_LE(&hdr->e_shnum, fake_sections.count);
+	PUT_LE(&hdr->e_shstrndx, fake_sections.out_shstrndx);
+
 	/* Validate mapping addresses. */
 	for (i = 0; i < sizeof(special_pages) / sizeof(special_pages[0]); i++) {
 		if (!syms[i])
@@ -113,25 +257,17 @@ static void BITSFUNC(go)(void *addr, size_t len,
 
 		if (syms[i] % 4096)
 			fail("%s must be a multiple of 4096\n",
-			     required_syms[i]);
+			     required_syms[i].name);
 		if (syms[i] < data_size)
 			fail("%s must be after the text mapping\n",
-			     required_syms[i]);
+			     required_syms[i].name);
 		if (syms[sym_end_mapping] < syms[i] + 4096)
-			fail("%s overruns end_mapping\n", required_syms[i]);
+			fail("%s overruns end_mapping\n",
+			     required_syms[i].name);
 	}
 	if (syms[sym_end_mapping] % 4096)
 		fail("end_mapping must be a multiple of 4096\n");
 
-	/* Remove sections or use fakes */
-	if (fake_sections_size % sizeof(ELF(Shdr)))
-		fail("vdso_fake_sections size is not a multiple of %ld\n",
-		     (long)sizeof(ELF(Shdr)));
-	PUT_LE(&hdr->e_shoff, fake_sections_value);
-	PUT_LE(&hdr->e_shentsize, fake_sections_value ? sizeof(ELF(Shdr)) : 0);
-	PUT_LE(&hdr->e_shnum, fake_sections_size / sizeof(ELF(Shdr)));
-	PUT_LE(&hdr->e_shstrndx, SHN_UNDEF);
-
 	if (!name) {
 		fwrite(addr, load_size, 1, outfile);
 		return;
@@ -169,9 +305,9 @@ static void BITSFUNC(go)(void *addr, size_t len,
 			(unsigned long)GET_LE(&alt_sec->sh_size));
 	}
 	for (i = 0; i < NSYMS; i++) {
-		if (syms[i])
+		if (required_syms[i].export && syms[i])
 			fprintf(outfile, "\t.sym_%s = 0x%" PRIx64 ",\n",
-				required_syms[i], syms[i]);
+				required_syms[i].name, syms[i]);
 	}
 	fprintf(outfile, "};\n");
 }
diff --git a/arch/x86/vdso/vdso32/vdso-fakesections.c b/arch/x86/vdso/vdso32/vdso-fakesections.c
new file mode 100644
index 0000000..541468e
--- /dev/null
+++ b/arch/x86/vdso/vdso32/vdso-fakesections.c
@@ -0,0 +1 @@
+#include "../vdso-fakesections.c"
diff --git a/arch/x86/vdso/vdsox32.lds.S b/arch/x86/vdso/vdsox32.lds.S
index 46b991b..697c11e 100644
--- a/arch/x86/vdso/vdsox32.lds.S
+++ b/arch/x86/vdso/vdsox32.lds.S
@@ -6,6 +6,8 @@
  * the DSO.
  */
 
+#define BUILD_VDSOX32
+
 #include "vdso-layout.lds.S"
 
 /*
-- 
1.9.3

