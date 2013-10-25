Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab3JYQIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 12:08:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:2982 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864Ab3JYQIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 12:08:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,571,1378882800"; 
   d="scan'208";a="417211698"
From: Huajun Li <huajun.li.lee@gmail.com>
To: jaegeuk.kim@samsung.com, linux-f2fs-devel@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Huajun Li <huajun.li@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Weihong Xu <weihong.xu@intel.com>
Subject: [f2fs-dev 3/5] f2fs: Add a new function: f2fs_reserve_block()
Date: Sat, 26 Oct 2013 00:01:57 +0800
Message-Id: <1382716919-23345-4-git-send-email-huajun.li.lee@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382716919-23345-1-git-send-email-huajun.li.lee@gmail.com>
References: <1382716919-23345-1-git-send-email-huajun.li.lee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huajun Li <huajun.li@intel.com>

Add the function f2fs_reserve_block() to easily reserve new blocks.

Signed-off-by: Huajun Li <huajun.li@intel.com>
Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
Signed-off-by: Weihong Xu <weihong.xu@intel.com>
---
 fs/f2fs/data.c |   29 ++++++++++++++++++-----------
 fs/f2fs/f2fs.h |    1 +
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index c8887d8..7b31911 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -64,6 +64,23 @@ int reserve_new_block(struct dnode_of_data *dn)
 	return 0;
 }
 
+int f2fs_reserve_block(struct inode *inode,
+		       struct dnode_of_data *dn, pgoff_t index)
+{
+	int err;
+
+	set_new_dnode(dn, inode, NULL, NULL, 0);
+	err = get_dnode_of_data(dn, index, ALLOC_NODE);
+	if (err)
+		return err;
+	if (dn->data_blkaddr == NULL_ADDR)
+		err = reserve_new_block(dn);
+
+	f2fs_put_dnode(dn);
+
+	return err;
+}
+
 static int check_extent_cache(struct inode *inode, pgoff_t pgofs,
 					struct buffer_head *bh_result)
 {
@@ -644,19 +661,9 @@ repeat:
 	*pagep = page;
 
 	f2fs_lock_op(sbi);
-
-	set_new_dnode(&dn, inode, NULL, NULL, 0);
-	err = get_dnode_of_data(&dn, index, ALLOC_NODE);
-	if (err)
-		goto err;
-
-	if (dn.data_blkaddr == NULL_ADDR)
-		err = reserve_new_block(&dn);
-
-	f2fs_put_dnode(&dn);
+	err = f2fs_reserve_block(inode, &dn, index);
 	if (err)
 		goto err;
-
 	f2fs_unlock_op(sbi);
 
 	if ((len == PAGE_CACHE_SIZE) || PageUptodate(page))
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index e50a8b0..4f34330 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1112,6 +1112,7 @@ void destroy_checkpoint_caches(void);
  * data.c
  */
 int reserve_new_block(struct dnode_of_data *);
+int f2fs_reserve_block(struct inode *, struct dnode_of_data *, pgoff_t);
 void update_extent_cache(block_t, struct dnode_of_data *);
 struct page *find_data_page(struct inode *, pgoff_t, bool);
 struct page *get_lock_data_page(struct inode *, pgoff_t);
-- 
1.7.9.5

