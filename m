Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbaIBR1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:27:44 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:45958 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbaIBR1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:27:42 -0400
Message-ID: <5405FE07.4030400@gmail.com>
Date: Tue, 02 Sep 2014 10:27:35 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>
CC: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/12] of: Add binding document for MIPS GIC
References: <1409350479-19108-1-git-send-email-abrestic@chromium.org> <1409350479-19108-4-git-send-email-abrestic@chromium.org>
In-Reply-To: <1409350479-19108-4-git-send-email-abrestic@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2014 03:14 PM, Andrew Bresticker wrote:
> The Global Interrupt Controller (GIC) present on certain MIPS systems
> can be used to route external interrupts to individual VPEs and CPU
> interrupt vectors.  It also supports a timer and software-generated
> interrupts.
>
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> ---
>   Documentation/devicetree/bindings/mips/gic.txt | 50 ++++++++++++++++++++++++++
>   1 file changed, 50 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/mips/gic.txt
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
> +- reg : Base address and length of the GIC registers.
> +- interrupts : Core interrupts to which the GIC may route external interrupts.

This doesn't make sense to me.  The GIC can, and does, route interrupts 
to all CPU cores in a SMP system.  How can there be a concept of only 
associating it with several interrupt lines on a single CPU in the 
system?  That is not what the GIC does, is it?  It is a Global 
interrupts controller, not local.  So specifying device tree bindings 
that don't show its Global nature seems wrong.


> +- interrupt-controller : Identifies the node as an interrupt controller
> +- #interrupt-cells : Specifies the number of cells needed to encode an
> +  interrupt specifier.  Should be 3.
> +  - The first cell is the GIC interrupt number.
> +  - The second cell encodes the interrupt flags.
> +    See <include/dt-bindings/interrupt-controller/irq.h> for a list of valid
> +    flags.
> +  - The optional third cell indicates which CPU interrupt vector the GIC
> +    interrupt should be routed to.  It is a 0-based index into the list of
> +    GIC-to-CPU interrupts specified in the "interrupts" property described
> +    above.  For example, a '2' in this cell will route the interrupt to the
> +    3rd core interrupt listed in 'interrupts'.  If omitted, the interrupt will
> +    be routed to the 1st core interrupt.
> +

This seems like a really convoluted way of doing things that really goes 
against the device tree model.

The routing of interrupts through the GIC to a core interrupt is 
controlled entirely within the GIC hardware and therefore should be a 
property of the GIC itself, not all the random devices connected 
upstream to the GIC.

It also places policy about the priority of the various interrupts into 
the device tree.  Typically the device tree would contain only 
information about the topology of the hardware blocks, not arbitrary 
policy decisions that software could change and still have a perfectly 
functional system.

Therefore I would recommend removing the third cell from the interrupt 
specifier.


> +Example:
> +
> +	cpu_intc: interrupt-controller@0 {
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
>

