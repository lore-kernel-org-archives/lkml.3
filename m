Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaAORDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 12:03:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbaAORDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:03:52 -0500
Date: Wed, 15 Jan 2014 18:03:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/timers 2/4] timers: Reduce __run_timers()
	latency for empty list
Message-ID: <20140115170310.GB11499@redhat.com>
References: <20140115051939.GA31164@linux.vnet.ibm.com> <1389763248-31297-1-git-send-email-paulmck@linux.vnet.ibm.com> <1389763248-31297-2-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389763248-31297-2-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14, Paul E. McKenney wrote:
>
> The __run_timers() function currently steps through the list one jiffy at
> a time

And this is very suboptimal if jiffies - timer_jiffies is huge. Looks
like, we should rework base->tv* structures, or (perhaps) optimize
the "cascade" logic so that __run_timers() can increment timer_jiffies
and move all the expired timers into work_list at one step. And the
->next_timer logic is obviously very suboptimal.

But this is almost off-topic, I agree that in the short term these
changes make sense.

> +static bool catchup_timer_jiffies(struct tvec_base *base)
> +{
> +#ifdef CONFIG_NO_HZ_FULL
> +	if (!base->all_timers) {
> +		base->timer_jiffies = jiffies;
> +		return 1;
> +	}
> +#endif /* #ifdef CONFIG_NO_HZ_FULL */
> +	return 0;
> +}
> +
>  static void
>  __internal_add_timer(struct tvec_base *base, struct timer_list *timer)
>  {
> @@ -1150,6 +1161,10 @@ static inline void __run_timers(struct tvec_base *base)
>  	struct timer_list *timer;
>  
>  	spin_lock_irq(&base->lock);
> +	if (catchup_timer_jiffies(base)) {
> +		spin_unlock_irq(&base->lock);
> +		return;
> +	}


This is really minor, but perhaps it would be better to modify
run_timer_softirq() to call catchup_timer_jiffies() lockless along
with another fast-path time_after_eq() check.

Better yet, it would be nice to avoid raise_softirq(TIMER_SOFTIRQ),
but this is not simple due to hrtimer_run_pending().

Oleg.

