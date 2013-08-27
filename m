Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab3H0BCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:02:53 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41414 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab3H0BCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:02:50 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: security@kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <cover.1377196394.git.luto@amacapital.net>
	<cover.1377196394.git.luto@amacapital.net>
	<a5db0606160dbd1412828be0d91a4a115a84abf6.1377196394.git.luto@amacapital.net>
Date: Mon, 26 Aug 2013 18:02:42 -0700
In-Reply-To: <a5db0606160dbd1412828be0d91a4a115a84abf6.1377196394.git.luto@amacapital.net>
	(Andy Lutomirski's message of "Thu, 22 Aug 2013 11:39:16 -0700")
Message-ID: <87y57olzd9.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19R1DemAKaelaV3PfRBhLyAa4FD4xXEuNE=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.5 XMGappySubj_01 Very gappy subject
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0003]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/2] Rename nsproxy.pid_ns to nsproxy.pid_ns_for_children
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> nsproxy.pid_ns is *not* the task's pid namespace.  The name should clarify
> that.
>
> This makes it more obvious that setns on a pid namespace is weird --
> it won't change the pid namespace shown in procfs.

Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>

> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  include/linux/nsproxy.h |  6 +++++-
>  kernel/fork.c           |  5 +++--
>  kernel/nsproxy.c        | 27 ++++++++++++++-------------
>  kernel/pid_namespace.c  |  4 ++--
>  4 files changed, 24 insertions(+), 18 deletions(-)
>
> diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
> index 10e5947..b4ec59d 100644
> --- a/include/linux/nsproxy.h
> +++ b/include/linux/nsproxy.h
> @@ -14,6 +14,10 @@ struct fs_struct;
>   * A structure to contain pointers to all per-process
>   * namespaces - fs (mount), uts, network, sysvipc, etc.
>   *
> + * The pid namespace is an exception -- it's accessed using
> + * task_active_pid_ns.  The pid namespace here is the
> + * namespace that children will use.
> + *
>   * 'count' is the number of tasks holding a reference.
>   * The count for each namespace, then, will be the number
>   * of nsproxies pointing to it, not the number of tasks.
> @@ -27,7 +31,7 @@ struct nsproxy {
>  	struct uts_namespace *uts_ns;
>  	struct ipc_namespace *ipc_ns;
>  	struct mnt_namespace *mnt_ns;
> -	struct pid_namespace *pid_ns;
> +	struct pid_namespace *pid_ns_for_children;
>  	struct net 	     *net_ns;
>  };
>  extern struct nsproxy init_nsproxy;
> diff --git a/kernel/fork.c b/kernel/fork.c
> index e23bb19..bf46287 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1177,7 +1177,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  	 * don't allow the creation of threads.
>  	 */
>  	if ((clone_flags & (CLONE_VM|CLONE_NEWPID)) &&
> -	    (task_active_pid_ns(current) != current->nsproxy->pid_ns))
> +	    (task_active_pid_ns(current) !=
> +	     current->nsproxy->pid_ns_for_children))
>  		return ERR_PTR(-EINVAL);
>  
>  	retval = security_task_create(clone_flags);
> @@ -1351,7 +1352,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
>  
>  	if (pid != &init_struct_pid) {
>  		retval = -ENOMEM;
> -		pid = alloc_pid(p->nsproxy->pid_ns);
> +		pid = alloc_pid(p->nsproxy->pid_ns_for_children);
>  		if (!pid)
>  			goto bad_fork_cleanup_io;
>  	}
> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> index 364ceab..997cbb9 100644
> --- a/kernel/nsproxy.c
> +++ b/kernel/nsproxy.c
> @@ -29,15 +29,15 @@
>  static struct kmem_cache *nsproxy_cachep;
>  
>  struct nsproxy init_nsproxy = {
> -	.count	= ATOMIC_INIT(1),
> -	.uts_ns	= &init_uts_ns,
> +	.count			= ATOMIC_INIT(1),
> +	.uts_ns			= &init_uts_ns,
>  #if defined(CONFIG_POSIX_MQUEUE) || defined(CONFIG_SYSVIPC)
> -	.ipc_ns	= &init_ipc_ns,
> +	.ipc_ns			= &init_ipc_ns,
>  #endif
> -	.mnt_ns	= NULL,
> -	.pid_ns	= &init_pid_ns,
> +	.mnt_ns			= NULL,
> +	.pid_ns_for_children	= &init_pid_ns,
>  #ifdef CONFIG_NET
> -	.net_ns	= &init_net,
> +	.net_ns			= &init_net,
>  #endif
>  };
>  
> @@ -85,9 +85,10 @@ static struct nsproxy *create_new_namespaces(unsigned long flags,
>  		goto out_ipc;
>  	}
>  
> -	new_nsp->pid_ns = copy_pid_ns(flags, user_ns, tsk->nsproxy->pid_ns);
> -	if (IS_ERR(new_nsp->pid_ns)) {
> -		err = PTR_ERR(new_nsp->pid_ns);
> +	new_nsp->pid_ns_for_children =
> +		copy_pid_ns(flags, user_ns, tsk->nsproxy->pid_ns_for_children);
> +	if (IS_ERR(new_nsp->pid_ns_for_children)) {
> +		err = PTR_ERR(new_nsp->pid_ns_for_children);
>  		goto out_pid;
>  	}
>  
> @@ -100,8 +101,8 @@ static struct nsproxy *create_new_namespaces(unsigned long flags,
>  	return new_nsp;
>  
>  out_net:
> -	if (new_nsp->pid_ns)
> -		put_pid_ns(new_nsp->pid_ns);
> +	if (new_nsp->pid_ns_for_children)
> +		put_pid_ns(new_nsp->pid_ns_for_children);
>  out_pid:
>  	if (new_nsp->ipc_ns)
>  		put_ipc_ns(new_nsp->ipc_ns);
> @@ -174,8 +175,8 @@ void free_nsproxy(struct nsproxy *ns)
>  		put_uts_ns(ns->uts_ns);
>  	if (ns->ipc_ns)
>  		put_ipc_ns(ns->ipc_ns);
> -	if (ns->pid_ns)
> -		put_pid_ns(ns->pid_ns);
> +	if (ns->pid_ns_for_children)
> +		put_pid_ns(ns->pid_ns_for_children);
>  	put_net(ns->net_ns);
>  	kmem_cache_free(nsproxy_cachep, ns);
>  }
> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index 6917e8e..601bb36 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -349,8 +349,8 @@ static int pidns_install(struct nsproxy *nsproxy, void *ns)
>  	if (ancestor != active)
>  		return -EINVAL;
>  
> -	put_pid_ns(nsproxy->pid_ns);
> -	nsproxy->pid_ns = get_pid_ns(new);
> +	put_pid_ns(nsproxy->pid_ns_for_children);
> +	nsproxy->pid_ns_for_children = get_pid_ns(new);
>  	return 0;
>  }
