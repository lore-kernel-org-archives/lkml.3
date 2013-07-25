Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab3GYSKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:10:45 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43368 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab3GYRv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:51:56 -0400
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH V8 03/33] iov_iter: add copy_to_user support
Date: Thu, 25 Jul 2013 12:50:29 -0500
Message-Id: <1374774659-13121-4-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zach Brown <zab@zabbo.net>

This adds iov_iter wrappers around copy_to_user() to match the existing
wrappers around copy_from_user().

This will be used by the generic file system buffered read path.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
---
 fs/iov-iter.c      | 80 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |  4 +++
 2 files changed, 84 insertions(+)

diff --git a/fs/iov-iter.c b/fs/iov-iter.c
index 563a6ba..0b2407e 100644
--- a/fs/iov-iter.c
+++ b/fs/iov-iter.c
@@ -6,6 +6,86 @@
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
 
+static size_t __iovec_copy_to_user(char *vaddr, const struct iovec *iov,
+				   size_t base, size_t bytes, int atomic)
+{
+	size_t copied = 0, left = 0;
+
+	while (bytes) {
+		char __user *buf = iov->iov_base + base;
+		int copy = min(bytes, iov->iov_len - base);
+
+		base = 0;
+		if (atomic)
+			left = __copy_to_user_inatomic(buf, vaddr, copy);
+		else
+			left = copy_to_user(buf, vaddr, copy);
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
+ * were sucessfully copied.  If a fault is encountered then return the number of
+ * bytes which were copied.
+ */
+size_t iov_iter_copy_to_user_atomic(struct page *page,
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
+		left = __copy_to_user_inatomic(buf, kaddr + offset, bytes);
+		copied = bytes - left;
+	} else {
+		copied = __iovec_copy_to_user(kaddr + offset, i->iov,
+					      i->iov_offset, bytes, 1);
+	}
+	kunmap_atomic(kaddr);
+
+	return copied;
+}
+EXPORT_SYMBOL(iov_iter_copy_to_user_atomic);
+
+/*
+ * This has the same sideeffects and return value as
+ * iov_iter_copy_to_user_atomic().
+ * The difference is that it attempts to resolve faults.
+ * Page must not be locked.
+ */
+size_t iov_iter_copy_to_user(struct page *page,
+		struct iov_iter *i, unsigned long offset, size_t bytes)
+{
+	char *kaddr;
+	size_t copied;
+
+	kaddr = kmap(page);
+	if (likely(i->nr_segs == 1)) {
+		int left;
+		char __user *buf = i->iov->iov_base + i->iov_offset;
+		left = copy_to_user(buf, kaddr + offset, bytes);
+		copied = bytes - left;
+	} else {
+		copied = __iovec_copy_to_user(kaddr + offset, i->iov,
+					      i->iov_offset, bytes, 0);
+	}
+	kunmap(page);
+	return copied;
+}
+EXPORT_SYMBOL(iov_iter_copy_to_user);
+
 static size_t __iovec_copy_from_user(char *vaddr, const struct iovec *iov,
 				     size_t base, size_t bytes, int atomic)
 {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9818747..80f71df 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -296,6 +296,10 @@ struct iov_iter {
 	size_t count;
 };
 
+size_t iov_iter_copy_to_user_atomic(struct page *page,
+		struct iov_iter *i, unsigned long offset, size_t bytes);
+size_t iov_iter_copy_to_user(struct page *page,
+		struct iov_iter *i, unsigned long offset, size_t bytes);
 size_t iov_iter_copy_from_user_atomic(struct page *page,
 		struct iov_iter *i, unsigned long offset, size_t bytes);
 size_t iov_iter_copy_from_user(struct page *page,
-- 
1.8.3.4

