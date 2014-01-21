Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbaAUUqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 15:46:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44837 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbaAUUqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 15:46:04 -0500
Date: Tue, 21 Jan 2014 12:45:40 -0800
From: tip-bot for Michael Davidson <tipbot@zytor.com>
Message-ID: <tip-4cac7bb27b772924d5c6ac6caaa1ba9e929e8199@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        keescook@chromium.org, md@google.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, md@google.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20140121203223.GA12649@www.outflux.net>
References: <20140121203223.GA12649@www.outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] x86, relocs: Add manual debug mode
Git-Commit-ID: 4cac7bb27b772924d5c6ac6caaa1ba9e929e8199
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 21 Jan 2014 12:45:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4cac7bb27b772924d5c6ac6caaa1ba9e929e8199
Gitweb:     http://git.kernel.org/tip/4cac7bb27b772924d5c6ac6caaa1ba9e929e8199
Author:     Michael Davidson <md@google.com>
AuthorDate: Tue, 21 Jan 2014 12:32:23 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 21 Jan 2014 12:41:48 -0800

x86, relocs: Add manual debug mode

Improve the debuggability of relocations output. When trying to compare
the output between different linkers, it's handy to be able to see the
section names in output.

Signed-off-by: Michael Davidson <md@google.com>
Link: http://lkml.kernel.org/r/20140121203223.GA12649@www.outflux.net
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/tools/relocs.c        | 30 +++++++++++++++++++++++++++++-
 arch/x86/tools/relocs.h        |  7 ++++---
 arch/x86/tools/relocs_common.c | 16 ++++++++++++----
 3 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index 11f9285..cfbdbdb 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -1025,6 +1025,29 @@ static void emit_relocs(int as_text, int use_real_mode)
 	}
 }
 
+/*
+ * As an aid to debugging problems with different linkers
+ * print summary information about the relocs.
+ * Since different linkers tend to emit the sections in
+ * different orders we use the section names in the output.
+ */
+static int do_reloc_info(struct section *sec, Elf_Rel *rel, ElfW(Sym) *sym,
+				const char *symname)
+{
+	printf("%s\t%s\t%s\t%s\n",
+		sec_name(sec->shdr.sh_info),
+		rel_type(ELF_R_TYPE(rel->r_info)),
+		symname,
+		sec_name(sym->st_shndx));
+	return 0;
+}
+
+static void print_reloc_info(void)
+{
+	printf("reloc section\treloc type\tsymbol\tsymbol section\n");
+	walk_relocs(do_reloc_info);
+}
+
 #if ELF_BITS == 64
 # define process process_64
 #else
@@ -1032,7 +1055,8 @@ static void emit_relocs(int as_text, int use_real_mode)
 #endif
 
 void process(FILE *fp, int use_real_mode, int as_text,
-	     int show_absolute_syms, int show_absolute_relocs)
+	     int show_absolute_syms, int show_absolute_relocs,
+	     int show_reloc_info)
 {
 	regex_init(use_real_mode);
 	read_ehdr(fp);
@@ -1050,5 +1074,9 @@ void process(FILE *fp, int use_real_mode, int as_text,
 		print_absolute_relocs();
 		return;
 	}
+	if (show_reloc_info) {
+		print_reloc_info();
+		return;
+	}
 	emit_relocs(as_text, use_real_mode);
 }
diff --git a/arch/x86/tools/relocs.h b/arch/x86/tools/relocs.h
index 07cdb1e..f595906 100644
--- a/arch/x86/tools/relocs.h
+++ b/arch/x86/tools/relocs.h
@@ -29,8 +29,9 @@ enum symtype {
 };
 
 void process_32(FILE *fp, int use_real_mode, int as_text,
-		int show_absolute_syms, int show_absolute_relocs);
+		int show_absolute_syms, int show_absolute_relocs,
+		int show_reloc_info);
 void process_64(FILE *fp, int use_real_mode, int as_text,
-		int show_absolute_syms, int show_absolute_relocs);
-
+		int show_absolute_syms, int show_absolute_relocs,
+		int show_reloc_info);
 #endif /* RELOCS_H */
diff --git a/arch/x86/tools/relocs_common.c b/arch/x86/tools/relocs_common.c
index 44d3968..acab636 100644
--- a/arch/x86/tools/relocs_common.c
+++ b/arch/x86/tools/relocs_common.c
@@ -11,12 +11,13 @@ void die(char *fmt, ...)
 
 static void usage(void)
 {
-	die("relocs [--abs-syms|--abs-relocs|--text|--realmode] vmlinux\n");
+	die("relocs [--abs-syms|--abs-relocs|--reloc-info|--text|--realmode]" \
+	    " vmlinux\n");
 }
 
 int main(int argc, char **argv)
 {
-	int show_absolute_syms, show_absolute_relocs;
+	int show_absolute_syms, show_absolute_relocs, show_reloc_info;
 	int as_text, use_real_mode;
 	const char *fname;
 	FILE *fp;
@@ -25,6 +26,7 @@ int main(int argc, char **argv)
 
 	show_absolute_syms = 0;
 	show_absolute_relocs = 0;
+	show_reloc_info = 0;
 	as_text = 0;
 	use_real_mode = 0;
 	fname = NULL;
@@ -39,6 +41,10 @@ int main(int argc, char **argv)
 				show_absolute_relocs = 1;
 				continue;
 			}
+			if (strcmp(arg, "--reloc-info") == 0) {
+				show_reloc_info = 1;
+				continue;
+			}
 			if (strcmp(arg, "--text") == 0) {
 				as_text = 1;
 				continue;
@@ -67,10 +73,12 @@ int main(int argc, char **argv)
 	rewind(fp);
 	if (e_ident[EI_CLASS] == ELFCLASS64)
 		process_64(fp, use_real_mode, as_text,
-			   show_absolute_syms, show_absolute_relocs);
+			   show_absolute_syms, show_absolute_relocs,
+			   show_reloc_info);
 	else
 		process_32(fp, use_real_mode, as_text,
-			   show_absolute_syms, show_absolute_relocs);
+			   show_absolute_syms, show_absolute_relocs,
+			   show_reloc_info);
 	fclose(fp);
 	return 0;
 }
