Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204AbaH3BxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 21:53:22 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26707 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaH3BxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 21:53:21 -0400
X-AuditID: cbfee61a-f79e46d00000134f-8c-54012e8fd9c1
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH v2] f2fs: reposition unlock_new_inode to prevent
 accessing invalid inode
Date: Sat, 30 Aug 2014 09:52:34 +0800
Message-id: <000901cfc3f5$2baaee60$8300cb20$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac/D9OctQAolm5EXSF+AfxagWyGm+A==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jAd1+PcYQg3uNPBbX9jUyWTxZP4vZ
	4tIid4vLu+awObB4bFrVyeaxe8FnJo++LasYPT5vkgtgieKySUnNySxLLdK3S+DK6Nl9ga3g
	gXjF+pXfWRoY3wt1MXJySAiYSGyad5sNwhaTuHBvPZDNxSEksIhRom3NCSYI5wejxIvbD9hB
	qtgEVCSWd/xnArFFBLwkJu0/wQJiMwt4SDR2fGcFsYUFUiSuH3oJVs8ioCoxte87I4jNK2Ap
	ceV4OyuELSjxY/I9qF4tifU7jzNB2PISm9e8ZYa4SEFix9nXjBC79CQO3PvCCFEjLrHxyC2W
	CYwCs5CMmoVk1Cwko2YhaVnAyLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzion0ntYFzZ
	YHGIUYCDUYmH98JLhhAh1sSy4srcQ4wSHMxKIrxSj4FCvCmJlVWpRfnxRaU5qcWHGKU5WJTE
	eQ+0WgcKCaQnlqRmp6YWpBbBZJk4OKUaGCWingm1Gjzcn1G97qP5lut8/5v/ZSzImbEwbPeL
	lGvBdUHae+7c5E4uLDzA+yNVPI9lnfOTx4IZPEsem9nunbD8vzKf7aXuF4x7hYW2RixtW7Rl
	Qdhi52VVAqLO3UsmsxULrRFee41duV2ns7Nrbk7xultXN8YdEQu8Ev5a4A1Hb+KalhsREUos
	xRmJhlrMRcWJAPUf46BmAgAA
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

change log from v1:
 o Add condition judgment in gc_data_segment() suggested by Changman Lee.
 o use iget_failed to simplify code.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/gc.c    |  2 +-
 fs/f2fs/namei.c | 20 +++++---------------
 2 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index e8507b1..943a31d 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -593,7 +593,7 @@ next_step:
 
 		if (phase == 2) {
 			inode = f2fs_iget(sb, dni.ino);
-			if (IS_ERR(inode))
+			if (IS_ERR(inode) || is_bad_inode(inode))
 				continue;
 
 			start_bidx = start_bidx_of_node(nofs, F2FS_I(inode));
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 6b53ce9..ee103fd 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -134,9 +134,7 @@ static int f2fs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 	return 0;
 out:
 	clear_nlink(inode);
-	unlock_new_inode(inode);
-	make_bad_inode(inode);
-	iput(inode);
+	iget_failed(inode);
 	alloc_nid_failed(sbi, ino);
 	return err;
 }
@@ -267,9 +265,7 @@ static int f2fs_symlink(struct inode *dir, struct dentry *dentry,
 	return err;
 out:
 	clear_nlink(inode);
-	unlock_new_inode(inode);
-	make_bad_inode(inode);
-	iput(inode);
+	iget_failed(inode);
 	alloc_nid_failed(sbi, inode->i_ino);
 	return err;
 }
@@ -308,9 +304,7 @@ static int f2fs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 out_fail:
 	clear_inode_flag(F2FS_I(inode), FI_INC_LINK);
 	clear_nlink(inode);
-	unlock_new_inode(inode);
-	make_bad_inode(inode);
-	iput(inode);
+	iget_failed(inode);
 	alloc_nid_failed(sbi, inode->i_ino);
 	return err;
 }
@@ -354,9 +348,7 @@ static int f2fs_mknod(struct inode *dir, struct dentry *dentry,
 	return 0;
 out:
 	clear_nlink(inode);
-	unlock_new_inode(inode);
-	make_bad_inode(inode);
-	iput(inode);
+	iget_failed(inode);
 	alloc_nid_failed(sbi, inode->i_ino);
 	return err;
 }
@@ -688,9 +680,7 @@ release_out:
 out:
 	f2fs_unlock_op(sbi);
 	clear_nlink(inode);
-	unlock_new_inode(inode);
-	make_bad_inode(inode);
-	iput(inode);
+	iget_failed(inode);
 	alloc_nid_failed(sbi, inode->i_ino);
 	return err;
 }
-- 
2.0.1.474.g72c7794


