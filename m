Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbaLEKRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 05:17:48 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:46946 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaLEKRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 05:17:46 -0500
Date: Fri, 5 Dec 2014 11:17:41 +0100
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: lee.jones@linaro.org, johan@kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: dln2: add suspend/resume functionality
Message-ID: <20141205101741.GD11445@localhost>
References: <1417089434-11274-1-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417089434-11274-1-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 01:57:14PM +0200, Octavian Purdila wrote:

> @@ -753,11 +759,42 @@ static const struct usb_device_id dln2_table[] = {
>  
>  MODULE_DEVICE_TABLE(usb, dln2_table);

Place the new callbacks above the device id table.

> +static int dln2_suspend(struct usb_interface *iface, pm_message_t message)
> +{
> +	struct dln2_dev *dln2 = usb_get_intfdata(iface);
> +
> +	dln2_stop(dln2);

You should also stop the reads urbs here.

> +	return 0;
> +}
> +
> +static int dln2_resume(struct usb_interface *iface)
> +{
> +	struct dln2_dev *dln2 = usb_get_intfdata(iface);
> +
> +	dln2->disconnect = false;

And surely you need to resubmit the read urbs in resume, or you will
never receive any more data.

How did you test this patch?

> +	return 0;
> +}
> +
> +static int dln2_reset_resume(struct usb_interface *iface)
> +{
> +	struct dln2_dev *dln2 = usb_get_intfdata(iface);
> +	int ret;
> +
> +	dln2_free_rx_urbs(dln2);
> +	ret = dln2_setup_rx_urbs(dln2, iface->cur_altsetting);

This doesn't make much sense. Why would you ever want to reallocate the
urbs and their buffers here?  

If the device does not lose its state as you claim, then all you need to
do is to resubmit the read urbs (as in resume).

Johan
