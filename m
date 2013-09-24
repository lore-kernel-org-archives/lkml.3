Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab3IXQi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 12:38:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570Ab3IXQiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 12:38:55 -0400
Date: Tue, 24 Sep 2013 18:31:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] hotplug: Optimize {get,put}_online_cpus()
Message-ID: <20130924163146.GA3777@redhat.com>
References: <1378805550-29949-38-git-send-email-mgorman@suse.de> <20130917143003.GA29354@twins.programming.kicks-ass.net> <20130917162050.GK22421@suse.de> <20130917164505.GG12926@twins.programming.kicks-ass.net> <20130918154939.GZ26785@twins.programming.kicks-ass.net> <20130919143241.GB26785@twins.programming.kicks-ass.net> <20130923175052.GA20991@redhat.com> <20130924123821.GT12926@twins.programming.kicks-ass.net> <20130924144236.GB9093@linux.vnet.ibm.com> <20130924160959.GO9326@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130924160959.GO9326@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24, Peter Zijlstra wrote:
>
> +void __get_online_cpus(void)
>  {
> -	if (cpu_hotplug.active_writer == current)
> +	/* Support reader-in-writer recursion */
> +	if (__cpuhp_writer == current)
>  		return;
> -	mutex_lock(&cpu_hotplug.lock);
>  
> -	if (WARN_ON(!cpu_hotplug.refcount))
> -		cpu_hotplug.refcount++; /* try to fix things up */
> +	atomic_inc(&cpuhp_waitcount);
>  
> -	if (!--cpu_hotplug.refcount && unlikely(cpu_hotplug.active_writer))
> -		wake_up_process(cpu_hotplug.active_writer);
> -	mutex_unlock(&cpu_hotplug.lock);
> +	/*
> +	 * We either call schedule() in the wait, or we'll fall through
> +	 * and reschedule on the preempt_enable() in get_online_cpus().
> +	 */
> +	preempt_enable_no_resched();
> +	wait_event(cpuhp_readers, !__cpuhp_writer);
> +	preempt_disable();
> +
> +	if (atomic_dec_and_test(&cpuhp_waitcount))
> +		wake_up_all(&cpuhp_writer);

Yes, this should fix the races with the exiting writer, but still this
doesn't look right afaics.

In particular let me repeat,

>  void cpu_hotplug_begin(void)
>  {
> -	cpu_hotplug.active_writer = current;
> +	unsigned int count = 0;
> +	int cpu;
> +
> +	lockdep_assert_held(&cpu_add_remove_lock);
>  
> -	for (;;) {
> -		mutex_lock(&cpu_hotplug.lock);
> -		if (likely(!cpu_hotplug.refcount))
> -			break;
> -		__set_current_state(TASK_UNINTERRUPTIBLE);
> -		mutex_unlock(&cpu_hotplug.lock);
> -		schedule();
> +	__cpuhp_writer = current;
> +
> +	/* 
> +	 * After this everybody will observe writer and take the slow path.
> +	 */
> +	synchronize_sched();

synchronize_sched() is slow. The new readers will likely notice
__cpuhp_writer != NULL much earlier and they will be blocked in
__get_online_cpus() while the writer sleeps before it actually
enters the critical section.

Or I completely misunderstood this all?

Oleg.

