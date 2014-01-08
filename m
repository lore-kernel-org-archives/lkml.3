Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbaAHMfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 07:35:37 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:56661 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755610AbaAHMfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 07:35:34 -0500
Date: Wed, 8 Jan 2014 12:35:34 +0000
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "pjt@google.com" <pjt@google.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "alex.shi@linaro.org" <alex.shi@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "amit.kucheria@linaro.org" <amit.kucheria@linaro.org>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>
Subject: Re: [RFC] sched: CPU topology try
Message-ID: <20140108123534.GI2936@e103034-lin>
References: <20131105222752.GD16117@laptop.programming.kicks-ass.net>
 <1387372431-2644-1-git-send-email-vincent.guittot@linaro.org>
 <52B87149.4010801@arm.com>
 <CAKfTPtDmb1fa8PUcrqEGaoQLxoPBddu-Yn_oS8KwsCJJWJzQug@mail.gmail.com>
 <20140106163123.GN31570@twins.programming.kicks-ass.net>
 <CAKfTPtDind8HGJwu0odSnNdRpaxp3VB3JWw3eADAp4bL4Ex-Mw@mail.gmail.com>
 <20140107132220.GZ31570@twins.programming.kicks-ass.net>
 <20140107141059.GY3694@twins.programming.kicks-ass.net>
 <20140107154154.GH2936@e103034-lin>
 <20140107204951.GD2480@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140107204951.GD2480@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 08:49:51PM +0000, Peter Zijlstra wrote:
> On Tue, Jan 07, 2014 at 03:41:54PM +0000, Morten Rasmussen wrote:
> > I think that could work if we sort of the priority scaling issue that I
> > mentioned before.
> 
> We talked a bit about this on IRC a month or so ago, right? My memories
> from that are that your main complaint is that we don't detect the
> overload scenario right.
> 
> That is; the point at which we should start caring about SMP-nice is
> when all our CPUs are fully occupied, because up to that point we're
> under utilized and work preservation mandates we utilize idle time.

Yes. I think I stated the problem differently, but I think we talk about
the same thing. Basically, priority-scaling in task load_contrib means
that runnable_load_avg and blocked_load_avg are poor indicators of cpu
load (available idle time). Priority scaling only makes sense when the
system is fully utilized. When that is not the case, it just gives us a
potentially very inaccurate picture of the load (available idle time).

Pretty much what you just said :-)

> Currently we detect overload by sg.nr_running >= sg.capacity, which can
> be very misleading because while a cpu might have a task running 'now'
> it might be 99% idle.
> 
> At which point I argued we should change the capacity thing anyhow. Ever
> since the runnable_avg patch set I've been arguing to change that into
> an actual utilization test.
> 
> So I think that if we measure overload by something like >95% utilization
> on the entire group the load scaling again makes perfect sense.

I agree that it make more sense to change the overload test to be based
on some tracked load. How about the non-overloaded case? Load balancing
would have to be based on unweighted task loads in that case?

> 
> Given the 3 task {A,B,C} workload where A and B are niced, to land on a
> symmetric dual CPU system like: {A,B}+{C}, assuming they're all while(1)
> loops :-).
> 
> The harder case is where all 3 tasks are of equal weight; in which case
> fairness would mandate we (slowly) rotate the tasks such that they all
> get 2/3 time -- we also horribly fail at this :-)

I have encountered that one a number of times. All the middleware noise
in Android sometimes give that effect.

I'm not sure if the NUMA guy would like rotating scheduler though :-)
