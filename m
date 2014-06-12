Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaFLSsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 14:48:01 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33673 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaFLSr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 14:47:58 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: <hpa@zytor.com>, Kui Zhang <kuizhang@gmail.com>
Cc: x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 3/3] x86,vdso: Hack to keep 64-bit Go programs working
Date: Thu, 12 Jun 2014 11:47:44 -0700
Message-Id: <ad9f313026949247ed2067631b4e5c27c1935064.1402598632.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1402598632.git.luto@amacapital.net>
References: <cover.1402598632.git.luto@amacapital.net>
In-Reply-To: <cover.1402598632.git.luto@amacapital.net>
References: <cover.1402598632.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Go runtime has a buggy vDSO parser that currently segfaults.
This writes an empty SHT_DYNSYM entry that causes Go's runtime to
malfunction by thinking that the vDSO is empty rather than
malfunctioning by running off the end and segfaulting.

This is currently broken for big-endian build hosts.  The hack
should also be disabled for x32, but I'm not sure what the right way
to do that is.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/vdso/Makefile            |  2 +-
 arch/x86/vdso/vdso-fakesections.c | 20 ++++++++++++++++++++
 arch/x86/vdso/vdso2c.h            | 21 +++++++++++++++++----
 3 files changed, 38 insertions(+), 5 deletions(-)
 create mode 100644 arch/x86/vdso/vdso-fakesections.c

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 9769df0..ffdeb5b 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -15,7 +15,7 @@ vdso-install-$(VDSO32-y)	+= $(vdso32-images)
 
 
 # files to link into the vdso
-vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o
+vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o vdso-fakesections.o
 
 vobjs-$(VDSOX32-y) += $(vobjx32s-compat)
 
diff --git a/arch/x86/vdso/vdso-fakesections.c b/arch/x86/vdso/vdso-fakesections.c
new file mode 100644
index 0000000..ef75ece
--- /dev/null
+++ b/arch/x86/vdso/vdso-fakesections.c
@@ -0,0 +1,20 @@
+/*
+ * Copyright 2014 Andy Lutomirski
+ * Subject to the GNU Public License, v.2
+ *
+ * Hack to keep broken Go programs working.
+ */
+
+#if __x86_64__  /* hack only needed for the 64-bit vDSO */
+
+#include <linux/elf.h>
+
+extern const __visible struct elf64_shdr vdso_fake_sections[];
+const __visible struct elf64_shdr vdso_fake_sections[] = {
+	{
+		.sh_type = SHT_DYNSYM,
+		.sh_entsize = sizeof(Elf64_Sym),
+	}
+};
+
+#endif
diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
index d9f6f61..43d9ab1 100644
--- a/arch/x86/vdso/vdso2c.h
+++ b/arch/x86/vdso/vdso2c.h
@@ -18,6 +18,8 @@ static void GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 	const char *secstrings;
 	uint64_t syms[NSYMS] = {};
 
+	uint64_t fake_sections_value = 0, fake_sections_size = 0;
+
 	Elf_Phdr *pt = (Elf_Phdr *)(addr + GET_LE(&hdr->e_phoff));
 
 	/* Walk the segment table. */
@@ -84,6 +86,7 @@ static void GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 			GET_LE(&symtab_hdr->sh_entsize) * i;
 		const char *name = addr + GET_LE(&strtab_hdr->sh_offset) +
 			GET_LE(&sym->st_name);
+
 		for (k = 0; k < NSYMS; k++) {
 			if (!strcmp(name, required_syms[k])) {
 				if (syms[k]) {
@@ -93,6 +96,13 @@ static void GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 				syms[k] = GET_LE(&sym->st_value);
 			}
 		}
+
+		if (!strcmp(name, "vdso_fake_sections")) {
+			if (fake_sections_value)
+				fail("duplicate vdso_fake_sections\n");
+			fake_sections_value = GET_LE(&sym->st_value);
+			fake_sections_size = GET_LE(&sym->st_size);
+		}
 	}
 
 	/* Validate mapping addresses. */
@@ -112,10 +122,13 @@ static void GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 	if (syms[sym_end_mapping] % 4096)
 		fail("end_mapping must be a multiple of 4096\n");
 
-	/* Remove sections. */
-	hdr->e_shoff = 0;
-	hdr->e_shentsize = 0;
-	hdr->e_shnum = 0;
+	/* Remove sections or use fakes */
+	if (fake_sections_size % sizeof(Elf_Shdr))
+		fail("vdso_fake_sections size is not a multiple of %ld\n",
+		     (long)sizeof(Elf_Shdr));
+	hdr->e_shoff = fake_sections_value;
+	hdr->e_shentsize = fake_sections_value ? sizeof(Elf_Shdr) : 0;
+	hdr->e_shnum = fake_sections_size / sizeof(Elf_Shdr);
 	hdr->e_shstrndx = SHN_UNDEF; /* SHN_UNDEF == 0 */
 
 	if (!name) {
-- 
1.9.3

