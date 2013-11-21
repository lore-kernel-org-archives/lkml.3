Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab3KUMjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 07:39:14 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:38590 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab3KUMjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 07:39:12 -0500
Date: Thu, 21 Nov 2013 13:39:08 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [patch 4/6] ia64: Use preempt_schedule_irq
Message-ID: <20131121123906.GA20114@localhost.localdomain>
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
User-Agent: Mutt/1.5.21 (2010-09-15)
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

So that's because the schedule point is on a common user and kernel return path?

If necessary, why not having a SCHEDULE_IRQ macro in ia64 that maps to either schedule or
preempt_schedule_irq() instead?

Unless that problem happens elsewhere as well?
