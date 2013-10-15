Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963Ab3JOOtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:49:04 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58534 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932829Ab3JOOtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:49:00 -0400
Date: Tue, 15 Oct 2013 10:48:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: H Hartley Sweeten <hartleys@visionengravers.com>
cc: linux-usb@vger.kernel.org,
        ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, Ryan Mallon <rmallon@gmail.com>
Subject: Re: [PATCH] usb: ohci: remove ep93xx bus glue platform driver
In-Reply-To: <201310141435.31147.hartleys@visionengravers.com>
Message-ID: <Pine.LNX.4.44L0.1310151047100.1377-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Oct 2013, H Hartley Sweeten wrote:

> Convert ep93xx to use the OHCI platform driver and remove the
> ohci-ep93xx bus glue driver.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Ryan Mallon <rmallon@gmail.com>

...

> @@ -297,22 +298,58 @@ static struct platform_device ep93xx_rtc_device = {
>  	.resource	= ep93xx_rtc_resource,
>  };
>  
> +/*************************************************************************
> + * EP93xx OHCI USB Host
> + *************************************************************************/
> +
> +static struct clk *ep93xx_ohci_host_clock;
> +
> +static int ep93xx_ohci_power_on(struct platform_device *pdev)
> +{
> +	if (!ep93xx_ohci_host_clock) {
> +		ep93xx_ohci_host_clock = devm_clk_get(&pdev->dev, NULL);
> +		if (IS_ERR(ep93xx_ohci_host_clock))
> +			return PTR_ERR(ep93xx_ohci_host_clock);
> +	}
> +
> +	clk_enable(ep93xx_ohci_host_clock);
> +
> +	return 0;
> +}
> +
> +static void ep93xx_ohci_power_off(struct platform_device *pdev)
> +{
> +	clk_disable(ep93xx_ohci_host_clock);
> +}
> +
> +static void ep93xx_ohci_power_suspend(struct platform_device *pdev)
> +{
> +	ep93xx_ohci_power_off(pdev);
> +}
> +
> +static struct usb_ohci_pdata ep93xx_ohci_pdata = {
> +	.power_on	= ep93xx_ohci_power_on,
> +	.power_off	= ep93xx_ohci_power_off,
> +	.power_suspend	= ep93xx_ohci_power_suspend,
> +};

You don't need to have a separate ep93xx_ohci_power_suspend() routine.  
Just initialize the method entry for .power_suspend to point to 
ep93xx_ohci_power_off.

Alan Stern

