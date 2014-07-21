Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448AbaGUSQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 14:16:19 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:48941 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933240AbaGUSQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 14:16:18 -0400
Date: Mon, 21 Jul 2014 11:16:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 03/10] rcu: Kick full dynticks CPU on extended grace
 period with a void IRQ
Message-ID: <20140721181612.GJ8690@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1405730661-9355-1-git-send-email-fweisbec@gmail.com>
 <1405730661-9355-4-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405730661-9355-4-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072118-1542-0000-0000-000003716C29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 02:44:14AM +0200, Frederic Weisbecker wrote:
> When a full dynticks CPU stays for too long in the kernel, it may fail
> to report quiescent states due to it missing ticks and therefore it can
> delay the completion of grace periods.
> 
> A way to solve this is to send an IPI to the incriminated CPU such that
> it can check rcu_needs_cpu() and reschedule some ticks accordingly to
> poll again on quiescent states reports.
> 
> This is what we try to achieve while calling rcu_kick_nohz_cpu() but it
> has no effect because we trigger a scheduler IPI which is actually a
> no-op when not used for scheduler internal purpose, ie: it doesn't call
> irq_exit() when not used for remote wakeup or other specifics.
> 
> No need to tweak the scheduler IPI further though. Lets keep it clean
> of external noise and use an empty IPI instead. We hereby get sure that
> we will call irq_exit() on the target without much overhead nor added
> noise on scheduler fast path.
> 
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  kernel/rcu/tree_plugin.h | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index cbc2c45..395c14d 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -2401,14 +2401,16 @@ static bool init_nocb_callback_list(struct rcu_data *rdp)
>   * off.  RCU will be paying attention to this CPU because it is in the
>   * kernel, but the CPU cannot be guaranteed to be executing the RCU state
>   * machine because the scheduling-clock tick has been disabled.  Therefore,
> - * if an adaptive-ticks CPU is failing to respond to the current grace
> - * period and has not be idle from an RCU perspective, kick it.
> + * if an full dynticks CPU is failing to respond to the current grace
> + * period and has not be idle from an RCU perspective, kick it with a
> + * void IRQ so that it can check that RCU needs its tick from rcu_needs_cpu()
> + * on irq exit.
>   */
>  static void rcu_kick_nohz_cpu(int cpu)
>  {
>  #ifdef CONFIG_NO_HZ_FULL
>  	if (tick_nohz_full_cpu(cpu))
> -		smp_send_reschedule(cpu);
> +		irq_work_void_on(cpu);
>  #endif /* #ifdef CONFIG_NO_HZ_FULL */
>  }
> 
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

