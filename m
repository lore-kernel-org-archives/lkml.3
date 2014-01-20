Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbaATKpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 05:45:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:44579 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbaATKpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 05:45:05 -0500
X-IronPort-AV: E=Sophos;i="4.95,689,1384272000"; 
   d="scan'208";a="9436307"
Message-ID: <52DCFC6A.8060200@cn.fujitsu.com>
Date: Mon, 20 Jan 2014 18:37:30 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 2/2] f2fs: remove the orphan block page array
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/20 18:43:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/20 18:43:42,
	Serialize complete at 2014/01/20 18:43:42
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the orphan_blocks may be max to 504, so it is not security
and rigorous to store such a large array in the kernel stack
as Dan Carpenter said.
In fact, grab_meta_page has locked the page in the page cache,
and we can use find_get_page() to fetch the page safely in the
downstream, so we can remove the page array directly.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/checkpoint.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index f9d4f7d..ed82de6 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -311,11 +311,10 @@ static void write_orphan_inodes(struct f2fs_sb_info *sbi, block_t start_blk)
 	unsigned short orphan_blocks = (unsigned short)((sbi->n_orphans +
 		(F2FS_ORPHANS_PER_BLOCK - 1)) / F2FS_ORPHANS_PER_BLOCK);
 	struct page *page = NULL;
-	struct page *pages[orphan_blocks];
 	struct orphan_inode_entry *orphan = NULL;
 
 	for (index = 0; index < orphan_blocks; index++)
-		pages[index] = grab_meta_page(sbi, start_blk + index);
+		grab_meta_page(sbi, start_blk + index);
 
 	index = 1;
 	spin_lock(&sbi->orphan_inode_lock);
@@ -324,10 +323,12 @@ static void write_orphan_inodes(struct f2fs_sb_info *sbi, block_t start_blk)
 	/* loop for each orphan inode entry and write them in Jornal block */
 	list_for_each_entry(orphan, head, list) {
 		if (!page) {
-			page = pages[index - 1];
+			page = find_get_page(META_MAPPING(sbi), start_blk++);
+			f2fs_bug_on(!page);
 			orphan_blk =
 				(struct f2fs_orphan_block *)page_address(page);
 			memset(orphan_blk, 0, sizeof(*orphan_blk));
+			f2fs_put_page(page, 0);
 		}
 
 		orphan_blk->ino[nentries++] = cpu_to_le32(orphan->ino);
-- 
1.7.7

