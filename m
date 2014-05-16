Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbaEPXSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 19:18:52 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:39361 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856AbaEPXSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 19:18:50 -0400
Date: Sat, 17 May 2014 01:18:55 +0200
From: Emil Goode <emilgoode@gmail.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Shawn Guo <shawn.guo@freescale.com>, Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] ARM: imx: fix error handling
Message-ID: <20140516231855.GB4323@lianli>
References: <1400234045-6022-1-git-send-email-emilgoode@gmail.com>
 <20140516192451.GP16662@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140516192451.GP16662@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Uwe,

Thank you for the review.

On Fri, May 16, 2014 at 09:24:51PM +0200, Uwe Kleine-König wrote:
> Hello Emil,
> 
> IMHO the subject is too general. Maybe better use:
> 
> 	ARM: imx: fix error handling in ipu device registration

Agreed, will change this and resend.

> 
> On Fri, May 16, 2014 at 11:54:05AM +0200, Emil Goode wrote:
> > If we fail to allocate struct platform_device pdev we
> > dereference it after the goto label err.
> > 
> > I have rearranged the error handling a bit to fix the issue
> > and also make it more clear.
> > 
> > Signed-off-by: Emil Goode <emilgoode@gmail.com>
> > ---
> > v2: Changed to return -ENOMEM instead of ret where possible and
> >     updated the subject line.
> > 
> >  arch/arm/mach-imx/devices/platform-ipu-core.c |   22 +++++++++++++---------
> >  1 file changed, 13 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/arm/mach-imx/devices/platform-ipu-core.c b/arch/arm/mach-imx/devices/platform-ipu-core.c
> > index fc4dd7c..68f2a4a 100644
> > --- a/arch/arm/mach-imx/devices/platform-ipu-core.c
> > +++ b/arch/arm/mach-imx/devices/platform-ipu-core.c
> > @@ -77,34 +77,38 @@ struct platform_device *__init imx_alloc_mx3_camera(
> >  
> >  	pdev = platform_device_alloc("mx3-camera", 0);
> >  	if (!pdev)
> > -		goto err;
> > +		return ERR_PTR(-ENOMEM);
> >  
> >  	pdev->dev.dma_mask = kmalloc(sizeof(*pdev->dev.dma_mask), GFP_KERNEL);
> >  	if (!pdev->dev.dma_mask)
> > -		goto err;
> > +		goto put_pdev;
> >  
> >  	*pdev->dev.dma_mask = DMA_BIT_MASK(32);
> >  	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
> >  
> >  	ret = platform_device_add_resources(pdev, res, ARRAY_SIZE(res));
> >  	if (ret)
> > -		goto err;
> > +		goto free_dma_mask;
> >  
> >  	if (pdata) {
> >  		struct mx3_camera_pdata *copied_pdata;
> >  
> >  		ret = platform_device_add_data(pdev, pdata, sizeof(*pdata));
> > -		if (ret) {
> > -err:
> > -			kfree(pdev->dev.dma_mask);
> > -			platform_device_put(pdev);
> > -			return ERR_PTR(-ENODEV);
> > -		}
> > +		if (ret)
> > +			goto free_dma_mask;
> > +
> >  		copied_pdata = dev_get_platdata(&pdev->dev);
> >  		copied_pdata->dma_dev = &imx_ipu_coredev->dev;
> >  	}
> >  
> >  	return pdev;
> > +
> > +free_dma_mask:
> > +	kfree(pdev->dev.dma_mask);
> > +put_pdev:
> > +	platform_device_put(pdev);
> > +
> > +	return ERR_PTR(ret);
> >  }
> I didn't check if it is easily possible, but converting this file to use
> platform_device_register_full might simplify it considerably.

Will look into this and consider sending another patch.

> 
> I'm not sure this fix is critical, because the problem happens if an
> allocation during boot fails. But still, if you want to get this fix
> into a stable release, you should simplify it, i.e. don't do the code
> reorganisations. (Also the "more clear" part seems to be subjective, I
> like the error handling better as it is now. But that might only be me.)

To my knowlege there is no impact on end users and I don't think the bug
is critical since, as you say, the allocation happens during boot.
Probably it's not necessary to have this fixed in stable kernels.

> 
> Are you using this code? I thought arch/arm/mach-imx/devices to be dead
> as it is unused on dt platforms.

The bug was found using coccinelle. I'm not using the code and I don't know
what the plans are for this file in the transition to device tree. But as long
as the file is in the kernel I think it's worth fixing the bug.

Best regards,

Emil Goode

> 
> Best regards
> Uwe
> 
> -- 
> Pengutronix e.K.                           | Uwe Kleine-König            |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
