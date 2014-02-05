Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbaBERzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:55:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55367 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbaBERzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:55:40 -0500
Date: Wed, 5 Feb 2014 18:55:28 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 06/14] perf, core: always switch pmu specific data during
 context switch
Message-ID: <20140205175528.GF5002@laptop.programming.kicks-ass.net>
References: <1388728091-18564-1-git-send-email-zheng.z.yan@intel.com>
 <1388728091-18564-7-git-send-email-zheng.z.yan@intel.com>
 <CABPqkBQS=kSyRb0hb7DSTAOmUpB03_Cq70Wi1NvHj+DAQc4FVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQS=kSyRb0hb7DSTAOmUpB03_Cq70Wi1NvHj+DAQc4FVQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 06:19:27PM +0100, Stephane Eranian wrote:
> On Fri, Jan 3, 2014 at 6:48 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
> > If two tasks were both forked from the same parent task, Events in their perf
> > task contexts can be the same. Perf core optimizes context switch oout in this
> > case.
> >
> > Previous patch inroduces pmu specific data. The data is task specific, so we
> > should switch the data even when context switch is optimized out.
> >
> Reviwed-by: Stephane Eranian <eranian@google.com>

You should look again.. that xchg() is an atomic op and a total waste of
time since the assignment back onto ctx->task_ctx_data is non-atomic.

Complete fail there.

> > Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> > ---
> >  kernel/events/core.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index b6650ab..d6d8dea 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -2319,6 +2319,8 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
> >                         next->perf_event_ctxp[ctxn] = ctx;
> >                         ctx->task = next;
> >                         next_ctx->task = task;
> > +                       ctx->task_ctx_data = xchg(&next_ctx->task_ctx_data,
> > +                                                 ctx->task_ctx_data);
> >                         do_switch = 0;
> >
> >                         perf_event_sync_stat(ctx, next_ctx);
> > --
> > 1.8.4.2
> >
