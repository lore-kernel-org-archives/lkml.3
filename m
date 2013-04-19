Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030521Ab3DSNzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 09:55:48 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51328 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968307Ab3DSNzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 09:55:47 -0400
Message-ID: <51714CCC.9090800@ti.com>
Date: Fri, 19 Apr 2013 19:25:24 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <linux-serial@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] arm: mach-omap2: remove "OMAP_DEVICE_NO_IDLE_ON_SUSPEND"
 check
References: <1366198467-6757-1-git-send-email-sourav.poddar@ti.com>	<1366198467-6757-5-git-send-email-sourav.poddar@ti.com>	<87li8f4sum.fsf@linaro.org> <5170434C.7040706@ti.com> <874nf31opn.fsf@linaro.org>
In-Reply-To: <874nf31opn.fsf@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,
On Friday 19 April 2013 03:33 AM, Kevin Hilman wrote:
> Sourav Poddar<sourav.poddar@ti.com>  writes:
>
>> On Thursday 18 April 2013 11:35 PM, Kevin Hilman wrote:
>>> Sourav Poddar<sourav.poddar@ti.com>   writes:
>>>
>>>> Remove the "OMAP_DEVICE_NO_IDLE_ON_SUSPEND" check, since UART was the only one making
>>>> use of it. Now serial core/driver takes care of the case when "no_console_suspend"
>>>> is used in the bootargs and you need to keep the clock enable for console even while suspend.
>>>>
>>>> Signed-off-by: Sourav Poddar<sourav.poddar@ti.com>
>>> NAK.  This patch will break many things...
>>>
>>>> ---
>>>>    arch/arm/mach-omap2/omap_device.c |    7 +------
>>>>    1 files changed, 1 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap_device.c
>>>> index 381be7a..d6dce8f 100644
>>>> --- a/arch/arm/mach-omap2/omap_device.c
>>>> +++ b/arch/arm/mach-omap2/omap_device.c
>>>> @@ -620,11 +620,8 @@ static int _od_suspend_noirq(struct device *dev)
>>>>    	ret = pm_generic_suspend_noirq(dev);
>>>>
>>>>    	if (!ret&&   !pm_runtime_status_suspended(dev)) {
>>>> -		if (pm_generic_runtime_suspend(dev) == 0) {
>>>> -			if (!(od->flags&   OMAP_DEVICE_NO_IDLE_ON_SUSPEND))
>>>> -				omap_device_idle(pdev);
>>> Why did you remove the omap_device_idle() here?
>> This patch is used along with patch3 to get rid of the issue. I posted
>> them as a
>> seperate patch beacuse of the subject line as one goes under drivers/*
>> and the other
>> arm/mach-omap2/*..
>>
>> This check was only valid for UART, and if od->flags is set to the
>> "OMAP_DEVICE_NO_IDLE_ON_SUSPEND" flag, then UART will not be idled.
> correct, but *every other device* would be idled (if not already idle.)
>
>> But now, we no longer depend on od->flag value to prevent idling of
>> our console UART as the prepare/complete apis will take care of them.
> Right, so removing the check on od->flags is fine, but what I asked
> about is why you removed the omap_device_idle() call.
>
> Remember that this code is called for *every* omap_device during
> suspend, not just UART.
>
> What you did stops *every* device from being idled during suspend.
>
> You didn't read my whole message.  Specifically this part:
>
Yes, got your point. omap_device_idle should not be called only
for console uart.

Just did a quick testing by including the following hunk on top of my 
patch series..

diff --git a/arch/arm/mach-omap2/omap_device.c 
b/arch/arm/mach-omap2/omap_device.c
index c226946..7480e87 100644
--- a/arch/arm/mach-omap2/omap_device.c
+++ b/arch/arm/mach-omap2/omap_device.c
@@ -617,8 +617,10 @@ static int _od_suspend_noirq(struct device *dev)
         ret = pm_generic_suspend_noirq(dev);

         if (!ret && !pm_runtime_status_suspended(dev)) {
-               if (pm_generic_runtime_suspend(dev) == 0)
+               if (pm_generic_runtime_suspend(dev) == 0) {
+                       omap_device_idle(pdev);
                         od->flags |= OMAP_DEVICE_SUSPENDED;
+               }
         }

         return ret;
@@ -631,6 +633,7 @@ static int _od_resume_noirq(struct device *dev)

         if ((od->flags & OMAP_DEVICE_SUSPENDED) &&
             !pm_runtime_status_suspended(dev)) {
+               omap_device_enable(pdev);
                 od->flags &= ~OMAP_DEVICE_SUSPENDED;
                 pm_generic_runtime_resume(dev);
         }
And found the wakeup from UART is no more functional.
So, the omap_device_idle gets called for console UART also, thereby
preventing the "no_idle_on_suspend" theory.

Hence, merely putting prepare/complete callback the way I did is not 
helping.
We need to delete omap_device_idle also, which I agree is not correct.
So, we need a way to bypass this "omap_device_idle"
call for console UART. ?
What my understanding was that after modifying serial driver,
bypass the entire hunk[1] for console UART?


>>> Note that the check is for when the flag is *not* set, so this patch
>>> changes behavior for all the drivers that do not use
>>> _NO_IDLE_ON_SUSPEND.  I think that's the opposite of what you intended.
> Kevin

