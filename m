Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab3JBLne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 07:43:34 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:57176 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab3JBLnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 07:43:33 -0400
Date: Wed, 2 Oct 2013 13:43:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, "Kleen, Andi" <andi.kleen@intel.com>,
        "Shishkin, Alexander" <alexander.shishkin@intel.com>
Subject: Re: PERF_EVENT_IOC_SET_OUTPUT
Message-ID: <20131002114327.GE7941@localhost.localdomain>
References: <524B1E7C.3070108@intel.com>
 <20131002100350.GO3081@twins.programming.kicks-ass.net>
 <20131002102954.GD7941@localhost.localdomain>
 <20131002112730.GQ3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002112730.GQ3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 01:27:30PM +0200, Peter Zijlstra wrote:
> On Wed, Oct 02, 2013 at 12:29:56PM +0200, Frederic Weisbecker wrote:
> > On Wed, Oct 02, 2013 at 12:03:50PM +0200, Peter Zijlstra wrote:
> > > On Tue, Oct 01, 2013 at 10:11:56PM +0300, Adrian Hunter wrote:
> > > > Hi
> > > > 
> > > > It does not seem possible to use set-output between
> > > > task contexts of different types (e.g. a software event
> > > > to a hardware event)
> > > > 
> > > > If you look at perf_event_set_output():
> > > > 
> > > >           /*
> > > >            * If its not a per-cpu rb, it must be the same task.
> > > >            */
> > > >           if (output_event->cpu == -1 && output_event->ctx != event->ctx)
> > > >                   goto out;
> > > > 
> > > > ctx (perf_event_context) won't be the same for events
> > > > of different types.  Is this restriction necessary?
> > > 
> > > Hmm.. so last night I wrote me a big reply saying we couldn't do it;
> > > then this morning I reconsidered and thing that something like:
> > > 
> > >   output_event->ctx->task != event->ctx->task
> > > 
> > > should actually work.
> > > 
> > > The reason it should be OK I think is because perf_mmap() will refuse to
> > > create a buffer for inherited events that have ->cpu == -1.
> > > 
> > > My initial response was going to say that it wouldn't be possible
> > > because __perf_event_task_sched_out() could 'break' one ctx while still
> > > swapping the other, at which point the buffer would have to service two
> > > different tasks, potentially from different CPUs and with the buffers
> > > not actually being SMP safe that's a problem.
> > 
> > I don't get what you mean with breaking or swapping a ctx.
> > But I can confirm that perf_mmap() won't allow a buffer to be remotely
> > accessed from another CPU. Now there may be other issues than locality which
> > I'm missing :)
> 
> The way we 'optimize' context switches between tasks with identical
> contexts is to simply swap the context and leave the hardware alone.
> 
> So counters belonging to prev will then belong to next and vice versa.
> This avoids having to read hardware counters, update stats, removes
> counters from hardware, and re-program hardware with possible the exact
> same set.
> 
> When a child context changes its context (eg, inserts or removes a
> counter) we break this swapping because now the contexts don't match
> anymore and we have to take the slow and painful way of prodding
> hardware.

Ah right, I remember that now. This caused me quite some headaches
a few years ago :)
