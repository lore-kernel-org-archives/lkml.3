Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbaEQPft (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 11:35:49 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:56627 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757412AbaEQPfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 11:35:46 -0400
Date: Sat, 17 May 2014 17:35:40 +0200
From: Emil Goode <emilgoode@gmail.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: walter harms <wharms@bfs.de>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] ARM: imx: fix error handling
Message-ID: <20140517153540.GA4309@lianli>
References: <1400234045-6022-1-git-send-email-emilgoode@gmail.com>
 <5375EB13.8000200@bfs.de>
 <20140516111646.GC4366@lianli>
 <5375FB36.8020004@bfs.de>
 <20140516193139.GQ16662@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140516193139.GQ16662@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Uwe,

On Fri, May 16, 2014 at 09:31:39PM +0200, Uwe Kleine-König wrote:
> Hello Walter,
> 
> On Fri, May 16, 2014 at 01:49:10PM +0200, walter harms wrote:
> > Am 16.05.2014 13:16, schrieb Emil Goode:
> > > Hello Walter,
> > > 
> > > On Fri, May 16, 2014 at 12:40:19PM +0200, walter harms wrote:
> > >>
> > >>
> > >> Am 16.05.2014 11:54, schrieb Emil Goode:
> > >>> If we fail to allocate struct platform_device pdev we
> > >>> dereference it after the goto label err.
> > >>>
> > >>> I have rearranged the error handling a bit to fix the issue
> > >>> and also make it more clear.
> > >>>
> > >>> Signed-off-by: Emil Goode <emilgoode@gmail.com>
> > >>> ---
> > >>> v2: Changed to return -ENOMEM instead of ret where possible and
> > >>>     updated the subject line.
> > >>>
> > >>>  arch/arm/mach-imx/devices/platform-ipu-core.c |   22 +++++++++++++---------
> > >>>  1 file changed, 13 insertions(+), 9 deletions(-)
> > >>>
> > >>> diff --git a/arch/arm/mach-imx/devices/platform-ipu-core.c b/arch/arm/mach-imx/devices/platform-ipu-core.c
> > >>> index fc4dd7c..68f2a4a 100644
> > >>> --- a/arch/arm/mach-imx/devices/platform-ipu-core.c
> > >>> +++ b/arch/arm/mach-imx/devices/platform-ipu-core.c
> > >>> @@ -77,34 +77,38 @@ struct platform_device *__init imx_alloc_mx3_camera(
> > >>>  
> > >>>  	pdev = platform_device_alloc("mx3-camera", 0);
> > >>>  	if (!pdev)
> > >>> -		goto err;
> > >>> +		return ERR_PTR(-ENOMEM);
> > >>>  
> > >>>  	pdev->dev.dma_mask = kmalloc(sizeof(*pdev->dev.dma_mask), GFP_KERNEL);
> > >>>  	if (!pdev->dev.dma_mask)
> > >>> -		goto err;
> > >>> +		goto put_pdev;
> > >>>  
> > >>>  	*pdev->dev.dma_mask = DMA_BIT_MASK(32);
> > >>>  	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
> > >>>  
> > >>>  	ret = platform_device_add_resources(pdev, res, ARRAY_SIZE(res));
> > >>>  	if (ret)
> > >>> -		goto err;
> > >>> +		goto free_dma_mask;
> > >>>  
> > >>>  	if (pdata) {
> > >>>  		struct mx3_camera_pdata *copied_pdata;
> > >>>  
> > >>>  		ret = platform_device_add_data(pdev, pdata, sizeof(*pdata));
> > >>> -		if (ret) {
> > >>> -err:
> > >>> -			kfree(pdev->dev.dma_mask);
> > >>> -			platform_device_put(pdev);
> > >>> -			return ERR_PTR(-ENODEV);
> > >>> -		}
> > >>> +		if (ret)
> > >>> +			goto free_dma_mask;
> > >>> +
> > >>>  		copied_pdata = dev_get_platdata(&pdev->dev);
> > >>>  		copied_pdata->dma_dev = &imx_ipu_coredev->dev;
> > >>
> > >>
> > >> the patch is fine, but what use is this copied_pdata ?
> > >> It scope ends next line ?
> > >>
> > >> re,
> > >>  wh
> > > 
> > > I also thought that looked a bit odd, but copied_pdata is a temporary
> > > pointer to platform_data of the dev struct.
> > > 
> > > dev_get_platdata looks like this:
> > > 
> > > static inline void *dev_get_platdata(const struct device *dev)
> > > {
> > >         return dev->platform_data;
> > > }
> > > 
> > > So I believe it's a more compact way of writing:
> > > 
> > > pdev->dev->platform_data->dma_dev = &imx_ipu_coredev->dev;
> It's not about compactness. The dev_get_platdata accessor exists to be
> used instead of directly accessing dev->platform_data. I admit a comment
> would be nice ...
> 
> Anyhow this is all ugly, actually you'd want to have the dma_dev member
> already fixed when calling platform_device_add_data. But you cannot
> simply do
> 
> 	pdata->dma_dev = &imx_ipu_coredev->dev;
> 	ret = platform_device_add_data(pdev, pdata, sizeof(*pdata));
> 
> because *pdata is const.

Thank you for the explanation. Regarding the possibility of using
platform_device_register_full() to simplify this function. It seem to
be possible, the following inline function is available to help with this.

imx_add_platform_device_dmamask()

Available here:

arch/arm/mach-imx/devices/devices-common.h

But as you mentioned above we need to allocate a new platform_device
struct before we can assign &imx_ipu_coredev->dev to dma_dev, since
pdata is const. I guess this assignment could be done after calling
imx_add_platform_device_dmamask() but I don't think that makes the
code easier to read.

I think it's best to resend the current patch. (with updated subject line)

Best regards,

Emil Goode



