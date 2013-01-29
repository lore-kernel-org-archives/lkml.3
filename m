Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab3A2NUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 08:20:23 -0500
Received: from mail.kernel.org ([198.145.19.201]:44642 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258Ab3A2NUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 08:20:20 -0500
Date: Tue, 29 Jan 2013 05:21:15 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH 07/33] dma: Convert to devm_ioremap_resource()
Message-ID: <20130129132115.GA1474@kroah.com>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
 <1358762966-20791-8-git-send-email-thierry.reding@avionic-design.de>
 <CAHp75VdeBrMg-ccxwY-45H_-_KatdwL7FnjB8SXWWgF1C+9Y1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VdeBrMg-ccxwY-45H_-_KatdwL7FnjB8SXWWgF1C+9Y1Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 03:11:05PM +0200, Andy Shevchenko wrote:
> On Mon, Jan 21, 2013 at 12:09 PM, Thierry Reding
> <thierry.reding@avionic-design.de> wrote:
> > Convert all uses of devm_request_and_ioremap() to the newly introduced
> > devm_ioremap_resource() which provides more consistent error handling.
> >
> > devm_ioremap_resource() provides its own error messages so all explicit
> > error messages can be removed from the failure code paths.
> >
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > Cc: Vinod Koul <vinod.koul@intel.com>
> > ---
> >  drivers/dma/dw_dmac.c         |  7 ++++---
> >  drivers/dma/imx-dma.c         |  7 ++++---
> >  drivers/dma/mmp_pdma.c        |  7 ++++---
> >  drivers/dma/mmp_tdma.c        |  7 ++++---
> >  drivers/dma/tegra20-apb-dma.c | 10 ++++------
> >  5 files changed, 20 insertions(+), 18 deletions(-)
> >
> > diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> > index 3e8ba02..b33d1f6 100644
> > --- a/drivers/dma/dw_dmac.c
> > +++ b/drivers/dma/dw_dmac.c
> > @@ -14,6 +14,7 @@
> >  #include <linux/delay.h>
> >  #include <linux/dmaengine.h>
> >  #include <linux/dma-mapping.h>
> > +#include <linux/err.h>
> >  #include <linux/init.h>
> >  #include <linux/interrupt.h>
> >  #include <linux/io.h>
> > @@ -1489,9 +1490,9 @@ static int dw_probe(struct platform_device *pdev)
> >         if (irq < 0)
> >                 return irq;
> >
> > -       regs = devm_request_and_ioremap(&pdev->dev, io);
> > -       if (!regs)
> > -               return -EBUSY;
> > +       regs = devm_ioremap_resource(&pdev->dev, io);
> > +       if (IS_ERR(regs))
> > +               return PTR_ERR(regs);
> 
> Do you concern that change makes sparse crazy?
> 
> drivers/dma/dw_dmac.c:1690:20: warning: incorrect type in argument 1
> (different address spaces)
> drivers/dma/dw_dmac.c:1690:20:    expected void const *ptr
> drivers/dma/dw_dmac.c:1690:20:    got void [noderef] <asn:2>*[assigned] regs
> drivers/dma/dw_dmac.c:1691:32: warning: incorrect type in argument 1
> (different address spaces)
> drivers/dma/dw_dmac.c:1691:32:    expected void const *ptr
> drivers/dma/dw_dmac.c:1691:32:    got void [noderef] <asn:2>*[assigned] regs

Yeah, Thierry has been emailing me about this and it's a false-positive
that I don't know how we are going to make sparse handle properly.

greg k-h
