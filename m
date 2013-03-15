Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab3COJXC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 05:23:02 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39928 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965Ab3COJXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 05:23:00 -0400
Message-ID: <5142E86C.90805@ti.com>
Date: Fri, 15 Mar 2013 11:22:52 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <balbi@ti.com>, <b-cousson@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 00/24] ARM: OMAP2+: Adapt to ehci-omap changes for 3.10
References: <1363088606-2692-1-git-send-email-rogerq@ti.com> <20130312164007.GZ26093@atomide.com> <5140821B.2030902@ti.com> <20130313162454.GE26093@atomide.com> <5140AAFD.4080508@ti.com> <20130313165729.GF26093@atomide.com> <5141EFAE.2040809@ti.com> <20130314165440.GG26093@atomide.com>
In-Reply-To: <20130314165440.GG26093@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2013 06:54 PM, Tony Lindgren wrote:
> * Roger Quadros <rogerq@ti.com> [130314 08:45]:
>>
>> OK. Let me know how the below patch looks. After that, the board code
>> will look like.
>>
>> static struct usbhs_phy_data phy_data[] = {
>> 	{
>> 		.reset_gpio = 147,
>> 		.vcc_gpio = 148
>> 		.vcc_polarity = 1,
>> 		.phy_id = "nop_usb_xceiv.2",
>> 	},
>> 	{}, /* Terminator */
>> };
>>
>> usbhs_init_phys(phy_data);
> 
> Great, looks good to me.
>  
>> Patch to implement usbhs_init_phys();
>>
>> diff --git a/arch/arm/mach-omap2/usb-host.c b/arch/arm/mach-omap2/usb-host.c
>> index 5706bdc..b9d6bff 100644
>> --- a/arch/arm/mach-omap2/usb-host.c
>> +++ b/arch/arm/mach-omap2/usb-host.c
>> @@ -22,8 +22,12 @@
>>  #include <linux/platform_device.h>
>>  #include <linux/slab.h>
>>  #include <linux/dma-mapping.h>
>> +#include <linux/regulator/machine.h>
>> +#include <linux/regulator/fixed.h>
>> +#include <linux/string.h>
>>  
>>  #include <asm/io.h>
>> +#include <asm/gpio.h>
> 
> Please change these both to linux/io.h and linux/gpio.h.

OK.

>   
>>  #include "soc.h"
>>  #include "omap_device.h"
>> @@ -472,6 +476,141 @@ void __init setup_4430ohci_io_mux(const enum usbhs_omap_port_mode *port_mode)
>>  	}
>>  }
>>  
>> +static const char *reset_supply = "reset";
>> +static const char *vcc_supply = "vcc";
>> +
>> +/* Template for PHY regulators */
>> +static struct regulator_consumer_supply hsusb_reg_supplies[] = {
>> +	{ /* .supply & .dev_name filled later */ },
>> +};
>> +
>> +static struct regulator_init_data hsusb_reg_data = {
>> +	.constraints = {
>> +		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
>> +	},
>> +	.consumer_supplies	= hsusb_reg_supplies,
>> +	.num_consumer_supplies	= ARRAY_SIZE(hsusb_reg_supplies),
>> +};
>> +
>> +static struct fixed_voltage_config hsusb_reg_config = {
>> +	/* .supply_name filled later */
>> +	.microvolts = 3300000,
>> +	.gpio = -1,		/* updated later */
>> +	.startup_delay = 70000, /* 70msec */
>> +	.enable_high = 1,	/* updated later */
>> +	.enabled_at_boot = 0,	/* keep in RESET */
>> +	/* .init_data filled later */
>> +};
>> +
>> +static struct platform_device_info hsusb_reg_pdev_info = {
>> +	.name	= "reg-fixed-voltage",
>> +	.id	= PLATFORM_DEVID_AUTO,
>> +};
>> +
>> +int __init usbhs_init_phys(struct usbhs_phy_data *phy)
>> +{
>> +	struct regulator_consumer_supply *supplies;
>> +	struct regulator_init_data *reg_data;
>> +	struct fixed_voltage_config *config;
>> +	char *supply_name;
>> +	int i;
>> +
>> +
>> +	for (i = 1; i <= OMAP3_HS_USB_PORTS; i++) {
> 
> Maybe pass the number of ports to initialize too to the
> function? Might be more future proof, although it will only
> be needed until we have converted to DT.
> 

OK. I'll add a port index parameter to the usbhs_phy_data structure
to indicate which port the data belongs to and a number of ports
to usbhs_init_phys()

board code can then do

static struct usbhs_phy_data phy_data[] = {
	{
		.port = 1,	/* First USB port */
		.reset_gpio = 147,
		.vcc_gpio = 148
		.vcc_polarity = 1,
		.phy_id = "nop_usb_xceiv.2",
	},
};

usbhs_init_phys(phy_data, ARRAY_SIZE(phy_data));

>> +
>> +		if (!phy->phy_id)	/* Terminator ? */
>> +			break;
>> +
>> +		if (!gpio_is_valid(phy->reset_gpio))
>> +			goto check_vcc;
>> +
>> +		supplies = kmemdup(hsusb_reg_supplies,
>> +			    ARRAY_SIZE(hsusb_reg_supplies) *
>> +			    sizeof(struct regulator_consumer_supply),
>> +			    GFP_KERNEL);
>> +		if (!supplies)
>> +			return -ENOMEM;
>> +
>> +		supplies->supply = reset_supply;
>> +		supplies->dev_name = phy->phy_id;
>> +
>> +		reg_data = kmemdup(&hsusb_reg_data, sizeof(hsusb_reg_data),
>> +							GFP_KERNEL);
>> +		if (!reg_data)
>> +			return -ENOMEM;
>> +
>> +		reg_data->consumer_supplies = supplies;
>> +
>> +		config = kmemdup(&hsusb_reg_config, sizeof(hsusb_reg_config),
>> +							GFP_KERNEL);
>> +		if (!config)
>> +			return -ENOMEM;
>> +
>> +		supply_name = kmalloc(14, GFP_KERNEL);
>> +		if (!supply_name)
>> +			return -ENOMEM;
>> +
>> +		scnprintf(supply_name, 13, "hsusb%d_reset", i);
>> +		config->supply_name = supply_name;
>> +		config->gpio = phy->reset_gpio;
>> +		config->init_data = reg_data;
>> +
>> +		hsusb_reg_pdev_info.data = config;
>> +		hsusb_reg_pdev_info.size_data = sizeof(hsusb_reg_config);
>> +		platform_device_register_full(&hsusb_reg_pdev_info);
>> +
>> +check_vcc:
>> +		if (!gpio_is_valid(phy->vcc_gpio))
>> +			goto next;
>> +
>> +		supplies = kmemdup(hsusb_reg_supplies,
>> +			    ARRAY_SIZE(hsusb_reg_supplies) *
>> +			    sizeof(struct regulator_consumer_supply),
>> +			    GFP_KERNEL);
>> +		if (!supplies)
>> +			return -ENOMEM;
>> +
>> +		supplies->supply = vcc_supply;
>> +		supplies->dev_name = phy->phy_id;
>> +
>> +		reg_data = kmemdup(&hsusb_reg_data, sizeof(hsusb_reg_data),
>> +							GFP_KERNEL);
>> +		if (!reg_data)
>> +			return -ENOMEM;
>> +
>> +		reg_data->consumer_supplies = supplies;
>> +
>> +		config = kmemdup(&hsusb_reg_config, sizeof(hsusb_reg_config),
>> +							GFP_KERNEL);
>> +		if (!config)
>> +			return -ENOMEM;
>> +
>> +		supply_name = kmalloc(14, GFP_KERNEL);
>> +		if (!supply_name)
>> +			return -ENOMEM;
>> +
>> +		scnprintf(supply_name, 13, "hsusb%d_vcc", i);
>> +		config->supply_name = supply_name;
>> +		config->gpio = phy->vcc_gpio;
>> +		config->enable_high = phy->vcc_polarity;
>> +		config->init_data = reg_data;
>> +
>> +		hsusb_reg_pdev_info.data = config;
>> +		hsusb_reg_pdev_info.size_data = sizeof(hsusb_reg_config);
>> +		platform_device_register_full(&hsusb_reg_pdev_info);
>> +
>> +next:
>> +		phy++;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>  void __init usbhs_init(struct usbhs_omap_platform_data *pdata)
>>  {
>>  	struct omap_hwmod	*uhh_hwm, *tll_hwm;
>> diff --git a/arch/arm/mach-omap2/usb.h b/arch/arm/mach-omap2/usb.h
>> index 3319f5c..70a8c63 100644
>> --- a/arch/arm/mach-omap2/usb.h
>> +++ b/arch/arm/mach-omap2/usb.h
>> @@ -53,8 +53,16 @@
>>  #define USBPHY_OTGSESSEND_EN	(1 << 20)
>>  #define USBPHY_DATA_POLARITY	(1 << 23)
>>  
>> +struct usbhs_phy_data {
>> +	int reset_gpio;
>> +	int vcc_gpio;
>> +	bool vcc_polarity;	/* 1 active high, 0 active low */
>> +	char *phy_id;
>> +};
>> +
>>  extern void usb_musb_init(struct omap_musb_board_data *board_data);
>>  extern void usbhs_init(struct usbhs_omap_platform_data *pdata);
>> +extern int usbhs_init_phys(struct usbhs_phy_data *phy);
> 
> Maybe need a static inline version when no EHCI is selected?
> 
Yes.

> Otherwise looks good to me, thanks for updating it.
> 

Cool. I'll update all boards and send it to you soon.

cheers,
-roger
