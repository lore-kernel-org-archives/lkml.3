Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353Ab3K1Sgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 13:36:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759276Ab3K1Sgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 13:36:36 -0500
Date: Thu, 28 Nov 2013 19:37:02 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Ma, Xindong" <xindong.ma@intel.com>, Sameer Nanda <snanda@chromium.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mhocko@suse.cz" <mhocko@suse.cz>,
        "rientjes@google.com" <rientjes@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Peter Zijlstra'" <peterz@infradead.org>,
        "'gregkh@linuxfoundation.org'" <gregkh@linuxfoundation.org>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>
Subject: Re: [PATCH] Fix race between oom kill and task exit
Message-ID: <20131128183702.GC20740@redhat.com>
References: <3917C05D9F83184EAA45CE249FF1B1DD0253093A@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3917C05D9F83184EAA45CE249FF1B1DD0253093A@SHSMSX103.ccr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28, Ma, Xindong wrote:
>
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

I got lost... didn't we recently discussed the similar patch from Sameer?

This one doesn't look right. find_lock_task_mm() after unlock(tasklist)
can hit the same problem.

I belive the patch from Sameer was correct.

Oleg.

