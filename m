Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab3KRUKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 15:10:43 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:42006 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab3KRUKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 15:10:39 -0500
Date: Mon, 18 Nov 2013 14:10:25 -0600
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Markus Blank-Burian <burian@muenster.de>
Subject: Re: 3.10.16 cgroup_mutex deadlock
Message-ID: <20131118201025.GA2747@sbohrermbp13-local.rgmadvisors.com>
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

On Sun, Nov 17, 2013 at 06:17:17PM -0800, Hugh Dickins wrote:
> Sorry for the delay: I was on the point of reporting success last
> night, when I tried a debug kernel: and that didn't work so well
> (got spinlock bad magic report in pwd_adjust_max_active(), and
> tests wouldn't run at all).
> 
> Even the non-early cgroup_init() is called well before the
> early_initcall init_workqueues(): though only the debug (lockdep
> and spinlock debug) kernel appeared to have a problem with that.
> 
> Here's the patch I ended up with successfully on a 3.11.7-based
> kernel (though below I've rediffed it against 3.11.8): the
> schedule_work->queue_work hunks are slightly different on 3.11
> than in your patch against current, and I did alloc_workqueue()
> from a separate core_initcall.
> 
> The interval between cgroup_init and that is a bit of a worry;
> but we don't seem to have suffered from the interval between
> cgroup_init and init_workqueues before (when system_wq is NULL)
> - though you may have more courage than I to reorder them!
> 
> Initially I backed out my system_highpri_wq workaround, and
> verified that it was still easy to reproduce the problem with
> one of our cgroup stresstests.  Yes it was, then your modified
> patch below convincingly fixed it.
> 
> I ran with Johannes's patch adding extra mem_cgroup_reparent_charges:
> as I'd expected, that didn't solve this issue (though it's worth
> our keeping it in to rule out another source of problems).  And I
> checked back on dumps of failures: they indeed show the tell-tale
> 256 kworkers doing cgroup_offline_fn, just as you predicted.
> 
> Thanks!
> Hugh
> 
> ---
>  kernel/cgroup.c | 30 +++++++++++++++++++++++++++---
>  1 file changed, 27 insertions(+), 3 deletions(-)
> 
> --- 3.11.8/kernel/cgroup.c	2013-11-17 17:40:54.200640692 -0800
> +++ linux/kernel/cgroup.c	2013-11-17 17:43:10.876643941 -0800
> @@ -89,6 +89,14 @@ static DEFINE_MUTEX(cgroup_mutex);
>  static DEFINE_MUTEX(cgroup_root_mutex);
>  
>  /*
> + * cgroup destruction makes heavy use of work items and there can be a lot
> + * of concurrent destructions.  Use a separate workqueue so that cgroup
> + * destruction work items don't end up filling up max_active of system_wq
> + * which may lead to deadlock.
> + */
> +static struct workqueue_struct *cgroup_destroy_wq;
> +
> +/*
>   * Generate an array of cgroup subsystem pointers. At boot time, this is
>   * populated with the built in subsystems, and modular subsystems are
>   * registered after that. The mutable section of this array is protected by
> @@ -890,7 +898,7 @@ static void cgroup_free_rcu(struct rcu_h
>  	struct cgroup *cgrp = container_of(head, struct cgroup, rcu_head);
>  
>  	INIT_WORK(&cgrp->destroy_work, cgroup_free_fn);
> -	schedule_work(&cgrp->destroy_work);
> +	queue_work(cgroup_destroy_wq, &cgrp->destroy_work);
>  }
>  
>  static void cgroup_diput(struct dentry *dentry, struct inode *inode)
> @@ -4205,7 +4213,7 @@ static void css_release(struct percpu_re
>  	struct cgroup_subsys_state *css =
>  		container_of(ref, struct cgroup_subsys_state, refcnt);
>  
> -	schedule_work(&css->dput_work);
> +	queue_work(cgroup_destroy_wq, &css->dput_work);
>  }
>  
>  static void init_cgroup_css(struct cgroup_subsys_state *css,
> @@ -4439,7 +4447,7 @@ static void cgroup_css_killed(struct cgr
>  
>  	/* percpu ref's of all css's are killed, kick off the next step */
>  	INIT_WORK(&cgrp->destroy_work, cgroup_offline_fn);
> -	schedule_work(&cgrp->destroy_work);
> +	queue_work(cgroup_destroy_wq, &cgrp->destroy_work);
>  }
>  
>  static void css_ref_killed_fn(struct percpu_ref *ref)
> @@ -4967,6 +4975,22 @@ out:
>  	return err;
>  }
>  
> +static int __init cgroup_destroy_wq_init(void)
> +{
> +	/*
> +	 * There isn't much point in executing destruction path in
> +	 * parallel.  Good chunk is serialized with cgroup_mutex anyway.
> +	 * Use 1 for @max_active.
> +	 *
> +	 * We would prefer to do this in cgroup_init() above, but that
> +	 * is called before init_workqueues(): so leave this until after.
> +	 */
> +	cgroup_destroy_wq = alloc_workqueue("cgroup_destroy", 0, 1);
> +	BUG_ON(!cgroup_destroy_wq);
> +	return 0;
> +}
> +core_initcall(cgroup_destroy_wq_init);
> +
>  /*
>   * proc_cgroup_show()
>   *  - Print task's cgroup paths into seq_file, one line for each hierarchy

Thanks Tejun and Hugh.  Sorry for my late entry in getting around to
testing this fix. On the surface it sounds correct however I'd like to
test this on top of 3.10.* since that is what we'll likely be running.
I've tried to apply Hugh's patch above on top of 3.10.19 but it
appears there are a number of conflicts.  Looking over the changes and
my understanding of the problem I believe on 3.10 only the
cgroup_free_fn needs to be run in a separate workqueue.  Below is the
patch I've applied on top of 3.10.19, which I'm about to start
testing.  If it looks like I botched the backport in any way please
let me know so I can test a propper fix on top of 3.10.19.


---
 kernel/cgroup.c |   28 ++++++++++++++++++++++++++--
 1 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b6b26fa..113a522 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -92,6 +92,14 @@ static DEFINE_MUTEX(cgroup_mutex);
 static DEFINE_MUTEX(cgroup_root_mutex);
 
 /*
+* cgroup destruction makes heavy use of work items and there can be a lot
+* of concurrent destructions.  Use a separate workqueue so that cgroup
+* destruction work items don't end up filling up max_active of system_wq
+* which may lead to deadlock.
+*/
+static struct workqueue_struct *cgroup_destroy_wq;
+
+/*
  * Generate an array of cgroup subsystem pointers. At boot time, this is
  * populated with the built in subsystems, and modular subsystems are
  * registered after that. The mutable section of this array is protected by
@@ -873,7 +881,8 @@ static void cgroup_free_rcu(struct rcu_head *head)
 {
 	struct cgroup *cgrp = container_of(head, struct cgroup, rcu_head);
 
-	schedule_work(&cgrp->free_work);
+	INIT_WORK(&cgrp->free_work, cgroup_free_fn);
+	queue_work(cgroup_destroy_wq, &cgrp->free_work);
 }
 
 static void cgroup_diput(struct dentry *dentry, struct inode *inode)
@@ -1405,7 +1414,6 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 	INIT_LIST_HEAD(&cgrp->allcg_node);
 	INIT_LIST_HEAD(&cgrp->release_list);
 	INIT_LIST_HEAD(&cgrp->pidlists);
-	INIT_WORK(&cgrp->free_work, cgroup_free_fn);
 	mutex_init(&cgrp->pidlist_mutex);
 	INIT_LIST_HEAD(&cgrp->event_list);
 	spin_lock_init(&cgrp->event_list_lock);
@@ -4686,6 +4694,22 @@ out:
 	return err;
 }
 
+static int __init cgroup_destroy_wq_init(void)
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
+core_initcall(cgroup_destroy_wq_init);
+
 /*
  * proc_cgroup_show()
  *  - Print task's cgroup paths into seq_file, one line for each hierarchy
-- 
1.7.7.6

