Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaFGCtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 22:49:31 -0400
Received: from ns.horizon.com ([71.41.210.147]:49011 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752544AbaFGCt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 22:49:29 -0400
Date: 6 Jun 2014 22:49:28 -0400
Message-ID: <20140607024928.14178.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, rdunlap@infradead.org, tj@kernel.org
Subject: [PATCH v2 2/3] lib: glob.c: Add CONFIG_GLOB_SELFTEST
Cc: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com
In-Reply-To: <20140607024404.13786.qmail@ns.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was useful during development, and is retained for future regression
testing.

GCC appears to have no way to place string literals in a particular
section; adding __initconst to a char pointer leaves the string itself
in the default string section, where it will not be thrown away after
module load.

Thus all string constants are kept in explicitly declared and named
arrays.  Sorry this makes printk a bit harder to read.  At least the
tests are more compact.

Signed-off-by: George Spelvin <linux@horizon.com>
---
Persuading GCC to throw away *all* the self-test data after running
it was surprisingly annoying.

The one thing I'm not really sure about is what to do if the self-test
fails.  For now, I make the module_init function fail too.  Opinions?

 lib/Kconfig |  14 ++++++
 lib/glob.c  | 164 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 178 insertions(+)

diff --git a/lib/Kconfig b/lib/Kconfig
index 4a607036..49592008 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -401,6 +401,20 @@ config GLOB
 	  are compiling an out-of tree driver which tells you that it
 	  depends on this.
 
+config GLOB_SELFTEST
+	bool "glob self-test on init"
+	default n
+	depends on GLOB
+	help
+	  This option enables a simple self-test of the glob_match
+	  function on startup.	It is primarily useful for people
+	  working on the code to ensure they haven't introduced any
+	  regressions.
+
+	  It only adds a little bit of code and slows kernel boot (or
+	  module load) by a small amount, so you're welcome to play with
+	  it, but you probably don't need it.
+
 #
 # Netlink attribute parsing support is select'ed if needed
 #
diff --git a/lib/glob.c b/lib/glob.c
index 05beb470..671f80d3 100644
--- a/lib/glob.c
+++ b/lib/glob.c
@@ -121,3 +121,167 @@ backtrack:
 	}
 }
 EXPORT_SYMBOL(glob_match);
+
+
+#ifdef CONFIG_GLOB_SELFTEST
+
+#include <linux/printk.h>
+#include <linux/moduleparam.h>
+
+/* Boot with "glob.verbose=1" to show successful tests, too */
+static bool verbose = false;
+module_param(verbose, bool, 0);
+
+struct glob_test {
+	char const *pat, *str;
+	bool expected;
+};
+
+static bool __pure __init test(char const *pat, char const *str, bool expected)
+{
+	bool match = glob_match(pat, str);
+	bool success = match == expected;
+
+	/* Can't get string literals into a particular section, so... */
+	static char const msg_error[] __initconst =
+		KERN_ERR "glob: \"%s\" vs. \"%s\": %s *** ERROR ***\n";
+	static char const msg_ok[] __initconst =
+		KERN_DEBUG "glob: \"%s\" vs. \"%s\": %s OK\n";
+	static char const mismatch[] __initconst = "mismatch";
+	char const *message;
+
+	if (!success)
+		message = msg_error;
+	else if (verbose)
+		message = msg_ok;
+	else
+		return success;
+
+	printk(message, pat, str, mismatch + 3*match);
+	return success;
+}
+
+/*
+ * The tests are all jammed together in one array to make it simpler
+ * to place that array in the .init.rodata section.  The obvious
+ * "array of structures containing char *" has no way to force the
+ * pointed-to strings to be in a particular section.
+ *
+ * Anyway, a test consists of:
+ * 1. Expected glob_match result: '1' or '0'.
+ * 2. Pattern to match: null-terminated string
+ * 3. String to match against: null-terminated string
+ *
+ * The list of tests is terminated with a final '\0' instead of
+ * a glob_match result character.
+ */
+static char const glob_tests[] __initconst = 
+	/* Some basic tests */
+	"1" "a\0" "a\0"
+	"0" "a\0" "b\0"
+	"0" "a\0" "aa\0"
+	"0" "a\0" "\0"
+	"1" "\0" "\0"
+	"0" "\0" "a\0"
+	/* Simple character class tests */
+	"1" "[a]\0" "a\0"
+	"0" "[a]\0" "b\0"
+	"0" "[!a]\0" "a\0"
+	"1" "[!a]\0" "b\0"
+	"1" "[ab]\0" "a\0"
+	"1" "[ab]\0" "b\0"
+	"0" "[ab]\0" "c\0"
+	"1" "[!ab]\0" "c\0"
+	"1" "[a-c]\0" "b\0"
+	"0" "[a-c]\0" "d\0"
+	/* Corner cases in character class parsing */
+	"1" "[a-c-e-g]\0" "-\0"
+	"0" "[a-c-e-g]\0" "d\0"
+	"1" "[a-c-e-g]\0" "f\0"
+	"1" "[]a-ceg-ik[]\0" "a\0"
+	"1" "[]a-ceg-ik[]\0" "]\0"
+	"1" "[]a-ceg-ik[]\0" "[\0"
+	"1" "[]a-ceg-ik[]\0" "h\0"
+	"0" "[]a-ceg-ik[]\0" "f\0"
+	"0" "[!]a-ceg-ik[]\0" "h\0"
+	"0" "[!]a-ceg-ik[]\0" "]\0"
+	"1" "[!]a-ceg-ik[]\0" "f\0"
+	/* Simple wild cards */
+	"1" "?\0" "a\0"
+	"0" "?\0" "aa\0"
+	"0" "??\0" "a\0"
+	"1" "?x?\0" "axb\0"
+	"0" "?x?\0" "abx\0"
+	"0" "?x?\0" "xab\0"
+	/* Asterisk wild cards (backtracking) */
+	"0" "*??\0" "a\0"
+	"1" "*??\0" "ab\0"
+	"1" "*??\0" "abc\0"
+	"1" "*??\0" "abcd\0"
+	"0" "??*\0" "a\0"
+	"1" "??*\0" "ab\0"
+	"1" "??*\0" "abc\0"
+	"1" "??*\0" "abcd\0"
+	"0" "?*?\0" "a\0"
+	"1" "?*?\0" "ab\0"
+	"1" "?*?\0" "abc\0"
+	"1" "?*?\0" "abcd\0"
+	"1" "*b\0" "b\0"
+	"1" "*b\0" "ab\0"
+	"0" "*b\0" "ba\0"
+	"1" "*b\0" "bb\0"
+	"1" "*b\0" "abb\0"
+	"1" "*b\0" "bab\0"
+	"1" "*bc\0" "abbc\0"
+	"1" "*bc\0" "bc\0"
+	"1" "*bc\0" "bbc\0"
+	"1" "*bc\0" "bcbc\0"
+	/* Multiple asterisks (complex backtracking) */
+	"1" "*ac*\0" "abacadaeafag\0"
+	"1" "*ac*ae*ag*\0" "abacadaeafag\0"
+	"1" "*a*b*[bc]*[ef]*g*\0" "abacadaeafag\0"
+	"0" "*a*b*[ef]*[cd]*g*\0" "abacadaeafag\0"
+	"1" "*abcd*\0" "abcabcabcabcdefg\0"
+	"1" "*ab*cd*\0" "abcabcabcabcdefg\0"
+	"1" "*abcd*abcdef*\0" "abcabcdabcdeabcdefg\0"
+	"0" "*abcd*\0" "abcabcabcabcefg\0"
+	"0" "*ab*cd*\0" "abcabcabcabcefg\0";
+
+static int __init glob_init(void)
+{
+	unsigned successes = 0;
+	unsigned n = 0;
+	char const *p = glob_tests;
+	static char const message[] __initconst =
+		KERN_INFO "glob: %u self-tests passed, %u failed\n";
+
+	/*
+	 * Tests are jammed together in a string.  The first byte is '1'
+	 * or '0' to indicate the expected outcome, or '\0' to indicate the
+	 * end of the tests.  Then come two null-terminated strings: the
+	 * pattern and the string to match it against.
+	 */
+	while (*p) {
+		bool expected = *p++ & 1;
+		char const *pat = p;
+
+		p += strlen(p) + 1;
+		successes += test(pat, p, expected);
+		p += strlen(p) + 1;
+		n++;
+	}
+
+	n -= successes;
+	printk(message, successes, n);
+
+	/* What's the errno for "kernel bug detected"?  Guess... */
+	return n ? -ECANCELED : 0;
+}
+
+/* We need a dummy exit function to allow unload */
+static void __exit glob_fini(void) { }
+
+module_init(glob_init);
+module_exit(glob_fini);
+
+#endif /* CONFIG_GLOB_SELFTEST */
-- 
2.0.0

