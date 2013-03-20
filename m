Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933962Ab3CTAAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 20:00:51 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:40851 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab3CTAAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 20:00:47 -0400
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jack@suse.cz, fengguang.wu@intel.com, jmoyer@redhat.com,
        zab@redhat.com, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/10] workqueue: add workqueue->unbound_attrs
Date: Tue, 19 Mar 2013 17:00:23 -0700
Message-Id: <1363737629-16745-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363737629-16745-1-git-send-email-tj@kernel.org>
References: <1363737629-16745-1-git-send-email-tj@kernel.org>
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
index 2768ed2..57e6139 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -247,6 +247,8 @@ struct workqueue_struct {
 	int			nr_drainers;	/* WQ: drain in progress */
 	int			saved_max_active; /* PW: saved pwq max_active */
 
+	struct workqueue_attrs	*unbound_attrs;	/* WQ: only for unbound wqs */
+
 #ifdef CONFIG_SYSFS
 	struct wq_device	*wq_dev;	/* I: for sysfs interface */
 #endif
@@ -3099,10 +3101,9 @@ static ssize_t wq_nice_show(struct device *dev, struct device_attribute *attr,
 	struct workqueue_struct *wq = dev_to_wq(dev);
 	int written;
 
-	rcu_read_lock_sched();
-	written = scnprintf(buf, PAGE_SIZE, "%d\n",
-			    first_pwq(wq)->pool->attrs->nice);
-	rcu_read_unlock_sched();
+	mutex_lock(&wq_mutex);
+	written = scnprintf(buf, PAGE_SIZE, "%d\n", wq->unbound_attrs->nice);
+	mutex_unlock(&wq_mutex);
 
 	return written;
 }
@@ -3116,9 +3117,9 @@ static struct workqueue_attrs *wq_sysfs_prep_attrs(struct workqueue_struct *wq)
 	if (!attrs)
 		return NULL;
 
-	rcu_read_lock_sched();
-	copy_workqueue_attrs(attrs, first_pwq(wq)->pool->attrs);
-	rcu_read_unlock_sched();
+	mutex_lock(&wq_mutex);
+	copy_workqueue_attrs(attrs, wq->unbound_attrs);
+	mutex_unlock(&wq_mutex);
 	return attrs;
 }
 
@@ -3149,10 +3150,9 @@ static ssize_t wq_cpumask_show(struct device *dev,
 	struct workqueue_struct *wq = dev_to_wq(dev);
 	int written;
 
-	rcu_read_lock_sched();
-	written = cpumask_scnprintf(buf, PAGE_SIZE,
-				    first_pwq(wq)->pool->attrs->cpumask);
-	rcu_read_unlock_sched();
+	mutex_lock(&wq_mutex);
+	written = cpumask_scnprintf(buf, PAGE_SIZE, wq->unbound_attrs->cpumask);
+	mutex_unlock(&wq_mutex);
 
 	written += scnprintf(buf + written, PAGE_SIZE - written, "\n");
 	return written;
@@ -3585,8 +3585,10 @@ static void pwq_unbound_release_workfn(struct work_struct *work)
 	 * If we're the last pwq going away, @wq is already dead and no one
 	 * is gonna access it anymore.  Free it.
 	 */
-	if (list_empty(&wq->pwqs))
+	if (list_empty(&wq->pwqs)) {
+		free_workqueue_attrs(wq->unbound_attrs);
 		kfree(wq);
+	}
 }
 
 /**
@@ -3656,6 +3658,9 @@ static void init_and_link_pwq(struct pool_workqueue *pwq,
 	/* link in @pwq */
 	list_add_rcu(&pwq->pwqs_node, &wq->pwqs);
 
+	if (wq->flags & WQ_UNBOUND)
+		copy_workqueue_attrs(wq->unbound_attrs, pool->attrs);
+
 	spin_unlock_irq(&pwq_lock);
 	mutex_unlock(&wq->flush_mutex);
 }
@@ -3764,6 +3769,12 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
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
@@ -3832,6 +3843,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 	return wq;
 
 err_free_wq:
+	free_workqueue_attrs(wq->unbound_attrs);
 	kfree(wq);
 	return NULL;
 err_destroy:
-- 
1.8.1.4

