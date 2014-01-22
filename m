Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbaAVGE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 01:04:56 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:48810 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526AbaAVGEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 01:04:47 -0500
MIME-Version: 1.0
In-Reply-To: <52DE7D75.4040302@ti.com>
References: <1385373690-12170-1-git-send-email-kishon@ti.com>
	<1390299099-14764-1-git-send-email-kishon@ti.com>
	<1390299099-14764-2-git-send-email-kishon@ti.com>
	<52DE7D75.4040302@ti.com>
Date: Wed, 22 Jan 2014 11:34:45 +0530
Message-ID: <CAFp+6iFkgD8x4DozhQdRSx=KLWGwR5pOsCxrVgWbcnCMTFT-sg@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] usb: dwc3: adapt dwc3 core to use Generic PHY Framework
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Roger Quadros <rogerq@ti.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, george.cherian@ti.com,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>,
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

Hi,


On Tue, Jan 21, 2014 at 7:30 PM, Roger Quadros <rogerq@ti.com> wrote:
> Hi Kishon,
>
> On 01/21/2014 12:11 PM, Kishon Vijay Abraham I wrote:
>> Adapted dwc3 core to use the Generic PHY Framework. So for init, exit,
>> power_on and power_off the following APIs are used phy_init(), phy_exit(),
>> phy_power_on() and phy_power_off().
>>
>> However using the old USB phy library wont be removed till the PHYs of all
>> other SoC's using dwc3 core is adapted to the Generic PHY Framework.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>> Changes from v3:
>> * avoided using quirks
>>
>>  Documentation/devicetree/bindings/usb/dwc3.txt |    6 ++-
>>  drivers/usb/dwc3/core.c                        |   60 ++++++++++++++++++++++++
>>  drivers/usb/dwc3/core.h                        |    7 +++
>>  3 files changed, 71 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/usb/dwc3.txt b/Documentation/devicetree/bindings/usb/dwc3.txt
>> index e807635..471366d 100644
>> --- a/Documentation/devicetree/bindings/usb/dwc3.txt
>> +++ b/Documentation/devicetree/bindings/usb/dwc3.txt
>> @@ -6,11 +6,13 @@ Required properties:
>>   - compatible: must be "snps,dwc3"
>>   - reg : Address and length of the register set for the device
>>   - interrupts: Interrupts used by the dwc3 controller.
>> +
>> +Optional properties:
>>   - usb-phy : array of phandle for the PHY device.  The first element
>>     in the array is expected to be a handle to the USB2/HS PHY and
>>     the second element is expected to be a handle to the USB3/SS PHY
>> -
>> -Optional properties:
>> + - phys: from the *Generic PHY* bindings
>> + - phy-names: from the *Generic PHY* bindings
>>   - tx-fifo-resize: determines if the FIFO *has* to be reallocated.
>>
>>  This is usually a subnode to DWC3 glue to which it is connected.
>> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
>> index e009d4e..036d589 100644
>> --- a/drivers/usb/dwc3/core.c
>> +++ b/drivers/usb/dwc3/core.c
>> @@ -82,6 +82,11 @@ static void dwc3_core_soft_reset(struct dwc3 *dwc)
>>
>>       usb_phy_init(dwc->usb2_phy);
>>       usb_phy_init(dwc->usb3_phy);
>> +     if (dwc->usb2_generic_phy)
>> +             phy_init(dwc->usb2_generic_phy);
>
> What if phy_init() fails? You need to report and fail. Same applies for all PHY apis in this patch.
>
>> +     if (dwc->usb3_generic_phy)
>> +             phy_init(dwc->usb3_generic_phy);
>> +
>>       mdelay(100);
>>
>>       /* Clear USB3 PHY reset */
>> @@ -343,6 +348,11 @@ static void dwc3_core_exit(struct dwc3 *dwc)
>>  {
>>       usb_phy_shutdown(dwc->usb2_phy);
>>       usb_phy_shutdown(dwc->usb3_phy);
>> +     if (dwc->usb2_generic_phy)
>> +             phy_exit(dwc->usb2_generic_phy);
>> +     if (dwc->usb3_generic_phy)
>> +             phy_exit(dwc->usb3_generic_phy);
>> +
>>  }
>>
>>  #define DWC3_ALIGN_MASK              (16 - 1)
>> @@ -433,6 +443,32 @@ static int dwc3_probe(struct platform_device *pdev)
>>               }
>>       }
>>
>> +     dwc->usb2_generic_phy = devm_phy_get(dev, "usb2-phy");
>> +     if (IS_ERR(dwc->usb2_generic_phy)) {
>> +             ret = PTR_ERR(dwc->usb2_generic_phy);
>> +             if (ret == -ENOSYS || ret == -ENODEV) {
>> +                     dwc->usb2_generic_phy = NULL;
>> +             } else if (ret == -EPROBE_DEFER) {
>> +                     return ret;
>> +             } else {
>> +                     dev_err(dev, "no usb2 phy configured\n");
>> +                     return ret;
>> +             }
>> +     }
>> +
>> +     dwc->usb3_generic_phy = devm_phy_get(dev, "usb3-phy");
>> +     if (IS_ERR(dwc->usb3_generic_phy)) {
>> +             ret = PTR_ERR(dwc->usb3_generic_phy);
>> +             if (ret == -ENOSYS || ret == -ENODEV) {
>> +                     dwc->usb3_generic_phy = NULL;
>> +             } else if (ret == -EPROBE_DEFER) {
>> +                     return ret;
>> +             } else {
>> +                     dev_err(dev, "no usb3 phy configured\n");
>> +                     return ret;
>> +             }
>> +     }
>> +
>>       dwc->xhci_resources[0].start = res->start;
>>       dwc->xhci_resources[0].end = dwc->xhci_resources[0].start +
>>                                       DWC3_XHCI_REGS_END;
>> @@ -482,6 +518,11 @@ static int dwc3_probe(struct platform_device *pdev)
>>       usb_phy_set_suspend(dwc->usb2_phy, 0);
>>       usb_phy_set_suspend(dwc->usb3_phy, 0);
>>
>> +     if (dwc->usb2_generic_phy)
>> +             phy_power_on(dwc->usb2_generic_phy);
>> +     if (dwc->usb3_generic_phy)
>> +             phy_power_on(dwc->usb3_generic_phy);
>> +
>
> Is it OK to power on the phy before phy_init()?

Isn't phy_init() being done before phy_power_on() in the
core_soft_reset() in this patch ?
Isn't that what you want here ?

>
> I suggest to move phy_init() from core_soft_reset() to here, just before phy_power_on().

core_soft_reset() is called before phy_power_on() itself from
dwc3_core_init(), right ?
will moving the phy_inti() here make nay difference ?

>
>>       ret = dwc3_event_buffers_setup(dwc);
>>       if (ret) {
>>               dev_err(dwc->dev, "failed to setup event buffers\n");
[...]
snip


-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
