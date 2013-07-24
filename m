Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab3GXNQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 09:16:44 -0400
Received: from service87.mimecast.com ([91.220.42.44]:37945 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab3GXNQm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 09:16:42 -0400
Date: Wed, 24 Jul 2013 14:16:38 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "mingo@kernel.org" <mingo@kernel.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
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
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
Message-ID: <20130724131638.GD12572@e103034-lin>
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
 <20130713064909.GW25631@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
In-Reply-To: <20130713064909.GW25631@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 24 Jul 2013 13:16:37.0860 (UTC) FILETIME=[072FA240:01CE8870]
X-MC-Unique: 113072414163906601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 13, 2013 at 07:49:09AM +0100, Peter Zijlstra wrote:
> On Tue, Jul 09, 2013 at 04:55:29PM +0100, Morten Rasmussen wrote:
> > Hi,
> > 
> > This patch set is an initial prototype aiming at the overall power-aware
> > scheduler design proposal that I previously described
> > <http://permalink.gmane.org/gmane.linux.kernel/1508480>.
> > 
> > The patch set introduces a cpu capacity managing 'power scheduler' which lives
> > by the side of the existing (process) scheduler. Its role is to monitor the
> > system load and decide which cpus that should be available to the process
> > scheduler.
> 
> Hmm...
> 
> This looks like a userspace hotplug deamon approach lifted to kernel space :/

I know I'm arriving a bit late to the party...

I do see what you mean, but I think comparing it to a userspace hotplug
deamon is a bit harsh :) As Catalin has already pointed out, the
intention behind the design is to separate cpu capacity management from
load-balancing and runqueue management to avoid adding further
complexity to main load balancer. 

> How about instead of layering over the load-balancer to constrain its behaviour
> you change the behaviour to not need constraint? Fix it so it does the right
> thing, instead of limiting it.
> 
> I don't think its _that_ hard to make the balancer do packing over spreading.
> The power balance code removed in 8e7fbcbc had things like that (although it
> was broken). And I'm sure I've seen patches over the years that did similar
> things. Didn't Vincent and Alex also do things like that?
>
> We should take the good bits from all that and make something of it. And I
> think its easier now that we have the per task and per rq utilization numbers
> [1].

IMHO proper packing (capacity management) is a quite complex problem,
that will require a major modifications to the load-balance logic if we
want to integrate it there. Essentially getting rid of all the implicit
assumptions that only made sense when task load weight was static and we
didn't have a clue about the true cpu load.

I don't think a load-balance code clean up can be avoided even if we go
with the power scheduler scheduler design. For example, the scaling of
load weight by priority makes packing based on task load weight so
conservative that it is not usable. Any tiny high priority task may
completely take over a cpu if it happens to be on the runqueue during
load balance. Vincent and Alex don't use task load weight in their
packing patches but use their own metrics instead.

I agree that we should take the good bits of those patches, but they are
far from the complete solution we are looking for in their current form.

The proposed design would let us deal with the complexity of interacting
power drivers and capacity management outside the main scheduler and use
it more or less unmodified. At lest to begin with. Down the line, we
will have to have a look at the load balance logic. But hopefully it
will be simpler or at least not more complex than it is now.

> 
> Just start by changing the balancer to pack instead of spread. Once that works,
> see where the two modes diverge and put a knob in.
> 
> Then worry about power thingies.

I don't think packing and the power stuff can be considered completely
orthogonal. Packing should to take power stuff like frequency domains
and cluster/package C-states into account.


> 
> I'm not entirely sold on differentiating between short running and other tasks
> either. Although I suppose I see where that comes from. A task that would run
> 50% on a big core would unlikely be qualified as small, however if it would
> require 85% of a small core and there's room on the small cores its a good move
> to run it there.
> 
> So where's the limit for being small? It seems like an artificial limit and
> such should be avoided where possible.

I agree. But having too many small tasks on a single cpu to get to 90%
(or whatever we consider to be full) is not ideal either as the tasks
may wait for very long to run compared to their actual running time.

Vincent's patches actually tries to address this problem by reducing the
'full' threshold depending when the number of tasks on the cpu
increases. If I remember correctly, Vincent has removed the small task
limit in his latest patches.

For packing, I don't think we need a strict limit for when a task is
small. Just pack until the cpu is full or the running/runnable ratio of
the tasks on the runqueue gets too low.
There is no small task limit in the very simplistic packing done in this
patch set either.

Part of the reason for trying to identify small tasks is that these are
often not performance sensitive. This is related to the 'which task is
important/this task is performance sensitive' discussion.

Morten

