Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab3LZKbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 05:31:39 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50012 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab3LZKbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 05:31:38 -0500
X-IronPort-AV: E=Sophos;i="4.95,553,1384272000"; 
   d="scan'208";a="9330888"
Message-ID: <52BC03D3.2040002@cn.fujitsu.com>
Date: Thu, 26 Dec 2013 18:24:19 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] f2fs: convert max_orphans to a field of f2fs_sb_info
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/26 18:30:52,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/26 18:30:54,
	Serialize complete at 2013/12/26 18:30:54
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, we need to calculate the max orphan num when we try to acquire an
orphan inode, but it's a stable value since the super block was inited. So
converting it to a field of f2fs_sb_info and use it directly when needed seems
a better choose.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/checkpoint.c |   20 ++++++++++----------
 fs/f2fs/f2fs.h       |    1 +
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 2fc3b6b..0d78bbe 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -194,23 +194,15 @@ const struct address_space_operations f2fs_meta_aops = {
 
 int acquire_orphan_inode(struct f2fs_sb_info *sbi)
 {
-	unsigned int max_orphans;
 	int err = 0;
 
-	/*
-	 * considering 512 blocks in a segment 8 blocks are needed for cp
-	 * and log segment summaries. Remaining blocks are used to keep
-	 * orphan entries with the limitation one reserved segment
-	 * for cp pack we can have max 1020*504 orphan entries
-	 */
-	max_orphans = (sbi->blocks_per_seg - 2 - NR_CURSEG_TYPE)
-				* F2FS_ORPHANS_PER_BLOCK;
 	mutex_lock(&sbi->orphan_inode_mutex);
-	if (unlikely(sbi->n_orphans >= max_orphans))
+	if (unlikely(sbi->n_orphans >= sbi->max_orphans))
 		err = -ENOSPC;
 	else
 		sbi->n_orphans++;
 	mutex_unlock(&sbi->orphan_inode_mutex);
+
 	return err;
 }
 
@@ -834,6 +826,14 @@ void init_orphan_info(struct f2fs_sb_info *sbi)
 	mutex_init(&sbi->orphan_inode_mutex);
 	INIT_LIST_HEAD(&sbi->orphan_inode_list);
 	sbi->n_orphans = 0;
+	/*
+	 * considering 512 blocks in a segment 8 blocks are needed for cp
+	 * and log segment summaries. Remaining blocks are used to keep
+	 * orphan entries with the limitation one reserved segment
+	 * for cp pack we can have max 1020*504 orphan entries
+	 */
+	sbi->max_orphans = (sbi->blocks_per_seg - 2 - NR_CURSEG_TYPE)
+				* F2FS_ORPHANS_PER_BLOCK;
 }
 
 int __init create_checkpoint_caches(void)
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 1a06f0a..36211cb 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -414,6 +414,7 @@ struct f2fs_sb_info {
 	struct list_head orphan_inode_list;	/* orphan inode list */
 	struct mutex orphan_inode_mutex;	/* for orphan inode list */
 	unsigned int n_orphans;			/* # of orphan inodes */
+	unsigned int max_orphans;		/* max orphan inodes */
 
 	/* for directory inode management */
 	struct list_head dir_inode_list;	/* dir inode list */
-- 
1.7.7

