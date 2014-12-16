Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194AbaLPOUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 09:20:52 -0500
Received: from down.free-electrons.com ([37.187.137.238]:35178 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751084AbaLPOUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 09:20:47 -0500
Date: Tue, 16 Dec 2014 15:20:41 +0100
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
Message-ID: <20141216152041.56ff9b2e@bbrezillon>
In-Reply-To: <alpine.DEB.2.11.1412161349420.17382@nanos>
References: <1418660152-17185-1-git-send-email-boris.brezillon@free-electrons.com>
	<2662748.NJbkr6jW7r@vostro.rjw.lan>
	<3542278.8lcJeXLMFm@vostro.rjw.lan>
	<20141216100715.57baeb65@bbrezillon>
	<alpine.DEB.2.11.1412161013570.17382@nanos>
	<20141216122503.77c5632f@bbrezillon>
	<alpine.DEB.2.11.1412161349420.17382@nanos>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2014 13:56:26 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 16 Dec 2014, Boris Brezillon wrote:
> > Thomas Gleixner <tglx@linutronix.de> wrote:
> > > Install the timer interrupt as a demultiplexing interrupt.
> > 
> > I can try to hack the AIC irqchip driver to implement this demux logic,
> > but this logic can't be placed in the PIT (Periodic Interval Timer)
> > driver itself, because the shared IRQ line is used by the at91 clock
> > controller (PMC) which is providing the clock to the PIT device.
> > This gives the following dependency graph:
> > 
> > PIT =depends-on=> Master Clock =provided-by=> PMC =needs=> PMC IRQ.
> 
> It never can be a part of a device driver. This is a property of the
> interrupt controller which fails to provide a proper demux for this
> irq line in the first place.
> 
> So you fake the demux in the irq chip driver, where you provide the
> pseudo chip and the demux logic. None of the device drivers (PIT, PMC,
> UART ...) even knows about that.
> 
> |--------|             |--------|
> | AIC    |-------------| Pseudo |---- PIT
> |        |             | chip   |---- PMC
> |        |             |        |---- UART
> |        |             |--------|
> |        |--- devX
> |        |--- devY
> |        |--- devZ
> |--------|
> 
> So PIT, PMC and UART get interrupt numbers handed out which are
> outside of the interrupt space of AIC.

Okay, that's what I had in mind, thanks for clarifying this aspect.

Regarding the DT representation, it should look like this, right ?

aic: interrupt-controller@fffff000 {
	#interrupt-cells = <3>;
	compatible = "atmel,at91rm9200-aic";
	interrupt-controller;
	reg = <0xfffff000 0x200>;
	atmel,external-irqs = <29 30 31>;

	irq1_demux: irq1-demux {
		#interrupt-cells = <1>;
		interrupt-controller;
	}
};

pit: timer@fffffd30 {
	compatible = "atmel,at91sam9260-pit";
	reg = <0xfffffd30 0xf>;
	/* 0 is the id reserved for the PIT */
	interrupts-extended = <&irq1_demux 0>;
	clocks = <&mck>;
};

pmc: pmc@fffffc00 {
	compatible = "atmel,at91sam9260-pmc";
	reg = <0xfffffc00 0x100>;
	/* 1 is the id reserved for the PMC */
	interrupts-extended = <&irq1_demux 1>;
[...]
};

Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
