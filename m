Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab3JROrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:47:01 -0400
Received: from 33.106-14-84.ripe.coltfrance.com ([84.14.106.33]:46991 "EHLO
	proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3JROq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:46:59 -0400
From: "Guillaume Gaudonville" <gaudonville@6wind.com>
To: ebiederm@xmission.com
Cc: linux-kernel@vger.kernel.org, serge.hallyn@canonical.com,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        davem@davemloft.net, cmetcalf@tilera.com,
        Guillaume Gaudonville <guillaume.gaudonville@6wind.com>
Subject: [RFC PATCH linux-next v2] ns: do not allocate a new nsproxy at each call
Date: Fri, 18 Oct 2013 16:46:39 +0200
Message-Id: <1382107599-1028-1-git-send-email-guillaume.gaudonville@6wind.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <8738o1ovdi.fsf@xmission.com>
References: <8738o1ovdi.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, at each call of setns system call a new nsproxy is allocated,
the old nsproxy namespaces are copied into the new one and the old nsproxy
is freed if the task was the only one to use it.

It can creates large delays on hardware with large number of cpus since
to free a nsproxy a synchronize_rcu() call is done.

When a task is the only one to use a nsproxy, only the task can do an action
that will make this nsproxy to be shared by another task or thread (fork,...).
So when the refcount of the nsproxy is equal to 1, we can simply update the
current nsproxy field without allocating a new one and freeing the old one.

The install operations of each kind of namespace cannot fails, so there's no
need to check for an error and calling ops->install().

However since we can have readers of the nsproxy that are not the current task,
we need to protect access to each namespace pointer in the nsproxy. This is
done by assigning it using rcu_assign_pointer() and when it is possible
that the reader is not the current task, read the pointer using
rcu_dereference().

Finally the install function of each namespace type must be modified to ensure
that the refcount of the old namespace is released after the assignment in
nsproxy.

On kernel 3.12-rc1, using a small application that does:

- call setns on a first net namespace and open a socket,
- call setns on a second net namespace and open a socket,
- switch back to the first namespace and close the socket,
- switch back to the second namespace and close the socket,

On an Intel Westmere with 24 logical cores at 3.33 GHz, it gives the
following results using the time command:

- without the proposed patch:

  root@blackcloudy:~# time ./test_x86

  real    0m0.130s
  user    0m0.000s
  sys     0m0.000s

- with the proposed patch:

  root@blackcloudy:~# time ./test_x86

  real    0m0.020s
  user    0m0.000s
  sys     0m0.000s

Reported-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Guillaume Gaudonville <guillaume.gaudonville@6wind.com>
---

v2:
  - protect readers, by releasing namespaces refcount after updating the
    nsproxy pointer,
  - protect readers, by using rcu_assign_pointer() to affect nsproxy
    pointers,
  - readers need to use rcu_dereference() to access the namespace and
    must take a reference on it before leaving the rcu_read_lock section
    (this last part was already present),
  - do not add additional exit point in setns syscall.

There are still 2 suspicious functions, nfs_server_list_open() and
nfs_volume_list_open(). They are accessing directly to the net_ns
like below:

struct net *net = pid_ns->child_reaper->nsproxy->net_ns;

It seems to me that currently they should access it under rcu_read_lock()
and using task_nsproxy(pid_ns->child_reaper). It looks like a bug, no?

And then with this proposed patch they should access the netns through
a rcu_dereference and take a reference on the netns. I didn't
modify them for now, but if it is confirmed I can send a patch
fixing the first issue and then send a v3 of this proposed patch.

 fs/namespace.c           |    9 +++++----
 fs/proc/proc_net.c       |    2 +-
 fs/proc_namespace.c      |    2 +-
 ipc/namespace.c          |    9 +++++----
 kernel/nsproxy.c         |   11 +++++++++++
 kernel/pid_namespace.c   |    7 ++++---
 kernel/utsname.c         |    9 +++++----
 net/core/net_namespace.c |   11 ++++++-----
 8 files changed, 38 insertions(+), 22 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index a36e806..1890a87 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2840,7 +2840,7 @@ static void *mntns_get(struct task_struct *task)
 	rcu_read_lock();
 	nsproxy = task_nsproxy(task);
 	if (nsproxy) {
-		ns = nsproxy->mnt_ns;
+		ns = rcu_dereference(nsproxy->mnt_ns);
 		get_mnt_ns(ns);
 	}
 	rcu_read_unlock();
@@ -2856,7 +2856,7 @@ static void mntns_put(void *ns)
 static int mntns_install(struct nsproxy *nsproxy, void *ns)
 {
 	struct fs_struct *fs = current->fs;
-	struct mnt_namespace *mnt_ns = ns;
+	struct mnt_namespace *old_mnt_ns, *mnt_ns = ns;
 	struct path root;
 
 	if (!ns_capable(mnt_ns->user_ns, CAP_SYS_ADMIN) ||
@@ -2868,8 +2868,9 @@ static int mntns_install(struct nsproxy *nsproxy, void *ns)
 		return -EINVAL;
 
 	get_mnt_ns(mnt_ns);
-	put_mnt_ns(nsproxy->mnt_ns);
-	nsproxy->mnt_ns = mnt_ns;
+	old_mnt_ns = nsproxy->mnt_ns;
+	rcu_assign_pointer(nsproxy->mnt_ns, mnt_ns);
+	put_mnt_ns(old_mnt_ns);
 
 	/* Find the root */
 	root.mnt    = &mnt_ns->root->mnt;
diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
index b4ac657..39b93a5 100644
--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -111,7 +111,7 @@ static struct net *get_proc_task_net(struct inode *dir)
 	if (task != NULL) {
 		ns = task_nsproxy(task);
 		if (ns != NULL)
-			net = get_net(ns->net_ns);
+			net = get_net(rcu_dereference(ns->net_ns));
 	}
 	rcu_read_unlock();
 
diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
index 5fe34c3..3a507e7 100644
--- a/fs/proc_namespace.c
+++ b/fs/proc_namespace.c
@@ -239,7 +239,7 @@ static int mounts_open_common(struct inode *inode, struct file *file,
 		put_task_struct(task);
 		goto err;
 	}
-	ns = nsp->mnt_ns;
+	ns = rcu_dereference(nsp->mnt_ns);
 	if (!ns) {
 		rcu_read_unlock();
 		put_task_struct(task);
diff --git a/ipc/namespace.c b/ipc/namespace.c
index 7c1fa45..94f5fd3 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -156,7 +156,7 @@ static void *ipcns_get(struct task_struct *task)
 	rcu_read_lock();
 	nsproxy = task_nsproxy(task);
 	if (nsproxy)
-		ns = get_ipc_ns(nsproxy->ipc_ns);
+		ns = get_ipc_ns(rcu_dereference(nsproxy->ipc_ns));
 	rcu_read_unlock();
 
 	return ns;
@@ -169,15 +169,16 @@ static void ipcns_put(void *ns)
 
 static int ipcns_install(struct nsproxy *nsproxy, void *new)
 {
-	struct ipc_namespace *ns = new;
+	struct ipc_namespace *old_ns, *ns = new;
 	if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN) ||
 	    !nsown_capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
 	/* Ditch state from the old ipc namespace */
 	exit_sem(current);
-	put_ipc_ns(nsproxy->ipc_ns);
-	nsproxy->ipc_ns = get_ipc_ns(ns);
+	old_ns = nsproxy->ipc_ns;
+	rcu_assign_pointer(nsproxy->ipc_ns, get_ipc_ns(ns));
+	put_ipc_ns(old_ns);
 	return 0;
 }
 
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index afc0456..4ad9f9f 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -255,6 +255,17 @@ SYSCALL_DEFINE2(setns, int, fd, int, nstype)
 	if (nstype && (ops->type != nstype))
 		goto out;
 
+	/*
+	 * If count == 1, only the current task can increment it,
+	 * by doing a fork for example so we can safely update the
+	 * current nsproxy pointers without allocate a new one,
+	 * update it and destroy the old one
+	 */
+	if (atomic_read(&tsk->nsproxy->count) == 1) {
+		err = ops->install(tsk->nsproxy, ei->ns);
+		goto out;
+	}
+
 	new_nsproxy = create_new_namespaces(0, tsk, current_user_ns(), tsk->fs);
 	if (IS_ERR(new_nsproxy)) {
 		err = PTR_ERR(new_nsproxy);
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 69473c4..ac10df4 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -326,7 +326,7 @@ static void pidns_put(void *ns)
 static int pidns_install(struct nsproxy *nsproxy, void *ns)
 {
 	struct pid_namespace *active = task_active_pid_ns(current);
-	struct pid_namespace *ancestor, *new = ns;
+	struct pid_namespace *old, *ancestor, *new = ns;
 
 	if (!ns_capable(new->user_ns, CAP_SYS_ADMIN) ||
 	    !nsown_capable(CAP_SYS_ADMIN))
@@ -349,8 +349,9 @@ static int pidns_install(struct nsproxy *nsproxy, void *ns)
 	if (ancestor != active)
 		return -EINVAL;
 
-	put_pid_ns(nsproxy->pid_ns);
-	nsproxy->pid_ns = get_pid_ns(new);
+	old = nsproxy->pid_ns;
+	rcu_assign_pointer(nsproxy->pid_ns, get_pid_ns(new));
+	put_pid_ns(old);
 	return 0;
 }
 
diff --git a/kernel/utsname.c b/kernel/utsname.c
index a47fc5d..ba6581b 100644
--- a/kernel/utsname.c
+++ b/kernel/utsname.c
@@ -96,7 +96,7 @@ static void *utsns_get(struct task_struct *task)
 	rcu_read_lock();
 	nsproxy = task_nsproxy(task);
 	if (nsproxy) {
-		ns = nsproxy->uts_ns;
+		ns = rcu_dereference(nsproxy->uts_ns);
 		get_uts_ns(ns);
 	}
 	rcu_read_unlock();
@@ -111,15 +111,16 @@ static void utsns_put(void *ns)
 
 static int utsns_install(struct nsproxy *nsproxy, void *new)
 {
-	struct uts_namespace *ns = new;
+	struct uts_namespace *old_ns, *ns = new;
 
 	if (!ns_capable(ns->user_ns, CAP_SYS_ADMIN) ||
 	    !nsown_capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
 	get_uts_ns(ns);
-	put_uts_ns(nsproxy->uts_ns);
-	nsproxy->uts_ns = ns;
+	old_ns = nsproxy->uts_ns;
+	rcu_assign_pointer(nsproxy->uts_ns, ns);
+	put_uts_ns(old_ns);
 	return 0;
 }
 
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 80e271d..966d435 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -374,7 +374,7 @@ struct net *get_net_ns_by_pid(pid_t pid)
 		struct nsproxy *nsproxy;
 		nsproxy = task_nsproxy(tsk);
 		if (nsproxy)
-			net = get_net(nsproxy->net_ns);
+			net = get_net(rcu_dereference(nsproxy->net_ns));
 	}
 	rcu_read_unlock();
 	return net;
@@ -634,7 +634,7 @@ static void *netns_get(struct task_struct *task)
 	rcu_read_lock();
 	nsproxy = task_nsproxy(task);
 	if (nsproxy)
-		net = get_net(nsproxy->net_ns);
+		net = get_net(rcu_dereference(nsproxy->net_ns));
 	rcu_read_unlock();
 
 	return net;
@@ -647,14 +647,15 @@ static void netns_put(void *ns)
 
 static int netns_install(struct nsproxy *nsproxy, void *ns)
 {
-	struct net *net = ns;
+	struct net *old_net, *net = ns;
 
 	if (!ns_capable(net->user_ns, CAP_SYS_ADMIN) ||
 	    !nsown_capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	put_net(nsproxy->net_ns);
-	nsproxy->net_ns = get_net(net);
+	old_net = nsproxy->net_ns;
+	rcu_assign_pointer(nsproxy->net_ns, get_net(net));
+	put_net(old_net);
 	return 0;
 }
 
-- 
1.7.2.5

