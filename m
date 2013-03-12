Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933442Ab3CLTjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:39:51 -0400
Received: from relay1.sgi.com ([192.48.179.29]:42405 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274Ab3CLTiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:38:25 -0400
Message-Id: <20130312193824.184040171@gulag1.americas.sgi.com>
References: <20130312193823.212544181@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 12 Mar 2013 14:38:29 -0500
From: Mike Travis <travis@sgi.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        kgdb-bugreport@lists.sourceforge.net, x86@kernel.org,
        linux-kernel@vger.kernel.org, Tim Bird <tim.bird@am.sony.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?ISO-8859-15?q?Vincent=20Stehl=C3=A9?= 
	<vincent.stehle@laposte.net>,
        Andrei Warkentin <andrey.warkentin@gmail.com>
Subject: [PATCH 06/14] KDB: consolidate KDB grep code
Content-Disposition: inline; filename=kdb-consolidate-grep-cmd.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch consolidates various parts of the grep code in KDB
into a new file, kdb_grep.c, in preparation of various cleanups
and additions.

Cc: Tim Bird <tim.bird@am.sony.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Vincent Stehlé" <vincent.stehle@laposte.net>
Cc: Andrei Warkentin <andrey.warkentin@gmail.com>
Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 kernel/debug/kdb/Makefile      |    2 
 kernel/debug/kdb/kdb_grep.c    |  145 +++++++++++++++++++++++++++++++++++++++++
 kernel/debug/kdb/kdb_io.c      |   38 ----------
 kernel/debug/kdb/kdb_main.c    |   92 --------------------------
 kernel/debug/kdb/kdb_private.h |    4 +
 5 files changed, 152 insertions(+), 129 deletions(-)

--- linux.orig/kernel/debug/kdb/Makefile
+++ linux/kernel/debug/kdb/Makefile
@@ -7,7 +7,7 @@
 #
 
 CCVERSION	:= $(shell $(CC) -v 2>&1 | sed -ne '$$p')
-obj-y := kdb_io.o kdb_main.o kdb_support.o kdb_bt.o gen-kdb_cmds.o kdb_bp.o kdb_debugger.o
+obj-y := kdb_io.o kdb_main.o kdb_support.o kdb_bt.o gen-kdb_cmds.o kdb_bp.o kdb_grep.o kdb_debugger.o
 obj-$(CONFIG_KDB_KEYBOARD)    += kdb_keyboard.o
 
 clean-files := gen-kdb_cmds.c
--- /dev/null
+++ linux/kernel/debug/kdb/kdb_grep.c
@@ -0,0 +1,145 @@
+/*
+ * Kernel Debugger Architecture Grep Support
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 1999-2004,2013 Silicon Graphics, Inc.  All Rights Reserved.
+ * Copyright (c) 2009 Wind River Systems, Inc.  All Rights Reserved.
+ */
+
+#include <linux/ctype.h>
+#include <linux/string.h>
+#include <linux/kdb.h>
+#include "kdb_private.h"
+
+#define GREP_LEN 256
+char kdb_grep_string[GREP_LEN];
+int kdb_grepping_flag;
+EXPORT_SYMBOL(kdb_grepping_flag);
+int kdb_grep_leading;
+int kdb_grep_trailing;
+
+/*
+ * The "str" argument may point to something like  | grep xyz
+ */
+void kdb_grep_parse(const char *str)
+{
+	int	len;
+	char	*cp = (char *)str, *cp2;
+
+	/* sanity check: we should have been called with the \ first */
+	if (*cp != '|')
+		return;
+	cp++;
+	while (isspace(*cp))
+		cp++;
+	if (strncmp(cp, "grep ", 5)) {
+		kdb_printf("invalid 'pipe', see grephelp\n");
+		return;
+	}
+	cp += 5;
+	while (isspace(*cp))
+		cp++;
+	cp2 = strchr(cp, '\n');
+	if (cp2)
+		*cp2 = '\0'; /* remove the trailing newline */
+	len = strlen(cp);
+	if (len == 0) {
+		kdb_printf("invalid 'pipe', see grephelp\n");
+		return;
+	}
+	/* now cp points to a nonzero length search string */
+	if (*cp == '"') {
+		/* allow it be "x y z" by removing the "'s - there must
+		   be two of them */
+		cp++;
+		cp2 = strchr(cp, '"');
+		if (!cp2) {
+			kdb_printf("invalid quoted string, see grephelp\n");
+			return;
+		}
+		*cp2 = '\0'; /* end the string where the 2nd " was */
+	}
+	kdb_grep_leading = 0;
+	if (*cp == '^') {
+		kdb_grep_leading = 1;
+		cp++;
+	}
+	len = strlen(cp);
+	kdb_grep_trailing = 0;
+	if (*(cp+len-1) == '$') {
+		kdb_grep_trailing = 1;
+		*(cp+len-1) = '\0';
+	}
+	len = strlen(cp);
+	if (!len)
+		return;
+	if (len >= GREP_LEN) {
+		kdb_printf("search string too long\n");
+		return;
+	}
+	strcpy(kdb_grep_string, cp);
+	kdb_grepping_flag++;
+	return;
+}
+
+
+/*
+ * search arg1 to see if it contains arg2
+ * (kdmain.c provides flags for ^pat and pat$)
+ *
+ * return 1 for found, 0 for not found
+ */
+int kdb_grep_search(char *searched)
+{
+	char firstchar, *cp;
+	char *searchfor = kdb_grep_string;
+	int len1, len2;
+
+	/* not counting the newline at the end of "searched" */
+	len1 = strlen(searched)-1;
+	len2 = strlen(searchfor);
+	if (len1 < len2)
+		return 0;
+	if (kdb_grep_leading && kdb_grep_trailing && len1 != len2)
+		return 0;
+	if (kdb_grep_leading) {
+		if (!strncmp(searched, searchfor, len2))
+			return 1;
+	} else if (kdb_grep_trailing) {
+		if (!strncmp(searched+len1-len2, searchfor, len2))
+			return 1;
+	} else {
+		firstchar = *searchfor;
+		cp = searched;
+		while ((cp = strchr(cp, firstchar))) {
+			if (!strncmp(cp, searchfor, len2))
+				return 1;
+			cp++;
+		}
+	}
+	return 0;
+}
+
+
+
+/*
+ * display help for the use of cmd | grep pattern
+ */
+int kdb_grep_help(int argc, const char **argv)
+{
+	kdb_printf("Usage of  cmd args | grep pattern:\n");
+	kdb_printf("  Any command's output may be filtered through an ");
+	kdb_printf("emulated 'pipe'.\n");
+	kdb_printf("  'grep' is just a key word.\n");
+	kdb_printf(
+	"  The pattern may include a very limited set of metacharacters:\n");
+	kdb_printf("   pattern or ^pattern or pattern$ or ^pattern$\n");
+	kdb_printf(
+	"  And if there are spaces in the pattern, you may quote it:\n");
+	kdb_printf(
+	"  \"pat tern\" or \"^pat tern\" or \"pat tern$\" or \"^pat tern$\"\n");
+	return 0;
+}
--- linux.orig/kernel/debug/kdb/kdb_io.c
+++ linux/kernel/debug/kdb/kdb_io.c
@@ -514,42 +514,6 @@ static char *next_avail = kdb_buffer;
 static int  size_avail;
 static int  suspend_grep;
 
-/*
- * search arg1 to see if it contains arg2
- * (kdmain.c provides flags for ^pat and pat$)
- *
- * return 1 for found, 0 for not found
- */
-static int kdb_search_string(char *searched, char *searchfor)
-{
-	char firstchar, *cp;
-	int len1, len2;
-
-	/* not counting the newline at the end of "searched" */
-	len1 = strlen(searched)-1;
-	len2 = strlen(searchfor);
-	if (len1 < len2)
-		return 0;
-	if (kdb_grep_leading && kdb_grep_trailing && len1 != len2)
-		return 0;
-	if (kdb_grep_leading) {
-		if (!strncmp(searched, searchfor, len2))
-			return 1;
-	} else if (kdb_grep_trailing) {
-		if (!strncmp(searched+len1-len2, searchfor, len2))
-			return 1;
-	} else {
-		firstchar = *searchfor;
-		cp = searched;
-		while ((cp = strchr(cp, firstchar))) {
-			if (!strncmp(cp, searchfor, len2))
-				return 1;
-			cp++;
-		}
-	}
-	return 0;
-}
-
 int vkdb_printf(const char *fmt, va_list ap)
 {
 	int diag;
@@ -668,7 +632,7 @@ int vkdb_printf(const char *fmt, va_list
 		 * Only continue with this output if it contains the
 		 * search string.
 		 */
-		fnd = kdb_search_string(kdb_buffer, kdb_grep_string);
+		fnd = kdb_grep_search(kdb_buffer);
 		if (!fnd) {
 			/*
 			 * At this point the complete line at the start
--- linux.orig/kernel/debug/kdb/kdb_main.c
+++ linux/kernel/debug/kdb/kdb_main.c
@@ -42,13 +42,6 @@
 #include <linux/slab.h>
 #include "kdb_private.h"
 
-#define GREP_LEN 256
-char kdb_grep_string[GREP_LEN];
-int kdb_grepping_flag;
-EXPORT_SYMBOL(kdb_grepping_flag);
-int kdb_grep_leading;
-int kdb_grep_trailing;
-
 /*
  * Kernel debugger state flags
  */
@@ -768,70 +761,6 @@ static char cmd_hist[KDB_CMD_HISTORY_COU
 static char cmd_cur[CMD_BUFLEN];
 
 /*
- * The "str" argument may point to something like  | grep xyz
- */
-static void parse_grep(const char *str)
-{
-	int	len;
-	char	*cp = (char *)str, *cp2;
-
-	/* sanity check: we should have been called with the \ first */
-	if (*cp != '|')
-		return;
-	cp++;
-	while (isspace(*cp))
-		cp++;
-	if (strncmp(cp, "grep ", 5)) {
-		kdb_printf("invalid 'pipe', see grephelp\n");
-		return;
-	}
-	cp += 5;
-	while (isspace(*cp))
-		cp++;
-	cp2 = strchr(cp, '\n');
-	if (cp2)
-		*cp2 = '\0'; /* remove the trailing newline */
-	len = strlen(cp);
-	if (len == 0) {
-		kdb_printf("invalid 'pipe', see grephelp\n");
-		return;
-	}
-	/* now cp points to a nonzero length search string */
-	if (*cp == '"') {
-		/* allow it be "x y z" by removing the "'s - there must
-		   be two of them */
-		cp++;
-		cp2 = strchr(cp, '"');
-		if (!cp2) {
-			kdb_printf("invalid quoted string, see grephelp\n");
-			return;
-		}
-		*cp2 = '\0'; /* end the string where the 2nd " was */
-	}
-	kdb_grep_leading = 0;
-	if (*cp == '^') {
-		kdb_grep_leading = 1;
-		cp++;
-	}
-	len = strlen(cp);
-	kdb_grep_trailing = 0;
-	if (*(cp+len-1) == '$') {
-		kdb_grep_trailing = 1;
-		*(cp+len-1) = '\0';
-	}
-	len = strlen(cp);
-	if (!len)
-		return;
-	if (len >= GREP_LEN) {
-		kdb_printf("search string too long\n");
-		return;
-	}
-	strcpy(kdb_grep_string, cp);
-	kdb_grepping_flag++;
-	return;
-}
-
-/*
  * kdb_parse - Parse the command line, search the command table for a
  *	matching command and invoke the command function.  This
  *	function may be called recursively, if it is, the second call
@@ -943,7 +872,7 @@ int kdb_parse(const char *cmdstr)
 	if (!argc)
 		return 0;
 	if (check_grep)
-		parse_grep(cp);
+		kdb_grep_parse(cp);
 	if (defcmd_in_progress) {
 		int result = kdb_defcmd2(cmdstr, argv[0]);
 		if (!defcmd_in_progress) {
@@ -2680,25 +2609,6 @@ static int kdb_per_cpu(int argc, const c
 	return 0;
 }
 
-/*
- * display help for the use of cmd | grep pattern
- */
-static int kdb_grep_help(int argc, const char **argv)
-{
-	kdb_printf("Usage of  cmd args | grep pattern:\n");
-	kdb_printf("  Any command's output may be filtered through an ");
-	kdb_printf("emulated 'pipe'.\n");
-	kdb_printf("  'grep' is just a key word.\n");
-	kdb_printf("  The pattern may include a very limited set of "
-		   "metacharacters:\n");
-	kdb_printf("   pattern or ^pattern or pattern$ or ^pattern$\n");
-	kdb_printf("  And if there are spaces in the pattern, you may "
-		   "quote it:\n");
-	kdb_printf("   \"pat tern\" or \"^pat tern\" or \"pat tern$\""
-		   " or \"^pat tern$\"\n");
-	return 0;
-}
-
 /*
  * kdb_register_repeat - This function is used to register a kernel
  * 	debugger command.
--- linux.orig/kernel/debug/kdb/kdb_private.h
+++ linux/kernel/debug/kdb/kdb_private.h
@@ -159,6 +159,10 @@ extern int kdb_grepping_flag;
 extern char kdb_grep_string[];
 extern int kdb_grep_leading;
 extern int kdb_grep_trailing;
+extern void kdb_grep_parse(const char *str);
+extern int kdb_grep_search(char *searched);
+extern int kdb_grep_help(int argc, const char **argv);
+
 extern char *kdb_cmds[];
 extern unsigned long kdb_task_state_string(const char *);
 extern char kdb_task_state_char (const struct task_struct *);

-- 
