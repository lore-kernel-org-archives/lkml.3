Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933968Ab3CHW6O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 17:58:14 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:30403 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758070Ab3CHWwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 17:52:46 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: Zach Brown <zab@zabbo.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH V7 -next 07/33] iov_iter: ii_iovec_copy_to_user should pre-fault user pages
Date: Fri,  8 Mar 2013 16:52:02 -0600
Message-Id: <1362783148-22736-8-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1362783148-22736-1-git-send-email-dave.kleikamp@oracle.com>
References: <1362783148-22736-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This duplicates the optimization in file_read_actor as a later patch
will replace it with a call to __iov_iter_copy_to_user().

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
---
 fs/iov-iter.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/iov-iter.c b/fs/iov-iter.c
index 6cb6be0..59f9556 100644
--- a/fs/iov-iter.c
+++ b/fs/iov-iter.c
@@ -80,17 +80,32 @@ static size_t ii_iovec_copy_to_user(struct page *page,
 			return 0;
 	}
 
-	kaddr = kmap(page);
 	if (likely(i->nr_segs == 1)) {
 		int left;
 		char __user *buf = iov->iov_base + i->iov_offset;
+		/*
+		 * Faults on the destination of a read are common, so do it
+		 * before taking the kmap.
+		 */
+		if (!fault_in_pages_writeable(buf, bytes)) {
+			kaddr = kmap_atomic(page);
+			left = __copy_to_user_inatomic(buf, kaddr + offset,
+						     bytes);
+			kunmap_atomic(kaddr);
+			if (left == 0)
+				goto success;
+		}
+		kaddr = kmap(page);
 		left = copy_to_user(buf, kaddr + offset, bytes);
+		kunmap(page);
+success:
 		copied = bytes - left;
 	} else {
+		kaddr = kmap(page);
 		copied = __iovec_copy_to_user(kaddr + offset, iov,
 					      i->iov_offset, bytes, 0);
+		kunmap(page);
 	}
-	kunmap(page);
 	return copied;
 }
 
-- 
1.8.1.5

