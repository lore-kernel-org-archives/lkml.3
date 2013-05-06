Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab3EFJZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 05:25:42 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:63605 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab3EFJZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 05:25:41 -0400
Date: Mon, 6 May 2013 11:25:37 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fr?d?ric Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL, RFC] Full dynticks, CONFIG_NO_HZ_FULL feature
Message-ID: <20130506092537.GA8879@gmail.com>
References: <20130505110351.GA4768@gmail.com>
 <CA+55aFzPHkCH7CVZ4tkaF91+=GLZAxxncTq0J9d6AKpSPqovZw@mail.gmail.com>
 <20130505212511.GC3659@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130505212511.GC3659@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Sun, May 05, 2013 at 01:33:45PM -0700, Linus Torvalds wrote:
> > On Sun, May 5, 2013 at 4:03 AM, Ingo Molnar <mingo@kernel.org> wrote:
> > >
> > > Please consider pulling the latest timers-nohz-for-linus git tree from:
> > 
> > Ok, it seems to work for me, so pulled.
> > 
> > However, by "work for me" I mean "doesn't actually seem to make any
> > difference for me". Maybe I'm odd, but the most common situation is
> > either a fairly idle machine (in which case the old NOHZ did fine) or
> > a fairly over-crowded one when I'm running something sufficiently
> > threaded (in which case the new NOHZ_FULL doesn't do anything either).
> > 
> > So I really hope the "cpu has more than one running thread" case is
> > getting a lot of attention. Not for 3.10, but right now it seems to
> > still result in the same old 1kHz timer interrupts..
> > 
> > So I haven't actually found a real load where any of this makes a
> > noticeable *difference*.
> 
> The workloads where we expect the most noticeable differences are HPC 
> workloads with short iterations and a HPC-style barrier between each 
> interation on the one hand and real-time workloads on the other. My 
> guess is that you aren't doing too much of either.

I think Linus might have referred to my 'future plans' entry:

| Future plans:
|
| - there's ongoing work to reduce 1Hz to 0Hz, to essentially shut
|   off the periodic tick altogether when there's a single busy task on a
|   CPU. We'd first like 1 Hz to be exposed more widely before we go for
|   the 0 Hz target though.
|
| - once we reach 0 Hz we can and remove the periodic tick assumption from
|   nr_running>=2 as well, by essentially interrupting busy tasks only as
|   frequently as the sched_latency constraints require us to do - once
|   every 4-40 msecs, depending on nr_running.

and indicated that in practice desktop and developer workload will see the 
full win from reduced HZ only once we implement those two points and 
extend the scope of dynticks even more and make HZ truly variable 
regardless of rq->nr_running.

> We do have some measurements taken on an early prototype of this patchset,
> which are on slides 5 and 6 of:
> 
> http://linuxplumbersconf.org/2009/slides/Josh-Triplett-painless-kernel.pdf
> 
> This is for an HPC workload with a 100-microsecond iteration time.

Interesting that HZ=1000 caused 8% overhead there. On a regular x86 server 
PC I've measured the HZ=1000 overhead to pure user-space execution to be 
around 1% (sometimes a bit less, sometimes a bit more).

But even 1% is worth it.

Thanks,

	Ingo
