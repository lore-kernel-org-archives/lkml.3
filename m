Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab3CRNsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 09:48:21 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:49214 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab3CRNsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 09:48:19 -0400
MIME-Version: 1.0
In-Reply-To: <30907273.148421363318130664.JavaMail.weblogic@epv6ml07>
References: <30907273.148421363318130664.JavaMail.weblogic@epv6ml07>
Date: Mon, 18 Mar 2013 19:18:18 +0530
Message-ID: <CAFp+6iHSus67LkFJsT-DhF3go=bvepV8nGquzF96oF2bHotFxw@mail.gmail.com>
Subject: Re: [PATCH v2] usb: ehci-s5p: Use devm for requesting ehci_vbus_gpio
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Felipe Balbi <balbi@ti.com>, Alexander Graf <agraf@suse.de>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Fri, Mar 15, 2013 at 8:58 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> On Friday, March 15, 2013 12:16 PM, Doug Anderson wrote:
>>
>> The ehci_vbus_gpio is requested but never freed.  This can cause
>> problems with deferred probes and would cause problems if
>> s5p_ehci_remove was ever called.  Use devm to fix this.
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>
> Acked-by: Jingoo Han <jg1.han@samsung.com>
>
>
> Best regards,
> Jingoo Han
>
>> ---
>> Changes in v2:
>> - &pdev->dev => dev elsewhere in s5p_setup_vbus_gpio()
>>
>>  drivers/usb/host/ehci-s5p.c | 11 ++++++-----
>>  1 file changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
>> index 20ebf6a..738490e 100644
>> --- a/drivers/usb/host/ehci-s5p.c
>> +++ b/drivers/usb/host/ehci-s5p.c
>> @@ -92,20 +92,21 @@ static void s5p_ehci_phy_disable(struct s5p_ehci_hcd *s5p_ehci)
>>
>>  static void s5p_setup_vbus_gpio(struct platform_device *pdev)
>>  {
>> +     struct device *dev = &pdev->dev;
>>       int err;
>>       int gpio;
>>
>> -     if (!pdev->dev.of_node)
>> +     if (!dev->of_node)
>>               return;
>>
>> -     gpio = of_get_named_gpio(pdev->dev.of_node,
>> -                     "samsung,vbus-gpio", 0);
>> +     gpio = of_get_named_gpio(dev->of_node, "samsung,vbus-gpio", 0);
>>       if (!gpio_is_valid(gpio))
>>               return;
>>
>> -     err = gpio_request_one(gpio, GPIOF_OUT_INIT_HIGH, "ehci_vbus_gpio");
>> +     err = devm_gpio_request_one(dev, gpio, GPIOF_OUT_INIT_HIGH,
>> +                                 "ehci_vbus_gpio");
>>       if (err)
>> -             dev_err(&pdev->dev, "can't request ehci vbus gpio %d", gpio);
>> +             dev_err(dev, "can't request ehci vbus gpio %d", gpio);
>>  }
>>

tested this patch with smdk5250 h/w.

Without this patch get following kernel message (since ehci-s5p's
probe was being deferred
due to unavailability of PHY and we were trying to request gpio once again) :
[    1.175000] s5p-ehci 12110000.usb: can't request ehci vbus gpio 177

which however goes away after applying this patch.

Tested-by: Vivek Gautam <gautam.vivek@samsung.com>


-- 
Thanks & Regards
Vivek
