Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab3DYGt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 02:49:27 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43637 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab3DYGtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 02:49:25 -0400
Message-ID: <5178D1E0.6010400@ti.com>
Date: Thu, 25 Apr 2013 12:19:04 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <linux-serial@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCHv3 5/5] arm: omap2+: omap_device: remove no_idle_on_suspend
References: <1366809353-19435-1-git-send-email-sourav.poddar@ti.com>	<1366809353-19435-6-git-send-email-sourav.poddar@ti.com> <87d2tj378q.fsf@linaro.org>
In-Reply-To: <87d2tj378q.fsf@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,
On Thursday 25 April 2013 03:45 AM, Kevin Hilman wrote:
> Sourav Poddar<sourav.poddar@ti.com>  writes:
>
>> Remove "no_idle_on_suspend" check, since respective
>> driver should be able to prevent idling of a
>> device whenever required.
>>
>> Driver's can get same behavior by just returning -EBUSY
>> from their ->runtime_suspend only during suspend.
>>
>> Cc: Santosh Shilimkar<santosh.shilimkar@ti.com>
>> Cc: Felipe Balbi<balbi@ti.com>
>> Cc: Rajendra nayak<rnayak@ti.com>
>> Cc: Grygorii Strashko<grygorii.strashko@ti.com>
>> Signed-off-by: Sourav Poddar<sourav.poddar@ti.com>
>> Reviewed-by: Felipe Balbi<balbi@ti.com>
>> ---
>>   arch/arm/mach-omap2/omap_device.c |   12 +++---------
>>   arch/arm/mach-omap2/omap_device.h |   10 ----------
>>   2 files changed, 3 insertions(+), 19 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap_device.c
>> index 381be7a..2043d71 100644
>> --- a/arch/arm/mach-omap2/omap_device.c
>> +++ b/arch/arm/mach-omap2/omap_device.c
>> @@ -170,9 +170,6 @@ static int omap_device_build_from_dt(struct platform_device *pdev)
>>   			r->name = dev_name(&pdev->dev);
>>   	}
>>
>> -	if (of_get_property(node, "ti,no_idle_on_suspend", NULL))
>> -		omap_device_disable_idle_on_suspend(pdev);
>> -
>>   	pdev->dev.pm_domain =&omap_device_pm_domain;
>>
>>   odbfd_exit1:
>> @@ -620,11 +617,9 @@ static int _od_suspend_noirq(struct device *dev)
>>   	ret = pm_generic_suspend_noirq(dev);
>>
>>   	if (!ret&&  !pm_runtime_status_suspended(dev)) {
>> -		if (pm_generic_runtime_suspend(dev) == 0) {
>> -			if (!(od->flags&  OMAP_DEVICE_NO_IDLE_ON_SUSPEND))
>> -				omap_device_idle(pdev);
>> +		if (pm_generic_runtime_suspend(dev) == 0)
>> +			omap_device_idle(pdev);
>>   			od->flags |= OMAP_DEVICE_SUSPENDED;
>> -		}
> Look closely at the if statement, followed by more than one line, and
> the braces removed.
>
> That means that od->flag will be set, even when omap_device_idle() was
> not called.  Which in turn means that upon resume, omap_device_enable()
> will be called on a device that has not had omap_device_idle() called,
> which means there would be WARNs coming from omap_device due to the
> mismatch.
>
True, my bad. Will modify the code to bypass
"od->flags |= OMAP_DEVICE_SUSPENDED"
> Hmm... this does not instill confidence that this code has been tested.
>
Sorry for the above glitch, I tested this code. I checked that the
system is able to resume from suspend state, but completely missed the
following statement in the log..
"[   47.922424] omap_uart omap_uart.2: omap_device: omap_device_enable() 
called from invalid state 1"

> Kevin
>
>
>>   	}
>>
>>   	return ret;
>> @@ -638,8 +633,7 @@ static int _od_resume_noirq(struct device *dev)
>>   	if ((od->flags&  OMAP_DEVICE_SUSPENDED)&&
>>   	!pm_runtime_status_suspended(dev)) {
>>   		od->flags&= ~OMAP_DEVICE_SUSPENDED;
>> -		if (!(od->flags&  OMAP_DEVICE_NO_IDLE_ON_SUSPEND))
>> -			omap_device_enable(pdev);
>> +		omap_device_enable(pdev);
>>   		pm_generic_runtime_resume(dev);
>>   	}
>>
>> diff --git a/arch/arm/mach-omap2/omap_device.h b/arch/arm/mach-omap2/omap_device.h
>> index 044c31d..17ca1ae 100644
>> --- a/arch/arm/mach-omap2/omap_device.h
>> +++ b/arch/arm/mach-omap2/omap_device.h
>> @@ -38,7 +38,6 @@ extern struct dev_pm_domain omap_device_pm_domain;
>>
>>   /* omap_device.flags values */
>>   #define OMAP_DEVICE_SUSPENDED		BIT(0)
>> -#define OMAP_DEVICE_NO_IDLE_ON_SUSPEND	BIT(1)
>>
>>   /**
>>    * struct omap_device - omap_device wrapper for platform_devices
>> @@ -101,13 +100,4 @@ static inline struct omap_device *to_omap_device(struct platform_device *pdev)
>>   {
>>   	return pdev ? pdev->archdata.od : NULL;
>>   }
>> -
>> -static inline
>> -void omap_device_disable_idle_on_suspend(struct platform_device *pdev)
>> -{
>> -	struct omap_device *od = to_omap_device(pdev);
>> -
>> -	od->flags |= OMAP_DEVICE_NO_IDLE_ON_SUSPEND;
>> -}
>> -
>>   #endif

