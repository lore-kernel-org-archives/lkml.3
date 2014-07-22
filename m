Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbaGVFDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 01:03:17 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:44983 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752153AbaGVFDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 01:03:06 -0400
X-IronPort-AV: E=Sophos;i="5.00,931,1396972800"; 
   d="scan'208";a="33612979"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] workqueue: get the probable node ID from the first CPU of the mask
Date: Tue, 22 Jul 2014 13:04:02 +0800
Message-ID: <1406005442-12070-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current get_unbound_pool() considers all node IDs are probable for
the pool, and it travel all nodes to find the node ID for the pool.
This travel is unnecessary, the probable node ID can be attained
from the first CPU and we need check only one possible node ID.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 347ac5b..942103d9 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3482,12 +3482,10 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 
 	/* if cpumask is contained inside a NUMA node, we belong to that node */
 	if (wq_numa_enabled) {
-		for_each_node(node) {
-			if (cpumask_subset(pool->attrs->cpumask,
-					   wq_numa_possible_cpumask[node])) {
-				pool->node = node;
-				break;
-			}
+		node = cpu_to_node(cpumask_first(pool->attrs->cpumask));
+		if (cpumask_subset(pool->attrs->cpumask,
+				   wq_numa_possible_cpumask[node])) {
+			pool->node = node;
 		}
 	}
 
-- 
1.7.4.4

