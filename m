Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaBOEMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 23:12:18 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:47375 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaBOEMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 23:12:16 -0500
MIME-Version: 1.0
In-Reply-To: <CANhyOUcBrsnfSa3sCGbFqUB0g6zfG9moqbGapJGU3zbxWQVgiA@mail.gmail.com>
References: <1392260923-31659-1-git-send-email-t.dakhran@samsung.com>
	<52FCBC42.6020904@samsung.com>
	<CANhyOUcBrsnfSa3sCGbFqUB0g6zfG9moqbGapJGU3zbxWQVgiA@mail.gmail.com>
Date: Sat, 15 Feb 2014 13:12:14 +0900
Message-ID: <CANhyOUfm8D70OU2QJWH-JyzLuqhcfza1OcTECKbbPbyXDaut_g@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] exynos_mct driver: fix irq allocation and cleanup
From: Tarek Dakhran <t.dakhran@gmail.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Tarek Dakhran <t.dakhran@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Tarek Dakhran <t.dakhran@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 10:31 PM, Tarek Dakhran <t.dakhran@gmail.com> wrote:
> Hi Tomasz,
>
> On Thursday, February 13, 2014, Tomasz Figa <t.figa@samsung.com> wrote:
>>
>> Hi Tarek,
>>
>> On 13.02.2014 04:08, Tarek Dakhran wrote:
>>>
>>> exynos4_local_timer_setup called on the secondary cpu before
>>> irqs are enabled. request_irq can sleep, which produces next warning:
>>>
>>> on boot:
>>> [    0.370000] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
>>> [    0.370000] Setting up static identity map for 0x403b5700 - 0x403b5758
>>> [    0.395000] CPU1: Booted secondary processor
>>> [    0.395000] ------------[ cut here ]------------
>>> [    0.395000] WARNING: CPU: 1 PID: 0 at kernel/locking/lockdep.c:2742
>>> lockdep_trace_alloc+0xe0/0xfc()
>>> [    0.395000] DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags))
>>> [    0.395000] Modules linked in:
>>> [    0.395000] CPU: 1 PID: 0 Comm: swapper/1 Not tainted
>>> 3.14.0-rc2-00004-g0db95f4 #128
>>> [    0.395000] [<c0014308>] (unwind_backtrace) from [<c0011690>]
>>> (show_stack+0x10/0x14)
>>> [    0.395000] [<c0011690>] (show_stack) from [<c03ae7d0>]
>>> (dump_stack+0x6c/0xb8)
>>> [    0.395000] [<c03ae7d0>] (dump_stack) from [<c001d504>]
>>> (warn_slowpath_common+0x68/0x8c)
>>> [    0.395000] [<c001d504>] (warn_slowpath_common) from [<c001d5bc>]
>>> (warn_slowpath_fmt+0x30/0x40)
>>> [    0.395000] [<c001d5bc>] (warn_slowpath_fmt) from [<c0059824>]
>>> (lockdep_trace_alloc+0xe0/0xfc)
>>> [    0.395000] [<c0059824>] (lockdep_trace_alloc) from [<c00bee24>]
>>> (kmem_cache_alloc+0x24/0x160)
>>> [    0.395000] [<c00bee24>] (kmem_cache_alloc) from [<c0068174>]
>>> (request_threaded_irq+0x64/0x130)
>>> [    0.395000] [<c0068174>] (request_threaded_irq) from [<c02efaf8>]
>>> (exynos4_local_timer_setup+0xd0/0x124)
>>> [    0.395000] [<c02efaf8>] (exynos4_local_timer_setup) from [<c02efc34>]
>>> (exynos4_mct_cpu_notify+0x78/0xf0)
>>> [    0.395000] [<c02efc34>] (exynos4_mct_cpu_notify) from [<c003d318>]
>>> (notifier_call_chain+0x44/0x84)
>>> [    0.395000] [<c003d318>] (notifier_call_chain) from [<c001d61c>]
>>> (__cpu_notify+0x24/0x40)
>>> [    0.395000] [<c001d61c>] (__cpu_notify) from [<c0013314>]
>>> (secondary_start_kernel+0xe4/0x134)
>>> [    0.395000] [<c0013314>] (secondary_start_kernel) from [<40008624>]
>>> (0x40008624)
>>> [    0.395000] ---[ end trace 347890460e745f50 ]---
>>> [    0.420000] CPU1: update cpu_power 1024
>>> [    0.420000] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
>>>
>>> on hotplug:
>>> [  108.040000] CPU3: Booted secondary processor
>>> [  108.040000] BUG: sleeping function called from invalid context at
>>> mm/slub.c:965
>>> [  108.040000] in_atomic(): 1, irqs_disabled(): 128, pid: 0, name:
>>> swapper/3
>>> [  108.040000] INFO: lockdep is turned off.
>>> [  108.040000] irq event stamp: 0
>>> [  108.040000] hardirqs last  enabled at (0): [<  (null)>]   (null)
>>> [  108.040000] hardirqs last disabled at (0): [<c001b768>]
>>> copy_process.part.2+0x2a4/0x12f4
>>> [  108.040000] softirqs last  enabled at (0): [<c001b768>]
>>> copy_process.part.2+0x2a4/0x12f4
>>> [  108.040000] softirqs last disabled at (0): [<  (null)>]   (null)
>>> [  108.040000] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G        W
>>> 3.14.0-rc2-00004-g0db95f4 #128
>>> [  108.040000] [<c0014308>] (unwind_backtrace) from [<c0011690>]
>>> (show_stack+0x10/0x14)
>>> [  108.040000] [<c0011690>] (show_stack) from [<c03ae7d0>]
>>> (dump_stack+0x6c/0xb8)
>>> [  108.040000] [<c03ae7d0>] (dump_stack) from [<c00beed4>]
>>> (kmem_cache_alloc+0xd4/0x160)
>>> [  108.040000] [<c00beed4>] (kmem_cache_alloc) from [<c0068174>]
>>> (request_threaded_irq+0x64/0x130)
>>> [  108.040000] [<c0068174>] (request_threaded_irq) from [<c02efaf8>]
>>> (exynos4_local_timer_setup+0xd0/0x124)
>>> [  108.040000] [<c02efaf8>] (exynos4_local_timer_setup) from [<c02efc34>]
>>> (exynos4_mct_cpu_notify+0x78/0xf0)
>>> [  108.040000] [<c02efc34>] (exynos4_mct_cpu_notify) from [<c003d318>]
>>> (notifier_call_chain+0x44/0x84)
>>> [  108.040000] [<c003d318>] (notifier_call_chain) from [<c001d61c>]
>>> (__cpu_notify+0x24/0x40)
>>> [  108.040000] [<c001d61c>] (__cpu_notify) from [<c0013314>]
>>> (secondary_start_kernel+0xe4/0x134)
>>> [  108.040000] [<c0013314>] (secondary_start_kernel) from [<40008624>]
>>> (0x40008624)
>>>
>>> First patch fixes this problem by removing request_irq from
>>> exynos4_local_timer_setup
>>> Second removes non-dt stuff.
>>>
>>> Tested on linux kernel v3.14-rc2.
>>
>>
>> It would be nice to say on which boards it has been tested. Let me check
>> this on our boards anyway.
>>
>> Best regards,
>> Tomasz
>
>
> Tested on smdk5410 reference board with lockdep enabled.
> I think the problem will present on all boards due to call sleeping function
> in irq_disabled context.
>
> Best Regards,
>     Tarek
>
Has anyone else tested this patches?
if yes, what is the result?


Best regards,
. Tarek
