Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbaAJKQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 05:16:34 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:7186 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbaAJKQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 05:16:30 -0500
X-IronPort-AV: E=Sophos;i="4.95,637,1384272000"; 
   d="scan'208";a="9400710"
Message-ID: <52CFC6BE.7020609@cn.fujitsu.com>
Date: Fri, 10 Jan 2014 18:09:02 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [f2fs-dev][PATCH 1/3] f2fs: move grabing orphan pages out of protection
 region
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/10 18:15:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/10 18:15:23,
	Serialize complete at 2014/01/10 18:15:23
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move grabing orphan block page out of protection region, and grab all
the orphan block pages ahead.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/checkpoint.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 0d78bbe..af92c74 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -303,22 +303,25 @@ static void write_orphan_inodes(struct f2fs_sb_info *sbi, block_t start_blk)
 {
 	struct list_head *head;
 	struct f2fs_orphan_block *orphan_blk = NULL;
-	struct page *page = NULL;
 	unsigned int nentries = 0;
-	unsigned short index = 1;
-	unsigned short orphan_blocks;
+	unsigned short index;
+	unsigned short orphan_blocks = (unsigned short)((sbi->n_orphans +
+		(F2FS_ORPHANS_PER_BLOCK - 1)) / F2FS_ORPHANS_PER_BLOCK);
+	struct page *page = NULL;
+	struct page *pages[orphan_blocks];
 	struct orphan_inode_entry *orphan = NULL;
 
-	orphan_blocks = (unsigned short)((sbi->n_orphans +
-		(F2FS_ORPHANS_PER_BLOCK - 1)) / F2FS_ORPHANS_PER_BLOCK);
+	for (index = 0; index < orphan_blocks; index++)
+		pages[index] = grab_meta_page(sbi, start_blk + index);
 
+	index = 1;
 	mutex_lock(&sbi->orphan_inode_mutex);
 	head = &sbi->orphan_inode_list;
 
 	/* loop for each orphan inode entry and write them in Jornal block */
 	list_for_each_entry(orphan, head, list) {
 		if (!page) {
-			page = grab_meta_page(sbi, start_blk);
+			page = pages[index - 1];
 			orphan_blk =
 				(struct f2fs_orphan_block *)page_address(page);
 			memset(orphan_blk, 0, sizeof(*orphan_blk));
-- 
1.7.7

