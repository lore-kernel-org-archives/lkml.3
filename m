Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760172AbaJaVyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 17:54:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbaJaVyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 17:54:12 -0400
Date: Fri, 31 Oct 2014 22:53:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, peter@hurleysoftware.com,
        rjw@rjwysocki.net, torvalds@linux-foundation.org, tglx@linutronix.de,
        eparis@redhat.com, umgwanakikbuti@gmail.com, marcel@holtmann.org,
        ebiederm@xmission.com, davem@davemloft.net, fengguang.wu@intel.com
Subject: Re: [PATCH 2/7] wait: Reimplement wait_event_freezable()
Message-ID: <20141031215342.GA27823@redhat.com>
References: <20141031111037.936236584@infradead.org> <20141031111549.551132563@infradead.org> <20141031213802.GA25881@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031213802.GA25881@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31, Oleg Nesterov wrote:
>
> On 10/31, Peter Zijlstra wrote:
> >
> > Provide better implementations of wait_event_freezable() APIs.
> >
> > The problem is with freezer_do_not_count(), it hides the thread from
> > the freezer, even though this thread might not actually freeze/sleep
> > at all.
>
> I agree, wait_event_freezable() is awful. But could you clarify "at all" ?
>
> Sure, the task can be preempted right after it sets, it can do a lot
> of things before it calls schedule(), it can be woken after that and
> it can run again and do something else before freezer_count() calls
> try_to_freeze(), etc.
>
> Is this what you meant?
>
>
> > +#define __wait_event_freezable(wq, condition)				\
> > +	(void)___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, 0,	\
> > +			    schedule(); try_to_freeze())
>
> I don't think this can work. wait_event_freezable() should be used by
> kernel threads and thus we can't rely on TIF_SIGPENDING, freeze_task()
> simply does wake_up_state(TASK_INTERRUPTIBLE) in this case.
>
> Just for example, suppose that try_to_freeze_tasks() calls freeze_task()
> before this kthread sets current->state = TASK_INTERRUPTIBLE. In this
> case __wait_event_freezable()->schedule() will happily sleep and
> try_to_freeze_tasks() will fail.
>
> That is why I tried to suggest cmd == freezable_schedule(). Still not
> good, but at least this narrows the window and (perhaps) we can improve
> this freezable_schedule() later.
>
> But on a second thought... Probably cmd => try_to_freeze(); schedule();
> should work. Or just
>
> 	#define __wait_event_freezable(wq, condition)	\
> 		__wait_event_interruptible(wq, ({ try_to_freeze(); (condition); }))
>
> which looks simpler.

Ah, but I forgot about another problem... can't we finally kill this ugly
"long save = current->state" code in __refrigerator() ? Nobody seem to
understand why we are doing this, and this looks just wrong.

And this doesn't allow us to do try_to_freeze() + schedule().

Oleg.

