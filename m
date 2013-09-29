Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab3I2Jic (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 05:38:32 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:44427 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3I2JiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 05:38:18 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] vfs: Get rid of duplicate file_ops check in do_readv_writev()
Date: Sun, 29 Sep 2013 18:37:50 +0900
Message-Id: <1380447470-2811-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1380447470-2811-1-git-send-email-namhyung@kernel.org>
References: <1380447470-2811-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file->f_op check in do_readv_writev() is redundant since all of
its caller (vfs_readv and vfs_writev) already did the check.  The
same goes to compat_do_readv_writev().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 fs/read_write.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 878f40e50451..a8bcdd26b16e 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -721,11 +721,6 @@ static ssize_t do_readv_writev(int type, struct file *file,
 	io_fn_t fn;
 	iov_fn_t fnv;
 
-	if (!file->f_op) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	ret = rw_copy_check_uvector(type, uvector, nr_segs,
 				    ARRAY_SIZE(iovstack), iovstack, &iov);
 	if (ret <= 0)
@@ -894,10 +889,6 @@ static ssize_t compat_do_readv_writev(int type, struct file *file,
 	io_fn_t fn;
 	iov_fn_t fnv;
 
-	ret = -EINVAL;
-	if (!file->f_op)
-		goto out;
-
 	ret = -EFAULT;
 	if (!access_ok(VERIFY_READ, uvector, nr_segs*sizeof(*uvector)))
 		goto out;
-- 
1.7.9.2

