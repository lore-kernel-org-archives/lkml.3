Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760674AbaGYWtX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 18:49:23 -0400
Received: from mail.kernel.org ([198.145.19.201]:48771 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760063AbaGYWtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 18:49:20 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 06/11] f2fs: skip unnecessary data writes during fsync
Date: Fri, 25 Jul 2014 15:47:20 -0700
Message-Id: <1406328445-63707-6-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1406328445-63707-1-git-send-email-jaegeuk@kernel.org>
References: <1406328445-63707-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch intends to improve the fsync performance by skipping remaining the
recovery information, only when there is no data that we should recover.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/file.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 7c652b3..121689a 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -133,6 +133,17 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		return ret;
 	}
 
+	/*
+	 * if there is no written data, don't waste time to write recovery info.
+	 */
+	if (!is_inode_flag_set(fi, FI_APPEND_WRITE) &&
+		!exist_written_data(sbi, inode->i_ino, APPEND_INO)) {
+		if (is_inode_flag_set(fi, FI_UPDATE_WRITE) &&
+			exist_written_data(sbi, inode->i_ino, UPDATE_INO))
+			goto flush_out;
+		goto out;
+	}
+
 	/* guarantee free sections for fsync */
 	f2fs_balance_fs(sbi);
 
@@ -188,6 +199,11 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		ret = wait_on_node_pages_writeback(sbi, inode->i_ino);
 		if (ret)
 			goto out;
+
+		/* once recovery info is written, don't need to tack this */
+		remove_dirty_inode(sbi, inode->i_ino, APPEND_INO);
+flush_out:
+		remove_dirty_inode(sbi, inode->i_ino, UPDATE_INO);
 		ret = f2fs_issue_flush(F2FS_SB(inode->i_sb));
 	}
 out:
-- 
1.8.5.2 (Apple Git-48)

