Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbaFCMEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:04:00 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:11383 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751362AbaFCMD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 08:03:57 -0400
Date: Tue, 3 Jun 2014 13:03:54 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v2 08/11] sched: get CPU's activity statistic
Message-ID: <20140603120354.GC29593@e103034-lin>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-9-git-send-email-vincent.guittot@linaro.org>
 <20140528121001.GI19967@e103034-lin>
 <CAKfTPtDxeBfZK1AxCRqEG91pi--Ti1RYFoQPDhvMVnGTCspQ-g@mail.gmail.com>
 <20140528154703.GJ19967@e103034-lin>
 <CAKfTPtCd8Mm+bvO3f1ybRC=gV-vQ=_5SxcUnOiuZ0XTf0JN=mA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtCd8Mm+bvO3f1ybRC=gV-vQ=_5SxcUnOiuZ0XTf0JN=mA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 05:39:10PM +0100, Vincent Guittot wrote:
> On 28 May 2014 17:47, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> > On Wed, May 28, 2014 at 02:15:03PM +0100, Vincent Guittot wrote:
> >> On 28 May 2014 14:10, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> >> > On Fri, May 23, 2014 at 04:53:02PM +0100, Vincent Guittot wrote:
> 
> [snip]
> 
> >
> >> This value is linked to the CPU on
> >> which it has run previously because of the time sharing with others
> >> tasks, so the unweighted load of a freshly migrated task will reflect
> >> its load on the previous CPU (with the time sharing with other tasks
> >> on prev CPU).
> >
> > I agree that the task runnable_avg_sum is always affected by the
> > circumstances on the cpu where it is running, and that it takes this
> > history with it. However, I think cfs.runnable_load_avg leads to less
> > problems than using the rq runnable_avg_sum. It would work nicely for
> > the two tasks on two cpus example I mentioned earlier. We don't need add
> 
> i would say that nr_running is an even better metrics for such
> situation as the load doesn't give any additional information.

I fail to understand how nr_running can be used. nr_running doesn't tell
you anything about the utilization of the cpu, just the number tasks
that happen to be runnable at a point in time on a specific cpu. It
might be two small tasks that just happened to be running while you read
nr_running.

An unweighted version of cfs.runnable_load_avg gives you a metric that
captures cpu utilization to some extend, but not the number of tasks.
And it reflects task migrations immediately unlike the rq
runnable_avg_sum.

> Just to point that we can spent a lot of time listing which use case
> are better covered by which metrics :-)

Agreed, but I think it is quite important to discuss what we understand
by cpu utilization. It seems to be different depending on what you want
to use it for. I think it is also clear that none of the metrics that
have been proposed are perfect. We therefore have to be careful to only
use metrics in scenarios where they make sense. IMHO, both rq
runnable_avg_sum and unweighted cfs.runnable_load_avg capture cpu
utilization, but in different ways.

We have done experiments internally with rq runnable_avg_sum for
load-balancing decisions in the past and found it unsuitable due to its
slow response to task migrations. That is why I brought it up here.
AFAICT, you use rq runnable_avg_sum more like a flag than a quantitative
measure of cpu utilization. Viewing things from an energy-awareness
point of view I'm more interested in the latter for estimating the
implications of moving tasks around. I don't have any problems with
using rq runnable_avg_sum for other things as long we are fully aware of
how this metric works.

> > something on top when the cpu is fully utilized by more than one task.
> > It comes more naturally with cfs.runnable_load_avg. If it is much larger
> > than 47742, it should be fairly safe to assume that you shouldn't stick
> > more tasks on that cpu.
> >
> >>
> >> I'm not saying that such metric is useless but it's not perfect as well.
> >
> > It comes with its own set of problems, agreed. Based on my current
> > understanding (or lack thereof) they just seem smaller :)
> 
> I think it's worth using the cpu utilization for some cases because it
> has got some information that are not available elsewhere. And the
> replacement of the current capacity computation is one example.
> As explained previously, I'm not against adding other metrics and i'm
> not sure to understand why you oppose these 2 metrics whereas they
> could be complementary

I think we more or less agree :) I'm fine with both metrics and I agree
that they complement each other. My concern is using the right metric
for the right job. If you choose to use rq runnable_avg_sum you have to
keep its slow reaction time in mind. I think that might be
difficult/not possible for some load-balancing decisions. That is
basically my point :)

Morten
