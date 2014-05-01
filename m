Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaEADYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 23:24:08 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:57997 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaEADYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 23:24:05 -0400
From: Leon Yu <chianglungyu@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Leon Yu <chianglungyu@gmail.com>
Subject: [PATCH] splice: fix possible memory leak in vmsplice_to_user().
Date: Thu,  1 May 2014 03:22:57 +0000
Message-Id: <1398914577-8315-1-git-send-email-chianglungyu@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 6130f5315 ("switch vmsplice_to_user() to copy_page_to_iter()"),
rw_copy_check_uvector is used for sanity check, however, iov can be leaked if
that check failed.

So, fix it by handling this error path properly.

Signed-off-by: Leon Yu <chianglungyu@gmail.com>
---
 fs/splice.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/splice.c b/fs/splice.c
index 9bc07d2..b789328 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1546,7 +1546,7 @@ static long vmsplice_to_user(struct file *file, const struct iovec __user *uiov,
 	ret = rw_copy_check_uvector(READ, uiov, nr_segs,
 				    ARRAY_SIZE(iovstack), iovstack, &iov);
 	if (ret <= 0)
-		return ret;
+		goto out;
 
 	iov_iter_init(&iter, iov, nr_segs, count, 0);
 
@@ -1560,6 +1560,7 @@ static long vmsplice_to_user(struct file *file, const struct iovec __user *uiov,
 	ret = __splice_from_pipe(pipe, &sd, pipe_to_user);
 	pipe_unlock(pipe);
 
+out:
 	if (iov != iovstack)
 		kfree(iov);
 
-- 
1.9.2

