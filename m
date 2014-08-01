Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbaHAN1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 09:27:09 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58864 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750716AbaHAN1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 09:27:07 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>
Subject: Re: [PATCH 1/3] irq / PM: New driver interface for wakeup interruptsn
Date: Fri, 01 Aug 2014 15:45:41 +0200
Message-ID: <19816559.O6O5RjzKM1@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.10.1408010217090.4997@nanos>
References: <20140724212620.GO3935@laptop> <1624300.2IhdzCt5pu@vostro.rjw.lan> <alpine.DEB.2.10.1408010217090.4997@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 01, 2014 11:40:55 AM Thomas Gleixner wrote:
> On Fri, 1 Aug 2014, Rafael J. Wysocki wrote:
> > On Friday, August 01, 2014 12:16:23 AM Thomas Gleixner wrote:

[cut]

> > > > And now there's one more piece of it which is suspend-to-idle (aka "freeze").
> > > > That doesn't go all the way to syscore_suspend(), but basically stops after
> > > > finishing the "noirq" phase of suspending devices.  Then, it idles the CPUs
> > > > and waits for interrupts that will take them out of idle.  Only some of those
> > > > interrupts are wakeup events, so it only resumes when __pm_wakeup_event() or
> > > > __pm_relax() is called in the process of handling the interrupts.
> > > >
> > > > Of course, it could be implemented differently, but that was the simplest
> > > > way to do that.  It still can be changed, but I'd really like it not to have
> > > > to go through all of the disabling nonboot CPUs and sysfore_suspend(), because
> > > > that simply isn't necessary (and it avoids a metric ton of problems with CPU
> > > > offline/online).  And of course, it has to work on x86 too.
> > > 
> > > Right. So one thing which would make the situation more clear is that
> > > the interrupt handler needs to tell the core code about this by
> > > returning something like IRQ_HANDLED_PMWAKE and the core kicks the
> > > suspend-to-idle logic back to life. I'm not sure whether the extra
> > > return value is actually necessary, we might even map it to
> > > IRQ_HANDLED in the core as we know that we are in the suspend
> > > state.
> > 
> > I'm not sure I'm following you here.  Do you mean that upon receiving
> > IRQ_HANDLED_PMWAKE from an interrupt handler the core will know that
> > this was a wakeup event and will trigger a resume from suspend-to-idle?
> 
> Correct. Whether we need the extra return code is debatable. But yes,
> we want to talk to the PM/suspend/resume thing at core level instead
> of letting drivers use random interfaces which happen to be exported
> for one reason or the other, but definitely not for the purpose of
> random driver.

OK, I guess "IRQ_HANDLED from a wakeup interrupt" may be interpreted as
IRQ_HANDLED_PMWAKE.  On the other hand, if that's going to be handled in
handle_irq_event_percpu(), then using a special return code would save us
a brach for IRQ_HANDLED interrupts.  We could convert it to IRQ_HANDLED
immediately then.

[cut]

> > I'm not sure about the ordering, though.  It would be good to have a working
> > replacement for the IRQF_NO_SUSPEND things that we'll be removing in 1, for
> > example.  So since we need to do 3) IRQF_SHARED for both IRQF_NO_SUSPEND and
> > wakeup, as you said, would it be practical to start with that one?
> 
> The numbering was not meant as ordering, it was just to seperate the
> various issues which we need to look at.

OK, I'll take a stab at the IRQF_SHARED thing if you don't mind.

Here's my current understanding of what can be done for IRQF_NO_SUSPEND.

In suspend_device_irqs():

(1) If all actions in the list have the same setting (eg. IRQF_NO_SUSPEND unset),
    keep the current behavior.
(2) If the actions have different settings:
    - Actions with IRQF_NO_SUSPEND set are not modified.
    - Actions with IRQF_NO_SUSPEND unset are switched over to a stub handler.
    - IRQS_SUSPEND_MODE (new flag) is set for the IRQ.

In note_interrupt():

  If action_ret is IRQ_NONE and IRQS_SUSPEND_MODE is set for the IRQ, disable the
  IRQ, set IRQS_SUSPENDED for it and call system_wakeup(BAD_INTERRUPT) (that will
  abort suspend if still in progress or break the suspend-to-idle loop).

In resume_device_irqs():

(1) If IRQS_SUSPEND_MODE is set, switch over actions with IRQF_NO_SUSPEND unset
    to their original handlers and clear the flag.  Fall through.
(2) If IRQS_SUSPENDED is set, clear the flag and enable the interrupt.

The stub handler only needs to return IRQ_NONE unconditionally in that case.

Does that make sense?

Rafael

