Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964865Ab3GLPgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 11:36:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:45648 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932979Ab3GLPgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 11:36:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,653,1367996400"; 
   d="scan'208";a="364336011"
Message-ID: <51E0225F.7090509@linux.intel.com>
Date: Fri, 12 Jul 2013 08:35:59 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Morten Rasmussen <morten.rasmussen@arm.com>
CC: "mingo@kernel.org" <mingo@kernel.org>,
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
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com> <51DC414F.5050900@linux.intel.com> <20130710111627.GC15989@e103687> <51DD5BFC.8000102@linux.intel.com> <20130712124612.GE20960@e103034-lin>
In-Reply-To: <20130712124612.GE20960@e103034-lin>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/12/2013 5:46 AM, Morten Rasmussen wrote:


> I have had a quick look at intel_pstate.c and to me it seems that it can
> be turned into a power driver that uses the proposed interface with a
> few modifications. intel_pstate.c already has max and min P-state as
> well as a current P-state calculated using the aperf/mperf ratio. I

it calculates average frequency... not current p state.
first of all, it's completely and strictly backwards looking
(and in the light of this being used in a load balancing decision,
the past is NOT a predictor for the future since you're about to change the maximum)
and second, in the light of having idle time... you do not get what you
think you get ;-)


>
> In the first case, the power scheduler would not know about turbo mode
> and never request it. Turbo mode could still be used by the power driver
> as a hidden bonus when power scheduler requests max power.

but what do you do when you ask for low power? On Intel.. for various cases,
you also pick a high P state!

(the assumption "low P state == low power" and "high P state == high power"
is just not valid)


>
> In the second approach, the power scheduler may request power (P-state)
> that can only be provided by a turbo P-state. Since we cannot be
> guaranteed to get that, the power driver would return the power
> (P-state) that is guaranteed (or at least very likely)

even non-turbo is very likely to not be achievable in various very
common situations. Two year ago I would have said, sure, but today,
it's just not the case anymore.

> I understand that the difference between highest guaranteed P-state and
> highest potential P-state is likely to increase in the future. Without
> any feedback about what potential P-state we can approximately get, we
> can only pack tasks until we hit the load that can be handled at the
> highest guaranteed P-state.

the only highest guaranteed P state is... the lowest P state. Sorry.
Everything else is subject to thermal management and hardware policies.


> I believe that there already is a power limit notification mechanism on
> Intel that can notify the OS when the firmware chooses a lower P-state
> than the one requested by the OS.

and we turn that off to avoid interrupt floods.....


> You (or Rafael) mentioned in our previous discussion that you are
> working on an improved intel_pstate driver. Will that be fundamentally
> different from the current one?

yes.
the hardware has been changing, and will be changing more (at a faster rate),
and we'll have very different algorithms for the different generations.

For example, for the recently launched client Haswell (think Ultrabook) the
system idle power is going down about 20 times compared to the previous generation (e.g.
what you'd buy a month ago).
With that change, the rules about when to go fast and not are changing dramatically....
since going faster means you'll go to the low power faster (even on previous generations that
effect is there, but with lower power in idle, this just gets stronger).

> I agree that packing is not a good idea for cache or memory bound tasks.
> It is not any different on dual cluster ARM setups like big.LITTLE. But,
> we do see a lot of benefit in packing small tasks which are not cache or
> memory bound, or performance critical. Keeping them on as few cpus as
> possible means that the rest can enter deeper C-states for longer.

I totally agree with the idea of *statistically* grouping short running tasks.
But... this can be done VERY simple without such explicit "how many do we need".
All you need to do is to do a statistical "sort left", e.g. if a short running tasks
wants to run (that by definition has not run for a while, so is cache cold anyway),
make it prefer the lowest number idle cpu to wake up on.
Heck, even making it just prefer only cpu 0 when it's idle will by and large already achieve
this.
Remember that you don't have to be perfect; no point trying to move tasks that never run in your
management time window; only the ones that actually want to run need management.
And at the "I want to run" time, you can just sort it left.
(and this is fine for tasks that run short; all the numa/etc logic value kicks in for tasks that do
some serious amounts of work and thus by definition run for longer stretches)

What you don't want to do, is run tasks sequentially that could have run in parallel. That's the best
way to destroy power efficiency in multicore systems ;-(

And to be honest, the effect of per logical CPU C states is much smaller on Intel than the effect
of global idle (in Intel terms, "package C states"). The break even points of CPU core states are
extremely short for us, even for the deepest states. The bigger bang for the buck is with system wide
idle, so that memory can go to self refresh (and the memory controllers/etc can be turned off).
The break even point for those kind of things is longer, and that's where wakeups/etc make a much bigger dent.



> BTW. Packing one strictly memory bound task and one strictly cpu bound
> task on one socket might work. The only problem is to determine the task
> charateristics ;-)

yeah "NUMA is hard, lets go shopping" for sure.


