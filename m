Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbbAUPwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:52:41 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:40171 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbbAUPwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:52:33 -0500
Message-ID: <1421855543.14076.68.camel@arm.com>
Subject: Re: [PATCH v4 1/3] perf: Use monotonic clock as a source for
 timestamps
From: Pawel Moll <pawel.moll@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christopher Covington <cov@codeaurora.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Date: Wed, 21 Jan 2015 15:52:23 +0000
In-Reply-To: <20150105130035.GP30905@twins.programming.kicks-ass.net>
References: <1415292718-19785-1-git-send-email-pawel.moll@arm.com>
	 <1415292718-19785-2-git-send-email-pawel.moll@arm.com>
	 <20150105130035.GP30905@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.10-0ubuntu1~14.10.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-05 at 13:00 +0000, Peter Zijlstra wrote:
> On Thu, Nov 06, 2014 at 04:51:56PM +0000, Pawel Moll wrote:
> >  Documentation/kernel-parameters.txt |  9 +++++++++
> >  kernel/events/core.c                | 37 +++++++++++++++++++++++++++++++++++++
> >  2 files changed, 46 insertions(+)
> 
> > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > index 4c81a86..8ead8d8 100644
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> 
> > @@ -2763,6 +2764,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
> >  			allocator.  This parameter is primarily	for debugging
> >  			and performance comparison.
> >  
> > +	perf_use_local_clock
> > +			[PERF]
> > +			Use local_clock() as a source for perf timestamps
> > +			generation. This was be the default behaviour and
> > +			this parameter can be used to maintain backward
> > +			compatibility or on older hardware with expensive
> > +			monotonic clock source.
> > +
> >  	pf.		[PARIDE]
> >  			See Documentation/blockdev/paride.txt.
> 
> So I'm always terminally confused on the naming of kernel parameters,
> sometimes things are modules (even when they're not actually =m capable)
> and get a module::foo naming or so and sometimes they're not.

I guess you mean module.foo?

> So we want to use the module naming thing or not?

Honestly, I don't mind either way. For one thing ftrace doesn't bother
and just uses __setup() as well.

> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index 2b02c9f..5d0aa03 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> 
> > @@ -322,8 +323,41 @@ extern __weak const char *perf_pmu_name(void)
> >  	return "pmu";
> >  }
> >  
> > +static bool perf_use_local_clock;
> > +static int __init perf_use_local_clock_setup(char *__unused)
> > +{
> > +	perf_use_local_clock = true;
> > +	return 1;
> > +}
> > +__setup("perf_use_local_clock", perf_use_local_clock_setup);
> 
> >  static inline u64 perf_clock(void)
> >  {
> > +	if (likely(!perf_use_local_clock))
> > +		return ktime_get_mono_fast_ns();
> > +
> >  	return local_clock();
> >  }
> 
> Since this all is boot time, should we not use things like static_key
> and avoid the 'pointless' conditional at runtime?

Right. it's good to learn new stuff - I didn't know there was
architecture-agnostic support for jump labels. Definitely worth the
effort, will give it a try and spin the patch.

Pawel


