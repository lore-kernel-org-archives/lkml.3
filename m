Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbaKXBUF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 20:20:05 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37924 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaKXBUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 20:20:02 -0500
Date: Mon, 24 Nov 2014 01:20:01 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [RFC][PATCH 2/2] handle ITER_KVEC without copy_..._user
Message-ID: <20141124012000.GA27106@ZenIV.linux.org.uk>
References: <20141124010953.GB7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141124010953.GB7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows ITER_KVEC iterators work regardless of set_fs() - they can
use memcpy() instead of uaccess.h stuff.  While we are at it, they don't
need to bother with "it's walked into an unmapped area" logics either and
copying itself is atomic, which simplifies the copy_page_..._iter() for
those guys.

Note that size increase is just 15%, even though we'd just added the third
kind of iterators.  Without the previous patch it would've been much more...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/uio.h |    1 +
 mm/iov_iter.c       |  101 ++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 88 insertions(+), 14 deletions(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 9b15814..6e16945 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -31,6 +31,7 @@ struct iov_iter {
 	size_t count;
 	union {
 		const struct iovec *iov;
+		const struct kvec *kvec;
 		const struct bio_vec *bvec;
 	};
 	unsigned long nr_segs;
diff --git a/mm/iov_iter.c b/mm/iov_iter.c
index 155b554..89ed7cd 100644
--- a/mm/iov_iter.c
+++ b/mm/iov_iter.c
@@ -26,6 +26,25 @@
 	n = wanted - n;					\
 }
 
+#define iterate_kvec(i, n, __v, __p, skip, STEP) {	\
+	size_t wanted = n;				\
+	__p = i->kvec;					\
+	__v.iov_base = __p->iov_base + skip;		\
+	__v.iov_len = min(n, __p->iov_len - skip);	\
+	(void)(STEP);					\
+	skip += __v.iov_len;				\
+	n -= __v.iov_len;				\
+	while (unlikely(n)) {				\
+		__p++;					\
+		__v.iov_base = __p->iov_base;		\
+		__v.iov_len = min(n, __p->iov_len);	\
+		(void)(STEP);				\
+		skip = __v.iov_len;			\
+		n -= __v.iov_len;			\
+	}						\
+	n = wanted;					\
+}
+
 #define iterate_bvec(i, n, __v, __p, skip, STEP) {	\
 	size_t wanted = n;				\
 	__p = i->bvec;					\
@@ -47,12 +66,16 @@
 	n = wanted;					\
 }
 
-#define iterate_all_kinds(i, n, v, I, B) {			\
+#define iterate_all_kinds(i, n, v, I, B, K) {			\
 	size_t skip = i->iov_offset;				\
 	if (unlikely(i->type & ITER_BVEC)) {			\
 		const struct bio_vec *bvec;			\
 		struct bio_vec v;				\
 		iterate_bvec(i, n, v, bvec, skip, (B))		\
+	} else if (unlikely(i->type & ITER_KVEC)) {		\
+		const struct kvec *kvec;			\
+		struct kvec v;					\
+		iterate_kvec(i, n, v, kvec, skip, (K))		\
 	} else {						\
 		const struct iovec *iov;			\
 		struct iovec v;					\
@@ -60,7 +83,7 @@
 	}							\
 }
 
-#define iterate_all_kinds_shift(i, n, v, I, B) {		\
+#define iterate_all_kinds_shift(i, n, v, I, B, K) {		\
 	size_t skip = i->iov_offset;				\
 	if (unlikely(i->type & ITER_BVEC)) {			\
 		const struct bio_vec *bvec;			\
@@ -72,6 +95,16 @@
 		}						\
 		i->nr_segs -= bvec - i->bvec;			\
 		i->bvec = bvec;					\
+	} else if (unlikely(i->type & ITER_KVEC)) {		\
+		const struct kvec *kvec;			\
+		struct kvec v;					\
+		iterate_kvec(i, n, v, kvec, skip, (K))		\
+		if (skip == kvec->iov_len) {			\
+			kvec++;					\
+			skip = 0;				\
+		}						\
+		i->nr_segs -= kvec - i->kvec;			\
+		i->kvec = kvec;					\
 	} else {						\
 		const struct iovec *iov;			\
 		struct iovec v;					\
@@ -121,8 +154,10 @@ size_t copy_to_iter(void *addr, size_t bytes, struct iov_iter *i)
 		__copy_to_user(v.iov_base, (from += v.iov_len) - v.iov_len,
 			       v.iov_len),
 		memcpy_to_page(v.bv_page, v.bv_offset,
-			       (from += v.bv_len) - v.bv_len, v.bv_len)
+			       (from += v.bv_len) - v.bv_len, v.bv_len),
+		memcpy(v.iov_base, (from += v.iov_len) - v.iov_len, v.iov_len)
 	)
+
 	return bytes;
 }
 EXPORT_SYMBOL(copy_to_iter);
@@ -140,7 +175,8 @@ size_t copy_from_iter(void *addr, size_t bytes, struct iov_iter *i)
 		__copy_from_user((to += v.iov_len) - v.iov_len, v.iov_base,
 				 v.iov_len),
 		memcpy_from_page((to += v.bv_len) - v.bv_len, v.bv_page,
-				 v.bv_offset, v.bv_len)
+				 v.bv_offset, v.bv_len),
+		memcpy((to += v.iov_len) - v.iov_len, v.iov_base, v.iov_len)
 	)
 
 	return bytes;
@@ -231,7 +267,7 @@ done:
 size_t copy_page_to_iter(struct page *page, size_t offset, size_t bytes,
 			 struct iov_iter *i)
 {
-	if (i->type & ITER_BVEC) {
+	if (i->type & (ITER_BVEC|ITER_KVEC)) {
 		void *kaddr = kmap_atomic(page);
 		size_t wanted = copy_to_iter(kaddr + offset, bytes, i);
 		kunmap_atomic(kaddr);
@@ -325,7 +361,7 @@ done:
 size_t copy_page_from_iter(struct page *page, size_t offset, size_t bytes,
 			 struct iov_iter *i)
 {
-	if (i->type & ITER_BVEC) {
+	if (i->type & (ITER_BVEC|ITER_KVEC)) {
 		void *kaddr = kmap_atomic(page);
 		size_t wanted = copy_from_iter(kaddr + offset, bytes, i);
 		kunmap_atomic(kaddr);
@@ -346,7 +382,7 @@ EXPORT_SYMBOL(copy_page_from_iter);
  */
 int iov_iter_fault_in_readable(struct iov_iter *i, size_t bytes)
 {
-	if (!(i->type & ITER_BVEC)) {
+	if (!(i->type & (ITER_BVEC|ITER_KVEC))) {
 		char __user *buf = i->iov->iov_base + i->iov_offset;
 		bytes = min(bytes, i->iov->iov_len - i->iov_offset);
 		return fault_in_pages_readable(buf, bytes);
@@ -365,7 +401,8 @@ size_t iov_iter_zero(size_t bytes, struct iov_iter *i)
 
 	iterate_all_kinds_shift(i, bytes, v,
 		__clear_user(v.iov_base, v.iov_len),
-		memzero_page(v.bv_page, v.bv_offset, v.bv_len)
+		memzero_page(v.bv_page, v.bv_offset, v.bv_len),
+		memset(v.iov_base, 0, v.iov_len)
 	)
 
 	return bytes;
@@ -380,7 +417,8 @@ size_t iov_iter_copy_from_user_atomic(struct page *page,
 		__copy_from_user_inatomic((p += v.iov_len) - v.iov_len,
 					  v.iov_base, v.iov_len),
 		memcpy_from_page((p += v.bv_len) - v.bv_len, v.bv_page,
-				 v.bv_offset, v.bv_len)
+				 v.bv_offset, v.bv_len),
+		memcpy((p += v.iov_len) - v.iov_len, v.iov_base, v.iov_len)
 	)
 	kunmap_atomic(kaddr);
 	return bytes;
@@ -389,7 +427,7 @@ EXPORT_SYMBOL(iov_iter_copy_from_user_atomic);
 
 void iov_iter_advance(struct iov_iter *i, size_t size)
 {
-	iterate_all_kinds_shift(i, size, v, 0, 0)
+	iterate_all_kinds_shift(i, size, v, 0, 0, 0)
 }
 EXPORT_SYMBOL(iov_iter_advance);
 
@@ -398,10 +436,14 @@ void iov_iter_init(struct iov_iter *i, int direction,
 			size_t count)
 {
 	/* It will get better.  Eventually... */
-	if (segment_eq(get_fs(), KERNEL_DS))
+	if (segment_eq(get_fs(), KERNEL_DS)) {
 		direction |= ITER_KVEC;
-	i->type = direction;
-	i->iov = iov;
+		i->type = direction;
+		i->kvec = (struct kvec *)iov;
+	} else {
+		i->type = direction;
+		i->iov = iov;
+	}
 	i->nr_segs = nr_segs;
 	i->iov_offset = 0;
 	i->count = count;
@@ -418,7 +460,8 @@ unsigned long iov_iter_alignment(const struct iov_iter *i)
 
 	iterate_all_kinds(i, size, v,
 		(res |= (unsigned long)v.iov_base | v.iov_len, 0),
-		res |= v.bv_offset | v.bv_len
+		res |= v.bv_offset | v.bv_len,
+		res |= (unsigned long)v.iov_base | v.iov_len
 	)
 	return res;
 }
@@ -453,6 +496,16 @@ ssize_t iov_iter_get_pages(struct iov_iter *i,
 		*start = v.bv_offset;
 		get_page(*pages = v.bv_page);
 		return v.bv_len;
+	}}),({ if (likely(v.iov_len)) {
+		unsigned long addr = (unsigned long)v.iov_base, end;
+		size_t len = v.iov_len + (*start = addr & (PAGE_SIZE - 1));
+
+		if (len > maxpages * PAGE_SIZE)
+			len = maxpages * PAGE_SIZE;
+		addr &= ~(PAGE_SIZE - 1);
+		for (end = addr + len; addr < end; addr += PAGE_SIZE)
+			get_page(*pages++ = virt_to_page(addr));
+		return len - *start;
 	}})
 	)
 	return 0;
@@ -505,6 +558,19 @@ ssize_t iov_iter_get_pages_alloc(struct iov_iter *i,
 			return -ENOMEM;
 		get_page(*p = v.bv_page);
 		return v.bv_len;
+	}}),({ if (likely(v.iov_len)) {
+		unsigned long addr = (unsigned long)v.iov_base, end;
+		size_t len = v.iov_len + (*start = addr & (PAGE_SIZE - 1));
+		int n;
+
+		addr &= ~(PAGE_SIZE - 1);
+		n = DIV_ROUND_UP(len, PAGE_SIZE);
+		*pages = p = get_pages_array(n);
+		if (!p)
+			return -ENOMEM;
+		for (end = addr + len; addr < end; addr += PAGE_SIZE)
+			get_page(*p++ = virt_to_page(addr));
+		return len - *start;
 	}})
 	)
 	return 0;
@@ -531,6 +597,13 @@ int iov_iter_npages(const struct iov_iter *i, int maxpages)
 			npages++;
 			if (npages >= maxpages)
 				return maxpages;
+		 }}),
+		({if (v.iov_len) {
+			unsigned long p = (unsigned long)v.iov_base;
+			npages += DIV_ROUND_UP(p + v.iov_len, PAGE_SIZE)
+				- p / PAGE_SIZE;
+			if (npages >= maxpages)
+				return maxpages;
 		 }})
 	)
 	return npages;
