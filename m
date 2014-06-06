Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbaFFWpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 18:45:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38818 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbaFFWpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 18:45:44 -0400
Date: Fri, 6 Jun 2014 15:45:26 -0700
Message-Id: <201406062245.s56MjQh6013059@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/vdso fix for v3.16
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Cc: akpm@linux-foundation.org, hpa@linux.intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, luto@amacapital.net, mingo@kernel.org,
        tglx@linutronix.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This fixes building the vdso code on older Linux systems, and probably
some non-Linux systems.

The following changes since commit a0abcf2e8f8017051830f738ac1bf5ef42703243:

  Merge branch 'x86/vdso' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip into next (2014-06-05 08:05:29 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-vdso-for-linus

for you to fetch changes up to bdfb9bcc25005d06a9c301830bdeb7ca5a0b6ef7:

  x86, vdso: Use <tools/le_byteshift.h> for littleendian access (2014-06-06 14:54:54 -0700)

----------------------------------------------------------------
H. Peter Anvin (1):
      x86, vdso: Use <tools/le_byteshift.h> for littleendian access

 arch/x86/vdso/Makefile |  1 +
 arch/x86/vdso/vdso2c.c | 10 ++++----
 arch/x86/vdso/vdso2c.h | 62 +++++++++++++++++++++++++-------------------------
 3 files changed, 38 insertions(+), 35 deletions(-)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 895d4b1..9769df0 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -59,6 +59,7 @@ VDSO_LDFLAGS_vdso.lds = -m64 -Wl,-soname=linux-vdso.so.1 \
 $(obj)/vdso64.so.dbg: $(src)/vdso.lds $(vobjs) FORCE
 	$(call if_changed,vdso)
 
+HOST_EXTRACFLAGS += -I$(srctree)/tools/include
 hostprogs-y			+= vdso2c
 
 quiet_cmd_vdso2c = VDSO2C  $@
diff --git a/arch/x86/vdso/vdso2c.c b/arch/x86/vdso/vdso2c.c
index deabaf5..450ac6e 100644
--- a/arch/x86/vdso/vdso2c.c
+++ b/arch/x86/vdso/vdso2c.c
@@ -11,6 +11,8 @@
 #include <sys/mman.h>
 #include <sys/types.h>
 
+#include <tools/le_byteshift.h>
+
 #include <linux/elf.h>
 #include <linux/types.h>
 
@@ -56,12 +58,12 @@ static void fail(const char *format, ...)
  */
 #define GLE(x, bits, ifnot)						\
 	__builtin_choose_expr(						\
-		(sizeof(x) == bits/8),					\
-		(__typeof__(x))le##bits##toh(x), ifnot)
+		(sizeof(*(x)) == bits/8),				\
+		(__typeof__(*(x)))get_unaligned_le##bits(x), ifnot)
 
-extern void bad_get_le(uint64_t);
+extern void bad_get_le(void);
 #define LAST_LE(x)							\
-	__builtin_choose_expr(sizeof(x) == 1, (x), bad_get_le(x))
+	__builtin_choose_expr(sizeof(*(x)) == 1, *(x), bad_get_le())
 
 #define GET_LE(x)							\
 	GLE(x, 64, GLE(x, 32, GLE(x, 16, LAST_LE(x))))
diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
index d1e99e1..8a07463 100644
--- a/arch/x86/vdso/vdso2c.h
+++ b/arch/x86/vdso/vdso2c.h
@@ -18,27 +18,27 @@ static void GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 	const char *secstrings;
 	uint64_t syms[NSYMS] = {};
 
-	Elf_Phdr *pt = (Elf_Phdr *)(addr + GET_LE(hdr->e_phoff));
+	Elf_Phdr *pt = (Elf_Phdr *)(addr + GET_LE(&hdr->e_phoff));
 
 	/* Walk the segment table. */
-	for (i = 0; i < GET_LE(hdr->e_phnum); i++) {
-		if (GET_LE(pt[i].p_type) == PT_LOAD) {
+	for (i = 0; i < GET_LE(&hdr->e_phnum); i++) {
+		if (GET_LE(&pt[i].p_type) == PT_LOAD) {
 			if (found_load)
 				fail("multiple PT_LOAD segs\n");
 
-			if (GET_LE(pt[i].p_offset) != 0 ||
-			    GET_LE(pt[i].p_vaddr) != 0)
+			if (GET_LE(&pt[i].p_offset) != 0 ||
+			    GET_LE(&pt[i].p_vaddr) != 0)
 				fail("PT_LOAD in wrong place\n");
 
-			if (GET_LE(pt[i].p_memsz) != GET_LE(pt[i].p_filesz))
+			if (GET_LE(&pt[i].p_memsz) != GET_LE(&pt[i].p_filesz))
 				fail("cannot handle memsz != filesz\n");
 
-			load_size = GET_LE(pt[i].p_memsz);
+			load_size = GET_LE(&pt[i].p_memsz);
 			found_load = 1;
-		} else if (GET_LE(pt[i].p_type) == PT_DYNAMIC) {
-			dyn = addr + GET_LE(pt[i].p_offset);
-			dyn_end = addr + GET_LE(pt[i].p_offset) +
-				GET_LE(pt[i].p_memsz);
+		} else if (GET_LE(&pt[i].p_type) == PT_DYNAMIC) {
+			dyn = addr + GET_LE(&pt[i].p_offset);
+			dyn_end = addr + GET_LE(&pt[i].p_offset) +
+				GET_LE(&pt[i].p_memsz);
 		}
 	}
 	if (!found_load)
@@ -47,24 +47,24 @@ static void GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 
 	/* Walk the dynamic table */
 	for (i = 0; dyn + i < dyn_end &&
-		     GET_LE(dyn[i].d_tag) != DT_NULL; i++) {
-		typeof(dyn[i].d_tag) tag = GET_LE(dyn[i].d_tag);
+		     GET_LE(&dyn[i].d_tag) != DT_NULL; i++) {
+		typeof(dyn[i].d_tag) tag = GET_LE(&dyn[i].d_tag);
 		if (tag == DT_REL || tag == DT_RELSZ ||
 		    tag == DT_RELENT || tag == DT_TEXTREL)
 			fail("vdso image contains dynamic relocations\n");
 	}
 
 	/* Walk the section table */
-	secstrings_hdr = addr + GET_LE(hdr->e_shoff) +
-		GET_LE(hdr->e_shentsize)*GET_LE(hdr->e_shstrndx);
-	secstrings = addr + GET_LE(secstrings_hdr->sh_offset);
-	for (i = 0; i < GET_LE(hdr->e_shnum); i++) {
-		Elf_Shdr *sh = addr + GET_LE(hdr->e_shoff) +
-			GET_LE(hdr->e_shentsize) * i;
-		if (GET_LE(sh->sh_type) == SHT_SYMTAB)
+	secstrings_hdr = addr + GET_LE(&hdr->e_shoff) +
+		GET_LE(&hdr->e_shentsize)*GET_LE(&hdr->e_shstrndx);
+	secstrings = addr + GET_LE(&secstrings_hdr->sh_offset);
+	for (i = 0; i < GET_LE(&hdr->e_shnum); i++) {
+		Elf_Shdr *sh = addr + GET_LE(&hdr->e_shoff) +
+			GET_LE(&hdr->e_shentsize) * i;
+		if (GET_LE(&sh->sh_type) == SHT_SYMTAB)
 			symtab_hdr = sh;
 
-		if (!strcmp(secstrings + GET_LE(sh->sh_name),
+		if (!strcmp(secstrings + GET_LE(&sh->sh_name),
 			    ".altinstructions"))
 			alt_sec = sh;
 	}
@@ -72,25 +72,25 @@ static void GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 	if (!symtab_hdr)
 		fail("no symbol table\n");
 
-	strtab_hdr = addr + GET_LE(hdr->e_shoff) +
-		GET_LE(hdr->e_shentsize) * GET_LE(symtab_hdr->sh_link);
+	strtab_hdr = addr + GET_LE(&hdr->e_shoff) +
+		GET_LE(&hdr->e_shentsize) * GET_LE(&symtab_hdr->sh_link);
 
 	/* Walk the symbol table */
 	for (i = 0;
-	     i < GET_LE(symtab_hdr->sh_size) / GET_LE(symtab_hdr->sh_entsize);
+	     i < GET_LE(&symtab_hdr->sh_size) / GET_LE(&symtab_hdr->sh_entsize);
 	     i++) {
 		int k;
-		Elf_Sym *sym = addr + GET_LE(symtab_hdr->sh_offset) +
-			GET_LE(symtab_hdr->sh_entsize) * i;
-		const char *name = addr + GET_LE(strtab_hdr->sh_offset) +
-			GET_LE(sym->st_name);
+		Elf_Sym *sym = addr + GET_LE(&symtab_hdr->sh_offset) +
+			GET_LE(&symtab_hdr->sh_entsize) * i;
+		const char *name = addr + GET_LE(&strtab_hdr->sh_offset) +
+			GET_LE(&sym->st_name);
 		for (k = 0; k < NSYMS; k++) {
 			if (!strcmp(name, required_syms[k])) {
 				if (syms[k]) {
 					fail("duplicate symbol %s\n",
 					     required_syms[k]);
 				}
-				syms[k] = GET_LE(sym->st_value);
+				syms[k] = GET_LE(&sym->st_value);
 			}
 		}
 	}
@@ -150,9 +150,9 @@ static void GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 	fprintf(outfile, "\t},\n");
 	if (alt_sec) {
 		fprintf(outfile, "\t.alt = %lu,\n",
-			(unsigned long)GET_LE(alt_sec->sh_offset));
+			(unsigned long)GET_LE(&alt_sec->sh_offset));
 		fprintf(outfile, "\t.alt_len = %lu,\n",
-			(unsigned long)GET_LE(alt_sec->sh_size));
+			(unsigned long)GET_LE(&alt_sec->sh_size));
 	}
 	for (i = 0; i < NSYMS; i++) {
 		if (syms[i])
