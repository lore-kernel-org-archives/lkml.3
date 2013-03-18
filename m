Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab3CRMm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 08:42:26 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43993 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab3CRMmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 08:42:24 -0400
Message-ID: <51470BA9.1070902@ti.com>
Date: Mon, 18 Mar 2013 14:42:17 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <balbi@ti.com>, <linux-omap@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v2 06/23] ARM: OMAP3: 3430SDP: Adapt to ehci-omap changes
References: <1363360604-21368-1-git-send-email-rogerq@ti.com> <1363360604-21368-7-git-send-email-rogerq@ti.com> <20130315161201.GA9370@atomide.com>
In-Reply-To: <20130315161201.GA9370@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2013 06:12 PM, Tony Lindgren wrote:
> Hi,
> 
> I think you can get rid of quite a bit more of the repeated data for
> most boards, see below.
> 
> * Roger Quadros <rogerq@ti.com> [130315 08:21]:
>> Add 2 platform devices for 'nop-usb-xceiv'. These will be used
>> as PHYs for HS USB ports 1 and 2 so provide binding information
>> for them.
>>
>> Use usbhs_init_phys() to register the PHY's RESET regulators.
>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> ---
>>  arch/arm/mach-omap2/board-3430sdp.c |   47 ++++++++++++++++++++++++++++++----
>>  1 files changed, 41 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/board-3430sdp.c b/arch/arm/mach-omap2/board-3430sdp.c
>> index ce812de..5584682 100644
>> --- a/arch/arm/mach-omap2/board-3430sdp.c
>> +++ b/arch/arm/mach-omap2/board-3430sdp.c
>> @@ -21,6 +21,7 @@
>>  #include <linux/spi/spi.h>
>>  #include <linux/i2c/twl.h>
>>  #include <linux/regulator/machine.h>
>> +#include <linux/usb/phy.h>
>>  #include <linux/io.h>
>>  #include <linux/gpio.h>
>>  #include <linux/mmc/host.h>
>> @@ -445,16 +446,37 @@ static void enable_board_wakeup_source(void)
>>  		OMAP_WAKEUP_EN | OMAP_PIN_INPUT_PULLUP);
>>  }
>>  
>> +/* PHY device on HS USB Port 1 i.e. nop_usb_xceiv.1 */
>> +static struct platform_device hsusb1_phy_device = {
>> +	.name = "nop_usb_xceiv",
>> +	.id = 1,
>> +};
>> +
>> +/* PHY device on HS USB Port 2 i.e. nop_usb_xceiv.2 */
>> +static struct platform_device hsusb2_phy_device = {
>> +	.name = "nop_usb_xceiv",
>> +	.id = 2,
>> +};
> 
> Please allocate these in the common ehci platform init code
> so you don't have to repeat the same nop_usb_xceiv for each
> board-*.c file. If you need to override these, then you can
> pass something instead of NULL to the init function.

OK. I think there is nothing to be overridden except the
platform_data. But that I can pass into via phy_data structure below.

> 
>> +static struct usbhs_phy_data phy_data[] __initdata = {
>> +	{
>> +		.port = 1,
>> +		.reset_gpio = 57,
>> +		.vcc_gpio = -EINVAL,
>> +		.phy_id = "nop_usb_xceiv.1",
>> +	},
>> +	{
>> +		.port = 2,
>> +		.reset_gpio = 61,
>> +		.vcc_gpio = -EINVAL,
>> +		.phy_id = "nop_usb_xceiv.2",
>> +	},
>> +};
> 
> This is OK as it's the board specific data needed. If it's the
> same for many boards, then you might want to add some init function
> for the default case.

To keep it simple I'll leave this the way it is. There is nothing
much that can be kept common. If reset_gpio and vcc_gpio is not used
then the data structure is not required at all.

> 
>> +static struct platform_device *sdp3430_devices[] __initdata = {
>> +	&hsusb1_phy_device,
>> +	&hsusb2_phy_device,
>> +};
> 
> It then seems that this can be in the common ehci platform init
> code for most cases.

OK.

> 
>>  static void __init omap_3430sdp_init(void)
>>  {
>>  	int gpio_pendown;
>> @@ -606,6 +633,14 @@ static void __init omap_3430sdp_init(void)
>>  	board_flash_init(sdp_flash_partitions, chip_sel_3430, 0);
>>  	sdp3430_display_init();
>>  	enable_board_wakeup_source();
>> +
>> +	platform_add_devices(sdp3430_devices, ARRAY_SIZE(sdp3430_devices));
>> +	/* PHY on HSUSB Port 1 i.e. index 0 */
>> +	usb_bind_phy("ehci-omap.0", 0, "nop_usb_xceiv.1");
>> +	/* PHY on HSUSB Port 2 i.e. index 1 */
>> +	usb_bind_phy("ehci-omap.0", 1, "nop_usb_xceiv.2");
> 
> And this part too in most cases.

Yes.

> 
>> +	usbhs_init_phys(phy_data, ARRAY_SIZE(phy_data));
>>  	usbhs_init(&usbhs_bdata);
>>  }
> 

cheers,
-roger

