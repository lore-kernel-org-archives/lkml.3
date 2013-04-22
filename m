Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab3DVFvT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 01:51:19 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41421 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab3DVFvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 01:51:18 -0400
Message-ID: <5174CFA3.6020402@ti.com>
Date: Mon, 22 Apr 2013 11:20:27 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <linux-serial@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] arm: mach-omap2: remove "OMAP_DEVICE_NO_IDLE_ON_SUSPEND"
 check
References: <1366198467-6757-1-git-send-email-sourav.poddar@ti.com>	<1366198467-6757-5-git-send-email-sourav.poddar@ti.com>	<87li8f4sum.fsf@linaro.org> <5170434C.7040706@ti.com>	<874nf31opn.fsf@linaro.org> <51714CCC.9090800@ti.com> <871ua6zi6w.fsf@linaro.org>
In-Reply-To: <871ua6zi6w.fsf@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,
On Friday 19 April 2013 08:22 PM, Kevin Hilman wrote:
> Sourav Poddar<sourav.poddar@ti.com>  writes:
>
> [...]
>
>> Yes, got your point. omap_device_idle should not be called only
>> for console uart.
>>
>> Just did a quick testing by including the following hunk on top of my
>> patch series..
>>
>> diff --git a/arch/arm/mach-omap2/omap_device.c
>> b/arch/arm/mach-omap2/omap_device.c
>> index c226946..7480e87 100644
>> --- a/arch/arm/mach-omap2/omap_device.c
>> +++ b/arch/arm/mach-omap2/omap_device.c
>> @@ -617,8 +617,10 @@ static int _od_suspend_noirq(struct device *dev)
>>          ret = pm_generic_suspend_noirq(dev);
>>
>>          if (!ret&&  !pm_runtime_status_suspended(dev)) {
>> -               if (pm_generic_runtime_suspend(dev) == 0)
>> +               if (pm_generic_runtime_suspend(dev) == 0) {
>> +                       omap_device_idle(pdev);
>>                          od->flags |= OMAP_DEVICE_SUSPENDED;
>> +               }
>>          }
>>
>>          return ret;
>> @@ -631,6 +633,7 @@ static int _od_resume_noirq(struct device *dev)
>>
>>          if ((od->flags&  OMAP_DEVICE_SUSPENDED)&&
>>              !pm_runtime_status_suspended(dev)) {
>> +               omap_device_enable(pdev);
>>                  od->flags&= ~OMAP_DEVICE_SUSPENDED;
>>                  pm_generic_runtime_resume(dev);
>>          }
>> And found the wakeup from UART is no more functional.
>> So, the omap_device_idle gets called for console UART also, thereby
>> preventing the "no_idle_on_suspend" theory.
>>
>> Hence, merely putting prepare/complete callback the way I did is not
>> helping.
>> We need to delete omap_device_idle also, which I agree is not correct.
>> So, we need a way to bypass this "omap_device_idle"
>> call for console UART. ?
> OK, I see what's happening now.
>
> How about this: rather than using prepare/complete callbacks, can you
> use the runtime_suspend callback to return an error code during suspend?
Yes, that can be done.
> (only for the console, and only when no_console_suspend is enabled, and
> only during suspend)
>
> Since _od_suspend_noirq checks to be sure the drivers ->runtime_suspend
> callback succeeds before it calls omap_device_idle(), if you report a
> failure, omap_device_idle will not be called.
>
True.

~Sourav
> Kevin
>
>

