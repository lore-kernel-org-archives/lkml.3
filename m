Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459AbaGCK7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:59:30 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:38517 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaGCK71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 06:59:27 -0400
X-AuditID: cbfee61b-f79f86d00000144c-94-53b5378d0105
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH] f2fs: reduce competition among node page writes
Date: Thu, 03 Jul 2014 18:58:39 +0800
Message-id: <003901cf96ad$dbd17680$93746380$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+Wq1VhjUkT6xXpTOaqieBUFV425g==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t9jQd1e863BBu0LTSyu7Wtksniyfhaz
	xaVF7hZ79p5ksbi8aw6bA6vHplWdbB67F3xm8ujbsorR4/MmuQCWKC6blNSczLLUIn27BK6M
	zzvnsBbsEquY/PAEawPjMaEuRk4OCQETibUPOpghbDGJC/fWs3UxcnEICUxnlLj7YSsThPOD
	UWLBi3vsIFVsAioSyzv+M4HYIgJeEpP2n2ABsZkFMiXuNc0AmyQMFP/0cT6YzSKgKnFx+TdW
	EJtXwFKiZ94vKFtQ4sfke1C9WhLrdx5ngrDlJTaveQt1kYLEjrOvGSF26Um863wOVSMusfHI
	LZYJjAKzkIyahWTULCSjZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOLyfSe9g
	XNVgcYhRgINRiYfXwX5LsBBrYllxZe4hRgkOZiUR3tv6W4OFeFMSK6tSi/Lji0pzUosPMUpz
	sCiJ8x5stQ4UEkhPLEnNTk0tSC2CyTJxcEo1MK5bk/wjro/J/56lW1Pt1xO7S+zXSc7rZBRa
	mqLD73eTzZqtvHLrf6+95/cbTFlzpELfZe8DU/aqvFUXbrevuLrfq/CI9fvEyRIWS3bMFVnn
	ylT449uqjOkfz3S35P523dQ6oVOc7ddxtgNib76cP+Hgvb4rUctwTc/qzDnsrBMDLn/vW7np
	WJkSS3FGoqEWc1FxIgCI8DzLawIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do not need to block on ->node_write among different node page writers e.g.
fsync/flush, unless we have a node page writer from write_checkpoint.
So it's better use rw_semaphore instead of mutex type for ->node_write to
promote performance.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/checkpoint.c |    6 +++---
 fs/f2fs/f2fs.h       |    2 +-
 fs/f2fs/node.c       |    4 ++--
 fs/f2fs/super.c      |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 0b4710c..eec406b 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -714,10 +714,10 @@ retry_flush_dents:
 	 * until finishing nat/sit flush.
 	 */
 retry_flush_nodes:
-	mutex_lock(&sbi->node_write);
+	down_write(&sbi->node_write);
 
 	if (get_pages(sbi, F2FS_DIRTY_NODES)) {
-		mutex_unlock(&sbi->node_write);
+		up_write(&sbi->node_write);
 		sync_node_pages(sbi, 0, &wbc);
 		goto retry_flush_nodes;
 	}
@@ -726,7 +726,7 @@ retry_flush_nodes:
 
 static void unblock_operations(struct f2fs_sb_info *sbi)
 {
-	mutex_unlock(&sbi->node_write);
+	up_write(&sbi->node_write);
 	f2fs_unlock_all(sbi);
 }
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index ae3b4ac..ca30b5a 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -444,7 +444,7 @@ struct f2fs_sb_info {
 	struct inode *meta_inode;		/* cache meta blocks */
 	struct mutex cp_mutex;			/* checkpoint procedure lock */
 	struct rw_semaphore cp_rwsem;		/* blocking FS operations */
-	struct mutex node_write;		/* locking node writes */
+	struct rw_semaphore node_write;		/* locking node writes */
 	struct mutex writepages;		/* mutex for writepages() */
 	bool por_doing;				/* recovery is doing or not */
 	wait_queue_head_t cp_wait;
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index a90f51d..7b5b5de 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1231,12 +1231,12 @@ static int f2fs_write_node_page(struct page *page,
 	if (wbc->for_reclaim)
 		goto redirty_out;
 
-	mutex_lock(&sbi->node_write);
+	down_read(&sbi->node_write);
 	set_page_writeback(page);
 	write_node_page(sbi, page, &fio, nid, ni.blk_addr, &new_addr);
 	set_node_addr(sbi, &ni, new_addr, is_fsync_dnode(page));
 	dec_page_count(sbi, F2FS_DIRTY_NODES);
-	mutex_unlock(&sbi->node_write);
+	up_read(&sbi->node_write);
 	unlock_page(page);
 	return 0;
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 8f96d93..bed9413 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -947,7 +947,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	mutex_init(&sbi->gc_mutex);
 	mutex_init(&sbi->writepages);
 	mutex_init(&sbi->cp_mutex);
-	mutex_init(&sbi->node_write);
+	init_rwsem(&sbi->node_write);
 	sbi->por_doing = false;
 	spin_lock_init(&sbi->stat_lock);
 
-- 
1.7.9.5


