Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab3C1GpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:45:00 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:64151 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab3C1Go5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:44:57 -0400
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jack@suse.cz, fengguang.wu@intel.com, jmoyer@redhat.com,
        zab@redhat.com, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/14] workqueue: introduce numa_pwq_tbl_install()
Date: Wed, 27 Mar 2013 23:43:37 -0700
Message-Id: <1364453020-2829-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1364453020-2829-1-git-send-email-tj@kernel.org>
References: <1364453020-2829-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out pool_workqueue linking and installation into numa_pwq_tbl[]
from apply_workqueue_attrs() into numa_pwq_tbl_install().  link_pwq()
is made safe to call multiple times.  numa_pwq_tbl_install() links the
pwq, installs it into numa_pwq_tbl[] at the specified node and returns
the old entry.

@last_pwq is removed from link_pwq() as the return value of the new
function can be used instead.

This is to prepare for NUMA affinity support for unbound workqueues.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index a4420be..527dc418 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3639,24 +3639,26 @@ static void init_pwq(struct pool_workqueue *pwq, struct workqueue_struct *wq,
 	pwq->flush_color = -1;
 	pwq->refcnt = 1;
 	INIT_LIST_HEAD(&pwq->delayed_works);
+	INIT_LIST_HEAD(&pwq->pwqs_node);
 	INIT_LIST_HEAD(&pwq->mayday_node);
 	INIT_WORK(&pwq->unbound_release_work, pwq_unbound_release_workfn);
 }
 
 /* sync @pwq with the current state of its associated wq and link it */
-static void link_pwq(struct pool_workqueue *pwq,
-		     struct pool_workqueue **p_last_pwq)
+static void link_pwq(struct pool_workqueue *pwq)
 {
 	struct workqueue_struct *wq = pwq->wq;
 
 	lockdep_assert_held(&wq->mutex);
 
+	/* may be called multiple times, ignore if already linked */
+	if (!list_empty(&pwq->pwqs_node))
+		return;
+
 	/*
 	 * Set the matching work_color.  This is synchronized with
 	 * wq->mutex to avoid confusing flush_workqueue().
 	 */
-	if (p_last_pwq)
-		*p_last_pwq = first_pwq(wq);
 	pwq->work_color = wq->work_color;
 
 	/* sync max_active to the current setting */
@@ -3689,6 +3691,23 @@ static struct pool_workqueue *alloc_unbound_pwq(struct workqueue_struct *wq,
 	return pwq;
 }
 
+/* install @pwq into @wq's numa_pwq_tbl[] for @node and return the old pwq */
+static struct pool_workqueue *numa_pwq_tbl_install(struct workqueue_struct *wq,
+						   int node,
+						   struct pool_workqueue *pwq)
+{
+	struct pool_workqueue *old_pwq;
+
+	lockdep_assert_held(&wq->mutex);
+
+	/* link_pwq() can handle duplicate calls */
+	link_pwq(pwq);
+
+	old_pwq = rcu_access_pointer(wq->numa_pwq_tbl[node]);
+	rcu_assign_pointer(wq->numa_pwq_tbl[node], pwq);
+	return old_pwq;
+}
+
 /**
  * apply_workqueue_attrs - apply new workqueue_attrs to an unbound workqueue
  * @wq: the target workqueue
@@ -3707,7 +3726,7 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 			  const struct workqueue_attrs *attrs)
 {
 	struct workqueue_attrs *new_attrs;
-	struct pool_workqueue *pwq, *last_pwq;
+	struct pool_workqueue *pwq, *last_pwq = NULL;
 	int node;
 
 	/* only unbound workqueues can change attributes */
@@ -3734,11 +3753,9 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 
 	mutex_lock(&wq->mutex);
 
-	link_pwq(pwq, &last_pwq);
-
 	copy_workqueue_attrs(wq->unbound_attrs, new_attrs);
 	for_each_node(node)
-		rcu_assign_pointer(wq->numa_pwq_tbl[node], pwq);
+		last_pwq = numa_pwq_tbl_install(wq, node, pwq);
 
 	mutex_unlock(&wq->mutex);
 
@@ -3774,7 +3791,7 @@ static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 			init_pwq(pwq, wq, &cpu_pools[highpri]);
 
 			mutex_lock(&wq->mutex);
-			link_pwq(pwq, NULL);
+			link_pwq(pwq);
 			mutex_unlock(&wq->mutex);
 		}
 		return 0;
-- 
1.8.1.4

