Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbaCYSjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:39:43 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:49974 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaCYSjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 14:39:41 -0400
Message-ID: <5331CD43.1010601@ahsoftware.de>
Date: Tue, 25 Mar 2014 19:38:59 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sebastian Capella <sebastian.capella@linaro.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Len Brown <len.brown@intel.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Austin <jonathan.austin@arm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Sricharan R <r.sricharan@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Russ Dill <Russ.Dill@ti.com>,
        Nicolas Pitre <nico@linaro.org>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH v7 2/2] ARM hibernation / suspend-to-disk
References: <1394016605-24120-1-git-send-email-sebastian.capella@linaro.org>	<1394016605-24120-3-git-send-email-sebastian.capella@linaro.org>	<20140316070917.GA3094@arch.cereza>	<CADHgK6s58EJyJxB-47K8w26H8ZCBFQ2zu7PGAQU9O+2g7=fPwA@mail.gmail.com>	<20140317204410.GA1118@arch.cereza>	<CADHgK6tHngKVZS=jo=VYt3Nt3dhiEmiWr28iDy7q_uR9goBj=Q@mail.gmail.com>	<20140319154434.GA3488@arch.cereza>	<CADHgK6vLB3h0zrdpve=ZyjNu2pe1VYsGxrYgv=2C-JV37vE9tQ@mail.gmail.com> <CADHgK6vkwjXyJxRcOXjJpJJaR0-YR869NpPZ+CBBS8kEdE0qCQ@mail.gmail.com>
In-Reply-To: <CADHgK6vkwjXyJxRcOXjJpJJaR0-YR869NpPZ+CBBS8kEdE0qCQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 19.03.2014 22:06, schrieb Sebastian Capella:
> On 19 March 2014 13:47, Sebastian Capella <sebastian.capella@linaro.org> wrote:
>> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
>> index a5f702a..d96b910 100644
>> --- a/kernel/power/hibernate.c
>> +++ b/kernel/power/hibernate.c
>> @@ -594,7 +594,8 @@ static void power_down(void)
>>          case HIBERNATION_PLATFORM:
>>                  hibernation_platform_enter();
>>          case HIBERNATION_SHUTDOWN:
>> -               kernel_power_off();
>> +               if (pm_power_off)
>> +                       kernel_power_off();
>>                  break;
>>   #ifdef CONFIG_SUSPEND
>>          case HIBERNATION_SUSPEND:
>>
>>
>> This follows the behavior in the reboot syscall which does it this way
>> also.  I'm testing this now, and it seems work fine.  If this looks
>> good, I can add it as an additional patch.
>
> BTW, one thing I would point out is that kernel_power_off and
> kernel_halt call the same notifier but with different parameters
> (SYS_POWER_OFF and SYS_HALT).
>
> If pm_power_down is null, I dont see why we'd want to notify
> SYS_POWER_OFF before SYS_HALT.  With the previous change I'm assuming
> there's no benefit, so please chime in if you know a reason.

Both states, power off and sys halt, do sound pretty final and I would 
assume something is broken, if power off is called before sys halt or 
vice versa. At least I would never expect that the 
reboot/poweroff/syshalt notifier may be called twice (and thats why the 
heartbeat-trigger may crash).

But just in case, changing that behaviour in ledtrig-heartbeat.c would 
be pretty easy, just remove the heartbeat_reboot_notifier (which plays 
nice and deregisters the trigger on reboot) and use the panic_notifier 
(which doesn't unregister the trigger but just turns off the led) for 
reboot too. Another solution would be to unregister the reboot_notifier 
in the reboot_nofifier itself. I've just seen one watchdog driver 
(drivers/rtc/rtc-m41t80.c) which does that. But I still think such 
shouldn't be necessary (and I haven't had a look at other 
reboot_notifier users).


Regards,

Alexander Holler
