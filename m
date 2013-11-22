Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab3KVGCL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 01:02:11 -0500
Received: from mga11.intel.com ([192.55.52.93]:21214 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806Ab3KVGB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 01:01:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,750,1378882800"; 
   d="log'?scan'208";a="437797019"
Date: Fri, 22 Nov 2013 14:02:23 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: LKP <fnstml-lkp@cn.fujitsu.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Boaz Harrosh <bharrosh@panasas.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: WARNING: CPU: 0 PID: 1 at init/main.c:711 do_one_initcall()
Message-ID: <20131122060223.GP9991@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="EuxKj2iCbKjpUGkD"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EuxKj2iCbKjpUGkD
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

+------------------------------------------------------------------+----+
|                                                                  |    |
+------------------------------------------------------------------+----+
| boot_successes                                                   | 0  |
| boot_failures                                                    | 29 |
| WARNING:CPU:PID:at_init/main.c:do_one_initcall()                 | 29 |
| initcall_calibrate_xor_blocks_returned_with_preemption_imbalance | 29 |
+------------------------------------------------------------------+----+

[    0.127025]    generic_sse:   148.363 MB/sec
[    0.127478] xor: using function: prefetch64-sse (152.727 MB/sec)
[    0.128017] ------------[ cut here ]------------
[    0.128531] WARNING: CPU: 0 PID: 1 at init/main.c:711 do_one_initcall+0x105/0x115()
[    0.129018] initcall calibrate_xor_blocks+0x0/0x144 returned with preemption imbalance 
[    0.130013] Modules linked in:
[    0.130357] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-11285-gb242bff #91
[    0.131013]  0000000000000000 ffff88000d0dde00 ffffffff8161acc5 ffff88000d0dde48
[    0.132554]  ffff88000d0dde38 ffffffff81052de9 ffffffff81000316 ffffffff81a77cfd
[    0.133380]  0000000000000000 0000000000000000 0000000000000000 ffff88000d0dde98
[    0.134213] Call Trace:
[    0.134493]  [<ffffffff8161acc5>] dump_stack+0x4e/0x7a
[    0.135017]  [<ffffffff81052de9>] warn_slowpath_common+0x75/0x8e
[    0.135654]  [<ffffffff81000316>] ? do_one_initcall+0x105/0x115
[    0.136015]  [<ffffffff81a77cfd>] ? do_xor_speed+0xdd/0xdd
[    0.137016]  [<ffffffff81052e49>] warn_slowpath_fmt+0x47/0x49
[    0.137628]  [<ffffffff810c8382>] ? free_pages+0x51/0x53
[    0.138015]  [<ffffffff81a77cfd>] ? do_xor_speed+0xdd/0xdd
[    0.138623]  [<ffffffff81000316>] do_one_initcall+0x105/0x115
[    0.139017]  [<ffffffff81a59ed6>] kernel_init_freeable+0x115/0x19b
[    0.140016]  [<ffffffff81a59707>] ? do_early_param+0x88/0x88
[    0.140630]  [<ffffffff81610ff9>] ? rest_init+0xbd/0xbd
[    0.141016]  [<ffffffff81611002>] kernel_init+0x9/0xfa
[    0.141567]  [<ffffffff8162a98c>] ret_from_fork+0x7c/0xb0
[    0.142016]  [<ffffffff81610ff9>] ? rest_init+0xbd/0xbd
[    0.143028] ---[ end trace 19b4eab334350767 ]---
[    0.143530] atomic64 test passed for x86-64 platform with CX8 and with SSE

git bisect start b242bff548c34510fd9b7f0e29b885263dfb8903 5e01dc7b26d9f24f39abace5da98ccbd6a5ceb52 --
git bisect good 5cbb3d216e2041700231bcfc383ee5f8b7fc8b74  # 09:25     20+      0  Merge branch 'akpm' (patches from Andrew Morton)
git bisect good 7e1a1e9378018aeea2c7e8a3dd2ceb1db1523b0b  # 09:42     20+      0  Merge tag 'xfs-for-linus-v3.13-rc1' of git://oss.sgi.com/xfs/xfs
git bisect good 4937e2a6f939a41bf811378e80d71f68aa0950c6  # 10:08     20+      0  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input
git bisect good 210e812f036736aeda097d9a6ef84b1f2b334bae  # 10:31     20+      0  perf header: Fix bogus group name
git bisect good d5bdaf4f68f0590fc481bca54bcaffeb27b75fca  # 10:54     20+      0  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mattst88/alpha
git bisect good e630a6bcf18079b2ab6b03d55c9757e8ef6656b6  # 11:03     20+      0  staging: lustre: fix checkpatch issue regarding pointer coding style
git bisect good 6449a5811e62ab9587b54feca45c06cfee0e37cd  # 11:10     20+      0  Merge 'btrfs/for-linus' into devel-cairo-x86_64-201311220159
git bisect good 78103b692e7aa6a8e2ef678c9a3465d6bfe44559  # 11:14     20+      0  Merge 'staging/opw-next' into devel-cairo-x86_64-201311220159
git bisect good 7acd71879ce408af2d2ca3cd3ec3a86d0667ceae  # 11:24     20+      0  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless into for-davem
git bisect good 2ea4606fd707f05cddce72219a5f90ca471c09d6  # 11:32     20+      0  drm/msm: add atomic support
git bisect  bad cd7efef070cc5420858c271a9908df3f86cef83b  # 11:40      0-      3  {SQUASHME} exofs_ioctl: Fix for deadlock when close of root node
git bisect  bad 13cf7003526891bfb7ad12fc5cff01cf9e734dc2  # 11:43      0-     14  {SPLITME} exofs_ioctl: All the new and external files
git bisect  bad 20545536cd8ea949c61527b6395ec8c0d2c237b1  # 11:46      0-     17  RFC: do_xor_speed Broken on UML do to jiffies
git bisect good 4a9a4b3528afce48d3f4b1c07b988040e78112e2  # 11:50     20+      0  pnfs: Proper delay for NFS4ERR_RECALLCONFLICT in layout_get_done
# first bad commit: [20545536cd8ea949c61527b6395ec8c0d2c237b1] RFC: do_xor_speed Broken on UML do to jiffies
git bisect good 4a9a4b3528afce48d3f4b1c07b988040e78112e2  # 11:52     60+      0  pnfs: Proper delay for NFS4ERR_RECALLCONFLICT in layout_get_done
git bisect  bad b242bff548c34510fd9b7f0e29b885263dfb8903  # 11:52      0-     29  Merge 'open-osd/exofs_ioctl' into devel-cairo-x86_64-201311220159
git bisect good 727fb2e90de9b05224b1801b4c21e7fe18506b43  # 12:07     60+      0  Revert "RFC: do_xor_speed Broken on UML do to jiffies"
git bisect good 527d1511310a89650000081869260394e20c7013  # 12:26     60+      0  Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc
git bisect good f3fa585afa93230883dc4c259dc03df6234a5e5f  # 12:42     60+      0  Add linux-next specific files for 20131122


Thanks.

	--yliu

--EuxKj2iCbKjpUGkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-roam-13:20131122022047:x86_64-randconfig-c1-1122:3.12.0-11285-gb242bff:91"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Linux version 3.12.0-11285-gb242bff (kbuild@cairo) (gcc vers=
ion 4.8.1 (Debian 4.8.1-8) ) #91 SMP PREEMPT Fri Nov 22 02:12:57 CST 2013
[    0.000000] Command line: hung_task_panic=3D1 rcutree.rcu_cpu_stall_time=
out=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug d=
ynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/ke=
rnel-tests/run-queue/kvm/x86_64-randconfig-c1-1122/devel-cairo-x86_64-20131=
1220159/.vmlinuz-b242bff548c34510fd9b7f0e29b885263dfb8903-20131122021504-5-=
roam branch=3Dlinux-devel/devel-cairo-x86_64-201311220159 BOOT_IMAGE=3D/ker=
nel/x86_64-randconfig-c1-1122/b242bff548c34510fd9b7f0e29b885263dfb8903/vmli=
nuz-3.12.0-11285-gb242bff
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
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x024c8000, 0x024c8fff] PGTABLE
[    0.000000] BRK [0x024c9000, 0x024c9fff] PGTABLE
[    0.000000] BRK [0x024ca000, 0x024cafff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x024cb000, 0x024cbfff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127684(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 000040
[    0.000000] ACPI: SSDT 000000000ffff7a0 000796 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 000080 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f9000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
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
[    0.000000] mapped APIC to ffffffffff5f9000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f8000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88000de00000 s74824 r8192=
 d23480 u1048576
[    0.000000] pcpu-alloc: s74824 r8192 d23480 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr de0cc40
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64391
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-c1-1122/devel-cairo-x86_64=
-201311220159/.vmlinuz-b242bff548c34510fd9b7f0e29b885263dfb8903-20131122021=
504-5-roam branch=3Dlinux-devel/devel-cairo-x86_64-201311220159 BOOT_IMAGE=
=3D/kernel/x86_64-randconfig-c1-1122/b242bff548c34510fd9b7f0e29b885263dfb89=
03/vmlinuz-3.12.0-11285-gb242bff
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 203776K/261744K available (6321K kernel code, 816K r=
wdata, 3368K rodata, 800K init, 9932K bss, 57968K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:4352 nr_irqs:56 16
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
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
[    0.000000]                ww contexts mixing:  ok  |  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]            spinlock nest unlocked:  ok  |
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:  ok  |  ok  |  ok  |
[    0.000000]                               try:  ok  |  ok  |  ok  |
[    0.000000]                             block:  ok  |  ok  |  ok  |
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2892.982 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 5785.96 Bogo=
MIPS (lpj=3D2892982)
[    0.003007] pid_max: default: 32768 minimum: 301
[    0.004128] Mount-cache hash table entries: 256
[    0.006445] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.006445] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.006445] tlb_flushall_shift: 6
[    0.008215] Freeing SMP alternatives memory: 24K (ffffffff81b0e000 - fff=
fffff81b14000)
[    0.012505] ACPI: Core revision 20130927
[    0.040343] ACPI: All ACPI Tables successfully acquired
[    0.041551] Getting VERSION: 50014
[    0.041937] Getting VERSION: 50014
[    0.042037] Getting ID: 0
[    0.042341] Getting ID: ff000000
[    0.043023] Getting LVT0: 8700
[    0.043368] Getting LVT1: 8400
[    0.043760] enabled ExtINT on CPU#0
[    0.045240] ENABLING IO-APIC IRQs
[    0.045618] init IO_APIC IRQs
[    0.045950]  apic 0 pin 0 not connected
[    0.046041] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.047038] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.048037] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.049035] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.050035] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.051035] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.052034] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.052922] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.053035] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.054035] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.055035] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.056035] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.057035] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.058035] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.059035] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.060028]  apic 0 pin 16 not connected
[    0.060456]  apic 0 pin 17 not connected
[    0.061014]  apic 0 pin 18 not connected
[    0.061435]  apic 0 pin 19 not connected
[    0.062014]  apic 0 pin 20 not connected
[    0.062438]  apic 0 pin 21 not connected
[    0.063014]  apic 0 pin 22 not connected
[    0.063443]  apic 0 pin 23 not connected
[    0.064169] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.065014] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.066014] Using local APIC timer interrupts.
[    0.066014] calibrating APIC timer ...
[    0.068000] ... lapic delta =3D 6249965
[    0.068000] ... PM-Timer delta =3D 357958
[    0.068000] ... PM-Timer result ok
[    0.068000] ..... delta 6249965
[    0.068000] ..... mult: 268433952
[    0.068000] ..... calibration result: 999994
[    0.068000] ..... CPU clock speed is 2892.0991 MHz.
[    0.068000] ..... host bus clock speed is 999.0994 MHz.
[    0.068235] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.079329] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.082839] x86: Booting SMP configuration:
[    0.083016] .... node  #0, CPUs:      #1
[    0.079176] kvm-clock: cpu 1, msr 0:fffd041, secondary cpu clock
[    0.079176] masked ExtINT on CPU#1

[    0.098050] x86: Booted up 1 node, 2 CPUs
[    0.098010] KVM setup async PF for cpu 1
[    0.098015] kvm-stealtime: cpu 1, msr df0cc40
[    0.099015] smpboot: Total of 2 processors activated (11571.92 BogoMIPS)
[    0.104582] xor: measuring software checksum speed
[    0.116030]    prefetch64-sse:   152.727 MB/sec
[    0.127025]    generic_sse:   148.363 MB/sec
[    0.127478] xor: using function: prefetch64-sse (152.727 MB/sec)
[    0.128017] ------------[ cut here ]------------
[    0.128531] WARNING: CPU: 0 PID: 1 at init/main.c:711 do_one_initcall+0x=
105/0x115()
[    0.129018] initcall calibrate_xor_blocks+0x0/0x144 returned with preemp=
tion imbalance=20
[    0.130013] Modules linked in:
[    0.130357] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-11285-gb242=
bff #91
[    0.131013]  0000000000000000 ffff88000d0dde00 ffffffff8161acc5 ffff8800=
0d0dde48
[    0.132554]  ffff88000d0dde38 ffffffff81052de9 ffffffff81000316 ffffffff=
81a77cfd
[    0.133380]  0000000000000000 0000000000000000 0000000000000000 ffff8800=
0d0dde98
[    0.134213] Call Trace:
[    0.134493]  [<ffffffff8161acc5>] dump_stack+0x4e/0x7a
[    0.135017]  [<ffffffff81052de9>] warn_slowpath_common+0x75/0x8e
[    0.135654]  [<ffffffff81000316>] ? do_one_initcall+0x105/0x115
[    0.136015]  [<ffffffff81a77cfd>] ? do_xor_speed+0xdd/0xdd
[    0.137016]  [<ffffffff81052e49>] warn_slowpath_fmt+0x47/0x49
[    0.137628]  [<ffffffff810c8382>] ? free_pages+0x51/0x53
[    0.138015]  [<ffffffff81a77cfd>] ? do_xor_speed+0xdd/0xdd
[    0.138623]  [<ffffffff81000316>] do_one_initcall+0x105/0x115
[    0.139017]  [<ffffffff81a59ed6>] kernel_init_freeable+0x115/0x19b
[    0.140016]  [<ffffffff81a59707>] ? do_early_param+0x88/0x88
[    0.140630]  [<ffffffff81610ff9>] ? rest_init+0xbd/0xbd
[    0.141016]  [<ffffffff81611002>] kernel_init+0x9/0xfa
[    0.141567]  [<ffffffff8162a98c>] ret_from_fork+0x7c/0xb0
[    0.142016]  [<ffffffff81610ff9>] ? rest_init+0xbd/0xbd
[    0.143028] ---[ end trace 19b4eab334350767 ]---
[    0.143530] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.145300] regulator-dummy: no parameters
[    0.146456] NET: Registered protocol family 16
[    0.148491] cpuidle: using governor ladder
[    0.149285] ACPI: bus type PCI registered
[    0.149741] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.150195] PCI: Using configuration type 1 for base access
[    0.177543] bio: create slab <bio-0> at 0
[    0.195018] raid6: sse2x1    6734 MB/s
[    0.212018] raid6: sse2x2    8503 MB/s
[    0.229020] raid6: sse2x4    9753 MB/s
[    0.229441] raid6: using algorithm sse2x4 (9753 MB/s)
[    0.229987] raid6: using intx1 recovery algorithm
[    0.231379] ACPI: Added _OSI(Module Device)
[    0.231845] ACPI: Added _OSI(Processor Device)
[    0.232014] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.232525] ACPI: Added _OSI(Processor Aggregator Device)
[    0.287826] ACPI: Interpreter enabled
[    0.288105] ACPI: (supports S0 S4 S5)
[    0.288535] ACPI: Using IOAPIC for interrupt routing
[    0.289230] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.305726] ACPI: No dock devices found.
[    0.413023] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.413758] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.414222] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.422668] acpiphp: Slot [3] registered
[    0.423455] acpiphp: Slot [4] registered
[    0.424433] acpiphp: Slot [5] registered
[    0.425329] acpiphp: Slot [6] registered
[    0.426219] acpiphp: Slot [7] registered
[    0.427099] acpiphp: Slot [8] registered
[    0.427948] acpiphp: Slot [9] registered
[    0.428469] acpiphp: Slot [10] registered
[    0.429448] acpiphp: Slot [11] registered
[    0.430443] acpiphp: Slot [12] registered
[    0.431440] acpiphp: Slot [13] registered
[    0.432411] acpiphp: Slot [14] registered
[    0.433291] acpiphp: Slot [15] registered
[    0.434184] acpiphp: Slot [16] registered
[    0.435085] acpiphp: Slot [17] registered
[    0.435939] acpiphp: Slot [18] registered
[    0.436449] acpiphp: Slot [19] registered
[    0.437449] acpiphp: Slot [20] registered
[    0.438484] acpiphp: Slot [21] registered
[    0.439440] acpiphp: Slot [22] registered
[    0.440405] acpiphp: Slot [23] registered
[    0.441287] acpiphp: Slot [24] registered
[    0.442186] acpiphp: Slot [25] registered
[    0.443093] acpiphp: Slot [26] registered
[    0.443967] acpiphp: Slot [27] registered
[    0.444436] acpiphp: Slot [28] registered
[    0.445446] acpiphp: Slot [29] registered
[    0.446439] acpiphp: Slot [30] registered
[    0.447429] acpiphp: Slot [31] registered
[    0.447914] PCI host bridge to bus 0000:00
[    0.448025] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.449023] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.449696] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.450024] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.451023] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.452036] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.455105] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.458393] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.462339] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.466542] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.467394] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.468024] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.471348] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.473703] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.475695] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.483024] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.486648] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.488016] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.490018] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.497018] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.500106] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.502016] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.503625] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.512939] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.514618] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.516637] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.525676] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.527606] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.529015] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.538391] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.540015] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.542015] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.551033] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.552617] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.554615] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.563635] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.565015] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.567015] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.576197] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.577330] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.584162] pci_bus 0000:00: on NUMA node 0
[    0.591743] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.594517] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.597232] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.599947] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.601441] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.608943] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.609036] ACPI: \_SB_.PCI0: notify handler is installed
[    0.610123] Found 1 acpi root devices
[    0.611845] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.612018] vgaarb: loaded
[    0.613013] vgaarb: bridge control possible 0000:00:02.0
[    0.616301] SCSI subsystem initialized
[    0.617244] libata version 3.00 loaded.
[    0.617731] ACPI: bus type USB registered
[    0.618324] usbcore: registered new interface driver usbfs
[    0.619132] usbcore: registered new interface driver hub
[    0.620121] usbcore: registered new device driver usb
[    0.621164] Linux video capture interface: v2.00
[    0.621874] pps_core: LinuxPPS API ver. 1 registered
[    0.622014] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.623073] PTP clock support registered
[    0.624364] wmi: Mapper loaded
[    0.624707] PCI: Using ACPI for IRQ routing
[    0.625016] PCI: pci_cache_line_size set to 64 bytes
[    0.626187] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.626840] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.628958] Switched to clocksource kvm-clock
[    0.629097] pnp: PnP ACPI init
[    0.629483] ACPI: bus type PNP registered
[    0.630207] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.631318] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.632314] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.633375] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.634362] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.635456] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.636736] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.637662] pnp 00:03: [dma 2]
[    0.638230] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.639555] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.640640] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.641914] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.643047] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.646694] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.649715] pnp: PnP ACPI: found 7 devices
[    0.650195] ACPI: bus type PNP unregistered
[    0.650645] INFO_MDMA: LNW DMA Driver Version 1.1.0
[    0.657825] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.658459] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.659088] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.659756] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.660528] NET: Registered protocol family 1
[    0.661093] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.661734] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.662397] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.663115] pci 0000:00:02.0: Boot video device
[    0.663702] PCI: CLS 0 bytes, default 64
[    0.665210] Unpacking initramfs...
[    2.841554] Freeing initrd memory: 23656K (ffff88000e8d6000 - ffff88000f=
ff0000)
[    3.111081] DMA-API: preallocated 65536 debug entries
[    3.111676] DMA-API: debugging enabled by kernel config
[    3.113245] Scanning for low memory corruption every 60 seconds
[    3.114246] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    3.115941] cryptomgr_test (35) used greatest stack depth: 6296 bytes le=
ft
[    3.125852] modprobe (43) used greatest stack depth: 5648 bytes left
[    3.134376] cryptomgr_test (40) used greatest stack depth: 5208 bytes le=
ft
[    3.136557] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    3.137267] AVX or AES-NI instructions are not detected.
[    3.137872] AVX instructions are not detected.
[    3.142350] Initializing RT-Tester: OK
[    3.144740] Initialise module verification
[    3.145364] audit: initializing netlink socket (disabled)
[    3.146092] type=3D2000 audit(1385057981.563:1): initialized
[    3.167723] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.208667] zbud: loaded
[    3.211066] VFS: Disk quotas dquot_6.5.2
[    3.212233] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    3.216797] NTFS driver 2.1.30 [Flags: R/O].
[    3.220719] JFS: nTxBlock =3D 1777, nTxLock =3D 14216
[    3.223962] SGI XFS with ACLs, security attributes, realtime, large bloc=
k/inode numbers, no debug enabled
[    3.238345] bio: create slab <bio-1> at 1
[    3.243288] Btrfs loaded
[    3.243630] msgmni has been set to 444
[    3.252828] alg: No test for crc32 (crc32-table)
[    3.254323] alg: No test for lz4 (lz4-generic)
[    3.255265] alg: No test for lz4hc (lz4hc-generic)
[    3.256081] alg: No test for stdrng (krng)
[    3.256637] async_tx: api initialized (async)
[    3.257206] Key type asymmetric registered
[    3.257727] Asymmetric key parser 'x509' registered
[    3.258882] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 252)
[    3.259807] io scheduler noop registered (default)
[    3.261167] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.262349] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    3.263729] vmlfb: initializing
[    3.264311] Could not find Carillo Ranch MCH device.
[    3.336804] HDLC line discipline maxframe=3D4096
[    3.337405] N_HDLC line discipline registered.
[    3.338057] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.361072] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    3.364975] Cyclades driver 2.6
[    3.365593] SyncLink GT
[    3.365923] SyncLink GT, tty major#248
[    3.366503] SyncLink GT no devices found
[    3.367187] Non-volatile memory driver v1.3
[    3.367891] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    3.368548] Linux agpgart interface v0.103
[    3.369301] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    3.370569] lkdtm: No crash points registered, enable through debugfs
[    3.371616] Phantom Linux Driver, version n0.9.8, init OK
[    3.372788] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    3.374715] usbcore: registered new interface driver viperboard
[    3.384685] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
modprobe: FATAL: Could not load /lib/modules/3.12.0-11285-gb242bff/modules.=
dep: No such file or directory

[    3.397470] modprobe (98) used greatest stack depth: 5192 bytes left
[    3.399337] ftl_cs: FTL header not found.
[    3.407697] usbcore: registered new interface driver i2400m_usb
[    3.408787] usbcore: registered new interface driver cdc_phonet
[    3.409856] usbcore: registered new interface driver ipheth
[    3.413376] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    3.414383] usbcore: registered new interface driver cdc_wdm
[    3.415195] usbcore: registered new interface driver usbtmc
[    3.415943] usbcore: registered new interface driver microtekX6
[    3.416767] usbcore: registered new interface driver cytherm
[    3.417650] usbcore: registered new interface driver isight_firmware
[    3.418636] usbcore: registered new interface driver ldusb
[    3.419462] usbcore: registered new interface driver legousbtower
[    3.420360] usbcore: registered new interface driver usb_ehset_test
[    3.421262] usbcore: registered new interface driver trancevibrator
[    3.422134] usbcore: registered new interface driver usbsevseg
[    3.422896] usbcore: registered new interface driver yurex
[    3.424854] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    3.427342] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.428440] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.430707] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    3.431845] evbug: Connected device: input0 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    3.433501] usbcore: registered new interface driver aiptek
[    3.434302] usbcore: registered new interface driver gtco
[    3.435067] usbcore: registered new interface driver wacom
[    3.436444] mk712: device not present
[    3.437342] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    3.438196] cm109: Keymap for Komunikate KIP1000 phone loaded
[    3.439050] usbcore: registered new interface driver cm109
[    3.439714] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    3.440646] usbcore: registered new interface driver ims_pcu
[    3.441505] usbcore: registered new interface driver keyspan_remote
[    3.443764] i2c /dev entries driver
[    3.445226] i2c-parport-light: adapter type unspecified
[    3.445928] usbcore: registered new interface driver i2c-tiny-usb
[    3.447993] usbcore: registered new interface driver stkwebcam
[    3.448922] usbcore: registered new interface driver s2255
[    3.449637] cpia2: V4L-Driver for Vision CPiA2 based cameras v3.0.1
[    3.450601] usbcore: registered new interface driver cpia2
[    3.451448] usbcore: registered new interface driver sn9c102
[    3.452310] usbcore: registered new interface driver em28xx
[    3.453305] pps pps0: new PPS source ktimer
[    3.453791] pps pps0: ktimer PPS source registered
[    3.454425] pps_ldisc: PPS line discipline registered
[    3.455215] Driver for 1-wire Dallas network protocol.
[    3.459423] pc87360: PC8736x not detected, module not inserted
[    3.460676] md: raid0 personality registered for level 0
[    3.461373] md: raid1 personality registered for level 1
[    3.461969] md: raid10 personality registered for level 10
[    3.463227] md: raid6 personality registered for level 6
[    3.464239] md: raid5 personality registered for level 5
[    3.464914] md: raid4 personality registered for level 4
[    3.465586] md: multipath personality registered for level -4
[    3.466306] md: faulty personality registered for level -5
[    3.468483] device-mapper: uevent: version 1.0.3
[    3.470308] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised:=
 dm-devel@redhat.com
[    3.472639] device-mapper: multipath: version 1.6.0 loaded
[    3.473403] device-mapper: multipath round-robin: version 1.0.0 loaded
[    3.475178] device-mapper: raid: Loading target version 1.5.2
[    3.476601] ledtrig-cpu: registered to indicate activity on CPUs
[    3.554497] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    3.555716] hidraw: raw HID events driver (C) Jiri Kosina
[    3.558486] usbcore: registered new interface driver usbkbd
[    3.559404] acer_wmi: Acer Laptop ACPI-WMI Extras
[    3.559953] acer_wmi: No or unsupported WMI interface, unable to load
[    3.562329] NET: Registered protocol family 35
[    3.563815] 9pnet: Installing 9P2000 support
[    3.564785]=20
[    3.564785] printing PIC contents
[    3.565404] ... PIC  IMR: ffff
[    3.565763] ... PIC  IRR: 1013
[    3.566152] ... PIC  ISR: 0000
[    3.566568] ... PIC ELCR: 0c00
[    3.566949] printing local APIC contents on CPU#0/0:
[    3.567719] ... APIC ID:      00000000 (0)
[    3.567941] ... APIC VERSION: 00050014
[    3.567941] ... APIC TASKPRI: 00000000 (00)
[    3.567941] ... APIC PROCPRI: 00000000
[    3.567941] ... APIC LDR: 01000000
[    3.567941] ... APIC DFR: ffffffff
[    3.567941] ... APIC SPIV: 000001ff
[    3.567941] ... APIC ISR field:
[    3.567941] 000000000000000000000000000000000000000000000000000000000000=
0000
[    3.567941] ... APIC TMR field:
[    3.567941] 000000000200000000000000000000000000000000000000000000000000=
0000
[    3.567941] ... APIC IRR field:
[    3.567941] 000000000000000000000000000000000000000000000000000000000000=
0000
[    3.567941] ... APIC ESR: 00000000
[    3.567941] ... APIC ICR: 000008fd
[    3.567941] ... APIC ICR2: 02000000
[    3.567941] ... APIC LVTT: 000000ef
[    3.567941] ... APIC LVTPC: 00010000
[    3.567941] ... APIC LVT0: 00010700
[    3.567941] ... APIC LVT1: 00000400
[    3.567941] ... APIC LVTERR: 000000fe
[    3.567941] ... APIC TMICT: 02427796
[    3.567941] ... APIC TMCCT: 01d92468
[    3.567941] ... APIC TDCR: 00000003
[    3.567941]=20
[    3.585262] number of MP IRQ sources: 15.
[    3.585727] number of IO-APIC #0 registers: 24.
[    3.586266] testing the IO APIC.......................
[    3.586864] IO APIC #0......
[    3.587226] .... register #00: 00000000
[    3.587674] .......    : physical APIC id: 00
[    3.588198] .......    : Delivery Type: 0
[    3.588657] .......    : LTS          : 0
[    3.589141] .... register #01: 00170011
[    3.589578] .......     : max redirection entries: 17
[    3.590179] .......     : PRQ implemented: 0
[    3.590666] .......     : IO APIC version: 11
[    3.591192] .... register #02: 00000000
[    3.591630] .......     : arbitration: 00
[    3.592116] .... IRQ redirection table:
[    3.592567] 1    0    0   0   0    0    0    00
[    3.593119] 0    0    0   0   0    1    1    31
[    3.593644] 0    0    0   0   0    1    1    30
[    3.594195] 0    0    0   0   0    1    1    33
[    3.594724] 1    0    0   0   0    1    1    34
[    3.595276] 1    1    0   0   0    1    1    35
[    3.595804] 0    0    0   0   0    1    1    36
[    3.596355] 0    0    0   0   0    1    1    37
[    3.596884] 0    0    0   0   0    1    1    38
[    3.597440] 0    1    0   0   0    1    1    39
[    3.597974] 1    1    0   0   0    1    1    3A
[    3.598530] 1    1    0   0   0    1    1    3B
[    3.599089] 0    0    0   0   0    1    1    3C
[    3.599615] 0    0    0   0   0    1    1    3D
[    3.600166] 0    0    0   0   0    1    1    3E
[    3.600687] 0    0    0   0   0    1    1    3F
[    3.601239] 1    0    0   0   0    0    0    00
[    3.601763] 1    0    0   0   0    0    0    00
[    3.602311] 1    0    0   0   0    0    0    00
[    3.602835] 1    0    0   0   0    0    0    00
[    3.603382] 1    0    0   0   0    0    0    00
[    3.603904] 1    0    0   0   0    0    0    00
[    3.604454] 1    0    0   0   0    0    0    00
[    3.604977] 1    0    0   0   0    0    0    00
[    3.605519] IRQ to pin mappings:
[    3.605891] IRQ0 -> 0:2
[    3.606241] IRQ1 -> 0:1
[    3.606561] IRQ3 -> 0:3
[    3.606877] IRQ4 -> 0:4
[    3.607228] IRQ5 -> 0:5
[    3.607645] IRQ6 -> 0:6
[    3.608211] IRQ7 -> 0:7
[    3.608642] IRQ8 -> 0:8
[    3.609055] IRQ9 -> 0:9
[    3.609457] IRQ10 -> 0:10
[    3.609869] IRQ11 -> 0:11
[    3.610240] IRQ12 -> 0:12
[    3.610585] IRQ13 -> 0:13
[    3.610919] IRQ14 -> 0:14
[    3.611293] IRQ15 -> 0:15
[    3.611640] .................................... done.
[    3.613047] Loading module verification certificates
[    3.614781] MODSIGN: Loaded cert 'Magrathea: Glacier signing key: 6184ef=
742e72a079337091b0adb8bdb683d305f0'
[    3.616059] registered taskstats version 1
modprobe: FATAL: Could not load /lib/modules/3.12.0-11285-gb242bff/modules.=
dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-11285-gb242bff/modules.=
dep: No such file or directory

[    3.634742] Key type encrypted registered
modprobe: FATAL: Could not load /lib/modules/3.12.0-11285-gb242bff/modules.=
dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-11285-gb242bff/modules.=
dep: No such file or directory

[    3.652205] raid6test: testing the 4-disk case...
[    3.652853] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[    3.653706] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(P) =
 OK
[    3.654567] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(Q) =
 OK
[    3.655464] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(P) =
 OK
[    3.656286] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(Q) =
 OK
[    3.657084] raid6test: test_disks(2, 3): faila=3D  2(P)  failb=3D  3(Q) =
 OK
[    3.657921] raid6test: testing the 5-disk case...
[    3.658759] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[    3.659596] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[    3.660427] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(P) =
 OK
[    3.661327] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(Q) =
 OK
[    3.662141] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[    3.662938] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(P) =
 OK
[    3.663754] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(Q) =
 OK
[    3.664663] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(P) =
 OK
[    3.665478] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(Q) =
 OK
[    3.666299] raid6test: test_disks(3, 4): faila=3D  3(P)  failb=3D  4(Q) =
 OK
[    3.667181] raid6test: testing the 11-disk case...
[    3.667795] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[    3.668640] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[    3.669601] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[    3.670864] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[    3.672109] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[    3.673390] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[    3.674633] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[    3.675731] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[    3.676690] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(P) =
 OK
[    3.677590] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(Q)=
  OK
[    3.678819] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[    3.679786] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[    3.680674] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[    3.681585] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[    3.682509] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[    3.683386] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[    3.684299] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[    3.685222] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(P) =
 OK
[    3.686065] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(Q)=
  OK
[    3.687058] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[    3.688049] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[    3.688874] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[    3.689730] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[    3.690672] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[    3.691598] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[    3.692587] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(P) =
 OK
[    3.693440] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(Q)=
  OK
[    3.694490] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[    3.695365] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[    3.696217] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[    3.697075] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[    3.697931] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[    3.699148] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(P) =
 OK
[    3.700406] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(Q)=
  OK
[    3.701454] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[    3.702716] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[    3.703833] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[    3.704939] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[    3.705958] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(P) =
 OK
[    3.707066] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(Q)=
  OK
[    3.708247] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[    3.709431] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[    3.710265] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[    3.711084] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(P) =
 OK
[    3.711872] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(Q)=
  OK
[    3.712720] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[    3.713566] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[    3.714408] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(P) =
 OK
[    3.715217] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(Q)=
  OK
[    3.716067] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[    3.716870] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(P) =
 OK
[    3.717714] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(Q)=
  OK
[    3.718567] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(P) =
 OK
[    3.719394] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(Q)=
  OK
[    3.720205] raid6test: test_disks(9, 10): faila=3D  9(P)  failb=3D 10(Q)=
  OK
[    3.721113] raid6test: testing the 12-disk case...
[    3.721724] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[    3.722565] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[    3.723410] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[    3.724245] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[    3.725068] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[    3.725873] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[    3.726722] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[    3.727587] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[    3.728434] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(D) =
 OK
[    3.729264] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(P)=
  OK
[    3.730082] raid6test: test_disks(0, 11): faila=3D  0(D)  failb=3D 11(Q)=
  OK
[    3.730896] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[    3.731742] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[    3.732592] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[    3.733439] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[    3.734264] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[    3.735087] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[    3.735912] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[    3.736776] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(D) =
 OK
[    3.737652] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(P)=
  OK
[    3.738508] raid6test: test_disks(1, 11): faila=3D  1(D)  failb=3D 11(Q)=
  OK
[    3.739385] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[    3.740242] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[    3.741086] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[    3.741967] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[    3.742847] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[    3.743773] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[    3.744699] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(D) =
 OK
[    3.745625] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(P)=
  OK
[    3.746548] raid6test: test_disks(2, 11): faila=3D  2(D)  failb=3D 11(Q)=
  OK
[    3.747479] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[    3.748427] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[    3.749356] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[    3.750271] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[    3.751184] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[    3.752094] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(D) =
 OK
[    3.752930] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(P)=
  OK
[    3.753818] raid6test: test_disks(3, 11): faila=3D  3(D)  failb=3D 11(Q)=
  OK
[    3.754752] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[    3.755673] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[    3.756596] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[    3.757517] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[    3.758426] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(D) =
 OK
[    3.759310] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(P)=
  OK
[    3.760177] raid6test: test_disks(4, 11): faila=3D  4(D)  failb=3D 11(Q)=
  OK
[    3.760982] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[    3.761843] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[    3.762701] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[    3.763563] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(D) =
 OK
[    3.764416] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(P)=
  OK
[    3.765260] raid6test: test_disks(5, 11): faila=3D  5(D)  failb=3D 11(Q)=
  OK
[    3.766104] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[    3.766908] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[    3.767790] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(D) =
 OK
[    3.768645] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(P)=
  OK
[    3.769499] raid6test: test_disks(6, 11): faila=3D  6(D)  failb=3D 11(Q)=
  OK
[    3.770374] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[    3.771223] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(D) =
 OK
[    3.772056] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(P)=
  OK
[    3.772851] raid6test: test_disks(7, 11): faila=3D  7(D)  failb=3D 11(Q)=
  OK
[    3.773724] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(D) =
 OK
[    3.774580] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(P)=
  OK
[    3.775428] raid6test: test_disks(8, 11): faila=3D  8(D)  failb=3D 11(Q)=
  OK
[    3.776286] raid6test: test_disks(9, 10): faila=3D  9(D)  failb=3D 10(P)=
  OK
[    3.777119] raid6test: test_disks(9, 11): faila=3D  9(D)  failb=3D 11(Q)=
  OK
[    3.777919] raid6test: test_disks(10, 11): faila=3D 10(P)  failb=3D 11(Q=
)  OK
[    3.778998] raid6test: testing the 24-disk case...
[    3.779685] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[    3.780557] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[    3.781425] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[    3.782285] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[    3.783131] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[    3.783945] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[    3.784813] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[    3.785685] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[    3.786559] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(D) =
 OK
[    3.787429] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(D)=
  OK
[    3.788319] raid6test: test_disks(0, 11): faila=3D  0(D)  failb=3D 11(D)=
  OK
[    3.789182] raid6test: test_disks(0, 12): faila=3D  0(D)  failb=3D 12(D)=
  OK
[    3.790055] raid6test: test_disks(0, 13): faila=3D  0(D)  failb=3D 13(D)=
  OK
[    3.790878] raid6test: test_disks(0, 14): faila=3D  0(D)  failb=3D 14(D)=
  OK
[    3.791752] raid6test: test_disks(0, 15): faila=3D  0(D)  failb=3D 15(D)=
  OK
[    3.792634] raid6test: test_disks(0, 16): faila=3D  0(D)  failb=3D 16(D)=
  OK
[    3.793509] raid6test: test_disks(0, 17): faila=3D  0(D)  failb=3D 17(D)=
  OK
[    3.794393] raid6test: test_disks(0, 18): faila=3D  0(D)  failb=3D 18(D)=
  OK
[    3.795259] raid6test: test_disks(0, 19): faila=3D  0(D)  failb=3D 19(D)=
  OK
[    3.796112] raid6test: test_disks(0, 20): faila=3D  0(D)  failb=3D 20(D)=
  OK
[    3.796934] raid6test: test_disks(0, 21): faila=3D  0(D)  failb=3D 21(D)=
  OK
[    3.797821] raid6test: test_disks(0, 22): faila=3D  0(D)  failb=3D 22(P)=
  OK
[    3.798688] raid6test: test_disks(0, 23): faila=3D  0(D)  failb=3D 23(Q)=
  OK
[    3.799569] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[    3.800440] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[    3.801300] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[    3.802154] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[    3.802968] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[    3.803839] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[    3.804711] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[    3.805581] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(D) =
 OK
[    3.806442] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(D)=
  OK
[    3.807309] raid6test: test_disks(1, 11): faila=3D  1(D)  failb=3D 11(D)=
  OK
[    3.808182] raid6test: test_disks(1, 12): faila=3D  1(D)  failb=3D 12(D)=
  OK
[    3.809002] raid6test: test_disks(1, 13): faila=3D  1(D)  failb=3D 13(D)=
  OK
[    3.809880] raid6test: test_disks(1, 14): faila=3D  1(D)  failb=3D 14(D)=
  OK
[    3.810759] raid6test: test_disks(1, 15): faila=3D  1(D)  failb=3D 15(D)=
  OK
[    3.811639] raid6test: test_disks(1, 16): faila=3D  1(D)  failb=3D 16(D)=
  OK
[    3.812515] raid6test: test_disks(1, 17): faila=3D  1(D)  failb=3D 17(D)=
  OK
[    3.813400] raid6test: test_disks(1, 18): faila=3D  1(D)  failb=3D 18(D)=
  OK
[    3.814269] raid6test: test_disks(1, 19): faila=3D  1(D)  failb=3D 19(D)=
  OK
[    3.815122] raid6test: test_disks(1, 20): faila=3D  1(D)  failb=3D 20(D)=
  OK
[    3.815945] raid6test: test_disks(1, 21): faila=3D  1(D)  failb=3D 21(D)=
  OK
[    3.816817] raid6test: test_disks(1, 22): faila=3D  1(D)  failb=3D 22(P)=
  OK
[    3.817704] raid6test: test_disks(1, 23): faila=3D  1(D)  failb=3D 23(Q)=
  OK
[    3.818583] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[    3.819450] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[    3.820316] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[    3.821171] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[    3.821986] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[    3.822853] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[    3.823726] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(D) =
 OK
[    3.824595] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(D)=
  OK
[    3.825473] raid6test: test_disks(2, 11): faila=3D  2(D)  failb=3D 11(D)=
  OK
[    3.826355] raid6test: test_disks(2, 12): faila=3D  2(D)  failb=3D 12(D)=
  OK
[    3.827225] raid6test: test_disks(2, 13): faila=3D  2(D)  failb=3D 13(D)=
  OK
[    3.828082] raid6test: test_disks(2, 14): faila=3D  2(D)  failb=3D 14(D)=
  OK
[    3.828908] raid6test: test_disks(2, 15): faila=3D  2(D)  failb=3D 15(D)=
  OK
[    3.829787] raid6test: test_disks(2, 16): faila=3D  2(D)  failb=3D 16(D)=
  OK
[    3.830670] raid6test: test_disks(2, 17): faila=3D  2(D)  failb=3D 17(D)=
  OK
[    3.831545] raid6test: test_disks(2, 18): faila=3D  2(D)  failb=3D 18(D)=
  OK
[    3.832423] raid6test: test_disks(2, 19): faila=3D  2(D)  failb=3D 19(D)=
  OK
[    3.833291] raid6test: test_disks(2, 20): faila=3D  2(D)  failb=3D 20(D)=
  OK
[    3.834159] raid6test: test_disks(2, 21): faila=3D  2(D)  failb=3D 21(D)=
  OK
[    3.834981] raid6test: test_disks(2, 22): faila=3D  2(D)  failb=3D 22(P)=
  OK
[    3.835844] raid6test: test_disks(2, 23): faila=3D  2(D)  failb=3D 23(Q)=
  OK
[    3.836725] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[    3.837608] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[    3.838479] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[    3.839352] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[    3.840204] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[    3.841049] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(D) =
 OK
[    3.841868] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(D)=
  OK
[    3.842745] raid6test: test_disks(3, 11): faila=3D  3(D)  failb=3D 11(D)=
  OK
[    3.843620] raid6test: test_disks(3, 12): faila=3D  3(D)  failb=3D 12(D)=
  OK
[    3.844498] raid6test: test_disks(3, 13): faila=3D  3(D)  failb=3D 13(D)=
  OK
[    3.845380] raid6test: test_disks(3, 14): faila=3D  3(D)  failb=3D 14(D)=
  OK
[    3.846247] raid6test: test_disks(3, 15): faila=3D  3(D)  failb=3D 15(D)=
  OK
[    3.847091] raid6test: test_disks(3, 16): faila=3D  3(D)  failb=3D 16(D)=
  OK
[    3.847921] raid6test: test_disks(3, 17): faila=3D  3(D)  failb=3D 17(D)=
  OK
[    3.848797] raid6test: test_disks(3, 18): faila=3D  3(D)  failb=3D 18(D)=
  OK
[    3.849678] raid6test: test_disks(3, 19): faila=3D  3(D)  failb=3D 19(D)=
  OK
[    3.850560] raid6test: test_disks(3, 20): faila=3D  3(D)  failb=3D 20(D)=
  OK
[    3.851436] raid6test: test_disks(3, 21): faila=3D  3(D)  failb=3D 21(D)=
  OK
[    3.852306] raid6test: test_disks(3, 22): faila=3D  3(D)  failb=3D 22(P)=
  OK
[    3.853158] raid6test: test_disks(3, 23): faila=3D  3(D)  failb=3D 23(Q)=
  OK
[    3.853978] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[    3.854851] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[    3.855719] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[    3.856590] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[    3.857460] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(D) =
 OK
[    3.858342] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(D)=
  OK
[    3.859201] raid6test: test_disks(4, 11): faila=3D  4(D)  failb=3D 11(D)=
  OK
[    3.860057] raid6test: test_disks(4, 12): faila=3D  4(D)  failb=3D 12(D)=
  OK
[    3.860885] raid6test: test_disks(4, 13): faila=3D  4(D)  failb=3D 13(D)=
  OK
[    3.861766] raid6test: test_disks(4, 14): faila=3D  4(D)  failb=3D 14(D)=
  OK
[    3.862650] raid6test: test_disks(4, 15): faila=3D  4(D)  failb=3D 15(D)=
  OK
[    3.863530] raid6test: test_disks(4, 16): faila=3D  4(D)  failb=3D 16(D)=
  OK
[    3.864412] raid6test: test_disks(4, 17): faila=3D  4(D)  failb=3D 17(D)=
  OK
[    3.865286] raid6test: test_disks(4, 18): faila=3D  4(D)  failb=3D 18(D)=
  OK
[    3.866162] raid6test: test_disks(4, 19): faila=3D  4(D)  failb=3D 19(D)=
  OK
[    3.867078] raid6test: test_disks(4, 20): faila=3D  4(D)  failb=3D 20(D)=
  OK
[    3.867924] raid6test: test_disks(4, 21): faila=3D  4(D)  failb=3D 21(D)=
  OK
[    3.868807] raid6test: test_disks(4, 22): faila=3D  4(D)  failb=3D 22(P)=
  OK
[    3.869681] raid6test: test_disks(4, 23): faila=3D  4(D)  failb=3D 23(Q)=
  OK
[    3.870562] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[    3.871433] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[    3.872287] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[    3.873199] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(D) =
 OK
[    3.874302] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(D)=
  OK
[    3.875458] raid6test: test_disks(5, 11): faila=3D  5(D)  failb=3D 11(D)=
  OK
[    3.876319] raid6test: test_disks(5, 12): faila=3D  5(D)  failb=3D 12(D)=
  OK
[    3.877180] raid6test: test_disks(5, 13): faila=3D  5(D)  failb=3D 13(D)=
  OK
[    3.878052] raid6test: test_disks(5, 14): faila=3D  5(D)  failb=3D 14(D)=
  OK
[    3.878897] raid6test: test_disks(5, 15): faila=3D  5(D)  failb=3D 15(D)=
  OK
[    3.879794] raid6test: test_disks(5, 16): faila=3D  5(D)  failb=3D 16(D)=
  OK
[    3.880679] raid6test: test_disks(5, 17): faila=3D  5(D)  failb=3D 17(D)=
  OK
[    3.881572] raid6test: test_disks(5, 18): faila=3D  5(D)  failb=3D 18(D)=
  OK
[    3.882442] raid6test: test_disks(5, 19): faila=3D  5(D)  failb=3D 19(D)=
  OK
[    3.883328] raid6test: test_disks(5, 20): faila=3D  5(D)  failb=3D 20(D)=
  OK
[    3.884198] raid6test: test_disks(5, 21): faila=3D  5(D)  failb=3D 21(D)=
  OK
[    3.885001] raid6test: test_disks(5, 22): faila=3D  5(D)  failb=3D 22(P)=
  OK
[    3.885864] raid6test: test_disks(5, 23): faila=3D  5(D)  failb=3D 23(Q)=
  OK
[    3.886742] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[    3.887895] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[    3.889163] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(D) =
 OK
[    3.890174] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(D)=
  OK
[    3.891092] raid6test: test_disks(6, 11): faila=3D  6(D)  failb=3D 11(D)=
  OK
[    3.891918] raid6test: test_disks(6, 12): faila=3D  6(D)  failb=3D 12(D)=
  OK
[    3.892794] raid6test: test_disks(6, 13): faila=3D  6(D)  failb=3D 13(D)=
  OK
[    3.893670] raid6test: test_disks(6, 14): faila=3D  6(D)  failb=3D 14(D)=
  OK
[    3.894501] raid6test: test_disks(6, 15): faila=3D  6(D)  failb=3D 15(D)=
  OK
[    3.895331] raid6test: test_disks(6, 16): faila=3D  6(D)  failb=3D 16(D)=
  OK
[    3.896169] raid6test: test_disks(6, 17): faila=3D  6(D)  failb=3D 17(D)=
  OK
[    3.896974] raid6test: test_disks(6, 18): faila=3D  6(D)  failb=3D 18(D)=
  OK
[    3.897834] raid6test: test_disks(6, 19): faila=3D  6(D)  failb=3D 19(D)=
  OK
[    3.898681] raid6test: test_disks(6, 20): faila=3D  6(D)  failb=3D 20(D)=
  OK
[    3.899514] raid6test: test_disks(6, 21): faila=3D  6(D)  failb=3D 21(D)=
  OK
[    3.900343] raid6test: test_disks(6, 22): faila=3D  6(D)  failb=3D 22(P)=
  OK
[    3.901166] raid6test: test_disks(6, 23): faila=3D  6(D)  failb=3D 23(Q)=
  OK
[    3.901971] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[    3.902801] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(D) =
 OK
[    3.903636] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(D)=
  OK
[    3.904469] raid6test: test_disks(7, 11): faila=3D  7(D)  failb=3D 11(D)=
  OK
[    3.905301] raid6test: test_disks(7, 12): faila=3D  7(D)  failb=3D 12(D)=
  OK
[    3.906136] raid6test: test_disks(7, 13): faila=3D  7(D)  failb=3D 13(D)=
  OK
[    3.906939] raid6test: test_disks(7, 14): faila=3D  7(D)  failb=3D 14(D)=
  OK
[    3.907913] raid6test: test_disks(7, 15): faila=3D  7(D)  failb=3D 15(D)=
  OK
[    3.909040] raid6test: test_disks(7, 16): faila=3D  7(D)  failb=3D 16(D)=
  OK
[    3.909849] raid6test: test_disks(7, 17): faila=3D  7(D)  failb=3D 17(D)=
  OK
[    3.910693] raid6test: test_disks(7, 18): faila=3D  7(D)  failb=3D 18(D)=
  OK
[    3.911570] raid6test: test_disks(7, 19): faila=3D  7(D)  failb=3D 19(D)=
  OK
[    3.912432] raid6test: test_disks(7, 20): faila=3D  7(D)  failb=3D 20(D)=
  OK
[    3.913273] raid6test: test_disks(7, 21): faila=3D  7(D)  failb=3D 21(D)=
  OK
[    3.914358] raid6test: test_disks(7, 22): faila=3D  7(D)  failb=3D 22(P)=
  OK
[    3.915247] raid6test: test_disks(7, 23): faila=3D  7(D)  failb=3D 23(Q)=
  OK
[    3.916087] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(D) =
 OK
[    3.916882] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(D)=
  OK
[    3.917809] raid6test: test_disks(8, 11): faila=3D  8(D)  failb=3D 11(D)=
  OK
[    3.918678] raid6test: test_disks(8, 12): faila=3D  8(D)  failb=3D 12(D)=
  OK
[    3.919510] raid6test: test_disks(8, 13): faila=3D  8(D)  failb=3D 13(D)=
  OK
[    3.920342] raid6test: test_disks(8, 14): faila=3D  8(D)  failb=3D 14(D)=
  OK
[    3.921183] raid6test: test_disks(8, 15): faila=3D  8(D)  failb=3D 15(D)=
  OK
[    3.922046] raid6test: test_disks(8, 16): faila=3D  8(D)  failb=3D 16(D)=
  OK
[    3.922852] raid6test: test_disks(8, 17): faila=3D  8(D)  failb=3D 17(D)=
  OK
[    3.923700] raid6test: test_disks(8, 18): faila=3D  8(D)  failb=3D 18(D)=
  OK
[    3.924534] raid6test: test_disks(8, 19): faila=3D  8(D)  failb=3D 19(D)=
  OK
[    3.925396] raid6test: test_disks(8, 20): faila=3D  8(D)  failb=3D 20(D)=
  OK
[    3.926228] raid6test: test_disks(8, 21): faila=3D  8(D)  failb=3D 21(D)=
  OK
[    3.927063] raid6test: test_disks(8, 22): faila=3D  8(D)  failb=3D 22(P)=
  OK
[    3.927886] raid6test: test_disks(8, 23): faila=3D  8(D)  failb=3D 23(Q)=
  OK
[    3.928764] raid6test: test_disks(9, 10): faila=3D  9(D)  failb=3D 10(D)=
  OK
[    3.929612] raid6test: test_disks(9, 11): faila=3D  9(D)  failb=3D 11(D)=
  OK
[    3.930447] raid6test: test_disks(9, 12): faila=3D  9(D)  failb=3D 12(D)=
  OK
[    3.931280] raid6test: test_disks(9, 13): faila=3D  9(D)  failb=3D 13(D)=
  OK
[    3.932144] raid6test: test_disks(9, 14): faila=3D  9(D)  failb=3D 14(D)=
  OK
[    3.932950] raid6test: test_disks(9, 15): faila=3D  9(D)  failb=3D 15(D)=
  OK
[    3.933794] raid6test: test_disks(9, 16): faila=3D  9(D)  failb=3D 16(D)=
  OK
[    3.934638] raid6test: test_disks(9, 17): faila=3D  9(D)  failb=3D 17(D)=
  OK
[    3.935504] raid6test: test_disks(9, 18): faila=3D  9(D)  failb=3D 18(D)=
  OK
[    3.936343] raid6test: test_disks(9, 19): faila=3D  9(D)  failb=3D 19(D)=
  OK
[    3.937185] raid6test: test_disks(9, 20): faila=3D  9(D)  failb=3D 20(D)=
  OK
[    3.938059] raid6test: test_disks(9, 21): faila=3D  9(D)  failb=3D 21(D)=
  OK
[    3.938888] raid6test: test_disks(9, 22): faila=3D  9(D)  failb=3D 22(P)=
  OK
[    3.939725] raid6test: test_disks(9, 23): faila=3D  9(D)  failb=3D 23(Q)=
  OK
[    3.940575] raid6test: test_disks(10, 11): faila=3D 10(D)  failb=3D 11(D=
)  OK
[    3.941424] raid6test: test_disks(10, 12): faila=3D 10(D)  failb=3D 12(D=
)  OK
[    3.942297] raid6test: test_disks(10, 13): faila=3D 10(D)  failb=3D 13(D=
)  OK
[    3.943147] raid6test: test_disks(10, 14): faila=3D 10(D)  failb=3D 14(D=
)  OK
[    3.943964] raid6test: test_disks(10, 15): faila=3D 10(D)  failb=3D 15(D=
)  OK
[    3.944831] raid6test: test_disks(10, 16): faila=3D 10(D)  failb=3D 16(D=
)  OK
[    3.945726] raid6test: test_disks(10, 17): faila=3D 10(D)  failb=3D 17(D=
)  OK
[    3.946580] raid6test: test_disks(10, 18): faila=3D 10(D)  failb=3D 18(D=
)  OK
[    3.947429] raid6test: test_disks(10, 19): faila=3D 10(D)  failb=3D 19(D=
)  OK
[    3.948305] raid6test: test_disks(10, 20): faila=3D 10(D)  failb=3D 20(D=
)  OK
[    3.949191] raid6test: test_disks(10, 21): faila=3D 10(D)  failb=3D 21(D=
)  OK
[    3.950463] raid6test: test_disks(10, 22): faila=3D 10(D)  failb=3D 22(P=
)  OK
[    3.951298] raid6test: test_disks(10, 23): faila=3D 10(D)  failb=3D 23(Q=
)  OK
[    3.952188] raid6test: test_disks(11, 12): faila=3D 11(D)  failb=3D 12(D=
)  OK
[    3.953049] raid6test: test_disks(11, 13): faila=3D 11(D)  failb=3D 13(D=
)  OK
[    3.953869] raid6test: test_disks(11, 14): faila=3D 11(D)  failb=3D 14(D=
)  OK
[    3.954725] raid6test: test_disks(11, 15): faila=3D 11(D)  failb=3D 15(D=
)  OK
[    3.955614] raid6test: test_disks(11, 16): faila=3D 11(D)  failb=3D 16(D=
)  OK
[    3.956832] raid6test: test_disks(11, 17): faila=3D 11(D)  failb=3D 17(D=
)  OK
[    3.957800] raid6test: test_disks(11, 18): faila=3D 11(D)  failb=3D 18(D=
)  OK
[    3.958691] raid6test: test_disks(11, 19): faila=3D 11(D)  failb=3D 19(D=
)  OK
[    3.959537] raid6test: test_disks(11, 20): faila=3D 11(D)  failb=3D 20(D=
)  OK
[    3.960388] raid6test: test_disks(11, 21): faila=3D 11(D)  failb=3D 21(D=
)  OK
[    3.961235] raid6test: test_disks(11, 22): faila=3D 11(D)  failb=3D 22(P=
)  OK
[    3.962108] raid6test: test_disks(11, 23): faila=3D 11(D)  failb=3D 23(Q=
)  OK
[    3.962917] raid6test: test_disks(12, 13): faila=3D 12(D)  failb=3D 13(D=
)  OK
[    3.963773] raid6test: test_disks(12, 14): faila=3D 12(D)  failb=3D 14(D=
)  OK
[    3.964622] raid6test: test_disks(12, 15): faila=3D 12(D)  failb=3D 15(D=
)  OK
[    3.965502] raid6test: test_disks(12, 16): faila=3D 12(D)  failb=3D 16(D=
)  OK
[    3.966353] raid6test: test_disks(12, 17): faila=3D 12(D)  failb=3D 17(D=
)  OK
[    3.967199] raid6test: test_disks(12, 18): faila=3D 12(D)  failb=3D 18(D=
)  OK
[    3.968085] raid6test: test_disks(12, 19): faila=3D 12(D)  failb=3D 19(D=
)  OK
[    3.968934] raid6test: test_disks(12, 20): faila=3D 12(D)  failb=3D 20(D=
)  OK
[    3.969792] raid6test: test_disks(12, 21): faila=3D 12(D)  failb=3D 21(D=
)  OK
[    3.970649] raid6test: test_disks(12, 22): faila=3D 12(D)  failb=3D 22(P=
)  OK
[    3.971477] raid6test: test_disks(12, 23): faila=3D 12(D)  failb=3D 23(Q=
)  OK
[    3.972361] raid6test: test_disks(13, 14): faila=3D 13(D)  failb=3D 14(D=
)  OK
[    3.973210] raid6test: test_disks(13, 15): faila=3D 13(D)  failb=3D 15(D=
)  OK
[    3.974059] raid6test: test_disks(13, 16): faila=3D 13(D)  failb=3D 16(D=
)  OK
[    3.974875] raid6test: test_disks(13, 17): faila=3D 13(D)  failb=3D 17(D=
)  OK
[    3.975769] raid6test: test_disks(13, 18): faila=3D 13(D)  failb=3D 18(D=
)  OK
[    3.976617] raid6test: test_disks(13, 19): faila=3D 13(D)  failb=3D 19(D=
)  OK
[    3.977461] raid6test: test_disks(13, 20): faila=3D 13(D)  failb=3D 20(D=
)  OK
[    3.978324] raid6test: test_disks(13, 21): faila=3D 13(D)  failb=3D 21(D=
)  OK
[    3.979224] raid6test: test_disks(13, 22): faila=3D 13(D)  failb=3D 22(P=
)  OK
[    3.980060] raid6test: test_disks(13, 23): faila=3D 13(D)  failb=3D 23(Q=
)  OK
[    3.980884] raid6test: test_disks(14, 15): faila=3D 14(D)  failb=3D 15(D=
)  OK
[    3.981748] raid6test: test_disks(14, 16): faila=3D 14(D)  failb=3D 16(D=
)  OK
[    3.982630] raid6test: test_disks(14, 17): faila=3D 14(D)  failb=3D 17(D=
)  OK
[    3.983477] raid6test: test_disks(14, 18): faila=3D 14(D)  failb=3D 18(D=
)  OK
[    3.984326] raid6test: test_disks(14, 19): faila=3D 14(D)  failb=3D 19(D=
)  OK
[    3.985197] raid6test: test_disks(14, 20): faila=3D 14(D)  failb=3D 20(D=
)  OK
[    3.986051] raid6test: test_disks(14, 21): faila=3D 14(D)  failb=3D 21(D=
)  OK
[    3.986866] raid6test: test_disks(14, 22): faila=3D 14(D)  failb=3D 22(P=
)  OK
[    3.987738] raid6test: test_disks(14, 23): faila=3D 14(D)  failb=3D 23(Q=
)  OK
[    3.988619] raid6test: test_disks(15, 16): faila=3D 15(D)  failb=3D 16(D=
)  OK
[    3.989466] raid6test: test_disks(15, 17): faila=3D 15(D)  failb=3D 17(D=
)  OK
[    3.990319] raid6test: test_disks(15, 18): faila=3D 15(D)  failb=3D 18(D=
)  OK
[    3.991166] raid6test: test_disks(15, 19): faila=3D 15(D)  failb=3D 19(D=
)  OK
[    3.992076] raid6test: test_disks(15, 20): faila=3D 15(D)  failb=3D 20(D=
)  OK
[    3.992894] raid6test: test_disks(15, 21): faila=3D 15(D)  failb=3D 21(D=
)  OK
[    3.993750] raid6test: test_disks(15, 22): faila=3D 15(D)  failb=3D 22(P=
)  OK
[    3.994588] raid6test: test_disks(15, 23): faila=3D 15(D)  failb=3D 23(Q=
)  OK
[    3.995455] raid6test: test_disks(16, 17): faila=3D 16(D)  failb=3D 17(D=
)  OK
[    3.996336] raid6test: test_disks(16, 18): faila=3D 16(D)  failb=3D 18(D=
)  OK
[    3.997187] raid6test: test_disks(16, 19): faila=3D 16(D)  failb=3D 19(D=
)  OK
[    3.998061] raid6test: test_disks(16, 20): faila=3D 16(D)  failb=3D 20(D=
)  OK
[    3.998894] raid6test: test_disks(16, 21): faila=3D 16(D)  failb=3D 21(D=
)  OK
[    3.999765] raid6test: test_disks(16, 22): faila=3D 16(D)  failb=3D 22(P=
)  OK
[    4.000609] raid6test: test_disks(16, 23): faila=3D 16(D)  failb=3D 23(Q=
)  OK
[    4.001833] raid6test: test_disks(17, 18): faila=3D 17(D)  failb=3D 18(D=
)  OK
[    4.002937] raid6test: test_disks(17, 19): faila=3D 17(D)  failb=3D 19(D=
)  OK
[    4.003982] raid6test: test_disks(17, 20): faila=3D 17(D)  failb=3D 20(D=
)  OK
[    4.004832] raid6test: test_disks(17, 21): faila=3D 17(D)  failb=3D 21(D=
)  OK
[    4.005782] raid6test: test_disks(17, 22): faila=3D 17(D)  failb=3D 22(P=
)  OK
[    4.006652] raid6test: test_disks(17, 23): faila=3D 17(D)  failb=3D 23(Q=
)  OK
[    4.007525] raid6test: test_disks(18, 19): faila=3D 18(D)  failb=3D 19(D=
)  OK
[    4.008435] raid6test: test_disks(18, 20): faila=3D 18(D)  failb=3D 20(D=
)  OK
[    4.009350] raid6test: test_disks(18, 21): faila=3D 18(D)  failb=3D 21(D=
)  OK
[    4.010204] raid6test: test_disks(18, 22): faila=3D 18(D)  failb=3D 22(P=
)  OK
[    4.011052] raid6test: test_disks(18, 23): faila=3D 18(D)  failb=3D 23(Q=
)  OK
[    4.011909] raid6test: test_disks(19, 20): faila=3D 19(D)  failb=3D 20(D=
)  OK
[    4.012786] raid6test: test_disks(19, 21): faila=3D 19(D)  failb=3D 21(D=
)  OK
[    4.013800] raid6test: test_disks(19, 22): faila=3D 19(D)  failb=3D 22(P=
)  OK
[    4.014686] raid6test: test_disks(19, 23): faila=3D 19(D)  failb=3D 23(Q=
)  OK
[    4.015601] raid6test: test_disks(20, 21): faila=3D 20(D)  failb=3D 21(D=
)  OK
[    4.016482] raid6test: test_disks(20, 22): faila=3D 20(D)  failb=3D 22(P=
)  OK
[    4.017386] raid6test: test_disks(20, 23): faila=3D 20(D)  failb=3D 23(Q=
)  OK
[    4.018289] raid6test: test_disks(21, 22): faila=3D 21(D)  failb=3D 22(P=
)  OK
[    4.019158] raid6test: test_disks(21, 23): faila=3D 21(D)  failb=3D 23(Q=
)  OK
[    4.019987] raid6test: test_disks(22, 23): faila=3D 22(P)  failb=3D 23(Q=
)  OK
[    4.021652] raid6test: testing the 64-disk case...
[    4.022390] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[    4.023329] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[    4.024254] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[    4.025202] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[    4.026122] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[    4.027046] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[    4.027961] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[    4.028911] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[    4.029872] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(D) =
 OK
[    4.030804] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(D)=
  OK
[    4.031747] raid6test: test_disks(0, 11): faila=3D  0(D)  failb=3D 11(D)=
  OK
[    4.032690] raid6test: test_disks(0, 12): faila=3D  0(D)  failb=3D 12(D)=
  OK
[    4.033663] raid6test: test_disks(0, 13): faila=3D  0(D)  failb=3D 13(D)=
  OK
[    4.034591] raid6test: test_disks(0, 14): faila=3D  0(D)  failb=3D 14(D)=
  OK
[    4.035536] raid6test: test_disks(0, 15): faila=3D  0(D)  failb=3D 15(D)=
  OK
[    4.036457] raid6test: test_disks(0, 16): faila=3D  0(D)  failb=3D 16(D)=
  OK
[    4.037409] raid6test: test_disks(0, 17): faila=3D  0(D)  failb=3D 17(D)=
  OK
[    4.038339] raid6test: test_disks(0, 18): faila=3D  0(D)  failb=3D 18(D)=
  OK
[    4.039282] raid6test: test_disks(0, 19): faila=3D  0(D)  failb=3D 19(D)=
  OK
[    4.040192] raid6test: test_disks(0, 20): faila=3D  0(D)  failb=3D 20(D)=
  OK
[    4.041128] raid6test: test_disks(0, 21): faila=3D  0(D)  failb=3D 21(D)=
  OK
[    4.042103] raid6test: test_disks(0, 22): faila=3D  0(D)  failb=3D 22(D)=
  OK
[    4.042996] raid6test: test_disks(0, 23): faila=3D  0(D)  failb=3D 23(D)=
  OK
[    4.043934] raid6test: test_disks(0, 24): faila=3D  0(D)  failb=3D 24(D)=
  OK
[    4.044871] raid6test: test_disks(0, 25): faila=3D  0(D)  failb=3D 25(D)=
  OK
[    4.045856] raid6test: test_disks(0, 26): faila=3D  0(D)  failb=3D 26(D)=
  OK
[    4.046795] raid6test: test_disks(0, 27): faila=3D  0(D)  failb=3D 27(D)=
  OK
[    4.047747] raid6test: test_disks(0, 28): faila=3D  0(D)  failb=3D 28(D)=
  OK
[    4.048703] raid6test: test_disks(0, 29): faila=3D  0(D)  failb=3D 29(D)=
  OK
[    4.049669] raid6test: test_disks(0, 30): faila=3D  0(D)  failb=3D 30(D)=
  OK
[    4.050596] raid6test: test_disks(0, 31): faila=3D  0(D)  failb=3D 31(D)=
  OK
[    4.051528] raid6test: test_disks(0, 32): faila=3D  0(D)  failb=3D 32(D)=
  OK
[    4.052467] raid6test: test_disks(0, 33): faila=3D  0(D)  failb=3D 33(D)=
  OK
[    4.053419] raid6test: test_disks(0, 34): faila=3D  0(D)  failb=3D 34(D)=
  OK
[    4.054340] raid6test: test_disks(0, 35): faila=3D  0(D)  failb=3D 35(D)=
  OK
[    4.055282] raid6test: test_disks(0, 36): faila=3D  0(D)  failb=3D 36(D)=
  OK
[    4.056193] raid6test: test_disks(0, 37): faila=3D  0(D)  failb=3D 37(D)=
  OK
[    4.057124] raid6test: test_disks(0, 38): faila=3D  0(D)  failb=3D 38(D)=
  OK
[    4.058088] raid6test: test_disks(0, 39): faila=3D  0(D)  failb=3D 39(D)=
  OK
[    4.059000] raid6test: test_disks(0, 40): faila=3D  0(D)  failb=3D 40(D)=
  OK
[    4.059945] raid6test: test_disks(0, 41): faila=3D  0(D)  failb=3D 41(D)=
  OK
[    4.061216] raid6test: test_disks(0, 42): faila=3D  0(D)  failb=3D 42(D)=
  OK
[    4.062167] raid6test: test_disks(0, 43): faila=3D  0(D)  failb=3D 43(D)=
  OK
[    4.063148] raid6test: test_disks(0, 44): faila=3D  0(D)  failb=3D 44(D)=
  OK
[    4.064407] raid6test: test_disks(0, 45): faila=3D  0(D)  failb=3D 45(D)=
  OK
[    4.065453] raid6test: test_disks(0, 46): faila=3D  0(D)  failb=3D 46(D)=
  OK
[    4.066744] raid6test: test_disks(0, 47): faila=3D  0(D)  failb=3D 47(D)=
  OK
[    4.067706] raid6test: test_disks(0, 48): faila=3D  0(D)  failb=3D 48(D)=
  OK
[    4.068669] raid6test: test_disks(0, 49): faila=3D  0(D)  failb=3D 49(D)=
  OK
[    4.069698] raid6test: test_disks(0, 50): faila=3D  0(D)  failb=3D 50(D)=
  OK
[    4.070644] raid6test: test_disks(0, 51): faila=3D  0(D)  failb=3D 51(D)=
  OK
[    4.071585] raid6test: test_disks(0, 52): faila=3D  0(D)  failb=3D 52(D)=
  OK
[    4.072537] raid6test: test_disks(0, 53): faila=3D  0(D)  failb=3D 53(D)=
  OK
[    4.073516] raid6test: test_disks(0, 54): faila=3D  0(D)  failb=3D 54(D)=
  OK
[    4.074444] raid6test: test_disks(0, 55): faila=3D  0(D)  failb=3D 55(D)=
  OK
[    4.075398] raid6test: test_disks(0, 56): faila=3D  0(D)  failb=3D 56(D)=
  OK
[    4.076334] raid6test: test_disks(0, 57): faila=3D  0(D)  failb=3D 57(D)=
  OK
[    4.077290] raid6test: test_disks(0, 58): faila=3D  0(D)  failb=3D 58(D)=
  OK
[    4.078257] raid6test: test_disks(0, 59): faila=3D  0(D)  failb=3D 59(D)=
  OK
[    4.079190] raid6test: test_disks(0, 60): faila=3D  0(D)  failb=3D 60(D)=
  OK
[    4.080137] raid6test: test_disks(0, 61): faila=3D  0(D)  failb=3D 61(D)=
  OK
[    4.081088] raid6test: test_disks(0, 62): faila=3D  0(D)  failb=3D 62(P)=
  OK
[    4.082094] raid6test: test_disks(0, 63): faila=3D  0(D)  failb=3D 63(Q)=
  OK
[    4.082996] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[    4.083932] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[    4.084864] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[    4.085846] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[    4.086775] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[    4.087742] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[    4.088678] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[    4.089628] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(D) =
 OK
[    4.090760] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(D)=
  OK
[    4.091670] raid6test: test_disks(1, 11): faila=3D  1(D)  failb=3D 11(D)=
  OK
[    4.092604] raid6test: test_disks(1, 12): faila=3D  1(D)  failb=3D 12(D)=
  OK
[    4.093577] raid6test: test_disks(1, 13): faila=3D  1(D)  failb=3D 13(D)=
  OK
[    4.094496] raid6test: test_disks(1, 14): faila=3D  1(D)  failb=3D 14(D)=
  OK
[    4.095441] raid6test: test_disks(1, 15): faila=3D  1(D)  failb=3D 15(D)=
  OK
[    4.096359] raid6test: test_disks(1, 16): faila=3D  1(D)  failb=3D 16(D)=
  OK
[    4.097302] raid6test: test_disks(1, 17): faila=3D  1(D)  failb=3D 17(D)=
  OK
[    4.098288] raid6test: test_disks(1, 18): faila=3D  1(D)  failb=3D 18(D)=
  OK
[    4.099205] raid6test: test_disks(1, 19): faila=3D  1(D)  failb=3D 19(D)=
  OK
[    4.100124] raid6test: test_disks(1, 20): faila=3D  1(D)  failb=3D 20(D)=
  OK
[    4.101041] raid6test: test_disks(1, 21): faila=3D  1(D)  failb=3D 21(D)=
  OK
[    4.101993] raid6test: test_disks(1, 22): faila=3D  1(D)  failb=3D 22(D)=
  OK
[    4.102922] raid6test: test_disks(1, 23): faila=3D  1(D)  failb=3D 23(D)=
  OK
[    4.103855] raid6test: test_disks(1, 24): faila=3D  1(D)  failb=3D 24(D)=
  OK
[    4.104784] raid6test: test_disks(1, 25): faila=3D  1(D)  failb=3D 25(D)=
  OK
[    4.105770] raid6test: test_disks(1, 26): faila=3D  1(D)  failb=3D 26(D)=
  OK
[    4.106693] raid6test: test_disks(1, 27): faila=3D  1(D)  failb=3D 27(D)=
  OK
[    4.107651] raid6test: test_disks(1, 28): faila=3D  1(D)  failb=3D 28(D)=
  OK
[    4.108596] raid6test: test_disks(1, 29): faila=3D  1(D)  failb=3D 29(D)=
  OK
[    4.109562] raid6test: test_disks(1, 30): faila=3D  1(D)  failb=3D 30(D)=
  OK
[    4.110482] raid6test: test_disks(1, 31): faila=3D  1(D)  failb=3D 31(D)=
  OK
[    4.111403] raid6test: test_disks(1, 32): faila=3D  1(D)  failb=3D 32(D)=
  OK
[    4.112320] raid6test: test_disks(1, 33): faila=3D  1(D)  failb=3D 33(D)=
  OK
[    4.113279] raid6test: test_disks(1, 34): faila=3D  1(D)  failb=3D 34(D)=
  OK
[    4.114175] tsc: Refined TSC clocksource calibration: 2892.967 MHz
[    4.115104] raid6test: test_disks(1, 35): faila=3D  1(D)  failb=3D 35(D)=
  OK
[    4.115986] raid6test: test_disks(1, 36): faila=3D  1(D)  failb=3D 36(D)=
  OK
[    4.116909] raid6test: test_disks(1, 37): faila=3D  1(D)  failb=3D 37(D)=
  OK
[    4.117882] raid6test: test_disks(1, 38): faila=3D  1(D)  failb=3D 38(D)=
  OK
[    4.118833] raid6test: test_disks(1, 39): faila=3D  1(D)  failb=3D 39(D)=
  OK
[    4.119761] raid6test: test_disks(1, 40): faila=3D  1(D)  failb=3D 40(D)=
  OK
[    4.120701] raid6test: test_disks(1, 41): faila=3D  1(D)  failb=3D 41(D)=
  OK
[    4.121657] raid6test: test_disks(1, 42): faila=3D  1(D)  failb=3D 42(D)=
  OK
[    4.122584] raid6test: test_disks(1, 43): faila=3D  1(D)  failb=3D 43(D)=
  OK
[    4.123502] raid6test: test_disks(1, 44): faila=3D  1(D)  failb=3D 44(D)=
  OK
[    4.124432] raid6test: test_disks(1, 45): faila=3D  1(D)  failb=3D 45(D)=
  OK
[    4.125385] raid6test: test_disks(1, 46): faila=3D  1(D)  failb=3D 46(D)=
  OK
[    4.126289] raid6test: test_disks(1, 47): faila=3D  1(D)  failb=3D 47(D)=
  OK
[    4.127190] raid6test: test_disks(1, 48): faila=3D  1(D)  failb=3D 48(D)=
  OK
[    4.128114] raid6test: test_disks(1, 49): faila=3D  1(D)  failb=3D 49(D)=
  OK
[    4.128979] raid6test: test_disks(1, 50): faila=3D  1(D)  failb=3D 50(D)=
  OK
[    4.129925] raid6test: test_disks(1, 51): faila=3D  1(D)  failb=3D 51(D)=
  OK
[    4.130832] raid6test: test_disks(1, 52): faila=3D  1(D)  failb=3D 52(D)=
  OK
[    4.131734] raid6test: test_disks(1, 53): faila=3D  1(D)  failb=3D 53(D)=
  OK
[    4.132635] raid6test: test_disks(1, 54): faila=3D  1(D)  failb=3D 54(D)=
  OK
[    4.133574] raid6test: test_disks(1, 55): faila=3D  1(D)  failb=3D 55(D)=
  OK
[    4.134469] raid6test: test_disks(1, 56): faila=3D  1(D)  failb=3D 56(D)=
  OK
[    4.135374] raid6test: test_disks(1, 57): faila=3D  1(D)  failb=3D 57(D)=
  OK
[    4.136273] raid6test: test_disks(1, 58): faila=3D  1(D)  failb=3D 58(D)=
  OK
[    4.137203] raid6test: test_disks(1, 59): faila=3D  1(D)  failb=3D 59(D)=
  OK
[    4.138133] raid6test: test_disks(1, 60): faila=3D  1(D)  failb=3D 60(D)=
  OK
[    4.139056] raid6test: test_disks(1, 61): faila=3D  1(D)  failb=3D 61(D)=
  OK
[    4.139934] raid6test: test_disks(1, 62): faila=3D  1(D)  failb=3D 62(P)=
  OK
[    4.140851] raid6test: test_disks(1, 63): faila=3D  1(D)  failb=3D 63(Q)=
  OK
[    4.141814] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[    4.142760] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[    4.143673] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[    4.144609] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[    4.145561] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[    4.146471] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[    4.147384] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(D) =
 OK
[    4.148326] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(D)=
  OK
[    4.149273] raid6test: test_disks(2, 11): faila=3D  2(D)  failb=3D 11(D)=
  OK
[    4.150187] raid6test: test_disks(2, 12): faila=3D  2(D)  failb=3D 12(D)=
  OK
[    4.151095] raid6test: test_disks(2, 13): faila=3D  2(D)  failb=3D 13(D)=
  OK
[    4.151969] raid6test: test_disks(2, 14): faila=3D  2(D)  failb=3D 14(D)=
  OK
[    4.152876] raid6test: test_disks(2, 15): faila=3D  2(D)  failb=3D 15(D)=
  OK
[    4.153839] raid6test: test_disks(2, 16): faila=3D  2(D)  failb=3D 16(D)=
  OK
[    4.154769] raid6test: test_disks(2, 17): faila=3D  2(D)  failb=3D 17(D)=
  OK
[    4.155696] raid6test: test_disks(2, 18): faila=3D  2(D)  failb=3D 18(D)=
  OK
[    4.156629] raid6test: test_disks(2, 19): faila=3D  2(D)  failb=3D 19(D)=
  OK
[    4.157616] raid6test: test_disks(2, 20): faila=3D  2(D)  failb=3D 20(D)=
  OK
[    4.158550] raid6test: test_disks(2, 21): faila=3D  2(D)  failb=3D 21(D)=
  OK
[    4.159474] raid6test: test_disks(2, 22): faila=3D  2(D)  failb=3D 22(D)=
  OK
[    4.160401] raid6test: test_disks(2, 23): faila=3D  2(D)  failb=3D 23(D)=
  OK
[    4.161340] raid6test: test_disks(2, 24): faila=3D  2(D)  failb=3D 24(D)=
  OK
[    4.162266] raid6test: test_disks(2, 25): faila=3D  2(D)  failb=3D 25(D)=
  OK
[    4.163173] raid6test: test_disks(2, 26): faila=3D  2(D)  failb=3D 26(D)=
  OK
[    4.164090] raid6test: test_disks(2, 27): faila=3D  2(D)  failb=3D 27(D)=
  OK
[    4.164965] raid6test: test_disks(2, 28): faila=3D  2(D)  failb=3D 28(D)=
  OK
[    4.165925] raid6test: test_disks(2, 29): faila=3D  2(D)  failb=3D 29(D)=
  OK
[    4.166849] raid6test: test_disks(2, 30): faila=3D  2(D)  failb=3D 30(D)=
  OK
[    4.167781] raid6test: test_disks(2, 31): faila=3D  2(D)  failb=3D 31(D)=
  OK
[    4.168710] raid6test: test_disks(2, 32): faila=3D  2(D)  failb=3D 32(D)=
  OK
[    4.169702] raid6test: test_disks(2, 33): faila=3D  2(D)  failb=3D 33(D)=
  OK
[    4.170607] raid6test: test_disks(2, 34): faila=3D  2(D)  failb=3D 34(D)=
  OK
[    4.171501] raid6test: test_disks(2, 35): faila=3D  2(D)  failb=3D 35(D)=
  OK
[    4.172404] raid6test: test_disks(2, 36): faila=3D  2(D)  failb=3D 36(D)=
  OK
[    4.173329] raid6test: test_disks(2, 37): faila=3D  2(D)  failb=3D 37(D)=
  OK
[    4.174235] raid6test: test_disks(2, 38): faila=3D  2(D)  failb=3D 38(D)=
  OK
[    4.175136] raid6test: test_disks(2, 39): faila=3D  2(D)  failb=3D 39(D)=
  OK
[    4.176007] raid6test: test_disks(2, 40): faila=3D  2(D)  failb=3D 40(D)=
  OK
[    4.176906] raid6test: test_disks(2, 41): faila=3D  2(D)  failb=3D 41(D)=
  OK
[    4.177861] raid6test: test_disks(2, 42): faila=3D  2(D)  failb=3D 42(D)=
  OK
[    4.178761] raid6test: test_disks(2, 43): faila=3D  2(D)  failb=3D 43(D)=
  OK
[    4.179662] raid6test: test_disks(2, 44): faila=3D  2(D)  failb=3D 44(D)=
  OK
[    4.180566] raid6test: test_disks(2, 45): faila=3D  2(D)  failb=3D 45(D)=
  OK
[    4.181499] raid6test: test_disks(2, 46): faila=3D  2(D)  failb=3D 46(D)=
  OK
[    4.182398] raid6test: test_disks(2, 47): faila=3D  2(D)  failb=3D 47(D)=
  OK
[    4.183293] raid6test: test_disks(2, 48): faila=3D  2(D)  failb=3D 48(D)=
  OK
[    4.184187] raid6test: test_disks(2, 49): faila=3D  2(D)  failb=3D 49(D)=
  OK
[    4.185086] raid6test: test_disks(2, 50): faila=3D  2(D)  failb=3D 50(D)=
  OK
[    4.185980] raid6test: test_disks(2, 51): faila=3D  2(D)  failb=3D 51(D)=
  OK
[    4.186881] raid6test: test_disks(2, 52): faila=3D  2(D)  failb=3D 52(D)=
  OK
[    4.187793] raid6test: test_disks(2, 53): faila=3D  2(D)  failb=3D 53(D)=
  OK
[    4.188691] raid6test: test_disks(2, 54): faila=3D  2(D)  failb=3D 54(D)=
  OK
[    4.189631] raid6test: test_disks(2, 55): faila=3D  2(D)  failb=3D 55(D)=
  OK
[    4.190528] raid6test: test_disks(2, 56): faila=3D  2(D)  failb=3D 56(D)=
  OK
[    4.191423] raid6test: test_disks(2, 57): faila=3D  2(D)  failb=3D 57(D)=
  OK
[    4.192324] raid6test: test_disks(2, 58): faila=3D  2(D)  failb=3D 58(D)=
  OK
[    4.193257] raid6test: test_disks(2, 59): faila=3D  2(D)  failb=3D 59(D)=
  OK
[    4.194164] raid6test: test_disks(2, 60): faila=3D  2(D)  failb=3D 60(D)=
  OK
[    4.195085] raid6test: test_disks(2, 61): faila=3D  2(D)  failb=3D 61(D)=
  OK
[    4.195960] raid6test: test_disks(2, 62): faila=3D  2(D)  failb=3D 62(P)=
  OK
[    4.196875] raid6test: test_disks(2, 63): faila=3D  2(D)  failb=3D 63(Q)=
  OK
[    4.197849] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[    4.198809] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[    4.199754] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[    4.200668] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[    4.201604] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[    4.202486] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(D) =
 OK
[    4.203381] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(D)=
  OK
[    4.204278] raid6test: test_disks(3, 11): faila=3D  3(D)  failb=3D 11(D)=
  OK
[    4.205212] raid6test: test_disks(3, 12): faila=3D  3(D)  failb=3D 12(D)=
  OK
[    4.206110] raid6test: test_disks(3, 13): faila=3D  3(D)  failb=3D 13(D)=
  OK
[    4.206979] raid6test: test_disks(3, 14): faila=3D  3(D)  failb=3D 14(D)=
  OK
[    4.207903] raid6test: test_disks(3, 15): faila=3D  3(D)  failb=3D 15(D)=
  OK
[    4.208806] raid6test: test_disks(3, 16): faila=3D  3(D)  failb=3D 16(D)=
  OK
[    4.209762] raid6test: test_disks(3, 17): faila=3D  3(D)  failb=3D 17(D)=
  OK
[    4.210678] raid6test: test_disks(3, 18): faila=3D  3(D)  failb=3D 18(D)=
  OK
[    4.211606] raid6test: test_disks(3, 19): faila=3D  3(D)  failb=3D 19(D)=
  OK
[    4.212525] raid6test: test_disks(3, 20): faila=3D  3(D)  failb=3D 20(D)=
  OK
[    4.213482] raid6test: test_disks(3, 21): faila=3D  3(D)  failb=3D 21(D)=
  OK
[    4.214421] raid6test: test_disks(3, 22): faila=3D  3(D)  failb=3D 22(D)=
  OK
[    4.215333] raid6test: test_disks(3, 23): faila=3D  3(D)  failb=3D 23(D)=
  OK
[    4.216256] raid6test: test_disks(3, 24): faila=3D  3(D)  failb=3D 24(D)=
  OK
[    4.217199] raid6test: test_disks(3, 25): faila=3D  3(D)  failb=3D 25(D)=
  OK
[    4.218130] raid6test: test_disks(3, 26): faila=3D  3(D)  failb=3D 26(D)=
  OK
[    4.219042] raid6test: test_disks(3, 27): faila=3D  3(D)  failb=3D 27(D)=
  OK
[    4.219924] raid6test: test_disks(3, 28): faila=3D  3(D)  failb=3D 28(D)=
  OK
[    4.220845] raid6test: test_disks(3, 29): faila=3D  3(D)  failb=3D 29(D)=
  OK
[    4.221799] raid6test: test_disks(3, 30): faila=3D  3(D)  failb=3D 30(D)=
  OK
[    4.222732] raid6test: test_disks(3, 31): faila=3D  3(D)  failb=3D 31(D)=
  OK
[    4.223656] raid6test: test_disks(3, 32): faila=3D  3(D)  failb=3D 32(D)=
  OK
[    4.224581] raid6test: test_disks(3, 33): faila=3D  3(D)  failb=3D 33(D)=
  OK
[    4.225531] raid6test: test_disks(3, 34): faila=3D  3(D)  failb=3D 34(D)=
  OK
[    4.226477] raid6test: test_disks(3, 35): faila=3D  3(D)  failb=3D 35(D)=
  OK
[    4.227405] raid6test: test_disks(3, 36): faila=3D  3(D)  failb=3D 36(D)=
  OK
[    4.228354] raid6test: test_disks(3, 37): faila=3D  3(D)  failb=3D 37(D)=
  OK
[    4.229301] raid6test: test_disks(3, 38): faila=3D  3(D)  failb=3D 38(D)=
  OK
[    4.230213] raid6test: test_disks(3, 39): faila=3D  3(D)  failb=3D 39(D)=
  OK
[    4.231126] raid6test: test_disks(3, 40): faila=3D  3(D)  failb=3D 40(D)=
  OK
[    4.232043] raid6test: test_disks(3, 41): faila=3D  3(D)  failb=3D 41(D)=
  OK
[    4.232926] raid6test: test_disks(3, 42): faila=3D  3(D)  failb=3D 42(D)=
  OK
[    4.233879] raid6test: test_disks(3, 43): faila=3D  3(D)  failb=3D 43(D)=
  OK
[    4.234807] raid6test: test_disks(3, 44): faila=3D  3(D)  failb=3D 44(D)=
  OK
[    4.235729] raid6test: test_disks(3, 45): faila=3D  3(D)  failb=3D 45(D)=
  OK
[    4.236654] raid6test: test_disks(3, 46): faila=3D  3(D)  failb=3D 46(D)=
  OK
[    4.237632] raid6test: test_disks(3, 47): faila=3D  3(D)  failb=3D 47(D)=
  OK
[    4.238576] raid6test: test_disks(3, 48): faila=3D  3(D)  failb=3D 48(D)=
  OK
[    4.239493] raid6test: test_disks(3, 49): faila=3D  3(D)  failb=3D 49(D)=
  OK
[    4.240427] raid6test: test_disks(3, 50): faila=3D  3(D)  failb=3D 50(D)=
  OK
[    4.241366] raid6test: test_disks(3, 51): faila=3D  3(D)  failb=3D 51(D)=
  OK
[    4.242267] raid6test: test_disks(3, 52): faila=3D  3(D)  failb=3D 52(D)=
  OK
[    4.243175] raid6test: test_disks(3, 53): faila=3D  3(D)  failb=3D 53(D)=
  OK
[    4.244073] raid6test: test_disks(3, 54): faila=3D  3(D)  failb=3D 54(D)=
  OK
[    4.244936] raid6test: test_disks(3, 55): faila=3D  3(D)  failb=3D 55(D)=
  OK
[    4.245870] raid6test: test_disks(3, 56): faila=3D  3(D)  failb=3D 56(D)=
  OK
[    4.246774] raid6test: test_disks(3, 57): faila=3D  3(D)  failb=3D 57(D)=
  OK
[    4.247700] raid6test: test_disks(3, 58): faila=3D  3(D)  failb=3D 58(D)=
  OK
[    4.248608] raid6test: test_disks(3, 59): faila=3D  3(D)  failb=3D 59(D)=
  OK
[    4.249549] raid6test: test_disks(3, 60): faila=3D  3(D)  failb=3D 60(D)=
  OK
[    4.250449] raid6test: test_disks(3, 61): faila=3D  3(D)  failb=3D 61(D)=
  OK
[    4.251344] raid6test: test_disks(3, 62): faila=3D  3(D)  failb=3D 62(P)=
  OK
[    4.252241] raid6test: test_disks(3, 63): faila=3D  3(D)  failb=3D 63(Q)=
  OK
[    4.253147] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[    4.254083] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[    4.254944] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[    4.255838] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[    4.256731] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(D) =
 OK
[    4.257675] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(D)=
  OK
[    4.258584] raid6test: test_disks(4, 11): faila=3D  4(D)  failb=3D 11(D)=
  OK
[    4.259481] raid6test: test_disks(4, 12): faila=3D  4(D)  failb=3D 12(D)=
  OK
[    4.260384] raid6test: test_disks(4, 13): faila=3D  4(D)  failb=3D 13(D)=
  OK
[    4.261323] raid6test: test_disks(4, 14): faila=3D  4(D)  failb=3D 14(D)=
  OK
[    4.262241] raid6test: test_disks(4, 15): faila=3D  4(D)  failb=3D 15(D)=
  OK
[    4.263160] raid6test: test_disks(4, 16): faila=3D  4(D)  failb=3D 16(D)=
  OK
[    4.264088] raid6test: test_disks(4, 17): faila=3D  4(D)  failb=3D 17(D)=
  OK
[    4.264966] raid6test: test_disks(4, 18): faila=3D  4(D)  failb=3D 18(D)=
  OK
[    4.265927] raid6test: test_disks(4, 19): faila=3D  4(D)  failb=3D 19(D)=
  OK
[    4.266848] raid6test: test_disks(4, 20): faila=3D  4(D)  failb=3D 20(D)=
  OK
[    4.267784] raid6test: test_disks(4, 21): faila=3D  4(D)  failb=3D 21(D)=
  OK
[    4.268710] raid6test: test_disks(4, 22): faila=3D  4(D)  failb=3D 22(D)=
  OK
[    4.269715] raid6test: test_disks(4, 23): faila=3D  4(D)  failb=3D 23(D)=
  OK
[    4.270640] raid6test: test_disks(4, 24): faila=3D  4(D)  failb=3D 24(D)=
  OK
[    4.271568] raid6test: test_disks(4, 25): faila=3D  4(D)  failb=3D 25(D)=
  OK
[    4.272491] raid6test: test_disks(4, 26): faila=3D  4(D)  failb=3D 26(D)=
  OK
[    4.273461] raid6test: test_disks(4, 27): faila=3D  4(D)  failb=3D 27(D)=
  OK
[    4.274415] raid6test: test_disks(4, 28): faila=3D  4(D)  failb=3D 28(D)=
  OK
[    4.275351] raid6test: test_disks(4, 29): faila=3D  4(D)  failb=3D 29(D)=
  OK
[    4.276298] raid6test: test_disks(4, 30): faila=3D  4(D)  failb=3D 30(D)=
  OK
[    4.277259] raid6test: test_disks(4, 31): faila=3D  4(D)  failb=3D 31(D)=
  OK
[    4.278217] raid6test: test_disks(4, 32): faila=3D  4(D)  failb=3D 32(D)=
  OK
[    4.279130] raid6test: test_disks(4, 33): faila=3D  4(D)  failb=3D 33(D)=
  OK
[    4.280049] raid6test: test_disks(4, 34): faila=3D  4(D)  failb=3D 34(D)=
  OK
[    4.280943] raid6test: test_disks(4, 35): faila=3D  4(D)  failb=3D 35(D)=
  OK
[    4.281909] raid6test: test_disks(4, 36): faila=3D  4(D)  failb=3D 36(D)=
  OK
[    4.282851] raid6test: test_disks(4, 37): faila=3D  4(D)  failb=3D 37(D)=
  OK
[    4.283787] raid6test: test_disks(4, 38): faila=3D  4(D)  failb=3D 38(D)=
  OK
[    4.284726] raid6test: test_disks(4, 39): faila=3D  4(D)  failb=3D 39(D)=
  OK
[    4.285679] raid6test: test_disks(4, 40): faila=3D  4(D)  failb=3D 40(D)=
  OK
[    4.286605] raid6test: test_disks(4, 41): faila=3D  4(D)  failb=3D 41(D)=
  OK
[    4.287526] raid6test: test_disks(4, 42): faila=3D  4(D)  failb=3D 42(D)=
  OK
[    4.288476] raid6test: test_disks(4, 43): faila=3D  4(D)  failb=3D 43(D)=
  OK
[    4.289455] raid6test: test_disks(4, 44): faila=3D  4(D)  failb=3D 44(D)=
  OK
[    4.290409] raid6test: test_disks(4, 45): faila=3D  4(D)  failb=3D 45(D)=
  OK
[    4.291347] raid6test: test_disks(4, 46): faila=3D  4(D)  failb=3D 46(D)=
  OK
[    4.292282] raid6test: test_disks(4, 47): faila=3D  4(D)  failb=3D 47(D)=
  OK
[    4.293249] raid6test: test_disks(4, 48): faila=3D  4(D)  failb=3D 48(D)=
  OK
[    4.294173] raid6test: test_disks(4, 49): faila=3D  4(D)  failb=3D 49(D)=
  OK
[    4.295089] raid6test: test_disks(4, 50): faila=3D  4(D)  failb=3D 50(D)=
  OK
[    4.295991] raid6test: test_disks(4, 51): faila=3D  4(D)  failb=3D 51(D)=
  OK
[    4.296932] raid6test: test_disks(4, 52): faila=3D  4(D)  failb=3D 52(D)=
  OK
[    4.297923] raid6test: test_disks(4, 53): faila=3D  4(D)  failb=3D 53(D)=
  OK
[    4.298863] raid6test: test_disks(4, 54): faila=3D  4(D)  failb=3D 54(D)=
  OK
[    4.299804] raid6test: test_disks(4, 55): faila=3D  4(D)  failb=3D 55(D)=
  OK
[    4.300748] raid6test: test_disks(4, 56): faila=3D  4(D)  failb=3D 56(D)=
  OK
[    4.301720] raid6test: test_disks(4, 57): faila=3D  4(D)  failb=3D 57(D)=
  OK
[    4.302664] raid6test: test_disks(4, 58): faila=3D  4(D)  failb=3D 58(D)=
  OK
[    4.303609] raid6test: test_disks(4, 59): faila=3D  4(D)  failb=3D 59(D)=
  OK
[    4.304555] raid6test: test_disks(4, 60): faila=3D  4(D)  failb=3D 60(D)=
  OK
[    4.305521] raid6test: test_disks(4, 61): faila=3D  4(D)  failb=3D 61(D)=
  OK
[    4.306461] raid6test: test_disks(4, 62): faila=3D  4(D)  failb=3D 62(P)=
  OK
[    4.307398] raid6test: test_disks(4, 63): faila=3D  4(D)  failb=3D 63(Q)=
  OK
[    4.308339] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[    4.309285] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[    4.310202] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[    4.311113] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(D) =
 OK
[    4.311986] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(D)=
  OK
[    4.312930] raid6test: test_disks(5, 11): faila=3D  5(D)  failb=3D 11(D)=
  OK
[    4.313896] raid6test: test_disks(5, 12): faila=3D  5(D)  failb=3D 12(D)=
  OK
[    4.314836] raid6test: test_disks(5, 13): faila=3D  5(D)  failb=3D 13(D)=
  OK
[    4.315775] raid6test: test_disks(5, 14): faila=3D  5(D)  failb=3D 14(D)=
  OK
[    4.316713] raid6test: test_disks(5, 15): faila=3D  5(D)  failb=3D 15(D)=
  OK
[    4.317695] raid6test: test_disks(5, 16): faila=3D  5(D)  failb=3D 16(D)=
  OK
[    4.318643] raid6test: test_disks(5, 17): faila=3D  5(D)  failb=3D 17(D)=
  OK
[    4.319591] raid6test: test_disks(5, 18): faila=3D  5(D)  failb=3D 18(D)=
  OK
[    4.320530] raid6test: test_disks(5, 19): faila=3D  5(D)  failb=3D 19(D)=
  OK
[    4.321503] raid6test: test_disks(5, 20): faila=3D  5(D)  failb=3D 20(D)=
  OK
[    4.322448] raid6test: test_disks(5, 21): faila=3D  5(D)  failb=3D 21(D)=
  OK
[    4.323390] raid6test: test_disks(5, 22): faila=3D  5(D)  failb=3D 22(D)=
  OK
[    4.324327] raid6test: test_disks(5, 23): faila=3D  5(D)  failb=3D 23(D)=
  OK
[    4.325284] raid6test: test_disks(5, 24): faila=3D  5(D)  failb=3D 24(D)=
  OK
[    4.326212] raid6test: test_disks(5, 25): faila=3D  5(D)  failb=3D 25(D)=
  OK
[    4.327134] raid6test: test_disks(5, 26): faila=3D  5(D)  failb=3D 26(D)=
  OK
[    4.328066] raid6test: test_disks(5, 27): faila=3D  5(D)  failb=3D 27(D)=
  OK
[    4.328957] raid6test: test_disks(5, 28): faila=3D  5(D)  failb=3D 28(D)=
  OK
[    4.329929] raid6test: test_disks(5, 29): faila=3D  5(D)  failb=3D 29(D)=
  OK
[    4.330870] raid6test: test_disks(5, 30): faila=3D  5(D)  failb=3D 30(D)=
  OK
[    4.331812] raid6test: test_disks(5, 31): faila=3D  5(D)  failb=3D 31(D)=
  OK
[    4.332756] raid6test: test_disks(5, 32): faila=3D  5(D)  failb=3D 32(D)=
  OK
[    4.333728] raid6test: test_disks(5, 33): faila=3D  5(D)  failb=3D 33(D)=
  OK
[    4.334668] raid6test: test_disks(5, 34): faila=3D  5(D)  failb=3D 34(D)=
  OK
[    4.335614] raid6test: test_disks(5, 35): faila=3D  5(D)  failb=3D 35(D)=
  OK
[    4.336555] raid6test: test_disks(5, 36): faila=3D  5(D)  failb=3D 36(D)=
  OK
[    4.337587] raid6test: test_disks(5, 37): faila=3D  5(D)  failb=3D 37(D)=
  OK
[    4.338526] raid6test: test_disks(5, 38): faila=3D  5(D)  failb=3D 38(D)=
  OK
[    4.339469] raid6test: test_disks(5, 39): faila=3D  5(D)  failb=3D 39(D)=
  OK
[    4.340413] raid6test: test_disks(5, 40): faila=3D  5(D)  failb=3D 40(D)=
  OK
[    4.341376] raid6test: test_disks(5, 41): faila=3D  5(D)  failb=3D 41(D)=
  OK
[    4.342301] raid6test: test_disks(5, 42): faila=3D  5(D)  failb=3D 42(D)=
  OK
[    4.343230] raid6test: test_disks(5, 43): faila=3D  5(D)  failb=3D 43(D)=
  OK
[    4.344160] raid6test: test_disks(5, 44): faila=3D  5(D)  failb=3D 44(D)=
  OK
[    4.345071] raid6test: test_disks(5, 45): faila=3D  5(D)  failb=3D 45(D)=
  OK
[    4.345990] raid6test: test_disks(5, 46): faila=3D  5(D)  failb=3D 46(D)=
  OK
[    4.346930] raid6test: test_disks(5, 47): faila=3D  5(D)  failb=3D 47(D)=
  OK
[    4.347875] raid6test: test_disks(5, 48): faila=3D  5(D)  failb=3D 48(D)=
  OK
[    4.348804] raid6test: test_disks(5, 49): faila=3D  5(D)  failb=3D 49(D)=
  OK
[    4.349762] raid6test: test_disks(5, 50): faila=3D  5(D)  failb=3D 50(D)=
  OK
[    4.350690] raid6test: test_disks(5, 51): faila=3D  5(D)  failb=3D 51(D)=
  OK
[    4.351620] raid6test: test_disks(5, 52): faila=3D  5(D)  failb=3D 52(D)=
  OK
[    4.352547] raid6test: test_disks(5, 53): faila=3D  5(D)  failb=3D 53(D)=
  OK
[    4.353581] raid6test: test_disks(5, 54): faila=3D  5(D)  failb=3D 54(D)=
  OK
[    4.354499] raid6test: test_disks(5, 55): faila=3D  5(D)  failb=3D 55(D)=
  OK
[    4.355427] raid6test: test_disks(5, 56): faila=3D  5(D)  failb=3D 56(D)=
  OK
[    4.356352] raid6test: test_disks(5, 57): faila=3D  5(D)  failb=3D 57(D)=
  OK
[    4.357305] raid6test: test_disks(5, 58): faila=3D  5(D)  failb=3D 58(D)=
  OK
[    4.358244] raid6test: test_disks(5, 59): faila=3D  5(D)  failb=3D 59(D)=
  OK
[    4.359168] raid6test: test_disks(5, 60): faila=3D  5(D)  failb=3D 60(D)=
  OK
[    4.360074] raid6test: test_disks(5, 61): faila=3D  5(D)  failb=3D 61(D)=
  OK
[    4.360950] raid6test: test_disks(5, 62): faila=3D  5(D)  failb=3D 62(P)=
  OK
[    4.361903] raid6test: test_disks(5, 63): faila=3D  5(D)  failb=3D 63(Q)=
  OK
[    4.362824] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[    4.363763] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[    4.364664] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(D) =
 OK
[    4.365613] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(D)=
  OK
[    4.366531] raid6test: test_disks(6, 11): faila=3D  6(D)  failb=3D 11(D)=
  OK
[    4.367452] raid6test: test_disks(6, 12): faila=3D  6(D)  failb=3D 12(D)=
  OK
[    4.368388] raid6test: test_disks(6, 13): faila=3D  6(D)  failb=3D 13(D)=
  OK
[    4.369382] raid6test: test_disks(6, 14): faila=3D  6(D)  failb=3D 14(D)=
  OK
[    4.370310] raid6test: test_disks(6, 15): faila=3D  6(D)  failb=3D 15(D)=
  OK
[    4.371226] raid6test: test_disks(6, 16): faila=3D  6(D)  failb=3D 16(D)=
  OK
[    4.372155] raid6test: test_disks(6, 17): faila=3D  6(D)  failb=3D 17(D)=
  OK
[    4.373058] raid6test: test_disks(6, 18): faila=3D  6(D)  failb=3D 18(D)=
  OK
[    4.374058] raid6test: test_disks(6, 19): faila=3D  6(D)  failb=3D 19(D)=
  OK
[    4.374938] raid6test: test_disks(6, 20): faila=3D  6(D)  failb=3D 20(D)=
  OK
[    4.375859] raid6test: test_disks(6, 21): faila=3D  6(D)  failb=3D 21(D)=
  OK
[    4.376778] raid6test: test_disks(6, 22): faila=3D  6(D)  failb=3D 22(D)=
  OK
[    4.377747] raid6test: test_disks(6, 23): faila=3D  6(D)  failb=3D 23(D)=
  OK
[    4.378661] raid6test: test_disks(6, 24): faila=3D  6(D)  failb=3D 24(D)=
  OK
[    4.379583] raid6test: test_disks(6, 25): faila=3D  6(D)  failb=3D 25(D)=
  OK
[    4.380500] raid6test: test_disks(6, 26): faila=3D  6(D)  failb=3D 26(D)=
  OK
[    4.381455] raid6test: test_disks(6, 27): faila=3D  6(D)  failb=3D 27(D)=
  OK
[    4.382372] raid6test: test_disks(6, 28): faila=3D  6(D)  failb=3D 28(D)=
  OK
[    4.383350] raid6test: test_disks(6, 29): faila=3D  6(D)  failb=3D 29(D)=
  OK
[    4.384298] raid6test: test_disks(6, 30): faila=3D  6(D)  failb=3D 30(D)=
  OK
[    4.385243] raid6test: test_disks(6, 31): faila=3D  6(D)  failb=3D 31(D)=
  OK
[    4.386165] raid6test: test_disks(6, 32): faila=3D  6(D)  failb=3D 32(D)=
  OK
[    4.387072] raid6test: test_disks(6, 33): faila=3D  6(D)  failb=3D 33(D)=
  OK
[    4.387966] raid6test: test_disks(6, 34): faila=3D  6(D)  failb=3D 34(D)=
  OK
[    4.388887] raid6test: test_disks(6, 35): faila=3D  6(D)  failb=3D 35(D)=
  OK
[    4.389845] raid6test: test_disks(6, 36): faila=3D  6(D)  failb=3D 36(D)=
  OK
[    4.390767] raid6test: test_disks(6, 37): faila=3D  6(D)  failb=3D 37(D)=
  OK
[    4.391692] raid6test: test_disks(6, 38): faila=3D  6(D)  failb=3D 38(D)=
  OK
[    4.392612] raid6test: test_disks(6, 39): faila=3D  6(D)  failb=3D 39(D)=
  OK
[    4.393664] raid6test: test_disks(6, 40): faila=3D  6(D)  failb=3D 40(D)=
  OK
[    4.394586] raid6test: test_disks(6, 41): faila=3D  6(D)  failb=3D 41(D)=
  OK
[    4.395507] raid6test: test_disks(6, 42): faila=3D  6(D)  failb=3D 42(D)=
  OK
[    4.396428] raid6test: test_disks(6, 43): faila=3D  6(D)  failb=3D 43(D)=
  OK
[    4.397386] raid6test: test_disks(6, 44): faila=3D  6(D)  failb=3D 44(D)=
  OK
[    4.398338] raid6test: test_disks(6, 45): faila=3D  6(D)  failb=3D 45(D)=
  OK
[    4.399250] raid6test: test_disks(6, 46): faila=3D  6(D)  failb=3D 46(D)=
  OK
[    4.400167] raid6test: test_disks(6, 47): faila=3D  6(D)  failb=3D 47(D)=
  OK
[    4.401065] raid6test: test_disks(6, 48): faila=3D  6(D)  failb=3D 48(D)=
  OK
[    4.401973] raid6test: test_disks(6, 49): faila=3D  6(D)  failb=3D 49(D)=
  OK
[    4.402889] raid6test: test_disks(6, 50): faila=3D  6(D)  failb=3D 50(D)=
  OK
[    4.403837] raid6test: test_disks(6, 51): faila=3D  6(D)  failb=3D 51(D)=
  OK
[    4.404752] raid6test: test_disks(6, 52): faila=3D  6(D)  failb=3D 52(D)=
  OK
[    4.405705] raid6test: test_disks(6, 53): faila=3D  6(D)  failb=3D 53(D)=
  OK
[    4.406628] raid6test: test_disks(6, 54): faila=3D  6(D)  failb=3D 54(D)=
  OK
[    4.407564] raid6test: test_disks(6, 55): faila=3D  6(D)  failb=3D 55(D)=
  OK
[    4.408482] raid6test: test_disks(6, 56): faila=3D  6(D)  failb=3D 56(D)=
  OK
[    4.409438] raid6test: test_disks(6, 57): faila=3D  6(D)  failb=3D 57(D)=
  OK
[    4.410357] raid6test: test_disks(6, 58): faila=3D  6(D)  failb=3D 58(D)=
  OK
[    4.411283] raid6test: test_disks(6, 59): faila=3D  6(D)  failb=3D 59(D)=
  OK
[    4.412202] raid6test: test_disks(6, 60): faila=3D  6(D)  failb=3D 60(D)=
  OK
[    4.413113] raid6test: test_disks(6, 61): faila=3D  6(D)  failb=3D 61(D)=
  OK
[    4.414135] raid6test: test_disks(6, 62): faila=3D  6(D)  failb=3D 62(P)=
  OK
[    4.415000] raid6test: test_disks(6, 63): faila=3D  6(D)  failb=3D 63(Q)=
  OK
[    4.415922] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[    4.416833] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(D) =
 OK
[    4.417815] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(D)=
  OK
[    4.418739] raid6test: test_disks(7, 11): faila=3D  7(D)  failb=3D 11(D)=
  OK
[    4.419665] raid6test: test_disks(7, 12): faila=3D  7(D)  failb=3D 12(D)=
  OK
[    4.420591] raid6test: test_disks(7, 13): faila=3D  7(D)  failb=3D 13(D)=
  OK
[    4.421563] raid6test: test_disks(7, 14): faila=3D  7(D)  failb=3D 14(D)=
  OK
[    4.422481] raid6test: test_disks(7, 15): faila=3D  7(D)  failb=3D 15(D)=
  OK
[    4.423434] raid6test: test_disks(7, 16): faila=3D  7(D)  failb=3D 16(D)=
  OK
[    4.424364] raid6test: test_disks(7, 17): faila=3D  7(D)  failb=3D 17(D)=
  OK
[    4.425318] raid6test: test_disks(7, 18): faila=3D  7(D)  failb=3D 18(D)=
  OK
[    4.426237] raid6test: test_disks(7, 19): faila=3D  7(D)  failb=3D 19(D)=
  OK
[    4.427161] raid6test: test_disks(7, 20): faila=3D  7(D)  failb=3D 20(D)=
  OK
[    4.428084] raid6test: test_disks(7, 21): faila=3D  7(D)  failb=3D 21(D)=
  OK
[    4.428966] raid6test: test_disks(7, 22): faila=3D  7(D)  failb=3D 22(D)=
  OK
[    4.429926] raid6test: test_disks(7, 23): faila=3D  7(D)  failb=3D 23(D)=
  OK
[    4.430848] raid6test: test_disks(7, 24): faila=3D  7(D)  failb=3D 24(D)=
  OK
[    4.431771] raid6test: test_disks(7, 25): faila=3D  7(D)  failb=3D 25(D)=
  OK
[    4.432694] raid6test: test_disks(7, 26): faila=3D  7(D)  failb=3D 26(D)=
  OK
[    4.433745] raid6test: test_disks(7, 27): faila=3D  7(D)  failb=3D 27(D)=
  OK
[    4.434666] raid6test: test_disks(7, 28): faila=3D  7(D)  failb=3D 28(D)=
  OK
[    4.435594] raid6test: test_disks(7, 29): faila=3D  7(D)  failb=3D 29(D)=
  OK
[    4.436514] raid6test: test_disks(7, 30): faila=3D  7(D)  failb=3D 30(D)=
  OK
[    4.437477] raid6test: test_disks(7, 31): faila=3D  7(D)  failb=3D 31(D)=
  OK
[    4.438424] raid6test: test_disks(7, 32): faila=3D  7(D)  failb=3D 32(D)=
  OK
[    4.439349] raid6test: test_disks(7, 33): faila=3D  7(D)  failb=3D 33(D)=
  OK
[    4.440272] raid6test: test_disks(7, 34): faila=3D  7(D)  failb=3D 34(D)=
  OK
[    4.441219] raid6test: test_disks(7, 35): faila=3D  7(D)  failb=3D 35(D)=
  OK
[    4.442136] raid6test: test_disks(7, 36): faila=3D  7(D)  failb=3D 36(D)=
  OK
[    4.443047] raid6test: test_disks(7, 37): faila=3D  7(D)  failb=3D 37(D)=
  OK
[    4.444147] raid6test: test_disks(7, 38): faila=3D  7(D)  failb=3D 38(D)=
  OK
[    4.445061] raid6test: test_disks(7, 39): faila=3D  7(D)  failb=3D 39(D)=
  OK
[    4.445980] raid6test: test_disks(7, 40): faila=3D  7(D)  failb=3D 40(D)=
  OK
[    4.446996] raid6test: test_disks(7, 41): faila=3D  7(D)  failb=3D 41(D)=
  OK
[    4.447936] raid6test: test_disks(7, 42): faila=3D  7(D)  failb=3D 42(D)=
  OK
[    4.448903] raid6test: test_disks(7, 43): faila=3D  7(D)  failb=3D 43(D)=
  OK
[    4.449857] raid6test: test_disks(7, 44): faila=3D  7(D)  failb=3D 44(D)=
  OK
[    4.450872] raid6test: test_disks(7, 45): faila=3D  7(D)  failb=3D 45(D)=
  OK
[    4.451874] raid6test: test_disks(7, 46): faila=3D  7(D)  failb=3D 46(D)=
  OK
[    4.452811] raid6test: test_disks(7, 47): faila=3D  7(D)  failb=3D 47(D)=
  OK
[    4.453810] raid6test: test_disks(7, 48): faila=3D  7(D)  failb=3D 48(D)=
  OK
[    4.454775] raid6test: test_disks(7, 49): faila=3D  7(D)  failb=3D 49(D)=
  OK
[    4.455776] raid6test: test_disks(7, 50): faila=3D  7(D)  failb=3D 50(D)=
  OK
[    4.456822] raid6test: test_disks(7, 51): faila=3D  7(D)  failb=3D 51(D)=
  OK
[    4.457767] raid6test: test_disks(7, 52): faila=3D  7(D)  failb=3D 52(D)=
  OK
[    4.458734] raid6test: test_disks(7, 53): faila=3D  7(D)  failb=3D 53(D)=
  OK
[    4.459735] raid6test: test_disks(7, 54): faila=3D  7(D)  failb=3D 54(D)=
  OK
[    4.460665] raid6test: test_disks(7, 55): faila=3D  7(D)  failb=3D 55(D)=
  OK
[    4.461605] raid6test: test_disks(7, 56): faila=3D  7(D)  failb=3D 56(D)=
  OK
[    4.462574] raid6test: test_disks(7, 57): faila=3D  7(D)  failb=3D 57(D)=
  OK
[    4.463591] raid6test: test_disks(7, 58): faila=3D  7(D)  failb=3D 58(D)=
  OK
[    4.464527] raid6test: test_disks(7, 59): faila=3D  7(D)  failb=3D 59(D)=
  OK
[    4.465468] raid6test: test_disks(7, 60): faila=3D  7(D)  failb=3D 60(D)=
  OK
[    4.466443] raid6test: test_disks(7, 61): faila=3D  7(D)  failb=3D 61(D)=
  OK
[    4.467471] raid6test: test_disks(7, 62): faila=3D  7(D)  failb=3D 62(P)=
  OK
[    4.468422] raid6test: test_disks(7, 63): faila=3D  7(D)  failb=3D 63(Q)=
  OK
[    4.469361] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(D) =
 OK
[    4.470326] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(D)=
  OK
[    4.471334] raid6test: test_disks(8, 11): faila=3D  8(D)  failb=3D 11(D)=
  OK
[    4.472278] raid6test: test_disks(8, 12): faila=3D  8(D)  failb=3D 12(D)=
  OK
[    4.473210] raid6test: test_disks(8, 13): faila=3D  8(D)  failb=3D 13(D)=
  OK
[    4.474476] raid6test: test_disks(8, 14): faila=3D  8(D)  failb=3D 14(D)=
  OK
[    4.475944] raid6test: test_disks(8, 15): faila=3D  8(D)  failb=3D 15(D)=
  OK
[    4.477389] raid6test: test_disks(8, 16): faila=3D  8(D)  failb=3D 16(D)=
  OK
[    4.478866] raid6test: test_disks(8, 17): faila=3D  8(D)  failb=3D 17(D)=
  OK
[    4.480330] raid6test: test_disks(8, 18): faila=3D  8(D)  failb=3D 18(D)=
  OK
[    4.481794] raid6test: test_disks(8, 19): faila=3D  8(D)  failb=3D 19(D)=
  OK
[    4.483261] raid6test: test_disks(8, 20): faila=3D  8(D)  failb=3D 20(D)=
  OK
[    4.484742] raid6test: test_disks(8, 21): faila=3D  8(D)  failb=3D 21(D)=
  OK
[    4.486211] raid6test: test_disks(8, 22): faila=3D  8(D)  failb=3D 22(D)=
  OK
[    4.487674] raid6test: test_disks(8, 23): faila=3D  8(D)  failb=3D 23(D)=
  OK
[    4.489151] raid6test: test_disks(8, 24): faila=3D  8(D)  failb=3D 24(D)=
  OK
[    4.490591] raid6test: test_disks(8, 25): faila=3D  8(D)  failb=3D 25(D)=
  OK
[    4.492089] raid6test: test_disks(8, 26): faila=3D  8(D)  failb=3D 26(D)=
  OK
[    4.493474] raid6test: test_disks(8, 27): faila=3D  8(D)  failb=3D 27(D)=
  OK
[    4.494413] raid6test: test_disks(8, 28): faila=3D  8(D)  failb=3D 28(D)=
  OK
[    4.495382] raid6test: test_disks(8, 29): faila=3D  8(D)  failb=3D 29(D)=
  OK
[    4.496286] raid6test: test_disks(8, 30): faila=3D  8(D)  failb=3D 30(D)=
  OK
[    4.497187] raid6test: test_disks(8, 31): faila=3D  8(D)  failb=3D 31(D)=
  OK
[    4.498123] raid6test: test_disks(8, 32): faila=3D  8(D)  failb=3D 32(D)=
  OK
[    4.499081] raid6test: test_disks(8, 33): faila=3D  8(D)  failb=3D 33(D)=
  OK
[    4.499954] raid6test: test_disks(8, 34): faila=3D  8(D)  failb=3D 34(D)=
  OK
[    4.500857] raid6test: test_disks(8, 35): faila=3D  8(D)  failb=3D 35(D)=
  OK
[    4.501770] raid6test: test_disks(8, 36): faila=3D  8(D)  failb=3D 36(D)=
  OK
[    4.502677] raid6test: test_disks(8, 37): faila=3D  8(D)  failb=3D 37(D)=
  OK
[    4.503611] raid6test: test_disks(8, 38): faila=3D  8(D)  failb=3D 38(D)=
  OK
[    4.504509] raid6test: test_disks(8, 39): faila=3D  8(D)  failb=3D 39(D)=
  OK
[    4.505402] raid6test: test_disks(8, 40): faila=3D  8(D)  failb=3D 40(D)=
  OK
[    4.506299] raid6test: test_disks(8, 41): faila=3D  8(D)  failb=3D 41(D)=
  OK
[    4.507265] raid6test: test_disks(8, 42): faila=3D  8(D)  failb=3D 42(D)=
  OK
[    4.508191] raid6test: test_disks(8, 43): faila=3D  8(D)  failb=3D 43(D)=
  OK
[    4.509092] raid6test: test_disks(8, 44): faila=3D  8(D)  failb=3D 44(D)=
  OK
[    4.509963] raid6test: test_disks(8, 45): faila=3D  8(D)  failb=3D 45(D)=
  OK
[    4.511058] raid6test: test_disks(8, 46): faila=3D  8(D)  failb=3D 46(D)=
  OK
[    4.511925] raid6test: test_disks(8, 47): faila=3D  8(D)  failb=3D 47(D)=
  OK
[    4.512836] raid6test: test_disks(8, 48): faila=3D  8(D)  failb=3D 48(D)=
  OK
[    4.513741] raid6test: test_disks(8, 49): faila=3D  8(D)  failb=3D 49(D)=
  OK
[    4.514647] raid6test: test_disks(8, 50): faila=3D  8(D)  failb=3D 50(D)=
  OK
[    4.515614] raid6test: test_disks(8, 51): faila=3D  8(D)  failb=3D 51(D)=
  OK
[    4.516514] raid6test: test_disks(8, 52): faila=3D  8(D)  failb=3D 52(D)=
  OK
[    4.517413] raid6test: test_disks(8, 53): faila=3D  8(D)  failb=3D 53(D)=
  OK
[    4.518338] raid6test: test_disks(8, 54): faila=3D  8(D)  failb=3D 54(D)=
  OK
[    4.519303] raid6test: test_disks(8, 55): faila=3D  8(D)  failb=3D 55(D)=
  OK
[    4.520206] raid6test: test_disks(8, 56): faila=3D  8(D)  failb=3D 56(D)=
  OK
[    4.521111] raid6test: test_disks(8, 57): faila=3D  8(D)  failb=3D 57(D)=
  OK
[    4.521980] raid6test: test_disks(8, 58): faila=3D  8(D)  failb=3D 58(D)=
  OK
[    4.522922] raid6test: test_disks(8, 59): faila=3D  8(D)  failb=3D 59(D)=
  OK
[    4.523843] raid6test: test_disks(8, 60): faila=3D  8(D)  failb=3D 60(D)=
  OK
[    4.524759] raid6test: test_disks(8, 61): faila=3D  8(D)  failb=3D 61(D)=
  OK
[    4.525657] raid6test: test_disks(8, 62): faila=3D  8(D)  failb=3D 62(P)=
  OK
[    4.526559] raid6test: test_disks(8, 63): faila=3D  8(D)  failb=3D 63(Q)=
  OK
[    4.527514] raid6test: test_disks(9, 10): faila=3D  9(D)  failb=3D 10(D)=
  OK
[    4.528442] raid6test: test_disks(9, 11): faila=3D  9(D)  failb=3D 11(D)=
  OK
[    4.529468] raid6test: test_disks(9, 12): faila=3D  9(D)  failb=3D 12(D)=
  OK
[    4.530364] raid6test: test_disks(9, 13): faila=3D  9(D)  failb=3D 13(D)=
  OK
[    4.531327] raid6test: test_disks(9, 14): faila=3D  9(D)  failb=3D 14(D)=
  OK
[    4.532224] raid6test: test_disks(9, 15): faila=3D  9(D)  failb=3D 15(D)=
  OK
[    4.533117] raid6test: test_disks(9, 16): faila=3D  9(D)  failb=3D 16(D)=
  OK
[    4.533980] raid6test: test_disks(9, 17): faila=3D  9(D)  failb=3D 17(D)=
  OK
[    4.534924] raid6test: test_disks(9, 18): faila=3D  9(D)  failb=3D 18(D)=
  OK
[    4.535837] raid6test: test_disks(9, 19): faila=3D  9(D)  failb=3D 19(D)=
  OK
[    4.536744] raid6test: test_disks(9, 20): faila=3D  9(D)  failb=3D 20(D)=
  OK
[    4.537678] raid6test: test_disks(9, 21): faila=3D  9(D)  failb=3D 21(D)=
  OK
[    4.538590] raid6test: test_disks(9, 22): faila=3D  9(D)  failb=3D 22(D)=
  OK
[    4.539551] raid6test: test_disks(9, 23): faila=3D  9(D)  failb=3D 23(D)=
  OK
[    4.540442] raid6test: test_disks(9, 24): faila=3D  9(D)  failb=3D 24(D)=
  OK
[    4.541342] raid6test: test_disks(9, 25): faila=3D  9(D)  failb=3D 25(D)=
  OK
[    4.542360] raid6test: test_disks(9, 26): faila=3D  9(D)  failb=3D 26(D)=
  OK
[    4.543317] raid6test: test_disks(9, 27): faila=3D  9(D)  failb=3D 27(D)=
  OK
[    4.544210] raid6test: test_disks(9, 28): faila=3D  9(D)  failb=3D 28(D)=
  OK
[    4.545109] raid6test: test_disks(9, 29): faila=3D  9(D)  failb=3D 29(D)=
  OK
[    4.545972] raid6test: test_disks(9, 30): faila=3D  9(D)  failb=3D 30(D)=
  OK
[    4.546905] raid6test: test_disks(9, 31): faila=3D  9(D)  failb=3D 31(D)=
  OK
[    4.547862] raid6test: test_disks(9, 32): faila=3D  9(D)  failb=3D 32(D)=
  OK
[    4.548767] raid6test: test_disks(9, 33): faila=3D  9(D)  failb=3D 33(D)=
  OK
[    4.549667] raid6test: test_disks(9, 34): faila=3D  9(D)  failb=3D 34(D)=
  OK
[    4.550575] raid6test: test_disks(9, 35): faila=3D  9(D)  failb=3D 35(D)=
  OK
[    4.551531] raid6test: test_disks(9, 36): faila=3D  9(D)  failb=3D 36(D)=
  OK
[    4.552422] raid6test: test_disks(9, 37): faila=3D  9(D)  failb=3D 37(D)=
  OK
[    4.553314] raid6test: test_disks(9, 38): faila=3D  9(D)  failb=3D 38(D)=
  OK
[    4.554211] raid6test: test_disks(9, 39): faila=3D  9(D)  failb=3D 39(D)=
  OK
[    4.555174] raid6test: test_disks(9, 40): faila=3D  9(D)  failb=3D 40(D)=
  OK
[    4.556077] raid6test: test_disks(9, 41): faila=3D  9(D)  failb=3D 41(D)=
  OK
[    4.556947] raid6test: test_disks(9, 42): faila=3D  9(D)  failb=3D 42(D)=
  OK
[    4.558008] raid6test: test_disks(9, 43): faila=3D  9(D)  failb=3D 43(D)=
  OK
[    4.558951] raid6test: test_disks(9, 44): faila=3D  9(D)  failb=3D 44(D)=
  OK
[    4.559873] raid6test: test_disks(9, 45): faila=3D  9(D)  failb=3D 45(D)=
  OK
[    4.560776] raid6test: test_disks(9, 46): faila=3D  9(D)  failb=3D 46(D)=
  OK
[    4.561676] raid6test: test_disks(9, 47): faila=3D  9(D)  failb=3D 47(D)=
  OK
[    4.562582] raid6test: test_disks(9, 48): faila=3D  9(D)  failb=3D 48(D)=
  OK
[    4.563501] raid6test: test_disks(9, 49): faila=3D  9(D)  failb=3D 49(D)=
  OK
[    4.564394] raid6test: test_disks(9, 50): faila=3D  9(D)  failb=3D 50(D)=
  OK
[    4.565291] raid6test: test_disks(9, 51): faila=3D  9(D)  failb=3D 51(D)=
  OK
[    4.566204] raid6test: test_disks(9, 52): faila=3D  9(D)  failb=3D 52(D)=
  OK
[    4.567105] raid6test: test_disks(9, 53): faila=3D  9(D)  failb=3D 53(D)=
  OK
[    4.567999] raid6test: test_disks(9, 54): faila=3D  9(D)  failb=3D 54(D)=
  OK
[    4.568906] raid6test: test_disks(9, 55): faila=3D  9(D)  failb=3D 55(D)=
  OK
[    4.569822] raid6test: test_disks(9, 56): faila=3D  9(D)  failb=3D 56(D)=
  OK
[    4.570811] raid6test: test_disks(9, 57): faila=3D  9(D)  failb=3D 57(D)=
  OK
[    4.571745] raid6test: test_disks(9, 58): faila=3D  9(D)  failb=3D 58(D)=
  OK
[    4.572648] raid6test: test_disks(9, 59): faila=3D  9(D)  failb=3D 59(D)=
  OK
[    4.573554] raid6test: test_disks(9, 60): faila=3D  9(D)  failb=3D 60(D)=
  OK
[    4.574454] raid6test: test_disks(9, 61): faila=3D  9(D)  failb=3D 61(D)=
  OK
[    4.575343] raid6test: test_disks(9, 62): faila=3D  9(D)  failb=3D 62(P)=
  OK
[    4.576231] raid6test: test_disks(9, 63): faila=3D  9(D)  failb=3D 63(Q)=
  OK
[    4.577133] raid6test: test_disks(10, 11): faila=3D 10(D)  failb=3D 11(D=
)  OK
[    4.578070] raid6test: test_disks(10, 12): faila=3D 10(D)  failb=3D 12(D=
)  OK
[    4.578952] raid6test: test_disks(10, 13): faila=3D 10(D)  failb=3D 13(D=
)  OK
[    4.579872] raid6test: test_disks(10, 14): faila=3D 10(D)  failb=3D 14(D=
)  OK
[    4.580785] raid6test: test_disks(10, 15): faila=3D 10(D)  failb=3D 15(D=
)  OK
[    4.581704] raid6test: test_disks(10, 16): faila=3D 10(D)  failb=3D 16(D=
)  OK
[    4.582628] raid6test: test_disks(10, 17): faila=3D 10(D)  failb=3D 17(D=
)  OK
[    4.583544] raid6test: test_disks(10, 18): faila=3D 10(D)  failb=3D 18(D=
)  OK
[    4.584451] raid6test: test_disks(10, 19): faila=3D 10(D)  failb=3D 19(D=
)  OK
[    4.585357] raid6test: test_disks(10, 20): faila=3D 10(D)  failb=3D 20(D=
)  OK
[    4.586278] raid6test: test_disks(10, 21): faila=3D 10(D)  failb=3D 21(D=
)  OK
[    4.587189] raid6test: test_disks(10, 22): faila=3D 10(D)  failb=3D 22(D=
)  OK
[    4.588129] raid6test: test_disks(10, 23): faila=3D 10(D)  failb=3D 23(D=
)  OK
[    4.589046] raid6test: test_disks(10, 24): faila=3D 10(D)  failb=3D 24(D=
)  OK
[    4.589917] raid6test: test_disks(10, 25): faila=3D 10(D)  failb=3D 25(D=
)  OK
[    4.590834] raid6test: test_disks(10, 26): faila=3D 10(D)  failb=3D 26(D=
)  OK
[    4.591756] raid6test: test_disks(10, 27): faila=3D 10(D)  failb=3D 27(D=
)  OK
[    4.592664] raid6test: test_disks(10, 28): faila=3D 10(D)  failb=3D 28(D=
)  OK
[    4.593586] raid6test: test_disks(10, 29): faila=3D 10(D)  failb=3D 29(D=
)  OK
[    4.594497] raid6test: test_disks(10, 30): faila=3D 10(D)  failb=3D 30(D=
)  OK
[    4.595410] raid6test: test_disks(10, 31): faila=3D 10(D)  failb=3D 31(D=
)  OK
[    4.596323] raid6test: test_disks(10, 32): faila=3D 10(D)  failb=3D 32(D=
)  OK
[    4.597232] raid6test: test_disks(10, 33): faila=3D 10(D)  failb=3D 33(D=
)  OK
[    4.598186] raid6test: test_disks(10, 34): faila=3D 10(D)  failb=3D 34(D=
)  OK
[    4.599107] raid6test: test_disks(10, 35): faila=3D 10(D)  failb=3D 35(D=
)  OK
[    4.599994] raid6test: test_disks(10, 36): faila=3D 10(D)  failb=3D 36(D=
)  OK
[    4.600909] raid6test: test_disks(10, 37): faila=3D 10(D)  failb=3D 37(D=
)  OK
[    4.601822] raid6test: test_disks(10, 38): faila=3D 10(D)  failb=3D 38(D=
)  OK
[    4.602741] raid6test: test_disks(10, 39): faila=3D 10(D)  failb=3D 39(D=
)  OK
[    4.603657] raid6test: test_disks(10, 40): faila=3D 10(D)  failb=3D 40(D=
)  OK
[    4.604576] raid6test: test_disks(10, 41): faila=3D 10(D)  failb=3D 41(D=
)  OK
[    4.605484] raid6test: test_disks(10, 42): faila=3D 10(D)  failb=3D 42(D=
)  OK
[    4.606389] raid6test: test_disks(10, 43): faila=3D 10(D)  failb=3D 43(D=
)  OK
[    4.607297] raid6test: test_disks(10, 44): faila=3D 10(D)  failb=3D 44(D=
)  OK
[    4.608233] raid6test: test_disks(10, 45): faila=3D 10(D)  failb=3D 45(D=
)  OK
[    4.609140] raid6test: test_disks(10, 46): faila=3D 10(D)  failb=3D 46(D=
)  OK
[    4.610047] raid6test: test_disks(10, 47): faila=3D 10(D)  failb=3D 47(D=
)  OK
[    4.610921] raid6test: test_disks(10, 48): faila=3D 10(D)  failb=3D 48(D=
)  OK
[    4.611849] raid6test: test_disks(10, 49): faila=3D 10(D)  failb=3D 49(D=
)  OK
[    4.612764] raid6test: test_disks(10, 50): faila=3D 10(D)  failb=3D 50(D=
)  OK
[    4.613676] raid6test: test_disks(10, 51): faila=3D 10(D)  failb=3D 51(D=
)  OK
[    4.614653] raid6test: test_disks(10, 52): faila=3D 10(D)  failb=3D 52(D=
)  OK
[    4.615571] raid6test: test_disks(10, 53): faila=3D 10(D)  failb=3D 53(D=
)  OK
[    4.616476] raid6test: test_disks(10, 54): faila=3D 10(D)  failb=3D 54(D=
)  OK
[    4.617395] raid6test: test_disks(10, 55): faila=3D 10(D)  failb=3D 55(D=
)  OK
[    4.618327] raid6test: test_disks(10, 56): faila=3D 10(D)  failb=3D 56(D=
)  OK
[    4.619238] raid6test: test_disks(10, 57): faila=3D 10(D)  failb=3D 57(D=
)  OK
[    4.620153] raid6test: test_disks(10, 58): faila=3D 10(D)  failb=3D 58(D=
)  OK
[    4.621072] raid6test: test_disks(10, 59): faila=3D 10(D)  failb=3D 59(D=
)  OK
[    4.621948] raid6test: test_disks(10, 60): faila=3D 10(D)  failb=3D 60(D=
)  OK
[    4.622872] raid6test: test_disks(10, 61): faila=3D 10(D)  failb=3D 61(D=
)  OK
[    4.623792] raid6test: test_disks(10, 62): faila=3D 10(D)  failb=3D 62(P=
)  OK
[    4.624700] raid6test: test_disks(10, 63): faila=3D 10(D)  failb=3D 63(Q=
)  OK
[    4.625625] raid6test: test_disks(11, 12): faila=3D 11(D)  failb=3D 12(D=
)  OK
[    4.626546] raid6test: test_disks(11, 13): faila=3D 11(D)  failb=3D 13(D=
)  OK
[    4.627450] raid6test: test_disks(11, 14): faila=3D 11(D)  failb=3D 14(D=
)  OK
[    4.628382] raid6test: test_disks(11, 15): faila=3D 11(D)  failb=3D 15(D=
)  OK
[    4.629286] raid6test: test_disks(11, 16): faila=3D 11(D)  failb=3D 16(D=
)  OK
[    4.630195] raid6test: test_disks(11, 17): faila=3D 11(D)  failb=3D 17(D=
)  OK
[    4.631106] raid6test: test_disks(11, 18): faila=3D 11(D)  failb=3D 18(D=
)  OK
[    4.631986] raid6test: test_disks(11, 19): faila=3D 11(D)  failb=3D 19(D=
)  OK
[    4.632904] raid6test: test_disks(11, 20): faila=3D 11(D)  failb=3D 20(D=
)  OK
[    4.633820] raid6test: test_disks(11, 21): faila=3D 11(D)  failb=3D 21(D=
)  OK
[    4.634736] raid6test: test_disks(11, 22): faila=3D 11(D)  failb=3D 22(D=
)  OK
[    4.635645] raid6test: test_disks(11, 23): faila=3D 11(D)  failb=3D 23(D=
)  OK
[    4.636557] raid6test: test_disks(11, 24): faila=3D 11(D)  failb=3D 24(D=
)  OK
[    4.637461] raid6test: test_disks(11, 25): faila=3D 11(D)  failb=3D 25(D=
)  OK
[    4.638421] raid6test: test_disks(11, 26): faila=3D 11(D)  failb=3D 26(D=
)  OK
[    4.639335] raid6test: test_disks(11, 27): faila=3D 11(D)  failb=3D 27(D=
)  OK
[    4.640245] raid6test: test_disks(11, 28): faila=3D 11(D)  failb=3D 28(D=
)  OK
[    4.641166] raid6test: test_disks(11, 29): faila=3D 11(D)  failb=3D 29(D=
)  OK
[    4.642078] raid6test: test_disks(11, 30): faila=3D 11(D)  failb=3D 30(D=
)  OK
[    4.642949] raid6test: test_disks(11, 31): faila=3D 11(D)  failb=3D 31(D=
)  OK
[    4.643870] raid6test: test_disks(11, 32): faila=3D 11(D)  failb=3D 32(D=
)  OK
[    4.644786] raid6test: test_disks(11, 33): faila=3D 11(D)  failb=3D 33(D=
)  OK
[    4.645703] raid6test: test_disks(11, 34): faila=3D 11(D)  failb=3D 34(D=
)  OK
[    4.646620] raid6test: test_disks(11, 35): faila=3D 11(D)  failb=3D 35(D=
)  OK
[    4.647528] raid6test: test_disks(11, 36): faila=3D 11(D)  failb=3D 36(D=
)  OK
[    4.648467] raid6test: test_disks(11, 37): faila=3D 11(D)  failb=3D 37(D=
)  OK
[    4.649370] raid6test: test_disks(11, 38): faila=3D 11(D)  failb=3D 38(D=
)  OK
[    4.650278] raid6test: test_disks(11, 39): faila=3D 11(D)  failb=3D 39(D=
)  OK
[    4.651193] raid6test: test_disks(11, 40): faila=3D 11(D)  failb=3D 40(D=
)  OK
[    4.652130] raid6test: test_disks(11, 41): faila=3D 11(D)  failb=3D 41(D=
)  OK
[    4.653056] raid6test: test_disks(11, 42): faila=3D 11(D)  failb=3D 42(D=
)  OK
[    4.653929] raid6test: test_disks(11, 43): faila=3D 11(D)  failb=3D 43(D=
)  OK
[    4.654844] raid6test: test_disks(11, 44): faila=3D 11(D)  failb=3D 44(D=
)  OK
[    4.655761] raid6test: test_disks(11, 45): faila=3D 11(D)  failb=3D 45(D=
)  OK
[    4.656675] raid6test: test_disks(11, 46): faila=3D 11(D)  failb=3D 46(D=
)  OK
[    4.657634] raid6test: test_disks(11, 47): faila=3D 11(D)  failb=3D 47(D=
)  OK
[    4.658560] raid6test: test_disks(11, 48): faila=3D 11(D)  failb=3D 48(D=
)  OK
[    4.659467] raid6test: test_disks(11, 49): faila=3D 11(D)  failb=3D 49(D=
)  OK
[    4.660380] raid6test: test_disks(11, 50): faila=3D 11(D)  failb=3D 50(D=
)  OK
[    4.661291] raid6test: test_disks(11, 51): faila=3D 11(D)  failb=3D 51(D=
)  OK
[    4.662198] raid6test: test_disks(11, 52): faila=3D 11(D)  failb=3D 52(D=
)  OK
[    4.663111] raid6test: test_disks(11, 53): faila=3D 11(D)  failb=3D 53(D=
)  OK
[    4.663982] raid6test: test_disks(11, 54): faila=3D 11(D)  failb=3D 54(D=
)  OK
[    4.664901] raid6test: test_disks(11, 55): faila=3D 11(D)  failb=3D 55(D=
)  OK
[    4.665811] raid6test: test_disks(11, 56): faila=3D 11(D)  failb=3D 56(D=
)  OK
[    4.666720] raid6test: test_disks(11, 57): faila=3D 11(D)  failb=3D 57(D=
)  OK
[    4.667663] raid6test: test_disks(11, 58): faila=3D 11(D)  failb=3D 58(D=
)  OK
[    4.668585] raid6test: test_disks(11, 59): faila=3D 11(D)  failb=3D 59(D=
)  OK
[    4.669492] raid6test: test_disks(11, 60): faila=3D 11(D)  failb=3D 60(D=
)  OK
[    4.670404] raid6test: test_disks(11, 61): faila=3D 11(D)  failb=3D 61(D=
)  OK
[    4.671311] raid6test: test_disks(11, 62): faila=3D 11(D)  failb=3D 62(P=
)  OK
[    4.672214] raid6test: test_disks(11, 63): faila=3D 11(D)  failb=3D 63(Q=
)  OK
[    4.673124] raid6test: test_disks(12, 13): faila=3D 12(D)  failb=3D 13(D=
)  OK
[    4.674000] raid6test: test_disks(12, 14): faila=3D 12(D)  failb=3D 14(D=
)  OK
[    4.674908] raid6test: test_disks(12, 15): faila=3D 12(D)  failb=3D 15(D=
)  OK
[    4.675815] raid6test: test_disks(12, 16): faila=3D 12(D)  failb=3D 16(D=
)  OK
[    4.676729] raid6test: test_disks(12, 17): faila=3D 12(D)  failb=3D 17(D=
)  OK
[    4.677648] raid6test: test_disks(12, 18): faila=3D 12(D)  failb=3D 18(D=
)  OK
[    4.678561] raid6test: test_disks(12, 19): faila=3D 12(D)  failb=3D 19(D=
)  OK
[    4.679465] raid6test: test_disks(12, 20): faila=3D 12(D)  failb=3D 20(D=
)  OK
[    4.680375] raid6test: test_disks(12, 21): faila=3D 12(D)  failb=3D 21(D=
)  OK
[    4.681284] raid6test: test_disks(12, 22): faila=3D 12(D)  failb=3D 22(D=
)  OK
[    4.682189] raid6test: test_disks(12, 23): faila=3D 12(D)  failb=3D 23(D=
)  OK
[    4.683098] raid6test: test_disks(12, 24): faila=3D 12(D)  failb=3D 24(D=
)  OK
[    4.683968] raid6test: test_disks(12, 25): faila=3D 12(D)  failb=3D 25(D=
)  OK
[    4.684881] raid6test: test_disks(12, 26): faila=3D 12(D)  failb=3D 26(D=
)  OK
[    4.685790] raid6test: test_disks(12, 27): faila=3D 12(D)  failb=3D 27(D=
)  OK
[    4.686696] raid6test: test_disks(12, 28): faila=3D 12(D)  failb=3D 28(D=
)  OK
[    4.687615] raid6test: test_disks(12, 29): faila=3D 12(D)  failb=3D 29(D=
)  OK
[    4.688521] raid6test: test_disks(12, 30): faila=3D 12(D)  failb=3D 30(D=
)  OK
[    4.689431] raid6test: test_disks(12, 31): faila=3D 12(D)  failb=3D 31(D=
)  OK
[    4.690338] raid6test: test_disks(12, 32): faila=3D 12(D)  failb=3D 32(D=
)  OK
[    4.691242] raid6test: test_disks(12, 33): faila=3D 12(D)  failb=3D 33(D=
)  OK
[    4.692171] raid6test: test_disks(12, 34): faila=3D 12(D)  failb=3D 34(D=
)  OK
[    4.693309] raid6test: test_disks(12, 35): faila=3D 12(D)  failb=3D 35(D=
)  OK
[    4.694216] raid6test: test_disks(12, 36): faila=3D 12(D)  failb=3D 36(D=
)  OK
[    4.695125] raid6test: test_disks(12, 37): faila=3D 12(D)  failb=3D 37(D=
)  OK
[    4.695995] raid6test: test_disks(12, 38): faila=3D 12(D)  failb=3D 38(D=
)  OK
[    4.696913] raid6test: test_disks(12, 39): faila=3D 12(D)  failb=3D 39(D=
)  OK
[    4.697853] raid6test: test_disks(12, 40): faila=3D 12(D)  failb=3D 40(D=
)  OK
[    4.698771] raid6test: test_disks(12, 41): faila=3D 12(D)  failb=3D 41(D=
)  OK
[    4.699690] raid6test: test_disks(12, 42): faila=3D 12(D)  failb=3D 42(D=
)  OK
[    4.700607] raid6test: test_disks(12, 43): faila=3D 12(D)  failb=3D 43(D=
)  OK
[    4.701627] raid6test: test_disks(12, 44): faila=3D 12(D)  failb=3D 44(D=
)  OK
[    4.702544] raid6test: test_disks(12, 45): faila=3D 12(D)  failb=3D 45(D=
)  OK
[    4.703452] raid6test: test_disks(12, 46): faila=3D 12(D)  failb=3D 46(D=
)  OK
[    4.704356] raid6test: test_disks(12, 47): faila=3D 12(D)  failb=3D 47(D=
)  OK
[    4.705259] raid6test: test_disks(12, 48): faila=3D 12(D)  failb=3D 48(D=
)  OK
[    4.706166] raid6test: test_disks(12, 49): faila=3D 12(D)  failb=3D 49(D=
)  OK
[    4.707075] raid6test: test_disks(12, 50): faila=3D 12(D)  failb=3D 50(D=
)  OK
[    4.707976] raid6test: test_disks(12, 51): faila=3D 12(D)  failb=3D 51(D=
)  OK
[    4.708888] raid6test: test_disks(12, 52): faila=3D 12(D)  failb=3D 52(D=
)  OK
[    4.709801] raid6test: test_disks(12, 53): faila=3D 12(D)  failb=3D 53(D=
)  OK
[    4.710717] raid6test: test_disks(12, 54): faila=3D 12(D)  failb=3D 54(D=
)  OK
[    4.711632] raid6test: test_disks(12, 55): faila=3D 12(D)  failb=3D 55(D=
)  OK
[    4.712646] raid6test: test_disks(12, 56): faila=3D 12(D)  failb=3D 56(D=
)  OK
[    4.713564] raid6test: test_disks(12, 57): faila=3D 12(D)  failb=3D 57(D=
)  OK
[    4.714473] raid6test: test_disks(12, 58): faila=3D 12(D)  failb=3D 58(D=
)  OK
[    4.715377] raid6test: test_disks(12, 59): faila=3D 12(D)  failb=3D 59(D=
)  OK
[    4.716282] raid6test: test_disks(12, 60): faila=3D 12(D)  failb=3D 60(D=
)  OK
[    4.717197] raid6test: test_disks(12, 61): faila=3D 12(D)  failb=3D 61(D=
)  OK
[    4.718131] raid6test: test_disks(12, 62): faila=3D 12(D)  failb=3D 62(P=
)  OK
[    4.719040] raid6test: test_disks(12, 63): faila=3D 12(D)  failb=3D 63(Q=
)  OK
[    4.719919] raid6test: test_disks(13, 14): faila=3D 13(D)  failb=3D 14(D=
)  OK
[    4.720837] raid6test: test_disks(13, 15): faila=3D 13(D)  failb=3D 15(D=
)  OK
[    4.721760] raid6test: test_disks(13, 16): faila=3D 13(D)  failb=3D 16(D=
)  OK
[    4.722676] raid6test: test_disks(13, 17): faila=3D 13(D)  failb=3D 17(D=
)  OK
[    4.723600] raid6test: test_disks(13, 18): faila=3D 13(D)  failb=3D 18(D=
)  OK
[    4.724511] raid6test: test_disks(13, 19): faila=3D 13(D)  failb=3D 19(D=
)  OK
[    4.725417] raid6test: test_disks(13, 20): faila=3D 13(D)  failb=3D 20(D=
)  OK
[    4.726323] raid6test: test_disks(13, 21): faila=3D 13(D)  failb=3D 21(D=
)  OK
[    4.727230] raid6test: test_disks(13, 22): faila=3D 13(D)  failb=3D 22(D=
)  OK
[    4.728164] raid6test: test_disks(13, 23): faila=3D 13(D)  failb=3D 23(D=
)  OK
[    4.729078] raid6test: test_disks(13, 24): faila=3D 13(D)  failb=3D 24(D=
)  OK
[    4.729954] raid6test: test_disks(13, 25): faila=3D 13(D)  failb=3D 25(D=
)  OK
[    4.730875] raid6test: test_disks(13, 26): faila=3D 13(D)  failb=3D 26(D=
)  OK
[    4.731804] raid6test: test_disks(13, 27): faila=3D 13(D)  failb=3D 27(D=
)  OK
[    4.732836] raid6test: test_disks(13, 28): faila=3D 13(D)  failb=3D 28(D=
)  OK
[    4.733761] raid6test: test_disks(13, 29): faila=3D 13(D)  failb=3D 29(D=
)  OK
[    4.734675] raid6test: test_disks(13, 30): faila=3D 13(D)  failb=3D 30(D=
)  OK
[    4.735593] raid6test: test_disks(13, 31): faila=3D 13(D)  failb=3D 31(D=
)  OK
[    4.736499] raid6test: test_disks(13, 32): faila=3D 13(D)  failb=3D 32(D=
)  OK
[    4.737408] raid6test: test_disks(13, 33): faila=3D 13(D)  failb=3D 33(D=
)  OK
[    4.738348] raid6test: test_disks(13, 34): faila=3D 13(D)  failb=3D 34(D=
)  OK
[    4.739258] raid6test: test_disks(13, 35): faila=3D 13(D)  failb=3D 35(D=
)  OK
[    4.740166] raid6test: test_disks(13, 36): faila=3D 13(D)  failb=3D 36(D=
)  OK
[    4.741076] raid6test: test_disks(13, 37): faila=3D 13(D)  failb=3D 37(D=
)  OK
[    4.741948] raid6test: test_disks(13, 38): faila=3D 13(D)  failb=3D 38(D=
)  OK
[    4.742866] raid6test: test_disks(13, 39): faila=3D 13(D)  failb=3D 39(D=
)  OK
[    4.743786] raid6test: test_disks(13, 40): faila=3D 13(D)  failb=3D 40(D=
)  OK
[    4.744704] raid6test: test_disks(13, 41): faila=3D 13(D)  failb=3D 41(D=
)  OK
[    4.745623] raid6test: test_disks(13, 42): faila=3D 13(D)  failb=3D 42(D=
)  OK
[    4.746532] raid6test: test_disks(13, 43): faila=3D 13(D)  failb=3D 43(D=
)  OK
[    4.747435] raid6test: test_disks(13, 44): faila=3D 13(D)  failb=3D 44(D=
)  OK
[    4.748380] raid6test: test_disks(13, 45): faila=3D 13(D)  failb=3D 45(D=
)  OK
[    4.749290] raid6test: test_disks(13, 46): faila=3D 13(D)  failb=3D 46(D=
)  OK
[    4.750198] raid6test: test_disks(13, 47): faila=3D 13(D)  failb=3D 47(D=
)  OK
[    4.751115] raid6test: test_disks(13, 48): faila=3D 13(D)  failb=3D 48(D=
)  OK
[    4.751986] raid6test: test_disks(13, 49): faila=3D 13(D)  failb=3D 49(D=
)  OK
[    4.752902] raid6test: test_disks(13, 50): faila=3D 13(D)  failb=3D 50(D=
)  OK
[    4.753813] raid6test: test_disks(13, 51): faila=3D 13(D)  failb=3D 51(D=
)  OK
[    4.754726] raid6test: test_disks(13, 52): faila=3D 13(D)  failb=3D 52(D=
)  OK
[    4.755636] raid6test: test_disks(13, 53): faila=3D 13(D)  failb=3D 53(D=
)  OK
[    4.756545] raid6test: test_disks(13, 54): faila=3D 13(D)  failb=3D 54(D=
)  OK
[    4.757448] raid6test: test_disks(13, 55): faila=3D 13(D)  failb=3D 55(D=
)  OK
[    4.758388] raid6test: test_disks(13, 56): faila=3D 13(D)  failb=3D 56(D=
)  OK
[    4.759297] raid6test: test_disks(13, 57): faila=3D 13(D)  failb=3D 57(D=
)  OK
[    4.760212] raid6test: test_disks(13, 58): faila=3D 13(D)  failb=3D 58(D=
)  OK
[    4.761127] raid6test: test_disks(13, 59): faila=3D 13(D)  failb=3D 59(D=
)  OK
[    4.762002] raid6test: test_disks(13, 60): faila=3D 13(D)  failb=3D 60(D=
)  OK
[    4.762917] raid6test: test_disks(13, 61): faila=3D 13(D)  failb=3D 61(D=
)  OK
[    4.763831] raid6test: test_disks(13, 62): faila=3D 13(D)  failb=3D 62(P=
)  OK
[    4.764740] raid6test: test_disks(13, 63): faila=3D 13(D)  failb=3D 63(Q=
)  OK
[    4.765650] raid6test: test_disks(14, 15): faila=3D 14(D)  failb=3D 15(D=
)  OK
[    4.766566] raid6test: test_disks(14, 16): faila=3D 14(D)  failb=3D 16(D=
)  OK
[    4.767470] raid6test: test_disks(14, 17): faila=3D 14(D)  failb=3D 17(D=
)  OK
[    4.768393] raid6test: test_disks(14, 18): faila=3D 14(D)  failb=3D 18(D=
)  OK
[    4.769308] raid6test: test_disks(14, 19): faila=3D 14(D)  failb=3D 19(D=
)  OK
[    4.770223] raid6test: test_disks(14, 20): faila=3D 14(D)  failb=3D 20(D=
)  OK
[    4.771134] raid6test: test_disks(14, 21): faila=3D 14(D)  failb=3D 21(D=
)  OK
[    4.772045] raid6test: test_disks(14, 22): faila=3D 14(D)  failb=3D 22(D=
)  OK
[    4.772911] raid6test: test_disks(14, 23): faila=3D 14(D)  failb=3D 23(D=
)  OK
[    4.773821] raid6test: test_disks(14, 24): faila=3D 14(D)  failb=3D 24(D=
)  OK
[    4.774738] raid6test: test_disks(14, 25): faila=3D 14(D)  failb=3D 25(D=
)  OK
[    4.775650] raid6test: test_disks(14, 26): faila=3D 14(D)  failb=3D 26(D=
)  OK
[    4.776559] raid6test: test_disks(14, 27): faila=3D 14(D)  failb=3D 27(D=
)  OK
[    4.777461] raid6test: test_disks(14, 28): faila=3D 14(D)  failb=3D 28(D=
)  OK
[    4.778408] raid6test: test_disks(14, 29): faila=3D 14(D)  failb=3D 29(D=
)  OK
[    4.779319] raid6test: test_disks(14, 30): faila=3D 14(D)  failb=3D 30(D=
)  OK
[    4.780223] raid6test: test_disks(14, 31): faila=3D 14(D)  failb=3D 31(D=
)  OK
[    4.781129] raid6test: test_disks(14, 32): faila=3D 14(D)  failb=3D 32(D=
)  OK
[    4.781997] raid6test: test_disks(14, 33): faila=3D 14(D)  failb=3D 33(D=
)  OK
[    4.782915] raid6test: test_disks(14, 34): faila=3D 14(D)  failb=3D 34(D=
)  OK
[    4.783832] raid6test: test_disks(14, 35): faila=3D 14(D)  failb=3D 35(D=
)  OK
[    4.784740] raid6test: test_disks(14, 36): faila=3D 14(D)  failb=3D 36(D=
)  OK
[    4.785650] raid6test: test_disks(14, 37): faila=3D 14(D)  failb=3D 37(D=
)  OK
[    4.786564] raid6test: test_disks(14, 38): faila=3D 14(D)  failb=3D 38(D=
)  OK
[    4.787465] raid6test: test_disks(14, 39): faila=3D 14(D)  failb=3D 39(D=
)  OK
[    4.788384] raid6test: test_disks(14, 40): faila=3D 14(D)  failb=3D 40(D=
)  OK
[    4.789292] raid6test: test_disks(14, 41): faila=3D 14(D)  failb=3D 41(D=
)  OK
[    4.790199] raid6test: test_disks(14, 42): faila=3D 14(D)  failb=3D 42(D=
)  OK
[    4.791114] raid6test: test_disks(14, 43): faila=3D 14(D)  failb=3D 43(D=
)  OK
[    4.791986] raid6test: test_disks(14, 44): faila=3D 14(D)  failb=3D 44(D=
)  OK
[    4.792899] raid6test: test_disks(14, 45): faila=3D 14(D)  failb=3D 45(D=
)  OK
[    4.793812] raid6test: test_disks(14, 46): faila=3D 14(D)  failb=3D 46(D=
)  OK
[    4.794721] raid6test: test_disks(14, 47): faila=3D 14(D)  failb=3D 47(D=
)  OK
[    4.795623] raid6test: test_disks(14, 48): faila=3D 14(D)  failb=3D 48(D=
)  OK
[    4.796530] raid6test: test_disks(14, 49): faila=3D 14(D)  failb=3D 49(D=
)  OK
[    4.797439] raid6test: test_disks(14, 50): faila=3D 14(D)  failb=3D 50(D=
)  OK
[    4.798372] raid6test: test_disks(14, 51): faila=3D 14(D)  failb=3D 51(D=
)  OK
[    4.799278] raid6test: test_disks(14, 52): faila=3D 14(D)  failb=3D 52(D=
)  OK
[    4.800189] raid6test: test_disks(14, 53): faila=3D 14(D)  failb=3D 53(D=
)  OK
[    4.801093] raid6test: test_disks(14, 54): faila=3D 14(D)  failb=3D 54(D=
)  OK
[    4.801964] raid6test: test_disks(14, 55): faila=3D 14(D)  failb=3D 55(D=
)  OK
[    4.802884] raid6test: test_disks(14, 56): faila=3D 14(D)  failb=3D 56(D=
)  OK
[    4.803795] raid6test: test_disks(14, 57): faila=3D 14(D)  failb=3D 57(D=
)  OK
[    4.804707] raid6test: test_disks(14, 58): faila=3D 14(D)  failb=3D 58(D=
)  OK
[    4.805617] raid6test: test_disks(14, 59): faila=3D 14(D)  failb=3D 59(D=
)  OK
[    4.806523] raid6test: test_disks(14, 60): faila=3D 14(D)  failb=3D 60(D=
)  OK
[    4.807438] raid6test: test_disks(14, 61): faila=3D 14(D)  failb=3D 61(D=
)  OK
[    4.808368] raid6test: test_disks(14, 62): faila=3D 14(D)  failb=3D 62(P=
)  OK
[    4.809271] raid6test: test_disks(14, 63): faila=3D 14(D)  failb=3D 63(Q=
)  OK
[    4.810174] raid6test: test_disks(15, 16): faila=3D 15(D)  failb=3D 16(D=
)  OK
[    4.811086] raid6test: test_disks(15, 17): faila=3D 15(D)  failb=3D 17(D=
)  OK
[    4.811961] raid6test: test_disks(15, 18): faila=3D 15(D)  failb=3D 18(D=
)  OK
[    4.812868] raid6test: test_disks(15, 19): faila=3D 15(D)  failb=3D 19(D=
)  OK
[    4.813780] raid6test: test_disks(15, 20): faila=3D 15(D)  failb=3D 20(D=
)  OK
[    4.814688] raid6test: test_disks(15, 21): faila=3D 15(D)  failb=3D 21(D=
)  OK
[    4.815600] raid6test: test_disks(15, 22): faila=3D 15(D)  failb=3D 22(D=
)  OK
[    4.816501] raid6test: test_disks(15, 23): faila=3D 15(D)  failb=3D 23(D=
)  OK
[    4.817428] raid6test: test_disks(15, 24): faila=3D 15(D)  failb=3D 24(D=
)  OK
[    4.818366] raid6test: test_disks(15, 25): faila=3D 15(D)  failb=3D 25(D=
)  OK
[    4.819270] raid6test: test_disks(15, 26): faila=3D 15(D)  failb=3D 26(D=
)  OK
[    4.820173] raid6test: test_disks(15, 27): faila=3D 15(D)  failb=3D 27(D=
)  OK
[    4.821083] raid6test: test_disks(15, 28): faila=3D 15(D)  failb=3D 28(D=
)  OK
[    4.821954] raid6test: test_disks(15, 29): faila=3D 15(D)  failb=3D 29(D=
)  OK
[    4.822867] raid6test: test_disks(15, 30): faila=3D 15(D)  failb=3D 30(D=
)  OK
[    4.823783] raid6test: test_disks(15, 31): faila=3D 15(D)  failb=3D 31(D=
)  OK
[    4.824692] raid6test: test_disks(15, 32): faila=3D 15(D)  failb=3D 32(D=
)  OK
[    4.825600] raid6test: test_disks(15, 33): faila=3D 15(D)  failb=3D 33(D=
)  OK
[    4.826504] raid6test: test_disks(15, 34): faila=3D 15(D)  failb=3D 34(D=
)  OK
[    4.827415] raid6test: test_disks(15, 35): faila=3D 15(D)  failb=3D 35(D=
)  OK
[    4.828352] raid6test: test_disks(15, 36): faila=3D 15(D)  failb=3D 36(D=
)  OK
[    4.829261] raid6test: test_disks(15, 37): faila=3D 15(D)  failb=3D 37(D=
)  OK
[    4.830163] raid6test: test_disks(15, 38): faila=3D 15(D)  failb=3D 38(D=
)  OK
[    4.831069] raid6test: test_disks(15, 39): faila=3D 15(D)  failb=3D 39(D=
)  OK
[    4.832153] raid6test: test_disks(15, 40): faila=3D 15(D)  failb=3D 40(D=
)  OK
[    4.833138] raid6test: test_disks(15, 41): faila=3D 15(D)  failb=3D 41(D=
)  OK
[    4.834047] raid6test: test_disks(15, 42): faila=3D 15(D)  failb=3D 42(D=
)  OK
[    4.834933] raid6test: test_disks(15, 43): faila=3D 15(D)  failb=3D 43(D=
)  OK
[    4.835866] raid6test: test_disks(15, 44): faila=3D 15(D)  failb=3D 44(D=
)  OK
[    4.836781] raid6test: test_disks(15, 45): faila=3D 15(D)  failb=3D 45(D=
)  OK
[    4.837713] raid6test: test_disks(15, 46): faila=3D 15(D)  failb=3D 46(D=
)  OK
[    4.838633] raid6test: test_disks(15, 47): faila=3D 15(D)  failb=3D 47(D=
)  OK
[    4.839545] raid6test: test_disks(15, 48): faila=3D 15(D)  failb=3D 48(D=
)  OK
[    4.840454] raid6test: test_disks(15, 49): faila=3D 15(D)  failb=3D 49(D=
)  OK
[    4.841367] raid6test: test_disks(15, 50): faila=3D 15(D)  failb=3D 50(D=
)  OK
[    4.842276] raid6test: test_disks(15, 51): faila=3D 15(D)  failb=3D 51(D=
)  OK
[    4.843190] raid6test: test_disks(15, 52): faila=3D 15(D)  failb=3D 52(D=
)  OK
[    4.844102] raid6test: test_disks(15, 53): faila=3D 15(D)  failb=3D 53(D=
)  OK
[    4.844979] raid6test: test_disks(15, 54): faila=3D 15(D)  failb=3D 54(D=
)  OK
[    4.845898] raid6test: test_disks(15, 55): faila=3D 15(D)  failb=3D 55(D=
)  OK
[    4.846819] raid6test: test_disks(15, 56): faila=3D 15(D)  failb=3D 56(D=
)  OK
[    4.847804] raid6test: test_disks(15, 57): faila=3D 15(D)  failb=3D 57(D=
)  OK
[    4.848785] raid6test: test_disks(15, 58): faila=3D 15(D)  failb=3D 58(D=
)  OK
[    4.849768] raid6test: test_disks(15, 59): faila=3D 15(D)  failb=3D 59(D=
)  OK
[    4.850738] raid6test: test_disks(15, 60): faila=3D 15(D)  failb=3D 60(D=
)  OK
[    4.851708] raid6test: test_disks(15, 61): faila=3D 15(D)  failb=3D 61(D=
)  OK
[    4.852672] raid6test: test_disks(15, 62): faila=3D 15(D)  failb=3D 62(P=
)  OK
[    4.853623] raid6test: test_disks(15, 63): faila=3D 15(D)  failb=3D 63(Q=
)  OK
[    4.854586] raid6test: test_disks(16, 17): faila=3D 16(D)  failb=3D 17(D=
)  OK
[    4.855554] raid6test: test_disks(16, 18): faila=3D 16(D)  failb=3D 18(D=
)  OK
[    4.856508] raid6test: test_disks(16, 19): faila=3D 16(D)  failb=3D 19(D=
)  OK
[    4.857462] raid6test: test_disks(16, 20): faila=3D 16(D)  failb=3D 20(D=
)  OK
[    4.858446] raid6test: test_disks(16, 21): faila=3D 16(D)  failb=3D 21(D=
)  OK
[    4.859365] raid6test: test_disks(16, 22): faila=3D 16(D)  failb=3D 22(D=
)  OK
[    4.860285] raid6test: test_disks(16, 23): faila=3D 16(D)  failb=3D 23(D=
)  OK
[    4.861229] raid6test: test_disks(16, 24): faila=3D 16(D)  failb=3D 24(D=
)  OK
[    4.862176] raid6test: test_disks(16, 25): faila=3D 16(D)  failb=3D 25(D=
)  OK
[    4.863090] raid6test: test_disks(16, 26): faila=3D 16(D)  failb=3D 26(D=
)  OK
[    4.863971] raid6test: test_disks(16, 27): faila=3D 16(D)  failb=3D 27(D=
)  OK
[    4.864902] raid6test: test_disks(16, 28): faila=3D 16(D)  failb=3D 28(D=
)  OK
[    4.865818] raid6test: test_disks(16, 29): faila=3D 16(D)  failb=3D 29(D=
)  OK
[    4.866754] raid6test: test_disks(16, 30): faila=3D 16(D)  failb=3D 30(D=
)  OK
[    4.867702] raid6test: test_disks(16, 31): faila=3D 16(D)  failb=3D 31(D=
)  OK
[    4.868627] raid6test: test_disks(16, 32): faila=3D 16(D)  failb=3D 32(D=
)  OK
[    4.869551] raid6test: test_disks(16, 33): faila=3D 16(D)  failb=3D 33(D=
)  OK
[    4.870470] raid6test: test_disks(16, 34): faila=3D 16(D)  failb=3D 34(D=
)  OK
[    4.871391] raid6test: test_disks(16, 35): faila=3D 16(D)  failb=3D 35(D=
)  OK
[    4.872311] raid6test: test_disks(16, 36): faila=3D 16(D)  failb=3D 36(D=
)  OK
[    4.873227] raid6test: test_disks(16, 37): faila=3D 16(D)  failb=3D 37(D=
)  OK
[    4.874141] raid6test: test_disks(16, 38): faila=3D 16(D)  failb=3D 38(D=
)  OK
[    4.875061] raid6test: test_disks(16, 39): faila=3D 16(D)  failb=3D 39(D=
)  OK
[    4.875937] raid6test: test_disks(16, 40): faila=3D 16(D)  failb=3D 40(D=
)  OK
[    4.876873] raid6test: test_disks(16, 41): faila=3D 16(D)  failb=3D 41(D=
)  OK
[    4.877812] raid6test: test_disks(16, 42): faila=3D 16(D)  failb=3D 42(D=
)  OK
[    4.878723] raid6test: test_disks(16, 43): faila=3D 16(D)  failb=3D 43(D=
)  OK
[    4.879651] raid6test: test_disks(16, 44): faila=3D 16(D)  failb=3D 44(D=
)  OK
[    4.880567] raid6test: test_disks(16, 45): faila=3D 16(D)  failb=3D 45(D=
)  OK
[    4.881620] raid6test: test_disks(16, 46): faila=3D 16(D)  failb=3D 46(D=
)  OK
[    4.883160] raid6test: test_disks(16, 47): faila=3D 16(D)  failb=3D 47(D=
)  OK
[    4.884359] raid6test: test_disks(16, 48): faila=3D 16(D)  failb=3D 48(D=
)  OK
[    4.885300] raid6test: test_disks(16, 49): faila=3D 16(D)  failb=3D 49(D=
)  OK
[    4.886218] raid6test: test_disks(16, 50): faila=3D 16(D)  failb=3D 50(D=
)  OK
[    4.887123] raid6test: test_disks(16, 51): faila=3D 16(D)  failb=3D 51(D=
)  OK
[    4.888064] raid6test: test_disks(16, 52): faila=3D 16(D)  failb=3D 52(D=
)  OK
[    4.888938] raid6test: test_disks(16, 53): faila=3D 16(D)  failb=3D 53(D=
)  OK
[    4.889854] raid6test: test_disks(16, 54): faila=3D 16(D)  failb=3D 54(D=
)  OK
[    4.890771] raid6test: test_disks(16, 55): faila=3D 16(D)  failb=3D 55(D=
)  OK
[    4.891688] raid6test: test_disks(16, 56): faila=3D 16(D)  failb=3D 56(D=
)  OK
[    4.892666] raid6test: test_disks(16, 57): faila=3D 16(D)  failb=3D 57(D=
)  OK
[    4.893580] raid6test: test_disks(16, 58): faila=3D 16(D)  failb=3D 58(D=
)  OK
[    4.894558] raid6test: test_disks(16, 59): faila=3D 16(D)  failb=3D 59(D=
)  OK
[    4.895726] raid6test: test_disks(16, 60): faila=3D 16(D)  failb=3D 60(D=
)  OK
[    4.896978] raid6test: test_disks(16, 61): faila=3D 16(D)  failb=3D 61(D=
)  OK
[    4.898094] raid6test: test_disks(16, 62): faila=3D 16(D)  failb=3D 62(P=
)  OK
[    4.898968] raid6test: test_disks(16, 63): faila=3D 16(D)  failb=3D 63(Q=
)  OK
[    4.899890] raid6test: test_disks(17, 18): faila=3D 17(D)  failb=3D 18(D=
)  OK
[    4.900814] raid6test: test_disks(17, 19): faila=3D 17(D)  failb=3D 19(D=
)  OK
[    4.901739] raid6test: test_disks(17, 20): faila=3D 17(D)  failb=3D 20(D=
)  OK
[    4.902657] raid6test: test_disks(17, 21): faila=3D 17(D)  failb=3D 21(D=
)  OK
[    4.903578] raid6test: test_disks(17, 22): faila=3D 17(D)  failb=3D 22(D=
)  OK
[    4.904485] raid6test: test_disks(17, 23): faila=3D 17(D)  failb=3D 23(D=
)  OK
[    4.905401] raid6test: test_disks(17, 24): faila=3D 17(D)  failb=3D 24(D=
)  OK
[    4.906312] raid6test: test_disks(17, 25): faila=3D 17(D)  failb=3D 25(D=
)  OK
[    4.907226] raid6test: test_disks(17, 26): faila=3D 17(D)  failb=3D 26(D=
)  OK
[    4.908171] raid6test: test_disks(17, 27): faila=3D 17(D)  failb=3D 27(D=
)  OK
[    4.909092] raid6test: test_disks(17, 28): faila=3D 17(D)  failb=3D 28(D=
)  OK
[    4.909971] raid6test: test_disks(17, 29): faila=3D 17(D)  failb=3D 29(D=
)  OK
[    4.910895] raid6test: test_disks(17, 30): faila=3D 17(D)  failb=3D 30(D=
)  OK
[    4.911839] raid6test: test_disks(17, 31): faila=3D 17(D)  failb=3D 31(D=
)  OK
[    4.913120] raid6test: test_disks(17, 32): faila=3D 17(D)  failb=3D 32(D=
)  OK
[    4.914251] raid6test: test_disks(17, 33): faila=3D 17(D)  failb=3D 33(D=
)  OK
[    4.915164] raid6test: test_disks(17, 34): faila=3D 17(D)  failb=3D 34(D=
)  OK
[    4.916080] raid6test: test_disks(17, 35): faila=3D 17(D)  failb=3D 35(D=
)  OK
[    4.916966] raid6test: test_disks(17, 36): faila=3D 17(D)  failb=3D 36(D=
)  OK
[    4.917978] raid6test: test_disks(17, 37): faila=3D 17(D)  failb=3D 37(D=
)  OK
[    4.918895] raid6test: test_disks(17, 38): faila=3D 17(D)  failb=3D 38(D=
)  OK
[    4.919810] raid6test: test_disks(17, 39): faila=3D 17(D)  failb=3D 39(D=
)  OK
[    4.920727] raid6test: test_disks(17, 40): faila=3D 17(D)  failb=3D 40(D=
)  OK
[    4.921643] raid6test: test_disks(17, 41): faila=3D 17(D)  failb=3D 41(D=
)  OK
[    4.922564] raid6test: test_disks(17, 42): faila=3D 17(D)  failb=3D 42(D=
)  OK
[    4.923469] raid6test: test_disks(17, 43): faila=3D 17(D)  failb=3D 43(D=
)  OK
[    4.924375] raid6test: test_disks(17, 44): faila=3D 17(D)  failb=3D 44(D=
)  OK
[    4.925286] raid6test: test_disks(17, 45): faila=3D 17(D)  failb=3D 45(D=
)  OK
[    4.926192] raid6test: test_disks(17, 46): faila=3D 17(D)  failb=3D 46(D=
)  OK
[    4.927100] raid6test: test_disks(17, 47): faila=3D 17(D)  failb=3D 47(D=
)  OK
[    4.928055] raid6test: test_disks(17, 48): faila=3D 17(D)  failb=3D 48(D=
)  OK
[    4.928929] raid6test: test_disks(17, 49): faila=3D 17(D)  failb=3D 49(D=
)  OK
[    4.929847] raid6test: test_disks(17, 50): faila=3D 17(D)  failb=3D 50(D=
)  OK
[    4.930765] raid6test: test_disks(17, 51): faila=3D 17(D)  failb=3D 51(D=
)  OK
[    4.931673] raid6test: test_disks(17, 52): faila=3D 17(D)  failb=3D 52(D=
)  OK
[    4.932594] raid6test: test_disks(17, 53): faila=3D 17(D)  failb=3D 53(D=
)  OK
[    4.933502] raid6test: test_disks(17, 54): faila=3D 17(D)  failb=3D 54(D=
)  OK
[    4.934405] raid6test: test_disks(17, 55): faila=3D 17(D)  failb=3D 55(D=
)  OK
[    4.935314] raid6test: test_disks(17, 56): faila=3D 17(D)  failb=3D 56(D=
)  OK
[    4.936219] raid6test: test_disks(17, 57): faila=3D 17(D)  failb=3D 57(D=
)  OK
[    4.937127] raid6test: test_disks(17, 58): faila=3D 17(D)  failb=3D 58(D=
)  OK
[    4.938081] raid6test: test_disks(17, 59): faila=3D 17(D)  failb=3D 59(D=
)  OK
[    4.938960] raid6test: test_disks(17, 60): faila=3D 17(D)  failb=3D 60(D=
)  OK
[    4.939879] raid6test: test_disks(17, 61): faila=3D 17(D)  failb=3D 61(D=
)  OK
[    4.940796] raid6test: test_disks(17, 62): faila=3D 17(D)  failb=3D 62(P=
)  OK
[    4.941711] raid6test: test_disks(17, 63): faila=3D 17(D)  failb=3D 63(Q=
)  OK
[    4.942630] raid6test: test_disks(18, 19): faila=3D 18(D)  failb=3D 19(D=
)  OK
[    4.943551] raid6test: test_disks(18, 20): faila=3D 18(D)  failb=3D 20(D=
)  OK
[    4.944456] raid6test: test_disks(18, 21): faila=3D 18(D)  failb=3D 21(D=
)  OK
[    4.945366] raid6test: test_disks(18, 22): faila=3D 18(D)  failb=3D 22(D=
)  OK
[    4.946273] raid6test: test_disks(18, 23): faila=3D 18(D)  failb=3D 23(D=
)  OK
[    4.947179] raid6test: test_disks(18, 24): faila=3D 18(D)  failb=3D 24(D=
)  OK
[    4.948123] raid6test: test_disks(18, 25): faila=3D 18(D)  failb=3D 25(D=
)  OK
[    4.948997] raid6test: test_disks(18, 26): faila=3D 18(D)  failb=3D 26(D=
)  OK
[    4.949908] raid6test: test_disks(18, 27): faila=3D 18(D)  failb=3D 27(D=
)  OK
[    4.950826] raid6test: test_disks(18, 28): faila=3D 18(D)  failb=3D 28(D=
)  OK
[    4.951745] raid6test: test_disks(18, 29): faila=3D 18(D)  failb=3D 29(D=
)  OK
[    4.952666] raid6test: test_disks(18, 30): faila=3D 18(D)  failb=3D 30(D=
)  OK
[    4.953588] raid6test: test_disks(18, 31): faila=3D 18(D)  failb=3D 31(D=
)  OK
[    4.954500] raid6test: test_disks(18, 32): faila=3D 18(D)  failb=3D 32(D=
)  OK
[    4.955406] raid6test: test_disks(18, 33): faila=3D 18(D)  failb=3D 33(D=
)  OK
[    4.956315] raid6test: test_disks(18, 34): faila=3D 18(D)  failb=3D 34(D=
)  OK
[    4.957226] raid6test: test_disks(18, 35): faila=3D 18(D)  failb=3D 35(D=
)  OK
[    4.958202] raid6test: test_disks(18, 36): faila=3D 18(D)  failb=3D 36(D=
)  OK
[    4.959117] raid6test: test_disks(18, 37): faila=3D 18(D)  failb=3D 37(D=
)  OK
[    4.959988] raid6test: test_disks(18, 38): faila=3D 18(D)  failb=3D 38(D=
)  OK
[    4.960903] raid6test: test_disks(18, 39): faila=3D 18(D)  failb=3D 39(D=
)  OK
[    4.961819] raid6test: test_disks(18, 40): faila=3D 18(D)  failb=3D 40(D=
)  OK
[    4.962727] raid6test: test_disks(18, 41): faila=3D 18(D)  failb=3D 41(D=
)  OK
[    4.963635] raid6test: test_disks(18, 42): faila=3D 18(D)  failb=3D 42(D=
)  OK
[    4.964544] raid6test: test_disks(18, 43): faila=3D 18(D)  failb=3D 43(D=
)  OK
[    4.965452] raid6test: test_disks(18, 44): faila=3D 18(D)  failb=3D 44(D=
)  OK
[    4.966367] raid6test: test_disks(18, 45): faila=3D 18(D)  failb=3D 45(D=
)  OK
[    4.967276] raid6test: test_disks(18, 46): faila=3D 18(D)  failb=3D 46(D=
)  OK
[    4.968204] raid6test: test_disks(18, 47): faila=3D 18(D)  failb=3D 47(D=
)  OK
[    4.969114] raid6test: test_disks(18, 48): faila=3D 18(D)  failb=3D 48(D=
)  OK
[    4.969985] raid6test: test_disks(18, 49): faila=3D 18(D)  failb=3D 49(D=
)  OK
[    4.970898] raid6test: test_disks(18, 50): faila=3D 18(D)  failb=3D 50(D=
)  OK
[    4.971812] raid6test: test_disks(18, 51): faila=3D 18(D)  failb=3D 51(D=
)  OK
[    4.972727] raid6test: test_disks(18, 52): faila=3D 18(D)  failb=3D 52(D=
)  OK
[    4.973638] raid6test: test_disks(18, 53): faila=3D 18(D)  failb=3D 53(D=
)  OK
[    4.974550] raid6test: test_disks(18, 54): faila=3D 18(D)  failb=3D 54(D=
)  OK
[    4.975457] raid6test: test_disks(18, 55): faila=3D 18(D)  failb=3D 55(D=
)  OK
[    4.976365] raid6test: test_disks(18, 56): faila=3D 18(D)  failb=3D 56(D=
)  OK
[    4.977280] raid6test: test_disks(18, 57): faila=3D 18(D)  failb=3D 57(D=
)  OK
[    4.978199] raid6test: test_disks(18, 58): faila=3D 18(D)  failb=3D 58(D=
)  OK
[    4.979113] raid6test: test_disks(18, 59): faila=3D 18(D)  failb=3D 59(D=
)  OK
[    4.979983] raid6test: test_disks(18, 60): faila=3D 18(D)  failb=3D 60(D=
)  OK
[    4.980895] raid6test: test_disks(18, 61): faila=3D 18(D)  failb=3D 61(D=
)  OK
[    4.981803] raid6test: test_disks(18, 62): faila=3D 18(D)  failb=3D 62(P=
)  OK
[    4.982711] raid6test: test_disks(18, 63): faila=3D 18(D)  failb=3D 63(Q=
)  OK
[    4.983628] raid6test: test_disks(19, 20): faila=3D 19(D)  failb=3D 20(D=
)  OK
[    4.984542] raid6test: test_disks(19, 21): faila=3D 19(D)  failb=3D 21(D=
)  OK
[    4.985445] raid6test: test_disks(19, 22): faila=3D 19(D)  failb=3D 22(D=
)  OK
[    4.986350] raid6test: test_disks(19, 23): faila=3D 19(D)  failb=3D 23(D=
)  OK
[    4.987257] raid6test: test_disks(19, 24): faila=3D 19(D)  failb=3D 24(D=
)  OK
[    4.988178] raid6test: test_disks(19, 25): faila=3D 19(D)  failb=3D 25(D=
)  OK
[    4.989087] raid6test: test_disks(19, 26): faila=3D 19(D)  failb=3D 26(D=
)  OK
[    4.989956] raid6test: test_disks(19, 27): faila=3D 19(D)  failb=3D 27(D=
)  OK
[    4.990867] raid6test: test_disks(19, 28): faila=3D 19(D)  failb=3D 28(D=
)  OK
[    4.991785] raid6test: test_disks(19, 29): faila=3D 19(D)  failb=3D 29(D=
)  OK
[    4.992697] raid6test: test_disks(19, 30): faila=3D 19(D)  failb=3D 30(D=
)  OK
[    4.993609] raid6test: test_disks(19, 31): faila=3D 19(D)  failb=3D 31(D=
)  OK
[    4.994514] raid6test: test_disks(19, 32): faila=3D 19(D)  failb=3D 32(D=
)  OK
[    4.995425] raid6test: test_disks(19, 33): faila=3D 19(D)  failb=3D 33(D=
)  OK
[    4.996336] raid6test: test_disks(19, 34): faila=3D 19(D)  failb=3D 34(D=
)  OK
[    4.997243] raid6test: test_disks(19, 35): faila=3D 19(D)  failb=3D 35(D=
)  OK
[    4.998187] raid6test: test_disks(19, 36): faila=3D 19(D)  failb=3D 36(D=
)  OK
[    4.999102] raid6test: test_disks(19, 37): faila=3D 19(D)  failb=3D 37(D=
)  OK
[    4.999975] raid6test: test_disks(19, 38): faila=3D 19(D)  failb=3D 38(D=
)  OK
[    5.000950] raid6test: test_disks(19, 39): faila=3D 19(D)  failb=3D 39(D=
)  OK
[    5.001897] raid6test: test_disks(19, 40): faila=3D 19(D)  failb=3D 40(D=
)  OK
[    5.002841] raid6test: test_disks(19, 41): faila=3D 19(D)  failb=3D 41(D=
)  OK
[    5.003756] raid6test: test_disks(19, 42): faila=3D 19(D)  failb=3D 42(D=
)  OK
[    5.004664] raid6test: test_disks(19, 43): faila=3D 19(D)  failb=3D 43(D=
)  OK
[    5.005578] raid6test: test_disks(19, 44): faila=3D 19(D)  failb=3D 44(D=
)  OK
[    5.006488] raid6test: test_disks(19, 45): faila=3D 19(D)  failb=3D 45(D=
)  OK
[    5.007398] raid6test: test_disks(19, 46): faila=3D 19(D)  failb=3D 46(D=
)  OK
[    5.008328] raid6test: test_disks(19, 47): faila=3D 19(D)  failb=3D 47(D=
)  OK
[    5.009238] raid6test: test_disks(19, 48): faila=3D 19(D)  failb=3D 48(D=
)  OK
[    5.010143] raid6test: test_disks(19, 49): faila=3D 19(D)  failb=3D 49(D=
)  OK
[    5.011055] raid6test: test_disks(19, 50): faila=3D 19(D)  failb=3D 50(D=
)  OK
[    5.011927] raid6test: test_disks(19, 51): faila=3D 19(D)  failb=3D 51(D=
)  OK
[    5.012845] raid6test: test_disks(19, 52): faila=3D 19(D)  failb=3D 52(D=
)  OK
[    5.013754] raid6test: test_disks(19, 53): faila=3D 19(D)  failb=3D 53(D=
)  OK
[    5.014659] raid6test: test_disks(19, 54): faila=3D 19(D)  failb=3D 54(D=
)  OK
[    5.015568] raid6test: test_disks(19, 55): faila=3D 19(D)  failb=3D 55(D=
)  OK
[    5.016475] raid6test: test_disks(19, 56): faila=3D 19(D)  failb=3D 56(D=
)  OK
[    5.017394] raid6test: test_disks(19, 57): faila=3D 19(D)  failb=3D 57(D=
)  OK
[    5.018314] raid6test: test_disks(19, 58): faila=3D 19(D)  failb=3D 58(D=
)  OK
[    5.019223] raid6test: test_disks(19, 59): faila=3D 19(D)  failb=3D 59(D=
)  OK
[    5.020133] raid6test: test_disks(19, 60): faila=3D 19(D)  failb=3D 60(D=
)  OK
[    5.021041] raid6test: test_disks(19, 61): faila=3D 19(D)  failb=3D 61(D=
)  OK
[    5.021915] raid6test: test_disks(19, 62): faila=3D 19(D)  failb=3D 62(P=
)  OK
[    5.022821] raid6test: test_disks(19, 63): faila=3D 19(D)  failb=3D 63(Q=
)  OK
[    5.023729] raid6test: test_disks(20, 21): faila=3D 20(D)  failb=3D 21(D=
)  OK
[    5.024640] raid6test: test_disks(20, 22): faila=3D 20(D)  failb=3D 22(D=
)  OK
[    5.025545] raid6test: test_disks(20, 23): faila=3D 20(D)  failb=3D 23(D=
)  OK
[    5.026442] raid6test: test_disks(20, 24): faila=3D 20(D)  failb=3D 24(D=
)  OK
[    5.027353] raid6test: test_disks(20, 25): faila=3D 20(D)  failb=3D 25(D=
)  OK
[    5.028293] raid6test: test_disks(20, 26): faila=3D 20(D)  failb=3D 26(D=
)  OK
[    5.029196] raid6test: test_disks(20, 27): faila=3D 20(D)  failb=3D 27(D=
)  OK
[    5.030105] raid6test: test_disks(20, 28): faila=3D 20(D)  failb=3D 28(D=
)  OK
[    5.030979] raid6test: test_disks(20, 29): faila=3D 20(D)  failb=3D 29(D=
)  OK
[    5.031891] raid6test: test_disks(20, 30): faila=3D 20(D)  failb=3D 30(D=
)  OK
[    5.032805] raid6test: test_disks(20, 31): faila=3D 20(D)  failb=3D 31(D=
)  OK
[    5.033717] raid6test: test_disks(20, 32): faila=3D 20(D)  failb=3D 32(D=
)  OK
[    5.034624] raid6test: test_disks(20, 33): faila=3D 20(D)  failb=3D 33(D=
)  OK
[    5.035527] raid6test: test_disks(20, 34): faila=3D 20(D)  failb=3D 34(D=
)  OK
[    5.036444] raid6test: test_disks(20, 35): faila=3D 20(D)  failb=3D 35(D=
)  OK
[    5.037354] raid6test: test_disks(20, 36): faila=3D 20(D)  failb=3D 36(D=
)  OK
[    5.038276] raid6test: test_disks(20, 37): faila=3D 20(D)  failb=3D 37(D=
)  OK
[    5.039183] raid6test: test_disks(20, 38): faila=3D 20(D)  failb=3D 38(D=
)  OK
[    5.040092] raid6test: test_disks(20, 39): faila=3D 20(D)  failb=3D 39(D=
)  OK
[    5.040969] raid6test: test_disks(20, 40): faila=3D 20(D)  failb=3D 40(D=
)  OK
[    5.041879] raid6test: test_disks(20, 41): faila=3D 20(D)  failb=3D 41(D=
)  OK
[    5.042798] raid6test: test_disks(20, 42): faila=3D 20(D)  failb=3D 42(D=
)  OK
[    5.043707] raid6test: test_disks(20, 43): faila=3D 20(D)  failb=3D 43(D=
)  OK
[    5.044620] raid6test: test_disks(20, 44): faila=3D 20(D)  failb=3D 44(D=
)  OK
[    5.045526] raid6test: test_disks(20, 45): faila=3D 20(D)  failb=3D 45(D=
)  OK
[    5.046440] raid6test: test_disks(20, 46): faila=3D 20(D)  failb=3D 46(D=
)  OK
[    5.047355] raid6test: test_disks(20, 47): faila=3D 20(D)  failb=3D 47(D=
)  OK
[    5.048271] raid6test: test_disks(20, 48): faila=3D 20(D)  failb=3D 48(D=
)  OK
[    5.049175] raid6test: test_disks(20, 49): faila=3D 20(D)  failb=3D 49(D=
)  OK
[    5.050086] raid6test: test_disks(20, 50): faila=3D 20(D)  failb=3D 50(D=
)  OK
[    5.050958] raid6test: test_disks(20, 51): faila=3D 20(D)  failb=3D 51(D=
)  OK
[    5.051871] raid6test: test_disks(20, 52): faila=3D 20(D)  failb=3D 52(D=
)  OK
[    5.052784] raid6test: test_disks(20, 53): faila=3D 20(D)  failb=3D 53(D=
)  OK
[    5.053690] raid6test: test_disks(20, 54): faila=3D 20(D)  failb=3D 54(D=
)  OK
[    5.054599] raid6test: test_disks(20, 55): faila=3D 20(D)  failb=3D 55(D=
)  OK
[    5.055504] raid6test: test_disks(20, 56): faila=3D 20(D)  failb=3D 56(D=
)  OK
[    5.056412] raid6test: test_disks(20, 57): faila=3D 20(D)  failb=3D 57(D=
)  OK
[    5.057324] raid6test: test_disks(20, 58): faila=3D 20(D)  failb=3D 58(D=
)  OK
[    5.058240] raid6test: test_disks(20, 59): faila=3D 20(D)  failb=3D 59(D=
)  OK
[    5.059148] raid6test: test_disks(20, 60): faila=3D 20(D)  failb=3D 60(D=
)  OK
[    5.060057] raid6test: test_disks(20, 61): faila=3D 20(D)  failb=3D 61(D=
)  OK
[    5.060932] raid6test: test_disks(20, 62): faila=3D 20(D)  failb=3D 62(P=
)  OK
[    5.061842] raid6test: test_disks(20, 63): faila=3D 20(D)  failb=3D 63(Q=
)  OK
[    5.062756] raid6test: test_disks(21, 22): faila=3D 21(D)  failb=3D 22(D=
)  OK
[    5.063666] raid6test: test_disks(21, 23): faila=3D 21(D)  failb=3D 23(D=
)  OK
[    5.064576] raid6test: test_disks(21, 24): faila=3D 21(D)  failb=3D 24(D=
)  OK
[    5.065482] raid6test: test_disks(21, 25): faila=3D 21(D)  failb=3D 25(D=
)  OK
[    5.066393] raid6test: test_disks(21, 26): faila=3D 21(D)  failb=3D 26(D=
)  OK
[    5.067301] raid6test: test_disks(21, 27): faila=3D 21(D)  failb=3D 27(D=
)  OK
[    5.068221] raid6test: test_disks(21, 28): faila=3D 21(D)  failb=3D 28(D=
)  OK
[    5.069132] raid6test: test_disks(21, 29): faila=3D 21(D)  failb=3D 29(D=
)  OK
[    5.070040] raid6test: test_disks(21, 30): faila=3D 21(D)  failb=3D 30(D=
)  OK
[    5.070911] raid6test: test_disks(21, 31): faila=3D 21(D)  failb=3D 31(D=
)  OK
[    5.071827] raid6test: test_disks(21, 32): faila=3D 21(D)  failb=3D 32(D=
)  OK
[    5.072735] raid6test: test_disks(21, 33): faila=3D 21(D)  failb=3D 33(D=
)  OK
[    5.073647] raid6test: test_disks(21, 34): faila=3D 21(D)  failb=3D 34(D=
)  OK
[    5.074556] raid6test: test_disks(21, 35): faila=3D 21(D)  failb=3D 35(D=
)  OK
[    5.075460] raid6test: test_disks(21, 36): faila=3D 21(D)  failb=3D 36(D=
)  OK
[    5.076367] raid6test: test_disks(21, 37): faila=3D 21(D)  failb=3D 37(D=
)  OK
[    5.077276] raid6test: test_disks(21, 38): faila=3D 21(D)  failb=3D 38(D=
)  OK
[    5.078195] raid6test: test_disks(21, 39): faila=3D 21(D)  failb=3D 39(D=
)  OK
[    5.079105] raid6test: test_disks(21, 40): faila=3D 21(D)  failb=3D 40(D=
)  OK
[    5.079980] raid6test: test_disks(21, 41): faila=3D 21(D)  failb=3D 41(D=
)  OK
[    5.080889] raid6test: test_disks(21, 42): faila=3D 21(D)  failb=3D 42(D=
)  OK
[    5.081801] raid6test: test_disks(21, 43): faila=3D 21(D)  failb=3D 43(D=
)  OK
[    5.082707] raid6test: test_disks(21, 44): faila=3D 21(D)  failb=3D 44(D=
)  OK
[    5.083617] raid6test: test_disks(21, 45): faila=3D 21(D)  failb=3D 45(D=
)  OK
[    5.084523] raid6test: test_disks(21, 46): faila=3D 21(D)  failb=3D 46(D=
)  OK
[    5.085436] raid6test: test_disks(21, 47): faila=3D 21(D)  failb=3D 47(D=
)  OK
[    5.086341] raid6test: test_disks(21, 48): faila=3D 21(D)  failb=3D 48(D=
)  OK
[    5.087246] raid6test: test_disks(21, 49): faila=3D 21(D)  failb=3D 49(D=
)  OK
[    5.088166] raid6test: test_disks(21, 50): faila=3D 21(D)  failb=3D 50(D=
)  OK
[    5.089076] raid6test: test_disks(21, 51): faila=3D 21(D)  failb=3D 51(D=
)  OK
[    5.089950] raid6test: test_disks(21, 52): faila=3D 21(D)  failb=3D 52(D=
)  OK
[    5.090863] raid6test: test_disks(21, 53): faila=3D 21(D)  failb=3D 53(D=
)  OK
[    5.091771] raid6test: test_disks(21, 54): faila=3D 21(D)  failb=3D 54(D=
)  OK
[    5.092682] raid6test: test_disks(21, 55): faila=3D 21(D)  failb=3D 55(D=
)  OK
[    5.093592] raid6test: test_disks(21, 56): faila=3D 21(D)  failb=3D 56(D=
)  OK
[    5.094500] raid6test: test_disks(21, 57): faila=3D 21(D)  failb=3D 57(D=
)  OK
[    5.095412] raid6test: test_disks(21, 58): faila=3D 21(D)  failb=3D 58(D=
)  OK
[    5.096323] raid6test: test_disks(21, 59): faila=3D 21(D)  failb=3D 59(D=
)  OK
[    5.097233] raid6test: test_disks(21, 60): faila=3D 21(D)  failb=3D 60(D=
)  OK
[    5.098152] raid6test: test_disks(21, 61): faila=3D 21(D)  failb=3D 61(D=
)  OK
[    5.099058] raid6test: test_disks(21, 62): faila=3D 21(D)  failb=3D 62(P=
)  OK
[    5.099925] raid6test: test_disks(21, 63): faila=3D 21(D)  failb=3D 63(Q=
)  OK
[    5.100846] raid6test: test_disks(22, 23): faila=3D 22(D)  failb=3D 23(D=
)  OK
[    5.101758] raid6test: test_disks(22, 24): faila=3D 22(D)  failb=3D 24(D=
)  OK
[    5.102668] raid6test: test_disks(22, 25): faila=3D 22(D)  failb=3D 25(D=
)  OK
[    5.103587] raid6test: test_disks(22, 26): faila=3D 22(D)  failb=3D 26(D=
)  OK
[    5.104495] raid6test: test_disks(22, 27): faila=3D 22(D)  failb=3D 27(D=
)  OK
[    5.105404] raid6test: test_disks(22, 28): faila=3D 22(D)  failb=3D 28(D=
)  OK
[    5.106313] raid6test: test_disks(22, 29): faila=3D 22(D)  failb=3D 29(D=
)  OK
[    5.107220] raid6test: test_disks(22, 30): faila=3D 22(D)  failb=3D 30(D=
)  OK
[    5.108143] raid6test: test_disks(22, 31): faila=3D 22(D)  failb=3D 31(D=
)  OK
[    5.109056] raid6test: test_disks(22, 32): faila=3D 22(D)  failb=3D 32(D=
)  OK
[    5.109926] raid6test: test_disks(22, 33): faila=3D 22(D)  failb=3D 33(D=
)  OK
[    5.110842] raid6test: test_disks(22, 34): faila=3D 22(D)  failb=3D 34(D=
)  OK
[    5.111755] raid6test: test_disks(22, 35): faila=3D 22(D)  failb=3D 35(D=
)  OK
[    5.112662] raid6test: test_disks(22, 36): faila=3D 22(D)  failb=3D 36(D=
)  OK
[    5.113573] raid6test: test_disks(22, 37): faila=3D 22(D)  failb=3D 37(D=
)  OK
[    5.114822] raid6test: test_disks(22, 38): faila=3D 22(D)  failb=3D 38(D=
)  OK
[    5.115809] raid6test: test_disks(22, 39): faila=3D 22(D)  failb=3D 39(D=
)  OK
[    5.116726] raid6test: test_disks(22, 40): faila=3D 22(D)  failb=3D 40(D=
)  OK
[    5.117778] raid6test: test_disks(22, 41): faila=3D 22(D)  failb=3D 41(D=
)  OK
[    5.118694] raid6test: test_disks(22, 42): faila=3D 22(D)  failb=3D 42(D=
)  OK
[    5.119606] raid6test: test_disks(22, 43): faila=3D 22(D)  failb=3D 43(D=
)  OK
[    5.120607] raid6test: test_disks(22, 44): faila=3D 22(D)  failb=3D 44(D=
)  OK
[    5.121571] raid6test: test_disks(22, 45): faila=3D 22(D)  failb=3D 45(D=
)  OK
[    5.122479] raid6test: test_disks(22, 46): faila=3D 22(D)  failb=3D 46(D=
)  OK
[    5.123459] raid6test: test_disks(22, 47): faila=3D 22(D)  failb=3D 47(D=
)  OK
[    5.124550] raid6test: test_disks(22, 48): faila=3D 22(D)  failb=3D 48(D=
)  OK
[    5.125692] raid6test: test_disks(22, 49): faila=3D 22(D)  failb=3D 49(D=
)  OK
[    5.126752] raid6test: test_disks(22, 50): faila=3D 22(D)  failb=3D 50(D=
)  OK
[    5.127709] raid6test: test_disks(22, 51): faila=3D 22(D)  failb=3D 51(D=
)  OK
[    5.128776] raid6test: test_disks(22, 52): faila=3D 22(D)  failb=3D 52(D=
)  OK
[    5.129946] raid6test: test_disks(22, 53): faila=3D 22(D)  failb=3D 53(D=
)  OK
[    5.130978] raid6test: test_disks(22, 54): faila=3D 22(D)  failb=3D 54(D=
)  OK
[    5.131952] raid6test: test_disks(22, 55): faila=3D 22(D)  failb=3D 55(D=
)  OK
[    5.133077] raid6test: test_disks(22, 56): faila=3D 22(D)  failb=3D 56(D=
)  OK
[    5.133988] raid6test: test_disks(22, 57): faila=3D 22(D)  failb=3D 57(D=
)  OK
[    5.134902] raid6test: test_disks(22, 58): faila=3D 22(D)  failb=3D 58(D=
)  OK
[    5.135813] raid6test: test_disks(22, 59): faila=3D 22(D)  failb=3D 59(D=
)  OK
[    5.136732] raid6test: test_disks(22, 60): faila=3D 22(D)  failb=3D 60(D=
)  OK
[    5.137696] raid6test: test_disks(22, 61): faila=3D 22(D)  failb=3D 61(D=
)  OK
[    5.138609] raid6test: test_disks(22, 62): faila=3D 22(D)  failb=3D 62(P=
)  OK
[    5.139512] raid6test: test_disks(22, 63): faila=3D 22(D)  failb=3D 63(Q=
)  OK
[    5.140424] raid6test: test_disks(23, 24): faila=3D 23(D)  failb=3D 24(D=
)  OK
[    5.141365] raid6test: test_disks(23, 25): faila=3D 23(D)  failb=3D 25(D=
)  OK
[    5.142275] raid6test: test_disks(23, 26): faila=3D 23(D)  failb=3D 26(D=
)  OK
[    5.143179] raid6test: test_disks(23, 27): faila=3D 23(D)  failb=3D 27(D=
)  OK
[    5.144086] raid6test: test_disks(23, 28): faila=3D 23(D)  failb=3D 28(D=
)  OK
[    5.144959] raid6test: test_disks(23, 29): faila=3D 23(D)  failb=3D 29(D=
)  OK
[    5.145906] raid6test: test_disks(23, 30): faila=3D 23(D)  failb=3D 30(D=
)  OK
[    5.146815] raid6test: test_disks(23, 31): faila=3D 23(D)  failb=3D 31(D=
)  OK
[    5.147744] raid6test: test_disks(23, 32): faila=3D 23(D)  failb=3D 32(D=
)  OK
[    5.148655] raid6test: test_disks(23, 33): faila=3D 23(D)  failb=3D 33(D=
)  OK
[    5.149608] raid6test: test_disks(23, 34): faila=3D 23(D)  failb=3D 34(D=
)  OK
[    5.150512] raid6test: test_disks(23, 35): faila=3D 23(D)  failb=3D 35(D=
)  OK
[    5.151427] raid6test: test_disks(23, 36): faila=3D 23(D)  failb=3D 36(D=
)  OK
[    5.152333] raid6test: test_disks(23, 37): faila=3D 23(D)  failb=3D 37(D=
)  OK
[    5.153261] raid6test: test_disks(23, 38): faila=3D 23(D)  failb=3D 38(D=
)  OK
[    5.154175] raid6test: test_disks(23, 39): faila=3D 23(D)  failb=3D 39(D=
)  OK
[    5.155080] raid6test: test_disks(23, 40): faila=3D 23(D)  failb=3D 40(D=
)  OK
[    5.155953] raid6test: test_disks(23, 41): faila=3D 23(D)  failb=3D 41(D=
)  OK
[    5.156863] raid6test: test_disks(23, 42): faila=3D 23(D)  failb=3D 42(D=
)  OK
[    5.157837] raid6test: test_disks(23, 43): faila=3D 23(D)  failb=3D 43(D=
)  OK
[    5.158750] raid6test: test_disks(23, 44): faila=3D 23(D)  failb=3D 44(D=
)  OK
[    5.159658] raid6test: test_disks(23, 45): faila=3D 23(D)  failb=3D 45(D=
)  OK
[    5.160569] raid6test: test_disks(23, 46): faila=3D 23(D)  failb=3D 46(D=
)  OK
[    5.161512] raid6test: test_disks(23, 47): faila=3D 23(D)  failb=3D 47(D=
)  OK
[    5.162424] raid6test: test_disks(23, 48): faila=3D 23(D)  failb=3D 48(D=
)  OK
[    5.163333] raid6test: test_disks(23, 49): faila=3D 23(D)  failb=3D 49(D=
)  OK
[    5.164238] raid6test: test_disks(23, 50): faila=3D 23(D)  failb=3D 50(D=
)  OK
[    5.165148] raid6test: test_disks(23, 51): faila=3D 23(D)  failb=3D 51(D=
)  OK
[    5.166090] raid6test: test_disks(23, 52): faila=3D 23(D)  failb=3D 52(D=
)  OK
[    5.166963] raid6test: test_disks(23, 53): faila=3D 23(D)  failb=3D 53(D=
)  OK
[    5.167882] raid6test: test_disks(23, 54): faila=3D 23(D)  failb=3D 54(D=
)  OK
[    5.168794] raid6test: test_disks(23, 55): faila=3D 23(D)  failb=3D 55(D=
)  OK
[    5.169794] raid6test: test_disks(23, 56): faila=3D 23(D)  failb=3D 56(D=
)  OK
[    5.170703] raid6test: test_disks(23, 57): faila=3D 23(D)  failb=3D 57(D=
)  OK
[    5.171615] raid6test: test_disks(23, 58): faila=3D 23(D)  failb=3D 58(D=
)  OK
[    5.172516] raid6test: test_disks(23, 59): faila=3D 23(D)  failb=3D 59(D=
)  OK
[    5.173482] raid6test: test_disks(23, 60): faila=3D 23(D)  failb=3D 60(D=
)  OK
[    5.174410] raid6test: test_disks(23, 61): faila=3D 23(D)  failb=3D 61(D=
)  OK
[    5.175329] raid6test: test_disks(23, 62): faila=3D 23(D)  failb=3D 62(P=
)  OK
[    5.176231] raid6test: test_disks(23, 63): faila=3D 23(D)  failb=3D 63(Q=
)  OK
[    5.177150] raid6test: test_disks(24, 25): faila=3D 24(D)  failb=3D 25(D=
)  OK
[    5.178119] raid6test: test_disks(24, 26): faila=3D 24(D)  failb=3D 26(D=
)  OK
[    5.179040] raid6test: test_disks(24, 27): faila=3D 24(D)  failb=3D 27(D=
)  OK
[    5.179930] raid6test: test_disks(24, 28): faila=3D 24(D)  failb=3D 28(D=
)  OK
[    5.180857] raid6test: test_disks(24, 29): faila=3D 24(D)  failb=3D 29(D=
)  OK
[    5.181817] raid6test: test_disks(24, 30): faila=3D 24(D)  failb=3D 30(D=
)  OK
[    5.182748] raid6test: test_disks(24, 31): faila=3D 24(D)  failb=3D 31(D=
)  OK
[    5.183672] raid6test: test_disks(24, 32): faila=3D 24(D)  failb=3D 32(D=
)  OK
[    5.184602] raid6test: test_disks(24, 33): faila=3D 24(D)  failb=3D 33(D=
)  OK
[    5.185569] raid6test: test_disks(24, 34): faila=3D 24(D)  failb=3D 34(D=
)  OK
[    5.186495] raid6test: test_disks(24, 35): faila=3D 24(D)  failb=3D 35(D=
)  OK
[    5.187415] raid6test: test_disks(24, 36): faila=3D 24(D)  failb=3D 36(D=
)  OK
[    5.188362] raid6test: test_disks(24, 37): faila=3D 24(D)  failb=3D 37(D=
)  OK
[    5.189311] raid6test: test_disks(24, 38): faila=3D 24(D)  failb=3D 38(D=
)  OK
[    5.190226] raid6test: test_disks(24, 39): faila=3D 24(D)  failb=3D 39(D=
)  OK
[    5.191284] raid6test: test_disks(24, 40): faila=3D 24(D)  failb=3D 40(D=
)  OK
[    5.192207] raid6test: test_disks(24, 41): faila=3D 24(D)  failb=3D 41(D=
)  OK
[    5.193127] raid6test: test_disks(24, 42): faila=3D 24(D)  failb=3D 42(D=
)  OK
[    5.194080] raid6test: test_disks(24, 43): faila=3D 24(D)  failb=3D 43(D=
)  OK
[    5.194948] raid6test: test_disks(24, 44): faila=3D 24(D)  failb=3D 44(D=
)  OK
[    5.195860] raid6test: test_disks(24, 45): faila=3D 24(D)  failb=3D 45(D=
)  OK
[    5.196767] raid6test: test_disks(24, 46): faila=3D 24(D)  failb=3D 46(D=
)  OK
[    5.197723] raid6test: test_disks(24, 47): faila=3D 24(D)  failb=3D 47(D=
)  OK
[    5.198629] raid6test: test_disks(24, 48): faila=3D 24(D)  failb=3D 48(D=
)  OK
[    5.199540] raid6test: test_disks(24, 49): faila=3D 24(D)  failb=3D 49(D=
)  OK
[    5.200467] raid6test: test_disks(24, 50): faila=3D 24(D)  failb=3D 50(D=
)  OK
[    5.201406] raid6test: test_disks(24, 51): faila=3D 24(D)  failb=3D 51(D=
)  OK
[    5.202769] raid6test: test_disks(24, 52): faila=3D 24(D)  failb=3D 52(D=
)  OK
[    5.203684] raid6test: test_disks(24, 53): faila=3D 24(D)  failb=3D 53(D=
)  OK
[    5.204597] raid6test: test_disks(24, 54): faila=3D 24(D)  failb=3D 54(D=
)  OK
[    5.205555] raid6test: test_disks(24, 55): faila=3D 24(D)  failb=3D 55(D=
)  OK
[    5.206458] raid6test: test_disks(24, 56): faila=3D 24(D)  failb=3D 56(D=
)  OK
[    5.207373] raid6test: test_disks(24, 57): faila=3D 24(D)  failb=3D 57(D=
)  OK
[    5.208305] raid6test: test_disks(24, 58): faila=3D 24(D)  failb=3D 58(D=
)  OK
[    5.209219] raid6test: test_disks(24, 59): faila=3D 24(D)  failb=3D 59(D=
)  OK
[    5.210156] raid6test: test_disks(24, 60): faila=3D 24(D)  failb=3D 60(D=
)  OK
[    5.211097] raid6test: test_disks(24, 61): faila=3D 24(D)  failb=3D 61(D=
)  OK
[    5.211972] raid6test: test_disks(24, 62): faila=3D 24(D)  failb=3D 62(P=
)  OK
[    5.212887] raid6test: test_disks(24, 63): faila=3D 24(D)  failb=3D 63(Q=
)  OK
[    5.213841] raid6test: test_disks(25, 26): faila=3D 25(D)  failb=3D 26(D=
)  OK
[    5.214757] raid6test: test_disks(25, 27): faila=3D 25(D)  failb=3D 27(D=
)  OK
[    5.215657] raid6test: test_disks(25, 28): faila=3D 25(D)  failb=3D 28(D=
)  OK
[    5.216572] raid6test: test_disks(25, 29): faila=3D 25(D)  failb=3D 29(D=
)  OK
[    5.217556] raid6test: test_disks(25, 30): faila=3D 25(D)  failb=3D 30(D=
)  OK
[    5.218464] raid6test: test_disks(25, 31): faila=3D 25(D)  failb=3D 31(D=
)  OK
[    5.219378] raid6test: test_disks(25, 32): faila=3D 25(D)  failb=3D 32(D=
)  OK
[    5.220286] raid6test: test_disks(25, 33): faila=3D 25(D)  failb=3D 33(D=
)  OK
[    5.221216] raid6test: test_disks(25, 34): faila=3D 25(D)  failb=3D 34(D=
)  OK
[    5.222162] raid6test: test_disks(25, 35): faila=3D 25(D)  failb=3D 35(D=
)  OK
[    5.223077] raid6test: test_disks(25, 36): faila=3D 25(D)  failb=3D 36(D=
)  OK
[    5.223950] raid6test: test_disks(25, 37): faila=3D 25(D)  failb=3D 37(D=
)  OK
[    5.224866] raid6test: test_disks(25, 38): faila=3D 25(D)  failb=3D 38(D=
)  OK
[    5.225817] raid6test: test_disks(25, 39): faila=3D 25(D)  failb=3D 39(D=
)  OK
[    5.226729] raid6test: test_disks(25, 40): faila=3D 25(D)  failb=3D 40(D=
)  OK
[    5.227667] raid6test: test_disks(25, 41): faila=3D 25(D)  failb=3D 41(D=
)  OK
[    5.228581] raid6test: test_disks(25, 42): faila=3D 25(D)  failb=3D 42(D=
)  OK
[    5.229537] raid6test: test_disks(25, 43): faila=3D 25(D)  failb=3D 43(D=
)  OK
[    5.230461] raid6test: test_disks(25, 44): faila=3D 25(D)  failb=3D 44(D=
)  OK
[    5.231374] raid6test: test_disks(25, 45): faila=3D 25(D)  failb=3D 45(D=
)  OK
[    5.232286] raid6test: test_disks(25, 46): faila=3D 25(D)  failb=3D 46(D=
)  OK
[    5.233197] raid6test: test_disks(25, 47): faila=3D 25(D)  failb=3D 47(D=
)  OK
[    5.234250] raid6test: test_disks(25, 48): faila=3D 25(D)  failb=3D 48(D=
)  OK
[    5.235255] raid6test: test_disks(25, 49): faila=3D 25(D)  failb=3D 49(D=
)  OK
[    5.236162] raid6test: test_disks(25, 50): faila=3D 25(D)  failb=3D 50(D=
)  OK
[    5.237071] raid6test: test_disks(25, 51): faila=3D 25(D)  failb=3D 51(D=
)  OK
[    5.238071] raid6test: test_disks(25, 52): faila=3D 25(D)  failb=3D 52(D=
)  OK
[    5.238987] raid6test: test_disks(25, 53): faila=3D 25(D)  failb=3D 53(D=
)  OK
[    5.239932] raid6test: test_disks(25, 54): faila=3D 25(D)  failb=3D 54(D=
)  OK
[    5.240917] raid6test: test_disks(25, 55): faila=3D 25(D)  failb=3D 55(D=
)  OK
[    5.241895] raid6test: test_disks(25, 56): faila=3D 25(D)  failb=3D 56(D=
)  OK
[    5.243251] raid6test: test_disks(25, 57): faila=3D 25(D)  failb=3D 57(D=
)  OK
[    5.244835] raid6test: test_disks(25, 58): faila=3D 25(D)  failb=3D 58(D=
)  OK
[    5.246419] raid6test: test_disks(25, 59): faila=3D 25(D)  failb=3D 59(D=
)  OK
[    5.248095] raid6test: test_disks(25, 60): faila=3D 25(D)  failb=3D 60(D=
)  OK
[    5.249694] raid6test: test_disks(25, 61): faila=3D 25(D)  failb=3D 61(D=
)  OK
[    5.251283] raid6test: test_disks(25, 62): faila=3D 25(D)  failb=3D 62(P=
)  OK
[    5.252866] raid6test: test_disks(25, 63): faila=3D 25(D)  failb=3D 63(Q=
)  OK
[    5.253911] raid6test: test_disks(26, 27): faila=3D 26(D)  failb=3D 27(D=
)  OK
[    5.254920] raid6test: test_disks(26, 28): faila=3D 26(D)  failb=3D 28(D=
)  OK
[    5.255924] raid6test: test_disks(26, 29): faila=3D 26(D)  failb=3D 29(D=
)  OK
[    5.256923] raid6test: test_disks(26, 30): faila=3D 26(D)  failb=3D 30(D=
)  OK
[    5.257937] raid6test: test_disks(26, 31): faila=3D 26(D)  failb=3D 31(D=
)  OK
[    5.258934] raid6test: test_disks(26, 32): faila=3D 26(D)  failb=3D 32(D=
)  OK
[    5.259929] raid6test: test_disks(26, 33): faila=3D 26(D)  failb=3D 33(D=
)  OK
[    5.260927] raid6test: test_disks(26, 34): faila=3D 26(D)  failb=3D 34(D=
)  OK
[    5.261931] raid6test: test_disks(26, 35): faila=3D 26(D)  failb=3D 35(D=
)  OK
[    5.262931] raid6test: test_disks(26, 36): faila=3D 26(D)  failb=3D 36(D=
)  OK
[    5.263930] raid6test: test_disks(26, 37): faila=3D 26(D)  failb=3D 37(D=
)  OK
[    5.264927] raid6test: test_disks(26, 38): faila=3D 26(D)  failb=3D 38(D=
)  OK
[    5.265927] raid6test: test_disks(26, 39): faila=3D 26(D)  failb=3D 39(D=
)  OK
[    5.266922] raid6test: test_disks(26, 40): faila=3D 26(D)  failb=3D 40(D=
)  OK
[    5.267934] raid6test: test_disks(26, 41): faila=3D 26(D)  failb=3D 41(D=
)  OK
[    5.268932] raid6test: test_disks(26, 42): faila=3D 26(D)  failb=3D 42(D=
)  OK
[    5.269930] raid6test: test_disks(26, 43): faila=3D 26(D)  failb=3D 43(D=
)  OK
[    5.270931] raid6test: test_disks(26, 44): faila=3D 26(D)  failb=3D 44(D=
)  OK
[    5.271929] raid6test: test_disks(26, 45): faila=3D 26(D)  failb=3D 45(D=
)  OK
[    5.272926] raid6test: test_disks(26, 46): faila=3D 26(D)  failb=3D 46(D=
)  OK
[    5.273928] raid6test: test_disks(26, 47): faila=3D 26(D)  failb=3D 47(D=
)  OK
[    5.274927] raid6test: test_disks(26, 48): faila=3D 26(D)  failb=3D 48(D=
)  OK
[    5.275922] raid6test: test_disks(26, 49): faila=3D 26(D)  failb=3D 49(D=
)  OK
[    5.276920] raid6test: test_disks(26, 50): faila=3D 26(D)  failb=3D 50(D=
)  OK
[    5.277941] raid6test: test_disks(26, 51): faila=3D 26(D)  failb=3D 51(D=
)  OK
[    5.278937] raid6test: test_disks(26, 52): faila=3D 26(D)  failb=3D 52(D=
)  OK
[    5.279934] raid6test: test_disks(26, 53): faila=3D 26(D)  failb=3D 53(D=
)  OK
[    5.280929] raid6test: test_disks(26, 54): faila=3D 26(D)  failb=3D 54(D=
)  OK
[    5.281930] raid6test: test_disks(26, 55): faila=3D 26(D)  failb=3D 55(D=
)  OK
[    5.282928] raid6test: test_disks(26, 56): faila=3D 26(D)  failb=3D 56(D=
)  OK
[    5.283931] raid6test: test_disks(26, 57): faila=3D 26(D)  failb=3D 57(D=
)  OK
[    5.284931] raid6test: test_disks(26, 58): faila=3D 26(D)  failb=3D 58(D=
)  OK
[    5.285929] raid6test: test_disks(26, 59): faila=3D 26(D)  failb=3D 59(D=
)  OK
[    5.286929] raid6test: test_disks(26, 60): faila=3D 26(D)  failb=3D 60(D=
)  OK
[    5.287936] raid6test: test_disks(26, 61): faila=3D 26(D)  failb=3D 61(D=
)  OK
[    5.288928] raid6test: test_disks(26, 62): faila=3D 26(D)  failb=3D 62(P=
)  OK
[    5.289930] raid6test: test_disks(26, 63): faila=3D 26(D)  failb=3D 63(Q=
)  OK
[    5.290926] raid6test: test_disks(27, 28): faila=3D 27(D)  failb=3D 28(D=
)  OK
[    5.291924] raid6test: test_disks(27, 29): faila=3D 27(D)  failb=3D 29(D=
)  OK
[    5.292923] raid6test: test_disks(27, 30): faila=3D 27(D)  failb=3D 30(D=
)  OK
[    5.293922] raid6test: test_disks(27, 31): faila=3D 27(D)  failb=3D 31(D=
)  OK
[    5.294920] raid6test: test_disks(27, 32): faila=3D 27(D)  failb=3D 32(D=
)  OK
[    5.295935] raid6test: test_disks(27, 33): faila=3D 27(D)  failb=3D 33(D=
)  OK
[    5.296930] raid6test: test_disks(27, 34): faila=3D 27(D)  failb=3D 34(D=
)  OK
[    5.297969] raid6test: test_disks(27, 35): faila=3D 27(D)  failb=3D 35(D=
)  OK
[    5.298981] raid6test: test_disks(27, 36): faila=3D 27(D)  failb=3D 36(D=
)  OK
[    5.299977] raid6test: test_disks(27, 37): faila=3D 27(D)  failb=3D 37(D=
)  OK
[    5.300976] raid6test: test_disks(27, 38): faila=3D 27(D)  failb=3D 38(D=
)  OK
[    5.301974] raid6test: test_disks(27, 39): faila=3D 27(D)  failb=3D 39(D=
)  OK
[    5.302975] raid6test: test_disks(27, 40): faila=3D 27(D)  failb=3D 40(D=
)  OK
[    5.303979] raid6test: test_disks(27, 41): faila=3D 27(D)  failb=3D 41(D=
)  OK
[    5.304979] raid6test: test_disks(27, 42): faila=3D 27(D)  failb=3D 42(D=
)  OK
[    5.305977] raid6test: test_disks(27, 43): faila=3D 27(D)  failb=3D 43(D=
)  OK
[    5.306977] raid6test: test_disks(27, 44): faila=3D 27(D)  failb=3D 44(D=
)  OK
[    5.307987] raid6test: test_disks(27, 45): faila=3D 27(D)  failb=3D 45(D=
)  OK
[    5.308983] raid6test: test_disks(27, 46): faila=3D 27(D)  failb=3D 46(D=
)  OK
[    5.309984] raid6test: test_disks(27, 47): faila=3D 27(D)  failb=3D 47(D=
)  OK
[    5.310985] raid6test: test_disks(27, 48): faila=3D 27(D)  failb=3D 48(D=
)  OK
[    5.311985] raid6test: test_disks(27, 49): faila=3D 27(D)  failb=3D 49(D=
)  OK
[    5.312985] raid6test: test_disks(27, 50): faila=3D 27(D)  failb=3D 50(D=
)  OK
[    5.313987] raid6test: test_disks(27, 51): faila=3D 27(D)  failb=3D 51(D=
)  OK
[    5.314985] raid6test: test_disks(27, 52): faila=3D 27(D)  failb=3D 52(D=
)  OK
[    5.315982] raid6test: test_disks(27, 53): faila=3D 27(D)  failb=3D 53(D=
)  OK
[    5.316978] raid6test: test_disks(27, 54): faila=3D 27(D)  failb=3D 54(D=
)  OK
[    5.317992] raid6test: test_disks(27, 55): faila=3D 27(D)  failb=3D 55(D=
)  OK
[    5.318985] raid6test: test_disks(27, 56): faila=3D 27(D)  failb=3D 56(D=
)  OK
[    5.319985] raid6test: test_disks(27, 57): faila=3D 27(D)  failb=3D 57(D=
)  OK
[    5.320984] raid6test: test_disks(27, 58): faila=3D 27(D)  failb=3D 58(D=
)  OK
[    5.321979] raid6test: test_disks(27, 59): faila=3D 27(D)  failb=3D 59(D=
)  OK
[    5.322981] raid6test: test_disks(27, 60): faila=3D 27(D)  failb=3D 60(D=
)  OK
[    5.323978] raid6test: test_disks(27, 61): faila=3D 27(D)  failb=3D 61(D=
)  OK
[    5.324976] raid6test: test_disks(27, 62): faila=3D 27(D)  failb=3D 62(P=
)  OK
[    5.325968] raid6test: test_disks(27, 63): faila=3D 27(D)  failb=3D 63(Q=
)  OK
[    5.326971] raid6test: test_disks(28, 29): faila=3D 28(D)  failb=3D 29(D=
)  OK
[    5.327989] raid6test: test_disks(28, 30): faila=3D 28(D)  failb=3D 30(D=
)  OK
[    5.328985] raid6test: test_disks(28, 31): faila=3D 28(D)  failb=3D 31(D=
)  OK
[    5.329982] raid6test: test_disks(28, 32): faila=3D 28(D)  failb=3D 32(D=
)  OK
[    5.330977] raid6test: test_disks(28, 33): faila=3D 28(D)  failb=3D 33(D=
)  OK
[    5.331978] raid6test: test_disks(28, 34): faila=3D 28(D)  failb=3D 34(D=
)  OK
[    5.332978] raid6test: test_disks(28, 35): faila=3D 28(D)  failb=3D 35(D=
)  OK
[    5.333976] raid6test: test_disks(28, 36): faila=3D 28(D)  failb=3D 36(D=
)  OK
[    5.334975] raid6test: test_disks(28, 37): faila=3D 28(D)  failb=3D 37(D=
)  OK
[    5.335992] raid6test: test_disks(28, 38): faila=3D 28(D)  failb=3D 38(D=
)  OK
[    5.336985] raid6test: test_disks(28, 39): faila=3D 28(D)  failb=3D 39(D=
)  OK
[    5.338001] raid6test: test_disks(28, 40): faila=3D 28(D)  failb=3D 40(D=
)  OK
[    5.338994] raid6test: test_disks(28, 41): faila=3D 28(D)  failb=3D 41(D=
)  OK
[    5.339986] raid6test: test_disks(28, 42): faila=3D 28(D)  failb=3D 42(D=
)  OK
[    5.340981] raid6test: test_disks(28, 43): faila=3D 28(D)  failb=3D 43(D=
)  OK
[    5.341980] raid6test: test_disks(28, 44): faila=3D 28(D)  failb=3D 44(D=
)  OK
[    5.342981] raid6test: test_disks(28, 45): faila=3D 28(D)  failb=3D 45(D=
)  OK
[    5.343980] raid6test: test_disks(28, 46): faila=3D 28(D)  failb=3D 46(D=
)  OK
[    5.344978] raid6test: test_disks(28, 47): faila=3D 28(D)  failb=3D 47(D=
)  OK
[    5.345977] raid6test: test_disks(28, 48): faila=3D 28(D)  failb=3D 48(D=
)  OK
[    5.346972] raid6test: test_disks(28, 49): faila=3D 28(D)  failb=3D 49(D=
)  OK
[    5.347980] raid6test: test_disks(28, 50): faila=3D 28(D)  failb=3D 50(D=
)  OK
[    5.348979] raid6test: test_disks(28, 51): faila=3D 28(D)  failb=3D 51(D=
)  OK
[    5.349980] raid6test: test_disks(28, 52): faila=3D 28(D)  failb=3D 52(D=
)  OK
[    5.350982] raid6test: test_disks(28, 53): faila=3D 28(D)  failb=3D 53(D=
)  OK
[    5.351979] raid6test: test_disks(28, 54): faila=3D 28(D)  failb=3D 54(D=
)  OK
[    5.352972] raid6test: test_disks(28, 55): faila=3D 28(D)  failb=3D 55(D=
)  OK
[    5.353971] raid6test: test_disks(28, 56): faila=3D 28(D)  failb=3D 56(D=
)  OK
[    5.354964] raid6test: test_disks(28, 57): faila=3D 28(D)  failb=3D 57(D=
)  OK
[    5.355963] raid6test: test_disks(28, 58): faila=3D 28(D)  failb=3D 58(D=
)  OK
[    5.357441] raid6test: test_disks(28, 59): faila=3D 28(D)  failb=3D 59(D=
)  OK
[    5.358443] raid6test: test_disks(28, 60): faila=3D 28(D)  failb=3D 60(D=
)  OK
[    5.359440] raid6test: test_disks(28, 61): faila=3D 28(D)  failb=3D 61(D=
)  OK
[    5.360433] raid6test: test_disks(28, 62): faila=3D 28(D)  failb=3D 62(P=
)  OK
[    5.361429] raid6test: test_disks(28, 63): faila=3D 28(D)  failb=3D 63(Q=
)  OK
[    5.362429] raid6test: test_disks(29, 30): faila=3D 29(D)  failb=3D 30(D=
)  OK
[    5.363437] raid6test: test_disks(29, 31): faila=3D 29(D)  failb=3D 31(D=
)  OK
[    5.364440] raid6test: test_disks(29, 32): faila=3D 29(D)  failb=3D 32(D=
)  OK
[    5.365443] raid6test: test_disks(29, 33): faila=3D 29(D)  failb=3D 33(D=
)  OK
[    5.366443] raid6test: test_disks(29, 34): faila=3D 29(D)  failb=3D 34(D=
)  OK
[    5.367452] raid6test: test_disks(29, 35): faila=3D 29(D)  failb=3D 35(D=
)  OK
[    5.368472] raid6test: test_disks(29, 36): faila=3D 29(D)  failb=3D 36(D=
)  OK
[    5.369479] raid6test: test_disks(29, 37): faila=3D 29(D)  failb=3D 37(D=
)  OK
[    5.370477] raid6test: test_disks(29, 38): faila=3D 29(D)  failb=3D 38(D=
)  OK
[    5.371479] raid6test: test_disks(29, 39): faila=3D 29(D)  failb=3D 39(D=
)  OK
[    5.372480] raid6test: test_disks(29, 40): faila=3D 29(D)  failb=3D 40(D=
)  OK
[    5.373489] raid6test: test_disks(29, 41): faila=3D 29(D)  failb=3D 41(D=
)  OK
[    5.374494] raid6test: test_disks(29, 42): faila=3D 29(D)  failb=3D 42(D=
)  OK
[    5.375498] raid6test: test_disks(29, 43): faila=3D 29(D)  failb=3D 43(D=
)  OK
[    5.376503] raid6test: test_disks(29, 44): faila=3D 29(D)  failb=3D 44(D=
)  OK
[    5.377512] raid6test: test_disks(29, 45): faila=3D 29(D)  failb=3D 45(D=
)  OK
[    5.378553] raid6test: test_disks(29, 46): faila=3D 29(D)  failb=3D 46(D=
)  OK
[    5.379560] raid6test: test_disks(29, 47): faila=3D 29(D)  failb=3D 47(D=
)  OK
[    5.380558] raid6test: test_disks(29, 48): faila=3D 29(D)  failb=3D 48(D=
)  OK
[    5.381564] raid6test: test_disks(29, 49): faila=3D 29(D)  failb=3D 49(D=
)  OK
[    5.382571] raid6test: test_disks(29, 50): faila=3D 29(D)  failb=3D 50(D=
)  OK
[    5.383581] raid6test: test_disks(29, 51): faila=3D 29(D)  failb=3D 51(D=
)  OK
[    5.384583] raid6test: test_disks(29, 52): faila=3D 29(D)  failb=3D 52(D=
)  OK
[    5.385593] raid6test: test_disks(29, 53): faila=3D 29(D)  failb=3D 53(D=
)  OK
[    5.386596] raid6test: test_disks(29, 54): faila=3D 29(D)  failb=3D 54(D=
)  OK
[    5.387629] raid6test: test_disks(29, 55): faila=3D 29(D)  failb=3D 55(D=
)  OK
[    5.388641] raid6test: test_disks(29, 56): faila=3D 29(D)  failb=3D 56(D=
)  OK
[    5.389648] raid6test: test_disks(29, 57): faila=3D 29(D)  failb=3D 57(D=
)  OK
[    5.390651] raid6test: test_disks(29, 58): faila=3D 29(D)  failb=3D 58(D=
)  OK
[    5.391653] raid6test: test_disks(29, 59): faila=3D 29(D)  failb=3D 59(D=
)  OK
[    5.392662] raid6test: test_disks(29, 60): faila=3D 29(D)  failb=3D 60(D=
)  OK
[    5.393663] raid6test: test_disks(29, 61): faila=3D 29(D)  failb=3D 61(D=
)  OK
[    5.394655] raid6test: test_disks(29, 62): faila=3D 29(D)  failb=3D 62(P=
)  OK
[    5.395676] raid6test: test_disks(29, 63): faila=3D 29(D)  failb=3D 63(Q=
)  OK
[    5.396673] raid6test: test_disks(30, 31): faila=3D 30(D)  failb=3D 31(D=
)  OK
[    5.397681] raid6test: test_disks(30, 32): faila=3D 30(D)  failb=3D 32(D=
)  OK
[    5.398698] raid6test: test_disks(30, 33): faila=3D 30(D)  failb=3D 33(D=
)  OK
[    5.399706] raid6test: test_disks(30, 34): faila=3D 30(D)  failb=3D 34(D=
)  OK
[    5.400709] raid6test: test_disks(30, 35): faila=3D 30(D)  failb=3D 35(D=
)  OK
[    5.401714] raid6test: test_disks(30, 36): faila=3D 30(D)  failb=3D 36(D=
)  OK
[    5.402723] raid6test: test_disks(30, 37): faila=3D 30(D)  failb=3D 37(D=
)  OK
[    5.403728] raid6test: test_disks(30, 38): faila=3D 30(D)  failb=3D 38(D=
)  OK
[    5.404733] raid6test: test_disks(30, 39): faila=3D 30(D)  failb=3D 39(D=
)  OK
[    5.405744] raid6test: test_disks(30, 40): faila=3D 30(D)  failb=3D 40(D=
)  OK
[    5.406754] raid6test: test_disks(30, 41): faila=3D 30(D)  failb=3D 41(D=
)  OK
[    5.407774] raid6test: test_disks(30, 42): faila=3D 30(D)  failb=3D 42(D=
)  OK
[    5.408776] raid6test: test_disks(30, 43): faila=3D 30(D)  failb=3D 43(D=
)  OK
[    5.409783] raid6test: test_disks(30, 44): faila=3D 30(D)  failb=3D 44(D=
)  OK
[    5.410788] raid6test: test_disks(30, 45): faila=3D 30(D)  failb=3D 45(D=
)  OK
[    5.411879] raid6test: test_disks(30, 46): faila=3D 30(D)  failb=3D 46(D=
)  OK
[    5.413076] raid6test: test_disks(30, 47): faila=3D 30(D)  failb=3D 47(D=
)  OK
[    5.414064] raid6test: test_disks(30, 48): faila=3D 30(D)  failb=3D 48(D=
)  OK
[    5.415052] raid6test: test_disks(30, 49): faila=3D 30(D)  failb=3D 49(D=
)  OK
[    5.415992] raid6test: test_disks(30, 50): faila=3D 30(D)  failb=3D 50(D=
)  OK
[    5.416988] raid6test: test_disks(30, 51): faila=3D 30(D)  failb=3D 51(D=
)  OK
[    5.418000] raid6test: test_disks(30, 52): faila=3D 30(D)  failb=3D 52(D=
)  OK
[    5.418995] raid6test: test_disks(30, 53): faila=3D 30(D)  failb=3D 53(D=
)  OK
[    5.419992] raid6test: test_disks(30, 54): faila=3D 30(D)  failb=3D 54(D=
)  OK
[    5.420986] raid6test: test_disks(30, 55): faila=3D 30(D)  failb=3D 55(D=
)  OK
[    5.421988] raid6test: test_disks(30, 56): faila=3D 30(D)  failb=3D 56(D=
)  OK
[    5.422987] raid6test: test_disks(30, 57): faila=3D 30(D)  failb=3D 57(D=
)  OK
[    5.423983] raid6test: test_disks(30, 58): faila=3D 30(D)  failb=3D 58(D=
)  OK
[    5.424978] raid6test: test_disks(30, 59): faila=3D 30(D)  failb=3D 59(D=
)  OK
[    5.425979] raid6test: test_disks(30, 60): faila=3D 30(D)  failb=3D 60(D=
)  OK
[    5.426977] raid6test: test_disks(30, 61): faila=3D 30(D)  failb=3D 61(D=
)  OK
[    5.428126] raid6test: test_disks(30, 62): faila=3D 30(D)  failb=3D 62(P=
)  OK
[    5.429110] raid6test: test_disks(30, 63): faila=3D 30(D)  failb=3D 63(Q=
)  OK
[    5.430099] raid6test: test_disks(31, 32): faila=3D 31(D)  failb=3D 32(D=
)  OK
[    5.431081] raid6test: test_disks(31, 33): faila=3D 31(D)  failb=3D 33(D=
)  OK
[    5.432107] raid6test: test_disks(31, 34): faila=3D 31(D)  failb=3D 34(D=
)  OK
[    5.433091] raid6test: test_disks(31, 35): faila=3D 31(D)  failb=3D 35(D=
)  OK
[    5.434068] raid6test: test_disks(31, 36): faila=3D 31(D)  failb=3D 36(D=
)  OK
[    5.435047] raid6test: test_disks(31, 37): faila=3D 31(D)  failb=3D 37(D=
)  OK
[    5.436101] raid6test: test_disks(31, 38): faila=3D 31(D)  failb=3D 38(D=
)  OK
[    5.437071] raid6test: test_disks(31, 39): faila=3D 31(D)  failb=3D 39(D=
)  OK
[    5.438082] raid6test: test_disks(31, 40): faila=3D 31(D)  failb=3D 40(D=
)  OK
[    5.439062] raid6test: test_disks(31, 41): faila=3D 31(D)  failb=3D 41(D=
)  OK
[    5.440083] raid6test: test_disks(31, 42): faila=3D 31(D)  failb=3D 42(D=
)  OK
[    5.441064] raid6test: test_disks(31, 43): faila=3D 31(D)  failb=3D 43(D=
)  OK
[    5.442052] raid6test: test_disks(31, 44): faila=3D 31(D)  failb=3D 44(D=
)  OK
[    5.442992] raid6test: test_disks(31, 45): faila=3D 31(D)  failb=3D 45(D=
)  OK
[    5.444008] raid6test: test_disks(31, 46): faila=3D 31(D)  failb=3D 46(D=
)  OK
[    5.444999] raid6test: test_disks(31, 47): faila=3D 31(D)  failb=3D 47(D=
)  OK
[    5.445990] raid6test: test_disks(31, 48): faila=3D 31(D)  failb=3D 48(D=
)  OK
[    5.446985] raid6test: test_disks(31, 49): faila=3D 31(D)  failb=3D 49(D=
)  OK
[    5.448003] raid6test: test_disks(31, 50): faila=3D 31(D)  failb=3D 50(D=
)  OK
[    5.449001] raid6test: test_disks(31, 51): faila=3D 31(D)  failb=3D 51(D=
)  OK
[    5.449996] raid6test: test_disks(31, 52): faila=3D 31(D)  failb=3D 52(D=
)  OK
[    5.450994] raid6test: test_disks(31, 53): faila=3D 31(D)  failb=3D 53(D=
)  OK
[    5.452200] raid6test: test_disks(31, 54): faila=3D 31(D)  failb=3D 54(D=
)  OK
[    5.453512] raid6test: test_disks(31, 55): faila=3D 31(D)  failb=3D 55(D=
)  OK
[    5.454815] raid6test: test_disks(31, 56): faila=3D 31(D)  failb=3D 56(D=
)  OK
[    5.456163] raid6test: test_disks(31, 57): faila=3D 31(D)  failb=3D 57(D=
)  OK
[    5.457460] raid6test: test_disks(31, 58): faila=3D 31(D)  failb=3D 58(D=
)  OK
[    5.458797] raid6test: test_disks(31, 59): faila=3D 31(D)  failb=3D 59(D=
)  OK
[    5.460139] raid6test: test_disks(31, 60): faila=3D 31(D)  failb=3D 60(D=
)  OK
[    5.461430] raid6test: test_disks(31, 61): faila=3D 31(D)  failb=3D 61(D=
)  OK
[    5.462737] raid6test: test_disks(31, 62): faila=3D 31(D)  failb=3D 62(P=
)  OK
[    5.464079] raid6test: test_disks(31, 63): faila=3D 31(D)  failb=3D 63(Q=
)  OK
[    5.465381] raid6test: test_disks(32, 33): faila=3D 32(D)  failb=3D 33(D=
)  OK
[    5.466693] raid6test: test_disks(32, 34): faila=3D 32(D)  failb=3D 34(D=
)  OK
[    5.468064] raid6test: test_disks(32, 35): faila=3D 32(D)  failb=3D 35(D=
)  OK
[    5.469366] raid6test: test_disks(32, 36): faila=3D 32(D)  failb=3D 36(D=
)  OK
[    5.470674] raid6test: test_disks(32, 37): faila=3D 32(D)  failb=3D 37(D=
)  OK
[    5.471990] raid6test: test_disks(32, 38): faila=3D 32(D)  failb=3D 38(D=
)  OK
[    5.473295] raid6test: test_disks(32, 39): faila=3D 32(D)  failb=3D 39(D=
)  OK
[    5.474607] raid6test: test_disks(32, 40): faila=3D 32(D)  failb=3D 40(D=
)  OK
[    5.475912] raid6test: test_disks(32, 41): faila=3D 32(D)  failb=3D 41(D=
)  OK
[    5.477217] raid6test: test_disks(32, 42): faila=3D 32(D)  failb=3D 42(D=
)  OK
[    5.478557] raid6test: test_disks(32, 43): faila=3D 32(D)  failb=3D 43(D=
)  OK
[    5.479871] raid6test: test_disks(32, 44): faila=3D 32(D)  failb=3D 44(D=
)  OK
[    5.481209] raid6test: test_disks(32, 45): faila=3D 32(D)  failb=3D 45(D=
)  OK
[    5.482517] raid6test: test_disks(32, 46): faila=3D 32(D)  failb=3D 46(D=
)  OK
[    5.483825] raid6test: test_disks(32, 47): faila=3D 32(D)  failb=3D 47(D=
)  OK
[    5.485168] raid6test: test_disks(32, 48): faila=3D 32(D)  failb=3D 48(D=
)  OK
[    5.486466] raid6test: test_disks(32, 49): faila=3D 32(D)  failb=3D 49(D=
)  OK
[    5.487792] raid6test: test_disks(32, 50): faila=3D 32(D)  failb=3D 50(D=
)  OK
[    5.489144] raid6test: test_disks(32, 51): faila=3D 32(D)  failb=3D 51(D=
)  OK
[    5.490436] raid6test: test_disks(32, 52): faila=3D 32(D)  failb=3D 52(D=
)  OK
[    5.491743] raid6test: test_disks(32, 53): faila=3D 32(D)  failb=3D 53(D=
)  OK
[    5.493086] raid6test: test_disks(32, 54): faila=3D 32(D)  failb=3D 54(D=
)  OK
[    5.494386] raid6test: test_disks(32, 55): faila=3D 32(D)  failb=3D 55(D=
)  OK
[    5.495702] raid6test: test_disks(32, 56): faila=3D 32(D)  failb=3D 56(D=
)  OK
[    5.497010] raid6test: test_disks(32, 57): faila=3D 32(D)  failb=3D 57(D=
)  OK
[    5.498326] raid6test: test_disks(32, 58): faila=3D 32(D)  failb=3D 58(D=
)  OK
[    5.499645] raid6test: test_disks(32, 59): faila=3D 32(D)  failb=3D 59(D=
)  OK
[    5.500950] raid6test: test_disks(32, 60): faila=3D 32(D)  failb=3D 60(D=
)  OK
[    5.502259] raid6test: test_disks(32, 61): faila=3D 32(D)  failb=3D 61(D=
)  OK
[    5.503565] raid6test: test_disks(32, 62): faila=3D 32(D)  failb=3D 62(P=
)  OK
[    5.504863] raid6test: test_disks(32, 63): faila=3D 32(D)  failb=3D 63(Q=
)  OK
[    5.506210] raid6test: test_disks(33, 34): faila=3D 33(D)  failb=3D 34(D=
)  OK
[    5.507507] raid6test: test_disks(33, 35): faila=3D 33(D)  failb=3D 35(D=
)  OK
[    5.508847] raid6test: test_disks(33, 36): faila=3D 33(D)  failb=3D 36(D=
)  OK
[    5.510192] raid6test: test_disks(33, 37): faila=3D 33(D)  failb=3D 37(D=
)  OK
[    5.511496] raid6test: test_disks(33, 38): faila=3D 33(D)  failb=3D 38(D=
)  OK
[    5.512810] raid6test: test_disks(33, 39): faila=3D 33(D)  failb=3D 39(D=
)  OK
[    5.514150] raid6test: test_disks(33, 40): faila=3D 33(D)  failb=3D 40(D=
)  OK
[    5.515456] raid6test: test_disks(33, 41): faila=3D 33(D)  failb=3D 41(D=
)  OK
[    5.516762] raid6test: test_disks(33, 42): faila=3D 33(D)  failb=3D 42(D=
)  OK
[    5.518135] raid6test: test_disks(33, 43): faila=3D 33(D)  failb=3D 43(D=
)  OK
[    5.519444] raid6test: test_disks(33, 44): faila=3D 33(D)  failb=3D 44(D=
)  OK
[    5.520756] raid6test: test_disks(33, 45): faila=3D 33(D)  failb=3D 45(D=
)  OK
[    5.522110] raid6test: test_disks(33, 46): faila=3D 33(D)  failb=3D 46(D=
)  OK
[    5.523411] raid6test: test_disks(33, 47): faila=3D 33(D)  failb=3D 47(D=
)  OK
[    5.524720] raid6test: test_disks(33, 48): faila=3D 33(D)  failb=3D 48(D=
)  OK
[    5.526072] raid6test: test_disks(33, 49): faila=3D 33(D)  failb=3D 49(D=
)  OK
[    5.527377] raid6test: test_disks(33, 50): faila=3D 33(D)  failb=3D 50(D=
)  OK
[    5.528722] raid6test: test_disks(33, 51): faila=3D 33(D)  failb=3D 51(D=
)  OK
[    5.530057] raid6test: test_disks(33, 52): faila=3D 33(D)  failb=3D 52(D=
)  OK
[    5.531350] raid6test: test_disks(33, 53): faila=3D 33(D)  failb=3D 53(D=
)  OK
[    5.532664] raid6test: test_disks(33, 54): faila=3D 33(D)  failb=3D 54(D=
)  OK
[    5.533967] raid6test: test_disks(33, 55): faila=3D 33(D)  failb=3D 55(D=
)  OK
[    5.535274] raid6test: test_disks(33, 56): faila=3D 33(D)  failb=3D 56(D=
)  OK
[    5.536580] raid6test: test_disks(33, 57): faila=3D 33(D)  failb=3D 57(D=
)  OK
[    5.537911] raid6test: test_disks(33, 58): faila=3D 33(D)  failb=3D 58(D=
)  OK
[    5.539225] raid6test: test_disks(33, 59): faila=3D 33(D)  failb=3D 59(D=
)  OK
[    5.540526] raid6test: test_disks(33, 60): faila=3D 33(D)  failb=3D 60(D=
)  OK
[    5.541836] raid6test: test_disks(33, 61): faila=3D 33(D)  failb=3D 61(D=
)  OK
[    5.543178] raid6test: test_disks(33, 62): faila=3D 33(D)  failb=3D 62(P=
)  OK
[    5.544476] raid6test: test_disks(33, 63): faila=3D 33(D)  failb=3D 63(Q=
)  OK
[    5.545795] raid6test: test_disks(34, 35): faila=3D 34(D)  failb=3D 35(D=
)  OK
[    5.547140] raid6test: test_disks(34, 36): faila=3D 34(D)  failb=3D 36(D=
)  OK
[    5.548475] raid6test: test_disks(34, 37): faila=3D 34(D)  failb=3D 37(D=
)  OK
[    5.549784] raid6test: test_disks(34, 38): faila=3D 34(D)  failb=3D 38(D=
)  OK
[    5.551132] raid6test: test_disks(34, 39): faila=3D 34(D)  failb=3D 39(D=
)  OK
[    5.552440] raid6test: test_disks(34, 40): faila=3D 34(D)  failb=3D 40(D=
)  OK
[    5.553746] raid6test: test_disks(34, 41): faila=3D 34(D)  failb=3D 41(D=
)  OK
[    5.555088] raid6test: test_disks(34, 42): faila=3D 34(D)  failb=3D 42(D=
)  OK
[    5.556397] raid6test: test_disks(34, 43): faila=3D 34(D)  failb=3D 43(D=
)  OK
[    5.557742] raid6test: test_disks(34, 44): faila=3D 34(D)  failb=3D 44(D=
)  OK
[    5.559097] raid6test: test_disks(34, 45): faila=3D 34(D)  failb=3D 45(D=
)  OK
[    5.560387] raid6test: test_disks(34, 46): faila=3D 34(D)  failb=3D 46(D=
)  OK
[    5.561698] raid6test: test_disks(34, 47): faila=3D 34(D)  failb=3D 47(D=
)  OK
[    5.563046] raid6test: test_disks(34, 48): faila=3D 34(D)  failb=3D 48(D=
)  OK
[    5.564335] raid6test: test_disks(34, 49): faila=3D 34(D)  failb=3D 49(D=
)  OK
[    5.565649] raid6test: test_disks(34, 50): faila=3D 34(D)  failb=3D 50(D=
)  OK
[    5.566955] raid6test: test_disks(34, 51): faila=3D 34(D)  failb=3D 51(D=
)  OK
[    5.568276] raid6test: test_disks(34, 52): faila=3D 34(D)  failb=3D 52(D=
)  OK
[    5.569587] raid6test: test_disks(34, 53): faila=3D 34(D)  failb=3D 53(D=
)  OK
[    5.570882] raid6test: test_disks(34, 54): faila=3D 34(D)  failb=3D 54(D=
)  OK
[    5.572191] raid6test: test_disks(34, 55): faila=3D 34(D)  failb=3D 55(D=
)  OK
[    5.573487] raid6test: test_disks(34, 56): faila=3D 34(D)  failb=3D 56(D=
)  OK
[    5.574791] raid6test: test_disks(34, 57): faila=3D 34(D)  failb=3D 57(D=
)  OK
[    5.576143] raid6test: test_disks(34, 58): faila=3D 34(D)  failb=3D 58(D=
)  OK
[    5.577435] raid6test: test_disks(34, 59): faila=3D 34(D)  failb=3D 59(D=
)  OK
[    5.578769] raid6test: test_disks(34, 60): faila=3D 34(D)  failb=3D 60(D=
)  OK
[    5.580120] raid6test: test_disks(34, 61): faila=3D 34(D)  failb=3D 61(D=
)  OK
[    5.581410] raid6test: test_disks(34, 62): faila=3D 34(D)  failb=3D 62(P=
)  OK
[    5.582718] raid6test: test_disks(34, 63): faila=3D 34(D)  failb=3D 63(Q=
)  OK
[    5.584060] raid6test: test_disks(35, 36): faila=3D 35(D)  failb=3D 36(D=
)  OK
[    5.585362] raid6test: test_disks(35, 37): faila=3D 35(D)  failb=3D 37(D=
)  OK
[    5.586668] raid6test: test_disks(35, 38): faila=3D 35(D)  failb=3D 38(D=
)  OK
[    5.588003] raid6test: test_disks(35, 39): faila=3D 35(D)  failb=3D 39(D=
)  OK
[    5.589311] raid6test: test_disks(35, 40): faila=3D 35(D)  failb=3D 40(D=
)  OK
[    5.590622] raid6test: test_disks(35, 41): faila=3D 35(D)  failb=3D 41(D=
)  OK
[    5.591924] raid6test: test_disks(35, 42): faila=3D 35(D)  failb=3D 42(D=
)  OK
[    5.593240] raid6test: test_disks(35, 43): faila=3D 35(D)  failb=3D 43(D=
)  OK
[    5.594545] raid6test: test_disks(35, 44): faila=3D 35(D)  failb=3D 44(D=
)  OK
[    5.595848] raid6test: test_disks(35, 45): faila=3D 35(D)  failb=3D 45(D=
)  OK
[    5.597195] raid6test: test_disks(35, 46): faila=3D 35(D)  failb=3D 46(D=
)  OK
[    5.598526] raid6test: test_disks(35, 47): faila=3D 35(D)  failb=3D 47(D=
)  OK
[    5.599844] raid6test: test_disks(35, 48): faila=3D 35(D)  failb=3D 48(D=
)  OK
[    5.601182] raid6test: test_disks(35, 49): faila=3D 35(D)  failb=3D 49(D=
)  OK
[    5.602486] raid6test: test_disks(35, 50): faila=3D 35(D)  failb=3D 50(D=
)  OK
[    5.603792] raid6test: test_disks(35, 51): faila=3D 35(D)  failb=3D 51(D=
)  OK
[    5.605128] raid6test: test_disks(35, 52): faila=3D 35(D)  failb=3D 52(D=
)  OK
[    5.606430] raid6test: test_disks(35, 53): faila=3D 35(D)  failb=3D 53(D=
)  OK
[    5.607771] raid6test: test_disks(35, 54): faila=3D 35(D)  failb=3D 54(D=
)  OK
[    5.609123] raid6test: test_disks(35, 55): faila=3D 35(D)  failb=3D 55(D=
)  OK
[    5.610424] raid6test: test_disks(35, 56): faila=3D 35(D)  failb=3D 56(D=
)  OK
[    5.611731] raid6test: test_disks(35, 57): faila=3D 35(D)  failb=3D 57(D=
)  OK
[    5.613082] raid6test: test_disks(35, 58): faila=3D 35(D)  failb=3D 58(D=
)  OK
[    5.614383] raid6test: test_disks(35, 59): faila=3D 35(D)  failb=3D 59(D=
)  OK
[    5.615702] raid6test: test_disks(35, 60): faila=3D 35(D)  failb=3D 60(D=
)  OK
[    5.617068] raid6test: test_disks(35, 61): faila=3D 35(D)  failb=3D 61(D=
)  OK
[    5.618387] raid6test: test_disks(35, 62): faila=3D 35(D)  failb=3D 62(P=
)  OK
[    5.619704] raid6test: test_disks(35, 63): faila=3D 35(D)  failb=3D 63(Q=
)  OK
[    5.621056] raid6test: test_disks(36, 37): faila=3D 36(D)  failb=3D 37(D=
)  OK
[    5.622367] raid6test: test_disks(36, 38): faila=3D 36(D)  failb=3D 38(D=
)  OK
[    5.623688] raid6test: test_disks(36, 39): faila=3D 36(D)  failb=3D 39(D=
)  OK
[    5.624999] raid6test: test_disks(36, 40): faila=3D 36(D)  failb=3D 40(D=
)  OK
[    5.626315] raid6test: test_disks(36, 41): faila=3D 36(D)  failb=3D 41(D=
)  OK
[    5.627650] raid6test: test_disks(36, 42): faila=3D 36(D)  failb=3D 42(D=
)  OK
[    5.628974] raid6test: test_disks(36, 43): faila=3D 36(D)  failb=3D 43(D=
)  OK
[    5.630286] raid6test: test_disks(36, 44): faila=3D 36(D)  failb=3D 44(D=
)  OK
[    5.631605] raid6test: test_disks(36, 45): faila=3D 36(D)  failb=3D 45(D=
)  OK
[    5.632915] raid6test: test_disks(36, 46): faila=3D 36(D)  failb=3D 46(D=
)  OK
[    5.634216] raid6test: test_disks(36, 47): faila=3D 36(D)  failb=3D 47(D=
)  OK
[    5.635519] raid6test: test_disks(36, 48): faila=3D 36(D)  failb=3D 48(D=
)  OK
[    5.636819] raid6test: test_disks(36, 49): faila=3D 36(D)  failb=3D 49(D=
)  OK
[    5.638192] raid6test: test_disks(36, 50): faila=3D 36(D)  failb=3D 50(D=
)  OK
[    5.639503] raid6test: test_disks(36, 51): faila=3D 36(D)  failb=3D 51(D=
)  OK
[    5.640814] raid6test: test_disks(36, 52): faila=3D 36(D)  failb=3D 52(D=
)  OK
[    5.642171] raid6test: test_disks(36, 53): faila=3D 36(D)  failb=3D 53(D=
)  OK
[    5.643472] raid6test: test_disks(36, 54): faila=3D 36(D)  failb=3D 54(D=
)  OK
[    5.644777] raid6test: test_disks(36, 55): faila=3D 36(D)  failb=3D 55(D=
)  OK
[    5.646125] raid6test: test_disks(36, 56): faila=3D 36(D)  failb=3D 56(D=
)  OK
[    5.647421] raid6test: test_disks(36, 57): faila=3D 36(D)  failb=3D 57(D=
)  OK
[    5.648779] raid6test: test_disks(36, 58): faila=3D 36(D)  failb=3D 58(D=
)  OK
[    5.650125] raid6test: test_disks(36, 59): faila=3D 36(D)  failb=3D 59(D=
)  OK
[    5.651424] raid6test: test_disks(36, 60): faila=3D 36(D)  failb=3D 60(D=
)  OK
[    5.652811] raid6test: test_disks(36, 61): faila=3D 36(D)  failb=3D 61(D=
)  OK
[    5.654224] raid6test: test_disks(36, 62): faila=3D 36(D)  failb=3D 62(P=
)  OK
[    5.655574] raid6test: test_disks(36, 63): faila=3D 36(D)  failb=3D 63(Q=
)  OK
[    5.656915] raid6test: test_disks(37, 38): faila=3D 37(D)  failb=3D 38(D=
)  OK
[    5.658292] raid6test: test_disks(37, 39): faila=3D 37(D)  failb=3D 39(D=
)  OK
[    5.659646] raid6test: test_disks(37, 40): faila=3D 37(D)  failb=3D 40(D=
)  OK
[    5.660988] raid6test: test_disks(37, 41): faila=3D 37(D)  failb=3D 41(D=
)  OK
[    5.662368] raid6test: test_disks(37, 42): faila=3D 37(D)  failb=3D 42(D=
)  OK
[    5.663714] raid6test: test_disks(37, 43): faila=3D 37(D)  failb=3D 43(D=
)  OK
[    5.665127] raid6test: test_disks(37, 44): faila=3D 37(D)  failb=3D 44(D=
)  OK
[    5.666458] raid6test: test_disks(37, 45): faila=3D 37(D)  failb=3D 45(D=
)  OK
[    5.667821] raid6test: test_disks(37, 46): faila=3D 37(D)  failb=3D 46(D=
)  OK
[    5.669248] raid6test: test_disks(37, 47): faila=3D 37(D)  failb=3D 47(D=
)  OK
[    5.670595] raid6test: test_disks(37, 48): faila=3D 37(D)  failb=3D 48(D=
)  OK
[    5.671929] raid6test: test_disks(37, 49): faila=3D 37(D)  failb=3D 49(D=
)  OK
[    5.673293] raid6test: test_disks(37, 50): faila=3D 37(D)  failb=3D 50(D=
)  OK
[    5.674635] raid6test: test_disks(37, 51): faila=3D 37(D)  failb=3D 51(D=
)  OK
[    5.675978] raid6test: test_disks(37, 52): faila=3D 37(D)  failb=3D 52(D=
)  OK
[    5.677342] raid6test: test_disks(37, 53): faila=3D 37(D)  failb=3D 53(D=
)  OK
[    5.678706] raid6test: test_disks(37, 54): faila=3D 37(D)  failb=3D 54(D=
)  OK
[    5.680082] raid6test: test_disks(37, 55): faila=3D 37(D)  failb=3D 55(D=
)  OK
[    5.681443] raid6test: test_disks(37, 56): faila=3D 37(D)  failb=3D 56(D=
)  OK
[    5.682782] raid6test: test_disks(37, 57): faila=3D 37(D)  failb=3D 57(D=
)  OK
[    5.684189] raid6test: test_disks(37, 58): faila=3D 37(D)  failb=3D 58(D=
)  OK
[    5.685522] raid6test: test_disks(37, 59): faila=3D 37(D)  failb=3D 59(D=
)  OK
[    5.686859] raid6test: test_disks(37, 60): faila=3D 37(D)  failb=3D 60(D=
)  OK
[    5.688247] raid6test: test_disks(37, 61): faila=3D 37(D)  failb=3D 61(D=
)  OK
[    5.689595] raid6test: test_disks(37, 62): faila=3D 37(D)  failb=3D 62(P=
)  OK
[    5.690929] raid6test: test_disks(37, 63): faila=3D 37(D)  failb=3D 63(Q=
)  OK
[    5.692297] raid6test: test_disks(38, 39): faila=3D 38(D)  failb=3D 39(D=
)  OK
[    5.693640] raid6test: test_disks(38, 40): faila=3D 38(D)  failb=3D 40(D=
)  OK
[    5.694979] raid6test: test_disks(38, 41): faila=3D 38(D)  failb=3D 41(D=
)  OK
[    5.696350] raid6test: test_disks(38, 42): faila=3D 38(D)  failb=3D 42(D=
)  OK
[    5.697711] raid6test: test_disks(38, 43): faila=3D 38(D)  failb=3D 43(D=
)  OK
[    5.699130] raid6test: test_disks(38, 44): faila=3D 38(D)  failb=3D 44(D=
)  OK
[    5.700467] raid6test: test_disks(38, 45): faila=3D 38(D)  failb=3D 45(D=
)  OK
[    5.701809] raid6test: test_disks(38, 46): faila=3D 38(D)  failb=3D 46(D=
)  OK
[    5.703217] raid6test: test_disks(38, 47): faila=3D 38(D)  failb=3D 47(D=
)  OK
[    5.704585] raid6test: test_disks(38, 48): faila=3D 38(D)  failb=3D 48(D=
)  OK
[    5.705922] raid6test: test_disks(38, 49): faila=3D 38(D)  failb=3D 49(D=
)  OK
[    5.707290] raid6test: test_disks(38, 50): faila=3D 38(D)  failb=3D 50(D=
)  OK
[    5.708673] raid6test: test_disks(38, 51): faila=3D 38(D)  failb=3D 51(D=
)  OK
[    5.710052] raid6test: test_disks(38, 52): faila=3D 38(D)  failb=3D 52(D=
)  OK
[    5.711410] raid6test: test_disks(38, 53): faila=3D 38(D)  failb=3D 53(D=
)  OK
[    5.712757] raid6test: test_disks(38, 54): faila=3D 38(D)  failb=3D 54(D=
)  OK
[    5.714163] raid6test: test_disks(38, 55): faila=3D 38(D)  failb=3D 55(D=
)  OK
[    5.715502] raid6test: test_disks(38, 56): faila=3D 38(D)  failb=3D 56(D=
)  OK
[    5.716853] raid6test: test_disks(38, 57): faila=3D 38(D)  failb=3D 57(D=
)  OK
[    5.718264] raid6test: test_disks(38, 58): faila=3D 38(D)  failb=3D 58(D=
)  OK
[    5.719623] raid6test: test_disks(38, 59): faila=3D 38(D)  failb=3D 59(D=
)  OK
[    5.720968] raid6test: test_disks(38, 60): faila=3D 38(D)  failb=3D 60(D=
)  OK
[    5.722344] raid6test: test_disks(38, 61): faila=3D 38(D)  failb=3D 61(D=
)  OK
[    5.723684] raid6test: test_disks(38, 62): faila=3D 38(D)  failb=3D 62(P=
)  OK
[    5.725072] raid6test: test_disks(38, 63): faila=3D 38(D)  failb=3D 63(Q=
)  OK
[    5.726432] raid6test: test_disks(39, 40): faila=3D 39(D)  failb=3D 40(D=
)  OK
[    5.727803] raid6test: test_disks(39, 41): faila=3D 39(D)  failb=3D 41(D=
)  OK
[    5.729224] raid6test: test_disks(39, 42): faila=3D 39(D)  failb=3D 42(D=
)  OK
[    5.730585] raid6test: test_disks(39, 43): faila=3D 39(D)  failb=3D 43(D=
)  OK
[    5.731923] raid6test: test_disks(39, 44): faila=3D 39(D)  failb=3D 44(D=
)  OK
[    5.733296] raid6test: test_disks(39, 45): faila=3D 39(D)  failb=3D 45(D=
)  OK
[    5.734644] raid6test: test_disks(39, 46): faila=3D 39(D)  failb=3D 46(D=
)  OK
[    5.735989] raid6test: test_disks(39, 47): faila=3D 39(D)  failb=3D 47(D=
)  OK
[    5.737354] raid6test: test_disks(39, 48): faila=3D 39(D)  failb=3D 48(D=
)  OK
[    5.738709] raid6test: test_disks(39, 49): faila=3D 39(D)  failb=3D 49(D=
)  OK
[    5.740123] raid6test: test_disks(39, 50): faila=3D 39(D)  failb=3D 50(D=
)  OK
[    5.741454] raid6test: test_disks(39, 51): faila=3D 39(D)  failb=3D 51(D=
)  OK
[    5.742798] raid6test: test_disks(39, 52): faila=3D 39(D)  failb=3D 52(D=
)  OK
[    5.744212] raid6test: test_disks(39, 53): faila=3D 39(D)  failb=3D 53(D=
)  OK
[    5.745563] raid6test: test_disks(39, 54): faila=3D 39(D)  failb=3D 54(D=
)  OK
[    5.746903] raid6test: test_disks(39, 55): faila=3D 39(D)  failb=3D 55(D=
)  OK
[    5.748291] raid6test: test_disks(39, 56): faila=3D 39(D)  failb=3D 56(D=
)  OK
[    5.749644] raid6test: test_disks(39, 57): faila=3D 39(D)  failb=3D 57(D=
)  OK
[    5.750989] raid6test: test_disks(39, 58): faila=3D 39(D)  failb=3D 58(D=
)  OK
[    5.752363] raid6test: test_disks(39, 59): faila=3D 39(D)  failb=3D 59(D=
)  OK
[    5.753700] raid6test: test_disks(39, 60): faila=3D 39(D)  failb=3D 60(D=
)  OK
[    5.755074] raid6test: test_disks(39, 61): faila=3D 39(D)  failb=3D 61(D=
)  OK
[    5.756428] raid6test: test_disks(39, 62): faila=3D 39(D)  failb=3D 62(P=
)  OK
[    5.757799] raid6test: test_disks(39, 63): faila=3D 39(D)  failb=3D 63(Q=
)  OK
[    5.759216] raid6test: test_disks(40, 41): faila=3D 40(D)  failb=3D 41(D=
)  OK
[    5.760572] raid6test: test_disks(40, 42): faila=3D 40(D)  failb=3D 42(D=
)  OK
[    5.761908] raid6test: test_disks(40, 43): faila=3D 40(D)  failb=3D 43(D=
)  OK
[    5.763283] raid6test: test_disks(40, 44): faila=3D 40(D)  failb=3D 44(D=
)  OK
[    5.764626] raid6test: test_disks(40, 45): faila=3D 40(D)  failb=3D 45(D=
)  OK
[    5.765969] raid6test: test_disks(40, 46): faila=3D 40(D)  failb=3D 46(D=
)  OK
[    5.767329] raid6test: test_disks(40, 47): faila=3D 40(D)  failb=3D 47(D=
)  OK
[    5.768702] raid6test: test_disks(40, 48): faila=3D 40(D)  failb=3D 48(D=
)  OK
[    5.770120] raid6test: test_disks(40, 49): faila=3D 40(D)  failb=3D 49(D=
)  OK
[    5.771452] raid6test: test_disks(40, 50): faila=3D 40(D)  failb=3D 50(D=
)  OK
[    5.772794] raid6test: test_disks(40, 51): faila=3D 40(D)  failb=3D 51(D=
)  OK
[    5.774209] raid6test: test_disks(40, 52): faila=3D 40(D)  failb=3D 52(D=
)  OK
[    5.775560] raid6test: test_disks(40, 53): faila=3D 40(D)  failb=3D 53(D=
)  OK
[    5.776892] raid6test: test_disks(40, 54): faila=3D 40(D)  failb=3D 54(D=
)  OK
[    5.778297] raid6test: test_disks(40, 55): faila=3D 40(D)  failb=3D 55(D=
)  OK
[    5.779647] raid6test: test_disks(40, 56): faila=3D 40(D)  failb=3D 56(D=
)  OK
[    5.780998] raid6test: test_disks(40, 57): faila=3D 40(D)  failb=3D 57(D=
)  OK
[    5.782376] raid6test: test_disks(40, 58): faila=3D 40(D)  failb=3D 58(D=
)  OK
[    5.783720] raid6test: test_disks(40, 59): faila=3D 40(D)  failb=3D 59(D=
)  OK
[    5.785143] raid6test: test_disks(40, 60): faila=3D 40(D)  failb=3D 60(D=
)  OK
[    5.786483] raid6test: test_disks(40, 61): faila=3D 40(D)  failb=3D 61(D=
)  OK
[    5.787855] raid6test: test_disks(40, 62): faila=3D 40(D)  failb=3D 62(P=
)  OK
[    5.789243] raid6test: test_disks(40, 63): faila=3D 40(D)  failb=3D 63(Q=
)  OK
[    5.790596] raid6test: test_disks(41, 42): faila=3D 41(D)  failb=3D 42(D=
)  OK
[    5.791938] raid6test: test_disks(41, 43): faila=3D 41(D)  failb=3D 43(D=
)  OK
[    5.793293] raid6test: test_disks(41, 44): faila=3D 41(D)  failb=3D 44(D=
)  OK
[    5.794602] raid6test: test_disks(41, 45): faila=3D 41(D)  failb=3D 45(D=
)  OK
[    5.795905] raid6test: test_disks(41, 46): faila=3D 41(D)  failb=3D 46(D=
)  OK
[    5.797202] raid6test: test_disks(41, 47): faila=3D 41(D)  failb=3D 47(D=
)  OK
[    5.798535] raid6test: test_disks(41, 48): faila=3D 41(D)  failb=3D 48(D=
)  OK
[    5.799841] raid6test: test_disks(41, 49): faila=3D 41(D)  failb=3D 49(D=
)  OK
[    5.801183] raid6test: test_disks(41, 50): faila=3D 41(D)  failb=3D 50(D=
)  OK
[    5.802492] raid6test: test_disks(41, 51): faila=3D 41(D)  failb=3D 51(D=
)  OK
[    5.803802] raid6test: test_disks(41, 52): faila=3D 41(D)  failb=3D 52(D=
)  OK
[    5.805145] raid6test: test_disks(41, 53): faila=3D 41(D)  failb=3D 53(D=
)  OK
[    5.806446] raid6test: test_disks(41, 54): faila=3D 41(D)  failb=3D 54(D=
)  OK
[    5.807773] raid6test: test_disks(41, 55): faila=3D 41(D)  failb=3D 55(D=
)  OK
[    5.809120] raid6test: test_disks(41, 56): faila=3D 41(D)  failb=3D 56(D=
)  OK
[    5.810418] raid6test: test_disks(41, 57): faila=3D 41(D)  failb=3D 57(D=
)  OK
[    5.811717] raid6test: test_disks(41, 58): faila=3D 41(D)  failb=3D 58(D=
)  OK
[    5.813064] raid6test: test_disks(41, 59): faila=3D 41(D)  failb=3D 59(D=
)  OK
[    5.814359] raid6test: test_disks(41, 60): faila=3D 41(D)  failb=3D 60(D=
)  OK
[    5.815679] raid6test: test_disks(41, 61): faila=3D 41(D)  failb=3D 61(D=
)  OK
[    5.816979] raid6test: test_disks(41, 62): faila=3D 41(D)  failb=3D 62(P=
)  OK
[    5.818323] raid6test: test_disks(41, 63): faila=3D 41(D)  failb=3D 63(Q=
)  OK
[    5.819642] raid6test: test_disks(42, 43): faila=3D 42(D)  failb=3D 43(D=
)  OK
[    5.820946] raid6test: test_disks(42, 44): faila=3D 42(D)  failb=3D 44(D=
)  OK
[    5.822255] raid6test: test_disks(42, 45): faila=3D 42(D)  failb=3D 45(D=
)  OK
[    5.823567] raid6test: test_disks(42, 46): faila=3D 42(D)  failb=3D 46(D=
)  OK
[    5.824868] raid6test: test_disks(42, 47): faila=3D 42(D)  failb=3D 47(D=
)  OK
[    5.826212] raid6test: test_disks(42, 48): faila=3D 42(D)  failb=3D 48(D=
)  OK
[    5.827504] raid6test: test_disks(42, 49): faila=3D 42(D)  failb=3D 49(D=
)  OK
[    5.828853] raid6test: test_disks(42, 50): faila=3D 42(D)  failb=3D 50(D=
)  OK
[    5.830204] raid6test: test_disks(42, 51): faila=3D 42(D)  failb=3D 51(D=
)  OK
[    5.831500] raid6test: test_disks(42, 52): faila=3D 42(D)  failb=3D 52(D=
)  OK
[    5.832822] raid6test: test_disks(42, 53): faila=3D 42(D)  failb=3D 53(D=
)  OK
[    5.834165] raid6test: test_disks(42, 54): faila=3D 42(D)  failb=3D 54(D=
)  OK
[    5.835471] raid6test: test_disks(42, 55): faila=3D 42(D)  failb=3D 55(D=
)  OK
[    5.836778] raid6test: test_disks(42, 56): faila=3D 42(D)  failb=3D 56(D=
)  OK
[    5.838137] raid6test: test_disks(42, 57): faila=3D 42(D)  failb=3D 57(D=
)  OK
[    5.839442] raid6test: test_disks(42, 58): faila=3D 42(D)  failb=3D 58(D=
)  OK
[    5.840750] raid6test: test_disks(42, 59): faila=3D 42(D)  failb=3D 59(D=
)  OK
[    5.842101] raid6test: test_disks(42, 60): faila=3D 42(D)  failb=3D 60(D=
)  OK
[    5.843398] raid6test: test_disks(42, 61): faila=3D 42(D)  failb=3D 61(D=
)  OK
[    5.844701] raid6test: test_disks(42, 62): faila=3D 42(D)  failb=3D 62(P=
)  OK
[    5.846048] raid6test: test_disks(42, 63): faila=3D 42(D)  failb=3D 63(Q=
)  OK
[    5.847337] raid6test: test_disks(43, 44): faila=3D 43(D)  failb=3D 44(D=
)  OK
[    5.848668] raid6test: test_disks(43, 45): faila=3D 43(D)  failb=3D 45(D=
)  OK
[    5.849971] raid6test: test_disks(43, 46): faila=3D 43(D)  failb=3D 46(D=
)  OK
[    5.851277] raid6test: test_disks(43, 47): faila=3D 43(D)  failb=3D 47(D=
)  OK
[    5.852589] raid6test: test_disks(43, 48): faila=3D 43(D)  failb=3D 48(D=
)  OK
[    5.853890] raid6test: test_disks(43, 49): faila=3D 43(D)  failb=3D 49(D=
)  OK
[    5.855199] raid6test: test_disks(43, 50): faila=3D 43(D)  failb=3D 50(D=
)  OK
[    5.856502] raid6test: test_disks(43, 51): faila=3D 43(D)  failb=3D 51(D=
)  OK
[    5.857839] raid6test: test_disks(43, 52): faila=3D 43(D)  failb=3D 52(D=
)  OK
[    5.859193] raid6test: test_disks(43, 53): faila=3D 43(D)  failb=3D 53(D=
)  OK
[    5.860492] raid6test: test_disks(43, 54): faila=3D 43(D)  failb=3D 54(D=
)  OK
[    5.861803] raid6test: test_disks(43, 55): faila=3D 43(D)  failb=3D 55(D=
)  OK
[    5.863157] raid6test: test_disks(43, 56): faila=3D 43(D)  failb=3D 56(D=
)  OK
[    5.864458] raid6test: test_disks(43, 57): faila=3D 43(D)  failb=3D 57(D=
)  OK
[    5.865776] raid6test: test_disks(43, 58): faila=3D 43(D)  failb=3D 58(D=
)  OK
[    5.867124] raid6test: test_disks(43, 59): faila=3D 43(D)  failb=3D 59(D=
)  OK
[    5.868453] raid6test: test_disks(43, 60): faila=3D 43(D)  failb=3D 60(D=
)  OK
[    5.869762] raid6test: test_disks(43, 61): faila=3D 43(D)  failb=3D 61(D=
)  OK
[    5.871094] raid6test: test_disks(43, 62): faila=3D 43(D)  failb=3D 62(P=
)  OK
[    5.872404] raid6test: test_disks(43, 63): faila=3D 43(D)  failb=3D 63(Q=
)  OK
[    5.873718] raid6test: test_disks(44, 45): faila=3D 44(D)  failb=3D 45(D=
)  OK
[    5.875065] raid6test: test_disks(44, 46): faila=3D 44(D)  failb=3D 46(D=
)  OK
[    5.876369] raid6test: test_disks(44, 47): faila=3D 44(D)  failb=3D 47(D=
)  OK
[    5.877703] raid6test: test_disks(44, 48): faila=3D 44(D)  failb=3D 48(D=
)  OK
[    5.879057] raid6test: test_disks(44, 49): faila=3D 44(D)  failb=3D 49(D=
)  OK
[    5.880354] raid6test: test_disks(44, 50): faila=3D 44(D)  failb=3D 50(D=
)  OK
[    5.881659] raid6test: test_disks(44, 51): faila=3D 44(D)  failb=3D 51(D=
)  OK
[    5.882969] raid6test: test_disks(44, 52): faila=3D 44(D)  failb=3D 52(D=
)  OK
[    5.884275] raid6test: test_disks(44, 53): faila=3D 44(D)  failb=3D 53(D=
)  OK
[    5.885587] raid6test: test_disks(44, 54): faila=3D 44(D)  failb=3D 54(D=
)  OK
[    5.886882] raid6test: test_disks(44, 55): faila=3D 44(D)  failb=3D 55(D=
)  OK
[    5.888208] raid6test: test_disks(44, 56): faila=3D 44(D)  failb=3D 56(D=
)  OK
[    5.889512] raid6test: test_disks(44, 57): faila=3D 44(D)  failb=3D 57(D=
)  OK
[    5.890825] raid6test: test_disks(44, 58): faila=3D 44(D)  failb=3D 58(D=
)  OK
[    5.892181] raid6test: test_disks(44, 59): faila=3D 44(D)  failb=3D 59(D=
)  OK
[    5.893480] raid6test: test_disks(44, 60): faila=3D 44(D)  failb=3D 60(D=
)  OK
[    5.894793] raid6test: test_disks(44, 61): faila=3D 44(D)  failb=3D 61(D=
)  OK
[    5.896139] raid6test: test_disks(44, 62): faila=3D 44(D)  failb=3D 62(P=
)  OK
[    5.897436] raid6test: test_disks(44, 63): faila=3D 44(D)  failb=3D 63(Q=
)  OK
[    5.898771] raid6test: test_disks(45, 46): faila=3D 45(D)  failb=3D 46(D=
)  OK
[    5.900127] raid6test: test_disks(45, 47): faila=3D 45(D)  failb=3D 47(D=
)  OK
[    5.901429] raid6test: test_disks(45, 48): faila=3D 45(D)  failb=3D 48(D=
)  OK
[    5.902754] raid6test: test_disks(45, 49): faila=3D 45(D)  failb=3D 49(D=
)  OK
[    5.904095] raid6test: test_disks(45, 50): faila=3D 45(D)  failb=3D 50(D=
)  OK
[    5.905393] raid6test: test_disks(45, 51): faila=3D 45(D)  failb=3D 51(D=
)  OK
[    5.906694] raid6test: test_disks(45, 52): faila=3D 45(D)  failb=3D 52(D=
)  OK
[    5.908058] raid6test: test_disks(45, 53): faila=3D 45(D)  failb=3D 53(D=
)  OK
[    5.909366] raid6test: test_disks(45, 54): faila=3D 45(D)  failb=3D 54(D=
)  OK
[    5.910674] raid6test: test_disks(45, 55): faila=3D 45(D)  failb=3D 55(D=
)  OK
[    5.911983] raid6test: test_disks(45, 56): faila=3D 45(D)  failb=3D 56(D=
)  OK
[    5.913288] raid6test: test_disks(45, 57): faila=3D 45(D)  failb=3D 57(D=
)  OK
[    5.914600] raid6test: test_disks(45, 58): faila=3D 45(D)  failb=3D 58(D=
)  OK
[    5.915918] raid6test: test_disks(45, 59): faila=3D 45(D)  failb=3D 59(D=
)  OK
[    5.917223] raid6test: test_disks(45, 60): faila=3D 45(D)  failb=3D 60(D=
)  OK
[    5.918571] raid6test: test_disks(45, 61): faila=3D 45(D)  failb=3D 61(D=
)  OK
[    5.919871] raid6test: test_disks(45, 62): faila=3D 45(D)  failb=3D 62(P=
)  OK
[    5.921212] raid6test: test_disks(45, 63): faila=3D 45(D)  failb=3D 63(Q=
)  OK
[    5.922524] raid6test: test_disks(46, 47): faila=3D 46(D)  failb=3D 47(D=
)  OK
[    5.923839] raid6test: test_disks(46, 48): faila=3D 46(D)  failb=3D 48(D=
)  OK
[    5.925182] raid6test: test_disks(46, 49): faila=3D 46(D)  failb=3D 49(D=
)  OK
[    5.926486] raid6test: test_disks(46, 50): faila=3D 46(D)  failb=3D 50(D=
)  OK
[    5.927813] raid6test: test_disks(46, 51): faila=3D 46(D)  failb=3D 51(D=
)  OK
[    5.929163] raid6test: test_disks(46, 52): faila=3D 46(D)  failb=3D 52(D=
)  OK
[    5.930456] raid6test: test_disks(46, 53): faila=3D 46(D)  failb=3D 53(D=
)  OK
[    5.931765] raid6test: test_disks(46, 54): faila=3D 46(D)  failb=3D 54(D=
)  OK
[    5.933111] raid6test: test_disks(46, 55): faila=3D 46(D)  failb=3D 55(D=
)  OK
[    5.934413] raid6test: test_disks(46, 56): faila=3D 46(D)  failb=3D 56(D=
)  OK
[    5.935727] raid6test: test_disks(46, 57): faila=3D 46(D)  failb=3D 57(D=
)  OK
[    5.937081] raid6test: test_disks(46, 58): faila=3D 46(D)  failb=3D 58(D=
)  OK
[    5.938404] raid6test: test_disks(46, 59): faila=3D 46(D)  failb=3D 59(D=
)  OK
[    5.939716] raid6test: test_disks(46, 60): faila=3D 46(D)  failb=3D 60(D=
)  OK
[    5.941064] raid6test: test_disks(46, 61): faila=3D 46(D)  failb=3D 61(D=
)  OK
[    5.942361] raid6test: test_disks(46, 62): faila=3D 46(D)  failb=3D 62(P=
)  OK
[    5.943669] raid6test: test_disks(46, 63): faila=3D 46(D)  failb=3D 63(Q=
)  OK
[    5.944976] raid6test: test_disks(47, 48): faila=3D 47(D)  failb=3D 48(D=
)  OK
[    5.946286] raid6test: test_disks(47, 49): faila=3D 47(D)  failb=3D 49(D=
)  OK
[    5.947620] raid6test: test_disks(47, 50): faila=3D 47(D)  failb=3D 50(D=
)  OK
[    5.948945] raid6test: test_disks(47, 51): faila=3D 47(D)  failb=3D 51(D=
)  OK
[    5.950255] raid6test: test_disks(47, 52): faila=3D 47(D)  failb=3D 52(D=
)  OK
[    5.951561] raid6test: test_disks(47, 53): faila=3D 47(D)  failb=3D 53(D=
)  OK
[    5.952871] raid6test: test_disks(47, 54): faila=3D 47(D)  failb=3D 54(D=
)  OK
[    5.954211] raid6test: test_disks(47, 55): faila=3D 47(D)  failb=3D 55(D=
)  OK
[    5.955515] raid6test: test_disks(47, 56): faila=3D 47(D)  failb=3D 56(D=
)  OK
[    5.956824] raid6test: test_disks(47, 57): faila=3D 47(D)  failb=3D 57(D=
)  OK
[    5.958187] raid6test: test_disks(47, 58): faila=3D 47(D)  failb=3D 58(D=
)  OK
[    5.959507] raid6test: test_disks(47, 59): faila=3D 47(D)  failb=3D 59(D=
)  OK
[    5.960822] raid6test: test_disks(47, 60): faila=3D 47(D)  failb=3D 60(D=
)  OK
[    5.962172] raid6test: test_disks(47, 61): faila=3D 47(D)  failb=3D 61(D=
)  OK
[    5.963468] raid6test: test_disks(47, 62): faila=3D 47(D)  failb=3D 62(P=
)  OK
[    5.964774] raid6test: test_disks(47, 63): faila=3D 47(D)  failb=3D 63(Q=
)  OK
[    5.966119] raid6test: test_disks(48, 49): faila=3D 48(D)  failb=3D 49(D=
)  OK
[    5.967415] raid6test: test_disks(48, 50): faila=3D 48(D)  failb=3D 50(D=
)  OK
[    5.968756] raid6test: test_disks(48, 51): faila=3D 48(D)  failb=3D 51(D=
)  OK
[    5.970101] raid6test: test_disks(48, 52): faila=3D 48(D)  failb=3D 52(D=
)  OK
[    5.971402] raid6test: test_disks(48, 53): faila=3D 48(D)  failb=3D 53(D=
)  OK
[    5.972709] raid6test: test_disks(48, 54): faila=3D 48(D)  failb=3D 54(D=
)  OK
[    5.974052] raid6test: test_disks(48, 55): faila=3D 48(D)  failb=3D 55(D=
)  OK
[    5.975352] raid6test: test_disks(48, 56): faila=3D 48(D)  failb=3D 56(D=
)  OK
[    5.976660] raid6test: test_disks(48, 57): faila=3D 48(D)  failb=3D 57(D=
)  OK
[    5.977988] raid6test: test_disks(48, 58): faila=3D 48(D)  failb=3D 58(D=
)  OK
[    5.979300] raid6test: test_disks(48, 59): faila=3D 48(D)  failb=3D 59(D=
)  OK
[    5.980605] raid6test: test_disks(48, 60): faila=3D 48(D)  failb=3D 60(D=
)  OK
[    5.981907] raid6test: test_disks(48, 61): faila=3D 48(D)  failb=3D 61(D=
)  OK
[    5.983206] raid6test: test_disks(48, 62): faila=3D 48(D)  failb=3D 62(P=
)  OK
[    5.984504] raid6test: test_disks(48, 63): faila=3D 48(D)  failb=3D 63(Q=
)  OK
[    5.985815] raid6test: test_disks(49, 50): faila=3D 49(D)  failb=3D 50(D=
)  OK
[    5.987157] raid6test: test_disks(49, 51): faila=3D 49(D)  failb=3D 51(D=
)  OK
[    5.988479] raid6test: test_disks(49, 52): faila=3D 49(D)  failb=3D 52(D=
)  OK
[    5.989789] raid6test: test_disks(49, 53): faila=3D 49(D)  failb=3D 53(D=
)  OK
[    5.991130] raid6test: test_disks(49, 54): faila=3D 49(D)  failb=3D 54(D=
)  OK
[    5.992432] raid6test: test_disks(49, 55): faila=3D 49(D)  failb=3D 55(D=
)  OK
[    5.993736] raid6test: test_disks(49, 56): faila=3D 49(D)  failb=3D 56(D=
)  OK
[    5.995068] raid6test: test_disks(49, 57): faila=3D 49(D)  failb=3D 57(D=
)  OK
[    5.996369] raid6test: test_disks(49, 58): faila=3D 49(D)  failb=3D 58(D=
)  OK
[    5.997690] raid6test: test_disks(49, 59): faila=3D 49(D)  failb=3D 59(D=
)  OK
[    5.999002] raid6test: test_disks(49, 60): faila=3D 49(D)  failb=3D 60(D=
)  OK
[    6.000311] raid6test: test_disks(49, 61): faila=3D 49(D)  failb=3D 61(D=
)  OK
[    6.001615] raid6test: test_disks(49, 62): faila=3D 49(D)  failb=3D 62(P=
)  OK
[    6.002922] raid6test: test_disks(49, 63): faila=3D 49(D)  failb=3D 63(Q=
)  OK
[    6.004255] raid6test: test_disks(50, 51): faila=3D 50(D)  failb=3D 51(D=
)  OK
[    6.005568] raid6test: test_disks(50, 52): faila=3D 50(D)  failb=3D 52(D=
)  OK
[    6.006876] raid6test: test_disks(50, 53): faila=3D 50(D)  failb=3D 53(D=
)  OK
[    6.008212] raid6test: test_disks(50, 54): faila=3D 50(D)  failb=3D 54(D=
)  OK
[    6.009532] raid6test: test_disks(50, 55): faila=3D 50(D)  failb=3D 55(D=
)  OK
[    6.010885] raid6test: test_disks(50, 56): faila=3D 50(D)  failb=3D 56(D=
)  OK
[    6.012222] raid6test: test_disks(50, 57): faila=3D 50(D)  failb=3D 57(D=
)  OK
[    6.013522] raid6test: test_disks(50, 58): faila=3D 50(D)  failb=3D 58(D=
)  OK
[    6.014832] raid6test: test_disks(50, 59): faila=3D 50(D)  failb=3D 59(D=
)  OK
[    6.016186] raid6test: test_disks(50, 60): faila=3D 50(D)  failb=3D 60(D=
)  OK
[    6.017499] raid6test: test_disks(50, 61): faila=3D 50(D)  failb=3D 61(D=
)  OK
[    6.018849] raid6test: test_disks(50, 62): faila=3D 50(D)  failb=3D 62(P=
)  OK
[    6.020190] raid6test: test_disks(50, 63): faila=3D 50(D)  failb=3D 63(Q=
)  OK
[    6.021484] raid6test: test_disks(51, 52): faila=3D 51(D)  failb=3D 52(D=
)  OK
[    6.022796] raid6test: test_disks(51, 53): faila=3D 51(D)  failb=3D 53(D=
)  OK
[    6.024142] raid6test: test_disks(51, 54): faila=3D 51(D)  failb=3D 54(D=
)  OK
[    6.025448] raid6test: test_disks(51, 55): faila=3D 51(D)  failb=3D 55(D=
)  OK
[    6.026765] raid6test: test_disks(51, 56): faila=3D 51(D)  failb=3D 56(D=
)  OK
[    6.028130] raid6test: test_disks(51, 57): faila=3D 51(D)  failb=3D 57(D=
)  OK
[    6.029444] raid6test: test_disks(51, 58): faila=3D 51(D)  failb=3D 58(D=
)  OK
[    6.030754] raid6test: test_disks(51, 59): faila=3D 51(D)  failb=3D 59(D=
)  OK
[    6.032105] raid6test: test_disks(51, 60): faila=3D 51(D)  failb=3D 60(D=
)  OK
[    6.033401] raid6test: test_disks(51, 61): faila=3D 51(D)  failb=3D 61(D=
)  OK
[    6.034707] raid6test: test_disks(51, 62): faila=3D 51(D)  failb=3D 62(P=
)  OK
[    6.036052] raid6test: test_disks(51, 63): faila=3D 51(D)  failb=3D 63(Q=
)  OK
[    6.037347] raid6test: test_disks(52, 53): faila=3D 52(D)  failb=3D 53(D=
)  OK
[    6.038687] raid6test: test_disks(52, 54): faila=3D 52(D)  failb=3D 54(D=
)  OK
[    6.039988] raid6test: test_disks(52, 55): faila=3D 52(D)  failb=3D 55(D=
)  OK
[    6.041288] raid6test: test_disks(52, 56): faila=3D 52(D)  failb=3D 56(D=
)  OK
[    6.042593] raid6test: test_disks(52, 57): faila=3D 52(D)  failb=3D 57(D=
)  OK
[    6.043894] raid6test: test_disks(52, 58): faila=3D 52(D)  failb=3D 58(D=
)  OK
[    6.045202] raid6test: test_disks(52, 59): faila=3D 52(D)  failb=3D 59(D=
)  OK
[    6.046503] raid6test: test_disks(52, 60): faila=3D 52(D)  failb=3D 60(D=
)  OK
[    6.047836] raid6test: test_disks(52, 61): faila=3D 52(D)  failb=3D 61(D=
)  OK
[    6.049178] raid6test: test_disks(52, 62): faila=3D 52(D)  failb=3D 62(P=
)  OK
[    6.050467] raid6test: test_disks(52, 63): faila=3D 52(D)  failb=3D 63(Q=
)  OK
[    6.051768] raid6test: test_disks(53, 54): faila=3D 53(D)  failb=3D 54(D=
)  OK
[    6.053114] raid6test: test_disks(53, 55): faila=3D 53(D)  failb=3D 55(D=
)  OK
[    6.054405] raid6test: test_disks(53, 56): faila=3D 53(D)  failb=3D 56(D=
)  OK
[    6.055719] raid6test: test_disks(53, 57): faila=3D 53(D)  failb=3D 57(D=
)  OK
[    6.057063] raid6test: test_disks(53, 58): faila=3D 53(D)  failb=3D 58(D=
)  OK
[    6.058401] raid6test: test_disks(53, 59): faila=3D 53(D)  failb=3D 59(D=
)  OK
[    6.059712] raid6test: test_disks(53, 60): faila=3D 53(D)  failb=3D 60(D=
)  OK
[    6.061052] raid6test: test_disks(53, 61): faila=3D 53(D)  failb=3D 61(D=
)  OK
[    6.062347] raid6test: test_disks(53, 62): faila=3D 53(D)  failb=3D 62(P=
)  OK
[    6.063653] raid6test: test_disks(53, 63): faila=3D 53(D)  failb=3D 63(Q=
)  OK
[    6.064957] raid6test: test_disks(54, 55): faila=3D 54(D)  failb=3D 55(D=
)  OK
[    6.066264] raid6test: test_disks(54, 56): faila=3D 54(D)  failb=3D 56(D=
)  OK
[    6.067593] raid6test: test_disks(54, 57): faila=3D 54(D)  failb=3D 57(D=
)  OK
[    6.068902] raid6test: test_disks(54, 58): faila=3D 54(D)  failb=3D 58(D=
)  OK
[    6.070212] raid6test: test_disks(54, 59): faila=3D 54(D)  failb=3D 59(D=
)  OK
[    6.071537] raid6test: test_disks(54, 60): faila=3D 54(D)  failb=3D 60(D=
)  OK
[    6.072859] raid6test: test_disks(54, 61): faila=3D 54(D)  failb=3D 61(D=
)  OK
[    6.074203] raid6test: test_disks(54, 62): faila=3D 54(D)  failb=3D 62(P=
)  OK
[    6.075515] raid6test: test_disks(54, 63): faila=3D 54(D)  failb=3D 63(Q=
)  OK
[    6.076836] raid6test: test_disks(55, 56): faila=3D 55(D)  failb=3D 56(D=
)  OK
[    6.078205] raid6test: test_disks(55, 57): faila=3D 55(D)  failb=3D 57(D=
)  OK
[    6.079513] raid6test: test_disks(55, 58): faila=3D 55(D)  failb=3D 58(D=
)  OK
[    6.080814] raid6test: test_disks(55, 59): faila=3D 55(D)  failb=3D 59(D=
)  OK
[    6.082160] raid6test: test_disks(55, 60): faila=3D 55(D)  failb=3D 60(D=
)  OK
[    6.083455] raid6test: test_disks(55, 61): faila=3D 55(D)  failb=3D 61(D=
)  OK
[    6.084757] raid6test: test_disks(55, 62): faila=3D 55(D)  failb=3D 62(P=
)  OK
[    6.086109] raid6test: test_disks(55, 63): faila=3D 55(D)  failb=3D 63(Q=
)  OK
[    6.087406] raid6test: test_disks(56, 57): faila=3D 56(D)  failb=3D 57(D=
)  OK
[    6.088747] raid6test: test_disks(56, 58): faila=3D 56(D)  failb=3D 58(D=
)  OK
[    6.090089] raid6test: test_disks(56, 59): faila=3D 56(D)  failb=3D 59(D=
)  OK
[    6.091388] raid6test: test_disks(56, 60): faila=3D 56(D)  failb=3D 60(D=
)  OK
[    6.092703] raid6test: test_disks(56, 61): faila=3D 56(D)  failb=3D 61(D=
)  OK
[    6.093999] raid6test: test_disks(56, 62): faila=3D 56(D)  failb=3D 62(P=
)  OK
[    6.095302] raid6test: test_disks(56, 63): faila=3D 56(D)  failb=3D 63(Q=
)  OK
[    6.096609] raid6test: test_disks(57, 58): faila=3D 57(D)  failb=3D 58(D=
)  OK
[    6.097942] raid6test: test_disks(57, 59): faila=3D 57(D)  failb=3D 59(D=
)  OK
[    6.099249] raid6test: test_disks(57, 60): faila=3D 57(D)  failb=3D 60(D=
)  OK
[    6.100555] raid6test: test_disks(57, 61): faila=3D 57(D)  failb=3D 61(D=
)  OK
[    6.101852] raid6test: test_disks(57, 62): faila=3D 57(D)  failb=3D 62(P=
)  OK
[    6.103189] raid6test: test_disks(57, 63): faila=3D 57(D)  failb=3D 63(Q=
)  OK
[    6.104488] raid6test: test_disks(58, 59): faila=3D 58(D)  failb=3D 59(D=
)  OK
[    6.105811] raid6test: test_disks(58, 60): faila=3D 58(D)  failb=3D 60(D=
)  OK
[    6.107155] raid6test: test_disks(58, 61): faila=3D 58(D)  failb=3D 61(D=
)  OK
[    6.108477] raid6test: test_disks(58, 62): faila=3D 58(D)  failb=3D 62(P=
)  OK
[    6.109786] raid6test: test_disks(58, 63): faila=3D 58(D)  failb=3D 63(Q=
)  OK
[    6.111132] raid6test: test_disks(59, 60): faila=3D 59(D)  failb=3D 60(D=
)  OK
[    6.112446] raid6test: test_disks(59, 61): faila=3D 59(D)  failb=3D 61(D=
)  OK
[    6.113749] raid6test: test_disks(59, 62): faila=3D 59(D)  failb=3D 62(P=
)  OK
[    6.115106] raid6test: test_disks(59, 63): faila=3D 59(D)  failb=3D 63(Q=
)  OK
[    6.116413] raid6test: test_disks(60, 61): faila=3D 60(D)  failb=3D 61(D=
)  OK
[    6.117735] raid6test: test_disks(60, 62): faila=3D 60(D)  failb=3D 62(P=
)  OK
[    6.119091] raid6test: test_disks(60, 63): faila=3D 60(D)  failb=3D 63(Q=
)  OK
[    6.120387] raid6test: test_disks(61, 62): faila=3D 61(D)  failb=3D 62(P=
)  OK
[    6.121690] raid6test: test_disks(61, 63): faila=3D 61(D)  failb=3D 63(Q=
)  OK
[    6.122980] raid6test: test_disks(62, 63): faila=3D 62(P)  failb=3D 63(Q=
)  OK
[    6.124111] raid6test:=20
[    6.124510] raid6test: complete (2429 tests, 0 failures)
[    6.128715] hd: no drives specified - use hd=3Dcyl,head,sectors on kerne=
l command line
[    6.130523] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    6.131955] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    6.132635] EDD information not available.
[    6.133365] PM: Hibernation image not present or could not be loaded.
[    6.136492] Freeing unused kernel memory: 800K (ffffffff81a46000 - fffff=
fff81b0e000)
[    6.154082] random: init urandom read with 6 bits of entropy available
modprobe: FATAL: Could not load /lib/modules/3.12.0-11285-gb242bff/modules.=
dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-11285-gb242bff/modules.=
dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-11285-gb242bff/modules.=
dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-11285-gb242bff/modules.=
dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-11285-gb242bff/modules.=
dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-11285-gb242bff/modules.=
dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-11285-gb242bff/modules.=
dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-11285-gb242bff/modules.=
dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-11285-gb242bff/modules.=
dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-11285-gb242bff/modules.=
dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-11285-gb242bff/modules.=
dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-11285-gb242bff/modules.=
dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-11285-gb242bff/modules.=
dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-11285-gb242bff/modules.=
dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-11285-gb242bff/modules.=
dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/3.12.0-11285-gb242bff/modules.=
dep: No such file or directory

mount: unknown filesystem type 'devpts'
mountall: mount /dev/pts [2313] terminated with status 32
mountall: Filesystem could not be mounted: /dev/pts
mountall: Skipping mounting /dev/pts since Plymouth is not available
udevd[2358]: error: runtime directory '/run/udev' not writable, for now fal=
ling back to '/dev/.udev'
udevd[2360]: inotify_init failed: Function not implemented

udevd[2360]: error initializing inotify

udevd[2364]: error: runtime directory '/run/udev' not writable, for now fal=
ling back to '/dev/.udev'
udevd[2367]: inotify_init failed: Function not implemented

udevd[2367]: error initializing inotify

udevd[2368]: error: runtime directory '/run/udev' not writable, for now fal=
ling back to '/dev/.udev'
udevd[2369]: inotify_init failed: Function not implemented

udevd[2369]: error initializing inotify

udevd[2370]: error: runtime directory '/run/udev' not writable, for now fal=
ling back to '/dev/.udev'
udevd[2371]: inotify_init failed: Function not implemented

udevd[2371]: error initializing inotify

udevd[2372]: error: runtime directory '/run/udev' not writable, for now fal=
ling back to '/dev/.udev'
udevd[2373]: inotify_init failed: Function not implemented

udevd[2373]: error initializing inotify

udevd[2374]: error: runtime directory '/run/udev' not writable, for now fal=
ling back to '/dev/.udev'
udevd[2375]: inotify_init failed: Function not implemented

udevd[2375]: error initializing inotify

udevd[2376]: error: runtime directory '/run/udev' not writable, for now fal=
ling back to '/dev/.udev'
udevd[2377]: inotify_init failed: Function not implemented

udevd[2377]: error initializing inotify

udevd[2378]: error: runtime directory '/run/udev' not writable, for now fal=
ling back to '/dev/.udev'
udevd[2379]: inotify_init failed: Function not implemented

udevd[2379]: error initializing inotify

udevd[2380]: error: runtime directory '/run/udev' not writable, for now fal=
ling back to '/dev/.udev'
udevd[2381]: inotify_init failed: Function not implemented

udevd[2381]: error initializing inotify

udevd[2382]: error: runtime directory '/run/udev' not writable, for now fal=
ling back to '/dev/.udev'
udevd[2383]: inotify_init failed: Function not implemented

udevd[2383]: error initializing inotify

udevd[2384]: error: runtime directory '/run/udev' not writable, for now fal=
ling back to '/dev/.udev'
udevd[2385]: inotify_init failed: Function not implemented

udevd[2385]: error initializing inotify

 * Asking all remaining processes to terminate...      =20
 * All processes ended within 1 seconds....      =20
 * Deactivating swap...      =20
umount: /run/lock: not mounted
 * Will now restart
[   67.239386] Unregister pv shared memory for cpu 0
[   67.239923] Unregister pv shared memory for cpu 1
[   67.241866] reboot: Restarting system
[   67.242317] reboot: machine restart
Elapsed time: 70
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-c1-1122/b242bff548c34510fd9b7f0e29b885263dfb8903/vmlinuz-3.12.0-11285-gb24=
2bff -append 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_timeout=3D100 log_b=
uf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_printk s=
ysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,115200 c=
onsole=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-qu=
eue/kvm/x86_64-randconfig-c1-1122/devel-cairo-x86_64-201311220159/.vmlinuz-=
b242bff548c34510fd9b7f0e29b885263dfb8903-20131122021504-5-roam branch=3Dlin=
ux-devel/devel-cairo-x86_64-201311220159 BOOT_IMAGE=3D/kernel/x86_64-randco=
nfig-c1-1122/b242bff548c34510fd9b7f0e29b885263dfb8903/vmlinuz-3.12.0-11285-=
gb242bff'  -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz -m 256M -sm=
p 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no=
-reboot -watchdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs/LABEL=3D=
KVM/disk0-quantal-roam-13,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=
=3DKVM/disk1-quantal-roam-13,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LAB=
EL=3DKVM/disk2-quantal-roam-13,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/L=
ABEL=3DKVM/disk3-quantal-roam-13,media=3Ddisk,if=3Dvirtio -drive file=3D/fs=
/LABEL=3DKVM/disk4-quantal-roam-13,media=3Ddisk,if=3Dvirtio -drive file=3D/=
fs/LABEL=3DKVM/disk5-quantal-roam-13,media=3Ddisk,if=3Dvirtio -pidfile /dev=
/shm/kboot/pid-quantal-roam-13 -serial file:/dev/shm/kboot/serial-quantal-r=
oam-13 -daemonize -display none -monitor null=20

--EuxKj2iCbKjpUGkD
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-c1-1122-b242bff548c34510fd9b7f0e29b885263dfb8903-initcall-calibrate_xor_blocks-18887.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDVlMDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgYjI0MmJmZi4uLiBNZXJnZSAnb3Blbi1vc2Qv
ZXhvZnNfaW9jdGwnIGludG8gZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMxMTIyMDE1OQpIRUFE
IGlzIG5vdyBhdCA1ZTAxZGM3Li4uIExpbnV4IDMuMTIKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMxLTExMjIvbGludXgtZGV2ZWw6ZGV2
ZWwtY2Fpcm8teDg2XzY0LTIwMTMxMTIyMDE1OTo1ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVk
YTk4Y2NiZDZhNWNlYjUyOmJpc2VjdC11c2IKIFNVQ0NFU1MKCmJpc2VjdDogZ29vZCBjb21t
aXQgNWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1MgpnaXQgYmlzZWN0
IHN0YXJ0IGIyNDJiZmY1NDhjMzQ1MTBmZDliN2YwZTI5Yjg4NTI2M2RmYjg5MDMgNWUwMWRj
N2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1MiAtLQpQcmV2aW91cyBIRUFEIHBv
c2l0aW9uIHdhcyA1ZTAxZGM3Li4uIExpbnV4IDMuMTIKSEVBRCBpcyBub3cgYXQgNmU0NjY0
NS4uLiBMaW51eCAzLjExCkJpc2VjdGluZzogNTk2MyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0
IGFmdGVyIHRoaXMgKHJvdWdobHkgMTMgc3RlcHMpCls1Y2JiM2QyMTZlMjA0MTcwMDIzMWJj
ZmMzODNlZTVmOGI3ZmM4Yjc0XSBNZXJnZSBicmFuY2ggJ2FrcG0nIChwYXRjaGVzIGZyb20g
QW5kcmV3IE1vcnRvbikKZ2l0IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91
c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LXJhbmRjb25maWctYzEtMTEyMi9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAx
MzExMjIwMTU5OjVjYmIzZDIxNmUyMDQxNzAwMjMxYmNmYzM4M2VlNWY4YjdmYzhiNzQ6Ymlz
ZWN0LXVzYgoKMjAxMy0xMS0yMi0wOTowMDowOSA1Y2JiM2QyMTZlMjA0MTcwMDIzMWJjZmMz
ODNlZTVmOGI3ZmM4Yjc0IGNvbXBpbGluZwoxMjgzIHJlYWwgIDE5ODUgdXNlciAgMjAxIHN5
cyAgMTcwLjM5JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLWMxLTExMjIKCjIwMTMtMTEtMjIt
MDk6MjM6MTkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLTA1MzIxLWc1Y2JiM2QyLi4u
CTEwCTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMjk2NyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0
IGFmdGVyIHRoaXMgKHJvdWdobHkgMTIgc3RlcHMpCls3ZTFhMWU5Mzc4MDE4YWVlYTJjN2U4
YTNkZDJjZWIxZGIxNTIzYjBiXSBNZXJnZSB0YWcgJ3hmcy1mb3ItbGludXMtdjMuMTMtcmMx
JyBvZiBnaXQ6Ly9vc3Muc2dpLmNvbS94ZnMveGZzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMx
LTExMjIvbGludXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMxMTIyMDE1OTo3ZTFh
MWU5Mzc4MDE4YWVlYTJjN2U4YTNkZDJjZWIxZGIxNTIzYjBiOmJpc2VjdC11c2IKCjIwMTMt
MTEtMjItMDk6MjU6NTMgN2UxYTFlOTM3ODAxOGFlZWEyYzdlOGEzZGQyY2ViMWRiMTUyM2Iw
YiBjb21waWxpbmcKNzkzIHJlYWwgIDE5ODEgdXNlciAgMTk3IHN5cyAgMjc0LjY3JSBjcHUg
CXg4Nl82NC1yYW5kY29uZmlnLWMxLTExMjIKCjIwMTMtMTEtMjItMDk6NDA6MDQgZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLTA4MzE3LWc3ZTFhMWU5Li4JMTIJMjAgU1VDQ0VTUwoK
QmlzZWN0aW5nOiAxNDU3IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91
Z2hseSAxMSBzdGVwcykKWzQ5MzdlMmE2ZjkzOWE0MWJmODExMzc4ZTgwZDcxZjY4YWEwOTUw
YzZdIE1lcmdlIGJyYW5jaCAnZm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9w
dWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZHRvci9pbnB1dApydW5uaW5nIC9jL2tlcm5lbC10
ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlz
ZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZp
Zy1jMS0xMTIyL2xpbnV4LWRldmVsOmRldmVsLWNhaXJvLXg4Nl82NC0yMDEzMTEyMjAxNTk6
NDkzN2UyYTZmOTM5YTQxYmY4MTEzNzhlODBkNzFmNjhhYTA5NTBjNjpiaXNlY3QtdXNiCgoy
MDEzLTExLTIyLTA5OjQyOjEwIDQ5MzdlMmE2ZjkzOWE0MWJmODExMzc4ZTgwZDcxZjY4YWEw
OTUwYzYgY29tcGlsaW5nCjEyNDkgcmVhbCAgMjAwNyB1c2VyICAyMTAgc3lzICAxNzcuNTMl
IGNwdSAJeDg2XzY0LXJhbmRjb25maWctYzEtMTEyMgoKMjAxMy0xMS0yMi0xMDowNjo1NCBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtMDk4MjctZzQ5MzdlMmEuLgkyMCBTVUNDRVNT
CgpCaXNlY3Rpbmc6IDcyOCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJv
dWdobHkgMTAgc3RlcHMpClsyMTBlODEyZjAzNjczNmFlZGEwOTdkOWE2ZWY4NGIxZjJiMzM0
YmFlXSBwZXJmIGhlYWRlcjogRml4IGJvZ3VzIGdyb3VwIG5hbWUKcnVubmluZyAvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91c2Ivb2Jq
LWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRj
b25maWctYzEtMTEyMi9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAxMzExMjIw
MTU5OjIxMGU4MTJmMDM2NzM2YWVkYTA5N2Q5YTZlZjg0YjFmMmIzMzRiYWU6YmlzZWN0LXVz
YgoKMjAxMy0xMS0yMi0xMDowODoyNyAyMTBlODEyZjAzNjczNmFlZGEwOTdkOWE2ZWY4NGIx
ZjJiMzM0YmFlIGNvbXBpbGluZwoxMjExIHJlYWwgIDIwMTYgdXNlciAgMTkyIHN5cyAgMTgy
LjM0JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLWMxLTExMjIKCjIwMTMtMTEtMjItMTA6Mjk6
MzAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLTEwNTU2LWcyMTBlODEyLi4JMgkyMCBT
VUNDRVNTCgpCaXNlY3Rpbmc6IDM2NSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgOSBzdGVwcykKW2Q1YmRhZjRmNjhmMDU5MGZjNDgxYmNhNTRiY2FmZmVi
MjdiNzVmY2FdIE1lcmdlIGJyYW5jaCAnZm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQua2VybmVs
Lm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvbWF0dHN0ODgvYWxwaGEKcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy91
c2Ivb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LXJhbmRjb25maWctYzEtMTEyMi9saW51eC1kZXZlbDpkZXZlbC1jYWlyby14ODZfNjQtMjAx
MzExMjIwMTU5OmQ1YmRhZjRmNjhmMDU5MGZjNDgxYmNhNTRiY2FmZmViMjdiNzVmY2E6Ymlz
ZWN0LXVzYgoKMjAxMy0xMS0yMi0xMDozMTozMiBkNWJkYWY0ZjY4ZjA1OTBmYzQ4MWJjYTU0
YmNhZmZlYjI3Yjc1ZmNhIGNvbXBpbGluZwoxMDUxIHJlYWwgIDIwMzIgdXNlciAgMTkzIHN5
cyAgMjExLjY3JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLWMxLTExMjIKCjIwMTMtMTEtMjIt
MTA6NTE6MTYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLTEwOTE3LWdkNWJkYWY0Li4u
CTUJMTQJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxODIgcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDggc3RlcHMpCltlNjMwYTZiY2YxODA3OWIyYWI2YjAz
ZDU1Yzk3NTdlOGVmNjY1NmI2XSBzdGFnaW5nOiBsdXN0cmU6IGZpeCBjaGVja3BhdGNoIGlz
c3VlIHJlZ2FyZGluZyBwb2ludGVyIGNvZGluZyBzdHlsZQpydW5uaW5nIC9jL2tlcm5lbC10
ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlz
ZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZp
Zy1jMS0xMTIyL2xpbnV4LWRldmVsOmRldmVsLWNhaXJvLXg4Nl82NC0yMDEzMTEyMjAxNTk6
ZTYzMGE2YmNmMTgwNzliMmFiNmIwM2Q1NWM5NzU3ZThlZjY2NTZiNjpiaXNlY3QtdXNiCgoy
MDEzLTExLTIyLTEwOjU0OjIyIGU2MzBhNmJjZjE4MDc5YjJhYjZiMDNkNTVjOTc1N2U4ZWY2
NjU2YjYgY29tcGlsaW5nCjMzMCByZWFsICAxOTk0IHVzZXIgIDIwNiBzeXMgIDY2NS41MCUg
Y3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1jMS0xMTIyCgoyMDEzLTExLTIyLTExOjAwOjM2IGRl
dGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1yYzYtMDEyMzctZ2U2MzBhNmIuLgk0CTE4CTIw
IFNVQ0NFU1MKCkJpc2VjdGluZzogMTE2IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIg
dGhpcyAocm91Z2hseSA3IHN0ZXBzKQpbNjQ0OWE1ODExZTYyYWI5NTg3YjU0ZmVjYTQ1YzA2
Y2ZlZTBlMzdjZF0gTWVyZ2UgJ2J0cmZzL2Zvci1saW51cycgaW50byBkZXZlbC1jYWlyby14
ODZfNjQtMjAxMzExMjIwMTU5CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5l
bC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMxLTExMjIvbGludXgt
ZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMxMTIyMDE1OTo2NDQ5YTU4MTFlNjJhYjk1
ODdiNTRmZWNhNDVjMDZjZmVlMGUzN2NkOmJpc2VjdC11c2IKCjIwMTMtMTEtMjItMTE6MDM6
MTEgNjQ0OWE1ODExZTYyYWI5NTg3YjU0ZmVjYTQ1YzA2Y2ZlZTBlMzdjZCBjb21waWxpbmcK
MzEwIHJlYWwgIDIwMTUgdXNlciAgMjA4IHN5cyAgNzE1LjI2JSBjcHUgCXg4Nl82NC1yYW5k
Y29uZmlnLWMxLTExMjIKCjIwMTMtMTEtMjItMTE6MDg6NDUgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgMy4xMi4wLTEwOTg1LWc2NDQ5YTU4Li4JOQkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDYw
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA2IHN0ZXBzKQpb
NzgxMDNiNjkyZTdhYTZhOGUyZWY2NzhjOWEzNDY1ZDZiZmU0NDU1OV0gTWVyZ2UgJ3N0YWdp
bmcvb3B3LW5leHQnIGludG8gZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMxMTIyMDE1OQpydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUv
d2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94
ODZfNjQtcmFuZGNvbmZpZy1jMS0xMTIyL2xpbnV4LWRldmVsOmRldmVsLWNhaXJvLXg4Nl82
NC0yMDEzMTEyMjAxNTk6NzgxMDNiNjkyZTdhYTZhOGUyZWY2NzhjOWEzNDY1ZDZiZmU0NDU1
OTpiaXNlY3QtdXNiCgoyMDEzLTExLTIyLTExOjEwOjQ3IDc4MTAzYjY5MmU3YWE2YThlMmVm
Njc4YzlhMzQ2NWQ2YmZlNDQ1NTkgY29tcGlsaW5nCjU4IHJlYWwgIDE5MCB1c2VyICAzNiBz
eXMgIDM5MC44MiUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1jMS0xMTIyCgoyMDEzLTExLTIy
LTExOjEyOjA4IGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC0xMTIyNC1nNzgxMDNiNi4u
CTE3CTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMzEgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDUgc3RlcHMpCls3YWNkNzE4NzljZTQwOGFmMmQyY2EzY2Qz
ZWMzYTg2ZDA2NjdjZWFlXSBNZXJnZSBicmFuY2ggJ21hc3Rlcicgb2YgZ2l0Oi8vZ2l0Lmtl
cm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2xpbnZpbGxlL3dpcmVsZXNzIGlu
dG8gZm9yLWRhdmVtCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMxLTExMjIvbGludXgtZGV2ZWw6
ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMxMTIyMDE1OTo3YWNkNzE4NzljZTQwOGFmMmQyY2Ez
Y2QzZWMzYTg2ZDA2NjdjZWFlOmJpc2VjdC11c2IKCjIwMTMtMTEtMjItMTE6MTQ6MTAgN2Fj
ZDcxODc5Y2U0MDhhZjJkMmNhM2NkM2VjM2E4NmQwNjY3Y2VhZSBjb21waWxpbmcKNTA0IHJl
YWwgIDIwMzMgdXNlciAgMTk4IHN5cyAgNDQyLjA5JSBjcHUgCXg4Nl82NC1yYW5kY29uZmln
LWMxLTExMjIKCjIwMTMtMTEtMjItMTE6MjI6NTUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4x
Mi4wLTEwNzM5LWc3YWNkNzE4Li4JNgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDE1IHJldmlz
aW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA0IHN0ZXBzKQpbMmVhNDYw
NmZkNzA3ZjA1Y2RkY2U3MjIxOWE1ZjkwY2E0NzFjMDlkNl0gZHJtL21zbTogYWRkIGF0b21p
YyBzdXBwb3J0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMxLTExMjIvbGludXgtZGV2ZWw6ZGV2
ZWwtY2Fpcm8teDg2XzY0LTIwMTMxMTIyMDE1OToyZWE0NjA2ZmQ3MDdmMDVjZGRjZTcyMjE5
YTVmOTBjYTQ3MWMwOWQ2OmJpc2VjdC11c2IKCjIwMTMtMTEtMjItMTE6MjQ6NTkgMmVhNDYw
NmZkNzA3ZjA1Y2RkY2U3MjIxOWE1ZjkwY2E0NzFjMDlkNiBjb21waWxpbmcKMjg0IHJlYWwg
IDE5NjMgdXNlciAgMTk4IHN5cyAgNzYwLjA1JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLWMx
LTExMjIKCjIwMTMtMTEtMjItMTE6MzA6MDYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4w
LTAwODMwLWcyZWE0NjA2Li4uLgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDcgcmV2aXNpb25z
IGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDMgc3RlcHMpCltjZDdlZmVmMDcw
Y2M1NDIwODU4YzI3MWE5OTA4ZGYzZjg2Y2VmODNiXSB7U1FVQVNITUV9IGV4b2ZzX2lvY3Rs
OiBGaXggZm9yIGRlYWRsb2NrIHdoZW4gY2xvc2Ugb2Ygcm9vdCBub2RlCnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNi
L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1y
YW5kY29uZmlnLWMxLTExMjIvbGludXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMx
MTIyMDE1OTpjZDdlZmVmMDcwY2M1NDIwODU4YzI3MWE5OTA4ZGYzZjg2Y2VmODNiOmJpc2Vj
dC11c2IKCjIwMTMtMTEtMjItMTE6MzI6NDkgY2Q3ZWZlZjA3MGNjNTQyMDg1OGMyNzFhOTkw
OGRmM2Y4NmNlZjgzYiBjb21waWxpbmcKMzExIHJlYWwgIDE5MjkgdXNlciAgMjAzIHN5cyAg
Njg1LjQ1JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLWMxLTExMjIKCjIwMTMtMTEtMjItMTE6
Mzk6MjAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4wLTAwMDA4LWdjZDdlZmVmLi4uIFRF
U1QgRkFJTFVSRQpbICAgIDAuMTE1MDE0XSAgICBnZW5lcmljX3NzZTogMTEyODYuOTA5IE1C
L3NlYwpbICAgIDAuMTE1NDMxXSB4b3I6IHVzaW5nIGZ1bmN0aW9uOiBwcmVmZXRjaDY0LXNz
ZSAoMTE1NjAuNzI3IE1CL3NlYykKWyAgICAwLjExNjAxNl0gLS0tLS0tLS0tLS0tWyBjdXQg
aGVyZSBdLS0tLS0tLS0tLS0tClsgICAgMC4xMTY0NjRdIFdBUk5JTkc6IENQVTogMCBQSUQ6
IDEgYXQgaW5pdC9tYWluLmM6Njk5IGRvX29uZV9pbml0Y2FsbCsweDEwMy8weDExMygpClsg
ICAgMC4xMTcwMTddIGluaXRjYWxsIGNhbGlicmF0ZV94b3JfYmxvY2tzKzB4MC8weDEyOCBy
ZXR1cm5lZCB3aXRoIHByZWVtcHRpb24gaW1iYWxhbmNlIApbICAgIDAuMTE4MDEzXSBNb2R1
bGVzIGxpbmtlZCBpbjoKWyAgICAwLjExODM0Ml0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2Fw
cGVyLzAgTm90IHRhaW50ZWQgMy4xMS4wLTAwMDA4LWdjZDdlZmVmICM4NTQKWyAgICAwLjEx
OTAxNF0gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAwZDBkYmUwMCBmZmZmZmZmZjgxNWYw
ZDFlIGZmZmY4ODAwMGQwZGJlNDgKWyAgICAwLjExOTc2NV0gIGZmZmY4ODAwMGQwZGJlMzgg
ZmZmZmZmZmY4MTA1MWJhYyBmZmZmZmZmZjgxMDAwMmViIGZmZmZmZmZmODFhMjQ5ODkKWyAg
ICAwLjEyMDQ5MV0gIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgw
MDBkMGRiZmQ4IGZmZmY4ODAwMGQwZGJlOTgKWyAgICAwLjEyMTM0M10gQ2FsbCBUcmFjZToK
WyAgICAwLjEyMTU4NF0gIFs8ZmZmZmZmZmY4MTVmMGQxZT5dIGR1bXBfc3RhY2srMHg0ZS8w
eDgyClsgICAgMC4xMjIwMTddICBbPGZmZmZmZmZmODEwNTFiYWM+XSB3YXJuX3Nsb3dwYXRo
X2NvbW1vbisweDc1LzB4OGUKWyAgICAwLjEyMjYwMF0gIFs8ZmZmZmZmZmY4MTAwMDJlYj5d
ID8gZG9fb25lX2luaXRjYWxsKzB4MTAzLzB4MTEzClsgICAgMC4xMjMwMTVdICBbPGZmZmZm
ZmZmODFhMjQ5ODk+XSA/IGRvX3hvcl9zcGVlZCsweGRkLzB4ZGQKWyAgICAwLjEyMzU1MV0g
IFs8ZmZmZmZmZmY4MTA1MWMwYz5dIHdhcm5fc2xvd3BhdGhfZm10KzB4NDcvMHg0OQpbICAg
IDAuMTI0MDE3XSAgWzxmZmZmZmZmZjgxMGM1NTY5Pl0gPyBmcmVlX3BhZ2VzKzB4NTIvMHg1
NApbICAgIDAuMTI0NTI3XSAgWzxmZmZmZmZmZjgxYTI0OTg5Pl0gPyBkb194b3Jfc3BlZWQr
MHhkZC8weGRkClsgICAgMC4xMjUwMTVdICBbPGZmZmZmZmZmODEwMDAyZWI+XSBkb19vbmVf
aW5pdGNhbGwrMHgxMDMvMHgxMTMKWyAgICAwLjEyNjAxN10gIFs8ZmZmZmZmZmY4MWEwNmVh
Yj5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MTE1LzB4MTk2ClsgICAgMC4xMjY2MTNdICBb
PGZmZmZmZmZmODFhMDY3MDc+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4ODgvMHg4OApbICAgIDAu
MTI3MDE1XSAgWzxmZmZmZmZmZjgxNWU3MWQ5Pl0gPyByZXN0X2luaXQrMHhiZC8weGJkClsg
ICAgMC4xMjc1MThdICBbPGZmZmZmZmZmODE1ZTcxZTI+XSBrZXJuZWxfaW5pdCsweDkvMHhj
YwpbICAgIDAuMTI4MDE2XSAgWzxmZmZmZmZmZjgxNjAwOGJjPl0gcmV0X2Zyb21fZm9yaysw
eDdjLzB4YjAKWyAgICAwLjEyODUzMl0gIFs8ZmZmZmZmZmY4MTVlNzFkOT5dID8gcmVzdF9p
bml0KzB4YmQvMHhiZApbICAgIDAuMTI5MDM2XSAtLS1bIGVuZCB0cmFjZSBiNDA2MGFlNDEy
ZTFjMjg0IF0tLS0KWyAgICAwLjEyOTQ4N10gYXRvbWljNjQgdGVzdCBwYXNzZWQgZm9yIHg4
Ni02NCBwbGF0Zm9ybSB3aXRoIENYOCBhbmQgd2l0aCBTU0UKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1jMS0xMTIyL2NkN2VmZWYwNzBjYzU0MjA4NThjMjcxYTk5MDhkZjNmODZjZWY4
M2IvZG1lc2ctcXVhbnRhbC1pbm4tMjM6MjAxMzExMjIxMTQwNDQ6eDg2XzY0LXJhbmRjb25m
aWctYzEtMTEyMjozLjExLjAtMDAwMDgtZ2NkN2VmZWY6ODU0Ci9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctYzEtMTEyMi9jZDdlZmVmMDcwY2M1NDIwODU4YzI3MWE5OTA4ZGYzZjg2Y2Vm
ODNiL2RtZXNnLXF1YW50YWwtcm9hbS0yNjoyMDEzMTEyMjExNDAzOTp4ODZfNjQtcmFuZGNv
bmZpZy1jMS0xMTIyOjMuMTEuMC0wMDAwOC1nY2Q3ZWZlZjo4NTQKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1jMS0xMTIyL2NkN2VmZWYwNzBjYzU0MjA4NThjMjcxYTk5MDhkZjNmODZj
ZWY4M2IvZG1lc2cteW9jdG8tcm9hbS0yNjoyMDEzMTEyMjExNDA0NDp4ODZfNjQtcmFuZGNv
bmZpZy1jMS0xMTIyOjMuMTEuMC0wMDAwOC1nY2Q3ZWZlZjo4NTQKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1jMS0xMTIyL2NkN2VmZWYwNzBjYzU0MjA4NThjMjcxYTk5MDhkZjNmODZj
ZWY4M2IvZG1lc2ctcXVhbnRhbC1yb2FtLTE6MjAxMzExMjIxMTQwNDY6eDg2XzY0LXJhbmRj
b25maWctYzEtMTEyMjozLjExLjAtMDAwMDgtZ2NkN2VmZWY6ODU0Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctYzEtMTEyMi9jZDdlZmVmMDcwY2M1NDIwODU4YzI3MWE5OTA4ZGYzZjg2
Y2VmODNiL2RtZXNnLXF1YW50YWwtcm9hbS00OjIwMTMxMTIyMTE0MDQ2Ong4Nl82NC1yYW5k
Y29uZmlnLWMxLTExMjI6My4xMS4wLTAwMDA4LWdjZDdlZmVmOjg1NAova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWMxLTExMjIvY2Q3ZWZlZjA3MGNjNTQyMDg1OGMyNzFhOTkwOGRmM2Y4
NmNlZjgzYi9kbWVzZy1xdWFudGFsLXdhaW1lYS0zOjIwMTMxMTIyMTkyOTMxOng4Nl82NC1y
YW5kY29uZmlnLWMxLTExMjI6My4xMS4wLTAwMDA4LWdjZDdlZmVmOjg1NAova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWMxLTExMjIvY2Q3ZWZlZjA3MGNjNTQyMDg1OGMyNzFhOTkwOGRm
M2Y4NmNlZjgzYi9kbWVzZy15b2N0by1yb2FtLTg6MjAxMzExMjIxMTQwNDY6eDg2XzY0LXJh
bmRjb25maWctYzEtMTEyMjozLjExLjAtMDAwMDgtZ2NkN2VmZWY6ODU0CjA6NzozIGFsbF9n
b29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDMgcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDIgc3RlcHMpClsxM2NmNzAwMzUyNjg5MWJmYjdh
ZDEyZmM1Y2ZmMDFjZjllNzM0ZGMyXSB7U1BMSVRNRX0gZXhvZnNfaW9jdGw6IEFsbCB0aGUg
bmV3IGFuZCBleHRlcm5hbCBmaWxlcwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlzZWN0CmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1jMS0xMTIyL2xp
bnV4LWRldmVsOmRldmVsLWNhaXJvLXg4Nl82NC0yMDEzMTEyMjAxNTk6MTNjZjcwMDM1MjY4
OTFiZmI3YWQxMmZjNWNmZjAxY2Y5ZTczNGRjMjpiaXNlY3QtdXNiCgoyMDEzLTExLTIyLTEx
OjQwOjUyIDEzY2Y3MDAzNTI2ODkxYmZiN2FkMTJmYzVjZmYwMWNmOWU3MzRkYzIgY29tcGls
aW5nCjYzIHJlYWwgIDE4MyB1c2VyICAzNiBzeXMgIDM0Ny44NCUgY3B1IAl4ODZfNjQtcmFu
ZGNvbmZpZy1jMS0xMTIyCgoyMDEzLTExLTIyLTExOjQyOjE1IGRldGVjdGluZyBib290IHN0
YXRlIDMuMTEuMC0wMDAwNC1nMTNjZjcwMC4uLiBURVNUIEZBSUxVUkUKWyAgICAwLjE3MzAz
Nl0gICAgZ2VuZXJpY19zc2U6ICA2MDYxLjgxOCBNQi9zZWMKWyAgICAwLjE3Mzk0NF0geG9y
OiB1c2luZyBmdW5jdGlvbjogcHJlZmV0Y2g2NC1zc2UgKDcxOTMuODE4IE1CL3NlYykKWyAg
ICAwLjE3NDAyMF0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAg
MC4xNzUwMDBdIFdBUk5JTkc6IENQVTogMCBQSUQ6IDEgYXQgaW5pdC9tYWluLmM6Njk5IGRv
X29uZV9pbml0Y2FsbCsweDEwMy8weDExMygpClsgICAgMC4xNzUwMDBdIGluaXRjYWxsIGNh
bGlicmF0ZV94b3JfYmxvY2tzKzB4MC8weDEyOCByZXR1cm5lZCB3aXRoIHByZWVtcHRpb24g
aW1iYWxhbmNlIApbICAgIDAuMTc1MDE2XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAwLjE3
NjAxN10gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xMS4w
LTAwMDA0LWcxM2NmNzAwICM4NTUKWyAgICAwLjE3NzAxNl0gIDAwMDAwMDAwMDAwMDAwMDAg
ZmZmZjg4MDAwZDBkYmUwMCBmZmZmZmZmZjgxNWYwZDFlIGZmZmY4ODAwMGQwZGJlNDgKWyAg
ICAwLjE3ODAwMF0gIGZmZmY4ODAwMGQwZGJlMzggZmZmZmZmZmY4MTA1MWJhYyBmZmZmZmZm
ZjgxMDAwMmViIGZmZmZmZmZmODFhMjQ5ODkKWyAgICAwLjE3ODAwMF0gIDAwMDAwMDAwMDAw
MDAwMDAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDBkMGRiZmQ4IGZmZmY4ODAwMGQwZGJl
OTgKWyAgICAwLjE3OTA4M10gQ2FsbCBUcmFjZToKWyAgICAwLjE3OTYxMV0gIFs8ZmZmZmZm
ZmY4MTVmMGQxZT5dIGR1bXBfc3RhY2srMHg0ZS8weDgyClsgICAgMC4xODAwMjBdICBbPGZm
ZmZmZmZmODEwNTFiYWM+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDc1LzB4OGUKWyAgICAw
LjE4MTAxOF0gIFs8ZmZmZmZmZmY4MTAwMDJlYj5dID8gZG9fb25lX2luaXRjYWxsKzB4MTAz
LzB4MTEzClsgICAgMC4xODIwMDBdICBbPGZmZmZmZmZmODFhMjQ5ODk+XSA/IGRvX3hvcl9z
cGVlZCsweGRkLzB4ZGQKWyAgICAwLjE4MjAwMF0gIFs8ZmZmZmZmZmY4MTA1MWMwYz5dIHdh
cm5fc2xvd3BhdGhfZm10KzB4NDcvMHg0OQpbICAgIDAuMTgyMDAwXSAgWzxmZmZmZmZmZjgx
MGM1NTY5Pl0gPyBmcmVlX3BhZ2VzKzB4NTIvMHg1NApbICAgIDAuMTgyMDAwXSAgWzxmZmZm
ZmZmZjgxYTI0OTg5Pl0gPyBkb194b3Jfc3BlZWQrMHhkZC8weGRkClsgICAgMC4xODMwMThd
ICBbPGZmZmZmZmZmODEwMDAyZWI+XSBkb19vbmVfaW5pdGNhbGwrMHgxMDMvMHgxMTMKWyAg
ICAwLjE4NDAyMF0gIFs8ZmZmZmZmZmY4MWEwNmVhYj5dIGtlcm5lbF9pbml0X2ZyZWVhYmxl
KzB4MTE1LzB4MTk2ClsgICAgMC4xODUwMThdICBbPGZmZmZmZmZmODFhMDY3MDc+XSA/IGRv
X2Vhcmx5X3BhcmFtKzB4ODgvMHg4OApbICAgIDAuMTg2MDE5XSAgWzxmZmZmZmZmZjgxNWU3
MWQ5Pl0gPyByZXN0X2luaXQrMHhiZC8weGJkClsgICAgMC4xODcwMThdICBbPGZmZmZmZmZm
ODE1ZTcxZTI+XSBrZXJuZWxfaW5pdCsweDkvMHhjYwpbICAgIDAuMTg4MDE5XSAgWzxmZmZm
ZmZmZjgxNjAwOGJjPl0gcmV0X2Zyb21fZm9yaysweDdjLzB4YjAKWyAgICAwLjE4OTAwMF0g
IFs8ZmZmZmZmZmY4MTVlNzFkOT5dID8gcmVzdF9pbml0KzB4YmQvMHhiZApbICAgIDAuMTg5
MDAwXSAtLS1bIGVuZCB0cmFjZSAyYmI5MTYyYjhhN2MyNmIwIF0tLS0KWyAgICAwLjE4OTAw
MF0gYXRvbWljNjQgdGVzdCBwYXNzZWQgZm9yIHg4Ni02NCBwbGF0Zm9ybSB3aXRoIENYOCBh
bmQgd2l0aCBTU0UKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMS0xMTIyLzEzY2Y3MDAz
NTI2ODkxYmZiN2FkMTJmYzVjZmYwMWNmOWU3MzRkYzIvZG1lc2ctcXVhbnRhbC1yb2FtLTQ1
OjIwMTMxMTIyMTE0MzI2Ong4Nl82NC1yYW5kY29uZmlnLWMxLTExMjI6My4xMS4wLTAwMDA0
LWcxM2NmNzAwOjg1NQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMxLTExMjIvMTNjZjcw
MDM1MjY4OTFiZmI3YWQxMmZjNWNmZjAxY2Y5ZTczNGRjMi9kbWVzZy1xdWFudGFsLXJvYW0t
MTA6MjAxMzExMjIxMTQzMjc6eDg2XzY0LXJhbmRjb25maWctYzEtMTEyMjozLjExLjAtMDAw
MDQtZzEzY2Y3MDA6ODU1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzEtMTEyMi8xM2Nm
NzAwMzUyNjg5MWJmYjdhZDEyZmM1Y2ZmMDFjZjllNzM0ZGMyL2RtZXNnLXF1YW50YWwtcm9h
bS0zNToyMDEzMTEyMjExNDMyODp4ODZfNjQtcmFuZGNvbmZpZy1jMS0xMTIyOjMuMTEuMC0w
MDAwNC1nMTNjZjcwMDo4NTUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMS0xMTIyLzEz
Y2Y3MDAzNTI2ODkxYmZiN2FkMTJmYzVjZmYwMWNmOWU3MzRkYzIvZG1lc2ctcXVhbnRhbC13
YWltZWEtMTI6MjAxMzExMjIxOTMyMTI6eDg2XzY0LXJhbmRjb25maWctYzEtMTEyMjozLjEx
LjAtMDAwMDQtZzEzY2Y3MDA6ODU1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzEtMTEy
Mi8xM2NmNzAwMzUyNjg5MWJmYjdhZDEyZmM1Y2ZmMDFjZjllNzM0ZGMyL2RtZXNnLXF1YW50
YWwteGJtLTI6MjAxMzExMjIxOTM2NTg6eDg2XzY0LXJhbmRjb25maWctYzEtMTEyMjozLjEx
LjAtMDAwMDQtZzEzY2Y3MDA6ODU1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzEtMTEy
Mi8xM2NmNzAwMzUyNjg5MWJmYjdhZDEyZmM1Y2ZmMDFjZjllNzM0ZGMyL2RtZXNnLXlvY3Rv
LXJvYW0tMTY6MjAxMzExMjIxMTQzMzE6eDg2XzY0LXJhbmRjb25maWctYzEtMTEyMjozLjEx
LjAtMDAwMDQtZzEzY2Y3MDA6ODU1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzEtMTEy
Mi8xM2NmNzAwMzUyNjg5MWJmYjdhZDEyZmM1Y2ZmMDFjZjllNzM0ZGMyL2RtZXNnLXlvY3Rv
LXJvYW0tMjU6MjAxMzExMjIxMTQzMzM6eDg2XzY0LXJhbmRjb25maWctYzEtMTEyMjozLjEx
LjAtMDAwMDQtZzEzY2Y3MDA6ODU1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzEtMTEy
Mi8xM2NmNzAwMzUyNjg5MWJmYjdhZDEyZmM1Y2ZmMDFjZjllNzM0ZGMyL2RtZXNnLXlvY3Rv
LXJvYW0tMzY6MjAxMzExMjIxMTQzMzQ6eDg2XzY0LXJhbmRjb25maWctYzEtMTEyMjozLjEx
LjAtMDAwMDQtZzEzY2Y3MDA6ODU1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzEtMTEy
Mi8xM2NmNzAwMzUyNjg5MWJmYjdhZDEyZmM1Y2ZmMDFjZjllNzM0ZGMyL2RtZXNnLXlvY3Rv
LXJvYW0tNDg6MjAxMzExMjIxMTQzMzU6eDg2XzY0LXJhbmRjb25maWctYzEtMTEyMjozLjEx
LjAtMDAwMDQtZzEzY2Y3MDA6ODU1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzEtMTEy
Mi8xM2NmNzAwMzUyNjg5MWJmYjdhZDEyZmM1Y2ZmMDFjZjllNzM0ZGMyL2RtZXNnLXlvY3Rv
LXdhaW1lYS00OjIwMTMxMTIyMTkzMjExOng4Nl82NC1yYW5kY29uZmlnLWMxLTExMjI6My4x
MS4wLTAwMDA0LWcxM2NmNzAwOjg1NQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMxLTEx
MjIvMTNjZjcwMDM1MjY4OTFiZmI3YWQxMmZjNWNmZjAxY2Y5ZTczNGRjMi9kbWVzZy1xdWFu
dGFsLXJvYW0tMjc6MjAxMzExMjIxMTQzMzc6eDg2XzY0LXJhbmRjb25maWctYzEtMTEyMjoz
LjExLjAtMDAwMDQtZzEzY2Y3MDA6ODU1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzEt
MTEyMi8xM2NmNzAwMzUyNjg5MWJmYjdhZDEyZmM1Y2ZmMDFjZjllNzM0ZGMyL2RtZXNnLXF1
YW50YWwtc3RvYWtsZXktNToyMDEzMTEyMjExNDMxNDp4ODZfNjQtcmFuZGNvbmZpZy1jMS0x
MTIyOjMuMTEuMC0wMDAwNC1nMTNjZjcwMDo4NTUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1jMS0xMTIyLzEzY2Y3MDAzNTI2ODkxYmZiN2FkMTJmYzVjZmYwMWNmOWU3MzRkYzIvZG1l
c2ctcXVhbnRhbC1sa3AtdHQwMi0yMzoyMDEzMTEyMjAyNDIwNjp4ODZfNjQtcmFuZGNvbmZp
Zy1jMS0xMTIyOjMuMTEuMC0wMDAwNC1nMTNjZjcwMDo4NTUKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1jMS0xMTIyLzEzY2Y3MDAzNTI2ODkxYmZiN2FkMTJmYzVjZmYwMWNmOWU3MzRk
YzIvZG1lc2ctcXVhbnRhbC1yb2FtLTk6MjAxMzExMjIxMTQzMzg6eDg2XzY0LXJhbmRjb25m
aWctYzEtMTEyMjozLjExLjAtMDAwMDQtZzEzY2Y3MDA6ODU1CjA6MTQ6MTQgYWxsX2dvb2Q6
YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bVJFUEVBVCBDT1VOVDogMjAgICMgL2NjL3dmZy91
c2ItYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDEgcmV2aXNpb24gbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMSBzdGVwKQpbMjA1NDU1MzZjZDhlYTk0OWM2MTUy
N2I2Mzk1ZWM4YzBkMmMyMzdiMV0gUkZDOiBkb194b3Jfc3BlZWQgQnJva2VuIG9uIFVNTCBk
byB0byBqaWZmaWVzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvaG9tZS93ZmcvdXNiL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMxLTExMjIvbGludXgtZGV2ZWw6
ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMxMTIyMDE1OToyMDU0NTUzNmNkOGVhOTQ5YzYxNTI3
YjYzOTVlYzhjMGQyYzIzN2IxOmJpc2VjdC11c2IKCjIwMTMtMTEtMjItMTE6NDM6NDggMjA1
NDU1MzZjZDhlYTk0OWM2MTUyN2I2Mzk1ZWM4YzBkMmMyMzdiMSBjb21waWxpbmcKNTUgcmVh
bCAgMTgxIHVzZXIgIDM2IHN5cyAgMzkzLjY5JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLWMx
LTExMjIKCjIwMTMtMTEtMjItMTE6NDU6MDMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMS4w
LTAwMDAyLWcyMDU0NTUzLi4uIFRFU1QgRkFJTFVSRQpbICAgIDAuMTcxMDE1XSAgICBnZW5l
cmljX3NzZTogIDU5MTIuMDAwIE1CL3NlYwpbICAgIDAuMTcxOTM1XSB4b3I6IHVzaW5nIGZ1
bmN0aW9uOiBwcmVmZXRjaDY0LXNzZSAoNjg3Ni4zNjMgTUIvc2VjKQpbICAgIDAuMTcyMDIw
XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAwLjE3MzAwMF0g
V0FSTklORzogQ1BVOiAwIFBJRDogMSBhdCBpbml0L21haW4uYzo2OTkgZG9fb25lX2luaXRj
YWxsKzB4MTAzLzB4MTEzKCkKWyAgICAwLjE3MzAwMF0gaW5pdGNhbGwgY2FsaWJyYXRlX3hv
cl9ibG9ja3MrMHgwLzB4MTI4IHJldHVybmVkIHdpdGggcHJlZW1wdGlvbiBpbWJhbGFuY2Ug
ClsgICAgMC4xNzMwMTVdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDAuMTc0MDE3XSBDUFU6
IDAgUElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjExLjAtMDAwMDItZzIw
NTQ1NTMgIzg1NgpbICAgIDAuMTc1MDE2XSAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDBk
MGRiZTAwIGZmZmZmZmZmODE1ZjBkMWUgZmZmZjg4MDAwZDBkYmU0OApbICAgIDAuMTc3MDE0
XSAgZmZmZjg4MDAwZDBkYmUzOCBmZmZmZmZmZjgxMDUxYmFjIGZmZmZmZmZmODEwMDAyZWIg
ZmZmZmZmZmY4MWEyNDk4OQpbICAgIDAuMTc4NzUyXSAgMDAwMDAwMDAwMDAwMDAwMCAwMDAw
MDAwMDAwMDAwMDAwIGZmZmY4ODAwMGQwZGJmZDggZmZmZjg4MDAwZDBkYmU5OApbICAgIDAu
MTgwNDEyXSBDYWxsIFRyYWNlOgpbICAgIDAuMTgxMDIxXSAgWzxmZmZmZmZmZjgxNWYwZDFl
Pl0gZHVtcF9zdGFjaysweDRlLzB4ODIKWyAgICAwLjE4MjAyMF0gIFs8ZmZmZmZmZmY4MTA1
MWJhYz5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4NzUvMHg4ZQpbICAgIDAuMTgzMDE4XSAg
WzxmZmZmZmZmZjgxMDAwMmViPl0gPyBkb19vbmVfaW5pdGNhbGwrMHgxMDMvMHgxMTMKWyAg
ICAwLjE4NDAzM10gIFs8ZmZmZmZmZmY4MWEyNDk4OT5dID8gZG9feG9yX3NwZWVkKzB4ZGQv
MHhkZApbICAgIDAuMTg1MDE4XSAgWzxmZmZmZmZmZjgxMDUxYzBjPl0gd2Fybl9zbG93cGF0
aF9mbXQrMHg0Ny8weDQ5ClsgICAgMC4xODYwMDBdICBbPGZmZmZmZmZmODEwYzU1Njk+XSA/
IGZyZWVfcGFnZXMrMHg1Mi8weDU0ClsgICAgMC4xODYwMDBdICBbPGZmZmZmZmZmODFhMjQ5
ODk+XSA/IGRvX3hvcl9zcGVlZCsweGRkLzB4ZGQKWyAgICAwLjE4NjAwMF0gIFs8ZmZmZmZm
ZmY4MTAwMDJlYj5dIGRvX29uZV9pbml0Y2FsbCsweDEwMy8weDExMwpbICAgIDAuMTg2MDAw
XSAgWzxmZmZmZmZmZjgxYTA2ZWFiPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgxMTUvMHgx
OTYKWyAgICAwLjE4NjAwMF0gIFs8ZmZmZmZmZmY4MWEwNjcwNz5dID8gZG9fZWFybHlfcGFy
YW0rMHg4OC8weDg4ClsgICAgMC4xODYwMDBdICBbPGZmZmZmZmZmODE1ZTcxZDk+XSA/IHJl
c3RfaW5pdCsweGJkLzB4YmQKWyAgICAwLjE4NjAwMF0gIFs8ZmZmZmZmZmY4MTVlNzFlMj5d
IGtlcm5lbF9pbml0KzB4OS8weGNjClsgICAgMC4xODYwMDBdICBbPGZmZmZmZmZmODE2MDA4
YmM+XSByZXRfZnJvbV9mb3JrKzB4N2MvMHhiMApbICAgIDAuMTg2MDAwXSAgWzxmZmZmZmZm
ZjgxNWU3MWQ5Pl0gPyByZXN0X2luaXQrMHhiZC8weGJkClsgICAgMC4xODYwMDBdIC0tLVsg
ZW5kIHRyYWNlIGFiOTlkMzY4MTAyYTEwZjcgXS0tLQpbICAgIDAuMTg2MDAwXSBhdG9taWM2
NCB0ZXN0IHBhc3NlZCBmb3IgeDg2LTY0IHBsYXRmb3JtIHdpdGggQ1g4IGFuZCB3aXRoIFNT
RQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMxLTExMjIvMjA1NDU1MzZjZDhlYTk0OWM2
MTUyN2I2Mzk1ZWM4YzBkMmMyMzdiMS9kbWVzZy1xdWFudGFsLXJvYW0tMTE6MjAxMzExMjIx
MTQ2MTQ6eDg2XzY0LXJhbmRjb25maWctYzEtMTEyMjozLjExLjAtMDAwMDItZzIwNTQ1NTM6
ODU2Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzEtMTEyMi8yMDU0NTUzNmNkOGVhOTQ5
YzYxNTI3YjYzOTVlYzhjMGQyYzIzN2IxL2RtZXNnLXF1YW50YWwtc25iLTE1OjIwMTMxMTIy
MTE0NjE0Ong4Nl82NC1yYW5kY29uZmlnLWMxLTExMjI6My4xMS4wLTAwMDAyLWcyMDU0NTUz
Ojg1Ngova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMxLTExMjIvMjA1NDU1MzZjZDhlYTk0
OWM2MTUyN2I2Mzk1ZWM4YzBkMmMyMzdiMS9kbWVzZy1xdWFudGFsLWxrcC10dDAyLTEwOjIw
MTMxMTIyMDI0NDQ4Ong4Nl82NC1yYW5kY29uZmlnLWMxLTExMjI6My4xMS4wLTAwMDAyLWcy
MDU0NTUzOjg1Ngova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMxLTExMjIvMjA1NDU1MzZj
ZDhlYTk0OWM2MTUyN2I2Mzk1ZWM4YzBkMmMyMzdiMS9kbWVzZy1xdWFudGFsLWxrcC10dDAy
LTE1OjIwMTMxMTIyMDI0NDU2Ong4Nl82NC1yYW5kY29uZmlnLWMxLTExMjI6My4xMS4wLTAw
MDAyLWcyMDU0NTUzOjg1Ngova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMxLTExMjIvMjA1
NDU1MzZjZDhlYTk0OWM2MTUyN2I2Mzk1ZWM4YzBkMmMyMzdiMS9kbWVzZy1xdWFudGFsLWxr
cC10dDAyLTc6MjAxMzExMjIwMjQ0NTY6eDg2XzY0LXJhbmRjb25maWctYzEtMTEyMjozLjEx
LjAtMDAwMDItZzIwNTQ1NTM6ODU2Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzEtMTEy
Mi8yMDU0NTUzNmNkOGVhOTQ5YzYxNTI3YjYzOTVlYzhjMGQyYzIzN2IxL2RtZXNnLXF1YW50
YWwtc25iLTE2OjIwMTMxMTIyMTE0NjE5Ong4Nl82NC1yYW5kY29uZmlnLWMxLTExMjI6My4x
MS4wLTAwMDAyLWcyMDU0NTUzOjg1Ngova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMxLTEx
MjIvMjA1NDU1MzZjZDhlYTk0OWM2MTUyN2I2Mzk1ZWM4YzBkMmMyMzdiMS9kbWVzZy1xdWFu
dGFsLXNuYi0xOjIwMTMxMTIyMTE0NjI0Ong4Nl82NC1yYW5kY29uZmlnLWMxLTExMjI6My4x
MS4wLTAwMDAyLWcyMDU0NTUzOjg1Ngova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMxLTEx
MjIvMjA1NDU1MzZjZDhlYTk0OWM2MTUyN2I2Mzk1ZWM4YzBkMmMyMzdiMS9kbWVzZy1xdWFu
dGFsLXNuYi0zOToyMDEzMTEyMjExNDYyMDp4ODZfNjQtcmFuZGNvbmZpZy1jMS0xMTIyOjMu
MTEuMC0wMDAwMi1nMjA1NDU1Mzo4NTYKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMS0x
MTIyLzIwNTQ1NTM2Y2Q4ZWE5NDljNjE1MjdiNjM5NWVjOGMwZDJjMjM3YjEvZG1lc2cteW9j
dG8tbGtwLXR0MDItMTY6MjAxMzExMjIwMjQ0NTQ6eDg2XzY0LXJhbmRjb25maWctYzEtMTEy
MjozLjExLjAtMDAwMDItZzIwNTQ1NTM6ODU2Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
YzEtMTEyMi8yMDU0NTUzNmNkOGVhOTQ5YzYxNTI3YjYzOTVlYzhjMGQyYzIzN2IxL2RtZXNn
LXlvY3RvLWxrcC10dDAyLTU6MjAxMzExMjIwMjQ0NTU6eDg2XzY0LXJhbmRjb25maWctYzEt
MTEyMjozLjExLjAtMDAwMDItZzIwNTQ1NTM6ODU2Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctYzEtMTEyMi8yMDU0NTUzNmNkOGVhOTQ5YzYxNTI3YjYzOTVlYzhjMGQyYzIzN2IxL2Rt
ZXNnLXlvY3RvLXJvYW0tMzg6MjAxMzExMjIxMTQ2Mjc6eDg2XzY0LXJhbmRjb25maWctYzEt
MTEyMjozLjExLjAtMDAwMDItZzIwNTQ1NTM6ODU2Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctYzEtMTEyMi8yMDU0NTUzNmNkOGVhOTQ5YzYxNTI3YjYzOTVlYzhjMGQyYzIzN2IxL2Rt
ZXNnLXlvY3RvLXJvYW0tNDI6MjAxMzExMjIxMTQ2MjM6eDg2XzY0LXJhbmRjb25maWctYzEt
MTEyMjozLjExLjAtMDAwMDItZzIwNTQ1NTM6ODU2Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctYzEtMTEyMi8yMDU0NTUzNmNkOGVhOTQ5YzYxNTI3YjYzOTVlYzhjMGQyYzIzN2IxL2Rt
ZXNnLXlvY3RvLXJvYW0tNDoyMDEzMTEyMjExNDYxOTp4ODZfNjQtcmFuZGNvbmZpZy1jMS0x
MTIyOjMuMTEuMC0wMDAwMi1nMjA1NDU1Mzo4NTYKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1jMS0xMTIyLzIwNTQ1NTM2Y2Q4ZWE5NDljNjE1MjdiNjM5NWVjOGMwZDJjMjM3YjEvZG1l
c2cteW9jdG8tc3RvYWtsZXktMjoyMDEzMTEyMjExNDU1Nzp4ODZfNjQtcmFuZGNvbmZpZy1j
MS0xMTIyOjMuMTEuMC0wMDAwMi1nMjA1NDU1Mzo4NTYKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1jMS0xMTIyLzIwNTQ1NTM2Y2Q4ZWE5NDljNjE1MjdiNjM5NWVjOGMwZDJjMjM3YjEv
ZG1lc2cteW9jdG8td2FpbWVhLTEwOjIwMTMxMTIyMTkzNTA3Ong4Nl82NC1yYW5kY29uZmln
LWMxLTExMjI6My4xMS4wLTAwMDAyLWcyMDU0NTUzOjg1Ngova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWMxLTExMjIvMjA1NDU1MzZjZDhlYTk0OWM2MTUyN2I2Mzk1ZWM4YzBkMmMyMzdi
MS9kbWVzZy15b2N0by1sa3Atc3QwMS02OjIwMTMxMTIyMTkzMzE0Ong4Nl82NC1yYW5kY29u
ZmlnLWMxLTExMjI6My4xMS4wLTAwMDAyLWcyMDU0NTUzOjg1Ngova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWMxLTExMjIvMjA1NDU1MzZjZDhlYTk0OWM2MTUyN2I2Mzk1ZWM4YzBkMmMy
MzdiMS9kbWVzZy15b2N0by1yb2FtLTI0OjIwMTMxMTIyMTE0NjI4Ong4Nl82NC1yYW5kY29u
ZmlnLWMxLTExMjI6My4xMS4wLTAwMDAyLWcyMDU0NTUzOjg1NgowOjE3OjE3IGFsbF9nb29k
OmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW1SRVBFQVQgQ09VTlQ6IDIwICAjIC9jYy93Zmcv
dXNiLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAwIHN0ZXBzKQpbNGE5YTRiMzUyOGFmY2U0OGQz
ZjRiMWMwN2I5ODgwNDBlNzgxMTJlMl0gcG5mczogUHJvcGVyIGRlbGF5IGZvciBORlM0RVJS
X1JFQ0FMTENPTkZMSUNUIGluIGxheW91dF9nZXRfZG9uZQpydW5uaW5nIC9jL2tlcm5lbC10
ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3VzYi9vYmotYmlz
ZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZp
Zy1jMS0xMTIyL2xpbnV4LWRldmVsOmRldmVsLWNhaXJvLXg4Nl82NC0yMDEzMTEyMjAxNTk6
NGE5YTRiMzUyOGFmY2U0OGQzZjRiMWMwN2I5ODgwNDBlNzgxMTJlMjpiaXNlY3QtdXNiCgoy
MDEzLTExLTIyLTExOjQ2OjM1IDRhOWE0YjM1MjhhZmNlNDhkM2Y0YjFjMDdiOTg4MDQwZTc4
MTEyZTIgY29tcGlsaW5nCjY0IHJlYWwgIDE4MiB1c2VyICAzNCBzeXMgIDMzNC4yNSUgY3B1
IAl4ODZfNjQtcmFuZGNvbmZpZy1jMS0xMTIyCgoyMDEzLTExLTIyLTExOjQ4OjAxIGRldGVj
dGluZyBib290IHN0YXRlIDMuMTEuMC0wMDAwMS1nNGE5YTRiMy4uCTgJMjAgU1VDQ0VTUwoK
MjA1NDU1MzZjZDhlYTk0OWM2MTUyN2I2Mzk1ZWM4YzBkMmMyMzdiMSBpcyB0aGUgZmlyc3Qg
YmFkIGNvbW1pdApjb21taXQgMjA1NDU1MzZjZDhlYTk0OWM2MTUyN2I2Mzk1ZWM4YzBkMmMy
MzdiMQpBdXRob3I6IEJvYXogSGFycm9zaCA8YmhhcnJvc2hAcGFuYXNhcy5jb20+CkRhdGU6
ICAgVGh1IEp1bCAxOSAxNToyMjozNyAyMDEyICswMzAwCgogICAgUkZDOiBkb194b3Jfc3Bl
ZWQgQnJva2VuIG9uIFVNTCBkbyB0byBqaWZmaWVzCiAgICAKICAgIFJlbWVtYmVyIHRoYXQg
aGFuZyBJIHJlcG9ydGVkIGEgd2hpbGUgYmFjayBvbiBVTUwuIFdlbGwKICAgIEknbSBhdCBp
dCBhZ2FpbiwgYW5kIGl0IHN0aWxsIGhhbmdzIGFuZCBJIGZvdW5kIHdoeS4KICAgIAogICAg
SSBoYXZlIGRwcmludGVkIGppZmZpZXMgYW5kIGl0IG5ldmVyIGFkdmFuY2VzIGR1cmluZyB0
aGUKICAgIGxvb3AgYXQgZG9feG9yX3NwZWVkLiBUaGVyZSBmb3IgaXQgaXMgc3R1Y2sgaW4g
YW4gZW5kbGVzcwogICAgbG9vcC4gSSBoYXZlIGFsc28gZHByaW50ZWQgY3VycmVudF9rZXJu
ZWxfdGltZSgpIGFuZCBpdAogICAgcmV0dXJucyB0aGUgc2FtZSBjb25zdGFudCB2YWx1ZSBh
cyB3ZWxsLgogICAgCiAgICBOb3RlIHRoYXQgaXQgZG9lcyB1c3VhbGx5IHdvcmsgb24gVU1M
LCBvbmx5IGR1cmluZwogICAgdGhlIG1vZHByb2JlIG9mIHhvci5rbyB3aGlsZSB0aGF0IHRl
c3QgaXMgcnVubmluZy4gSXQgbG9va3MKICAgIGxpa2Ugc29tZSBsdWNraW5nIGlzIHByZXZl
bnRpbmcgdGhlIGNsb2NrIGZyb20gdGlja2luZy4KICAgIAogICAgSG93ZXZlciBrdGltZV9n
ZXRfdHMgZG9lcyB3b3JrIGZvciBtZSBzbyBJIGNoYW5nZWQgdGhlIGNvZGUKICAgIGFzIGJl
bG93LCBzbyBJIGNhbiB3b3JrLiBTZWUgaG93IEkgcHV0IHNldmVyYWwgc2FmZXR5CiAgICBn
dWFyZHMsIHRvIG5ldmVyIGdldCBoYW5ncyBhZ2Fpbi4KICAgIEFuZCBJIHRoaW5rIG15IHRp
bWUgYmFzZWQgYXBwcm9hY2ggaXMgbW9yZSBhY2N1cmF0ZSB0aGVuCiAgICBwcmV2aW91cyBz
eXN0ZW0uCiAgICAKICAgIFVNTCBndXlzIHBsZWFzZSBpbnZlc3RpZ2F0ZSB0aGUgamlmZmll
cyBpc3N1ZT8gd2hhdCBpcwogICAgeG9yLmtvIG5vdCBkb2luZyByaWdodD8KICAgIAogICAg
U2lnbmVkLW9mZi1ieTogQm9heiBIYXJyb3NoIDxiaGFycm9zaEBwYW5hc2FzLmNvbT4KCjow
NDAwMDAgMDQwMDAwIGM2MDg2ZGMxOGJkMjRhODdjMmYwZDYxODFhNDcwNWM0Yjc0M2VkYWQg
MzgxNGQyNDcxOTc1NjIyN2QxNWRiMTI1OGNkNDcyNmNkZWUzNmMwNyBNCWNyeXB0bwpiaXNl
Y3QgcnVuIHN1Y2Nlc3MKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82
NC1yYW5kY29uZmlnLWMxLTExMjIvbGludXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIw
MTMxMTIyMDE1OTo0YTlhNGIzNTI4YWZjZTQ4ZDNmNGIxYzA3Yjk4ODA0MGU3ODExMmUyOmJp
c2VjdC11c2IKCjIwMTMtMTEtMjItMTE6NTA6MDcgNGE5YTRiMzUyOGFmY2U0OGQzZjRiMWMw
N2I5ODgwNDBlNzgxMTJlMiByZXVzZSAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMxLTEx
MjIvNGE5YTRiMzUyOGFmY2U0OGQzZjRiMWMwN2I5ODgwNDBlNzgxMTJlMi92bWxpbnV6LTMu
MTEuMC0wMDAwMS1nNGE5YTRiMwoKMjAxMy0xMS0yMi0xMTo1MDowOCBkZXRlY3RpbmcgYm9v
dCBzdGF0ZSAuLgkzNwk2MCBTVUNDRVNTCgpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0veDg2XzY0LXJhbmRjb25maWctYzEtMTEyMi9saW51eC1kZXZlbDpkZXZlbC1jYWly
by14ODZfNjQtMjAxMzExMjIwMTU5OmIyNDJiZmY1NDhjMzQ1MTBmZDliN2YwZTI5Yjg4NTI2
M2RmYjg5MDM6YmlzZWN0LXVzYgogVEVTVCBGQUlMVVJFClsgICAgMC4xNTEwMTRdICAgIGdl
bmVyaWNfc3NlOiAgNDc2NC4zNjMgTUIvc2VjClsgICAgMC4xNTE3NjNdIHhvcjogdXNpbmcg
ZnVuY3Rpb246IHByZWZldGNoNjQtc3NlICg1MzUzLjQ1NCBNQi9zZWMpClsgICAgMC4xNTIw
MTddIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDAuMTUzMDIx
XSBXQVJOSU5HOiBDUFU6IDAgUElEOiAxIGF0IGluaXQvbWFpbi5jOjcxMSBkb19vbmVfaW5p
dGNhbGwrMHgxMDUvMHgxMTUoKQpbICAgIDAuMTU0MDI0XSBpbml0Y2FsbCBjYWxpYnJhdGVf
eG9yX2Jsb2NrcysweDAvMHgxNDQgcmV0dXJuZWQgd2l0aCBwcmVlbXB0aW9uIGltYmFsYW5j
ZSAKWyAgICAwLjE1NTAxM10gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMC4xNTYwNzNdIENQ
VTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTIuMC0xMTI4NS1n
YjI0MmJmZiAjOTEKWyAgICAwLjE1NzAxNF0gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAw
ZDBkZGUwMCBmZmZmZmZmZjgxNjFhY2M1IGZmZmY4ODAwMGQwZGRlNDgKWyAgICAwLjE1OTA3
MF0gIGZmZmY4ODAwMGQwZGRlMzggZmZmZmZmZmY4MTA1MmRlOSBmZmZmZmZmZjgxMDAwMzE2
IGZmZmZmZmZmODFhNzdjZmQKWyAgICAwLjE2MDYyMF0gIDAwMDAwMDAwMDAwMDAwMDAgMDAw
MDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMGQwZGRlOTgKWyAgICAw
LjE2MjA3MF0gQ2FsbCBUcmFjZToKWyAgICAwLjE2MjUxMV0gIFs8ZmZmZmZmZmY4MTYxYWNj
NT5dIGR1bXBfc3RhY2srMHg0ZS8weDdhClsgICAgMC4xNjMwMThdICBbPGZmZmZmZmZmODEw
NTJkZTk+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDc1LzB4OGUKWyAgICAwLjE2NDAxNl0g
IFs8ZmZmZmZmZmY4MTAwMDMxNj5dID8gZG9fb25lX2luaXRjYWxsKzB4MTA1LzB4MTE1Clsg
ICAgMC4xNjUwMTVdICBbPGZmZmZmZmZmODFhNzdjZmQ+XSA/IGRvX3hvcl9zcGVlZCsweGRk
LzB4ZGQKWyAgICAwLjE2NjAxNl0gIFs8ZmZmZmZmZmY4MTA1MmU0OT5dIHdhcm5fc2xvd3Bh
dGhfZm10KzB4NDcvMHg0OQpbICAgIDAuMTY3MDE4XSAgWzxmZmZmZmZmZjgxMGM4MzgyPl0g
PyBmcmVlX3BhZ2VzKzB4NTEvMHg1MwpbICAgIDAuMTY4MDE2XSAgWzxmZmZmZmZmZjgxYTc3
Y2ZkPl0gPyBkb194b3Jfc3BlZWQrMHhkZC8weGRkClsgICAgMC4xNjkwMTZdICBbPGZmZmZm
ZmZmODEwMDAzMTY+XSBkb19vbmVfaW5pdGNhbGwrMHgxMDUvMHgxMTUKWyAgICAwLjE3MDAx
OF0gIFs8ZmZmZmZmZmY4MWE1OWVkNj5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MTE1LzB4
MTliClsgICAgMC4xNzEwMTZdICBbPGZmZmZmZmZmODFhNTk3MDc+XSA/IGRvX2Vhcmx5X3Bh
cmFtKzB4ODgvMHg4OApbICAgIDAuMTcyMDE3XSAgWzxmZmZmZmZmZjgxNjEwZmY5Pl0gPyBy
ZXN0X2luaXQrMHhiZC8weGJkClsgICAgMC4xNzMwMTZdICBbPGZmZmZmZmZmODE2MTEwMDI+
XSBrZXJuZWxfaW5pdCsweDkvMHhmYQpbICAgIDAuMTc0MDE3XSAgWzxmZmZmZmZmZjgxNjJh
OThjPl0gcmV0X2Zyb21fZm9yaysweDdjLzB4YjAKWyAgICAwLjE3NTAxNl0gIFs8ZmZmZmZm
ZmY4MTYxMGZmOT5dID8gcmVzdF9pbml0KzB4YmQvMHhiZApbICAgIDAuMTc2MDMxXSAtLS1b
IGVuZCB0cmFjZSA2MTIyNTVlYTA4ZGFlZTE3IF0tLS0KWyAgICAwLjE3NzAxNl0gYXRvbWlj
NjQgdGVzdCBwYXNzZWQgZm9yIHg4Ni02NCBwbGF0Zm9ybSB3aXRoIENYOCBhbmQgd2l0aCBT
U0UKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMS0xMTIyL2IyNDJiZmY1NDhjMzQ1MTBm
ZDliN2YwZTI5Yjg4NTI2M2RmYjg5MDMvZG1lc2ctcXVhbnRhbC1yb2FtLTEzOjIwMTMxMTIy
MDIyMDQ3Ong4Nl82NC1yYW5kY29uZmlnLWMxLTExMjI6My4xMi4wLTExMjg1LWdiMjQyYmZm
OjkxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzEtMTEyMi9iMjQyYmZmNTQ4YzM0NTEw
ZmQ5YjdmMGUyOWI4ODUyNjNkZmI4OTAzL2RtZXNnLXlvY3RvLWlubi0zNzoyMDEzMTEyMjA4
NTg0Mjp4ODZfNjQtcmFuZGNvbmZpZy1jMS0xMTIyOjMuMTIuMC0xMTI4NS1nYjI0MmJmZjo5
MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMxLTExMjIvYjI0MmJmZjU0OGMzNDUxMGZk
OWI3ZjBlMjliODg1MjYzZGZiODkwMy9kbWVzZy1xdWFudGFsLXJvYW0tMToyMDEzMTEyMjAy
MTYzODp4ODZfNjQtcmFuZGNvbmZpZy1jMS0xMTIyOjMuMTIuMC0xMTI4NS1nYjI0MmJmZjo5
MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMxLTExMjIvYjI0MmJmZjU0OGMzNDUxMGZk
OWI3ZjBlMjliODg1MjYzZGZiODkwMy9kbWVzZy15b2N0by1pbm4tMjA6MjAxMzExMjIwODU4
Mjk6eDg2XzY0LXJhbmRjb25maWctYzEtMTEyMjozLjEyLjAtMTEyODUtZ2IyNDJiZmY6OTEK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMS0xMTIyL2IyNDJiZmY1NDhjMzQ1MTBmZDli
N2YwZTI5Yjg4NTI2M2RmYjg5MDMvZG1lc2ctcXVhbnRhbC1pbm4tMjM6MjAxMzExMjIwOTAy
MjE6eDg2XzY0LXJhbmRjb25maWctYzEtMTEyMjozLjEyLjAtMTEyODUtZ2IyNDJiZmY6OTEK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMS0xMTIyL2IyNDJiZmY1NDhjMzQ1MTBmZDli
N2YwZTI5Yjg4NTI2M2RmYjg5MDMvZG1lc2ctcXVhbnRhbC1pbm4tMjQ6MjAxMzExMjIwOTAy
MjE6eDg2XzY0LXJhbmRjb25maWctYzEtMTEyMjozLjEyLjAtMTEyODUtZ2IyNDJiZmY6OTEK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMS0xMTIyL2IyNDJiZmY1NDhjMzQ1MTBmZDli
N2YwZTI5Yjg4NTI2M2RmYjg5MDMvZG1lc2ctcXVhbnRhbC1yb2FtLTIxOjIwMTMxMTIyMDg1
ODM0Ong4Nl82NC1yYW5kY29uZmlnLWMxLTExMjI6My4xMi4wLTExMjg1LWdiMjQyYmZmOjkx
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzEtMTEyMi9iMjQyYmZmNTQ4YzM0NTEwZmQ5
YjdmMGUyOWI4ODUyNjNkZmI4OTAzL2RtZXNnLXlvY3RvLXJvYW0tMTQ6MjAxMzExMjIwMjE5
MDE6eDg2XzY0LXJhbmRjb25maWctYzEtMTEyMjozLjEyLjAtMTEyODUtZ2IyNDJiZmY6OTEK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMS0xMTIyL2IyNDJiZmY1NDhjMzQ1MTBmZDli
N2YwZTI5Yjg4NTI2M2RmYjg5MDMvZG1lc2ctcXVhbnRhbC1yb2FtLTM3OjIwMTMxMTIyMDg1
ODI4Ong4Nl82NC1yYW5kY29uZmlnLWMxLTExMjI6My4xMi4wLTExMjg1LWdiMjQyYmZmOjkx
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzEtMTEyMi9iMjQyYmZmNTQ4YzM0NTEwZmQ5
YjdmMGUyOWI4ODUyNjNkZmI4OTAzL2RtZXNnLXF1YW50YWwtYmVucy02OjIwMTMxMTIyMDIx
NzA2Ong4Nl82NC1yYW5kY29uZmlnLWMxLTExMjI6My4xMi4wLTExMjg1LWdiMjQyYmZmOjkx
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzEtMTEyMi9iMjQyYmZmNTQ4YzM0NTEwZmQ5
YjdmMGUyOWI4ODUyNjNkZmI4OTAzL2RtZXNnLXlvY3RvLWpha2V0b3duLTE1OjIwMTMxMTIy
MDg1ODUzOng4Nl82NC1yYW5kY29uZmlnLWMxLTExMjI6My4xMi4wLTExMjg1LWdiMjQyYmZm
OjkxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzEtMTEyMi9iMjQyYmZmNTQ4YzM0NTEw
ZmQ5YjdmMGUyOWI4ODUyNjNkZmI4OTAzL2RtZXNnLXF1YW50YWwtaW5uLTQyOjIwMTMxMTIy
MDkwMjEwOng4Nl82NC1yYW5kY29uZmlnLWMxLTExMjI6My4xMi4wLTExMjg1LWdiMjQyYmZm
OjkxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzEtMTEyMi9iMjQyYmZmNTQ4YzM0NTEw
ZmQ5YjdmMGUyOWI4ODUyNjNkZmI4OTAzL2RtZXNnLXF1YW50YWwtY2Fpcm8tOToyMDEzMTEy
MjA4NTgzMjp4ODZfNjQtcmFuZGNvbmZpZy1jMS0xMTIyOjMuMTIuMC0xMTI4NS1nYjI0MmJm
Zjo5MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMxLTExMjIvYjI0MmJmZjU0OGMzNDUx
MGZkOWI3ZjBlMjliODg1MjYzZGZiODkwMy9kbWVzZy15b2N0by1yb2FtLTE6MjAxMzExMjIw
MjE5Mjg6eDg2XzY0LXJhbmRjb25maWctYzEtMTEyMjozLjEyLjAtMTEyODUtZ2IyNDJiZmY6
OTEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMS0xMTIyL2IyNDJiZmY1NDhjMzQ1MTBm
ZDliN2YwZTI5Yjg4NTI2M2RmYjg5MDMvZG1lc2ctcXVhbnRhbC1yb2FtLTMxOjIwMTMxMTIy
MDg1ODM4Ong4Nl82NC1yYW5kY29uZmlnLWMxLTExMjI6My4xMi4wLTExMjg1LWdiMjQyYmZm
OjkxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzEtMTEyMi9iMjQyYmZmNTQ4YzM0NTEw
ZmQ5YjdmMGUyOWI4ODUyNjNkZmI4OTAzL2RtZXNnLXF1YW50YWwtd2FpbWVhLTE1OjIwMTMx
MTIyMTAwOTMyOng4Nl82NC1yYW5kY29uZmlnLWMxLTExMjI6My4xMi4wLTExMjg1LWdiMjQy
YmZmOjkxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzEtMTEyMi9iMjQyYmZmNTQ4YzM0
NTEwZmQ5YjdmMGUyOWI4ODUyNjNkZmI4OTAzL2RtZXNnLXlvY3RvLXNuYi0yMzoyMDEzMTEy
MjA5MDIyNTp4ODZfNjQtcmFuZGNvbmZpZy1jMS0xMTIyOjMuMTIuMC0xMTI4NS1nYjI0MmJm
Zjo5MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMxLTExMjIvYjI0MmJmZjU0OGMzNDUx
MGZkOWI3ZjBlMjliODg1MjYzZGZiODkwMy9kbWVzZy15b2N0by1yb2FtLTI3OjIwMTMxMTIy
MDkwMjIzOng4Nl82NC1yYW5kY29uZmlnLWMxLTExMjI6My4xMi4wLTExMjg1LWdiMjQyYmZm
OjkxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzEtMTEyMi9iMjQyYmZmNTQ4YzM0NTEw
ZmQ5YjdmMGUyOWI4ODUyNjNkZmI4OTAzL2RtZXNnLXF1YW50YWwtbGtwLXR0MDItMTg6MjAx
MzExMjEyMzU3MDU6eDg2XzY0LXJhbmRjb25maWctYzEtMTEyMjozLjEyLjAtMTEyODUtZ2Iy
NDJiZmY6OTEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMS0xMTIyL2IyNDJiZmY1NDhj
MzQ1MTBmZDliN2YwZTI5Yjg4NTI2M2RmYjg5MDMvZG1lc2ctcXVhbnRhbC14Ym0tMzoyMDEz
MTEyMjEwMTUxNzp4ODZfNjQtcmFuZGNvbmZpZy1jMS0xMTIyOjMuMTIuMC0xMTI4NS1nYjI0
MmJmZjo5MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMxLTExMjIvYjI0MmJmZjU0OGMz
NDUxMGZkOWI3ZjBlMjliODg1MjYzZGZiODkwMy9kbWVzZy1xdWFudGFsLWxrcC1zdDAxLTE6
MjAxMzExMjIxNjQ1MjE6eDg2XzY0LXJhbmRjb25maWctYzEtMTEyMjozLjEyLjAtMTEyODUt
Z2IyNDJiZmY6OTEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMS0xMTIyL2IyNDJiZmY1
NDhjMzQ1MTBmZDliN2YwZTI5Yjg4NTI2M2RmYjg5MDMvZG1lc2ctcXVhbnRhbC1pbm4tMToy
MDEzMTEyMjA5MDIxNzp4ODZfNjQtcmFuZGNvbmZpZy1jMS0xMTIyOjMuMTIuMC0xMTI4NS1n
YjI0MmJmZjo5MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMxLTExMjIvYjI0MmJmZjU0
OGMzNDUxMGZkOWI3ZjBlMjliODg1MjYzZGZiODkwMy9kbWVzZy15b2N0by1pbm4tMTE6MjAx
MzExMjIwODU4Mzc6eDg2XzY0LXJhbmRjb25maWctYzEtMTEyMjozLjEyLjAtMTEyODUtZ2Iy
NDJiZmY6OTEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMS0xMTIyL2IyNDJiZmY1NDhj
MzQ1MTBmZDliN2YwZTI5Yjg4NTI2M2RmYjg5MDMvZG1lc2cteW9jdG8td2FpbWVhLTEyOjIw
MTMxMTIyMTAwOTIzOng4Nl82NC1yYW5kY29uZmlnLWMxLTExMjI6My4xMi4wLTExMjg1LWdi
MjQyYmZmOjkxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzEtMTEyMi9iMjQyYmZmNTQ4
YzM0NTEwZmQ5YjdmMGUyOWI4ODUyNjNkZmI4OTAzL2RtZXNnLXlvY3RvLWJlbnMtNjoyMDEz
MTEyMjAyMTY0Njp4ODZfNjQtcmFuZGNvbmZpZy1jMS0xMTIyOjMuMTIuMC0xMTI4NS1nYjI0
MmJmZjo5MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMxLTExMjIvYjI0MmJmZjU0OGMz
NDUxMGZkOWI3ZjBlMjliODg1MjYzZGZiODkwMy9kbWVzZy1xdWFudGFsLWlubi00NDoyMDEz
MTEyMjA5MDIyMDp4ODZfNjQtcmFuZGNvbmZpZy1jMS0xMTIyOjMuMTIuMC0xMTI4NS1nYjI0
MmJmZjo5MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWMxLTExMjIvYjI0MmJmZjU0OGMz
NDUxMGZkOWI3ZjBlMjliODg1MjYzZGZiODkwMy9kbWVzZy15b2N0by1zbmItMzQ6MjAxMzEx
MjIwOTAyMjE6eDg2XzY0LXJhbmRjb25maWctYzEtMTEyMjozLjEyLjAtMTEyODUtZ2IyNDJi
ZmY6OTEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1jMS0xMTIyL2IyNDJiZmY1NDhjMzQ1
MTBmZDliN2YwZTI5Yjg4NTI2M2RmYjg5MDMvZG1lc2cteW9jdG8taW5uLTM4OjIwMTMxMTIy
MDkwMjE0Ong4Nl82NC1yYW5kY29uZmlnLWMxLTExMjI6My4xMi4wLTExMjg1LWdiMjQyYmZm
OjkxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctYzEtMTEyMi9iMjQyYmZmNTQ4YzM0NTEw
ZmQ5YjdmMGUyOWI4ODUyNjNkZmI4OTAzL2RtZXNnLXF1YW50YWwtcm9hbS0yNDoyMDEzMTEy
MjA5MDIxNzp4ODZfNjQtcmFuZGNvbmZpZy1jMS0xMTIyOjMuMTIuMC0xMTI4NS1nYjI0MmJm
Zjo5MQowOjI5OjI5IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpbZGV0YWNoZWQgSEVB
RCA3MjdmYjJlXSBSZXZlcnQgIlJGQzogZG9feG9yX3NwZWVkIEJyb2tlbiBvbiBVTUwgZG8g
dG8gamlmZmllcyIKIDEgZmlsZSBjaGFuZ2VkLCAyMiBpbnNlcnRpb25zKCspLCAyNSBkZWxl
dGlvbnMoLSkKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5k
Y29uZmlnLWMxLTExMjIvbGludXgtZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMxMTIy
MDE1OTo3MjdmYjJlOTBkZTliMDUyMjRiMTgwMWI0YzIxZTdmZTE4NTA2YjQzOmJpc2VjdC11
c2IKCjIwMTMtMTEtMjItMTE6NTI6MzMgNzI3ZmIyZTkwZGU5YjA1MjI0YjE4MDFiNGMyMWU3
ZmUxODUwNmI0MyBjb21waWxpbmcKCjIwMTMtMTEtMjItMTI6MDQ6NDIgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgMy4xMi4wLTExMjg2LWc3MjdmYjJlLi4JMTIJNTUJNjAgU1VDQ0VTUwoKCj09
PT09PT09PSB1cHN0cmVhbSA9PT09PT09PT0KRmV0Y2hpbmcgbGludXMKbHMgLWEgL2tlcm5l
bC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMxLTExMjIvbGludXgt
ZGV2ZWw6ZGV2ZWwtY2Fpcm8teDg2XzY0LTIwMTMxMTIyMDE1OTo1MjdkMTUxMTMxMGE4OTY1
MDAwMDA4MTg2OTI2MDM5NGUyMGM3MDEzOmJpc2VjdC11c2IKCjIwMTMtMTEtMjItMTI6MDc6
MTcgNTI3ZDE1MTEzMTBhODk2NTAwMDAwODE4NjkyNjAzOTRlMjBjNzAxMyBjb21waWxpbmcK
CjIwMTMtMTEtMjItMTI6MjM6MjAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLTEwOTI4
LWc1MjdkMTUxLi4JMwkxOAkzNQk1Mwk2MCBTVUNDRVNTCgoKPT09PT09PT09IGxpbnV4LW5l
eHQgPT09PT09PT09CkZldGNoaW5nIG5leHQKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWMxLTExMjIvbGludXgtZGV2ZWw6ZGV2ZWwtY2Fp
cm8teDg2XzY0LTIwMTMxMTIyMDE1OTpmM2ZhNTg1YWZhOTMyMzA4ODNkYzRjMjU5ZGMwM2Rm
NjIzNGE1ZTVmOmJpc2VjdC11c2IKCjIwMTMtMTEtMjItMTI6Mjc6MTAgZjNmYTU4NWFmYTkz
MjMwODgzZGM0YzI1OWRjMDNkZjYyMzRhNWU1ZiBjb21waWxpbmcKCjIwMTMtMTEtMjItMTI6
Mzk6NDEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLW5leHQtMjAxMzExMjItMTIyMDkt
Z2YzZmE1ODUuLgkyCTM4CTYwIFNVQ0NFU1MKCg==

--EuxKj2iCbKjpUGkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.12.0-11285-gb242bff"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.12.0 Kernel Configuration
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
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
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
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
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
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
# CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
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
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
# CONFIG_NO_HZ_FULL_ALL is not set
# CONFIG_NO_HZ_FULL_SYSIDLE is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
# CONFIG_TASK_XACCT is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_RCU_USER_QS=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
CONFIG_RCU_FAST_NO_HZ=y
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
CONFIG_RCU_NOCB_CPU=y
CONFIG_RCU_NOCB_CPU_ALL=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_CGROUPS is not set
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
# CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLUB_CPU_PARTIAL=y
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
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
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
# CONFIG_MODULE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
# CONFIG_MODULE_SIG_ALL is not set
# CONFIG_MODULE_SIG_SHA1 is not set
CONFIG_MODULE_SIG_SHA224=y
# CONFIG_MODULE_SIG_SHA256 is not set
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha224"
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
# CONFIG_BLK_DEV_INTEGRITY is not set
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=m
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
# CONFIG_X86_INTEL_LPSS is not set
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
CONFIG_MEMTEST=y
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
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_I8K=y
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
CONFIG_ZBUD=y
CONFIG_ZSWAP=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
CONFIG_DEBUG_HOTPLUG_CPU0=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=y
# CONFIG_ACPI_FAN is not set
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
# CONFIG_ACPI_THERMAL is not set
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
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
# CONFIG_CPU_IDLE_GOV_MENU is not set
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=m

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=m
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
# CONFIG_ISA_DMA_API is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=m
CONFIG_PCMCIA=m
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
# CONFIG_YENTA_O2 is not set
CONFIG_YENTA_RICOH=y
# CONFIG_YENTA_TI is not set
# CONFIG_YENTA_TOSHIBA is not set
# CONFIG_PD6729 is not set
CONFIG_I82092=m
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=m
# CONFIG_HOTPLUG_PCI_CPCI_GENERIC is not set
CONFIG_HOTPLUG_PCI_SHPC=m
CONFIG_RAPIDIO=m
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
CONFIG_RAPIDIO_DMA_ENGINE=y
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_ENUM_BASIC=m

#
# RapidIO Switch drivers
#
# CONFIG_RAPIDIO_TSI57X is not set
# CONFIG_RAPIDIO_CPS_XX is not set
# CONFIG_RAPIDIO_TSI568 is not set
# CONFIG_RAPIDIO_CPS_GEN2 is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
# CONFIG_COREDUMP is not set
# CONFIG_IA32_EMULATION is not set
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=m
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
CONFIG_ATM=m
# CONFIG_ATM_LANE is not set
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=m
CONFIG_NET_DSA_TAG_TRAILER=y
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
CONFIG_IPX=m
CONFIG_IPX_INTERN=y
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
# CONFIG_IPDDP is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
CONFIG_PHONET=y
CONFIG_IEEE802154=m
CONFIG_MAC802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_ATM is not set
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=y
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_MQPRIO=m
# CONFIG_NET_SCH_CHOKE is not set
# CONFIG_NET_SCH_QFQ is not set
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=m
CONFIG_NET_SCH_FQ=m
# CONFIG_NET_SCH_INGRESS is not set
CONFIG_NET_SCH_PLUG=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
# CONFIG_NET_CLS_RSVP is not set
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
# CONFIG_NET_CLS_BPF is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=y
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=y
CONFIG_NET_EMATCH_META=m
# CONFIG_NET_EMATCH_TEXT is not set
# CONFIG_NET_EMATCH_CANID is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
# CONFIG_NET_ACT_MIRRED is not set
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=y
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=y
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=m
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=m
# CONFIG_HSR is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_JIT=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
# CONFIG_CAN_BCM is not set
CONFIG_CAN_GW=m

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
CONFIG_CAN_SLCAN=m
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
CONFIG_CAN_LEDS=y
CONFIG_CAN_JANZ_ICAN3=m
CONFIG_PCH_CAN=m
# CONFIG_CAN_SJA1000 is not set
CONFIG_CAN_C_CAN=m
CONFIG_CAN_C_CAN_PLATFORM=m
CONFIG_CAN_C_CAN_PCI=m
CONFIG_CAN_CC770=m
CONFIG_CAN_CC770_ISA=m
# CONFIG_CAN_CC770_PLATFORM is not set

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=m
CONFIG_CAN_ESD_USB2=m
CONFIG_CAN_KVASER_USB=m
# CONFIG_CAN_PEAK_USB is not set
CONFIG_CAN_8DEV_USB=m
CONFIG_CAN_SOFTING=m
# CONFIG_CAN_SOFTING_CS is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
# CONFIG_IRNET is not set
CONFIG_IRCOMM=m
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=m

#
# Dongle support
#
# CONFIG_DONGLE is not set
# CONFIG_KINGSUN_DONGLE is not set
CONFIG_KSDAZZLE_DONGLE=m
# CONFIG_KS959_DONGLE is not set

#
# FIR device drivers
#
CONFIG_USB_IRDA=m
CONFIG_SIGMATEL_FIR=m
CONFIG_VLSI_FIR=m
CONFIG_MCS_FIR=m
CONFIG_BT=m
CONFIG_BT_RFCOMM=m
# CONFIG_BT_RFCOMM_TTY is not set
CONFIG_BT_BNEP=m
# CONFIG_BT_BNEP_MC_FILTER is not set
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTUSB is not set
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
# CONFIG_BT_HCIUART_H4 is not set
# CONFIG_BT_HCIUART_BCSP is not set
# CONFIG_BT_HCIUART_ATH3K is not set
CONFIG_BT_HCIUART_LL=y
# CONFIG_BT_HCIUART_3WIRE is not set
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
# CONFIG_BT_HCIDTL1 is not set
# CONFIG_BT_HCIBT3C is not set
CONFIG_BT_HCIBLUECARD=m
CONFIG_BT_HCIBTUART=m
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
# CONFIG_BT_MRVL_SDIO is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=m
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=m
CONFIG_MTD=y
# CONFIG_MTD_TESTS is not set
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_CMDLINE_PARTS=y
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
CONFIG_FTL=y
# CONFIG_NFTL is not set
CONFIG_INFTL=m
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
CONFIG_SM_FTL=y
CONFIG_MTD_OOPS=m
CONFIG_MTD_SWAP=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
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
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
# CONFIG_MTD_RAM is not set
CONFIG_MTD_ROM=m
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=m
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
CONFIG_MTD_SC520CDP=m
# CONFIG_MTD_NETSC520 is not set
CONFIG_MTD_TS5500=m
CONFIG_MTD_AMD76XROM=m
CONFIG_MTD_ICHXROM=m
CONFIG_MTD_ESB2ROM=m
CONFIG_MTD_CK804XROM=m
# CONFIG_MTD_SCB2_FLASH is not set
CONFIG_MTD_NETtel=m
CONFIG_MTD_L440GX=m
CONFIG_MTD_INTEL_VR_NOR=m
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=m
CONFIG_MTD_PMC551_BUGFIX=y
CONFIG_MTD_PMC551_DEBUG=y
CONFIG_MTD_SLRAM=m
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
CONFIG_MTD_BLOCK2MTD=m

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=y
# CONFIG_MTD_NAND_ECC_BCH is not set
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=m
CONFIG_MTD_NAND_DENALI_PCI=m
CONFIG_MTD_NAND_DENALI_SCRATCH_REG_ADDR=0xFF108018
CONFIG_MTD_NAND_GPIO=y
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
# CONFIG_MTD_NAND_DISKONCHIP is not set
CONFIG_MTD_NAND_DOCG4=y
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_NANDSIM=m
CONFIG_MTD_NAND_PLATFORM=m
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
# CONFIG_MTD_ONENAND_GENERIC is not set
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_MTD_UBI_GLUEBI=y
# CONFIG_PARPORT is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=m
CONFIG_BLK_CPQ_CISS_DA=m
CONFIG_CISS_SCSI_TAPE=y
# CONFIG_BLK_DEV_DAC960 is not set
CONFIG_BLK_DEV_UMEM=m
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=m

#
# DRBD disabled because PROC_FS or INET not selected
#
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_NVME=m
# CONFIG_BLK_DEV_SKD is not set
CONFIG_BLK_DEV_SX8=m
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=m
CONFIG_BLK_DEV_HD=y
CONFIG_BLK_DEV_RSXX=m

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=m
CONFIG_AD525X_DPOT_I2C=m
CONFIG_DUMMY_IRQ=m
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
# CONFIG_INTEL_MID_PTI is not set
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
CONFIG_ICS932S401=y
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_PCH_PHUB=y
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_SRAM=y
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
CONFIG_CB710_CORE=m
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#
# CONFIG_INTEL_MIC_HOST is not set

#
# Intel MIC Card Driver
#
# CONFIG_INTEL_MIC_CARD is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=m
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_ENCLOSURE=y
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=m
# CONFIG_SCSI_FC_TGT_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=m
# CONFIG_SCSI_SRP_TGT_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
CONFIG_SATA_AHCI_PLATFORM=y
# CONFIG_AHCI_IMX is not set
# CONFIG_SATA_INIC162X is not set
CONFIG_SATA_ACARD_AHCI=y
CONFIG_SATA_SIL24=y
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=y
CONFIG_SATA_SX4=m
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
CONFIG_SATA_HIGHBANK=y
CONFIG_SATA_MV=y
# CONFIG_SATA_NV is not set
CONFIG_SATA_PROMISE=y
CONFIG_SATA_RCAR=m
CONFIG_SATA_SIL=y
CONFIG_SATA_SIS=y
CONFIG_SATA_SVW=m
CONFIG_SATA_ULI=y
CONFIG_SATA_VIA=m
CONFIG_SATA_VITESSE=y

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
CONFIG_PATA_ARASAN_CF=y
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
CONFIG_PATA_ATP867X=m
CONFIG_PATA_CMD64X=m
CONFIG_PATA_CS5520=y
CONFIG_PATA_CS5530=m
CONFIG_PATA_CS5536=m
# CONFIG_PATA_CYPRESS is not set
CONFIG_PATA_EFAR=m
# CONFIG_PATA_HPT366 is not set
CONFIG_PATA_HPT37X=m
CONFIG_PATA_HPT3X2N=y
# CONFIG_PATA_HPT3X3 is not set
CONFIG_PATA_IT8213=m
# CONFIG_PATA_IT821X is not set
CONFIG_PATA_JMICRON=m
# CONFIG_PATA_MARVELL is not set
CONFIG_PATA_NETCELL=y
# CONFIG_PATA_NINJA32 is not set
CONFIG_PATA_NS87415=m
CONFIG_PATA_OLDPIIX=y
CONFIG_PATA_OPTIDMA=y
CONFIG_PATA_PDC2027X=m
CONFIG_PATA_PDC_OLD=y
CONFIG_PATA_RADISYS=m
CONFIG_PATA_RDC=y
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
CONFIG_PATA_SERVERWORKS=m
CONFIG_PATA_SIL680=y
CONFIG_PATA_SIS=y
CONFIG_PATA_TOSHIBA=y
CONFIG_PATA_TRIFLEX=m
CONFIG_PATA_VIA=y
CONFIG_PATA_WINBOND=y

#
# PIO-only SFF controllers
#
CONFIG_PATA_CMD640_PCI=m
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
CONFIG_PATA_OPTI=m
# CONFIG_PATA_PCMCIA is not set
CONFIG_PATA_PLATFORM=m
CONFIG_PATA_RZ1000=y

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
# CONFIG_MD_LINEAR is not set
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MD_MULTIPATH=y
CONFIG_MD_FAULTY=y
CONFIG_BCACHE=m
# CONFIG_BCACHE_DEBUG is not set
CONFIG_BCACHE_CLOSURES_DEBUG=y
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=m
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=y
# CONFIG_DM_THIN_PROVISIONING is not set
# CONFIG_DM_CACHE is not set
CONFIG_DM_MIRROR=y
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_RAID=y
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
CONFIG_DM_MULTIPATH_QL=m
# CONFIG_DM_MULTIPATH_ST is not set
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
CONFIG_DM_SWITCH=m
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=y
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
# CONFIG_LOOPBACK_TARGET is not set
CONFIG_ISCSI_TARGET=m
CONFIG_SBP_TARGET=m
CONFIG_FUSION=y
# CONFIG_FUSION_SPI is not set
CONFIG_FUSION_FC=m
# CONFIG_FUSION_SAS is not set
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=m
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
# CONFIG_FIREWIRE_OHCI is not set
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NOSY=y
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=m
# CONFIG_NET_CORE is not set
CONFIG_ARCNET=m
CONFIG_ARCNET_1201=m
CONFIG_ARCNET_1051=m
CONFIG_ARCNET_RAW=m
CONFIG_ARCNET_CAP=m
CONFIG_ARCNET_COM90xx=m
CONFIG_ARCNET_COM90xxIO=m
# CONFIG_ARCNET_RIM_I is not set
# CONFIG_ARCNET_COM20020 is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
CONFIG_ATM_LANAI=m
# CONFIG_ATM_ENI is not set
CONFIG_ATM_FIRESTREAM=m
CONFIG_ATM_ZATM=m
CONFIG_ATM_ZATM_DEBUG=y
# CONFIG_ATM_NICSTAR is not set
CONFIG_ATM_IDT77252=m
CONFIG_ATM_IDT77252_DEBUG=y
CONFIG_ATM_IDT77252_RCV_ALL=y
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=m
CONFIG_ATM_AMBASSADOR_DEBUG=y
CONFIG_ATM_HORIZON=m
# CONFIG_ATM_HORIZON_DEBUG is not set
CONFIG_ATM_IA=m
CONFIG_ATM_IA_DEBUG=y
CONFIG_ATM_FORE200E=m
CONFIG_ATM_FORE200E_USE_TASKLET=y
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
CONFIG_ATM_HE=m
CONFIG_ATM_HE_USE_SUNI=y
# CONFIG_ATM_SOLOS is not set

#
# CAIF transport drivers
#
CONFIG_VHOST_NET=y
# CONFIG_VHOST_SCSI is not set
CONFIG_VHOST_RING=y
CONFIG_VHOST=y

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
CONFIG_NET_DSA_MV88E6060=m
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
# CONFIG_ETHERNET is not set
# CONFIG_FDDI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=m
CONFIG_AMD_PHY=m
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=m
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
CONFIG_BCM87XX_PHY=m
CONFIG_ICPLUS_PHY=m
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
CONFIG_LSI_ET1011C_PHY=m
CONFIG_MICREL_PHY=m
# CONFIG_MDIO_BITBANG is not set
CONFIG_PPP=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_DEFLATE=m
# CONFIG_PPP_FILTER is not set
CONFIG_PPP_MPPE=m
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPPOATM=m
# CONFIG_PPPOE is not set
# CONFIG_PPP_ASYNC is not set
CONFIG_PPP_SYNC_TTY=m
# CONFIG_SLIP is not set
CONFIG_SLHC=m

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
CONFIG_USB_KAWETH=m
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_RTL8152=m
CONFIG_USB_USBNET=m
# CONFIG_USB_NET_AX8817X is not set
# CONFIG_USB_NET_AX88179_178A is not set
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_CDC_EEM=m
CONFIG_USB_NET_CDC_NCM=m
# CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
# CONFIG_USB_NET_CDC_MBIM is not set
CONFIG_USB_NET_DM9601=m
CONFIG_USB_NET_SR9700=m
# CONFIG_USB_NET_SMSC75XX is not set
CONFIG_USB_NET_SMSC95XX=m
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
# CONFIG_USB_NET_CDC_SUBSET is not set
CONFIG_USB_NET_ZAURUS=m
CONFIG_USB_NET_CX82310_ETH=m
# CONFIG_USB_NET_KALMIA is not set
CONFIG_USB_NET_QMI_WWAN=m
# CONFIG_USB_NET_INT51X1 is not set
CONFIG_USB_CDC_PHONET=y
CONFIG_USB_IPHETH=y
CONFIG_USB_SIERRA_NET=m
CONFIG_USB_VL600=m
# CONFIG_WLAN is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=y
CONFIG_WIMAX_I2400M_USB=y
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=m
# CONFIG_IEEE802154_FAKEHARD is not set
# CONFIG_IEEE802154_FAKELB is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

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
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_SH_KEYSC is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=y
CONFIG_TABLET_USB_GTCO=y
CONFIG_TABLET_USB_HANWANG=m
# CONFIG_TABLET_USB_KBTAB is not set
CONFIG_TABLET_USB_WACOM=y
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=m
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
CONFIG_TOUCHSCREEN_BU21013=m
CONFIG_TOUCHSCREEN_CY8CTMG110=m
CONFIG_TOUCHSCREEN_CYTTSP_CORE=m
CONFIG_TOUCHSCREEN_CYTTSP_I2C=m
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=m
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=m
CONFIG_TOUCHSCREEN_DYNAPRO=y
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=y
CONFIG_TOUCHSCREEN_FUJITSU=m
CONFIG_TOUCHSCREEN_ILI210X=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=m
CONFIG_TOUCHSCREEN_WACOM_I2C=m
CONFIG_TOUCHSCREEN_MAX11801=m
CONFIG_TOUCHSCREEN_MCS5000=m
CONFIG_TOUCHSCREEN_MMS114=m
CONFIG_TOUCHSCREEN_MTOUCH=y
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=m
# CONFIG_TOUCHSCREEN_TI_AM335X_TSC is not set
CONFIG_TOUCHSCREEN_PIXCIR=m
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
# CONFIG_TOUCHSCREEN_MC13783 is not set
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
# CONFIG_TOUCHSCREEN_USB_3M is not set
# CONFIG_TOUCHSCREEN_USB_ITM is not set
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
# CONFIG_TOUCHSCREEN_USB_IRTOUCH is not set
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
# CONFIG_TOUCHSCREEN_USB_GOTOP is not set
CONFIG_TOUCHSCREEN_USB_JASTEC=y
# CONFIG_TOUCHSCREEN_USB_ELO is not set
# CONFIG_TOUCHSCREEN_USB_E2I is not set
# CONFIG_TOUCHSCREEN_USB_ZYTRONIC is not set
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
# CONFIG_TOUCHSCREEN_USB_NEXIO is not set
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_ST1232=y
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_TOUCHSCREEN_ZFORCE is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_88PM860X_ONKEY is not set
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_BMA150=y
CONFIG_INPUT_MC13783_PWRBUTTON=m
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_MPU3050=m
CONFIG_INPUT_APANEL=y
# CONFIG_INPUT_GP2A is not set
CONFIG_INPUT_GPIO_TILT_POLLED=m
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=y
CONFIG_INPUT_KXTJ9=y
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
CONFIG_INPUT_POWERMATE=m
# CONFIG_INPUT_YEALINK is not set
CONFIG_INPUT_CM109=y
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_PCF50633_PMU is not set
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=m
CONFIG_INPUT_IMS_PCU=y
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_IDEAPAD_SLIDEBAR=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=y
CONFIG_CYZ_INTR=y
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINKMP is not set
CONFIG_SYNCLINK_GT=y
CONFIG_NOZOMI=m
# CONFIG_ISI is not set
CONFIG_N_HDLC=y
CONFIG_N_GSM=y
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MFD_HSU=m
CONFIG_SERIAL_UARTLITE=y
CONFIG_SERIAL_UARTLITE_CONSOLE=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=m
CONFIG_SERIAL_TIMBERDALE=m
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_PCH_UART=y
CONFIG_SERIAL_PCH_UART_CONSOLE=y
CONFIG_SERIAL_ARC=y
CONFIG_SERIAL_ARC_CONSOLE=y
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
CONFIG_SERIAL_ST_ASC=m
# CONFIG_TTY_PRINTK is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=m

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
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
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=m
# CONFIG_I2C_AMD756_S4882 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
# CONFIG_I2C_ISMT is not set
CONFIG_I2C_PIIX4=m
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_EG20T=y
CONFIG_I2C_GPIO=m
CONFIG_I2C_OCORES=m
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SH_MOBILE is not set
CONFIG_I2C_SIMTEC=m
CONFIG_I2C_XILINX=y
# CONFIG_I2C_RCAR is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=y
CONFIG_I2C_VIPERBOARD=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=m

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
CONFIG_NTP_PPS=y

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
CONFIG_PPS_CLIENT_LDISC=y
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
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_TS5500=m
# CONFIG_GPIO_SCH is not set
CONFIG_GPIO_ICH=m
CONFIG_GPIO_VX855=m
CONFIG_GPIO_LYNXPOINT=y

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
CONFIG_GPIO_MAX7300=m
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
CONFIG_GPIO_PCF857X=m
CONFIG_GPIO_RC5T583=y
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_WM8350 is not set
# CONFIG_GPIO_WM8994 is not set
CONFIG_GPIO_ADP5588=m

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_INTEL_MID is not set
# CONFIG_GPIO_PCH is not set
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_TIMBERDALE=y
CONFIG_GPIO_RDC321X=m

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MCP23S08 is not set

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_JANZ_TTL is not set
CONFIG_GPIO_PALMAS=y
# CONFIG_GPIO_TPS6586X is not set
CONFIG_GPIO_TPS65910=y

#
# USB GPIO expanders:
#
# CONFIG_GPIO_VIPERBOARD is not set
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=m
# CONFIG_W1_MASTER_DS2490 is not set
# CONFIG_W1_MASTER_DS2482 is not set
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=m
CONFIG_W1_SLAVE_DS2408_READBACK=y
# CONFIG_W1_SLAVE_DS2413 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=m
CONFIG_W1_SLAVE_DS28E04=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_WM8350_POWER=m
CONFIG_TEST_POWER=m
CONFIG_BATTERY_88PM860X=y
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=m
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
# CONFIG_CHARGER_88PM860X is not set
# CONFIG_CHARGER_PCF50633 is not set
CONFIG_CHARGER_ISP1704=y
CONFIG_CHARGER_MAX8903=m
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MANAGER=y
CONFIG_CHARGER_MAX8998=m
CONFIG_CHARGER_BQ2415X=m
CONFIG_CHARGER_BQ24190=m
# CONFIG_CHARGER_BQ24735 is not set
CONFIG_CHARGER_SMB347=y
CONFIG_BATTERY_GOLDFISH=y
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=y
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_GPIO_FAN=y
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_HTU21=m
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IBMAEM is not set
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=m
CONFIG_SENSORS_LINEAGE=y
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
CONFIG_SENSORS_LTC4245=m
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=m
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MCP3021=m
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=m
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=m
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_WM8350 is not set
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_MC13783_ADC=m

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=y
CONFIG_SENSORS_ATK0110=m
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_EMULATION=y
# CONFIG_INTEL_POWERCLAMP is not set

#
# Texas Instruments thermal drivers
#
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
# CONFIG_SSB_PCIHOST is not set
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_CROS_EC=m
CONFIG_MFD_CROS_EC_I2C=m
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13783=m
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_I2C=m
# CONFIG_HTC_PASIC3 is not set
CONFIG_HTC_I2CPLD=y
CONFIG_LPC_ICH=m
CONFIG_LPC_SCH=m
CONFIG_MFD_JANZ_CMODIO=m
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=m
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
CONFIG_MFD_VIPERBOARD=y
# CONFIG_MFD_RETU is not set
CONFIG_MFD_PCF50633=m
# CONFIG_PCF50633_ADC is not set
CONFIG_PCF50633_GPIO=m
CONFIG_MFD_RDC321X=m
CONFIG_MFD_RTSX_PCI=m
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=y
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=m
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=m
CONFIG_MFD_TIMBERDALE=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=m
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_88PM8607 is not set
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_ANATOP=y
# CONFIG_REGULATOR_AB3100 is not set
# CONFIG_REGULATOR_DA9210 is not set
# CONFIG_REGULATOR_FAN53555 is not set
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_ISL6271A=m
CONFIG_REGULATOR_LP3971=y
# CONFIG_REGULATOR_LP3972 is not set
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_LP8755=m
CONFIG_REGULATOR_LP8788=m
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=m
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8998=m
CONFIG_REGULATOR_MAX77686=m
CONFIG_REGULATOR_MAX77693=m
CONFIG_REGULATOR_MC13XXX_CORE=m
# CONFIG_REGULATOR_MC13783 is not set
CONFIG_REGULATOR_MC13892=m
# CONFIG_REGULATOR_PALMAS is not set
# CONFIG_REGULATOR_PCF50633 is not set
CONFIG_REGULATOR_PFUZE100=m
# CONFIG_REGULATOR_RC5T583 is not set
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=m
CONFIG_REGULATOR_TPS62360=m
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=m
CONFIG_REGULATOR_TPS65217=m
CONFIG_REGULATOR_TPS6586X=m
CONFIG_REGULATOR_TPS65910=y
# CONFIG_REGULATOR_WM8350 is not set
# CONFIG_REGULATOR_WM8994 is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_TUNER=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_VMALLOC=y
CONFIG_VIDEOBUF_DMA_CONTIG=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_CONTIG=y
CONFIG_VIDEOBUF2_VMALLOC=y
# CONFIG_VIDEO_V4L2_INT_DEVICE is not set
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_RC_CORE=y
CONFIG_RC_MAP=m
# CONFIG_RC_DECODERS is not set
# CONFIG_RC_DEVICES is not set
CONFIG_MEDIA_USB_SUPPORT=y

#
# Webcam devices
#
# CONFIG_USB_VIDEO_CLASS is not set
CONFIG_USB_GSPCA=m
CONFIG_USB_M5602=m
# CONFIG_USB_STV06XX is not set
# CONFIG_USB_GL860 is not set
CONFIG_USB_GSPCA_BENQ=m
CONFIG_USB_GSPCA_CONEX=m
# CONFIG_USB_GSPCA_CPIA1 is not set
CONFIG_USB_GSPCA_ETOMS=m
CONFIG_USB_GSPCA_FINEPIX=m
CONFIG_USB_GSPCA_JEILINJ=m
CONFIG_USB_GSPCA_JL2005BCD=m
CONFIG_USB_GSPCA_KINECT=m
CONFIG_USB_GSPCA_KONICA=m
CONFIG_USB_GSPCA_MARS=m
# CONFIG_USB_GSPCA_MR97310A is not set
CONFIG_USB_GSPCA_NW80X=m
CONFIG_USB_GSPCA_OV519=m
# CONFIG_USB_GSPCA_OV534 is not set
CONFIG_USB_GSPCA_OV534_9=m
CONFIG_USB_GSPCA_PAC207=m
CONFIG_USB_GSPCA_PAC7302=m
# CONFIG_USB_GSPCA_PAC7311 is not set
# CONFIG_USB_GSPCA_SE401 is not set
CONFIG_USB_GSPCA_SN9C2028=m
CONFIG_USB_GSPCA_SN9C20X=m
# CONFIG_USB_GSPCA_SONIXB is not set
# CONFIG_USB_GSPCA_SONIXJ is not set
# CONFIG_USB_GSPCA_SPCA500 is not set
CONFIG_USB_GSPCA_SPCA501=m
CONFIG_USB_GSPCA_SPCA505=m
# CONFIG_USB_GSPCA_SPCA506 is not set
# CONFIG_USB_GSPCA_SPCA508 is not set
CONFIG_USB_GSPCA_SPCA561=m
# CONFIG_USB_GSPCA_SPCA1528 is not set
CONFIG_USB_GSPCA_SQ905=m
# CONFIG_USB_GSPCA_SQ905C is not set
CONFIG_USB_GSPCA_SQ930X=m
CONFIG_USB_GSPCA_STK014=m
CONFIG_USB_GSPCA_STK1135=m
CONFIG_USB_GSPCA_STV0680=m
CONFIG_USB_GSPCA_SUNPLUS=m
# CONFIG_USB_GSPCA_T613 is not set
CONFIG_USB_GSPCA_TOPRO=m
# CONFIG_USB_GSPCA_TV8532 is not set
# CONFIG_USB_GSPCA_VC032X is not set
CONFIG_USB_GSPCA_VICAM=m
# CONFIG_USB_GSPCA_XIRLINK_CIT is not set
CONFIG_USB_GSPCA_ZC3XX=m
CONFIG_USB_PWC=m
CONFIG_USB_PWC_DEBUG=y
# CONFIG_USB_PWC_INPUT_EVDEV is not set
CONFIG_VIDEO_CPIA2=y
CONFIG_USB_ZR364XX=m
CONFIG_USB_STKWEBCAM=y
CONFIG_USB_S2255=y
CONFIG_USB_SN9C102=y
# CONFIG_VIDEO_USBTV is not set

#
# Webcam, TV (analog/digital) USB devices
#
CONFIG_VIDEO_EM28XX=y
# CONFIG_VIDEO_EM28XX_RC is not set
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#
CONFIG_V4L_PLATFORM_DRIVERS=y
# CONFIG_VIDEO_CAFE_CCIC is not set
# CONFIG_VIDEO_VIA_CAMERA is not set
CONFIG_VIDEO_TIMBERDALE=y
CONFIG_SOC_CAMERA=y
CONFIG_SOC_CAMERA_SCALE_CROP=y
# CONFIG_SOC_CAMERA_PLATFORM is not set
CONFIG_VIDEO_RCAR_VIN=y
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
CONFIG_V4L_TEST_DRIVERS=y
CONFIG_VIDEO_VIVI=m
# CONFIG_VIDEO_MEM2MEM_TESTDEV is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_VIDEO_TVEEPROM=y
CONFIG_CYPRESS_FIRMWARE=m

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_VIDEO_IR_I2C=y

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_MSP3400=y

#
# RDS decoders
#

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=y
CONFIG_VIDEO_SAA711X=y
CONFIG_VIDEO_TVP5150=y

#
# Video and audio decoders
#

#
# Video encoders
#

#
# Camera sensor devices
#
CONFIG_VIDEO_MT9V011=y

#
# Flash devices
#

#
# Video improvement chips
#

#
# Miscellaneous helper chips
#

#
# Sensors used on soc_camera driver
#

#
# soc_camera sensor drivers
#
CONFIG_SOC_CAMERA_IMX074=m
# CONFIG_SOC_CAMERA_MT9M001 is not set
CONFIG_SOC_CAMERA_MT9M111=m
CONFIG_SOC_CAMERA_MT9T031=y
CONFIG_SOC_CAMERA_MT9T112=y
CONFIG_SOC_CAMERA_MT9V022=y
# CONFIG_SOC_CAMERA_OV2640 is not set
# CONFIG_SOC_CAMERA_OV5642 is not set
# CONFIG_SOC_CAMERA_OV6650 is not set
CONFIG_SOC_CAMERA_OV772X=m
CONFIG_SOC_CAMERA_OV9640=y
# CONFIG_SOC_CAMERA_OV9740 is not set
# CONFIG_SOC_CAMERA_RJ54N1 is not set
CONFIG_SOC_CAMERA_TW9910=y

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=m
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=m
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=m
CONFIG_FB_PM2=m
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=y
# CONFIG_FB_CYBER2000_DDC is not set
CONFIG_FB_ARC=m
# CONFIG_FB_ASILIANT is not set
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
CONFIG_FB_S1D13XXX=m
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
CONFIG_FB_I740=m
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
CONFIG_FB_MATROX=m
# CONFIG_FB_MATROX_MILLENIUM is not set
# CONFIG_FB_MATROX_MYSTIQUE is not set
# CONFIG_FB_MATROX_G is not set
CONFIG_FB_MATROX_I2C=m
CONFIG_FB_RADEON=m
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=m
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=m
# CONFIG_FB_ATY_CT is not set
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=y
# CONFIG_FB_SIS_300 is not set
# CONFIG_FB_SIS_315 is not set
CONFIG_FB_VIA=y
CONFIG_FB_VIA_DIRECT_PROCFS=y
CONFIG_FB_VIA_X_COMPATIBILITY=y
CONFIG_FB_NEOMAGIC=y
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=m
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
# CONFIG_FB_SMSCUFX is not set
CONFIG_FB_UDL=m
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=m
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=m
# CONFIG_FB_AUO_K1900 is not set
CONFIG_FB_AUO_K1901=m
CONFIG_FB_SIMPLE=y
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_LM3533=m
CONFIG_BACKLIGHT_CARILLO_RANCH=m
CONFIG_BACKLIGHT_PWM=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=m
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_88PM860X=y
# CONFIG_BACKLIGHT_PCF50633 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
CONFIG_BACKLIGHT_LM3639=m
# CONFIG_BACKLIGHT_LP855X is not set
CONFIG_BACKLIGHT_LP8788=m
CONFIG_BACKLIGHT_TPS65217=m
CONFIG_BACKLIGHT_GPIO=m
CONFIG_BACKLIGHT_LV5207LP=m
CONFIG_BACKLIGHT_BD6107=m
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=y
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
CONFIG_HID_AUREAL=y
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
CONFIG_HID_CHICONY=y
# CONFIG_HID_CYPRESS is not set
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=m
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=y
# CONFIG_HID_GYRATION is not set
CONFIG_HID_ICADE=y
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LCPOWER=m
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=m
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=m
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=y
# CONFIG_HID_PICOLCD_FB is not set
CONFIG_HID_PICOLCD_BACKLIGHT=y
# CONFIG_HID_PICOLCD_LCD is not set
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SPEEDLINK=m
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
# CONFIG_USB_HID is not set
CONFIG_HID_PID=y

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=y
CONFIG_USB_MOUSE=m

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
CONFIG_USB_OTG_WHITELIST=y
CONFIG_USB_OTG_BLACKLIST_HUB=y
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB=m
CONFIG_USB_WUSB_CBAF=m
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
# CONFIG_USB_XHCI_HCD is not set
# CONFIG_USB_EHCI_HCD is not set
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1362_HCD=m
CONFIG_USB_FUSBH200_HCD=y
# CONFIG_USB_FOTG210_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=m
CONFIG_USB_U132_HCD=m
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=m
# CONFIG_USB_WHCI_HCD is not set
CONFIG_USB_HWA_HCD=m
CONFIG_USB_HCD_BCMA=m
CONFIG_USB_HCD_SSB=m
CONFIG_USB_HCD_TEST_MODE=y
CONFIG_USB_MUSB_HDRC=y
# CONFIG_USB_MUSB_HOST is not set
# CONFIG_USB_MUSB_GADGET is not set
CONFIG_USB_MUSB_DUAL_ROLE=y
CONFIG_USB_MUSB_TUSB6010=m
# CONFIG_USB_MUSB_UX500 is not set
CONFIG_MUSB_PIO_ONLY=y
# CONFIG_USB_RENESAS_USBHS is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=y
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
# CONFIG_USB_STORAGE is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
CONFIG_USB_MICROTEK=y
# CONFIG_USB_DWC3 is not set
CONFIG_USB_CHIPIDEA=m
CONFIG_USB_CHIPIDEA_UDC=y
# CONFIG_USB_CHIPIDEA_DEBUG is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
# CONFIG_USB_EMI26 is not set
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=y
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
# CONFIG_USB_APPLEDISPLAY is not set
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
CONFIG_USB_EHSET_TEST_FIXTURE=y
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=m
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
# CONFIG_USB_XUSBATM is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
# CONFIG_NOP_USB_XCEIV is not set
CONFIG_OMAP_CONTROL_USB=y
CONFIG_OMAP_USB3=y
# CONFIG_AM335X_PHY_USB is not set
CONFIG_SAMSUNG_USBPHY=m
# CONFIG_SAMSUNG_USB2PHY is not set
CONFIG_SAMSUNG_USB3PHY=m
# CONFIG_USB_GPIO_VBUS is not set
CONFIG_USB_ISP1301=y
CONFIG_USB_RCAR_PHY=y
# CONFIG_USB_RCAR_GEN2_PHY is not set
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_DEBUG=y
# CONFIG_USB_GADGET_VERBOSE is not set
CONFIG_USB_GADGET_DEBUG_FILES=y
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FOTG210_UDC=y
# CONFIG_USB_R8A66597 is not set
CONFIG_USB_PXA27X=y
# CONFIG_USB_MV_UDC is not set
# CONFIG_USB_MV_U3D is not set
CONFIG_USB_M66592=m
CONFIG_USB_AMD5536UDC=y
CONFIG_USB_NET2272=y
CONFIG_USB_NET2272_DMA=y
# CONFIG_USB_NET2280 is not set
CONFIG_USB_GOKU=y
CONFIG_USB_EG20T=m
CONFIG_USB_DUMMY_HCD=m
CONFIG_USB_LIBCOMPOSITE=m
CONFIG_USB_F_ACM=m
CONFIG_USB_U_SERIAL=m
CONFIG_USB_U_ETHER=m
CONFIG_USB_F_SERIAL=m
CONFIG_USB_F_OBEX=m
CONFIG_USB_F_ECM=m
CONFIG_USB_F_PHONET=m
CONFIG_USB_F_MASS_STORAGE=m
CONFIG_USB_CONFIGFS=m
# CONFIG_USB_CONFIGFS_SERIAL is not set
CONFIG_USB_CONFIGFS_ACM=y
CONFIG_USB_CONFIGFS_OBEX=y
# CONFIG_USB_CONFIGFS_NCM is not set
CONFIG_USB_CONFIGFS_ECM=y
# CONFIG_USB_CONFIGFS_ECM_SUBSET is not set
# CONFIG_USB_CONFIGFS_RNDIS is not set
# CONFIG_USB_CONFIGFS_EEM is not set
# CONFIG_USB_CONFIGFS_PHONET is not set
# CONFIG_USB_CONFIGFS_MASS_STORAGE is not set
# CONFIG_USB_ZERO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
CONFIG_USB_GADGETFS=m
# CONFIG_USB_FUNCTIONFS is not set
CONFIG_USB_MASS_STORAGE=m
CONFIG_USB_GADGET_TARGET=m
CONFIG_USB_G_SERIAL=m
CONFIG_USB_G_PRINTER=m
CONFIG_USB_CDC_COMPOSITE=m
CONFIG_USB_G_NOKIA=m
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
CONFIG_USB_G_HID=m
# CONFIG_USB_G_DBGP is not set
CONFIG_USB_G_WEBCAM=m
CONFIG_UWB=m
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=m
CONFIG_UWB_I1480U=m
CONFIG_MMC=m
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
# CONFIG_MMC_BLOCK_BOUNCE is not set
CONFIG_SDIO_UART=m
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
# CONFIG_MMC_SDHCI_PCI is not set
CONFIG_MMC_SDHCI_ACPI=m
# CONFIG_MMC_SDHCI_PLTFM is not set
# CONFIG_MMC_OMAP_HS is not set
CONFIG_MMC_TIFM_SD=m
# CONFIG_MMC_SDRICOH_CS is not set
CONFIG_MMC_CB710=m
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_VUB300=m
CONFIG_MMC_USHC=m
# CONFIG_MMC_REALTEK_PCI is not set
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
# CONFIG_MSPRO_BLOCK is not set
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_MEMSTICK_R592=m
CONFIG_MEMSTICK_REALTEK_PCI=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=m
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
# CONFIG_LEDS_LP8788 is not set
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
# CONFIG_LEDS_PCA9685 is not set
CONFIG_LEDS_WM8350=m
CONFIG_LEDS_PWM=m
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_LT3593=m
CONFIG_LEDS_DELL_NETBOOKS=m
CONFIG_LEDS_MC13783=m
CONFIG_LEDS_TCA6507=m
CONFIG_LEDS_LM355x=m
CONFIG_LEDS_OT200=m
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
CONFIG_LEDS_TRIGGER_CPU=y
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=y
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
# CONFIG_INFINIBAND_USER_ACCESS is not set
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
# CONFIG_INFINIBAND_QIB is not set
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_SRPT=m
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=m
# CONFIG_EDAC_E752X is not set
CONFIG_EDAC_I82975X=m
# CONFIG_EDAC_I3000 is not set
CONFIG_EDAC_I3200=m
# CONFIG_EDAC_X38 is not set
CONFIG_EDAC_I5400=m
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
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
# CONFIG_RTC_DRV_88PM860X is not set
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1374=y
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_LP8788=m
# CONFIG_RTC_DRV_MAX6900 is not set
CONFIG_RTC_DRV_MAX8907=m
# CONFIG_RTC_DRV_MAX8998 is not set
# CONFIG_RTC_DRV_MAX77686 is not set
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_X1205=m
# CONFIG_RTC_DRV_PALMAS is not set
CONFIG_RTC_DRV_PCF2127=y
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=y
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=m
CONFIG_RTC_DRV_TPS6586X=m
CONFIG_RTC_DRV_TPS65910=y
CONFIG_RTC_DRV_RC5T583=m
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=m
CONFIG_RTC_DRV_RV3029C2=y

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=m
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=m
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
# CONFIG_RTC_DRV_V3020 is not set
CONFIG_RTC_DRV_DS2404=m
# CONFIG_RTC_DRV_WM8350 is not set
CONFIG_RTC_DRV_PCF50633=m
CONFIG_RTC_DRV_AB3100=m

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=m
# CONFIG_RTC_DRV_MOXART is not set

#
# HID Sensor RTC drivers
#
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
# CONFIG_DMADEVICES_VDEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
CONFIG_INTEL_IOATDMA=m
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
CONFIG_DW_DMAC_PCI=y
CONFIG_TIMB_DMA=y
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
CONFIG_DCA=m
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=m
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=m
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
CONFIG_UIO_NETX=m
# CONFIG_UIO_MF624 is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=m

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=m
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=m
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=y
# CONFIG_ACERHDF is not set
CONFIG_ASUS_LAPTOP=m
# CONFIG_DELL_LAPTOP is not set
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
CONFIG_FUJITSU_LAPTOP=m
CONFIG_FUJITSU_LAPTOP_DEBUG=y
# CONFIG_FUJITSU_TABLET is not set
CONFIG_HP_ACCEL=y
CONFIG_HP_WMI=y
CONFIG_PANASONIC_LAPTOP=m
CONFIG_THINKPAD_ACPI=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
CONFIG_THINKPAD_ACPI_DEBUG=y
CONFIG_THINKPAD_ACPI_UNSAFE_LEDS=y
CONFIG_THINKPAD_ACPI_VIDEO=y
# CONFIG_THINKPAD_ACPI_HOTKEY_POLL is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_EEEPC_LAPTOP is not set
CONFIG_ASUS_WMI=m
# CONFIG_ASUS_NB_WMI is not set
# CONFIG_EEEPC_WMI is not set
CONFIG_ACPI_WMI=y
CONFIG_MSI_WMI=m
CONFIG_TOPSTAR_LAPTOP=m
CONFIG_ACPI_TOSHIBA=y
CONFIG_TOSHIBA_BT_RFKILL=y
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=m
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
CONFIG_INTEL_RST=m
CONFIG_INTEL_SMARTCONNECT=y
CONFIG_PVPANIC=m

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_ARM_ARCH_TIMER_EVTSTREAM is not set
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=m
CONFIG_STE_MODEM_RPROC=m

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
# CONFIG_EXTCON_MAX77693 is not set
CONFIG_EXTCON_PALMAS=y
CONFIG_MEMORY=y
# CONFIG_IIO is not set
CONFIG_NTB=y
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=m
# CONFIG_VME_TSI148 is not set

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=m

#
# VME Device Drivers
#
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_IPACK_BUS=m
CONFIG_BOARD_TPCI200=m
CONFIG_SERIAL_IPOCTAL=m
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=m
CONFIG_FMC_FAKEDEV=m
CONFIG_FMC_TRIVIAL=m
CONFIG_FMC_WRITE_EEPROM=m
CONFIG_FMC_CHARDEV=m

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set
# CONFIG_POWERCAP is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4_FS is not set
CONFIG_FS_MBCACHE=m
CONFIG_REISERFS_FS=m
CONFIG_REISERFS_CHECK=y
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
# CONFIG_REISERFS_FS_POSIX_ACL is not set
# CONFIG_REISERFS_FS_SECURITY is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
CONFIG_JFS_DEBUG=y
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_WARN=y
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
CONFIG_NILFS2_FS=m
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m
CONFIG_CUSE=m

#
# Caches
#
CONFIG_FSCACHE=m
# CONFIG_FSCACHE_STATS is not set
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_FSCACHE_OBJECT_LIST=y
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
# CONFIG_JOLIET is not set
# CONFIG_ZISOFS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
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
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=m
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=m
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=m
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=m
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=m
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=m
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=m

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
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
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
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_SCHED_DEBUG is not set
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_PREEMPT=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
CONFIG_PROVE_RCU_DELAY=y
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
# CONFIG_RCU_CPU_STALL_INFO is not set
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=m
CONFIG_CPU_NOTIFIER_ERROR_INJECT=m
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAIL_MMC_REQUEST=y
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
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
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=m
CONFIG_INTERVAL_TREE_TEST=m
# CONFIG_PERCPU_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_ASYNC_RAID6_TEST=y
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=m
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_DMA_API_DEBUG=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_DEBUG is not set
CONFIG_IOMMU_STRESS=y
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
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
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
CONFIG_CRYPTO_USER=m
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_PCRYPT=m
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
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
# CONFIG_CRYPTO_MD5 is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=m
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=m
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_BINARY_PRINTF is not set

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
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=m
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_BCH=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_FONT_SUPPORT=m
CONFIG_FONT_8x16=y
CONFIG_FONT_AUTOSELECT=y

--EuxKj2iCbKjpUGkD--
