Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375AbaGCRq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 13:46:26 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:61754 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaGCRqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 13:46:25 -0400
Message-ID: <53B596F0.7020507@linaro.org>
Date: Thu, 03 Jul 2014 19:46:24 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: timers & suspend
References: <f270ad9c-9906-445d-9e9a-4d3618787455@BY2FFO11FD039.protection.gbl> <53B54AC2.5040908@linaro.org> <83fa689b-a06a-4f1c-97cb-f7a7121a0f25@BL2FFO11FD041.protection.gbl> <53B5922A.7020006@linaro.org> <12596549-d0f6-43b6-810d-ccd908404364@BL2FFO11FD055.protection.gbl>
In-Reply-To: <12596549-d0f6-43b6-810d-ccd908404364@BL2FFO11FD055.protection.gbl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2014 07:40 PM, Sören Brinkmann wrote:
> On Thu, 2014-07-03 at 07:26PM +0200, Daniel Lezcano wrote:
>> On 07/03/2014 06:09 PM, Sören Brinkmann wrote:
>>> On Thu, 2014-07-03 at 02:21PM +0200, Daniel Lezcano wrote:
>>>> On 06/30/2014 08:39 PM, Sören Brinkmann wrote:
>>>>> Hi,
>>>>>
>>>>> I'm currently working on suspend for Zynq and try to track down some
>>>>> spurious wakes. It looks like the spurious wakes are caused by timers,
>>>>> hence I was wondering whether there are any special requirements for
>>>>> timer drivers when it comes to suspend support or if I just missed
>>>>> something.
>>>>>
>>>>> Zynq sets the 'IRQCHIP_MASK_ON_SUSPEND' flag, which should mask all
>>>>> interrupts but the wake source. Reading through kernel/irq/pm.c
>>>>> indicates, that timer interrupts get some special treatment though.
>>>>> Therefore I implemented some suspend/resume callbacks for the
>>>>> cadence_ttc which disable and clear the timer's interrupts when going
>>>>> into suspend. That seems to mitigate the issue quite a bit, but I still
>>>>> saw spurious wakes - just a lot less often.
>>>>> Digging a little deeper revealed, the spurious wakes are caused by the
>>>>> ARM's smp_twd timer now. Given that that driver is probably used by a few
>>>>> more ARM platforms, I get the feeling that I'm missing something.
>>>>
>>>> Do you receive any interrupt from the cadence_ttc ? (/proc/interrupts)
>>>>
>>>> That's funny because I realize that you cadence ttc timer is never
>>>> used as there are the architected timers. The cadence ttc would be
>>>> only useful if there were an idle state powering down the smp_twd
>>>> timers but it is not the case on this board, IIUC.
>>> Yes they are used. They TTC is the only broadcast capable timer for
>>> Zynq. In my experience, I can not even boot without it (may have
>>> dependencies on CPUidle or something).
>>
>> Actually the cpuidle driver is wrong. It assumes the state #1 will
>> power off the different cores with their architected timers and then
>> switch to the broadcast timer. But this one is not needed as we
>> don't power down the core with the twd timers, so no need to switch
>> to a backup timer device.
>>
>> The implementation of the DDR self refresh idle state (incoming
>> patchset) removes the cpu_pm notifiers + the flag TIMER_STOP. The
>> result is 0 interrupts for ttc cadence timer. I removed in the dts
>> the cadence ttc and my board booted without problem (it is a zynq
>> 702).
>>
>> Except I missed something, the cadence ttc is actually not used at all.
> I tested on the current master branch. I see TTC interrupts on CPU0 and
> timer_list shows the TTC to be the broadcast device. Removing the TTC
> nodes from my DT results in boot hanging - shortly after cpuidle is
> started.
>
> Removing cpuidle from my kernel makes the system boot. And it has no
> broadcast device anymore.

You can safely remove the CPUIDLE_FLAG_TIMER_STOP in the cpuidle drivers 
and I am pretty sure it will boot without problem.

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

