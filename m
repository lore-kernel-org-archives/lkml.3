Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932888AbbAFV1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 16:27:30 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:54570 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932838AbbAFV1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:27:22 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org,
        hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com,
        lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
        mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com,
        david@fromorbit.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 29/45] writeback: move i_wb_list emptiness test into inode_wb_list_del() from its caller
Date: Tue,  6 Jan 2015 16:26:06 -0500
Message-Id: <1420579582-8516-30-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420579582-8516-1-git-send-email-tj@kernel.org>
References: <1420579582-8516-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

inode_wb_list_del() has one caller, evict(), which tests whether
inode->i_wb_list is empty before invoking the function.  With cgroup
writeback support, an inode may belong to multiple bdi_writeback's
rendering this test incorrect or at least insufficient.  This patch
moves the test into inode_wb_list_del() so that later patches can
update the logic in the function proper.

This does add a function call and jump when a clean inode is being
evicted but this shouldn't be anything noticeable and if it ever is
making that part an inline logic in fs/internal.h is easy.

This patch is pure code reorganization.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c | 3 +++
 fs/inode.c        | 4 +---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 4094d30..0fcdfe9 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -510,6 +510,9 @@ void inode_wb_list_del(struct inode *inode)
 	struct backing_dev_info *bdi = inode_to_bdi(inode);
 	struct bdi_writeback *wb = &bdi->wb;
 
+	if (list_empty(&inode->i_wb_list))
+		return;
+
 	spin_lock(&wb->list_lock);
 	inode_wb_list_del_locked(inode, wb);
 	spin_unlock(&wb->list_lock);
diff --git a/fs/inode.c b/fs/inode.c
index aa149e7..7fbfc00 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -536,9 +536,7 @@ static void evict(struct inode *inode)
 	BUG_ON(!(inode->i_state & I_FREEING));
 	BUG_ON(!list_empty(&inode->i_lru));
 
-	if (!list_empty(&inode->i_wb_list))
-		inode_wb_list_del(inode);
-
+	inode_wb_list_del(inode);
 	inode_sb_list_del(inode);
 
 	/*
-- 
2.1.0

