Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935483AbaDJKc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:32:58 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:47509 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934795AbaDJKcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:32:53 -0400
MIME-Version: 1.0
In-Reply-To: <53465FB9.7070002@ti.com>
References: <1397044485-26483-1-git-send-email-gautam.vivek@samsung.com>
	<53465FB9.7070002@ti.com>
Date: Thu, 10 Apr 2014 16:02:52 +0530
Message-ID: <CAFp+6iHKT6wFBimhzEGVJRiY_y-2rAur_e-TPFS9=RTLckf-rA@mail.gmail.com>
Subject: Re: [PATCH] phy: exynos5-usbdrd: Add facility to toggle vbus gpio on/off
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Kamil Debski <k.debski@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,


On Thu, Apr 10, 2014 at 2:39 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> Hi.
>
> On Wednesday 09 April 2014 05:24 PM, Vivek Gautam wrote:
>> Adding support to enable/disable VBUS hooked to a gpio
>> to enable vbus supply on the port.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> ---
>>
>> Based on 'phy-exynos5-usbdrd' patches:
>> [PATCH V4 0/5] Add Exynos5 USB 3.0 phy driver based on generic PHY framework
>> http://www.spinics.net/lists/linux-usb/msg105507.html
>>
>>  drivers/phy/phy-exynos5-usbdrd.c |   18 ++++++++++++++++++
>>  1 file changed, 18 insertions(+)
>>
>> diff --git a/drivers/phy/phy-exynos5-usbdrd.c b/drivers/phy/phy-exynos5-usbdrd.c
>> index ff54a7c..5ca7485 100644
>> --- a/drivers/phy/phy-exynos5-usbdrd.c
>> +++ b/drivers/phy/phy-exynos5-usbdrd.c
>> @@ -18,6 +18,7 @@
>>  #include <linux/module.h>
>>  #include <linux/of.h>
>>  #include <linux/of_address.h>
>> +#include <linux/of_gpio.h>
>>  #include <linux/phy/phy.h>
>>  #include <linux/platform_device.h>
>>  #include <linux/mutex.h>
>> @@ -176,6 +177,7 @@ struct exynos5_usbdrd_phy {
>>       struct clk *ref_clk;
>>       unsigned long ref_rate;
>>       unsigned int refclk_reg;
>> +     int gpio;
>>  };
>>
>>  #define to_usbdrd_phy(inst) \
>> @@ -460,6 +462,9 @@ static int exynos5_usbdrd_phy_power_on(struct phy *phy)
>>       if (!IS_ERR(phy_drd->usb30_sclk))
>>               clk_prepare_enable(phy_drd->usb30_sclk);
>>
>> +     /* Toggle VBUS gpio - on */
>> +     gpio_set_value(phy_drd->gpio, 1);
>> +
>>       /* Power-on PHY*/
>>       inst->phy_cfg->phy_isol(inst, 0);
>>
>> @@ -476,6 +481,9 @@ static int exynos5_usbdrd_phy_power_off(struct phy *phy)
>>       /* Power-off the PHY */
>>       inst->phy_cfg->phy_isol(inst, 1);
>>
>> +     /* Toggle VBUS gpio - off */
>> +     gpio_set_value(phy_drd->gpio, 0);
>> +
>>       if (!IS_ERR(phy_drd->usb30_sclk))
>>               clk_disable_unprepare(phy_drd->usb30_sclk);
>>
>> @@ -585,6 +593,16 @@ static int exynos5_usbdrd_phy_probe(struct platform_device *pdev)
>>
>>       phy_drd->drv_data = drv_data;
>>
>> +     /* Get required GPIO for vbus */
>> +     phy_drd->gpio = of_get_named_gpio(dev->of_node,
>> +                                       "samsung,vbus-gpio", 0);
>
> Is this dt property documented somewhere?
>> +     if (!gpio_is_valid(phy_drd->gpio))
>> +             dev_dbg(dev, "no usbdrd-phy vbus gpio defined\n");
>
> No return here? Can the PHY be functional even without the VBUS?

On few boards, the switch IC's enable may no be controlled by a GPIO,
rather enabled by default.
So in those cases we may not want to stop PHY probe, when the VBUS
GPIO is not present.


-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
