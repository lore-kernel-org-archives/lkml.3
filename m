Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab3GUQtn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 12:49:43 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:59395 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab3GUQtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 12:49:41 -0400
MIME-Version: 1.0
In-Reply-To: <51E83A4F.5080904@ti.com>
References: <1374165830-6367-1-git-send-email-r.sricharan@ti.com>
	<1374165830-6367-2-git-send-email-r.sricharan@ti.com>
	<51E83A4F.5080904@ti.com>
Date: Sun, 21 Jul 2013 18:49:40 +0200
Message-ID: <CACRpkdY3nQaWimTwB-Zt-8+Q_KZr8a0rpB1SUQq=AuoG4bAYnQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] misc: Add crossbar driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: Sricharan R <r.sricharan@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        ext Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rajendra Nayak <rnayak@ti.com>, Felipe Balbi <balbi@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 8:56 PM, Nishanth Menon <nm@ti.com> wrote:

> I carry forward my TI internal objection to this approach:

It is actually a very good sign of FOSS-maturity that you as a company
take unresolved architectural issues to the community. Kudos!

> Lets see what happens as a result of this:
>
> https://patchwork.kernel.org/patch/2825148/ (introducing DTS for DRA7)
> uart1 to uart6 is defined. while in fact 10 uarts exist on IP block.
> uart1: serial@4806a000 {
> <snip>
> +                       interrupts = <0 72 0x4>;
> Assumes that GIC interrupt by default mapping used.

So introducing this inbetween the GIC lines and its actual device IRQ
lines inevitably means that the GIC three-cell concept is completely
ill-devised to handle this.

For routing IRQs, I think the proper solution would be to use a
cascaded struct irqchip, which in turn contains an irqdomain
translation to remux the signal onto the GIC inputs.

I.e. the interrupt-controller given to that serial would be the
crossbar irqchip, and that in turn will hog and allocate apropriate
lines from the gic to it would probably itself list *all* the IRQs
of the GIC as "its" IRQs.

We already have plenty of cascading irqchips such as GPIO
controller providing IRQs, just that they only multiplex on a
single GIC line instead of the whole lot.

Mock example:

                intc: interrupt-controller@0 {
                        compatible = "arm,cortex-a9-gic";
                        #interrupt-cells = <3>;
                        #address-cells = <1>;
                        interrupt-controller;
                        reg = ...;
                };

                crossbar: crossbar@0 {
                        compatible = "...";
                        interrupt-controller;
                        #interrupt-cells = <1>;
                        interrupt-parent = <&intc>;
                        interrupts = <0 0 IRQ_TYPE_LEVEL_HIGH>,
                                          <0 1 IRQ_TYPE_LEVEL_HIGH>,
                                          <0 2 IRQ_TYPE_LEVEL_HIGH>,
                                          ....
                                          <0 n IRQ_TYPE_LEVEL_HIGH>;
                };

                uart0: serial@0 {
                        compatible = "...";
                        interrupt-parent = <&crossbar>;
                        interrupts = <1234>;
                 };

Maybe the interrupts provided from crossbar cannot even be
specified by a number, maybe a line name need to be used
or so. I don't know the particulars.

Whether this as a whole is a good idea, I don't know,
but you would have to go about it something like this.

What happens if there is no line to mux in a certain IRQ?

Yours,
Linus Walleij
