Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbaFWNwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:52:21 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:37326 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753905AbaFWNwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:52:17 -0400
Message-ID: <1403531535.3804.11.camel@hornet>
Subject: Re: [PATCH v7 1/2] video: ARM CLCD: Add DT support
From: Pawel Moll <pawel.moll@arm.com>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>
Date: Mon, 23 Jun 2014 14:52:15 +0100
In-Reply-To: <CAFEAcA-NZiRDDeUc7n+6hxgjG1V3qYXPAwyfSdtyz=ZCcD8kiw@mail.gmail.com>
References: <1403018494-10264-1-git-send-email-pawel.moll@arm.com>
	 <CAFEAcA-NZiRDDeUc7n+6hxgjG1V3qYXPAwyfSdtyz=ZCcD8kiw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-20 at 23:27 +0100, Peter Maydell wrote:
> On 17 June 2014 16:21, Pawel Moll <pawel.moll@arm.com> wrote:
> > This patch adds basic DT bindings for the PL11x CLCD cells
> > and make their fbdev driver use them.
> 
> > +* ARM PrimeCell Color LCD Controller PL110/PL111
> > +
> > +See also Documentation/devicetree/bindings/arm/primecell.txt
> > +
> > +Required properties:
> > +
> > +- compatible: must be one of:
> > +       "arm,pl110", "arm,primecell"
> > +       "arm,pl111", "arm,primecell"
> > +
> > +- reg: base address and size of the control registers block
> > +
> > +- interrupt-names: either the single entry "combined" representing a
> > +       combined interrupt output (CLCDINTR), or the four entries
> > +       "mbe", "vcomp", "lnbu", "fuf" representing the individual
> > +       CLCDMBEINTR, CLCDVCOMPINTR, CLCDLNBUINTR, CLCDFUFINTR interrupts
> > +
> > +- interrupts: contains an interrupt specifier for each entry in
> > +       interrupt-names
> > +
> > +- clocks-names: should contain "clcdclk" and "apb_pclk"
> > +
> > +- clocks: contains phandle and clock specifier pairs for the entries
> > +       in the clock-names property. See
> > +       Documentation/devicetree/binding/clock/clock-bindings.txt
> > +
> > +Optional properties:
> > +
> > +- arm,pl11x,framebuffer-base: a pair of two 32-bit values, address and size,
> > +       defining the framebuffer that must be used; if not present, the
> > +       framebuffer may be located anywhere in the memory
> > +
> > +- max-memory-bandwidth: maximum bandwidth in bytes per second that the
> > +       cell's memory interface can handle
> > +
> > +Required sub-nodes:
> > +
> > +- port: describes LCD panel signals, following the common binding
> > +       for video transmitter interfaces; see
> > +       Documentation/devicetree/bindings/media/video-interfaces.txt;
> > +       when it is a TFT panel, the port's endpoint must define the
> > +       following property:
> > +
> > +       - arm,pl11x,tft-r0g0b0-pads: an array of three 32-bit values,
> > +               defining the way CLD pads are wired up; this implicitly
> > +               defines available color modes, for example:
> > +               - PL111 TFT 4:4:4 panel:
> > +                       arm,pl11x,tft-r0g0b0-pads = <4 15 20>;
> > +               - PL110 TFT (1:)5:5:5 panel:
> > +                       arm,pl11x,tft-r0g0b0-pads = <1 7 13>;
> > +               - PL111 TFT (1:)5:5:5 panel:
> > +                       arm,pl11x,tft-r0g0b0-pads = <3 11 19>;
> > +               - PL111 TFT 5:6:5 panel:
> > +                       arm,pl11x,tft-r0g0b0-pads = <3 10 19>;
> > +               - PL110 and PL111 TFT 8:8:8 panel:
> > +                       arm,pl11x,tft-r0g0b0-pads = <0 8 16>;
> > +               - PL110 and PL111 TFT 8:8:8 panel, R & B components swapped:
> > +                       arm,pl11x,tft-r0g0b0-pads = <16 8 0>;
> 
> How does this work for boards like the versatilepb which have a
> mux between a PL110 and the TFT, allowing it to efffectively
> rewire the pads at runtime under control of the SYS_CLCD
> sysreg (to give a wider range of colour modes than the
> PL110 supports natively)?

The particular case you're referring has been already discussed several
times, and the bottom line here is that it's not PL111 compatible (there
are more changes than just the mux) and will need separate "compatible"
value and some tweaks in the driver (in the places currently doing
CONFIG_ARCH_VERSATILE).

Now, if it was PL111 with an external, independent muxer, the pads
description would still hold its value (PL111's R would still be wired
up at a particular pad etc.) and the display pipeline drivers would have
to handle the case.

Pawel

