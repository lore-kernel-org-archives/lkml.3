Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab3IZSxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:53:53 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:50714 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471Ab3IZSxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:53:48 -0400
Date: Thu, 26 Sep 2013 11:53:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
cc: akpm@linux-foundation.org, oleg@redhat.com, security@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] kthread: Make kthread_create() killable.
In-Reply-To: <201309261159.BHB18780.OHLFQFMOOJSVtF@I-love.SAKURA.ne.jp>
Message-ID: <alpine.DEB.2.02.1309261149050.10904@chino.kir.corp.google.com>
References: <20130915163919.GC13344@redhat.com> <201309160953.IGI12418.FOQHOFVJLOMFSt@I-love.SAKURA.ne.jp> <20130923160725.49093c565dcf6df7037dcc6b@linux-foundation.org> <201309250017.HBG57846.VFOStOFFOLQJHM@I-love.SAKURA.ne.jp>
 <alpine.DEB.2.02.1309251351001.27471@chino.kir.corp.google.com> <201309261159.BHB18780.OHLFQFMOOJSVtF@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Sep 2013, Tetsuo Handa wrote:

> > wait_for_completion() is scary if that completion requires memory that 
> > cannot be allocated because the caller is killed but uninterruptible.
> 
> I don't think these lines are specific to wait_for_completion() users.
> 
> Currently the OOM killer is disabled throughout from "the moment the OOM killer
> chose a process to kill" to "the moment the task_struct of the chosen process
> becomes unreachable". Any blocking functions which wait in TASK_UNINTERRUPTIBLE
> (e.g. mutex_lock()) can disable the OOM killer if the current thread is chosen
> by the OOM killer. Therefore, any users of blocking functions which wait in
> TASK_UNINTERRUPTIBLE are considered scary if they assume that the current
> thread will not be chosen by the OOM killer.
> 

Yeah, that's always been true.

> But it seems to me that re-enabling the OOM killer at some point is more
> realizable than purging all such users.
> 
> To re-enable the OOM killer at some point, the OOM killer needs to choose more
> processes if the to-be-killed process cannot be terminated within an adequate
> period.
> 
> For example, add "unsigned long memdie_stamp;" to "struct task_struct" and do
> "p->memdie_stamp = jiffies + 5 * HZ;" before "set_tsk_thread_flag(p, TIF_MEMDIE);"
> and do
> 
>  	if (test_tsk_thread_flag(task, TIF_MEMDIE)) {
>  		if (unlikely(frozen(task)))
>  			__thaw_task(task);
> +		/* Choose more processes if the chosen process cannot die. */
> +		if (time_after(jiffies, p->memdie_stamp) &&
> +		    task->state == TASK_UNINTERRUPTIBLE)
> +		        return OOM_SCAN_CONTINUE;
>  		if (!force_kill)
>  			return OOM_SCAN_ABORT;
>  	}
> 
> in oom_scan_process_thread().
> 

There may not be any eligible processes left and then the machine panics.  
These time-based delays also have caused a complete depletion of memory 
reserves if more than one process is chosen and each consumes an 
non-neglible amount of memory which would then cause livelock.  We used to 
have a jiffies-based rekill in 2.6.18 internally and we finally could 
remove it when mm->mmap_sem issues were fixed (mostly by checking for 
fatal_signal_pending() and aborting when necessary).

> [PATCH v3] kthread: Make kthread_create() killable.
> 
> Any user process callers of wait_for_completion() except global init process
> might be chosen by the OOM killer while waiting for completion() call by some
> other process which does memory allocation.
> 
> When such users are chosen by the OOM killer when they are waiting for
> completion() in TASK_UNINTERRUPTIBLE, the system will be kept stressed
> due to memory starvation because the OOM killer cannot kill such users.
> 
> kthread_create() is one of such users and this patch fixes the problem for
> kthreadd by making kthread_create() killable.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Acked-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Absolutely, thanks.
