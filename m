Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbaAQMPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 07:15:46 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:56824 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbaAQMPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 07:15:44 -0500
X-Nat-Received: from [202.181.97.72]:58853 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1389960938.13953
To: james.l.morris@oracle.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH(v2)] commoncap: don't alloc the credential unless needed in cap_task_prctl
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201312182139.DBE65685.FFFtOOOHQJLSVM@I-love.SAKURA.ne.jp>
	<20131218210353.GB28022@tp>
	<201312190630.EIE51594.tLMVQOFSHOJFOF@I-love.SAKURA.ne.jp>
	<20131223223242.GA29181@tp>
	<201401031939.CDD34371.VJMFtOFOOFHSLQ@I-love.SAKURA.ne.jp>
In-Reply-To: <201401031939.CDD34371.VJMFtOFOOFHSLQ@I-love.SAKURA.ne.jp>
Message-Id: <201401172115.GCC00099.OFQMFFtSLHOOJV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 17 Jan 2014 21:15:34 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 17012014 #7344181, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James, would you pick up this patch?

Tetsuo Handa wrote:
> James, please apply.
> 
> Kevin, does "cause OOM" mean something like the OOM killer or kmalloc() failure
> is triggerred by frequent prctl() requests by userspace applications?
> If yes, we should backport to stable as this affects any 2.6.29 and later kernels.
> --------------------
> From 1cb92c00bd1529f5d16a3f13c09f2bd6b6f7c6ca Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Thu, 19 Dec 2013 06:23:04 +0900
> Subject: [PATCH] commoncap: don't alloc the credential unless needed in cap_task_prctl
> 
> In function cap_task_prctl(), we would allocate a credential
> unconditionally and then check if we support the requested function.
> If not we would release this credential with abort_creds() by using
> RCU method. But on some archs such as powerpc, the sys_prctl is heavily
> used to get/set the floating point exception mode. So the unnecessary
> allocating/releasing of credential not only introduce runtime overhead
> but also do cause OOM due to the RCU implementation.
> 
> This patch removes abort_creds() from cap_task_prctl() by calling
> prepare_creds() only when we need to modify it.
> 
> Reported-by: Kevin Hao <haokexin@gmail.com>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
> ---
>  security/commoncap.c |  134 +++++++++++++++++++++++++------------------------
>  1 files changed, 68 insertions(+), 66 deletions(-)
> 
> diff --git a/security/commoncap.c b/security/commoncap.c
> index b9d613e..2b62f44 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -818,19 +818,75 @@ int cap_task_setnice(struct task_struct *p, int nice)
>  	return cap_safe_nice(p);
>  }
>  
> +static int cap_prctl_read(const struct cred *old, unsigned long arg2)
> +{
> +	if (!cap_valid(arg2))
> +		return -EINVAL;
> +	return !!cap_raised(old->cap_bset, arg2);
> +}
> +
>  /*
>   * Implement PR_CAPBSET_DROP.  Attempt to remove the specified capability from
>   * the current task's bounding set.  Returns 0 on success, -ve on error.
>   */
> -static long cap_prctl_drop(struct cred *new, unsigned long cap)
> +static int cap_prctl_drop(const struct cred *old, unsigned long cap)
>  {
> -	if (!ns_capable(current_user_ns(), CAP_SETPCAP))
> +	struct cred *new;
> +
> +	if (!ns_capable(old->user_ns, CAP_SETPCAP))
>  		return -EPERM;
>  	if (!cap_valid(cap))
>  		return -EINVAL;
> -
> +	new = prepare_creds();
> +	if (!new)
> +		return -ENOMEM;
>  	cap_lower(new->cap_bset, cap);
> -	return 0;
> +	return commit_creds(new);
> +}
> +
> +static int cap_prctl_securebits(const struct cred *old, unsigned long arg2)
> +{
> +	struct cred *new;
> +
> +	if ((((old->securebits & SECURE_ALL_LOCKS) >> 1)
> +	     & (old->securebits ^ arg2))			/*[1]*/
> +	    || ((old->securebits & SECURE_ALL_LOCKS & ~arg2))	/*[2]*/
> +	    || (arg2 & ~(SECURE_ALL_LOCKS | SECURE_ALL_BITS))	/*[3]*/
> +	    || (cap_capable(old, old->user_ns, CAP_SETPCAP,
> +			    SECURITY_CAP_AUDIT) != 0)		/*[4]*/
> +	    /*
> +	     * [1] no changing of bits that are locked
> +	     * [2] no unlocking of locks
> +	     * [3] no setting of unsupported bits
> +	     * [4] doing anything requires privilege (go read about
> +	     *     the "sendmail capabilities bug")
> +	     */
> +	    )
> +		/* cannot change a locked bit */
> +		return -EPERM;
> +	new = prepare_creds();
> +	if (!new)
> +		return -ENOMEM;
> +	new->securebits = arg2;
> +	return commit_creds(new);
> +}
> +
> +static int cap_prctl_keepcaps(unsigned long arg2)
> +{
> +	struct cred *new;
> +
> +	if (arg2 > 1) /* Note, we rely on arg2 being unsigned here */
> +		return -EINVAL;
> +	if (issecure(SECURE_KEEP_CAPS_LOCKED))
> +		return -EPERM;
> +	new = prepare_creds();
> +	if (!new)
> +		return -ENOMEM;
> +	if (arg2)
> +		new->securebits |= issecure_mask(SECURE_KEEP_CAPS);
> +	else
> +		new->securebits &= ~issecure_mask(SECURE_KEEP_CAPS);
> +	return commit_creds(new);
>  }
>  
>  /**
> @@ -848,26 +904,14 @@ static long cap_prctl_drop(struct cred *new, unsigned long cap)
>  int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
>  		   unsigned long arg4, unsigned long arg5)
>  {
> -	struct cred *new;
> -	long error = 0;
> -
> -	new = prepare_creds();
> -	if (!new)
> -		return -ENOMEM;
> +	const struct cred *old = current_cred();
>  
>  	switch (option) {
>  	case PR_CAPBSET_READ:
> -		error = -EINVAL;
> -		if (!cap_valid(arg2))
> -			goto error;
> -		error = !!cap_raised(new->cap_bset, arg2);
> -		goto no_change;
> +		return cap_prctl_read(old, arg2);
>  
>  	case PR_CAPBSET_DROP:
> -		error = cap_prctl_drop(new, arg2);
> -		if (error < 0)
> -			goto error;
> -		goto changed;
> +		return cap_prctl_drop(old, arg2);
>  
>  	/*
>  	 * The next four prctl's remain to assist with transitioning a
> @@ -889,63 +933,21 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
>  	 * capability-based-privilege environment.
>  	 */
>  	case PR_SET_SECUREBITS:
> -		error = -EPERM;
> -		if ((((new->securebits & SECURE_ALL_LOCKS) >> 1)
> -		     & (new->securebits ^ arg2))			/*[1]*/
> -		    || ((new->securebits & SECURE_ALL_LOCKS & ~arg2))	/*[2]*/
> -		    || (arg2 & ~(SECURE_ALL_LOCKS | SECURE_ALL_BITS))	/*[3]*/
> -		    || (cap_capable(current_cred(),
> -				    current_cred()->user_ns, CAP_SETPCAP,
> -				    SECURITY_CAP_AUDIT) != 0)		/*[4]*/
> -			/*
> -			 * [1] no changing of bits that are locked
> -			 * [2] no unlocking of locks
> -			 * [3] no setting of unsupported bits
> -			 * [4] doing anything requires privilege (go read about
> -			 *     the "sendmail capabilities bug")
> -			 */
> -		    )
> -			/* cannot change a locked bit */
> -			goto error;
> -		new->securebits = arg2;
> -		goto changed;
> +		return cap_prctl_securebits(old, arg2);
>  
>  	case PR_GET_SECUREBITS:
> -		error = new->securebits;
> -		goto no_change;
> +		return old->securebits;
>  
>  	case PR_GET_KEEPCAPS:
> -		if (issecure(SECURE_KEEP_CAPS))
> -			error = 1;
> -		goto no_change;
> +		return !!issecure(SECURE_KEEP_CAPS);
>  
>  	case PR_SET_KEEPCAPS:
> -		error = -EINVAL;
> -		if (arg2 > 1) /* Note, we rely on arg2 being unsigned here */
> -			goto error;
> -		error = -EPERM;
> -		if (issecure(SECURE_KEEP_CAPS_LOCKED))
> -			goto error;
> -		if (arg2)
> -			new->securebits |= issecure_mask(SECURE_KEEP_CAPS);
> -		else
> -			new->securebits &= ~issecure_mask(SECURE_KEEP_CAPS);
> -		goto changed;
> +		return cap_prctl_keepcaps(arg2);
>  
>  	default:
>  		/* No functionality available - continue with default */
> -		error = -ENOSYS;
> -		goto error;
> +		return -ENOSYS;
>  	}
> -
> -	/* Functionality provided */
> -changed:
> -	return commit_creds(new);
> -
> -no_change:
> -error:
> -	abort_creds(new);
> -	return error;
>  }
>  
>  /**
> -- 
> 1.7.1
> 
