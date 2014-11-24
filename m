Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbaKXBJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 20:09:57 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37903 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaKXBJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 20:09:55 -0500
Date: Mon, 24 Nov 2014 01:09:54 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [RFC][PATCH 1/2] reduce the amount of boilerplate in iov_iter.c
Message-ID: <20141124010953.GB7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iov_iter.c has already grown pretty large, and there is a couple of pending
changes to it that promise to make it even bigger.  On the other hand, there's
a lot of duplicated logics in there.  Generally, we'd want something like
iterate(iter, size, f_iovec, f_bvec, data, move) that would apply the right
callback to all ranges from the current position up to current + size and
possibly move the current position.  However, doing that in a straightforward
way brings too much overhead - these suckers *are* on some fairly hot paths.

A working variant follows; it uses Vile Preprocessor Stuff(tm) to do something
kinda-sorta templates-like.  Any suggestions for doing that in a prettier
way would be very welcome.

As it is, this sucker reduces the size of that thing from 958 lines
to 552, and allows to do further work without blowing the size to hell.
Specifically, it allows to add a new kind of iovecs (ITER_KVEC using
straight memcpy instead of going through copy_..._user) at the cost of
mere 74 extra lines (see the next patch) and allows to add the things
like csum_and_copy_{from,to}_iter() without arseloads of extra code (also
written, but I'd prefer to clean it up a bit more first).

Again, I really hate that kind of preprocessor abuses and I would love to
do it in straight C.  Hell knows, maybe C11 with some gccisms would suffice
(lambdas + careful use of always_inline), but kernel is very far from being
gnu11-clean.  If anybody has some smart trick that would allow to do it,
without code duplication from hell and without buggered code generation,
I would be very glad to use it instead (disclaimer: any suggestions starting
with "use C++" will be passed straight to /dev/null - I'm not looking for
C++ vs C holy war).

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
---
 mm/iov_iter.c |  956 +++++++++++++++++----------------------------------------
 1 file changed, 275 insertions(+), 681 deletions(-)

diff --git a/mm/iov_iter.c b/mm/iov_iter.c
index eafcf60..155b554 100644
--- a/mm/iov_iter.c
+++ b/mm/iov_iter.c
@@ -4,95 +4,148 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 
-static size_t copy_to_iter_iovec(void *from, size_t bytes, struct iov_iter *i)
+#define iterate_iovec(i, n, __v, __p, skip, STEP) {	\
+	size_t left;					\
+	size_t wanted = n;				\
+	__p = i->iov;					\
+	__v.iov_base = __p->iov_base + skip;		\
+	__v.iov_len = min(n, __p->iov_len - skip);	\
+	left = (STEP);					\
+	__v.iov_len -= left;				\
+	skip += __v.iov_len;				\
+	n -= __v.iov_len;				\
+	while (unlikely(!left && n)) {			\
+		__p++;					\
+		__v.iov_base = __p->iov_base;		\
+		__v.iov_len = min(n, __p->iov_len);	\
+		left = (STEP);				\
+		__v.iov_len -= left;			\
+		skip = __v.iov_len;			\
+		n -= __v.iov_len;			\
+	}						\
+	n = wanted - n;					\
+}
+
+#define iterate_bvec(i, n, __v, __p, skip, STEP) {	\
+	size_t wanted = n;				\
+	__p = i->bvec;					\
+	__v.bv_page = __p->bv_page;			\
+	__v.bv_offset = __p->bv_offset + skip;	 	\
+	__v.bv_len = min_t(size_t, n, __p->bv_len - skip);	\
+	(void)(STEP);					\
+	skip += __v.bv_len;				\
+	n -= __v.bv_len;				\
+	while (unlikely(n)) {				\
+		__p++;					\
+		__v.bv_page = __p->bv_page;		\
+		__v.bv_offset = __p->bv_offset;		\
+		__v.bv_len = min_t(size_t, n, __p->bv_len);	\
+		(void)(STEP);				\
+		skip = __v.bv_len;			\
+		n -= __v.bv_len;			\
+	}						\
+	n = wanted;					\
+}
+
+#define iterate_all_kinds(i, n, v, I, B) {			\
+	size_t skip = i->iov_offset;				\
+	if (unlikely(i->type & ITER_BVEC)) {			\
+		const struct bio_vec *bvec;			\
+		struct bio_vec v;				\
+		iterate_bvec(i, n, v, bvec, skip, (B))		\
+	} else {						\
+		const struct iovec *iov;			\
+		struct iovec v;					\
+		iterate_iovec(i, n, v, iov, skip, (I))		\
+	}							\
+}
+
+#define iterate_all_kinds_shift(i, n, v, I, B) {		\
+	size_t skip = i->iov_offset;				\
+	if (unlikely(i->type & ITER_BVEC)) {			\
+		const struct bio_vec *bvec;			\
+		struct bio_vec v;				\
+		iterate_bvec(i, n, v, bvec, skip, (B))		\
+		if (skip == bvec->bv_len) {			\
+			bvec++;					\
+			skip = 0;				\
+		}						\
+		i->nr_segs -= bvec - i->bvec;			\
+		i->bvec = bvec;					\
+	} else {						\
+		const struct iovec *iov;			\
+		struct iovec v;					\
+		iterate_iovec(i, n, v, iov, skip, (I))		\
+		if (skip == iov->iov_len) {			\
+			iov++;					\
+			skip = 0;				\
+		}						\
+		i->nr_segs -= iov - i->iov;			\
+		i->iov = iov;					\
+	}							\
+	i->count -= n;						\
+	i->iov_offset = skip;					\
+}
+
+static void memcpy_from_page(char *to, struct page *page, size_t offset, size_t len)
 {
-	size_t skip, copy, left, wanted;
-	const struct iovec *iov;
-	char __user *buf;
+	char *from = kmap_atomic(page);
+	memcpy(to, from + offset, len);
+	kunmap_atomic(from);
+}
 
+static void memcpy_to_page(struct page *page, size_t offset, char *from, size_t len)
+{
+	char *to = kmap_atomic(page);
+	memcpy(to + offset, from, len);
+	kunmap_atomic(to);
+}
+
+static void memzero_page(struct page *page, size_t offset, size_t len)
+{
+	char *addr = kmap_atomic(page);
+	memset(addr + offset, 0, len);
+	kunmap_atomic(addr);
+}
+
+size_t copy_to_iter(void *addr, size_t bytes, struct iov_iter *i)
+{
+	char *from = addr;
 	if (unlikely(bytes > i->count))
 		bytes = i->count;
 
 	if (unlikely(!bytes))
 		return 0;
 
-	wanted = bytes;
-	iov = i->iov;
-	skip = i->iov_offset;
-	buf = iov->iov_base + skip;
-	copy = min(bytes, iov->iov_len - skip);
-
-	left = __copy_to_user(buf, from, copy);
-	copy -= left;
-	skip += copy;
-	from += copy;
-	bytes -= copy;
-	while (unlikely(!left && bytes)) {
-		iov++;
-		buf = iov->iov_base;
-		copy = min(bytes, iov->iov_len);
-		left = __copy_to_user(buf, from, copy);
-		copy -= left;
-		skip = copy;
-		from += copy;
-		bytes -= copy;
-	}
-
-	if (skip == iov->iov_len) {
-		iov++;
-		skip = 0;
-	}
-	i->count -= wanted - bytes;
-	i->nr_segs -= iov - i->iov;
-	i->iov = iov;
-	i->iov_offset = skip;
-	return wanted - bytes;
+	iterate_all_kinds_shift(i, bytes, v,
+		__copy_to_user(v.iov_base, (from += v.iov_len) - v.iov_len,
+			       v.iov_len),
+		memcpy_to_page(v.bv_page, v.bv_offset,
+			       (from += v.bv_len) - v.bv_len, v.bv_len)
+	)
+	return bytes;
 }
+EXPORT_SYMBOL(copy_to_iter);
 
-static size_t copy_from_iter_iovec(void *to, size_t bytes, struct iov_iter *i)
+size_t copy_from_iter(void *addr, size_t bytes, struct iov_iter *i)
 {
-	size_t skip, copy, left, wanted;
-	const struct iovec *iov;
-	char __user *buf;
-
+	char *to = addr;
 	if (unlikely(bytes > i->count))
 		bytes = i->count;
 
 	if (unlikely(!bytes))
 		return 0;
 
-	wanted = bytes;
-	iov = i->iov;
-	skip = i->iov_offset;
-	buf = iov->iov_base + skip;
-	copy = min(bytes, iov->iov_len - skip);
+	iterate_all_kinds_shift(i, bytes, v,
+		__copy_from_user((to += v.iov_len) - v.iov_len, v.iov_base,
+				 v.iov_len),
+		memcpy_from_page((to += v.bv_len) - v.bv_len, v.bv_page,
+				 v.bv_offset, v.bv_len)
+	)
 
-	left = __copy_from_user(to, buf, copy);
-	copy -= left;
-	skip += copy;
-	to += copy;
-	bytes -= copy;
-	while (unlikely(!left && bytes)) {
-		iov++;
-		buf = iov->iov_base;
-		copy = min(bytes, iov->iov_len);
-		left = __copy_from_user(to, buf, copy);
-		copy -= left;
-		skip = copy;
-		to += copy;
-		bytes -= copy;
-	}
-
-	if (skip == iov->iov_len) {
-		iov++;
-		skip = 0;
-	}
-	i->count -= wanted - bytes;
-	i->nr_segs -= iov - i->iov;
-	i->iov = iov;
-	i->iov_offset = skip;
-	return wanted - bytes;
+	return bytes;
 }
+EXPORT_SYMBOL(copy_from_iter);
 
 static size_t copy_page_to_iter_iovec(struct page *page, size_t offset, size_t bytes,
 			 struct iov_iter *i)
@@ -175,6 +228,19 @@ done:
 	return wanted - bytes;
 }
 
+size_t copy_page_to_iter(struct page *page, size_t offset, size_t bytes,
+			 struct iov_iter *i)
+{
+	if (i->type & ITER_BVEC) {
+		void *kaddr = kmap_atomic(page);
+		size_t wanted = copy_to_iter(kaddr + offset, bytes, i);
+		kunmap_atomic(kaddr);
+		return wanted;
+	} else
+		return copy_page_to_iter_iovec(page, offset, bytes, i);
+}
+EXPORT_SYMBOL(copy_page_to_iter);
+
 static size_t copy_page_from_iter_iovec(struct page *page, size_t offset, size_t bytes,
 			 struct iov_iter *i)
 {
@@ -256,133 +322,18 @@ done:
 	return wanted - bytes;
 }
 
-static size_t zero_iovec(size_t bytes, struct iov_iter *i)
-{
-	size_t skip, copy, left, wanted;
-	const struct iovec *iov;
-	char __user *buf;
-
-	if (unlikely(bytes > i->count))
-		bytes = i->count;
-
-	if (unlikely(!bytes))
-		return 0;
-
-	wanted = bytes;
-	iov = i->iov;
-	skip = i->iov_offset;
-	buf = iov->iov_base + skip;
-	copy = min(bytes, iov->iov_len - skip);
-
-	left = __clear_user(buf, copy);
-	copy -= left;
-	skip += copy;
-	bytes -= copy;
-
-	while (unlikely(!left && bytes)) {
-		iov++;
-		buf = iov->iov_base;
-		copy = min(bytes, iov->iov_len);
-		left = __clear_user(buf, copy);
-		copy -= left;
-		skip = copy;
-		bytes -= copy;
-	}
-
-	if (skip == iov->iov_len) {
-		iov++;
-		skip = 0;
-	}
-	i->count -= wanted - bytes;
-	i->nr_segs -= iov - i->iov;
-	i->iov = iov;
-	i->iov_offset = skip;
-	return wanted - bytes;
-}
-
-static size_t __iovec_copy_from_user_inatomic(char *vaddr,
-			const struct iovec *iov, size_t base, size_t bytes)
-{
-	size_t copied = 0, left = 0;
-
-	while (bytes) {
-		char __user *buf = iov->iov_base + base;
-		int copy = min(bytes, iov->iov_len - base);
-
-		base = 0;
-		left = __copy_from_user_inatomic(vaddr, buf, copy);
-		copied += copy;
-		bytes -= copy;
-		vaddr += copy;
-		iov++;
-
-		if (unlikely(left))
-			break;
-	}
-	return copied - left;
-}
-
-/*
- * Copy as much as we can into the page and return the number of bytes which
- * were successfully copied.  If a fault is encountered then return the number of
- * bytes which were copied.
- */
-static size_t copy_from_user_atomic_iovec(struct page *page,
-		struct iov_iter *i, unsigned long offset, size_t bytes)
-{
-	char *kaddr;
-	size_t copied;
-
-	kaddr = kmap_atomic(page);
-	if (likely(i->nr_segs == 1)) {
-		int left;
-		char __user *buf = i->iov->iov_base + i->iov_offset;
-		left = __copy_from_user_inatomic(kaddr + offset, buf, bytes);
-		copied = bytes - left;
-	} else {
-		copied = __iovec_copy_from_user_inatomic(kaddr + offset,
-						i->iov, i->iov_offset, bytes);
-	}
-	kunmap_atomic(kaddr);
-
-	return copied;
-}
-
-static void advance_iovec(struct iov_iter *i, size_t bytes)
+size_t copy_page_from_iter(struct page *page, size_t offset, size_t bytes,
+			 struct iov_iter *i)
 {
-	BUG_ON(i->count < bytes);
-
-	if (likely(i->nr_segs == 1)) {
-		i->iov_offset += bytes;
-		i->count -= bytes;
-	} else {
-		const struct iovec *iov = i->iov;
-		size_t base = i->iov_offset;
-		unsigned long nr_segs = i->nr_segs;
-
-		/*
-		 * The !iov->iov_len check ensures we skip over unlikely
-		 * zero-length segments (without overruning the iovec).
-		 */
-		while (bytes || unlikely(i->count && !iov->iov_len)) {
-			int copy;
-
-			copy = min(bytes, iov->iov_len - base);
-			BUG_ON(!i->count || i->count < copy);
-			i->count -= copy;
-			bytes -= copy;
-			base += copy;
-			if (iov->iov_len == base) {
-				iov++;
-				nr_segs--;
-				base = 0;
-			}
-		}
-		i->iov = iov;
-		i->iov_offset = base;
-		i->nr_segs = nr_segs;
-	}
+	if (i->type & ITER_BVEC) {
+		void *kaddr = kmap_atomic(page);
+		size_t wanted = copy_from_iter(kaddr + offset, bytes, i);
+		kunmap_atomic(kaddr);
+		return wanted;
+	} else
+		return copy_page_from_iter_iovec(page, offset, bytes, i);
 }
+EXPORT_SYMBOL(copy_page_from_iter);
 
 /*
  * Fault in the first iovec of the given iov_iter, to a maximum length
@@ -404,29 +355,43 @@ int iov_iter_fault_in_readable(struct iov_iter *i, size_t bytes)
 }
 EXPORT_SYMBOL(iov_iter_fault_in_readable);
 
-static unsigned long alignment_iovec(const struct iov_iter *i)
+size_t iov_iter_zero(size_t bytes, struct iov_iter *i)
 {
-	const struct iovec *iov = i->iov;
-	unsigned long res;
-	size_t size = i->count;
-	size_t n;
+	if (unlikely(bytes > i->count))
+		bytes = i->count;
 
-	if (!size)
+	if (unlikely(!bytes))
 		return 0;
 
-	res = (unsigned long)iov->iov_base + i->iov_offset;
-	n = iov->iov_len - i->iov_offset;
-	if (n >= size)
-		return res | size;
-	size -= n;
-	res |= n;
-	while (size > (++iov)->iov_len) {
-		res |= (unsigned long)iov->iov_base | iov->iov_len;
-		size -= iov->iov_len;
-	}
-	res |= (unsigned long)iov->iov_base | size;
-	return res;
+	iterate_all_kinds_shift(i, bytes, v,
+		__clear_user(v.iov_base, v.iov_len),
+		memzero_page(v.bv_page, v.bv_offset, v.bv_len)
+	)
+
+	return bytes;
 }
+EXPORT_SYMBOL(iov_iter_zero);
+
+size_t iov_iter_copy_from_user_atomic(struct page *page,
+		struct iov_iter *i, unsigned long offset, size_t bytes)
+{
+	char *kaddr = kmap_atomic(page), *p = kaddr + offset;
+	iterate_all_kinds(i, bytes, v,
+		__copy_from_user_inatomic((p += v.iov_len) - v.iov_len,
+					  v.iov_base, v.iov_len),
+		memcpy_from_page((p += v.bv_len) - v.bv_len, v.bv_page,
+				 v.bv_offset, v.bv_len)
+	)
+	kunmap_atomic(kaddr);
+	return bytes;
+}
+EXPORT_SYMBOL(iov_iter_copy_from_user_atomic);
+
+void iov_iter_advance(struct iov_iter *i, size_t size)
+{
+	iterate_all_kinds_shift(i, size, v, 0, 0)
+}
+EXPORT_SYMBOL(iov_iter_advance);
 
 void iov_iter_init(struct iov_iter *i, int direction,
 			const struct iovec *iov, unsigned long nr_segs,
@@ -443,465 +408,134 @@ void iov_iter_init(struct iov_iter *i, int direction,
 }
 EXPORT_SYMBOL(iov_iter_init);
 
-static ssize_t get_pages_iovec(struct iov_iter *i,
-		   struct page **pages, size_t maxsize, unsigned maxpages,
-		   size_t *start)
-{
-	size_t offset = i->iov_offset;
-	const struct iovec *iov = i->iov;
-	size_t len;
-	unsigned long addr;
-	int n;
-	int res;
-
-	len = iov->iov_len - offset;
-	if (len > i->count)
-		len = i->count;
-	if (len > maxsize)
-		len = maxsize;
-	addr = (unsigned long)iov->iov_base + offset;
-	len += *start = addr & (PAGE_SIZE - 1);
-	if (len > maxpages * PAGE_SIZE)
-		len = maxpages * PAGE_SIZE;
-	addr &= ~(PAGE_SIZE - 1);
-	n = (len + PAGE_SIZE - 1) / PAGE_SIZE;
-	res = get_user_pages_fast(addr, n, (i->type & WRITE) != WRITE, pages);
-	if (unlikely(res < 0))
-		return res;
-	return (res == n ? len : res * PAGE_SIZE) - *start;
-}
-
-static ssize_t get_pages_alloc_iovec(struct iov_iter *i,
-		   struct page ***pages, size_t maxsize,
-		   size_t *start)
-{
-	size_t offset = i->iov_offset;
-	const struct iovec *iov = i->iov;
-	size_t len;
-	unsigned long addr;
-	void *p;
-	int n;
-	int res;
-
-	len = iov->iov_len - offset;
-	if (len > i->count)
-		len = i->count;
-	if (len > maxsize)
-		len = maxsize;
-	addr = (unsigned long)iov->iov_base + offset;
-	len += *start = addr & (PAGE_SIZE - 1);
-	addr &= ~(PAGE_SIZE - 1);
-	n = (len + PAGE_SIZE - 1) / PAGE_SIZE;
-	
-	p = kmalloc(n * sizeof(struct page *), GFP_KERNEL);
-	if (!p)
-		p = vmalloc(n * sizeof(struct page *));
-	if (!p)
-		return -ENOMEM;
-
-	res = get_user_pages_fast(addr, n, (i->type & WRITE) != WRITE, p);
-	if (unlikely(res < 0)) {
-		kvfree(p);
-		return res;
-	}
-	*pages = p;
-	return (res == n ? len : res * PAGE_SIZE) - *start;
-}
-
-static int iov_iter_npages_iovec(const struct iov_iter *i, int maxpages)
+unsigned long iov_iter_alignment(const struct iov_iter *i)
 {
-	size_t offset = i->iov_offset;
+	unsigned long res = 0;
 	size_t size = i->count;
-	const struct iovec *iov = i->iov;
-	int npages = 0;
-	int n;
-
-	for (n = 0; size && n < i->nr_segs; n++, iov++) {
-		unsigned long addr = (unsigned long)iov->iov_base + offset;
-		size_t len = iov->iov_len - offset;
-		offset = 0;
-		if (unlikely(!len))	/* empty segment */
-			continue;
-		if (len > size)
-			len = size;
-		npages += (addr + len + PAGE_SIZE - 1) / PAGE_SIZE
-			  - addr / PAGE_SIZE;
-		if (npages >= maxpages)	/* don't bother going further */
-			return maxpages;
-		size -= len;
-		offset = 0;
-	}
-	return min(npages, maxpages);
-}
-
-static void memcpy_from_page(char *to, struct page *page, size_t offset, size_t len)
-{
-	char *from = kmap_atomic(page);
-	memcpy(to, from + offset, len);
-	kunmap_atomic(from);
-}
-
-static void memcpy_to_page(struct page *page, size_t offset, char *from, size_t len)
-{
-	char *to = kmap_atomic(page);
-	memcpy(to + offset, from, len);
-	kunmap_atomic(to);
-}
-
-static void memzero_page(struct page *page, size_t offset, size_t len)
-{
-	char *addr = kmap_atomic(page);
-	memset(addr + offset, 0, len);
-	kunmap_atomic(addr);
-}
-
-static size_t copy_to_iter_bvec(void *from, size_t bytes, struct iov_iter *i)
-{
-	size_t skip, copy, wanted;
-	const struct bio_vec *bvec;
 
-	if (unlikely(bytes > i->count))
-		bytes = i->count;
-
-	if (unlikely(!bytes))
+	if (!size)
 		return 0;
 
-	wanted = bytes;
-	bvec = i->bvec;
-	skip = i->iov_offset;
-	copy = min_t(size_t, bytes, bvec->bv_len - skip);
-
-	memcpy_to_page(bvec->bv_page, skip + bvec->bv_offset, from, copy);
-	skip += copy;
-	from += copy;
-	bytes -= copy;
-	while (bytes) {
-		bvec++;
-		copy = min(bytes, (size_t)bvec->bv_len);
-		memcpy_to_page(bvec->bv_page, bvec->bv_offset, from, copy);
-		skip = copy;
-		from += copy;
-		bytes -= copy;
-	}
-	if (skip == bvec->bv_len) {
-		bvec++;
-		skip = 0;
-	}
-	i->count -= wanted - bytes;
-	i->nr_segs -= bvec - i->bvec;
-	i->bvec = bvec;
-	i->iov_offset = skip;
-	return wanted - bytes;
+	iterate_all_kinds(i, size, v,
+		(res |= (unsigned long)v.iov_base | v.iov_len, 0),
+		res |= v.bv_offset | v.bv_len
+	)
+	return res;
 }
+EXPORT_SYMBOL(iov_iter_alignment);
 
-static size_t copy_from_iter_bvec(void *to, size_t bytes, struct iov_iter *i)
+ssize_t iov_iter_get_pages(struct iov_iter *i,
+		   struct page **pages, size_t maxsize, unsigned maxpages,
+		   size_t *start)
 {
-	size_t skip, copy, wanted;
-	const struct bio_vec *bvec;
+	if (maxsize > i->count)
+		maxsize = i->count;
 
-	if (unlikely(bytes > i->count))
-		bytes = i->count;
-
-	if (unlikely(!bytes))
+	if (!maxsize)
 		return 0;
 
-	wanted = bytes;
-	bvec = i->bvec;
-	skip = i->iov_offset;
-
-	copy = min(bytes, bvec->bv_len - skip);
-
-	memcpy_from_page(to, bvec->bv_page, bvec->bv_offset + skip, copy);
-
-	to += copy;
-	skip += copy;
-	bytes -= copy;
-
-	while (bytes) {
-		bvec++;
-		copy = min(bytes, (size_t)bvec->bv_len);
-		memcpy_from_page(to, bvec->bv_page, bvec->bv_offset, copy);
-		skip = copy;
-		to += copy;
-		bytes -= copy;
-	}
-	if (skip == bvec->bv_len) {
-		bvec++;
-		skip = 0;
-	}
-	i->count -= wanted;
-	i->nr_segs -= bvec - i->bvec;
-	i->bvec = bvec;
-	i->iov_offset = skip;
-	return wanted;
-}
-
-static size_t copy_page_to_iter_bvec(struct page *page, size_t offset,
-					size_t bytes, struct iov_iter *i)
-{
-	void *kaddr = kmap_atomic(page);
-	size_t wanted = copy_to_iter_bvec(kaddr + offset, bytes, i);
-	kunmap_atomic(kaddr);
-	return wanted;
+	iterate_all_kinds(i, maxsize, v, ({ if (likely(v.iov_len)) {
+		unsigned long addr = (unsigned long)v.iov_base;
+		size_t len = v.iov_len + (*start = addr & (PAGE_SIZE - 1));
+		int n;
+		int res;
+
+		if (len > maxpages * PAGE_SIZE)
+			len = maxpages * PAGE_SIZE;
+		addr &= ~(PAGE_SIZE - 1);
+		n = DIV_ROUND_UP(len, PAGE_SIZE);
+		res = get_user_pages_fast(addr, n, (i->type & WRITE) != WRITE, pages);
+		if (unlikely(res < 0))
+			return res;
+		return (res == n ? len : res * PAGE_SIZE) - *start;
+	}0;}),({ if (likely(v.bv_len)) {
+		/* can't be more than PAGE_SIZE */
+		*start = v.bv_offset;
+		get_page(*pages = v.bv_page);
+		return v.bv_len;
+	}})
+	)
+	return 0;
 }
+EXPORT_SYMBOL(iov_iter_get_pages);
 
-static size_t copy_page_from_iter_bvec(struct page *page, size_t offset,
-					size_t bytes, struct iov_iter *i)
+static struct page **get_pages_array(size_t n)
 {
-	void *kaddr = kmap_atomic(page);
-	size_t wanted = copy_from_iter_bvec(kaddr + offset, bytes, i);
-	kunmap_atomic(kaddr);
-	return wanted;
+	struct page **p = kmalloc(n * sizeof(struct page *), GFP_KERNEL);
+	if (!p)
+		p = vmalloc(n * sizeof(struct page *));
+	return p;
 }
 
-static size_t zero_bvec(size_t bytes, struct iov_iter *i)
+ssize_t iov_iter_get_pages_alloc(struct iov_iter *i,
+		   struct page ***pages, size_t maxsize,
+		   size_t *start)
 {
-	size_t skip, copy, wanted;
-	const struct bio_vec *bvec;
+	struct page **p;
 
-	if (unlikely(bytes > i->count))
-		bytes = i->count;
+	if (maxsize > i->count)
+		maxsize = i->count;
 
-	if (unlikely(!bytes))
+	if (!maxsize)
 		return 0;
 
-	wanted = bytes;
-	bvec = i->bvec;
-	skip = i->iov_offset;
-	copy = min_t(size_t, bytes, bvec->bv_len - skip);
-
-	memzero_page(bvec->bv_page, skip + bvec->bv_offset, copy);
-	skip += copy;
-	bytes -= copy;
-	while (bytes) {
-		bvec++;
-		copy = min(bytes, (size_t)bvec->bv_len);
-		memzero_page(bvec->bv_page, bvec->bv_offset, copy);
-		skip = copy;
-		bytes -= copy;
-	}
-	if (skip == bvec->bv_len) {
-		bvec++;
-		skip = 0;
-	}
-	i->count -= wanted - bytes;
-	i->nr_segs -= bvec - i->bvec;
-	i->bvec = bvec;
-	i->iov_offset = skip;
-	return wanted - bytes;
-}
-
-static size_t copy_from_user_bvec(struct page *page,
-		struct iov_iter *i, unsigned long offset, size_t bytes)
-{
-	char *kaddr;
-	size_t left;
-	const struct bio_vec *bvec;
-	size_t base = i->iov_offset;
-
-	kaddr = kmap_atomic(page);
-	for (left = bytes, bvec = i->bvec; left; bvec++, base = 0) {
-		size_t copy = min(left, bvec->bv_len - base);
-		if (!bvec->bv_len)
-			continue;
-		memcpy_from_page(kaddr + offset, bvec->bv_page,
-				 bvec->bv_offset + base, copy);
-		offset += copy;
-		left -= copy;
-	}
-	kunmap_atomic(kaddr);
-	return bytes;
-}
-
-static void advance_bvec(struct iov_iter *i, size_t bytes)
-{
-	BUG_ON(i->count < bytes);
-
-	if (likely(i->nr_segs == 1)) {
-		i->iov_offset += bytes;
-		i->count -= bytes;
-	} else {
-		const struct bio_vec *bvec = i->bvec;
-		size_t base = i->iov_offset;
-		unsigned long nr_segs = i->nr_segs;
-
-		/*
-		 * The !iov->iov_len check ensures we skip over unlikely
-		 * zero-length segments (without overruning the iovec).
-		 */
-		while (bytes || unlikely(i->count && !bvec->bv_len)) {
-			int copy;
-
-			copy = min(bytes, bvec->bv_len - base);
-			BUG_ON(!i->count || i->count < copy);
-			i->count -= copy;
-			bytes -= copy;
-			base += copy;
-			if (bvec->bv_len == base) {
-				bvec++;
-				nr_segs--;
-				base = 0;
-			}
+	iterate_all_kinds(i, maxsize, v, ({ if (likely(v.iov_len)) {
+		unsigned long addr = (unsigned long)v.iov_base;
+		size_t len = v.iov_len + (*start = addr & (PAGE_SIZE - 1));
+		int n;
+		int res;
+
+		addr &= ~(PAGE_SIZE - 1);
+		n = DIV_ROUND_UP(len, PAGE_SIZE);
+		p = get_pages_array(n);
+		if (!p)
+			return -ENOMEM;
+		res = get_user_pages_fast(addr, n, (i->type & WRITE) != WRITE, p);
+		if (unlikely(res < 0)) {
+			kvfree(p);
+			return res;
 		}
-		i->bvec = bvec;
-		i->iov_offset = base;
-		i->nr_segs = nr_segs;
-	}
+		*pages = p;
+		return (res == n ? len : res * PAGE_SIZE) - *start;
+	}0;}),({ if (likely(v.bv_len)) {
+		/* can't be more than PAGE_SIZE */
+		*start = v.bv_offset;
+		*pages = p = get_pages_array(1);
+		if (!p)
+			return -ENOMEM;
+		get_page(*p = v.bv_page);
+		return v.bv_len;
+	}})
+	)
+	return 0;
 }
+EXPORT_SYMBOL(iov_iter_get_pages_alloc);
 
-static unsigned long alignment_bvec(const struct iov_iter *i)
+int iov_iter_npages(const struct iov_iter *i, int maxpages)
 {
-	const struct bio_vec *bvec = i->bvec;
-	unsigned long res;
 	size_t size = i->count;
-	size_t n;
+	int npages = 0;
 
 	if (!size)
 		return 0;
 
-	res = bvec->bv_offset + i->iov_offset;
-	n = bvec->bv_len - i->iov_offset;
-	if (n >= size)
-		return res | size;
-	size -= n;
-	res |= n;
-	while (size > (++bvec)->bv_len) {
-		res |= bvec->bv_offset | bvec->bv_len;
-		size -= bvec->bv_len;
-	}
-	res |= bvec->bv_offset | size;
-	return res;
-}
-
-static ssize_t get_pages_bvec(struct iov_iter *i,
-		   struct page **pages, size_t maxsize, unsigned maxpages,
-		   size_t *start)
-{
-	const struct bio_vec *bvec = i->bvec;
-	size_t len = bvec->bv_len - i->iov_offset;
-	if (len > i->count)
-		len = i->count;
-	if (len > maxsize)
-		len = maxsize;
-	/* can't be more than PAGE_SIZE */
-	*start = bvec->bv_offset + i->iov_offset;
-
-	get_page(*pages = bvec->bv_page);
-
-	return len;
-}
-
-static ssize_t get_pages_alloc_bvec(struct iov_iter *i,
-		   struct page ***pages, size_t maxsize,
-		   size_t *start)
-{
-	const struct bio_vec *bvec = i->bvec;
-	size_t len = bvec->bv_len - i->iov_offset;
-	if (len > i->count)
-		len = i->count;
-	if (len > maxsize)
-		len = maxsize;
-	*start = bvec->bv_offset + i->iov_offset;
-
-	*pages = kmalloc(sizeof(struct page *), GFP_KERNEL);
-	if (!*pages)
-		return -ENOMEM;
-
-	get_page(**pages = bvec->bv_page);
-
-	return len;
-}
-
-static int iov_iter_npages_bvec(const struct iov_iter *i, int maxpages)
-{
-	size_t offset = i->iov_offset;
-	size_t size = i->count;
-	const struct bio_vec *bvec = i->bvec;
-	int npages = 0;
-	int n;
-
-	for (n = 0; size && n < i->nr_segs; n++, bvec++) {
-		size_t len = bvec->bv_len - offset;
-		offset = 0;
-		if (unlikely(!len))	/* empty segment */
-			continue;
-		if (len > size)
-			len = size;
-		npages++;
-		if (npages >= maxpages)	/* don't bother going further */
-			return maxpages;
-		size -= len;
-		offset = 0;
-	}
-	return min(npages, maxpages);
-}
-
-size_t copy_page_to_iter(struct page *page, size_t offset, size_t bytes,
-			 struct iov_iter *i)
-{
-	if (i->type & ITER_BVEC)
-		return copy_page_to_iter_bvec(page, offset, bytes, i);
-	else
-		return copy_page_to_iter_iovec(page, offset, bytes, i);
+	iterate_all_kinds(i, size, v,
+		({if (v.iov_len) {
+			unsigned long p = (unsigned long)v.iov_base;
+			npages += DIV_ROUND_UP(p + v.iov_len, PAGE_SIZE)
+				- p / PAGE_SIZE;
+			if (npages >= maxpages)
+				return maxpages;
+		 }0;}),
+		({if (v.bv_len) {
+			npages++;
+			if (npages >= maxpages)
+				return maxpages;
+		 }})
+	)
+	return npages;
 }
-EXPORT_SYMBOL(copy_page_to_iter);
-
-size_t copy_page_from_iter(struct page *page, size_t offset, size_t bytes,
-			 struct iov_iter *i)
-{
-	if (i->type & ITER_BVEC)
-		return copy_page_from_iter_bvec(page, offset, bytes, i);
-	else
-		return copy_page_from_iter_iovec(page, offset, bytes, i);
-}
-EXPORT_SYMBOL(copy_page_from_iter);
-
-size_t copy_to_iter(void *addr, size_t bytes, struct iov_iter *i)
-{
-	if (i->type & ITER_BVEC)
-		return copy_to_iter_bvec(addr, bytes, i);
-	else
-		return copy_to_iter_iovec(addr, bytes, i);
-}
-EXPORT_SYMBOL(copy_to_iter);
-
-size_t copy_from_iter(void *addr, size_t bytes, struct iov_iter *i)
-{
-	if (i->type & ITER_BVEC)
-		return copy_from_iter_bvec(addr, bytes, i);
-	else
-		return copy_from_iter_iovec(addr, bytes, i);
-}
-EXPORT_SYMBOL(copy_from_iter);
-
-size_t iov_iter_zero(size_t bytes, struct iov_iter *i)
-{
-	if (i->type & ITER_BVEC) {
-		return zero_bvec(bytes, i);
-	} else {
-		return zero_iovec(bytes, i);
-	}
-}
-EXPORT_SYMBOL(iov_iter_zero);
-
-size_t iov_iter_copy_from_user_atomic(struct page *page,
-		struct iov_iter *i, unsigned long offset, size_t bytes)
-{
-	if (i->type & ITER_BVEC)
-		return copy_from_user_bvec(page, i, offset, bytes);
-	else
-		return copy_from_user_atomic_iovec(page, i, offset, bytes);
-}
-EXPORT_SYMBOL(iov_iter_copy_from_user_atomic);
-
-void iov_iter_advance(struct iov_iter *i, size_t size)
-{
-	if (i->type & ITER_BVEC)
-		advance_bvec(i, size);
-	else
-		advance_iovec(i, size);
-}
-EXPORT_SYMBOL(iov_iter_advance);
+EXPORT_SYMBOL(iov_iter_npages);
 
 /*
  * Return the count of just the current iov_iter segment.
@@ -916,43 +550,3 @@ size_t iov_iter_single_seg_count(const struct iov_iter *i)
 		return min(i->count, i->bvec->bv_len - i->iov_offset);
 }
 EXPORT_SYMBOL(iov_iter_single_seg_count);
-
-unsigned long iov_iter_alignment(const struct iov_iter *i)
-{
-	if (i->type & ITER_BVEC)
-		return alignment_bvec(i);
-	else
-		return alignment_iovec(i);
-}
-EXPORT_SYMBOL(iov_iter_alignment);
-
-ssize_t iov_iter_get_pages(struct iov_iter *i,
-		   struct page **pages, size_t maxsize, unsigned maxpages,
-		   size_t *start)
-{
-	if (i->type & ITER_BVEC)
-		return get_pages_bvec(i, pages, maxsize, maxpages, start);
-	else
-		return get_pages_iovec(i, pages, maxsize, maxpages, start);
-}
-EXPORT_SYMBOL(iov_iter_get_pages);
-
-ssize_t iov_iter_get_pages_alloc(struct iov_iter *i,
-		   struct page ***pages, size_t maxsize,
-		   size_t *start)
-{
-	if (i->type & ITER_BVEC)
-		return get_pages_alloc_bvec(i, pages, maxsize, start);
-	else
-		return get_pages_alloc_iovec(i, pages, maxsize, start);
-}
-EXPORT_SYMBOL(iov_iter_get_pages_alloc);
-
-int iov_iter_npages(const struct iov_iter *i, int maxpages)
-{
-	if (i->type & ITER_BVEC)
-		return iov_iter_npages_bvec(i, maxpages);
-	else
-		return iov_iter_npages_iovec(i, maxpages);
-}
-EXPORT_SYMBOL(iov_iter_npages);
