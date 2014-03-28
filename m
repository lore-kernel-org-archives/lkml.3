Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbaC1KuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 06:50:08 -0400
Received: from service87.mimecast.com ([91.220.42.44]:51891 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaC1KuE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 06:50:04 -0400
Date: Fri, 28 Mar 2014 10:50:00 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Rob Herring <robh@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [pci] BUG: unable to handle kernel NULL pointer dereference at
 00000000000000c8
Message-ID: <20140328105000.GX17163@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Fengguang Wu <fengguang.wu@intel.com>,
	Rob Herring <robh@kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20140328075851.GA18800@localhost>
MIME-Version: 1.0
In-Reply-To: <20140328075851.GA18800@localhost>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 28 Mar 2014 10:50:16.0145 (UTC) FILETIME=[80E88410:01CF4A73]
X-MC-Unique: 114032810500103701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 07:58:51AM +0000, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux versatile
> 
> commit 003b5e6f33242288b3da627ac8a9fffdc61067a0
> Author:     Liviu Dudau <Liviu.Dudau@arm.com>
> AuthorDate: Fri Mar 14 15:34:29 2014 +0000
> Commit:     Rob Herring <robh@kernel.org>
> CommitDate: Thu Mar 27 17:00:57 2014 -0500
> 
>     pci: Create pci_host_bridge before its associated bus in pci_create_root_bus.
>     
>     Before commit 7b5436635800 the pci_host_bridge was created before the root bus.
>     As that commit has added a needless dependency on the bus for pci_alloc_host_bridge()
>     the creation order has been changed for no good reason. Revert the order of
>     creation as we are going to depend on the pci_host_bridge structure to retrieve the
>     domain number of the root bus.
>     
>     Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
>     Acked-by: Grant Likely <grant.likely@linaro.org>
>     Tested-by: Tanmay Inamdar <tinamdar@apm.com>
> 
> +-----------------------------------------------------------+------------+------------+
> |                                                           | 003b5e6f33 | eef38aacf6 |
> +-----------------------------------------------------------+------------+------------+
> | boot_successes                                            | 0          | 0          |
> | boot_failures                                             | 20         | 19         |
> | BUG:unable_to_handle_kernel_NULL_pointer_dereference      | 20         | 19         |
> | Oops:SMP                                                  | 20         | 19         |
> | RIP:pcibios_root_bridge_prepare                           | 20         | 19         |
> | Kernel_panic-not_syncing:Attempted_to_kill_init_exitcode= | 20         | 19         |
> | backtrace:acpi_bus_scan                                   | 20         | 19         |
> | backtrace:acpi_scan_init                                  | 20         | 19         |
> | backtrace:acpi_init                                       | 20         | 19         |
> | backtrace:kernel_init_freeable                            | 20         | 19         |
> +-----------------------------------------------------------+------------+------------+
> 
> [    0.886041] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
> [    0.888121] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
> [    0.895383] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
> [    0.896026] BUG: unable to handle kernel NULL pointer dereference at 00000000000000c8
> [    0.897000] IP: [<ffffffff819a9387>] pcibios_root_bridge_prepare+0x11/0x26
> [    0.897000] PGD 0 
> [    0.897000] Oops: 0000 [#1] SMP 
> [    0.897000] Modules linked in:
> [    0.897000] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc2-00030-g003b5e6 #712
> [    0.897000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    0.897000] task: ffff88001e6c8000 ti: ffff88001e6c4000 task.ti: ffff88001e6c4000
> [    0.897000] RIP: 0010:[<ffffffff819a9387>]  [<ffffffff819a9387>] pcibios_root_bridge_prepare+0x11/0x26
> [    0.897000] RSP: 0000:ffff88001e6c5c00  EFLAGS: 00010282
> [    0.897000] RAX: 0000000000000000 RBX: ffff88001de68ee8 RCX: 0000000000000000
> [    0.897000] RDX: 0000000000000498 RSI: ffff88001e6c87f0 RDI: ffff88001dfe5cd0
> [    0.897000] RBP: ffff88001e6c5c90 R08: 00000000b0fa9e28 R09: 0000000000000001
> [    0.897000] R10: 000000000000a1e0 R11: 0000000000000000 R12: ffff88001dfe5cd0
> [    0.897000] R13: ffff88001de68f18 R14: 0000000000000000 R15: ffffffff821b1270
> [    0.897000] FS:  0000000000000000(0000) GS:ffff88001ea00000(0000) knlGS:0000000000000000
> [    0.897000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    0.897000] CR2: 00000000000000c8 CR3: 00000000020ae000 CR4: 00000000000006f0
> [    0.897000] Stack:
> [    0.897000]  ffffffff814b15dc ffff88001dfe6148 ffff88001e428000 ffff88001e6c5cc8
> [    0.897000]  0000000000000000 ffff88001e6c5c90 ffffffff815f10ea ffffffff82026a3d
> [    0.897000]  ffff88001e6c5c48 ffff880000000010 ffff88001e6c5ca0 ffff88001e6c5c60
> [    0.897000] Call Trace:
> [    0.897000]  [<ffffffff814b15dc>] ? pci_create_root_bus+0x7e/0x31e
> [    0.897000]  [<ffffffff815f10ea>] ? dev_warn+0x5c/0x5e
> [    0.897000]  [<ffffffff819a82be>] ? pci_mmconfig_insert+0xb2/0x1d0
> [    0.897000]  [<ffffffff819a92d8>] pci_acpi_scan_root+0x30c/0x3aa
> [    0.897000]  [<ffffffff814e0db9>] acpi_pci_root_add+0x25b/0x32f
> [    0.897000]  [<ffffffff814dd3c9>] acpi_bus_attach+0x85/0xf4
> [    0.897000]  [<ffffffff814dd425>] acpi_bus_attach+0xe1/0xf4
> [    0.897000]  [<ffffffff814dd425>] acpi_bus_attach+0xe1/0xf4
> [    0.897000]  [<ffffffff814dd493>] acpi_bus_scan+0x5b/0x6b
> [    0.897000]  [<ffffffff82412c02>] ? acpi_sleep_proc_init+0x2a/0x2a
> [    0.897000]  [<ffffffff82412ff2>] acpi_scan_init+0x60/0x18e
> [    0.897000]  [<ffffffff82412c02>] ? acpi_sleep_proc_init+0x2a/0x2a
> [    0.897000]  [<ffffffff82412e41>] acpi_init+0x23f/0x257
> [    0.897000]  [<ffffffff810002b2>] do_one_initcall+0x84/0x11a
> [    0.897000]  [<ffffffff81094152>] ? parse_args+0x189/0x249
> [    0.897000]  [<ffffffff823cdf75>] kernel_init_freeable+0x1d8/0x25d
> [    0.897000]  [<ffffffff823cd759>] ? do_early_param+0x88/0x88
> [    0.897000]  [<ffffffff81ae8469>] ? rest_init+0xcd/0xcd
> [    0.897000]  [<ffffffff81ae8477>] kernel_init+0xe/0xda
> [    0.897000]  [<ffffffff81b0f83c>] ret_from_fork+0x7c/0xb0
> [    0.897000]  [<ffffffff81ae8469>] ? rest_init+0xcd/0xcd
> [    0.897000] Code: 71 b0 ff 48 8b 1b eb ee 48 83 c4 38 4c 89 e8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 44 00 00 48 8b 87 70 04 00 00 55 48 89 e5 5d <48> 8b 80 c8 00 00 00 48 8b 40 08 48 89 87 c0 03 00 00 31 c0 c3 
> [    0.897000] RIP  [<ffffffff819a9387>] pcibios_root_bridge_prepare+0x11/0x26
> [    0.897000]  RSP <ffff88001e6c5c00>
> [    0.897000] CR2: 00000000000000c8
> [    0.897000] ---[ end trace 6110a1dd1810ff29 ]---
> [    0.897033] swapper/0 (1) used greatest stack depth: 3816 bytes left
> 
> git bisect start eef38aacf67aae8b10c07c8b55b3f0fee627c8fa a79528e9d849803457b6235ddb1a1cfd4e11c6cd --
> git bisect good f22b3e5788b29311219620adeb3edac565881241  # 09:02     20+      0  dts: versatile: add pci controller binding
> git bisect  bad 36623599ba01b3aba32c615a210ce50e195204fa  # 09:04      0-     20  pci: Export find_pci_host_bridge() function.
> git bisect good d5bb25094600d096be062f823109753c6b218400  # 09:12     20+      0  pci: OF: Fix the conversion of IO ranges into IO resources.
> git bisect  bad 003b5e6f33242288b3da627ac8a9fffdc61067a0  # 09:19      0-      7  pci: Create pci_host_bridge before its associated bus in pci_create_root_bus.
> # first bad commit: [003b5e6f33242288b3da627ac8a9fffdc61067a0] pci: Create pci_host_bridge before its associated bus in pci_create_root_bus.
> git bisect good d5bb25094600d096be062f823109753c6b218400  # 09:26     60+      0  pci: OF: Fix the conversion of IO ranges into IO resources.
> git bisect  bad eef38aacf67aae8b10c07c8b55b3f0fee627c8fa  # 09:26      0-     19  ARM: versatile: register sched_clock directly
> git bisect good f217c44ebd41ce7369d2df07622b2839479183b0  # 09:33     60+      0  Merge tag 'trace-fixes-v3.14-rc7-v2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace
> git bisect good 9eee0105595d9d1f3702d0e8d8cf4950e400ed0b  # 09:41     60+      0  Add linux-next specific files for 20140327
> 
> This script may reproduce the error.
> 
> -----------------------------------------------------------------------------
> #!/bin/bash
> 
> kernel=$1
> 
> kvm=(
>         qemu-system-x86_64 -cpu kvm64 -enable-kvm
>         -kernel $kernel
>         -smp 2
>         -m 256M
>         -net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio
>         -net user,vlan=0
>         -net nic,vlan=1,model=e1000
>         -net user,vlan=1
>         -boot order=nc
>         -no-reboot
>         -watchdog i6300esb
>         -serial stdio
>         -display none
>         -monitor null
> )
> 
> append=(
>         debug
>         sched_debug
>         apic=debug
>         ignore_loglevel
>         sysrq_always_enabled
>         panic=10
>         prompt_ramdisk=0
>         earlyprintk=ttyS0,115200
>         console=ttyS0,115200
>         console=tty0
>         vga=normal
>         root=/dev/ram0
>         rw            
> )
>  
> "${kvm[@]}" --append "${append[*]}"
> -----------------------------------------------------------------------------
> 
> 
> Thanks,
> Fengguang

[kernel log removed]


Fengguang,

Thanks for testing this. I will post an updated series soon and hope that Rob
will update his branch soon. Until then, can you try the following patch on
top of Rob's series?

Best regards,
Liviu

8<--------------------------------------------------------------------------
>From 46bc56e9239c04ee236f4b17526f3e7ebcda52cf Mon Sep 17 00:00:00 2001
From: Liviu Dudau <Liviu.Dudau@arm.com>
Date: Fri, 28 Mar 2014 10:47:59 +0000
Subject: pci: Fix crash on pcibios_root_bridge_prepare()

Commit 003b5e6f33242 changed the order of creation between bridge
and the root bus, but pcibios_root_bridge_prepare() is expecting
the root bus to be properly configured when called. Move the call
after the bus has been initialised (back in the original spot).

Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
---
 drivers/pci/probe.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 172c615..ddc7e34 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1734,9 +1734,6 @@ struct pci_bus *pci_create_root_bus_in_domain(struct device *parent,
 	bridge->dev.parent = parent;
 	bridge->dev.release = pci_release_host_bridge_dev;
 	bridge->domain_nr = domain;
-	error = pcibios_root_bridge_prepare(bridge);
-	if (error)
-		goto err_out;
 
 	b = pci_alloc_bus();
 	if (!b) {
@@ -1757,6 +1754,10 @@ struct pci_bus *pci_create_root_bus_in_domain(struct device *parent,
 
 	bridge->bus = b;
 	dev_set_name(&bridge->dev, "pci%04x:%02x", bridge->domain_nr, bus);
+	error = pcibios_root_bridge_prepare(bridge);
+	if (error)
+		goto err_out;
+
 	error = device_register(&bridge->dev);
 	if (error) {
 		put_device(&bridge->dev);


