Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab3EFLZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 07:25:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:10236 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab3EFLZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 07:25:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,621,1363158000"; 
   d="scan'208";a="329498251"
From: Haicheng Li <haicheng.li@linux.intel.com>
To: linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>,
        Haicheng Li <haicheng.li@linux.intel.com>
Subject: [PATCH] f2fs: optimize alloc_nid_failed()
Date: Mon,  6 May 2013 19:25:06 +0800
Message-Id: <1367839506-30372-1-git-send-email-haicheng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current alloc_nid_failed() has two issues:
1. unecessarily kmem_cache_free() the free_nid and then realloc a new
   slab cache for it immediately;
2. needs to __lookup_free_nid_list() twice in order to find out the free_nid
   from free_nid_list.

This patch fixes these issues.

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
---
 fs/f2fs/node.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index e275218..7ce8e9f 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1403,8 +1403,21 @@ void alloc_nid_done(struct f2fs_sb_info *sbi, nid_t nid)
  */
 void alloc_nid_failed(struct f2fs_sb_info *sbi, nid_t nid)
 {
-	alloc_nid_done(sbi, nid);
-	add_free_nid(NM_I(sbi), nid);
+	struct f2fs_nm_info *nm_i = NM_I(sbi);
+	struct free_nid *i;
+
+	spin_lock(&nm_i->free_nid_list_lock);
+	i = __lookup_free_nid_list(nid, &nm_i->free_nid_list);
+	if (i) {
+		BUG_ON(i->state != NID_ALLOC);
+		if (nm_i->fcnt > 2 * MAX_FREE_NIDS)
+			__del_from_free_nid_list(i);
+		else {
+			i->state = NID_NEW;
+			nm_i->fcnt++;
+		}
+	}
+	spin_unlock(&nm_i->free_nid_list_lock);
 }
 
 void recover_node_page(struct f2fs_sb_info *sbi, struct page *page,
-- 
1.7.9.5

