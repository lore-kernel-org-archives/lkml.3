Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab3I3V5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 17:57:07 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:48313 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859Ab3I3V5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 17:57:06 -0400
Date: Mon, 30 Sep 2013 14:57:02 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
cc: akpm@linux-foundation.org, oleg@redhat.com, security@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: kthread: Make kthread_create() killable.
In-Reply-To: <201309281618.JAG82364.VFMtSOOQOLFHJF@I-love.SAKURA.ne.jp>
Message-ID: <alpine.DEB.2.02.1309301441270.28109@chino.kir.corp.google.com>
References: <20130923160725.49093c565dcf6df7037dcc6b@linux-foundation.org> <201309250017.HBG57846.VFOStOFFOLQJHM@I-love.SAKURA.ne.jp> <alpine.DEB.2.02.1309251351001.27471@chino.kir.corp.google.com> <201309261159.BHB18780.OHLFQFMOOJSVtF@I-love.SAKURA.ne.jp>
 <alpine.DEB.2.02.1309261149050.10904@chino.kir.corp.google.com> <201309281618.JAG82364.VFMtSOOQOLFHJF@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Sep 2013, Tetsuo Handa wrote:

> Some of enterprise users might prefer "kernel panic followed by kdump and
> automatic reboot" to "a system is not responding for unpredictable period", for
> the panic helps getting information for analyzing what process caused the
> freeze. Well, can they use "Panic (Reboot) On Soft Lockups" option?
> 

Or, when the system doesn't respond for a long period of time you do 
sysrq+T and you find the TIF_MEMDIE bit set on a process that makes no 
progress exiting.  These instances _should_ be very rare since we don't 
have any other reports of it (and the oom killer hasn't differed in this 
regard for over three years).  It used to be much more common for 
mm->mmap_sem dependencies that were fixed.

> Currently the OOM killer kills a process after
> 
>   blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
> 
> in out_of_memory() released all reclaimable memory.

The oom notifiers usually don't do any good on x86.

> This call helps reducing
> the chance to kill a process if the bad process no longer asks for more memory.

The "bad process" could be anything, it's simply the process that is 
allocating memory when all memory is exhausted.

> But if the bad process continues asking for more memory and the chosen task is
> in TASK_UNINTERRUPTIBLE state, this call helps the OOM killer to be disabled
> for unpredictable period. Therefore, releasing all reclaimable memory before
> the OOM killer kills a process might be considered bad.
> 

I don't follow this statement, could you reword it?

If current calls the oom killer and the oom notifiers don't free any 
memory (which is very likely), then choosing an uninterruptible process is 
possible and has always been possible.  If sending SIGKILL and giving that 
process access to memory reserves does not allow it to exit in a short 
amount of time, then it must be waiting on another process that also 
cannot make forward process.  We must identify these cases (which is 
easily doable as described above) and fix them.

> Then, what about an approach described below?
> 
> (1) Introduce a kernel thread which reserves (e.g.) 1 percent of kernel memory
>     (this amount should be configurable via sysctl) upon startup.
> 

We don't need kernel threads, this is what per-zone memory reserves are 
intended to provide for GFP_ATOMIC and TIF_MEMDIE allocations (or 
PF_MEMALLOC for reclaimers).

> (2) The kernel thread sleeps using wait_event(memory_reservoir_wait) and
>     releases PAGE_SIZE bytes from the reserved memory upon each wakeup.
> 
> (3) The OOM killer calls wake_up() like
> 
>      	if (test_tsk_thread_flag(task, TIF_MEMDIE)) {
>      		if (unlikely(frozen(task)))
>      			__thaw_task(task);
>     +		/* Let the memory reservoir release memory if the chosen process cannot die. */
>     +		if (time_after(jiffies, p->memdie_stamp) &&
>     +		    task->state == TASK_UNINTERRUPTIBLE)
>     +		        wake_up(&memory_reservoir_wait);
>      		if (!force_kill)
>      			return OOM_SCAN_ABORT;
>      	}
> 
>     in oom_scan_process_thread().
> 

This doesn't guarantee that the process that the chosen process is waiting 
for will be able to allocate that page, so it's useless.

> (4) When a task where test_tsk_thread_flag(task, TIF_MEMDIE) is true has
>     terminated and memory used by the task is reclaimed, the reclaimed memory
>     is again reserved by the kernel thread up to 1 percent of kernel memory.
> 
> In this way, we could shorten the duration of the OOM killer being disabled
> unless the reserved memory was not enough to terminate the chosen process.
> 

Could you please describe and post the details of any case where this 
currently happens so we can address the problem directly instead of trying 
to workaround it?
