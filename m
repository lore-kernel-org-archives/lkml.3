Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbaLBJT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 04:19:56 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:65421 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaLBJTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 04:19:51 -0500
Date: Tue, 2 Dec 2014 10:19:47 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] oom: don't assume that a coredumping thread will
 exit soon
Message-ID: <20141202091947.GB27014@dhcp22.suse.cz>
References: <20141127230349.GA25075@redhat.com>
 <20141127230405.GA25093@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141127230405.GA25093@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 28-11-14 00:04:05, Oleg Nesterov wrote:
> oom_kill.c assumes that PF_EXITING task should exit and free the memory
> soon. This is wrong in many ways and one important case is the coredump.
> A task can sleep in exit_mm() "forever" while the coredumping sub-thread
> can need more memory.
> 
> Change the PF_EXITING checks to take SIGNAL_GROUP_COREDUMP into account,
> we add the new trivial helper for that.
> 
> Note: this is only the first step, this patch doesn't try to solve other
> problems. For example it doesn't try to clear the wrongly set TIF_MEMDIE
> (SIGNAL_GROUP_COREDUMP check is obviously racy),

I am not sure I understand this. What do you mean by wrongly set
TIF_MEMDIE? That we give a process access to reserves even though it is
already done with the coredumping?

> fatal_signal_pending() can be false positive, etc.

When can this happen?

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

I guess the patch as is makes sense and it is an improvement. We need
to call the helper in mem_cgroup_out_of_memory as well, though.

With that feel free to add
Acked-by: Michal Hocko <mhocko@suse.cz>

Also the original fix for the coredumping (edd45544c6f0 "oom: avoid
deferring oom killer if exiting task is being traced") doesn't work
really as per http://marc.info/?l=linux-kernel&m=141711049013620 then
this and the follow up patch should be marked for stable I guess.

> ---
>  mm/oom_kill.c |   12 +++++++++---
>  1 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 5340f6b..7af33b5 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
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
> @@ -281,7 +287,7 @@ enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
>  	if (oom_task_origin(task))
>  		return OOM_SCAN_SELECT;
>  
> -	if (task->flags & PF_EXITING && !force_kill) {
> +	if (task_will_free_mem(task) && !force_kill) {
>  		/*
>  		 * If this task is not being ptraced on exit, then wait for it
>  		 * to finish before killing some other task unnecessarily.
> @@ -443,7 +449,7 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>  	 * If the task is already exiting, don't alarm the sysadmin or kill
>  	 * its children or threads, just set TIF_MEMDIE so it can die quickly
>  	 */
> -	if (p->flags & PF_EXITING) {
> +	if (task_will_free_mem(p)) {
>  		set_tsk_thread_flag(p, TIF_MEMDIE);
>  		put_task_struct(p);
>  		return;
> @@ -649,7 +655,7 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
>  	 * select it.  The goal is to allow it to allocate so that it may
>  	 * quickly exit and free its memory.
>  	 */
> -	if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
> +	if (fatal_signal_pending(current) || task_will_free_mem(current)) {
>  		set_thread_flag(TIF_MEMDIE);
>  		return;
>  	}
> -- 
> 1.5.5.1
> 

-- 
Michal Hocko
SUSE Labs
