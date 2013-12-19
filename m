Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471Ab3LSUxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 15:53:15 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:34163 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab3LSUxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 15:53:13 -0500
Message-ID: <52B35CBA.7020202@linaro.org>
Date: Thu, 19 Dec 2013 21:53:14 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Michal Simek <michal.simek@xilinx.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 3/9] clocksource/cadence_ttc: Store timer frequency
 in driver data
References: <1385514296-26702-1-git-send-email-soren.brinkmann@xilinx.com> <1385514296-26702-4-git-send-email-soren.brinkmann@xilinx.com> <5cff3201-db97-4061-a686-bf79ac17d4fe@CO1EHSMHS006.ehs.local> <52B1B6FF.7000400@linaro.org> <ce29829b-3727-46ba-8c46-54273ce04745@DB8EHSMHS003.ehs.local> <52B21A82.7050608@linaro.org> <0d7ba9e5-6a62-415d-86e1-763335645406@CH1EHSMHS002.ehs.local>
In-Reply-To: <0d7ba9e5-6a62-415d-86e1-763335645406@CH1EHSMHS002.ehs.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 07:32 PM, Sören Brinkmann wrote:
> Hi Daniel,
>
> On Wed, Dec 18, 2013 at 10:58:26PM +0100, Daniel Lezcano wrote:
>> On 12/18/2013 05:47 PM, Sören Brinkmann wrote:
>>> Hi Daniel,
>>>
>>> On Wed, Dec 18, 2013 at 03:53:51PM +0100, Daniel Lezcano wrote:
>>>> On 12/17/2013 08:21 PM, Sören Brinkmann wrote:
>>>>> Hi Daniel,
>>>>>
>>>>> On Tue, Nov 26, 2013 at 05:04:50PM -0800, Soren Brinkmann wrote:
>>>>>> It is not allowed to call clk_get_rate() from interrupt context. To
>>>>>> avoid such calls the timer input frequency is stored in the driver's
>>>>>> data struct which makes it accessible to the driver in any context.
>>>>>>
>>>>>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>>>>>> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>>>>>
>>>>> I doubt that we'll resolve all issues with this series before the
>>>>> holidays or even the next merge window. Could you take this patch into
>>>>> your tree for 3.14? It is not directly related to the cpufreq work and
>>>>> fixes an actual issue that triggers a kernel WARN under some condition
>>>>> (I missed preserving the details and the trace). That would take the
>>>>> easy stuff out of the way and we can focus on the more controversial
>>>>> changes.
>>>>
>>>> You are asking to take it for 3.14 but shouldn't it go as a 3.13 fix ?
>>>
>>> That's also an option. As I remember, the patch fixes a kernel WARN. The
>>> system still seemed operational though. Up to you whether this is
>>> considered severe enough for the 3.13 series. I'm happy either way.
>>
>> I was not able to reproduce the WARN with my board.
>>
>> Please, could you give the WARN or give the procedure to reproduce it ?
>
> I can't either... I thought I saw the WARN on a vanilla kernel during
> boot (IIRC, when cpuidle started). Is there any chance the timer core
> calls the timer's set_mode() from interrupt context?
> Anyway, let's drop it for now. I'll make sure to record more information
> in case it reappears.

Finally I was able to reproduce it with the highres timers disabled, the 
periodic tick system and the locks debug.

Indeed, we are in an interrupt context (IPI) and we are calling 
clk_get_rate in the the set_mode function which in turn ends up by 
getting a mutex... Even if that does not hang, it is a potential kernel 
crash so I will apply the patch with an updated changelog.

------------[ cut here ]------------
WARNING: CPU: 1 PID: 0 at 
/home/dlezcano/Work/src/cpuidle-next/kernel/mutex.c:856 
mutex_trylock+0x70/0x1fc()
DEBUG_LOCKS_WARN_ON(in_interrupt())
Modules linked in:
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.12.0-xilinx-dirty #93
[<c0014a78>] (unwind_backtrace+0x0/0x11c) from [<c0011b6c>] 
(show_stack+0x10/0x14)
[<c0011b6c>] (show_stack+0x10/0x14) from [<c039120c>] (dump_stack+0x7c/0xc0)
[<c039120c>] (dump_stack+0x7c/0xc0) from [<c001fda4>] 
(warn_slowpath_common+0x60/0x84)
[<c001fda4>] (warn_slowpath_common+0x60/0x84) from [<c001fe48>] 
(warn_slowpath_fmt+0x2c/0x3c)
[<c001fe48>] (warn_slowpath_fmt+0x2c/0x3c) from [<c0392658>] 
(mutex_trylock+0x70/0x1fc)
[<c0392658>] (mutex_trylock+0x70/0x1fc) from [<c02dfc08>] 
(clk_prepare_lock+0xc/0xe4)
[<c02dfc08>] (clk_prepare_lock+0xc/0xe4) from [<c02e099c>] 
(clk_get_rate+0xc/0x44)
[<c02e099c>] (clk_get_rate+0xc/0x44) from [<c02d0394>] 
(ttc_set_mode+0x34/0x78)
[<c02d0394>] (ttc_set_mode+0x34/0x78) from [<c005f794>] 
(clockevents_set_mode+0x28/0x5c)
[<c005f794>] (clockevents_set_mode+0x28/0x5c) from [<c00607fc>] 
(tick_broadcast_on_off+0x190/0x1c0)
[<c00607fc>] (tick_broadcast_on_off+0x190/0x1c0) from [<c005f168>] 
(clockevents_notify+0x58/0x1ac)
[<c005f168>] (clockevents_notify+0x58/0x1ac) from [<c02b99dc>] 
(cpuidle_setup_broadcast_timer+0x20/0x24)
[<c02b99dc>] (cpuidle_setup_broadcast_timer+0x20/0x24) from [<c006cd04>] 
(generic_smp_call_function_single_interrupt+0)
[<c006cd04>] (generic_smp_call_function_single_interrupt+0xe0/0x130) 
from [<c00138c8>] (handle_IPI+0x88/0x118)
[<c00138c8>] (handle_IPI+0x88/0x118) from [<c0008504>] 
(gic_handle_irq+0x58/0x60)
[<c0008504>] (gic_handle_irq+0x58/0x60) from [<c0012644>] 
(__irq_svc+0x44/0x78)
Exception stack(0xef099fa0 to 0xef099fe8)
9fa0: 00000001 ef092100 00000000 ef092100 ef098000 00000015 c0399f2c 
c0579d74
9fc0: 0000406a 413fc090 00000000 00000000 00000000 ef099fe8 c00666ec 
c000f46c
9fe0: 20000113 ffffffff
[<c0012644>] (__irq_svc+0x44/0x78) from [<c000f46c>] 
(arch_cpu_idle+0x34/0x3c)
[<c000f46c>] (arch_cpu_idle+0x34/0x3c) from [<c0053980>] 
(cpu_startup_entry+0xa8/0x10c)
[<c0053980>] (cpu_startup_entry+0xa8/0x10c) from [<000085a4>] (0x85a4)
---[ end trace 8185ad1c7a65f6e7 ]---

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

