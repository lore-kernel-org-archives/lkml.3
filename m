Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbbANQK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:10:28 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:52029 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbbANQKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:10:25 -0500
Message-ID: <54B694F0.1000405@linaro.org>
Date: Wed, 14 Jan 2015 17:10:24 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>
CC: tglx@linutronix.de, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH] clockevents: rockchip: Add rockchip timer for rk3288
References: <1420542233-16897-1-git-send-email-daniel.lezcano@linaro.org> <3085252.tjZK7l7tBp@phil>
In-Reply-To: <3085252.tjZK7l7tBp@phil>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 12:20 AM, Heiko Stübner wrote:
> Hi Daniel,
>
> sorry it took a bit longer to reply.

No problem :)

> Generally it looks good to me, just some minor issues inline below.

Thanks for the review.

> It would also be nice to include the rockchip list (linux-
> rockchip@lists.infradead.org) for future patches.

Yes, sure. I will do that in the future.

[...]

>> +- clock-frequency: the frequency the timer is running
>> +
>> +Example:
>> +	timer: timer@ff810000 {
>> +		compatible = "rockchip,rk3288-timer";
>> +		reg = <0xff810000 0x20>;
>> +		interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
>> +		clock-frequency = <24000000>;
>
> wouldn't it make sense to use the actual supplying clock?
>
> For the timer you want to use it is just the non-gateable &xin24m, but the
> timers in the other block (timer0-5) actually do have gateable clocks.
>
> Similarly there is a pclk_timer supplying at least one of the two actual
> blocks. I'll try to inquire how the blocks are actually supplied.

Ok, are you suggesting I should use another timer so we can gate it for 
power efficiency ?

>> +	};
>> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
>> index 2a878a3..7a7db48 100644
>> --- a/arch/arm/boot/dts/rk3288.dtsi
>> +++ b/arch/arm/boot/dts/rk3288.dtsi
>> @@ -149,6 +149,13 @@
>>   		clock-frequency = <24000000>;
>>   	};
>>
>> +	timer: timer@ff810000 {
>> +		compatible = "rockchip,rk3288-timer";
>> +		reg = <0xff810000 0x20>;
>> +		interrupts = <GIC_SPI 72 IRQ_TYPE_LEVEL_HIGH>;
>> +		clock-frequency = <24000000>;
>> +	};
>> +
>>   	sdmmc: dwmmc@ff0c0000 {
>>   		compatible = "rockchip,rk3288-dw-mshc";
>>   		clock-freq-min-max = <400000 150000000>;
>> diff --git a/arch/arm/mach-rockchip/Kconfig b/arch/arm/mach-rockchip/Kconfig
>> index ac5803c..4c3fa7e 100644
>> --- a/arch/arm/mach-rockchip/Kconfig
>> +++ b/arch/arm/mach-rockchip/Kconfig
>> @@ -11,6 +11,7 @@ config ARCH_ROCKCHIP
>>   	select HAVE_ARM_SCU if SMP
>>   	select HAVE_ARM_TWD if SMP
>>   	select DW_APB_TIMER_OF
>> +	select RK3288_TIMER
>>   	select ARM_GLOBAL_TIMER
>>   	select CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
>>   	help
>> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
>> index fc01ec2..6ed97a6 100644
>> --- a/drivers/clocksource/Kconfig
>> +++ b/drivers/clocksource/Kconfig
>> @@ -26,6 +26,10 @@ config DW_APB_TIMER_OF
>>   	select DW_APB_TIMER
>>   	select CLKSRC_OF
>>
>> +config RK3288_TIMER
>> +	bool
>> +	select CLKSRC_OF
>> +
>
> the config symbol to compile rockchip_timer.c is RK3288_TIMER?
> I'd think it could match a bit more ...
> ROCKCHIP_TIMER -> rockchip_timer.c
> 	or
> RK3288_TIMER -> rk3288_timer.c
 >
> This timer-block is actually also present on the rk3188, but not on the rk3066
> which uses an unmodified dw_apb_timer.

Ok, then rockchip_timer.c fits better. I will do the change.

>>   config ARMADA_370_XP_TIMER
>>   	bool
>>   	select CLKSRC_OF
>> diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
>> +
>> +        if (of_property_read_u32(np, "clock-frequency", &bc_timer.freq)) {
>
> formatting issue with spaces instead of tabs in the 5 lines above

Copy that.

>> +		pr_err("Failed to read the frequency for '%s'\n", TIMER_NAME);
>> +		return;
>> +	}

Thanks!
   -- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

