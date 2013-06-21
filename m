Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab3FUIuz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 04:50:55 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42627 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758048Ab3FUIuG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 04:50:06 -0400
Date: Fri, 21 Jun 2013 09:50:02 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: David Lang <david@lang.hm>, Ingo Molnar <mingo@kernel.org>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: power-efficient scheduling design
Message-ID: <20130621085002.GJ5460@e103034-lin>
References: <20130530134718.GB32728@e103034-lin>
 <20130531105204.GE30394@gmail.com>
 <20130614160522.GG32728@e103034-lin>
 <51C07ABC.2080704@linux.intel.com>
 <alpine.DEB.2.02.1306181039340.9258@nftneq.ynat.uz>
 <51C1D0BB.3040705@linux.intel.com>
 <20130619170042.GH5460@e103034-lin>
 <51C1E58D.9000408@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <51C1E58D.9000408@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 21 Jun 2013 08:50:00.0502 (UTC) FILETIME=[5062C560:01CE6E5C]
X-MC-Unique: 113062109500204101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 06:08:29PM +0100, Arjan van de Ven wrote:
> On 6/19/2013 10:00 AM, Morten Rasmussen wrote:
> > On Wed, Jun 19, 2013 at 04:39:39PM +0100, Arjan van de Ven wrote:
> >> On 6/18/2013 10:47 AM, David Lang wrote:
> >>
> >>>
> >>> It's bad enough trying to guess the needs of the processes, but if you also are reduced to guessing the capabilities of the cores, how can anything be made to work?
> >>
> >> btw one way to look at this is to assume that (with some minimal hinting)
> >> the CPU driver will do the right thing and get you just about the best performance you can get
> >> (that is appropriate for the task at hand)...
> >> ... and don't do anything in the scheduler proactively.
> >
> > If I understand correctly, you mean if your hardware/firmware is fully
> 
> hardware, firmware and the driver
> 
> > in control of the p-state selection and changes it fast enough to match
> > the current load, the scheduler doesn't have to care? By fast enough I
> > mean, faster than the scheduler would notice if a cpu was temporarily
> > overloaded at a low p-state. In that case, you wouldn't need
> > cpufreq/p-state hints, and the scheduler would only move tasks between
> > cpus when cpus are fully loaded at their max p-state.
> 
> with the migration hint, I'm pretty sure we'll be there today typically.

A hint when a task is moved to a new cpu is too late if the migration
shouldn't have happened at all. If the scheduler knows that the cpu is
able to switch to a higher p-state it can decide to wait for the p-state
change instead of migrating the task and waking up another cpu.

> we'll notice within 10 msec regardless, but the migration hint will take
> the edge of those 10 msec normally.

I'm not sure if 10 msec is fast enough for the scheduler to not notice.
Real use-case studies will tell.

> 
> I would argue that the "at their max p-state" in your sentence needs to go away.
> since you don't know what you actually are except in hindsight.
> And even then you don't know if you could have gone higher or not.

Yes. What I meant was that if your p-state selection is responsive
enough the scheduler would only see the cpu as overloaded when it is in
its highest available p-state. That may determined dynamically by power,
thermal, and other factors.

> 
> 
> >> the hints I have in mind are not all that complex; we have the biggest issues today
> >> around task migration (the task migrates to a cold cpu... so a simple notifier chain
> >> on the new cpu as it is accepting a task and we can bump it up), real time tasks
> >> (again, simple notifier chain to get you to a predictably high performance level)
> >> and we're a long way better than we are today in terms of actual problems.
> >>
> >> For all the talk of ondemand (as ARM still uses that today)... that guy puts you in
> >> either the lowest or highest frequency over 95% of the time. Other non-cpufreq solutions
> >> like on Intel are bit more advanced (and will grow more so over time), but even there,
> >> in the grand scheme of things, the scheduler shouldn't have to care anymore with those
> >> two notifiers in place.
> >
> > You would need more than a few hints to implement more advanced capacity
> > management like proposed for the power scheduler. I believe that Intel
> > would benefit as well from guiding the scheduler to idle the right cpu
> > to enable deeper idle states and/or enable turbo-boost for other cpus.
> 
> that's an interesting theory.
> I've yet to see any way to actually have that do something useful.
> 
> yes there is some value in grouping a lot of very short tasks together.
> not a lot of value, but at least some.
> 
> and there is some value in the grouping within a package (to a degree) thing.
> 
> (both are basically "statistically, sort left" as policy)
> 

The proposed task packing patches have shown significant benefits for
scenarios with many short tasks. This is a typical scenario on android.

Morten


