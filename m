Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaFFNPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 09:15:15 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:11185 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750993AbaFFNPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 09:15:13 -0400
Date: Fri, 6 Jun 2014 14:15:10 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Subject: Re: [RFC PATCH 06/16] arm: topology: Define TC2 sched energy and
 provide it to scheduler
Message-ID: <20140606131510.GV29593@e103034-lin>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
 <1400869003-27769-7-git-send-email-morten.rasmussen@arm.com>
 <20140603114428.GY11096@twins.programming.kicks-ass.net>
 <20140604154227.GR29593@e103034-lin>
 <20140604161618.GQ30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604161618.GQ30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 05:16:18PM +0100, Peter Zijlstra wrote:
> On Wed, Jun 04, 2014 at 04:42:27PM +0100, Morten Rasmussen wrote:
> > On Tue, Jun 03, 2014 at 12:44:28PM +0100, Peter Zijlstra wrote:
> > > On Fri, May 23, 2014 at 07:16:33PM +0100, Morten Rasmussen wrote:
> > > > +static struct capacity_state cap_states_cluster_a7[] = {
> > > > +	/* Cluster only power */
> > > > +	 { .cap =  358, .power = 2967, }, /*  350 MHz */
> > > > +	 { .cap =  410, .power = 2792, }, /*  400 MHz */
> > > > +	 { .cap =  512, .power = 2810, }, /*  500 MHz */
> > > > +	 { .cap =  614, .power = 2815, }, /*  600 MHz */
> > > > +	 { .cap =  717, .power = 2919, }, /*  700 MHz */
> > > > +	 { .cap =  819, .power = 2847, }, /*  800 MHz */
> > > > +	 { .cap =  922, .power = 3917, }, /*  900 MHz */
> > > > +	 { .cap = 1024, .power = 4905, }, /* 1000 MHz */
> > > > +	};
> > > > +
> > > > +static struct capacity_state cap_states_cluster_a15[] = {
> > > > +	/* Cluster only power */
> > > > +	 { .cap =  840, .power =  7920, }, /*  500 MHz */
> > > > +	 { .cap = 1008, .power =  8165, }, /*  600 MHz */
> > > > +	 { .cap = 1176, .power =  8172, }, /*  700 MHz */
> > > > +	 { .cap = 1343, .power =  8195, }, /*  800 MHz */
> > > > +	 { .cap = 1511, .power =  8265, }, /*  900 MHz */
> > > > +	 { .cap = 1679, .power =  8446, }, /* 1000 MHz */
> > > > +	 { .cap = 1847, .power = 11426, }, /* 1100 MHz */
> > > > +	 { .cap = 2015, .power = 15200, }, /* 1200 MHz */
> > > > +	};
> > > 
> > > 
> > > So how did you obtain these numbers? Did you use numbers provided by the
> > > hardware people, or did you run a particular benchmark and record the
> > > power usage?
> > >
> > > Does that benchmark do some actual work (as opposed to a while(1) loop)
> > > to keep more silicon lit up?
> > 
> > Hardware people don't like sharing data, so I did my own measurements
> > and calculations to get the numbers above.
> > 
> > ARM TC2 has on-chip energy counters for counting energy consumed by the
> > A7 and A15 clusters. They are fairly accurate. 
> 
> Recent Intel chips have that too; they come packaged as:
> 
>   perf stat -a -e "power/energy-cores/" -- cmd
> 
> (through the perf_event_intel_rapl.c driver), It would be ideal if the
> ARM equivalent was available through a similar interface.
> 
> http://lwn.net/Articles/573602/

Nice. On ARM it is not mandatory to have energy counters and what they
actually measure if they are implemented is implementation dependent.
However, each vendor does extensive evaluation and characterization of
their implementation already, so I don't think would be a problem for
them to provide the numbers.

> > I used sysbench cpu
> > benchmark as test workload for the above numbers. sysbench might not be
> > a representative workload, but it is easy to use. I think, ideally,
> > vendors would run their own mix of workloads they care about and derrive
> > their numbers for their platform based on that.
> > 
> > > If you have a setup for measuring these, should we try and publish that
> > > too so that people can run it on their platform and provide these
> > > numbers?
> > 
> > The workload setup I used quite simple. I ran sysbench with taskset with
> > different numbers of threads to extrapolate power consumed by each
> > individual cpu and how much comes from just powering on the domain.
> > 
> > Measuring the actual power is very platform specific. Developing a fully
> > automated tool do it for any given platform isn't straigt forward, but
> > I'm happy to share how I did it. I can add a description of the method I
> > used on TC2 to the documentation so others can use it as reference.
> 
> That would be good I think, esp. if we can get similar perf based energy
> measurement things sorted. And if we make the tool consume the machine
> topology present in sysfs we can get a long way towards automating this
> I think.

Some of the measurements could be automated. Others are hard to
automate as they require extensive knowledge about the platform. wakeup
energy, for example. You may need to do various tricks and hacks to
force the platform to use a specific idle-state so you know what you are
measuring.

I will add the TC2 recipe as a start and then see if my ugly scripts can
be turned into something generally useful.
