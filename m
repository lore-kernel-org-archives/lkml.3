Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbaFXGRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 02:17:31 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56767 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbaFXGR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 02:17:29 -0400
X-AuditID: cbfee61b-f79f86d00000144c-94-53a917f7bd87
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] f2fs: reduce region of f2fs_lock_op covered for better
 concurrency
Date: Tue, 24 Jun 2014 14:16:24 +0800
Message-id: <001701cf8f73$f8abe6a0$ea03b3e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+PcYSWE1UWf//HT1SFWa+8jlNa9A==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t9jQd3v4iuDDZasM7e4tq+RyeLJ+lnM
	FpcWuVvs2XuSxeLyrjlsDqwem1Z1snnsXvCZyaNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy
	Ns53LtjFVzH3YGUD4y7uLkZODgkBE4mprzvZIWwxiQv31rN1MXJxCAlMZ5TY29bPDuH8YJR4
	+XkWG0gVm4CKxPKO/0wgtoiAl8Sk/SdYQGxmgUyJe00zmEFsYYFIiZlPVzCC2CwCqhKr+p+C
	xXkFLCWerH/DBGELSvyYfA+qV0ti/c7jTBC2vMTmNW+ZIS5SkNhx9jUjxC49iS9zHrFD1IhL
	bDxyi2UCo8AsJKNmIRk1C8moWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIDu1n
	0jsYVzVYHGIU4GBU4uGNCFwRLMSaWFZcmXuIUYKDWUmE1/ILUIg3JbGyKrUoP76oNCe1+BCj
	NAeLkjjvwVbrQCGB9MSS1OzU1ILUIpgsEwenVAOjh5ZfYoFe7LwdjJPFDfJEp/h1PPExiJzx
	UydaX33i3vRylflC135ef5XTr3jb43xFbD/P6aCDVZ+5vdde2VFXYe8++7anm6hWLqPnpK+X
	mXa9eHP/fveBvPkLtpYrTVTsniiU9HT5bEbv9pZzx884K2tudWR3yndn8licVezo1By9xrJ/
	qbMSS3FGoqEWc1FxIgCjbQkVaQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In our rename process, region of f2fs_lock_op covered is too big as some of the
code like f2fs_empty_dir/f2fs_find_entry are not needed to protect by this lock.

So in the extreme case like doing checkpoint when we rename old inode to exist
inode in a large directory could cause lower concurrency.

Let's reduce the region of f2fs_lock_op to fix this.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/namei.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index f17e34c..143799d 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -394,8 +394,6 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			goto out_old;
 	}
 
-	f2fs_lock_op(sbi);
-
 	if (new_inode) {
 
 		err = -ENOTEMPTY;
@@ -408,6 +406,8 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		if (!new_entry)
 			goto out_dir;
 
+		f2fs_lock_op(sbi);
+
 		err = acquire_orphan_inode(sbi);
 		if (err)
 			goto put_out_dir;
@@ -439,9 +439,13 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		update_inode_page(old_inode);
 		update_inode_page(new_inode);
 	} else {
+		f2fs_lock_op(sbi);
+
 		err = f2fs_add_link(new_dentry, old_inode);
-		if (err)
+		if (err) {
+			f2fs_unlock_op(sbi);
 			goto out_dir;
+		}
 
 		if (old_dir_entry) {
 			inc_nlink(new_dir);
@@ -475,6 +479,7 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	return 0;
 
 put_out_dir:
+	f2fs_unlock_op(sbi);
 	kunmap(new_page);
 	f2fs_put_page(new_page, 0);
 out_dir:
@@ -482,7 +487,6 @@ out_dir:
 		kunmap(old_dir_page);
 		f2fs_put_page(old_dir_page, 0);
 	}
-	f2fs_unlock_op(sbi);
 out_old:
 	kunmap(old_page);
 	f2fs_put_page(old_page, 0);
-- 
1.7.9.5


