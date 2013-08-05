Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab3HEMCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 08:02:45 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33913 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab3HEMCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 08:02:44 -0400
From: Jin Xu <jinuxstyle@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, jinuxstyle@gmail.com
Subject: [PATCH] f2fs: fix a deadlock in fsync
Date: Mon,  5 Aug 2013 20:02:04 +0800
Message-Id: <1375704124-22274-1-git-send-email-jinuxstyle@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jin Xu <jinuxstyle@gmail.com>

This patch fixes a deadlock bug that occurs quite often when there are
concurrent write and fsync on a same file.

Following is the simplified call trace when tasks get hung.

fsync thread:
- f2fs_sync_file
 ...
 - f2fs_write_data_pages
 ...
  - update_extent_cache
  ...
   - update_inode
    - wait_on_page_writeback

bdi writeback thread
- __writeback_single_inode
 - f2fs_write_data_pages
  - mutex_lock(sbi->writepages)

The deadlock happens when the fsync thread waits on a inode page that has
been added to the f2fs' cached bio sbi->bio[NODE], and unfortunately,
no one else could be able to submit the cached bio to block layer for
writeback. This is because the fsync thread already hold a sbi->fs_lock and
the sbi->writepages lock, causing the bdi thread being blocked when attempt
to write data pages for the same inode. At the same time, f2fs_gc thread
does not notice the situation and could not help. Even the sync syscall
gets blocked.

To fix it, we could submit the cached bio first before waiting on a inode page
that is being written back.

Signed-off-by: Jin Xu <jinuxstyle@gmail.com>
---
 fs/f2fs/f2fs.h    |    2 ++
 fs/f2fs/gc.c      |    5 +----
 fs/f2fs/inode.c   |    3 ++-
 fs/f2fs/segment.c |    9 +++++++++
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 467d42d..064d3f9 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1013,6 +1013,8 @@ void allocate_new_segments(struct f2fs_sb_info *);
 struct page *get_sum_page(struct f2fs_sb_info *, unsigned int);
 struct bio *f2fs_bio_alloc(struct block_device *, int);
 void f2fs_submit_bio(struct f2fs_sb_info *, enum page_type, bool sync);
+void f2fs_wait_on_page_writeback(struct f2fs_sb_info *sbi,
+		struct page *page, enum page_type type, bool sync);
 void write_meta_page(struct f2fs_sb_info *, struct page *);
 void write_node_page(struct f2fs_sb_info *, struct page *, unsigned int,
 					block_t, block_t *);
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 35f9b1a..acfa411 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -508,10 +508,7 @@ static void move_data_page(struct inode *inode, struct page *page, int gc_type)
 	} else {
 		struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 
-		if (PageWriteback(page)) {
-			f2fs_submit_bio(sbi, DATA, true);
-			wait_on_page_writeback(page);
-		}
+		f2fs_wait_on_page_writeback(sbi, page, DATA, true);
 
 		if (clear_page_dirty_for_io(page) &&
 			S_ISDIR(inode->i_mode)) {
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 2b2d45d1..d42b85b 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -148,10 +148,11 @@ bad_inode:
 
 void update_inode(struct inode *inode, struct page *node_page)
 {
+	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	struct f2fs_node *rn;
 	struct f2fs_inode *ri;
 
-	wait_on_page_writeback(node_page);
+	f2fs_wait_on_page_writeback(sbi, node_page, NODE, false);
 
 	rn = page_address(node_page);
 	ri = &(rn->i);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index a86d125..7056cc0 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -702,6 +702,15 @@ alloc_new:
 	trace_f2fs_submit_write_page(page, blk_addr, type);
 }
 
+void f2fs_wait_on_page_writeback(struct f2fs_sb_info *sbi,
+		struct page *page, enum page_type type, bool sync)
+{
+	if (PageWriteback(page)) {
+		f2fs_submit_bio(sbi, type, sync);
+		wait_on_page_writeback(page);
+	}
+}
+
 static bool __has_curseg_space(struct f2fs_sb_info *sbi, int type)
 {
 	struct curseg_info *curseg = CURSEG_I(sbi, type);
-- 
1.7.9.5

