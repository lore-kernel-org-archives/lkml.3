Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbbAXOF1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:05:27 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:57923 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbbAXOEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:04:36 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 32/32] bitmap, cpumask, nodemask: remove dedicated formatting functions
Date: Sat, 24 Jan 2015 09:03:38 -0500
Message-Id: <1422108218-25398-33-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422108218-25398-1-git-send-email-tj@kernel.org>
References: <1422108218-25398-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all bitmap formatting usages have been converted to
'%*pb[l]', the separate formatting functions are unnecessary.  The
following functions are removed.

* bitmap_scn[list]printf()
* cpumask_scnprintf(), cpulist_scnprintf()
* [__]nodemask_scnprintf(), [__]nodelist_scnprintf()
* seq_bitmap[_list](), seq_cpumask[_list](), seq_nodemask[_list]()
* seq_buf_bitmask()

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 fs/seq_file.c            | 32 --------------------------------
 include/linux/bitmap.h   |  7 -------
 include/linux/cpumask.h  | 31 -------------------------------
 include/linux/nodemask.h | 33 +++++++--------------------------
 include/linux/seq_buf.h  |  3 ---
 include/linux/seq_file.h | 25 -------------------------
 lib/bitmap.c             | 41 -----------------------------------------
 lib/seq_buf.c            | 36 ------------------------------------
 8 files changed, 7 insertions(+), 201 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index dbf3a59..555f821 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -539,38 +539,6 @@ int seq_dentry(struct seq_file *m, struct dentry *dentry, const char *esc)
 	return res;
 }
 
-int seq_bitmap(struct seq_file *m, const unsigned long *bits,
-				   unsigned int nr_bits)
-{
-	if (m->count < m->size) {
-		int len = bitmap_scnprintf(m->buf + m->count,
-				m->size - m->count, bits, nr_bits);
-		if (m->count + len < m->size) {
-			m->count += len;
-			return 0;
-		}
-	}
-	seq_set_overflow(m);
-	return -1;
-}
-EXPORT_SYMBOL(seq_bitmap);
-
-int seq_bitmap_list(struct seq_file *m, const unsigned long *bits,
-		unsigned int nr_bits)
-{
-	if (m->count < m->size) {
-		int len = bitmap_scnlistprintf(m->buf + m->count,
-				m->size - m->count, bits, nr_bits);
-		if (m->count + len < m->size) {
-			m->count += len;
-			return 0;
-		}
-	}
-	seq_set_overflow(m);
-	return -1;
-}
-EXPORT_SYMBOL(seq_bitmap_list);
-
 static void *single_start(struct seq_file *p, loff_t *pos)
 {
 	return NULL + (*pos == 0);
diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 202e403..dd1d23a 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -52,16 +52,13 @@
  * bitmap_bitremap(oldbit, old, new, nbits)	newbit = map(old, new)(oldbit)
  * bitmap_onto(dst, orig, relmap, nbits)	*dst = orig relative to relmap
  * bitmap_fold(dst, orig, sz, nbits)		dst bits = orig bits mod sz
- * bitmap_scnprintf(buf, len, src, nbits)	Print bitmap src to buf
  * bitmap_parse(buf, buflen, dst, nbits)	Parse bitmap dst from kernel buf
  * bitmap_parse_user(ubuf, ulen, dst, nbits)	Parse bitmap dst from user buf
- * bitmap_scnlistprintf(buf, len, src, nbits)	Print bitmap src as list to buf
  * bitmap_parselist(buf, dst, nbits)		Parse bitmap dst from kernel buf
  * bitmap_parselist_user(buf, dst, nbits)	Parse bitmap dst from user buf
  * bitmap_find_free_region(bitmap, bits, order)	Find and allocate bit region
  * bitmap_release_region(bitmap, pos, order)	Free specified bit region
  * bitmap_allocate_region(bitmap, pos, order)	Allocate specified bit region
- * bitmap_print_to_pagebuf(list, buf, mask, nbits) Print bitmap src as list/hex
  */
 
 /*
@@ -147,14 +144,10 @@ bitmap_find_next_zero_area(unsigned long *map,
 					      align_mask, 0);
 }
 
-extern int bitmap_scnprintf(char *buf, unsigned int len,
-			const unsigned long *src, int nbits);
 extern int __bitmap_parse(const char *buf, unsigned int buflen, int is_user,
 			unsigned long *dst, int nbits);
 extern int bitmap_parse_user(const char __user *ubuf, unsigned int ulen,
 			unsigned long *dst, int nbits);
-extern int bitmap_scnlistprintf(char *buf, unsigned int len,
-			const unsigned long *src, int nbits);
 extern int bitmap_parselist(const char *buf, unsigned long *maskp,
 			int nmaskbits);
 extern int bitmap_parselist_user(const char __user *ubuf, unsigned int ulen,
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 4d8e3b2..299d3eb 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -547,21 +547,6 @@ static inline void cpumask_copy(struct cpumask *dstp,
 #define cpumask_of(cpu) (get_cpu_mask(cpu))
 
 /**
- * cpumask_scnprintf - print a cpumask into a string as comma-separated hex
- * @buf: the buffer to sprintf into
- * @len: the length of the buffer
- * @srcp: the cpumask to print
- *
- * If len is zero, returns zero.  Otherwise returns the length of the
- * (nul-terminated) @buf string.
- */
-static inline int cpumask_scnprintf(char *buf, int len,
-				    const struct cpumask *srcp)
-{
-	return bitmap_scnprintf(buf, len, cpumask_bits(srcp), nr_cpu_ids);
-}
-
-/**
  * cpumask_parse_user - extract a cpumask from a user string
  * @buf: the buffer to extract from
  * @len: the length of the buffer
@@ -591,22 +576,6 @@ static inline int cpumask_parselist_user(const char __user *buf, int len,
 }
 
 /**
- * cpulist_scnprintf - print a cpumask into a string as comma-separated list
- * @buf: the buffer to sprintf into
- * @len: the length of the buffer
- * @srcp: the cpumask to print
- *
- * If len is zero, returns zero.  Otherwise returns the length of the
- * (nul-terminated) @buf string.
- */
-static inline int cpulist_scnprintf(char *buf, int len,
-				    const struct cpumask *srcp)
-{
-	return bitmap_scnlistprintf(buf, len, cpumask_bits(srcp),
-				    nr_cpu_ids);
-}
-
-/**
  * cpumask_parse - extract a cpumask from from a string
  * @buf: the buffer to extract from
  * @dstp: the cpumask to set.
diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index 63295d2..ac86720 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -8,14 +8,13 @@
  * See detailed comments in the file linux/bitmap.h describing the
  * data type on which these nodemasks are based.
  *
- * For details of nodemask_scnprintf() and nodemask_parse_user(),
- * see bitmap_scnprintf() and bitmap_parse_user() in lib/bitmap.c.
- * For details of nodelist_scnprintf() and nodelist_parse(), see
- * bitmap_scnlistprintf() and bitmap_parselist(), also in bitmap.c.
- * For details of node_remap(), see bitmap_bitremap in lib/bitmap.c.
- * For details of nodes_remap(), see bitmap_remap in lib/bitmap.c.
- * For details of nodes_onto(), see bitmap_onto in lib/bitmap.c.
- * For details of nodes_fold(), see bitmap_fold in lib/bitmap.c.
+ * For details of nodemask_parse_user(), see bitmap_parse_user() in
+ * lib/bitmap.c.  For details of nodelist_parse(), see bitmap_parselist(),
+ * also in bitmap.c.  For details of node_remap(), see bitmap_bitremap in
+ * lib/bitmap.c.  For details of nodes_remap(), see bitmap_remap in
+ * lib/bitmap.c.  For details of nodes_onto(), see bitmap_onto in
+ * lib/bitmap.c.  For details of nodes_fold(), see bitmap_fold in
+ * lib/bitmap.c.
  *
  * The available nodemask operations are:
  *
@@ -52,9 +51,7 @@
  * NODE_MASK_NONE			Initializer - no bits set
  * unsigned long *nodes_addr(mask)	Array of unsigned long's in mask
  *
- * int nodemask_scnprintf(buf, len, mask) Format nodemask for printing
  * int nodemask_parse_user(ubuf, ulen, mask)	Parse ascii string as nodemask
- * int nodelist_scnprintf(buf, len, mask) Format nodemask as list for printing
  * int nodelist_parse(buf, map)		Parse ascii string as nodelist
  * int node_remap(oldbit, old, new)	newbit = map(old, new)(oldbit)
  * void nodes_remap(dst, src, old, new)	*dst = map(old, new)(src)
@@ -312,14 +309,6 @@ static inline int __first_unset_node(const nodemask_t *maskp)
 
 #define nodes_addr(src) ((src).bits)
 
-#define nodemask_scnprintf(buf, len, src) \
-			__nodemask_scnprintf((buf), (len), &(src), MAX_NUMNODES)
-static inline int __nodemask_scnprintf(char *buf, int len,
-					const nodemask_t *srcp, int nbits)
-{
-	return bitmap_scnprintf(buf, len, srcp->bits, nbits);
-}
-
 #define nodemask_parse_user(ubuf, ulen, dst) \
 		__nodemask_parse_user((ubuf), (ulen), &(dst), MAX_NUMNODES)
 static inline int __nodemask_parse_user(const char __user *buf, int len,
@@ -328,14 +317,6 @@ static inline int __nodemask_parse_user(const char __user *buf, int len,
 	return bitmap_parse_user(buf, len, dstp->bits, nbits);
 }
 
-#define nodelist_scnprintf(buf, len, src) \
-			__nodelist_scnprintf((buf), (len), &(src), MAX_NUMNODES)
-static inline int __nodelist_scnprintf(char *buf, int len,
-					const nodemask_t *srcp, int nbits)
-{
-	return bitmap_scnlistprintf(buf, len, srcp->bits, nbits);
-}
-
 #define nodelist_parse(buf, dst) __nodelist_parse((buf), &(dst), MAX_NUMNODES)
 static inline int __nodelist_parse(const char *buf, nodemask_t *dstp, int nbits)
 {
diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
index 9aafe0e..fb7eb9c 100644
--- a/include/linux/seq_buf.h
+++ b/include/linux/seq_buf.h
@@ -125,9 +125,6 @@ extern int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
 			      unsigned int len);
 extern int seq_buf_path(struct seq_buf *s, const struct path *path, const char *esc);
 
-extern int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
-			   int nmaskbits);
-
 #ifdef CONFIG_BINARY_PRINTF
 extern int
 seq_buf_bprintf(struct seq_buf *s, const char *fmt, const u32 *binary);
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index cf6a9da..afbb1fd 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -126,31 +126,6 @@ int seq_path(struct seq_file *, const struct path *, const char *);
 int seq_dentry(struct seq_file *, struct dentry *, const char *);
 int seq_path_root(struct seq_file *m, const struct path *path,
 		  const struct path *root, const char *esc);
-int seq_bitmap(struct seq_file *m, const unsigned long *bits,
-				   unsigned int nr_bits);
-static inline int seq_cpumask(struct seq_file *m, const struct cpumask *mask)
-{
-	return seq_bitmap(m, cpumask_bits(mask), nr_cpu_ids);
-}
-
-static inline int seq_nodemask(struct seq_file *m, nodemask_t *mask)
-{
-	return seq_bitmap(m, mask->bits, MAX_NUMNODES);
-}
-
-int seq_bitmap_list(struct seq_file *m, const unsigned long *bits,
-		unsigned int nr_bits);
-
-static inline int seq_cpumask_list(struct seq_file *m,
-				   const struct cpumask *mask)
-{
-	return seq_bitmap_list(m, cpumask_bits(mask), nr_cpu_ids);
-}
-
-static inline int seq_nodemask_list(struct seq_file *m, nodemask_t *mask)
-{
-	return seq_bitmap_list(m, mask->bits, MAX_NUMNODES);
-}
 
 int single_open(struct file *, int (*)(struct seq_file *, void *), void *);
 int single_open_size(struct file *, int (*)(struct seq_file *, void *), void *, size_t);
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 1c8607d0..6d83d17 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -377,24 +377,6 @@ EXPORT_SYMBOL(bitmap_find_next_zero_area_off);
 #define BASEDEC 10		/* fancier cpuset lists input in decimal */
 
 /**
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
-{
-	return scnprintf(buf, buflen, "%*pb", nmaskbits, maskp);
-}
-EXPORT_SYMBOL(bitmap_scnprintf);
-
-/**
  * __bitmap_parse - convert an ASCII hex string into a bitmap.
  * @buf: pointer to buffer containing string.
  * @buflen: buffer size in bytes.  If string is smaller than this
@@ -508,29 +490,6 @@ int bitmap_parse_user(const char __user *ubuf,
 EXPORT_SYMBOL(bitmap_parse_user);
 
 /**
- * bitmap_scnlistprintf - convert bitmap to list format ASCII string
- * @buf: byte buffer into which string is placed
- * @buflen: reserved size of @buf, in bytes
- * @maskp: pointer to bitmap to convert
- * @nmaskbits: size of bitmap, in bits
- *
- * Output format is a comma-separated list of decimal numbers and
- * ranges.  Consecutively set bits are shown as two hyphen-separated
- * decimal numbers, the smallest and largest bit numbers set in
- * the range.  Output format is compatible with the format
- * accepted as input by bitmap_parselist().
- *
- * The return value is the number of characters which were written to *buf
- * excluding the trailing '\0', as per ISO C99's scnprintf.
- */
-int bitmap_scnlistprintf(char *buf, unsigned int buflen,
-	const unsigned long *maskp, int nmaskbits)
-{
-	return scnprintf(buf, buflen, "%*pbl", nmaskbits, maskp);
-}
-EXPORT_SYMBOL(bitmap_scnlistprintf);
-
-/**
  * bitmap_print_to_pagebuf - convert bitmap to list or hex format ASCII string
  * @list: indicates whether the bitmap must be list
  * @buf: page aligned buffer into which string is placed
diff --git a/lib/seq_buf.c b/lib/seq_buf.c
index 4eedfed..88c0854 100644
--- a/lib/seq_buf.c
+++ b/lib/seq_buf.c
@@ -91,42 +91,6 @@ int seq_buf_printf(struct seq_buf *s, const char *fmt, ...)
 	return ret;
 }
 
-/**
- * seq_buf_bitmask - write a bitmask array in its ASCII representation
- * @s:		seq_buf descriptor
- * @maskp:	points to an array of unsigned longs that represent a bitmask
- * @nmaskbits:	The number of bits that are valid in @maskp
- *
- * Writes a ASCII representation of a bitmask string into @s.
- *
- * Returns zero on success, -1 on overflow.
- */
-int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
-		    int nmaskbits)
-{
-	unsigned int len = seq_buf_buffer_left(s);
-	int ret;
-
-	WARN_ON(s->size == 0);
-
-	/*
-	 * Note, because bitmap_scnprintf() only returns the number of bytes
-	 * written and not the number that would be written, we use the last
-	 * byte of the buffer to let us know if we overflowed. There's a small
-	 * chance that the bitmap could have fit exactly inside the buffer, but
-	 * it's not that critical if that does happen.
-	 */
-	if (len > 1) {
-		ret = bitmap_scnprintf(s->buffer + s->len, len, maskp, nmaskbits);
-		if (ret < len) {
-			s->len += ret;
-			return 0;
-		}
-	}
-	seq_buf_set_overflow(s);
-	return -1;
-}
-
 #ifdef CONFIG_BINARY_PRINTF
 /**
  * seq_buf_bprintf - Write the printf string from binary arguments
-- 
2.1.0

