Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab3DLMJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 08:09:34 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:34893 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab3DLMJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 08:09:28 -0400
Message-ID: <5167F972.2000707@atmel.com>
Date: Fri, 12 Apr 2013 14:09:22 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: <rtc-linux@googlegroups.com>, Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [rtc-linux] Re: [PATCH v2 0/5] ARM: at91: fix hanged boot
References: <20130311180611.GF8797@localhost> <1363025279-17615-1-git-send-email-jhovold@gmail.com> <20130411155505.GD21305@localhost> <20130411165414.GC25242@game.jcrosoft.org> <20130412093333.GF21305@localhost>
In-Reply-To: <20130412093333.GF21305@localhost>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2013 11:33 AM, Johan Hovold :
> On Thu, Apr 11, 2013 at 06:54:14PM +0200, Jean-Christophe PLAGNIOL-VILLARD wrote:
>> On 17:55 Thu 11 Apr     , Johan Hovold wrote:
>>> On Mon, Mar 11, 2013 at 07:07:54PM +0100, Johan Hovold wrote:
>>>> These patches fix a few severe issues affecting most AT91 SOCs where
>>>> boot can hang after a non-general reset, and where the only way to get
>>>> the system booting again is to do a general reset -- something which
>>>> could require physically removing any backup battery.
>>>
>>> Have you had time to look at these patches yet, Nicolas?
>>>
>>> I don't think not having decided on the path forward for DT-support for
>>> rtc-at91sam9 needs to be a blocker. The rtt-nodes will be needed in any
>>> case.
>>>
>>> I could respin the series on top of the DT-patch for rtc-at91rm9200, and
>>> add interrupt and status-disabled properties to the DT-nodes as well.
>> for this this is still a no go
>>
>> this way too much ugly
> 
> I understand that you prefer fixing every bootloader. I was just making
> sure everyone agrees that that is the best solution.
> 
> The two interrupt masks has to be cleared before the kernel enables the
> system interrupt; either it needs to be done by the bootloader or by the
> at91 arch code.
> 
> The various bootloaders may not know anything about RTT or RTC, but
> have all made sure interrupts are disabled before executing the kernel.
> That is, they have fulfilled the requirement that interrupts must be
> disabled.
> 
> So the trade-off seems to be: Either we fix this once and for all using
> the infrastructure already in place in the kernel (DT), or risk further
> (apparently) bricked systems as there are bound to be bootloaders that
> won't get updated.

Note that I didn't read your patch series yet, so I am not commenting on
the implementation.

BUT, from my experience with customers facing this issue, I do thing
that we must provide a solution (even in Linux kernel itself).


> [...]
> 
>>>> The problems stem from the fact that the RTC and RTT-peripherals are
>>>> powered by backup power (VDDBU) and are not reset on wake-up, user,
>>>> watchdog or software reset. Consequently, RTC and RTT-alarms and their
>>>> interrupts may be enabled at boot, leading to a system lock-up when an
>>>> interrupt arrives on the shared system-interrupt line before the
>>>> appropriate handler (e.g. RTC-driver) has been installed.
>>>>
>>>> The easiest way to trigger this is to simply wake up from an RTC-alarm
>>>> on at91sam9g45. The RTC-driver currently does not disable interrupts at
>>>> shutdown so even after a clean shut-down the system will always hang
>>>> after waking up.
>>>>
>>>> The first patch fixes this very general case of RTC-wake up after a
>>>> clean shutdown in the RTC-driver and is marked for stable as it is
>>>> perfectly straight-forward. [ Note that the other, RTT-based, AT91
>>>> RTC-driver already disables its interrupts at shutdown. ]
> 
> And what about this patch? If it's decided that every bootloader needs
> to be updated, then perhaps it's better to risk bricked systems also
> after a clean shutdown to enforce those updates? Should we then remove
> the corresponding disable of interrupts at shutdown from the rtc-at91sam9
> driver by the same logic?
> 
>>>> The more general problem can be triggered, for example, by doing a
>>>> user-reset while updating the RTC-time or if an RTC or RTT-alarm goes
>>>> off after a non-clean shutdown.
>>>>
>>>> To fix this I propose that arch-code should mask the relevant interrupts
>>>> before enabling the system interrupt at early boot, and this is what
>>>> the fifth patch does. To access the RTC-registers I choose to revert a
>>>> recent patch that moved the register definitions to drivers/rtc.
>>>>
>>>> Arguably, the relevant interrupts could also be disabled in bootloaders,
>>>> but I suggest fixing it in the kernel once and for all.
> 
> Thanks,
> Johan
> 
> 


-- 
Nicolas Ferre
