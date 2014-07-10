Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbaGJJcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 05:32:09 -0400
Received: from relay.parallels.com ([195.214.232.42]:55509 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbaGJJcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 05:32:05 -0400
Subject: [PATCH] fuse: remove WARN_ON writeback on dead inode
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Thu, 10 Jul 2014 13:32:02 +0400
Message-ID: <20140710093101.21765.96636.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUSE has an architectural peculiarity: it cannot write to an inode, unless it
has an associated file open for write. Since the beginning (Apr 30 2008, commit
3be5a52b), FUSE BUG_ON (later WARN_ON) the case when it has to process
writeback, but all associated files are closed. The latest relevant commit is
72523425:

>   Don't bug if there's no writable files found for page writeback.  If ever
>   this is triggered, a WARN_ON helps debugging it much better then a BUG_ON.
>
>   Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

But that situation can happen in quite a legal way: for example, let's mmap a
file, then issue O_DIRECT read to mmapped region and immediately close file
and munmap. O_DIRECT will pin some pages, execute IO to them and then mark
pages dirty. Here we are.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/file.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 6e16dad..3a47aa2 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1624,8 +1624,8 @@ static void fuse_writepage_end(struct fuse_conn *fc, struct fuse_req *req)
 	fuse_writepage_free(fc, req);
 }
 
-static struct fuse_file *__fuse_write_file_get(struct fuse_conn *fc,
-					       struct fuse_inode *fi)
+static struct fuse_file *fuse_write_file_get(struct fuse_conn *fc,
+					     struct fuse_inode *fi)
 {
 	struct fuse_file *ff = NULL;
 
@@ -1640,14 +1640,6 @@ static struct fuse_file *__fuse_write_file_get(struct fuse_conn *fc,
 	return ff;
 }
 
-static struct fuse_file *fuse_write_file_get(struct fuse_conn *fc,
-					     struct fuse_inode *fi)
-{
-	struct fuse_file *ff = __fuse_write_file_get(fc, fi);
-	WARN_ON(!ff);
-	return ff;
-}
-
 int fuse_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
@@ -1655,7 +1647,7 @@ int fuse_write_inode(struct inode *inode, struct writeback_control *wbc)
 	struct fuse_file *ff;
 	int err;
 
-	ff = __fuse_write_file_get(fc, fi);
+	ff = fuse_write_file_get(fc, fi);
 	err = fuse_flush_times(inode, ff);
 	if (ff)
 		fuse_file_put(ff, 0);

