Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab3CZRMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:12:24 -0400
Received: from mga14.intel.com ([143.182.124.37]:29478 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab3CZRMX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:12:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,913,1355126400"; 
   d="scan'208";a="276224704"
Message-ID: <1364317922.6652.34.camel@smile>
Subject: Re: [PATCH v2.1] dw_dmac: make wrapper on
 of_dma_controller_register()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Date: Tue, 26 Mar 2013 19:12:02 +0200
In-Reply-To: <CAKohpoksxVo3fFdaqOBucOzJs_aU3XGiTcM3b6GzW=m=ooFzQQ@mail.gmail.com>
References: <5151B91B.7060404@metafoo.de>
	 <1364317484-30005-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAKohpoksxVo3fFdaqOBucOzJs_aU3XGiTcM3b6GzW=m=ooFzQQ@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-26 at 22:37 +0530, Viresh Kumar wrote: 
> On 26 March 2013 22:34, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > This patch introduces new method dw_dma_of_controller_register(). The wrapper
> > is called only when of_node is present.
> >
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  drivers/dma/dw_dmac.c | 19 ++++++++++++-------
> >  1 file changed, 12 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> > index 274fd7d..12657d7 100644
> > --- a/drivers/dma/dw_dmac.c
> > +++ b/drivers/dma/dw_dmac.c
> > @@ -1303,6 +1303,16 @@ static struct dma_chan *dw_dma_of_xlate(struct of_phandle_args *dma_spec,
> >         return dma_request_channel(cap, dw_dma_of_filter, &fargs);
> >  }
> >
> > +static void dw_dma_of_controller_register(struct dw_dma *dw)
> > +{
> > +       struct device *dev = dw->dma.dev;
> > +       int err;
> > +
> > +       err = of_dma_controller_register(dev->of_node, dw_dma_of_xlate, dw);
> > +       if (err)
> > +               dev_err(dev, "could not register of_dma_controller\n");
> > +}
> > +
> >  /* --------------------- Cyclic DMA API extensions -------------------- */
> >
> >  /**
> > @@ -1843,13 +1853,8 @@ static int dw_probe(struct platform_device *pdev)
> >
> >         dma_async_device_register(&dw->dma);
> >
> > -       if (pdev->dev.of_node) {
> > -               err = of_dma_controller_register(pdev->dev.of_node,
> > -                                                dw_dma_of_xlate, dw);
> > -               if (err && err != -ENODEV)
> > -                       dev_err(&pdev->dev,
> > -                               "could not register of_dma_controller\n");
> > -       }
> > +       if (pdev->dev.of_node)
> > +               dw_dma_of_controller_register(dw);
> 
> I forgot where we started from, but what's the need of this patch?

Nowadays, besides removal of the -ENODEV checking, it makes probe
function looks tidier.

Think about upcoming stuff (e.g. ACPI), if we put everything inside
probe it will look overloaded.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
