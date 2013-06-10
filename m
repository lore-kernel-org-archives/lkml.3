Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab3FJKf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 06:35:59 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:33227 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab3FJKf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 06:35:56 -0400
Date: Mon, 10 Jun 2013 12:35:37 +0200
From: Emil Goode <emilgoode@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Andrew Lunn <andrew@lunn.ch>, Bill Pemberton <wfp5p@virginia.edu>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        "'Dan Carpenter'" <dan.carpenter@oracle.com>,
        "'Andy Shevchenko'" <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v2] mtd: orion_nand: Improve error handling in
 orion_nand_probe
Message-ID: <20130610103537.GA20987@debian>
References: <1370822442-25217-1-git-send-email-emilgoode@gmail.com>
 <001e01ce659c$3e582270$bb086750$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001e01ce659c$3e582270$bb086750$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jingoo,

Thank you for the review. There was another discussion and the following
patch was sent that converts printk to dev_err.

http://lists.infradead.org/pipermail/linux-mtd/2013-June/047198.html

My conclusion of the discussion was that error messages for kzalloc
calls are probably made out of habit and that it's better to rely on
the internal error messages of kzalloc.

http://lists.infradead.org/pipermail/linux-mtd/2013-June/047203.html

So instead of sending a second version that applies on top of the
"convert printk to dev_*" patch, I decided to remove the error
messages for the kzalloc calls.

About the introduced call to devm_request_mem_region that is made
inside of devm_ioremap_resource. My understanding is that
request_mem_region should be used for all memory mappen I/O to
inform the kernel of the I/O adress range that will be used by
the driver.

There are other examples in drivers/mtd/nand of devm_ioremap_resource
beeing used in probe functions.

Here are some of them:
drivers/mtd/nand/lpc32xx_slc.c
drivers/mtd/nand/fsmc_nand.c
drivers/mtd/nand/davinci_nand.c

Best regards,

Emil

On Mon, Jun 10, 2013 at 02:34:57PM +0900, Jingoo Han wrote:
> Monday, June 10, 2013 9:01 AM, Emil Goode wrote:
> > 
> > This patch fixes some issues in the error handling and simplifies
> > the code by converting to devm* functions.
> > 
> > If the kzalloc call fails it is unnecessary to use the label no_res
> > and pass a NULL pointer to kfree. If the devm_kzalloc call fails on
> > line 110 we forget to call iounmap for the previous ioremap call.
> > 
> > The following changes are introduced:
> > - Convert to devm_kzalloc and remove calls to kfree.
> > - Convert to devm_ioremap_resource that adds a missing call to
> >   *request_mem_region and remove calls to iounmap.
> > - The devm_ioremap_resource function checks the passed resource so
> >   we can remove the NULL check after the platform_get_resource call.
> > 
> > Signed-off-by: Emil Goode <emilgoode@gmail.com>
> > ---
> > This patch is only build tested
> > v2: Fix change log typo and remove error messages for kzalloc calls
> > 
> >  drivers/mtd/nand/orion_nand.c |   49 +++++++++++++----------------------------
> >  1 file changed, 15 insertions(+), 34 deletions(-)
> > 
> > diff --git a/drivers/mtd/nand/orion_nand.c b/drivers/mtd/nand/orion_nand.c
> > index 8fbd002..76b9fba 100644
> > --- a/drivers/mtd/nand/orion_nand.c
> > +++ b/drivers/mtd/nand/orion_nand.c
> > @@ -85,35 +85,24 @@ static int __init orion_nand_probe(struct platform_device *pdev)
> >  	int ret = 0;
> >  	u32 val = 0;
> > 
> > -	nc = kzalloc(sizeof(struct nand_chip) + sizeof(struct mtd_info), GFP_KERNEL);
> > -	if (!nc) {
> > -		printk(KERN_ERR "orion_nand: failed to allocate device structure.\n");
> 
> CC'ed Dan Carpenter, Andy Shevchenko
> 
> You don't need to remove this error message.
> You would replace 'printk(KERN_ERR "orion_nand:...)' with
> 'dev_err(&pdev->dev,)'.
> 
> 	dev_err("failed to allocate device structure.\n");
> 
> 
> > -		ret = -ENOMEM;
> > -		goto no_res;
> > -	}
> > +	nc = devm_kzalloc(&pdev->dev, sizeof(struct nand_chip) +
> > +			  sizeof(struct mtd_info), GFP_KERNEL);
> > +	if (!nc)
> > +		return -ENOMEM;
> > +
> >  	mtd = (struct mtd_info *)(nc + 1);
> > 
> >  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > -	if (!res) {
> > -		ret = -ENODEV;
> > -		goto no_res;
> > -	}
> > -
> > -	io_base = ioremap(res->start, resource_size(res));
> > -	if (!io_base) {
> > -		printk(KERN_ERR "orion_nand: ioremap failed\n");
> 
> Yes, this error message is not necessary.
> devm_ioremap_resource() provides its own error messages; so all
> explicit error messages can be removed from the failure code paths.
> 
> 
> > -		ret = -EIO;
> > -		goto no_res;
> > -	}
> > +	io_base = devm_ioremap_resource(&pdev->dev, res);
> 
> How about using devm_ioremap() instead of devm_ioremap_resource()?
> 
> Only ioremap() was used previously; however, devm_ioremap_resource()
> internally calls both devm_request_mem_region() and devm_ioremap().
> 
> If it is wrong, please let me know kindly. :)
> 
> 
> > +	if (IS_ERR(io_base))
> > +		return PTR_ERR(io_base);
> > 
> >  	if (pdev->dev.of_node) {
> >  		board = devm_kzalloc(&pdev->dev, sizeof(struct orion_nand_data),
> > -					GFP_KERNEL);
> > -		if (!board) {
> > -			printk(KERN_ERR "orion_nand: failed to allocate board structure.\n");
> 
> As above mentioned, you don't need to remove this error message.
> You would replace 'printk(KERN_ERR "orion_nand:...)' with
> 'dev_err(&pdev->dev,)'.
> 
> 	dev_err("failed to allocate board structure.\n");
> 
> 
> Best regards,
> Jingoo Han
> 
> 
> > -			ret = -ENOMEM;
> > -			goto no_res;
> > -		}
> > +				     GFP_KERNEL);
> > +		if (!board)
> > +			return -ENOMEM;
> > +
> >  		if (!of_property_read_u32(pdev->dev.of_node, "cle", &val))
> >  			board->cle = (u8)val;
> >  		else
> > @@ -167,7 +156,7 @@ static int __init orion_nand_probe(struct platform_device *pdev)
> > 
> >  	if (nand_scan(mtd, 1)) {
> >  		ret = -ENXIO;
> > -		goto no_dev;
> > +		goto disable_clk;
> >  	}
> > 
> >  	mtd->name = "orion_nand";
> > @@ -176,20 +165,17 @@ static int __init orion_nand_probe(struct platform_device *pdev)
> >  			board->parts, board->nr_parts);
> >  	if (ret) {
> >  		nand_release(mtd);
> > -		goto no_dev;
> > +		goto disable_clk;
> >  	}
> > 
> >  	return 0;
> > 
> > -no_dev:
> > +disable_clk:
> >  	if (!IS_ERR(clk)) {
> >  		clk_disable_unprepare(clk);
> >  		clk_put(clk);
> >  	}
> >  	platform_set_drvdata(pdev, NULL);
> > -	iounmap(io_base);
> > -no_res:
> > -	kfree(nc);
> > 
> >  	return ret;
> >  }
> > @@ -197,15 +183,10 @@ no_res:
> >  static int orion_nand_remove(struct platform_device *pdev)
> >  {
> >  	struct mtd_info *mtd = platform_get_drvdata(pdev);
> > -	struct nand_chip *nc = mtd->priv;
> >  	struct clk *clk;
> > 
> >  	nand_release(mtd);
> > 
> > -	iounmap(nc->IO_ADDR_W);
> > -
> > -	kfree(nc);
> > -
> >  	clk = clk_get(&pdev->dev, NULL);
> >  	if (!IS_ERR(clk)) {
> >  		clk_disable_unprepare(clk);
> > --
> > 1.7.10.4
> 
