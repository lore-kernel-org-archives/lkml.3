Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbaIYM1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 08:27:05 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16800 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaIYM1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 08:27:03 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-9a-54240a134ed8
Message-id: <54240A12.3080206@samsung.com>
Date: Thu, 25 Sep 2014 14:26:58 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Robert Baldyga <r.baldyga@samsung.com>, Paul.Zimmerman@synopsys.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCH 1/6] usb: dwc2/gadget: move phy bus legth initialization
References: <1410252297-13738-1-git-send-email-r.baldyga@samsung.com>
 <1410252297-13738-2-git-send-email-r.baldyga@samsung.com>
In-reply-to: <1410252297-13738-2-git-send-email-r.baldyga@samsung.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xK7rCXCohBhP26FkcvF9v0bx4PZvF
	j9cX2Cwu75rDZrFoWSuzxaOHW1ktHhzeye7A7rF/7hp2j74tqxg9tuz/zOhx/MZ2Jo/Pm+QC
	WKO4bFJSczLLUov07RK4MuYuX8dc8Few4sfUg4wNjO94uxg5OSQETCQmX73IDGGLSVy4t56t
	i5GLQ0hgKaPE7jV7mCCcT4wSuxpnAWU4OHgFtCRWdqWANLAIqEqcXbgErJlNwFCi620XWImo
	QIzEm/YCkDCvgKDEj8n3WEBsEQF3icttvcwgI5kFehgl7l5/C9YrLOAjsXHyXUaIXY2MElPW
	PQXr4BRwk9j07xdYEbOAmcSXl4dZIWx5ic1r3jJPYBSYhWTJLCRls5CULWBkXsUomlqaXFCc
	lJ5rqFecmFtcmpeul5yfu4kREuRfdjAuPmZ1iFGAg1GJh9fDXzlEiDWxrLgy9xCjBAezkggv
	H4tKiBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZG9YaKe8t+Xp1b+engpWWb5HtdNTYGyuXM2xv/
	ast7ue5vFTN+ZF5wKPl/7njaqqAkV029X6mrNWJ/HguSNzO8EdRcqPN/h1Ku5REdXhW1O79M
	bG4mG++86MPnt6bU5dRRoeD0x4s7zHeXrjtRI+v15MiMno3Lnhs0PF+puaetcKFp+1bVBu+X
	SizFGYmGWsxFxYkAXRKwi1ACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg and Paul,

On 2014-09-09 10:44, Robert Baldyga wrote:
> From: Kamil Debski <k.debski@samsung.com>
>
> This patch moves the part of code that initializes the PHY bus width.
> This results in simpler code and removes the need to check whether
> the Generic PHY Framework is used.

I've noticed that patches from this patchset have been finally merged to
usb-next tree, but I cannot find this patch there. Is there any reason for
dropping it?

> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>   drivers/usb/dwc2/gadget.c | 22 +++++++++++-----------
>   1 file changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
> index ce6071d..9cbe136 100644
> --- a/drivers/usb/dwc2/gadget.c
> +++ b/drivers/usb/dwc2/gadget.c
> @@ -3392,6 +3392,9 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
>   	if (!hsotg)
>   		return -ENOMEM;
>   
> +	/* Set default UTMI width */
> +	hsotg->phyif = GUSBCFG_PHYIF16;
> +
>   	/*
>   	 * Attempt to find a generic PHY, then look for an old style
>   	 * USB PHY, finally fall back to pdata
> @@ -3410,8 +3413,15 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
>   			hsotg->plat = plat;
>   		} else
>   			hsotg->uphy = uphy;
> -	} else
> +	} else {
>   		hsotg->phy = phy;
> +		/*
> +		 * If using the generic PHY framework, check if the PHY bus
> +		 * width is 8-bit and set the phyif appropriately.
> +		 */
> +		if (phy_get_bus_width(phy) == 8)
> +			hsotg->phyif = GUSBCFG_PHYIF8;
> +	}
>   
>   	hsotg->dev = dev;
>   
> @@ -3471,16 +3481,6 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
>   		goto err_supplies;
>   	}
>   
> -	/* Set default UTMI width */
> -	hsotg->phyif = GUSBCFG_PHYIF16;
> -
> -	/*
> -	 * If using the generic PHY framework, check if the PHY bus
> -	 * width is 8-bit and set the phyif appropriately.
> -	 */
> -	if (hsotg->phy && (phy_get_bus_width(phy) == 8))
> -		hsotg->phyif = GUSBCFG_PHYIF8;
> -
>   	/* usb phy enable */
>   	s3c_hsotg_phy_enable(hsotg);
>   

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

