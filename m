Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaJBVhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 17:37:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbaJBVhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 17:37:54 -0400
Date: Thu, 2 Oct 2014 23:34:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, tglx@linutronix.de,
        ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/11] sched: Debug nested sleeps
Message-ID: <20141002213425.GB12446@redhat.com>
References: <20140924081845.572814794@infradead.org> <20140924082242.591637616@infradead.org> <20140929221344.GB12112@redhat.com> <20140930134928.GF4241@worktop.programming.kicks-ass.net> <20140930214732.GA31384@redhat.com> <20141001161058.GE2843@worktop.programming.kicks-ass.net> <20141001183549.GA3382@redhat.com> <20141002090745.GC3003@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141002090745.GC3003@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02, Peter Zijlstra wrote:
>
> On Wed, Oct 01, 2014 at 08:35:49PM +0200, Oleg Nesterov wrote:
> >
> > For example, let's suppose that we do not have 01/11 which fixes
> > mutex_lock(). Then this code
> >
> > 	set_current_state(TASK_UNINTERRUPTIBLE);
> > 	...
> > 	fixup_sleep();
> > 	...
> > 	mutex_lock(some_mutex);
> >
> > can hang, but only if !CONFIG_DEBUG_ATOMIC_SLEEP.
>
> Right, but we should not use fixup_sleep() in this case,

(well, I am not really sure but this is off-topic and I agree this needs
 another discussion)

> because its an
> actual proper bug, we should fix it, not paper over it.

Exactly! this is what I meant: CONFIG_DEBUG_ATOMIC_SLEEP will hide the
bug we need to fix.

> > So perhaps it makes sense to redefine it
> >
> > 	#ifdef CONFIG_DEBUG_ATOMIC_SLEEP
> > 	#define fixup_sleep()	(current->task_state_change = 0)
> > 	#else
> > 	#define fixup_sleep()	do { } while (0)
> > 	#endif
> >
> > and change __might_sleep()
> >
> > 	-	if (WARN(current->state != TASK_RUNNING,
> > 	+	if (WARN(current->state != TASK_RUNNING && current->task_state_change != 0,
> >
> > ?
>
> So I'm hesitant to go that way because it adds extra state dependency.

OK. We can always reconsider this later. I spammed you only because I
wanted to understand what did me/you/both missed in this discussion.

> What if someone 'forgets' to use the *set*state() helpers.

Yes, this is true. Although we want to fix them anyway, if nothing else
for this warning in might_sleep().

Oleg.

