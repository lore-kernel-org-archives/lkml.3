Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab3KUNaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 08:30:18 -0500
Received: from www.linutronix.de ([62.245.132.108]:39401 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3KUNaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 08:30:17 -0500
Date: Thu, 21 Nov 2013 14:30:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Tony Luck <tony.luck@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [patch 4/6] ia64: Use preempt_schedule_irq
In-Reply-To: <20131121130605.GE10022@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.02.1311211428450.30673@ionos.tec.linutronix.de>
References: <20130917082838.218329307@infradead.org> <20130917182350.449685712@linutronix.de> <20130917183628.857145384@linutronix.de> <CA+8MBbKq1idWt1OSpRM3mWMDAQaEoewrU=h=m_pFoidVy6OA-Q@mail.gmail.com> <alpine.DEB.2.02.1311202121340.30673@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1311211230030.30673@ionos.tec.linutronix.de> <20131121130605.GE10022@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Nov 2013, Peter Zijlstra wrote:

> On Thu, Nov 21, 2013 at 12:41:44PM +0100, Thomas Gleixner wrote:
> > On Wed, 20 Nov 2013, Thomas Gleixner wrote:
> > > On Wed, 20 Nov 2013, Tony Luck wrote:
> > > > asmlinkage void __sched preempt_schedule_irq(void)
> > > > {
> > > >            schedule();
> > > > }
> > > > 
> > > > Or is life more complicated than that?
> > > 
> > > Hmm, I think I fubared that and you decided to ignore my patch :) 
> > > 
> > > Let me look at it tomorrow morning with full awake brain cells.
> > 
> > Ok, wrapped my brain around it. I tripped over the magic asm foo which
> > has a single need_resched check and schedule point for both sys call
> > return and interrupt return.
> > 
> > So you need the schedule_preempt_irq() for kernel preemption from
> > interrupt return while on a normal syscall preemption a schedule would
> > be sufficient. But using schedule_preempt_irq() is not harmful here in
> > any way. It just sets the preempt_active bit also in cases where it
> > would not be required. 
> > 
> > Even on preempt=n kernels adding the preempt_active bit is completely
> > harmless. So instead of having an extra function, moving the existing
> > one out of the ifdef PREEMPT looks like the sanest thing to do.
> > 
> > Peter, Ingo ?
> 
> Uhm, preempt_schedule_irq() assumes interrupts are disabled and
> explicitly returns with interrupts disabled again. Does the ia64
> callsite conform?

Yep.
 
> If so, schedule() would actually be actively wrong, because that will
> whinge when called with interrupts disabled, and will return with
> interrupts enabled.
> 
> Anyway, I don't object to the patch per se, but it might bloat a few
> !ia64 kernels for having to carry the extra text.
 
Well, we could get rid of quite some other sti/schedule/cli asm magic
all over the archs.

Thanks,

	tglx
