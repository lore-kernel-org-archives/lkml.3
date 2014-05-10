Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaEJDOB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 23:14:01 -0400
Received: from ns.horizon.com ([71.41.210.147]:25389 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751315AbaEJDOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 23:14:00 -0400
Date: 9 May 2014 23:13:56 -0400
Message-ID: <20140510031356.22726.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tj@kernel.org
Subject: [PATCH 1/2] Add lib/glob.c
Cc: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        torvalds@linux-foundation.org
In-Reply-To: <20140313121032.GA9981@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a helper function from drivers/ata/libata_core.c, where it is used
to blacklist particular device models.  It's being moved to lib/ so other
drivers may use it for the same purpose.

This implementation in non-recursive, so is safe for the kernel stack.

Signed-off-by: George Spelvin <linux@horizon.com>
---
Finally rescued this from the back burner.  The code size will go back
down in the second patch which removes the old implementation, although
the number of source line reflects more comments and a test driver.

The infrastructure parts of this, such as the module name and Kconfig
declarations, are something I haven't done before, and comments are
appreciated.

Tejun Heo <htejun@gmail.com> wrote:
> On Wed, Mar 12, 2014 at 06:52:44PM -0400, George Spelvin wrote:
>> Sure; I'll prepare some patches.  May I feed it through you, or
>> is there a lib/ maintainer I need to go through?
>
> Please keep me cc'd but you'd probably also want to cc Linus, Andrew
> Morton and Ingo.

 include/linux/glob.h |  10 +++
 lib/Kconfig          |  14 ++++
 lib/Makefile         |   2 +
 lib/glob.c           | 225 +++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 251 insertions(+)
 create mode 100644 include/linux/glob.h
 create mode 100644 lib/glob.c

diff --git a/include/linux/glob.h b/include/linux/glob.h
new file mode 100644
index 0000000..c990b7f
--- /dev/null
+++ b/include/linux/glob.h
@@ -0,0 +1,10 @@
+#ifndef _LINUX_GLOB_H
+#define _LINUX_GLOB_H
+
+#include <linux/types.h>	/* For bool */
+#include <linux/compiler.h>	/* For __pure */
+
+bool __pure glob_match(char const *pat, char const *str);
+
+#endif	/* _LINUX_GLOB_H */
+
diff --git a/lib/Kconfig b/lib/Kconfig
index 991c98b..5333d10 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -373,6 +373,20 @@ config CPU_RMAP
 config DQL
 	bool
 
+config GLOB
+	tristate
+#	(Prompt disabled to reduce kbuild clutter until someone needs it.)
+#	prompt "glob_match() function"
+	help
+	  This option provides a glob_match function for performing simple
+	  text pattern matching.  It is primarily used by the ATA code
+	  to blacklist particular drive models, but other device drivers
+	  may need similar functionality.
+
+	  All in-kernel drivers that require this function automatically
+	  select this option.  Say N unless you are compiling an out-of
+	  tree driver which tells you it depend on it.
+
 #
 # Netlink attribute parsing support is select'ed if needed
 #
diff --git a/lib/Makefile b/lib/Makefile
index 48140e3..c859f81 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -133,6 +133,8 @@ obj-$(CONFIG_CORDIC) += cordic.o
 
 obj-$(CONFIG_DQL) += dynamic_queue_limits.o
 
+obj-$(CONFIG_GLOB) += glob.o
+
 obj-$(CONFIG_MPILIB) += mpi/
 obj-$(CONFIG_SIGNATURE) += digsig.o
 
diff --git a/lib/glob.c b/lib/glob.c
new file mode 100644
index 0000000..b71ca59
--- /dev/null
+++ b/lib/glob.c
@@ -0,0 +1,225 @@
+#ifdef UNITTEST
+/* To do a basic sanity test, "cc -DUNITTEST glob.c" and run a.out. */
+
+#include <stdbool.h>
+#define __pure __attribute__((pure))
+#define NOP(x)
+#define EXPORT_SYMBOL NOP	/* Two stages to avoid checkpatch complaints */
+
+#else
+
+#include <linux/module.h>
+#include <linux/glob.h>
+
+MODULE_DESCRIPTION("glob(7) matching");
+MODULE_LICENSE("Dual MIT/GPL");
+
+#endif
+
+/**
+ * glob_match - Shell-style pattern matching, like !fnmatch(pat, str, 0)
+ * @pat: Pattern to match.  Metacharacters are ?, *, [ and \.
+ *       (And, inside character classes, !, - and ].)
+ * @str: String to match.  the pattern must match the entire string.
+ *
+ * Perform shell-style glob matching, returning true (1) if the match
+ * succeeds, or false (0) if it fails.
+ *
+ * This is small and simple implementation intended for device blacklists
+ * where a string is matched against a number of patterns.  Thus, it
+ * does not preprocess the patterns.  It is non-recursive, and run-time
+ * is at most quadratic: strlen(@str)*strlen(@pat).
+ *
+ * An example of the worst case is glob_match("*aaaaa", "aaaaaaaaaa");
+ * it takes 6 passes over the pattern before matching the string.
+ *
+ * Like !fnmatch(@pat, @str, 0) and unlike the shell, this does NOT
+ * treat / or leading . specially; it isn't actually used for pathnames.
+ *
+ * Note that according to glob(7) (and unlike bash), character classes
+ * are complemented by a leading !; this does not support the regex-style
+ * [^a-z] syntax.
+ *
+ * An opening bracket without a matching close is matched literally.
+ */
+bool __pure
+glob_match(char const *pat, char const *str)
+{
+	/*
+	 * Backtrack to previous * on mismatch and retry starting one
+	 * character later in the string.  Because * matches all characters
+	 * (no exception for /), it can be easily proved that there's
+	 * never a need to backtrack multiple levels.
+	 */
+	char const *back_pat = 0, *back_str = back_str;
+	/*
+	 * Loop over each token (character or class) in pat, matching
+	 * it against the remaining unmatched tail of str.  Return false
+	 * on mismatch, or true after matching the trailing nul bytes.
+	 */
+	for (;;) {
+		unsigned char c = *str++;
+		unsigned char d = *pat++;
+
+		switch (d) {
+		case '?':	/* Wildcard: anything but nul */
+			if (c == '\0')
+				return false;
+			break;
+		case '*':	/* Any-length wildcard */
+			if (*pat == '\0')	/* Optimize trailing * case */
+				return true;
+			back_pat = pat;
+			back_str = --str;	/* Allow zero-length match */
+			break;
+		case '[': {	/* Character class */
+			bool match = false, inverted = (*pat == '!');
+			char const *class = pat + inverted;
+			unsigned char a = *class++;
+
+			/*
+			 * Iterate over each span in the character class.
+			 * A span is either a single character a, or a
+			 * range a-b.
+			 */
+			do {
+				unsigned char b = a;
+
+				if (a == '\0')	/* Malformed */
+					goto literal;
+
+				if (class[0] == '-' && class[1] != ']') {
+					b = class[1];
+
+					if (b == '\0')
+						goto literal;
+
+					class += 2;
+					/* Any special action if a > b? */
+				}
+				match |= (a <= c && c <= b);
+			} while ((a = *class++) != ']');
+
+			if (match == inverted)
+				goto backtrack;
+			pat = class;
+			}
+			break;
+		case '\\':
+			d = *pat++;
+			/* FALLLTHROUGH */
+		default:	/* Literal character */
+literal:
+			if (c == d) {
+				if (d == '\0')
+					return true;
+				break;
+			}
+backtrack:
+			if (c == '\0' || !back_pat)
+				return false;	/* No point continuing */
+			/* Try again from last *, one character later in str. */
+			pat = back_pat;
+			str = ++back_str;
+			break;
+		}
+	}
+}
+EXPORT_SYMBOL(glob_match);
+
+
+#ifdef UNITTEST
+
+/* Test code */
+#include <stdio.h>
+#include <stdlib.h>
+struct glob_test {
+	char const *pat, *str;
+	bool expected;
+};
+
+static void
+test(struct glob_test const *g)
+{
+	bool match = glob_match(g->pat, g->str);
+
+	printf("\"%s\" vs. \"%s\": %s %s\n", g->pat, g->str,
+		match ? "match" : "mismatch",
+		match == g->expected ? "OK" : "*** ERROR ***");
+	if (match != g->expected)
+		exit(1);
+}
+
+static struct glob_test const tests[] = {
+	{ "a", "a", true },
+	{ "a", "b", false },
+	{ "a", "aa", false },
+	{ "a", "", false },
+	{ "", "", true },
+	{ "", "a", false },
+	{ "[a]", "a", true },
+	{ "[!a]", "a", false },
+	{ "[!a]", "b", true },
+	{ "[ab]", "a", true },
+	{ "[ab]", "b", true },
+	{ "[ab]", "c", false },
+	{ "[!ab]", "c", true },
+	{ "[a-c]", "b", true },
+	{ "[a-c]", "d", false },
+	{ "[]a-ceg-ik[]", "a", true },
+	{ "[]a-ceg-ik[]", "]", true },
+	{ "[]a-ceg-ik[]", "[", true },
+	{ "[]a-ceg-ik[]", "h", true },
+	{ "[]a-ceg-ik[]", "f", false },
+	{ "[!]a-ceg-ik[]", "h", false },
+	{ "[!]a-ceg-ik[]", "]", false },
+	{ "[!]a-ceg-ik[]", "f", true },
+	{ "[a-b-]", "-", true },
+	{ "?", "a", true },
+	{ "?", "aa", false },
+	{ "??", "a", false },
+	{ "?x?", "axb", true },
+	{ "?x?", "abx", false },
+	{ "?x?", "xab", false },
+	{ "*??", "a", false },
+	{ "*??", "ab", true },
+	{ "*??", "abc", true },
+	{ "*??", "abcd", true },
+	{ "??*", "a", false },
+	{ "??*", "ab", true },
+	{ "??*", "abc", true },
+	{ "??*", "abcd", true },
+	{ "?*?", "a", false },
+	{ "?*?", "ab", true },
+	{ "?*?", "abc", true },
+	{ "?*?", "abcd", true },
+	{ "*b", "b", true },
+	{ "*b", "ab", true },
+	{ "*b", "aab", true },
+	{ "*bc", "abbc", true },
+	{ "*bc", "bc", true },
+	{ "*bc", "bbc", true },
+	{ "*bc", "bcbc", true },
+	{ "*ac*", "abacadaeafag", true },
+	{ "*ac*ae*ag*", "abacadaeafag", true },
+	{ "*a*b*[bc]*[ef]*g*", "abacadaeafag", true },
+	{ "*a*b*[ef]*[cd]*g*", "abacadaeafag", false },
+	{ "*abcd*", "abcabcabcabcdefg", true },
+	{ "*ab*cd*", "abcabcabcabcdefg", true },
+	{ "*abcd*abcdef*", "abcabcdabcdeabcdefg", true },
+	{ "*abcd*", "abcabcabcabcefg", false },
+	{ "*ab*cd*", "abcabcabcabcefg", false }
+};
+
+int
+main(void)
+{
+	size_t i;
+
+	for (i = 0; i < sizeof(tests)/sizeof(*tests); i++)
+		test(tests + i);
+
+	return 0;
+}
+
+#endif	/* UNITTEST */
-- 
1.9.2

