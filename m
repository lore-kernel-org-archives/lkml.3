Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab3K1Gf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 01:35:26 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:42647 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705Ab3K1GfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 01:35:24 -0500
Date: Thu, 28 Nov 2013 01:35:05 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Ma, Xindong" <xindong.ma@intel.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mhocko@suse.cz" <mhocko@suse.cz>,
        "rientjes@google.com" <rientjes@google.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Peter Zijlstra'" <peterz@infradead.org>,
        "'gregkh@linuxfoundation.org'" <gregkh@linuxfoundation.org>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>,
        William Dauchy <wdauchy@gmail.com>, azurIt <azurit@pobox.sk>
Subject: Re: [PATCH] Fix race between oom kill and task exit
Message-ID: <20131128063505.GN3556@cmpxchg.org>
References: <3917C05D9F83184EAA45CE249FF1B1DD0253093A@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3917C05D9F83184EAA45CE249FF1B1DD0253093A@SHSMSX103.ccr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc William and azur who might have encountered this problem.

On Thu, Nov 28, 2013 at 05:09:16AM +0000, Ma, Xindong wrote:
> From: Leon Ma <xindong.ma@intel.com>
> Date: Thu, 28 Nov 2013 12:46:09 +0800
> Subject: [PATCH] Fix race between oom kill and task exit
> 
> There is a race between oom kill and task exit. Scenario is:
>    TASK  A                      TASK  B
> TASK B is selected to oom kill
> in oom_kill_process()
> check PF_EXITING of TASK B
>                             task call do_exit()
>                             task set PF_EXITING flag
>                             write_lock_irq(&tasklist_lock);
>                             remove TASK B from thread group in __unhash_process()
>                             write_unlock_irq(&tasklist_lock);
> read_lock(&tasklist_lock);
> traverse threads of TASK B
> read_unlock(&tasklist_lock);
> 
> After that, the following traversal of threads in TASK B will not end because TASK B is not in the thread group:
> do {
> ....
> } while_each_thread(p, t);
> 
> Signed-off-by: Leon Ma <xindong.ma@intel.com>
> Signed-off-by: xiaobing tu <xiaobing.tu@intel.com>
> ---
>  mm/oom_kill.c |   20 ++++++++++----------
>  1 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 1e4a600..32ec88d 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -412,16 +412,6 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>  	static DEFINE_RATELIMIT_STATE(oom_rs, DEFAULT_RATELIMIT_INTERVAL,
>  					      DEFAULT_RATELIMIT_BURST);
>  
> -	/*
> -	 * If the task is already exiting, don't alarm the sysadmin or kill
> -	 * its children or threads, just set TIF_MEMDIE so it can die quickly
> -	 */
> -	if (p->flags & PF_EXITING) {
> -		set_tsk_thread_flag(p, TIF_MEMDIE);
> -		put_task_struct(p);
> -		return;
> -	}
> -
>  	if (__ratelimit(&oom_rs))
>  		dump_header(p, gfp_mask, order, memcg, nodemask);
>  
> @@ -437,6 +427,16 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>  	 * still freeing memory.
>  	 */
>  	read_lock(&tasklist_lock);
> +	/*
> +	 * If the task is already exiting, don't alarm the sysadmin or kill
> +	 * its children or threads, just set TIF_MEMDIE so it can die quickly
> +	 */
> +	if (p->flags & PF_EXITING) {
> +		set_tsk_thread_flag(p, TIF_MEMDIE);
> +		put_task_struct(p);
> +		read_unlock(&tasklist_lock);
> +		return;
> +	}
>  	do {
>  		list_for_each_entry(child, &t->children, sibling) {
>  			unsigned int child_points;
> -- 
> 1.7.4.1
> 
