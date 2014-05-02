Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbaEBKgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 06:36:19 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:59777 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaEBKgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 06:36:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAFp+6iHgdgUNcbWky9TH6=3aSWZ4fcjTVgRs2NohYY6-VsQPiQ@mail.gmail.com>
References: <1398835192-21634-1-git-send-email-gautam.vivek@samsung.com>
	<1398835192-21634-3-git-send-email-gautam.vivek@samsung.com>
	<53628154.4080101@gmail.com>
	<CAFp+6iHgdgUNcbWky9TH6=3aSWZ4fcjTVgRs2NohYY6-VsQPiQ@mail.gmail.com>
Date: Fri, 2 May 2014 16:06:15 +0530
X-Google-Sender-Auth: 9Sot6oG4MKM6vgT5dB5GlcLHVhg
Message-ID: <CAFp+6iH8NE7axKnwkLFnxXqcVuZ8Y7PBebmg36z2KKdj+pQjhA@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] usb: ohci-exynos: Add facility to use phy provided
 by the generic phy framework
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kamil Debski <k.debski@samsung.com>, Jingoo Han <jg1.han@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2014 at 2:55 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> Hi Tomasz,
>
>
> On Thu, May 1, 2014 at 10:46 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>> Hi Vivek,
>>
>> Please see my comments inline.
>
> Thanks for the review, please find my answers inline.
>
>>
>>
>> On 30.04.2014 07:19, Vivek Gautam wrote:
>>>
>>> Add support to consume phy provided by Generic phy framework.
>>> Keeping the support for older usb-phy intact right now, in order
>>> to prevent any functionality break in absence of relevant
>>> device tree side change for ohci-exynos.
>>> Once we move to new phy in the device nodes for ohci, we can
>>> remove the support for older phys.
>>>
>>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>>> Cc: Jingoo Han <jg1.han@samsung.com>
>>> Cc: Alan Stern <stern@rowland.harvard.edu>
>>> ---
>>>
>>> Changes from v3:
>>>   - Calling usb_phy_shutdown() when exynos_ohci_phy_enable() is failing.
>>>   - Made exynos_ohci_phy_disable() return void, since its return value
>>>     did not serve any purpose.
>>>   - Calling clk_disable_unprepare() in exynos_ohci_resume() when
>>>     exynos_ohci_phy_enable() is failed.
>>>
>>>   .../devicetree/bindings/usb/exynos-usb.txt         |   19 +++
>>>   drivers/usb/host/ohci-exynos.c                     |  128
>>> +++++++++++++++++---
>>>   2 files changed, 132 insertions(+), 15 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/usb/exynos-usb.txt
>>> b/Documentation/devicetree/bindings/usb/exynos-usb.txt
>>> index d967ba1..a90c973 100644
>>> --- a/Documentation/devicetree/bindings/usb/exynos-usb.txt
>>> +++ b/Documentation/devicetree/bindings/usb/exynos-usb.txt
>>> @@ -38,6 +38,15 @@ Required properties:
>>>    - interrupts: interrupt number to the cpu.
>>>    - clocks: from common clock binding: handle to usb clock.
>>>    - clock-names: from common clock binding: Shall be "usbhost".
>>> + - port: if in the SoC there are OHCI phys, they should be listed here.
>>> +   One phy per port. Each port should have following entries:
>>> +       - reg: port number on OHCI controller, e.g
>>> +              On Exynos5250, port 0 is USB2.0 otg phy
>>> +                             port 1 is HSIC phy0
>>> +                             port 2 is HSIC phy1
>>> +       - phys: from the *Generic PHY* bindings, specifying phy used by
>>> port.
>>> +       - phy-names: from the *Generic PHY* bindings, specifying name of
>>> phy
>>> +                    used by the port.
>>
>>
>> I think you don't need this property for this binding, as the PHYs are being
>> requested by indices (in fact only index 0 is used).
>
> True, that phy-names property is not used, since PHYs are being
> requested using indices.
> We can remove this.
>
>>
>>
>>>
>>>   Example:
>>>         usb@12120000 {
>>> @@ -47,6 +56,16 @@ Example:
>>>
>>>                 clocks = <&clock 285>;
>>>                 clock-names = "usbhost";
>>> +
>>> +               #address-cells = <1>;
>>> +               #size-cells = <0>;
>>> +               port@0 {
>>> +                   reg = <0>;
>>> +                   phys = <&usb2phy 1>;
>>> +                   phy-names = "host";
>>
>>
>> Ditto.
> will remove this.
>
>>
>>
>>> +                   status = "disabled";
>>> +               };
>>> +
>>>         };
>>>
>>>   DWC3
>>> diff --git a/drivers/usb/host/ohci-exynos.c
>>> b/drivers/usb/host/ohci-exynos.c
>>> index 05f00e3..f90bf9a 100644
>>> --- a/drivers/usb/host/ohci-exynos.c
>>> +++ b/drivers/usb/host/ohci-exynos.c
>>> @@ -18,6 +18,7 @@
>>>   #include <linux/module.h>
>>>   #include <linux/of.h>
>>>   #include <linux/platform_device.h>
>>> +#include <linux/phy/phy.h>
>>>   #include <linux/usb/phy.h>
>>>   #include <linux/usb/samsung_usb_phy.h>
>>>   #include <linux/usb.h>
>>> @@ -33,28 +34,122 @@ static struct hc_driver __read_mostly
>>> exynos_ohci_hc_driver;
>>>
>>>   #define to_exynos_ohci(hcd) (struct exynos_ohci_hcd
>>> *)(hcd_to_ohci(hcd)->priv)
>>>
>>> +#define PHY_NUMBER 3
>>
>>
>> nit: A blank line would be nice here to separate from the struct below.
>
> Ok, will add one.
>
>>
>> By the way, doesn't the number of PHY ports depend on platform? Of course
>> right now the driver supports only Exynos >= 4210 SoCs with the generic PHY
>> interface, so it might be changed in further patches.
>
> Yes, the number of PHY ports will be platform dependent feature.
> In subsequent patches we can add support to count the number of PHYs,
> or rather in this patch
> itself, when we do -
>          for_each_available_child_of_node(dev->of_node, child) {
> we can keep a count of how many child nodes we found, and then
> configure those many.
> As such the host controller drivers will have 'host' and 'hsic' PHYs.
>
>>
>>
>>>   struct exynos_ohci_hcd {
>>>         struct clk *clk;
>>>         struct usb_phy *phy;
>>>         struct usb_otg *otg;
>>> +       struct phy *phy_g[PHY_NUMBER];
>>>   };
>>>
>>> -static void exynos_ohci_phy_enable(struct device *dev)
>>> +static int exynos_ohci_get_phy(struct device *dev,
>>> +                               struct exynos_ohci_hcd *exynos_ohci)
>>> +{
>>> +       struct device_node *child;
>>> +       struct phy *phy;
>>> +       int phy_number;
>>> +       int ret = 0;
>>> +
>>> +       exynos_ohci->phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
>>> +       if (IS_ERR(exynos_ohci->phy)) {
>>> +               ret = PTR_ERR(exynos_ohci->phy);
>>> +               /* This is the case when PHY config is disabled */
>>> +               if (ret == -ENXIO || ret == -ENODEV) {
>>> +                       dev_dbg(dev, "Failed to get usb2 phy\n");
>>> +                       exynos_ohci->phy = NULL;
>>
>>
>> I think you should keep this an ERR_PTR() and just use IS_ERR() check
>> further in the driver instead of checking for NULL.
>
> Yea, that's also one way to check for phy, i can modify this.
>
>>
>>> +                       ret = 0;
>>
>>
>> Do you need to set ret to 0 here? The code for getting generic PHYs will
>> either leave it unchanged when there are no port nodes defined or overwrite
>> it with value returned by of_property_read_u32(). In the first case, an
>> error code should be returned, not zero, as the driver was unable to get any
>> PHY.
>
> The idea was to not fail exynos_ohci_get_phy() call when the PHY
> configs are not even enabled.
> Since this would mean, that the driver will never be able to get a PHY
> in future, and there will be no point in
> failing the driver probe.
>
> In a case when the host controller dts is still on older PHY bindings,
> this 'ret' will *not* be over-wriiten, since the
> generic phy nodes will not be there.
> And in case the host dts is moved to the new generic PHY based
> bindings. then the part of this function exynos_ohci_get_phy()
> related to older usb-phy, shall not execute.
>
> This is reason why i did not really add a fall-back mechanism for getting PHY.
> Since from DT either of the two bindings be supplied, and then things
> here will be handles almost independently.
>
>>
>>
>>> +               } else if (ret == -EPROBE_DEFER) {
>>
>>
>> I think you could merge this case with the else clause below, as most driver
>> do. Moreover, since the only thing done after the fail_phy label is
>> returning the error code, you could just immediately return from here. So
>> the whole block of code would end up like this:
>>
>>         if (IS_ERR(exynos_ohci->phy)) {
>>                 ret = PTR_ERR(exynos_ohci->phy);
>>                 if (ret != -ENXIO && ret != -ENODEV) {
>>
>>                         dev_err(dev, "no usb2 phy configured\n");
>>                         return ret;
>>
>>                 }
>>                 dev_dbg(dev, "Failed to get usb2 phy\n");
>>                 exynos_ohci->phy = NULL;
>>         } else {
>>
>>                 exynos_ohci->otg = exynos_ohci->phy->otg;
>>         }
>
> Ok, this seems a good restructuring. I shall change this.
>
>>
>>> +                       goto fail_phy;
>>>
>>> +               } else {
>>> +                       dev_err(dev, "no usb2 phy configured\n");
>>> +                       goto fail_phy;
>>> +               }
>>> +       } else {
>>> +               exynos_ohci->otg = exynos_ohci->phy->otg;
>>> +       }
>>> +
>>> +       /* Getting generic phy:
>>
>>
>> CodingStyle: Multi-line comments should begin and end with a single empty
>> line:
>>
>>         /*
>>          * Getting generic phy:
>>          * ...
>>          */
>>
>> also nit: s/phy/PHY/
>>
>
> Ok, will correct this.
>
>>
>>> +        * We are keeping both types of phys as a part of transiting OHCI
>>> +        * to generic phy framework, so that in absence of supporting dts
>>> +        * changes the functionality doesn't break.
>>> +        * Once we move the ohci dt nodes to use new generic phys,
>>> +        * we can remove support for older PHY in this driver.
>>
>>
>> Well, this is not entirely true. The problem here is not caused by existing
>> DTS files, but rather a chance that there are existing devices using DTB
>> files built from them. So to remove the support for old bindings, we need to
>> make sure that such devices have their DTBs updated to ones built from new
>> DTS.
>
> Fair enough, thanks for explaining. :-)
> I shall modify this comment.
>
>>
>>
>>> +        */
>>> +       for_each_available_child_of_node(dev->of_node, child) {
>>> +               ret = of_property_read_u32(child, "reg", &phy_number);
>>> +               if (ret) {
>>> +                       dev_err(dev, "Failed to parse device tree\n");
>>> +                       of_node_put(child);
>>> +                       goto fail_phy;
>>
>>
>> Why not just return ret here?
>>
>>> +               }
>>
>>
>> nit: Blank line here would be nice.
>
> ok
>
>>
>>
>>> +               if (phy_number >= PHY_NUMBER) {
>>> +                       dev_err(dev, "Invalid number of PHYs\n");
>>> +                       of_node_put(child);
>>> +                       ret = -EINVAL;
>>> +                       goto fail_phy;
>>
>>
>> What about just return -EINVAL;
>
> Yea, just another way of doing things. ;-)
> I felt 'goto' to be a bit clean than adding number of returns in
> between statements.
>
>>
>>> +               }
>>
>>
>> nit: Here too.
> yea, will add a blank line.
>
>>
>>> +               phy = devm_of_phy_get(dev, child, 0);
>>> +               of_node_put(child);
>>> +               if (IS_ERR(phy)) {
>>> +                       ret = PTR_ERR(phy);
>>> +                       /* This is the case when PHY config is disabled */
>>> +                       if (ret == -ENOSYS || ret == -ENODEV) {
>>> +                               dev_dbg(dev, "Failed to get usb2 phy\n");
>>> +                               phy = NULL;
>>>
>>> +                               ret = 0;
>>> +                       } else if (ret == -EPROBE_DEFER) {
>>> +                               goto fail_phy;
>>> +                       } else {
>>> +                               dev_err(dev, "no usb2 phy configured\n");
>>> +                               goto fail_phy;
>>> +                       }
>>> +               }
>>
>>
>> Similar comments to this block apply as for the block getting legacy USB
>> PHY.
>
> Ok, i will restructure this same as 'legacy PHY  block'
>
>>
>>
>>> +               exynos_ohci->phy_g[phy_number] = phy;
>>> +       }
>>> +
>>> +fail_phy:
>>> +       return ret;
>>> +}
>>> +
>>> +static int exynos_ohci_phy_enable(struct device *dev)
>>>   {
>>>         struct usb_hcd *hcd = dev_get_drvdata(dev);
>>>         struct exynos_ohci_hcd *exynos_ohci = to_exynos_ohci(hcd);
>>> +       int i;
>>> +       int ret = 0;
>>>
>>> -       if (exynos_ohci->phy)
>>> -               usb_phy_init(exynos_ohci->phy);
>>> +       if (exynos_ohci->phy) {
>>
>>
>> !IS_ERR() should be used to check for validity.
>
> Ok, this with the earlier change of setting exynos_ohci->phy as
> ERR_PTR(), should be good then.
>
>>
>>
>>> +               ret = usb_phy_init(exynos_ohci->phy);
>>> +               if (ret)
>>> +                       return ret;
>>
>>
>> IMHO a simple return usb_phy_init(...) could be used here, if we are using
>> the legacy PHY interface.
>
> Right, with legacy PHY, just a 'return usb_phy_init(...)' should do;
> since those devices will not have the generic
> PHYs.
>
>>
>>
>>> +       }
>>> +
>>> +       for (i = 0; ret == 0 && i < PHY_NUMBER; i++)
>>> +               if (exynos_ohci->phy_g[i])
>>
>>
>> !IS_ERR(). Just make sure that the array is initialized with an ERR_PTR()
>> with some error code, (-ENODEV) probably
>
> Ok.

I think we don't need to initialize this array to any ERR_PTR(), since
devm_of_phy_get()
will anyways assign an ERR_PTR() to phy in unsuccessful case, and a
valid phy pointer
when it successfully gets one.
Isn't it ?

I think the same goes with legacy usb-phy function devm_usb_get_phy().


[snip]


-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
