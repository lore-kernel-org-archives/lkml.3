Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaK1XKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 18:10:50 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:32897 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaK1XKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 18:10:48 -0500
Message-ID: <547900D2.6050404@roeck-us.net>
Date: Fri, 28 Nov 2014 15:10:10 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>, Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, shawn.guo@linaro.org,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org, fkan@apm.com
Subject: Re: [PATCH 2/2] ARM: imx: src: support vf610 system reset controller
References: <1417193015-6033-1-git-send-email-stefan@agner.ch> <2716009.DOfHfaSPkY@wuerfel> <6341b31998ff843d236bc2a3e34537b0@agner.ch> <18555848.LVhqYu0kXL@wuerfel> <d3026e3c95825c31a80cf32b3600ad42@agner.ch>
In-Reply-To: <d3026e3c95825c31a80cf32b3600ad42@agner.ch>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.547900D8.0056,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2014 03:00 PM, Stefan Agner wrote:
> On 2014-11-28 23:22, Arnd Bergmann wrote:
>> On Friday 28 November 2014 23:09:09 Stefan Agner wrote:
>>> On 2014-11-28 22:24, Arnd Bergmann wrote:
>>>> On Friday 28 November 2014 22:02:01 Stefan Agner wrote:
>>>>
>>>>>> If the SRC is also capable of resetting individual blocks instead of just
>>>>>> the entire machine, it would be a reset driver in drivers/reset instead.
>>>>>
>>>>> Beside the system reset, there is only a mask functionality for the
>>>>> watchdogs (there are two watchdogs, one for Cortex-A5 and one for the
>>>>> M4). This makes the SRC module in the Vybrid a bit different then what
>>>>> is available on other i.MX SoC's...
>>>>
>>>> If you already have the watchdog registers in there and want to have
>>>> a watchdog driver too, the easiest way would be to register the reboot
>>>> handler from the watchdog driver.
>>>
>>> Hm, not sure we speak about the same here. The SRC module has two
>>> (multi-)bit fields to mask the watchdog reset event for each watchdog.
>>> Beside that, there are two full watchdog register maps, which are in
>>> different areas. There is already a driver for this watchdogs. I'm not
>>> sure what the idea behind this is exactly, I guess it would easily allow
>>> to (temporary) mask the other CPU's watchdog. However, I don't think we
>>> need that functionality, so I don't care about that right now.
>>
>> Ok, I see, thanks for the clarification!
>>
>>> There is also a restart handler in the watchdog driver, but I prefer to
>>> use the reset capabilities of the SRC since it has immediate effect.
>>>
>>> Lets get to the big picture again: I could register the whole SRC
>>> register map as a syscon device and then access the registers from my
>>> suspend/resume implementation later on. And similar in the restart
>>> driver, I would use syscon_regmap_lookup_by_compatible to check if it
>>> contains the vf610-src compatible string and register the restart
>>> driver/handler if available.
>>
>> Correct, and also in the watchdog driver, I guess.
>>
>> Instead of syscon_regmap_lookup_by_compatible, please use
>> syscon_regmap_lookup_by_phandle and put the link to the syscon
>> device into the device accessing it.
>>
>> Also, see if you can use or extend drivers/power/reset/syscon-reboot.c
>> for your use case.
>
> Nice, this allows to do the reset with almost no code. The only thing
> which might be a problem is the priority: I used 192 since 128 is
> already used by the watchdog driver. Maybe we can change that
> syscon-reboot is a bit above watchdogs by default, or maybe even a dt
> property? I will try to use that driver for v2. Thx!
>

A dt property might make more sense if the syscon driver is to be used
for multiple systems. Otherwise, no matter what you pick, it will be
wrong for some system.

Guenter

