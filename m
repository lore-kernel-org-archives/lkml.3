Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab3JJJCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 05:02:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:49659 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab3JJJC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 05:02:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1070,1371106800"; 
   d="log'?scan'208";a="408736164"
Date: Thu, 10 Oct 2013 17:02:17 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: initcall calibrate_xor_blocks returned with preemption imbalance
Message-ID: <20131010090217.GB2541@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit 20545536cd8ea949c61527b6395ec8c0d2c237b1
Author: Boaz Harrosh <bharrosh@panasas.com>
Date:   Thu Jul 19 15:22:37 2012 +0300

    RFC: do_xor_speed Broken on UML do to jiffies
    
    Remember that hang I reported a while back on UML. Well
    I'm at it again, and it still hangs and I found why.
    
    I have dprinted jiffies and it never advances during the
    loop at do_xor_speed. There for it is stuck in an endless
    loop. I have also dprinted current_kernel_time() and it
    returns the same constant value as well.
    
    Note that it does usually work on UML, only during
    the modprobe of xor.ko while that test is running. It looks
    like some lucking is preventing the clock from ticking.
    
    However ktime_get_ts does work for me so I changed the code
    as below, so I can work. See how I put several safety
    guards, to never get hangs again.
    And I think my time based approach is more accurate then
    previous system.
    
    UML guys please investigate the jiffies issue? what is
    xor.ko not doing right?
    
    Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

[    0.232004]    generic_sse:  6816.333 MB/sec
[    0.233534] xor: using function: prefetch64-sse (9178.666 MB/sec)
[    0.235445] ------------[ cut here ]------------
[    0.236010] WARNING: CPU: 0 PID: 1 at init/main.c:701 do_one_initcall+0x128/0x138()
[    0.240041] initcall calibrate_xor_blocks+0x0/0x144 returned with preemption imbalance 
[    0.242872] Modules linked in:
[    0.244006] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-rc4-wl-02197-g3d5587e #119
[    0.246837] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.248004]  0000000000000000 ffff88000e1e5e00 ffffffff81a3a6bf ffff88000e1e5e48
[    0.252003]  ffff88000e1e5e38 ffffffff810c53d5 ffffffff81000315 ffffffff8256ff16
[    0.255243]  0000000000000000 0000000000000000 ffff88000e1e5fd8 ffff88000e1e5e98
[    0.258537] Call Trace:
[    0.260010]  [<ffffffff81a3a6bf>] dump_stack+0x54/0x74
[    0.261730]  [<ffffffff810c53d5>] warn_slowpath_common+0x7f/0x98
[    0.263623]  [<ffffffff81000315>] ? do_one_initcall+0x128/0x138
[    0.264006]  [<ffffffff8256ff16>] ? do_xor_speed+0xe2/0xe2
[    0.265785]  [<ffffffff810c543a>] warn_slowpath_fmt+0x4c/0x4e
[    0.268007]  [<ffffffff811767d9>] ? free_pages+0x45/0x47
[    0.269751]  [<ffffffff8256ff16>] ? do_xor_speed+0xe2/0xe2
[    0.272006]  [<ffffffff81000315>] do_one_initcall+0x128/0x138
[    0.273843]  [<ffffffff82532ed3>] kernel_init_freeable+0x159/0x1da
[    0.276005]  [<ffffffff8253274d>] ? do_early_param+0x88/0x88
[    0.277835]  [<ffffffff81a2a057>] ? rest_init+0xdb/0xdb
[    0.280006]  [<ffffffff81a2a065>] kernel_init+0xe/0xdb
[    0.281718]  [<ffffffff81a4d97c>] ret_from_fork+0x7c/0xb0
[    0.283485]  [<ffffffff81a2a057>] ? rest_init+0xdb/0xdb
[    0.284021] ---[ end trace 3592511960ba24aa ]---
[    0.285636] atomic64 test passed for x86-64 platform with CX8 and with SSE

git bisect start 3d5587ec7222eebd6d2fa2d4b245ef837a8f36fa 15c03dd4859ab16f9212238f29dd315654aa94f6 --
git bisect good bd1bc39506ad6ce236bf932757d6e3a81b3e3d55  # 09:41     20+      0  Merge 'regmap/topic/core' into devel-hourly-2013101007
git bisect good f0a6d5852cc8b4e9e518c0426580f0589327e438  # 10:56     20+      0  Merge 'arm-soc/next/dt' into devel-hourly-2013101007
git bisect good 909dc6fa1f1f42dcdae62b07c4d6b894a392e0d7  # 11:36     20+      0  Merge 'ipsec-next/testing' into devel-hourly-2013101007
git bisect good 7fb1b0615235b3975def59fbffd0f52c71736bd3  # 11:57     20+      1  Merge 'arm-soc/next/drivers' into devel-hourly-2013101007
git bisect good ac5fb9846698e9dffc430ab38c1aaefe50a51980  # 12:22     20+      0  Merge remote-tracking branch 'regulator/topic/optional' into regulator-next
git bisect good b9729e9f8d82724c98f13dd358c7b08a4d7de3d2  # 13:31     20+      3  mtd: nand: pxa3xx_nand: Remove redundant of_match_ptr
git bisect  bad c420082bfcc00a908360edd4bb5826ece1c59ae4  # 14:13      0-     20  Merge 'open-osd/exofs_ioctl' into devel-hourly-2013101007
git bisect good 3f8985b977fbab1bf7ddea03bf311949ebca4afd  # 15:03     20+      0  Merge remote-tracking branch 'regulator/topic/tps6586x' into regulator-next
git bisect  bad 7425910fffb08f541e4d2819c4ae7900894fc504  # 15:41      0-      1  {OUT-OF-TREE-DEBUG}: Remove the cdb_offset check because of osc-osd bug
git bisect  bad 71e6bb4b77c4782642b3cb6b4f9369191e08b934  # 15:48      0-      1  pnfs_osd_xdr_srv (private): Add pnfs-objects server side XDR encoding/decoding
git bisect  bad 20545536cd8ea949c61527b6395ec8c0d2c237b1  # 16:03      0-     16  RFC: do_xor_speed Broken on UML do to jiffies
git bisect good 4a9a4b3528afce48d3f4b1c07b988040e78112e2  # 16:22     20+      0  pnfs: Proper delay for NFS4ERR_RECALLCONFLICT in layout_get_done
git bisect good 4a9a4b3528afce48d3f4b1c07b988040e78112e2  # 16:36     60+      0  pnfs: Proper delay for NFS4ERR_RECALLCONFLICT in layout_get_done
git bisect  bad 3d5587ec7222eebd6d2fa2d4b245ef837a8f36fa  # 16:36      0-     19  Merge 'tip/x86/bsp-hotplug' into devel-hourly-2013101007
git bisect good 0e7a3ed04f0cd4311096d691888f88569310ee6c  # 16:57     63+      0  Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good a0cf1abc25ac197dd97b857c0f6341066a8cb1cf  # 16:57     63+      0  Add linux-next specific files for 20130927

Thanks,
Fengguang

--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-bens-4:20131010080156:x86_64-lkp-CONFIG_SCHED_DEBUG:3.12.0-rc4-wl-02197-g3d5587e:119"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-rc4-wl-02197-g3d5587e (kbuild@inn) (gcc=
 version 4.8.1 (Debian 4.8.1-8) ) #119 SMP Thu Oct 10 07:57:44 CST 2013
[    0.000000] Command line: hung_task_panic=3D1 rcutree.rcu_cpu_stall_time=
out=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug d=
ynamic_printk sysrq_always_enabled panic=3D10 load_ramdisk=3D2 prompt_ramdi=
sk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal ip=3D::::quantal-=
bens-4::dhcp nfsroot=3D192.168.1.1:/nfsroot/wfg,tcp,v3,nocto,actimeo=3D600,=
nolock,rsize=3D524288,wsize=3D524288 rw link=3D/kernel-tests/run-queue/kvm/=
x86_64-lkp-CONFIG_SCHED_DEBUG/devel-hourly-2013101007/.vmlinuz-3d5587ec7222=
eebd6d2fa2d4b245ef837a8f36fa-20131010075902-7-bens branch=3Dlinux-devel/dev=
el-hourly-2013101007 BOOT_IMAGE=3D/kernel/x86_64-lkp-CONFIG_SCHED_DEBUG/3d5=
587ec7222eebd6d2fa2d4b245ef837a8f36fa/vmlinuz-3.12.0-rc4-wl-02197-g3d5587e
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
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at =
[ffff8800000fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02fe3000, 0x02fe3fff] PGTABLE
[    0.000000] BRK [0x02fe4000, 0x02fe4fff] PGTABLE
[    0.000000] BRK [0x02fe5000, 0x02fe5fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fdfffff]
[    0.000000]  [mem 0x0fc00000-0x0fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0fbfffff]
[    0.000000]  [mem 0x0c000000-0x0fbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0fe00000-0x0fffdfff]
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x02fe6000, 0x02fe6fff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 1044624(99%)
[    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 00034 (v01 BOCHS  BXPCRSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000=
001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 011A9 (v01   BXPC   BXDSDT 00000=
001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 00080 (v01 BOCHS  BXPCAPIC 00000=
001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 00038 (v01 BOCHS  BXPCHPET 00000=
001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f7000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0f7f9000-0x0f7fdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:f7f5001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000ea0000=
0-ffff88000edfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 960 pages used for memmap
[    0.000000]   DMA32 zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f7000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f6000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:2 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff88000e600000 s1920832 r8=
192 d20672 u2097152
[    0.000000] pcpu-alloc: s1920832 r8192 d20672 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:f7f5001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr e60d200
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 64391
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10 load_ramdisk=3D2 promp=
t_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal ip=3D::::q=
uantal-bens-4::dhcp nfsroot=3D192.168.1.1:/nfsroot/wfg,tcp,v3,nocto,actimeo=
=3D600,nolock,rsize=3D524288,wsize=3D524288 rw link=3D/kernel-tests/run-que=
ue/kvm/x86_64-lkp-CONFIG_SCHED_DEBUG/devel-hourly-2013101007/.vmlinuz-3d558=
7ec7222eebd6d2fa2d4b245ef837a8f36fa-20131010075902-7-bens branch=3Dlinux-de=
vel/devel-hourly-2013101007 BOOT_IMAGE=3D/kernel/x86_64-lkp-CONFIG_SCHED_DE=
BUG/3d5587ec7222eebd6d2fa2d4b245ef837a8f36fa/vmlinuz-3.12.0-rc4-wl-02197-g3=
d5587e
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 212116K/261744K available (10571K kernel code, 1389K=
 rwdata, 5356K rodata, 3192K init, 9584K bss, 49628K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000] NR_IRQS:16640 nr_irqs:512 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6335 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] allocated 1048576 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2666.772 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. lpj=3D106670=
88
[    0.008929] pid_max: default: 32768 minimum: 301
[    0.010729] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.012427] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.016169] Mount-cache hash table entries: 256
[    0.018880] Initializing cgroup subsys memory
[    0.020092] Initializing cgroup subsys blkio
[    0.021659] Initializing cgroup subsys perf_event
[    0.023320] Initializing cgroup subsys hugetlb
[    0.024169] mce: CPU supports 10 MCE banks
[    0.025774] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.025774] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.025774] tlb_flushall_shift: 6
[    0.032130] Freeing SMP alternatives memory: 40K (ffffffff8267b000 - fff=
fffff82685000)
[    0.042967] ACPI: Core revision 20130725
[    0.046306] ACPI: All ACPI Tables successfully acquired
[    0.048749] ftrace: allocating 39655 entries in 155 pages
[    0.060475] Getting VERSION: 50014
[    0.061918] Getting VERSION: 50014
[    0.063301] Getting ID: 0
[    0.064023] Getting ID: ff000000
[    0.065390] Getting LVT0: 8700
[    0.066698] Getting LVT1: 8400
[    0.068249] enabled ExtINT on CPU#0
[    0.072042] ENABLING IO-APIC IRQs
[    0.073420] init IO_APIC IRQs
[    0.074700]  apic 0 pin 0 not connected
[    0.076021] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.078905] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.080032] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.084029] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.086865] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.088028] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.092028] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.096028] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.098875] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.100028] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.104028] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.108029] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.110909] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.112029] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.116029] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.118914]  apic 0 pin 16 not connected
[    0.120004]  apic 0 pin 17 not connected
[    0.121477]  apic 0 pin 18 not connected
[    0.124004]  apic 0 pin 19 not connected
[    0.125475]  apic 0 pin 20 not connected
[    0.126943]  apic 0 pin 21 not connected
[    0.128004]  apic 0 pin 22 not connected
[    0.129478]  apic 0 pin 23 not connected
[    0.131098] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.132004] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.137564] Using local APIC timer interrupts.
[    0.137564] calibrating APIC timer ...
[    0.144000] ... lapic delta =3D 6249989
[    0.144000] ... PM-Timer delta =3D 357971
[    0.144000] ... PM-Timer result ok
[    0.144000] ..... delta 6249989
[    0.144000] ..... mult: 268434983
[    0.144000] ..... calibration result: 3999992
[    0.144000] ..... CPU clock speed is 2666.2599 MHz.
[    0.144000] ..... host bus clock speed is 999.3992 MHz.
[    0.144134] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.151772] smpboot: Booting Node   0, Processors  #   1 OK
[    0.008000] kvm-clock: cpu 1, msr 0:f7f5041, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.172102] Brought up 2 CPUs
[    0.172064] KVM setup async PF for cpu 1
[    0.172064] kvm-stealtime: cpu 1, msr e80d200
[    0.176005] smpboot: Total of 2 processors activated (10667.08 BogoMIPS)
[    0.182945] CPU0 attaching sched-domain:
[    0.184035]  domain 0: span 0-1 level CPU
[    0.185655]   groups: 0 1
[    0.188721] CPU1 attaching sched-domain:
[    0.190175]  domain 0: span 0-1 level CPU
[    0.191789]   groups: 1 0
[    0.193250] devtmpfs: initialized
[    0.206454] xor: measuring software checksum speed
[    0.220004]    prefetch64-sse:  9178.666 MB/sec
[    0.232004]    generic_sse:  6816.333 MB/sec
[    0.233534] xor: using function: prefetch64-sse (9178.666 MB/sec)
[    0.235445] ------------[ cut here ]------------
[    0.236010] WARNING: CPU: 0 PID: 1 at init/main.c:701 do_one_initcall+0x=
128/0x138()
[    0.240041] initcall calibrate_xor_blocks+0x0/0x144 returned with preemp=
tion imbalance=20
[    0.242872] Modules linked in:
[    0.244006] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-rc4-wl-0219=
7-g3d5587e #119
[    0.246837] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.248004]  0000000000000000 ffff88000e1e5e00 ffffffff81a3a6bf ffff8800=
0e1e5e48
[    0.252003]  ffff88000e1e5e38 ffffffff810c53d5 ffffffff81000315 ffffffff=
8256ff16
[    0.255243]  0000000000000000 0000000000000000 ffff88000e1e5fd8 ffff8800=
0e1e5e98
[    0.258537] Call Trace:
[    0.260010]  [<ffffffff81a3a6bf>] dump_stack+0x54/0x74
[    0.261730]  [<ffffffff810c53d5>] warn_slowpath_common+0x7f/0x98
[    0.263623]  [<ffffffff81000315>] ? do_one_initcall+0x128/0x138
[    0.264006]  [<ffffffff8256ff16>] ? do_xor_speed+0xe2/0xe2
[    0.265785]  [<ffffffff810c543a>] warn_slowpath_fmt+0x4c/0x4e
[    0.268007]  [<ffffffff811767d9>] ? free_pages+0x45/0x47
[    0.269751]  [<ffffffff8256ff16>] ? do_xor_speed+0xe2/0xe2
[    0.272006]  [<ffffffff81000315>] do_one_initcall+0x128/0x138
[    0.273843]  [<ffffffff82532ed3>] kernel_init_freeable+0x159/0x1da
[    0.276005]  [<ffffffff8253274d>] ? do_early_param+0x88/0x88
[    0.277835]  [<ffffffff81a2a057>] ? rest_init+0xdb/0xdb
[    0.280006]  [<ffffffff81a2a065>] kernel_init+0xe/0xdb
[    0.281718]  [<ffffffff81a4d97c>] ret_from_fork+0x7c/0xb0
[    0.283485]  [<ffffffff81a2a057>] ? rest_init+0xdb/0xdb
[    0.284021] ---[ end trace 3592511960ba24aa ]---
[    0.285636] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.288160] NET: Registered protocol family 16
[    0.292234] cpuidle: using governor ladder
[    0.293550] cpuidle: using governor menu
[    0.296727] ACPI: bus type PCI registered
[    0.298209] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.300262] PCI: Using configuration type 1 for base access
[    0.360314] bio: create slab <bio-0> at 0
[    0.432013] raid6: sse2x1    3443 MB/s
[    0.500009] raid6: sse2x2    6634 MB/s
[    0.568009] raid6: sse2x4    7070 MB/s
[    0.569438] raid6: using algorithm sse2x4 (7070 MB/s)
[    0.571135] raid6: using intx1 recovery algorithm
[    0.572075] ACPI: Added _OSI(Module Device)
[    0.573586] ACPI: Added _OSI(Processor Device)
[    0.575155] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.576005] ACPI: Added _OSI(Processor Aggregator Device)
[    0.582075] ACPI: EC: Look up EC in DSDT
[    0.589211] ACPI: Interpreter enabled
[    0.590628] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20130725/hwxface-571)
[    0.596006] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20130725/hwxface-571)
[    0.604044] ACPI: (supports S0 S3 S4 S5)
[    0.605506] ACPI: Using IOAPIC for interrupt routing
[    0.608038] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.609385] ACPI: No dock devices found.
[    0.628538] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.629982] acpi PNP0A03:00: ACPI _OSC support notification failed, disa=
bling PCIe ASPM
[    0.632006] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.635135] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.642031] acpiphp: Slot [3] registered
[    0.642031] acpiphp: Slot [4] registered
[    0.645656] acpiphp: Slot [5] registered
[    0.645656] acpiphp: Slot [6] registered
[    0.648949] acpiphp: Slot [7] registered
[    0.649628] acpiphp: Slot [8] registered
[    0.652204] acpiphp: Slot [9] registered
[    0.653630] acpiphp: Slot [10] registered
[    0.653630] acpiphp: Slot [11] registered
[    0.657160] acpiphp: Slot [12] registered
[    0.657672] acpiphp: Slot [13] registered
[    0.660469] acpiphp: Slot [14] registered
[    0.661668] acpiphp: Slot [15] registered
[    0.661672] acpiphp: Slot [16] registered
[    0.665455] acpiphp: Slot [17] registered
[    0.665455] acpiphp: Slot [18] registered
[    0.668786] acpiphp: Slot [19] registered
[    0.669643] acpiphp: Slot [20] registered
[    0.672080] acpiphp: Slot [21] registered
[    0.673637] acpiphp: Slot [22] registered
[    0.673668] acpiphp: Slot [23] registered
[    0.677031] acpiphp: Slot [24] registered
[    0.677031] acpiphp: Slot [25] registered
[    0.680343] acpiphp: Slot [26] registered
[    0.681646] acpiphp: Slot [27] registered
[    0.681660] acpiphp: Slot [28] registered
[    0.685294] acpiphp: Slot [29] registered
[    0.685663] acpiphp: Slot [30] registered
[    0.688595] acpiphp: Slot [31] registered
[    0.689513] PCI host bridge to bus 0000:00
[    0.689513] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.689806] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.692006] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.693930] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.696005] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.698130] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.704146] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.706057] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.710532] pci 0000:00:01.1: reg 0x20: [io  0xc1e0-0xc1ef]
[    0.716168] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.716690] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.719361] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.724533] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.728958] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.733688] pci 0000:00:02.0: reg 0x14: [mem 0xfebe0000-0xfebe0fff]
[    0.743106] pci 0000:00:02.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.749165] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.749285] pci 0000:00:03.0: reg 0x10: [io  0xc1c0-0xc1df]
[    0.753146] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    0.760578] pci 0000:00:03.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.764140] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.769199] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.769199] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.777145] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.780190] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.783290] pci 0000:00:05.0: reg 0x10: [io  0xc040-0xc07f]
[    0.785138] pci 0000:00:05.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[    0.796176] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.797234] pci 0000:00:06.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.800591] pci 0000:00:06.0: reg 0x14: [mem 0xfebe3000-0xfebe3fff]
[    0.808743] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.812014] pci 0000:00:07.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.814915] pci 0000:00:07.0: reg 0x14: [mem 0xfebe4000-0xfebe4fff]
[    0.824175] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.829210] pci 0000:00:08.0: reg 0x10: [io  0xc100-0xc13f]
[    0.829210] pci 0000:00:08.0: reg 0x14: [mem 0xfebe5000-0xfebe5fff]
[    0.840174] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.841215] pci 0000:00:09.0: reg 0x10: [io  0xc140-0xc17f]
[    0.844011] pci 0000:00:09.0: reg 0x14: [mem 0xfebe6000-0xfebe6fff]
[    0.852510] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.855239] pci 0000:00:0a.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.857135] pci 0000:00:0a.0: reg 0x14: [mem 0xfebe7000-0xfebe7fff]
[    0.868138] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    0.868673] pci 0000:00:0b.0: reg 0x10: [mem 0xfebe8000-0xfebe800f]
[    0.877691] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.880239] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.882902] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.885615] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.888133] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.892406] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.894333] ACPI: \_SB_.PCI0: notify handler is installed
[    0.894333] Found 1 acpi root devices
[    0.900112] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.902939] vgaarb: loaded
[    0.902939] vgaarb: bridge control possible 0000:00:02.0
[    0.904204] SCSI subsystem initialized
[    0.908160] libata version 3.00 loaded.
[    0.908177] ACPI: bus type USB registered
[    0.912239] usbcore: registered new interface driver usbfs
[    0.912239] usbcore: registered new interface driver hub
[    0.916090] usbcore: registered new device driver usb
[    0.916180] pps_core: LinuxPPS API ver. 1 registered
[    0.917738] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.924096] PTP clock support registered
[    0.925608] EDAC MC: Ver: 3.0.0
[    0.928218] PCI: Using ACPI for IRQ routing
[    0.929543] PCI: pci_cache_line_size set to 64 bytes
[    0.932007] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.932007] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.937169] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.937169] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.938217] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.948128] Switched to clocksource kvm-clock
[    1.085943] pnp: PnP ACPI init
[    1.087373] ACPI: bus type PNP registered
[    1.089001] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    1.092105] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.094159] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    1.097242] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.099255] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    1.102362] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.104448] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    1.107245] pnp 00:03: [dma 2]
[    1.108742] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.110803] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    1.113894] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.115938] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    1.119011] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.121643] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.123871] pnp: PnP ACPI: found 7 devices
[    1.125405] ACPI: bus type PNP unregistered
[    1.151010] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.152917] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.154696] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.156639] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.158691] NET: Registered protocol family 2
[    1.160713] TCP established hash table entries: 2048 (order: 2, 16384 by=
tes)
[    1.162867] TCP bind hash table entries: 2048 (order: 5, 163840 bytes)
[    1.165063] TCP: Hash tables configured (established 2048 bind 2048)
[    1.167056] TCP: reno registered
[    1.168402] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    1.170319] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    1.172615] NET: Registered protocol family 1
[    1.174545] RPC: Registered named UNIX socket transport module.
[    1.176439] RPC: Registered udp transport module.
[    1.178044] RPC: Registered tcp transport module.
[    1.179648] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.181658] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.183532] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.185433] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.187379] pci 0000:00:02.0: Boot video device
[    1.189138] PCI: CLS 0 bytes, default 64
[    1.219493] DMA-API: preallocated 65536 debug entries
[    1.221324] DMA-API: debugging enabled by kernel config
[    1.223904] kvm: no hardware support
[    1.225550] Machine check injector initialized
[    1.227454] Scanning for low memory corruption every 60 seconds
[    1.229786] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    1.232846] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    1.235975] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    1.240421] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.242334] PCLMULQDQ-NI instructions are not detected.
[    1.244088] AVX or AES-NI instructions are not detected.
[    1.245813] AVX instructions are not detected.
[    1.254667] AVX instructions are not detected.
[    1.256241] AVX instructions are not detected.
[    1.257792] AVX instructions are not detected.
[    1.319528] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.337257] VFS: Disk quotas dquot_6.5.2
[    1.339024] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.346355] NFS: Registering the id_resolver key type
[    1.348224] Key type id_resolver registered
[    1.349731] Key type id_legacy registered
[    1.351210] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.354559] ROMFS MTD (C) 2007 Red Hat, Inc.
[    1.356574] fuse init (API version 7.22)
[    1.358686] SGI XFS with ACLs, security attributes, realtime, large bloc=
k/inode numbers, debug enabled
[    1.365552] bio: create slab <bio-1> at 1
[    1.368276] Btrfs loaded
[    1.369480] msgmni has been set to 414
[    1.378293] NET: Registered protocol family 38
[    1.379928] Key type asymmetric registered
[    1.381492] Asymmetric key parser 'x509' registered
[    1.383348] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    1.386277] io scheduler noop registered
[    1.387734] io scheduler deadline registered
[    1.389339] io scheduler cfq registered (default)
[    1.391888] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.394342] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.396889] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    1.399604] ACPI: Power Button [PWRF]
[    1.402614] GHES: HEST is not enabled!
[    1.404112] ERST DBG: ERST support is disabled.
[    1.407103] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    1.408992] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:3)
[    1.414035] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    1.415883] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:3)
[    1.421714] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    1.429831] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    1.442997] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.467743] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    1.473180] Non-volatile memory driver v1.3
[    1.483151] brd: module loaded
[    1.488961] loop: module loaded
[    1.490557] virtio-pci 0000:00:05.0: irq 40 for MSI/MSI-X
[    1.492365] virtio-pci 0000:00:05.0: irq 41 for MSI/MSI-X
[    1.495529]  vda: unknown partition table
[    1.499322] virtio-pci 0000:00:06.0: irq 42 for MSI/MSI-X
[    1.501167] virtio-pci 0000:00:06.0: irq 43 for MSI/MSI-X
[    1.503904]  vdb: unknown partition table
[    1.507566] virtio-pci 0000:00:07.0: irq 44 for MSI/MSI-X
[    1.509408] virtio-pci 0000:00:07.0: irq 45 for MSI/MSI-X
[    1.512217]  vdc: unknown partition table
[    1.515649] virtio-pci 0000:00:08.0: irq 46 for MSI/MSI-X
[    1.517471] virtio-pci 0000:00:08.0: irq 47 for MSI/MSI-X
[    1.520179]  vdd: unknown partition table
[    1.523567] virtio-pci 0000:00:09.0: irq 48 for MSI/MSI-X
[    1.525393] virtio-pci 0000:00:09.0: irq 49 for MSI/MSI-X
[    1.528099]  vde: unknown partition table
[    1.531482] virtio-pci 0000:00:0a.0: irq 50 for MSI/MSI-X
[    1.533309] virtio-pci 0000:00:0a.0: irq 51 for MSI/MSI-X
[    1.536045]  vdf: unknown partition table
[    1.539516] lkdtm: No crash points registered, enable through debugfs
[    1.542487] Loading iSCSI transport class v2.0-870.
[    1.546242] Adaptec aacraid driver 1.2-0[30200]-ms
[    1.548342] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    1.550769] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 8.06.00.08-k.
[    1.553966] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 ES=
T 2006)
[    1.556855] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 20=
06)
[    1.559241] megasas: 06.700.06.00-rc1 Sat. Aug. 31 17:00:00 PDT 2013
[    1.561837] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    1.564047] RocketRAID 3xxx/4xxx Controller driver v1.8
[    1.580762] scsi_debug: host protection
[    1.582298] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[    1.586021] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[    1.589017] ata_piix 0000:00:01.1: version 2.13
[    1.593801] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.596172] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.=
00 MiB)
[    1.600128] sd 0:0:0:0: [sda] Write Protect is off
[    1.601805] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    1.603699] scsi1 : ata_piix
[    1.605728] scsi2 : ata_piix
[    1.607402] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc1e0 irq 14
[    1.609524] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc1e8 irq 15
[    1.612190] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[    1.617507] virtio-pci 0000:00:03.0: irq 52 for MSI/MSI-X
[    1.619327] virtio-pci 0000:00:03.0: irq 53 for MSI/MSI-X
[    1.621184] virtio-pci 0000:00:03.0: irq 54 for MSI/MSI-X
[    1.625432] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.=
de
[    1.627922] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    1.629767] Copyright (c) 2007 Atheros Corporation.
[    1.632347] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[    1.634558] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.=
com>
[    1.634558]   http://www.scyld.com/network/drivers.html
[    1.638821] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-2=
9)
[    1.641324] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    1.643243] e100: Copyright(c) 1999-2006 Intel Corporation
[    1.645252] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-=
NAPI
[    1.647364] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    1.652109]  sda: unknown partition table
[    1.668123] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.768906] ata2.01: NODEV after polling detection
[    1.771106] ata2.00: ATAPI: QEMU DVD-ROM, 1.6.0, max UDMA/100
[    1.773726] ata2.00: configured for MWDMA2
[    1.776148] scsi 2:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     1.=
6. PQ: 0 ANSI: 5
[    1.780606] sr0: scsi3-mmc drive: 4x/4x cd/rw xa/form2 tray
[    1.782556] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.784940] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    1.787182] sr 2:0:0:0: Attached scsi generic sg1 type 5
[    2.020390] e1000 0000:00:04.0 eth1: (PCI:33MHz:32-bit) 52:54:00:12:34:57
[    2.022482] e1000 0000:00:04.0 eth1: Intel(R) PRO/1000 Network Connection
[    2.024799] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    2.026667] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    2.028813] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.=
5-k
[    2.030902] igb: Copyright (c) 2007-2013 Intel Corporation.
[    2.032969] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - vers=
ion 3.15.1-k
[    2.035748] ixgbe: Copyright (c) 1999-2013 Intel Corporation.
[    2.037912] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2=
-NAPI
[    2.040073] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    2.042378] sky2: driver version 1.30
[    2.046138] usbcore: registered new interface driver catc
[    2.048151] usbcore: registered new interface driver kaweth
[    2.049963] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[    2.052889] usbcore: registered new interface driver pegasus
[    2.054942] usbcore: registered new interface driver rtl8150
[    2.057026] usbcore: registered new interface driver asix
[    2.058995] usbcore: registered new interface driver ax88179_178a
[    2.061184] usbcore: registered new interface driver cdc_ether
[    2.063245] usbcore: registered new interface driver r815x
[    2.065296] usbcore: registered new interface driver cdc_eem
[    2.067329] usbcore: registered new interface driver dm9601
[    2.069390] usbcore: registered new interface driver smsc75xx
[    2.071442] usbcore: registered new interface driver smsc95xx
[    2.073545] usbcore: registered new interface driver gl620a
[    2.075553] usbcore: registered new interface driver net1080
[    2.077624] usbcore: registered new interface driver plusb
[    2.079607] usbcore: registered new interface driver rndis_host
[    2.081748] usbcore: registered new interface driver cdc_subset
[    2.083832] usbcore: registered new interface driver zaurus
[    2.085897] usbcore: registered new interface driver MOSCHIP usb-etherne=
t driver
[    2.088858] usbcore: registered new interface driver int51x1
[    2.090880] usbcore: registered new interface driver ipheth
[    2.092951] usbcore: registered new interface driver sierra_net
[    2.095041] usbcore: registered new interface driver cdc_ncm
[    2.096900] Fusion MPT base driver 3.04.20
[    2.098405] Copyright (c) 1999-2008 LSI Corporation
[    2.100116] Fusion MPT SPI Host driver 3.04.20
[    2.101936] Fusion MPT FC Host driver 3.04.20
[    2.103726] Fusion MPT SAS Host driver 3.04.20
[    2.105584] Fusion MPT misc device (ioctl) driver 3.04.20
[    2.107687] mptctl: Registered with Fusion MPT base driver
[    2.109533] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[    2.112161] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.114195] ehci-pci: EHCI PCI platform driver
[    2.115980] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.117973] ohci-pci: OHCI PCI platform driver
[    2.119778] uhci_hcd: USB Universal Host Controller Interface driver
[    2.122243] usbcore: registered new interface driver usb-storage
[    2.124372] usbcore: registered new interface driver ums-alauda
[    2.126448] usbcore: registered new interface driver ums-datafab
[    2.128564] usbcore: registered new interface driver ums-freecom
[    2.130660] usbcore: registered new interface driver ums-isd200
[    2.132722] usbcore: registered new interface driver ums-jumpshot
[    2.134798] usbcore: registered new interface driver ums-sddr09
[    2.136875] usbcore: registered new interface driver ums-sddr55
[    2.138896] usbcore: registered new interface driver ums-usbat
[    2.140945] usbcore: registered new interface driver usbtest
[    2.143147] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    2.154603] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.156325] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.158762] mousedev: PS/2 mouse device common for all mice
[    2.162119] rtc_cmos 00:00: RTC can wake from S4
[    2.164595] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    2.166751] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    2.168984] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    2.172141] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    2.174575] i6300esb: initialized (0xffffc900008f4000). heartbeat=3D30 s=
ec (nowayout=3D0)
[    2.177673] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    2.179818] iTCO_vendor_support: vendor-support=3D0
[    2.181718] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    2.184769] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    2.187995] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D0)
[    2.191607] md: linear personality registered for level -1
[    2.193510] md: raid0 personality registered for level 0
[    2.195359] md: raid1 personality registered for level 1
[    2.197227] md: raid10 personality registered for level 10
[    2.199295] md: raid6 personality registered for level 6
[    2.201193] md: raid5 personality registered for level 5
[    2.203050] md: raid4 personality registered for level 4
[    2.204922] md: multipath personality registered for level -4
[    2.206875] md: faulty personality registered for level -5
[    2.210440] device-mapper: ioctl: 4.26.0-ioctl (2013-08-15) initialised:=
 dm-devel@redhat.com
[    2.214295] device-mapper: multipath: version 1.5.1 loaded
[    2.216151] device-mapper: multipath round-robin: version 1.0.0 loaded
[    2.218442] device-mapper: cache-policy-mq: version 1.0.0 loaded
[    2.220363] device-mapper: cache cleaner: version 1.0.0 loaded
[    2.223051] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    2.225906] tsc: Refined TSC clocksource calibration: 2666.603 MHz
[    2.232794] usbcore: registered new interface driver usbhid
[    2.234614] usbhid: USB HID core driver
[    2.236349] oprofile: using NMI interrupt.
[    2.238026] TCP: bic registered
[    2.239337] Initializing XFRM netlink socket
[    2.242113] NET: Registered protocol family 10
[    2.244465] sit: IPv6 over IPv4 tunneling driver
[    2.246864] NET: Registered protocol family 17
[    2.248575] 8021q: 802.1Q VLAN Support v1.8
[    2.250299] sctp: Hash tables configured (established 819 bind 819)
[    2.252663] Key type dns_resolver registered
[    2.255857]=20
[    2.255857] printing PIC contents
[    2.258078] ... PIC  IMR: ffff
[    2.259388] ... PIC  IRR: 9113
[    2.260700] ... PIC  ISR: 0000
[    2.261987] ... PIC ELCR: 0c00
[    2.263308] printing local APIC contents on CPU#0/0:
[    2.265024] ... APIC ID:      00000000 (0)
[    2.266549] ... APIC VERSION: 00050014
[    2.267297] ... APIC TASKPRI: 00000000 (00)
[    2.267297] ... APIC PROCPRI: 00000000
[    2.267297] ... APIC LDR: 01000000
[    2.267297] ... APIC DFR: ffffffff
[    2.267297] ... APIC SPIV: 000001ff
[    2.267297] ... APIC ISR field:
[    2.267297] 000000000000000000000000000000000000000000000000000000000000=
0000
[    2.267297] ... APIC TMR field:
[    2.267297] 000000000200000000000000000000000000000000000000000000000000=
0000
[    2.267297] ... APIC IRR field:
[    2.267297] 000000000000000000000000000000000000000000000000000000000000=
8000
[    2.267297] ... APIC ESR: 00000000
[    2.267297] ... APIC ICR: 000008fd
[    2.267297] ... APIC ICR2: 02000000
[    2.267297] ... APIC LVTT: 000000ef
[    2.267297] ... APIC LVTPC: 00010000
[    2.267297] ... APIC LVT0: 00010700
[    2.267297] ... APIC LVT1: 00000400
[    2.267297] ... APIC LVTERR: 000000fe
[    2.267297] ... APIC TMICT: 0003cc06
[    2.267297] ... APIC TMCCT: 00000000
[    2.267297] ... APIC TDCR: 00000003
[    2.267297]=20
[    2.305454] number of MP IRQ sources: 15.
[    2.306949] number of IO-APIC #0 registers: 24.
[    2.308555] testing the IO APIC.......................
[    2.310291] IO APIC #0......
[    2.311526] .... register #00: 00000000
[    2.312994] .......    : physical APIC id: 00
[    2.314543] .......    : Delivery Type: 0
[    2.316031] .......    : LTS          : 0
[    2.317503] .... register #01: 00170011
[    2.318934] .......     : max redirection entries: 17
[    2.320644] .......     : PRQ implemented: 0
[    2.322172] .......     : IO APIC version: 11
[    2.323709] .... register #02: 00000000
[    2.325185] .......     : arbitration: 00
[    2.326650] .... IRQ redirection table:
[    2.328121] 1    0    0   0   0    0    0    00
[    2.329718] 0    0    0   0   0    1    1    31
[    2.331321] 0    0    0   0   0    1    1    30
[    2.332952] 0    0    0   0   0    1    1    33
[    2.334554] 1    0    0   0   0    1    1    34
[    2.336165] 1    1    0   0   0    1    1    35
[    2.337750] 0    0    0   0   0    1    1    36
[    2.339375] 0    0    0   0   0    1    1    37
[    2.341000] 0    0    0   0   0    1    1    38
[    2.342604] 0    1    0   0   0    1    1    39
[    2.344217] 1    1    0   0   0    1    1    3A
[    2.345812] 1    1    0   0   0    1    1    3B
[    2.347411] 0    0    0   0   0    1    1    3C
[    2.349034] 0    0    0   0   0    1    1    3D
[    2.350627] 0    0    0   0   0    1    1    3E
[    2.352243] 0    0    0   0   0    1    1    3F
[    2.353842] 1    0    0   0   0    0    0    00
[    2.355439] 1    0    0   0   0    0    0    00
[    2.357074] 1    0    0   0   0    0    0    00
[    2.358665] 1    0    0   0   0    0    0    00
[    2.360282] 1    0    0   0   0    0    0    00
[    2.361879] 1    0    0   0   0    0    0    00
[    2.363475] 1    0    0   0   0    0    0    00
[    2.365100] 1    0    0   0   0    0    0    00
[    2.366682] IRQ to pin mappings:
[    2.367989] IRQ0 -> 0:2
[    2.369445] IRQ1 -> 0:1
[    2.370867] IRQ3 -> 0:3
[    2.372323] IRQ4 -> 0:4
[    2.373740] IRQ5 -> 0:5
[    2.375158] IRQ6 -> 0:6
[    2.376602] IRQ7 -> 0:7
[    2.378021] IRQ8 -> 0:8
[    2.379446] IRQ9 -> 0:9
[    2.380886] IRQ10 -> 0:10
[    2.382345] IRQ11 -> 0:11
[    2.383798] IRQ12 -> 0:12
[    2.385282] IRQ13 -> 0:13
[    2.386733] IRQ14 -> 0:14
[    2.388215] IRQ15 -> 0:15
[    2.389678] .................................... done.
[    2.392071] PM: Hibernation image not present or could not be loaded.
[    2.394148] registered taskstats version 1
[    2.396785] rtc_cmos 00:00: setting system clock to 2013-10-09 23:59:16 =
UTC (1381363156)
[    2.399694] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    2.403492] 8021q: adding VLAN 0 to HW filter on device eth0
[    2.414029] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[    2.415885] 8021q: adding VLAN 0 to HW filter on device eth1
[    2.432038] Sending DHCP requests ., OK
[    2.452042] IP-Config: Got DHCP answer from 10.0.2.2, my address is 10.0=
=2E2.15
[    2.507950] IP-Config: Complete:
[    2.509392]      device=3Deth0, hwaddr=3D52:54:00:12:34:56, ipaddr=3D10.=
0.2.15, mask=3D255.255.255.0, gw=3D10.0.2.2
[    2.512597]      host=3Dquantal-bens-4, domain=3D, nis-domain=3D(none)
[    2.514501]      bootserver=3D10.0.2.2, rootserver=3D192.168.1.1, rootpa=
th=3D
[    2.515957]      nameserver0=3D10.0.2.3
[    2.810819] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input2
[    2.814785] md: Skipping autodetection of RAID arrays. (raid=3Dautodetec=
t will force)
[    2.846083] VFS: Mounted root (nfs filesystem) on device 0:13.
[    2.853083] Freeing unused kernel memory: 3192K (ffffffff8235d000 - ffff=
ffff8267b000)
[    2.855937] Write protecting the kernel read-only data: 18432k
[    2.864755] Freeing unused kernel memory: 1704K (ffff880001a56000 - ffff=
880001c00000)
[    2.870277] Freeing unused kernel memory: 788K (ffff88000213b000 - ffff8=
80002200000)
[   40.859197] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recov=
ery directory
[   40.863197] NFSD: starting 90-second grace period (net ffffffff8230bd80)
Kernel tests: Boot OK!
[   42.303987] Unregister pv shared memory for cpu 1
[   42.332408] CPU0 attaching NULL sched-domain.
[   42.334031] CPU1 attaching NULL sched-domain.
[   42.334079] CPU0 attaching NULL sched-domain.
[   42.339917] smpboot: CPU 1 is now offline
[   42.464748] smpboot: Booting Node 0 Processor 1 APIC 0x1
[   42.340018] kvm-clock: cpu 1, msr 0:f7f5041, secondary cpu clock
[   42.340018] masked ExtINT on CPU#1
[   42.500233] CPU0 attaching NULL sched-domain.
[   42.501890] CPU0 attaching sched-domain:
[   42.503373]  domain 0: span 0-1 level CPU
[   42.505050]   groups: 0 (cpu_power =3D 1023) 1
[   42.507146] CPU1 attaching sched-domain:
[   42.508660]  domain 0: span 0-1 level CPU
[   42.510305]   groups: 1 0 (cpu_power =3D 1023)
[   42.512718] KVM setup async PF for cpu 1
[   42.514254] kvm-stealtime: cpu 1, msr e80d200
Trinity v1.0  Dave Jones <davej@redhat.com> 2012
[2419] Marking 64-bit syscall 274 (get_robust_list) as AVOID
[2419] Marking 32-bit syscall 312 (get_robust_list) as AVOID
[   43.627135] Unregister pv shared memory for cpu 1
[   43.768185] CPU0 attaching NULL sched-domain.
[   43.769795] CPU1 attaching NULL sched-domain.
[   43.771385] CPU0 attaching NULL sched-domain.
[   43.776191] smpboot: CPU 1 is now offline
[   53.807032] smpboot: Booting Node 0 Processor 1 APIC 0x1
[   43.776964] kvm-clock: cpu 1, msr 0:f7f5041, secondary cpu clock
[   43.776964] masked ExtINT on CPU#1
[   53.842375] CPU0 attaching NULL sched-domain.
[   53.844025] CPU0 attaching sched-domain:
[   53.845495]  domain 0: span 0-1 level CPU
[   53.847110]   groups: 0 (cpu_power =3D 1010) 1
[   53.849225] CPU1 attaching sched-domain:
[   53.850690]  domain 0: span 0-1 level CPU
[   53.852347]   groups: 1 0 (cpu_power =3D 1010)
[   53.854664] KVM setup async PF for cpu 1
[   53.856219] kvm-stealtime: cpu 1, msr e80d200
[   55.595870] Bits 55-60 of /proc/PID/pagemap entries are about to stop be=
ing page-shift some time soon. See the linux/Documentation/vm/pagemap.txt f=
or details.
[2427] Watchdog is alive
[2419] Started watchdog thread 2427
[   56.625440] warning: process `trinity-child0' used the deprecated sysctl=
 system call with=20
1219 iterations.
2171 iterations.
2758 iterations.
4244 iterations.
6563 iterations.
6693 iterations.
6842 iterations.
7215 iterations.
9614 iterations.
[   84.006933] scsi_nl_rcv_msg: discarding partial skb
11204 iterations.
11589 iterations.
12767 iterations.
13456 iterations.
15220 iterations.
15913 iterations.
15941 iterations.
17777 iterations.
19442 iterations.
19497 iterations.
22478 iterations.
23121 iterations.
23388 iterations.
23487 iterations.
23600 iterations.
23661 iterations.
24150 iterations.
26036 iterations.
26664 iterations.
27602 iterations.
28102 iterations.
29449 iterations.
32302 iterations.
umount: /fs/trinity/sys: device is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
run-parts: /etc/kernel-tests/99-trinity exited with return code 1
[  155.809595] nfsd: last server has exited, flushing export cache
[  158.911733] Unregister pv shared memory for cpu 1
[  158.913446] Unregister pv shared memory for cpu 0
[  158.915838] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  158.931966] reboot: Restarting system
[  158.933436] reboot: machine restart
Elapsed time: 165
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-lkp-CONFIG=
_SCHED_DEBUG/3d5587ec7222eebd6d2fa2d4b245ef837a8f36fa/vmlinuz-3.12.0-rc4-wl=
-02197-g3d5587e -append 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_timeout=
=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dyna=
mic_printk sysrq_always_enabled panic=3D10 load_ramdisk=3D2 prompt_ramdisk=
=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal ip=3D::::quantal-be=
ns-4::dhcp nfsroot=3D192.168.1.1:/nfsroot/wfg,tcp,v3,nocto,actimeo=3D600,no=
lock,rsize=3D524288,wsize=3D524288 rw link=3D/kernel-tests/run-queue/kvm/x8=
6_64-lkp-CONFIG_SCHED_DEBUG/devel-hourly-2013101007/.vmlinuz-3d5587ec7222ee=
bd6d2fa2d4b245ef837a8f36fa-20131010075902-7-bens branch=3Dlinux-devel/devel=
-hourly-2013101007 BOOT_IMAGE=3D/kernel/x86_64-lkp-CONFIG_SCHED_DEBUG/3d558=
7ec7222eebd6d2fa2d4b245ef837a8f36fa/vmlinuz-3.12.0-rc4-wl-02197-g3d5587e'  =
-m 256M -smp 2 -net nic,vlan=3D0,macaddr=3D00:00:00:00:00:00,model=3Dvirtio=
 -net user,vlan=3D0,hostfwd=3Dtcp::13965-:22 -net nic,vlan=3D1,model=3De100=
0 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -drive =
file=3D/fs/sda7/disk0-quantal-bens-4,media=3Ddisk,if=3Dvirtio -drive file=
=3D/fs/sda7/disk1-quantal-bens-4,media=3Ddisk,if=3Dvirtio -drive file=3D/fs=
/sda7/disk2-quantal-bens-4,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sda7/=
disk3-quantal-bens-4,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sda7/disk4-=
quantal-bens-4,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sda7/disk5-quanta=
l-bens-4,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-quantal-bens-=
4 -serial file:/dev/shm/kboot/serial-quantal-bens-4 -daemonize -display non=
e -monitor null=20

--pWyiEgJYm5f9v55/
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-3d5587ec7222eebd6d2fa2d4b245ef837a8f36fa-x86_64-lkp-CONFIG_SCHED_DEBUG-initcall-calibrate_xor_blocks-116724.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDE1YzAzZGQ0ODU5YWIxNmY5MjEyMjM4ZjI5ZGQzMTU2NTRhYTk0ZjYK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgM2Q1NTg3ZS4uLiBNZXJnZSAndGlwL3g4Ni9i
c3AtaG90cGx1ZycgaW50byBkZXZlbC1ob3VybHktMjAxMzEwMTAwNwpIRUFEIGlzIG5vdyBh
dCAxNWMwM2RkLi4uIExpbnV4IDMuMTItcmMzCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS94ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRy9saW51eC1kZXZlbDpkZXZl
bC1ob3VybHktMjAxMzEwMTAwNzoxNWMwM2RkNDg1OWFiMTZmOTIxMjIzOGYyOWRkMzE1NjU0
YWE5NGY2OmJpc2VjdC1uZXQKCjIwMTMtMTAtMTAtMDg6NTU6MzggMTVjMDNkZDQ4NTlhYjE2
ZjkyMTIyMzhmMjlkZDMxNTY1NGFhOTRmNiByZXVzZSAva2VybmVsL3g4Nl82NC1sa3AtQ09O
RklHX1NDSEVEX0RFQlVHLzE1YzAzZGQ0ODU5YWIxNmY5MjEyMjM4ZjI5ZGQzMTU2NTRhYTk0
ZjYvdm1saW51ei0zLjEyLjAtcmMzCgoyMDEzLTEwLTEwLTA4OjU1OjM4IGRldGVjdGluZyBi
b290IHN0YXRlIC4uLi4uLi4uCTE0CTIwIFNVQ0NFU1MKCmJpc2VjdDogZ29vZCBjb21taXQg
MTVjMDNkZDQ4NTlhYjE2ZjkyMTIyMzhmMjlkZDMxNTY1NGFhOTRmNgpnaXQgYmlzZWN0IHN0
YXJ0IDNkNTU4N2VjNzIyMmVlYmQ2ZDJmYTJkNGIyNDVlZjgzN2E4ZjM2ZmEgMTVjMDNkZDQ4
NTlhYjE2ZjkyMTIyMzhmMjlkZDMxNTY1NGFhOTRmNiAtLQpQcmV2aW91cyBIRUFEIHBvc2l0
aW9uIHdhcyAxNWMwM2RkLi4uIExpbnV4IDMuMTItcmMzClN3aXRjaGVkIHRvIGJyYW5jaCAn
bWFzdGVyJwpZb3VyIGJyYW5jaCBpcyBiZWhpbmQgJ29yaWdpbi9tYXN0ZXInIGJ5IDQxMjEz
IGNvbW1pdHMsIGFuZCBjYW4gYmUgZmFzdC1mb3J3YXJkZWQuCiAgKHVzZSAiZ2l0IHB1bGwi
IHRvIHVwZGF0ZSB5b3VyIGxvY2FsIGJyYW5jaCkKQmlzZWN0aW5nOiAxMzExIHJldmlzaW9u
cyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMCBzdGVwcykKW2JkMWJjMzk1
MDZhZDZjZTIzNmJmOTMyNzU3ZDZlM2E4MWIzZTNkNTVdIE1lcmdlICdyZWdtYXAvdG9waWMv
Y29yZScgaW50byBkZXZlbC1ob3VybHktMjAxMzEwMTAwNwpnaXQgYmlzZWN0IHJ1biAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9uZXQv
b2JqLWJpc2VjdApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2hvbWUvd2ZnL25ldC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS94ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRy9saW51eC1kZXZl
bDpkZXZlbC1ob3VybHktMjAxMzEwMTAwNzpiZDFiYzM5NTA2YWQ2Y2UyMzZiZjkzMjc1N2Q2
ZTNhODFiM2UzZDU1OmJpc2VjdC1uZXQKCjIwMTMtMTAtMTAtMDk6MDE6MTYgYmQxYmMzOTUw
NmFkNmNlMjM2YmY5MzI3NTdkNmUzYTgxYjNlM2Q1NSBjb21waWxpbmcKMTQwNSByZWFsICAx
NzQ5IHVzZXIgIDE1MCBzeXMgIDEzNS4xMyUgY3B1IAl4ODZfNjQtbGtwLUNPTkZJR19TQ0hF
RF9ERUJVRwoKMjAxMy0xMC0xMC0wOToyOToxMiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEy
LjAtcmM0LXdsLTAwODg1LWdiZDFiYzM5Li4uLi4JMwkxMwkxOS4uLi4uLi4uLi4uLi4uLgky
MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDYyNyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgOSBzdGVwcykKW2YwYTZkNTg1MmNjOGI0ZTllNTE4YzA0MjY1ODBm
MDU4OTMyN2U0MzhdIE1lcmdlICdhcm0tc29jL25leHQvZHQnIGludG8gZGV2ZWwtaG91cmx5
LTIwMTMxMDEwMDcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9ob21lL3dmZy9uZXQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0veDg2XzY0LWxrcC1DT05GSUdfU0NIRURfREVCVUcvbGludXgtZGV2
ZWw6ZGV2ZWwtaG91cmx5LTIwMTMxMDEwMDc6ZjBhNmQ1ODUyY2M4YjRlOWU1MThjMDQyNjU4
MGYwNTg5MzI3ZTQzODpiaXNlY3QtbmV0CgoyMDEzLTEwLTEwLTA5OjQxOjIwIGYwYTZkNTg1
MmNjOGI0ZTllNTE4YzA0MjY1ODBmMDU4OTMyN2U0MzggY29tcGlsaW5nCjM3MTUgcmVhbCAg
MTcyOCB1c2VyICAxNDkgc3lzICA1MC41MyUgY3B1IAl4ODZfNjQtbGtwLUNPTkZJR19TQ0hF
RF9ERUJVRwoKMjAxMy0xMC0xMC0xMDo0NjowMyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEy
LjAtcmM0LXdsLTAxNTY5LWdmMGE2ZDU4Li4uLi4uCTEJMTAuCTEzCTE0CTE4CTE5Li4uLi4u
LgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDM1MCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgOCBzdGVwcykKWzkwOWRjNmZhMWYxZjQyZGNkYWU2MmIwN2M0
ZDZiODk0YTM5MmUwZDddIE1lcmdlICdpcHNlYy1uZXh0L3Rlc3RpbmcnIGludG8gZGV2ZWwt
aG91cmx5LTIwMTMxMDEwMDcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9uZXQvb2JqLWJpc2VjdApscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LWxrcC1DT05GSUdfU0NIRURfREVCVUcvbGlu
dXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTMxMDEwMDc6OTA5ZGM2ZmExZjFmNDJkY2RhZTYy
YjA3YzRkNmI4OTRhMzkyZTBkNzpiaXNlY3QtbmV0CgoyMDEzLTEwLTEwLTEwOjU2OjM3IDkw
OWRjNmZhMWYxZjQyZGNkYWU2MmIwN2M0ZDZiODk0YTM5MmUwZDcgY29tcGlsaW5nCjExOTEg
cmVhbCAgMTY1MCB1c2VyICAxNDAgc3lzICAxNTAuMjclIGNwdSAJeDg2XzY0LWxrcC1DT05G
SUdfU0NIRURfREVCVUcKCjIwMTMtMTAtMTAtMTE6MjQ6NTQgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgMy4xMi4wLXJjNC13bC0wMTg0Ni1nOTA5ZGM2ZmEuLi4uLi4JMQkxNQkxOS4uLi4uLi4u
Li4uLi4uCTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMTk4IHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpbN2ZiMWIwNjE1MjM1YjM5NzVkZWY1
OWZiZmZkMGY1MmM3MTczNmJkM10gTWVyZ2UgJ2FybS1zb2MvbmV4dC9kcml2ZXJzJyBpbnRv
IGRldmVsLWhvdXJseS0yMDEzMTAxMDA3CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2Vj
dC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbmV0L29iai1iaXNlY3QKbHMgLWEg
L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1sa3AtQ09ORklHX1NDSEVEX0RF
QlVHL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDEzMTAxMDA3OjdmYjFiMDYxNTIzNWIz
OTc1ZGVmNTlmYmZmZDBmNTJjNzE3MzZiZDM6YmlzZWN0LW5ldAoKMjAxMy0xMC0xMC0xMToz
Njo1OSA3ZmIxYjA2MTUyMzViMzk3NWRlZjU5ZmJmZmQwZjUyYzcxNzM2YmQzIGNvbXBpbGlu
Zwo3MjkgcmVhbCAgMzU3IHVzZXIgIDMxIHN5cyAgNTMuMzUlIGNwdSAJeDg2XzY0LWxrcC1D
T05GSUdfU0NIRURfREVCVUcKCjIwMTMtMTAtMTAtMTE6NDk6NTYgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgMy4xMi4wLXJjNC13bC0wMTk5OC1nN2ZiMWIwNi4uLi4JMS4JMwkxNQkxNgkxNy4J
MTgJMTkuCTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMTAxIHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA3IHN0ZXBzKQpbYWM1ZmI5ODQ2Njk4ZTlkZmZjNDMw
YWIzOGMxYWFlZmU1MGE1MTk4MF0gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAncmVn
dWxhdG9yL3RvcGljL29wdGlvbmFsJyBpbnRvIHJlZ3VsYXRvci1uZXh0CnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbmV0
L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1s
a3AtQ09ORklHX1NDSEVEX0RFQlVHL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDEzMTAx
MDA3OmFjNWZiOTg0NjY5OGU5ZGZmYzQzMGFiMzhjMWFhZWZlNTBhNTE5ODA6YmlzZWN0LW5l
dAoKMjAxMy0xMC0xMC0xMTo1NzozMCBhYzVmYjk4NDY2OThlOWRmZmM0MzBhYjM4YzFhYWVm
ZTUwYTUxOTgwIGNvbXBpbGluZwo4NDAgcmVhbCAgMTczMSB1c2VyICAxNDkgc3lzICAyMjMu
NzglIGNwdSAJeDg2XzY0LWxrcC1DT05GSUdfU0NIRURfREVCVUcKCjIwMTMtMTAtMTAtMTI6
MTg6NTMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLXJjNC0wMDA5Ny1nYWM1ZmI5OC4u
Li4uLgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDU4IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3Qg
YWZ0ZXIgdGhpcyAocm91Z2hseSA2IHN0ZXBzKQpbYjk3MjllOWY4ZDgyNzI0Yzk4ZjEzZGQz
NThjN2IwOGE0ZDdkZTNkMl0gbXRkOiBuYW5kOiBweGEzeHhfbmFuZDogUmVtb3ZlIHJlZHVu
ZGFudCBvZl9tYXRjaF9wdHIKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9uZXQvb2JqLWJpc2VjdApscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LWxrcC1DT05GSUdfU0NIRURfREVCVUcvbGlu
dXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTMxMDEwMDc6Yjk3MjllOWY4ZDgyNzI0Yzk4ZjEz
ZGQzNThjN2IwOGE0ZDdkZTNkMjpiaXNlY3QtbmV0CgoyMDEzLTEwLTEwLTEyOjIyOjI4IGI5
NzI5ZTlmOGQ4MjcyNGM5OGYxM2RkMzU4YzdiMDhhNGQ3ZGUzZDIgY29tcGlsaW5nCjIzMzEg
cmVhbCAgMTczMCB1c2VyICAxNTAgc3lzICA4MC42NyUgY3B1IAl4ODZfNjQtbGtwLUNPTkZJ
R19TQ0hFRF9ERUJVRwoKMjAxMy0xMC0xMC0xMzowMjo1NiBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAzLjEyLjAtcmMxLTAwMjkzLWdiOTcyOWU5Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAz
MCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNSBzdGVwcykK
W2M0MjAwODJiZmNjMDBhOTA4MzYwZWRkNGJiNTgyNmVjZTFjNTlhZTRdIE1lcmdlICdvcGVu
LW9zZC9leG9mc19pb2N0bCcgaW50byBkZXZlbC1ob3VybHktMjAxMzEwMTAwNwpydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2Zn
L25ldC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZf
NjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRy9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAx
MzEwMTAwNzpjNDIwMDgyYmZjYzAwYTkwODM2MGVkZDRiYjU4MjZlY2UxYzU5YWU0OmJpc2Vj
dC1uZXQKCjIwMTMtMTAtMTAtMTM6MzE6MzUgYzQyMDA4MmJmY2MwMGE5MDgzNjBlZGQ0YmI1
ODI2ZWNlMWM1OWFlNCBjb21waWxpbmcKMTE2MCByZWFsICAxNzM1IHVzZXIgIDE0NyBzeXMg
IDE2Mi4zNSUgY3B1IAl4ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRwoKMjAxMy0xMC0x
MC0xMzo1MjowNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtcmM0LXdsLTAyMTY2LWdj
NDIwMDgyLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uIFRFU1Qg
RkFJTFVSRQpbICAgIDAuODE2MTI4XSAgICBnZW5lcmljX3NzZTogICAzMjkuMzMzIE1CL3Nl
YwpbICAgIDAuODE2Nzc2XSB4b3I6IHVzaW5nIGZ1bmN0aW9uOiBnZW5lcmljX3NzZSAoMzI5
LjMzMyBNQi9zZWMpClsgICAgMC44MTc2NjNdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0t
LS0tLS0tLS0tLQpbICAgIDAuODE4NzQ5XSBXQVJOSU5HOiBDUFU6IDAgUElEOiAxIGF0IGlu
aXQvbWFpbi5jOjcwMSBkb19vbmVfaW5pdGNhbGwrMHgxMjgvMHgxMzgoKQpbICAgIDAuODE5
NjMxXSBpbml0Y2FsbCBjYWxpYnJhdGVfeG9yX2Jsb2NrcysweDAvMHgxNDQgcmV0dXJuZWQg
d2l0aCBwcmVlbXB0aW9uIGltYmFsYW5jZSAKWyAgICAwLjgyMDI5Nl0gTW9kdWxlcyBsaW5r
ZWQgaW46ClsgICAgMC44MjEzMzZdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5v
dCB0YWludGVkIDMuMTIuMC1yYzQtd2wtMDIxNjYtZ2M0MjAwODIgIzQxOApbICAgIDAuODIy
MTUxXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDEx
ClsgICAgMC44MjMwNDBdICAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMWRmNTVlMDAgZmZm
ZmZmZmY4MWEzNzU4ZCBmZmZmODgwMDFkZjU1ZTQ4ClsgICAgMC44MjQ4NTZdICBmZmZmODgw
MDFkZjU1ZTM4IGZmZmZmZmZmODEwYzUzZDUgZmZmZmZmZmY4MTAwMDMxNSBmZmZmZmZmZjgy
NTZkZWYxClsgICAgMC44MjU3OTVdICAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAw
MDAgZmZmZjg4MDAxZGY1NWZkOCBmZmZmODgwMDFkZjU1ZTk4ClsgICAgMC44MjY4MDZdIENh
bGwgVHJhY2U6ClsgICAgMC44MjczMzJdICBbPGZmZmZmZmZmODFhMzc1OGQ+XSBkdW1wX3N0
YWNrKzB4NTQvMHg3NApbICAgIDAuODI4MjAwXSAgWzxmZmZmZmZmZjgxMGM1M2Q1Pl0gd2Fy
bl9zbG93cGF0aF9jb21tb24rMHg3Zi8weDk4ClsgICAgMC44Mjg4MjNdICBbPGZmZmZmZmZm
ODEwMDAzMTU+XSA/IGRvX29uZV9pbml0Y2FsbCsweDEyOC8weDEzOApbICAgIDAuODI5NDMx
XSAgWzxmZmZmZmZmZjgyNTZkZWYxPl0gPyBkb194b3Jfc3BlZWQrMHhlMi8weGUyClsgICAg
MC44Mjk5OTJdICBbPGZmZmZmZmZmODEwYzU0M2E+XSB3YXJuX3Nsb3dwYXRoX2ZtdCsweDRj
LzB4NGUKWyAgICAwLjgzMDU4NV0gIFs8ZmZmZmZmZmY4MTE3NjZjZD5dID8gZnJlZV9wYWdl
cysweDQ1LzB4NDcKWyAgICAwLjgzMTEzNl0gIFs8ZmZmZmZmZmY4MjU2ZGVmMT5dID8gZG9f
eG9yX3NwZWVkKzB4ZTIvMHhlMgpbICAgIDAuODMyMTczXSAgWzxmZmZmZmZmZjgxMDAwMzE1
Pl0gZG9fb25lX2luaXRjYWxsKzB4MTI4LzB4MTM4ClsgICAgMC44MzI4MDVdICBbPGZmZmZm
ZmZmODI1MzBlZDM+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDE1OS8weDFkYQpbICAgIDAu
ODMzNDMwXSAgWzxmZmZmZmZmZjgyNTMwNzRkPl0gPyBkb19lYXJseV9wYXJhbSsweDg4LzB4
ODgKWyAgICAwLjgzNDAwMF0gIFs8ZmZmZmZmZmY4MWEyNmVlNz5dID8gcmVzdF9pbml0KzB4
ZGIvMHhkYgpbICAgIDAuODM0NTQ5XSAgWzxmZmZmZmZmZjgxYTI2ZWY1Pl0ga2VybmVsX2lu
aXQrMHhlLzB4ZGIKWyAgICAwLjgzNTA4NV0gIFs8ZmZmZmZmZmY4MWE0YTgzYz5dIHJldF9m
cm9tX2ZvcmsrMHg3Yy8weGIwClsgICAgMC44MzYxNjNdICBbPGZmZmZmZmZmODFhMjZlZTc+
XSA/IHJlc3RfaW5pdCsweGRiLzB4ZGIKWyAgICAwLjg0MDQwNF0gLS0tWyBlbmQgdHJhY2Ug
NzhlMTAxNjQ1NWFlODA0YSBdLS0tClsgICAgMC44NDIyMzVdIGF0b21pYzY0IHRlc3QgcGFz
c2VkIGZvciB4ODYtNjQgcGxhdGZvcm0gd2l0aCBDWDggYW5kIHdpdGggU1NFCi9rZXJuZWwv
eDg2XzY0LWxrcC1DT05GSUdfU0NIRURfREVCVUcvYzQyMDA4MmJmY2MwMGE5MDgzNjBlZGQ0
YmI1ODI2ZWNlMWM1OWFlNC9kbWVzZy1uZnNyb290LWFudC0xNDoyMDEzMTAxMDE0MDMwODp4
ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRzozLjEyLjAtcmM0LXdsLTAyMTY2LWdjNDIw
MDgyOjQxOAova2VybmVsL3g4Nl82NC1sa3AtQ09ORklHX1NDSEVEX0RFQlVHL2M0MjAwODJi
ZmNjMDBhOTA4MzYwZWRkNGJiNTgyNmVjZTFjNTlhZTQvZG1lc2ctbmZzcm9vdC1hbnQtOToy
MDEzMTAxMDE0MDIyMTp4ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRzozLjEyLjAtcmM0
LXdsLTAyMTY2LWdjNDIwMDgyOjQxOAova2VybmVsL3g4Nl82NC1sa3AtQ09ORklHX1NDSEVE
X0RFQlVHL2M0MjAwODJiZmNjMDBhOTA4MzYwZWRkNGJiNTgyNmVjZTFjNTlhZTQvZG1lc2ct
bmZzcm9vdC1pbm4tMTM6MjAxMzEwMTAxMzU1MDA6eDg2XzY0LWxrcC1DT05GSUdfU0NIRURf
REVCVUc6My4xMi4wLXJjNC13bC0wMjE2Ni1nYzQyMDA4Mjo0MTgKL2tlcm5lbC94ODZfNjQt
bGtwLUNPTkZJR19TQ0hFRF9ERUJVRy9jNDIwMDgyYmZjYzAwYTkwODM2MGVkZDRiYjU4MjZl
Y2UxYzU5YWU0L2RtZXNnLW5mc3Jvb3QtaW5uLTE4OjIwMTMxMDEwMTM1MzUyOng4Nl82NC1s
a3AtQ09ORklHX1NDSEVEX0RFQlVHOjMuMTIuMC1yYzQtd2wtMDIxNjYtZ2M0MjAwODI6NDE4
Ci9rZXJuZWwveDg2XzY0LWxrcC1DT05GSUdfU0NIRURfREVCVUcvYzQyMDA4MmJmY2MwMGE5
MDgzNjBlZGQ0YmI1ODI2ZWNlMWM1OWFlNC9kbWVzZy1uZnNyb290LWlubi0xOToyMDEzMTAx
MDEzNTUxMzp4ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRzozLjEyLjAtcmM0LXdsLTAy
MTY2LWdjNDIwMDgyOjQxOAova2VybmVsL3g4Nl82NC1sa3AtQ09ORklHX1NDSEVEX0RFQlVH
L2M0MjAwODJiZmNjMDBhOTA4MzYwZWRkNGJiNTgyNmVjZTFjNTlhZTQvZG1lc2ctbmZzcm9v
dC1pbm4tMjI6MjAxMzEwMTAxMzU0NDk6eDg2XzY0LWxrcC1DT05GSUdfU0NIRURfREVCVUc6
My4xMi4wLXJjNC13bC0wMjE2Ni1nYzQyMDA4Mjo0MTgKL2tlcm5lbC94ODZfNjQtbGtwLUNP
TkZJR19TQ0hFRF9ERUJVRy9jNDIwMDgyYmZjYzAwYTkwODM2MGVkZDRiYjU4MjZlY2UxYzU5
YWU0L2RtZXNnLW5mc3Jvb3QtaW5uLTI0OjIwMTMxMDEwMTM1NTIxOng4Nl82NC1sa3AtQ09O
RklHX1NDSEVEX0RFQlVHOjMuMTIuMC1yYzQtd2wtMDIxNjYtZ2M0MjAwODI6NDE4Ci9rZXJu
ZWwveDg2XzY0LWxrcC1DT05GSUdfU0NIRURfREVCVUcvYzQyMDA4MmJmY2MwMGE5MDgzNjBl
ZGQ0YmI1ODI2ZWNlMWM1OWFlNC9kbWVzZy1uZnNyb290LWlubi0yNjoyMDEzMTAxMDEzNTQ1
Nzp4ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRzozLjEyLjAtcmM0LXdsLTAyMTY2LWdj
NDIwMDgyOjQxOAova2VybmVsL3g4Nl82NC1sa3AtQ09ORklHX1NDSEVEX0RFQlVHL2M0MjAw
ODJiZmNjMDBhOTA4MzYwZWRkNGJiNTgyNmVjZTFjNTlhZTQvZG1lc2ctbmZzcm9vdC1pbm4t
Mjg6MjAxMzEwMTAxMzU1MDY6eDg2XzY0LWxrcC1DT05GSUdfU0NIRURfREVCVUc6My4xMi4w
LXJjNC13bC0wMjE2Ni1nYzQyMDA4Mjo0MTgKL2tlcm5lbC94ODZfNjQtbGtwLUNPTkZJR19T
Q0hFRF9ERUJVRy9jNDIwMDgyYmZjYzAwYTkwODM2MGVkZDRiYjU4MjZlY2UxYzU5YWU0L2Rt
ZXNnLW5mc3Jvb3QtaW5uLTc6MjAxMzEwMTAxMzU1MTM6eDg2XzY0LWxrcC1DT05GSUdfU0NI
RURfREVCVUc6My4xMi4wLXJjNC13bC0wMjE2Ni1nYzQyMDA4Mjo0MTgKL2tlcm5lbC94ODZf
NjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRy9jNDIwMDgyYmZjYzAwYTkwODM2MGVkZDRiYjU4
MjZlY2UxYzU5YWU0L2RtZXNnLW5mc3Jvb3QtbGtwLXR0MDItMTU6MjAxMzEwMTAwNDI3MTE6
eDg2XzY0LWxrcC1DT05GSUdfU0NIRURfREVCVUc6My4xMi4wLXJjNC13bC0wMjE2Ni1nYzQy
MDA4Mjo0MTgKL2tlcm5lbC94ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRy9jNDIwMDgy
YmZjYzAwYTkwODM2MGVkZDRiYjU4MjZlY2UxYzU5YWU0L2RtZXNnLW5mc3Jvb3Qtd2FpbWVh
LTExOjIwMTMxMDEwMjE1MzQzOng4Nl82NC1sa3AtQ09ORklHX1NDSEVEX0RFQlVHOjMuMTIu
MC1yYzQtd2wtMDIxNjYtZ2M0MjAwODI6NDE4Ci9rZXJuZWwveDg2XzY0LWxrcC1DT05GSUdf
U0NIRURfREVCVUcvYzQyMDA4MmJmY2MwMGE5MDgzNjBlZGQ0YmI1ODI2ZWNlMWM1OWFlNC9k
bWVzZy1uZnNyb290LXdhaW1lYS00OjIwMTMxMDEwMjE1NDI3Ong4Nl82NC1sa3AtQ09ORklH
X1NDSEVEX0RFQlVHOjMuMTIuMC1yYzQtd2wtMDIxNjYtZ2M0MjAwODI6NDE4Ci9rZXJuZWwv
eDg2XzY0LWxrcC1DT05GSUdfU0NIRURfREVCVUcvYzQyMDA4MmJmY2MwMGE5MDgzNjBlZGQ0
YmI1ODI2ZWNlMWM1OWFlNC9kbWVzZy1xdWFudGFsLWlubi0yNToyMDEzMTAxMDEzNTUyMTp4
ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRzozLjEyLjAtcmM0LXdsLTAyMTY2LWdjNDIw
MDgyOjQxOAova2VybmVsL3g4Nl82NC1sa3AtQ09ORklHX1NDSEVEX0RFQlVHL2M0MjAwODJi
ZmNjMDBhOTA4MzYwZWRkNGJiNTgyNmVjZTFjNTlhZTQvZG1lc2ctcXVhbnRhbC1pbm4tNDE6
MjAxMzEwMTAxMzU1MzQ6eDg2XzY0LWxrcC1DT05GSUdfU0NIRURfREVCVUc6My4xMi4wLXJj
NC13bC0wMjE2Ni1nYzQyMDA4Mjo0MTgKL2tlcm5lbC94ODZfNjQtbGtwLUNPTkZJR19TQ0hF
RF9ERUJVRy9jNDIwMDgyYmZjYzAwYTkwODM2MGVkZDRiYjU4MjZlY2UxYzU5YWU0L2RtZXNn
LXF1YW50YWwtbGtwLXR0MDItMTc6MjAxMzEwMTAwNDI3MjM6eDg2XzY0LWxrcC1DT05GSUdf
U0NIRURfREVCVUc6My4xMi4wLXJjNC13bC0wMjE2Ni1nYzQyMDA4Mjo0MTgKL2tlcm5lbC94
ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRy9jNDIwMDgyYmZjYzAwYTkwODM2MGVkZDRi
YjU4MjZlY2UxYzU5YWU0L2RtZXNnLXF1YW50YWwtbmhtNC0xOjIwMTMxMDEwMDYwMDU4Ong4
Nl82NC1sa3AtQ09ORklHX1NDSEVEX0RFQlVHOjMuMTIuMC1yYzQtd2wtMDIxNjYtZ2M0MjAw
ODI6NDE4Ci9rZXJuZWwveDg2XzY0LWxrcC1DT05GSUdfU0NIRURfREVCVUcvYzQyMDA4MmJm
Y2MwMGE5MDgzNjBlZGQ0YmI1ODI2ZWNlMWM1OWFlNC9kbWVzZy1xdWFudGFsLW5obTQtMzoy
MDEzMTAxMDA2MDEyOTp4ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRzozLjEyLjAtcmM0
LXdsLTAyMTY2LWdjNDIwMDgyOjQxOAova2VybmVsL3g4Nl82NC1sa3AtQ09ORklHX1NDSEVE
X0RFQlVHL2M0MjAwODJiZmNjMDBhOTA4MzYwZWRkNGJiNTgyNmVjZTFjNTlhZTQvZG1lc2ct
cXVhbnRhbC1zdG9ha2xleS02OjIwMTMxMDEwMTM1NDUzOng4Nl82NC1sa3AtQ09ORklHX1ND
SEVEX0RFQlVHOjMuMTIuMC1yYzQtd2wtMDIxNjYtZ2M0MjAwODI6NDE4Ci9rZXJuZWwveDg2
XzY0LWxrcC1DT05GSUdfU0NIRURfREVCVUcvYzQyMDA4MmJmY2MwMGE5MDgzNjBlZGQ0YmI1
ODI2ZWNlMWM1OWFlNC9kbWVzZy15b2N0by1uaG00LTI6MjAxMzEwMTAwNjAxMTk6eDg2XzY0
LWxrcC1DT05GSUdfU0NIRURfREVCVUc6My4xMi4wLXJjNC13bC0wMjE2Ni1nYzQyMDA4Mjo0
MTgKMDoyMDoyMCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtUkVQRUFUIENP
VU5UOiAyMCAgIyAvY2Mvd2ZnL25ldC1iaXNlY3QvLnJlcGVhdBtbMG0KCkJpc2VjdGluZzog
MTMgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDQgc3RlcHMp
ClszZjg5ODViOTc3ZmJhYjFiZjdkZGVhMDNiZjMxMTk0OWViY2E0YWZkXSBNZXJnZSByZW1v
dGUtdHJhY2tpbmcgYnJhbmNoICdyZWd1bGF0b3IvdG9waWMvdHBzNjU4NngnIGludG8gcmVn
dWxhdG9yLW5leHQKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9ob21lL3dmZy9uZXQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0veDg2XzY0LWxrcC1DT05GSUdfU0NIRURfREVCVUcvbGludXgtZGV2
ZWw6ZGV2ZWwtaG91cmx5LTIwMTMxMDEwMDc6M2Y4OTg1Yjk3N2ZiYWIxYmY3ZGRlYTAzYmYz
MTE5NDllYmNhNGFmZDpiaXNlY3QtbmV0CgoyMDEzLTEwLTEwLTE0OjEzOjE0IDNmODk4NWI5
NzdmYmFiMWJmN2RkZWEwM2JmMzExOTQ5ZWJjYTRhZmQgY29tcGlsaW5nCjIxMTggcmVhbCAg
MTcyNCB1c2VyICAxNDkgc3lzICA4OC40OCUgY3B1IAl4ODZfNjQtbGtwLUNPTkZJR19TQ0hF
RF9ERUJVRwoKMjAxMy0xMC0xMC0xNDo0OToyMSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEy
LjAtcmM0LTAwMTExLWczZjg5ODViLi4uLi4uCTUJMTIuCTE1CTE3LgkxOS4uLi4uLi4uLi4u
Li4uCTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogNiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgMyBzdGVwcykKWzc0MjU5MTBmZmZiMDhmNTQxZTRkMjgxOWM0
YWU3OTAwODk0ZmM1MDRdIHtPVVQtT0YtVFJFRS1ERUJVR306IFJlbW92ZSB0aGUgY2RiX29m
ZnNldCBjaGVjayBiZWNhdXNlIG9mIG9zYy1vc2QgYnVnCnJ1bm5pbmcgL2Mva2VybmVsLXRl
c3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbmV0L29iai1iaXNl
Y3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1sa3AtQ09ORklH
X1NDSEVEX0RFQlVHL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDEzMTAxMDA3Ojc0MjU5
MTBmZmZiMDhmNTQxZTRkMjgxOWM0YWU3OTAwODk0ZmM1MDQ6YmlzZWN0LW5ldAoKMjAxMy0x
MC0xMC0xNTowMzozMCA3NDI1OTEwZmZmYjA4ZjU0MWU0ZDI4MTljNGFlNzkwMDg5NGZjNTA0
IGNvbXBpbGluZwoyMDYyIHJlYWwgIDE3MTYgdXNlciAgMTQ5IHN5cyAgOTAuNDclIGNwdSAJ
eDg2XzY0LWxrcC1DT05GSUdfU0NIRURfREVCVUcKCjIwMTMtMTAtMTAtMTU6Mzg6NTQgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLTAwMDA3LWc3NDI1OTEwLi4uLi4uIFRFU1QgRkFJ
TFVSRQpbICAgIDAuMjAwMDExXSAgICBnZW5lcmljX3NzZTogICAxNzYuMzMzIE1CL3NlYwpb
ICAgIDAuMjAxMzI0XSB4b3I6IHVzaW5nIGZ1bmN0aW9uOiBnZW5lcmljX3NzZSAoMTc2LjMz
MyBNQi9zZWMpClsgICAgMC4yMDMwMDVdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0t
LS0tLS0tLQpbICAgIDAuMjA0MDA5XSBXQVJOSU5HOiBDUFU6IDAgUElEOiAxIGF0IGluaXQv
bWFpbi5jOjY5OSBkb19vbmVfaW5pdGNhbGwrMHgxMjgvMHgxMzgoKQpbICAgIDAuMjA2NjUz
XSBpbml0Y2FsbCBjYWxpYnJhdGVfeG9yX2Jsb2NrcysweDAvMHgxMjggcmV0dXJuZWQgd2l0
aCBwcmVlbXB0aW9uIGltYmFsYW5jZSAKWyAgICAwLjIwODAwM10gTW9kdWxlcyBsaW5rZWQg
aW46ClsgICAgMC4yMDkyMTNdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0
YWludGVkIDMuMTEuMC0wMDAwNy1nNzQyNTkxMCAjNDIwClsgICAgMC4yMTIwMDRdIEhhcmR3
YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAwLjIx
MzU0OF0gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAxZGY0N2UwMCBmZmZmZmZmZjgxYTBj
MTY1IGZmZmY4ODAwMWRmNDdlNDgKWyAgICAwLjIxNzQxNl0gIGZmZmY4ODAwMWRmNDdlMzgg
ZmZmZmZmZmY4MTBjMjJhZCBmZmZmZmZmZjgxMDAwMzE1IGZmZmZmZmZmODI1NjIzYzAKWyAg
ICAwLjIyMDAwM10gIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgw
MDFkZjQ3ZmQ4IGZmZmY4ODAwMWRmNDdlOTgKWyAgICAwLjIyMjkzNl0gQ2FsbCBUcmFjZToK
WyAgICAwLjIyNDAxMV0gIFs8ZmZmZmZmZmY4MWEwYzE2NT5dIGR1bXBfc3RhY2srMHg1NC8w
eDc0ClsgICAgMC4yMjU1OTBdICBbPGZmZmZmZmZmODEwYzIyYWQ+XSB3YXJuX3Nsb3dwYXRo
X2NvbW1vbisweDdmLzB4OTgKWyAgICAwLjIyNzE4NV0gIFs8ZmZmZmZmZmY4MTAwMDMxNT5d
ID8gZG9fb25lX2luaXRjYWxsKzB4MTI4LzB4MTM4ClsgICAgMC4yMjgwMDddICBbPGZmZmZm
ZmZmODI1NjIzYzA+XSA/IGRvX3hvcl9zcGVlZCsweGUyLzB4ZTIKWyAgICAwLjIyOTUwM10g
IFs8ZmZmZmZmZmY4MTBjMjMxMj5dIHdhcm5fc2xvd3BhdGhfZm10KzB4NGMvMHg0ZQpbICAg
IDAuMjMyMDA3XSAgWzxmZmZmZmZmZjgxMTcxZWIwPl0gPyBmcmVlX3BhZ2VzKzB4NDUvMHg0
NwpbICAgIDAuMjMzNTIzXSAgWzxmZmZmZmZmZjgyNTYyM2MwPl0gPyBkb194b3Jfc3BlZWQr
MHhlMi8weGUyClsgICAgMC4yMzUxNDhdICBbPGZmZmZmZmZmODEwMDAzMTU+XSBkb19vbmVf
aW5pdGNhbGwrMHgxMjgvMHgxMzgKWyAgICAwLjIzNjAwN10gIFs8ZmZmZmZmZmY4MjUyN2Vk
Mz5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MTU5LzB4MWRhClsgICAgMC4yMzc3NjldICBb
PGZmZmZmZmZmODI1Mjc3NGQ+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4ODgvMHg4OApbICAgIDAu
MjQwMDA3XSAgWzxmZmZmZmZmZjgxOWZjNjA3Pl0gPyByZXN0X2luaXQrMHhkYi8weGRiClsg
ICAgMC4yNDE1OThdICBbPGZmZmZmZmZmODE5ZmM2MTU+XSBrZXJuZWxfaW5pdCsweGUvMHhk
YgpbICAgIDAuMjQzMDUxXSAgWzxmZmZmZmZmZjgxYTFmNDZjPl0gcmV0X2Zyb21fZm9yaysw
eDdjLzB4YjAKWyAgICAwLjI0NDAwNl0gIFs8ZmZmZmZmZmY4MTlmYzYwNz5dID8gcmVzdF9p
bml0KzB4ZGIvMHhkYgpbICAgIDAuMjQ1NTcyXSAtLS1bIGVuZCB0cmFjZSAyMDJlNWJkYjg2
MGJlYTQ0IF0tLS0KWyAgICAwLjI0ODAwNl0gYXRvbWljNjQgdGVzdCBwYXNzZWQgZm9yIHg4
Ni02NCBwbGF0Zm9ybSB3aXRoIENYOCBhbmQgd2l0aCBTU0UKL2tlcm5lbC94ODZfNjQtbGtw
LUNPTkZJR19TQ0hFRF9ERUJVRy83NDI1OTEwZmZmYjA4ZjU0MWU0ZDI4MTljNGFlNzkwMDg5
NGZjNTA0L2RtZXNnLW5mc3Jvb3Qtd2FpbWVhLTM6MjAxMzEwMTAyMzQwMjM6eDg2XzY0LWxr
cC1DT05GSUdfU0NIRURfREVCVUc6My4xMS4wLTAwMDA3LWc3NDI1OTEwOjQyMAova2VybmVs
L3g4Nl82NC1sa3AtQ09ORklHX1NDSEVEX0RFQlVHLzc0MjU5MTBmZmZiMDhmNTQxZTRkMjgx
OWM0YWU3OTAwODk0ZmM1MDQvZG1lc2ctbmZzcm9vdC13YWltZWEtMjoyMDEzMTAxMDIzNDAz
OTp4ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRzozLjExLjAtMDAwMDctZzc0MjU5MTA6
NDIwCi9rZXJuZWwveDg2XzY0LWxrcC1DT05GSUdfU0NIRURfREVCVUcvNzQyNTkxMGZmZmIw
OGY1NDFlNGQyODE5YzRhZTc5MDA4OTRmYzUwNC9kbWVzZy1uZnNyb290LXdhaW1lYS05OjIw
MTMxMDEwMjM0MDQyOng4Nl82NC1sa3AtQ09ORklHX1NDSEVEX0RFQlVHOjMuMTEuMC0wMDAw
Ny1nNzQyNTkxMDo0MjAKMDozOjEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2Vj
dGluZzogMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMiBz
dGVwcykKWzcxZTZiYjRiNzdjNDc4MjY0MmIzY2I2YjRmOTM2OTE5MWUwOGI5MzRdIHBuZnNf
b3NkX3hkcl9zcnYgKHByaXZhdGUpOiBBZGQgcG5mcy1vYmplY3RzIHNlcnZlciBzaWRlIFhE
UiBlbmNvZGluZy9kZWNvZGluZwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVz
dC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL25ldC9vYmotYmlzZWN0CmxzIC1hIC9rZXJu
ZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRy9s
aW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxMzEwMTAwNzo3MWU2YmI0Yjc3YzQ3ODI2NDJi
M2NiNmI0ZjkzNjkxOTFlMDhiOTM0OmJpc2VjdC1uZXQKCjIwMTMtMTAtMTAtMTU6NDI6MDMg
NzFlNmJiNGI3N2M0NzgyNjQyYjNjYjZiNGY5MzY5MTkxZTA4YjkzNCBjb21waWxpbmcKNTQg
cmVhbCAgNDIgdXNlciAgMTAgc3lzICA5Ni43MSUgY3B1IAl4ODZfNjQtbGtwLUNPTkZJR19T
Q0hFRF9ERUJVRwoKMjAxMy0xMC0xMC0xNTo0NTo1NiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAz
LjExLjAtMDAwMDMtZzcxZTZiYjQuLi4uLi4gVEVTVCBGQUlMVVJFClsgICAgMC4yNTIwMThd
ICAgIGdlbmVyaWNfc3NlOiAgNjYyMy42NjYgTUIvc2VjClsgICAgMC4yNTM4MDldIHhvcjog
dXNpbmcgZnVuY3Rpb246IHByZWZldGNoNjQtc3NlICg3MTg5LjY2NiBNQi9zZWMpClsgICAg
MC4yNTU4MTFdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDAu
MjU2MDE4XSBXQVJOSU5HOiBDUFU6IDAgUElEOiAxIGF0IGluaXQvbWFpbi5jOjY5OSBkb19v
bmVfaW5pdGNhbGwrMHgxMjgvMHgxMzgoKQpbICAgIDAuMjYwMDE2XSBpbml0Y2FsbCBjYWxp
YnJhdGVfeG9yX2Jsb2NrcysweDAvMHgxMjggcmV0dXJuZWQgd2l0aCBwcmVlbXB0aW9uIGlt
YmFsYW5jZSAKWyAgICAwLjI2NDAxMF0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMC4yNjU2
MzJdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTEuMC0w
MDAwMy1nNzFlNmJiNCAjNDIxClsgICAgMC4yNjgwMTldIEhhcmR3YXJlIG5hbWU6IEJvY2hz
IEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAwLjI3MDA4OV0gIDAwMDAwMDAw
MDAwMDAwMDAgZmZmZjg4MDAxZGY0N2UwMCBmZmZmZmZmZjgxYTBjMTY1IGZmZmY4ODAwMWRm
NDdlNDgKWyAgICAwLjI3NDU4MV0gIGZmZmY4ODAwMWRmNDdlMzggZmZmZmZmZmY4MTBjMjJh
ZCBmZmZmZmZmZjgxMDAwMzE1IGZmZmZmZmZmODI1NjIzYzAKWyAgICAwLjI3Nzk4Nl0gIDAw
MDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDFkZjQ3ZmQ4IGZmZmY4
ODAwMWRmNDdlOTgKWyAgICAwLjI4MDg2MF0gQ2FsbCBUcmFjZToKWyAgICAwLjI4MjIzOF0g
IFs8ZmZmZmZmZmY4MWEwYzE2NT5dIGR1bXBfc3RhY2srMHg1NC8weDc0ClsgICAgMC4yODQw
MTRdICBbPGZmZmZmZmZmODEwYzIyYWQ+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDdmLzB4
OTgKWyAgICAwLjI4NjEzNV0gIFs8ZmZmZmZmZmY4MTAwMDMxNT5dID8gZG9fb25lX2luaXRj
YWxsKzB4MTI4LzB4MTM4ClsgICAgMC4yODgwMTVdICBbPGZmZmZmZmZmODI1NjIzYzA+XSA/
IGRvX3hvcl9zcGVlZCsweGUyLzB4ZTIKWyAgICAwLjI5MDAxOV0gIFs8ZmZmZmZmZmY4MTBj
MjMxMj5dIHdhcm5fc2xvd3BhdGhfZm10KzB4NGMvMHg0ZQpbICAgIDAuMjkyMDE0XSAgWzxm
ZmZmZmZmZjgxMTcxZWIwPl0gPyBmcmVlX3BhZ2VzKzB4NDUvMHg0NwpbICAgIDAuMjkzOTcy
XSAgWzxmZmZmZmZmZjgyNTYyM2MwPl0gPyBkb194b3Jfc3BlZWQrMHhlMi8weGUyClsgICAg
MC4yOTYwMTRdICBbPGZmZmZmZmZmODEwMDAzMTU+XSBkb19vbmVfaW5pdGNhbGwrMHgxMjgv
MHgxMzgKWyAgICAwLjI5ODA4MF0gIFs8ZmZmZmZmZmY4MjUyN2VkMz5dIGtlcm5lbF9pbml0
X2ZyZWVhYmxlKzB4MTU5LzB4MWRhClsgICAgMC4zMDAwMTJdICBbPGZmZmZmZmZmODI1Mjc3
NGQ+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4ODgvMHg4OApbICAgIDAuMzAxOTk0XSAgWzxmZmZm
ZmZmZjgxOWZjNjA3Pl0gPyByZXN0X2luaXQrMHhkYi8weGRiClsgICAgMC4zMDQwMTNdICBb
PGZmZmZmZmZmODE5ZmM2MTU+XSBrZXJuZWxfaW5pdCsweGUvMHhkYgpbICAgIDAuMzA1OTE0
XSAgWzxmZmZmZmZmZjgxYTFmNDZjPl0gcmV0X2Zyb21fZm9yaysweDdjLzB4YjAKWyAgICAw
LjMwODAxN10gIFs8ZmZmZmZmZmY4MTlmYzYwNz5dID8gcmVzdF9pbml0KzB4ZGIvMHhkYgpb
ICAgIDAuMzEwMDM3XSAtLS1bIGVuZCB0cmFjZSBhYzQ5NmNkNGNhYzY1MGMxIF0tLS0KWyAg
ICAwLjMxMjAxMV0gYXRvbWljNjQgdGVzdCBwYXNzZWQgZm9yIHg4Ni02NCBwbGF0Zm9ybSB3
aXRoIENYOCBhbmQgd2l0aCBTU0UKL2tlcm5lbC94ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9E
RUJVRy83MWU2YmI0Yjc3YzQ3ODI2NDJiM2NiNmI0ZjkzNjkxOTFlMDhiOTM0L2RtZXNnLW5m
c3Jvb3QtYXRoZW5zLTEwOjIwMTMxMDEwMTU0ODUwOng4Nl82NC1sa3AtQ09ORklHX1NDSEVE
X0RFQlVHOjMuMTEuMC0wMDAwMy1nNzFlNmJiNDo0MjEKMDoxOjEgYWxsX2dvb2Q6YmFkOmFs
bF9iYWQgYm9vdHMKG1sxOzM1bVJFUEVBVCBDT1VOVDogMjAgICMgL2NjL3dmZy9uZXQtYmlz
ZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDEgc3RlcCkKWzIwNTQ1NTM2Y2Q4ZWE5NDljNjE1MjdiNjM5
NWVjOGMwZDJjMjM3YjFdIFJGQzogZG9feG9yX3NwZWVkIEJyb2tlbiBvbiBVTUwgZG8gdG8g
amlmZmllcwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1
cmUuc2ggL2hvbWUvd2ZnL25ldC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVu
LXF1ZXVlL2t2bS94ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRy9saW51eC1kZXZlbDpk
ZXZlbC1ob3VybHktMjAxMzEwMTAwNzoyMDU0NTUzNmNkOGVhOTQ5YzYxNTI3YjYzOTVlYzhj
MGQyYzIzN2IxOmJpc2VjdC1uZXQKCjIwMTMtMTAtMTAtMTU6NDk6MTEgMjA1NDU1MzZjZDhl
YTk0OWM2MTUyN2I2Mzk1ZWM4YzBkMmMyMzdiMSBjb21waWxpbmcKMjAyIHJlYWwgIDQ0IHVz
ZXIgIDEwIHN5cyAgMjYuOTElIGNwdSAJeDg2XzY0LWxrcC1DT05GSUdfU0NIRURfREVCVUcK
CjIwMTMtMTAtMTAtMTU6NTk6MjQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLTAwMDAy
LWcyMDU0NTUzLi4uLi4uLi4gVEVTVCBGQUlMVVJFClsgICAgMC4yNjQwMDldICAgIGdlbmVy
aWNfc3NlOiAgNjQ4My4zMzMgTUIvc2VjClsgICAgMC4yNjU4NzBdIHhvcjogdXNpbmcgZnVu
Y3Rpb246IHByZWZldGNoNjQtc3NlICg2NjYwLjAwMCBNQi9zZWMpClsgICAgMC4yNjgwMDdd
IC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDAuMjY5OTI5XSBX
QVJOSU5HOiBDUFU6IDAgUElEOiAxIGF0IGluaXQvbWFpbi5jOjY5OSBkb19vbmVfaW5pdGNh
bGwrMHgxMjgvMHgxMzgoKQpbICAgIDAuMjcyMDEwXSBpbml0Y2FsbCBjYWxpYnJhdGVfeG9y
X2Jsb2NrcysweDAvMHgxMjggcmV0dXJuZWQgd2l0aCBwcmVlbXB0aW9uIGltYmFsYW5jZSAK
WyAgICAwLjI3NjAwNF0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMC4yNzc4MzRdIENQVTog
MCBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTEuMC0wMDAwMi1nMjA1
NDU1MyAjNDIyClsgICAgMC4yODAwMDVdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBC
SU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAwLjI4NDAwNF0gIDAwMDAwMDAwMDAwMDAwMDAg
ZmZmZjg4MDAxZGY0N2UwMCBmZmZmZmZmZjgxYTBjMTY1IGZmZmY4ODAwMWRmNDdlNDgKWyAg
ICAwLjI4ODAwNF0gIGZmZmY4ODAwMWRmNDdlMzggZmZmZmZmZmY4MTBjMjJhZCBmZmZmZmZm
ZjgxMDAwMzE1IGZmZmZmZmZmODI1NjIzYzAKWyAgICAwLjI5MjAwNV0gIDAwMDAwMDAwMDAw
MDAwMDAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDFkZjQ3ZmQ4IGZmZmY4ODAwMWRmNDdl
OTgKWyAgICAwLjI5NjAwNF0gQ2FsbCBUcmFjZToKWyAgICAwLjI5NzM3Nl0gIFs8ZmZmZmZm
ZmY4MWEwYzE2NT5dIGR1bXBfc3RhY2srMHg1NC8weDc0ClsgICAgMC4yOTk0MjFdICBbPGZm
ZmZmZmZmODEwYzIyYWQ+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDdmLzB4OTgKWyAgICAw
LjMwMDAwOF0gIFs8ZmZmZmZmZmY4MTAwMDMxNT5dID8gZG9fb25lX2luaXRjYWxsKzB4MTI4
LzB4MTM4ClsgICAgMC4zMDQwMDddICBbPGZmZmZmZmZmODI1NjIzYzA+XSA/IGRvX3hvcl9z
cGVlZCsweGUyLzB4ZTIKWyAgICAwLjMwNjE2N10gIFs8ZmZmZmZmZmY4MTBjMjMxMj5dIHdh
cm5fc2xvd3BhdGhfZm10KzB4NGMvMHg0ZQpbICAgIDAuMzA4MDA5XSAgWzxmZmZmZmZmZjgx
MTcxZWIwPl0gPyBmcmVlX3BhZ2VzKzB4NDUvMHg0NwpbICAgIDAuMzEwMDc4XSAgWzxmZmZm
ZmZmZjgyNTYyM2MwPl0gPyBkb194b3Jfc3BlZWQrMHhlMi8weGUyClsgICAgMC4zMTIwMDdd
ICBbPGZmZmZmZmZmODEwMDAzMTU+XSBkb19vbmVfaW5pdGNhbGwrMHgxMjgvMHgxMzgKWyAg
ICAwLjMxNDE3N10gIFs8ZmZmZmZmZmY4MjUyN2VkMz5dIGtlcm5lbF9pbml0X2ZyZWVhYmxl
KzB4MTU5LzB4MWRhClsgICAgMC4zMTYwMDddICBbPGZmZmZmZmZmODI1Mjc3NGQ+XSA/IGRv
X2Vhcmx5X3BhcmFtKzB4ODgvMHg4OApbICAgIDAuMzE4MTk2XSAgWzxmZmZmZmZmZjgxOWZj
NjA3Pl0gPyByZXN0X2luaXQrMHhkYi8weGRiClsgICAgMC4zMjAwMDhdICBbPGZmZmZmZmZm
ODE5ZmM2MTU+XSBrZXJuZWxfaW5pdCsweGUvMHhkYgpbICAgIDAuMzIyMDM3XSAgWzxmZmZm
ZmZmZjgxYTFmNDZjPl0gcmV0X2Zyb21fZm9yaysweDdjLzB4YjAKWyAgICAwLjMyNDAwOF0g
IFs8ZmZmZmZmZmY4MTlmYzYwNz5dID8gcmVzdF9pbml0KzB4ZGIvMHhkYgpbICAgIDAuMzI2
MDc2XSAtLS1bIGVuZCB0cmFjZSA5NzY4MTI1OGVmMTA2MjkwIF0tLS0KWyAgICAwLjMyODAw
OF0gYXRvbWljNjQgdGVzdCBwYXNzZWQgZm9yIHg4Ni02NCBwbGF0Zm9ybSB3aXRoIENYOCBh
bmQgd2l0aCBTU0UKL2tlcm5lbC94ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRy8yMDU0
NTUzNmNkOGVhOTQ5YzYxNTI3YjYzOTVlYzhjMGQyYzIzN2IxL2RtZXNnLW5mc3Jvb3Qtc25i
LTg6MjAxMzEwMTAxNjAyMjU6eDg2XzY0LWxrcC1DT05GSUdfU0NIRURfREVCVUc6My4xMS4w
LTAwMDAyLWcyMDU0NTUzOjQyMgova2VybmVsL3g4Nl82NC1sa3AtQ09ORklHX1NDSEVEX0RF
QlVHLzIwNTQ1NTM2Y2Q4ZWE5NDljNjE1MjdiNjM5NWVjOGMwZDJjMjM3YjEvZG1lc2ctbmZz
cm9vdC13YWltZWEtMTI6MjAxMzEwMTEwMDAxMjY6eDg2XzY0LWxrcC1DT05GSUdfU0NIRURf
REVCVUc6My4xMS4wLTAwMDAyLWcyMDU0NTUzOjQyMgova2VybmVsL3g4Nl82NC1sa3AtQ09O
RklHX1NDSEVEX0RFQlVHLzIwNTQ1NTM2Y2Q4ZWE5NDljNjE1MjdiNjM5NWVjOGMwZDJjMjM3
YjEvZG1lc2ctbmZzcm9vdC13YWltZWEtMzoyMDEzMTAxMTAwMDExODp4ODZfNjQtbGtwLUNP
TkZJR19TQ0hFRF9ERUJVRzozLjExLjAtMDAwMDItZzIwNTQ1NTM6NDIyCi9rZXJuZWwveDg2
XzY0LWxrcC1DT05GSUdfU0NIRURfREVCVUcvMjA1NDU1MzZjZDhlYTk0OWM2MTUyN2I2Mzk1
ZWM4YzBkMmMyMzdiMS9kbWVzZy1uZnNyb290LXdhaW1lYS02OjIwMTMxMDExMDAwMTA0Ong4
Nl82NC1sa3AtQ09ORklHX1NDSEVEX0RFQlVHOjMuMTEuMC0wMDAwMi1nMjA1NDU1Mzo0MjIK
L2tlcm5lbC94ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRy8yMDU0NTUzNmNkOGVhOTQ5
YzYxNTI3YjYzOTVlYzhjMGQyYzIzN2IxL2RtZXNnLXF1YW50YWwtbGtwLXN0MDEtNjoyMDEz
MTAxMDE2MDI0MDp4ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRzozLjExLjAtMDAwMDIt
ZzIwNTQ1NTM6NDIyCi9rZXJuZWwveDg2XzY0LWxrcC1DT05GSUdfU0NIRURfREVCVUcvMjA1
NDU1MzZjZDhlYTk0OWM2MTUyN2I2Mzk1ZWM4YzBkMmMyMzdiMS9kbWVzZy1xdWFudGFsLW5o
bTQtMToyMDEzMTAxMDA4MDgzNzp4ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRzozLjEx
LjAtMDAwMDItZzIwNTQ1NTM6NDIyCi9rZXJuZWwveDg2XzY0LWxrcC1DT05GSUdfU0NIRURf
REVCVUcvMjA1NDU1MzZjZDhlYTk0OWM2MTUyN2I2Mzk1ZWM4YzBkMmMyMzdiMS9kbWVzZy1x
dWFudGFsLXNuYi0yOjIwMTMxMDEwMTYwMjMzOng4Nl82NC1sa3AtQ09ORklHX1NDSEVEX0RF
QlVHOjMuMTEuMC0wMDAwMi1nMjA1NDU1Mzo0MjIKL2tlcm5lbC94ODZfNjQtbGtwLUNPTkZJ
R19TQ0hFRF9ERUJVRy8yMDU0NTUzNmNkOGVhOTQ5YzYxNTI3YjYzOTVlYzhjMGQyYzIzN2Ix
L2RtZXNnLXF1YW50YWwtd2FpbWVhLTExOjIwMTMxMDExMDAwMTIzOng4Nl82NC1sa3AtQ09O
RklHX1NDSEVEX0RFQlVHOjMuMTEuMC0wMDAwMi1nMjA1NDU1Mzo0MjIKL2tlcm5lbC94ODZf
NjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRy8yMDU0NTUzNmNkOGVhOTQ5YzYxNTI3YjYzOTVl
YzhjMGQyYzIzN2IxL2RtZXNnLXF1YW50YWwtd2FpbWVhLTE1OjIwMTMxMDExMDAwMTE5Ong4
Nl82NC1sa3AtQ09ORklHX1NDSEVEX0RFQlVHOjMuMTEuMC0wMDAwMi1nMjA1NDU1Mzo0MjIK
L2tlcm5lbC94ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRy8yMDU0NTUzNmNkOGVhOTQ5
YzYxNTI3YjYzOTVlYzhjMGQyYzIzN2IxL2RtZXNnLXF1YW50YWwteGJtLTE6MjAxMzEwMTAy
MzU0MDI6eDg2XzY0LWxrcC1DT05GSUdfU0NIRURfREVCVUc6My4xMS4wLTAwMDAyLWcyMDU0
NTUzOjQyMgova2VybmVsL3g4Nl82NC1sa3AtQ09ORklHX1NDSEVEX0RFQlVHLzIwNTQ1NTM2
Y2Q4ZWE5NDljNjE1MjdiNjM5NWVjOGMwZDJjMjM3YjEvZG1lc2cteW9jdG8tbmhtNC0xOjIw
MTMxMDEwMDgwODQxOng4Nl82NC1sa3AtQ09ORklHX1NDSEVEX0RFQlVHOjMuMTEuMC0wMDAw
Mi1nMjA1NDU1Mzo0MjIKL2tlcm5lbC94ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRy8y
MDU0NTUzNmNkOGVhOTQ5YzYxNTI3YjYzOTVlYzhjMGQyYzIzN2IxL2RtZXNnLXlvY3RvLXdh
aW1lYS0zOjIwMTMxMDExMDAwMTE1Ong4Nl82NC1sa3AtQ09ORklHX1NDSEVEX0RFQlVHOjMu
MTEuMC0wMDAwMi1nMjA1NDU1Mzo0MjIKL2tlcm5lbC94ODZfNjQtbGtwLUNPTkZJR19TQ0hF
RF9ERUJVRy8yMDU0NTUzNmNkOGVhOTQ5YzYxNTI3YjYzOTVlYzhjMGQyYzIzN2IxL2RtZXNn
LW5mc3Jvb3QtbGtwLXR0MDItMTA6MjAxMzEwMTAwNjM1MDU6eDg2XzY0LWxrcC1DT05GSUdf
U0NIRURfREVCVUc6My4xMS4wLTAwMDAyLWcyMDU0NTUzOjQyMgova2VybmVsL3g4Nl82NC1s
a3AtQ09ORklHX1NDSEVEX0RFQlVHLzIwNTQ1NTM2Y2Q4ZWE5NDljNjE1MjdiNjM5NWVjOGMw
ZDJjMjM3YjEvZG1lc2ctbmZzcm9vdC1sa3AtdHQwMi0zOjIwMTMxMDEwMDYzNDU4Ong4Nl82
NC1sa3AtQ09ORklHX1NDSEVEX0RFQlVHOjMuMTEuMC0wMDAwMi1nMjA1NDU1Mzo0MjIKL2tl
cm5lbC94ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRy8yMDU0NTUzNmNkOGVhOTQ5YzYx
NTI3YjYzOTVlYzhjMGQyYzIzN2IxL2RtZXNnLXF1YW50YWwtbGtwLXR0MDItMjI6MjAxMzEw
MTAwNjM0NTc6eDg2XzY0LWxrcC1DT05GSUdfU0NIRURfREVCVUc6My4xMS4wLTAwMDAyLWcy
MDU0NTUzOjQyMgova2VybmVsL3g4Nl82NC1sa3AtQ09ORklHX1NDSEVEX0RFQlVHLzIwNTQ1
NTM2Y2Q4ZWE5NDljNjE1MjdiNjM5NWVjOGMwZDJjMjM3YjEvZG1lc2ctcXVhbnRhbC1sa3At
dHQwMi04OjIwMTMxMDEwMDYzNTA5Ong4Nl82NC1sa3AtQ09ORklHX1NDSEVEX0RFQlVHOjMu
MTEuMC0wMDAwMi1nMjA1NDU1Mzo0MjIKL2tlcm5lbC94ODZfNjQtbGtwLUNPTkZJR19TQ0hF
RF9ERUJVRy8yMDU0NTUzNmNkOGVhOTQ5YzYxNTI3YjYzOTVlYzhjMGQyYzIzN2IxL2RtZXNn
LXlvY3RvLWJlbnMtMzoyMDEzMTAxMDE2MDI1Mjp4ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9E
RUJVRzozLjExLjAtMDAwMDItZzIwNTQ1NTM6NDIyCi9rZXJuZWwveDg2XzY0LWxrcC1DT05G
SUdfU0NIRURfREVCVUcvMjA1NDU1MzZjZDhlYTk0OWM2MTUyN2I2Mzk1ZWM4YzBkMmMyMzdi
MS9kbWVzZy15b2N0by1pbm4tMjA6MjAxMzEwMTAxNjAyNDg6eDg2XzY0LWxrcC1DT05GSUdf
U0NIRURfREVCVUc6My4xMS4wLTAwMDAyLWcyMDU0NTUzOjQyMgova2VybmVsL3g4Nl82NC1s
a3AtQ09ORklHX1NDSEVEX0RFQlVHLzIwNTQ1NTM2Y2Q4ZWE5NDljNjE1MjdiNjM5NWVjOGMw
ZDJjMjM3YjEvZG1lc2cteW9jdG8tbGtwLXN0MDEtMTI6MjAxMzEwMTAxNjAyNTM6eDg2XzY0
LWxrcC1DT05GSUdfU0NIRURfREVCVUc6My4xMS4wLTAwMDAyLWcyMDU0NTUzOjQyMgowOjE5
OjE2IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25z
IGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDAgc3RlcHMpCls0YTlhNGIzNTI4
YWZjZTQ4ZDNmNGIxYzA3Yjk4ODA0MGU3ODExMmUyXSBwbmZzOiBQcm9wZXIgZGVsYXkgZm9y
IE5GUzRFUlJfUkVDQUxMQ09ORkxJQ1QgaW4gbGF5b3V0X2dldF9kb25lCnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbmV0
L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1s
a3AtQ09ORklHX1NDSEVEX0RFQlVHL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDEzMTAx
MDA3OjRhOWE0YjM1MjhhZmNlNDhkM2Y0YjFjMDdiOTg4MDQwZTc4MTEyZTI6YmlzZWN0LW5l
dAoKMjAxMy0xMC0xMC0xNjowMzoyOCA0YTlhNGIzNTI4YWZjZTQ4ZDNmNGIxYzA3Yjk4ODA0
MGU3ODExMmUyIGNvbXBpbGluZwoyMjggcmVhbCAgNDQgdXNlciAgOSBzeXMgIDIzLjUzJSBj
cHUgCXg4Nl82NC1sa3AtQ09ORklHX1NDSEVEX0RFQlVHCgoyMDEzLTEwLTEwLTE2OjExOjUy
IGRldGVjdGluZyBib290IHN0YXRlIDMuMTEuMC0wMDAwMS1nNGE5YTRiMy4uLi4uCTE5Li4u
Li4uLi4uLi4uLi4uCTIwIFNVQ0NFU1MKCjIwNTQ1NTM2Y2Q4ZWE5NDljNjE1MjdiNjM5NWVj
OGMwZDJjMjM3YjEgaXMgdGhlIGZpcnN0IGJhZCBjb21taXQKY29tbWl0IDIwNTQ1NTM2Y2Q4
ZWE5NDljNjE1MjdiNjM5NWVjOGMwZDJjMjM3YjEKQXV0aG9yOiBCb2F6IEhhcnJvc2ggPGJo
YXJyb3NoQHBhbmFzYXMuY29tPgpEYXRlOiAgIFRodSBKdWwgMTkgMTU6MjI6MzcgMjAxMiAr
MDMwMAoKICAgIFJGQzogZG9feG9yX3NwZWVkIEJyb2tlbiBvbiBVTUwgZG8gdG8gamlmZmll
cwogICAgCiAgICBSZW1lbWJlciB0aGF0IGhhbmcgSSByZXBvcnRlZCBhIHdoaWxlIGJhY2sg
b24gVU1MLiBXZWxsCiAgICBJJ20gYXQgaXQgYWdhaW4sIGFuZCBpdCBzdGlsbCBoYW5ncyBh
bmQgSSBmb3VuZCB3aHkuCiAgICAKICAgIEkgaGF2ZSBkcHJpbnRlZCBqaWZmaWVzIGFuZCBp
dCBuZXZlciBhZHZhbmNlcyBkdXJpbmcgdGhlCiAgICBsb29wIGF0IGRvX3hvcl9zcGVlZC4g
VGhlcmUgZm9yIGl0IGlzIHN0dWNrIGluIGFuIGVuZGxlc3MKICAgIGxvb3AuIEkgaGF2ZSBh
bHNvIGRwcmludGVkIGN1cnJlbnRfa2VybmVsX3RpbWUoKSBhbmQgaXQKICAgIHJldHVybnMg
dGhlIHNhbWUgY29uc3RhbnQgdmFsdWUgYXMgd2VsbC4KICAgIAogICAgTm90ZSB0aGF0IGl0
IGRvZXMgdXN1YWxseSB3b3JrIG9uIFVNTCwgb25seSBkdXJpbmcKICAgIHRoZSBtb2Rwcm9i
ZSBvZiB4b3Iua28gd2hpbGUgdGhhdCB0ZXN0IGlzIHJ1bm5pbmcuIEl0IGxvb2tzCiAgICBs
aWtlIHNvbWUgbHVja2luZyBpcyBwcmV2ZW50aW5nIHRoZSBjbG9jayBmcm9tIHRpY2tpbmcu
CiAgICAKICAgIEhvd2V2ZXIga3RpbWVfZ2V0X3RzIGRvZXMgd29yayBmb3IgbWUgc28gSSBj
aGFuZ2VkIHRoZSBjb2RlCiAgICBhcyBiZWxvdywgc28gSSBjYW4gd29yay4gU2VlIGhvdyBJ
IHB1dCBzZXZlcmFsIHNhZmV0eQogICAgZ3VhcmRzLCB0byBuZXZlciBnZXQgaGFuZ3MgYWdh
aW4uCiAgICBBbmQgSSB0aGluayBteSB0aW1lIGJhc2VkIGFwcHJvYWNoIGlzIG1vcmUgYWNj
dXJhdGUgdGhlbgogICAgcHJldmlvdXMgc3lzdGVtLgogICAgCiAgICBVTUwgZ3V5cyBwbGVh
c2UgaW52ZXN0aWdhdGUgdGhlIGppZmZpZXMgaXNzdWU/IHdoYXQgaXMKICAgIHhvci5rbyBu
b3QgZG9pbmcgcmlnaHQ/CiAgICAKICAgIFNpZ25lZC1vZmYtYnk6IEJvYXogSGFycm9zaCA8
YmhhcnJvc2hAcGFuYXNhcy5jb20+Cgo6MDQwMDAwIDA0MDAwMCBjNjA4NmRjMThiZDI0YTg3
YzJmMGQ2MTgxYTQ3MDVjNGI3NDNlZGFkIDM4MTRkMjQ3MTk3NTYyMjdkMTVkYjEyNThjZDQ3
MjZjZGVlMzZjMDcgTQljcnlwdG8KYmlzZWN0IHJ1biBzdWNjZXNzCmxzIC1hIC9rZXJuZWwt
dGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRy9saW51
eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxMzEwMTAwNzo0YTlhNGIzNTI4YWZjZTQ4ZDNmNGIx
YzA3Yjk4ODA0MGU3ODExMmUyOmJpc2VjdC1uZXQKCjIwMTMtMTAtMTAtMTY6MjI6NTkgNGE5
YTRiMzUyOGFmY2U0OGQzZjRiMWMwN2I5ODgwNDBlNzgxMTJlMiByZXVzZSAva2VybmVsL3g4
Nl82NC1sa3AtQ09ORklHX1NDSEVEX0RFQlVHLzRhOWE0YjM1MjhhZmNlNDhkM2Y0YjFjMDdi
OTg4MDQwZTc4MTEyZTIvdm1saW51ei0zLjExLjAtMDAwMDEtZzRhOWE0YjMKCjIwMTMtMTAt
MTAtMTY6MjI6NTkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4JMzMJNTIJNTYuLi4uLi4u
Li4uLi4uLi4uLgk1OAk2MCBTVUNDRVNTCgpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0veDg2XzY0LWxrcC1DT05GSUdfU0NIRURfREVCVUcvbGludXgtZGV2ZWw6ZGV2ZWwt
aG91cmx5LTIwMTMxMDEwMDc6M2Q1NTg3ZWM3MjIyZWViZDZkMmZhMmQ0YjI0NWVmODM3YThm
MzZmYTpiaXNlY3QtbmV0CiBURVNUIEZBSUxVUkUKWyAgICAwLjgwODExN10gICAgZ2VuZXJp
Y19zc2U6ICAgMzYyLjAwMCBNQi9zZWMKWyAgICAwLjgwODcwMV0geG9yOiB1c2luZyBmdW5j
dGlvbjogZ2VuZXJpY19zc2UgKDM2Mi4wMDAgTUIvc2VjKQpbICAgIDAuODA5NTk0XSAtLS0t
LS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAwLjgxMDcwMl0gV0FSTklO
RzogQ1BVOiAwIFBJRDogMSBhdCBpbml0L21haW4uYzo3MDEgZG9fb25lX2luaXRjYWxsKzB4
MTI4LzB4MTM4KCkKWyAgICAwLjgxMTY4NV0gaW5pdGNhbGwgY2FsaWJyYXRlX3hvcl9ibG9j
a3MrMHgwLzB4MTQ0IHJldHVybmVkIHdpdGggcHJlZW1wdGlvbiBpbWJhbGFuY2UgClsgICAg
MC44MTIyMzBdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDAuODEzMjUxXSBDUFU6IDAgUElE
OiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjEyLjAtcmM0LXdsLTAyMTk3LWcz
ZDU1ODdlICMxMTkKWyAgICAwLjgxNDA0N10gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMs
IEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDAuODE0OTQzXSAgMDAwMDAwMDAwMDAwMDAw
MCBmZmZmODgwMDFkZjU1ZTAwIGZmZmZmZmZmODFhM2E2YmYgZmZmZjg4MDAxZGY1NWU0OApb
ICAgIDAuODE2OTE3XSAgZmZmZjg4MDAxZGY1NWUzOCBmZmZmZmZmZjgxMGM1M2Q1IGZmZmZm
ZmZmODEwMDAzMTUgZmZmZmZmZmY4MjU2ZmYxNgpbICAgIDAuODE3OTMxXSAgMDAwMDAwMDAw
MDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMWRmNTVmZDggZmZmZjg4MDAxZGY1
NWU5OApbICAgIDAuODE5MDEzXSBDYWxsIFRyYWNlOgpbICAgIDAuODE5NTUxXSAgWzxmZmZm
ZmZmZjgxYTNhNmJmPl0gZHVtcF9zdGFjaysweDU0LzB4NzQKWyAgICAwLjgyMDE5NV0gIFs8
ZmZmZmZmZmY4MTBjNTNkNT5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4N2YvMHg5OApbICAg
IDAuODIwODIyXSAgWzxmZmZmZmZmZjgxMDAwMzE1Pl0gPyBkb19vbmVfaW5pdGNhbGwrMHgx
MjgvMHgxMzgKWyAgICAwLjgyMTQyMF0gIFs8ZmZmZmZmZmY4MjU2ZmYxNj5dID8gZG9feG9y
X3NwZWVkKzB4ZTIvMHhlMgpbICAgIDAuODIxOTk3XSAgWzxmZmZmZmZmZjgxMGM1NDNhPl0g
d2Fybl9zbG93cGF0aF9mbXQrMHg0Yy8weDRlClsgICAgMC44MjI1ODBdICBbPGZmZmZmZmZm
ODExNzY3ZDk+XSA/IGZyZWVfcGFnZXMrMHg0NS8weDQ3ClsgICAgMC44MjMxNDNdICBbPGZm
ZmZmZmZmODI1NmZmMTY+XSA/IGRvX3hvcl9zcGVlZCsweGUyLzB4ZTIKWyAgICAwLjgyNDE2
MV0gIFs8ZmZmZmZmZmY4MTAwMDMxNT5dIGRvX29uZV9pbml0Y2FsbCsweDEyOC8weDEzOApb
ICAgIDAuODI0NzYxXSAgWzxmZmZmZmZmZjgyNTMyZWQzPl0ga2VybmVsX2luaXRfZnJlZWFi
bGUrMHgxNTkvMHgxZGEKWyAgICAwLjgyNTM5MV0gIFs8ZmZmZmZmZmY4MjUzMjc0ZD5dID8g
ZG9fZWFybHlfcGFyYW0rMHg4OC8weDg4ClsgICAgMC44MjU5NzZdICBbPGZmZmZmZmZmODFh
MmEwNTc+XSA/IHJlc3RfaW5pdCsweGRiLzB4ZGIKWyAgICAwLjgyNjUxNl0gIFs8ZmZmZmZm
ZmY4MWEyYTA2NT5dIGtlcm5lbF9pbml0KzB4ZS8weGRiClsgICAgMC44MjcwNjNdICBbPGZm
ZmZmZmZmODFhNGQ5N2M+XSByZXRfZnJvbV9mb3JrKzB4N2MvMHhiMApbICAgIDAuODI3NjI1
XSAgWzxmZmZmZmZmZjgxYTJhMDU3Pl0gPyByZXN0X2luaXQrMHhkYi8weGRiClsgICAgMC44
MzI0MDBdIC0tLVsgZW5kIHRyYWNlIGVhOGJkNDVmMGEyYTE4NzkgXS0tLQpbICAgIDAuODM0
MTY2XSBhdG9taWM2NCB0ZXN0IHBhc3NlZCBmb3IgeDg2LTY0IHBsYXRmb3JtIHdpdGggQ1g4
IGFuZCB3aXRoIFNTRQova2VybmVsL3g4Nl82NC1sa3AtQ09ORklHX1NDSEVEX0RFQlVHLzNk
NTU4N2VjNzIyMmVlYmQ2ZDJmYTJkNGIyNDVlZjgzN2E4ZjM2ZmEvZG1lc2ctbmZzcm9vdC1j
YWlyby0zOjIwMTMxMDEwMDg1NDE0Ong4Nl82NC1sa3AtQ09ORklHX1NDSEVEX0RFQlVHOjMu
MTIuMC1yYzQtd2wtMDIxOTctZzNkNTU4N2U6MTE5Ci9rZXJuZWwveDg2XzY0LWxrcC1DT05G
SUdfU0NIRURfREVCVUcvM2Q1NTg3ZWM3MjIyZWViZDZkMmZhMmQ0YjI0NWVmODM3YThmMzZm
YS9kbWVzZy1uZnNyb290LWlubi0xODoyMDEzMTAxMDA4NTM1ODp4ODZfNjQtbGtwLUNPTkZJ
R19TQ0hFRF9ERUJVRzozLjEyLjAtcmM0LXdsLTAyMTk3LWczZDU1ODdlOjExOQova2VybmVs
L3g4Nl82NC1sa3AtQ09ORklHX1NDSEVEX0RFQlVHLzNkNTU4N2VjNzIyMmVlYmQ2ZDJmYTJk
NGIyNDVlZjgzN2E4ZjM2ZmEvZG1lc2ctcXVhbnRhbC1iZW5zLTQ6MjAxMzEwMTAwODAxNTY6
eDg2XzY0LWxrcC1DT05GSUdfU0NIRURfREVCVUc6My4xMi4wLXJjNC13bC0wMjE5Ny1nM2Q1
NTg3ZToxMTkKL2tlcm5lbC94ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRy8zZDU1ODdl
YzcyMjJlZWJkNmQyZmEyZDRiMjQ1ZWY4MzdhOGYzNmZhL2RtZXNnLW5mc3Jvb3Qtc25iLTI6
MjAxMzEwMTAwODU0MTQ6eDg2XzY0LWxrcC1DT05GSUdfU0NIRURfREVCVUc6My4xMi4wLXJj
NC13bC0wMjE5Ny1nM2Q1NTg3ZToxMTkKL2tlcm5lbC94ODZfNjQtbGtwLUNPTkZJR19TQ0hF
RF9ERUJVRy8zZDU1ODdlYzcyMjJlZWJkNmQyZmEyZDRiMjQ1ZWY4MzdhOGYzNmZhL2RtZXNn
LW5mc3Jvb3Qtc25iLTM6MjAxMzEwMTAwODAyMDY6eDg2XzY0LWxrcC1DT05GSUdfU0NIRURf
REVCVUc6My4xMi4wLXJjNC13bC0wMjE5Ny1nM2Q1NTg3ZToxMTkKL2tlcm5lbC94ODZfNjQt
bGtwLUNPTkZJR19TQ0hFRF9ERUJVRy8zZDU1ODdlYzcyMjJlZWJkNmQyZmEyZDRiMjQ1ZWY4
MzdhOGYzNmZhL2RtZXNnLXF1YW50YWwtY2Fpcm8tMzE6MjAxMzEwMTAwODAyMDU6eDg2XzY0
LWxrcC1DT05GSUdfU0NIRURfREVCVUc6My4xMi4wLXJjNC13bC0wMjE5Ny1nM2Q1NTg3ZTox
MTkKL2tlcm5lbC94ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRy8zZDU1ODdlYzcyMjJl
ZWJkNmQyZmEyZDRiMjQ1ZWY4MzdhOGYzNmZhL2RtZXNnLW5mc3Jvb3Qtd2FpbWVhLTQ6MjAx
MzEwMTAxNjUzMDE6eDg2XzY0LWxrcC1DT05GSUdfU0NIRURfREVCVUc6My4xMi4wLXJjNC13
bC0wMjE5Ny1nM2Q1NTg3ZToxMTkKL2tlcm5lbC94ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9E
RUJVRy8zZDU1ODdlYzcyMjJlZWJkNmQyZmEyZDRiMjQ1ZWY4MzdhOGYzNmZhL2RtZXNnLW5m
c3Jvb3QtYW50LTE6MjAxMzEwMTAwOTAyMDU6eDg2XzY0LWxrcC1DT05GSUdfU0NIRURfREVC
VUc6My4xMi4wLXJjNC13bC0wMjE5Ny1nM2Q1NTg3ZToxMTkKL2tlcm5lbC94ODZfNjQtbGtw
LUNPTkZJR19TQ0hFRF9ERUJVRy8zZDU1ODdlYzcyMjJlZWJkNmQyZmEyZDRiMjQ1ZWY4Mzdh
OGYzNmZhL2RtZXNnLXF1YW50YWwtYW50LTk6MjAxMzEwMTAwODA5MDM6eDg2XzY0LWxrcC1D
T05GSUdfU0NIRURfREVCVUc6My4xMi4wLXJjNC13bC0wMjE5Ny1nM2Q1NTg3ZToxMTkKL2tl
cm5lbC94ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRy8zZDU1ODdlYzcyMjJlZWJkNmQy
ZmEyZDRiMjQ1ZWY4MzdhOGYzNmZhL2RtZXNnLW5mc3Jvb3QtY2Fpcm8tMzA6MjAxMzEwMTAw
ODUzNTM6eDg2XzY0LWxrcC1DT05GSUdfU0NIRURfREVCVUc6My4xMi4wLXJjNC13bC0wMjE5
Ny1nM2Q1NTg3ZToxMTkKL2tlcm5lbC94ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRy8z
ZDU1ODdlYzcyMjJlZWJkNmQyZmEyZDRiMjQ1ZWY4MzdhOGYzNmZhL2RtZXNnLXlvY3RvLWph
a2V0b3duLTE0OjIwMTMxMDEwMDgwMjIyOng4Nl82NC1sa3AtQ09ORklHX1NDSEVEX0RFQlVH
OjMuMTIuMC1yYzQtd2wtMDIxOTctZzNkNTU4N2U6MTE5Ci9rZXJuZWwveDg2XzY0LWxrcC1D
T05GSUdfU0NIRURfREVCVUcvM2Q1NTg3ZWM3MjIyZWViZDZkMmZhMmQ0YjI0NWVmODM3YThm
MzZmYS9kbWVzZy1uZnNyb290LWxrcC10dDAyLTk6MjAxMzEwMDkyMzI2MDg6eDg2XzY0LWxr
cC1DT05GSUdfU0NIRURfREVCVUc6My4xMi4wLXJjNC13bC0wMjE5Ny1nM2Q1NTg3ZToxMTkK
L2tlcm5lbC94ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRy8zZDU1ODdlYzcyMjJlZWJk
NmQyZmEyZDRiMjQ1ZWY4MzdhOGYzNmZhL2RtZXNnLW5mc3Jvb3QtaW5uLTk6MjAxMzEwMTAw
ODAyMTU6eDg2XzY0LWxrcC1DT05GSUdfU0NIRURfREVCVUc6My4xMi4wLXJjNC13bC0wMjE5
Ny1nM2Q1NTg3ZToxMTkKL2tlcm5lbC94ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRy8z
ZDU1ODdlYzcyMjJlZWJkNmQyZmEyZDRiMjQ1ZWY4MzdhOGYzNmZhL2RtZXNnLW5mc3Jvb3Qt
c25iLTExOjIwMTMxMDEwMDg1NDAxOng4Nl82NC1sa3AtQ09ORklHX1NDSEVEX0RFQlVHOjMu
MTIuMC1yYzQtd2wtMDIxOTctZzNkNTU4N2U6MTE5Ci9rZXJuZWwveDg2XzY0LWxrcC1DT05G
SUdfU0NIRURfREVCVUcvM2Q1NTg3ZWM3MjIyZWViZDZkMmZhMmQ0YjI0NWVmODM3YThmMzZm
YS9kbWVzZy1uZnNyb290LXhpYW4tOToyMDEzMTAxMDA4MDIwNDp4ODZfNjQtbGtwLUNPTkZJ
R19TQ0hFRF9ERUJVRzozLjEyLjAtcmM0LXdsLTAyMTk3LWczZDU1ODdlOjExOQova2VybmVs
L3g4Nl82NC1sa3AtQ09ORklHX1NDSEVEX0RFQlVHLzNkNTU4N2VjNzIyMmVlYmQ2ZDJmYTJk
NGIyNDVlZjgzN2E4ZjM2ZmEvZG1lc2ctcXVhbnRhbC13YWltZWEtMjoyMDEzMTAxMDE2MDA0
NTp4ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRzozLjEyLjAtcmM0LXdsLTAyMTk3LWcz
ZDU1ODdlOjExOQova2VybmVsL3g4Nl82NC1sa3AtQ09ORklHX1NDSEVEX0RFQlVHLzNkNTU4
N2VjNzIyMmVlYmQ2ZDJmYTJkNGIyNDVlZjgzN2E4ZjM2ZmEvZG1lc2cteW9jdG8tY2Fpcm8t
Mjc6MjAxMzEwMTAwODAyMDc6eDg2XzY0LWxrcC1DT05GSUdfU0NIRURfREVCVUc6My4xMi4w
LXJjNC13bC0wMjE5Ny1nM2Q1NTg3ZToxMTkKL2tlcm5lbC94ODZfNjQtbGtwLUNPTkZJR19T
Q0hFRF9ERUJVRy8zZDU1ODdlYzcyMjJlZWJkNmQyZmEyZDRiMjQ1ZWY4MzdhOGYzNmZhL2Rt
ZXNnLXlvY3RvLWFudC01OjIwMTMxMDEwMDkwMjUzOng4Nl82NC1sa3AtQ09ORklHX1NDSEVE
X0RFQlVHOjMuMTIuMC1yYzQtd2wtMDIxOTctZzNkNTU4N2U6MTE5Ci9rZXJuZWwveDg2XzY0
LWxrcC1DT05GSUdfU0NIRURfREVCVUcvM2Q1NTg3ZWM3MjIyZWViZDZkMmZhMmQ0YjI0NWVm
ODM3YThmMzZmYS9kbWVzZy1uZnNyb290LWxrcC10dDAyLTE2OjIwMTMxMDA5MjMyNjA2Ong4
Nl82NC1sa3AtQ09ORklHX1NDSEVEX0RFQlVHOjMuMTIuMC1yYzQtd2wtMDIxOTctZzNkNTU4
N2U6MTE5CjA6MTk6MTkgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCltkZXRhY2hlZCBI
RUFEIDEzYjMyNTRdIFJldmVydCAiUkZDOiBkb194b3Jfc3BlZWQgQnJva2VuIG9uIFVNTCBk
byB0byBqaWZmaWVzIgogMSBmaWxlIGNoYW5nZWQsIDIyIGluc2VydGlvbnMoKyksIDI1IGRl
bGV0aW9ucygtKQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LWxr
cC1DT05GSUdfU0NIRURfREVCVUcvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTMxMDEw
MDc6MTNiMzI1NGE5OGE1YjAwZGJmZDMzNWNmMzk2YmU1ZGQwYjg4YTZiNDpiaXNlY3QtbmV0
CgoyMDEzLTEwLTEwLTE2OjM2OjUwIDEzYjMyNTRhOThhNWIwMGRiZmQzMzVjZjM5NmJlNWRk
MGI4OGE2YjQgY29tcGlsaW5nCjIwMTMtMTAtMTAtMTY6NTc6MzQgMTNiMzI1NGE5OGE1YjAw
ZGJmZDMzNWNmMzk2YmU1ZGQwYjg4YTZiNCBTS0lQIEJST0tFTiBCVUlMRApDaGVjayBlcnJv
cyBpbiAvY2Mvd2ZnL25ldC1iaXNlY3QgYW5kIC90bXAva2VybmVsL3g4Nl82NC1sa3AtQ09O
RklHX1NDSEVEX0RFQlVHLzEzYjMyNTRhOThhNWIwMGRiZmQzMzVjZjM5NmJlNWRkMGI4OGE2
YjQKCj09PT09PT09PSB1cHN0cmVhbSA9PT09PT09PT0KRmV0Y2hpbmcgbGludXMKbHMgLWEg
L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1sa3AtQ09ORklHX1NDSEVEX0RF
QlVHL2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDEzMTAxMDA3OjBlN2EzZWQwNGYwY2Q0
MzExMDk2ZDY5MTg4OGY4ODU2OTMxMGVlNmM6YmlzZWN0LW5ldAogU1VDQ0VTUwoKCj09PT09
PT09PSBsaW51eC1uZXh0ID09PT09PT09PQpGZXRjaGluZyBuZXh0CmxzIC1hIC9rZXJuZWwt
dGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtbGtwLUNPTkZJR19TQ0hFRF9ERUJVRy9saW51
eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxMzEwMTAwNzphMGNmMWFiYzI1YWMxOTdkZDk3Yjg1
N2MwZjYzNDEwNjZhOGNiMWNmOmJpc2VjdC1uZXQKIFNVQ0NFU1MKCg==

--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.12.0-rc4-wl-02197-g3d5587e"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.12.0-rc4 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
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
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
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
# CONFIG_NO_HZ_FULL is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
# CONFIG_RCU_USER_QS is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_NOCB_CPU=y
CONFIG_RCU_NOCB_CPU_NONE=y
# CONFIG_RCU_NOCB_CPU_ZERO is not set
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=20
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_ARCH_USES_NUMA_PROT_NONE=y
# CONFIG_NUMA_BALANCING_DEFAULT_ENABLED is not set
CONFIG_NUMA_BALANCING=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_SWAP_ENABLED=y
CONFIG_MEMCG_KMEM=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
# CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
# CONFIG_SCHED_AUTOGROUP is not set
CONFIG_MM_OWNER=y
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
CONFIG_KALLSYMS_ALL=y
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
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_UPROBES=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
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
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=256
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_MOVABLE_NODE is not set
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_TEST_SUSPEND=y
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_EINJ=y
CONFIG_ACPI_APEI_ERST_DEBUG=y
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=y
# CONFIG_X86_AMD_FREQ_SENSITIVITY is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
CONFIG_IP_MROUTE=y
# CONFIG_IP_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=y
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
# CONFIG_TCP_CONG_CUBIC is not set
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
CONFIG_DEFAULT_BIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="bic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
# CONFIG_IPV6_VTI is not set
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_GRE is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
# CONFIG_NET_SCTPPROBE is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_COOKIE_HMAC_SHA1 is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_VLAN_8021Q_MVRP is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
# CONFIG_DMA_SHARED_BUFFER is not set

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ATMEL_SSC is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
CONFIG_SCSI_ACARD=y
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=4
CONFIG_AIC7XXX_RESET_DELAY_MS=15000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC7XXX_OLD=y
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=4
CONFIG_AIC79XX_RESET_DELAY_MS=15000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC94XX=y
# CONFIG_AIC94XX_DEBUG is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_MPT2SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS_LOGGING is not set
CONFIG_SCSI_MPT3SAS=m
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
# CONFIG_SCSI_MPT3SAS_LOGGING is not set
# CONFIG_SCSI_UFSHCD is not set
CONFIG_SCSI_HPTIOP=y
CONFIG_SCSI_BUSLOGIC=y
# CONFIG_SCSI_FLASHPOINT is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
CONFIG_SCSI_GDTH=y
CONFIG_SCSI_ISCI=m
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLA_FC=y
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
CONFIG_SCSI_DEBUG=y
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=y
# CONFIG_SCSI_CHELSIO_FCOE is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
# CONFIG_SATA_HIGHBANK is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_RCAR is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_AUTODETECT is not set
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MD_MULTIPATH=y
CONFIG_MD_FAULTY=y
CONFIG_BCACHE=y
# CONFIG_BCACHE_DEBUG is not set
# CONFIG_BCACHE_EDEBUG is not set
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=y
CONFIG_DM_BIO_PRISON=y
CONFIG_DM_PERSISTENT_DATA=y
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
# CONFIG_DM_THIN_PROVISIONING is not set
CONFIG_DM_CACHE=y
CONFIG_DM_CACHE_MQ=y
CONFIG_DM_CACHE_CLEANER=y
CONFIG_DM_MIRROR=y
# CONFIG_DM_RAID is not set
# CONFIG_DM_LOG_USERSPACE is not set
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
# CONFIG_DM_MULTIPATH_QL is not set
# CONFIG_DM_MULTIPATH_ST is not set
CONFIG_DM_DELAY=y
# CONFIG_DM_UEVENT is not set
CONFIG_DM_FLAKEY=y
# CONFIG_DM_VERITY is not set
# CONFIG_DM_SWITCH is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=40
CONFIG_FUSION_CTL=y
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=y
# CONFIG_NLMON is not set
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#
CONFIG_VHOST_NET=y
CONFIG_VHOST_RING=y
CONFIG_VHOST=y

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
# CONFIG_NET_DSA_MV88E6060 is not set
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
CONFIG_ACENIC=y
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_NET_VENDOR_AMD=y
CONFIG_AMD8111_ETH=y
CONFIG_PCNET32=y
# CONFIG_PCMCIA_NMCLAN is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
CONFIG_ATL1=y
CONFIG_ATL1E=y
CONFIG_ATL1C=y
# CONFIG_ALX is not set
CONFIG_NET_CADENCE=y
# CONFIG_ARM_AT91_ETHER is not set
# CONFIG_MACB is not set
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
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
CONFIG_TULIP=y
# CONFIG_TULIP_MWI is not set
# CONFIG_TULIP_MMIO is not set
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=y
CONFIG_WINBOND_840=y
CONFIG_DM9102=y
CONFIG_ULI526X=y
# CONFIG_PCMCIA_XIRCOM is not set
CONFIG_NET_VENDOR_DLINK=y
CONFIG_DL2K=y
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_FUJITSU=y
# CONFIG_PCMCIA_FMVJ18X is not set
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=y
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
# CONFIG_IGBVF is not set
CONFIG_IXGB=y
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
# CONFIG_IXGBEVF is not set
# CONFIG_I40E is not set
CONFIG_NET_VENDOR_I825XX=y
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
CONFIG_SKGE=y
CONFIG_SKGE_DEBUG=y
# CONFIG_SKGE_GENESIS is not set
CONFIG_SKY2=y
CONFIG_SKY2_DEBUG=y
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_MLX5_CORE is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_8390=y
# CONFIG_PCMCIA_AXNET is not set
CONFIG_NE2K_PCI=y
# CONFIG_PCMCIA_PCNET is not set
CONFIG_NET_VENDOR_NVIDIA=y
CONFIG_FORCEDETH=y
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_8139CP=y
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=y
# CONFIG_SH_ETH is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
CONFIG_SIS900=y
# CONFIG_SIS190 is not set
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_PCMCIA_SMC91C92 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VIA=y
CONFIG_VIA_RHINE=y
# CONFIG_VIA_RHINE_MMIO is not set
CONFIG_VIA_VELOCITY=y
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_NET_VENDOR_XIRCOM=y
# CONFIG_PCMCIA_XIRC2PS is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
# CONFIG_AMD_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
CONFIG_BROADCOM_PHY=y
# CONFIG_BCM87XX_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=y
# CONFIG_USB_RTL8152 is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=y
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=y
# CONFIG_USB_NET_CDC_MBIM is not set
CONFIG_USB_NET_DM9601=y
# CONFIG_USB_NET_SR9700 is not set
CONFIG_USB_NET_SMSC75XX=y
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=y
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_NET_QMI_WWAN is not set
CONFIG_USB_NET_INT51X1=y
CONFIG_USB_IPHETH=y
CONFIG_USB_SIERRA_NET=y
# CONFIG_USB_VL600 is not set
CONFIG_WLAN=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_HOSTAP is not set
# CONFIG_WL_TI is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
# CONFIG_N_HDLC is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_ST_ASC is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_HSI is not set

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
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_HTU21 is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IBMAEM is not set
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_CPU_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_X86_PKG_TEMP_THERMAL=m

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
# CONFIG_IE6XX_WDT is not set
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_LPC_ICH=y
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_EXYNOS_VIDEO is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
# CONFIG_HID_APPLEIR is not set
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_HUION is not set
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=m
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=y
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
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
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_FUSBH200_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HSIC_USB3503 is not set

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_AM335X_PHY_USB is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_RCAR_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_GHES=y
CONFIG_EDAC_E752X=y
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I7CORE is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
# CONFIG_EDAC_SBRIDGE is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF2127 is not set
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set
# CONFIG_RTC_DRV_DS2404 is not set

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MOXART is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_CHROMEOS_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_ARM_ARCH_TIMER_EVTSTREAM is not set
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set
# CONFIG_INTEL_IOMMU is not set
# CONFIG_IRQ_REMAP is not set

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
# CONFIG_EFI_VARS is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_DEBUG=y
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_FTRACE is not set
# CONFIG_PSTORE_RAM is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_F2FS_FS is not set
# CONFIG_EFIVAR_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V2=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
# CONFIG_NFS_V4_2 is not set
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
CONFIG_ROOT_NFS=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFSD=y
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
# CONFIG_NFSD_FAULT_INJECTION is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_SUNRPC_DEBUG is not set
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
# CONFIG_CIFS_UPCALL is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_ACL is not set
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_SMB2 is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

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
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
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
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
# CONFIG_MMIOTRACE_TEST is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_ASYNC_RAID6_TEST is not set
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
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
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
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
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
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
# CONFIG_CRYPTO_CRCT10DIF_PCLMUL is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
# CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
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
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_PERCPU_RWSEM=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y

--pWyiEgJYm5f9v55/--
