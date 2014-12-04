Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbaLDOeb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 09:34:31 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:43393 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaLDOe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 09:34:29 -0500
Date: Thu, 4 Dec 2014 15:34:26 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] oom: don't assume that a coredumping thread will
 exit soon
Message-ID: <20141204143426.GB25001@dhcp22.suse.cz>
References: <20141127230349.GA25075@redhat.com>
 <20141203195001.GA11558@redhat.com>
 <20141203195020.GB11558@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141203195020.GB11558@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 03-12-14 20:50:20, Oleg Nesterov wrote:
> oom_kill.c assumes that PF_EXITING task should exit and free the memory
> soon. This is wrong in many ways and one important case is the coredump.
> A task can sleep in exit_mm() "forever" while the coredumping sub-thread
> can need more memory.
> 
> Change the PF_EXITING checks to take SIGNAL_GROUP_COREDUMP into account,
> we add the new trivial helper for that.
> 
> Note: this is only the first step, this patch doesn't try to solve other
> problems. The SIGNAL_GROUP_COREDUMP check is obviously racy, a task can
> participate in coredump after it was already observed in PF_EXITING state,
> so TIF_MEMDIE (which also blocks oom-killer) still can be wrongly set.
> fatal_signal_pending() can be true because of SIGNAL_GROUP_COREDUMP so
> out_of_memory() and mem_cgroup_out_of_memory() shouldn't blindly trust it.
> And even the name/usage of the new helper is confusing, an exiting thread
> can only free its ->mm if it is the only/last task in thread group.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

OK, I do not have a better name for the helper and code duplication
looks even worse so
Acked-by: Michal Hocko <mhocko@suse.cz>

Andrew's additional comment makes sense as well.
> ---
>  include/linux/oom.h |    6 ++++++
>  mm/memcontrol.c     |    2 +-
>  mm/oom_kill.c       |    6 +++---
>  3 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/oom.h b/include/linux/oom.h
> index e8d6e10..e16b945 100644
> --- a/include/linux/oom.h
> +++ b/include/linux/oom.h
> @@ -92,6 +92,12 @@ static inline bool oom_gfp_allowed(gfp_t gfp_mask)
>  
>  extern struct task_struct *find_lock_task_mm(struct task_struct *p);
>  
> +static inline bool task_will_free_mem(struct task_struct *task)
> +{
> +	return (task->flags & PF_EXITING) &&
> +		!(task->signal->flags & SIGNAL_GROUP_COREDUMP);
> +}
> +
>  /* sysctls */
>  extern int sysctl_oom_dump_tasks;
>  extern int sysctl_oom_kill_allocating_task;
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d6ac0e3..3d1d49f 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1734,7 +1734,7 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	 * select it.  The goal is to allow it to allocate so that it may
>  	 * quickly exit and free its memory.
>  	 */
> -	if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
> +	if (fatal_signal_pending(current) || task_will_free_mem(current)) {
>  		set_thread_flag(TIF_MEMDIE);
>  		return;
>  	}
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 5340f6b..837ff31 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -281,7 +281,7 @@ enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
>  	if (oom_task_origin(task))
>  		return OOM_SCAN_SELECT;
>  
> -	if (task->flags & PF_EXITING && !force_kill) {
> +	if (task_will_free_mem(task) && !force_kill) {
>  		/*
>  		 * If this task is not being ptraced on exit, then wait for it
>  		 * to finish before killing some other task unnecessarily.
> @@ -443,7 +443,7 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>  	 * If the task is already exiting, don't alarm the sysadmin or kill
>  	 * its children or threads, just set TIF_MEMDIE so it can die quickly
>  	 */
> -	if (p->flags & PF_EXITING) {
> +	if (task_will_free_mem(p)) {
>  		set_tsk_thread_flag(p, TIF_MEMDIE);
>  		put_task_struct(p);
>  		return;
> @@ -649,7 +649,7 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
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
> 

-- 
Michal Hocko
SUSE Labs
