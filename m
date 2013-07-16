Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933584Ab3GPT5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:57:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:49367 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932991Ab3GPT5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:57:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,679,1367996400"; 
   d="scan'208";a="366240822"
Message-ID: <51E5A5AE.7010903@linux.intel.com>
Date: Tue, 16 Jul 2013 12:57:34 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Morten Rasmussen <morten.rasmussen@arm.com>, mingo@kernel.org,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        alex.shi@intel.com, efault@gmx.de, pjt@google.com, len.brown@intel.com,
        corbet@lwn.net, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com> <20130713064909.GW25631@dyad.programming.kicks-ass.net> <51E166C8.3000902@linux.intel.com> <20130715195914.GC23818@dyad.programming.kicks-ass.net> <51E45E8B.705@linux.intel.com> <20130715210650.GF23818@dyad.programming.kicks-ass.net> <20130715211230.GG23818@dyad.programming.kicks-ass.net> <51E47D30.5030203@linux.intel.com> <20130716173848.GA22795@dyad.programming.kicks-ass.net> <51E5947F.4090109@linux.intel.com> <20130716192145.GV17211@twins.programming.kicks-ass.net>
In-Reply-To: <20130716192145.GV17211@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/16/2013 12:21 PM, Peter Zijlstra wrote:

> Suppose a 2 cpu system, one cpu is running 3/4 throttle, the other is
> running at half speed. Both cpus are equally utilized. A new task
> comes on.
>
> Where do we run it?
>
> We need to know that there's head-room on the 1/2 speed cpu and should
> crank its pace and place the task there.

ok so you are interested in past "real" utilization of the hardware resources;
that is available generally (and tends to come from hardware counters, on ARM
as well).

you may not get it as a percentage, but in some absolute term, so you
can know which of the two is least loaded... that might be enough

Today cpufreq uses a library to get these counters, moving that library to the scheduler
or some similar place.... sounds like a great idea.
There is an argument for what to do on systems where such counters are either
absent or very expensive and that's good question; maybe one of the ARM folks
can say how expensive these counters are for them to see if there really is such
a problem?

> Even without the new task; its not a 'balanced' situation, but it
> appears that way because the cpu's are nearly equally utilized. Maybe if
> we crank one cpu to the max it could run all tasks and have the other
> cpu power gated. Or maybe they could both drop to 60% and run equal
> loads.

which way is better for energy consumption is likely a per arch question,
and having the architecture provide some runtime configuration about how
valueable it is to spread out sounds sensible to me.

then the question of how much remaining capacity; this is a hard one, and not just
for Intel. Almost all mobile devices today are thermally constrained, ARM and Intel
alike (at least the higher performance ones)... the curse of wanting very thin and light
phones that are made of thermally isolating plastic (so that radio waves can go through)
and have a nice and bright screen...

With thermals as a whole you tend to not know you're hitting the wall until you try;
you may think you can go another gigahertz on a core, but when you go there you near instantly
hit a thermal limit that whacks you waaaay back down again.

(that reminds me, I'd love investigate for the scheduler to look at core temperature as one of the
factors in its decision... that might actually be one of the more interesting inputs to
scheduler decisions, both in terms of capacity planning and efficiency)


> We need feedback for these problems; but you're telling us new Intel
> stuff can't really tell us much of anything :/

s/new/existing/ to be honest; chips we've been selling in the last 4+ years.

> What I'm saying is; sure the cpufreq driver might have chip specific
> magic but it very much needs to tell us things too we can't have it do
> its own thing and not care.

some of the things may come from other things than the P state selection part;
a lot of the things you're asking for will tend to come from counters I suspect.

