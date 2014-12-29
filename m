Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaL2LvG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 06:51:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:33729 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067AbaL2LvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 06:51:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,659,1413270000"; 
   d="scan'208";a="644054834"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 4/4] hexdump: makes it return amount of bytes placed in buffer
Date: Mon, 29 Dec 2014 13:50:54 +0200
Message-Id: <1419853854-5602-5-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419853854-5602-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1419853854-5602-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes hexdump to return amount of bytes placed in the buffer
excluding trailing NUL. In case of overflow it returns desired amount of bytes
to place entire dump. Thus, it mimics snprintf().

This will be useful for users that would like to repeat with bigger buffer.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 include/linux/printk.h |  6 ++---
 lib/hexdump.c          | 73 +++++++++++++++++++++++++++++++++++++-------------
 lib/test-hexdump.c     | 45 +++++++++++++++++++++++++++++++
 3 files changed, 103 insertions(+), 21 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index c8f1703..aeb9d7f 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -408,9 +408,9 @@ enum {
 	DUMP_PREFIX_ADDRESS,
 	DUMP_PREFIX_OFFSET
 };
-extern void hex_dump_to_buffer(const void *buf, size_t len,
-			       int rowsize, int groupsize,
-			       char *linebuf, size_t linebuflen, bool ascii);
+extern int hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
+			      int groupsize, char *linebuf, size_t linebuflen,
+			      bool ascii);
 #ifdef CONFIG_PRINTK
 extern void print_hex_dump(const char *level, const char *prefix_str,
 			   int prefix_type, int rowsize, int groupsize,
diff --git a/lib/hexdump.c b/lib/hexdump.c
index 4af53f7..7ea0969 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -97,22 +97,26 @@ EXPORT_SYMBOL(bin2hex);
  *
  * example output buffer:
  * 40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f  @ABCDEFGHIJKLMNO
+ *
+ * Return:
+ * The amount of bytes placed in the buffer without terminating NUL. If the
+ * output was truncated, then the return value is the number of bytes
+ * (excluding the terminating NUL) which would have been written to the final
+ * string if enough space had been available.
  */
-void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
-			int groupsize, char *linebuf, size_t linebuflen,
-			bool ascii)
+int hex_dump_to_buffer(const void *buf, size_t len, int rowsize, int groupsize,
+		       char *linebuf, size_t linebuflen, bool ascii)
 {
 	const u8 *ptr = buf;
 	int ngroups;
 	u8 ch;
 	int j, lx = 0;
 	int ascii_column;
+	int ret;
 
 	if (rowsize != 16 && rowsize != 32)
 		rowsize = 16;
 
-	if (!len)
-		goto nil;
 	if (len > rowsize)		/* limit to one line at a time */
 		len = rowsize;
 	if (!is_power_of_2(groupsize) || groupsize > 8)
@@ -122,27 +126,50 @@ void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
 
 	ngroups = len / groupsize;
 	ascii_column = rowsize * 2 + rowsize / groupsize + 1;
+
+	if (!linebuflen)
+		goto overflow1;
+
+	if (!len)
+		goto nil;
+
 	if (groupsize == 8) {
 		const u64 *ptr8 = buf;
 
-		for (j = 0; j < ngroups; j++)
-			lx += scnprintf(linebuf + lx, linebuflen - lx,
-					"%s%16.16llx", j ? " " : "",
-					(unsigned long long)*(ptr8 + j));
+		for (j = 0; j < ngroups; j++) {
+			ret = snprintf(linebuf + lx, linebuflen - lx,
+				       "%s%16.16llx", j ? " " : "",
+				       (unsigned long long)*(ptr8 + j));
+			if (ret >= linebuflen - lx)
+				goto overflow1;
+			lx += ret;
+		}
 	} else if (groupsize == 4) {
 		const u32 *ptr4 = buf;
 
-		for (j = 0; j < ngroups; j++)
-			lx += scnprintf(linebuf + lx, linebuflen - lx,
-					"%s%8.8x", j ? " " : "", *(ptr4 + j));
+		for (j = 0; j < ngroups; j++) {
+			ret = snprintf(linebuf + lx, linebuflen - lx,
+				       "%s%8.8x", j ? " " : "",
+				       *(ptr4 + j));
+			if (ret >= linebuflen - lx)
+				goto overflow1;
+			lx += ret;
+		}
 	} else if (groupsize == 2) {
 		const u16 *ptr2 = buf;
 
-		for (j = 0; j < ngroups; j++)
-			lx += scnprintf(linebuf + lx, linebuflen - lx,
-					"%s%4.4x", j ? " " : "", *(ptr2 + j));
+		for (j = 0; j < ngroups; j++) {
+			ret = snprintf(linebuf + lx, linebuflen - lx,
+				       "%s%4.4x", j ? " " : "",
+				       *(ptr2 + j));
+			if (ret >= linebuflen - lx)
+				goto overflow1;
+			lx += ret;
+		}
 	} else {
-		for (j = 0; (j < len) && (lx + 3) <= linebuflen; j++) {
+		for (j = 0; j < len; j++) {
+			if (linebuflen < lx + 3)
+				goto overflow2;
 			ch = ptr[j];
 			linebuf[lx++] = hex_asc_hi(ch);
 			linebuf[lx++] = hex_asc_lo(ch);
@@ -154,14 +181,24 @@ void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
 	if (!ascii)
 		goto nil;
 
-	while (lx < (linebuflen - 1) && lx < ascii_column)
+	while (lx < ascii_column) {
+		if (linebuflen < lx + 2)
+			goto overflow2;
 		linebuf[lx++] = ' ';
-	for (j = 0; (j < len) && (lx + 2) < linebuflen; j++) {
+	}
+	for (j = 0; j < len; j++) {
+		if (linebuflen < lx + 2)
+			goto overflow2;
 		ch = ptr[j];
 		linebuf[lx++] = (isascii(ch) && isprint(ch)) ? ch : '.';
 	}
 nil:
+	linebuf[lx] = '\0';
+	return lx;
+overflow2:
 	linebuf[lx++] = '\0';
+overflow1:
+	return ascii ? ascii_column + len : (groupsize * 2 + 1) * ngroups - 1;
 }
 EXPORT_SYMBOL(hex_dump_to_buffer);
 
diff --git a/lib/test-hexdump.c b/lib/test-hexdump.c
index 9d3bd1e..d10f90b 100644
--- a/lib/test-hexdump.c
+++ b/lib/test-hexdump.c
@@ -114,6 +114,45 @@ static void __init test_hexdump_set(int rowsize, bool ascii)
 	test_hexdump(len, rowsize, 1, ascii);
 }
 
+static void __init test_hexdump_overflow(bool ascii)
+{
+	char buf[56];
+	const char *t = test_data_1_le[0];
+	size_t l = get_random_int() % sizeof(buf);
+	bool a;
+	int e, r;
+
+	memset(buf, ' ', sizeof(buf));
+
+	r = hex_dump_to_buffer(data_b, 1, 16, 1, buf, l, ascii);
+
+	if (ascii)
+		e = 50;
+	else
+		e = 2;
+	buf[e + 2] = '\0';
+
+	if (!l) {
+		a = r == e && buf[0] == ' ';
+	} else if (l < 3) {
+		a = r == e && buf[0] == '\0';
+	} else if (l < 4) {
+		a = r == e && !strcmp(buf, t);
+	} else if (ascii) {
+		if (l < 51)
+			a = r == e && buf[l - 1] == '\0' && buf[l - 2] == ' ';
+		else
+			a = r == e && buf[50] == '\0' && buf[49] == '.';
+	} else {
+		a = r == e && buf[e] == '\0';
+	}
+
+	if (!a) {
+		pr_err("Len: %zu rc: %zu strlen: %zu\n", l, r, strlen(buf));
+		pr_err("Result: '%s'\n", buf);
+	}
+}
+
 static int __init test_hexdump_init(void)
 {
 	unsigned int i;
@@ -129,6 +168,12 @@ static int __init test_hexdump_init(void)
 	for (i = 0; i < 16; i++)
 		test_hexdump_set(rowsize, true);
 
+	for (i = 0; i < 16; i++)
+		test_hexdump_overflow(false);
+
+	for (i = 0; i < 16; i++)
+		test_hexdump_overflow(true);
+
 	return -EINVAL;
 }
 module_init(test_hexdump_init);
-- 
2.1.3

