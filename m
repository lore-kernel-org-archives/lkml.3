Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbaLPS0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 13:26:16 -0500
Received: from down.free-electrons.com ([37.187.137.238]:36354 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750976AbaLPS0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 13:26:14 -0500
Date: Tue, 16 Dec 2014 19:26:09 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Mike Turquette <mturquette@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] ARM: at91: fix irq_pm_install_action WARNING
Message-ID: <20141216192609.778f5f8d@bbrezillon>
In-Reply-To: <alpine.DEB.2.11.1412161013570.17382@nanos>
References: <1418660152-17185-1-git-send-email-boris.brezillon@free-electrons.com>
	<2662748.NJbkr6jW7r@vostro.rjw.lan>
	<3542278.8lcJeXLMFm@vostro.rjw.lan>
	<20141216100715.57baeb65@bbrezillon>
	<alpine.DEB.2.11.1412161013570.17382@nanos>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Tue, 16 Dec 2014 11:03:55 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 16 Dec 2014, Boris Brezillon wrote:
> > On Mon, 15 Dec 2014 23:48:14 +0100
> > "Rafael J. Wysocki" <rjw@rjwysocki.net> wrote:
> > > Or even set IRFQ_NO_SUSPEND for all of the users of this interrupt and add
> > > comments to them explaining why it is set.
> > Actually I thought about adding a new flag (let's call it
> > IRQF_DONT_COMPLAIN for now ;-)) to remove those warnings (or specifying
> > IRFQ_NO_SUSPEND in all peripherals sharing the IRQ with the init
> > timer), but after discussing the problem with Thomas I decided to go
> > for the approach described in my cover letter.
> > 
> > Thomas, correct me if I'm wrong, but your concern about the
> > IRQF_DONT_COMPLAIN approach was that it was leaving interrupt handlers
> > of suspended devices in an active state (meaning that they could be
> > called in "suspend" or "early resume" state), and such devices might
> > not properly handle interrupts while being in a suspended state (clocks
> > and regulators disabled).
> > In at91 specific case this should not be an issue thought.
> > 
> > We have the same problem when setting IRFQ_NO_SUSPEND on all peripherals
> > sharing the IRQ with the init timer.
> > Moreover, I'd like to keep the core automatically disabling the IRQ when
> > the PMC, RTC, watchdog or DBGU (UART) peripherals have their own
> > dedicated IRQ (which is the case on Atmel sama5 SoCs).
> > This implies testing for the SoC version in each of these drivers and
> > adapting the request_irq call accordingly.
> 
> But still all those drivers must disable the interrupts at the device
> level on suspend, right?
> 
> > Thomas, Rafael, if both of you think I should either introduce a new
> > flag or specify IRFQ_NO_SUSPEND in all shared IRQ users, then I can go
> > for one of this solution.
> 
> All of this really sucks. What about the following?
> 
> Install the timer interrupt as a demultiplexing interrupt.
> 
> Create a pseudo interrupt chip, which essentially does nothing, but
> keeps track of the disabled state. Install handle_simple_irq as
> handler for those "demux" interrupts. Then have:
> 
> struct data {
>        u32 unmasked;
>        u32 demuxavail;
> };
> 
> static struct data demuxdata;
> 
> At init time you know how many of these demux interrupts are
> available. So you set the demuxdata up, e.g. for 3 interrupts
> connected:
> 
> 	demuxdata.demuxavail = 0x07;
> 
> You install a pointer to demuxdata for all demux interrupts as irq
> chip data and the simple handler.
> 
> And in the mask/unmask handlers you do:
> 
> mask(irqdata) {
>        struct data *d = irq_data_get_irq_chip_data(irqdata);
> 
>        d->unmasked &= ~irqdata->mask;
>        if (!d->unmasked)
>        	  mask_demux_irq();
> }
> 
> unmask(irqdata) {
>        struct data *d = irq_data_get_irq_chip_data(irqdata);
> 
>        if (!d->unmasked)
>        	  unmask_demux_irq();
>        d->mask |= irqdata->mask;
> }
> 
> Now the demuxhandler does:
> 
>     mask = demuxdata.demuxavail & demuxdata.unmasked;
> 
>     for_each_bit(bit, mask)
>     	generic_handle_irq(demuxirq_start + bit);
> 
> So the handler wont be invoked for masked bits and handle_simple_irq()
> will not call the device handler if the interrupt is marked disabled.
> 
> So in the suspend case all "demux" interrupts except those which are
> marked NOSUSPEND are marked disabled and the handlers wont be invoked.
> 
> Locking and other details omitted.
> 
> That avoids the whole flag, action, whatever business for the price of
> a really trivial demux mechanism. Everything just works. Even the irq
> storm detector will just disable the parent interrupt once all
> handlers return NONE often enough.

Still have one question regarding the spurious interrupt detection code.
AFAIU, it disables a specific IRQ handler if it triggers to often with
an IRQ_NONE return, right ?

In this dumb demuxer I can't tell which child interrupt should be
handled (there is no interrupt cause register), thus I call
generic_handle_irq on all unmasked IRQs.
Isn't there a risk to get some of my child interrupts disabled because
they always return IRQ_NONE (which is a normal use case for
IRQF_SHARED: we're only expecting at least one handler to return
IRQ_HANDLED or IRQ_WAKE_THREAD, not all of them) ?


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
