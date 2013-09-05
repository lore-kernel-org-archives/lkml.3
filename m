Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab3IEQhh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 12:37:37 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:36633 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab3IEQhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 12:37:35 -0400
Date: Thu, 5 Sep 2013 12:30:04 -0400
From: Tejun Heo <tj@kernel.org>
To: Libin <huawei.libin@huawei.com>
Cc: linux-kernel@vger.kernel.org, wangyijing@huawei.com, guohanjun@huawei.com,
        wujianguo@huawei.com
Subject: [PATCH] workqueue: fix ordered workqueue in NUMA setups
Message-ID: <20130905163004.GD24148@htj.dyndns.org>
References: <1378357844-15632-1-git-send-email-huawei.libin@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378357844-15632-1-git-send-email-huawei.libin@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Libin.

Thanks a lot for the report and the possible fix.  I took a different
approach as ensuring the pwqs are setup correctly during creation is
cleaner / lower overhead.  Can you please consider the followings when
submitting patches in the future?

* Please use your full name in SOBs.

* Please use tab for tabs instead of spaces and a tab should be 8
  space wide.  It's strongly discouraged to use an editor configured
  to treat a tab as four spaces.

Thanks.

----- 8< ------
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
Cc: stable@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 29b7985..9c91b1d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -305,6 +305,9 @@ static DEFINE_HASHTABLE(unbound_pool_hash, UNBOUND_POOL_HASH_ORDER);
 /* I: attributes used when instantiating standard unbound pools on demand */
 static struct workqueue_attrs *unbound_std_wq_attrs[NR_STD_WORKER_POOLS];
 
+/* I: attributes used when instantiating ordered pools on demand */
+static struct workqueue_attrs *ordered_wq_attrs[NR_STD_WORKER_POOLS];
+
 struct workqueue_struct *system_wq __read_mostly;
 EXPORT_SYMBOL(system_wq);
 struct workqueue_struct *system_highpri_wq __read_mostly;
@@ -4084,7 +4087,7 @@ out_unlock:
 static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 {
 	bool highpri = wq->flags & WQ_HIGHPRI;
-	int cpu;
+	int cpu, ret;
 
 	if (!(wq->flags & WQ_UNBOUND)) {
 		wq->cpu_pwqs = alloc_percpu(struct pool_workqueue);
@@ -4104,6 +4107,13 @@ static int alloc_and_link_pwqs(struct workqueue_struct *wq)
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
@@ -5026,13 +5036,23 @@ static int __init init_workqueues(void)
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
