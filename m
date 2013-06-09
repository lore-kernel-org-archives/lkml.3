Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab3FIXM3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 19:12:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22145 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab3FIXM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 19:12:27 -0400
X-AuditID: cbfee68f-b7f436d000000f81-51-51b50bd9a9b6
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: sync dir->i_size with its block allocation
Date: Mon, 10 Jun 2013 08:11:05 +0900
Message-id: <1370819465-28653-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t8zY92b3FsDDb5tNrG4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+PWC+uCb+IVJw5E
	NDCuEu5i5OSQEDCRmP/7CSOELSZx4d56ti5GLg4hgWWMEh+2dTHDFN398J8FIjGdUaKn+TMj
	hNPGJHG+8zpQFQcHm4C2xOb9BiANIgLMEgumngerYRaYwCjxf9F7FpCEsICjxK4XD9hAbBYB
	VYmmhgmsIDavgLtE35MX7BDbdCVW/3/ODtIsIXCbTeLx1InsEA0CEt8mH2IBWSYhICux6QDU
	dZISB1fcYJnAKLiAkWEVo2hqQXJBcVJ6kbFecWJucWleul5yfu4mRkgA9u9gvHvA+hBjMtC4
	icxSosn5wADOK4k3NDYzsjA1MTU2Mrc0I01YSZxXrcU6UEggPbEkNTs1tSC1KL6oNCe1+BAj
	EwenVAPjimnFGWZMNxMO7ZEv2Zd/71p74WQTdxPZm6vYoxPmvC2ZU+t9y3ZRaJqlunmWUOLu
	pcwuucmnzzHfe76wgHdtmrbGYwlVTe/k+Cvim4ol9y7IfFLgt2zDFrnr7yd+v7XzloRBw+S0
	s2qcSi9vvQg4w/Zumu+VvbKFfTbGrY57Oz3XR+z+tUJfiaU4I9FQi7moOBEAOD4LPlYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsVy+t9jQd2b3FsDDV5v0Le4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjHj1gvrgm/iFScORDQwrhLuYuTkkBAwkbj74T8LhC0mceHeerYuRi4OIYHp
	jBI9zZ8ZIZw2JonzndeZuxg5ONgEtCU27zcAaRARYJZYMPU8WA2zwARGif+L3oNNEhZwlNj1
	4gEbiM0ioCrR1DCBFcTmFXCX6Hvygh1im67E6v/P2Scwci9gZFjFKJpakFxQnJSea6hXnJhb
	XJqXrpecn7uJERzez6R2MK5ssDjEKMDBqMTD++DXlkAh1sSy4srcQ4wSHMxKIrwFTUAh3pTE
	yqrUovz4otKc1OJDjMlA2ycyS4km5wNjL68k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJ
	JanZqakFqUUwW5g4OKUaGLtSWy5HdatbKj/LMY9bLScoYj/x+Ebz/oybt89m//e2iA7+rzvl
	kVTctbtlr85G32dbt7T0JMuFzUqmN5XFGU7s9195rXnZwkNzw9IZNJ49N4+641oYff2U6wJd
	zYUn/GR5vVfI6av4qfCsaGDnXfpC4UTKSxF59SWy29daJNnuCVCL5xWIVmIpzkg01GIuKk4E
	ANpfQr6zAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If new dentry block is allocated and its i_size is updated, we should update
its inode block together in order to sync i_size and its block allocation.
Otherwise, we can loose additional dentry block due to the unconsistent i_size.

Errorneous Scenario
-------------------

In the recovery routine,
 - recovery_dentry
 | - __f2fs_add_link
 | | - get_new_data_page
 | | | - i_size_write(new_i_size)
 | | | - mark_inode_dirty_sync(dir)
 | | - update_parent_metadata
 | | | - mark_inode_dirty(dir)
 |
 - write_checkpoint
   - sync_dirty_dir_inodes
     - filemap_flush(dentry_blocks)
       - f2fs_write_data_page
         - skip to write the last dentry block due to index < i_size

In the above flow, new_i_size is not updated to its inode block so that the
last dentry block will be lost accordingly.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c | 2 ++
 fs/f2fs/dir.c  | 9 ++++-----
 fs/f2fs/f2fs.h | 1 +
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 93917e3..5b145fc 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -339,6 +339,8 @@ repeat:
 	if (new_i_size &&
 		i_size_read(inode) < ((index + 1) << PAGE_CACHE_SHIFT)) {
 		i_size_write(inode, ((index + 1) << PAGE_CACHE_SHIFT));
+		/* Only the directory inode sets new_i_size */
+		set_inode_flag(F2FS_I(inode), FI_UPDATE_DIR);
 		mark_inode_dirty_sync(inode);
 	}
 	return page;
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 81a1d6f..b72b274 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -370,22 +370,20 @@ error:
 static void update_parent_metadata(struct inode *dir, struct inode *inode,
 						unsigned int current_depth)
 {
-	bool need_dir_update = false;
-
 	if (is_inode_flag_set(F2FS_I(inode), FI_NEW_INODE)) {
 		if (S_ISDIR(inode->i_mode)) {
 			inc_nlink(dir);
-			need_dir_update = true;
+			set_inode_flag(F2FS_I(dir), FI_UPDATE_DIR);
 		}
 		clear_inode_flag(F2FS_I(inode), FI_NEW_INODE);
 	}
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
 	if (F2FS_I(dir)->i_current_depth != current_depth) {
 		F2FS_I(dir)->i_current_depth = current_depth;
-		need_dir_update = true;
+		set_inode_flag(F2FS_I(dir), FI_UPDATE_DIR);
 	}
 
-	if (need_dir_update)
+	if (is_inode_flag_set(F2FS_I(inode), FI_UPDATE_DIR))
 		update_inode_page(dir);
 	else
 		mark_inode_dirty(dir);
@@ -502,6 +500,7 @@ add_dentry:
 
 	update_parent_metadata(dir, inode, current_depth);
 fail:
+	clear_inode_flag(F2FS_I(dir), FI_UPDATE_DIR);
 	kunmap(dentry_page);
 	f2fs_put_page(dentry_page, 1);
 	return err;
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index bfb97c9..091c688 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -859,6 +859,7 @@ enum {
 	FI_INC_LINK,		/* need to increment i_nlink */
 	FI_ACL_MODE,		/* indicate acl mode */
 	FI_NO_ALLOC,		/* should not allocate any blocks */
+	FI_UPDATE_DIR,		/* should update inode block for consistency */
 	FI_DELAY_IPUT,		/* used for the recovery */
 };
 
-- 
1.8.1.3.566.gaa39828

