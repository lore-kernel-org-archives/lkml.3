Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934058Ab3CHXBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 18:01:22 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36021 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757067Ab3CHWwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 17:52:45 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: Zach Brown <zab@zabbo.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH V7 -next 04/33] iov_iter: add __iovec_copy_to_user()
Date: Fri,  8 Mar 2013 16:51:59 -0600
Message-Id: <1362783148-22736-5-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1362783148-22736-1-git-send-email-dave.kleikamp@oracle.com>
References: <1362783148-22736-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
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
index cd85051..3e60370 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -295,7 +295,9 @@ struct iov_iter {
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
1.8.1.5

