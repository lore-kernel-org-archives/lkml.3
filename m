Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbaBYL3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:29:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38588 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbaBYL3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:29:41 -0500
Date: Tue, 25 Feb 2014 12:29:36 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, Dave P Martin <Dave.Martin@arm.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 4/7] perf: be less pessimistic when scheduling events
Message-ID: <20140225112936.GM9987@twins.programming.kicks-ass.net>
References: <1392054264-23570-1-git-send-email-mark.rutland@arm.com>
 <1392054264-23570-5-git-send-email-mark.rutland@arm.com>
 <20140210175854.GB27965@twins.programming.kicks-ass.net>
 <20140211174804.GC12476@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211174804.GC12476@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 05:48:05PM +0000, Mark Rutland wrote:
> On Mon, Feb 10, 2014 at 05:58:54PM +0000, Peter Zijlstra wrote:
> > On Mon, Feb 10, 2014 at 05:44:21PM +0000, Mark Rutland wrote:
> > > This patch makes ctx_flexible_sched_in attempt to schedule every group
> > > in the flexible_groups list even when earlier groups failed to schedule,
> > > enabling more groups to be scheduled simultaneously.
> > 
> > Since you're basically free to create as many events as you want, you can
> > (as an unprivilidged user) make the context switch to and from your task
> > arbitrarily expensive.
> 
> Not that it makes the approach any better, but surely this is already
> the case for software events? 

Yeah, software events are a problem; I realized this the moment I send
that email. However, software events do not have the O(n!) programming
fail hw events have.

AMD Fam15h has a O(n^4) termination of the O(n*n!) algorithm, the rest
of x86 has a normal O(n^2) bound.

> I can create as many as I want, and they'll always try to schedule.
> 
> I'll take a look into other ways to stop disparate PMUs' events from
> adversely affecting each other. I guess it might not be possible to
> solve the general problem without allowing said expensive context
> switch.

So the problem you're facing is that you'll attach events for each PMU
available on the system to a particular task? And simply want to
continue scheduling even though a particular event will never fit on the
CPUs PMU its currently running on?

So the trivial work-around would be to create an event per cpu and set
event->cpu. That way you'll get the event_filter_match() exception in
ctx_flexible_sched_in() and we'll skip over all events that cannot be
programmed on this CPU.

The other approach is adding a cpumask to events, which would
drastically cut down on the amount of events you'd need to create; then
again, ARM doesn't have a silly amount of CPUs x86 has just quite yet.
