Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab3KUNGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 08:06:18 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46695 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab3KUNGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 08:06:17 -0500
Date: Thu, 21 Nov 2013 14:06:05 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [patch 4/6] ia64: Use preempt_schedule_irq
Message-ID: <20131121130605.GE10022@twins.programming.kicks-ass.net>
References: <20130917082838.218329307@infradead.org>
 <20130917182350.449685712@linutronix.de>
 <20130917183628.857145384@linutronix.de>
 <CA+8MBbKq1idWt1OSpRM3mWMDAQaEoewrU=h=m_pFoidVy6OA-Q@mail.gmail.com>
 <alpine.DEB.2.02.1311202121340.30673@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1311211230030.30673@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311211230030.30673@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 12:41:44PM +0100, Thomas Gleixner wrote:
> On Wed, 20 Nov 2013, Thomas Gleixner wrote:
> > On Wed, 20 Nov 2013, Tony Luck wrote:
> > > asmlinkage void __sched preempt_schedule_irq(void)
> > > {
> > >            schedule();
> > > }
> > > 
> > > Or is life more complicated than that?
> > 
> > Hmm, I think I fubared that and you decided to ignore my patch :) 
> > 
> > Let me look at it tomorrow morning with full awake brain cells.
> 
> Ok, wrapped my brain around it. I tripped over the magic asm foo which
> has a single need_resched check and schedule point for both sys call
> return and interrupt return.
> 
> So you need the schedule_preempt_irq() for kernel preemption from
> interrupt return while on a normal syscall preemption a schedule would
> be sufficient. But using schedule_preempt_irq() is not harmful here in
> any way. It just sets the preempt_active bit also in cases where it
> would not be required. 
> 
> Even on preempt=n kernels adding the preempt_active bit is completely
> harmless. So instead of having an extra function, moving the existing
> one out of the ifdef PREEMPT looks like the sanest thing to do.
> 
> Peter, Ingo ?

Uhm, preempt_schedule_irq() assumes interrupts are disabled and
explicitly returns with interrupts disabled again. Does the ia64
callsite conform?

If so, schedule() would actually be actively wrong, because that will
whinge when called with interrupts disabled, and will return with
interrupts enabled.

Anyway, I don't object to the patch per se, but it might bloat a few
!ia64 kernels for having to carry the extra text.
