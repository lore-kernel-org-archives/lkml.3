Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab3K0DgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 22:36:03 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:64045 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab3K0Df7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 22:35:59 -0500
Date: Tue, 26 Nov 2013 19:35:55 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Wei Yongjun'" <weiyj.lk@gmail.com>,
        "'David Woodhouse'" <dwmw2@infradead.org>,
        "'Bill Pemberton'" <wfp5p@virginia.edu>,
        "'Artem Bityutskiy'" <artem.bityutskiy@linux.intel.com>,
        "'Wei Yongjun'" <yongjun_wei@trendmicro.com.cn>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: Alchemy: add missing platform_set_drvdata() in
 au1550nd_probe()
Message-ID: <20131127033555.GY9468@ld-irv-0074.broadcom.com>
References: <CAPgLHd-qf8Zj0gWgJh3_WMZOAx5-H6aABrVFqRsAw=XkOfDdmw@mail.gmail.com>
 <20131126235026.GN9468@ld-irv-0074.broadcom.com>
 <004e01ceeb05$9d579690$d806c3b0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <004e01ceeb05$9d579690$d806c3b0$%han@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

On Wed, Nov 27, 2013 at 09:14:18AM +0900, Jingoo Han wrote:
> On Wednesday, November 27, 2013 8:50 AM, Brian Norris wrote:
> > On Mon, Nov 11, 2013 at 02:18:29PM +0800, Wei Yongjun wrote:
> > > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > >
> > > Add missing platform_set_drvdata() in au1550nd_probe(), otherwise
> > > calling platform_get_drvdata() in remove returns NULL.
> > 
> > An alternative solution: just allocate ctx with devm_kzalloc().Then you
> > don't have to kfree() it at all.
> 
> Even if devm_kzalloc() is used, missing platform_set_drvdata() will
> be still necessary.
> 
> static int au1550nd_remove(struct platform_device *pdev)
> {
> 	struct au1550nd_ctx *ctx = platform_get_drvdata(pdev);
> 	.....
> 
> 	nand_release(&ctx->info);
> 
> 'ctx' is still used. Also, in order to use 'ctx',
> platform_get_drvdata(pdev) should be called.

Ah, I overlooked that. Thanks. In that case, you still have to do
something like this patch, and devm_kzalloc() can be left for another
day (or not done at all).

> > 
> > I don't mind one solution over the other too much. Let me know which
> > you'd prefer.
> > 
> > > Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > > ---
> > >  drivers/mtd/nand/au1550nd.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/drivers/mtd/nand/au1550nd.c b/drivers/mtd/nand/au1550nd.c
> > > index ae8dd7c..909b673 100644
> > > --- a/drivers/mtd/nand/au1550nd.c
> > > +++ b/drivers/mtd/nand/au1550nd.c
> > > @@ -480,6 +480,8 @@ static int au1550nd_probe(struct platform_device *pdev)
> > >
> > >  	mtd_device_register(&ctx->info, pd->parts, pd->num_parts);
> > >
> > > +	platform_set_drvdata(pdev, ctx);
> > > +
> > 
> > Personally, I'd choose to call platform_set_drvdata() earlier in the
> > probe routine (e.g., immediately after its allocation), in case we end
> > up calling platform_get_drvdata() from some sub-routine in the future.
> 
> Do you mean the following?
> But, most drivers calls platform_set_drvdata() later in the probe routine.

I wouldn't say "most." An unscientific survey seemed to show some
variation, with no clear pattern.

> static int au1550nd_probe(struct platform_device *pdev)
> {
>         struct au1550nd_platdata *pd;
>         struct au1550nd_ctx *ctx;
>         struct nand_chip *this;
>         struct resource *r;
>         int ret, cs;
> 
>         pd = dev_get_platdata(&pdev->dev);
>         if (!pd) {
>                 dev_err(&pdev->dev, "missing platform data\n");
>                 return -ENODEV;
>         }
> 
>         ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
>         if (!ctx) {
>                 dev_err(&pdev->dev, "no memory for NAND context\n");
>                 return -ENOMEM;
>         }
> 
> +	platform_set_drvdata(pdev, ctx);
> +

Yes, that looks better to me.

Brian
