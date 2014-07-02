Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbaGBNUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:20:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:38767 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550AbaGBNUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:20:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,588,1400050800"; 
   d="scan'208";a="564157324"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 2/6] lib / string_helpers: introduce string_escape_mem()
Date: Wed,  2 Jul 2014 16:20:25 +0300
Message-Id: <1404307229-19186-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404307229-19186-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1404307229-19186-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is almost the opposite function to string_unescape(). Nevertheless it
handles \0 and could be used for any byte buffer.

The documentation is supplied together with the function prototype.

The test cases covers most of the scenarios and would be expanded later on.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 include/linux/string_helpers.h |  83 ++++++++++++++++
 lib/string_helpers.c           | 215 +++++++++++++++++++++++++++++++++++++++++
 lib/test-string_helpers.c      | 213 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 511 insertions(+)

diff --git a/include/linux/string_helpers.h b/include/linux/string_helpers.h
index 3eeee96..db13f20 100644
--- a/include/linux/string_helpers.h
+++ b/include/linux/string_helpers.h
@@ -71,4 +71,87 @@ static inline int string_unescape_any_inplace(char *buf)
 	return string_unescape_any(buf, buf, 0);
 }
 
+#define ESCAPE_SPACE		0x01
+#define ESCAPE_SPECIAL		0x02
+#define ESCAPE_NULL		0x04
+#define ESCAPE_OCTAL		0x08
+#define ESCAPE_ANY		\
+	(ESCAPE_SPACE | ESCAPE_OCTAL | ESCAPE_SPECIAL | ESCAPE_NULL)
+#define ESCAPE_NP		0x10
+#define ESCAPE_ANY_NP		(ESCAPE_ANY | ESCAPE_NP)
+#define ESCAPE_HEX		0x20
+
+/**
+ * string_escape_mem - quote characters in the given memory buffer
+ * @src:	source buffer (unescaped)
+ * @isz:	source buffer size
+ * @dst:	destination buffer (escaped)
+ * @osz:	destination buffer size
+ * @flags:	combination of the flags (bitwise OR):
+ *	%ESCAPE_SPACE:
+ *		'\f' - form feed
+ *		'\n' - new line
+ *		'\r' - carriage return
+ *		'\t' - horizontal tab
+ *		'\v' - vertical tab
+ *	%ESCAPE_SPECIAL:
+ *		'\\' - backslash
+ *		'\a' - alert (BEL)
+ *		'\e' - escape
+ *	%ESCAPE_NULL:
+ *		'\0' - null
+ *	%ESCAPE_OCTAL:
+ *		'\NNN' - byte with octal value NNN (3 digits)
+ *	%ESCAPE_ANY:
+ *		all previous together
+ *	%ESCAPE_NP:
+ *		escape only non-printable characters (checked by isprint)
+ *	%ESCAPE_ANY_NP:
+ *		all previous together
+ *	%ESCAPE_HEX:
+ *		'\xHH' - byte with hexadecimal value HH (2 digits)
+ * @esc:	NULL-terminated string of characters any of which, if found in
+ *		the source, has to be escaped
+ *
+ * Description:
+ * The process of escaping byte buffer includes several parts. They are applied
+ * in the following sequence.
+ *	1. The character is matched to the printable class, if asked, and in
+ *	   case of match it passes through to the output.
+ *	2. The character is not matched to the one from @esc string and thus
+ *	   must go as is to the output.
+ *	3. The character is checked if it falls into the class given by @flags.
+ *	   %ESCAPE_OCTAL and %ESCAPE_HEX are going last since they cover any
+ *	   character. Note that they actually can't go together, otherwise
+ *	   %ESCAPE_HEX will be ignored.
+ *
+ * Caller must provide valid source and destination pointers. Be aware that
+ * destination buffer will not be NULL-terminated, thus caller have to append
+ * it if needs.
+ *
+ * Return: amount of characters processed to the destination buffer, or
+ * 	   %-ENOMEM if the size of buffer is not enough to put an escaped
+ * 	   character.
+ */
+int string_escape_mem(const char *src, size_t isz, char *dst, size_t osz,
+		unsigned int flags, const char *esc);
+
+static inline int string_escape_mem_any_np(const char *src, size_t isz,
+		char *dst, size_t osz, const char *esc)
+{
+	return string_escape_mem(src, isz, dst, osz, ESCAPE_ANY_NP, esc);
+}
+
+static inline int string_escape_str(const char *src, char *dst, size_t sz,
+		unsigned int flags, const char *esc)
+{
+	return string_escape_mem(src, strlen(src), dst, sz, flags, esc);
+}
+
+static inline int string_escape_str_any_np(const char *src, char *dst,
+		size_t sz, const char *esc)
+{
+	return string_escape_str(src, dst, sz, ESCAPE_ANY_NP, esc);
+}
+
 #endif
diff --git a/lib/string_helpers.c b/lib/string_helpers.c
index 29033f3..00112eb 100644
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -8,6 +8,8 @@
 #include <linux/math64.h>
 #include <linux/export.h>
 #include <linux/ctype.h>
+#include <linux/errno.h>
+#include <linux/string.h>
 #include <linux/string_helpers.h>
 
 /**
@@ -202,3 +204,216 @@ int string_unescape(char *src, char *dst, size_t size, unsigned int flags)
 	return out - dst;
 }
 EXPORT_SYMBOL(string_unescape);
+
+static int escape_passthrough(unsigned char c, char **dst, size_t *osz)
+{
+	char *out = *dst;
+
+	if (*osz < 1)
+		return -ENOMEM;
+
+	*out++ = c;
+
+	*dst = out;
+	*osz -= 1;
+
+	return 1;
+}
+
+static int escape_space(unsigned char c, char **dst, size_t *osz)
+{
+	char *out = *dst;
+	unsigned char to;
+
+	if (*osz < 2)
+		return -ENOMEM;
+
+	switch (c) {
+	case '\n':
+		to = 'n';
+		break;
+	case '\r':
+		to = 'r';
+		break;
+	case '\t':
+		to = 't';
+		break;
+	case '\v':
+		to = 'v';
+		break;
+	case '\f':
+		to = 'f';
+		break;
+	default:
+		return 0;
+	}
+
+	*out++ = '\\';
+	*out++ = to;
+
+	*dst = out;
+	*osz -= 2;
+
+	return 1;
+}
+
+static int escape_special(unsigned char c, char **dst, size_t *osz)
+{
+	char *out = *dst;
+	unsigned char to;
+
+	if (*osz < 2)
+		return -ENOMEM;
+
+	switch (c) {
+	case '\\':
+		to = '\\';
+		break;
+	case '\a':
+		to = 'a';
+		break;
+	case '\e':
+		to = 'e';
+		break;
+	default:
+		return 0;
+	}
+
+	*out++ = '\\';
+	*out++ = to;
+
+	*dst = out;
+	*osz -= 2;
+
+	return 1;
+}
+
+static int escape_null(unsigned char c, char **dst, size_t *osz)
+{
+	char *out = *dst;
+
+	if (*osz < 2)
+		return -ENOMEM;
+
+	if (c)
+		return 0;
+
+	*out++ = '\\';
+	*out++ = '0';
+
+	*dst = out;
+	*osz -= 2;
+
+	return 1;
+}
+
+static int escape_octal(unsigned char c, char **dst, size_t *osz)
+{
+	char *out = *dst;
+
+	if (*osz < 4)
+		return -ENOMEM;
+
+	*out++ = '\\';
+	*out++ = ((c >> 6) & 0x07) + '0';
+	*out++ = ((c >> 3) & 0x07) + '0';
+	*out++ = ((c >> 0) & 0x07) + '0';
+
+	*dst = out;
+	*osz -= 4;
+
+	return 1;
+}
+
+static int escape_hex(unsigned char c, char **dst, size_t *osz)
+{
+	char *out = *dst;
+
+	if (*osz < 4)
+		return -ENOMEM;
+
+	*out++ = '\\';
+	*out++ = 'x';
+	*out++ = hex_asc_hi(c);
+	*out++ = hex_asc_lo(c);
+
+	*dst = out;
+	*osz -= 4;
+
+	return 1;
+}
+
+int string_escape_mem(const char *src, size_t isz, char *dst, size_t osz,
+		      unsigned int flags, const char *esc)
+{
+	char *out = dst;
+	int ret = 0;
+
+	while (isz--) {
+		unsigned char c = *src++;
+
+		/*
+		 * Apply rules in the following sequence:
+		 *	- the character is printable, when @flags has
+		 *	  %ESCAPE_NP bit set
+		 *	- the @esc string is supplied and does not contain a
+		 *	  character under question
+		 *	- the character doesn't fall into a class of symbols
+		 *	  defined by given @flags
+		 * In these cases we just pass through a character to the
+		 * output buffer.
+		 */
+		if ((flags & ESCAPE_NP && isprint(c)) ||
+		    (esc && *esc && !strchr(esc, c))) {
+			/* do nothing */
+		} else {
+			if (flags & ESCAPE_SPACE) {
+				ret = escape_space(c, &out, &osz);
+				if (ret < 0)
+					break;
+				if (ret > 0)
+					continue;
+			}
+
+			if (flags & ESCAPE_SPECIAL) {
+				ret = escape_special(c, &out, &osz);
+				if (ret < 0)
+					break;
+				if (ret > 0)
+					continue;
+			}
+
+			if (flags & ESCAPE_NULL) {
+				ret = escape_null(c, &out, &osz);
+				if (ret < 0)
+					break;
+				if (ret > 0)
+					continue;
+			}
+
+			/* ESCAPE_OCTAL and ESCAPE_HEX always go last */
+			if (flags & ESCAPE_OCTAL) {
+				ret = escape_octal(c, &out, &osz);
+				if (ret < 0)
+					break;
+				continue;
+			}
+			if (flags & ESCAPE_HEX) {
+				ret = escape_hex(c, &out, &osz);
+				if (ret < 0)
+					break;
+				continue;
+			}
+		}
+
+		ret = escape_passthrough(c, &out, &osz);
+		if (ret < 0)
+			break;
+	}
+
+	if (ret < 0)
+		return ret;
+
+	return out - dst;
+}
+EXPORT_SYMBOL(string_escape_mem);
diff --git a/lib/test-string_helpers.c b/lib/test-string_helpers.c
index ea86e02..4b022ae 100644
--- a/lib/test-string_helpers.c
+++ b/lib/test-string_helpers.c
@@ -102,6 +102,209 @@ static void __init test_string_unescape(const char *name, unsigned int flags,
 			      out_test, q_test);
 }
 
+struct test_string_1 {
+	const char *out;
+	unsigned int flags;
+};
+
+#define	TEST_STRING_2_MAX_S1		32
+struct test_string_2 {
+	const char *in;
+	struct test_string_1 s1[TEST_STRING_2_MAX_S1];
+};
+
+#define	TEST_STRING_2_DICT_0		NULL
+static const struct test_string_2 escape0[] __initconst = {{
+	.in = "\f\\ \n\r\t\v",
+	.s1 = {{
+		.out = "\\f\\ \\n\\r\\t\\v",
+		.flags = ESCAPE_SPACE,
+	},{
+		.out = "\\f\\134\\040\\n\\r\\t\\v",
+		.flags = ESCAPE_SPACE | ESCAPE_OCTAL,
+	},{
+		.out = "\\f\\x5c\\x20\\n\\r\\t\\v",
+		.flags = ESCAPE_SPACE | ESCAPE_HEX,
+	},{
+		/* terminator */
+	}},
+},{
+	.in = "\\h\\\"\a\e\\",
+	.s1 = {{
+		.out = "\\\\h\\\\\"\\a\\e\\\\",
+		.flags = ESCAPE_SPECIAL,
+	},{
+		.out = "\\\\\\150\\\\\\042\\a\\e\\\\",
+		.flags = ESCAPE_SPECIAL | ESCAPE_OCTAL,
+	},{
+		.out = "\\\\\\x68\\\\\\x22\\a\\e\\\\",
+		.flags = ESCAPE_SPECIAL | ESCAPE_HEX,
+	},{
+		/* terminator */
+	}},
+},{
+	.in = "\eb \\C\007\"\x90\r]",
+	.s1 = {{
+		.out = "\eb \\C\007\"\x90\\r]",
+		.flags = ESCAPE_SPACE,
+	},{
+		.out = "\\eb \\\\C\\a\"\x90\r]",
+		.flags = ESCAPE_SPECIAL,
+	},{
+		.out = "\\eb \\\\C\\a\"\x90\\r]",
+		.flags = ESCAPE_SPACE | ESCAPE_SPECIAL,
+	},{
+		.out = "\\033\\142\\040\\134\\103\\007\\042\\220\\015\\135",
+		.flags = ESCAPE_OCTAL,
+	},{
+		.out = "\\033\\142\\040\\134\\103\\007\\042\\220\\r\\135",
+		.flags = ESCAPE_SPACE | ESCAPE_OCTAL,
+	},{
+		.out = "\\e\\142\\040\\\\\\103\\a\\042\\220\\015\\135",
+		.flags = ESCAPE_SPECIAL | ESCAPE_OCTAL,
+	},{
+		.out = "\\e\\142\\040\\\\\\103\\a\\042\\220\\r\\135",
+		.flags = ESCAPE_SPACE | ESCAPE_SPECIAL | ESCAPE_OCTAL,
+	},{
+		.out = "\eb \\C\007\"\x90\r]",
+		.flags = ESCAPE_NP,
+	},{
+		.out = "\eb \\C\007\"\x90\\r]",
+		.flags = ESCAPE_SPACE | ESCAPE_NP,
+	},{
+		.out = "\\eb \\C\\a\"\x90\r]",
+		.flags = ESCAPE_SPECIAL | ESCAPE_NP,
+	},{
+		.out = "\\eb \\C\\a\"\x90\\r]",
+		.flags = ESCAPE_SPACE | ESCAPE_SPECIAL | ESCAPE_NP,
+	},{
+		.out = "\\033b \\C\\007\"\\220\\015]",
+		.flags = ESCAPE_OCTAL | ESCAPE_NP,
+	},{
+		.out = "\\033b \\C\\007\"\\220\\r]",
+		.flags = ESCAPE_SPACE | ESCAPE_OCTAL | ESCAPE_NP,
+	},{
+		.out = "\\eb \\C\\a\"\\220\\r]",
+		.flags = ESCAPE_SPECIAL | ESCAPE_SPACE | ESCAPE_OCTAL |
+			 ESCAPE_NP,
+	},{
+		.out = "\\x1bb \\C\\x07\"\\x90\\x0d]",
+		.flags = ESCAPE_NP | ESCAPE_HEX,
+	},{
+		/* terminator */
+	}},
+},{
+	/* terminator */
+}};
+
+#define	TEST_STRING_2_DICT_1		"b\\ \t\r"
+static const struct test_string_2 escape1[] __initconst = {{
+	.in = "\f\\ \n\r\t\v",
+	.s1 = {{
+		.out = "\f\\134\\040\n\\015\\011\v",
+		.flags = ESCAPE_OCTAL,
+	},{
+		.out = "\f\\x5c\\x20\n\\x0d\\x09\v",
+		.flags = ESCAPE_HEX,
+	},{
+		/* terminator */
+	}},
+},{
+	.in = "\\h\\\"\a\e\\",
+	.s1 = {{
+		.out = "\\134h\\134\"\a\e\\134",
+		.flags = ESCAPE_OCTAL,
+	},{
+		/* terminator */
+	}},
+},{
+	.in = "\eb \\C\007\"\x90\r]",
+	.s1 = {{
+		.out = "\e\\142\\040\\134C\007\"\x90\\015]",
+		.flags = ESCAPE_OCTAL,
+	},{
+		/* terminator */
+	}},
+},{
+	/* terminator */
+}};
+
+static __init const char *test_string_find_match(const struct test_string_2 *s2,
+						 unsigned int flags)
+{
+	const struct test_string_1 *s1 = s2->s1;
+	unsigned int i;
+
+	if (!flags)
+		return s2->in;
+
+	/* Test cases are NULL-aware */
+	flags &= ~ESCAPE_NULL;
+
+	/* ESCAPE_OCTAL has a higher priority */
+	if (flags & ESCAPE_OCTAL)
+		flags &= ~ESCAPE_HEX;
+
+	for (i = 0; i < TEST_STRING_2_MAX_S1 && s1->out; i++, s1++)
+		if (s1->flags == flags)
+			return s1->out;
+	return NULL;
+}
+
+static __init void test_string_escape(const char *name,
+				      const struct test_string_2 *s2,
+				      unsigned int flags, const char *esc)
+{
+	char in[256];
+	char out_test[512];
+	char out_real[512];
+	int p = 0, q_test = 0, q_real = sizeof(out_real);
+
+	for (; s2->in; s2++) {
+		const char *out;
+		int len;
+
+		/* NULL injection */
+		if (flags & ESCAPE_NULL) {
+			in[p++] = '\0';
+			out_test[q_test++] = '\\';
+			out_test[q_test++] = '0';
+		}
+
+		/* Don't try strings that have no output */
+		out = test_string_find_match(s2, flags);
+		if (!out)
+			continue;
+
+		/* Copy string to in buffer */
+		len = strlen(s2->in);
+		memcpy(&in[p], s2->in, len);
+		p += len;
+
+		/* Copy expected result for given flags */
+		len = strlen(out);
+		memcpy(&out_test[q_test], out, len);
+		q_test += len;
+	}
+
+	q_real = string_escape_mem(in, p, out_real, q_real, flags, esc);
+
+	test_string_check_buf(name, flags, in, p, out_real, q_real, out_test, q_test);
+}
+
+static __init void test_string_escape_nomem(void)
+{
+	char *in = "\eb \\C\007\"\x90\r]";
+	char out[64];
+	int rc = -ENOMEM, ret;
+
+	ret = string_escape_str_any_np(in, out, strlen(in), NULL);
+	if (ret == rc)
+		return;
+
+	pr_err("Test 'escape nomem' failed: got %d instead of %d\n", ret, rc);
+}
+
 static int __init test_string_helpers_init(void)
 {
 	unsigned int i;
@@ -112,6 +315,16 @@ static int __init test_string_helpers_init(void)
 	test_string_unescape("unescape inplace",
 			     get_random_int() % (UNESCAPE_ANY + 1), true);
 
+	/* Without dictionary */
+	for (i = 0; i < (ESCAPE_ANY_NP | ESCAPE_HEX) + 1; i++)
+		test_string_escape("escape 0", escape0, i, TEST_STRING_2_DICT_0);
+
+	/* With dictionary */
+	for (i = 0; i < (ESCAPE_ANY_NP | ESCAPE_HEX) + 1; i++)
+		test_string_escape("escape 1", escape1, i, TEST_STRING_2_DICT_1);
+
+	test_string_escape_nomem();
+
 	return -EINVAL;
 }
 module_init(test_string_helpers_init);
-- 
2.0.0

