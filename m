Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761127AbaGYWtg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 18:49:36 -0400
Received: from mail.kernel.org ([198.145.19.201]:48857 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760984AbaGYWtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 18:49:32 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 10/11] f2fs: avoid checkpoint when error was occurred
Date: Fri, 25 Jul 2014 15:47:24 -0700
Message-Id: <1406328445-63707-10-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1406328445-63707-1-git-send-email-jaegeuk@kernel.org>
References: <1406328445-63707-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to do checkpoint, whenever any errors were detected.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/recovery.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index a112368..90d7e80 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -436,7 +436,6 @@ int recover_fsync_data(struct f2fs_sb_info *sbi)
 {
 	struct list_head inode_list;
 	int err;
-	bool need_writecp = false;
 
 	fsync_entry_slab = f2fs_kmem_cache_create("f2fs_fsync_inode_entry",
 			sizeof(struct fsync_inode_entry));
@@ -454,8 +453,6 @@ int recover_fsync_data(struct f2fs_sb_info *sbi)
 	if (list_empty(&inode_list))
 		goto out;
 
-	need_writecp = true;
-
 	/* step #2: recover data */
 	err = recover_data(sbi, &inode_list, CURSEG_WARM_NODE);
 	f2fs_bug_on(!list_empty(&inode_list));
@@ -463,7 +460,7 @@ out:
 	destroy_fsync_dnodes(&inode_list);
 	kmem_cache_destroy(fsync_entry_slab);
 	sbi->por_doing = false;
-	if (!err && need_writecp)
+	if (!err)
 		write_checkpoint(sbi, false);
 	return err;
 }
-- 
1.8.5.2 (Apple Git-48)

