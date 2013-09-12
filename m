Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002Ab3ILKLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 06:11:13 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48783 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210Ab3ILKLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 06:11:08 -0400
Message-ID: <52319300.6040509@ti.com>
Date: Thu, 12 Sep 2013 15:40:08 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Vivek Gautam <gautamvivek1987@gmail.com>
CC: <rogerq@ti.com>, Felipe Balbi <balbi@ti.com>, <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>, <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        <george.cherian@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        <linux-doc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] usb: dwc3: adapt dwc3 core to use Generic PHY Framework
References: <1378136591-7463-1-git-send-email-kishon@ti.com> <1378136591-7463-3-git-send-email-kishon@ti.com> <CAFp+6iH7AbiJrVg-8hhv+21OyLp0cPEH0RdMh5tzTT+W_ifPDQ@mail.gmail.com>
In-Reply-To: <CAFp+6iH7AbiJrVg-8hhv+21OyLp0cPEH0RdMh5tzTT+W_ifPDQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 September 2013 02:57 PM, Vivek Gautam wrote:
> Hi Kishon,
> 
> 
> On Mon, Sep 2, 2013 at 9:13 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>> Adapted dwc3 core to use the Generic PHY Framework. So for init, exit,
>> power_on and power_off the following APIs are used phy_init(), phy_exit(),
>> phy_power_on() and phy_power_off().
>>
>> However using the old USB phy library wont be removed till the PHYs of all
>> other SoC's using dwc3 core is adapted to the Generic PHY Framework.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>  Documentation/devicetree/bindings/usb/dwc3.txt |    6 ++-
>>  drivers/usb/dwc3/Kconfig                       |    1 +
>>  drivers/usb/dwc3/core.c                        |   49 ++++++++++++++++++++++++
>>  drivers/usb/dwc3/core.h                        |    7 ++++
>>  4 files changed, 61 insertions(+), 2 deletions(-)
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
>> diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
>> index cfc16dd..ad7ce83 100644
>> --- a/drivers/usb/dwc3/Kconfig
>> +++ b/drivers/usb/dwc3/Kconfig
>> @@ -3,6 +3,7 @@ config USB_DWC3
>>         depends on (USB || USB_GADGET) && GENERIC_HARDIRQS && HAS_DMA
>>         depends on EXTCON
>>         select USB_PHY
>> +       select GENERIC_PHY
>>         select USB_XHCI_PLATFORM if USB_SUPPORT && USB_XHCI_HCD
>>         help
>>           Say Y or M here if your system has a Dual Role SuperSpeed
>> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
>> index 428c29e..485d365 100644
>> --- a/drivers/usb/dwc3/core.c
>> +++ b/drivers/usb/dwc3/core.c
>> @@ -82,6 +82,12 @@ static void dwc3_core_soft_reset(struct dwc3 *dwc)
>>
>>         usb_phy_init(dwc->usb2_phy);
>>         usb_phy_init(dwc->usb3_phy);
>> +
>> +       if (dwc->usb2_generic_phy)
>> +               phy_init(dwc->usb2_generic_phy);
>> +       if (dwc->usb3_generic_phy)
>> +               phy_init(dwc->usb3_generic_phy);
>> +
>>         mdelay(100);
>>
>>         /* Clear USB3 PHY reset */
>> @@ -343,6 +349,11 @@ static void dwc3_core_exit(struct dwc3 *dwc)
>>  {
>>         usb_phy_shutdown(dwc->usb2_phy);
>>         usb_phy_shutdown(dwc->usb3_phy);
>> +
>> +       if (dwc->usb2_generic_phy)
>> +               phy_power_off(dwc->usb2_generic_phy);
>> +       if (dwc->usb3_generic_phy)
>> +               phy_power_off(dwc->usb3_generic_phy);
>>  }
>>
>>  #define DWC3_ALIGN_MASK                (16 - 1)
>> @@ -427,6 +438,23 @@ static int dwc3_probe(struct platform_device *pdev)
>>                 dwc->usb3_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB3);
>>         }
>>
>> +       if (of_property_read_bool(node, "phys") || pdata->has_phy) {
>> +               dwc->usb2_generic_phy = devm_phy_get(dev, "usb2-phy");
>> +               if (IS_ERR(dwc->usb2_generic_phy)) {
>> +                       dev_err(dev, "no usb2 phy configured yet");
>> +                       return PTR_ERR(dwc->usb2_generic_phy);
>> +               }
> 
> I have a doubt here.
> As i can see in the current phy drivers structuring, for OMAP there
> are two phy drivers :
> omap phy-omap-usb2 (talking to musb controller)

It talks to dwc3 controller also ;-)

> and phy-omap-usb3(talking to dwc3 controller).
> 
> Now dwc3 controller requests both usb2-phy (supported by phy-omap-usb2
> ?) and usb3-phy (supported by phy-omap-usb3 ?).
> But phy-omap-usb2 is not the one designated to talk to DWC3
> controller, then why does still DWC3 want to request usb2-phy, which
> end of the day will be phy-omap-usb2.
> May be i am wrong here since i don't have knowledge about OMAP h/w architecture.
> 
> Is it like phy-omap-usb2 includes UTMI phys for both musb controller
> as well as dwc3 controller ?

right. It's needed for dwc3 too. The same USB2 PHY IP is used for both MUSB in
OMAP2+ platforms and DWC3 in OMAP5.

Thanks
Kishon
