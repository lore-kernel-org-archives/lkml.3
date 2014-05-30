Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933582AbaE3Ps7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:48:59 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:48898 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933247AbaE3Psz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:48:55 -0400
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
Subject: [PATCH v2 1/2] x86,vdso: When vdso2c fails, unlink the output
Date: Fri, 30 May 2014 08:48:48 -0700
Message-Id: <1764385fe9931e8940b9d001132515448ea89523.1401464755.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1401464755.git.luto@amacapital.net>
References: <CALCETrXef77JLoEp5hCXSdMAk7usWsL-sUG6NrcgLgrz3krfag@mail.gmail.com>
 <cover.1401464755.git.luto@amacapital.net>
In-Reply-To: <cover.1401464755.git.luto@amacapital.net>
References: <cover.1401464755.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids bizarre failures if make is run again.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/vdso/vdso2c.c | 20 +++++++++++---------
 arch/x86/vdso/vdso2c.h | 10 +++-------
 2 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/arch/x86/vdso/vdso2c.c b/arch/x86/vdso/vdso2c.c
index 81edd1e..fe8bfbf 100644
--- a/arch/x86/vdso/vdso2c.c
+++ b/arch/x86/vdso/vdso2c.c
@@ -14,6 +14,8 @@
 #include <linux/elf.h>
 #include <linux/types.h>
 
+const char *outfilename;
+
 /* Symbols that we need in vdso2c. */
 enum {
 	sym_vvar_page,
@@ -44,6 +46,7 @@ static void fail(const char *format, ...)
 	va_start(ap, format);
 	fprintf(stderr, "Error: ");
 	vfprintf(stderr, format, ap);
+	unlink(outfilename);
 	exit(1);
 	va_end(ap);
 }
@@ -82,17 +85,16 @@ static void fail(const char *format, ...)
 #undef Elf_Sym
 #undef Elf_Dyn
 
-static int go(void *addr, size_t len, FILE *outfile, const char *name)
+static void go(void *addr, size_t len, FILE *outfile, const char *name)
 {
 	Elf64_Ehdr *hdr = (Elf64_Ehdr *)addr;
 
 	if (hdr->e_ident[EI_CLASS] == ELFCLASS64) {
-		return go64(addr, len, outfile, name);
+		go64(addr, len, outfile, name);
 	} else if (hdr->e_ident[EI_CLASS] == ELFCLASS32) {
-		return go32(addr, len, outfile, name);
+		go32(addr, len, outfile, name);
 	} else {
-		fprintf(stderr, "Error: unknown ELF class\n");
-		return 1;
+		fail("unknown ELF class\n");
 	}
 }
 
@@ -102,7 +104,6 @@ int main(int argc, char **argv)
 	off_t len;
 	void *addr;
 	FILE *outfile;
-	int ret;
 	char *name, *tmp;
 	int namelen;
 
@@ -143,14 +144,15 @@ int main(int argc, char **argv)
 	if (addr == MAP_FAILED)
 		err(1, "mmap");
 
-	outfile = fopen(argv[2], "w");
+	outfilename = argv[2];
+	outfile = fopen(outfilename, "w");
 	if (!outfile)
 		err(1, "%s", argv[2]);
 
-	ret = go(addr, (size_t)len, outfile, name);
+	go(addr, (size_t)len, outfile, name);
 
 	munmap(addr, len);
 	fclose(outfile);
 
-	return ret;
+	return 0;
 }
diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
index 3dcc61e..26a7c1f 100644
--- a/arch/x86/vdso/vdso2c.h
+++ b/arch/x86/vdso/vdso2c.h
@@ -4,7 +4,7 @@
  * are built for 32-bit userspace.
  */
 
-static int GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
+static void GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 {
 	int found_load = 0;
 	unsigned long load_size = -1;  /* Work around bogus warning */
@@ -62,10 +62,8 @@ static int GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 			alt_sec = sh;
 	}
 
-	if (!symtab_hdr) {
+	if (!symtab_hdr)
 		fail("no symbol table\n");
-		return 1;
-	}
 
 	strtab_hdr = addr + hdr->e_shoff +
 		hdr->e_shentsize * symtab_hdr->sh_link;
@@ -112,7 +110,7 @@ static int GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 
 	if (!name) {
 		fwrite(addr, load_size, 1, outfile);
-		return 0;
+		return;
 	}
 
 	fprintf(outfile, "/* AUTOMATICALLY GENERATED -- DO NOT EDIT */\n\n");
@@ -152,6 +150,4 @@ static int GOFUNC(void *addr, size_t len, FILE *outfile, const char *name)
 				required_syms[i], syms[i]);
 	}
 	fprintf(outfile, "};\n");
-
-	return 0;
 }
-- 
1.9.3

