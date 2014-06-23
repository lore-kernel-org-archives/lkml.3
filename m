Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbaFWSlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 14:41:03 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.44.111]:42907 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbaFWSlB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 14:41:01 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Robert Baldyga <r.baldyga@samsung.com>, "balbi@ti.com" <balbi@ti.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "andrzej.p@samsung.com" <andrzej.p@samsung.com>
Subject: RE: [PATCH 06/11] usb: dwc2/gadget: ensure that all fifos have
 correct memory buffers
Thread-Topic: [PATCH 06/11] usb: dwc2/gadget: ensure that all fifos have
 correct memory buffers
Thread-Index: AQHPjrg8kjq7UPHOxEiJel2adNMMapt/BxPQ
Date: Mon, 23 Jun 2014 18:40:59 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844B9CC5@US01WEMBX2.internal.synopsys.com>
References: <1403509890-14103-1-git-send-email-r.baldyga@samsung.com>
 <1403509890-14103-7-git-send-email-r.baldyga@samsung.com>
In-Reply-To: <1403509890-14103-7-git-send-email-r.baldyga@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Robert Baldyga [mailto:r.baldyga@samsung.com]
> Sent: Monday, June 23, 2014 12:51 AM
> 
> From: Marek Szyprowski <m.szyprowski@samsung.com>
> 
> Print warning if FIFOs are configured in such a way that they don't fit
> into the SPRAM available on the s3c hsotg module.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>  drivers/usb/dwc2/core.h   |  1 +
>  drivers/usb/dwc2/gadget.c | 15 ++++++++++-----
>  2 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
> index 1efd10c..067390e 100644
> --- a/drivers/usb/dwc2/core.h
> +++ b/drivers/usb/dwc2/core.h
> @@ -194,6 +194,7 @@ struct s3c_hsotg {
>  	struct regulator_bulk_data supplies[ARRAY_SIZE(s3c_hsotg_supply_names)];
> 
>  	u32                     phyif;
> +	int			fifo_mem;
>  	unsigned int            dedicated_fifos:1;
>  	unsigned char           num_of_eps;
> 
> diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
> index 95b6dcb..21d21de 100644
> --- a/drivers/usb/dwc2/gadget.c
> +++ b/drivers/usb/dwc2/gadget.c
> @@ -194,6 +194,8 @@ static void s3c_hsotg_init_fifo(struct s3c_hsotg *hsotg)
>  	for (ep = 1; ep <= 15; ep++) {
>  		val = addr;
>  		val |= size << FIFOSIZE_DEPTH_SHIFT;
> +		WARN_ONCE(addr + size > hsotg->fifo_mem,
> +			  "insufficient fifo memory");
>  		addr += size;
> 
>  		writel(val, hsotg->regs + DPTXFSIZN(ep));
> @@ -3030,19 +3032,22 @@ static void s3c_hsotg_initep(struct s3c_hsotg *hsotg,
>   */
>  static void s3c_hsotg_hw_cfg(struct s3c_hsotg *hsotg)
>  {
> -	u32 cfg2, cfg4;
> +	u32 cfg2, cfg3, cfg4;
>  	/* check hardware configuration */
> 
>  	cfg2 = readl(hsotg->regs + 0x48);
>  	hsotg->num_of_eps = (cfg2 >> 10) & 0xF;
> 
> -	dev_info(hsotg->dev, "EPs:%d\n", hsotg->num_of_eps);
> +	cfg3 = readl(hsotg->regs + 0x4C);
> +	hsotg->fifo_mem = (cfg3 >> 16);
> 
>  	cfg4 = readl(hsotg->regs + 0x50);
>  	hsotg->dedicated_fifos = (cfg4 >> 25) & 1;
> 
> -	dev_info(hsotg->dev, "%s fifos\n",
> -		 hsotg->dedicated_fifos ? "dedicated" : "shared");
> +	dev_info(hsotg->dev, "EPs: %d, %s fifos, %d entries in SPRAM\n",
> +		 hsotg->num_of_eps,
> +		 hsotg->dedicated_fifos ? "dedicated" : "shared",
> +		 hsotg->fifo_mem);
>  }
> 
>  /**
> @@ -3495,8 +3500,8 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
>  	s3c_hsotg_phy_enable(hsotg);
> 
>  	s3c_hsotg_corereset(hsotg);
> -	s3c_hsotg_init(hsotg);
>  	s3c_hsotg_hw_cfg(hsotg);
> +	s3c_hsotg_init(hsotg);

This last hunk looks like it is not related to the rest of the patch? If
so, I think it should be a separate patch.

-- 
Paul

