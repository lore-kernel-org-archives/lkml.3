Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab3IIUHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 16:07:15 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:37882 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab3IIUHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 16:07:11 -0400
Date: Mon, 9 Sep 2013 13:07:08 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sergey Dyasly <dserrg@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>,
        Sha Zhengju <handai.szj@taobao.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] OOM killer: wait for tasks with pending SIGKILL to
 exit
In-Reply-To: <1378740624-2456-1-git-send-email-dserrg@gmail.com>
Message-ID: <alpine.DEB.2.02.1309091303010.12523@chino.kir.corp.google.com>
References: <1378740624-2456-1-git-send-email-dserrg@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Sep 2013, Sergey Dyasly wrote:

> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 98e75f2..ef83b81 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -275,13 +275,16 @@ enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
>  	if (oom_task_origin(task))
>  		return OOM_SCAN_SELECT;
>  
> -	if (task->flags & PF_EXITING && !force_kill) {
> +	if ((task->flags & PF_EXITING || fatal_signal_pending(task)) &&
> +	    !force_kill) {

This makes sense.

>  		/*
>  		 * If this task is not being ptraced on exit, then wait for it
>  		 * to finish before killing some other task unnecessarily.
>  		 */
> -		if (!(task->group_leader->ptrace & PT_TRACE_EXIT))
> +		if (!(task->group_leader->ptrace & PT_TRACE_EXIT)) {
> +			set_tsk_thread_flag(task, TIF_MEMDIE);

This does not, we do not give access to memory reserves unless the process 
needs it to allocate memory.  The task here, which is not current, can 
call into the oom killer and be granted memory reserves if necessary.

>  			return OOM_SCAN_ABORT;
> +		}
>  	}
>  	return OOM_SCAN_OK;
>  }
> @@ -412,16 +415,6 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
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

I think you misunderstood the point of this; if a selected process is 
already in the exit path then this is simply avoiding dumping oom kill 
lines to the kernel log.  We want to keep doing that.

> -
>  	if (__ratelimit(&oom_rs))
>  		dump_header(p, gfp_mask, order, memcg, nodemask);
>  
