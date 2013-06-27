Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760Ab3F0Epc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 00:45:32 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59659 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750960Ab3F0Epa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 00:45:30 -0400
Message-ID: <1372308329.2060.3.camel@joe-AO722>
Subject: Re: [PATCH v3] staging: usbip: replace pr_warning() with dev_warn().
From: Joe Perches <joe@perches.com>
To: navin patidar <navinp@cdac.in>
Cc: gregkh@linuxfoundation.org, mfm@muteddisk.com,
        sergei.shtylyov@cogentembedded.com, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Wed, 26 Jun 2013 21:45:29 -0700
In-Reply-To: <1372307706-6711-1-git-send-email-navinp@cdac.in>
References: <1372307706-6711-1-git-send-email-navinp@cdac.in>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-27 at 10:05 +0530, navin patidar wrote:
> dev_warn() is preferred over pr_warning().
[]
> diff --git a/drivers/staging/usbip/usbip_event.c b/drivers/staging/usbip/usbip_event.c
[]
> @@ -85,7 +87,20 @@ int usbip_start_eh(struct usbip_device *ud)
> 
>  	ud->eh = kthread_run(event_handler_loop, ud, "usbip_eh");
>  	if (IS_ERR(ud->eh)) {
> -		pr_warning("Unable to start control thread\n");
> +		struct device dev;

Don't put a struct device on stack,
just use a struct device *

> +		if (ud->side == USBIP_STUB) {
> +			struct stub_device *sdev;
> +
> +			sdev = container_of(ud, struct stub_device, ud);
> +			dev = sdev->udev->dev;

			dev = &sdev->udev->dev;

> +		} else {
> +			struct vhci_device *vdev;
> +
> +			vdev = container_of(ud, struct vhci_device, ud);
> +			dev = vdev->udev->dev;

			dev = &vdev->udev->dev;
though maybe
			dev = &container_of(udev, struct vhci_device, ud)->udev->dev;
would work too.

> +		}
> +		dev_warn(&dev, "Unable to start control thread\n");

		dev_warn(dev, ...)



