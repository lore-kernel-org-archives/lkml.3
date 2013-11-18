Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333Ab3KRJUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 04:20:47 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61789 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750836Ab3KRJUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 04:20:37 -0500
X-IronPort-AV: E=Sophos;i="4.93,722,1378828800"; 
   d="scan'208";a="9064179"
Message-ID: <5289DA67.5040600@cn.fujitsu.com>
Date: Mon, 18 Nov 2013 17:14:15 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] f2fs: use mutex rather than the rw_sem
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/18 17:18:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/18 17:18:42,
	Serialize complete at 2013/11/18 17:18:42
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use mutex rather than the rw_sem to protect bio related fields,
because it's needless to take the read_sem in the read path.


Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/data.c    |    4 ----
 fs/f2fs/f2fs.h    |    2 +-
 fs/f2fs/segment.c |    8 ++++----
 fs/f2fs/super.c   |    2 +-
 4 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index aa3438c..b4e4c7e 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -383,8 +383,6 @@ int f2fs_readpage(struct f2fs_sb_info *sbi, struct page *page,
 
 	trace_f2fs_readpage(page, blk_addr, type);
 
-	down_read(&sbi->bio_sem);
-
 	/* Allocate a new bio */
 	bio = f2fs_bio_alloc(bdev, 1);
 
@@ -394,13 +392,11 @@ int f2fs_readpage(struct f2fs_sb_info *sbi, struct page *page,
 
 	if (bio_add_page(bio, page, PAGE_CACHE_SIZE, 0) < PAGE_CACHE_SIZE) {
 		bio_put(bio);
-		up_read(&sbi->bio_sem);
 		f2fs_put_page(page, 1);
 		return -EFAULT;
 	}
 
 	submit_bio(type, bio);
-	up_read(&sbi->bio_sem);
 	return 0;
 }
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 89dc750..78a0054 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -361,7 +361,7 @@ struct f2fs_sb_info {
 	struct f2fs_sm_info *sm_info;		/* segment manager */
 	struct bio *bio[NR_PAGE_TYPE];		/* bios to merge */
 	sector_t last_block_in_bio[NR_PAGE_TYPE];	/* last block number */
-	struct rw_semaphore bio_sem;		/* IO semaphore */
+	struct mutex bio_mutex;			/* IO write mutex */
 
 	/* for checkpoint */
 	struct f2fs_checkpoint *ckpt;		/* raw checkpoint pointer */
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index fa284d3..e91f65c 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -653,9 +653,9 @@ static void do_submit_bio(struct f2fs_sb_info *sbi,
 
 void f2fs_submit_bio(struct f2fs_sb_info *sbi, enum page_type type, bool sync)
 {
-	down_write(&sbi->bio_sem);
+	mutex_lock(&sbi->bio_mutex);
 	do_submit_bio(sbi, type, sync);
-	up_write(&sbi->bio_sem);
+	mutex_unlock(&sbi->bio_mutex);
 }
 
 static void submit_write_page(struct f2fs_sb_info *sbi, struct page *page,
@@ -666,7 +666,7 @@ static void submit_write_page(struct f2fs_sb_info *sbi, struct page *page,
 
 	verify_block_addr(sbi, blk_addr);
 
-	down_write(&sbi->bio_sem);
+	mutex_lock(&sbi->bio_mutex);
 
 	inc_page_count(sbi, F2FS_WRITEBACK);
 
@@ -701,7 +701,7 @@ retry:
 
 	sbi->last_block_in_bio[type] = blk_addr;
 
-	up_write(&sbi->bio_sem);
+	mutex_unlock(&sbi->bio_mutex);
 	trace_f2fs_submit_write_page(page, blk_addr, type);
 }
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index bafff72..fab3550 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -874,7 +874,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	mutex_init(&sbi->node_write);
 	sbi->por_doing = false;
 	spin_lock_init(&sbi->stat_lock);
-	init_rwsem(&sbi->bio_sem);
+	mutex_init(&sbi->bio_mutex);
 	init_rwsem(&sbi->cp_rwsem);
 	init_waitqueue_head(&sbi->cp_wait);
 	init_sb_info(sbi);
-- 
1.7.7

