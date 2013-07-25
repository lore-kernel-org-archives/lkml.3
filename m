Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab3GYTrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 15:47:20 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:39001 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab3GYTrQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 15:47:16 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>, "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] usb: dwc3: core: modify IO memory resource after
 deferred probe completes
Thread-Topic: [PATCH] usb: dwc3: core: modify IO memory resource after
 deferred probe completes
Thread-Index: AQHOiVPvkmnt8PfOUEep6UDMuSIK7Jl1y1Ag
Date: Thu, 25 Jul 2013 19:46:58 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030458DE112E@US01WEMBX2.internal.synopsys.com>
References: <1374769590-14491-1-git-send-email-iivanov@mm-sol.com>
In-Reply-To: <1374769590-14491-1-git-send-email-iivanov@mm-sol.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Ivan T. Ivanov
> Sent: Thursday, July 25, 2013 9:27 AM
> 
> When deferred probe happens driver will try to ioremap multiple times
> and will fail. Memory resource.start variable is a global variable,
> modifications in this field will be accumulated on every probe.
> Fix this by moving the above operations after driver hold all
> required PHY's.
> 
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> ---
>  drivers/usb/dwc3/core.c |   31 ++++++++++++++++---------------
>  1 file changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index 607bef8..50c833f 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -384,21 +384,6 @@ static int dwc3_probe(struct platform_device *pdev)
>  		dev_err(dev, "missing memory resource\n");
>  		return -ENODEV;
>  	}
> -	dwc->xhci_resources[0].start = res->start;
> -	dwc->xhci_resources[0].end = dwc->xhci_resources[0].start +
> -					DWC3_XHCI_REGS_END;
> -	dwc->xhci_resources[0].flags = res->flags;
> -	dwc->xhci_resources[0].name = res->name;
> -
> -	res->start += DWC3_GLOBALS_REGS_START;
> -
> -	 /*
> -	  * Request memory region but exclude xHCI regs,
> -	  * since it will be requested by the xhci-plat driver.
> -	  */
> -	regs = devm_ioremap_resource(dev, res);
> -	if (IS_ERR(regs))
> -		return PTR_ERR(regs);
> 
>  	if (node) {
>  		dwc->maximum_speed = of_usb_get_maximum_speed(node);
> @@ -452,6 +437,22 @@ static int dwc3_probe(struct platform_device *pdev)
>  		return -EPROBE_DEFER;
>  	}
> 
> +	dwc->xhci_resources[0].start = res->start;
> +	dwc->xhci_resources[0].end = dwc->xhci_resources[0].start +
> +					DWC3_XHCI_REGS_END;
> +	dwc->xhci_resources[0].flags = res->flags;
> +	dwc->xhci_resources[0].name = res->name;
> +
> +	res->start += DWC3_GLOBALS_REGS_START;

Ick. The driver is modifying the struct resource passed to it by the
platform code? That seems like a layering violation, and is fragile as
hell. In addition to this bug, what would happen if the struct resource
was declared 'const'?

-- 
Paul

