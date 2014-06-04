Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbaFDGZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 02:25:34 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:65164 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbaFDGZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 02:25:32 -0400
MIME-Version: 1.0
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E0304844B2141@US01WEMBX2.internal.synopsys.com>
References: <1401791978-3555-1-git-send-email-gautam.vivek@samsung.com>
	<A2CA0424C0A6F04399FB9E1CD98E0304844B2141@US01WEMBX2.internal.synopsys.com>
Date: Wed, 4 Jun 2014 11:55:31 +0530
X-Google-Sender-Auth: GdjeZUDTFcQ_JxZYNfzlhczZWdI
Message-ID: <CAFp+6iGgyh9eBfHU-XY=v+81oXpNk+OHRd0oUAdVG2tDzgH=gQ@mail.gmail.com>
Subject: Re: [PATCH] usb: dwc3: Keeping 'resource' related code together
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kishon@ti.com" <kishon@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Wed, Jun 4, 2014 at 12:41 AM, Paul Zimmerman
<Paul.Zimmerman@synopsys.com> wrote:
>> From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-owner@vger.kernel.org] On Behalf Of Vivek Gautam
>> Sent: Tuesday, June 03, 2014 3:40 AM
>>
>> Putting together the code related to getting the 'IORESOURCE_MEM'
>> and assigning the same to dwc->xhci_resources, for increasing
>> the readability.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> ---
>>
>> Based on 'next' branch of Felipe's usb tree.
>> Also cleanly applies to 'usb-next' branch of Greg's usb tree.
>>
>>  drivers/usb/dwc3/core.c |   38 +++++++++++++++++++-------------------
>>  1 file changed, 19 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
>> index 3f59c12..4ca925d 100644
>> --- a/drivers/usb/dwc3/core.c
>> +++ b/drivers/usb/dwc3/core.c
>> @@ -656,6 +656,25 @@ static int dwc3_probe(struct platform_device *pdev)
>>               return -ENODEV;
>>       }
>>
>> +     dwc->xhci_resources[0].start = res->start;
>> +     dwc->xhci_resources[0].end = dwc->xhci_resources[0].start +
>> +                                     DWC3_XHCI_REGS_END;
>> +     dwc->xhci_resources[0].flags = res->flags;
>> +     dwc->xhci_resources[0].name = res->name;
>> +
>> +     res->start += DWC3_GLOBALS_REGS_START;
>> +
>> +     /*
>> +      * Request memory region but exclude xHCI regs,
>> +      * since it will be requested by the xhci-plat driver.
>> +      */
>> +     regs = devm_ioremap_resource(dev, res);
>> +     if (IS_ERR(regs))
>> +             return PTR_ERR(regs);
>> +
>> +     dwc->regs       = regs;
>> +     dwc->regs_size  = resource_size(res);
>> +
>>       if (node) {
>>               dwc->maximum_speed = of_usb_get_maximum_speed(node);
>
> I think this will break if the following dwc3_core_get_phy() call returns
> -EPROBE_DEFER. Since you have incremented res->start above, the next time
> this probe function is called, res->start will have the wrong value.
> Provided I'm reading the code correctly of course :)

True, my fault. This will surely throw an error in requesting memory
region the next time probe
is called.
Thanks for catching this.

>
> I think you could fix that by decrementing res->start back to its
> original value just after the call to resource_size() above.

Sure will put
        res->start -= DWC3_GLOBALS_REGS_START;
right after the call to resource_size() call.



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
