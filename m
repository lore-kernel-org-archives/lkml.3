Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651Ab3EWLbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 07:31:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:3140 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758418Ab3EWLbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 07:31:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,728,1363158000"; 
   d="scan'208";a="306762919"
Date: Thu, 23 May 2013 16:24:40 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 26/63] dmaengine: ste_dma40: Supply full Device Tree
 parsing support
Message-ID: <20130523105440.GH30200@intel.com>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
 <1367591569-32197-27-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367591569-32197-27-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 03:32:12PM +0100, Lee Jones wrote:
> Using the new DMA DT bindings and API, we can register the DMA40 driver
> as Device Tree capable. Now, when a client attempts to allocate a
> channel using the DMA DT bindings via its own node, we are able to parse
> the request and allocate a channel in the correct manner.
> 
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: devicetree-discuss@lists.ozlabs.org
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Vinod Koul <vinod.koul@intel.com>

--
~Vinod
> ---
>  .../devicetree/bindings/dma/ste-dma40.txt          |   62 ++++++++++++++++++++
>  drivers/dma/ste_dma40.c                            |   52 ++++++++++++++++
>  2 files changed, 114 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/dma/ste-dma40.txt
> 
> diff --git a/Documentation/devicetree/bindings/dma/ste-dma40.txt b/Documentation/devicetree/bindings/dma/ste-dma40.txt
> new file mode 100644
> index 0000000..2679a87
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/dma/ste-dma40.txt
> @@ -0,0 +1,62 @@
> +* DMA40 DMA Controller
> +
> +Required properties:
> +- compatible: "stericsson,dma40"
> +- reg: Address range of the DMAC registers
> +- reg-names: Names of the above areas to use during resource look-up
> +- interrupt: Should contain the DMAC interrupt number
> +- #dma-cells: must be <3>
> +
> +Optional properties:
> +- dma-channels: Number of channels supported by hardware - if not present
> +		the driver will attempt to obtain the information from H/W
> +
> +Example:
> +
> +	dma: dma-controller@801C0000 {
> +		compatible = "stericsson,db8500-dma40", "stericsson,dma40";
> +		reg = <0x801C0000 0x1000  0x40010000 0x800>;
> +		reg-names = "base", "lcpa";
> +		interrupt-parent = <&intc>;
> +		interrupts = <0 25 0x4>;
> +
> +		#dma-cells = <2>;
> +		dma-channels = <8>;
> +	};
> +
> +Clients
> +Required properties:
> +- dmas: Comma separated list of dma channel requests
> +- dma-names: Names of the aforementioned requested channels
> +
> +Each dmas request consists of 4 cells:
> +  1. A phandle pointing to the DMA controller
> +  2. Device Type
> +  3. The DMA request line number (only when 'use fixed channel' is set)
> +  4. A 32bit mask specifying; mode, direction and endianess [NB: This list will grow]
> +        0x00000001: Mode:
> +                Logical channel when unset
> +                Physical channel when set
> +        0x00000002: Direction:
> +                Memory to Device when unset
> +                Device to Memory when set
> +        0x00000004: Endianess:
> +                Little endian when unset
> +                Big endian when set
> +        0x00000008: Use fixed channel:
> +                Use automatic channel selection when unset
> +                Use DMA request line number when set
> +
> +Example:
> +
> +	uart@80120000 {
> +		compatible = "arm,pl011", "arm,primecell";
> +		reg = <0x80120000 0x1000>;
> +		interrupts = <0 11 0x4>;
> +
> +		dmas = <&dma 13 0 0x2>, /* Logical - DevToMem */
> +		       <&dma 13 0 0x0>; /* Logical - MemToDev */
> +		dma-names = "rx", "rx";
> +
> +		status = "disabled";
> +	};
> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> index d7c2397..b77d508 100644
> --- a/drivers/dma/ste_dma40.c
> +++ b/drivers/dma/ste_dma40.c
> @@ -18,6 +18,7 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/err.h>
>  #include <linux/of.h>
> +#include <linux/of_dma.h>
>  #include <linux/amba/bus.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/platform_data/dma-ste-dma40.h>
> @@ -2419,6 +2420,50 @@ static void d40_set_prio_realtime(struct d40_chan *d40c)
>  		__d40_set_prio_rt(d40c, d40c->dma_cfg.dev_type, false);
>  }
>  
> +#define D40_DT_FLAGS_MODE(flags)       ((flags >> 0) & 0x1)
> +#define D40_DT_FLAGS_DIR(flags)        ((flags >> 1) & 0x1)
> +#define D40_DT_FLAGS_BIG_ENDIAN(flags) ((flags >> 2) & 0x1)
> +#define D40_DT_FLAGS_FIXED_CHAN(flags) ((flags >> 3) & 0x1)
> +
> +static struct dma_chan *d40_xlate(struct of_phandle_args *dma_spec,
> +				  struct of_dma *ofdma)
> +{
> +	struct stedma40_chan_cfg cfg;
> +	dma_cap_mask_t cap;
> +	u32 flags;
> +
> +	memset(&cfg, 0, sizeof(struct stedma40_chan_cfg));
> +
> +	dma_cap_zero(cap);
> +	dma_cap_set(DMA_SLAVE, cap);
> +
> +	cfg.dev_type = dma_spec->args[0];
> +	flags = dma_spec->args[2];
> +
> +	switch (D40_DT_FLAGS_MODE(flags)) {
> +	case 0: cfg.mode = STEDMA40_MODE_LOGICAL; break;
> +	case 1: cfg.mode = STEDMA40_MODE_PHYSICAL; break;
> +	}
> +
> +	switch (D40_DT_FLAGS_DIR(flags)) {
> +	case 0:
> +		cfg.dir = STEDMA40_MEM_TO_PERIPH;
> +		cfg.dst_info.big_endian = D40_DT_FLAGS_BIG_ENDIAN(flags);
> +		break;
> +	case 1:
> +		cfg.dir = STEDMA40_PERIPH_TO_MEM;
> +		cfg.src_info.big_endian = D40_DT_FLAGS_BIG_ENDIAN(flags);
> +		break;
> +	}
> +
> +	if (D40_DT_FLAGS_FIXED_CHAN(flags)) {
> +		cfg.phy_channel = dma_spec->args[1];
> +		cfg.use_fixed_channel = true;
> +	}
> +
> +	return dma_request_channel(cap, stedma40_filter, &cfg);
> +}
> +
>  /* DMA ENGINE functions */
>  static int d40_alloc_chan_resources(struct dma_chan *chan)
>  {
> @@ -3632,6 +3677,13 @@ static int __init d40_probe(struct platform_device *pdev)
>  
>  	d40_hw_init(base);
>  
> +	if (np) {
> +		err = of_dma_controller_register(np, d40_xlate, NULL);
> +		if (err && err != -ENODEV)
> +			dev_err(&pdev->dev,
> +				"could not register of_dma_controller\n");
> +	}
> +
>  	dev_info(base->dev, "initialized\n");
>  	return 0;
>  
> -- 
> 1.7.10.4
> 
