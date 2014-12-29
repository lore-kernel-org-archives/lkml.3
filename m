Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbaL2LvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 06:51:04 -0500
Received: from mga03.intel.com ([134.134.136.65]:47817 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbaL2Luq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 06:50:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,659,1413270000"; 
   d="scan'208";a="630324032"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/4] hexdump: introduce test suite
Date: Mon, 29 Dec 2014 13:50:51 +0200
Message-Id: <1419853854-5602-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419853854-5602-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1419853854-5602-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Test different scenarios of function calls located in lib/hexdump.c.

Currently hex_dump_to_buffer() is only tested and test data is provided for
little endian CPUs.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 lib/Kconfig.debug  |   3 ++
 lib/Makefile       |   4 +-
 lib/test-hexdump.c | 135 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 141 insertions(+), 1 deletion(-)
 create mode 100644 lib/test-hexdump.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a4a6d9a..5fe0a71 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1580,6 +1580,9 @@ config ASYNC_RAID6_TEST
 
 	  If unsure, say N.
 
+config TEST_HEXDUMP
+	tristate "Test functions located in the hexdump module at runtime"
+
 config TEST_STRING_HELPERS
 	tristate "Test functions located in the string_helpers module at runtime"
 
diff --git a/lib/Makefile b/lib/Makefile
index f42838a..3dca86f 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -23,12 +23,14 @@ lib-y	+= kobject.o klist.o
 obj-y	+= lockref.o
 
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
-	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
+	 bust_spinlocks.o kasprintf.o bitmap.o scatterlist.o \
 	 gcd.o lcm.o list_sort.o uuid.o flex_array.o iovec.o clz_ctz.o \
 	 bsearch.o find_last_bit.o find_next_bit.o llist.o memweight.o kfifo.o \
 	 percpu-refcount.o percpu_ida.o rhashtable.o reciprocal_div.o
 obj-y += string_helpers.o
 obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
+obj-y += hexdump.o
+obj-$(CONFIG_TEST_HEXDUMP) += test-hexdump.o
 obj-y += kstrtox.o
 obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
 obj-$(CONFIG_TEST_LKM) += test_module.o
diff --git a/lib/test-hexdump.c b/lib/test-hexdump.c
new file mode 100644
index 0000000..9d3bd1e
--- /dev/null
+++ b/lib/test-hexdump.c
@@ -0,0 +1,135 @@
+/*
+ * Test cases for lib/hexdump.c module.
+ */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/random.h>
+#include <linux/string.h>
+
+static const unsigned char data_b[] = {
+	'\xbe', '\x32', '\xdb', '\x7b', '\x0a', '\x18', '\x93', '\xb2',	/* 00 - 07 */
+	'\x70', '\xba', '\xc4', '\x24', '\x7d', '\x83', '\x34', '\x9b',	/* 08 - 0f */
+	'\xa6', '\x9c', '\x31', '\xad', '\x9c', '\x0f', '\xac', '\xe9',	/* 10 - 17 */
+	'\x4c', '\xd1', '\x19', '\x99', '\x43', '\xb1', '\xaf', '\x0c',	/* 18 - 1f */
+};
+
+static const unsigned char data_a[] = ".2.{....p..$}.4...1.....L...C...";
+
+static const char *test_data_1_le[] __initconst = {
+	"be", "32", "db", "7b", "0a", "18", "93", "b2",
+	"70", "ba", "c4", "24", "7d", "83", "34", "9b",
+	"a6", "9c", "31", "ad", "9c", "0f", "ac", "e9",
+	"4c", "d1", "19", "99", "43", "b1", "af", "0c",
+};
+
+static const char *test_data_2_le[] __initconst = {
+	"32be", "7bdb", "180a", "b293",
+	"ba70", "24c4", "837d", "9b34",
+	"9ca6", "ad31", "0f9c", "e9ac",
+	"d14c", "9919", "b143", "0caf",
+};
+
+static const char *test_data_4_le[] __initconst = {
+	"7bdb32be", "b293180a", "24c4ba70", "9b34837d",
+	"ad319ca6", "e9ac0f9c", "9919d14c", "0cafb143",
+};
+
+static const char *test_data_8_le[] __initconst = {
+	"b293180a7bdb32be", "9b34837d24c4ba70",
+	"e9ac0f9cad319ca6", "0cafb1439919d14c",
+};
+
+static void __init test_hexdump(size_t len, int rowsize, int groupsize,
+				bool ascii)
+{
+	char test[32 * 3 + 2 + 32 + 1];
+	char real[32 * 3 + 2 + 32 + 1];
+	char *p;
+	const char **result;
+	size_t l = len;
+	int gs = groupsize, rs = rowsize;
+	unsigned int i;
+
+	hex_dump_to_buffer(data_b, l, rs, gs, real, sizeof(real), ascii);
+
+	if (rs != 16 && rs != 32)
+		rs = 16;
+
+	if (l > rs)
+		l = rs;
+
+	if (!is_power_of_2(gs) || gs > 8 || (len % gs != 0))
+		gs = 1;
+
+	if (gs == 8)
+		result = test_data_8_le;
+	else if (gs == 4)
+		result = test_data_4_le;
+	else if (gs == 2)
+		result = test_data_2_le;
+	else
+		result = test_data_1_le;
+
+	memset(test, ' ', sizeof(test));
+
+	/* hex dump */
+	p = test;
+	for (i = 0; i < l / gs; i++) {
+		const char *q = *result++;
+		size_t amount = strlen(q);
+
+		strncpy(p, q, amount);
+		p += amount + 1;
+	}
+	if (i)
+		p--;
+
+	/* ASCII part */
+	if (ascii) {
+		p = test + rs * 2 + rs / gs + 1;
+		strncpy(p, data_a, l);
+		p += l;
+	}
+
+	*p = '\0';
+
+	if (strcmp(test, real)) {
+		pr_err("Len: %zu row: %d group: %d\n", len, rowsize, groupsize);
+		pr_err("Result: '%s'\n", real);
+		pr_err("Expect: '%s'\n", test);
+	}
+}
+
+static void __init test_hexdump_set(int rowsize, bool ascii)
+{
+	size_t d = min_t(size_t, sizeof(data_b), rowsize);
+	size_t len = get_random_int() % d + 1;
+
+	test_hexdump(len, rowsize, 4, ascii);
+	test_hexdump(len, rowsize, 2, ascii);
+	test_hexdump(len, rowsize, 8, ascii);
+	test_hexdump(len, rowsize, 1, ascii);
+}
+
+static int __init test_hexdump_init(void)
+{
+	unsigned int i;
+	int rowsize;
+
+	pr_info("Running tests...\n");
+
+	rowsize = (get_random_int() % 2 + 1) * 16;
+	for (i = 0; i < 16; i++)
+		test_hexdump_set(rowsize, false);
+
+	rowsize = (get_random_int() % 2 + 1) * 16;
+	for (i = 0; i < 16; i++)
+		test_hexdump_set(rowsize, true);
+
+	return -EINVAL;
+}
+module_init(test_hexdump_init);
+MODULE_LICENSE("Dual BSD/GPL");
-- 
2.1.3

