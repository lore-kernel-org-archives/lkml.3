Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbbAUADo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 19:03:44 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:36883 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530AbbAUADm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 19:03:42 -0500
Date: Wed, 21 Jan 2015 00:03:41 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: gregory.clement@free-electrons.com
cc: hdegoede@redhat.com, tj@kernel.org, treding@nvidia.com,
        pwalmsley@nvidia.com, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, linux-ide@vger.kernel.org
Subject: next-20150120 broken on Tegra by "ata: libahci: Allow using multiple
 regulators"
Message-ID: <alpine.DEB.2.02.1501210003010.5450@utopia.booyaka.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(linux-ide@ added)

Commit c7d7ddee7e24eedde6149eefbcfbfbc7125b9ff0 ("ata: libahci: Allow
using multiple regulators") in Linux-next 20150120 causes a panic
during boot on multiple Tegra boards:

http://nvt.pwsan.com/experimental/linux-next/testlogs/test_next-20150120/20150120001539/boot/tegra30-beaver/tegra30-beaver/tegra_defconfig_log.txt
http://nvt.pwsan.com/experimental/linux-next/testlogs/test_next-20150120/20150120001539/boot/tegra114-dalmore-a04/tegra114-dalmore/tegra_defconfig_log.txt
http://nvt.pwsan.com/experimental/linux-next/testlogs/test_next-20150120/20150120001539/boot/tegra124-jetson-tk1/tegra124-jetson-tk1/tegra_defconfig_log.txt

Taking the latter boot log as an example, the 6b6b6b9f value that the 
kernel is trying to dereference is being passed into _regulator_put() as a 
struct regulator *.


- Paul

[    1.353036] platform as3722-regulator: Driver as3722-regulator requests probe deferral
[    1.362978] tegra-ahci 70027000.sata: Failed to get supply 'avdd': -517
[    1.369607] tegra-ahci 70027000.sata: Failed to get regulators
[    1.375479] Unable to handle kernel paging request at virtual address 6b6b6b9f
[    1.382689] pgd = c0004000
[    1.385517] [6b6b6b9f] *pgd=00000000
[    1.389101] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
[    1.394403] Modules linked in:
[    1.397467] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.19.0-rc5-next-20150120-72727-g5d0eebb #1
[    1.406237] Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
[    1.412493] task: ee053840 ti: ee054000 task.ti: ee054000
[    1.417891] PC is at _regulator_put+0x14/0xa0
[    1.422241] LR is at regulator_put+0x1c/0x2c
[    1.426506] pc : [<c027764c>]    lr : [<c02776f4>]    psr: 00000113
[    1.426506] sp : ee055e40  ip : ee18aedc  fp : 00000000
[    1.437964] r10: c02f94b4  r9 : c02f94b0  r8 : ee055e70
[    1.443179] r7 : 0000000d  r6 : 00000005  r5 : 6b6b6b6b  r4 : 6b6b6b6b
[    1.449695] r3 : ee053840  r2 : ee055e48  r1 : 00000000  r0 : 6b6b6b6b
[    1.456213] Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[    1.463509] Control: 10c5387d  Table: 8000406a  DAC: 00000015
[    1.469245] Process swapper/0 (pid: 1, stack limit = 0xee054210)
[    1.475242] Stack: (0xee055e40 to 0xee056000)
[    1.479596] 5e40: c08ff470 6b6b6b6b 00000005 c02776f4 6b6b6b6b 00000001 ee3d9990 c03481a4
[    1.487761] 5e60: ee3d9980 ee055e70 ee18ae10 c02f99f8 ee3d9980 ee3ed980 ee18ae10 c09804c0
[    1.495927] 5e80: fffffdfb c0910898 00000000 c08d31e4 00000000 c02f6ea8 ee18ae10 c0910898
[    1.504093] 5ea0: ee18ae44 00000000 c08b996c c02f70f0 00000000 c0910898 c02f7064 c02f577c
[    1.512258] 5ec0: ee036560 ee15f934 c0910898 ee3d9a00 c090dc08 c02f6744 c07e6d00 c0910898
[    1.520423] 5ee0: c08ee018 c0910898 c08ee018 ee3ed700 c0939340 c02f7714 00000000 c08ee018
[    1.528588] 5f00: c08ee018 c0008b04 c063dd14 00000014 00000000 00000000 00000000 c012d2dc
[    1.536752] 5f20: 00000000 c08f2684 60000113 00000001 ef7fcca0 c0659cbc 000000d9 c003bdd4
[    1.544917] 5f40: c08626bc 00000006 ef7fcca8 00000006 c08f264c ef7fcc40 c08e3474 00000006
[    1.553082] 5f60: c08d31d8 c0939340 000000d9 c08d31e4 c089c598 c089cd80 00000006 00000006
[    1.561247] 5f80: c089c598 7fffffff 00000000 c062f028 00000000 00000000 00000000 00000000
[    1.569413] 5fa0: 00000000 c062f030 00000000 c000e9c0 00000000 00000000 00000000 00000000
[    1.577578] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    1.585743] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000 ffffffff 7fffffff
[    1.593920] [<c027764c>] (_regulator_put) from [<c02776f4>] (regulator_put+0x1c/0x2c)
[    1.601751] [<c02776f4>] (regulator_put) from [<c03481a4>] (ahci_platform_put_resources+0x74/0xa0)
[    1.610704] [<c03481a4>] (ahci_platform_put_resources) from [<c02f99f8>] (release_nodes+0x164/0x1d8)
[    1.619828] [<c02f99f8>] (release_nodes) from [<c02f6ea8>] (driver_probe_device+0x70/0x22c)
[    1.628170] [<c02f6ea8>] (driver_probe_device) from [<c02f70f0>] (__driver_attach+0x8c/0x90)
[    1.636604] [<c02f70f0>] (__driver_attach) from [<c02f577c>] (bus_for_each_dev+0x54/0x88)
[    1.644774] [<c02f577c>] (bus_for_each_dev) from [<c02f6744>] (bus_add_driver+0xd4/0x1d0)
[    1.652940] [<c02f6744>] (bus_add_driver) from [<c02f7714>] (driver_register+0x78/0xf4)
[    1.660936] [<c02f7714>] (driver_register) from [<c0008b04>] (do_one_initcall+0x80/0x1d0)
[    1.669108] [<c0008b04>] (do_one_initcall) from [<c089cd80>] (kernel_init_freeable+0x108/0x1d4)
[    1.677802] [<c089cd80>] (kernel_init_freeable) from [<c062f030>] (kernel_init+0x8/0xec)
[    1.685887] [<c062f030>] (kernel_init) from [<c000e9c0>] (ret_from_fork+0x14/0x34)
[    1.693447] Code: e2504000 08bd8070 e3740a01 88bd8070 (e5940034) 
[    1.699578] ---[ end trace 6cc7849b05d3269f ]---
[    1.704225] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
[    1.704225] 
[    1.713348] CPU2: stopping
[    1.716059] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G      D         3.19.0-rc5-next-20150120-72727-g5d0eebb #1
[    1.726041] Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
[    1.732316] [<c0015a90>] (unwind_backtrace) from [<c00114a8>] (show_stack+0x10/0x14)
[    1.740057] [<c00114a8>] (show_stack) from [<c0632e9c>] (dump_stack+0x84/0xd0)
[    1.747273] [<c0632e9c>] (dump_stack) from [<c001429c>] (handle_IPI+0x134/0x160)
[    1.754660] [<c001429c>] (handle_IPI) from [<c00087d4>] (gic_handle_irq+0x54/0x5c)
[    1.762222] [<c00087d4>] (gic_handle_irq) from [<c0012000>] (__irq_svc+0x40/0x74)
[    1.769691] Exception stack(0xee079f98 to 0xee079fe0)
[    1.774734] 9f80:                                                       ffffffed 00000000
[    1.782900] 9fa0: ee079fe8 c001ee80 c08ea4f8 c08ea494 00000000 00000000 c08e6a00 c08e5d98
[    1.791064] 9fc0: ffffffed 00000000 00000000 ee079fe0 c000f48c c000f490 60000113 ffffffff
[    1.799236] [<c0012000>] (__irq_svc) from [<c000f490>] (arch_cpu_idle+0x30/0x3c)
[    1.806626] [<c000f490>] (arch_cpu_idle) from [<c00554cc>] (cpu_startup_entry+0x1a4/0x278)
[    1.814881] [<c00554cc>] (cpu_startup_entry) from [<80008864>] (0x80008864)
[    1.821831] CPU3: stopping
[    1.824542] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G      D         3.19.0-rc5-next-20150120-72727-g5d0eebb #1
[    1.834526] Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
[    1.840797] [<c0015a90>] (unwind_backtrace) from [<c00114a8>] (show_stack+0x10/0x14)
[    1.848536] [<c00114a8>] (show_stack) from [<c0632e9c>] (dump_stack+0x84/0xd0)
[    1.855751] [<c0632e9c>] (dump_stack) from [<c001429c>] (handle_IPI+0x134/0x160)
[    1.863138] [<c001429c>] (handle_IPI) from [<c00087d4>] (gic_handle_irq+0x54/0x5c)
[    1.870701] [<c00087d4>] (gic_handle_irq) from [<c0012000>] (__irq_svc+0x40/0x74)
[    1.878170] Exception stack(0xee07bf98 to 0xee07bfe0)
[    1.883212] bf80:                                                       ffffffed 00000000
[    1.891377] bfa0: ee07bfe8 c001ee80 c08ea4f8 c08ea494 00000000 00000000 c08e6a00 c08e5d98
[    1.899543] bfc0: ffffffed 00000000 00000000 ee07bfe0 c000f48c c000f490 60000113 ffffffff
[    1.907715] [<c0012000>] (__irq_svc) from [<c000f490>] (arch_cpu_idle+0x30/0x3c)
[    1.915105] [<c000f490>] (arch_cpu_idle) from [<c00554cc>] (cpu_startup_entry+0x1a4/0x278)
[    1.923358] [<c00554cc>] (cpu_startup_entry) from [<80008864>] (0x80008864)
[    1.930309] CPU1: stopping
[    1.933018] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G      D         3.19.0-rc5-next-20150120-72727-g5d0eebb #1
[    1.943002] Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
[    1.949273] [<c0015a90>] (unwind_backtrace) from [<c00114a8>] (show_stack+0x10/0x14)
[    1.957012] [<c00114a8>] (show_stack) from [<c0632e9c>] (dump_stack+0x84/0xd0)
[    1.964227] [<c0632e9c>] (dump_stack) from [<c001429c>] (handle_IPI+0x134/0x160)
[    1.971614] [<c001429c>] (handle_IPI) from [<c00087d4>] (gic_handle_irq+0x54/0x5c)
[    1.979177] [<c00087d4>] (gic_handle_irq) from [<c0012000>] (__irq_svc+0x40/0x74)
[    1.986646] Exception stack(0xee077f98 to 0xee077fe0)
[    1.991690] 7f80:                                                       ffffffed 00000000
[    1.999856] 7fa0: ee077fe8 c001ee80 c08ea4f8 c08ea494 00000000 00000000 c08e6a00 c08e5d98
[    2.008022] 7fc0: ffffffed 00000000 00000000 ee077fe0 c000f48c c000f490 60000113 ffffffff
[    2.016194] [<c0012000>] (__irq_svc) from [<c000f490>] (arch_cpu_idle+0x30/0x3c)
[    2.023585] [<c000f490>] (arch_cpu_idle) from [<c00554cc>] (cpu_startup_entry+0x1a4/0x278)
[    2.031838] [<c00554cc>] (cpu_startup_entry) from [<80008864>] (0x80008864)
[    2.038794] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
[    2.038794] 
--
To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
