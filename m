Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab3KENfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 08:35:06 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45562 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753957Ab3KENfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 08:35:04 -0500
Date: Tue, 5 Nov 2013 13:34:08 +0000
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "eranian@google.com" <eranian@google.com>
Subject: Re: perf: PERF_EVENT_IOC_PERIOD on ARM vs everywhere else
Message-ID: <20131105133408.GC26895@mudshark.cambridge.arm.com>
References: <alpine.DEB.2.10.1310272233120.12721@vincent-weaver-1.um.maine.edu>
 <20131028085700.GB20218@mudshark.cambridge.arm.com>
 <alpine.DEB.2.10.1310281002020.24060@vincent-weaver-1.um.maine.edu>
 <20131029042810.GD22291@mudshark.cambridge.arm.com>
 <20131029134536.GD16117@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1310291129090.15619@vincent-weaver-1.um.maine.edu>
 <20131030095615.GG16117@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030095615.GG16117@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 09:56:15AM +0000, Peter Zijlstra wrote:
> On Tue, Oct 29, 2013 at 11:36:52AM -0400, Vince Weaver wrote:
> > It is true the current behavior is unexpected.  What was the logic behind 
> > deferring to the next overflow for the update?  Was it a code simplicity 
> > thing?  Or were there hardware reasons behind it?
> 
> Mostly an oversight I think. The delay is simply how it worked out in
> that the arch code has to reload the period once an event fires in order
> to reprogram. Since nobody actually used the thing, nobody had
> experience with it.
> 
> Now it turns out someone had a complaint but hid it somewhere on some
> obscure list :-(
> 
> There is actually generic code that force resets the period; see
> perf_event_period().
> 
> > Definitely when an event is stopped, it makes more sense for 
> > PERF_EVENT_IOC_PERIOD to take place immediately.  
> > 
> > I'm not sure what happens if we try to use it on a running event, 
> > especially if we've already passed the new period value.
> 
> The below code should deal with both cases I think -- completely
> untested.

[...]

> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 17b3c6cf1606..c45d53e561da 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3530,7 +3530,7 @@ static void perf_event_for_each(struct perf_event *event,
>  static int perf_event_period(struct perf_event *event, u64 __user *arg)
>  {
>  	struct perf_event_context *ctx = event->ctx;
> -	int ret = 0;
> +	int ret = 0, active;
>  	u64 value;
>  
>  	if (!is_sampling_event(event))
> @@ -3554,6 +3554,20 @@ static int perf_event_period(struct perf_event *event, u64 __user *arg)
>  		event->attr.sample_period = value;
>  		event->hw.sample_period = value;
>  	}
> +
> +	active = (event->state == PERF_EVENT_STATE_ACTIVE);
> +	if (active) {
> +		perf_pmu_disable(ctx->pmu);
> +		event->pmu->stop(event, PERF_EF_UPDATE);
> +	}
> +
> +	local64_set(event->hw.period_left, 0);

Adding the missing '&' here, this patch does what's expected for ARM (i.e.
Vince's ioctl_period test still fails).

  Tested-by: Will Deacon <will.deacon@arm.com>

Will
