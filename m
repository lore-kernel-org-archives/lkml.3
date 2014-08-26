Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934433AbaHZKgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:36:14 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33979 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbaHZKgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:36:13 -0400
X-AuditID: cbfee61b-f79f86d00000144c-a9-53fc631b446d
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH] f2fs: reposition unlock_new_inode to prevent
 accessing invalid inode
Date: Tue, 26 Aug 2014 18:35:29 +0800
Message-id: <009101cfc119$8e7a5a00$ab6f0e00$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac/BD5RCYqgxKWCGR7aF2zZfPhVCfw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsVy+t9jQV3p5D/BBndfSFg8WT+L2eLSIneL
	y7vmsDkwe2xa1cnmsXvBZyaPz5vkApijuGxSUnMyy1KL9O0SuDKu3NvFUnBZuOL08t9sDYzX
	+bsYOTkkBEwkpjyfzQRhi0lcuLeeDcQWEpjOKDFlsnYXIxeQ/YNR4lL/LFaQBJuAisTyjv9g
	DSJA9qFFl9lBbGYBD4nGju9gNcICiRKTt50BG8QioCqx/tATZhCbV8BSovHOZ0YIW1Dix+R7
	LBC9WhLrdx5ngrDlJTavecsMcZCCxI6zrxkhdulJ3Lx5nhmiRlxi45FbLBMYBWYhGTULyahZ
	SEbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZw+D6T3sG4qsHiEKMAB6MSD++N
	+N/BQqyJZcWVuYcYJTiYlUR4H0b/CRbiTUmsrEotyo8vKs1JLT7EKM3BoiTOe7DVOlBIID2x
	JDU7NbUgtQgmy8TBKdXAyD3Le/YB7tDV/0SUK5Vm+igdM3g6W/JJyM72jVzeYnzVe04e/6fi
	8OLPN6EuI6/Ik+9L1k3ocuO4aXHb5qfBl5bp1zjnpUxXKhbdZ6pp+ePr2+T8s2u+X1RkN2DO
	O570MVMr5+cZrynLI5wOVDPu7iuQV89fq/5gilr4Yf7lxfsfPokvWF0cqMRSnJFoqMVcVJwI
	AFY1W/tbAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the race condition on the inode cache, following scenario can appear:
[Thread a]				[Thread b]
					->f2fs_mkdir
					  ->f2fs_add_link
					    ->__f2fs_add_link
					      ->init_inode_metadata failed here
->gc_thread_func
  ->f2fs_gc
    ->do_garbage_collect
      ->gc_data_segment
        ->f2fs_iget
          ->iget_locked
            ->wait_on_inode
					  ->unlock_new_inode
        ->move_data_page
					  ->make_bad_inode
					  ->iput

When we fail in create/symlink/mkdir/mknod/tmpfile, the new allocated inode
should be set as bad to avoid being accessed by other thread. But in above
scenario, it allows f2fs to access the invalid inode before this inode was set
as bad.
This patch fix the potential problem, and this issue was found by code review.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/namei.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 6b53ce9..845f1be 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -134,8 +134,8 @@ static int f2fs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 	return 0;
 out:
 	clear_nlink(inode);
-	unlock_new_inode(inode);
 	make_bad_inode(inode);
+	unlock_new_inode(inode);
 	iput(inode);
 	alloc_nid_failed(sbi, ino);
 	return err;
@@ -267,8 +267,8 @@ static int f2fs_symlink(struct inode *dir, struct dentry *dentry,
 	return err;
 out:
 	clear_nlink(inode);
-	unlock_new_inode(inode);
 	make_bad_inode(inode);
+	unlock_new_inode(inode);
 	iput(inode);
 	alloc_nid_failed(sbi, inode->i_ino);
 	return err;
@@ -308,8 +308,8 @@ static int f2fs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 out_fail:
 	clear_inode_flag(F2FS_I(inode), FI_INC_LINK);
 	clear_nlink(inode);
-	unlock_new_inode(inode);
 	make_bad_inode(inode);
+	unlock_new_inode(inode);
 	iput(inode);
 	alloc_nid_failed(sbi, inode->i_ino);
 	return err;
@@ -354,8 +354,8 @@ static int f2fs_mknod(struct inode *dir, struct dentry *dentry,
 	return 0;
 out:
 	clear_nlink(inode);
-	unlock_new_inode(inode);
 	make_bad_inode(inode);
+	unlock_new_inode(inode);
 	iput(inode);
 	alloc_nid_failed(sbi, inode->i_ino);
 	return err;
@@ -688,8 +688,8 @@ release_out:
 out:
 	f2fs_unlock_op(sbi);
 	clear_nlink(inode);
-	unlock_new_inode(inode);
 	make_bad_inode(inode);
+	unlock_new_inode(inode);
 	iput(inode);
 	alloc_nid_failed(sbi, inode->i_ino);
 	return err;
-- 
2.0.0.421.g786a89d


