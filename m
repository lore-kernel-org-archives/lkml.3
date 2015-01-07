Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbbAGCTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:19:36 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:49609 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922AbbAGCTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:19:32 -0500
Date: Tue, 6 Jan 2015 18:19:26 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Calvin Owens <calvinowens@fb.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2] ksoftirqd: Enable IRQs and call cond_resched() before
 poking RCU
Message-ID: <20150107021926.GT5280@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1420594659-16996-1-git-send-email-calvinowens@fb.com>
 <20150107014906.GA27996@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150107014906.GA27996@mail.thefacebook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010702-0025-0000-0000-0000078CF496
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 05:49:06PM -0800, Calvin Owens wrote:
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
> ---
> Changes since v1:
> 	I mixed up the kernel versions I was patching against, sorry!
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
> -		rcu_note_context_switch();
>  		local_irq_enable();
>  		cond_resched();

If this is for 3.20, we can just replace cond_resched() with
cond_resched_rcu_qs(), and get rid of the direct call to
rcu_note_context_switch().  This has the benefit of avoiding
needless rcu_note_context_switch() overhead if cond_resched()
actually did a reschedule.

But don't try it in 3.19 or earlier.  ;-)

							Thanx, Paul

> +
> +		preempt_disable();
> +		rcu_note_context_switch();
> +		preempt_enable();
> +
>  		return;
>  	}
>  	local_irq_enable();
> -- 
> 2.1.1
> 

