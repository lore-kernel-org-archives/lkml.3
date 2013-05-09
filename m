Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab3EIKzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 06:55:05 -0400
Received: from service87.mimecast.com ([91.220.42.44]:39188 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab3EIKzD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 06:55:03 -0400
Date: Thu, 9 May 2013 11:55:16 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Alex Shi <alex.shi@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 3/7] sched: set initial value of runnable avg for new
 forked task
Message-ID: <20130509105516.GF4068@e103034-lin>
References: <CAPM31RJg7t8f1H-dZwzP1c-0HHb_=8twidX74gS2NfyQhHUhCw@mail.gmail.com>
 <5187760D.8060900@intel.com>
 <CAPM31RKiCfSZ=hJ9P7WOH6AC8uj6b06mEM6K0WCTYXC7OJAq7A@mail.gmail.com>
 <51886460.3020009@intel.com>
 <CAPM31RLsip-PMY73oq58gyi42EQ+-upmPpMQFkukVBX6LTwtCw@mail.gmail.com>
 <20130507095715.GE4068@e103034-lin>
 <5188DFEF.6010403@intel.com>
 <CAPM31R+x3h0b_r4uFkg_SMnkp0AWA6QRAQuDRducycHnFdG5Xw@mail.gmail.com>
 <20130508113442.GB6803@dyad.programming.kicks-ass.net>
 <CAPM31RK06z9SrwACTCyOg96tza9UxA9ZRZegBDA76pG2oM+m7A@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAPM31RK06z9SrwACTCyOg96tza9UxA9ZRZegBDA76pG2oM+m7A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 09 May 2013 10:54:59.0468 (UTC) FILETIME=[A65AECC0:01CE4CA3]
X-MC-Unique: 113050911550013601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 01:00:34PM +0100, Paul Turner wrote:
> On Wed, May 8, 2013 at 4:34 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, May 07, 2013 at 04:20:55AM -0700, Paul Turner wrote:
> >> Yes, 1024 was only intended as a starting point.  We could also
> >> arbitrarily pick something larger, the key is that we pick
> >> _something_.
> >>
> >> If we wanted to be more exacting about it we could just give them a
> >> sched_slice() worth; this would have a few obvious "nice" properties
> >> (pun intended).
> >
> > Oh I see I misunderstood again :/ Its not about the effective load but weight
> > of the initial effective load wrt adjustment.
> >
> > Previous schedulers didn't have this aspect at all, so no experience from me
> > here. Paul would be the one, since he's ran longest with this stuff.
> >
> > That said, I would tend to keep it shorter rather than longer so that it would
> > adjust quicker to whatever it really wanted to be.
> >
> > Morten says the load is unstable specifically on loaded systems.
> 
> Here, Morten was (I believe) referring to the stability at task startup.
> 
> To be clear:
> Because we have such a small runnable period denominator at this point
> a single changed observation (for an equivalently behaving thread)
> could have a very large effect.  e.g. fork/exec -- happen to take a
> major #pf, observe a "relatively" long initial block.
> 
> By associating an initial period (along with our full load_contrib)
> here, we're making the denominator larger so that these effects are
> less pronounced; achieving better convergence towards what our load
> contribution should actually be.

This is exactly what I meant, thanks :)

For the workloads we are looking at we frequently see tasks that get
blocked for short amounts of time shortly after the task was created. As
you already explained, the small denominator causes the tracked load
change very quickly until the denominator gets larger.

I think it makes good sense to initialize the period and sum (to be
conservative) to some appropriate value to get more a more stable
tracked load for new tasks.

Morten

> 
> Also: We do this conservatively, by converging down, not up.
> 
> > I would think
> > this is because we'd experience scheduling latency, we're runnable more pushing
> > things up. But if we're really an idle task at heart we'd not run again for a
> > long while, pushing things down again.
> 
> Exactly, this is why we must be careful to use instaneous weights
> about wake-up decisions.  Interactive and background tasks are largely
> idle.
> 
> While this is exactly how we want them to be perceived from a
> load-balance perspective it's important to keep in mind that while
> wake-up placement has a very important role in the overall balance of
> a system, it is not playing quite the same game as the load-balancer.
> 
> >
> > So on that point Paul's suggestion of maybe starting with __sched_slice() might
> > make sense because it increases the weight of the initial avg with nr_running.
> > Not sure really, we'll have to play and see what works best for a number of
> > workloads.
> 

