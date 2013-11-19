Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab3KSOk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:40:28 -0500
Received: from www.linutronix.de ([62.245.132.108]:56067 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab3KSOk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:40:26 -0500
Date: Tue, 19 Nov 2013 15:39:54 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: NeilBrown <neilb@suse.de>, Jonathan Corbet <corbet@lwn.net>,
        Dean Nelson <dcn@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        Marek Belisko <marek@goldelico.com>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH/RFC] wait_for_completion_timeout() considered harmful.
In-Reply-To: <20131119122322.GM3866@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.02.1311191512440.30673@ionos.tec.linutronix.de>
References: <20131117080603.2a0d3b6d@notabene.brown> <20131118152746.937b2b7971d7a4bba4ef996d@linux-foundation.org> <20131119104438.6d45828b@notabene.brown> <20131119082548.GD10022@twins.programming.kicks-ass.net> <20131119195851.26bee8e6@notabene.brown>
 <20131119122322.GM3866@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Nov 2013, Peter Zijlstra wrote:
> On Tue, Nov 19, 2013 at 07:58:51PM +1100, NeilBrown wrote:
> > 	/*
> > 	 * TODO: Make sure that we wait at least required delay but why we
> > 	 * have to extend it one tick more?
> > 	 */
> > 	schedule_timeout_interruptible(msecs_to_jiffies(delay) + 2);
> 
> What makes me sad is that clearly people knew stuff was broken but
> somehow it never got properly fixed.
> 
> Yes, changing something like this is risky, but I prefer to fix the
> implementation to the sane and documented behaviour and fix up whatever
> fallout that generates. The end result is saner code in general and less
> new bugs.
 
The underlying issue of the timer wheel is that it is driven by a
coarse grained tick.

So a schedule_timeout(1) is guaranteed to sleep until the next tick
arrives. There is no way to figure out whether the timer was started
right at the beginning of a tick period or right at the end.

This has been the case from day one of the timer wheel.

The user space interfaces [clock_]nanosleep and the various posix
timers had countermeasures based on gettimeofday() to guarantee the
correct behaviour. glibc still has some extra checks around some
timeout related syscalls for that reason. We killed that mess when we
converted them over to hrtimers.

So if you really want to make sure that you slept at minimum the given
number of ticks with the timer wheel, then you have only one choice:

       Add unconditionally 1 to the given number of ticks

I don't think that this will cause a massive fallout as the timing of
the timer_list timers already varies by an order of magnitude due to
the HZ settings. So anything which relies on the timer wheel in terms
of precision is hosed already. So adding 1 will just hose it some
more.

Thanks,

	tglx
