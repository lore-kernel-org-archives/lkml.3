Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933947Ab3CHXA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 18:00:59 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36029 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757654Ab3CHWwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 17:52:46 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: Zach Brown <zab@zabbo.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH V7 -next 06/33] iov_iter: hide iovec details behind ops function pointers
Date: Fri,  8 Mar 2013 16:52:01 -0600
Message-Id: <1362783148-22736-7-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1362783148-22736-1-git-send-email-dave.kleikamp@oracle.com>
References: <1362783148-22736-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@zabbo.net>

This moves the current iov_iter functions behind an ops struct of
function pointers.  The current iov_iter functions all work with memory
which is specified by iovec arrays of user space pointers.

This patch is part of a series that lets us specify memory with bio_vec
arrays of page pointers.  By moving to an iov_iter operation struct we
can add that support in later patches in this series by adding another
set of function pointers.

I only came to this after having initialy tried to teach the current
iov_iter functions about bio_vecs by introducing conditional branches
that dealt with bio_vecs in all the functions.  It wasn't pretty.  This
approach seems to be the lesser evil.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
---
 fs/cifs/file.c     |  4 +--
 fs/fuse/file.c     |  5 ++--
 fs/iov-iter.c      | 86 +++++++++++++++++++++++++++++-------------------------
 include/linux/fs.h | 77 ++++++++++++++++++++++++++++++++++++++----------
 4 files changed, 114 insertions(+), 58 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 517f464..1bce053 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2715,8 +2715,8 @@ cifs_readdata_to_iov(struct cifs_readdata *rdata, const struct iovec *iov,
 		/* go while there's data to be copied and no errors */
 		if (copy && !rc) {
 			pdata = kmap(page);
-			rc = memcpy_toiovecend(ii.iov, pdata, ii.iov_offset,
-						(int)copy);
+			rc = memcpy_toiovecend(iov_iter_iovec(&ii), pdata,
+					       ii.iov_offset, (int)copy);
 			kunmap(page);
 			if (!rc) {
 				*copied += copy;
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 6d5f1ed..a359fe0 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1059,9 +1059,10 @@ static inline void fuse_page_descs_length_init(struct fuse_req *req,
 			req->page_descs[i].offset;
 }
 
-static inline unsigned long fuse_get_user_addr(const struct iov_iter *ii)
+static inline unsigned long fuse_get_user_addr(struct iov_iter *ii)
 {
-	return (unsigned long)ii->iov->iov_base + ii->iov_offset;
+	struct iovec *iov = iov_iter_iovec(ii);
+	return (unsigned long)iov->iov_base + ii->iov_offset;
 }
 
 static inline size_t fuse_get_frag_size(const struct iov_iter *ii,
diff --git a/fs/iov-iter.c b/fs/iov-iter.c
index 6cecab4..6cb6be0 100644
--- a/fs/iov-iter.c
+++ b/fs/iov-iter.c
@@ -36,9 +36,10 @@ static size_t __iovec_copy_to_user(char *vaddr, const struct iovec *iov,
  * were sucessfully copied.  If a fault is encountered then return the number of
  * bytes which were copied.
  */
-size_t iov_iter_copy_to_user_atomic(struct page *page,
+static size_t ii_iovec_copy_to_user_atomic(struct page *page,
 		struct iov_iter *i, unsigned long offset, size_t bytes)
 {
+	struct iovec *iov = (struct iovec *)i->data;
 	char *kaddr;
 	size_t copied;
 
@@ -46,55 +47,52 @@ size_t iov_iter_copy_to_user_atomic(struct page *page,
 	kaddr = kmap_atomic(page);
 	if (likely(i->nr_segs == 1)) {
 		int left;
-		char __user *buf = i->iov->iov_base + i->iov_offset;
+		char __user *buf = iov->iov_base + i->iov_offset;
 		left = __copy_to_user_inatomic(buf, kaddr + offset, bytes);
 		copied = bytes - left;
 	} else {
-		copied = __iovec_copy_to_user(kaddr + offset, i->iov,
+		copied = __iovec_copy_to_user(kaddr + offset, iov,
 					      i->iov_offset, bytes, 1);
 	}
 	kunmap_atomic(kaddr);
 
 	return copied;
 }
-EXPORT_SYMBOL(iov_iter_copy_to_user_atomic);
 
 /*
  * This has the same sideeffects and return value as
- * iov_iter_copy_to_user_atomic().
+ * ii_iovec_copy_to_user_atomic().
  * The difference is that it attempts to resolve faults.
  * Page must not be locked.
  */
-size_t __iov_iter_copy_to_user(struct page *page,
-		struct iov_iter *i, unsigned long offset, size_t bytes)
+static size_t ii_iovec_copy_to_user(struct page *page,
+		struct iov_iter *i, unsigned long offset, size_t bytes,
+		int check_access)
 {
+	struct iovec *iov = (struct iovec *)i->data;
 	char *kaddr;
 	size_t copied;
 
+	if (check_access) {
+		might_sleep();
+		if (generic_segment_checks(iov, &i->nr_segs, &bytes,
+					   VERIFY_WRITE))
+			return 0;
+	}
+
 	kaddr = kmap(page);
 	if (likely(i->nr_segs == 1)) {
 		int left;
-		char __user *buf = i->iov->iov_base + i->iov_offset;
+		char __user *buf = iov->iov_base + i->iov_offset;
 		left = copy_to_user(buf, kaddr + offset, bytes);
 		copied = bytes - left;
 	} else {
-		copied = __iovec_copy_to_user(kaddr + offset, i->iov,
+		copied = __iovec_copy_to_user(kaddr + offset, iov,
 					      i->iov_offset, bytes, 0);
 	}
 	kunmap(page);
 	return copied;
 }
-EXPORT_SYMBOL(__iov_iter_copy_to_user);
-
-size_t iov_iter_copy_to_user(struct page *page,
-		struct iov_iter *i, unsigned long offset, size_t bytes)
-{
-	might_sleep();
-	if (generic_segment_checks(i->iov, &i->nr_segs, &bytes, VERIFY_WRITE))
-		return 0;
-	return __iov_iter_copy_to_user(page, i, offset, bytes);
-}
-EXPORT_SYMBOL(iov_iter_copy_to_user);
 
 static size_t __iovec_copy_from_user(char *vaddr, const struct iovec *iov,
 				     size_t base, size_t bytes, int atomic)
@@ -126,9 +124,10 @@ static size_t __iovec_copy_from_user(char *vaddr, const struct iovec *iov,
  * were successfully copied.  If a fault is encountered then return the number
  * of bytes which were copied.
  */
-size_t iov_iter_copy_from_user_atomic(struct page *page,
+static size_t ii_iovec_copy_from_user_atomic(struct page *page,
 		struct iov_iter *i, unsigned long offset, size_t bytes)
 {
+	struct iovec *iov = (struct iovec *)i->data;
 	char *kaddr;
 	size_t copied;
 
@@ -136,11 +135,11 @@ size_t iov_iter_copy_from_user_atomic(struct page *page,
 	kaddr = kmap_atomic(page);
 	if (likely(i->nr_segs == 1)) {
 		int left;
-		char __user *buf = i->iov->iov_base + i->iov_offset;
+		char __user *buf = iov->iov_base + i->iov_offset;
 		left = __copy_from_user_inatomic(kaddr + offset, buf, bytes);
 		copied = bytes - left;
 	} else {
-		copied = __iovec_copy_from_user(kaddr + offset, i->iov,
+		copied = __iovec_copy_from_user(kaddr + offset, iov,
 						i->iov_offset, bytes, 1);
 	}
 	kunmap_atomic(kaddr);
@@ -151,32 +150,32 @@ EXPORT_SYMBOL(iov_iter_copy_from_user_atomic);
 
 /*
  * This has the same sideeffects and return value as
- * iov_iter_copy_from_user_atomic().
+ * ii_iovec_copy_from_user_atomic().
  * The difference is that it attempts to resolve faults.
  * Page must not be locked.
  */
-size_t iov_iter_copy_from_user(struct page *page,
+static size_t ii_iovec_copy_from_user(struct page *page,
 		struct iov_iter *i, unsigned long offset, size_t bytes)
 {
+	struct iovec *iov = (struct iovec *)i->data;
 	char *kaddr;
 	size_t copied;
 
 	kaddr = kmap(page);
 	if (likely(i->nr_segs == 1)) {
 		int left;
-		char __user *buf = i->iov->iov_base + i->iov_offset;
+		char __user *buf = iov->iov_base + i->iov_offset;
 		left = __copy_from_user(kaddr + offset, buf, bytes);
 		copied = bytes - left;
 	} else {
-		copied = __iovec_copy_from_user(kaddr + offset, i->iov,
+		copied = __iovec_copy_from_user(kaddr + offset, iov,
 						i->iov_offset, bytes, 0);
 	}
 	kunmap(page);
 	return copied;
 }
-EXPORT_SYMBOL(iov_iter_copy_from_user);
 
-void iov_iter_advance(struct iov_iter *i, size_t bytes)
+static void ii_iovec_advance(struct iov_iter *i, size_t bytes)
 {
 	BUG_ON(i->count < bytes);
 
@@ -184,7 +183,7 @@ void iov_iter_advance(struct iov_iter *i, size_t bytes)
 		i->iov_offset += bytes;
 		i->count -= bytes;
 	} else {
-		const struct iovec *iov = i->iov;
+		struct iovec *iov = (struct iovec *)i->data;
 		size_t base = i->iov_offset;
 		unsigned long nr_segs = i->nr_segs;
 
@@ -206,12 +205,11 @@ void iov_iter_advance(struct iov_iter *i, size_t bytes)
 				base = 0;
 			}
 		}
-		i->iov = iov;
+		i->data = (unsigned long)iov;
 		i->iov_offset = base;
 		i->nr_segs = nr_segs;
 	}
 }
-EXPORT_SYMBOL(iov_iter_advance);
 
 /*
  * Fault in the first iovec of the given iov_iter, to a maximum length
@@ -222,23 +220,33 @@ EXPORT_SYMBOL(iov_iter_advance);
  * would be possible (callers must not rely on the fact that _only_ the
  * first iovec will be faulted with the current implementation).
  */
-int iov_iter_fault_in_readable(struct iov_iter *i, size_t bytes)
+static int ii_iovec_fault_in_readable(struct iov_iter *i, size_t bytes)
 {
-	char __user *buf = i->iov->iov_base + i->iov_offset;
-	bytes = min(bytes, i->iov->iov_len - i->iov_offset);
+	struct iovec *iov = (struct iovec *)i->data;
+	char __user *buf = iov->iov_base + i->iov_offset;
+	bytes = min(bytes, iov->iov_len - i->iov_offset);
 	return fault_in_pages_readable(buf, bytes);
 }
-EXPORT_SYMBOL(iov_iter_fault_in_readable);
 
 /*
  * Return the count of just the current iov_iter segment.
  */
-size_t iov_iter_single_seg_count(const struct iov_iter *i)
+static size_t ii_iovec_single_seg_count(const struct iov_iter *i)
 {
-	const struct iovec *iov = i->iov;
+	const struct iovec *iov = (struct iovec *)i->data;
 	if (i->nr_segs == 1)
 		return i->count;
 	else
 		return min(i->count, iov->iov_len - i->iov_offset);
 }
-EXPORT_SYMBOL(iov_iter_single_seg_count);
+
+struct iov_iter_ops ii_iovec_ops = {
+	.ii_copy_to_user_atomic = ii_iovec_copy_to_user_atomic,
+	.ii_copy_to_user = ii_iovec_copy_to_user,
+	.ii_copy_from_user_atomic = ii_iovec_copy_from_user_atomic,
+	.ii_copy_from_user = ii_iovec_copy_from_user,
+	.ii_advance = ii_iovec_advance,
+	.ii_fault_in_readable = ii_iovec_fault_in_readable,
+	.ii_single_seg_count = ii_iovec_single_seg_count,
+};
+EXPORT_SYMBOL(ii_iovec_ops);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3e60370..b1dff8a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -289,31 +289,73 @@ struct address_space;
 struct writeback_control;
 
 struct iov_iter {
-	const struct iovec *iov;
+	struct iov_iter_ops *ops;
+	unsigned long data;
 	unsigned long nr_segs;
 	size_t iov_offset;
 	size_t count;
 };
 
-size_t __iov_iter_copy_to_user_atomic(struct page *page,
-		struct iov_iter *i, unsigned long offset, size_t bytes);
-size_t __iov_iter_copy_to_user(struct page *page,
-		struct iov_iter *i, unsigned long offset, size_t bytes);
-size_t iov_iter_copy_to_user(struct page *page,
-		struct iov_iter *i, unsigned long offset, size_t bytes);
-size_t iov_iter_copy_from_user_atomic(struct page *page,
-		struct iov_iter *i, unsigned long offset, size_t bytes);
-size_t iov_iter_copy_from_user(struct page *page,
-		struct iov_iter *i, unsigned long offset, size_t bytes);
-void iov_iter_advance(struct iov_iter *i, size_t bytes);
-int iov_iter_fault_in_readable(struct iov_iter *i, size_t bytes);
-size_t iov_iter_single_seg_count(const struct iov_iter *i);
+struct iov_iter_ops {
+	size_t (*ii_copy_to_user_atomic)(struct page *, struct iov_iter *,
+					 unsigned long, size_t);
+	size_t (*ii_copy_to_user)(struct page *, struct iov_iter *,
+				  unsigned long, size_t, int);
+	size_t (*ii_copy_from_user_atomic)(struct page *, struct iov_iter *,
+					   unsigned long, size_t);
+	size_t (*ii_copy_from_user)(struct page *, struct iov_iter *,
+					  unsigned long, size_t);
+	void (*ii_advance)(struct iov_iter *, size_t);
+	int (*ii_fault_in_readable)(struct iov_iter *, size_t);
+	size_t (*ii_single_seg_count)(const struct iov_iter *);
+};
+
+static inline size_t iov_iter_copy_to_user_atomic(struct page *page,
+		struct iov_iter *i, unsigned long offset, size_t bytes)
+{
+	return i->ops->ii_copy_to_user_atomic(page, i, offset, bytes);
+}
+static inline size_t __iov_iter_copy_to_user(struct page *page,
+		struct iov_iter *i, unsigned long offset, size_t bytes)
+{
+	return i->ops->ii_copy_to_user(page, i, offset, bytes, 0);
+}
+static inline size_t iov_iter_copy_to_user(struct page *page,
+		struct iov_iter *i, unsigned long offset, size_t bytes)
+{
+	return i->ops->ii_copy_to_user(page, i, offset, bytes, 1);
+}
+static inline size_t iov_iter_copy_from_user_atomic(struct page *page,
+		struct iov_iter *i, unsigned long offset, size_t bytes)
+{
+	return i->ops->ii_copy_from_user_atomic(page, i, offset, bytes);
+}
+static inline size_t iov_iter_copy_from_user(struct page *page,
+		struct iov_iter *i, unsigned long offset, size_t bytes)
+{
+	return i->ops->ii_copy_from_user(page, i, offset, bytes);
+}
+static inline void iov_iter_advance(struct iov_iter *i, size_t bytes)
+{
+	return i->ops->ii_advance(i, bytes);
+}
+static inline int iov_iter_fault_in_readable(struct iov_iter *i, size_t bytes)
+{
+	return i->ops->ii_fault_in_readable(i, bytes);
+}
+static inline size_t iov_iter_single_seg_count(const struct iov_iter *i)
+{
+	return i->ops->ii_single_seg_count(i);
+}
+
+extern struct iov_iter_ops ii_iovec_ops;
 
 static inline void iov_iter_init(struct iov_iter *i,
 			const struct iovec *iov, unsigned long nr_segs,
 			size_t count, size_t written)
 {
-	i->iov = iov;
+	i->ops = &ii_iovec_ops;
+	i->data = (unsigned long)iov;
 	i->nr_segs = nr_segs;
 	i->iov_offset = 0;
 	i->count = count + written;
@@ -321,6 +363,11 @@ static inline void iov_iter_init(struct iov_iter *i,
 	iov_iter_advance(i, written);
 }
 
+static inline struct iovec *iov_iter_iovec(struct iov_iter *i)
+{
+	return (struct iovec *)i->data;
+}
+
 static inline size_t iov_iter_count(struct iov_iter *i)
 {
 	return i->count;
-- 
1.8.1.5

