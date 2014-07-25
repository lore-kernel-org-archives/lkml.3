Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760384AbaGYMbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 08:31:09 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64137 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759259AbaGYMbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 08:31:07 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>
Subject: Re: [RFC][PATCH] irq: Rework IRQF_NO_SUSPENDED
Date: Fri, 25 Jul 2014 14:49:34 +0200
Message-ID: <2634160.AMXQm5EuML@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.10.1407251109390.23352@nanos>
References: <20140724212620.GO3935@laptop> <13290270.IfKaUSRMLR@vostro.rjw.lan> <alpine.DEB.2.10.1407251109390.23352@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 25, 2014 11:27:25 AM Thomas Gleixner wrote:
> On Fri, 25 Jul 2014, Rafael J. Wysocki wrote:
> > On Thursday, July 24, 2014 11:26:20 PM Peter Zijlstra wrote:
> > > Subject: irq: Rework IRQF_NO_SUSPENDED
> > > From: Peter Zijlstra <peterz@infradead.org>
> > > Date: Thu Jul 24 22:34:50 CEST 2014
> > > 
> > > Typically when devices are suspended they're quiesced such that they
> > > will not generate any further interrupts.
> > > 
> > > However some devices should still generate interrupts, even when
> > > suspended, typically used to wake the machine back up.
> > > 
> > > Such logic should ideally be contained inside each driver, if it can
> > > generate interrupts when suspended, it knows about this and the
> > > interrupt handler can deal with it.
> > > 
> > > Except of course for shared interrupts, when such a wakeup device is
> > > sharing an interrupt line with a device that does not expect
> > > interrupts while suspended things can go funny.
> > > 
> > > This is where IRQF_NO_SUSPEND comes in, the idea is that drivers that
> > > have the capability to wake the machine set IRQF_NO_SUSPEND and their
> > > handler will still be called, even when the IRQ subsystem is formally
> > > suspended. Handlers without IRQF_NO_SUSPEND will not be called.
> > > 
> > > This replaced the prior implementation of IRQF_NO_SUSPEND which had
> > > a number of fatal issues in that it didn't actually work for the
> > > shared case, exactly the case it should be helping.
> > > 
> > > There is still enable_irq_wake()/IRQD_WAKEUP_STATE that tries to serve
> > > a similar purpose but is equially wrecked for shared interrupts,
> > > ideally this would be removed.
> > 
> > Let me comment about this particular thing.
> > 
> > I had a discussion with Dmitry about that and his argument was that
> > enable_irq_wake() should imply IRQF_NO_SUSPEND, because drivers that
> > set up interrupts for system wakeup should expect those interrupts to
> > trigger at any time, including system suspend.  Hence the patch that
> > added the IRQD_WAKEUP_STATE check to __disable_irq().
> > 
> > However, in the face of the problem that is being addressed here I'm
> > not really sure that this argument is valid, because if the driver
> > calling enable_irq_wake() is sharing the IRQ with another one, the
> > other driver may not actually know that the IRQ will be a wakeup one
> > and still may not expect interrupts to come to it during system
> > suspend/resume.
> > 
> > Yes, drivers using enable_irq_wake() will likely want IRQF_NO_SUSPEND to
> > be set for their irqactions, but that should not imply "no suspend" for
> > all irqactions sharing the same desc.  So I guess it may be better to go
> > forth and use a global "interrupts suspended" state variable instead of the
> > IRQS_SUSPENDED flag for each desc and throw away the IRQD_WAKEUP_STATE
> > check from suspend_device_irqs() entirely.
> 
> How should that global state work?

Well, never mind.

If the face of your remark about the level-triggered interrupts that's all moot.

Rafael

