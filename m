Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934169AbaHZIm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 04:42:58 -0400
Received: from relay.parallels.com ([195.214.232.42]:56679 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933898AbaHZIm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 04:42:56 -0400
Subject: [PATCH 3/6] fuse: wait for end of IO on release (v2)
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, avati@gluster.org,
        linux-kernel@vger.kernel.org
Date: Tue, 26 Aug 2014 12:42:52 +0400
Message-ID: <20140826084149.30577.27364.stgit@localhost.localdomain>
In-Reply-To: <20140821160823.11005.32693.stgit@localhost.localdomain>
References: <20140821160823.11005.32693.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two types of I/O activity that can be "in progress" at the time
of fuse_release() execution: asynchronous read-ahead and write-back. The
patch ensures that they are completed before fuse_release_common sends
FUSE_RELEASE to userspace.

So far as fuse_release() waits for end of async I/O, its callbacks
(fuse_readpages_end and fuse_writepage_finish) calling fuse_file_put cannot
be the last holders of fuse file anymore. To emphasize the fact, the patch
replaces fuse_file_put with __fuse_file_put there.

Changed in v2 (thanks to Miklos):
 - removed redundant locking around __fuse_file_put()

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/file.c |   71 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 66 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 7723b3f..8713e62 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -149,6 +149,17 @@ static void fuse_file_put(struct fuse_file *ff, bool sync)
 	}
 }
 
+/*
+ * Asynchronous callbacks may use it instead of fuse_file_put() because
+ * we guarantee that they are never last holders of ff. Hitting BUG() below
+ * will make clear any violation of the guarantee.
+ */
+static void __fuse_file_put(struct fuse_file *ff)
+{
+	if (atomic_dec_and_test(&ff->count))
+		BUG();
+}
+
 int fuse_do_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
 		 bool isdir)
 {
@@ -279,6 +290,11 @@ static void fuse_prepare_release(struct fuse_file *ff, int flags, int opcode)
 	req->in.args[0].value = inarg;
 }
 
+static bool must_release_synchronously(struct fuse_file *ff)
+{
+	return ff->open_flags & FOPEN_SYNC_RELEASE;
+}
+
 void fuse_release_common(struct file *file, int opcode)
 {
 	struct fuse_file *ff;
@@ -302,6 +318,13 @@ void fuse_release_common(struct file *file, int opcode)
 	req->misc.release.path = file->f_path;
 
 	/*
+	 * No more in-flight asynchronous READ or WRITE requests if
+	 * fuse file release is synchronous
+	 */
+	if (must_release_synchronously(ff))
+		BUG_ON(atomic_read(&ff->count) != 1);
+
+	/*
 	 * Normally this will send the RELEASE request, however if
 	 * some asynchronous READ or WRITE requests are outstanding,
 	 * the sending will be delayed.
@@ -321,11 +344,34 @@ static int fuse_open(struct inode *inode, struct file *file)
 static int fuse_release(struct inode *inode, struct file *file)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_file *ff = file->private_data;
 
 	/* see fuse_vma_close() for !writeback_cache case */
 	if (fc->writeback_cache)
 		write_inode_now(inode, 1);
 
+	if (must_release_synchronously(ff)) {
+		struct fuse_inode *fi = get_fuse_inode(inode);
+
+		/*
+		 * Must remove file from write list. Otherwise it is possible
+		 * this file will get more writeback from another files
+		 * rerouted via write_files.
+		 */
+		spin_lock(&ff->fc->lock);
+		list_del_init(&ff->write_entry);
+		spin_unlock(&ff->fc->lock);
+
+		wait_event(fi->page_waitq, atomic_read(&ff->count) == 1);
+
+		/*
+		 * spin_unlock_wait(&ff->fc->lock) would be natural here to
+		 * wait for threads just released ff to leave their critical
+		 * sections. But taking spinlock is the first thing
+		 * fuse_release_common does, so that this is unnecessary.
+		 */
+	}
+
 	fuse_release_common(file, FUSE_RELEASE);
 
 	/* return value is ignored by VFS */
@@ -823,8 +869,15 @@ static void fuse_readpages_end(struct fuse_conn *fc, struct fuse_req *req)
 		unlock_page(page);
 		page_cache_release(page);
 	}
-	if (req->ff)
-		fuse_file_put(req->ff, false);
+	if (req->ff) {
+		if (must_release_synchronously(req->ff)) {
+			struct fuse_inode *fi = get_fuse_inode(req->inode);
+
+			__fuse_file_put(req->ff);
+			wake_up(&fi->page_waitq);
+		} else
+			fuse_file_put(req->ff, false);
+	}
 }
 
 struct fuse_fill_data {
@@ -851,6 +904,7 @@ static void fuse_send_readpages(struct fuse_fill_data *data)
 	if (fc->async_read) {
 		req->ff = fuse_file_get(ff);
 		req->end = fuse_readpages_end;
+		req->inode = data->inode;
 		fuse_request_send_background(fc, req);
 	} else {
 		fuse_request_send(fc, req);
@@ -1502,7 +1556,7 @@ static void fuse_writepage_free(struct fuse_conn *fc, struct fuse_req *req)
 	for (i = 0; i < req->num_pages; i++)
 		__free_page(req->pages[i]);
 
-	if (req->ff)
+	if (req->ff && !must_release_synchronously(req->ff))
 		fuse_file_put(req->ff, false);
 }
 
@@ -1519,6 +1573,8 @@ static void fuse_writepage_finish(struct fuse_conn *fc, struct fuse_req *req)
 		dec_zone_page_state(req->pages[i], NR_WRITEBACK_TEMP);
 		bdi_writeout_inc(bdi);
 	}
+	if (must_release_synchronously(req->ff))
+		__fuse_file_put(req->ff);
 	wake_up(&fi->page_waitq);
 }
 
@@ -1659,8 +1715,13 @@ int fuse_write_inode(struct inode *inode, struct writeback_control *wbc)
 
 	ff = __fuse_write_file_get(fc, fi);
 	err = fuse_flush_times(inode, ff);
-	if (ff)
-		fuse_file_put(ff, 0);
+	if (ff) {
+		if (must_release_synchronously(ff)) {
+			__fuse_file_put(ff);
+			wake_up(&fi->page_waitq);
+		} else
+			fuse_file_put(ff, false);
+	}
 
 	return err;
 }

