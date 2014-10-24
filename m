Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbaJXWO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 18:14:57 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:47291 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaJXWOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 18:14:55 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1410240835200.15577@pianoman.cluster.toy>
References: <cover.1413323611.git.luto@amacapital.net> <alpine.DEB.2.10.1410210003300.5251@pianoman.cluster.toy>
 <CALCETrV0UCodO7FAi2fXd9ED6K_RHs-0yb+P4Ubmo=EUKZs3gg@mail.gmail.com>
 <alpine.DEB.2.10.1410211057120.1451@pianoman.cluster.toy> <20141021160411.GF3219@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1410211255580.4491@pianoman.cluster.toy> <20141023114228.GB12706@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1410240835200.15577@pianoman.cluster.toy>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 24 Oct 2014 15:14:33 -0700
Message-ID: <CALCETrWmtOPP115dCo1vEckNVdF5EZceu+r-C8XU9HzHGf62uQ@mail.gmail.com>
Subject: Re: [RFC 0/5] CR4 handling improvements
To: Vince Weaver <vince@deater.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 5:41 AM, Vince Weaver <vince@deater.net> wrote:
> On Thu, 23 Oct 2014, Peter Zijlstra wrote:
>
>> On Tue, Oct 21, 2014 at 01:05:49PM -0400, Vince Weaver wrote:
>
>> > There are various reasons why you might want to start events at times
>> > other than the beginning of the program.  Some people don't like kernel
>> > multiplexing so they start/stop manually if they want to switch eventsets.
>>
>> I suppose you could pre-create all events and use ioctl()s to start/stop
>> them where/when desired, this should be faster I think. But yes, this is
>> not a use-case I've though much about.
>
> The scheduling step is most of what makes the perf_event start call have
> high overhead.  The other annoyance is the fact that due to the NMI
> watchdog your can successfully perf_event_open() an event group but still
> have it fail at start time, so a lot of code has to be done that does
> extraneous open/start/close calls to make sure the events really fit.
>
>> MAP_POPULATE is your friend there, but yes manually prefaulting is
>> perfectly fine too, and the HPC people are quite familiar with the
>> concept, they do it for a lot of things.
>
> MAP_POPULATE actually has noticably more overhead than manually
> prefaulting.  It's on my todo list to drop ftrace on there and find out
> why, but I've been stuck chasing kernel-crashing fuzzer bugs instead in my
> spare time.

Have you checked recently?  IIRC Michael Lespinasse put some effort
into improving MAP_POPULATE recently.

>
> perfctr and possibly perfmon2 would automatically pre-fault the mmap page
> for you in the kernel, so there was no need for the user to do it.
>
>
> In any case I wasn't really trying to make trouble here, it's just I came
> across the people using rdpmc w/o perf_event just the other day (on USENET
> of all places).  They were so happy it worked w/o patches now, that I felt
> bad breaking it to them that there were patches floating around that were
> going to make their usecase not work anymore.
>
> I guess like all things though, you can't have anything fun and useful in
> the kernel without the security people taking it away.

I'm sympathetic enough to this use case that I don't really mind
adding a bit of code to support rdpmc=2 meaning that rdpmc is always
allowed.  Switching in and out of rdpmc=2 mode will be expensive
(static key and IPI to all CPUs).  PeterZ, is that OK with you?

--Andy

>
> Vince



-- 
Andy Lutomirski
AMA Capital Management, LLC
