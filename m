Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbaETIfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 04:35:38 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:63825 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaETIff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 04:35:35 -0400
Date: Tue, 20 May 2014 01:35:31 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Fabio Estevam <festevam@gmail.com>, David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        kernel-janitors@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 1/2] mtd: delete unneeded call to platform_get_drvdata
Message-ID: <20140520083531.GH2413@norris-Latitude-E6410>
References: <1400308369-24375-1-git-send-email-Julia.Lawall@lip6.fr>
 <CAOMZO5AymcCnC6Awt2LiGP9yz=baRA0HLoLRUSBgNeg3b5=9xQ@mail.gmail.com>
 <alpine.DEB.2.10.1405171511140.2587@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405171511140.2587@hadrien>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Mike

On Sat, May 17, 2014 at 03:12:02PM +0800, Julia Lawall wrote:
> On Sat, 17 May 2014, Fabio Estevam wrote:
> > On Sat, May 17, 2014 at 3:32 AM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> > > From: Julia Lawall <Julia.Lawall@lip6.fr>
> > >
> > > Platform_get_drvdata is an accessor function, and has no purpose if its
> > > result is not used.
> > >
> > > The semantic patch that fixes this problem is as follows:
> > > (http://coccinelle.lip6.fr/)
> > >
> > > // <smpl>
> > > @@
> > > identifier x;
> > > type T;
> > > @@
> > > - T x = platform_get_drvdata(...);
> > > ... when != x
> > > // </smpl>
> > >
> > > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> > >
> > > ---
> > >  drivers/mtd/nand/bf5xx_nand.c |    4 ----
> > >  1 file changed, 4 deletions(-)
> > >
> > > diff --git a/drivers/mtd/nand/bf5xx_nand.c b/drivers/mtd/nand/bf5xx_nand.c
> > > index b7a2494..b5fbd48 100644
> > > --- a/drivers/mtd/nand/bf5xx_nand.c
> > > +++ b/drivers/mtd/nand/bf5xx_nand.c
> > > @@ -840,15 +840,11 @@ out_err_kzalloc:
> > >
> > >  static int bf5xx_nand_suspend(struct platform_device *dev, pm_message_t pm)
> > >  {
> > > -       struct bf5xx_nand_info *info = platform_get_drvdata(dev);
> > > -
> > >         return 0;
> > >  }
> > >
> > >  static int bf5xx_nand_resume(struct platform_device *dev)
> > >  {
> > > -       struct bf5xx_nand_info *info = platform_get_drvdata(dev);
> > > -
> > >         return 0;
> >
> > In this case bf5xx_nand_suspend/resume could be removed?
> 
> I don't know.  It looks like it is intentional to have a definition that
> returns an indication of success?  The complete set of definitions is:

I'm not so sure. I believe suspend/resume works just fine without the
hooks, if those hooks would otherwise be doing nothing. It is notable
that this driver is not using the modern dev_pm_ops form of the
suspend/resume callbacks, so maybe it just hasn't aged gracefully--and
possibly was never supported properly in the first place.

I'll either take this patch as-is, or look to killing off the
suspend/resume callbacks entirely here, depending on Mike's feedback.

> #ifdef CONFIG_PM
> 
> static int bf5xx_nand_suspend(struct platform_device *dev, pm_message_t
> pm)
> {
>         struct bf5xx_nand_info *info = platform_get_drvdata(dev);
> 
> 	return 0;
> }
> 
> static int bf5xx_nand_resume(struct platform_device *dev)
> {
>         struct bf5xx_nand_info *info = platform_get_drvdata(dev);
> 
>         return 0;
> }
> 
> #else
> #define bf5xx_nand_suspend NULL
> #define bf5xx_nand_resume NULL
> #endif

Thanks,
Brian
