Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab3KESLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 13:11:37 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:34553 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab3KESLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 13:11:34 -0500
MIME-Version: 1.0
In-Reply-To: <525E9046.3090209@ti.com>
References: <1381866857-3861-1-git-send-email-kishon@ti.com>
	<1381866857-3861-2-git-send-email-kishon@ti.com>
	<525E8E93.9010503@ti.com>
	<525E9046.3090209@ti.com>
Date: Tue, 5 Nov 2013 23:41:31 +0530
Message-ID: <CAFp+6iFFk9Bg1xDaKbuQwF_vEmnVtFtai6LPEsNDodpH5WF4ow@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] usb: dwc3: get "usb_phy" only if the platform
 indicates the presence of PHY's
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Kishon Vijay Abraham I <kishon@ti.com>, Roger Quadros <rogerq@ti.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, ijc+devicetree@hellion.org.uk,
        Rob Landley <rob@landley.net>, Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Kishon, Roger


On Wed, Oct 16, 2013 at 6:40 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> Hi roger,
>
> On Wednesday 16 October 2013 06:33 PM, Roger Quadros wrote:
>> Hi Kishon,

Apologies for missing this thread for so long.

>>
>> On 10/15/2013 10:54 PM, Kishon Vijay Abraham I wrote:
>>> There can be systems which does not have a external usb_phy, so get
>>> usb_phy only if dt data indicates the presence of PHY in the case of dt boot or
>>> if platform_data indicates the presence of PHY. Also remove checking if
>>> return value is -ENXIO since it's now changed to always enable usb_phy layer.
>>>
>>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>>> ---
>>> In usb_get_phy_by_phandle, index 0 always refers to usb2 phy and index 1 always
>>> refers to usb3 phy. Since we've lived so long with this, this patch will make
>>> an assumption that if only one entry is populated in *usb-phy* property, it will
>>> be usb2 phy and the next entry will be usb3 phy.
>>>
>>>  drivers/usb/dwc3/Kconfig         |    1 +
>>>  drivers/usb/dwc3/core.c          |   72 ++++++++++++++++++++------------------
>>>  drivers/usb/dwc3/platform_data.h |    2 ++
>>>  3 files changed, 41 insertions(+), 34 deletions(-)
>>>
>>> diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
>>> index 70fc430..8e385b4 100644
>>> --- a/drivers/usb/dwc3/Kconfig
>>> +++ b/drivers/usb/dwc3/Kconfig
>>> @@ -1,6 +1,7 @@
>>>  config USB_DWC3
>>>      tristate "DesignWare USB3 DRD Core Support"
>>>      depends on (USB || USB_GADGET) && HAS_DMA
>>> +    select USB_PHY
>>>      select USB_XHCI_PLATFORM if USB_SUPPORT && USB_XHCI_HCD
>>>      help
>>>        Say Y or M here if your system has a Dual Role SuperSpeed
>>> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
>>> index 474162e..cb91d70 100644
>>> --- a/drivers/usb/dwc3/core.c
>>> +++ b/drivers/usb/dwc3/core.c
>>> @@ -354,6 +354,7 @@ static int dwc3_probe(struct platform_device *pdev)
>>>      struct device_node      *node = dev->of_node;
>>>      struct resource         *res;
>>>      struct dwc3             *dwc;
>>> +    int                     count;
>>>
>>>      int                     ret = -ENOMEM;
>>>
>>> @@ -387,16 +388,49 @@ static int dwc3_probe(struct platform_device *pdev)
>>>      if (node) {
>>>              dwc->maximum_speed = of_usb_get_maximum_speed(node);
>>>
>>> -            dwc->usb2_phy = devm_usb_get_phy_by_phandle(dev, "usb-phy", 0);
>>> -            dwc->usb3_phy = devm_usb_get_phy_by_phandle(dev, "usb-phy", 1);
>>> +            count = of_count_phandle_with_args(node, "usb-phy", NULL);
>>> +            switch (count) {
>>> +            case 2:
>>> +                    dwc->usb3_phy = devm_usb_get_phy_by_phandle(dev,
>>> +                            "usb-phy", 1);
>>> +                    if (IS_ERR(dwc->usb3_phy)) {
>>> +                            dev_err(dev, "usb3 phy not found\n");
>>> +                            return PTR_ERR(dwc->usb3_phy);
>>> +                    }
>>> +            case 1:
>>> +                    dwc->usb2_phy = devm_usb_get_phy_by_phandle(dev,
>>> +                            "usb-phy", 0);
>>> +                    if (IS_ERR(dwc->usb2_phy)) {
>>> +                            dev_err(dev, "usb2 phy not found\n");
>>> +                            return PTR_ERR(dwc->usb2_phy);
>>> +                    }
>>> +                    break;
>>
>> In the Exynos case, there is only 1 phy and it is the USB3 phy. This code
>> will wrongly treat it as usb2_phy.

Thank you Roger for your concern regarding Exynos case.
It's true that, Exynos5 series of SoCs have got only one IP block for
DWC3'c PHY.
This block is actually a combo of USB2 phy (UTMI+) as well as USB3 phy (PIPE3).
And the same is served by a single USB phy driver. This is also
clarified in the thread : https://lkml.org/lkml/2013/11/5/160

>
> That was the case even before this patch no? Unfortunately the old USB PHY
> library doesn't have APIs to get PHYs in a better way. If we try modifying the
> USB PHY library, it'll be kind of duplicating what is already there in the
> Generic PHY library. I'd rather prefer Exynos guys to use the new framework.
>
> Thanks
> Kishon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
