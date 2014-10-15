Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbaJOVlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 17:41:23 -0400
Received: from top.free-electrons.com ([176.31.233.9]:34013 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751894AbaJOVlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 17:41:21 -0400
Date: Wed, 15 Oct 2014 18:39:53 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        dwmw2@infradead.org, computersforpeace@gmail.com, jg1.han@samsung.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: orion_nand: fix error code path in probe
Message-ID: <20141015213953.GB23155@arch.hh.imgtec.org>
References: <1413296198-29486-1-git-send-email-michael.opdenacker@free-electrons.com>
 <20141014213503.GD5331@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141014213503.GD5331@lunn.ch>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 Oct 11:35 PM, Andrew Lunn wrote:
> On Tue, Oct 14, 2014 at 04:16:38PM +0200, Michael Opdenacker wrote:
> > This replaces kzalloc() and ioremap() calls by
> > the corresponding devm_ functions in the probe() routine,
> > which automatically release the corresponding resources
> > when probe() fails or when the device is removed.
> > 
> > This simplifies the error management code and
> > fixes a bug reported by "make coccicheck":
> > 
> > if "board = devm_kzalloc()" fails, the probe()
> > function jumps incorrectly to label "no_res" and
> > therefore returns without running "iounmap()"
> > 
> > Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> > ---
> >  drivers/mtd/nand/orion_nand.c | 28 +++++++++-------------------
> >  1 file changed, 9 insertions(+), 19 deletions(-)
> > 
> > diff --git a/drivers/mtd/nand/orion_nand.c b/drivers/mtd/nand/orion_nand.c
> > index 471b4df3a5ac..a9c2bde16c25 100644
> > --- a/drivers/mtd/nand/orion_nand.c
> > +++ b/drivers/mtd/nand/orion_nand.c
> > @@ -19,7 +19,7 @@
> >  #include <linux/mtd/partitions.h>
> >  #include <linux/clk.h>
> >  #include <linux/err.h>
> > -#include <asm/io.h>
> > +#include <linux/io.h>
> >  #include <asm/sizes.h>
> >  #include <linux/platform_data/mtd-orion_nand.h>
> >  
> > @@ -85,32 +85,30 @@ static int __init orion_nand_probe(struct platform_device *pdev)
> >  	int ret = 0;
> >  	u32 val = 0;
> >  
> > -	nc = kzalloc(sizeof(struct nand_chip) + sizeof(struct mtd_info), GFP_KERNEL);
> > +	nc = devm_kzalloc(&pdev->dev,
> > +			sizeof(struct nand_chip) + sizeof(struct mtd_info),
> > +			GFP_KERNEL);
> >  	if (!nc) {
> > -		ret = -ENOMEM;
> > -		goto no_res;
> > +		return -ENOMEM;
> >  	}
> >  	mtd = (struct mtd_info *)(nc + 1);
> >  
> >  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >  	if (!res) {
> > -		ret = -ENODEV;
> > -		goto no_res;
> > +		return -ENODEV;
> >  	}
> >  
> > -	io_base = ioremap(res->start, resource_size(res));
> > +	io_base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
> >  	if (!io_base) {
> >  		dev_err(&pdev->dev, "ioremap failed\n");
> > -		ret = -EIO;
> > -		goto no_res;
> > +		return -EIO;
> >  	}
> 
> Hi Michael
> 
> It is quite a common pattern to use:
> 
>         res = platform_get_resource(dev, IORESOURCE_MEM, 0);
>         c->membase = devm_ioremap_resource(&dev->dev, res);
>         if (IS_ERR(c->membase))
> 	   return PTR_ERR(c->membase)
> 
> which is more compact.
> 

Be careful with this. devm_ioremap and devm_ioremap_resource are not
the same thing, as the former requests the region as well.

It can break things if the region is shared across several drivers.
I don't think this is the case, so in fact adding the request is correct,
but it's a more intrusive change than just "code cleanup".

-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
