Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbbATKry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:47:54 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:37258 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbbATKrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:47:52 -0500
Date: Tue, 20 Jan 2015 10:47:47 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: johan@kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mfd: dln2: add start/stop RX URBs helpers
Message-ID: <20150120104747.GT5767@x1>
References: <1421668296-28470-1-git-send-email-octavian.purdila@intel.com>
 <1421668296-28470-2-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1421668296-28470-2-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2015, Octavian Purdila wrote:

> This is in preparation for adding suspend / resume support.
> 
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> Reviewed-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/mfd/dln2.c | 51 +++++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 41 insertions(+), 10 deletions(-)

With Johan's Ack, I'm fairly sure I can just apply this without an in
depth review from me.

After a quick glance; applied, thanks.

> diff --git a/drivers/mfd/dln2.c b/drivers/mfd/dln2.c
> index 6d49685..8311820 100644
> --- a/drivers/mfd/dln2.c
> +++ b/drivers/mfd/dln2.c
> @@ -587,12 +587,19 @@ static void dln2_free_rx_urbs(struct dln2_dev *dln2)
>  	int i;
>  
>  	for (i = 0; i < DLN2_MAX_URBS; i++) {
> -		usb_kill_urb(dln2->rx_urb[i]);
>  		usb_free_urb(dln2->rx_urb[i]);
>  		kfree(dln2->rx_buf[i]);
>  	}
>  }
>  
> +static void dln2_stop_rx_urbs(struct dln2_dev *dln2)
> +{
> +	int i;
> +
> +	for (i = 0; i < DLN2_MAX_URBS; i++)
> +		usb_kill_urb(dln2->rx_urb[i]);
> +}
> +
>  static void dln2_free(struct dln2_dev *dln2)
>  {
>  	dln2_free_rx_urbs(dln2);
> @@ -604,9 +611,7 @@ static int dln2_setup_rx_urbs(struct dln2_dev *dln2,
>  			      struct usb_host_interface *hostif)
>  {
>  	int i;
> -	int ret;
>  	const int rx_max_size = DLN2_RX_BUF_SIZE;
> -	struct device *dev = &dln2->interface->dev;
>  
>  	for (i = 0; i < DLN2_MAX_URBS; i++) {
>  		dln2->rx_buf[i] = kmalloc(rx_max_size, GFP_KERNEL);
> @@ -620,8 +625,19 @@ static int dln2_setup_rx_urbs(struct dln2_dev *dln2,
>  		usb_fill_bulk_urb(dln2->rx_urb[i], dln2->usb_dev,
>  				  usb_rcvbulkpipe(dln2->usb_dev, dln2->ep_in),
>  				  dln2->rx_buf[i], rx_max_size, dln2_rx, dln2);
> +	}
> +
> +	return 0;
> +}
>  
> -		ret = usb_submit_urb(dln2->rx_urb[i], GFP_KERNEL);
> +static int dln2_start_rx_urbs(struct dln2_dev *dln2, gfp_t gfp)
> +{
> +	struct device *dev = &dln2->interface->dev;
> +	int ret;
> +	int i;
> +
> +	for (i = 0; i < DLN2_MAX_URBS; i++) {
> +		ret = usb_submit_urb(dln2->rx_urb[i], gfp);
>  		if (ret < 0) {
>  			dev_err(dev, "failed to submit RX URB: %d\n", ret);
>  			return ret;
> @@ -665,9 +681,8 @@ static const struct mfd_cell dln2_devs[] = {
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
> @@ -696,6 +711,15 @@ static void dln2_disconnect(struct usb_interface *interface)
>  	/* wait for transfers to end */
>  	wait_event(dln2->disconnect_wq, !dln2->active_transfers);
>  
> +	dln2_stop_rx_urbs(dln2);
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
> @@ -738,23 +762,30 @@ static int dln2_probe(struct usb_interface *interface,
>  
>  	ret = dln2_setup_rx_urbs(dln2, hostif);
>  	if (ret)
> -		goto out_cleanup;
> +		goto out_free;
> +
> +	ret = dln2_start_rx_urbs(dln2, GFP_KERNEL);
> +	if (ret)
> +		goto out_stop_rx;
>  
>  	ret = dln2_hw_init(dln2);
>  	if (ret < 0) {
>  		dev_err(dev, "failed to initialize hardware\n");
> -		goto out_cleanup;
> +		goto out_stop_rx;
>  	}
>  
>  	ret = mfd_add_hotplug_devices(dev, dln2_devs, ARRAY_SIZE(dln2_devs));
>  	if (ret != 0) {
>  		dev_err(dev, "failed to add mfd devices to core\n");
> -		goto out_cleanup;
> +		goto out_stop_rx;
>  	}
>  
>  	return 0;
>  
> -out_cleanup:
> +out_stop_rx:
> +	dln2_stop_rx_urbs(dln2);
> +
> +out_free:
>  	dln2_free(dln2);
>  
>  	return ret;

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
