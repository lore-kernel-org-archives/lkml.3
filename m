Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab3LPLHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 06:07:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35572 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab3LPLHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 06:07:44 -0500
Date: Mon, 16 Dec 2013 12:07:28 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v0 01/71] perf: Disable all pmus on unthrottling and
 rescheduling
Message-ID: <20131216110728.GW21999@twins.programming.kicks-ass.net>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1386765443-26966-2-git-send-email-alexander.shishkin@linux.intel.com>
 <20131213180638.GR21999@twins.programming.kicks-ass.net>
 <87eh5dt60b.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eh5dt60b.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 01:00:36PM +0200, Alexander Shishkin wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> 
> > On Wed, Dec 11, 2013 at 02:36:13PM +0200, Alexander Shishkin wrote:
> >> Currently, only one pmu in a context gets disabled during unthrottling
> >> and event_sched_{out,in}, however, events in one context may belong to
> >> different pmus, which results in pmus being reprogrammed while they are
> >> still enabled. This patch temporarily disables pmus that correspond to
> >> each event in the context while these events are being modified.
> >> 
> >> Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> >> ---
> >>  kernel/events/core.c | 27 ++++++++++++++++++++++++---
> >>  1 file changed, 24 insertions(+), 3 deletions(-)
> >> 
> >> diff --git a/kernel/events/core.c b/kernel/events/core.c
> >> index 403b781..d656cd6 100644
> >> --- a/kernel/events/core.c
> >> +++ b/kernel/events/core.c
> >> @@ -1396,6 +1396,9 @@ event_sched_out(struct perf_event *event,
> >>  	if (event->state != PERF_EVENT_STATE_ACTIVE)
> >>  		return;
> >>  
> >> +	if (event->pmu != ctx->pmu)
> >> +		perf_pmu_disable(event->pmu);
> >> +
> >>  	event->state = PERF_EVENT_STATE_INACTIVE;
> >>  	if (event->pending_disable) {
> >>  		event->pending_disable = 0;
> >> @@ -1412,6 +1415,9 @@ event_sched_out(struct perf_event *event,
> >>  		ctx->nr_freq--;
> >>  	if (event->attr.exclusive || !cpuctx->active_oncpu)
> >>  		cpuctx->exclusive = 0;
> >> +
> >> +	if (event->pmu != ctx->pmu)
> >> +		perf_pmu_enable(event->pmu);
> >>  }
> >>  
> >>  static void
> >
> > Hmm, indeed. Does it make sense to drop the conditional?
> > perf_pmu_{en,dis}able() is recursive and the thinking is that if its the
> > same PMU the cacheline is hot because we touched it already recently
> > anyway, so the unconditional inc/dec might actually be faster.. dunno.
> 
> Well, given the disable_count check in perf_pmu_{en,dis}able, this one
> indeed looks redundant to me. Should I resend this one separately?

Yes, it seems an unrelated bugfix, like Andi said.
