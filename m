Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbaBLURS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 15:17:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49179 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbaBLURQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 15:17:16 -0500
Date: Wed, 12 Feb 2014 21:17:09 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <bitbucket@online.de>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Too many rescheduling interrupts (still!)
Message-ID: <20140212201709.GB6835@laptop.programming.kicks-ass.net>
References: <CALCETrVL44ewQPJXNwPAm2s5aj9auo2p4tYYieNcxANoL91VWw@mail.gmail.com>
 <alpine.DEB.2.02.1402112219160.21991@ionos.tec.linutronix.de>
 <CALCETrUPyG1HoXFToXuVLOzX2f20zzxJyABKASOUPY691JmjMA@mail.gmail.com>
 <20140212101324.GC3545@laptop.programming.kicks-ass.net>
 <CALCETrW-GCNuqSTO=p==0gPE2c8wZKSe98Gi4PP2NRdgk5iKag@mail.gmail.com>
 <20140212163916.GA27965@twins.programming.kicks-ass.net>
 <CALCETrWx39_xLZAEGA8_nnGGhbpaSXqY4haLqbU1wavJM6wenQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWx39_xLZAEGA8_nnGGhbpaSXqY4haLqbU1wavJM6wenQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 10:19:42AM -0800, Andy Lutomirski wrote:
> >  static void ttwu_queue_remote(struct task_struct *p, int cpu)
> >  {
> > -       if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list))
> > -               smp_send_reschedule(cpu);
> > +       struct rq *rq = cpu_rq(cpu);
> > +
> > +       if (llist_add(&p->wake_entry, &rq->wake_list)) {
> > +               set_tsk_need_resched(rq->idle);
> > +               smp_mb__after_clear_bit();
> > +               if (!tsk_is_polling(rq->idle) || rq->curr != rq->idle)
> > +                       smp_send_reschedule(cpu);
> > +       }
> 
> At the very least this needs a comment pointing out that rq->lock is
> intentionally not taken.  This makes my brain hurt a little :)

Oh absolutely; I wanted to write one, but couldn't get a straight story
so gave up for now.

> > +               /*
> > +                * We must clear polling before running sched_ttwu_pending().
> > +                * Otherwise it becomes possible to have entries added in
> > +                * ttwu_queue_remote() and still not get an IPI to process
> > +                * them.
> > +                */
> > +               __current_clr_polling();
> > +
> > +               set_preempt_need_resched();
> > +               sched_ttwu_pending();
> > +
> >                 tick_nohz_idle_exit();
> >                 schedule_preempt_disabled();
> > +               __current_set_polling();
> 
> I wonder if this side has enough barriers to make this work.

sched_ttwu_pending() does xchg() as first op and thereby orders itself
against the clr_polling.


I'll need a fresh brain for your proposal.. will read it again in the
morning.
