Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab3I3K5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:57:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:57954 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211Ab3I3K5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:57:44 -0400
X-AuditID: cbfee6a1-b7f876d0000032d0-02-52495925b349
Date: Mon, 30 Sep 2013 10:57:41 +0000 (GMT)
From: Yuan Zhong <yuan.mark.zhong@samsung.com>
Subject: [f2fs-dev][PATCH]f2fs: avoid congestion_wait when do_checkpoint for
 better performance
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, shu.tan@samsung.com
Reply-to: yuan.mark.zhong@samsung.com
MIME-version: 1.0
X-MTR: 20130930105513378@yuan.mark.zhong
Msgkey: 20130930105513378@yuan.mark.zhong
X-EPLocale: en_US.windows-1252
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130930105513378@yuan.mark.zhong
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <20389937.79321380538660833.JavaMail.weblogic@epml14>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t/tGbqqkZ5BBtParC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGzwU9rAXnlCuWnu5hbmC8otTFyMkhJKAl8f7HQ2YQW0LARGL/
	qy52CFtM4sK99WxdjFxANfMZJQ52TmQFSbAIqEp0NT0Gs9kE9CXu7NvHCGILC8RLHN39Aiwu
	IqAgMbltMzNIM7PANEaJ278WAxVxAE1SlTi+thSkhldAUOLkzCcsIGEJAQ2Jb2fMIcKaEo3X
	9jNB3CAnsWTqZSibV2JG+1MWmPi0r2ugbpaWOD9rAyPMzYu/P4aK80scu72DCWI8r8ST+8Ew
	Y3Zv/sIGYQtITD1zEKpVV6Lr5zmoVj6JNQvfssCM2XVqOTNM7/0tc8HOYRZQlJjS/ZAdwjaQ
	OLJoDiuqr0BsR4kpi/8wTWCUm4UkNQtJ+ywk7chqFjCyrGIUTS1ILihOSq8w1CtOzC0uzUvX
	S87P3cQIjvJnC3cwfjlvfYhRgINRiYd3wnKPICHWxLLiytxDjBIczEoivBPcPIOEeFMSK6tS
	i/Lji0pzUosPMUpzsCiJ8z5ttQ4UEkhPLEnNTk0tSC2CyTJxcEo1MM7+/DaCu3+ltccb9jrJ
	J0cVXvrKctQve9bRXTVD9su+/L2hbQZ9RRz9bYc1+t3K1q8057p/ve3Dw6hLt9RfW546sXZ7
	4Jl53ZObmx1CZufO+TcnWKuiZmJi5LPapaGeGY9OaQq8OVJef2rSR4ZgOWuJedcMpqSKueVw
	6/c3tF/PWbSMcX7PfiWW4oxEQy3mouJEADDS6HbuAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8UAvsOV008948


Previously,  do_checkpoint() will call congestion_wait() for waiting the pages (previous submitted node/meta/data pages) to be written back.
Because congestion_wait() will set a regular period (e.g. HZ / 50 ) for waiting.
For this reason, there is a situation that after the pages have been written back, but the checkpoint thread still wait for congestion_wait to exit.
This is a problem here, especially, when sync a large number of small files or dirs.
In order to avoid this, a wait_list is introduced, the checkpoint thread will be dropped into the wait_list if the pages have not been written back, and will be waked up by contrast.

Signed-off-by: Yuan Zhong <yuan.mark.zhong@samsung.com>
---
 fs/f2fs/checkpoint.c |  3 +--
 fs/f2fs/f2fs.h       | 19 +++++++++++++++++++
 fs/f2fs/segment.c    |  1 +
 fs/f2fs/super.c      |  1 +
 4 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index bb31220..cf6b4a5 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -756,8 +756,7 @@ static void do_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
 	f2fs_put_page(cp_page, 1);
 
 	/* wait for previous submitted node/meta pages writeback */
-	while (get_pages(sbi, F2FS_WRITEBACK))
-		congestion_wait(BLK_RW_ASYNC, HZ / 50);
+	f2fs_writeback_wait(sbi);
 
 	filemap_fdatawait_range(sbi->node_inode->i_mapping, 0, LONG_MAX);
 	filemap_fdatawait_range(sbi->meta_inode->i_mapping, 0, LONG_MAX);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 608f0df..f8b62cc 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -18,6 +18,7 @@
 #include <linux/crc32.h>
 #include <linux/magic.h>
 #include <linux/kobject.h>
+#include <linux/wait.h>
 
 /*
  * For mount options
@@ -430,6 +431,8 @@ struct f2fs_sb_info {
 	/* For sysfs suppport */
 	struct kobject s_kobj;
 	struct completion s_kobj_unregister;
+	
+	wait_queue_head_t writeback_wqh;
 };
 
 /*
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
index 09af9c7..79293fe 100644
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
index 13d0a0f..b31f686 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -818,6 +818,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	mutex_init(&sbi->gc_mutex);
 	mutex_init(&sbi->writepages);
 	mutex_init(&sbi->cp_mutex);
+	init_waitqueue_head(&sbi->writeback_wqh);
 	for (i = 0; i < NR_GLOBAL_LOCKS; i++)
 		mutex_init(&sbi->fs_lock[i]);
 	mutex_init(&sbi->node_write);
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
