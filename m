Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbaAXMMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 07:12:13 -0500
Received: from mga14.intel.com ([143.182.124.37]:3946 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbaAXMMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 07:12:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,712,1384329600"; 
   d="log'?scan'208";a="464094925"
Date: Fri, 24 Jan 2014 20:08:40 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [mac80211] BUG: unable to handle kernel paging request at 6b6b6b8f
Message-ID: <20140124120840.GA25638@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Johannes,

The BUG does not show up in linux-next 20140124, is it fixed now?

I got the below dmesg and the first bad commit is

commit c990d19e30cea9f3d39f02c807f09f0be2a5ed71
Author:     Johannes Berg <johannes.berg@intel.com>
AuthorDate: Wed Jan 22 10:36:59 2014 +0100
Commit:     Johannes Berg <johannes.berg@intel.com>
CommitDate: Wed Jan 22 11:00:56 2014 +0100

    mac80211: remove module handling from rate control ops
    
    There's not a single rate control algorithm actually in
    a separate module where the module refcount would be
    required. Similarly, there's no specific rate control
    module.
    
    Therefore, all the module handling code in rate control
    is really just dead code, so remove it.
    
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>

+------------------------------------------------------------------------------+--------------+--------------+
|                                                                              | 99b767b457fe | abcab52cfba5 |
+------------------------------------------------------------------------------+--------------+--------------+
| boot_successes                                                               | 0            | 0            |
| boot_failures                                                                | 80           | 19           |
| WARNING:CPU:PID:at_drivers/media/v4l2-core/videobuf2-core.c:vb2_queue_init() | 80           |              |
| BUG:unable_to_handle_kernel_paging_request_at                                | 0            | 19           |
| Oops                                                                         | 0            | 19           |
| EIP_is_at_kobject_get                                                        | 0            | 19           |
| Kernel_panic-not_syncing:Fatal_exception                                     | 0            | 19           |
+------------------------------------------------------------------------------+--------------+--------------+

[623936.597242] ieee80211 phy0: Failed to select rate control algorithm
[623936.598414] ieee80211 phy0: Failed to initialize rate control algorithm
[623936.599745] mac80211_hwsim: ieee80211_register_hw failed (-2)
[623936.600901] BUG: unable to handle kernel paging request at 6b6b6b8f
[623936.602208] IP: [<c14638e1>] kobject_get+0x3d/0xc1
[623936.603293] *pde = 00000000 
[623936.604115] Oops: 0002 [#1] 
[623936.604939] CPU: 0 PID: 1 Comm: swapper Not tainted 3.13.0-04758-gabcab52 #159
[623936.606557] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[623936.607648] task: ce060000 ti: ce064000 task.ti: ce064000
[623936.608700] EIP: 0060:[<c14638e1>] EFLAGS: 00010246 CPU: 0
[623936.609769] EIP is at kobject_get+0x3d/0xc1
[623936.610680] EAX: 00000001 EBX: 6b6b6b73 ECX: 00000000 EDX: c0122360
[623936.611825] ESI: c2ce5450 EDI: ce065f04 EBP: ce065ec4 ESP: ce065ec0
[623936.612987]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[623936.614033] CR0: 8005003b CR2: 6b6b6b8f CR3: 02fa2000 CR4: 00000690
[623936.615191] Stack:
[623936.615837]  6b6b6b6b ce065ecc c1769a1b ce065ee0 c176facd c2ce5450 fffffffe ce065f04
[623936.618016]  ce065ef0 c176e06d c2ce5450 ce065f04 ce065f08 c17707f4 c1770766 00000000
[623936.620196]  c17707f4 00000000 ce065f10 c1772b2d ce065f24 c2f1562a c2f14f8a 00000000
[623936.622388] Call Trace:
[623936.623132]  [<c1769a1b>] get_device+0x2b/0x41
[623936.624039]  [<c176facd>] driver_detach+0x69/0x14e
[623936.625044]  [<c176e06d>] bus_remove_driver+0x12d/0x172
[623936.626090]  [<c17707f4>] driver_unregister+0x7e/0x91
[623936.627082]  [<c1770766>] ? driver_remove_groups+0x19/0x29
[623936.628160]  [<c17707f4>] ? driver_unregister+0x7e/0x91
[623936.629157]  [<c1772b2d>] platform_driver_unregister+0x19/0x29
[623936.630265]  [<c2f1562a>] init_mac80211_hwsim+0x6a0/0x6b8
[623936.631332]  [<c2f14f8a>] ? p54p_driver_init+0x32/0x32
[623936.632330]  [<c2eb456e>] do_one_initcall+0x131/0x24d
[623936.633350]  [<c2eb36a1>] ? repair_env_string+0x32/0xd3
[623936.634411]  [<c2eb366f>] ? do_early_param+0x128/0x128
[623936.635436]  [<c10ca94a>] ? parse_args+0x41a/0x5cf
[623936.636419]  [<c2eb366f>] ? do_early_param+0x128/0x128
[623936.637436]  [<c2eb4905>] kernel_init_freeable+0x27b/0x3e9
[623936.638466]  [<c2eb4905>] ? kernel_init_freeable+0x27b/0x3e9
[623936.639854]  [<c25906c2>] kernel_init+0x16/0x1fa
[623936.641025]  [<c25c725b>] ret_from_kernel_thread+0x1b/0x30
[623936.642112]  [<c25906ac>] ? rest_init+0xf1/0xf1
[623936.643111] Code: c0 53 89 c3 0f 84 a0 00 00 00 83 05 c8 d4 19 c3 01 83 15 cc d4 19 c3 00 b8 01 00 00 00 83 05 18 c8 19 c3 01 83 15 1c c8 19 c3 00 <0f> c1 43 1c 83 05 20 c8 19 c3 01 83 15 24 c8 19 c3 00 40 48 7f
[623936.650430] EIP: [<c14638e1>] kobject_get+0x3d/0xc1 SS:ESP 0068:ce065ec0
[623936.651747] CR2: 000000006b6b6b8f
[623936.652564] ---[ end trace 788ca11104c0a921 ]---
[623936.653543] Kernel panic - not syncing: Fatal exception

git bisect start abcab52cfba54e0e3b19d88eab7e9d340593b987 d8ec26d7f8287f5788a494f56e8814210f0e64be --
git bisect good e1ebe59b6ae7248f7debe42da4cf14c3a4e076a5  # 16:49     20+     20  Merge 'drm-intel/drm-intel-fixes' into devel-roam-i386-201401221837
git bisect good 32c0862ea6457f27d049ff8fbe83aeb314358111  # 16:54     20+     20  Merge 'f2fs/dev' into devel-roam-i386-201401221837
git bisect good 11efa21121b0048691b0c9f210ffeb46e37e88b9  # 17:03     20+     20  Merge 'f2fs/linux-3.10' into devel-roam-i386-201401221837
git bisect  bad 78390893c0628d4e83fb2630bde99c8fd6b0f0d0  # 17:05      0-      2  Merge 'mac80211-next/wip' into devel-roam-i386-201401221837
git bisect good 99b767b457fee362b257229a356a72ae60fea97a  # 17:14     20+     20  mac80211: minstrel_ht: sample_table can be __read_mostly
git bisect  bad 97b51a91bbcee1cf217c4af2140c8c9ab7761ddd  # 17:16      0-      2  mac80211_hwsim: report survey data for scanned channels
git bisect  bad d30ffb10dfa134ef1d1e017e96bc74fd909d0778  # 17:19      0-     18  mac80211_hwsim: make P2P-Device support optional
git bisect  bad c990d19e30cea9f3d39f02c807f09f0be2a5ed71  # 17:21      0-      5  mac80211: remove module handling from rate control ops
# first bad commit: [c990d19e30cea9f3d39f02c807f09f0be2a5ed71] mac80211: remove module handling from rate control ops
git bisect good 99b767b457fee362b257229a356a72ae60fea97a  # 17:48     60+     80  mac80211: minstrel_ht: sample_table can be __read_mostly
git bisect  bad abcab52cfba54e0e3b19d88eab7e9d340593b987  # 17:49      0-     19  0day head guard for 'devel-roam-i386-201401221837'
git bisect good 6358567276c459f3ea052fdeee6b297bc327ee83  # 18:25     60+     60  Revert "mac80211: remove module handling from rate control ops"
git bisect good 3aacd625f20129f5a41ea3ff3b5353b0e4dabd01  # 18:38     60+     60  Merge branch 'akpm' (incoming from Andrew)
git bisect good 0d92c4f9dbb6151bbba41c06f829d46b406fb8a2  # 18:49     60+     60  Add linux-next specific files for 20140124

Thanks,
Fengguang

--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-inn-9:20140122190445:i386-randconfig-r1-0122:3.13.0-04758-gabcab52:159"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.13.0-04758-gabcab52 (kbuild@roam) (gcc versi=
on 4.8.1 (Debian 4.8.1-8) ) #159 Wed Jan 22 19:02:44 CST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] initial memory mapped: [mem 0x00000000-0x03bfffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e000000-0x0e3fffff]
[    0.000000]  [mem 0x0e000000-0x0e3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0dffffff]
[    0.000000]  [mem 0x08000000-0x0dffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x07ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0fffdfff]
[    0.000000]  [mem 0x0e400000-0x0fbfffff] page 2M
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x0379e000, 0x0379efff] PGTABLE
[    0.000000] RAMDISK: [mem 0x0e7ab000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: FACP 0fffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXP=
C 00000001)
[    0.000000] ACPI: DSDT 0fffe490 0011A9 (v01   BXPC   BXDSDT 00000001 INT=
L 20100528)
[    0.000000] ACPI: FACS 0fffff40 000040
[    0.000000] ACPI: SSDT 0ffff7a0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: APIC 0ffff680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXP=
C 00000001)
[    0.000000] ACPI: HPET 0ffff640 000038 (v01 BOCHS  BXPCHPET 00000001 BXP=
C 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[623931.345674] BRK [0x0379f000, 0x0379ffff] PGTABLE
[623931.346030] Zone ranges:
[623931.346226]   DMA      [mem 0x00001000-0x00ffffff]
[623931.346594]   Normal   [mem 0x01000000-0x0fffdfff]
[623931.346960]   HighMem  empty
[623931.347179] Movable zone start for each node
[623931.347497] Early memory node ranges
[623931.347766]   node   0: [mem 0x00001000-0x0009efff]
[623931.348136]   node   0: [mem 0x00100000-0x0fffdfff]
[623931.348497] On node 0 totalpages: 65436
[623931.350280] free_area_init_node: node 0, pgdat c2e7ff5c, node_mem_map c=
e5ab020
[623931.350821]   DMA zone: 32 pages used for memmap
[623931.351176]   DMA zone: 0 pages reserved
[623931.351470]   DMA zone: 3998 pages, LIFO batch:0
[623931.351877]   Normal zone: 480 pages used for memmap
[623931.352260]   Normal zone: 61438 pages, LIFO batch:15
[623931.353414] Using APIC driver default
[623931.354010] ACPI: PM-Timer IO Port: 0xb008
[623931.354322] ACPI: Local APIC address 0xfee00000
[623931.354661] mapped APIC to         ffffb000 (        fee00000)
[623931.355105] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[623931.355541] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[623931.355979] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor =
1/0x1 ignored.
[623931.356574] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[623931.357009] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[623931.357502] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0=
-23
[623931.358020] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[623931.358494] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC=
 INT 02
[623931.359035] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[623931.359529] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC=
 INT 05
[623931.360068] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[623931.360557] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC=
 INT 09
[623931.361095] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high leve=
l)
[623931.361595] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC=
 INT 0a
[623931.362133] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high leve=
l)
[623931.362637] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC=
 INT 0b
[623931.363182] ACPI: IRQ0 used by override.
[623931.363479] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC=
 INT 01
[623931.364017] ACPI: IRQ2 used by override.
[623931.364310] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC=
 INT 03
[623931.364847] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC=
 INT 04
[623931.365377] ACPI: IRQ5 used by override.
[623931.365672] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC=
 INT 06
[623931.366213] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC=
 INT 07
[623931.366750] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC=
 INT 08
[623931.367291] ACPI: IRQ9 used by override.
[623931.367585] ACPI: IRQ10 used by override.
[623931.367885] ACPI: IRQ11 used by override.
[623931.368192] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC=
 INT 0c
[623931.368720] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC=
 INT 0d
[623931.369260] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC=
 INT 0e
[623931.369794] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC=
 INT 0f
[623931.370338] Using ACPI (MADT) for SMP configuration information
[623931.370782] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[623931.371184] mapped IOAPIC to ffffa000 (fec00000)
[623931.371529] nr_irqs_gsi: 40
[623931.371750] KVM setup async PF for cpu 0
[623931.372055] kvm-stealtime: cpu 0, msr 2ad3600
[623931.372399] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[623931.372905] Booting paravirtualized kernel on KVM
[623931.373321] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[623931.373738] pcpu-alloc: [0] 0=20
[623931.373988] Built 1 zonelists in Zone order, mobility grouping on.  Tot=
al pages: 64924
[623931.374593] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS=
0,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=
=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 r=
w link=3D/kernel-tests/run-queue/kvm/i386-randconfig-r1-0122/linux-devel:de=
vel-roam-i386-201401221837/.vmlinuz-abcab52cfba54e0e3b19d88eab7e9d340593b98=
7-20140122190414-2-inn branch=3Dlinux-devel/devel-roam-i386-201401221837 BO=
OT_IMAGE=3D/kernel/i386-randconfig-r1-0122/abcab52cfba54e0e3b19d88eab7e9d34=
0593b987/vmlinuz-3.13.0-04758-gabcab52
[623931.378920] PID hash table entries: 1024 (order: 0, 4096 bytes)
[623931.379476] Dentry cache hash table entries: 32768 (order: 5, 131072 by=
tes)
[623931.380136] Inode-cache hash table entries: 16384 (order: 4, 65536 byte=
s)
[623931.380700] Initializing CPU#0
[623931.380956] Initializing HighMem for node 0 (00000000:00000000)
[623931.381986] Memory: 193932K/261744K available (22303K kernel code, 4154=
K rwdata, 4916K rodata, 944K init, 8124K bss, 67812K reserved, 0K highmem)
[623931.382999] virtual kernel memory layout:
[623931.382999]     fixmap  : 0xfffa1000 - 0xfffff000   ( 376 kB)
[623931.382999]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[623931.382999]     vmalloc : 0xd07fe000 - 0xff7fe000   ( 752 MB)
[623931.382999]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[623931.382999]       .init : 0xc2eb3000 - 0xc2f9f000   ( 944 kB)
[623931.382999]       .data : 0xc25c82ad - 0xc2eb2920   (9129 kB)
[623931.382999]       .text : 0xc1000000 - 0xc25c82ad   (22304 kB)
[623931.386382] Checking if this processor honours the WP bit even in super=
visor mode...Ok.
[623931.387175] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D1,=
 Nodes=3D1
[623931.387713] NR_IRQS:2304 nr_irqs:256 16
[623931.388110] CPU 0 irqstacks, hard=3Dce00a000 soft=3Dce00c000
[623931.405045] Console: colour VGA+ 80x25
[623931.405340] console [tty0] enabled
[623931.405722] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.13.0-04758-gabcab52 (kbuild@roam) (gcc versi=
on 4.8.1 (Debian 4.8.1-8) ) #159 Wed Jan 22 19:02:44 CST 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] initial memory mapped: [mem 0x00000000-0x03bfffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e000000-0x0e3fffff]
[    0.000000]  [mem 0x0e000000-0x0e3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0dffffff]
[    0.000000]  [mem 0x08000000-0x0dffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x07ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0fffdfff]
[    0.000000]  [mem 0x0e400000-0x0fbfffff] page 2M
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x0379e000, 0x0379efff] PGTABLE
[    0.000000] RAMDISK: [mem 0x0e7ab000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: FACP 0fffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXP=
C 00000001)
[    0.000000] ACPI: DSDT 0fffe490 0011A9 (v01   BXPC   BXDSDT 00000001 INT=
L 20100528)
[    0.000000] ACPI: FACS 0fffff40 000040
[    0.000000] ACPI: SSDT 0ffff7a0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: APIC 0ffff680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXP=
C 00000001)
[    0.000000] ACPI: HPET 0ffff640 000038 (v01 BOCHS  BXPCHPET 00000001 BXP=
C 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[623931.345674] BRK [0x0379f000, 0x0379ffff] PGTABLE
[623931.346030] Zone ranges:
[623931.346226]   DMA      [mem 0x00001000-0x00ffffff]
[623931.346594]   Normal   [mem 0x01000000-0x0fffdfff]
[623931.346960]   HighMem  empty
[623931.347179] Movable zone start for each node
[623931.347497] Early memory node ranges
[623931.347766]   node   0: [mem 0x00001000-0x0009efff]
[623931.348136]   node   0: [mem 0x00100000-0x0fffdfff]
[623931.348497] On node 0 totalpages: 65436
[623931.350280] free_area_init_node: node 0, pgdat c2e7ff5c, node_mem_map c=
e5ab020
[623931.350821]   DMA zone: 32 pages used for memmap
[623931.351176]   DMA zone: 0 pages reserved
[623931.351470]   DMA zone: 3998 pages, LIFO batch:0
[623931.351877]   Normal zone: 480 pages used for memmap
[623931.352260]   Normal zone: 61438 pages, LIFO batch:15
[623931.353414] Using APIC driver default
[623931.354010] ACPI: PM-Timer IO Port: 0xb008
[623931.354322] ACPI: Local APIC address 0xfee00000
[623931.354661] mapped APIC to         ffffb000 (        fee00000)
[623931.355105] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[623931.355541] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[623931.355979] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor =
1/0x1 ignored.
[623931.356574] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[623931.357009] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[623931.357502] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0=
-23
[623931.358020] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[623931.358494] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC=
 INT 02
[623931.359035] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[623931.359529] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC=
 INT 05
[623931.360068] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[623931.360557] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC=
 INT 09
[623931.361095] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high leve=
l)
[623931.361595] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC=
 INT 0a
[623931.362133] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high leve=
l)
[623931.362637] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC=
 INT 0b
[623931.363182] ACPI: IRQ0 used by override.
[623931.363479] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC=
 INT 01
[623931.364017] ACPI: IRQ2 used by override.
[623931.364310] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC=
 INT 03
[623931.364847] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC=
 INT 04
[623931.365377] ACPI: IRQ5 used by override.
[623931.365672] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC=
 INT 06
[623931.366213] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC=
 INT 07
[623931.366750] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC=
 INT 08
[623931.367291] ACPI: IRQ9 used by override.
[623931.367585] ACPI: IRQ10 used by override.
[623931.367885] ACPI: IRQ11 used by override.
[623931.368192] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC=
 INT 0c
[623931.368720] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC=
 INT 0d
[623931.369260] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC=
 INT 0e
[623931.369794] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC=
 INT 0f
[623931.370338] Using ACPI (MADT) for SMP configuration information
[623931.370782] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[623931.371184] mapped IOAPIC to ffffa000 (fec00000)
[623931.371529] nr_irqs_gsi: 40
[623931.371750] KVM setup async PF for cpu 0
[623931.372055] kvm-stealtime: cpu 0, msr 2ad3600
[623931.372399] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[623931.372905] Booting paravirtualized kernel on KVM
[623931.373321] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[623931.373738] pcpu-alloc: [0] 0=20
[623931.373988] Built 1 zonelists in Zone order, mobility grouping on.  Tot=
al pages: 64924
[623931.374593] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS=
0,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=
=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 r=
w link=3D/kernel-tests/run-queue/kvm/i386-randconfig-r1-0122/linux-devel:de=
vel-roam-i386-201401221837/.vmlinuz-abcab52cfba54e0e3b19d88eab7e9d340593b98=
7-20140122190414-2-inn branch=3Dlinux-devel/devel-roam-i386-201401221837 BO=
OT_IMAGE=3D/kernel/i386-randconfig-r1-0122/abcab52cfba54e0e3b19d88eab7e9d34=
0593b987/vmlinuz-3.13.0-04758-gabcab52
[623931.378920] PID hash table entries: 1024 (order: 0, 4096 bytes)
[623931.379476] Dentry cache hash table entries: 32768 (order: 5, 131072 by=
tes)
[623931.380136] Inode-cache hash table entries: 16384 (order: 4, 65536 byte=
s)
[623931.380700] Initializing CPU#0
[623931.380956] Initializing HighMem for node 0 (00000000:00000000)
[623931.381986] Memory: 193932K/261744K available (22303K kernel code, 4154=
K rwdata, 4916K rodata, 944K init, 8124K bss, 67812K reserved, 0K highmem)
[623931.382999] virtual kernel memory layout:
[623931.382999]     fixmap  : 0xfffa1000 - 0xfffff000   ( 376 kB)
[623931.382999]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[623931.382999]     vmalloc : 0xd07fe000 - 0xff7fe000   ( 752 MB)
[623931.382999]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[623931.382999]       .init : 0xc2eb3000 - 0xc2f9f000   ( 944 kB)
[623931.382999]       .data : 0xc25c82ad - 0xc2eb2920   (9129 kB)
[623931.382999]       .text : 0xc1000000 - 0xc25c82ad   (22304 kB)
[623931.386382] Checking if this processor honours the WP bit even in super=
visor mode...Ok.
[623931.387175] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D1,=
 Nodes=3D1
[623931.387713] NR_IRQS:2304 nr_irqs:256 16
[623931.388110] CPU 0 irqstacks, hard=3Dce00a000 soft=3Dce00c000
[623931.405045] Console: colour VGA+ 80x25
[623931.405340] console [tty0] enabled
[623931.405722] bootconsole [earlyser0] disabled
[623931.474581] console [ttyS0] enabled
[623931.475239] hpet clockevent registered
[623931.475759] tsc: Detected 2693.542 MHz processor
[623931.476301] Calibrating delay loop (skipped) preset value.. 5387.08 Bog=
oMIPS (lpj=3D26935420)
[623931.477274] pid_max: default: 32768 minimum: 301
[623931.477921] Security Framework initialized
[623931.478419] AppArmor: AppArmor initialized
[623931.478932] Mount-cache hash table entries: 512
[623931.479914] Initializing cgroup subsys debug
[623931.480413] Initializing cgroup subsys perf_event
[623931.481324] Initializing cgroup subsys net_prio
[623931.482355] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[623931.482355] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[623931.482355] tlb_flushall_shift: 6
[623931.484942] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppi=
ng: 01)
[623931.490114] ACPI: Core revision 20131115
[623931.499898] ACPI: All ACPI Tables successfully acquired
[623931.501161] Performance Events: unsupported Netburst CPU model 6 no PMU=
 driver, software events only.
[623931.506475] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[623931.507428] Getting VERSION: 50014
[623931.508236] Getting VERSION: 50014
[623931.508994] Getting ID: 0
[623931.509725] Getting ID: f000000
[623931.510461] Getting LVT0: 8700
[623931.511181] Getting LVT1: 8400
[623931.511951] enabled ExtINT on CPU#0
[623931.513448] ENABLING IO-APIC IRQs
[623931.514252] init IO_APIC IRQs
[623931.515013]  apic 0 pin 0 not connected
[623931.515841] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 A=
ctive:0 Dest:1)
[623931.517463] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 A=
ctive:0 Dest:1)
[623931.519092] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 A=
ctive:0 Dest:1)
[623931.520673] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 A=
ctive:0 Dest:1)
[623931.522376] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 A=
ctive:0 Dest:1)
[623931.523973] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 A=
ctive:0 Dest:1)
[623931.525680] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 A=
ctive:0 Dest:1)
[623931.527286] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 A=
ctive:0 Dest:1)
[623931.528848] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 A=
ctive:0 Dest:1)
[623931.530481] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1=
 Active:0 Dest:1)
[623931.532090] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1=
 Active:0 Dest:1)
[623931.533709] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0=
 Active:0 Dest:1)
[623931.535363] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0=
 Active:0 Dest:1)
[623931.536990] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0=
 Active:0 Dest:1)
[623931.538649] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0=
 Active:0 Dest:1)
[623931.540256]  apic 0 pin 16 not connected
[623931.541071]  apic 0 pin 17 not connected
[623931.541877]  apic 0 pin 18 not connected
[623931.542686]  apic 0 pin 19 not connected
[623931.543510]  apic 0 pin 20 not connected
[623931.544326]  apic 0 pin 21 not connected
[623931.545141]  apic 0 pin 22 not connected
[623931.546018]  apic 0 pin 23 not connected
[623931.546968] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=
=3D-1
[623931.548080] Using local APIC timer interrupts.
[623931.548080] calibrating APIC timer ...
[623931.665278] ... lapic delta =3D 6249837
[623931.666126] ... PM-Timer delta =3D 357946
[623931.666992] ... PM-Timer result ok
[623931.667798] ..... delta 6249837
[623931.668585] ..... mult: 268428455
[623931.669391] ..... calibration result: 9999739
[623931.670305] ..... CPU clock speed is 2693.3862 MHz.
[623931.671277] ..... host bus clock speed is 999.9739 MHz.
[623931.672974] devtmpfs: initialized
[623931.674137] gcov: version magic: 0x3430382a
[623931.676933] pinctrl core: initialized pinctrl subsystem
[623931.678244] regulator-dummy: no parameters
[623931.679332] NET: Registered protocol family 16
[623931.681497] cpuidle: using governor ladder
[623931.682409] cpuidle: using governor menu
[623931.683959] ACPI: bus type PCI registered
[623931.684883] PCI: Using configuration type 1 for base access
[623931.713290] bio: create slab <bio-0> at 0
[623931.714726] ACPI: Added _OSI(Module Device)
[623931.715634] ACPI: Added _OSI(Processor Device)
[623931.716574] ACPI: Added _OSI(3.0 _SCP Extensions)
[623931.717530] ACPI: Added _OSI(Processor Aggregator Device)
[623931.731356] ACPI: Interpreter enabled
[623931.732229] ACPI: (supports S0 S5)
[623931.733079] ACPI: Using IOAPIC for interrupt routing
[623931.734140] PCI: Using host bridge windows from ACPI; if necessary, use=
 "pci=3Dnocrs" and report a bug
[623931.738097] ACPI: No dock devices found.
[623931.766357] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[623931.767510] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[623931.768632] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[623931.770934] acpi PNP0A03:00: fail to add MMCONFIG information, can't ac=
cess extended PCI configuration space under this bridge.
[623931.773166] PCI host bridge to bus 0000:00
[623931.774075] pci_bus 0000:00: root bus resource [bus 00-ff]
[623931.775127] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[623931.776253] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[623931.777386] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bff=
ff]
[623931.778589] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfff=
ff]
[623931.779826] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[623931.781611] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[623931.783539] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[623931.787361] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[623931.790025] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[623931.791372] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PII=
X4 ACPI
[623931.793032] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PII=
X4 SMB
[623931.795187] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[623931.799744] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[623931.802288] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[623931.809638] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[623931.811811] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[623931.814081] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[623931.816228] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[623931.822363] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[623931.824137] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[623931.826296] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[623931.828360] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[623931.835225] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[623931.837388] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[623931.839465] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[623931.846314] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[623931.848468] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[623931.850530] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[623931.857348] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[623931.859512] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[623931.861587] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[623931.868418] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[623931.870567] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[623931.872645] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[623931.879464] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[623931.881623] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[623931.883720] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[623931.890513] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[623931.892165] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[623931.897041] pci_bus 0000:00: on NUMA node 0
[623931.899874] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[623931.901806] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[623931.903728] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[623931.905625] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[623931.907218] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[623931.909983] ACPI: Enabled 16 GPEs in block 00 to 0F
[623931.911109] ACPI: \_SB_.PCI0: notify handler is installed
[623931.912385] Found 1 acpi root devices
[623931.915057] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,own=
s=3Dio+mem,locks=3Dnone
[623931.916812] vgaarb: loaded
[623931.917550] vgaarb: bridge control possible 0000:00:02.0
[623931.919760] ACPI: bus type USB registered
[623931.920769] usbcore: registered new interface driver usbfs
[623931.921884] usbcore: registered new interface driver hub
[623931.923032] usbcore: registered new device driver usb
[623931.924457] Linux video capture interface: v2.00
[623931.925464] pps_core: LinuxPPS API ver. 1 registered
[623931.926456] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo=
 Giometti <giometti@linux.it>
[623931.928309] PTP clock support registered
[623931.929499] wmi: Mapper loaded
[623931.930411] Advanced Linux Sound Architecture Driver Initialized.
[623931.931529] PCI: Using ACPI for IRQ routing
[623931.932453] PCI: pci_cache_line_size set to 64 bytes
[623931.933607] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[623931.935073] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[623931.937317] Bluetooth: Core ver 2.18
[623931.938223] NET: Registered protocol family 31
[623931.939154] Bluetooth: HCI device and connection manager initialized
[623931.940309] Bluetooth: HCI socket layer initialized
[623931.941316] Bluetooth: L2CAP socket layer initialized
[623931.942357] Bluetooth: SCO socket layer initialized
[623931.943356] NET: Registered protocol family 8
[623931.944351] NET: Registered protocol family 20
[623931.946589] HPET: 3 timers in total, 0 timers will be used for per-cpu =
timer
[623931.947833] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[623931.949055] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[623931.952204] cfg80211: Calling CRDA to update world regulatory domain
[623931.953435] Switched to clocksource kvm-clock
[623931.960742] FS-Cache: Loaded
[623931.961653] AppArmor: AppArmor Filesystem Enabled
[623931.962753] pnp: PnP ACPI init
[623931.963581] ACPI: bus type PNP registered
[623931.964644] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 A=
ctive:0 Dest:1)
[623931.966452] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[623931.967767] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 A=
ctive:0 Dest:1)
[623931.969597] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[623931.970846] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0=
 Active:0 Dest:1)
[623931.972727] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[623931.974151] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 A=
ctive:0 Dest:1)
[623931.975926] pnp 00:03: [dma 2]
[623931.976866] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[623931.978290] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 A=
ctive:0 Dest:1)
[623931.980077] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[623931.981482] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 A=
ctive:0 Dest:1)
[623931.983298] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[623931.985431] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[623931.987306] pnp: PnP ACPI: found 7 devices
[623931.988244] ACPI: bus type PNP unregistered
[623932.029018] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[623932.030100] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[623932.031167] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[623932.032294] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[623932.033485] NET: Registered protocol family 1
[623932.034460] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[623932.035566] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[623932.036656] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[623932.037800] pci 0000:00:02.0: Boot video device
[623932.038806] PCI: CLS 0 bytes, default 64
[623932.039949] Unpacking initramfs...
[623932.865615] Freeing initrd memory: 24852K (ce7ab000 - cfff0000)
[623932.939599] DMA-API: preallocated 65536 debug entries
[623932.940626] DMA-API: debugging enabled by kernel config
[623932.942718] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[623932.943980] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.=
fsnet.co.uk>, Peter Oruba
[623932.946472] The force parameter has not been set to 1. The Iris powerof=
f handler will not be installed.
[623932.948403] NatSemi SCx200 Driver
[623932.949704] futex hash table entries: 256 (order: -1, 2048 bytes)
[623932.950872] audit: initializing netlink socket (disabled)
[623932.951995] type=3D2000 audit(1390388672.982:1): initialized
[623933.715653] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[623933.744900] NTFS driver 2.1.30 [Flags: R/O].
[623933.747043] fuse init (API version 7.22)
[623933.749377] JFS: nTxBlock =3D 1709, nTxLock =3D 13674
[623933.751953] NILFS version 2 loaded
[623933.754747] GFS2 installed
[623933.760211] alg: No test for crc32 (crc32-table)
[623933.761381] alg: No test for lz4 (lz4-generic)
[623933.762365] alg: No test for lz4hc (lz4hc-generic)
[623933.763396] alg: No test for stdrng (krng)
[623933.768588] NET: Registered protocol family 38
[623933.769551] Key type asymmetric registered
[623933.770441] Asymmetric key parser 'x509' registered
[623933.771432] io scheduler noop registered (default)
[623933.772910] io scheduler cfq registered
[623933.773917] xz_dec_test: module loaded
[623933.774769] xz_dec_test: Create a device node with 'mknod xz_dec_test c=
 252 0' and write .xz files to it.
[623933.778062] rivafb_setup START
[623933.778905] nvidiafb_setup START
[623933.779808] VIA Graphics Integration Chipset framebuffer 2.4 initializi=
ng
[623933.781240] vmlfb: initializing
[623933.782140] no IO addresses supplied
[623933.783329] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM=
 (4096 kB) at 0xfc000000
[623933.785155] CL Picasso4: enable CONFIG_FB_LITTLE_ENDIAN to support this=
 framebuffer
[623933.786810] cirrusfb 0000:00:02.0: could not register fb device; err =
=3D -38!
[623933.788056] cirrusfb: probe of 0000:00:02.0 failed with error -38
[623933.789391] usbcore: registered new interface driver udlfb
[623933.790486] usbcore: registered new interface driver smscufx
[623933.791945] uvesafb: failed to execute /sbin/v86d
[623933.792918] uvesafb: make sure that the v86d helper is installed and ex=
ecutable
[623933.794546] uvesafb: Getting VBE info block failed (eax=3D0x4f00, err=
=3D-2)
[623933.795726] uvesafb: vbe_init() failed with -22
[623933.796679] uvesafb: probe of uvesafb.0 failed with error -22
[623933.800443] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[623933.801547] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1=
 Active:0 Dest:1)
[623933.806477] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[623933.807577] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1=
 Active:0 Dest:1)
[623933.812600] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[623933.817327] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[623933.828409] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[623933.851247] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200)=
 is a 16550A
[623933.854130] serial: Freescale lpuart driver
[623933.855149] Cyclades driver 2.6
[623933.856108] MOXA Intellio family driver version 6.0k
[623933.857209] RocketPort device driver module, version 2.09, 12-June-2003
[623933.858450] No rocketport ports found; unloading driver
[623933.859551] SyncLink GT
[623933.860276] SyncLink GT, tty major#247
[623933.861204] SyncLink GT no devices found
[623933.862119] SyncLink serial driver $Revision: 4.38 $
[623933.870138] SyncLink serial driver $Revision: 4.38 $, tty major#246
[623933.871346] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2=
 Exp $
[623933.872975] ac.o: No PCI boards found.
[623933.873841] ac.o: For an ISA board you must supply memory and irq param=
eters.
[623933.875720] Non-volatile memory driver v1.3
[623933.876641] scx200_gpio: no SCx200 gpio present
[623933.877609] nsc_gpio initializing
[623933.878447] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[623933.879511] smapi::smapi_init, ERROR invalid usSmapiID
[623933.880560] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI i=
s not available on this machine
[623933.882420] mwave: mwavedd::mwave_init: Error: Failed to initialize boa=
rd data
[623933.884049] mwave: mwavedd::mwave_init: Error: Failed to initialize
[623933.885187] Linux agpgart interface v0.103
[623933.886441] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seco=
nds, margin is 60 seconds).
[623933.888240] Hangcheck: Using getrawmonotonic().
[623933.889477] [drm] Initialized drm 1.1.0 20060810
[623933.890904] dummy-irq: no IRQ given.  Use irq=3DN
[623933.891927] Phantom Linux Driver, version n0.9.8, init OK
[623933.893346] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo G=
iometti
[623933.895194] c2port c2port0: C2 port uc added
[623933.896129] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 b=
ytes total)
[623933.897933] Guest personality initialized and is inactive
[623933.899070] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D62)
[623933.900255] Initialized host personality
[623933.901777] usbcore: registered new interface driver viperboard
[623933.902921] Uniform Multi-Platform E-IDE driver
[623933.903996] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[623933.905239] piix 0000:00:01.1: not 100% native mode: will probe irqs la=
ter
[623933.908047]     ide0: BM-DMA at 0xc1c0-0xc1c7
[623933.908996]     ide1: BM-DMA at 0xc1c8-0xc1cf
[623933.909917] Probing IDE interface ide0...
[623933.933477] tsc: Refined TSC clocksource calibration: 2693.449 MHz
[623934.513546] Probing IDE interface ide1...
[623935.303515] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
[623936.023609] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[623936.024893] hdc: MWDMA2 mode selected
[623936.025887] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[623936.027001] ide1 at 0x170-0x177,0x376 on irq 15
[623936.029370] ide_generic: please use "probe_mask=3D0x3f" module paramete=
r for probing all legacy ISA IDE ports
[623936.031319] ide-cd driver 5.00
[623936.032423] ide-cd: hdc: ATAPI 4X DVD-ROM drive, 512kB Cache
[623936.033803] cdrom: Uniform CD-ROM driver Revision: 3.20
[623936.036417] SSFDC read-only Flash Translation layer
[623936.037473] L440GX flash mapping: failed to find PIIX4 ISA bridge, cann=
ot continue
[623936.039110] device id =3D 2440
[623936.039868] device id =3D 2480
[623936.040597] device id =3D 24c0
[623936.041378] device id =3D 24d0
[623936.042164] device id =3D 25a1
[623936.042959] device id =3D 2670
[623936.043817] platform physmap-flash.0: failed to claim resource 0
[623936.045004] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
[623936.046320] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel=
 Networks.
[623936.048009] pmc551: not detected
[623936.050937] HSI/SSI char device loaded
[623936.052140] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S=
=2E Miller (davem@redhat.com)
[623936.055313] libphy: Fixed MDIO Bus: probed
[623936.056381] vcan: Virtual CAN interface driver
[623936.057323] CAN device driver interface
[623936.058229] usbcore: registered new interface driver ems_usb
[623936.059344] usbcore: registered new interface driver kvaser_usb
[623936.060494] usbcore: registered new interface driver peak_usb
[623936.061612] cc770: CAN netdevice driver
[623936.068735] cc770_isa: insufficient parameters supplied
[623936.070076] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken=
=2Ede
[623936.071409] Atheros(R) L2 Ethernet Driver - version 2.2.3
[623936.072468] Copyright (c) 2007 Atheros Corporation.
[623936.074114] vxge: Copyright(c) 2002-2010 Exar Corp.
[623936.075102] vxge: Driver version: 2.5.3.22640-k
[623936.076105] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8=
-NAPI
[623936.077388] e1000: Copyright (c) 1999-2006 Intel Corporation.
[623936.415403] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:=
56
[623936.416634] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connecti=
on
[623936.417889] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[623936.418978] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[623936.420140] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0=
=2E5-k
[623936.421347] igb: Copyright (c) 2007-2013 Intel Corporation.
[623936.422512] igbvf: Intel(R) Gigabit Virtual Function Network Driver - v=
ersion 2.0.2-k
[623936.424236] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[623936.425384] ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function N=
etwork Driver - version 2.11.3-k
[623936.427231] ixgbevf: Copyright (c) 2009 - 2012 Intel Corporation.
[623936.428412] i40e: Intel(R) Ethernet Connection XL710 Network Driver - v=
ersion 0.3.11-k
[623936.430109] i40e: Copyright (c) 2013 Intel Corporation.
[623936.431199] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k=
2-NAPI
[623936.432809] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[623936.434004] jme: JMicron JMC2XX ethernet driver version 1.0.8
[623936.435350] QLogic 1/10 GbE Converged/Intelligent Ethernet Driver v5.3.=
52
[623936.436654] tehuti: Tehuti Networks(R) Network Driver, 7.29.3
[623936.437740] tehuti: Options: hw_csum=20
[623936.438653] mkiss: AX.25 Multikiss, Hans Albas PE1AYX
[623936.439688] AX.25: bpqether driver version 004
[623936.440638] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[623936.440638] baycom_ser_fdx: version 0.10
[623936.443765] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[623936.444854] hdlcdrv: version 0.8
[623936.445645] PPP generic driver version 2.4.2
[623936.446723] PPP BSD Compression module registered
[623936.447696] PPP Deflate Compression module registered
[623936.448721] PPP MPPE Compression module registered
[623936.449699] NET: Registered protocol family 24
[623936.450660] DLCI driver v0.35, 4 Jan 1997, mike.mclagan@linux.org.
[623936.451801] ipw2100: Intel(R) PRO/Wireless 2100 Network Driver, git-1.2=
=2E2
[623936.453004] ipw2100: Copyright(c) 2003-2006 Intel Corporation
[623936.454206] libipw: 802.11 data/management/control stack, git-1.1.13
[623936.455361] libipw: Copyright (C) 2004-2005 Intel Corporation <jketreno=
@linux.intel.com>
[623936.457125] Atmel at76x USB Wireless LAN Driver 0.17 loading
[623936.458264] usbcore: registered new interface driver at76c50x-usb
[623936.459400] Loaded prism54 driver, version 1.2
[623936.460531] Broadcom 43xx driver loaded [ Features: PLS ]
[623936.461609] Broadcom 43xx-legacy driver loaded [ Features: PLD ]
[623936.462725] zd1211rw usb_init()
[623936.463613] usbcore: registered new interface driver zd1211rw
[623936.464699] zd1211rw initialized
[623936.465597] usbcore: registered new interface driver rtl8187
[623936.466913] usbcore: registered new interface driver rndis_wlan
[623936.468148] usbcore: registered new interface driver zd1201
[623936.469309] usbcore: registered new interface driver lbtf_usb
[623936.470490] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connectio=
n driver for Linux, in-tree:ds
[623936.472348] iwl3945: Copyright(c) 2003-2011 Intel Corporation
[623936.473650] usbcore: registered new interface driver rt2500usb
[623936.474808] usbcore: registered new interface driver rt2800usb
[623936.476211] cfg80211: Updating information on frequency 2412 MHz with r=
egulatory rule:
[623936.477908] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi,=
 2000 mBm)
[623936.479540] cfg80211: Updating information on frequency 2417 MHz with r=
egulatory rule:
[623936.481221] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi,=
 2000 mBm)
[623936.482865] cfg80211: Updating information on frequency 2422 MHz with r=
egulatory rule:
[623936.484556] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi,=
 2000 mBm)
[623936.486189] cfg80211: Updating information on frequency 2427 MHz with r=
egulatory rule:
[623936.487910] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi,=
 2000 mBm)
[623936.489528] cfg80211: Updating information on frequency 2432 MHz with r=
egulatory rule:
[623936.491197] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi,=
 2000 mBm)
[623936.492836] cfg80211: Updating information on frequency 2437 MHz with r=
egulatory rule:
[623936.494544] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi,=
 2000 mBm)
[623936.496198] cfg80211: Updating information on frequency 2442 MHz with r=
egulatory rule:
[623936.497879] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi,=
 2000 mBm)
[623936.499500] cfg80211: Updating information on frequency 2447 MHz with r=
egulatory rule:
[623936.501196] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi,=
 2000 mBm)
[623936.502841] cfg80211: Updating information on frequency 2452 MHz with r=
egulatory rule:
[623936.504546] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi,=
 2000 mBm)
[623936.506200] cfg80211: Updating information on frequency 2457 MHz with r=
egulatory rule:
[623936.507865] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi,=
 2000 mBm)
[623936.509487] cfg80211: Updating information on frequency 2462 MHz with r=
egulatory rule:
[623936.511168] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi,=
 2000 mBm)
[623936.512799] cfg80211: Updating information on frequency 2467 MHz with r=
egulatory rule:
[623936.514511] cfg80211: 2457000 KHz - 2482000 KHz @ 40000 KHz), (600 mBi,=
 2000 mBm)
[623936.516229] cfg80211: Updating information on frequency 2472 MHz with r=
egulatory rule:
[623936.517929] cfg80211: 2457000 KHz - 2482000 KHz @ 40000 KHz), (600 mBi,=
 2000 mBm)
[623936.519598] cfg80211: Updating information on frequency 2484 MHz with r=
egulatory rule:
[623936.521271] cfg80211: 2474000 KHz - 2494000 KHz @ 20000 KHz), (600 mBi,=
 2000 mBm)
[623936.522912] cfg80211: Updating information on frequency 5180 MHz with r=
egulatory rule:
[623936.524573] cfg80211: 5170000 KHz - 5250000 KHz @ 160000 KHz), (600 mBi=
, 2000 mBm)
[623936.526220] cfg80211: Updating information on frequency 5200 MHz with r=
egulatory rule:
[623936.527895] cfg80211: 5170000 KHz - 5250000 KHz @ 160000 KHz), (600 mBi=
, 2000 mBm)
[623936.529514] cfg80211: Updating information on frequency 5220 MHz with r=
egulatory rule:
[623936.531194] cfg80211: 5170000 KHz - 5250000 KHz @ 160000 KHz), (600 mBi=
, 2000 mBm)
[623936.532814] cfg80211: Updating information on frequency 5240 MHz with r=
egulatory rule:
[623936.534526] cfg80211: 5170000 KHz - 5250000 KHz @ 160000 KHz), (600 mBi=
, 2000 mBm)
[623936.536208] cfg80211: Updating information on frequency 5260 MHz with r=
egulatory rule:
[623936.537921] cfg80211: 5250000 KHz - 5330000 KHz @ 160000 KHz), (600 mBi=
, 2000 mBm)
[623936.539602] cfg80211: Updating information on frequency 5280 MHz with r=
egulatory rule:
[623936.541278] cfg80211: 5250000 KHz - 5330000 KHz @ 160000 KHz), (600 mBi=
, 2000 mBm)
[623936.542964] cfg80211: Updating information on frequency 5300 MHz with r=
egulatory rule:
[623936.544660] cfg80211: 5250000 KHz - 5330000 KHz @ 160000 KHz), (600 mBi=
, 2000 mBm)
[623936.546364] cfg80211: Updating information on frequency 5320 MHz with r=
egulatory rule:
[623936.548063] cfg80211: 5250000 KHz - 5330000 KHz @ 160000 KHz), (600 mBi=
, 2000 mBm)
[623936.549711] cfg80211: Updating information on frequency 5500 MHz with r=
egulatory rule:
[623936.551392] cfg80211: 5490000 KHz - 5730000 KHz @ 160000 KHz), (600 mBi=
, 2000 mBm)
[623936.553010] cfg80211: Updating information on frequency 5520 MHz with r=
egulatory rule:
[623936.554724] cfg80211: 5490000 KHz - 5730000 KHz @ 160000 KHz), (600 mBi=
, 2000 mBm)
[623936.556327] cfg80211: Updating information on frequency 5540 MHz with r=
egulatory rule:
[623936.558000] cfg80211: 5490000 KHz - 5730000 KHz @ 160000 KHz), (600 mBi=
, 2000 mBm)
[623936.559652] cfg80211: Updating information on frequency 5560 MHz with r=
egulatory rule:
[623936.561327] cfg80211: 5490000 KHz - 5730000 KHz @ 160000 KHz), (600 mBi=
, 2000 mBm)
[623936.563018] cfg80211: Updating information on frequency 5580 MHz with r=
egulatory rule:
[623936.564694] cfg80211: 5490000 KHz - 5730000 KHz @ 160000 KHz), (600 mBi=
, 2000 mBm)
[623936.566330] cfg80211: Updating information on frequency 5600 MHz with r=
egulatory rule:
[623936.568080] cfg80211: 5490000 KHz - 5730000 KHz @ 160000 KHz), (600 mBi=
, 2000 mBm)
[623936.569712] cfg80211: Updating information on frequency 5620 MHz with r=
egulatory rule:
[623936.571399] cfg80211: 5490000 KHz - 5730000 KHz @ 160000 KHz), (600 mBi=
, 2000 mBm)
[623936.579206] cfg80211: Updating information on frequency 5640 MHz with r=
egulatory rule:
[623936.580858] cfg80211: 5490000 KHz - 5730000 KHz @ 160000 KHz), (600 mBi=
, 2000 mBm)
[623936.582533] cfg80211: Updating information on frequency 5660 MHz with r=
egulatory rule:
[623936.584249] cfg80211: 5490000 KHz - 5730000 KHz @ 160000 KHz), (600 mBi=
, 2000 mBm)
[623936.585896] cfg80211: Updating information on frequency 5680 MHz with r=
egulatory rule:
[623936.587602] cfg80211: 5490000 KHz - 5730000 KHz @ 160000 KHz), (600 mBi=
, 2000 mBm)
[623936.589220] cfg80211: Updating information on frequency 5700 MHz with r=
egulatory rule:
[623936.590899] cfg80211: 5490000 KHz - 5730000 KHz @ 160000 KHz), (600 mBi=
, 2000 mBm)
[623936.592533] cfg80211: Disabling freq 5745 MHz
[623936.593465] cfg80211: Disabling freq 5765 MHz
[623936.594385] cfg80211: Disabling freq 5785 MHz
[623936.595311] cfg80211: Disabling freq 5805 MHz
[623936.596232] cfg80211: Disabling freq 5825 MHz
[623936.597242] ieee80211 phy0: Failed to select rate control algorithm
[623936.598414] ieee80211 phy0: Failed to initialize rate control algorithm
[623936.599745] mac80211_hwsim: ieee80211_register_hw failed (-2)
[623936.600901] BUG: unable to handle kernel paging request at 6b6b6b8f
[623936.602208] IP: [<c14638e1>] kobject_get+0x3d/0xc1
[623936.603293] *pde =3D 00000000=20
[623936.604115] Oops: 0002 [#1]=20
[623936.604939] CPU: 0 PID: 1 Comm: swapper Not tainted 3.13.0-04758-gabcab=
52 #159
[623936.606557] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[623936.607648] task: ce060000 ti: ce064000 task.ti: ce064000
[623936.608700] EIP: 0060:[<c14638e1>] EFLAGS: 00010246 CPU: 0
[623936.609769] EIP is at kobject_get+0x3d/0xc1
[623936.610680] EAX: 00000001 EBX: 6b6b6b73 ECX: 00000000 EDX: c0122360
[623936.611825] ESI: c2ce5450 EDI: ce065f04 EBP: ce065ec4 ESP: ce065ec0
[623936.612987]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[623936.614033] CR0: 8005003b CR2: 6b6b6b8f CR3: 02fa2000 CR4: 00000690
[623936.615191] Stack:
[623936.615837]  6b6b6b6b ce065ecc c1769a1b ce065ee0 c176facd c2ce5450 ffff=
fffe ce065f04
[623936.618016]  ce065ef0 c176e06d c2ce5450 ce065f04 ce065f08 c17707f4 c177=
0766 00000000
[623936.620196]  c17707f4 00000000 ce065f10 c1772b2d ce065f24 c2f1562a c2f1=
4f8a 00000000
[623936.622388] Call Trace:
[623936.623132]  [<c1769a1b>] get_device+0x2b/0x41
[623936.624039]  [<c176facd>] driver_detach+0x69/0x14e
[623936.625044]  [<c176e06d>] bus_remove_driver+0x12d/0x172
[623936.626090]  [<c17707f4>] driver_unregister+0x7e/0x91
[623936.627082]  [<c1770766>] ? driver_remove_groups+0x19/0x29
[623936.628160]  [<c17707f4>] ? driver_unregister+0x7e/0x91
[623936.629157]  [<c1772b2d>] platform_driver_unregister+0x19/0x29
[623936.630265]  [<c2f1562a>] init_mac80211_hwsim+0x6a0/0x6b8
[623936.631332]  [<c2f14f8a>] ? p54p_driver_init+0x32/0x32
[623936.632330]  [<c2eb456e>] do_one_initcall+0x131/0x24d
[623936.633350]  [<c2eb36a1>] ? repair_env_string+0x32/0xd3
[623936.634411]  [<c2eb366f>] ? do_early_param+0x128/0x128
[623936.635436]  [<c10ca94a>] ? parse_args+0x41a/0x5cf
[623936.636419]  [<c2eb366f>] ? do_early_param+0x128/0x128
[623936.637436]  [<c2eb4905>] kernel_init_freeable+0x27b/0x3e9
[623936.638466]  [<c2eb4905>] ? kernel_init_freeable+0x27b/0x3e9
[623936.639854]  [<c25906c2>] kernel_init+0x16/0x1fa
[623936.641025]  [<c25c725b>] ret_from_kernel_thread+0x1b/0x30
[623936.642112]  [<c25906ac>] ? rest_init+0xf1/0xf1
[623936.643111] Code: c0 53 89 c3 0f 84 a0 00 00 00 83 05 c8 d4 19 c3 01 83=
 15 cc d4 19 c3 00 b8 01 00 00 00 83 05 18 c8 19 c3 01 83 15 1c c8 19 c3 00=
 <0f> c1 43 1c 83 05 20 c8 19 c3 01 83 15 24 c8 19 c3 00 40 48 7f
[623936.650430] EIP: [<c14638e1>] kobject_get+0x3d/0xc1 SS:ESP 0068:ce065ec0
[623936.651747] CR2: 000000006b6b6b8f
[623936.652564] ---[ end trace 788ca11104c0a921 ]---
[623936.653543] Kernel panic - not syncing: Fatal exception
[623936.654566] Kernel Offset: 0x0 from 0xc1000000 (relocation range: 0xc00=
00000-0xd07fdfff)
[623936.656289] Rebooting in 10 seconds..
Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-r=
1-0122/abcab52cfba54e0e3b19d88eab7e9d340593b987/vmlinuz-3.13.0-04758-gabcab=
52 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=3Ddeb=
ug sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,1152=
00 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/ru=
n-queue/kvm/i386-randconfig-r1-0122/linux-devel:devel-roam-i386-20140122183=
7/.vmlinuz-abcab52cfba54e0e3b19d88eab7e9d340593b987-20140122190414-2-inn br=
anch=3Dlinux-devel/devel-roam-i386-201401221837 BOOT_IMAGE=3D/kernel/i386-r=
andconfig-r1-0122/abcab52cfba54e0e3b19d88eab7e9d340593b987/vmlinuz-3.13.0-0=
4758-gabcab52'  -initrd /kernel-tests/initrd/quantal-core-i386.cgz -m 256M =
-smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::10=
177-:22 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltim=
e -drive file=3D/fs/LABEL=3DKVM/disk0-quantal-inn-9,media=3Ddisk,if=3Dvirti=
o -drive file=3D/fs/LABEL=3DKVM/disk1-quantal-inn-9,media=3Ddisk,if=3Dvirti=
o -drive file=3D/fs/LABEL=3DKVM/disk2-quantal-inn-9,media=3Ddisk,if=3Dvirti=
o -drive file=3D/fs/LABEL=3DKVM/disk3-quantal-inn-9,media=3Ddisk,if=3Dvirti=
o -drive file=3D/fs/LABEL=3DKVM/disk4-quantal-inn-9,media=3Ddisk,if=3Dvirti=
o -drive file=3D/fs/LABEL=3DKVM/disk5-quantal-inn-9,media=3Ddisk,if=3Dvirti=
o -pidfile /dev/shm/kboot/pid-quantal-inn-9 -serial file:/dev/shm/kboot/ser=
ial-quantal-inn-9 -daemonize -display none -monitor null=20

--HcAYCG3uE/tztfnV
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-r1-0122-abcab52cfba54e0e3b19d88eab7e9d340593b987-BUG:-unable-to-handle-kernel-paging-request-at-70545.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IGQ4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yMS0w
MTIyL2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0MDEyMjE4Mzc6ZDhlYzI2ZDdm
ODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZTpiaXNlY3QtdXNiCgoyMDE0LTAxLTI0
LTE2OjIwOjIyIGQ4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUgcmV1
c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjEtMDEyMi9kOGVjMjZkN2Y4Mjg3ZjU3ODhh
NDk0ZjU2ZTg4MTQyMTBmMGU2NGJlL3ZtbGludXotMy4xMy4wCgoyMDE0LTAxLTI0LTE2OjIw
OjIyIGRldGVjdGluZyBib290IHN0YXRlIC4uLi4JMQk0CTUJMTUJMTYJMTkJMjAgU1VDQ0VT
UwoKYmlzZWN0OiBnb29kIGNvbW1pdCBkOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQy
MTBmMGU2NGJlCmdpdCBiaXNlY3Qgc3RhcnQgYWJjYWI1MmNmYmE1NGUwZTNiMTlkODhlYWI3
ZTlkMzQwNTkzYjk4NyBkOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJl
IC0tCi9jL2tlcm5lbC10ZXN0cy9saW5lYXItYmlzZWN0OiBbIi1iIiwgImFiY2FiNTJjZmJh
NTRlMGUzYjE5ZDg4ZWFiN2U5ZDM0MDU5M2I5ODciLCAiLWciLCAiZDhlYzI2ZDdmODI4N2Y1
Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZSIsICIvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIiwgIi9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdCJdCkJpc2Vj
dGluZzogNDc1OCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
MTMgc3RlcHMpCltlMWViZTU5YjZhZTcyNDhmN2RlYmU0MmRhNGNmMTRjM2E0ZTA3NmE1XSBN
ZXJnZSAnZHJtLWludGVsL2RybS1pbnRlbC1maXhlcycgaW50byBkZXZlbC1yb2FtLWkzODYt
MjAxNDAxMjIxODM3CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yMS0wMTIyL2xpbnV4LWRldmVsOmRl
dmVsLXJvYW0taTM4Ni0yMDE0MDEyMjE4Mzc6ZTFlYmU1OWI2YWU3MjQ4ZjdkZWJlNDJkYTRj
ZjE0YzNhNGUwNzZhNTpiaXNlY3QtdXNiCiAgL2Mva2VybmVsLXRlc3RzL2NvbW1vbi5zaDox
NjQ6IGR1bXBfc3RhY2sKICAvYy9rZXJuZWwtdGVzdHMvY29tbW9uLnNoOjE5MjogY2hlY2tf
Y21kX3Jlc3VsdAogIC9jL2tlcm5lbC10ZXN0cy9jb21tb24uc2g6MjUxOiBncmVwCiAgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaDo4NDogcmV1c2Vfb2xk
X2dvb2RfYmFkCiAgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aDo5MjogbWFpbgoKMjAxNC0wMS0yNC0xNjoyNTo1NSBlMWViZTU5YjZhZTcyNDhmN2RlYmU0
MmRhNGNmMTRjM2E0ZTA3NmE1IGNvbXBpbGluZwo2MjggcmVhbCAgMjI3NiB1c2VyICAxOTkg
c3lzICAzOTMuOTclIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXIxLTAxMjIKCjIwMTQtMDEtMjQt
MTY6Mzc6MTMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMy4wLTA0NTYxLWdlMWViZTU5Li4u
CTEJMi4uCTMuCTQuCTUJNgk3Li4uLgk5Li4JMTAJMTkuCTIwIFNVQ0NFU1MKCkJpc2VjdGlu
ZzogMTk3IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0
ZXBzKQpbMzJjMDg2MmVhNjQ1N2YyN2QwNDlmZjhmYmU4M2FlYjMxNDM1ODExMV0gTWVyZ2Ug
J2YyZnMvZGV2JyBpbnRvIGRldmVsLXJvYW0taTM4Ni0yMDE0MDEyMjE4MzcKcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91
c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1y
YW5kY29uZmlnLXIxLTAxMjIvbGludXgtZGV2ZWw6ZGV2ZWwtcm9hbS1pMzg2LTIwMTQwMTIy
MTgzNzozMmMwODYyZWE2NDU3ZjI3ZDA0OWZmOGZiZTgzYWViMzE0MzU4MTExOmJpc2VjdC11
c2IKICAvYy9rZXJuZWwtdGVzdHMvY29tbW9uLnNoOjE2NDogZHVtcF9zdGFjawogIC9jL2tl
cm5lbC10ZXN0cy9jb21tb24uc2g6MTkyOiBjaGVja19jbWRfcmVzdWx0CiAgL2Mva2VybmVs
LXRlc3RzL2NvbW1vbi5zaDoyNTE6IGdyZXAKICAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoOjg0OiByZXVzZV9vbGRfZ29vZF9iYWQKICAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoOjkyOiBtYWluCgoyMDE0LTAxLTI0
LTE2OjQ5OjQ2IDMyYzA4NjJlYTY0NTdmMjdkMDQ5ZmY4ZmJlODNhZWIzMTQzNTgxMTEgY29t
cGlsaW5nCjU2IHJlYWwgIDcwIHVzZXIgIDEwIHN5cyAgMTQ0LjQyJSBjcHUgCWkzODYtcmFu
ZGNvbmZpZy1yMS0wMTIyCgoyMDE0LTAxLTI0LTE2OjUwOjU1IGRldGVjdGluZyBib290IHN0
YXRlIDMuMTMuMC0wNDc0NC1nMzJjMDg2Mi4uLi4JMTIJMTYJMjAgU1VDQ0VTUwoKQmlzZWN0
aW5nOiAxNCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNCBz
dGVwcykKWzExZWZhMjExMjFiMDA0ODY5MWIwYzlmMjEwZmZlYjQ2ZTM3ZTg4YjldIE1lcmdl
ICdmMmZzL2xpbnV4LTMuMTAnIGludG8gZGV2ZWwtcm9hbS1pMzg2LTIwMTQwMTIyMTgzNwpy
dW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hv
bWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2
bS9pMzg2LXJhbmRjb25maWctcjEtMDEyMi9saW51eC1kZXZlbDpkZXZlbC1yb2FtLWkzODYt
MjAxNDAxMjIxODM3OjExZWZhMjExMjFiMDA0ODY5MWIwYzlmMjEwZmZlYjQ2ZTM3ZTg4Yjk6
YmlzZWN0LXVzYgogIC9jL2tlcm5lbC10ZXN0cy9jb21tb24uc2g6MTY0OiBkdW1wX3N0YWNr
CiAgL2Mva2VybmVsLXRlc3RzL2NvbW1vbi5zaDoxOTI6IGNoZWNrX2NtZF9yZXN1bHQKICAv
Yy9rZXJuZWwtdGVzdHMvY29tbW9uLnNoOjI1MTogZ3JlcAogIC9jL2tlcm5lbC10ZXN0cy9i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2g6ODQ6IHJldXNlX29sZF9nb29kX2JhZAogIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2g6OTI6IG1haW4KCjIw
MTQtMDEtMjQtMTY6NTQ6MjYgMTFlZmEyMTEyMWIwMDQ4NjkxYjBjOWYyMTBmZmViNDZlMzdl
ODhiOSBjb21waWxpbmcKNTYgcmVhbCAgNzggdXNlciAgOSBzeXMgIDE1Ni44NiUgY3B1IAlp
Mzg2LXJhbmRjb25maWctcjEtMDEyMgoKMjAxNC0wMS0yNC0xNjo1NTozNiBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAzLjEzLjAtMDQ3NDYtZzExZWZhMjEuLi4uLi4uCTExLgkxNi4uCTE5Lgky
MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDEyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIg
dGhpcyAocm91Z2hseSA0IHN0ZXBzKQpbNzgzOTA4OTNjMDYyOGQ0ZTgzZmIyNjMwYmRlOTlj
OGZkNmIwZjBkMF0gTWVyZ2UgJ21hYzgwMjExLW5leHQvd2lwJyBpbnRvIGRldmVsLXJvYW0t
aTM4Ni0yMDE0MDEyMjE4MzcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXIxLTAxMjIvbGludXgtZGV2
ZWw6ZGV2ZWwtcm9hbS1pMzg2LTIwMTQwMTIyMTgzNzo3ODM5MDg5M2MwNjI4ZDRlODNmYjI2
MzBiZGU5OWM4ZmQ2YjBmMGQwOmJpc2VjdC11c2IKICAvYy9rZXJuZWwtdGVzdHMvY29tbW9u
LnNoOjE2NDogZHVtcF9zdGFjawogIC9jL2tlcm5lbC10ZXN0cy9jb21tb24uc2g6MTkyOiBj
aGVja19jbWRfcmVzdWx0CiAgL2Mva2VybmVsLXRlc3RzL2NvbW1vbi5zaDoyNTE6IGdyZXAK
ICAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoOjg0OiByZXVz
ZV9vbGRfZ29vZF9iYWQKICAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoOjkyOiBtYWluCgoyMDE0LTAxLTI0LTE3OjAzOjA3IDc4MzkwODkzYzA2MjhkNGU4
M2ZiMjYzMGJkZTk5YzhmZDZiMGYwZDAgY29tcGlsaW5nCjYzIHJlYWwgIDM4MCB1c2VyICAz
MSBzeXMgIDY0NS4zOCUgY3B1IAlpMzg2LXJhbmRjb25maWctcjEtMDEyMgoKMjAxNC0wMS0y
NC0xNzowNDoyMiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEzLjAtMDQ3NTctZzc4MzkwODku
Li4gVEVTVCBGQUlMVVJFCls3MTM0NDYuMDcxNjkxXSBpZWVlODAyMTEgcGh5MDogRmFpbGVk
IHRvIHNlbGVjdCByYXRlIGNvbnRyb2wgYWxnb3JpdGhtCls3MTM0NDYuMDczMDMwXSBpZWVl
ODAyMTEgcGh5MDogRmFpbGVkIHRvIGluaXRpYWxpemUgcmF0ZSBjb250cm9sIGFsZ29yaXRo
bQpbNzEzNDQ2LjA3NDUyM10gbWFjODAyMTFfaHdzaW06IGllZWU4MDIxMV9yZWdpc3Rlcl9o
dyBmYWlsZWQgKC0yKQpbNzEzNDQ2LjA3NTg2N10gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtl
cm5lbCBwYWdpbmcgcmVxdWVzdCBhdCA2YjZiNmI4ZgpbNzEzNDQ2LjA3NzMwMF0gSVA6IFs8
YzE0NjNkMGY+XSBrb2JqZWN0X2dldCsweDNkLzB4YzEKWzcxMzQ0Ni4wNzg1NTddICpwZGUg
PSAwMDAwMDAwMCAKWzcxMzQ0Ni4wNzk1MjldIE9vcHM6IDAwMDIgWyMxXSAKWzcxMzQ0Ni4w
ODA1MDFdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjEzLjAt
MDQ3NTctZzc4MzkwODkgIzEyMwpbNzEzNDQ2LjA4MjM3NF0gSGFyZHdhcmUgbmFtZTogQm9j
aHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbNzEzNDQ2LjA4MzYyNl0gdGFzazog
Y2UwNjAwMDAgdGk6IGNlMDY0MDAwIHRhc2sudGk6IGNlMDY0MDAwCls3MTM0NDYuMDg0ODY3
XSBFSVA6IDAwNjA6WzxjMTQ2M2QwZj5dIEVGTEFHUzogMDAwMTAyNDYgQ1BVOiAwCls3MTM0
NDYuMDg2MDY0XSBFSVAgaXMgYXQga29iamVjdF9nZXQrMHgzZC8weGMxCls3MTM0NDYuMDg3
MTA3XSBFQVg6IDAwMDAwMDAxIEVCWDogNmI2YjZiNzMgRUNYOiAwMDAwMDAwMCBFRFg6IGMw
YTg5M2YwCls3MTM0NDYuMDg4Mzk4XSBFU0k6IGMyY2M3NDUwIEVESTogY2UwNjVmMDQgRUJQ
OiBjZTA2NWVjNCBFU1A6IGNlMDY1ZWMwCls3MTM0NDYuMDg5NzA0XSAgRFM6IDAwN2IgRVM6
IDAwN2IgRlM6IDAwMDAgR1M6IDAwZTAgU1M6IDAwNjgKWzcxMzQ0Ni4wOTA5MDJdIENSMDog
ODAwNTAwM2IgQ1IyOiA2YjZiNmI4ZiBDUjM6IDAyZjg0MDAwIENSNDogMDAwMDA2OTAKWzcx
MzQ0Ni4wOTIyMDldIFN0YWNrOgpbNzEzNDQ2LjA5Mjk3M10gIDZiNmI2YjZiIGNlMDY1ZWNj
IGMxNzZhMWQwIGNlMDY1ZWUwIGMxNzcwMjgyIGMyY2M3NDUwIGZmZmZmZmZlIGNlMDY1ZjA0
Cls3MTM0NDYuMDk1NDU0XSAgY2UwNjVlZjAgYzE3NmU4MjIgYzJjYzc0NTAgY2UwNjVmMDQg
Y2UwNjVmMDggYzE3NzBmYTkgYzE3NzBmMWIgMDAwMDAwMDAKWzcxMzQ0Ni4wOTc5MjddICBj
MTc3MGZhOSAwMDAwMDAwMCBjZTA2NWYxMCBjMTc3MzJlMiBjZTA2NWYyNCBjMmVmNzY0OSBj
MmVmNmZhOSAwMDAwMDAwMApbNzEzNDQ2LjEwMDQxOV0gQ2FsbCBUcmFjZToKWzcxMzQ0Ni4x
MDEyNzBdICBbPGMxNzZhMWQwPl0gZ2V0X2RldmljZSsweDJiLzB4NDEKWzcxMzQ0Ni4xMDIz
NDNdICBbPGMxNzcwMjgyPl0gZHJpdmVyX2RldGFjaCsweDY5LzB4MTRlCls3MTM0NDYuMTAz
NDY2XSAgWzxjMTc2ZTgyMj5dIGJ1c19yZW1vdmVfZHJpdmVyKzB4MTJkLzB4MTcyCls3MTM0
NDYuMTA0NjMwXSAgWzxjMTc3MGZhOT5dIGRyaXZlcl91bnJlZ2lzdGVyKzB4N2UvMHg5MQpb
NzEzNDQ2LjEwNTc4NF0gIFs8YzE3NzBmMWI+XSA/IGRyaXZlcl9yZW1vdmVfZ3JvdXBzKzB4
MTkvMHgyOQpbNzEzNDQ2LjEwNjk5N10gIFs8YzE3NzBmYTk+XSA/IGRyaXZlcl91bnJlZ2lz
dGVyKzB4N2UvMHg5MQpbNzEzNDQ2LjEwODE5MF0gIFs8YzE3NzMyZTI+XSBwbGF0Zm9ybV9k
cml2ZXJfdW5yZWdpc3RlcisweDE5LzB4MjkKWzcxMzQ0Ni4xMDk0NjNdICBbPGMyZWY3NjQ5
Pl0gaW5pdF9tYWM4MDIxMV9od3NpbSsweDZhMC8weDZiOApbNzEzNDQ2LjExMDY0M10gIFs8
YzJlZjZmYTk+XSA/IHA1NHBfZHJpdmVyX2luaXQrMHgzMi8weDMyCls3MTM0NDYuMTExODAx
XSAgWzxjMmU5NjU2ZT5dIGRvX29uZV9pbml0Y2FsbCsweDEzMS8weDI0ZApbNzEzNDQ2LjEx
Mjk0Nl0gIFs8YzJlOTU2YTE+XSA/IHJlcGFpcl9lbnZfc3RyaW5nKzB4MzIvMHhkMwpbNzEz
NDQ2LjExNDEyMF0gIFs8YzJlOTU2NmY+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4MTI4LzB4MTI4
Cls3MTM0NDYuMTE1MzE5XSAgWzxjMTBjYWExOT5dID8gcGFyc2VfYXJncysweDQxYS8weDVj
ZgpbNzEzNDQ2LjExNjQyNV0gIFs8YzJlOTU2NmY+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4MTI4
LzB4MTI4Cls3MTM0NDYuMTE3NTgzXSAgWzxjMmU5NjkwNT5dIGtlcm5lbF9pbml0X2ZyZWVh
YmxlKzB4MjdiLzB4M2U5Cls3MTM0NDYuMTE4NzcwXSAgWzxjMmU5NjkwNT5dID8ga2VybmVs
X2luaXRfZnJlZWFibGUrMHgyN2IvMHgzZTkKWzcxMzQ0Ni4xMjAwMTNdICBbPGMyNTkyNTgy
Pl0ga2VybmVsX2luaXQrMHgxNi8weDFmYQpbNzEzNDQ2LjEyMTEwMl0gIFs8YzI1YzkxNWI+
XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MWIvMHgzMApbNzEzNDQ2LjEyMjMwNl0gIFs8
YzI1OTI1NmM+XSA/IHJlc3RfaW5pdCsweGYxLzB4ZjEKWzcxMzQ0Ni4xMjMzOTldIENvZGU6
IGMwIDUzIDg5IGMzIDBmIDg0IGEwIDAwIDAwIDAwIDgzIDA1IGM4IGY0IDE3IGMzIDAxIDgz
IDE1IGNjIGY0IDE3IGMzIDAwIGI4IDAxIDAwIDAwIDAwIDgzIDA1IDE4IGU4IDE3IGMzIDAx
IDgzIDE1IDFjIGU4IDE3IGMzIDAwIDwwZj4gYzEgNDMgMWMgODMgMDUgMjAgZTggMTcgYzMg
MDEgODMgMTUgMjQgZTggMTcgYzMgMDAgNDAgNDggN2YKWzcxMzQ0Ni4xMzE2NzBdIEVJUDog
WzxjMTQ2M2QwZj5dIGtvYmplY3RfZ2V0KzB4M2QvMHhjMSBTUzpFU1AgMDA2ODpjZTA2NWVj
MApbNzEzNDQ2LjEzMzIzNV0gQ1IyOiAwMDAwMDAwMDZiNmI2YjhmCls3MTM0NDYuMTM0MTc0
XSAtLS1bIGVuZCB0cmFjZSAxODliNDNiYjM5MTliODMwIF0tLS0KWzcxMzQ0Ni4xMzUyOTdd
IEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBGYXRhbCBleGNlcHRpb24KL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctcjEtMDEyMi83ODM5MDg5M2MwNjI4ZDRlODNmYjI2MzBiZGU5OWM4
ZmQ2YjBmMGQwL2RtZXNnLXF1YW50YWwtcm9hbS0xNjoyMDE0MDEyNDE3MDUzNzppMzg2LXJh
bmRjb25maWctcjEtMDEyMjozLjEzLjAtMDQ3NTctZzc4MzkwODk6MTIzCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLXIxLTAxMjIvNzgzOTA4OTNjMDYyOGQ0ZTgzZmIyNjMwYmRlOTljOGZk
NmIwZjBkMC9kbWVzZy15b2N0by1yb2FtLTM4OjIwMTQwMTI0MTcwNTM3OmkzODYtcmFuZGNv
bmZpZy1yMS0wMTIyOjMuMTMuMC0wNDc1Ny1nNzgzOTA4OToxMjMKMDoyOjIgYWxsX2dvb2Q6
YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDEtMjQgMTc6MDU6NTMgUkVQRUFUIENP
VU5UOiAyMCAgIyAvY2Mvd2ZnL3VzYi1iaXNlY3QvLnJlcGVhdBtbMG0KCmxpbmVhci1iaXNl
Y3Q6IGJhZCBicmFuY2ggbWF5IGJlIG1hYzgwMjExLW5leHQvd2lwCmxpbmVhci1iaXNlY3Q6
IGhhbmRsZSBvdmVyIHRvIGdpdCBiaXNlY3QKbGluZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBz
dGFydCA3ODM5MDg5M2MwNjI4ZDRlODNmYjI2MzBiZGU5OWM4ZmQ2YjBmMGQwIDExZWZhMjEx
MjFiMDA0ODY5MWIwYzlmMjEwZmZlYjQ2ZTM3ZTg4YjkgLS0KUHJldmlvdXMgSEVBRCBwb3Np
dGlvbiB3YXMgNzgzOTA4OS4uLiBNZXJnZSAnbWFjODAyMTEtbmV4dC93aXAnIGludG8gZGV2
ZWwtcm9hbS1pMzg2LTIwMTQwMTIyMTgzNwpIRUFEIGlzIG5vdyBhdCA2ZTQ2NjQ1Li4uIExp
bnV4IDMuMTEKQmlzZWN0aW5nOiA1IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSAzIHN0ZXBzKQpbOTliNzY3YjQ1N2ZlZTM2MmIyNTcyMjlhMzU2YTcyYWU2
MGZlYTk3YV0gbWFjODAyMTE6IG1pbnN0cmVsX2h0OiBzYW1wbGVfdGFibGUgY2FuIGJlIF9f
cmVhZF9tb3N0bHkKbGluZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBydW4gL2Mva2VybmVsLXRl
c3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNl
Y3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXIxLTAxMjIvbGludXgtZGV2ZWw6ZGV2ZWwtcm9hbS1p
Mzg2LTIwMTQwMTIyMTgzNzo5OWI3NjdiNDU3ZmVlMzYyYjI1NzIyOWEzNTZhNzJhZTYwZmVh
OTdhOmJpc2VjdC11c2IKICAvYy9rZXJuZWwtdGVzdHMvY29tbW9uLnNoOjE2NDogZHVtcF9z
dGFjawogIC9jL2tlcm5lbC10ZXN0cy9jb21tb24uc2g6MTkyOiBjaGVja19jbWRfcmVzdWx0
CiAgL2Mva2VybmVsLXRlc3RzL2NvbW1vbi5zaDoyNTE6IGdyZXAKICAvYy9rZXJuZWwtdGVz
dHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoOjg0OiByZXVzZV9vbGRfZ29vZF9iYWQK
ICAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoOjkyOiBtYWlu
CgoyMDE0LTAxLTI0LTE3OjA2OjIxIDk5Yjc2N2I0NTdmZWUzNjJiMjU3MjI5YTM1NmE3MmFl
NjBmZWE5N2EgY29tcGlsaW5nCjMwMCByZWFsICAyMzg4IHVzZXIgIDE5NSBzeXMgIDg2MC44
MCUgY3B1IAlpMzg2LXJhbmRjb25maWctcjEtMDEyMgoKMjAxNC0wMS0yNC0xNzoxMTozNyBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtMTEyOTAtZzk5Yjc2N2IuLi4JMgk2CTIwIFNV
Q0NFU1MKCkJpc2VjdGluZzogMiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgMiBzdGVwcykKWzk3YjUxYTkxYmJjZWUxY2YyMTdjNGFmMjE0MGM4YzlhYjc3
NjFkZGRdIG1hYzgwMjExX2h3c2ltOiByZXBvcnQgc3VydmV5IGRhdGEgZm9yIHNjYW5uZWQg
Y2hhbm5lbHMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXIxLTAxMjIvbGludXgtZGV2ZWw6ZGV2ZWwt
cm9hbS1pMzg2LTIwMTQwMTIyMTgzNzo5N2I1MWE5MWJiY2VlMWNmMjE3YzRhZjIxNDBjOGM5
YWI3NzYxZGRkOmJpc2VjdC11c2IKICAvYy9rZXJuZWwtdGVzdHMvY29tbW9uLnNoOjE2NDog
ZHVtcF9zdGFjawogIC9jL2tlcm5lbC10ZXN0cy9jb21tb24uc2g6MTkyOiBjaGVja19jbWRf
cmVzdWx0CiAgL2Mva2VybmVsLXRlc3RzL2NvbW1vbi5zaDoyNTE6IGdyZXAKICAvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoOjg0OiByZXVzZV9vbGRfZ29v
ZF9iYWQKICAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoOjky
OiBtYWluCgoyMDE0LTAxLTI0LTE3OjE0OjM4IDk3YjUxYTkxYmJjZWUxY2YyMTdjNGFmMjE0
MGM4YzlhYjc3NjFkZGQgY29tcGlsaW5nCjcwIHJlYWwgIDMxOCB1c2VyICAyNyBzeXMgIDQ4
OC4yOCUgY3B1IAlpMzg2LXJhbmRjb25maWctcjEtMDEyMgoKMjAxNC0wMS0yNC0xNzoxNTo1
OSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtMTEyOTMtZzk3YjUxYTkuLiBURVNUIEZB
SUxVUkUKWyAgICA0LjczMDg1MV0gaWVlZTgwMjExIHBoeTA6IEZhaWxlZCB0byBzZWxlY3Qg
cmF0ZSBjb250cm9sIGFsZ29yaXRobQpbICAgIDQuNzMyMjE0XSBpZWVlODAyMTEgcGh5MDog
RmFpbGVkIHRvIGluaXRpYWxpemUgcmF0ZSBjb250cm9sIGFsZ29yaXRobQpbICAgIDQuNzMz
NzQyXSBtYWM4MDIxMV9od3NpbTogaWVlZTgwMjExX3JlZ2lzdGVyX2h3IGZhaWxlZCAoLTIp
ClsgICAgNC43MzUxMzVdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFnaW5nIHJl
cXVlc3QgYXQgNmI2YjZiOGYKWyAgICA0LjczNjgzNV0gSVA6IFs8YzE0NWUzNjg+XSBrb2Jq
ZWN0X2dldCsweDNkLzB4YzEKWyAgICA0LjczODEyMF0gKnBkZSA9IDAwMDAwMDAwIApbICAg
IDQuNzM5MTQ1XSBPb3BzOiAwMDAyIFsjMV0gClsgICAgNC43NDAxMTldIENQVTogMCBQSUQ6
IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjEyLjAtMTEyOTMtZzk3YjUxYTkgIzEy
NQpbICAgIDQuNzQwNzQxXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2No
cyAwMS8wMS8yMDExClsgICAgNC43NDA3NDFdIHRhc2s6IGNlMDYwMDAwIHRpOiBjZTA2NDAw
MCB0YXNrLnRpOiBjZTA2NDAwMApbICAgIDQuNzQwNzQxXSBFSVA6IDAwNjA6WzxjMTQ1ZTM2
OD5dIEVGTEFHUzogMDAwMTAyNDYgQ1BVOiAwClsgICAgNC43NDA3NDFdIEVJUCBpcyBhdCBr
b2JqZWN0X2dldCsweDNkLzB4YzEKWyAgICA0Ljc0MDc0MV0gRUFYOiAwMDAwMDAwMSBFQlg6
IDZiNmI2YjczIEVDWDogMDAwMDAwMDAgRURYOiBjZWJjYzQ4MApbICAgIDQuNzQwNzQxXSBF
U0k6IGMyY2ExMGQ0IEVESTogY2UwNjVmMDQgRUJQOiBjZTA2NWVjNCBFU1A6IGNlMDY1ZWMw
ClsgICAgNC43NDA3NDFdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDAwMCBHUzogMDBlMCBT
UzogMDA2OApbICAgIDQuNzQwNzQxXSBDUjA6IDgwMDUwMDNiIENSMjogNmI2YjZiOGYgQ1Iz
OiAwMmY1YjAwMCBDUjQ6IDAwMDAwNjkwClsgICAgNC43NDA3NDFdIFN0YWNrOgpbICAgIDQu
NzQwNzQxXSAgNmI2YjZiNmIgY2UwNjVlY2MgYzE3NWE1MmUgY2UwNjVlZTAgYzE3NjA1OGMg
YzJjYTEwZDQgZmZmZmZmZmUgY2UwNjVmMDQKWyAgICA0Ljc0MDc0MV0gIGNlMDY1ZWYwIGMx
NzVlYjBmIGMyY2ExMGQ0IGNlMDY1ZjA0IGNlMDY1ZjA4IGMxNzYxMmIzIGMxNzYxMjI1IDAw
MDAwMDAwClsgICAgNC43NDA3NDFdICBjMTc2MTJiMyAwMDAwMDAwMCBjZTA2NWYxMCBjMTc2
MzVlYyBjZTA2NWYyNCBjMmVjZWY1MCBjMmVjZThiMCAwMDAwMDAwMApbICAgIDQuNzQwNzQx
XSBDYWxsIFRyYWNlOgpbICAgIDQuNzQwNzQxXSAgWzxjMTc1YTUyZT5dIGdldF9kZXZpY2Ur
MHgyYi8weDQxClsgICAgNC43NDA3NDFdICBbPGMxNzYwNThjPl0gZHJpdmVyX2RldGFjaCsw
eDY5LzB4MTRlClsgICAgNC43NDA3NDFdICBbPGMxNzVlYjBmPl0gYnVzX3JlbW92ZV9kcml2
ZXIrMHgxMmQvMHgxNzIKWyAgICA0Ljc0MDc0MV0gIFs8YzE3NjEyYjM+XSBkcml2ZXJfdW5y
ZWdpc3RlcisweDdlLzB4OTEKWyAgICA0Ljc0MDc0MV0gIFs8YzE3NjEyMjU+XSA/IGRyaXZl
cl9yZW1vdmVfZ3JvdXBzKzB4MTkvMHgyOQpbICAgIDQuNzQwNzQxXSAgWzxjMTc2MTJiMz5d
ID8gZHJpdmVyX3VucmVnaXN0ZXIrMHg3ZS8weDkxClsgICAgNC43NDA3NDFdICBbPGMxNzYz
NWVjPl0gcGxhdGZvcm1fZHJpdmVyX3VucmVnaXN0ZXIrMHgxOS8weDI5ClsgICAgNC43NDA3
NDFdICBbPGMyZWNlZjUwPl0gaW5pdF9tYWM4MDIxMV9od3NpbSsweDZhMC8weDZiOApbICAg
IDQuNzQwNzQxXSAgWzxjMmVjZThiMD5dID8gcDU0cF9kcml2ZXJfaW5pdCsweDMyLzB4MzIK
WyAgICA0Ljc0MDc0MV0gIFs8YzJlNmY1NTU+XSBkb19vbmVfaW5pdGNhbGwrMHgxMzEvMHgy
NGQKWyAgICA0Ljc0MDc0MV0gIFs8YzJlNmU2YTE+XSA/IHJlcGFpcl9lbnZfc3RyaW5nKzB4
MzIvMHhkMwpbICAgIDQuNzQwNzQxXSAgWzxjMmU2ZTY2Zj5dID8gZG9fZWFybHlfcGFyYW0r
MHgxMjgvMHgxMjgKWyAgICA0Ljc0MDc0MV0gIFs8YzEwYzg0Mzk+XSA/IHBhcnNlX2FyZ3Mr
MHg0MWEvMHg1Y2YKWyAgICA0Ljc0MDc0MV0gIFs8YzJlNmU2NmY+XSA/IGRvX2Vhcmx5X3Bh
cmFtKzB4MTI4LzB4MTI4ClsgICAgNC43NDA3NDFdICBbPGMyZTZmOGVjPl0ga2VybmVsX2lu
aXRfZnJlZWFibGUrMHgyN2IvMHgzZTkKWyAgICA0Ljc0MDc0MV0gIFs8YzJlNmY4ZWM+XSA/
IGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MjdiLzB4M2U5ClsgICAgNC43NDA3NDFdICBbPGMy
NTc3OWYyPl0ga2VybmVsX2luaXQrMHgxNi8weDFmYQpbICAgIDQuNzQwNzQxXSAgWzxjMjVh
ZTEzYj5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDMwClsgICAgNC43NDA3NDFd
ICBbPGMyNTc3OWRjPl0gPyByZXN0X2luaXQrMHhmMS8weGYxClsgICAgNC43NDA3NDFdIENv
ZGU6IGMwIDUzIDg5IGMzIDBmIDg0IGEwIDAwIDAwIDAwIDgzIDA1IGY4IDA1IDE1IGMzIDAx
IDgzIDE1IGZjIDA1IDE1IGMzIDAwIGI4IDAxIDAwIDAwIDAwIDgzIDA1IDg4IGY5IDE0IGMz
IDAxIDgzIDE1IDhjIGY5IDE0IGMzIDAwIDwwZj4gYzEgNDMgMWMgODMgMDUgOTAgZjkgMTQg
YzMgMDEgODMgMTUgOTQgZjkgMTQgYzMgMDAgNDAgNDggN2YKWyAgICA0Ljc0MDc0MV0gRUlQ
OiBbPGMxNDVlMzY4Pl0ga29iamVjdF9nZXQrMHgzZC8weGMxIFNTOkVTUCAwMDY4OmNlMDY1
ZWMwClsgICAgNC43NDA3NDFdIENSMjogMDAwMDAwMDA2YjZiNmI4ZgpbICAgIDQuNzQwNzQx
XSAtLS1bIGVuZCB0cmFjZSAxZTk0ODEwZDc3ZWQxMGY5IF0tLS0KWyAgICA0Ljc0MDc0MV0g
S2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEZhdGFsIGV4Y2VwdGlvbgova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1yMS0wMTIyLzk3YjUxYTkxYmJjZWUxY2YyMTdjNGFmMjE0MGM4Yzlh
Yjc3NjFkZGQvZG1lc2ctcXVhbnRhbC14cHMtNToyMDE0MDEyNDE3MTYzMzppMzg2LXJhbmRj
b25maWctcjEtMDEyMjozLjEyLjAtMTEyOTMtZzk3YjUxYTk6MTI1Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLXIxLTAxMjIvOTdiNTFhOTFiYmNlZTFjZjIxN2M0YWYyMTQwYzhjOWFiNzc2
MWRkZC9kbWVzZy15b2N0by1hdGhlbnMtMTc6MjAxNDAxMjQxNzE2MjM6aTM4Ni1yYW5kY29u
ZmlnLXIxLTAxMjI6My4xMi4wLTExMjkzLWc5N2I1MWE5OjEyNQowOjI6MiBhbGxfZ29vZDpi
YWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wMS0yNCAxNzoxNzowMSBSRVBFQVQgQ09V
TlQ6IDIwICAjIC9jYy93ZmcvdXNiLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiAw
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0ZXApCltk
MzBmZmIxMGRmYTEzNGVmMWQxZTAxN2U5NmJjNzRmZDkwOWQwNzc4XSBtYWM4MDIxMV9od3Np
bTogbWFrZSBQMlAtRGV2aWNlIHN1cHBvcnQgb3B0aW9uYWwKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2JqLWJp
c2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmln
LXIxLTAxMjIvbGludXgtZGV2ZWw6ZGV2ZWwtcm9hbS1pMzg2LTIwMTQwMTIyMTgzNzpkMzBm
ZmIxMGRmYTEzNGVmMWQxZTAxN2U5NmJjNzRmZDkwOWQwNzc4OmJpc2VjdC11c2IKICAvYy9r
ZXJuZWwtdGVzdHMvY29tbW9uLnNoOjE2NDogZHVtcF9zdGFjawogIC9jL2tlcm5lbC10ZXN0
cy9jb21tb24uc2g6MTkyOiBjaGVja19jbWRfcmVzdWx0CiAgL2Mva2VybmVsLXRlc3RzL2Nv
bW1vbi5zaDoyNTE6IGdyZXAKICAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoOjg0OiByZXVzZV9vbGRfZ29vZF9iYWQKICAvYy9rZXJuZWwtdGVzdHMvYmlz
ZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoOjkyOiBtYWluCgoyMDE0LTAxLTI0LTE3OjE3OjAz
IGQzMGZmYjEwZGZhMTM0ZWYxZDFlMDE3ZTk2YmM3NGZkOTA5ZDA3NzggY29tcGlsaW5nCjU4
IHJlYWwgIDgxIHVzZXIgIDkgc3lzICAxNTYuMDklIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXIx
LTAxMjIKCjIwMTQtMDEtMjQtMTc6MTg6MTIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4w
LTExMjkyLWdkMzBmZmIxLi4gVEVTVCBGQUlMVVJFClsgICAgNS4wMjEzNDldIGllZWU4MDIx
MSBwaHkwOiBGYWlsZWQgdG8gc2VsZWN0IHJhdGUgY29udHJvbCBhbGdvcml0aG0KWyAgICA1
LjAyMjcxNV0gaWVlZTgwMjExIHBoeTA6IEZhaWxlZCB0byBpbml0aWFsaXplIHJhdGUgY29u
dHJvbCBhbGdvcml0aG0KWyAgICA1LjAyNDIxOF0gbWFjODAyMTFfaHdzaW06IGllZWU4MDIx
MV9yZWdpc3Rlcl9odyBmYWlsZWQgKC0yKQpbICAgIDUuMDI1NjAwXSBCVUc6IHVuYWJsZSB0
byBoYW5kbGUga2VybmVsIHBhZ2luZyByZXF1ZXN0IGF0IDZiNmI2YjhmClsgICAgNS4wMjcx
MjFdIElQOiBbPGMxNDVlMzY4Pl0ga29iamVjdF9nZXQrMHgzZC8weGMxClsgICAgNS4wMjgz
ODVdICpwZGUgPSAwMDAwMDAwMCAKWyAgICA1LjAyOTM0OV0gT29wczogMDAwMiBbIzFdIApb
ICAgIDUuMDMwMTY5XSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQg
My4xMi4wLTExMjkyLWdkMzBmZmIxICMxMjYKWyAgICA1LjAzMDE2OV0gSGFyZHdhcmUgbmFt
ZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDUuMDMwMTY5XSB0
YXNrOiBjZTA2MDAwMCB0aTogY2UwNjQwMDAgdGFzay50aTogY2UwNjQwMDAKWyAgICA1LjAz
MDE2OV0gRUlQOiAwMDYwOls8YzE0NWUzNjg+XSBFRkxBR1M6IDAwMDEwMjQ2IENQVTogMApb
ICAgIDUuMDMwMTY5XSBFSVAgaXMgYXQga29iamVjdF9nZXQrMHgzZC8weGMxClsgICAgNS4w
MzAxNjldIEVBWDogMDAwMDAwMDEgRUJYOiA2YjZiNmI3MyBFQ1g6IDAwMDAwMDAwIEVEWDog
Y2ViYzkzZjAKWyAgICA1LjAzMDE2OV0gRVNJOiBjMmNhMTBkNCBFREk6IGNlMDY1ZjA0IEVC
UDogY2UwNjVlYzQgRVNQOiBjZTA2NWVjMApbICAgIDUuMDMwMTY5XSAgRFM6IDAwN2IgRVM6
IDAwN2IgRlM6IDAwMDAgR1M6IDAwZTAgU1M6IDAwNjgKWyAgICA1LjAzMDE2OV0gQ1IwOiA4
MDA1MDAzYiBDUjI6IDZiNmI2YjhmIENSMzogMDJmNWIwMDAgQ1I0OiAwMDAwMDY5MApbICAg
IDUuMDMwMTY5XSBTdGFjazoKWyAgICA1LjAzMDE2OV0gIDZiNmI2YjZiIGNlMDY1ZWNjIGMx
NzVhNTJlIGNlMDY1ZWUwIGMxNzYwNThjIGMyY2ExMGQ0IGZmZmZmZmZlIGNlMDY1ZjA0Clsg
ICAgNS4wMzAxNjldICBjZTA2NWVmMCBjMTc1ZWIwZiBjMmNhMTBkNCBjZTA2NWYwNCBjZTA2
NWYwOCBjMTc2MTJiMyBjMTc2MTIyNSAwMDAwMDAwMApbICAgIDUuMDMwMTY5XSAgYzE3NjEy
YjMgMDAwMDAwMDAgY2UwNjVmMTAgYzE3NjM1ZWMgY2UwNjVmMjQgYzJlY2VmNTAgYzJlY2U4
YjAgMDAwMDAwMDAKWyAgICA1LjAzMDE2OV0gQ2FsbCBUcmFjZToKWyAgICA1LjAzMDE2OV0g
IFs8YzE3NWE1MmU+XSBnZXRfZGV2aWNlKzB4MmIvMHg0MQpbICAgIDUuMDMwMTY5XSAgWzxj
MTc2MDU4Yz5dIGRyaXZlcl9kZXRhY2grMHg2OS8weDE0ZQpbICAgIDUuMDMwMTY5XSAgWzxj
MTc1ZWIwZj5dIGJ1c19yZW1vdmVfZHJpdmVyKzB4MTJkLzB4MTcyClsgICAgNS4wMzAxNjld
ICBbPGMxNzYxMmIzPl0gZHJpdmVyX3VucmVnaXN0ZXIrMHg3ZS8weDkxClsgICAgNS4wMzAx
NjldICBbPGMxNzYxMjI1Pl0gPyBkcml2ZXJfcmVtb3ZlX2dyb3VwcysweDE5LzB4MjkKWyAg
ICA1LjAzMDE2OV0gIFs8YzE3NjEyYjM+XSA/IGRyaXZlcl91bnJlZ2lzdGVyKzB4N2UvMHg5
MQpbICAgIDUuMDMwMTY5XSAgWzxjMTc2MzVlYz5dIHBsYXRmb3JtX2RyaXZlcl91bnJlZ2lz
dGVyKzB4MTkvMHgyOQpbICAgIDUuMDMwMTY5XSAgWzxjMmVjZWY1MD5dIGluaXRfbWFjODAy
MTFfaHdzaW0rMHg2YTAvMHg2YjgKWyAgICA1LjAzMDE2OV0gIFs8YzJlY2U4YjA+XSA/IHA1
NHBfZHJpdmVyX2luaXQrMHgzMi8weDMyClsgICAgNS4wMzAxNjldICBbPGMyZTZmNTU1Pl0g
ZG9fb25lX2luaXRjYWxsKzB4MTMxLzB4MjRkClsgICAgNS4wMzAxNjldICBbPGMyZTZlNmEx
Pl0gPyByZXBhaXJfZW52X3N0cmluZysweDMyLzB4ZDMKWyAgICA1LjAzMDE2OV0gIFs8YzJl
NmU2NmY+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4MTI4LzB4MTI4ClsgICAgNS4wMzAxNjldICBb
PGMxMGM4NDM5Pl0gPyBwYXJzZV9hcmdzKzB4NDFhLzB4NWNmClsgICAgNS4wMzAxNjldICBb
PGMyZTZlNjZmPl0gPyBkb19lYXJseV9wYXJhbSsweDEyOC8weDEyOApbICAgIDUuMDMwMTY5
XSAgWzxjMmU2ZjhlYz5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MjdiLzB4M2U5ClsgICAg
NS4wMzAxNjldICBbPGMyZTZmOGVjPl0gPyBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDI3Yi8w
eDNlOQpbICAgIDUuMDMwMTY5XSAgWzxjMjU3NzZlMj5dIGtlcm5lbF9pbml0KzB4MTYvMHgx
ZmEKWyAgICA1LjAzMDE2OV0gIFs8YzI1YWRlMWI+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFk
KzB4MWIvMHgzMApbICAgIDUuMDMwMTY5XSAgWzxjMjU3NzZjYz5dID8gcmVzdF9pbml0KzB4
ZjEvMHhmMQpbICAgIDUuMDMwMTY5XSBDb2RlOiBjMCA1MyA4OSBjMyAwZiA4NCBhMCAwMCAw
MCAwMCA4MyAwNSBmOCAwNSAxNSBjMyAwMSA4MyAxNSBmYyAwNSAxNSBjMyAwMCBiOCAwMSAw
MCAwMCAwMCA4MyAwNSA4OCBmOSAxNCBjMyAwMSA4MyAxNSA4YyBmOSAxNCBjMyAwMCA8MGY+
IGMxIDQzIDFjIDgzIDA1IDkwIGY5IDE0IGMzIDAxIDgzIDE1IDk0IGY5IDE0IGMzIDAwIDQw
IDQ4IDdmClsgICAgNS4wMzAxNjldIEVJUDogWzxjMTQ1ZTM2OD5dIGtvYmplY3RfZ2V0KzB4
M2QvMHhjMSBTUzpFU1AgMDA2ODpjZTA2NWVjMApbICAgIDUuMDMwMTY5XSBDUjI6IDAwMDAw
MDAwNmI2YjZiOGYKWyAgICA1LjAzMDE2OV0gLS0tWyBlbmQgdHJhY2UgYzk1MGEzZTllNzBk
Y2QzYyBdLS0tClsgICAgNS4wMzAxNjldIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBG
YXRhbCBleGNlcHRpb24KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjEtMDEyMi9kMzBmZmIx
MGRmYTEzNGVmMWQxZTAxN2U5NmJjNzRmZDkwOWQwNzc4L2RtZXNnLXF1YW50YWwtYXRoZW5z
LTE6MjAxNDAxMjQxNzE4NTM6aTM4Ni1yYW5kY29uZmlnLXIxLTAxMjI6My4xMi4wLTExMjky
LWdkMzBmZmIxOjEyNgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMS0wMTIyL2QzMGZmYjEw
ZGZhMTM0ZWYxZDFlMDE3ZTk2YmM3NGZkOTA5ZDA3NzgvZG1lc2ctcXVhbnRhbC1hdGhlbnMt
NDQ6MjAxNDAxMjQxNzE4NDg6aTM4Ni1yYW5kY29uZmlnLXIxLTAxMjI6My4xMi4wLTExMjky
LWdkMzBmZmIxOjEyNgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMS0wMTIyL2QzMGZmYjEw
ZGZhMTM0ZWYxZDFlMDE3ZTk2YmM3NGZkOTA5ZDA3NzgvZG1lc2ctcXVhbnRhbC1yb2FtLTM5
OjIwMTQwMTI0MTcxODUzOmkzODYtcmFuZGNvbmZpZy1yMS0wMTIyOjMuMTIuMC0xMTI5Mi1n
ZDMwZmZiMToxMjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjEtMDEyMi9kMzBmZmIxMGRm
YTEzNGVmMWQxZTAxN2U5NmJjNzRmZDkwOWQwNzc4L2RtZXNnLXF1YW50YWwtcm9hbS00NToy
MDE0MDEyNDE3MTg1MTppMzg2LXJhbmRjb25maWctcjEtMDEyMjozLjEyLjAtMTEyOTItZ2Qz
MGZmYjE6MTI2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIxLTAxMjIvZDMwZmZiMTBkZmEx
MzRlZjFkMWUwMTdlOTZiYzc0ZmQ5MDlkMDc3OC9kbWVzZy1xdWFudGFsLXdhaW1lYS0yOjIw
MTQwMTI0MTcxODUzOmkzODYtcmFuZGNvbmZpZy1yMS0wMTIyOjMuMTIuMC0xMTI5Mi1nZDMw
ZmZiMToxMjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjEtMDEyMi9kMzBmZmIxMGRmYTEz
NGVmMWQxZTAxN2U5NmJjNzRmZDkwOWQwNzc4L2RtZXNnLXF1YW50YWwteHBzLTU6MjAxNDAx
MjQxNzE4NTE6aTM4Ni1yYW5kY29uZmlnLXIxLTAxMjI6My4xMi4wLTExMjkyLWdkMzBmZmIx
OjEyNgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMS0wMTIyL2QzMGZmYjEwZGZhMTM0ZWYx
ZDFlMDE3ZTk2YmM3NGZkOTA5ZDA3NzgvZG1lc2cteW9jdG8tYXRoZW5zLTEyOjIwMTQwMTI0
MTcxODUzOmkzODYtcmFuZGNvbmZpZy1yMS0wMTIyOjMuMTIuMC0xMTI5Mi1nZDMwZmZiMTox
MjYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjEtMDEyMi9kMzBmZmIxMGRmYTEzNGVmMWQx
ZTAxN2U5NmJjNzRmZDkwOWQwNzc4L2RtZXNnLXlvY3RvLWF0aGVucy0yOToyMDE0MDEyNDE3
MTg0NTppMzg2LXJhbmRjb25maWctcjEtMDEyMjozLjEyLjAtMTEyOTItZ2QzMGZmYjE6MTI2
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIxLTAxMjIvZDMwZmZiMTBkZmExMzRlZjFkMWUw
MTdlOTZiYzc0ZmQ5MDlkMDc3OC9kbWVzZy15b2N0by1hdGhlbnMtNDI6MjAxNDAxMjQxNzE4
NDc6aTM4Ni1yYW5kY29uZmlnLXIxLTAxMjI6My4xMi4wLTExMjkyLWdkMzBmZmIxOjEyNgov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMS0wMTIyL2QzMGZmYjEwZGZhMTM0ZWYxZDFlMDE3
ZTk2YmM3NGZkOTA5ZDA3NzgvZG1lc2cteW9jdG8tYXRoZW5zLTY6MjAxNDAxMjQxNzE4NTM6
aTM4Ni1yYW5kY29uZmlnLXIxLTAxMjI6My4xMi4wLTExMjkyLWdkMzBmZmIxOjEyNgova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1yMS0wMTIyL2QzMGZmYjEwZGZhMTM0ZWYxZDFlMDE3ZTk2
YmM3NGZkOTA5ZDA3NzgvZG1lc2cteW9jdG8tY2Fpcm8tMTI6MjAxNDAxMjQxNzE4NTM6aTM4
Ni1yYW5kY29uZmlnLXIxLTAxMjI6My4xMi4wLTExMjkyLWdkMzBmZmIxOjEyNgova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1yMS0wMTIyL2QzMGZmYjEwZGZhMTM0ZWYxZDFlMDE3ZTk2YmM3
NGZkOTA5ZDA3NzgvZG1lc2cteW9jdG8tY2Fpcm8tMzc6MjAxNDAxMjQxNzE4NTM6aTM4Ni1y
YW5kY29uZmlnLXIxLTAxMjI6My4xMi4wLTExMjkyLWdkMzBmZmIxOjEyNgova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1yMS0wMTIyL2QzMGZmYjEwZGZhMTM0ZWYxZDFlMDE3ZTk2YmM3NGZk
OTA5ZDA3NzgvZG1lc2cteW9jdG8tY2Fpcm8tNjoyMDE0MDEyNDE3MTg1MzppMzg2LXJhbmRj
b25maWctcjEtMDEyMjozLjEyLjAtMTEyOTItZ2QzMGZmYjE6MTI2Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLXIxLTAxMjIvZDMwZmZiMTBkZmExMzRlZjFkMWUwMTdlOTZiYzc0ZmQ5MDlk
MDc3OC9kbWVzZy15b2N0by1yb2FtLTE5OjIwMTQwMTI0MTcxODQ4OmkzODYtcmFuZGNvbmZp
Zy1yMS0wMTIyOjMuMTIuMC0xMTI5Mi1nZDMwZmZiMToxMjYKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctcjEtMDEyMi9kMzBmZmIxMGRmYTEzNGVmMWQxZTAxN2U5NmJjNzRmZDkwOWQwNzc4
L2RtZXNnLXlvY3RvLXJvYW0tMjQ6MjAxNDAxMjQxNzE4NTE6aTM4Ni1yYW5kY29uZmlnLXIx
LTAxMjI6My4xMi4wLTExMjkyLWdkMzBmZmIxOjEyNgova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1yMS0wMTIyL2QzMGZmYjEwZGZhMTM0ZWYxZDFlMDE3ZTk2YmM3NGZkOTA5ZDA3NzgvZG1l
c2cteW9jdG8tcm9hbS00MjoyMDE0MDEyNDE3MTg0ODppMzg2LXJhbmRjb25maWctcjEtMDEy
MjozLjEyLjAtMTEyOTItZ2QzMGZmYjE6MTI2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIx
LTAxMjIvZDMwZmZiMTBkZmExMzRlZjFkMWUwMTdlOTZiYzc0ZmQ5MDlkMDc3OC9kbWVzZy15
b2N0by1yb2FtLTU6MjAxNDAxMjQxNzE4NDg6aTM4Ni1yYW5kY29uZmlnLXIxLTAxMjI6My4x
Mi4wLTExMjkyLWdkMzBmZmIxOjEyNgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMS0wMTIy
L2QzMGZmYjEwZGZhMTM0ZWYxZDFlMDE3ZTk2YmM3NGZkOTA5ZDA3NzgvZG1lc2cteW9jdG8t
d2FpbWVhLTEyOjIwMTQwMTI0MTcxODUzOmkzODYtcmFuZGNvbmZpZy1yMS0wMTIyOjMuMTIu
MC0xMTI5Mi1nZDMwZmZiMToxMjYKMDoxODoxOCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290
cwobWzE7MzVtMjAxNC0wMS0yNCAxNzoxOToxMyBSRVBFQVQgQ09VTlQ6IDIwICAjIC9jYy93
ZmcvdXNiLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAwIHN0ZXBzKQpbYzk5MGQxOWUzMGNlYTlm
M2QzOWYwMmM4MDdmMDlmMGJlMmE1ZWQ3MV0gbWFjODAyMTE6IHJlbW92ZSBtb2R1bGUgaGFu
ZGxpbmcgZnJvbSByYXRlIGNvbnRyb2wgb3BzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yMS0wMTIy
L2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0MDEyMjE4Mzc6Yzk5MGQxOWUzMGNl
YTlmM2QzOWYwMmM4MDdmMDlmMGJlMmE1ZWQ3MTpiaXNlY3QtdXNiCiAgL2Mva2VybmVsLXRl
c3RzL2NvbW1vbi5zaDoxNjQ6IGR1bXBfc3RhY2sKICAvYy9rZXJuZWwtdGVzdHMvY29tbW9u
LnNoOjE5MjogY2hlY2tfY21kX3Jlc3VsdAogIC9jL2tlcm5lbC10ZXN0cy9jb21tb24uc2g6
MjUxOiBncmVwCiAgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aDo4NDogcmV1c2Vfb2xkX2dvb2RfYmFkCiAgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaDo5MjogbWFpbgoKMjAxNC0wMS0yNC0xNzoxOToxNSBjOTkwZDE5
ZTMwY2VhOWYzZDM5ZjAyYzgwN2YwOWYwYmUyYTVlZDcxIGNvbXBpbGluZwo1NCByZWFsICA3
NyB1c2VyICAxMCBzeXMgIDE2Mi4zNCUgY3B1IAlpMzg2LXJhbmRjb25maWctcjEtMDEyMgoK
MjAxNC0wMS0yNC0xNzoyMDoyMiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtMTEyOTEt
Z2M5OTBkMTkuLiBURVNUIEZBSUxVUkUKWyAgICA2LjU0Mzc3NF0gaWVlZTgwMjExIHBoeTA6
IEZhaWxlZCB0byBzZWxlY3QgcmF0ZSBjb250cm9sIGFsZ29yaXRobQpbICAgIDYuNTQ2MTgz
XSBpZWVlODAyMTEgcGh5MDogRmFpbGVkIHRvIGluaXRpYWxpemUgcmF0ZSBjb250cm9sIGFs
Z29yaXRobQpbICAgIDYuNTQ4NjcyXSBtYWM4MDIxMV9od3NpbTogaWVlZTgwMjExX3JlZ2lz
dGVyX2h3IGZhaWxlZCAoLTIpClsgICAgNi41NTExNjldIEJVRzogdW5hYmxlIHRvIGhhbmRs
ZSBrZXJuZWwgcGFnaW5nIHJlcXVlc3QgYXQgNmI2YjZiOGYKWyAgICA2LjU1Mzc3OV0gSVA6
IFs8YzE0NWUzNjg+XSBrb2JqZWN0X2dldCsweDNkLzB4YzEKWyAgICA2LjU1NTk1MV0gKnBk
ZSA9IDAwMDAwMDAwIApbICAgIDYuNTU3NTY5XSBPb3BzOiAwMDAyIFsjMV0gClsgICAgNi41
NTkxOTldIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjEyLjAt
MTEyOTEtZ2M5OTBkMTkgIzEyNwpbICAgIDYuNTYwOTcyXSBIYXJkd2FyZSBuYW1lOiBCb2No
cyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgNi41NjA5NzJdIHRhc2s6IGNl
MDYwMDAwIHRpOiBjZTA2NDAwMCB0YXNrLnRpOiBjZTA2NDAwMApbICAgIDYuNTYwOTcyXSBF
SVA6IDAwNjA6WzxjMTQ1ZTM2OD5dIEVGTEFHUzogMDAwMTAyNDYgQ1BVOiAwClsgICAgNi41
NjA5NzJdIEVJUCBpcyBhdCBrb2JqZWN0X2dldCsweDNkLzB4YzEKWyAgICA2LjU2MDk3Ml0g
RUFYOiAwMDAwMDAwMSBFQlg6IDZiNmI2YjczIEVDWDogMDAwMDAwMDAgRURYOiBjZWJjOTNm
MApbICAgIDYuNTYwOTcyXSBFU0k6IGMyY2ExMGQ0IEVESTogY2UwNjVmMDQgRUJQOiBjZTA2
NWVjNCBFU1A6IGNlMDY1ZWMwClsgICAgNi41NjA5NzJdICBEUzogMDA3YiBFUzogMDA3YiBG
UzogMDAwMCBHUzogMDBlMCBTUzogMDA2OApbICAgIDYuNTYwOTcyXSBDUjA6IDgwMDUwMDNi
IENSMjogNmI2YjZiOGYgQ1IzOiAwMmY1YjAwMCBDUjQ6IDAwMDAwNjkwClsgICAgNi41NjA5
NzJdIFN0YWNrOgpbICAgIDYuNTYwOTcyXSAgNmI2YjZiNmIgY2UwNjVlY2MgYzE3NWE1MmUg
Y2UwNjVlZTAgYzE3NjA1OGMgYzJjYTEwZDQgZmZmZmZmZmUgY2UwNjVmMDQKWyAgICA2LjU2
MDk3Ml0gIGNlMDY1ZWYwIGMxNzVlYjBmIGMyY2ExMGQ0IGNlMDY1ZjA0IGNlMDY1ZjA4IGMx
NzYxMmIzIGMxNzYxMjI1IDAwMDAwMDAwClsgICAgNi41NjA5NzJdICBjMTc2MTJiMyAwMDAw
MDAwMCBjZTA2NWYxMCBjMTc2MzVlYyBjZTA2NWYyNCBjMmVjZWY0NCBjMmVjZThiMCAwMDAw
MDAwMApbICAgIDYuNTYwOTcyXSBDYWxsIFRyYWNlOgpbICAgIDYuNTYwOTcyXSAgWzxjMTc1
YTUyZT5dIGdldF9kZXZpY2UrMHgyYi8weDQxClsgICAgNi41NjA5NzJdICBbPGMxNzYwNThj
Pl0gZHJpdmVyX2RldGFjaCsweDY5LzB4MTRlClsgICAgNi41NjA5NzJdICBbPGMxNzVlYjBm
Pl0gYnVzX3JlbW92ZV9kcml2ZXIrMHgxMmQvMHgxNzIKWyAgICA2LjU2MDk3Ml0gIFs8YzE3
NjEyYjM+XSBkcml2ZXJfdW5yZWdpc3RlcisweDdlLzB4OTEKWyAgICA2LjU2MDk3Ml0gIFs8
YzE3NjEyMjU+XSA/IGRyaXZlcl9yZW1vdmVfZ3JvdXBzKzB4MTkvMHgyOQpbICAgIDYuNTYw
OTcyXSAgWzxjMTc2MTJiMz5dID8gZHJpdmVyX3VucmVnaXN0ZXIrMHg3ZS8weDkxClsgICAg
Ni41NjA5NzJdICBbPGMxNzYzNWVjPl0gcGxhdGZvcm1fZHJpdmVyX3VucmVnaXN0ZXIrMHgx
OS8weDI5ClsgICAgNi41NjA5NzJdICBbPGMyZWNlZjQ0Pl0gaW5pdF9tYWM4MDIxMV9od3Np
bSsweDY5NC8weDZhYwpbICAgIDYuNTYwOTcyXSAgWzxjMmVjZThiMD5dID8gcDU0cF9kcml2
ZXJfaW5pdCsweDMyLzB4MzIKWyAgICA2LjU2MDk3Ml0gIFs8YzJlNmY1NTU+XSBkb19vbmVf
aW5pdGNhbGwrMHgxMzEvMHgyNGQKWyAgICA2LjU2MDk3Ml0gIFs8YzJlNmU2YTE+XSA/IHJl
cGFpcl9lbnZfc3RyaW5nKzB4MzIvMHhkMwpbICAgIDYuNTYwOTcyXSAgWzxjMmU2ZTY2Zj5d
ID8gZG9fZWFybHlfcGFyYW0rMHgxMjgvMHgxMjgKWyAgICA2LjU2MDk3Ml0gIFs8YzEwYzg0
Mzk+XSA/IHBhcnNlX2FyZ3MrMHg0MWEvMHg1Y2YKWyAgICA2LjU2MDk3Ml0gIFs8YzJlNmU2
NmY+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4MTI4LzB4MTI4ClsgICAgNi41NjA5NzJdICBbPGMy
ZTZmOGVjPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgyN2IvMHgzZTkKWyAgICA2LjU2MDk3
Ml0gIFs8YzJlNmY4ZWM+XSA/IGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MjdiLzB4M2U5Clsg
ICAgNi41NjA5NzJdICBbPGMyNTc3NjUyPl0ga2VybmVsX2luaXQrMHgxNi8weDFmYQpbICAg
IDYuNTYwOTcyXSAgWzxjMjVhZGQ5Yj5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8w
eDMwClsgICAgNi41NjA5NzJdICBbPGMyNTc3NjNjPl0gPyByZXN0X2luaXQrMHhmMS8weGYx
ClsgICAgNi41NjA5NzJdIENvZGU6IGMwIDUzIDg5IGMzIDBmIDg0IGEwIDAwIDAwIDAwIDgz
IDA1IGY4IDA1IDE1IGMzIDAxIDgzIDE1IGZjIDA1IDE1IGMzIDAwIGI4IDAxIDAwIDAwIDAw
IDgzIDA1IDg4IGY5IDE0IGMzIDAxIDgzIDE1IDhjIGY5IDE0IGMzIDAwIDwwZj4gYzEgNDMg
MWMgODMgMDUgOTAgZjkgMTQgYzMgMDEgODMgMTUgOTQgZjkgMTQgYzMgMDAgNDAgNDggN2YK
WyAgICA2LjU2MDk3Ml0gRUlQOiBbPGMxNDVlMzY4Pl0ga29iamVjdF9nZXQrMHgzZC8weGMx
IFNTOkVTUCAwMDY4OmNlMDY1ZWMwClsgICAgNi41NjA5NzJdIENSMjogMDAwMDAwMDA2YjZi
NmI4ZgpbICAgIDYuNTYwOTcyXSAtLS1bIGVuZCB0cmFjZSAyZGIxZTEyZjViMGI4ZDQxIF0t
LS0KWyAgICA2LjU2MDk3Ml0gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEZhdGFsIGV4
Y2VwdGlvbgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMS0wMTIyL2M5OTBkMTllMzBjZWE5
ZjNkMzlmMDJjODA3ZjA5ZjBiZTJhNWVkNzEvZG1lc2cteW9jdG8tY2Fpcm8tMTA6MjAxNDAx
MjQxNzIwNDk6aTM4Ni1yYW5kY29uZmlnLXIxLTAxMjI6My4xMi4wLTExMjkxLWdjOTkwZDE5
OjEyNwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMS0wMTIyL2M5OTBkMTllMzBjZWE5ZjNk
MzlmMDJjODA3ZjA5ZjBiZTJhNWVkNzEvZG1lc2cteW9jdG8tY2Fpcm8tNjoyMDE0MDEyNDE3
MjA0OTppMzg2LXJhbmRjb25maWctcjEtMDEyMjozLjEyLjAtMTEyOTEtZ2M5OTBkMTk6MTI3
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIxLTAxMjIvYzk5MGQxOWUzMGNlYTlmM2QzOWYw
MmM4MDdmMDlmMGJlMmE1ZWQ3MS9kbWVzZy1xdWFudGFsLWNhaXJvLTEyOjIwMTQwMTI0MTcy
MDU0OmkzODYtcmFuZGNvbmZpZy1yMS0wMTIyOjMuMTIuMC0xMTI5MS1nYzk5MGQxOToxMjcK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjEtMDEyMi9jOTkwZDE5ZTMwY2VhOWYzZDM5ZjAy
YzgwN2YwOWYwYmUyYTVlZDcxL2RtZXNnLXF1YW50YWwtY2Fpcm8tNDQ6MjAxNDAxMjQxNzIw
NTQ6aTM4Ni1yYW5kY29uZmlnLXIxLTAxMjI6My4xMi4wLTExMjkxLWdjOTkwZDE5OjEyNwov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMS0wMTIyL2M5OTBkMTllMzBjZWE5ZjNkMzlmMDJj
ODA3ZjA5ZjBiZTJhNWVkNzEvZG1lc2cteW9jdG8tY2Fpcm8tNDc6MjAxNDAxMjQxNzIwNTY6
aTM4Ni1yYW5kY29uZmlnLXIxLTAxMjI6My4xMi4wLTExMjkxLWdjOTkwZDE5OjEyNwowOjU6
NSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wMS0yNCAxNzoyMToy
NCBSRVBFQVQgQ09VTlQ6IDIwICAjIC9jYy93ZmcvdXNiLWJpc2VjdC8ucmVwZWF0G1swbQoK
Yzk5MGQxOWUzMGNlYTlmM2QzOWYwMmM4MDdmMDlmMGJlMmE1ZWQ3MSBpcyB0aGUgZmlyc3Qg
YmFkIGNvbW1pdApjb21taXQgYzk5MGQxOWUzMGNlYTlmM2QzOWYwMmM4MDdmMDlmMGJlMmE1
ZWQ3MQpBdXRob3I6IEpvaGFubmVzIEJlcmcgPGpvaGFubmVzLmJlcmdAaW50ZWwuY29tPgpE
YXRlOiAgIFdlZCBKYW4gMjIgMTA6MzY6NTkgMjAxNCArMDEwMAoKICAgIG1hYzgwMjExOiBy
ZW1vdmUgbW9kdWxlIGhhbmRsaW5nIGZyb20gcmF0ZSBjb250cm9sIG9wcwogICAgCiAgICBU
aGVyZSdzIG5vdCBhIHNpbmdsZSByYXRlIGNvbnRyb2wgYWxnb3JpdGhtIGFjdHVhbGx5IGlu
CiAgICBhIHNlcGFyYXRlIG1vZHVsZSB3aGVyZSB0aGUgbW9kdWxlIHJlZmNvdW50IHdvdWxk
IGJlCiAgICByZXF1aXJlZC4gU2ltaWxhcmx5LCB0aGVyZSdzIG5vIHNwZWNpZmljIHJhdGUg
Y29udHJvbAogICAgbW9kdWxlLgogICAgCiAgICBUaGVyZWZvcmUsIGFsbCB0aGUgbW9kdWxl
IGhhbmRsaW5nIGNvZGUgaW4gcmF0ZSBjb250cm9sCiAgICBpcyByZWFsbHkganVzdCBkZWFk
IGNvZGUsIHNvIHJlbW92ZSBpdC4KICAgIAogICAgU2lnbmVkLW9mZi1ieTogSm9oYW5uZXMg
QmVyZyA8am9oYW5uZXMuYmVyZ0BpbnRlbC5jb20+Cgo6MDQwMDAwIDA0MDAwMCAwYTNjMmE1
ZDc2YTlkYzczYmIyMzIyYzg0ZGY3OGE1ZjhjMjhhNGY4IDYzMDU5MDNmNGMyNWZjMzIyM2Zj
ZjQ1Y2EwNzA5ODU0MDViZjA2ZjkgTQlkcml2ZXJzCjowNDAwMDAgMDQwMDAwIDNmNDU5YzEw
YTVmNTc2ZjZkZWFkM2RjNjQyMTdkYWY5OWJlZDk0ZmQgYmQzOTdiNjg3YjgwZWE3ZTI2Nzg4
ZDM3NjI4NmEyZDNiZTllYTU4MyBNCWluY2x1ZGUKOjA0MDAwMCAwNDAwMDAgNzJjNDE4YmY0
YmU5YThkOGRmN2FiM2MwNjc3YzY2MjBhOTY4ZWE4NiBjZjAwMzZjZGE0YmFlOTFiMDdlN2Iy
MmY5YmIzZDE0NDJiOWY5NThjIE0JbmV0CmJpc2VjdCBydW4gc3VjY2VzcwpscyAtYSAva2Vy
bmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXIxLTAxMjIvbGludXgt
ZGV2ZWw6ZGV2ZWwtcm9hbS1pMzg2LTIwMTQwMTIyMTgzNzo5OWI3NjdiNDU3ZmVlMzYyYjI1
NzIyOWEzNTZhNzJhZTYwZmVhOTdhOmJpc2VjdC11c2IKCjIwMTQtMDEtMjQtMTc6MjE6Mjcg
OTliNzY3YjQ1N2ZlZTM2MmIyNTcyMjlhMzU2YTcyYWU2MGZlYTk3YSByZXVzZSAva2VybmVs
L2kzODYtcmFuZGNvbmZpZy1yMS0wMTIyLzk5Yjc2N2I0NTdmZWUzNjJiMjU3MjI5YTM1NmE3
MmFlNjBmZWE5N2Evdm1saW51ei0zLjEyLjAtMTEyOTAtZzk5Yjc2N2IKCjIwMTQtMDEtMjQt
MTc6MjE6MjcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMgk5CTEyCTEzCTIxCTIzCTI2CTI5
CTMyCTM0CTM3CTM4CTQwCTQxLgk0Mi4JNDQuCTQ1CTQ2Li4uLi4uLi4uLi4JNDcJNTEuCTUz
Li4uCTU0Li4JNTUJNTcJNTguLi4uLi4uCTYwIFNVQ0NFU1MKCmxzIC1hIC9rZXJuZWwtdGVz
dHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctcjEtMDEyMi9saW51eC1kZXZlbDpk
ZXZlbC1yb2FtLWkzODYtMjAxNDAxMjIxODM3OmFiY2FiNTJjZmJhNTRlMGUzYjE5ZDg4ZWFi
N2U5ZDM0MDU5M2I5ODc6YmlzZWN0LXVzYgogVEVTVCBGQUlMVVJFCls3ODY3NzMuMzIzNzcx
XSBpZWVlODAyMTEgcGh5MDogRmFpbGVkIHRvIHNlbGVjdCByYXRlIGNvbnRyb2wgYWxnb3Jp
dGhtCls3ODY3NzMuMzI2MTMyXSBpZWVlODAyMTEgcGh5MDogRmFpbGVkIHRvIGluaXRpYWxp
emUgcmF0ZSBjb250cm9sIGFsZ29yaXRobQpbNzg2NzczLjMyODIwN10gbWFjODAyMTFfaHdz
aW06IGllZWU4MDIxMV9yZWdpc3Rlcl9odyBmYWlsZWQgKC0yKQpbNzg2NzczLjMzMDE0M10g
QlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBwYWdpbmcgcmVxdWVzdCBhdCA2YjZiNmI4
ZgpbNzg2NzczLjMzMjE2MV0gSVA6IFs8YzE0NjM4ZTE+XSBrb2JqZWN0X2dldCsweDNkLzB4
YzEKWzc4Njc3My4zMzM5MjRdICpwZGUgPSAwMDAwMDAwMCAKWzc4Njc3My4zMzUyNTJdIE9v
cHM6IDAwMDIgWyMxXSAKWzc4Njc3My4zMzY2MzJdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dh
cHBlciBOb3QgdGFpbnRlZCAzLjEzLjAtMDQ3NTgtZ2FiY2FiNTIgIzE1OQpbNzg2NzczLjMz
OTI2MV0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAx
MQpbNzg2NzczLjM0MTEwM10gdGFzazogY2UwNjAwMDAgdGk6IGNlMDY0MDAwIHRhc2sudGk6
IGNlMDY0MDAwCls3ODY3NzMuMzQyODk5XSBFSVA6IDAwNjA6WzxjMTQ2MzhlMT5dIEVGTEFH
UzogMDAwMTAyNDYgQ1BVOiAwCls3ODY3NzMuMzQ0NjYxXSBFSVAgaXMgYXQga29iamVjdF9n
ZXQrMHgzZC8weGMxCls3ODY3NzMuMzQ2MTQwXSBFQVg6IDAwMDAwMDAxIEVCWDogNmI2YjZi
NzMgRUNYOiAwMDAwMDAwMCBFRFg6IGMwMTIyMzYwCls3ODY3NzMuMzQ4MDczXSBFU0k6IGMy
Y2U1NDUwIEVESTogY2UwNjVmMDQgRUJQOiBjZTA2NWVjNCBFU1A6IGNlMDY1ZWMwCls3ODY3
NzMuMzQ5OTkxXSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwMDAgR1M6IDAwZTAgU1M6IDAw
NjgKWzc4Njc3My4zNTE3ODRdIENSMDogODAwNTAwM2IgQ1IyOiA2YjZiNmI4ZiBDUjM6IDAy
ZmEyMDAwIENSNDogMDAwMDA2OTAKWzc4Njc3My4zNTM3MTNdIFN0YWNrOgpbNzg2NzczLjM1
NDgxM10gIDZiNmI2YjZiIGNlMDY1ZWNjIGMxNzY5YTFiIGNlMDY1ZWUwIGMxNzZmYWNkIGMy
Y2U1NDUwIGZmZmZmZmZlIGNlMDY1ZjA0Cls3ODY3NzMuMzU4MzIzXSAgY2UwNjVlZjAgYzE3
NmUwNmQgYzJjZTU0NTAgY2UwNjVmMDQgY2UwNjVmMDggYzE3NzA3ZjQgYzE3NzA3NjYgMDAw
MDAwMDAKWzc4Njc3My4zNjE5MTJdICBjMTc3MDdmNCAwMDAwMDAwMCBjZTA2NWYxMCBjMTc3
MmIyZCBjZTA2NWYyNCBjMmYxNTYyYSBjMmYxNGY4YSAwMDAwMDAwMApbNzg2NzczLjM2NTMy
MV0gQ2FsbCBUcmFjZToKWzc4Njc3My4zNjY1MjFdICBbPGMxNzY5YTFiPl0gZ2V0X2Rldmlj
ZSsweDJiLzB4NDEKWzc4Njc3My4zNjgwMDhdICBbPGMxNzZmYWNkPl0gZHJpdmVyX2RldGFj
aCsweDY5LzB4MTRlCls3ODY3NzMuMzY5NTc1XSAgWzxjMTc2ZTA2ZD5dIGJ1c19yZW1vdmVf
ZHJpdmVyKzB4MTJkLzB4MTcyCls3ODY3NzMuMzcxMTY5XSAgWzxjMTc3MDdmND5dIGRyaXZl
cl91bnJlZ2lzdGVyKzB4N2UvMHg5MQpbNzg2NzczLjM3Mjg1MF0gIFs8YzE3NzA3NjY+XSA/
IGRyaXZlcl9yZW1vdmVfZ3JvdXBzKzB4MTkvMHgyOQpbNzg2NzczLjM3NDQ3OF0gIFs8YzE3
NzA3ZjQ+XSA/IGRyaXZlcl91bnJlZ2lzdGVyKzB4N2UvMHg5MQpbNzg2NzczLjM3NjA4M10g
IFs8YzE3NzJiMmQ+XSBwbGF0Zm9ybV9kcml2ZXJfdW5yZWdpc3RlcisweDE5LzB4MjkKWzc4
Njc3My4zNzc3NzhdICBbPGMyZjE1NjJhPl0gaW5pdF9tYWM4MDIxMV9od3NpbSsweDZhMC8w
eDZiOApbNzg2NzczLjM3OTM4MF0gIFs8YzJmMTRmOGE+XSA/IHA1NHBfZHJpdmVyX2luaXQr
MHgzMi8weDMyCls3ODY3NzMuMzgwOTY4XSAgWzxjMmViNDU2ZT5dIGRvX29uZV9pbml0Y2Fs
bCsweDEzMS8weDI0ZApbNzg2NzczLjM4MjUwN10gIFs8YzJlYjM2YTE+XSA/IHJlcGFpcl9l
bnZfc3RyaW5nKzB4MzIvMHhkMwpbNzg2NzczLjM4NDEwMF0gIFs8YzJlYjM2NmY+XSA/IGRv
X2Vhcmx5X3BhcmFtKzB4MTI4LzB4MTI4Cls3ODY3NzMuMzg1OTA2XSAgWzxjMTBjYTk0YT5d
ID8gcGFyc2VfYXJncysweDQxYS8weDVjZgpbNzg2NzczLjM4NzQ0OV0gIFs8YzJlYjM2NmY+
XSA/IGRvX2Vhcmx5X3BhcmFtKzB4MTI4LzB4MTI4Cls3ODY3NzMuMzg5MDM2XSAgWzxjMmVi
NDkwNT5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MjdiLzB4M2U5Cls3ODY3NzMuMzkwNzA1
XSAgWzxjMmViNDkwNT5dID8ga2VybmVsX2luaXRfZnJlZWFibGUrMHgyN2IvMHgzZTkKWzc4
Njc3My4zOTIzMjJdICBbPGMyNTkwNmMyPl0ga2VybmVsX2luaXQrMHgxNi8weDFmYQpbNzg2
NzczLjM5Mzk2MF0gIFs8YzI1YzcyNWI+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MWIv
MHgzMApbNzg2NzczLjM5NTU3OV0gIFs8YzI1OTA2YWM+XSA/IHJlc3RfaW5pdCsweGYxLzB4
ZjEKWzc4Njc3My4zOTcwNTBdIENvZGU6IGMwIDUzIDg5IGMzIDBmIDg0IGEwIDAwIDAwIDAw
IDgzIDA1IGM4IGQ0IDE5IGMzIDAxIDgzIDE1IGNjIGQ0IDE5IGMzIDAwIGI4IDAxIDAwIDAw
IDAwIDgzIDA1IDE4IGM4IDE5IGMzIDAxIDgzIDE1IDFjIGM4IDE5IGMzIDAwIDwwZj4gYzEg
NDMgMWMgODMgMDUgMjAgYzggMTkgYzMgMDEgODMgMTUgMjQgYzggMTkgYzMgMDAgNDAgNDgg
N2YKWzc4Njc3My40MDc4NjFdIEVJUDogWzxjMTQ2MzhlMT5dIGtvYmplY3RfZ2V0KzB4M2Qv
MHhjMSBTUzpFU1AgMDA2ODpjZTA2NWVjMApbNzg2NzczLjQwOTg4M10gQ1IyOiAwMDAwMDAw
MDZiNmI2YjhmCls3ODY3NzMuNDExMTYxXSAtLS1bIGVuZCB0cmFjZSA5YWY1ODA0YjlhYWFm
YzE4IF0tLS0KWzc4Njc3My40MTI2OTRdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBG
YXRhbCBleGNlcHRpb24KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjEtMDEyMi9hYmNhYjUy
Y2ZiYTU0ZTBlM2IxOWQ4OGVhYjdlOWQzNDA1OTNiOTg3L2RtZXNnLXlvY3RvLWNhaXJvLTM5
OjIwMTQwMTI0MTYyMTI0OmkzODYtcmFuZGNvbmZpZy1yMS0wMTIyOjMuMTMuMC0wNDc1OC1n
YWJjYWI1MjoxNTkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjEtMDEyMi9hYmNhYjUyY2Zi
YTU0ZTBlM2IxOWQ4OGVhYjdlOWQzNDA1OTNiOTg3L2RtZXNnLXF1YW50YWwteHBzLTY6MjAx
NDAxMjQxNjIyMzQ6aTM4Ni1yYW5kY29uZmlnLXIxLTAxMjI6My4xMy4wLTA0NzU4LWdhYmNh
YjUyOjE1OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMS0wMTIyL2FiY2FiNTJjZmJhNTRl
MGUzYjE5ZDg4ZWFiN2U5ZDM0MDU5M2I5ODcvZG1lc2ctcXVhbnRhbC1pbm4tOToyMDE0MDEy
MjE5MDQ0NTppMzg2LXJhbmRjb25maWctcjEtMDEyMjozLjEzLjAtMDQ3NTgtZ2FiY2FiNTI6
MTU5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIxLTAxMjIvYWJjYWI1MmNmYmE1NGUwZTNi
MTlkODhlYWI3ZTlkMzQwNTkzYjk4Ny9kbWVzZy15b2N0by1pbm4tMTQ6MjAxNDAxMjQxNjE4
NTM6aTM4Ni1yYW5kY29uZmlnLXIxLTAxMjI6My4xMy4wLTA0NzU4LWdhYmNhYjUyOjE1OQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMS0wMTIyL2FiY2FiNTJjZmJhNTRlMGUzYjE5ZDg4
ZWFiN2U5ZDM0MDU5M2I5ODcvZG1lc2ctcXVhbnRhbC1pbm4tNDg6MjAxNDAxMjIxOTA0NDU6
aTM4Ni1yYW5kY29uZmlnLXIxLTAxMjI6My4xMy4wLTA0NzU4LWdhYmNhYjUyOjE1OQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1yMS0wMTIyL2FiY2FiNTJjZmJhNTRlMGUzYjE5ZDg4ZWFi
N2U5ZDM0MDU5M2I5ODcvZG1lc2cteW9jdG8tYXRoZW5zLTE2OjIwMTQwMTI0MTYxODUwOmkz
ODYtcmFuZGNvbmZpZy1yMS0wMTIyOjMuMTMuMC0wNDc1OC1nYWJjYWI1MjoxNTkKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctcjEtMDEyMi9hYmNhYjUyY2ZiYTU0ZTBlM2IxOWQ4OGVhYjdl
OWQzNDA1OTNiOTg3L2RtZXNnLXF1YW50YWwtaW5uLTMyOjIwMTQwMTIyMTkwNTM5OmkzODYt
cmFuZGNvbmZpZy1yMS0wMTIyOjMuMTMuMC0wNDc1OC1nYWJjYWI1MjoxNTkKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctcjEtMDEyMi9hYmNhYjUyY2ZiYTU0ZTBlM2IxOWQ4OGVhYjdlOWQz
NDA1OTNiOTg3L2RtZXNnLXlvY3RvLXN0b2FrbGV5LTM6MjAxNDAxMjIxOTA1MzQ6aTM4Ni1y
YW5kY29uZmlnLXIxLTAxMjI6My4xMy4wLTA0NzU4LWdhYmNhYjUyOjE1OQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1yMS0wMTIyL2FiY2FiNTJjZmJhNTRlMGUzYjE5ZDg4ZWFiN2U5ZDM0
MDU5M2I5ODcvZG1lc2cteW9jdG8tY2Fpcm8tMzU6MjAxNDAxMjQxNjE5MTQ6aTM4Ni1yYW5k
Y29uZmlnLXIxLTAxMjI6My4xMy4wLTA0NzU4LWdhYmNhYjUyOjE1OQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1yMS0wMTIyL2FiY2FiNTJjZmJhNTRlMGUzYjE5ZDg4ZWFiN2U5ZDM0MDU5
M2I5ODcvZG1lc2cteW9jdG8tYXRoZW5zLTI5OjIwMTQwMTI0MTYxODUxOmkzODYtcmFuZGNv
bmZpZy1yMS0wMTIyOjMuMTMuMC0wNDc1OC1nYWJjYWI1MjoxNTkKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctcjEtMDEyMi9hYmNhYjUyY2ZiYTU0ZTBlM2IxOWQ4OGVhYjdlOWQzNDA1OTNi
OTg3L2RtZXNnLXF1YW50YWwtc3RvYWtsZXktNzoyMDE0MDEyNDE2MTg0OTppMzg2LXJhbmRj
b25maWctcjEtMDEyMjozLjEzLjAtMDQ3NTgtZ2FiY2FiNTI6MTU5Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLXIxLTAxMjIvYWJjYWI1MmNmYmE1NGUwZTNiMTlkODhlYWI3ZTlkMzQwNTkz
Yjk4Ny9kbWVzZy15b2N0by1pbm4tNDU6MjAxNDAxMjIxOTA1MzQ6aTM4Ni1yYW5kY29uZmln
LXIxLTAxMjI6My4xMy4wLTA0NzU4LWdhYmNhYjUyOjE1OQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1yMS0wMTIyL2FiY2FiNTJjZmJhNTRlMGUzYjE5ZDg4ZWFiN2U5ZDM0MDU5M2I5ODcv
ZG1lc2ctcXVhbnRhbC1zdG9ha2xleS00OjIwMTQwMTIyMTkwNTM0OmkzODYtcmFuZGNvbmZp
Zy1yMS0wMTIyOjMuMTMuMC0wNDc1OC1nYWJjYWI1MjoxNTkKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctcjEtMDEyMi9hYmNhYjUyY2ZiYTU0ZTBlM2IxOWQ4OGVhYjdlOWQzNDA1OTNiOTg3
L2RtZXNnLXF1YW50YWwtaW5uLTI1OjIwMTQwMTI0MTYxODUzOmkzODYtcmFuZGNvbmZpZy1y
MS0wMTIyOjMuMTMuMC0wNDc1OC1nYWJjYWI1MjoxNTkKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctcjEtMDEyMi9hYmNhYjUyY2ZiYTU0ZTBlM2IxOWQ4OGVhYjdlOWQzNDA1OTNiOTg3L2Rt
ZXNnLXF1YW50YWwteGlhbi05OjIwMTQwMTI0MTYyMTAzOmkzODYtcmFuZGNvbmZpZy1yMS0w
MTIyOjMuMTMuMC0wNDc1OC1nYWJjYWI1MjoxNTkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
cjEtMDEyMi9hYmNhYjUyY2ZiYTU0ZTBlM2IxOWQ4OGVhYjdlOWQzNDA1OTNiOTg3L2RtZXNn
LXlvY3RvLXN0b2FrbGV5LTI6MjAxNDAxMjQxNjE4NDg6aTM4Ni1yYW5kY29uZmlnLXIxLTAx
MjI6My4xMy4wLTA0NzU4LWdhYmNhYjUyOjE1OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1y
MS0wMTIyL2FiY2FiNTJjZmJhNTRlMGUzYjE5ZDg4ZWFiN2U5ZDM0MDU5M2I5ODcvZG1lc2ct
eW9jdG8taW5uLTQwOjIwMTQwMTIyMTkwNTM0OmkzODYtcmFuZGNvbmZpZy1yMS0wMTIyOjMu
MTMuMC0wNDc1OC1nYWJjYWI1MjoxNTkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjEtMDEy
Mi9hYmNhYjUyY2ZiYTU0ZTBlM2IxOWQ4OGVhYjdlOWQzNDA1OTNiOTg3L2RtZXNnLXF1YW50
YWwtaW5uLTI6MjAxNDAxMjIxOTA1Mzk6aTM4Ni1yYW5kY29uZmlnLXIxLTAxMjI6My4xMy4w
LTA0NzU4LWdhYmNhYjUyOjE1OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMS0wMTIyL2Fi
Y2FiNTJjZmJhNTRlMGUzYjE5ZDg4ZWFiN2U5ZDM0MDU5M2I5ODcvZG1lc2ctcXVhbnRhbC1p
bm4tNDoyMDE0MDEyMjE5MDUzOTppMzg2LXJhbmRjb25maWctcjEtMDEyMjozLjEzLjAtMDQ3
NTgtZ2FiY2FiNTI6MTU5CjA6MTk6MTkgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCltk
ZXRhY2hlZCBIRUFEIDYzNTg1NjddIFJldmVydCAibWFjODAyMTE6IHJlbW92ZSBtb2R1bGUg
aGFuZGxpbmcgZnJvbSByYXRlIGNvbnRyb2wgb3BzIgogOCBmaWxlcyBjaGFuZ2VkLCAyOSBp
bnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1x
dWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXIxLTAxMjIvbGludXgtZGV2ZWw6ZGV2ZWwtcm9h
bS1pMzg2LTIwMTQwMTIyMTgzNzo2MzU4NTY3Mjc2YzQ1OWYzZWEwNTJmZGVlZTZiMjk3YmMz
MjdlZTgzOmJpc2VjdC11c2IKCjIwMTQtMDEtMjQtMTc6NDk6MDkgNjM1ODU2NzI3NmM0NTlm
M2VhMDUyZmRlZWU2YjI5N2JjMzI3ZWU4MyBjb21waWxpbmcKCjIwMTQtMDEtMjQtMTc6NTQ6
MjEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMy4wLTA0NzU5LWc2MzU4NTY3Li4uLi4uLgk1
CTEyCTEzCTE4CTE5LgkyMAkyMQkyMi4uCTIzCTI0CTMwCTM0CTM1Li4uLi4uLi4uLi4uLgkz
NgkzNy4uLi4uLi4uLi4uCTQxLgk0NAk0Ni4uCTUwCTU0CTU2CTU3Li4JNTgJNjAgU1VDQ0VT
UwoKCj09PT09PT09PSB1cHN0cmVhbSA9PT09PT09PT0KbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yMS0wMTIyL2xpbnV4LWRldmVsOmRldmVs
LXJvYW0taTM4Ni0yMDE0MDEyMjE4Mzc6M2FhY2Q2MjVmMjAxMjlmNWE0MWVhM2ZmM2I1MzUz
YjBlNGRhYmQwMTpiaXNlY3QtdXNiCgoyMDE0LTAxLTI0LTE4OjI1OjU0IDNhYWNkNjI1ZjIw
MTI5ZjVhNDFlYTNmZjNiNTM1M2IwZTRkYWJkMDEgY29tcGlsaW5nCgoyMDE0LTAxLTI0LTE4
OjMwOjUyIGRldGVjdGluZyBib290IHN0YXRlIDMuMTMuMC0wNTYxNy1nM2FhY2Q2Mi4uLi4u
CTEuLgkxMgkxMwkxNAkzMAk1MQk1OS4JNjAgU1VDQ0VTUwoKCj09PT09PT09PSBsaW51eC1u
ZXh0ID09PT09PT09PQpGZXRjaGluZyBuZXh0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctcjEtMDEyMi9saW51eC1kZXZlbDpkZXZlbC1yb2Ft
LWkzODYtMjAxNDAxMjIxODM3OjBkOTJjNGY5ZGJiNjE1MWJiYmE0MWMwNmY4MjlkNDZiNDA2
ZmI4YTI6YmlzZWN0LXVzYgoKMjAxNC0wMS0yNC0xODozOTozOCAwZDkyYzRmOWRiYjYxNTFi
YmJhNDFjMDZmODI5ZDQ2YjQwNmZiOGEyIGNvbXBpbGluZwoKMjAxNC0wMS0yNC0xODo0NTow
OCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEzLjAtbmV4dC0yMDE0MDEyNC0xMTQ0Ny1nMGQ5
MmM0Zi4uCTEJMTEJMTYJMjIJNTAJNTUJNjAgU1VDQ0VTUwoK

--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.13.0-04758-gabcab52"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.13.0 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_COMPILE_TEST=y
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_KERNEL_XZ=y
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_FHANDLE is not set
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_STALL_COMMON is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_HUGETLB is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
# CONFIG_FAIR_GROUP_SCHED is not set
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
# CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR_NONE is not set
CONFIG_CC_STACKPROTECTOR_REGULAR=y
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
CONFIG_GCOV_FORMAT_AUTODETECT=y
# CONFIG_GCOV_FORMAT_3_4 is not set
# CONFIG_GCOV_FORMAT_4_7 is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_LBDAF=y
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_BSGLIB is not set
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
CONFIG_ACORN_PARTITION_EESOX=y
# CONFIG_ACORN_PARTITION_ICS is not set
CONFIG_ACORN_PARTITION_ADFS=y
CONFIG_ACORN_PARTITION_POWERTEC=y
# CONFIG_ACORN_PARTITION_RISCIX is not set
CONFIG_AIX_PARTITION=y
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
# CONFIG_MSDOS_PARTITION is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_CMDLINE_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_ASN1=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_INTEL_LPSS=y
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
CONFIG_M586TSC=y
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=5
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_F00F_BUG=y
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_TSC=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_EARLY=y
CONFIG_MICROCODE_AMD_EARLY=y
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_ZBUD is not set
# CONFIG_HIGHPTE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
CONFIG_SECCOMP=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
# CONFIG_ACPI_BUTTON is not set
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=y
# CONFIG_ACPI_BGRT is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
CONFIG_PCI_GOMMCONFIG=y
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
# CONFIG_OLPC is not set
# CONFIG_ALIX is not set
CONFIG_NET5501=y
# CONFIG_GEOS is not set
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_NETFILTER_XTABLES=y
CONFIG_BRIDGE_NF_EBTABLES=y
# CONFIG_BRIDGE_EBT_BROUTE is not set
CONFIG_BRIDGE_EBT_T_FILTER=y
CONFIG_BRIDGE_EBT_T_NAT=y
CONFIG_BRIDGE_EBT_802_3=y
CONFIG_BRIDGE_EBT_AMONG=y
CONFIG_BRIDGE_EBT_ARP=y
# CONFIG_BRIDGE_EBT_IP is not set
CONFIG_BRIDGE_EBT_LIMIT=y
CONFIG_BRIDGE_EBT_MARK=y
# CONFIG_BRIDGE_EBT_PKTTYPE is not set
# CONFIG_BRIDGE_EBT_STP is not set
CONFIG_BRIDGE_EBT_VLAN=y
# CONFIG_BRIDGE_EBT_DNAT is not set
# CONFIG_BRIDGE_EBT_MARK_T is not set
# CONFIG_BRIDGE_EBT_REDIRECT is not set
CONFIG_BRIDGE_EBT_SNAT=y
# CONFIG_BRIDGE_EBT_LOG is not set
CONFIG_BRIDGE_EBT_ULOG=y
# CONFIG_BRIDGE_EBT_NFLOG is not set
CONFIG_ATM=y
CONFIG_ATM_LANE=y
CONFIG_STP=y
CONFIG_MRP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
CONFIG_ATALK=y
# CONFIG_DEV_APPLETALK is not set
CONFIG_X25=y
# CONFIG_LAPB is not set
CONFIG_PHONET=y
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
# CONFIG_NET_SCH_ATM is not set
CONFIG_NET_SCH_PRIO=y
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
CONFIG_NET_SCH_SFB=y
CONFIG_NET_SCH_SFQ=y
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=y
# CONFIG_NET_SCH_GRED is not set
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_MQPRIO is not set
CONFIG_NET_SCH_CHOKE=y
CONFIG_NET_SCH_QFQ=y
# CONFIG_NET_SCH_CODEL is not set
CONFIG_NET_SCH_FQ_CODEL=y
# CONFIG_NET_SCH_FQ is not set
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
# CONFIG_NET_CLS_TCINDEX is not set
CONFIG_NET_CLS_FW=y
# CONFIG_NET_CLS_U32 is not set
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_CLS_BPF=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
# CONFIG_NET_EMATCH_CMP is not set
# CONFIG_NET_EMATCH_NBYTE is not set
# CONFIG_NET_EMATCH_U32 is not set
CONFIG_NET_EMATCH_META=y
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_EMATCH_CANID=y
# CONFIG_NET_CLS_ACT is not set
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
# CONFIG_DNS_RESOLVER is not set
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_NC is not set
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
CONFIG_VMWARE_VMCI_VSOCKETS=y
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=y
# CONFIG_HSR is not set
CONFIG_NETPRIO_CGROUP=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
CONFIG_AX25_DAMA_SLAVE=y
# CONFIG_NETROM is not set
# CONFIG_ROSE is not set

#
# AX.25 network device drivers
#
CONFIG_MKISS=y
# CONFIG_6PACK is not set
CONFIG_BPQETHER=y
CONFIG_BAYCOM_SER_FDX=y
# CONFIG_BAYCOM_SER_HDX is not set
# CONFIG_YAM is not set
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
CONFIG_CAN_BCM=y
# CONFIG_CAN_GW is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=y
# CONFIG_CAN_CALC_BITTIMING is not set
# CONFIG_CAN_LEDS is not set
CONFIG_CAN_MCP251X=y
CONFIG_PCH_CAN=y
# CONFIG_CAN_SJA1000 is not set
CONFIG_CAN_C_CAN=y
# CONFIG_CAN_C_CAN_PLATFORM is not set
# CONFIG_CAN_C_CAN_PCI is not set
CONFIG_CAN_CC770=y
CONFIG_CAN_CC770_ISA=y
# CONFIG_CAN_CC770_PLATFORM is not set

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=y
# CONFIG_CAN_ESD_USB2 is not set
CONFIG_CAN_KVASER_USB=y
CONFIG_CAN_PEAK_USB=y
# CONFIG_CAN_8DEV_USB is not set
CONFIG_CAN_SOFTING=y
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
CONFIG_BT=y
CONFIG_BT_RFCOMM=y
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=y
# CONFIG_BT_BNEP_MC_FILTER is not set
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
CONFIG_BT_HCIBTSDIO=y
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIBCM203X=y
# CONFIG_BT_HCIBPA10X is not set
CONFIG_BT_HCIBFUSB=y
CONFIG_BT_HCIVHCI=y
# CONFIG_BT_MRVL is not set
CONFIG_BT_ATH3K=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_REG_DEBUG=y
# CONFIG_CFG80211_DEFAULT_PS is not set
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
CONFIG_LIB80211_DEBUG=y
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_MESSAGE_TRACING is not set
CONFIG_MAC80211_DEBUG_MENU=y
# CONFIG_MAC80211_NOINLINE is not set
# CONFIG_MAC80211_VERBOSE_DEBUG is not set
CONFIG_MAC80211_MLME_DEBUG=y
CONFIG_MAC80211_STA_DEBUG=y
# CONFIG_MAC80211_HT_DEBUG is not set
CONFIG_MAC80211_IBSS_DEBUG=y
# CONFIG_MAC80211_PS_DEBUG is not set
CONFIG_MAC80211_MPL_DEBUG=y
# CONFIG_MAC80211_MPATH_DEBUG is not set
CONFIG_MAC80211_MHWMP_DEBUG=y
# CONFIG_MAC80211_MESH_SYNC_DEBUG is not set
CONFIG_MAC80211_MESH_CSA_DEBUG=y
# CONFIG_MAC80211_MESH_PS_DEBUG is not set
CONFIG_MAC80211_TDLS_DEBUG=y
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
CONFIG_RFKILL_REGULATOR=y
# CONFIG_NET_9P is not set
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
CONFIG_CAIF_NETDEV=y
CONFIG_CAIF_USB=y
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_CMA is not set

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
# CONFIG_FTL is not set
CONFIG_NFTL=y
CONFIG_NFTL_RW=y
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
CONFIG_SSFDC=y
CONFIG_SM_FTL=y
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
CONFIG_MTD_CFI_NOSWAP=y
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_GEOMETRY is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
# CONFIG_MTD_OTP is not set
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
# CONFIG_MTD_TS5500 is not set
CONFIG_MTD_SBC_GXX=y
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
CONFIG_MTD_ESB2ROM=y
CONFIG_MTD_CK804XROM=y
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
CONFIG_MTD_PCI=y
# CONFIG_MTD_GPIO_ADDR is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y
CONFIG_MTD_LATCH_ADDR=y

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
CONFIG_MTD_PMC551_BUGFIX=y
# CONFIG_MTD_PMC551_DEBUG is not set
CONFIG_MTD_DATAFLASH=y
CONFIG_MTD_DATAFLASH_WRITE_VERIFY=y
CONFIG_MTD_DATAFLASH_OTP=y
# CONFIG_MTD_M25P80 is not set
CONFIG_MTD_SST25L=y
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
# CONFIG_MTD_NAND is not set
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=y
CONFIG_MTD_ONENAND_OTP=y
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_MTD_UBI_GLUEBI=y
# CONFIG_PARPORT is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_AD525X_DPOT_SPI=y
# CONFIG_ATMEL_PWM is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
CONFIG_INTEL_MID_PTI=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
# CONFIG_ICS932S401 is not set
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
CONFIG_DS1682=y
CONFIG_TI_DAC7512=y
CONFIG_VMWARE_BALLOON=y
CONFIG_BMP085=y
# CONFIG_BMP085_I2C is not set
CONFIG_BMP085_SPI=y
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_LATTICE_ECP3_CONFIG=y
CONFIG_SRAM=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_93XX46=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_VMWARE_VMCI=y

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_BLK_DEV_IDE_SATA=y
# CONFIG_IDE_GD is not set
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
CONFIG_BLK_DEV_CMD640=y
CONFIG_BLK_DEV_CMD640_ENHANCED=y
CONFIG_BLK_DEV_IDEPNP=y
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=y
CONFIG_BLK_DEV_OPTI621=y
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=y
CONFIG_BLK_DEV_ALI15X3=y
CONFIG_BLK_DEV_AMD74XX=y
CONFIG_BLK_DEV_ATIIXP=y
# CONFIG_BLK_DEV_CMD64X is not set
CONFIG_BLK_DEV_TRIFLEX=y
# CONFIG_BLK_DEV_CS5520 is not set
CONFIG_BLK_DEV_CS5530=y
CONFIG_BLK_DEV_CS5535=y
# CONFIG_BLK_DEV_CS5536 is not set
CONFIG_BLK_DEV_HPT366=y
CONFIG_BLK_DEV_JMICRON=y
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=y
CONFIG_BLK_DEV_IT8172=y
CONFIG_BLK_DEV_IT8213=y
# CONFIG_BLK_DEV_IT821X is not set
CONFIG_BLK_DEV_NS87415=y
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
CONFIG_BLK_DEV_PDC202XX_NEW=y
CONFIG_BLK_DEV_SVWKS=y
CONFIG_BLK_DEV_SIIMAGE=y
CONFIG_BLK_DEV_SIS5513=y
CONFIG_BLK_DEV_SLC90E66=y
CONFIG_BLK_DEV_TRM290=y
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_CONFIG=y
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
CONFIG_I2O_BUS=y
# CONFIG_I2O_BLOCK is not set
CONFIG_I2O_PROC=y
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
CONFIG_DUMMY=y
CONFIG_EQUALIZER=y
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
CONFIG_NTB_NETDEV=y
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_VIRTIO_NET is not set
CONFIG_NLMON=y
# CONFIG_ARCNET is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
CONFIG_ATM_LANAI=y
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_FIRESTREAM is not set
CONFIG_ATM_ZATM=y
CONFIG_ATM_ZATM_DEBUG=y
CONFIG_ATM_NICSTAR=y
# CONFIG_ATM_NICSTAR_USE_SUNI is not set
# CONFIG_ATM_NICSTAR_USE_IDT77105 is not set
# CONFIG_ATM_IDT77252 is not set
CONFIG_ATM_AMBASSADOR=y
CONFIG_ATM_AMBASSADOR_DEBUG=y
CONFIG_ATM_HORIZON=y
CONFIG_ATM_HORIZON_DEBUG=y
CONFIG_ATM_IA=y
# CONFIG_ATM_IA_DEBUG is not set
CONFIG_ATM_FORE200E=y
CONFIG_ATM_FORE200E_USE_TASKLET=y
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
# CONFIG_ATM_HE is not set
# CONFIG_ATM_SOLOS is not set

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=y
# CONFIG_CAIF_SPI_SLAVE is not set
CONFIG_CAIF_HSI=y
# CONFIG_CAIF_VIRTIO is not set
# CONFIG_VHOST_NET is not set

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_ETHERNET=y
CONFIG_MDIO=y
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=y
# CONFIG_TYPHOON is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
CONFIG_NET_VENDOR_AMD=y
CONFIG_AMD8111_ETH=y
CONFIG_PCNET32=y
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
CONFIG_ATL1=y
# CONFIG_ATL1E is not set
CONFIG_ATL1C=y
CONFIG_ALX=y
CONFIG_NET_CADENCE=y
CONFIG_ARM_AT91_ETHER=y
CONFIG_MACB=y
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
CONFIG_BNX2=y
# CONFIG_CNIC is not set
CONFIG_TIGON3=y
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
CONFIG_CHELSIO_T4=y
CONFIG_CHELSIO_T4VF=y
# CONFIG_NET_VENDOR_CISCO is not set
# CONFIG_DNET is not set
# CONFIG_NET_VENDOR_DEC is not set
CONFIG_NET_VENDOR_DLINK=y
CONFIG_DL2K=y
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=y
CONFIG_NET_VENDOR_EXAR=y
CONFIG_S2IO=y
CONFIG_VXGE=y
# CONFIG_VXGE_DEBUG_TRACE_ALL is not set
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
CONFIG_IGBVF=y
CONFIG_IXGB=y
# CONFIG_IXGBE is not set
CONFIG_IXGBEVF=y
CONFIG_I40E=y
# CONFIG_NET_VENDOR_I825XX is not set
CONFIG_IP1000=y
CONFIG_JME=y
# CONFIG_NET_VENDOR_MARVELL is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
CONFIG_MLX5_CORE=y
# CONFIG_NET_VENDOR_MICREL is not set
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_ENC28J60 is not set
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
# CONFIG_NET_VENDOR_OKI is not set
CONFIG_ETHOC=y
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
CONFIG_YELLOWFIN=y
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=y
CONFIG_QLCNIC=y
CONFIG_QLCNIC_DCB=y
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_NET_VENDOR_REALTEK is not set
# CONFIG_SH_ETH is not set
# CONFIG_NET_VENDOR_RDC is not set
CONFIG_NET_VENDOR_SEEQ=y
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
# CONFIG_SFC is not set
# CONFIG_NET_VENDOR_SMSC is not set
# CONFIG_NET_VENDOR_STMICRO is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
CONFIG_NIU=y
CONFIG_NET_VENDOR_TEHUTI=y
CONFIG_TEHUTI=y
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
# CONFIG_FDDI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
CONFIG_AMD_PHY=y
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
CONFIG_CICADA_PHY=y
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
# CONFIG_BCM87XX_PHY is not set
CONFIG_ICPLUS_PHY=y
# CONFIG_REALTEK_PHY is not set
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
# CONFIG_MICREL_PHY is not set
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
# CONFIG_MDIO_GPIO is not set
# CONFIG_MICREL_KS8995MA is not set
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=y
CONFIG_PPPOE=y
# CONFIG_PPP_ASYNC is not set
CONFIG_PPP_SYNC_TTY=y
# CONFIG_SLIP is not set
CONFIG_SLHC=y

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
# CONFIG_USB_PEGASUS is not set
CONFIG_USB_RTL8150=y
CONFIG_USB_RTL8152=y
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=y
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=y
# CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
CONFIG_USB_NET_CDC_MBIM=y
CONFIG_USB_NET_DM9601=y
CONFIG_USB_NET_SR9700=y
CONFIG_USB_NET_SMSC75XX=y
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
# CONFIG_USB_NET_NET1080 is not set
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=y
# CONFIG_USB_ALI_M5632 is not set
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
# CONFIG_USB_ARMLINUX is not set
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
# CONFIG_USB_NET_ZAURUS is not set
CONFIG_USB_NET_CX82310_ETH=y
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_NET_QMI_WWAN is not set
CONFIG_USB_NET_INT51X1=y
# CONFIG_USB_CDC_PHONET is not set
# CONFIG_USB_IPHETH is not set
CONFIG_USB_SIERRA_NET=y
# CONFIG_USB_VL600 is not set
CONFIG_WLAN=y
CONFIG_LIBERTAS_THINFIRM=y
CONFIG_LIBERTAS_THINFIRM_DEBUG=y
CONFIG_LIBERTAS_THINFIRM_USB=y
# CONFIG_AIRO is not set
CONFIG_ATMEL=y
CONFIG_PCI_ATMEL=y
CONFIG_AT76C50X_USB=y
CONFIG_PRISM54=y
CONFIG_USB_ZD1201=y
CONFIG_USB_NET_RNDIS_WLAN=y
CONFIG_RTL8180=y
CONFIG_RTL8187=y
CONFIG_RTL8187_LEDS=y
CONFIG_ADM8211=y
CONFIG_MAC80211_HWSIM=y
CONFIG_MWL8K=y
# CONFIG_ATH_CARDS is not set
CONFIG_B43=y
CONFIG_B43_BCMA=y
CONFIG_B43_SSB=y
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
CONFIG_B43_SDIO=y
CONFIG_B43_BCMA_PIO=y
CONFIG_B43_PIO=y
# CONFIG_B43_PHY_N is not set
CONFIG_B43_PHY_LP=y
# CONFIG_B43_PHY_HT is not set
CONFIG_B43_LEDS=y
# CONFIG_B43_DEBUG is not set
CONFIG_B43LEGACY=y
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
CONFIG_B43LEGACY_DEBUG=y
CONFIG_B43LEGACY_DMA=y
# CONFIG_B43LEGACY_DMA_AND_PIO_MODE is not set
CONFIG_B43LEGACY_DMA_MODE=y
# CONFIG_B43LEGACY_PIO_MODE is not set
CONFIG_BRCMUTIL=y
CONFIG_BRCMSMAC=y
CONFIG_BRCMFMAC=y
# CONFIG_BRCMFMAC_SDIO is not set
# CONFIG_BRCMFMAC_USB is not set
CONFIG_BRCM_TRACING=y
# CONFIG_BRCMDBG is not set
CONFIG_HOSTAP=y
# CONFIG_HOSTAP_FIRMWARE is not set
# CONFIG_HOSTAP_PLX is not set
CONFIG_HOSTAP_PCI=y
CONFIG_IPW2100=y
# CONFIG_IPW2100_MONITOR is not set
# CONFIG_IPW2100_DEBUG is not set
# CONFIG_IPW2200 is not set
CONFIG_LIBIPW=y
CONFIG_LIBIPW_DEBUG=y
# CONFIG_IWLWIFI is not set
CONFIG_IWLEGACY=y
# CONFIG_IWL4965 is not set
CONFIG_IWL3945=y

#
# iwl3945 / iwl4965 Debugging Options
#
CONFIG_IWLEGACY_DEBUG=y
# CONFIG_LIBERTAS is not set
# CONFIG_HERMES is not set
CONFIG_P54_COMMON=y
# CONFIG_P54_USB is not set
CONFIG_P54_PCI=y
# CONFIG_P54_SPI is not set
CONFIG_P54_LEDS=y
CONFIG_RT2X00=y
CONFIG_RT2400PCI=y
# CONFIG_RT2500PCI is not set
# CONFIG_RT61PCI is not set
CONFIG_RT2800PCI=y
CONFIG_RT2800PCI_RT33XX=y
CONFIG_RT2800PCI_RT35XX=y
# CONFIG_RT2800PCI_RT53XX is not set
CONFIG_RT2800PCI_RT3290=y
CONFIG_RT2500USB=y
# CONFIG_RT73USB is not set
CONFIG_RT2800USB=y
# CONFIG_RT2800USB_RT33XX is not set
CONFIG_RT2800USB_RT35XX=y
CONFIG_RT2800USB_RT3573=y
# CONFIG_RT2800USB_RT53XX is not set
# CONFIG_RT2800USB_RT55XX is not set
CONFIG_RT2800USB_UNKNOWN=y
CONFIG_RT2800_LIB=y
CONFIG_RT2800_LIB_MMIO=y
CONFIG_RT2X00_LIB_MMIO=y
CONFIG_RT2X00_LIB_PCI=y
CONFIG_RT2X00_LIB_USB=y
CONFIG_RT2X00_LIB=y
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_LEDS=y
# CONFIG_RT2X00_DEBUG is not set
CONFIG_RTL_CARDS=y
CONFIG_RTL8192CE=y
CONFIG_RTL8192SE=y
CONFIG_RTL8192DE=y
# CONFIG_RTL8723AE is not set
CONFIG_RTL8188EE=y
# CONFIG_RTL8192CU is not set
CONFIG_RTLWIFI=y
CONFIG_RTLWIFI_PCI=y
CONFIG_RTLWIFI_DEBUG=y
CONFIG_RTL8192C_COMMON=y
CONFIG_WL_TI=y
# CONFIG_WL1251 is not set
CONFIG_WL12XX=y
CONFIG_WL18XX=y
CONFIG_WLCORE=y
CONFIG_WLCORE_SPI=y
CONFIG_WLCORE_SDIO=y
CONFIG_WILINK_PLATFORM_DATA=y
CONFIG_ZD1211RW=y
CONFIG_ZD1211RW_DEBUG=y
CONFIG_MWIFIEX=y
CONFIG_MWIFIEX_SDIO=y
# CONFIG_MWIFIEX_PCIE is not set
CONFIG_MWIFIEX_USB=y
CONFIG_CW1200=y
CONFIG_CW1200_WLAN_SDIO=y
CONFIG_CW1200_WLAN_SPI=y

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
CONFIG_WAN=y
# CONFIG_HDLC is not set
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
CONFIG_SBNI=y
CONFIG_SBNI_MULTILINE=y
CONFIG_HYPERV_NET=y
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
# CONFIG_ISDN_CAPI is not set
CONFIG_ISDN_DRV_GIGASET=y
CONFIG_GIGASET_DUMMYLL=y
# CONFIG_GIGASET_BASE is not set
CONFIG_GIGASET_M105=y
CONFIG_GIGASET_M101=y
# CONFIG_GIGASET_DEBUG is not set
# CONFIG_MISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5520=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=y
# CONFIG_KEYBOARD_QT2160 is not set
CONFIG_KEYBOARD_LKKBD=y
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
CONFIG_KEYBOARD_MATRIX=y
CONFIG_KEYBOARD_LM8323=y
CONFIG_KEYBOARD_LM8333=y
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
CONFIG_KEYBOARD_MPR121=y
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_SH_KEYSC=y
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_USB=y
# CONFIG_JOYSTICK_IFORCE_232 is not set
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
# CONFIG_JOYSTICK_ZHENHUA is not set
CONFIG_JOYSTICK_AS5011=y
# CONFIG_JOYSTICK_JOYDUMP is not set
CONFIG_JOYSTICK_XPAD=y
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_88PM860X is not set
# CONFIG_TOUCHSCREEN_ADS7846 is not set
CONFIG_TOUCHSCREEN_AD7877=y
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
CONFIG_TOUCHSCREEN_AD7879_SPI=y
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
CONFIG_TOUCHSCREEN_BU21013=y
CONFIG_TOUCHSCREEN_CY8CTMG110=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP_I2C=y
CONFIG_TOUCHSCREEN_CYTTSP_SPI=y
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP4_I2C is not set
CONFIG_TOUCHSCREEN_CYTTSP4_SPI=y
CONFIG_TOUCHSCREEN_DA9052=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=y
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_WACOM_I2C=y
# CONFIG_TOUCHSCREEN_MAX11801 is not set
CONFIG_TOUCHSCREEN_MCS5000=y
CONFIG_TOUCHSCREEN_MMS114=y
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_PIXCIR=y
CONFIG_TOUCHSCREEN_WM831X=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
# CONFIG_TOUCHSCREEN_MC13783 is not set
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_ELO=y
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=y
# CONFIG_TOUCHSCREEN_TSC2005 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_TOUCHSCREEN_W90X900=y
# CONFIG_TOUCHSCREEN_PCAP is not set
CONFIG_TOUCHSCREEN_ST1232=y
CONFIG_TOUCHSCREEN_SUR40=y
CONFIG_TOUCHSCREEN_TPS6507X=y
CONFIG_TOUCHSCREEN_ZFORCE=y
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM860X_ONKEY=y
CONFIG_INPUT_88PM80X_ONKEY=y
CONFIG_INPUT_AD714X=y
CONFIG_INPUT_AD714X_I2C=y
CONFIG_INPUT_AD714X_SPI=y
# CONFIG_INPUT_ARIZONA_HAPTICS is not set
CONFIG_INPUT_BMA150=y
CONFIG_INPUT_PCSPKR=y
CONFIG_INPUT_MAX8925_ONKEY=y
CONFIG_INPUT_MC13783_PWRBUTTON=y
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_MPU3050=y
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_GP2A is not set
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
# CONFIG_INPUT_WISTRON_BTNS is not set
CONFIG_INPUT_ATLAS_BTNS=y
CONFIG_INPUT_ATI_REMOTE2=y
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_POWERMATE=y
# CONFIG_INPUT_YEALINK is not set
CONFIG_INPUT_CM109=y
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
CONFIG_INPUT_DA9052_ONKEY=y
# CONFIG_INPUT_WM831X_ON is not set
CONFIG_INPUT_PCAP=y
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=y
CONFIG_INPUT_ADXL34X_SPI=y
# CONFIG_INPUT_IMS_PCU is not set
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_IDEAPAD_SLIDEBAR=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
# CONFIG_HYPERV_KEYBOARD is not set
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=y
CONFIG_CYCLADES=y
CONFIG_CYZ_INTR=y
CONFIG_MOXA_INTELLIO=y
# CONFIG_MOXA_SMARTIO is not set
CONFIG_SYNCLINK=y
# CONFIG_SYNCLINKMP is not set
CONFIG_SYNCLINK_GT=y
# CONFIG_NOZOMI is not set
CONFIG_ISI=y
# CONFIG_N_HDLC is not set
CONFIG_N_GSM=y
CONFIG_TRACE_ROUTER=y
CONFIG_TRACE_SINK=y
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_CLPS711X is not set
CONFIG_SERIAL_MAX3100=y
CONFIG_SERIAL_MAX310X=y
CONFIG_SERIAL_MRST_MAX3110=y
CONFIG_SERIAL_MFD_HSU=y
CONFIG_SERIAL_MFD_HSU_CONSOLE=y
CONFIG_SERIAL_UARTLITE=y
CONFIG_SERIAL_UARTLITE_CONSOLE=y
# CONFIG_SERIAL_SH_SCI is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
CONFIG_SERIAL_IFX6X60=y
CONFIG_SERIAL_PCH_UART=y
# CONFIG_SERIAL_PCH_UART_CONSOLE is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
# CONFIG_SERIAL_ST_ASC is not set
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y
# CONFIG_SONYPI is not set
CONFIG_MWAVE=y
CONFIG_SCx200_GPIO=y
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=y
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
CONFIG_TCG_TIS_I2C_ATMEL=y
CONFIG_TCG_TIS_I2C_INFINEON=y
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
CONFIG_TCG_INFINEON=y
CONFIG_TCG_ST33_I2C=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=y
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_ISMT=y
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EG20T=y
CONFIG_I2C_GPIO=y
CONFIG_I2C_KEMPLD=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_RIIC is not set
CONFIG_I2C_SH_MOBILE=y
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y
# CONFIG_I2C_RCAR is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set
CONFIG_I2C_VIPERBOARD=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_SCx200_I2C=y
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
CONFIG_SCx200_ACB=y
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_ATMEL=y
CONFIG_SPI_BCM2835=y
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_EP93XX is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_IMX is not set
# CONFIG_SPI_FSL_DSPI is not set
# CONFIG_SPI_OC_TINY is not set
CONFIG_SPI_OMAP24XX=y
CONFIG_SPI_TI_QSPI=y
CONFIG_SPI_OMAP_100K=y
CONFIG_SPI_ORION=y
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=y
CONFIG_SPI_PXA2XX_PCI=y
CONFIG_SPI_SC18IS602=y
CONFIG_SPI_SH=y
CONFIG_SPI_SH_HSPI=y
# CONFIG_SPI_TEGRA114 is not set
CONFIG_SPI_TEGRA20_SFLASH=y
# CONFIG_SPI_TEGRA20_SLINK is not set
CONFIG_SPI_TOPCLIFF_PCH=y
CONFIG_SPI_TXX9=y
# CONFIG_SPI_XCOMM is not set
CONFIG_SPI_XILINX=y
CONFIG_SPI_DESIGNWARE=y
CONFIG_SPI_DW_PCI=y
# CONFIG_SPI_DW_MMIO is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=y

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_PINCTRL=y

#
# Pin controllers
#
# CONFIG_PINMUX is not set
CONFIG_PINCONF=y
# CONFIG_DEBUG_PINCTRL is not set
CONFIG_PINCTRL_BAYTRAIL=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_CLPS711X is not set
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_F7188X=y
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_TS5500 is not set
CONFIG_GPIO_SCH=y
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_MAX7300=y
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_RC5T583 is not set
CONFIG_GPIO_SX150X=y
# CONFIG_GPIO_WM831X is not set
CONFIG_GPIO_ADP5520=y
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_INTEL_MID=y
CONFIG_GPIO_PCH=y
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_TIMBERDALE is not set
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
CONFIG_GPIO_MC33880=y

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
# CONFIG_GPIO_KEMPLD is not set

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_TPS6586X is not set

#
# USB GPIO expanders:
#
CONFIG_GPIO_VIPERBOARD=y
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2490=y
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
# CONFIG_MAX8925_POWER is not set
# CONFIG_WM831X_BACKUP is not set
CONFIG_WM831X_POWER=y
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_88PM860X is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
# CONFIG_BATTERY_DA9052 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_ISP1704=y
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MANAGER=y
# CONFIG_CHARGER_MAX8997 is not set
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_BQ24735=y
CONFIG_CHARGER_SMB347=y
# CONFIG_CHARGER_TPS65090 is not set
CONFIG_BATTERY_GOLDFISH=y
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_DA9052_ADC is not set
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=y
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95234=y
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=y
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SIS5595=y
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_DME1737=y
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_ADS7871=y
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=y
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=y
CONFIG_SENSORS_ATK0110=y
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=y

#
# Texas Instruments thermal drivers
#
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_BLOCKIO=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_BLOCKIO=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_AS3711=y
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
CONFIG_EZX_PCAP=y
CONFIG_MFD_VIPERBOARD=y
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_ARIZONA_SPI=y
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
# CONFIG_MFD_WM8997 is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_88PM800=y
# CONFIG_REGULATOR_88PM8607 is not set
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_ARIZONA=y
CONFIG_REGULATOR_AS3711=y
CONFIG_REGULATOR_DA9052=y
# CONFIG_REGULATOR_DA9063 is not set
CONFIG_REGULATOR_DA9210=y
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
# CONFIG_REGULATOR_LP3972 is not set
# CONFIG_REGULATOR_LP872X is not set
# CONFIG_REGULATOR_LP8755 is not set
CONFIG_REGULATOR_LP8788=y
# CONFIG_REGULATOR_MAX1586 is not set
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8907 is not set
CONFIG_REGULATOR_MAX8925=y
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8997=y
CONFIG_REGULATOR_MC13XXX_CORE=y
# CONFIG_REGULATOR_MC13783 is not set
CONFIG_REGULATOR_MC13892=y
# CONFIG_REGULATOR_PCAP is not set
CONFIG_REGULATOR_PFUZE100=y
# CONFIG_REGULATOR_RC5T583 is not set
# CONFIG_REGULATOR_S2MPS11 is not set
CONFIG_REGULATOR_S5M8767=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=y
CONFIG_REGULATOR_TPS62360=y
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65090=y
CONFIG_REGULATOR_TPS65217=y
# CONFIG_REGULATOR_TPS6524X is not set
CONFIG_REGULATOR_TPS6586X=y
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8400=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_TUNER=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_VMALLOC=y
CONFIG_VIDEO_V4L2_INT_DEVICE=y
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
# CONFIG_MEDIA_USB_SUPPORT is not set
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture/analog TV support
#
CONFIG_VIDEO_ZORAN=y
# CONFIG_VIDEO_ZORAN_DC30 is not set
# CONFIG_VIDEO_ZORAN_ZR36060 is not set
CONFIG_VIDEO_HEXIUM_GEMINI=y
CONFIG_VIDEO_HEXIUM_ORION=y
CONFIG_VIDEO_MXB=y

#
# Media capture/analog/hybrid TV support
#
CONFIG_VIDEO_CX25821=y
CONFIG_VIDEO_CX25821_ALSA=y
# CONFIG_VIDEO_SAA7134 is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_VIDEO_BTCX=y
CONFIG_CYPRESS_FIRMWARE=y
CONFIG_VIDEO_SAA7146=y
CONFIG_VIDEO_SAA7146_VV=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=y
# CONFIG_VIDEO_TDA7432 is not set
CONFIG_VIDEO_TDA9840=y
# CONFIG_VIDEO_TEA6415C is not set
# CONFIG_VIDEO_TEA6420 is not set
# CONFIG_VIDEO_MSP3400 is not set
CONFIG_VIDEO_CS5345=y
CONFIG_VIDEO_CS53L32A=y
# CONFIG_VIDEO_TLV320AIC23B is not set
CONFIG_VIDEO_UDA1342=y
CONFIG_VIDEO_WM8775=y
# CONFIG_VIDEO_WM8739 is not set
CONFIG_VIDEO_VP27SMPX=y
CONFIG_VIDEO_SONY_BTF_MPX=y

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=y

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=y
CONFIG_VIDEO_ADV7183=y
CONFIG_VIDEO_BT819=y
# CONFIG_VIDEO_BT856 is not set
# CONFIG_VIDEO_BT866 is not set
CONFIG_VIDEO_KS0127=y
CONFIG_VIDEO_ML86V7667=y
# CONFIG_VIDEO_SAA7110 is not set
CONFIG_VIDEO_SAA711X=y
CONFIG_VIDEO_SAA7191=y
# CONFIG_VIDEO_TVP514X is not set
# CONFIG_VIDEO_TVP5150 is not set
CONFIG_VIDEO_TVP7002=y
# CONFIG_VIDEO_TW2804 is not set
CONFIG_VIDEO_TW9903=y
# CONFIG_VIDEO_TW9906 is not set
CONFIG_VIDEO_VPX3220=y

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=y
CONFIG_VIDEO_CX25840=y

#
# Video encoders
#
# CONFIG_VIDEO_SAA7127 is not set
CONFIG_VIDEO_SAA7185=y
# CONFIG_VIDEO_ADV7170 is not set
CONFIG_VIDEO_ADV7175=y
CONFIG_VIDEO_ADV7343=y
CONFIG_VIDEO_ADV7393=y
CONFIG_VIDEO_AK881X=y
CONFIG_VIDEO_THS8200=y

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#
# CONFIG_VIDEO_UPD64031A is not set
# CONFIG_VIDEO_UPD64083 is not set

#
# Miscellaneous helper chips
#
# CONFIG_VIDEO_THS7303 is not set
CONFIG_VIDEO_M52790=y

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y

#
# Customize TV tuners
#
# CONFIG_MEDIA_TUNER_SIMPLE is not set
# CONFIG_MEDIA_TUNER_TDA8290 is not set
# CONFIG_MEDIA_TUNER_TDA827X is not set
# CONFIG_MEDIA_TUNER_TDA18271 is not set
# CONFIG_MEDIA_TUNER_TDA9887 is not set
CONFIG_MEDIA_TUNER_TEA5761=y
# CONFIG_MEDIA_TUNER_TEA5767 is not set
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_MT2060=y
CONFIG_MEDIA_TUNER_MT2063=y
CONFIG_MEDIA_TUNER_MT2266=y
# CONFIG_MEDIA_TUNER_MT2131 is not set
CONFIG_MEDIA_TUNER_QT1010=y
CONFIG_MEDIA_TUNER_XC2028=y
# CONFIG_MEDIA_TUNER_XC5000 is not set
# CONFIG_MEDIA_TUNER_XC4000 is not set
CONFIG_MEDIA_TUNER_MXL5005S=y
CONFIG_MEDIA_TUNER_MXL5007T=y
# CONFIG_MEDIA_TUNER_MC44S803 is not set
# CONFIG_MEDIA_TUNER_MAX2165 is not set
# CONFIG_MEDIA_TUNER_TDA18218 is not set
CONFIG_MEDIA_TUNER_FC0011=y
CONFIG_MEDIA_TUNER_FC0012=y
CONFIG_MEDIA_TUNER_FC0013=y
CONFIG_MEDIA_TUNER_TDA18212=y
CONFIG_MEDIA_TUNER_E4000=y
CONFIG_MEDIA_TUNER_FC2580=y
CONFIG_MEDIA_TUNER_TUA9001=y
CONFIG_MEDIA_TUNER_IT913X=y
CONFIG_MEDIA_TUNER_R820T=y

#
# Customise DVB Frontends
#
# CONFIG_DVB_AU8522_V4L is not set
CONFIG_DVB_TUNER_DIB0070=y
# CONFIG_DVB_TUNER_DIB0090 is not set

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=y

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_ALI=y
# CONFIG_AGP_ATI is not set
CONFIG_AGP_AMD=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
CONFIG_AGP_SIS=y
CONFIG_AGP_SWORKS=y
CONFIG_AGP_VIA=y
# CONFIG_AGP_EFFICEON is not set
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
# CONFIG_DRM_I2C_SIL164 is not set
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=y
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I810=y
# CONFIG_DRM_I915 is not set
CONFIG_DRM_MGA=y
CONFIG_DRM_SIS=y
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
CONFIG_DRM_VMWGFX=y
CONFIG_DRM_VMWGFX_FBCON=y
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=y
CONFIG_DRM_MGAG200=y
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_BOCHS is not set
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=y
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
CONFIG_FB_BIG_ENDIAN=y
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=y
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
CONFIG_FB_CYBER2000=y
# CONFIG_FB_CYBER2000_DDC is not set
CONFIG_FB_ARC=y
CONFIG_FB_ASILIANT=y
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
# CONFIG_FB_VESA is not set
# CONFIG_FB_EFI is not set
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
CONFIG_FB_NVIDIA_DEBUG=y
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
CONFIG_FB_RIVA=y
# CONFIG_FB_RIVA_I2C is not set
CONFIG_FB_RIVA_DEBUG=y
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_I740=y
# CONFIG_FB_I810 is not set
CONFIG_FB_LE80578=y
# CONFIG_FB_CARILLO_RANCH is not set
CONFIG_FB_MATROX=y
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=y
# CONFIG_FB_MATROX_MAVEN is not set
CONFIG_FB_RADEON=y
# CONFIG_FB_RADEON_I2C is not set
CONFIG_FB_RADEON_BACKLIGHT=y
CONFIG_FB_RADEON_DEBUG=y
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=y
CONFIG_FB_S3_DDC=y
CONFIG_FB_SAVAGE=y
# CONFIG_FB_SAVAGE_I2C is not set
# CONFIG_FB_SAVAGE_ACCEL is not set
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=y
CONFIG_FB_VIA_DIRECT_PROCFS=y
CONFIG_FB_VIA_X_COMPATIBILITY=y
CONFIG_FB_NEOMAGIC=y
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
CONFIG_FB_VOODOO1=y
# CONFIG_FB_VT8623 is not set
CONFIG_FB_TRIDENT=y
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SM501 is not set
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=y
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
# CONFIG_FB_METRONOME is not set
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
CONFIG_FB_AUO_K1901=y
# CONFIG_FB_HYPERV is not set
# CONFIG_FB_SIMPLE is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_L4F00242T03=y
CONFIG_LCD_LMS283GF05=y
# CONFIG_LCD_LTV350QV is not set
CONFIG_LCD_ILI922X=y
# CONFIG_LCD_ILI9320 is not set
CONFIG_LCD_TDO24M=y
# CONFIG_LCD_VGG2432A4 is not set
# CONFIG_LCD_PLATFORM is not set
# CONFIG_LCD_S6E63M0 is not set
# CONFIG_LCD_LD9040 is not set
CONFIG_LCD_AMS369FG06=y
CONFIG_LCD_LMS501KF03=y
CONFIG_LCD_HX8357=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
# CONFIG_BACKLIGHT_CARILLO_RANCH is not set
CONFIG_BACKLIGHT_PWM=y
CONFIG_BACKLIGHT_DA9052=y
CONFIG_BACKLIGHT_MAX8925=y
CONFIG_BACKLIGHT_APPLE=y
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP5520=y
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_88PM860X=y
CONFIG_BACKLIGHT_LM3630A=y
CONFIG_BACKLIGHT_LM3639=y
# CONFIG_BACKLIGHT_LP855X is not set
CONFIG_BACKLIGHT_LP8788=y
# CONFIG_BACKLIGHT_TPS65217 is not set
CONFIG_BACKLIGHT_AS3711=y
CONFIG_BACKLIGHT_GPIO=y
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
CONFIG_LOGO_LINUX_VGA16=y
# CONFIG_LOGO_LINUX_CLUT224 is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_DMAENGINE_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=y
CONFIG_SND_JACK=y
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_HRTIMER=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
CONFIG_SND_DEBUG=y
CONFIG_SND_DEBUG_VERBOSE=y
CONFIG_SND_PCM_XRUN_DEBUG=y
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=y
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=y
CONFIG_SND_DUMMY=y
CONFIG_SND_ALOOP=y
CONFIG_SND_MTPAV=y
CONFIG_SND_SERIAL_U16550=y
CONFIG_SND_MPU401=y
# CONFIG_SND_PCI is not set
CONFIG_SND_SPI=y
# CONFIG_SND_AT73C213 is not set
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=y
# CONFIG_SND_USB_UA101 is not set
CONFIG_SND_USB_USX2Y=y
# CONFIG_SND_USB_CAIAQ is not set
# CONFIG_SND_USB_US122L is not set
CONFIG_SND_USB_6FIRE=y
CONFIG_SND_USB_HIFACE=y
CONFIG_SND_SOC=y
CONFIG_SND_SOC_GENERIC_DMAENGINE_PCM=y
# CONFIG_SND_SOC_ADI is not set
CONFIG_SND_ATMEL_SOC=y
# CONFIG_SND_BCM2835_SOC_I2S is not set
CONFIG_SND_EP93XX_SOC=y
# CONFIG_SND_DESIGNWARE_I2S is not set
CONFIG_SND_SOC_FSL_SPDIF=y
CONFIG_SND_IMX_SOC=y
CONFIG_SND_SOC_IMX_PCM_DMA=y
CONFIG_SND_SOC_IMX_SPDIF=y
CONFIG_SND_KIRKWOOD_SOC=y
# CONFIG_SND_KIRKWOOD_SOC_OPENRD is not set
CONFIG_SND_KIRKWOOD_SOC_T5325=y
CONFIG_SND_MXS_SOC=y
CONFIG_SND_SOC_MXS_SGTL5000=y
CONFIG_SND_SOC_TEGRA=y
CONFIG_SND_SOC_TEGRA_RT5640=y
CONFIG_SND_SOC_TEGRA_WM8753=y
# CONFIG_SND_SOC_TEGRA_WM8903 is not set
CONFIG_SND_SOC_TEGRA_TRIMSLICE=y
# CONFIG_SND_SOC_TEGRA_ALC5632 is not set
# CONFIG_SND_SOC_TEGRA_MAX98090 is not set
CONFIG_SND_SOC_I2C_AND_SPI=y
# CONFIG_SND_SOC_ALL_CODECS is not set
CONFIG_SND_SOC_ALC5623=y
CONFIG_SND_SOC_RT5640=y
CONFIG_SND_SOC_SGTL5000=y
CONFIG_SND_SOC_TLV320AIC23=y
CONFIG_SND_SOC_WM8753=y
CONFIG_SND_SIMPLE_CARD=y
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
CONFIG_UHID=y
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_PRODIKEYS is not set
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
# CONFIG_LOGITECH_FF is not set
CONFIG_LOGIRUMBLEPAD2_FF=y
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_ORTEK=y
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SPEEDLINK=y
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_HYPERV_MOUSE=y
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=y
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
# CONFIG_USB_HID is not set
# CONFIG_HID_PID is not set

#
# I2C HID support
#
CONFIG_I2C_HID=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=y
# CONFIG_USB_EHCI_HCD is not set
CONFIG_USB_OXU210HP_HCD=y
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=y
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_FUSBH200_HCD is not set
CONFIG_USB_FOTG210_HCD=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
CONFIG_USB_OHCI_HCD_SSB=y
CONFIG_USB_OHCI_HCD_PLATFORM=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=y
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_HCD_ISO is not set
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_RENESAS_USBHS_HCD=y
CONFIG_USB_WHCI_HCD=y
CONFIG_USB_HWA_HCD=y
# CONFIG_USB_HCD_BCMA is not set
CONFIG_USB_HCD_SSB=y
# CONFIG_USB_HCD_TEST_MODE is not set
CONFIG_USB_RENESAS_USBHS=y

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=y
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MUSB_HDRC=y
# CONFIG_USB_MUSB_HOST is not set
# CONFIG_USB_MUSB_GADGET is not set
CONFIG_USB_MUSB_DUAL_ROLE=y
CONFIG_USB_MUSB_TUSB6010=y
# CONFIG_USB_MUSB_UX500 is not set
CONFIG_MUSB_PIO_ONLY=y
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
# CONFIG_USB_SISUSBVGA is not set
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
CONFIG_USB_EHSET_TEST_FIXTURE=y
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y
CONFIG_USB_EZUSB_FX2=y
# CONFIG_USB_HSIC_USB3503 is not set
CONFIG_USB_ATM=y
# CONFIG_USB_SPEEDTOUCH is not set
# CONFIG_USB_CXACRU is not set
# CONFIG_USB_UEAGLEATM is not set
# CONFIG_USB_XUSBATM is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
# CONFIG_USB_OTG_FSM is not set
# CONFIG_KEYSTONE_USB_PHY is not set
CONFIG_NOP_USB_XCEIV=y
CONFIG_OMAP_CONTROL_USB=y
CONFIG_OMAP_USB3=y
CONFIG_AM335X_CONTROL_USB=y
CONFIG_AM335X_PHY_USB=y
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_USB_GPIO_VBUS=y
CONFIG_USB_ISP1301=y
CONFIG_USB_RCAR_PHY=y
CONFIG_USB_RCAR_GEN2_PHY=y
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
CONFIG_USB_GADGET_DEBUG_FILES=y
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
# CONFIG_USB_FUSB300 is not set
CONFIG_USB_FOTG210_UDC=y
# CONFIG_USB_GR_UDC is not set
# CONFIG_USB_R8A66597 is not set
CONFIG_USB_RENESAS_USBHS_UDC=y
CONFIG_USB_PXA27X=y
CONFIG_USB_MV_UDC=y
CONFIG_USB_MV_U3D=y
CONFIG_USB_M66592=y
# CONFIG_USB_AMD5536UDC is not set
CONFIG_USB_NET2272=y
CONFIG_USB_NET2272_DMA=y
# CONFIG_USB_NET2280 is not set
CONFIG_USB_GOKU=y
# CONFIG_USB_EG20T is not set
CONFIG_USB_DUMMY_HCD=y
CONFIG_USB_LIBCOMPOSITE=y
# CONFIG_USB_CONFIGFS is not set
# CONFIG_USB_ZERO is not set
# CONFIG_USB_AUDIO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_MASS_STORAGE is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_MIDI_GADGET is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_NOKIA is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
CONFIG_USB_G_WEBCAM=y
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
CONFIG_UWB_I1480U=y
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_ACPI=y
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_SDHCI_PXAV3=y
# CONFIG_MMC_SDHCI_PXAV2 is not set
CONFIG_MMC_OMAP_HS=y
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_CB710 is not set
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MMC_VUB300=y
CONFIG_MMC_USHC=y
CONFIG_MMC_REALTEK_PCI=y
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3533=y
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_NET48XX=y
CONFIG_LEDS_WRAP=y
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_LP8788=y
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_PCA9685=y
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_DAC124S085=y
# CONFIG_LEDS_PWM is not set
CONFIG_LEDS_REGULATOR=y
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=y
# CONFIG_LEDS_LT3593 is not set
# CONFIG_LEDS_ADP5520 is not set
CONFIG_LEDS_DELL_NETBOOKS=y
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_MAX8997=y
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
# CONFIG_LEDS_TRIGGER_CAMERA is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_MTHCA=y
CONFIG_INFINIBAND_MTHCA_DEBUG=y
# CONFIG_MLX4_INFINIBAND is not set
CONFIG_MLX5_INFINIBAND=y
CONFIG_INFINIBAND_OCRDMA=y
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_SYSTOHC is not set
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
# CONFIG_RTC_INTF_PROC is not set
# CONFIG_RTC_INTF_DEV is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM860X=y
CONFIG_RTC_DRV_88PM80X=y
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1672=y
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_LP8788=y
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8907=y
# CONFIG_RTC_DRV_MAX8925 is not set
CONFIG_RTC_DRV_MAX8997=y
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=y
# CONFIG_RTC_DRV_X1205 is not set
CONFIG_RTC_DRV_PCF2127=y
CONFIG_RTC_DRV_PCF8523=y
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=y
# CONFIG_RTC_DRV_M41T80_WDT is not set
CONFIG_RTC_DRV_BQ32K=y
CONFIG_RTC_DRV_TPS6586X=y
# CONFIG_RTC_DRV_RC5T583 is not set
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=y
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
CONFIG_RTC_DRV_EM3027=y
# CONFIG_RTC_DRV_RV3029C2 is not set
# CONFIG_RTC_DRV_S5M is not set

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
CONFIG_RTC_DRV_M41T94=y
CONFIG_RTC_DRV_DS1305=y
CONFIG_RTC_DRV_DS1390=y
CONFIG_RTC_DRV_MAX6902=y
CONFIG_RTC_DRV_R9701=y
# CONFIG_RTC_DRV_RS5C348 is not set
CONFIG_RTC_DRV_DS3234=y
CONFIG_RTC_DRV_PCF2123=y
CONFIG_RTC_DRV_RX4581=y

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=y
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_DA9052=y
CONFIG_RTC_DRV_STK17TA8=y
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_DS2404=y
# CONFIG_RTC_DRV_WM831X is not set

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_PCAP=y
CONFIG_RTC_DRV_MC13XXX=y
# CONFIG_RTC_DRV_MOXART is not set

#
# HID Sensor RTC drivers
#
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
CONFIG_UIO_CIF=y
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
CONFIG_UIO_SERCOS3=y
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
CONFIG_UIO_MF624=y
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=y
# CONFIG_HYPERV_UTILS is not set
# CONFIG_HYPERV_BALLOON is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=y
CONFIG_ACERHDF=y
# CONFIG_ASUS_LAPTOP is not set
CONFIG_DELL_LAPTOP=y
CONFIG_DELL_WMI=y
CONFIG_DELL_WMI_AIO=y
CONFIG_FUJITSU_LAPTOP=y
CONFIG_FUJITSU_LAPTOP_DEBUG=y
CONFIG_FUJITSU_TABLET=y
# CONFIG_TC1100_WMI is not set
CONFIG_HP_ACCEL=y
CONFIG_HP_WMI=y
CONFIG_PANASONIC_LAPTOP=y
CONFIG_THINKPAD_ACPI=y
# CONFIG_THINKPAD_ACPI_ALSA_SUPPORT is not set
CONFIG_THINKPAD_ACPI_DEBUGFACILITIES=y
CONFIG_THINKPAD_ACPI_DEBUG=y
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
# CONFIG_THINKPAD_ACPI_VIDEO is not set
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_SENSORS_HDAPS=y
CONFIG_INTEL_MENLOW=y
CONFIG_ACPI_WMI=y
CONFIG_MSI_WMI=y
CONFIG_TOPSTAR_LAPTOP=y
CONFIG_ACPI_TOSHIBA=y
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
CONFIG_INTEL_IPS=y
# CONFIG_IBM_RTL is not set
CONFIG_XO15_EBOOK=y
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=y
CONFIG_SAMSUNG_Q10=y
# CONFIG_APPLE_GMUX is not set
CONFIG_INTEL_RST=y
CONFIG_INTEL_SMARTCONNECT=y
CONFIG_PVPANIC=y
CONFIG_CHROME_PLATFORMS=y
# CONFIG_CHROMEOS_LAPTOP is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
CONFIG_COMMON_CLK_DEBUG=y
CONFIG_COMMON_CLK_WM831X=y
CONFIG_COMMON_CLK_SI5351=y
CONFIG_COMMON_CLK_S2MPS11=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
# CONFIG_EXTCON_MAX8997 is not set
CONFIG_EXTCON_ARIZONA=y
CONFIG_MEMORY=y
# CONFIG_IIO is not set
CONFIG_NTB=y
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
CONFIG_SERIAL_IPOCTAL=y
CONFIG_RESET_CONTROLLER=y
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set
# CONFIG_BCM_KONA_USB2_PHY is not set
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
# CONFIG_DMIID is not set
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
CONFIG_GOOGLE_SMI=y
CONFIG_GOOGLE_MEMCONSOLE=y

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
# CONFIG_EXT3_FS_SECURITY is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_EXT4_DEBUG=y
CONFIG_FS_XIP=y
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=y
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
# CONFIG_QUOTA is not set
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_DMA_API_DEBUG=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_EARLY_PRINTK_EFI is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
# CONFIG_BIG_KEYS is not set
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
# CONFIG_SECURITY_APPARMOR_HASH is not set
# CONFIG_SECURITY_YAMA is not set
# CONFIG_IMA is not set
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_APPARMOR=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="apparmor"
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_CRC32=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
# CONFIG_CRYPTO_MD5 is not set
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=y
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
# CONFIG_KVM_INTEL is not set
# CONFIG_KVM_AMD is not set
# CONFIG_LGUEST is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_RATIONAL=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_AUDIT_GENERIC=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y

--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--HcAYCG3uE/tztfnV--
