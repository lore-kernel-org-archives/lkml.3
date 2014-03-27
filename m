Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034AbaC0RVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 13:21:33 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:61955 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021AbaC0RV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 13:21:28 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/4] workqueues: Account unbound workqueue in a seperate list
Date: Thu, 27 Mar 2014 18:21:00 +0100
Message-Id: <1395940862-31428-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1395940862-31428-1-git-send-email-fweisbec@gmail.com>
References: <1395940862-31428-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The workqueues are all listed in a global list protected by a big mutex.
And this big mutex is used in apply_workqueue_attrs() as well.

Now as we plan to implement a directory to control the cpumask of
all non-ABI unbound workqueues, we want to be able to iterate over all
unbound workqueues and call apply_workqueue_attrs() for each of
them with the new cpumask.

But the risk for a deadlock is on the way: we need to iterate the list
of workqueues under wq_pool_mutex. But then apply_workqueue_attrs()
itself calls wq_pool_mutex.

The easiest solution to work around this is to keep track of unbound
workqueues in a separate list with a separate mutex.

Cc: Christoph Lameter <cl@linux.com>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Mike Galbraith <bitbucket@online.de>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/workqueue.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 4d230e3..8749bef 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -131,6 +131,8 @@ enum {
  *
  * PR: wq_pool_mutex protected for writes.  Sched-RCU protected for reads.
  *
+ * PU: wq_unbound_mutex protected
+ *
  * WQ: wq->mutex protected.
  *
  * WR: wq->mutex protected for writes.  Sched-RCU protected for reads.
@@ -232,6 +234,7 @@ struct wq_device;
 struct workqueue_struct {
 	struct list_head	pwqs;		/* WR: all pwqs of this wq */
 	struct list_head	list;		/* PL: list of all workqueues */
+	struct list_head	unbound_list;	/* PU: list of unbound workqueues */
 
 	struct mutex		mutex;		/* protects this wq */
 	int			work_color;	/* WQ: current work color */
@@ -288,9 +291,11 @@ static bool wq_numa_enabled;		/* unbound NUMA affinity enabled */
 static struct workqueue_attrs *wq_update_unbound_numa_attrs_buf;
 
 static DEFINE_MUTEX(wq_pool_mutex);	/* protects pools and workqueues list */
+static DEFINE_MUTEX(wq_unbound_mutex);	/* protects list of unbound workqueues */
 static DEFINE_SPINLOCK(wq_mayday_lock);	/* protects wq->maydays list */
 
 static LIST_HEAD(workqueues);		/* PL: list of all workqueues */
+static LIST_HEAD(workqueues_unbound);	/* PU: list of unbound workqueues */
 static bool workqueue_freezing;		/* PL: have wqs started freezing? */
 
 /* the per-cpu worker pools */
@@ -4263,6 +4268,12 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 
 	mutex_unlock(&wq_pool_mutex);
 
+	if (wq->flags & WQ_UNBOUND) {
+		mutex_lock(&wq_unbound_mutex);
+		list_add(&wq->unbound_list, &workqueues_unbound);
+		mutex_unlock(&wq_unbound_mutex);
+	}
+
 	return wq;
 
 err_free_wq:
@@ -4318,6 +4329,12 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	list_del_init(&wq->list);
 	mutex_unlock(&wq_pool_mutex);
 
+	if (wq->flags & WQ_UNBOUND) {
+		mutex_lock(&wq_unbound_mutex);
+		list_del(&wq->unbound_list);
+		mutex_unlock(&wq_unbound_mutex);
+	}
+
 	workqueue_sysfs_unregister(wq);
 
 	if (wq->rescuer) {
-- 
1.8.3.1

