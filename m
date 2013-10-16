Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935082Ab3JPOSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:18:23 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:26516 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934379Ab3JPOFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:05:44 -0400
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, Christoph Hellwig <hch@infradead.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH V9 01/33] iov_iter: move into its own file
Date: Wed, 16 Oct 2013 09:04:14 -0500
Message-Id: <1381932286-14978-2-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381932286-14978-1-git-send-email-dave.kleikamp@oracle.com>
References: <1381932286-14978-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@zabbo.net>

This moves the iov_iter functions in to their own file.  We're going to
be working on them in upcoming patches.  They become sufficiently large,
and remain self-contained, to justify seperating them from the rest of
the huge mm/filemap.c.

Signed-off-by: Zach Brown <zab@zabbo.net>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 fs/Makefile   |   2 +-
 fs/iov-iter.c | 151 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/filemap.c  | 144 -------------------------------------------------------
 3 files changed, 152 insertions(+), 145 deletions(-)
 create mode 100644 fs/iov-iter.c

diff --git a/fs/Makefile b/fs/Makefile
index 4fe6df3..1afa0e0 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -11,7 +11,7 @@ obj-y :=	open.o read_write.o file_table.o super.o \
 		attr.o bad_inode.o file.o filesystems.o namespace.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o splice.o sync.o utimes.o \
-		stack.o fs_struct.o statfs.o
+		stack.o fs_struct.o statfs.o iov-iter.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
diff --git a/fs/iov-iter.c b/fs/iov-iter.c
new file mode 100644
index 0000000..52c23d9
--- /dev/null
+++ b/fs/iov-iter.c
@@ -0,0 +1,151 @@
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/uaccess.h>
+#include <linux/uio.h>
+#include <linux/hardirq.h>
+#include <linux/highmem.h>
+#include <linux/pagemap.h>
+
+static size_t __iovec_copy_from_user_inatomic(char *vaddr,
+			const struct iovec *iov, size_t base, size_t bytes)
+{
+	size_t copied = 0, left = 0;
+
+	while (bytes) {
+		char __user *buf = iov->iov_base + base;
+		int copy = min(bytes, iov->iov_len - base);
+
+		base = 0;
+		left = __copy_from_user_inatomic(vaddr, buf, copy);
+		copied += copy;
+		bytes -= copy;
+		vaddr += copy;
+		iov++;
+
+		if (unlikely(left))
+			break;
+	}
+	return copied - left;
+}
+
+/*
+ * Copy as much as we can into the page and return the number of bytes which
+ * were successfully copied.  If a fault is encountered then return the number
+ * of bytes which were copied.
+ */
+size_t iov_iter_copy_from_user_atomic(struct page *page,
+		struct iov_iter *i, unsigned long offset, size_t bytes)
+{
+	char *kaddr;
+	size_t copied;
+
+	BUG_ON(!in_atomic());
+	kaddr = kmap_atomic(page);
+	if (likely(i->nr_segs == 1)) {
+		int left;
+		char __user *buf = i->iov->iov_base + i->iov_offset;
+		left = __copy_from_user_inatomic(kaddr + offset, buf, bytes);
+		copied = bytes - left;
+	} else {
+		copied = __iovec_copy_from_user_inatomic(kaddr + offset,
+						i->iov, i->iov_offset, bytes);
+	}
+	kunmap_atomic(kaddr);
+
+	return copied;
+}
+EXPORT_SYMBOL(iov_iter_copy_from_user_atomic);
+
+/*
+ * This has the same sideeffects and return value as
+ * iov_iter_copy_from_user_atomic().
+ * The difference is that it attempts to resolve faults.
+ * Page must not be locked.
+ */
+size_t iov_iter_copy_from_user(struct page *page,
+		struct iov_iter *i, unsigned long offset, size_t bytes)
+{
+	char *kaddr;
+	size_t copied;
+
+	kaddr = kmap(page);
+	if (likely(i->nr_segs == 1)) {
+		int left;
+		char __user *buf = i->iov->iov_base + i->iov_offset;
+		left = __copy_from_user(kaddr + offset, buf, bytes);
+		copied = bytes - left;
+	} else {
+		copied = __iovec_copy_from_user_inatomic(kaddr + offset,
+						i->iov, i->iov_offset, bytes);
+	}
+	kunmap(page);
+	return copied;
+}
+EXPORT_SYMBOL(iov_iter_copy_from_user);
+
+void iov_iter_advance(struct iov_iter *i, size_t bytes)
+{
+	BUG_ON(i->count < bytes);
+
+	if (likely(i->nr_segs == 1)) {
+		i->iov_offset += bytes;
+		i->count -= bytes;
+	} else {
+		const struct iovec *iov = i->iov;
+		size_t base = i->iov_offset;
+		unsigned long nr_segs = i->nr_segs;
+
+		/*
+		 * The !iov->iov_len check ensures we skip over unlikely
+		 * zero-length segments (without overruning the iovec).
+		 */
+		while (bytes || unlikely(i->count && !iov->iov_len)) {
+			int copy;
+
+			copy = min(bytes, iov->iov_len - base);
+			BUG_ON(!i->count || i->count < copy);
+			i->count -= copy;
+			bytes -= copy;
+			base += copy;
+			if (iov->iov_len == base) {
+				iov++;
+				nr_segs--;
+				base = 0;
+			}
+		}
+		i->iov = iov;
+		i->iov_offset = base;
+		i->nr_segs = nr_segs;
+	}
+}
+EXPORT_SYMBOL(iov_iter_advance);
+
+/*
+ * Fault in the first iovec of the given iov_iter, to a maximum length
+ * of bytes. Returns 0 on success, or non-zero if the memory could not be
+ * accessed (ie. because it is an invalid address).
+ *
+ * writev-intensive code may want this to prefault several iovecs -- that
+ * would be possible (callers must not rely on the fact that _only_ the
+ * first iovec will be faulted with the current implementation).
+ */
+int iov_iter_fault_in_readable(struct iov_iter *i, size_t bytes)
+{
+	char __user *buf = i->iov->iov_base + i->iov_offset;
+	bytes = min(bytes, i->iov->iov_len - i->iov_offset);
+	return fault_in_pages_readable(buf, bytes);
+}
+EXPORT_SYMBOL(iov_iter_fault_in_readable);
+
+/*
+ * Return the count of just the current iov_iter segment.
+ */
+size_t iov_iter_single_seg_count(const struct iov_iter *i)
+{
+	const struct iovec *iov = i->iov;
+	if (i->nr_segs == 1)
+		return i->count;
+	else
+		return min(i->count, iov->iov_len - i->iov_offset);
+}
+EXPORT_SYMBOL(iov_iter_single_seg_count);
diff --git a/mm/filemap.c b/mm/filemap.c
index 1e6aec4..e652863 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1952,150 +1952,6 @@ struct page *read_cache_page(struct address_space *mapping,
 }
 EXPORT_SYMBOL(read_cache_page);
 
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
-size_t iov_iter_copy_from_user_atomic(struct page *page,
-		struct iov_iter *i, unsigned long offset, size_t bytes)
-{
-	char *kaddr;
-	size_t copied;
-
-	BUG_ON(!in_atomic());
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
-EXPORT_SYMBOL(iov_iter_copy_from_user_atomic);
-
-/*
- * This has the same sideeffects and return value as
- * iov_iter_copy_from_user_atomic().
- * The difference is that it attempts to resolve faults.
- * Page must not be locked.
- */
-size_t iov_iter_copy_from_user(struct page *page,
-		struct iov_iter *i, unsigned long offset, size_t bytes)
-{
-	char *kaddr;
-	size_t copied;
-
-	kaddr = kmap(page);
-	if (likely(i->nr_segs == 1)) {
-		int left;
-		char __user *buf = i->iov->iov_base + i->iov_offset;
-		left = __copy_from_user(kaddr + offset, buf, bytes);
-		copied = bytes - left;
-	} else {
-		copied = __iovec_copy_from_user_inatomic(kaddr + offset,
-						i->iov, i->iov_offset, bytes);
-	}
-	kunmap(page);
-	return copied;
-}
-EXPORT_SYMBOL(iov_iter_copy_from_user);
-
-void iov_iter_advance(struct iov_iter *i, size_t bytes)
-{
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
-}
-EXPORT_SYMBOL(iov_iter_advance);
-
-/*
- * Fault in the first iovec of the given iov_iter, to a maximum length
- * of bytes. Returns 0 on success, or non-zero if the memory could not be
- * accessed (ie. because it is an invalid address).
- *
- * writev-intensive code may want this to prefault several iovecs -- that
- * would be possible (callers must not rely on the fact that _only_ the
- * first iovec will be faulted with the current implementation).
- */
-int iov_iter_fault_in_readable(struct iov_iter *i, size_t bytes)
-{
-	char __user *buf = i->iov->iov_base + i->iov_offset;
-	bytes = min(bytes, i->iov->iov_len - i->iov_offset);
-	return fault_in_pages_readable(buf, bytes);
-}
-EXPORT_SYMBOL(iov_iter_fault_in_readable);
-
-/*
- * Return the count of just the current iov_iter segment.
- */
-size_t iov_iter_single_seg_count(const struct iov_iter *i)
-{
-	const struct iovec *iov = i->iov;
-	if (i->nr_segs == 1)
-		return i->count;
-	else
-		return min(i->count, iov->iov_len - i->iov_offset);
-}
-EXPORT_SYMBOL(iov_iter_single_seg_count);
-
 /*
  * Performs necessary checks before doing a write
  *
-- 
1.8.4

