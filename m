Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab3EFPQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 11:16:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:30209 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611Ab3EFPQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 11:16:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,622,1363158000"; 
   d="scan'208";a="298322407"
From: Haicheng Li <haicheng.li@linux.intel.com>
To: linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>,
        Haicheng Li <haicheng.li@linux.intel.com>
Subject: [PATCH 2/4] f2fs: code cleanup for scan_nat_page() and build_free_nids()
Date: Mon,  6 May 2013 23:15:42 +0800
Message-Id: <1367853344-28938-3-git-send-email-haicheng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367853344-28938-1-git-send-email-haicheng.li@linux.intel.com>
References: <1367853344-28938-1-git-send-email-haicheng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does two cleanups:
1. remove unused variable "fcnt" in build_free_nids().
2. make scan_nat_page() as void type and remove useless variable "fcnt".

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
---
 fs/f2fs/node.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 532ac57..1b45dd0 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1292,12 +1292,11 @@ static void remove_free_nid(struct f2fs_nm_info *nm_i, nid_t nid)
 	spin_unlock(&nm_i->free_nid_list_lock);
 }
 
-static int scan_nat_page(struct f2fs_nm_info *nm_i,
+static void scan_nat_page(struct f2fs_nm_info *nm_i,
 			struct page *nat_page, nid_t start_nid)
 {
 	struct f2fs_nat_block *nat_blk = page_address(nat_page);
 	block_t blk_addr;
-	int fcnt = 0;
 	int i;
 
 	i = start_nid % NAT_ENTRY_PER_BLOCK;
@@ -1308,9 +1307,8 @@ static int scan_nat_page(struct f2fs_nm_info *nm_i,
 		blk_addr  = le32_to_cpu(nat_blk->entries[i].block_addr);
 		BUG_ON(blk_addr == NEW_ADDR);
 		if (blk_addr == NULL_ADDR)
-			fcnt += add_free_nid(nm_i, start_nid);
+			add_free_nid(nm_i, start_nid);
 	}
-	return fcnt;
 }
 
 static void build_free_nids(struct f2fs_sb_info *sbi)
@@ -1319,7 +1317,7 @@ static void build_free_nids(struct f2fs_sb_info *sbi)
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_HOT_DATA);
 	struct f2fs_summary_block *sum = curseg->sum_blk;
-	int fcnt = 0, i = 0;
+	int i = 0;
 	nid_t nid = nm_i->next_scan_nid;
 
 	/* Enough entries */
@@ -1332,7 +1330,7 @@ static void build_free_nids(struct f2fs_sb_info *sbi)
 	while (1) {
 		struct page *page = get_current_nat_page(sbi, nid);
 
-		fcnt += scan_nat_page(nm_i, page, nid);
+		scan_nat_page(nm_i, page, nid);
 		f2fs_put_page(page, 1);
 
 		nid += (NAT_ENTRY_PER_BLOCK - (nid % NAT_ENTRY_PER_BLOCK));
-- 
1.7.9.5

