Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab3KSKKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 05:10:22 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:39351 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab3KSKKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 05:10:18 -0500
X-IronPort-AV: E=Sophos;i="4.93,728,1378828800"; 
   d="scan'208";a="9074466"
Message-ID: <528B378E.2020109@cn.fujitsu.com>
Date: Tue, 19 Nov 2013 18:03:58 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] f2fs: simplify write_orphan_inodes for better readable
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/19 18:08:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/19 18:08:23,
	Serialize complete at 2013/11/19 18:08:23
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify write_orphan_inodes for better readable. Because we hold the
orphan_inode_mutex, so it's safe to use list_for_each_entry instead of
list_for_each_safe.


Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/checkpoint.c |   38 ++++++++++++++++++--------------------
 1 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 5716e5e..f884589 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -300,12 +300,13 @@ int recover_orphan_inodes(struct f2fs_sb_info *sbi)
 
 static void write_orphan_inodes(struct f2fs_sb_info *sbi, block_t start_blk)
 {
-	struct list_head *head, *this, *next;
+	struct list_head *head;
 	struct f2fs_orphan_block *orphan_blk = NULL;
 	struct page *page = NULL;
 	unsigned int nentries = 0;
 	unsigned short index = 1;
 	unsigned short orphan_blocks;
+	struct orphan_inode_entry *orphan = NULL;
 
 	orphan_blocks = (unsigned short)((sbi->n_orphans +
 		(F2FS_ORPHANS_PER_BLOCK - 1)) / F2FS_ORPHANS_PER_BLOCK);
@@ -314,12 +315,17 @@ static void write_orphan_inodes(struct f2fs_sb_info *sbi, block_t start_blk)
 	head = &sbi->orphan_inode_list;
 
 	/* loop for each orphan inode entry and write them in Jornal block */
-	list_for_each_safe(this, next, head) {
-		struct orphan_inode_entry *orphan;
+	list_for_each_entry(orphan, head, list) {
+		if (!page) {
+			page = grab_meta_page(sbi, start_blk);
+			orphan_blk =
+				(struct f2fs_orphan_block *)page_address(page);
+			memset(orphan_blk, 0, sizeof(*orphan_blk));
+		}
 
-		orphan = list_entry(this, struct orphan_inode_entry, list);
+		orphan_blk->ino[nentries] = cpu_to_le32(orphan->ino);
 
-		if (nentries == F2FS_ORPHANS_PER_BLOCK) {
+		if (nentries++ == F2FS_ORPHANS_PER_BLOCK) {
 			/*
 			 * an orphan block is full of 1020 entries,
 			 * then we need to flush current orphan blocks
@@ -335,24 +341,16 @@ static void write_orphan_inodes(struct f2fs_sb_info *sbi, block_t start_blk)
 			nentries = 0;
 			page = NULL;
 		}
-		if (page)
-			goto page_exist;
+	}
 
-		page = grab_meta_page(sbi, start_blk);
-		orphan_blk = (struct f2fs_orphan_block *)page_address(page);
-		memset(orphan_blk, 0, sizeof(*orphan_blk));
-page_exist:
-		orphan_blk->ino[nentries++] = cpu_to_le32(orphan->ino);
+	if (page) {
+		orphan_blk->blk_addr = cpu_to_le16(index);
+		orphan_blk->blk_count = cpu_to_le16(orphan_blocks);
+		orphan_blk->entry_count = cpu_to_le32(nentries);
+		set_page_dirty(page);
+		f2fs_put_page(page, 1);
 	}
-	if (!page)
-		goto end;
 
-	orphan_blk->blk_addr = cpu_to_le16(index);
-	orphan_blk->blk_count = cpu_to_le16(orphan_blocks);
-	orphan_blk->entry_count = cpu_to_le32(nentries);
-	set_page_dirty(page);
-	f2fs_put_page(page, 1);
-end:
 	mutex_unlock(&sbi->orphan_inode_mutex);
 }
 
-- 
1.7.7

