Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbaHLLor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 07:44:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33762 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147AbaHLLod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 07:44:33 -0400
Date: Tue, 12 Aug 2014 13:44:30 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v2] freezer: check OOM kill while being frozen
Message-ID: <20140812114430.GA7049@dhcp22.suse.cz>
References: <1407804835-24763-1-git-send-email-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407804835-24763-1-git-send-email-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 11-08-14 17:53:54, Cong Wang wrote:
> There is a race condition between OOM killer and freezer when
> they try to operate on the same process, something like below:
> 
>         Process A       Process B               Process C
> trigger page fault
> then trigger oom
> B=oom_scan_process_thread()
>                                         cgroup freezer freeze(A, B)
>                         ...
>                         try_to_freeze()
>                         stay in D state
> oom_kill_process(B)
> restart page fault
> ...
> 
> In this case, process A triggered a page fault in user-space,
> and the kernel page fault handler triggered OOM, then kernel
> selected process B as the victim, right before being killed
> process B was frozen by process C therefore went to D state,
> then kernel sent SIGKILL but it is already too late as
> process B will not care about pending signals any more.
> 
> David Rientjes tried to fix same issue with commit
> f660daac474c6f (oom: thaw threads if oom killed thread is
> frozen before deferring) but it doesn't work any more, because

Has it stopped working as a result of a3201227f803 (freezer: make
freezing() test freeze conditions in effect instead of TIF_FREEZE)?
It removes clear_freeze_flag from __thaw_task and so the OOM victim
cannot escape from the refrigerator. But there were a lot of changes in
that area at the time so I might be missing some subtle details.

> __thaw_task() just checks if it's frozen and then wakes it up,
> but the frozen task, after waking up, will check if freezing()
> is still true and continue to freeze itself if so. __thaw_task()
> can't make freezing() return false since it doesn't change any
> of these conditions, especially cgroup_freezing().
> 
> Fix this straightly by checking if the frozen process itself
> has been killed by OOM killer, so that the frozen process will
> recover itself and be killed finally.

OK, this should work. I remember Tejun mentioned that he wanted frozen
tasks to be killable but I have no idea where this went. Maybe we want
to go with the OOM part now as it fixes a real bug.

> Cc: David Rientjes <rientjes@google.com>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

I think this should go to stable as well.

Acked-by: Michal Hocko <mhocko@suse.cz>

Two minor notes below:

> ---
>  kernel/freezer.c | 19 +++++++++++--------
>  mm/oom_kill.c    |  2 --
>  2 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/freezer.c b/kernel/freezer.c
> index aa6a8aa..1f90d70 100644
> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c
> @@ -52,6 +52,16 @@ bool freezing_slow_path(struct task_struct *p)
>  }
>  EXPORT_SYMBOL(freezing_slow_path);
>  
> +static bool i_should_thaw_myself(bool check_kthr_stop)

should_thaw_current?

> +{
> +	if (!freezing(current) ||
> +	    (check_kthr_stop && kthread_should_stop()) ||
> +	    test_thread_flag(TIF_MEMDIE))
> +		return true;
> +	else
> +		return false;
> +}
> +
>  /* Refrigerator is place where frozen processes are stored :-). */
>  bool __refrigerator(bool check_kthr_stop)
>  {
> @@ -67,8 +77,7 @@ bool __refrigerator(bool check_kthr_stop)
>  
>  		spin_lock_irq(&freezer_lock);
>  		current->flags |= PF_FROZEN;
> -		if (!freezing(current) ||
> -		    (check_kthr_stop && kthread_should_stop()))
> +		if (i_should_thaw_myself(check_kthr_stop))
>  			current->flags &= ~PF_FROZEN;
>  		spin_unlock_irq(&freezer_lock);
>  
> @@ -147,12 +156,6 @@ void __thaw_task(struct task_struct *p)
>  {
>  	unsigned long flags;
>  
> -	/*
> -	 * Clear freezing and kick @p if FROZEN.  Clearing is guaranteed to
> -	 * be visible to @p as waking up implies wmb.  Waking up inside
> -	 * freezer_lock also prevents wakeups from leaking outside
> -	 * refrigerator.
> -	 */

This is an unrelated change.

>  	spin_lock_irqsave(&freezer_lock, flags);
>  	if (frozen(p))
>  		wake_up_process(p);
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 1e11df8..112c278 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -266,8 +266,6 @@ enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
>  	 * Don't allow any other task to have access to the reserves.
>  	 */
>  	if (test_tsk_thread_flag(task, TIF_MEMDIE)) {
> -		if (unlikely(frozen(task)))
> -			__thaw_task(task);
>  		if (!force_kill)
>  			return OOM_SCAN_ABORT;
>  	}
> -- 
> 1.8.3.1
> 

-- 
Michal Hocko
SUSE Labs
