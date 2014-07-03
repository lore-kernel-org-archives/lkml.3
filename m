Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461AbaGCRoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 13:44:08 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:36096 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859AbaGCRoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 13:44:06 -0400
Message-ID: <53B59664.3030809@linaro.org>
Date: Thu, 03 Jul 2014 19:44:04 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: timers & suspend
References: <f270ad9c-9906-445d-9e9a-4d3618787455@BY2FFO11FD039.protection.gbl> <53B54AC2.5040908@linaro.org> <83fa689b-a06a-4f1c-97cb-f7a7121a0f25@BL2FFO11FD041.protection.gbl> <53B5922A.7020006@linaro.org> <b4b5a783-75cb-42f9-a501-7384b750b719@BN1AFFO11FD038.protection.gbl>
In-Reply-To: <b4b5a783-75cb-42f9-a501-7384b750b719@BN1AFFO11FD038.protection.gbl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2014 07:30 PM, Sören Brinkmann wrote:
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
> You mean with your patches, or without? I'd have to check that.

I meant with my patches.

>>>>> It's probably worth mentioning that the suspend state in Zynq does not
>>>>> power off the CPU cores. It just asserts the resets on secondary cores
>>>>> and the primary one waits in wfi.
>>>>
>>>> Why do you need to reset them ?
>>> CPU0 is not reset, but all secondary cores are. That is as close to
>>> power off as we get and works well with hotplug.
>>
>> Ok, I was not aware of this approach. Is there any patchset
>> available in the net ?
> It's in mainline for a while. arch/arm/mach-zynq/platsmp.c defines the
> SMP ops. Zynq's cpu_die/kill result in the CPU reset being asserted. And
> when the core is plugged in again, it gets deasserted and goes through
> the secondary boot path.
> That code is a little cleaned up in our vendor tree, but overall it
> should be the same functionality wise.

Ah, interesting. Thanks for the precision. I was pointing to v3.16-rc3 
and I didn't see the upstream xilinx code. So my patchset is now 
out-dated :(

I will look at the code closely.

Thanks
   -- Daniel






-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

