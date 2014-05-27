Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbaE0OVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 10:21:15 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55742 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbaE0OVM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 10:21:12 -0400
Date: Tue, 27 May 2014 16:21:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: Fix mux_interval hrtimer wreckage
Message-ID: <20140527142106.GA19143@laptop.programming.kicks-ass.net>
References: <20140520090258.GR2485@laptop.programming.kicks-ass.net>
 <CABPqkBQC-uiqHy+OWKZviLH1BnzLV1=nbyR0CHsokNH_38OXfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CABPqkBQC-uiqHy+OWKZviLH1BnzLV1=nbyR0CHsokNH_38OXfw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 04:09:48PM +0200, Stephane Eranian wrote:
> On Tue, May 20, 2014 at 11:02 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > Subject: perf: Fix mux_interval hrtimer wreckage
> > From: Peter Zijlstra <peterz@infradead.org>
> > Date: Tue May 20 10:09:32 CEST 2014
> >
> > Thomas stumbled over the hrtimer_forward_now() in
> > perf_event_mux_interval_ms_store() and noticed its broken-ness.
> >
> > You cannot just change the expiry time of an active timer, it will
> > destroy the red-black tree order and cause havoc.
> >
> > Change it to (re)start the timer instead, (re)starting a timer will
> > dequeue and enqueue a timer and therefore preserve rb-tree order.
> >
> > Since we cannot enqueue remotely, wrap the thing in
> > cpu_function_call(), this however mandates that we restrict ourselves
> > to online cpus. Also serialize the entire setting so we don't get
> > multiple concurrent threads trying to update to different values.
> >
> > Also fix a problem in perf_mux_hrtimer_restart(), checking against
> > hrtimer_active() can actually loose us the timer when timer->state ==
> > HRTIMER_STATE_CALLBACK and the callback has already decided NORESTART.
> >
> > Furthermore it doesn't make any sense to test
> > hrtimer_callback_running() when we already tested hrtimer_active(),
> > but with the above change, we explicitly must call it when
> > callback_running.
> >
> > Lastly, rename a few functions:
> >
> >   s/perf_cpu_hrtimer_/perf_mux_hrtimer_/ -- because I could not find
> >                                             the mux timer function
> >
> >   s/\<hr\>/timer/ -- because that's the normal way of calling things.
> >
> > Fixes: 62b856397927 ("perf: Add sysfs entry to adjust multiplexing interval per PMU")
> > Cc: Stephane Eranian <eranian@google.com>
> > Reported-by: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> > Link: http://lkml.kernel.org/n/tip-ife5kqgnt7mviatc9fakz8wk@git.kernel.org
> 
> So, I tested this patch on tip.git and it panics my kernels as soon as
> I multiplex
> events. For instance running:
> $ perf stat -e cycles,cycles,cycles,cycles,cycles,cycles dd
> if=/dev/urandom of=/dev/null count=10000000
> 

Yeah, I hadn't actually tested it, but I did find more hrtimer wreckage
meanwhile and I've not yet figured out how to fix it so I put this on
hold for a little while.

I'll try and get the lot sorted soon though.
