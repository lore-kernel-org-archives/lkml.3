Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933875Ab3GWVrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:47:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40853 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756955Ab3GWVrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:47:08 -0400
Date: Tue, 23 Jul 2013 14:47:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: navin patidar <navinp@cdac.in>
Cc: mfm@muteddisk.com, sergei.shtylyov@cogentembedded.com, joe@perches.com,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] staging: usbip: replace pr_warning() with dev_warn().
Message-ID: <20130723214707.GA20685@kroah.com>
References: <1372327492-9099-1-git-send-email-navinp@cdac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372327492-9099-1-git-send-email-navinp@cdac.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 03:34:52PM +0530, navin patidar wrote:
> dev_warn() is preferred over pr_warning().
> 
> container_of() is used to get usb_driver pointer from usbip_device container
> (stub_device or vhci_device), to get device structure required for dev_warn().
> 
> Signed-off-by: navin patidar <navinp@cdac.in>
> ---
>  drivers/staging/usbip/usbip_event.c |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/usbip/usbip_event.c b/drivers/staging/usbip/usbip_event.c
> index 82123be..1f3a571 100644
> --- a/drivers/staging/usbip/usbip_event.c
> +++ b/drivers/staging/usbip/usbip_event.c
> @@ -21,6 +21,8 @@
>  #include <linux/export.h>
> 
>  #include "usbip_common.h"
> +#include "stub.h"
> +#include "vhci.h"
> 
>  static int event_handler(struct usbip_device *ud)
>  {
> @@ -85,7 +87,14 @@ int usbip_start_eh(struct usbip_device *ud)
> 
>  	ud->eh = kthread_run(event_handler_loop, ud, "usbip_eh");
>  	if (IS_ERR(ud->eh)) {
> -		pr_warning("Unable to start control thread\n");
> +		struct device *dev;
> +
> +		if (ud->side == USBIP_STUB)
> +			dev = &container_of(ud, struct stub_device, ud)->udev->dev;
> +		else
> +			dev = &container_of(ud, struct vhci_device, ud)->udev->dev;

Putting '&' in front of container_of seems odd, are you sure it's needed
here?  If ud is a pointer, everything else should "just work" properly
without that.

Can you please fix this up?

thanks,

greg k-h
