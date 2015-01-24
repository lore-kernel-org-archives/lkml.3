Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbbAXOEB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:04:01 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:59294 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbbAXODw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:03:52 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 02/32] lib/vsprintf: implement bitmap printing through '%*pb[l]'
Date: Sat, 24 Jan 2015 09:03:08 -0500
Message-Id: <1422108218-25398-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422108218-25398-1-git-send-email-tj@kernel.org>
References: <1422108218-25398-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bitmap and its derivatives such as cpumask and nodemask currently only
provide formatting functions which put the output string into the
provided buffer; however, how long this buffer should be isn't defined
anywhere and given that some of these bitmaps can be too large to be
formatted into an on-stack buffer it users sometimes are unnecessarily
forced to come up with creative solutions and compromises for the
buffer just to printk these bitmaps.

There have been a couple different attempts at making this easier.

1. Way back, PeterZ tried printk '%pb' extension with the precision
   for bit width - '%.*pb'.  This was intuitive and made sense but
   unfortunately triggered a compile warning about using precision
   for a pointer.

   http://lkml.kernel.org/g/1336577562.2527.58.camel@twins

2. I implemented bitmap_pr_cont[_list]() and its wrappers for cpumask
   and nodemask.  This works but PeterZ pointed out that pr_cont's
   tendency to produce broken lines when multiple CPUs are printing is
   bothering considering the usages.

   http://lkml.kernel.org/g/1418226774-30215-3-git-send-email-tj@kernel.org

So, this patch is another attempt at teaching printk and friends how
to print bitmaps.  It's almost identical to what PeterZ tried with
precision but it uses the field width for the number of bits instead
of precision.  The format used is '%*pb[l]', with the optional
trailing 'l' specifying list format instead of hex masks.

This is a valid format string and doesn't trigger compiler warnings;
however, it does make it impossible to specify output field width when
printing bitmaps.  I think this is an acceptable trade-off given how
much easier it makes printing bitmaps and that we don't have any
in-kernel user which is using the field width specification.  If any
future user wants to use field width with a bitmap, it'd have to
format the bitmap into a string buffer and then print that buffer with
width spec, which isn't different from how it should be done now.

This patch implements bitmap[_list]_string() which are called from the
vsprintf pointer() formatting function.  The implementation is mostly
identical to bitmap_scn[list]printf() except that the output is
performed in the vsprintf way.  These functions handle formatting into
too small buffers and sprintf() family of functions report the correct
overrun output length.

bitmap_scn[list]printf() are now thin wrappers around scnprintf().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
Hello,

Linus, this is the second of the three pre-requisite patches to
convert the users of the dedicated bitmap formatting functions over to
'%*pb[l]' formatting and actually implements the formatting.

If this approach is agreed upon, I think it'd be best to route these
three patches through mainline soon so that subsystem conversion
patches can pull these in and apply per-subsystem conversion patches.

Thanks.

 lib/bitmap.c   | 61 ++-----------------------------------
 lib/vsprintf.c | 94 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 96 insertions(+), 59 deletions(-)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index 324ea9e..1e482a6 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -390,28 +390,7 @@ EXPORT_SYMBOL(bitmap_find_next_zero_area_off);
 int bitmap_scnprintf(char *buf, unsigned int buflen,
 	const unsigned long *maskp, int nmaskbits)
 {
-	int i, word, bit, len = 0;
-	unsigned long val;
-	const char *sep = "";
-	int chunksz;
-	u32 chunkmask;
-
-	chunksz = nmaskbits & (CHUNKSZ - 1);
-	if (chunksz == 0)
-		chunksz = CHUNKSZ;
-
-	i = ALIGN(nmaskbits, CHUNKSZ) - CHUNKSZ;
-	for (; i >= 0; i -= CHUNKSZ) {
-		chunkmask = ((1ULL << chunksz) - 1);
-		word = i / BITS_PER_LONG;
-		bit = i % BITS_PER_LONG;
-		val = (maskp[word] >> bit) & chunkmask;
-		len += scnprintf(buf+len, buflen-len, "%s%0*lx", sep,
-			(chunksz+3)/4, val);
-		chunksz = CHUNKSZ;
-		sep = ",";
-	}
-	return len;
+	return scnprintf(buf, buflen, "%*pb", nmaskbits, maskp);
 }
 EXPORT_SYMBOL(bitmap_scnprintf);
 
@@ -528,25 +507,6 @@ int bitmap_parse_user(const char __user *ubuf,
 }
 EXPORT_SYMBOL(bitmap_parse_user);
 
-/*
- * bscnl_emit(buf, buflen, rbot, rtop, bp)
- *
- * Helper routine for bitmap_scnlistprintf().  Write decimal number
- * or range to buf, suppressing output past buf+buflen, with optional
- * comma-prefix.  Return len of what was written to *buf, excluding the
- * trailing \0.
- */
-static inline int bscnl_emit(char *buf, int buflen, int rbot, int rtop, int len)
-{
-	if (len > 0)
-		len += scnprintf(buf + len, buflen - len, ",");
-	if (rbot == rtop)
-		len += scnprintf(buf + len, buflen - len, "%d", rbot);
-	else
-		len += scnprintf(buf + len, buflen - len, "%d-%d", rbot, rtop);
-	return len;
-}
-
 /**
  * bitmap_scnlistprintf - convert bitmap to list format ASCII string
  * @buf: byte buffer into which string is placed
@@ -566,24 +526,7 @@ static inline int bscnl_emit(char *buf, int buflen, int rbot, int rtop, int len)
 int bitmap_scnlistprintf(char *buf, unsigned int buflen,
 	const unsigned long *maskp, int nmaskbits)
 {
-	int len = 0;
-	/* current bit is 'cur', most recently seen range is [rbot, rtop] */
-	int cur, rbot, rtop;
-
-	if (buflen == 0)
-		return 0;
-	buf[0] = 0;
-
-	rbot = cur = find_first_bit(maskp, nmaskbits);
-	while (cur < nmaskbits) {
-		rtop = cur;
-		cur = find_next_bit(maskp, nmaskbits, cur+1);
-		if (cur >= nmaskbits || cur > rtop + 1) {
-			len = bscnl_emit(buf, buflen, rbot, rtop, len);
-			rbot = cur;
-		}
-	}
-	return len;
+	return scnprintf(buf, buflen, "%*pbl", nmaskbits, maskp);
 }
 EXPORT_SYMBOL(bitmap_scnlistprintf);
 
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index ec337f6..8cf7357 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -793,6 +793,87 @@ char *hex_string(char *buf, char *end, u8 *addr, struct printf_spec spec,
 }
 
 static noinline_for_stack
+char *bitmap_string(char *buf, char *end, unsigned long *bitmap,
+		    struct printf_spec spec, const char *fmt)
+{
+	const int CHUNKSZ = 32;
+	int nr_bits = max_t(int, spec.field_width, 0);
+	int i, chunksz;
+	bool first = true;
+
+	/* reused to print numbers */
+	spec = (struct printf_spec){ .flags = SMALL | ZEROPAD, .base = 16 };
+
+	chunksz = nr_bits & (CHUNKSZ - 1);
+	if (chunksz == 0)
+		chunksz = CHUNKSZ;
+
+	i = ALIGN(nr_bits, CHUNKSZ) - CHUNKSZ;
+	for (; i >= 0; i -= CHUNKSZ) {
+		u32 chunkmask, val;
+		int word, bit;
+
+		chunkmask = ((1ULL << chunksz) - 1);
+		word = i / BITS_PER_LONG;
+		bit = i % BITS_PER_LONG;
+		val = (bitmap[word] >> bit) & chunkmask;
+
+		if (!first) {
+			if (buf < end)
+				*buf = ',';
+			buf++;
+		}
+		first = false;
+
+		spec.field_width = DIV_ROUND_UP(chunksz, 4);
+		buf = number(buf, end, val, spec);
+
+		chunksz = CHUNKSZ;
+	}
+	return buf;
+}
+
+static noinline_for_stack
+char *bitmap_list_string(char *buf, char *end, unsigned long *bitmap,
+			 struct printf_spec spec, const char *fmt)
+{
+	int nr_bits = max_t(int, spec.field_width, 0);
+	/* current bit is 'cur', most recently seen range is [rbot, rtop] */
+	int cur, rbot, rtop;
+	bool first = true;
+
+	/* reused to print numbers */
+	spec = (struct printf_spec){ .base = 10 };
+
+	rbot = cur = find_first_bit(bitmap, nr_bits);
+	while (cur < nr_bits) {
+		rtop = cur;
+		cur = find_next_bit(bitmap, nr_bits, cur + 1);
+		if (cur < nr_bits && cur <= rtop + 1)
+			continue;
+
+		if (!first) {
+			if (buf < end)
+				*buf = ',';
+			buf++;
+		}
+		first = false;
+
+		buf = number(buf, end, rbot, spec);
+		if (rbot < rtop) {
+			if (buf < end)
+				*buf = '-';
+			buf++;
+
+			buf = number(buf, end, rtop, spec);
+		}
+
+		rbot = cur;
+	}
+	return buf;
+}
+
+static noinline_for_stack
 char *mac_address_string(char *buf, char *end, u8 *addr,
 			 struct printf_spec spec, const char *fmt)
 {
@@ -1257,6 +1338,10 @@ int kptr_restrict __read_mostly;
  * - 'B' For backtraced symbolic direct pointers with offset
  * - 'R' For decoded struct resource, e.g., [mem 0x0-0x1f 64bit pref]
  * - 'r' For raw struct resource, e.g., [mem 0x0-0x1f flags 0x201]
+ * - 'b[l]' For a bitmap, the number of bits is determined by the field
+ *       width which must be explicitly specified either as part of the
+ *       format string '%32b[l]' or through '%*b[l]', [l] selects
+ *       range-list format instead of hex format
  * - 'M' For a 6-byte MAC address, it prints the address in the
  *       usual colon-separated hex notation
  * - 'm' For a 6-byte MAC address, it prints the hex address without colons
@@ -1353,6 +1438,13 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		return resource_string(buf, end, ptr, spec, fmt);
 	case 'h':
 		return hex_string(buf, end, ptr, spec, fmt);
+	case 'b':
+		switch (fmt[1]) {
+		case 'l':
+			return bitmap_list_string(buf, end, ptr, spec, fmt);
+		default:
+			return bitmap_string(buf, end, ptr, spec, fmt);
+		}
 	case 'M':			/* Colon separated: 00:01:02:03:04:05 */
 	case 'm':			/* Contiguous: 000102030405 */
 					/* [mM]F (FDDI) */
@@ -1689,6 +1781,8 @@ qualifier:
  * %pB output the name of a backtrace symbol with its offset
  * %pR output the address range in a struct resource with decoded flags
  * %pr output the address range in a struct resource with raw flags
+ * %pb output the bitmap with field width as the number of bits
+ * %pbl output the bitmap as range list with field width as the number of bits
  * %pM output a 6-byte MAC address with colons
  * %pMR output a 6-byte MAC address with colons in reversed order
  * %pMF output a 6-byte MAC address with dashes
-- 
2.1.0

