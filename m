Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab3JUJUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:20:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39490 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753613Ab3JUIvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:24 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Miklos Szeredi" <mszeredi@suse.cz>,
        "Maxim Patlasov" <MPatlasov@parallels.com>,
        "Maxim Patlasov" <mpatlasov@parallels.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.154304044@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 050/149] fuse: hotfix truncate_pagecache() issue
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: add the fuse_inode::state field which we didn't have]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/fuse/dir.c    | 7 ++++++-
 fs/fuse/file.c   | 8 +++++++-
 fs/fuse/fuse_i.h | 2 ++
 fs/fuse/inode.c  | 3 ++-
 4 files changed, 17 insertions(+), 3 deletions(-)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1282,6 +1282,7 @@ static int fuse_do_setattr(struct dentry
 {
 	struct inode *inode = entry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_inode *fi = get_fuse_inode(inode);
 	struct fuse_req *req;
 	struct fuse_setattr_in inarg;
 	struct fuse_attr_out outarg;
@@ -1312,8 +1313,10 @@ static int fuse_do_setattr(struct dentry
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	if (is_truncate)
+	if (is_truncate) {
 		fuse_set_nowrite(inode);
+		set_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
+	}
 
 	memset(&inarg, 0, sizeof(inarg));
 	memset(&outarg, 0, sizeof(outarg));
@@ -1375,12 +1378,14 @@ static int fuse_do_setattr(struct dentry
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
 
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -519,7 +519,8 @@ static void fuse_read_update_size(struct
 	struct fuse_inode *fi = get_fuse_inode(inode);
 
 	spin_lock(&fc->lock);
-	if (attr_ver == fi->attr_version && size < inode->i_size) {
+	if (attr_ver == fi->attr_version && size < inode->i_size &&
+	    !test_bit(FUSE_I_SIZE_UNSTABLE, &fi->state)) {
 		fi->attr_version = ++fc->attr_version;
 		i_size_write(inode, size);
 	}
@@ -881,12 +882,16 @@ static ssize_t fuse_perform_write(struct
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
@@ -921,6 +926,7 @@ static ssize_t fuse_perform_write(struct
 	if (res > 0)
 		fuse_write_update_size(inode, pos);
 
+	clear_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
 	fuse_invalidate_attr(inode);
 
 	return res > 0 ? res : err;
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
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -92,6 +92,7 @@ static struct inode *fuse_alloc_inode(st
 	fi->attr_version = 0;
 	fi->writectr = 0;
 	fi->orig_ino = 0;
+	fi->state = 0;
 	INIT_LIST_HEAD(&fi->write_files);
 	INIT_LIST_HEAD(&fi->queued_writes);
 	INIT_LIST_HEAD(&fi->writepages);
@@ -200,7 +201,8 @@ void fuse_change_attributes(struct inode
 	loff_t oldsize;
 
 	spin_lock(&fc->lock);
-	if (attr_version != 0 && fi->attr_version > attr_version) {
+	if ((attr_version != 0 && fi->attr_version > attr_version) ||
+	    test_bit(FUSE_I_SIZE_UNSTABLE, &fi->state)) {
 		spin_unlock(&fc->lock);
 		return;
 	}

