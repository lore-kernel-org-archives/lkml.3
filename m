Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaE0Ol3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 10:41:29 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56209 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbaE0Ol0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 10:41:26 -0400
Date: Tue, 27 May 2014 16:41:16 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] vfs: fix vmplice_to_user()
Message-ID: <20140527144116.GK17233@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Commit 6130f5315ee8 "switch vmsplice_to_user() to copy_page_to_iter()" in
v3.15-rc1 broke vmsplice(2).

This patch fixes two bugs:

 - count is not initialized to a proper value, which resulted in no data
   being copied

 - if rw_copy_check_uvector() returns negative then the iov might be leaked.

Tested OK.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/splice.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1537,7 +1537,7 @@ static long vmsplice_to_user(struct file
 	struct iovec iovstack[UIO_FASTIOV];
 	struct iovec *iov = iovstack;
 	struct iov_iter iter;
-	ssize_t count = 0;
+	ssize_t count;
 
 	pipe = get_pipe_info(file);
 	if (!pipe)
@@ -1546,8 +1546,9 @@ static long vmsplice_to_user(struct file
 	ret = rw_copy_check_uvector(READ, uiov, nr_segs,
 				    ARRAY_SIZE(iovstack), iovstack, &iov);
 	if (ret <= 0)
-		return ret;
+		goto out;
 
+	count = ret;
 	iov_iter_init(&iter, iov, nr_segs, count, 0);
 
 	sd.len = 0;
@@ -1560,6 +1561,7 @@ static long vmsplice_to_user(struct file
 	ret = __splice_from_pipe(pipe, &sd, pipe_to_user);
 	pipe_unlock(pipe);
 
+out:
 	if (iov != iovstack)
 		kfree(iov);
 
