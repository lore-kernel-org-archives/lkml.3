Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759672Ab3FCTl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 15:41:28 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:46708 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758726Ab3FCTl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 15:41:26 -0400
Date: Mon, 3 Jun 2013 21:41:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH RFC -tip 0/6] perf: IRQ-bound performance events
Message-ID: <20130603194101.GB31107@somewhere>
References: <20130603094132.GB30878@dhcp-26-207.brq.redhat.com>
 <20130603122223.GA1999@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130603122223.GA1999@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 02:22:23PM +0200, Ingo Molnar wrote:
> 
> * Alexander Gordeev <agordeev@redhat.com> wrote:
> 
> > This patchset is against perf/core branch.
> > 
> > As Linux is able to measure task-bound and CPU-bound performance
> > events there are no convenient means to monitor performance of
> > an execution context which requires control and tuning probably
> > most - interrupt service routines.
> > 
> > This series is an attempt to introduce IRQ-bound performance
> > events - ones that only count in a context of a hardware interrupt
> > handler.
> > 
> > The implementation is pretty straightforward: an IRQ-bound event
> > is registered with the IRQ descriptor and gets enabled/disabled
> > using new PMU callbacks: pmu_enable_irq() and pmu_disable_irq().
> > 
> > The series has not been tested thoroughly and is a concept proof
> > rather than a decent implementation: no group events could be be
> > loaded, inappropriate (i.e. software) events are not rejected,
> > only Intel and AMD PMUs were tried for 'perf stat', only Intel
> > PMU works with precise events. Perf tool changes are just a hack.
> > 
> > Yet, I would like first to ensure if the approach taken is not
> > screwed and I did not miss anything vital. Not to mention if the
> > change is wanted at all.
> > 
> > Below is a sample session on a machine with x2apic in cluster mode.
> > IRQ number is passed using new argument -I <irq> (please nevermind
> > '...process id '8'...' in the output for now):
> 
> Looks useful.
> 
> I think the main challenges are:
> 
>  - Creating a proper ABI for all this:
> 
>    - IRQ numbers alone are probably not specific enough: we'd also want to 
>      be more specific to match on handler names - or handler numbers if
>      the handler name is not unique.
> 
>    - another useful variant would be where IRQ numbers are too specific:
>      something like 'perf top irq' would be a natural thing to do, to see 
>      only overhead in hardirq execution - without limiting it to a
>      specific handler. An 'all irq contexts' wildcard concept?
> 
>  - Covering softirqs as well. If we handle both hardirqs and softirqs,
>    then we are pretty much feature complete: all major context types that 
>    the Linux kernel cares about are covered in instrumentation. For things
>    like networking the softirq overhead is obviously very important, and 
>    for example on routers it will do most of the execution.
> 
>  - Covering threaded IRQs as well, in a similar model. So if someone types
>    'perf top irq', and some IRQ handlers are running threaded, those
>    should probaby be included as well.
> 
>  - Making the tooling friendlier: 'perf top irq' would be useful, and
>    accepting handler names would be useful as well.

How about we define finegrained context on top of perf events themselves?
Like we could tell perf to count a task's instructions only after
tracepoint:irq_entry is hit and stop counting when tracepoint:irq_exit.

This way we can define any kind of fine grained context, not just irqs. We
are not short on tracepoints, software events, breakpoints, kprobes, uprobes
to play Legos there.

I had a branch with a working draft of that:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
  	perf/custom-ctx-v2-pre

Frederic Weisbecker (5):
      perf: Starter and stopper events
      perf: New enable_on_starter attribute
      perf: Support for starter and stopper in tools
      perf: New --enable-on-starter option
      perf: Add TODOs for event defined context

It needs quite some improvements, (some are listed in the TODO on the last commit)
especially in both the kernel and user interfaces.

Jiri had some nice ideas about it.

Also Peter was unhappy about how starter/stopper events were inherited in children
events because it complicated the inheritance code, which I totally agree with, although
I couldn't think of a better way by that time. Then I got distracted with other things so
this was the last iteration.

But it can be an interesting starting point. I'm convinced this can be a great feature!
Think about all the user contexts we can define with uprobes for example.

Thanks.
