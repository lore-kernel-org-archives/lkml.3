Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbaFGQpG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 12:45:06 -0400
Received: from mail.kernel.org ([198.145.19.201]:59918 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbaFGQpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 12:45:04 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 3/3] f2fs: avoid not to call remove_dirty_inode
Date: Sun,  8 Jun 2014 01:44:32 +0900
Message-Id: <1402159472-61137-3-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1402159472-61137-1-git-send-email-jaegeuk@kernel.org>
References: <1402159472-61137-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is an errorneous case during the recovery like below.

In recovery_dentry,
 1) dir = f2fs_iget();
 2) mark the dir with FI_DELAY_IPUT
 3) goto unmap_out

After the end of recovery routine, there is no dirty dentries so the dir cannot
be released by iput in remove_dirty_dir_inode.

This patch fixes such the bug case by handling the iget and iput in the
recovery_dentry procedure.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/recovery.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index e950a2f..a112368 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -52,20 +52,13 @@ static int recover_dentry(struct page *ipage, struct inode *inode)
 		goto out;
 	}
 
-	if (is_inode_flag_set(F2FS_I(dir), FI_DIRTY_DIR)) {
-		iput(dir);
-	} else {
-		add_dirty_dir_inode(dir);
-		set_inode_flag(F2FS_I(dir), FI_DELAY_IPUT);
-	}
-
 	name.len = le32_to_cpu(raw_inode->i_namelen);
 	name.name = raw_inode->i_name;
 
 	if (unlikely(name.len > F2FS_NAME_LEN)) {
 		WARN_ON(1);
 		err = -ENAMETOOLONG;
-		goto out;
+		goto out_err;
 	}
 retry:
 	de = f2fs_find_entry(dir, &name, &page);
@@ -90,11 +83,23 @@ retry:
 		goto retry;
 	}
 	err = __f2fs_add_link(dir, &name, inode);
+	if (err)
+		goto out_err;
+
+	if (is_inode_flag_set(F2FS_I(dir), FI_DELAY_IPUT)) {
+		iput(dir);
+	} else {
+		add_dirty_dir_inode(dir);
+		set_inode_flag(F2FS_I(dir), FI_DELAY_IPUT);
+	}
+
 	goto out;
 
 out_unmap_put:
 	kunmap(page);
 	f2fs_put_page(page, 0);
+out_err:
+	iput(dir);
 out:
 	f2fs_msg(inode->i_sb, KERN_NOTICE,
 			"%s: ino = %x, name = %s, dir = %lx, err = %d",
-- 
1.8.5.2 (Apple Git-48)

