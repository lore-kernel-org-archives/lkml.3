Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbaGNJEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 05:04:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:37630 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaGNJEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 05:04:43 -0400
Date: Mon, 14 Jul 2014 11:04:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [patch 54/55] timekeeping: Provide fast and NMI safe access to
 CLOCK_MONOTONIC[_RAW]
In-Reply-To: <20140714083753.GK9918@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1407141100280.4357@nanos>
References: <20140711133623.530368377@linutronix.de> <20140711133709.835700036@linutronix.de> <20140714083753.GK9918@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2014, Peter Zijlstra wrote:
> On Fri, Jul 11, 2014 at 01:45:19PM -0000, Thomas Gleixner wrote:
> > Tracers want a correlated time between the kernel instrumentation and
> > user space. We really do not want to export sched_clock() to user
> > space, so we need to provide something sensible for this.
> > 
> > Using separate data structures with an non blocking sequence count
> > based update mechanism allows us to do that. The data structure
> > required for the readout has a sequence counter and two copies of the
> > timekeeping data.
> > 
> > On the update side:
> > 
> >   tkf->seq++;
> >   smp_wmb();
> >   update(tkf->base[0], tk;
> >   tkf->seq++;
> >   smp_wmb();
> >   update(tkf->base[1], tk;
> > 
> > On the reader side:
> > 
> >   do {
> >      seq = tkf->seq;
> >      smp_rmb();
> >      idx = seq & 0x01;
> >      now = now(tkf->base[idx]);
> >      smp_rmb();
> >   } while (seq != tkf->seq)
> > 
> > So if NMI hits the update of base[0] it will use base[1] which is
> > still consistent. In case of CLOCK_MONOTONIC this can result in
> > slightly wrong timestamps (a few nanoseconds) accross an update. Not a
> > big issue for the intended use case.
> 
> But it breaks monotonicity, right? ;-)

It can in theory, but does it really matter for tracing?
 
> Also, what happens when TSC is not available as a clocksource? There's
> still a metric ton of hardware (including the latest generation HSW)
> that has fucked firmware/TSC.

Well, bad luck then. You end up using hpet or worse, but it's still
your decision whether to base your instrumentation on that or not. For
sane clock sources (i.e. almost anything except TSC) it works
perfectly fine.

Thanks,

	tglx
