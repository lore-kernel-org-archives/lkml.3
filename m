Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab3E3Mml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 08:42:41 -0400
Received: from relay.parallels.com ([195.214.232.42]:58490 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab3E3Mme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 08:42:34 -0400
Subject: [PATCH] fuse: fix alignment in short read optimization for async_dio
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, bfoster@redhat.com,
        linux-kernel@vger.kernel.org, devel@openvz.org
Date: Thu, 30 May 2013 16:41:34 +0400
Message-ID: <20130530123858.16486.94636.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bug was introduced with async_dio feature: trying to optimize short reads,
we cut number-of-bytes-to-read to i_size boundary. Hence the following example:

	truncate --size=300 /mnt/file
	dd if=/mnt/file of=/dev/null iflag=direct

led to FUSE_READ request of 300 bytes size. This turned out to be problem
for userspace fuse implementations who rely on assumption that kernel fuse
does not change alignment of request from client FS.

The patch turns off the optimization if async_dio is disabled. And, if it's
enabled, the patch fixes adjustment of number-of-bytes-to-read to preserve
alignment.

Note, that we cannot throw out short read optimization entirely because
otherwise a direct read of a huge size issued on a tiny file would generate
a huge amount of fuse requests and most of them would be ACKed by userspace
with zero bytes read.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/file.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index d1c9b85..9026572 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2365,6 +2365,11 @@ static void fuse_do_truncate(struct file *file)
 	fuse_do_setattr(inode, &attr, file);
 }
 
+static inline loff_t fuse_round_up(loff_t off)
+{
+	return round_up(off, FUSE_MAX_PAGES_PER_REQ << PAGE_SHIFT);
+}
+
 static ssize_t
 fuse_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 			loff_t offset, unsigned long nr_segs)
@@ -2372,6 +2377,7 @@ fuse_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 	ssize_t ret = 0;
 	struct file *file = iocb->ki_filp;
 	struct fuse_file *ff = file->private_data;
+	bool async_dio = ff->fc->async_dio;
 	loff_t pos = 0;
 	struct inode *inode;
 	loff_t i_size;
@@ -2383,10 +2389,10 @@ fuse_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 	i_size = i_size_read(inode);
 
 	/* optimization for short read */
-	if (rw != WRITE && offset + count > i_size) {
+	if (async_dio && rw != WRITE && offset + count > i_size) {
 		if (offset >= i_size)
 			return 0;
-		count = i_size - offset;
+		count = min_t(loff_t, count, fuse_round_up(i_size - offset));
 	}
 
 	io = kmalloc(sizeof(struct fuse_io_priv), GFP_KERNEL);
@@ -2404,7 +2410,7 @@ fuse_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 	 * By default, we want to optimize all I/Os with async request
 	 * submission to the client filesystem if supported.
 	 */
-	io->async = ff->fc->async_dio;
+	io->async = async_dio;
 	io->iocb = iocb;
 
 	/*
@@ -2412,7 +2418,7 @@ fuse_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 	 * to wait on real async I/O requests, so we must submit this request
 	 * synchronously.
 	 */
-	if (!is_sync_kiocb(iocb) && (offset + count > i_size))
+	if (!is_sync_kiocb(iocb) && (offset + count > i_size) && rw == WRITE)
 		io->async = false;
 
 	if (rw == WRITE)

