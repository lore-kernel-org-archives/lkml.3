Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab3IXQjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 12:39:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10972 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab3IXQjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 12:39:31 -0400
X-Authority-Analysis: v=2.0 cv=R/aB6KtX c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=6uerBSPhkSsA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=rzOjJkEkrDcA:10 a=JfrnYn6hAAAA:8 a=p2WlpnJhAAAA:8 a=frjPX2c0mNUQaoDGwlgA:9 a=CjuIK1q_8ugA:10 a=3Rfx1nUSh_UA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 24 Sep 2013 12:39:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] hotplug: Optimize {get,put}_online_cpus()
Message-ID: <20130924123927.32da5c1e@gandalf.local.home>
In-Reply-To: <20130924123821.GT12926@twins.programming.kicks-ass.net>
References: <1378805550-29949-1-git-send-email-mgorman@suse.de>
	<1378805550-29949-38-git-send-email-mgorman@suse.de>
	<20130917143003.GA29354@twins.programming.kicks-ass.net>
	<20130917162050.GK22421@suse.de>
	<20130917164505.GG12926@twins.programming.kicks-ass.net>
	<20130918154939.GZ26785@twins.programming.kicks-ass.net>
	<20130919143241.GB26785@twins.programming.kicks-ass.net>
	<20130923175052.GA20991@redhat.com>
	<20130924123821.GT12926@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Sep 2013 14:38:21 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> +#define cpuhp_writer_wait(cond)						\
> +do {									\
> +	for (;;) {							\
> +		set_current_state(TASK_UNINTERRUPTIBLE);		\
> +		if (cond)						\
> +			break;						\
> +		schedule();						\
> +	}								\
> +	__set_current_state(TASK_RUNNING);				\
> +} while (0)
> +
> +void __get_online_cpus(void)

The above really needs a comment about how it is used. Otherwise, I can
envision someone calling this as "oh I can use this when I'm in a
preempt disable section", and the comment below for the
preempt_enable_no_resched() will no longer be true.

-- Steve


>  {
> -	if (cpu_hotplug.active_writer == current)
> +	if (cpuhp_writer_task == current)
>  		return;
> -	mutex_lock(&cpu_hotplug.lock);
>  
> -	if (WARN_ON(!cpu_hotplug.refcount))
> -		cpu_hotplug.refcount++; /* try to fix things up */
> +	atomic_inc(&cpuhp_waitcount);
> +
> +	/*
> +	 * We either call schedule() in the wait, or we'll fall through
> +	 * and reschedule on the preempt_enable() in get_online_cpus().
> +	 */
> +	preempt_enable_no_resched();
> +	wait_event(cpuhp_wq, !__cpuhp_writer);
> +	preempt_disable();
> +
> +	/*
> +	 * It would be possible for cpu_hotplug_done() to complete before
> +	 * the atomic_inc() above; in which case there is no writer waiting
> +	 * and doing a wakeup would be BAD (tm).
> +	 *
> +	 * If however we still observe cpuhp_writer_task here we know
> +	 * cpu_hotplug_done() is currently stuck waiting for cpuhp_waitcount.
> +	 */
> +	if (atomic_dec_and_test(&cpuhp_waitcount) && cpuhp_writer_task)
> +		cpuhp_writer_wake();
> +}
> +EXPORT_SYMBOL_GPL(__get_online_cpus);
>  
