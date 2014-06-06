Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaFFVgt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 17:36:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38242 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307AbaFFVgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 17:36:47 -0400
Message-ID: <53923450.9080202@zytor.com>
Date: Fri, 06 Jun 2014 14:36:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@linux.intel.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sasha.levin@oracle.com>,
        Stefani Seibold <stefani@seibold.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [GIT PULL] x86/vdso changes for v3.16
References: <201406042235.s54MZgwP020553@terminus.zytor.com> <20140606140017.afb7f91142f66cb3dd13c186@linux-foundation.org> <CA+55aFyKTbBUM4DJukmW5fiH213D0FbVmrreR9wOtMRmmijQ9Q@mail.gmail.com> <CALCETrWA92Q4ro9eaRkUrebjgQT7B2uj+bK81m9byZnDY_eMxA@mail.gmail.com> <CA+55aFx8ezbe-mCYWp6kM8Nh3oUQd_+SNz6mLoGQtMVDk3EALA@mail.gmail.com> <53922F74.20406@linux.intel.com> <CALCETrXpCMdyPjM6MSbxoi0matoYLfduuSiwmTjGCUU62KOsTw@mail.gmail.com>
In-Reply-To: <CALCETrXpCMdyPjM6MSbxoi0matoYLfduuSiwmTjGCUU62KOsTw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/mixed;
 boundary="------------060707090900010509050502"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060707090900010509050502
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Want to help test this?

I dropped the idea of adding -I$(srctree)/tools/include globally for
right now, because there is a linux/types.h in that directory which
shadows the uapi definition, and that could break some libcs.  That
should almost certainly be fixed.

	-hpa


--------------060707090900010509050502
Content-Type: text/x-patch;
 name="0001-x86-vdso-Use-tools-le_byteshift.h-for-littleendian-a.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-x86-vdso-Use-tools-le_byteshift.h-for-littleendian-a.pa";
 filename*1="tch"

>From 37848b0fcf39503e357b0879553d9a7b24a000fd Mon Sep 17 00:00:00 2001
From: "H. Peter Anvin" <hpa@linux.intel.com>
Date: Fri, 6 Jun 2014 14:30:37 -0700
Subject: [PATCH] x86, vdso: Use <tools/le_byteshift.h> for littleendian access

There are no standard functions for littleendian data (unlike
bigendian data.)  Thus, use <tools/le_byteshift.h> to access
littleendian data members.  Those are fairly inefficient, but it
doesn't matter for this purpose (and can be optimized later.)  This
avoids portability problems.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/20140606140017.afb7f91142f66cb3dd13c186@linux-foundation.org
---
 arch/x86/vdso/Makefile |  1 +
 arch/x86/vdso/vdso2c.c |  8 ++++---
 arch/x86/vdso/vdso2c.h | 62 +++++++++++++++++++++++++-------------------------
 3 files changed, 37 insertions(+), 34 deletions(-)

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
index deabaf5..d5042c6 100644
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
 
 extern void bad_get_le(uint64_t);
 #define LAST_LE(x)							\
-	__builtin_choose_expr(sizeof(x) == 1, (x), bad_get_le(x))
+	__builtin_choose_expr(sizeof(*(x)) == 1, *(x), bad_get_le(x))
 
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
-- 
1.9.3


--------------060707090900010509050502--
