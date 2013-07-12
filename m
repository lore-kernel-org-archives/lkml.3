Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964791Ab3GLMqG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 08:46:06 -0400
Received: from service87.mimecast.com ([91.220.42.44]:53058 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932948Ab3GLMqE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 08:46:04 -0400
Date: Fri, 12 Jul 2013 13:46:13 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        rafael.j.wysocki@intel.com
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
Message-ID: <20130712124612.GE20960@e103034-lin>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
 <51DC414F.5050900@linux.intel.com>
 <20130710111627.GC15989@e103687>
 <51DD5BFC.8000102@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <51DD5BFC.8000102@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 12 Jul 2013 12:45:58.0386 (UTC) FILETIME=[C1D12D20:01CE7EFD]
X-MC-Unique: 113071213460101301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 02:05:00PM +0100, Arjan van de Ven wrote:
> 
> >
> >>
> >> also, it almost looks like there is a fundamental assumption in the code
> >> that you can get the current effective P state to make scheduler decisions on;
> >> on Intel at least that is basically impossible... and getting more so with every generation
> >> (likewise for AMD afaics)
> >>
> >> (you can get what you ran at on average over some time in the past, but not
> >> what you're at now or going forward)
> >>
> >
> > As described above, it is not a strict assumption. From a scheduler
> > point of view we somehow need to know if the cpus are truly fully
> > utilized (at their highest P-state)
> 
> unfortunately we can't provide this on Intel ;-(
> we can provide you what you ran at average, we cannot provide you if that is the max or not
> 
> (first of all, because we outright don't know what the max would have been, and second,
> because we may be running slower than max because the workload was memory bound or
> any of the other conditions that makes the HW P state "governor" decide to reduce
> frequency for efficiency reasons)

I have had a quick look at intel_pstate.c and to me it seems that it can
be turned into a power driver that uses the proposed interface with a
few modifications. intel_pstate.c already has max and min P-state as
well as a current P-state calculated using the aperf/mperf ratio. I
think these are quite similar to what we need for the power
scheduler/driver. The aperf/mperf ratio can approximate the current
'power'. For max 'power' it can be done in two ways: Either use the
highest non-turbo P-state or the highest available turbo P-state.

In the first case, the power scheduler would not know about turbo mode
and never request it. Turbo mode could still be used by the power driver
as a hidden bonus when power scheduler requests max power.

In the second approach, the power scheduler may request power (P-state)
that can only be provided by a turbo P-state. Since we cannot be
guaranteed to get that, the power driver would return the power
(P-state) that is guaranteed (or at least very likely). That is, the
highest non-turbo P-state. That approach seems better to me and also
somewhat similar to what is done in intel_pstate.c (if I understand it
correctly).

I'm not an expert on Intel power management, so I may be missing
something.

I understand that the difference between highest guaranteed P-state and
highest potential P-state is likely to increase in the future. Without
any feedback about what potential P-state we can approximately get, we
can only pack tasks until we hit the load that can be handled at the
highest guaranteed P-state. Are you (Intel) considering any new feedback
mechanisms for this?

I believe that there already is a power limit notification mechanism on
Intel that can notify the OS when the firmware chooses a lower P-state
than the one requested by the OS.

You (or Rafael) mentioned in our previous discussion that you are
working on an improved intel_pstate driver. Will that be fundamentally
different from the current one?

> > so we need to throw more cpus at the
> > problem (assuming that we have more than one task per cpu) or if we can
> > just go to a higher P-state. We don't need a strict guarantee that we
> > get exactly the P-state that we request for each cpu. The power
> > scheduler generates hints and the power driver gives us feedback on what
> > we can roughly expect to get.
> 
> 
> >
> >> I'm rather nervous about calculating how many cores you want active as a core scheduler feature.
> >> I understand that for your big.LITTLE architecture you need this due to the asymmetry,
> >> but as a general rule for more symmetric systems it's known to be suboptimal by quite a
> >> real percentage. For a normal Intel single CPU system it's sort of the worst case you can do
> >> in that it leads to serializing tasks that could have run in parallel over multiple cores/threads.
> >> So at minimum this kind of logic must be enabled/disabled based on architecture decisions.
> >
> > Packing clearly has to take power topology into account and do the right
> > thing for the particular platform. It is not in place yet, but will be
> > addressed. I believe it would make sense for dual cpu Intel systems to
> > pack at socket level?
> 
> a little bit. if you have 2 quad core systems, it will make sense to pack 2 tasks
> onto a single core, assuming they are not cache or memory bandwidth bound (remember this is numa!)
> but if you have 4 tasks, it's not likely to be worth it to pack, unless you get an enormous
> economy of scale due to cache sharing
> (this is far more about getting numa balancing right than about power; you're not very likely
> to win back the power you loose from inefficiency if you get the numa side wrong by being
> too smart about power placement)

I agree that packing is not a good idea for cache or memory bound tasks.
It is not any different on dual cluster ARM setups like big.LITTLE. But,
we do see a lot of benefit in packing small tasks which are not cache or
memory bound, or performance critical. Keeping them on as few cpus as
possible means that the rest can enter deeper C-states for longer.

BTW. Packing one strictly memory bound task and one strictly cpu bound
task on one socket might work. The only problem is to determine the task
charateristics ;-)

