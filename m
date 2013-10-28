Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670Ab3J1PAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:00:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51159 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab3J1OtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:49:22 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Maxim Patlasov <mpatlasov@parallels.com>,
        Miklos Szeredi <mszeredi@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 34/64] fuse: hotfix truncate_pagecache() issue
Date: Mon, 28 Oct 2013 14:47:53 +0000
Message-Id: <1382971703-17393-35-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxim Patlasov <MPatlasov@parallels.com>

commit 06a7c3c2781409af95000c60a5df743fd4e2f8b4 upstream.

The way how fuse calls truncate_pagecache() from fuse_change_attributes()
is completely wrong. Because, w/o i_mutex held, we never sure whether
'oldsize' and 'attr->size' are valid by the time of execution of
truncate_pagecache(inode, oldsize, attr->size). In fact, as soon as we
released fc->lock in the middle of fuse_change_attributes(), we completely
loose control of actions which may happen with given inode until we reach
truncate_pagecache. The list of potentially dangerous actions includes
mmap-ed reads and writes, ftruncate(2) and write(2) extending file size.

The typical outcome of doing truncate_pagecache() with outdated arguments
is data corruption from user point of view. This is (in some sense)
acceptable in cases when the issue is triggered by a change of the file on
the server (i.e. externally wrt fuse operation), but it is absolutely
intolerable in scenarios when a single fuse client modifies a file without
any external intervention. A real life case I discovered by fsx-linux
looked like this:

1. Shrinking ftruncate(2) comes to fuse_do_setattr(). The latter sends
FUSE_SETATTR to the server synchronously, but before getting fc->lock ...
2. fuse_dentry_revalidate() is asynchronously called. It sends FUSE_LOOKUP
to the server synchronously, then calls fuse_change_attributes(). The
latter updates i_size, releases fc->lock, but before comparing oldsize vs
attr->size..
3. fuse_do_setattr() from the first step proceeds by acquiring fc->lock and
updating attributes and i_size, but now oldsize is equal to
outarg.attr.size because i_size has just been updated (step 2). Hence,
fuse_do_setattr() returns w/o calling truncate_pagecache().
4. As soon as ftruncate(2) completes, the user extends file size by
write(2) making a hole in the middle of file, then reads data from the hole
either by read(2) or mmap-ed read. The user expects to get zero data from
the hole, but gets stale data because truncate_pagecache() is not executed
yet.

The scenario above illustrates one side of the problem: not truncating the
page cache even though we should. Another side corresponds to truncating
page cache too late, when the state of inode changed significantly.
Theoretically, the following is possible:

1. As in the previous scenario fuse_dentry_revalidate() discovered that
i_size changed (due to our own fuse_do_setattr()) and is going to call
truncate_pagecache() for some 'new_size' it believes valid right now. But
by the time that particular truncate_pagecache() is called ...
2. fuse_do_setattr() returns (either having called truncate_pagecache() or
not -- it doesn't matter).
3. The file is extended either by write(2) or ftruncate(2) or fallocate(2).
4. mmap-ed write makes a page in the extended region dirty.

The result will be the lost of data user wrote on the fourth step.

The patch is a hotfix resolving the issue in a simplistic way: let's skip
dangerous i_size update and truncate_pagecache if an operation changing
file size is in progress. This simplistic approach looks correct for the
cases w/o external changes. And to handle them properly, more sophisticated
and intrusive techniques (e.g. NFS-like one) would be required. I'd like to
postpone it until the issue is well discussed on the mailing list(s).

Changed in v2:
 - improved patch description to cover both sides of the issue.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
[ luis: backported to 3.5, based on bwh's backport to 3.2:
  - added state field to struct fuse_inode ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/fuse/dir.c    | 7 ++++++-
 fs/fuse/file.c   | 8 +++++++-
 fs/fuse/fuse_i.h | 9 +++++++++
 fs/fuse/inode.c  | 4 +++-
 4 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index b60cc5f..ac5b0b9 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1354,6 +1354,7 @@ static int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
 {
 	struct inode *inode = entry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_inode *fi = get_fuse_inode(inode);
 	struct fuse_req *req;
 	struct fuse_setattr_in inarg;
 	struct fuse_attr_out outarg;
@@ -1384,8 +1385,10 @@ static int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	if (is_truncate)
+	if (is_truncate) {
 		fuse_set_nowrite(inode);
+		set_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
+	}
 
 	memset(&inarg, 0, sizeof(inarg));
 	memset(&outarg, 0, sizeof(outarg));
@@ -1447,12 +1450,14 @@ static int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
 		invalidate_inode_pages2(inode->i_mapping);
 	}
 
+	clear_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
 	return 0;
 
 error:
 	if (is_truncate)
 		fuse_release_nowrite(inode);
 
+	clear_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
 	return err;
 }
 
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index e7785e4..9cc2f91 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -515,7 +515,8 @@ static void fuse_read_update_size(struct inode *inode, loff_t size,
 	struct fuse_inode *fi = get_fuse_inode(inode);
 
 	spin_lock(&fc->lock);
-	if (attr_ver == fi->attr_version && size < inode->i_size) {
+	if (attr_ver == fi->attr_version && size < inode->i_size &&
+	    !test_bit(FUSE_I_SIZE_UNSTABLE, &fi->state)) {
 		fi->attr_version = ++fc->attr_version;
 		i_size_write(inode, size);
 	}
@@ -877,12 +878,16 @@ static ssize_t fuse_perform_write(struct file *file,
 {
 	struct inode *inode = mapping->host;
 	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_inode *fi = get_fuse_inode(inode);
 	int err = 0;
 	ssize_t res = 0;
 
 	if (is_bad_inode(inode))
 		return -EIO;
 
+	if (inode->i_size < pos + iov_iter_count(ii))
+		set_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
+
 	do {
 		struct fuse_req *req;
 		ssize_t count;
@@ -917,6 +922,7 @@ static ssize_t fuse_perform_write(struct file *file,
 	if (res > 0)
 		fuse_write_update_size(inode, pos);
 
+	clear_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
 	fuse_invalidate_attr(inode);
 
 	return res > 0 ? res : err;
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 771fb63..1f63d49 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -103,6 +103,15 @@ struct fuse_inode {
 
 	/** List of writepage requestst (pending or sent) */
 	struct list_head writepages;
+
+	/** Miscellaneous bits describing inode state */
+	unsigned long state;
+};
+
+/** FUSE inode state bits */
+enum {
+	/** An operation changing file size is in progress  */
+	FUSE_I_SIZE_UNSTABLE,
 };
 
 struct fuse_conn;
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 1cd6165..bca4e62 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -92,6 +92,7 @@ static struct inode *fuse_alloc_inode(struct super_block *sb)
 	fi->attr_version = 0;
 	fi->writectr = 0;
 	fi->orig_ino = 0;
+	fi->state = 0;
 	INIT_LIST_HEAD(&fi->write_files);
 	INIT_LIST_HEAD(&fi->queued_writes);
 	INIT_LIST_HEAD(&fi->writepages);
@@ -199,7 +200,8 @@ void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
 	loff_t oldsize;
 
 	spin_lock(&fc->lock);
-	if (attr_version != 0 && fi->attr_version > attr_version) {
+	if ((attr_version != 0 && fi->attr_version > attr_version) ||
+	    test_bit(FUSE_I_SIZE_UNSTABLE, &fi->state)) {
 		spin_unlock(&fc->lock);
 		return;
 	}
-- 
1.8.3.2

