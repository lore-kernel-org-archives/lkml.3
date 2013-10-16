Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935075Ab3JPOSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:18:00 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:26521 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934440Ab3JPOFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:05:45 -0400
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, Christoph Hellwig <hch@infradead.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH V9 08/33] iov_iter: add bvec support
Date: Wed, 16 Oct 2013 09:04:21 -0500
Message-Id: <1381932286-14978-9-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381932286-14978-1-git-send-email-dave.kleikamp@oracle.com>
References: <1381932286-14978-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@zabbo.net>

This adds a set of iov_iter_ops calls which work with memory which is
specified by an array of bio_vec structs instead of an array of iovec
structs.

The big difference is that the pages referenced by the bio_vec elements
are pinned.  They don't need to be faulted in and we can always use
kmap_atomic() to map them one at a time.

Signed-off-by: Zach Brown <zab@zabbo.net>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 fs/iov-iter.c      | 129 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |  19 ++++++++
 2 files changed, 148 insertions(+)

diff --git a/fs/iov-iter.c b/fs/iov-iter.c
index 59f9556..5624e36 100644
--- a/fs/iov-iter.c
+++ b/fs/iov-iter.c
@@ -5,6 +5,7 @@
 #include <linux/hardirq.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
+#include <linux/bio.h>
 
 static size_t __iovec_copy_to_user(char *vaddr, const struct iovec *iov,
 				   size_t base, size_t bytes, int atomic)
@@ -109,6 +110,134 @@ success:
 	return copied;
 }
 
+#ifdef CONFIG_BLOCK
+/*
+ * As an easily verifiable first pass, we implement all the methods that
+ * copy data to and from bvec pages with one function.  We implement it
+ * all with kmap_atomic().
+ */
+static size_t bvec_copy_tofrom_page(struct iov_iter *iter, struct page *page,
+				    unsigned long page_offset, size_t bytes,
+				    int topage)
+{
+	struct bio_vec *bvec = (struct bio_vec *)iter->data;
+	size_t bvec_offset = iter->iov_offset;
+	size_t remaining = bytes;
+	void *bvec_map;
+	void *page_map;
+	size_t copy;
+
+	page_map = kmap_atomic(page);
+
+	BUG_ON(bytes > iter->count);
+	while (remaining) {
+		BUG_ON(bvec->bv_len == 0);
+		BUG_ON(bvec_offset >= bvec->bv_len);
+		copy = min(remaining, bvec->bv_len - bvec_offset);
+		bvec_map = kmap_atomic(bvec->bv_page);
+		if (topage)
+			memcpy(page_map + page_offset,
+			       bvec_map + bvec->bv_offset + bvec_offset,
+			       copy);
+		else
+			memcpy(bvec_map + bvec->bv_offset + bvec_offset,
+			       page_map + page_offset,
+			       copy);
+		kunmap_atomic(bvec_map);
+		remaining -= copy;
+		bvec_offset += copy;
+		page_offset += copy;
+		if (bvec_offset == bvec->bv_len) {
+			bvec_offset = 0;
+			bvec++;
+		}
+	}
+
+	kunmap_atomic(page_map);
+
+	return bytes;
+}
+
+static size_t ii_bvec_copy_to_user_atomic(struct page *page, struct iov_iter *i,
+					  unsigned long offset, size_t bytes)
+{
+	return bvec_copy_tofrom_page(i, page, offset, bytes, 0);
+}
+static size_t ii_bvec_copy_to_user(struct page *page, struct iov_iter *i,
+				   unsigned long offset, size_t bytes,
+				   int check_access)
+{
+	return bvec_copy_tofrom_page(i, page, offset, bytes, 0);
+}
+static size_t ii_bvec_copy_from_user_atomic(struct page *page,
+					    struct iov_iter *i,
+					    unsigned long offset, size_t bytes)
+{
+	return bvec_copy_tofrom_page(i, page, offset, bytes, 1);
+}
+static size_t ii_bvec_copy_from_user(struct page *page, struct iov_iter *i,
+				     unsigned long offset, size_t bytes)
+{
+	return bvec_copy_tofrom_page(i, page, offset, bytes, 1);
+}
+
+/*
+ * bio_vecs have a stricter structure than iovecs that might have
+ * come from userspace.  There are no zero length bio_vec elements.
+ */
+static void ii_bvec_advance(struct iov_iter *i, size_t bytes)
+{
+	struct bio_vec *bvec = (struct bio_vec *)i->data;
+	size_t offset = i->iov_offset;
+	size_t delta;
+
+	BUG_ON(i->count < bytes);
+	while (bytes) {
+		BUG_ON(bvec->bv_len == 0);
+		BUG_ON(bvec->bv_len <= offset);
+		delta = min(bytes, bvec->bv_len - offset);
+		offset += delta;
+		i->count -= delta;
+		bytes -= delta;
+		if (offset == bvec->bv_len) {
+			bvec++;
+			offset = 0;
+		}
+	}
+
+	i->data = (unsigned long)bvec;
+	i->iov_offset = offset;
+}
+
+/*
+ * pages pointed to by bio_vecs are always pinned.
+ */
+static int ii_bvec_fault_in_readable(struct iov_iter *i, size_t bytes)
+{
+	return 0;
+}
+
+static size_t ii_bvec_single_seg_count(const struct iov_iter *i)
+{
+	const struct bio_vec *bvec = (struct bio_vec *)i->data;
+	if (i->nr_segs == 1)
+		return i->count;
+	else
+		return min(i->count, bvec->bv_len - i->iov_offset);
+}
+
+struct iov_iter_ops ii_bvec_ops = {
+	.ii_copy_to_user_atomic = ii_bvec_copy_to_user_atomic,
+	.ii_copy_to_user = ii_bvec_copy_to_user,
+	.ii_copy_from_user_atomic = ii_bvec_copy_from_user_atomic,
+	.ii_copy_from_user = ii_bvec_copy_from_user,
+	.ii_advance = ii_bvec_advance,
+	.ii_fault_in_readable = ii_bvec_fault_in_readable,
+	.ii_single_seg_count = ii_bvec_single_seg_count,
+};
+EXPORT_SYMBOL(ii_bvec_ops);
+#endif	/* CONFIG_BLOCK */
+
 static size_t __iovec_copy_from_user(char *vaddr, const struct iovec *iov,
 				     size_t base, size_t bytes, int atomic)
 {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0137010..ea607ef 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -350,6 +350,25 @@ static inline size_t iov_iter_single_seg_count(const struct iov_iter *i)
 	return i->ops->ii_single_seg_count(i);
 }
 
+#ifdef CONFIG_BLOCK
+extern struct iov_iter_ops ii_bvec_ops;
+
+struct bio_vec;
+static inline void iov_iter_init_bvec(struct iov_iter *i,
+				      struct bio_vec *bvec,
+				      unsigned long nr_segs,
+				      size_t count, size_t written)
+{
+	i->ops = &ii_bvec_ops;
+	i->data = (unsigned long)bvec;
+	i->nr_segs = nr_segs;
+	i->iov_offset = 0;
+	i->count = count + written;
+
+	iov_iter_advance(i, written);
+}
+#endif
+
 extern struct iov_iter_ops ii_iovec_ops;
 
 static inline void iov_iter_init(struct iov_iter *i,
-- 
1.8.4

