Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919Ab3DZKUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 06:20:37 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60849
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757190Ab3DZKUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 06:20:35 -0400
Date: Fri, 26 Apr 2013 12:18:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        mingo@kernel.org, linux@arm.linux.org.uk, pjt@google.com,
        santosh.shilimkar@ti.com, morten.rasmussen@arm.com,
        chander.kashyap@linaro.org, cmetcalf@tilera.com, tony.luck@intel.com,
        alex.shi@intel.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        len.brown@intel.com, arjan@linux.intel.com, amit.kucheria@linaro.org,
        corbet@lwn.net
Subject: Re: [RFC PATCH v3 3/6] sched: pack small tasks
Message-ID: <20130426101849.GD8669@dyad.programming.kicks-ass.net>
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org>
 <1363955155-18382-4-git-send-email-vincent.guittot@linaro.org>
 <1364300782.5053.6.camel@laptop>
 <5152C83F.6060509@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5152C83F.6060509@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 03:51:51PM +0530, Preeti U Murthy wrote:
> Hi,
> 
> On 03/26/2013 05:56 PM, Peter Zijlstra wrote:
> > On Fri, 2013-03-22 at 13:25 +0100, Vincent Guittot wrote:
> >> +static bool is_buddy_busy(int cpu)
> >> +{
> >> +       struct rq *rq = cpu_rq(cpu);
> >> +
> >> +       /*
> >> +        * A busy buddy is a CPU with a high load or a small load with
> >> a lot of
> >> +        * running tasks.
> >> +        */
> >> +       return (rq->avg.runnable_avg_sum >
> >> +                       (rq->avg.runnable_avg_period / (rq->nr_running
> >> + 2)));
> >> +}
> > 
> > Why does the comment talk about load but we don't see it in the
> > equation. Also, why does nr_running matter at all? I thought we'd
> > simply bother with utilization, if fully utilized we're done etc..
> > 
> 
> Peter, lets say the run-queue has 50% utilization and is running 2
> tasks. And we wish to find out if it is busy. We would compare this
> metric with the cpu power, which lets say is 100.
> 
> rq->util * 100 < cpu_of(rq)->power.
> 
> In the above scenario would we declare the cpu _not_busy? Or would we do
> the following:
> 
> (rq->util * 100) * #nr_running <  cpu_of(rq)->power and conclude that it
> is just enough _busy_ to not take on more processes?

That is just confused... ->power doesn't have anything to do with a per-cpu
measure. ->power is a inter-cpu measure of relative compute capacity.

Mixing in nr_running confuses things even more; it doesn't matter how many
tasks it takes to push utilization up to 100%; once its there the cpu simply
cannot run more.

So colour me properly confused..
