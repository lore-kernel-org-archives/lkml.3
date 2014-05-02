Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaEBGhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 02:37:06 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:63818 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbaEBGhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 02:37:03 -0400
Message-ID: <1399012619.5233.76.camel@marge.simpson.net>
Subject: Re: [PATCH RFC/TEST] sched: make sync affine wakeups work
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, morten.rasmussen@arm.com, mingo@kernel.org,
        peterz@infradead.org, george.mccollister@gmail.com,
        ktkhai@parallels.com
Date: Fri, 02 May 2014 08:36:59 +0200
In-Reply-To: <53633645.9090308@redhat.com>
References: <20140502004237.79dd3de6@annuminas.surriel.com>
	 <1399008721.5233.35.camel@marge.simpson.net>
	 <1399010337.5233.50.camel@marge.simpson.net> <53633645.9090308@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-02 at 02:08 -0400, Rik van Riel wrote: 
> On 05/02/2014 01:58 AM, Mike Galbraith wrote:
> > On Fri, 2014-05-02 at 07:32 +0200, Mike Galbraith wrote: 
> >> On Fri, 2014-05-02 at 00:42 -0400, Rik van Riel wrote: 
> >>> Currently sync wakeups from the wake_affine code cannot work as
> >>> designed, because the task doing the sync wakeup from the target
> >>> cpu will block its wakee from selecting that cpu.
> >>>
> >>> This is despite the fact that whether or not the wakeup is sync
> >>> determines whether or not we want to do an affine wakeup...
> >>
> >> If the sync hint really did mean we ARE going to schedule RSN, waking
> >> local would be a good thing.  It is all too often a big fat lie.
> > 
> > One example of that is say pgbench.  The mother of all work (server
> > thread) for that load wakes with sync hint.  Let the server wake the
> > first of a small herd CPU affine, and that first wakee then preempt the
> > server (mother of all work) that drives the entire load.
> > 
> > Byebye throughput.
> > 
> > When there's only one wakee, and there's really not enough overlap to at
> > least break even, waking CPU affine is a great idea.  Even when your
> > wakees only run for a short time, if you wake/get_preempted repeat, the
> > load will serialize.
> 
> I see a similar issue with specjbb2013, with 4 backend and
> 4 frontend JVMs on a 4 node NUMA system.
> 
> The NUMA balancing code nicely places the memory of each JVM
> on one NUMA node, but then the wake_affine code will happily
> run all of the threads anywhere on the system, totally ruining
> memory locality.

Hm, I thought numasched got excessive pull crap under control.  For
steady hefty loads, you want to kill all but periodic load balancing
once the thing gets cranked up.  The less you move tasks, the better the
load will perform.  Bursty loads exist too though, damn the bad luck.

> The front end and back end only exchange a few hundred messages
> a second, over loopback tcp, so the switching rate between
> threads is quite low...
> 
> I wonder if it would make sense for wake_affine to be off by
> default, and only switch on when the right conditions are
> detected, instead of having it on by default like we have now?

Not IMHO, but I have seen situations where that was exactly what I
recommended to fix the throughput problem the user was having.

Reason why is that case was on a box where FAIR_SLEEPERS is disabled by
default, meaning there is no such thing as wakeup preemption.  Guess
what happens when you don't have shared LLC for a fast/light wakee to
escape to when the waker is a pig.  The worst thing possible in that
case is to wake affine.  Leave the poor thing wherever it was, else it
will take a latency hit that need not have been.

> I have some ideas on that, but I should probably catch some
> sleep before trying to code them up :)

Yeah, there are many aspects to ponder.

> Meanwhile, the test patch that I posted may help us figure out
> whether the "sync" option in the current wake_affine code does
> anything useful.

If I had a NAK stamp and digital ink pad, that patch wouldn't be
readable, much less applicable ;-)

-Mike

