Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab3F1IeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 04:34:16 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:43132 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab3F1IeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 04:34:13 -0400
Message-ID: <51CD4A7B.7060907@redhat.com>
Date: Fri, 28 Jun 2013 10:34:03 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm-devel <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Karen Noel <knoel@redhat.com>, Rik van Riel <riel@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: watchdog: print stolen time increment at softlockup detection
References: <20130628025723.GA12719@amt.cnet>
In-Reply-To: <20130628025723.GA12719@amt.cnet>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 28/06/2013 04:57, Marcelo Tosatti ha scritto:
> 
> One possibility for a softlockup report in a Linux VM, is that the host
> system is overcommitted to the point where the watchdog task is unable
> to make progress (unable to touch the watchdog).
> 
> Maintain the increment in stolen time for the period of 
> softlockup threshold detection (20 seconds by the default), 
> and report this increment in the softlockup message.
> 
> Overcommitment is then indicated by a large stolen time increment,
> accounting for more than, or for a significant percentage of the
> softlockup threshold.
> 
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 05039e3..ed09d58 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -34,6 +34,8 @@ int __read_mostly watchdog_thresh = 10;
>  static int __read_mostly watchdog_disabled;
>  static u64 __read_mostly sample_period;
>  
> +#define SOFT_INTRS_PER_PERIOD 5
> +
>  static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
>  static DEFINE_PER_CPU(struct task_struct *, softlockup_watchdog);
>  static DEFINE_PER_CPU(struct hrtimer, watchdog_hrtimer);
> @@ -127,9 +129,51 @@ static void set_sample_period(void)
>  	 * and hard thresholds) to increment before the
>  	 * hardlockup detector generates a warning
>  	 */
> -	sample_period = get_softlockup_thresh() * ((u64)NSEC_PER_SEC / 5);
> +	sample_period = get_softlockup_thresh() *
> +			((u64)NSEC_PER_SEC / SOFT_INTRS_PER_PERIOD);
>  }
>  
> +#ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
> +struct steal_clock_record {
> +	u64 prev_stolen_time;
> +	u64 stolen_time[SOFT_INTRS_PER_PERIOD];
> +	int idx;
> +};
> +
> +static DEFINE_PER_CPU(struct steal_clock_record, steal_record);
> +static void record_steal_time(void)
> +{
> +	struct steal_clock_record *r;
> +	int cpu = smp_processor_id();
> +	u64 steal_time;
> +	r = &per_cpu(steal_record, cpu);
> +
> +	steal_time = paravirt_steal_clock(cpu);
> +	r->stolen_time[r->idx] = steal_time - r->prev_stolen_time;
> +	r->idx++;
> +	if (r->idx == SOFT_INTRS_PER_PERIOD)
> +		r->idx = 0;
> +	r->prev_stolen_time = steal_time;
> +}
> +
> +static unsigned int get_accumulated_steal(int cpu)
> +{
> +	int idx;
> +	u64 t = 0;
> +	struct steal_clock_record *r = &per_cpu(steal_record, cpu);
> +
> +	for (idx = 0; idx < SOFT_INTRS_PER_PERIOD; idx++)
> +		t += r->stolen_time[idx];
> +
> +	do_div(t, 1000000);
> +
> +	return t;
> +}
> +
> +#else
> +static void record_steal_time(void) { return; }
> +#endif
> +
>  /* Commands for resetting the watchdog */
>  static void __touch_watchdog(void)
>  {
> @@ -271,6 +315,9 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
>  	/* kick the hardlockup detector */
>  	watchdog_interrupt_count();
>  
> +	/* record steal time */
> +	record_steal_time();
> +
>  	/* kick the softlockup detector */
>  	wake_up_process(__this_cpu_read(softlockup_watchdog));
>  
> @@ -316,6 +363,10 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
>  		printk(KERN_EMERG "BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
>  			smp_processor_id(), duration,
>  			current->comm, task_pid_nr(current));
> +#ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
> +		printk(KERN_EMERG "soft lockup stolen time = %ums\n",
> +			get_accumulated_steal(smp_processor_id()));

Perhaps print this only if nonzero (so that it doesn't print it on bare
metal)?  Then you can remove the #ifdef too, it will be optimized away
by the compiler for !CONFIG_PARAVIRT_TIME_ACCOUNTING.

Paolo

> +#endif
>  		print_modules();
>  		print_irqtrace_events(current);
>  		if (regs)
> 

