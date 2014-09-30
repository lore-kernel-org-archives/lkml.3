Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbaI3VvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:51:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbaI3Vu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:50:58 -0400
Date: Tue, 30 Sep 2014 23:47:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, tglx@linutronix.de,
        ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/11] sched: Debug nested sleeps
Message-ID: <20140930214732.GA31384@redhat.com>
References: <20140924081845.572814794@infradead.org> <20140924082242.591637616@infradead.org> <20140929221344.GB12112@redhat.com> <20140930134928.GF4241@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930134928.GF4241@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30, Peter Zijlstra wrote:
>
> On Tue, Sep 30, 2014 at 12:13:44AM +0200, Oleg Nesterov wrote:
> > On 09/24, Peter Zijlstra wrote:
> > >
> > > +#ifdef CONFIG_DEBUG_ATOMIC_SLEEP
> > > +
> > > +#define __set_task_state(tsk, state_value)			\
> > > +	do {							\
> > > +		(tsk)->task_state_change = _THIS_IP_;		\
> > > +		(tsk)->state = (state_value);			\
> > > +	} while (0)
> >
> > ...
> >
> > > @@ -7143,6 +7143,19 @@ void __might_sleep(const char *file, int
> > >  {
> > >  	static unsigned long prev_jiffy;	/* ratelimiting */
> > >
> > > +	/*
> > > +	 * Blocking primitives will set (and therefore destroy) current->state,
> > > +	 * since we will exit with TASK_RUNNING make sure we enter with it,
> > > +	 * otherwise we will destroy state.
> > > +	 */
> > > +	if (WARN(current->state != TASK_RUNNING,
> > > +			"do not call blocking ops when !TASK_RUNNING; "
> > > +			"state=%lx set at [<%p>] %pS\n",
> > > +			current->state,
> > > +			(void *)current->task_state_change,
> > > +			(void *)current->task_state_change))
> > > +		__set_current_state(TASK_RUNNING);
> >
> > Question: now that we have ->task_state_change, perhaps it makes sense
> > to redefine fixup_sleep()
> >
> > 	#ifdef CONFIG_DEBUG_ATOMIC_SLEEP
> > 	#define fixup_sleep()	(current->task_state_change = 0)
> > 	#else
> > 	#define fixup_sleep()	do { } while (0)
> > 	#endif
> >
> > and make the WARN() above depend on task_state_change != 0 ?
> >
> > This is minor, but this way CONFIG_DEBUG_ATOMIC_SLEEP will not imply
> > a subtle behavioural change.
>
> You mean the __set_current_state() that's extra?

Yes, and note that it only does __set_current_state(RUNNING) if
CONFIG_DEBUG_ATOMIC_SLEEP. This means that disabling/enabling this
option can, silently hide/uncover a bug.

> I would actually argue
> to keep that since it makes the 'problem' much worse.

OK, I won't insist, but could you explain why the suggested change can
make the problem (and which problem ;) worse?

Oleg.

