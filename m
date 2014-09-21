Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbaIUAoe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 20:44:34 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63173 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751251AbaIUAod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 20:44:33 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Subject: Re: [PATCH/RFC] rtc: rtc-twl: Fixed nested IRQ handling in resume from suspend
Date: Sun, 21 Sep 2014 03:04:16 +0200
Message-ID: <3217793.MXnpGDmaUd@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.10.1409161318130.4247@nanos>
References: <1410607196-3941-1-git-send-email-laurent.pinchart@ideasonboard.com> <alpine.DEB.2.10.1409161318130.4247@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 17, 2014 02:57:11 PM Thomas Gleixner wrote:
> On Sat, 13 Sep 2014, Laurent Pinchart wrote:
> 
> > The TWL RTC interrupt is a double-nested threaded interrupt, handled
> > through the TWL SIH (Secondary Interrupt Handler) and PIH (Primary
> > Interrupt Handler).
> > 
> > When the system is woken up from suspend by a TWL RTC alarm interrupt,
> > the TWL PIH and SIH are enabled first (due to the normal IRQ enabling
> > sequence for the PIH and to the IRQF_EARLY_RESUME flag for the SIH)
> > before the TWL RTC interrupt gets enabled. This results on the interrupt
> > being processed by the TWL primary interrupt handler, forwarded to the
> > nested SIH, and then marked as pending for the RTC by handle_nested_irq
> > called from the SIH.
> > 
> > The RTC interrupt then eventually gets reenabled the kernel, which will
> > try to call its top half interrupt handler. As the interrupt is a nested
> > threaded IRQ, its primary handler has been set to the
> > irq_nested_primary_handler function, which is never supposed to be
> > called and generates a WARN_ON, without waking the IRQ thread up.
> 
> Right. It CANNOT wake up the thread, because there is no thread
> associated to that particular interrupt. It's handler is called in the
> context of the parent (demultiplexing) interrupt thread. Of course
> twl4030 does not call irq_set_parent() for the nested
> interrupts. That's there so the resend of a nested thread irq will be
> targeted to its parent.
>  
> Using IRQF_EARLY_RESUME is really, really wrong for device drivers
> simply because at the point where early resume is called the devices
> have not yet been resumed, so a interrupt delivered at this point
> might run into a stale device and cause a machine stall or any other
> undesired side effect. It was added for a special case with Xen where
> Xen needs the IPIs working early in resume. And it's definitely not
> meant to solve ordering issues of interrupts on resume.
> 
> That said, looking at that twl4030 driver, there seems to be a double
> nesting issue. So also the simple one level parent redirection of the
> irq resend wont work. I really wonder why this only triggers in the
> context of resume.
> 
> Now the resend issue is simple to fix. The resume time ordering
> constraints is a bit more involved, but it should be possible w/o
> inflicting anything more complex on drivers than requiring them to use
> irq_set_parent(), which should be name irq_set_nested_parent().
> 
> Completely untested patch below. It applies on top of
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/pm
> 
> So what twl4030 needs on top of that are calls to
> irq_set_nested_parent() for the nested interrupts.
> 
> That will automatically establish the nesting depth, redirect the
> retrigger to the top most interrupt and solve the resume ordering.
> 
> The resume ordering is the reverse of the nesting:
> 
>     top-irq1 - nested irq10   - nested irq20 (parent = 10)
>     	     | (parent = 1)   - nested irq21 (parent = 10)
> 	     |
>     	     - nested irq11   - nested irq22 (parent = 11)	
> 	     | (parent = 1)   - nested irq23 (parent = 11)
> 	     |
> 	     - nested irq12   - nested irq24 (parent = 12)
> 	       (parent = 1)   - nested irq25 (parent = 12)
> 
> So the resume ordering is
> 
>    20-21-22-23-24-25 - 10-11-12 - 1

I was thinking about this earlier today.

Can't we do something like this (pseudo code) during resume:

resume_irq(irq) {
	if (has parent_irq)
		resume_irq(parent_irq);

	do stuff;
}

which will get us the right ordering without using bitmaps and visiting
the same one twice (once from the child and once from the main resume loop)
doesn't matter?

Rafael

