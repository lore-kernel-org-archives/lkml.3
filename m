Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab3JJNK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 09:10:58 -0400
Received: from relay.parallels.com ([195.214.232.42]:48197 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169Ab3JJNKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 09:10:55 -0400
Subject: [PATCH 04/11] fuse: Trust kernel i_size only - v4
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org,
        jbottomley@parallels.com, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, fengguang.wu@intel.com, devel@openvz.org
Date: Thu, 10 Oct 2013 17:10:46 +0400
Message-ID: <20131010131036.10089.59063.stgit@dhcp-10-30-17-2.sw.ru>
In-Reply-To: <20131010130718.10089.6736.stgit@dhcp-10-30-17-2.sw.ru>
References: <20131010130718.10089.6736.stgit@dhcp-10-30-17-2.sw.ru>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Emelyanov <xemul@openvz.org>

Make fuse think that when writeback is on the inode's i_size is always
up-to-date and not update it with the value received from the userspace.
This is done because the page cache code may update i_size without letting
the FS know.

This assumption implies fixing the previously introduced short-read helper --
when a short read occurs the 'hole' is filled with zeroes.

fuse_file_fallocate() is also fixed because now we should keep i_size up to
date, so it must be updated if FUSE_FALLOCATE request succeeded.

Changed in v2:
 - improved comment in fuse_short_read()
 - fixed fuse_file_fallocate() for KEEP_SIZE mode

Changed in v3:
 - fixed fuse_fillattr() not to use local i_size if writeback-cache is off
 - added a comment explaining why we cannot trust attr.size from server

Changed in v4:
 - do not change fuse_file_fallocate() because what we need is already
   implemented in commits a200a2d and 14c1441

Signed-off-by: Maxim V. Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/dir.c   |   13 +++++++++++--
 fs/fuse/file.c  |   26 ++++++++++++++++++++++++--
 fs/fuse/inode.c |   11 +++++++++--
 3 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 62b43b5..f022968 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -854,6 +854,11 @@ static void fuse_fillattr(struct inode *inode, struct fuse_attr *attr,
 			  struct kstat *stat)
 {
 	unsigned int blkbits;
+	struct fuse_conn *fc = get_fuse_conn(inode);
+
+	/* see the comment in fuse_change_attributes() */
+	if (fc->writeback_cache && S_ISREG(inode->i_mode))
+		attr->size = i_size_read(inode);
 
 	stat->dev = inode->i_sb->s_dev;
 	stat->ino = attr->ino;
@@ -1594,6 +1599,7 @@ int fuse_do_setattr(struct inode *inode, struct iattr *attr,
 	struct fuse_setattr_in inarg;
 	struct fuse_attr_out outarg;
 	bool is_truncate = false;
+	bool is_wb = fc->writeback_cache;
 	loff_t oldsize;
 	int err;
 
@@ -1665,7 +1671,9 @@ int fuse_do_setattr(struct inode *inode, struct iattr *attr,
 	fuse_change_attributes_common(inode, &outarg.attr,
 				      attr_timeout(&outarg));
 	oldsize = inode->i_size;
-	i_size_write(inode, outarg.attr.size);
+	/* see the comment in fuse_change_attributes() */
+	if (!is_wb || is_truncate || !S_ISREG(inode->i_mode))
+		i_size_write(inode, outarg.attr.size);
 
 	if (is_truncate) {
 		/* NOTE: this may release/reacquire fc->lock */
@@ -1677,7 +1685,8 @@ int fuse_do_setattr(struct inode *inode, struct iattr *attr,
 	 * Only call invalidate_inode_pages2() after removing
 	 * FUSE_NOWRITE, otherwise fuse_launder_page() would deadlock.
 	 */
-	if (S_ISREG(inode->i_mode) && oldsize != outarg.attr.size) {
+	if ((is_truncate || !is_wb) &&
+	    S_ISREG(inode->i_mode) && oldsize != outarg.attr.size) {
 		truncate_pagecache(inode, outarg.attr.size);
 		invalidate_inode_pages2(inode->i_mapping);
 	}
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 886f3a2..333a764 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -658,9 +658,31 @@ static void fuse_short_read(struct fuse_req *req, struct inode *inode,
 			    u64 attr_ver)
 {
 	size_t num_read = req->out.args[0].size;
+	struct fuse_conn *fc = get_fuse_conn(inode);
+
+	if (fc->writeback_cache) {
+		/*
+		 * A hole in a file. Some data after the hole are in page cache,
+		 * but have not reached the client fs yet. So, the hole is not
+		 * present there.
+		 */
+		int i;
+		int start_idx = num_read >> PAGE_CACHE_SHIFT;
+		size_t off = num_read & (PAGE_CACHE_SIZE - 1);
+
+		for (i = start_idx; i < req->num_pages; i++) {
+			struct page *page = req->pages[i];
+			void *mapaddr = kmap_atomic(page);
 
-	loff_t pos = page_offset(req->pages[0]) + num_read;
-	fuse_read_update_size(inode, pos, attr_ver);
+			memset(mapaddr + off, 0, PAGE_CACHE_SIZE - off);
+
+			kunmap_atomic(mapaddr);
+			off = 0;
+		}
+	} else {
+		loff_t pos = page_offset(req->pages[0]) + num_read;
+		fuse_read_update_size(inode, pos, attr_ver);
+	}
 }
 
 static int fuse_readpage(struct file *file, struct page *page)
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index a8ce6da..63818ab 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -197,6 +197,7 @@ void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_inode *fi = get_fuse_inode(inode);
+	bool is_wb = fc->writeback_cache;
 	loff_t oldsize;
 	struct timespec old_mtime;
 
@@ -211,10 +212,16 @@ void fuse_change_attributes(struct inode *inode, struct fuse_attr *attr,
 	fuse_change_attributes_common(inode, attr, attr_valid);
 
 	oldsize = inode->i_size;
-	i_size_write(inode, attr->size);
+	/*
+	 * In case of writeback_cache enabled, the cached writes beyond EOF
+	 * extend local i_size without keeping userspace server in sync. So,
+	 * attr->size coming from server can be stale. We cannot trust it.
+	 */
+	if (!is_wb || !S_ISREG(inode->i_mode))
+		i_size_write(inode, attr->size);
 	spin_unlock(&fc->lock);
 
-	if (S_ISREG(inode->i_mode)) {
+	if (!is_wb && S_ISREG(inode->i_mode)) {
 		bool inval = false;
 
 		if (oldsize != attr->size) {

