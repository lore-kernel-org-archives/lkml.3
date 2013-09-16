Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab3IPRBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 13:01:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42465 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab3IPRBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 13:01:54 -0400
Message-ID: <5237397C.2050308@canonical.com>
Date: Mon, 16 Sep 2013 10:01:48 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Richard Guy Briggs <rgb@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] apparmor: remove the "task" arg from may_change_ptraced_domain()
References: <20130916142035.GA26661@redhat.com>
In-Reply-To: <20130916142035.GA26661@redhat.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2013 07:20 AM, Oleg Nesterov wrote:
> Unless task == current ptrace_parent(task) is not safe even under
> rcu_read_lock() and most of the current users are not right.
> 
> So may_change_ptraced_domain(task) looks wrong as well. However it
> is always called with task == current so the code is actually fine.
> Remove this argument to make this fact clear.
> 
> Note: perhaps we should simply kill ptrace_parent(), it buys almost
> nothing. And it is obviously racy, perhaps this should be fixed.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: John Johansen <john.johansen@canonical.com>

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
> 

