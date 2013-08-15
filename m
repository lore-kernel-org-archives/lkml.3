Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab3HOLRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 07:17:42 -0400
Received: from mail-pa0-f66.google.com ([209.85.220.66]:64884 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251Ab3HOLRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 07:17:40 -0400
From: Jin Xu <jinuxstyle@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jinuxstyle@gmail.com
Subject: [PATCH] f2fs: avoid writing inode redundantly when creating a file
Date: Thu, 15 Aug 2013 19:17:01 +0800
Message-Id: <1376565421-7218-1-git-send-email-jinuxstyle@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jin Xu <jinuxstyle@gmail.com>

In f2fs_write_inode, updating inode after f2fs_balance_fs is not
a optimized way in the case that f2fs_gc is performed ahead. The
inode page will be unnecessarily written out twice, one of which
is in f2fs_gc->...->sync_node_pages and the other is in
update_inode_page.

Let's update the inode page in prior to f2fs_balance_fs to avoid
this.

To reproduce it,
$ touch file (before this step, should make the device need f2fs_gc)
$ sync (or wait the bdi to write dirty inode)

Signed-off-by: Jin Xu <jinuxstyle@gmail.com>
---
 fs/f2fs/inode.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index d42b85b..675b84a 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -222,9 +222,6 @@ int f2fs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	if (!is_inode_flag_set(F2FS_I(inode), FI_DIRTY_INODE))
 		return 0;
 
-	if (wbc)
-		f2fs_balance_fs(sbi);
-
 	/*
 	 * We need to lock here to prevent from producing dirty node pages
 	 * during the urgent cleaning time when runing out of free sections.
@@ -232,6 +229,10 @@ int f2fs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	ilock = mutex_lock_op(sbi);
 	ret = update_inode_page(inode);
 	mutex_unlock_op(sbi, ilock);
+
+	if (wbc)
+		f2fs_balance_fs(sbi);
+
 	return ret;
 }
 
-- 
1.7.9.5

