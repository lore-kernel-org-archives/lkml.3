Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645AbaDKJ7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 05:59:43 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:4747 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932446AbaDKJ7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 05:59:36 -0400
X-IronPort-AV: E=Sophos;i="4.97,841,1389715200"; 
   d="scan'208";a="29145756"
Message-ID: <5347BACD.8030004@cn.fujitsu.com>
Date: Fri, 11 Apr 2014 17:50:05 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/7] f2fs: introduce struct flush_cmd_control to wrap the,
 flush_merge fields
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the flush_merge fields from sm_i, and use the new struct flush_cmd_control
to wrap it, so that we can igonre these fileds if flush_merge is disable, and
it alse can the structs more neat.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/f2fs.h    |   14 +++++++----
 fs/f2fs/segment.c |   68 ++++++++++++++++++++++++++++++++--------------------
 fs/f2fs/super.c   |   44 +++++++++++++++++++--------------
 3 files changed, 76 insertions(+), 50 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 1130f9c..780d7e2 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -323,6 +323,14 @@ struct flush_cmd {
 	int ret;
 };
 
+struct flush_cmd_control {
+	struct task_struct *f2fs_issue_flush;	/* flush thread */
+	wait_queue_head_t flush_wait_queue;	/* waiting queue for wake-up */
+	struct flush_cmd *issue_list;		/* list for command issue */
+	struct flush_cmd *dispatch_list;	/* list for command dispatch */
+	spinlock_t issue_lock;			/* for issue list lock */
+};
+
 struct f2fs_sm_info {
 	struct sit_info *sit_info;		/* whole segment information */
 	struct free_segmap_info *free_info;	/* free segment information */
@@ -353,11 +361,7 @@ struct f2fs_sm_info {
 	unsigned int min_ipu_util;	/* in-place-update threshold */
 
 	/* for flush command control */
-	struct task_struct *f2fs_issue_flush;	/* flush thread */
-	wait_queue_head_t flush_wait_queue;	/* waiting queue for wake-up */
-	struct flush_cmd *issue_list;		/* list for command issue */
-	struct flush_cmd *dispatch_list;	/* list for command dispatch */
-	spinlock_t issue_lock;			/* for issue list lock */
+	struct flush_cmd_control *cmd_control_info;
 };
 
 /*
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 5c30255..2f9ead7 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -200,20 +200,20 @@ void f2fs_balance_fs_bg(struct f2fs_sb_info *sbi)
 int issue_flush_thread(void *data)
 {
 	struct f2fs_sb_info *sbi = data;
-	struct f2fs_sm_info *sm_i = SM_I(sbi);
-	wait_queue_head_t *q = &sm_i->flush_wait_queue;
+	struct flush_cmd_control *fcc_i = SM_I(sbi)->cmd_control_info;
+	wait_queue_head_t *q = &fcc_i->flush_wait_queue;
 repeat:
 	if (kthread_should_stop())
 		return 0;
 
-	spin_lock(&sm_i->issue_lock);
-	if (sm_i->issue_list) {
-		sm_i->dispatch_list = sm_i->issue_list;
-		sm_i->issue_list = NULL;
+	spin_lock(&fcc_i->issue_lock);
+	if (fcc_i->issue_list) {
+		fcc_i->dispatch_list = fcc_i->issue_list;
+		fcc_i->issue_list = NULL;
 	}
-	spin_unlock(&sm_i->issue_lock);
+	spin_unlock(&fcc_i->issue_lock);
 
-	if (sm_i->dispatch_list) {
+	if (fcc_i->dispatch_list) {
 		struct bio *bio = bio_alloc(GFP_NOIO, 0);
 		struct flush_cmd *cmd, *next;
 		int ret;
@@ -221,22 +221,23 @@ repeat:
 		bio->bi_bdev = sbi->sb->s_bdev;
 		ret = submit_bio_wait(WRITE_FLUSH, bio);
 
-		for (cmd = sm_i->dispatch_list; cmd; cmd = next) {
+		for (cmd = fcc_i->dispatch_list; cmd; cmd = next) {
 			cmd->ret = ret;
 			next = cmd->next;
 			complete(&cmd->wait);
 		}
 		bio_put(bio);
-		sm_i->dispatch_list = NULL;
+		fcc_i->dispatch_list = NULL;
 	}
 
-	wait_event_interruptible(*q, kthread_should_stop() || sm_i->issue_list);
+	wait_event_interruptible(*q,
+			kthread_should_stop() || fcc_i->issue_list);
 	goto repeat;
 }
 
 int f2fs_issue_flush(struct f2fs_sb_info *sbi)
 {
-	struct f2fs_sm_info *sm_i = SM_I(sbi);
+	struct flush_cmd_control *fcc_i = SM_I(sbi)->cmd_control_info;
 	struct flush_cmd *cmd;
 	int ret;
 
@@ -246,15 +247,15 @@ int f2fs_issue_flush(struct f2fs_sb_info *sbi)
 	cmd = f2fs_kmem_cache_alloc(flush_cmd_slab, GFP_ATOMIC | __GFP_ZERO);
 	init_completion(&cmd->wait);
 
-	spin_lock(&sm_i->issue_lock);
-	if (sm_i->issue_list)
-		sm_i->issue_list->next = cmd;
+	spin_lock(&fcc_i->issue_lock);
+	if (fcc_i->issue_list)
+		fcc_i->issue_list->next = cmd;
 	else
-		sm_i->issue_list = cmd;
-	spin_unlock(&sm_i->issue_lock);
+		fcc_i->issue_list = cmd;
+	spin_unlock(&fcc_i->issue_lock);
 
-	if (!sm_i->dispatch_list)
-		wake_up(&sm_i->flush_wait_queue);
+	if (!fcc_i->dispatch_list)
+		wake_up(&fcc_i->flush_wait_queue);
 
 	wait_for_completion(&cmd->wait);
 	ret = cmd->ret;
@@ -1859,12 +1860,22 @@ int build_segment_manager(struct f2fs_sb_info *sbi)
 	sm_info->max_discards = 0;
 
 	if (test_opt(sbi, FLUSH_MERGE) && !f2fs_readonly(sbi->sb)) {
-		spin_lock_init(&sm_info->issue_lock);
-		init_waitqueue_head(&sm_info->flush_wait_queue);
-		sm_info->f2fs_issue_flush = kthread_run(issue_flush_thread, sbi,
+		struct flush_cmd_control *fcc_i =
+			kzalloc(sizeof(struct flush_cmd_control), GFP_KERNEL);
+
+		if (!fcc_i)
+			return -ENOMEM;
+		spin_lock_init(&fcc_i->issue_lock);
+		init_waitqueue_head(&fcc_i->flush_wait_queue);
+
+		fcc_i->f2fs_issue_flush = kthread_run(issue_flush_thread, sbi,
 				"f2fs_flush-%u:%u", MAJOR(dev), MINOR(dev));
-		if (IS_ERR(sm_info->f2fs_issue_flush))
-			return PTR_ERR(sm_info->f2fs_issue_flush);
+		if (IS_ERR(fcc_i->f2fs_issue_flush)) {
+			err = PTR_ERR(fcc_i->f2fs_issue_flush);
+			kfree(fcc_i);
+			return err;
+		}
+		sm_info->cmd_control_info = fcc_i;
 	}
 
 	err = build_sit_info(sbi);
@@ -1973,10 +1984,15 @@ static void destroy_sit_info(struct f2fs_sb_info *sbi)
 void destroy_segment_manager(struct f2fs_sb_info *sbi)
 {
 	struct f2fs_sm_info *sm_info = SM_I(sbi);
+	struct flush_cmd_control *fcc_i;
+
 	if (!sm_info)
 		return;
-	if (sm_info->f2fs_issue_flush)
-		kthread_stop(sm_info->f2fs_issue_flush);
+	fcc_i = sm_info->cmd_control_info;
+	if (fcc_i) {
+		kthread_stop(fcc_i->f2fs_issue_flush);
+		kfree(fcc_i);
+	}
 	destroy_dirty_segmap(sbi);
 	destroy_curseg(sbi);
 	destroy_free_segmap(sbi);
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index bea642a..4d562fb 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -641,29 +641,35 @@ static int f2fs_remount(struct super_block *sb, int *flags, char *data)
 	 * or if flush_merge is not passed in mount option.
 	 */
 	if ((*flags & MS_RDONLY) || !test_opt(sbi, FLUSH_MERGE)) {
-		struct f2fs_sm_info *sm_info = sbi->sm_info;
+		struct flush_cmd_control *fcc_i =
+					sbi->sm_info->cmd_control_info;
 
-		if (sm_info->f2fs_issue_flush)
-			kthread_stop(sm_info->f2fs_issue_flush);
-		sm_info->issue_list = sm_info->dispatch_list = NULL;
-		sm_info->f2fs_issue_flush = NULL;
-	} else if (test_opt(sbi, FLUSH_MERGE)) {
-		struct f2fs_sm_info *sm_info = sbi->sm_info;
-
-		if (!sm_info->f2fs_issue_flush) {
-			dev_t dev = sbi->sb->s_bdev->bd_dev;
+		if (fcc_i) {
+			if (fcc_i->f2fs_issue_flush)
+				kthread_stop(fcc_i->f2fs_issue_flush);
+			fcc_i->issue_list = fcc_i->dispatch_list = NULL;
+			fcc_i->f2fs_issue_flush = NULL;
+		}
+	} else if (test_opt(sbi, FLUSH_MERGE) &&
+					!sbi->sm_info->cmd_control_info) {
+		dev_t dev = sbi->sb->s_bdev->bd_dev;
+		struct flush_cmd_control *fcc_i =
+			kzalloc(sizeof(struct flush_cmd_control), GFP_KERNEL);
 
-			spin_lock_init(&sm_info->issue_lock);
-			init_waitqueue_head(&sm_info->flush_wait_queue);
-			sm_info->f2fs_issue_flush =
-				kthread_run(issue_flush_thread, sbi,
+		if (!fcc_i) {
+			err = -ENOMEM;
+			goto restore_gc;
+		}
+		spin_lock_init(&fcc_i->issue_lock);
+		init_waitqueue_head(&fcc_i->flush_wait_queue);
+		fcc_i->f2fs_issue_flush = kthread_run(issue_flush_thread, sbi,
 				"f2fs_flush-%u:%u", MAJOR(dev), MINOR(dev));
-			if (IS_ERR(sm_info->f2fs_issue_flush)) {
-				err = PTR_ERR(sm_info->f2fs_issue_flush);
-				sm_info->f2fs_issue_flush = NULL;
-				goto restore_gc;
-			}
+		if (IS_ERR(fcc_i->f2fs_issue_flush)) {
+			err = PTR_ERR(fcc_i->f2fs_issue_flush);
+			kfree(fcc_i);
+			goto restore_gc;
 		}
+		sbi->sm_info->cmd_control_info = fcc_i;
 	}
 skip:
 	/* Update the POSIXACL Flag */
-- 
1.7.7

