Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbbATKsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:48:16 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:47072 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbbATKsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:48:14 -0500
Date: Tue, 20 Jan 2015 10:48:09 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: johan@kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] mfd: dln2: add suspend/resume functionality
Message-ID: <20150120104809.GU5767@x1>
References: <1421668296-28470-1-git-send-email-octavian.purdila@intel.com>
 <1421668296-28470-3-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1421668296-28470-3-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2015, Octavian Purdila wrote:

> Without suspend/resume functionality in the USB driver the USB core
> will disconnect and reconnect the DLN2 port and because the GPIO
> framework does not yet support removal of an in-use controller a
> suspend/resume operation will result in a crash.
> 
> This patch provides suspend and resume functions for the DLN2 driver
> so that the above scenario is avoided, if the host controller does not
> drop VBUS during suspend, since in this case the device state is
> preserved.
> 
> We chose not implemented reset_resume so that if the host controller
> does drop VBUS the resume path will go through above the
> disconnect/reconnect process since it is probably better to fix the
> GPIO framework disconnect issue then to save and restore the device
> state for every driver.
> 
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> Reviewed-by: Johan Hovold <johan@kernel.org>

With Johan's Ack, I'm fairly sure I can just apply this without an in
depth review from me.

After a quick glance; applied, thanks.

> ---
>  drivers/mfd/dln2.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/drivers/mfd/dln2.c b/drivers/mfd/dln2.c
> index 8311820..1be9bd1 100644
> --- a/drivers/mfd/dln2.c
> +++ b/drivers/mfd/dln2.c
> @@ -791,6 +791,24 @@ out_free:
>  	return ret;
>  }
>  
> +static int dln2_suspend(struct usb_interface *iface, pm_message_t message)
> +{
> +	struct dln2_dev *dln2 = usb_get_intfdata(iface);
> +
> +	dln2_stop(dln2);
> +
> +	return 0;
> +}
> +
> +static int dln2_resume(struct usb_interface *iface)
> +{
> +	struct dln2_dev *dln2 = usb_get_intfdata(iface);
> +
> +	dln2->disconnect = false;
> +
> +	return dln2_start_rx_urbs(dln2, GFP_NOIO);
> +}
> +
>  static const struct usb_device_id dln2_table[] = {
>  	{ USB_DEVICE(0xa257, 0x2013) },
>  	{ }
> @@ -803,6 +821,8 @@ static struct usb_driver dln2_driver = {
>  	.probe = dln2_probe,
>  	.disconnect = dln2_disconnect,
>  	.id_table = dln2_table,
> +	.suspend = dln2_suspend,
> +	.resume = dln2_resume,
>  };
>  
>  module_usb_driver(dln2_driver);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
