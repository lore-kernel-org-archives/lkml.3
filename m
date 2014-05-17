Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbaEQWvr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 18:51:47 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:58940 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaEQWvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 18:51:46 -0400
Date: Sun, 18 May 2014 00:51:53 +0200
From: Emil Goode <emilgoode@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v3] ARM: imx: fix error handling in ipu device
 registration
Message-ID: <20140517225153.GB20413@lianli>
References: <1400352033-18262-1-git-send-email-emilgoode@gmail.com>
 <20140517191821.GD16662@pengutronix.de>
 <20140517220836.GI15585@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140517220836.GI15585@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dan,

On Sun, May 18, 2014 at 01:08:36AM +0300, Dan Carpenter wrote:
> On Sat, May 17, 2014 at 09:18:21PM +0200, Uwe Kleine-König wrote:
> > diff --git a/arch/arm/mach-imx/devices/platform-ipu-core.c b/arch/arm/mach-imx/devices/platform-ipu-core.c
> > index fc4dd7cedc11..6bd7c3f37ac0 100644
> > --- a/arch/arm/mach-imx/devices/platform-ipu-core.c
> > +++ b/arch/arm/mach-imx/devices/platform-ipu-core.c
> > @@ -77,7 +77,7 @@ struct platform_device *__init imx_alloc_mx3_camera(
> >  
> >  	pdev = platform_device_alloc("mx3-camera", 0);
> >  	if (!pdev)
> > -		goto err;
> > +		return ERR_PTR(-ENOMEM);
> >  
> >  	pdev->dev.dma_mask = kmalloc(sizeof(*pdev->dev.dma_mask), GFP_KERNEL);
> >  	if (!pdev->dev.dma_mask)
> 
> Emil, do this one, please and not the second suggestion.

Yes, I would pick this one to.

> 
> Direct returns are more readable.  Otherwise, you wonder what the goto
> is for and where it will take you and be annoyed to discover it is a
> waste of time, no-op goto.  Also you will wonder if platform_device_put()
> accepts NULL pointers.  Thirdly there is a small ugliness that the error
> code is not preserved.  What is the point of setting the error code to
> -ENOMEM only to discard it?
> 
> Let's look at that error handling again.
> 
> err:  <-- the name is not descriptive.  the location is bad.
> 		kfree(pdev->dev.dma_mask);  <- null dereference.
> 		platform_device_put(pdev);  <- ok
> 		return ERR_PTR(-ENODEV);    <- should be "return ERR_PTR(ret);"
> 
> 3 out of 4 of the lines are bad.

I agree that it's not very pretty.

Now that Uwe solved the issue regarding converting the function to
platform_device_register_full(), I will look into sending a second patch
that would remove these lines.

Thank you!

Best regards,

Emil Goode
