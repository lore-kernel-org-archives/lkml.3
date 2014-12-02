Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbaLBJff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 04:35:35 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:58082 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaLBJfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 04:35:33 -0500
Date: Tue, 2 Dec 2014 10:35:30 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] oom: kill the insufficient and no longer needed
 PT_TRACE_EXIT check
Message-ID: <20141202093530.GC27014@dhcp22.suse.cz>
References: <20141127230349.GA25075@redhat.com>
 <20141127230408.GA25100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141127230408.GA25100@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 28-11-14 00:04:08, Oleg Nesterov wrote:
> After the previous patch we can remove the PT_TRACE_EXIT check in
> oom_scan_process_thread(), it was added to handle the case when the
> coredumping was "frozen" by ptrace, but it doesn't really work. If
> nothing else, we would need to check all threads which could share
> the same ->mm to make it more or less correct.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

I still do not see why we do not need task->ptrace & PT_TRACE_EXIT check
here. I do understand that the check on group_leader doesn't make much
sense. ptrace_event would block until the tracer let the task run again
which may be never AFAICS.

It is really sad how subtle and racy are all these checks :/

> ---
>  mm/oom_kill.c |   11 +++--------
>  1 files changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 7af33b5..a2a4036 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -287,14 +287,9 @@ enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
>  	if (oom_task_origin(task))
>  		return OOM_SCAN_SELECT;
>  
> -	if (task_will_free_mem(task) && !force_kill) {
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
> -- 
> 1.5.5.1
> 

-- 
Michal Hocko
SUSE Labs
