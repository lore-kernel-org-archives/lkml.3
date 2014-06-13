Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbaFMKRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 06:17:48 -0400
Received: from mail.kernel.org ([198.145.19.201]:55027 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbaFMKRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 06:17:45 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/3] f2fs: recover fallocated data and its i_size together
Date: Fri, 13 Jun 2014 19:17:45 +0900
Message-Id: <1402654666-81383-2-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1402654666-81383-1-git-send-email-jaegeuk@kernel.org>
References: <1402654666-81383-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch arranges the f2fs_locks to cover the fallocated data and its i_size.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/file.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 9c49c59..623df73 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -659,13 +659,13 @@ static int expand_inode_data(struct inode *inode, loff_t offset,
 	off_start = offset & (PAGE_CACHE_SIZE - 1);
 	off_end = (offset + len) & (PAGE_CACHE_SIZE - 1);
 
+	f2fs_lock_op(sbi);
+
 	for (index = pg_start; index <= pg_end; index++) {
 		struct dnode_of_data dn;
 
-		f2fs_lock_op(sbi);
 		set_new_dnode(&dn, inode, NULL, NULL, 0);
 		ret = f2fs_reserve_block(&dn, index);
-		f2fs_unlock_op(sbi);
 		if (ret)
 			break;
 
@@ -683,8 +683,9 @@ static int expand_inode_data(struct inode *inode, loff_t offset,
 		i_size_read(inode) < new_size) {
 		i_size_write(inode, new_size);
 		mark_inode_dirty(inode);
-		f2fs_write_inode(inode, NULL);
+		update_inode_page(inode);
 	}
+	f2fs_unlock_op(sbi);
 
 	return ret;
 }
-- 
1.8.5.2 (Apple Git-48)

