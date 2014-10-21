Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933343AbaJURFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 13:05:07 -0400
Received: from smtpauth05h.mfg.siteprotect.com ([64.26.60.146]:34792 "EHLO
	smtpauth05.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933101AbaJURFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 13:05:05 -0400
Date: Tue, 21 Oct 2014 13:05:49 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Peter Zijlstra <peterz@infradead.org>
cc: Andy Lutomirski <luto@amacapital.net>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>
Subject: Re: [RFC 0/5] CR4 handling improvements
In-Reply-To: <20141021160411.GF3219@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1410211255580.4491@pianoman.cluster.toy>
References: <cover.1413323611.git.luto@amacapital.net> <alpine.DEB.2.10.1410210003300.5251@pianoman.cluster.toy> <CALCETrV0UCodO7FAi2fXd9ED6K_RHs-0yb+P4Ubmo=EUKZs3gg@mail.gmail.com> <alpine.DEB.2.10.1410211057120.1451@pianoman.cluster.toy>
 <20141021160411.GF3219@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020208.5446923F.03A4,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2014, Peter Zijlstra wrote:

> > perf_event is also fairly high overhead for setting up and starting 
> > events,
> 
> Which you only do once at the start, so is that really a problem?

There are various reasons why you might want to start events at times
other than the beginning of the program.  Some people don't like kernel 
multiplexing so they start/stop manually if they want to switch eventsets.

But no, I suppose you could ask anyone wanting to use rdpmc to open some 
sort of dummy event at startup just to get cr4 enabled.

> I still don't get that argument, 2 rdpmc's is cheaper than doing wrmsr,
> not to mention doing wrmsr through a syscall. And looking at that mmap
> page is 1 cacheline. Is that cacheline read (assuming you miss) the real
> problem?

Well at least by default the first read of the mmap page causes a 
pagefault which adds a few thousand cycles of latency.  Though you can
somewhat get around this by prefaulting it in at some point.

Anyway I'm just reporting numbers I get when measuring the overhead of 
the old perfctr interface vs perf_event on typical PAPI workloads.  It's 
true you can re-arrange calls and such so that perf_event behaves better 
but that involves redoing a lot of existing code.

I do appreciate the trouble you've gone through keeping self-monitoring 
working considering the fact that I'm the only user admitting to using it.

Adding perf_event rdpmc support to PAPI has been stalled for a while due 
to various reasons.  So that's why I haven't been finding the various bugs 
that have been turning up.  The PAPI perf_event component really needs a 
complete from-scratch re-write, but that's made tricky because we have to 
be backwards compatible and workaround all the pre-2.6.36 perf_event bugs.
You wouldn't think anyone would care, but the most vocal users are all 
RHEL 6 users running the monstrosity of a 2.6.32 kernel that is patched 
full of all kinds of crazy back-ported perf_event patches, and that is 
always breaking PAPI in fun and exciting ways.

Vince
