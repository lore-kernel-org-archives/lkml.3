Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbbAZQzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:55:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:33267 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbbAZQzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:55:43 -0500
Date: Mon, 26 Jan 2015 17:55:36 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com,
        markus.t.metzger@intel.com, mathieu.poirier@linaro.org,
        Kaixu Xia <kaixu.xia@linaro.org>, acme@infradead.org
Subject: Re: [PATCH v9 12/14] x86: perf: intel_pt: Intel PT PMU driver
Message-ID: <20150126165536.GA23038@twins.programming.kicks-ass.net>
References: <1421237903-181015-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1421237903-181015-13-git-send-email-alexander.shishkin@linux.intel.com>
 <20150115090659.GQ23965@worktop.programming.kicks-ass.net>
 <87egqwmdhe.fsf@ashishki-desk.ger.corp.intel.com>
 <87twzllhbz.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87twzllhbz.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 03:20:00PM +0200, Alexander Shishkin wrote:
> > As for the exclusive events, how about something like the code below (on
> > top of the previous exclusive event patch)? The only remaining issue
> > that I see is creating cpu-wide events in the presence of per-thread
> > (event->cpu==-1) events. Both would still work, but only one of them
> > will actually get scheduled at a time. I'm thinking about adding a
> > counter for per-thread events to struct pmu for this purpose, so that if
> > any are present, we can disallow creating cpu-wide events. Or, we can
> > leave it as it is.
> >
> > What do you think?
> >
> > ---
> >  kernel/events/core.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 47 insertions(+), 5 deletions(-)
> >
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index cf0bf99f53..e8c86530e2 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -7688,14 +7688,11 @@ static bool exclusive_event_match(struct perf_event *e1, struct perf_event *e2)
> >  	return false;
> >  }
> >  
> > -static bool exclusive_event_ok(struct perf_event *event,
> > -			      struct perf_event_context *ctx)
> > +static bool __exclusive_event_ok(struct perf_event *event,
> > +				 struct perf_event_context *ctx)
> >  {
> >  	struct perf_event *iter_event;
> >  
> > -	if (!(event->pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE))
> > -		return true;
> > -
> >  	list_for_each_entry(iter_event, &ctx->event_list, event_entry) {
> >  		if (exclusive_event_match(iter_event, event))
> >  			return false;
> > @@ -7704,6 +7701,51 @@ static bool exclusive_event_ok(struct perf_event *event,
> >  	return true;
> >  }
> >  
> > +static bool __exclusive_event_ok_on_cpu(struct perf_event *event, int cpu)
> > +{
> > +	struct perf_event_context *cpuctx;
> > +	bool ret;
> > +
> > +	cpuctx = find_get_context(event->pmu, NULL, cpu);
> > +	mutex_lock(&cpuctx->mutex);
> > +	ret = __exclusive_event_ok(event, cpuctx);
> > +	perf_unpin_context(cpuctx);
> > +	put_ctx(cpuctx);
> > +	mutex_unlock(&cpuctx->mutex);
> 
> Actually, find_get_context() is not needed here, the following should be
> sufficient:
> 
> 	cpuctx = &per_cpu_ptr(event->pmu->pmu_cpu_context, cpu)->ctx;
> 
> 	mutex_lock(&cpuctx->mutex);
> 	ret = __exclusive_event_ok(event, cpuctx);
> 	mutex_unlock(&cpuctx->mutex);

Yes that'll work.
