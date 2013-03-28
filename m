Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab3C1Go2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:44:28 -0400
Received: from mail-qe0-f53.google.com ([209.85.128.53]:59661 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab3C1GoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:44:24 -0400
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jack@suse.cz, fengguang.wu@intel.com, jmoyer@redhat.com,
        zab@redhat.com, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/14] workqueue: add workqueue->unbound_attrs
Date: Wed, 27 Mar 2013 23:43:31 -0700
Message-Id: <1364453020-2829-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1364453020-2829-1-git-send-email-tj@kernel.org>
References: <1364453020-2829-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, when exposing attrs of an unbound workqueue via sysfs, the
workqueue_attrs of first_pwq() is used as that should equal the
current state of the workqueue.

The planned NUMA affinity support will make unbound workqueues make
use of multiple pool_workqueues for different NUMA nodes and the above
assumption will no longer hold.  Introduce workqueue->unbound_attrs
which records the current attrs in effect and use it for sysfs instead
of first_pwq()->attrs.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index fab2630..65f200c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -244,6 +244,8 @@ struct workqueue_struct {
 	int			nr_drainers;	/* WQ: drain in progress */
 	int			saved_max_active; /* WQ: saved pwq max_active */
 
+	struct workqueue_attrs	*unbound_attrs;	/* WQ: only for unbound wqs */
+
 #ifdef CONFIG_SYSFS
 	struct wq_device	*wq_dev;	/* I: for sysfs interface */
 #endif
@@ -3088,10 +3090,9 @@ static ssize_t wq_nice_show(struct device *dev, struct device_attribute *attr,
 	struct workqueue_struct *wq = dev_to_wq(dev);
 	int written;
 
-	rcu_read_lock_sched();
-	written = scnprintf(buf, PAGE_SIZE, "%d\n",
-			    first_pwq(wq)->pool->attrs->nice);
-	rcu_read_unlock_sched();
+	mutex_lock(&wq->mutex);
+	written = scnprintf(buf, PAGE_SIZE, "%d\n", wq->unbound_attrs->nice);
+	mutex_unlock(&wq->mutex);
 
 	return written;
 }
@@ -3105,9 +3106,9 @@ static struct workqueue_attrs *wq_sysfs_prep_attrs(struct workqueue_struct *wq)
 	if (!attrs)
 		return NULL;
 
-	rcu_read_lock_sched();
-	copy_workqueue_attrs(attrs, first_pwq(wq)->pool->attrs);
-	rcu_read_unlock_sched();
+	mutex_lock(&wq->mutex);
+	copy_workqueue_attrs(attrs, wq->unbound_attrs);
+	mutex_unlock(&wq->mutex);
 	return attrs;
 }
 
@@ -3138,10 +3139,9 @@ static ssize_t wq_cpumask_show(struct device *dev,
 	struct workqueue_struct *wq = dev_to_wq(dev);
 	int written;
 
-	rcu_read_lock_sched();
-	written = cpumask_scnprintf(buf, PAGE_SIZE,
-				    first_pwq(wq)->pool->attrs->cpumask);
-	rcu_read_unlock_sched();
+	mutex_lock(&wq->mutex);
+	written = cpumask_scnprintf(buf, PAGE_SIZE, wq->unbound_attrs->cpumask);
+	mutex_unlock(&wq->mutex);
 
 	written += scnprintf(buf + written, PAGE_SIZE - written, "\n");
 	return written;
@@ -3558,8 +3558,10 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
 	 * If we're the last pwq going away, @wq is already dead and no one
 	 * is gonna access it anymore.  Free it.
 	 */
-	if (is_last)
+	if (is_last) {
+		free_workqueue_attrs(wq->unbound_attrs);
 		kfree(wq);
+	}
 }
 
 /**
@@ -3634,6 +3636,9 @@ static void init_and_link_pwq(struct pool_workqueue *pwq,
 	/* link in @pwq */
 	list_add_rcu(&pwq->pwqs_node, &wq->pwqs);
 
+	if (wq->flags & WQ_UNBOUND)
+		copy_workqueue_attrs(wq->unbound_attrs, pool->attrs);
+
 	mutex_unlock(&wq->mutex);
 }
 
@@ -3761,6 +3766,12 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	if (!wq)
 		return NULL;
 
+	if (flags & WQ_UNBOUND) {
+		wq->unbound_attrs = alloc_workqueue_attrs(GFP_KERNEL);
+		if (!wq->unbound_attrs)
+			goto err_free_wq;
+	}
+
 	vsnprintf(wq->name, namelen, fmt, args1);
 	va_end(args);
 	va_end(args1);
@@ -3830,6 +3841,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	return wq;
 
 err_free_wq:
+	free_workqueue_attrs(wq->unbound_attrs);
 	kfree(wq);
 	return NULL;
 err_destroy:
-- 
1.8.1.4

