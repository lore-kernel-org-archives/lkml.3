Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbaGVFEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 01:04:41 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:47882 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752840AbaGVFEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 01:04:38 -0400
X-IronPort-AV: E=Sophos;i="5.00,931,1396972800"; 
   d="scan'208";a="33613094"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] workqueue: use nr_node_ids instead of wq_numa_tbl_len
Date: Tue, 22 Jul 2014 13:05:40 +0800
Message-ID: <1406005540-12174-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are the same and nr_node_ids is provided by the memory subsystem.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 4e9f722..7207393 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -265,7 +265,6 @@ struct workqueue_struct {
 
 static struct kmem_cache *pwq_cache;
 
-static int wq_numa_tbl_len;		/* highest possible NUMA node id + 1 */
 static cpumask_var_t *wq_numa_possible_cpumask;
 					/* possible CPUs of each node */
 
@@ -3760,7 +3759,7 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 	if (WARN_ON((wq->flags & __WQ_ORDERED) && !list_empty(&wq->pwqs)))
 		return -EINVAL;
 
-	pwq_tbl = kzalloc(wq_numa_tbl_len * sizeof(pwq_tbl[0]), GFP_KERNEL);
+	pwq_tbl = kzalloc(nr_node_ids * sizeof(pwq_tbl[0]), GFP_KERNEL);
 	new_attrs = alloc_workqueue_attrs(GFP_KERNEL);
 	tmp_attrs = alloc_workqueue_attrs(GFP_KERNEL);
 	if (!pwq_tbl || !new_attrs || !tmp_attrs)
@@ -4008,7 +4007,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 
 	/* allocate wq and format name */
 	if (flags & WQ_UNBOUND)
-		tbl_size = wq_numa_tbl_len * sizeof(wq->numa_pwq_tbl[0]);
+		tbl_size = nr_node_ids * sizeof(wq->numa_pwq_tbl[0]);
 
 	wq = kzalloc(sizeof(*wq) + tbl_size, GFP_KERNEL);
 	if (!wq)
@@ -4779,10 +4778,6 @@ static void __init wq_numa_init(void)
 	cpumask_var_t *tbl;
 	int node, cpu;
 
-	/* determine NUMA pwq table len - highest node id + 1 */
-	for_each_node(node)
-		wq_numa_tbl_len = max(wq_numa_tbl_len, node + 1);
-
 	if (num_possible_nodes() <= 1)
 		return;
 
@@ -4799,7 +4794,7 @@ static void __init wq_numa_init(void)
 	 * available.  Build one from cpu_to_node() which should have been
 	 * fully initialized by now.
 	 */
-	tbl = kzalloc(wq_numa_tbl_len * sizeof(tbl[0]), GFP_KERNEL);
+	tbl = kzalloc(nr_node_ids * sizeof(tbl[0]), GFP_KERNEL);
 	BUG_ON(!tbl);
 
 	for_each_node(node)
-- 
1.7.4.4

