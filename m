Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201Ab3CHWwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 17:52:50 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36009 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510Ab3CHWwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 17:52:45 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: Zach Brown <zab@zabbo.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH V7 -next 02/33] iov_iter: iov_iter_copy_from_user() should use non-atomic copy
Date: Fri,  8 Mar 2013 16:51:57 -0600
Message-Id: <1362783148-22736-3-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1362783148-22736-1-git-send-email-dave.kleikamp@oracle.com>
References: <1362783148-22736-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
---
 fs/iov-iter.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/iov-iter.c b/fs/iov-iter.c
index 52c23d9..563a6ba 100644
--- a/fs/iov-iter.c
+++ b/fs/iov-iter.c
@@ -6,8 +6,8 @@
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
 
-static size_t __iovec_copy_from_user_inatomic(char *vaddr,
-			const struct iovec *iov, size_t base, size_t bytes)
+static size_t __iovec_copy_from_user(char *vaddr, const struct iovec *iov,
+				     size_t base, size_t bytes, int atomic)
 {
 	size_t copied = 0, left = 0;
 
@@ -16,7 +16,10 @@ static size_t __iovec_copy_from_user_inatomic(char *vaddr,
 		int copy = min(bytes, iov->iov_len - base);
 
 		base = 0;
-		left = __copy_from_user_inatomic(vaddr, buf, copy);
+		if (atomic)
+			left = __copy_from_user_inatomic(vaddr, buf, copy);
+		else
+			left = __copy_from_user(vaddr, buf, copy);
 		copied += copy;
 		bytes -= copy;
 		vaddr += copy;
@@ -47,8 +50,8 @@ size_t iov_iter_copy_from_user_atomic(struct page *page,
 		left = __copy_from_user_inatomic(kaddr + offset, buf, bytes);
 		copied = bytes - left;
 	} else {
-		copied = __iovec_copy_from_user_inatomic(kaddr + offset,
-						i->iov, i->iov_offset, bytes);
+		copied = __iovec_copy_from_user(kaddr + offset, i->iov,
+						i->iov_offset, bytes, 1);
 	}
 	kunmap_atomic(kaddr);
 
@@ -75,8 +78,8 @@ size_t iov_iter_copy_from_user(struct page *page,
 		left = __copy_from_user(kaddr + offset, buf, bytes);
 		copied = bytes - left;
 	} else {
-		copied = __iovec_copy_from_user_inatomic(kaddr + offset,
-						i->iov, i->iov_offset, bytes);
+		copied = __iovec_copy_from_user(kaddr + offset, i->iov,
+						i->iov_offset, bytes, 0);
 	}
 	kunmap(page);
 	return copied;
-- 
1.8.1.5

