Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288AbaFRXBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:01:43 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:64145 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408AbaFRXAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:00:09 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Josh Boyer <jwboyer@fedoraproject.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 2/5] x86,vdso2c: Use better macros for ELF bitness
Date: Wed, 18 Jun 2014 15:59:47 -0700
Message-Id: <d953cd2e70ceee1400985d091188cdd65fba2f05.1403129369.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1403129369.git.luto@amacapital.net>
References: <cover.1403129369.git.luto@amacapital.net>
In-Reply-To: <cover.1403129369.git.luto@amacapital.net>
References: <cover.1403129369.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than using a separate macro for each replacement, use generic
macros.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/vdso/vdso2c.c | 42 +++++++++++++-----------------------------
 arch/x86/vdso/vdso2c.h | 23 ++++++++++++-----------
 2 files changed, 25 insertions(+), 40 deletions(-)

diff --git a/arch/x86/vdso/vdso2c.c b/arch/x86/vdso/vdso2c.c
index 7a6bf50..7343899 100644
--- a/arch/x86/vdso/vdso2c.c
+++ b/arch/x86/vdso/vdso2c.c
@@ -83,37 +83,21 @@ extern void bad_put_le(void);
 
 #define NSYMS (sizeof(required_syms) / sizeof(required_syms[0]))
 
-#define BITS 64
-#define GOFUNC go64
-#define Elf_Ehdr Elf64_Ehdr
-#define Elf_Shdr Elf64_Shdr
-#define Elf_Phdr Elf64_Phdr
-#define Elf_Sym Elf64_Sym
-#define Elf_Dyn Elf64_Dyn
+#define BITSFUNC3(name, bits) name##bits
+#define BITSFUNC2(name, bits) BITSFUNC3(name, bits)
+#define BITSFUNC(name) BITSFUNC2(name, ELF_BITS)
+
+#define ELF_BITS_XFORM2(bits, x) Elf##bits##_##x
+#define ELF_BITS_XFORM(bits, x) ELF_BITS_XFORM2(bits, x)
+#define ELF(x) ELF_BITS_XFORM(ELF_BITS, x)
+
+#define ELF_BITS 64
 #include "vdso2c.h"
-#undef BITS
-#undef GOFUNC
-#undef Elf_Ehdr
-#undef Elf_Shdr
-#undef Elf_Phdr
-#undef Elf_Sym
-#undef Elf_Dyn
-
-#define BITS 32
-#define GOFUNC go32
-#define Elf_Ehdr Elf32_Ehdr
-#define Elf_Shdr Elf32_Shdr
-#define Elf_Phdr Elf32_Phdr
-#define Elf_Sym Elf32_Sym
-#define Elf_Dyn Elf32_Dyn
+#undef ELF_BITS
+
+#define ELF_BITS 32
 #include "vdso2c.h"
-#undef BITS
-#undef GOFUNC
-#undef Elf_Ehdr
-#undef Elf_Shdr
-#undef Elf_Phdr
-#undef Elf_Sym
-#undef Elf_Dyn
+#undef ELF_BITS
 
 static void go(void *addr, size_t len, FILE *outfile, const char *name)
 {
diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
index c6eefaf..8e185ce 100644
--- a/arch/x86/vdso/vdso2c.h
+++ b/arch/x86/vdso/vdso2c.h
@@ -4,23 +4,24 @@
  * are built for 32-bit userspace.
  */
 
-static void GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
+static void BITSFUNC(go)(void *addr, size_t len,
+			 FILE *outfile, const char *name)
 {
 	int found_load = 0;
 	unsigned long load_size = -1;  /* Work around bogus warning */
 	unsigned long data_size;
-	Elf_Ehdr *hdr = (Elf_Ehdr *)addr;
+	ELF(Ehdr) *hdr = (ELF(Ehdr) *)addr;
 	int i;
 	unsigned long j;
-	Elf_Shdr *symtab_hdr = NULL, *strtab_hdr, *secstrings_hdr,
+	ELF(Shdr) *symtab_hdr = NULL, *strtab_hdr, *secstrings_hdr,
 		*alt_sec = NULL;
-	Elf_Dyn *dyn = 0, *dyn_end = 0;
+	ELF(Dyn) *dyn = 0, *dyn_end = 0;
 	const char *secstrings;
 	uint64_t syms[NSYMS] = {};
 
 	uint64_t fake_sections_value = 0, fake_sections_size = 0;
 
-	Elf_Phdr *pt = (Elf_Phdr *)(addr + GET_LE(&hdr->e_phoff));
+	ELF(Phdr) *pt = (ELF(Phdr) *)(addr + GET_LE(&hdr->e_phoff));
 
 	/* Walk the segment table. */
 	for (i = 0; i < GET_LE(&hdr->e_phnum); i++) {
@@ -61,7 +62,7 @@ static void GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 		GET_LE(&hdr->e_shentsize)*GET_LE(&hdr->e_shstrndx);
 	secstrings = addr + GET_LE(&secstrings_hdr->sh_offset);
 	for (i = 0; i < GET_LE(&hdr->e_shnum); i++) {
-		Elf_Shdr *sh = addr + GET_LE(&hdr->e_shoff) +
+		ELF(Shdr) *sh = addr + GET_LE(&hdr->e_shoff) +
 			GET_LE(&hdr->e_shentsize) * i;
 		if (GET_LE(&sh->sh_type) == SHT_SYMTAB)
 			symtab_hdr = sh;
@@ -82,7 +83,7 @@ static void GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 	     i < GET_LE(&symtab_hdr->sh_size) / GET_LE(&symtab_hdr->sh_entsize);
 	     i++) {
 		int k;
-		Elf_Sym *sym = addr + GET_LE(&symtab_hdr->sh_offset) +
+		ELF(Sym) *sym = addr + GET_LE(&symtab_hdr->sh_offset) +
 			GET_LE(&symtab_hdr->sh_entsize) * i;
 		const char *name = addr + GET_LE(&strtab_hdr->sh_offset) +
 			GET_LE(&sym->st_name);
@@ -123,12 +124,12 @@ static void GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 		fail("end_mapping must be a multiple of 4096\n");
 
 	/* Remove sections or use fakes */
-	if (fake_sections_size % sizeof(Elf_Shdr))
+	if (fake_sections_size % sizeof(ELF(Shdr)))
 		fail("vdso_fake_sections size is not a multiple of %ld\n",
-		     (long)sizeof(Elf_Shdr));
+		     (long)sizeof(ELF(Shdr)));
 	PUT_LE(&hdr->e_shoff, fake_sections_value);
-	PUT_LE(&hdr->e_shentsize, fake_sections_value ? sizeof(Elf_Shdr) : 0);
-	PUT_LE(&hdr->e_shnum, fake_sections_size / sizeof(Elf_Shdr));
+	PUT_LE(&hdr->e_shentsize, fake_sections_value ? sizeof(ELF(Shdr)) : 0);
+	PUT_LE(&hdr->e_shnum, fake_sections_size / sizeof(ELF(Shdr)));
 	PUT_LE(&hdr->e_shstrndx, SHN_UNDEF);
 
 	if (!name) {
-- 
1.9.3

