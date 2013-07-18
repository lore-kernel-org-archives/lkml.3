Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617Ab3GRKpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 06:45:32 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:64473 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757497Ab3GRKpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 06:45:31 -0400
Date: Thu, 18 Jul 2013 12:45:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Hunter <ahh@google.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [RFC] [PATCH] x86: avoid per_cpu for APIC id tables
Message-ID: <20130718104527.GE23558@gmail.com>
References: <1374090073-1957-1-git-send-email-ahh@google.com>
 <20130718065249.GA17622@gmail.com>
 <20130718085542.GE27075@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718085542.GE27075@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Jul 18, 2013 at 08:52:49AM +0200, Ingo Molnar wrote:
> > 
> > * Andrew Hunter <ahh@google.com> wrote:
> > 
> > > Hi, I have a patch (following) that modifies handling of APIC id tables,
> > > trading a small amount of space in the (NR_CPUS - nr_cpu_ids) >> 0 case for
> > > faster accesses and slightly better cache layout (as APIC ids are mostly used
> > > cross-cpu.)  I'm not an APIC expert so I'd appreciate some eyes on this, but
> > > it shouldn't change any behavior whatsoever.  Thoughts? (We're likely to merge
> > > this internally even if upstream judges the space loss too much of a cost, so
> > > I'd like to know if there's some other problem I've missed that this causes.)
> > > 
> > > I've tested this cursorily in most of our internal configurations but not in
> > > any particularly exotic hardware/config.
> > > 
> > > 
> > > From e6bf354c05d98651e8c27f96582f0ab56992e58a Mon Sep 17 00:00:00 2001
> > > From: Andrew Hunter <ahh@google.com>
> > > Date: Tue, 16 Jul 2013 16:50:36 -0700
> > > Subject: [PATCH] x86: avoid per_cpu for APIC id tables
> > > 
> > > DEFINE_PER_CPU(var) and friends go to lengths to arrange all of cpu
> > > i's per cpu variables as contiguous with each other; this requires a
> > > double indirection to reference a variable.
> > > 
> > > For data that is logically per-cpu but
> > > 
> > > a) rarely modified
> > > b) commonly accessed from other CPUs
> > > 
> > > this is bad: no writes means we don't have to worry about cache ping
> > > pong, and cross-CPU access means there's no cache savings from not
> > > pulling in remote entries.  (Actually, it's worse than "no" cache
> > > savings: instead of one cache line containing 32 useful APIC ids, it
> > > will contain 3 useful APIC ids and much other percpu data from the
> > > remote CPU we don't want.)  It's also slower to access, due to the
> > > indirection.
> > > 
> > > So instead use a flat array for APIC ids, most commonly used for IPIs
> > > and the like.  This makes a measurable improvement (up to 10%) in some
> > > benchmarks that heavily stress remote wakeups.
> > > 
> > > The one disadvantage is that we waste 8 bytes per unused CPU (NR_CPUS
> > > - actual). But this is a fairly small amount of memory for reasonable
> > > values of NR_CPUS.
> > > 
> > > Tested: builds and boots, runs a suite of wakeup-intensive test without failure.
> > 
> > 1)
> > 
> > To make it easier to merge such patches it would also be nice to integrate 
> > a remote wakeup performance test into 'perf bench sched pipe', so that we 
> > can measure it more easily. You can also cite the results in your 
> > changelog.
> 
> While one could base the code (or even share) it with pipe, I'd like it 
> to appear a different benchmark from the outside. Also I'm fairly sure 
> they have a benchmark for this. Venki started this work, it looks like 
> Andrew is taking over, good! :-)

Do you mean it should be in a separate 'perf bench sched remote-wakeup' 
benchmark, appearing as a separate benchmark to the user? Agreed with 
that.

Thanks,

	Ingo
