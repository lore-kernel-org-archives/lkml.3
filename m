Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab3JaScu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 14:32:50 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51089 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab3JaScq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 14:32:46 -0400
Message-ID: <5272A24A.30800@wwwdotorg.org>
Date: Thu, 31 Oct 2013 12:32:42 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>, mturquette@linaro.org
CC: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        jiada_wang@mentor.com, kyungmin.park@samsung.com,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH v7 5/5] clk: Implement clk_unregister()
References: <1383076268-8984-1-git-send-email-s.nawrocki@samsung.com> <1383076268-8984-6-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1383076268-8984-6-git-send-email-s.nawrocki@samsung.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2013 01:51 PM, Sylwester Nawrocki wrote:
> clk_unregister() is currently not implemented and it is required when
> a clock provider module needs to be unloaded.
> 
> Normally the clock supplier module is prevented to be unloaded by
> taking reference on the module in clk_get().
> 
> For cases when the clock supplier module deinitializes despite the
> consumers of its clocks holding a reference on the module, e.g. when
> the driver is unbound through "unbind" sysfs attribute, there are
> empty clock ops added. These ops are assigned temporarily to struct
> clk and used until all consumers release the clock, to avoid invoking
> callbacks from the module which just got removed.

This patch is now in Mike's clk-next and hence next-20131031, and causes
both a WARN and an OOPS when booting the Tegra Dalmore board. (See log
below)

If I do the following to fix some other issues:

1) Apply:
http://www.spinics.net/lists/arm-kernel/msg283619.html
clk: fix boot panic with non-dev-associated clocks

2) Merge some Tegra-specific bug-fixes:
https://lkml.org/lkml/2013/10/29/771
Re: pull request for Tegra clock rework and Tegra124 clock support

... then revert this patch a336ed7 "clk: Implement clk_unregister()",
everything works again.

> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: CPU: 0 PID: 0 at include/linux/kref.h:47 __clk_get+0x6c/0x84()
> [    0.000000] Modules linked in:
> [    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.12.0-rc3-00069-g850d089 #172
> [    0.000000] [<c00158f0>] (unwind_backtrace+0x0/0xf8) from [<c00117a8>] (show_stack+0x10/0x14)
> [    0.000000] [<c00117a8>] (show_stack+0x10/0x14) from [<c053b0b4>] (dump_stack+0x80/0xc4)
> [    0.000000] [<c053b0b4>] (dump_stack+0x80/0xc4) from [<c00251f4>] (warn_slowpath_common+0x64/0x88)
> [    0.000000] [<c00251f4>] (warn_slowpath_common+0x64/0x88) from [<c0025234>] (warn_slowpath_null+0x1c/0x24)
> [    0.000000] [<c0025234>] (warn_slowpath_null+0x1c/0x24) from [<c03a3f98>] (__clk_get+0x6c/0x84)
> [    0.000000] [<c03a3f98>] (__clk_get+0x6c/0x84) from [<c03a17e0>] (of_clk_get+0x5c/0x74)
> [    0.000000] [<c03a17e0>] (of_clk_get+0x5c/0x74) from [<c03a1830>] (of_clk_get_by_name+0x38/0xb4)
> [    0.000000] [<c03a1830>] (of_clk_get_by_name+0x38/0xb4) from [<c073e114>] (tegra_pmc_init+0x70/0x298)
> [    0.000000] [<c073e114>] (tegra_pmc_init+0x70/0x298) from [<c073de68>] (tegra_dt_init_irq+0x10/0x20)
> [    0.000000] [<c073de68>] (tegra_dt_init_irq+0x10/0x20) from [<c0739384>] (init_IRQ+0x24/0x2c)
> [    0.000000] [<c0739384>] (init_IRQ+0x24/0x2c) from [<c0737910>] (start_kernel+0x1a0/0x30c)
> [    0.000000] [<c0737910>] (start_kernel+0x1a0/0x30c) from [<80008074>] (0x80008074)
> [    0.000000] ---[ end trace 1b75b31a2719ed1c ]---
...
> [   14.674455] Unable to handle kernel paging request at virtual address 6b6b6cc3
> [   14.681719] pgd = c0004000
> [   14.684517] [6b6b6cc3] *pgd=00000000
> [   14.688166] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
> [   14.693507] Modules linked in:
> [   14.696640] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W    3.12.0-rc3-00069-g850d089 #172
> [   14.705385] task: ee07ea40 ti: ee098000 task.ti: ee098000
> [   14.710837] PC is at module_put+0x28/0x78
> [   14.714916] LR is at tegra_ehci_probe+0xac/0x3b8
> [   14.719575] pc : [<c0077b18>]    lr : [<c031d910>]    psr: 20000113
> [   14.719575] sp : ee099e60  ip : ee018740  fp : 00000000
> [   14.731092] r10: fffffdfb  r9 : ee098000  r8 : fffffdfb
> [   14.736350] r7 : c058ad18  r6 : ee112410  r5 : ee0186c0  r4 : ee098000
> [   14.742909] r3 : 00000001  r2 : 00000001  r1 : 000004d0  r0 : 6b6b6b6b
> [   14.749473] Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> [   14.756824] Control: 10c5387d  Table: 8000406a  DAC: 00000015
> [   14.762601] Process swapper/0 (pid: 1, stack limit = 0xee098240)
> [   14.768640] Stack: (0xee099e60 to 0xee09a000)
> [   14.773045] 9e60: ee365800 c031d910 c031d864 c0808e58 ee112410 00000000 c079e924 c074fe3c
> [   14.781273] 9e80: c07374e0 c02a225c c02a2244 c02a1108 00000000 ee112410 c079e924 ee112444
> [   14.789498] 9ea0: 00000000 c02a12b0 00000000 c079e924 c02a1224 c029f73c ee0880e0 ee1135f4
> [   14.797722] 9ec0: c079e924 ee37fb40 c0798bd0 c02a07dc c06a645c c079e924 c079e924 00000006
> [   14.805946] 9ee0: c0760ab8 c07c0900 c074fe3c c02a18c8 c02a2284 c076d118 00000006 c00089d8
> [   14.814170] 9f00: c07e60d8 ee133840 c0543d24 000000bf c07c0900 00000001 00000000 c0781dd8
> [   14.822393] 9f20: 60000113 00000001 00000008 c182b1d2 c055e284 c003d620 ee099f64 c004741c
> [   14.830617] 9f40: c06abae4 c070618c 00000006 00000006 c0781dc8 c076d118 00000006 c0760ab8
> [   14.838841] 9f60: c07c0900 000000b9 c0760ac4 c07374e0 00000000 c0737b78 00000006 00000006
> [   14.847064] 9f80: c07374e0 ffffffff 00000000 c0536aec 00000000 00000000 00000000 00000000
> [   14.855288] 9fa0: 00000000 c0536af4 00000000 c000e678 00000000 00000000 00000000 00000000
> [   14.863509] 9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [   14.871732] 9fe0: 00000000 00000000 00000000 00000000 00000013 00000000 ffffffff ffffffff
> [   14.879994] [<c0077b18>] (module_put+0x28/0x78) from [<c031d910>] (tegra_ehci_probe+0xac/0x3b8)
> [   14.888782] [<c031d910>] (tegra_ehci_probe+0xac/0x3b8) from [<c02a225c>] (platform_drv_probe+0x18/0x1c)
> [   14.898247] [<c02a225c>] (platform_drv_probe+0x18/0x1c) from [<c02a1108>] (driver_probe_device+0x108/0x224)
> [   14.908050] [<c02a1108>] (driver_probe_device+0x108/0x224) from [<c02a12b0>] (__driver_attach+0x8c/0x90)
> [   14.917607] [<c02a12b0>] (__driver_attach+0x8c/0x90) from [<c029f73c>] (bus_for_each_dev+0x54/0x88)
> [   14.926729] [<c029f73c>] (bus_for_each_dev+0x54/0x88) from [<c02a07dc>] (bus_add_driver+0xd4/0x258)
> [   14.935837] [<c02a07dc>] (bus_add_driver+0xd4/0x258) from [<c02a18c8>] (driver_register+0x78/0xf4)
> [   14.944862] [<c02a18c8>] (driver_register+0x78/0xf4) from [<c00089d8>] (do_one_initcall+0xe4/0x140)
> [   14.953982] [<c00089d8>] (do_one_initcall+0xe4/0x140) from [<c0737b78>] (kernel_init_freeable+0xfc/0x1c4)
> [   14.963624] [<c0737b78>] (kernel_init_freeable+0xfc/0x1c4) from [<c0536af4>] (kernel_init+0x8/0xe4)
> [   14.972748] [<c0536af4>] (kernel_init+0x8/0xe4) from [<c000e678>] (ret_from_fork+0x14/0x3c)
> [   14.981155] Code: e5943004 e2833001 e5843004 f57ff05a (e5903158) 
> [   14.987438] ---[ end trace 1b75b31a2719ed1d ]---
> [   14.992109] note: swapper/0[1] exited with preempt_count 1
> [   14.997752] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
> [   14.997752] 
> [   15.006970] CPU2: stopping
> [   15.009756] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G      D W    3.12.0-rc3-00069-g850d089 #172
> [   15.018572] [<c00158f0>] (unwind_backtrace+0x0/0xf8) from [<c00117a8>] (show_stack+0x10/0x14)
> [   15.027180] [<c00117a8>] (show_stack+0x10/0x14) from [<c053b0b4>] (dump_stack+0x80/0xc4)
> [   15.035341] [<c053b0b4>] (dump_stack+0x80/0xc4) from [<c00142e8>] (handle_IPI+0xfc/0x120)
> [   15.043587] [<c00142e8>] (handle_IPI+0xfc/0x120) from [<c0008704>] (gic_handle_irq+0x54/0x5c)
> [   15.052183] [<c0008704>] (gic_handle_irq+0x54/0x5c) from [<c00122a0>] (__irq_svc+0x40/0x70)
> [   15.060573] Exception stack(0xee0b7fa0 to 0xee0b7fe8)
> [   15.065671] 7fa0: ffffffed 010d0000 c077b968 00000000 ee0b6000 c07c0747 00000001 c07c0747
> [   15.073900] 7fc0: c077a44c c077a3d4 c05430cc 00000000 00000001 ee0b7fe8 c000f1dc c000f1d4
> [   15.082114] 7fe0: 60000113 ffffffff
> [   15.085679] [<c00122a0>] (__irq_svc+0x40/0x70) from [<c000f1d4>] (arch_cpu_idle+0x28/0x38)
> [   15.094019] [<c000f1d4>] (arch_cpu_idle+0x28/0x38) from [<c0061d58>] (cpu_startup_entry+0x60/0x134)
> [   15.103127] [<c0061d58>] (cpu_startup_entry+0x60/0x134) from [<800087a4>] (0x800087a4)
> [   15.111089] CPU3: stopping
> [   15.113872] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G      D W    3.12.0-rc3-00069-g850d089 #172
> [   15.122680] [<c00158f0>] (unwind_backtrace+0x0/0xf8) from [<c00117a8>] (show_stack+0x10/0x14)
> [   15.131284] [<c00117a8>] (show_stack+0x10/0x14) from [<c053b0b4>] (dump_stack+0x80/0xc4)
> [   15.139441] [<c053b0b4>] (dump_stack+0x80/0xc4) from [<c00142e8>] (handle_IPI+0xfc/0x120)
> [   15.147683] [<c00142e8>] (handle_IPI+0xfc/0x120) from [<c0008704>] (gic_handle_irq+0x54/0x5c)
> [   15.156280] [<c0008704>] (gic_handle_irq+0x54/0x5c) from [<c00122a0>] (__irq_svc+0x40/0x70)
> [   15.164669] Exception stack(0xee0b9fa0 to 0xee0b9fe8)
> [   15.169768] 9fa0: ffffffed 010d8000 c077b968 00000000 ee0b8000 c07c0747 00000001 c07c0747
> [   15.177994] 9fc0: c077a44c c077a3d4 c05430cc 00000000 00000001 ee0b9fe8 c000f1dc c000f1d4
> [   15.186208] 9fe0: 60000113 ffffffff
> [   15.189771] [<c00122a0>] (__irq_svc+0x40/0x70) from [<c000f1d4>] (arch_cpu_idle+0x28/0x38)
> [   15.198108] [<c000f1d4>] (arch_cpu_idle+0x28/0x38) from [<c0061d58>] (cpu_startup_entry+0x60/0x134)
> [   15.207215] [<c0061d58>] (cpu_startup_entry+0x60/0x134) from [<800087a4>] (0x800087a4)
> [   15.215178] CPU0: stopping
> [   15.217953] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G      D W    3.12.0-rc3-00069-g850d089 #172
> [   15.226758] [<c00158f0>] (unwind_backtrace+0x0/0xf8) from [<c00117a8>] (show_stack+0x10/0x14)
> [   15.235363] [<c00117a8>] (show_stack+0x10/0x14) from [<c053b0b4>] (dump_stack+0x80/0xc4)
> [   15.243522] [<c053b0b4>] (dump_stack+0x80/0xc4) from [<c00142e8>] (handle_IPI+0xfc/0x120)
> [   15.251765] [<c00142e8>] (handle_IPI+0xfc/0x120) from [<c0008704>] (gic_handle_irq+0x54/0x5c)
> [   15.260363] [<c0008704>] (gic_handle_irq+0x54/0x5c) from [<c00122a0>] (__irq_svc+0x40/0x70)
> [   15.268754] Exception stack(0xc0773f68 to 0xc0773fb0)
> [   15.273851] 3f60:                   ffffffed 010c0000 c077b968 00000000 c0772000 c07c0747
> [   15.282080] 3f80: 00000001 c07c0747 c077a44c c077a3d4 c05430cc 00000000 00000020 c0773fb0
> [   15.290297] 3fa0: c000f1dc c000f1d4 60000113 ffffffff
> [   15.295421] [<c00122a0>] (__irq_svc+0x40/0x70) from [<c000f1d4>] (arch_cpu_idle+0x28/0x38)
> [   15.303757] [<c000f1d4>] (arch_cpu_idle+0x28/0x38) from [<c0061d58>] (cpu_startup_entry+0x60/0x134)
> [   15.312874] [<c0061d58>] (cpu_startup_entry+0x60/0x134) from [<c0737a28>] (start_kernel+0x2b8/0x30c)
> [   15.322069] [<c0737a28>] (start_kernel+0x2b8/0x30c) from [<80008074>] (0x80008074)

