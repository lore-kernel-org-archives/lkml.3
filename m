Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbbA2PUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:20:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:55777 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbbA2PUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:20:30 -0500
Date: Thu, 29 Jan 2015 16:20:22 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com,
        markus.t.metzger@intel.com, mathieu.poirier@linaro.org,
        Kaixu Xia <kaixu.xia@linaro.org>, acme@infradead.org
Subject: Re: [PATCH v9 12/14] x86: perf: intel_pt: Intel PT PMU driver
Message-ID: <20150129152022.GC26304@twins.programming.kicks-ass.net>
References: <1421237903-181015-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1421237903-181015-13-git-send-email-alexander.shishkin@linux.intel.com>
 <20150115090659.GQ23965@worktop.programming.kicks-ass.net>
 <87egqwmdhe.fsf@ashishki-desk.ger.corp.intel.com>
 <87twzllhbz.fsf@ashishki-desk.ger.corp.intel.com>
 <20150126165536.GA23038@twins.programming.kicks-ass.net>
 <87zj9485j0.fsf@ashishki-desk.ger.corp.intel.com>
 <20150129115918.GA26304@twins.programming.kicks-ass.net>
 <CAB7JpEFo=gmx9mFxDi06fueunFrpqgsKtg4_eC-PuUeuCHre1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB7JpEFo=gmx9mFxDi06fueunFrpqgsKtg4_eC-PuUeuCHre1g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2015 at 05:03:21PM +0200, Alexander Shishkin wrote:
> > We're already holding ctx->mutex, this should have made lockdep scream.
> 
> As I mentioned offline, cpuctx->ctx.mutex is set to a lockdep class of
> its own, so lockdep doesn't see this. It is, of course, still a
> problem.

Right; I don't think we currently use that annotation of
cpuctx->ctx.mutex but I had indeed overlooked that.

Per perf_ctx_lock() the nesting order is:

 cpuctx
   ctx

And here we would have done the inverse. Still I'm not entirely sure it
would've resulted in a deadlock, we typically don't take multiple
ctx->mutex locks, and where we do its either between different context
on the same CPU (eg, moving a software event to the hardware lists), or
between the same context on different CPUs (perf_pmu_migrate_context),
or between inherited contexts (put_event, in child->parent nesting).

None of those cases seem to overlap with this order.

However,

> But as you pointed out, if we grab the exclusive_cnt for per-task
> cpu!=-1 events as well, we don't need to look into other contexts here
> at all.

its irrelevant because we can avoid the entire ordeal ;-)

> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -3487,6 +3487,9 @@ static void __free_event(struct perf_eve
> >         if (event->destroy)
> >                 event->destroy(event);
> >
> > +       if (event->pmu && event->ctx)
> > +               exclusive_event_release(event);
> 
> It looks like event can be already removed from its context at this
> point, so event->ctx will be NULL and the counter would leak or am I
> missing something?

Yeah, event->ctx is _magic_ ;-)

event->ctx is never NULL, although it can change. Much fun because of
that; see: lkml.kernel.org/r/20150123125159.696530128@infradead.org if
you like to torture yourself a wee bit.

> I used the event->attach_state & PERF_ATTACH_TASK to see if it's a
> per-task counter, which seems reliable even though it might need
> documenting.

Yes, I suppose that is indeed better, I had feared we clear the
ATTACH_TASK state on remove_from_context() like we do all the other
ATTACH states, but we do not.


> > +static bool exclusive_event_ok(struct perf_event *event,
> > +                              struct perf_event_context *ctx)
> 
> Then, maybe exclusive_event_installable() is a better name, because
> this one only deals with the current context; cpu-wide vs per-task
> case is taken care of in perf_event_alloc()/__free_event().

OK.

> > +       /*
> > +        * exclusive_cnt <0: cpu
> > +        *               >0: tsk
> > +        */
> > +       if (ctx->task) {
> > +               if (!atomic_inc_unless_negative(&pmu->exclusive_cnt))
> > +                       return false;
> > +       } else {
> > +               if (!atomic_dec_unless_positive(&pmu->exclusive_cnt))
> > +                       return false;
> > +       }
> 
> So I would like to keep this bit in perf_event_alloc() path and the
> reverse in __free_event(),

Fair enough; exclusive_event_init() ?

> > +
> > +       mutex_lock(&ctx->lock);
> > +       ret = __exclusive_event_ok(event, ctx);
> > +       mutex_unlock(&ctx->lock);

And as you pointed out on IRC, this needs to be in the same section as
install_in_context() otherwise we have a race.

> > +       if (!ret) {
> > +               if (ctx->task)
> > +                       atomic_dec(&pmu->exclusive_cnt);
> > +               else
> > +                       atomic_inc(&pmu->exclusive_cnt);
> > +       }
> 
> in which case we don't need to undo the counter here, because it will
> still go through __free_event() in the error path.

OK; exclusive_event_destroy() ?

