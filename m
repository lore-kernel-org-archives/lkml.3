Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750952AbaG0Wuc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 18:50:32 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50921 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750771AbaG0Wua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 18:50:30 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] PCI / PM: Make PCIe PME interrupts wake up from "freeze" sleep state
Date: Mon, 28 Jul 2014 01:08:58 +0200
Message-ID: <1744442.5aE2TFtgoQ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <3655886.Ih7L6voqVK@vostro.rjw.lan>
References: <12684812.i3F8JrYCl0@vostro.rjw.lan> <20140724134241.GZ6758@twins.programming.kicks-ass.net> <3655886.Ih7L6voqVK@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 24, 2014 05:36:28 PM Rafael J. Wysocki wrote:
> On Thursday, July 24, 2014 03:42:41 PM Peter Zijlstra wrote:
> 
> [...]
> 
> > 
> > So with this patch on:
> > 
> >   http://marc.info/?l=3Dlinux-kernel&m=3D140620918218199
> > 
> > This will not work on my machine, because aerdrv is requesting the same
> > irq.
> > 
> > Now I've not a f'cking clue what aerdrv is, and whether it too wants
> > NO_SUSPEND on or not.
> > 
> > But if I make it also request NO_SUSPEND it all starts working.
> 
> OK, so can you please test the updated patch below?
> 
> Rafael
> 
> ---
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: PCI / PM: Make PCIe PME interrupts wake up from "freeze" sleep state
> 
> The "freeze" sleep state, also known as suspend-to-idle, is entered
> without taking nonboot CPUs offline, right after devices have been
> suspended.  It works by waiting for at least one wakeup source object
> to become "active" as a result of handling a hardware interrupt.
> 
> Of course, interrupts supposed to be able to wake up the system from
> suspend-to-idle cannot be disabled by suspend_device_irqs() and their
> interrupt handlers must be able to cope with interrupts coming after
> all devices have been suspended.  In that case, they only need to
> call __pm_wakeup_event() for a single wakeup source object without
> trying to access hardware (that will be resumed later as part of
> the subsequent system resume).
> 
> Make PCIe PME interrupts work this way.
> 
> Register an additional wakeup source object for each PCIe PME
> service device.  That object will be used to generate wakeups from
> suspend-to-idle.
> 
> Add IRQF_NO_SUSPEND to PME interrupt flags.  This will make
> suspend_device_irqs() to ignore PME interrupts, but that's OK,
> because the PME interrupt handler is suspend-aware anyway and
> can cope with interrupts coming during system suspend-resume.
> Unfortunately, that requires the AER service driver to pass
> IRQF_NO_SUSPEND when requesting its IRQ which may be shared with
> the PME interrupt and to make that safe, simple suspend/resume
> routines need to be added to the AER driver.
> 
> During system suspend, while suspending the PME service for given
> port, walk the bus below that port and see if any devices on that
> bus are configured for wakeup.  If so, do not disable the PME
> interrupt, but only set a "suspend level" for the service to
> "wakeup" and make the interrupt handler behave in a special way,
> which is to call __pm_wakeup_event() with the service's wakeup
> source object as the first argument whenever the interrupt is
> triggered.
> 
> The "suspend level" is cleared while resuming the PME service.
> 
> This change allows Wake-on-LAN to be used for wakeup from
> suspend-to-idle on my MSI Wind tesbed netbook.

Hi Bjorn,

There will be a new version of this, please ignore for now.

Rafael

