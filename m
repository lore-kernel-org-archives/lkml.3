Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab3EVCWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 22:22:08 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:55457 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab3EVCWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 22:22:05 -0400
X-AuditID: 85900ec0-d2ec7b900000151e-7f-519c2bca95be
Subject: [PATCH v2 3/5] lib/string: Add a generic wildcard string matching
 function
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <tom.zanussi@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Wed, 22 May 2013 11:19:14 +0900
Message-ID: <20130522021914.4299.35560.stgit@mhiramat-M0-7522>
In-Reply-To: <20130522021903.4299.85911.stgit@mhiramat-M0-7522>
References: <20130522021903.4299.85911.stgit@mhiramat-M0-7522>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add strglobmatch() for generic wildcard string matching.
This code is originally from perf-tools. For porting in
the kernel, the limitation of the number of wildcards is
introduced, because of the limitation of the stack.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>
---
 include/linux/string.h |    8 ++++
 lib/string.c           |   91 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 99 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
index ac889c5..fcb1506 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -122,6 +122,14 @@ extern void argv_free(char **argv);
 extern bool sysfs_streq(const char *s1, const char *s2);
 extern int strtobool(const char *s, bool *res);
 
+/*
+ * Maximum number of wildcards in a glob pattern
+ * This limits the number of wildcards in a glob pattern, because
+ * more wildcards consume more kernel stack.
+ */
+#define MAX_GLOB_WILDCARDS	10
+extern bool strglobmatch(const char *glob, const char *str);
+
 #ifdef CONFIG_BINARY_PRINTF
 int vbin_printf(u32 *bin_buf, size_t size, const char *fmt, va_list args);
 int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf);
diff --git a/lib/string.c b/lib/string.c
index e5878de..640fb10 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -824,3 +824,94 @@ void *memchr_inv(const void *start, int c, size_t bytes)
 	return check_bytes8(start, value, bytes % 8);
 }
 EXPORT_SYMBOL(memchr_inv);
+
+/* Character class matching */
+static bool __match_charclass(const char *pat, char c, const char **npat)
+{
+	bool complement = false, ret = true;
+
+	if (*pat == '!') {
+		complement = true;
+		pat++;
+	}
+	if (*pat++ == c)	/* First character is special */
+		goto end;
+
+	while (*pat && *pat != ']') {	/* Matching */
+		if (*pat == '-' && *(pat + 1) != ']') {	/* Range */
+			if (*(pat - 1) <= c && c <= *(pat + 1))
+				goto end;
+			if (*(pat - 1) > *(pat + 1))
+				goto error;
+			pat += 2;
+		} else if (*pat++ == c)
+			goto end;
+	}
+	if (!*pat)
+		goto error;
+	ret = false;
+
+end:
+	while (*pat && *pat != ']')	/* Searching closing */
+		pat++;
+	if (!*pat)
+		goto error;
+	*npat = pat + 1;
+	return complement ? !ret : ret;
+
+error:
+	return false;
+}
+
+/* Glob pattern(wildcard and char-class) matching */
+static bool __match_glob(const char *pat, const char *str, int nest)
+{
+	if (nest > MAX_GLOB_WILDCARDS)
+		return false;
+
+	while (*str && *pat && *pat != '*') {
+		if (*pat == '?') {	/* Matches any single character */
+			str++;
+			pat++;
+			continue;
+		} else if (*pat == '[')	/* Character classes/Ranges */
+			if (__match_charclass(pat + 1, *str, &pat)) {
+				str++;
+				continue;
+			} else
+				return false;
+		else if (*pat == '\\') /* Escaped char match as normal char */
+			pat++;
+		if (*str++ != *pat++)
+			return false;
+	}
+	/* Check wild card */
+	if (*pat == '*') {
+		while (*pat == '*')
+			pat++;
+		if (!*pat)	/* Tail wild card matches all */
+			return true;
+		while (*str)
+			if (__match_glob(pat, str++, nest + 1))
+				return true;
+	}
+	return !*str && !*pat;
+}
+
+/**
+ * strglobmatch - glob expression pattern matching
+ * @pat: the pattern string to match
+ * @str: the target string to match
+ *
+ * This returns true if the @str matches @pat. @pat can includes wildcards
+ * ('*','?') and character classes ([CHARS], complementation and ranges are
+ * also supported). Also, this supports escape character ('\') to use special
+ * characters as normal character.
+ *
+ * Note: if @pat syntax is broken, this always returns false.
+ */
+bool strglobmatch(const char *pat, const char *str)
+{
+	return __match_glob(pat, str, 0);
+}
+EXPORT_SYMBOL(strglobmatch);

