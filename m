Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbaFMAtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 20:49:55 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:61341 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbaFMAtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 20:49:51 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: <hpa@zytor.com>, Kui Zhang <kuizhang@gmail.com>
Cc: x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 3/3] x86,vdso: Hack to keep 64-bit Go programs working
Date: Thu, 12 Jun 2014 17:49:41 -0700
Message-Id: <d10618176c4bd39b457a5e85c497295c90cab1bc.1402620327.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1402620327.git.luto@amacapital.net>
References: <cover.1402620327.git.luto@amacapital.net>
In-Reply-To: <cover.1402620327.git.luto@amacapital.net>
References: <cover.1402620327.git.luto@amacapital.net>
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
 arch/x86/vdso/Makefile            | 18 ++++++++++--------
 arch/x86/vdso/vdso-fakesections.c | 32 ++++++++++++++++++++++++++++++++
 arch/x86/vdso/vdso2c.h            | 23 ++++++++++++++++++-----
 3 files changed, 60 insertions(+), 13 deletions(-)
 create mode 100644 arch/x86/vdso/vdso-fakesections.c

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 9769df0..ba6fc27 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -15,12 +15,8 @@ vdso-install-$(VDSO32-y)	+= $(vdso32-images)
 
 
 # files to link into the vdso
-vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o
-
-vobjs-$(VDSOX32-y) += $(vobjx32s-compat)
-
-# Filter out x32 objects.
-vobj64s := $(filter-out $(vobjx32s-compat),$(vobjs-y))
+vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o vdso-fakesections.o
+vobjs-nox32 := vdso-fakesections.o
 
 # files to link into kernel
 obj-y				+= vma.o
@@ -34,7 +30,7 @@ vdso_img-$(VDSO32-y)		+= 32-sysenter
 
 obj-$(VDSO32-y)			+= vdso32-setup.o
 
-vobjs := $(foreach F,$(vobj64s),$(obj)/$F)
+vobjs := $(foreach F,$(vobjs-y),$(obj)/$F)
 
 $(obj)/vdso.o: $(obj)/vdso.so
 
@@ -104,7 +100,13 @@ VDSO_LDFLAGS_vdsox32.lds = -Wl,-m,elf32_x86_64 \
 			   -Wl,-z,max-page-size=4096 \
 			   -Wl,-z,common-page-size=4096
 
-vobjx32s-y := $(vobj64s:.o=-x32.o)
+# 64-bit objects to re-brand as x32
+vobjs64-for-x32 := $(filter-out $(vobjs-nox32),$(vobjs-y))
+
+# x32-rebranded versions
+vobjx32s-y := $(vobjs64-for-x32:.o=-x32.o)
+
+# same thing, but in the output directory
 vobjx32s := $(foreach F,$(vobjx32s-y),$(obj)/$F)
 
 # Convert 64bit object file to x32 for x32 vDSO.
diff --git a/arch/x86/vdso/vdso-fakesections.c b/arch/x86/vdso/vdso-fakesections.c
new file mode 100644
index 0000000..cb8a8d7
--- /dev/null
+++ b/arch/x86/vdso/vdso-fakesections.c
@@ -0,0 +1,32 @@
+/*
+ * Copyright 2014 Andy Lutomirski
+ * Subject to the GNU Public License, v.2
+ *
+ * Hack to keep broken Go programs working.
+ *
+ * The Go runtime had a couple of bugs: it would read the section table to try
+ * to figure out how many dynamic symbols there were (it shouldn't have looked
+ * at the section table at all) and, if there were no SHT_SYNDYM section table
+ * entry, it would use an uninitialized value for the number of symbols.  As a
+ * workaround, we supply a minimal section table.  vdso2c will adjust the
+ * in-memory image so that "vdso_fake_sections" becomes the section table.
+ *
+ * The bug was introduced by:
+ * https://code.google.com/p/go/source/detail?r=56ea40aac72b (2012-08-31)
+ * and is being addressed in the Go runtime in this issue:
+ * https://code.google.com/p/go/issues/detail?id=8197
+ */
+
+#ifndef __x86_64__
+#error This hack is specific to the 64-bit vDSO
+#endif
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
diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
index d9f6f61..c6eefaf 100644
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
@@ -112,11 +122,14 @@ static void GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 	if (syms[sym_end_mapping] % 4096)
 		fail("end_mapping must be a multiple of 4096\n");
 
-	/* Remove sections. */
-	hdr->e_shoff = 0;
-	hdr->e_shentsize = 0;
-	hdr->e_shnum = 0;
-	hdr->e_shstrndx = SHN_UNDEF; /* SHN_UNDEF == 0 */
+	/* Remove sections or use fakes */
+	if (fake_sections_size % sizeof(Elf_Shdr))
+		fail("vdso_fake_sections size is not a multiple of %ld\n",
+		     (long)sizeof(Elf_Shdr));
+	PUT_LE(&hdr->e_shoff, fake_sections_value);
+	PUT_LE(&hdr->e_shentsize, fake_sections_value ? sizeof(Elf_Shdr) : 0);
+	PUT_LE(&hdr->e_shnum, fake_sections_size / sizeof(Elf_Shdr));
+	PUT_LE(&hdr->e_shstrndx, SHN_UNDEF);
 
 	if (!name) {
 		fwrite(addr, load_size, 1, outfile);
-- 
1.9.3

