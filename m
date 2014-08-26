Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbaHZXhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 19:37:37 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60808 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755930AbaHZXhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 19:37:01 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>, Aubrey Li <aubrey.li@intel.com>
Subject: [PATCH 0/5 v3] irq / PM: Suspend-to-idle wakeup interrupts
Date: Wed, 27 Aug 2014 01:46:23 +0200
Message-ID: <5320472.coYotHR1d0@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <26580319.OZP7jvJnA9@vostro.rjw.lan>
References: <26580319.OZP7jvJnA9@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday, August 11, 2014 03:56:46 PM Rafael J. Wysocki wrote:
> Hi,
> 
> I thought I'd just refresh the previous patchset, but in the meantime I found
> a way to avoid adding overhead to note_interrupt(), so I decided to change the
> approach.
> 
> Patch [2/6] fixes the problem with IRQF_NO_SUSPEND and shared interrupts.  The
> idea is to use wrapper handlers for all irqactions of the shared IRQs where at
> least one of them has IRQF_NO_SUSPEND set.  Since the wrapper handler is now
> installed for all irqactions in the given irq_desc, it can track the return
> codes from the original handlers and "suspend" the IRQ if the interrupt is going
> to be unhandled eventually.  All described in the changelog.  This is independent
> of the handling of wakeup interrupts for suspend-to-idle.
> 
> Patch [3/6] makes IRQs configured for system wakeup with enable_irq_wake() work
> for suspend to idle.  It does that by using a (different) wrapper handler for
> all irqactions in the wakeup irq_descs and that wrapper handler takes care of
> all the ugly details.  Again, all described in the changelog.
> 
> Patches [1/6], [4-5/6] are unmodified and the last one addes documentation.

It has occured to me recently that trying to address two different issues at
once in one patchset may be more confusing than it has to be, so the following
series has one and only one purpose which is to make enable_irq_wake() interrupts
wake up from suspend-to-idle while avoiding the shared interrupts pain.

The way it works is that for each IRQD_WAKEUP_STATE IRQ (a) all of the interrupt
handlers are substituted for by a special "wakeup mode" handler and (b) the
IRQ is re-enabled right before entering the suspend-to-idle loop.  After a wakeup
interrupt all is restored to the previous state left by suspend_device_irqs().

The "wakeup mode" handler triggers a system wakeup, disables the IRQ and marks
it as "suspended" and "pending".

To me, all of this is relatively straightforward and the handling of
IRQF_NO_SUSPEND for shared interrupts, which is a separate problem, can be
addressed on top of it later (make no mistake, I still think that it should be
addressed).

The patches are as follows:

[1/5] Mechanism to wake up the system or abort suspend in progress automatically.
[2/5] Wakeup interrupts support for suspend-to-idle.
[3/5] Set IRQCHIP_SKIP_SET_WAKE for x86 IOAPIC IRQ chips.
[4/5] Make PCIe PME wake up from suspend to idle.
[5/5] Documentation.

Patches [1/5] and [3-4/5] have not been changed since I posted them previously
and patch [5/5] has been updated to reflect the focus on wakeup (I removed the
paragraph on IRQF_NO_SUSPEND vs shared interrupts from it).

All tested on MSI Wind.

Rafael

