Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab3GYRwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:52:07 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:19804 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854Ab3GYRvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:51:54 -0400
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH V8 04/33] iov_iter: add __iovec_copy_to_user()
Date: Thu, 25 Jul 2013 12:50:30 -0500
Message-Id: <1374774659-13121-5-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds __iovec_copy_to_user() which doesn't verify write access
to the user memory to be called from code where that verification has
already been done.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
---
 fs/iov-iter.c      | 14 ++++++++++++--
 include/linux/fs.h |  4 +++-
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/iov-iter.c b/fs/iov-iter.c
index 0b2407e..6cecab4 100644
--- a/fs/iov-iter.c
+++ b/fs/iov-iter.c
@@ -19,7 +19,7 @@ static size_t __iovec_copy_to_user(char *vaddr, const struct iovec *iov,
 		if (atomic)
 			left = __copy_to_user_inatomic(buf, vaddr, copy);
 		else
-			left = copy_to_user(buf, vaddr, copy);
+			left = __copy_to_user(buf, vaddr, copy);
 		copied += copy;
 		bytes -= copy;
 		vaddr += copy;
@@ -65,7 +65,7 @@ EXPORT_SYMBOL(iov_iter_copy_to_user_atomic);
  * The difference is that it attempts to resolve faults.
  * Page must not be locked.
  */
-size_t iov_iter_copy_to_user(struct page *page,
+size_t __iov_iter_copy_to_user(struct page *page,
 		struct iov_iter *i, unsigned long offset, size_t bytes)
 {
 	char *kaddr;
@@ -84,6 +84,16 @@ size_t iov_iter_copy_to_user(struct page *page,
 	kunmap(page);
 	return copied;
 }
+EXPORT_SYMBOL(__iov_iter_copy_to_user);
+
+size_t iov_iter_copy_to_user(struct page *page,
+		struct iov_iter *i, unsigned long offset, size_t bytes)
+{
+	might_sleep();
+	if (generic_segment_checks(i->iov, &i->nr_segs, &bytes, VERIFY_WRITE))
+		return 0;
+	return __iov_iter_copy_to_user(page, i, offset, bytes);
+}
 EXPORT_SYMBOL(iov_iter_copy_to_user);
 
 static size_t __iovec_copy_from_user(char *vaddr, const struct iovec *iov,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 80f71df..bfc6eb0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -296,7 +296,9 @@ struct iov_iter {
 	size_t count;
 };
 
-size_t iov_iter_copy_to_user_atomic(struct page *page,
+size_t __iov_iter_copy_to_user_atomic(struct page *page,
+		struct iov_iter *i, unsigned long offset, size_t bytes);
+size_t __iov_iter_copy_to_user(struct page *page,
 		struct iov_iter *i, unsigned long offset, size_t bytes);
 size_t iov_iter_copy_to_user(struct page *page,
 		struct iov_iter *i, unsigned long offset, size_t bytes);
-- 
1.8.3.4

