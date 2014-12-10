Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451AbaLJPxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:53:20 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:58351 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370AbaLJPxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:53:09 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/12] bitmap: restructure bitmap_sn[list]printf()
Date: Wed, 10 Dec 2014 10:52:43 -0500
Message-Id: <1418226774-30215-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1418226774-30215-1-git-send-email-tj@kernel.org>
References: <1418226774-30215-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bitmap_sn[list]printf() implement formatting a bitmap into the
specified string buffer.  We want to add functions which target a
different output (printk).  To enable that, this patch restructures
bitmap_sn[list]printf() so that the formatting and outputting are
separate.

Formatting is now handled by bitmap_print[_list]() and
bitmap_sn[list]printf() wrap the formatting functions with the output
callback bitmap_scnprintf_fn() which fills the string buffer.  A later
patch will implement bitmap_pr_cont[_list]() by adding a different
outputting callback.

This patch doesn't change the behaviors of bitmap_sn[list]printf().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 lib/bitmap.c | 113 ++++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 73 insertions(+), 40 deletions(-)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index 324ea9e..f1d6351 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -372,25 +372,33 @@ EXPORT_SYMBOL(bitmap_find_next_zero_area_off);
  * second version by Paul Jackson, third by Joe Korty.
  */
 
+struct bitmap_scnprintf_data {
+	char		*buf;
+	unsigned int	buflen;
+	unsigned int	len;
+};
+
+typedef __printf(2, 3) void (*bitmap_printfn_t)(void *data, const char *fmt, ...);
+
+static void bitmap_scnprintf_fn(void *data, const char *fmt, ...)
+{
+	struct bitmap_scnprintf_data *bsd = data;
+	va_list args;
+
+	va_start(args, fmt);
+	bsd->len += vscnprintf(bsd->buf + bsd->len, bsd->buflen - bsd->len,
+			       fmt, args);
+	va_end(args);
+}
+
 #define CHUNKSZ				32
 #define nbits_to_hold_value(val)	fls(val)
 #define BASEDEC 10		/* fancier cpuset lists input in decimal */
 
-/**
- * bitmap_scnprintf - convert bitmap to an ASCII hex string.
- * @buf: byte buffer into which string is placed
- * @buflen: reserved size of @buf, in bytes
- * @maskp: pointer to bitmap to convert
- * @nmaskbits: size of bitmap, in bits
- *
- * Exactly @nmaskbits bits are displayed.  Hex digits are grouped into
- * comma-separated sets of eight digits per set.  Returns the number of
- * characters which were written to *buf, excluding the trailing \0.
- */
-int bitmap_scnprintf(char *buf, unsigned int buflen,
-	const unsigned long *maskp, int nmaskbits)
+static void bitmap_print(const unsigned long *maskp, int nmaskbits,
+			 bitmap_printfn_t printfn, void *printfn_data)
 {
-	int i, word, bit, len = 0;
+	int i, word, bit;
 	unsigned long val;
 	const char *sep = "";
 	int chunksz;
@@ -406,12 +414,30 @@ int bitmap_scnprintf(char *buf, unsigned int buflen,
 		word = i / BITS_PER_LONG;
 		bit = i % BITS_PER_LONG;
 		val = (maskp[word] >> bit) & chunkmask;
-		len += scnprintf(buf+len, buflen-len, "%s%0*lx", sep,
-			(chunksz+3)/4, val);
+		printfn(printfn_data, "%s%0*lx", sep, (chunksz+3)/4, val);
 		chunksz = CHUNKSZ;
 		sep = ",";
 	}
-	return len;
+}
+
+/**
+ * bitmap_scnprintf - convert bitmap to an ASCII hex string.
+ * @buf: byte buffer into which string is placed
+ * @buflen: reserved size of @buf, in bytes
+ * @maskp: pointer to bitmap to convert
+ * @nmaskbits: size of bitmap, in bits
+ *
+ * Exactly @nmaskbits bits are displayed.  Hex digits are grouped into
+ * comma-separated sets of eight digits per set.  Returns the number of
+ * characters which were written to *buf, excluding the trailing \0.
+ */
+int bitmap_scnprintf(char *buf, unsigned int buflen,
+		     const unsigned long *maskp, int nmaskbits)
+{
+	struct bitmap_scnprintf_data bsd = { .buf = buf, .buflen = buflen };
+
+	bitmap_print(maskp, nmaskbits, bitmap_scnprintf_fn, &bsd);
+	return bsd.len;
 }
 EXPORT_SYMBOL(bitmap_scnprintf);
 
@@ -531,20 +557,37 @@ EXPORT_SYMBOL(bitmap_parse_user);
 /*
  * bscnl_emit(buf, buflen, rbot, rtop, bp)
  *
- * Helper routine for bitmap_scnlistprintf().  Write decimal number
- * or range to buf, suppressing output past buf+buflen, with optional
- * comma-prefix.  Return len of what was written to *buf, excluding the
- * trailing \0.
+ * Helper routine for bitmap_scnlistprintf().  Write decimal number or
+ * range to buf, with optional comma-prefix.
  */
-static inline int bscnl_emit(char *buf, int buflen, int rbot, int rtop, int len)
+static inline void bscnl_emit(int rbot, int rtop, bool first,
+			      bitmap_printfn_t printfn, void *printfn_data)
 {
-	if (len > 0)
-		len += scnprintf(buf + len, buflen - len, ",");
+	if (!first)
+		printfn(printfn_data, ",");
 	if (rbot == rtop)
-		len += scnprintf(buf + len, buflen - len, "%d", rbot);
+		printfn(printfn_data, "%d", rbot);
 	else
-		len += scnprintf(buf + len, buflen - len, "%d-%d", rbot, rtop);
-	return len;
+		printfn(printfn_data, "%d-%d", rbot, rtop);
+}
+
+static void bitmap_print_list(const unsigned long *maskp, int nmaskbits,
+			      bitmap_printfn_t printfn, void *printfn_data)
+{
+	bool first = true;
+	/* current bit is 'cur', most recently seen range is [rbot, rtop] */
+	int cur, rbot, rtop;
+
+	rbot = cur = find_first_bit(maskp, nmaskbits);
+	while (cur < nmaskbits) {
+		rtop = cur;
+		cur = find_next_bit(maskp, nmaskbits, cur+1);
+		if (cur >= nmaskbits || cur > rtop + 1) {
+			bscnl_emit(rbot, rtop, first, printfn, printfn_data);
+			rbot = cur;
+			first = false;
+		}
+	}
 }
 
 /**
@@ -566,24 +609,14 @@ static inline int bscnl_emit(char *buf, int buflen, int rbot, int rtop, int len)
 int bitmap_scnlistprintf(char *buf, unsigned int buflen,
 	const unsigned long *maskp, int nmaskbits)
 {
-	int len = 0;
-	/* current bit is 'cur', most recently seen range is [rbot, rtop] */
-	int cur, rbot, rtop;
+	struct bitmap_scnprintf_data bsd = { .buf = buf, .buflen = buflen };
 
 	if (buflen == 0)
 		return 0;
 	buf[0] = 0;
 
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
+	bitmap_print_list(maskp, nmaskbits, bitmap_scnprintf_fn, &bsd);
+	return bsd.len;
 }
 EXPORT_SYMBOL(bitmap_scnlistprintf);
 
-- 
2.1.0

