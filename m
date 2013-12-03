Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab3LCCqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 21:46:45 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:58463 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705Ab3LCCqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 21:46:39 -0500
Message-ID: <529D4607.9080709@gtsys.com.hk>
Date: Tue, 03 Dec 2013 10:46:31 +0800
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11 ThunderBrowse/3.8
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] usb: phy-generic: Add ULPI VBUS support
References: <1385967919-13258-1-git-send-email-chris.ruehl@gtsys.com.hk> <1385967919-13258-4-git-send-email-chris.ruehl@gtsys.com.hk> <20131202182204.GQ12952@e106331-lin.cambridge.arm.com>
In-Reply-To: <20131202182204.GQ12952@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 03, 2013 02:22 AM, Mark Rutland wrote:
> On Mon, Dec 02, 2013 at 07:05:19AM +0000, Chris Ruehl wrote:
>> usb: phy-generic: Add ULPI VBUS support
>>
>> Some platforms need to set the VBUS parameters of the ULPI
>> like ISP1504 which interact with overcurrent protection and
>> power switch MIC2575. Therefore it requires to set
>> * DRVVBUS
>> * DRVVBUS_EXT
>> * EXTVBUSIND
>> * CHRGVBUS
>> of the ULPI.
>> This patch add support for it.
>
> Could you elaborate on when we need to do this and why?

Hi Mark,

If the parameters not set properly for this kind of board design
(ULPI + MIC) the 5V USB power is unstable and result errors while detecting and
running a usb-device.

>
>>
>> Devicetree configuration example:
>>
>> usbphy0: usbphy@0x10024170 {
>>   compatible = "usb-nop-xceiv";
>>   reg =<0x10024170 0x4>; /* ULPI Viewport OTG */
>>   clocks =<&clks 75>;
>>   clock-names = "main_clk";
>> };
>>
>> &usbphy0 {
>>          reset-gpios =<&gpio1 31 1>;
>>          pinctrl-names = "default";
>>          pinctrl-0 =<&pinctrl_usbphy0&pinctrl_usbotg1>;
>>          ulpi_set_vbus =<0x0f>;
>> };
>>
>> Please refer to the phy-bindings.txt for the value of ulpi_set_vbus commit
>> with this patch.
>>
>> Signed-off-by: Chris Ruehl<chris.ruehl@gtsys.com.hk>
>> ---
>>   .../devicetree/bindings/phy/phy-bindings.txt       |   15 ++++++
>>   drivers/usb/phy/phy-generic.c                      |   50 +++++++++++++++++++-
>>   drivers/usb/phy/phy-generic.h                      |    3 ++
>>   3 files changed, 67 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/devicetree/bindings/phy/phy-bindings.txt b/Documentation/devicetree/bindings/phy/phy-bindings.txt
>> index 8ae844f..b109b2f 100644
>> --- a/Documentation/devicetree/bindings/phy/phy-bindings.txt
>> +++ b/Documentation/devicetree/bindings/phy/phy-bindings.txt
>> @@ -34,6 +34,18 @@ phys : the phandle for the PHY device (used by the PHY subsystem)
>>   phy-names : the names of the PHY corresponding to the PHYs present in the
>>   	    *phys* phandle
>>
>> +Optional Properties:
>> +reset-gpios :	GPIO used to reset ULPI like ISP1504 with
>> +		0 = reset active high ; 1 = reset active low.
>
> The format of the gpio-specifier doesn't matter here.

I write this description because its takes me half a day to figure out that
the gpio definition must set <&gpioX num 1> to activate low rather then
<&gpioX num 0> which is active high! Only want to give people a hand. I don't
mind if you want to truncate it to:

reset-gpios :	GPIO used to reset ULPI
cs-gpios:	GPIO used to select a ULPI chipset

>
> Why do you need to mention the ISP1504? Either this is generic, or it
> doesn't belong here.
>
> Perhaps we need a ulpi-phy binding document. This and the rest of the
> patch is strongly tied to ULPI.


>
>> +cs-gpios :	GPIO used to activate a ULPI like ISP1504 with
>> +		0 = reset acitive high; 1 = reset active low.
>
> Again, the format of the gpio-specifier is not a concern here. I'm also
> a little confused as to the name "cs-gpios" for something that activates
> the ULPI.
>
>> +ulpi_set_vbus :	ULPI configuation parameter to program the VBUS signaling of
>> +		ISP1504 or similar chipsets.
>
> Could you elaborate on this? Is this applicable to any ULPI PHY? The
> description implies that it's somewhat tied to ISP1504 (if it's not,
> drop the mention of ISP1504).
>
> Why exactly do we need this, and why should it live in the DT?
>
> Why can se not figure this out automatically, or have defaults that work
> in more places?

We talk about board specific design, some designs need to set the VBUS flags 
others not, but its all run on the same generic kernel functions. FMHO this is
exactly what DT is designed for. The problem is how to encode the VBUS setup
a) easy to understand
b) easy to decode in the code

Drivers like phy-tegra-usb using there own hard coded ulpi setup, I think this
patch offers a way to work with the phy-generic.

>
> Also, s/_/-/ on property names please.

got it.

>
>> +		Set the parameter:
>> +		DRVVBUS = (1) DRVVBUS_EXT = (1<<1) EXTVBUSIND = (1<<2) CHRGVBUS = (1<<3)
>> +		eg: DRVVBUS | DRVVBUS_EXT = 0x03
>> +		    ulpi_set_vbus =<0x03>
>
> I don't like putting arbitrary bitfields like this in DT. They're
> illegible and easy to abuse

Sorry, but for the pinctrl (e.g fsl,imx27-pinctrl.txt) its done this way too, 
and for the code logic its becomes very simple. A solution with Boolean
ulpi-set-drvvbus
..
ulpi-set-chrgvbus
result in much more code in the kernel, by four times calling 
of_property_read_bool() vs. one time of_property_read_u32()
and the overhead the logic to encode it into a u32.

>
> Boolean properties are nicer for flags.
>
> What exactly do these flags mean?

The flags names related to the phy-ulpi.c used names ULPI_OTG_DRVVBUS ...
DRVVBUS 	enables the general logic for USB-VBUS in the ULPI
DRVVBUS_EXT	enables the external power out
DRVBUSIND	enables the logic for overcurrent protection and fault detection
CHRGVBUS 	enables the pump to stabilize the 5V output power level

>
> [...]
>
>> @@ -253,14 +284,15 @@ static int usb_phy_gen_xceiv_probe(struct platform_device *pdev)
>>
>>   	if (dev->of_node) {
>>   		struct device_node *node = dev->of_node;
>> +		struct resource	*res;
>>   		enum of_gpio_flags flags;
>>   		enum of_gpio_flags csflags;
>> +		u32 ulpi_vbus;
>>
>>   		if (of_property_read_u32(node, "clock-frequency",&clk_rate))
>>   			clk_rate = 0;
>>
>>   		needs_vcc = of_property_read_bool(node, "vcc-supply");
>> -
>>   		nop->gpio_reset = of_get_named_gpio_flags(node, "reset-gpios",
>>   								0,&flags);
>
> Why the random line deletion?

Ups that's should be happen while I had a earlier release.. I missed it.

>
>>
>> @@ -274,6 +306,22 @@ static int usb_phy_gen_xceiv_probe(struct platform_device *pdev)
>>   		if (gpio_is_valid(nop->gpio_chipselect))
>>   			nop->cs_active_low = csflags&  OF_GPIO_ACTIVE_LOW;
>>
>> +		err = of_property_read_u32(node, "ulpi_set_vbus",&ulpi_vbus);
add spaces here
>> +		if (err) {
>> +			nop->ulpi_vbus = -1;
>> +			nop->viewport = NULL;

>> +			ulpi_vbus = 0;
remove this its unused

>> +		} else {
>> +			dev_dbg(dev,"ULPI ulpi_set_vbus 0x%02x",ulpi_vbus);
add spaces here
>> +			nop->ulpi_vbus = ulpi_vbus;
>> +			res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>
> This wasn't described in the binding document, and it's ULPI specific. I

You right, we looking IORESOURCE_MEM for the ULPI-Viewport which I missed to 
mentioned.
The reg = <> for the current phy: phy@0 defines in the imx27.dtmi was unused.
1) I moved it to the AIPI2
2) merge them into the usb address range
to the the ULPI viewport available when needed.


> think we need a separate ulpi-phy binding that builds upon the generic
> one.
>
I agree with this.

> Thanks,
> Mark.

Thanks for the review.
Chris

> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
