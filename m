Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935048AbaFTRJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 13:09:47 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49795 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754378AbaFTRJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 13:09:45 -0400
Date: Fri, 20 Jun 2014 18:09:01 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 1/2] video: ARM CLCD: Add DT support
Message-ID: <20140620170901.GA12059@leverpostej>
References: <1403018494-10264-1-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403018494-10264-1-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pawel,

On Tue, Jun 17, 2014 at 04:21:33PM +0100, Pawel Moll wrote:
> This patch adds basic DT bindings for the PL11x CLCD cells
> and make their fbdev driver use them.
> 
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> ---
> Changes since v6:
> - replaced in-node device-timing subnode with the standard
>   video interface bindings (as in: ports & endpoints); only
>   "panel-dpi" compatible panels are supported in the driver
> 
> Changes since v5:
> - realised that dma_alloc_writecombine() is a arm-specific function;
>   replaced with generic dma_alloc_coherent()/dma_mmap_writecombine()
> 
> Changes since v4:
> - simplified the pads description property and made it optional
> 
> Changes since v3:
> - changed wording and order of interrupt-names and interrupts
>   properties documentation
> - changed wording of arm,pl11x,framebuffer-base property
>   documentation
> - cleaned up binding documentation indentation
> 
> Changes since v2:
> - replaced video-ram phandle with arm,pl11x,framebuffer-base
> - replaced panel-* properties with arm,pl11x,panel-data-pads
> - replaced max-framebuffer-size with max-memory-bandwidth
> - modified clcdfb_of_init_tft_panel() to use the pads
>   data and take differences between PL110 and PL110 into
>   account
> 
> Changes since v1:
> - minor code cleanups as suggested by Sylwester Nawrocki
> 
>  .../devicetree/bindings/video/arm,pl11x.txt        | 102 ++++++++
>  drivers/video/fbdev/Kconfig                        |   1 +
>  drivers/video/fbdev/amba-clcd.c                    | 268 +++++++++++++++++++++
>  3 files changed, 371 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/video/arm,pl11x.txt
> 
> diff --git a/Documentation/devicetree/bindings/video/arm,pl11x.txt b/Documentation/devicetree/bindings/video/arm,pl11x.txt
> new file mode 100644
> index 0000000..54124c6
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/video/arm,pl11x.txt
> @@ -0,0 +1,102 @@
> +* ARM PrimeCell Color LCD Controller PL110/PL111
> +
> +See also Documentation/devicetree/bindings/arm/primecell.txt
> +
> +Required properties:
> +
> +- compatible: must be one of:
> +	"arm,pl110", "arm,primecell"
> +	"arm,pl111", "arm,primecell"
> +
> +- reg: base address and size of the control registers block
> +
> +- interrupt-names: either the single entry "combined" representing a
> +	combined interrupt output (CLCDINTR), or the four entries
> +	"mbe", "vcomp", "lnbu", "fuf" representing the individual
> +	CLCDMBEINTR, CLCDVCOMPINTR, CLCDLNBUINTR, CLCDFUFINTR interrupts
> +
> +- interrupts: contains an interrupt specifier for each entry in
> +	interrupt-names
> +
> +- clocks-names: should contain "clcdclk" and "apb_pclk"

s/clocks-names/clock-names/

> +
> +- clocks: contains phandle and clock specifier pairs for the entries
> +	in the clock-names property. See
> +	Documentation/devicetree/binding/clock/clock-bindings.txt
> +
> +Optional properties:
> +
> +- arm,pl11x,framebuffer-base: a pair of two 32-bit values, address and size,
> +	defining the framebuffer that must be used; if not present, the
> +	framebuffer may be located anywhere in the memory

The name is confusing: this is a base _and_ size.

When should this be used, and what is valid to point it at?

How does this play with memory carveouts (CMA, reserved-memory)?

> +- max-memory-bandwidth: maximum bandwidth in bytes per second that the
> +	cell's memory interface can handle

When should I set this, given it is optional?

> +
> +Required sub-nodes:
> +
> +- port: describes LCD panel signals, following the common binding
> +	for video transmitter interfaces; see
> +	Documentation/devicetree/bindings/media/video-interfaces.txt;
> +	when it is a TFT panel, the port's endpoint must define the
> +	following property:
> +
> +	- arm,pl11x,tft-r0g0b0-pads: an array of three 32-bit values,
> +		defining the way CLD pads are wired up; this implicitly
> +		defines available color modes, for example:
> +		- PL111 TFT 4:4:4 panel:
> +			arm,pl11x,tft-r0g0b0-pads = <4 15 20>;
> +		- PL110 TFT (1:)5:5:5 panel:
> +			arm,pl11x,tft-r0g0b0-pads = <1 7 13>;
> +		- PL111 TFT (1:)5:5:5 panel:
> +			arm,pl11x,tft-r0g0b0-pads = <3 11 19>;
> +		- PL111 TFT 5:6:5 panel:
> +			arm,pl11x,tft-r0g0b0-pads = <3 10 19>;
> +		- PL110 and PL111 TFT 8:8:8 panel:
> +			arm,pl11x,tft-r0g0b0-pads = <0 8 16>;
> +		- PL110 and PL111 TFT 8:8:8 panel, R & B components swapped:
> +			arm,pl11x,tft-r0g0b0-pads = <16 8 0>;

I'm somewhat lost trying to figure out this mapping. Am I not looking at
this in the right way, or is there any documentation which makes this
clearer?

Thanks,
Mark.
