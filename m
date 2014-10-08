Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbaJHDvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 23:51:07 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:44501 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754169AbaJHDvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 23:51:03 -0400
X-IronPort-AV: E=Sophos;i="5.04,674,1406563200"; 
   d="scan'208";a="36937206"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 3/3] workqueue: remove get_online_cpus() from apply_workqueue_attrs()
Date: Wed, 8 Oct 2014 11:53:33 +0800
Message-ID: <1412740423-20782-4-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1412740423-20782-1-git-send-email-laijs@cn.fujitsu.com>
References: <1412740423-20782-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two aims for get_online_cpus():
  1) Protects cpumask_of_node(node). (CPUs should stay stable)
  2) Protects the pwq-allocation and installation

But both aims are settled by other methods in previous patches:
cpumask_of_node(node) is replaced by wq_unbound_online_cpumask, and
the pwq-allocation and installation are changed to be protected by
wq_pool_mutex.  Now the get_online_cpus() is no reason to exist,
remove it!

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   15 ++-------------
 1 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9bc3a87..63a8000 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3776,13 +3776,6 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 	 */
 	copy_workqueue_attrs(tmp_attrs, new_attrs);
 
-	/*
-	 * CPUs should stay stable across pwq creations and installations.
-	 * Pin CPUs, determine the target cpumask for each node and create
-	 * pwqs accordingly.
-	 */
-	get_online_cpus();
-
 	mutex_lock(&wq_pool_mutex);
 
 	/*
@@ -3827,7 +3820,6 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 
 	mutex_unlock(&wq_pool_mutex);
 
-	put_online_cpus();
 	ret = 0;
 	/* fall through */
 out_free:
@@ -3842,7 +3834,6 @@ enomem_pwq:
 		if (pwq_tbl && pwq_tbl[node] != dfl_pwq)
 			free_unbound_pwq(pwq_tbl[node]);
 	mutex_unlock(&wq_pool_mutex);
-	put_online_cpus();
 enomem:
 	ret = -ENOMEM;
 	goto out_free;
@@ -3921,10 +3912,8 @@ static void wq_update_unbound_numa(struct workqueue_struct *wq, int cpu)
 	}
 
 	/*
-	 * Install the new pwq.  As this function is called only from CPU
-	 * hotplug callbacks and applying a new attrs is wrapped with
-	 * get/put_online_cpus(), @wq->unbound_attrs couldn't have changed
-	 * inbetween.
+	 * Install the new pwq.  As this function is called with wq_pool_mutex
+	 * held, @wq->unbound_attrs couldn't have changed inbetween.
 	 */
 	mutex_lock(&wq->mutex);
 	old_pwq = numa_pwq_tbl_install(wq, node, pwq);
-- 
1.7.4.4

