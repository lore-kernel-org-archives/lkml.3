Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbaDIGMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 02:12:42 -0400
Received: from 1wt.eu ([62.212.114.60]:3682 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbaDIGMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 02:12:24 -0400
Date: Wed, 9 Apr 2014 08:11:29 +0200
From: Willy Tarreau <w@1wt.eu>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Neil Greatorex <neil@fatboyfat.co.uk>,
        linux-arm-kernel@lists.infradead.org,
        Matthew Minter <matthew_minter@xyratex.com>,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH v2] bus: mvebu-mbus: Avoid setting an undefined window size
Message-ID: <20140409061128.GC16465@1wt.eu>
References: <1397000654-10849-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <1397000654-10849-1-git-send-email-jgunthorpe@obsidianresearch.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jason,

On Tue, Apr 08, 2014 at 05:44:14PM -0600, Jason Gunthorpe wrote:
> The mbus hardware requires a power of two size, and size aligned base.
> Currently, if a non-power of two is passed in to the low level routines
> they configure the register in a way that results in undefined behaviour.
> 
> Call WARN and return EINVAL instead.

The WARN is correctly emitted for both igb ports here, but unfortunately
despite EINVAL, I still get the panic. Also I find it surprizing that it
reports sizes ending in ffff. I read the patch and it looks correct, so
we possibly have something else wrong here.

OK I just got it by adding two printk() in pci-mvebu.c. Both functions
mvebu_pcie_handle_iobase_change() and mvebu_pcie_handle_membase_change()
do pass a size which is in fact a mask (size - 1) and not the real size.
So the mbus is fed with an incorrect size which is off by one :

root@xpgp:~# modprobe igb
igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.5-k
igb: Copyright (c) 2007-2013 Intel Corporation.
PCI: enabling device 0000:00:09.0 (0140 -> 0143)
mvebu_pcie_handle_iobase_change: base=e8010000 size=00000fff
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1258 at drivers/bus/mvebu-mbus.c:271 mvebu_mbus_setup_window+0xb3/0xe4()
Invalid MBus window size: 0xfff
Modules linked in: igb(+) i2c_algo_bit
CPU: 0 PID: 1258 Comm: modprobe Not tainted 3.14.0-mvebu #18
[<c0011c39>] (unwind_backtrace) from [<c000f20b>] (show_stack+0xb/0xc)
[<c000f20b>] (show_stack) from [<c02b5d1b>] (dump_stack+0x4f/0x64)
[<c02b5d1b>] (dump_stack) from [<c001a145>] (warn_slowpath_common+0x49/0x68)
[<c001a145>] (warn_slowpath_common) from [<c001a1bd>] (warn_slowpath_fmt+0x1d/0x28)
[<c001a1bd>] (warn_slowpath_fmt) from [<c017005b>] (mvebu_mbus_setup_window+0xb3/0xe4)
[<c017005b>] (mvebu_mbus_setup_window) from [<c01700f1>] (mvebu_mbus_alloc_window.constprop.7+0x65/0xc4)
[<c01700f1>] (mvebu_mbus_alloc_window.constprop.7) from [<c01865cf>] (mvebu_pcie_handle_iobase_change+0x6b/0xb0)
[<c01865cf>] (mvebu_pcie_handle_iobase_change) from [<c0186d1b>] (mvebu_pcie_wr_conf+0x2eb/0x2f4)
[<c0186d1b>] (mvebu_pcie_wr_conf) from [<c0177f39>] (pci_bus_write_config_word+0x35/0x44)
[<c0177f39>] (pci_bus_write_config_word) from [<c0010bf3>] (pcibios_enable_device+0xab/0xc0)
[<c0010bf3>] (pcibios_enable_device) from [<c017bb67>] (do_pci_enable_device+0x27/0x80)
[<c017bb67>] (do_pci_enable_device) from [<c017c727>] (pci_enable_device_flags+0x8f/0xc4)
[<c017c727>] (pci_enable_device_flags) from [<c017c67b>] (pci_enable_bridge+0x2b/0x48)
[<c017c67b>] (pci_enable_bridge) from [<c017c6e1>] (pci_enable_device_flags+0x49/0xc4)
[<c017c6e1>] (pci_enable_device_flags) from [<bf806aa1>] (igb_probe+0x1c/0xb80 [igb])
[<bf806aa1>] (igb_probe [igb]) from [<c017d1f5>] (pci_device_probe+0x45/0x6c)
[<c017d1f5>] (pci_device_probe) from [<c019bead>] (driver_probe_device+0xb5/0x174)
[<c019bead>] (driver_probe_device) from [<c019bfb7>] (__driver_attach+0x4b/0x4c)
[<c019bfb7>] (__driver_attach) from [<c019af43>] (bus_for_each_dev+0x27/0x48)
[<c019af43>] (bus_for_each_dev) from [<c019b967>] (bus_add_driver+0x87/0x128)
[<c019b967>] (bus_add_driver) from [<c019c379>] (driver_register+0x35/0x84)
[<c019c379>] (driver_register) from [<bf81e027>] (init_module+0x26/0x3f [igb])
[<bf81e027>] (init_module [igb]) from [<c0008809>] (do_one_initcall+0xa1/0xe4)
[<c0008809>] (do_one_initcall) from [<c00555e3>] (load_module+0x1067/0x1544)
[<c00555e3>] (load_module) from [<c0055b3f>] (SyS_init_module+0x7f/0x8c)
[<c0055b3f>] (SyS_init_module) from [<c000cc81>] (ret_fast_syscall+0x1/0x46)
---[ end trace 53f41ddadca51c5e ]---
mvebu_pcie_handle_membase_change: base=e0000000 size=002fffff
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1258 at drivers/bus/mvebu-mbus.c:271 mvebu_mbus_setup_window+0xb3/0xe4()
Invalid MBus window size: 0x2fffff
Modules linked in: igb(+) i2c_algo_bit
CPU: 0 PID: 1258 Comm: modprobe Tainted: G        W    3.14.0-mvebu #18
[<c0011c39>] (unwind_backtrace) from [<c000f20b>] (show_stack+0xb/0xc)
[<c000f20b>] (show_stack) from [<c02b5d1b>] (dump_stack+0x4f/0x64)
[<c02b5d1b>] (dump_stack) from [<c001a145>] (warn_slowpath_common+0x49/0x68)
[<c001a145>] (warn_slowpath_common) from [<c001a1bd>] (warn_slowpath_fmt+0x1d/0x28)
[<c001a1bd>] (warn_slowpath_fmt) from [<c017005b>] (mvebu_mbus_setup_window+0xb3/0xe4)
[<c017005b>] (mvebu_mbus_setup_window) from [<c0170145>] (mvebu_mbus_alloc_window.constprop.7+0xb9/0xc4)
[<c0170145>] (mvebu_mbus_alloc_window.constprop.7) from [<c0170447>] (mvebu_mbus_add_window_by_id+0xf/0x14)
[<c0170447>] (mvebu_mbus_add_window_by_id) from [<c0186cf1>] (mvebu_pcie_wr_conf+0x2c1/0x2f4)
[<c0186cf1>] (mvebu_pcie_wr_conf) from [<c0177f39>] (pci_bus_write_config_word+0x35/0x44)
[<c0177f39>] (pci_bus_write_config_word) from [<c0010bf3>] (pcibios_enable_device+0xab/0xc0)
[<c0010bf3>] (pcibios_enable_device) from [<c017bb67>] (do_pci_enable_device+0x27/0x80)
[<c017bb67>] (do_pci_enable_device) from [<c017c727>] (pci_enable_device_flags+0x8f/0xc4)
[<c017c727>] (pci_enable_device_flags) from [<c017c67b>] (pci_enable_bridge+0x2b/0x48)
[<c017c67b>] (pci_enable_bridge) from [<c017c6e1>] (pci_enable_device_flags+0x49/0xc4)
[<c017c6e1>] (pci_enable_device_flags) from [<bf806aa1>] (igb_probe+0x1c/0xb80 [igb])
[<bf806aa1>] (igb_probe [igb]) from [<c017d1f5>] (pci_device_probe+0x45/0x6c)
[<c017d1f5>] (pci_device_probe) from [<c019bead>] (driver_probe_device+0xb5/0x174)
[<c019bead>] (driver_probe_device) from [<c019bfb7>] (__driver_attach+0x4b/0x4c)
[<c019bfb7>] (__driver_attach) from [<c019af43>] (bus_for_each_dev+0x27/0x48)
[<c019af43>] (bus_for_each_dev) from [<c019b967>] (bus_add_driver+0x87/0x128)
[<c019b967>] (bus_add_driver) from [<c019c379>] (driver_register+0x35/0x84)
[<c019c379>] (driver_register) from [<bf81e027>] (init_module+0x26/0x3f [igb])
[<bf81e027>] (init_module [igb]) from [<c0008809>] (do_one_initcall+0xa1/0xe4)
[<c0008809>] (do_one_initcall) from [<c00555e3>] (load_module+0x1067/0x1544)
[<c00555e3>] (load_module) from [<c0055b3f>] (SyS_init_module+0x7f/0x8c)
[<c0055b3f>] (SyS_init_module) from [<c000cc81>] (ret_fast_syscall+0x1/0x46)
---[ end trace 53f41ddadca51c5f ]---
PCI: enabling device 0000:02:00.0 (0140 -> 0142)
Unhandled fault: external abort on non-linefetch (0x1008) at 0xf0300018
Internal error: : 1008 [#1] SMP THUMB2
Modules linked in: igb(+) i2c_algo_bit
CPU: 0 PID: 1258 Comm: modprobe Tainted: G        W    3.14.0-mvebu #18
task: c7534d00 ti: edb9c000 task.ti: edb9c000
PC is at igb_get_invariants_82575+0x75/0x894 [igb]
LR is at igb_probe+0x22a/0xb80 [igb]
pc : [<bf80fe26>]    lr : [<bf806caf>]    psr: 20000033
sp : edb9dd00  ip : bf811e51  fp : c7488898
r10: bf816950  r9 : 00000001  r8 : c7488440
r7 : ed9a7068  r6 : 00000001  r5 : 00000000  r4 : c7488898
r3 : f0300000  r2 : 00001524  r1 : bf819654  r0 : c7488898
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA Thumb  Segment user
Control: 50c53c7d  Table: 075f406a  DAC: 00000015
Process modprobe (pid: 1258, stack limit = 0xedb9c240)
Stack: (0xedb9dd00 to 0xedb9e000)
dd00: ed9a7068 c7488440 00000001 bf818c28 c7488898 ed9a7000 00000000 c7488000
dd20: ed9a7068 c7488440 00000001 bf816950 c7488898 bf806caf 7ffffffe ec96a870
dd40: ec96a900 c00bdd75 edaea900 edaea900 00000001 00000001 ec96a870 ec96a870
dd60: 00000000 ec96a900 ec96a870 c03f5560 edaea900 ed9a7068 bf818c64 ed9a7000
dd80: 00000000 bf818c30 00000001 edb9c000 00000000 c017d1f5 ed9a7068 c0701170
dda0: 00000000 bf818c64 bf81e001 c019bead 00000000 ed9a7068 bf818c64 ed9a709c
ddc0: 00000000 c019bfb7 00000000 bf818c64 c019bf6d c019af43 ed8a02dc edaebeb4
dde0: bf818c64 c75e5880 c065c5b8 c019b967 bf818cac bf818c64 bf815948 bf818c64
de00: bf815948 bf8196a4 00000001 c019c379 bf818c30 bf818c28 bf815948 bf81e027
de20: 00000000 00400100 bf8196b0 c0008809 edb9de30 edb9de30 ed8f4d00 ed9e2000
de40: ed8f4d00 ed9e2000 ef7d2590 ef7d2580 40000000 f02a2000 ef7d2580 00000001
de60: f02a2000 00000000 ecd6d800 c0671680 ef7d2590 0000001f edb6df80 f02a2000
de80: 00000000 00400100 bf8196b0 bf8196a4 00000001 ecd6d800 00000001 00000124
dea0: bf8196ec c00555e3 bf8196b0 00007fff c0053c85 f02c1000 f02c0fff 00000000
dec0: f02a2000 bf8196b0 0001a670 edb9c000 00000000 bf8196b0 edb9c000 00000000
dee0: 0001a090 c007cbe3 edb9c000 00000000 0000001f 00000000 00000000 00000000
df00: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
df20: 00000000 00000000 00000000 00000000 ffffffff 0001e400 0002e328 0001a670
df40: 00000080 c000ce24 edb9c000 00000000 0001a090 c0055b3f f02a2000 0001e400
df60: f02b83e4 f02b8239 f02ba824 00015800 000169b0 00000000 00000000 00000000
df80: 00000028 00000029 0000001e 00000000 00000017 00000000 0001a070 0001a6e8
dfa0: 0001a688 c000cc81 0001a070 0001a6e8 0002e328 0001e400 0001a670 00000000
dfc0: 0001a070 0001a6e8 0001a688 00000080 0001a670 0001a008 0001a090 0001a090
dfe0: 00019220 bef988f8 0000bbd3 b6f1e558 60000030 0002e328 00000000 00000000
[<bf80fe26>] (igb_get_invariants_82575 [igb]) from [<bf806caf>] (igb_probe+0x22a/0xb80 [igb])
[<bf806caf>] (igb_probe [igb]) from [<c017d1f5>] (pci_device_probe+0x45/0x6c)
[<c017d1f5>] (pci_device_probe) from [<c019bead>] (driver_probe_device+0xb5/0x174)
[<c019bead>] (driver_probe_device) from [<c019bfb7>] (__driver_attach+0x4b/0x4c)
[<c019bfb7>] (__driver_attach) from [<c019af43>] (bus_for_each_dev+0x27/0x48)
[<c019af43>] (bus_for_each_dev) from [<c019b967>] (bus_add_driver+0x87/0x128)
[<c019b967>] (bus_add_driver) from [<c019c379>] (driver_register+0x35/0x84)
[<c019c379>] (driver_register) from [<bf81e027>] (init_module+0x26/0x3f [igb])
[<bf81e027>] (init_module [igb]) from [<c0008809>] (do_one_initcall+0xa1/0xe4)
[<c0008809>] (do_one_initcall) from [<c00555e3>] (load_module+0x1067/0x1544)
[<c00555e3>] (load_module) from [<c0055b3f>] (SyS_init_module+0x7f/0x8c)
[<c0055b3f>] (SyS_init_module) from [<c000cc81>] (ret_fast_syscall+0x1/0x46)
Code: 33b9 f8c4 6300 6863 (f8d3) 8018 
---[ end trace 53f41ddadca51c60 ]---
Kernel panic - not syncing: Fatal exception
CPU2: stopping
CPU: 2 PID: 0 Comm: swapper/2 Tainted: G      D W    3.14.0-mvebu #18
[<c0011c39>] (unwind_backtrace) from [<c000f20b>] (show_stack+0xb/0xc)
[<c000f20b>] (show_stack) from [<c02b5d1b>] (dump_stack+0x4f/0x64)
[<c02b5d1b>] (dump_stack) from [<c00113b3>] (handle_IPI+0xcb/0x100)
[<c00113b3>] (handle_IPI) from [<c0008485>] (armada_370_xp_handle_irq+0x7d/0xc8)
[<c0008485>] (armada_370_xp_handle_irq) from [<c000f9fb>] (__irq_svc+0x3b/0x5c)
Exception stack(0xed87ffa8 to 0xed87fff0)
ffa0:                   ffffffed 2d990000 c064ea1c 00000c32 ed87e000 c064e4ac
ffc0: c064e448 c0671ce5 00000001 c0671ce5 c02bae78 00000000 a0000000 ed87fff0
ffe0: c000d74d c00416ec 600f0033 ffffffff
[<c000f9fb>] (__irq_svc) from [<c00416ec>] (cpu_startup_entry+0x44/0xd4)
[<c00416ec>] (cpu_startup_entry) from [<00008569>] (0x8569)
CPU1: stopping
CPU: 1 PID: 0 Comm: swapper/1 Tainted: G      D W    3.14.0-mvebu #18
[<c0011c39>] (unwind_backtrace) from [<c000f20b>] (show_stack+0xb/0xc)
[<c000f20b>] (show_stack) from [<c02b5d1b>] (dump_stack+0x4f/0x64)
[<c02b5d1b>] (dump_stack) from [<c00113b3>] (handle_IPI+0xcb/0x100)
[<c00113b3>] (handle_IPI) from [<c0008485>] (armada_370_xp_handle_irq+0x7d/0xc8)
[<c0008485>] (armada_370_xp_handle_irq) from [<c000f9fb>] (__irq_svc+0x3b/0x5c)
Exception stack(0xed87dfa8 to 0xed87dff0)
dfa0:                   ffffffed 2d988000 c064ea1c 00001fa4 ed87c000 c064e4ac
dfc0: c064e448 c0671ce5 00000001 c0671ce5 c02bae78 00000000 a0000000 ed87dff0
dfe0: c000d74d c00416ec 600f0033 ffffffff
[<c000f9fb>] (__irq_svc) from [<c00416ec>] (cpu_startup_entry+0x44/0xd4)
[<c00416ec>] (cpu_startup_entry) from [<00008569>] (0x8569)
CPU3: stopping
CPU: 3 PID: 0 Comm: swapper/3 Tainted: G      D W    3.14.0-mvebu #18
[<c0011c39>] (unwind_backtrace) from [<c000f20b>] (show_stack+0xb/0xc)
[<c000f20b>] (show_stack) from [<c02b5d1b>] (dump_stack+0x4f/0x64)
[<c02b5d1b>] (dump_stack) from [<c00113b3>] (handle_IPI+0xcb/0x100)
[<c00113b3>] (handle_IPI) from [<c0008485>] (armada_370_xp_handle_irq+0x7d/0xc8)
[<c0008485>] (armada_370_xp_handle_irq) from [<c000f9fb>] (__irq_svc+0x3b/0x5c)
Exception stack(0xed881fa8 to 0xed881ff0)
1fa0:                   ffffffed 2d998000 c064ea1c 000006fc ed880000 c064e4ac
1fc0: c064e448 c0671ce5 00000001 c0671ce5 c02bae78 00000000 a0000000 ed881ff0
1fe0: c000d74d c00416ec 60000033 ffffffff
[<c000f9fb>] (__irq_svc) from [<c00416ec>] (cpu_startup_entry+0x44/0xd4)
[<c00416ec>] (cpu_startup_entry) from [<00008569>] (0x8569)
Rebooting in 1 seconds..
BootROM 1.20


The cause is obvious, the two callers compute a wrong size, so the attached
patch fixes it. After that I still get the panic but for the proper reason :

root@xpgp:~# modprobe igb
igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.5-k
igb: Copyright (c) 2007-2013 Intel Corporation.
PCI: enabling device 0000:00:09.0 (0140 -> 0143)
mvebu_pcie_handle_iobase_change: base=e8010000 size=00001000
mvebu_pcie_handle_membase_change: base=e0000000 size=00300000
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1242 at drivers/bus/mvebu-mbus.c:271 mvebu_mbus_setup_window+0xb3/0xe4()
Invalid MBus window size: 0x300000
Modules linked in: igb(+) i2c_algo_bit
CPU: 0 PID: 1242 Comm: modprobe Not tainted 3.14.0-mvebu #26
[<c0011c39>] (unwind_backtrace) from [<c000f20b>] (show_stack+0xb/0xc)
[<c000f20b>] (show_stack) from [<c02b5d4b>] (dump_stack+0x4f/0x64)
[<c02b5d4b>] (dump_stack) from [<c001a145>] (warn_slowpath_common+0x49/0x68)
[<c001a145>] (warn_slowpath_common) from [<c001a1bd>] (warn_slowpath_fmt+0x1d/0x28)
(...)

I still don't know why it ends up in a panic, but we die on the expected
test now.

Regards,
Willy


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-pci-mvebu-fix-off-by-one-in-the-computed-size-of-the.patch"

>From de000611015c7490a07ced6e36bfffbfdd136832 Mon Sep 17 00:00:00 2001
From: Willy Tarreau <w@1wt.eu>
Date: Wed, 9 Apr 2014 08:05:09 +0200
Subject: pci: mvebu: fix off-by-one in the computed size of the mbus windows

mvebu_pcie_handle_membase_change() and mvebu_pcie_handle_iobase_change()
compute a window size which is in fact a mask. This size is fed to
mvebu_mbus_add_window_by_id() which itself subtracts 1 to get the
mask. So clearly the two functions above are wrong.

Fix this by adding one to the computed size.

Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/pci/host/pci-mvebu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index 0e79665..eff0ab5 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -329,7 +329,7 @@ static void mvebu_pcie_handle_iobase_change(struct mvebu_pcie_port *port)
 	port->iowin_base = port->pcie->io.start + iobase;
 	port->iowin_size = ((0xFFF | ((port->bridge.iolimit & 0xF0) << 8) |
 			    (port->bridge.iolimitupper << 16)) -
-			    iobase);
+			    iobase) + 1;
 
 	mvebu_mbus_add_window_remap_by_id(port->io_target, port->io_attr,
 					  port->iowin_base, port->iowin_size,
@@ -362,7 +362,7 @@ static void mvebu_pcie_handle_membase_change(struct mvebu_pcie_port *port)
 	port->memwin_base  = ((port->bridge.membase & 0xFFF0) << 16);
 	port->memwin_size  =
 		(((port->bridge.memlimit & 0xFFF0) << 16) | 0xFFFFF) -
-		port->memwin_base;
+		port->memwin_base + 1;
 
 	mvebu_mbus_add_window_by_id(port->mem_target, port->mem_attr,
 				    port->memwin_base, port->memwin_size);
-- 
1.7.12.2.21.g234cd45.dirty


--dDRMvlgZJXvWKvBx--
