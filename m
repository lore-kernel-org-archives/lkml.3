Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab3LCWCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 17:02:49 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:36002 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366Ab3LCWAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 17:00:46 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, clm@fb.com, viro@zeniv.linux.org.uk, zab@redhat.com,
        shaggy@kernel.org, Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 07/11] iov_iter: Kill written arg to iov_iter_init()
Date: Tue,  3 Dec 2013 14:00:13 -0800
Message-Id: <1386108017-27964-8-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1386108017-27964-1-git-send-email-kmo@daterainc.com>
References: <1386108017-27964-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
---
 fs/btrfs/file.c     |  8 +++++---
 fs/cifs/file.c      |  4 ++--
 fs/fuse/file.c      | 11 ++++++-----
 include/linux/uio.h |  9 +++------
 mm/filemap.c        |  4 +++-
 5 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 82d0342..273c429 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1577,8 +1577,9 @@ static ssize_t __btrfs_direct_write(struct kiocb *iocb,
 		return written;
 
 	pos += written;
-	count -= written;
-	iov_iter_init(&i, iov, nr_segs, count, written);
+	iov_iter_init(&i, iov, nr_segs, count);
+	iov_iter_advance(&i, written);
+
 	written_buffered = __btrfs_buffered_write(file, &i, pos);
 	if (written_buffered < 0) {
 		err = written_buffered;
@@ -1693,7 +1694,8 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 	} else {
 		struct iov_iter i;
 
-		iov_iter_init(&i, iov, nr_segs, count, num_written);
+		iov_iter_init(&i, iov, nr_segs, count + num_written);
+		iov_iter_advance(&i, num_written);
 
 		num_written = __btrfs_buffered_write(file, &i, pos);
 		if (num_written > 0)
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 5a5a872..dc11685 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2416,7 +2416,7 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 	else
 		pid = current->tgid;
 
-	iov_iter_init(&it, iov, nr_segs, len, 0);
+	iov_iter_init(&it, iov, nr_segs, len);
 	do {
 		size_t save_len;
 
@@ -2720,7 +2720,7 @@ cifs_readdata_to_iov(struct cifs_readdata *rdata, const struct iovec *iov,
 	unsigned int i;
 
 	/* set up iov_iter and advance to the correct offset */
-	iov_iter_init(&ii, iov, nr_segs, iov_length(iov, nr_segs), 0);
+	iov_iter_init(&ii, iov, nr_segs, iov_length(iov, nr_segs));
 	iov_iter_advance(&ii, pos);
 
 	*copied = 0;
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 69175a1..ce45524 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1135,9 +1135,10 @@ static ssize_t fuse_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 			goto out;
 
 		pos += written;
-		count -= written;
 
-		iov_iter_init(&i, iov, nr_segs, count, written);
+		iov_iter_init(&i, iov, nr_segs, count);
+		iov_iter_advance(&i, written);
+
 		written_buffered = fuse_perform_write(file, mapping, &i, pos);
 		if (written_buffered < 0) {
 			err = written_buffered;
@@ -1157,7 +1158,7 @@ static ssize_t fuse_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 		written += written_buffered;
 		iocb->ki_pos = pos + written_buffered;
 	} else {
-		iov_iter_init(&i, iov, nr_segs, count, 0);
+		iov_iter_init(&i, iov, nr_segs, count);
 		written = fuse_perform_write(file, mapping, &i, pos);
 		if (written >= 0)
 			iocb->ki_pos = pos + written;
@@ -1283,7 +1284,7 @@ ssize_t fuse_direct_io(struct fuse_io_priv *io, const struct iovec *iov,
 	struct fuse_req *req;
 	struct iov_iter ii;
 
-	iov_iter_init(&ii, iov, nr_segs, count, 0);
+	iov_iter_init(&ii, iov, nr_segs, count);
 
 	if (io->async)
 		req = fuse_get_req_for_background(fc, fuse_iter_npages(&ii));
@@ -2171,7 +2172,7 @@ static int fuse_ioctl_copy_user(struct page **pages, struct iovec *iov,
 	if (!bytes)
 		return 0;
 
-	iov_iter_init(&ii, iov, nr_segs, bytes, 0);
+	iov_iter_init(&ii, iov, nr_segs, bytes);
 
 	while (iov_iter_count(&ii)) {
 		struct page *page = pages[page_idx++];
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 2b99e0d..d653fee 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -67,16 +67,13 @@ size_t iov_iter_copy_from_user(struct page *page,
 void iov_iter_advance(struct iov_iter *i, size_t bytes);
 int iov_iter_fault_in_readable(struct iov_iter *i, size_t bytes);
 
-static inline void iov_iter_init(struct iov_iter *i,
-			const struct iovec *iov, unsigned long nr_segs,
-			size_t count, size_t written)
+static inline void iov_iter_init(struct iov_iter *i, const struct iovec *iov,
+				 unsigned long nr_segs, size_t count)
 {
 	i->iov = iov;
 	i->nr_segs = nr_segs;
 	i->iov_offset = 0;
-	i->count = count + written;
-
-	iov_iter_advance(i, written);
+	i->count = count;
 }
 
 static inline size_t iov_iter_count(struct iov_iter *i)
diff --git a/mm/filemap.c b/mm/filemap.c
index 1a40f12..d48f39f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2387,7 +2387,9 @@ generic_file_buffered_write(struct kiocb *iocb, const struct iovec *iov,
 	ssize_t status;
 	struct iov_iter i;
 
-	iov_iter_init(&i, iov, nr_segs, count, written);
+	iov_iter_init(&i, iov, nr_segs, count + written);
+	iov_iter_advance(&i, written);
+
 	status = generic_perform_write(file, &i, pos);
 
 	if (likely(status >= 0)) {
-- 
1.8.4.4

