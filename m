Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbaGGDWv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 23:22:51 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:8684 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbaGGDWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 23:22:49 -0400
X-AuditID: cbfee61a-f79e46d00000134f-06-53ba1287b666
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH] f2fs: use inner macro and function to clean up codes
Date: Mon, 07 Jul 2014 11:21:59 +0800
Message-id: <006201cf9992$b98c7a60$2ca56f20$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+ZiyxswPJ/WWfWQP285OrR6S80EQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t9jAd12oV3BBhvvi1hc29fIZPFk/Sxm
	i0uL3C327D3JYnF51xw2B1aPTas62Tx2L/jM5NG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
	K1ZcZi3olKo4NX8hSwPjGtEuRk4OCQETiebVp5kgbDGJC/fWs3UxcnEICSxilGjaNI8ZwvnB
	KPFrzR9mkCo2ARWJ5R3/wTpEBLwkJu0/wQJiMwtkStxrmgFWIyzgL9H4bjcjiM0ioCqxbdlh
	sBpeAUuJmws+sEPYghI/Jt+D6tWSWL/zOBOELS+xec1bZoiLFCR2nH3NCLFLT+LYmm1sEDXi
	EhuP3GKZwCgwC8moWUhGzUIyahaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgsP7
	mdQOxpUNFocYBTgYlXh4D6zaGSzEmlhWXJl7iFGCg1lJhPeMG1CINyWxsiq1KD++qDQntfgQ
	ozQHi5I474FW60AhgfTEktTs1NSC1CKYLBMHp1QDo5KM4+yWMs3ImM4k+XMZ4cI7lZkZph6a
	X3nf93A1f//ke3kvF2bd0tuyQ83sRH6D7XTn4mqN87Ibtu3+WfN2cQeTz/r1AY+a88zuPelW
	fN50K3dtQ8eLN8bGSySu2Z268/3S3WPsx7mdnwVxMLR/CNS89m3ytIKP15qUap34Los7RXyZ
	femDmBJLcUaioRZzUXEiAIbKRiJrAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patch we use below inner macro and function to clean up codes.
1. ADDRS_PER_PAGE
2. SM_I
3. f2fs_readonly

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/file.c    | 3 +--
 fs/f2fs/segment.c | 9 ++++-----
 fs/f2fs/super.c   | 7 +++----
 3 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 36fa505..7c652b3 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -272,8 +272,7 @@ static loff_t f2fs_seek_block(struct file *file, loff_t offset, int whence)
 			}
 		}
 
-		end_offset = IS_INODE(dn.node_page) ?
-			ADDRS_PER_INODE(F2FS_I(inode)) : ADDRS_PER_BLOCK;
+		end_offset = ADDRS_PER_PAGE(dn.node_page, F2FS_I(inode));
 
 		/* find data/hole in dnode block */
 		for (; dn.ofs_in_node < end_offset;
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index a4f8375..8a6e57d 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -272,13 +272,13 @@ int create_flush_cmd_control(struct f2fs_sb_info *sbi)
 		return -ENOMEM;
 	spin_lock_init(&fcc->issue_lock);
 	init_waitqueue_head(&fcc->flush_wait_queue);
-	sbi->sm_info->cmd_control_info = fcc;
+	SM_I(sbi)->cmd_control_info = fcc;
 	fcc->f2fs_issue_flush = kthread_run(issue_flush_thread, sbi,
 				"f2fs_flush-%u:%u", MAJOR(dev), MINOR(dev));
 	if (IS_ERR(fcc->f2fs_issue_flush)) {
 		err = PTR_ERR(fcc->f2fs_issue_flush);
 		kfree(fcc);
-		sbi->sm_info->cmd_control_info = NULL;
+		SM_I(sbi)->cmd_control_info = NULL;
 		return err;
 	}
 
@@ -287,13 +287,12 @@ int create_flush_cmd_control(struct f2fs_sb_info *sbi)
 
 void destroy_flush_cmd_control(struct f2fs_sb_info *sbi)
 {
-	struct flush_cmd_control *fcc =
-				sbi->sm_info->cmd_control_info;
+	struct flush_cmd_control *fcc = SM_I(sbi)->cmd_control_info;
 
 	if (fcc && fcc->f2fs_issue_flush)
 		kthread_stop(fcc->f2fs_issue_flush);
 	kfree(fcc);
-	sbi->sm_info->cmd_control_info = NULL;
+	SM_I(sbi)->cmd_control_info = NULL;
 }
 
 static void __locate_dirty_segment(struct f2fs_sb_info *sbi, unsigned int segno,
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index bed9413..5800e5c 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -615,7 +615,7 @@ static int f2fs_remount(struct super_block *sb, int *flags, char *data)
 	 * Previous and new state of filesystem is RO,
 	 * so skip checking GC and FLUSH_MERGE conditions.
 	 */
-	if ((sb->s_flags & MS_RDONLY) && (*flags & MS_RDONLY))
+	if (f2fs_readonly(sb) && (*flags & MS_RDONLY))
 		goto skip;
 
 	/*
@@ -642,8 +642,7 @@ static int f2fs_remount(struct super_block *sb, int *flags, char *data)
 	 */
 	if ((*flags & MS_RDONLY) || !test_opt(sbi, FLUSH_MERGE)) {
 		destroy_flush_cmd_control(sbi);
-	} else if (test_opt(sbi, FLUSH_MERGE) &&
-					!sbi->sm_info->cmd_control_info) {
+	} else if (test_opt(sbi, FLUSH_MERGE) && !SM_I(sbi)->cmd_control_info) {
 		err = create_flush_cmd_control(sbi);
 		if (err)
 			goto restore_gc;
@@ -1082,7 +1081,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	 * If filesystem is not mounted as read-only then
 	 * do start the gc_thread.
 	 */
-	if (!(sb->s_flags & MS_RDONLY)) {
+	if (!f2fs_readonly(sb)) {
 		/* After POR, we can run background GC thread.*/
 		err = start_gc_thread(sbi);
 		if (err)
-- 
2.0.0.257.g75cc6c6


