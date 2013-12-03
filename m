Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab3LCOvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:51:45 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:42845 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab3LCOvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:51:42 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 7/9] staging/lustre/llite: remove ll_file_get_iov_count
Date: Tue,  3 Dec 2013 22:42:06 +0800
Message-Id: <1386081729-9481-10-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386081729-9481-1-git-send-email-bergwolf@gmail.com>
References: <1386081729-9481-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It exactly copies generic_segment_checks() except wrongly calling
access_ok(VERIFY_READ) for aio read range. Drop it and just call
generic_segment_checks() instead.

Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/file.c |   36 ++--------------------------
 1 file changed, 2 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 8f03eb0..25442ac 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -1148,38 +1148,6 @@ out:
 	return result;
 }
 
-
-/*
- * XXX: exact copy from kernel code (__generic_file_aio_write_nolock)
- */
-static int ll_file_get_iov_count(const struct iovec *iov,
-				 unsigned long *nr_segs, size_t *count)
-{
-	size_t cnt = 0;
-	unsigned long seg;
-
-	for (seg = 0; seg < *nr_segs; seg++) {
-		const struct iovec *iv = &iov[seg];
-
-		/*
-		 * If any segment has a negative length, or the cumulative
-		 * length ever wraps negative then return -EINVAL.
-		 */
-		cnt += iv->iov_len;
-		if (unlikely((ssize_t)(cnt|iv->iov_len) < 0))
-			return -EINVAL;
-		if (access_ok(VERIFY_READ, iv->iov_base, iv->iov_len))
-			continue;
-		if (seg == 0)
-			return -EFAULT;
-		*nr_segs = seg;
-		cnt -= iv->iov_len;   /* This segment is no good */
-		break;
-	}
-	*count = cnt;
-	return 0;
-}
-
 static ssize_t ll_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 				unsigned long nr_segs, loff_t pos)
 {
@@ -1189,7 +1157,7 @@ static ssize_t ll_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 	ssize_t	     result;
 	int		 refcheck;
 
-	result = ll_file_get_iov_count(iov, &nr_segs, &count);
+	result = generic_segment_checks(iov, &nr_segs, &ocount, VERIFY_WRITE);
 	if (result)
 		return result;
 
@@ -1248,7 +1216,7 @@ static ssize_t ll_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	ssize_t	     result;
 	int		 refcheck;
 
-	result = ll_file_get_iov_count(iov, &nr_segs, &count);
+	result = generic_segment_checks(iov, &nr_segs, &ocount, VERIFY_READ);
 	if (result)
 		return result;
 
-- 
1.7.9.5

