Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbaLOLnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 06:43:08 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:43055 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaLOLnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:43:06 -0500
Date: Mon, 15 Dec 2014 12:43:02 +0100
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: linus.walleij@linaro.org, lee.jones@linaro.org, johan@kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: Re: [PATCH 3/3] mfd: dln2: add suspend/resume functionality
Message-ID: <20141215114302.GE6778@localhost>
References: <1418302951-9309-1-git-send-email-octavian.purdila@intel.com>
 <1418302951-9309-4-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418302951-9309-4-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 03:02:31PM +0200, Octavian Purdila wrote:
> Without suspend/resume functionality in the USB driver the USB core
> will disconnect and reconnect the DLN2 port and because the GPIO
> framework does not yet support removal of an in-use controller a
> suspend/resume operation will result in a crash.
> 
> This patch provides suspend and resume functions for the DLN2 driver
> so that the above scenario is avoided.
>
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> ---
>  drivers/mfd/dln2.c | 41 ++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 38 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mfd/dln2.c b/drivers/mfd/dln2.c
> index 6d49685..08c403c 100644
> --- a/drivers/mfd/dln2.c
> +++ b/drivers/mfd/dln2.c
> @@ -587,7 +587,6 @@ static void dln2_free_rx_urbs(struct dln2_dev *dln2)
>  	int i;
>  
>  	for (i = 0; i < DLN2_MAX_URBS; i++) {
> -		usb_kill_urb(dln2->rx_urb[i]);
>  		usb_free_urb(dln2->rx_urb[i]);
>  		kfree(dln2->rx_buf[i]);
>  	}

Now dln2_free will no longer stop the urbs before releasing them and
hence you can get a use after free in the error path of probe where
dln2_free is called after you have submitted the urbs.

Please be more careful.

Splitting allocation and submission (and reuse that helper in resume)
and adding a stop_rx_urbs helper might be a good idea.

> @@ -665,9 +664,8 @@ static const struct mfd_cell dln2_devs[] = {
>  	},
>  };
>  
> -static void dln2_disconnect(struct usb_interface *interface)
> +static void dln2_stop(struct dln2_dev *dln2)
>  {
> -	struct dln2_dev *dln2 = usb_get_intfdata(interface);
>  	int i, j;
>  
>  	/* don't allow starting new transfers */
> @@ -696,6 +694,16 @@ static void dln2_disconnect(struct usb_interface *interface)
>  	/* wait for transfers to end */
>  	wait_event(dln2->disconnect_wq, !dln2->active_transfers);
>  
> +	for (i = 0; i < DLN2_MAX_URBS; i++)
> +		usb_kill_urb(dln2->rx_urb[i]);
> +}
> +
> +static void dln2_disconnect(struct usb_interface *interface)
> +{
> +	struct dln2_dev *dln2 = usb_get_intfdata(interface);
> +
> +	dln2_stop(dln2);
> +
>  	mfd_remove_devices(&interface->dev);
>  
>  	dln2_free(dln2);
> @@ -767,11 +775,38 @@ static const struct usb_device_id dln2_table[] = {
>  
>  MODULE_DEVICE_TABLE(usb, dln2_table);

I believe I already asked you to place the new callbacks above the id
table.

> +static int dln2_suspend(struct usb_interface *iface, pm_message_t message)
> +{
> +	struct dln2_dev *dln2 = usb_get_intfdata(iface);
> +
> +	dln2_stop(dln2);
> +	return 0;
> +}
> +
> +static int dln2_resume(struct usb_interface *iface)
> +{
> +	struct dln2_dev *dln2 = usb_get_intfdata(iface);
> +	int i;
> +	int ret = 0;
> +
> +	dln2->disconnect = false;
> +
> +	for (i = 0; i < DLN2_MAX_URBS; i++) {
> +		ret = usb_submit_urb(dln2->rx_urb[i], GFP_KERNEL);

You cannot use GFP_KERNEL in resume, use GFP_NOIO.

> +		if (ret)

Add a dev_err here.

> +			break;
> +	}
> +
> +	return ret;
> +}

Johan
