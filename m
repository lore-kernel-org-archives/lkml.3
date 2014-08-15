Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbaHOQi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:38:56 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:40755 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaHOQiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:38:54 -0400
MIME-Version: 1.0
In-Reply-To: <1407897037-6037-1-git-send-email-stepanm@codeaurora.org>
References: <53EAC37C.4020203@codeaurora.org> <1407897037-6037-1-git-send-email-stepanm@codeaurora.org>
From: Rob Herring <robherring2@gmail.com>
Date: Fri, 15 Aug 2014 11:38:33 -0500
Message-ID: <CAL_JsqKoikzLsXmXrm0GDM=+5ofX=OvrmvUTw3O-qX2hSTztcw@mail.gmail.com>
Subject: Re: [PATCH v2] of: Deep-copy names of platform devices
To: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Greg...

On Tue, Aug 12, 2014 at 9:30 PM, Stepan Moskovchenko
<stepanm@codeaurora.org> wrote:
> When we parse the device tree and allocate platform
> devices, the 'name' of the newly-created platform_device
> is set to point to the 'name' field of the 'struct device'
> embedded within the platform_device. This is dangerous,
> because the name of the 'struct device' is dynamically
> allocated. Drivers may call dev_set_name() on the device,
> which will free and reallocate the name of the device,
> leaving the 'name' of the platform_device pointing to the
> now-freed memory.
>
> Furthermore, if the dev_set_name() call is made from a
> driver's probe() function and a subsequent request results
> in probe deferral, the dangling 'name' reference may lead
> to the device being re-probed using the wrong driver.

This seems wrong. I don't think we want drivers to change their own
device's name. The name is not supposed to change after registration.

Rob

> To mitigate these scenarios, we use kstrdup to perform a
> deep copy of the device name when assigning the name of the
> platform_device, so that the platform_device name is
> unaffected by any calls to dev_set_name() that might made
> by drivers to rename the embedded 'struct device'.
>
> Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
> ---
> * v2 - swap cleanup order
>
>  drivers/of/device.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/of/device.c b/drivers/of/device.c
> index f685e55..e9beae6 100644
> --- a/drivers/of/device.c
> +++ b/drivers/of/device.c
> @@ -54,7 +54,7 @@ int of_device_add(struct platform_device *ofdev)
>
>         /* name and id have to be set so that the platform bus doesn't get
>          * confused on matching */
> -       ofdev->name = dev_name(&ofdev->dev);
> +       ofdev->name = kstrdup(dev_name(&ofdev->dev), GFP_KERNEL);
>         ofdev->id = -1;
>
>         /* device_add will assume that this device is on the same node as
> @@ -75,6 +75,7 @@ EXPORT_SYMBOL(of_device_register);
>
>  void of_device_unregister(struct platform_device *ofdev)
>  {
> +       kfree(ofdev->name);
>         device_unregister(&ofdev->dev);
>  }
>  EXPORT_SYMBOL(of_device_unregister);
> --
> The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
>
