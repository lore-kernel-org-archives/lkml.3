Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbaFTSDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 14:03:16 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:55800 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbaFTSDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 14:03:15 -0400
Message-ID: <53A4776B.8010208@cogentembedded.com>
Date: Fri, 20 Jun 2014 22:03:23 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Himangi Saraogi <himangi774@gmail.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
CC: julia.lawall@lip6.fr
Subject: Re: [PATCH] usb: host: xhci-plat: use devm_functions
References: <20140620164853.GA5798@himangi-Dell>
In-Reply-To: <20140620164853.GA5798@himangi-Dell>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06/20/2014 08:48 PM, Himangi Saraogi wrote:

> This patch introduces the use of managed interface devm_ioremap_resource
> for ioremap_nocache and request_mem_region and removes the corresponding
> free functions in the probe and remove functions.

> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> ---
>   drivers/usb/host/xhci-plat.c | 25 +++++--------------------
>   1 file changed, 5 insertions(+), 20 deletions(-)

> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
> index 29d8adb..31d14a5 100644
> --- a/drivers/usb/host/xhci-plat.c
> +++ b/drivers/usb/host/xhci-plat.c
> @@ -140,18 +140,11 @@ static int xhci_plat_probe(struct platform_device *pdev)
>   	hcd->rsrc_start = res->start;
>   	hcd->rsrc_len = resource_size(res);
>
> -	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len,
> -				driver->description)) {
> -		dev_dbg(&pdev->dev, "controller already in use\n");
> -		ret = -EBUSY;
> -		goto put_hcd;
> -	}
> -
> -	hcd->regs = ioremap_nocache(hcd->rsrc_start, hcd->rsrc_len);
> -	if (!hcd->regs) {
> +	hcd->regs = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(hcd->regs)) {
>   		dev_dbg(&pdev->dev, "error mapping memory\n");

    This line is worth removing -- devm_ioremap_resource() complains loudly on 
errors.

> -		ret = -EFAULT;
> -		goto release_mem_region;
> +		ret = PTR_ERR(hcd->regs);
> +		goto put_hcd;
>   	}

WBR, Sergei

