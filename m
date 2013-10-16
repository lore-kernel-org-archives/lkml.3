Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934590Ab3JPOFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:05:52 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:26562 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934350Ab3JPOFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:05:48 -0400
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, Christoph Hellwig <hch@infradead.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH V9 02/33] iov_iter: iov_iter_copy_from_user() should use non-atomic copy
Date: Wed, 16 Oct 2013 09:04:15 -0500
Message-Id: <1381932286-14978-3-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381932286-14978-1-git-send-email-dave.kleikamp@oracle.com>
References: <1381932286-14978-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
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
1.8.4

