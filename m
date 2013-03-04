Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab3CDIIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 03:08:49 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:35083 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536Ab3CDIIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 03:08:47 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1303021050210.11936-100000@netrider.rowland.org>
References: <1362230590-20960-7-git-send-email-gautam.vivek@samsung.com>
	<Pine.LNX.4.44L0.1303021050210.11936-100000@netrider.rowland.org>
Date: Mon, 4 Mar 2013 13:38:45 +0530
Message-ID: <CAFp+6iFsR1H8kRmg2ynGto0ZERydOc-Vk+niS_ucH20o2R7SCg@mail.gmail.com>
Subject: Re: [PATCH v2 06/10] usb: xhci: Enable runtime pm in xhci-plat
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, sarah.a.sharp@linux.intel.com, kgene.kim@samsung.com,
        kishon@ti.com, Doug Anderson <dianders@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Sat, Mar 2, 2013 at 9:23 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sat, 2 Mar 2013, Vivek Gautam wrote:
>
>> By enabling runtime pm in this driver allows users of
>> xhci-plat to enter into runtime pm. This is not full
>> runtime pm support (AKA xhci-plat doesn't actually power
>> anything off when in runtime suspend mode) but,
>> just basic enablement.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> CC: Doug Anderson <dianders@chromium.org>
>> ---
>>  drivers/usb/host/xhci-plat.c |    7 +++++++
>>  1 files changed, 7 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
>> index c9c7e13..595cb52 100644
>> --- a/drivers/usb/host/xhci-plat.c
>> +++ b/drivers/usb/host/xhci-plat.c
>> @@ -12,6 +12,7 @@
>>   */
>>
>>  #include <linux/platform_device.h>
>> +#include <linux/pm_runtime.h>
>>  #include <linux/module.h>
>>  #include <linux/slab.h>
>>
>> @@ -149,6 +150,8 @@ static int xhci_plat_probe(struct platform_device *pdev)
>>       if (ret)
>>               goto put_usb3_hcd;
>>
>> +     pm_runtime_enable(&pdev->dev);
>
> This is generally not a good idea.  You shouldn't enable a device for
> runtime PM without first telling the PM core what state it is in.
>
Right, but i am not completely sure on any fixed path to follow for
enabling runtime
power management on a device. :-(
Does it become necessary to "pm_runtime_set_active" or
"pm_runtime_set_suspended" a device
before "pm_runtime_enable" ? pm_runtime_enable would just try to
decrement the disable_depth
of the device.

>> @@ -174,6 +177,10 @@ static int xhci_plat_remove(struct platform_device *dev)
>>       struct usb_hcd  *hcd = platform_get_drvdata(dev);
>>       struct xhci_hcd *xhci = hcd_to_xhci(hcd);
>>
>> +     if (!pm_runtime_suspended(&dev->dev))
>> +             pm_runtime_put(&dev->dev);
>> +     pm_runtime_disable(&dev->dev);
>> +
>>       usb_remove_hcd(xhci->shared_hcd);
>>       usb_put_hcd(xhci->shared_hcd);
>
> This is very strange.  Why have a pm_runtime_put with no balancing
> pm_runtime_get?
>
> And why use an async routine when you're about to unbind the driver?
> Don't you want the callback to occur before the unbinding?
>
> Alan Stern
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks & Regards
Vivek
