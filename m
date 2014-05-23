Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292AbaEWN1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 09:27:55 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:55744 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaEWN1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 09:27:54 -0400
Date: Fri, 23 May 2014 15:27:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@kernel.org, tj@kernel.org,
        rusty@rustcorp.com.au, akpm@linux-foundation.org, hch@infradead.org,
        mgorman@suse.de, riel@redhat.com, bp@suse.de, rostedt@goodmis.org,
        mgalbraith@suse.de, ego@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        oleg@redhat.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/3] CPU hotplug, smp: Flush any pending IPI callbacks
 before CPU offline
Message-ID: <20140523132747.GB1768@localhost.localdomain>
References: <20140523101134.17924.31463.stgit@srivatsabhat.in.ibm.com>
 <20140523101229.17924.50256.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140523101229.17924.50256.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 03:42:35PM +0530, Srivatsa S. Bhat wrote:
> During CPU offline, in the stop-machine loop, we use 2 separate stages to
> disable interrupts, to ensure that the CPU going offline doesn't get any new
> IPIs from the other CPUs after it has gone offline.
> 
> However, an IPI sent much earlier might arrive late on the target CPU
> (possibly _after_ the CPU has gone offline) due to hardware latencies,
> and if this happens, then the smp-call-function callbacks queued on the
> outgoing CPU will not get noticed (and hence not executed) at all.
> 
> This is somewhat theoretical, but in any case, it makes sense to explicitly
> loop through the call_single_queue and flush any pending callbacks before the
> CPU goes completely offline. So, perform this step in the CPU_DYING stage of
> CPU offline. That way, we would have handled all the queued callbacks before
> going offline, and also, no new IPIs can be sent by the other CPUs to the
> outgoing CPU at that point, because they will all be executing the stop-machine
> code with interrupts disabled.
> 
> But since the outgoing CPU is already marked offline at this point, we can't
> directly invoke generic_smp_call_function_single_interrupt() from CPU_DYING
> notifier, because it will trigger the "IPI to offline CPU" warning. Hence,
> separate out its functionality into to a new function called
> 'flush_smp_call_function_queue' which skips the "is-cpu-online?" check, and
> call this instead (since we know what we are doing in this path).
> 
> (Aside: 'generic_smp_call_function_single_interrupt' is too long a name already,
> so I didn't want to add an uglier-looking double-underscore prefixed version.
> 'flush_smp_call_function_queue' is a much more meaningful name).
> 
> Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
> 
>  kernel/smp.c |   59 +++++++++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 50 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 306f818..b7a527b 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -29,6 +29,8 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_function_data, cfd_data);
>  
>  static DEFINE_PER_CPU_SHARED_ALIGNED(struct llist_head, call_single_queue);
>  
> +static void flush_smp_call_function_queue(void);
> +
>  static int
>  hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
>  {
> @@ -52,6 +54,18 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
>  	case CPU_UP_CANCELED:
>  	case CPU_UP_CANCELED_FROZEN:
>  
> +	case CPU_DYING:
> +	case CPU_DYING_FROZEN:
> +		/*
> +		 * The IPIs for the smp-call-function callbacks queued by other
> +		 * CPUs might arrive late due to hardware latencies. So flush
> +		 * out any pending IPI callbacks explicitly (without waiting for
> +		 * the IPIs to arrive), to ensure that the outgoing CPU doesn't
> +		 * go offline with work still pending.
> +		 */
> +		flush_smp_call_function_queue();
> +		break;
> +
>  	case CPU_DEAD:
>  	case CPU_DEAD_FROZEN:
>  		free_cpumask_var(cfd->cpumask);
> @@ -177,26 +191,56 @@ static int generic_exec_single(int cpu, struct call_single_data *csd,
>  	return 0;
>  }
>  
> -/*
> - * Invoked by arch to handle an IPI for call function single. Must be
> - * called from the arch with interrupts disabled.
> +/**
> + * flush_smp_call_function_queue - Flush pending smp-call-function callbacks
> + *
> + * Flush any pending smp-call-function callbacks queued on this CPU. This is
> + * invoked by the generic IPI handler, as well as by a CPU about to go offline,
> + * to ensure that all pending IPI functions are run before it goes completely
> + * offline.
> + *
> + * Loop through the call_single_queue and run all the queued functions.
> + * Must be called with interrupts disabled.
>   */
> -void generic_smp_call_function_single_interrupt(void)
> +static void flush_smp_call_function_queue(void)
>  {
>  	struct llist_node *entry;
>  	struct call_single_data *csd, *csd_next;
> -	static bool warned;
>  
>  	entry = llist_del_all(&__get_cpu_var(call_single_queue));
>  	entry = llist_reverse_order(entry);
>  
> +	llist_for_each_entry_safe(csd, csd_next, entry, llist) {
> +		csd->func(csd->info);
> +		csd_unlock(csd);
> +	}
> +}
> +
> +/**
> + * generic_smp_call_function_single_interrupt - Execute SMP IPI callbacks
> + *
> + * Invoked by arch to handle an IPI for call function single.
> + * Must be called with interrupts disabled.
> + */
> +void generic_smp_call_function_single_interrupt(void)
> +{
> +	static bool warned;
> +
> +	WARN_ON(!irqs_disabled());
> +
>  	/*
>  	 * Shouldn't receive this interrupt on a cpu that is not yet online.
>  	 */
>  	if (unlikely(!cpu_online(smp_processor_id()) && !warned)) {
> +		struct llist_node *entry;
> +		struct call_single_data *csd;
> +
>  		warned = true;
>  		WARN(1, "IPI on offline CPU %d\n", smp_processor_id());
>  
> +		entry = llist_del_all(&__get_cpu_var(call_single_queue));

This is deleting all the entries, the call to flush_smp_call_function_queue()
will then miss these.

> +		entry = llist_reverse_order(entry);



> +
>  		/*
>  		 * We don't have to use the _safe() variant here
>  		 * because we are not invoking the IPI handlers yet.
> @@ -206,10 +250,7 @@ void generic_smp_call_function_single_interrupt(void)
>  				csd->func);
>  	}
>  
> -	llist_for_each_entry_safe(csd, csd_next, entry, llist) {
> -		csd->func(csd->info);
> -		csd_unlock(csd);
> -	}
> +	flush_smp_call_function_queue();
>  }
>  
>  /*
> 
