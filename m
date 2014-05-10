Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaEJDGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 23:06:41 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:58216 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaEJDGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 23:06:40 -0400
Date: Fri, 9 May 2014 23:06:35 -0400
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, peterz@infradead.org,
        tglx@linutronix.de, mingo@kernel.org, rusty@rustcorp.com.au,
        fweisbec@gmail.com, hch@infradead.org, mgorman@suse.de,
        riel@redhat.com, bp@suse.de, rostedt@goodmis.org, mgalbraith@suse.de,
        ego@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com, oleg@redhat.com,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] CPU hotplug, stop-machine: Plug race-window that
 leads to "IPI-to-offline-CPU"
Message-ID: <20140510030635.GC22539@mtj.dyndns.org>
References: <20140506180213.14375.5904.stgit@srivatsabhat.in.ibm.com>
 <20140506180258.14375.20181.stgit@srivatsabhat.in.ibm.com>
 <20140506134054.8cd531296c8aa5d9c3eff958@linux-foundation.org>
 <20140506204248.GH27738@htj.dyndns.org>
 <536953C4.8030201@linux.vnet.ibm.com>
 <53695BCF.5040504@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53695BCF.5040504@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 03:31:51AM +0530, Srivatsa S. Bhat wrote:
> diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
> index 01fbae5..7abb361 100644
> --- a/kernel/stop_machine.c
> +++ b/kernel/stop_machine.c
> @@ -165,12 +165,13 @@ static void ack_state(struct multi_stop_data *msdata)
>  		set_state(msdata, msdata->state + 1);
>  }
>  
> +

Why add a new line here?

>  /* This is the cpu_stop function which stops the CPU. */
>  static int multi_cpu_stop(void *data)
>  {
>  	struct multi_stop_data *msdata = data;
>  	enum multi_stop_state curstate = MULTI_STOP_NONE;
> -	int cpu = smp_processor_id(), err = 0;
> +	int cpu = smp_processor_id(), num_active_cpus, err = 0;

	TYPE var0 = INIT0, var1, var2 = INIT2;

looks kinda weird.  Maybe collect initialized ones to one side or
separate out uninitialized one to a separate declaration?

Also, isn't nr_active_cpus more common way of naming it?

>  	unsigned long flags;
>  	bool is_active;
>  
> @@ -180,15 +181,38 @@ static int multi_cpu_stop(void *data)
>  	 */
>  	local_save_flags(flags);
>  
> -	if (!msdata->active_cpus)
> +	if (!msdata->active_cpus) {
>  		is_active = cpu == cpumask_first(cpu_online_mask);
> -	else
> +		num_active_cpus = 1;
> +	} else {
>  		is_active = cpumask_test_cpu(cpu, msdata->active_cpus);
> +		num_active_cpus = cpumask_weight(msdata->active_cpus);
> +	}
>  
>  	/* Simple state machine */
>  	do {
>  		/* Chill out and ensure we re-read multi_stop_state. */
>  		cpu_relax();
> +
> +		/*
> +		 * In the case of CPU offline, we don't want the other CPUs to
> +		 * send IPIs to the active_cpu (the one going offline) after it
> +		 * has entered the _DISABLE_IRQ state (because, then it will
> +		 * notice the IPIs only after it goes offline). So ensure that
> +		 * the active_cpu always follows the others while entering
> +		 * each subsequent state in this state-machine.
> +		 *
> +		 * msdata->thread_ack tracks the number of CPUs that are yet to
> +		 * move to the next state, during each transition. So make the
> +		 * active_cpu(s) wait until ->thread_ack indicates that the
> +		 * active_cpus are the only ones left to complete the transition.
> +		 */
> +		if (is_active) {
> +			/* Wait until all the non-active threads ack the state */
> +			while (atomic_read(&msdata->thread_ack) > num_active_cpus)
> +				cpu_relax();
> +		}

Wouldn't it be cleaner to separate this out to a separate stage so
that there are two separate DISABLE_IRQ stages - sth like
MULTI_STOP_DISABLE_IRQ_INACTIVE and MULTI_STOP_DISABLE_IRQ_ACTIVE?
The above adds an ad-hoc mechanism on top of the existing mechanism
which is built to sequence similar things anyway.

Thanks.

-- 
tejun
