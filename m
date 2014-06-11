Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbaFKWwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 18:52:35 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:51082 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbaFKWwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 18:52:33 -0400
Date: Wed, 11 Jun 2014 15:52:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: chiluk@canonical.com, Rafael Tinoco <rafael.tinoco@canonical.com>,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        Christopher Arges <chris.j.arges@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: Re: Possible netns creation and execution performance/scalability
 regression since v3.8 due to rcu callbacks being offloaded to multiple cpus
Message-ID: <20140611225228.GO4581@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAJE_dJyfq5zWcs2y52siXRruCCA1Dk_=Ds=rZ8BrBZLa7FCbuQ@mail.gmail.com>
 <20140611133919.GZ4581@linux.vnet.ibm.com>
 <CAJE_dJwfaUkop=XZxD-BfDPwKDjnfF1bvmD6XWaqVA4Xt2E6bQ@mail.gmail.com>
 <539879B8.4010204@canonical.com>
 <20140611161857.GC4581@linux.vnet.ibm.com>
 <53989F7B.6000004@canonical.com>
 <874mzr41kf.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874mzr41kf.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061122-1344-0000-0000-000002281CC2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 01:46:08PM -0700, Eric W. Biederman wrote:
> Dave Chiluk <chiluk@canonical.com> writes:
> 
> > On 06/11/2014 11:18 AM, Paul E. McKenney wrote:
> >> On Wed, Jun 11, 2014 at 10:46:00AM -0500, David Chiluk wrote:
> >>> Now think about what happens when a gateway goes down, the namespaces
> >>> need to be migrated, or a new machine needs to be brought up to replace
> >>> it.  When we're talking about 3000 namespaces, the amount of time it
> >>> takes simply to recreate the namespaces becomes very significant.
> >>>
> >>> The script is a stripped down example of what exactly is being done on
> >>> the neutron gateway in order to create namespaces.
> >> 
> >> Are the namespaces torn down and recreated one at a time, or is there some
> >> syscall, ioctl(), or whatever that allows bulk tear down and recreating?
> >> 
> >> 							Thanx, Paul
> >
> > In the normal running case, the namespaces are created one at a time, as
> > new customers create a new set of VMs on the cloud.
> >
> > However, in the case of failover to a new neutron gateway the namespaces
> > are created all at once using the ip command (more or less serially).
> >
> > As far as I know there is no syscall or ioctl that allows bulk tear down
> > and recreation.  if such a beast exists that might be helpful.
> 
> Bulk teardown exists for network namespaces, and it happens
> automatically.  Bulk creation does not exist.  But then until now rcu
> was not know to even exist on the namespace creation path.
> 
> Which is what puzzles me.
> 
> Looking a little closer switch_task_namespaces which calls
> synchronize_rcu when the old nsproxy is dead may exists in both
> unshare/clone and in setns.  So that may be the culprit.
> 
> Certainly it is the only thing going on in the ip netns exec case.
> 
> ip netns add also performs a bind mount so we get into all of the vfs
> level locking as well.
> 
> On the chance it is dropping the old nsproxy which calls syncrhonize_rcu
> in switch_task_namespaces that is causing you problems I have attached
> a patch that changes from rcu_read_lock to task_lock for code that
> calls task_nsproxy from a different task.  The code should be safe
> and it should be an unquestions performance improvement but I have only
> compile tested it.
> 
> If you can try the patch it will tell is if the problem is the rcu
> access in switch_task_namespaces (the only one I am aware of network
> namespace creation) or if the problem rcu case is somewhere else.
> 
> If nothing else knowing which rcu accesses are causing the slow down
> seem important at the end of the day.
> 
> Eric
> 
> 
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> Date: Wed, 11 Jun 2014 13:33:47 -0700
> Subject: [PATCH] nsproxy: Protect remote reads of nsproxy with task_lock not rcu_read_lock.
> 
> Remote reads are rare and setns/clone can be slow because we are using
> syncrhonize_rcu.  Let's speed things up by using locking that does not
> optimize for a case that does not exist.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  fs/namespace.c           |  4 ++--
>  fs/proc/proc_net.c       |  2 ++
>  fs/proc_namespace.c      |  6 ++----
>  include/linux/nsproxy.h  |  6 +++---
>  ipc/namespace.c          |  4 ++--
>  kernel/nsproxy.c         | 12 +++---------
>  kernel/utsname.c         |  4 ++--
>  net/core/net_namespace.c |  6 ++++--
>  8 files changed, 20 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 182bc41cd887..2d52c1676bbb 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -2972,13 +2972,13 @@ static void *mntns_get(struct task_struct *task)
>  	struct mnt_namespace *ns = NULL;
>  	struct nsproxy *nsproxy;
> 
> -	rcu_read_lock();
> +	task_lock(task);
>  	nsproxy = task_nsproxy(task);
>  	if (nsproxy) {
>  		ns = nsproxy->mnt_ns;
>  		get_mnt_ns(ns);
>  	}
> -	rcu_read_unlock();
> +	task_unlock(task);
> 
>  	return ns;
>  }
> diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
> index 4677bb7dc7c2..a5e2d5576645 100644
> --- a/fs/proc/proc_net.c
> +++ b/fs/proc/proc_net.c
> @@ -113,9 +113,11 @@ static struct net *get_proc_task_net(struct inode *dir)
>  	rcu_read_lock();
>  	task = pid_task(proc_pid(dir), PIDTYPE_PID);
>  	if (task != NULL) {
> +		task_lock(task);
>  		ns = task_nsproxy(task);
>  		if (ns != NULL)
>  			net = get_net(ns->net_ns);
> +		task_unlock(task);
>  	}
>  	rcu_read_unlock();
> 
> diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
> index 1a81373947f3..2b0f6455af54 100644
> --- a/fs/proc_namespace.c
> +++ b/fs/proc_namespace.c
> @@ -232,17 +232,15 @@ static int mounts_open_common(struct inode *inode, struct file *file,
>  	if (!task)
>  		goto err;
> 
> -	rcu_read_lock();
> +	task_lock(task);
>  	nsp = task_nsproxy(task);
>  	if (!nsp || !nsp->mnt_ns) {
> -		rcu_read_unlock();
> +		task_unlock(task);
>  		put_task_struct(task);
>  		goto err;
>  	}
>  	ns = nsp->mnt_ns;
>  	get_mnt_ns(ns);
> -	rcu_read_unlock();
> -	task_lock(task);
>  	if (!task->fs) {
>  		task_unlock(task);
>  		put_task_struct(task);
> diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
> index b4ec59d159ac..229aeb8ade5b 100644
> --- a/include/linux/nsproxy.h
> +++ b/include/linux/nsproxy.h
> @@ -46,7 +46,7 @@ extern struct nsproxy init_nsproxy;
>   *     precautions should be taken - just dereference the pointers
>   *
>   *  3. the access to other task namespaces is performed like this
> - *     rcu_read_lock();
> + *     task_lock(tsk);
>   *     nsproxy = task_nsproxy(tsk);
>   *     if (nsproxy != NULL) {
>   *             / *
> @@ -57,13 +57,13 @@ extern struct nsproxy init_nsproxy;
>   *         * NULL task_nsproxy() means that this task is
>   *         * almost dead (zombie)
>   *         * /
> - *     rcu_read_unlock();
> + *     task_unlock(tsk);
>   *
>   */
> 
>  static inline struct nsproxy *task_nsproxy(struct task_struct *tsk)
>  {
> -	return rcu_dereference(tsk->nsproxy);
> +	return tsk->nsproxy;
>  }
> 
>  int copy_namespaces(unsigned long flags, struct task_struct *tsk);
> diff --git a/ipc/namespace.c b/ipc/namespace.c
> index 59451c1e214d..15b2ee95c3a9 100644
> --- a/ipc/namespace.c
> +++ b/ipc/namespace.c
> @@ -154,11 +154,11 @@ static void *ipcns_get(struct task_struct *task)
>  	struct ipc_namespace *ns = NULL;
>  	struct nsproxy *nsproxy;
> 
> -	rcu_read_lock();
> +	task_lock(task);
>  	nsproxy = task_nsproxy(task);
>  	if (nsproxy)
>  		ns = get_ipc_ns(nsproxy->ipc_ns);
> -	rcu_read_unlock();
> +	task_unlock(task);
> 
>  	return ns;
>  }
> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> index 8e7811086b82..20a9929ce342 100644
> --- a/kernel/nsproxy.c
> +++ b/kernel/nsproxy.c
> @@ -204,18 +204,12 @@ void switch_task_namespaces(struct task_struct *p, struct nsproxy *new)
> 
>  	might_sleep();
> 
> +	task_lock(p);
>  	ns = p->nsproxy;
> -
> -	rcu_assign_pointer(p->nsproxy, new);
> +	p->nsproxy = new;
> +	task_unlock(p);
> 
>  	if (ns && atomic_dec_and_test(&ns->count)) {
> -		/*
> -		 * wait for others to get what they want from this nsproxy.
> -		 *
> -		 * cannot release this nsproxy via the call_rcu() since
> -		 * put_mnt_ns() will want to sleep
> -		 */
> -		synchronize_rcu();
>  		free_nsproxy(ns);

If this is the culprit, another approach would be to use workqueues from
RCU callbacks.  The following (untested, probably does not even build)
patch illustrates one such approach.

							Thanx, Paul

------------------------------------------------------------------------

nsproxy: Substitute call_rcu/queue_work for synchronize_rcu

This commit gets synchronize_rcu() out of the way by getting the work
done in workqueue context from an RCU callback function.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index b4ec59d159ac..489bf4c7a3a0 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -33,6 +33,10 @@ struct nsproxy {
 	struct mnt_namespace *mnt_ns;
 	struct pid_namespace *pid_ns_for_children;
 	struct net 	     *net_ns;
+	union cu {
+		struct rcu_head      rh;
+		struct work_struct   ws;
+	};
 };
 extern struct nsproxy init_nsproxy;
 
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 8e7811086b82..d9a4730ce386 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -27,6 +27,7 @@
 #include <linux/syscalls.h>
 
 static struct kmem_cache *nsproxy_cachep;
+static struct workqueue_struct *nsproxy_wq;
 
 struct nsproxy init_nsproxy = {
 	.count			= ATOMIC_INIT(1),
@@ -198,6 +199,21 @@ out:
 	return err;
 }
 
+static void free_nsproxy_wq(struct work_struct *work)
+{
+	struct nsproxy *ns = container_of(rhp, struct nsproxy, cu.ws);
+
+	free_nsproxy(ns);
+}
+
+static void free_nsproxy_rcu(struct rcu_head *rhp)
+{
+	struct nsproxy *ns = container_of(rhp, struct nsproxy, cu.rh);
+
+	INIT_WORK(&ns->cu.ws, free_nsproxy_wq);
+	queue_work(nsproxy_wq, &ns->cu.ws);
+}
+
 void switch_task_namespaces(struct task_struct *p, struct nsproxy *new)
 {
 	struct nsproxy *ns;
@@ -210,13 +226,10 @@ void switch_task_namespaces(struct task_struct *p, struct nsproxy *new)
 
 	if (ns && atomic_dec_and_test(&ns->count)) {
 		/*
-		 * wait for others to get what they want from this nsproxy.
-		 *
-		 * cannot release this nsproxy via the call_rcu() since
-		 * put_mnt_ns() will want to sleep
+		 * Invoke free_nsproxy() (from workqueue context) to clean
+		 * up after others to get what they want from this nsproxy.
 		 */
-		synchronize_rcu();
-		free_nsproxy(ns);
+		call_rcu(&ns->rh, free_nsproxy_rcu);
 	}
 }
 
@@ -264,5 +277,6 @@ out:
 int __init nsproxy_cache_init(void)
 {
 	nsproxy_cachep = KMEM_CACHE(nsproxy, SLAB_PANIC);
+	nsproxy_wq = alloc_workqueue("nsproxy_wq", WQ_MEM_RECLAIM, 0);
 	return 0;
 }

