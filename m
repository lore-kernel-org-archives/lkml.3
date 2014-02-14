Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbaBNK6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 05:58:53 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62938 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751584AbaBNK6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 05:58:51 -0500
Date: Fri, 14 Feb 2014 10:58:22 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 23/27] clocksource: sh_cmt: Add DT support
Message-ID: <20140214105822.GE9907@e106331-lin.cambridge.arm.com>
References: <1392339605-20691-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1392339605-20691-24-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392339605-20691-24-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 01:00:01AM +0000, Laurent Pinchart wrote:
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  .../devicetree/bindings/timer/renesas,cmt.txt      |  75 +++++++++++++++
>  drivers/clocksource/sh_cmt.c                       | 104 +++++++++++++++++----
>  2 files changed, 160 insertions(+), 19 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/timer/renesas,cmt.txt
> 
> diff --git a/Documentation/devicetree/bindings/timer/renesas,cmt.txt b/Documentation/devicetree/bindings/timer/renesas,cmt.txt
> new file mode 100644
> index 0000000..28d4ab5
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/timer/renesas,cmt.txt
> @@ -0,0 +1,75 @@
> +* Renesas R-Car Compare Match Timer (CMT)
> +
> +The CMT is a multi-channel 16/32/48-bit timer/counter with configurable clock
> +inputs and programmable compare match.
> +
> +Channels share hadware resources but their counter and compare match value are
> +independent. A particular CMT instance can implement only a subset of the
> +channels supported by the CMT model. Channels indices start from 0 and are
> +consecutive.
> +
> +Required Properties:
> +
> +  - compatible: must contain one of the following.
> +    - "renesas,cmt-32" for the 32-bit CMT
> +		(CMT0 on sh7372, sh73a0 and r8a7740)
> +    - "renesas,cmt-32-fast" for the 32-bit CMT with fast clock support
> +		(CMT[234] on sh7372, sh73a0 and r8a7740)
> +    - "renasas,cmt-48" for the 48-bit CMT
> +		(CMT1 on sh7372, sh73a0 and r8a7740)
> +    - "renesas,cmt-48-gen2" for the second generation 48-bit CMT
> +    		(CMT[01] on r8a73a4, r8a7790 and r8a7791)
> +
> +  - reg: base address and length of the registers block for the timer module.
> +  - interrupt-parent, interrupts: interrupt-specifier for the timer, one per
> +    channel.

It might make more sense to describe the interrupt on the channel
subnode. It makes it far clearer which channel has which interrupt.

> +  - clocks: phandle and clock-specifier pair for the functional clock.
> +  - clock-names: must be "fck".

It would be nice to define the list once:

- clocks: A list of phandle + clock-specifier pairs, one for each entry
  in clock-names.
- clock-names: Should contain "fck" for the functional clock.

> +
> +  - #address-cells: must be 1
> +  - #size-cells: must be 0
> +
> +  - renesas,channels-mask: integer bitmask of the channels implemented by the
> +    timer instance.

This is implied by the presence of a subnode. Either remove this or the
subnodes.

> +
> +
> +Each channel is described by a sub-node named "channel@<idx>", where <idx> is
> +the channel index.
> +
> +Channels Required Properties:
> +
> +  - reg: the channel index.
> +
> +Channels Optional Properties:
> +
> +  - clock-source-rating: rating of the timer as a clock source device.
> +  - clock-event-rating: rating of the timer as a clock event device.

This feels like a leak of Linux internals. Why do you need this?

> +
> +
> +Example: R8A7790 (R-Car H2) CMT0 node
> +
> +	CMT0 on R8A7790 implements hardware channels 5 and 6 only and names
> +	them channels 0 and 1 in the documentation.
> +
> +	cmt0: timer@ffca0000 {
> +		compatible = "renesas,cmt-48-gen2";
> +		reg = <0 0xffca0000 0 0x1004>;
> +		interrupt-parent = <&gic>;
> +		interrupts = <0 142 IRQ_TYPE_LEVEL_HIGH>,
> +			     <0 142 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&mstp1_clks R8A7790_CLK_CMT0>;
> +
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		renesas,channels-mask = <0x60>;
> +
> +		channel@0 {
> +			reg = <0>;
> +			clock-event-rating = <80>;
> +		};
> +		channel@0 {
> +			reg = <0>;
> +			clock-source-rating = <80>;
> +		};

Aaargh. Use the _real_ channel IDs for the reg proeprties and get rid of
the mask. It's pointlessly confusing.

Thanks,
Mark
