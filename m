Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab3FZM4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:56:41 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:63527 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3FZM4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:56:39 -0400
Message-ID: <51CAE507.409@cogentembedded.com>
Date: Wed, 26 Jun 2013 16:56:39 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: navin patidar <navinp@cdac.in>
CC: gregkh@linuxfoundation.org, mfm@muteddisk.com, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: usbip: replace pr_warning() with dev_warn().
References: <1372239703-4551-1-git-send-email-navinp@cdac.in>
In-Reply-To: <1372239703-4551-1-git-send-email-navinp@cdac.in>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 26-06-2013 13:41, navin patidar wrote:

> dev_warn() is preferred over pr_warning().

> container_of() is used to get usb_driver pointer from usbip_device container
> (stub_device or vhci_device), to get device structure required for dev_warn().

> Signed-off-by: navin patidar <navinp@cdac.in>
> ---
>   drivers/staging/usbip/usbip_event.c |   14 +++++++++++++-
>   1 file changed, 13 insertions(+), 1 deletion(-)

> diff --git a/drivers/staging/usbip/usbip_event.c b/drivers/staging/usbip/usbip_event.c
> index 82123be..3bd1b94 100644
> --- a/drivers/staging/usbip/usbip_event.c
> +++ b/drivers/staging/usbip/usbip_event.c
> @@ -21,6 +21,8 @@
>   #include <linux/export.h>
>
>   #include "usbip_common.h"
> +#include "stub.h"
> +#include "vhci.h"
>
>   static int event_handler(struct usbip_device *ud)
>   {
> @@ -85,7 +87,17 @@ int usbip_start_eh(struct usbip_device *ud)
>
>   	ud->eh = kthread_run(event_handler_loop, ud, "usbip_eh");
>   	if (IS_ERR(ud->eh)) {
> -		pr_warning("Unable to start control thread\n");
> +		struct device dev;

    Empty line after declaration wouldn't hurt here...

> +		if (ud->side == USBIP_STUB) {
> +			struct stub_device *sdev;

    ... and here.

> +			sdev = container_of(ud, struct stub_device, ud);
> +			dev = sdev->udev->dev;
> +		} else {
> +			struct vhci_device *vdev;

    ... and here.

> +			vdev = container_of(ud, struct vhci_device, ud);
> +			dev = vdev->udev->dev;
> +		}
> +		dev_warn(&dev, "Unable to start control thread\n");

    Patch looks clumsy...

WBR, Sergei

