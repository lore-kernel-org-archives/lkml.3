Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbaHTJGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 05:06:31 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36006 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750745AbaHTJG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 05:06:29 -0400
Date: Wed, 20 Aug 2014 11:06:25 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        =?UTF-8?B?R2HDq2w=?= PORTAY <gael.portay@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, Nicolas FERRE <nicolas.ferre@atmel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: [PATCH 3/3] ARM: at91/tclib: mask interruptions at shutdown and
 probe
Message-ID: <20140820110625.17f77c9f@bbrezillon>
In-Reply-To: <20140820082818.GB15414@ulmo>
References: <1408486072-19268-1-git-send-email-gael.portay@gmail.com>
	<1408486072-19268-4-git-send-email-gael.portay@gmail.com>
	<776D4128-09AC-418C-A710-28A2522D1D63@jcrosoft.com>
	<20140820010130.10974326@bbrezillon>
	<20140820073111.GH13793@ulmo>
	<20140820101422.3e8da816@bbrezillon>
	<20140820082818.GB15414@ulmo>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2014 10:28:20 +0200
Thierry Reding <thierry.reding@gmail.com> wrote:

> On Wed, Aug 20, 2014 at 10:14:22AM +0200, Boris BREZILLON wrote:
> > Hi Thierry,
> > 
> > On Wed, 20 Aug 2014 09:31:13 +0200
> > Thierry Reding <thierry.reding@gmail.com> wrote:
> > 
> > > On Wed, Aug 20, 2014 at 01:01:30AM +0200, Boris BREZILLON wrote:
> > > > Hi Jean-Christophe,
> > > > 
> > > > On Wed, 20 Aug 2014 06:11:17 +0800
> > > > Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> wrote:
> > > > 
> > > > > Hi,
> > > > > 
> > > > > 	This is a bit weird as the clock of the TC should be off and the irq free
> > > > > 
> > > > > 	so this should never happened we need to investigate more why this append
> > > > 
> > > > I may have found the source of this bug.
> > > > 
> > > > As Gael stated, when you're kexec-ing a new kernel your previous kernel
> > > > could be using the tbc_clksrc driver (and especially the clkevent
> > > > device). Thus the kernel might have planned a timer event and then been
> > > > asked to shutdown the machine (requested by the kexec code).
> > > > In this case the AIC interrupt connected to the TC Block is disabled
> > > > but not the interrupts within the TCB IP (IDR registers), possibly
> > > > leaving a pending interrupt before booting the new kernel.
> > > > 
> > > > When the tcb_clksrc driver is loaded by the new kernel it enables the
> > > > interrupt line by calling setup_irq [1] while the clockevent device is
> > > > not registered yet [2]. Thus the event_handler is still NULL when the
> > > > AIC line connected to the TCB is unmasked. Remember that an interrupt
> > > > is still pending on this HW block, which will lead to an immediate call
> > > > to the ch2_irq handler, which tries to call the event_handler, which in
> > > > turns is NULL because clkevent device registration has not taken place
> > > > at this moment => Kernel panic.
> > > > ITOH, we can't register the clkevent device before the irq handler is
> > > > set up, because we should be ready to handle clkevent request at the
> > > > time clockevents_config_and_register is called.
> > > > 
> > > > This leaves two solution:
> > > >  1) disable the TCB irqs (using TCB IDR registers) before calling
> > > >  setup_irq in the tcb_clksrc driver
> > > >  2) disable the TCB irqs at the tclib level (as proposed by Gael)
> > > > 
> > > > I prefer solution #2 because it fixes the bug for all TCB users (not
> > > > just the tcb_clksrc driver).
> > > 
> > > Wouldn't a more proper fix be to only enable the IRQ (setup_irq()) once
> > > everything has properly been set up? That's certainly how all other
> > > drivers are doing this. Generally I think it's best to assume that an
> > > interrupt can fire at any point after it's been enabled, so everything
> > > should be set up prior to enabling it.
> > 
> > Sure. And, AFAIK, another common practice is to disable all interrupts
> > and acknowledge all pending interrupts before registering a new irq
> > handler to avoid inheriting peripheral dirty state from previous usage
> > (either the bootloader, or the previous kernel when using kexec).
> 
> Discarding all pending interrupts may not always be what we want. And
> masking interrupts prior to registering the handler isn't always going
> to work either (shared interrupts), so device drivers should always set
> things up in the correct order.
> 

I meant disabling/acknowledging interrupts within the HW block not
the interrupt line connected to the interrupt controller (which indeed
can be shared among several peripherals).
The TCB IP provides SR (Status Register) to acknowledge interrupts at
the TCB level and IER/IDR/ISR (Interrupt Enable/Disable/Status
Register) to manipulate TCB interrupts.

> > This being said, I really think we should leave the HW in a clean state
> > when shutdown is called. And disabling interrupts at the tclib level
> > (in a shutdown callback) ensure that.
> 
> Yes, cleaning up the hardware and disabling interrupts upon shutdown
> seems like a good idea to me in addition to the above.
> 
> Thierry



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
