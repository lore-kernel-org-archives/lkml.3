Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935122AbaEaDKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 23:10:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50576 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935070AbaEaDKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 23:10:19 -0400
Date: Fri, 30 May 2014 20:10:07 -0700
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-e002e99ea4b07c8446d8e1ca892c60f44630643e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <2cf258df123cb24bad63c274c8563c050547d99d.1401464755.git.luto@amacapital.net>
References: <2cf258df123cb24bad63c274c8563c050547d99d.1401464755.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86/vdso, build: Make LE access macros clearer,
  host-safe
Git-Commit-ID: e002e99ea4b07c8446d8e1ca892c60f44630643e
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

Commit-ID:  e002e99ea4b07c8446d8e1ca892c60f44630643e
Gitweb:     http://git.kernel.org/tip/e002e99ea4b07c8446d8e1ca892c60f44630643e
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 30 May 2014 17:03:22 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 30 May 2014 17:03:22 -0700

x86/vdso, build: Make LE access macros clearer, host-safe

Make it a little clearer what the littleendian access macros in
vdso2c.[ch] actually do.  This way they can probably also be moved to
a central location (e.g. tools/include) for the benefit of other host
tools.

We should avoid implementation namespace symbols when writing code
that is compiling for the compiler host, so avoid names starting with
double underscore or underscore-capital.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/2cf258df123cb24bad63c274c8563c050547d99d.1401464755.git.luto@amacapital.net
---
 arch/x86/vdso/vdso2c.c | 16 ++++++-------
 arch/x86/vdso/vdso2c.h | 65 ++++++++++++++++++++++++++------------------------
 2 files changed, 42 insertions(+), 39 deletions(-)

diff --git a/arch/x86/vdso/vdso2c.c b/arch/x86/vdso/vdso2c.c
index de19ced..a09d5a8 100644
--- a/arch/x86/vdso/vdso2c.c
+++ b/arch/x86/vdso/vdso2c.c
@@ -54,17 +54,17 @@ static void fail(const char *format, ...)
 /*
  * Evil macros to do a little-endian read.
  */
-#define __GET_TYPE(x, type, bits, ifnot)				\
+#define GLE(x, bits, ifnot)						\
 	__builtin_choose_expr(						\
-		__builtin_types_compatible_p(typeof(x), type),		\
-		le##bits##toh((x)), ifnot)
+		(sizeof(x) == bits/8),					\
+		(__typeof__(x))le##bits##toh(x), ifnot)
 
-extern void bad_get(uint64_t);
+extern void bad_get_le(uint64_t);
+#define LAST_LE(x)							\
+	__builtin_choose_expr(sizeof(x) == 1, (x), bad_le(x))
 
-#define GET(x)								\
-	__GET_TYPE((x), __u32, 32, __GET_TYPE((x), __u64, 64,		\
-	__GET_TYPE((x), __s32, 32, __GET_TYPE((x), __s64, 64,		\
-	__GET_TYPE((x), __u16, 16, bad_get(x))))))
+#define GET_LE(x)							\
+	GLE(x, 64, GLE(x, 32, GLE(x, 16, LAST_LE(x))))
 
 #define NSYMS (sizeof(required_syms) / sizeof(required_syms[0]))
 
diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
index f0475da..d1e99e1 100644
--- a/arch/x86/vdso/vdso2c.h
+++ b/arch/x86/vdso/vdso2c.h
@@ -18,27 +18,27 @@ static void GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 	const char *secstrings;
 	uint64_t syms[NSYMS] = {};
 
-	Elf_Phdr *pt = (Elf_Phdr *)(addr + GET(hdr->e_phoff));
+	Elf_Phdr *pt = (Elf_Phdr *)(addr + GET_LE(hdr->e_phoff));
 
 	/* Walk the segment table. */
-	for (i = 0; i < GET(hdr->e_phnum); i++) {
-		if (GET(pt[i].p_type) == PT_LOAD) {
+	for (i = 0; i < GET_LE(hdr->e_phnum); i++) {
+		if (GET_LE(pt[i].p_type) == PT_LOAD) {
 			if (found_load)
 				fail("multiple PT_LOAD segs\n");
 
-			if (GET(pt[i].p_offset) != 0 ||
-			    GET(pt[i].p_vaddr) != 0)
+			if (GET_LE(pt[i].p_offset) != 0 ||
+			    GET_LE(pt[i].p_vaddr) != 0)
 				fail("PT_LOAD in wrong place\n");
 
-			if (GET(pt[i].p_memsz) != GET(pt[i].p_filesz))
+			if (GET_LE(pt[i].p_memsz) != GET_LE(pt[i].p_filesz))
 				fail("cannot handle memsz != filesz\n");
 
-			load_size = GET(pt[i].p_memsz);
+			load_size = GET_LE(pt[i].p_memsz);
 			found_load = 1;
-		} else if (GET(pt[i].p_type) == PT_DYNAMIC) {
-			dyn = addr + GET(pt[i].p_offset);
-			dyn_end = addr + GET(pt[i].p_offset) +
-				GET(pt[i].p_memsz);
+		} else if (GET_LE(pt[i].p_type) == PT_DYNAMIC) {
+			dyn = addr + GET_LE(pt[i].p_offset);
+			dyn_end = addr + GET_LE(pt[i].p_offset) +
+				GET_LE(pt[i].p_memsz);
 		}
 	}
 	if (!found_load)
@@ -46,48 +46,51 @@ static void GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 	data_size = (load_size + 4095) / 4096 * 4096;
 
 	/* Walk the dynamic table */
-	for (i = 0; dyn + i < dyn_end && GET(dyn[i].d_tag) != DT_NULL; i++) {
-		typeof(dyn[i].d_tag) tag = GET(dyn[i].d_tag);
+	for (i = 0; dyn + i < dyn_end &&
+		     GET_LE(dyn[i].d_tag) != DT_NULL; i++) {
+		typeof(dyn[i].d_tag) tag = GET_LE(dyn[i].d_tag);
 		if (tag == DT_REL || tag == DT_RELSZ ||
 		    tag == DT_RELENT || tag == DT_TEXTREL)
 			fail("vdso image contains dynamic relocations\n");
 	}
 
 	/* Walk the section table */
-	secstrings_hdr = addr + GET(hdr->e_shoff) +
-		GET(hdr->e_shentsize)*GET(hdr->e_shstrndx);
-	secstrings = addr + GET(secstrings_hdr->sh_offset);
-	for (i = 0; i < GET(hdr->e_shnum); i++) {
-		Elf_Shdr *sh = addr + GET(hdr->e_shoff) +
-			GET(hdr->e_shentsize) * i;
-		if (GET(sh->sh_type) == SHT_SYMTAB)
+	secstrings_hdr = addr + GET_LE(hdr->e_shoff) +
+		GET_LE(hdr->e_shentsize)*GET_LE(hdr->e_shstrndx);
+	secstrings = addr + GET_LE(secstrings_hdr->sh_offset);
+	for (i = 0; i < GET_LE(hdr->e_shnum); i++) {
+		Elf_Shdr *sh = addr + GET_LE(hdr->e_shoff) +
+			GET_LE(hdr->e_shentsize) * i;
+		if (GET_LE(sh->sh_type) == SHT_SYMTAB)
 			symtab_hdr = sh;
 
-		if (!strcmp(secstrings + GET(sh->sh_name), ".altinstructions"))
+		if (!strcmp(secstrings + GET_LE(sh->sh_name),
+			    ".altinstructions"))
 			alt_sec = sh;
 	}
 
 	if (!symtab_hdr)
 		fail("no symbol table\n");
 
-	strtab_hdr = addr + GET(hdr->e_shoff) +
-		GET(hdr->e_shentsize) * GET(symtab_hdr->sh_link);
+	strtab_hdr = addr + GET_LE(hdr->e_shoff) +
+		GET_LE(hdr->e_shentsize) * GET_LE(symtab_hdr->sh_link);
 
 	/* Walk the symbol table */
-	for (i = 0; i < GET(symtab_hdr->sh_size) / GET(symtab_hdr->sh_entsize);
+	for (i = 0;
+	     i < GET_LE(symtab_hdr->sh_size) / GET_LE(symtab_hdr->sh_entsize);
 	     i++) {
 		int k;
-		Elf_Sym *sym = addr + GET(symtab_hdr->sh_offset) +
-			GET(symtab_hdr->sh_entsize) * i;
-		const char *name = addr + GET(strtab_hdr->sh_offset) +
-			GET(sym->st_name);
+		Elf_Sym *sym = addr + GET_LE(symtab_hdr->sh_offset) +
+			GET_LE(symtab_hdr->sh_entsize) * i;
+		const char *name = addr + GET_LE(strtab_hdr->sh_offset) +
+			GET_LE(sym->st_name);
 		for (k = 0; k < NSYMS; k++) {
 			if (!strcmp(name, required_syms[k])) {
 				if (syms[k]) {
 					fail("duplicate symbol %s\n",
 					     required_syms[k]);
 				}
-				syms[k] = GET(sym->st_value);
+				syms[k] = GET_LE(sym->st_value);
 			}
 		}
 	}
@@ -147,9 +150,9 @@ static void GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 	fprintf(outfile, "\t},\n");
 	if (alt_sec) {
 		fprintf(outfile, "\t.alt = %lu,\n",
-			(unsigned long)GET(alt_sec->sh_offset));
+			(unsigned long)GET_LE(alt_sec->sh_offset));
 		fprintf(outfile, "\t.alt_len = %lu,\n",
-			(unsigned long)GET(alt_sec->sh_size));
+			(unsigned long)GET_LE(alt_sec->sh_size));
 	}
 	for (i = 0; i < NSYMS; i++) {
 		if (syms[i])
