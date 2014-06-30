Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbaF3Hzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 03:55:45 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43879 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbaF3Hzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 03:55:43 -0400
Message-ID: <53B117F9.6080004@ti.com>
Date: Mon, 30 Jun 2014 10:55:37 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tero Kristo <t-kristo@ti.com>, Tony Lindgren <tony@atomide.com>,
        Nishanth Menon <nm@ti.com>
CC: <rnayak@ti.com>, <balbi@ti.com>, <nsekhar@ti.com>, <kishon@ti.com>,
        <george.cherian@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: DRA7-evm: Enable SATA PHY and USB PHY power supplies
References: <1403700996-27105-1-git-send-email-rogerq@ti.com> <53AB4CE0.6020705@ti.com> <20140626073115.GD28884@atomide.com> <53ABE9AD.1000100@ti.com> <53AC2CA7.30800@ti.com> <53AC36ED.2000309@ti.com>
In-Reply-To: <53AC36ED.2000309@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2014 06:06 PM, Tero Kristo wrote:
> On 06/26/2014 05:22 PM, Roger Quadros wrote:
>> +Tero
>>
>> On 06/26/2014 12:36 PM, Roger Quadros wrote:
>>> On 06/26/2014 10:31 AM, Tony Lindgren wrote:
>>>> * Nishanth Menon <nm@ti.com> [140625 15:29]:
>>>>> On 06/25/2014 07:56 AM, Roger Quadros wrote:
>>>>>> The SATA and USB PHYs need the 1.8V and 3.3V supplies.
>>>>>> The PHY drivers/framework don't yet support regulator
>>>>>> supply so we have to keep these regulators always-on till
>>>>>> then.
>>>>>>
>>>>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>>>>>> ---
>>>>>>   arch/arm/boot/dts/dra7-evm.dts | 2 ++
>>>>>>   1 file changed, 2 insertions(+)
>>>>>>
>>>>>> diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
>>>>>> index 4adc280..99a1f79 100644
>>>>>> --- a/arch/arm/boot/dts/dra7-evm.dts
>>>>>> +++ b/arch/arm/boot/dts/dra7-evm.dts
>>>>>> @@ -241,6 +241,7 @@
>>>>>>                       regulator-min-microvolt = <1800000>;
>>>>>>                       regulator-max-microvolt = <1800000>;
>>>>>>                       regulator-boot-on;
>>>>>> +                    regulator-always-on;
>>>>>>                   };
>>>>>>
>>>>>>                   ldo9_reg: ldo9 {
>>>>>> @@ -266,6 +267,7 @@
>>>>>>                       regulator-min-microvolt = <3300000>;
>>>>>>                       regulator-max-microvolt = <3300000>;
>>>>>>                       regulator-boot-on;
>>>>>> +                    regulator-always-on;
>>>>>>                   };
>>>>>>               };
>>>>>>           };
>>>>>>
>>>>>
>>>>> Why not fix phy driver/framework as needed? the trouble is people
>>>>> always forget to remove always-on... who actually audits old logs and
>>>>> fixes stuff back up?
>>>>
>>>> Yes I agree let's not play with the regulator-always-on unless
>>>> absolutely necessary.
>>>>
>>> Agreed. PHY framework must deal with this. Till then USB, SATA and most likely PCIe as well will not work on DRA7-evm.
>>>
>>
>> I tried the below patch to enable the relevant regulators in the PHY drivers but still couldn't manage to get USB to work. The same 1.8V regulator is used to supply 3 pins
>> -vdda_usb1: DPLL_USB and HS_USB1 analog supply
>> -vdda_usb2: HS_USB2 analog supply
>> -vdda_usb3: DPLL_USB_OTG_SS and USB3.0 Rx/Tx analog supply
>>
>> It seems that the regulator auto disable kicks in before the phy driver enables the regulator thus causing some kind of malfunction. I'm not sure whether this is due to DPLL_USB supply glitch or HS_USB1 analog supply glitch.
>>
>> In any case, the DPLL_USB (clock driver?) needs to enable the 1.8V regulator in addition to the HS_USB PHY driver to prevent this supply glitch.
>>
>> Tero, any suggestions about this? If we are not concerned about disabling DPLL_USB anytime then the regulator might just as well be always-on. Alternatively can we place a regulator_get(), regulator_enable() in drivers/clk/ti/dpll.c?
> 
> I believe dpll_usb needs to go down for the core to idle. Also, we are working on getting suspend-resume working on this platform, so having the regulator always on is a no-no.
> 
> Also, I am heavily against adding regulator tweaks within the clock driver, there needs to be another way.

Fair enough. There is not much information about controlling the power on vdda_usbx pins except the power-up and power-down sequence diagrams in Fig. 3.1 and 3.2 in the Data Manual (DRA75x_74x_ES1.1_DM_Early_Preliminary_vJ.pdf).

Can the regulator be dealt with in the OMAP PM core driver, along with the vdd_mpu and vdd_core stuff?

cheers,
-roger

>> ---
>>
>> diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
>> index 4adc280..23379ab 100644
>> --- a/arch/arm/boot/dts/dra7-evm.dts
>> +++ b/arch/arm/boot/dts/dra7-evm.dts
>> @@ -495,3 +495,11 @@
>>           };
>>       };
>>   };
>> +
>> +&usb2_phy1 {
>> +    vdda3v3-supply = <&ldousb_reg>;
>> +};
>> +
>> +&usb3_phy1 {
>> +    vdda1v8-supply = <&ldo3_reg>;
>> +};
>> diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
>> index 7007c11..bb1a768 100644
>> --- a/drivers/phy/phy-omap-usb2.c
>> +++ b/drivers/phy/phy-omap-usb2.c
>> @@ -30,6 +30,7 @@
>>   #include <linux/phy/omap_control_phy.h>
>>   #include <linux/phy/phy.h>
>>   #include <linux/of_platform.h>
>> +#include <linux/regulator/consumer.h>
>>
>>   #define USB2PHY_DISCON_BYP_LATCH (1 << 31)
>>   #define USB2PHY_ANA_CONFIG1 0x4c
>> @@ -107,6 +108,18 @@ static int omap_usb_power_off(struct phy *x)
>>
>>       omap_control_phy_power(phy->control_dev, 0);
>>
>> +    if (phy->pwr) {
>> +        int ret;
>> +
>> +        ret = regulator_disable(phy->pwr);
>> +        if (ret) {
>> +            dev_err(phy->dev, "failed to disable regulator\n");
>> +            return ret;
>> +        } else {
>> +            dev_info(phy->dev, "disabled regulator\n");
>> +        }
>> +    }
>> +
>>       return 0;
>>   }
>>
>> @@ -114,6 +127,18 @@ static int omap_usb_power_on(struct phy *x)
>>   {
>>       struct omap_usb *phy = phy_get_drvdata(x);
>>
>> +    if (phy->pwr) {
>> +        int ret;
>> +
>> +        ret = regulator_enable(phy->pwr);
>> +        if (ret) {
>> +            dev_err(phy->dev, "failed to enable regulator\n");
>> +            return ret;
>> +        } else {
>> +            dev_info(phy->dev, "enabled regulator\n");
>> +        }
>> +    }
>> +
>>       omap_control_phy_power(phy->control_dev, 1);
>>
>>       return 0;
>> @@ -253,6 +278,14 @@ static int omap_usb2_probe(struct platform_device *pdev)
>>       phy->control_dev = &control_pdev->dev;
>>       omap_control_phy_power(phy->control_dev, 0);
>>
>> +    /* phy-supply */
>> +    phy->pwr = devm_regulator_get_optional(phy->dev, "vdda3v3");
>> +    if (IS_ERR(phy->pwr)) {
>> +        if (PTR_ERR(phy->pwr) == -EPROBE_DEFER)
>> +            return -EPROBE_DEFER;
>> +        phy->pwr = NULL;
>> +    }
>> +
>>       otg->set_host        = omap_usb_set_host;
>>       otg->set_peripheral    = omap_usb_set_peripheral;
>>       if (phy_data->flags & OMAP_USB2_HAS_SET_VBUS)
>> diff --git a/drivers/phy/phy-ti-pipe3.c b/drivers/phy/phy-ti-pipe3.c
>> index 5913676..1b46b0b 100644
>> --- a/drivers/phy/phy-ti-pipe3.c
>> +++ b/drivers/phy/phy-ti-pipe3.c
>> @@ -28,6 +28,7 @@
>>   #include <linux/delay.h>
>>   #include <linux/phy/omap_control_phy.h>
>>   #include <linux/of_platform.h>
>> +#include <linux/regulator/consumer.h>
>>
>>   #define    PLL_STATUS        0x00000004
>>   #define    PLL_GO            0x00000008
>> @@ -81,6 +82,7 @@ struct ti_pipe3 {
>>       struct clk        *sys_clk;
>>       struct clk        *refclk;
>>       struct pipe3_dpll_map    *dpll_map;
>> +    struct regulator    *pwr_dpll;
>>   };
>>
>>   static struct pipe3_dpll_map dpll_map_usb[] = {
>> @@ -215,6 +217,17 @@ static int ti_pipe3_init(struct phy *x)
>>       u32 val;
>>       int ret = 0;
>>
>> +    /* Enable DPLL regulator */
>> +    if (phy->pwr_dpll) {
>> +        ret = regulator_enable(phy->pwr_dpll);
>> +        if (ret) {
>> +            dev_err(phy->dev, "failed to enable regulator\n");
>> +            return ret;
>> +        } else {
>> +            dev_info(phy->dev, "enabled regulator\n");
>> +        }
>> +    }
>> +
>>       /* Bring it out of IDLE if it is IDLE */
>>       val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
>>       if (val & PLL_IDLE) {
>> @@ -262,6 +275,18 @@ static int ti_pipe3_exit(struct phy *x)
>>           return -EBUSY;
>>       }
>>
>> +    /* Disable DPLL regulator */
>> +    if (phy->pwr_dpll) {
>> +        int ret;
>> +
>> +        ret = regulator_disable(phy->pwr_dpll);
>> +        if (ret) {
>> +            dev_err(phy->dev, "failed to disable regulator\n");
>> +            return ret;
>> +        } else {
>> +            dev_info(phy->dev, "disabled regulator\n");
>> +        }
>> +    }
>>       return 0;
>>   }
>>   static struct phy_ops ops = {
>> @@ -308,7 +333,15 @@ static int ti_pipe3_probe(struct platform_device *pdev)
>>       if (IS_ERR(phy->pll_ctrl_base))
>>           return PTR_ERR(phy->pll_ctrl_base);
>>
>> -    phy->dev        = &pdev->dev;
>> +    phy->dev = &pdev->dev;
>> +
>> +    /* dpll-supply */
>> +    phy->pwr_dpll = devm_regulator_get_optional(phy->dev, "vdda1v8");
>> +    if (IS_ERR(phy->pwr_dpll)) {
>> +        if (PTR_ERR(phy->pwr_dpll) == -EPROBE_DEFER)
>> +            return -EPROBE_DEFER;
>> +        phy->pwr_dpll = NULL;
>> +    }
>>
>>       if (!of_device_is_compatible(node, "ti,phy-pipe3-sata")) {
>>
>> diff --git a/include/linux/phy/omap_usb.h b/include/linux/phy/omap_usb.h
>> index dc2c541..e2c46df 100644
>> --- a/include/linux/phy/omap_usb.h
>> +++ b/include/linux/phy/omap_usb.h
>> @@ -40,6 +40,7 @@ struct omap_usb {
>>       struct clk        *wkupclk;
>>       struct clk        *optclk;
>>       u8            flags;
>> +    struct regulator    *pwr;
>>   };
>>
>>   struct usb_phy_data {
>>
> 

