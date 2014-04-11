Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbaDKKAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 06:00:53 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:52436 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756686AbaDKJ7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 05:59:40 -0400
X-IronPort-AV: E=Sophos;i="4.97,841,1389715200"; 
   d="scan'208";a="29145760"
Message-ID: <5347BAD2.2040003@cn.fujitsu.com>
Date: Fri, 11 Apr 2014 17:50:10 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/7] f2fs: introduce help function {create,destroy}_flush_cmd_control
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce help function {create,destroy}_flush_cmd_control to clean up
the create/destory flush merge operation.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/f2fs.h    |    3 +-
 fs/f2fs/segment.c |   55 ++++++++++++++++++++++++++++++++++++----------------
 fs/f2fs/super.c   |   29 ++-------------------------
 3 files changed, 43 insertions(+), 44 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 780d7e2..863fde5 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1178,8 +1178,9 @@ void destroy_node_manager_caches(void);
  */
 void f2fs_balance_fs(struct f2fs_sb_info *);
 void f2fs_balance_fs_bg(struct f2fs_sb_info *);
-int issue_flush_thread(void *);
 int f2fs_issue_flush(struct f2fs_sb_info *);
+int create_flush_cmd_control(struct f2fs_sb_info *);
+void destroy_flush_cmd_control(struct f2fs_sb_info *);
 void invalidate_blocks(struct f2fs_sb_info *, block_t);
 void refresh_sit_entry(struct f2fs_sb_info *, block_t, block_t);
 void clear_prefree_segments(struct f2fs_sb_info *);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 2f9ead7..8458943 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -197,7 +197,7 @@ void f2fs_balance_fs_bg(struct f2fs_sb_info *sbi)
 		f2fs_sync_fs(sbi->sb, true);
 }
 
-int issue_flush_thread(void *data)
+static int issue_flush_thread(void *data)
 {
 	struct f2fs_sb_info *sbi = data;
 	struct flush_cmd_control *fcc_i = SM_I(sbi)->cmd_control_info;
@@ -263,6 +263,41 @@ int f2fs_issue_flush(struct f2fs_sb_info *sbi)
 	return ret;
 }
 
+int create_flush_cmd_control(struct f2fs_sb_info *sbi)
+{
+	dev_t dev = sbi->sb->s_bdev->bd_dev;
+	struct flush_cmd_control *fcc_i;
+	int err = 0;
+
+	fcc_i = kzalloc(sizeof(struct flush_cmd_control), GFP_KERNEL);
+	if (!fcc_i)
+		return -ENOMEM;
+	spin_lock_init(&fcc_i->issue_lock);
+	init_waitqueue_head(&fcc_i->flush_wait_queue);
+	fcc_i->f2fs_issue_flush = kthread_run(issue_flush_thread, sbi,
+				"f2fs_flush-%u:%u", MAJOR(dev), MINOR(dev));
+	if (IS_ERR(fcc_i->f2fs_issue_flush)) {
+		err = PTR_ERR(fcc_i->f2fs_issue_flush);
+		kfree(fcc_i);
+		return err;
+	}
+	sbi->sm_info->cmd_control_info = fcc_i;
+
+	return err;
+}
+
+void destroy_flush_cmd_control(struct f2fs_sb_info *sbi)
+{
+	struct flush_cmd_control *fcc_i =
+				sbi->sm_info->cmd_control_info;
+	if (!fcc_i)
+		return;
+
+	if (fcc_i->f2fs_issue_flush)
+		kthread_stop(fcc_i->f2fs_issue_flush);
+	kfree(fcc_i);
+}
+
 static void __locate_dirty_segment(struct f2fs_sb_info *sbi, unsigned int segno,
 		enum dirty_type dirty_type)
 {
@@ -1831,7 +1866,6 @@ int build_segment_manager(struct f2fs_sb_info *sbi)
 {
 	struct f2fs_super_block *raw_super = F2FS_RAW_SUPER(sbi);
 	struct f2fs_checkpoint *ckpt = F2FS_CKPT(sbi);
-	dev_t dev = sbi->sb->s_bdev->bd_dev;
 	struct f2fs_sm_info *sm_info;
 	int err;
 
@@ -1860,22 +1894,9 @@ int build_segment_manager(struct f2fs_sb_info *sbi)
 	sm_info->max_discards = 0;
 
 	if (test_opt(sbi, FLUSH_MERGE) && !f2fs_readonly(sbi->sb)) {
-		struct flush_cmd_control *fcc_i =
-			kzalloc(sizeof(struct flush_cmd_control), GFP_KERNEL);
-
-		if (!fcc_i)
-			return -ENOMEM;
-		spin_lock_init(&fcc_i->issue_lock);
-		init_waitqueue_head(&fcc_i->flush_wait_queue);
-
-		fcc_i->f2fs_issue_flush = kthread_run(issue_flush_thread, sbi,
-				"f2fs_flush-%u:%u", MAJOR(dev), MINOR(dev));
-		if (IS_ERR(fcc_i->f2fs_issue_flush)) {
-			err = PTR_ERR(fcc_i->f2fs_issue_flush);
-			kfree(fcc_i);
+		err = create_flush_cmd_control(sbi);
+		if (err)
 			return err;
-		}
-		sm_info->cmd_control_info = fcc_i;
 	}
 
 	err = build_sit_info(sbi);
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 4d562fb..b2b1863 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -641,35 +641,12 @@ static int f2fs_remount(struct super_block *sb, int *flags, char *data)
 	 * or if flush_merge is not passed in mount option.
 	 */
 	if ((*flags & MS_RDONLY) || !test_opt(sbi, FLUSH_MERGE)) {
-		struct flush_cmd_control *fcc_i =
-					sbi->sm_info->cmd_control_info;
-
-		if (fcc_i) {
-			if (fcc_i->f2fs_issue_flush)
-				kthread_stop(fcc_i->f2fs_issue_flush);
-			fcc_i->issue_list = fcc_i->dispatch_list = NULL;
-			fcc_i->f2fs_issue_flush = NULL;
-		}
+		destroy_flush_cmd_control(sbi);
 	} else if (test_opt(sbi, FLUSH_MERGE) &&
 					!sbi->sm_info->cmd_control_info) {
-		dev_t dev = sbi->sb->s_bdev->bd_dev;
-		struct flush_cmd_control *fcc_i =
-			kzalloc(sizeof(struct flush_cmd_control), GFP_KERNEL);
-
-		if (!fcc_i) {
-			err = -ENOMEM;
-			goto restore_gc;
-		}
-		spin_lock_init(&fcc_i->issue_lock);
-		init_waitqueue_head(&fcc_i->flush_wait_queue);
-		fcc_i->f2fs_issue_flush = kthread_run(issue_flush_thread, sbi,
-				"f2fs_flush-%u:%u", MAJOR(dev), MINOR(dev));
-		if (IS_ERR(fcc_i->f2fs_issue_flush)) {
-			err = PTR_ERR(fcc_i->f2fs_issue_flush);
-			kfree(fcc_i);
+		err = create_flush_cmd_control(sbi);
+		if (err)
 			goto restore_gc;
-		}
-		sbi->sm_info->cmd_control_info = fcc_i;
 	}
 skip:
 	/* Update the POSIXACL Flag */
-- 
1.7.7


