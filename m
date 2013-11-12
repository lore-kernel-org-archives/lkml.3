Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab3KLPNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 10:13:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35777 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab3KLPNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 10:13:11 -0500
Date: Tue, 12 Nov 2013 16:13:08 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Sameer Nanda <snanda@chromium.org>
Cc: akpm@linux-foundation.org, rientjes@google.com, hannes@cmpxchg.org,
        rusty@rustcorp.com.au, semenzato@google.com, murzin.v@gmail.com,
        oleg@redhat.com, dserrg@gmail.com, msb@chromium.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mm, oom: Fix race when selecting process to kill
Message-ID: <20131112151308.GD6049@dhcp22.suse.cz>
References: <20131109151639.GB14249@redhat.com>
 <1384215717-2389-1-git-send-email-snanda@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384215717-2389-1-git-send-email-snanda@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 11-11-13 16:21:57, Sameer Nanda wrote:
> The selection of the process to be killed happens in two spots:
> first in select_bad_process and then a further refinement by
> looking for child processes in oom_kill_process. Since this is
> a two step process, it is possible that the process selected by
> select_bad_process may get a SIGKILL just before oom_kill_process
> executes. If this were to happen, __unhash_process deletes this
> process from the thread_group list. This results in oom_kill_process
> getting stuck in an infinite loop when traversing the thread_group
> list of the selected process.
> 
> Fix this race by adding a pid_alive check for the selected process
> with tasklist_lock held in oom_kill_process.
> 
> Signed-off-by: Sameer Nanda <snanda@chromium.org>
> ---
>  mm/oom_kill.c | 24 +++++++++++++++++++-----
>  1 file changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 6738c47..57638ef 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -413,12 +413,20 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>  					      DEFAULT_RATELIMIT_BURST);
>  
>  	/*
> +	 * while_each_thread is currently not RCU safe. Lets hold the
> +	 * tasklist_lock across all invocations of while_each_thread (including
> +	 * the one in find_lock_task_mm) in this function.
> +	 */
> +	read_lock(&tasklist_lock);
> +
> +	/*
>  	 * If the task is already exiting, don't alarm the sysadmin or kill
>  	 * its children or threads, just set TIF_MEMDIE so it can die quickly
>  	 */
> -	if (p->flags & PF_EXITING) {
> +	if (p->flags & PF_EXITING || !pid_alive(p)) {
>  		set_tsk_thread_flag(p, TIF_MEMDIE);
>  		put_task_struct(p);
> +		read_unlock(&tasklist_lock);
>  		return;
>  	}

show_mem used to be one of a bottleneck but now that we have Mel's "mm:
do not walk all of system memory during show_mem" it shouldn't be a big
deal anymore.
The real trouble is with dump_tasks which might be zillions of tasks and
we do not want to hold tasklist_lock for that long.

So no this would regress on the huge machines and yes we have seen
reports like that and explicit requests to backport 6b0c81b3be114 (mm,
oom: reduce dependency on tasklist_lock) so this would be a step
backwards although I see there is a real problem that it tries to fix.

-- 
Michal Hocko
SUSE Labs
