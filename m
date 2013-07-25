Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab3GYSEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:04:31 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:19892 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972Ab3GYRwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:52:02 -0400
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, Dave Kleikamp <dave.kleikamp@oracle.com>,
        fuse-devel@lists.sourceforge.net
Subject: [PATCH V8 05/33] fuse: convert fuse to use iov_iter_copy_[to|from]_user
Date: Thu, 25 Jul 2013 12:50:31 -0500
Message-Id: <1374774659-13121-6-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A future patch hides the internals of struct iov_iter, so fuse should
be using the supported interface.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Acked-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: fuse-devel@lists.sourceforge.net
---
 fs/fuse/file.c | 29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 5c121fe..633766c 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1861,30 +1861,17 @@ static int fuse_ioctl_copy_user(struct page **pages, struct iovec *iov,
 	while (iov_iter_count(&ii)) {
 		struct page *page = pages[page_idx++];
 		size_t todo = min_t(size_t, PAGE_SIZE, iov_iter_count(&ii));
-		void *kaddr;
+		size_t left;
 
-		kaddr = kmap(page);
-
-		while (todo) {
-			char __user *uaddr = ii.iov->iov_base + ii.iov_offset;
-			size_t iov_len = ii.iov->iov_len - ii.iov_offset;
-			size_t copy = min(todo, iov_len);
-			size_t left;
-
-			if (!to_user)
-				left = copy_from_user(kaddr, uaddr, copy);
-			else
-				left = copy_to_user(uaddr, kaddr, copy);
-
-			if (unlikely(left))
-				return -EFAULT;
+		if (!to_user)
+			left = iov_iter_copy_from_user(page, &ii, 0, todo);
+		else
+			left = iov_iter_copy_to_user(page, &ii, 0, todo);
 
-			iov_iter_advance(&ii, copy);
-			todo -= copy;
-			kaddr += copy;
-		}
+		if (unlikely(left))
+			return -EFAULT;
 
-		kunmap(page);
+		iov_iter_advance(&ii, todo);
 	}
 
 	return 0;
-- 
1.8.3.4

