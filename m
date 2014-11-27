Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbaK0M3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:29:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35588 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbaK0M3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:29:11 -0500
Date: Thu, 27 Nov 2014 13:29:08 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: oom && coredump
Message-ID: <20141127122908.GB18833@dhcp22.suse.cz>
References: <20141017171904.GA12263@redhat.com>
 <20141020184657.GA505@dhcp22.suse.cz>
 <20141020190620.GA21882@redhat.com>
 <20141020195618.GA606@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141020195618.GA606@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry this one has somehow completely fallen off my radar]

On Mon 20-10-14 21:56:18, Oleg Nesterov wrote:
> On 10/20, Oleg Nesterov wrote:
> >
> > And I agree that it
> > is hardly possible to close this race, and this patch makes the things
> > better.
> 
> speaking of "partial" fixes for oom problems...
> 
> Perhaps the patch below makes sense? Sure, it is racy, but probably
> better than nothing. And in any case (imo) this SIGNAL_GROUP_COREDUMP
> check doesn't look bad, the coredumping task can consume more memory,
> and we can't assume it is going to actually exit soon.

I am not familiar with this area much (it is too scary...).
I guess the issue is that OOM killer might try to kill a task which is
currently in the middle of cordumping which is not killable, right? And
if it is blocked on memory allocation then we are effectively dead
locked. Right?

Wouldn't it be better to make coredumping killable? Is this even
possible?

> And at least we can kill that ugly and wrong ptrace check.

Why is the ptrace check wrong? PF_EXITING should be set after
ptrace_event(PTRACE_EVENT_EXIT, code). But then I can see
unlikely(tsk->flags & PF_EXITING) check right after PTRACE_EVENT_EXIT
notification. Is this the thing?

But I do not get why we do not have to care about PTRACE_EVENT_EXIT once
SIGNAL_GROUP_COREDUMP is checked anymore or how they are related? What
prevents the original issue when the OOM victim is blocked by ptrace for
ever?

> What do you think?
> 
> Oleg.
> 
> --- x/mm/oom_kill.c
> +++ x/mm/oom_kill.c
> @@ -254,6 +254,12 @@ static enum oom_constraint constrained_alloc(struct zonelist *zonelist,
>  }
>  #endif
>  
> +static inline bool task_will_free_mem(struct task_struct *task)
> +{
> +	return (task->flags & PF_EXITING) &&
> +		!(task->signal->flags & SIGNAL_GROUP_COREDUMP);
> +}
> +
>  enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
>  		unsigned long totalpages, const nodemask_t *nodemask,
>  		bool force_kill)
> @@ -281,14 +287,9 @@ enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
>  	if (oom_task_origin(task))
>  		return OOM_SCAN_SELECT;
>  
> -	if (task->flags & PF_EXITING && !force_kill) {
> -		/*
> -		 * If this task is not being ptraced on exit, then wait for it
> -		 * to finish before killing some other task unnecessarily.
> -		 */
> -		if (!(task->group_leader->ptrace & PT_TRACE_EXIT))
> -			return OOM_SCAN_ABORT;
> -	}
> +	if (task_will_free_mem(task) && !force_kill)
> +		return OOM_SCAN_ABORT;
> +
>  	return OOM_SCAN_OK;
>  }
>  
> @@ -426,7 +427,7 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>  	 * If the task is already exiting, don't alarm the sysadmin or kill
>  	 * its children or threads, just set TIF_MEMDIE so it can die quickly
>  	 */
> -	if (p->flags & PF_EXITING) {
> +	if (task_will_free_mem(p)) {
>  		set_tsk_thread_flag(p, TIF_MEMDIE);
>  		put_task_struct(p);
>  		return;
> @@ -632,7 +633,7 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
>  	 * select it.  The goal is to allow it to allocate so that it may
>  	 * quickly exit and free its memory.
>  	 */
> -	if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
> +	if (fatal_signal_pending(current) || task_will_free_mem(current)) {
>  		set_thread_flag(TIF_MEMDIE);
>  		return;
>  	}
> 

-- 
Michal Hocko
SUSE Labs
