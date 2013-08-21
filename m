Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab3HURPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 13:15:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab3HURPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 13:15:53 -0400
Date: Wed, 21 Aug 2013 19:09:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
Message-ID: <20130821170927.GA15838@redhat.com>
References: <521313D8.9080500@lab.ntt.co.jp> <20130820084405.GC3258@twins.programming.kicks-ass.net> <52138BE9.5090005@linux.intel.com> <20130820160146.GG3258@twins.programming.kicks-ass.net> <20130820163312.GA17957@redhat.com> <20130820175429.GI3258@twins.programming.kicks-ass.net> <20130820182553.GB22287@redhat.com> <20130821083130.GM3258@twins.programming.kicks-ass.net> <20130821113551.GA1472@redhat.com> <20130821124849.GB31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821124849.GB31370@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21, Peter Zijlstra wrote:
>
> On Wed, Aug 21, 2013 at 01:35:51PM +0200, Oleg Nesterov wrote:
> >
> > Well, the only overhead is "if(to == MAX_SCHEDULE_TIMEOUT)" at the start.
> > I don't think it makes sense to copy-and-paste the identical code to
> > avoid it. But please ignore, this is really minor and off-topic.
>
> Ah, so the 'problem' is that schedule_timeout() doesn't live in
> kernel/sched/core.c and we thus get an extra function call (which are
> somewhat expensive on some archs).

So, unlike me, you like -02 more than -Os ;)

> +static inline long schedule_timeout(long timeout)
> +{
> +	if (timeout == MAX_SCHEDULE_TIMEOUT) {
> +		schedule();
> +		return timeout;
> +	}
> +	return __schedule_timeout(timeout);
> +}

Well this means that every caller will do the MAX_SCHEDULE_TIMEOUT
check inline, and this case is unlikely. And you are also going
to make  schedule_timeout_*() inline...

But,

> +static inline long schedule_timeout_interruptible(long timeout)
> +{
> +	__set_current_state(TASK_INTERRUPTIBLE);
> +	return schedule_timeout(timeout);
> +}
> +static inline long schedule_timeout_killable(long timeout)
> +{
> +	__set_current_state(TASK_KILLABLE);
> +	return schedule_timeout(timeout);
> +}
> +static inline long schedule_timeout_uninterruptible(long timeout)
> +{
> +	__set_current_state(TASK_UNINTERRUPTIBLE);
> +	return schedule_timeout(timeout);
> +}
> ...
> -signed long __sched schedule_timeout_interruptible(signed long timeout)
> -{
> -	__set_current_state(TASK_INTERRUPTIBLE);
> -	return schedule_timeout(timeout);
> -}
> -EXPORT_SYMBOL(schedule_timeout_interruptible);
> -
> -signed long __sched schedule_timeout_killable(signed long timeout)
> -{
> -	__set_current_state(TASK_KILLABLE);
> -	return schedule_timeout(timeout);
> -}
> -EXPORT_SYMBOL(schedule_timeout_killable);
> -
> -signed long __sched schedule_timeout_uninterruptible(signed long timeout)
> -{
> -	__set_current_state(TASK_UNINTERRUPTIBLE);
> -	return schedule_timeout(timeout);
> -}
> -EXPORT_SYMBOL(schedule_timeout_uninterruptible);
> +EXPORT_SYMBOL(__schedule_timeout);

personally I think this particular change is fine.

Or we can export a single schedule_timeout_state(timeout, state) to
factor out get_current().

But just in case, of course I won't argue in any case.

Oleg.

