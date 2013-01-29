Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab3A2Qco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 11:32:44 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:19983 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab3A2QY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 11:24:26 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH V6 02/30] iov_iter: iov_iter_copy_from_user() should use non-atomic copy
Date: Tue, 29 Jan 2013 10:23:15 -0600
Message-Id: <1359476623-10544-3-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359476623-10544-1-git-send-email-dave.kleikamp@oracle.com>
References: <1359476623-10544-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
---
 fs/iov-iter.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/iov-iter.c b/fs/iov-iter.c
index 83f7594..5c4f3a5 100644
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
1.8.1.1

