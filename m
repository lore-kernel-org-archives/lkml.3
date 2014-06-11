Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaFKTc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:32:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42705 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751002AbaFKTc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:32:28 -0400
Date: Wed, 11 Jun 2014 15:32:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Himangi Saraogi <himangi774@gmail.com>
cc: Tony Prisk <linux@prisktech.co.nz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <julia.lawall@lip6.fr>
Subject: Re: [PATCH v2] uhci-platform: use devm_ioremap resource
In-Reply-To: <20140611191844.GA13009@himangi-Dell>
Message-ID: <Pine.LNX.4.44L0.1406111528170.890-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2014, Himangi Saraogi wrote:

> This patch replaces the memory allocation using request_mem_region and
> the ioremap by a single call to managed interface devm_ioremap_reource.
> The corresponding calls to release_mem_region and iounmap in the probe
> and release functions are now unnecessary and are removed. Also a label
> is done away with and linux/device.h is added to make sure the devm_*()
> outine declarations are unambiguously available.
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
> v2: pass correct arguments to devm_ioremap_resource
> Not compile tested due to incompatible architecture.

uhci-platform is compatible with all architectures.  But you have to 
add it to the .config file by hand.

>  drivers/usb/host/uhci-platform.c | 22 +++++-----------------
>  1 file changed, 5 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/usb/host/uhci-platform.c b/drivers/usb/host/uhci-platform.c
> index 01833ab..b987f1d 100644
> --- a/drivers/usb/host/uhci-platform.c
> +++ b/drivers/usb/host/uhci-platform.c
> @@ -8,6 +8,7 @@
>   */
>  
>  #include <linux/of.h>
> +#include <linux/device.h>
>  #include <linux/platform_device.h>
>  
>  static int uhci_platform_init(struct usb_hcd *hcd)
> @@ -88,33 +89,22 @@ static int uhci_hcd_platform_probe(struct platform_device *pdev)
>  	hcd->rsrc_start = res->start;
>  	hcd->rsrc_len = resource_size(res);
>  
> -	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
> -		pr_err("%s: request_mem_region failed\n", __func__);
> -		ret = -EBUSY;
> +	hcd->regs = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(hcd->regs)) {
> +		ret = PTR_ERR(hcd->regs);
>  		goto err_rmr;

Again, you didn't adjust the statement label.  The "rmr" in err_rmr 
stands for "request_mem_region", so it is clearly out of place in your 
patch.

Alan Stern

