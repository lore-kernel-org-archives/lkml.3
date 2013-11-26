Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093Ab3KZOYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 09:24:45 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54493 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab3KZOYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 09:24:44 -0500
Message-ID: <5294AF27.8080605@gmail.com>
Date: Tue, 26 Nov 2013 15:24:39 +0100
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizefan@huawei.com>,
        Tejun Heo <tj@kernel.org>
CC: John Stultz <john.stultz@linaro.org>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] cpuset: Fix memory allocator deadlock
References: <20131126140341.GL10022@twins.programming.kicks-ass.net>
In-Reply-To: <20131126140341.GL10022@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 03:03 PM, Peter Zijlstra wrote:
> Juri hit the below lockdep report:
> 
> [    4.303391] ======================================================
> [    4.303392] [ INFO: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected ]
> [    4.303394] 3.12.0-dl-peterz+ #144 Not tainted
> [    4.303395] ------------------------------------------------------
> [    4.303397] kworker/u4:3/689 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
> [    4.303399]  (&p->mems_allowed_seq){+.+...}, at: [<ffffffff8114e63c>] new_slab+0x6c/0x290
> [    4.303417]
> [    4.303417] and this task is already holding:
> [    4.303418]  (&(&q->__queue_lock)->rlock){..-...}, at: [<ffffffff812d2dfb>] blk_execute_rq_nowait+0x5b/0x100
> [    4.303431] which would create a new lock dependency:
> [    4.303432]  (&(&q->__queue_lock)->rlock){..-...} -> (&p->mems_allowed_seq){+.+...}
> [    4.303436]
> 
> [    4.303898] the dependencies between the lock to be acquired and SOFTIRQ-irq-unsafe lock:
> [    4.303918] -> (&p->mems_allowed_seq){+.+...} ops: 2762 {
> [    4.303922]    HARDIRQ-ON-W at:
> [    4.303923]                     [<ffffffff8108ab9a>] __lock_acquire+0x65a/0x1ff0
> [    4.303926]                     [<ffffffff8108cbe3>] lock_acquire+0x93/0x140
> [    4.303929]                     [<ffffffff81063dd6>] kthreadd+0x86/0x180
> [    4.303931]                     [<ffffffff816ded6c>] ret_from_fork+0x7c/0xb0
> [    4.303933]    SOFTIRQ-ON-W at:
> [    4.303933]                     [<ffffffff8108abcc>] __lock_acquire+0x68c/0x1ff0
> [    4.303935]                     [<ffffffff8108cbe3>] lock_acquire+0x93/0x140
> [    4.303940]                     [<ffffffff81063dd6>] kthreadd+0x86/0x180
> [    4.303955]                     [<ffffffff816ded6c>] ret_from_fork+0x7c/0xb0
> [    4.303959]    INITIAL USE at:
> [    4.303960]                    [<ffffffff8108a884>] __lock_acquire+0x344/0x1ff0
> [    4.303963]                    [<ffffffff8108cbe3>] lock_acquire+0x93/0x140
> [    4.303966]                    [<ffffffff81063dd6>] kthreadd+0x86/0x180
> [    4.303969]                    [<ffffffff816ded6c>] ret_from_fork+0x7c/0xb0
> [    4.303972]  }
> 
> Which reports that we take mems_allowed_seq with interrupts enabled. A
> little digging found that this can only be from
> cpuset_change_task_nodemask().
> 
> This is an actual deadlock because an interrupt doing an allocation will
> hit get_mems_allowed()->...->__read_seqcount_begin(), which will spin
> forever waiting for the write side to complete.
> 

And this patch fixes it, thanks!

> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Reported-by: Juri Lelli <juri.lelli@gmail.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

Tested-by: Juri Lelli <juri.lelli@gmail.com>

Best,

- Juri

> ---
>  kernel/cpuset.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 6bf981e13c43..4772034b4b17 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -1033,8 +1033,10 @@ static void cpuset_change_task_nodemask(struct task_struct *tsk,
>  	need_loop = task_has_mempolicy(tsk) ||
>  			!nodes_intersects(*newmems, tsk->mems_allowed);
>  
> -	if (need_loop)
> +	if (need_loop) {
> +		local_irq_disable();
>  		write_seqcount_begin(&tsk->mems_allowed_seq);
> +	}
>  
>  	nodes_or(tsk->mems_allowed, tsk->mems_allowed, *newmems);
>  	mpol_rebind_task(tsk, newmems, MPOL_REBIND_STEP1);
> @@ -1042,8 +1044,10 @@ static void cpuset_change_task_nodemask(struct task_struct *tsk,
>  	mpol_rebind_task(tsk, newmems, MPOL_REBIND_STEP2);
>  	tsk->mems_allowed = *newmems;
>  
> -	if (need_loop)
> +	if (need_loop) {
>  		write_seqcount_end(&tsk->mems_allowed_seq);
> +		local_irq_enable();
> +	}
>  
>  	task_unlock(tsk);
>  }
> 
