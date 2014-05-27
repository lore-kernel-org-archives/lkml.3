Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbaE0T0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 15:26:00 -0400
Received: from ns.horizon.com ([71.41.210.147]:40252 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752654AbaE0TZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 15:25:58 -0400
Date: 27 May 2014 15:25:56 -0400
Message-ID: <20140527192556.6555.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: viro@ZenIV.linux.org.uk
Subject: Re: [PATCH] vfs: fix vmplice_to_user()
Cc: linux@horizon.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, miklos@szeredi.hu,
        torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You could also get rid of the separate ret/count variables
and use ssize_t everywhere; that's the declared return type
of rw_copy_check_uvector and __splice_from_pipe, after all.

Hunks after the first two are optional extras to make types
consistent in other functions in that file, although I stopped
once I realized how big a job it owuld be to do it all.

Signed-off-by: George Spelvin <linux@horizon.com>

diff --git a/fs/splice.c b/fs/splice.c
index 6b111500..2fce8f44 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1534,18 +1534,17 @@ static long vmsplice_to_user(struct file *file, const struct iovec __user *uiov,
 	struct pipe_inode_info *pipe;
 	struct iovec iovstack[UIO_FASTIOV];
 	struct iovec *iov = iovstack;
-	long ret;
+	ssize_t count;
 
 	pipe = get_pipe_info(file);
 	if (!pipe)
 		return -EBADF;
 
-	ret = rw_copy_check_uvector(READ, uiov, nr_segs,
+	count = rw_copy_check_uvector(READ, uiov, nr_segs,
 				    ARRAY_SIZE(iovstack), iovstack, &iov);
-	if (ret > 0) {
+	if (count > 0) {
 		struct splice_desc sd;
 		struct iov_iter iter;
-		ssize_t count = ret;
 
 		iov_iter_init(&iter, iov, nr_segs, count, 0);
 
@@ -1556,14 +1555,14 @@ static long vmsplice_to_user(struct file *file, const struct iovec __user *uiov,
 		sd.pos = 0;
 
 		pipe_lock(pipe);
-		ret = __splice_from_pipe(pipe, &sd, pipe_to_user);
+		count = __splice_from_pipe(pipe, &sd, pipe_to_user);
 		pipe_unlock(pipe);
 	}
 
 	if (iov != iovstack)
 		kfree(iov);
 
-	return ret;
+	return count;
 }
 
 /*
@@ -1571,7 +1570,7 @@ static long vmsplice_to_user(struct file *file, const struct iovec __user *uiov,
  * as splice-from-memory, where the regular splice is splice-from-file (or
  * to file). In both cases the output is a pipe, naturally.
  */
-static long vmsplice_to_pipe(struct file *file, const struct iovec __user *iov,
+static ssize_t vmsplice_to_pipe(struct file *file, const struct iovec __user *iov,
 			     unsigned long nr_segs, unsigned int flags)
 {
 	struct pipe_inode_info *pipe;
@@ -1585,7 +1584,7 @@ static long vmsplice_to_pipe(struct file *file, const struct iovec __user *iov,
 		.ops = &user_page_pipe_buf_ops,
 		.spd_release = spd_release_page,
 	};
-	long ret;
+	ssize_t ret;
 
 	pipe = get_pipe_info(file);
 	if (!pipe)
@@ -1626,25 +1625,25 @@ SYSCALL_DEFINE4(vmsplice, int, fd, const struct iovec __user *, iov,
 		unsigned long, nr_segs, unsigned int, flags)
 {
 	struct fd f;
-	long error;
+	ssize_t ret;
 
 	if (unlikely(nr_segs > UIO_MAXIOV))
 		return -EINVAL;
 	else if (unlikely(!nr_segs))
 		return 0;
 
-	error = -EBADF;
+	ret = -EBADF;
 	f = fdget(fd);
 	if (f.file) {
 		if (f.file->f_mode & FMODE_WRITE)
-			error = vmsplice_to_pipe(f.file, iov, nr_segs, flags);
+			ret = vmsplice_to_pipe(f.file, iov, nr_segs, flags);
 		else if (f.file->f_mode & FMODE_READ)
-			error = vmsplice_to_user(f.file, iov, nr_segs, flags);
+			ret = vmsplice_to_user(f.file, iov, nr_segs, flags);
 
 		fdput(f);
 	}
 
-	return error;
+	return ret;
 }
 
 #ifdef CONFIG_COMPAT
