Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab3GAQyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 12:54:04 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:62506 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab3GAQyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 12:54:01 -0400
Date: Mon, 1 Jul 2013 18:53:57 +0200
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
Message-ID: <20130701165355.GP7246@somewhere.redhat.com>
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
> +
> +/*
> + * Check to see if the system is fully idle, other than the timekeeping CPU.
> + * The caller must have disabled interrupts.
> + */
> +bool rcu_sys_is_idle(void)
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

To clarify my worries, I would expect the following ordering:

    CPU 0                                           CPU 1

    cmpxchg(global_state, RCU_SYSIDLE_..., ...)     write rdtp(1)->idle_dynticks
    smp_mb() // implied by cmpxchg                  smp_mb()
    read rdtp(1)-idle_dynticks                      cmpxchg(global_state, RCU_SYSIDLE_NONE)

This example doesn't really make sense because CPU 0 only wants to change global state after
checking rdtp(1)->idle_dynticks. So we obviously want the other way around as you did. But then
I can't find an ordering that makes sure that only either happens:

* CPU 0 sees CPU 1 update when it wakes up and so we reset to RCU_SYSIDLE_NONE from CPU 0
* CPU 1 wakes up and reset to RCU_SYSIDLE_NONE and sends an IPI to CPU 0

I mean that's what the code does, but I don't get the ordering that guarantees we can't
fall into some intermediate state when CPU 0 sees CPU 1 idle whereas it already woke up without
sending the IPI.

I'm sure you'll point me to my mistaken review :)


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
