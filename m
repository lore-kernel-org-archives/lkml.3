Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015Ab3BGQwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:52:05 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:55499 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758830Ab3BGQwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:52:02 -0500
Message-ID: <5113DBAF.2050104@wwwdotorg.org>
Date: Thu, 07 Feb 2013 09:51:59 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "nico@linaro.org" <nico@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>
Subject: Re: [PATCHv3 4/4] arm: Add generic timer broadcast support
References: <1358183124-28461-1-git-send-email-mark.rutland@arm.com> <1358183124-28461-5-git-send-email-mark.rutland@arm.com> <5112C25F.6000508@wwwdotorg.org> <20130207100403.GD16987@e106331-lin.cambridge.arm.com> <511392A8.9010905@ti.com>
In-Reply-To: <511392A8.9010905@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 04:40 AM, Santosh Shilimkar wrote:
> Mark,
> 
> On Thursday 07 February 2013 03:34 PM, Mark Rutland wrote:
>> Hi Stephen,
>>
>> Sorry about this; I'm to blame for the bug.
>>
>> On Wed, Feb 06, 2013 at 08:51:43PM +0000, Stephen Warren wrote:
>>> On 01/14/2013 10:05 AM, Mark Rutland wrote:
>>>> Implement timer_broadcast for the arm architecture, allowing for the
>>>> use
>>>> of clock_event_device_drivers decoupled from the timer tick broadcast
>>>> mechanism.
>>>
>>> Mark, this patch is now in next-20130206 and causes a crash during boot
>>> on Tegra. The reason appears to be because of:
>>>
>>>> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
>>>
>>>> @@ -524,7 +524,6 @@ static void __cpuinit percpu_timer_setup(void)
>>>>       struct clock_event_device *evt = &per_cpu(percpu_clockevent,
>>>> cpu);
>>>>
>>>>       evt->cpumask = cpumask_of(cpu);
>>>> -    evt->broadcast = smp_timer_broadcast;
>>>
>>> After that change, evt->broadcast is never assigned, and hence is NULL.
>>> Yet elsewhere in kernel/time/tick-broadcast.c it's used unconditionally:
>>>
>>> static void tick_do_broadcast(struct cpumask *mask)
>>> ...
>>>     if (!cpumask_empty(mask)) {
>>> ...
>>>         td = &per_cpu(tick_cpu_device, cpumask_first(mask));
>>>         td->evtdev->broadcast(mask);
>>>
>>> Now perhaps the Tegra timer driver simply isn't being set up correctly,
>>> so the bug is there... But the only other place I can find where
>>> ->broadcast is assigned is in tick_device_uses_broadcast() which only
>>> does it for "non-functional" timers, which doesn't apply to Tegra's
>>> timer.
>>
>> The intent of 12ad100046: "clockevents: Add generic timer broadcast
>> function"
>> was to setup the broadcast function both for non-functional/dummy
>> timers and
>> those that stop in low-power states (CLOCK_EVT_FEAT_C3STOP). I missed the
>> CLOCK_EVT_FEAT_C3STOP case.
>
> I am not sure this exactly the case. Because in my testing, the C3STOP
> path was exercised already. And if the C3STOP is used then notifiers
> calls are expected for switching of clock-events to broadcast mode.
> 
> And dummy broad-cast hook should come into picture only if the per CPU
> local timer clock-event are not registered.
> 
> I just tried "next-20130207" on OMAP and I see the broad-cast mechanism
> works and didn't observe any crash.
...
>> I believe the patch below will fix this for Tegra and any other
>> platforms where
>> broadcast is required in low power states.
>>
> Am not sure you really need that patch unless and until am missing a
> scenario in my test.
> 
> Stephan,
> 
> Do we have crash log seen on Tegra ? Which tegra CPUIDLE driver
> is being used when crash is seen ?

The crash log is below. It's simply because td->evt->broadcast is NULL
because it wasn't ever set.

I'm using the CPUIDLE driver in arch/arm/mach-tegra/cpuidle*.c.

> [ 4.179156] Unable to handle kernel NULL pointer dereference at virtual address 00000000
> [ 4.211200] pgd = c0004000
> [ 4.237688] [00000000] *pgd=00000000
> [ 4.264868] Internal error: Oops: 80000005 [#1] PREEMPT SMP ARM
> [ 4.294396] Modules linked in:
> [ 4.320940] CPU: 0 Not tainted (3.8.0-rc6-next-20130206-00002-g2aaa5ff #6)
> [ 4.352125] PC is at 0x0
> [ 4.378346] LR is at tick_do_broadcast.constprop.3+0x74/0xb0
> [ 4.407786] pc : [<00000000>] lr : [<c0063b38>] psr: 20000193
> [ 4.407786] sp : c06d7d60 ip : 00000002 fp : 00000004
> [ 4.466633] r10: c06d2ef8 r9 : c06def08 r8 : c06dec98
> [ 4.495457] r7 : 00000000 r6 : f8b8d230 r5 : c073d598 r4 : 00000000
> [ 4.525825] r3 : 00000000 r2 : 008ac000 r1 : 00000004 r0 : c073d5a4
> [ 4.556192] Flags: nzCv IRQs off FIQs on Mode SVC_32 ISA ARM Segment kernel
> [ 4.587865] Control: 10c5387d Table: 0000404a DAC: 00000015
> [ 4.617983] Process swapper/0 (pid: 0, stack limit = 0xc06d6238)
> [ 4.648314] Stack: (0xc06d7d60 to 0xc06d8000)
> [ 4.677145] 7d60: 00000002 ffffffff 7fffffff c0063c28 00000000 c06f17c0 f8b8d230 00000000
> [ 4.710387] 7d80: c0029b40 c06f1780 ee015ad0 00000000 00000000 00000049 c07186a7 ee015a80
> [ 4.743652] 7da0: 00000001 c0228c2c c0228c08 c0079184 f8b66130 00000000 ee2dc8e8 ee015a80
> [ 4.776806] 7dc0: ee015ad0 c06f1780 fe000100 c06d8080 c06d6000 c04e01ac 00000000 c0079304
> [ 4.810088] 7de0: ee015a80 ee015ad0 c06d7ee8 c007bf38 c007bebc 00000049 00000049 c0078b8c
> [ 4.843304] 7e00: c06d3678 c000eb74 fe00010c c06df040 c06d7e30 c00086d8 c0029acc c0029b40
> [ 4.876440] 7e20: 20000113 ffffffff c06d7e64 c000df40 00000001 c073a100 00000000 00000000
> [ 4.909580] 7e40: 00000202 0000001d 00000000 c06d6000 c06d8080 c06d6000 c04e01ac 00000000
> [ 4.942655] 7e60: 00000000 c06d7e78 c0029acc c0029b40 20000113 ffffffff c06ede80 ee012380
> [ 4.975697] 7e80: c0f7a834 00000000 ffff8c6e 00200000 c01f4290 c06d6000 0000001d 00000000
> [ 5.008939] 7ea0: fe000100 ee1a8b80 c06d6000 c04e01ac 00000000 c0029fa4 c06d3678 c000eb78
> [ 5.042564] 7ec0: fe00010c c06df040 c06d7ee8 c00086d8 c005d5f8 c0325700 60000113 ffffffff
> [ 5.076394] 7ee0: c06d7f1c c000df40 c06d7f30 3b9aca00 f8b59610 00000000 f8105948 00000000
> [ 5.110339] 7f00: c0f763e8 00000001 ee1a8b80 c06d6000 c04e01ac 00000000 00000015 c06d7f30
> [ 5.144383] 7f20: c005d5f8 c0325700 60000113 ffffffff f8b59610 00000000 00000000 c04e01ac
> [ 5.178363] 7f40: 00000000 c0f763e8 c0f763e8 00000001 c06e3de0 c03253ec 00000004 ee1a8b94
> [ 5.212337] 7f60: c0f763e8 c0327290 0000004c c0f763e8 c0761a0c 00000001 c06e3de0 00000000
> [ 5.246703] 7f80: c06e2ab0 c0325504 c06d6000 c06d6000 c0718888 c06de3f4 c04e01ac c000ef74
> [ 5.281026] 7fa0: c06decf8 c06d6000 c07187c0 c0f73d40 ffffffff 411fc090 3fffffff c069f7b4
> [ 5.315263] 7fc0: ffffffff ffffffff c069f2ec 00000000 00000000 c06c86a8 00000000 10c5387d
> [ 5.349498] 7fe0: c06de3f0 c06c86a4 c06e2aa4 0000406a 00000000 00008074 00000000 00000000
> [ 5.383733] [<c0063b38>] (tick_do_broadcast.constprop.3+0x74/0xb0) from [<c0063c28>] (tick_handle_oneshot_broadcast+0xb4/0x108)
> [ 5.421789] [<c0063c28>] (tick_handle_oneshot_broadcast+0xb4/0x108) from [<c0228c2c>] (tegra_timer_interrupt+0x24/0x2c)
> [ 5.459485] [<c0228c2c>] (tegra_timer_interrupt+0x24/0x2c) from [<c0079184>] (handle_irq_event_percpu+0x50/0x194)
> [ 5.497012] [<c0079184>] (handle_irq_event_percpu+0x50/0x194) from [<c0079304>] (handle_irq_event+0x3c/0x5c)
> [ 5.534558] [<c0079304>] (handle_irq_event+0x3c/0x5c) from [<c007bf38>] (handle_fasteoi_irq+0x7c/0x138)
> [ 5.572007] [<c007bf38>] (handle_fasteoi_irq+0x7c/0x138) from [<c0078b8c>] (generic_handle_irq+0x20/0x30)
> [ 5.609920] [<c0078b8c>] (generic_handle_irq+0x20/0x30) from [<c000eb74>] (handle_IRQ+0x38/0x94)
> [ 5.647209] [<c000eb74>] (handle_IRQ+0x38/0x94) from [<c00086d8>] (gic_handle_irq+0x28/0x5c)
> [ 5.684385] [<c00086d8>] (gic_handle_irq+0x28/0x5c) from [<c000df40>] (__irq_svc+0x40/0x70)
> [ 5.721713] Exception stack(0xc06d7e30 to 0xc06d7e78)
> [ 5.755567] 7e20: 00000001 c073a100 00000000 00000000
> [ 5.792782] 7e40: 00000202 0000001d 00000000 c06d6000 c06d8080 c06d6000 c04e01ac 00000000
> [ 5.829856] 7e60: 00000000 c06d7e78 c0029acc c0029b40 20000113 ffffffff
> [ 5.865532] [<c000df40>] (__irq_svc+0x40/0x70) from [<c0029b40>] (__do_softirq+0x84/0x1b8)
> [ 5.903191] [<c0029b40>] (__do_softirq+0x84/0x1b8) from [<c0029fa4>] (irq_exit+0x90/0x98)
> [ 5.940843] [<c0029fa4>] (irq_exit+0x90/0x98) from [<c000eb78>] (handle_IRQ+0x3c/0x94)
> [ 5.978365] [<c000eb78>] (handle_IRQ+0x3c/0x94) from [<c00086d8>] (gic_handle_irq+0x28/0x5c)
> [ 6.016482] [<c00086d8>] (gic_handle_irq+0x28/0x5c) from [<c000df40>] (__irq_svc+0x40/0x70)
> [ 6.054601] Exception stack(0xc06d7ee8 to 0xc06d7f30)
> [ 6.089523] 7ee0: c06d7f30 3b9aca00 f8b59610 00000000 f8105948 00000000
> [ 6.127885] 7f00: c0f763e8 00000001 ee1a8b80 c06d6000 c04e01ac 00000000 00000015 c06d7f30
> [ 6.166169] 7f20: c005d5f8 c0325700 60000113 ffffffff
> [ 6.201233] [<c000df40>] (__irq_svc+0x40/0x70) from [<c0325700>] (cpuidle_wrap_enter+0x48/0x98)
> [ 6.240573] [<c0325700>] (cpuidle_wrap_enter+0x48/0x98) from [<c03253ec>] (cpuidle_enter_state+0x14/0x60)
> [ 6.281197] [<c03253ec>] (cpuidle_enter_state+0x14/0x60) from [<c0327290>] (cpuidle_enter_state_coupled+0x208/0x2a0)
> [ 6.323163] [<c0327290>] (cpuidle_enter_state_coupled+0x208/0x2a0) from [<c0325504>] (cpuidle_idle_call+0xcc/0x11c)
> [ 6.365258] [<c0325504>] (cpuidle_idle_call+0xcc/0x11c) from [<c000ef74>] (cpu_idle+0xb0/0x114)
> [ 6.405790] [<c000ef74>] (cpu_idle+0xb0/0x114) from [<c069f7b4>] (start_kernel+0x2a4/0x2f4)
> [ 6.446051] Code: bad PC value
> [ 6.480872] ---[ end trace 319bbea8753aac77 ]---
> [ 6.517329] Kernel panic- not syncing: Fatal exception in interrupt
> [ 7.944703] SMP: failed to stop secondary CPUs 
