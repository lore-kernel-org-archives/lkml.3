Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbaJASjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:39:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085AbaJASjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:39:12 -0400
Date: Wed, 1 Oct 2014 20:35:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, tglx@linutronix.de,
        ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/11] sched: Debug nested sleeps
Message-ID: <20141001183549.GA3382@redhat.com>
References: <20140924081845.572814794@infradead.org> <20140924082242.591637616@infradead.org> <20140929221344.GB12112@redhat.com> <20140930134928.GF4241@worktop.programming.kicks-ass.net> <20140930214732.GA31384@redhat.com> <20141001161058.GE2843@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141001161058.GE2843@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01, Peter Zijlstra wrote:
>
> On Tue, Sep 30, 2014 at 11:47:32PM +0200, Oleg Nesterov wrote:
>
> > > > This is minor, but this way CONFIG_DEBUG_ATOMIC_SLEEP will not imply
> > > > a subtle behavioural change.
> > >
> > > You mean the __set_current_state() that's extra?
> >
> > Yes, and note that it only does __set_current_state(RUNNING) if
> > CONFIG_DEBUG_ATOMIC_SLEEP. This means that disabling/enabling this
> > option can, silently hide/uncover a bug.
> >
> > > I would actually argue
> > > to keep that since it makes the 'problem' much worse.
> >
> > OK, I won't insist, but could you explain why the suggested change can
> > make the problem (and which problem ;) worse?
>
> Sure, so the trivial problem is not actually going to sleep in the outer
> wait primitive because the inner wait primitive reset ->state to
> TASK_RUNNING.

But this means that fixup_sleep() must not be used?

> So by always setting the ->state to TASK_RUNNING it never goes to sleep
> and it'll revert to spinning,

But I tried to suggest to not set TASK_RUNNING?


Peter, I am sorry for wasting your time, this is really minor, but still
I'd like to understand.

Let me try again. With this series we have

	#ifdef CONFIG_DEBUG_ATOMIC_SLEEP
	#define fixup_sleep()	__set_current_state(TASK_RUNNING)
	#else
	#define fixup_sleep()	do { } while (0)
	#endif

and this means that we do not need __set_current_state(RUNNING) for
correctness, just we want to shut up the warning in __might_sleep().
This is fine (and the self-documenting helper is nice), but this means
that CONFIG_DEBUG_ATOMIC_SLEEP adds a subtle difference.

For example, let's suppose that we do not have 01/11 which fixes
mutex_lock(). Then this code

	set_current_state(TASK_UNINTERRUPTIBLE);
	...
	fixup_sleep();
	...
	mutex_lock(some_mutex);

can hang, but only if !CONFIG_DEBUG_ATOMIC_SLEEP.

So perhaps it makes sense to redefine it

	#ifdef CONFIG_DEBUG_ATOMIC_SLEEP
	#define fixup_sleep()	(current->task_state_change = 0)
	#else
	#define fixup_sleep()	do { } while (0)
	#endif

and change __might_sleep()

	-	if (WARN(current->state != TASK_RUNNING,
	+	if (WARN(current->state != TASK_RUNNING && current->task_state_change != 0,

?

Oleg.

