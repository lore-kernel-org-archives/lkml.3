Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab3EJODd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:03:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39747 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753762Ab3EJOD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:03:29 -0400
Date: Fri, 10 May 2013 10:03:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Wolfram Sang <wsa@the-dreams.de>
cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [RFC 30/42] drivers/usb/host: don't check resource with
 devm_ioremap_resource
In-Reply-To: <1368173847-5661-31-git-send-email-wsa@the-dreams.de>
Message-ID: <Pine.LNX.4.44L0.1305100957320.1313-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 May 2013, Wolfram Sang wrote:

> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
>  drivers/usb/host/ehci-atmel.c    |    9 +--------
>  drivers/usb/host/ehci-mxc.c      |    8 +-------
>  drivers/usb/host/ehci-platform.c |    6 +-----
>  drivers/usb/host/ehci-sh.c       |   10 +---------
>  drivers/usb/host/ohci-nxp.c      |    6 ------
>  drivers/usb/host/ohci-platform.c |    7 +------
>  6 files changed, 5 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-atmel.c b/drivers/usb/host/ehci-atmel.c
> index 6642009..62bf3e6 100644
> --- a/drivers/usb/host/ehci-atmel.c
> +++ b/drivers/usb/host/ehci-atmel.c
> @@ -101,17 +101,10 @@ static int ehci_atmel_drv_probe(struct platform_device *pdev)
>  		goto fail_create_hcd;
>  	}
>  
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		dev_err(&pdev->dev,
> -			"Found HC with no register addr. Check %s setup!\n",
> -			dev_name(&pdev->dev));
> -		retval = -ENODEV;
> -		goto fail_request_resource;
> -	}
>  	hcd->rsrc_start = res->start;
>  	hcd->rsrc_len = resource_size(res);
>  
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	hcd->regs = devm_ioremap_resource(&pdev->dev, res);

This isn't right.  You are now dereferencing an uninitialized pointer
in the assignment to hcd->rsrc_start.  The compiler won't like that.

Most of the other changes in this patch suffer from the same problem.

Alan Stern

