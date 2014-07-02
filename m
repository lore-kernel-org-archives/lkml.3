Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196AbaGBLvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 07:51:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46847 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbaGBLvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 07:51:07 -0400
Message-ID: <53B3F225.5020303@ti.com>
Date: Wed, 2 Jul 2014 14:51:01 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tero Kristo <t-kristo@ti.com>, Tony Lindgren <tony@atomide.com>,
        Nishanth Menon <nm@ti.com>
CC: <rnayak@ti.com>, <balbi@ti.com>, <nsekhar@ti.com>, <kishon@ti.com>,
        <george.cherian@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: DRA7-evm: Enable SATA PHY and USB PHY power supplies
References: <1403700996-27105-1-git-send-email-rogerq@ti.com> <53AB4CE0.6020705@ti.com> <20140626073115.GD28884@atomide.com> <53ABE9AD.1000100@ti.com> <53AC2CA7.30800@ti.com> <53AC36ED.2000309@ti.com> <53B117F9.6080004@ti.com>
In-Reply-To: <53B117F9.6080004@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2014 10:55 AM, Roger Quadros wrote:
> On 06/26/2014 06:06 PM, Tero Kristo wrote:
>> On 06/26/2014 05:22 PM, Roger Quadros wrote:
>>> +Tero
>>>
>>> On 06/26/2014 12:36 PM, Roger Quadros wrote:
>>>> On 06/26/2014 10:31 AM, Tony Lindgren wrote:
>>>>> * Nishanth Menon <nm@ti.com> [140625 15:29]:
>>>>>> On 06/25/2014 07:56 AM, Roger Quadros wrote:
>>>>>>> The SATA and USB PHYs need the 1.8V and 3.3V supplies.
>>>>>>> The PHY drivers/framework don't yet support regulator
>>>>>>> supply so we have to keep these regulators always-on till
>>>>>>> then.
>>>>>>>
>>>>>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>>>>>>> ---
>>>>>>>   arch/arm/boot/dts/dra7-evm.dts | 2 ++
>>>>>>>   1 file changed, 2 insertions(+)
>>>>>>>
>>>>>>> diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
>>>>>>> index 4adc280..99a1f79 100644
>>>>>>> --- a/arch/arm/boot/dts/dra7-evm.dts
>>>>>>> +++ b/arch/arm/boot/dts/dra7-evm.dts
>>>>>>> @@ -241,6 +241,7 @@
>>>>>>>                       regulator-min-microvolt = <1800000>;
>>>>>>>                       regulator-max-microvolt = <1800000>;
>>>>>>>                       regulator-boot-on;
>>>>>>> +                    regulator-always-on;

There was a confirmation from the TI hardware team that this 1.8V regulator can't be powered down while the SoC is Active. So we need to have regulator-always-on here.

>>>>>>>                   };
>>>>>>>
>>>>>>>                   ldo9_reg: ldo9 {
>>>>>>> @@ -266,6 +267,7 @@
>>>>>>>                       regulator-min-microvolt = <3300000>;
>>>>>>>                       regulator-max-microvolt = <3300000>;
>>>>>>>                       regulator-boot-on;
>>>>>>> +                    regulator-always-on;

This ldousb_reg 3.3V regulator can be turned off when the PHY is not in use. The PHY driver will manage this.

cheers,
-roger

>>>>>>>                   };
>>>>>>>               };
>>>>>>>           };
>>>>>>>
>>>>>>
>>>>>> Why not fix phy driver/framework as needed? the trouble is people
>>>>>> always forget to remove always-on... who actually audits old logs and
>>>>>> fixes stuff back up?
>>>>>
>>>>> Yes I agree let's not play with the regulator-always-on unless
>>>>> absolutely necessary.
>>>>>
>>>> Agreed. PHY framework must deal with this. Till then USB, SATA and most likely PCIe as well will not work on DRA7-evm.
>>>>
>>>
>>> I tried the below patch to enable the relevant regulators in the PHY drivers but still couldn't manage to get USB to work. The same 1.8V regulator is used to supply 3 pins
>>> -vdda_usb1: DPLL_USB and HS_USB1 analog supply
>>> -vdda_usb2: HS_USB2 analog supply
>>> -vdda_usb3: DPLL_USB_OTG_SS and USB3.0 Rx/Tx analog supply
>>>
>>> It seems that the regulator auto disable kicks in before the phy driver enables the regulator thus causing some kind of malfunction. I'm not sure whether this is due to DPLL_USB supply glitch or HS_USB1 analog supply glitch.
>>>
>>> In any case, the DPLL_USB (clock driver?) needs to enable the 1.8V regulator in addition to the HS_USB PHY driver to prevent this supply glitch.
>>>
>>> Tero, any suggestions about this? If we are not concerned about disabling DPLL_USB anytime then the regulator might just as well be always-on. Alternatively can we place a regulator_get(), regulator_enable() in drivers/clk/ti/dpll.c?
>>
>> I believe dpll_usb needs to go down for the core to idle. Also, we are working on getting suspend-resume working on this platform, so having the regulator always on is a no-no.
>>
>> Also, I am heavily against adding regulator tweaks within the clock driver, there needs to be another way.
> 
> Fair enough. There is not much information about controlling the power on vdda_usbx pins except the power-up and power-down sequence diagrams in Fig. 3.1 and 3.2 in the Data Manual (DRA75x_74x_ES1.1_DM_Early_Preliminary_vJ.pdf).
> 
> Can the regulator be dealt with in the OMAP PM core driver, along with the vdd_mpu and vdd_core stuff?
> 



