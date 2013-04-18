Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936680Ab3DRWDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 18:03:23 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:50225 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936642Ab3DRWDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 18:03:21 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <linux-serial@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] arm: mach-omap2: remove "OMAP_DEVICE_NO_IDLE_ON_SUSPEND" check
References: <1366198467-6757-1-git-send-email-sourav.poddar@ti.com>
	<1366198467-6757-5-git-send-email-sourav.poddar@ti.com>
	<87li8f4sum.fsf@linaro.org> <5170434C.7040706@ti.com>
Date: Thu, 18 Apr 2013 15:03:16 -0700
In-Reply-To: <5170434C.7040706@ti.com> (Sourav Poddar's message of "Fri, 19
	Apr 2013 00:32:36 +0530")
Message-ID: <874nf31opn.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sourav Poddar <sourav.poddar@ti.com> writes:

> On Thursday 18 April 2013 11:35 PM, Kevin Hilman wrote:
>> Sourav Poddar<sourav.poddar@ti.com>  writes:
>>
>>> Remove the "OMAP_DEVICE_NO_IDLE_ON_SUSPEND" check, since UART was the only one making
>>> use of it. Now serial core/driver takes care of the case when "no_console_suspend"
>>> is used in the bootargs and you need to keep the clock enable for console even while suspend.
>>>
>>> Signed-off-by: Sourav Poddar<sourav.poddar@ti.com>
>> NAK.  This patch will break many things...
>>
>>> ---
>>>   arch/arm/mach-omap2/omap_device.c |    7 +------
>>>   1 files changed, 1 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap_device.c
>>> index 381be7a..d6dce8f 100644
>>> --- a/arch/arm/mach-omap2/omap_device.c
>>> +++ b/arch/arm/mach-omap2/omap_device.c
>>> @@ -620,11 +620,8 @@ static int _od_suspend_noirq(struct device *dev)
>>>   	ret = pm_generic_suspend_noirq(dev);
>>>
>>>   	if (!ret&&  !pm_runtime_status_suspended(dev)) {
>>> -		if (pm_generic_runtime_suspend(dev) == 0) {
>>> -			if (!(od->flags&  OMAP_DEVICE_NO_IDLE_ON_SUSPEND))
>>> -				omap_device_idle(pdev);
>> Why did you remove the omap_device_idle() here?
> This patch is used along with patch3 to get rid of the issue. I posted
> them as a
> seperate patch beacuse of the subject line as one goes under drivers/*
> and the other
> arm/mach-omap2/*..
>
> This check was only valid for UART, and if od->flags is set to the
> "OMAP_DEVICE_NO_IDLE_ON_SUSPEND" flag, then UART will not be idled. 

correct, but *every other device* would be idled (if not already idle.)

> But now, we no longer depend on od->flag value to prevent idling of
> our console UART as the prepare/complete apis will take care of them.

Right, so removing the check on od->flags is fine, but what I asked
about is why you removed the omap_device_idle() call.

Remember that this code is called for *every* omap_device during
suspend, not just UART.

What you did stops *every* device from being idled during suspend.

You didn't read my whole message.  Specifically this part:

>> Note that the check is for when the flag is *not* set, so this patch
>> changes behavior for all the drivers that do not use
>> _NO_IDLE_ON_SUSPEND.  I think that's the opposite of what you intended.

Kevin
