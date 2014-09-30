Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbaI3Hna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 03:43:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:65408 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755206AbaI3HnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 03:43:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,625,1406617200"; 
   d="log'?scan'208";a="480930281"
Date: Tue, 30 Sep 2014 15:43:05 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: [hw_breakpoint] WARNING: at kernel/trace/trace_kprobe.c:1393
 kprobe_trace_self_tests_init()
Message-ID: <20140930074305.GA8090@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Oleg,

0day kernel testing robot got the below dmesg and the first bad commit is

commit 8b4d801b2b123b6c09742f861fe44a8527b84d47
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Thu Jun 20 17:50:06 2013 +0200
Commit:     Ingo Molnar <mingo@kernel.org>
CommitDate: Thu Jun 20 17:57:00 2013 +0200

    hw_breakpoint: Fix cpu check in task_bp_pinned(cpu)
    
    trinity fuzzer triggered WARN_ONCE("Can't find any breakpoint
    slot") in arch_install_hw_breakpoint() but the problem is not
    arch-specific.
    
    The problem is, task_bp_pinned(cpu) checks "cpu == iter->cpu"
    but this doesn't account the "all cpus" events with iter->cpu <
    0.
    
    This means that, say, register_user_hw_breakpoint(tsk) can
    happily create the arbitrary number > HBP_NUM of breakpoints
    which can not be activated. toggle_bp_task_slot() is equally
    wrong by the same reason and nr_task_bp_pinned[] can have
    negative entries.
    
    Simple test:
    
    	# perl -e 'sleep 1 while 1' &
    	# perf record -e mem:0x10,mem:0x10,mem:0x10,mem:0x10,mem:0x10 -p `pidof perl`
    
    Before this patch this triggers the same problem/WARN_ON(),
    after the patch it correctly fails with -ENOSPC.
    
    Reported-by: Vince Weaver <vincent.weaver@maine.edu>
    Signed-off-by: Oleg Nesterov <oleg@redhat.com>
    Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: <stable@vger.kernel.org>
    Link: http://lkml.kernel.org/r/20130620155006.GA6324@redhat.com
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

+-----------------------------------------------------------------------+------------+------------+------------------+
|                                                                       | 003002e04e | 8b4d801b2b | v3.17-rc7_093000 |
+-----------------------------------------------------------------------+------------+------------+------------------+
| boot_successes                                                        | 60         | 0          | 0                |
| boot_failures                                                         | 0          | 20         | 11               |
| WARNING:at_kernel/trace/trace_kprobe.c:kprobe_trace_self_tests_init() | 0          | 20         | 11               |
| backtrace:kprobe_trace_self_tests_init                                | 0          | 20         | 11               |
| backtrace:warn_slowpath_null                                          | 0          | 20         | 11               |
| backtrace:kernel_init_freeable                                        | 0          | 20         | 11               |
+-----------------------------------------------------------------------+------------+------------+------------------+

[    4.188679] Testing kprobe tracing: 
[    4.189810] Could not insert probe at kprobe_trace_selftest_target+0: -22
[    4.191076] ------------[ cut here ]------------
[    4.191542] WARNING: at kernel/trace/trace_kprobe.c:1393 kprobe_trace_self_tests_init+0x69/0x7f0()
[    4.192999] Modules linked in:
[    4.193314] CPU: 0 PID: 1 Comm: swapper Not tainted 3.10.0-rc3-00006-g8b4d801 #1
[    4.193998]  0000000000000009 ffff880013881e78 ffffffff814f4abd ffff880013881eb0
[    4.194733]  ffffffff81075481 ffffffff81aa2570 0000000000000007 0000000000000000
[    4.195469]  0000000000000000 0000000000000000 ffff880013881ec0 ffffffff810754ea
[    4.196202] Call Trace:
[    4.196513]  [<ffffffff814f4abd>] dump_stack+0x27/0x30
[    4.197399]  [<ffffffff81075481>] warn_slowpath_common+0x91/0xd0
[    4.197996]  [<ffffffff81aa2570>] ? init_kprobe_trace+0xe8/0xe8
[    4.198752]  [<ffffffff810754ea>] warn_slowpath_null+0x2a/0x40
[    4.199667]  [<ffffffff81aa25d9>] kprobe_trace_self_tests_init+0x69/0x7f0
[    4.200316]  [<ffffffff81aa2570>] ? init_kprobe_trace+0xe8/0xe8
[    4.200856]  [<ffffffff8100031a>] do_one_initcall+0x16a/0x220
[    4.201387]  [<ffffffff81a824f5>] kernel_init_freeable+0x231/0x31b
[    4.201948]  [<ffffffff814ed750>] ? rest_init+0x160/0x160
[    4.202458]  [<ffffffff814ed766>] kernel_init+0x16/0x230
[    4.202943]  [<ffffffff8150897a>] ret_from_fork+0x7a/0xb0
[    4.203813]  [<ffffffff814ed750>] ? rest_init+0x160/0x160
[    4.204530] ---[ end trace ecbec1edfe4cb96b ]---
[    4.204957] error on probing function entry.

git bisect start v3.10 v3.9 --
git bisect good ff89acc563a0bd49965674f56552ad6620415fe2  # 05:50     20+      0  Merge branch 'rcu/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu
git bisect good e4327859341f2d3a93b4b6fef2ea483eac1c270c  # 08:08     20+      0  Merge branch 'for-3.10' of git://git.samba.org/sfrench/cifs-2.6
git bisect good 2601ded7fd8827ddbcc450cbfb153b3f3c59b443  # 08:15     20+      0  Merge tag 'sound-3.10' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
git bisect good 9e895ace5d82df8929b16f58e9f515f6d54ab82d  # 08:19     20+      0  Linux 3.10-rc7
git bisect  bad 1a506e473576cdcb922d339aea76b67d0fe344f7  # 08:23      0-     20  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux
git bisect good 78750f1908869c3bfcbf2a1f1f00f078f2948271  # 08:39     20+      0  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client
git bisect  bad 54faf77d065926adbcc2a49e6df3559094cc93ba  # 11:54      0-      8  Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good de6e1317f746fbc527a73976c58b4119e506ff7c  # 11:59     20+      0  Merge tag 'critical_fix_for_3.9' of git://git.kernel.org/pub/scm/linux/kernel/git/rwlove/fcoe
git bisect good e3ff91143eb2a6eaaab4831c85a2837a95fbbea3  # 12:03     20+      0  Merge branch 'fixes' of git://git.linaro.org/people/rmk/linux-arm
git bisect  bad 8b4d801b2b123b6c09742f861fe44a8527b84d47  # 12:09      0-     20  hw_breakpoint: Fix cpu check in task_bp_pinned(cpu)
git bisect good 003002e04ed38618fc37b92ba128f5ca79d39f4f  # 12:12     20+      0  kprobes: Fix arch_prepare_kprobe to handle copy insn failures
# first bad commit: [8b4d801b2b123b6c09742f861fe44a8527b84d47] hw_breakpoint: Fix cpu check in task_bp_pinned(cpu)
git bisect good 003002e04ed38618fc37b92ba128f5ca79d39f4f  # 12:14     60+      0  kprobes: Fix arch_prepare_kprobe to handle copy insn failures
git bisect  bad 1866293290036c0e5f4843ec702392ad809a38ff  # 12:17      0-     11  0day head guard for 'devel-hourly-2014093000'
git bisect  bad fe82dcec644244676d55a1384c958d5f67979adb  # 12:17      0-     20  Linux 3.17-rc7


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-cpu kvm64
	-enable-kvm
	-kernel $kernel
	-initrd $initrd
	-m 320
	-smp 1
	-net nic,vlan=1,model=e1000
	-net user,vlan=1
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-rtc base=localtime
	-serial stdio
	-display none
	-monitor null 
)

append=(
	hung_task_panic=1
	earlyprintk=ttyS0,115200
	debug
	apic=debug
	sysrq_always_enabled
	rcupdate.rcu_cpu_stall_timeout=100
	panic=-1
	softlockup_panic=1
	nmi_watchdog=panic
	oops=panic
	load_ramdisk=2
	prompt_ramdisk=0
	console=ttyS0,115200
	console=tty0
	vga=normal
	root=/dev/ram0
	rw
	drbd.minor_count=8
)

"${kvm[@]}" --append "${append[*]}"
----------------------------------------------------------------------------

Thanks,
Fengguang

--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-vp-13:20140930120945:x86_64-randconfig-hsb2-09300248:3.10.0-rc3-00006-g8b4d801:1"
Content-Transfer-Encoding: quoted-printable

early console in setup code
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 3.10.0-rc3-00006-g8b4d801 (kbuild@lkp-hsx02) (=
gcc version 4.9.1 (Debian 4.9.1-11) ) #1 Tue Sep 30 12:08:15 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-hsb2-09300248/linux-devel:devel-hourly-2014093000:8b4d801b2b123b6c0974=
2f861fe44a8527b84d47:bisect-linux-4/.vmlinuz-8b4d801b2b123b6c09742f861fe44a=
8527b84d47-20140930120826-11-vp branch=3Dlinux-devel/devel-hourly-201409300=
0 BOOT_IMAGE=3D/kernel/x86_64-randconfig-hsb2-09300248/8b4d801b2b123b6c0974=
2f861fe44a8527b84d47/vmlinuz-3.10.0-rc3-00006-g8b4d801 drbd.minor_count=3D8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
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
[    0.000000] found SMP MP-table at [mem 0x000fdad0-0x000fdadf] mapped at =
[ffff8800000fdad0]
[    0.000000]   mpc: fdae0-fdbe8
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x025d4000, 0x025d4fff] PGTABLE
[    0.000000] BRK [0x025d5000, 0x025d5fff] PGTABLE
[    0.000000] BRK [0x025d6000, 0x025d6fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x025d7000, 0x025d7fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
[    0.000000] ACPI: RSDP 00000000000fd970 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0000000013ffe4b0 00034 (v01 BOCHS  BXPCRSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACP 0000000013ffff80 00074 (v01 BOCHS  BXPCFACP 00000=
001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0000000013ffe4f0 011A9 (v01   BXPC   BXDSDT 00000=
001 INTL 20100528)
[    0.000000] ACPI: FACS 0000000013ffff40 00040
[    0.000000] ACPI: SSDT 0000000013fff800 00735 (v01 BOCHS  BXPCSSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: APIC 0000000013fff6e0 00078 (v01 BOCHS  BXPCAPIC 00000=
001 BXPC 00000001)
[    0.000000] ACPI: HPET 0000000013fff6a0 00038 (v01 BOCHS  BXPCHPET 00000=
001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880012e0000=
0-ffff8800133fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1064 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1889640
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80679
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-hsb2-09300248/linux-devel:devel-hourly-2014093000:8b4d801b2b123=
b6c09742f861fe44a8527b84d47:bisect-linux-4/.vmlinuz-8b4d801b2b123b6c09742f8=
61fe44a8527b84d47-20140930120826-11-vp branch=3Dlinux-devel/devel-hourly-20=
14093000 BOOT_IMAGE=3D/kernel/x86_64-randconfig-hsb2-09300248/8b4d801b2b123=
b6c09742f861fe44a8527b84d47/vmlinuz-3.10.0-rc3-00006-g8b4d801 drbd.minor_co=
unt=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 294684k/327672k available (5165k kernel code, 392k a=
bsent, 32596k reserved, 5575k data, 880k init)
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
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
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.530 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 5389.52 Bogo=
MIPS (lpj=3D8978433)
[    0.006666] pid_max: default: 4096 minimum: 301
[    0.006666] Mount-cache hash table entries: 256
[    0.006666] Initializing cgroup subsys debug
[    0.006683] Initializing cgroup subsys freezer
[    0.007133] Initializing cgroup subsys perf_event
[    0.007725] mce: CPU supports 10 MCE banks
[    0.008169] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.008169] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.008169] tlb_flushall_shift: 6
[    0.009448] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.013405] ACPI: Core revision 20130328
[    0.016339] ACPI: All ACPI Tables successfully acquired
[    0.016735] ftrace: allocating 13154 entries in 52 pages
[    0.023452] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.025000] Testing tracer nop: PASSED
[    0.025481] Getting VERSION: 50014
[    0.025842] Getting VERSION: 50014
[    0.026172] Getting ID: 0
[    0.026431] Getting ID: ff000000
[    0.026681] Getting LVT0: 8700
[    0.026985] Getting LVT1: 8400
[    0.027349] enabled ExtINT on CPU#0
[    0.028485] ENABLING IO-APIC IRQs
[    0.028806] init IO_APIC IRQs
[    0.029095]  apic 0 pin 0 not connected
[    0.029469] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.030024] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.030779] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.031516] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.032264] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.033355] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.034099] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.034857] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.035616] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.036354] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.036688] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.037443] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.038202] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.038961] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.040021] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.040775]  apic 0 pin 16 not connected
[    0.041146]  apic 0 pin 17 not connected
[    0.041509]  apic 0 pin 18 not connected
[    0.041876]  apic 0 pin 19 not connected
[    0.042240]  apic 0 pin 20 not connected
[    0.042601]  apic 0 pin 21 not connected
[    0.042978]  apic 0 pin 22 not connected
[    0.043338]  apic 0 pin 23 not connected
[    0.043841] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.044379] Using local APIC timer interrupts.
[    0.044379] calibrating APIC timer ...
[    0.046666] ... lapic delta =3D 6249565
[    0.046666] ... PM-Timer delta =3D 357941
[    0.046666] ... PM-Timer result ok
[    0.046666] ..... delta 6249565
[    0.046666] ..... mult: 268416799
[    0.046666] ..... calibration result: 3333101
[    0.046666] ..... CPU clock speed is 2693.1956 MHz.
[    0.046666] ..... host bus clock speed is 1000.0101 MHz.
[    0.046666] devtmpfs: initialized
[    0.046666] Testing tracer function: PASSED
[    0.180347] Testing dynamic ftrace: PASSED
[    0.420131] Testing dynamic ftrace ops #1: (1 0 1 1 0) (1 1 2 1 0) (2 1 =
3 1 8) (2 2 4 1 86) PASSED
[    0.507183] Testing dynamic ftrace ops #2: (1 0 1 8 0) (1 1 2 86 0) (2 1=
 3 1 13) (2 2 4 83 95) PASSED
[    0.594892] Testing ftrace recursion: PASSED
[    0.603132] Testing ftrace recursion safe: PASSED
[    0.611419] Testing ftrace regs: PASSED
[    0.619615] Testing tracer irqsoff: PASSED
[    0.676731] regulator-dummy: no parameters
[    0.677354] NET: Registered protocol family 16
[    0.678209] ACPI: bus type PCI registered
[    0.678664] PCI: Using configuration type 1 for base access
[    0.679516] ACPI: Added _OSI(Module Device)
[    0.679906] ACPI: Added _OSI(Processor Device)
[    0.680005] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.680442] ACPI: Added _OSI(Processor Aggregator Device)
[    0.682342] ACPI: EC: Look up EC in DSDT
[    0.688448] ACPI: Interpreter enabled
[    0.688807] ACPI: (supports S0 S5)
[    0.689120] ACPI: Using IOAPIC for interrupt routing
[    0.689604] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.700382] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.701491] PCI host bridge to bus 0000:00
[    0.701875] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.702372] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.702933] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.703339] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.703957] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.704642] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.705753] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.706938] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.710005] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    0.711852] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.712750] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.713348] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.714166] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.717325] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.719214] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    0.725807] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.727099] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.728623] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.730496] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.735711] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.736505] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.737679] pci 0000:00:04.0: reg 10: [io  0xc040-0xc07f]
[    0.739147] pci 0000:00:04.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
[    0.745077] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.746672] pci 0000:00:05.0: reg 10: [io  0xc080-0xc0bf]
[    0.748138] pci 0000:00:05.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[    0.754112] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.755674] pci 0000:00:06.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.757142] pci 0000:00:06.0: reg 14: [mem 0xfebf3000-0xfebf3fff]
[    0.762726] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.764353] pci 0000:00:07.0: reg 10: [io  0xc100-0xc13f]
[    0.765818] pci 0000:00:07.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    0.771331] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.773339] pci 0000:00:08.0: reg 10: [io  0xc140-0xc17f]
[    0.774810] pci 0000:00:08.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    0.780325] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.781883] pci 0000:00:09.0: reg 10: [io  0xc180-0xc1bf]
[    0.783339] pci 0000:00:09.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    0.789374] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.790532] pci 0000:00:0a.0: reg 10: [mem 0xfebf7000-0xfebf700f]
[    0.794436] pci_bus 0000:00: on NUMA node 0
[    0.794840] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.796922] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.797761] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.798582] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.799395] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.800115] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.801034] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.801524] acpi root: \_SB_.PCI0 notify handler is installed
[    0.802134] Found 1 acpi root devices
[    0.803459] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.804191] vgaarb: loaded
[    0.804444] vgaarb: bridge control possible 0000:00:02.0
[    0.805347] media: Linux media interface: v0.10
[    0.805796] Linux video capture interface: v2.00
[    0.806263] EDAC MC: Ver: 3.0.0
[    0.807145] PCI: Using ACPI for IRQ routing
[    0.807548] PCI: pci_cache_line_size set to 64 bytes
[    0.808211] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.808769] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.809881] Switching to clocksource kvm-clock
[    0.823087] pnp: PnP ACPI init
[    0.823435] ACPI: bus type PNP registered
[    0.823922] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.824725] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.825388] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.826149] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.826805] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.827586] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.828255] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.828983] pnp 00:03: [dma 2]
[    0.829303] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.829978] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.830756] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.831431] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.832191] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.832864] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.833638] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.834545] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.835415] pnp: PnP ACPI: found 8 devices
[    0.835792] ACPI: bus type PNP unregistered
[    0.841493] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.842005] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.842514] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.843080] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.843698] NET: Registered protocol family 1
[    0.844110] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.844665] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.845207] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.845791] pci 0000:00:02.0: Boot video device
[    0.846290] PCI: CLS 0 bytes, default 64
[    0.847077] Unpacking initramfs...
[    0.952109] Freeing initrd memory: 3112k freed
[    0.954236] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    0.955045] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    0.956722] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    0.958088] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    0.958969] AVX instructions are not detected.
[    0.959538] AVX instructions are not detected.
[    0.987709] Kprobe smoke test started
[    1.004766] Kprobe smoke test passed successfully
[    1.005788] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.010072] xz_dec_test: module loaded
[    1.010439] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
253 0' and write .xz files to it.
[    1.011517] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    1.012214] ACPI: Power Button [PWRF]
[    1.013262] HDLC line discipline maxframe=3D4096
[    1.013700] N_HDLC line discipline registered.
[    1.014105] r3964: Philips r3964 Driver $Revision: 1.10 $
[    1.014605] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.040103] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    1.041683] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    1.042516] Hangcheck: Using getrawmonotonic().
[    1.043037] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    1.043927] HSI/SSI char device loaded
[    1.044360] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    1.045787] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.046287] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.047153] mousedev: PS/2 mouse device common for all mice
[    1.047965] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    1.049486] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    1.050312] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    1.052304] Driver for 1-wire Dallas network protocol.
[    1.053112] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[    1.054071] cpuidle: using governor ladder
[    1.054459] cpuidle: using governor menu
[    1.055470]=20
[    1.055470] printing PIC contents
[    1.055922] ... PIC  IMR: ffff
[    1.056220] ... PIC  IRR: 1013
[    1.056507] ... PIC  ISR: 0000
[    1.056807] ... PIC ELCR: 0c00
[    1.057096] printing local APIC contents on CPU#0/0:
[    1.057560] ... APIC ID:      00000000 (0)
[    1.057935] ... APIC VERSION: 00050014
[    1.058289] ... APIC TASKPRI: 00000000 (00)
[    1.058733] ... APIC PROCPRI: 00000000
[    1.059078] ... APIC LDR: 01000000
[    1.059403] ... APIC DFR: ffffffff
[    1.059717] ... APIC SPIV: 000001ff
[    1.060038] ... APIC ISR field:
[    1.060128] 000000000000000000000000000000000000000000000000000000000000=
0000
[    1.060128] ... APIC TMR field:
[    1.060128] 000000000200000000000000000000000000000000000000000000000000=
0000
[    1.060128] ... APIC IRR field:
[    1.060128] 000000000000000000000000000000000000000000000000000000000000=
8000
[    1.060128] ... APIC ESR: 00000000
[    1.060128] ... APIC ICR: 00000831
[    1.060128] ... APIC ICR2: 01000000
[    1.060128] ... APIC LVTT: 000000ef
[    1.060128] ... APIC LVTPC: 00010000
[    1.060128] ... APIC LVT0: 00010700
[    1.060128] ... APIC LVT1: 00000400
[    1.060128] ... APIC LVTERR: 000000fe
[    1.060128] ... APIC TMICT: 00030dfd
[    1.060128] ... APIC TMCCT: 00000000
[    1.060128] ... APIC TDCR: 00000003
[    1.060128]=20
[    1.068925] number of MP IRQ sources: 15.
[    1.069318] number of IO-APIC #0 registers: 24.
[    1.069896] testing the IO APIC.......................
[    1.070402] IO APIC #0......
[    1.070667] .... register #00: 00000000
[    1.071014] .......    : physical APIC id: 00
[    1.071418] .......    : Delivery Type: 0
[    1.071782] .......    : LTS          : 0
[    1.072145] .... register #01: 00170011
[    1.072504] .......     : max redirection entries: 17
[    1.072959] .......     : PRQ implemented: 0
[    1.073371] .......     : IO APIC version: 11
[    1.073768] .... register #02: 00000000
[    1.074115] .......     : arbitration: 00
[    1.074491] .... IRQ redirection table:
[    1.074851] 1    0    0   0   0    0    0    00
[    1.075279] 0    0    0   0   0    1    1    31
[    1.075699] 0    0    0   0   0    1    1    30
[    1.076121] 0    0    0   0   0    1    1    33
[    1.076552] 1    0    0   0   0    1    1    34
[    1.076984] 1    1    0   0   0    1    1    35
[    1.077414] 0    0    0   0   0    1    1    36
[    1.077834] 0    0    0   0   0    1    1    37
[    1.078263] 0    0    0   0   0    1    1    38
[    1.078682] 0    1    0   0   0    1    1    39
[    1.079103] 1    1    0   0   0    1    1    3A
[    1.079531] 1    1    0   0   0    1    1    3B
[    1.079946] 0    0    0   0   0    1    1    3C
[    1.080387] 0    0    0   0   0    1    1    3D
[    1.080806] 0    0    0   0   0    1    1    3E
[    1.081233] 0    0    0   0   0    1    1    3F
[    1.081649] 1    0    0   0   0    0    0    00
[    1.082065] 1    0    0   0   0    0    0    00
[    1.082508] 1    0    0   0   0    0    0    00
[    1.082925] 1    0    0   0   0    0    0    00
[    1.083366] 1    0    0   0   0    0    0    00
[    1.083785] 1    0    0   0   0    0    0    00
[    1.084211] 1    0    0   0   0    0    0    00
[    1.084628] 1    0    0   0   0    0    0    00
[    1.085036] IRQ to pin mappings:
[    1.085348] IRQ0 -> 0:2
[    1.085607] IRQ1 -> 0:1
[    1.085865] IRQ3 -> 0:3
[    1.086123] IRQ4 -> 0:4
[    1.086389] IRQ5 -> 0:5
[    1.086645] IRQ6 -> 0:6
[    1.086919] IRQ7 -> 0:7
[    1.087184] IRQ8 -> 0:8
[    1.087440] IRQ9 -> 0:9
[    1.087696] IRQ10 -> 0:10
[    1.087967] IRQ11 -> 0:11
[    1.088253] IRQ12 -> 0:12
[    1.088523] IRQ13 -> 0:13
[    1.088795] IRQ14 -> 0:14
[    1.089066] IRQ15 -> 0:15
[    1.089350] .................................... done.
[    1.090087] Running tests on trace events:
[    1.090485] Testing event emulate_vsyscall: OK
[    1.096897] Testing event sys_exit: OK
[    1.103591] Testing event sys_enter: OK
[    1.110371] Testing event mce_record: OK
[    1.116898] Testing event task_rename: OK
[    1.123548] Testing event task_newtask: OK
[    1.130265] Testing event console: OK
[    1.136962] Testing event softirq_raise: OK
[    1.145601] Testing event softirq_exit: OK
[    1.150202] Testing event softirq_entry: OK
[    1.156850] Testing event irq_handler_exit: OK
[    1.163514] Testing event irq_handler_entry: OK
[    1.170187] Testing event tick_stop: OK
[    1.176869] Testing event itimer_expire: OK
[    1.183613] Testing event itimer_state: OK
[    1.190185] Testing event hrtimer_cancel: OK
[    1.196832] Testing event hrtimer_expire_exit: OK
[    1.203565] Testing event hrtimer_expire_entry: OK
[    1.210283] Testing event hrtimer_start: OK
[    1.216889] Testing event hrtimer_init: OK
[    1.223571] Testing event timer_cancel: OK
[    1.230263] Testing event timer_expire_exit: OK
[    1.236925] Testing event timer_expire_entry: OK
[    1.243604] Testing event timer_start: OK
[    1.250260] Testing event timer_init: OK
[    1.256922] Testing event signal_deliver: OK
[    1.263584] Testing event signal_generate: OK
[    1.270266] Testing event workqueue_execute_end: OK
[    1.276849] Testing event workqueue_execute_start: OK
[    1.283490] Testing event workqueue_activate_work: OK
[    1.290178] Testing event workqueue_queue_work: OK
[    1.296830] Testing event rcu_utilization: OK
[    1.303509] Testing event sched_pi_setprio: OK
[    1.310280] Testing event sched_stat_runtime: OK
[    1.316825] Testing event sched_stat_blocked: OK
[    1.323491] Testing event sched_stat_iowait: OK
[    1.330153] Testing event sched_stat_sleep: OK
[    1.336821] Testing event sched_stat_wait: OK
[    1.343486] Testing event sched_process_exec: OK
[    1.350151] Testing event sched_process_fork: OK
[    1.356819] Testing event sched_process_wait: OK
[    1.363485] Testing event sched_wait_task: OK
[    1.370150] Testing event sched_process_exit: OK
[    1.376855] Testing event sched_process_free: OK
[    1.383492] Testing event sched_migrate_task: OK
[    1.390176] Testing event sched_switch: OK
[    1.396835] Testing event sched_wakeup_new: OK
[    1.403504] Testing event sched_wakeup: OK
[    1.410191] Testing event sched_kthread_stop_ret: OK
[    1.416848] Testing event sched_kthread_stop: OK
[    1.423503] Testing event lock_release: OK
[    1.430194] Testing event lock_acquire: OK
[    1.436842] Testing event module_request: OK
[    1.443536] Testing event module_free: OK
[    1.450160] Testing event module_load: OK
[    1.456827] Testing event ftrace_test_filter: OK
[    1.463487] Testing event power_domain_target: OK
[    1.470163] Testing event clock_set_rate: OK
[    1.476868] Testing event clock_disable: OK
[    1.483484] Testing event clock_enable: OK
[    1.490165] Testing event wakeup_source_deactivate: OK
[    1.496923] Testing event wakeup_source_activate: OK
[    1.503588] Testing event machine_suspend: OK
[    1.510186] Testing event cpu_frequency: OK
[    1.516855] Testing event cpu_idle: OK
[    1.523584] Testing event rpm_return_int: OK
[    1.530211] Testing event rpm_idle: OK
[    1.536951] Testing event rpm_resume: OK
[    1.543508] Testing event rpm_suspend: OK
[    1.550184] Testing event mm_filemap_add_to_page_cache: OK
[    1.556816] Testing event mm_filemap_delete_from_page_cache: OK
[    1.563486] Testing event oom_score_adj_update: OK
[    1.570153] Testing event mm_vmscan_lru_shrink_inactive: OK
[    1.576874] Testing event mm_vmscan_writepage: OK
[    1.583488] Testing event mm_vmscan_memcg_isolate: OK
[    1.590154] Testing event mm_vmscan_lru_isolate: OK
[    1.596843] Testing event mm_shrink_slab_end: OK
[    1.603509] Testing event mm_shrink_slab_start: OK
[    1.610188] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[    1.616917] Testing event mm_vmscan_memcg_reclaim_end: OK
[    1.623509] Testing event mm_vmscan_direct_reclaim_end: OK
[    1.630163] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[    1.636824] Testing event mm_vmscan_memcg_reclaim_begin: OK
[    1.643505] Testing event mm_vmscan_direct_reclaim_begin: OK
[    1.650186] Testing event mm_vmscan_wakeup_kswapd: OK
[    1.656821] Testing event mm_vmscan_kswapd_wake: OK
[    1.663500] Testing event mm_vmscan_kswapd_sleep: OK
[    1.670174] Testing event mm_page_alloc_extfrag: OK
[    1.676830] Testing event mm_page_pcpu_drain: OK
[    1.683488] Testing event mm_page_alloc_zone_locked: OK
[    1.690153] Testing event mm_page_alloc: OK
[    1.696826] Testing event mm_page_free_batched: OK
[    1.703486] Testing event mm_page_free: OK
[    1.710152] Testing event kmem_cache_free: OK
[    1.716822] Testing event kfree: OK
[    1.723499] Testing event kmem_cache_alloc_node: OK
[    1.730161] Testing event kmalloc_node: OK
[    1.736820] Testing event kmem_cache_alloc: OK
[    1.743491] Testing event kmalloc: OK
[    1.750167] Testing event mm_compaction_migratepages: OK
[    1.756818] Testing event mm_compaction_isolate_freepages: OK
[    1.763500] Testing event mm_compaction_isolate_migratepages: OK
[    1.770169] Testing event mm_migrate_pages: OK
[    1.776822] Testing event writeback_single_inode: OK
[    1.783492] Testing event writeback_single_inode_start: OK
[    1.790151] Testing event writeback_wait_iff_congested: OK
[    1.796821] Testing event writeback_congestion_wait: OK
[    1.803487] Testing event writeback_sb_inodes_requeue: OK
[    1.810152] Testing event balance_dirty_pages: OK
[    1.816827] Testing event bdi_dirty_ratelimit: OK
[    1.823487] Testing event global_dirty_state: OK
[    1.830231] Testing event writeback_queue_io: OK
[    1.836894] Testing event wbc_writepage: OK
[    1.843564] Testing event writeback_bdi_unregister: OK
[    1.850231] Testing event writeback_bdi_register: OK
[    1.856889] Testing event writeback_wake_background: OK
[    1.863557] Testing event writeback_nowork: OK
[    1.870236] Testing event writeback_pages_written: OK
[    1.876888] Testing event writeback_wait: OK
[    1.883551] Testing event writeback_written: OK
[    1.890232] Testing event writeback_start: OK
[    1.896888] Testing event writeback_exec: OK
[    1.903553] Testing event writeback_queue: OK
[    1.910243] Testing event writeback_write_inode: OK
[    1.916894] Testing event writeback_write_inode_start: OK
[    1.923557] Testing event writeback_dirty_inode: OK
[    1.930231] Testing event writeback_dirty_inode_start: OK
[    1.936888] Testing event writeback_dirty_page: OK
[    1.943556] Testing event regulator_set_voltage_complete: OK
[    1.950240] Testing event regulator_set_voltage:=20
[    1.956834] tsc: Refined TSC clocksource calibration: 2693.410 MHz
OK
[    1.957849] Testing event regulator_disable_complete: OK
[    1.963557] Testing event regulator_disable: OK
[    1.970231] Testing event regulator_enable_complete: OK
[    1.976893] Testing event regulator_enable_delay: OK
[    1.983552] Testing event regulator_enable: OK
[    1.990228] Testing event extract_entropy_user: OK
[    1.996886] Testing event extract_entropy: OK
[    2.003558] Testing event get_random_bytes: OK
[    2.010232] Testing event credit_entropy_bits: OK
[    2.016892] Testing event mix_pool_bytes_nolock: OK
[    2.023557] Testing event mix_pool_bytes: OK
[    2.030237] Testing event regmap_async_complete_done: OK
[    2.036894] Testing event regmap_async_complete_start: OK
[    2.043557] Testing event regmap_async_io_complete: OK
[    2.050236] Testing event regmap_async_write_start: OK
[    2.056891] Testing event regmap_cache_bypass: OK
[    2.063556] Testing event regmap_cache_only: OK
[    2.070250] Testing event regcache_sync: OK
[    2.076928] Testing event regmap_hw_write_done: OK
[    2.083588] Testing event regmap_hw_write_start: OK
[    2.090269] Testing event regmap_hw_read_done: OK
[    2.096926] Testing event regmap_hw_read_start: OK
[    2.103607] Testing event regmap_reg_read_cache: OK
[    2.110262] Testing event regmap_reg_read: OK
[    2.116924] Testing event regmap_reg_write: OK
[    2.123572] Testing event mc_event: OK
[    2.130298] Testing event binder_return: OK
[    2.136922] Testing event binder_command: OK
[    2.143578] Testing event binder_update_page_range: OK
[    2.150289] Testing event binder_transaction_failed_buffer_release: OK
[    2.156891] Testing event binder_transaction_buffer_release: OK
[    2.163565] Testing event binder_transaction_alloc_buf: OK
[    2.170250] Testing event binder_transaction_fd: OK
[    2.176900] Testing event binder_transaction_ref_to_ref: OK
[    2.183556] Testing event binder_transaction_ref_to_node: OK
[    2.190270] Testing event binder_transaction_node_to_ref: OK
[    2.196903] Testing event binder_transaction_received: OK
[    2.203551] Testing event binder_transaction: OK
[    2.210268] Testing event binder_wait_for_work: OK
[    2.216922] Testing event binder_read_done: OK
[    2.223592] Testing event binder_write_done: OK
[    2.230271] Testing event binder_ioctl_done: OK
[    2.236930] Testing event binder_unlock: OK
[    2.243591] Testing event binder_locked: OK
[    2.250288] Testing event binder_lock: OK
[    2.256897] Testing event binder_ioctl: OK
[    2.263591] Testing event sync_pt: OK
[    2.270361] Testing event sync_wait: OK
[    2.276962] Testing event sync_timeline: OK
[    2.283584] Testing event udp_fail_queue_rcv_skb: OK
[    2.290640] Testing event sock_exceed_buf_limit: OK
[    2.296937] Testing event sock_rcvqueue_full: OK
[    2.303615] Testing event napi_poll: OK
[    2.310268] Testing event netif_rx: OK
[    2.316935] Testing event netif_receive_skb: OK
[    2.323628] Testing event net_dev_queue: OK
[    2.330310] Testing event net_dev_xmit: OK
[    2.336934] Testing event skb_copy_datagram_iovec: OK
[    2.343597] Testing event consume_skb: OK
[    2.350384] Testing event kfree_skb: OK
[    2.356926] Running tests on trace event systems:
[    2.357593] Testing event system skb: OK
[    2.363632] Testing event system net: OK
[    2.371558] Testing event system napi: OK
[    2.376936] Testing event system sock: OK
[    2.383632] Testing event system udp: OK
[    2.390217] Testing event system sync: OK
[    2.396976] Testing event system binder: OK
[    2.403854] Testing event system ras: OK
[    2.410247] Testing event system regmap: OK
[    2.417181] Testing event system random: OK
[    2.423673] Testing event system regulator: OK
[    2.430338] Testing event system writeback: OK
[    2.437326] Testing event system migrate: OK
[    2.443575] Testing event system compaction: OK
[    2.450277] Testing event system kmem: OK
[    2.457194] Testing event system vmscan: OK
[    2.463807] Testing event system oom: OK
[    2.470243] Testing event system filemap: OK
[    2.476967] Testing event system rpm: OK
[    2.483625] Testing event system power: OK
[    2.490373] Testing event system test: OK
[    2.496904] Testing event system module: OK
[    2.503599] Testing event system lock: OK
[    2.510233] Testing event system sched: OK
[    2.517015] Testing event system rcu: OK
[    2.523511] Testing event system workqueue: OK
[    2.530205] Testing event system signal: OK
[    2.536839] Testing event system timer: OK
[    2.543620] Testing event system irq: OK
[    2.550210] Testing event system printk: OK
[    2.556833] Testing event system task: OK
[    2.563505] Testing event system mce: OK
[    2.570166] Testing event system raw_syscalls: OK
[    2.576844] Testing event system vsyscall: OK
[    2.583495] Running tests on all trace events:
[    2.583938] Testing all events: OK
[    2.627951] Running tests again, along with the function tracer
[    2.628631] Running tests on trace events:
[    2.629084] Testing event emulate_vsyscall: OK
[    2.637093] Testing event sys_exit: OK
[    2.643847] Testing event sys_enter: OK
[    2.650427] Testing event mce_record: OK
[    2.657068] Testing event task_rename: OK
[    2.663725] Testing event task_newtask: OK
[    2.670404] Testing event console: OK
[    2.677062] Testing event softirq_raise: OK
[    2.683719] Testing event softirq_exit: OK
[    2.690424] Testing event softirq_entry: OK
[    2.697082] Testing event irq_handler_exit: OK
[    2.703753] Testing event irq_handler_entry: OK
[    2.710427] Testing event tick_stop: OK
[    2.717084] Testing event itimer_expire: OK
[    2.723782] Testing event itimer_state: OK
[    2.730492] Testing event hrtimer_cancel: OK
[    2.737062] Testing event hrtimer_expire_exit: OK
[    2.743714] Testing event hrtimer_expire_entry: OK
[    2.750389] Testing event hrtimer_start: OK
[    2.757051] Testing event hrtimer_init: OK
[    2.763713] Testing event timer_cancel: OK
[    2.770401] Testing event timer_expire_exit: OK
[    2.777048] Testing event timer_expire_entry: OK
[    2.783736] Testing event timer_start: OK
[    2.790418] Testing event timer_init: OK
[    2.797070] Testing event signal_deliver: OK
[    2.803734] Testing event signal_generate: OK
[    2.810423] Testing event workqueue_execute_end: OK
[    2.817069] Testing event workqueue_execute_start: OK
[    2.823735] Testing event workqueue_activate_work: OK
[    2.830433] Testing event workqueue_queue_work: OK
[    2.837080] Testing event rcu_utilization: OK
[    2.843736] Testing event sched_pi_setprio: OK
[    2.850420] Testing event sched_stat_runtime: OK
[    2.857080] Testing event sched_stat_blocked: OK
[    2.863732] Testing event sched_stat_iowait: OK
[    2.870411] Testing event sched_stat_sleep: OK
[    2.877064] Testing event sched_stat_wait: OK
[    2.883742] Testing event sched_process_exec: OK
[    2.890427] Testing event sched_process_fork: OK
[    2.897078] Testing event sched_process_wait: OK
[    2.903735] Testing event sched_wait_task: OK
[    2.910428] Testing event sched_process_exit: OK
[    2.917079] Testing event sched_process_free: OK
[    2.923736] Testing event sched_migrate_task: OK
[    2.930446] Testing event sched_switch: OK
[    2.937080] Testing event sched_wakeup_new: OK
[    2.943737] Testing event sched_wakeup: OK
[    2.950430] Testing event sched_kthread_stop_ret: OK
[    2.957087] Testing event sched_kthread_stop: OK
[    2.963737] Testing event lock_release: OK
[    2.970429] Testing event lock_acquire: OK
[    2.977092] Testing event module_request: OK
[    2.983726] Testing event module_free: OK
[    2.990403] Testing event module_load: OK
[    2.997098] Testing event ftrace_test_filter: OK
[    3.004014] Testing event power_domain_target: OK
[    3.010648] Testing event clock_set_rate: OK
[    3.017312] Testing event clock_disable: OK
[    3.023988] Testing event clock_enable: OK
[    3.030674] Testing event wakeup_source_deactivate: OK
[    3.037408] Testing event wakeup_source_activate: OK
[    3.043981] Testing event machine_suspend: OK
[    3.050643] Testing event cpu_frequency: OK
[    3.057097] Testing event cpu_idle: OK
[    3.063736] Testing event rpm_return_int: OK
[    3.070408] Testing event rpm_idle: OK
[    3.077067] Testing event rpm_resume: OK
[    3.083734] Testing event rpm_suspend: OK
[    3.090410] Testing event mm_filemap_add_to_page_cache: OK
[    3.097068] Testing event mm_filemap_delete_from_page_cache: OK
[    3.103734] Testing event oom_score_adj_update: OK
[    3.110421] Testing event mm_vmscan_lru_shrink_inactive: OK
[    3.117068] Testing event mm_vmscan_writepage: OK
[    3.123735] Testing event mm_vmscan_memcg_isolate: OK
[    3.130409] Testing event mm_vmscan_lru_isolate: OK
[    3.137068] Testing event mm_shrink_slab_end: OK
[    3.143734] Testing event mm_shrink_slab_start: OK
[    3.150408] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[    3.157098] Testing event mm_vmscan_memcg_reclaim_end: OK
[    3.163734] Testing event mm_vmscan_direct_reclaim_end: OK
[    3.170408] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[    3.177067] Testing event mm_vmscan_memcg_reclaim_begin: OK
[    3.183722] Testing event mm_vmscan_direct_reclaim_begin: OK
[    3.190396] Testing event mm_vmscan_wakeup_kswapd: OK
[    3.197054] Testing event mm_vmscan_kswapd_wake: OK
[    3.203721] Testing event mm_vmscan_kswapd_sleep: OK
[    3.210395] Testing event mm_page_alloc_extfrag: OK
[    3.217054] Testing event mm_page_pcpu_drain: OK
[    3.223748] Testing event mm_page_alloc_zone_locked: OK
[    3.230426] Testing event mm_page_alloc: OK
[    3.237078] Testing event mm_page_free_batched: OK
[    3.243746] Testing event mm_page_free: OK
[    3.250408] Testing event kmem_cache_free: OK
[    3.257076] Testing event kfree: OK
[    3.263730] Testing event kmem_cache_alloc_node: OK
[    3.270423] Testing event kmalloc_node: OK
[    3.277053] Testing event kmem_cache_alloc: OK
[    3.283728] Testing event kmalloc: OK
[    3.290397] Testing event mm_compaction_migratepages: OK
[    3.297033] Testing event mm_compaction_isolate_freepages: OK
[    3.303699] Testing event mm_compaction_isolate_migratepages: OK
[    3.310373] Testing event mm_migrate_pages: OK
[    3.317031] Testing event writeback_single_inode: OK
[    3.323724] Testing event writeback_single_inode_start: OK
[    3.330371] Testing event writeback_wait_iff_congested: OK
[    3.337031] Testing event writeback_congestion_wait: OK
[    3.343698] Testing event writeback_sb_inodes_requeue: OK
[    3.350372] Testing event balance_dirty_pages: OK
[    3.357059] Testing event bdi_dirty_ratelimit: OK
[    3.363698] Testing event global_dirty_state: OK
[    3.370370] Testing event writeback_queue_io: OK
[    3.377031] Testing event wbc_writepage: OK
[    3.383699] Testing event writeback_bdi_unregister: OK
[    3.390371] Testing event writeback_bdi_register: OK
[    3.397031] Testing event writeback_wake_background: OK
[    3.403699] Testing event writeback_nowork: OK
[    3.410371] Testing event writeback_pages_written: OK
[    3.417031] Testing event writeback_wait: OK
[    3.423725] Testing event writeback_written: OK
[    3.430374] Testing event writeback_start: OK
[    3.437038] Testing event writeback_exec: OK
[    3.443697] Testing event writeback_queue: OK
[    3.450371] Testing event writeback_write_inode: OK
[    3.457045] Testing event writeback_write_inode_start: OK
[    3.463698] Testing event writeback_dirty_inode: OK
[    3.470374] Testing event writeback_dirty_inode_start: OK
[    3.477031] Testing event writeback_dirty_page: OK
[    3.483698] Testing event regulator_set_voltage_complete: OK
[    3.490372] Testing event regulator_set_voltage: OK
[    3.497031] Testing event regulator_disable_complete: OK
[    3.503699] Testing event regulator_disable: OK
[    3.510458] Testing event regulator_enable_complete: OK
[    3.517054] Testing event regulator_enable_delay: OK
[    3.523749] Testing event regulator_enable: OK
[    3.530400] Testing event extract_entropy_user: OK
[    3.537054] Testing event extract_entropy: OK
[    3.543722] Testing event get_random_bytes: OK
[    3.550397] Testing event credit_entropy_bits: OK
[    3.557062] Testing event mix_pool_bytes_nolock: OK
[    3.563723] Testing event mix_pool_bytes: OK
[    3.570406] Testing event regmap_async_complete_done: OK
[    3.577056] Testing event regmap_async_complete_start: OK
[    3.583723] Testing event regmap_async_io_complete: OK
[    3.590381] Testing event regmap_async_write_start: OK
[    3.597039] Testing event regmap_cache_bypass: OK
[    3.603701] Testing event regmap_cache_only: OK
[    3.610374] Testing event regcache_sync: OK
[    3.617034] Testing event regmap_hw_write_done: OK
[    3.623729] Testing event regmap_hw_write_start: OK
[    3.630373] Testing event regmap_hw_read_done: OK
[    3.637034] Testing event regmap_hw_read_start: OK
[    3.643701] Testing event regmap_reg_read_cache: OK
[    3.650374] Testing event regmap_reg_read: OK
[    3.657047] Testing event regmap_reg_write: OK
[    3.663701] Testing event mc_event: OK
[    3.670374] Testing event binder_return: OK
[    3.677035] Testing event binder_command: OK
[    3.683701] Testing event binder_update_page_range: OK
[    3.690459] Testing event binder_transaction_failed_buffer_release: OK
[    3.697055] Testing event binder_transaction_buffer_release: OK
[    3.703720] Testing event binder_transaction_alloc_buf: OK
[    3.710421] Testing event binder_transaction_fd: OK
[    3.717067] Testing event binder_transaction_ref_to_ref: OK
[    3.723723] Testing event binder_transaction_ref_to_node: OK
[    3.730397] Testing event binder_transaction_node_to_ref: OK
[    3.737054] Testing event binder_transaction_received: OK
[    3.743720] Testing event binder_transaction: OK
[    3.750397] Testing event binder_wait_for_work: OK
[    3.757056] Testing event binder_read_done: OK
[    3.763721] Testing event binder_write_done: OK
[    3.770426] Testing event binder_ioctl_done: OK
[    3.777349] Testing event binder_unlock: OK
[    3.783732] Testing event binder_locked: OK
[    3.790398] Testing event binder_lock: OK
[    3.797042] Testing event binder_ioctl: OK
[    3.803709] Testing event sync_pt: OK
[    3.810406] Testing event sync_wait: OK
[    3.817042] Testing event sync_timeline: OK
[    3.823736] Testing event udp_fail_queue_rcv_skb: OK
[    3.830409] Testing event sock_exceed_buf_limit: OK
[    3.837067] Testing event sock_rcvqueue_full: OK
[    3.843738] Testing event napi_poll: OK
[    3.850422] Testing event netif_rx: OK
[    3.857069] Testing event netif_receive_skb: OK
[    3.863739] Testing event net_dev_queue: OK
[    3.870409] Testing event net_dev_xmit: OK
[    3.877066] Testing event skb_copy_datagram_iovec: OK
[    3.883733] Testing event consume_skb: OK
[    3.890409] Testing event kfree_skb: OK
[    3.897071] Running tests on trace event systems:
[    3.897601] Testing event system skb: OK
[    3.904030] Testing event system net: OK
[    3.910559] Testing event system napi: OK
[    3.917063] Testing event system sock: OK
[    3.923779] Testing event system udp: OK
[    3.930408] Testing event system sync: OK
[    3.937168] Testing event system binder: OK
[    3.944596] Testing event system ras: OK
[    3.950449] Testing event system regmap: OK
[    3.957667] Testing event system random: OK
[    3.963966] Testing event system regulator: OK
[    3.970670] Testing event system writeback: OK
[    3.978154] Testing event system migrate: OK
[    3.983736] Testing event system compaction: OK
[    3.990487] Testing event system kmem: OK
[    3.997553] Testing event system vmscan: OK
[    4.004367] Testing event system oom: OK
[    4.010407] Testing event system filemap: OK
[    4.017082] Testing event system rpm: OK
[    4.023856] Testing event system power: OK
[    4.030774] Testing event system test: OK
[    4.037270] Testing event system module: OK
[    4.043820] Testing event system lock: OK
[    4.050520] Testing event system sched: OK
[    4.057832] Testing event system rcu: OK
[    4.063724] Testing event system workqueue: OK
[    4.070562] Testing event system signal: OK
[    4.077107] Testing event system timer: OK
[    4.084267] Testing event system irq: OK
[    4.090603] Testing event system printk: OK
[    4.097040] Testing event system task: OK
[    4.103838] Testing event system mce: OK
[    4.110471] Testing event system raw_syscalls: OK
[    4.117148] Testing event system vsyscall: OK
[    4.124010] Running tests on all trace events:
[    4.124512] Testing all events: OK
[    4.186448] Testing ftrace filter: OK
[    4.188679] Testing kprobe tracing:=20
[    4.189810] Could not insert probe at kprobe_trace_selftest_target+0: -22
[    4.191076] ------------[ cut here ]------------
[    4.191542] WARNING: at kernel/trace/trace_kprobe.c:1393 kprobe_trace_se=
lf_tests_init+0x69/0x7f0()
[    4.192999] Modules linked in:
[    4.193314] CPU: 0 PID: 1 Comm: swapper Not tainted 3.10.0-rc3-00006-g8b=
4d801 #1
[    4.193998]  0000000000000009 ffff880013881e78 ffffffff814f4abd ffff8800=
13881eb0
[    4.194733]  ffffffff81075481 ffffffff81aa2570 0000000000000007 00000000=
00000000
[    4.195469]  0000000000000000 0000000000000000 ffff880013881ec0 ffffffff=
810754ea
[    4.196202] Call Trace:
[    4.196513]  [<ffffffff814f4abd>] dump_stack+0x27/0x30
[    4.197399]  [<ffffffff81075481>] warn_slowpath_common+0x91/0xd0
[    4.197996]  [<ffffffff81aa2570>] ? init_kprobe_trace+0xe8/0xe8
[    4.198752]  [<ffffffff810754ea>] warn_slowpath_null+0x2a/0x40
[    4.199667]  [<ffffffff81aa25d9>] kprobe_trace_self_tests_init+0x69/0x7f0
[    4.200316]  [<ffffffff81aa2570>] ? init_kprobe_trace+0xe8/0xe8
[    4.200856]  [<ffffffff8100031a>] do_one_initcall+0x16a/0x220
[    4.201387]  [<ffffffff81a824f5>] kernel_init_freeable+0x231/0x31b
[    4.201948]  [<ffffffff814ed750>] ? rest_init+0x160/0x160
[    4.202458]  [<ffffffff814ed766>] kernel_init+0x16/0x230
[    4.202943]  [<ffffffff8150897a>] ret_from_fork+0x7a/0xb0
[    4.203813]  [<ffffffff814ed750>] ? rest_init+0x160/0x160
[    4.204530] ---[ end trace ecbec1edfe4cb96b ]---
[    4.204957] error on probing function entry.
[    4.206878] Could not insert probe at kprobe_trace_selftest_target+0: -22
[    4.207554] ------------[ cut here ]------------
[    4.207982] WARNING: at kernel/trace/trace_kprobe.c:1414 kprobe_trace_se=
lf_tests_init+0x24c/0x7f0()
[    4.208931] Modules linked in:
[    4.209246] CPU: 0 PID: 1 Comm: swapper Tainted: G        W    3.10.0-rc=
3-00006-g8b4d801 #1
[    4.210287]  0000000000000009 ffff880013881e78 ffffffff814f4abd ffff8800=
13881eb0
[    4.211268]  ffffffff81075481 0000000000000001 0000000000000007 00000000=
00000000
[    4.212287]  0000000000000000 0000000000000000 ffff880013881ec0 ffffffff=
810754ea
[    4.213249] Call Trace:
[    4.213500]  [<ffffffff814f4abd>] dump_stack+0x27/0x30
[    4.213967]  [<ffffffff81075481>] warn_slowpath_common+0x91/0xd0
[    4.214514]  [<ffffffff810754ea>] warn_slowpath_null+0x2a/0x40
[    4.215042]  [<ffffffff81aa27bc>] kprobe_trace_self_tests_init+0x24c/0x7=
f0
[    4.215665]  [<ffffffff81aa2570>] ? init_kprobe_trace+0xe8/0xe8
[    4.216203]  [<ffffffff8100031a>] do_one_initcall+0x16a/0x220
[    4.217062]  [<ffffffff81a824f5>] kernel_init_freeable+0x231/0x31b
[    4.217855]  [<ffffffff814ed750>] ? rest_init+0x160/0x160
[    4.218407]  [<ffffffff814ed766>] kernel_init+0x16/0x230
[    4.219280]  [<ffffffff8150897a>] ret_from_fork+0x7a/0xb0
[    4.219846]  [<ffffffff814ed750>] ? rest_init+0x160/0x160
[    4.220359] ---[ end trace ecbec1edfe4cb96c ]---
[    4.220781] error on probing function return.
[    4.221189] NG: Some tests are failed. Please check them.
[    4.222541] Key type trusted registered
[    4.225915] Freeing unused kernel memory: 880k freed
mount: mounting proc on /proc failed: No such device
/etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: not found

Please wait: booting...
mount: mounting proc on /proc failed: No such device
grep: /proc/filesystems: No such file or directory
Starting Bootlog daemon: bootlogd: cannot allocate pseudo tty: No such file=
 or directory
bootlogd.
mount: can't read '/proc/mounts': No such file or directory
/etc/init.d/rc: /etc/rcS.d/S37populate-volatile.sh: line 172: can't open /p=
roc/cmdline: no such file
grep: /proc/filesystems: No such file or directory
Configuring network interfaces... ifconfig: socket: Address family not supp=
orted by protocol
done.
hwclock: can't open '/dev/misc/rtc': No such file or directory
Running postinst /etc/rpm-postinsts/100...
mount: no /proc/mounts
wfg: skip syslogd
Kernel tests: Boot OK!
Kernel tests: Boot OK!
mount: mounting proc on /proc failed: No such device
/etc/rc5.d/S99-rc.local: line 19: can't create /proc/602/oom_score_adj: non=
existent directory
sed: /lib/modules/3.10.0-rc3-00006-g8b4d801/modules.dep: No such file or di=
rectory
xargs: modprobe: No such file or directory
run-parts: /etc/kernel-tests/01-modprobe exited with code 127
grep: /proc/cmdline: No such file or directory
grep: /proc/cmdline: No such file or directory
/etc/kernel-tests/90-trinity: line 18: /usr/sbin/chroot: not found
/etc/kernel-tests/90-trinity: line 17: /usr/sbin/chroot: not found
/etc/kernel-tests/90-trinity: line 16: /trinity: not found
/etc/kernel-tests/90-trinity: line 15: /trinity: not found
lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 08:49:11 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 08:49:11 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

lsmod: can't open '/proc/modules': No such file or directory
BusyBox v1.19.4 (2012-04-22 08:49:11 PDT) multi-call binary.

Usage: rmmod [-wfa] [MODULE]...

run-parts: /etc/kernel-tests/99-rmmod exited with code 123
mount: no /proc/mounts
wfg: skip syslogd
sed: /proc/mounts: No such file or directory
sed: /proc/mounts: No such file or directory
sed: /proc/mounts: No such file or directory
Deconfiguring network interfaces... ifconfig: socket: Address family not su=
pported by protocol
done.
Sending all processes the TERM signal...
mount: mounting proc on /proc failed: No such device
Sending all processes the KILL signal...
mount: mounting proc on /proc failed: No such device
Unmounting remote filesystems...
Deactivating swap...
Unmounting local filesystems...
grep: /proc/mounts: No such file or directory
mount: can't read '/proc/mounts': No such file or directory
Rebooting...=20
[   72.450133] Unregister pv shared memory for cpu 0
[   72.450942] Restarting system.
[   72.451236] reboot: machine restart
Elapsed time: 75
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-hsb2-09300248/8b4d801b2b123b6c09742f861fe44a8527b84d47/vmlinuz-3.10.0-rc3-=
00006-g8b4d801 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debu=
g apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 pa=
nic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdis=
k=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal=
  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-=
hsb2-09300248/linux-devel:devel-hourly-2014093000:8b4d801b2b123b6c09742f861=
fe44a8527b84d47:bisect-linux-4/.vmlinuz-8b4d801b2b123b6c09742f861fe44a8527b=
84d47-20140930120826-11-vp branch=3Dlinux-devel/devel-hourly-2014093000 BOO=
T_IMAGE=3D/kernel/x86_64-randconfig-hsb2-09300248/8b4d801b2b123b6c09742f861=
fe44a8527b84d47/vmlinuz-3.10.0-rc3-00006-g8b4d801 drbd.minor_count=3D8'  -i=
nitrd /kernel-tests/initrd/yocto-minimal-x86_64.cgz -m 320 -smp 1 -net nic,=
vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watc=
hdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs/LABEL=3DKVM/disk0-yoc=
to-vp-13,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1-yocto=
-vp-13,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk2-yocto-v=
p-13,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-yocto-vp-=
13,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk4-yocto-vp-13=
,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk5-yocto-vp-13,m=
edia=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-yocto-vp-13 -serial fil=
e:/dev/shm/kboot/serial-yocto-vp-13 -daemonize -display none -monitor null=
=20

--82I3+IH0IqGh5yIs
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-hsb2-09300248-1866293290036c0e5f4843ec702392ad809a38ff-WARNING:---at----kprobe_trace_self_tests_init+-x-106626.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgMTg2NjI5My4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1o
b3VybHktMjAxNDA5MzAwMCcKZ2l0IGNoZWNrb3V0IGZlODJkY2VjNjQ0MjQ0Njc2ZDU1YTEz
ODRjOTU4ZDVmNjc5NzlhZGIKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5
LTIwMTQwOTMwMDA6ZmU4MmRjZWM2NDQyNDQ2NzZkNTVhMTM4NGM5NThkNWY2Nzk3OWFkYjpi
aXNlY3QtbGludXgtNAoKMjAxNC0wOS0zMCAwMzowOTozNyBmZTgyZGNlYzY0NDI0NDY3NmQ1
NWExMzg0Yzk1OGQ1ZjY3OTc5YWRiIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMi94ODZfNjQtcmFuZGNvbmZpZy1o
c2IyLTA5MzAwMjQ4LWZlODJkY2VjNjQ0MjQ0Njc2ZDU1YTEzODRjOTU4ZDVmNjc5NzlhZGIK
Q2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkz
MDAyNDgvZmU4MmRjZWM2NDQyNDQ2NzZkNTVhMTM4NGM5NThkNWY2Nzk3OWFkYgp3YWl0aW5n
IGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAy
L3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgtZmU4MmRjZWM2NDQyNDQ2NzZkNTVh
MTM4NGM5NThkNWY2Nzk3OWFkYgobWzE7MzVtMjAxNC0wOS0zMCAwMzoxMTozNyBObyBidWls
ZCBzZXJ2ZWQgZmlsZSAva2J1aWxkLXRlc3RzL2J1aWxkLXNlcnZlZC94ODZfNjQtcmFuZGNv
bmZpZy1oc2IyLTA5MzAwMjQ4LWZlODJkY2VjNjQ0MjQ0Njc2ZDU1YTEzODRjOTU4ZDVmNjc5
NzlhZGIbWzBtClJldHJ5IGJ1aWxkIC4uCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1oc2IyLTA5MzAwMjQ4L2ZlODJkY2VjNjQ0MjQ0Njc2ZDU1YTEzODRjOTU4ZDVmNjc5
NzlhZGIvdm1saW51ei0zLjE3LjAtcmM3CgoyMDE0LTA5LTMwIDAzOjEyOjM3IGRldGVjdGlu
ZyBib290IHN0YXRlIC4uLiBURVNUIEZBSUxVUkUKWyAgICA2LjY3NTQ3Ml0gVGVzdGluZyBr
cHJvYmUgdHJhY2luZzogClsgICAgNi42NzY3OTBdIENvdWxkIG5vdCBpbnNlcnQgcHJvYmUg
YXQga3Byb2JlX3RyYWNlX3NlbGZ0ZXN0X3RhcmdldCswOiAtMjIKWyAgICA2LjY3Nzc3NF0g
LS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgNi42NzgzNTZdIFdB
Uk5JTkc6IENQVTogMCBQSUQ6IDEgYXQga2VybmVsL3RyYWNlL3RyYWNlX2twcm9iZS5jOjE0
MDEga3Byb2JlX3RyYWNlX3NlbGZfdGVzdHNfaW5pdCsweDhkLzB4ODYyKCkKWyAgICA2LjY3
OTc3MF0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgNi42ODAxODRdIENQVTogMCBQSUQ6IDEg
Q29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjE3LjAtcmM3ICMxClsgICAgNi42ODA5Mjdd
ICAwMDAwMDAwMDAwMDAwMDA5IGZmZmY4ODAwMTI0OTdlMjAgZmZmZmZmZmY4MTVkZTY1OCBm
ZmZmODgwMDEyNDk3ZTU4ClsgICAgNi42ODE4OTFdICBmZmZmZmZmZjgxMGE2MThlIGZmZmZm
ZmZmODE5YTkwMDAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDBjNmJkNWMwClsgICAgNi42
ODI4NTRdICAwMDAwMDAwMDAwMDAwMDAwIGZmZmZmZmZmODFjNGYyMTAgZmZmZjg4MDAxMjQ5
N2U2OCBmZmZmZmZmZjgxMGE2MWVhClsgICAgNi42ODM4MzNdIENhbGwgVHJhY2U6ClsgICAg
Ni42ODQxNTFdICBbPGZmZmZmZmZmODE1ZGU2NTg+XSBkdW1wX3N0YWNrKzB4MmUvMHgzZQpb
ICAgIDYuNjg0Nzg2XSAgWzxmZmZmZmZmZjgxMGE2MThlPl0gd2Fybl9zbG93cGF0aF9jb21t
b24rMHhhZS8weGUwClsgICAgNi42ODU1MjVdICBbPGZmZmZmZmZmODFjNGYyMTA+XSA/IGlu
aXRfa3Byb2JlX3RyYWNlKzB4ZTgvMHhlOApbICAgIDYuNjg2MjUzXSAgWzxmZmZmZmZmZjgx
MGE2MWVhPl0gd2Fybl9zbG93cGF0aF9udWxsKzB4MmEvMHg0MApbICAgIDYuNjg2OTc3XSAg
WzxmZmZmZmZmZjgxYzRmMjlkPl0ga3Byb2JlX3RyYWNlX3NlbGZfdGVzdHNfaW5pdCsweDhk
LzB4ODYyClsgICAgNi42ODc4MDJdICBbPGZmZmZmZmZmODEwMDAzNTM+XSBkb19vbmVfaW5p
dGNhbGwrMHhmMy8weDMwMApbICAgIDYuNjg4NDk2XSAgWzxmZmZmZmZmZjgxYzJiOGE0Pl0g
a2VybmVsX2luaXRfZnJlZWFibGUrMHgzMTQvMHg0MGEKWyAgICA2LjY4OTI1MF0gIFs8ZmZm
ZmZmZmY4MTVkN2UwMD5dID8gcmVzdF9pbml0KzB4MTMwLzB4MTMwClsgICAgNi42ODk5MDld
ICBbPGZmZmZmZmZmODE1ZDdlMTY+XSBrZXJuZWxfaW5pdCsweDE2LzB4MWEwClsgICAgNi42
OTA1NzldICBbPGZmZmZmZmZmODE1ZTlhZmE+XSByZXRfZnJvbV9mb3JrKzB4N2EvMHhiMApb
ICAgIDYuNjkxMjM4XSAgWzxmZmZmZmZmZjgxNWQ3ZTAwPl0gPyByZXN0X2luaXQrMHgxMzAv
MHgxMzAKWyAgICA2LjY5MTg4OV0gLS0tWyBlbmQgdHJhY2UgYTI1YmZlMjFiMTA0N2Y0ZSBd
LS0tClsgICAgNi42OTI0NThdIGVycm9yIG9uIHByb2JpbmcgZnVuY3Rpb24gZW50cnkuCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC9mZTgyZGNlYzY0NDI0NDY3
NmQ1NWExMzg0Yzk1OGQ1ZjY3OTc5YWRiL2RtZXNnLXF1YW50YWwtdnAtMTA6MjAxNDA5MzAw
MzEzNDg6eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODozLjE3LjAtcmM3OjEKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4L2ZlODJkY2VjNjQ0MjQ0Njc2
ZDU1YTEzODRjOTU4ZDVmNjc5NzlhZGIvZG1lc2ctcXVhbnRhbC12cC0xMjoyMDE0MDkzMDAz
MTM0Njp4ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4OjMuMTcuMC1yYzc6MQova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvZmU4MmRjZWM2NDQyNDQ2NzZk
NTVhMTM4NGM5NThkNWY2Nzk3OWFkYi9kbWVzZy1xdWFudGFsLXZwLTk6MjAxNDA5MzAwMzEz
NDU6eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODozLjE3LjAtcmM3OjEKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4L2ZlODJkY2VjNjQ0MjQ0Njc2ZDU1
YTEzODRjOTU4ZDVmNjc5NzlhZGIvZG1lc2ctcXVhbnRhbC12cC0yMDoyMDE0MDkzMDAzMTM1
MDp4ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4OjMuMTcuMC1yYzc6MQova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvZmU4MmRjZWM2NDQyNDQ2NzZkNTVh
MTM4NGM5NThkNWY2Nzk3OWFkYi9kbWVzZy1xdWFudGFsLXZwLTE0OjIwMTQwOTMwMDMxMzU1
Ong4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDg6My4xNy4wLXJjNzoxCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC9mZTgyZGNlYzY0NDI0NDY3NmQ1NWEx
Mzg0Yzk1OGQ1ZjY3OTc5YWRiL2RtZXNnLXF1YW50YWwtdnAtMTU6MjAxNDA5MzAwMzEzNTQ6
eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODozLjE3LjAtcmM3OjEKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4L2ZlODJkY2VjNjQ0MjQ0Njc2ZDU1YTEz
ODRjOTU4ZDVmNjc5NzlhZGIvZG1lc2ctcXVhbnRhbC12cC0xNzoyMDE0MDkzMDAzMTM1Mzp4
ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4OjMuMTcuMC1yYzc6MQova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvZmU4MmRjZWM2NDQyNDQ2NzZkNTVhMTM4
NGM5NThkNWY2Nzk3OWFkYi9kbWVzZy1xdWFudGFsLXZwLTE5OjIwMTQwOTMwMDMxMzUxOng4
Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDg6My4xNy4wLXJjNzoxCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC9mZTgyZGNlYzY0NDI0NDY3NmQ1NWExMzg0
Yzk1OGQ1ZjY3OTc5YWRiL2RtZXNnLXF1YW50YWwtdnAtMToyMDE0MDkzMDAzMTM1MTp4ODZf
NjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4OjMuMTcuMC1yYzc6MQova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvZmU4MmRjZWM2NDQyNDQ2NzZkNTVhMTM4NGM5
NThkNWY2Nzk3OWFkYi9kbWVzZy1xdWFudGFsLXZwLTIxOjIwMTQwOTMwMDMxMzUyOng4Nl82
NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDg6My4xNy4wLXJjNzoxCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC9mZTgyZGNlYzY0NDI0NDY3NmQ1NWExMzg0Yzk1
OGQ1ZjY3OTc5YWRiL2RtZXNnLXF1YW50YWwtdnAtMjI6MjAxNDA5MzAwMzEzNTQ6eDg2XzY0
LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODozLjE3LjAtcmM3OjEKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4L2ZlODJkY2VjNjQ0MjQ0Njc2ZDU1YTEzODRjOTU4
ZDVmNjc5NzlhZGIvZG1lc2ctcXVhbnRhbC12cC0yNToyMDE0MDkzMDAzMTM1Mjp4ODZfNjQt
cmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4OjMuMTcuMC1yYzc6MQova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWhzYjItMDkzMDAyNDgvZmU4MmRjZWM2NDQyNDQ2NzZkNTVhMTM4NGM5NThk
NWY2Nzk3OWFkYi9kbWVzZy1xdWFudGFsLXZwLTI2OjIwMTQwOTMwMDMxMzUxOng4Nl82NC1y
YW5kY29uZmlnLWhzYjItMDkzMDAyNDg6My4xNy4wLXJjNzoxCi9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctaHNiMi0wOTMwMDI0OC9mZTgyZGNlYzY0NDI0NDY3NmQ1NWExMzg0Yzk1OGQ1
ZjY3OTc5YWRiL2RtZXNnLXF1YW50YWwtdnAtMjc6MjAxNDA5MzAwMzEzNTU6eDg2XzY0LXJh
bmRjb25maWctaHNiMi0wOTMwMDI0ODozLjE3LjAtcmM3OjEKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1oc2IyLTA5MzAwMjQ4L2ZlODJkY2VjNjQ0MjQ0Njc2ZDU1YTEzODRjOTU4ZDVm
Njc5NzlhZGIvZG1lc2ctcXVhbnRhbC12cC0yODoyMDE0MDkzMDAzMTM1Mzp4ODZfNjQtcmFu
ZGNvbmZpZy1oc2IyLTA5MzAwMjQ4OjMuMTcuMC1yYzc6MQova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWhzYjItMDkzMDAyNDgvZmU4MmRjZWM2NDQyNDQ2NzZkNTVhMTM4NGM5NThkNWY2
Nzk3OWFkYi9kbWVzZy1xdWFudGFsLXZwLTMwOjIwMTQwOTMwMDMxMzUyOng4Nl82NC1yYW5k
Y29uZmlnLWhzYjItMDkzMDAyNDg6My4xNy4wLXJjNzoxCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaHNiMi0wOTMwMDI0OC9mZTgyZGNlYzY0NDI0NDY3NmQ1NWExMzg0Yzk1OGQ1ZjY3
OTc5YWRiL2RtZXNnLXF1YW50YWwtdnAtMzI6MjAxNDA5MzAwMzEzNTU6eDg2XzY0LXJhbmRj
b25maWctaHNiMi0wOTMwMDI0ODozLjE3LjAtcmM3OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1oc2IyLTA5MzAwMjQ4L2ZlODJkY2VjNjQ0MjQ0Njc2ZDU1YTEzODRjOTU4ZDVmNjc5
NzlhZGIvZG1lc2ctcXVhbnRhbC12cC01OjIwMTQwOTMwMDMxMzUzOng4Nl82NC1yYW5kY29u
ZmlnLWhzYjItMDkzMDAyNDg6My4xNy4wLXJjNzoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaHNiMi0wOTMwMDI0OC9mZTgyZGNlYzY0NDI0NDY3NmQ1NWExMzg0Yzk1OGQ1ZjY3OTc5
YWRiL2RtZXNnLXF1YW50YWwtdnAtNjoyMDE0MDkzMDAzMTM1MTp4ODZfNjQtcmFuZGNvbmZp
Zy1oc2IyLTA5MzAwMjQ4OjMuMTcuMC1yYzc6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWhzYjItMDkzMDAyNDgvZmU4MmRjZWM2NDQyNDQ2NzZkNTVhMTM4NGM5NThkNWY2Nzk3OWFk
Yi9kbWVzZy1xdWFudGFsLXZwLTc6MjAxNDA5MzAwMzEzNTM6eDg2XzY0LXJhbmRjb25maWct
aHNiMi0wOTMwMDI0ODozLjE3LjAtcmM3OjEKMDoyMDoyMCBhbGxfZ29vZDpiYWQ6YWxsX2Jh
ZCBib290cwobWzE7MzVtMjAxNC0wOS0zMCAwMzoxNDowOSBSRVBFQVQgQ09VTlQ6IDIwICAj
IC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTQvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKYmlzZWN0
OiBiYWQgY29tbWl0IGZlODJkY2VjNjQ0MjQ0Njc2ZDU1YTEzODRjOTU4ZDVmNjc5NzlhZGIK
Z2l0IGNoZWNrb3V0IHYzLjE2CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94
ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4L2xpbnV4LWRldmVsOmRldmVsLWhvdXJs
eS0yMDE0MDkzMDAwOjE5NTgzY2E1ODRkNmY1NzQzODRlMTdmZTc2MTNkZmFlYWRjZGM0YTY6
YmlzZWN0LWxpbnV4LTQKCjIwMTQtMDktMzAgMDM6MTU6MTkgMTk1ODNjYTU4NGQ2ZjU3NDM4
NGUxN2ZlNzYxM2RmYWVhZGNkYzRhNiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8g
L2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDIveDg2XzY0LXJhbmRjb25maWct
aHNiMi0wOTMwMDI0OC0xOTU4M2NhNTg0ZDZmNTc0Mzg0ZTE3ZmU3NjEzZGZhZWFkY2RjNGE2
CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5
MzAwMjQ4LzE5NTgzY2E1ODRkNmY1NzQzODRlMTdmZTc2MTNkZmFlYWRjZGM0YTYKd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gw
Mi1zbW9rZS94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LTE5NTgzY2E1ODRkNmY1
NzQzODRlMTdmZTc2MTNkZmFlYWRjZGM0YTYKG1sxOzM1bTIwMTQtMDktMzAgMDM6MjQ6MTkg
S2VybmVsIGJ1aWxkIGZhaWwgb3IgdGltZW91dBtbMG0KMjAxNC0wOS0zMCAwMzoyNDoxOSAx
OTU4M2NhNTg0ZDZmNTc0Mzg0ZTE3ZmU3NjEzZGZhZWFkY2RjNGE2IFNLSVAgQlJPS0VOIEJV
SUxECkNoZWNrIC9rYnVpbGQtdGVzdHMvYnVpbGQtc2VydmVkL3g4Nl82NC1yYW5kY29uZmln
LWhzYjItMDkzMDAyNDgtMTk1ODNjYTU4NGQ2ZjU3NDM4NGUxN2ZlNzYxM2RmYWVhZGNkYzRh
NgpiaXNlY3Q6IHNraXAgYnJva2VuIGJ1aWxkIGZvciB2My4xNgpnaXQgY2hlY2tvdXQgdjMu
MTUKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmln
LWhzYjItMDkzMDAyNDgvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwOTMwMDA6MTg2
MGUzNzk4NzVkZmU3MjcxYzY0OTA1OGFlZGRmZmU1YWZkOWQwZDpiaXNlY3QtbGludXgtNAoK
MjAxNC0wOS0zMCAwMzoyNDoyMyAxODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVkZGZmZTVh
ZmQ5ZDBkIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlL2xrcC1oc3gwMi94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LTE4
NjBlMzc5ODc1ZGZlNzI3MWM2NDkwNThhZWRkZmZlNWFmZDlkMGQKQ2hlY2sgZm9yIGtlcm5l
bCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvMTg2MGUzNzk4
NzVkZmU3MjcxYzY0OTA1OGFlZGRmZmU1YWZkOWQwZAp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAyL3g4Nl82NC1yYW5kY29u
ZmlnLWhzYjItMDkzMDAyNDgtMTg2MGUzNzk4NzVkZmU3MjcxYzY0OTA1OGFlZGRmZmU1YWZk
OWQwZAobWzE7MzVtMjAxNC0wOS0zMCAwNDowMDoyMyBObyBidWlsZCBzZXJ2ZWQgZmlsZSAv
a2J1aWxkLXRlc3RzL2J1aWxkLXNlcnZlZC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAw
MjQ4LTE4NjBlMzc5ODc1ZGZlNzI3MWM2NDkwNThhZWRkZmZlNWFmZDlkMGQbWzBtClJldHJ5
IGJ1aWxkIC4uCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAw
MjQ4LzE4NjBlMzc5ODc1ZGZlNzI3MWM2NDkwNThhZWRkZmZlNWFmZDlkMGQvdm1saW51ei0z
LjE1LjAKCjIwMTQtMDktMzAgMDQ6MDE6MjMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4gVEVT
VCBGQUlMVVJFClsgICAgNy4yMTg0NDFdIFRlc3Rpbmcga3Byb2JlIHRyYWNpbmc6IApbICAg
IDcuMjIwMzYzXSBDb3VsZCBub3QgaW5zZXJ0IHByb2JlIGF0IGtwcm9iZV90cmFjZV9zZWxm
dGVzdF90YXJnZXQrMDogLTIyClsgICAgNy4yMjE4MjldIC0tLS0tLS0tLS0tLVsgY3V0IGhl
cmUgXS0tLS0tLS0tLS0tLQpbICAgIDcuMjIyNzIxXSBXQVJOSU5HOiBDUFU6IDAgUElEOiAx
IGF0IGtlcm5lbC90cmFjZS90cmFjZV9rcHJvYmUuYzoxMzg3IGtwcm9iZV90cmFjZV9zZWxm
X3Rlc3RzX2luaXQrMHg2OS8weDdmMCgpClsgICAgNy4yMjQ4NTBdIE1vZHVsZXMgbGlua2Vk
IGluOgpbICAgIDcuMjI1NDAwXSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIgTm90IHRh
aW50ZWQgMy4xNS4wICMxClsgICAgNy4yMjY0NDBdICAwMDAwMDAwMDAwMDAwMDA5IGZmZmY4
ODAwMTI0NTdlMzAgZmZmZmZmZmY4MTU4N2I4MiBmZmZmODgwMDEyNDU3ZTY4ClsgICAgNy4y
Mjc3OTVdICBmZmZmZmZmZjgxMDlhMjNlIDAwMDAwMDAwMDAwMDAwMDAgZmZmZmZmZmY4MWJk
MTNiMCAwMDAwMDAwMDAwMDAwMDhmClsgICAgNy4yMjkxODJdICAwMDAwMDAwMDAwMDAwMDAw
IDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAxMjQ1N2U3OCBmZmZmZmZmZjgxMDlhMjlhClsg
ICAgNy4yMzA2MTFdIENhbGwgVHJhY2U6ClsgICAgNy4yMzEwNzldICBbPGZmZmZmZmZmODE1
ODdiODI+XSBkdW1wX3N0YWNrKzB4MmUvMHgzZQpbICAgIDcuMjMxODg3XSAgWzxmZmZmZmZm
ZjgxMDlhMjNlPl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHhhZS8weGUwClsgICAgNy4yMzI4
NjldICBbPGZmZmZmZmZmODFiZDEzYjA+XSA/IGluaXRfa3Byb2JlX3RyYWNlKzB4ZTgvMHhl
OApbICAgIDcuMjMzOTUzXSAgWzxmZmZmZmZmZjgxMDlhMjlhPl0gd2Fybl9zbG93cGF0aF9u
dWxsKzB4MmEvMHg0MApbICAgIDcuMjM0OTM4XSAgWzxmZmZmZmZmZjgxYmQxNDE5Pl0ga3By
b2JlX3RyYWNlX3NlbGZfdGVzdHNfaW5pdCsweDY5LzB4N2YwClsgICAgNy4yMzYxMjVdICBb
PGZmZmZmZmZmODFiZDEzYjA+XSA/IGluaXRfa3Byb2JlX3RyYWNlKzB4ZTgvMHhlOApbICAg
IDcuMjM3NDg2XSAgWzxmZmZmZmZmZjgxMDAwM2RhPl0gZG9fb25lX2luaXRjYWxsKzB4MTdh
LzB4MjIwClsgICAgNy4yMzg2NjRdICBbPGZmZmZmZmZmODFiYWY2OTA+XSBrZXJuZWxfaW5p
dF9mcmVlYWJsZSsweDMxNC8weDQwYQpbICAgIDcuMjM5NzEwXSAgWzxmZmZmZmZmZjgxNTgw
MGUwPl0gPyByZXN0X2luaXQrMHgxMzAvMHgxMzAKWyAgICA3LjI0MDUwM10gIFs8ZmZmZmZm
ZmY4MTU4MDBmNj5dIGtlcm5lbF9pbml0KzB4MTYvMHgxYTAKWyAgICA3LjI0MTMyOF0gIFs8
ZmZmZmZmZmY4MTVhNGJjYT5dIHJldF9mcm9tX2ZvcmsrMHg3YS8weGIwClsgICAgNy4yNDIx
NzhdICBbPGZmZmZmZmZmODE1ODAwZTA+XSA/IHJlc3RfaW5pdCsweDEzMC8weDEzMApbICAg
IDcuMjQzMDQyXSAtLS1bIGVuZCB0cmFjZSAwZjVkZTA5ZDNjZTVjMjk1IF0tLS0KWyAgICA3
LjI0Mzc2N10gZXJyb3Igb24gcHJvYmluZyBmdW5jdGlvbiBlbnRyeS4KL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LzE4NjBlMzc5ODc1ZGZlNzI3MWM2NDkwNThh
ZWRkZmZlNWFmZDlkMGQvZG1lc2ctcXVhbnRhbC12cC0xNzoyMDE0MDkzMDA0MDE0ODp4ODZf
NjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4OjMuMTUuMDoxCjA6MToxIGFsbF9nb29kOmJh
ZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA5LTMwIDA0OjAyOjI0IFJFUEVBVCBDT1VO
VDogMjAgICMgL2MvYm9vdC1iaXNlY3QvbGludXgtNC9vYmotYmlzZWN0Ly5yZXBlYXQbWzBt
CgpiaXNlY3Q6IGJhZCBjb21taXQgdjMuMTUKZ2l0IGNoZWNrb3V0IHYzLjE0CmxzIC1hIC9r
YnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAw
MjQ4L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDkzMDAwOjQ1NWM2ZmRiZDIxOTE2
MWJkMDliMTE2NWYxMTY5OWQ2ZDczZGUxMWM6YmlzZWN0LWxpbnV4LTQKCjIwMTQtMDktMzAg
MDQ6MDI6MzMgNDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjExNjk5ZDZkNzNkZTExYyBjb21w
aWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9s
a3AtaHN4MDIveDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC00NTVjNmZkYmQyMTkx
NjFiZDA5YjExNjVmMTE2OTlkNmQ3M2RlMTFjCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LzQ1NWM2ZmRiZDIxOTE2MWJkMDli
MTE2NWYxMTY5OWQ2ZDczZGUxMWMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMi94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5
MzAwMjQ4LTQ1NWM2ZmRiZDIxOTE2MWJkMDliMTE2NWYxMTY5OWQ2ZDczZGUxMWMKG1sxOzM1
bTIwMTQtMDktMzAgMDQ6MTM6MzMgTm8gYnVpbGQgc2VydmVkIGZpbGUgL2tidWlsZC10ZXN0
cy9idWlsZC1zZXJ2ZWQveDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC00NTVjNmZk
YmQyMTkxNjFiZDA5YjExNjVmMTE2OTlkNmQ3M2RlMTFjG1swbQpSZXRyeSBidWlsZCAuLgpr
ZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC80NTVjNmZk
YmQyMTkxNjFiZDA5YjExNjVmMTE2OTlkNmQ3M2RlMTFjL3ZtbGludXotMy4xNC4wCgoyMDE0
LTA5LTMwIDA0OjE0OjMzIGRldGVjdGluZyBib290IHN0YXRlIC4uIFRFU1QgRkFJTFVSRQpb
ICAgIDYuODIxNzM2XSBUZXN0aW5nIGtwcm9iZSB0cmFjaW5nOiAKWyAgICA2LjgyMzYyNl0g
Q291bGQgbm90IGluc2VydCBwcm9iZSBhdCBrcHJvYmVfdHJhY2Vfc2VsZnRlc3RfdGFyZ2V0
KzA6IC0yMgpbICAgIDYuODI1MTgxXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0t
LS0tLS0KWyAgICA2LjgyNjA5OF0gV0FSTklORzogQ1BVOiAwIFBJRDogMSBhdCBrZXJuZWwv
dHJhY2UvdHJhY2Vfa3Byb2JlLmM6MTM5OSBrcHJvYmVfdHJhY2Vfc2VsZl90ZXN0c19pbml0
KzB4NjkvMHg3ZjAoKQpbICAgIDYuODI4MzIwXSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICA2
LjgyODk1NF0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTQu
MCAjMgpbICAgIDYuODMwMDQ0XSAgMDAwMDAwMDAwMDAwMDAwOSBmZmZmODgwMDEyNDgzZTMw
IGZmZmZmZmZmODE1ODQzNTYgZmZmZjg4MDAxMjQ4M2U2OApbICAgIDYuODMxNTczXSAgZmZm
ZmZmZmY4MTA5ODY4ZSAwMDAwMDAwMDAwMDAwMDAwIGZmZmZmZmZmODFiYjY2MDAgMDAwMDAw
MDAwMDAwMDA5MgpbICAgIDYuODMzMDY2XSAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAw
MDAwMDAwIGZmZmY4ODAwMTI0ODNlNzggZmZmZmZmZmY4MTA5ODZlYQpbICAgIDYuODM0NTc0
XSBDYWxsIFRyYWNlOgpbICAgIDYuODM1MDcwXSAgWzxmZmZmZmZmZjgxNTg0MzU2Pl0gZHVt
cF9zdGFjaysweDJlLzB4M2UKWyAgICA2LjgzNjA2MV0gIFs8ZmZmZmZmZmY4MTA5ODY4ZT5d
IHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4YWUvMHhlMApbICAgIDYuODM3MjAzXSAgWzxmZmZm
ZmZmZjgxYmI2NjAwPl0gPyBpbml0X2twcm9iZV90cmFjZSsweGU4LzB4ZTgKWyAgICA2Ljgz
ODM1MV0gIFs8ZmZmZmZmZmY4MTA5ODZlYT5dIHdhcm5fc2xvd3BhdGhfbnVsbCsweDJhLzB4
NDAKWyAgICA2LjgzOTQ2Ml0gIFs8ZmZmZmZmZmY4MWJiNjY2OT5dIGtwcm9iZV90cmFjZV9z
ZWxmX3Rlc3RzX2luaXQrMHg2OS8weDdmMApbICAgIDYuODQwNzQ4XSAgWzxmZmZmZmZmZjgx
YmI2NjAwPl0gPyBpbml0X2twcm9iZV90cmFjZSsweGU4LzB4ZTgKWyAgICA2Ljg0MTkwMl0g
IFs8ZmZmZmZmZmY4MTAwMDNkYT5dIGRvX29uZV9pbml0Y2FsbCsweDE3YS8weDIyMApbICAg
IDYuODQzMDA0XSAgWzxmZmZmZmZmZjgxYjk0NjkwPl0ga2VybmVsX2luaXRfZnJlZWFibGUr
MHgzMTQvMHg0MGEKWyAgICA2Ljg0NDE4NV0gIFs8ZmZmZmZmZmY4MTU3Yzk1MD5dID8gcmVz
dF9pbml0KzB4MTMwLzB4MTMwClsgICAgNi44NDUyMzldICBbPGZmZmZmZmZmODE1N2M5NjY+
XSBrZXJuZWxfaW5pdCsweDE2LzB4MWEwClsgICAgNi44NDYyNTddICBbPGZmZmZmZmZmODE1
YTE1OGE+XSByZXRfZnJvbV9mb3JrKzB4N2EvMHhiMApbICAgIDYuODQ3MjkxXSAgWzxmZmZm
ZmZmZjgxNTdjOTUwPl0gPyByZXN0X2luaXQrMHgxMzAvMHgxMzAKWyAgICA2Ljg0ODM3Ml0g
LS0tWyBlbmQgdHJhY2UgMjUyNDUyZGUxZTM4ZDZkNiBdLS0tClsgICAgNi44NDkyNjJdIGVy
cm9yIG9uIHByb2JpbmcgZnVuY3Rpb24gZW50cnkuCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaHNiMi0wOTMwMDI0OC80NTVjNmZkYmQyMTkxNjFiZDA5YjExNjVmMTE2OTlkNmQ3M2Rl
MTFjL2RtZXNnLXF1YW50YWwtdnAtMzA6MjAxNDA5MzAwNDE1MjI6eDg2XzY0LXJhbmRjb25m
aWctaHNiMi0wOTMwMDI0ODozLjE0LjA6Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhz
YjItMDkzMDAyNDgvNDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjExNjk5ZDZkNzNkZTExYy9k
bWVzZy15b2N0by1rYnVpbGQtMTI6MjAxNDA5MzAwNDEyMjQ6eDg2XzY0LXJhbmRjb25maWct
aHNiMi0wOTMwMDI0ODozLjE0LjA6MgowOjI6MiBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290
cwobWzE7MzVtMjAxNC0wOS0zMCAwNDoxNTozNSBSRVBFQVQgQ09VTlQ6IDIwICAjIC9jL2Jv
b3QtYmlzZWN0L2xpbnV4LTQvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKYmlzZWN0OiBiYWQg
Y29tbWl0IHYzLjE0CmdpdCBjaGVja291dCB2My4xMwpscyAtYSAva2J1aWxkLXRlc3RzL3J1
bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC9saW51eC1kZXZl
bDpkZXZlbC1ob3VybHktMjAxNDA5MzAwMDpkOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4
MTQyMTBmMGU2NGJlOmJpc2VjdC1saW51eC00CgoyMDE0LTA5LTMwIDA0OjE2OjU0IGQ4ZWMy
NmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUgY29tcGlsaW5nClF1ZXVlZCBi
dWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAyL3g4Nl82
NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgtZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4
ODE0MjEwZjBlNjRiZQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaHNiMi0wOTMwMDI0OC9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBm
MGU2NGJlCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS9sa3AtaHN4MDIveDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC1kOGVjMjZk
N2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlChtbMTszNW0yMDE0LTA5LTMwIDA0
OjE4OjU0IE5vIGJ1aWxkIHNlcnZlZCBmaWxlIC9rYnVpbGQtdGVzdHMvYnVpbGQtc2VydmVk
L3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgtZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5
NGY1NmU4ODE0MjEwZjBlNjRiZRtbMG0KUmV0cnkgYnVpbGQgLi4Ka2VybmVsOiAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5
NGY1NmU4ODE0MjEwZjBlNjRiZS92bWxpbnV6LTMuMTMuMAoKMjAxNC0wOS0zMCAwNDoyMDow
MSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLiBURVNUIEZBSUxVUkUKWyAgIDEwLjkzMjMzMl0g
VGVzdGluZyBrcHJvYmUgdHJhY2luZzogClsgICAxMC45MzQyODRdIENvdWxkIG5vdCBpbnNl
cnQgcHJvYmUgYXQga3Byb2JlX3RyYWNlX3NlbGZ0ZXN0X3RhcmdldCswOiAtMjIKWyAgIDEw
Ljk0MzQ5Nl0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAxMC45
NDQ2MzFdIFdBUk5JTkc6IENQVTogMCBQSUQ6IDEgYXQga2VybmVsL3RyYWNlL3RyYWNlX2tw
cm9iZS5jOjEzNDEga3Byb2JlX3RyYWNlX3NlbGZfdGVzdHNfaW5pdCsweDY5LzB4N2YwKCkK
WyAgIDEwLjk1MjI5NF0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAxMC45NTMwNDJdIENQVTog
MCBQSUQ6IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjEzLjAgIzEKWyAgIDEwLjk1
OTQ3M10gIDAwMDAwMDAwMDAwMDAwMDkgZmZmZjg4MDAxMjQ0ZmUzMCBmZmZmZmZmZjgxNTQ0
ODc1IGZmZmY4ODAwMTI0NGZlNjgKWyAgIDEwLjk2MzU4NV0gIGZmZmZmZmZmODEwN2ZiMmUg
MDAwMDAwMDAwMDAwMDAwMCBmZmZmZmZmZjgxYjUwZTI5IDAwMDAwMDAwMDAwMDAwOTIKWyAg
IDEwLjk2NzA0M10gIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgw
MDEyNDRmZTc4IGZmZmZmZmZmODEwN2ZiOGEKWyAgIDEwLjk3MzMxMV0gQ2FsbCBUcmFjZToK
WyAgIDEwLjk3NDE3NV0gIFs8ZmZmZmZmZmY4MTU0NDg3NT5dIGR1bXBfc3RhY2srMHgyZS8w
eDNlClsgICAxMC45ODIyNTZdICBbPGZmZmZmZmZmODEwN2ZiMmU+XSB3YXJuX3Nsb3dwYXRo
X2NvbW1vbisweGFlLzB4ZTAKWyAgIDEwLjk4MzY4Ml0gIFs8ZmZmZmZmZmY4MWI1MGUyOT5d
ID8gaW5pdF9rcHJvYmVfdHJhY2UrMHhlOC8weGU4ClsgICAxMC45ODcyNTZdICBbPGZmZmZm
ZmZmODEwN2ZiOGE+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgyYS8weDQwClsgICAxMC45ODg1
ODNdICBbPGZmZmZmZmZmODFiNTBlOTI+XSBrcHJvYmVfdHJhY2Vfc2VsZl90ZXN0c19pbml0
KzB4NjkvMHg3ZjAKWyAgIDEwLjk5ODYxOV0gIFs8ZmZmZmZmZmY4MWI1MGUyOT5dID8gaW5p
dF9rcHJvYmVfdHJhY2UrMHhlOC8weGU4ClsgICAxMS4wMDI2MDldICBbPGZmZmZmZmZmODEw
MDAzOWE+XSBkb19vbmVfaW5pdGNhbGwrMHgxN2EvMHgyMjAKWyAgIDExLjAwMzk5M10gIFs8
ZmZmZmZmZmY4MWIyZjY3NT5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MzE0LzB4NDBhClsg
ICAxMS4wMDY2NDBdICBbPGZmZmZmZmZmODE1M2Q0YjA+XSA/IHJlc3RfaW5pdCsweDEzMC8w
eDEzMApbICAgMTEuMDEwMDkwXSAgWzxmZmZmZmZmZjgxNTNkNGM2Pl0ga2VybmVsX2luaXQr
MHgxNi8weDFkMApbICAgMTEuMDEyOTk4XSAgWzxmZmZmZmZmZjgxNTYxNjhhPl0gcmV0X2Zy
b21fZm9yaysweDdhLzB4YjAKWyAgIDExLjAyMjE5OV0gIFs8ZmZmZmZmZmY4MTUzZDRiMD5d
ID8gcmVzdF9pbml0KzB4MTMwLzB4MTMwClsgICAxMS4wMjM0MDVdIC0tLVsgZW5kIHRyYWNl
IGY1MzcwZTU5OTUxMmUxNDMgXS0tLQpbICAgMTEuMDI0NDIyXSBlcnJvciBvbiBwcm9iaW5n
IGZ1bmN0aW9uIGVudHJ5Lgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAy
NDgvZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZS9kbWVzZy15b2N0
by1rYnVpbGQtMTI6MjAxNDA5MzAwNDE3Mjc6eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMw
MDI0ODozLjEzLjA6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgv
ZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZS9kbWVzZy15b2N0by1r
YnVpbGQtMjU6MjAxNDA5MzAwNDE3MzE6eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0
ODozLjEzLjA6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvZDhl
YzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZS9kbWVzZy15b2N0by1rYnVp
bGQtNDoyMDE0MDkzMDA0MTcyNzp4ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4OjMu
MTMuMDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC9kOGVjMjZk
N2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlL2RtZXNnLXlvY3RvLWtidWlsZC01
OjIwMTQwOTMwMDQxNzI3Ong4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDg6My4xMy4w
OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4L2Q4ZWMyNmQ3Zjgy
ODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUvZG1lc2cteW9jdG8ta2J1aWxkLTY6MjAx
NDA5MzAwNDE3Mjk6eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODozLjEzLjA6MQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvZDhlYzI2ZDdmODI4N2Y1
Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZS9kbWVzZy15b2N0by1rYnVpbGQtNzoyMDE0MDkz
MDA0MTczMzp4ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4OjMuMTMuMDoxCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC9kOGVjMjZkN2Y4Mjg3ZjU3ODhh
NDk0ZjU2ZTg4MTQyMTBmMGU2NGJlL2RtZXNnLXF1YW50YWwta2J1aWxkLTIzOjIwMTQwOTMw
MDQxNzM5Ong4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDg6My4xMy4wOjEKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4L2Q4ZWMyNmQ3ZjgyODdmNTc4OGE0
OTRmNTZlODgxNDIxMGYwZTY0YmUvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMjU6MjAxNDA5MzAw
NDE3NDI6eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODozLjEzLjA6MQova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5
NGY1NmU4ODE0MjEwZjBlNjRiZS9kbWVzZy15b2N0by1rYnVpbGQtMTA6MjAxNDA5MzAwNDE3
Mzg6eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODozLjEzLjA6MQova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1
NmU4ODE0MjEwZjBlNjRiZS9kbWVzZy15b2N0by1rYnVpbGQtMjoyMDE0MDkzMDA0MTczNTp4
ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4OjMuMTMuMDoxCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4
MTQyMTBmMGU2NGJlL2RtZXNnLXF1YW50YWwta2J1aWxkLTk6MjAxNDA5MzAwNDE3NDk6eDg2
XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODozLjEzLjA6MQowOjExOjExIGFsbF9nb29k
OmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA5LTMwIDA0OjIxOjA2IFJFUEVBVCBD
T1VOVDogMjAgICMgL2MvYm9vdC1iaXNlY3QvbGludXgtNC9vYmotYmlzZWN0Ly5yZXBlYXQb
WzBtCgpiaXNlY3Q6IGJhZCBjb21taXQgdjMuMTMKZ2l0IGNoZWNrb3V0IHYzLjEyCmxzIC1h
IC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5
MzAwMjQ4L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDkzMDAwOjVlMDFkYzdiMjZk
OWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTI6YmlzZWN0LWxpbnV4LTQKCjIwMTQtMDkt
MzAgMDQ6MjU6NDIgNWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1MiBj
b21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1
ZS9sa3AtaHN4MDIveDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC01ZTAxZGM3YjI2
ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LzVlMDFkYzdiMjZkOWYyNGYz
OWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMi94ODZfNjQtcmFuZGNvbmZpZy1oc2Iy
LTA5MzAwMjQ4LTVlMDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIKa2Vy
bmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvNWUwMWRjN2Iy
NmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1Mi92bWxpbnV6LTMuMTIuMAoKMjAxNC0w
OS0zMCAwNDoyNzo0MiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4gVEVTVCBGQUlMVVJFClsgICAgNi42OTY1MjRdIFRlc3Rpbmcga3Byb2JlIHRyYWNpbmc6
IApbICAgIDYuNjk4MzQ5XSBDb3VsZCBub3QgaW5zZXJ0IHByb2JlIGF0IGtwcm9iZV90cmFj
ZV9zZWxmdGVzdF90YXJnZXQrMDogLTIyClsgICAgNi43MDM4MzVdIC0tLS0tLS0tLS0tLVsg
Y3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDYuNzE3NzMzXSBXQVJOSU5HOiBDUFU6IDAg
UElEOiAxIGF0IGtlcm5lbC90cmFjZS90cmFjZV9rcHJvYmUuYzoxMzQxIGtwcm9iZV90cmFj
ZV9zZWxmX3Rlc3RzX2luaXQrMHg2OS8weDdmMCgpClsgICAgNi43MTk3OTBdIE1vZHVsZXMg
bGlua2VkIGluOgpbICAgIDYuNzIwNDExXSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIg
Tm90IHRhaW50ZWQgMy4xMi4wICMxClsgICAgNi43MjE2MDldICAwMDAwMDAwMDAwMDAwMDA5
IGZmZmY4ODAwMTI0NGZlMzAgZmZmZmZmZmY4MTUzYzI1OCBmZmZmODgwMDEyNDRmZTY4Clsg
ICAgNi43MjMzNjNdICBmZmZmZmZmZjgxMDdmYzRlIGZmZmZmZmZmODFiMzc5NDIgMDAwMDAw
MDAwMDAwMDAwNyAwMDAwMDAwMDAwMDAwMDAwClsgICAgNi43MjUyMjZdICAwMDAwMDAwMDAw
MDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAxMjQ0ZmU3OCBmZmZmZmZmZjgxMDdm
Y2FhClsgICAgNi43MjcyMjldIENhbGwgVHJhY2U6ClsgICAgNi43Mjc4MTddICBbPGZmZmZm
ZmZmODE1M2MyNTg+XSBkdW1wX3N0YWNrKzB4MmUvMHgzZQpbICAgIDYuNzI4ODc0XSAgWzxm
ZmZmZmZmZjgxMDdmYzRlPl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHhhZS8weGUwClsgICAg
Ni43MzAxNzRdICBbPGZmZmZmZmZmODFiMzc5NDI+XSA/IGluaXRfa3Byb2JlX3RyYWNlKzB4
ZTgvMHhlOApbICAgIDYuNzMxNDY2XSAgWzxmZmZmZmZmZjgxMDdmY2FhPl0gd2Fybl9zbG93
cGF0aF9udWxsKzB4MmEvMHg0MApbICAgIDYuNzMyNzAyXSAgWzxmZmZmZmZmZjgxYjM3OWFi
Pl0ga3Byb2JlX3RyYWNlX3NlbGZfdGVzdHNfaW5pdCsweDY5LzB4N2YwClsgICAgNi43MzQx
MTRdICBbPGZmZmZmZmZmODFiMzc5NDI+XSA/IGluaXRfa3Byb2JlX3RyYWNlKzB4ZTgvMHhl
OApbICAgIDYuNzM1NTgxXSAgWzxmZmZmZmZmZjgxMDAwMzJhPl0gZG9fb25lX2luaXRjYWxs
KzB4MTdhLzB4MjIwClsgICAgNi43MzcwMzRdICBbPGZmZmZmZmZmODFiMTY1Mjg+XSBrZXJu
ZWxfaW5pdF9mcmVlYWJsZSsweDIzMS8weDMyNwpbICAgIDYuNzM4NDQ1XSAgWzxmZmZmZmZm
ZjgxNTM0ZmUwPl0gPyByZXN0X2luaXQrMHgxNjAvMHgxNjAKWyAgICA2LjczOTYzOF0gIFs8
ZmZmZmZmZmY4MTUzNGZmNj5dIGtlcm5lbF9pbml0KzB4MTYvMHgyMzAKWyAgICA2Ljc0MDgz
OF0gIFs8ZmZmZmZmZmY4MTU1M2QwYT5dIHJldF9mcm9tX2ZvcmsrMHg3YS8weGIwClsgICAg
Ni43NDE5MzNdICBbPGZmZmZmZmZmODE1MzRmZTA+XSA/IHJlc3RfaW5pdCsweDE2MC8weDE2
MApbICAgIDYuNzQzMTE4XSAtLS1bIGVuZCB0cmFjZSA3NDJlZWM3ODM2ZmZjZDlmIF0tLS0K
WyAgICA2Ljc0NDEyNF0gZXJyb3Igb24gcHJvYmluZyBmdW5jdGlvbiBlbnRyeS4KL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LzVlMDFkYzdiMjZkOWYyNGYzOWFi
YWNlNWRhOThjY2JkNmE1Y2ViNTIvZG1lc2ctcXVhbnRhbC12cC0yNjoyMDE0MDkzMDA1MzE0
NTp4ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4OjMuMTIuMDoxCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC81ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVk
YTk4Y2NiZDZhNWNlYjUyL2RtZXNnLXF1YW50YWwtdnAtMjc6MjAxNDA5MzAwNTMxNDQ6eDg2
XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODozLjEyLjA6MQova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWhzYjItMDkzMDAyNDgvNWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNj
YmQ2YTVjZWI1Mi9kbWVzZy15b2N0by12cC00ODoyMDE0MDkzMDA1MzE0MDp4ODZfNjQtcmFu
ZGNvbmZpZy1oc2IyLTA5MzAwMjQ4OjMuMTIuMDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaHNiMi0wOTMwMDI0OC81ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNl
YjUyL2RtZXNnLXlvY3RvLXZwLTQ5OjIwMTQwOTMwMDUzMTQwOng4Nl82NC1yYW5kY29uZmln
LWhzYjItMDkzMDAyNDg6My4xMi4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2Iy
LTA5MzAwMjQ4LzVlMDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIvZG1l
c2cteW9jdG8tdnAtNjE6MjAxNDA5MzAwNTMxMzk6eDg2XzY0LXJhbmRjb25maWctaHNiMi0w
OTMwMDI0ODozLjEyLjA6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAy
NDgvNWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1Mi9kbWVzZy1xdWFu
dGFsLXZwLTEwOjIwMTQwOTMwMDUzMTU2Ong4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAy
NDg6My4xMi4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LzVl
MDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIvZG1lc2ctcXVhbnRhbC12
cC0xOjIwMTQwOTMwMDUzMTU1Ong4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDg6My4x
Mi4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LzVlMDFkYzdi
MjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIvZG1lc2cteW9jdG8tdnAtNDoyMDE0
MDkzMDA1MzE0OTp4ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4OjMuMTIuMDoxCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC81ZTAxZGM3YjI2ZDlmMjRm
MzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyL2RtZXNnLXlvY3RvLWl2YjQxLTU4OjIwMTQwOTMw
MDUzMTU4Ong4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDg6Ogova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvNWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5
OGNjYmQ2YTVjZWI1Mi9kbWVzZy15b2N0by12cC0yMToyMDE0MDkzMDA1MzIwNjp4ODZfNjQt
cmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4OjMuMTIuMDoxCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaHNiMi0wOTMwMDI0OC81ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZh
NWNlYjUyL2RtZXNnLXlvY3RvLXZwLTUyOjIwMTQwOTMwMDUzMTU5Ong4Nl82NC1yYW5kY29u
ZmlnLWhzYjItMDkzMDAyNDg6My4xMi4wOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1o
c2IyLTA5MzAwMjQ4LzVlMDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIv
ZG1lc2cteW9jdG8tdnAtNTQ6MjAxNDA5MzAwNTMyMDc6eDg2XzY0LXJhbmRjb25maWctaHNi
Mi0wOTMwMDI0ODozLjEyLjA6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkz
MDAyNDgvNWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1Mi9kbWVzZy15
b2N0by1rYnVpbGQtMTA6MjAxNDA5MzAwNTI5MDQ6eDg2XzY0LXJhbmRjb25maWctaHNiMi0w
OTMwMDI0ODozLjEyLjA6MQowOjEzOjEzIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtb
MTszNW0yMDE0LTA5LTMwIDA1OjMyOjE0IFJFUEVBVCBDT1VOVDogMjAgICMgL2MvYm9vdC1i
aXNlY3QvbGludXgtNC9vYmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpiaXNlY3Q6IGJhZCBjb21t
aXQgdjMuMTIKZ2l0IGNoZWNrb3V0IHYzLjExCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1
ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4L2xpbnV4LWRldmVsOmRl
dmVsLWhvdXJseS0yMDE0MDkzMDAwOjZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5
NGMxOTIxM2U6YmlzZWN0LWxpbnV4LTQKCjIwMTQtMDktMzAgMDU6MzI6MTYgNmU0NjY0NTI1
YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZSBjb21waWxpbmcKUXVldWVkIGJ1aWxk
IHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDIveDg2XzY0LXJh
bmRjb25maWctaHNiMi0wOTMwMDI0OC02ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBh
OTRjMTkyMTNlCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1oc2IyLTA5MzAwMjQ4LzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIx
M2UKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvNmU0
NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZS92bWxpbnV6LTMuMTEuMAoK
MjAxNC0wOS0zMCAwNTozMzoxNiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uLi4gVEVTVCBG
QUlMVVJFClsgICAgOS4xNTgxOTddIFRlc3Rpbmcga3Byb2JlIHRyYWNpbmc6IApbICAgIDku
MTYwMDUyXSBDb3VsZCBub3QgaW5zZXJ0IHByb2JlIGF0IGtwcm9iZV90cmFjZV9zZWxmdGVz
dF90YXJnZXQrMDogLTIyClsgICAgOS4xNjE2ODFdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUg
XS0tLS0tLS0tLS0tLQpbICAgIDkuMTcxOTI1XSBXQVJOSU5HOiBDUFU6IDAgUElEOiAxIGF0
IGtlcm5lbC90cmFjZS90cmFjZV9rcHJvYmUuYzoxMzQxIGtwcm9iZV90cmFjZV9zZWxmX3Rl
c3RzX2luaXQrMHg2OS8weDdmMCgpClsgICAgOS4xNzQzNTFdIE1vZHVsZXMgbGlua2VkIGlu
OgpbICAgIDkuMTc1MDMwXSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50
ZWQgMy4xMS4wICMxClsgICAgOS4xODU2NThdICAwMDAwMDAwMDAwMDAwMDA5IGZmZmY4ODAw
MTI0NDdlMzAgZmZmZmZmZmY4MTUxNTQwMSBmZmZmODgwMDEyNDQ3ZTY4ClsgICAgOS4xOTMx
MzldICBmZmZmZmZmZjgxMDdmMGJlIGZmZmZmZmZmODFhZTY3MGQgMDAwMDAwMDAwMDAwMDAw
NyAwMDAwMDAwMDAwMDAwMDAwClsgICAgOS4yMDQwMjNdICAwMDAwMDAwMDAwMDAwMDAwIDAw
MDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAxMjQ0N2U3OCBmZmZmZmZmZjgxMDdmMTFhClsgICAg
OS4yMDYwMDBdIENhbGwgVHJhY2U6ClsgICAgOS4yMDY2MjVdICBbPGZmZmZmZmZmODE1MTU0
MDE+XSBkdW1wX3N0YWNrKzB4MmUvMHgzZQpbICAgIDkuMjA3OTcwXSAgWzxmZmZmZmZmZjgx
MDdmMGJlPl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHhhZS8weGUwClsgICAgOS4yMTE5NTRd
ICBbPGZmZmZmZmZmODFhZTY3MGQ+XSA/IGluaXRfa3Byb2JlX3RyYWNlKzB4ZTgvMHhlOApb
ICAgIDkuMjE4NTQ4XSAgWzxmZmZmZmZmZjgxMDdmMTFhPl0gd2Fybl9zbG93cGF0aF9udWxs
KzB4MmEvMHg0MApbICAgIDkuMjE5OTk3XSAgWzxmZmZmZmZmZjgxYWU2Nzc2Pl0ga3Byb2Jl
X3RyYWNlX3NlbGZfdGVzdHNfaW5pdCsweDY5LzB4N2YwClsgICAgOS4yMjUyNjBdICBbPGZm
ZmZmZmZmODFhZTY3MGQ+XSA/IGluaXRfa3Byb2JlX3RyYWNlKzB4ZTgvMHhlOApbICAgIDku
MjMyMTQyXSAgWzxmZmZmZmZmZjgxMDAwMzJhPl0gZG9fb25lX2luaXRjYWxsKzB4MTdhLzB4
MjIwClsgICAgOS4yMzM2MTBdICBbPGZmZmZmZmZmODFhYzU1Mjg+XSBrZXJuZWxfaW5pdF9m
cmVlYWJsZSsweDIzMS8weDMxYgpbICAgIDkuMjQwMTAzXSAgWzxmZmZmZmZmZjgxNTBlM2Mw
Pl0gPyByZXN0X2luaXQrMHgxNjAvMHgxNjAKWyAgICA5LjI0NzcwM10gIFs8ZmZmZmZmZmY4
MTUwZTNkNj5dIGtlcm5lbF9pbml0KzB4MTYvMHgyMzAKWyAgICA5LjI0OTA2OF0gIFs8ZmZm
ZmZmZmY4MTUyZDFmYT5dIHJldF9mcm9tX2ZvcmsrMHg3YS8weGIwClsgICAgOS4yNTA0NDFd
ICBbPGZmZmZmZmZmODE1MGUzYzA+XSA/IHJlc3RfaW5pdCsweDE2MC8weDE2MApbICAgIDku
MjUxNzU3XSAtLS1bIGVuZCB0cmFjZSAxMzc0Y2E2Nzc2YTRmNjQyIF0tLS0KWyAgICA5LjI2
MTkyNl0gZXJyb3Igb24gcHJvYmluZyBmdW5jdGlvbiBlbnRyeS4KL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3
MGE5NGMxOTIxM2UvZG1lc2ctcXVhbnRhbC1pdmI0MS0xMDE6MjAxNDA5MzAwNTM1NTQ6eDg2
XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaHNiMi0wOTMwMDI0OC82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTky
MTNlL2RtZXNnLXF1YW50YWwtaXZiNDEtMTY6MjAxNDA5MzAwNTM1NTU6eDg2XzY0LXJhbmRj
b25maWctaHNiMi0wOTMwMDI0ODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMi0w
OTMwMDI0OC82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlL2RtZXNn
LXF1YW50YWwtaXZiNDEtMjI6MjAxNDA5MzAwNTM1NTQ6eDg2XzY0LXJhbmRjb25maWctaHNi
Mi0wOTMwMDI0ODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC82
ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlL2RtZXNnLXF1YW50YWwt
aXZiNDEtNDA6MjAxNDA5MzAwNTM1NDk6eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0
ODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC82ZTQ2NjQ1MjVi
MWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlL2RtZXNnLXF1YW50YWwtaXZiNDEtNTE6
MjAxNDA5MzAwNTM1NTQ6eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODo6Ci9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC82ZTQ2NjQ1MjViMWRiMjhmOGM0
ZTExMzA5NTdmNzBhOTRjMTkyMTNlL2RtZXNnLXF1YW50YWwtaXZiNDEtNzQ6MjAxNDA5MzAw
NTM1NTQ6eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODo6Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdm
NzBhOTRjMTkyMTNlL2RtZXNnLXF1YW50YWwtaXZiNDEtNzc6MjAxNDA5MzAwNTM1NDk6eDg2
XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaHNiMi0wOTMwMDI0OC82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTky
MTNlL2RtZXNnLXF1YW50YWwtaXZiNDEtMTA5OjIwMTQwOTMwMDUzNjA5Ong4Nl82NC1yYW5k
Y29uZmlnLWhzYjItMDkzMDAyNDg6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjIt
MDkzMDAyNDgvNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZS9kbWVz
Zy15b2N0by1pdmI0MS01ODoyMDE0MDkzMDA1MzYwNjp4ODZfNjQtcmFuZGNvbmZpZy1oc2Iy
LTA5MzAwMjQ4OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LzZl
NDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2cteW9jdG8taXZi
NDEtNjc6MjAxNDA5MzAwNTM2MDY6eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODo6
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC82ZTQ2NjQ1MjViMWRi
MjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlL2RtZXNnLXlvY3RvLWl2YjQxLTg0OjIwMTQw
OTMwMDUzNjA4Ong4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDg6Ogova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMw
OTU3ZjcwYTk0YzE5MjEzZS9kbWVzZy15b2N0by1pdmI0MS04NjoyMDE0MDkzMDA1MzYwODp4
ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1oc2IyLTA5MzAwMjQ4LzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMx
OTIxM2UvZG1lc2cteW9jdG8taXZiNDEtOTU6MjAxNDA5MzAwNTM2MDg6eDg2XzY0LXJhbmRj
b25maWctaHNiMi0wOTMwMDI0ODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMi0w
OTMwMDI0OC82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlL2RtZXNn
LXlvY3RvLWtidWlsZC0xNjoyMDE0MDkzMDA1MzMwNjp4ODZfNjQtcmFuZGNvbmZpZy1oc2Iy
LTA5MzAwMjQ4OjMuMTEuMDoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMw
MDI0OC82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlL2RtZXNnLXlv
Y3RvLWtidWlsZC0xODoyMDE0MDkzMDA1MzMwNDp4ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5
MzAwMjQ4OjMuMTEuMDoxCjA6MTU6MTUgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sx
OzM1bTIwMTQtMDktMzAgMDU6MzY6MTcgUkVQRUFUIENPVU5UOiAyMCAgIyAvYy9ib290LWJp
c2VjdC9saW51eC00L29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCmJpc2VjdDogYmFkIGNvbW1p
dCB2My4xMQpnaXQgY2hlY2tvdXQgdjMuMTAKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVl
dWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvbGludXgtZGV2ZWw6ZGV2
ZWwtaG91cmx5LTIwMTQwOTMwMDA6OGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlm
MDc5ZTM3NjpiaXNlY3QtbGludXgtNAoKMjAxNC0wOS0zMCAwNTozNjoxOSA4YmI0OTVlM2Yw
MjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQg
dGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMi94ODZfNjQtcmFu
ZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LThiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5
ZjA3OWUzNzYKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWhzYjItMDkzMDAyNDgvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3
Ngp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUv
bGtwLWhzeDAyLXNtb2tlL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgtOGJiNDk1
ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3NgprZXJuZWw6IC9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC84YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFk
NzdmM2FjOWYwNzllMzc2L3ZtbGludXotMy4xMC4wCgoyMDE0LTA5LTMwIDA1OjM4OjE5IGRl
dGVjdGluZyBib290IHN0YXRlIC4uLiBURVNUIEZBSUxVUkUKWyAgICA2LjkyMTc5NV0gVGVz
dGluZyBrcHJvYmUgdHJhY2luZzogClsgICAgNi45MjM2MjhdIENvdWxkIG5vdCBpbnNlcnQg
cHJvYmUgYXQga3Byb2JlX3RyYWNlX3NlbGZ0ZXN0X3RhcmdldCswOiAtMjIKWyAgICA2Ljky
NTM3OF0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAgNi45MjY0
MTddIFdBUk5JTkc6IGF0IGtlcm5lbC90cmFjZS90cmFjZV9rcHJvYmUuYzoxMzkzIGtwcm9i
ZV90cmFjZV9zZWxmX3Rlc3RzX2luaXQrMHg2OS8weDdmMCgpClsgICAgNi45MzI3MDNdIE1v
ZHVsZXMgbGlua2VkIGluOgpbICAgIDYuOTMzNDcyXSBDUFU6IDAgUElEOiAxIENvbW06IHN3
YXBwZXIgTm90IHRhaW50ZWQgMy4xMC4wICMxClsgICAgNi45MzQ3NzldICAwMDAwMDAwMDAw
MDAwMDA5IGZmZmY4ODAwMTI0ODFlNzggZmZmZmZmZmY4MTRmNWNhZiBmZmZmODgwMDEyNDgx
ZWIwClsgICAgNi45NDA2MDldICBmZmZmZmZmZjgxMDc1YjIxIGZmZmZmZmZmODFhYTM1Zjgg
MDAwMDAwMDAwMDAwMDAwNyAwMDAwMDAwMDAwMDAwMDAwClsgICAgNi45NDI0MDFdICAwMDAw
MDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAxMjQ4MWVjMCBmZmZmZmZm
ZjgxMDc1YjhhClsgICAgNi45NTIzNjddIENhbGwgVHJhY2U6ClsgICAgNi45NTI5NTBdICBb
PGZmZmZmZmZmODE0ZjVjYWY+XSBkdW1wX3N0YWNrKzB4MjcvMHgzMApbICAgIDYuOTU0MTM1
XSAgWzxmZmZmZmZmZjgxMDc1YjIxPl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg5MS8weGQw
ClsgICAgNi45NTU1MjVdICBbPGZmZmZmZmZmODFhYTM1Zjg+XSA/IGluaXRfa3Byb2JlX3Ry
YWNlKzB4ZTgvMHhlOApbICAgIDYuOTU2OTkzXSAgWzxmZmZmZmZmZjgxMDc1YjhhPl0gd2Fy
bl9zbG93cGF0aF9udWxsKzB4MmEvMHg0MApbICAgIDYuOTU4MzE3XSAgWzxmZmZmZmZmZjgx
YWEzNjYxPl0ga3Byb2JlX3RyYWNlX3NlbGZfdGVzdHNfaW5pdCsweDY5LzB4N2YwClsgICAg
Ni45NTk4NTNdICBbPGZmZmZmZmZmODFhYTM1Zjg+XSA/IGluaXRfa3Byb2JlX3RyYWNlKzB4
ZTgvMHhlOApbICAgIDYuOTYxMjY4XSAgWzxmZmZmZmZmZjgxMDAwMzFhPl0gZG9fb25lX2lu
aXRjYWxsKzB4MTZhLzB4MjIwClsgICAgNi45NjQ2NDFdICBbPGZmZmZmZmZmODFhODM0ZjU+
XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDIzMS8weDMxYgpbICAgIDYuOTY2MDQzXSAgWzxm
ZmZmZmZmZjgxNGVlNmYwPl0gPyByZXN0X2luaXQrMHgxNjAvMHgxNjAKWyAgICA2Ljk3Mjk4
MV0gIFs8ZmZmZmZmZmY4MTRlZTcwNj5dIGtlcm5lbF9pbml0KzB4MTYvMHgyMzAKWyAgICA2
Ljk3NDIyMV0gIFs8ZmZmZmZmZmY4MTUwOWMzYT5dIHJldF9mcm9tX2ZvcmsrMHg3YS8weGIw
ClsgICAgNi45NzU0NjhdICBbPGZmZmZmZmZmODE0ZWU2ZjA+XSA/IHJlc3RfaW5pdCsweDE2
MC8weDE2MApbICAgIDYuOTc2ODA0XSAtLS1bIGVuZCB0cmFjZSBhZWZlZTg2MzVmMDE4NWE0
IF0tLS0KWyAgICA2Ljk3Nzg2Ml0gZXJyb3Igb24gcHJvYmluZyBmdW5jdGlvbiBlbnRyeS4K
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LzhiYjQ5NWUzZjAyNDAx
ZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1lc2cteW9jdG8taXZiNDEtMTc6MjAxNDA5
MzAwNTM5MTg6eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODo6Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC84YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFk
NzdmM2FjOWYwNzllMzc2L2RtZXNnLXF1YW50YWwtaXZiNDEtMTEyOjIwMTQwOTMwMDUzOTI1
Ong4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDg6Ogova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWhzYjItMDkzMDAyNDgvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlm
MDc5ZTM3Ni9kbWVzZy1xdWFudGFsLWl2YjQxLTEyOjIwMTQwOTMwMDUzOTI0Ong4Nl82NC1y
YW5kY29uZmlnLWhzYjItMDkzMDAyNDg6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhz
YjItMDkzMDAyNDgvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9k
bWVzZy1xdWFudGFsLWl2YjQxLTE2OjIwMTQwOTMwMDUzOTIzOng4Nl82NC1yYW5kY29uZmln
LWhzYjItMDkzMDAyNDg6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAy
NDgvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVzZy1xdWFu
dGFsLWl2YjQxLTU2OjIwMTQwOTMwMDUzOTI0Ong4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkz
MDAyNDg6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvOGJiNDk1
ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVzZy1xdWFudGFsLWl2YjQx
LTgxOjIwMTQwOTMwMDUzOTI1Ong4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDg6Ogov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvOGJiNDk1ZTNmMDI0MDFl
ZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVzZy1xdWFudGFsLWl2YjQxLTkzOjIwMTQw
OTMwMDUzOTI1Ong4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDg6Ogova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIx
ZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVzZy1xdWFudGFsLWl2YjQxLTk2OjIwMTQwOTMwMDUzOTI1
Ong4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDg6Ogova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLWhzYjItMDkzMDAyNDgvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlm
MDc5ZTM3Ni9kbWVzZy15b2N0by1pdmI0MS0xMDU6MjAxNDA5MzAwNTM5MTg6eDg2XzY0LXJh
bmRjb25maWctaHNiMi0wOTMwMDI0ODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNi
Mi0wOTMwMDI0OC84YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2L2Rt
ZXNnLXlvY3RvLWl2YjQxLTIwOjIwMTQwOTMwMDUzOTIwOng4Nl82NC1yYW5kY29uZmlnLWhz
YjItMDkzMDAyNDg6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgv
OGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVzZy15b2N0by1p
dmI0MS00NDoyMDE0MDkzMDA1MzkxOTp4ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4
OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LzhiYjQ5NWUzZjAy
NDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1lc2cteW9jdG8taXZiNDEtNTk6MjAx
NDA5MzAwNTM5MTg6eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODo6Ci9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC84YmI0OTVlM2YwMjQwMWVlNmY3NmQx
YjFkNzdmM2FjOWYwNzllMzc2L2RtZXNnLXlvY3RvLWl2YjQxLTU6MjAxNDA5MzAwNTM5MjA6
eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaHNiMi0wOTMwMDI0OC84YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYw
NzllMzc2L2RtZXNnLXlvY3RvLWl2YjQxLTcyOjIwMTQwOTMwMDUzOTE3Ong4Nl82NC1yYW5k
Y29uZmlnLWhzYjItMDkzMDAyNDg6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjIt
MDkzMDAyNDgvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni9kbWVz
Zy15b2N0by1pdmI0MS03NjoyMDE0MDkzMDA1MzkxODp4ODZfNjQtcmFuZGNvbmZpZy1oc2Iy
LTA5MzAwMjQ4OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4Lzhi
YjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1lc2cteW9jdG8taXZi
NDEtOToyMDE0MDkzMDA1MzkxODp4ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4OjoK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LzhiYjQ5NWUzZjAyNDAx
ZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1lc2cteW9jdG8ta2J1aWxkLTIyOjIwMTQw
OTMwMDUzNjIyOng4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDg6My4xMC4wOjEKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LzhiYjQ5NWUzZjAyNDAxZWU2
Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1lc2cteW9jdG8ta2J1aWxkLTI1OjIwMTQwOTMw
MDUzNjE4Ong4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDg6My4xMC4wOjEKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2
ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYvZG1lc2cteW9jdG8ta2J1aWxkLTMxOjIwMTQwOTMwMDUz
NjE4Ong4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDg6My4xMC4wOjEKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LzhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFi
MWQ3N2YzYWM5ZjA3OWUzNzYvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMjM6MjAxNDA5MzAwNTM2
Mjk6eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODozLjEwLjA6MQowOjIwOjIwIGFs
bF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA5LTMwIDA1OjM5OjUwIFJF
UEVBVCBDT1VOVDogMjAgICMgL2MvYm9vdC1iaXNlY3QvbGludXgtNC9vYmotYmlzZWN0Ly5y
ZXBlYXQbWzBtCgpiaXNlY3Q6IGJhZCBjb21taXQgdjMuMTAKZ2l0IGNoZWNrb3V0IHYzLjkK
bHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhz
YjItMDkzMDAyNDgvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwOTMwMDA6YzFiZTVh
NWIxYjM1NWQ0MGU2Y2Y3OWNjOTc5ZWI2NmRhZmEyNGFkMTpiaXNlY3QtbGludXgtNAoKMjAx
NC0wOS0zMCAwNTo0MDowMyBjMWJlNWE1YjFiMzU1ZDQwZTZjZjc5Y2M5NzllYjY2ZGFmYTI0
YWQxIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL2xrcC1oc3gwMi94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LWMxYmU1
YTViMWIzNTVkNDBlNmNmNzljYzk3OWViNjZkYWZhMjRhZDEKQ2hlY2sgZm9yIGtlcm5lbCBp
biAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvYzFiZTVhNWIxYjM1
NWQ0MGU2Y2Y3OWNjOTc5ZWI2NmRhZmEyNGFkMQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9m
IC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAyL3g4Nl82NC1yYW5kY29uZmln
LWhzYjItMDkzMDAyNDgtYzFiZTVhNWIxYjM1NWQ0MGU2Y2Y3OWNjOTc5ZWI2NmRhZmEyNGFk
MQobWzE7MzVtMjAxNC0wOS0zMCAwNTo0MzowNCBObyBidWlsZCBzZXJ2ZWQgZmlsZSAva2J1
aWxkLXRlc3RzL2J1aWxkLXNlcnZlZC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4
LWMxYmU1YTViMWIzNTVkNDBlNmNmNzljYzk3OWViNjZkYWZhMjRhZDEbWzBtClJldHJ5IGJ1
aWxkIC4uCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4
L2MxYmU1YTViMWIzNTVkNDBlNmNmNzljYzk3OWViNjZkYWZhMjRhZDEvdm1saW51ei0zLjku
MAoKMjAxNC0wOS0zMCAwNTo0NDowNCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTIwIFNVQ0NF
U1MKCmJpc2VjdDogZ29vZCBjb21taXQgdjMuOQpnaXQgYmlzZWN0IHN0YXJ0IHYzLjEwIHYz
LjkgLS0KL2Mva2VybmVsLXRlc3RzL2xpbmVhci1iaXNlY3Q6IFsiLWIiLCAidjMuMTAiLCAi
LWciLCAidjMuOSIsICIvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIiwgIi9jL2Jvb3QtYmlzZWN0L2xpbnV4LTQvb2JqLWJpc2VjdCJdCkJpc2VjdGluZzog
MTQ3MzcgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDE0IHN0
ZXBzKQpbZmY4OWFjYzU2M2EwYmQ0OTk2NTY3NGY1NjU1MmFkNjYyMDQxNWZlMl0gTWVyZ2Ug
YnJhbmNoICdyY3UvdXJnZW50JyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xp
bnV4L2tlcm5lbC9naXQvcGF1bG1jay9saW51eC1yY3UKcnVubmluZyAvYy9rZXJuZWwtdGVz
dHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTQv
b2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJh
bmRjb25maWctaHNiMi0wOTMwMDI0OC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA5
MzAwMDpmZjg5YWNjNTYzYTBiZDQ5OTY1Njc0ZjU2NTUyYWQ2NjIwNDE1ZmUyOmJpc2VjdC1s
aW51eC00CgoyMDE0LTA5LTMwIDA1OjQ2OjE1IGZmODlhY2M1NjNhMGJkNDk5NjU2NzRmNTY1
NTJhZDY2MjA0MTVmZTIgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAyL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkz
MDAyNDgtZmY4OWFjYzU2M2EwYmQ0OTk2NTY3NGY1NjU1MmFkNjYyMDQxNWZlMgpDaGVjayBm
b3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC9m
Zjg5YWNjNTYzYTBiZDQ5OTY1Njc0ZjU2NTUyYWQ2NjIwNDE1ZmUyCndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDIveDg2XzY0
LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC1mZjg5YWNjNTYzYTBiZDQ5OTY1Njc0ZjU2NTUy
YWQ2NjIwNDE1ZmUyChtbMTszNW0yMDE0LTA5LTMwIDA1OjQ4OjE1IE5vIGJ1aWxkIHNlcnZl
ZCBmaWxlIC9rYnVpbGQtdGVzdHMvYnVpbGQtc2VydmVkL3g4Nl82NC1yYW5kY29uZmlnLWhz
YjItMDkzMDAyNDgtZmY4OWFjYzU2M2EwYmQ0OTk2NTY3NGY1NjU1MmFkNjYyMDQxNWZlMhtb
MG0KUmV0cnkgYnVpbGQgLi4Ka2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhz
YjItMDkzMDAyNDgvZmY4OWFjYzU2M2EwYmQ0OTk2NTY3NGY1NjU1MmFkNjYyMDQxNWZlMi92
bWxpbnV6LTMuMTAuMC1yYzEtMDAyMDItZ2ZmODlhY2MKCjIwMTQtMDktMzAgMDU6NDk6MTUg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxODIwIHJl
dmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMSBzdGVwcykKW2U0
MzI3ODU5MzQxZjJkM2E5M2I0YjZmZWYyZWE0ODNlYWMxYzI3MGNdIE1lcmdlIGJyYW5jaCAn
Zm9yLTMuMTAnIG9mIGdpdDovL2dpdC5zYW1iYS5vcmcvc2ZyZW5jaC9jaWZzLTIuNgpydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9v
dC1iaXNlY3QvbGludXgtNC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1
ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4L2xpbnV4LWRldmVsOmRl
dmVsLWhvdXJseS0yMDE0MDkzMDAwOmU0MzI3ODU5MzQxZjJkM2E5M2I0YjZmZWYyZWE0ODNl
YWMxYzI3MGM6YmlzZWN0LWxpbnV4LTQKCjIwMTQtMDktMzAgMDU6NTA6NDkgZTQzMjc4NTkz
NDFmMmQzYTkzYjRiNmZlZjJlYTQ4M2VhYzFjMjcwYyBjb21waWxpbmcKUXVldWVkIGJ1aWxk
IHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDIveDg2XzY0LXJh
bmRjb25maWctaHNiMi0wOTMwMDI0OC1lNDMyNzg1OTM0MWYyZDNhOTNiNGI2ZmVmMmVhNDgz
ZWFjMWMyNzBjCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1oc2IyLTA5MzAwMjQ4L2U0MzI3ODU5MzQxZjJkM2E5M2I0YjZmZWYyZWE0ODNlYWMxYzI3
MGMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
L2xrcC1oc3gwMi94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LWU0MzI3ODU5MzQx
ZjJkM2E5M2I0YjZmZWYyZWE0ODNlYWMxYzI3MGMKG1sxOzM1bTIwMTQtMDktMzAgMDU6NTg6
NDkgTm8gYnVpbGQgc2VydmVkIGZpbGUgL2tidWlsZC10ZXN0cy9idWlsZC1zZXJ2ZWQveDg2
XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC1lNDMyNzg1OTM0MWYyZDNhOTNiNGI2ZmVm
MmVhNDgzZWFjMWMyNzBjG1swbQpSZXRyeSBidWlsZCAuLgp3YWl0aW5nIGZvciBjb21wbGV0
aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAyLXNtb2tlL3g4Nl82
NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgtZTQzMjc4NTkzNDFmMmQzYTkzYjRiNmZlZjJl
YTQ4M2VhYzFjMjcwYwprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMi0w
OTMwMDI0OC9lNDMyNzg1OTM0MWYyZDNhOTNiNGI2ZmVmMmVhNDgzZWFjMWMyNzBjL3ZtbGlu
dXotMy4xMC4wLXJjNC0wMDI0MC1nZTQzMjc4NQoKMjAxNC0wOS0zMCAwNzowMjo0OSBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTE3CTIwIFNVQ0NFU1MK
CkJpc2VjdGluZzogNjk2IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91
Z2hseSAxMCBzdGVwcykKWzI2MDFkZWQ3ZmQ4ODI3ZGRiY2M0NTBjYmZiMTUzYjNmM2M1OWI0
NDNdIE1lcmdlIHRhZyAnc291bmQtMy4xMCcgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHVi
L3NjbS9saW51eC9rZXJuZWwvZ2l0L3Rpd2FpL3NvdW5kCnJ1bm5pbmcgL2Mva2VybmVsLXRl
c3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC00
L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1y
YW5kY29uZmlnLWhzYjItMDkzMDAyNDgvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQw
OTMwMDA6MjYwMWRlZDdmZDg4MjdkZGJjYzQ1MGNiZmIxNTNiM2YzYzU5YjQ0MzpiaXNlY3Qt
bGludXgtNAoKMjAxNC0wOS0zMCAwODoxMToyNiAyNjAxZGVkN2ZkODgyN2RkYmNjNDUwY2Jm
YjE1M2IzZjNjNTliNDQzIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMi94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5
MzAwMjQ4LTI2MDFkZWQ3ZmQ4ODI3ZGRiY2M0NTBjYmZiMTUzYjNmM2M1OWI0NDMKQ2hlY2sg
Zm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgv
MjYwMWRlZDdmZDg4MjdkZGJjYzQ1MGNiZmIxNTNiM2YzYzU5YjQ0Mwp3YWl0aW5nIGZvciBj
b21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAyL3g4Nl82
NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgtMjYwMWRlZDdmZDg4MjdkZGJjYzQ1MGNiZmIx
NTNiM2YzYzU5YjQ0MwprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMi0w
OTMwMDI0OC8yNjAxZGVkN2ZkODgyN2RkYmNjNDUwY2JmYjE1M2IzZjNjNTliNDQzL3ZtbGlu
dXotMy4xMC4wLXJjNi0wMDA1Ni1nMjYwMWRlZAoKMjAxNC0wOS0zMCAwODoxMzoyNiBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAuLgkxNwkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDI3NCByZXZp
c2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOSBzdGVwcykKWzllODk1
YWNlNWQ4MmRmODkyOWIxNmY1OGU5ZjUxNWY2ZDU0YWI4MmRdIExpbnV4IDMuMTAtcmM3CnJ1
bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9i
b290LWJpc2VjdC9saW51eC00L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4t
cXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvbGludXgtZGV2ZWw6
ZGV2ZWwtaG91cmx5LTIwMTQwOTMwMDA6OWU4OTVhY2U1ZDgyZGY4OTI5YjE2ZjU4ZTlmNTE1
ZjZkNTRhYjgyZDpiaXNlY3QtbGludXgtNAoKMjAxNC0wOS0zMCAwODoxNTo0MSA5ZTg5NWFj
ZTVkODJkZjg5MjliMTZmNThlOWY1MTVmNmQ1NGFiODJkIGNvbXBpbGluZwpRdWV1ZWQgYnVp
bGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMi94ODZfNjQt
cmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LTllODk1YWNlNWQ4MmRmODkyOWIxNmY1OGU5ZjUx
NWY2ZDU0YWI4MmQKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWhzYjItMDkzMDAyNDgvOWU4OTVhY2U1ZDgyZGY4OTI5YjE2ZjU4ZTlmNTE1ZjZkNTRh
YjgyZAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVl
dWUvbGtwLWhzeDAyL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgtOWU4OTVhY2U1
ZDgyZGY4OTI5YjE2ZjU4ZTlmNTE1ZjZkNTRhYjgyZAprZXJuZWw6IC9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC85ZTg5NWFjZTVkODJkZjg5MjliMTZmNThlOWY1
MTVmNmQ1NGFiODJkL3ZtbGludXotMy4xMC4wLXJjNwoKMjAxNC0wOS0zMCAwODoxNzo0MSBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgkxMQkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDE2OCBy
ZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOCBzdGVwcykKWzFh
NTA2ZTQ3MzU3NmNkY2I5MjJkMzM5YWVhNzZiNjdkMGZlMzQ0ZjddIE1lcmdlIGJyYW5jaCAn
ZHJtLWZpeGVzJyBvZiBnaXQ6Ly9wZW9wbGUuZnJlZWRlc2t0b3Aub3JnL35haXJsaWVkL2xp
bnV4CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aCAvYy9ib290LWJpc2VjdC9saW51eC00L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0
cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvbGludXgt
ZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwOTMwMDA6MWE1MDZlNDczNTc2Y2RjYjkyMmQzMzlh
ZWE3NmI2N2QwZmUzNDRmNzpiaXNlY3QtbGludXgtNAoKMjAxNC0wOS0zMCAwODoxOTo0MyAx
YTUwNmU0NzM1NzZjZGNiOTIyZDMzOWFlYTc2YjY3ZDBmZTM0NGY3IGNvbXBpbGluZwpRdWV1
ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMi94
ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LTFhNTA2ZTQ3MzU3NmNkY2I5MjJkMzM5
YWVhNzZiNjdkMGZlMzQ0ZjcKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWhzYjItMDkzMDAyNDgvMWE1MDZlNDczNTc2Y2RjYjkyMmQzMzlhZWE3NmI2
N2QwZmUzNDRmNwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVp
bGQtcXVldWUvbGtwLWhzeDAyL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgtMWE1
MDZlNDczNTc2Y2RjYjkyMmQzMzlhZWE3NmI2N2QwZmUzNDRmNwobWzE7MzVtMjAxNC0wOS0z
MCAwODoyMTo0MyBObyBidWlsZCBzZXJ2ZWQgZmlsZSAva2J1aWxkLXRlc3RzL2J1aWxkLXNl
cnZlZC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LTFhNTA2ZTQ3MzU3NmNkY2I5
MjJkMzM5YWVhNzZiNjdkMGZlMzQ0ZjcbWzBtClJldHJ5IGJ1aWxkIC4uCmtlcm5lbDogL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LzFhNTA2ZTQ3MzU3NmNkY2I5
MjJkMzM5YWVhNzZiNjdkMGZlMzQ0Zjcvdm1saW51ei0zLjEwLjAtcmM3LTAwMDU0LWcxYTUw
NmU0CgoyMDE0LTA5LTMwIDA4OjIyOjQzIGRldGVjdGluZyBib290IHN0YXRlIC4uIFRFU1Qg
RkFJTFVSRQpbICAgIDguMzI1ODAzXSBUZXN0aW5nIGtwcm9iZSB0cmFjaW5nOiAKWyAgICA4
LjMyODIwMF0gQ291bGQgbm90IGluc2VydCBwcm9iZSBhdCBrcHJvYmVfdHJhY2Vfc2VsZnRl
c3RfdGFyZ2V0KzA6IC0yMgpbICAgIDguMzI5ODEzXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJl
IF0tLS0tLS0tLS0tLS0KWyAgICA4LjMzMDk0Nl0gV0FSTklORzogYXQga2VybmVsL3RyYWNl
L3RyYWNlX2twcm9iZS5jOjEzOTMga3Byb2JlX3RyYWNlX3NlbGZfdGVzdHNfaW5pdCsweDY5
LzB4N2YwKCkKWyAgICA4LjM0OTc4OV0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgOC4zNTA2
MTddIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjEwLjAtcmM3
LTAwMDU0LWcxYTUwNmU0ICMxClsgICAgOC4zNTIyNjhdICAwMDAwMDAwMDAwMDAwMDA5IGZm
ZmY4ODAwMTI0ODFlNzggZmZmZmZmZmY4MTRmNWJkZiBmZmZmODgwMDEyNDgxZWIwClsgICAg
OC4zNTQwNzldICBmZmZmZmZmZjgxMDc1YjIxIGZmZmZmZmZmODFhYTM1ZjggMDAwMDAwMDAw
MDAwMDAwNyAwMDAwMDAwMDAwMDAwMDAwClsgICAgOC4zNTU4NTFdICAwMDAwMDAwMDAwMDAw
MDAwIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAxMjQ4MWVjMCBmZmZmZmZmZjgxMDc1Yjhh
ClsgICAgOC4zNTc2ODZdIENhbGwgVHJhY2U6ClsgICAgOC4zNTgzMjFdICBbPGZmZmZmZmZm
ODE0ZjViZGY+XSBkdW1wX3N0YWNrKzB4MjcvMHgzMApbICAgIDguMzY4MzEzXSAgWzxmZmZm
ZmZmZjgxMDc1YjIxPl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg5MS8weGQwClsgICAgOC4z
Nzg4MDBdICBbPGZmZmZmZmZmODFhYTM1Zjg+XSA/IGluaXRfa3Byb2JlX3RyYWNlKzB4ZTgv
MHhlOApbICAgIDguMzgwMTE1XSAgWzxmZmZmZmZmZjgxMDc1YjhhPl0gd2Fybl9zbG93cGF0
aF9udWxsKzB4MmEvMHg0MApbICAgIDguMzgxNDQ3XSAgWzxmZmZmZmZmZjgxYWEzNjYxPl0g
a3Byb2JlX3RyYWNlX3NlbGZfdGVzdHNfaW5pdCsweDY5LzB4N2YwClsgICAgOC4zODMwMzhd
ICBbPGZmZmZmZmZmODFhYTM1Zjg+XSA/IGluaXRfa3Byb2JlX3RyYWNlKzB4ZTgvMHhlOApb
ICAgIDguMzg0NDEzXSAgWzxmZmZmZmZmZjgxMDAwMzFhPl0gZG9fb25lX2luaXRjYWxsKzB4
MTZhLzB4MjIwClsgICAgOC4zODU2ODldICBbPGZmZmZmZmZmODFhODM0ZjU+XSBrZXJuZWxf
aW5pdF9mcmVlYWJsZSsweDIzMS8weDMxYgpbICAgIDguMzg3MTM0XSAgWzxmZmZmZmZmZjgx
NGVlNjIwPl0gPyByZXN0X2luaXQrMHgxNjAvMHgxNjAKWyAgICA4LjM5Njg1Nl0gIFs8ZmZm
ZmZmZmY4MTRlZTYzNj5dIGtlcm5lbF9pbml0KzB4MTYvMHgyMzAKWyAgICA4LjQwMzIyMV0g
IFs8ZmZmZmZmZmY4MTUwOWIzYT5dIHJldF9mcm9tX2ZvcmsrMHg3YS8weGIwClsgICAgOC40
MDc3NjVdICBbPGZmZmZmZmZmODE0ZWU2MjA+XSA/IHJlc3RfaW5pdCsweDE2MC8weDE2MApb
ICAgIDguNDExMTg2XSAtLS1bIGVuZCB0cmFjZSA0Mjg2MmIwMTJjYzBkMjM3IF0tLS0KWyAg
ICA4LjQxMzE1MF0gZXJyb3Igb24gcHJvYmluZyBmdW5jdGlvbiBlbnRyeS4KL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LzFhNTA2ZTQ3MzU3NmNkY2I5MjJkMzM5
YWVhNzZiNjdkMGZlMzQ0ZjcvZG1lc2cteW9jdG8taXZiNDEtOTA6MjAxNDA5MzAwODIzMjI6
eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaHNiMi0wOTMwMDI0OC8xYTUwNmU0NzM1NzZjZGNiOTIyZDMzOWFlYTc2YjY3ZDBm
ZTM0NGY3L2RtZXNnLXF1YW50YWwtaXZiNDEtMTAwOjIwMTQwOTMwMDgyMzMwOng4Nl82NC1y
YW5kY29uZmlnLWhzYjItMDkzMDAyNDg6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhz
YjItMDkzMDAyNDgvMWE1MDZlNDczNTc2Y2RjYjkyMmQzMzlhZWE3NmI2N2QwZmUzNDRmNy9k
bWVzZy1xdWFudGFsLWl2YjQxLTE4OjIwMTQwOTMwMDgyMzMyOng4Nl82NC1yYW5kY29uZmln
LWhzYjItMDkzMDAyNDg6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAy
NDgvMWE1MDZlNDczNTc2Y2RjYjkyMmQzMzlhZWE3NmI2N2QwZmUzNDRmNy9kbWVzZy1xdWFu
dGFsLWl2YjQxLTE5OjIwMTQwOTMwMDgyMzMwOng4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkz
MDAyNDg6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvMWE1MDZl
NDczNTc2Y2RjYjkyMmQzMzlhZWE3NmI2N2QwZmUzNDRmNy9kbWVzZy1xdWFudGFsLWl2YjQx
LTI4OjIwMTQwOTMwMDgyMzMwOng4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDg6Ogov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvMWE1MDZlNDczNTc2Y2Rj
YjkyMmQzMzlhZWE3NmI2N2QwZmUzNDRmNy9kbWVzZy1xdWFudGFsLWl2YjQxLTI6MjAxNDA5
MzAwODIzMzE6eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODo6Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC8xYTUwNmU0NzM1NzZjZGNiOTIyZDMzOWFl
YTc2YjY3ZDBmZTM0NGY3L2RtZXNnLXF1YW50YWwtaXZiNDEtMzA6MjAxNDA5MzAwODIzMjk6
eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaHNiMi0wOTMwMDI0OC8xYTUwNmU0NzM1NzZjZGNiOTIyZDMzOWFlYTc2YjY3ZDBm
ZTM0NGY3L2RtZXNnLXF1YW50YWwtaXZiNDEtNDg6MjAxNDA5MzAwODIzMzE6eDg2XzY0LXJh
bmRjb25maWctaHNiMi0wOTMwMDI0ODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNi
Mi0wOTMwMDI0OC8xYTUwNmU0NzM1NzZjZGNiOTIyZDMzOWFlYTc2YjY3ZDBmZTM0NGY3L2Rt
ZXNnLXF1YW50YWwtaXZiNDEtNTE6MjAxNDA5MzAwODIzMzI6eDg2XzY0LXJhbmRjb25maWct
aHNiMi0wOTMwMDI0ODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0
OC8xYTUwNmU0NzM1NzZjZGNiOTIyZDMzOWFlYTc2YjY3ZDBmZTM0NGY3L2RtZXNnLXF1YW50
YWwtaXZiNDEtNzc6MjAxNDA5MzAwODIzMzE6eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMw
MDI0ODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC8xYTUwNmU0
NzM1NzZjZGNiOTIyZDMzOWFlYTc2YjY3ZDBmZTM0NGY3L2RtZXNnLXF1YW50YWwtaXZiNDEt
ODI6MjAxNDA5MzAwODIzMzE6eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODo6Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC8xYTUwNmU0NzM1NzZjZGNi
OTIyZDMzOWFlYTc2YjY3ZDBmZTM0NGY3L2RtZXNnLXF1YW50YWwtaXZiNDEtOTI6MjAxNDA5
MzAwODIzMzE6eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODo6Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC8xYTUwNmU0NzM1NzZjZGNiOTIyZDMzOWFl
YTc2YjY3ZDBmZTM0NGY3L2RtZXNnLXlvY3RvLWl2YjQxLTE2OjIwMTQwOTMwMDgyMzI1Ong4
Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDg6Ogova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWhzYjItMDkzMDAyNDgvMWE1MDZlNDczNTc2Y2RjYjkyMmQzMzlhZWE3NmI2N2QwZmUz
NDRmNy9kbWVzZy15b2N0by1pdmI0MS0zNzoyMDE0MDkzMDA4MjMyNDp4ODZfNjQtcmFuZGNv
bmZpZy1oc2IyLTA5MzAwMjQ4OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5
MzAwMjQ4LzFhNTA2ZTQ3MzU3NmNkY2I5MjJkMzM5YWVhNzZiNjdkMGZlMzQ0ZjcvZG1lc2ct
eW9jdG8taXZiNDEtNDM6MjAxNDA5MzAwODIzMjQ6eDg2XzY0LXJhbmRjb25maWctaHNiMi0w
OTMwMDI0ODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC8xYTUw
NmU0NzM1NzZjZGNiOTIyZDMzOWFlYTc2YjY3ZDBmZTM0NGY3L2RtZXNnLXlvY3RvLWl2YjQx
LTU1OjIwMTQwOTMwMDgyMzI1Ong4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDg6Ogov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvMWE1MDZlNDczNTc2Y2Rj
YjkyMmQzMzlhZWE3NmI2N2QwZmUzNDRmNy9kbWVzZy15b2N0by1pdmI0MS01NjoyMDE0MDkz
MDA4MjMyNjp4ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4OjoKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LzFhNTA2ZTQ3MzU3NmNkY2I5MjJkMzM5YWVh
NzZiNjdkMGZlMzQ0ZjcvZG1lc2cteW9jdG8taXZiNDEtNjk6MjAxNDA5MzAwODIzMjc6eDg2
XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaHNiMi0wOTMwMDI0OC8xYTUwNmU0NzM1NzZjZGNiOTIyZDMzOWFlYTc2YjY3ZDBmZTM0
NGY3L2RtZXNnLXlvY3RvLWl2YjQxLTkyOjIwMTQwOTMwMDgyMzI2Ong4Nl82NC1yYW5kY29u
ZmlnLWhzYjItMDkzMDAyNDg6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkz
MDAyNDgvMWE1MDZlNDczNTc2Y2RjYjkyMmQzMzlhZWE3NmI2N2QwZmUzNDRmNy9kbWVzZy15
b2N0by1pdmI0MS05NDoyMDE0MDkzMDA4MjMyNTp4ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5
MzAwMjQ4OjoKMDoyMDoyMCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAx
NC0wOS0zMCAwODoyMzo0NCBSRVBFQVQgQ09VTlQ6IDIwICAjIC9jL2Jvb3QtYmlzZWN0L2xp
bnV4LTQvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiA1NCByZXZpc2lvbnMg
bGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNiBzdGVwcykKWzc4NzUwZjE5MDg4
NjljM2JmY2JmMmExZjFmMDBmMDc4ZjI5NDgyNzFdIE1lcmdlIGJyYW5jaCAnZm9yLWxpbnVz
JyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvc2Fn
ZS9jZXBoLWNsaWVudApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290
LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtNC9vYmotYmlzZWN0CmxzIC1hIC9r
YnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAw
MjQ4L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDkzMDAwOjc4NzUwZjE5MDg4Njlj
M2JmY2JmMmExZjFmMDBmMDc4ZjI5NDgyNzE6YmlzZWN0LWxpbnV4LTQKCjIwMTQtMDktMzAg
MDg6MjM6NDYgNzg3NTBmMTkwODg2OWMzYmZjYmYyYTFmMWYwMGYwNzhmMjk0ODI3MSBjb21w
aWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9s
a3AtaHN4MDIveDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC03ODc1MGYxOTA4ODY5
YzNiZmNiZjJhMWYxZjAwZjA3OGYyOTQ4MjcxCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4Lzc4NzUwZjE5MDg4NjljM2JmY2Jm
MmExZjFmMDBmMDc4ZjI5NDgyNzEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMi94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5
MzAwMjQ4LTc4NzUwZjE5MDg4NjljM2JmY2JmMmExZjFmMDBmMDc4ZjI5NDgyNzEKa2VybmVs
OiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvNzg3NTBmMTkwODg2
OWMzYmZjYmYyYTFmMWYwMGYwNzhmMjk0ODI3MS92bWxpbnV6LTMuMTAuMC1yYzctMDAwMjYt
Zzc4NzUwZjEKCjIwMTQtMDktMzAgMDg6Mzc6NDYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4u
CTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMjggcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRl
ciB0aGlzIChyb3VnaGx5IDUgc3RlcHMpCls1NGZhZjc3ZDA2NTkyNmFkYmNjMmE0OWU2ZGYz
NTU5MDk0Y2M5M2JhXSBNZXJnZSBicmFuY2ggJ3BlcmYtdXJnZW50LWZvci1saW51cycgb2Yg
Z2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RpcC90aXAK
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9j
L2Jvb3QtYmlzZWN0L2xpbnV4LTQvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1
bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC9saW51eC1kZXZl
bDpkZXZlbC1ob3VybHktMjAxNDA5MzAwMDo1NGZhZjc3ZDA2NTkyNmFkYmNjMmE0OWU2ZGYz
NTU5MDk0Y2M5M2JhOmJpc2VjdC1saW51eC00CgoyMDE0LTA5LTMwIDA4OjM5OjUxIDU0ZmFm
NzdkMDY1OTI2YWRiY2MyYTQ5ZTZkZjM1NTkwOTRjYzkzYmEgY29tcGlsaW5nClF1ZXVlZCBi
dWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAyL3g4Nl82
NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgtNTRmYWY3N2QwNjU5MjZhZGJjYzJhNDllNmRm
MzU1OTA5NGNjOTNiYQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaHNiMi0wOTMwMDI0OC81NGZhZjc3ZDA2NTkyNmFkYmNjMmE0OWU2ZGYzNTU5MDk0
Y2M5M2JhCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS9sa3AtaHN4MDIveDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC01NGZhZjc3
ZDA2NTkyNmFkYmNjMmE0OWU2ZGYzNTU5MDk0Y2M5M2JhChtbMTszNW0yMDE0LTA5LTMwIDEx
OjQxOjUyIE5vIGJ1aWxkIHNlcnZlZCBmaWxlIC9rYnVpbGQtdGVzdHMvYnVpbGQtc2VydmVk
L3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgtNTRmYWY3N2QwNjU5MjZhZGJjYzJh
NDllNmRmMzU1OTA5NGNjOTNiYRtbMG0KUmV0cnkgYnVpbGQgLi4Kd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMi1zbW9rZS94
ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LTU0ZmFmNzdkMDY1OTI2YWRiY2MyYTQ5
ZTZkZjM1NTkwOTRjYzkzYmEKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhz
YjItMDkzMDAyNDgvNTRmYWY3N2QwNjU5MjZhZGJjYzJhNDllNmRmMzU1OTA5NGNjOTNiYS92
bWxpbnV6LTMuMTAuMC1yYzctMDAwMzgtZzU0ZmFmNzcKCjIwMTQtMDktMzAgMTE6NDc6NTIg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4uLi4uLi4gVEVTVCBGQUlMVVJFClsgICAg
NC44MjU0NzRdIFRlc3Rpbmcga3Byb2JlIHRyYWNpbmc6IApbICAgIDQuODI3MDM0XSBDb3Vs
ZCBub3QgaW5zZXJ0IHByb2JlIGF0IGtwcm9iZV90cmFjZV9zZWxmdGVzdF90YXJnZXQrMDog
LTIyClsgICAgNC44MjgyMDRdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0t
LQpbICAgIDQuODI4ODU3XSBXQVJOSU5HOiBhdCBrZXJuZWwvdHJhY2UvdHJhY2Vfa3Byb2Jl
LmM6MTM5MyBrcHJvYmVfdHJhY2Vfc2VsZl90ZXN0c19pbml0KzB4NjkvMHg3ZjAoKQpbICAg
IDQuODMwMzM3XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICA0LjgzMDgzNl0gQ1BVOiAwIFBJ
RDogMSBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTAuMC1yYzctMDAwMzgtZzU0ZmFm
NzcgIzEKWyAgICA0LjgzMTkzMl0gIDAwMDAwMDAwMDAwMDAwMDkgZmZmZjg4MDAxMzg4MWU3
OCBmZmZmZmZmZjgxNGY1YmRmIGZmZmY4ODAwMTM4ODFlYjAKWyAgICA0LjgzMzAyMF0gIGZm
ZmZmZmZmODEwNzViMjEgZmZmZmZmZmY4MWFhMzVmOCAwMDAwMDAwMDAwMDAwMDA3IDAwMDAw
MDAwMDAwMDAwMDAKWyAgICA0LjgzNDMxNl0gIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAw
MDAwMDAwMCBmZmZmODgwMDEzODgxZWMwIGZmZmZmZmZmODEwNzViOGEKWyAgICA0LjgzNTU1
MF0gQ2FsbCBUcmFjZToKWyAgICA0LjgzNTkyMF0gIFs8ZmZmZmZmZmY4MTRmNWJkZj5dIGR1
bXBfc3RhY2srMHgyNy8weDMwClsgICAgNC44MzY2MzddICBbPGZmZmZmZmZmODEwNzViMjE+
XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDkxLzB4ZDAKWyAgICA0LjgzNzY3MF0gIFs8ZmZm
ZmZmZmY4MWFhMzVmOD5dID8gaW5pdF9rcHJvYmVfdHJhY2UrMHhlOC8weGU4ClsgICAgNC44
Mzg1MDBdICBbPGZmZmZmZmZmODEwNzViOGE+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgyYS8w
eDQwClsgICAgNC44MzkzMzRdICBbPGZmZmZmZmZmODFhYTM2NjE+XSBrcHJvYmVfdHJhY2Vf
c2VsZl90ZXN0c19pbml0KzB4NjkvMHg3ZjAKWyAgICA0Ljg0MDM4MV0gIFs8ZmZmZmZmZmY4
MWFhMzVmOD5dID8gaW5pdF9rcHJvYmVfdHJhY2UrMHhlOC8weGU4ClsgICAgNC44NDEyMDFd
ICBbPGZmZmZmZmZmODEwMDAzMWE+XSBkb19vbmVfaW5pdGNhbGwrMHgxNmEvMHgyMjAKWyAg
ICA0Ljg0MjEwNl0gIFs8ZmZmZmZmZmY4MWE4MzRmNT5dIGtlcm5lbF9pbml0X2ZyZWVhYmxl
KzB4MjMxLzB4MzFiClsgICAgNC44NDI5NzNdICBbPGZmZmZmZmZmODE0ZWU2MjA+XSA/IHJl
c3RfaW5pdCsweDE2MC8weDE2MApbICAgIDQuODQzODEwXSAgWzxmZmZmZmZmZjgxNGVlNjM2
Pl0ga2VybmVsX2luaXQrMHgxNi8weDIzMApbICAgIDQuODQ0NTQzXSAgWzxmZmZmZmZmZjgx
NTA5YjNhPl0gcmV0X2Zyb21fZm9yaysweDdhLzB4YjAKWyAgICA0Ljg0NTI5Nl0gIFs8ZmZm
ZmZmZmY4MTRlZTYyMD5dID8gcmVzdF9pbml0KzB4MTYwLzB4MTYwClsgICAgNC44NDYxMjRd
IC0tLVsgZW5kIHRyYWNlIDU2MTZiMzk3M2YxOTY4MDQgXS0tLQpbICAgIDQuODQ2ODEyXSBl
cnJvciBvbiBwcm9iaW5nIGZ1bmN0aW9uIGVudHJ5Lgova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWhzYjItMDkzMDAyNDgvNTRmYWY3N2QwNjU5MjZhZGJjYzJhNDllNmRmMzU1OTA5NGNj
OTNiYS9kbWVzZy15b2N0by12cC0xOToyMDE0MDkzMDExNTQ0Njp4ODZfNjQtcmFuZGNvbmZp
Zy1oc2IyLTA5MzAwMjQ4OjMuMTAuMC1yYzctMDAwMzgtZzU0ZmFmNzc6MQova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvNTRmYWY3N2QwNjU5MjZhZGJjYzJhNDll
NmRmMzU1OTA5NGNjOTNiYS9kbWVzZy15b2N0by12cC0yMToyMDE0MDkzMDExNTQ0Nzp4ODZf
NjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4OjMuMTAuMC1yYzctMDAwMzgtZzU0ZmFmNzc6
MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvNTRmYWY3N2QwNjU5
MjZhZGJjYzJhNDllNmRmMzU1OTA5NGNjOTNiYS9kbWVzZy15b2N0by12cC0yNDoyMDE0MDkz
MDExNTQ0NDp4ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4OjMuMTAuMC1yYzctMDAw
MzgtZzU0ZmFmNzc6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgv
NTRmYWY3N2QwNjU5MjZhZGJjYzJhNDllNmRmMzU1OTA5NGNjOTNiYS9kbWVzZy15b2N0by12
cC0yNzoyMDE0MDkzMDExNTQ0NDp4ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4OjMu
MTAuMC1yYzctMDAwMzgtZzU0ZmFmNzc6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhz
YjItMDkzMDAyNDgvNTRmYWY3N2QwNjU5MjZhZGJjYzJhNDllNmRmMzU1OTA5NGNjOTNiYS9k
bWVzZy15b2N0by12cC0yODoyMDE0MDkzMDExNTQ0Nzp4ODZfNjQtcmFuZGNvbmZpZy1oc2Iy
LTA5MzAwMjQ4OjMuMTAuMC1yYzctMDAwMzgtZzU0ZmFmNzc6MQova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWhzYjItMDkzMDAyNDgvNTRmYWY3N2QwNjU5MjZhZGJjYzJhNDllNmRmMzU1
OTA5NGNjOTNiYS9kbWVzZy15b2N0by12cC00MjoyMDE0MDkzMDExNTQ0Nzp4ODZfNjQtcmFu
ZGNvbmZpZy1oc2IyLTA5MzAwMjQ4OjMuMTAuMC1yYzctMDAwMzgtZzU0ZmFmNzc6MQova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvNTRmYWY3N2QwNjU5MjZhZGJj
YzJhNDllNmRmMzU1OTA5NGNjOTNiYS9kbWVzZy15b2N0by12cC02MjoyMDE0MDkzMDExNTQ0
NDp4ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4OjMuMTAuMC1yYzctMDAwMzgtZzU0
ZmFmNzc6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvNTRmYWY3
N2QwNjU5MjZhZGJjYzJhNDllNmRmMzU1OTA5NGNjOTNiYS9kbWVzZy15b2N0by12cC02NDoy
MDE0MDkzMDExNTQ0ODp4ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4OjMuMTAuMC1y
YzctMDAwMzgtZzU0ZmFmNzc6MQowOjg6OCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwob
WzE7MzVtMjAxNC0wOS0zMCAxMTo1NDo1MyBSRVBFQVQgQ09VTlQ6IDIwICAjIC9jL2Jvb3Qt
YmlzZWN0L2xpbnV4LTQvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiAxMiBy
ZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNCBzdGVwcykKW2Rl
NmUxMzE3Zjc0NmZiYzUyN2E3Mzk3NmM1OGI0MTE5ZTUwNmZmN2NdIE1lcmdlIHRhZyAnY3Jp
dGljYWxfZml4X2Zvcl8zLjknIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGlu
dXgva2VybmVsL2dpdC9yd2xvdmUvZmNvZQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtNC9vYmotYmlz
ZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZp
Zy1oc2IyLTA5MzAwMjQ4L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDkzMDAwOmRl
NmUxMzE3Zjc0NmZiYzUyN2E3Mzk3NmM1OGI0MTE5ZTUwNmZmN2M6YmlzZWN0LWxpbnV4LTQK
CjIwMTQtMDktMzAgMTE6NTQ6NTMgZGU2ZTEzMTdmNzQ2ZmJjNTI3YTczOTc2YzU4YjQxMTll
NTA2ZmY3YyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9i
dWlsZC1xdWV1ZS9sa3AtaHN4MDIveDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC1k
ZTZlMTMxN2Y3NDZmYmM1MjdhNzM5NzZjNThiNDExOWU1MDZmZjdjCkNoZWNrIGZvciBrZXJu
ZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4L2RlNmUxMzE3
Zjc0NmZiYzUyN2E3Mzk3NmM1OGI0MTE5ZTUwNmZmN2MKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMi94ODZfNjQtcmFuZGNv
bmZpZy1oc2IyLTA5MzAwMjQ4LWRlNmUxMzE3Zjc0NmZiYzUyN2E3Mzk3NmM1OGI0MTE5ZTUw
NmZmN2MKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgv
ZGU2ZTEzMTdmNzQ2ZmJjNTI3YTczOTc2YzU4YjQxMTllNTA2ZmY3Yy92bWxpbnV6LTMuMTAu
MC1yYzctMDAwMjgtZ2RlNmUxMzEKCjIwMTQtMDktMzAgMTE6NTY6NTMgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgLi4uLgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDEwIHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA0IHN0ZXBzKQpbZTNmZjkxMTQzZWIyYTZl
YWFhYjQ4MzFjODVhMjgzN2E5NWZiYmVhM10gTWVyZ2UgYnJhbmNoICdmaXhlcycgb2YgZ2l0
Oi8vZ2l0LmxpbmFyby5vcmcvcGVvcGxlL3Jtay9saW51eC1hcm0KcnVubmluZyAvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xp
bnV4LTQvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2
XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHkt
MjAxNDA5MzAwMDplM2ZmOTExNDNlYjJhNmVhYWFiNDgzMWM4NWEyODM3YTk1ZmJiZWEzOmJp
c2VjdC1saW51eC00CgoyMDE0LTA5LTMwIDExOjU5OjI0IGUzZmY5MTE0M2ViMmE2ZWFhYWI0
ODMxYzg1YTI4MzdhOTVmYmJlYTMgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAyL3g4Nl82NC1yYW5kY29uZmlnLWhz
YjItMDkzMDAyNDgtZTNmZjkxMTQzZWIyYTZlYWFhYjQ4MzFjODVhMjgzN2E5NWZiYmVhMwpD
aGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMw
MDI0OC9lM2ZmOTExNDNlYjJhNmVhYWFiNDgzMWM4NWEyODM3YTk1ZmJiZWEzCndhaXRpbmcg
Zm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDIv
eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC1lM2ZmOTExNDNlYjJhNmVhYWFiNDgz
MWM4NWEyODM3YTk1ZmJiZWEzCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1o
c2IyLTA5MzAwMjQ4L2UzZmY5MTE0M2ViMmE2ZWFhYWI0ODMxYzg1YTI4MzdhOTVmYmJlYTMv
dm1saW51ei0zLjEwLjAtcmM3LTAwMDM0LWdlM2ZmOTExCgoyMDE0LTA5LTMwIDEyOjAxOjMx
IGRldGVjdGluZyBib290IHN0YXRlIC4uCTE5CTIwIFNVQ0NFU1MKCmxpbmVhci1iaXNlY3Q6
IGJhZCBicmFuY2ggbWF5IGJlIGJyYW5jaCAncGVyZi11cmdlbnQtZm9yLWxpbnVzJyBvZiBn
aXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGlwL3RpcAps
aW5lYXItYmlzZWN0OiBoYW5kbGUgb3ZlciB0byBnaXQgYmlzZWN0CmxpbmVhci1iaXNlY3Q6
IGdpdCBiaXNlY3Qgc3RhcnQgNTRmYWY3N2QwNjU5MjZhZGJjYzJhNDllNmRmMzU1OTA5NGNj
OTNiYSBlM2ZmOTExNDNlYjJhNmVhYWFiNDgzMWM4NWEyODM3YTk1ZmJiZWEzIC0tClByZXZp
b3VzIEhFQUQgcG9zaXRpb24gd2FzIGUzZmY5MTEuLi4gTWVyZ2UgYnJhbmNoICdmaXhlcycg
b2YgZ2l0Oi8vZ2l0LmxpbmFyby5vcmcvcGVvcGxlL3Jtay9saW51eC1hcm0KSEVBRCBpcyBu
b3cgYXQgMTcxYzA2Mi4uLiBNZXJnZSB0YWcgJ21tYy12My4xNi0yJyBvZiBnaXQ6Ly9naXQu
bGluYXJvLm9yZy9wZW9wbGUvdWxmLmhhbnNzb24vbW1jCkJpc2VjdGluZzogMSByZXZpc2lv
biBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0ZXApCls4YjRkODAxYjJi
MTIzYjZjMDk3NDJmODYxZmU0NGE4NTI3Yjg0ZDQ3XSBod19icmVha3BvaW50OiBGaXggY3B1
IGNoZWNrIGluIHRhc2tfYnBfcGlubmVkKGNwdSkKbGluZWFyLWJpc2VjdDogZ2l0IGJpc2Vj
dCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9i
b290LWJpc2VjdC9saW51eC00L29iai1iaXNlY3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTQvb2Jq
LWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRj
b25maWctaHNiMi0wOTMwMDI0OC9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDA5MzAw
MDo4YjRkODAxYjJiMTIzYjZjMDk3NDJmODYxZmU0NGE4NTI3Yjg0ZDQ3OmJpc2VjdC1saW51
eC00CgoyMDE0LTA5LTMwIDEyOjA3OjA5IDhiNGQ4MDFiMmIxMjNiNmMwOTc0MmY4NjFmZTQ0
YTg1MjdiODRkNDcgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUvbGtwLWhzeDAyL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAy
NDgtOGI0ZDgwMWIyYjEyM2I2YzA5NzQyZjg2MWZlNDRhODUyN2I4NGQ0NwpDaGVjayBmb3Ig
a2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC84YjRk
ODAxYjJiMTIzYjZjMDk3NDJmODYxZmU0NGE4NTI3Yjg0ZDQ3CndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDItc21va2UveDg2
XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC04YjRkODAxYjJiMTIzYjZjMDk3NDJmODYx
ZmU0NGE4NTI3Yjg0ZDQ3Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2Iy
LTA5MzAwMjQ4LzhiNGQ4MDFiMmIxMjNiNmMwOTc0MmY4NjFmZTQ0YTg1MjdiODRkNDcvdm1s
aW51ei0zLjEwLjAtcmMzLTAwMDA2LWc4YjRkODAxCgoyMDE0LTA5LTMwIDEyOjA5OjIyIGRl
dGVjdGluZyBib290IHN0YXRlIC4gVEVTVCBGQUlMVVJFClsgICAgNC4xODg2NzldIFRlc3Rp
bmcga3Byb2JlIHRyYWNpbmc6IApbICAgIDQuMTg5ODEwXSBDb3VsZCBub3QgaW5zZXJ0IHBy
b2JlIGF0IGtwcm9iZV90cmFjZV9zZWxmdGVzdF90YXJnZXQrMDogLTIyClsgICAgNC4xOTEw
NzZdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDQuMTkxNTQy
XSBXQVJOSU5HOiBhdCBrZXJuZWwvdHJhY2UvdHJhY2Vfa3Byb2JlLmM6MTM5MyBrcHJvYmVf
dHJhY2Vfc2VsZl90ZXN0c19pbml0KzB4NjkvMHg3ZjAoKQpbICAgIDQuMTkyOTk5XSBNb2R1
bGVzIGxpbmtlZCBpbjoKWyAgICA0LjE5MzMxNF0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2Fw
cGVyIE5vdCB0YWludGVkIDMuMTAuMC1yYzMtMDAwMDYtZzhiNGQ4MDEgIzEKWyAgICA0LjE5
Mzk5OF0gIDAwMDAwMDAwMDAwMDAwMDkgZmZmZjg4MDAxMzg4MWU3OCBmZmZmZmZmZjgxNGY0
YWJkIGZmZmY4ODAwMTM4ODFlYjAKWyAgICA0LjE5NDczM10gIGZmZmZmZmZmODEwNzU0ODEg
ZmZmZmZmZmY4MWFhMjU3MCAwMDAwMDAwMDAwMDAwMDA3IDAwMDAwMDAwMDAwMDAwMDAKWyAg
ICA0LjE5NTQ2OV0gIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgw
MDEzODgxZWMwIGZmZmZmZmZmODEwNzU0ZWEKWyAgICA0LjE5NjIwMl0gQ2FsbCBUcmFjZToK
WyAgICA0LjE5NjUxM10gIFs8ZmZmZmZmZmY4MTRmNGFiZD5dIGR1bXBfc3RhY2srMHgyNy8w
eDMwClsgICAgNC4xOTczOTldICBbPGZmZmZmZmZmODEwNzU0ODE+XSB3YXJuX3Nsb3dwYXRo
X2NvbW1vbisweDkxLzB4ZDAKWyAgICA0LjE5Nzk5Nl0gIFs8ZmZmZmZmZmY4MWFhMjU3MD5d
ID8gaW5pdF9rcHJvYmVfdHJhY2UrMHhlOC8weGU4ClsgICAgNC4xOTg3NTJdICBbPGZmZmZm
ZmZmODEwNzU0ZWE+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgyYS8weDQwClsgICAgNC4xOTk2
NjddICBbPGZmZmZmZmZmODFhYTI1ZDk+XSBrcHJvYmVfdHJhY2Vfc2VsZl90ZXN0c19pbml0
KzB4NjkvMHg3ZjAKWyAgICA0LjIwMDMxNl0gIFs8ZmZmZmZmZmY4MWFhMjU3MD5dID8gaW5p
dF9rcHJvYmVfdHJhY2UrMHhlOC8weGU4ClsgICAgNC4yMDA4NTZdICBbPGZmZmZmZmZmODEw
MDAzMWE+XSBkb19vbmVfaW5pdGNhbGwrMHgxNmEvMHgyMjAKWyAgICA0LjIwMTM4N10gIFs8
ZmZmZmZmZmY4MWE4MjRmNT5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MjMxLzB4MzFiClsg
ICAgNC4yMDE5NDhdICBbPGZmZmZmZmZmODE0ZWQ3NTA+XSA/IHJlc3RfaW5pdCsweDE2MC8w
eDE2MApbICAgIDQuMjAyNDU4XSAgWzxmZmZmZmZmZjgxNGVkNzY2Pl0ga2VybmVsX2luaXQr
MHgxNi8weDIzMApbICAgIDQuMjAyOTQzXSAgWzxmZmZmZmZmZjgxNTA4OTdhPl0gcmV0X2Zy
b21fZm9yaysweDdhLzB4YjAKWyAgICA0LjIwMzgxM10gIFs8ZmZmZmZmZmY4MTRlZDc1MD5d
ID8gcmVzdF9pbml0KzB4MTYwLzB4MTYwClsgICAgNC4yMDQ1MzBdIC0tLVsgZW5kIHRyYWNl
IGVjYmVjMWVkZmU0Y2I5NmIgXS0tLQpbICAgIDQuMjA0OTU3XSBlcnJvciBvbiBwcm9iaW5n
IGZ1bmN0aW9uIGVudHJ5Lgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAy
NDgvOGI0ZDgwMWIyYjEyM2I2YzA5NzQyZjg2MWZlNDRhODUyN2I4NGQ0Ny9kbWVzZy15b2N0
by12cC0xMzoyMDE0MDkzMDEyMDk0NTp4ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4
OjMuMTAuMC1yYzMtMDAwMDYtZzhiNGQ4MDE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWhzYjItMDkzMDAyNDgvOGI0ZDgwMWIyYjEyM2I2YzA5NzQyZjg2MWZlNDRhODUyN2I4NGQ0
Ny9kbWVzZy15b2N0by12cC0xNDoyMDE0MDkzMDEyMDk0Nzp4ODZfNjQtcmFuZGNvbmZpZy1o
c2IyLTA5MzAwMjQ4OjMuMTAuMC1yYzMtMDAwMDYtZzhiNGQ4MDE6MQova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvOGI0ZDgwMWIyYjEyM2I2YzA5NzQyZjg2MWZl
NDRhODUyN2I4NGQ0Ny9kbWVzZy15b2N0by12cC0xODoyMDE0MDkzMDEyMDk0NDp4ODZfNjQt
cmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4OjMuMTAuMC1yYzMtMDAwMDYtZzhiNGQ4MDE6MQov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvOGI0ZDgwMWIyYjEyM2I2
YzA5NzQyZjg2MWZlNDRhODUyN2I4NGQ0Ny9kbWVzZy15b2N0by12cC0xOjIwMTQwOTMwMTIw
OTQ3Ong4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDg6My4xMC4wLXJjMy0wMDAwNi1n
OGI0ZDgwMToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC84YjRk
ODAxYjJiMTIzYjZjMDk3NDJmODYxZmU0NGE4NTI3Yjg0ZDQ3L2RtZXNnLXlvY3RvLXZwLTI4
OjIwMTQwOTMwMTIwOTQ2Ong4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDg6My4xMC4w
LXJjMy0wMDAwNi1nOGI0ZDgwMToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMi0w
OTMwMDI0OC84YjRkODAxYjJiMTIzYjZjMDk3NDJmODYxZmU0NGE4NTI3Yjg0ZDQ3L2RtZXNn
LXlvY3RvLXZwLTI6MjAxNDA5MzAxMjA5NDU6eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMw
MDI0ODozLjEwLjAtcmMzLTAwMDA2LWc4YjRkODAxOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1oc2IyLTA5MzAwMjQ4LzhiNGQ4MDFiMmIxMjNiNmMwOTc0MmY4NjFmZTQ0YTg1Mjdi
ODRkNDcvZG1lc2cteW9jdG8tdnAtMzM6MjAxNDA5MzAxMjA5NDc6eDg2XzY0LXJhbmRjb25m
aWctaHNiMi0wOTMwMDI0ODozLjEwLjAtcmMzLTAwMDA2LWc4YjRkODAxOjEKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LzhiNGQ4MDFiMmIxMjNiNmMwOTc0MmY4
NjFmZTQ0YTg1MjdiODRkNDcvZG1lc2cteW9jdG8tdnAtMzQ6MjAxNDA5MzAxMjA5NDQ6eDg2
XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODozLjEwLjAtcmMzLTAwMDA2LWc4YjRkODAx
OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LzhiNGQ4MDFiMmIx
MjNiNmMwOTc0MmY4NjFmZTQ0YTg1MjdiODRkNDcvZG1lc2cteW9jdG8tdnAtNDE6MjAxNDA5
MzAxMjA5NDU6eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODozLjEwLjAtcmMzLTAw
MDA2LWc4YjRkODAxOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4
LzhiNGQ4MDFiMmIxMjNiNmMwOTc0MmY4NjFmZTQ0YTg1MjdiODRkNDcvZG1lc2cteW9jdG8t
dnAtNDI6MjAxNDA5MzAxMjA5NDU6eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODoz
LjEwLjAtcmMzLTAwMDA2LWc4YjRkODAxOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1o
c2IyLTA5MzAwMjQ4LzhiNGQ4MDFiMmIxMjNiNmMwOTc0MmY4NjFmZTQ0YTg1MjdiODRkNDcv
ZG1lc2cteW9jdG8tdnAtNDM6MjAxNDA5MzAxMjA5NDY6eDg2XzY0LXJhbmRjb25maWctaHNi
Mi0wOTMwMDI0ODozLjEwLjAtcmMzLTAwMDA2LWc4YjRkODAxOjEKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LzhiNGQ4MDFiMmIxMjNiNmMwOTc0MmY4NjFmZTQ0
YTg1MjdiODRkNDcvZG1lc2cteW9jdG8tdnAtNDU6MjAxNDA5MzAxMjA5NDc6eDg2XzY0LXJh
bmRjb25maWctaHNiMi0wOTMwMDI0ODozLjEwLjAtcmMzLTAwMDA2LWc4YjRkODAxOjEKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LzhiNGQ4MDFiMmIxMjNiNmMw
OTc0MmY4NjFmZTQ0YTg1MjdiODRkNDcvZG1lc2cteW9jdG8tdnAtNTA6MjAxNDA5MzAxMjA5
NDc6eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODozLjEwLjAtcmMzLTAwMDA2LWc4
YjRkODAxOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LzhiNGQ4
MDFiMmIxMjNiNmMwOTc0MmY4NjFmZTQ0YTg1MjdiODRkNDcvZG1lc2cteW9jdG8tdnAtNTc6
MjAxNDA5MzAxMjA5NDY6eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODozLjEwLjAt
cmMzLTAwMDA2LWc4YjRkODAxOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5
MzAwMjQ4LzhiNGQ4MDFiMmIxMjNiNmMwOTc0MmY4NjFmZTQ0YTg1MjdiODRkNDcvZG1lc2ct
eW9jdG8tdnAtNjI6MjAxNDA5MzAxMjA5NDU6eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMw
MDI0ODozLjEwLjAtcmMzLTAwMDA2LWc4YjRkODAxOjEKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1oc2IyLTA5MzAwMjQ4LzhiNGQ4MDFiMmIxMjNiNmMwOTc0MmY4NjFmZTQ0YTg1Mjdi
ODRkNDcvZG1lc2cteW9jdG8tdnAtMjQ6MjAxNDA5MzAxMjA5NDc6eDg2XzY0LXJhbmRjb25m
aWctaHNiMi0wOTMwMDI0ODozLjEwLjAtcmMzLTAwMDA2LWc4YjRkODAxOjEKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LzhiNGQ4MDFiMmIxMjNiNmMwOTc0MmY4
NjFmZTQ0YTg1MjdiODRkNDcvZG1lc2cteW9jdG8tdnAtNDA6MjAxNDA5MzAxMjA5NDc6eDg2
XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODozLjEwLjAtcmMzLTAwMDA2LWc4YjRkODAx
OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LzhiNGQ4MDFiMmIx
MjNiNmMwOTc0MmY4NjFmZTQ0YTg1MjdiODRkNDcvZG1lc2cteW9jdG8tdnAtNjoyMDE0MDkz
MDEyMDk0Nzp4ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4OjMuMTAuMC1yYzMtMDAw
MDYtZzhiNGQ4MDE6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgv
OGI0ZDgwMWIyYjEyM2I2YzA5NzQyZjg2MWZlNDRhODUyN2I4NGQ0Ny9kbWVzZy15b2N0by12
cC04OjIwMTQwOTMwMTIwOTQ3Ong4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDg6My4x
MC4wLXJjMy0wMDAwNi1nOGI0ZDgwMToxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNi
Mi0wOTMwMDI0OC84YjRkODAxYjJiMTIzYjZjMDk3NDJmODYxZmU0NGE4NTI3Yjg0ZDQ3L2Rt
ZXNnLXlvY3RvLXZwLTc6MjAxNDA5MzAxMjA5NDg6eDg2XzY0LXJhbmRjb25maWctaHNiMi0w
OTMwMDI0ODozLjEwLjAtcmMzLTAwMDA2LWc4YjRkODAxOjEKMDoyMDoyMCBhbGxfZ29vZDpi
YWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wOS0zMCAxMjowOTo1MyBSRVBFQVQgQ09V
TlQ6IDIwICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTQvb2JqLWJpc2VjdC8ucmVwZWF0G1sw
bQoKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91
Z2hseSAwIHN0ZXBzKQpbMDAzMDAyZTA0ZWQzODYxOGZjMzdiOTJiYTEyOGY1Y2E3OWQzOWY0
Zl0ga3Byb2JlczogRml4IGFyY2hfcHJlcGFyZV9rcHJvYmUgdG8gaGFuZGxlIGNvcHkgaW5z
biBmYWlsdXJlcwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtNC9vYmotYmlzZWN0CmxzIC1hIC9rYnVp
bGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4
L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDkzMDAwOjAwMzAwMmUwNGVkMzg2MThm
YzM3YjkyYmExMjhmNWNhNzlkMzlmNGY6YmlzZWN0LWxpbnV4LTQKCjIwMTQtMDktMzAgMTI6
MDk6NTkgMDAzMDAyZTA0ZWQzODYxOGZjMzdiOTJiYTEyOGY1Y2E3OWQzOWY0ZiBjb21waWxp
bmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3At
aHN4MDIveDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC0wMDMwMDJlMDRlZDM4NjE4
ZmMzN2I5MmJhMTI4ZjVjYTc5ZDM5ZjRmCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LzAwMzAwMmUwNGVkMzg2MThmYzM3Yjky
YmExMjhmNWNhNzlkMzlmNGYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRl
c3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMi1zbW9rZS94ODZfNjQtcmFuZGNvbmZpZy1oc2Iy
LTA5MzAwMjQ4LTAwMzAwMmUwNGVkMzg2MThmYzM3YjkyYmExMjhmNWNhNzlkMzlmNGYKa2Vy
bmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvMDAzMDAyZTA0
ZWQzODYxOGZjMzdiOTJiYTEyOGY1Y2E3OWQzOWY0Zi92bWxpbnV6LTMuMTAuMC1yYzMtMDAw
MDUtZzAwMzAwMmUKCjIwMTQtMDktMzAgMTI6MTE6NTkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
LgkyMCBTVUNDRVNTCgo4YjRkODAxYjJiMTIzYjZjMDk3NDJmODYxZmU0NGE4NTI3Yjg0ZDQ3
IGlzIHRoZSBmaXJzdCBiYWQgY29tbWl0CmNvbW1pdCA4YjRkODAxYjJiMTIzYjZjMDk3NDJm
ODYxZmU0NGE4NTI3Yjg0ZDQ3CkF1dGhvcjogT2xlZyBOZXN0ZXJvdiA8b2xlZ0ByZWRoYXQu
Y29tPgpEYXRlOiAgIFRodSBKdW4gMjAgMTc6NTA6MDYgMjAxMyArMDIwMAoKICAgIGh3X2Jy
ZWFrcG9pbnQ6IEZpeCBjcHUgY2hlY2sgaW4gdGFza19icF9waW5uZWQoY3B1KQogICAgCiAg
ICB0cmluaXR5IGZ1enplciB0cmlnZ2VyZWQgV0FSTl9PTkNFKCJDYW4ndCBmaW5kIGFueSBi
cmVha3BvaW50CiAgICBzbG90IikgaW4gYXJjaF9pbnN0YWxsX2h3X2JyZWFrcG9pbnQoKSBi
dXQgdGhlIHByb2JsZW0gaXMgbm90CiAgICBhcmNoLXNwZWNpZmljLgogICAgCiAgICBUaGUg
cHJvYmxlbSBpcywgdGFza19icF9waW5uZWQoY3B1KSBjaGVja3MgImNwdSA9PSBpdGVyLT5j
cHUiCiAgICBidXQgdGhpcyBkb2Vzbid0IGFjY291bnQgdGhlICJhbGwgY3B1cyIgZXZlbnRz
IHdpdGggaXRlci0+Y3B1IDwKICAgIDAuCiAgICAKICAgIFRoaXMgbWVhbnMgdGhhdCwgc2F5
LCByZWdpc3Rlcl91c2VyX2h3X2JyZWFrcG9pbnQodHNrKSBjYW4KICAgIGhhcHBpbHkgY3Jl
YXRlIHRoZSBhcmJpdHJhcnkgbnVtYmVyID4gSEJQX05VTSBvZiBicmVha3BvaW50cwogICAg
d2hpY2ggY2FuIG5vdCBiZSBhY3RpdmF0ZWQuIHRvZ2dsZV9icF90YXNrX3Nsb3QoKSBpcyBl
cXVhbGx5CiAgICB3cm9uZyBieSB0aGUgc2FtZSByZWFzb24gYW5kIG5yX3Rhc2tfYnBfcGlu
bmVkW10gY2FuIGhhdmUKICAgIG5lZ2F0aXZlIGVudHJpZXMuCiAgICAKICAgIFNpbXBsZSB0
ZXN0OgogICAgCiAgICAJIyBwZXJsIC1lICdzbGVlcCAxIHdoaWxlIDEnICYKICAgIAkjIHBl
cmYgcmVjb3JkIC1lIG1lbToweDEwLG1lbToweDEwLG1lbToweDEwLG1lbToweDEwLG1lbTow
eDEwIC1wIGBwaWRvZiBwZXJsYAogICAgCiAgICBCZWZvcmUgdGhpcyBwYXRjaCB0aGlzIHRy
aWdnZXJzIHRoZSBzYW1lIHByb2JsZW0vV0FSTl9PTigpLAogICAgYWZ0ZXIgdGhlIHBhdGNo
IGl0IGNvcnJlY3RseSBmYWlscyB3aXRoIC1FTk9TUEMuCiAgICAKICAgIFJlcG9ydGVkLWJ5
OiBWaW5jZSBXZWF2ZXIgPHZpbmNlbnQud2VhdmVyQG1haW5lLmVkdT4KICAgIFNpZ25lZC1v
ZmYtYnk6IE9sZWcgTmVzdGVyb3YgPG9sZWdAcmVkaGF0LmNvbT4KICAgIEFja2VkLWJ5OiBG
cmVkZXJpYyBXZWlzYmVja2VyIDxmd2Vpc2JlY0BnbWFpbC5jb20+CiAgICBDYzogPHN0YWJs
ZUB2Z2VyLmtlcm5lbC5vcmc+CiAgICBMaW5rOiBodHRwOi8vbGttbC5rZXJuZWwub3JnL3Iv
MjAxMzA2MjAxNTUwMDYuR0E2MzI0QHJlZGhhdC5jb20KICAgIFNpZ25lZC1vZmYtYnk6IElu
Z28gTW9sbmFyIDxtaW5nb0BrZXJuZWwub3JnPgoKOjA0MDAwMCAwNDAwMDAgNmU2YTc5YmU5
NjY4Y2M5ZDA4MDc4Y2E5ZjBjNjA0OTdjZDU4NTY4MSAxMjkyZjEwZDdlOTM4OWMxZDA5Yjhi
ZDZhYWNkYzg3ZTIyOTZiMDA4IE0Ja2VybmVsCmJpc2VjdCBydW4gc3VjY2VzcwpIRUFEIGlz
IG5vdyBhdCAwMDMwMDJlLi4uIGtwcm9iZXM6IEZpeCBhcmNoX3ByZXBhcmVfa3Byb2JlIHRv
IGhhbmRsZSBjb3B5IGluc24gZmFpbHVyZXMKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVl
dWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvbGludXgtZGV2ZWw6ZGV2
ZWwtaG91cmx5LTIwMTQwOTMwMDA6MDAzMDAyZTA0ZWQzODYxOGZjMzdiOTJiYTEyOGY1Y2E3
OWQzOWY0ZjpiaXNlY3QtbGludXgtNAoKMjAxNC0wOS0zMCAxMjoxMjo1OSAwMDMwMDJlMDRl
ZDM4NjE4ZmMzN2I5MmJhMTI4ZjVjYTc5ZDM5ZjRmIHJldXNlIC9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctaHNiMi0wOTMwMDI0OC8wMDMwMDJlMDRlZDM4NjE4ZmMzN2I5MmJhMTI4ZjVj
YTc5ZDM5ZjRmL3ZtbGludXotMy4xMC4wLXJjMy0wMDAwNS1nMDAzMDAyZQoKMjAxNC0wOS0z
MCAxMjoxMjo1OSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgkzNwk2MCBTVUNDRVNTCgpQcmV2
aW91cyBIRUFEIHBvc2l0aW9uIHdhcyAwMDMwMDJlLi4uIGtwcm9iZXM6IEZpeCBhcmNoX3By
ZXBhcmVfa3Byb2JlIHRvIGhhbmRsZSBjb3B5IGluc24gZmFpbHVyZXMKSEVBRCBpcyBub3cg
YXQgMTg2NjI5My4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1ob3VybHktMjAxNDA5
MzAwMCcKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29u
ZmlnLWhzYjItMDkzMDAyNDgvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwOTMwMDA6
MTg2NjI5MzI5MDAzNmMwZTVmNDg0M2VjNzAyMzkyYWQ4MDlhMzhmZjpiaXNlY3QtbGludXgt
NAogVEVTVCBGQUlMVVJFClsgICAgOS41NTM5MThdIFRlc3Rpbmcga3Byb2JlIHRyYWNpbmc6
IApbICAgIDkuNTU3Mjk4XSBDb3VsZCBub3QgaW5zZXJ0IHByb2JlIGF0IGtwcm9iZV90cmFj
ZV9zZWxmdGVzdF90YXJnZXQrMDogLTIyClsgICAgOS41NjAzNDddIC0tLS0tLS0tLS0tLVsg
Y3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDkuNTYyMTYzXSBXQVJOSU5HOiBDUFU6IDAg
UElEOiAxIGF0IGtlcm5lbC90cmFjZS90cmFjZV9rcHJvYmUuYzoxNDAxIGtwcm9iZV90cmFj
ZV9zZWxmX3Rlc3RzX2luaXQrMHg4ZC8weDg2MigpClsgICAgOS41NjY2NTldIE1vZHVsZXMg
bGlua2VkIGluOgpbICAgIDkuNTY4MDA4XSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIg
Tm90IHRhaW50ZWQgMy4xNy4wLXJjNy0wMTY1OC1nMTg2NjI5MyAjMjkyClsgICAgOS41NzA5
ODRdICAwMDAwMDAwMDAwMDAwMDA5IGZmZmY4ODAwMTI0OTdlMjAgZmZmZmZmZmY4MTVkZjA0
ZiBmZmZmODgwMDEyNDk3ZTU4ClsgICAgOS41NzQwOTddICBmZmZmZmZmZjgxMGE2MzhlIGZm
ZmZmZmZmODE5YWQwMDAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDEyNTRhZWEwClsgICAg
OS41NzcyMjddICAwMDAwMDAwMDAwMDAwMDAwIGZmZmZmZmZmODFjNTMxZmUgZmZmZjg4MDAx
MjQ5N2U2OCBmZmZmZmZmZjgxMGE2M2VhClsgICAgOS41ODAyNjJdIENhbGwgVHJhY2U6Clsg
ICAgOS41ODEyODJdICBbPGZmZmZmZmZmODE1ZGYwNGY+XSBkdW1wX3N0YWNrKzB4MmUvMHgz
ZQpbICAgIDkuNTgzMjc4XSAgWzxmZmZmZmZmZjgxMGE2MzhlPl0gd2Fybl9zbG93cGF0aF9j
b21tb24rMHhhZS8weGUwClsgICAgOS41ODU2MjddICBbPGZmZmZmZmZmODFjNTMxZmU+XSA/
IGluaXRfa3Byb2JlX3RyYWNlKzB4ZTgvMHhlOApbICAgIDkuNTg3OTU3XSAgWzxmZmZmZmZm
ZjgxMGE2M2VhPl0gd2Fybl9zbG93cGF0aF9udWxsKzB4MmEvMHg0MApbICAgIDkuNTkwMjc1
XSAgWzxmZmZmZmZmZjgxYzUzMjhiPl0ga3Byb2JlX3RyYWNlX3NlbGZfdGVzdHNfaW5pdCsw
eDhkLzB4ODYyClsgICAgOS41OTI5MTVdICBbPGZmZmZmZmZmODEwMDAzNTM+XSBkb19vbmVf
aW5pdGNhbGwrMHhmMy8weDMwMApbICAgIDkuNTk1MTcyXSAgWzxmZmZmZmZmZjgxYzJmOGE0
Pl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgzMTQvMHg0MGEKWyAgICA5LjU5NzQ5NF0gIFs8
ZmZmZmZmZmY4MTVkODczMD5dID8gcmVzdF9pbml0KzB4MTMwLzB4MTMwClsgICAgOS41OTk0
NDRdICBbPGZmZmZmZmZmODE1ZDg3NDY+XSBrZXJuZWxfaW5pdCsweDE2LzB4MWEwClsgICAg
OS42MDE1NDVdICBbPGZmZmZmZmZmODE1ZWE3N2E+XSByZXRfZnJvbV9mb3JrKzB4N2EvMHhi
MApbICAgIDkuNjAzNjUzXSAgWzxmZmZmZmZmZjgxNWQ4NzMwPl0gPyByZXN0X2luaXQrMHgx
MzAvMHgxMzAKWyAgICA5LjYwNTc1OF0gLS0tWyBlbmQgdHJhY2UgZDRkNzBmN2U1YjAyNWM5
YyBdLS0tClsgICAgOS42MDc1OThdIGVycm9yIG9uIHByb2JpbmcgZnVuY3Rpb24gZW50cnku
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC8xODY2MjkzMjkwMDM2
YzBlNWY0ODQzZWM3MDIzOTJhZDgwOWEzOGZmL2RtZXNnLXlvY3RvLXZwLTU6MjAxNDA5MzAw
MzA5MjI6eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODozLjE3LjAtcmM3LTAxNjU4
LWcxODY2MjkzOjI5Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgv
MTg2NjI5MzI5MDAzNmMwZTVmNDg0M2VjNzAyMzkyYWQ4MDlhMzhmZi9kbWVzZy1xdWFudGFs
LWxrcC1uZXgwNS0yOjIwMTQwOTMwMDMwOTMyOng4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkz
MDAyNDg6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvMTg2NjI5
MzI5MDAzNmMwZTVmNDg0M2VjNzAyMzkyYWQ4MDlhMzhmZi9kbWVzZy1xdWFudGFsLWxrcC1u
ZXgwNS02ODoyMDE0MDkzMDAzMDkzMzp4ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4
OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LzE4NjYyOTMyOTAw
MzZjMGU1ZjQ4NDNlYzcwMjM5MmFkODA5YTM4ZmYvZG1lc2cteW9jdG8tdnAtNTM6MjAxNDA5
MzAwMjU4MDE6eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODozLjE3LjAtcmM3LTAx
NjU4LWcxODY2MjkzOjI5Mgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAy
NDgvMTg2NjI5MzI5MDAzNmMwZTVmNDg0M2VjNzAyMzkyYWQ4MDlhMzhmZi9kbWVzZy1xdWFu
dGFsLWxrcC1uZXgwNS00OToyMDE0MDkzMDAzMDkzMjp4ODZfNjQtcmFuZGNvbmZpZy1oc2Iy
LTA5MzAwMjQ4OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LzE4
NjYyOTMyOTAwMzZjMGU1ZjQ4NDNlYzcwMjM5MmFkODA5YTM4ZmYvZG1lc2cteW9jdG8tbGtw
LW5leDA1LTQ0OjIwMTQwOTMwMDMwOTI3Ong4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAy
NDg6Ogova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvMTg2NjI5MzI5
MDAzNmMwZTVmNDg0M2VjNzAyMzkyYWQ4MDlhMzhmZi9kbWVzZy15b2N0by1sa3AtbmV4MDUt
NDoyMDE0MDkzMDAzMDkyNzp4ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4OjoKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LzE4NjYyOTMyOTAwMzZjMGU1
ZjQ4NDNlYzcwMjM5MmFkODA5YTM4ZmYvZG1lc2cteW9jdG8tbGtwLW5leDA1LTM6MjAxNDA5
MzAwMzA5Mjg6eDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODo6Ci9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC8xODY2MjkzMjkwMDM2YzBlNWY0ODQzZWM3
MDIzOTJhZDgwOWEzOGZmL2RtZXNnLXF1YW50YWwtbGtwLW5leDA1LTIyOjIwMTQwOTMwMDMw
OTMzOng4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDg6Ogova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWhzYjItMDkzMDAyNDgvMTg2NjI5MzI5MDAzNmMwZTVmNDg0M2VjNzAyMzky
YWQ4MDlhMzhmZi9kbWVzZy15b2N0by12cC01MToyMDE0MDkzMDAzMDkyMjp4ODZfNjQtcmFu
ZGNvbmZpZy1oc2IyLTA5MzAwMjQ4OjMuMTcuMC1yYzctMDE2NTgtZzE4NjYyOTM6MjkyCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC8xODY2MjkzMjkwMDM2YzBl
NWY0ODQzZWM3MDIzOTJhZDgwOWEzOGZmL2RtZXNnLXlvY3RvLXZwLTU2OjIwMTQwOTMwMDMw
OTIyOng4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDg6My4xNy4wLXJjNy0wMTY1OC1n
MTg2NjI5MzoyOTIKMDoxMToxMSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKSEVBRCBp
cyBub3cgYXQgMTg2NjI5MyAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1ob3VybHktMjAx
NDA5MzAwMCcKCj09PT09PT09PSBsaW51cy9tYXN0ZXIgPT09PT09PT09Ck5vdGU6IGNoZWNr
aW5nIG91dCAnbGludXMvbWFzdGVyJy4KCllvdSBhcmUgaW4gJ2RldGFjaGVkIEhFQUQnIHN0
YXRlLiBZb3UgY2FuIGxvb2sgYXJvdW5kLCBtYWtlIGV4cGVyaW1lbnRhbApjaGFuZ2VzIGFu
ZCBjb21taXQgdGhlbSwgYW5kIHlvdSBjYW4gZGlzY2FyZCBhbnkgY29tbWl0cyB5b3UgbWFr
ZSBpbiB0aGlzCnN0YXRlIHdpdGhvdXQgaW1wYWN0aW5nIGFueSBicmFuY2hlcyBieSBwZXJm
b3JtaW5nIGFub3RoZXIgY2hlY2tvdXQuCgpJZiB5b3Ugd2FudCB0byBjcmVhdGUgYSBuZXcg
YnJhbmNoIHRvIHJldGFpbiBjb21taXRzIHlvdSBjcmVhdGUsIHlvdSBtYXkKZG8gc28gKG5v
dyBvciBsYXRlcikgYnkgdXNpbmcgLWIgd2l0aCB0aGUgY2hlY2tvdXQgY29tbWFuZCBhZ2Fp
bi4gRXhhbXBsZToKCiAgZ2l0IGNoZWNrb3V0IC1iIG5ld19icmFuY2hfbmFtZQoKSEVBRCBp
cyBub3cgYXQgZmU4MmRjZS4uLiBMaW51eCAzLjE3LXJjNwpscyAtYSAva2J1aWxkLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC9saW51czpt
YXN0ZXI6ZmU4MmRjZWM2NDQyNDQ2NzZkNTVhMTM4NGM5NThkNWY2Nzk3OWFkYjpiaXNlY3Qt
bGludXgtNAogVEVTVCBGQUlMVVJFClsgICAgNi42NzU0NzJdIFRlc3Rpbmcga3Byb2JlIHRy
YWNpbmc6IApbICAgIDYuNjc2NzkwXSBDb3VsZCBub3QgaW5zZXJ0IHByb2JlIGF0IGtwcm9i
ZV90cmFjZV9zZWxmdGVzdF90YXJnZXQrMDogLTIyClsgICAgNi42Nzc3NzRdIC0tLS0tLS0t
LS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDYuNjc4MzU2XSBXQVJOSU5HOiBD
UFU6IDAgUElEOiAxIGF0IGtlcm5lbC90cmFjZS90cmFjZV9rcHJvYmUuYzoxNDAxIGtwcm9i
ZV90cmFjZV9zZWxmX3Rlc3RzX2luaXQrMHg4ZC8weDg2MigpClsgICAgNi42Nzk3NzBdIE1v
ZHVsZXMgbGlua2VkIGluOgpbICAgIDYuNjgwMTg0XSBDUFU6IDAgUElEOiAxIENvbW06IHN3
YXBwZXIgTm90IHRhaW50ZWQgMy4xNy4wLXJjNyAjMQpbICAgIDYuNjgwOTI3XSAgMDAwMDAw
MDAwMDAwMDAwOSBmZmZmODgwMDEyNDk3ZTIwIGZmZmZmZmZmODE1ZGU2NTggZmZmZjg4MDAx
MjQ5N2U1OApbICAgIDYuNjgxODkxXSAgZmZmZmZmZmY4MTBhNjE4ZSBmZmZmZmZmZjgxOWE5
MDAwIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAwYzZiZDVjMApbICAgIDYuNjgyODU0XSAg
MDAwMDAwMDAwMDAwMDAwMCBmZmZmZmZmZjgxYzRmMjEwIGZmZmY4ODAwMTI0OTdlNjggZmZm
ZmZmZmY4MTBhNjFlYQpbICAgIDYuNjgzODMzXSBDYWxsIFRyYWNlOgpbICAgIDYuNjg0MTUx
XSAgWzxmZmZmZmZmZjgxNWRlNjU4Pl0gZHVtcF9zdGFjaysweDJlLzB4M2UKWyAgICA2LjY4
NDc4Nl0gIFs8ZmZmZmZmZmY4MTBhNjE4ZT5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4YWUv
MHhlMApbICAgIDYuNjg1NTI1XSAgWzxmZmZmZmZmZjgxYzRmMjEwPl0gPyBpbml0X2twcm9i
ZV90cmFjZSsweGU4LzB4ZTgKWyAgICA2LjY4NjI1M10gIFs8ZmZmZmZmZmY4MTBhNjFlYT5d
IHdhcm5fc2xvd3BhdGhfbnVsbCsweDJhLzB4NDAKWyAgICA2LjY4Njk3N10gIFs8ZmZmZmZm
ZmY4MWM0ZjI5ZD5dIGtwcm9iZV90cmFjZV9zZWxmX3Rlc3RzX2luaXQrMHg4ZC8weDg2Mgpb
ICAgIDYuNjg3ODAyXSAgWzxmZmZmZmZmZjgxMDAwMzUzPl0gZG9fb25lX2luaXRjYWxsKzB4
ZjMvMHgzMDAKWyAgICA2LjY4ODQ5Nl0gIFs8ZmZmZmZmZmY4MWMyYjhhND5dIGtlcm5lbF9p
bml0X2ZyZWVhYmxlKzB4MzE0LzB4NDBhClsgICAgNi42ODkyNTBdICBbPGZmZmZmZmZmODE1
ZDdlMDA+XSA/IHJlc3RfaW5pdCsweDEzMC8weDEzMApbICAgIDYuNjg5OTA5XSAgWzxmZmZm
ZmZmZjgxNWQ3ZTE2Pl0ga2VybmVsX2luaXQrMHgxNi8weDFhMApbICAgIDYuNjkwNTc5XSAg
WzxmZmZmZmZmZjgxNWU5YWZhPl0gcmV0X2Zyb21fZm9yaysweDdhLzB4YjAKWyAgICA2LjY5
MTIzOF0gIFs8ZmZmZmZmZmY4MTVkN2UwMD5dID8gcmVzdF9pbml0KzB4MTMwLzB4MTMwClsg
ICAgNi42OTE4ODldIC0tLVsgZW5kIHRyYWNlIGEyNWJmZTIxYjEwNDdmNGUgXS0tLQpbICAg
IDYuNjkyNDU4XSBlcnJvciBvbiBwcm9iaW5nIGZ1bmN0aW9uIGVudHJ5Lgova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvZmU4MmRjZWM2NDQyNDQ2NzZkNTVhMTM4
NGM5NThkNWY2Nzk3OWFkYi9kbWVzZy1xdWFudGFsLXZwLTEwOjIwMTQwOTMwMDMxMzQ4Ong4
Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDg6My4xNy4wLXJjNzoxCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC9mZTgyZGNlYzY0NDI0NDY3NmQ1NWExMzg0
Yzk1OGQ1ZjY3OTc5YWRiL2RtZXNnLXF1YW50YWwtdnAtNToyMDE0MDkzMDAzMTM1Mzp4ODZf
NjQtcmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4OjMuMTcuMC1yYzc6MQova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgvZmU4MmRjZWM2NDQyNDQ2NzZkNTVhMTM4NGM5
NThkNWY2Nzk3OWFkYi9kbWVzZy1xdWFudGFsLXZwLTI4OjIwMTQwOTMwMDMxMzUzOng4Nl82
NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDg6My4xNy4wLXJjNzoxCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctaHNiMi0wOTMwMDI0OC9mZTgyZGNlYzY0NDI0NDY3NmQ1NWExMzg0Yzk1
OGQ1ZjY3OTc5YWRiL2RtZXNnLXF1YW50YWwtdnAtMjE6MjAxNDA5MzAwMzEzNTI6eDg2XzY0
LXJhbmRjb25maWctaHNiMi0wOTMwMDI0ODozLjE3LjAtcmM3OjEKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4L2ZlODJkY2VjNjQ0MjQ0Njc2ZDU1YTEzODRjOTU4
ZDVmNjc5NzlhZGIvZG1lc2ctcXVhbnRhbC12cC0xMjoyMDE0MDkzMDAzMTM0Njp4ODZfNjQt
cmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4OjMuMTcuMC1yYzc6MQova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWhzYjItMDkzMDAyNDgvZmU4MmRjZWM2NDQyNDQ2NzZkNTVhMTM4NGM5NThk
NWY2Nzk3OWFkYi9kbWVzZy1xdWFudGFsLXZwLTY6MjAxNDA5MzAwMzEzNTE6eDg2XzY0LXJh
bmRjb25maWctaHNiMi0wOTMwMDI0ODozLjE3LjAtcmM3OjEKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1oc2IyLTA5MzAwMjQ4L2ZlODJkY2VjNjQ0MjQ0Njc2ZDU1YTEzODRjOTU4ZDVm
Njc5NzlhZGIvZG1lc2ctcXVhbnRhbC12cC0xOjIwMTQwOTMwMDMxMzUxOng4Nl82NC1yYW5k
Y29uZmlnLWhzYjItMDkzMDAyNDg6My4xNy4wLXJjNzoxCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaHNiMi0wOTMwMDI0OC9mZTgyZGNlYzY0NDI0NDY3NmQ1NWExMzg0Yzk1OGQ1ZjY3
OTc5YWRiL2RtZXNnLXF1YW50YWwtdnAtNzoyMDE0MDkzMDAzMTM1Mzp4ODZfNjQtcmFuZGNv
bmZpZy1oc2IyLTA5MzAwMjQ4OjMuMTcuMC1yYzc6MQova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWhzYjItMDkzMDAyNDgvZmU4MmRjZWM2NDQyNDQ2NzZkNTVhMTM4NGM5NThkNWY2Nzk3
OWFkYi9kbWVzZy1xdWFudGFsLXZwLTMyOjIwMTQwOTMwMDMxMzU1Ong4Nl82NC1yYW5kY29u
ZmlnLWhzYjItMDkzMDAyNDg6My4xNy4wLXJjNzoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaHNiMi0wOTMwMDI0OC9mZTgyZGNlYzY0NDI0NDY3NmQ1NWExMzg0Yzk1OGQ1ZjY3OTc5
YWRiL2RtZXNnLXF1YW50YWwtdnAtMTQ6MjAxNDA5MzAwMzEzNTU6eDg2XzY0LXJhbmRjb25m
aWctaHNiMi0wOTMwMDI0ODozLjE3LjAtcmM3OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1oc2IyLTA5MzAwMjQ4L2ZlODJkY2VjNjQ0MjQ0Njc2ZDU1YTEzODRjOTU4ZDVmNjc5Nzlh
ZGIvZG1lc2ctcXVhbnRhbC12cC0xOToyMDE0MDkzMDAzMTM1MTp4ODZfNjQtcmFuZGNvbmZp
Zy1oc2IyLTA5MzAwMjQ4OjMuMTcuMC1yYzc6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWhzYjItMDkzMDAyNDgvZmU4MmRjZWM2NDQyNDQ2NzZkNTVhMTM4NGM5NThkNWY2Nzk3OWFk
Yi9kbWVzZy1xdWFudGFsLXZwLTI1OjIwMTQwOTMwMDMxMzUyOng4Nl82NC1yYW5kY29uZmln
LWhzYjItMDkzMDAyNDg6My4xNy4wLXJjNzoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
aHNiMi0wOTMwMDI0OC9mZTgyZGNlYzY0NDI0NDY3NmQ1NWExMzg0Yzk1OGQ1ZjY3OTc5YWRi
L2RtZXNnLXF1YW50YWwtdnAtOToyMDE0MDkzMDAzMTM0NTp4ODZfNjQtcmFuZGNvbmZpZy1o
c2IyLTA5MzAwMjQ4OjMuMTcuMC1yYzc6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhz
YjItMDkzMDAyNDgvZmU4MmRjZWM2NDQyNDQ2NzZkNTVhMTM4NGM5NThkNWY2Nzk3OWFkYi9k
bWVzZy1xdWFudGFsLXZwLTI2OjIwMTQwOTMwMDMxMzUxOng4Nl82NC1yYW5kY29uZmlnLWhz
YjItMDkzMDAyNDg6My4xNy4wLXJjNzoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNi
Mi0wOTMwMDI0OC9mZTgyZGNlYzY0NDI0NDY3NmQ1NWExMzg0Yzk1OGQ1ZjY3OTc5YWRiL2Rt
ZXNnLXF1YW50YWwtdnAtMzA6MjAxNDA5MzAwMzEzNTI6eDg2XzY0LXJhbmRjb25maWctaHNi
Mi0wOTMwMDI0ODozLjE3LjAtcmM3OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2Iy
LTA5MzAwMjQ4L2ZlODJkY2VjNjQ0MjQ0Njc2ZDU1YTEzODRjOTU4ZDVmNjc5NzlhZGIvZG1l
c2ctcXVhbnRhbC12cC0xNToyMDE0MDkzMDAzMTM1NDp4ODZfNjQtcmFuZGNvbmZpZy1oc2Iy
LTA5MzAwMjQ4OjMuMTcuMC1yYzc6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjIt
MDkzMDAyNDgvZmU4MmRjZWM2NDQyNDQ2NzZkNTVhMTM4NGM5NThkNWY2Nzk3OWFkYi9kbWVz
Zy1xdWFudGFsLXZwLTIwOjIwMTQwOTMwMDMxMzUwOng4Nl82NC1yYW5kY29uZmlnLWhzYjIt
MDkzMDAyNDg6My4xNy4wLXJjNzoxCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHNiMi0w
OTMwMDI0OC9mZTgyZGNlYzY0NDI0NDY3NmQ1NWExMzg0Yzk1OGQ1ZjY3OTc5YWRiL2RtZXNn
LXF1YW50YWwtdnAtMjI6MjAxNDA5MzAwMzEzNTQ6eDg2XzY0LXJhbmRjb25maWctaHNiMi0w
OTMwMDI0ODozLjE3LjAtcmM3OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5
MzAwMjQ4L2ZlODJkY2VjNjQ0MjQ0Njc2ZDU1YTEzODRjOTU4ZDVmNjc5NzlhZGIvZG1lc2ct
cXVhbnRhbC12cC0xNzoyMDE0MDkzMDAzMTM1Mzp4ODZfNjQtcmFuZGNvbmZpZy1oc2IyLTA5
MzAwMjQ4OjMuMTcuMC1yYzc6MQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkz
MDAyNDgvZmU4MmRjZWM2NDQyNDQ2NzZkNTVhMTM4NGM5NThkNWY2Nzk3OWFkYi9kbWVzZy1x
dWFudGFsLXZwLTI3OjIwMTQwOTMwMDMxMzU1Ong4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkz
MDAyNDg6My4xNy4wLXJjNzoxCjA6MjA6MjAgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMK
Cgo9PT09PT09PT0gbmV4dC9tYXN0ZXIgPT09PT09PT09ClByZXZpb3VzIEhFQUQgcG9zaXRp
b24gd2FzIGZlODJkY2UuLi4gTGludXggMy4xNy1yYzcKSEVBRCBpcyBub3cgYXQgNGQ4NDI2
Zi4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAxNDA5MjYKbHMgLWEg
L2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkz
MDAyNDgvbmV4dDptYXN0ZXI6NGQ4NDI2ZjlhYzYwMWRiMmE2NGZhN2JlNjQwNTFkMDJiOWM5
ZmUwMTpiaXNlY3QtbGludXgtNAoKMjAxNC0wOS0zMCAxMjoxNzozNiA0ZDg0MjZmOWFjNjAx
ZGIyYTY0ZmE3YmU2NDA1MWQwMmI5YzlmZTAxIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFz
ayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMi94ODZfNjQtcmFuZGNv
bmZpZy1oc2IyLTA5MzAwMjQ4LTRkODQyNmY5YWM2MDFkYjJhNjRmYTdiZTY0MDUxZDAyYjlj
OWZlMDEKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhz
YjItMDkzMDAyNDgvNGQ4NDI2ZjlhYzYwMWRiMmE2NGZhN2JlNjQwNTFkMDJiOWM5ZmUwMQp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtw
LWhzeDAyL3g4Nl82NC1yYW5kY29uZmlnLWhzYjItMDkzMDAyNDgtNGQ4NDI2ZjlhYzYwMWRi
MmE2NGZhN2JlNjQwNTFkMDJiOWM5ZmUwMQobWzE7MzVtMjAxNC0wOS0zMCAxMjoxOTozNyBO
byBidWlsZCBzZXJ2ZWQgZmlsZSAva2J1aWxkLXRlc3RzL2J1aWxkLXNlcnZlZC94ODZfNjQt
cmFuZGNvbmZpZy1oc2IyLTA5MzAwMjQ4LTRkODQyNmY5YWM2MDFkYjJhNjRmYTdiZTY0MDUx
ZDAyYjljOWZlMDEbWzBtClJldHJ5IGJ1aWxkIC4uChtbMTszNW0yMDE0LTA5LTMwIDEyOjIw
OjM3IEtlcm5lbCBidWlsZCBmYWlsIG9yIHRpbWVvdXQbWzBtCjIwMTQtMDktMzAgMTI6MjA6
MzcgNGQ4NDI2ZjlhYzYwMWRiMmE2NGZhN2JlNjQwNTFkMDJiOWM5ZmUwMSBTS0lQIEJST0tF
TiBCVUlMRApDaGVjayAva2J1aWxkLXRlc3RzL2J1aWxkLXNlcnZlZC94ODZfNjQtcmFuZGNv
bmZpZy1oc2IyLTA5MzAwMjQ4LTRkODQyNmY5YWM2MDFkYjJhNjRmYTdiZTY0MDUxZDAyYjlj
OWZlMDEK

--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.10.0-rc3-00006-g8b4d801"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.10.0-rc3 Kernel Configuration
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
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
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
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
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
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_STALL_COMMON is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
# CONFIG_CGROUP_SCHED is not set
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_UIDGID_CONVERTED=y
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
# CONFIG_SCHED_AUTOGROUP is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HOTPLUG=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=m
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
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
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
# CONFIG_MODULE_UNLOAD is not set
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
# CONFIG_BLOCK is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
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
# CONFIG_GART_IOMMU is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_I8K=m
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
CONFIG_MICROCODE_INTEL_EARLY=y
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
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
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_ACPI=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_I2C=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

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
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=m
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
# CONFIG_COREDUMP is not set
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_KEYS_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
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
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NETPRIO_CGROUP is not set
# CONFIG_BPF_JIT is not set

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
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
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=m
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=m
CONFIG_MTD_TESTS=m
# CONFIG_MTD_REDBOOT_PARTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_OOPS=m

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
CONFIG_MTD_CFI_BE_BYTE_SWAP=y
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
CONFIG_MTD_CFI_GEOMETRY=y
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
CONFIG_MTD_MAP_BANK_WIDTH_16=y
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
# CONFIG_MTD_CFI_I1 is not set
CONFIG_MTD_CFI_I2=y
CONFIG_MTD_CFI_I4=y
# CONFIG_MTD_CFI_I8 is not set
# CONFIG_MTD_OTP is not set
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_PHYSMAP is not set
# CONFIG_MTD_TS5500 is not set
CONFIG_MTD_AMD76XROM=m
CONFIG_MTD_ICHXROM=m
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
CONFIG_MTD_NETtel=m
CONFIG_MTD_L440GX=m
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=m
CONFIG_MTD_DATAFLASH_WRITE_VERIFY=y
CONFIG_MTD_DATAFLASH_OTP=y
CONFIG_MTD_M25P80=m
CONFIG_M25PXX_USE_FAST_READ=y
# CONFIG_MTD_SST25L is not set
# CONFIG_MTD_SLRAM is not set
CONFIG_MTD_PHRAM=m
# CONFIG_MTD_MTDRAM is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=m
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=m
# CONFIG_MTD_NAND_ECC_BCH is not set
# CONFIG_MTD_SM_COMMON is not set
# CONFIG_MTD_NAND_DENALI is not set
CONFIG_MTD_NAND_IDS=m
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=m
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
# CONFIG_MTD_NAND_DOCG4 is not set
# CONFIG_MTD_NAND_CAFE is not set
# CONFIG_MTD_NAND_NANDSIM is not set
CONFIG_MTD_NAND_PLATFORM=m
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
# CONFIG_MTD_UBI is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
CONFIG_PARPORT_PC_PCMCIA=m
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_DUMMY_IRQ=m
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=m
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29020=m
CONFIG_SENSORS_BH1770=m
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
CONFIG_DS1682=m
CONFIG_VMWARE_BALLOON=y
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=m
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=m
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5520=m
CONFIG_KEYBOARD_ADP5588=m
CONFIG_KEYBOARD_ADP5589=m
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
CONFIG_KEYBOARD_QT2160=y
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
CONFIG_KEYBOARD_MAX7359=m
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
CONFIG_KEYBOARD_NEWTON=m
CONFIG_KEYBOARD_OPENCORES=m
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_TC3589X=y
CONFIG_KEYBOARD_XTKBD=m
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=m
# CONFIG_JOYSTICK_ADI is not set
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=m
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=m
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_232=y
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
# CONFIG_JOYSTICK_STINGER is not set
CONFIG_JOYSTICK_TWIDJOY=m
# CONFIG_JOYSTICK_ZHENHUA is not set
CONFIG_JOYSTICK_DB9=m
# CONFIG_JOYSTICK_GAMECON is not set
CONFIG_JOYSTICK_TURBOGRAFX=m
# CONFIG_JOYSTICK_AS5011 is not set
CONFIG_JOYSTICK_JOYDUMP=m
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM860X_ONKEY=m
CONFIG_INPUT_88PM80X_ONKEY=m
CONFIG_INPUT_AD714X=y
CONFIG_INPUT_AD714X_I2C=y
CONFIG_INPUT_AD714X_SPI=y
CONFIG_INPUT_BMA150=m
CONFIG_INPUT_MAX8925_ONKEY=m
CONFIG_INPUT_MC13783_PWRBUTTON=m
CONFIG_INPUT_MMA8450=m
CONFIG_INPUT_MPU3050=m
CONFIG_INPUT_APANEL=m
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=m
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_RETU_PWRBUTTON is not set
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF50633_PMU=m
CONFIG_INPUT_PCF8574=y
CONFIG_INPUT_DA9052_ONKEY=m
CONFIG_INPUT_DA9055_ONKEY=m
CONFIG_INPUT_WM831X_ON=y
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=y
# CONFIG_INPUT_ADXL34X_SPI is not set
CONFIG_INPUT_CMA3000=m
CONFIG_INPUT_CMA3000_I2C=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PARKBD=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=m
CONFIG_SERIO_PS2MULT=m
CONFIG_SERIO_ARC_PS2=m
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
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
CONFIG_N_HDLC=y
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set
# CONFIG_STALDRV is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
# CONFIG_SERIAL_8250_DMA is not set
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_MAX310X=y
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=m
CONFIG_SERIAL_TIMBERDALE=m
CONFIG_SERIAL_ALTERA_JTAGUART=m
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
CONFIG_PPDEV=m
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
# CONFIG_IPMI_WATCHDOG is not set
# CONFIG_IPMI_POWEROFF is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=m
CONFIG_R3964=y
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
# CONFIG_MWAVE is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=m
CONFIG_TCG_TIS_I2C_INFINEON=m
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=m
# CONFIG_I2C_MUX is not set
# CONFIG_I2C_HELPER_AUTO is not set
# CONFIG_I2C_SMBUS is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=y
# CONFIG_I2C_ALGOPCA is not set

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
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_OCORES=m
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=m
CONFIG_SPI_LM70_LLP=m
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=m
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_XCOMM=m
CONFIG_SPI_XILINX=m
CONFIG_SPI_DESIGNWARE=m
# CONFIG_SPI_DW_PCI is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=m

#
# Qualcomm MSM SSBI bus support
#
# CONFIG_SSBI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=y

#
# PPS support
#
CONFIG_PPS=m
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_PARPORT is not set
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
# CONFIG_PTP_1588_CLOCK is not set

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_DS1WM=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=m
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
CONFIG_GENERIC_ADC_BATTERY=m
# CONFIG_MAX8925_POWER is not set
CONFIG_WM831X_BACKUP=y
# CONFIG_WM831X_POWER is not set
# CONFIG_WM8350_POWER is not set
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_88PM860X=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=m
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9030=y
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_88PM860X=m
# CONFIG_CHARGER_PCF50633 is not set
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_MANAGER=y
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_SMB347=m
CONFIG_CHARGER_TPS65090=y
CONFIG_BATTERY_GOLDFISH=y
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_AD7314=m
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=m
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_DA9052_ADC=m
CONFIG_SENSORS_DA9055=m
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_HIH6130=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IBMAEM=m
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IIO_HWMON=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM70=m
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LTC4151=m
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4261=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_MAX1111=m
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=m
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NCT6775=m
CONFIG_SENSORS_NTC_THERMISTOR=m
CONFIG_SENSORS_PC87360=m
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=m
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_ADS7871=m
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_WM831X=m
CONFIG_SENSORS_WM8350=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_MC13783_ADC=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
# CONFIG_SSB_PCMCIAHOST is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_AS3711=y
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_CROS_EC=m
CONFIG_MFD_CROS_EC_I2C=m
# CONFIG_MFD_CROS_EC_SPI is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
CONFIG_MFD_MC13783=m
CONFIG_MFD_MC13XXX=m
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_MFD_MC13XXX_I2C=m
CONFIG_HTC_PASIC3=y
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_88PM800=m
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
# CONFIG_MFD_MAX8907 is not set
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=m
CONFIG_PCF50633_ADC=m
# CONFIG_PCF50633_GPIO is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=m
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=m
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=m
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
CONFIG_MFD_ARIZONA_SPI=y
# CONFIG_MFD_WM5102 is not set
# CONFIG_MFD_WM5110 is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM831X_SPI is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_AD5398=y
# CONFIG_REGULATOR_DA903X is not set
CONFIG_REGULATOR_DA9052=m
CONFIG_REGULATOR_DA9055=m
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_MC13XXX_CORE=m
CONFIG_REGULATOR_MC13783=m
# CONFIG_REGULATOR_MC13892 is not set
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_88PM8607=y
CONFIG_REGULATOR_MAX1586=m
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=m
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_LP8755=m
# CONFIG_REGULATOR_LP8788 is not set
CONFIG_REGULATOR_PCF50633=m
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS62360=y
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65090=y
CONFIG_REGULATOR_TPS65217=m
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8350=y
CONFIG_REGULATOR_WM8994=m
# CONFIG_REGULATOR_AS3711 is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
# CONFIG_VIDEO_V4L2_INT_DEVICE is not set
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
# CONFIG_MEDIA_PCI_SUPPORT is not set
CONFIG_V4L_PLATFORM_DRIVERS=y
# CONFIG_VIDEO_CAFE_CCIC is not set
# CONFIG_VIDEO_TIMBERDALE is not set
# CONFIG_SOC_CAMERA is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_MEDIA_PARPORT_SUPPORT=y
# CONFIG_VIDEO_BWQCAM is not set
CONFIG_VIDEO_CQCAM=m

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
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=y
CONFIG_VIDEO_TDA9840=y
CONFIG_VIDEO_TEA6415C=y
# CONFIG_VIDEO_TEA6420 is not set
CONFIG_VIDEO_MSP3400=y
# CONFIG_VIDEO_CS5345 is not set
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_TLV320AIC23B=m
# CONFIG_VIDEO_UDA1342 is not set
CONFIG_VIDEO_WM8775=y
CONFIG_VIDEO_WM8739=y
CONFIG_VIDEO_VP27SMPX=y
CONFIG_VIDEO_SONY_BTF_MPX=m

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set

#
# Video decoders
#
# CONFIG_VIDEO_ADV7180 is not set
# CONFIG_VIDEO_ADV7183 is not set
CONFIG_VIDEO_ADV7604=y
# CONFIG_VIDEO_BT819 is not set
CONFIG_VIDEO_BT856=m
CONFIG_VIDEO_BT866=y
CONFIG_VIDEO_KS0127=m
CONFIG_VIDEO_SAA7110=y
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_SAA7191=y
CONFIG_VIDEO_TVP514X=m
# CONFIG_VIDEO_TVP5150 is not set
CONFIG_VIDEO_TVP7002=y
# CONFIG_VIDEO_TW2804 is not set
CONFIG_VIDEO_TW9903=y
CONFIG_VIDEO_TW9906=m
CONFIG_VIDEO_VPX3220=m

#
# Video and audio decoders
#
# CONFIG_VIDEO_SAA717X is not set
CONFIG_VIDEO_CX25840=y

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=y
CONFIG_VIDEO_SAA7185=y
CONFIG_VIDEO_ADV7170=m
CONFIG_VIDEO_ADV7175=y
CONFIG_VIDEO_ADV7343=m
CONFIG_VIDEO_ADV7393=m
CONFIG_VIDEO_AD9389B=y
CONFIG_VIDEO_AK881X=y

#
# Camera sensor devices
#
CONFIG_VIDEO_APTINA_PLL=y
# CONFIG_VIDEO_OV7640 is not set
CONFIG_VIDEO_OV7670=m
# CONFIG_VIDEO_OV9650 is not set
CONFIG_VIDEO_VS6624=y
CONFIG_VIDEO_MT9M032=m
CONFIG_VIDEO_MT9P031=y
# CONFIG_VIDEO_MT9T001 is not set
CONFIG_VIDEO_MT9V011=m
CONFIG_VIDEO_MT9V032=y
CONFIG_VIDEO_SR030PC30=y
# CONFIG_VIDEO_NOON010PC30 is not set
# CONFIG_VIDEO_M5MOLS is not set
CONFIG_VIDEO_S5K6AA=y
CONFIG_VIDEO_S5K4ECGX=y
# CONFIG_VIDEO_S5C73M3 is not set

#
# Flash devices
#
CONFIG_VIDEO_ADP1653=m
CONFIG_VIDEO_AS3645A=y

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=y
CONFIG_VIDEO_UPD64083=m

#
# Miscelaneous helper chips
#
# CONFIG_VIDEO_THS7303 is not set
CONFIG_VIDEO_M52790=y

#
# Sensors used on soc_camera driver
#

#
# Customise DVB Frontends
#
# CONFIG_DVB_AU8522_V4L is not set
# CONFIG_DVB_TUNER_DIB0070 is not set
# CONFIG_DVB_TUNER_DIB0090 is not set

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_HDMI=y
CONFIG_FB=m
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=m
# CONFIG_FB_VGA16 is not set
CONFIG_FB_N411=m
CONFIG_FB_HGA=m
CONFIG_FB_S1D13XXX=m
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=m
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_SM501=m
CONFIG_FB_GOLDFISH=m
CONFIG_FB_VIRTUAL=m
CONFIG_FB_METRONOME=m
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=m
CONFIG_FB_AUO_K190X=m
# CONFIG_FB_AUO_K1900 is not set
# CONFIG_FB_AUO_K1901 is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_LTV350QV is not set
CONFIG_LCD_ILI922X=y
CONFIG_LCD_ILI9320=y
CONFIG_LCD_TDO24M=y
# CONFIG_LCD_VGG2432A4 is not set
# CONFIG_LCD_PLATFORM is not set
CONFIG_LCD_LMS501KF03=m
CONFIG_LCD_HX8357=y
# CONFIG_BACKLIGHT_CLASS_DEVICE is not set
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=m
CONFIG_HIDRAW=y
CONFIG_UHID=m
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
CONFIG_HID_CHERRY=m
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=m
CONFIG_HID_ELECOM=m
# CONFIG_HID_EZKEY is not set
CONFIG_HID_KEYTOUCH=m
# CONFIG_HID_KYE is not set
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
# CONFIG_HID_GYRATION is not set
CONFIG_HID_ICADE=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
# CONFIG_HID_LOGITECH is not set
CONFIG_HID_MAGICMOUSE=m
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
CONFIG_PANTHERLORD_FF=y
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=m
# CONFIG_HID_PICOLCD_FB is not set
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_PS3REMOTE is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=m
CONFIG_HID_GREENASIA=m
CONFIG_GREENASIA_FF=y
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
CONFIG_THRUSTMASTER_FF=y
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=m
CONFIG_HID_WIIMOTE_EXT=y
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# I2C HID support
#
CONFIG_I2C_HID=m
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=m
CONFIG_MMC_WBSD=m
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SPI is not set
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
# CONFIG_LEDS_88PM860X is not set
CONFIG_LEDS_LM3530=m
CONFIG_LEDS_LM3533=m
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_PCA9532=m
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8788=m
CONFIG_LEDS_PCA955X=m
# CONFIG_LEDS_PCA9633 is not set
CONFIG_LEDS_WM831X_STATUS=m
# CONFIG_LEDS_WM8350 is not set
CONFIG_LEDS_DA903X=m
CONFIG_LEDS_DA9052=m
CONFIG_LEDS_DAC124S085=m
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=m
CONFIG_LEDS_ADP5520=m
CONFIG_LEDS_MC13783=m
CONFIG_LEDS_TCA6507=m
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
# CONFIG_LEDS_TRIGGER_CAMERA is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I7CORE is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
# CONFIG_RTC_INTF_DEV is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM860X=m
# CONFIG_RTC_DRV_88PM80X is not set
CONFIG_RTC_DRV_DS1307=m
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
CONFIG_RTC_DRV_DS3232=m
CONFIG_RTC_DRV_LP8788=y
# CONFIG_RTC_DRV_MAX6900 is not set
CONFIG_RTC_DRV_MAX8925=y
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_X1205=y
# CONFIG_RTC_DRV_PCF8523 is not set
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=y
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=m
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=m
CONFIG_RTC_DRV_EM3027=y
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=m
CONFIG_RTC_DRV_M41T94=y
CONFIG_RTC_DRV_DS1305=m
CONFIG_RTC_DRV_DS1390=m
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_R9701 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
CONFIG_RTC_DRV_DS3234=y
CONFIG_RTC_DRV_PCF2123=y
CONFIG_RTC_DRV_RX4581=m

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_DA9052=m
# CONFIG_RTC_DRV_DA9055 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_RP5C01=m
# CONFIG_RTC_DRV_V3020 is not set
# CONFIG_RTC_DRV_DS2404 is not set
CONFIG_RTC_DRV_WM831X=m
CONFIG_RTC_DRV_WM8350=y
CONFIG_RTC_DRV_PCF50633=m

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=m

#
# HID Sensor RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC=m
# CONFIG_DW_DMAC_BIG_ENDIAN_IO is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=m
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
# CONFIG_CFAG12864B is not set
CONFIG_UIO=m
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV is not set
CONFIG_UIO_PDRV_GENIRQ=m
CONFIG_UIO_DMEM_GENIRQ=m
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=m
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
CONFIG_ECHO=y
CONFIG_COMEDI=m
CONFIG_COMEDI_DEBUG=y
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
# CONFIG_COMEDI_MISC_DRIVERS is not set
# CONFIG_COMEDI_PCI_DRIVERS is not set
CONFIG_COMEDI_PCMCIA_DRIVERS=y
# CONFIG_COMEDI_CB_DAS16_CS is not set
CONFIG_COMEDI_DAS08_CS=m
CONFIG_COMEDI_NI_DAQ_700_CS=m
CONFIG_COMEDI_NI_DAQ_DIO24_CS=m
CONFIG_COMEDI_NI_LABPC_CS=m
CONFIG_COMEDI_NI_MIO_CS=m
# CONFIG_COMEDI_QUATECH_DAQP_CS is not set
CONFIG_COMEDI_8255=m
CONFIG_COMEDI_FC=m
CONFIG_COMEDI_DAS08=m
CONFIG_COMEDI_NI_LABPC=m
CONFIG_COMEDI_NI_TIO=m
CONFIG_PANEL=m
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
CONFIG_PANEL_CHANGE_MESSAGE=y
CONFIG_PANEL_BOOT_MESSAGE=""
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#

#
# Accelerometers
#
CONFIG_ADIS16201=m
CONFIG_ADIS16203=m
# CONFIG_ADIS16204 is not set
CONFIG_ADIS16209=m
# CONFIG_ADIS16220 is not set
CONFIG_ADIS16240=m
CONFIG_SCA3000=m

#
# Analog to digital converters
#
CONFIG_AD7291=m
CONFIG_AD799X=m
CONFIG_AD799X_RING_BUFFER=y
CONFIG_AD7192=m
# CONFIG_AD7280 is not set

#
# Analog digital bi-direction converters
#

#
# Capacitance to digital converters
#
CONFIG_AD7150=m
CONFIG_AD7152=m
CONFIG_AD7746=m

#
# Direct Digital Synthesis
#
# CONFIG_AD5930 is not set
CONFIG_AD9832=m
# CONFIG_AD9834 is not set
CONFIG_AD9850=m
CONFIG_AD9852=m
# CONFIG_AD9910 is not set
CONFIG_AD9951=m

#
# Digital gyroscope sensors
#
CONFIG_ADIS16060=m
CONFIG_ADIS16130=m
CONFIG_ADIS16260=m

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=m

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=m
CONFIG_SENSORS_ISL29028=m
CONFIG_TSL2583=m
CONFIG_TSL2x7x=m

#
# Magnetometer sensors
#
CONFIG_SENSORS_HMC5843=m

#
# Active energy metering IC
#
CONFIG_ADE7753=m
CONFIG_ADE7754=m
# CONFIG_ADE7758 is not set
CONFIG_ADE7759=m
# CONFIG_ADE7854 is not set

#
# Resolver to digital converters
#
CONFIG_AD2S90=m

#
# Triggers - standalone
#
CONFIG_IIO_PERIODIC_RTC_TRIGGER=m
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_ZSMALLOC is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_FT1000=y
# CONFIG_FT1000_PCMCIA is not set

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
# CONFIG_ASHMEM is not set
# CONFIG_ANDROID_LOGGER is not set
# CONFIG_ANDROID_TIMED_OUTPUT is not set
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
# CONFIG_ANDROID_INTF_ALARM_DEV is not set
CONFIG_SYNC=y
CONFIG_SW_SYNC=y
CONFIG_SW_SYNC_USER=y
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_NET_VENDOR_SILICOM is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_PVPANIC is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_ADC_JACK=m
# CONFIG_EXTCON_MAX77693 is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
# CONFIG_IIO_BUFFER_CB is not set
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
CONFIG_KXSD9=m

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=m
# CONFIG_AD7266 is not set
CONFIG_AD7298=m
# CONFIG_AD7923 is not set
CONFIG_AD7791=m
# CONFIG_AD7793 is not set
CONFIG_AD7476=m
CONFIG_AD7887=m
# CONFIG_LP8788_ADC is not set
CONFIG_MAX1363=m
CONFIG_TI_ADC081C=m
# CONFIG_TI_AM335X_ADC is not set

#
# Amplifiers
#
# CONFIG_AD8366 is not set

#
# Hid Sensor IIO Common
#

#
# Digital to analog converters
#
CONFIG_AD5064=m
CONFIG_AD5360=m
CONFIG_AD5380=m
CONFIG_AD5421=m
CONFIG_AD5624R_SPI=m
CONFIG_AD5446=m
# CONFIG_AD5449 is not set
CONFIG_AD5504=m
# CONFIG_AD5755 is not set
CONFIG_AD5764=m
CONFIG_AD5791=m
# CONFIG_AD5686 is not set
CONFIG_MAX517=m
CONFIG_MCP4725=m

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
CONFIG_AD9523=m

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
CONFIG_ADF4350=m

#
# Digital gyroscope sensors
#
# CONFIG_ADIS16080 is not set
CONFIG_ADIS16136=m
CONFIG_ADXRS450=m
CONFIG_ITG3200=m

#
# Inertial measurement units
#
# CONFIG_ADIS16400 is not set
CONFIG_ADIS16480=m
CONFIG_IIO_ADIS_LIB=m
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
# CONFIG_SENSORS_LM3533 is not set
CONFIG_SENSORS_TSL2563=m
CONFIG_VCNL4000=m

#
# Magnetometer sensors
#
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=m
# CONFIG_DCDBAS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
# CONFIG_SYSFS is not set
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ECRYPT_FS is not set
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
CONFIG_JFFS2_FS_WBUF_VERIFY=y
# CONFIG_JFFS2_SUMMARY is not set
# CONFIG_JFFS2_FS_XATTR is not set
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
CONFIG_JFFS2_LZO=y
# CONFIG_JFFS2_RTIME is not set
CONFIG_JFFS2_RUBIN=y
# CONFIG_JFFS2_CMODE_NONE is not set
CONFIG_JFFS2_CMODE_PRIORITY=y
# CONFIG_JFFS2_CMODE_SIZE is not set
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
# CONFIG_LOGFS is not set
CONFIG_ROMFS_FS=m
CONFIG_ROMFS_BACKED_BY_MTD=y
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=m
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=m
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=m
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=m
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=m
# CONFIG_NLS_MAC_TURKISH is not set
# CONFIG_NLS_UTF8 is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_DEBUG_SLAB=y
# CONFIG_DEBUG_SLAB_LEAK is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_NOTIFIER_ERROR_INJECTION=m
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
# CONFIG_FAULT_INJECTION is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
# CONFIG_DEBUG_PAGEALLOC is not set
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
# CONFIG_FUNCTION_GRAPH_TRACER is not set
CONFIG_IRQSOFF_TRACER=y
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_STACK_TRACER=y
CONFIG_KPROBE_EVENT=y
# CONFIG_UPROBE_EVENT is not set
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
# CONFIG_EVENT_TRACE_TEST_SYSCALLS is not set
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_RBTREE_TEST is not set
CONFIG_INTERVAL_TREE_TEST=m
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_STRING_HELPERS=m
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
CONFIG_DEBUG_TLBFLUSH=y
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
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=m
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
# CONFIG_CRYPTO_ECB is not set
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=m
# CONFIG_CRYPTO_MD5 is not set
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=m
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=m
# CONFIG_CRYPTO_ARC4 is not set
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
# CONFIG_CRYPTO_BLOWFISH_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
# CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y
# CONFIG_CRYPTO_TWOFISH_AVX2_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
CONFIG_ASYMMETRIC_KEY_TYPE=m
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=m
CONFIG_PUBLIC_KEY_ALGO_RSA=m
# CONFIG_X509_CERTIFICATE_PARSER is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_CRC8=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_MPILIB=m

--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--82I3+IH0IqGh5yIs--
