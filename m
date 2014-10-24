Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbaJXCGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 22:06:33 -0400
Received: from regular1.263xmail.com ([211.150.99.133]:50019 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbaJXCGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 22:06:31 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: zhengsq@rock-chips.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <e8ba5677cb782d43caaa9619c6d645ae>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <5449B433.5040003@rock-chips.com>
Date: Fri, 24 Oct 2014 10:06:43 +0800
From: Caesar Wang <caesar.wang@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com,
        zyf@rock-chips.com, dianders@chromium.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        cf@rock-chips.com, dbasehore@chromium.org, huangtao@rock-chips.com,
        cjf@rock-chips.com, zhengsq@rock-chips.com
Subject: Re: [PATCH v13 4/5] ARM: dts: add main Thermal info to rk3288
References: <1414057207-1576-1-git-send-email-caesar.wang@rock-chips.com> <1414057207-1576-5-git-send-email-caesar.wang@rock-chips.com> <20141024004625.GD9463@dtor-ws> <5449A6A4.3070608@rock-chips.com> <E4EEE800-5701-45E5-9E97-D3B036DC2F17@gmail.com>
In-Reply-To: <E4EEE800-5701-45E5-9E97-D3B036DC2F17@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


在 2014/10/24 9:37, Dmitry Torokhov 写道:
> On October 23, 2014 6:08:52 PM PDT, Caesar Wang <caesar.wang@rock-chips.com> wrote:
>> Dmitry,
>>
>> 在 2014/10/24 8:46, Dmitry Torokhov 写道:
>>> Hi Caesar,
>>>
>>> On Thu, Oct 23, 2014 at 05:40:06PM +0800, Caesar Wang wrote:
>>>> This patch is depend on rk3288-thermal.dtsi,or
>>>> it will compile error.
>>>>
>>>> If the temperature over a period of time High,over 120C
>>>> the resulting TSHUT gave CRU module,let it reset
>>>> the entire chip,or via GPIO give PMIC.
>>>>
>>>> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
>>>> ---
>>>>    arch/arm/boot/dts/rk3288.dtsi | 21 +++++++++++++++++++++
>>>>    1 file changed, 21 insertions(+)
>>>>
>>>> diff --git a/arch/arm/boot/dts/rk3288.dtsi
>> b/arch/arm/boot/dts/rk3288.dtsi
>>>> index cb18bb4..85fc17a 100644
>>>> --- a/arch/arm/boot/dts/rk3288.dtsi
>>>> +++ b/arch/arm/boot/dts/rk3288.dtsi
>>>> @@ -15,6 +15,7 @@
>>>>    #include <dt-bindings/interrupt-controller/arm-gic.h>
>>>>    #include <dt-bindings/pinctrl/rockchip.h>
>>>>    #include <dt-bindings/clock/rk3288-cru.h>
>>>> +#include <dt-bindings/thermal/thermal.h>
>>>>    #include "skeleton.dtsi"
>>>>    
>>>>    / {
>>>> @@ -66,6 +67,7 @@
>>>>    				 216000  900000
>>>>    				 126000  900000
>>>>    			>;
>>>> +			#cooling-cells = <2>; /* min followed by max */
>>>>    			clock-latency = <40000>;
>>>>    			clocks = <&cru ARMCLK>;
>>>>    		};
>>>> @@ -346,6 +348,19 @@
>>>>    		status = "disabled";
>>>>    	};
>>>>    
>>>> +	tsadc: tsadc@ff280000 {
>>>> +		compatible = "rockchip,rk3288-tsadc";
>>>> +		reg = <0xff280000 0x100>;
>>>> +		interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
>>>> +		clocks = <&cru SCLK_TSADC>, <&cru PCLK_TSADC>;
>>>> +		clock-names = "tsadc", "apb_pclk";
>>>> +		pinctrl-names = "default";
>>>> +		pinctrl-0 = <&otp_out>;
>>>> +		#thermal-sensor-cells = <1>;
>>>> +		hw-shut-temp = <120000>;
>>> I do not think this is a good value. You have (in the other DTS file)
>>> passive trip point at 80 and critical (which should result in orderly
>>> shutdown) at 125. But here you define hardware-controlled shutdown at
>>> 120C, which is backwards. You should have:
>>>
>>> passive <= critical <= hardware
>> Hmmm....
>> but, the system will shutdown when temperature over critial value,
>> there is no chance of triggering the TSHUT.
>>
>> If the temperature over a period of time High,as we know,
>> the resulting TSHUT gave CRU module,let it hot-reset the entire chip,
>> or via GPIO give PMIC cold-reset the entire chip.
> Having tshut trigger is not the goal, tshut is the measure of last resort. If we can handle thermal conditions without triggering tshut, we achieved our goal.
>
> Tshut triggering is " oh, crap, nothing we tried works" scenario.

I don't think so.

In general,We should have:
passive <= hardware(reset entire chip) <= critical(shutdown)

The temperature be rising qulckly if have some other conditions,
the "critical" will play a role.

Agreed?


>
> Thanks.
>

-- 
Best regards,
Caesar


