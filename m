Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761468Ab3ECMn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 08:43:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:24814 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab3ECMn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 08:43:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,604,1363158000"; 
   d="scan'208";a="331878112"
From: Haicheng Li <haicheng.li@linux.intel.com>
To: linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>,
        Haicheng Li <haicheng.li@linux.intel.com>
Subject: [PATCH 1/2] f2fs: optimize scan_nat_page()
Date: Fri,  3 May 2013 20:43:22 +0800
Message-Id: <1367585003-24241-1-git-send-email-haicheng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When nm_i->fcnt > 2 * MAX_FREE_NIDS, stop scanning other NAT entries.

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
---
 fs/f2fs/node.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index e275218..6276467 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1216,7 +1216,7 @@ static int add_free_nid(struct f2fs_nm_info *nm_i, nid_t nid)
 	struct free_nid *i;
 
 	if (nm_i->fcnt > 2 * MAX_FREE_NIDS)
-		return 0;
+		return -1;
 retry:
 	i = kmem_cache_alloc(free_nid_slab, GFP_NOFS);
 	if (!i) {
@@ -1265,10 +1265,16 @@ static int scan_nat_page(struct f2fs_nm_info *nm_i,
 	i = start_nid % NAT_ENTRY_PER_BLOCK;
 
 	for (; i < NAT_ENTRY_PER_BLOCK; i++, start_nid++) {
-		blk_addr  = le32_to_cpu(nat_blk->entries[i].block_addr);
+		int cnt;
+
+		blk_addr = le32_to_cpu(nat_blk->entries[i].block_addr);
 		BUG_ON(blk_addr == NEW_ADDR);
-		if (blk_addr == NULL_ADDR)
-			fcnt += add_free_nid(nm_i, start_nid);
+		if (blk_addr == NULL_ADDR) {
+			cnt = add_free_nid(nm_i, start_nid);
+			if (cnt < 0)
+				break;
+			fcnt += cnt;
+		}
 	}
 	return fcnt;
 }
-- 
1.7.9.5

