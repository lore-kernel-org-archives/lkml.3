Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbaJTFUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 01:20:00 -0400
Received: from mail.kernel.org ([198.145.19.201]:59997 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbaJTFTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 01:19:53 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 06/11] f2fs: fix counting inline_data inode numbers
Date: Sun, 19 Oct 2014 22:19:34 -0700
Message-Id: <1413782379-11758-6-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413782379-11758-1-git-send-email-jaegeuk@kernel.org>
References: <1413782379-11758-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes wrongly counting inline_data inode numbers.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/inode.c | 4 ++--
 fs/f2fs/namei.c | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index b9b1d6b..4131e3c 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -169,6 +169,7 @@ make_now:
 		goto bad_inode;
 	}
 	unlock_new_inode(inode);
+	stat_inc_inline_inode(inode);
 	stat_inc_inline_dir(inode);
 	trace_f2fs_iget(inode);
 	return inode;
@@ -296,12 +297,12 @@ void f2fs_evict_inode(struct inode *inode)
 
 	f2fs_lock_op(sbi);
 	remove_inode_page(inode);
-	stat_dec_inline_inode(inode);
 	f2fs_unlock_op(sbi);
 
 	sb_end_intwrite(inode->i_sb);
 no_delete:
 	stat_dec_inline_dir(inode);
+	stat_dec_inline_inode(inode);
 	invalidate_mapping_pages(NODE_MAPPING(sbi), inode->i_ino, inode->i_ino);
 	if (xnid)
 		invalidate_mapping_pages(NODE_MAPPING(sbi), xnid, xnid);
@@ -327,7 +328,6 @@ void handle_failed_inode(struct inode *inode)
 		f2fs_truncate(inode);
 
 	remove_inode_page(inode);
-	stat_dec_inline_inode(inode);
 
 	clear_inode_flag(F2FS_I(inode), FI_INLINE_DENTRY);
 	alloc_nid_failed(sbi, inode->i_ino);
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 94ba291..a004a97 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -198,8 +198,6 @@ static struct dentry *f2fs_lookup(struct inode *dir, struct dentry *dentry,
 		inode = f2fs_iget(dir->i_sb, ino);
 		if (IS_ERR(inode))
 			return ERR_CAST(inode);
-
-		stat_inc_inline_inode(inode);
 	}
 
 	return d_splice_alias(inode, dentry);
-- 
2.1.1

