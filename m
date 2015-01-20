Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbbATNWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:22:16 -0500
Received: from www.linutronix.de ([62.245.132.108]:48746 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbbATNWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:22:15 -0500
Date: Tue, 20 Jan 2015 14:21:51 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Calvin Owens <calvinowens@fb.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] ksoftirqd: Enable IRQs and call cond_resched() before
 poking RCU
In-Reply-To: <20150113211618.GA21498@mail.thefacebook.com>
Message-ID: <alpine.DEB.2.11.1501201419550.5526@nanos>
References: <1420594659-16996-1-git-send-email-calvinowens@fb.com> <20150107014906.GA27996@mail.thefacebook.com> <20150107021926.GT5280@linux.vnet.ibm.com> <20150107165223.GA21555@linux.vnet.ibm.com> <20150108043329.GB27996@mail.thefacebook.com>
 <20150108045306.GJ5280@linux.vnet.ibm.com> <20150108214644.GC27996@mail.thefacebook.com> <alpine.DEB.2.11.1501131215380.5526@nanos> <20150113184301.GO9719@linux.vnet.ibm.com> <20150113211618.GA21498@mail.thefacebook.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2015, Calvin Owens wrote:

> While debugging an issue with excessive softirq usage, I encountered the
> following note in commit 3e339b5dae24a706 ("softirq: Use hotplug thread
> infrastructure"):
> 
>     [ paulmck: Call rcu_note_context_switch() with interrupts enabled. ]
> 
> ...but despite this note, the patch still calls RCU with IRQs disabled.
> 
> This seemingly innocuous change caused a significant regression in softirq
> CPU usage on the sending side of a large TCP transfer (~1 GB/s): when
> introducing 0.01% packet loss, the softirq usage would jump to around 25%,
> spiking as high as 50%. Before the change, the usage would never exceed 5%.
> 
> Moving the call to rcu_note_context_switch() after the cond_sched() call,
> as it was originally before the hotplug patch, completely eliminated this
> problem.
> 
> Signed-off-by: Calvin Owens <calvinowens@fb.com>
> Cc: stable@vger.kernel.org
> ---
> This version includes the "cpu" argument to rcu_note_context_switch() in
> order to apply cleanly to stable kernels. It will need to be removed to
> apply to 3.18+ and 3.19 (upstream commit 38200cf2 removed the argument).
> 
>  kernel/softirq.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index 501baa9..9e787d8 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -656,9 +656,13 @@ static void run_ksoftirqd(unsigned int cpu)
>  		 * in the task stack here.
>  		 */
>  		__do_softirq();
> -		rcu_note_context_switch(cpu);
>  		local_irq_enable();
>  		cond_resched();
> +
> +		preempt_disable();
> +		rcu_note_context_switch(cpu);
> +		preempt_enable();
> +

The whole rcu_note_context_switch() in run_ksoftirqd() is silly.

    cond_resched()
	__preempt_count_add(PREEMPT_ACTIVE);

	__schedule();
	     preempt_disable();
	     rcu_note_context_switch();
	     ....

	__preempt_count_sub(PREEMPT_ACTIVE);

Thanks,

	tglx
