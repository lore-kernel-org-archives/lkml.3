Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbaAMJvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 04:51:01 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50055 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbaAMJu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 04:50:57 -0500
X-IronPort-AV: E=Sophos;i="4.95,651,1384272000"; 
   d="scan'208";a="9409914"
Message-ID: <52D3B540.90407@cn.fujitsu.com>
Date: Mon, 13 Jan 2014 17:43:28 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?5L+e6LaF?= <chao2.yu@samsung.com>
Subject: [f2fs-dev][PATCH V2 1/3] f2fs: move grabbing orphan pages out of
 protection region
References: <52CFC6BE.7020609@cn.fujitsu.com>
In-Reply-To: <52CFC6BE.7020609@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/13 17:49:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/13 17:49:45,
	Serialize complete at 2014/01/13 17:49:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move grabbing orphan block page out of protection region, and grab all
the orphan block pages ahead.

v2:
  Remove the redundant code as Chao Yu suggested.

Reviewed-by: Chao Yu <chao2.yu@samsung.com>
Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/checkpoint.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 0d78bbe..fdc5a12 100644
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
@@ -338,7 +341,6 @@ static void write_orphan_inodes(struct f2fs_sb_info *sbi, block_t start_blk)
 			set_page_dirty(page);
 			f2fs_put_page(page, 1);
 			index++;
-			start_blk++;
 			nentries = 0;
 			page = NULL;
 		}
-- 
1.7.7


