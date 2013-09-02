Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866Ab3IBP6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 11:58:38 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51501 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758331Ab3IBP6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 11:58:36 -0400
Date: Mon, 2 Sep 2013 16:58:12 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: "hongbo.zhang@freescale.com" <hongbo.zhang@freescale.com>
Cc: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "djbw@fb.com" <djbw@fb.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 2/3] DMA: Freescale: Add new 8-channel DMA engine
 device tree nodes
Message-ID: <20130902155636.GA18206@e106331-lin.cambridge.arm.com>
References: <1377861980-7027-1-git-send-email-hongbo.zhang@freescale.com>
 <1377861980-7027-3-git-send-email-hongbo.zhang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377861980-7027-3-git-send-email-hongbo.zhang@freescale.com>
Thread-Topic: [PATCH v9 2/3] DMA: Freescale: Add new 8-channel DMA engine
 device tree nodes
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Aug 30, 2013 at 12:26:19PM +0100, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
>
> Freescale QorIQ T4 and B4 introduce new 8-channel DMA engines, this patch adds
> the device tree nodes for them.
>
> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
> ---
>  .../devicetree/bindings/powerpc/fsl/dma.txt        |   67 ++++++++++++++++
>  arch/powerpc/boot/dts/fsl/b4si-post.dtsi           |    4 +-
>  arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi          |   82 ++++++++++++++++++++
>  arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi          |   82 ++++++++++++++++++++
>  arch/powerpc/boot/dts/fsl/t4240si-post.dtsi        |    4 +-
>  5 files changed, 235 insertions(+), 4 deletions(-)
>  create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi
>  create mode 100644 arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi
>
> diff --git a/Documentation/devicetree/bindings/powerpc/fsl/dma.txt b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
> index ddf17af..332ac77 100644
> --- a/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
> +++ b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
> @@ -126,6 +126,73 @@ Example:
>                 };
>         };
>
> +** Freescale Elo3 DMA Controller
> +   This is EloPlus controller with 8 channels, used in Freescale Txxx and Bxxx

I was under the impression EloPlus was the previous revision. Should
that say Elo3, or is Elo3 considered to be an EloPlus implementation?

> +   series chips, such as t1040, t4240, b4860.
> +
> +Required properties:
> +
> +- compatible        : must include "fsl,elo3-dma"
> +- reg               : <registers specifier for DMA general status reg>

The example has two reg entries. What both are should be specified. From
what you described last time, it sounds like each is a status register
for four channels.

Presumably the first covers the channels at 0x0,0x80,0x100,0x180, and
the second covers the channels at 0x300,0x380,0x400,0x480? If the
registers have specific names in a datasheet, it would be worth
mentioning them.

If the specification of the DMA controller allows for more channels, it
may be worth describing that case now.

> +- ranges            : describes the mapping between the address space of the
> +                      DMA channels and the address space of the DMA controller

This looks odd as a required property, and I'm slightly confused. Is
this used to map the reg values of the DMA channels, or is it used when
mapping the DMA address space (for which dma-ranges exists in ePAPR and
other bindings).

> +
> +- DMA channel nodes:
> +        - compatible        : must include "fsl,eloplus-dma-channel"
> +        - reg               : <registers specifier for channel>

What does this represent? What are valid values?

In the example below it looks like these are offsets of control
registers within the dma controller.

If the reg property may have any value, how do they get mapped to bits
in the status register(s)?

May some channels be unusable for some reason, or will all eight
channels be wired on any given Elo3 DMA?

Cheers,
Mark.

> +        - interrupts        : <interrupt specifier for DMA channel IRQ>
> +        - interrupt-parent  : optional, if needed for interrupt mapping
> +
> +Example:
> +dma@100300 {
> +       #address-cells = <1>;
> +       #size-cells = <1>;
> +       compatible = "fsl,elo3-dma";
> +       reg = <0x100300 0x4>,
> +             <0x100600 0x4>;
> +       ranges = <0x0 0x100100 0x500>;
> +       dma-channel@0 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x0 0x80>;
> +               interrupts = <28 2 0 0>;
> +       };
> +       dma-channel@80 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x80 0x80>;
> +               interrupts = <29 2 0 0>;
> +       };
> +       dma-channel@100 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x100 0x80>;
> +               interrupts = <30 2 0 0>;
> +       };
> +       dma-channel@180 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x180 0x80>;
> +               interrupts = <31 2 0 0>;
> +       };
> +       dma-channel@300 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x300 0x80>;
> +               interrupts = <76 2 0 0>;
> +       };
> +       dma-channel@380 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x380 0x80>;
> +               interrupts = <77 2 0 0>;
> +       };
> +       dma-channel@400 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x400 0x80>;
> +               interrupts = <78 2 0 0>;
> +       };
> +       dma-channel@480 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x480 0x80>;
> +               interrupts = <79 2 0 0>;
> +       };
> +};
> +
>  Note on DMA channel compatible properties: The compatible property must say
>  "fsl,elo-dma-channel" or "fsl,eloplus-dma-channel" to be used by the Elo DMA
>  driver (fsldma).  Any DMA channel used by fsldma cannot be used by another
> diff --git a/arch/powerpc/boot/dts/fsl/b4si-post.dtsi b/arch/powerpc/boot/dts/fsl/b4si-post.dtsi
> index 7399154..ea53ea1 100644
> --- a/arch/powerpc/boot/dts/fsl/b4si-post.dtsi
> +++ b/arch/powerpc/boot/dts/fsl/b4si-post.dtsi
> @@ -223,13 +223,13 @@
>                 reg = <0xe2000 0x1000>;
>         };
>
> -/include/ "qoriq-dma-0.dtsi"
> +/include/ "elo3-dma-0.dtsi"
>         dma@100300 {
>                 fsl,iommu-parent = <&pamu0>;
>                 fsl,liodn-reg = <&guts 0x580>; /* DMA1LIODNR */
>         };
>
> -/include/ "qoriq-dma-1.dtsi"
> +/include/ "elo3-dma-1.dtsi"
>         dma@101300 {
>                 fsl,iommu-parent = <&pamu0>;
>                 fsl,liodn-reg = <&guts 0x584>; /* DMA2LIODNR */
> diff --git a/arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi b/arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi
> new file mode 100644
> index 0000000..3c210e0
> --- /dev/null
> +++ b/arch/powerpc/boot/dts/fsl/elo3-dma-0.dtsi
> @@ -0,0 +1,82 @@
> +/*
> + * QorIQ Elo3 DMA device tree stub [ controller @ offset 0x100000 ]
> + *
> + * Copyright 2013 Freescale Semiconductor Inc.
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions are met:
> + *     * Redistributions of source code must retain the above copyright
> + *       notice, this list of conditions and the following disclaimer.
> + *     * Redistributions in binary form must reproduce the above copyright
> + *       notice, this list of conditions and the following disclaimer in the
> + *       documentation and/or other materials provided with the distribution.
> + *     * Neither the name of Freescale Semiconductor nor the
> + *       names of its contributors may be used to endorse or promote products
> + *       derived from this software without specific prior written permission.
> + *
> + *
> + * ALTERNATIVELY, this software may be distributed under the terms of the
> + * GNU General Public License ("GPL") as published by the Free Software
> + * Foundation, either version 2 of that License or (at your option) any
> + * later version.
> + *
> + * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
> + * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
> + * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
> + * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
> + * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
> + * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
> + * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
> + * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
> + * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> + */
> +
> +dma0: dma@100300 {
> +       #address-cells = <1>;
> +       #size-cells = <1>;
> +       compatible = "fsl,elo3-dma";
> +       reg = <0x100300 0x4>,
> +             <0x100600 0x4>;
> +       ranges = <0x0 0x100100 0x500>;
> +       dma-channel@0 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x0 0x80>;
> +               interrupts = <28 2 0 0>;
> +       };
> +       dma-channel@80 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x80 0x80>;
> +               interrupts = <29 2 0 0>;
> +       };
> +       dma-channel@100 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x100 0x80>;
> +               interrupts = <30 2 0 0>;
> +       };
> +       dma-channel@180 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x180 0x80>;
> +               interrupts = <31 2 0 0>;
> +       };
> +       dma-channel@300 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x300 0x80>;
> +               interrupts = <76 2 0 0>;
> +       };
> +       dma-channel@380 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x380 0x80>;
> +               interrupts = <77 2 0 0>;
> +       };
> +       dma-channel@400 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x400 0x80>;
> +               interrupts = <78 2 0 0>;
> +       };
> +       dma-channel@480 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x480 0x80>;
> +               interrupts = <79 2 0 0>;
> +       };
> +};
> diff --git a/arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi b/arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi
> new file mode 100644
> index 0000000..cccf3bb
> --- /dev/null
> +++ b/arch/powerpc/boot/dts/fsl/elo3-dma-1.dtsi
> @@ -0,0 +1,82 @@
> +/*
> + * QorIQ Elo3 DMA device tree stub [ controller @ offset 0x101000 ]
> + *
> + * Copyright 2013 Freescale Semiconductor Inc.
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions are met:
> + *     * Redistributions of source code must retain the above copyright
> + *       notice, this list of conditions and the following disclaimer.
> + *     * Redistributions in binary form must reproduce the above copyright
> + *       notice, this list of conditions and the following disclaimer in the
> + *       documentation and/or other materials provided with the distribution.
> + *     * Neither the name of Freescale Semiconductor nor the
> + *       names of its contributors may be used to endorse or promote products
> + *       derived from this software without specific prior written permission.
> + *
> + *
> + * ALTERNATIVELY, this software may be distributed under the terms of the
> + * GNU General Public License ("GPL") as published by the Free Software
> + * Foundation, either version 2 of that License or (at your option) any
> + * later version.
> + *
> + * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
> + * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
> + * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
> + * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
> + * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
> + * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
> + * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
> + * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
> + * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> + */
> +
> +dma1: dma@101300 {
> +       #address-cells = <1>;
> +       #size-cells = <1>;
> +       compatible = "fsl,elo3-dma";
> +       reg = <0x101300 0x4>,
> +             <0x101600 0x4>;
> +       ranges = <0x0 0x101100 0x500>;
> +       dma-channel@0 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x0 0x80>;
> +               interrupts = <32 2 0 0>;
> +       };
> +       dma-channel@80 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x80 0x80>;
> +               interrupts = <33 2 0 0>;
> +       };
> +       dma-channel@100 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x100 0x80>;
> +               interrupts = <34 2 0 0>;
> +       };
> +       dma-channel@180 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x180 0x80>;
> +               interrupts = <35 2 0 0>;
> +       };
> +       dma-channel@300 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x300 0x80>;
> +               interrupts = <80 2 0 0>;
> +       };
> +       dma-channel@380 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x380 0x80>;
> +               interrupts = <81 2 0 0>;
> +       };
> +       dma-channel@400 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x400 0x80>;
> +               interrupts = <82 2 0 0>;
> +       };
> +       dma-channel@480 {
> +               compatible = "fsl,eloplus-dma-channel";
> +               reg = <0x480 0x80>;
> +               interrupts = <83 2 0 0>;
> +       };
> +};
> diff --git a/arch/powerpc/boot/dts/fsl/t4240si-post.dtsi b/arch/powerpc/boot/dts/fsl/t4240si-post.dtsi
> index bd611a9..ec95c60 100644
> --- a/arch/powerpc/boot/dts/fsl/t4240si-post.dtsi
> +++ b/arch/powerpc/boot/dts/fsl/t4240si-post.dtsi
> @@ -387,8 +387,8 @@
>                 reg        = <0xea000 0x4000>;
>         };
>
> -/include/ "qoriq-dma-0.dtsi"
> -/include/ "qoriq-dma-1.dtsi"
> +/include/ "elo3-dma-0.dtsi"
> +/include/ "elo3-dma-1.dtsi"
>
>  /include/ "qoriq-espi-0.dtsi"
>         spi@110000 {
> --
> 1.7.9.5
>
>
>
>
