Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbaHLTtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 15:49:36 -0400
Received: from mail.kernel.org ([198.145.19.201]:58061 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755089AbaHLTtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 15:49:33 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 08/13] f2fs: do checkpoint at f2fs_put_super
Date: Tue, 12 Aug 2014 12:49:22 -0700
Message-Id: <1407872967-26423-8-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
References: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic_shutdown_super calls sync_filesystem, evict_inode, and then
f2fs_put_super. In f2fs_evict_inode, we remain some dirty inode information
so we should release them at f2fs_put_super.

But normally, it's more reasonable to set its superblock as dirty when
evict_inode is called.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/inode.c | 1 +
 fs/f2fs/super.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 2c39999..eeaf5aa 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -303,6 +303,7 @@ no_delete:
 		add_dirty_inode(sbi, inode->i_ino, APPEND_INO);
 	if (is_inode_flag_set(F2FS_I(inode), FI_UPDATE_WRITE))
 		add_dirty_inode(sbi, inode->i_ino, UPDATE_INO);
+	F2FS_SET_SB_DIRT(sbi);
 out_clear:
 	clear_inode(inode);
 }
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 633315a..60e3554 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -432,7 +432,7 @@ static void f2fs_put_super(struct super_block *sb)
 	stop_gc_thread(sbi);
 
 	/* We don't need to do checkpoint when it's clean */
-	if (sbi->s_dirty && get_pages(sbi, F2FS_DIRTY_NODES))
+	if (sbi->s_dirty)
 		write_checkpoint(sbi, true);
 
 	iput(sbi->node_inode);
-- 
1.8.5.2 (Apple Git-48)

