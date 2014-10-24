Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbaJXMk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 08:40:28 -0400
Received: from smtpauth13.mfg.siteprotect.com ([64.26.60.145]:39967 "EHLO
	smtpauth03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756090AbaJXMk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 08:40:27 -0400
Date: Fri, 24 Oct 2014 08:41:12 -0400 (EDT)
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
In-Reply-To: <20141023114228.GB12706@worktop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1410240835200.15577@pianoman.cluster.toy>
References: <cover.1413323611.git.luto@amacapital.net> <alpine.DEB.2.10.1410210003300.5251@pianoman.cluster.toy> <CALCETrV0UCodO7FAi2fXd9ED6K_RHs-0yb+P4Ubmo=EUKZs3gg@mail.gmail.com> <alpine.DEB.2.10.1410211057120.1451@pianoman.cluster.toy>
 <20141021160411.GF3219@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1410211255580.4491@pianoman.cluster.toy> <20141023114228.GB12706@worktop.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020201.544A48BA.00AF,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2014, Peter Zijlstra wrote:

> On Tue, Oct 21, 2014 at 01:05:49PM -0400, Vince Weaver wrote:

> > There are various reasons why you might want to start events at times
> > other than the beginning of the program.  Some people don't like kernel 
> > multiplexing so they start/stop manually if they want to switch eventsets.
> 
> I suppose you could pre-create all events and use ioctl()s to start/stop
> them where/when desired, this should be faster I think. But yes, this is
> not a use-case I've though much about.

The scheduling step is most of what makes the perf_event start call have 
high overhead.  The other annoyance is the fact that due to the NMI 
watchdog your can successfully perf_event_open() an event group but still 
have it fail at start time, so a lot of code has to be done that does 
extraneous open/start/close calls to make sure the events really fit.

> MAP_POPULATE is your friend there, but yes manually prefaulting is
> perfectly fine too, and the HPC people are quite familiar with the
> concept, they do it for a lot of things.

MAP_POPULATE actually has noticably more overhead than manually 
prefaulting.  It's on my todo list to drop ftrace on there and find out 
why, but I've been stuck chasing kernel-crashing fuzzer bugs instead in my 
spare time.

perfctr and possibly perfmon2 would automatically pre-fault the mmap page 
for you in the kernel, so there was no need for the user to do it.


In any case I wasn't really trying to make trouble here, it's just I came 
across the people using rdpmc w/o perf_event just the other day (on USENET 
of all places).  They were so happy it worked w/o patches now, that I felt 
bad breaking it to them that there were patches floating around that were 
going to make their usecase not work anymore.

I guess like all things though, you can't have anything fun and useful in 
the kernel without the security people taking it away.

Vince
