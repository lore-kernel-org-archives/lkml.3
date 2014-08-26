Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbaHZXhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 19:37:01 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62763 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754993AbaHZXg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 19:36:58 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>, Aubrey Li <aubrey.li@intel.com>
Subject: [PATCH 5/5 v3] irq / PM: Document rules related to system suspend and interrupts
Date: Wed, 27 Aug 2014 01:52:19 +0200
Message-ID: <1430782.YU7ig6M0ss@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5320472.coYotHR1d0@vostro.rjw.lan>
References: <26580319.OZP7jvJnA9@vostro.rjw.lan> <5320472.coYotHR1d0@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Add a document describing how IRQs are managed during system suspend
and resume, how to set up a wakeup interrupt and what the IRQF_NO_SUSPEND
flag is supposed to be used for.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 Documentation/power/suspend-and-interrupts.txt |  146 +++++++++++++++++++++++++
 1 file changed, 146 insertions(+)

Index: linux-pm/Documentation/power/suspend-and-interrupts.txt
===================================================================
--- /dev/null
+++ linux-pm/Documentation/power/suspend-and-interrupts.txt
@@ -0,0 +1,146 @@
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
+devices).  That is done by suspend_device_irqs().
+
+The rationale for doing so is that after the "late" phase of device suspend
+there is no legitimate reason why any interrupts from suspended devices should
+trigger and if any devices have not been suspended properly yet, it is better to
+block interrupts from them anyway.  Also, in the past we had problems with
+interrupt handlers for shared IRQs that device drivers implementing them were
+not prepared for interrupts triggering after their devices had been suspended.
+In some cases they would attempt to access, for example, memory address spaces
+of suspended devices and cause unpredictable behavior to ensue as a result.
+Unfortunately, such problems are very difficult to debug and the introduction
+of suspend_device_irqs(), along with the "noirq" phase of device suspend and
+resume, was the only practical way to mitigate them.
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
+The IRQF_NO_SUSPEND flag should not be used when requesting interrupts that
+subsequently will be configured for waking up the system from sleep states
+via enable_irq_wake() (that is, system wakeup interrupts).
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
+controller needs to be enabled to receive signals from the line in question.
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
+by returning -EBUSY from that function.  It does not, however, invoke any
+interrupt handlers for system wakeup IRQs after suspend_device_irqs().
+
+
+System Wakeup Interrupts and Suspend-to-Idle
+--------------------------------------------
+
+Suspend-to-idle (also known as the "freeze" sleep state) is a relatively new
+system sleep state that works by idling all of the processors and waiting for
+interrupts right after the "noirq" phase of suspending devices.
+
+Of course, this means that all of the interrupts with the IRQF_NO_SUSPEND flag
+set will bring CPUs out of idle while in that state, but they will not cause the
+IRQ subsystem to trigger a system wakeup.
+
+System wakeup interrupts, in turn, are generally expected to trigger wakeup from
+system sleep states, including suspend-to-idle.  For this reason, all of the
+IRQs configured for system wakeup with enable_irq_wake(), previously disabled
+by suspend_device_irqs(), are re-enabled right before starting the final "go to
+an idle state and wait for an interrupt" loop of suspend-to-idle.  However, they
+are also reconfigured so that the original handlers associated with them will
+not be invoked at that time.  Those interrupt handlers are all temporarily
+substituted for by a special "wakeup mode" interrupt handler that disables the
+IRQ, marks it as "suspended" and pending and triggers a suspend-to-idle wakeup
+event.
+
+The rationale here is to keep the behavior consistent with the existing way of
+handling wakeup interrupts during full system suspends, which is that
+
+ (a) interrupt handlers are not executed for them after suspend_device_irqs()
+
+and
+
+ (b) full system suspends are aborted if an interrupt from a wakeup IRQ line is
+     received after suspend_device_irqs().
+
+Combined with the requirement that system wakeup interrupts wake up the system
+from suspend-to-idle, (a) and (b) imply that interrupt handlers should not be
+invoked for wakeup interrupts in suspend-to-idle, although those interrupts
+should still wake up the system from that state.  The IRQs that triggered wakeup
+also need to be marked as pending to avoid losing wakeup events.
+
+When wakeup from suspend-to-idle is triggered, the wakeup IRQs are disabled
+again and their original interrupt handlers are restored.  They are subsequently
+re-enabled by resume_device_irqs(), as usual.
+
+
+IRQF_NO_SUSPEND and enable_irq_wake()
+-------------------------------------
+
+There are no valid reasons to use both enable_irq_wake() and the IRQF_NO_SUSPEND
+flag on the same IRQ.
+
+First of all, if the IRQ is not shared, the rules for handling IRQF_NO_SUSPEND
+interrupts (interrupt handlers are invoked after suspend_device_irqs()) are
+directly at odds with the rules for handling system wakeup interrupts (interrupt
+handlers are not invoked after suspend_device_irqs()).
+
+Secondly, enable_irq_wake() applies to entire IRQs and not to individual
+interrupt handlers, so sharing an IRQ between a system wakeup interrupt source
+and an IRQF_NO_SUSPEND interrupt source does not make sense in principle.  If
+attempted, it leads to situations in which genuine wakeup interrups are lost,
+because they are regarded as interrupts from the IRQF_NO_SUSPEND interrupt
+source, or are reported as unhandled interrupts, depending on the implementation
+of the interrupt handler for that source, the timing of events and other
+factors.

