Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab3IWVwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 17:52:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571Ab3IWVwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 17:52:19 -0400
Date: Mon, 23 Sep 2013 17:52:14 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: John Johansen <john.johansen@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] apparmor: remove the "task" arg from
 may_change_ptraced_domain()
Message-ID: <20130923215214.GV13968@madcap2.tricolour.ca>
References: <20130916142035.GA26661@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130916142035.GA26661@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 04:20:35PM +0200, Oleg Nesterov wrote:
> Unless task == current ptrace_parent(task) is not safe even under
> rcu_read_lock() and most of the current users are not right.

Could you point to an explanation of this?

> So may_change_ptraced_domain(task) looks wrong as well. However it
> is always called with task == current so the code is actually fine.
> Remove this argument to make this fact clear.
> 
> Note: perhaps we should simply kill ptrace_parent(), it buys almost
> nothing. And it is obviously racy, perhaps this should be fixed.

(Did you send a patch to fix the selinux hook?)

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Richard Guy Briggs <rgb@redhat.com>

> ---
>  security/apparmor/domain.c |   14 ++++++--------
>  1 files changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
> index 26c607c..8423558 100644
> --- a/security/apparmor/domain.c
> +++ b/security/apparmor/domain.c
> @@ -50,23 +50,21 @@ void aa_free_domain_entries(struct aa_domain *domain)
>  
>  /**
>   * may_change_ptraced_domain - check if can change profile on ptraced task
> - * @task: task we want to change profile of   (NOT NULL)
>   * @to_profile: profile to change to  (NOT NULL)
>   *
> - * Check if the task is ptraced and if so if the tracing task is allowed
> + * Check if current is ptraced and if so if the tracing task is allowed
>   * to trace the new domain
>   *
>   * Returns: %0 or error if change not allowed
>   */
> -static int may_change_ptraced_domain(struct task_struct *task,
> -				     struct aa_profile *to_profile)
> +static int may_change_ptraced_domain(struct aa_profile *to_profile)
>  {
>  	struct task_struct *tracer;
>  	struct aa_profile *tracerp = NULL;
>  	int error = 0;
>  
>  	rcu_read_lock();
> -	tracer = ptrace_parent(task);
> +	tracer = ptrace_parent(current);
>  	if (tracer)
>  		/* released below */
>  		tracerp = aa_get_task_profile(tracer);
> @@ -477,7 +475,7 @@ int apparmor_bprm_set_creds(struct linux_binprm *bprm)
>  	}
>  
>  	if (bprm->unsafe & (LSM_UNSAFE_PTRACE | LSM_UNSAFE_PTRACE_CAP)) {
> -		error = may_change_ptraced_domain(current, new_profile);
> +		error = may_change_ptraced_domain(new_profile);
>  		if (error) {
>  			aa_put_profile(new_profile);
>  			goto audit;
> @@ -690,7 +688,7 @@ int aa_change_hat(const char *hats[], int count, u64 token, bool permtest)
>  			}
>  		}
>  
> -		error = may_change_ptraced_domain(current, hat);
> +		error = may_change_ptraced_domain(hat);
>  		if (error) {
>  			info = "ptraced";
>  			error = -EPERM;
> @@ -829,7 +827,7 @@ int aa_change_profile(const char *ns_name, const char *hname, bool onexec,
>  	}
>  
>  	/* check if tracing task is allowed to trace target domain */
> -	error = may_change_ptraced_domain(current, target);
> +	error = may_change_ptraced_domain(target);
>  	if (error) {
>  		info = "ptrace prevents transition";
>  		goto audit;
> -- 
> 1.5.5.1
> 
> 

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer
Kernel Security
AMER ENG Base Operating Systems
Remote, Ottawa, Canada
Voice: +1.647.777.2635
Internal: (81) 32635
Alt: +1.613.693.0684x3545
