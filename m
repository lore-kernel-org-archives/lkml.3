Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab3L0RKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 12:10:51 -0500
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:22467 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751225Ab3L0RKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 12:10:49 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am8QACO0vVJbsm8//2dsb2JhbABYKIJjgzq3KAICgRkXdIJTExwjGIECN4gIAckXjx2EPQEDiUGOVQGSFIM6Lw
Date: Fri, 27 Dec 2013 17:11:45 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, rdunlap@infradead.org
Subject: [PATCH 1/1] reiserfs:Adding tmpfile support (v2)
Message-Id: <20131227171145.c2a14e80dcbe7f7c1dd470b7@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New function reiserfs_tmpfile:
 -Duplicate reiserfs_create
 -Remove dquot_initialize (cf ext2/tmpfile)
 -Remove add_entry code
 -Add d_tmpfile generic call
 -Add add_save_link (cf ext3/orphan_add)
reiserfs_link function:
 -Add remove_save_link (cf ext3/orphan_del)

Saved link is removed in normal use (close) 
cf reiserfs_evict_inode (reiserfsck is ok)
Note : This patch still requires reiserfs_link testing.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/reiserfs/namei.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index dc5236f..60339d4 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -637,6 +637,66 @@ static int reiserfs_create(struct inode *dir, struct dentry *dentry, umode_t mod
 	return retval;
 }
 
+
+/* tmpfile function based on reiserfs_create without filename entry
+*/
+
+static int reiserfs_tmpfile(struct inode *dir, struct dentry *dentry,
+	umode_t mode)
+{
+	int retval;
+	struct inode *inode;
+	int jbegin_count =
+	    JOURNAL_PER_BALANCE_CNT * 2 +
+	    2 * (REISERFS_QUOTA_INIT_BLOCKS(dir->i_sb) +
+		 REISERFS_QUOTA_TRANS_BLOCKS(dir->i_sb));
+	struct reiserfs_transaction_handle th;
+	struct reiserfs_security_handle security;
+
+	inode = new_inode(dir->i_sb);
+	if (!inode)
+		return -ENOMEM;
+
+	new_inode_init(inode, dir, mode);
+
+	jbegin_count += reiserfs_cache_default_acl(dir);
+	retval = reiserfs_security_init(dir, inode, &dentry->d_name, &security);
+	if (retval < 0) {
+		drop_new_inode(inode);
+		return retval;
+	}
+	jbegin_count += retval;
+	reiserfs_write_lock(dir->i_sb);
+
+	retval = journal_begin(&th, dir->i_sb, jbegin_count);
+	if (retval) {
+		drop_new_inode(inode);
+		goto out_failed;
+	}
+
+	retval =
+	    reiserfs_new_inode(&th, dir, mode, NULL, 0 /*i_size */ , dentry,
+			       inode, &security);
+	if (retval)
+		goto out_failed;
+
+	inode->i_op = &reiserfs_file_inode_operations;
+	inode->i_fop = &reiserfs_file_operations;
+	inode->i_mapping->a_ops = &reiserfs_address_space_operations;
+
+	reiserfs_update_inode_transaction(inode);
+	reiserfs_update_inode_transaction(dir);
+
+	unlock_new_inode(inode);
+	d_tmpfile(dentry, inode);
+	add_save_link(&th, inode, 0);
+	retval = journal_end(&th, dir->i_sb, jbegin_count);
+
+      out_failed:
+	reiserfs_write_unlock(dir->i_sb);
+	return retval;
+}
+
 static int reiserfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode,
 			  dev_t rdev)
 {
@@ -1146,6 +1206,8 @@ static int reiserfs_link(struct dentry *old_dentry, struct inode *dir,
 	reiserfs_update_sd(&th, inode);
 
 	ihold(inode);
+	if (inode->i_nlink == 1)
+		remove_save_link(inode, 0);
 	d_instantiate(dentry, inode);
 	retval = journal_end(&th, dir->i_sb, jbegin_count);
 	reiserfs_write_unlock(dir->i_sb);
@@ -1522,6 +1584,7 @@ const struct inode_operations reiserfs_dir_inode_operations = {
 	.removexattr = reiserfs_removexattr,
 	.permission = reiserfs_permission,
 	.get_acl = reiserfs_get_acl,
+	.tmpfile = reiserfs_tmpfile,
 };
 
 /*
-- 
1.8.1.4
