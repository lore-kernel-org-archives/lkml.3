Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbaJBJHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 05:07:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:55416 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaJBJHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 05:07:48 -0400
Date: Thu, 2 Oct 2014 11:07:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, tglx@linutronix.de,
        ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/11] sched: Debug nested sleeps
Message-ID: <20141002090745.GC3003@worktop.programming.kicks-ass.net>
References: <20140924081845.572814794@infradead.org>
 <20140924082242.591637616@infradead.org>
 <20140929221344.GB12112@redhat.com>
 <20140930134928.GF4241@worktop.programming.kicks-ass.net>
 <20140930214732.GA31384@redhat.com>
 <20141001161058.GE2843@worktop.programming.kicks-ass.net>
 <20141001183549.GA3382@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141001183549.GA3382@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 08:35:49PM +0200, Oleg Nesterov wrote:
> On 10/01, Peter Zijlstra wrote:
> > Sure, so the trivial problem is not actually going to sleep in the outer
> > wait primitive because the inner wait primitive reset ->state to
> > TASK_RUNNING.
> 
> But this means that fixup_sleep() must not be used?

Right, in case its an actual bug, we'll not use fixup_sleep(). Those are
only used to annotate the few odd cases.

> > So by always setting the ->state to TASK_RUNNING it never goes to sleep
> > and it'll revert to spinning,
> 
> But I tried to suggest to not set TASK_RUNNING?

That's what I understood, because that's the difference between
CONFIG_DEBUG_ATOMIC_SLEEP and not. Or I made a complete mess of things,
which could well have happened, I had a terrible headache yesterday.

> Peter, I am sorry for wasting your time, this is really minor, but still
> I'd like to understand.
> 
> Let me try again. With this series we have
> 
> 	#ifdef CONFIG_DEBUG_ATOMIC_SLEEP
> 	#define fixup_sleep()	__set_current_state(TASK_RUNNING)
> 	#else
> 	#define fixup_sleep()	do { } while (0)
> 	#endif
> 
> and this means that we do not need __set_current_state(RUNNING) for
> correctness, just we want to shut up the warning in __might_sleep().
> This is fine (and the self-documenting helper is nice), but this means
> that CONFIG_DEBUG_ATOMIC_SLEEP adds a subtle difference.
> 
> For example, let's suppose that we do not have 01/11 which fixes
> mutex_lock(). Then this code
> 
> 	set_current_state(TASK_UNINTERRUPTIBLE);
> 	...
> 	fixup_sleep();
> 	...
> 	mutex_lock(some_mutex);
> 
> can hang, but only if !CONFIG_DEBUG_ATOMIC_SLEEP.

Right, but we should not use fixup_sleep() in this case, because its an
actual proper bug, we should fix it, not paper over it. Arguably we
should use preempt_schedule in mutex_lock() in that particular case, but
that's another discussion.

> So perhaps it makes sense to redefine it
> 
> 	#ifdef CONFIG_DEBUG_ATOMIC_SLEEP
> 	#define fixup_sleep()	(current->task_state_change = 0)
> 	#else
> 	#define fixup_sleep()	do { } while (0)
> 	#endif
> 
> and change __might_sleep()
> 
> 	-	if (WARN(current->state != TASK_RUNNING,
> 	+	if (WARN(current->state != TASK_RUNNING && current->task_state_change != 0,
> 
> ?

So I'm hesitant to go that way because it adds extra state dependency.
What if someone 'forgets' to use the *set*state() helpers.
