Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaBLRqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 12:46:45 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:43289 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbaBLRqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 12:46:44 -0500
Date: Wed, 12 Feb 2014 18:46:39 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <bitbucket@online.de>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Too many rescheduling interrupts (still!)
Message-ID: <20140212174637.GC5496@localhost.localdomain>
References: <CALCETrVL44ewQPJXNwPAm2s5aj9auo2p4tYYieNcxANoL91VWw@mail.gmail.com>
 <alpine.DEB.2.02.1402112219160.21991@ionos.tec.linutronix.de>
 <CALCETrUPyG1HoXFToXuVLOzX2f20zzxJyABKASOUPY691JmjMA@mail.gmail.com>
 <20140212101324.GC3545@laptop.programming.kicks-ass.net>
 <CAFTL4hyJtUHaT39NmM71=Ho4fp28PJ+-KezQryXJE_gTEMaHqA@mail.gmail.com>
 <20140212164356.GB27965@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212164356.GB27965@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 05:43:56PM +0100, Peter Zijlstra wrote:
> On Wed, Feb 12, 2014 at 04:59:52PM +0100, Frederic Weisbecker wrote:
> > 2014-02-12 11:13 GMT+01:00 Peter Zijlstra <peterz@infradead.org>:
> > > On Tue, Feb 11, 2014 at 02:34:11PM -0800, Andy Lutomirski wrote:
> > >> On Tue, Feb 11, 2014 at 1:21 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > >> >> A small number of reschedule interrupts appear to be due to a race:
> > >> >> both resched_task and wake_up_idle_cpu do, essentially:
> > >> >>
> > >> >> set_tsk_need_resched(t);
> > >> >> smb_mb();
> > >> >> if (!tsk_is_polling(t))
> > >> >>   smp_send_reschedule(cpu);
> > >> >>
> > >> >> The problem is that set_tsk_need_resched wakes the CPU and, if the CPU
> > >> >> is too quick (which isn't surprising if it was in C0 or C1), then it
> > >> >> could *clear* TS_POLLING before tsk_is_polling is read.
> > >
> > > Yeah we have the wrong default for the idle loops.. it should default to
> > > polling and only switch to !polling at the very last moment if it really
> > > needs an interrupt to wake.
> > >
> > > Changing this requires someone (probably me again :/) to audit all arch
> > > cpu idle drivers/functions.
> > 
> > Looking at wake_up_idle_cpu(), we set need_resched and send the IPI.
> > On the other end, the CPU wakes up, exits the idle loop and even goes
> > to the scheduler while there is probably no task to schedule.
> > 
> > I wonder if this is all necessary. All we need is the timer to be
> > handled by the dynticks code to re-evaluate the next tick. So calling
> > irq_exit() -> tick_nohz_irq_exit() from the scheduler_ipi() should be
> > enough.
> 
> No no, the idea was to NOT send IPIs. So falling out of idle by writing
> TIF_NEED_RESCHED and having the idle loop fixup the timers on its way
> back to idle is what you want.

Ok but if the target is idle, dynticks and not polling, we don't have the choice
but to send an IPI, right? I'm talking about this kind of case.
