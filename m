Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab3KOHyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 02:54:19 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49898 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab3KOHyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 02:54:07 -0500
Date: Fri, 15 Nov 2013 16:54:01 +0900
From: Tejun Heo <tj@kernel.org>
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>, Li Zefan <lizefan@huawei.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Markus Blank-Burian <burian@muenster.de>
Subject: Re: 3.10.16 cgroup_mutex deadlock
Message-ID: <20131115075401.GB9755@mtj.dyndns.org>
References: <20131111220626.GA7509@sbohrermbp13-local.rgmadvisors.com>
 <52820030.6000806@huawei.com>
 <20131112143147.GB6049@dhcp22.suse.cz>
 <20131112155530.GA2860@sbohrermbp13-local.rgmadvisors.com>
 <20131112165504.GF6049@dhcp22.suse.cz>
 <20131114225649.GA16725@sbohrermbp13-local.rgmadvisors.com>
 <20131115062458.GA9755@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131115062458.GA9755@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Shawn, Hugh, can you please verify whether the attached patch makes
the deadlock go away?

Thanks.

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e0839bc..dc9dc06 100644
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
@@ -4254,7 +4262,7 @@ static void css_free_rcu_fn(struct rcu_head *rcu_head)
 	 * css_put().  dput() requires process context which we don't have.
 	 */
 	INIT_WORK(&css->destroy_work, css_free_work_fn);
-	schedule_work(&css->destroy_work);
+	queue_work(cgroup_destroy_wq, &css->destroy_work);
 }
 
 static void css_release(struct percpu_ref *ref)
@@ -4544,7 +4552,7 @@ static void css_killed_ref_fn(struct percpu_ref *ref)
 		container_of(ref, struct cgroup_subsys_state, refcnt);
 
 	INIT_WORK(&css->destroy_work, css_killed_work_fn);
-	schedule_work(&css->destroy_work);
+	queue_work(cgroup_destroy_wq, &css->destroy_work);
 }
 
 /**
@@ -5025,6 +5033,17 @@ int __init cgroup_init(void)
 	if (err)
 		return err;
 
+	/*
+	 * There isn't much point in executing destruction path in
+	 * parallel.  Good chunk is serialized with cgroup_mutex anyway.
+	 * Use 1 for @max_active.
+	 */
+	cgroup_destroy_wq = alloc_workqueue("cgroup_destroy", 0, 1);
+	if (!cgroup_destroy_wq) {
+		err = -ENOMEM;
+		goto out;
+	}
+
 	for_each_builtin_subsys(ss, i) {
 		if (!ss->early_init)
 			cgroup_init_subsys(ss);
@@ -5062,9 +5081,11 @@ int __init cgroup_init(void)
 	proc_create("cgroups", 0, NULL, &proc_cgroupstats_operations);
 
 out:
-	if (err)
+	if (err) {
+		if (cgroup_destroy_wq)
+			destroy_workqueue(cgroup_destroy_wq);
 		bdi_destroy(&cgroup_backing_dev_info);
-
+	}
 	return err;
 }
 
