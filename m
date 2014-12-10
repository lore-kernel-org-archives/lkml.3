Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431AbaLJPxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:53:18 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:46825 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758120AbaLJPxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:53:11 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/12] bitmap, cpumask, nodemask: implement pr_cont variants of formatting functions
Date: Wed, 10 Dec 2014 10:52:44 -0500
Message-Id: <1418226774-30215-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1418226774-30215-1-git-send-email-tj@kernel.org>
References: <1418226774-30215-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These three bitmap types implement functions which format the bitmap
into a string buffer; however, how long this buffer should be isn't
defined anywhere and given that some of these bitmaps can be too large
to be formatted into an on-stack buffer people sometimes are
unnecessarily forced to come up with creative solutions and
compromises for the buffer just to printk these bitmaps.

The previous patch restructured bitmap_scn[list]printf() so that a
different output target can be easily added.  This patch implements
bitmap_pr_cont[_list]() which format the specified bitmap and output
it directly through printk so that it can be interposed with other
printk calls.

The counterparts in cpumask and nodemask - cpu{mask|list}_pr_cont()
and node{mask|list}_pr_cont() are also added.

This patch doesn't convert the existing users.  The next one will.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/bitmap.h   |  4 ++++
 include/linux/cpumask.h  | 18 ++++++++++++++++++
 include/linux/nodemask.h | 16 ++++++++++++++++
 lib/bitmap.c             | 35 +++++++++++++++++++++++++++++++++++
 4 files changed, 73 insertions(+)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 202e403..271537e 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -53,9 +53,11 @@
  * bitmap_onto(dst, orig, relmap, nbits)	*dst = orig relative to relmap
  * bitmap_fold(dst, orig, sz, nbits)		dst bits = orig bits mod sz
  * bitmap_scnprintf(buf, len, src, nbits)	Print bitmap src to buf
+ * bitmap_pr_cont(src, nbits)			pr_cont bitmap src
  * bitmap_parse(buf, buflen, dst, nbits)	Parse bitmap dst from kernel buf
  * bitmap_parse_user(ubuf, ulen, dst, nbits)	Parse bitmap dst from user buf
  * bitmap_scnlistprintf(buf, len, src, nbits)	Print bitmap src as list to buf
+ * bitmap_pr_cont_list(src, nbits)		pr_cont bitmap src as list
  * bitmap_parselist(buf, dst, nbits)		Parse bitmap dst from kernel buf
  * bitmap_parselist_user(buf, dst, nbits)	Parse bitmap dst from user buf
  * bitmap_find_free_region(bitmap, bits, order)	Find and allocate bit region
@@ -149,12 +151,14 @@ bitmap_find_next_zero_area(unsigned long *map,
 
 extern int bitmap_scnprintf(char *buf, unsigned int len,
 			const unsigned long *src, int nbits);
+extern void bitmap_pr_cont(const unsigned long *src, int nbits);
 extern int __bitmap_parse(const char *buf, unsigned int buflen, int is_user,
 			unsigned long *dst, int nbits);
 extern int bitmap_parse_user(const char __user *ubuf, unsigned int ulen,
 			unsigned long *dst, int nbits);
 extern int bitmap_scnlistprintf(char *buf, unsigned int len,
 			const unsigned long *src, int nbits);
+extern void bitmap_pr_cont_list(const unsigned long *src, int nbits);
 extern int bitmap_parselist(const char *buf, unsigned long *maskp,
 			int nmaskbits);
 extern int bitmap_parselist_user(const char __user *ubuf, unsigned int ulen,
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index b950e9d..743828c 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -554,6 +554,15 @@ static inline int cpumask_scnprintf(char *buf, int len,
 }
 
 /**
+ * cpumask_pr_cont - pr_cont a cpumask as comma-separated hex
+ * @srcp: the cpumask to print
+ */
+static inline void cpumask_pr_cont(const struct cpumask *srcp)
+{
+	bitmap_pr_cont(cpumask_bits(srcp), nr_cpumask_bits);
+}
+
+/**
  * cpumask_parse_user - extract a cpumask from a user string
  * @buf: the buffer to extract from
  * @len: the length of the buffer
@@ -599,6 +608,15 @@ static inline int cpulist_scnprintf(char *buf, int len,
 }
 
 /**
+ * cpulist_pr_cont - pr_cont a cpumask as comma-separated list
+ * @srcp: the cpumask to print
+ */
+static inline void cpulist_pr_cont(const struct cpumask *srcp)
+{
+	bitmap_pr_cont_list(cpumask_bits(srcp), nr_cpumask_bits);
+}
+
+/**
  * cpumask_parse - extract a cpumask from from a string
  * @buf: the buffer to extract from
  * @dstp: the cpumask to set.
diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index 83a6aed..e8c3bdc 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -53,8 +53,10 @@
  * unsigned long *nodes_addr(mask)	Array of unsigned long's in mask
  *
  * int nodemask_scnprintf(buf, len, mask) Format nodemask for printing
+ * void nodemask_pr_cont(mask)		pr_cont nodemask
  * int nodemask_parse_user(ubuf, ulen, mask)	Parse ascii string as nodemask
  * int nodelist_scnprintf(buf, len, mask) Format nodemask as list for printing
+ * void nodelist_pr_cont(mask)		pr_cont nodemask as list
  * int nodelist_parse(buf, map)		Parse ascii string as nodelist
  * int node_remap(oldbit, old, new)	newbit = map(old, new)(oldbit)
  * void nodes_remap(dst, src, old, new)	*dst = map(old, new)(src)
@@ -312,6 +314,13 @@ static inline int __nodemask_scnprintf(char *buf, int len,
 	return bitmap_scnprintf(buf, len, srcp->bits, nbits);
 }
 
+#define nodemask_pr_cont(src) \
+			__nodemask_pr_cont(&(src), MAX_NUMNODES)
+static inline void __nodemask_pr_cont(const nodemask_t *srcp, int nbits)
+{
+	bitmap_pr_cont(srcp->bits, nbits);
+}
+
 #define nodemask_parse_user(ubuf, ulen, dst) \
 		__nodemask_parse_user((ubuf), (ulen), &(dst), MAX_NUMNODES)
 static inline int __nodemask_parse_user(const char __user *buf, int len,
@@ -328,6 +337,13 @@ static inline int __nodelist_scnprintf(char *buf, int len,
 	return bitmap_scnlistprintf(buf, len, srcp->bits, nbits);
 }
 
+#define nodelist_pr_cont(src) \
+			__nodelist_pr_cont(&(src), MAX_NUMNODES)
+static inline void __nodelist_pr_cont(const nodemask_t *srcp, int nbits)
+{
+	bitmap_pr_cont_list(srcp->bits, nbits);
+}
+
 #define nodelist_parse(buf, dst) __nodelist_parse((buf), &(dst), MAX_NUMNODES)
 static inline int __nodelist_parse(const char *buf, nodemask_t *dstp, int nbits)
 {
diff --git a/lib/bitmap.c b/lib/bitmap.c
index f1d6351..e4eaf30f 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -391,6 +391,15 @@ static void bitmap_scnprintf_fn(void *data, const char *fmt, ...)
 	va_end(args);
 }
 
+static void bitmap_pr_cont_fn(void *data, const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	vprintk(fmt, args);
+	va_end(args);
+}
+
 #define CHUNKSZ				32
 #define nbits_to_hold_value(val)	fls(val)
 #define BASEDEC 10		/* fancier cpuset lists input in decimal */
@@ -442,6 +451,19 @@ int bitmap_scnprintf(char *buf, unsigned int buflen,
 EXPORT_SYMBOL(bitmap_scnprintf);
 
 /**
+ * bitmap_pr_cont - pr_cont bitmap as an ASCII hex string.
+ * @maskp: pointer to bitmap to convert
+ * @nmaskbits: size of bitmap, in bits
+ *
+ * pr_cont() the same output as bitmap_scnprintf().
+ */
+void bitmap_pr_cont(const unsigned long *maskp, int nmaskbits)
+{
+	bitmap_print(maskp, nmaskbits, bitmap_pr_cont_fn, NULL);
+}
+EXPORT_SYMBOL(bitmap_pr_cont);
+
+/**
  * __bitmap_parse - convert an ASCII hex string into a bitmap.
  * @buf: pointer to buffer containing string.
  * @buflen: buffer size in bytes.  If string is smaller than this
@@ -621,6 +643,19 @@ int bitmap_scnlistprintf(char *buf, unsigned int buflen,
 EXPORT_SYMBOL(bitmap_scnlistprintf);
 
 /**
+ * bitmap_pr_cont_list - pr_cont bitmap as a list format ASCII string
+ * @maskp: pointer to bitmap to convert
+ * @nmaskbits: size of bitmap, in bits
+ *
+ * pr_cont() the same output as bitmap_scnlistprintf().
+ */
+void bitmap_pr_cont_list(const unsigned long *maskp, int nmaskbits)
+{
+	bitmap_print_list(maskp, nmaskbits, bitmap_pr_cont_fn, NULL);
+}
+EXPORT_SYMBOL(bitmap_pr_cont_list);
+
+/**
  * bitmap_print_to_pagebuf - convert bitmap to list or hex format ASCII string
  * @list: indicates whether the bitmap must be list
  * @buf: page aligned buffer into which string is placed
-- 
2.1.0

