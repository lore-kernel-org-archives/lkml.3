Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab3A2ADh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 19:03:37 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:45543 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab3A2ADd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 19:03:33 -0500
Message-ID: <510711D1.3090205@wwwdotorg.org>
Date: Mon, 28 Jan 2013 17:03:29 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>,
        AnilKumar Ch <anilkumar@ti.com>
Subject: Re: [PATCH 2/2] regulator: tps65910: Fix using wrong dev argument
 for calling of_regulator_match
References: <1358994450.20257.1.camel@phoenix> <1358994705.20257.4.camel@phoenix>
In-Reply-To: <1358994705.20257.4.camel@phoenix>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2013 07:31 PM, Axel Lin wrote:
> The dev parameter is the device requesting the data.
> In this case it should be &pdev->dev rather than pdev->dev.parent.
> 
> The dev parameter is used to call devm_kzalloc in of_get_regulator_init_data(),
> which means this fixes a memory leak because the memory is allocated every time
> probe() is called, thus it should be freed when this driver is unloaded.

With this patch as part of next-20130128, I see a crash when booting my
system. Reverting this patch solves the problem.

> [    2.248939] platform 67.regulator: Driver reg-fixed-voltage requests probe deferral
> [    2.254574] 5v0: 5000 mV 
> [    2.259889] Unable to handle kernel paging request at virtual address 5a5a5a58
> [    2.259892] pgd = c0004000
> [    2.259897] [5a5a5a58] *pgd=00000000
> [    2.259908] Internal error: Oops: 80000005 [#1] PREEMPT SMP ARM
> [    2.259912] Modules linked in:
> [    2.259919] CPU: 0    Not tainted  (3.8.0-rc5-next-20130128 #50)
> [    2.259928] PC is at 0x5a5a5a58
> [    2.259944] LR is at regulator_register+0x1d0/0x134c
> [    2.259949] pc : [<5a5a5a58>]    lr : [<c0234558>]    psr: 20000113
> [    2.259949] sp : ee397d88  ip : 00000000  fp : ee189e10
> [    2.259952] r10: ee189e10  r9 : c070d600  r8 : ee154080
> [    2.259956] r7 : ee187e20  r6 : ee397e3c  r5 : ee3ec86c  r4 : ee3bd400
> [    2.259959] r3 : 5a5a5a5a  r2 : 00000000  r1 : ffffffd0  r0 : ee3cc550
> [    2.259964] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> [    2.259968] Control: 10c5387d  Table: 8000404a  DAC: 00000015
> [    2.259971] Process kworker/u:3 (pid: 73, stack limit = 0xee396238)
> [    2.259976] Stack: (0xee397d88 to 0xee398000)
> [    2.259982] 7d80:                   ee154080 ee3bd414 ee397db4 c0295318 00000000 00000001
> [    2.259989] 7da0: 00000044 ee154080 ee154080 ee154080 ee154084 c04f8e0c ee154080 00000000
> [    2.259995] 7dc0: 00000001 00000044 00000001 c0296374 ee397ddf c00c3de0 ee154080 000005c0
> [    2.260002] 7de0: a0000113 00000000 ee17a750 00000001 ee3cc550 c0238134 ee397e5c c00c4c50
> [    2.260008] 7e00: ee11f750 ee3cc550 ee17a750 0000005c 00000001 c070d7d8 c070d600 ee3bfbd4
> [    2.260015] 7e20: ee189e10 c0238d18 ee3ec86c 00000004 c070d5f0 ee187a00 ee136238 ee187e20
> [    2.260021] 7e40: ee189e10 ee3cc550 c0f8de90 ee154080 00000000 00000000 00000000 00000000
> [    2.260027] 7e60: c077ce60 ee187a10 c077ce60 c0288afc c070d4e0 c077ce68 c0716ae8 00000000
> [    2.260034] 7e80: c0758200 c0289af8 c0289ae4 c02888d8 c0289c48 ee187a10 ee397eb0 c0288afc
> [    2.260040] 7ea0: 00000000 00000000 00000000 c0287168 ee09b6f4 ee135478 c0716ae8 ee187a10
> [    2.260046] 7ec0: ee187a44 00000000 ee3af600 c0288804 ee09b680 ee187a10 ee187a10 c0716b40
> [    2.260053] 7ee0: ee3af600 c0287e5c ee187a10 c0716ae0 c0716abc c02883bc ee0f33c0 c0758200
> [    2.260059] 7f00: ee396000 c0038bcc 00000000 00000003 ee397f44 c0047cc8 fbffdf77 ee0f33c0
> [    2.260065] 7f20: c0758200 ee0f33d4 ee396000 00000001 00000089 c073526a c0758200 c003b3c4
> [    2.260072] 7f40: 00000000 ee07fe94 ee397f6c 00000000 ee0f33c0 c003b2a0 00000000 00000000
> [    2.260078] 7f60: 00000000 c003fdf4 f7ff7fff 00000000 fffff7bf ee0f33c0 00000000 00000000
> [    2.260084] 7f80: ee397f80 ee397f80 00000000 00000000 ee397f90 ee397f90 ee07fe94 c003fd4c
> [    2.260090] 7fa0: 00000000 00000000 00000000 c000e5b8 00000000 00000000 00000000 00000000
> [    2.260095] 7fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [    2.260101] 7fe0: 00000000 00000000 00000000 00000000 00000013 00000000 f7ff7efb ffffffff
> [    2.260130] [<c0234558>] (regulator_register+0x1d0/0x134c) from [<c0238d18>] (tps65910_probe+0x21c/0x60c)
> [    2.260148] [<c0238d18>] (tps65910_probe+0x21c/0x60c) from [<c0289af8>] (platform_drv_probe+0x14/0x18)
> [    2.260162] [<c0289af8>] (platform_drv_probe+0x14/0x18) from [<c02888d8>] (driver_probe_device+0x94/0x228)
> [    2.260171] [<c02888d8>] (driver_probe_device+0x94/0x228) from [<c0287168>] (bus_for_each_drv+0x60/0x8c)
> [    2.260179] [<c0287168>] (bus_for_each_drv+0x60/0x8c) from [<c0288804>] (device_attach+0x80/0xa4)
> [    2.260187] [<c0288804>] (device_attach+0x80/0xa4) from [<c0287e5c>] (bus_probe_device+0x84/0xa8)
> [    2.260195] [<c0287e5c>] (bus_probe_device+0x84/0xa8) from [<c02883bc>] (deferred_probe_work_func+0x68/0x94)
> [    2.260217] [<c02883bc>] (deferred_probe_work_func+0x68/0x94) from [<c0038bcc>] (process_one_work+0x124/0x370)
> [    2.260231] [<c0038bcc>] (process_one_work+0x124/0x370) from [<c003b3c4>] (worker_thread+0x124/0x364)
> [    2.260248] [<c003b3c4>] (worker_thread+0x124/0x364) from [<c003fdf4>] (kthread+0xa8/0xb4)
> [    2.260265] [<c003fdf4>] (kthread+0xa8/0xb4) from [<c000e5b8>] (ret_from_fork+0x14/0x3c)
> [    2.260271] Code: bad PC value
> [    2.260278] ---[ end trace a1e56122e7e757ad ]---
> [    2.260344] Unable to handle kernel paging request at virtual address ffffffec
> [    2.260347] pgd = c0004000
> [    2.260353] [ffffffec] *pgd=ae7f5821, *pte=00000000, *ppte=00000000
> [    2.260357] Internal error: Oops: 17 [#2] PREEMPT SMP ARM
> [    2.260360] Modules linked in:
> [    2.260365] CPU: 0    Tainted: G      D       (3.8.0-rc5-next-20130128 #50)
> [    2.260371] PC is at kthread_data+0x4/0xc
> [    2.260377] LR is at wq_worker_sleeping+0xc/0xa4
> [    2.260382] pc : [<c0040014>]    lr : [<c003b8d0>]    psr: 00000193
> [    2.260382] sp : ee397a58  ip : 00000000  fp : ee397b2c
> [    2.260385] r10: ee1f7d58  r9 : ee1f7cdc  r8 : c06efdc0
> [    2.260388] r7 : ee396000  r6 : c0f95dc0  r5 : 00000000  r4 : ee1f7a80
> [    2.260391] r3 : 00000000  r2 : 00000000  r1 : 00000000  r0 : ee1f7a80
> [    2.260395] Flags: nzcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
> [    2.260399] Control: 10c5387d  Table: 8000404a  DAC: 00000015
> [    2.260402] Process kworker/u:3 (pid: 73, stack limit = 0xee396238)
> [    2.260405] Stack: (0xee397a58 to 0xee398000)
> [    2.260409] 7a40:                                                       ee1f7a80 00000000
> [    2.260416] 7a60: c0f95dc0 c04fa06c 00000007 00000001 ee397ab4 00000000 c0714e74 60000193
> [    2.260423] 7a80: c0714e60 00000004 ee004900 c06efdc0 c06efdc0 c06efdc0 ee397ab4 00000008
> [    2.260429] 7aa0: ee1f7ae0 c06efdc0 c06efdc0 c06efdc0 c06efdc0 c06efdc0 ee367040 c0735b58
> [    2.260436] 7ac0: 00000170 c00c320c ee1f7a80 ee1e0dc0 ee367544 ee367040 ee1f7a80 c00278fc
> [    2.260442] 7ae0: 00000001 00200200 ee397b0c c004e9c4 ee1f7f0c 00000001 c06ee700 00000000
> [    2.260449] 7b00: ee1f7eb0 c076cec4 ee397b08 ee1f7a80 00000001 ee1f7a78 ee064a40 ee397b4c
> [    2.260455] 7b20: ee1f7cdc ee1f7cdc ee1f7cdc c0028bd8 c06fec70 ee397b44 ee396000 00000001
> [    2.260462] 7b40: 60000113 00430043 ee397b44 ee1f7d24 00000002 c0735700 ee397d40 ee396000
> [    2.260468] 7b60: c06fec70 0000000b fffffffc 00000000 60000113 c0011c18 ee396238 0000000b
> [    2.260474] 7b80: c07368be ee397b98 5a5a5a48 ee397d40 00000000 00000008 20646162 76204350
> [    2.260480] 7ba0: 65756c61 00000000 80000005 ee397d40 5a5a5a58 00000000 80000005 00000000
> [    2.260487] 7bc0: ee1f7a80 ee189e10 ee189e10 c04f7d0c c062827c ee397d40 5a5a5a58 00000000
> [    2.260493] 7be0: 80000005 00000000 ee1f7a80 ee189e10 ee189e10 c0019b90 80000005 00000000
> [    2.260499] 7c00: ee396000 ee397d40 5a5a5a58 c0019d20 c06efdc0 ee19a01c 00000000 ee397c48
> [    2.260506] 7c20: ffff8c13 00000028 00000000 c002fc20 ffff8baf a0000113 ee397c48 c002fd14
> [    2.260512] 7c40: ee397c48 c04f8000 00000000 00200200 ffff8c13 c0756f40 c002f8fc ee1f7a80
> [    2.260518] 7c60: ffffffff ffffffff 00000000 00000000 00000000 00000000 00000000 00000005
> [    2.260524] 7c80: c06ff6e8 5a5a5a58 ee397d40 ee154080 c070d600 ee189e10 ee189e10 c0008664
> [    2.260531] 7ca0: 00800044 c0723c88 ee006940 00000002 0000000d ee181630 c0723c88 c0723c88
> [    2.260537] 7cc0: c0723c8c c04f8e0c ee006940 ee0174c0 00000002 0000000d ee181630 c0325584
> [    2.260543] 7ce0: 00000002 ee181644 c0723c88 ee181418 00000001 c06f40c0 ee397d40 00000002
> [    2.260549] 7d00: 00000001 ffff8baf 00000000 c0321a80 00000000 ee181418 ee181418 00000002
> [    2.260555] 7d20: ee397d40 00000001 ee000500 5a5a5a58 20000113 ffffffff ee397d74 c000e298
> [    2.260562] 7d40: ee3cc550 ffffffd0 00000000 5a5a5a5a ee3bd400 ee3ec86c ee397e3c ee187e20
> [    2.260568] 7d60: ee154080 c070d600 ee189e10 ee189e10 00000000 ee397d88 c0234558 5a5a5a58
> [    2.260574] 7d80: 20000113 ffffffff ee154080 ee3bd414 ee397db4 c0295318 00000000 00000001
> [    2.260581] 7da0: 00000044 ee154080 ee154080 ee154080 ee154084 c04f8e0c ee154080 00000000
> [    2.260587] 7dc0: 00000001 00000044 00000001 c0296374 ee397ddf c00c3de0 ee154080 000005c0
> [    2.260593] 7de0: a0000113 00000000 ee17a750 00000001 ee3cc550 c0238134 ee397e5c c00c4c50
> [    2.260600] 7e00: ee11f750 ee3cc550 ee17a750 0000005c 00000001 c070d7d8 c070d600 ee3bfbd4
> [    2.260606] 7e20: ee189e10 c0238d18 ee3ec86c 00000004 c070d5f0 ee187a00 ee136238 ee187e20
> [    2.260612] 7e40: ee189e10 ee3cc550 c0f8de90 ee154080 00000000 00000000 00000000 00000000
> [    2.260619] 7e60: c077ce60 ee187a10 c077ce60 c0288afc c070d4e0 c077ce68 c0716ae8 00000000
> [    2.260625] 7e80: c0758200 c0289af8 c0289ae4 c02888d8 c0289c48 ee187a10 ee397eb0 c0288afc
> [    2.260631] 7ea0: 00000000 00000000 00000000 c0287168 ee09b6f4 ee135478 c0716ae8 ee187a10
> [    2.260637] 7ec0: ee187a44 00000000 ee3af600 c0288804 ee09b680 ee187a10 ee187a10 c0716b40
> [    2.260644] 7ee0: ee3af600 c0287e5c ee187a10 c0716ae0 c0716abc c02883bc ee0f33c0 c0758200
> [    2.260650] 7f00: ee396000 c0038bcc 00000000 00000003 ee397f44 c0047cc8 fbffdf77 ee0f33c0
> [    2.260657] 7f20: c0758200 ee0f33d4 ee396000 00000001 00000089 c073526a c0758200 c003b3c4
> [    2.260663] 7f40: 00000000 ee07fe94 ee397f6c 00000000 ee0f33c0 c003b2a0 00000000 00000000
> [    2.260669] 7f60: 00000000 c003fdf4 f7ff7fff 00000000 fffff7bf ee0f33c0 00000000 00000000
> [    2.260675] 7f80: ee397f80 ee397f80 00000001 00010001 ee397f90 ee397f90 ee07fe94 c003fd4c
> [    2.260681] 7fa0: 00000000 00000000 00000000 c000e5b8 00000000 00000000 00000000 00000000
> [    2.260686] 7fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [    2.260692] 7fe0: 00000000 00000000 00000000 00000000 00000013 00000000 f7ff7efb ffffffff
> [    2.260704] [<c0040014>] (kthread_data+0x4/0xc) from [<c003b8d0>] (wq_worker_sleeping+0xc/0xa4)
> [    2.260728] [<c003b8d0>] (wq_worker_sleeping+0xc/0xa4) from [<c04fa06c>] (__schedule+0x4f4/0x6ec)
> [    2.260744] [<c04fa06c>] (__schedule+0x4f4/0x6ec) from [<c0028bd8>] (do_exit+0x5e8/0x870)
> [    2.260759] [<c0028bd8>] (do_exit+0x5e8/0x870) from [<c0011c18>] (die+0x35c/0x3d8)
> [    2.260782] [<c0011c18>] (die+0x35c/0x3d8) from [<c0019b90>] (__do_kernel_fault+0x64/0x84)
> [    2.260793] [<c0019b90>] (__do_kernel_fault+0x64/0x84) from [<c0019d20>] (do_page_fault+0x170/0x3a4)
> [    2.260802] [<c0019d20>] (do_page_fault+0x170/0x3a4) from [<c0008664>] (do_PrefetchAbort+0x34/0x9c)
> [    2.260811] [<c0008664>] (do_PrefetchAbort+0x34/0x9c) from [<c000e298>] (__pabt_svc+0x38/0x80)
> [    2.260814] Exception stack(0xee397d40 to 0xee397d88)
> [    2.260821] 7d40: ee3cc550 ffffffd0 00000000 5a5a5a5a ee3bd400 ee3ec86c ee397e3c ee187e20
> [    2.260827] 7d60: ee154080 c070d600 ee189e10 ee189e10 00000000 ee397d88 c0234558 5a5a5a58
> [    2.260830] 7d80: 20000113 ffffffff
> [    2.260838] [<c000e298>] (__pabt_svc+0x38/0x80) from [<5a5a5a58>] (0x5a5a5a58)
> [    2.260844] Code: e513001c e7e00150 e12fff1e e59032ac (e5130014) 
> [    2.260848] ---[ end trace a1e56122e7e757ae ]---
> [    2.260850] Fixing recursive fault but reboot is needed!

