Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbaIOUV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:21:59 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:60416 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854AbaIOUV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 16:21:56 -0400
From: Christoph Hellwig <milosz@adfin.com>
X-Google-Original-From: Christoph Hellwig <hch@lst.de>
Date: Mon, 15 Sep 2014 16:21:51 -0400
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 6/7] move flags enforcement to vfs_preadv/vfs_pwritev
Message-ID: <b7faca081076f52327690ebb7fecd1f1bf05a07c.1410810247.git.milosz@adfin.com>
References: <cover.1410810247.git.milosz@adfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1410810247.git.milosz@adfin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Milosz Tanski <milosz@adfin.com>
---
 fs/read_write.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 87a6034..233ea98 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -863,6 +863,8 @@ ssize_t vfs_readv(struct file *file, const struct iovec __user *vec,
 		return -EBADF;
 	if (!(file->f_mode & FMODE_CAN_READ))
 		return -EINVAL;
+	if (flags & ~O_NONBLOCK)
+		return -EINVAL;
 
 	return do_readv_writev(READ, file, vec, vlen, pos, flags);
 }
@@ -876,6 +878,8 @@ ssize_t vfs_writev(struct file *file, const struct iovec __user *vec,
 		return -EBADF;
 	if (!(file->f_mode & FMODE_CAN_WRITE))
 		return -EINVAL;
+	if (flags & ~0)
+		return -EINVAL;
 
 	return do_readv_writev(WRITE, file, vec, vlen, pos, flags);
 }
@@ -908,9 +912,6 @@ SYSCALL_DEFINE4(readv2, unsigned long, fd, const struct iovec __user *, vec,
 	struct fd f = fdget_pos(fd);
 	ssize_t ret = -EBADF;
 
-	if (flags & ~O_NONBLOCK)
-		return -EINVAL;
-
 	if (f.file) {
 		loff_t pos = file_pos_read(f.file);
 		ret = vfs_readv(f.file, vec, vlen, &pos, flags);
@@ -951,9 +952,6 @@ SYSCALL_DEFINE4(writev2, unsigned long, fd, const struct iovec __user *, vec,
 	struct fd f = fdget_pos(fd);
 	ssize_t ret = -EBADF;
 
-	if (flags & ~0)
-		return -EINVAL;
-
 	if (f.file) {
 		loff_t pos = file_pos_read(f.file);
 		ret = vfs_writev(f.file, vec, vlen, &pos, flags);
@@ -1006,8 +1004,6 @@ SYSCALL_DEFINE6(preadv2, unsigned long, fd, const struct iovec __user *, vec,
 	struct fd f;
 	ssize_t ret = -EBADF;
 
-	if (flags & ~O_NONBLOCK)
-		return -EINVAL;
 	if (pos < 0)
 		return -EINVAL;
 
@@ -1057,8 +1053,6 @@ SYSCALL_DEFINE6(pwritev2, unsigned long, fd, const struct iovec __user *, vec,
 	struct fd f;
 	ssize_t ret = -EBADF;
 
-	if (flags & ~0)
-		return -EINVAL;
 	if (pos < 0)
 		return -EINVAL;
 
-- 
1.7.9.5

