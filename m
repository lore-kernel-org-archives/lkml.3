Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbaDOLar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:30:47 -0400
Received: from relay.parallels.com ([195.214.232.42]:54774 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaDOLaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:30:46 -0400
Subject: [PATCH 4/7] fuse: introduce FUSE_I_CTIME_DIRTY flag
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@openvz.org
Date: Tue, 15 Apr 2014 15:30:43 +0400
Message-ID: <20140415112938.11860.48150.stgit@dhcp-10-30-30-94.sw.ru>
In-Reply-To: <20140415112413.11860.1451.stgit@dhcp-10-30-30-94.sw.ru>
References: <20140415112413.11860.1451.stgit@dhcp-10-30-30-94.sw.ru>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The flag plays the role similar to FUSE_I_MTIME_DIRTY: local ctime
(inode->i_ctime) is newer than on the server; so, local ctime must be
flushed to the server afterwards.

The patch only introduces the flag, extends API (fuse_setattr_in) properly,
and implements the flush procedure (fuse_flush_cmtime()). Further patches of
the patch-set will implement the logic of setting and clearing the flag.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/dir.c             |   22 ++++++++++++++++++----
 fs/fuse/file.c            |   11 ++++-------
 fs/fuse/fuse_i.h          |    4 +++-
 include/uapi/linux/fuse.h |   11 ++++++++---
 4 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index c7cb41c..0596726 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1600,9 +1600,9 @@ static void fuse_setattr_fill(struct fuse_conn *fc, struct fuse_req *req,
 }
 
 /*
- * Flush inode->i_mtime to the server
+ * Flush inode->i_mtime and inode->i_ctime to the server
  */
-int fuse_flush_mtime(struct file *file, bool nofail)
+int fuse_flush_cmtime(struct file *file, bool nofail)
 {
 	struct inode *inode = file->f_mapping->host;
 	struct fuse_inode *fi = get_fuse_inode(inode);
@@ -1610,8 +1610,16 @@ int fuse_flush_mtime(struct file *file, bool nofail)
 	struct fuse_req *req = NULL;
 	struct fuse_setattr_in inarg;
 	struct fuse_attr_out outarg;
+	unsigned cmtime_flags = 0;
 	int err;
 
+	if (test_bit(FUSE_I_MTIME_DIRTY, &fi->state))
+		cmtime_flags |= FATTR_MTIME;
+	if (test_bit(FUSE_I_CTIME_DIRTY, &fi->state) && fc->minor >= 24)
+		cmtime_flags |= FATTR_CTIME;
+	if (!cmtime_flags)
+		return 0;
+
 	if (nofail) {
 		req = fuse_get_req_nofail_nopages(fc, file);
 	} else {
@@ -1623,17 +1631,23 @@ int fuse_flush_mtime(struct file *file, bool nofail)
 	memset(&inarg, 0, sizeof(inarg));
 	memset(&outarg, 0, sizeof(outarg));
 
-	inarg.valid |= FATTR_MTIME;
+	inarg.valid = cmtime_flags;
 	inarg.mtime = inode->i_mtime.tv_sec;
 	inarg.mtimensec = inode->i_mtime.tv_nsec;
+	if (fc->minor >= 24) {
+		inarg.ctime = inode->i_ctime.tv_sec;
+		inarg.ctimensec = inode->i_ctime.tv_nsec;
+	}
 
 	fuse_setattr_fill(fc, req, inode, &inarg, &outarg);
 	fuse_request_send(fc, req);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 
-	if (!err)
+	if (!err) {
 		clear_bit(FUSE_I_MTIME_DIRTY, &fi->state);
+		clear_bit(FUSE_I_CTIME_DIRTY, &fi->state);
+	}
 
 	return err;
 }
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index c2c6df7..9ed8590b 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -328,8 +328,7 @@ static int fuse_release(struct inode *inode, struct file *file)
 	if (fc->writeback_cache)
 		filemap_write_and_wait(file->f_mapping);
 
-	if (test_bit(FUSE_I_MTIME_DIRTY, &get_fuse_inode(inode)->state))
-		fuse_flush_mtime(file, true);
+	fuse_flush_cmtime(file, true);
 
 	fuse_release_common(file, FUSE_RELEASE);
 
@@ -512,11 +511,9 @@ int fuse_fsync_common(struct file *file, loff_t start, loff_t end,
 
 	fuse_sync_writes(inode);
 
-	if (test_bit(FUSE_I_MTIME_DIRTY, &get_fuse_inode(inode)->state)) {
-		int err = fuse_flush_mtime(file, false);
-		if (err)
-			goto out;
-	}
+	err = fuse_flush_cmtime(file, false);
+	if (err)
+		goto out;
 
 	req = fuse_get_req_nopages(fc);
 	if (IS_ERR(req)) {
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index a257ed8e..781a01d 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -121,6 +121,8 @@ enum {
 	FUSE_I_SIZE_UNSTABLE,
 	/** i_mtime has been updated locally; a flush to userspace needed */
 	FUSE_I_MTIME_DIRTY,
+	/** i_ctime has been updated locally; a flush to userspace needed */
+	FUSE_I_CTIME_DIRTY,
 };
 
 struct fuse_conn;
@@ -891,7 +893,7 @@ int fuse_dev_release(struct inode *inode, struct file *file);
 
 bool fuse_write_update_size(struct inode *inode, loff_t pos);
 
-int fuse_flush_mtime(struct file *file, bool nofail);
+int fuse_flush_cmtime(struct file *file, bool nofail);
 
 int fuse_do_setattr(struct inode *inode, struct iattr *attr,
 		    struct file *file);
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index cf4750e..8af06cc 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -96,6 +96,10 @@
  *
  * 7.23
  *  - add FUSE_WRITEBACK_CACHE
+ *
+ * 7.24
+ *  - ctime support for FUSE_WRITEBACK_CACHE:
+ *    changes in fuse_setattr_in and fuse_forget_in
  */
 
 #ifndef _LINUX_FUSE_H
@@ -131,7 +135,7 @@
 #define FUSE_KERNEL_VERSION 7
 
 /** Minor version number of this interface */
-#define FUSE_KERNEL_MINOR_VERSION 23
+#define FUSE_KERNEL_MINOR_VERSION 24
 
 /** The node ID of the root inode */
 #define FUSE_ROOT_ID 1
@@ -191,6 +195,7 @@ struct fuse_file_lock {
 #define FATTR_ATIME_NOW	(1 << 7)
 #define FATTR_MTIME_NOW	(1 << 8)
 #define FATTR_LOCKOWNER	(1 << 9)
+#define FATTR_CTIME	(1 << 10)
 
 /**
  * Flags returned by the OPEN request
@@ -438,10 +443,10 @@ struct fuse_setattr_in {
 	uint64_t	lock_owner;
 	uint64_t	atime;
 	uint64_t	mtime;
-	uint64_t	unused2;
+	uint64_t	ctime;
 	uint32_t	atimensec;
 	uint32_t	mtimensec;
-	uint32_t	unused3;
+	uint32_t	ctimensec;
 	uint32_t	mode;
 	uint32_t	unused4;
 	uint32_t	uid;

