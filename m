Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbaEGQi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:38:59 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:52040 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943AbaEGQhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:37:13 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 3/6] workqueue: Create low-level unbound workqueues cpumask
Date: Wed,  7 May 2014 18:36:58 +0200
Message-Id: <1399480621-19555-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1399480621-19555-1-git-send-email-fweisbec@gmail.com>
References: <1399480621-19555-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a cpumask that limit the affinity of all unbound workqueues.
This cpumask is controlled though a file at the root of the workqueue
sysfs directory.

It works on a lower-level than the per WQ_SYSFS workqueues cpumask files
such that the effective cpumask applied for a given unbound workqueue is
the intersection of /sys/devices/virtual/workqueue/$WORKQUEUE/cpumask and
the new /sys/devices/virtual/workqueue/cpumask_unbounds file.

This patch implements the basic infrastructure and the read interface.
cpumask_unbounds is initially set to cpu_possible_mask.

Cc: Christoph Lameter <cl@linux.com>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Mike Galbraith <bitbucket@online.de>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/workqueue.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e5d7719..1252a8c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -293,6 +293,8 @@ static DEFINE_SPINLOCK(wq_mayday_lock);	/* protects wq->maydays list */
 static LIST_HEAD(workqueues);		/* PL: list of all workqueues */
 static bool workqueue_freezing;		/* PL: have wqs started freezing? */
 
+static cpumask_var_t wq_unbound_cpumask;
+
 /* the per-cpu worker pools */
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct worker_pool [NR_STD_WORKER_POOLS],
 				     cpu_worker_pools);
@@ -3674,7 +3676,7 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 
 	/* make a copy of @attrs and sanitize it */
 	copy_workqueue_attrs(new_attrs, attrs);
-	cpumask_and(new_attrs->cpumask, new_attrs->cpumask, cpu_possible_mask);
+	cpumask_and(new_attrs->cpumask, new_attrs->cpumask, wq_unbound_cpumask);
 
 	/*
 	 * We may create multiple pwqs with differing cpumasks.  Make a
@@ -4071,9 +4073,29 @@ static struct bus_type wq_subsys = {
 	.dev_groups			= wq_sysfs_groups,
 };
 
+static ssize_t unbounds_cpumask_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	int written;
+
+	written = cpumask_scnprintf(buf, PAGE_SIZE, wq_unbound_cpumask);
+	written += scnprintf(buf + written, PAGE_SIZE - written, "\n");
+
+	return written;
+}
+
+static struct device_attribute wq_sysfs_cpumask_attr =
+	__ATTR(cpumask, 0444, unbounds_cpumask_show, NULL);
+
 static int __init wq_sysfs_init(void)
 {
-	return subsys_virtual_register(&wq_subsys, NULL);
+	int err;
+
+	err = subsys_virtual_register(&wq_subsys, NULL);
+	if (err)
+		return err;
+
+	return device_create_file(wq_subsys.dev_root, &wq_sysfs_cpumask_attr);
 }
 core_initcall(wq_sysfs_init);
 
@@ -5068,6 +5090,9 @@ static int __init init_workqueues(void)
 
 	WARN_ON(__alignof__(struct pool_workqueue) < __alignof__(long long));
 
+	BUG_ON(!alloc_cpumask_var(&wq_unbound_cpumask, GFP_KERNEL));
+	cpumask_copy(wq_unbound_cpumask, cpu_possible_mask);
+
 	pwq_cache = KMEM_CACHE(pool_workqueue, SLAB_PANIC);
 
 	cpu_notifier(workqueue_cpu_up_callback, CPU_PRI_WORKQUEUE_UP);
-- 
1.8.3.1

