Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330Ab3KHUpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 15:45:41 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:56230 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758284Ab3KHUpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 15:45:35 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <CAOesGMhjC=NDn4YiY4tQ3ZcW_rK9_qOY03CVD1eyVFC74ucdrA@mail.gmail.com>
References: <526DBEAA.4030707@linaro.org>
	<1382984701-2371-1-git-send-email-sboyd@codeaurora.org>
	<878uxcq1m7.fsf@linaro.org>
	<20131029060058.GD21983@codeaurora.org>
	<CAOesGMhjC=NDn4YiY4tQ3ZcW_rK9_qOY03CVD1eyVFC74ucdrA@mail.gmail.com>
Date: Fri, 8 Nov 2013 12:45:34 -0800
Message-ID: <CAOesGMhB2Akf_B2_J3LVdt1bDvcsTE7+8Kq=NvsXmkf3EwGsiw@mail.gmail.com>
Subject: Re: [PATCH] ARM: Support arch_irq_work_raise() via self IPIs
From: Olof Johansson <olof@lixom.net>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Kevin Hilman <khilman@linaro.org>, Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 8, 2013 at 12:06 PM, Olof Johansson <olof@lixom.net> wrote:
> On Mon, Oct 28, 2013 at 11:00 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> On 10/28, Kevin Hilman wrote:
>>> Stephen Boyd <sboyd@codeaurora.org> writes:
>>>
>>> > This will allow the scheduler tick to be restarted if we're in
>>> > full NOHZ mode.
>>> >
>>> > Cc: Kevin Hilman <khilman@linaro.org>
>>> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
>>> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>>>
>>> Minor nit, but I'd prefer a more verbose changelog (I forget things
>>> quickly and like to rely on changelogs for my memory.)  Probably worth
>>> adding something like: "By default, irq_work is tied to the tick
>>> processing (update_process_times()) but in full NOHZ mode, no tick means
>>> no IRQ work.  In order for IRQ work to be done in full NOHZ mode, a
>>> self-IPI is used to process IRQ work."
>>>
>>> Other than the changelog nit, patch looks good, feel free to add
>>>
>>> Reviewed-by: Kevin Hilman <khilman@linaro.org>
>>>
>>> If Russell is OK with this, it can go to his patch system.
>>>
>>
>> Fair enough. This is what I came up with. I'll send it off to the
>> patch tracker in about 12 hours if nobody else has anymore
>> comments.
>>
>> ----8<-----
>> ARM: Support arch_irq_work_raise() via self IPIs
>>
>> By default, IRQ work is run from the tick interrupt (see
>> irq_work_run() in update_process_times()). When we're in full
>> NOHZ mode, restarting the tick requires the use of IRQ work and
>> if the only place we run IRQ work is in the tick interrupt we
>> have an unbreakable cycle. Implement arch_irq_work_raise() via
>> self IPIs to break this cycle and get the tick started again.
>> Note that we implement this via IPIs which are only available on
>> SMP builds. This shouldn't be a problem because full NOHZ is only
>> supported on SMP builds anyway.
>>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> Reviewed-by: Kevin Hilman <khilman@linaro.org>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>
>
> Hm, so I think this just landed in -next, which seems... late for
> 3.13. Anyway, it causes boot failures on Cubieboards (Allwinner A10),
> I just bisected it down to this patch (fails to boot
> multi_v7_defconfig, no console output at all).
>
> Unfortunately I'm not getting any debug_ll output from the board at
> the moment, so I can't actually get to a panic stack or other error
> info. :( I hope I can get back to you with one later today.

Turns out that I hit this on the BeagleBone as well, and I got a trace
out of it. Seems like this might be broken on all non-SMP platforms
built with CONFIG_SMP=y?


[    0.206322] Unable to handle kernel NULL pointer dereference at
virtual address 00000000
[    0.214752] pgd = c0004000
[    0.217628] [00000000] *pgd=00000000
[    0.221421] Internal error: Oops: 80000005 [#1] SMP ARM
[    0.226890] Modules linked in:
[    0.230136] CPU: 0 PID: 1 Comm: swapper/0 Not tainted
3.12.0-rc6-00018-g8d45144-dirty #16
[    0.238646] task: de05b440 ti: de05c000 task.ti: de05c000
[    0.244294] PC is at 0x0
[    0.247010] LR is at arch_irq_work_raise+0x3c/0x48
[    0.252034] pc : [<00000000>]    lr : [<c0019590>]    psr: 60000193
[    0.252034] sp : de05dd60  ip : 00000001  fp : 00000000
[    0.264029] r10: c085e2f0  r9 : de05c000  r8 : c07be0a4
[    0.269496] r7 : de05c000  r6 : de05c000  r5 : c07c5778  r4 : c0824554
[    0.276305] r3 : 00000000  r2 : 00000000  r1 : 00000006  r0 : c0529a58
[    0.283116] Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM
Segment kernel
[    0.290818] Control: 10c5387d  Table: 80004019  DAC: 00000017
[    0.296821] Process swapper/0 (pid: 1, stack limit = 0xde05c248)
[    0.303094] Stack: (0xde05dd60 to 0xde05e000)
[    0.307677] dd60: c07b9dbc c00cb2dc 00000001 c08242c0 c08242c0
60000113 c07be0a8 c00b0590
[    0.316191] dd80: de05c000 c085e2f0 c08242c0 c08242c0 c1414c28
c00b07cc de05b440 c1414c28
[    0.324705] dda0: c08242c0 c00b0af8 c0862bb0 c0862db0 c1414cd8
de05c028 c0824840 de05ddb8
[    0.333218] ddc0: 00000000 00000009 00000001 00000024 c07be0a8
c07be0a4 de05c000 c085e2f0
[    0.341731] dde0: 00000000 c004a4b0 00000010 de00d2dc 00000054
00000100 00000024 00000000
[    0.350244] de00: de05c028 0000000a ffff8ae7 00200040 00000016
de05c000 60000193 de05c000
[    0.358756] de20: 00000054 00000000 00000000 00000000 00000000
c004a704 00000000 de05c008
[    0.367269] de40: c07ba254 c004aa1c c07c5778 c0014b70 fa200000
00000054 de05de80 c0861244
[    0.375782] de60: 00000000 c0008634 de05b440 c051c778 20000113
ffffffff de05deb4 c051d0a4
[    0.384295] de80: 00000001 00000001 00000000 de05b440 c082afac
de057ac0 de057ac0 de0443c0
[    0.392807] dea0: 00000000 00000000 00000000 00000000 c082afbc
de05dec8 c009f2a0 c051c778
[    0.401321] dec0: 20000113 ffffffff 00000000 c016edb0 00000000
000002b0 de057ac0 de057ac0
[    0.409833] dee0: 00000000 c016ee40 c0875e50 de05df2e de057ac0
00000000 00000013 00000000
[    0.418345] df00: 00000000 c016f054 de043600 de0443c0 c008eb38
de004ec0 c0875e50 c008eb44
[    0.426858] df20: 00000012 00000000 00000000 3931f0f8 00000000
00000000 00000014 c0822e84
[    0.435370] df40: 00000000 c008ed2c 00000000 00000000 00000000
c07b7490 c07b7490 c075ab3c
[    0.443882] df60: 00000000 c00701ac 00000002 00000000 c0070160
dffadb73 7bf8edb4 00000000
[    0.452394] df80: c051092c 00000000 00000000 00000000 00000000
00000000 00000000 c0510934
[    0.460907] dfa0: de05aa40 00000000 c051092c c0013ce8 00000000
00000000 00000000 00000000
[    0.469419] dfc0: 00000000 00000000 00000000 00000000 00000000
00000000 00000000 00000000
[    0.477930] dfe0: 00000000 00000000 00000000 00000000 00000013
00000000 07efffe5 4dfac6f5
[    0.486468] [<c0019590>] (arch_irq_work_raise+0x3c/0x48) from
[<c00cb2dc>] (irq_work_queue+0xe4/0xf8)
[    0.496073] [<c00cb2dc>] (irq_work_queue+0xe4/0xf8) from
[<c00b0590>] (rcu_accelerate_cbs+0x1d4/0x1d8)
[    0.505756] [<c00b0590>] (rcu_accelerate_cbs+0x1d4/0x1d8) from
[<c00b07cc>] (rcu_start_gp+0x34/0x48)
[    0.515259] [<c00b07cc>] (rcu_start_gp+0x34/0x48) from [<c00b0af8>]
(rcu_process_callbacks+0x318/0x608)
[    0.525040] [<c00b0af8>] (rcu_process_callbacks+0x318/0x608) from
[<c004a4b0>] (__do_softirq+0x114/0x2a0)
[    0.534989] [<c004a4b0>] (__do_softirq+0x114/0x2a0) from
[<c004a704>] (do_softirq+0x6c/0x74)
[    0.543776] [<c004a704>] (do_softirq+0x6c/0x74) from [<c004aa1c>]
(irq_exit+0xac/0x100)
[    0.552126] [<c004aa1c>] (irq_exit+0xac/0x100) from [<c0014b70>]
(handle_IRQ+0x54/0xb4)
[    0.560466] [<c0014b70>] (handle_IRQ+0x54/0xb4) from [<c0008634>]
(omap3_intc_handle_irq+0x60/0x74)
[    0.569885] [<c0008634>] (omap3_intc_handle_irq+0x60/0x74) from
[<c051d0a4>] (__irq_svc+0x44/0x5c)
[    0.579196] Exception stack(0xde05de80 to 0xde05dec8)
[    0.584491] de80: 00000001 00000001 00000000 de05b440 c082afac
de057ac0 de057ac0 de0443c0
[    0.593004] dea0: 00000000 00000000 00000000 00000000 c082afbc
de05dec8 c009f2a0 c051c778
[    0.601510] dec0: 20000113 ffffffff
[    0.605202] [<c051d0a4>] (__irq_svc+0x44/0x5c) from [<c051c778>]
(_raw_spin_unlock_irq+0x28/0x2c)
[    0.614447] [<c051c778>] (_raw_spin_unlock_irq+0x28/0x2c) from
[<c016edb0>] (proc_alloc_inum+0x30/0xa8)
[    0.624220] [<c016edb0>] (proc_alloc_inum+0x30/0xa8) from
[<c016ee40>] (proc_register+0x18/0x130)
[    0.633454] [<c016ee40>] (proc_register+0x18/0x130) from
[<c016f054>] (proc_mkdir_data+0x44/0x6c)
[    0.642702] [<c016f054>] (proc_mkdir_data+0x44/0x6c) from
[<c008eb44>] (register_irq_proc+0x6c/0x128)
[    0.652292] [<c008eb44>] (register_irq_proc+0x6c/0x128) from
[<c008ed2c>] (init_irq_proc+0x74/0xb0)
[    0.661706] [<c008ed2c>] (init_irq_proc+0x74/0xb0) from
[<c075ab3c>] (kernel_init_freeable+0x84/0x1c8)
[    0.671390] [<c075ab3c>] (kernel_init_freeable+0x84/0x1c8) from
[<c0510934>] (kernel_init+0x8/0x150)
[    0.680892] [<c0510934>] (kernel_init+0x8/0x150) from [<c0013ce8>]
(ret_from_fork+0x14/0x2c)
[    0.689674] Code: bad PC value
[    0.692984] ---[ end trace 1b75b31a2719ed1c ]---
