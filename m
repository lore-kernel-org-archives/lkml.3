Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061Ab3GMQOY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 12:14:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:43837 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152Ab3GMQOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 12:14:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,659,1367996400"; 
   d="scan'208";a="330891758"
Message-ID: <51E17CDD.30805@linux.intel.com>
Date: Sat, 13 Jul 2013 09:14:21 -0700
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
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com> <20130713064909.GW25631@dyad.programming.kicks-ass.net>
In-Reply-To: <20130713064909.GW25631@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/12/2013 11:49 PM, Peter Zijlstra wrote:
> On Tue, Jul 09, 2013 at 04:55:29PM +0100, Morten Rasmussen wrote:
>> Hi,
>>
>> This patch set is an initial prototype aiming at the overall power-aware
>> scheduler design proposal that I previously described
>> <http://permalink.gmane.org/gmane.linux.kernel/1508480>.
>>
>> The patch set introduces a cpu capacity managing 'power scheduler' which lives
>> by the side of the existing (process) scheduler. Its role is to monitor the
>> system load and decide which cpus that should be available to the process
>> scheduler.
>
> Hmm...
>
> This looks like a userspace hotplug deamon approach lifted to kernel space :/
>
> How about instead of layering over the load-balancer to constrain its behaviour
> you change the behaviour to not need constraint? Fix it so it does the right
> thing, instead of limiting it.
>
> I don't think its _that_ hard to make the balancer do packing over spreading.
> The power balance code removed in 8e7fbcbc had things like that (although it
> was broken). And I'm sure I've seen patches over the years that did similar
> things. Didn't Vincent and Alex also do things like that?

a basic "sort left" (e.g. when needing to pick a cpu for a task that is short running,
pick the lowest numbered idle one) will already have the effect of packing in practice.
it's not perfect packing, but on a statistical level it'll be quite good.

(this all assumes relatively idle systems with spare capacity to play with of course..
... but that's the domain where packing plays a role)



> Arjan; from reading your emails you're mostly busy explaining what cannot be
> done. Please explain what _can_ be done and what Intel wants. From what I can
> see you basically promote a max P state max concurrency race to idle FTW.
>

btw one more thing I'd like to get is a communication between the scheduler
and the policy/hardware drivers about task migration.
When a task migrates to another CPU, the statistics that the hardware/driver/policy
were keeping on that target CPU are really not valid anymore in terms of forward
looking predictive power. A communication (API or notification or whatever form it takes)
around this would be quite helpful.
This could be as simple as just setting a flag on the target cpu (in their rq), so that
the next power event (exiting idle, P state evaluation, whatever) the policy code
can flush-and-start-over.


on thinking more about the short running task thing; there is an optimization we currently don't do,
mostly for hyperthreading. (and HT is just one out of a set of cases with similar power behavior)
If we know a task runs briefly AND is not performance critical, it's much much better to place it on
a hyperthreading buddy of an already busy core than it is to place it on an empty core (or to delay it).
Yes a HT pair isn't the same performance as a full core, but in terms of power the 2nd half of a HT pair
is nearly free... so if there's a task that's not performance sensitive (and won't disturb the other task too much,
e.g. runs briefly enough)... it's better to pack onto a core than to spread.
you can generalize this to a class of systems where adding work to a core (read: group of cpus that share resources)
is significantly cheaper than running on a full empty core.

(there is clearly a tradeoff, by sharing resources you also end up reducing performance/efficiency, and that has its
own effect on power, so there is some kind of balance needed and a big enough gain to be worth the loss)

