Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab3AaVvC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 16:51:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57861 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273Ab3AaVua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 16:50:30 -0500
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 6/6] ext3: Convert ext3 to use mapping lock
Date: Thu, 31 Jan 2013 22:49:54 +0100
Message-Id: <1359668994-13433-7-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1359668994-13433-1-git-send-email-jack@suse.cz>
References: <1359668994-13433-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the filesystem to use mapping lock when truncating files and doing
buffered writes. The rest is handled in the generic code.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/inode.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index b176d42..1f5d5f1 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1261,6 +1261,7 @@ static int ext3_write_begin(struct file *file, struct address_space *mapping,
 	index = pos >> PAGE_CACHE_SHIFT;
 	from = pos & (PAGE_CACHE_SIZE - 1);
 	to = from + len;
+	flags |= AOP_FLAG_LOCK_MAPPING;
 
 retry:
 	page = grab_cache_page_write_begin(mapping, index, flags);
@@ -3273,6 +3274,8 @@ int ext3_setattr(struct dentry *dentry, struct iattr *attr)
 	struct inode *inode = dentry->d_inode;
 	int error, rc = 0;
 	const unsigned int ia_valid = attr->ia_valid;
+	struct range_lock mapping_lock;
+	int range_locked = 0;
 
 	error = inode_change_ok(inode, attr);
 	if (error)
@@ -3314,6 +3317,12 @@ int ext3_setattr(struct dentry *dentry, struct iattr *attr)
 	    attr->ia_valid & ATTR_SIZE && attr->ia_size < inode->i_size) {
 		handle_t *handle;
 
+		range_lock_init(&mapping_lock,
+				attr->ia_size >> PAGE_CACHE_SHIFT,
+				ULONG_MAX);
+		range_lock(&inode->i_mapping->mapping_lock, &mapping_lock);
+		range_locked = 1;
+
 		handle = ext3_journal_start(inode, 3);
 		if (IS_ERR(handle)) {
 			error = PTR_ERR(handle);
@@ -3351,6 +3360,12 @@ int ext3_setattr(struct dentry *dentry, struct iattr *attr)
 	    attr->ia_size != i_size_read(inode)) {
 		truncate_setsize(inode, attr->ia_size);
 		ext3_truncate(inode);
+
+		if (range_locked) {
+			range_unlock(&inode->i_mapping->mapping_lock,
+				     &mapping_lock);
+			range_locked = 0;
+		}
 	}
 
 	setattr_copy(inode, attr);
@@ -3360,6 +3375,8 @@ int ext3_setattr(struct dentry *dentry, struct iattr *attr)
 		rc = ext3_acl_chmod(inode);
 
 err_out:
+	if (range_locked)
+		range_unlock(&inode->i_mapping->mapping_lock, &mapping_lock);
 	ext3_std_error(inode->i_sb, error);
 	if (!error)
 		error = rc;
-- 
1.7.1

