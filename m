Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaETNRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:17:35 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41748 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbaETNRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:17:33 -0400
Message-ID: <537B5598.8070603@ti.com>
Date: Tue, 20 May 2014 16:16:08 +0300
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: <dbaryshkov@gmail.com>, <dwmw2@infradead.org>,
        <ijc+devicetree@hellion.org.uk>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>, <galak@codeaurora.org>,
        <grant.likely@linaro.org>, <rdunlap@infradead.org>,
        <linux@arm.linux.org.uk>, <grygorii.strashko@ti.com>, <olof@lixom.net>,
        <w-kwok2@ti.com>, <sboyd@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Patch v3 0/5] Introduce keystone reset driver
References: <1400495155-11136-1-git-send-email-ivan.khoronzhuk@ti.com> <537A1E2C.8040102@ti.com> <5095812.b6DgWAxYzH@wuerfel>
In-Reply-To: <5095812.b6DgWAxYzH@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/19/2014 08:47 PM, Arnd Bergmann wrote:
> On Monday 19 May 2014 11:07:24 Santosh Shilimkar wrote:
>> On Monday 19 May 2014 06:25 AM, Ivan Khoronzhuk wrote:
>>> These patches introduce keystone reset driver.
>>>
>>> The keystone SoC can be rebooted in several ways. By external reset
>>> pin, by soft and by watchdogs. This driver allows software reset and reset
>>> by one of the watchdogs. Also added opportunity to set soft/hard reset type.
>>>
>>> Based on v3.15-rc5
>>>
>> Arnd,
>> Can I have have your ack/reviewed-by please since you did gave few comments
>> on previous version.
> Sorry for not getting back to you earlier on this topic.
>
>> On 04/14/2014 09:44 PM, Arnd Bergmann wrote:
>>> On Monday 14 April 2014 20:41:20 Ivan Khoronzhuk wrote:
>>>> +Optional properties:
>>>> +
>>>> +- ti,soft-reset:       Boolean option indicating soft reset.
>>>> +                       By default hard reset is used.
>>>> +
>>>> +- ti,wdt_list:         WDT list that can cause SoC reset.
>>>> +                       The list in format: <0>, <2>;
>>>> +                       Begins from 0 to 3, as keystone can contain up
>>>> +                       to 4 SoC reset watchdogs.
>>> This looks like your binding just describes a subset of the
>>> watchdog timer registers. If so, don't do a standalone reset
>> The registers are not a subset of watchdog hardware it's SoC specific future
>> controlled by SoC specific registers (bootregs and PLL regs).
>>
>> For watchog IP setup, the Keystone uses the watchdog driver common with
>> other
>> SoCs -- davinci_watchdog that is not depend on other SoC settings like
>> this driver does.
>>
>> The Keystone SoCs have separate registers to tune Keystone2 reset
>> functionality
>> by configuring Reset multiplexer &  PLL. And it tunes not only watchdog
>> usage.
>> The keystone SoC can be rebooted in several ways. By external reset pin,
>> by soft and
>> by watchdogs. This driver allows software reset or reset by one of the
>> watchdogs
>> (and other settings) independently on watchdog driver settings. This is
>> job of reset driver.
> It sounds like you use a syscon area in the reset driver. This is not
> uncommon, but it means you should probably have a generic node for
> the SoC specific registers that contains all of them at once and
> exports them as a regmap using the drivers/mfd/syscon.c driver.
>
> 	Arnd

Arnd,
Thank for the reply

The reset driver uses two ranges:
- RSTYPE, RSTCTRL,RSTCFG, RSISO  (Reset Main PLL Controller)
- RESETMUX8-10 registers

The content of these register ranges are completely used by the reset 
driver.
Currently no one on the SoC can access them instead of the reset driver.
Also we don't use syscon/regmap at all - so adding this will be some 
overhead.

As I posted previously:
"...configuring Reset multiplexer & PLL. And it tunes not only watchdog 
usage..."

Yes, it tunes not only watchdog usage and uses part of registers from 
PLL controller,
but all it works with are connected with reset functionality. These 
ranges are used only
by reset driver and their purpose is reset functionality.

Maybe in the future some soft can use ranges in question for own tasks, 
but it should be
done via reset driver. So as I see there is no reasons to use regmap for 
reset driver.

-- 
Regards,
Ivan Khoronzhuk

