Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbaAJKQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 05:16:47 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:7186 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754447AbaAJKQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 05:16:40 -0500
X-IronPort-AV: E=Sophos;i="4.95,637,1384272000"; 
   d="scan'208";a="9400713"
Message-ID: <52CFC6CA.3060406@cn.fujitsu.com>
Date: Fri, 10 Jan 2014 18:09:14 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [f2fs-dev] [PATCH 3/3] f2fs: use spinlock rather than mutex for better
 speed
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/10 18:15:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/10 18:15:34,
	Serialize complete at 2014/01/10 18:15:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the 2 previous changes, all the long time operations are moved out
of the protection region, so here we can use spinlock rather than mutex
(orphan_inode_mutex) for lower overhead.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/checkpoint.c |   24 ++++++++++++------------
 fs/f2fs/f2fs.h       |    2 +-
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 007f64c..d0c797f 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -196,22 +196,22 @@ int acquire_orphan_inode(struct f2fs_sb_info *sbi)
 {
 	int err = 0;
 
-	mutex_lock(&sbi->orphan_inode_mutex);
+	spin_lock(&sbi->orphan_inode_lock);
 	if (unlikely(sbi->n_orphans >= sbi->max_orphans))
 		err = -ENOSPC;
 	else
 		sbi->n_orphans++;
-	mutex_unlock(&sbi->orphan_inode_mutex);
+	spin_unlock(&sbi->orphan_inode_lock);
 
 	return err;
 }
 
 void release_orphan_inode(struct f2fs_sb_info *sbi)
 {
-	mutex_lock(&sbi->orphan_inode_mutex);
+	spin_lock(&sbi->orphan_inode_lock);
 	f2fs_bug_on(sbi->n_orphans == 0);
 	sbi->n_orphans--;
-	mutex_unlock(&sbi->orphan_inode_mutex);
+	spin_unlock(&sbi->orphan_inode_lock);
 }
 
 void add_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
@@ -222,12 +222,12 @@ void add_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
 	new = f2fs_kmem_cache_alloc(orphan_entry_slab, GFP_ATOMIC);
 	new->ino = ino;
 
-	mutex_lock(&sbi->orphan_inode_mutex);
+	spin_lock(&sbi->orphan_inode_lock);
 	head = &sbi->orphan_inode_list;
 	list_for_each(this, head) {
 		orphan = list_entry(this, struct orphan_inode_entry, list);
 		if (orphan->ino == ino) {
-			mutex_unlock(&sbi->orphan_inode_mutex);
+			spin_unlock(&sbi->orphan_inode_lock);
 			kmem_cache_free(orphan_entry_slab, new);
 			return;
 		}
@@ -242,7 +242,7 @@ void add_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
 		list_add(&new->list, this->prev);
 	else
 		list_add_tail(&new->list, head);
-	mutex_unlock(&sbi->orphan_inode_mutex);
+	spin_unlock(&sbi->orphan_inode_lock);
 }
 
 void remove_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
@@ -250,7 +250,7 @@ void remove_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
 	struct list_head *head;
 	struct orphan_inode_entry *orphan;
 
-	mutex_lock(&sbi->orphan_inode_mutex);
+	spin_lock(&sbi->orphan_inode_lock);
 	head = &sbi->orphan_inode_list;
 	list_for_each_entry(orphan, head, list) {
 		if (orphan->ino == ino) {
@@ -261,7 +261,7 @@ void remove_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
 			break;
 		}
 	}
-	mutex_unlock(&sbi->orphan_inode_mutex);
+	spin_unlock(&sbi->orphan_inode_lock);
 }
 
 static void recover_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
@@ -318,7 +318,7 @@ static void write_orphan_inodes(struct f2fs_sb_info *sbi, block_t start_blk)
 		pages[index] = grab_meta_page(sbi, start_blk + index);
 
 	index = 1;
-	mutex_lock(&sbi->orphan_inode_mutex);
+	spin_lock(&sbi->orphan_inode_lock);
 	head = &sbi->orphan_inode_list;
 
 	/* loop for each orphan inode entry and write them in Jornal block */
@@ -358,7 +358,7 @@ static void write_orphan_inodes(struct f2fs_sb_info *sbi, block_t start_blk)
 		f2fs_put_page(page, 1);
 	}
 
-	mutex_unlock(&sbi->orphan_inode_mutex);
+	spin_unlock(&sbi->orphan_inode_lock);
 }
 
 static struct page *validate_checkpoint(struct f2fs_sb_info *sbi,
@@ -829,7 +829,7 @@ void write_checkpoint(struct f2fs_sb_info *sbi, bool is_umount)
 
 void init_orphan_info(struct f2fs_sb_info *sbi)
 {
-	mutex_init(&sbi->orphan_inode_mutex);
+	spin_lock_init(&sbi->orphan_inode_lock);
 	INIT_LIST_HEAD(&sbi->orphan_inode_list);
 	sbi->n_orphans = 0;
 	/*
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 5f7dc4f..2d3f531 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -412,7 +412,7 @@ struct f2fs_sb_info {
 
 	/* for orphan inode management */
 	struct list_head orphan_inode_list;	/* orphan inode list */
-	struct mutex orphan_inode_mutex;	/* for orphan inode list */
+	spinlock_t orphan_inode_lock;		/* for orphan inode list */
 	unsigned int n_orphans;			/* # of orphan inodes */
 	unsigned int max_orphans;		/* max orphan inodes */
 
-- 
1.7.7

