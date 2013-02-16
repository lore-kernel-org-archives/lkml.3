Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab3BPLNG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 06:13:06 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:37040 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab3BPLNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 06:13:04 -0500
MIME-Version: 1.0
In-Reply-To: <1360952512-971558-3-git-send-email-arnd@arndb.de>
References: <1360952512-971558-1-git-send-email-arnd@arndb.de>
	<1360952512-971558-3-git-send-email-arnd@arndb.de>
Date: Sat, 16 Feb 2013 13:13:01 +0200
Message-ID: <CAHp75VfyO5wep-shvZ_mkwLmL2_Fa2jgq63AvE2t8=TPLZn6yg@mail.gmail.com>
Subject: Re: [PATCH 2/4] dmaengine: dw_dmac: move to generic DMA binding
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 8:21 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> The original device tree binding for this driver, from Viresh Kumar
> unfortunately conflicted with the generic DMA binding, and did not allow
> to completely seperate slave device configuration from the controller.
>
> This is an attempt to replace it with an implementation of the generic
> binding, but it is currently completely untested, because I do not have
> any hardware with this particular controller.
>
> The patch applies on top of linux-next, which contains both the base
> support for the generic DMA binding, as well as the earlier attempt from
> Viresh. Both of these are currently not merged upstream however.
>
> There are a couple of TODO items that are left remaining and are open
> for ideas from other people.

> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c

> @@ -168,7 +169,13 @@ static void dwc_initialize(struct dw_dma_chan *dwc)
>         if (dwc->initialized == true)
>                 return;
>
> -       if (dws) {
> +       if (dws && dws->cfg_hi == 0xffffffff && dws->cfg_lo == 0xffffffff) {
> +               /* autoconfigure based on request line from DT */
> +               if (dwc->dma_sconfig.direction == DMA_MEM_TO_DEV)
> +                       cfghi = DWC_CFGH_DST_PER(dwc->req);
> +               else if (dwc->dma_sconfig.direction == DMA_DEV_TO_MEM)
> +                       cfghi = DWC_CFGH_SRC_PER(dwc->req);

Please, use dwc->direction instead of field in the slave_config. If I
remember correctly it's marked like obsoleted/deprecated.

> @@ -1179,49 +1186,61 @@ static void dwc_free_chan_resources(struct dma_chan *chan)
>         dev_vdbg(chan2dev(chan), "%s: done\n", __func__);
>  }
>
> -bool dw_dma_generic_filter(struct dma_chan *chan, void *param)
> +struct dw_dma_filter_args {
> +       struct dw_dma *dw;
> +       u32 req;

Why this is u32 and not unsigned int?

> +       u32 src;
> +       u32 dst;

And this could be also just unsigned int.

> +static bool dw_dma_generic_filter(struct dma_chan *chan, void *param)
>  {

> +       dws->cfg_hi     = 0xffffffff;
> +       dws->cfg_lo     = 0xffffffff;

Agree with Russell about ~0.

> +static struct dma_chan *dw_dma_xlate(struct of_phandle_args *dma_spec,
> +                                        struct of_dma *ofdma)
> +{
> +       struct dw_dma *dw = ofdma->of_dma_data;
> +       struct dw_dma_filter_args fargs = {
> +               .dw = dw,
> +       };
> +       dma_cap_mask_t cap;
> +
> +       if (dma_spec->args_count != 3)
> +               return NULL;
> +
> +       fargs.req = be32_to_cpup(dma_spec->args+0);
> +       fargs.src = be32_to_cpup(dma_spec->args+1);
> +       fargs.dst = be32_to_cpup(dma_spec->args+2);

You could cast them to usual C types like unsigned int. I see u32 in
rare cases in the driver like for reading/writting from/to hw and when
API contains it. Here I doubt we have to leave them as u32.

> +
> +       if (WARN_ON(fargs.req >= 16 || fargs.src >= 2 || fargs.dst >= 2))
> +               return NULL;

16 here is a magic number for me. I would like to see something like
#define DW_MAX_REQUEST_LINES 16 in the dw_dmac_regs.h.

Besides of that, what 2 does come from?

> @@ -1765,6 +1751,10 @@ static int dw_probe(struct platform_device *pdev)
>
>         dma_async_device_register(&dw->dma);
>
> +       err = of_dma_controller_register(pdev->dev.of_node, dw_dma_xlate, dw);
> +       if (err)
> +               dev_err(&pdev->dev, "could not register of_dma_controller\n");

It's not an error, dev_dbg. Consider case when !CONFIG_OF.

> --- a/drivers/dma/dw_dmac_regs.h
> +++ b/drivers/dma/dw_dmac_regs.h
> @@ -213,6 +213,10 @@ struct dw_dma_chan {
>         /* configuration passed via DMA_SLAVE_CONFIG */
>         struct dma_slave_config dma_sconfig;
>
> +       /* slave configuration from DT */
> +       unsigned int            req;

Could you use here full name like "request_line"? And I think the
better place for it in subsection "hardware configuration" (consider
non-DT cases of use).

>         /* backlink to dw_dma */
>         struct dw_dma           *dw;
>  };

We should not have this in linux-next. Are you sure you rebased it on
top of recent one?

-- 
With Best Regards,
Andy Shevchenko
