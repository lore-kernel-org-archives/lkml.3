Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaDYJ5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:57:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:41469 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaDYJ5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:57:33 -0400
Date: Fri, 25 Apr 2014 11:57:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Yuyang Du <yuyang.du@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        arjan.van.de.ven@intel.com, Len Brown <len.brown@intel.com>,
        rafael.j.wysocki@intel.com, alan.cox@intel.com,
        "Gross, Mark" <mark.gross@intel.com>,
        Morten Rasmussen <morten.rasmussen@arm.com>
Subject: Re: [RFC] A new CPU load metric for power-efficient scheduler: CPU
 ConCurrency
Message-ID: <20140425095729.GG26782@laptop.programming.kicks-ass.net>
References: <20140424193004.GA2467@intel.com>
 <CAKfTPtDUdmf3gpTJAqf49Hddpv2h4XQffz1OLpuhjuRpKOU7jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtDUdmf3gpTJAqf49Hddpv2h4XQffz1OLpuhjuRpKOU7jg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 10:00:02AM +0200, Vincent Guittot wrote:
> On 24 April 2014 21:30, Yuyang Du <yuyang.du@intel.com> wrote:
> > Hi Ingo, PeterZ, and others,
> >
> > The current scheduler's load balancing is completely work-conserving. In some
> > workload, generally low CPU utilization but immersed with CPU bursts of
> > transient tasks, migrating task to engage all available CPUs for
> > work-conserving can lead to significant overhead: cache locality loss,
> > idle/active HW state transitional latency and power, shallower idle state,
> > etc, which are both power and performance inefficient especially for today's
> > low power processors in mobile.
> >
> > This RFC introduces a sense of idleness-conserving into work-conserving (by
> > all means, we really don't want to be overwhelming in only one way). But to
> > what extent the idleness-conserving should be, bearing in mind that we don't
> > want to sacrifice performance? We first need a load/idleness indicator to that
> > end.
> >
> > Thanks to CFS's "model an ideal, precise multi-tasking CPU", tasks can be seen
> > as concurrently running (the tasks in the runqueue). So it is natural to use
> > task concurrency as load indicator. Having said that, we do two things:
> >
> > 1)      Divide continuous time into periods of time, and average task concurrency
> > in period, for tolerating the transient bursts:
> > a = sum(concurrency * time) / period
> > 2)      Exponentially decay past periods, and synthesize them all, for hysteresis
> > to load drops or resilience to load rises (let f be decaying factor, and a_x
> > the xth period average since period 0):
> > s = a_n + f^1 * a_n-1 + f^2 * a_n-2 +, .....,+ f^(n-1) * a_1 + f^n * a_0
> 
> In the original version of entity load tracking patchset, there was a
> usage_avg_sum field that was counting the time the task was really
> running on the CPU. By combining this (disappeared ) field with the
> runnable_avg_sum, you should have similar concurrency value but with
> the current load tracking mechanism (instead of creating new one).

I'm not entire sure understood what was proposed, but I suspect its very
close to what I told you to do with the capacity muck. Use avg
utilization instead of 1 active task per core.

And yes, the current load tracking should be pretty close.

We just need to come up another way of doing SMT again, bloody
inconvenient SMT.
