Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbaAVIAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 03:00:24 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:57007 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaAVIAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 03:00:21 -0500
Message-ID: <52DF7A78.5030700@ti.com>
Date: Wed, 22 Jan 2014 09:59:52 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vivek Gautam <gautamvivek1987@gmail.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>, <george.cherian@ti.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v4 2/2] usb: dwc3: adapt dwc3 core to use Generic PHY
 Framework
References: <1385373690-12170-1-git-send-email-kishon@ti.com>	<1390299099-14764-1-git-send-email-kishon@ti.com>	<1390299099-14764-2-git-send-email-kishon@ti.com>	<52DE7D75.4040302@ti.com> <CAFp+6iFkgD8x4DozhQdRSx=KLWGwR5pOsCxrVgWbcnCMTFT-sg@mail.gmail.com>
In-Reply-To: <CAFp+6iFkgD8x4DozhQdRSx=KLWGwR5pOsCxrVgWbcnCMTFT-sg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2014 08:04 AM, Vivek Gautam wrote:
> Hi,
> 
> 
> On Tue, Jan 21, 2014 at 7:30 PM, Roger Quadros <rogerq@ti.com> wrote:
>> Hi Kishon,
>>
>> On 01/21/2014 12:11 PM, Kishon Vijay Abraham I wrote:
>>> Adapted dwc3 core to use the Generic PHY Framework. So for init, exit,
>>> power_on and power_off the following APIs are used phy_init(), phy_exit(),
>>> phy_power_on() and phy_power_off().
>>>
>>> However using the old USB phy library wont be removed till the PHYs of all
>>> other SoC's using dwc3 core is adapted to the Generic PHY Framework.
>>>
>>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>>> ---
>>> Changes from v3:
>>> * avoided using quirks
>>>
>>>  Documentation/devicetree/bindings/usb/dwc3.txt |    6 ++-
>>>  drivers/usb/dwc3/core.c                        |   60 ++++++++++++++++++++++++
>>>  drivers/usb/dwc3/core.h                        |    7 +++
>>>  3 files changed, 71 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/usb/dwc3.txt b/Documentation/devicetree/bindings/usb/dwc3.txt
>>> index e807635..471366d 100644
>>> --- a/Documentation/devicetree/bindings/usb/dwc3.txt
>>> +++ b/Documentation/devicetree/bindings/usb/dwc3.txt
>>> @@ -6,11 +6,13 @@ Required properties:
>>>   - compatible: must be "snps,dwc3"
>>>   - reg : Address and length of the register set for the device
>>>   - interrupts: Interrupts used by the dwc3 controller.
>>> +
>>> +Optional properties:
>>>   - usb-phy : array of phandle for the PHY device.  The first element
>>>     in the array is expected to be a handle to the USB2/HS PHY and
>>>     the second element is expected to be a handle to the USB3/SS PHY
>>> -
>>> -Optional properties:
>>> + - phys: from the *Generic PHY* bindings
>>> + - phy-names: from the *Generic PHY* bindings
>>>   - tx-fifo-resize: determines if the FIFO *has* to be reallocated.
>>>
>>>  This is usually a subnode to DWC3 glue to which it is connected.
>>> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
>>> index e009d4e..036d589 100644
>>> --- a/drivers/usb/dwc3/core.c
>>> +++ b/drivers/usb/dwc3/core.c
>>> @@ -82,6 +82,11 @@ static void dwc3_core_soft_reset(struct dwc3 *dwc)
>>>
>>>       usb_phy_init(dwc->usb2_phy);
>>>       usb_phy_init(dwc->usb3_phy);
>>> +     if (dwc->usb2_generic_phy)
>>> +             phy_init(dwc->usb2_generic_phy);
>>
>> What if phy_init() fails? You need to report and fail. Same applies for all PHY apis in this patch.
>>
>>> +     if (dwc->usb3_generic_phy)
>>> +             phy_init(dwc->usb3_generic_phy);
>>> +
>>>       mdelay(100);
>>>
>>>       /* Clear USB3 PHY reset */
>>> @@ -343,6 +348,11 @@ static void dwc3_core_exit(struct dwc3 *dwc)
>>>  {
>>>       usb_phy_shutdown(dwc->usb2_phy);
>>>       usb_phy_shutdown(dwc->usb3_phy);
>>> +     if (dwc->usb2_generic_phy)
>>> +             phy_exit(dwc->usb2_generic_phy);
>>> +     if (dwc->usb3_generic_phy)
>>> +             phy_exit(dwc->usb3_generic_phy);
>>> +
>>>  }
>>>
>>>  #define DWC3_ALIGN_MASK              (16 - 1)
>>> @@ -433,6 +443,32 @@ static int dwc3_probe(struct platform_device *pdev)
>>>               }
>>>       }
>>>
>>> +     dwc->usb2_generic_phy = devm_phy_get(dev, "usb2-phy");
>>> +     if (IS_ERR(dwc->usb2_generic_phy)) {
>>> +             ret = PTR_ERR(dwc->usb2_generic_phy);
>>> +             if (ret == -ENOSYS || ret == -ENODEV) {
>>> +                     dwc->usb2_generic_phy = NULL;
>>> +             } else if (ret == -EPROBE_DEFER) {
>>> +                     return ret;
>>> +             } else {
>>> +                     dev_err(dev, "no usb2 phy configured\n");
>>> +                     return ret;
>>> +             }
>>> +     }
>>> +
>>> +     dwc->usb3_generic_phy = devm_phy_get(dev, "usb3-phy");
>>> +     if (IS_ERR(dwc->usb3_generic_phy)) {
>>> +             ret = PTR_ERR(dwc->usb3_generic_phy);
>>> +             if (ret == -ENOSYS || ret == -ENODEV) {
>>> +                     dwc->usb3_generic_phy = NULL;
>>> +             } else if (ret == -EPROBE_DEFER) {
>>> +                     return ret;
>>> +             } else {
>>> +                     dev_err(dev, "no usb3 phy configured\n");
>>> +                     return ret;
>>> +             }
>>> +     }
>>> +
>>>       dwc->xhci_resources[0].start = res->start;
>>>       dwc->xhci_resources[0].end = dwc->xhci_resources[0].start +
>>>                                       DWC3_XHCI_REGS_END;
>>> @@ -482,6 +518,11 @@ static int dwc3_probe(struct platform_device *pdev)
>>>       usb_phy_set_suspend(dwc->usb2_phy, 0);
>>>       usb_phy_set_suspend(dwc->usb3_phy, 0);
>>>
>>> +     if (dwc->usb2_generic_phy)
>>> +             phy_power_on(dwc->usb2_generic_phy);
>>> +     if (dwc->usb3_generic_phy)
>>> +             phy_power_on(dwc->usb3_generic_phy);
>>> +
>>
>> Is it OK to power on the phy before phy_init()?
> 
> Isn't phy_init() being done before phy_power_on() in the
> core_soft_reset() in this patch ?
> Isn't that what you want here ?
> 
>>
>> I suggest to move phy_init() from core_soft_reset() to here, just before phy_power_on().
> 
> core_soft_reset() is called before phy_power_on() itself from
> dwc3_core_init(), right ?
> will moving the phy_inti() here make nay difference ?

You are right. This part is fine then.

cheers,
-roger
