Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424Ab3ARMLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 07:11:46 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:54407 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807Ab3ARMLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 07:11:44 -0500
Message-ID: <50F93BE8.9070904@ti.com>
Date: Fri, 18 Jan 2013 17:41:20 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <rob.herring@calxeda.com>, <rob@landley.net>, <tony@atomide.com>,
        <b-cousson@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <grant.likely@secretlab.ca>,
        <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4/4] drivers: usb: start using the control module driver
References: <1358502045-27008-1-git-send-email-kishon@ti.com> <1358502045-27008-5-git-send-email-kishon@ti.com> <20130118120256.GC4672@arwen.pp.htv.fi>
In-Reply-To: <20130118120256.GC4672@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013 05:32 PM, Felipe Balbi wrote:
> Hi,
>
> On Fri, Jan 18, 2013 at 03:10:45PM +0530, Kishon Vijay Abraham I wrote:
>> Start using the control module driver for powering on the PHY and for
>> writing to the mailbox instead of writing to the control module
>> registers on their own.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>   Documentation/devicetree/bindings/usb/omap-usb.txt |    4 ++
>>   Documentation/devicetree/bindings/usb/usb-phy.txt  |    7 +--
>>   arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |   13 ----
>>   drivers/usb/musb/Kconfig                           |    1 +
>>   drivers/usb/musb/omap2430.c                        |   64 ++++++++------------
>>   drivers/usb/musb/omap2430.h                        |    9 ---
>>   drivers/usb/phy/Kconfig                            |    1 +
>>   drivers/usb/phy/omap-usb2.c                        |   38 +++---------
>>   include/linux/usb/omap_usb.h                       |    4 +-
>>   9 files changed, 42 insertions(+), 99 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Documentation/devicetree/bindings/usb/omap-usb.txt
>> index ead6ba9..8bedbba 100644
>> --- a/Documentation/devicetree/bindings/usb/omap-usb.txt
>> +++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
>> @@ -3,6 +3,9 @@ OMAP GLUE AND OTHER OMAP SPECIFIC COMPONENTS
>>   OMAP MUSB GLUE
>>    - compatible : Should be "ti,omap4-musb" or "ti,omap3-musb"
>>    - ti,hwmods : must be "usb_otg_hs"
>> + - ti,has_mailbox : to specify that omap uses an external mailbox
>> +   (in control module) to communicate with the musb core during device connect
>> +   and disconnect.
>>    - multipoint : Should be "1" indicating the musb controller supports
>>      multipoint. This is a MUSB configuration-specific setting.
>>    - num_eps : Specifies the number of endpoints. This is also a
>> @@ -24,6 +27,7 @@ SOC specific device node entry
>>   usb_otg_hs: usb_otg_hs@4a0ab000 {
>>   	compatible = "ti,omap4-musb";
>>   	ti,hwmods = "usb_otg_hs";
>> +	ti,has_mailbox;
>>   	multipoint = <1>;
>>   	num_eps = <16>;
>>   	ram_bits = <12>;
>> diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Documentation/devicetree/bindings/usb/usb-phy.txt
>> index 2466b6f..48761a2 100644
>> --- a/Documentation/devicetree/bindings/usb/usb-phy.txt
>> +++ b/Documentation/devicetree/bindings/usb/usb-phy.txt
>> @@ -4,9 +4,7 @@ OMAP USB2 PHY
>>
>>   Required properties:
>>    - compatible: Should be "ti,omap-usb2"
>> - - reg : Address and length of the register set for the device. Also
>> -add the address of control module dev conf register until a driver for
>> -control module is added
>> + - reg : Address and length of the register set for the device.
>>
>>   Optional properties:
>>    - ctrl_module : phandle of the control module used by PHY driver to power on
>> @@ -16,7 +14,6 @@ This is usually a subnode of ocp2scp to which it is connected.
>>
>>   usb2phy@4a0ad080 {
>>   	compatible = "ti,omap-usb2";
>> -	reg = <0x4a0ad080 0x58>,
>> -	      <0x4a002300 0x4>;
>> +	reg = <0x4a0ad080 0x58>;
>>   	ctrl_module = <&omap_control_usb>;
>>   };
>> diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
>> index 129d508..103f4ba 100644
>> --- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
>> +++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
>> @@ -2698,13 +2698,6 @@ static struct resource omap44xx_usb_phy_and_pll_addrs[] = {
>>   		.end		= 0x4a0ae000,
>>   		.flags		= IORESOURCE_MEM,
>>   	},
>> -	{
>> -		/* XXX: Remove this once control module driver is in place */
>> -		.name		= "ctrl_dev",
>> -		.start		= 0x4a002300,
>> -		.end		= 0x4a002303,
>> -		.flags		= IORESOURCE_MEM,
>> -	},
>>   	{ }
>>   };
>>
>> @@ -6152,12 +6145,6 @@ static struct omap_hwmod_addr_space omap44xx_usb_otg_hs_addrs[] = {
>>   		.pa_end		= 0x4a0ab7ff,
>>   		.flags		= ADDR_TYPE_RT
>>   	},
>> -	{
>> -		/* XXX: Remove this once control module driver is in place */
>> -		.pa_start	= 0x4a00233c,
>> -		.pa_end		= 0x4a00233f,
>> -		.flags		= ADDR_TYPE_RT
>> -	},
>>   	{ }
>>   };
>>
>> diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
>> index 23a0b7f..de6e5ce 100644
>> --- a/drivers/usb/musb/Kconfig
>> +++ b/drivers/usb/musb/Kconfig
>> @@ -11,6 +11,7 @@ config USB_MUSB_HDRC
>>   	select NOP_USB_XCEIV if (SOC_TI81XX || SOC_AM33XX)
>>   	select TWL4030_USB if MACH_OMAP_3430SDP
>>   	select TWL6030_USB if MACH_OMAP_4430SDP || MACH_OMAP4_PANDA
>> +	select OMAP_CONTROL_USB if MACH_OMAP_4430SDP || MACH_OMAP4_PANDA
>>   	select USB_OTG_UTILS
>>   	help
>>   	  Say Y here if your system has a dual role high speed USB
>> diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
>> index da00af4..3e7ceef 100644
>> --- a/drivers/usb/musb/omap2430.c
>> +++ b/drivers/usb/musb/omap2430.c
>> @@ -37,6 +37,7 @@
>>   #include <linux/err.h>
>>   #include <linux/delay.h>
>>   #include <linux/usb/musb-omap.h>
>> +#include <linux/usb/omap_control_usb.h>
>>
>>   #include "musb_core.h"
>>   #include "omap2430.h"
>> @@ -46,7 +47,7 @@ struct omap2430_glue {
>>   	struct platform_device	*musb;
>>   	enum omap_musb_vbus_id_status status;
>>   	struct work_struct	omap_musb_mailbox_work;
>> -	u32 __iomem		*control_otghs;
>> +	struct device		*control_otghs;
>>   };
>>   #define glue_to_musb(g)		platform_get_drvdata(g->musb)
>>
>> @@ -54,26 +55,6 @@ struct omap2430_glue		*_glue;
>>
>>   static struct timer_list musb_idle_timer;
>>
>> -/**
>> - * omap4_usb_phy_mailbox - write to usb otg mailbox
>> - * @glue: struct omap2430_glue *
>> - * @val: the value to be written to the mailbox
>> - *
>> - * On detection of a device (ID pin is grounded), this API should be called
>> - * to set AVALID, VBUSVALID and ID pin is grounded.
>> - *
>> - * When OMAP is connected to a host (OMAP in device mode), this API
>> - * is called to set AVALID, VBUSVALID and ID pin in high impedance.
>> - *
>> - * XXX: This function will be removed once we have a seperate driver for
>> - * control module
>> - */
>> -static void omap4_usb_phy_mailbox(struct omap2430_glue *glue, u32 val)
>> -{
>> -	if (glue->control_otghs)
>> -		writel(val, glue->control_otghs);
>> -}
>> -
>>   static void musb_do_idle(unsigned long _musb)
>>   {
>>   	struct musb	*musb = (void *)_musb;
>> @@ -269,7 +250,6 @@ EXPORT_SYMBOL_GPL(omap_musb_mailbox);
>>
>>   static void omap_musb_set_mailbox(struct omap2430_glue *glue)
>>   {
>> -	u32 val;
>>   	struct musb *musb = glue_to_musb(glue);
>>   	struct device *dev = musb->controller;
>>   	struct musb_hdrc_platform_data *pdata = dev->platform_data;
>> @@ -285,8 +265,8 @@ static void omap_musb_set_mailbox(struct omap2430_glue *glue)
>>   		musb->xceiv->last_event = USB_EVENT_ID;
>>   		if (musb->gadget_driver) {
>>   			pm_runtime_get_sync(dev);
>> -			val = AVALID | VBUSVALID;
>> -			omap4_usb_phy_mailbox(glue, val);
>> +			if (!IS_ERR(glue->control_otghs))
>> +				omap_control_usb_host_mode(glue->control_otghs);
>
> you could introduce a helper to do the checks for you. something like:
>
> static inline void omap_control_set_mode(*ctrl, int mode)
> {
> 	if (IS_ERR(glue->control_otghs))
> 		return;
>
> 	switch (mode) {
> 	case HOST:
> 		omap_control_usb_host_mode(ctrl);
> 		break;
> 	case DEVICE:
> 		omap_control_usb_device(ctrl)
> 		break;
> 	default:
> 		meh();
> 	}
> }
>
> likewise for power() method

Ok.

Thanks
Kishon
