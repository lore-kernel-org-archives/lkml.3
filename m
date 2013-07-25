Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab3GYRVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:21:18 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:55707 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678Ab3GYRVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:21:15 -0400
Message-ID: <51F15E85.1050808@cogentembedded.com>
Date: Thu, 25 Jul 2013 21:21:09 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: dwc3: core: modify IO memory resource after deferred
 probe completes
References: <1374769590-14491-1-git-send-email-iivanov@mm-sol.com>
In-Reply-To: <1374769590-14491-1-git-send-email-iivanov@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 08:26 PM, Ivan T. Ivanov wrote:

> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

> When deferred probe happens driver will try to ioremap multiple times
> and will fail. Memory resource.start variable is a global variable,
> modifications in this field will be accumulated on every probe.
> Fix this by moving the above operations after driver hold all
> required PHY's.

> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> ---
>   drivers/usb/dwc3/core.c |   31 ++++++++++++++++---------------
>   1 file changed, 16 insertions(+), 15 deletions(-)

> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index 607bef8..50c833f 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
[...]
> @@ -452,6 +437,22 @@ static int dwc3_probe(struct platform_device *pdev)
>   		return -EPROBE_DEFER;
>   	}
>
> +	dwc->xhci_resources[0].start = res->start;
> +	dwc->xhci_resources[0].end = dwc->xhci_resources[0].start +
> +					DWC3_XHCI_REGS_END;
> +	dwc->xhci_resources[0].flags = res->flags;
> +	dwc->xhci_resources[0].name = res->name;
> +
> +	res->start += DWC3_GLOBALS_REGS_START;
> +
> +	 /*
> +	  * Request memory region but exclude xHCI regs,
> +	  * since it will be requested by the xhci-plat driver.
> +	  */

     Please remove an extra space after a tab on each comment line.
It seems like a good time to do it, while you're moving this code.

> +	regs = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(regs))
> +		return PTR_ERR(regs);
> +

WBR, Sergei

