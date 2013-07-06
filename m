Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab3GFGNK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 02:13:10 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:47627 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab3GFGNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 02:13:08 -0400
Date: Sat, 6 Jul 2013 14:12:05 +0800
From: Wang YanQing <udknight@gmail.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: xiaoguangrong@cn.fujitsu.com, mingo@elte.hu, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, npiggin@suse.de,
        deepthi@linux.vnet.ibm.com, peterz@infradead.org,
        rusty@rustcorp.com.au, heiko.carstens@de.ibm.com, rostedt@goodmis.org,
        miltonm@bga.com, srivatsa.bhat@linux.vnet.ibm.com,
        jens.axboe@oracle.com, tj@kernel.org, akpm@linux-foundation.org,
        svaidy@linux.vnet.ibm.com, shli@kernel.org, tglx@linutronix.de,
        lig.fnst@cn.fujitsu.com, anton@samba.org
Subject: Re: [PATCH 2/3] smp/ipi:Clarify ambiguous comments around deadlock
 scenarios in smp_call_function variants.
Message-ID: <20130706061205.GA3518@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Preeti U Murthy <preeti@linux.vnet.ibm.com>,
	xiaoguangrong@cn.fujitsu.com, mingo@elte.hu,
	paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
	a.p.zijlstra@chello.nl, npiggin@suse.de, deepthi@linux.vnet.ibm.com,
	peterz@infradead.org, rusty@rustcorp.com.au,
	heiko.carstens@de.ibm.com, rostedt@goodmis.org, miltonm@bga.com,
	srivatsa.bhat@linux.vnet.ibm.com, jens.axboe@oracle.com,
	tj@kernel.org, akpm@linux-foundation.org, svaidy@linux.vnet.ibm.com,
	shli@kernel.org, tglx@linutronix.de, lig.fnst@cn.fujitsu.com,
	anton@samba.org
References: <20130705162548.16888.18957.stgit@preeti.in.ibm.com>
 <20130705162711.16888.30274.stgit@preeti.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130705162711.16888.30274.stgit@preeti.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 09:57:11PM +0530, Preeti U Murthy wrote:
> Elaborate on when deadlocks can occur when a call is made to
> smp_call_function_single() and its friends. This avoids ambiguity about
> when to use these calls.
> 
> Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> Cc: srivatsa.bhat@linux.vnet.ibm.com
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au
> ---
> 
>  kernel/smp.c |   46 ++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 44 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 89be6e6..b6981ae 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -230,7 +230,23 @@ int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
>  	this_cpu = get_cpu();
>  
>  	/*
> -	 * Can deadlock when called with interrupts disabled.
> +	 * Can deadlock when called with interrupts disabled under two
> +	 * different circumstances depending on the wait parameter.
> +	 *
> +	 * 1. wait = 1: Two CPUs execute smp_call_function_single(), send an
> +	 * IPI to each other, and wait for func to finish on each other.
> +	 * Since they are interrupt disabled, neither receives this IPI,
> +	 * nor do they proceed forward,as they wait for each other to complete
> +	 * execution of func.
> +	 *

Yes, we should avoid this situation, but I am not sure whether this is 
the meaning of "deadlock" in the original comment.

> +	 * 2. wait = 0: This function could be called from an interrupt
> +	 * context, and can get blocked on the csd_lock(csd) below in
> +	 * "non wait cases".
> +	 * This is because the percpu copy of csd of this_cpu is used
> +	 * in non wait cases. Under such circumstances, if the previous caller
> +	 * of this function who got preempted by this interrupt has already taken
> +	 * the lock under non wait condition, it will result in deadlock.
> +	 *

No, it will not cause deadlock, it is not mutex lock,  it is busy wait, so
when the CSD_FLAG_LOCK be cleared, the code will go on running.

After stare into the kernel/smp.c, I can't catch what the exactly meaning
of the "DeadLock" in the original comment also.

I hope someone can clarify it.

Thanks.

