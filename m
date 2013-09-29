Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab3I2DA3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 23:00:29 -0400
Received: from netrider.rowland.org ([192.131.102.5]:60056 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753609Ab3I2DA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 23:00:28 -0400
Date: Sat, 28 Sep 2013 23:00:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Tomasz Figa <tomasz.figa@gmail.com>
cc: USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] USB: OHCI: Check the overrides pointer for NULL in
 ohci_init_driver()
In-Reply-To: <1380390989-4740-1-git-send-email-tomasz.figa@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1309282259220.11462-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Sep 2013, Tomasz Figa wrote:

> A series of commit starting at
> 
> 50a97e059b USB: OHCI: make ohci-exynos a separate driver
> 
> and ending at
> 
> b8ad5c3706 USB: OHCI: make ohci-pxa27x a separate driver
> 
> introduced the concept of separate OHCI drivers for particular
> controllers. Respective drivers need to call ohci_init_driver() to
> initialize hc_driver struct with generic data and to certain extent
> with platform specific overrides through ohci_driver_overrides struct
> passed as second argument to this function. However the code does not
> check if the ohci_driver_overrides struct pointer is non-NULL, which
> leads for a NULL pointer dereference for drivers that do not need any
> overrides.
> 
> This patch fixes the problem by dereferencing the passed pointer to
> ohci_driver_overrides struct only if it is non-NULL.
> 
> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
> ---
>  drivers/usb/host/ohci-hcd.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
> index 21d937a..8ada13f 100644
> --- a/drivers/usb/host/ohci-hcd.c
> +++ b/drivers/usb/host/ohci-hcd.c
> @@ -1161,10 +1161,12 @@ void ohci_init_driver(struct hc_driver *drv,
>  	/* Copy the generic table to drv and then apply the overrides */
>  	*drv = ohci_hc_driver;
>  
> -	drv->product_desc = over->product_desc;
> -	drv->hcd_priv_size += over->extra_priv_size;
> -	if (over->reset)
> -		drv->reset = over->reset;
> +	if (over) {
> +		drv->product_desc = over->product_desc;
> +		drv->hcd_priv_size += over->extra_priv_size;
> +		if (over->reset)
> +			drv->reset = over->reset;
> +	}
>  }
>  EXPORT_SYMBOL_GPL(ohci_init_driver);

You were scooped by Kevin Hilman:

	http://marc.info/?l=linux-usb&m=138029463906143&w=2

Alan Stern

