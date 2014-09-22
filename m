Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbaIVICY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 04:02:24 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:56876 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752536AbaIVICV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 04:02:21 -0400
X-IronPort-AV: E=Sophos;i="5.04,570,1406563200"; 
   d="scan'208";a="36266776"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH] workqueue: show the pool ID of the default pwq's pool in the pool_ids file
Date: Mon, 22 Sep 2014 16:04:37 +0800
Message-ID: <1411373079-11828-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems incomplete if the pool_ids file doesn't include the default
pwq's pool.  Add it and the result:

# cat pool_ids 
0:9 1:10
default:8

rcu_read_lock_sched() is also changed to mutex_lock(&wq->mutex)
for accessing the default pwq.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 5dbe22a..6af95210 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3004,7 +3004,7 @@ static ssize_t wq_pool_ids_show(struct device *dev,
 	const char *delim = "";
 	int node, written = 0;
 
-	rcu_read_lock_sched();
+	mutex_lock(&wq->mutex);
 	for_each_node(node) {
 		written += scnprintf(buf + written, PAGE_SIZE - written,
 				     "%s%d:%d", delim, node,
@@ -3012,7 +3012,9 @@ static ssize_t wq_pool_ids_show(struct device *dev,
 		delim = " ";
 	}
 	written += scnprintf(buf + written, PAGE_SIZE - written, "\n");
-	rcu_read_unlock_sched();
+	written += scnprintf(buf + written, PAGE_SIZE - written,
+			     "default:%d\n", wq->dfl_pwq->pool->id);
+	mutex_unlock(&wq->mutex);
 
 	return written;
 }
-- 
1.7.4.4

