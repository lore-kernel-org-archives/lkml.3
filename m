Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbaFCRlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 13:41:32 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:57237 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751128AbaFCRla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 13:41:30 -0400
Date: Tue, 3 Jun 2014 18:41:25 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>
Subject: Re: [PATCH v2 08/11] sched: get CPU's activity statistic
Message-ID: <20140603174125.GG29593@e103034-lin>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-9-git-send-email-vincent.guittot@linaro.org>
 <20140528121001.GI19967@e103034-lin>
 <CAKfTPtDxeBfZK1AxCRqEG91pi--Ti1RYFoQPDhvMVnGTCspQ-g@mail.gmail.com>
 <20140528154703.GJ19967@e103034-lin>
 <CAKfTPtCd8Mm+bvO3f1ybRC=gV-vQ=_5SxcUnOiuZ0XTf0JN=mA@mail.gmail.com>
 <20140603120354.GC29593@e103034-lin>
 <20140603155939.GA30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603155939.GA30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 04:59:39PM +0100, Peter Zijlstra wrote:
> On Tue, Jun 03, 2014 at 01:03:54PM +0100, Morten Rasmussen wrote:
> > An unweighted version of cfs.runnable_load_avg gives you a metric that
> > captures cpu utilization to some extend, but not the number of tasks.
> > And it reflects task migrations immediately unlike the rq
> > runnable_avg_sum.
> 
> So runnable_avg would be equal to the utilization as long as
> there's idle time, as soon as we're over-loaded the metric shows how
> much extra cpu is required.
> 
> That is, runnable_avg - running_avg >= 0 and the amount is the
> exact amount of extra cpu required to make all tasks run but not have
> idle time.

Yes, roughly. runnable_avg goes up quite steeply if you have many tasks
on a fully utilized cpu, so the actual amount of extra cpu required
might be somewhat lower. I can't come up with something better, so I
agree.

> 
> > Agreed, but I think it is quite important to discuss what we understand
> > by cpu utilization. It seems to be different depending on what you want
> > to use it for.
> 
> I understand utilization to be however much cpu is actually used, so I
> would, per the existing naming, call running_avg to be the avg
> utilization of a task/group/cpu whatever.

I see your point, but for load balancing purposes we are more intested
in the runnable_avg as it tells us about the cpu capacity requirements.
I don't like to throw more terms into the mix, but you could call
runnable_avg the potential task/group/cpu utilization. This is an
estimate of how much utilization a task would cause if we moved it to an
idle cpu. That might be quite different from running_avg on an
over-utilized cpu.

> 
> > We have done experiments internally with rq runnable_avg_sum for
> > load-balancing decisions in the past and found it unsuitable due to its
> > slow response to task migrations. That is why I brought it up here.
> 
> So I'm not entirely seeing that from the code (I've not traced this),
> afaict we actually update the per-cpu values on migration based on the
> task values.
> 
> old_rq->sum -= p->val;
> new_rq->sum += p->val;
> 
> like,.. except of course totally obscured.

Yes, for cfs.runnable_load_avg, rq->avg.runnable_avg_sum is different.
See the other reply.
