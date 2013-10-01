Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab3JANVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 09:21:12 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:56572 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab3JANVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 09:21:10 -0400
X-Nat-Received: from [202.181.97.72]:55362 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1380633654.6285
To: rientjes@google.com
Cc: akpm@linux-foundation.org, oleg@redhat.com, security@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: kthread: Make kthread_create() killable.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <alpine.DEB.2.02.1309251351001.27471@chino.kir.corp.google.com>
	<201309261159.BHB18780.OHLFQFMOOJSVtF@I-love.SAKURA.ne.jp>
	<alpine.DEB.2.02.1309261149050.10904@chino.kir.corp.google.com>
	<201309281618.JAG82364.VFMtSOOQOLFHJF@I-love.SAKURA.ne.jp>
	<alpine.DEB.2.02.1309301441270.28109@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1309301441270.28109@chino.kir.corp.google.com>
Message-Id: <201310012220.EIE35417.HFOQLFSFMJOtOV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 1 Oct 2013 22:20:51 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 01102013 #11149554, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Sat, 28 Sep 2013, Tetsuo Handa wrote:
> 
> > Some of enterprise users might prefer "kernel panic followed by kdump and
> > automatic reboot" to "a system is not responding for unpredictable period", for
> > the panic helps getting information for analyzing what process caused the
> > freeze. Well, can they use "Panic (Reboot) On Soft Lockups" option?
> > 
> 
> Or, when the system doesn't respond for a long period of time you do 
> sysrq+T and you find the TIF_MEMDIE bit set on a process that makes no 
> progress exiting.

In enterprise systems, an operator is not always sitting in front of the server
for pressing sysrq keys (nor kept ssh session for issuing sysrq via procfs).
The operator likely finds it many hours later after the system got frozen. The
operator finds that he/she can't login, and presses power reset button.
Rather than wasting for many hours, an unattended automatic reboot might be
preferred.

>                    These instances _should_ be very rare since we don't 
> have any other reports of it (and the oom killer hasn't differed in this 
> regard for over three years).  It used to be much more common for 
> mm->mmap_sem dependencies that were fixed.
> 

Such reports in real world might be rare, but I care potential bugs which can
affect availability of the server.

If local unprivileged users can execute their own programs, they can easily
freeze the server. Therefore, I test whether such freeze can happen using DoS
attacking programs executed by local unprivileged users. I confirmed that
request_module() can easily freeze the server and the request_module() case was
fixed as CVE-2012-4398. I confirmed that kthread_create() can freeze the server
(though not easy to trigger but can happen by chance) and posted a patch in
this thread.

> > Currently the OOM killer kills a process after
> > 
> >   blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
> > 
> > in out_of_memory() released all reclaimable memory.
> 
> The oom notifiers usually don't do any good on x86.
> 
> > This call helps reducing
> > the chance to kill a process if the bad process no longer asks for more memory.
> 
> The "bad process" could be anything, it's simply the process that is 
> allocating memory when all memory is exhausted.
> 

I'm using "bad process" as what you mean.

> > But if the bad process continues asking for more memory and the chosen task is
> > in TASK_UNINTERRUPTIBLE state, this call helps the OOM killer to be disabled
> > for unpredictable period. Therefore, releasing all reclaimable memory before
> > the OOM killer kills a process might be considered bad.
> > 
> 
> I don't follow this statement, could you reword it?
> 
> If current calls the oom killer and the oom notifiers don't free any 
> memory (which is very likely), then choosing an uninterruptible process is 
> possible and has always been possible.

Yes, this does happen if a local unprivileged user who can execute his/her own
program consumed a lots of memory.

>                                         If sending SIGKILL and giving that 
> process access to memory reserves does not allow it to exit in a short 
> amount of time, then it must be waiting on another process that also 
> cannot make forward process.

Yes. kthread_create(), do_coredump() and call_usermodehelper_keys() are
examples of such cases which I think I can trigger deadlock using DoS attacking
programs executed by local unprivileged users.

>                               We must identify these cases (which is 
> easily doable as described above) and fix them.
> 

I'm not expecting that we identify all possible cases, for any blocking
functions which wait in TASK_UNINTERRUPTIBLE are candidates for such cases.
This is as problematic as GFP_NOFS allocation functions calling other functions
which do GFP_KERNEL allocation.

> > Then, what about an approach described below?
> > 
> > (1) Introduce a kernel thread which reserves (e.g.) 1 percent of kernel memory
> >     (this amount should be configurable via sysctl) upon startup.
> > 
> 
> We don't need kernel threads, this is what per-zone memory reserves are 
> intended to provide for GFP_ATOMIC and TIF_MEMDIE allocations (or 
> PF_MEMALLOC for reclaimers).
> 

I know some amount of memory is reserved for GFP_ATOMIC/TIF_MEMDIE allocations.
What I'm talking about is GFP_KERNEL allocating processes which are preventing
TIF_MEMDIE process from terminating due to TASK_UNINTERRUPTIBLE wait.

> > (2) The kernel thread sleeps using wait_event(memory_reservoir_wait) and
> >     releases PAGE_SIZE bytes from the reserved memory upon each wakeup.
> > 
> > (3) The OOM killer calls wake_up() like
> > 
> >      	if (test_tsk_thread_flag(task, TIF_MEMDIE)) {
> >      		if (unlikely(frozen(task)))
> >      			__thaw_task(task);
> >     +		/* Let the memory reservoir release memory if the chosen process cannot die. */
> >     +		if (time_after(jiffies, p->memdie_stamp) &&
> >     +		    task->state == TASK_UNINTERRUPTIBLE)
> >     +		        wake_up(&memory_reservoir_wait);
> >      		if (!force_kill)
> >      			return OOM_SCAN_ABORT;
> >      	}
> > 
> >     in oom_scan_process_thread().
> > 
> 
> This doesn't guarantee that the process that the chosen process is waiting 
> for will be able to allocate that page, so it's useless.
> 

I don't think this is completely useless.

The chosen process was marked as TIF_MEMDIE because the process was consuming
most memory, but it does not mean that the process marked as TIF_MEMDIE itself
needs more memory. The process marked as TIF_MEMDIE may be simply waiting at
kthread_create() etc. where other process which is not marked as TIF_MEMDIE
depends on more memory.

Even if the process marked as TIF_MEMDIE is allowed to access reserved memory,
the process which really wants memory may not be marked as TIF_MEMDIE.
To be able to give the process which really wants memory chance to allocate
memory, memory pool via kernel thread might help.

> > (4) When a task where test_tsk_thread_flag(task, TIF_MEMDIE) is true has
> >     terminated and memory used by the task is reclaimed, the reclaimed memory
> >     is again reserved by the kernel thread up to 1 percent of kernel memory.
> > 
> > In this way, we could shorten the duration of the OOM killer being disabled
> > unless the reserved memory was not enough to terminate the chosen process.
> > 
> 
> Could you please describe and post the details of any case where this 
> currently happens so we can address the problem directly instead of trying 
> to workaround it?
> 

Even if the process marked as TIF_MEMDIE can access per-zone memory reserves,
that does not help if the process which really needs memory (in order to
terminate the process marked as TIF_MEMDIE) cannot access per-zone memory
reserves.

If (e.g.) the caller of kthread_create() was marked as TIF_MEMDIE but the
kthreadd cannot allocate memory which is needed for terminating the caller of
kthread_create(), the system freezes. We can make kthread_create() killable
because it is not too difficult to fix.

Some of such dependency (e.g. kthread_create()) can be addressed directly, but
it is too hard to address all directly. Thus, I propose memory reserving thread
as a workaround.
