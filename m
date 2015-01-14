Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbbANWMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 17:12:36 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:59598 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbbANWMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 17:12:35 -0500
Date: Wed, 14 Jan 2015 14:12:28 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Calvin Owens <calvinowens@fb.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] ksoftirqd: Enable IRQs and call cond_resched() before
 poking RCU
Message-ID: <20150114221228.GV9719@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1420594659-16996-1-git-send-email-calvinowens@fb.com>
 <20150107014906.GA27996@mail.thefacebook.com>
 <20150107021926.GT5280@linux.vnet.ibm.com>
 <20150107165223.GA21555@linux.vnet.ibm.com>
 <20150108043329.GB27996@mail.thefacebook.com>
 <20150108045306.GJ5280@linux.vnet.ibm.com>
 <20150108214644.GC27996@mail.thefacebook.com>
 <alpine.DEB.2.11.1501131215380.5526@nanos>
 <20150113184301.GO9719@linux.vnet.ibm.com>
 <20150113211618.GA21498@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150113211618.GA21498@mail.thefacebook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011422-0009-0000-0000-000007FE486D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 01:16:18PM -0800, Calvin Owens wrote:
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

Applied, thank you!  I deleted the "cpu" arguments from the calls to
rcu_note_context_switch() below in order for the patch to apply.

I the put the patch following that on top, as Thomas suggested.

							Thanx, Paul

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
>  		return;
>  	}
>  	local_irq_enable();
> -- 
> 2.1.1

------------------------------------------------------------------------

ksoftirqd: Use new cond_resched_rcu_qs() function

Simplify run_ksoftirqd() by using the new cond_resched_rcu_qs() function
that conditionally reschedules, but unconditionally supplies an RCU
quiescent state.  This commit is separate from the previous commit by
Calvin Owens because Calvin's approach can be backported, while this
commit cannot be.  The reason that this commit cannot be backported is
that cond_resched_rcu_qs() does not always provide the needed quiescent
state in earlier kernels.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/softirq.c b/kernel/softirq.c
index c497fcdf0d1e..8cdb98847c7b 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -657,12 +657,7 @@ static void run_ksoftirqd(unsigned int cpu)
 		 */
 		__do_softirq();
 		local_irq_enable();
-		cond_resched();
-
-		preempt_disable();
-		rcu_note_context_switch();
-		preempt_enable();
-
+		cond_resched_rcu_qs();
 		return;
 	}
 	local_irq_enable();

