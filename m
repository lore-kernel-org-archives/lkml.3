Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab3KNQka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:40:30 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:58185 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab3KNQjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:39:42 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Li Xi <lixi@ddn.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 19/39] staging/lustre/libcfs: Add relocation function to libcfs heap
Date: Fri, 15 Nov 2013 00:32:42 +0800
Message-Id: <1384446782-13741-20-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Xi <lixi@ddn.com>

When changing the values of the node in the heap which might affect
its ranking, we have to remove the node from the heap, change the
values and then insert the node into the heap again. The process of
inserting into the heap might fail because of memory insufficiency.
Sometimes, it is not convienient and efficient for a caller to handle
such kind of failure.

This patch adds a new function to do the job.

Lustre-change: http://review.whamcloud.com/6743
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3494
Signed-off-by: Li Xi <lixi@ddn.com>
Reviewed-by: Bobbie Lind <bobbie.j.lind@intel.com>
Reviewed-by: Liang Zhen <liang.zhen@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/include/linux/libcfs/libcfs_heap.h      |    1 +
 drivers/staging/lustre/lustre/libcfs/heap.c        |   18 ++++++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_heap.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_heap.h
index bfa6d7b..9d72647 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_heap.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_heap.h
@@ -166,6 +166,7 @@ cfs_binheap_t *cfs_binheap_create(cfs_binheap_ops_t *ops, unsigned int flags,
 cfs_binheap_node_t *cfs_binheap_find(cfs_binheap_t *h, unsigned int idx);
 int cfs_binheap_insert(cfs_binheap_t *h, cfs_binheap_node_t *e);
 void cfs_binheap_remove(cfs_binheap_t *h, cfs_binheap_node_t *e);
+void cfs_binheap_relocate(cfs_binheap_t *h, cfs_binheap_node_t *e);
 
 static inline int
 cfs_binheap_size(cfs_binheap_t *h)
diff --git a/drivers/staging/lustre/lustre/libcfs/heap.c b/drivers/staging/lustre/lustre/libcfs/heap.c
index 147e4fe..2493582 100644
--- a/drivers/staging/lustre/lustre/libcfs/heap.c
+++ b/drivers/staging/lustre/lustre/libcfs/heap.c
@@ -463,8 +463,7 @@ cfs_binheap_remove(cfs_binheap_t *h, cfs_binheap_node_t *e)
 
 	last->chn_index = cur_idx;
 	*cur_ptr = last;
-	if (!cfs_binheap_bubble(h, *cur_ptr))
-		cfs_binheap_sink(h, *cur_ptr);
+	cfs_binheap_relocate(h, *cur_ptr);
 
 	e->chn_index = CBH_POISON;
 	if (h->cbh_ops->hop_exit)
@@ -472,4 +471,19 @@ cfs_binheap_remove(cfs_binheap_t *h, cfs_binheap_node_t *e)
 }
 EXPORT_SYMBOL(cfs_binheap_remove);
 
+/**
+ * Relocate a node in the binary heap.
+ * Should be called whenever a node's values
+ * which affects its ranking are changed.
+ *
+ * \param[in] h The heap
+ * \param[in] e The node
+ */
+void
+cfs_binheap_relocate(cfs_binheap_t *h, cfs_binheap_node_t *e)
+{
+	if (!cfs_binheap_bubble(h, e))
+		cfs_binheap_sink(h, e);
+}
+EXPORT_SYMBOL(cfs_binheap_relocate);
 /** @} heap */
-- 
1.7.9.5

