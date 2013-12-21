Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab3LUKEP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 05:04:15 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:15789 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab3LUKEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 05:04:12 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-2d-52b5679b04ae
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [f2fs-dev] [PATCH 3/3] f2fs: avoid to set wrong pino of inode when
 rename dir
Date: Sat, 21 Dec 2013 18:03:28 +0800
Message-id: <000201cefe33$ff3c9270$fdb5b750$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7+L4j6QBSI+mwzSCOC/KpLfyqINA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jAd3Z6VuDDG4sMre4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+PyrfXsBcd4Ku7u
	uM7ewDiVq4uRg0NCwETi9maXLkZOIFNM4sK99WxdjFwcQgKLGCXOrjzGCOH8YJT4v2MHI0gV
	m4CKxPKO/0wgtoiAosSG9xvYQWxmgUyJOa8ns4LYwgIREhsufGcDsVkEVCX6mk8zg9i8ApYS
	LUcfsUDYghI/Jt9jgejVkli/8zgThC0vsXnNW2aIixQkdpx9zQixS09i678eqF3iEhuP3GKZ
	wCgwC8moWUhGzUIyahaSlgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxggP5mfQOxlUN
	FocYBTgYlXh4JSK3BAmxJpYVV+YeYpTgYFYS4f0YujVIiDclsbIqtSg/vqg0J7X4EKM0B4uS
	OO/BVutAIYH0xJLU7NTUgtQimCwTB6dUA2PvDV3l+VumHHvH93/T8r76l81TDt3qcwrmm239
	mF+Yg33R4cjfjs9/vJ/sN+XWHmcJW/cL8jkrjHLiFy8q0jXbfbVxtk3p097D5UtmvrvSsM57
	pUqqV/Ce7X7n3Gsc9nC6tO6Jz5qyVDA06LfiRs/fqin8jzPOPH9m13zWK9lZaqXMxFMW6ycp
	sRRnJBpqMRcVJwIA67fabWACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we rename a dir to new name which is not exist previous,
we will set pino of parent inode with ino of child inode in f2fs_set_link.
It destroy consistency of pino, it should be fixed.

Thanks for previous work of Shu Tan.

Signed-off-by: Shu Tan <shu.tan@samsung.com>
Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/dir.c   |    3 ---
 fs/f2fs/namei.c |    2 ++
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index c6c9280..b1b32ea 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -256,9 +256,6 @@ void f2fs_set_link(struct inode *dir, struct f2fs_dir_entry *de,
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
 	mark_inode_dirty(dir);
 
-	/* update parent inode number before releasing dentry page */
-	F2FS_I(inode)->i_pino = dir->i_ino;
-
 	f2fs_put_page(page, 1);
 }
 
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 575adac..a68838d 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -424,6 +424,7 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		}
 
 		f2fs_set_link(new_dir, new_entry, new_page, old_inode);
+		F2FS_I(old_inode)->i_pino = new_dir->i_ino;
 
 		new_inode->i_ctime = CURRENT_TIME;
 		if (old_dir_entry)
@@ -457,6 +458,7 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		if (old_dir != new_dir) {
 			f2fs_set_link(old_inode, old_dir_entry,
 						old_dir_page, new_dir);
+			F2FS_I(old_inode)->i_pino = new_dir->i_ino;
 		} else {
 			kunmap(old_dir_page);
 			f2fs_put_page(old_dir_page, 0);
-- 
1.7.9.5

