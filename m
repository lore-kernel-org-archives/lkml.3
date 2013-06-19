Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934722Ab3FSMjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 08:39:40 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46167 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934022Ab3FSMjj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 08:39:39 -0400
Date: Wed, 19 Jun 2013 13:39:33 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: David Lang <david@lang.hm>
Cc: Ingo Molnar <mingo@kernel.org>, "alex.shi@intel.com" <alex.shi@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: power-efficient scheduling design
Message-ID: <20130619123933.GG5460@e103034-lin>
References: <20130530134718.GB32728@e103034-lin>
 <20130531105204.GE30394@gmail.com>
 <20130614160522.GG32728@e103034-lin>
 <alpine.DEB.2.02.1306171809200.9258@nftneq.ynat.uz>
 <20130618102324.GF5460@e103034-lin>
 <alpine.DEB.2.02.1306181032160.9258@nftneq.ynat.uz>
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1306181032160.9258@nftneq.ynat.uz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 19 Jun 2013 12:39:32.0867 (UTC) FILETIME=[0C876530:01CE6CEA]
X-MC-Unique: 113061913393601901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 06:39:27PM +0100, David Lang wrote:
> On Tue, 18 Jun 2013, Morten Rasmussen wrote:
> 
> >> I don't think that you are passing nearly enough information around.
> >>
> >> A fairly simple example
> >>
> >> take a relatively modern 4-core system with turbo mode where speed controls
> >> affect two cores at a time (I don't know the details of the available CPUs to
> >> know if this is an exact fit to any existing system, but I think it's a
> >> reasonable fit)
> >>
> >> If you are running with a loadave of 2, should you power down 2 cores and run
> >> the other two in turbo mode, power down 2 cores and not increase the speed, or
> >> leave all 4 cores running as is.
> >>
> >> Depending on the mix of processes, I could see any one of the three being the
> >> right answer.
> >>
> >> If you have a process that's maxing out it's cpu time on one core, going to
> >> turbo mode is the right thing as the other processes should fit on the other
> >> core and that process will use more CPU (theoretically getting done sooner)
> >>
> >> If no process is close to maxing out the core, then if you are in power saving
> >> mode, you probably want to shut down two cores and run everything on the other
> >> two
> >>
> >> If you only have two processes eating almost all your CPU time, going to two
> >> cores is probably the right thing to do.
> >>
> >> If you have more processes, each eating a little bit of time, then continuing
> >> to run on all four cores uses more cache, and could let all of the tasks finish
> >> faster.
> >>
> >>
> >> So, how is the Power Scheduler going to get this level of information?
> >>
> >> It doesn't seem reasonable to either pass this much data around, or to try and
> >> give two independant tools access to the same raw data (since that data is so
> >> tied to the internal details of the scheduler). If we are talking two parts of
> >> the same thing, then it's perfectly legitimate to have this sort of intimate
> >> knowledge of the internal data structures.
> >
> > I realize that my description is not very clear about this point. Total
> > load is clearly not enough information for the power scheduler to take
> > any reasonable decisions. By current load, I mean per-cpu load, number
> > of tasks, and possibly more task statistics. Enough information to
> > determine the best use of the system cpus.
> >
> > As stated in my previous reply, this is not the ultimate design. It
> > expect to have many design iterations. If it turns out that it doesn't
> > make sense to have a separate power scheduler, then we should merge
> > them. I just propose to divide the design into manageable components. A
> > unified design covering the scheduler, two other policy frameworks, and
> > new policies is too complex in my opinion.
> >
> > The power scheduler may be viewed as an external extension to the
> > periodic scheduler load balance. I don't see a major problem in
> > accessing raw data in the scheduler. The power scheduler will live in
> > sched/power.c. In a unified solution where you put everything into
> > sched/fair.c you would still need access to the same raw data to make
> > the right power scheduling decisions. By having the power scheduler
> > separately we just attempt to minimize the entanglement.
> 
> Why insist on this being treated as an external component that you have to pass 
> messages to?
> 
> If you allow it to be combined, then it can lookup the info it needs rather than 
> trying to define an API between the two that accounts for everything that you 
> need to know (now and in the future)

I don't see why you cannot read the internal scheduler data structures
from the power scheduler (with appropriate attention to locking). The
point of the proposed design is not to define interfaces, it is to divide
the problem into manageable components.

Let me repeat again, if we while developing the solution find out that
the separation doesn't make sense I have no problem merging them. I
don't insist on the separation, my point is that we need to partition
this very complex problem and let it evolve into a reasonable solution.

> 
> This will mean that as the internals of one change it will affect the internals 
> of the other, but it seems like this is far more likely to be successful.
> 

That is no different from having a merged design. If you change
something in the scheduler you would have to consider all the power
implications anyway. The power scheduler design would give you at least
a vague separation and the possibility of not having a power scheduler
at all.

> If you have hundreds or thousands of processes, it's bad enough to lookup the 
> data directly, but trying to marshal the infromation to send it to a separate 
> component seems counterproductive.

I don't see why that should be necessary.

Morten

