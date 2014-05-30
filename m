Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933682AbaE3PtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:49:20 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:62127 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933148AbaE3Ps5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:48:57 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 2/2] x86,vdso: Fix cross-compilation from big-endian architectures
Date: Fri, 30 May 2014 08:48:49 -0700
Message-Id: <2cf258df123cb24bad63c274c8563c050547d99d.1401464755.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1401464755.git.luto@amacapital.net>
References: <CALCETrXef77JLoEp5hCXSdMAk7usWsL-sUG6NrcgLgrz3krfag@mail.gmail.com>
 <cover.1401464755.git.luto@amacapital.net>
In-Reply-To: <cover.1401464755.git.luto@amacapital.net>
References: <cover.1401464755.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a macro GET(x) to convert x from big-endian to
little-endian.  Hopefully I put it everywhere it needs to go and got
all the cases needed for everyone's linux/elf.h.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/vdso/vdso2c.c | 15 ++++++++++++
 arch/x86/vdso/vdso2c.h | 63 ++++++++++++++++++++++++++++----------------------
 2 files changed, 50 insertions(+), 28 deletions(-)

diff --git a/arch/x86/vdso/vdso2c.c b/arch/x86/vdso/vdso2c.c
index fe8bfbf..de19ced 100644
--- a/arch/x86/vdso/vdso2c.c
+++ b/arch/x86/vdso/vdso2c.c
@@ -51,6 +51,21 @@ static void fail(const char *format, ...)
 	va_end(ap);
 }
 
+/*
+ * Evil macros to do a little-endian read.
+ */
+#define __GET_TYPE(x, type, bits, ifnot)				\
+	__builtin_choose_expr(						\
+		__builtin_types_compatible_p(typeof(x), type),		\
+		le##bits##toh((x)), ifnot)
+
+extern void bad_get(uint64_t);
+
+#define GET(x)								\
+	__GET_TYPE((x), __u32, 32, __GET_TYPE((x), __u64, 64,		\
+	__GET_TYPE((x), __s32, 32, __GET_TYPE((x), __s64, 64,		\
+	__GET_TYPE((x), __u16, 16, bad_get(x))))))
+
 #define NSYMS (sizeof(required_syms) / sizeof(required_syms[0]))
 
 #define BITS 64
diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
index 26a7c1f..f0475da 100644
--- a/arch/x86/vdso/vdso2c.h
+++ b/arch/x86/vdso/vdso2c.h
@@ -18,25 +18,27 @@ static void GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 	const char *secstrings;
 	uint64_t syms[NSYMS] = {};
 
-	Elf_Phdr *pt = (Elf_Phdr *)(addr + hdr->e_phoff);
+	Elf_Phdr *pt = (Elf_Phdr *)(addr + GET(hdr->e_phoff));
 
 	/* Walk the segment table. */
-	for (i = 0; i < hdr->e_phnum; i++) {
-		if (pt[i].p_type == PT_LOAD) {
+	for (i = 0; i < GET(hdr->e_phnum); i++) {
+		if (GET(pt[i].p_type) == PT_LOAD) {
 			if (found_load)
 				fail("multiple PT_LOAD segs\n");
 
-			if (pt[i].p_offset != 0 || pt[i].p_vaddr != 0)
+			if (GET(pt[i].p_offset) != 0 ||
+			    GET(pt[i].p_vaddr) != 0)
 				fail("PT_LOAD in wrong place\n");
 
-			if (pt[i].p_memsz != pt[i].p_filesz)
+			if (GET(pt[i].p_memsz) != GET(pt[i].p_filesz))
 				fail("cannot handle memsz != filesz\n");
 
-			load_size = pt[i].p_memsz;
+			load_size = GET(pt[i].p_memsz);
 			found_load = 1;
-		} else if (pt[i].p_type == PT_DYNAMIC) {
-			dyn = addr + pt[i].p_offset;
-			dyn_end = addr + pt[i].p_offset + pt[i].p_memsz;
+		} else if (GET(pt[i].p_type) == PT_DYNAMIC) {
+			dyn = addr + GET(pt[i].p_offset);
+			dyn_end = addr + GET(pt[i].p_offset) +
+				GET(pt[i].p_memsz);
 		}
 	}
 	if (!found_load)
@@ -44,43 +46,48 @@ static void GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 	data_size = (load_size + 4095) / 4096 * 4096;
 
 	/* Walk the dynamic table */
-	for (i = 0; dyn + i < dyn_end && dyn[i].d_tag != DT_NULL; i++) {
-		if (dyn[i].d_tag == DT_REL || dyn[i].d_tag == DT_RELSZ ||
-		    dyn[i].d_tag == DT_RELENT || dyn[i].d_tag == DT_TEXTREL)
+	for (i = 0; dyn + i < dyn_end && GET(dyn[i].d_tag) != DT_NULL; i++) {
+		typeof(dyn[i].d_tag) tag = GET(dyn[i].d_tag);
+		if (tag == DT_REL || tag == DT_RELSZ ||
+		    tag == DT_RELENT || tag == DT_TEXTREL)
 			fail("vdso image contains dynamic relocations\n");
 	}
 
 	/* Walk the section table */
-	secstrings_hdr = addr + hdr->e_shoff + hdr->e_shentsize*hdr->e_shstrndx;
-	secstrings = addr + secstrings_hdr->sh_offset;
-	for (i = 0; i < hdr->e_shnum; i++) {
-		Elf_Shdr *sh = addr + hdr->e_shoff + hdr->e_shentsize * i;
-		if (sh->sh_type == SHT_SYMTAB)
+	secstrings_hdr = addr + GET(hdr->e_shoff) +
+		GET(hdr->e_shentsize)*GET(hdr->e_shstrndx);
+	secstrings = addr + GET(secstrings_hdr->sh_offset);
+	for (i = 0; i < GET(hdr->e_shnum); i++) {
+		Elf_Shdr *sh = addr + GET(hdr->e_shoff) +
+			GET(hdr->e_shentsize) * i;
+		if (GET(sh->sh_type) == SHT_SYMTAB)
 			symtab_hdr = sh;
 
-		if (!strcmp(secstrings + sh->sh_name, ".altinstructions"))
+		if (!strcmp(secstrings + GET(sh->sh_name), ".altinstructions"))
 			alt_sec = sh;
 	}
 
 	if (!symtab_hdr)
 		fail("no symbol table\n");
 
-	strtab_hdr = addr + hdr->e_shoff +
-		hdr->e_shentsize * symtab_hdr->sh_link;
+	strtab_hdr = addr + GET(hdr->e_shoff) +
+		GET(hdr->e_shentsize) * GET(symtab_hdr->sh_link);
 
 	/* Walk the symbol table */
-	for (i = 0; i < symtab_hdr->sh_size / symtab_hdr->sh_entsize; i++) {
+	for (i = 0; i < GET(symtab_hdr->sh_size) / GET(symtab_hdr->sh_entsize);
+	     i++) {
 		int k;
-		Elf_Sym *sym = addr + symtab_hdr->sh_offset +
-			symtab_hdr->sh_entsize * i;
-		const char *name = addr + strtab_hdr->sh_offset + sym->st_name;
+		Elf_Sym *sym = addr + GET(symtab_hdr->sh_offset) +
+			GET(symtab_hdr->sh_entsize) * i;
+		const char *name = addr + GET(strtab_hdr->sh_offset) +
+			GET(sym->st_name);
 		for (k = 0; k < NSYMS; k++) {
 			if (!strcmp(name, required_syms[k])) {
 				if (syms[k]) {
 					fail("duplicate symbol %s\n",
 					     required_syms[k]);
 				}
-				syms[k] = sym->st_value;
+				syms[k] = GET(sym->st_value);
 			}
 		}
 	}
@@ -106,7 +113,7 @@ static void GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 	hdr->e_shoff = 0;
 	hdr->e_shentsize = 0;
 	hdr->e_shnum = 0;
-	hdr->e_shstrndx = SHN_UNDEF;
+	hdr->e_shstrndx = htole16(SHN_UNDEF);
 
 	if (!name) {
 		fwrite(addr, load_size, 1, outfile);
@@ -140,9 +147,9 @@ static void GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 	fprintf(outfile, "\t},\n");
 	if (alt_sec) {
 		fprintf(outfile, "\t.alt = %lu,\n",
-			(unsigned long)alt_sec->sh_offset);
+			(unsigned long)GET(alt_sec->sh_offset));
 		fprintf(outfile, "\t.alt_len = %lu,\n",
-			(unsigned long)alt_sec->sh_size);
+			(unsigned long)GET(alt_sec->sh_size));
 	}
 	for (i = 0; i < NSYMS; i++) {
 		if (syms[i])
-- 
1.9.3

