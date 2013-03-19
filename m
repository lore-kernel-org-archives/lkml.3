Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961Ab3CST2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:28:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:43321 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932810Ab3CST2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:28:42 -0400
X-IronPort-AV: E=Sophos;i="4.84,874,1355068800"; 
   d="scan'208";a="6904497"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 02/21] workqueue: don't free pool->worker_idr by RCU
Date: Wed, 20 Mar 2013 03:28:02 +0800
Message-Id: <1363721306-2030-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:15,
	Serialize complete at 2013/03/20 03:27:15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pool->worker_idr nor worker->id is not protected by RCU.
don't need to free pool->worker_idr by RCU.

Just free it directly.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 40f4017..298cefe 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3411,7 +3411,6 @@ static void rcu_free_pool(struct rcu_head *rcu)
 {
 	struct worker_pool *pool = container_of(rcu, struct worker_pool, rcu);
 
-	idr_destroy(&pool->worker_idr);
 	free_workqueue_attrs(pool->attrs);
 	kfree(pool);
 }
@@ -3462,6 +3461,7 @@ static void put_unbound_pool(struct worker_pool *pool)
 		destroy_worker(worker);
 	WARN_ON(pool->nr_workers || pool->nr_idle);
 
+	idr_destroy(&pool->worker_idr);
 	spin_unlock_irq(&pool->lock);
 	mutex_unlock(&pool->manager_mutex);
 	mutex_unlock(&pool->manager_arb);
-- 
1.7.7.6

