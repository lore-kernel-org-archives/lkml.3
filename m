Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbaDNRz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:55:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755346AbaDNRzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:55:16 -0400
Message-ID: <1397498107.2419.5.camel@flatline.rdu.redhat.com>
Subject: [git bisect regression 3.15-rc1] NULL ptr deref in ichx_gpio_probe
From: Eric Paris <eparis@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: ptyser@xes-inc.com, linus.walleij@linaro.org, gnurou@gmail.com,
        linux-gpio@vger.kernel.org, vdonnefort@gmail.com
Date: Mon, 14 Apr 2014 13:55:07 -0400
Content-Type: multipart/mixed; boundary="=-ulZGu2Iq7uiVzD0xUh/i"
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ulZGu2Iq7uiVzD0xUh/i
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

I cannot boot 3.15-rc1 kernels because I get a NULL ptr bug in
ichx_gpio_probe.  The backtrace is at the end of the e-mail.  I did a
bisect and found:

$ git bisect good
b667cf488aa9476b0ab64acd91f2a96f188cfd21 is the first bad commit
commit b667cf488aa9476b0ab64acd91f2a96f188cfd21
Author: Vincent Donnefort <vdonnefort@gmail.com>
Date:   Fri Feb 7 14:21:05 2014 +0100

    gpio: ich: Add support for multiple register addresses

    This patch introduces regs and reglen pointers which allow a chipset to have
    register addresses differing from ICH ones.

    Signed-off-by: Vincent Donnefort <vdonnefort@gmail.com>
    Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

:040000 040000 f69690db4ff26eb01553bbc33679bf43d9054948 889bd1726d656d0a274edbc41c220e67e6151500 M      drivers

I am attaching the full dmesg from that boot as possibly other
information will be helpful...

The Backtrace:

[   18.021255] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   18.021617] IP: [<ffffffffa02a46a0>] ichx_gpio_probe+0x2a0/0x41c [gpio_ich]
[   18.021918] PGD 0
[   18.022011] Oops: 0000 [#1] SMP
[   18.022011] Modules linked in: gpio_ich(+) snd_seq_device snd_pcm i5400_edac joydev edac_core parport_pc snd_timer lpc_ich shpchp parport tpm_tis snd soundcore microcode i2c_i801 serio_raw mfd_core i5k_amb tpm nouveau hid_logitech_dj video mxm_wmi wmi i2c_algo_bit drm_kms_helper ttm drm ata_generic tg3 pata_acpi ptp pps_core i2c_core
[   18.022011] CPU: 5 PID: 553 Comm: systemd-udevd Not tainted 3.14.0-rc1+ #9
[   18.022011] Hardware name: Dell Inc. Precision WorkStation T5400  /0RW203, BIOS A04 08/21/2008
[   18.022011] task: ffff880033e2cc50 ti: ffff88044ba26000 task.ti: ffff88044ba26000
[   18.022011] RIP: 0010:[<ffffffffa02a46a0>]  [<ffffffffa02a46a0>] ichx_gpio_probe+0x2a0/0x41c [gpio_ich]
[   18.022011] RSP: 0018:ffff88044ba27ba0  EFLAGS: 00010246
[   18.022011] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[   18.022011] RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff81c3e180
[   18.022011] RBP: ffff88044ba27bd0 R08: 0000000000000000 R09: ffff880034fb04b0
[   18.022011] R10: 0000000000000001 R11: ffff880033e2d7f0 R12: ffff880034fb0000
[   18.022011] R13: ffff88044c28dcc0 R14: 0000000000000003 R15: 0000000000000000
[   18.022011] FS:  00007fbc8df5f880(0000) GS:ffff88045e000000(0000) knlGS:0000000000000000
[   18.022011] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   18.022011] CR2: 0000000000000000 CR3: 000000044b95e000 CR4: 00000000000007e0
[   18.022011] Stack:
[   18.022011]  ffff880034fb04b0 ffff880034fb0010 ffffffffa02a6028 ffff880034fb0000
[   18.022011]  0000000000000000 0000000000000001 ffff88044ba27c00 ffffffff814f4a55
[   18.022011]  ffffffff814f21a2 ffff880034fb0010 0000000000000000 ffffffffa02a6028
[   18.022011] Call Trace:
[   18.022011]  [<ffffffff814f4a55>] platform_drv_probe+0x45/0xb0
[   18.022011]  [<ffffffff814f21a2>] ? driver_sysfs_add+0x82/0xb0
[   18.022011]  [<ffffffff814f2945>] driver_probe_device+0x125/0x3a0
[   18.022011]  [<ffffffff814f2c93>] __driver_attach+0x93/0xa0
[   18.022011]  [<ffffffff814f2c00>] ? __device_attach+0x40/0x40
[   18.022011]  [<ffffffff814f0683>] bus_for_each_dev+0x73/0xc0
[   18.022011]  [<ffffffff814f22ce>] driver_attach+0x1e/0x20
[   18.022011]  [<ffffffff814f1e78>] bus_add_driver+0x188/0x260
[   18.022011]  [<ffffffffa00d0000>] ? 0xffffffffa00cffff
[   18.022011]  [<ffffffff814f3334>] driver_register+0x64/0xf0
[   18.022011]  [<ffffffffa00d0000>] ? 0xffffffffa00cffff
[   18.022011]  [<ffffffff814f497a>] __platform_driver_register+0x4a/0x50
[   18.022011]  [<ffffffffa00d0017>] ichx_gpio_driver_init+0x17/0x1000 [gpio_ich]
[   18.022011]  [<ffffffff8100214a>] do_one_initcall+0xfa/0x1b0
[   18.022011]  [<ffffffff81063e93>] ? set_memory_nx+0x43/0x50
[   18.022011]  [<ffffffff81130e58>] load_module+0x1c28/0x26d0
[   18.022011]  [<ffffffff8112bff0>] ? store_uevent+0x70/0x70
[   18.022011]  [<ffffffff81236790>] ? kernel_read+0x50/0x80
[   18.022011]  [<ffffffff81131ad6>] SyS_finit_module+0xa6/0xd0
[   18.022011]  [<ffffffff817c9f69>] system_call_fastpath+0x16/0x1b
[   18.022011] Code: 00 00 40 61 2a a0 e9 f0 fd ff ff 48 8b 05 81 1f 00 00 45 31 c0 48 c7 c7 80 e1 c3 81 4c 89 4d d0 48 8b 48 08 48 8b 50 10 48 63 c3 <0f> b6 34 01 0f b6 14 1a 4c 89 c9 49 03 75 00 e8 8c a2 df e0 48
[   18.022011] RIP  [<ffffffffa02a46a0>] ichx_gpio_probe+0x2a0/0x41c [gpio_ich]
[   18.022011]  RSP <ffff88044ba27ba0>
[   18.022011] CR2: 0000000000000000
[   18.047269] ---[ end trace 178b39b238232179 ]---


--=-ulZGu2Iq7uiVzD0xUh/i
Content-Disposition: attachment; filename="dmesg"
Content-Type: text/plain; name="dmesg"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.14.0-rc1+ (eparis@paris.rdu.redhat.com) (gcc version 4.8.2 20131212 (Red Hat 4.8.2-7) (GCC) ) #9 SMP Mon Apr 14 13:18:48 EDT 2014
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.14.0-rc1+ root=/dev/mapper/fedora_flatline-root ro rd.md=0 rd.lvm.lv=fedora_flatline/root rd.dm=0 vconsole.keymap=us rd.lvm.lv=fedora_flatline/swap rd.luks=0 vconsole.font=latarcyrheb-sun16 LANG=en_US.UTF-8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ebff] usable
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cfe0abff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cfe0ac00-0x00000000cfe5cbff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cfe5cc00-0x00000000cfe5ebff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000cfe5ec00-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fe000000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffb00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000046fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: Dell Inc. Precision WorkStation T5400  /0RW203, BIOS A04 08/21/2008
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x470000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask 2000000000 write-back
[    0.000000]   1 base 00CFF00000 mask 3FFFF00000 uncachable
[    0.000000]   2 base 00D0000000 mask 3FF0000000 uncachable
[    0.000000]   3 base 00E0000000 mask 3FE0000000 uncachable
[    0.000000]   4 base 1FF0000000 mask 3FF0000000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xcff00000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xcfe0a max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fe710-0x000fe71f] mapped at [ffff8800000fe710]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000098000] 98000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02dc2000, 0x02dc2fff] PGTABLE
[    0.000000] BRK [0x02dc3000, 0x02dc3fff] PGTABLE
[    0.000000] BRK [0x02dc4000, 0x02dc4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x46fe00000-0x46fffffff]
[    0.000000]  [mem 0x46fe00000-0x46fffffff] page 2M
[    0.000000] BRK [0x02dc5000, 0x02dc5fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x46c000000-0x46fdfffff]
[    0.000000]  [mem 0x46c000000-0x46fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x400000000-0x46bffffff]
[    0.000000]  [mem 0x400000000-0x46bffffff] page 2M
[    0.000000] BRK [0x02dc6000, 0x02dc6fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0xcfe09fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xcfdfffff] page 2M
[    0.000000]  [mem 0xcfe00000-0xcfe09fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
[    0.000000]  [mem 0x100000000-0x3ffffffff] page 2M
[    0.000000] BRK [0x02dc7000, 0x02dc7fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x32578000-0x352b3fff]
[    0.000000] ACPI: RSDP 00000000000febf0 000024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000000fcd58 0000BC (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: FACP 00000000000fce88 0000F4 (v03 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: DSDT 00000000fff62e18 003A12 (v01   DELL    dt_ex 00001000 INTL 20050624)
[    0.000000] ACPI: FACS 00000000cfe0ac00 000040
[    0.000000] ACPI: SSDT 00000000fff6694b 0000AC (v01   DELL    st_ex 00001000 INTL 20050624)
[    0.000000] ACPI: APIC 00000000000fcf7c 0000AA (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: BOOT 00000000000fd026 000028 (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: ASF! 00000000000fd04e 000096 (v32 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: MCFG 00000000000fd0e4 00003E (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: HPET 00000000000fd122 000038 (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: TCPA 00000000000fd37e 000032 (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: DMAR 00000000000fd3b0 0000C8 (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: SLIC 00000000000fd15a 000176 (v01 DELL    B9K     00000015 ASL  00000061)
[    0.000000] ACPI: SSDT 00000000cfe0ac40 000175 (v01 DpgPmm  Cpu0Ist 00000011 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000cfe0b049 000175 (v01 DpgPmm  Cpu1Ist 00000011 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000cfe0b452 000175 (v01 DpgPmm  Cpu2Ist 00000011 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000cfe0b85b 000175 (v01 DpgPmm  Cpu3Ist 00000011 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000cfe0bc64 000175 (v01 DpgPmm  Cpu4Ist 00000011 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000cfe0c06d 000175 (v01 DpgPmm  Cpu5Ist 00000011 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000cfe0c476 000175 (v01 DpgPmm  Cpu6Ist 00000011 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000cfe0c87f 000175 (v01 DpgPmm  Cpu7Ist 00000011 INTL 20050624)
[    0.000000] ACPI:    ? 00000000cfe0cc88 4D545243 (v04        \xffffffc1\xffffffe2\?k?\xffffffc7? A26A2957 ??\xffffffa6\xfffffff7 0FF8CC82)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000046fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x46fffffff]
[    0.000000]   NODE_DATA [mem 0x46ffca000-0x46fff0fff]
[    0.000000]  [ffffea0000000000-ffffea0011bfffff] PMD -> [ffff88045e600000-ffff88046f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x46fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009dfff]
[    0.000000]   node   0: [mem 0x00100000-0xcfe09fff]
[    0.000000]   node   0: [mem 0x100000000-0x46fffffff]
[    0.000000] On node 0 totalpages: 4455847
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13241 pages used for memmap
[    0.000000]   DMA32 zone: 847370 pages, LIFO batch:31
[    0.000000]   Normal zone: 56320 pages used for memmap
[    0.000000]   Normal zone: 3604480 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec88000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec88000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xfec89000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 10, version 32, address 0xfec89000, GSI 48-71
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 88
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcfe0a000-0xcfe0afff]
[    0.000000] PM: Registered nosave memory: [mem 0xcfe0b000-0xcfe5bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xcfe5c000-0xcfe5cfff]
[    0.000000] PM: Registered nosave memory: [mem 0xcfe5d000-0xcfe5dfff]
[    0.000000] PM: Registered nosave memory: [mem 0xcfe5e000-0xcfe5efff]
[    0.000000] PM: Registered nosave memory: [mem 0xcfe5f000-0xcfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd0000000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfdffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfe000000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffafffff]
[    0.000000] PM: Registered nosave memory: [mem 0xffb00000-0xffffffff]
[    0.000000] e820: [mem 0xd0000000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 478 pages/cpu @ffff88045d600000 s1926720 r8192 d22976 u2097152
[    0.000000] pcpu-alloc: s1926720 r8192 d22976 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5 [0] 6 [0] 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4386201
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.14.0-rc1+ root=/dev/mapper/fedora_flatline-root ro rd.md=0 rd.lvm.lv=fedora_flatline/root rd.dm=0 vconsole.keymap=us rd.lvm.lv=fedora_flatline/swap rd.luks=0 vconsole.font=latarcyrheb-sun16 LANG=en_US.UTF-8
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Memory: 17385368K/17823388K available (7993K kernel code, 1595K rwdata, 3256K rodata, 3692K init, 12860K bss, 438020K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU lockdep checking is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=8.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
[    0.000000] NR_IRQS:524544 nr_irqs:1560 16
[    0.000000] ACPI: Core revision 20131218
[    0.000000] kmemleak: Kernel memory leak detector disabled
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] allocated 71303168 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] ODEBUG: 32 of 32 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2493.827 MHz processor
[    0.001045] Calibrating delay loop (skipped), value calculated using timer frequency.. 4987.65 BogoMIPS (lpj=2493827)
[    0.002088] pid_max: default: 32768 minimum: 301
[    0.002264] Security Framework initialized
[    0.002358] SELinux:  Initializing.
[    0.002491] SELinux:  Starting in permissive mode
[    0.017576] Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.045731] Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.056384] Mount-cache hash table entries: 256
[    0.057569] Initializing cgroup subsys memory
[    0.057685] Initializing cgroup subsys devices
[    0.057786] Initializing cgroup subsys freezer
[    0.057885] Initializing cgroup subsys net_cls
[    0.057969] Initializing cgroup subsys blkio
[    0.058007] Initializing cgroup subsys perf_event
[    0.058094] Initializing cgroup subsys net_prio
[    0.058178] Initializing cgroup subsys hugetlb
[    0.058329] CPU: Physical Processor ID: 0
[    0.058412] CPU: Processor Core ID: 0
[    0.058494] mce: CPU supports 6 MCE banks
[    0.058583] CPU0: Thermal monitoring enabled (TM2)
[    0.058676] Last level iTLB entries: 4KB 128, 2MB 4, 4MB 4
Last level dTLB entries: 4KB 256, 2MB 0, 4MB 32, 1GB 0
tlb_flushall_shift: -1
[    0.059121] Freeing SMP alternatives memory: 24K (ffffffff8212b000 - ffffffff82131000)
[    0.061235] ftrace: allocating 26229 entries in 103 pages
[    0.068460] dmar: Host address width 38
[    0.068544] dmar: DRHD base: 0x000000fe710000 flags: 0x0
[    0.068654] dmar: IOMMU 0: reg_base_addr fe710000 ver 1:0 cap 900000c2f0462 ecap e01
[    0.068775] dmar: DRHD base: 0x000000fe714000 flags: 0x0
[    0.068866] dmar: IOMMU 1: reg_base_addr fe714000 ver 1:0 cap 900000c2f0462 ecap e01
[    0.069006] dmar: DRHD base: 0x000000fe719000 flags: 0x0
[    0.069098] dmar: IOMMU 2: reg_base_addr fe719000 ver 1:0 cap 900000c2f0462 ecap e01
[    0.070005] dmar: DRHD base: 0x000000fe718000 flags: 0x1
[    0.070097] dmar: IOMMU 3: reg_base_addr fe718000 ver 1:0 cap 900000c2f0462 ecap e01
[    0.070217] dmar: RMRR base: 0x000000cfe61000 end: 0x000000cfe6ffff
[    0.071233] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.081333] smpboot: CPU0: Intel(R) Xeon(R) CPU           E5420  @ 2.50GHz (fam: 06, model: 17, stepping: 06)
[    0.082000] Performance Events: PEBS fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
[    0.082000] ... version:                2
[    0.082000] ... bit width:              40
[    0.082000] ... generic registers:      2
[    0.082000] ... value mask:             000000ffffffffff
[    0.082000] ... max period:             000000007fffffff
[    0.082000] ... fixed-purpose events:   3
[    0.082000] ... event mask:             0000000700000003
[    0.085453] x86: Booting SMP configuration:
[    0.085537] .... node  #0, CPUs:      #1
[    0.157482] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.158102]  #2 #3 #4 #5 #6 #7
[    0.233132] x86: Booted up 1 node, 8 CPUs
[    0.234005] smpboot: Total of 8 processors activated (39899.82 BogoMIPS)
[    0.237317] devtmpfs: initialized
[    0.254601] PM: Registering ACPI NVS region [mem 0xcfe0ac00-0xcfe5cbff] (335872 bytes)
[    0.254601] reboot: Dell Precision T5400 series board detected. Selecting BIOS-method for reboots.
[    0.257336] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.257423] pinctrl core: initialized pinctrl subsystem
[    0.257762] RTC time: 17:33:53, date: 04/14/14
[    0.258117] NET: Registered protocol family 16
[    0.258727] cpuidle: using governor menu
[    0.258926] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.259017] ACPI: bus type PCI registered
[    0.259100] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.259419] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.259544] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.296191] PCI: Using configuration type 1 for base access
[    0.305274] bio: create slab <bio-0> at 0
[    0.306354] ACPI: Added _OSI(Module Device)
[    0.306443] ACPI: Added _OSI(Processor Device)
[    0.306526] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.306609] ACPI: Added _OSI(Processor Aggregator Device)
[    0.335253] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.464347] ACPI: Interpreter enabled
[    0.464448] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131218/hwxface-580)
[    0.464709] ACPI: (supports S0 S1 S3 S4 S5)
[    0.464792] ACPI: Using IOAPIC for interrupt routing
[    0.465115] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.465595] ACPI: No dock devices found.
[    0.708118] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.708213] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.708400] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.725383] PCI host bridge to bus 0000:00
[    0.725473] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.725567] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.725653] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.725738] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.725824] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000effff]
[    0.725909] pci_bus 0000:00: root bus resource [mem 0x000f0000-0x000fffff]
[    0.726005] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfe000000]
[    0.726091] pci_bus 0000:00: root bus resource [mem 0xcff00000-0xdfffffff]
[    0.726177] pci_bus 0000:00: root bus resource [mem 0xff980800-0xff980bff]
[    0.726263] pci_bus 0000:00: root bus resource [mem 0xff97c000-0xff97ffff]
[    0.726348] pci_bus 0000:00: root bus resource [mem 0xfed20000-0xfed9ffff]
[    0.726475] pci 0000:00:00.0: [8086:4001] type 00 class 0x060000
[    0.726630] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.727212] pci 0000:00:01.0: [8086:4021] type 01 class 0x060400
[    0.727320] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.727744] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.728025] pci 0000:00:05.0: [8086:4025] type 01 class 0x060400
[    0.728131] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.728495] pci 0000:00:05.0: System wakeup disabled by ACPI
[    0.728772] pci 0000:00:09.0: [8086:4029] type 01 class 0x060400
[    0.728876] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    0.729247] pci 0000:00:09.0: System wakeup disabled by ACPI
[    0.729528] pci 0000:00:10.0: [8086:4030] type 00 class 0x060000
[    0.730045] pci 0000:00:10.1: [8086:4030] type 00 class 0x060000
[    0.730554] pci 0000:00:10.2: [8086:4030] type 00 class 0x060000
[    0.731074] pci 0000:00:10.3: [8086:4030] type 00 class 0x060000
[    0.731588] pci 0000:00:10.4: [8086:4030] type 00 class 0x060000
[    0.732111] pci 0000:00:11.0: [8086:4031] type 00 class 0x060000
[    0.732631] pci 0000:00:15.0: [8086:4035] type 00 class 0x060000
[    0.733139] pci 0000:00:15.1: [8086:4035] type 00 class 0x060000
[    0.733666] pci 0000:00:16.0: [8086:4036] type 00 class 0x060000
[    0.734177] pci 0000:00:16.1: [8086:4036] type 00 class 0x060000
[    0.734720] pci 0000:00:1b.0: [8086:269a] type 00 class 0x040300
[    0.734746] pci 0000:00:1b.0: reg 0x10: [mem 0xfbffc000-0xfbffffff 64bit]
[    0.734879] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.735407] pci 0000:00:1c.0: [8086:2690] type 01 class 0x060400
[    0.735551] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.735915] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.736196] pci 0000:00:1d.0: [8086:2688] type 00 class 0x0c0300
[    0.736260] pci 0000:00:1d.0: reg 0x20: [io  0xff80-0xff9f]
[    0.736661] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.736932] pci 0000:00:1d.1: [8086:2689] type 00 class 0x0c0300
[    0.737010] pci 0000:00:1d.1: reg 0x20: [io  0xff60-0xff7f]
[    0.737401] pci 0000:00:1d.1: System wakeup disabled by ACPI
[    0.737665] pci 0000:00:1d.2: [8086:268a] type 00 class 0x0c0300
[    0.737729] pci 0000:00:1d.2: reg 0x20: [io  0xff40-0xff5f]
[    0.738125] pci 0000:00:1d.2: System wakeup disabled by ACPI
[    0.738396] pci 0000:00:1d.3: [8086:268b] type 00 class 0x0c0300
[    0.738460] pci 0000:00:1d.3: reg 0x20: [io  0xff20-0xff3f]
[    0.738851] pci 0000:00:1d.3: System wakeup disabled by ACPI
[    0.739128] pci 0000:00:1d.7: [8086:268c] type 00 class 0x0c0320
[    0.739158] pci 0000:00:1d.7: reg 0x10: [mem 0xff980800-0xff980bff]
[    0.739292] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.739813] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.740257] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.740531] pci 0000:00:1f.0: [8086:2670] type 00 class 0x060100
[    0.741119] pci 0000:00:1f.1: [8086:269e] type 00 class 0x01018a
[    0.741139] pci 0000:00:1f.1: reg 0x10: [io  0x01f0-0x01f7]
[    0.741153] pci 0000:00:1f.1: reg 0x14: [io  0x03f4-0x03f7]
[    0.741167] pci 0000:00:1f.1: reg 0x18: [io  0x0170-0x0177]
[    0.741181] pci 0000:00:1f.1: reg 0x1c: [io  0x0374-0x0377]
[    0.741195] pci 0000:00:1f.1: reg 0x20: [io  0xffa0-0xffaf]
[    0.741716] pci 0000:00:1f.2: [8086:2681] type 00 class 0x010601
[    0.741742] pci 0000:00:1f.2: reg 0x10: [io  0xfe00-0xfe07]
[    0.741755] pci 0000:00:1f.2: reg 0x14: [io  0xfe10-0xfe13]
[    0.741767] pci 0000:00:1f.2: reg 0x18: [io  0xfe20-0xfe27]
[    0.741780] pci 0000:00:1f.2: reg 0x1c: [io  0xfe30-0xfe33]
[    0.741793] pci 0000:00:1f.2: reg 0x20: [io  0xfec0-0xfedf]
[    0.741806] pci 0000:00:1f.2: reg 0x24: [mem 0xff970000-0xff9703ff]
[    0.741872] pci 0000:00:1f.2: PME# supported from D3hot
[    0.742384] pci 0000:00:1f.3: [8086:269b] type 00 class 0x0c0500
[    0.742464] pci 0000:00:1f.3: reg 0x20: [io  0xece0-0xecff]
[    0.743129] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.743219] pci 0000:00:01.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    0.743404] pci 0000:02:00.0: [10de:040e] type 00 class 0x030000
[    0.743423] pci 0000:02:00.0: reg 0x10: [mem 0xfa000000-0xfaffffff]
[    0.743441] pci 0000:02:00.0: reg 0x14: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.743460] pci 0000:02:00.0: reg 0x1c: [mem 0xf8000000-0xf9ffffff 64bit]
[    0.743473] pci 0000:02:00.0: reg 0x24: [io  0xdc80-0xdcff]
[    0.743486] pci 0000:02:00.0: reg 0x30: [mem 0xfbd00000-0xfbd1ffff pref]
[    0.745062] pci 0000:00:05.0: PCI bridge to [bus 02]
[    0.745156] pci 0000:00:05.0:   bridge window [io  0xd000-0xdfff]
[    0.745161] pci 0000:00:05.0:   bridge window [mem 0xf8000000-0xfbdfffff]
[    0.745169] pci 0000:00:05.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.745608] pci 0000:03:00.0: [8086:3500] type 01 class 0x060400
[    0.745726] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.745887] pci 0000:03:00.0: System wakeup disabled by ACPI
[    0.746166] pci 0000:03:00.3: [8086:350c] type 01 class 0x060400
[    0.746283] pci 0000:03:00.3: PME# supported from D0 D3hot D3cold
[    0.746463] pci 0000:03:00.3: System wakeup disabled by ACPI
[    0.748027] pci 0000:00:09.0: PCI bridge to [bus 03-07]
[    0.748124] pci 0000:00:09.0:   bridge window [mem 0xf7f00000-0xf7ffffff]
[    0.748574] pci 0000:04:00.0: [8086:3510] type 01 class 0x060400
[    0.748701] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    0.748867] pci 0000:04:00.0: System wakeup disabled by ACPI
[    0.749142] pci 0000:04:01.0: [8086:3514] type 01 class 0x060400
[    0.749270] pci 0000:04:01.0: PME# supported from D0 D3hot D3cold
[    0.749444] pci 0000:04:01.0: System wakeup disabled by ACPI
[    0.749761] pci 0000:03:00.0: PCI bridge to [bus 04-06]
[    0.750029] pci 0000:04:00.0: PCI bridge to [bus 05]
[    0.750288] pci 0000:04:01.0: PCI bridge to [bus 06]
[    0.750630] pci 0000:03:00.3: PCI bridge to [bus 07]
[    0.750934] pci 0000:08:00.0: [14e4:167a] type 00 class 0x020000
[    0.750968] pci 0000:08:00.0: reg 0x10: [mem 0xf7ef0000-0xf7efffff 64bit]
[    0.751200] pci 0000:08:00.0: PME# supported from D3hot D3cold
[    0.753032] pci 0000:00:1c.0: PCI bridge to [bus 08]
[    0.753130] pci 0000:00:1c.0:   bridge window [mem 0xf7e00000-0xf7efffff]
[    0.753350] pci 0000:00:1e.0: PCI bridge to [bus 09] (subtractive decode)
[    0.753459] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.753462] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.753464] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.753467] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000effff] (subtractive decode)
[    0.753470] pci 0000:00:1e.0:   bridge window [mem 0x000f0000-0x000fffff] (subtractive decode)
[    0.753472] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfe000000] (subtractive decode)
[    0.753475] pci 0000:00:1e.0:   bridge window [mem 0xcff00000-0xdfffffff] (subtractive decode)
[    0.753477] pci 0000:00:1e.0:   bridge window [mem 0xff980800-0xff980bff] (subtractive decode)
[    0.753480] pci 0000:00:1e.0:   bridge window [mem 0xff97c000-0xff97ffff] (subtractive decode)
[    0.753482] pci 0000:00:1e.0:   bridge window [mem 0xfed20000-0xfed9ffff] (subtractive decode)
[    0.774509] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 15)
[    0.775655] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    0.776806] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    0.778044] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
[    0.779338] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *9 10 11 12 15)
[    0.780516] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11 12 15)
[    0.781653] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 15)
[    0.782848] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12 15)
[    0.783709] ACPI: Enabled 2 GPEs in block 00 to 1F
[    0.784266] vgaarb: device added: PCI:0000:02:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.784404] vgaarb: loaded
[    0.784489] vgaarb: bridge control possible 0000:02:00.0
[    0.785196] SCSI subsystem initialized
[    0.785448] libata version 3.00 loaded.
[    0.785448] ACPI: bus type USB registered
[    0.785448] usbcore: registered new interface driver usbfs
[    0.785531] usbcore: registered new interface driver hub
[    0.786080] usbcore: registered new device driver usb
[    0.786678] PCI: Using ACPI for IRQ routing
[    0.795359] PCI: pci_cache_line_size set to 64 bytes
[    0.795440] pci 0000:00:1f.2: no compatible bridge window for [mem 0xff970000-0xff9703ff]
[    0.795623] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    0.795718] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    0.795814] e820: reserve RAM buffer [mem 0x0009ec00-0x0009ffff]
[    0.795823] e820: reserve RAM buffer [mem 0xcfe0ac00-0xcfffffff]
[    0.796562] NetLabel: Initializing
[    0.796644] NetLabel:  domain hash size = 128
[    0.796736] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.796884] NetLabel:  unlabeled traffic allowed by default
[    0.797072] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.797160] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.797413] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.801496] Switched to clocksource hpet
[    0.872930] pnp: PnP ACPI init
[    0.873107] ACPI: bus type PNP registered
[    0.878444] system 00:00: [io  0x0800-0x085f] could not be reserved
[    0.878532] system 00:00: [io  0x0c00-0x0c7f] has been reserved
[    0.878618] system 00:00: [io  0x0860-0x08ff] has been reserved
[    0.878765] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.878917] pnp 00:01: [dma 4]
[    0.879035] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.879283] pnp 00:02: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.879514] pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.879745] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.894551] pnp 00:05: [dma 0 disabled]
[    0.895156] pnp 00:05: Plug and Play ACPI device, IDs PNP0401 (active)
[    0.899506] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.903862] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.908501] pnp 00:08: Plug and Play ACPI device, IDs WEC1000 PNP0c31 (active)
[    0.918848] pnp 00:09: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.918863] pnp: PnP ACPI: found 10 devices
[    0.918947] ACPI: bus type PNP unregistered
[    0.933408] pci 0000:00:1f.2: BAR 5: assigned [mem 0xf0000000-0xf00003ff]
[    0.933501] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.933589] pci 0000:00:01.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    0.933682] pci 0000:00:05.0: PCI bridge to [bus 02]
[    0.933767] pci 0000:00:05.0:   bridge window [io  0xd000-0xdfff]
[    0.933856] pci 0000:00:05.0:   bridge window [mem 0xf8000000-0xfbdfffff]
[    0.933944] pci 0000:00:05.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.934083] pci 0000:04:00.0: PCI bridge to [bus 05]
[    0.934180] pci 0000:04:01.0: PCI bridge to [bus 06]
[    0.934278] pci 0000:03:00.0: PCI bridge to [bus 04-06]
[    0.934376] pci 0000:03:00.3: PCI bridge to [bus 07]
[    0.934472] pci 0000:00:09.0: PCI bridge to [bus 03-07]
[    0.934560] pci 0000:00:09.0:   bridge window [mem 0xf7f00000-0xf7ffffff]
[    0.934653] pci 0000:00:1c.0: PCI bridge to [bus 08]
[    0.934741] pci 0000:00:1c.0:   bridge window [mem 0xf7e00000-0xf7efffff]
[    0.934836] pci 0000:00:1e.0: PCI bridge to [bus 09]
[    0.934933] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.934936] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.934938] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.934941] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000effff]
[    0.934943] pci_bus 0000:00: resource 8 [mem 0x000f0000-0x000fffff]
[    0.934945] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfe000000]
[    0.934948] pci_bus 0000:00: resource 10 [mem 0xcff00000-0xdfffffff]
[    0.934950] pci_bus 0000:00: resource 11 [mem 0xff980800-0xff980bff]
[    0.934952] pci_bus 0000:00: resource 12 [mem 0xff97c000-0xff97ffff]
[    0.934955] pci_bus 0000:00: resource 13 [mem 0xfed20000-0xfed9ffff]
[    0.934957] pci_bus 0000:01: resource 1 [mem 0xfbe00000-0xfbefffff]
[    0.934960] pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
[    0.934962] pci_bus 0000:02: resource 1 [mem 0xf8000000-0xfbdfffff]
[    0.934964] pci_bus 0000:02: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.934967] pci_bus 0000:03: resource 1 [mem 0xf7f00000-0xf7ffffff]
[    0.934970] pci_bus 0000:08: resource 1 [mem 0xf7e00000-0xf7efffff]
[    0.934972] pci_bus 0000:09: resource 4 [io  0x0000-0x0cf7]
[    0.934975] pci_bus 0000:09: resource 5 [io  0x0d00-0xffff]
[    0.934977] pci_bus 0000:09: resource 6 [mem 0x000a0000-0x000bffff]
[    0.934979] pci_bus 0000:09: resource 7 [mem 0x000c0000-0x000effff]
[    0.934982] pci_bus 0000:09: resource 8 [mem 0x000f0000-0x000fffff]
[    0.934984] pci_bus 0000:09: resource 9 [mem 0xf0000000-0xfe000000]
[    0.934986] pci_bus 0000:09: resource 10 [mem 0xcff00000-0xdfffffff]
[    0.934988] pci_bus 0000:09: resource 11 [mem 0xff980800-0xff980bff]
[    0.934990] pci_bus 0000:09: resource 12 [mem 0xff97c000-0xff97ffff]
[    0.934993] pci_bus 0000:09: resource 13 [mem 0xfed20000-0xfed9ffff]
[    0.935079] NET: Registered protocol family 2
[    0.936705] TCP established hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.940138] TCP bind hash table entries: 65536 (order: 10, 5242880 bytes)
[    0.944873] TCP: Hash tables configured (established 262144 bind 65536)
[    0.945102] TCP: reno registered
[    0.946525] UDP hash table entries: 16384 (order: 9, 3145728 bytes)
[    0.950341] UDP-Lite hash table entries: 16384 (order: 9, 3145728 bytes)
[    0.953280] NET: Registered protocol family 1
[    0.963610] pci 0000:00:1f.0: rerouting interrupts for [8086:2670]
[    0.963729] pci 0000:02:00.0: Boot video device
[    0.963754] PCI: CLS 64 bytes, default 64
[    0.964167] Unpacking initramfs...
[    2.079295] Freeing initrd memory: 46320K (ffff880032578000 - ffff8800352b4000)
[    2.106496] DMA-API: preallocated 65536 debug entries
[    2.106588] DMA-API: debugging enabled by kernel config
[    2.106698] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.106785] software IO TLB [mem 0xcbe0a000-0xcfe0a000] (64MB) mapped at [ffff8800cbe0a000-ffff8800cfe09fff]
[    2.107023] Simple Boot Flag at 0x7a set to 0x80
[    2.111091] Scanning for low memory corruption every 60 seconds
[    2.111957] cryptomgr_test (66) used greatest stack depth: 5832 bytes left
[    2.113402] futex hash table entries: 2048 (order: 6, 262144 bytes)
[    2.114042] Initialise system trusted keyring
[    2.114260] audit: initializing netlink subsys (disabled)
[    2.114440] audit: type=2000 audit(1397496835.113:1): initialized
[    2.139373] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.151105] zbud: loaded
[    2.152703] VFS: Disk quotas dquot_6.5.2
[    2.152982] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.155546] msgmni has been set to 32768
[    2.155979] Key type big_key registered
[    2.156077] SELinux:  Registering netfilter hooks
[    2.157768] cryptomgr_test (71) used greatest stack depth: 5496 bytes left
[    2.158247] cryptomgr_test (73) used greatest stack depth: 5064 bytes left
[    2.159046] cryptomgr_test (76) used greatest stack depth: 5048 bytes left
[    2.159525] alg: No test for stdrng (krng)
[    2.159637] NET: Registered protocol family 38
[    2.159755] Key type asymmetric registered
[    2.159857] Asymmetric key parser 'x509' registered
[    2.159977] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    2.160316] io scheduler noop registered
[    2.160401] io scheduler deadline registered
[    2.160777] io scheduler cfq registered (default)
[    2.162248] list_sort_test: start testing list_sort()
[    2.168187] pcieport 0000:00:1c.0: irq 88 for MSI/MSI-X
[    2.169915] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.170167] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.170574] intel_idle: does not run on family 6 model 23
[    2.170878] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    2.171056] ACPI: Power Button [VBTN]
[    2.171373] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.171499] ACPI: Power Button [PWRF]
[    2.172917] GHES: HEST is not enabled!
[    2.173294] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.194213] 00:06: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    2.215323] 00:07: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    2.217338] Non-volatile memory driver v1.3
[    2.217422] Linux agpgart interface v0.103
[    2.218342] ahci 0000:00:1f.2: version 3.0
[    2.219682] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x1f impl SATA mode
[    2.219806] ahci 0000:00:1f.2: flags: 64bit ncq pm led slum part 
[    2.224022] scsi0 : ahci
[    2.224734] scsi1 : ahci
[    2.225304] scsi2 : ahci
[    2.225888] scsi3 : ahci
[    2.226460] scsi4 : ahci
[    2.227046] scsi5 : ahci
[    2.227386] ata1: SATA max UDMA/133 abar m1024@0xf0000000 port 0xf0000100 irq 20
[    2.227509] ata2: SATA max UDMA/133 abar m1024@0xf0000000 port 0xf0000180 irq 20
[    2.227629] ata3: SATA max UDMA/133 abar m1024@0xf0000000 port 0xf0000200 irq 20
[    2.227749] ata4: SATA max UDMA/133 abar m1024@0xf0000000 port 0xf0000280 irq 20
[    2.227870] ata5: SATA max UDMA/133 abar m1024@0xf0000000 port 0xf0000300 irq 20
[    2.227990] ata6: DUMMY
[    2.228280] ata_piix 0000:00:1f.1: version 2.13
[    2.231321] scsi6 : ata_piix
[    2.231867] scsi7 : ata_piix
[    2.232187] ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    2.232274] ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    2.232590] ata7: port disabled--ignoring
[    2.232677] ata8: port disabled--ignoring
[    2.232696] libphy: Fixed MDIO Bus: probed
[    2.233043] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.233167] ehci-pci: EHCI PCI platform driver
[    2.234530] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    2.235145] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    2.235351] ehci-pci 0000:00:1d.7: debug port 1
[    2.239426] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
[    2.239495] ehci-pci 0000:00:1d.7: irq 21, io mem 0xff980800
[    2.245055] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.245533] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.245620] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.245741] usb usb1: Product: EHCI Host Controller
[    2.245824] usb usb1: Manufacturer: Linux 3.14.0-rc1+ ehci_hcd
[    2.245908] usb usb1: SerialNumber: 0000:00:1d.7
[    2.247021] hub 1-0:1.0: USB hub found
[    2.247189] hub 1-0:1.0: 8 ports detected
[    2.248862] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.248959] ohci-pci: OHCI PCI platform driver
[    2.249120] uhci_hcd: USB Universal Host Controller Interface driver
[    2.250411] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.250705] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.250837] uhci_hcd 0000:00:1d.0: detected 2 ports
[    2.250946] uhci_hcd 0000:00:1d.0: irq 21, io base 0x0000ff80
[    2.251262] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    2.251348] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.251469] usb usb2: Product: UHCI Host Controller
[    2.251552] usb usb2: Manufacturer: Linux 3.14.0-rc1+ uhci_hcd
[    2.251637] usb usb2: SerialNumber: 0000:00:1d.0
[    2.252295] hub 2-0:1.0: USB hub found
[    2.252414] hub 2-0:1.0: 2 ports detected
[    2.254230] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.254528] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    2.254660] uhci_hcd 0000:00:1d.1: detected 2 ports
[    2.254799] uhci_hcd 0000:00:1d.1: irq 22, io base 0x0000ff60
[    2.255077] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.255164] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.255285] usb usb3: Product: UHCI Host Controller
[    2.255368] usb usb3: Manufacturer: Linux 3.14.0-rc1+ uhci_hcd
[    2.255452] usb usb3: SerialNumber: 0000:00:1d.1
[    2.256106] hub 3-0:1.0: USB hub found
[    2.256215] hub 3-0:1.0: 2 ports detected
[    2.257967] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.258268] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    2.258399] uhci_hcd 0000:00:1d.2: detected 2 ports
[    2.258538] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000ff40
[    2.258802] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.258889] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.259024] usb usb4: Product: UHCI Host Controller
[    2.259108] usb usb4: Manufacturer: Linux 3.14.0-rc1+ uhci_hcd
[    2.259192] usb usb4: SerialNumber: 0000:00:1d.2
[    2.259822] hub 4-0:1.0: USB hub found
[    2.259930] hub 4-0:1.0: 2 ports detected
[    2.261702] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    2.261989] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    2.262134] uhci_hcd 0000:00:1d.3: detected 2 ports
[    2.262273] uhci_hcd 0000:00:1d.3: irq 23, io base 0x0000ff20
[    2.262533] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.262619] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.262740] usb usb5: Product: UHCI Host Controller
[    2.262823] usb usb5: Manufacturer: Linux 3.14.0-rc1+ uhci_hcd
[    2.262908] usb usb5: SerialNumber: 0000:00:1d.3
[    2.263571] hub 5-0:1.0: USB hub found
[    2.263679] hub 5-0:1.0: 2 ports detected
[    2.264522] usbcore: registered new interface driver usbserial
[    2.264642] usbcore: registered new interface driver usbserial_generic
[    2.264817] usbserial: USB Serial support registered for generic
[    2.265022] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    2.267946] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.268185] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.269032] mousedev: PS/2 mouse device common for all mice
[    2.270234] rtc_cmos 00:04: RTC can wake from S4
[    2.270790] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    2.270926] rtc_cmos 00:04: alarms up to one day, 242 bytes nvram, hpet irqs
[    2.271364] device-mapper: uevent: version 1.0.3
[    2.271818] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    2.274875] hidraw: raw HID events driver (C) Jiri Kosina
[    2.275487] usbcore: registered new interface driver usbhid
[    2.275572] usbhid: USB HID core driver
[    2.275920] drop_monitor: Initializing network drop monitor service
[    2.276283] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.276481] TCP: cubic registered
[    2.276566] Initializing XFRM netlink socket
[    2.277347] NET: Registered protocol family 10
[    2.278220] mip6: Mobile IPv6
[    2.278318] NET: Registered protocol family 17
[    2.280243] Loading compiled-in X.509 certificates
[    2.281648] Loaded X.509 cert 'Magrathea: Glacier signing key: 04ce000cb42283ef546f7addba94733473797c88'
[    2.281813] registered taskstats version 1
[    2.283711]   Magic number: 10:870:592
[    2.283963] rtc_cmos 00:04: setting system clock to 2014-04-14 17:33:55 UTC (1397496835)
[    2.284354] PM: Hibernation image not present or could not be loaded.
[    2.533050] ata5: SATA link down (SStatus 4 SControl 300)
[    2.533205] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.533397] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.533528] ata4: SATA link down (SStatus 0 SControl 300)
[    2.533653] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.534089] ata3.00: ATAPI: TSSTcorp DVD+/-RW TS-H653F, D200, max UDMA/100
[    2.534184] ata3.00: applying bridge limits
[    2.534444] ata2.00: ATA-8: Hitachi HDS721010DLE630, MS2OA5Q0, max UDMA/133
[    2.534543] ata2.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    2.535208] ata3.00: configured for UDMA/100
[    2.535649] ata2.00: configured for UDMA/133
[    2.556744] ata1.00: ATA-8: Hitachi HDP725025GLA380, GM2OA5BA, max UDMA/133
[    2.556836] ata1.00: 488281250 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    2.558032] ata1.00: configured for UDMA/133
[    2.559241] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HDP72502 GM2O PQ: 0 ANSI: 5
[    2.560525] sd 0:0:0:0: [sda] 488281250 512-byte logical blocks: (250 GB/232 GiB)
[    2.560819] sd 0:0:0:0: [sda] Write Protect is off
[    2.560871] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.560988] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.561097] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.561832] scsi 1:0:0:0: Direct-Access     ATA      Hitachi HDS72101 MS2O PQ: 0 ANSI: 5
[    2.562527] sd 1:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    2.562656] sd 1:0:0:0: [sdb] 4096-byte physical blocks
[    2.562742] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    2.562912] sd 1:0:0:0: [sdb] Write Protect is off
[    2.563000] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.563102] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.563985] scsi 2:0:0:0: CD-ROM            TSSTcorp DVD+-RW TS-H653F D200 PQ: 0 ANSI: 5
[    2.576185] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.576311] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.577256] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    2.577595] sr 2:0:0:0: Attached scsi generic sg2 type 5
[    2.585615]  sdb: sdb1
[    2.586913] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.589417]  sda: sda1 sda2
[    2.590698] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.595043] Freeing unused kernel memory: 3692K (ffffffff81d90000 - ffffffff8212b000)
[    2.595170] Write protecting the kernel read-only data: 12288k
[    2.596519] Freeing unused kernel memory: 188K (ffff8800017d1000 - ffff880001800000)
[    2.599430] Freeing unused kernel memory: 840K (ffff880001b2e000 - ffff880001c00000)
[    2.608226] random: systemd urandom read with 33 bits of entropy available
[    2.612645] systemd[1]: systemd 212 running in system mode. (+PAM +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ +SECCOMP -APPARMOR)
[    2.613774] systemd[1]: Detected architecture 'x86-64'.
[    2.613865] systemd[1]: Running in initial RAM disk.
[    2.615260] systemd[1]: Set hostname to <flatline.rdu.redhat.com>.
[    2.628670] systemd-fstab-g (114) used greatest stack depth: 5032 bytes left
[    2.695759] systemd[1]: Expecting device dev-mapper-fedora_flatline\x2droot.device...
[    2.696441] systemd[1]: Starting Timers.
[    2.697084] systemd[1]: Reached target Timers.
[    2.697183] systemd[1]: Starting -.slice.
[    2.749719] systemd[1]: Created slice -.slice.
[    2.749834] systemd[1]: Starting udev Control Socket.
[    2.750595] systemd[1]: Listening on udev Control Socket.
[    2.750707] systemd[1]: Starting udev Kernel Socket.
[    2.751678] systemd[1]: Listening on udev Kernel Socket.
[    2.751777] systemd[1]: Starting Journal Socket.
[    2.752667] systemd[1]: Listening on Journal Socket.
[    2.752766] systemd[1]: Starting Sockets.
[    2.753392] systemd[1]: Reached target Sockets.
[    2.753490] systemd[1]: Starting System Slice.
[    2.755657] systemd[1]: Created slice System Slice.
[    2.755757] systemd[1]: Starting system-systemd\x2dfsck.slice.
[    2.757383] systemd[1]: Created slice system-systemd\x2dfsck.slice.
[    2.757840] systemd[1]: Starting dracut cmdline hook...
[    2.760581] systemd[1]: Starting Apply Kernel Variables...
[    2.763238] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[    2.766252] systemd[1]: Starting Journal Service...
[    2.769491] systemd-sysctl (135) used greatest stack depth: 4968 bytes left
[    2.769748] systemd[1]: Started Journal Service.
[    3.109222] tsc: Refined TSC clocksource calibration: 2493.749 MHz
[    3.151468] systemd-udevd[280]: starting version 212
[    3.320081] usb 2-1: new low-speed USB device number 2 using uhci_hcd
[    3.321038] pps_core: LinuxPPS API ver. 1 registered
[    3.321145] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    3.329605] PTP clock support registered
[    3.361933] tg3.c:v3.136 (Jan 03, 2014)
[    3.377410] ata_id (305) used greatest stack depth: 4792 bytes left
[    3.405878] [drm] Initialized drm 1.1.0 20060810
[    3.432137] ata_id (315) used greatest stack depth: 3576 bytes left
[    3.458209] wmi: Mapper loaded
[    3.464766] tg3 0000:08:00.0 eth0: Tigon3 [partno(BCM95754) rev b002] (PCI Express) MAC address 00:21:9b:38:5c:f7
[    3.464901] tg3 0000:08:00.0 eth0: attached PHY is 5787 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[    3.465159] tg3 0000:08:00.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    3.465281] tg3 0000:08:00.0 eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    3.482192] usb 2-1: New USB device found, idVendor=05a4, idProduct=9841
[    3.482289] usb 2-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    3.482375] usb 2-1: Product: USB Compliant Keyboard
[    3.504029] input: USB Compliant Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.0/0003:05A4:9841.0001/input/input5
[    3.505636] hid-generic 0003:05A4:9841.0001: input,hidraw0: USB HID v1.10 Keyboard [USB Compliant Keyboard] on usb-0000:00:1d.0-1/input0
[    3.523987] input: USB Compliant Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.1/0003:05A4:9841.0002/input/input6
[    3.524988] hid-generic 0003:05A4:9841.0002: input,hidraw1: USB HID v1.10 Device [USB Compliant Keyboard] on usb-0000:00:1d.0-1/input1
[    3.609589] random: nonblocking pool is initialized
[    3.732107] usb 2-2: new full-speed USB device number 3 using uhci_hcd
[    3.906198] usb 2-2: New USB device found, idVendor=046d, idProduct=c52b
[    3.906296] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.906390] usb 2-2: Product: USB Receiver
[    3.906473] usb 2-2: Manufacturer: Logitech
[    3.940246] logitech-djreceiver 0003:046D:C52B.0005: hiddev0,hidraw2: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1d.0-2/input2
[    3.995046] input: Logitech Unifying Device. Wireless PID:1025 as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.2/0003:046D:C52B.0005/0003:046D:C52B.0006/input/input7
[    3.996486] logitech-djdevice 0003:046D:C52B.0006: input,hidraw3: USB HID v1.11 Mouse [Logitech Unifying Device. Wireless PID:1025] on usb-0000:00:1d.0-2:1
[    4.156328] usb 3-2: new low-speed USB device number 2 using uhci_hcd
[    4.156454] Switched to clocksource tsc
[    4.190152] [drm] hdmi device  not found 2 0 1
[    4.190482] nouveau  [  DEVICE][0000:02:00.0] BOOT0  : 0x084e00a2
[    4.190568] nouveau  [  DEVICE][0000:02:00.0] Chipset: G84 (NV84)
[    4.190653] nouveau  [  DEVICE][0000:02:00.0] Family : NV50
[    4.196325] nouveau  [   VBIOS][0000:02:00.0] checking PRAMIN for image...
[    4.200393] systemd-udevd[285]: renamed network interface eth0 to em1
[    4.245610] nouveau  [   VBIOS][0000:02:00.0] ... appears to be valid
[    4.245774] nouveau  [   VBIOS][0000:02:00.0] using image from PRAMIN
[    4.245958] nouveau  [   VBIOS][0000:02:00.0] BIT signature found
[    4.246068] nouveau  [   VBIOS][0000:02:00.0] version 60.84.63.00.11
[    4.270883] nouveau 0000:02:00.0: irq 89 for MSI/MSI-X
[    4.270907] nouveau  [     PMC][0000:02:00.0] MSI interrupts enabled
[    4.271152] nouveau  [     PFB][0000:02:00.0] RAM type: DDR2
[    4.271247] nouveau  [     PFB][0000:02:00.0] RAM size: 256 MiB
[    4.271341] nouveau  [     PFB][0000:02:00.0]    ZCOMP: 1892 tags
[    4.284785] nouveau  [    VOLT][0000:02:00.0] GPU voltage: 1200000uv
[    4.314602] nouveau  [  PTHERM][0000:02:00.0] FAN control: PWM
[    4.314708] nouveau  [  PTHERM][0000:02:00.0] fan management: automatic
[    4.314839] nouveau  [  PTHERM][0000:02:00.0] internal sensor: yes
[    4.314973] nouveau  [     CLK][0000:02:00.0] 20: core 208 MHz shader 416 MHz memory 100 MHz
[    4.315130] nouveau  [     CLK][0000:02:00.0] 21: core 460 MHz shader 920 MHz memory 400 MHz
[    4.315303] nouveau  [     CLK][0000:02:00.0] --: core 459 MHz shader 918 MHz memory 399 MHz
[    4.316368] [TTM] Zone  kernel: Available graphics memory: 8718216 kiB
[    4.316464] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    4.316559] [TTM] Initializing pool allocator
[    4.316686] [TTM] Initializing DMA pool allocator
[    4.316919] nouveau  [     DRM] VRAM: 256 MiB
[    4.317035] nouveau  [     DRM] GART: 1048576 MiB
[    4.317142] nouveau  [     DRM] TMDS table version 2.0
[    4.317237] nouveau  [     DRM] DCB version 4.0
[    4.317332] nouveau  [     DRM] DCB outp 00: 02000300 00000028
[    4.317427] nouveau  [     DRM] DCB outp 01: 01000302 00000030
[    4.317521] nouveau  [     DRM] DCB outp 02: 04011310 00000028
[    4.317615] nouveau  [     DRM] DCB outp 03: 02011312 00000030
[    4.317710] nouveau  [     DRM] DCB conn 00: 1030
[    4.317850] nouveau  [     DRM] DCB conn 01: 2130
[    4.338380] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    4.339337] [drm] Driver supports precise vblank timestamp query.
[    4.388034] usb 3-2: New USB device found, idVendor=051d, idProduct=0002
[    4.388142] usb 3-2: New USB device strings: Mfr=3, Product=1, SerialNumber=2
[    4.388247] usb 3-2: Product: Back-UPS ES 750 FW:841.I3 .D USB FW:I3 
[    4.388342] usb 3-2: Manufacturer: American Power Conversion
[    4.388436] usb 3-2: SerialNumber: 5B1134T26933  
[    4.611221] nouveau  [     DRM] MM: using CRYPT for buffer copies
[    4.677743] nouveau  [     DRM] allocated 1920x1080 fb: 0x60000, bo ffff880034faf800
[    4.678748] fbcon: nouveaufb (fb0) is primary device
[    4.773956] Console: switching to colour frame buffer device 240x67
[    4.776230] nouveau 0000:02:00.0: fb0: nouveaufb frame buffer device
[    4.776239] nouveau 0000:02:00.0: registered panic notifier
[    4.776275] [drm] Initialized nouveau 1.1.1 20120801 for 0000:02:00.0 on minor 0
[    5.614526] hid-generic 0003:051D:0002.0007: hiddev0,hidraw4: USB HID v1.10 Device [American Power Conversion Back-UPS ES 750 FW:841.I3 .D USB FW:I3 ] on usb-0000:00:1d.1-2/input0
[    5.808959] bio: create slab <bio-1> at 1
[    6.426211] PM: Starting manual resume from disk
[    6.426247] PM: Hibernation image partition 253:1 present
[    6.426249] PM: Looking for hibernation image.
[    6.453303] PM: Image not found (code -22)
[    6.453307] PM: Hibernation image not present or could not be loaded.
[    6.513652] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[    7.059319] systemd-udevd (284) used greatest stack depth: 3512 bytes left
[    7.176063] systemd-journald[137]: Received SIGTERM from PID 1 (systemd).
[    8.062684] SELinux: 2048 avtab hash slots, 99810 rules.
[    8.099354] SELinux: 2048 avtab hash slots, 99810 rules.
[    8.167042] SELinux:  8 users, 101 roles, 4833 types, 280 bools, 1 sens, 1024 cats
[    8.167049] SELinux:  83 classes, 99810 rules
[    8.181243] SELinux:  Completing initialization.
[    8.181246] SELinux:  Setting up existing superblocks.
[    8.181415] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[    8.181539] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    8.181584] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    8.181867] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    8.181956] SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
[    8.183590] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[    8.198660] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    8.198724] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    8.198796] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[    8.198857] SELinux: initialized (dev aio, type aio), not configured for labeling
[    8.198905] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[    8.199051] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    8.199144] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[    8.199219] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[    8.199391] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    8.205998] SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
[    8.206040] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    8.206053] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    8.206246] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    8.206359] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    8.206480] SELinux: initialized (dev pstore, type pstore), uses genfs_contexts
[    8.206507] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    8.206558] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    8.206602] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    8.206688] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    8.206718] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    8.206741] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    8.206771] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    8.206870] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    8.206894] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    8.206971] SELinux: initialized (dev configfs, type configfs), uses genfs_contexts
[    8.207075] SELinux: initialized (dev dm-0, type ext4), uses xattr
[    8.237015] audit: type=1403 audit(1397496841.451:2): policy loaded auid=4294967295 ses=4294967295
[    8.272418] systemd[1]: Successfully loaded SELinux policy in 367.584ms.
[    8.497690] systemd[1]: Relabelled /dev and /run in 40.673ms.
[    8.996446] system-upgrade- (524) used greatest stack depth: 3144 bytes left
[   11.115594] audit: type=1400 audit(1397496844.330:3): avc:  denied  { write } for  pid=544 comm="systemd-sysctl" name="shmmax" dev="proc" ino=10307 scontext=system_u:system_r:systemd_sysctl_t:s0 tcontext=system_u:object_r:proc_t:s0 tclass=file
[   11.413791] systemd-udevd[546]: starting version 212
[   14.626768] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   14.629560] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[   15.315742] EXT4-fs (dm-0): re-mounted. Opts: (null)
[   16.111279] i5k_amb: probe of i5k_amb.0 failed with error -16
[   16.172685] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[   16.193602] microcode: CPU0 sig=0x10676, pf=0x40, revision=0x60b
[   16.577944] microcode: CPU0 sig=0x10676, pf=0x40, revision=0x60b
[   16.578939] microcode: CPU0 updated to revision 0x60f, date = 2010-09-29
[   16.587089] microcode: CPU1 sig=0x10676, pf=0x40, revision=0x60b
[   16.588996] microcode: CPU1 sig=0x10676, pf=0x40, revision=0x60b
[   16.589993] microcode: CPU1 updated to revision 0x60f, date = 2010-09-29
[   16.598003] microcode: CPU2 sig=0x10676, pf=0x40, revision=0x60b
[   16.599940] microcode: CPU2 sig=0x10676, pf=0x40, revision=0x60b
[   16.600936] microcode: CPU2 updated to revision 0x60f, date = 2010-09-29
[   16.608997] microcode: CPU3 sig=0x10676, pf=0x40, revision=0x60b
[   16.609654] microcode: CPU3 sig=0x10676, pf=0x40, revision=0x60b
[   16.610498] microcode: CPU3 updated to revision 0x60f, date = 2010-09-29
[   16.616148] microcode: CPU4 sig=0x10676, pf=0x40, revision=0x60b
[   16.618212] microcode: CPU4 sig=0x10676, pf=0x40, revision=0x60b
[   16.619209] microcode: CPU4 updated to revision 0x60f, date = 2010-09-29
[   16.627195] microcode: CPU5 sig=0x10676, pf=0x40, revision=0x60b
[   16.629127] microcode: CPU5 sig=0x10676, pf=0x40, revision=0x60b
[   16.630121] microcode: CPU5 updated to revision 0x60f, date = 2010-09-29
[   16.638002] microcode: CPU6 sig=0x10676, pf=0x40, revision=0x60b
[   16.639884] microcode: CPU6 sig=0x10676, pf=0x40, revision=0x60b
[   16.640881] microcode: CPU6 updated to revision 0x60f, date = 2010-09-29
[   16.648677] microcode: CPU7 sig=0x10676, pf=0x40, revision=0x60b
[   16.650449] microcode: CPU7 sig=0x10676, pf=0x40, revision=0x60b
[   16.651447] microcode: CPU7 updated to revision 0x60f, date = 2010-09-29
[   16.659855] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   16.802127] tpm_tis 00:08: 1.2 TPM (device-id 0xFE, rev-id 70)
[   17.017702] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   17.211092] ACPI Warning: SystemIO range 0x0000000000000828-0x000000000000082f conflicts with OpRegion 0x0000000000000828-0x000000000000082d (\GLBC) (20131218/utaddress-258)
[   17.211454] ACPI Warning: SystemIO range 0x0000000000000828-0x000000000000082f conflicts with OpRegion 0x000000000000082a-0x000000000000082a (\SACT) (20131218/utaddress-258)
[   17.211757] ACPI Warning: SystemIO range 0x0000000000000828-0x000000000000082f conflicts with OpRegion 0x0000000000000828-0x0000000000000828 (\SSTS) (20131218/utaddress-258)
[   17.212193] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   17.212771] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   17.331501] parport_pc 00:05: reported by Plug and Play ACPI
[   17.332056] parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
[   17.688786] EDAC MC: Ver: 3.0.0
[   17.871602] EDAC MC0: Giving out device to module i5400_edac.c controller I5400: DEV 0000:00:10.0 (POLLED)
[   17.872517] EDAC PCI0: Giving out device to module i5400_edac controller EDAC PCI controller: DEV 0000:00:10.0 (POLLED)
[   18.021255] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   18.021617] IP: [<ffffffffa02a46a0>] ichx_gpio_probe+0x2a0/0x41c [gpio_ich]
[   18.021918] PGD 0 
[   18.022011] Oops: 0000 [#1] SMP 
[   18.022011] Modules linked in: gpio_ich(+) snd_seq_device snd_pcm i5400_edac joydev edac_core parport_pc snd_timer lpc_ich shpchp parport tpm_tis snd soundcore microcode i2c_i801 serio_raw mfd_core i5k_amb tpm nouveau hid_logitech_dj video mxm_wmi wmi i2c_algo_bit drm_kms_helper ttm drm ata_generic tg3 pata_acpi ptp pps_core i2c_core
[   18.022011] CPU: 5 PID: 553 Comm: systemd-udevd Not tainted 3.14.0-rc1+ #9
[   18.022011] Hardware name: Dell Inc. Precision WorkStation T5400  /0RW203, BIOS A04 08/21/2008
[   18.022011] task: ffff880033e2cc50 ti: ffff88044ba26000 task.ti: ffff88044ba26000
[   18.022011] RIP: 0010:[<ffffffffa02a46a0>]  [<ffffffffa02a46a0>] ichx_gpio_probe+0x2a0/0x41c [gpio_ich]
[   18.022011] RSP: 0018:ffff88044ba27ba0  EFLAGS: 00010246
[   18.022011] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[   18.022011] RDX: 0000000000000000 RSI: 0000000000000100 RDI: ffffffff81c3e180
[   18.022011] RBP: ffff88044ba27bd0 R08: 0000000000000000 R09: ffff880034fb04b0
[   18.022011] R10: 0000000000000001 R11: ffff880033e2d7f0 R12: ffff880034fb0000
[   18.022011] R13: ffff88044c28dcc0 R14: 0000000000000003 R15: 0000000000000000
[   18.022011] FS:  00007fbc8df5f880(0000) GS:ffff88045e000000(0000) knlGS:0000000000000000
[   18.022011] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   18.022011] CR2: 0000000000000000 CR3: 000000044b95e000 CR4: 00000000000007e0
[   18.022011] Stack:
[   18.022011]  ffff880034fb04b0 ffff880034fb0010 ffffffffa02a6028 ffff880034fb0000
[   18.022011]  0000000000000000 0000000000000001 ffff88044ba27c00 ffffffff814f4a55
[   18.022011]  ffffffff814f21a2 ffff880034fb0010 0000000000000000 ffffffffa02a6028
[   18.022011] Call Trace:
[   18.022011]  [<ffffffff814f4a55>] platform_drv_probe+0x45/0xb0
[   18.022011]  [<ffffffff814f21a2>] ? driver_sysfs_add+0x82/0xb0
[   18.022011]  [<ffffffff814f2945>] driver_probe_device+0x125/0x3a0
[   18.022011]  [<ffffffff814f2c93>] __driver_attach+0x93/0xa0
[   18.022011]  [<ffffffff814f2c00>] ? __device_attach+0x40/0x40
[   18.022011]  [<ffffffff814f0683>] bus_for_each_dev+0x73/0xc0
[   18.022011]  [<ffffffff814f22ce>] driver_attach+0x1e/0x20
[   18.022011]  [<ffffffff814f1e78>] bus_add_driver+0x188/0x260
[   18.022011]  [<ffffffffa00d0000>] ? 0xffffffffa00cffff
[   18.022011]  [<ffffffff814f3334>] driver_register+0x64/0xf0
[   18.022011]  [<ffffffffa00d0000>] ? 0xffffffffa00cffff
[   18.022011]  [<ffffffff814f497a>] __platform_driver_register+0x4a/0x50
[   18.022011]  [<ffffffffa00d0017>] ichx_gpio_driver_init+0x17/0x1000 [gpio_ich]
[   18.022011]  [<ffffffff8100214a>] do_one_initcall+0xfa/0x1b0
[   18.022011]  [<ffffffff81063e93>] ? set_memory_nx+0x43/0x50
[   18.022011]  [<ffffffff81130e58>] load_module+0x1c28/0x26d0
[   18.022011]  [<ffffffff8112bff0>] ? store_uevent+0x70/0x70
[   18.022011]  [<ffffffff81236790>] ? kernel_read+0x50/0x80
[   18.022011]  [<ffffffff81131ad6>] SyS_finit_module+0xa6/0xd0
[   18.022011]  [<ffffffff817c9f69>] system_call_fastpath+0x16/0x1b
[   18.022011] Code: 00 00 40 61 2a a0 e9 f0 fd ff ff 48 8b 05 81 1f 00 00 45 31 c0 48 c7 c7 80 e1 c3 81 4c 89 4d d0 48 8b 48 08 48 8b 50 10 48 63 c3 <0f> b6 34 01 0f b6 14 1a 4c 89 c9 49 03 75 00 e8 8c a2 df e0 48 
[   18.022011] RIP  [<ffffffffa02a46a0>] ichx_gpio_probe+0x2a0/0x41c [gpio_ich]
[   18.022011]  RSP <ffff88044ba27ba0>
[   18.022011] CR2: 0000000000000000
[   18.047269] ---[ end trace 178b39b238232179 ]---
[   18.124962] ppdev: user-space parallel port driver
[   18.191685] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   18.569088] iTCO_vendor_support: vendor-support=0
[   18.581831] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[   20.255586] snd_hda_intel 0000:00:1b.0: irq 90 for MSI/MSI-X
[   20.719682] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
[   20.720182] SELinux: initialized (dev dm-2, type ext4), uses xattr
[   21.438605] ALSA sound/pci/hda/hda_auto_parser.c:393 autoconfig: line_outs=1 (0x12/0x0/0x0/0x0/0x0) type:line
[   21.439035] ALSA sound/pci/hda/hda_auto_parser.c:397    speaker_outs=1 (0x13/0x0/0x0/0x0/0x0)
[   21.439400] ALSA sound/pci/hda/hda_auto_parser.c:401    hp_outs=1 (0x11/0x0/0x0/0x0/0x0)
[   21.439771] ALSA sound/pci/hda/hda_auto_parser.c:402    mono: mono_out=0x0
[   21.440288] ALSA sound/pci/hda/hda_auto_parser.c:406    inputs:
[   21.440779] ALSA sound/pci/hda/hda_auto_parser.c:410      Mic=0x14
[   21.441278] ALSA sound/pci/hda/hda_auto_parser.c:410      Line=0x15
[   21.454833] input: HDA Intel Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
[   21.458205] input: HDA Intel Line Out as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   21.459133] input: HDA Intel Line as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   21.459939] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   21.473438] Adding 8790012k swap on /dev/mapper/fedora_flatline-swap.  Priority:-1 extents:1 across:8790012k FS
[   23.345092] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[   23.588616] SELinux: initialized (dev sda1, type ext4), uses xattr
[   23.608688] systemd-journald[529]: Received request to flush runtime journal from PID 1
[   23.616232] audit: type=1305 audit(1397496856.831:4): audit_pid=815 old=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:auditd_t:s0 res=1
[   26.830139] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   27.984843] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   30.165513] Ebtables v2.0 registered
[   31.197997] Bridge firewalling registered
[   45.442441] cfg80211: Calling CRDA to update world regulatory domain
[   45.702579] cfg80211: World regulatory domain updated:
[   45.702587] cfg80211:  DFS Master region: unset
[   45.702590] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   45.702593] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   45.702595] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   45.702598] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm)
[   45.702600] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A, 2000 mBm)
[   45.702602] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm)
[   45.702604] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm)
[   46.088103] tg3 0000:08:00.0: irq 91 for MSI/MSI-X
[   46.136283] IPv6: ADDRCONF(NETDEV_UP): em1: link is not ready
[   47.706289] tg3 0000:08:00.0 em1: Link is up at 100 Mbps, full duplex
[   47.706304] tg3 0000:08:00.0 em1: Flow control is off for TX and off for RX
[   47.706345] IPv6: ADDRCONF(NETDEV_CHANGE): em1: link becomes ready
[   48.037740] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[   48.037845] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[   48.074869] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[   48.077751] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[   48.178305] tun: Universal TUN/TAP device driver, 1.6
[   48.178313] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   48.227919] device virbr0-nic entered promiscuous mode
[   48.235264] virbr0: port 1(virbr0-nic) entered forwarding state
[   48.235284] virbr0: port 1(virbr0-nic) entered forwarding state
[   48.705225] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   48.707075] IPv6: ADDRCONF(NETDEV_CHANGE): virbr0: link becomes ready
[   50.205900] fuse init (API version 7.22)
[   50.216345] SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
[   50.226715] SELinux: initialized (dev fusectl, type fusectl), uses genfs_contexts
[   50.859530] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   53.003302] virbr0: port 1(virbr0-nic) entered disabled state
[   85.796251] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs

--=-ulZGu2Iq7uiVzD0xUh/i--

