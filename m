Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbaBFJ5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 04:57:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:46208 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755307AbaBFJ4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 04:56:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,792,1384329600"; 
   d="scan'208";a="470734912"
Date: Thu, 6 Feb 2014 17:56:46 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [sched/preempt] INFO: rcu_sched self-detected stall on CPU { 1}
Message-ID: <20140206095646.GE17971@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1LKvkjL3sHcu1TtY"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Peter,

We noticed the below RCU stalls which will block the system.
The problem is bisected to

commit 8cb75e0c4ec9786b81439761eac1d18d4a931af3
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed Nov 20 12:22:37 2013 +0100
Commit:     Ingo Molnar <mingo@kernel.org>
CommitDate: Mon Jan 13 17:38:55 2014 +0100

    sched/preempt: Fix up missed PREEMPT_NEED_RESCHED folding
    
 arch/x86/include/asm/mwait.h |  2 +-
 include/linux/preempt.h      | 15 +++++++++++++++
 include/linux/sched.h        | 15 +++++++++++++++
 kernel/cpu/idle.c            | 17 ++++++++++-------
 kernel/sched/core.c          |  3 +--
 5 files changed, 42 insertions(+), 10 deletions(-)

[   85.786775] INFO: rcu_sched self-detected stall on CPU { 1}  (t=15000 jiffies g=233 c=232 q=1940)
[   85.788745] sending NMI to all CPUs:
[   85.789539] NMI backtrace for cpu 0
[   85.790389] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.13.0-rc8-wl-05610-gb524b38-dirty #1
[   85.792043] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   85.793072] task: ffffffff82211440 ti: ffffffff82200000 task.ti: ffffffff82200000
[   85.794631] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_safe_halt+0x6/0x8
[   85.796314] RSP: 0018:ffffffff82201ec8  EFLAGS: 00000246
[   85.797286] RAX: 0000000000000000 RBX: ffffffff82201fd8 RCX: 00000000ffffffff
[   85.798507] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 0000000000000046
[   85.799680] RBP: ffffffff82201ec8 R08: 0000000000000000 R09: 0000000000000000
[   85.800862] R10: 0000000000000000 R11: 0000000000000400 R12: 0000000000000000
[   85.802055] R13: ffffffff82201fd8 R14: ffffffff82201fd8 R15: 00000000ffffffff
[   85.803243] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000000
[   85.804872] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   85.806014] CR2: 00007feec94d2000 CR3: 000000007f7a2000 CR4: 00000000000006f0
[   85.807265] Stack:
[   85.807907]  ffffffff82201ee8 ffffffff81041811 ffffffff82201fd8 ffffffff82201fd8
[   85.809808]  ffffffff82201ef8 ffffffff81041f3d ffffffff82201f40 ffffffff8110be4c
[   85.811649]  ffff88011ffa3ec0 35ceeb7d84596041 ffffffffffffffff ffffffff823ef8d0
[   85.813483] Call Trace:
[   85.814198]  [<ffffffff81041811>] default_idle+0x38/0xc1
[   85.815171]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[   85.816152]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[   85.817201]  [<ffffffff81a022c3>] rest_init+0x87/0x89
[   85.818204]  [<ffffffff8234be04>] start_kernel+0x435/0x440
[   85.819197]  [<ffffffff8234b7dd>] ? repair_env_string+0x58/0x58
[   85.820241]  [<ffffffff8234b120>] ? early_idt_handlers+0x120/0x120
[   85.821311]  [<ffffffff8234b498>] x86_64_start_reservations+0x2a/0x2c
[   85.822434]  [<ffffffff8234b5d5>] x86_64_start_kernel+0x13b/0x148
[   85.823545] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 <5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5 


[  608.380273] INFO: rcu_sched self-detected stall on CPU { 0}  (t=15000 jiffies g=5755 c=5754 q=18379)
[  608.383101] sending NMI to all CPUs:
[  608.383940] NMI backtrace for cpu 0
[  608.384786] CPU: 0 PID: 692 Comm: kswapd0 Not tainted 3.13.0-rc7-00177-g8cb75e0 #1
[  608.392624] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  608.393750] task: ffff8801195f5a00 ti: ffff8800b6468000 task.ti: ffff8800b6468000
[  608.395395] RIP: 0010:[<ffffffff81060dd2>]  [<ffffffff81060dd2>] flat_send_IPI_mask+0x7e/0xac
[  608.397299] RSP: 0018:ffff88011fc03dd0  EFLAGS: 00010046
[  608.398342] RAX: 0000000000000c00 RBX: 0000000000000046 RCX: 0000000000000007
[  608.399622] RDX: ffffffff82221ca0 RSI: 0000000000000002 RDI: 0000000000000300
[  608.400863] RBP: ffff88011fc03df0 R08: 0000000000000000 R09: 0000000000000000
[  608.402152] R10: 000000000000c120 R11: 0000000000000000 R12: 0000000000000002
[  608.403398] R13: 0000000000000c00 R14: 000000000000000f R15: 0000000000000000
[  608.404650] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000000
[  608.406431] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  608.407528] CR2: 00000000006e5dc8 CR3: 000000000220c000 CR4: 00000000000006f0
[  608.408821] Stack:
[  608.409485]  0000000000002710 ffff88011fc0d800 0000000000000000 ffffffff8224da00
[  608.411472]  ffff88011fc03e00 ffffffff81061079 ffff88011fc03e18 ffffffff8105e2b1
[  608.413416]  ffffffff8224da00 ffff88011fc03e70 ffffffff81111e9b ffff88011fc13040
[  608.415381] Call Trace:
[  608.416100]  <IRQ> 
[  608.416398]  [<ffffffff81061079>] flat_send_IPI_all+0x1f/0x4a
[  608.418058]  [<ffffffff8105e2b1>] arch_trigger_all_cpu_backtrace+0x52/0x84
[  608.419311]  [<ffffffff81111e9b>] rcu_check_callbacks+0x205/0x57f
[  608.420480]  [<ffffffff8111b057>] ? tick_sched_do_timer+0x2f/0x2f
[  608.421628]  [<ffffffff810d044e>] update_process_times+0x3d/0x65
[  608.422779]  [<ffffffff8111af6c>] tick_sched_handle+0x37/0x43
[  608.423872]  [<ffffffff8111b091>] tick_sched_timer+0x3a/0x58
[  608.424958]  [<ffffffff810e3ac7>] __run_hrtimer+0x96/0x19a
[  608.426059]  [<ffffffff810e42ff>] hrtimer_interrupt+0xe8/0x1e3
[  608.427167]  [<ffffffff8105cbf1>] local_apic_timer_interrupt+0x54/0x57
[  608.428390]  [<ffffffff81a0f123>] smp_apic_timer_interrupt+0x3f/0x50
[  608.429561]  [<ffffffff81a0de32>] apic_timer_interrupt+0x72/0x80
[  608.430686]  <EOI> 
[  608.430977]  [<ffffffff814f2f9a>] ? find_last_bit+0x4a/0x4a
[  608.432785]  [<ffffffff8116d25f>] ? zone_watermark_ok_safe+0x61/0xad
[  608.433954]  [<ffffffff81177dac>] zone_balanced+0x1e/0x43
[  608.435042]  [<ffffffff8117b461>] balance_pgdat+0x3b6/0x501
[  608.436132]  [<ffffffff8117b8eb>] kswapd+0x33f/0x3c7
[  608.437169]  [<ffffffff810fb058>] ? __wake_up_sync+0x12/0x12
[  608.438272]  [<ffffffff8117b5ac>] ? balance_pgdat+0x501/0x501
[  608.439367]  [<ffffffff810e155c>] kthread+0xdb/0xe3
[  608.440394]  [<ffffffff810e1481>] ? kthread_create_on_node+0x16f/0x16f
[  608.441586]  [<ffffffff81a0d1bc>] ret_from_fork+0x7c/0xb0
[  608.442637]  [<ffffffff810e1481>] ? kthread_create_on_node+0x16f/0x16f
[  608.443852] Code: eb f0 44 89 f0 c1 e0 18 89 04 25 10 33 5f ff 44 89 e0 44 09 e8 41 81 cd 00 04 00 00 41 83 fc 02 41 0f 44 c5 89 04 25 00 33 5f ff <f6> c7 02 75 11 48 89 df 57 9d 0f 1f 44 00 00 e8 6e 94 0e 00 eb 

Full dmesgs and kconfig are attached.

Thanks,
Fengguang

--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg-ltp
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.13.0-rc7-00177-g8cb75e0 (kbuild@xian) (gcc v=
ersion 4.8.1 (Debian 4.8.1-8) ) #1 SMP Sun Feb 2 01:42:31 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vpx-4/bisect_l=
tp-syscalls-x86_64-lkp-8cb75e0c4ec9786b81439761eac1d18d4a931af3-0.yaml ARCH=
=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/8cb75e0c4ec9786b81439761eac1d18d4=
a931af3/vmlinuz-3.13.0-rc7-00177-g8cb75e0 kconfig=3Dx86_64-lkp commit=3D8cb=
75e0c4ec9786b81439761eac1d18d4a931af3 bm_initrd=3D/lkp/benchmarks/ltp.cgz m=
odules_initrd=3D/kernel/x86_64-lkp/8cb75e0c4ec9786b81439761eac1d18d4a931af3=
/modules.cgz max_uptime=3D1725 RESULT_ROOT=3D/lkp/result/vpx/micro/ltp/sysc=
alls/x86_64-lkp/8cb75e0c4ec9786b81439761eac1d18d4a931af3/0 initrd=3D/kernel=
-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::vpx-4::dhcp oops=3Dp=
anic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled pan=
ic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D2 prompt_r=
amdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dfffdfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dfffe000-0x00000000dfffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x120000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] e820: last_pfn =3D 0xdfffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fda90-0x000fda9f] mapped at =
[ffff8800000fda90]
[    0.000000]   mpc: fdaa0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0265c000, 0x0265cfff] PGTABLE
[    0.000000] BRK [0x0265d000, 0x0265dfff] PGTABLE
[    0.000000] BRK [0x0265e000, 0x0265efff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11fe00000-0x11fffffff]
[    0.000000]  [mem 0x11fe00000-0x11fffffff] page 2M
[    0.000000] BRK [0x0265f000, 0x0265ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11fdfffff]
[    0.000000]  [mem 0x11c000000-0x11fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdfffdfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xdfdfffff] page 2M
[    0.000000]  [mem 0xdfe00000-0xdfffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x70b04000-0x7fffffff]
[    0.000000] ACPI: RSDP 00000000000fd880 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 00000000dfffe380 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 00000000dfffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 00000000dfffe3c0 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 00000000dfffff40 000040
[    0.000000] ACPI: SSDT 00000000dffff6e0 000858 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 00000000dffff5b0 000090 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 00000000dffff570 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x11fffffff]
[    0.000000]   NODE_DATA [mem 0x11fff7000-0x11fffbfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 1:1ffef001, boot clock
[   22.047706]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff88011b60000=
0-ffff88011f5fffff] on node 0
[   22.048677] Zone ranges:
[   22.048924]   DMA      [mem 0x00001000-0x00ffffff]
[   22.049393]   DMA32    [mem 0x01000000-0xffffffff]
[   22.049862]   Normal   [mem 0x100000000-0x11fffffff]
[   22.050351] Movable zone start for each node
[   22.050763] Early memory node ranges
[   22.051111]   node   0: [mem 0x00001000-0x0009efff]
[   22.051608]   node   0: [mem 0x00100000-0xdfffdfff]
[   22.052077]   node   0: [mem 0x100000000-0x11fffffff]
[   22.052592] On node 0 totalpages: 1048476
[   22.052981]   DMA zone: 64 pages used for memmap
[   22.053446]   DMA zone: 21 pages reserved
[   22.053829]   DMA zone: 3998 pages, LIFO batch:0
[   22.054411]   DMA32 zone: 14272 pages used for memmap
[   22.054908]   DMA32 zone: 913406 pages, LIFO batch:31
[   22.073562]   Normal zone: 2048 pages used for memmap
[   22.074093]   Normal zone: 131072 pages, LIFO batch:31
[   22.077700] ACPI: PM-Timer IO Port: 0xb008
[   22.078109] ACPI: Local APIC address 0xfee00000
[   22.078556] mapped APIC to ffffffffff5f3000 (        fee00000)
[   22.079127] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[   22.079696] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[   22.080259] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[   22.080830] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[   22.081411] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[   22.081972] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[   22.082612] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[   22.083281] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[   22.083905] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[   22.084619] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[   22.085259] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[   22.085965] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[   22.086613] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[   22.087318] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[   22.087979] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[   22.088683] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[   22.089345] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[   22.090050] ACPI: IRQ0 used by override.
[   22.090438] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[   22.091143] ACPI: IRQ2 used by override.
[   22.091528] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[   22.092230] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[   22.092950] ACPI: IRQ5 used by override.
[   22.093352] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[   22.094046] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[   22.094749] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[   22.095454] ACPI: IRQ9 used by override.
[   22.095834] ACPI: IRQ10 used by override.
[   22.096221] ACPI: IRQ11 used by override.
[   22.096616] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[   22.097315] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[   22.098028] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[   22.098729] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[   22.099433] Using ACPI (MADT) for SMP configuration information
[   22.099998] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[   22.100504] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[   22.100996] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[   22.101528] nr_irqs_gsi: 40
[   22.101818] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[   22.102451] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[   22.103072] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[   22.103702] PM: Registered nosave memory: [mem 0xdfffe000-0xdfffffff]
[   22.104381] PM: Registered nosave memory: [mem 0xe0000000-0xfeffbfff]
[   22.105010] PM: Registered nosave memory: [mem 0xfeffc000-0xfeffffff]
[   22.105646] PM: Registered nosave memory: [mem 0xff000000-0xfffbffff]
[   22.106274] PM: Registered nosave memory: [mem 0xfffc0000-0xffffffff]
[   22.106909] e820: [mem 0xe0000000-0xfeffbfff] available for PCI devices
[   22.107579] Booting paravirtualized kernel on KVM
[   22.108050] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 n=
r_node_ids:1
[   22.109138] PERCPU: Embedded 27 pages/cpu @ffff88011fc00000 s81216 r8192=
 d21184 u524288
[   22.109926] pcpu-alloc: s81216 r8192 d21184 u524288 alloc=3D1*2097152
[   22.110559] pcpu-alloc: [0] 0 1 2 3=20
[   22.110926] kvm-clock: cpu 0, msr 1:1ffef001, primary cpu clock
[   22.111526] KVM setup async PF for cpu 0
[   22.111900] kvm-stealtime: cpu 0, msr 11fc0d040
[   22.112342] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 1032071
[   22.113136] Policy zone: Normal
[   22.113443] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vpx-4/b=
isect_ltp-syscalls-x86_64-lkp-8cb75e0c4ec9786b81439761eac1d18d4a931af3-0.ya=
ml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/8cb75e0c4ec9786b81439761ea=
c1d18d4a931af3/vmlinuz-3.13.0-rc7-00177-g8cb75e0 kconfig=3Dx86_64-lkp commi=
t=3D8cb75e0c4ec9786b81439761eac1d18d4a931af3 bm_initrd=3D/lkp/benchmarks/lt=
p.cgz modules_initrd=3D/kernel/x86_64-lkp/8cb75e0c4ec9786b81439761eac1d18d4=
a931af3/modules.cgz max_uptime=3D1725 RESULT_ROOT=3D/lkp/result/vpx/micro/l=
tp/syscalls/x86_64-lkp/8cb75e0c4ec9786b81439761eac1d18d4a931af3/0 initrd=3D=
/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::vpx-4::dhcp o=
ops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enab=
led panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D2 p=
rompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal
[   22.121005] sysrq: sysrq always enabled.
[   22.121574] PID hash table entries: 4096 (order: 3, 32768 bytes)
[   22.169429] Checking aperture...
[   22.216702] No AGP bridge found
[   22.229252] Memory: 3787696K/4193904K available (10313K kernel code, 123=
8K rwdata, 4144K rodata, 1424K init, 1744K bss, 406208K reserved)
[   22.230489] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4, N=
odes=3D1
[   22.231122] Hierarchical RCU implementation.
[   22.231517]=20
[   22.232084]=20
[   22.232655] NR_IRQS:33024 nr_irqs:712 16
[   22.248838] Console: colour VGA+ 80x25
[   22.249184] console [tty0] enabled
[   22.249623] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.13.0-rc7-00177-g8cb75e0 (kbuild@xian) (gcc v=
ersion 4.8.1 (Debian 4.8.1-8) ) #1 SMP Sun Feb 2 01:42:31 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vpx-4/bisect_l=
tp-syscalls-x86_64-lkp-8cb75e0c4ec9786b81439761eac1d18d4a931af3-0.yaml ARCH=
=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/8cb75e0c4ec9786b81439761eac1d18d4=
a931af3/vmlinuz-3.13.0-rc7-00177-g8cb75e0 kconfig=3Dx86_64-lkp commit=3D8cb=
75e0c4ec9786b81439761eac1d18d4a931af3 bm_initrd=3D/lkp/benchmarks/ltp.cgz m=
odules_initrd=3D/kernel/x86_64-lkp/8cb75e0c4ec9786b81439761eac1d18d4a931af3=
/modules.cgz max_uptime=3D1725 RESULT_ROOT=3D/lkp/result/vpx/micro/ltp/sysc=
alls/x86_64-lkp/8cb75e0c4ec9786b81439761eac1d18d4a931af3/0 initrd=3D/kernel=
-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::vpx-4::dhcp oops=3Dp=
anic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enabled pan=
ic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D2 prompt_r=
amdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dfffdfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dfffe000-0x00000000dfffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x120000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] e820: last_pfn =3D 0xdfffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fda90-0x000fda9f] mapped at =
[ffff8800000fda90]
[    0.000000]   mpc: fdaa0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0265c000, 0x0265cfff] PGTABLE
[    0.000000] BRK [0x0265d000, 0x0265dfff] PGTABLE
[    0.000000] BRK [0x0265e000, 0x0265efff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11fe00000-0x11fffffff]
[    0.000000]  [mem 0x11fe00000-0x11fffffff] page 2M
[    0.000000] BRK [0x0265f000, 0x0265ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11fdfffff]
[    0.000000]  [mem 0x11c000000-0x11fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdfffdfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xdfdfffff] page 2M
[    0.000000]  [mem 0xdfe00000-0xdfffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x70b04000-0x7fffffff]
[    0.000000] ACPI: RSDP 00000000000fd880 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 00000000dfffe380 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 00000000dfffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 00000000dfffe3c0 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 00000000dfffff40 000040
[    0.000000] ACPI: SSDT 00000000dffff6e0 000858 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 00000000dffff5b0 000090 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 00000000dffff570 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x11fffffff]
[    0.000000]   NODE_DATA [mem 0x11fff7000-0x11fffbfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 1:1ffef001, boot clock
[   22.047706]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff88011b60000=
0-ffff88011f5fffff] on node 0
[   22.048677] Zone ranges:
[   22.048924]   DMA      [mem 0x00001000-0x00ffffff]
[   22.049393]   DMA32    [mem 0x01000000-0xffffffff]
[   22.049862]   Normal   [mem 0x100000000-0x11fffffff]
[   22.050351] Movable zone start for each node
[   22.050763] Early memory node ranges
[   22.051111]   node   0: [mem 0x00001000-0x0009efff]
[   22.051608]   node   0: [mem 0x00100000-0xdfffdfff]
[   22.052077]   node   0: [mem 0x100000000-0x11fffffff]
[   22.052592] On node 0 totalpages: 1048476
[   22.052981]   DMA zone: 64 pages used for memmap
[   22.053446]   DMA zone: 21 pages reserved
[   22.053829]   DMA zone: 3998 pages, LIFO batch:0
[   22.054411]   DMA32 zone: 14272 pages used for memmap
[   22.054908]   DMA32 zone: 913406 pages, LIFO batch:31
[   22.073562]   Normal zone: 2048 pages used for memmap
[   22.074093]   Normal zone: 131072 pages, LIFO batch:31
[   22.077700] ACPI: PM-Timer IO Port: 0xb008
[   22.078109] ACPI: Local APIC address 0xfee00000
[   22.078556] mapped APIC to ffffffffff5f3000 (        fee00000)
[   22.079127] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[   22.079696] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[   22.080259] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[   22.080830] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[   22.081411] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[   22.081972] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[   22.082612] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[   22.083281] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[   22.083905] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[   22.084619] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[   22.085259] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[   22.085965] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[   22.086613] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[   22.087318] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[   22.087979] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[   22.088683] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[   22.089345] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[   22.090050] ACPI: IRQ0 used by override.
[   22.090438] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[   22.091143] ACPI: IRQ2 used by override.
[   22.091528] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[   22.092230] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[   22.092950] ACPI: IRQ5 used by override.
[   22.093352] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[   22.094046] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[   22.094749] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[   22.095454] ACPI: IRQ9 used by override.
[   22.095834] ACPI: IRQ10 used by override.
[   22.096221] ACPI: IRQ11 used by override.
[   22.096616] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[   22.097315] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[   22.098028] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[   22.098729] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[   22.099433] Using ACPI (MADT) for SMP configuration information
[   22.099998] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[   22.100504] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[   22.100996] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[   22.101528] nr_irqs_gsi: 40
[   22.101818] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[   22.102451] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[   22.103072] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[   22.103702] PM: Registered nosave memory: [mem 0xdfffe000-0xdfffffff]
[   22.104381] PM: Registered nosave memory: [mem 0xe0000000-0xfeffbfff]
[   22.105010] PM: Registered nosave memory: [mem 0xfeffc000-0xfeffffff]
[   22.105646] PM: Registered nosave memory: [mem 0xff000000-0xfffbffff]
[   22.106274] PM: Registered nosave memory: [mem 0xfffc0000-0xffffffff]
[   22.106909] e820: [mem 0xe0000000-0xfeffbfff] available for PCI devices
[   22.107579] Booting paravirtualized kernel on KVM
[   22.108050] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 n=
r_node_ids:1
[   22.109138] PERCPU: Embedded 27 pages/cpu @ffff88011fc00000 s81216 r8192=
 d21184 u524288
[   22.109926] pcpu-alloc: s81216 r8192 d21184 u524288 alloc=3D1*2097152
[   22.110559] pcpu-alloc: [0] 0 1 2 3=20
[   22.110926] kvm-clock: cpu 0, msr 1:1ffef001, primary cpu clock
[   22.111526] KVM setup async PF for cpu 0
[   22.111900] kvm-stealtime: cpu 0, msr 11fc0d040
[   22.112342] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 1032071
[   22.113136] Policy zone: Normal
[   22.113443] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vpx-4/b=
isect_ltp-syscalls-x86_64-lkp-8cb75e0c4ec9786b81439761eac1d18d4a931af3-0.ya=
ml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/8cb75e0c4ec9786b81439761ea=
c1d18d4a931af3/vmlinuz-3.13.0-rc7-00177-g8cb75e0 kconfig=3Dx86_64-lkp commi=
t=3D8cb75e0c4ec9786b81439761eac1d18d4a931af3 bm_initrd=3D/lkp/benchmarks/lt=
p.cgz modules_initrd=3D/kernel/x86_64-lkp/8cb75e0c4ec9786b81439761eac1d18d4=
a931af3/modules.cgz max_uptime=3D1725 RESULT_ROOT=3D/lkp/result/vpx/micro/l=
tp/syscalls/x86_64-lkp/8cb75e0c4ec9786b81439761eac1d18d4a931af3/0 initrd=3D=
/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::vpx-4::dhcp o=
ops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_enab=
led panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_ramdisk=3D2 p=
rompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal
[   22.121005] sysrq: sysrq always enabled.
[   22.121574] PID hash table entries: 4096 (order: 3, 32768 bytes)
[   22.169429] Checking aperture...
[   22.216702] No AGP bridge found
[   22.229252] Memory: 3787696K/4193904K available (10313K kernel code, 123=
8K rwdata, 4144K rodata, 1424K init, 1744K bss, 406208K reserved)
[   22.230489] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4, N=
odes=3D1
[   22.231122] Hierarchical RCU implementation.
[   22.231517]=20
[   22.232084]=20
[   22.232655] NR_IRQS:33024 nr_irqs:712 16
[   22.248838] Console: colour VGA+ 80x25
[   22.249184] console [tty0] enabled
[   22.249623] bootconsole [earlyser0] disabled
[   22.350709] console [ttyS0] enabled
[   22.362140] allocated 16777216 bytes of page_cgroup
[   22.362826] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[   22.364094] hpet clockevent registered
[   22.364712] tsc: Detected 2693.600 MHz processor
[   22.365309] Calibrating delay loop (skipped) preset value.. 5387.20 Bogo=
MIPS (lpj=3D10774400)
[   22.366430] pid_max: default: 32768 minimum: 301
[   22.367301] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[   22.372084] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[   22.374918] Mount-cache hash table entries: 256
[   22.376243] Initializing cgroup subsys memory
[   22.377174] Initializing cgroup subsys devices
[   22.378112] Initializing cgroup subsys freezer
[   22.379086] Initializing cgroup subsys blkio
[   22.379990] Initializing cgroup subsys perf_event
[   22.381004] Initializing cgroup subsys hugetlb
[   22.381991] mce: CPU supports 10 MCE banks
[   22.382921] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[   22.382921] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[   22.382921] tlb_flushall_shift: 6
[   22.385704] Freeing SMP alternatives memory: 44K (ffffffff8249b000 - fff=
fffff824a6000)
[   22.391853] ACPI: Core revision 20131115
[   22.393494] ACPI: All ACPI Tables successfully acquired
[   22.394673] ftrace: allocating 39709 entries in 156 pages
[   22.440009] Getting VERSION: 50014
[   22.440865] Getting VERSION: 50014
[   22.441694] Getting ID: 0
[   22.442442] Getting ID: ff000000
[   22.443227] Getting LVT0: 8700
[   22.443998] Getting LVT1: 8400
[   22.444877] enabled ExtINT on CPU#0
[   22.446404] ENABLING IO-APIC IRQs
[   22.447196] init IO_APIC IRQs
[   22.447953]  apic 0 pin 0 not connected
[   22.448867] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[   22.450544] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[   22.452287] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[   22.453971] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[   22.455660] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[   22.457383] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[   22.459038] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[   22.460777] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[   22.462425] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[   22.464072] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[   22.465826] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[   22.467499] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[   22.469262] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[   22.470923] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[   22.472669] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[   22.474329]  apic 0 pin 16 not connected
[   22.475169]  apic 0 pin 17 not connected
[   22.476012]  apic 0 pin 18 not connected
[   22.476907]  apic 0 pin 19 not connected
[   22.477755]  apic 0 pin 20 not connected
[   22.478596]  apic 0 pin 21 not connected
[   22.479449]  apic 0 pin 22 not connected
[   22.480369]  apic 0 pin 23 not connected
[   22.481362] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[   22.482662] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[   22.484979] Using local APIC timer interrupts.
[   22.484979] calibrating APIC timer ...
[   22.592142] ... lapic delta =3D 6249974
[   22.593123] ... PM-Timer delta =3D 357966
[   22.594097] ... PM-Timer result ok
[   22.594996] ..... delta 6249974
[   22.595871] ..... mult: 268434339
[   22.596853] ..... calibration result: 3999983
[   22.597936] ..... CPU clock speed is 2693.1969 MHz.
[   22.599076] ..... host bus clock speed is 999.3983 MHz.
[   22.600388] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[   22.604532] x86: Booting SMP configuration:
[   22.605578] .... node  #0, CPUs:      #1
[   22.616383] kvm-clock: cpu 1, msr 1:1ffef041, secondary cpu clock
[   22.617358] masked ExtINT on CPU#1
[   22.637891] KVM setup async PF for cpu 1
 #2
[   22.639323] kvm-stealtime: cpu 1, msr 11fc8d040
[   22.648088] kvm-clock: cpu 2, msr 1:1ffef081, secondary cpu clock
[   22.649083] masked ExtINT on CPU#2
[   22.669597] KVM setup async PF for cpu 2
 #3
[   22.670671] kvm-stealtime: cpu 2, msr 11fd0d040
[   22.679787] kvm-clock: cpu 3, msr 1:1ffef0c1, secondary cpu clock
[   22.680784] masked ExtINT on CPU#3

[   22.701307] x86: Booted up 1 node, 4 CPUs
[   22.701308] KVM setup async PF for cpu 3
[   22.701312] kvm-stealtime: cpu 3, msr 11fd8d040
[   22.704401] smpboot: Total of 4 processors activated (21548.80 BogoMIPS)
[   22.706613] devtmpfs: initialized
[   22.711860] xor: measuring software checksum speed
[   22.752366]    prefetch64-sse:   166.000 MB/sec
[   22.792367]    generic_sse:   159.000 MB/sec
[   22.793274] xor: using function: prefetch64-sse (166.000 MB/sec)
[   22.794408] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[   22.795835] NET: Registered protocol family 16
[   22.798525] cpuidle: using governor ladder
[   22.799460] cpuidle: using governor menu
[   22.800766] ACPI: bus type PCI registered
[   22.801650] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[   22.803115] PCI: Using configuration type 1 for base access
[   22.828063] bio: create slab <bio-0> at 0
[   22.896359] raid6: sse2x1    6734 MB/s
[   22.964350] raid6: sse2x2    8636 MB/s
[   23.032348] raid6: sse2x4   11258 MB/s
[   23.033187] raid6: using algorithm sse2x4 (11258 MB/s)
[   23.034206] raid6: using intx1 recovery algorithm
[   23.035243] ACPI: Added _OSI(Module Device)
[   23.036130] ACPI: Added _OSI(Processor Device)
[   23.037034] ACPI: Added _OSI(3.0 _SCP Extensions)
[   23.038021] ACPI: Added _OSI(Processor Aggregator Device)
[   23.040743] ACPI: Interpreter enabled
[   23.041596] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20131115/hwxface-580)
[   23.043533] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20131115/hwxface-580)
[   23.045488] ACPI: (supports S0 S3 S4 S5)
[   23.046355] ACPI: Using IOAPIC for interrupt routing
[   23.047454] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[   23.049521] ACPI: No dock devices found.
[   23.056675] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[   23.057840] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MS=
I]
[   23.059039] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[   23.060310] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[   23.062859] acpiphp: Slot [3] registered
[   23.063871] acpiphp: Slot [4] registered
[   23.064847] acpiphp: Slot [5] registered
[   23.065856] acpiphp: Slot [6] registered
[   23.066805] acpiphp: Slot [7] registered
[   23.067780] acpiphp: Slot [8] registered
[   23.068784] acpiphp: Slot [9] registered
[   23.069739] acpiphp: Slot [10] registered
[   23.070698] acpiphp: Slot [11] registered
[   23.071654] acpiphp: Slot [12] registered
[   23.072642] acpiphp: Slot [13] registered
[   23.073615] acpiphp: Slot [14] registered
[   23.074588] acpiphp: Slot [15] registered
[   23.075544] acpiphp: Slot [16] registered
[   23.076533] acpiphp: Slot [17] registered
[   23.077501] acpiphp: Slot [18] registered
[   23.078456] acpiphp: Slot [19] registered
[   23.079444] acpiphp: Slot [20] registered
[   23.080437] acpiphp: Slot [21] registered
[   23.081386] acpiphp: Slot [22] registered
[   23.082344] acpiphp: Slot [23] registered
[   23.083338] acpiphp: Slot [24] registered
[   23.084280] acpiphp: Slot [25] registered
[   23.085263] acpiphp: Slot [26] registered
[   23.086249] acpiphp: Slot [27] registered
[   23.087208] acpiphp: Slot [28] registered
[   23.088160] acpiphp: Slot [29] registered
[   23.089149] acpiphp: Slot [30] registered
[   23.090129] acpiphp: Slot [31] registered
[   23.091015] PCI host bridge to bus 0000:00
[   23.091918] pci_bus 0000:00: root bus resource [bus 00-ff]
[   23.092958] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[   23.094093] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[   23.095203] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[   23.096404] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebffff=
f]
[   23.097672] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[   23.099179] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[   23.100812] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[   23.104866] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[   23.107273] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[   23.108756] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[   23.110392] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[   23.111905] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[   23.119654] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[   23.122219] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[   23.129927] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[   23.131870] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[   23.134091] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[   23.136183] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[   23.148157] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[   23.149709] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[   23.151851] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[   23.153935] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[   23.160474] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[   23.162665] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[   23.164690] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[   23.171269] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[   23.173446] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[   23.175494] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[   23.182075] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[   23.184189] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[   23.186302] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[   23.192862] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[   23.195025] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[   23.197051] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[   23.203570] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[   23.205752] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[   23.207790] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[   23.214312] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[   23.215969] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[   23.221056] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[   23.222604] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[   23.224071] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[   23.225617] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[   23.227088] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[   23.228861] ACPI: Enabled 16 GPEs in block 00 to 0F
[   23.230018] ACPI: \_SB_.PCI0: notify handler is installed
[   23.231051] Found 1 acpi root devices
[   23.232793] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[   23.234532] vgaarb: loaded
[   23.235237] vgaarb: bridge control possible 0000:00:02.0
[   23.236765] SCSI subsystem initialized
[   23.238181] libata version 3.00 loaded.
[   23.239448] ACPI: bus type USB registered
[   23.240524] usbcore: registered new interface driver usbfs
[   23.241667] usbcore: registered new interface driver hub
[   23.242831] usbcore: registered new device driver usb
[   23.244114] pps_core: LinuxPPS API ver. 1 registered
[   23.245137] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[   23.247011] PTP clock support registered
[   23.248203] EDAC MC: Ver: 3.0.0
[   23.249402] PCI: Using ACPI for IRQ routing
[   23.250317] PCI: pci_cache_line_size set to 64 bytes
[   23.251505] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[   23.252644] e820: reserve RAM buffer [mem 0xdfffe000-0xdfffffff]
[   23.254801] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[   23.256060] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[   23.257399] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[   23.264262] Switched to clocksource kvm-clock
[   23.279233] pnp: PnP ACPI init
[   23.280112] ACPI: bus type PNP registered
[   23.281112] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:15)
[   23.282982] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[   23.284226] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:15)
[   23.286204] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[   23.287452] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:15)
[   23.289339] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[   23.290563] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:15)
[   23.292220] pnp 00:03: [dma 2]
[   23.293168] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[   23.294391] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:15)
[   23.296202] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[   23.297454] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:15)
[   23.299236] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[   23.300661] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[   23.301905] pnp: PnP ACPI: found 7 devices
[   23.302771] ACPI: bus type PNP unregistered
[   23.319117] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[   23.320200] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[   23.321284] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[   23.322424] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[   23.323635] NET: Registered protocol family 2
[   23.324801] TCP established hash table entries: 32768 (order: 6, 262144 =
bytes)
[   23.326556] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[   23.328131] TCP: Hash tables configured (established 32768 bind 32768)
[   23.329461] TCP: reno registered
[   23.330236] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[   23.331369] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[   23.332690] NET: Registered protocol family 1
[   23.333833] RPC: Registered named UNIX socket transport module.
[   23.334913] RPC: Registered udp transport module.
[   23.335843] RPC: Registered tcp transport module.
[   23.336823] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   23.337959] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[   23.339035] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[   23.340092] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[   23.341248] pci 0000:00:02.0: Boot video device
[   23.342231] PCI: CLS 0 bytes, default 64
[   23.343157] Trying to unpack rootfs image as initramfs...
[   28.132244] Freeing initrd memory: 250864K (ffff880070b04000 - ffff88008=
0000000)
[   28.133894] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[   28.135008] software IO TLB [mem 0xdbffe000-0xdfffe000] (64MB) mapped at=
 [ffff8800dbffe000-ffff8800dfffdfff]
[   28.137353] kvm: no hardware support
[   28.138877] Scanning for low memory corruption every 60 seconds
[   28.140224] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[   28.142026] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[   28.143924] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[   28.147181] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[   28.148327] PCLMULQDQ-NI instructions are not detected.
[   28.149342] AVX or AES-NI instructions are not detected.
[   28.150338] AVX instructions are not detected.
[   28.151237] AVX instructions are not detected.
[   28.152137] AVX instructions are not detected.
[   28.153055] AVX instructions are not detected.
[   28.179894] bounce pool size: 64 pages
[   28.180847] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   28.189937] VFS: Disk quotas dquot_6.5.2
[   28.190969] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   28.194453] NFS: Registering the id_resolver key type
[   28.195485] Key type id_resolver registered
[   28.196407] Key type id_legacy registered
[   28.197301] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[   28.198499] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   28.200394] ROMFS MTD (C) 2007 Red Hat, Inc.
[   28.201552] fuse init (API version 7.22)
[   28.202804] SGI XFS with ACLs, security attributes, realtime, large bloc=
k/inode numbers, no debug enabled
[   28.206341] bio: create slab <bio-1> at 1
[   28.207814] Btrfs loaded
[   28.208599] msgmni has been set to 7887
[   28.215840] NET: Registered protocol family 38
[   28.216823] Key type asymmetric registered
[   28.217913] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[   28.219659] io scheduler noop registered
[   28.220550] io scheduler deadline registered
[   28.221476] io scheduler cfq registered (default)
[   28.222887] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   28.224184] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[   28.225609] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   28.227257] ACPI: Power Button [PWRF]
[   28.228536] GHES: HEST is not enabled!
[   28.229885] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[   28.230974] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:15)
[   28.234364] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[   28.235443] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:15)
[   28.238801] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[   28.241729] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[   28.249983] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   28.272535] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[   28.275461] Non-volatile memory driver v1.3
[   28.279564] brd: module loaded
[   28.282164] loop: module loaded
[   28.283132] virtio-pci 0000:00:04.0: irq 40 for MSI/MSI-X
[   28.284185] virtio-pci 0000:00:04.0: irq 41 for MSI/MSI-X
[   28.285468] blk-mq: CPU -> queue map
[   28.286297]   CPU 0 -> Queue 0
[   28.287056]   CPU 1 -> Queue 0
[   28.287811]   CPU 2 -> Queue 0
[   28.288599]   CPU 3 -> Queue 0
[   28.290131]  vda: unknown partition table
[   28.293024] virtio-pci 0000:00:05.0: irq 42 for MSI/MSI-X
[   28.294047] virtio-pci 0000:00:05.0: irq 43 for MSI/MSI-X
[   28.295249] blk-mq: CPU -> queue map
[   28.296063]   CPU 0 -> Queue 0
[   28.296820]   CPU 1 -> Queue 0
[   28.297560]   CPU 2 -> Queue 0
[   28.298295]   CPU 3 -> Queue 0
[   28.300072]  vdb: unknown partition table
[   28.303342] virtio-pci 0000:00:06.0: irq 44 for MSI/MSI-X
[   28.304338] virtio-pci 0000:00:06.0: irq 45 for MSI/MSI-X
[   28.310898] blk-mq: CPU -> queue map
[   28.311666]   CPU 0 -> Queue 0
[   28.312416]   CPU 1 -> Queue 0
[   28.313125]   CPU 2 -> Queue 0
[   28.313835]   CPU 3 -> Queue 0
[   28.315537]  vdc: unknown partition table
[   28.318079] virtio-pci 0000:00:07.0: irq 46 for MSI/MSI-X
[   28.319099] virtio-pci 0000:00:07.0: irq 47 for MSI/MSI-X
[   28.320272] blk-mq: CPU -> queue map
[   28.321110]   CPU 0 -> Queue 0
[   28.321849]   CPU 1 -> Queue 0
[   28.322596]   CPU 2 -> Queue 0
[   28.323345]   CPU 3 -> Queue 0
[   28.324899]  vdd: unknown partition table
[   28.327509] virtio-pci 0000:00:08.0: irq 48 for MSI/MSI-X
[   28.328529] virtio-pci 0000:00:08.0: irq 49 for MSI/MSI-X
[   28.329649] blk-mq: CPU -> queue map
[   28.330428]   CPU 0 -> Queue 0
[   28.331135]   CPU 1 -> Queue 0
[   28.331841]   CPU 2 -> Queue 0
[   28.332600]   CPU 3 -> Queue 0
[   28.334343]  vde: unknown partition table
[   28.337030] virtio-pci 0000:00:09.0: irq 50 for MSI/MSI-X
[   28.338021] virtio-pci 0000:00:09.0: irq 51 for MSI/MSI-X
[   28.339134] blk-mq: CPU -> queue map
[   28.339892]   CPU 0 -> Queue 0
[   28.340614]   CPU 1 -> Queue 0
[   28.341321]   CPU 2 -> Queue 0
[   28.342029]   CPU 3 -> Queue 0
[   28.343616]  vdf: unknown partition table
[   28.346091] lkdtm: No crash points registered, enable through debugfs
[   28.348240] Loading iSCSI transport class v2.0-870.
[   28.350410] Adaptec aacraid driver 1.2-0[30200]-ms
[   28.351504] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[   28.352938] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 8.06.00.08-k.
[   28.354816] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 ES=
T 2006)
[   28.356563] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 20=
06)
[   28.357853] megasas: 06.700.06.00-rc1 Sat. Aug. 31 17:00:00 PDT 2013
[   28.359181] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[   28.360415] RocketRAID 3xxx/4xxx Controller driver v1.8
[   28.361907] ata_piix 0000:00:01.1: version 2.13
[   28.365492] scsi0 : ata_piix
[   28.366511] scsi1 : ata_piix
[   28.367428] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc1c0 irq 14
[   28.368656] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc1c8 irq 15
[   28.370776] tun: Universal TUN/TAP device driver, 1.6
[   28.371803] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   28.373365] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.=
de
[   28.374703] Atheros(R) L2 Ethernet Driver - version 2.2.3
[   28.375746] Copyright (c) 2007 Atheros Corporation.
[   28.377191] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[   28.378486] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.=
com>
[   28.378486]   http://www.scyld.com/network/drivers.html
[   28.380882] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-2=
9)
[   28.382227] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[   28.383342] e100: Copyright(c) 1999-2006 Intel Corporation
[   28.384458] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-=
NAPI
[   28.385680] e1000: Copyright (c) 1999-2006 Intel Corporation.
[   28.524724] ata2.01: NODEV after polling detection
[   28.525933] ata2.00: ATAPI: QEMU DVD-ROM, 1.6.0, max UDMA/100
[   28.527353] ata2.00: configured for MWDMA2
[   28.528864] scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     1.=
6. PQ: 0 ANSI: 5
[   28.532493] scsi 1:0:0:0: Attached scsi generic sg0 type 5
[   28.717319] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56
[   28.718500] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
[   28.719969] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[   28.721040] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[   28.722424] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.=
5-k
[   28.723610] igb: Copyright (c) 2007-2013 Intel Corporation.
[   28.724982] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - vers=
ion 3.15.1-k
[   28.726594] ixgbe: Copyright (c) 1999-2013 Intel Corporation.
[   28.727884] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2=
-NAPI
[   28.729111] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[   28.730673] sky2: driver version 1.30
[   28.733369] usbcore: registered new interface driver catc
[   28.734527] usbcore: registered new interface driver kaweth
[   28.735596] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[   28.737322] usbcore: registered new interface driver pegasus
[   28.738483] usbcore: registered new interface driver rtl8150
[   28.739655] usbcore: registered new interface driver asix
[   28.740799] usbcore: registered new interface driver ax88179_178a
[   28.742014] usbcore: registered new interface driver cdc_ether
[   28.743192] usbcore: registered new interface driver r815x
[   28.744347] usbcore: registered new interface driver cdc_eem
[   28.745505] usbcore: registered new interface driver dm9601
[   28.746656] usbcore: registered new interface driver smsc75xx
[   28.747828] usbcore: registered new interface driver smsc95xx
[   28.749066] usbcore: registered new interface driver gl620a
[   28.750208] usbcore: registered new interface driver net1080
[   28.751365] usbcore: registered new interface driver plusb
[   28.752509] usbcore: registered new interface driver rndis_host
[   28.753694] usbcore: registered new interface driver cdc_subset
[   28.754883] usbcore: registered new interface driver zaurus
[   28.756039] usbcore: registered new interface driver MOSCHIP usb-etherne=
t driver
[   28.757807] usbcore: registered new interface driver int51x1
[   28.758966] usbcore: registered new interface driver ipheth
[   28.760111] usbcore: registered new interface driver sierra_net
[   28.761327] usbcore: registered new interface driver cdc_ncm
[   28.762393] Fusion MPT base driver 3.04.20
[   28.763272] Copyright (c) 1999-2008 LSI Corporation
[   28.764257] Fusion MPT SPI Host driver 3.04.20
[   28.765317] Fusion MPT FC Host driver 3.04.20
[   28.766340] Fusion MPT SAS Host driver 3.04.20
[   28.767370] Fusion MPT misc device (ioctl) driver 3.04.20
[   28.768583] mptctl: Registered with Fusion MPT base driver
[   28.769641] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[   28.771009] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   28.772179] ehci-pci: EHCI PCI platform driver
[   28.773222] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   28.774350] ohci-pci: OHCI PCI platform driver
[   28.775394] uhci_hcd: USB Universal Host Controller Interface driver
[   28.776767] usbcore: registered new interface driver usb-storage
[   28.777974] usbcore: registered new interface driver ums-alauda
[   28.779197] usbcore: registered new interface driver ums-datafab
[   28.780409] usbcore: registered new interface driver ums-freecom
[   28.781612] usbcore: registered new interface driver ums-isd200
[   28.782803] usbcore: registered new interface driver ums-jumpshot
[   28.784015] usbcore: registered new interface driver ums-sddr09
[   28.785227] usbcore: registered new interface driver ums-sddr55
[   28.786437] usbcore: registered new interface driver ums-usbat
[   28.787640] usbcore: registered new interface driver usbtest
[   28.788958] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   28.791394] serio: i8042 KBD port at 0x60,0x64 irq 1
[   28.792396] serio: i8042 AUX port at 0x60,0x64 irq 12
[   28.793656] mousedev: PS/2 mouse device common for all mice
[   28.795287] rtc_cmos 00:00: RTC can wake from S4
[   28.796616] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   28.798361] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[   28.799550] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[   28.800913] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[   28.802383] i6300esb: initialized (0xffffc90000718000). heartbeat=3D30 s=
ec (nowayout=3D0)
[   28.804127] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[   28.805318] iTCO_vendor_support: vendor-support=3D0
[   28.806303] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[   28.807980] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[   28.809822] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D0)
[   28.811799] md: linear personality registered for level -1
[   28.812825] md: raid0 personality registered for level 0
[   28.813804] md: raid1 personality registered for level 1
[   28.814819] md: raid10 personality registered for level 10
[   28.816072] md: raid6 personality registered for level 6
[   28.817135] md: raid5 personality registered for level 5
[   28.818147] md: raid4 personality registered for level 4
[   28.819136] md: multipath personality registered for level -4
[   28.820163] md: faulty personality registered for level -5
[   28.821989] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised:=
 dm-devel@redhat.com
[   28.824247] device-mapper: multipath: version 1.6.0 loaded
[   28.825322] device-mapper: multipath round-robin: version 1.0.0 loaded
[   28.826474] device-mapper: cache-policy-mq: version 1.1.0 loaded
[   28.827523] device-mapper: cache cleaner: version 1.0.0 loaded
[   28.828896] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[   28.833047] usbcore: registered new interface driver usbhid
[   28.834072] usbhid: USB HID core driver
[   28.835124] TCP: bic registered
[   28.835869] Initializing XFRM netlink socket
[   28.837084] NET: Registered protocol family 10
[   28.838213] sit: IPv6 over IPv4 tunneling driver
[   28.839453] NET: Registered protocol family 17
[   28.840405] 8021q: 802.1Q VLAN Support v1.8
[   28.841603] sctp: Hash tables configured (established 65536 bind 65536)
[   28.842988] Key type dns_resolver registered
[   28.844905]=20
[   28.844905] printing PIC contents
[   28.846196] ... PIC  IMR: ffff
[   28.846955] ... PIC  IRR: 9113
[   28.847698] ... PIC  ISR: 0000
[   28.853987] ... PIC ELCR: 0c00
[   28.854752] printing local APIC contents on CPU#0/0:
[   28.855777] ... APIC ID:      00000000 (0)
[   28.856702] ... APIC VERSION: 00050014
[   28.857624] ... APIC TASKPRI: 00000000 (00)
[   28.858565] ... APIC PROCPRI: 00000000
[   28.859442] ... APIC LDR: 01000000
[   28.860296] ... APIC DFR: ffffffff
[   28.861149] ... APIC SPIV: 000001ff
[   28.861987] ... APIC ISR field:
[   28.862777] 000000000000000000000000000000000000000000000000000000000000=
0000
[   28.864668] ... APIC TMR field:
[   28.865496] 000000000200000000000000000000000000000000000000000000000000=
0000
[   28.867361] ... APIC IRR field:
[   28.868182] 000000000000000000000000000000000000000000000000000000000000=
8000
[   28.870077] ... APIC ESR: 00000000
[   28.870911] ... APIC ICR: 000008fd
[   28.871725] ... APIC ICR2: 04000000
[   28.872587] ... APIC LVTT: 000000ef
[   28.873435] ... APIC LVTPC: 00010000
[   28.874298] ... APIC LVT0: 00010700
[   28.875150] ... APIC LVT1: 00000400
[   28.875984] ... APIC LVTERR: 000000fe
[   28.876844] ... APIC TMICT: 0003cd6c
[   28.877698] ... APIC TMCCT: 00000000
[   28.878571] ... APIC TDCR: 00000003
[   28.879403]=20
[   28.880032] number of MP IRQ sources: 15.
[   28.880874] number of IO-APIC #0 registers: 24.
[   28.881735] testing the IO APIC.......................
[   28.882669] IO APIC #0......
[   28.883358] .... register #00: 00000000
[   28.884147] .......    : physical APIC id: 00
[   28.885011] .......    : Delivery Type: 0
[   28.885874] .......    : LTS          : 0
[   28.886680] .... register #01: 00170011
[   28.887471] .......     : max redirection entries: 17
[   28.888398] .......     : PRQ implemented: 0
[   28.889238] .......     : IO APIC version: 11
[   28.890084] .... register #02: 00000000
[   28.890876] .......     : arbitration: 00
[   28.891678] .... IRQ redirection table:
[   28.892489] 1    0    0   0   0    0    0    00
[   28.893359] 0    0    0   0   0    1    1    31
[   28.894226] 0    0    0   0   0    1    1    30
[   28.895097] 0    0    0   0   0    1    1    33
[   28.895973] 1    0    0   0   0    1    1    34
[   28.896850] 1    1    0   0   0    1    1    35
[   28.897729] 0    0    0   0   0    1    1    36
[   28.898600] 0    0    0   0   0    1    1    37
[   28.899469] 0    0    0   0   0    1    1    38
[   28.900350] 0    1    0   0   0    1    1    39
[   28.901229] 1    1    0   0   0    1    1    3A
[   28.902102] 1    1    0   0   0    1    1    3B
[   28.902976] 0    0    0   0   0    1    1    3C
[   28.903846] 0    0    0   0   0    1    1    3D
[   28.904732] 0    0    0   0   0    1    1    3E
[   28.905607] 0    0    0   0   0    1    1    3F
[   28.906485] 1    0    0   0   0    0    0    00
[   28.907357] 1    0    0   0   0    0    0    00
[   28.908228] 1    0    0   0   0    0    0    00
[   28.909116] 1    0    0   0   0    0    0    00
[   28.910000] 1    0    0   0   0    0    0    00
[   28.910877] 1    0    0   0   0    0    0    00
[   28.911746] 1    0    0   0   0    0    0    00
[   28.912660] 1    0    0   0   0    0    0    00
[   28.913521] IRQ to pin mappings:
[   28.914245] IRQ0 -> 0:2
[   28.915027] IRQ1 -> 0:1
[   28.915799] IRQ3 -> 0:3
[   28.916591] IRQ4 -> 0:4
[   28.917369] IRQ5 -> 0:5
[   28.918146] IRQ6 -> 0:6
[   28.918921] IRQ7 -> 0:7
[   28.919694] IRQ8 -> 0:8
[   28.920484] IRQ9 -> 0:9
[   28.921267] IRQ10 -> 0:10
[   28.922093] IRQ11 -> 0:11
[   28.922893] IRQ12 -> 0:12
[   28.923681] IRQ13 -> 0:13
[   28.924487] IRQ14 -> 0:14
[   28.925288] IRQ15 -> 0:15
[   28.926086] .................................... done.
[   28.927677] registered taskstats version 1
[   28.930155] rtc_cmos 00:00: setting system clock to 2014-02-05 11:56:00 =
UTC (1391601360)
[   28.931751] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[   28.936989] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   28.938032] 8021q: adding VLAN 0 to HW filter on device eth0
[   29.136313] tsc: Refined TSC clocksource calibration: 2693.409 MHz
[   29.427095] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[   30.940777] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Contr=
ol: RX
[   30.944344] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   30.960279] Sending DHCP requests ., OK
[   31.024294] IP-Config: Got DHCP answer from 10.0.2.2, my address is 10.0=
=2E2.15
[   31.025747] IP-Config: Complete:
[   31.026526]      device=3Deth0, hwaddr=3D52:54:00:12:34:56, ipaddr=3D10.=
0.2.15, mask=3D255.255.255.0, gw=3D10.0.2.2
[   31.028403]      host=3Dvpx-4, domain=3D, nis-domain=3D(none)
[   31.029421]      bootserver=3D10.0.2.2, rootserver=3D10.0.2.2, rootpath=
=3D
[   31.030193]      nameserver0=3D10.0.2.3
[   31.031553] PM: Hibernation image not present or could not be loaded.
[   31.034160] Freeing unused kernel memory: 1424K (ffffffff82337000 - ffff=
ffff8249b000)
[   31.035834] Write protecting the kernel read-only data: 18432k
[   31.041568] Freeing unused kernel memory: 1964K (ffff880001a15000 - ffff=
880001c00000)
[   31.047300] Freeing unused kernel memory: 2000K (ffff88000200c000 - ffff=
880002200000)
[   31.270212] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[   31.271677] platform microcode: Direct firmware load failed with error -2
[   31.273019] platform microcode: Falling back to user helper
[   31.330076] microcode: CPU1 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[   31.331185] platform microcode: Direct firmware load failed with error -2
[   31.332858] platform microcode: Falling back to user helper
[   31.337073] microcode: CPU2 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[   31.338488] platform microcode: Direct firmware load failed with error -2
[   31.340424] platform microcode: Falling back to user helper
[   31.344519] microcode: CPU3 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[   31.345563] platform microcode: Direct firmware load failed with error -2
[   31.346780] platform microcode: Falling back to user helper
[   31.351063] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[   31.646367] random: vgscan urandom read with 20 bits of entropy available

=3D=3D> /lkp/lkp/src/tmp/run_log <=3D=3D
Kernel tests: Boot OK!
PATH=3D/sbin:/usr/sbin:/bin:/usr/bin

=3D=3D> /lkp/lkp/src/tmp/err_log <=3D=3D

=3D=3D> /lkp/lkp/src/tmp/run_log <=3D=3D
downloading latest lkp src code
Kernel tests: Boot OK 2!
/lkp/lkp/src/bin/run-lkp
LKP_SRC_DIR=3D/lkp/lkp/src
RESULT_ROOT=3D/lkp/result/vpx/micro/ltp/syscalls/x86_64-lkp/8cb75e0c4ec9786=
b81439761eac1d18d4a931af3/0
job=3D/lkp/scheduled/vpx-4/bisect_ltp-syscalls-x86_64-lkp-8cb75e0c4ec9786b8=
1439761eac1d18d4a931af3-0.yaml
run-job /lkp/scheduled/vpx-4/bisect_ltp-syscalls-x86_64-lkp-8cb75e0c4ec9786=
b81439761eac1d18d4a931af3-0.yaml
run: pre-test
run: /lkp/lkp/src/monitors/event/wait pre-test
run: /lkp/lkp/src/monitors/wrapper uptime
run: /lkp/lkp/src/monitors/wrapper iostat
run: /lkp/lkp/src/monitors/wrapper vmstat
run: /lkp/lkp/src/monitors/wrapper numa-numastat
run: /lkp/lkp/src/monitors/wrapper numa-vmstat
run: /lkp/lkp/src/monitors/wrapper numa-meminfo
run: /lkp/lkp/src/monitors/wrapper proc-vmstat
run: /lkp/lkp/src/monitors/wrapper meminfo
run: /lkp/lkp/src/monitors/wrapper slabinfo
run: /lkp/lkp/src/monitors/wrapper interrupts
run: /lkp/lkp/src/monitors/wrapper lock_stat
run: /lkp/lkp/src/monitors/wrapper softirqs
run: /lkp/lkp/src/monitors/wrapper bdi_dev_mapping
run: /lkp/lkp/src/monitors/wrapper pmeter
run: /lkp/lkp/src/monitors/wrapper diskstats
run: /lkp/lkp/src/monitors/wrapper zoneinfo
run: /lkp/lkp/src/monitors/wrapper energy
run: /usr/bin/time -v -o /lkp/lkp/src/tmp/time /lkp/lkp/src/tests/micro/wra=
pper ltp
[   79.004564] warning: `capget01' uses 32-bit capabilities (legacy support=
 in use)
[  145.168663] random: nonblocking pool is initialized
[  381.524813] Bits 55-60 of /proc/PID/pagemap entries are about to stop be=
ing page-shift some time soon. See the linux/Documentation/vm/pagemap.txt f=
or details.
[  498.341146] XFS (loop0): Mounting Filesystem
[  498.344905] XFS (loop0): Ending clean mount
[  498.345943] XFS (loop0): Quotacheck needed: Please wait.
[  498.347264] XFS (loop0): Quotacheck: Done.
[  608.380273] INFO: rcu_sched self-detected stall on CPU { 0}  (t=3D15000 =
jiffies g=3D5755 c=3D5754 q=3D18379)
[  608.383101] sending NMI to all CPUs:
[  608.383940] NMI backtrace for cpu 0
[  608.384786] CPU: 0 PID: 692 Comm: kswapd0 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[  608.392624] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  608.393750] task: ffff8801195f5a00 ti: ffff8800b6468000 task.ti: ffff880=
0b6468000
[  608.395395] RIP: 0010:[<ffffffff81060dd2>]  [<ffffffff81060dd2>] flat_se=
nd_IPI_mask+0x7e/0xac
[  608.397299] RSP: 0018:ffff88011fc03dd0  EFLAGS: 00010046
[  608.398342] RAX: 0000000000000c00 RBX: 0000000000000046 RCX: 00000000000=
00007
[  608.399622] RDX: ffffffff82221ca0 RSI: 0000000000000002 RDI: 00000000000=
00300
[  608.400863] RBP: ffff88011fc03df0 R08: 0000000000000000 R09: 00000000000=
00000
[  608.402152] R10: 000000000000c120 R11: 0000000000000000 R12: 00000000000=
00002
[  608.403398] R13: 0000000000000c00 R14: 000000000000000f R15: 00000000000=
00000
[  608.404650] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:=
0000000000000000
[  608.406431] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  608.407528] CR2: 00000000006e5dc8 CR3: 000000000220c000 CR4: 00000000000=
006f0
[  608.408821] Stack:
[  608.409485]  0000000000002710 ffff88011fc0d800 0000000000000000 ffffffff=
8224da00
[  608.411472]  ffff88011fc03e00 ffffffff81061079 ffff88011fc03e18 ffffffff=
8105e2b1
[  608.413416]  ffffffff8224da00 ffff88011fc03e70 ffffffff81111e9b ffff8801=
1fc13040
[  608.415381] Call Trace:
[  608.416100]  <IRQ>=20
[  608.416398]  [<ffffffff81061079>] flat_send_IPI_all+0x1f/0x4a
[  608.418058]  [<ffffffff8105e2b1>] arch_trigger_all_cpu_backtrace+0x52/0x=
84
[  608.419311]  [<ffffffff81111e9b>] rcu_check_callbacks+0x205/0x57f
[  608.420480]  [<ffffffff8111b057>] ? tick_sched_do_timer+0x2f/0x2f
[  608.421628]  [<ffffffff810d044e>] update_process_times+0x3d/0x65
[  608.422779]  [<ffffffff8111af6c>] tick_sched_handle+0x37/0x43
[  608.423872]  [<ffffffff8111b091>] tick_sched_timer+0x3a/0x58
[  608.424958]  [<ffffffff810e3ac7>] __run_hrtimer+0x96/0x19a
[  608.426059]  [<ffffffff810e42ff>] hrtimer_interrupt+0xe8/0x1e3
[  608.427167]  [<ffffffff8105cbf1>] local_apic_timer_interrupt+0x54/0x57
[  608.428390]  [<ffffffff81a0f123>] smp_apic_timer_interrupt+0x3f/0x50
[  608.429561]  [<ffffffff81a0de32>] apic_timer_interrupt+0x72/0x80
[  608.430686]  <EOI>=20
[  608.430977]  [<ffffffff814f2f9a>] ? find_last_bit+0x4a/0x4a
[  608.432785]  [<ffffffff8116d25f>] ? zone_watermark_ok_safe+0x61/0xad
[  608.433954]  [<ffffffff81177dac>] zone_balanced+0x1e/0x43
[  608.435042]  [<ffffffff8117b461>] balance_pgdat+0x3b6/0x501
[  608.436132]  [<ffffffff8117b8eb>] kswapd+0x33f/0x3c7
[  608.437169]  [<ffffffff810fb058>] ? __wake_up_sync+0x12/0x12
[  608.438272]  [<ffffffff8117b5ac>] ? balance_pgdat+0x501/0x501
[  608.439367]  [<ffffffff810e155c>] kthread+0xdb/0xe3
[  608.440394]  [<ffffffff810e1481>] ? kthread_create_on_node+0x16f/0x16f
[  608.441586]  [<ffffffff81a0d1bc>] ret_from_fork+0x7c/0xb0
[  608.442637]  [<ffffffff810e1481>] ? kthread_create_on_node+0x16f/0x16f
[  608.443852] Code: eb f0 44 89 f0 c1 e0 18 89 04 25 10 33 5f ff 44 89 e0 =
44 09 e8 41 81 cd 00 04 00 00 41 83 fc 02 41 0f 44 c5 89 04 25 00 33 5f ff =
<f6> c7 02 75 11 48 89 df 57 9d 0f 1f 44 00 00 e8 6e 94 0e 00 eb=20
[  608.452167] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 68.222 msecs
[  608.452169] NMI backtrace for cpu 1
[  608.452172] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[  608.452173] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  608.452174] task: ffff880119b25100 ti: ffff880119b40000 task.ti: ffff880=
119b40000
[  608.452179] RIP: 0010:[<ffffffff81065bfa>]  [<ffffffff81065bfa>] native_=
safe_halt+0x6/0x8
[  608.452180] RSP: 0018:ffff880119b41eb8  EFLAGS: 00000246
[  608.452183] RAX: 0000000000000000 RBX: ffff880119b41fd8 RCX: 00000000fff=
fffff
[  608.452184] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[  608.452184] RBP: ffff880119b41eb8 R08: 0000000000000000 R09: 00000000000=
00000
[  608.452185] R10: 0000000000000001 R11: 0000000000000400 R12: 00000000000=
00001
[  608.452186] R13: ffff880119b41fd8 R14: ffff880119b41fd8 R15: 00000000000=
00000
[  608.452187] FS:  0000000000000000(0000) GS:ffff88011fc80000(0000) knlGS:=
0000000000000000
[  608.452187] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  608.452188] CR2: 0000000000e21364 CR3: 000000007edf0000 CR4: 00000000000=
006e0
[  608.452194] Stack:
[  608.452195]  ffff880119b41ed8 ffffffff8103f69e ffff880119b41fd8 ffff8801=
19b41fd8
[  608.452196]  ffff880119b41ee8 ffffffff8103fdca ffff880119b41f30 ffffffff=
8110923e
[  608.452197]  ffffffff81118fa2 e173ef88b221c3f9 0000000000000000 00000000=
00000000
[  608.452198] Call Trace:
[  608.452203]  [<ffffffff8103f69e>] default_idle+0x38/0xc1
[  608.452205]  [<ffffffff8103fdca>] arch_cpu_idle+0x18/0x28
[  608.452207]  [<ffffffff8110923e>] cpu_startup_entry+0x178/0x245
[  608.452208]  [<ffffffff81118fa2>] ? clockevents_register_device+0x112/0x=
117
[  608.452210]  [<ffffffff8105b391>] start_secondary+0x277/0x279
[  608.452220] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[  608.452224] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 68.259 msecs
[  608.452226] NMI backtrace for cpu 3
[  608.452228] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[  608.452229] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  608.452230] task: ffff880119b26300 ti: ffff880119b48000 task.ti: ffff880=
119b48000
[  608.452234] RIP: 0010:[<ffffffff81065bfa>]  [<ffffffff81065bfa>] native_=
safe_halt+0x6/0x8
[  608.452234] RSP: 0018:ffff880119b49eb8  EFLAGS: 00000246
[  608.452235] RAX: 0000000000000000 RBX: ffff880119b49fd8 RCX: 00000000fff=
fffff
[  608.452237] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[  608.452238] RBP: ffff880119b49eb8 R08: 0000000000000000 R09: 00000000000=
00000
[  608.452239] R10: 0000000000000003 R11: 0000000000000400 R12: 00000000000=
00003
[  608.452240] R13: ffff880119b49fd8 R14: ffff880119b49fd8 R15: 00000000000=
00000
[  608.452241] INFO: rcu_sched detected stalls on CPUs/tasks: { 0} (detecte=
d by 1, t=3D15017 jiffies, g=3D5755, c=3D5754, q=3D18379)
[  608.452242] FS:  0000000000000000(0000) GS:ffff88011fd80000(0000) knlGS:=
0000000000000000
[  608.452243] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  608.452243] CR2: 00007f0f536b7be0 CR3: 00000000b602f000 CR4: 00000000000=
006e0
[  608.452248] Stack:
[  608.452250]  ffff880119b49ed8 ffffffff8103f69e ffff880119b49fd8 ffff8801=
19b49fd8
[  608.452251]  ffff880119b49ee8 ffffffff8103fdca ffff880119b49f30 ffffffff=
8110923e
[  608.452252]  ffffffff81118fa2 b56143bc50374013 0000000000000000 00000000=
00000000
[  608.452252] Call Trace:
[  608.452255]  [<ffffffff8103f69e>] default_idle+0x38/0xc1
[  608.452256]  [<ffffffff8103fdca>] arch_cpu_idle+0x18/0x28
[  608.452258]  [<ffffffff8110923e>] cpu_startup_entry+0x178/0x245
[  608.452259]  [<ffffffff81118fa2>] ? clockevents_register_device+0x112/0x=
117
[  608.452261]  [<ffffffff8105b391>] start_secondary+0x277/0x279
[  608.452271] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[  608.452274] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 68.309 msecs
[  608.452276] NMI backtrace for cpu 2
[  608.452278] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[  608.452279] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  608.452282] task: ffff880119b25a00 ti: ffff880119b42000 task.ti: ffff880=
119b42000
[  608.452286] RIP: 0010:[<ffffffff81065bfa>]  [<ffffffff81065bfa>] native_=
safe_halt+0x6/0x8
[  608.452286] RSP: 0018:ffff880119b43eb8  EFLAGS: 00000246
[  608.452287] RAX: 0000000000000000 RBX: ffff880119b43fd8 RCX: 00000000fff=
fffff
[  608.452288] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[  608.452289] RBP: ffff880119b43eb8 R08: 0000000000000000 R09: 00000000000=
00000
[  608.452289] R10: 0000000000000002 R11: 0000000000000400 R12: 00000000000=
00002
[  608.452290] R13: ffff880119b43fd8 R14: ffff880119b43fd8 R15: 00000000000=
00000
[  608.452291] FS:  0000000000000000(0000) GS:ffff88011fd00000(0000) knlGS:=
0000000000000000
[  608.452292] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  608.452292] CR2: 00007fa74713d48f CR3: 000000000220c000 CR4: 00000000000=
006e0
[  608.452297] Stack:
[  608.452299]  ffff880119b43ed8 ffffffff8103f69e ffff880119b43fd8 ffff8801=
19b43fd8
[  608.452300]  ffff880119b43ee8 ffffffff8103fdca ffff880119b43f30 ffffffff=
8110923e
[  608.452301]  ffffffff81118fa2 3f66056c4b53d441 0000000000000000 00000000=
00000000
[  608.452301] Call Trace:
[  608.452303]  [<ffffffff8103f69e>] default_idle+0x38/0xc1
[  608.452305]  [<ffffffff8103fdca>] arch_cpu_idle+0x18/0x28
[  608.452306]  [<ffffffff8110923e>] cpu_startup_entry+0x178/0x245
[  608.452308]  [<ffffffff81118fa2>] ? clockevents_register_device+0x112/0x=
117
[  608.452309]  [<ffffffff8105b391>] start_secondary+0x277/0x279
[  608.452319] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[  608.452322] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 68.356 msecs
[  751.084261] INFO: rcu_sched self-detected stall on CPU { 2}  (t=3D15000 =
jiffies g=3D6882 c=3D6881 q=3D422116)
[  751.086013] sending NMI to all CPUs:
[  751.086754] NMI backtrace for cpu 2
[  751.087494] CPU: 2 PID: 692 Comm: kswapd0 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[  751.089006] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  751.089986] task: ffff8801195f5a00 ti: ffff8800b6468000 task.ti: ffff880=
0b6468000
[  751.091500] RIP: 0010:[<ffffffff81060dd2>]  [<ffffffff81060dd2>] flat_se=
nd_IPI_mask+0x7e/0xac
[  751.093094] RSP: 0018:ffff88011fd03dd0  EFLAGS: 00010046
[  751.093990] RAX: 0000000000000c00 RBX: 0000000000000046 RCX: 00000000000=
00007
[  751.095091] RDX: ffffffff82221ca0 RSI: 0000000000000002 RDI: 00000000000=
00300
[  751.096220] RBP: ffff88011fd03df0 R08: 0000000000000000 R09: 00000000000=
00000
[  751.097351] R10: 0000000000002b20 R11: 0000000000000000 R12: 00000000000=
00002
[  751.104076] R13: 0000000000000c00 R14: 000000000000000f R15: 00000000000=
00002
[  751.105205] FS:  0000000000000000(0000) GS:ffff88011fd00000(0000) knlGS:=
0000000000000000
[  751.106779] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  751.107761] CR2: 00000000006e5dc8 CR3: 000000000220c000 CR4: 00000000000=
006e0
[  751.108895] Stack:
[  751.109471]  0000000000002710 ffff88011fd0d800 0000000000000000 ffffffff=
8224da00
[  751.111060]  ffff88011fd03e00 ffffffff81061079 ffff88011fd03e18 ffffffff=
8105e2b1
[  751.112645]  ffffffff8224da00 ffff88011fd03e70 ffffffff81111e9b ffff8801=
1fd13040
[  751.114220] Call Trace:
[  751.114835]  <IRQ>=20
[  751.115063]  [<ffffffff81061079>] flat_send_IPI_all+0x1f/0x4a
[  751.116434]  [<ffffffff8105e2b1>] arch_trigger_all_cpu_backtrace+0x52/0x=
84
[  751.117506]  [<ffffffff81111e9b>] rcu_check_callbacks+0x205/0x57f
[  751.118520]  [<ffffffff8111b057>] ? tick_sched_do_timer+0x2f/0x2f
[  751.119550]  [<ffffffff810d044e>] update_process_times+0x3d/0x65
[  751.120560]  [<ffffffff8111af6c>] tick_sched_handle+0x37/0x43
[  751.121542]  [<ffffffff8111b091>] tick_sched_timer+0x3a/0x58
[  751.122515]  [<ffffffff810e3ac7>] __run_hrtimer+0x96/0x19a
[  751.123471]  [<ffffffff810e42ff>] hrtimer_interrupt+0xe8/0x1e3
[  751.124460]  [<ffffffff8105cbf1>] local_apic_timer_interrupt+0x54/0x57
[  751.125527]  [<ffffffff81a0f123>] smp_apic_timer_interrupt+0x3f/0x50
[  751.126577]  [<ffffffff81a0de32>] apic_timer_interrupt+0x72/0x80
[  751.127664]  <EOI>=20
[  751.127891]  [<ffffffff81a05afd>] ? _raw_spin_lock+0x1a/0x34
[  751.129274]  [<ffffffff81187c63>] list_lru_count_node+0x1c/0x57
[  751.130274]  [<ffffffff811c706a>] super_cache_count+0x77/0xba
[  751.131257]  [<ffffffff811780f4>] shrink_slab+0xfc/0x326
[  751.132198]  [<ffffffff811ba7c6>] ? mem_cgroup_iter+0x146/0x265
[  751.133200]  [<ffffffff811bfde0>] ? vmpressure+0x21/0x76
[  751.134139]  [<ffffffff8117b420>] balance_pgdat+0x375/0x501
[  751.135096]  [<ffffffff8117b8eb>] kswapd+0x33f/0x3c7
[  751.135994]  [<ffffffff810fb058>] ? __wake_up_sync+0x12/0x12
[  751.136970]  [<ffffffff8117b5ac>] ? balance_pgdat+0x501/0x501
[  751.137959]  [<ffffffff810e155c>] kthread+0xdb/0xe3
[  751.138851]  [<ffffffff810e1481>] ? kthread_create_on_node+0x16f/0x16f
[  751.139920]  [<ffffffff81a0d1bc>] ret_from_fork+0x7c/0xb0
[  751.140866]  [<ffffffff810e1481>] ? kthread_create_on_node+0x16f/0x16f
[  751.141934] Code: eb f0 44 89 f0 c1 e0 18 89 04 25 10 33 5f ff 44 89 e0 =
44 09 e8 41 81 cd 00 04 00 00 41 83 fc 02 41 0f 44 c5 89 04 25 00 33 5f ff =
<f6> c7 02 75 11 48 89 df 57 9d 0f 1f 44 00 00 e8 6e 94 0e 00 eb=20
[  751.146363] NMI backtrace for cpu 0
[  751.147248] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[  751.148870] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  751.149986] task: ffffffff82211440 ti: ffffffff82200000 task.ti: fffffff=
f82200000
[  751.151641] RIP: 0010:[<ffffffff81065bfa>]  [<ffffffff81065bfa>] native_=
safe_halt+0x6/0x8
[  751.153372] RSP: 0018:ffffffff82201ec8  EFLAGS: 00000246
[  751.154411] RAX: 0000000000000000 RBX: ffffffff82201fd8 RCX: 00000000fff=
fffff
[  751.155635] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[  751.156885] RBP: ffffffff82201ec8 R08: 0000000000000000 R09: 00000000000=
00000
[  751.158070] R10: 0000000000000000 R11: 0000000000000400 R12: 00000000000=
00000
[  751.159264] R13: ffffffff82201fd8 R14: ffffffff82201fd8 R15: 00000000fff=
fffff
[  751.160498] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:=
0000000000000000
[  751.162180] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  751.163231] CR2: 00007f06286b548f CR3: 000000000220c000 CR4: 00000000000=
006f0
[  751.164433] Stack:
[  751.165029]  ffffffff82201ee8 ffffffff8103f69e ffffffff82201fd8 ffffffff=
82201fd8
[  751.166676]  ffffffff82201ef8 ffffffff8103fdca ffffffff82201f40 ffffffff=
8110923e
[  751.168358]  ffff88011ffa3ec0 66c407fa264c5145 ffffffffffffffff ffffffff=
823ee8d0
[  751.170032] Call Trace:
[  751.170704]  [<ffffffff8103f69e>] default_idle+0x38/0xc1
[  751.171726]  [<ffffffff8103fdca>] arch_cpu_idle+0x18/0x28
[  751.172755]  [<ffffffff8110923e>] cpu_startup_entry+0x178/0x245
[  751.173854]  [<ffffffff819f01a3>] rest_init+0x87/0x89
[  751.174857]  [<ffffffff8234be04>] start_kernel+0x435/0x440
[  751.175914]  [<ffffffff8234b7dd>] ? repair_env_string+0x58/0x58
[  751.177045]  [<ffffffff8234b120>] ? early_idt_handlers+0x120/0x120
[  751.178154]  [<ffffffff8234b498>] x86_64_start_reservations+0x2a/0x2c
[  751.179349]  [<ffffffff8234b5d5>] x86_64_start_kernel+0x13b/0x148
[  751.180440] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[  751.185220] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 98.471 msecs
[  751.185221] NMI backtrace for cpu 1
[  751.185225] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[  751.185225] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  751.185227] task: ffff880119b25100 ti: ffff880119b40000 task.ti: ffff880=
119b40000
[  751.185231] RIP: 0010:[<ffffffff81065bfa>]  [<ffffffff81065bfa>] native_=
safe_halt+0x6/0x8
[  751.185232] RSP: 0018:ffff880119b41eb8  EFLAGS: 00000246
[  751.185236] RAX: 0000000000000000 RBX: ffff880119b41fd8 RCX: 00000000fff=
fffff
[  751.185237] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[  751.185238] RBP: ffff880119b41eb8 R08: 0000000000000000 R09: 00000000000=
00000
[  751.185238] R10: 0000000000000001 R11: 0000000000000400 R12: 00000000000=
00001
[  751.185239] R13: ffff880119b41fd8 R14: ffff880119b41fd8 R15: 00000000000=
00000
[  751.185240] FS:  0000000000000000(0000) GS:ffff88011fc80000(0000) knlGS:=
0000000000000000
[  751.185241] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  751.185241] CR2: 00007f58e05b7000 CR3: 000000007f133000 CR4: 00000000000=
006e0
[  751.185247] Stack:
[  751.185249]  ffff880119b41ed8 ffffffff8103f69e ffff880119b41fd8 ffff8801=
19b41fd8
[  751.185250]  ffff880119b41ee8 ffffffff8103fdca ffff880119b41f30 ffffffff=
8110923e
[  751.185251]  ffffffff81118fa2 e173ef88b221c3f9 0000000000000000 00000000=
00000000
[  751.185251] Call Trace:
[  751.185254]  [<ffffffff8103f69e>] default_idle+0x38/0xc1
[  751.185255]  [<ffffffff8103fdca>] arch_cpu_idle+0x18/0x28
[  751.185257]  [<ffffffff8110923e>] cpu_startup_entry+0x178/0x245
[  751.185259]  [<ffffffff81118fa2>] ? clockevents_register_device+0x112/0x=
117
[  751.185261]  [<ffffffff8105b391>] start_secondary+0x277/0x279
[  751.185271] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[  751.185274] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 98.497 msecs
[  751.185276] NMI backtrace for cpu 3
[  751.185278] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[  751.185278] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  751.185280] task: ffff880119b26300 ti: ffff880119b48000 task.ti: ffff880=
119b48000
[  751.185283] RIP: 0010:[<ffffffff81065bfa>]  [<ffffffff81065bfa>] native_=
safe_halt+0x6/0x8
[  751.185284] RSP: 0018:ffff880119b49eb8  EFLAGS: 00000246
[  751.185284] RAX: 0000000000000000 RBX: ffff880119b49fd8 RCX: 00000000fff=
fffff
[  751.185285] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[  751.185286] RBP: ffff880119b49eb8 R08: 0000000000000000 R09: 00000000000=
00000
[  751.185286] R10: 0000000000000003 R11: 0000000000000400 R12: 00000000000=
00003
[  751.185287] R13: ffff880119b49fd8 R14: ffff880119b49fd8 R15: 00000000000=
00000
[  751.185288] FS:  0000000000000000(0000) GS:ffff88011fd80000(0000) knlGS:=
0000000000000000
[  751.185289] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  751.185289] CR2: 00000000008b1364 CR3: 000000007cc07000 CR4: 00000000000=
006e0
[  751.185293] INFO: rcu_sched detected stalls on CPUs/tasks: { 2} (detecte=
d by 1, t=3D15025 jiffies, g=3D6882, c=3D6881, q=3D422116)
[  751.185295] Stack:
[  751.185296]  ffff880119b49ed8 ffffffff8103f69e ffff880119b49fd8 ffff8801=
19b49fd8
[  751.185297]  ffff880119b49ee8 ffffffff8103fdca ffff880119b49f30 ffffffff=
8110923e
[  751.185298]  ffffffff81118fa2 b56143bc50374013 0000000000000000 00000000=
00000000
[  751.185299] Call Trace:
[  751.185301]  [<ffffffff8103f69e>] default_idle+0x38/0xc1
[  751.185302]  [<ffffffff8103fdca>] arch_cpu_idle+0x18/0x28
[  751.185304]  [<ffffffff8110923e>] cpu_startup_entry+0x178/0x245
[  751.185305]  [<ffffffff81118fa2>] ? clockevents_register_device+0x112/0x=
117
[  751.185307]  [<ffffffff8105b391>] start_secondary+0x277/0x279
[  751.185317] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[  751.185319] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 98.542 msecs
[  931.196260] INFO: rcu_sched self-detected stall on CPU { 2}  (t=3D60028 =
jiffies g=3D6882 c=3D6881 q=3D474843)
[  931.197886] sending NMI to all CPUs:
[  931.198562] NMI backtrace for cpu 2
[  931.199289] CPU: 2 PID: 692 Comm: kswapd0 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[  931.200771] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  931.201783] task: ffff8801195f5a00 ti: ffff8800b6468000 task.ti: ffff880=
0b6468000
[  931.203373] RIP: 0010:[<ffffffff81060dd2>]  [<ffffffff81060dd2>] flat_se=
nd_IPI_mask+0x7e/0xac
[  931.204977] RSP: 0018:ffff88011fd03dd0  EFLAGS: 00010046
[  931.205880] RAX: 0000000000000c00 RBX: 0000000000000046 RCX: 00000000000=
00007
[  931.206981] RDX: ffffffff82221ca0 RSI: 0000000000000002 RDI: 00000000000=
00300
[  931.208074] RBP: ffff88011fd03df0 R08: 0000000000000000 R09: 00000000000=
00000
[  931.209179] R10: 00000000000097e0 R11: 0000000000000000 R12: 00000000000=
00002
[  931.210277] R13: 0000000000000c00 R14: 000000000000000f R15: 00000000000=
00002
[  931.211373] FS:  0000000000000000(0000) GS:ffff88011fd00000(0000) knlGS:=
0000000000000000
[  931.212905] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  931.213853] CR2: 00000000006e5dc8 CR3: 000000000220c000 CR4: 00000000000=
006e0
[  931.214956] Stack:
[  931.220894]  0000000000002710 ffff88011fd0d800 0000000000000000 ffffffff=
8224da00
[  931.222432]  ffff88011fd03e00 ffffffff81061079 ffff88011fd03e18 ffffffff=
8105e2b1
[  931.223985]  ffffffff8224da00 ffff88011fd03e70 ffffffff81111e9b ffff8801=
1fd13040
[  931.225518] Call Trace:
[  931.226114]  <IRQ>=20
[  931.226333]  [<ffffffff81061079>] flat_send_IPI_all+0x1f/0x4a
[  931.227669]  [<ffffffff8105e2b1>] arch_trigger_all_cpu_backtrace+0x52/0x=
84
[  931.228850]  [<ffffffff81111e9b>] rcu_check_callbacks+0x205/0x57f
[  931.229917]  [<ffffffff8111b057>] ? tick_sched_do_timer+0x2f/0x2f
[  931.230990]  [<ffffffff810d044e>] update_process_times+0x3d/0x65
[  931.231967]  [<ffffffff8111af6c>] tick_sched_handle+0x37/0x43
[  931.232920]  [<ffffffff8111b091>] tick_sched_timer+0x3a/0x58
[  931.233861]  [<ffffffff810e3ac7>] __run_hrtimer+0x96/0x19a
[  931.234785]  [<ffffffff810e42ff>] hrtimer_interrupt+0xe8/0x1e3
[  931.235748]  [<ffffffff8105cbf1>] local_apic_timer_interrupt+0x54/0x57
[  931.236780]  [<ffffffff81a0f123>] smp_apic_timer_interrupt+0x3f/0x50
[  931.237798]  [<ffffffff81a0de32>] apic_timer_interrupt+0x72/0x80
[  931.238778]  <EOI>=20
[  931.239000]  [<ffffffff81a05afd>] ? _raw_spin_lock+0x1a/0x34
[  931.240319]  [<ffffffff811bf4be>] mem_cgroup_soft_limit_reclaim+0x85/0x4=
39
[  931.241385]  [<ffffffff8117b316>] balance_pgdat+0x26b/0x501
[  931.242321]  [<ffffffff8117b8eb>] kswapd+0x33f/0x3c7
[  931.243189]  [<ffffffff810fb058>] ? __wake_up_sync+0x12/0x12
[  931.244132]  [<ffffffff8117b5ac>] ? balance_pgdat+0x501/0x501
[  931.245083]  [<ffffffff810e155c>] kthread+0xdb/0xe3
[  931.245943]  [<ffffffff810e1481>] ? kthread_create_on_node+0x16f/0x16f
[  931.246978]  [<ffffffff81a0d1bc>] ret_from_fork+0x7c/0xb0
[  931.247895]  [<ffffffff810e1481>] ? kthread_create_on_node+0x16f/0x16f
[  931.248941] Code: eb f0 44 89 f0 c1 e0 18 89 04 25 10 33 5f ff 44 89 e0 =
44 09 e8 41 81 cd 00 04 00 00 41 83 fc 02 41 0f 44 c5 89 04 25 00 33 5f ff =
<f6> c7 02 75 11 48 89 df 57 9d 0f 1f 44 00 00 e8 6e 94 0e 00 eb=20
[  931.253452] NMI backtrace for cpu 1
[  931.254333] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[  931.255884] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  931.256892] task: ffff880119b25100 ti: ffff880119b40000 task.ti: ffff880=
119b40000
[  931.258442] RIP: 0010:[<ffffffff81065bfa>]  [<ffffffff81065bfa>] native_=
safe_halt+0x6/0x8
[  931.260097] RSP: 0018:ffff880119b41eb8  EFLAGS: 00000246
[  931.261053] RAX: 0000000000000000 RBX: ffff880119b41fd8 RCX: 00000000fff=
fffff
[  931.262211] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[  931.263370] RBP: ffff880119b41eb8 R08: 0000000000000000 R09: 00000000000=
00000
[  931.264531] R10: 0000000000000001 R11: 0000000000000400 R12: 00000000000=
00001
[  931.265685] R13: ffff880119b41fd8 R14: ffff880119b41fd8 R15: 00000000000=
00000
[  931.266846] FS:  0000000000000000(0000) GS:ffff88011fc80000(0000) knlGS:=
0000000000000000
[  931.268459] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  931.269461] CR2: 00007f05c35bebe0 CR3: 00000000ab4af000 CR4: 00000000000=
006e0
[  931.270630] Stack:
[  931.271211]  ffff880119b41ed8 ffffffff8103f69e ffff880119b41fd8 ffff8801=
19b41fd8
[  931.272870]  ffff880119b41ee8 ffffffff8103fdca ffff880119b41f30 ffffffff=
8110923e
[  931.274512]  ffffffff81118fa2 e173ef88b221c3f9 0000000000000000 00000000=
00000000
[  931.276127] Call Trace:
[  931.276768]  [<ffffffff8103f69e>] default_idle+0x38/0xc1
[  931.277742]  [<ffffffff8103fdca>] arch_cpu_idle+0x18/0x28
[  931.278709]  [<ffffffff8110923e>] cpu_startup_entry+0x178/0x245
[  931.279735]  [<ffffffff81118fa2>] ? clockevents_register_device+0x112/0x=
117
[  931.280883]  [<ffffffff8105b391>] start_secondary+0x277/0x279
[  931.281889] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[  931.286350] NMI backtrace for cpu 3
[  931.286378] INFO: rcu_sched detected stalls on CPUs/tasks: { 2} (detecte=
d by 1, t=3D60050 jiffies, g=3D6882, c=3D6881, q=3D474843)
[  931.289171] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[  931.290652] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  931.291603] task: ffff880119b26300 ti: ffff880119b48000 task.ti: ffff880=
119b48000
[  931.293075] RIP: 0010:[<ffffffff81065bfa>]  [<ffffffff81065bfa>] native_=
safe_halt+0x6/0x8
[  931.294634] RSP: 0018:ffff880119b49eb8  EFLAGS: 00000246
[  931.295548] RAX: 0000000000000000 RBX: ffff880119b49fd8 RCX: 00000000fff=
fffff
[  931.296652] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[  931.297759] RBP: ffff880119b49eb8 R08: 0000000000000000 R09: 00000000000=
00000
[  931.298863] R10: 0000000000000003 R11: 0000000000000400 R12: 00000000000=
00003
[  931.299972] R13: ffff880119b49fd8 R14: ffff880119b49fd8 R15: 00000000000=
00000
[  931.301075] FS:  0000000000000000(0000) GS:ffff88011fd80000(0000) knlGS:=
0000000000000000
[  931.302619] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  931.303575] CR2: 00000000008b1364 CR3: 000000007f7bb000 CR4: 00000000000=
006e0
[  931.304682] Stack:
[  931.305235]  ffff880119b49ed8 ffffffff8103f69e ffff880119b49fd8 ffff8801=
19b49fd8
[  931.306791]  ffff880119b49ee8 ffffffff8103fdca ffff880119b49f30 ffffffff=
8110923e
[  931.308335]  ffffffff81118fa2 b56143bc50374013 0000000000000000 00000000=
00000000
[  931.309883] Call Trace:
[  931.310490]  [<ffffffff8103f69e>] default_idle+0x38/0xc1
[  931.311402]  [<ffffffff8103fdca>] arch_cpu_idle+0x18/0x28
[  931.312332]  [<ffffffff8110923e>] cpu_startup_entry+0x178/0x245
[  931.313314]  [<ffffffff81118fa2>] ? clockevents_register_device+0x112/0x=
117
[  931.314409]  [<ffffffff8105b391>] start_secondary+0x277/0x279
[  931.315369] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[  931.319690] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 121.045 msecs
[  931.319692] NMI backtrace for cpu 0
[  931.319695] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[  931.319696] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  931.319697] task: ffffffff82211440 ti: ffffffff82200000 task.ti: fffffff=
f82200000
[  931.319710] RIP: 0010:[<ffffffff81065bfa>]  [<ffffffff81065bfa>] native_=
safe_halt+0x6/0x8
[  931.319710] RSP: 0018:ffffffff82201ec8  EFLAGS: 00000246
[  931.319711] RAX: 0000000000000000 RBX: ffffffff82201fd8 RCX: 00000000fff=
fffff
[  931.319712] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[  931.319712] RBP: ffffffff82201ec8 R08: 0000000000000000 R09: 00000000000=
00000
[  931.319713] R10: 0000000000000000 R11: 0000000000000400 R12: 00000000000=
00000
[  931.319714] R13: ffffffff82201fd8 R14: ffffffff82201fd8 R15: 00000000fff=
fffff
[  931.319719] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:=
0000000000000000
[  931.319720] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  931.319720] CR2: 00007f06286b548f CR3: 000000000220c000 CR4: 00000000000=
006f0
[  931.319726] Stack:
[  931.319727]  ffffffff82201ee8 ffffffff8103f69e ffffffff82201fd8 ffffffff=
82201fd8
[  931.319728]  ffffffff82201ef8 ffffffff8103fdca ffffffff82201f40 ffffffff=
8110923e
[  931.319729]  ffff88011ffa3ec0 66c407fa264c5145 ffffffffffffffff ffffffff=
823ee8d0
[  931.319730] Call Trace:
[  931.319732]  [<ffffffff8103f69e>] default_idle+0x38/0xc1
[  931.319734]  [<ffffffff8103fdca>] arch_cpu_idle+0x18/0x28
[  931.319735]  [<ffffffff8110923e>] cpu_startup_entry+0x178/0x245
[  931.319739]  [<ffffffff819f01a3>] rest_init+0x87/0x89
[  931.319742]  [<ffffffff8234be04>] start_kernel+0x435/0x440
[  931.319744]  [<ffffffff8234b7dd>] ? repair_env_string+0x58/0x58
[  931.319746]  [<ffffffff8234b120>] ? early_idt_handlers+0x120/0x120
[  931.319747]  [<ffffffff8234b498>] x86_64_start_reservations+0x2a/0x2c
[  931.319749]  [<ffffffff8234b5d5>] x86_64_start_kernel+0x13b/0x148
[  931.319758] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[  931.319761] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 121.118 msecs
[ 1174.420271] INFO: rcu_sched self-detected stall on CPU { 0}  (t=3D15000 =
jiffies g=3D7101 c=3D7100 q=3D4733)
[ 1174.422109] sending NMI to all CPUs:
[ 1174.422926] NMI backtrace for cpu 0
[ 1174.423731] CPU: 0 PID: 692 Comm: kswapd0 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[ 1174.425342] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1174.426363] task: ffff8801195f5a00 ti: ffff8800b6468000 task.ti: ffff880=
0b6468000
[ 1174.427905] RIP: 0010:[<ffffffff81060dd2>]  [<ffffffff81060dd2>] flat_se=
nd_IPI_mask+0x7e/0xac
[ 1174.429613] RSP: 0018:ffff88011fc03dd0  EFLAGS: 00010046
[ 1174.430652] RAX: 0000000000000c00 RBX: 0000000000000046 RCX: 00000000000=
040a7
[ 1174.431972] RDX: ffffffff82221ca0 RSI: 0000000000000002 RDI: 00000000000=
00300
[ 1174.433182] RBP: ffff88011fc03df0 R08: 0000000000000000 R09: 00000000000=
00000
[ 1174.434378] R10: 0000000000000140 R11: 0000000000000000 R12: 00000000000=
00002
[ 1174.435577] R13: 0000000000000c00 R14: 000000000000000f R15: 00000000000=
00000
[ 1174.436767] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:=
0000000000000000
[ 1174.438427] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1174.439470] CR2: 00007ffac27a6f70 CR3: 000000000220c000 CR4: 00000000000=
006f0
[ 1174.440670] Stack:
[ 1174.441275]  0000000000002710 ffff88011fc0d800 0000000000000000 ffffffff=
8224da00
[ 1174.442953]  ffff88011fc03e00 ffffffff81061079 ffff88011fc03e18 ffffffff=
8105e2b1
[ 1174.444630]  ffffffff8224da00 ffff88011fc03e70 ffffffff81111e9b ffff8801=
1fc13040
[ 1174.446295] Call Trace:
[ 1174.446960]  <IRQ>=20
[ 1174.447197]  [<ffffffff81061079>] flat_send_IPI_all+0x1f/0x4a
[ 1174.448653]  [<ffffffff8105e2b1>] arch_trigger_all_cpu_backtrace+0x52/0x=
84
[ 1174.449815]  [<ffffffff81111e9b>] rcu_check_callbacks+0x205/0x57f
[ 1174.450891]  [<ffffffff8111b057>] ? tick_sched_do_timer+0x2f/0x2f
[ 1174.458087]  [<ffffffff810d044e>] update_process_times+0x3d/0x65
[ 1174.459160]  [<ffffffff8111af6c>] tick_sched_handle+0x37/0x43
[ 1174.460204]  [<ffffffff8111b091>] tick_sched_timer+0x3a/0x58
[ 1174.461237]  [<ffffffff810e3ac7>] __run_hrtimer+0x96/0x19a
[ 1174.462248]  [<ffffffff810e42ff>] hrtimer_interrupt+0xe8/0x1e3
[ 1174.463304]  [<ffffffff8105cbf1>] local_apic_timer_interrupt+0x54/0x57
[ 1174.464440]  [<ffffffff81a0f123>] smp_apic_timer_interrupt+0x3f/0x50
[ 1174.465549]  [<ffffffff81a0de32>] apic_timer_interrupt+0x72/0x80
[ 1174.466603]  <EOI>=20
[ 1174.466834]  [<ffffffff810fd95f>] ? down_read_trylock+0x1a/0x25
[ 1174.468287]  [<ffffffff811c6fc9>] grab_super_passive+0x59/0x83
[ 1174.469310]  [<ffffffff811c701d>] super_cache_count+0x2a/0xba
[ 1174.470381]  [<ffffffff811780f4>] shrink_slab+0xfc/0x326
[ 1174.471382]  [<ffffffff811ba7c6>] ? mem_cgroup_iter+0x146/0x265
[ 1174.472405]  [<ffffffff811bfde0>] ? vmpressure+0x21/0x76
[ 1174.473356]  [<ffffffff8117b420>] balance_pgdat+0x375/0x501
[ 1174.474343]  [<ffffffff8117b8eb>] kswapd+0x33f/0x3c7
[ 1174.475257]  [<ffffffff810fb058>] ? __wake_up_sync+0x12/0x12
[ 1174.476261]  [<ffffffff8117b5ac>] ? balance_pgdat+0x501/0x501
[ 1174.477271]  [<ffffffff810e155c>] kthread+0xdb/0xe3
[ 1174.478195]  [<ffffffff810e1481>] ? kthread_create_on_node+0x16f/0x16f
[ 1174.479300]  [<ffffffff81a0d1bc>] ret_from_fork+0x7c/0xb0
[ 1174.480262]  [<ffffffff810e1481>] ? kthread_create_on_node+0x16f/0x16f
[ 1174.481395] Code: eb f0 44 89 f0 c1 e0 18 89 04 25 10 33 5f ff 44 89 e0 =
44 09 e8 41 81 cd 00 04 00 00 41 83 fc 02 41 0f 44 c5 89 04 25 00 33 5f ff =
<f6> c7 02 75 11 48 89 df 57 9d 0f 1f 44 00 00 e8 6e 94 0e 00 eb=20
[ 1174.485953] NMI backtrace for cpu 3
[ 1174.486708] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[ 1174.488196] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1174.489171] task: ffff880119b26300 ti: ffff880119b48000 task.ti: ffff880=
119b48000
[ 1174.490681] RIP: 0010:[<ffffffff81065bfa>]  [<ffffffff81065bfa>] native_=
safe_halt+0x6/0x8
[ 1174.492303] RSP: 0018:ffff880119b49eb8  EFLAGS: 00000246
[ 1174.493216] RAX: 0000000000000000 RBX: ffff880119b49fd8 RCX: 00000000fff=
fffff
[ 1174.494342] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[ 1174.495489] RBP: ffff880119b49eb8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1174.496602] R10: 0000000000000003 R11: 0000000000000400 R12: 00000000000=
00003
[ 1174.497732] R13: ffff880119b49fd8 R14: ffff880119b49fd8 R15: 00000000000=
00000
[ 1174.498848] FS:  0000000000000000(0000) GS:ffff88011fd80000(0000) knlGS:=
0000000000000000
[ 1174.500390] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1174.501346] CR2: 00007f1f8f2831a0 CR3: 000000007cc95000 CR4: 00000000000=
006e0
[ 1174.502460] Stack:
[ 1174.503023]  ffff880119b49ed8 ffffffff8103f69e ffff880119b49fd8 ffff8801=
19b49fd8
[ 1174.504573]  ffff880119b49ee8 ffffffff8103fdca ffff880119b49f30 ffffffff=
8110923e
[ 1174.506124]  ffffffff81118fa2 b56143bc50374013 0000000000000000 00000000=
00000000
[ 1174.507681] Call Trace:
[ 1174.508308]  [<ffffffff8103f69e>] default_idle+0x38/0xc1
[ 1174.509214]  [<ffffffff8103fdca>] arch_cpu_idle+0x18/0x28
[ 1174.510136]  [<ffffffff8110923e>] cpu_startup_entry+0x178/0x245
[ 1174.511112]  [<ffffffff81118fa2>] ? clockevents_register_device+0x112/0x=
117
[ 1174.512231]  [<ffffffff8105b391>] start_secondary+0x277/0x279
[ 1174.513200] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[ 1174.517511] NMI backtrace for cpu 2
[ 1174.518250] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[ 1174.519784] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1174.520796] task: ffff880119b25a00 ti: ffff880119b42000 task.ti: ffff880=
119b42000
[ 1174.522354] RIP: 0010:[<ffffffff81065bfa>]  [<ffffffff81065bfa>] native_=
safe_halt+0x6/0x8
[ 1174.523937] RSP: 0018:ffff880119b43eb8  EFLAGS: 00000246
[ 1174.524893] RAX: 0000000000000000 RBX: ffff880119b43fd8 RCX: 00000000fff=
fffff
[ 1174.526049] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[ 1174.527210] RBP: ffff880119b43eb8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1174.528376] R10: 0000000000000002 R11: 0000000000000400 R12: 00000000000=
00002
[ 1174.529486] R13: ffff880119b43fd8 R14: ffff880119b43fd8 R15: 00000000000=
00000
[ 1174.530673] FS:  0000000000000000(0000) GS:ffff88011fd00000(0000) knlGS:=
0000000000000000
[ 1174.532255] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1174.533229] CR2: 0000000000fb2b84 CR3: 000000007ee55000 CR4: 00000000000=
006e0
[ 1174.534440] Stack:
[ 1174.535010]  ffff880119b43ed8 ffffffff8103f69e ffff880119b43fd8 ffff8801=
19b43fd8
[ 1174.536594]  ffff880119b43ee8 ffffffff8103fdca ffff880119b43f30 ffffffff=
8110923e
[ 1174.538183]  ffffffff81118fa2 3f66056c4b53d441 0000000000000000 00000000=
00000000
[ 1174.539814] Call Trace:
[ 1174.540438]  [<ffffffff8103f69e>] default_idle+0x38/0xc1
[ 1174.541362]  [<ffffffff8103fdca>] arch_cpu_idle+0x18/0x28
[ 1174.542368]  [<ffffffff8110923e>] cpu_startup_entry+0x178/0x245
[ 1174.543353]  [<ffffffff81118fa2>] ? clockevents_register_device+0x112/0x=
117
[ 1174.544519]  [<ffffffff8105b391>] start_secondary+0x277/0x279
[ 1174.545488] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[ 1174.549964] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 127.028 msecs
[ 1174.549966] NMI backtrace for cpu 1
[ 1174.549969] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[ 1174.549970] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1174.549971] task: ffff880119b25100 ti: ffff880119b40000 task.ti: ffff880=
119b40000
[ 1174.549975] RIP: 0010:[<ffffffff81065bfa>]  [<ffffffff81065bfa>] native_=
safe_halt+0x6/0x8
[ 1174.549976] RSP: 0018:ffff880119b41eb8  EFLAGS: 00000246
[ 1174.549976] RAX: 0000000000000000 RBX: ffff880119b41fd8 RCX: 00000000fff=
fffff
[ 1174.549977] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[ 1174.549978] RBP: ffff880119b41eb8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1174.549978] R10: 0000000100036fb1 R11: 0000000000000040 R12: 00000000000=
00001
[ 1174.549979] R13: ffff880119b41fd8 R14: ffff880119b41fd8 R15: 00000000000=
00000
[ 1174.549980] FS:  0000000000000000(0000) GS:ffff88011fc80000(0000) knlGS:=
0000000000000000
[ 1174.549980] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1174.549981] CR2: 00007f1f8f666008 CR3: 000000007f97b000 CR4: 00000000000=
006e0
[ 1174.549986] Stack:
[ 1174.549988]  ffff880119b41ed8 ffffffff8103f69e ffff880119b41fd8 ffff8801=
19b41fd8
[ 1174.549989]  ffff880119b41ee8 ffffffff8103fdca ffff880119b41f30 ffffffff=
8110923e
[ 1174.549990]  ffffffff81118fa2 e173ef88b221c3f9 0000000000000000 00000000=
00000000
[ 1174.549990] Call Trace:
[ 1174.549993]  [<ffffffff8103f69e>] default_idle+0x38/0xc1
[ 1174.549995]  [<ffffffff8103fdca>] arch_cpu_idle+0x18/0x28
[ 1174.549996]  [<ffffffff8110923e>] cpu_startup_entry+0x178/0x245
[ 1174.549998]  [<ffffffff81118fa2>] ? clockevents_register_device+0x112/0x=
117
[ 1174.549999]  [<ffffffff8105b391>] start_secondary+0x277/0x279
[ 1174.550009] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[ 1174.550013] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 127.058 msecs
[ 1174.550026] INFO: rcu_sched detected stalls on CPUs/tasks: { 0} (detecte=
d by 1, t=3D15032 jiffies, g=3D7101, c=3D7100, q=3D4733)
[ 1354.560260] INFO: rcu_sched self-detected stall on CPU { 0}  (t=3D60035 =
jiffies g=3D7101 c=3D7100 q=3D4733)
[ 1354.561944] sending NMI to all CPUs:
[ 1354.562652] NMI backtrace for cpu 0
[ 1354.563421] CPU: 0 PID: 692 Comm: kswapd0 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[ 1354.564975] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1354.565974] task: ffff8801195f5a00 ti: ffff8800b6468000 task.ti: ffff880=
0b6468000
[ 1354.567510] RIP: 0010:[<ffffffff81060dd2>]  [<ffffffff81060dd2>] flat_se=
nd_IPI_mask+0x7e/0xac
[ 1354.569190] RSP: 0018:ffff88011fc03dd0  EFLAGS: 00010046
[ 1354.570138] RAX: 0000000000000c00 RBX: 0000000000000046 RCX: 00000000000=
04765
[ 1354.571297] RDX: ffffffff82221ca0 RSI: 0000000000000002 RDI: 00000000000=
00300
[ 1354.572455] RBP: ffff88011fc03df0 R08: 0000000000000000 R09: 00000000000=
00000
[ 1354.573607] R10: 0000000000006a40 R11: 0000000000000000 R12: 00000000000=
00002
[ 1354.574761] R13: 0000000000000c00 R14: 000000000000000f R15: 00000000000=
00000
[ 1354.575919] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:=
0000000000000000
[ 1354.577524] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1354.578525] CR2: 00007ffac27a6f70 CR3: 000000000220c000 CR4: 00000000000=
006f0
[ 1354.579694] Stack:
[ 1354.580281]  0000000000002710 ffff88011fc0d800 0000000000000000 ffffffff=
8224da00
[ 1354.581889]  ffff88011fc03e00 ffffffff81061079 ffff88011fc03e18 ffffffff=
8105e2b1
[ 1354.583497]  ffffffff8224da00 ffff88011fc03e70 ffffffff81111e9b ffff8801=
1fc13040
[ 1354.585112] Call Trace:
[ 1354.585751]  <IRQ>=20
[ 1354.585982]  [<ffffffff81061079>] flat_send_IPI_all+0x1f/0x4a
[ 1354.587398]  [<ffffffff8105e2b1>] arch_trigger_all_cpu_backtrace+0x52/0x=
84
[ 1354.588526]  [<ffffffff81111e9b>] rcu_check_callbacks+0x205/0x57f
[ 1354.589567]  [<ffffffff8111b057>] ? tick_sched_do_timer+0x2f/0x2f
[ 1354.590608]  [<ffffffff810d044e>] update_process_times+0x3d/0x65
[ 1354.591641]  [<ffffffff8111af6c>] tick_sched_handle+0x37/0x43
[ 1354.592647]  [<ffffffff8111b091>] tick_sched_timer+0x3a/0x58
[ 1354.593638]  [<ffffffff810e3ac7>] __run_hrtimer+0x96/0x19a
[ 1354.594610]  [<ffffffff810e42ff>] hrtimer_interrupt+0xe8/0x1e3
[ 1354.595617]  [<ffffffff8105cbf1>] local_apic_timer_interrupt+0x54/0x57
[ 1354.596709]  [<ffffffff81a0f123>] smp_apic_timer_interrupt+0x3f/0x50
[ 1354.597782]  [<ffffffff81a0de32>] apic_timer_interrupt+0x72/0x80
[ 1354.598812]  <EOI>=20
[ 1354.599042]  [<ffffffff811bbbdb>] ? mem_cgroup_zone_lruvec+0x46/0x52
[ 1354.600518]  [<ffffffff8117a45c>] shrink_zone+0x59/0x158
[ 1354.601472]  [<ffffffff8117b3e9>] balance_pgdat+0x33e/0x501
[ 1354.608315]  [<ffffffff8117b8eb>] kswapd+0x33f/0x3c7
[ 1354.609225]  [<ffffffff810fb058>] ? __wake_up_sync+0x12/0x12
[ 1354.610219]  [<ffffffff8117b5ac>] ? balance_pgdat+0x501/0x501
[ 1354.611225]  [<ffffffff810e155c>] kthread+0xdb/0xe3
[ 1354.612131]  [<ffffffff810e1481>] ? kthread_create_on_node+0x16f/0x16f
[ 1354.613231]  [<ffffffff81a0d1bc>] ret_from_fork+0x7c/0xb0
[ 1354.614191]  [<ffffffff810e1481>] ? kthread_create_on_node+0x16f/0x16f
[ 1354.615275] Code: eb f0 44 89 f0 c1 e0 18 89 04 25 10 33 5f ff 44 89 e0 =
44 09 e8 41 81 cd 00 04 00 00 41 83 fc 02 41 0f 44 c5 89 04 25 00 33 5f ff =
<f6> c7 02 75 11 48 89 df 57 9d 0f 1f 44 00 00 e8 6e 94 0e 00 eb=20
[ 1354.619749] NMI backtrace for cpu 3
[ 1354.620500] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[ 1354.622016] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1354.622975] task: ffff880119b26300 ti: ffff880119b48000 task.ti: ffff880=
119b48000
[ 1354.624460] RIP: 0010:[<ffffffff81065bfa>]  [<ffffffff81065bfa>] native_=
safe_halt+0x6/0x8
[ 1354.626039] RSP: 0018:ffff880119b49eb8  EFLAGS: 00000246
[ 1354.626965] RAX: 0000000000000000 RBX: ffff880119b49fd8 RCX: 00000000fff=
fffff
[ 1354.628080] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[ 1354.629194] RBP: ffff880119b49eb8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1354.630321] R10: 0000000000000003 R11: 0000000000000400 R12: 00000000000=
00003
[ 1354.631449] R13: ffff880119b49fd8 R14: ffff880119b49fd8 R15: 00000000000=
00000
[ 1354.632564] FS:  0000000000000000(0000) GS:ffff88011fd80000(0000) knlGS:=
0000000000000000
[ 1354.634121] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1354.635076] CR2: 00007f1f8f2831a0 CR3: 000000007cc95000 CR4: 00000000000=
006e0
[ 1354.636185] Stack:
[ 1354.636742]  ffff880119b49ed8 ffffffff8103f69e ffff880119b49fd8 ffff8801=
19b49fd8
[ 1354.638312]  ffff880119b49ee8 ffffffff8103fdca ffff880119b49f30 ffffffff=
8110923e
[ 1354.639907]  ffffffff81118fa2 b56143bc50374013 0000000000000000 00000000=
00000000
[ 1354.641456] Call Trace:
[ 1354.642063]  [<ffffffff8103f69e>] default_idle+0x38/0xc1
[ 1354.642982]  [<ffffffff8103fdca>] arch_cpu_idle+0x18/0x28
[ 1354.643913]  [<ffffffff8110923e>] cpu_startup_entry+0x178/0x245
[ 1354.644895]  [<ffffffff81118fa2>] ? clockevents_register_device+0x112/0x=
117
[ 1354.645996]  [<ffffffff8105b391>] start_secondary+0x277/0x279
[ 1354.646993] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[ 1354.651327] NMI backtrace for cpu 1
[ 1354.651336] INFO: rcu_sched detected stalls on CPUs/tasks: { 0} (detecte=
d by 3, t=3D60057 jiffies, g=3D7101, c=3D7100, q=3D4733)
[ 1354.653903] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[ 1354.655444] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1354.656444] task: ffff880119b25100 ti: ffff880119b40000 task.ti: ffff880=
119b40000
[ 1354.658109] RIP: 0010:[<ffffffff81065bfa>]  [<ffffffff81065bfa>] native_=
safe_halt+0x6/0x8
[ 1354.659876] RSP: 0018:ffff880119b41eb8  EFLAGS: 00000246
[ 1354.660863] RAX: 0000000000000000 RBX: ffff880119b41fd8 RCX: 00000000fff=
fffff
[ 1354.662053] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[ 1354.663239] RBP: ffff880119b41eb8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1354.664429] R10: 0000000000000001 R11: 0000000000000400 R12: 00000000000=
00001
[ 1354.665617] R13: ffff880119b41fd8 R14: ffff880119b41fd8 R15: 00000000000=
00000
[ 1354.666814] FS:  0000000000000000(0000) GS:ffff88011fc80000(0000) knlGS:=
0000000000000000
[ 1354.668468] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1354.669498] CR2: 00007f1f8f666008 CR3: 000000007f97b000 CR4: 00000000000=
006e0
[ 1354.670692] Stack:
[ 1354.671293]  ffff880119b41ed8 ffffffff8103f69e ffff880119b41fd8 ffff8801=
19b41fd8
[ 1354.672956]  ffff880119b41ee8 ffffffff8103fdca ffff880119b41f30 ffffffff=
8110923e
[ 1354.674617]  ffffffff81118fa2 e173ef88b221c3f9 0000000000000000 00000000=
00000000
[ 1354.676279] Call Trace:
[ 1354.676939]  [<ffffffff8103f69e>] default_idle+0x38/0xc1
[ 1354.677920]  [<ffffffff8103fdca>] arch_cpu_idle+0x18/0x28
[ 1354.678912]  [<ffffffff8110923e>] cpu_startup_entry+0x178/0x245
[ 1354.680017]  [<ffffffff81118fa2>] ? clockevents_register_device+0x112/0x=
117
[ 1354.681186]  [<ffffffff8105b391>] start_secondary+0x277/0x279
[ 1354.682193] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[ 1354.686560] NMI backtrace for cpu 2
[ 1354.687273] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[ 1354.688692] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1354.689586] task: ffff880119b25a00 ti: ffff880119b42000 task.ti: ffff880=
119b42000
[ 1354.690970] RIP: 0010:[<ffffffff81065bfa>]  [<ffffffff81065bfa>] native_=
safe_halt+0x6/0x8
[ 1354.692424] RSP: 0018:ffff880119b43eb8  EFLAGS: 00000246
[ 1354.693252] RAX: 0000000000000000 RBX: ffff880119b43fd8 RCX: 00000000fff=
fffff
[ 1354.694296] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[ 1354.695325] RBP: ffff880119b43eb8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1354.696386] R10: 0000000000000002 R11: 0000000000000400 R12: 00000000000=
00002
[ 1354.697418] R13: ffff880119b43fd8 R14: ffff880119b43fd8 R15: 00000000000=
00000
[ 1354.698425] FS:  0000000000000000(0000) GS:ffff88011fd00000(0000) knlGS:=
0000000000000000
[ 1354.699920] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1354.700818] CR2: 0000000000fb2b84 CR3: 000000007ee55000 CR4: 00000000000=
006e0
[ 1354.701828] Stack:
[ 1354.702384]  ffff880119b43ed8 ffffffff8103f69e ffff880119b43fd8 ffff8801=
19b43fd8
[ 1354.703789]  ffff880119b43ee8 ffffffff8103fdca ffff880119b43f30 ffffffff=
8110923e
[ 1354.705275]  ffffffff81118fa2 3f66056c4b53d441 0000000000000000 00000000=
00000000
[ 1354.706675] Call Trace:
[ 1354.707224]  [<ffffffff8103f69e>] default_idle+0x38/0xc1
[ 1354.708055]  [<ffffffff8103fdca>] arch_cpu_idle+0x18/0x28
[ 1354.708950]  [<ffffffff8110923e>] cpu_startup_entry+0x178/0x245
[ 1354.709842]  [<ffffffff81118fa2>] ? clockevents_register_device+0x112/0x=
117
[ 1354.710835]  [<ffffffff8105b391>] start_secondary+0x277/0x279
[ 1354.711767] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[ 1354.715912] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 153.222 msecs
[ 1534.660260] INFO: rcu_sched self-detected stall on CPU { 0}  (t=3D105060=
 jiffies g=3D7101 c=3D7100 q=3D4734)
[ 1534.662101] sending NMI to all CPUs:
[ 1534.662862] NMI backtrace for cpu 0
[ 1534.663659] CPU: 0 PID: 692 Comm: kswapd0 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[ 1534.665265] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1534.666304] task: ffff8801195f5a00 ti: ffff8800b6468000 task.ti: ffff880=
0b6468000
[ 1534.667892] RIP: 0010:[<ffffffff81060dd2>]  [<ffffffff81060dd2>] flat_se=
nd_IPI_mask+0x7e/0xac
[ 1534.669631] RSP: 0018:ffff88011fc03dd0  EFLAGS: 00010046
[ 1534.670619] RAX: 0000000000000c00 RBX: 0000000000000046 RCX: 00000000000=
04f3c
[ 1534.671808] RDX: ffffffff82221ca0 RSI: 0000000000000002 RDI: 00000000000=
00300
[ 1534.673004] RBP: ffff88011fc03df0 R08: 0000000000000000 R09: 00000000000=
00000
[ 1534.674191] R10: 000000000000cf80 R11: 0000000000000000 R12: 00000000000=
00002
[ 1534.675386] R13: 0000000000000c00 R14: 000000000000000f R15: 00000000000=
00000
[ 1534.676579] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:=
0000000000000000
[ 1534.678243] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1534.679277] CR2: 00007ffac27a6f70 CR3: 000000000220c000 CR4: 00000000000=
006f0
[ 1534.680474] Stack:
[ 1534.681083]  0000000000002710 ffff88011fc0d800 0000000000000000 ffffffff=
8224da00
[ 1534.682752]  ffff88011fc03e00 ffffffff81061079 ffff88011fc03e18 ffffffff=
8105e2b1
[ 1534.684424]  ffffffff8224da00 ffff88011fc03e70 ffffffff81111e9b ffff8801=
1fc13040
[ 1534.686094] Call Trace:
[ 1534.686750]  <IRQ>=20
[ 1534.686993]  [<ffffffff81061079>] flat_send_IPI_all+0x1f/0x4a
[ 1534.688449]  [<ffffffff8105e2b1>] arch_trigger_all_cpu_backtrace+0x52/0x=
84
[ 1534.689610]  [<ffffffff81111e9b>] rcu_check_callbacks+0x205/0x57f
[ 1534.690682]  [<ffffffff8111b057>] ? tick_sched_do_timer+0x2f/0x2f
[ 1534.691758]  [<ffffffff810d044e>] update_process_times+0x3d/0x65
[ 1534.692822]  [<ffffffff8111af6c>] tick_sched_handle+0x37/0x43
[ 1534.693853]  [<ffffffff8111b091>] tick_sched_timer+0x3a/0x58
[ 1534.694877]  [<ffffffff810e3ac7>] __run_hrtimer+0x96/0x19a
[ 1534.695885]  [<ffffffff810e42ff>] hrtimer_interrupt+0xe8/0x1e3
[ 1534.696927]  [<ffffffff8105cbf1>] local_apic_timer_interrupt+0x54/0x57
[ 1534.698065]  [<ffffffff81a0f123>] smp_apic_timer_interrupt+0x3f/0x50
[ 1534.699175]  [<ffffffff81a0de32>] apic_timer_interrupt+0x72/0x80
[ 1534.700236]  <EOI>=20
[ 1534.700473]  [<ffffffff81a05afd>] ? _raw_spin_lock+0x1a/0x34
[ 1534.701921]  [<ffffffff81187c63>] list_lru_count_node+0x1c/0x57
[ 1534.702984]  [<ffffffff811c706a>] super_cache_count+0x77/0xba
[ 1534.704021]  [<ffffffff811780f4>] shrink_slab+0xfc/0x326
[ 1534.705005]  [<ffffffff811ba7c6>] ? mem_cgroup_iter+0x146/0x265
[ 1534.706062]  [<ffffffff811bfde0>] ? vmpressure+0x21/0x76
[ 1534.707044]  [<ffffffff8117b420>] balance_pgdat+0x375/0x501
[ 1534.708060]  [<ffffffff8117b8eb>] kswapd+0x33f/0x3c7
[ 1534.709010]  [<ffffffff810fb058>] ? __wake_up_sync+0x12/0x12
[ 1534.710031]  [<ffffffff8117b5ac>] ? balance_pgdat+0x501/0x501
[ 1534.711063]  [<ffffffff810e155c>] kthread+0xdb/0xe3
[ 1534.712001]  [<ffffffff810e1481>] ? kthread_create_on_node+0x16f/0x16f
[ 1534.713125]  [<ffffffff81a0d1bc>] ret_from_fork+0x7c/0xb0
[ 1534.714126]  [<ffffffff810e1481>] ? kthread_create_on_node+0x16f/0x16f
[ 1534.715247] Code: eb f0 44 89 f0 c1 e0 18 89 04 25 10 33 5f ff 44 89 e0 =
44 09 e8 41 81 cd 00 04 00 00 41 83 fc 02 41 0f 44 c5 89 04 25 00 33 5f ff =
<f6> c7 02 75 11 48 89 df 57 9d 0f 1f 44 00 00 e8 6e 94 0e 00 eb=20
[ 1534.719849] NMI backtrace for cpu 2
[ 1534.720620] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[ 1534.722194] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1534.728798] task: ffff880119b25a00 ti: ffff880119b42000 task.ti: ffff880=
119b42000
[ 1534.730320] RIP: 0010:[<ffffffff81065bfa>]  [<ffffffff81065bfa>] native_=
safe_halt+0x6/0x8
[ 1534.731947] RSP: 0018:ffff880119b43eb8  EFLAGS: 00000246
[ 1534.732901] RAX: 0000000000000000 RBX: ffff880119b43fd8 RCX: 00000000fff=
fffff
[ 1534.734061] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[ 1534.735220] RBP: ffff880119b43eb8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1534.736370] R10: 0000000000000002 R11: 0000000000000400 R12: 00000000000=
00002
[ 1534.737522] R13: ffff880119b43fd8 R14: ffff880119b43fd8 R15: 00000000000=
00000
[ 1534.738682] FS:  0000000000000000(0000) GS:ffff88011fd00000(0000) knlGS:=
0000000000000000
[ 1534.740289] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1534.741294] CR2: 0000000000fb2b84 CR3: 000000007ee55000 CR4: 00000000000=
006e0
[ 1534.742475] Stack:
[ 1534.743061]  ffff880119b43ed8 ffffffff8103f69e ffff880119b43fd8 ffff8801=
19b43fd8
[ 1534.744677]  ffff880119b43ee8 ffffffff8103fdca ffff880119b43f30 ffffffff=
8110923e
[ 1534.746278]  ffffffff81118fa2 3f66056c4b53d441 0000000000000000 00000000=
00000000
[ 1534.747891] Call Trace:
[ 1534.748524]  [<ffffffff8103f69e>] default_idle+0x38/0xc1
[ 1534.749478]  [<ffffffff8103fdca>] arch_cpu_idle+0x18/0x28
[ 1534.750447]  [<ffffffff8110923e>] cpu_startup_entry+0x178/0x245
[ 1534.751461]  [<ffffffff81118fa2>] ? clockevents_register_device+0x112/0x=
117
[ 1534.752608]  [<ffffffff8105b391>] start_secondary+0x277/0x279
[ 1534.753620] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[ 1534.758117] NMI backtrace for cpu 1
[ 1534.758128] INFO: rcu_sched detected stalls on CPUs/tasks: { 0} (detecte=
d by 2, t=3D105084 jiffies, g=3D7101, c=3D7100, q=3D4734)
[ 1534.760904] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[ 1534.762517] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1534.763552] task: ffff880119b25100 ti: ffff880119b40000 task.ti: ffff880=
119b40000
[ 1534.765145] RIP: 0010:[<ffffffff81065bfa>]  [<ffffffff81065bfa>] native_=
safe_halt+0x6/0x8
[ 1534.766833] RSP: 0018:ffff880119b41eb8  EFLAGS: 00000246
[ 1534.767832] RAX: 0000000000000000 RBX: ffff880119b41fd8 RCX: 00000000fff=
fffff
[ 1534.769027] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[ 1534.770216] RBP: ffff880119b41eb8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1534.771407] R10: 000000010005b9a1 R11: 0000000000000040 R12: 00000000000=
00001
[ 1534.772597] R13: ffff880119b41fd8 R14: ffff880119b41fd8 R15: 00000000000=
00000
[ 1534.773788] FS:  0000000000000000(0000) GS:ffff88011fc80000(0000) knlGS:=
0000000000000000
[ 1534.775452] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1534.776483] CR2: 00007f1f8f666008 CR3: 000000007f97b000 CR4: 00000000000=
006e0
[ 1534.777676] Stack:
[ 1534.778283]  ffff880119b41ed8 ffffffff8103f69e ffff880119b41fd8 ffff8801=
19b41fd8
[ 1534.779955]  ffff880119b41ee8 ffffffff8103fdca ffff880119b41f30 ffffffff=
8110923e
[ 1534.781621]  ffffffff81118fa2 e173ef88b221c3f9 0000000000000000 00000000=
00000000
[ 1534.783316] Call Trace:
[ 1534.783985]  [<ffffffff8103f69e>] default_idle+0x38/0xc1
[ 1534.784967]  [<ffffffff8103fdca>] arch_cpu_idle+0x18/0x28
[ 1534.785964]  [<ffffffff8110923e>] cpu_startup_entry+0x178/0x245
[ 1534.787019]  [<ffffffff81118fa2>] ? clockevents_register_device+0x112/0x=
117
[ 1534.788196]  [<ffffffff8105b391>] start_secondary+0x277/0x279
[ 1534.789231] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[ 1534.793842] NMI backtrace for cpu 3
[ 1534.794610] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[ 1534.796146] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1534.797133] task: ffff880119b26300 ti: ffff880119b48000 task.ti: ffff880=
119b48000
[ 1534.798647] RIP: 0010:[<ffffffff81065bfa>]  [<ffffffff81065bfa>] native_=
safe_halt+0x6/0x8
[ 1534.800258] RSP: 0018:ffff880119b49eb8  EFLAGS: 00000246
[ 1534.801199] RAX: 0000000000000000 RBX: ffff880119b49fd8 RCX: 00000000fff=
fffff
[ 1534.802341] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[ 1534.803487] RBP: ffff880119b49eb8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1534.804633] R10: 0000000000000003 R11: 0000000000000400 R12: 00000000000=
00003
[ 1534.805772] R13: ffff880119b49fd8 R14: ffff880119b49fd8 R15: 00000000000=
00000
[ 1534.806910] FS:  0000000000000000(0000) GS:ffff88011fd80000(0000) knlGS:=
0000000000000000
[ 1534.808490] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1534.809477] CR2: 00007f1f8f2831a0 CR3: 000000007cc95000 CR4: 00000000000=
006e0
[ 1534.810626] Stack:
[ 1534.811208]  ffff880119b49ed8 ffffffff8103f69e ffff880119b49fd8 ffff8801=
19b49fd8
[ 1534.812804]  ffff880119b49ee8 ffffffff8103fdca ffff880119b49f30 ffffffff=
8110923e
[ 1534.814397]  ffffffff81118fa2 b56143bc50374013 0000000000000000 00000000=
00000000
[ 1534.816009] Call Trace:
[ 1534.816630]  [<ffffffff8103f69e>] default_idle+0x38/0xc1
[ 1534.817574]  [<ffffffff8103fdca>] arch_cpu_idle+0x18/0x28
[ 1534.818537]  [<ffffffff8110923e>] cpu_startup_entry+0x178/0x245
[ 1534.819547]  [<ffffffff81118fa2>] ? clockevents_register_device+0x112/0x=
117
[ 1534.820674]  [<ffffffff8105b391>] start_secondary+0x277/0x279
[ 1534.821660] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[ 1534.826127] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 163.227 msecs
[ 1714.768264] INFO: rcu_sched self-detected stall on CPU { 0}  (t=3D150087=
 jiffies g=3D7101 c=3D7100 q=3D4734)
[ 1714.769947] sending NMI to all CPUs:
[ 1714.770652] NMI backtrace for cpu 0
[ 1714.771417] CPU: 0 PID: 692 Comm: kswapd0 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[ 1714.772962] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1714.773964] task: ffff8801195f5a00 ti: ffff8800b6468000 task.ti: ffff880=
0b6468000
[ 1714.775511] RIP: 0010:[<ffffffff81060dd2>]  [<ffffffff81060dd2>] flat_se=
nd_IPI_mask+0x7e/0xac
[ 1714.777185] RSP: 0018:ffff88011fc03dd0  EFLAGS: 00010046
[ 1714.778136] RAX: 0000000000000c00 RBX: 0000000000000046 RCX: 00000000000=
05737
[ 1714.779292] RDX: ffffffff82221ca0 RSI: 0000000000000002 RDI: 00000000000=
00300
[ 1714.780450] RBP: ffff88011fc03df0 R08: 0000000000000000 R09: 00000000000=
00000
[ 1714.781602] R10: 00000000000037a0 R11: 0000000000000000 R12: 00000000000=
00002
[ 1714.782754] R13: 0000000000000c00 R14: 000000000000000f R15: 00000000000=
00000
[ 1714.783909] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:=
0000000000000000
[ 1714.785519] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1714.786516] CR2: 00007ffac27a6f70 CR3: 000000000220c000 CR4: 00000000000=
006f0
[ 1714.787681] Stack:
[ 1714.788264]  0000000000002710 ffff88011fc0d800 0000000000000000 ffffffff=
8224da00
[ 1714.789877]  ffff88011fc03e00 ffffffff81061079 ffff88011fc03e18 ffffffff=
8105e2b1
[ 1714.791517]  ffffffff8224da00 ffff88011fc03e70 ffffffff81111e9b ffff8801=
1fc13040
[ 1714.793133] Call Trace:
[ 1714.793774]  <IRQ>=20
[ 1714.794003]  [<ffffffff81061079>] flat_send_IPI_all+0x1f/0x4a
[ 1714.795430]  [<ffffffff8105e2b1>] arch_trigger_all_cpu_backtrace+0x52/0x=
84
[ 1714.796559]  [<ffffffff81111e9b>] rcu_check_callbacks+0x205/0x57f
[ 1714.797600]  [<ffffffff8111b057>] ? tick_sched_do_timer+0x2f/0x2f
[ 1714.798642]  [<ffffffff810d044e>] update_process_times+0x3d/0x65
[ 1714.799681]  [<ffffffff8111af6c>] tick_sched_handle+0x37/0x43
[ 1714.800686]  [<ffffffff8111b091>] tick_sched_timer+0x3a/0x58
[ 1714.801677]  [<ffffffff810e3ac7>] __run_hrtimer+0x96/0x19a
[ 1714.802652]  [<ffffffff810e42ff>] hrtimer_interrupt+0xe8/0x1e3
[ 1714.803680]  [<ffffffff8105cbf1>] local_apic_timer_interrupt+0x54/0x57
[ 1714.804770]  [<ffffffff81a0f123>] smp_apic_timer_interrupt+0x3f/0x50
[ 1714.805841]  [<ffffffff81a0de32>] apic_timer_interrupt+0x72/0x80
[ 1714.806875]  <EOI>=20
[ 1714.807104]  [<ffffffff8117817c>] ? shrink_slab+0x184/0x326
[ 1714.808507]  [<ffffffff811780f4>] ? shrink_slab+0xfc/0x326
[ 1714.809485]  [<ffffffff811ba7c6>] ? mem_cgroup_iter+0x146/0x265
[ 1714.810512]  [<ffffffff811bfde0>] ? vmpressure+0x21/0x76
[ 1714.811477]  [<ffffffff8117b420>] balance_pgdat+0x375/0x501
[ 1714.812460]  [<ffffffff8117b8eb>] kswapd+0x33f/0x3c7
[ 1714.813380]  [<ffffffff810fb058>] ? __wake_up_sync+0x12/0x12
[ 1714.814373]  [<ffffffff8117b5ac>] ? balance_pgdat+0x501/0x501
[ 1714.815381]  [<ffffffff810e155c>] kthread+0xdb/0xe3
[ 1714.816284]  [<ffffffff810e1481>] ? kthread_create_on_node+0x16f/0x16f
[ 1714.817377]  [<ffffffff81a0d1bc>] ret_from_fork+0x7c/0xb0
[ 1714.818345]  [<ffffffff810e1481>] ? kthread_create_on_node+0x16f/0x16f
[ 1714.819436] Code: eb f0 44 89 f0 c1 e0 18 89 04 25 10 33 5f ff 44 89 e0 =
44 09 e8 41 81 cd 00 04 00 00 41 83 fc 02 41 0f 44 c5 89 04 25 00 33 5f ff =
<f6> c7 02 75 11 48 89 df 57 9d 0f 1f 44 00 00 e8 6e 94 0e 00 eb=20
[ 1714.823909] NMI backtrace for cpu 2
[ 1714.824682] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[ 1714.826164] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1714.827154] task: ffff880119b25a00 ti: ffff880119b42000 task.ti: ffff880=
119b42000
[ 1714.828631] RIP: 0010:[<ffffffff81065bfa>]  [<ffffffff81065bfa>] native_=
safe_halt+0x6/0x8
[ 1714.830204] RSP: 0018:ffff880119b43eb8  EFLAGS: 00000246
[ 1714.831140] RAX: 0000000000000000 RBX: ffff880119b43fd8 RCX: 00000000fff=
fffff
[ 1714.832245] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[ 1714.833386] RBP: ffff880119b43eb8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1714.834511] R10: 0000000000000002 R11: 0000000000000400 R12: 00000000000=
00002
[ 1714.835638] R13: ffff880119b43fd8 R14: ffff880119b43fd8 R15: 00000000000=
00000
[ 1714.836758] FS:  0000000000000000(0000) GS:ffff88011fd00000(0000) knlGS:=
0000000000000000
[ 1714.838297] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1714.839256] CR2: 0000000000fb2b84 CR3: 000000007ee55000 CR4: 00000000000=
006e0
[ 1714.840364] Stack:
[ 1714.840919]  ffff880119b43ed8 ffffffff8103f69e ffff880119b43fd8 ffff8801=
19b43fd8
[ 1714.847892]  ffff880119b43ee8 ffffffff8103fdca ffff880119b43f30 ffffffff=
8110923e
[ 1714.849445]  ffffffff81118fa2 3f66056c4b53d441 0000000000000000 00000000=
00000000
[ 1714.850984] Call Trace:
[ 1714.851622]  [<ffffffff8103f69e>] default_idle+0x38/0xc1
[ 1714.852538]  [<ffffffff8103fdca>] arch_cpu_idle+0x18/0x28
[ 1714.853457]  [<ffffffff8110923e>] cpu_startup_entry+0x178/0x245
[ 1714.854445]  [<ffffffff81118fa2>] ? clockevents_register_device+0x112/0x=
117
[ 1714.855538]  [<ffffffff8105b391>] start_secondary+0x277/0x279
[ 1714.856520] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[ 1714.860826] NMI backtrace for cpu 1
[ 1714.861563] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[ 1714.863026] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1714.863968] task: ffff880119b25100 ti: ffff880119b40000 task.ti: ffff880=
119b40000
[ 1714.865501] RIP: 0010:[<ffffffff81065bfa>]  [<ffffffff81065bfa>] native_=
safe_halt+0x6/0x8
[ 1714.867069] RSP: 0018:ffff880119b41eb8  EFLAGS: 00000246
[ 1714.867968] RAX: 0000000000000000 RBX: ffff880119b41fd8 RCX: 00000000fff=
fffff
[ 1714.869077] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[ 1714.870164] RBP: ffff880119b41eb8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1714.871283] R10: 000000010005b9a1 R11: 0000000000000040 R12: 00000000000=
00001
[ 1714.872436] R13: ffff880119b41fd8 R14: ffff880119b41fd8 R15: 00000000000=
00000
[ 1714.873551] FS:  0000000000000000(0000) GS:ffff88011fc80000(0000) knlGS:=
0000000000000000
[ 1714.875090] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1714.876059] CR2: 00007f1f8f666008 CR3: 000000007f97b000 CR4: 00000000000=
006e0
[ 1714.877194] Stack:
[ 1714.877786]  ffff880119b41ed8 ffffffff8103f69e ffff880119b41fd8 ffff8801=
19b41fd8
[ 1714.879348]  ffff880119b41ee8 ffffffff8103fdca ffff880119b41f30 ffffffff=
8110923e
[ 1714.880901]  ffffffff81118fa2 e173ef88b221c3f9 0000000000000000 00000000=
00000000
[ 1714.882443] Call Trace:
[ 1714.883040]  [<ffffffff8103f69e>] default_idle+0x38/0xc1
[ 1714.883967]  [<ffffffff8103fdca>] arch_cpu_idle+0x18/0x28
[ 1714.884905]  [<ffffffff8110923e>] cpu_startup_entry+0x178/0x245
[ 1714.885868]  [<ffffffff81118fa2>] ? clockevents_register_device+0x112/0x=
117
[ 1714.886969]  [<ffffffff8105b391>] start_secondary+0x277/0x279
[ 1714.887912] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[ 1714.892171] NMI backtrace for cpu 3
[ 1714.892178] INFO: rcu_sched detected stalls on CPUs/tasks: { 0} (detecte=
d by 1, t=3D150117 jiffies, g=3D7101, c=3D7100, q=3D4734)
[ 1714.894592] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[ 1714.895941] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1714.896872] task: ffff880119b26300 ti: ffff880119b48000 task.ti: ffff880=
119b48000
[ 1714.898238] RIP: 0010:[<ffffffff81065bfa>]  [<ffffffff81065bfa>] native_=
safe_halt+0x6/0x8
[ 1714.899692] RSP: 0018:ffff880119b49eb8  EFLAGS: 00000246
[ 1714.900550] RAX: 0000000000000000 RBX: ffff880119b49fd8 RCX: 00000000fff=
fffff
[ 1714.901557] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[ 1714.902563] RBP: ffff880119b49eb8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1714.903594] R10: 0000000000000003 R11: 0000000000000400 R12: 00000000000=
00003
[ 1714.904630] R13: ffff880119b49fd8 R14: ffff880119b49fd8 R15: 00000000000=
00000
[ 1714.905634] FS:  0000000000000000(0000) GS:ffff88011fd80000(0000) knlGS:=
0000000000000000
[ 1714.907035] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1714.907908] CR2: 00007f1f8f2831a0 CR3: 000000007cc95000 CR4: 00000000000=
006e0
[ 1714.908967] Stack:
[ 1714.909480]  ffff880119b49ed8 ffffffff8103f69e ffff880119b49fd8 ffff8801=
19b49fd8
[ 1714.910892]  ffff880119b49ee8 ffffffff8103fdca ffff880119b49f30 ffffffff=
8110923e
[ 1714.912363]  ffffffff81118fa2 b56143bc50374013 0000000000000000 00000000=
00000000
[ 1714.913773] Call Trace:
[ 1714.914330]  [<ffffffff8103f69e>] default_idle+0x38/0xc1
[ 1714.915162]  [<ffffffff8103fdca>] arch_cpu_idle+0x18/0x28
[ 1714.916011]  [<ffffffff8110923e>] cpu_startup_entry+0x178/0x245
[ 1714.916924]  [<ffffffff81118fa2>] ? clockevents_register_device+0x112/0x=
117
[ 1714.917920]  [<ffffffff8105b391>] start_secondary+0x277/0x279
[ 1714.918843] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[ 1894.900261] INFO: rcu_sched self-detected stall on CPU { 0}  (t=3D195120=
 jiffies g=3D7101 c=3D7100 q=3D4888)
[ 1894.902093] sending NMI to all CPUs:
[ 1894.902864] NMI backtrace for cpu 0
[ 1894.903657] CPU: 0 PID: 692 Comm: kswapd0 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[ 1894.905262] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1894.906302] task: ffff8801195f5a00 ti: ffff8800b6468000 task.ti: ffff880=
0b6468000
[ 1894.907897] RIP: 0010:[<ffffffff81060dd2>]  [<ffffffff81060dd2>] flat_se=
nd_IPI_mask+0x7e/0xac
[ 1894.909638] RSP: 0018:ffff88011fc03dd0  EFLAGS: 00010046
[ 1894.910612] RAX: 0000000000000c00 RBX: 0000000000000046 RCX: 00000000000=
05f1b
[ 1894.911811] RDX: ffffffff82221ca0 RSI: 0000000000000002 RDI: 00000000000=
00300
[ 1894.913000] RBP: ffff88011fc03df0 R08: 0000000000000000 R09: 00000000000=
00000
[ 1894.914194] R10: 0000000000009ce0 R11: 0000000000000000 R12: 00000000000=
00002
[ 1894.915389] R13: 0000000000000c00 R14: 000000000000000f R15: 00000000000=
00000
[ 1894.916581] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:=
0000000000000000
[ 1894.918248] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1894.919287] CR2: 00007ffac27a6f70 CR3: 000000000220c000 CR4: 00000000000=
006f0
[ 1894.920483] Stack:
[ 1894.921093]  0000000000002710 ffff88011fc0d800 0000000000000000 ffffffff=
8224da00
[ 1894.922760]  ffff88011fc03e00 ffffffff81061079 ffff88011fc03e18 ffffffff=
8105e2b1
[ 1894.924451]  ffffffff8224da00 ffff88011fc03e70 ffffffff81111e9b ffff8801=
1fc13040
[ 1894.926114] Call Trace:
[ 1894.926774]  <IRQ>=20
[ 1894.927012]  [<ffffffff81061079>] flat_send_IPI_all+0x1f/0x4a
[ 1894.928470]  [<ffffffff8105e2b1>] arch_trigger_all_cpu_backtrace+0x52/0x=
84
[ 1894.929637]  [<ffffffff81111e9b>] rcu_check_callbacks+0x205/0x57f
[ 1894.930713]  [<ffffffff8111b057>] ? tick_sched_do_timer+0x2f/0x2f
[ 1894.931791]  [<ffffffff810d044e>] update_process_times+0x3d/0x65
[ 1894.932856]  [<ffffffff8111af6c>] tick_sched_handle+0x37/0x43
[ 1894.933890]  [<ffffffff8111b091>] tick_sched_timer+0x3a/0x58
[ 1894.934917]  [<ffffffff810e3ac7>] __run_hrtimer+0x96/0x19a
[ 1894.935926]  [<ffffffff810e42ff>] hrtimer_interrupt+0xe8/0x1e3
[ 1894.936974]  [<ffffffff8105cbf1>] local_apic_timer_interrupt+0x54/0x57
[ 1894.938098]  [<ffffffff81a0f123>] smp_apic_timer_interrupt+0x3f/0x50
[ 1894.939273]  [<ffffffff81a0de32>] apic_timer_interrupt+0x72/0x80
[ 1894.940337]  <EOI>=20
[ 1894.940574]  [<ffffffff814f30ef>] ? find_first_bit+0x6/0x56
[ 1894.942043]  [<ffffffff81178095>] shrink_slab+0x9d/0x326
[ 1894.943034]  [<ffffffff811ba7c6>] ? mem_cgroup_iter+0x146/0x265
[ 1894.944114]  [<ffffffff811bfde0>] ? vmpressure+0x21/0x76
[ 1894.945069]  [<ffffffff8117b420>] balance_pgdat+0x375/0x501
[ 1894.946054]  [<ffffffff8117b8eb>] kswapd+0x33f/0x3c7
[ 1894.946997]  [<ffffffff810fb058>] ? __wake_up_sync+0x12/0x12
[ 1894.947989]  [<ffffffff8117b5ac>] ? balance_pgdat+0x501/0x501
[ 1894.949066]  [<ffffffff810e155c>] kthread+0xdb/0xe3
[ 1894.949992]  [<ffffffff810e1481>] ? kthread_create_on_node+0x16f/0x16f
[ 1894.951104]  [<ffffffff81a0d1bc>] ret_from_fork+0x7c/0xb0
[ 1894.952069]  [<ffffffff810e1481>] ? kthread_create_on_node+0x16f/0x16f
[ 1894.953159] Code: eb f0 44 89 f0 c1 e0 18 89 04 25 10 33 5f ff 44 89 e0 =
44 09 e8 41 81 cd 00 04 00 00 41 83 fc 02 41 0f 44 c5 89 04 25 00 33 5f ff =
<f6> c7 02 75 11 48 89 df 57 9d 0f 1f 44 00 00 e8 6e 94 0e 00 eb=20
[ 1894.957854] NMI backtrace for cpu 3
[ 1894.958595] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[ 1894.960095] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1894.961069] task: ffff880119b26300 ti: ffff880119b48000 task.ti: ffff880=
119b48000
[ 1894.962563] RIP: 0010:[<ffffffff81065bfa>]  [<ffffffff81065bfa>] native_=
safe_halt+0x6/0x8
[ 1894.964208] RSP: 0018:ffff880119b49eb8  EFLAGS: 00000246
[ 1894.965129] RAX: 0000000000000000 RBX: ffff880119b49fd8 RCX: 00000000fff=
fffff
[ 1894.966240] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[ 1894.967360] RBP: ffff880119b49eb8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1894.968480] R10: 0000000000000003 R11: 0000000000000400 R12: 00000000000=
00003
[ 1894.969594] R13: ffff880119b49fd8 R14: ffff880119b49fd8 R15: 00000000000=
00000
[ 1894.970743] FS:  0000000000000000(0000) GS:ffff88011fd80000(0000) knlGS:=
0000000000000000
[ 1894.972358] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1894.973415] CR2: 0000000000fd1f88 CR3: 000000007cc95000 CR4: 00000000000=
006e0
[ 1894.974566] Stack:
[ 1894.975133]  ffff880119b49ed8 ffffffff8103f69e ffff880119b49fd8 ffff8801=
19b49fd8
[ 1894.976710]  ffff880119b49ee8 ffffffff8103fdca ffff880119b49f30 ffffffff=
8110923e
[ 1894.978270]  ffffffff81118fa2 b56143bc50374013 0000000000000000 00000000=
00000000
[ 1894.980029] Call Trace:
[ 1894.980671]  [<ffffffff8103f69e>] default_idle+0x38/0xc1
[ 1894.981594]  [<ffffffff8103fdca>] arch_cpu_idle+0x18/0x28
[ 1894.982526]  [<ffffffff8110923e>] cpu_startup_entry+0x178/0x245
[ 1894.983512]  [<ffffffff81118fa2>] ? clockevents_register_device+0x112/0x=
117
[ 1894.984614]  [<ffffffff8105b391>] start_secondary+0x277/0x279
[ 1894.985579] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[ 1894.990072] NMI backtrace for cpu 1
[ 1894.990082] INFO: rcu_sched detected stalls on CPUs/tasks: { 0} (detecte=
d by 3, t=3D195142 jiffies, g=3D7101, c=3D7100, q=3D4888)
[ 1894.992798] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[ 1895.000394] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1895.001394] task: ffff880119b25100 ti: ffff880119b40000 task.ti: ffff880=
119b40000
[ 1895.002937] RIP: 0010:[<ffffffff81065bfa>]  [<ffffffff81065bfa>] native_=
safe_halt+0x6/0x8
[ 1895.004582] RSP: 0018:ffff880119b41eb8  EFLAGS: 00000246
[ 1895.005537] RAX: 0000000000000000 RBX: ffff880119b41fd8 RCX: 00000000fff=
fffff
[ 1895.006709] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[ 1895.007905] RBP: ffff880119b41eb8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1895.009060] R10: 0000000000000001 R11: 0000000000000400 R12: 00000000000=
00001
[ 1895.010218] R13: ffff880119b41fd8 R14: ffff880119b41fd8 R15: 00000000000=
00000
[ 1895.011373] FS:  0000000000000000(0000) GS:ffff88011fc80000(0000) knlGS:=
0000000000000000
[ 1895.013006] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1895.014007] CR2: 00007f67ee61548f CR3: 000000007f97b000 CR4: 00000000000=
006e0
[ 1895.015247] Stack:
[ 1895.015837]  ffff880119b41ed8 ffffffff8103f69e ffff880119b41fd8 ffff8801=
19b41fd8
[ 1895.017449]  ffff880119b41ee8 ffffffff8103fdca ffff880119b41f30 ffffffff=
8110923e
[ 1895.019116]  ffffffff81118fa2 e173ef88b221c3f9 0000000000000000 00000000=
00000000
[ 1895.020786] Call Trace:
[ 1895.021421]  [<ffffffff8103f69e>] default_idle+0x38/0xc1
[ 1895.022403]  [<ffffffff8103fdca>] arch_cpu_idle+0x18/0x28
[ 1895.023459]  [<ffffffff8110923e>] cpu_startup_entry+0x178/0x245
[ 1895.024515]  [<ffffffff81118fa2>] ? clockevents_register_device+0x112/0x=
117
[ 1895.025655]  [<ffffffff8105b391>] start_secondary+0x277/0x279
[ 1895.026688] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[ 1895.031207] NMI backtrace for cpu 2
[ 1895.031946] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.13.0-rc7-00177-g=
8cb75e0 #1
[ 1895.033418] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1895.034374] task: ffff880119b25a00 ti: ffff880119b42000 task.ti: ffff880=
119b42000
[ 1895.036004] RIP: 0010:[<ffffffff81065bfa>]  [<ffffffff81065bfa>] native_=
safe_halt+0x6/0x8
[ 1895.037816] RSP: 0018:ffff880119b43eb8  EFLAGS: 00000246
[ 1895.038751] RAX: 0000000000000000 RBX: ffff880119b43fd8 RCX: 00000000fff=
fffff
[ 1895.039852] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[ 1895.040953] RBP: ffff880119b43eb8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1895.042056] R10: ffff880119b995a8 R11: 0000000000000040 R12: 00000000000=
00002
[ 1895.043161] R13: ffff880119b43fd8 R14: ffff880119b43fd8 R15: 00000000000=
00000
[ 1895.044262] FS:  0000000000000000(0000) GS:ffff88011fd00000(0000) knlGS:=
0000000000000000
[ 1895.045793] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1895.046827] CR2: 00007f48891f3be0 CR3: 000000007e949000 CR4: 00000000000=
006e0
[ 1895.047970] Stack:
[ 1895.048528]  ffff880119b43ed8 ffffffff8103f69e ffff880119b43fd8 ffff8801=
19b43fd8
[ 1895.050079]  ffff880119b43ee8 ffffffff8103fdca ffff880119b43f30 ffffffff=
8110923e
[ 1895.051645]  ffffffff81118fa2 3f66056c4b53d441 0000000000000000 00000000=
00000000
[ 1895.053179] Call Trace:
[ 1895.053790]  [<ffffffff8103f69e>] default_idle+0x38/0xc1
[ 1895.054700]  [<ffffffff8103fdca>] arch_cpu_idle+0x18/0x28
[ 1895.055614]  [<ffffffff8110923e>] cpu_startup_entry+0x178/0x245
[ 1895.056642]  [<ffffffff81118fa2>] ? clockevents_register_device+0x112/0x=
117
[ 1895.057723]  [<ffffffff8105b391>] start_secondary+0x277/0x279
[ 1895.058652] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[ 1946.826391] SysRq : Show Blocked State
[ 1946.827225]   task                        PC stack   pid father
[ 1946.828199] cat-iostat      D 0000000000000001     0  2810      1 0x0000=
0000
[ 1946.829318]  ffff88007cd57ce0 0000000000000082 ffff88007cd57fd8 ffff8800=
7c48c800
[ 1946.830754]  0000000000013040 ffff88007c48c800 0000000000000296 00000200=
81065a03
[ 1946.832200]  ffff88011977aa00 ffff88007d5b9d40 ffff88007d5b9cb8 ffff8800=
7cd57cd8
[ 1946.833671] Call Trace:
[ 1946.834244]  [<ffffffff819b09c4>] ? rpc_make_runnable+0x76/0x84
[ 1946.835155]  [<ffffffff819b188a>] ? rpc_execute+0x59/0xa2
[ 1946.836017]  [<ffffffff81065a03>] ? kvm_clock_read+0x27/0x31
[ 1946.836924]  [<ffffffff81065a16>] ? kvm_clock_get_cycles+0x9/0xb
[ 1946.837847]  [<ffffffff8116895d>] ? filemap_fdatawait+0x23/0x23
[ 1946.838758]  [<ffffffff81a0309a>] schedule+0x6f/0x71
[ 1946.839574]  [<ffffffff81a032df>] io_schedule+0x8f/0xd6
[ 1946.840459]  [<ffffffff8116896b>] sleep_on_page+0xe/0x12
[ 1946.841314]  [<ffffffff81a035bd>] __wait_on_bit+0x48/0x7b
[ 1946.842179]  [<ffffffff811687be>] wait_on_page_bit+0x7a/0x7c
[ 1946.843064]  [<ffffffff810fb08c>] ? autoremove_wake_function+0x34/0x34
[ 1946.844047]  [<ffffffff811688cb>] filemap_fdatawait_range+0xc9/0x138
[ 1946.845036]  [<ffffffff811730a5>] ? do_writepages+0x1e/0x2c
[ 1946.845912]  [<ffffffff81169b99>] ? __filemap_fdatawrite_range+0x55/0x57
[ 1946.846900]  [<ffffffff81169c6e>] filemap_write_and_wait_range+0x3f/0x58
[ 1946.847895]  [<ffffffff812dc6b9>] nfs_file_fsync+0x4e/0x10c
[ 1946.848808]  [<ffffffff811ea812>] vfs_fsync_range+0x18/0x20
[ 1946.849714]  [<ffffffff811ea836>] vfs_fsync+0x1c/0x1e
[ 1946.850537]  [<ffffffff812dcadb>] nfs_file_flush+0x6c/0x6f
[ 1946.851411]  [<ffffffff811c279a>] filp_close+0x3c/0x72
[ 1946.852260]  [<ffffffff811dbf29>] __close_fd+0x76/0x8f
[ 1946.853113]  [<ffffffff811c27f3>] SyS_close+0x23/0x4c
[ 1946.853937]  [<ffffffff81a0d269>] system_call_fastpath+0x16/0x1b
[ 1946.855016] cat-proc-vmstat D 0000000000000001     0  2872      1 0x0000=
0000
[ 1946.856171]  ffff88007d6efce0 0000000000000086 ffff88007d6effd8 ffff8800=
7c5dec00
[ 1946.857742]  0000000000013040 ffff88007c5dec00 0000000000000296 00000200=
81065a03
[ 1946.859272]  ffff88011977aa00 ffff88007cf7bd40 ffff88007cf7bcb8 ffff8800=
7d6efcd8
[ 1946.860796] Call Trace:
[ 1946.861399]  [<ffffffff819b09c4>] ? rpc_make_runnable+0x76/0x84
[ 1946.862364]  [<ffffffff819b188a>] ? rpc_execute+0x59/0xa2
[ 1946.863281]  [<ffffffff81065a03>] ? kvm_clock_read+0x27/0x31
[ 1946.864227]  [<ffffffff81065a16>] ? kvm_clock_get_cycles+0x9/0xb
[ 1946.865206]  [<ffffffff8116895d>] ? filemap_fdatawait+0x23/0x23
[ 1946.866174]  [<ffffffff81a0309a>] schedule+0x6f/0x71
[ 1946.867044]  [<ffffffff81a032df>] io_schedule+0x8f/0xd6
[ 1946.867937]  [<ffffffff8116896b>] sleep_on_page+0xe/0x12
[ 1946.868823]  [<ffffffff81a035bd>] __wait_on_bit+0x48/0x7b
[ 1946.869678]  [<ffffffff811687be>] wait_on_page_bit+0x7a/0x7c
[ 1946.870565]  [<ffffffff810fb08c>] ? autoremove_wake_function+0x34/0x34
[ 1946.871539]  [<ffffffff811688cb>] filemap_fdatawait_range+0xc9/0x138
[ 1946.872523]  [<ffffffff811730a5>] ? do_writepages+0x1e/0x2c
[ 1946.873405]  [<ffffffff81169b99>] ? __filemap_fdatawrite_range+0x55/0x57
[ 1946.874403]  [<ffffffff81169c6e>] filemap_write_and_wait_range+0x3f/0x58
[ 1946.875395]  [<ffffffff812dc6b9>] nfs_file_fsync+0x4e/0x10c
[ 1946.876282]  [<ffffffff811ea812>] vfs_fsync_range+0x18/0x20
[ 1946.877172]  [<ffffffff811ea836>] vfs_fsync+0x1c/0x1e
[ 1946.877998]  [<ffffffff812dcadb>] nfs_file_flush+0x6c/0x6f
[ 1946.878863]  [<ffffffff811c279a>] filp_close+0x3c/0x72
[ 1946.879696]  [<ffffffff811dbf29>] __close_fd+0x76/0x8f
[ 1946.880563]  [<ffffffff811c27f3>] SyS_close+0x23/0x4c
[ 1946.881393]  [<ffffffff81a0d269>] system_call_fastpath+0x16/0x1b
[ 1946.882321] cat-slabinfo    D 0000000000000001     0  2904      1 0x0000=
0000
[ 1946.883385]  ffff88007e903ce0 0000000000000086 ffff88007e903fd8 ffff8800=
7d678900
[ 1946.884848]  0000000000013040 ffff88007d678900 0000000000000296 00000200=
81065a03
[ 1946.886290]  ffff88011977aa00 ffff88011b00e940 ffff88011b00e8b8 ffff8800=
7e903cd8
[ 1946.887717] Call Trace:
[ 1946.888302]  [<ffffffff819b09c4>] ? rpc_make_runnable+0x76/0x84
[ 1946.889229]  [<ffffffff819b188a>] ? rpc_execute+0x59/0xa2
[ 1946.890093]  [<ffffffff81065a03>] ? kvm_clock_read+0x27/0x31
[ 1946.890973]  [<ffffffff81065a16>] ? kvm_clock_get_cycles+0x9/0xb
[ 1946.891891]  [<ffffffff8116895d>] ? filemap_fdatawait+0x23/0x23
[ 1946.892831]  [<ffffffff81a0309a>] schedule+0x6f/0x71
[ 1946.893644]  [<ffffffff81a032df>] io_schedule+0x8f/0xd6
[ 1946.894487]  [<ffffffff8116896b>] sleep_on_page+0xe/0x12
[ 1946.895335]  [<ffffffff81a035bd>] __wait_on_bit+0x48/0x7b
[ 1946.896191]  [<ffffffff811687be>] wait_on_page_bit+0x7a/0x7c
[ 1946.897109]  [<ffffffff810fb08c>] ? autoremove_wake_function+0x34/0x34
[ 1946.898078]  [<ffffffff811688cb>] filemap_fdatawait_range+0xc9/0x138
[ 1946.899033]  [<ffffffff811730a5>] ? do_writepages+0x1e/0x2c
[ 1946.899907]  [<ffffffff81169b99>] ? __filemap_fdatawrite_range+0x55/0x57
[ 1946.900929]  [<ffffffff81169c6e>] filemap_write_and_wait_range+0x3f/0x58
[ 1946.901916]  [<ffffffff812dc6b9>] nfs_file_fsync+0x4e/0x10c
[ 1946.902792]  [<ffffffff811ea812>] vfs_fsync_range+0x18/0x20
[ 1946.903669]  [<ffffffff811ea836>] vfs_fsync+0x1c/0x1e
[ 1946.904541]  [<ffffffff812dcadb>] nfs_file_flush+0x6c/0x6f
[ 1946.905420]  [<ffffffff811c279a>] filp_close+0x3c/0x72
[ 1946.906253]  [<ffffffff811dbf29>] __close_fd+0x76/0x8f
[ 1946.907084]  [<ffffffff811c27f3>] SyS_close+0x23/0x4c
[ 1946.907901]  [<ffffffff81a0d269>] system_call_fastpath+0x16/0x1b
[ 1946.908852] kworker/u8:2    D 0000000000000003     0 20893      2 0x0000=
0000
[ 1946.909916] Workqueue: writeback bdi_writeback_workfn (flush-0:21)
[ 1946.910891]  ffff88007ee4bcd8 0000000000000046 ffff88007ee4bfd8 ffff8800=
76c01200
[ 1946.912359]  0000000000013040 ffff880076c01200 ffff88007ee4bc18 ffffffff=
8117158e
[ 1946.913794]  ffff88007ee4bc58 ffffffff811e6663 ffff8800b6ee4a60 ffff8800=
00000007
[ 1946.915234] Call Trace:
[ 1946.915797]  [<ffffffff8117158e>] ? mapping_tagged+0x12/0x14
[ 1946.916715]  [<ffffffff811e6663>] ? __writeback_single_inode+0x99/0x223
[ 1946.917696]  [<ffffffff810facff>] ? wake_up_bit+0x25/0x2a
[ 1946.918552]  [<ffffffff811e70a9>] ? writeback_sb_inodes+0x11d/0x35f
[ 1946.919501]  [<ffffffff81a05b7b>] ? _raw_spin_lock_irqsave+0x25/0x56
[ 1946.920489]  [<ffffffff81a0309a>] schedule+0x6f/0x71
[ 1946.921308]  [<ffffffff811e687b>] inode_sleep_on_writeback+0x8e/0xa3
[ 1946.922267]  [<ffffffff810fb058>] ? __wake_up_sync+0x12/0x12
[ 1946.923155]  [<ffffffff811e7579>] wb_writeback+0x1d7/0x2b7
[ 1946.924046]  [<ffffffff811e7c33>] bdi_writeback_workfn+0x179/0x3a0
[ 1946.929999]  [<ffffffff810dbe27>] process_one_work+0x1f7/0x398
[ 1946.930897]  [<ffffffff810dc4b3>] worker_thread+0x1e8/0x2e2
[ 1946.931768]  [<ffffffff810dc2cb>] ? rescuer_thread+0x2d4/0x2d4
[ 1946.932704]  [<ffffffff810e155c>] kthread+0xdb/0xe3
[ 1946.933511]  [<ffffffff810e1481>] ? kthread_create_on_node+0x16f/0x16f
[ 1946.934485]  [<ffffffff81a0d1bc>] ret_from_fork+0x7c/0xb0
[ 1946.935345]  [<ffffffff810e1481>] ? kthread_create_on_node+0x16f/0x16f
[ 1946.936350] chown           D 0000000000000001     0  8681   2742 0x0000=
0000
[ 1946.937417]  ffff88007ec3fb80 0000000000000086 ffff88007ec3ffd8 ffff8800=
769d5100
[ 1946.938851]  0000000000013040 ffff8800769d5100 ffff88007ec3ffd8 ffff8800=
769d5100
[ 1946.940307]  0000000000013040 ffff8800769d5100 ffff88007f9ef800 ffff8800=
7ec3fb00
[ 1946.941753] Call Trace:
[ 1946.942319]  [<ffffffff81168dde>] ? find_get_pages_tag+0xe6/0x13f
[ 1946.943246]  [<ffffffff81065a03>] ? kvm_clock_read+0x27/0x31
[ 1946.944133]  [<ffffffff81065a16>] ? kvm_clock_get_cycles+0x9/0xb
[ 1946.945088]  [<ffffffff8116895d>] ? filemap_fdatawait+0x23/0x23
[ 1946.946001]  [<ffffffff81a0309a>] schedule+0x6f/0x71
[ 1946.946816]  [<ffffffff81a032df>] io_schedule+0x8f/0xd6
[ 1946.947654]  [<ffffffff8116896b>] sleep_on_page+0xe/0x12
[ 1946.948542]  [<ffffffff81a035bd>] __wait_on_bit+0x48/0x7b
[ 1946.949401]  [<ffffffff811687be>] wait_on_page_bit+0x7a/0x7c
[ 1946.950289]  [<ffffffff810fb08c>] ? autoremove_wake_function+0x34/0x34
[ 1946.951262]  [<ffffffff81174177>] ? pagevec_lookup_tag+0x21/0x29
[ 1946.952184]  [<ffffffff811688cb>] filemap_fdatawait_range+0xc9/0x138
[ 1946.953164]  [<ffffffff811d677c>] ? dput+0x24/0x106
[ 1946.953964]  [<ffffffff8116895b>] filemap_fdatawait+0x21/0x23
[ 1946.954858]  [<ffffffff811e6646>] __writeback_single_inode+0x7c/0x223
[ 1946.955823]  [<ffffffff811e77a7>] writeback_single_inode+0xc2/0x162
[ 1946.956803]  [<ffffffff811e7892>] sync_inode+0x4b/0x52
[ 1946.957636]  [<ffffffff812e6ba6>] nfs_wb_all+0x59/0xcc
[ 1946.958465]  [<ffffffff812def0a>] nfs_setattr+0xb7/0x1ab
[ 1946.959319]  [<ffffffff811dadf6>] notify_change+0x226/0x319
[ 1946.960219]  [<ffffffff811c28f1>] chown_common.isra.15+0xd5/0x12d
[ 1946.961177]  [<ffffffff811ddae7>] ? __mnt_want_write+0x50/0x5f
[ 1946.962081]  [<ffffffff811c3631>] SyS_fchownat+0x84/0xd1
[ 1946.962924]  [<ffffffff812def80>] ? nfs_setattr+0x12d/0x1ab
[ 1946.963796]  [<ffffffff81a0d269>] system_call_fastpath+0x16/0x1b
[ 1946.964748] Sched Debug Version: v0.11, 3.13.0-rc7-00177-g8cb75e0 #1
[ 1946.965699] ktime                                   : 1924404.493918
[ 1946.966652] sched_clk                               : 1946964.746758
[ 1946.967597] cpu_clk                                 : 1946964.746811
[ 1946.968581] jiffies                                 : 4295373398
[ 1946.969490] sched_clock_stable()                    : 1
[ 1946.970331]=20
[ 1946.970794] sysctl_sched
[ 1946.971365]   .sysctl_sched_latency                    : 18.000000
[ 1946.972357]   .sysctl_sched_min_granularity            : 2.250000
[ 1946.973285]   .sysctl_sched_wakeup_granularity         : 3.000000
[ 1946.974218]   .sysctl_sched_child_runs_first           : 0
[ 1946.975094]   .sysctl_sched_features                   : 77435
[ 1946.975999]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
[ 1946.977008]=20
[ 1946.977474] cpu#0, 2693.600 MHz
[ 1946.978109]   .nr_running                    : 4
[ 1946.978885]   .load                          : 3072
[ 1946.979693]   .nr_switches                   : 765906
[ 1946.980550]   .nr_load_updates               : 374234
[ 1946.981376]   .nr_uninterruptible            : -8
[ 1946.982165]   .next_balance                  : 4295.373434
[ 1946.983037]   .curr->pid                     : 692
[ 1946.983827]   .clock                         : 1114424.344232
[ 1946.984749]   .cpu_load[0]                   : 1034
[ 1946.985606]   .cpu_load[1]                   : 1034
[ 1946.986414]   .cpu_load[2]                   : 1034
[ 1946.987222]   .cpu_load[3]                   : 1034
[ 1946.988032]   .cpu_load[4]                   : 1034
[ 1946.988867]=20
[ 1946.988867] cfs_rq[0]:/
[ 1946.989882]   .exec_clock                    : 0.000000
[ 1946.990723]   .MIN_vruntime                  : 546817.053342
[ 1946.991603]   .min_vruntime                  : 546826.053342
[ 1946.992518]   .max_vruntime                  : 546817.053342
[ 1946.993403]   .spread                        : 0.000000
[ 1946.994250]   .spread0                       : 0.000000
[ 1946.995093]   .nr_spread_over                : 0
[ 1946.995873]   .nr_running                    : 3
[ 1946.996685]   .load                          : 3072
[ 1946.997493]   .runnable_load_avg             : 1034
[ 1946.998295]   .blocked_load_avg              : 878
[ 1946.999094]   .tg_load_contrib               : 1912
[ 1946.999896]   .tg_runnable_contrib           : 1015
[ 1947.000729]   .tg_load_avg                   : 2858
[ 1947.001533]   .tg->runnable_avg              : 1018
[ 1947.002337]   .avg->runnable_avg_sum         : 47596
[ 1947.003151]   .avg->runnable_avg_period      : 47596
[ 1947.003960]=20
[ 1947.003960] rt_rq[0]:
[ 1947.004982]   .rt_nr_running                 : 0
[ 1947.005762]   .rt_throttled                  : 0
[ 1947.006544]   .rt_time                       : 0.000000
[ 1947.007384]   .rt_runtime                    : 950.000000
[ 1947.008250]=20
[ 1947.008250] runnable tasks:
[ 1947.008250]             task   PID         tree-key  switches  prio     =
exec-runtime         sum-exec        sum-sleep
[ 1947.008250] ------------------------------------------------------------=
----------------------------------------------
[ 1947.012722]      ksoftirqd/0     3    546817.053342      1860   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.015323]      kworker/0:0     4       595.957584        16   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.017923]     kworker/0:0H     5      3315.432893         5   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.020542]           rcu_bh     8       176.731450         2   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.023101]      migration/0     9         0.000000      3811     0     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.025718]      kworker/0:1   565    546817.053342      1358   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.028298] R        kswapd0   692    546833.227778      4513   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.030870]             ksmd   693      3282.016509         2   125     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.033473]       khugepaged   760      3291.330277         2   139     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.036039]           nfsiod   783      3306.374600         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.038621]          cifsiod   789      3312.394840         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.041218]         xfsalloc   804      3318.413983         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.043809]    xfs_mru_cache   805      3324.433701         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.046401]          xfslogd   806      3333.453420         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.049001]           crypto   821      3342.476809         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.051558]               rc  2515      6716.709449        11   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.054145]         startpar  2525      7039.550253        51   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.056766]             tail  2713      7929.643747        29   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.059357]=20
[ 1947.059823] cpu#1, 2693.600 MHz
[ 1947.060486]   .nr_running                    : 0
[ 1947.061265]   .load                          : 0
[ 1947.062041]   .nr_switches                   : 2071299
[ 1947.062870]   .nr_load_updates               : 295692
[ 1947.063697]   .nr_uninterruptible            : -12
[ 1947.064526]   .next_balance                  : 4295.373423
[ 1947.065396]   .curr->pid                     : 0
[ 1947.066179]   .clock                         : 1947064.297768
[ 1947.067065]   .cpu_load[0]                   : 0
[ 1947.067844]   .cpu_load[1]                   : 0
[ 1947.068654]   .cpu_load[2]                   : 0
[ 1947.069465]   .cpu_load[3]                   : 0
[ 1947.070246]   .cpu_load[4]                   : 0
[ 1947.071028]=20
[ 1947.071028] cfs_rq[1]:/
[ 1947.072034]   .exec_clock                    : 0.000000
[ 1947.072902]   .MIN_vruntime                  : 0.000001
[ 1947.073744]   .min_vruntime                  : 3461796.726853
[ 1947.074634]   .max_vruntime                  : 0.000001
[ 1947.075491]   .spread                        : 0.000000
[ 1947.076366]   .spread0                       : 2914970.673511
[ 1947.077261]   .nr_spread_over                : 0
[ 1947.078040]   .nr_running                    : 0
[ 1947.078813]   .load                          : 0
[ 1947.084691]   .runnable_load_avg             : 0
[ 1947.085473]   .blocked_load_avg              : 0
[ 1947.086254]   .tg_load_contrib               : 0
[ 1947.087031]   .tg_runnable_contrib           : 0
[ 1947.087810]   .tg_load_avg                   : 2858
[ 1947.088642]   .tg->runnable_avg              : 1018
[ 1947.089448]   .avg->runnable_avg_sum         : 0
[ 1947.090233]   .avg->runnable_avg_period      : 47220
[ 1947.091081]=20
[ 1947.091081] rt_rq[1]:
[ 1947.092073]   .rt_nr_running                 : 0
[ 1947.092877]   .rt_throttled                  : 0
[ 1947.093659]   .rt_time                       : 0.000000
[ 1947.094495]   .rt_runtime                    : 950.000000
[ 1947.095352]=20
[ 1947.095352] runnable tasks:
[ 1947.095352]             task   PID         tree-key  switches  prio     =
exec-runtime         sum-exec        sum-sleep
[ 1947.095352] ------------------------------------------------------------=
----------------------------------------------
[ 1947.099775]             init     1   3461788.187633      3499   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.102369]      migration/1    10         0.000000      4693     0     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.104968]      ksoftirqd/1    11   3461787.956534      3055   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.107557]     kworker/1:0H    13   3381215.701077         8   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.110152]          khelper    22         5.023450         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.112750]        kdevtmpfs    23   3303525.423788       269   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.115317]            netns    24        17.354356         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.117925]        writeback   424      3231.438909         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.120596]      kintegrityd   426      3246.495029         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.123238]          kblockd   429      3252.518658         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.125892]          ata_sff   536      3896.943378         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.128488]            khubd   547      3963.681759         2   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.131048]               md   557      4024.025613         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.133635]      edac-poller   560      4042.120198         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.136194]      kworker/1:1   566   3461788.011736      2477   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.138785]  kmpath_handlerd  1165      8600.382991         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.141381]          deferwq  1218      8600.441412         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.143937]            udevd  1347   3461096.810461       393   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.146529]            udevd  1488   3461096.932719       199   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.149127]            udevd  1489   3303463.589650         2   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.151684]      dbus-daemon  2597     11484.195726         1   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.154305]             sshd  2630     11534.840902         1   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.156892]       cat-iostat  2810   3461197.348062         5   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.159448]  cat-proc-vmstat  2872   3461235.015432         9   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.162038]     cat-slabinfo  2904   3461234.974666        12   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.164630]      kworker/1:2  3223     13502.138828         3   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.167195]     kworker/1:1H 30876   3381224.701950        11   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.169784]           wakeup  8655   3461145.085460         1   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.172374]            chown  8681   3461245.697171        14   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.174924]=20
[ 1947.175393] cpu#2, 2693.600 MHz
[ 1947.176026]   .nr_running                    : 1
[ 1947.176827]   .load                          : 1024
[ 1947.177635]   .nr_switches                   : 1963802
[ 1947.178467]   .nr_load_updates               : 352137
[ 1947.179321]   .nr_uninterruptible            : 4
[ 1947.180105]   .next_balance                  : 4295.373363
[ 1947.181002]   .curr->pid                     : 2751
[ 1947.181807]   .clock                         : 1946826.277305
[ 1947.182704]   .cpu_load[0]                   : 0
[ 1947.183487]   .cpu_load[1]                   : 0
[ 1947.184282]   .cpu_load[2]                   : 0
[ 1947.185078]   .cpu_load[3]                   : 0
[ 1947.185859]   .cpu_load[4]                   : 0
[ 1947.186640]=20
[ 1947.186640] cfs_rq[2]:/
[ 1947.187653]   .exec_clock                    : 0.000000
[ 1947.188523]   .MIN_vruntime                  : 0.000001
[ 1947.189358]   .min_vruntime                  : 2770211.990938
[ 1947.190255]   .max_vruntime                  : 0.000001
[ 1947.191096]   .spread                        : 0.000000
[ 1947.191927]   .spread0                       : 2223385.937596
[ 1947.192875]   .nr_spread_over                : 0
[ 1947.193662]   .nr_running                    : 1
[ 1947.194442]   .load                          : 1024
[ 1947.195248]   .runnable_load_avg             : 0
[ 1947.196027]   .blocked_load_avg              : 945
[ 1947.196847]   .tg_load_contrib               : 945
[ 1947.197646]   .tg_runnable_contrib           : 2
[ 1947.198427]   .tg_load_avg                   : 2858
[ 1947.199235]   .tg->runnable_avg              : 1018
[ 1947.200043]   .avg->runnable_avg_sum         : 118
[ 1947.200866]   .avg->runnable_avg_period      : 47796
[ 1947.201685]=20
[ 1947.201685] rt_rq[2]:
[ 1947.202680]   .rt_nr_running                 : 0
[ 1947.203460]   .rt_throttled                  : 0
[ 1947.204249]   .rt_time                       : 0.000000
[ 1947.205112]   .rt_runtime                    : 950.000000
[ 1947.205969]=20
[ 1947.205969] runnable tasks:
[ 1947.205969]             task   PID         tree-key  switches  prio     =
exec-runtime         sum-exec        sum-sleep
[ 1947.205969] ------------------------------------------------------------=
----------------------------------------------
[ 1947.210389]         kthreadd     2   2769811.994126       140   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.213000]      migration/2    14         0.000000      2301     0     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.215560]      ksoftirqd/2    15   2770202.191748      2997   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.218140]      kworker/2:0    16       220.874700        15   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.220733]     kworker/2:0H    17       248.917854         6   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.223292]           bioset   427         3.466278         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.225910]      kworker/2:1   567   2770211.990938      2344   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.228504]           rpciod   661       229.838759         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.231083]         iscsi_eh   997       952.774866         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.238708]        scsi_eh_1  1033      1352.052052         9   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.241291]        kpsmoused  1144      1393.433326         1   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.243846]          raid5wq  1155      1402.483245         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.246436]           bcache  1156      1415.111715         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.249060]     bch_btree_io  1157      1424.153545         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.251622]   dm_bufio_cache  1162      1433.172026         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.254229]          kmpathd  1164      1442.209731         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.256911]          run-lkp  2742   2769812.552025        34   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.260000] R        run-lkp  2751   2770202.990938        20   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.263451]=20
[ 1947.263960] cpu#3, 2693.600 MHz
[ 1947.264791]   .nr_running                    : 0
[ 1947.265827]   .load                          : 0
[ 1947.266750]   .nr_switches                   : 2270397
[ 1947.268091]   .nr_load_updates               : 446317
[ 1947.269328]   .nr_uninterruptible            : 21
[ 1947.270219]   .next_balance                  : 4295.373474
[ 1947.271353]   .curr->pid                     : 0
[ 1947.272196]   .clock                         : 1947268.283033
[ 1947.273159]   .cpu_load[0]                   : 0
[ 1947.273998]   .cpu_load[1]                   : 0
[ 1947.274822]   .cpu_load[2]                   : 0
[ 1947.275660]   .cpu_load[3]                   : 0
[ 1947.276497]   .cpu_load[4]                   : 0
[ 1947.277333]=20
[ 1947.277333] cfs_rq[3]:/
[ 1947.278405]   .exec_clock                    : 0.000000
[ 1947.279301]   .MIN_vruntime                  : 0.000001
[ 1947.280199]   .min_vruntime                  : 3463289.257294
[ 1947.281147]   .max_vruntime                  : 0.000001
[ 1947.282045]   .spread                        : 0.000000
[ 1947.282935]   .spread0                       : 2916463.203952
[ 1947.283890]   .nr_spread_over                : 0
[ 1947.284722]   .nr_running                    : 0
[ 1947.285567]   .load                          : 0
[ 1947.286403]   .runnable_load_avg             : 0
[ 1947.287240]   .blocked_load_avg              : 1
[ 1947.288073]   .tg_load_contrib               : 1
[ 1947.288894]   .tg_runnable_contrib           : 1
[ 1947.289723]   .tg_load_avg                   : 2858
[ 1947.290576]   .tg->runnable_avg              : 1018
[ 1947.291434]   .avg->runnable_avg_sum         : 62
[ 1947.292273]   .avg->runnable_avg_period      : 47130
[ 1947.293139]=20
[ 1947.293139] rt_rq[3]:
[ 1947.294184]   .rt_nr_running                 : 0
[ 1947.295007]   .rt_throttled                  : 0
[ 1947.295832]   .rt_time                       : 0.000000
[ 1947.296724]   .rt_runtime                    : 950.000000
[ 1947.297630]=20
[ 1947.297630] runnable tasks:
[ 1947.297630]             task   PID         tree-key  switches  prio     =
exec-runtime         sum-exec        sum-sleep
[ 1947.297630] ------------------------------------------------------------=
----------------------------------------------
[ 1947.302268]        rcu_sched     7   3463289.276879    478116   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.304989]      migration/3    18         0.000000      5558     0     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.307710]      ksoftirqd/3    19   3460568.901717      3137   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.310372]     kworker/3:0H    21   3400991.651541         9   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.312977]     kworker/u8:1    25   3462875.882373       334   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.315542]      kworker/3:1   568   3463278.963725      2320   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.318135]    fsnotify_mark   761   3462721.358237        25   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.320743]           bioset   814        17.078761         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.323328]         pencrypt   843       216.312779         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.325953]         pdecrypt   845       225.342388         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.328539]         kthrotld   879       505.690654         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.331106]        scsi_eh_0  1030       521.338037         4   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.333692]      kworker/3:2  1138      8392.968726        10   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.336273]          rpcbind  2390   3463247.916529        84   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.338848]        rpc.statd  2418      5726.483457        17   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.341466]          nfsroot  2692      6645.119625        55   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.344049]           wakeup  2782      6782.671799         1   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.346629]     kworker/u8:2 20893   3462858.393910       281   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.349217]     kworker/3:1H 30893   3401000.651372         6   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.351771]     kworker/u8:0  8682   3463272.797159        80   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1947.354353]=20
[ 1947.355272] SysRq : Emergency Sync
[ 1957.357219] SysRq : Resetting

Elapsed time: 1955
numactl --preferred=3D0 --physcpubind=3D16-19 qemu-system-x86_64 -cpu kvm64=
 -enable-kvm -kernel /kernel/x86_64-lkp/8cb75e0c4ec9786b81439761eac1d18d4a9=
31af3/vmlinuz-3.13.0-rc7-00177-g8cb75e0 -append 'user=3Dlkp job=3D/lkp/sche=
duled/vpx-4/bisect_ltp-syscalls-x86_64-lkp-8cb75e0c4ec9786b81439761eac1d18d=
4a931af3-0.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/8cb75e0c4ec97=
86b81439761eac1d18d4a931af3/vmlinuz-3.13.0-rc7-00177-g8cb75e0 kconfig=3Dx86=
_64-lkp commit=3D8cb75e0c4ec9786b81439761eac1d18d4a931af3 bm_initrd=3D/lkp/=
benchmarks/ltp.cgz modules_initrd=3D/kernel/x86_64-lkp/8cb75e0c4ec9786b8143=
9761eac1d18d4a931af3/modules.cgz max_uptime=3D1725 RESULT_ROOT=3D/lkp/resul=
t/vpx/micro/ltp/syscalls/x86_64-lkp/8cb75e0c4ec9786b81439761eac1d18d4a931af=
3/0 initrd=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::=
vpx-4::dhcp oops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysr=
q_always_enabled panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic load_=
ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3D=
normal'  -initrd /fs/sde1/initrd-vpx-4 -m 4G -smp 4 -net nic,vlan=3D1,model=
=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::9776-:22 -boot order=3Dnc -no-re=
boot -watchdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs/sde1/disk0-=
vpx-4,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sde1/disk1-vpx-4,media=3Dd=
isk,if=3Dvirtio -drive file=3D/fs/sde1/disk2-vpx-4,media=3Ddisk,if=3Dvirtio=
 -drive file=3D/fs/sde1/disk3-vpx-4,media=3Ddisk,if=3Dvirtio -drive file=3D=
/fs/sde1/disk4-vpx-4,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sde1/disk5-=
vpx-4,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-vpx-4 -serial fi=
le:/dev/shm/kboot/serial-vpx-4 -daemonize -display none -monitor null=20

--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg-xfstests
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.13.0-rc8-wl-05610-gb524b38-dirty (kbuild@ant=
) (gcc version 4.8.1 (Debian 4.8.1-8) ) #1 SMP Tue Jan 14 23:41:25 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vpx-4/cyclic_x=
fstests-generic-4HDD-ext4-generic-127-HEAD.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D=
/kernel/x86_64-lkp/b524b386c48571e82480bef4f3af38275381aa71/vmlinuz-3.13.0-=
rc8-wl-05610-gb524b38-dirty kconfig=3Dx86_64-lkp commit=3Db524b386c48571e82=
480bef4f3af38275381aa71 bm_initrd=3D/lkp/benchmarks/xfstests.cgz modules_in=
itrd=3D/kernel/x86_64-lkp/b524b386c48571e82480bef4f3af38275381aa71/modules.=
cgz max_uptime=3D836 RESULT_ROOT=3D/lkp/result/vpx/micro/xfstests/4HDD-ext4=
-generic-127/x86_64-lkp/b524b386c48571e82480bef4f3af38275381aa71/0 initrd=
=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::vpx-4::dhc=
p oops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_e=
nabled panic=3D10 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,11520=
0 console=3Dtty0 vga=3Dnormal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dfffdfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dfffe000-0x00000000dfffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x120000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] e820: last_pfn =3D 0xdfffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fda90-0x000fda9f] mapped at =
[ffff8800000fda90]
[    0.000000]   mpc: fdaa0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0265d000, 0x0265dfff] PGTABLE
[    0.000000] BRK [0x0265e000, 0x0265efff] PGTABLE
[    0.000000] BRK [0x0265f000, 0x0265ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11fe00000-0x11fffffff]
[    0.000000]  [mem 0x11fe00000-0x11fffffff] page 2M
[    0.000000] BRK [0x02660000, 0x02660fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11fdfffff]
[    0.000000]  [mem 0x11c000000-0x11fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdfffdfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xdfdfffff] page 2M
[    0.000000]  [mem 0xdfe00000-0xdfffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x73cdf000-0x7fffffff]
[    0.000000] ACPI: RSDP 00000000000fd880 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 00000000dfffe380 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 00000000dfffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 00000000dfffe3c0 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 00000000dfffff40 000040
[    0.000000] ACPI: SSDT 00000000dffff6e0 000858 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 00000000dffff5b0 000090 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 00000000dffff570 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x11fffffff]
[    0.000000]   NODE_DATA [mem 0x11fff7000-0x11fffbfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 1:1ffef001, boot clock
[   17.615259]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff88011b60000=
0-ffff88011f5fffff] on node 0
[   17.616130] Zone ranges:
[   17.616366]   DMA      [mem 0x00001000-0x00ffffff]
[   17.616801]   DMA32    [mem 0x01000000-0xffffffff]
[   17.617246]   Normal   [mem 0x100000000-0x11fffffff]
[   17.617698] Movable zone start for each node
[   17.618085] Early memory node ranges
[   17.618413]   node   0: [mem 0x00001000-0x0009efff]
[   17.618855]   node   0: [mem 0x00100000-0xdfffdfff]
[   17.619301]   node   0: [mem 0x100000000-0x11fffffff]
[   17.619760] On node 0 totalpages: 1048476
[   17.620124]   DMA zone: 64 pages used for memmap
[   17.620543]   DMA zone: 21 pages reserved
[   17.620907]   DMA zone: 3998 pages, LIFO batch:0
[   17.621443]   DMA32 zone: 14272 pages used for memmap
[   17.621906]   DMA32 zone: 913406 pages, LIFO batch:31
[   17.639543]   Normal zone: 2048 pages used for memmap
[   17.640024]   Normal zone: 131072 pages, LIFO batch:31
[   17.643377] ACPI: PM-Timer IO Port: 0xb008
[   17.643755] ACPI: Local APIC address 0xfee00000
[   17.644172] mapped APIC to ffffffffff5f3000 (        fee00000)
[   17.644701] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[   17.645233] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[   17.645765] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[   17.646295] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[   17.646820] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[   17.647343] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[   17.647938] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[   17.648563] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[   17.649137] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[   17.649797] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[   17.650400] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[   17.651053] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[   17.651653] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[   17.652307] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[   17.652922] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[   17.653572] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[   17.654184] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[   17.654835] ACPI: IRQ0 used by override.
[   17.655197] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[   17.655857] ACPI: IRQ2 used by override.
[   17.656212] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[   17.656864] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[   17.657521] ACPI: IRQ5 used by override.
[   17.657877] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[   17.658532] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[   17.659187] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[   17.659842] ACPI: IRQ9 used by override.
[   17.660202] ACPI: IRQ10 used by override.
[   17.660567] ACPI: IRQ11 used by override.
[   17.660927] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[   17.661578] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[   17.662233] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[   17.662880] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[   17.663538] Using ACPI (MADT) for SMP configuration information
[   17.664074] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[   17.664544] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[   17.664996] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[   17.665488] nr_irqs_gsi: 40
[   17.665761] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[   17.666351] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[   17.666934] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[   17.667520] PM: Registered nosave memory: [mem 0xdfffe000-0xdfffffff]
[   17.668099] PM: Registered nosave memory: [mem 0xe0000000-0xfeffbfff]
[   17.668689] PM: Registered nosave memory: [mem 0xfeffc000-0xfeffffff]
[   17.669274] PM: Registered nosave memory: [mem 0xff000000-0xfffbffff]
[   17.669858] PM: Registered nosave memory: [mem 0xfffc0000-0xffffffff]
[   17.670441] e820: [mem 0xe0000000-0xfeffbfff] available for PCI devices
[   17.671037] Booting paravirtualized kernel on KVM
[   17.671475] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 n=
r_node_ids:1
[   17.672480] PERCPU: Embedded 27 pages/cpu @ffff88011fc00000 s81216 r8192=
 d21184 u524288
[   17.673223] pcpu-alloc: s81216 r8192 d21184 u524288 alloc=3D1*2097152
[   17.673788] pcpu-alloc: [0] 0 1 2 3=20
[   17.674129] kvm-clock: cpu 0, msr 1:1ffef001, primary cpu clock
[   17.674703] KVM setup async PF for cpu 0
[   17.675062] kvm-stealtime: cpu 0, msr 11fc0d040
[   17.675489] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 1032071
[   17.676235] Policy zone: Normal
[   17.676527] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vpx-4/c=
yclic_xfstests-generic-4HDD-ext4-generic-127-HEAD.yaml ARCH=3Dx86_64 BOOT_I=
MAGE=3D/kernel/x86_64-lkp/b524b386c48571e82480bef4f3af38275381aa71/vmlinuz-=
3.13.0-rc8-wl-05610-gb524b38-dirty kconfig=3Dx86_64-lkp commit=3Db524b386c4=
8571e82480bef4f3af38275381aa71 bm_initrd=3D/lkp/benchmarks/xfstests.cgz mod=
ules_initrd=3D/kernel/x86_64-lkp/b524b386c48571e82480bef4f3af38275381aa71/m=
odules.cgz max_uptime=3D836 RESULT_ROOT=3D/lkp/result/vpx/micro/xfstests/4H=
DD-ext4-generic-127/x86_64-lkp/b524b386c48571e82480bef4f3af38275381aa71/0 i=
nitrd=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::vpx-4=
::dhcp oops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_alw=
ays_enabled panic=3D10 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,=
115200 console=3Dtty0 vga=3Dnormal
[   17.683518] sysrq: sysrq always enabled.
[   17.683992] PID hash table entries: 4096 (order: 3, 32768 bytes)
[   17.727154] Checking aperture...
[   17.772639] No AGP bridge found
[   17.784725] Memory: 3838744K/4193904K available (10387K kernel code, 123=
9K rwdata, 4156K rodata, 1428K init, 1744K bss, 355160K reserved)
[   17.785943] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4, N=
odes=3D1
[   17.786563] Hierarchical RCU implementation.
[   17.786940]=20
[   17.787490]=20
[   17.788040] NR_IRQS:33024 nr_irqs:712 16
[   17.803557] Console: colour VGA+ 80x25
[   17.803894] console [tty0] enabled
[   17.804317] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.13.0-rc8-wl-05610-gb524b38-dirty (kbuild@ant=
) (gcc version 4.8.1 (Debian 4.8.1-8) ) #1 SMP Tue Jan 14 23:41:25 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/vpx-4/cyclic_x=
fstests-generic-4HDD-ext4-generic-127-HEAD.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D=
/kernel/x86_64-lkp/b524b386c48571e82480bef4f3af38275381aa71/vmlinuz-3.13.0-=
rc8-wl-05610-gb524b38-dirty kconfig=3Dx86_64-lkp commit=3Db524b386c48571e82=
480bef4f3af38275381aa71 bm_initrd=3D/lkp/benchmarks/xfstests.cgz modules_in=
itrd=3D/kernel/x86_64-lkp/b524b386c48571e82480bef4f3af38275381aa71/modules.=
cgz max_uptime=3D836 RESULT_ROOT=3D/lkp/result/vpx/micro/xfstests/4HDD-ext4=
-generic-127/x86_64-lkp/b524b386c48571e82480bef4f3af38275381aa71/0 initrd=
=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::vpx-4::dhc=
p oops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_always_e=
nabled panic=3D10 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,11520=
0 console=3Dtty0 vga=3Dnormal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dfffdfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dfffe000-0x00000000dfffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x120000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] e820: last_pfn =3D 0xdfffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fda90-0x000fda9f] mapped at =
[ffff8800000fda90]
[    0.000000]   mpc: fdaa0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0265d000, 0x0265dfff] PGTABLE
[    0.000000] BRK [0x0265e000, 0x0265efff] PGTABLE
[    0.000000] BRK [0x0265f000, 0x0265ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11fe00000-0x11fffffff]
[    0.000000]  [mem 0x11fe00000-0x11fffffff] page 2M
[    0.000000] BRK [0x02660000, 0x02660fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11fdfffff]
[    0.000000]  [mem 0x11c000000-0x11fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdfffdfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xdfdfffff] page 2M
[    0.000000]  [mem 0xdfe00000-0xdfffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x73cdf000-0x7fffffff]
[    0.000000] ACPI: RSDP 00000000000fd880 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 00000000dfffe380 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 00000000dfffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 00000000dfffe3c0 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 00000000dfffff40 000040
[    0.000000] ACPI: SSDT 00000000dffff6e0 000858 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 00000000dffff5b0 000090 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 00000000dffff570 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x11fffffff]
[    0.000000]   NODE_DATA [mem 0x11fff7000-0x11fffbfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 1:1ffef001, boot clock
[   17.615259]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff88011b60000=
0-ffff88011f5fffff] on node 0
[   17.616130] Zone ranges:
[   17.616366]   DMA      [mem 0x00001000-0x00ffffff]
[   17.616801]   DMA32    [mem 0x01000000-0xffffffff]
[   17.617246]   Normal   [mem 0x100000000-0x11fffffff]
[   17.617698] Movable zone start for each node
[   17.618085] Early memory node ranges
[   17.618413]   node   0: [mem 0x00001000-0x0009efff]
[   17.618855]   node   0: [mem 0x00100000-0xdfffdfff]
[   17.619301]   node   0: [mem 0x100000000-0x11fffffff]
[   17.619760] On node 0 totalpages: 1048476
[   17.620124]   DMA zone: 64 pages used for memmap
[   17.620543]   DMA zone: 21 pages reserved
[   17.620907]   DMA zone: 3998 pages, LIFO batch:0
[   17.621443]   DMA32 zone: 14272 pages used for memmap
[   17.621906]   DMA32 zone: 913406 pages, LIFO batch:31
[   17.639543]   Normal zone: 2048 pages used for memmap
[   17.640024]   Normal zone: 131072 pages, LIFO batch:31
[   17.643377] ACPI: PM-Timer IO Port: 0xb008
[   17.643755] ACPI: Local APIC address 0xfee00000
[   17.644172] mapped APIC to ffffffffff5f3000 (        fee00000)
[   17.644701] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[   17.645233] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[   17.645765] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[   17.646295] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[   17.646820] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[   17.647343] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[   17.647938] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[   17.648563] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[   17.649137] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[   17.649797] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[   17.650400] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[   17.651053] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[   17.651653] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[   17.652307] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[   17.652922] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[   17.653572] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[   17.654184] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[   17.654835] ACPI: IRQ0 used by override.
[   17.655197] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[   17.655857] ACPI: IRQ2 used by override.
[   17.656212] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[   17.656864] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[   17.657521] ACPI: IRQ5 used by override.
[   17.657877] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[   17.658532] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[   17.659187] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[   17.659842] ACPI: IRQ9 used by override.
[   17.660202] ACPI: IRQ10 used by override.
[   17.660567] ACPI: IRQ11 used by override.
[   17.660927] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[   17.661578] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[   17.662233] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[   17.662880] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[   17.663538] Using ACPI (MADT) for SMP configuration information
[   17.664074] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[   17.664544] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[   17.664996] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[   17.665488] nr_irqs_gsi: 40
[   17.665761] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[   17.666351] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[   17.666934] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[   17.667520] PM: Registered nosave memory: [mem 0xdfffe000-0xdfffffff]
[   17.668099] PM: Registered nosave memory: [mem 0xe0000000-0xfeffbfff]
[   17.668689] PM: Registered nosave memory: [mem 0xfeffc000-0xfeffffff]
[   17.669274] PM: Registered nosave memory: [mem 0xff000000-0xfffbffff]
[   17.669858] PM: Registered nosave memory: [mem 0xfffc0000-0xffffffff]
[   17.670441] e820: [mem 0xe0000000-0xfeffbfff] available for PCI devices
[   17.671037] Booting paravirtualized kernel on KVM
[   17.671475] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 n=
r_node_ids:1
[   17.672480] PERCPU: Embedded 27 pages/cpu @ffff88011fc00000 s81216 r8192=
 d21184 u524288
[   17.673223] pcpu-alloc: s81216 r8192 d21184 u524288 alloc=3D1*2097152
[   17.673788] pcpu-alloc: [0] 0 1 2 3=20
[   17.674129] kvm-clock: cpu 0, msr 1:1ffef001, primary cpu clock
[   17.674703] KVM setup async PF for cpu 0
[   17.675062] kvm-stealtime: cpu 0, msr 11fc0d040
[   17.675489] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 1032071
[   17.676235] Policy zone: Normal
[   17.676527] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/vpx-4/c=
yclic_xfstests-generic-4HDD-ext4-generic-127-HEAD.yaml ARCH=3Dx86_64 BOOT_I=
MAGE=3D/kernel/x86_64-lkp/b524b386c48571e82480bef4f3af38275381aa71/vmlinuz-=
3.13.0-rc8-wl-05610-gb524b38-dirty kconfig=3Dx86_64-lkp commit=3Db524b386c4=
8571e82480bef4f3af38275381aa71 bm_initrd=3D/lkp/benchmarks/xfstests.cgz mod=
ules_initrd=3D/kernel/x86_64-lkp/b524b386c48571e82480bef4f3af38275381aa71/m=
odules.cgz max_uptime=3D836 RESULT_ROOT=3D/lkp/result/vpx/micro/xfstests/4H=
DD-ext4-generic-127/x86_64-lkp/b524b386c48571e82480bef4f3af38275381aa71/0 i=
nitrd=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::vpx-4=
::dhcp oops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddebug sysrq_alw=
ays_enabled panic=3D10 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,=
115200 console=3Dtty0 vga=3Dnormal
[   17.683518] sysrq: sysrq always enabled.
[   17.683992] PID hash table entries: 4096 (order: 3, 32768 bytes)
[   17.727154] Checking aperture...
[   17.772639] No AGP bridge found
[   17.784725] Memory: 3838744K/4193904K available (10387K kernel code, 123=
9K rwdata, 4156K rodata, 1428K init, 1744K bss, 355160K reserved)
[   17.785943] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4, N=
odes=3D1
[   17.786563] Hierarchical RCU implementation.
[   17.786940]=20
[   17.787490]=20
[   17.788040] NR_IRQS:33024 nr_irqs:712 16
[   17.803557] Console: colour VGA+ 80x25
[   17.803894] console [tty0] enabled
[   17.804317] bootconsole [earlyser0] disabled
[   17.901070] console [ttyS0] enabled
[   17.912102] allocated 16777216 bytes of page_cgroup
[   17.912733] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[   17.913941] hpet clockevent registered
[   17.914517] tsc: Detected 2693.528 MHz processor
[   17.915102] Calibrating delay loop (skipped) preset value.. 5387.05 Bogo=
MIPS (lpj=3D10774112)
[   17.916178] pid_max: default: 32768 minimum: 301
[   17.917029] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[   17.921609] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[   17.924275] Mount-cache hash table entries: 256
[   17.925494] Initializing cgroup subsys memory
[   17.926422] Initializing cgroup subsys devices
[   17.927319] Initializing cgroup subsys freezer
[   17.928214] Initializing cgroup subsys blkio
[   17.929084] Initializing cgroup subsys perf_event
[   17.930050] Initializing cgroup subsys hugetlb
[   17.931014] mce: CPU supports 10 MCE banks
[   17.931917] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[   17.931917] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[   17.931917] tlb_flushall_shift: 6
[   17.934629] Freeing SMP alternatives memory: 44K (ffffffff8249c000 - fff=
fffff824a7000)
[   17.941061] ACPI: Core revision 20131115
[   17.942612] ACPI: All ACPI Tables successfully acquired
[   17.943751] ftrace: allocating 39746 entries in 156 pages
[   17.988536] Getting VERSION: 50014
[   17.989331] Getting VERSION: 50014
[   17.990147] Getting ID: 0
[   17.990843] Getting ID: ff000000
[   17.991615] Getting LVT0: 8700
[   17.992359] Getting LVT1: 8400
[   17.993145] enabled ExtINT on CPU#0
[   17.994627] ENABLING IO-APIC IRQs
[   17.995397] init IO_APIC IRQs
[   17.996120]  apic 0 pin 0 not connected
[   17.996947] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[   17.998586] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[   18.000221] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[   18.001833] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[   18.003460] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[   18.005059] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[   18.006711] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[   18.008311] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[   18.009901] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[   18.011531] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[   18.013144] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[   18.014794] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[   18.016428] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[   18.018084] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[   18.019696] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[   18.021310]  apic 0 pin 16 not connected
[   18.022174]  apic 0 pin 17 not connected
[   18.022995]  apic 0 pin 18 not connected
[   18.023819]  apic 0 pin 19 not connected
[   18.024640]  apic 0 pin 20 not connected
[   18.025461]  apic 0 pin 21 not connected
[   18.026324]  apic 0 pin 22 not connected
[   18.027149]  apic 0 pin 23 not connected
[   18.028107] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[   18.029295] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[   18.031457] Using local APIC timer interrupts.
[   18.031457] calibrating APIC timer ...
[   18.137982] ... lapic delta =3D 6249196
[   18.138863] ... PM-Timer delta =3D 357876
[   18.139784] ... PM-Timer result ok
[   18.140647] ..... delta 6249196
[   18.141469] ..... mult: 268400924
[   18.142377] ..... calibration result: 3999485
[   18.143382] ..... CPU clock speed is 2692.3944 MHz.
[   18.144456] ..... host bus clock speed is 999.3485 MHz.
[   18.145623] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[   18.149363] x86: Booting SMP configuration:
[   18.150361] .... node  #0, CPUs:      #1
[   18.161143] kvm-clock: cpu 1, msr 1:1ffef041, secondary cpu clock
[   18.162111] masked ExtINT on CPU#1
[   18.182612] KVM setup async PF for cpu 1
 #2
[   18.183962] kvm-stealtime: cpu 1, msr 11fc8d040
[   18.192792] kvm-clock: cpu 2, msr 1:1ffef081, secondary cpu clock
[   18.193763] masked ExtINT on CPU#2
[   18.214261] KVM setup async PF for cpu 2
 #3
[   18.215289] kvm-stealtime: cpu 2, msr 11fd0d040
[   18.224396] kvm-clock: cpu 3, msr 1:1ffef0c1, secondary cpu clock
[   18.225392] masked ExtINT on CPU#3

[   18.245889] x86: Booted up 1 node, 4 CPUs
[   18.245895] KVM setup async PF for cpu 3
[   18.245899] kvm-stealtime: cpu 3, msr 11fd8d040
[   18.248984] smpboot: Total of 4 processors activated (21548.22 BogoMIPS)
[   18.251036] devtmpfs: initialized
[   18.256046] xor: measuring software checksum speed
[   18.293590]    prefetch64-sse:   186.000 MB/sec
[   18.333584]    generic_sse:   184.000 MB/sec
[   18.334435] xor: using function: prefetch64-sse (186.000 MB/sec)
[   18.335470] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[   18.336752] NET: Registered protocol family 16
[   18.338768] cpuidle: using governor ladder
[   18.339624] cpuidle: using governor menu
[   18.340824] ACPI: bus type PCI registered
[   18.341674] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[   18.342983] PCI: Using configuration type 1 for base access
[   18.367977] bio: create slab <bio-0> at 0
[   18.433561] raid6: sse2x1    8126 MB/s
[   18.501555] raid6: sse2x2   10191 MB/s
[   18.569537] raid6: sse2x4   11831 MB/s
[   18.570344] raid6: using algorithm sse2x4 (11831 MB/s)
[   18.571289] raid6: using intx1 recovery algorithm
[   18.572248] ACPI: Added _OSI(Module Device)
[   18.573110] ACPI: Added _OSI(Processor Device)
[   18.573999] ACPI: Added _OSI(3.0 _SCP Extensions)
[   18.574929] ACPI: Added _OSI(Processor Aggregator Device)
[   18.577554] ACPI: Interpreter enabled
[   18.578360] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20131115/hwxface-580)
[   18.580223] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20131115/hwxface-580)
[   18.582081] ACPI: (supports S0 S3 S4 S5)
[   18.582906] ACPI: Using IOAPIC for interrupt routing
[   18.583950] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[   18.585971] ACPI: No dock devices found.
[   18.592491] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[   18.593609] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MS=
I]
[   18.594794] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[   18.595991] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[   18.598372] acpiphp: Slot [3] registered
[   18.599276] acpiphp: Slot [4] registered
[   18.600172] acpiphp: Slot [5] registered
[   18.601068] acpiphp: Slot [6] registered
[   18.602015] acpiphp: Slot [7] registered
[   18.602936] acpiphp: Slot [8] registered
[   18.603835] acpiphp: Slot [9] registered
[   18.604733] acpiphp: Slot [10] registered
[   18.605649] acpiphp: Slot [11] registered
[   18.606601] acpiphp: Slot [12] registered
[   18.607514] acpiphp: Slot [13] registered
[   18.608422] acpiphp: Slot [14] registered
[   18.609327] acpiphp: Slot [15] registered
[   18.610304] acpiphp: Slot [16] registered
[   18.611211] acpiphp: Slot [17] registered
[   18.612114] acpiphp: Slot [18] registered
[   18.613014] acpiphp: Slot [19] registered
[   18.613977] acpiphp: Slot [20] registered
[   18.614906] acpiphp: Slot [21] registered
[   18.615815] acpiphp: Slot [22] registered
[   18.616716] acpiphp: Slot [23] registered
[   18.617642] acpiphp: Slot [24] registered
[   18.618570] acpiphp: Slot [25] registered
[   18.619483] acpiphp: Slot [26] registered
[   18.620392] acpiphp: Slot [27] registered
[   18.621301] acpiphp: Slot [28] registered
[   18.622219] acpiphp: Slot [29] registered
[   18.623125] acpiphp: Slot [30] registered
[   18.624023] acpiphp: Slot [31] registered
[   18.624866] PCI host bridge to bus 0000:00
[   18.625723] pci_bus 0000:00: root bus resource [bus 00-ff]
[   18.626734] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[   18.627788] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[   18.628837] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[   18.629976] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebffff=
f]
[   18.631134] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[   18.632525] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[   18.634064] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[   18.637852] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[   18.640078] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[   18.641434] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[   18.642987] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[   18.644381] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[   18.652365] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[   18.654788] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[   18.662043] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[   18.663837] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[   18.665908] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[   18.667961] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[   18.679249] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[   18.680661] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[   18.682802] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[   18.684786] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[   18.691177] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[   18.693252] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[   18.695264] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[   18.701685] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[   18.703777] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[   18.705753] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[   18.712218] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[   18.714353] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[   18.716372] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[   18.722830] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[   18.724896] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[   18.726899] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[   18.733218] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[   18.735309] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[   18.737292] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[   18.743603] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[   18.745180] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[   18.749995] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[   18.751429] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[   18.752839] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[   18.754283] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[   18.755666] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[   18.757331] ACPI: Enabled 16 GPEs in block 00 to 0F
[   18.758410] ACPI: \_SB_.PCI0: notify handler is installed
[   18.759403] Found 1 acpi root devices
[   18.760822] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[   18.762447] vgaarb: loaded
[   18.763132] vgaarb: bridge control possible 0000:00:02.0
[   18.764473] SCSI subsystem initialized
[   18.765738] libata version 3.00 loaded.
[   18.766949] ACPI: bus type USB registered
[   18.767947] usbcore: registered new interface driver usbfs
[   18.769032] usbcore: registered new interface driver hub
[   18.770188] usbcore: registered new device driver usb
[   18.771386] pps_core: LinuxPPS API ver. 1 registered
[   18.772333] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[   18.774138] PTP clock support registered
[   18.775292] EDAC MC: Ver: 3.0.0
[   18.776431] PCI: Using ACPI for IRQ routing
[   18.777288] PCI: pci_cache_line_size set to 64 bytes
[   18.778411] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[   18.779459] e820: reserve RAM buffer [mem 0xdfffe000-0xdfffffff]
[   18.781409] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[   18.782670] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[   18.783861] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[   18.790772] Switched to clocksource kvm-clock
[   18.806011] pnp: PnP ACPI init
[   18.806797] ACPI: bus type PNP registered
[   18.807677] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:15)
[   18.809420] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[   18.810552] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:15)
[   18.812301] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[   18.813428] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:15)
[   18.815178] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[   18.816317] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:15)
[   18.818023] pnp 00:03: [dma 2]
[   18.818858] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[   18.820008] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:15)
[   18.821735] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[   18.822893] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:15)
[   18.824622] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[   18.825942] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[   18.827158] pnp: PnP ACPI: found 7 devices
[   18.828001] ACPI: bus type PNP unregistered
[   18.842613] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[   18.843642] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[   18.844640] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[   18.845708] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[   18.846835] NET: Registered protocol family 2
[   18.847912] TCP established hash table entries: 32768 (order: 6, 262144 =
bytes)
[   18.849632] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[   18.851180] TCP: Hash tables configured (established 32768 bind 32768)
[   18.852401] TCP: reno registered
[   18.853150] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[   18.854238] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[   18.855462] NET: Registered protocol family 1
[   18.856575] RPC: Registered named UNIX socket transport module.
[   18.857607] RPC: Registered udp transport module.
[   18.858501] RPC: Registered tcp transport module.
[   18.859496] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   18.860594] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[   18.861629] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[   18.862651] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[   18.863750] pci 0000:00:02.0: Boot video device
[   18.864696] PCI: CLS 0 bytes, default 64
[   18.865607] Trying to unpack rootfs image as initramfs...
[   22.658164] Freeing initrd memory: 199812K (ffff880073cdf000 - ffff88008=
0000000)
[   22.659722] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[   22.660765] software IO TLB [mem 0xdbffe000-0xdfffe000] (64MB) mapped at=
 [ffff8800dbffe000-ffff8800dfffdfff]
[   22.663006] kvm: no hardware support
[   22.664742] Scanning for low memory corruption every 60 seconds
[   22.666130] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[   22.667770] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[   22.669664] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[   22.673680] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[   22.674798] PCLMULQDQ-NI instructions are not detected.
[   22.675748] AVX or AES-NI instructions are not detected.
[   22.676706] AVX instructions are not detected.
[   22.677580] AVX instructions are not detected.
[   22.678449] AVX instructions are not detected.
[   22.679338] AVX instructions are not detected.
[   22.704146] bounce pool size: 64 pages
[   22.704978] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   22.712107] VFS: Disk quotas dquot_6.5.2
[   22.713035] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   22.716210] NFS: Registering the id_resolver key type
[   22.717172] Key type id_resolver registered
[   22.718051] Key type id_legacy registered
[   22.718895] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[   22.720018] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   22.721711] ROMFS MTD (C) 2007 Red Hat, Inc.
[   22.722786] fuse init (API version 7.22)
[   22.723989] SGI XFS with ACLs, security attributes, realtime, large bloc=
k/inode numbers, no debug enabled
[   22.727349] bio: create slab <bio-1> at 1
[   22.729090] Btrfs loaded
[   22.729784] msgmni has been set to 7887
[   22.736339] NET: Registered protocol family 38
[   22.737242] Key type asymmetric registered
[   22.738336] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[   22.739991] io scheduler noop registered
[   22.740808] io scheduler deadline registered
[   22.741705] io scheduler cfq registered (default)
[   22.742991] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   22.744182] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[   22.745525] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   22.747091] ACPI: Power Button [PWRF]
[   22.748267] GHES: HEST is not enabled!
[   22.749591] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[   22.750611] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:15)
[   22.753825] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[   22.754873] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:15)
[   22.758084] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[   22.761043] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[   22.769387] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   22.791818] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[   22.794972] Non-volatile memory driver v1.3
[   22.799059] brd: module loaded
[   22.801455] loop: module loaded
[   22.802391] virtio-pci 0000:00:04.0: irq 40 for MSI/MSI-X
[   22.803412] virtio-pci 0000:00:04.0: irq 41 for MSI/MSI-X
[   22.804583] blk-mq: CPU -> queue map
[   22.805365]   CPU 0 -> Queue 0
[   22.806113]   CPU 1 -> Queue 0
[   22.806853]   CPU 2 -> Queue 0
[   22.807580]   CPU 3 -> Queue 0
[   22.808884]  vda: unknown partition table
[   22.811659] virtio-pci 0000:00:05.0: irq 42 for MSI/MSI-X
[   22.812678] virtio-pci 0000:00:05.0: irq 43 for MSI/MSI-X
[   22.813868] blk-mq: CPU -> queue map
[   22.814671]   CPU 0 -> Queue 0
[   22.815425]   CPU 1 -> Queue 0
[   22.816159]   CPU 2 -> Queue 0
[   22.816883]   CPU 3 -> Queue 0
[   22.818424]  vdb: unknown partition table
[   22.821185] virtio-pci 0000:00:06.0: irq 44 for MSI/MSI-X
[   22.822201] virtio-pci 0000:00:06.0: irq 45 for MSI/MSI-X
[   22.828712] blk-mq: CPU -> queue map
[   22.829513]   CPU 0 -> Queue 0
[   22.830239]   CPU 1 -> Queue 0
[   22.830978]   CPU 2 -> Queue 0
[   22.831704]   CPU 3 -> Queue 0
[   22.833213]  vdc: unknown partition table
[   22.835562] virtio-pci 0000:00:07.0: irq 46 for MSI/MSI-X
[   22.836576] virtio-pci 0000:00:07.0: irq 47 for MSI/MSI-X
[   22.837725] blk-mq: CPU -> queue map
[   22.838501]   CPU 0 -> Queue 0
[   22.839210]   CPU 1 -> Queue 0
[   22.839915]   CPU 2 -> Queue 0
[   22.840600]   CPU 3 -> Queue 0
[   22.841940]  vdd: unknown partition table
[   22.844470] virtio-pci 0000:00:08.0: irq 48 for MSI/MSI-X
[   22.845429] virtio-pci 0000:00:08.0: irq 49 for MSI/MSI-X
[   22.846505] blk-mq: CPU -> queue map
[   22.847267]   CPU 0 -> Queue 0
[   22.847952]   CPU 1 -> Queue 0
[   22.848629]   CPU 2 -> Queue 0
[   22.849312]   CPU 3 -> Queue 0
[   22.851052]  vde: unknown partition table
[   22.853713] virtio-pci 0000:00:09.0: irq 50 for MSI/MSI-X
[   22.854657] virtio-pci 0000:00:09.0: irq 51 for MSI/MSI-X
[   22.855743] blk-mq: CPU -> queue map
[   22.856485]   CPU 0 -> Queue 0
[   22.857176]   CPU 1 -> Queue 0
[   22.857892]   CPU 2 -> Queue 0
[   22.858574]   CPU 3 -> Queue 0
[   22.860186]  vdf: unknown partition table
[   22.862546] lkdtm: No crash points registered, enable through debugfs
[   22.864814] Loading iSCSI transport class v2.0-870.
[   22.866808] Adaptec aacraid driver 1.2-0[30200]-ms
[   22.867841] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[   22.869154] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 8.06.00.08-k.
[   22.870934] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 ES=
T 2006)
[   22.872546] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 20=
06)
[   22.873777] megasas: 06.700.06.00-rc1 Sat. Aug. 31 17:00:00 PDT 2013
[   22.875033] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[   22.876170] RocketRAID 3xxx/4xxx Controller driver v1.8
[   22.877601] ata_piix 0000:00:01.1: version 2.13
[   22.880957] scsi0 : ata_piix
[   22.881878] scsi1 : ata_piix
[   22.882734] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc1c0 irq 14
[   22.883893] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc1c8 irq 15
[   22.885916] tun: Universal TUN/TAP device driver, 1.6
[   22.886876] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   22.888305] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.=
de
[   22.889594] Atheros(R) L2 Ethernet Driver - version 2.2.3
[   22.890585] Copyright (c) 2007 Atheros Corporation.
[   22.891933] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[   22.893133] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.=
com>
[   22.893133]   http://www.scyld.com/network/drivers.html
[   22.895436] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-2=
9)
[   22.896715] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[   22.897772] e100: Copyright(c) 1999-2006 Intel Corporation
[   22.898876] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-=
NAPI
[   22.900046] e1000: Copyright (c) 1999-2006 Intel Corporation.
[   23.039248] ata2.01: NODEV after polling detection
[   23.040440] ata2.00: ATAPI: QEMU DVD-ROM, 1.6.0, max UDMA/100
[   23.041868] ata2.00: configured for MWDMA2
[   23.043299] scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     1.=
6. PQ: 0 ANSI: 5
[   23.045966] scsi 1:0:0:0: Attached scsi generic sg0 type 5
[   23.227404] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56
[   23.228529] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
[   23.229889] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[   23.230872] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[   23.232092] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.=
5-k
[   23.233167] igb: Copyright (c) 2007-2013 Intel Corporation.
[   23.234405] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - vers=
ion 3.15.1-k
[   23.235883] ixgbe: Copyright (c) 1999-2013 Intel Corporation.
[   23.237135] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2=
-NAPI
[   23.238264] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[   23.239730] sky2: driver version 1.30
[   23.242293] usbcore: registered new interface driver catc
[   23.243408] usbcore: registered new interface driver kaweth
[   23.244412] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[   23.246076] usbcore: registered new interface driver pegasus
[   23.247207] usbcore: registered new interface driver rtl8150
[   23.248324] usbcore: registered new interface driver asix
[   23.249413] usbcore: registered new interface driver ax88179_178a
[   23.250572] usbcore: registered new interface driver cdc_ether
[   23.251716] usbcore: registered new interface driver r815x
[   23.252800] usbcore: registered new interface driver cdc_eem
[   23.253908] usbcore: registered new interface driver dm9601
[   23.255036] usbcore: registered new interface driver smsc75xx
[   23.256159] usbcore: registered new interface driver smsc95xx
[   23.257296] usbcore: registered new interface driver gl620a
[   23.258395] usbcore: registered new interface driver net1080
[   23.259517] usbcore: registered new interface driver plusb
[   23.260606] usbcore: registered new interface driver rndis_host
[   23.261768] usbcore: registered new interface driver cdc_subset
[   23.262916] usbcore: registered new interface driver zaurus
[   23.264025] usbcore: registered new interface driver MOSCHIP usb-etherne=
t driver
[   23.265646] usbcore: registered new interface driver int51x1
[   23.266761] usbcore: registered new interface driver ipheth
[   23.267879] usbcore: registered new interface driver sierra_net
[   23.269021] usbcore: registered new interface driver cdc_ncm
[   23.270031] Fusion MPT base driver 3.04.20
[   23.270879] Copyright (c) 1999-2008 LSI Corporation
[   23.271829] Fusion MPT SPI Host driver 3.04.20
[   23.272807] Fusion MPT FC Host driver 3.04.20
[   23.273780] Fusion MPT SAS Host driver 3.04.20
[   23.274764] Fusion MPT misc device (ioctl) driver 3.04.20
[   23.275924] mptctl: Registered with Fusion MPT base driver
[   23.276921] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[   23.278239] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   23.279356] ehci-pci: EHCI PCI platform driver
[   23.280328] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   23.281400] ohci-pci: OHCI PCI platform driver
[   23.282384] uhci_hcd: USB Universal Host Controller Interface driver
[   23.283687] usbcore: registered new interface driver usb-storage
[   23.284840] usbcore: registered new interface driver ums-alauda
[   23.285977] usbcore: registered new interface driver ums-datafab
[   23.287134] usbcore: registered new interface driver ums-freecom
[   23.288291] usbcore: registered new interface driver ums-isd200
[   23.289432] usbcore: registered new interface driver ums-jumpshot
[   23.290584] usbcore: registered new interface driver ums-sddr09
[   23.291738] usbcore: registered new interface driver ums-sddr55
[   23.292879] usbcore: registered new interface driver ums-usbat
[   23.294037] usbcore: registered new interface driver usbtest
[   23.295270] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   23.297579] serio: i8042 KBD port at 0x60,0x64 irq 1
[   23.298534] serio: i8042 AUX port at 0x60,0x64 irq 12
[   23.299949] mousedev: PS/2 mouse device common for all mice
[   23.301758] rtc_cmos 00:00: RTC can wake from S4
[   23.302877] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   23.304578] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[   23.305743] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[   23.307210] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[   23.308660] i6300esb: initialized (0xffffc90000718000). heartbeat=3D30 s=
ec (nowayout=3D0)
[   23.310439] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[   23.311685] iTCO_vendor_support: vendor-support=3D0
[   23.312579] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[   23.314116] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[   23.315862] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D0)
[   23.317727] md: linear personality registered for level -1
[   23.318663] md: raid0 personality registered for level 0
[   23.319664] md: raid1 personality registered for level 1
[   23.320602] md: raid10 personality registered for level 10
[   23.321842] md: raid6 personality registered for level 6
[   23.322841] md: raid5 personality registered for level 5
[   23.323801] md: raid4 personality registered for level 4
[   23.324716] md: multipath personality registered for level -4
[   23.325707] md: faulty personality registered for level -5
[   23.328012] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised:=
 dm-devel@redhat.com
[   23.330091] device-mapper: multipath: version 1.6.0 loaded
[   23.331137] device-mapper: multipath round-robin: version 1.0.0 loaded
[   23.332264] device-mapper: cache-policy-mq: version 1.1.0 loaded
[   23.333315] device-mapper: cache cleaner: version 1.0.0 loaded
[   23.334640] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[   23.338010] usbcore: registered new interface driver usbhid
[   23.339059] usbhid: USB HID core driver
[   23.340041] TCP: bic registered
[   23.340780] Initializing XFRM netlink socket
[   23.342010] NET: Registered protocol family 10
[   23.343130] sit: IPv6 over IPv4 tunneling driver
[   23.344326] NET: Registered protocol family 17
[   23.345238] 8021q: 802.1Q VLAN Support v1.8
[   23.346358] sctp: Hash tables configured (established 65536 bind 65536)
[   23.347705] Key type dns_resolver registered
[   23.349348]=20
[   23.349348] printing PIC contents
[   23.350548] ... PIC  IMR: ffff
[   23.351271] ... PIC  IRR: 9113
[   23.351984] ... PIC  ISR: 0000
[   23.357846] ... PIC ELCR: 0c00
[   23.358590] printing local APIC contents on CPU#0/0:
[   23.359552] ... APIC ID:      00000000 (0)
[   23.360404] ... APIC VERSION: 00050014
[   23.361212] ... APIC TASKPRI: 00000000 (00)
[   23.362074] ... APIC PROCPRI: 00000000
[   23.362877] ... APIC LDR: 01000000
[   23.363642] ... APIC DFR: ffffffff
[   23.364413] ... APIC SPIV: 000001ff
[   23.365189] ... APIC ISR field:
[   23.365931] 000000000000000000000000000000000000000000000000000000000000=
0000
[   23.367653] ... APIC TMR field:
[   23.368392] 000000000200000000000000000000000000000000000000000000000000=
0000
[   23.370118] ... APIC IRR field:
[   23.370860] 000000000000000000000000000000000000000000000000000000000000=
0000
[   23.372591] ... APIC ESR: 00000000
[   23.373364] ... APIC ICR: 000400f6
[   23.374156] ... APIC ICR2: 02000000
[   23.374940] ... APIC LVTT: 000000ef
[   23.375671] ... APIC LVTPC: 00010000
[   23.376414] ... APIC LVT0: 00010700
[   23.377151] ... APIC LVT1: 00000400
[   23.377913] ... APIC LVTERR: 000000fe
[   23.378662] ... APIC TMICT: 0015aec1
[   23.379434] ... APIC TMCCT: 00000000
[   23.380178] ... APIC TDCR: 00000003
[   23.380923]=20
[   23.381478] number of MP IRQ sources: 15.
[   23.382269] number of IO-APIC #0 registers: 24.
[   23.383119] testing the IO APIC.......................
[   23.384005] IO APIC #0......
[   23.384647] .... register #00: 00000000
[   23.385390] .......    : physical APIC id: 00
[   23.386229] .......    : Delivery Type: 0
[   23.387050] .......    : LTS          : 0
[   23.387810] .... register #01: 00170011
[   23.388549] .......     : max redirection entries: 17
[   23.389424] .......     : PRQ implemented: 0
[   23.390236] .......     : IO APIC version: 11
[   23.391067] .... register #02: 00000000
[   23.391808] .......     : arbitration: 00
[   23.392564] .... IRQ redirection table:
[   23.393313] 1    0    0   0   0    0    0    00
[   23.394186] 0    0    0   0   0    1    1    31
[   23.395036] 0    0    0   0   0    1    1    30
[   23.395847] 0    0    0   0   0    1    1    33
[   23.396663] 1    0    0   0   0    1    1    34
[   23.397506] 1    1    0   0   0    1    1    35
[   23.398338] 0    0    0   0   0    1    1    36
[   23.399194] 0    0    0   0   0    1    1    37
[   23.400016] 0    0    0   0   0    1    1    38
[   23.400832] 0    1    0   0   0    1    1    39
[   23.401700] 1    1    0   0   0    1    1    3A
[   23.402511] 1    1    0   0   0    1    1    3B
[   23.403364] 0    0    0   0   0    1    1    3C
[   23.404183] 0    0    0   0   0    1    1    3D
[   23.404998] 0    0    0   0   0    1    1    3E
[   23.405855] 0    0    0   0   0    1    1    3F
[   23.406667] 1    0    0   0   0    0    0    00
[   23.407520] 1    0    0   0   0    0    0    00
[   23.408338] 1    0    0   0   0    0    0    00
[   23.409153] 1    0    0   0   0    0    0    00
[   23.410020] 1    0    0   0   0    0    0    00
[   23.410864] 1    0    0   0   0    0    0    00
[   23.411676] 1    0    0   0   0    0    0    00
[   23.412499] 1    0    0   0   0    0    0    00
[   23.413306] IRQ to pin mappings:
[   23.414034] IRQ0 -> 0:2
[   23.414784] IRQ1 -> 0:1
[   23.415534] IRQ3 -> 0:3
[   23.416262] IRQ4 -> 0:4
[   23.416994] IRQ5 -> 0:5
[   23.417761] IRQ6 -> 0:6
[   23.418494] IRQ7 -> 0:7
[   23.419291] IRQ8 -> 0:8
[   23.420022] IRQ9 -> 0:9
[   23.420748] IRQ10 -> 0:10
[   23.421530] IRQ11 -> 0:11
[   23.422294] IRQ12 -> 0:12
[   23.423082] IRQ13 -> 0:13
[   23.423830] IRQ14 -> 0:14
[   23.424578] IRQ15 -> 0:15
[   23.425326] .................................... done.
[   23.426610] registered taskstats version 1
[   23.428841] rtc_cmos 00:00: setting system clock to 2014-01-14 23:56:31 =
UTC (1389743791)
[   23.430365] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[   23.435280] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   23.436250] 8021q: adding VLAN 0 to HW filter on device eth0
[   23.662811] tsc: Refined TSC clocksource calibration: 2693.414 MHz
[   23.930040] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[   25.439261] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Contr=
ol: RX
[   25.442816] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   25.458802] Sending DHCP requests ., OK
[   25.518801] IP-Config: Got DHCP answer from 10.0.2.2, my address is 10.0=
=2E2.15
[   25.520055] IP-Config: Complete:
[   25.520764]      device=3Deth0, hwaddr=3D52:54:00:12:34:56, ipaddr=3D10.=
0.2.15, mask=3D255.255.255.0, gw=3D10.0.2.2
[   25.522510]      host=3Dvpx-4, domain=3D, nis-domain=3D(none)
[   25.523461]      bootserver=3D10.0.2.2, rootserver=3D10.0.2.2, rootpath=
=3D
[   25.524182]      nameserver0=3D10.0.2.3
[   25.525399] PM: Hibernation image not present or could not be loaded.
[   25.527782] Freeing unused kernel memory: 1428K (ffffffff82337000 - ffff=
ffff8249c000)
[   25.529267] Write protecting the kernel read-only data: 18432k
[   25.534588] Freeing unused kernel memory: 1888K (ffff880001a28000 - ffff=
880001c00000)
[   25.540062] Freeing unused kernel memory: 1988K (ffff88000200f000 - ffff=
880002200000)
[   25.722169] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[   25.743728] platform microcode: Direct firmware load failed with error -2
[   25.746993] platform microcode: Falling back to user helper
[   25.780749] microcode: CPU1 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[   25.781776] platform microcode: Direct firmware load failed with error -2
[   25.781777] platform microcode: Falling back to user helper
[   25.787863] microcode: CPU2 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[   25.788897] platform microcode: Direct firmware load failed with error -2
[   25.790057] platform microcode: Falling back to user helper
[   25.793774] microcode: CPU3 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[   25.794819] platform microcode: Direct firmware load failed with error -2
[   25.795963] platform microcode: Falling back to user helper
[   25.800448] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[   85.786775] INFO: rcu_sched self-detected stall on CPU { 1}  (t=3D15000 =
jiffies g=3D233 c=3D232 q=3D1940)
[   85.788745] sending NMI to all CPUs:
[   85.789539] NMI backtrace for cpu 0
[   85.790389] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[   85.792043] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   85.793072] task: ffffffff82211440 ti: ffffffff82200000 task.ti: fffffff=
f82200000
[   85.794631] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[   85.796314] RSP: 0018:ffffffff82201ec8  EFLAGS: 00000246
[   85.797286] RAX: 0000000000000000 RBX: ffffffff82201fd8 RCX: 00000000fff=
fffff
[   85.798507] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[   85.799680] RBP: ffffffff82201ec8 R08: 0000000000000000 R09: 00000000000=
00000
[   85.800862] R10: 0000000000000000 R11: 0000000000000400 R12: 00000000000=
00000
[   85.802055] R13: ffffffff82201fd8 R14: ffffffff82201fd8 R15: 00000000fff=
fffff
[   85.803243] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:=
0000000000000000
[   85.804872] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   85.806014] CR2: 00007feec94d2000 CR3: 000000007f7a2000 CR4: 00000000000=
006f0
[   85.807265] Stack:
[   85.807907]  ffffffff82201ee8 ffffffff81041811 ffffffff82201fd8 ffffffff=
82201fd8
[   85.809808]  ffffffff82201ef8 ffffffff81041f3d ffffffff82201f40 ffffffff=
8110be4c
[   85.811649]  ffff88011ffa3ec0 35ceeb7d84596041 ffffffffffffffff ffffffff=
823ef8d0
[   85.813483] Call Trace:
[   85.814198]  [<ffffffff81041811>] default_idle+0x38/0xc1
[   85.815171]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[   85.816152]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[   85.817201]  [<ffffffff81a022c3>] rest_init+0x87/0x89
[   85.818204]  [<ffffffff8234be04>] start_kernel+0x435/0x440
[   85.819197]  [<ffffffff8234b7dd>] ? repair_env_string+0x58/0x58
[   85.820241]  [<ffffffff8234b120>] ? early_idt_handlers+0x120/0x120
[   85.821311]  [<ffffffff8234b498>] x86_64_start_reservations+0x2a/0x2c
[   85.822434]  [<ffffffff8234b5d5>] x86_64_start_kernel+0x13b/0x148
[   85.823545] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[   85.831203] NMI backtrace for cpu 1
[   85.831206] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 41.664 msecs
[   85.831214] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detecte=
d by 0, t=3D15011 jiffies, g=3D233, c=3D232, q=3D1940)
[   85.835596] CPU: 1 PID: 696 Comm: kswapd0 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[   85.837217] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   85.843613] task: ffff8800bc718900 ti: ffff8800bc75c000 task.ti: ffff880=
0bc75c000
[   85.845141] RIP: 0010:[<ffffffff81063841>]  [<ffffffff81063841>] flat_se=
nd_IPI_mask+0x7e/0xac
[   85.846852] RSP: 0018:ffff88011fc83dd0  EFLAGS: 00010046
[   85.847813] RAX: 0000000000000c00 RBX: 0000000000000046 RCX: 00000000000=
01369
[   85.848973] RDX: ffffffff82222120 RSI: 0000000000000002 RDI: 00000000000=
00300
[   85.850130] RBP: ffff88011fc83df0 R08: 0000000000000000 R09: 00000000000=
00000
[   85.851290] R10: 000000000000a5a0 R11: 0000000000000000 R12: 00000000000=
00002
[   85.852450] R13: 0000000000000c00 R14: 000000000000000f R15: 00000000000=
00001
[   85.853640] FS:  0000000000000000(0000) GS:ffff88011fc80000(0000) knlGS:=
0000000000000000
[   85.855234] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   85.856246] CR2: 00007fe45ab579a0 CR3: 000000000220c000 CR4: 00000000000=
006e0
[   85.857404] Stack:
[   85.858039]  0000000000002710 ffff88011fc8d800 0000000000000000 ffffffff=
8224de40
[   85.859830]  ffff88011fc83e00 ffffffff81063ae8 ffff88011fc83e18 ffffffff=
81060d21
[   85.861616]  ffffffff8224de40 ffff88011fc83e70 ffffffff81114b1c ffff8801=
1fc93040
[   85.863404] Call Trace:
[   85.864056]  <IRQ>=20
[   85.864332]  [<ffffffff81063ae8>] flat_send_IPI_all+0x1f/0x4a
[   85.865827]  [<ffffffff81060d21>] arch_trigger_all_cpu_backtrace+0x52/0x=
84
[   85.866958]  [<ffffffff81114b1c>] rcu_check_callbacks+0x205/0x57f
[   85.868010]  [<ffffffff8111dcdd>] ? tick_sched_do_timer+0x2f/0x2f
[   85.869061]  [<ffffffff810d28d4>] update_process_times+0x3d/0x65
[   85.870125]  [<ffffffff8111dbed>] tick_sched_handle+0x37/0x43
[   85.871137]  [<ffffffff8111dd17>] tick_sched_timer+0x3a/0x58
[   85.872136]  [<ffffffff810e6129>] __run_hrtimer+0x96/0x19a
[   85.873119]  [<ffffffff810e6961>] hrtimer_interrupt+0xe8/0x1e3
[   85.874139]  [<ffffffff8105f691>] local_apic_timer_interrupt+0x54/0x57
[   85.875241]  [<ffffffff81a21841>] smp_apic_timer_interrupt+0x3f/0x50
[   85.876322]  [<ffffffff81a20532>] apic_timer_interrupt+0x72/0x80
[   85.877363]  <EOI>=20
[   85.877635]  [<ffffffff811716ca>] ? zone_watermark_ok_safe+0x4b/0xad
[   85.879197]  [<ffffffff8117c77d>] zone_balanced+0x1e/0x43
[   85.880166]  [<ffffffff8117fe32>] balance_pgdat+0x3b6/0x501
[   85.881152]  [<ffffffff811802bc>] kswapd+0x33f/0x3c7
[   85.882077]  [<ffffffff810fdbf5>] ? __wake_up_sync+0x12/0x12
[   85.883076]  [<ffffffff8117ff7d>] ? balance_pgdat+0x501/0x501
[   85.884091]  [<ffffffff810e3c1e>] kthread+0xdb/0xe3
[   85.885012]  [<ffffffff810e3b43>] ? kthread_create_on_node+0x16f/0x16f
[   85.886133]  [<ffffffff81a1f8bc>] ret_from_fork+0x7c/0xb0
[   85.887106]  [<ffffffff810e3b43>] ? kthread_create_on_node+0x16f/0x16f
[   85.888199] Code: eb f0 44 89 f0 c1 e0 18 89 04 25 10 33 5f ff 44 89 e0 =
44 09 e8 41 81 cd 00 04 00 00 41 83 fc 02 41 0f 44 c5 89 04 25 00 33 5f ff =
<f6> c7 02 75 11 48 89 df 57 9d 0f 1f 44 00 00 e8 5c 90 0e 00 eb=20
[   85.895640] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 106.100 msecs
[   85.895642] NMI backtrace for cpu 3
[   85.895644] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[   85.895645] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   85.895646] task: ffff880119b26300 ti: ffff880119b48000 task.ti: ffff880=
119b48000
[   85.895650] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[   85.895651] RSP: 0018:ffff880119b49eb8  EFLAGS: 00000246
[   85.895652] RAX: 0000000000000000 RBX: ffff880119b49fd8 RCX: 00000000fff=
fffff
[   85.895652] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[   85.895653] RBP: ffff880119b49eb8 R08: 0000000000000000 R09: 00000000000=
00000
[   85.895653] R10: 0000000000000003 R11: 0000000000000400 R12: 00000000000=
00003
[   85.895654] R13: ffff880119b49fd8 R14: ffff880119b49fd8 R15: 00000000000=
00000
[   85.895655] FS:  0000000000000000(0000) GS:ffff88011fd80000(0000) knlGS:=
0000000000000000
[   85.895656] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   85.895657] CR2: 00007f14d81d29d8 CR3: 000000007f470000 CR4: 00000000000=
006e0
[   85.895662] Stack:
[   85.895663]  ffff880119b49ed8 ffffffff81041811 ffff880119b49fd8 ffff8801=
19b49fd8
[   85.895664]  ffff880119b49ee8 ffffffff81041f3d ffff880119b49f30 ffffffff=
8110be4c
[   85.895665]  ffffffff8111bc52 92ed795e8031d18d 0000000000000000 00000000=
00000000
[   85.895665] Call Trace:
[   85.895668]  [<ffffffff81041811>] default_idle+0x38/0xc1
[   85.895669]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[   85.895671]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[   85.895672]  [<ffffffff8111bc52>] ? clockevents_register_device+0x112/0x=
117
[   85.895674]  [<ffffffff8105de31>] start_secondary+0x277/0x279
[   85.895684] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[   85.895686] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 106.120 msecs
[   85.895688] NMI backtrace for cpu 2
[   85.895690] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[   85.895691] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   85.895692] task: ffff880119b25a00 ti: ffff880119b42000 task.ti: ffff880=
119b42000
[   85.895695] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[   85.895696] RSP: 0018:ffff880119b43eb8  EFLAGS: 00000246
[   85.895697] RAX: 0000000000000000 RBX: ffff880119b43fd8 RCX: 00000000fff=
fffff
[   85.895700] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[   85.895701] RBP: ffff880119b43eb8 R08: 0000000000000000 R09: 00000000000=
00000
[   85.895701] R10: 00000000ffff1d40 R11: 0000000000000040 R12: 00000000000=
00002
[   85.895702] R13: ffff880119b43fd8 R14: ffff880119b43fd8 R15: 00000000000=
00000
[   85.895703] FS:  0000000000000000(0000) GS:ffff88011fd00000(0000) knlGS:=
0000000000000000
[   85.895704] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   85.895704] CR2: 0000000000e270c8 CR3: 000000007f0da000 CR4: 00000000000=
006e0
[   85.895710] Stack:
[   85.895711]  ffff880119b43ed8 ffffffff81041811 ffff880119b43fd8 ffff8801=
19b43fd8
[   85.895712]  ffff880119b43ee8 ffffffff81041f3d ffff880119b43f30 ffffffff=
8110be4c
[   85.895713]  ffffffff8111bc52 baab13b05212a163 0000000000000000 00000000=
00000000
[   85.895713] Call Trace:
[   85.895716]  [<ffffffff81041811>] default_idle+0x38/0xc1
[   85.895717]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[   85.895719]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[   85.895720]  [<ffffffff8111bc52>] ? clockevents_register_device+0x112/0x=
117
[   85.895722]  [<ffffffff8105de31>] start_secondary+0x277/0x279
[   85.895731] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[   85.895734] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 106.167 msecs
[  146.218102] random: vgscan urandom read with 83 bits of entropy available
[  215.819201] random: nonblocking pool is initialized
[  265.842775] INFO: rcu_sched self-detected stall on CPU { 1}  (t=3D60014 =
jiffies g=3D233 c=3D232 q=3D33921)
[  265.844593] sending NMI to all CPUs:
[  265.845305] NMI backtrace for cpu 1
[  265.846118] CPU: 1 PID: 696 Comm: kswapd0 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[  265.847742] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  265.848747] task: ffff8800bc718900 ti: ffff8800bc75c000 task.ti: ffff880=
0bc75c000
[  265.850294] RIP: 0010:[<ffffffff81063841>]  [<ffffffff81063841>] flat_se=
nd_IPI_mask+0x7e/0xac
[  265.852011] RSP: 0018:ffff88011fc83dd0  EFLAGS: 00010046
[  265.852979] RAX: 0000000000000c00 RBX: 0000000000000046 RCX: 00000000000=
03e53
[  265.854161] RDX: ffffffff82222120 RSI: 0000000000000002 RDI: 00000000000=
00300
[  265.855319] RBP: ffff88011fc83df0 R08: 0000000000000000 R09: 00000000000=
00000
[  265.856481] R10: 00000000000008c0 R11: 0000000000000000 R12: 00000000000=
00002
[  265.857669] R13: 0000000000000c00 R14: 000000000000000f R15: 00000000000=
00001
[  265.858832] FS:  0000000000000000(0000) GS:ffff88011fc80000(0000) knlGS:=
0000000000000000
[  265.860428] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  265.861450] CR2: 00007fe45ab579a0 CR3: 000000000220c000 CR4: 00000000000=
006e0
[  265.862628] Stack:
[  265.868635]  0000000000002710 ffff88011fc8d800 0000000000000000 ffffffff=
8224de40
[  265.870483]  ffff88011fc83e00 ffffffff81063ae8 ffff88011fc83e18 ffffffff=
81060d21
[  265.872271]  ffffffff8224de40 ffff88011fc83e70 ffffffff81114b1c ffff8801=
1fc93040
[  265.874094] Call Trace:
[  265.874750]  <IRQ>=20
[  265.875024]  [<ffffffff81063ae8>] flat_send_IPI_all+0x1f/0x4a
[  265.876522]  [<ffffffff81060d21>] arch_trigger_all_cpu_backtrace+0x52/0x=
84
[  265.877681]  [<ffffffff81114b1c>] rcu_check_callbacks+0x205/0x57f
[  265.878732]  [<ffffffff8111dcdd>] ? tick_sched_do_timer+0x2f/0x2f
[  265.879791]  [<ffffffff810d28d4>] update_process_times+0x3d/0x65
[  265.880834]  [<ffffffff8111dbed>] tick_sched_handle+0x37/0x43
[  265.881866]  [<ffffffff8111dd17>] tick_sched_timer+0x3a/0x58
[  265.882868]  [<ffffffff810e6129>] __run_hrtimer+0x96/0x19a
[  265.883850]  [<ffffffff810e6961>] hrtimer_interrupt+0xe8/0x1e3
[  265.884877]  [<ffffffff8105f691>] local_apic_timer_interrupt+0x54/0x57
[  265.885994]  [<ffffffff81a21841>] smp_apic_timer_interrupt+0x3f/0x50
[  265.887078]  [<ffffffff81a20532>] apic_timer_interrupt+0x72/0x80
[  265.888118]  <EOI>=20
[  265.888396]  [<ffffffff811716ef>] ? zone_watermark_ok_safe+0x70/0xad
[  265.889981]  [<ffffffff8117c77d>] zone_balanced+0x1e/0x43
[  265.890956]  [<ffffffff8117fe32>] balance_pgdat+0x3b6/0x501
[  265.891950]  [<ffffffff811802bc>] kswapd+0x33f/0x3c7
[  265.892880]  [<ffffffff810fdbf5>] ? __wake_up_sync+0x12/0x12
[  265.893918]  [<ffffffff8117ff7d>] ? balance_pgdat+0x501/0x501
[  265.894936]  [<ffffffff810e3c1e>] kthread+0xdb/0xe3
[  265.895854]  [<ffffffff810e3b43>] ? kthread_create_on_node+0x16f/0x16f
[  265.896949]  [<ffffffff81a1f8bc>] ret_from_fork+0x7c/0xb0
[  265.897951]  [<ffffffff810e3b43>] ? kthread_create_on_node+0x16f/0x16f
[  265.899045] Code: eb f0 44 89 f0 c1 e0 18 89 04 25 10 33 5f ff 44 89 e0 =
44 09 e8 41 81 cd 00 04 00 00 41 83 fc 02 41 0f 44 c5 89 04 25 00 33 5f ff =
<f6> c7 02 75 11 48 89 df 57 9d 0f 1f 44 00 00 e8 5c 90 0e 00 eb=20
[  265.906538] NMI backtrace for cpu 3
[  265.907352] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[  265.909004] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  265.910070] task: ffff880119b26300 ti: ffff880119b48000 task.ti: ffff880=
119b48000
[  265.911636] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[  265.913346] RSP: 0018:ffff880119b49eb8  EFLAGS: 00000246
[  265.914373] RAX: 0000000000000000 RBX: ffff880119b49fd8 RCX: 00000000fff=
fffff
[  265.915560] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[  265.916742] RBP: ffff880119b49eb8 R08: 0000000000000000 R09: 00000000000=
00000
[  265.917962] R10: 0000000000000003 R11: 0000000000000400 R12: 00000000000=
00003
[  265.919147] R13: ffff880119b49fd8 R14: ffff880119b49fd8 R15: 00000000000=
00000
[  265.920338] FS:  0000000000000000(0000) GS:ffff88011fd80000(0000) knlGS:=
0000000000000000
[  265.921994] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  265.923029] CR2: 0000000000405c60 CR3: 000000007f470000 CR4: 00000000000=
006e0
[  265.924272] Stack:
[  265.924903]  ffff880119b49ed8 ffffffff81041811 ffff880119b49fd8 ffff8801=
19b49fd8
[  265.926763]  ffff880119b49ee8 ffffffff81041f3d ffff880119b49f30 ffffffff=
8110be4c
[  265.928597]  ffffffff8111bc52 92ed795e8031d18d 0000000000000000 00000000=
00000000
[  265.930461] Call Trace:
[  265.931135]  [<ffffffff81041811>] default_idle+0x38/0xc1
[  265.932126]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[  265.933121]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[  265.934204]  [<ffffffff8111bc52>] ? clockevents_register_device+0x112/0x=
117
[  265.935381]  [<ffffffff8105de31>] start_secondary+0x277/0x279
[  265.936416] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[  265.944116] NMI backtrace for cpu 0
[  265.944123] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detecte=
d by 3, t=3D60039 jiffies, g=3D233, c=3D232, q=3D33921)
[  265.946820] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[  265.948477] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  265.949530] task: ffffffff82211440 ti: ffffffff82200000 task.ti: fffffff=
f82200000
[  265.951078] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[  265.952808] RSP: 0018:ffffffff82201ec8  EFLAGS: 00000246
[  265.953801] RAX: 0000000000000000 RBX: ffffffff82201fd8 RCX: 00000000fff=
fffff
[  265.954980] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[  265.956164] RBP: ffffffff82201ec8 R08: 0000000000000000 R09: 00000000000=
00000
[  265.957351] R10: 0000000000000000 R11: 0000000000000400 R12: 00000000000=
00000
[  265.958532] R13: ffffffff82201fd8 R14: ffffffff82201fd8 R15: 00000000fff=
fffff
[  265.959713] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:=
0000000000000000
[  265.961333] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  265.962371] CR2: 000000000223ea88 CR3: 000000007c4c1000 CR4: 00000000000=
006f0
[  265.963553] Stack:
[  265.964173]  ffffffff82201ee8 ffffffff81041811 ffffffff82201fd8 ffffffff=
82201fd8
[  265.966027]  ffffffff82201ef8 ffffffff81041f3d ffffffff82201f40 ffffffff=
8110be4c
[  265.967849]  ffff88011ffa3ec0 35ceeb7d84596041 ffffffffffffffff ffffffff=
823ef8d0
[  265.969669] Call Trace:
[  265.970334]  [<ffffffff81041811>] default_idle+0x38/0xc1
[  265.971318]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[  265.972312]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[  265.973366]  [<ffffffff81a022c3>] rest_init+0x87/0x89
[  265.974308]  [<ffffffff8234be04>] start_kernel+0x435/0x440
[  265.975308]  [<ffffffff8234b7dd>] ? repair_env_string+0x58/0x58
[  265.976357]  [<ffffffff8234b120>] ? early_idt_handlers+0x120/0x120
[  265.977432]  [<ffffffff8234b498>] x86_64_start_reservations+0x2a/0x2c
[  265.978533]  [<ffffffff8234b5d5>] x86_64_start_kernel+0x13b/0x148
[  265.979596] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[  265.987158] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 141.820 msecs
[  265.987160] NMI backtrace for cpu 2
[  265.987162] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[  265.987163] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  265.987164] task: ffff880119b25a00 ti: ffff880119b42000 task.ti: ffff880=
119b42000
[  265.987168] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[  265.987169] RSP: 0018:ffff880119b43eb8  EFLAGS: 00000246
[  265.987169] RAX: 0000000000000000 RBX: ffff880119b43fd8 RCX: 00000000fff=
fffff
[  265.987170] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[  265.987170] RBP: ffff880119b43eb8 R08: 0000000000000000 R09: 00000000000=
00000
[  265.987171] R10: 0000000000000002 R11: 0000000000000400 R12: 00000000000=
00002
[  265.987172] R13: ffff880119b43fd8 R14: ffff880119b43fd8 R15: 00000000000=
00000
[  265.987173] FS:  0000000000000000(0000) GS:ffff88011fd00000(0000) knlGS:=
0000000000000000
[  265.987174] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  265.987174] CR2: 00007f14d81ce000 CR3: 000000007f3f6000 CR4: 00000000000=
006e0
[  265.987180] Stack:
[  265.987181]  ffff880119b43ed8 ffffffff81041811 ffff880119b43fd8 ffff8801=
19b43fd8
[  265.987182]  ffff880119b43ee8 ffffffff81041f3d ffff880119b43f30 ffffffff=
8110be4c
[  265.987183]  ffffffff8111bc52 baab13b05212a163 0000000000000000 00000000=
00000000
[  265.987183] Call Trace:
[  265.987186]  [<ffffffff81041811>] default_idle+0x38/0xc1
[  265.987187]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[  265.987189]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[  265.987190]  [<ffffffff8111bc52>] ? clockevents_register_device+0x112/0x=
117
[  265.987192]  [<ffffffff8105de31>] start_secondary+0x277/0x279
[  265.987202] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[  265.987205] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 141.865 msecs
[  445.954775] INFO: rcu_sched self-detected stall on CPU { 1}  (t=3D105042=
 jiffies g=3D233 c=3D232 q=3D34671)
[  445.956644] sending NMI to all CPUs:
[  445.957365] NMI backtrace for cpu 1
[  445.958174] CPU: 1 PID: 696 Comm: kswapd0 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[  445.959799] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  445.960811] task: ffff8800bc718900 ti: ffff8800bc75c000 task.ti: ffff880=
0bc75c000
[  445.962366] RIP: 0010:[<ffffffff81063841>]  [<ffffffff81063841>] flat_se=
nd_IPI_mask+0x7e/0xac
[  445.964087] RSP: 0018:ffff88011fc83dd0  EFLAGS: 00010046
[  445.965053] RAX: 0000000000000c00 RBX: 0000000000000046 RCX: 00000000000=
05c45
[  445.966246] RDX: ffffffff82222120 RSI: 0000000000000002 RDI: 00000000000=
00300
[  445.967404] RBP: ffff88011fc83df0 R08: 0000000000000000 R09: 00000000000=
00000
[  445.968562] R10: 0000000000005320 R11: 0000000000000000 R12: 00000000000=
00002
[  445.969745] R13: 0000000000000c00 R14: 000000000000000f R15: 00000000000=
00001
[  445.970902] FS:  0000000000000000(0000) GS:ffff88011fc80000(0000) knlGS:=
0000000000000000
[  445.972489] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  445.973528] CR2: 00007fe45ab579a0 CR3: 000000000220c000 CR4: 00000000000=
006e0
[  445.974692] Stack:
[  445.975299]  0000000000002710 ffff88011fc8d800 0000000000000000 ffffffff=
8224de40
[  445.977092]  ffff88011fc83e00 ffffffff81063ae8 ffff88011fc83e18 ffffffff=
81060d21
[  445.978911]  ffffffff8224de40 ffff88011fc83e70 ffffffff81114b1c ffff8801=
1fc93040
[  445.980698] Call Trace:
[  445.981351]  <IRQ>=20
[  445.981656]  [<ffffffff81063ae8>] flat_send_IPI_all+0x1f/0x4a
[  445.983150]  [<ffffffff81060d21>] arch_trigger_all_cpu_backtrace+0x52/0x=
84
[  445.984281]  [<ffffffff81114b1c>] rcu_check_callbacks+0x205/0x57f
[  445.985333]  [<ffffffff8111dcdd>] ? tick_sched_do_timer+0x2f/0x2f
[  445.991796]  [<ffffffff810d28d4>] update_process_times+0x3d/0x65
[  445.992835]  [<ffffffff8111dbed>] tick_sched_handle+0x37/0x43
[  445.993876]  [<ffffffff8111dd17>] tick_sched_timer+0x3a/0x58
[  445.994883]  [<ffffffff810e6129>] __run_hrtimer+0x96/0x19a
[  445.995869]  [<ffffffff810e6961>] hrtimer_interrupt+0xe8/0x1e3
[  445.996895]  [<ffffffff8105f691>] local_apic_timer_interrupt+0x54/0x57
[  445.998020]  [<ffffffff81a21841>] smp_apic_timer_interrupt+0x3f/0x50
[  445.999091]  [<ffffffff81a20532>] apic_timer_interrupt+0x72/0x80
[  446.000127]  <EOI>=20
[  446.000400]  [<ffffffff814fed42>] ? find_last_bit+0x4a/0x4a
[  446.001925]  [<ffffffff811716e0>] ? zone_watermark_ok_safe+0x61/0xad
[  446.003001]  [<ffffffff8117c77d>] zone_balanced+0x1e/0x43
[  446.003977]  [<ffffffff8117fda6>] balance_pgdat+0x32a/0x501
[  446.004970]  [<ffffffff811802bc>] kswapd+0x33f/0x3c7
[  446.005937]  [<ffffffff810fdbf5>] ? __wake_up_sync+0x12/0x12
[  446.006939]  [<ffffffff8117ff7d>] ? balance_pgdat+0x501/0x501
[  446.007952]  [<ffffffff810e3c1e>] kthread+0xdb/0xe3
[  446.008873]  [<ffffffff810e3b43>] ? kthread_create_on_node+0x16f/0x16f
[  446.009995]  [<ffffffff81a1f8bc>] ret_from_fork+0x7c/0xb0
[  446.010971]  [<ffffffff810e3b43>] ? kthread_create_on_node+0x16f/0x16f
[  446.012058] Code: eb f0 44 89 f0 c1 e0 18 89 04 25 10 33 5f ff 44 89 e0 =
44 09 e8 41 81 cd 00 04 00 00 41 83 fc 02 41 0f 44 c5 89 04 25 00 33 5f ff =
<f6> c7 02 75 11 48 89 df 57 9d 0f 1f 44 00 00 e8 5c 90 0e 00 eb=20
[  446.019555] NMI backtrace for cpu 3
[  446.020363] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[  446.022092] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  446.023128] task: ffff880119b26300 ti: ffff880119b48000 task.ti: ffff880=
119b48000
[  446.024723] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[  446.026495] RSP: 0018:ffff880119b49eb8  EFLAGS: 00000246
[  446.027481] RAX: 0000000000000000 RBX: ffff880119b49fd8 RCX: 00000000fff=
fffff
[  446.028702] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[  446.029970] RBP: ffff880119b49eb8 R08: 0000000000000000 R09: 00000000000=
00000
[  446.031192] R10: 0000000000000003 R11: 0000000000000400 R12: 00000000000=
00003
[  446.032411] R13: ffff880119b49fd8 R14: ffff880119b49fd8 R15: 00000000000=
00000
[  446.033632] FS:  0000000000000000(0000) GS:ffff88011fd80000(0000) knlGS:=
0000000000000000
[  446.035259] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  446.036295] CR2: 0000000000405c60 CR3: 000000007f470000 CR4: 00000000000=
006e0
[  446.037496] Stack:
[  446.038133]  ffff880119b49ed8 ffffffff81041811 ffff880119b49fd8 ffff8801=
19b49fd8
[  446.039964]  ffff880119b49ee8 ffffffff81041f3d ffff880119b49f30 ffffffff=
8110be4c
[  446.041815]  ffffffff8111bc52 92ed795e8031d18d 0000000000000000 00000000=
00000000
[  446.043642] Call Trace:
[  446.044311]  [<ffffffff81041811>] default_idle+0x38/0xc1
[  446.045321]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[  446.046345]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[  446.047403]  [<ffffffff8111bc52>] ? clockevents_register_device+0x112/0x=
117
[  446.048578]  [<ffffffff8105de31>] start_secondary+0x277/0x279
[  446.049645] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[  446.057337] NMI backtrace for cpu 2
[  446.058149] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[  446.059791] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  446.060822] task: ffff880119b25a00 ti: ffff880119b42000 task.ti: ffff880=
119b42000
[  446.062403] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[  446.064120] RSP: 0018:ffff880119b43eb8  EFLAGS: 00000246
[  446.065112] RAX: 0000000000000000 RBX: ffff880119b43fd8 RCX: 00000000fff=
fffff
[  446.066298] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[  446.067484] RBP: ffff880119b43eb8 R08: 0000000000000000 R09: 00000000000=
00000
[  446.068673] R10: 0000000000000002 R11: 0000000000000400 R12: 00000000000=
00002
[  446.069861] R13: ffff880119b43fd8 R14: ffff880119b43fd8 R15: 00000000000=
00000
[  446.071049] FS:  0000000000000000(0000) GS:ffff88011fd00000(0000) knlGS:=
0000000000000000
[  446.072710] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  446.073884] CR2: 00007f14d81ce000 CR3: 000000007f3f6000 CR4: 00000000000=
006e0
[  446.075192] Stack:
[  446.075875]  ffff880119b43ed8 ffffffff81041811 ffff880119b43fd8 ffff8801=
19b43fd8
[  446.077794]  ffff880119b43ee8 ffffffff81041f3d ffff880119b43f30 ffffffff=
8110be4c
[  446.079741]  ffffffff8111bc52 baab13b05212a163 0000000000000000 00000000=
00000000
[  446.081573] Call Trace:
[  446.082248]  [<ffffffff81041811>] default_idle+0x38/0xc1
[  446.083238]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[  446.084239]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[  446.085297]  [<ffffffff8111bc52>] ? clockevents_register_device+0x112/0x=
117
[  446.086470]  [<ffffffff8105de31>] start_secondary+0x277/0x279
[  446.087509] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[  446.095195] NMI backtrace for cpu 0
[  446.095206] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detecte=
d by 2, t=3D105077 jiffies, g=3D233, c=3D232, q=3D34671)
[  446.097845] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[  446.099434] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  446.100414] task: ffffffff82211440 ti: ffffffff82200000 task.ti: fffffff=
f82200000
[  446.101920] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[  446.103584] RSP: 0018:ffffffff82201ec8  EFLAGS: 00000246
[  446.104536] RAX: 0000000000000000 RBX: ffffffff82201fd8 RCX: 00000000fff=
fffff
[  446.105709] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[  446.106874] RBP: ffffffff82201ec8 R08: 0000000000000000 R09: 00000000000=
00000
[  446.108009] R10: 0000000000000000 R11: 0000000000000400 R12: 00000000000=
00000
[  446.109111] R13: ffffffff82201fd8 R14: ffffffff82201fd8 R15: 00000000fff=
fffff
[  446.110301] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:=
0000000000000000
[  446.111888] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  446.112851] CR2: 000000000223ea88 CR3: 000000007c4c1000 CR4: 00000000000=
006f0
[  446.114017] Stack:
[  446.114604]  ffffffff82201ee8 ffffffff81041811 ffffffff82201fd8 ffffffff=
82201fd8
[  446.116423]  ffffffff82201ef8 ffffffff81041f3d ffffffff82201f40 ffffffff=
8110be4c
[  446.118225]  ffff88011ffa3ec0 35ceeb7d84596041 ffffffffffffffff ffffffff=
823ef8d0
[  446.120025] Call Trace:
[  446.120715]  [<ffffffff81041811>] default_idle+0x38/0xc1
[  446.121723]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[  446.122748]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[  446.123797]  [<ffffffff81a022c3>] rest_init+0x87/0x89
[  446.124760]  [<ffffffff8234be04>] start_kernel+0x435/0x440
[  446.125741]  [<ffffffff8234b7dd>] ? repair_env_string+0x58/0x58
[  446.126725]  [<ffffffff8234b120>] ? early_idt_handlers+0x120/0x120
[  446.127773]  [<ffffffff8234b498>] x86_64_start_reservations+0x2a/0x2c
[  446.128812]  [<ffffffff8234b5d5>] x86_64_start_kernel+0x13b/0x148
[  446.129873] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[  446.137236] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 179.834 msecs
[  626.106775] INFO: rcu_sched self-detected stall on CPU { 1}  (t=3D150080=
 jiffies g=3D233 c=3D232 q=3D35391)
[  626.108514] sending NMI to all CPUs:
[  626.109249] NMI backtrace for cpu 1
[  626.110002] CPU: 1 PID: 696 Comm: kswapd0 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[  626.111572] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  626.112563] task: ffff8800bc718900 ti: ffff8800bc75c000 task.ti: ffff880=
0bc75c000
[  626.114075] RIP: 0010:[<ffffffff81063841>]  [<ffffffff81063841>] flat_se=
nd_IPI_mask+0x7e/0xac
[  626.115693] RSP: 0018:ffff88011fc83dd0  EFLAGS: 00010046
[  626.116603] RAX: 0000000000000c00 RBX: 0000000000000046 RCX: 00000000000=
07b80
[  626.117744] RDX: ffffffff82222120 RSI: 0000000000000002 RDI: 00000000000=
00300
[  626.118854] RBP: ffff88011fc83df0 R08: 0000000000000000 R09: 00000000000=
00000
[  626.119955] R10: 0000000000009ce0 R11: 0000000000000000 R12: 00000000000=
00002
[  626.121062] R13: 0000000000000c00 R14: 000000000000000f R15: 00000000000=
00001
[  626.122200] FS:  0000000000000000(0000) GS:ffff88011fc80000(0000) knlGS:=
0000000000000000
[  626.123780] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  626.124743] CR2: 00007fe45ab579a0 CR3: 000000000220c000 CR4: 00000000000=
006e0
[  626.125882] Stack:
[  626.126442]  0000000000002710 ffff88011fc8d800 0000000000000000 ffffffff=
8224de40
[  626.127999]  ffff88011fc83e00 ffffffff81063ae8 ffff88011fc83e18 ffffffff=
81060d21
[  626.129571]  ffffffff8224de40 ffff88011fc83e70 ffffffff81114b1c ffff8801=
1fc93040
[  626.131124] Call Trace:
[  626.131733]  <IRQ>=20
[  626.131956]  [<ffffffff81063ae8>] flat_send_IPI_all+0x1f/0x4a
[  626.133307]  [<ffffffff81060d21>] arch_trigger_all_cpu_backtrace+0x52/0x=
84
[  626.134416]  [<ffffffff81114b1c>] rcu_check_callbacks+0x205/0x57f
[  626.135416]  [<ffffffff8111dcdd>] ? tick_sched_do_timer+0x2f/0x2f
[  626.136420]  [<ffffffff810d28d4>] update_process_times+0x3d/0x65
[  626.137411]  [<ffffffff8111dbed>] tick_sched_handle+0x37/0x43
[  626.138404]  [<ffffffff8111dd17>] tick_sched_timer+0x3a/0x58
[  626.139360]  [<ffffffff810e6129>] __run_hrtimer+0x96/0x19a
[  626.140296]  [<ffffffff810e6961>] hrtimer_interrupt+0xe8/0x1e3
[  626.141273]  [<ffffffff8105f691>] local_apic_timer_interrupt+0x54/0x57
[  626.142353]  [<ffffffff81a21841>] smp_apic_timer_interrupt+0x3f/0x50
[  626.143386]  [<ffffffff81a20532>] apic_timer_interrupt+0x72/0x80
[  626.144388]  <EOI>=20
[  626.144609]  [<ffffffff8117fb3d>] ? balance_pgdat+0xc1/0x501
[  626.145985]  [<ffffffff8117ff4e>] ? balance_pgdat+0x4d2/0x501
[  626.146945]  [<ffffffff811802bc>] kswapd+0x33f/0x3c7
[  626.147826]  [<ffffffff810fdbf5>] ? __wake_up_sync+0x12/0x12
[  626.154189]  [<ffffffff8117ff7d>] ? balance_pgdat+0x501/0x501
[  626.155148]  [<ffffffff810e3c1e>] kthread+0xdb/0xe3
[  626.156020]  [<ffffffff810e3b43>] ? kthread_create_on_node+0x16f/0x16f
[  626.157068]  [<ffffffff81a1f8bc>] ret_from_fork+0x7c/0xb0
[  626.158023]  [<ffffffff810e3b43>] ? kthread_create_on_node+0x16f/0x16f
[  626.159070] Code: eb f0 44 89 f0 c1 e0 18 89 04 25 10 33 5f ff 44 89 e0 =
44 09 e8 41 81 cd 00 04 00 00 41 83 fc 02 41 0f 44 c5 89 04 25 00 33 5f ff =
<f6> c7 02 75 11 48 89 df 57 9d 0f 1f 44 00 00 e8 5c 90 0e 00 eb=20
[  626.163389] NMI backtrace for cpu 3
[  626.164168] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[  626.165811] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  626.166798] task: ffff880119b26300 ti: ffff880119b48000 task.ti: ffff880=
119b48000
[  626.168321] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[  626.169965] RSP: 0018:ffff880119b49eb8  EFLAGS: 00000246
[  626.170919] RAX: 0000000000000000 RBX: ffff880119b49fd8 RCX: 00000000fff=
fffff
[  626.172060] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[  626.173257] RBP: ffff880119b49eb8 R08: 0000000000000000 R09: 00000000000=
00000
[  626.174444] R10: 0000000000000003 R11: 0000000000000400 R12: 00000000000=
00003
[  626.175600] R13: ffff880119b49fd8 R14: ffff880119b49fd8 R15: 00000000000=
00000
[  626.176764] FS:  0000000000000000(0000) GS:ffff88011fd80000(0000) knlGS:=
0000000000000000
[  626.178392] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  626.179389] CR2: 0000000000405c60 CR3: 000000007f470000 CR4: 00000000000=
006e0
[  626.180533] Stack:
[  626.181111]  ffff880119b49ed8 ffffffff81041811 ffff880119b49fd8 ffff8801=
19b49fd8
[  626.182742]  ffff880119b49ee8 ffffffff81041f3d ffff880119b49f30 ffffffff=
8110be4c
[  626.184357]  ffffffff8111bc52 92ed795e8031d18d 0000000000000000 00000000=
00000000
[  626.185975] Call Trace:
[  626.186604]  [<ffffffff81041811>] default_idle+0x38/0xc1
[  626.187556]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[  626.188506]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[  626.189544]  [<ffffffff8111bc52>] ? clockevents_register_device+0x112/0x=
117
[  626.190729]  [<ffffffff8105de31>] start_secondary+0x277/0x279
[  626.191718] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[  626.196167] NMI backtrace for cpu 0
[  626.196174] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detecte=
d by 3, t=3D150102 jiffies, g=3D233, c=3D232, q=3D35391)
[  626.198773] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[  626.200358] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  626.201332] task: ffffffff82211440 ti: ffffffff82200000 task.ti: fffffff=
f82200000
[  626.202839] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[  626.204447] RSP: 0018:ffffffff82201ec8  EFLAGS: 00000246
[  626.205382] RAX: 0000000000000000 RBX: ffffffff82201fd8 RCX: 00000000fff=
fffff
[  626.206532] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[  626.207655] RBP: ffffffff82201ec8 R08: 0000000000000000 R09: 00000000000=
00000
[  626.208781] R10: 0000000000000000 R11: 0000000000000400 R12: 00000000000=
00000
[  626.209904] R13: ffffffff82201fd8 R14: ffffffff82201fd8 R15: 00000000fff=
fffff
[  626.211025] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:=
0000000000000000
[  626.212588] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  626.213576] CR2: 000000000223ea88 CR3: 000000007c4c1000 CR4: 00000000000=
006f0
[  626.214704] Stack:
[  626.215269]  ffffffff82201ee8 ffffffff81041811 ffffffff82201fd8 ffffffff=
82201fd8
[  626.216845]  ffffffff82201ef8 ffffffff81041f3d ffffffff82201f40 ffffffff=
8110be4c
[  626.218418]  ffff88011ffa3ec0 35ceeb7d84596041 ffffffffffffffff ffffffff=
823ef8d0
[  626.219992] Call Trace:
[  626.220612]  [<ffffffff81041811>] default_idle+0x38/0xc1
[  626.221568]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[  626.222509]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[  626.223503]  [<ffffffff81a022c3>] rest_init+0x87/0x89
[  626.224447]  [<ffffffff8234be04>] start_kernel+0x435/0x440
[  626.225401]  [<ffffffff8234b7dd>] ? repair_env_string+0x58/0x58
[  626.226398]  [<ffffffff8234b120>] ? early_idt_handlers+0x120/0x120
[  626.227429]  [<ffffffff8234b498>] x86_64_start_reservations+0x2a/0x2c
[  626.228487]  [<ffffffff8234b5d5>] x86_64_start_kernel+0x13b/0x148
[  626.229502] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[  626.233853] NMI backtrace for cpu 2
[  626.234600] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[  626.236204] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  626.237191] task: ffff880119b25a00 ti: ffff880119b42000 task.ti: ffff880=
119b42000
[  626.238729] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[  626.240346] RSP: 0018:ffff880119b43eb8  EFLAGS: 00000246
[  626.241289] RAX: 0000000000000000 RBX: ffff880119b43fd8 RCX: 00000000fff=
fffff
[  626.242425] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[  626.243558] RBP: ffff880119b43eb8 R08: 0000000000000000 R09: 00000000000=
00000
[  626.244704] R10: 0000000000000002 R11: 0000000000000400 R12: 00000000000=
00002
[  626.245842] R13: ffff880119b43fd8 R14: ffff880119b43fd8 R15: 00000000000=
00000
[  626.246976] FS:  0000000000000000(0000) GS:ffff88011fd00000(0000) knlGS:=
0000000000000000
[  626.248549] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  626.249535] CR2: 00007f14d81ce000 CR3: 000000007f3f6000 CR4: 00000000000=
006e0
[  626.250678] Stack:
[  626.251247]  ffff880119b43ed8 ffffffff81041811 ffff880119b43fd8 ffff8801=
19b43fd8
[  626.252835]  ffff880119b43ee8 ffffffff81041f3d ffff880119b43f30 ffffffff=
8110be4c
[  626.254438]  ffffffff8111bc52 baab13b05212a163 0000000000000000 00000000=
00000000
[  626.256023] Call Trace:
[  626.256647]  [<ffffffff81041811>] default_idle+0x38/0xc1
[  626.257586]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[  626.258536]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[  626.259544]  [<ffffffff8111bc52>] ? clockevents_register_device+0x112/0x=
117
[  626.260665]  [<ffffffff8105de31>] start_secondary+0x277/0x279
[  626.261646] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[  806.206775] INFO: rcu_sched self-detected stall on CPU { 1}  (t=3D195105=
 jiffies g=3D233 c=3D232 q=3D36107)
[  806.208433] sending NMI to all CPUs:
[  806.209134] NMI backtrace for cpu 1
[  806.209900] CPU: 1 PID: 696 Comm: kswapd0 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[  806.211487] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  806.212456] task: ffff8800bc718900 ti: ffff8800bc75c000 task.ti: ffff880=
0bc75c000
[  806.213977] RIP: 0010:[<ffffffff81063841>]  [<ffffffff81063841>] flat_se=
nd_IPI_mask+0x7e/0xac
[  806.215609] RSP: 0018:ffff88011fc83dd0  EFLAGS: 00010046
[  806.216533] RAX: 0000000000000c00 RBX: 0000000000000046 RCX: 00000000000=
09a80
[  806.217679] RDX: ffffffff82222120 RSI: 0000000000000002 RDI: 00000000000=
00300
[  806.218801] RBP: ffff88011fc83df0 R08: 0000000000000000 R09: 00000000000=
00000
[  806.219916] R10: 000000000000e2e0 R11: 0000000000000000 R12: 00000000000=
00002
[  806.221032] R13: 0000000000000c00 R14: 000000000000000f R15: 00000000000=
00001
[  806.222173] FS:  0000000000000000(0000) GS:ffff88011fc80000(0000) knlGS:=
0000000000000000
[  806.223716] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  806.224680] CR2: 00007fe45ab579a0 CR3: 000000000220c000 CR4: 00000000000=
006e0
[  806.225820] Stack:
[  806.226386]  0000000000002710 ffff88011fc8d800 0000000000000000 ffffffff=
8224de40
[  806.227944]  ffff88011fc83e00 ffffffff81063ae8 ffff88011fc83e18 ffffffff=
81060d21
[  806.229514]  ffffffff8224de40 ffff88011fc83e70 ffffffff81114b1c ffff8801=
1fc93040
[  806.231071] Call Trace:
[  806.231678]  <IRQ>=20
[  806.231907]  [<ffffffff81063ae8>] flat_send_IPI_all+0x1f/0x4a
[  806.233255]  [<ffffffff81060d21>] arch_trigger_all_cpu_backtrace+0x52/0x=
84
[  806.234377]  [<ffffffff81114b1c>] rcu_check_callbacks+0x205/0x57f
[  806.235379]  [<ffffffff8111dcdd>] ? tick_sched_do_timer+0x2f/0x2f
[  806.236377]  [<ffffffff810d28d4>] update_process_times+0x3d/0x65
[  806.237374]  [<ffffffff8111dbed>] tick_sched_handle+0x37/0x43
[  806.238368]  [<ffffffff8111dd17>] tick_sched_timer+0x3a/0x58
[  806.239325]  [<ffffffff810e6129>] __run_hrtimer+0x96/0x19a
[  806.240269]  [<ffffffff810e6961>] hrtimer_interrupt+0xe8/0x1e3
[  806.241247]  [<ffffffff8105f691>] local_apic_timer_interrupt+0x54/0x57
[  806.242327]  [<ffffffff81a21841>] smp_apic_timer_interrupt+0x3f/0x50
[  806.243362]  [<ffffffff81a20532>] apic_timer_interrupt+0x72/0x80
[  806.244345]  <EOI>=20
[  806.244568]  [<ffffffff810ec94e>] ? __might_sleep+0x5/0xfa
[  806.245934]  [<ffffffff8117ccd7>] ? shrink_slab+0x30e/0x326
[  806.246897]  [<ffffffff811bfaed>] ? mem_cgroup_iter+0x146/0x265
[  806.247878]  [<ffffffff811c5166>] ? vmpressure+0x21/0x76
[  806.248788]  [<ffffffff8117fdf1>] balance_pgdat+0x375/0x501
[  806.249761]  [<ffffffff811802bc>] kswapd+0x33f/0x3c7
[  806.250643]  [<ffffffff810fdbf5>] ? __wake_up_sync+0x12/0x12
[  806.251596]  [<ffffffff8117ff7d>] ? balance_pgdat+0x501/0x501
[  806.252561]  [<ffffffff810e3c1e>] kthread+0xdb/0xe3
[  806.253444]  [<ffffffff810e3b43>] ? kthread_create_on_node+0x16f/0x16f
[  806.254506]  [<ffffffff81a1f8bc>] ret_from_fork+0x7c/0xb0
[  806.255438]  [<ffffffff810e3b43>] ? kthread_create_on_node+0x16f/0x16f
[  806.256483] Code: eb f0 44 89 f0 c1 e0 18 89 04 25 10 33 5f ff 44 89 e0 =
44 09 e8 41 81 cd 00 04 00 00 41 83 fc 02 41 0f 44 c5 89 04 25 00 33 5f ff =
<f6> c7 02 75 11 48 89 df 57 9d 0f 1f 44 00 00 e8 5c 90 0e 00 eb=20
[  806.260809] NMI backtrace for cpu 3
[  806.261637] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[  806.263340] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  806.264390] task: ffff880119b26300 ti: ffff880119b48000 task.ti: ffff880=
119b48000
[  806.266017] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[  806.273593] RSP: 0018:ffff880119b49eb8  EFLAGS: 00000246
[  806.274587] RAX: 0000000000000000 RBX: ffff880119b49fd8 RCX: 00000000fff=
fffff
[  806.275852] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[  806.277064] RBP: ffff880119b49eb8 R08: 0000000000000000 R09: 00000000000=
00000
[  806.278304] R10: 0000000000000003 R11: 0000000000000400 R12: 00000000000=
00003
[  806.279509] R13: ffff880119b49fd8 R14: ffff880119b49fd8 R15: 00000000000=
00000
[  806.280721] FS:  0000000000000000(0000) GS:ffff88011fd80000(0000) knlGS:=
0000000000000000
[  806.282426] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  806.283467] CR2: 0000000000405c60 CR3: 000000007f470000 CR4: 00000000000=
006e0
[  806.284678] Stack:
[  806.285293]  ffff880119b49ed8 ffffffff81041811 ffff880119b49fd8 ffff8801=
19b49fd8
[  806.287007]  ffff880119b49ee8 ffffffff81041f3d ffff880119b49f30 ffffffff=
8110be4c
[  806.288692]  ffffffff8111bc52 92ed795e8031d18d 0000000000000000 00000000=
00000000
[  806.290409] Call Trace:
[  806.291073]  [<ffffffff81041811>] default_idle+0x38/0xc1
[  806.292072]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[  806.293131]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[  806.294221]  [<ffffffff8111bc52>] ? clockevents_register_device+0x112/0x=
117
[  806.295411]  [<ffffffff8105de31>] start_secondary+0x277/0x279
[  806.296456] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[  806.301185] NMI backtrace for cpu 0
[  806.301965] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[  806.303555] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  806.304530] task: ffffffff82211440 ti: ffffffff82200000 task.ti: fffffff=
f82200000
[  806.306057] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[  806.307667] RSP: 0018:ffffffff82201ec8  EFLAGS: 00000246
[  806.308608] RAX: 0000000000000000 RBX: ffffffff82201fd8 RCX: 00000000fff=
fffff
[  806.309768] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[  806.310901] RBP: ffffffff82201ec8 R08: 0000000000000000 R09: 00000000000=
00000
[  806.312028] R10: 00000001000249c2 R11: 0000000000000040 R12: 00000000000=
00000
[  806.313154] R13: ffffffff82201fd8 R14: ffffffff82201fd8 R15: 00000000fff=
fffff
[  806.314304] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:=
0000000000000000
[  806.315877] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  806.316857] CR2: 000000000223ea88 CR3: 000000007c4c1000 CR4: 00000000000=
006f0
[  806.318011] Stack:
[  806.318580]  ffffffff82201ee8 ffffffff81041811 ffffffff82201fd8 ffffffff=
82201fd8
[  806.320166]  ffffffff82201ef8 ffffffff81041f3d ffffffff82201f40 ffffffff=
8110be4c
[  806.321779]  ffff88011ffa3ec0 35ceeb7d84596041 ffffffffffffffff ffffffff=
823ef8d0
[  806.323361] Call Trace:
[  806.323993]  [<ffffffff81041811>] default_idle+0x38/0xc1
[  806.324919]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[  806.325892]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[  806.326891]  [<ffffffff81a022c3>] rest_init+0x87/0x89
[  806.327791]  [<ffffffff8234be04>] start_kernel+0x435/0x440
[  806.328743]  [<ffffffff8234b7dd>] ? repair_env_string+0x58/0x58
[  806.329768]  [<ffffffff8234b120>] ? early_idt_handlers+0x120/0x120
[  806.330794]  [<ffffffff8234b498>] x86_64_start_reservations+0x2a/0x2c
[  806.331855]  [<ffffffff8234b5d5>] x86_64_start_kernel+0x13b/0x148
[  806.332872] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[  806.337254] NMI backtrace for cpu 2
[  806.337261] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detecte=
d by 0, t=3D195137 jiffies, g=3D233, c=3D232, q=3D36107)
[  806.339887] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[  806.341481] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  806.342463] task: ffff880119b25a00 ti: ffff880119b42000 task.ti: ffff880=
119b42000
[  806.343974] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[  806.345589] RSP: 0018:ffff880119b43eb8  EFLAGS: 00000246
[  806.346525] RAX: 0000000000000000 RBX: ffff880119b43fd8 RCX: 00000000fff=
fffff
[  806.347661] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[  806.348803] RBP: ffff880119b43eb8 R08: 0000000000000000 R09: 00000000000=
00000
[  806.349970] R10: 0000000000000002 R11: 0000000000000400 R12: 00000000000=
00002
[  806.351106] R13: ffff880119b43fd8 R14: ffff880119b43fd8 R15: 00000000000=
00000
[  806.352243] FS:  0000000000000000(0000) GS:ffff88011fd00000(0000) knlGS:=
0000000000000000
[  806.353815] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  806.354799] CR2: 00007f14d81ce000 CR3: 000000007f3f6000 CR4: 00000000000=
006e0
[  806.355942] Stack:
[  806.356512]  ffff880119b43ed8 ffffffff81041811 ffff880119b43fd8 ffff8801=
19b43fd8
[  806.358100]  ffff880119b43ee8 ffffffff81041f3d ffff880119b43f30 ffffffff=
8110be4c
[  806.359676]  ffffffff8111bc52 baab13b05212a163 0000000000000000 00000000=
00000000
[  806.361260] Call Trace:
[  806.361886]  [<ffffffff81041811>] default_idle+0x38/0xc1
[  806.362821]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[  806.363766]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[  806.364768]  [<ffffffff8111bc52>] ? clockevents_register_device+0x112/0x=
117
[  806.365922]  [<ffffffff8105de31>] start_secondary+0x277/0x279
[  806.366911] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[  986.346777] INFO: rcu_sched self-detected stall on CPU { 1}  (t=3D240140=
 jiffies g=3D233 c=3D232 q=3D36827)
[  986.348571] sending NMI to all CPUs:
[  986.349324] NMI backtrace for cpu 1
[  986.350091] CPU: 1 PID: 696 Comm: kswapd0 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[  986.351712] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  986.352713] task: ffff8800bc718900 ti: ffff8800bc75c000 task.ti: ffff880=
0bc75c000
[  986.354247] RIP: 0010:[<ffffffff81063841>]  [<ffffffff81063841>] flat_se=
nd_IPI_mask+0x7e/0xac
[  986.355926] RSP: 0018:ffff88011fc83dd0  EFLAGS: 00010046
[  986.356890] RAX: 0000000000000c00 RBX: 0000000000000046 RCX: 00000000000=
0b9bc
[  986.358088] RDX: ffffffff82222120 RSI: 0000000000000002 RDI: 00000000000=
00300
[  986.359237] RBP: ffff88011fc83df0 R08: 0000000000000000 R09: 00000000000=
00000
[  986.360393] R10: 0000000000002c60 R11: 0000000000000000 R12: 00000000000=
00002
[  986.361540] R13: 0000000000000c00 R14: 000000000000000f R15: 00000000000=
00001
[  986.362695] FS:  0000000000000000(0000) GS:ffff88011fc80000(0000) knlGS:=
0000000000000000
[  986.364299] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  986.365298] CR2: 00007fe45ab579a0 CR3: 000000000220c000 CR4: 00000000000=
006e0
[  986.366444] Stack:
[  986.367028]  0000000000002710 ffff88011fc8d800 0000000000000000 ffffffff=
8224de40
[  986.368632]  ffff88011fc83e00 ffffffff81063ae8 ffff88011fc83e18 ffffffff=
81060d21
[  986.370236]  ffffffff8224de40 ffff88011fc83e70 ffffffff81114b1c ffff8801=
1fc93040
[  986.371843] Call Trace:
[  986.372474]  <IRQ>=20
[  986.372703]  [<ffffffff81063ae8>] flat_send_IPI_all+0x1f/0x4a
[  986.374113]  [<ffffffff81060d21>] arch_trigger_all_cpu_backtrace+0x52/0x=
84
[  986.375248]  [<ffffffff81114b1c>] rcu_check_callbacks+0x205/0x57f
[  986.376299]  [<ffffffff8111dcdd>] ? tick_sched_do_timer+0x2f/0x2f
[  986.377336]  [<ffffffff810d28d4>] update_process_times+0x3d/0x65
[  986.378370]  [<ffffffff8111dbed>] tick_sched_handle+0x37/0x43
[  986.379372]  [<ffffffff8111dd17>] tick_sched_timer+0x3a/0x58
[  986.380363]  [<ffffffff810e6129>] __run_hrtimer+0x96/0x19a
[  986.381338]  [<ffffffff810e6961>] hrtimer_interrupt+0xe8/0x1e3
[  986.382354]  [<ffffffff8105f691>] local_apic_timer_interrupt+0x54/0x57
[  986.383438]  [<ffffffff81a21841>] smp_apic_timer_interrupt+0x3f/0x50
[  986.384524]  [<ffffffff81a20532>] apic_timer_interrupt+0x72/0x80
[  986.385559]  <EOI>=20
[  986.385788]  [<ffffffff8117edc2>] ? shrink_lruvec+0x58c/0x59e
[  986.387195]  [<ffffffff81a17bfd>] ? _raw_spin_lock+0x1a/0x34
[  986.388196]  [<ffffffff8132c300>] nfsd_reply_cache_count+0x15/0x2d
[  986.389236]  [<ffffffff8117cac5>] shrink_slab+0xfc/0x326
[  986.390189]  [<ffffffff811bfaed>] ? mem_cgroup_iter+0x146/0x265
[  986.391200]  [<ffffffff811c5166>] ? vmpressure+0x21/0x76
[  986.392149]  [<ffffffff8117fdf1>] balance_pgdat+0x375/0x501
[  986.393126]  [<ffffffff811802bc>] kswapd+0x33f/0x3c7
[  986.394037]  [<ffffffff810fdbf5>] ? __wake_up_sync+0x12/0x12
[  986.395025]  [<ffffffff8117ff7d>] ? balance_pgdat+0x501/0x501
[  986.396022]  [<ffffffff810e3c1e>] kthread+0xdb/0xe3
[  986.396924]  [<ffffffff810e3b43>] ? kthread_create_on_node+0x16f/0x16f
[  986.398015]  [<ffffffff81a1f8bc>] ret_from_fork+0x7c/0xb0
[  986.398968]  [<ffffffff810e3b43>] ? kthread_create_on_node+0x16f/0x16f
[  986.400049] Code: eb f0 44 89 f0 c1 e0 18 89 04 25 10 33 5f ff 44 89 e0 =
44 09 e8 41 81 cd 00 04 00 00 41 83 fc 02 41 0f 44 c5 89 04 25 00 33 5f ff =
<f6> c7 02 75 11 48 89 df 57 9d 0f 1f 44 00 00 e8 5c 90 0e 00 eb=20
[  986.404497] NMI backtrace for cpu 3
[  986.405317] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[  986.407016] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  986.408052] task: ffff880119b26300 ti: ffff880119b48000 task.ti: ffff880=
119b48000
[  986.409626] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[  986.411308] RSP: 0018:ffff880119b49eb8  EFLAGS: 00000246
[  986.412281] RAX: 0000000000000000 RBX: ffff880119b49fd8 RCX: 00000000fff=
fffff
[  986.413503] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[  986.414696] RBP: ffff880119b49eb8 R08: 0000000000000000 R09: 00000000000=
00000
[  986.415897] R10: 0000000000000003 R11: 0000000000000400 R12: 00000000000=
00003
[  986.417100] R13: ffff880119b49fd8 R14: ffff880119b49fd8 R15: 00000000000=
00000
[  986.418293] FS:  0000000000000000(0000) GS:ffff88011fd80000(0000) knlGS:=
0000000000000000
[  986.419934] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  986.420961] CR2: 0000000000405c60 CR3: 000000007f470000 CR4: 00000000000=
006e0
[  986.422179] Stack:
[  986.422768]  ffff880119b49ed8 ffffffff81041811 ffff880119b49fd8 ffff8801=
19b49fd8
[  986.430311]  ffff880119b49ee8 ffffffff81041f3d ffff880119b49f30 ffffffff=
8110be4c
[  986.431964]  ffffffff8111bc52 92ed795e8031d18d 0000000000000000 00000000=
00000000
[  986.433614] Call Trace:
[  986.434307]  [<ffffffff81041811>] default_idle+0x38/0xc1
[  986.435291]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[  986.436290]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[  986.437338]  [<ffffffff8111bc52>] ? clockevents_register_device+0x112/0x=
117
[  986.438516]  [<ffffffff8105de31>] start_secondary+0x277/0x279
[  986.439557] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[  986.444158] NMI backtrace for cpu 2
[  986.444176] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detecte=
d by 3, t=3D240164 jiffies, g=3D233, c=3D232, q=3D36827)
[  986.446899] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[  986.448570] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  986.449597] task: ffff880119b25a00 ti: ffff880119b42000 task.ti: ffff880=
119b42000
[  986.451170] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[  986.452839] RSP: 0018:ffff880119b43eb8  EFLAGS: 00000246
[  986.453811] RAX: 0000000000000000 RBX: ffff880119b43fd8 RCX: 00000000fff=
fffff
[  986.455007] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[  986.456185] RBP: ffff880119b43eb8 R08: 0000000000000000 R09: 00000000000=
00000
[  986.457360] R10: 0000000000000002 R11: 0000000000000400 R12: 00000000000=
00002
[  986.458582] R13: ffff880119b43fd8 R14: ffff880119b43fd8 R15: 00000000000=
00000
[  986.459777] FS:  0000000000000000(0000) GS:ffff88011fd00000(0000) knlGS:=
0000000000000000
[  986.461428] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  986.462443] CR2: 00007f14d81ce000 CR3: 000000007f3f6000 CR4: 00000000000=
006e0
[  986.463628] Stack:
[  986.464221]  ffff880119b43ed8 ffffffff81041811 ffff880119b43fd8 ffff8801=
19b43fd8
[  986.465860]  ffff880119b43ee8 ffffffff81041f3d ffff880119b43f30 ffffffff=
8110be4c
[  986.467504]  ffffffff8111bc52 baab13b05212a163 0000000000000000 00000000=
00000000
[  986.469148] Call Trace:
[  986.469793]  [<ffffffff81041811>] default_idle+0x38/0xc1
[  986.470788]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[  986.471769]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[  986.472817]  [<ffffffff8111bc52>] ? clockevents_register_device+0x112/0x=
117
[  986.473971]  [<ffffffff8105de31>] start_secondary+0x277/0x279
[  986.475005] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[  986.479547] NMI backtrace for cpu 0
[  986.480334] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[  986.481991] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  986.483004] task: ffffffff82211440 ti: ffffffff82200000 task.ti: fffffff=
f82200000
[  986.484547] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[  986.486197] RSP: 0018:ffffffff82201ec8  EFLAGS: 00000246
[  986.487155] RAX: 0000000000000000 RBX: ffffffff82201fd8 RCX: 00000000fff=
fffff
[  986.488323] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[  986.489488] RBP: ffffffff82201ec8 R08: 0000000000000000 R09: 00000000000=
00000
[  986.490659] R10: 0000000000000000 R11: 0000000000000400 R12: 00000000000=
00000
[  986.491825] R13: ffffffff82201fd8 R14: ffffffff82201fd8 R15: 00000000fff=
fffff
[  986.492990] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:=
0000000000000000
[  986.494614] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  986.495627] CR2: 000000000223ea88 CR3: 000000007c4c1000 CR4: 00000000000=
006f0
[  986.496801] Stack:
[  986.497402]  ffffffff82201ee8 ffffffff81041811 ffffffff82201fd8 ffffffff=
82201fd8
[  986.499029]  ffffffff82201ef8 ffffffff81041f3d ffffffff82201f40 ffffffff=
8110be4c
[  986.500652]  ffff88011ffa3ec0 35ceeb7d84596041 ffffffffffffffff ffffffff=
823ef8d0
[  986.502291] Call Trace:
[  986.502935]  [<ffffffff81041811>] default_idle+0x38/0xc1
[  986.503899]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[  986.504889]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[  986.505933]  [<ffffffff81a022c3>] rest_init+0x87/0x89
[  986.506881]  [<ffffffff8234be04>] start_kernel+0x435/0x440
[  986.507872]  [<ffffffff8234b7dd>] ? repair_env_string+0x58/0x58
[  986.508905]  [<ffffffff8234b120>] ? early_idt_handlers+0x120/0x120
[  986.509973]  [<ffffffff8234b498>] x86_64_start_reservations+0x2a/0x2c
[  986.511070]  [<ffffffff8234b5d5>] x86_64_start_kernel+0x13b/0x148
[  986.512127] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[ 1166.454775] INFO: rcu_sched self-detected stall on CPU { 1}  (t=3D285167=
 jiffies g=3D233 c=3D232 q=3D37547)
[ 1166.456382] sending NMI to all CPUs:
[ 1166.457064] NMI backtrace for cpu 1
[ 1166.457827] CPU: 1 PID: 696 Comm: kswapd0 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[ 1166.459412] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1166.460384] task: ffff8800bc718900 ti: ffff8800bc75c000 task.ti: ffff880=
0bc75c000
[ 1166.461895] RIP: 0010:[<ffffffff81063841>]  [<ffffffff81063841>] flat_se=
nd_IPI_mask+0x7e/0xac
[ 1166.463525] RSP: 0018:ffff88011fc83dd0  EFLAGS: 00010046
[ 1166.464447] RAX: 0000000000000c00 RBX: 0000000000000046 RCX: 00000000000=
0d90a
[ 1166.465595] RDX: ffffffff82222120 RSI: 0000000000000002 RDI: 00000000000=
00300
[ 1166.466714] RBP: ffff88011fc83df0 R08: 0000000000000000 R09: 00000000000=
00000
[ 1166.467833] R10: 00000000000076c0 R11: 0000000000000000 R12: 00000000000=
00002
[ 1166.468951] R13: 0000000000000c00 R14: 000000000000000f R15: 00000000000=
00001
[ 1166.470098] FS:  0000000000000000(0000) GS:ffff88011fc80000(0000) knlGS:=
0000000000000000
[ 1166.471652] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1166.472619] CR2: 00007fe45ab579a0 CR3: 000000000220c000 CR4: 00000000000=
006e0
[ 1166.473766] Stack:
[ 1166.474330]  0000000000002710 ffff88011fc8d800 0000000000000000 ffffffff=
8224de40
[ 1166.475880]  ffff88011fc83e00 ffffffff81063ae8 ffff88011fc83e18 ffffffff=
81060d21
[ 1166.477447]  ffffffff8224de40 ffff88011fc83e70 ffffffff81114b1c ffff8801=
1fc93040
[ 1166.479037] Call Trace:
[ 1166.479649]  <IRQ>=20
[ 1166.479872]  [<ffffffff81063ae8>] flat_send_IPI_all+0x1f/0x4a
[ 1166.481248]  [<ffffffff81060d21>] arch_trigger_all_cpu_backtrace+0x52/0x=
84
[ 1166.482363]  [<ffffffff81114b1c>] rcu_check_callbacks+0x205/0x57f
[ 1166.483366]  [<ffffffff8111dcdd>] ? tick_sched_do_timer+0x2f/0x2f
[ 1166.484376]  [<ffffffff810d28d4>] update_process_times+0x3d/0x65
[ 1166.485375]  [<ffffffff8111dbed>] tick_sched_handle+0x37/0x43
[ 1166.486376]  [<ffffffff8111dd17>] tick_sched_timer+0x3a/0x58
[ 1166.487338]  [<ffffffff810e6129>] __run_hrtimer+0x96/0x19a
[ 1166.488278]  [<ffffffff810e6961>] hrtimer_interrupt+0xe8/0x1e3
[ 1166.489252]  [<ffffffff8105f691>] local_apic_timer_interrupt+0x54/0x57
[ 1166.490329]  [<ffffffff81a21841>] smp_apic_timer_interrupt+0x3f/0x50
[ 1166.491359]  [<ffffffff81a20532>] apic_timer_interrupt+0x72/0x80
[ 1166.492354]  <EOI>=20
[ 1166.492578]  [<ffffffff81a17be3>] ? _raw_write_unlock_bh+0x20/0x20
[ 1166.494016]  [<ffffffff8118caac>] ? list_lru_count_node+0x1c/0x57
[ 1166.495024]  [<ffffffff811cc363>] super_cache_count+0x64/0xba
[ 1166.495988]  [<ffffffff8117cac5>] shrink_slab+0xfc/0x326
[ 1166.496908]  [<ffffffff811bfaed>] ? mem_cgroup_iter+0x146/0x265
[ 1166.497921]  [<ffffffff811c5166>] ? vmpressure+0x21/0x76
[ 1166.498838]  [<ffffffff8117fdf1>] balance_pgdat+0x375/0x501
[ 1166.499788]  [<ffffffff811802bc>] kswapd+0x33f/0x3c7
[ 1166.500670]  [<ffffffff810fdbf5>] ? __wake_up_sync+0x12/0x12
[ 1166.501654]  [<ffffffff8117ff7d>] ? balance_pgdat+0x501/0x501
[ 1166.502621]  [<ffffffff810e3c1e>] kthread+0xdb/0xe3
[ 1166.503497]  [<ffffffff810e3b43>] ? kthread_create_on_node+0x16f/0x16f
[ 1166.504546]  [<ffffffff81a1f8bc>] ret_from_fork+0x7c/0xb0
[ 1166.505489]  [<ffffffff810e3b43>] ? kthread_create_on_node+0x16f/0x16f
[ 1166.506549] Code: eb f0 44 89 f0 c1 e0 18 89 04 25 10 33 5f ff 44 89 e0 =
44 09 e8 41 81 cd 00 04 00 00 41 83 fc 02 41 0f 44 c5 89 04 25 00 33 5f ff =
<f6> c7 02 75 11 48 89 df 57 9d 0f 1f 44 00 00 e8 5c 90 0e 00 eb=20
[ 1166.510875] NMI backtrace for cpu 3
[ 1166.511632] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[ 1166.513242] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1166.514253] task: ffff880119b26300 ti: ffff880119b48000 task.ti: ffff880=
119b48000
[ 1166.515770] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[ 1166.517387] RSP: 0018:ffff880119b49eb8  EFLAGS: 00000246
[ 1166.518349] RAX: 0000000000000000 RBX: ffff880119b49fd8 RCX: 00000000fff=
fffff
[ 1166.519486] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[ 1166.520622] RBP: ffff880119b49eb8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1166.521793] R10: 0000000000000003 R11: 0000000000000400 R12: 00000000000=
00003
[ 1166.522934] R13: ffff880119b49fd8 R14: ffff880119b49fd8 R15: 00000000000=
00000
[ 1166.524068] FS:  0000000000000000(0000) GS:ffff88011fd80000(0000) knlGS:=
0000000000000000
[ 1166.525678] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1166.526659] CR2: 0000000000405c60 CR3: 000000007f470000 CR4: 00000000000=
006e0
[ 1166.527799] Stack:
[ 1166.528375]  ffff880119b49ed8 ffffffff81041811 ffff880119b49fd8 ffff8801=
19b49fd8
[ 1166.529981]  ffff880119b49ee8 ffffffff81041f3d ffff880119b49f30 ffffffff=
8110be4c
[ 1166.531570]  ffffffff8111bc52 92ed795e8031d18d 0000000000000000 00000000=
00000000
[ 1166.533163] Call Trace:
[ 1166.533810]  [<ffffffff81041811>] default_idle+0x38/0xc1
[ 1166.534750]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[ 1166.535701]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[ 1166.536703]  [<ffffffff8111bc52>] ? clockevents_register_device+0x112/0x=
117
[ 1166.537853]  [<ffffffff8105de31>] start_secondary+0x277/0x279
[ 1166.538835] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[ 1166.548739] NMI backtrace for cpu 2
[ 1166.549500] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[ 1166.551099] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1166.552081] task: ffff880119b25a00 ti: ffff880119b42000 task.ti: ffff880=
119b42000
[ 1166.553589] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[ 1166.555208] RSP: 0018:ffff880119b43eb8  EFLAGS: 00000246
[ 1166.556143] RAX: 0000000000000000 RBX: ffff880119b43fd8 RCX: 00000000fff=
fffff
[ 1166.557281] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[ 1166.558445] RBP: ffff880119b43eb8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1166.559585] R10: 0000000000000002 R11: 0000000000000400 R12: 00000000000=
00002
[ 1166.560723] R13: ffff880119b43fd8 R14: ffff880119b43fd8 R15: 00000000000=
00000
[ 1166.561857] FS:  0000000000000000(0000) GS:ffff88011fd00000(0000) knlGS:=
0000000000000000
[ 1166.563434] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1166.564417] CR2: 00007f14d81ce000 CR3: 000000007f3f6000 CR4: 00000000000=
006e0
[ 1166.565561] Stack:
[ 1166.566132]  ffff880119b43ed8 ffffffff81041811 ffff880119b43fd8 ffff8801=
19b43fd8
[ 1166.567715]  ffff880119b43ee8 ffffffff81041f3d ffff880119b43f30 ffffffff=
8110be4c
[ 1166.569300]  ffffffff8111bc52 baab13b05212a163 0000000000000000 00000000=
00000000
[ 1166.570882] Call Trace:
[ 1166.571512]  [<ffffffff81041811>] default_idle+0x38/0xc1
[ 1166.572453]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[ 1166.573401]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[ 1166.574433]  [<ffffffff8111bc52>] ? clockevents_register_device+0x112/0x=
117
[ 1166.575549]  [<ffffffff8105de31>] start_secondary+0x277/0x279
[ 1166.576534] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[ 1166.580924] NMI backtrace for cpu 0
[ 1166.580930] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detecte=
d by 2, t=3D285198 jiffies, g=3D233, c=3D232, q=3D37547)
[ 1166.583453] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[ 1166.584950] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1166.585896] task: ffffffff82211440 ti: ffffffff82200000 task.ti: fffffff=
f82200000
[ 1166.587334] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[ 1166.588848] RSP: 0018:ffffffff82201ec8  EFLAGS: 00000246
[ 1166.589753] RAX: 0000000000000000 RBX: ffffffff82201fd8 RCX: 00000000fff=
fffff
[ 1166.590827] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[ 1166.591897] RBP: ffffffff82201ec8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1166.592956] R10: 0000000100036eba R11: 0000000000000040 R12: 00000000000=
00000
[ 1166.594041] R13: ffffffff82201fd8 R14: ffffffff82201fd8 R15: 00000000fff=
fffff
[ 1166.595137] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:=
0000000000000000
[ 1166.596612] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1166.597565] CR2: 000000000223ea88 CR3: 000000007c4c1000 CR4: 00000000000=
006f0
[ 1166.598631] Stack:
[ 1166.599199]  ffffffff82201ee8 ffffffff81041811 ffffffff82201fd8 ffffffff=
82201fd8
[ 1166.600676]  ffffffff82201ef8 ffffffff81041f3d ffffffff82201f40 ffffffff=
8110be4c
[ 1166.602183]  ffff88011ffa3ec0 35ceeb7d84596041 ffffffffffffffff ffffffff=
823ef8d0
[ 1166.603687] Call Trace:
[ 1166.604272]  [<ffffffff81041811>] default_idle+0x38/0xc1
[ 1166.605143]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[ 1166.606055]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[ 1166.607020]  [<ffffffff81a022c3>] rest_init+0x87/0x89
[ 1166.607870]  [<ffffffff8234be04>] start_kernel+0x435/0x440
[ 1166.608766]  [<ffffffff8234b7dd>] ? repair_env_string+0x58/0x58
[ 1166.609731]  [<ffffffff8234b120>] ? early_idt_handlers+0x120/0x120
[ 1166.610692]  [<ffffffff8234b498>] x86_64_start_reservations+0x2a/0x2c
[ 1166.611707]  [<ffffffff8234b5d5>] x86_64_start_kernel+0x13b/0x148
[ 1166.612662] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[ 1346.590777] INFO: rcu_sched self-detected stall on CPU { 1}  (t=3D330201=
 jiffies g=3D233 c=3D232 q=3D38267)
[ 1346.592621] sending NMI to all CPUs:
[ 1346.593378] NMI backtrace for cpu 1
[ 1346.594126] CPU: 1 PID: 696 Comm: kswapd0 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[ 1346.595789] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1346.596794] task: ffff8800bc718900 ti: ffff8800bc75c000 task.ti: ffff880=
0bc75c000
[ 1346.598355] RIP: 0010:[<ffffffff81063841>]  [<ffffffff81063841>] flat_se=
nd_IPI_mask+0x7e/0xac
[ 1346.600041] RSP: 0018:ffff88011fc83dd0  EFLAGS: 00010046
[ 1346.601009] RAX: 0000000000000c00 RBX: 0000000000000046 RCX: 00000000000=
0f858
[ 1346.602170] RDX: ffffffff82222120 RSI: 0000000000000002 RDI: 00000000000=
00300
[ 1346.603362] RBP: ffff88011fc83df0 R08: 0000000000000000 R09: 00000000000=
00000
[ 1346.604527] R10: 000000000000c120 R11: 0000000000000000 R12: 00000000000=
00002
[ 1346.605687] R13: 0000000000000c00 R14: 000000000000000f R15: 00000000000=
00001
[ 1346.606848] FS:  0000000000000000(0000) GS:ffff88011fc80000(0000) knlGS:=
0000000000000000
[ 1346.608480] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1346.609490] CR2: 00007fe45ab579a0 CR3: 000000000220c000 CR4: 00000000000=
006e0
[ 1346.610662] Stack:
[ 1346.611238]  0000000000002710 ffff88011fc8d800 0000000000000000 ffffffff=
8224de40
[ 1346.612870]  ffff88011fc83e00 ffffffff81063ae8 ffff88011fc83e18 ffffffff=
81060d21
[ 1346.614492]  ffffffff8224de40 ffff88011fc83e70 ffffffff81114b1c ffff8801=
1fc93040
[ 1346.616114] Call Trace:
[ 1346.616763]  <IRQ>=20
[ 1346.616994]  [<ffffffff81063ae8>] flat_send_IPI_all+0x1f/0x4a
[ 1346.618424]  [<ffffffff81060d21>] arch_trigger_all_cpu_backtrace+0x52/0x=
84
[ 1346.619555]  [<ffffffff81114b1c>] rcu_check_callbacks+0x205/0x57f
[ 1346.620607]  [<ffffffff8111dcdd>] ? tick_sched_do_timer+0x2f/0x2f
[ 1346.621659]  [<ffffffff810d28d4>] update_process_times+0x3d/0x65
[ 1346.622704]  [<ffffffff8111dbed>] tick_sched_handle+0x37/0x43
[ 1346.623712]  [<ffffffff8111dd17>] tick_sched_timer+0x3a/0x58
[ 1346.624713]  [<ffffffff810e6129>] __run_hrtimer+0x96/0x19a
[ 1346.625694]  [<ffffffff810e6961>] hrtimer_interrupt+0xe8/0x1e3
[ 1346.626711]  [<ffffffff8105f691>] local_apic_timer_interrupt+0x54/0x57
[ 1346.627806]  [<ffffffff81a21841>] smp_apic_timer_interrupt+0x3f/0x50
[ 1346.628884]  [<ffffffff81a20532>] apic_timer_interrupt+0x72/0x80
[ 1346.629922]  <EOI>=20
[ 1346.630150]  [<ffffffff8117edc2>] ? shrink_lruvec+0x58c/0x59e
[ 1346.631589]  [<ffffffff81a17bfd>] ? _raw_spin_lock+0x1a/0x34
[ 1346.632596]  [<ffffffff81213a54>] mb_cache_shrink_count+0x15/0x6c
[ 1346.633634]  [<ffffffff8117cac5>] shrink_slab+0xfc/0x326
[ 1346.634598]  [<ffffffff811bfaed>] ? mem_cgroup_iter+0x146/0x265
[ 1346.635629]  [<ffffffff811c5166>] ? vmpressure+0x21/0x76
[ 1346.636586]  [<ffffffff8117fdf1>] balance_pgdat+0x375/0x501
[ 1346.637572]  [<ffffffff811802bc>] kswapd+0x33f/0x3c7
[ 1346.638496]  [<ffffffff810fdbf5>] ? __wake_up_sync+0x12/0x12
[ 1346.639496]  [<ffffffff8117ff7d>] ? balance_pgdat+0x501/0x501
[ 1346.640507]  [<ffffffff810e3c1e>] kthread+0xdb/0xe3
[ 1346.641421]  [<ffffffff810e3b43>] ? kthread_create_on_node+0x16f/0x16f
[ 1346.642515]  [<ffffffff81a1f8bc>] ret_from_fork+0x7c/0xb0
[ 1346.643485]  [<ffffffff810e3b43>] ? kthread_create_on_node+0x16f/0x16f
[ 1346.644582] Code: eb f0 44 89 f0 c1 e0 18 89 04 25 10 33 5f ff 44 89 e0 =
44 09 e8 41 81 cd 00 04 00 00 41 83 fc 02 41 0f 44 c5 89 04 25 00 33 5f ff =
<f6> c7 02 75 11 48 89 df 57 9d 0f 1f 44 00 00 e8 5c 90 0e 00 eb=20
[ 1346.649050] NMI backtrace for cpu 2
[ 1346.649832] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[ 1346.651511] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1346.652538] task: ffff880119b25a00 ti: ffff880119b42000 task.ti: ffff880=
119b42000
[ 1346.654104] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[ 1346.655784] RSP: 0018:ffff880119b43eb8  EFLAGS: 00000246
[ 1346.656754] RAX: 0000000000000000 RBX: ffff880119b43fd8 RCX: 00000000fff=
fffff
[ 1346.657940] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[ 1346.659116] RBP: ffff880119b43eb8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1346.660299] R10: 0000000000000002 R11: 0000000000000400 R12: 00000000000=
00002
[ 1346.661481] R13: ffff880119b43fd8 R14: ffff880119b43fd8 R15: 00000000000=
00000
[ 1346.662652] FS:  0000000000000000(0000) GS:ffff88011fd00000(0000) knlGS:=
0000000000000000
[ 1346.664285] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1346.665296] CR2: 00007f14d81ce000 CR3: 000000007f3f6000 CR4: 00000000000=
006e0
[ 1346.666487] Stack:
[ 1346.667074]  ffff880119b43ed8 ffffffff81041811 ffff880119b43fd8 ffff8801=
19b43fd8
[ 1346.668716]  ffff880119b43ee8 ffffffff81041f3d ffff880119b43f30 ffffffff=
8110be4c
[ 1346.670356]  ffffffff8111bc52 baab13b05212a163 0000000000000000 00000000=
00000000
[ 1346.671996] Call Trace:
[ 1346.672651]  [<ffffffff81041811>] default_idle+0x38/0xc1
[ 1346.673621]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[ 1346.674602]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[ 1346.675649]  [<ffffffff8111bc52>] ? clockevents_register_device+0x112/0x=
117
[ 1346.676816]  [<ffffffff8105de31>] start_secondary+0x277/0x279
[ 1346.677836] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[ 1346.682400] NMI backtrace for cpu 3
[ 1346.683180] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[ 1346.684883] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1346.685930] task: ffff880119b26300 ti: ffff880119b48000 task.ti: ffff880=
119b48000
[ 1346.687522] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[ 1346.689156] RSP: 0018:ffff880119b49eb8  EFLAGS: 00000246
[ 1346.690149] RAX: 0000000000000000 RBX: ffff880119b49fd8 RCX: 00000000fff=
fffff
[ 1346.696920] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[ 1346.698103] RBP: ffff880119b49eb8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1346.699290] R10: 0000000000000003 R11: 0000000000000400 R12: 00000000000=
00003
[ 1346.700485] R13: ffff880119b49fd8 R14: ffff880119b49fd8 R15: 00000000000=
00000
[ 1346.701662] FS:  0000000000000000(0000) GS:ffff88011fd80000(0000) knlGS:=
0000000000000000
[ 1346.703290] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1346.704303] CR2: 0000000000405c60 CR3: 000000007f470000 CR4: 00000000000=
006e0
[ 1346.705489] Stack:
[ 1346.706076]  ffff880119b49ed8 ffffffff81041811 ffff880119b49fd8 ffff8801=
19b49fd8
[ 1346.707716]  ffff880119b49ee8 ffffffff81041f3d ffff880119b49f30 ffffffff=
8110be4c
[ 1346.709351]  ffffffff8111bc52 92ed795e8031d18d 0000000000000000 00000000=
00000000
[ 1346.710982] Call Trace:
[ 1346.711630]  [<ffffffff81041811>] default_idle+0x38/0xc1
[ 1346.712600]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[ 1346.713579]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[ 1346.714615]  [<ffffffff8111bc52>] ? clockevents_register_device+0x112/0x=
117
[ 1346.715777]  [<ffffffff8105de31>] start_secondary+0x277/0x279
[ 1346.716796] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[ 1346.721380] NMI backtrace for cpu 0
[ 1346.721390] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detecte=
d by 3, t=3D330233 jiffies, g=3D233, c=3D232, q=3D38267)
[ 1346.726230] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[ 1346.729191] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1346.731011] task: ffffffff82211440 ti: ffffffff82200000 task.ti: fffffff=
f82200000
[ 1346.733785] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[ 1346.736715] RSP: 0018:ffffffff82201ec8  EFLAGS: 00000246
[ 1346.738417] RAX: 0000000000000000 RBX: ffffffff82201fd8 RCX: 00000000fff=
fffff
[ 1346.740451] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[ 1346.742471] RBP: ffffffff82201ec8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1346.744483] R10: 00000001000493b2 R11: 0000000000000040 R12: 00000000000=
00000
[ 1346.746505] R13: ffffffff82201fd8 R14: ffffffff82201fd8 R15: 00000000fff=
fffff
[ 1346.748531] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:=
0000000000000000
[ 1346.750557] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1346.751734] CR2: 000000000223ea88 CR3: 000000007c4c1000 CR4: 00000000000=
006f0
[ 1346.752911] Stack:
[ 1346.753505]  ffffffff82201ee8 ffffffff81041811 ffffffff82201fd8 ffffffff=
82201fd8
[ 1346.755125]  ffffffff82201ef8 ffffffff81041f3d ffffffff82201f40 ffffffff=
8110be4c
[ 1346.756759]  ffff88011ffa3ec0 35ceeb7d84596041 ffffffffffffffff ffffffff=
823ef8d0
[ 1346.758398] Call Trace:
[ 1346.759043]  [<ffffffff81041811>] default_idle+0x38/0xc1
[ 1346.760008]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[ 1346.760993]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[ 1346.762043]  [<ffffffff81a022c3>] rest_init+0x87/0x89
[ 1346.763269]  [<ffffffff8234be04>] start_kernel+0x435/0x440
[ 1346.764614]  [<ffffffff8234b7dd>] ? repair_env_string+0x58/0x58
[ 1346.765651]  [<ffffffff8234b120>] ? early_idt_handlers+0x120/0x120
[ 1346.766708]  [<ffffffff8234b498>] x86_64_start_reservations+0x2a/0x2c
[ 1346.767802]  [<ffffffff8234b5d5>] x86_64_start_kernel+0x13b/0x148
[ 1346.768854] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[ 1346.773396] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) t=
ook too long to run: 180.012 msecs
[ 1526.730776] INFO: rcu_sched self-detected stall on CPU { 1}  (t=3D375236=
 jiffies g=3D233 c=3D232 q=3D38983)
[ 1526.732545] sending NMI to all CPUs:
[ 1526.733290] NMI backtrace for cpu 1
[ 1526.734056] CPU: 1 PID: 696 Comm: kswapd0 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[ 1526.735640] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1526.736601] task: ffff8800bc718900 ti: ffff8800bc75c000 task.ti: ffff880=
0bc75c000
[ 1526.738106] RIP: 0010:[<ffffffff81063841>]  [<ffffffff81063841>] flat_se=
nd_IPI_mask+0x7e/0xac
[ 1526.739731] RSP: 0018:ffff88011fc83dd0  EFLAGS: 00010046
[ 1526.740652] RAX: 0000000000000c00 RBX: 0000000000000046 RCX: 00000000000=
0178a
[ 1526.741811] RDX: ffffffff82222120 RSI: 0000000000000002 RDI: 00000000000=
00300
[ 1526.742974] RBP: ffff88011fc83df0 R08: 0000000000000000 R09: 00000000000=
00000
[ 1526.744157] R10: 0000000000000be0 R11: 0000000000000000 R12: 00000000000=
00002
[ 1526.745293] R13: 0000000000000c00 R14: 000000000000000f R15: 00000000000=
00001
[ 1526.746443] FS:  0000000000000000(0000) GS:ffff88011fc80000(0000) knlGS:=
0000000000000000
[ 1526.748040] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1526.749027] CR2: 00007fe45ab579a0 CR3: 000000000220c000 CR4: 00000000000=
006e0
[ 1526.750174] Stack:
[ 1526.750766]  0000000000002710 ffff88011fc8d800 0000000000000000 ffffffff=
8224de40
[ 1526.752347]  ffff88011fc83e00 ffffffff81063ae8 ffff88011fc83e18 ffffffff=
81060d21
[ 1526.753925]  ffffffff8224de40 ffff88011fc83e70 ffffffff81114b1c ffff8801=
1fc93040
[ 1526.755503] Call Trace:
[ 1526.756135]  <IRQ>=20
[ 1526.756357]  [<ffffffff81063ae8>] flat_send_IPI_all+0x1f/0x4a
[ 1526.757757]  [<ffffffff81060d21>] arch_trigger_all_cpu_backtrace+0x52/0x=
84
[ 1526.758870]  [<ffffffff81114b1c>] rcu_check_callbacks+0x205/0x57f
[ 1526.759870]  [<ffffffff8111dcdd>] ? tick_sched_do_timer+0x2f/0x2f
[ 1526.760871]  [<ffffffff810d28d4>] update_process_times+0x3d/0x65
[ 1526.761899]  [<ffffffff8111dbed>] tick_sched_handle+0x37/0x43
[ 1526.762872]  [<ffffffff8111dd17>] tick_sched_timer+0x3a/0x58
[ 1526.763830]  [<ffffffff810e6129>] __run_hrtimer+0x96/0x19a
[ 1526.764800]  [<ffffffff810e6961>] hrtimer_interrupt+0xe8/0x1e3
[ 1526.765818]  [<ffffffff8105f691>] local_apic_timer_interrupt+0x54/0x57
[ 1526.766866]  [<ffffffff81a21841>] smp_apic_timer_interrupt+0x3f/0x50
[ 1526.767932]  [<ffffffff81a20532>] apic_timer_interrupt+0x72/0x80
[ 1526.768927]  <EOI>=20
[ 1526.769149]  [<ffffffff811716ff>] ? zone_watermark_ok_safe+0x80/0xad
[ 1526.770644]  [<ffffffff8117c77d>] zone_balanced+0x1e/0x43
[ 1526.771571]  [<ffffffff8117fe32>] balance_pgdat+0x3b6/0x501
[ 1526.772513]  [<ffffffff811802bc>] kswapd+0x33f/0x3c7
[ 1526.773387]  [<ffffffff810fdbf5>] ? __wake_up_sync+0x12/0x12
[ 1526.774371]  [<ffffffff8117ff7d>] ? balance_pgdat+0x501/0x501
[ 1526.775335]  [<ffffffff810e3c1e>] kthread+0xdb/0xe3
[ 1526.776206]  [<ffffffff810e3b43>] ? kthread_create_on_node+0x16f/0x16f
[ 1526.777270]  [<ffffffff81a1f8bc>] ret_from_fork+0x7c/0xb0
[ 1526.778235]  [<ffffffff810e3b43>] ? kthread_create_on_node+0x16f/0x16f
[ 1526.779283] Code: eb f0 44 89 f0 c1 e0 18 89 04 25 10 33 5f ff 44 89 e0 =
44 09 e8 41 81 cd 00 04 00 00 41 83 fc 02 41 0f 44 c5 89 04 25 00 33 5f ff =
<f6> c7 02 75 11 48 89 df 57 9d 0f 1f 44 00 00 e8 5c 90 0e 00 eb=20
[ 1526.783652] NMI backtrace for cpu 0
[ 1526.784614] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[ 1526.786376] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1526.787878] task: ffffffff82211440 ti: ffffffff82200000 task.ti: fffffff=
f82200000
[ 1526.789491] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[ 1526.791917] RSP: 0018:ffffffff82201ec8  EFLAGS: 00000246
[ 1526.793342] RAX: 0000000000000000 RBX: ffffffff82201fd8 RCX: 00000000fff=
fffff
[ 1526.795143] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[ 1526.796901] RBP: ffffffff82201ec8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1526.798090] R10: 000000010005b8aa R11: 0000000000000040 R12: 00000000000=
00000
[ 1526.799294] R13: ffffffff82201fd8 R14: ffffffff82201fd8 R15: 00000000fff=
fffff
[ 1526.800467] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:=
0000000000000000
[ 1526.802088] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1526.803101] CR2: 000000000223ea88 CR3: 000000007c4c1000 CR4: 00000000000=
006f0
[ 1526.804250] Stack:
[ 1526.804875]  ffffffff82201ee8 ffffffff81041811 ffffffff82201fd8 ffffffff=
82201fd8
[ 1526.806499]  ffffffff82201ef8 ffffffff81041f3d ffffffff82201f40 ffffffff=
8110be4c
[ 1526.808092]  ffff88011ffa3ec0 35ceeb7d84596041 ffffffffffffffff ffffffff=
823ef8d0
[ 1526.809711] Call Trace:
[ 1526.810328]  [<ffffffff81041811>] default_idle+0x38/0xc1
[ 1526.811275]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[ 1526.812227]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[ 1526.813231]  [<ffffffff81a022c3>] rest_init+0x87/0x89
[ 1526.814161]  [<ffffffff8234be04>] start_kernel+0x435/0x440
[ 1526.815110]  [<ffffffff8234b7dd>] ? repair_env_string+0x58/0x58
[ 1526.816120]  [<ffffffff8234b120>] ? early_idt_handlers+0x120/0x120
[ 1526.817141]  [<ffffffff8234b498>] x86_64_start_reservations+0x2a/0x2c
[ 1526.818236]  [<ffffffff8234b5d5>] x86_64_start_kernel+0x13b/0x148
[ 1526.819251] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[ 1526.823629] NMI backtrace for cpu 3
[ 1526.823647] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detecte=
d by 0, t=3D375259 jiffies, g=3D233, c=3D232, q=3D38983)
[ 1526.826286] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[ 1526.827892] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1526.828876] task: ffff880119b26300 ti: ffff880119b48000 task.ti: ffff880=
119b48000
[ 1526.830413] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[ 1526.832028] RSP: 0018:ffff880119b49eb8  EFLAGS: 00000246
[ 1526.832967] RAX: 0000000000000000 RBX: ffff880119b49fd8 RCX: 00000000fff=
fffff
[ 1526.834132] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[ 1526.835265] RBP: ffff880119b49eb8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1526.836405] R10: 0000000000000003 R11: 0000000000000400 R12: 00000000000=
00003
[ 1526.837545] R13: ffff880119b49fd8 R14: ffff880119b49fd8 R15: 00000000000=
00000
[ 1526.838682] FS:  0000000000000000(0000) GS:ffff88011fd80000(0000) knlGS:=
0000000000000000
[ 1526.840259] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1526.841240] CR2: 0000000000405c60 CR3: 000000007f470000 CR4: 00000000000=
006e0
[ 1526.842386] Stack:
[ 1526.842958]  ffff880119b49ed8 ffffffff81041811 ffff880119b49fd8 ffff8801=
19b49fd8
[ 1526.849995]  ffff880119b49ee8 ffffffff81041f3d ffff880119b49f30 ffffffff=
8110be4c
[ 1526.851582]  ffffffff8111bc52 92ed795e8031d18d 0000000000000000 00000000=
00000000
[ 1526.853160] Call Trace:
[ 1526.853788]  [<ffffffff81041811>] default_idle+0x38/0xc1
[ 1526.854726]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[ 1526.855673]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[ 1526.856678]  [<ffffffff8111bc52>] ? clockevents_register_device+0x112/0x=
117
[ 1526.857825]  [<ffffffff8105de31>] start_secondary+0x277/0x279
[ 1526.858817] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[ 1526.863219] NMI backtrace for cpu 2
[ 1526.863946] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[ 1526.865475] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1526.866503] task: ffff880119b25a00 ti: ffff880119b42000 task.ti: ffff880=
119b42000
[ 1526.868001] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[ 1526.869549] RSP: 0018:ffff880119b43eb8  EFLAGS: 00000246
[ 1526.870426] RAX: 0000000000000000 RBX: ffff880119b43fd8 RCX: 00000000fff=
fffff
[ 1526.871524] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[ 1526.872592] RBP: ffff880119b43eb8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1526.873696] R10: 0000000000000002 R11: 0000000000000400 R12: 00000000000=
00002
[ 1526.874773] R13: ffff880119b43fd8 R14: ffff880119b43fd8 R15: 00000000000=
00000
[ 1526.875858] FS:  0000000000000000(0000) GS:ffff88011fd00000(0000) knlGS:=
0000000000000000
[ 1526.877344] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1526.878298] CR2: 00007f14d81ce000 CR3: 000000007f3f6000 CR4: 00000000000=
006e0
[ 1526.879395] Stack:
[ 1526.879938]  ffff880119b43ed8 ffffffff81041811 ffff880119b43fd8 ffff8801=
19b43fd8
[ 1526.881436]  ffff880119b43ee8 ffffffff81041f3d ffff880119b43f30 ffffffff=
8110be4c
[ 1526.882969]  ffffffff8111bc52 baab13b05212a163 0000000000000000 00000000=
00000000
[ 1526.884450] Call Trace:
[ 1526.885037]  [<ffffffff81041811>] default_idle+0x38/0xc1
[ 1526.885948]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[ 1526.886870]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[ 1526.887867]  [<ffffffff8111bc52>] ? clockevents_register_device+0x112/0x=
117
[ 1526.888921]  [<ffffffff8105de31>] start_secondary+0x277/0x279
[ 1526.889885] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[ 1706.834775] INFO: rcu_sched self-detected stall on CPU { 1}  (t=3D420262=
 jiffies g=3D233 c=3D232 q=3D39703)
[ 1706.836432] sending NMI to all CPUs:
[ 1706.837140] NMI backtrace for cpu 1
[ 1706.837911] CPU: 1 PID: 696 Comm: kswapd0 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[ 1706.839491] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1706.840463] task: ffff8800bc718900 ti: ffff8800bc75c000 task.ti: ffff880=
0bc75c000
[ 1706.842021] RIP: 0010:[<ffffffff81063841>]  [<ffffffff81063841>] flat_se=
nd_IPI_mask+0x7e/0xac
[ 1706.843652] RSP: 0018:ffff88011fc83dd0  EFLAGS: 00010046
[ 1706.844567] RAX: 0000000000000c00 RBX: 0000000000000046 RCX: 00000000000=
036b4
[ 1706.845711] RDX: ffffffff82222120 RSI: 0000000000000002 RDI: 00000000000=
00300
[ 1706.846825] RBP: ffff88011fc83df0 R08: 0000000000000000 R09: 00000000000=
00000
[ 1706.847940] R10: 00000000000053c0 R11: 0000000000000000 R12: 00000000000=
00002
[ 1706.849057] R13: 0000000000000c00 R14: 000000000000000f R15: 00000000000=
00001
[ 1706.850200] FS:  0000000000000000(0000) GS:ffff88011fc80000(0000) knlGS:=
0000000000000000
[ 1706.851756] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1706.852723] CR2: 00007fe45ab579a0 CR3: 000000000220c000 CR4: 00000000000=
006e0
[ 1706.853873] Stack:
[ 1706.854438]  0000000000002710 ffff88011fc8d800 0000000000000000 ffffffff=
8224de40
[ 1706.856001]  ffff88011fc83e00 ffffffff81063ae8 ffff88011fc83e18 ffffffff=
81060d21
[ 1706.857584]  ffffffff8224de40 ffff88011fc83e70 ffffffff81114b1c ffff8801=
1fc93040
[ 1706.859141] Call Trace:
[ 1706.859758]  <IRQ>=20
[ 1706.859982]  [<ffffffff81063ae8>] flat_send_IPI_all+0x1f/0x4a
[ 1706.861351]  [<ffffffff81060d21>] arch_trigger_all_cpu_backtrace+0x52/0x=
84
[ 1706.862468]  [<ffffffff81114b1c>] rcu_check_callbacks+0x205/0x57f
[ 1706.863476]  [<ffffffff8111dcdd>] ? tick_sched_do_timer+0x2f/0x2f
[ 1706.864486]  [<ffffffff810d28d4>] update_process_times+0x3d/0x65
[ 1706.865504]  [<ffffffff8111dbed>] tick_sched_handle+0x37/0x43
[ 1706.866497]  [<ffffffff8111dd17>] tick_sched_timer+0x3a/0x58
[ 1706.867457]  [<ffffffff810e6129>] __run_hrtimer+0x96/0x19a
[ 1706.868400]  [<ffffffff810e6961>] hrtimer_interrupt+0xe8/0x1e3
[ 1706.869378]  [<ffffffff8105f691>] local_apic_timer_interrupt+0x54/0x57
[ 1706.870454]  [<ffffffff81a21841>] smp_apic_timer_interrupt+0x3f/0x50
[ 1706.871490]  [<ffffffff81a20532>] apic_timer_interrupt+0x72/0x80
[ 1706.872486]  <EOI>=20
[ 1706.872716]  [<ffffffff811cc2c1>] ? grab_super_passive+0x45/0x83
[ 1706.874125]  [<ffffffff811cc329>] super_cache_count+0x2a/0xba
[ 1706.875096]  [<ffffffff8117cac5>] shrink_slab+0xfc/0x326
[ 1706.876019]  [<ffffffff811bfaed>] ? mem_cgroup_iter+0x146/0x265
[ 1706.877009]  [<ffffffff811c5166>] ? vmpressure+0x21/0x76
[ 1706.877960]  [<ffffffff8117fdf1>] balance_pgdat+0x375/0x501
[ 1706.878913]  [<ffffffff811802bc>] kswapd+0x33f/0x3c7
[ 1706.879795]  [<ffffffff810fdbf5>] ? __wake_up_sync+0x12/0x12
[ 1706.880783]  [<ffffffff8117ff7d>] ? balance_pgdat+0x501/0x501
[ 1706.881774]  [<ffffffff810e3c1e>] kthread+0xdb/0xe3
[ 1706.882648]  [<ffffffff810e3b43>] ? kthread_create_on_node+0x16f/0x16f
[ 1706.883700]  [<ffffffff81a1f8bc>] ret_from_fork+0x7c/0xb0
[ 1706.884630]  [<ffffffff810e3b43>] ? kthread_create_on_node+0x16f/0x16f
[ 1706.885707] Code: eb f0 44 89 f0 c1 e0 18 89 04 25 10 33 5f ff 44 89 e0 =
44 09 e8 41 81 cd 00 04 00 00 41 83 fc 02 41 0f 44 c5 89 04 25 00 33 5f ff =
<f6> c7 02 75 11 48 89 df 57 9d 0f 1f 44 00 00 e8 5c 90 0e 00 eb=20
[ 1706.890038] NMI backtrace for cpu 3
[ 1706.890796] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[ 1706.892392] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1706.893375] task: ffff880119b26300 ti: ffff880119b48000 task.ti: ffff880=
119b48000
[ 1706.895014] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[ 1706.896714] RSP: 0018:ffff880119b49eb8  EFLAGS: 00000246
[ 1706.897675] RAX: 0000000000000000 RBX: ffff880119b49fd8 RCX: 00000000fff=
fffff
[ 1706.898806] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[ 1706.899937] RBP: ffff880119b49eb8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1706.901073] R10: 0000000100055528 R11: 0000000000000040 R12: 00000000000=
00003
[ 1706.902233] R13: ffff880119b49fd8 R14: ffff880119b49fd8 R15: 00000000000=
00000
[ 1706.903368] FS:  0000000000000000(0000) GS:ffff88011fd80000(0000) knlGS:=
0000000000000000
[ 1706.904945] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1706.905957] CR2: 0000000000405c60 CR3: 000000007f470000 CR4: 00000000000=
006e0
[ 1706.907108] Stack:
[ 1706.907680]  ffff880119b49ed8 ffffffff81041811 ffff880119b49fd8 ffff8801=
19b49fd8
[ 1706.909276]  ffff880119b49ee8 ffffffff81041f3d ffff880119b49f30 ffffffff=
8110be4c
[ 1706.910885]  ffffffff8111bc52 92ed795e8031d18d 0000000000000000 00000000=
00000000
[ 1706.912490] Call Trace:
[ 1706.913114]  [<ffffffff81041811>] default_idle+0x38/0xc1
[ 1706.914075]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[ 1706.915020]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[ 1706.916023]  [<ffffffff8111bc52>] ? clockevents_register_device+0x112/0x=
117
[ 1706.917140]  [<ffffffff8105de31>] start_secondary+0x277/0x279
[ 1706.918142] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[ 1706.922546] NMI backtrace for cpu 2
[ 1706.922553] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detecte=
d by 3, t=3D420283 jiffies, g=3D233, c=3D232, q=3D39703)
[ 1706.925176] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[ 1706.926813] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1706.927796] task: ffff880119b25a00 ti: ffff880119b42000 task.ti: ffff880=
119b42000
[ 1706.929296] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[ 1706.930914] RSP: 0018:ffff880119b43eb8  EFLAGS: 00000246
[ 1706.931852] RAX: 0000000000000000 RBX: ffff880119b43fd8 RCX: 00000000fff=
fffff
[ 1706.932987] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[ 1706.934121] RBP: ffff880119b43eb8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1706.935260] R10: 0000000000000002 R11: 0000000000000400 R12: 00000000000=
00002
[ 1706.936399] R13: ffff880119b43fd8 R14: ffff880119b43fd8 R15: 00000000000=
00000
[ 1706.937538] FS:  0000000000000000(0000) GS:ffff88011fd00000(0000) knlGS:=
0000000000000000
[ 1706.939120] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1706.940105] CR2: 00007f14d81ce000 CR3: 000000007f3f6000 CR4: 00000000000=
006e0
[ 1706.941245] Stack:
[ 1706.941844]  ffff880119b43ed8 ffffffff81041811 ffff880119b43fd8 ffff8801=
19b43fd8
[ 1706.943427]  ffff880119b43ee8 ffffffff81041f3d ffff880119b43f30 ffffffff=
8110be4c
[ 1706.945008]  ffffffff8111bc52 baab13b05212a163 0000000000000000 00000000=
00000000
[ 1706.946594] Call Trace:
[ 1706.947220]  [<ffffffff81041811>] default_idle+0x38/0xc1
[ 1706.948166]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[ 1706.949119]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[ 1706.950125]  [<ffffffff8111bc52>] ? clockevents_register_device+0x112/0x=
117
[ 1706.951246]  [<ffffffff8105de31>] start_secondary+0x277/0x279
[ 1706.952236] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[ 1706.956640] NMI backtrace for cpu 0
[ 1706.957436] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[ 1706.964499] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1706.965478] task: ffffffff82211440 ti: ffffffff82200000 task.ti: fffffff=
f82200000
[ 1706.966981] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[ 1706.968580] RSP: 0018:ffffffff82201ec8  EFLAGS: 00000246
[ 1706.969507] RAX: 0000000000000000 RBX: ffffffff82201fd8 RCX: 00000000fff=
fffff
[ 1706.970628] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[ 1706.971757] RBP: ffffffff82201ec8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1706.972884] R10: 0000000000000000 R11: 0000000000000400 R12: 00000000000=
00000
[ 1706.974012] R13: ffffffff82201fd8 R14: ffffffff82201fd8 R15: 00000000fff=
fffff
[ 1706.975139] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:=
0000000000000000
[ 1706.976706] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1706.977684] CR2: 000000000223ea88 CR3: 000000007c4c1000 CR4: 00000000000=
006f0
[ 1706.978813] Stack:
[ 1706.979379]  ffffffff82201ee8 ffffffff81041811 ffffffff82201fd8 ffffffff=
82201fd8
[ 1706.980951]  ffffffff82201ef8 ffffffff81041f3d ffffffff82201f40 ffffffff=
8110be4c
[ 1706.982525]  ffff88011ffa3ec0 35ceeb7d84596041 ffffffffffffffff ffffffff=
823ef8d0
[ 1706.984097] Call Trace:
[ 1706.984722]  [<ffffffff81041811>] default_idle+0x38/0xc1
[ 1706.985644]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[ 1706.986579]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[ 1706.987587]  [<ffffffff81a022c3>] rest_init+0x87/0x89
[ 1706.988483]  [<ffffffff8234be04>] start_kernel+0x435/0x440
[ 1706.989430]  [<ffffffff8234b7dd>] ? repair_env_string+0x58/0x58
[ 1706.990428]  [<ffffffff8234b120>] ? early_idt_handlers+0x120/0x120
[ 1706.991460]  [<ffffffff8234b498>] x86_64_start_reservations+0x2a/0x2c
[ 1706.992515]  [<ffffffff8234b5d5>] x86_64_start_kernel+0x13b/0x148
[ 1706.993525] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[ 1886.930775] INFO: rcu_sched self-detected stall on CPU { 1}  (t=3D465286=
 jiffies g=3D233 c=3D232 q=3D40423)
[ 1886.932407] sending NMI to all CPUs:
[ 1886.933094] NMI backtrace for cpu 1
[ 1886.933860] CPU: 1 PID: 696 Comm: kswapd0 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[ 1886.935432] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1886.936394] task: ffff8800bc718900 ti: ffff8800bc75c000 task.ti: ffff880=
0bc75c000
[ 1886.937902] RIP: 0010:[<ffffffff81063841>]  [<ffffffff81063841>] flat_se=
nd_IPI_mask+0x7e/0xac
[ 1886.939521] RSP: 0018:ffff88011fc83dd0  EFLAGS: 00010046
[ 1886.940439] RAX: 0000000000000c00 RBX: 0000000000000046 RCX: 00000000000=
055f9
[ 1886.941577] RDX: ffffffff82222120 RSI: 0000000000000002 RDI: 00000000000=
00300
[ 1886.942691] RBP: ffff88011fc83df0 R08: 0000000000000000 R09: 00000000000=
00000
[ 1886.943808] R10: 0000000000009d80 R11: 0000000000000000 R12: 00000000000=
00002
[ 1886.944922] R13: 0000000000000c00 R14: 000000000000000f R15: 00000000000=
00001
[ 1886.946073] FS:  0000000000000000(0000) GS:ffff88011fc80000(0000) knlGS:=
0000000000000000
[ 1886.947619] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1886.948587] CR2: 00007fe45ab579a0 CR3: 000000000220c000 CR4: 00000000000=
006e0
[ 1886.949732] Stack:
[ 1886.950298]  0000000000002710 ffff88011fc8d800 0000000000000000 ffffffff=
8224de40
[ 1886.951853]  ffff88011fc83e00 ffffffff81063ae8 ffff88011fc83e18 ffffffff=
81060d21
[ 1886.953403]  ffffffff8224de40 ffff88011fc83e70 ffffffff81114b1c ffff8801=
1fc93040
[ 1886.954983] Call Trace:
[ 1886.955590]  <IRQ>=20
[ 1886.955818]  [<ffffffff81063ae8>] flat_send_IPI_all+0x1f/0x4a
[ 1886.957163]  [<ffffffff81060d21>] arch_trigger_all_cpu_backtrace+0x52/0x=
84
[ 1886.958282]  [<ffffffff81114b1c>] rcu_check_callbacks+0x205/0x57f
[ 1886.959284]  [<ffffffff8111dcdd>] ? tick_sched_do_timer+0x2f/0x2f
[ 1886.960288]  [<ffffffff810d28d4>] update_process_times+0x3d/0x65
[ 1886.961286]  [<ffffffff8111dbed>] tick_sched_handle+0x37/0x43
[ 1886.962280]  [<ffffffff8111dd17>] tick_sched_timer+0x3a/0x58
[ 1886.963240]  [<ffffffff810e6129>] __run_hrtimer+0x96/0x19a
[ 1886.964179]  [<ffffffff810e6961>] hrtimer_interrupt+0xe8/0x1e3
[ 1886.965150]  [<ffffffff8105f691>] local_apic_timer_interrupt+0x54/0x57
[ 1886.966227]  [<ffffffff81a21841>] smp_apic_timer_interrupt+0x3f/0x50
[ 1886.967263]  [<ffffffff81a20532>] apic_timer_interrupt+0x72/0x80
[ 1886.968255]  <EOI>=20
[ 1886.968477]  [<ffffffff8117c906>] ? zone_reclaimable+0x5/0x23
[ 1886.969860]  [<ffffffff8117e87e>] ? shrink_lruvec+0x48/0x59e
[ 1886.970814]  [<ffffffff811cb69e>] ? put_super+0x21/0x34
[ 1886.971716]  [<ffffffff811cb967>] ? drop_super+0x1e/0x21
[ 1886.972632]  [<ffffffff811bedce>] ? __mem_cgroup_largest_soft_limit_node=
+0x1d/0xc7
[ 1886.974161]  [<ffffffff811bfaed>] ? mem_cgroup_iter+0x146/0x265
[ 1886.975142]  [<ffffffff8117ee38>] shrink_zone+0x64/0x158
[ 1886.976061]  [<ffffffff8117fdba>] balance_pgdat+0x33e/0x501
[ 1886.977008]  [<ffffffff811802bc>] kswapd+0x33f/0x3c7
[ 1886.977915]  [<ffffffff810fdbf5>] ? __wake_up_sync+0x12/0x12
[ 1886.978870]  [<ffffffff8117ff7d>] ? balance_pgdat+0x501/0x501
[ 1886.979835]  [<ffffffff810e3c1e>] kthread+0xdb/0xe3
[ 1886.980703]  [<ffffffff810e3b43>] ? kthread_create_on_node+0x16f/0x16f
[ 1886.981778]  [<ffffffff81a1f8bc>] ret_from_fork+0x7c/0xb0
[ 1886.982708]  [<ffffffff810e3b43>] ? kthread_create_on_node+0x16f/0x16f
[ 1886.983753] Code: eb f0 44 89 f0 c1 e0 18 89 04 25 10 33 5f ff 44 89 e0 =
44 09 e8 41 81 cd 00 04 00 00 41 83 fc 02 41 0f 44 c5 89 04 25 00 33 5f ff =
<f6> c7 02 75 11 48 89 df 57 9d 0f 1f 44 00 00 e8 5c 90 0e 00 eb=20
[ 1886.988061] NMI backtrace for cpu 0
[ 1886.988815] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[ 1886.990433] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1886.991410] task: ffffffff82211440 ti: ffffffff82200000 task.ti: fffffff=
f82200000
[ 1886.992918] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[ 1886.994562] RSP: 0018:ffffffff82201ec8  EFLAGS: 00000246
[ 1886.995496] RAX: 0000000000000000 RBX: ffffffff82201fd8 RCX: 00000000fff=
fffff
[ 1886.996624] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[ 1886.997778] RBP: ffffffff82201ec8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1886.998911] R10: 000000010006dda2 R11: 0000000000000040 R12: 00000000000=
00000
[ 1887.000038] R13: ffffffff82201fd8 R14: ffffffff82201fd8 R15: 00000000fff=
fffff
[ 1887.001164] FS:  0000000000000000(0000) GS:ffff88011fc00000(0000) knlGS:=
0000000000000000
[ 1887.002761] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1887.003736] CR2: 000000000223ea88 CR3: 000000007c4c1000 CR4: 00000000000=
006f0
[ 1887.004874] Stack:
[ 1887.005460]  ffffffff82201ee8 ffffffff81041811 ffffffff82201fd8 ffffffff=
82201fd8
[ 1887.007052]  ffffffff82201ef8 ffffffff81041f3d ffffffff82201f40 ffffffff=
8110be4c
[ 1887.008626]  ffff88011ffa3ec0 35ceeb7d84596041 ffffffffffffffff ffffffff=
823ef8d0
[ 1887.010229] Call Trace:
[ 1887.010856]  [<ffffffff81041811>] default_idle+0x38/0xc1
[ 1887.011786]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[ 1887.012759]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[ 1887.013791]  [<ffffffff81a022c3>] rest_init+0x87/0x89
[ 1887.014699]  [<ffffffff8234be04>] start_kernel+0x435/0x440
[ 1887.015653]  [<ffffffff8234b7dd>] ? repair_env_string+0x58/0x58
[ 1887.016650]  [<ffffffff8234b120>] ? early_idt_handlers+0x120/0x120
[ 1887.017709]  [<ffffffff8234b498>] x86_64_start_reservations+0x2a/0x2c
[ 1887.018772]  [<ffffffff8234b5d5>] x86_64_start_kernel+0x13b/0x148
[ 1887.019790] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[ 1887.024172] NMI backtrace for cpu 2
[ 1887.024179] INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detecte=
d by 0, t=3D465309 jiffies, g=3D233, c=3D232, q=3D40423)
[ 1887.026807] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[ 1887.028411] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1887.029394] task: ffff880119b25a00 ti: ffff880119b42000 task.ti: ffff880=
119b42000
[ 1887.030912] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[ 1887.032531] RSP: 0018:ffff880119b43eb8  EFLAGS: 00000246
[ 1887.033478] RAX: 0000000000000000 RBX: ffff880119b43fd8 RCX: 00000000fff=
fffff
[ 1887.034623] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[ 1887.035764] RBP: ffff880119b43eb8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1887.036899] R10: 0000000000000002 R11: 0000000000000400 R12: 00000000000=
00002
[ 1887.038054] R13: ffff880119b43fd8 R14: ffff880119b43fd8 R15: 00000000000=
00000
[ 1887.039197] FS:  0000000000000000(0000) GS:ffff88011fd00000(0000) knlGS:=
0000000000000000
[ 1887.040775] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1887.041762] CR2: 00007f14d81ce000 CR3: 000000007f3f6000 CR4: 00000000000=
006e0
[ 1887.042906] Stack:
[ 1887.043477]  ffff880119b43ed8 ffffffff81041811 ffff880119b43fd8 ffff8801=
19b43fd8
[ 1887.045061]  ffff880119b43ee8 ffffffff81041f3d ffff880119b43f30 ffffffff=
8110be4c
[ 1887.046646]  ffffffff8111bc52 baab13b05212a163 0000000000000000 00000000=
00000000
[ 1887.048229] Call Trace:
[ 1887.048854]  [<ffffffff81041811>] default_idle+0x38/0xc1
[ 1887.049788]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[ 1887.050737]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[ 1887.051740]  [<ffffffff8111bc52>] ? clockevents_register_device+0x112/0x=
117
[ 1887.052866]  [<ffffffff8105de31>] start_secondary+0x277/0x279
[ 1887.053875] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20
[ 1887.058263] NMI backtrace for cpu 3
[ 1887.059019] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.13.0-rc8-wl-0561=
0-gb524b38-dirty #1
[ 1887.060526] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 1887.061464] task: ffff880119b26300 ti: ffff880119b48000 task.ti: ffff880=
119b48000
[ 1887.062922] RIP: 0010:[<ffffffff81067bfa>]  [<ffffffff81067bfa>] native_=
safe_halt+0x6/0x8
[ 1887.064423] RSP: 0018:ffff880119b49eb8  EFLAGS: 00000246
[ 1887.070471] RAX: 0000000000000000 RBX: ffff880119b49fd8 RCX: 00000000fff=
fffff
[ 1887.071566] RDX: 0100000000000000 RSI: 0000000000000000 RDI: 00000000000=
00046
[ 1887.072640] RBP: ffff880119b49eb8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1887.073733] R10: 0000000000000003 R11: 0000000000000400 R12: 00000000000=
00003
[ 1887.074817] R13: ffff880119b49fd8 R14: ffff880119b49fd8 R15: 00000000000=
00000
[ 1887.075892] FS:  0000000000000000(0000) GS:ffff88011fd80000(0000) knlGS:=
0000000000000000
[ 1887.077365] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1887.078314] CR2: 0000000000405c60 CR3: 000000007f470000 CR4: 00000000000=
006e0
[ 1887.079413] Stack:
[ 1887.079980]  ffff880119b49ed8 ffffffff81041811 ffff880119b49fd8 ffff8801=
19b49fd8
[ 1887.081481]  ffff880119b49ee8 ffffffff81041f3d ffff880119b49f30 ffffffff=
8110be4c
[ 1887.083043]  ffffffff8111bc52 92ed795e8031d18d 0000000000000000 00000000=
00000000
[ 1887.084522] Call Trace:
[ 1887.085109]  [<ffffffff81041811>] default_idle+0x38/0xc1
[ 1887.086020]  [<ffffffff81041f3d>] arch_cpu_idle+0x18/0x28
[ 1887.086940]  [<ffffffff8110be4c>] cpu_startup_entry+0x178/0x245
[ 1887.087883]  [<ffffffff8111bc52>] ? clockevents_register_device+0x112/0x=
117
[ 1887.088940]  [<ffffffff8105de31>] start_secondary+0x277/0x279
[ 1887.089893] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 =
e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 =
<5d> c3 55 48 89 e5 f4 5d c3 55 49 89 ca 49 89 d1 8b 07 48 89 e5=20

BUG: kernel boot hang
Elapsed time: 1675
numactl --preferred=3D0 --physcpubind=3D16-19 qemu-system-x86_64 -cpu kvm64=
 -enable-kvm -kernel /kernel/x86_64-lkp/b524b386c48571e82480bef4f3af3827538=
1aa71/vmlinuz-3.13.0-rc8-wl-05610-gb524b38-dirty -append 'user=3Dlkp job=3D=
/lkp/scheduled/vpx-4/cyclic_xfstests-generic-4HDD-ext4-generic-127-HEAD.yam=
l ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/b524b386c48571e82480bef4f3a=
f38275381aa71/vmlinuz-3.13.0-rc8-wl-05610-gb524b38-dirty kconfig=3Dx86_64-l=
kp commit=3Db524b386c48571e82480bef4f3af38275381aa71 bm_initrd=3D/lkp/bench=
marks/xfstests.cgz modules_initrd=3D/kernel/x86_64-lkp/b524b386c48571e82480=
bef4f3af38275381aa71/modules.cgz max_uptime=3D836 RESULT_ROOT=3D/lkp/result=
/vpx/micro/xfstests/4HDD-ext4-generic-127/x86_64-lkp/b524b386c48571e82480be=
f4f3af38275381aa71/0 initrd=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/d=
ev/ram0 ip=3D::::vpx-4::dhcp oops=3Dpanic earlyprintk=3DttyS0,115200 debug =
apic=3Ddebug sysrq_always_enabled panic=3D10 load_ramdisk=3D2 prompt_ramdis=
k=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal'  -initrd /fs/sde1=
/initrd-vpx-4 -m 4G -smp 4 -net nic,vlan=3D1,model=3De1000 -net user,vlan=
=3D1,hostfwd=3Dtcp::9823-:22 -boot order=3Dnc -no-reboot -watchdog i6300esb=
 -rtc base=3Dlocaltime -drive file=3D/fs/sde1/disk0-vpx-4,media=3Ddisk,if=
=3Dvirtio -drive file=3D/fs/sde1/disk1-vpx-4,media=3Ddisk,if=3Dvirtio -driv=
e file=3D/fs/sde1/disk2-vpx-4,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sd=
e1/disk3-vpx-4,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sde1/disk4-vpx-4,=
media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sde1/disk5-vpx-4,media=3Ddisk,if=
=3Dvirtio -pidfile /dev/shm/kboot/pid-vpx-4 -serial file:/dev/shm/kboot/ser=
ial-vpx-4 -daemonize -display none -monitor null=20

--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=x86_64-lkp

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
# CONFIG_LOCALVERSION_AUTO is not set
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
CONFIG_BSD_PROCESS_ACCT_V3=y
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
CONFIG_RCU_FAST_NO_HZ=y
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
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
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
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
# CONFIG_DEBUG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
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
CONFIG_EXPERT=y
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
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# CONFIG_OPROFILE is not set
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
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
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
CONFIG_BLK_DEV_INTEGRITY=y
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
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
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
CONFIG_SCHED_OMIT_FRAME_POINTER=y
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
# CONFIG_PROCESSOR_SELECT is not set
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
CONFIG_NR_CPUS=512
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_I8K=m
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
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
CONFIG_MEMORY_ISOLATION=y
# CONFIG_MOVABLE_NODE is not set
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
# CONFIG_MEM_SOFT_DIRTY is not set
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
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
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
# CONFIG_PM_TEST_SUSPEND is not set
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
CONFIG_ACPI_PROCESSOR=m
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
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
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
CONFIG_ACPI_APEI_EINJ=y
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
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
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
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
CONFIG_X86_INTEL_PSTATE=y
CONFIG_X86_PCC_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=m
# CONFIG_X86_AMD_FREQ_SENSITIVITY is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=m
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
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=m
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
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
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
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
# CONFIG_BLK_DEV_SR is not set
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
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC7XXX_OLD=y
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=4
CONFIG_AIC79XX_RESET_DELAY_MS=15000
CONFIG_AIC79XX_DEBUG_ENABLE=y
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
# CONFIG_SCSI_DEBUG is not set
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
# CONFIG_PATA_PLATFORM is not set
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
CONFIG_TUN=y
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
# CONFIG_SKGE_DEBUG is not set
# CONFIG_SKGE_GENESIS is not set
CONFIG_SKY2=y
# CONFIG_SKY2_DEBUG is not set
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
# CONFIG_TTY_PRINTK is not set
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
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
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
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
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
CONFIG_PROC_VMCORE=y
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
# CONFIG_DEBUG_SECTION_MISMATCH is not set
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
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
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
# CONFIG_DEBUG_ATOMIC_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
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
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
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
# CONFIG_DMA_API_DEBUG is not set
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
CONFIG_DEBUG_SET_MODULE_RONX=y
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
CONFIG_KEYS_DEBUG_PROC_KEYS=y
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
# CONFIG_X509_CERTIFICATE_PARSER is not set
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
CONFIG_CMPXCHG_LOCKREF=y
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

--1LKvkjL3sHcu1TtY--
