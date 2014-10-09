Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbaJIR6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 13:58:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbaJIR6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 13:58:43 -0400
Date: Thu, 9 Oct 2014 19:55:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kirill Tkhai <tkhai@yandex.ru>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] sched: schedule_tail() should disable preemption
Message-ID: <20141009175521.GA16135@redhat.com>
References: <20141008080016.GB10832@worktop.programming.kicks-ass.net> <20141008183302.GA17495@redhat.com> <20141008183326.GB17495@redhat.com> <20141008193644.GA32055@redhat.com> <1412804248.24248.1.camel@yandex.ru> <20141009145726.GA5604@redhat.com> <20141009151730.GW10832@worktop.programming.kicks-ass.net> <20141009165713.GA13118@redhat.com> <20141009172834.GZ10832@worktop.programming.kicks-ass.net> <20141009173259.GC14547@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141009173259.GC14547@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09, Peter Zijlstra wrote:
>
> On Thu, Oct 09, 2014 at 07:28:34PM +0200, Peter Zijlstra wrote:
> > On Thu, Oct 09, 2014 at 06:57:13PM +0200, Oleg Nesterov wrote:
> > > @@ -2333,10 +2336,12 @@ context_switch(struct rq *rq, struct task_struct *prev,
> > >  #endif
> > >
> > >  	context_tracking_task_switch(prev, next);
> > > +
> > > +	pc = preempt_count();
> >
> > The only problem here is that you can loose PREEMPT_NEED_RESCHED, I
> > haven't thought about whether that is a problem here or not.

No, it must not be set. It was cleared by clear_preempt_need_resched()
in __schedule(), and nobody can set it.

(schedule_tail() also relies on fact it runs with irqs disabled).

But,

> Also, if you make that preempt_count_save(), to mirror the restore,

Yes, agreed. That is why I said we probably want preempt_count_raw()
(or _save). This way we avoid the unnecessary "&= ~PREEMPT_NEED_RESCHED"
on x86.

> can both preserve PREEMPT_NEED_RESCHED and avoid emitting code on !x86.

This too, although gcc should optimize this code out anyway. At least
it seems to do on x86 if I make preempt_count_restore() empty.

Oleg.

