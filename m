Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbaEGQhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:37:21 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:48156 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039AbaEGQhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:37:16 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5/6] workqueue: Allow modifying low level unbound workqueue cpumask
Date: Wed,  7 May 2014 18:37:00 +0200
Message-Id: <1399480621-19555-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1399480621-19555-1-git-send-email-fweisbec@gmail.com>
References: <1399480621-19555-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow to modify the low-level unbound workqueues cpumask through
sysfs. This is performed by traversing the entire workqueue list
and calling apply_workqueue_attrs() on the unbound workqueues.

Cc: Christoph Lameter <cl@linux.com>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Mike Galbraith <bitbucket@online.de>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/workqueue.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 63 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 2aa296d..5978cee 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -293,7 +293,7 @@ static DEFINE_SPINLOCK(wq_mayday_lock);	/* protects wq->maydays list */
 static LIST_HEAD(workqueues);		/* PL: list of all workqueues */
 static bool workqueue_freezing;		/* PL: have wqs started freezing? */
 
-static cpumask_var_t wq_unbound_cpumask;
+static cpumask_var_t wq_unbound_cpumask; /* PL: low level cpumask for all unbound wqs */
 
 /* the per-cpu worker pools */
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct worker_pool [NR_STD_WORKER_POOLS],
@@ -4084,19 +4084,80 @@ static struct bus_type wq_subsys = {
 	.dev_groups			= wq_sysfs_groups,
 };
 
+static int unbounds_cpumask_apply(cpumask_var_t cpumask)
+{
+	struct workqueue_struct *wq;
+	int ret;
+
+	lockdep_assert_held(&wq_pool_mutex);
+
+	list_for_each_entry(wq, &workqueues, list) {
+		struct workqueue_attrs *attrs;
+
+		if (!(wq->flags & WQ_UNBOUND))
+			continue;
+
+		attrs = wq_sysfs_prep_attrs(wq);
+		if (!attrs)
+			return -ENOMEM;
+
+		ret = apply_workqueue_attrs_locked(wq, attrs, cpumask);
+		free_workqueue_attrs(attrs);
+		if (ret)
+			break;
+	}
+
+	return 0;
+}
+
+static ssize_t unbounds_cpumask_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	cpumask_var_t cpumask;
+	int ret = -EINVAL;
+
+	if (!zalloc_cpumask_var(&cpumask, GFP_KERNEL))
+		return -ENOMEM;
+
+	ret = cpumask_parse(buf, cpumask);
+	if (ret)
+		goto out;
+
+	get_online_cpus();
+	if (cpumask_intersects(cpumask, cpu_online_mask)) {
+		mutex_lock(&wq_pool_mutex);
+		ret = unbounds_cpumask_apply(cpumask);
+		if (ret < 0) {
+			/* Warn if rollback itself fails */
+			WARN_ON_ONCE(unbounds_cpumask_apply(wq_unbound_cpumask));
+		} else {
+			cpumask_copy(wq_unbound_cpumask, cpumask);
+		}
+		mutex_unlock(&wq_pool_mutex);
+	}
+	put_online_cpus();
+out:
+	free_cpumask_var(cpumask);
+	return ret ? ret : count;
+}
+
 static ssize_t unbounds_cpumask_show(struct device *dev,
 				     struct device_attribute *attr, char *buf)
 {
 	int written;
 
+	mutex_lock(&wq_pool_mutex);
 	written = cpumask_scnprintf(buf, PAGE_SIZE, wq_unbound_cpumask);
+	mutex_unlock(&wq_pool_mutex);
+
 	written += scnprintf(buf + written, PAGE_SIZE - written, "\n");
 
 	return written;
 }
 
 static struct device_attribute wq_sysfs_cpumask_attr =
-	__ATTR(cpumask, 0444, unbounds_cpumask_show, NULL);
+	__ATTR(cpumask, 0644, unbounds_cpumask_show, unbounds_cpumask_store);
 
 static int __init wq_sysfs_init(void)
 {
-- 
1.8.3.1

