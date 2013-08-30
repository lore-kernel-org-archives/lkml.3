Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab3H3QKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 12:10:09 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:43375
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753886Ab3H3QKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 12:10:08 -0400
Date: Fri, 30 Aug 2013 16:10:03 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org
Subject: Re: [REVIEW][PATCH 1/5] namespaces: Simplify copy_namespaces so it
 is clear what is going on.
Message-ID: <20130830161003.GA18857@mail.hallyn.com>
References: <87ob8gys0d.fsf@xmission.com>
 <87ioyoyryr.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ioyoyryr.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> 
> Remove the test for the impossible case where tsk->nsproxy == NULL.  Fork
> will never be called with tsk->nsproxy == NULL.
> 
> Only call get_nsproxy when we don't need to generate a new_nsproxy,
> and mark the case where we don't generate a new nsproxy as likely.
> 
> Remove the code to drop an unnecessarily acquired nsproxy value.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  kernel/nsproxy.c |   35 +++++++++++------------------------
>  1 files changed, 11 insertions(+), 24 deletions(-)
> 
> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> index d9afd2563..a1ed011 100644
> --- a/kernel/nsproxy.c
> +++ b/kernel/nsproxy.c
> @@ -125,22 +125,16 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
>  	struct nsproxy *old_ns = tsk->nsproxy;
>  	struct user_namespace *user_ns = task_cred_xxx(tsk, user_ns);
>  	struct nsproxy *new_ns;
> -	int err = 0;
>  
> -	if (!old_ns)
> +	if (likely(!(flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
> +			      CLONE_NEWPID | CLONE_NEWNET)))) {
> +		get_nsproxy(old_ns);
>  		return 0;
> -
> -	get_nsproxy(old_ns);
> -
> -	if (!(flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
> -				CLONE_NEWPID | CLONE_NEWNET)))
> -		return 0;
> -
> -	if (!ns_capable(user_ns, CAP_SYS_ADMIN)) {
> -		err = -EPERM;
> -		goto out;
>  	}
>  
> +	if (!ns_capable(user_ns, CAP_SYS_ADMIN))
> +		return -EPERM;
> +
>  	/*
>  	 * CLONE_NEWIPC must detach from the undolist: after switching
>  	 * to a new ipc namespace, the semaphore arrays from the old
> @@ -149,22 +143,15 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
>  	 * it along with CLONE_NEWIPC.
>  	 */
>  	if ((flags & (CLONE_NEWIPC | CLONE_SYSVSEM)) ==
> -		(CLONE_NEWIPC | CLONE_SYSVSEM)) {
> -		err = -EINVAL;
> -		goto out;
> -	}
> +		(CLONE_NEWIPC | CLONE_SYSVSEM)) 
> +		return -EINVAL;
>  
>  	new_ns = create_new_namespaces(flags, tsk, user_ns, tsk->fs);
> -	if (IS_ERR(new_ns)) {
> -		err = PTR_ERR(new_ns);
> -		goto out;
> -	}
> +	if (IS_ERR(new_ns))
> +		return  PTR_ERR(new_ns);
>  
>  	tsk->nsproxy = new_ns;
> -
> -out:
> -	put_nsproxy(old_ns);
> -	return err;
> +	return 0;
>  }
>  
>  void free_nsproxy(struct nsproxy *ns)
> -- 
> 1.7.5.4
