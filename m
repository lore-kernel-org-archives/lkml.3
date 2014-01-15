Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbaAOSjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:39:23 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37202 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752847AbaAOSjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:39:21 -0500
Date: Wed, 15 Jan 2014 18:38:22 +0000
From: Will Deacon <will.deacon@arm.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Chad Paradis <chad.paradis@umit.maine.edu>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Subject: Re: [patch/rfc] perf on raspberry-pi without overflow interrupt
Message-ID: <20140115183822.GC28782@mudshark.cambridge.arm.com>
References: <alpine.DEB.2.10.1401081613370.4410@vincent-weaver-1.um.maine.edu>
 <20140108225315.GG31570@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1401082245120.22965@vincent-weaver-1.um.maine.edu>
 <20140109101921.GA26435@mudshark.cambridge.arm.com>
 <alpine.DEB.2.10.1401092304590.31813@vincent-weaver-1.um.maine.edu>
 <20140110100804.GB11045@mudshark.cambridge.arm.com>
 <alpine.DEB.2.10.1401132331290.20155@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1401132331290.20155@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vince,

On Tue, Jan 14, 2014 at 04:42:13AM +0000, Vince Weaver wrote:
> On Fri, 10 Jan 2014, Will Deacon wrote:
> > In the absence of a core change, I think I'd rather have something like your
> > second patch, but without the extra no_overflow_irq field (you can check the
> > platform device, as I mentioned previously).
> 
> Something like the following?  It works on my rasp-pi, still waiting for
> the compile to finish on the pandaboard so I haven't verified that the
> has-working-interrupt case still works.

[...]

> diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
> index bc3f2ef..e2c4aa2 100644
> --- a/arch/arm/kernel/perf_event.c
> +++ b/arch/arm/kernel/perf_event.c
> @@ -397,7 +397,7 @@ __hw_perf_event_init(struct perf_event *event)
>  	 */
>  	hwc->config_base	    |= (unsigned long)mapping;
>  
> -	if (!hwc->sample_period) {
> +	if (!is_sampling_event(event)) {
>  		/*
>  		 * For non-sampling runs, limit the sample_period to half
>  		 * of the counter width. That way, the new counter value
> @@ -407,6 +407,14 @@ __hw_perf_event_init(struct perf_event *event)
>  		hwc->sample_period  = armpmu->max_period >> 1;
>  		hwc->last_period    = hwc->sample_period;
>  		local64_set(&hwc->period_left, hwc->sample_period);
> +	} else {
> +
> +		/*
> +		 * If we have no PMU interrupt we cannot sample.
> +		 */
> +		if (platform_get_irq(armpmu->plat_device, 0) < 0)
> +			return -EOPNOTSUPP;

I think this should be <= 0, but apart from that this looks alright to me in
the absence of a core change.

Will
