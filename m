Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933597Ab3CHWyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 17:54:14 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:30468 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759957Ab3CHWwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 17:52:55 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: Zach Brown <zab@zabbo.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        fuse-devel@lists.sourceforge.net
Subject: [PATCH V7 -next 05/33] fuse: convert fuse to use iov_iter_copy_[to|from]_user
Date: Fri,  8 Mar 2013 16:52:00 -0600
Message-Id: <1362783148-22736-6-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1362783148-22736-1-git-send-email-dave.kleikamp@oracle.com>
References: <1362783148-22736-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
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
index f2ae8fd..6d5f1ed 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1733,30 +1733,17 @@ static int fuse_ioctl_copy_user(struct page **pages, struct iovec *iov,
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
1.8.1.5

