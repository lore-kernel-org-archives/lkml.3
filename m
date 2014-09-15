Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbaIOT3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:29:04 -0400
Received: from service87.mimecast.com ([91.220.42.44]:49070 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbaIOT3A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:29:00 -0400
Date: Mon, 15 Sep 2014 20:28:50 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "riel@redhat.com" <riel@redhat.com>, "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Subject: Re: [PATCH v5 10/12] sched: get CPU's utilization statistic
Message-ID: <20140915192850.GB28083@e103687>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
 <1409051215-16788-11-git-send-email-vincent.guittot@linaro.org>
 <20140911123412.GY3190@worktop.ger.corp.intel.com>
MIME-Version: 1.0
In-Reply-To: <20140911123412.GY3190@worktop.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 15 Sep 2014 19:28:55.0694 (UTC) FILETIME=[4A3E1AE0:01CFD11B]
X-MC-Unique: 114091520285803301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 01:34:12PM +0100, Peter Zijlstra wrote:
> > @@ -4514,6 +4519,17 @@ static int select_idle_sibling(struct task_struct *p, int target)
> >  	return target;
> >  }
> >  
> > +static int get_cpu_utilization(int cpu)
> > +{
> > +	unsigned long usage = cpu_rq(cpu)->cfs.usage_load_avg;
> > +	unsigned long capacity = capacity_of(cpu);
> > +
> > +	if (usage >= SCHED_LOAD_SCALE)
> > +		return capacity + 1;
> > +
> > +	return (usage * capacity) >> SCHED_LOAD_SHIFT;
> > +}
> 
> So if I understood patch 9 correct, your changelog is iffy.
> usage_load_avg should never get > 1 (of whatever unit), no matter how
> many tasks are on the rq. You can only maximally run all the time.
> 
> Therefore I can only interpret the if (usage >= SCHED_LOAD_SCALE) as
> numerical error handling, nothing more.

That is not entirely true unless you also classify transient usage
spikes due to task migrations as numerical errors as well.

Since each task sched_entity is carrying around 350ms worth of execution
history with it between different cpus and cpu utilization is based on
the sum of task entity usage_avg_contrib on the runqueue you may get
cfs.usage_load_avg > 1 temporarily after task migrations. It will
eventually converge to 1.

The same goes for new tasks which are initialized to have a
usage_avg_contrib of 1 and may be queued on cpu with tasks already
running. In that case cfs.usage_load_avg is temporarily unbounded.

> Also I'm not entirely sure I like the usage, utilization names/metrics.
> I would suggest to reverse them. Call the pure running number
> 'utilization' and this scaled with capacity 'usage' or so.

I can agree with calling running for utilization, but I'm not convienced
about capacity. What does it exactly cover here? I'm confused and
jetlagged.

Morten

