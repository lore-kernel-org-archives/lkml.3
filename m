Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab3JRWet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 18:34:49 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:54824 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757330Ab3JRWes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 18:34:48 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Guillaume Gaudonville" <gaudonville@6wind.com>
Cc: linux-kernel@vger.kernel.org, serge.hallyn@canonical.com,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        davem@davemloft.net, cmetcalf@tilera.com,
        Guillaume Gaudonville <guillaume.gaudonville@6wind.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
References: <8738o1ovdi.fsf@xmission.com>
	<1382107599-1028-1-git-send-email-guillaume.gaudonville@6wind.com>
Date: Fri, 18 Oct 2013 15:34:35 -0700
In-Reply-To: <1382107599-1028-1-git-send-email-guillaume.gaudonville@6wind.com>
	(Guillaume Gaudonville's message of "Fri, 18 Oct 2013 16:46:39 +0200")
Message-ID: <87y55qqkck.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+SF852TEBHc0XkWD4bkqm6RayUNdGUkZw=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0787]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Guillaume Gaudonville" <gaudonville@6wind.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC PATCH linux-next v2] ns: do not allocate a new nsproxy at each call
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Guillaume Gaudonville" <gaudonville@6wind.com> writes:

> Currently, at each call of setns system call a new nsproxy is allocated,
> the old nsproxy namespaces are copied into the new one and the old nsproxy
> is freed if the task was the only one to use it.

In principle this looks ok.  However you are not using rcu properly.

What you are doing is just far enough outside of normal rcu usage my
brain refuses to think it through today.

Paul can you give us a hand?

Specific code comments below.

It looks like what we really want for the pointer variables in nsproxy
is an atomic pointer type.  We have something like that with
ACCESS_ONCE.    Without a prebuilt idiom I am not thinking through this
issue clearly right now.

Maybe you are right that we need to push the rcu protection down a
level.  So we can have free reads and inexpensive writes.

> It can creates large delays on hardware with large number of cpus since
> to free a nsproxy a synchronize_rcu() call is done.
>
> When a task is the only one to use a nsproxy, only the task can do an action
> that will make this nsproxy to be shared by another task or thread (fork,...).
> So when the refcount of the nsproxy is equal to 1, we can simply update the
> current nsproxy field without allocating a new one and freeing the old one.
>
> The install operations of each kind of namespace cannot fails, so there's no
> need to check for an error and calling ops->install().
>
> However since we can have readers of the nsproxy that are not the current task,
> we need to protect access to each namespace pointer in the nsproxy. This is
> done by assigning it using rcu_assign_pointer() and when it is possible
> that the reader is not the current task, read the pointer using
> rcu_dereference().
>
> Finally the install function of each namespace type must be modified to ensure
> that the refcount of the old namespace is released after the assignment in
> nsproxy.
>
> On kernel 3.12-rc1, using a small application that does:
>
> - call setns on a first net namespace and open a socket,
> - call setns on a second net namespace and open a socket,
> - switch back to the first namespace and close the socket,
> - switch back to the second namespace and close the socket,

Note.  You don't need to switch namespaces for any operation except
opening the socket.  Sockets are always fixed in a single network
namespace.

Part of me wonders if this is the time to introduce the socketat system
call I threatend people with a while ago that takes a netns file
descriptor and gives you a socket in the specified namespace.

> On an Intel Westmere with 24 logical cores at 3.33 GHz, it gives the
> following results using the time command:
>
> - without the proposed patch:
>
>   root@blackcloudy:~# time ./test_x86
>
>   real    0m0.130s
>   user    0m0.000s
>   sys     0m0.000s
>
> - with the proposed patch:
>
>   root@blackcloudy:~# time ./test_x86
>
>   real    0m0.020s
>   user    0m0.000s
>   sys     0m0.000s
>
> Reported-by: Chris Metcalf <cmetcalf@tilera.com>
> Signed-off-by: Guillaume Gaudonville <guillaume.gaudonville@6wind.com>
> ---
>
> v2:
>   - protect readers, by releasing namespaces refcount after updating the
>     nsproxy pointer,
>   - protect readers, by using rcu_assign_pointer() to affect nsproxy
>     pointers,
>   - readers need to use rcu_dereference() to access the namespace and
>     must take a reference on it before leaving the rcu_read_lock section
>     (this last part was already present),
>   - do not add additional exit point in setns syscall.
>
> There are still 2 suspicious functions, nfs_server_list_open() and
> nfs_volume_list_open(). They are accessing directly to the net_ns
> like below:
>
> struct net *net = pid_ns->child_reaper->nsproxy->net_ns;
>
> It seems to me that currently they should access it under rcu_read_lock()
> and using task_nsproxy(pid_ns->child_reaper). It looks like a bug, no?
>
> And then with this proposed patch they should access the netns through
> a rcu_dereference and take a reference on the netns. I didn't
> modify them for now, but if it is confirmed I can send a patch
> fixing the first issue and then send a v3 of this proposed patch.
>
>  fs/namespace.c           |    9 +++++----
>  fs/proc/proc_net.c       |    2 +-
>  fs/proc_namespace.c      |    2 +-
>  ipc/namespace.c          |    9 +++++----
>  kernel/nsproxy.c         |   11 +++++++++++
>  kernel/pid_namespace.c   |    7 ++++---
>  kernel/utsname.c         |    9 +++++----
>  net/core/net_namespace.c |   11 ++++++-----
>  8 files changed, 38 insertions(+), 22 deletions(-)
>

[snip]

> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> index afc0456..4ad9f9f 100644
> --- a/kernel/nsproxy.c
> +++ b/kernel/nsproxy.c
> @@ -255,6 +255,17 @@ SYSCALL_DEFINE2(setns, int, fd, int, nstype)
>  	if (nstype && (ops->type != nstype))
>  		goto out;
>  
> +	/*
> +	 * If count == 1, only the current task can increment it,
> +	 * by doing a fork for example so we can safely update the
> +	 * current nsproxy pointers without allocate a new one,
> +	 * update it and destroy the old one
> +	 */
> +	if (atomic_read(&tsk->nsproxy->count) == 1) {
> +		err = ops->install(tsk->nsproxy, ei->ns);
> +		goto out;
> +	}

Typically to modify something you would need a lock, and the barriers
that implies.  We don't need a lock but I don't know if missing the
barriers is a problem.

> +
>  	new_nsproxy = create_new_namespaces(0, tsk, current_user_ns(), tsk->fs);
>  	if (IS_ERR(new_nsproxy)) {
>  		err = PTR_ERR(new_nsproxy);

[snip]
> diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
> index 80e271d..966d435 100644
> --- a/net/core/net_namespace.c
> +++ b/net/core/net_namespace.c
> @@ -374,7 +374,7 @@ struct net *get_net_ns_by_pid(pid_t pid)
>  		struct nsproxy *nsproxy;
>  		nsproxy = task_nsproxy(tsk);
>  		if (nsproxy)
> -			net = get_net(nsproxy->net_ns);
> +			net = get_net(rcu_dereference(nsproxy->net_ns));

net_ns is not rcu protected so rcu_derference is misleading and wrong.
Perhaps ACCESS_ONCE is what we want here.

>  	}
>  	rcu_read_unlock();
>  	return net;

[snip]

> @@ -647,14 +647,15 @@ static void netns_put(void *ns)
>  
>  static int netns_install(struct nsproxy *nsproxy, void *ns)
>  {
> -	struct net *net = ns;
> +	struct net *old_net, *net = ns;
>  
>  	if (!ns_capable(net->user_ns, CAP_SYS_ADMIN) ||
>  	    !nsown_capable(CAP_SYS_ADMIN))
>  		return -EPERM;
>  
> -	put_net(nsproxy->net_ns);
> -	nsproxy->net_ns = get_net(net);
> +	old_net = nsproxy->net_ns;
> +	rcu_assign_pointer(nsproxy->net_ns, get_net(net));
> +	put_net(old_net);

The ordering of operations is correct.  rcu_assign_pointer
is not correct because net_ns is not rcu protected.

>  	return 0;
>  }
