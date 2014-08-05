Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbaHEPLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:11:06 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:65147 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755563AbaHEPLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:11:04 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>
Subject: [PATCH 0/5] irq / PM: Shared IRQs vs IRQF_NO_SUSPEND and suspend-to-idle wakeup
Date: Tue, 05 Aug 2014 17:22:57 +0200
Message-ID: <3321219.itH23ZEDt4@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <3855585.ek3PTQLkmN@vostro.rjw.lan>
References: <20140724212620.GO3935@laptop> <alpine.DEB.2.10.1408011533580.4997@nanos> <3855585.ek3PTQLkmN@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 01, 2014 04:29:40 PM Rafael J. Wysocki wrote:
> On Friday, August 01, 2014 03:43:21 PM Thomas Gleixner wrote:
> > On Fri, 1 Aug 2014, Rafael J. Wysocki wrote:
> > > OK, I guess "IRQ_HANDLED from a wakeup interrupt" may be interpreted as
> > > IRQ_HANDLED_PMWAKE.  On the other hand, if that's going to be handled in
> > > handle_irq_event_percpu(), then using a special return code would save us
> > > a brach for IRQ_HANDLED interrupts.  We could convert it to IRQ_HANDLED
> > > immediately then.
> > 
> > We can handle it at the end of the function by calling
> > note_interrupt() unconditionally do the following there:
> > 
> >       if (suspended) {
> >       	 if (ret == IRQ_NONE) {
> > 	    if (shared)
> > 	       yell_and_abort_or_resume();
> >          } else {
> > 	    abort_or_resume();
> >          }
> >       }
> >       if (noirqdebug)
> >       	 return;
> 
> I see.
> 
> > > OK, I'll take a stab at the IRQF_SHARED thing if you don't mind.
> > 
> > Definitely not :)
> > 
> > > Here's my current understanding of what can be done for IRQF_NO_SUSPEND.
> > > 
> > > In suspend_device_irqs():
> > > 
> > > (1) If all actions in the list have the same setting (eg. IRQF_NO_SUSPEND unset),
> > >     keep the current behavior.
> > > (2) If the actions have different settings:
> > >     - Actions with IRQF_NO_SUSPEND set are not modified.
> > >     - Actions with IRQF_NO_SUSPEND unset are switched over to a stub handler.
> > >     - IRQS_SUSPEND_MODE (new flag) is set for the IRQ.
> > 
> > Can we please do that in setup_irq() and let the shared ones always
> > run through the stub? That keeps suspend/resume_device_irqs() simple.
> 
> OK

Here's a patch series based on what we talked about.

[1/5] Mechanism to wake up the system or abort suspend in progress automatically.
[2/5] Fix for shared IRQs vs IRQF_NO_SUSPEND (with wakeup in mind).
[3/5] Wakeup interrupts support for suspend-to-idle.
[4/5] Set IRQCHIP_SKIP_SET_WAKE for x86 IOAPIC IRQ chips.
[5/5] Make PCIe PME wake up from suspend to idle.

All tested on MSI Wind that has a couple of issues being addressed.

Rafael

