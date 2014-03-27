Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166AbaC0RXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 13:23:01 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:60806 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756966AbaC0RVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 13:21:10 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/4] workqueue: Move workqueue bus attr to device attribute
Date: Thu, 27 Mar 2014 18:20:59 +0100
Message-Id: <1395940862-31428-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1395940862-31428-1-git-send-email-fweisbec@gmail.com>
References: <1395940862-31428-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A workqueue directory implements at least two files: max_active and
per_cpu. Since thse are constant over WQ_SYSFS workqueues, they are
implemented as bus attributes.

Then come the attributes that only belong to unbound workqueues. Those
are implemented as device attribute.

Now we are planning to implement a specific workqueue directory in order
to control the cpu affinity of all non-ABI unbound workqueues at once.
So far we are only interested in the cpumask file on this virtual
workqueue directory: we can't have a single file max_active and per_cpu
for all non ABI unbound workqueues for example. And for now it's not
desirable to share more all-in-one property like cpu affinity.

So we want to be able to create a directory containing only cpumask.
Lets move the constant workqueue attrs as device attribute so that
we can consider skipping them when we want.

Cc: Christoph Lameter <cl@linux.com>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Mike Galbraith <bitbucket@online.de>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/workqueue.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 193e977..4d230e3 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3133,7 +3133,6 @@ static ssize_t per_cpu_show(struct device *dev, struct device_attribute *attr,
 
 	return scnprintf(buf, PAGE_SIZE, "%d\n", (bool)!(wq->flags & WQ_UNBOUND));
 }
-static DEVICE_ATTR_RO(per_cpu);
 
 static ssize_t max_active_show(struct device *dev,
 			       struct device_attribute *attr, char *buf)
@@ -3156,14 +3155,12 @@ static ssize_t max_active_store(struct device *dev,
 	workqueue_set_max_active(wq, val);
 	return count;
 }
-static DEVICE_ATTR_RW(max_active);
 
-static struct attribute *wq_sysfs_attrs[] = {
-	&dev_attr_per_cpu.attr,
-	&dev_attr_max_active.attr,
-	NULL,
+static struct device_attribute wq_sysfs_default_attrs[] = {
+	__ATTR(per_cpu, 0444, per_cpu_show, NULL),
+	__ATTR(max_active, 0644, max_active_show, max_active_store),
+	__ATTR_NULL,
 };
-ATTRIBUTE_GROUPS(wq_sysfs);
 
 static ssize_t wq_pool_ids_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -3313,7 +3310,6 @@ static struct device_attribute wq_sysfs_unbound_attrs[] = {
 
 static struct bus_type wq_subsys = {
 	.name				= "workqueue",
-	.dev_groups			= wq_sysfs_groups,
 };
 
 static int __init wq_sysfs_init(void)
@@ -3346,6 +3342,7 @@ static void wq_device_release(struct device *dev)
  */
 int workqueue_sysfs_register(struct workqueue_struct *wq)
 {
+	struct device_attribute *attr;
 	struct wq_device *wq_dev;
 	int ret;
 
@@ -3379,8 +3376,16 @@ int workqueue_sysfs_register(struct workqueue_struct *wq)
 		return ret;
 	}
 
+	for (attr = wq_sysfs_default_attrs; attr->attr.name; attr++) {
+		ret = device_create_file(&wq_dev->dev, attr);
+		if (ret) {
+			device_unregister(&wq_dev->dev);
+			wq->wq_dev = NULL;
+			return ret;
+		}
+	}
+
 	if (wq->flags & WQ_UNBOUND) {
-		struct device_attribute *attr;
 
 		for (attr = wq_sysfs_unbound_attrs; attr->attr.name; attr++) {
 			ret = device_create_file(&wq_dev->dev, attr);
-- 
1.8.3.1

