Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab3DLMb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 08:31:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:37038 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123Ab3DLMam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 08:30:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,462,1363158000"; 
   d="scan'208";a="321404549"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Baron <jbaron@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 1/4] lib/string_helpers: introduce generic string_unescape
Date: Fri, 12 Apr 2013 15:30:17 +0300
Message-Id: <1365769820-28953-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several places in kernel where modules unescapes input to convert
C-Style Escape Sequences into byte codes.

The patch provides generic implementation of such approach. Test cases are
also included into the patch.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
---
 include/linux/string_helpers.h |  58 ++++++++++++++++++
 lib/Kconfig.debug              |   3 +
 lib/Makefile                   |   4 +-
 lib/string_helpers.c           | 133 +++++++++++++++++++++++++++++++++++++++++
 lib/test-string_helpers.c      | 103 +++++++++++++++++++++++++++++++
 5 files changed, 300 insertions(+), 1 deletion(-)
 create mode 100644 lib/test-string_helpers.c

diff --git a/include/linux/string_helpers.h b/include/linux/string_helpers.h
index a3eb2f6..c18df71 100644
--- a/include/linux/string_helpers.h
+++ b/include/linux/string_helpers.h
@@ -13,4 +13,62 @@ enum string_size_units {
 int string_get_size(u64 size, enum string_size_units units,
 		    char *buf, int len);
 
+#define UNESCAPE_SPACE		0x01
+#define UNESCAPE_OCTAL		0x02
+#define UNESCAPE_HEX		0x04
+#define UNESCAPE_SPECIAL	0x08
+#define UNESCAPE_ANY		\
+	(UNESCAPE_SPACE | UNESCAPE_OCTAL | UNESCAPE_HEX | UNESCAPE_SPECIAL)
+
+/**
+ * string_unescape - unquote characters in the given string
+ * @src:	source buffer (escaped)
+ * @dst:	destination buffer (unescaped)
+ * @size:	size of the destination buffer (0 to unlimit)
+ * @flags:	combination of the flags (bitwise OR):
+ *	%UNESCAPE_SPACE:
+ *		'\f' - form feed
+ *		'\n' - new line
+ *		'\r' - carriage return
+ *		'\t' - horizontal tab
+ *		'\v' - vertical tab
+ *	%UNESCAPE_OCTAL:
+ *		'\NNN' - byte with octal value NNN (1 to 3 digits)
+ *	%UNESCAPE_HEX:
+ *		'\xHH' - byte with hexadecimal value HH (1 to 2 digits)
+ *	%UNESCAPE_SPECIAL:
+ *		'\"' - double quote
+ *		'\\' - backslash
+ *		'\a' - alert (BEL)
+ *		'\e' - escape
+ *	%UNESCAPE_ANY:
+ *		all previous together
+ *
+ * Returns amount of characters processed to the destination buffer excluding
+ * trailing '\0'.
+ *
+ * Due to size of output will be the same or smaller the translation could be
+ * done in place.
+ *
+ * Caller must provide valid source and destination pointers. Be aware that
+ * destination buffer will always be NULL-terminated. Source string must be
+ * NULL-terminated as well.
+ */
+int string_unescape(char *src, char *dst, size_t size, unsigned int flags);
+
+static inline int string_unescape_inplace(char *buf, unsigned int flags)
+{
+	return string_unescape(buf, buf, 0, flags);
+}
+
+static inline int string_unescape_any(char *src, char *dst, size_t size)
+{
+	return string_unescape(src, dst, size, UNESCAPE_ANY);
+}
+
+static inline int string_unescape_any_inplace(char *buf)
+{
+	return string_unescape_any(buf, buf, 0);
+}
+
 #endif
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index ae80518..770a422 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1481,5 +1481,8 @@ source "lib/Kconfig.kgdb"
 
 source "lib/Kconfig.kmemcheck"
 
+config TEST_STRING_HELPERS
+	tristate "Test functions located in the string_helpers module at runtime"
+
 config TEST_KSTRTOX
 	tristate "Test kstrto*() family of functions at runtime"
diff --git a/lib/Makefile b/lib/Makefile
index 10facc6..370a1d6 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -23,8 +23,10 @@ lib-y	+= kobject.o klist.o
 
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
-	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o flex_array.o \
+	 gcd.o lcm.o list_sort.o uuid.o flex_array.o \
 	 bsearch.o find_last_bit.o find_next_bit.o llist.o memweight.o kfifo.o
+obj-y += string_helpers.o
+obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
 obj-y += kstrtox.o
 obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
 
diff --git a/lib/string_helpers.c b/lib/string_helpers.c
index 1cffc22..ed5c145 100644
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -2,10 +2,12 @@
  * Helpers for formatting and printing strings
  *
  * Copyright 31 August 2008 James Bottomley
+ * Copyright (C) 2013, Intel Corporation
  */
 #include <linux/kernel.h>
 #include <linux/math64.h>
 #include <linux/export.h>
+#include <linux/ctype.h>
 #include <linux/string_helpers.h>
 
 /**
@@ -66,3 +68,134 @@ int string_get_size(u64 size, const enum string_size_units units,
 	return 0;
 }
 EXPORT_SYMBOL(string_get_size);
+
+static bool unescape_space(char **src, char **dst)
+{
+	char *p = *dst, *q = *src;
+
+	switch (*q) {
+	case 'n':
+		*p = '\n';
+		break;
+	case 'r':
+		*p = '\r';
+		break;
+	case 't':
+		*p = '\t';
+		break;
+	case 'v':
+		*p = '\v';
+		break;
+	case 'f':
+		*p = '\f';
+		break;
+	default:
+		return false;
+	}
+	*dst += 1;
+	*src += 1;
+	return true;
+}
+
+static bool unescape_octal(char **src, char **dst)
+{
+	char *p = *dst, *q = *src;
+	u8 num;
+
+	if (isodigit(*q) == 0)
+		return false;
+
+	num = (*q++) & 7;
+	while (num < 32 && isodigit(*q) && (q - *src < 3)) {
+		num <<= 3;
+		num += (*q++) & 7;
+	}
+	*p = num;
+	*dst += 1;
+	*src = q;
+	return true;
+}
+
+static bool unescape_hex(char **src, char **dst)
+{
+	char *p = *dst, *q = *src;
+	int digit;
+	u8 num;
+
+	if (*q++ != 'x')
+		return false;
+
+	num = digit = hex_to_bin(*q++);
+	if (digit < 0)
+		return false;
+
+	digit = hex_to_bin(*q);
+	if (digit >= 0) {
+		q++;
+		num = (num << 4) | digit;
+	}
+	*p = num;
+	*dst += 1;
+	*src = q;
+	return true;
+}
+
+static bool unescape_special(char **src, char **dst)
+{
+	char *p = *dst, *q = *src;
+
+	switch (*q) {
+	case '\"':
+		*p = '\"';
+		break;
+	case '\\':
+		*p = '\\';
+		break;
+	case 'a':
+		*p = '\a';
+		break;
+	case 'e':
+		*p = '\e';
+		break;
+	default:
+		return false;
+	}
+	*dst += 1;
+	*src += 1;
+	return true;
+}
+
+int string_unescape(char *src, char *dst, size_t size, unsigned int flags)
+{
+	char *out = dst;
+
+	while (*src && --size) {
+		if (src[0] == '\\' && src[1] != '\0' && size > 1) {
+			src++;
+			size--;
+
+			if (flags & UNESCAPE_SPACE &&
+					unescape_space(&src, &out))
+				continue;
+
+			if (flags & UNESCAPE_OCTAL &&
+					unescape_octal(&src, &out))
+				continue;
+
+			if (flags & UNESCAPE_HEX &&
+					unescape_hex(&src, &out))
+				continue;
+
+			if (flags & UNESCAPE_SPECIAL &&
+					unescape_special(&src, &out))
+				continue;
+
+			*out++ = '\\';
+		}
+		*out++ = *src++;
+	}
+	*out = '\0';
+
+	return out - dst;
+}
+EXPORT_SYMBOL(string_unescape);
diff --git a/lib/test-string_helpers.c b/lib/test-string_helpers.c
new file mode 100644
index 0000000..6ac48de
--- /dev/null
+++ b/lib/test-string_helpers.c
@@ -0,0 +1,103 @@
+/*
+ * Test cases for lib/string_helpers.c module.
+ */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/random.h>
+#include <linux/string.h>
+#include <linux/string_helpers.h>
+
+struct test_string {
+	const char *in;
+	const char *out;
+	unsigned int flags;
+};
+
+static const struct test_string strings[] __initconst = {
+	{
+		.in = "\\f\\ \\n\\r\\t\\v",
+		.out = "\f\\ \n\r\t\v",
+		.flags = UNESCAPE_SPACE,
+	},
+	{
+		.in = "\\40\\1\\387\\0064\\05\\040\\8a\\110\\777",
+		.out = " \001\00387\0064\005 \\8aH?7",
+		.flags = UNESCAPE_OCTAL,
+	},
+	{
+		.in = "\\xv\\xa\\x2c\\xD\\x6f2",
+		.out = "\\xv\n,\ro2",
+		.flags = UNESCAPE_HEX,
+	},
+	{
+		.in = "\\h\\\\\\\"\\a\\e\\",
+		.out = "\\h\\\"\a\e\\",
+		.flags = UNESCAPE_SPECIAL,
+	},
+};
+
+static void __init test_string_unescape(unsigned int flags, bool inplace)
+{
+	char in[256];
+	char out_test[256];
+	char out_real[256];
+	int i, p = 0, q_test = 0, q_real = sizeof(out_real);
+
+	for (i = 0; i < ARRAY_SIZE(strings); i++) {
+		const char *s = strings[i].in;
+		int len = strlen(strings[i].in);
+
+		/* Copy string to in buffer */
+		memcpy(&in[p], s, len);
+		p += len;
+
+		/* Copy expected result for given flags */
+		if (flags & strings[i].flags) {
+			s = strings[i].out;
+			len = strlen(strings[i].out);
+		}
+		memcpy(&out_test[q_test], s, len);
+		q_test += len;
+	}
+	in[p++] = '\0';
+
+	/* Call string_unescape and compare result */
+	if (inplace) {
+		memcpy(out_real, in, p);
+		if (flags == UNESCAPE_ANY)
+			q_real = string_unescape_any_inplace(out_real);
+		else
+			q_real = string_unescape_inplace(out_real, flags);
+	} else if (flags == UNESCAPE_ANY) {
+		q_real = string_unescape_any(in, out_real, q_real);
+	} else {
+		q_real = string_unescape(in, out_real, q_real, flags);
+	}
+
+	if (q_real != q_test || memcmp(out_test, out_real, q_test)) {
+		pr_warn("Test failed: flags = %u\n", flags);
+		print_hex_dump(KERN_WARNING, "Input: ",
+			       DUMP_PREFIX_NONE, 16, 1, in, p - 1, true);
+		print_hex_dump(KERN_WARNING, "Expected: ",
+			       DUMP_PREFIX_NONE, 16, 1, out_test, q_test, true);
+		print_hex_dump(KERN_WARNING, "Got: ",
+			       DUMP_PREFIX_NONE, 16, 1, out_real, q_real, true);
+	}
+}
+
+static int __init test_string_helpers_init(void)
+{
+	unsigned int i;
+
+	pr_info("Running tests...\n");
+	for (i = 0; i < UNESCAPE_ANY + 1; i++)
+		test_string_unescape(i, false);
+	test_string_unescape(get_random_int() % (UNESCAPE_ANY + 1), true);
+
+	return -EINVAL;
+}
+module_init(test_string_helpers_init);
+MODULE_LICENSE("Dual BSD/GPL");
-- 
1.8.2.rc0.22.gb3600c3

