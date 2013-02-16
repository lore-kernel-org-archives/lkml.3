Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab3BPX2j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 18:28:39 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63767 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739Ab3BPX2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 18:28:38 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCHv3 2/4] dmaengine: dw_dmac: move to generic DMA binding
Date: Sat, 16 Feb 2013 23:28:34 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@linux.intel.com>
References: <1360952512-971558-1-git-send-email-arnd@arndb.de> <201302162221.32799.arnd@arndb.de> <CAHp75VeCic+5_zyzFdtpw5dLxRaajD9zv6ZvSoDcHAD1EF=GSw@mail.gmail.com>
In-Reply-To: <CAHp75VeCic+5_zyzFdtpw5dLxRaajD9zv6ZvSoDcHAD1EF=GSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302162328.35068.arnd@arndb.de>
X-Provags-ID: V02:K0:qCU5/ldBo/nJS9Ocr5oi2rD/z7AAh95q5iLSdfdai8Y
 vQVd4fHnIESTbBGGWpSwMRZa5j+w5Xjf29/3xFL4XbxyMeSncn
 Zwa66t5ZIIO2C5gujf46JCbJKsjb1/ryPlM4bUXoZMHSwQGqs9
 p6NXTyn08pHubrXny3Rq5044Kdy7RRMUKzX+5KjxZ3TgXq2n8c
 nql7OU6IsZhyts+WPPRUSqvERbZg0vlkvuQMSJNLwD8EKZiupL
 z1x3jexrrIH2vSBT0g20TyoeFiq2s9iGpBN9KHFI4h1RMBBrJH
 5MYdKRHA3p77md/Z6dmLcw9UQHBUpJ3UGJvjuEc7U9wDAUR5Ld
 oJwjsMWks+vRQyb9phmA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 February 2013, Andy Shevchenko wrote:

> > @@ -1836,6 +1825,12 @@ static int dw_probe(struct platform_device *pdev)
> >
> >         dma_async_device_register(&dw->dma);
> >
> > +       if (pdev->dev.of_node)
> > +               err = of_dma_controller_register(pdev->dev.of_node,
> > +                                                dw_dma_xlate, dw);
> > +       if (err && err != -ENODEV)
> > +               dev_err(&pdev->dev, "could not register of_dma_controller\n");
> 
> I believe we may make it as
>  if (...of_node) {
>   err = ...register();
>   if (err...)
>     dev_err();
>  }

I thing the two are equivalent because we only get to the first if()
when err is 0. However, I agree that your version is a bit clearer,
so I'll change it.

> > --- a/drivers/dma/dw_dmac_regs.h
> > +++ b/drivers/dma/dw_dmac_regs.h
> 
> > @@ -211,9 +212,15 @@ struct dw_dma_chan {
> >         /* hardware configuration */
> >         unsigned int            block_size;
> >         bool                    nollp;
> > +       unsigned int            request_line;
> > +       struct dw_dma_slave     slave;
> > +
> 
> Do we really need an extra empty line here?

No, that was an accident.

> >         /* configuration passed via DMA_SLAVE_CONFIG */
> >         struct dma_slave_config dma_sconfig;
> > +
> > +       /* backlink to dw_dma */
> > +       struct dw_dma           *dw;
> 
> Seems it's not needed and came from rebase?

Probably. It certainly was not intentional.

	Arnd
