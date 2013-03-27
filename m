Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab3C0JxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:53:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49763 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849Ab3C0Jth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 05:49:37 -0400
Date: Wed, 27 Mar 2013 10:49:32 +0100
From: Borislav Petkov <bp@alien8.de>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 asm/8267
Message-ID: <20130327094932.GA8385@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@infradead.org>,
	lkml <linux-kernel@vger.kernel.org>,
	Stephane Eranian <eranian@google.com>,
	Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <20130324115556.GA4866@pd.tnic>
 <20130324155924.GB4866@pd.tnic>
 <20130326183452.GC27518@pd.tnic>
 <87ip4dgz31.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87ip4dgz31.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 03:02:10PM +0900, Namhyung Kim wrote:
> > --
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index 7b4a55d41efc..f3bb3384a106 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -4455,8 +4455,11 @@ static void perf_event_task_event(struct perf_task_event *task_event)
> >  next:
> >  		put_cpu_ptr(pmu->pmu_cpu_context);
> >  	}
> > +
> > +	preempt_disable();
> >  	if (task_event->task_ctx)
> >  		perf_event_task_ctx(task_event->task_ctx, task_event);
> > +	preempt_enable();

Ok, just for my own understanding: how do the events on the
->task_ctx->event_list relate to the current cpu in this path? I mean,
we're on the task exit path here so is it possible to be rescheduled
somewhere else and the check in event_filter_match to become
meaningless?

Because with this fix, we have a small window between enabling
preemption after the last pmu context and disabling it again to get
moved somewhere else.

Hmm.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
