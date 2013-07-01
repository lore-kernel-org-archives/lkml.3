Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab3GAVij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 17:38:39 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:47392 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab3GAVii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 17:38:38 -0400
Date: Mon, 1 Jul 2013 23:38:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full v2 6/7] nohz_full: Add full-system-idle
 state machine
Message-ID: <20130701213832.GR7246@somewhere.redhat.com>
References: <20130628200949.GA17458@linux.vnet.ibm.com>
 <1372450222-19420-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1372450222-19420-6-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372450222-19420-6-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 01:10:21PM -0700, Paul E. McKenney wrote:
> +/*
> + * Check to see if the system is fully idle, other than the timekeeping CPU.
> + * The caller must have disabled interrupts.
> + */
> +bool rcu_sys_is_idle(void)

Where is this function called? I can't find any caller in the patchset.

> +{
> +	static struct rcu_sysidle_head rsh;
> +	int rss = ACCESS_ONCE(full_sysidle_state);
> +
> +	WARN_ON_ONCE(smp_processor_id() != tick_do_timer_cpu);
> +
> +	/* Handle small-system case by doing a full scan of CPUs. */
> +	if (nr_cpu_ids <= RCU_SYSIDLE_SMALL && rss < RCU_SYSIDLE_FULL) {
> +		int cpu;
> +		bool isidle = true;
> +		unsigned long maxj = jiffies - ULONG_MAX / 4;
> +		struct rcu_data *rdp;
> +
> +		/* Scan all the CPUs looking for nonidle CPUs. */
> +		for_each_possible_cpu(cpu) {
> +			rdp = per_cpu_ptr(rcu_sysidle_state->rda, cpu);
> +			rcu_sysidle_check_cpu(rdp, &isidle, &maxj);
> +			if (!isidle)
> +				break;
> +		}
> +		rcu_sysidle_report(rcu_sysidle_state, isidle, maxj);
> +		rss = ACCESS_ONCE(full_sysidle_state);
> +	}
> +
> +	/* If this is the first observation of an idle period, record it. */
> +	if (rss == RCU_SYSIDLE_FULL) {
> +		rss = cmpxchg(&full_sysidle_state,
> +			      RCU_SYSIDLE_FULL, RCU_SYSIDLE_FULL_NOTED);
> +		return rss == RCU_SYSIDLE_FULL;
> +	}
> +
> +	smp_mb(); /* ensure rss load happens before later caller actions. */
> +
> +	/* If already fully idle, tell the caller (in case of races). */
> +	if (rss == RCU_SYSIDLE_FULL_NOTED)
> +		return true;
> +
> +	/*
> +	 * If we aren't there yet, and a grace period is not in flight,
> +	 * initiate a grace period.  Either way, tell the caller that
> +	 * we are not there yet.
> +	 */
> +	if (nr_cpu_ids > RCU_SYSIDLE_SMALL &&
> +	    !rcu_gp_in_progress(rcu_sysidle_state) &&
> +	    !rsh.inuse && xchg(&rsh.inuse, 1) == 0)
> +		call_rcu(&rsh.rh, rcu_sysidle_cb);

So this starts an RCU/RCU_preempt grace period to force the global idle
detection.

Would it make sense to create a new RCU flavour instead for this purpose?
Its only per CPU quiescent state would be when the timekeeping CPU ticks
(from rcu_check_callbacks()). The other CPUs would only complete their
QS request through extended quiescent states, ie: only the timekeeping
CPU is burdened.

This way you can enqueue a callback that is executed in the end of the
grace period for that flavour and that callback can help driving the
state machine somehow.

Now may be that's not a good idea because this adds some overhead to
any code that uses for_each_rcu_flavour().


> +	return false;
>  }
>  
>  /*
> @@ -2494,6 +2734,21 @@ static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq)
>  {
>  }
>  
> +static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
> +				  unsigned long *maxj)
> +{
> +}
> +
> +static bool is_sysidle_rcu_state(struct rcu_state *rsp)
> +{
> +	return false;
> +}
> +
> +static void rcu_sysidle_report(struct rcu_state *rsp, int isidle,
> +			       unsigned long maxj)
> +{
> +}
> +
>  static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
>  {
>  }
> -- 
> 1.8.1.5
> 
