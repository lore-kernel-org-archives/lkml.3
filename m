Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751140Ab3C0QcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 12:32:04 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42163 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718Ab3C0QcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 12:32:01 -0400
Date: Wed, 27 Mar 2013 17:31:56 +0100
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code:
 asm/8267
Message-ID: <20130327163156.GB8385@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@kernel.org>,
	Arnaldo Carvalho de Melo <acme@infradead.org>,
	lkml <linux-kernel@vger.kernel.org>,
	Stephane Eranian <eranian@google.com>,
	Namhyung Kim <namhyung.kim@lge.com>
References: <20130324115556.GA4866@pd.tnic>
 <20130324155924.GB4866@pd.tnic>
 <20130326183452.GC27518@pd.tnic>
 <87ip4dgz31.fsf@sejong.aot.lge.com>
 <20130327094932.GA8385@pd.tnic>
 <1364393372.5053.68.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1364393372.5053.68.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 03:09:32PM +0100, Peter Zijlstra wrote:
> On Wed, 2013-03-27 at 10:49 +0100, Borislav Petkov wrote:
> > Ok, just for my own understanding: how do the events on the
> > ->task_ctx->event_list relate to the current cpu in this path? I mean,
> > we're on the task exit path here so is it possible to be rescheduled
> > somewhere else and the check in event_filter_match to become
> > meaningless?
> 
> Events can be per-cpu, so what could happen is that we'd send the exit
> notification to a cpu we're not actually running on (anymore).

Right, but we still have a window of preemption enabled:

		put_cpu_ptr(pmu->pmu_cpu_context);	<---|
     	}						    |
	if (task_event->task_ctx) {			    |
		preempt_disable_notrace();		<---|

between the two arrows above.

I don't know the code all that well to know whether a reschedule in that
window would make us, when looking at the current cpu when matching the
events, look stupid or not...

OTOH, I can understand jolsa's approach of declaring the events on
->task_ctx->event_list for belonging to this task only and that then we
just don't want to compare event->cpu to the current cpu we're running
on.

But in the end of the day, I'd like you guys to decide what is the right
thing to do here.

Btw, jolsa, as a simplification to your solution, you could simply do:

	if (task_event->task_ctx)
		list_for_each_entry_rcu(event, &ctx->event_list, event_entry)
			perf_event_task_output(event, task_event);

and avoid adding a 'match' argument.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
