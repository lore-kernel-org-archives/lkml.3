Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab3JHIar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 04:30:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29291 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab3JHIan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 04:30:43 -0400
X-AuditID: cbfee6a3-b7f2e6d000006792-5f-5253c2b05aeb
Date: Tue, 08 Oct 2013 08:30:40 +0000 (GMT)
From: Yuan Zhong <yuan.mark.zhong@samsung.com>
Subject: [f2fs-dev] [PATCH v2] f2fs: avoid congestion_wait when do_checkpoint
 for better performance
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, shu.tan@samsung.com
Reply-to: yuan.mark.zhong@samsung.com
MIME-version: 1.0
X-MTR: 20131008082337652@yuan.mark.zhong
Msgkey: 20131008082337652@yuan.mark.zhong
X-EPLocale: en_US.windows-1252
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20131008082337652@yuan.mark.zhong
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <25944790.263941381221039729.JavaMail.weblogic@epml12>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t/t6bobDgUHGfyYLWZxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyXj0sLviiVvF381+mBsYPql2MnBxCAloS7388ZO5i5OCQEDCR
	uPHUECQsISAmceHeerYuRi6gkvmMEgtX9rKCJFgEVCSapz1lBrHZBPQl7uzbxwhiCwukSEy+
	tQysRkRAQWJy22ZmkGZmgWmMEtd3d7GDLBASUJU4vrYUpIZXQFDi5MwnLBDLNCSeTH3KBBHX
	lDh2fAMrRFxOYsnUy0wQNq/EjPanLDDxaV/XMEPY0hLnZ21ghDl68ffHUHF+iWO3dzBB/MUr
	8eR+MMyY3Zu/sEHYAhJTzxyEatWVOHP3FNQqPok1C9+ywIzZdWo5M0zv/S1zwWqYBRQlpnQ/
	ZIewDSSOLJrDiu4tXgEnia5zh9kmMMrNQpKahaR9FpJ2ZDULGFlWMYqmFiQXFCelVxjrFSfm
	Fpfmpesl5+duYgTH+LPFOxj/n7c+xCjAwajEwytwOChIiDWxrLgy9xCjBAezkgivgFFwkBBv
	SmJlVWpRfnxRaU5q8SFGaQ4WJXHeZ63WgUIC6YklqdmpqQWpRTBZJg5OqQbG3nwrm2VtIX1G
	tj+5P//7vaWRwf7fm3qlI+2smlHOSxgY9lpEhwmW7rl0JOFmx0P73a+SGs/FlVb9urX/zeYb
	7E8X1mTM/Mcubn/eNO38payw9Q+jnU3L95U13smXODrNSpvr7dFZn5tPFVpkzLs36SRf7Ys2
	lvkupStm/lcvufv0YvpT+UIbJZbijERDLeai4kQAvmedyu0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r988V0DV001590

Previously, do_checkpoint() will call congestion_wait() for waiting the pages (previous submitted node/meta/data pages) to be written back.
Because congestion_wait() will set a regular period (e.g. HZ / 50 ) for waiting.
For this reason, there is a situation that after the pages have been written back, but the checkpoint thread still wait for congestion_wait to exit.
This is a problem here, especially, when sync a large number of small files or dirs.
In order to avoid this, a wait_list is introduced, the checkpoint thread will be dropped into the wait_list if the pages have not been written back, and will be waked up by contrast.

Signed-off-by: Yuan Zhong <yuan.mark.zhong@samsung.com>
---  
 fs/f2fs/checkpoint.c |    3 +--
 fs/f2fs/f2fs.h       |   19 +++++++++++++++++++
 fs/f2fs/segment.c    |    1 +
 fs/f2fs/super.c      |    1 +
 4 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index ca39442..5d69ae0 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -758,8 +758,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
 	f2fs_put_page(cp_page, 1);
 
 	/* wait for previous submitted node/meta pages writeback */
-	while (get_pages(sbi, F2FS_WRITEBACK))
-		congestion_wait(BLK_RW_ASYNC, HZ / 50);
+	f2fs_writeback_wait(sbi);
 
 	filemap_fdatawait_range(sbi->node_inode->i_mapping, 0, LONG_MAX);
 	filemap_fdatawait_range(sbi->meta_inode->i_mapping, 0, LONG_MAX);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 7fd99d8..4b0d70e 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -18,6 +18,8 @@
 #include <linux/crc32.h>
 #include <linux/magic.h>
 #include <linux/kobject.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
 
 /*
  * For mount options
@@ -368,6 +370,7 @@ struct f2fs_sb_info {
 	struct mutex fs_lock[NR_GLOBAL_LOCKS];	/* blocking FS operations */
 	struct mutex node_write;		/* locking node writes */
 	struct mutex writepages;		/* mutex for writepages() */
+	wait_queue_head_t writeback_wqh;	/* wait_queue for writeback */
 	unsigned char next_lock_num;		/* round-robin global locks */
 	int por_doing;				/* recovery is doing or not */
 	int on_build_free_nids;			/* build_free_nids is doing */
@@ -961,6 +964,22 @@ static inline int f2fs_readonly(struct super_block *sb)
 	return sb->s_flags & MS_RDONLY;
 }
 
+static inline void f2fs_writeback_wait(struct f2fs_sb_info *sbi)
+{
+	DEFINE_WAIT(wait);
+
+	prepare_to_wait(&sbi->writeback_wqh, &wait, TASK_UNINTERRUPTIBLE);
+	if (get_pages(sbi, F2FS_WRITEBACK))
+		io_schedule();
+	finish_wait(&sbi->writeback_wqh, &wait);
+}
+
+static inline void f2fs_writeback_wake(struct f2fs_sb_info *sbi)
+{
+	if (!get_pages(sbi, F2FS_WRITEBACK))
+		wake_up_all(&sbi->writeback_wqh);
+}
+
 /*
  * file.c
  */
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index bd79bbe..0708aa9 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -597,6 +597,7 @@ static void f2fs_end_io_write(struct bio *bio, int err)
 
 	if (p->is_sync)
 		complete(p->wait);
+	f2fs_writeback_wake(p->sbi);
 	kfree(p);
 	bio_put(bio);
 }
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 094ccc6..3ac6d85 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -835,6 +835,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	mutex_init(&sbi->gc_mutex);
 	mutex_init(&sbi->writepages);
 	mutex_init(&sbi->cp_mutex);
+	init_waitqueue_head(&sbi->writeback_wqh);
 	for (i = 0; i < NR_GLOBAL_LOCKS; i++)
 		mutex_init(&sbi->fs_lock[i]);
 	mutex_init(&sbi->node_write);ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
