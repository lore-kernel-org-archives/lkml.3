Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbaFKUrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 16:47:21 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45581 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbaFKUrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 16:47:18 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: chiluk@canonical.com
Cc: paulmck@linux.vnet.ibm.com, Rafael Tinoco <rafael.tinoco@canonical.com>,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        Christopher Arges <chris.j.arges@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
References: <CAJE_dJyfq5zWcs2y52siXRruCCA1Dk_=Ds=rZ8BrBZLa7FCbuQ@mail.gmail.com>
	<20140611133919.GZ4581@linux.vnet.ibm.com>
	<CAJE_dJwfaUkop=XZxD-BfDPwKDjnfF1bvmD6XWaqVA4Xt2E6bQ@mail.gmail.com>
	<539879B8.4010204@canonical.com>
	<20140611161857.GC4581@linux.vnet.ibm.com>
	<53989F7B.6000004@canonical.com>
Date: Wed, 11 Jun 2014 13:46:08 -0700
In-Reply-To: <53989F7B.6000004@canonical.com> (Dave Chiluk's message of "Wed,
	11 Jun 2014 13:27:07 -0500")
Message-ID: <874mzr41kf.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+B29/Ns7Svtq3Y/56bCm+R4A4j50Pq6OQ=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4644]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;chiluk@canonical.com
X-Spam-Relay-Country: 
Subject: Re: Possible netns creation and execution performance/scalability regression since v3.8 due to rcu callbacks being offloaded to multiple cpus
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chiluk <chiluk@canonical.com> writes:

> On 06/11/2014 11:18 AM, Paul E. McKenney wrote:
>> On Wed, Jun 11, 2014 at 10:46:00AM -0500, David Chiluk wrote:
>>> Now think about what happens when a gateway goes down, the namespaces
>>> need to be migrated, or a new machine needs to be brought up to replace
>>> it.  When we're talking about 3000 namespaces, the amount of time it
>>> takes simply to recreate the namespaces becomes very significant.
>>>
>>> The script is a stripped down example of what exactly is being done on
>>> the neutron gateway in order to create namespaces.
>> 
>> Are the namespaces torn down and recreated one at a time, or is there some
>> syscall, ioctl(), or whatever that allows bulk tear down and recreating?
>> 
>> 							Thanx, Paul
>
> In the normal running case, the namespaces are created one at a time, as
> new customers create a new set of VMs on the cloud.
>
> However, in the case of failover to a new neutron gateway the namespaces
> are created all at once using the ip command (more or less serially).
>
> As far as I know there is no syscall or ioctl that allows bulk tear down
> and recreation.  if such a beast exists that might be helpful.

Bulk teardown exists for network namespaces, and it happens
automatically.  Bulk creation does not exist.  But then until now rcu
was not know to even exist on the namespace creation path.

Which is what puzzles me.

Looking a little closer switch_task_namespaces which calls
synchronize_rcu when the old nsproxy is dead may exists in both
unshare/clone and in setns.  So that may be the culprit.

Certainly it is the only thing going on in the ip netns exec case.

ip netns add also performs a bind mount so we get into all of the vfs
level locking as well.

On the chance it is dropping the old nsproxy which calls syncrhonize_rcu
in switch_task_namespaces that is causing you problems I have attached
a patch that changes from rcu_read_lock to task_lock for code that
calls task_nsproxy from a different task.  The code should be safe
and it should be an unquestions performance improvement but I have only
compile tested it.

If you can try the patch it will tell is if the problem is the rcu
access in switch_task_namespaces (the only one I am aware of network
namespace creation) or if the problem rcu case is somewhere else.

If nothing else knowing which rcu accesses are causing the slow down
seem important at the end of the day.

Eric


From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 11 Jun 2014 13:33:47 -0700
Subject: [PATCH] nsproxy: Protect remote reads of nsproxy with task_lock not rcu_read_lock.

Remote reads are rare and setns/clone can be slow because we are using
syncrhonize_rcu.  Let's speed things up by using locking that does not
optimize for a case that does not exist.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/namespace.c           |  4 ++--
 fs/proc/proc_net.c       |  2 ++
 fs/proc_namespace.c      |  6 ++----
 include/linux/nsproxy.h  |  6 +++---
 ipc/namespace.c          |  4 ++--
 kernel/nsproxy.c         | 12 +++---------
 kernel/utsname.c         |  4 ++--
 net/core/net_namespace.c |  6 ++++--
 8 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 182bc41cd887..2d52c1676bbb 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2972,13 +2972,13 @@ static void *mntns_get(struct task_struct *task)
 	struct mnt_namespace *ns = NULL;
 	struct nsproxy *nsproxy;
 
-	rcu_read_lock();
+	task_lock(task);
 	nsproxy = task_nsproxy(task);
 	if (nsproxy) {
 		ns = nsproxy->mnt_ns;
 		get_mnt_ns(ns);
 	}
-	rcu_read_unlock();
+	task_unlock(task);
 
 	return ns;
 }
diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index 4677bb7dc7c2..a5e2d5576645 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -113,9 +113,11 @@ static struct net *get_proc_task_net(struct inode *dir)
 	rcu_read_lock();
 	task = pid_task(proc_pid(dir), PIDTYPE_PID);
 	if (task != NULL) {
+		task_lock(task);
 		ns = task_nsproxy(task);
 		if (ns != NULL)
 			net = get_net(ns->net_ns);
+		task_unlock(task);
 	}
 	rcu_read_unlock();
 
diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
index 1a81373947f3..2b0f6455af54 100644
--- a/fs/proc_namespace.c
+++ b/fs/proc_namespace.c
@@ -232,17 +232,15 @@ static int mounts_open_common(struct inode *inode, struct file *file,
 	if (!task)
 		goto err;
 
-	rcu_read_lock();
+	task_lock(task);
 	nsp = task_nsproxy(task);
 	if (!nsp || !nsp->mnt_ns) {
-		rcu_read_unlock();
+		task_unlock(task);
 		put_task_struct(task);
 		goto err;
 	}
 	ns = nsp->mnt_ns;
 	get_mnt_ns(ns);
-	rcu_read_unlock();
-	task_lock(task);
 	if (!task->fs) {
 		task_unlock(task);
 		put_task_struct(task);
diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index b4ec59d159ac..229aeb8ade5b 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -46,7 +46,7 @@ extern struct nsproxy init_nsproxy;
  *     precautions should be taken - just dereference the pointers
  *
  *  3. the access to other task namespaces is performed like this
- *     rcu_read_lock();
+ *     task_lock(tsk);
  *     nsproxy = task_nsproxy(tsk);
  *     if (nsproxy != NULL) {
  *             / *
@@ -57,13 +57,13 @@ extern struct nsproxy init_nsproxy;
  *         * NULL task_nsproxy() means that this task is
  *         * almost dead (zombie)
  *         * /
- *     rcu_read_unlock();
+ *     task_unlock(tsk);
  *
  */
 
 static inline struct nsproxy *task_nsproxy(struct task_struct *tsk)
 {
-	return rcu_dereference(tsk->nsproxy);
+	return tsk->nsproxy;
 }
 
 int copy_namespaces(unsigned long flags, struct task_struct *tsk);
diff --git a/ipc/namespace.c b/ipc/namespace.c
index 59451c1e214d..15b2ee95c3a9 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -154,11 +154,11 @@ static void *ipcns_get(struct task_struct *task)
 	struct ipc_namespace *ns = NULL;
 	struct nsproxy *nsproxy;
 
-	rcu_read_lock();
+	task_lock(task);
 	nsproxy = task_nsproxy(task);
 	if (nsproxy)
 		ns = get_ipc_ns(nsproxy->ipc_ns);
-	rcu_read_unlock();
+	task_unlock(task);
 
 	return ns;
 }
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 8e7811086b82..20a9929ce342 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -204,18 +204,12 @@ void switch_task_namespaces(struct task_struct *p, struct nsproxy *new)
 
 	might_sleep();
 
+	task_lock(p);
 	ns = p->nsproxy;
-
-	rcu_assign_pointer(p->nsproxy, new);
+	p->nsproxy = new;
+	task_unlock(p);
 
 	if (ns && atomic_dec_and_test(&ns->count)) {
-		/*
-		 * wait for others to get what they want from this nsproxy.
-		 *
-		 * cannot release this nsproxy via the call_rcu() since
-		 * put_mnt_ns() will want to sleep
-		 */
-		synchronize_rcu();
 		free_nsproxy(ns);
 	}
 }
diff --git a/kernel/utsname.c b/kernel/utsname.c
index fd393124e507..359b1f12e90f 100644
--- a/kernel/utsname.c
+++ b/kernel/utsname.c
@@ -93,13 +93,13 @@ static void *utsns_get(struct task_struct *task)
 	struct uts_namespace *ns = NULL;
 	struct nsproxy *nsproxy;
 
-	rcu_read_lock();
+	task_lock(task);
 	nsproxy = task_nsproxy(task);
 	if (nsproxy) {
 		ns = nsproxy->uts_ns;
 		get_uts_ns(ns);
 	}
-	rcu_read_unlock();
+	task_unlock(task);
 
 	return ns;
 }
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 85b62691f4f2..4196f2a46fa8 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -373,9 +373,11 @@ struct net *get_net_ns_by_pid(pid_t pid)
 	tsk = find_task_by_vpid(pid);
 	if (tsk) {
 		struct nsproxy *nsproxy;
+		task_lock(tsk);
 		nsproxy = task_nsproxy(tsk);
 		if (nsproxy)
 			net = get_net(nsproxy->net_ns);
+		task_unlock(tsk);
 	}
 	rcu_read_unlock();
 	return net;
@@ -632,11 +634,11 @@ static void *netns_get(struct task_struct *task)
 	struct net *net = NULL;
 	struct nsproxy *nsproxy;
 
-	rcu_read_lock();
+	task_lock(task);
 	nsproxy = task_nsproxy(task);
 	if (nsproxy)
 		net = get_net(nsproxy->net_ns);
-	rcu_read_unlock();
+	task_unlock(task);
 
 	return net;
 }
-- 
1.9.1

