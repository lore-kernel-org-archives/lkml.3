Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbaIBJdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 05:33:38 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42300 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750903AbaIBJdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 05:33:35 -0400
Date: Tue, 2 Sep 2014 10:33:30 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/12] of: Add binding document for MIPS GIC
Message-ID: <20140902093330.GA6595@leverpostej>
References: <1409350479-19108-1-git-send-email-abrestic@chromium.org>
 <1409350479-19108-4-git-send-email-abrestic@chromium.org>
 <20140901110119.GB6617@leverpostej>
 <CAL1qeaH97fL3x689-FwOxRZWS2-6CDzzzJX3xEKdvULHoxjMLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL1qeaH97fL3x689-FwOxRZWS2-6CDzzzJX3xEKdvULHoxjMLA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 01:53:18AM +0100, Andrew Bresticker wrote:
> On Mon, Sep 1, 2014 at 4:01 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Fri, Aug 29, 2014 at 11:14:30PM +0100, Andrew Bresticker wrote:
> >> The Global Interrupt Controller (GIC) present on certain MIPS systems
> >> can be used to route external interrupts to individual VPEs and CPU
> >> interrupt vectors.  It also supports a timer and software-generated
> >> interrupts.
> >>
> >> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> >> ---
> >>  Documentation/devicetree/bindings/mips/gic.txt | 50 ++++++++++++++++++++++++++
> >>  1 file changed, 50 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/mips/gic.txt
> >>
> >> diff --git a/Documentation/devicetree/bindings/mips/gic.txt b/Documentation/devicetree/bindings/mips/gic.txt
> >> new file mode 100644
> >> index 0000000..725f1ef
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/mips/gic.txt
> >> @@ -0,0 +1,50 @@
> >> +MIPS Global Interrupt Controller (GIC)
> >> +
> >> +The MIPS GIC routes external interrupts to individual VPEs and IRQ pins.
> >> +It also supports a timer and software-generated interrupts which can be
> >> +used as IPIs.
> >> +
> >> +Required properties:
> >> +- compatible : Should be "mti,global-interrupt-controller"
> >
> > I couldn't find "mti" in vendor-prefixes.txt (as of v3.17-rc3). If
> > there's not a patch to add it elsewhere, would you mind providing one
> > with this series?
> 
> Sure.  As James points out, "img" could also be used but I chose "mti"
> since the CPU interrupt controller also uses "mti" and I believe the
> GIC IP was developed before the acquisition by Imagination (though I'm
> not sure if that actually matters).

Using 'mti' sounds like the right choice to me given both of those
points.

> >> +- reg : Base address and length of the GIC registers.
> >> +- interrupts : Core interrupts to which the GIC may route external interrupts.
> >
> > How many?
> 
> Up to 6, one for each of the possible core hardware interrupts (i.e.
> interrupt vectors 2 - 7).  Which ones are available to the GIC depend
> on the system, for example Malta has an i8259 PIC hooked up to CPU
> interrupt vector 2, so that vector should not be used by the GIC.
> 
> > In any order?
> 
> They can technically be in any order, but when in strictly
> increasing/decreasing order they can be used along with the 3rd cell
> (described below) to prioritize interrupts.

Ok. Could you try to place that into the property description?

> >> +- interrupt-controller : Identifies the node as an interrupt controller
> >> +- #interrupt-cells : Specifies the number of cells needed to encode an
> >> +  interrupt specifier.  Should be 3.
> >> +  - The first cell is the GIC interrupt number.
> >> +  - The second cell encodes the interrupt flags.
> >> +    See <include/dt-bindings/interrupt-controller/irq.h> for a list of valid
> >> +    flags.
> >
> > Are all the flags valid for this interrupt controller?
> 
> Yes.

Ok.

> >> +  - The optional third cell indicates which CPU interrupt vector the GIC
> >> +    interrupt should be routed to.  It is a 0-based index into the list of
> >> +    GIC-to-CPU interrupts specified in the "interrupts" property described
> >> +    above.  For example, a '2' in this cell will route the interrupt to the
> >> +    3rd core interrupt listed in 'interrupts'.  If omitted, the interrupt will
> >> +    be routed to the 1st core interrupt.
> >
> > I don't follow why this should be in the DT. Why is this necessary?
> 
> Since the GIC can route external interrupts to any of the CPU hardware
> interrupt vectors, it can be used to assign priorities to external
> interrupts.  If the CPU is in vectored interrupt mode, the highest
> numbered interrupt vector (7) has the highest priority.  An example:
> 
> gic: interrupt-controller@1bdc0000 {
>         ...
>         interrupts = <3>, <4>;
>         ...
> };
> 
> uart {
>         ...
>         interrupt-parent = <&gic>;
>         interrupts = <24 IRQ_TYPE_LEVEL_HIGH 1>;
>         ...
> };
> 
> i2c {
>         ...
>         interrupt-parent = <&gic>;
>         interrupts = <33 IRQ_TYPE_LEVEL_HIGH 0>;
>         ...
> };
> 
> Since the third cell for the UART is '1', it maps to CPU interrupt
> vector 4 and thus has a higher priority than the I2C (whose third cell
> is 0, mapping to CPU interrupt vector 3).
> 
> Perhaps, though, this is an instance of software policy being
> specified in device-tree.  Other options would be to a) evenly
> distribute the GIC external interrupts across the CPU interrupt
> vectors available to the GIC, or b) just map all GIC external
> interrupts to a single interrupt vector.

As a user I don't see why the DT author should be in charge of whether
my UART gets higher priority than my I2C controller. That priority is
not a fixed property of the interrupt (as the line and flags are).

That said, this is a grey area. Are there any cases where this
prioritisation is critical on existing devices?

> > I also don't follow how this can be ommitted, given interrupt-cells is
> > required to be three by the wording above.
> 
> If it's absent, the interrupt will be routed to the first CPU
> interrupt vector in the list.  It's equivalent to the third cell being
> 0.

My point is that the wording implies that the third cell is optional on
a per-interrupt basis, when in reality it depends on the GIC node's
#interrupt-cells and affect all devices with GIC interrupts.

If &gic/#interrupt-cells = <3>, the third cell can't be absent.

If &gic/interrupt-cells = <2>, the third cell can't be present.

So it would be better to describe as something like:

  When interrupt-cells = <3>, the third cell specifies the priority (in
  the range X to Y). When #interrupt-cells = <2> all interrupts are
  assigned the same priority (Z).

Thanks,
Mark.
