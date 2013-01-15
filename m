Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab3AOPCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 10:02:23 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:30532 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756399Ab3AOPCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 10:02:21 -0500
Subject: [PATCH] fuse: wait for end of IO on release (v2)
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org, devel@openvz.org,
        anand.avati@gmail.com
Date: Tue, 15 Jan 2013 19:02:13 +0400
Message-ID: <20130115145714.18519.53459.stgit@maximpc.sw.ru>
In-Reply-To: <20121220123144.4101.84499.stgit@maximpc.sw.ru>
References: <20121220123144.4101.84499.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
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

Changed in v2: Improve comments, comment spin_unlock_wait out. Thanks to Brian
for suggestions.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/file.c |   61 +++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 58 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 4f23134..150033a 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -137,6 +137,17 @@ static void fuse_file_put(struct fuse_file *ff, bool sync)
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
@@ -253,6 +264,13 @@ void fuse_release_common(struct file *file, int opcode)
 	req->misc.release.path = file->f_path;
 
 	/*
+	 * No more in-flight asynchronous READ or WRITE requests if
+	 * fuse file release is synchronous
+	 */
+	if (ff->fc->close_wait)
+		BUG_ON(atomic_read(&ff->count) != 1);
+
+	/*
 	 * Normally this will send the RELEASE request, however if
 	 * some asynchronous READ or WRITE requests are outstanding,
 	 * the sending will be delayed.
@@ -271,6 +289,30 @@ static int fuse_open(struct inode *inode, struct file *file)
 
 static int fuse_release(struct inode *inode, struct file *file)
 {
+	struct fuse_file *ff = file->private_data;
+
+	if (ff->fc->close_wait) {
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
@@ -610,8 +652,17 @@ static void fuse_readpages_end(struct fuse_conn *fc, struct fuse_req *req)
 		unlock_page(page);
 		page_cache_release(page);
 	}
-	if (req->ff)
-		fuse_file_put(req->ff, false);
+	if (req->ff) {
+		if (fc->close_wait) {
+			struct fuse_inode *fi = get_fuse_inode(req->inode);
+
+			spin_lock(&fc->lock);
+			__fuse_file_put(req->ff);
+			wake_up(&fi->page_waitq);
+			spin_unlock(&fc->lock);
+		} else
+			fuse_file_put(req->ff, false);
+	}
 }
 
 struct fuse_fill_data {
@@ -637,6 +688,7 @@ static void fuse_send_readpages(struct fuse_fill_data *data)
 	if (fc->async_read) {
 		req->ff = fuse_file_get(ff);
 		req->end = fuse_readpages_end;
+		req->inode = data->inode;
 		fuse_request_send_background(fc, req);
 	} else {
 		fuse_request_send(fc, req);
@@ -1178,7 +1230,8 @@ static ssize_t fuse_direct_write(struct file *file, const char __user *buf,
 static void fuse_writepage_free(struct fuse_conn *fc, struct fuse_req *req)
 {
 	__free_page(req->pages[0]);
-	fuse_file_put(req->ff, false);
+	if (!fc->close_wait)
+		fuse_file_put(req->ff, false);
 }
 
 static void fuse_writepage_finish(struct fuse_conn *fc, struct fuse_req *req)
@@ -1191,6 +1244,8 @@ static void fuse_writepage_finish(struct fuse_conn *fc, struct fuse_req *req)
 	dec_bdi_stat(bdi, BDI_WRITEBACK);
 	dec_zone_page_state(req->pages[0], NR_WRITEBACK_TEMP);
 	bdi_writeout_inc(bdi);
+	if (fc->close_wait)
+		__fuse_file_put(req->ff);
 	wake_up(&fi->page_waitq);
 }
 

