Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbaFGCoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 22:44:10 -0400
Received: from ns.horizon.com ([71.41.210.147]:50187 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752424AbaFGCoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 22:44:07 -0400
Date: 6 Jun 2014 22:44:04 -0400
Message-ID: <20140607024404.13786.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: rdunlap@infradead.org, tj@kernel.org
Subject: [PATCH v2 1/3] Add lib/glob.c
Cc: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@horizon.com, mingo@redhat.com
In-Reply-To: <20140511123605.GB22945@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a helper function from drivers/ata/libata_core.c, where it is used
to blacklist particular device models.  It's being moved to lib/ so other
drivers may use it for the same purpose.

This implementation in non-recursive, so is safe for the kernel stack.

Signed-off-by: George Spelvin <linux@horizon.com>
---
Sorry for the delay; while researching ways to organize the self-test
code I found lots of other code to fix up.

Per previous discussion, support for out-of-tree users is currently
disabled, although the machinery necessary to add it easily is
still there.

If nothing else, it provides a good place to put the self-test code.
(Which is now split out into a separate patch.)

I believe I've addressed all the comments made last time.  Any more?
(Acked-by: and Reviewed-by: particularly appreciated!)

 include/linux/glob.h |  10 +++++
 lib/Kconfig          |  19 ++++++++
 lib/Makefile         |   2 +
 lib/glob.c           | 123 +++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 154 insertions(+)
 create mode 100644 include/linux/glob.h
 create mode 100644 lib/glob.c

diff --git a/include/linux/glob.h b/include/linux/glob.h
new file mode 100644
index 00000000..c990b7fb
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
index 4771fb3f..4a607036 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -382,6 +382,25 @@ config CPU_RMAP
 config DQL
 	bool
 
+config GLOB
+	bool
+#	This actually supports modular compilation, but the module overhead
+#	is ridiculous for the amount of code involved.	Until an out-of-tree
+#	driver asks for it, we'll just link it directly it into the kernel
+#	when required.  Since we're ignoring out-of-tree users,	there's also
+#	no need bother prompting for a manual decision:
+#	prompt "glob_match() function"
+	help
+	  This option provides a glob_match function for performing
+	  simple text pattern matching.  It originated in the ATA code
+	  to blacklist particular drive models, but other device drivers
+	  may need similar functionality.
+
+	  All drivers in the Linux kernel tree that require this function
+	  should automatically select this option.  Say N unless you
+	  are compiling an out-of tree driver which tells you that it
+	  depends on this.
+
 #
 # Netlink attribute parsing support is select'ed if needed
 #
diff --git a/lib/Makefile b/lib/Makefile
index 0cd7b68e..a2ae6fe2 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -134,6 +134,8 @@ obj-$(CONFIG_CORDIC) += cordic.o
 
 obj-$(CONFIG_DQL) += dynamic_queue_limits.o
 
+obj-$(CONFIG_GLOB) += glob.o
+
 obj-$(CONFIG_MPILIB) += mpi/
 obj-$(CONFIG_SIGNATURE) += digsig.o
 
diff --git a/lib/glob.c b/lib/glob.c
new file mode 100644
index 00000000..05beb470
--- /dev/null
+++ b/lib/glob.c
@@ -0,0 +1,123 @@
+#include <linux/module.h>
+#include <linux/glob.h>
+
+/*
+ * The only reason this code can be compiled as a module is because the
+ * ATA code that depends on it can be as well.  In practice, they're
+ * both usually compiled in and the module overhead goes away.
+ */
+MODULE_DESCRIPTION("glob(7) matching");
+MODULE_LICENSE("Dual MIT/GPL");
+
+/**
+ * glob_match - Shell-style pattern matching, like !fnmatch(pat, str, 0)
+ * @pat: Shell-style pattern to match, e.g. "*.[ch]".
+ * @str: String to match.  The pattern must match the entire string.
+ *
+ * Perform shell-style glob matching, returning true (1) if the match
+ * succeeds, or false (0) if it fails.  Equivalent to !fnmatch(@pat, @str, 0).
+ *
+ * Pattern metacharacters are ?, *, [ and \.
+ * (And, inside character classes, !, - and ].)
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
+bool __pure glob_match(char const *pat, char const *str)
+{
+	/*
+	 * Backtrack to previous * on mismatch and retry starting one
+	 * character later in the string.  Because * matches all characters
+	 * (no exception for /), it can be easily proved that there's
+	 * never a need to backtrack multiple levels.
+	 */
+	char const *back_pat = 0, *back_str = back_str;
+
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
+			 * range a-b.  The first span may begin with ']'.
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
+			/*FALLTHROUGH*/
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
-- 
2.0.0

