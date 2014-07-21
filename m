Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933464AbaGUSQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 14:16:43 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:40932 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933199AbaGUSQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 14:16:42 -0400
Date: Mon, 21 Jul 2014 11:16:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 01/10] irq_work: Introduce void irq work
Message-ID: <20140721181637.GK8690@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1405730661-9355-1-git-send-email-fweisbec@gmail.com>
 <1405730661-9355-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405730661-9355-2-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072118-6688-0000-0000-00000374B93C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 02:44:12AM +0200, Frederic Weisbecker wrote:
> Being able to trigger an empty IPI appears to be useless in the first
> place. Yet it is expected to be very useful for callers who just need
> to execute irq_enter() or irq_exit() to a remote target.
> 
> More precisely this is going to be useful for the nohz subsystem which
> often needs a remote CPU to reschedule its tick when some state changed
> and require periodicity for any reason. Similar cases have been handled
> with random IPIs until now. But they surely bring unwanted overhead
> all along since they are all dedicated for specific tasks.
> 
> Triggering an irq work/smp_call_function IPI should be enough to solve
> that. If competing and spurious IPIs become a problem, we can still
> optimize that later.
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
>  include/linux/irq_work.h |  1 +
>  kernel/irq_work.c        | 21 +++++++++++++++++++++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
> index bf9422c..b2ad065 100644
> --- a/include/linux/irq_work.h
> +++ b/include/linux/irq_work.h
> @@ -36,6 +36,7 @@ bool irq_work_queue(struct irq_work *work);
> 
>  #ifdef CONFIG_SMP
>  bool irq_work_queue_on(struct irq_work *work, int cpu);
> +void irq_work_void_on(int cpu);
>  #endif
> 
>  void irq_work_run(void);
> diff --git a/kernel/irq_work.c b/kernel/irq_work.c
> index 4b0a890..36b7fb2 100644
> --- a/kernel/irq_work.c
> +++ b/kernel/irq_work.c
> @@ -81,6 +81,27 @@ bool irq_work_queue_on(struct irq_work *work, int cpu)
>  	return true;
>  }
>  EXPORT_SYMBOL_GPL(irq_work_queue_on);
> +
> +/**
> + * irq_work_void_on(): Run a void IRQ on the target
> + * @cpu: The cpu to run the IRQ on
> + *
> + * Run a void IRQ for its own sake on the target. It's generally
> + * useful for callers which want to run irq_enter() or irq_exit()
> + * on a remote CPU.
> + */
> +void irq_work_void_on(int cpu)
> +{
> +	/*
> +	 * NOTE: we could optimize that and spare some IPIs
> +	 * after checking that raised_list isn't empty before raising.
> +	 * This can't be done properly without cmpxchg() though so
> +	 * it may make things worse after all. But lets leave that
> +	 * possibility open in case people report such issue in the
> +	 * future.
> +	 */
> +	arch_send_call_function_single_ipi(cpu);
> +}
>  #endif
> 
>  /* Enqueue the irq work @work on the current CPU */
> -- 
> 1.8.3.1
> 

