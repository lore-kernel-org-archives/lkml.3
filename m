Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab3IPIkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:40:31 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:62316 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab3IPIk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:40:27 -0400
MIME-Version: 1.0
In-Reply-To: <5231BD9F.4020105@ti.com>
References: <1378136591-7463-1-git-send-email-kishon@ti.com>
	<1378136591-7463-2-git-send-email-kishon@ti.com>
	<52319912.8030203@ti.com>
	<CAFp+6iE+xbSWWp2bNc5MRSUrA4Fi6qVU4vhR4+mtZHZGidkMGg@mail.gmail.com>
	<52319FC4.8040703@ti.com>
	<CAFp+6iGzV4auP0AeySen2Qk6wEJM-xsTnQmfwMQDtp2tg1FMkQ@mail.gmail.com>
	<5231BD9F.4020105@ti.com>
Date: Mon, 16 Sep 2013 14:10:25 +0530
Message-ID: <CAFp+6iG=A5C3VY4sOT0qY10CSzdb2yCv1JVPW00K+MFHjcSqhA@mail.gmail.com>
Subject: Re: [PATCH 1/7] usb: dwc3: get "usb_phy" only if the platform
 indicates the presence of PHY
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Roger Quadros <rogerq@ti.com>, Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        george.cherian@ti.com, Greg KH <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Thu, Sep 12, 2013 at 6:41 PM, Roger Quadros <rogerq@ti.com> wrote:
> On 09/12/2013 02:26 PM, Vivek Gautam wrote:
>> Hi,
>>
>>
>> On Thu, Sep 12, 2013 at 4:34 PM, Roger Quadros <rogerq@ti.com> wrote:
>>> Hi,
>>>
>>> On 09/12/2013 01:47 PM, Vivek Gautam wrote:
>>>> On Thu, Sep 12, 2013 at 4:06 PM, Roger Quadros <rogerq@ti.com> wrote:
>>>>> Hi Kishon,
>>>>>
>>>>> On 09/02/2013 06:43 PM, Kishon Vijay Abraham I wrote:
>>>>>> There can be systems which does not have a external usb_phy, so get
>>>>>> usb_phy only if usb-phy property is added in the case of dt boot or if
>>>>>> platform_data indicates the presence of PHY. Also remove checking if
>>>>>> return value is -ENXIO since it's now changed to always enable usb_phy layer.
>>>>>>
>>>>>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>>>>>> ---
>>>>>>  drivers/usb/dwc3/Kconfig         |    1 +
>>>>>>  drivers/usb/dwc3/core.c          |   60 +++++++++++++++++---------------------
>>>>>>  drivers/usb/dwc3/platform_data.h |    1 +
>>>>>>  3 files changed, 28 insertions(+), 34 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
>>>>>> index f969ea2..cfc16dd 100644
>>>>>> --- a/drivers/usb/dwc3/Kconfig
>>>>>> +++ b/drivers/usb/dwc3/Kconfig
>>>>>> @@ -2,6 +2,7 @@ config USB_DWC3
>>>>>>       tristate "DesignWare USB3 DRD Core Support"
>>>>>>       depends on (USB || USB_GADGET) && GENERIC_HARDIRQS && HAS_DMA
>>>>>>       depends on EXTCON
>>>>>> +     select USB_PHY
>>>>>>       select USB_XHCI_PLATFORM if USB_SUPPORT && USB_XHCI_HCD
>>>>>>       help
>>>>>>         Say Y or M here if your system has a Dual Role SuperSpeed
>>>>>> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
>>>>>> index 474162e..428c29e 100644
>>>>>> --- a/drivers/usb/dwc3/core.c
>>>>>> +++ b/drivers/usb/dwc3/core.c
>>>>>> @@ -387,16 +387,38 @@ static int dwc3_probe(struct platform_device *pdev)
>>>>>>       if (node) {
>>>>>>               dwc->maximum_speed = of_usb_get_maximum_speed(node);
>>>>>>
>>>>>> -             dwc->usb2_phy = devm_usb_get_phy_by_phandle(dev, "usb-phy", 0);
>>>>>> -             dwc->usb3_phy = devm_usb_get_phy_by_phandle(dev, "usb-phy", 1);
>>>>>> +             if (of_property_read_bool(node, "usb-phy")) {
>>>>>> +                     dwc->usb2_phy = devm_usb_get_phy_by_phandle(dev,
>>>>>> +                             "usb-phy", 0);
>>>>>> +                     if (IS_ERR(dwc->usb2_phy))
>>>>>> +                             return PTR_ERR(dwc->usb2_phy);
>>>>>> +                     dwc->usb3_phy = devm_usb_get_phy_by_phandle(dev,
>>>>>> +                             "usb-phy", 1);
>>>>>> +                     if (IS_ERR(dwc->usb3_phy))
>>>>>> +                             return PTR_ERR(dwc->usb3_phy);
>>>>>
>>>>> Some DWC3 instances use only usb2_phy. e.g. on DRA7 the 2nd dwc3 instance doesn't use usb3_phy.
>>>>> This needs to be a valid case and driver shouldn't error out.
>>>>
>>>> So, i think adding flexibility to DWC3 to have either
>>>> usb2-phy/usb3-phy or both of them seems to be valid point.
>>>> Any suggestions ?
>>>>
>>>
>>> For high speed operation we need only usb2_phy but for super speed we need both usb2_phy
>>> and usb3_phy.
>>>
>>> Why would a dwc3 controller use only usb3_phy? A USB3.0 interface has to be compatible with
>>> USB2.0 as well, no?
>>
>> True and for that reason we need both UTMI+ interface as well as PIPE3
>> interface, right ?
>> But as also mentioned in the thread:
>> https://lkml.org/lkml/2013/9/12/181, on Samsung exynos5
>> architecturally same block is managing UTMI+ and PIPE3 interfaces,
>> which is handled by phy-samsung-usb3 driver and denoted by "usb3_phy:
>> usbphy@12100000" node in "arch/arm/boot/dts/exynos5250.dtsi".
>>
>> So on exynos5250, DWC3 really needs just usb3-phy, which is compatible
>> for USB 2.0 as well.
>
> I'm not familiar with exynos5250 dwc3, but looking at the dts file I can see both usb3_phy
> and usb2_phy nodes and both are referenced in the dwc3 node.

Right, and that's what we intend to fix.
Exynos5250 dwc3 is not in the need of both usb2_phy and usb3_phy.
In fact usb3_phy handle (which is served by phy-samsung-usb3 driver)
sets up the UTMI+ as well as PIPE3 phy on DWC3.
I know this looks different from the usual OMAP style of phy for dwc3.

Hi Sylwester,
  any suggestions here ? As contained in the exynos5250 user manual
too, there's only one block of PHY handling both UTMI+ and PIPE3
interfaces, and the set of registers (same base address) also indicate
one block of PHY. So we have the usb3_phy (phy-samsung-usb3 driver)
which setup the entire PHY require for DWC3 operation, and thereby we
__shouldn't__ need usb2_phy (phy-samsung-usb2 driver which actually
setup the PHY for a separate USB 2.0 controller on exynos5250) for
DWC3.

>
> The ehci and ohci controllers don't reference any PHY.

ehci-s5p and ohci-exynos are not using devm_usb_get_phy_by_phandle()
api until now, so they don't need to have the PHY handlers in their
node.

>
> cheers,
> -roger



-- 
Best Regards
Vivek
