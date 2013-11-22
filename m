Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab3KVWSB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 17:18:01 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:61328 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab3KVWR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 17:17:59 -0500
Date: Fri, 22 Nov 2013 17:17:52 -0500
From: Tejun Heo <tj@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Markus Blank-Burian <burian@muenster.de>
Subject: [PATCH cgroup/for-3.13-fixes] cgroup: use a dedicated workqueue for
 cgroup destruction
Message-ID: <20131122221752.GC8981@mtj.dyndns.org>
References: <20131111220626.GA7509@sbohrermbp13-local.rgmadvisors.com>
 <52820030.6000806@huawei.com>
 <20131112143147.GB6049@dhcp22.suse.cz>
 <20131112155530.GA2860@sbohrermbp13-local.rgmadvisors.com>
 <20131112165504.GF6049@dhcp22.suse.cz>
 <20131114225649.GA16725@sbohrermbp13-local.rgmadvisors.com>
 <20131115062458.GA9755@mtj.dyndns.org>
 <20131115075401.GB9755@mtj.dyndns.org>
 <alpine.LNX.2.00.1311171746160.15789@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1311171746160.15789@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Hugh.

I applied the following patch to cgroup/for-3.13-fixes.  For longer
term, I think it'd be better to pull workqueue init before cgroup one
but this one should be easier to backport for now.

Thanks!

----- >8 -----
>From e5fca243abae1445afbfceebda5f08462ef869d3 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Fri, 22 Nov 2013 17:14:39 -0500

Since be44562613851 ("cgroup: remove synchronize_rcu() from
cgroup_diput()"), cgroup destruction path makes use of workqueue.  css
freeing is performed from a work item from that point on and a later
commit, ea15f8ccdb430 ("cgroup: split cgroup destruction into two
steps"), moves css offlining to workqueue too.

As cgroup destruction isn't depended upon for memory reclaim, the
destruction work items were put on the system_wq; unfortunately, some
controller may block in the destruction path for considerable duration
while holding cgroup_mutex.  As large part of destruction path is
synchronized through cgroup_mutex, when combined with high rate of
cgroup removals, this has potential to fill up system_wq's max_active
of 256.

Also, it turns out that memcg's css destruction path ends up queueing
and waiting for work items on system_wq through work_on_cpu().  If
such operation happens while system_wq is fully occupied by cgroup
destruction work items, work_on_cpu() can't make forward progress
because system_wq is full and other destruction work items on
system_wq can't make forward progress because the work item waiting
for work_on_cpu() is holding cgroup_mutex, leading to deadlock.

This can be fixed by queueing destruction work items on a separate
workqueue.  This patch creates a dedicated workqueue -
cgroup_destroy_wq - for this purpose.  As these work items shouldn't
have inter-dependencies and mostly serialized by cgroup_mutex anyway,
giving high concurrency level doesn't buy anything and the workqueue's
@max_active is set to 1 so that destruction work items are executed
one by one on each CPU.

Hugh Dickins: Because cgroup_init() is run before init_workqueues(),
cgroup_destroy_wq can't be allocated from cgroup_init().  Do it from a
separate core_initcall().  In the future, we probably want to reorder
so that workqueue init happens before cgroup_init().

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Hugh Dickins <hughd@google.com>
Reported-by: Shawn Bohrer <shawn.bohrer@gmail.com>
Link: http://lkml.kernel.org/r/20131111220626.GA7509@sbohrermbp13-local.rgmadvisors.com
Link: http://lkml.kernel.org/g/alpine.LNX.2.00.1310301606080.2333@eggly.anvils
Cc: stable@vger.kernel.org # v3.9+
---
 kernel/cgroup.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4c62513..a7b98ee 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -90,6 +90,14 @@ static DEFINE_MUTEX(cgroup_mutex);
 static DEFINE_MUTEX(cgroup_root_mutex);
 
 /*
+ * cgroup destruction makes heavy use of work items and there can be a lot
+ * of concurrent destructions.  Use a separate workqueue so that cgroup
+ * destruction work items don't end up filling up max_active of system_wq
+ * which may lead to deadlock.
+ */
+static struct workqueue_struct *cgroup_destroy_wq;
+
+/*
  * Generate an array of cgroup subsystem pointers. At boot time, this is
  * populated with the built in subsystems, and modular subsystems are
  * registered after that. The mutable section of this array is protected by
@@ -871,7 +879,7 @@ static void cgroup_free_rcu(struct rcu_head *head)
 	struct cgroup *cgrp = container_of(head, struct cgroup, rcu_head);
 
 	INIT_WORK(&cgrp->destroy_work, cgroup_free_fn);
-	schedule_work(&cgrp->destroy_work);
+	queue_work(cgroup_destroy_wq, &cgrp->destroy_work);
 }
 
 static void cgroup_diput(struct dentry *dentry, struct inode *inode)
@@ -4249,7 +4257,7 @@ static void css_free_rcu_fn(struct rcu_head *rcu_head)
 	 * css_put().  dput() requires process context which we don't have.
 	 */
 	INIT_WORK(&css->destroy_work, css_free_work_fn);
-	schedule_work(&css->destroy_work);
+	queue_work(cgroup_destroy_wq, &css->destroy_work);
 }
 
 static void css_release(struct percpu_ref *ref)
@@ -4539,7 +4547,7 @@ static void css_killed_ref_fn(struct percpu_ref *ref)
 		container_of(ref, struct cgroup_subsys_state, refcnt);
 
 	INIT_WORK(&css->destroy_work, css_killed_work_fn);
-	schedule_work(&css->destroy_work);
+	queue_work(cgroup_destroy_wq, &css->destroy_work);
 }
 
 /**
@@ -5063,6 +5071,22 @@ out:
 	return err;
 }
 
+static int __init cgroup_wq_init(void)
+{
+	/*
+	 * There isn't much point in executing destruction path in
+	 * parallel.  Good chunk is serialized with cgroup_mutex anyway.
+	 * Use 1 for @max_active.
+	 *
+	 * We would prefer to do this in cgroup_init() above, but that
+	 * is called before init_workqueues(): so leave this until after.
+	 */
+	cgroup_destroy_wq = alloc_workqueue("cgroup_destroy", 0, 1);
+	BUG_ON(!cgroup_destroy_wq);
+	return 0;
+}
+core_initcall(cgroup_wq_init);
+
 /*
  * proc_cgroup_show()
  *  - Print task's cgroup paths into seq_file, one line for each hierarchy
-- 
1.8.4.2

