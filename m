Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbaIALBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:01:34 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60820 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752638AbaIALBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:01:32 -0400
Date: Mon, 1 Sep 2014 12:01:19 +0100
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
Message-ID: <20140901110119.GB6617@leverpostej>
References: <1409350479-19108-1-git-send-email-abrestic@chromium.org>
 <1409350479-19108-4-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409350479-19108-4-git-send-email-abrestic@chromium.org>
Thread-Topic: [PATCH 03/12] of: Add binding document for MIPS GIC
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 11:14:30PM +0100, Andrew Bresticker wrote:
> The Global Interrupt Controller (GIC) present on certain MIPS systems
> can be used to route external interrupts to individual VPEs and CPU
> interrupt vectors.  It also supports a timer and software-generated
> interrupts.
> 
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> ---
>  Documentation/devicetree/bindings/mips/gic.txt | 50 ++++++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mips/gic.txt
> 
> diff --git a/Documentation/devicetree/bindings/mips/gic.txt b/Documentation/devicetree/bindings/mips/gic.txt
> new file mode 100644
> index 0000000..725f1ef
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mips/gic.txt
> @@ -0,0 +1,50 @@
> +MIPS Global Interrupt Controller (GIC)
> +
> +The MIPS GIC routes external interrupts to individual VPEs and IRQ pins.
> +It also supports a timer and software-generated interrupts which can be
> +used as IPIs.
> +
> +Required properties:
> +- compatible : Should be "mti,global-interrupt-controller"

I couldn't find "mti" in vendor-prefixes.txt (as of v3.17-rc3). If
there's not a patch to add it elsewhere, would you mind providing one
with this series?

> +- reg : Base address and length of the GIC registers.
> +- interrupts : Core interrupts to which the GIC may route external interrupts.

How many? in any order?

> +- interrupt-controller : Identifies the node as an interrupt controller
> +- #interrupt-cells : Specifies the number of cells needed to encode an
> +  interrupt specifier.  Should be 3.
> +  - The first cell is the GIC interrupt number.
> +  - The second cell encodes the interrupt flags.
> +    See <include/dt-bindings/interrupt-controller/irq.h> for a list of valid
> +    flags.

Are all the flags valid for this interrupt controller?

> +  - The optional third cell indicates which CPU interrupt vector the GIC
> +    interrupt should be routed to.  It is a 0-based index into the list of
> +    GIC-to-CPU interrupts specified in the "interrupts" property described
> +    above.  For example, a '2' in this cell will route the interrupt to the
> +    3rd core interrupt listed in 'interrupts'.  If omitted, the interrupt will
> +    be routed to the 1st core interrupt.

I don't follow why this should be in the DT. Why is this necessary?

I also don't follow how this can be ommitted, given interrupt-cells is
required to be three by the wording above.

> +
> +Example:
> +
> +	cpu_intc: interrupt-controller@0 {

Nit: there's no reg on this node, so there shouldn't be a unit-address.

Thanks,
Mark.

> +		compatible = "mti,cpu-interrupt-controller";
> +
> +		interrupt-controller;
> +		#interrupt-cells = <1>;
> +	};
> +
> +	gic: interrupt-controller@1bdc0000 {
> +		compatible = "mti,global-interrupt-controller";
> +		reg = <0x1bdc0000 0x20000>;
> +
> +		interrupt-controller;
> +		#interrupt-cells = <3>;
> +
> +		interrupt-parent = <&cpu_intc>;
> +		interrupts = <3>, <4>;
> +	};
> +
> +	uart@18101400 {
> +		...
> +		interrupt-parent = <&gic>;
> +		interrupts = <24 IRQ_TYPE_LEVEL_HIGH 0>;
> +		...
> +	};
> -- 
> 2.1.0.rc2.206.gedb03e5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
