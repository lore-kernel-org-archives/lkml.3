Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbaHOV5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 17:57:24 -0400
Received: from mail.kernel.org ([198.145.19.201]:54329 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbaHOV5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 17:57:23 -0400
Date: Fri, 15 Aug 2014 14:58:18 -0700
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 08/13 v2] f2fs: do checkpoint at f2fs_put_super
Message-ID: <20140815215818.GB53769@jaegeuk-mac02.mot.com>
References: <1407872967-26423-1-git-send-email-jaegeuk@kernel.org>
 <1407872967-26423-8-git-send-email-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407872967-26423-8-git-send-email-jaegeuk@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change log from v1:
 o relocate F2FS_SET_SB_DIRT to avoid unnecessary checkpoints

The generic_shutdown_super calls sync_filesystem, evict_inode, and then
f2fs_put_super. In f2fs_evict_inode, we remain some dirty inode information
so we should release them at f2fs_put_super.

But normally, it's more reasonable to set its superblock as dirty when
evict_inode is called.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/checkpoint.c | 1 +
 fs/f2fs/super.c      | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 7e1c13b..01e1796 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -330,6 +330,7 @@ void add_dirty_inode(struct f2fs_sb_info *sbi, nid_t ino, int type)
 {
 	/* add new dirty ino entry into list */
 	__add_ino_entry(sbi, ino, type);
+	F2FS_SET_SB_DIRT(sbi);
 }
 
 void remove_dirty_inode(struct f2fs_sb_info *sbi, nid_t ino, int type)
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


