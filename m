Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaGVFEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 01:04:20 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:30267 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750821AbaGVFES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 01:04:18 -0400
X-IronPort-AV: E=Sophos;i="5.00,931,1396972800"; 
   d="scan'208";a="33613067"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] workqueue: remove the suspicuous out_unlock label in get_unbound_pool()
Date: Tue, 22 Jul 2014 13:04:49 +0800
Message-ID: <1406005489-12140-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the locking was moved up to the caller of the get_unbound_pool(),
out_unlock label doesn't need to do any unlock operation and the name
became bad, so we just remove this label, and the only usage-site
"goto out_unlock" is subsituted to "return pool".

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index b8990cf..4e9f722 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3462,7 +3462,7 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 	hash_for_each_possible(unbound_pool_hash, pool, hash_node, hash) {
 		if (wqattrs_equal(pool->attrs, attrs)) {
 			pool->refcnt++;
-			goto out_unlock;
+			return pool;
 		}
 	}
 
@@ -3498,7 +3498,7 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 
 	/* install */
 	hash_add(unbound_pool_hash, &pool->hash_node, hash);
-out_unlock:
+
 	return pool;
 fail:
 	if (pool)
-- 
1.7.4.4

