Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab3EFPQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 11:16:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:30209 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753746Ab3EFPQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 11:16:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,622,1363158000"; 
   d="scan'208";a="298322418"
From: Haicheng Li <haicheng.li@linux.intel.com>
To: linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>,
        Haicheng Li <haicheng.li@linux.intel.com>
Subject: [PATCH 3/4] f2fs: optimize scan_nat_page()
Date: Mon,  6 May 2013 23:15:43 +0800
Message-Id: <1367853344-28938-4-git-send-email-haicheng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367853344-28938-1-git-send-email-haicheng.li@linux.intel.com>
References: <1367853344-28938-1-git-send-email-haicheng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When nm_i->fcnt > 2 * MAX_FREE_NIDS, stop scanning other NAT entries.

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
---
 fs/f2fs/node.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 1b45dd0..1fe3fe2 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1254,7 +1254,7 @@ static int add_free_nid(struct f2fs_nm_info *nm_i, nid_t nid)
 	struct free_nid *i;
 
 	if (nm_i->fcnt > 2 * MAX_FREE_NIDS)
-		return 0;
+		return -1;
 
 	/* 0 nid should not be used */
 	if (nid == 0)
@@ -1302,12 +1302,17 @@ static void scan_nat_page(struct f2fs_nm_info *nm_i,
 	i = start_nid % NAT_ENTRY_PER_BLOCK;
 
 	for (; i < NAT_ENTRY_PER_BLOCK; i++, start_nid++) {
+		int cnt;
+
 		if (start_nid >= nm_i->max_nid)
 			break;
-		blk_addr  = le32_to_cpu(nat_blk->entries[i].block_addr);
+		blk_addr = le32_to_cpu(nat_blk->entries[i].block_addr);
 		BUG_ON(blk_addr == NEW_ADDR);
-		if (blk_addr == NULL_ADDR)
-			add_free_nid(nm_i, start_nid);
+		if (blk_addr == NULL_ADDR) {
+			cnt = add_free_nid(nm_i, start_nid);
+			if (cnt < 0)
+				break;
+		}
 	}
 }
 
-- 
1.7.9.5

