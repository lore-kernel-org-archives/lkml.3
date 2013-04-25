Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab3DYLdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:33:43 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:40285 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab3DYLdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:33:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130418141752.GC3959@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-25-git-send-email-lee.jones@linaro.org>
	<20130418121253.GF27903@gmail.com>
	<20130418141752.GC3959@gmail.com>
Date: Thu, 25 Apr 2013 13:33:41 +0200
Message-ID: <CACRpkdZiTCpkhLWiOU3yKJkHgg=od5qc-UemWRB07f7OE+RZ0A@mail.gmail.com>
Subject: Re: [PATCH 24/32 v3] dmaengine: ste_dma40: Supply full Device Tree
 parsing support
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 4:17 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Using the new DMA DT bindings and API, we can register the DMA40 driver
> as Device Tree capable. Now, when a client attempts to allocate a
> channel using the DMA DT bindings via its own node, we are able to parse
> the request and allocate a channel in the correct manner.
>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>


This needs to be CC: to devicetree-discussed so it can be checked for OS
independence and such... Also consider including Rob Herring on posts.

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
> +               the driver will attempt to obtain the information from H/W

I want you to define the memcpy channels in device tree as well.
Right now these are hardcoded into the driver and there is no way
to check whether they happen to overlap with other channels from the
device tree, i.e. a source of confusion.

Please add configuration for the static memcpy channels here.

> +#define D40_DT_FLAGS_MODE(flags)       ((flags >> 0) & 0x1)
> +#define D40_DT_FLAGS_DIR(flags)        ((flags >> 1) & 0x1)
> +#define D40_DT_FLAGS_BIG_ENDIAN(flags) ((flags >> 2) & 0x1)
> +#define D40_DT_FLAGS_FIXED_CHAN(flags) ((flags >> 3) & 0x1)
> +
> +static struct dma_chan *d40_xlate(struct of_phandle_args *dma_spec,
> +                                 struct of_dma *ofdma)
> +{
> +       struct stedma40_chan_cfg cfg;
> +       dma_cap_mask_t cap;
> +       u32 flags;
> +
> +       memset(&cfg, 0, sizeof(struct stedma40_chan_cfg));
> +
> +       dma_cap_zero(cap);
> +       dma_cap_set(DMA_SLAVE, cap);
> +
> +       cfg.dev_type = dma_spec->args[0];
> +       flags = dma_spec->args[2];
> +
> +       switch (D40_DT_FLAGS_MODE(flags)) {
> +       case 0: cfg.mode = STEDMA40_MODE_LOGICAL; break;
> +       case 1: cfg.mode = STEDMA40_MODE_PHYSICAL; break;
> +       }
> +
> +       switch (D40_DT_FLAGS_DIR(flags)) {
> +       case 0:
> +               cfg.dir = STEDMA40_MEM_TO_PERIPH;
> +               cfg.dst_info.big_endian = D40_DT_FLAGS_BIG_ENDIAN(flags);
> +               break;
> +       case 1:
> +               cfg.dir = STEDMA40_PERIPH_TO_MEM;
> +               cfg.src_info.big_endian = D40_DT_FLAGS_BIG_ENDIAN(flags);
> +               break;
> +       }
> +
> +       if (D40_DT_FLAGS_FIXED_CHAN(flags)) {
> +               cfg.phy_channel = dma_spec->args[1];
> +               cfg.use_fixed_channel = true;
> +       }
> +
> +       return dma_request_channel(cap, stedma40_filter, &cfg);
> +}

Nice! But please include handling of the memcpy channels.
(Unclear to me how to do that, but now i becomes your problem ;-)

> +       if (np) {
> +               err = of_dma_controller_register(np, d40_xlate, NULL);
> +               if (err && err != -ENODEV)
> +                       dev_err(&pdev->dev,
> +                               "could not register of_dma_controller\n");
> +       }
> +
>         dev_info(base->dev, "initialized\n");
>         return 0;

Is it really OK to just fall through after failing to register the controller
from the device tree?

Yours,
Linus Walleij
