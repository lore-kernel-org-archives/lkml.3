Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab3I1QiT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 12:38:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265Ab3I1QiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 12:38:15 -0400
Date: Sat, 28 Sep 2013 18:31:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH] hotplug: Optimize {get,put}_online_cpus()
Message-ID: <20130928163104.GA23352@redhat.com>
References: <20130925175055.GA25914@redhat.com> <20130925184015.GC3657@laptop.programming.kicks-ass.net> <20130925212200.GA7959@linux.vnet.ibm.com> <20130926111042.GS3081@twins.programming.kicks-ass.net> <20130926165840.GA863@redhat.com> <20130926175016.GI3657@laptop.programming.kicks-ass.net> <20130927181532.GA8401@redhat.com> <20130927204116.GJ15690@laptop.programming.kicks-ass.net> <20130928124859.GA13425@redhat.com> <20130928144720.GL15690@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130928144720.GL15690@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28, Peter Zijlstra wrote:
>
> On Sat, Sep 28, 2013 at 02:48:59PM +0200, Oleg Nesterov wrote:
>
> > Please note that this wait_event() adds a problem... it doesn't allow
> > to "offload" the final synchronize_sched(). Suppose a 4k cpu machine
> > does disable_nonboot_cpus(), we do not want 2 * 4k * synchronize_sched's
> > in this case. We can solve this, but this wait_event() complicates
> > the problem.
>
> That seems like a particularly easy fix; something like so?

Yes, but...

> @@ -586,6 +603,11 @@ int disable_nonboot_cpus(void)
>
> +	cpu_hotplug_done();
> +
> +	for_each_cpu(cpu, frozen_cpus)
> +		cpu_notify_nofail(CPU_POST_DEAD_FROZEN, (void*)(long)cpu);

This changes the protocol, I simply do not know if it is fine in general
to do __cpu_down(another_cpu) without CPU_POST_DEAD(previous_cpu). Say,
currently it is possible that CPU_DOWN_PREPARE takes some global lock
released by CPU_DOWN_FAILED or CPU_POST_DEAD.

Hmm. Now that workqueues do not use CPU_POST_DEAD, it has only 2 users,
mce_cpu_callback() and cpufreq_cpu_callback() and the 1st one even ignores
this notification if FROZEN. So yes, probably this is fine, but needs an
ack from cpufreq maintainers (cc'ed), for example to ensure that it is
fine to call __cpufreq_remove_dev_prepare() twice without _finish().

Oleg.

