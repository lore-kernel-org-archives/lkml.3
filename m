Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab3GMGuR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 02:50:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45013 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab3GMGuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 02:50:15 -0400
Date: Sat, 13 Jul 2013 08:49:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: mingo@kernel.org, arjan@linux.intel.com, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, alex.shi@intel.com, efault@gmx.de,
        pjt@google.com, len.brown@intel.com, corbet@lwn.net,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
Message-ID: <20130713064909.GW25631@dyad.programming.kicks-ass.net>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 04:55:29PM +0100, Morten Rasmussen wrote:
> Hi,
> 
> This patch set is an initial prototype aiming at the overall power-aware
> scheduler design proposal that I previously described
> <http://permalink.gmane.org/gmane.linux.kernel/1508480>.
> 
> The patch set introduces a cpu capacity managing 'power scheduler' which lives
> by the side of the existing (process) scheduler. Its role is to monitor the
> system load and decide which cpus that should be available to the process
> scheduler.

Hmm...

This looks like a userspace hotplug deamon approach lifted to kernel space :/

How about instead of layering over the load-balancer to constrain its behaviour
you change the behaviour to not need constraint? Fix it so it does the right
thing, instead of limiting it.

I don't think its _that_ hard to make the balancer do packing over spreading.
The power balance code removed in 8e7fbcbc had things like that (although it
was broken). And I'm sure I've seen patches over the years that did similar
things. Didn't Vincent and Alex also do things like that?

We should take the good bits from all that and make something of it. And I
think its easier now that we have the per task and per rq utilization numbers
[1].

Just start by changing the balancer to pack instead of spread. Once that works,
see where the two modes diverge and put a knob in.

Then worry about power thingies.


[1] -- I realize that the utilization numbers are actually influenced by
cpufreq state. Fixing this is another possible first step. I think it could be
done independently of the larger picture of a power aware balancer.


You also introduce a power topology separate from the topology information we
already have. Please integrate with the existing topology information so that
its a single entity.


The integration of cpuidle and cpufreq should start by unifying all the
statistics stuff. For cpuidle we need to pull in the per-cpu idle time
guestimator. For cpufreq the per-cpu usage stuff -- which we already have in
the scheduler these days!

Once we have all the statistics in place, its also easier to see what we can do
with them and what might be missing.

At this point mandate that policy drivers may not do any statistics gathering
of their own. If they feel the need to do so, we're missing something and
that's not right.

For the actual policies we should build a small library of concepts that can be
quickly composed to form an actual policy. Such that when two chips need
similar things they do indeed use the same code and not a copy with different
bugs. If there's only a single arch user of a concept that's fine, but at least
its out in the open and ready for re-use. Not hidden away in arch code.


Then we can start doing fancy stuff like fairness when constrained by power or
thermal envelopes. We'll need input from the GPU etc. for that. And the wildly
asymmetric thing you're interested in :-)


I'm not entirely sold on differentiating between short running and other tasks
either. Although I suppose I see where that comes from. A task that would run
50% on a big core would unlikely be qualified as small, however if it would
require 85% of a small core and there's room on the small cores its a good move
to run it there.

So where's the limit for being small? It seems like an artificial limit and
such should be avoided where possible.


Arjan; from reading your emails you're mostly busy explaining what cannot be
done. Please explain what _can_ be done and what Intel wants. From what I can
see you basically promote a max P state max concurrency race to idle FTW.

Since you can't say what the max P state is; and I think I understand the
reasons for that, and the hardware might not even respect the P state you tell
it to run at, does it even make sense to talk about Intel P states? When would
you not program the max P state?

In such a case the aperf/mperf ratio [2] gives both the current freq as the max
freq, since you're effectively always going at max speed.

[2] aperf/mperf ratio with an idle filter, we should exclude idle time.

IIRC you at one point said there was a time limit below which concurrency
spread wasn't useful anymore?

Also, most what you say for single socket systems; what does Intel want for
multi-socket systems?
