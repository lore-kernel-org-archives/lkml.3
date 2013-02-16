Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab3BPOA6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 09:00:58 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:64476 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab3BPOA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 09:00:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH 2/4] dmaengine: dw_dmac: move to generic DMA binding
Date: Sat, 16 Feb 2013 14:00:28 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@linux.intel.com>
References: <1360952512-971558-1-git-send-email-arnd@arndb.de> <1360952512-971558-3-git-send-email-arnd@arndb.de> <CAHp75VfyO5wep-shvZ_mkwLmL2_Fa2jgq63AvE2t8=TPLZn6yg@mail.gmail.com>
In-Reply-To: <CAHp75VfyO5wep-shvZ_mkwLmL2_Fa2jgq63AvE2t8=TPLZn6yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302161400.29064.arnd@arndb.de>
X-Provags-ID: V02:K0:iLiislTTUFY+FslKJ61Oly8ozfdWc2MwuZXGs/Alvmq
 cazUCuUcwfv/8F9ozpA7fuevudmnEorFwpgNXRg+pJuuj5OEAZ
 iYnUCE17tQLPh0jSFTkkKD4+nZMTzE0JWmLPu1p1tdVOUq/u9z
 f44gxw+riVFwRz2TzqIFrZLH9Pcf+Mc/pxSSwaE0WAsMsN1Ea6
 nrKAKs6ctzjb1ZOI9769gOx0aLbx8Vhy5hQ+WXW0RipTCDpBdw
 IllEJqDErLrBUCECAFkmlITl4lKER+H4pr+xKXonoQVlWrPbmN
 1x3wMhRkTN7IvLNAdPFLr/hQO6JCvLYR21Hb//iWOdkQQpdPei
 /GnscLgbSt4w0fBDq3i0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 February 2013, Andy Shevchenko wrote:
> On Fri, Feb 15, 2013 at 8:21 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> > @@ -168,7 +169,13 @@ static void dwc_initialize(struct dw_dma_chan *dwc)
> >         if (dwc->initialized == true)
> >                 return;
> >
> > -       if (dws) {
> > +       if (dws && dws->cfg_hi == 0xffffffff && dws->cfg_lo == 0xffffffff) {
> > +               /* autoconfigure based on request line from DT */
> > +               if (dwc->dma_sconfig.direction == DMA_MEM_TO_DEV)
> > +                       cfghi = DWC_CFGH_DST_PER(dwc->req);
> > +               else if (dwc->dma_sconfig.direction == DMA_DEV_TO_MEM)
> > +                       cfghi = DWC_CFGH_SRC_PER(dwc->req);
> 
> Please, use dwc->direction instead of field in the slave_config. If I
> remember correctly it's marked like obsoleted/deprecated.

Ok, that's easy to change. I was copying from the code you added
a few lines below, but was using an older version than the one where
you had made the change to use dwc->direction.

> > @@ -1179,49 +1186,61 @@ static void dwc_free_chan_resources(struct dma_chan *chan)
> >         dev_vdbg(chan2dev(chan), "%s: done\n", __func__);
> >  }
> >
> > -bool dw_dma_generic_filter(struct dma_chan *chan, void *param)
> > +struct dw_dma_filter_args {
> > +       struct dw_dma *dw;
> > +       u32 req;
> 
> Why this is u32 and not unsigned int?
> 
> > +       u32 src;
> > +       u32 dst;
> 
> And this could be also just unsigned int.

I was using u32 since I copied the values from a 32 bit
DT property value. I'll change it to unsigned int.

> > +static bool dw_dma_generic_filter(struct dma_chan *chan, void *param)
> >  {
> 
> > +       dws->cfg_hi     = 0xffffffff;
> > +       dws->cfg_lo     = 0xffffffff;
> 
> Agree with Russell about ~0.

ok.

> > +static struct dma_chan *dw_dma_xlate(struct of_phandle_args *dma_spec,
> > +                                        struct of_dma *ofdma)
> > +{
> > +       struct dw_dma *dw = ofdma->of_dma_data;
> > +       struct dw_dma_filter_args fargs = {
> > +               .dw = dw,
> > +       };
> > +       dma_cap_mask_t cap;
> > +
> > +       if (dma_spec->args_count != 3)
> > +               return NULL;
> > +
> > +       fargs.req = be32_to_cpup(dma_spec->args+0);
> > +       fargs.src = be32_to_cpup(dma_spec->args+1);
> > +       fargs.dst = be32_to_cpup(dma_spec->args+2);
> 
> You could cast them to usual C types like unsigned int. I see u32 in
> rare cases in the driver like for reading/writting from/to hw and when
> API contains it. Here I doubt we have to leave them as u32.

Right. 

> > +       if (WARN_ON(fargs.req >= 16 || fargs.src >= 2 || fargs.dst >= 2))
> > +               return NULL;
> 
> 16 here is a magic number for me. I would like to see something like
> #define DW_MAX_REQUEST_LINES 16 in the dw_dmac_regs.h.

Ok.

> Besides of that, what 2 does come from?

I thought that Viresh had commented that there could only be two masters.
It's probably best to compare against dw->nr_masters here.

> > @@ -1765,6 +1751,10 @@ static int dw_probe(struct platform_device *pdev)
> >
> >         dma_async_device_register(&dw->dma);
> >
> > +       err = of_dma_controller_register(pdev->dev.of_node, dw_dma_xlate, dw);
> > +       if (err)
> > +               dev_err(&pdev->dev, "could not register of_dma_controller\n");
> 
> It's not an error, dev_dbg. Consider case when !CONFIG_OF.

Ah right. I expected of_dma_controller_register to return 0 in that case, but
it returns -ENODEV. How about I change this to this?

	if (pdev->dev.of_node)
		err = of_dma_controller_register(pdev->dev.of_node, dw_dma_xlate, dw);
	if (err && err != -ENODEV)
		dev_err(&pdev->dev, "could not register of_dma_controller\n");

That would warn only when we have a dw_dmac device that was registered from
device tree but does not follow the binding or gets an -ENOMEM.

> > --- a/drivers/dma/dw_dmac_regs.h
> > +++ b/drivers/dma/dw_dmac_regs.h
> > @@ -213,6 +213,10 @@ struct dw_dma_chan {
> >         /* configuration passed via DMA_SLAVE_CONFIG */
> >         struct dma_slave_config dma_sconfig;
> >
> > +       /* slave configuration from DT */
> > +       unsigned int            req;
> 
> Could you use here full name like "request_line"? And I think the
> better place for it in subsection "hardware configuration" (consider
> non-DT cases of use).

Ok

> 
> >         /* backlink to dw_dma */
> >         struct dw_dma           *dw;
> >  };
> 
> We should not have this in linux-next. Are you sure you rebased it on
> top of recent one?

I was basing on the earliest commit that had Viresh's changes in it.
I'll rebase on top of Vinod's branch now.

Thanks for your review!

	Arnd
