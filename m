Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab3LBTp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:45:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39560 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab3LBTSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Libin <huawei.libin@huawei.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 3.12 154/212] workqueue: fix ordered workqueues in NUMA setups
Date: Mon,  2 Dec 2013 11:15:45 -0800
Message-Id: <20131202191304.629279916@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 8a2b75384444488fc4f2cbb9f0921b6a0794838f upstream.

An ordered workqueue implements execution ordering by using single
pool_workqueue with max_active == 1.  On a given pool_workqueue, work
items are processed in FIFO order and limiting max_active to 1
enforces the queued work items to be processed one by one.

Unfortunately, 4c16bd327c ("workqueue: implement NUMA affinity for
unbound workqueues") accidentally broke this guarantee by applying
NUMA affinity to ordered workqueues too.  On NUMA setups, an ordered
workqueue would end up with separate pool_workqueues for different
nodes.  Each pool_workqueue still limits max_active to 1 but multiple
work items may be executed concurrently and out of order depending on
which node they are queued to.

Fix it by using dedicated ordered_wq_attrs[] when creating ordered
workqueues.  The new attrs match the unbound ones except that no_numa
is always set thus forcing all NUMA nodes to share the default
pool_workqueue.

While at it, add sanity check in workqueue creation path which
verifies that an ordered workqueues has only the default
pool_workqueue.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Libin <huawei.libin@huawei.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/workqueue.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -305,6 +305,9 @@ static DEFINE_HASHTABLE(unbound_pool_has
 /* I: attributes used when instantiating standard unbound pools on demand */
 static struct workqueue_attrs *unbound_std_wq_attrs[NR_STD_WORKER_POOLS];
 
+/* I: attributes used when instantiating ordered pools on demand */
+static struct workqueue_attrs *ordered_wq_attrs[NR_STD_WORKER_POOLS];
+
 struct workqueue_struct *system_wq __read_mostly;
 EXPORT_SYMBOL(system_wq);
 struct workqueue_struct *system_highpri_wq __read_mostly;
@@ -4106,7 +4109,7 @@ out_unlock:
 static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 {
 	bool highpri = wq->flags & WQ_HIGHPRI;
-	int cpu;
+	int cpu, ret;
 
 	if (!(wq->flags & WQ_UNBOUND)) {
 		wq->cpu_pwqs = alloc_percpu(struct pool_workqueue);
@@ -4126,6 +4129,13 @@ static int alloc_and_link_pwqs(struct wo
 			mutex_unlock(&wq->mutex);
 		}
 		return 0;
+	} else if (wq->flags & __WQ_ORDERED) {
+		ret = apply_workqueue_attrs(wq, ordered_wq_attrs[highpri]);
+		/* there should only be single pwq for ordering guarantee */
+		WARN(!ret && (wq->pwqs.next != &wq->dfl_pwq->pwqs_node ||
+			      wq->pwqs.prev != &wq->dfl_pwq->pwqs_node),
+		     "ordering guarantee broken for workqueue %s\n", wq->name);
+		return ret;
 	} else {
 		return apply_workqueue_attrs(wq, unbound_std_wq_attrs[highpri]);
 	}
@@ -5051,13 +5061,23 @@ static int __init init_workqueues(void)
 		}
 	}
 
-	/* create default unbound wq attrs */
+	/* create default unbound and ordered wq attrs */
 	for (i = 0; i < NR_STD_WORKER_POOLS; i++) {
 		struct workqueue_attrs *attrs;
 
 		BUG_ON(!(attrs = alloc_workqueue_attrs(GFP_KERNEL)));
 		attrs->nice = std_nice[i];
 		unbound_std_wq_attrs[i] = attrs;
+
+		/*
+		 * An ordered wq should have only one pwq as ordering is
+		 * guaranteed by max_active which is enforced by pwqs.
+		 * Turn off NUMA so that dfl_pwq is used for all nodes.
+		 */
+		BUG_ON(!(attrs = alloc_workqueue_attrs(GFP_KERNEL)));
+		attrs->nice = std_nice[i];
+		attrs->no_numa = true;
+		ordered_wq_attrs[i] = attrs;
 	}
 
 	system_wq = alloc_workqueue("events", 0, 0);


