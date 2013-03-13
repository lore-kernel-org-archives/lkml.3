Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932935Ab3CMO32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 10:29:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33336 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755571Ab3CMO30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 10:29:26 -0400
Date: Wed, 13 Mar 2013 10:29:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alexander Graf <agraf@suse.de>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <dmueller@suse.de>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] USB: ehci-s5p: Fix phy reset
In-Reply-To: <1363136988-3704-1-git-send-email-agraf@suse.de>
Message-ID: <Pine.LNX.4.44L0.1303131028140.1705-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Mar 2013, Alexander Graf wrote:

> On my Exynos 5 based Arndale system, I need to pull the reset line down
> and then let it go up again to actually perform a reset. Without that
> reset, I can't find any USB hubs on my bus, rendering the USB controller
> useless.
> 
> So this patch implements the above logic, making EHCI and OHCI work on
> Arndale systems for me.
> 
> Signed-off-by: Alexander Graf <agraf@suse.de>
> CC: Vivek Gautam <gautam.vivek@samsung.com>
> CC: Jingoo Han <jg1.han@samsung.com>
> CC: Alan Stern <stern@rowland.harvard.edu>
> CC: Kukjin Kim <kgene.kim@samsung.com>
> CC: Felipe Balbi <balbi@ti.com>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
> 
> As this affects 3.9, this patch should definitely be considered for inclusion
> there.
> ---
>  drivers/usb/host/ehci-s5p.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
> index 20ebf6a..c6d67e4 100644
> --- a/drivers/usb/host/ehci-s5p.c
> +++ b/drivers/usb/host/ehci-s5p.c
> @@ -103,9 +103,15 @@ static void s5p_setup_vbus_gpio(struct platform_device *pdev)
>  	if (!gpio_is_valid(gpio))
>  		return;
>  
> -	err = gpio_request_one(gpio, GPIOF_OUT_INIT_HIGH, "ehci_vbus_gpio");
> -	if (err)
> +	/* reset pulls the line down, then up again */
> +	err = gpio_request_one(gpio, GPIOF_OUT_INIT_LOW, "ehci_vbus_gpio");
> +	if (err) {
>  		dev_err(&pdev->dev, "can't request ehci vbus gpio %d", gpio);
> +		return;
> +	}
> +	mdelay(1);
> +	__gpio_set_value(gpio, 1);
> +	gpio_free(gpio);
>  }
>  
>  static u64 ehci_s5p_dma_mask = DMA_BIT_MASK(32);

Acked-by: Alan Stern <stern@rowland.harvard.edu>

