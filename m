Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbaJWLmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:42:42 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43073 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377AbaJWLmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:42:40 -0400
Date: Thu, 23 Oct 2014 13:42:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vince@deater.net>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>
Subject: Re: [RFC 0/5] CR4 handling improvements
Message-ID: <20141023114228.GB12706@worktop.programming.kicks-ass.net>
References: <cover.1413323611.git.luto@amacapital.net>
 <alpine.DEB.2.10.1410210003300.5251@pianoman.cluster.toy>
 <CALCETrV0UCodO7FAi2fXd9ED6K_RHs-0yb+P4Ubmo=EUKZs3gg@mail.gmail.com>
 <alpine.DEB.2.10.1410211057120.1451@pianoman.cluster.toy>
 <20141021160411.GF3219@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1410211255580.4491@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1410211255580.4491@pianoman.cluster.toy>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 01:05:49PM -0400, Vince Weaver wrote:
> On Tue, 21 Oct 2014, Peter Zijlstra wrote:
> 
> > > perf_event is also fairly high overhead for setting up and starting 
> > > events,
> > 
> > Which you only do once at the start, so is that really a problem?
> 
> There are various reasons why you might want to start events at times
> other than the beginning of the program.  Some people don't like kernel 
> multiplexing so they start/stop manually if they want to switch eventsets.

I suppose you could pre-create all events and use ioctl()s to start/stop
them where/when desired, this should be faster I think. But yes, this is
not a use-case I've though much about.

> But no, I suppose you could ask anyone wanting to use rdpmc to open some 
> sort of dummy event at startup just to get cr4 enabled.

That's one work-around :-)

> > I still don't get that argument, 2 rdpmc's is cheaper than doing wrmsr,
> > not to mention doing wrmsr through a syscall. And looking at that mmap
> > page is 1 cacheline. Is that cacheline read (assuming you miss) the real
> > problem?
> 
> Well at least by default the first read of the mmap page causes a 
> pagefault which adds a few thousand cycles of latency.  Though you can
> somewhat get around this by prefaulting it in at some point.

MAP_POPULATE is your friend there, but yes manually prefaulting is
perfectly fine too, and the HPC people are quite familiar with the
concept, they do it for a lot of things.

> Anyway I'm just reporting numbers I get when measuring the overhead of 
> the old perfctr interface vs perf_event on typical PAPI workloads.  It's 
> true you can re-arrange calls and such so that perf_event behaves better 
> but that involves redoing a lot of existing code.

OK agreed, having to change existing code is often subject to various
forms of inertia/resistance. And yes I cannot deny that some of the
features perf has come at the expense of various overheads, however hard
we're trying to keep costs down.

> I do appreciate the trouble you've gone through keeping self-monitoring 
> working considering the fact that I'm the only user admitting to using it.

I have some code somewhere that uses it too, I've tried pushing it off
to other people but so far there are no takers :-)
