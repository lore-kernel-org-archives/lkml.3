Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935782Ab3DINeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 09:34:37 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:48173 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759206Ab3DINef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 09:34:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAFp+6iE-ZYSNHZBntTcX8fESLB2FXOr6idM8_Q3Rd7T3s_c4Dw@mail.gmail.com>
References: <1365500744-14839-1-git-send-email-gautam.vivek@samsung.com>
	<5163E8EB.1050803@samsung.com>
	<CAFp+6iE-ZYSNHZBntTcX8fESLB2FXOr6idM8_Q3Rd7T3s_c4Dw@mail.gmail.com>
Date: Tue, 9 Apr 2013 19:04:34 +0530
Message-ID: <CAFp+6iGS-4iv-PKTKP4OhwVvTsDoPnc-9N-6AAr5x=Bz9r=vTw@mail.gmail.com>
Subject: Re: [PATCH RFC] rtc: rtc-s3c: use clk_prepare_enable and clk_disable_unprepare
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        a.zummo@towertech.it, kgene.kim@samsung.com, dianders@chromium.org,
        Thomas Abraham <thomas.ab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,


On Tue, Apr 9, 2013 at 6:21 PM, Vivek Gautam <gautamvivek1987@gmail.com> wrote:
> Hi Sylwester,
>
>
> On Tue, Apr 9, 2013 at 3:39 PM, Sylwester Nawrocki
> <s.nawrocki@samsung.com> wrote:
>> On 04/09/2013 11:45 AM, Vivek Gautam wrote:
>>> Convert clk_enable/clk_disable to clk_prepare_enable/clk_disable_unprepare
>>> calls as required by common clock framework, to get rid of
>>> WARN_ON on prepare_count.
>>
>> Hmm, do you think warnings like below are any better that WARN_ON() on wrong
>> clock's prepare_count value ? :)
>>
>>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>>> ---
>>>
>>> This fixes the warnings in the boot log coming out of enabling
>>> the common clock framework in exynos platform.
>>>
>>> However, on doing system suspend/resume using rtc wake mechanism
>>> we still get following warning dump for the first time we suspend
>>> using commands:
>>>     echo +10 > /sys/class/rtc/rtc0/wakealarm
>>>     echo mem > /sys/power/state
>>>
>>> [   12.530000] ------------[ cut here ]------------
>>> [   12.530000] WARNING: at kernel/mutex.c:199 __mutex_lock_slowpath+0x2c0/0x340()
>>> [   12.530000] Modules linked in:
>>> [   12.530000] [<80014c60>] (unwind_backtrace+0x0/0xf8) from [<8001ebd0>] (warn_slowpath_common+0x54/0x68)
>>> [   12.530000] [<8001ebd0>] (warn_slowpath_common+0x54/0x68) from [<8001ec00>] (warn_slowpath_null+0x1c/0x24)
>>> [   12.530000] [<8001ec00>] (warn_slowpath_null+0x1c/0x24) from [<8033f548>] (__mutex_lock_slowpath+0x2c0/0x340)
>>> [   12.530000] [<8033f548>] (__mutex_lock_slowpath+0x2c0/0x340) from [<8033f5d4>] (mutex_lock+0xc/0x24)
>>> [   12.530000] [<8033f5d4>] (mutex_lock+0xc/0x24) from [<80299e18>] (clk_prepare+0x18/0x34)
>>> [   12.530000] [<80299e18>] (clk_prepare+0x18/0x34) from [<802862d8>] (s3c_rtc_alarmirq+0x1c/0x98)
>>> [   12.530000] [<802862d8>] (s3c_rtc_alarmirq+0x1c/0x98) from [<8006ad78>] (handle_irq_event_percpu+0x54/0x194)
>>> [   12.530000] [<8006ad78>] (handle_irq_event_percpu+0x54/0x194) from [<8006aef4>] (handle_irq_event+0x3c/0x5c)
>>> [   12.530000] [<8006aef4>] (handle_irq_event+0x3c/0x5c) from [<8006db00>] (handle_fasteoi_irq+0xa4/0x134)
>>> [   12.530000] [<8006db00>] (handle_fasteoi_irq+0xa4/0x134) from [<8006a594>] (generic_handle_irq+0x30/0x40)
>>> [   12.530000] [<8006a594>] (generic_handle_irq+0x30/0x40) from [<8000f4fc>] (handle_IRQ+0x40/0x90)
>>> [   12.530000] [<8000f4fc>] (handle_IRQ+0x40/0x90) from [<80008544>] (gic_handle_irq+0x38/0x68)
>>> [   12.530000] [<80008544>] (gic_handle_irq+0x38/0x68) from [<8000e200>] (__irq_svc+0x40/0x70)
>>> [   12.530000] Exception stack(0x8182be60 to 0x8182bea8)
>>> [   12.530000] be60: 00000000 00000000 0000000c ffffffff 60000013 8049fc50 00000000 80479a10
>>> [   12.530000] be80: 60000013 ee97de98 804799c0 00000001 0000000d 8182bea8 803412dc 803412e0
>>> [   12.530000] bea0: 60000013 ffffffff
>>> [   12.530000] [<8000e200>] (__irq_svc+0x40/0x70) from [<803412e0>] (_raw_spin_unlock_irqrestore+0x10/0x38)
>>> [   12.530000] [<803412e0>] (_raw_spin_unlock_irqrestore+0x10/0x38) from [<80070bc4>] (resume_irqs+0x9c/0xb8)
>>> [   12.530000] [<80070bc4>] (resume_irqs+0x9c/0xb8) from [<8021d528>] (dpm_resume_start+0xc/0x18)
>>> [   12.530000] [<8021d528>] (dpm_resume_start+0xc/0x18) from [<800544ac>] (suspend_devices_and_enter+0x118/0x2e4)
>>> [   12.530000] [<800544ac>] (suspend_devices_and_enter+0x118/0x2e4) from [<80054814>] (pm_suspend+0x19c/0x214)
>>> [   12.530000] [<80054814>] (pm_suspend+0x19c/0x214) from [<80053a58>] (state_store+0x120/0x12c)
>>> [   12.530000] [<80053a58>] (state_store+0x120/0x12c) from [<801ae9d8>] (kobj_attr_store+0x14/0x20)
>>> [   12.530000] [<801ae9d8>] (kobj_attr_store+0x14/0x20) from [<801092c8>] (sysfs_write_file+0xfc/0x17c)
>>> [   12.530000] [<801092c8>] (sysfs_write_file+0xfc/0x17c) from [<800b0d84>] (vfs_write+0xa8/0x138)
>>> [   12.530000] [<800b0d84>] (vfs_write+0xa8/0x138) from [<800b10e4>] (sys_write+0x40/0x68)
>>> [   12.530000] [<800b10e4>] (sys_write+0x40/0x68) from [<8000e600>] (ret_fast_syscall+0x0/0x30)
>>> [   12.530000] ---[ end trace 8643216fba2e8cb5 ]---
>>>
>>>  drivers/rtc/rtc-s3c.c |   58 ++++++++++++++++++++++++------------------------
>>>  1 files changed, 29 insertions(+), 29 deletions(-)
>>>
>>> diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
>>> index fb994e9..75637ad 100644
>>> --- a/drivers/rtc/rtc-s3c.c
>>> +++ b/drivers/rtc/rtc-s3c.c
>>> @@ -65,12 +65,12 @@ static void s3c_rtc_alarm_clk_enable(bool enable)
>>>       spin_lock_irqsave(&s3c_rtc_alarm_clk_lock, irq_flags);
>>>       if (enable) {
>>>               if (!alarm_clk_enabled) {
>>> -                     clk_enable(rtc_clk);
>>> +                     clk_prepare_enable(rtc_clk);
>>>                       alarm_clk_enabled = true;
>>>               }
>>>       } else {
>>>               if (alarm_clk_enabled) {
>>> -                     clk_disable(rtc_clk);
>>> +                     clk_disable_unprepare(rtc_clk);
>>>                       alarm_clk_enabled = false;
>>>               }
>>>       }
>>> @@ -83,13 +83,13 @@ static irqreturn_t s3c_rtc_alarmirq(int irq, void *id)
>>>  {
>>>       struct rtc_device *rdev = id;
>>>
>>> -     clk_enable(rtc_clk);
>>> +     clk_prepare_enable(rtc_clk);
>>
>> The reason for the above failure is that clk_prepare is called from an interrupt
>> context. You are not supposed to use clk_prepare_enable()/clk_unprepare_disble()
>> like this. Instead, prepare the clock in s3c_rtc_probe() and unprepare in the
>> driver's remove() callback. And clk_enable()/clk_disable calls could stay untouched.
>
> Aah !! actually missed a similar patch from Thomas Abraham :(
> doing the same as suggested by you.
> Its available at:
> http://patchwork.ozlabs.org/patch/188687/

There's a change required in the above mentioned patch, so possibly
Thomas can go ahead and post the next version
of that.



-- 
Thanks & Regards
Vivek
