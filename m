Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbaHSQxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 12:53:10 -0400
Received: from mail.kernel.org ([198.145.19.201]:36523 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbaHSQxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 12:53:07 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/2] f2fs: trigger release_dirty_inode in f2fs_put_super
Date: Tue, 19 Aug 2014 09:52:57 -0700
Message-Id: <1408467177-69746-2-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1408467177-69746-1-git-send-email-jaegeuk@kernel.org>
References: <1408467177-69746-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic_shutdown_super calls sync_filesystem, evict_inode, and then
f2fs_put_super. In f2fs_evict_inode, we remain some dirty inode information
so we should release them at f2fs_put_super.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/checkpoint.c | 2 +-
 fs/f2fs/super.c      | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 7e1c13b..f14af91 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -348,7 +348,7 @@ bool exist_written_data(struct f2fs_sb_info *sbi, nid_t ino, int mode)
 	return e ? true : false;
 }
 
-static void release_dirty_inode(struct f2fs_sb_info *sbi)
+void release_dirty_inode(struct f2fs_sb_info *sbi)
 {
 	struct ino_entry *e, *tmp;
 	int i;
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 60e3554..7a54779 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -435,6 +435,9 @@ static void f2fs_put_super(struct super_block *sb)
 	if (sbi->s_dirty)
 		write_checkpoint(sbi, true);
 
+	/* normally superblock is clean, so we need to release this */
+	release_dirty_inode(sbi);
+
 	iput(sbi->node_inode);
 	iput(sbi->meta_inode);
 
-- 
1.8.5.2 (Apple Git-48)

