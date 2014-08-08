Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbaHHBuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 21:50:20 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:65312 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754815AbaHHBuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 21:50:18 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>
Subject: Re: [PATCH 0/5] irq / PM: Shared IRQs vs IRQF_NO_SUSPEND and suspend-to-idle wakeup
Date: Fri, 08 Aug 2014 04:09 +0200
Message-ID: <4089915.QH7xXfFoFW@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <3321219.itH23ZEDt4@vostro.rjw.lan>
References: <20140724212620.GO3935@laptop> <3855585.ek3PTQLkmN@vostro.rjw.lan> <3321219.itH23ZEDt4@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 05, 2014 05:22:57 PM Rafael J. Wysocki wrote:
> On Friday, August 01, 2014 04:29:40 PM Rafael J. Wysocki wrote:
> > On Friday, August 01, 2014 03:43:21 PM Thomas Gleixner wrote:
> > > On Fri, 1 Aug 2014, Rafael J. Wysocki wrote:
> > > > OK, I guess "IRQ_HANDLED from a wakeup interrupt" may be interpreted as
> > > > IRQ_HANDLED_PMWAKE.  On the other hand, if that's going to be handled in
> > > > handle_irq_event_percpu(), then using a special return code would save us
> > > > a brach for IRQ_HANDLED interrupts.  We could convert it to IRQ_HANDLED
> > > > immediately then.
> > > 
> > > We can handle it at the end of the function by calling
> > > note_interrupt() unconditionally do the following there:
> > > 
> > >       if (suspended) {
> > >       	 if (ret == IRQ_NONE) {
> > > 	    if (shared)
> > > 	       yell_and_abort_or_resume();
> > >          } else {
> > > 	    abort_or_resume();
> > >          }
> > >       }
> > >       if (noirqdebug)
> > >       	 return;
> > 
> > I see.
> > 
> > > > OK, I'll take a stab at the IRQF_SHARED thing if you don't mind.
> > > 
> > > Definitely not :)
> > > 
> > > > Here's my current understanding of what can be done for IRQF_NO_SUSPEND.
> > > > 
> > > > In suspend_device_irqs():
> > > > 
> > > > (1) If all actions in the list have the same setting (eg. IRQF_NO_SUSPEND unset),
> > > >     keep the current behavior.
> > > > (2) If the actions have different settings:
> > > >     - Actions with IRQF_NO_SUSPEND set are not modified.
> > > >     - Actions with IRQF_NO_SUSPEND unset are switched over to a stub handler.
> > > >     - IRQS_SUSPEND_MODE (new flag) is set for the IRQ.
> > > 
> > > Can we please do that in setup_irq() and let the shared ones always
> > > run through the stub? That keeps suspend/resume_device_irqs() simple.
> > 
> > OK
> 
> Here's a patch series based on what we talked about.
> 
> [1/5] Mechanism to wake up the system or abort suspend in progress automatically.
> [2/5] Fix for shared IRQs vs IRQF_NO_SUSPEND (with wakeup in mind).
> [3/5] Wakeup interrupts support for suspend-to-idle.
> [4/5] Set IRQCHIP_SKIP_SET_WAKE for x86 IOAPIC IRQ chips.
> [5/5] Make PCIe PME wake up from suspend to idle.
> 
> All tested on MSI Wind that has a couple of issues being addressed.

Below is the doc patch I promised.

I'm not signing it off yet, as I'm sending it for comments mostly rather than
as something actually done.

Of course, it documents the situation after the series of [1-5/5] (with the
updated [3/5] I've just sent), especially as far as the suspend-to-idle goes.

Rafael


---
 Documentation/power/suspend-and-interrupts.txt |  136 +++++++++++++++++++++++++
 1 file changed, 136 insertions(+)

Index: linux-pm/Documentation/power/suspend-and-interrupts.txt
===================================================================
--- /dev/null
+++ linux-pm/Documentation/power/suspend-and-interrupts.txt
@@ -0,0 +1,136 @@
+System Suspend and Device Interrupts
+
+Copyright (C) 2014 Intel Corp.
+Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+
+
+Suspending and Resuming Device IRQs
+-----------------------------------
+
+Device interrupt request lines (IRQs) are generally disabled during system
+suspend after the "late" phase of suspending devices (that is, after all of the
+->prepare, ->suspend and ->suspend_late callbacks have been executed for all
+devices).  That is done by the suspend_device_irqs() function.
+
+The rationale for doing so is that after the "late" phase of device suspend
+there is no legitimate reason why any interrupts from suspended devices should
+trigger and if any devices have not been suspended properly yet, it is better to
+block interrupts from them anyway.  Also in the past we had problems with
+interrupt handlers of devices that shared IRQs with other devices and were not
+prepared for interrupts triggering after their devices had been suspended.
+In those cases they would attempt to access, for example, memory address spaces
+of suspended devices and cause unpredictable behavior to ensue as a result.
+Unfortunately, such problems are very difficult to debug and the introduction
+of suspend_device_irqs(), along with the "noirq" phase of device suspend, was
+the only practical way to prevent them from happening.
+
+Device IRQs are re-enabled during system resume, right before the "early" phase
+of resuming devices (that is, before starting to execute ->resume_early
+callbacks for devices).  The function doing that is resume_device_irqs().
+
+
+The IRQF_NO_SUSPEND Flag
+------------------------
+
+There are interrupts that can legitimately trigger during the entire system
+suspend-resume cycle, including the "noirq" phases of suspending and resuming
+devices as well as during the time when nonboot CPUs are taken offline and
+brought back online.  That applies to timer interrupts in the first place,
+but also to IPIs and to some other special-purpose interrupts, such as the ACPI
+SCI that isn't associated with any specific device and is used for signaling
+many different types of events.
+
+The IRQF_NO_SUSPEND flag is used to indicate that to the IRQ subsystem when
+requesting a special-purpose interrupt.  It causes suspend_device_irqs() to
+leave the corresponding IRQ enabled so as to allow the interrupt to work all
+the time as expected.
+
+If that IRQ is shared, it will still be left enabled by suspend_device_irqs(),
+but the interrupt handlers that were installed for it without IRQF_NO_SUSPEND
+set will not be executed after suspend_device_irqs() has returned.  Then, the
+IRQ subsystem will only execute interrupt handlers for which IRQF_NO_SUSPEND is
+set.  In that case, if the final result of handing an interrupt is IRQ_NONE, the
+IRQ subsystem will assume that the interrupt came from one of the apparently
+suspended devices that share the IRQ with an IRQF_NO_SUSPEND interrupt source
+(or more of them).  As a result, the IRQ will be disabled and marked as
+"suspended" to prevent spurious interrupts from triggering going forward.
+Next
+(1) if a system suspend is in progress, it will be aborted or
+(2) if the system is in the "freeze" sleep state (suspend-to-idle), it will be
+    woken up,
+to allow the system to recover from that error condition gracefully.
+
+The IRQF_NO_SUSPEND flag should not be used when requesting system wakeup
+interrupts (that is, interrupts that are supposed to wake up the system from
+sleep states), unless there are other (that is, unrelated to system wakeup)
+reasons why those interrupts can legitimately trigger after suspend_device_irqs()
+has returned and before resume_device_irqs() is called during the subsequent
+system resume.
+
+
+System Wakeup Interrupts, enable_irq_wake() and disable_irq_wake()
+------------------------------------------------------------------
+
+System wakeup interrupts generally need to be configured to wake up the system
+from sleep states, especially if they are used for different purposes (e.g. as
+I/O interrupts) in the working state.
+
+That may involve turning on a special signal handling logic within the platform
+(such as an SoC) so that signals from a given line are routed in a different way
+during system sleep so as to trigger a system wakeup when needed.  For example,
+the platform may include a dedicated interrupt controller used specifically for
+handling system wakeup events.  Then, if a given interrupt line is supposed to
+wake up the system from sleep sates, the corresponding input of that interrupt
+controller needs to be enabled to handle signals from the line in question.
+After wakeup, it generally is better to disable that input to prevent the
+dedicated controller from triggering interrupts unnecessarily.
+
+The IRQ subsystem provides two helper functions to be used by device drivers for
+those purposes.  Namely, enable_irq_wake() turns on the platform's logic for
+handling the given IRQ as a system wakeup interrupt line and disable_irq_wake()
+turns that logic off.
+
+Calling enable_irq_wake() doesn't prevent the working-state logic for handling
+the given IRQ from being disabled by suspend_device_irqs(), so after the "late"
+phase of suspending devices the IRQ can only be expected to work as a system
+wakeup interrupt line.  The IRQ subsystem checks if there are any pending
+interrupts on those lines by calling check_wakeup_irqs() at the last (syscore)
+stage of full system suspend.  If there are any, it aborts the system suspend
+by returning -EBUSY from that function.
+
+
+System Wakeup Interrupts and Suspend-to-Idle
+--------------------------------------------
+
+Suspend-to-idle (also known as the "freeze" sleep state) is a relatively new
+system sleep state that works by idling all of the processors and waiting for
+interrupts right after the "noirq" phase of suspending devices.
+
+Of course, this means that all of the interrupts with IRQF_NO_SUSPEND set will
+bring CPUs out of idle while in that state, but they will not cause the IRQ
+subsystem to trigger a system wakeup, unless the final result of handling an
+interrupt is IRQ_NONE.
+
+System wakeup interrupts, in turn, are generally expected to trigger wakeup from
+system sleep states, including suspend-to-idle.  For this reason, all of the
+IRQs configured for system wakeup with enable_irq_wake(), previously disabled
+by suspend_device_irqs(), are re-enabled right before starting the final "go to
+an idle state and wait for an interrupt" loop of suspend-to-idle.  However, they
+are also reconfigured so that the original handlers associated with them will
+not be invoked at that time.  Those interrupt handlers are all temporarily
+replaced with stub handlers that always return IRQ_NONE.  That tells the IRQ
+subsystem to trigger wakeup from suspend-to-idle upon receiving one of those
+interrupts, which is analogous to how system wakeup from full suspend works
+(that is, system wakeup is triggered when there's a signal on one of the wakeup
+lines).
+
+The rationale for doing so is that, even if the original handlers for the
+wakeup interrupts were invoked (which is not the case for wakeup from full
+system suspend anyway), they wouldn't be able to access devices (presumably
+suspended at that point) and they would only be able to tell "wakeup!" to the
+IRQ core.  However, the core doesn't really need to ask them about that, as it
+can figure that out by itself well enough.
+
+When wakeup from suspend-to-idle is triggered, the wakeup IRQs are disabled
+again and their original behavior is restored.  They are subsequently re-enabled
+by resume_device_irqs(), as usual.

