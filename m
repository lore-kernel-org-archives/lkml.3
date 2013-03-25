Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295Ab3CYSvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 14:51:23 -0400
Received: from relay1.sgi.com ([192.48.179.29]:37406 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932975Ab3CYSuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 14:50:10 -0400
Message-Id: <20130325185008.407092893@gulag1.americas.sgi.com>
References: <20130325185007.321022858@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 25 Mar 2013 13:50:14 -0500
From: Mike Travis <travis@sgi.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
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
Subject: [PATCH 07/15] KDB: clean up KDB grep code, add some options
Content-Disposition: inline; filename=kdb-update-grep-cmd.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up the grep 'pipe' code in KDB and adds some new options:

    * allows multiple '| grep' options to be used.
    * adds '-v' flag to invert the search.
    * adds '-o' flag for optional ('OR') patterns.
    * adds '-u' flag to delay printing until match found.

Options may be mixed in any combination.

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
 kernel/debug/kdb/kdb_grep.c    |  352 +++++++++++++++++++++++++++++++++--------
 kernel/debug/kdb/kdb_io.c      |   39 ++--
 kernel/debug/kdb/kdb_main.c    |   10 -
 kernel/debug/kdb/kdb_private.h |   55 +++++-
 4 files changed, 361 insertions(+), 95 deletions(-)

--- linux.orig/kernel/debug/kdb/kdb_grep.c
+++ linux/kernel/debug/kdb/kdb_grep.c
@@ -11,80 +11,224 @@
 
 #include <linux/ctype.h>
 #include <linux/string.h>
+#include <linux/module.h>
 #include <linux/kdb.h>
 #include "kdb_private.h"
 
-#define GREP_LEN 256
-char kdb_grep_string[GREP_LEN];
-int kdb_grepping_flag;
+#define KDB_GREP_PATT_LEN 511
+#define KDB_GREP_MAX 8
+
+static char kdb_grep_patterns[KDB_GREP_PATT_LEN+1];
+static int kdb_grep_pattern_idx;
+
+/* Note: kdb_grep_stack[0] intentially left zero */
+struct kdb_grep_stack_s kdb_grep_stack[KDB_GREP_MAX+1];
+int kdb_grepping_flag;			/* now kdb_grep_stack index */
 EXPORT_SYMBOL(kdb_grepping_flag);
-int kdb_grep_leading;
-int kdb_grep_trailing;
 
-/*
- * The "str" argument may point to something like  | grep xyz
- */
-void kdb_grep_parse(const char *str)
+static void kdb_grep_stack_clear(void)
 {
-	int	len;
-	char	*cp = (char *)str, *cp2;
+	kdb_grep_stack[kdb_grepping_flag].flags = 0;
+	kdb_grep_stack[kdb_grepping_flag].pattern_idx = 0;
+}
+
+static int kdb_grep_push(void)
+{
+	if (kdb_grepping_flag < KDB_GREP_MAX) {
+		++kdb_grepping_flag;
+		kdb_grep_stack_clear();
+		kdb_grep_set(enabled);
+		return 1;
+	}
+	return 0;
+}
+
+static void kdb_grep_pop(void)
+{
+	if (kdb_grepping_flag > 0) {
+		kdb_grep_pattern_idx =
+			kdb_grep_stack[kdb_grepping_flag].pattern_idx;
+
+		kdb_grep_patterns[kdb_grep_pattern_idx] = '\0';
+
+		if (kdb_grep(suspended))
+			kdb_grep_set_lvl(suspended, kdb_grepping_flag - 1);
+
+		kdb_grep_stack_clear();
+		--kdb_grepping_flag;
+
+		if (!kdb_grep(enabled))
+			kdb_grep_pop();
+	}
+}
+
+void kdb_grep_clear_all(void)
+{
+	kdb_grepping_flag = 0;
+	kdb_grep_pattern_idx = 0;
+	kdb_grep_patterns[0] = 0;
+	memset(kdb_grep_stack, 0, sizeof(kdb_grep_stack));
+}
+
+static int kdb_grep_error(const char *str)
+{
+	kdb_grep_clear_all();
+	kdb_printf("grep error: %s, see grephelp\n", str);
+	return -1;
+}
 
-	/* sanity check: we should have been called with the \ first */
+static const char *kdb_grep_pattern(int lvl)
+{
+	return &kdb_grep_patterns[kdb_grep_stack[lvl].pattern_idx];
+}
+
+static int kdb_grep_add_pattern(char *str)
+{
+	int len = strlen(str);
+
+	if (!len) {
+		kdb_grep_error("empty search pattern");
+		return 0;
+	}
+
+	if ((kdb_grep_pattern_idx + len) >= KDB_GREP_PATT_LEN) {
+		kdb_grep_error("search string(s) too long");
+		return 0;
+	}
+
+	/* copy string into pattern(s) buffer */
+	kdb_grep_stack[kdb_grepping_flag].pattern_idx = kdb_grep_pattern_idx;
+	strcpy((char *)kdb_grep_pattern(kdb_grepping_flag), str);
+	kdb_grep_pattern_idx += len + 1;
+	kdb_grep_patterns[kdb_grep_pattern_idx] = '\0';
+	return 1;
+}
+
+static char *is_grep(const char *cp)
+{
+	/* sanity check: we should have been called with the | first */
 	if (*cp != '|')
-		return;
+		return 0;
 	cp++;
 	while (isspace(*cp))
 		cp++;
+
 	if (strncmp(cp, "grep ", 5)) {
-		kdb_printf("invalid 'pipe', see grephelp\n");
-		return;
+		kdb_grep_error("invalid 'pipe'");
+		return NULL;
 	}
 	cp += 5;
+	return (char *)cp;
+}
+
+/*
+ * The "str" argument may point to something like  | grep xyz
+ */
+int kdb_grep_parse(char *str)
+{
+	int	len;
+	char	*cp, *cp2;
+	char	*newgrep;
+
+	cp = is_grep(str);
+	if (!cp)
+		return -1;
+repeat:
+	if (!kdb_grep_push())
+		return kdb_grep_error("too many grep's");
+
+	newgrep = NULL;
+
 	while (isspace(*cp))
 		cp++;
+
+	/* process possible options */
+	for (cp2 = cp; *cp2 == '-'; cp2 = cp) {
+		if (*++cp2 == '\0' || isspace(*cp2))
+			return kdb_grep_error("illegal option");
+
+		while (*cp2) {
+			switch (*cp2) {
+			case 'o':
+				kdb_grep_set(optional);
+				cp2++;
+				continue;
+			case 'u':
+				kdb_grep_set(until);
+				cp2++;
+				continue;
+			case 'v':
+				kdb_grep_set(inverted);
+				cp2++;
+				continue;
+			case ' ':
+			case '-':
+				break;
+			default:
+				return kdb_grep_error("illegal option");
+			}
+			break;
+		}
+		cp = cp2;
+		if (*cp == '-')	{
+			cp++;
+			break;
+		}
+		while (isspace(*cp))
+			cp++;
+	}
+
+	cp2 = strchr(cp, '|');
+	if (cp2) {			/* another '| grep' follows */
+		newgrep = is_grep(cp2);
+		if (!newgrep)
+			return -1;
+		*cp2 = '\0';
+	}
+
 	cp2 = strchr(cp, '\n');
-	if (cp2)
-		*cp2 = '\0'; /* remove the trailing newline */
+	if (cp2)			/* remove the trailing newline */
+		*cp2 = '\0';
+
 	len = strlen(cp);
-	if (len == 0) {
-		kdb_printf("invalid 'pipe', see grephelp\n");
-		return;
-	}
+	while (len > 0 && isspace(cp[len-1]))	/* trim trailing spaces */
+		cp[--len] = '\0';
+
+	if (len == 0)
+		return kdb_grep_error("pattern missing");
+
 	/* now cp points to a nonzero length search string */
 	if (*cp == '"') {
-		/* allow it be "x y z" by removing the "'s - there must
-		   be two of them */
+		/*
+		 * allow it be "x y z" by removing the "'s,
+		 *   - there must be two of them
+		 */
 		cp++;
 		cp2 = strchr(cp, '"');
-		if (!cp2) {
-			kdb_printf("invalid quoted string, see grephelp\n");
-			return;
-		}
+		if (!cp2)
+			return kdb_grep_error("invalid quoted string");
+
 		*cp2 = '\0'; /* end the string where the 2nd " was */
 	}
-	kdb_grep_leading = 0;
 	if (*cp == '^') {
-		kdb_grep_leading = 1;
+		kdb_grep_set(leading);
 		cp++;
 	}
 	len = strlen(cp);
-	kdb_grep_trailing = 0;
 	if (*(cp+len-1) == '$') {
-		kdb_grep_trailing = 1;
+		kdb_grep_set(trailing);
 		*(cp+len-1) = '\0';
 	}
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
+	if (!kdb_grep_add_pattern(cp))
+		return kdb_grep_error("too many pattern characters");
 
+	if (newgrep) {
+		cp = newgrep;
+		goto repeat;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(kdb_grep_parse);
 
 /*
  * search arg1 to see if it contains arg2
@@ -92,10 +236,11 @@ void kdb_grep_parse(const char *str)
  *
  * return 1 for found, 0 for not found
  */
-int kdb_grep_search(char *searched)
+static int kdb_search_string(const char *searched, int lvl)
 {
-	char firstchar, *cp;
-	char *searchfor = kdb_grep_string;
+	char firstchar;
+	const char *cp;
+	const char *searchfor = kdb_grep_pattern(lvl);
 	int len1, len2;
 
 	/* not counting the newline at the end of "searched" */
@@ -103,12 +248,15 @@ int kdb_grep_search(char *searched)
 	len2 = strlen(searchfor);
 	if (len1 < len2)
 		return 0;
-	if (kdb_grep_leading && kdb_grep_trailing && len1 != len2)
+	if (kdb_grep_lvl(leading, lvl)
+		&& kdb_grep_lvl(trailing, lvl)
+		&& len1 != len2)
 		return 0;
-	if (kdb_grep_leading) {
+
+	if (kdb_grep_lvl(leading, lvl)) {
 		if (!strncmp(searched, searchfor, len2))
 			return 1;
-	} else if (kdb_grep_trailing) {
+	} else if (kdb_grep_lvl(trailing, lvl)) {
 		if (!strncmp(searched+len1-len2, searchfor, len2))
 			return 1;
 	} else {
@@ -123,23 +271,105 @@ int kdb_grep_search(char *searched)
 	return 0;
 }
 
+int kdb_grep_search(const char *searched)
+{
+	int lvl;
+	int pmatch;
+	int match = 1;
+	int oc = 0, om = 0;
+
+	if (!kdb_grepping_flag)
+		return 1;
+
+	for (lvl = 1; lvl <= kdb_grepping_flag; lvl++) {
+		if (!kdb_grep_lvl(enabled, lvl))
+			continue;
+
+		if (!kdb_grep_lvl(optional, lvl)) {
+			if (oc && !om)
+				break;
+			oc = om = 0;
+		}
+
+		pmatch = kdb_search_string(searched, lvl);
 
+		if (kdb_grep_lvl(inverted, lvl))
+			pmatch ^= 1;
+
+		if (kdb_grep_lvl(optional, lvl)) {
+			oc++;
+			if (pmatch)
+				om++;
+
+		} else if (!pmatch) {
+			match = 0;
+			break;
+		}
+
+		if (pmatch && kdb_grep_lvl(until, lvl)) {
+			if (lvl == kdb_grepping_flag)
+				kdb_grep_pop();
+			else
+				kdb_grep_clear_lvl(enabled, lvl);
+		}
+	}
+
+	if (oc && !om)
+		return 0;
+
+	return match;
+}
+EXPORT_SYMBOL(kdb_grep_search);
 
 /*
- * display help for the use of cmd | grep pattern
+ * display help for the use of <cmd> <args> | grep <pattern>
  */
-int kdb_grep_help(int argc, const char **argv)
+static char *kdb_grep_help_list[] = {
+	"Usage of <cmd> <args> | grep <pattern> [| grep <pattern> ...]\n",
+	"  Any command's output may be filtered through an emulated 'pipe'.\n",
+	"  'grep' is just a key word.\n",
+	"  'grep -v' to invert the search.\n",
+	"  'grep -o' for optional ('OR') <pattern>.\n",
+	"  'grep -u' to delay printing until <pattern> found.\n",
+	"  Flags may be mixed and matched.  Use '--' before patterns starting with '-'.\n",
+	"  If consecutive patterns are 'optional' at least one must match.\n",
+	"  The pattern may include a very limited set of metacharacters:\n",
+	"     pattern or ^pattern or pattern$ or ^pattern$\n",
+	"  And if there are spaces in the pattern, you may quote it:\n",
+	"   \"pat tern\" or \"^pat tern\" or \"pat tern$\" or \"^pat tern$\"\n",
+	""
+};
+
+static int kdb_grep_help(int argc, const char **argv)
 {
-	kdb_printf("Usage of  cmd args | grep pattern:\n");
-	kdb_printf("  Any command's output may be filtered through an ");
-	kdb_printf("emulated 'pipe'.\n");
-	kdb_printf("  'grep' is just a key word.\n");
-	kdb_printf(
-	"  The pattern may include a very limited set of metacharacters:\n");
-	kdb_printf("   pattern or ^pattern or pattern$ or ^pattern$\n");
-	kdb_printf(
-	"  And if there are spaces in the pattern, you may quote it:\n");
-	kdb_printf(
-	"  \"pat tern\" or \"^pat tern\" or \"pat tern$\" or \"^pat tern$\"\n");
+	int i;
+
+	for (i = 0; *kdb_grep_help_list[i]; i++)
+		kdb_printf(kdb_grep_help_list[i]);
+
+	kdb_printf("  The '| grep' may be repeated up to %d times.\n",
+			KDB_GREP_MAX);
+
+	kdb_printf("  Max chars in all patterns (incl. NULLs) is %d.\n",
+			KDB_GREP_PATT_LEN);
 	return 0;
 }
+
+static int __init kdb_grep_init(void)
+{
+	kdb_register_repeat("grephelp", kdb_grep_help, "",
+	  "Display help on | grep", 0, KDB_REPEAT_NONE);
+
+	kdb_grep_clear_all();
+	pr_info("kdb_grep registered\n");
+	return 0;
+}
+
+static void __exit kdb_grep_exit(void)
+{
+	kdb_unregister("grephelp");
+}
+
+module_init(kdb_grep_init);
+module_exit(kdb_grep_exit);
+
--- linux.orig/kernel/debug/kdb/kdb_io.c
+++ linux/kernel/debug/kdb/kdb_io.c
@@ -504,7 +504,7 @@ empty:
  *	kdb output.
  *
  *  If the user is doing a cmd args | grep srch
- *  then kdb_grepping_flag is set.
+ *  then kdb_grep(enabled) is set.
  *  In that case we need to accumulate full lines (ending in \n) before
  *  searching for the pattern.
  */
@@ -512,7 +512,6 @@ empty:
 static char kdb_buffer[256];	/* A bit too big to go on stack */
 static char *next_avail = kdb_buffer;
 static int  size_avail;
-static int  suspend_grep;
 
 int vkdb_printf(const char *fmt, va_list ap)
 {
@@ -523,7 +522,7 @@ int vkdb_printf(const char *fmt, va_list
 	int saved_trap_printk;
 	int got_printf_lock = 0;
 	int retlen = 0;
-	int fnd, len;
+	int len;
 	char *cp, *cp2, *cphold = NULL, replaced_byte = ' ';
 	const char *ostring;
 	char *moreprompt = "more> ";
@@ -560,7 +559,7 @@ int vkdb_printf(const char *fmt, va_list
 	if (diag)
 		logging = 0;
 
-	if (!kdb_grepping_flag || suspend_grep) {
+	if (!kdb_grep(enabled) || kdb_grep(suspended)) {
 		/* normally, every vsnprintf starts a new buffer */
 		next_avail = kdb_buffer;
 		size_avail = sizeof(kdb_buffer);
@@ -568,15 +567,15 @@ int vkdb_printf(const char *fmt, va_list
 	vsnprintf(next_avail, size_avail, fmt, ap);
 
 	/*
-	 * If kdb_parse() found that the command was cmd xxx | grep yyy
-	 * then kdb_grepping_flag is set, and kdb_grep_string contains yyy
+	 * If kdb_grep(enabled) is set, accumulate the print data up to a
+	 * newline before 'kdb_grep_search'ing for it.  kdb_grep(suspended)
+	 * is disable it temporarily for kdb_printf to output prompts, etc.
 	 *
-	 * Accumulate the print data up to a newline before searching it.
 	 * (vsnprintf does null-terminate the string that it generates)
 	 */
 
 	/* skip the search if prints are temporarily unconditional */
-	if (!suspend_grep && kdb_grepping_flag) {
+	if (!kdb_grep(suspended) && kdb_grep(enabled)) {
 		cp = strchr(kdb_buffer, '\n');
 		if (!cp) {
 			/*
@@ -588,7 +587,7 @@ int vkdb_printf(const char *fmt, va_list
 			 *   The "[nn]more " prompt should also be
 			 *     (MOREPROMPT -> moreprompt)
 			 *   written *   but we print that ourselves,
-			 *   we set the suspend_grep flag to make
+			 *   we set the kdb_grep(suspended) flag to make
 			 *   it unconditional.
 			 *
 			 */
@@ -606,7 +605,7 @@ int vkdb_printf(const char *fmt, va_list
 					 * command, so we can go back
 					 * to normal mode.
 					 */
-					kdb_grepping_flag = 0;
+					kdb_grep_clear_all();
 					goto kdb_printit;
 				}
 			}
@@ -632,8 +631,7 @@ int vkdb_printf(const char *fmt, va_list
 		 * Only continue with this output if it contains the
 		 * search string.
 		 */
-		fnd = kdb_grep_search(kdb_buffer);
-		if (!fnd) {
+		if (!kdb_grep_search(kdb_buffer)) {
 			/*
 			 * At this point the complete line at the start
 			 * of kdb_buffer can be discarded, as it does
@@ -753,23 +751,23 @@ kdb_printit:
 			KDB_FLAG_SET(CMD_INTERRUPT); /* command interrupted */
 			KDB_STATE_CLEAR(PAGER);
 			/* end of command output; back to normal mode */
-			kdb_grepping_flag = 0;
+			kdb_grep_clear_all();
 			kdb_printf("\n");
 		} else if (buf1[0] == ' ') {
 			kdb_printf("\r");
-			suspend_grep = 1; /* for this recursion */
+			kdb_grep_set(suspended); /* for this recursion */
 		} else if (buf1[0] == '\n') {
 			kdb_nextline = linecount - 1;
 			kdb_printf("\r");
-			suspend_grep = 1; /* for this recursion */
+			kdb_grep_set(suspended); /* for this recursion */
 		} else if (buf1[0] && buf1[0] != '\n') {
 			/* user hit something other than enter */
-			suspend_grep = 1; /* for this recursion */
+			kdb_grep_set(suspended); /* for this recursion */
 			kdb_printf("\nOnly 'q' or 'Q' are processed at more "
 				   "prompt, input ignored\n");
-		} else if (kdb_grepping_flag) {
+		} else if (kdb_grep(enabled)) {
 			/* user hit enter */
-			suspend_grep = 1; /* for this recursion */
+			kdb_grep_set(suspended); /* for this recursion */
 			kdb_printf("\n");
 		}
 		kdb_input_flush();
@@ -781,7 +779,7 @@ kdb_printit:
 	 *  the terminating null, and cphold points to the null.
 	 * Then adjust the notion of available space in the buffer.
 	 */
-	if (kdb_grepping_flag && !suspend_grep) {
+	if (kdb_grep(enabled) && !kdb_grep(suspended)) {
 		*cphold = replaced_byte;
 		strcpy(kdb_buffer, cphold);
 		len = strlen(kdb_buffer);
@@ -790,7 +788,8 @@ kdb_printit:
 	}
 
 kdb_print_out:
-	suspend_grep = 0; /* end of what may have been a recursive call */
+	/* end of what may have been a recursive call */
+	kdb_grep_clear(suspended);
 	if (logging)
 		console_loglevel = saved_loglevel;
 	if (KDB_STATE(PRINTF_LOCK) && got_printf_lock) {
--- linux.orig/kernel/debug/kdb/kdb_main.c
+++ linux/kernel/debug/kdb/kdb_main.c
@@ -812,13 +812,13 @@ int kdb_parse(const char *cmdstr)
 	char *cp;
 	char *cpp, quoted;
 	kdbtab_t *tp;
-	int i, escaped, ignore_errors = 0, check_grep;
+	int i, escaped, ignore_errors = 0, check_grep = 0;
 
 	/*
 	 * First tokenize the command string.
 	 */
 	cp = (char *)cmdstr;
-	kdb_grepping_flag = check_grep = 0;
+	kdb_grep_clear_all();
 
 	if (KDB_FLAG(CMD_INTERRUPT)) {
 		/* Previous command was interrupted, newline must not
@@ -887,8 +887,8 @@ int kdb_parse(const char *cmdstr)
 	}
 	if (!argc)
 		return 0;
-	if (check_grep)
-		kdb_grep_parse(cp);
+	if (check_grep && kdb_grep_parse(cp))
+		return KDB_NOTFOUND;	/* '| grep' error */
 	if (defcmd_in_progress) {
 		int result = kdb_defcmd2(cmdstr, argv[0]);
 		if (!defcmd_in_progress) {
@@ -2758,8 +2758,6 @@ static void __init kdb_inittab(void)
 	  "Summarize the system", 4, KDB_REPEAT_NONE);
 	kdb_register_repeat("per_cpu", kdb_per_cpu, "<sym> [<bytes>] [<cpu>]",
 	  "Display per_cpu variables", 3, KDB_REPEAT_NONE);
-	kdb_register_repeat("grephelp", kdb_grep_help, "",
-	  "Display help on | grep", 0, KDB_REPEAT_NONE);
 }
 
 /* Execute any commands defined in kdb_cmds.  */
--- linux.orig/kernel/debug/kdb/kdb_private.h
+++ linux/kernel/debug/kdb/kdb_private.h
@@ -151,14 +151,6 @@ extern int kdb_main_loop(kdb_reason_t, k
 			 int, kdb_dbtrap_t, struct pt_regs *);
 
 /* Miscellaneous functions and data areas */
-extern int kdb_grepping_flag;
-extern char kdb_grep_string[];
-extern int kdb_grep_leading;
-extern int kdb_grep_trailing;
-extern void kdb_grep_parse(const char *str);
-extern int kdb_grep_search(char *searched);
-extern int kdb_grep_help(int argc, const char **argv);
-
 extern char *kdb_cmds[];
 extern unsigned long kdb_task_state_string(const char *);
 extern char kdb_task_state_char (const struct task_struct *);
@@ -181,5 +173,52 @@ extern char kdb_prompt_str[];
 
 #define	KDB_WORD_SIZE	((int)sizeof(unsigned long))
 
+/* kdb grep options */
+enum kdb_grep_flags {
+	kdb_grep_enabled,
+	kdb_grep_suspended,
+	kdb_grep_leading,
+	kdb_grep_trailing,
+	kdb_grep_inverted,
+	kdb_grep_until,
+	kdb_grep_optional
+};
+
+struct kdb_grep_stack_s {
+	unsigned short	flags;
+	unsigned short	pattern_idx;
+};
+
+extern int kdb_grepping_flag;
+extern struct kdb_grep_stack_s kdb_grep_stack[];
+extern void kdb_grep_clear_all(void);
+extern int kdb_grep_search(const char *searched);
+extern int kdb_grep_parse(char *str);
+
+#define	kdb_grep_flag(flag)	(1 << kdb_grep_##flag)
+
+#define	kdb_grep_lvl(f, l)	 __kdb_grep_lvl(kdb_grep_flag(f), l)
+#define	kdb_grep_set_lvl(f, l)	 __kdb_grep_set_lvl(kdb_grep_flag(f), l)
+#define	kdb_grep_clear_lvl(f, l) __kdb_grep_clear_lvl(kdb_grep_flag(f), l)
+
+#define	kdb_grep(flag)		kdb_grep_lvl(flag, kdb_grepping_flag)
+#define	kdb_grep_set(flag)	kdb_grep_set_lvl(flag, kdb_grepping_flag)
+#define	kdb_grep_clear(flag)	kdb_grep_clear_lvl(flag, kdb_grepping_flag)
+
+static inline int __kdb_grep_lvl(unsigned short flag, int lvl)
+{
+	return !!(kdb_grep_stack[lvl].flags & flag);
+}
+
+static inline void __kdb_grep_set_lvl(unsigned int flag, int lvl)
+{
+	kdb_grep_stack[lvl].flags |= flag;
+}
+
+static inline void __kdb_grep_clear_lvl(unsigned int flag, int lvl)
+{
+	kdb_grep_stack[lvl].flags &= ~flag;
+}
+
 #endif /* CONFIG_KGDB_KDB */
 #endif	/* !_KDBPRIVATE_H */

-- 
