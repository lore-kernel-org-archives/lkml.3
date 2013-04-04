Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975Ab3DDCHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 22:07:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:17418 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932802Ab3DDCGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 22:06:00 -0400
X-IronPort-AV: E=Sophos;i="4.87,404,1363104000"; 
   d="scan'208";a="6998072"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 5/7] workqueue, use default pwq when fail to allocate node pwd
Date: Thu, 4 Apr 2013 10:05:36 +0800
Message-Id: <1365041143-3088-5-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1365041143-3088-1-git-send-email-laijs@cn.fujitsu.com>
References: <1365041143-3088-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/04 10:04:58,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/04 10:04:58,
	Serialize complete at 2013/04/04 10:04:58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we fail to allocate the node pwq, we can use the default pwq
for the node.

Thus we can avoid failure after allocated default pwq, and remove
some code for failure path.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   28 +++++++---------------------
 1 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index a383eaf..737646d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3751,17 +3751,6 @@ static struct pool_workqueue *alloc_unbound_pwq(struct workqueue_struct *wq,
 	return pwq;
 }
 
-/* undo alloc_unbound_pwq(), used only in the error path */
-static void free_unbound_pwq(struct pool_workqueue *pwq)
-{
-	lockdep_assert_held(&wq_pool_mutex);
-
-	if (pwq) {
-		put_unbound_pool(pwq->pool);
-		kfree(pwq);
-	}
-}
-
 /**
  * wq_calc_node_mask - calculate a wq_attrs' cpumask for the specified node
  * @attrs: the wq_attrs of interest
@@ -3891,12 +3880,12 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 	for_each_node(node) {
 		if (wq_calc_node_cpumask(attrs, node, -1, tmp_attrs->cpumask)) {
 			pwq_tbl[node] = alloc_unbound_pwq(wq, tmp_attrs);
-			if (!pwq_tbl[node])
-				goto enomem_pwq;
-		} else {
-			dfl_pwq->refcnt++;
-			pwq_tbl[node] = dfl_pwq;
+			if (pwq_tbl[node])
+				continue;
+			/* fallback to dfl_pwq if the allocation failed */
 		}
+		dfl_pwq->refcnt++;
+		pwq_tbl[node] = dfl_pwq;
 	}
 
 	mutex_unlock(&wq_pool_mutex);
@@ -3931,10 +3920,6 @@ out_free:
 	return ret;
 
 enomem_pwq:
-	free_unbound_pwq(dfl_pwq);
-	for_each_node(node)
-		if (pwq_tbl && pwq_tbl[node] != dfl_pwq)
-			free_unbound_pwq(pwq_tbl[node]);
 	mutex_unlock(&wq_pool_mutex);
 	put_online_cpus();
 enomem:
@@ -4017,7 +4002,8 @@ static void wq_update_unbound_numa(struct workqueue_struct *wq, int cpu,
 	if (!pwq) {
 		pr_warning("workqueue: allocation failed while updating NUMA affinity of \"%s\"\n",
 			   wq->name);
-		goto out_unlock;
+		mutex_lock(&wq->mutex);
+		goto use_dfl_pwq;
 	}
 
 	/*
-- 
1.7.7.6

