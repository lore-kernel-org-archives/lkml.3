Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047AbaH0EfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 00:35:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:56535 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932942AbaH0EfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 00:35:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,408,1406617200"; 
   d="scan'208";a="590397312"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH v10 06/21] Add copy_to_iter(), copy_from_iter() and iov_iter_zero()
Date: Tue, 26 Aug 2014 23:45:26 -0400
Message-Id: <00ef35c57f3276dff8ea8b101fb44fbd36aa6edd.1409110741.git.matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <cover.1409110741.git.matthew.r.wilcox@intel.com>
References: <cover.1409110741.git.matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1409110741.git.matthew.r.wilcox@intel.com>
References: <cover.1409110741.git.matthew.r.wilcox@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <willy@linux.intel.com>

For DAX, we want to be able to copy between iovecs and kernel addresses
that don't necessarily have a struct page.  This is a fairly simple
rearrangement for bvec iters to kmap the pages outside and pass them in,
but for user iovecs it gets more complicated because we might try various
different ways to kmap the memory.  Duplicating the existing logic works
out best in this case.

We need to be able to write zeroes to an iovec for reads from unwritten
ranges in a file.  This is performed by the new iov_iter_zero() function,
again patterned after the existing code that handles iovec iterators.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 include/linux/uio.h |   3 +
 mm/iov_iter.c       | 237 ++++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 226 insertions(+), 14 deletions(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 48d64e6..1863ddd 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -80,6 +80,9 @@ size_t copy_page_to_iter(struct page *page, size_t offset, size_t bytes,
 			 struct iov_iter *i);
 size_t copy_page_from_iter(struct page *page, size_t offset, size_t bytes,
 			 struct iov_iter *i);
+size_t copy_to_iter(void *addr, size_t bytes, struct iov_iter *i);
+size_t copy_from_iter(void *addr, size_t bytes, struct iov_iter *i);
+size_t iov_iter_zero(size_t bytes, struct iov_iter *);
 unsigned long iov_iter_alignment(const struct iov_iter *i);
 void iov_iter_init(struct iov_iter *i, int direction, const struct iovec *iov,
 			unsigned long nr_segs, size_t count);
diff --git a/mm/iov_iter.c b/mm/iov_iter.c
index ab88dc0..d481fd8 100644
--- a/mm/iov_iter.c
+++ b/mm/iov_iter.c
@@ -4,6 +4,96 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 
+static size_t copy_to_iter_iovec(void *from, size_t bytes, struct iov_iter *i)
+{
+	size_t skip, copy, left, wanted;
+	const struct iovec *iov;
+	char __user *buf;
+
+	if (unlikely(bytes > i->count))
+		bytes = i->count;
+
+	if (unlikely(!bytes))
+		return 0;
+
+	wanted = bytes;
+	iov = i->iov;
+	skip = i->iov_offset;
+	buf = iov->iov_base + skip;
+	copy = min(bytes, iov->iov_len - skip);
+
+	left = __copy_to_user(buf, from, copy);
+	copy -= left;
+	skip += copy;
+	from += copy;
+	bytes -= copy;
+	while (unlikely(!left && bytes)) {
+		iov++;
+		buf = iov->iov_base;
+		copy = min(bytes, iov->iov_len);
+		left = __copy_to_user(buf, from, copy);
+		copy -= left;
+		skip = copy;
+		from += copy;
+		bytes -= copy;
+	}
+
+	if (skip == iov->iov_len) {
+		iov++;
+		skip = 0;
+	}
+	i->count -= wanted - bytes;
+	i->nr_segs -= iov - i->iov;
+	i->iov = iov;
+	i->iov_offset = skip;
+	return wanted - bytes;
+}
+
+static size_t copy_from_iter_iovec(void *to, size_t bytes, struct iov_iter *i)
+{
+	size_t skip, copy, left, wanted;
+	const struct iovec *iov;
+	char __user *buf;
+
+	if (unlikely(bytes > i->count))
+		bytes = i->count;
+
+	if (unlikely(!bytes))
+		return 0;
+
+	wanted = bytes;
+	iov = i->iov;
+	skip = i->iov_offset;
+	buf = iov->iov_base + skip;
+	copy = min(bytes, iov->iov_len - skip);
+
+	left = __copy_from_user(to, buf, copy);
+	copy -= left;
+	skip += copy;
+	to += copy;
+	bytes -= copy;
+	while (unlikely(!left && bytes)) {
+		iov++;
+		buf = iov->iov_base;
+		copy = min(bytes, iov->iov_len);
+		left = __copy_from_user(to, buf, copy);
+		copy -= left;
+		skip = copy;
+		to += copy;
+		bytes -= copy;
+	}
+
+	if (skip == iov->iov_len) {
+		iov++;
+		skip = 0;
+	}
+	i->count -= wanted - bytes;
+	i->nr_segs -= iov - i->iov;
+	i->iov = iov;
+	i->iov_offset = skip;
+	return wanted - bytes;
+}
+
 static size_t copy_page_to_iter_iovec(struct page *page, size_t offset, size_t bytes,
 			 struct iov_iter *i)
 {
@@ -166,6 +256,50 @@ done:
 	return wanted - bytes;
 }
 
+static size_t zero_iovec(size_t bytes, struct iov_iter *i)
+{
+	size_t skip, copy, left, wanted;
+	const struct iovec *iov;
+	char __user *buf;
+
+	if (unlikely(bytes > i->count))
+		bytes = i->count;
+
+	if (unlikely(!bytes))
+		return 0;
+
+	wanted = bytes;
+	iov = i->iov;
+	skip = i->iov_offset;
+	buf = iov->iov_base + skip;
+	copy = min(bytes, iov->iov_len - skip);
+
+	left = __clear_user(buf, copy);
+	copy -= left;
+	skip += copy;
+	bytes -= copy;
+
+	while (unlikely(!left && bytes)) {
+		iov++;
+		buf = iov->iov_base;
+		copy = min(bytes, iov->iov_len);
+		left = __clear_user(buf, copy);
+		copy -= left;
+		skip = copy;
+		bytes -= copy;
+	}
+
+	if (skip == iov->iov_len) {
+		iov++;
+		skip = 0;
+	}
+	i->count -= wanted - bytes;
+	i->nr_segs -= iov - i->iov;
+	i->iov = iov;
+	i->iov_offset = skip;
+	return wanted - bytes;
+}
+
 static size_t __iovec_copy_from_user_inatomic(char *vaddr,
 			const struct iovec *iov, size_t base, size_t bytes)
 {
@@ -412,12 +546,17 @@ static void memcpy_to_page(struct page *page, size_t offset, char *from, size_t
 	kunmap_atomic(to);
 }
 
-static size_t copy_page_to_iter_bvec(struct page *page, size_t offset, size_t bytes,
-			 struct iov_iter *i)
+static void memzero_page(struct page *page, size_t offset, size_t len)
+{
+	char *addr = kmap_atomic(page);
+	memset(addr + offset, 0, len);
+	kunmap_atomic(addr);
+}
+
+static size_t copy_to_iter_bvec(void *from, size_t bytes, struct iov_iter *i)
 {
 	size_t skip, copy, wanted;
 	const struct bio_vec *bvec;
-	void *kaddr, *from;
 
 	if (unlikely(bytes > i->count))
 		bytes = i->count;
@@ -430,8 +569,6 @@ static size_t copy_page_to_iter_bvec(struct page *page, size_t offset, size_t by
 	skip = i->iov_offset;
 	copy = min_t(size_t, bytes, bvec->bv_len - skip);
 
-	kaddr = kmap_atomic(page);
-	from = kaddr + offset;
 	memcpy_to_page(bvec->bv_page, skip + bvec->bv_offset, from, copy);
 	skip += copy;
 	from += copy;
@@ -444,7 +581,6 @@ static size_t copy_page_to_iter_bvec(struct page *page, size_t offset, size_t by
 		from += copy;
 		bytes -= copy;
 	}
-	kunmap_atomic(kaddr);
 	if (skip == bvec->bv_len) {
 		bvec++;
 		skip = 0;
@@ -456,12 +592,10 @@ static size_t copy_page_to_iter_bvec(struct page *page, size_t offset, size_t by
 	return wanted - bytes;
 }
 
-static size_t copy_page_from_iter_bvec(struct page *page, size_t offset, size_t bytes,
-			 struct iov_iter *i)
+static size_t copy_from_iter_bvec(void *to, size_t bytes, struct iov_iter *i)
 {
 	size_t skip, copy, wanted;
 	const struct bio_vec *bvec;
-	void *kaddr, *to;
 
 	if (unlikely(bytes > i->count))
 		bytes = i->count;
@@ -473,10 +607,6 @@ static size_t copy_page_from_iter_bvec(struct page *page, size_t offset, size_t
 	bvec = i->bvec;
 	skip = i->iov_offset;
 
-	kaddr = kmap_atomic(page);
-
-	to = kaddr + offset;
-
 	copy = min(bytes, bvec->bv_len - skip);
 
 	memcpy_from_page(to, bvec->bv_page, bvec->bv_offset + skip, copy);
@@ -493,7 +623,6 @@ static size_t copy_page_from_iter_bvec(struct page *page, size_t offset, size_t
 		to += copy;
 		bytes -= copy;
 	}
-	kunmap_atomic(kaddr);
 	if (skip == bvec->bv_len) {
 		bvec++;
 		skip = 0;
@@ -505,6 +634,61 @@ static size_t copy_page_from_iter_bvec(struct page *page, size_t offset, size_t
 	return wanted;
 }
 
+static size_t copy_page_to_iter_bvec(struct page *page, size_t offset,
+					size_t bytes, struct iov_iter *i)
+{
+	void *kaddr = kmap_atomic(page);
+	size_t wanted = copy_to_iter_bvec(kaddr + offset, bytes, i);
+	kunmap_atomic(kaddr);
+	return wanted;
+}
+
+static size_t copy_page_from_iter_bvec(struct page *page, size_t offset,
+					size_t bytes, struct iov_iter *i)
+{
+	void *kaddr = kmap_atomic(page);
+	size_t wanted = copy_from_iter_bvec(kaddr + offset, bytes, i);
+	kunmap_atomic(kaddr);
+	return wanted;
+}
+
+static size_t zero_bvec(size_t bytes, struct iov_iter *i)
+{
+	size_t skip, copy, wanted;
+	const struct bio_vec *bvec;
+
+	if (unlikely(bytes > i->count))
+		bytes = i->count;
+
+	if (unlikely(!bytes))
+		return 0;
+
+	wanted = bytes;
+	bvec = i->bvec;
+	skip = i->iov_offset;
+	copy = min_t(size_t, bytes, bvec->bv_len - skip);
+
+	memzero_page(bvec->bv_page, skip + bvec->bv_offset, copy);
+	skip += copy;
+	bytes -= copy;
+	while (bytes) {
+		bvec++;
+		copy = min(bytes, (size_t)bvec->bv_len);
+		memzero_page(bvec->bv_page, bvec->bv_offset, copy);
+		skip = copy;
+		bytes -= copy;
+	}
+	if (skip == bvec->bv_len) {
+		bvec++;
+		skip = 0;
+	}
+	i->count -= wanted - bytes;
+	i->nr_segs -= bvec - i->bvec;
+	i->bvec = bvec;
+	i->iov_offset = skip;
+	return wanted - bytes;
+}
+
 static size_t copy_from_user_bvec(struct page *page,
 		struct iov_iter *i, unsigned long offset, size_t bytes)
 {
@@ -668,6 +852,31 @@ size_t copy_page_from_iter(struct page *page, size_t offset, size_t bytes,
 }
 EXPORT_SYMBOL(copy_page_from_iter);
 
+size_t copy_to_iter(void *addr, size_t bytes, struct iov_iter *i)
+{
+	if (i->type & ITER_BVEC)
+		return copy_to_iter_bvec(addr, bytes, i);
+	else
+		return copy_to_iter_iovec(addr, bytes, i);
+}
+
+size_t copy_from_iter(void *addr, size_t bytes, struct iov_iter *i)
+{
+	if (i->type & ITER_BVEC)
+		return copy_from_iter_bvec(addr, bytes, i);
+	else
+		return copy_from_iter_iovec(addr, bytes, i);
+}
+
+size_t iov_iter_zero(size_t bytes, struct iov_iter *i)
+{
+	if (i->type & ITER_BVEC) {
+		return zero_bvec(bytes, i);
+	} else {
+		return zero_iovec(bytes, i);
+	}
+}
+
 size_t iov_iter_copy_from_user_atomic(struct page *page,
 		struct iov_iter *i, unsigned long offset, size_t bytes)
 {
-- 
2.0.0

