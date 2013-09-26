Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab3IZRF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 13:05:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab3IZRF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 13:05:56 -0400
Date: Thu, 26 Sep 2013 18:58:40 +0200
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
Message-ID: <20130926165840.GA863@redhat.com>
References: <20130921163404.GA8545@redhat.com> <20130923092955.GV9326@twins.programming.kicks-ass.net> <20130923173203.GA20392@redhat.com> <20130924202423.GW12926@twins.programming.kicks-ass.net> <20130925155515.GA17447@redhat.com> <20130925174307.GA3220@laptop.programming.kicks-ass.net> <20130925175055.GA25914@redhat.com> <20130925184015.GC3657@laptop.programming.kicks-ass.net> <20130925212200.GA7959@linux.vnet.ibm.com> <20130926111042.GS3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130926111042.GS3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

Sorry. Unlikely I will be able to read this patch today. So let me
ask another potentially wrong question without any thinking.

On 09/26, Peter Zijlstra wrote:
>
> +void __get_online_cpus(void)
> +{
> +again:
> +	/* See __srcu_read_lock() */
> +	__this_cpu_inc(__cpuhp_refcount);
> +	smp_mb(); /* A matches B, E */
> +	__this_cpu_inc(cpuhp_seq);
> +
> +	if (unlikely(__cpuhp_state == readers_block)) {

OK. Either we should see state = BLOCK or the writer should notice the
change in __cpuhp_refcount/seq. (altough I'd like to recheck this
cpuhp_seq logic ;)

> +		atomic_inc(&cpuhp_waitcount);
> +		__put_online_cpus();

OK, this does wake(cpuhp_writer).

>  void cpu_hotplug_begin(void)
>  {
> ...
> +	/*
> +	 * Notify new readers to block; up until now, and thus throughout the
> +	 * longish synchronize_sched() above, new readers could still come in.
> +	 */
> +	__cpuhp_state = readers_block;
> +
> +	smp_mb(); /* E matches A */
> +
> +	/*
> +	 * If they don't see our writer of readers_block to __cpuhp_state,
> +	 * then we are guaranteed to see their __cpuhp_refcount increment, and
> +	 * therefore will wait for them.
> +	 */
> +
> +	/* Wait for all now active readers to complete. */
> +	wait_event(cpuhp_writer, cpuhp_readers_active_check());

But. doesn't this mean that we need __wait_event() here as well?

Isn't it possible that the reader sees BLOCK but the writer does _not_
see the change in __cpuhp_refcount/cpuhp_seq? Those mb's guarantee
"either", not "both".

Don't we need to ensure that we can't check cpuhp_readers_active_check()
after wake(cpuhp_writer) was already called by the reader and before we
take the same lock?

Oleg.

