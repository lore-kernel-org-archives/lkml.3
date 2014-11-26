Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbaKZUBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 15:01:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:4684 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbaKZUBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 15:01:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,464,1413270000"; 
   d="scan'208";a="628780254"
Date: Wed, 26 Nov 2014 12:00:23 -0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "pang.xunlei" <pang.xunlei@linaro.org>
Cc: John Stultz <john.stultz@linaro.org>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: [time] WARNING: CPU: 0 PID: 1 at kernel/time/timekeeping.c:1337
 update_wall_time()
Message-ID: <20141126200023.GC22400@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Y5rl02BVI9TCfPar"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y5rl02BVI9TCfPar
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master

commit 6067dc5a8c2b1b57e67eaf1125db1d63c1ed6361
Author:     pang.xunlei <pang.xunlei@linaro.org>
AuthorDate: Wed Oct 8 15:03:34 2014 +0800
Commit:     John Stultz <john.stultz@linaro.org>
CommitDate: Fri Nov 21 11:59:56 2014 -0800

    time: Avoid possible NTP adjustment mult overflow.
    
    Ideally, __clocksource_updatefreq_scale, selects the largest shift
    value possible for a clocksource. This results in the mult memember of
    struct clocksource being particularly large, although not so large
    that NTP would adjust the clock to cause it to overflow.
    
    That said, nothing actually prohibits an overflow from occuring, its
    just that it "shouldn't" occur.
    
    So while very unlikely, and so far never observed, the value of
    (cs->mult+cs->maxadj) may have a chance to reach very near 0xFFFFFFFF,
    so there is a possibility it may overflow when doing NTP positive
    adjustment
    
    See the following detail: When NTP slewes the clock, kernel goes
    through update_wall_time()->...->timekeeping_apply_adjustment():
    	tk->tkr.mult += mult_adj;
    
    Since there is no guard against it, its possible tk->tkr.mult may
    overflow during this operation.
    
    This patch avoids any possible mult overflow by judging the overflow
    case before adding mult_adj to mult, also adds the WARNING message
    when capturing such case.
    
    Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
    [jstultz: Reworded commit message]
    Signed-off-by: John Stultz <john.stultz@linaro.org>

+----------------------------------------------------------+------------+------------+---------------+
|                                                          | fd866e2b11 | 6067dc5a8c | next-20141125 |
+----------------------------------------------------------+------------+------------+---------------+
| boot_successes                                           | 60         | 0          | 0             |
| boot_failures                                            | 0          | 20         | 12            |
| WARNING:at_kernel/time/timekeeping.c:#update_wall_time() | 0          | 20         | 12            |
| backtrace:acpi_get_devices                               | 0          | 19         | 12            |
| backtrace:pnpacpi_init                                   | 0          | 19         | 12            |
| backtrace:kernel_init_freeable                           | 0          | 20         | 12            |
| backtrace:pcibios_assign_resources                       | 0          | 1          |               |
+----------------------------------------------------------+------------+------------+---------------+

[    0.789871] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.791002] ------------[ cut here ]------------
[    0.791002] ------------[ cut here ]------------
[    0.791002] WARNING: CPU: 0 PID: 1 at kernel/time/timekeeping.c:1337 update_wall_time+0x3a8/0x56f()
[    0.791002] WARNING: CPU: 0 PID: 1 at kernel/time/timekeeping.c:1337 update_wall_time+0x3a8/0x56f()
[    0.791002] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc2-g6067dc5 #280
[    0.791002] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc2-g6067dc5 #280
[    0.791002]  0000000000000009 ffff880013803e68 ffffffff81a5803b 0000000000000068

git bisect start 7cc2ecdb63cfae062aeadc7c575a02b6e9cc4dbb 5d01410fe4d92081f349b013a2e7a95429e4f2c9 --
git bisect good c9f4ffa0ef6c4c71735e10e20d363b9de90725ac  # 10:27     20+      0  Merge remote-tracking branch 'l2-mtd/master'
git bisect  bad 0ac890893dfd6c51841f35b9cada0a002ada075d  # 10:33      0-      7  Merge remote-tracking branch 'ftrace/for-next'
git bisect good 4e0bc872f2ddddc08c0c5f18c9de6ef058d8d4fd  # 10:59     20+      0  Merge remote-tracking branch 'battery/master'
git bisect good a86dc53b0ec5196141ee0552805e03e42ba315d2  # 11:05     20+      0  Merge remote-tracking branch 'trivial/for-next'
git bisect  bad 50fa5ed69f4656a571166eac72c5b9108d487e7c  # 11:09      0-      5  Merge remote-tracking branch 'tip/auto-latest'
git bisect good 709de16948ef4b4bdc92fa7bff3808367f184075  # 11:59     20+      0  Merge remote-tracking branch 'devicetree/devicetree/next'
git bisect good daef792655bde9319bdfe5ba04ff42767d7622b4  # 12:05     20+      0  Merge remote-tracking branch 'spi/for-next'
git bisect  bad 0a2b9eac5a4567ca85c5a0daf96196563414765f  # 12:15      0-      3  Merge branch 'timers/core'
git bisect good 4e6e311e596eadba30d4f56f64eae7d45611a01c  # 12:17     20+      0  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core
git bisect good 36ce98818a4df66c8134c31fd6e768b4119c7a90  # 12:24     20+      0  sched/deadline: Introduce start_hrtick_dl() for !CONFIG_SCHED_HRTICK
git bisect good 9ea6c5885681e3d9ce9844ba9dc57371a5cfc6d2  # 12:32     20+      0  Merge branches 'torture.2014.11.03a', 'cpu.2014.11.03a', 'doc.2014.11.13a', 'fixes.2014.11.13a', 'signal.2014.10.29a' and 'rt.2014.10.29a' into HEAD
git bisect  bad 21b6c0512e8aca75ce76365e1aef9fb16e007100  # 12:36      0-     18  time: Remove timekeeping_inject_sleeptime()
git bisect  bad 90b6ce9c4066e0b2098dff65e52e6e7df1a51079  # 12:39      0-      1  time: Provide y2038 safe mktime() replacement
git bisect  bad 659bc17b80c692e0ccda757e207fc4666d9b3e71  # 12:55      0-     19  time: Complete NTP adjustment threshold judging conditions
git bisect  bad 6067dc5a8c2b1b57e67eaf1125db1d63c1ed6361  # 12:58      0-     20  time: Avoid possible NTP adjustment mult overflow.
git bisect good fd866e2b116b01d42428491899fe9925c42c121c  # 13:06     20+      0  time: Rename udelay_test.c to test_udelay.c
# first bad commit: [6067dc5a8c2b1b57e67eaf1125db1d63c1ed6361] time: Avoid possible NTP adjustment mult overflow.
git bisect good fd866e2b116b01d42428491899fe9925c42c121c  # 13:09     60+      0  time: Rename udelay_test.c to test_udelay.c
# extra tests on HEAD of next/master
git bisect  bad 7cc2ecdb63cfae062aeadc7c575a02b6e9cc4dbb  # 13:09      0-     12  Add linux-next specific files for 20141125
# extra tests on tree/branch next/master
git bisect  bad 7cc2ecdb63cfae062aeadc7c575a02b6e9cc4dbb  # 13:09      0-     12  Add linux-next specific files for 20141125
# extra tests on tree/branch linus/master
git bisect good b914c5b2130239fd378d1a719ab3c53f0c782be9  # 13:16     60+      0  Merge branch 'for-3.18' of git://linux-nfs.org/~bfields/linux
# extra tests on tree/branch next/master
git bisect  bad 7cc2ecdb63cfae062aeadc7c575a02b6e9cc4dbb  # 13:16      0-     12  Add linux-next specific files for 20141125


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-enable-kvm
	-cpu Haswell,+smep,+smap
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

--Y5rl02BVI9TCfPar
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-kbuild-20:20141126125541:x86_64-randconfig-ha2-1124:3.18.0-rc2-g6067dc5:280"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc2-g6067dc5 (kbuild@lkp-hsx01) (gcc ve=
rsion 4.9.1 (Debian 4.9.1-19) ) #280 SMP PREEMPT Wed Nov 26 12:55:33 CST 20=
14
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-ha2-1124/next:master:6067dc5a8c2b1b57e67eaf1125db1d63c1ed6361:bisect-l=
inux-7/.vmlinuz-6067dc5a8c2b1b57e67eaf1125db1d63c1ed6361-20141126125540-20-=
kbuild branch=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-ha2-1124=
/6067dc5a8c2b1b57e67eaf1125db1d63c1ed6361/vmlinuz-3.18.0-rc2-g6067dc5 drbd.=
minor_count=3D8
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
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdb00-0x000fdb0f] mapped at =
[ffff8800000fdb00]
[    0.000000]   mpc: fdb10-fdbf0
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0308f000, 0x0308ffff] PGTABLE
[    0.000000] BRK [0x03090000, 0x03090fff] PGTABLE
[    0.000000] BRK [0x03091000, 0x03091fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 4k
[    0.000000] BRK [0x03092000, 0x03092fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 4k
[    0.000000] BRK [0x03093000, 0x03093fff] PGTABLE
[    0.000000] BRK [0x03094000, 0x03094fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] cma: Reserved 32 MiB at 11800000
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD9A0 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE4B0 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE4F0 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF800 000735 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF6E0 000078 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF6A0 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] NODE_DATA(0) allocated [mem 0x13ff9000-0x13ffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ff8001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
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
[    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 474 pages/cpu @ffff880013800000 s1912448 r0=
 d29056 u2097152
[    0.000000] pcpu-alloc: s1912448 r0 d29056 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1380cd80
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-ha2-1124/next:master:6067dc5a8c2b1b57e67eaf1125db1d63c1ed6361:b=
isect-linux-7/.vmlinuz-6067dc5a8c2b1b57e67eaf1125db1d63c1ed6361-20141126125=
540-20-kbuild branch=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-h=
a2-1124/6067dc5a8c2b1b57e67eaf1125db1d63c1ed6361/vmlinuz-3.18.0-rc2-g6067dc=
5 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standar=
d form
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 249184K/327280K available (10646K kernel code, 1587K=
 rwdata, 5244K rodata, 2704K init, 13120K bss, 78096K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D1
[    0.000000] NR_IRQS:4352 nr_irqs:256 0
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc2-g6067dc5 (kbuild@lkp-hsx01) (gcc ve=
rsion 4.9.1 (Debian 4.9.1-19) ) #280 SMP PREEMPT Wed Nov 26 12:55:33 CST 20=
14
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-ha2-1124/next:master:6067dc5a8c2b1b57e67eaf1125db1d63c1ed6361:bisect-l=
inux-7/.vmlinuz-6067dc5a8c2b1b57e67eaf1125db1d63c1ed6361-20141126125540-20-=
kbuild branch=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-ha2-1124=
/6067dc5a8c2b1b57e67eaf1125db1d63c1ed6361/vmlinuz-3.18.0-rc2-g6067dc5 drbd.=
minor_count=3D8
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
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdb00-0x000fdb0f] mapped at =
[ffff8800000fdb00]
[    0.000000]   mpc: fdb10-fdbf0
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0308f000, 0x0308ffff] PGTABLE
[    0.000000] BRK [0x03090000, 0x03090fff] PGTABLE
[    0.000000] BRK [0x03091000, 0x03091fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 4k
[    0.000000] BRK [0x03092000, 0x03092fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 4k
[    0.000000] BRK [0x03093000, 0x03093fff] PGTABLE
[    0.000000] BRK [0x03094000, 0x03094fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] cma: Reserved 32 MiB at 11800000
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD9A0 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE4B0 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE4F0 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF800 000735 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF6E0 000078 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF6A0 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] NODE_DATA(0) allocated [mem 0x13ff9000-0x13ffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ff8001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
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
[    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 474 pages/cpu @ffff880013800000 s1912448 r0=
 d29056 u2097152
[    0.000000] pcpu-alloc: s1912448 r0 d29056 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1380cd80
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-ha2-1124/next:master:6067dc5a8c2b1b57e67eaf1125db1d63c1ed6361:b=
isect-linux-7/.vmlinuz-6067dc5a8c2b1b57e67eaf1125db1d63c1ed6361-20141126125=
540-20-kbuild branch=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-h=
a2-1124/6067dc5a8c2b1b57e67eaf1125db1d63c1ed6361/vmlinuz-3.18.0-rc2-g6067dc=
5 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standar=
d form
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 249184K/327280K available (10646K kernel code, 1587K=
 rwdata, 5244K rodata, 2704K init, 13120K bss, 78096K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D1
[    0.000000] NR_IRQS:4352 nr_irqs:256 0
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8639 kB
[    0.000000]  memory used by lock dependency info: 8639 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.528 MHz processor
[    0.000000] tsc: Detected 2693.528 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value..=20
[    0.006666] Calibrating delay loop (skipped) preset value.. 5389.51 Bogo=
MIPS (lpj=3D8978426)
5389.51 BogoMIPS (lpj=3D8978426)
[    0.007769] pid_max: default: 4096 minimum: 301
[    0.007769] pid_max: default: 4096 minimum: 301
[    0.010050] ACPI: Core revision 20140926
[    0.010050] ACPI: Core revision 20140926
[    0.017952] ACPI:=20
[    0.017952] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.020395] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.020395] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.023436] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.023436] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.026023] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.026023] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.026686] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.026686] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.030704] Initializing cgroup subsys freezer
[    0.030704] Initializing cgroup subsys freezer
[    0.033356] Initializing cgroup subsys blkio
[    0.033356] Initializing cgroup subsys blkio
[    0.035130] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.035130] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.035130] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.035130] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.060251] debug: unmapping init [mem 0xffffffff823b8000-0xffffffff823b=
efff]
[    0.060251] debug: unmapping init [mem 0xffffffff823b8000-0xffffffff823b=
efff]
[    0.067447] Getting VERSION: 1050014
[    0.067447] Getting VERSION: 1050014
[    0.068818] Getting VERSION: 1050014
[    0.068818] Getting VERSION: 1050014
[    0.070016] Getting ID: 0
[    0.070016] Getting ID: 0
[    0.070987] Getting ID: ff000000
[    0.070987] Getting ID: ff000000
[    0.072209] Getting LVT0: 8700
[    0.072209] Getting LVT0: 8700
[    0.073347] Getting LVT1: 8400
[    0.073347] Getting LVT1: 8400
[    0.074609] enabled ExtINT on CPU#0
[    0.074609] enabled ExtINT on CPU#0
[    0.077828] ENABLING IO-APIC IRQs
[    0.077828] ENABLING IO-APIC IRQs
[    0.079050] init IO_APIC IRQs
[    0.079050] init IO_APIC IRQs
[    0.080008]  apic 0 pin 0 not connected
[    0.080008]  apic 0 pin 0 not connected
[    0.081391] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.081391] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.083365] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.083365] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.086699] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.086699] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.088978] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.088978] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.090037] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.090037] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.093367] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.093367] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.096697] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.096697] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.100034] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.100034] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.103367] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.103367] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.106702] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.106702] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.109440] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.109440] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.110047] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.110047] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.113368] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.113368] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.116710] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.116710] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.120040] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.120040] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.123365] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.123365] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.125832]  apic 0 pin 16 not connected
[    0.125832]  apic 0 pin 16 not connected
[    0.126672]  apic 0 pin 17 not connected
[    0.126672]  apic 0 pin 17 not connected
[    0.128343]  apic 0 pin 18 not connected
[    0.128343]  apic 0 pin 18 not connected
[    0.130005]  apic 0 pin 19 not connected
[    0.130005]  apic 0 pin 19 not connected
[    0.131604]  apic 0 pin 20 not connected
[    0.131604]  apic 0 pin 20 not connected
[    0.133338]  apic 0 pin 21 not connected
[    0.133338]  apic 0 pin 21 not connected
[    0.134758]  apic 0 pin 22 not connected
[    0.134758]  apic 0 pin 22 not connected
[    0.136672]  apic 0 pin 23 not connected
[    0.136672]  apic 0 pin 23 not connected
[    0.138144] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.138144] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.140006] smpboot: CPU0:=20
[    0.140006] smpboot: CPU0: Intel Core Processor (Haswell)Intel Core Proc=
essor (Haswell) (fam: 06, model: 3c (fam: 06, model: 3c, stepping: 01)
, stepping: 01)
[    0.142760] TSC deadline timer enabled
[    0.142760] TSC deadline timer enabled
[    0.143333] Performance Events:=20
[    0.143333] Performance Events: unsupported p6 CPU model 60 unsupported =
p6 CPU model 60 no PMU driver, software events only.
no PMU driver, software events only.
[    0.156690] x86: Booted up 1 node, 1 CPUs
[    0.156690] x86: Booted up 1 node, 1 CPUs
[    0.157777] ----------------
[    0.157777] ----------------
[    0.158627] | NMI testsuite:
[    0.158627] | NMI testsuite:
[    0.159584] --------------------
[    0.159584] --------------------
[    0.160015] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.160015] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.162880]   remote IPI:
[    0.162880]   remote IPI:  ok  |  ok  |

[    0.164141]    local IPI:
[    0.164141]    local IPI:  ok  |  ok  |

[    0.190025] --------------------
[    0.190025] --------------------
[    0.191109] Good, all   2 testcases passed! |
[    0.191109] Good, all   2 testcases passed! |
[    0.192529] ---------------------------------
[    0.192529] ---------------------------------
[    0.193358] smpboot: Total of 1 processors activated (5389.51 BogoMIPS)
[    0.193358] smpboot: Total of 1 processors activated (5389.51 BogoMIPS)
[    0.196440] devtmpfs: initialized
[    0.196440] devtmpfs: initialized
[    0.217430] xor: automatically using best checksumming function:
[    0.217430] xor: automatically using best checksumming function:
[    0.253396]    avx       :  6496.800 MB/sec
[    0.253396]    avx       :  6496.800 MB/sec
[    0.256296] prandom: seed boundary self test passed
[    0.256296] prandom: seed boundary self test passed
[    0.258148] prandom: 100 self tests passed
[    0.258148] prandom: 100 self tests passed
[    0.261168] regulator-dummy: no parameters
[    0.261168] regulator-dummy: no parameters
[    0.264255] NET: Registered protocol family 16
[    0.264255] NET: Registered protocol family 16
[    0.283363] cpuidle: using governor menu
[    0.283363] cpuidle: using governor menu
[    0.324484] ACPI: bus type PCI registered
[    0.324484] ACPI: bus type PCI registered
[    0.325842] PCI: Using configuration type 1 for base access
[    0.325842] PCI: Using configuration type 1 for base access
[    0.470035] raid6: sse2x1    4257 MB/s
[    0.470035] raid6: sse2x1    4257 MB/s
[    0.530026] raid6: sse2x2    6141 MB/s
[    0.530026] raid6: sse2x2    6141 MB/s
[    0.586680] raid6: sse2x4    7177 MB/s
[    0.586680] raid6: sse2x4    7177 MB/s
[    0.587990] raid6: using algorithm sse2x4 (7177 MB/s)
[    0.587990] raid6: using algorithm sse2x4 (7177 MB/s)
[    0.589652] raid6: using ssse3x2 recovery algorithm
[    0.589652] raid6: using ssse3x2 recovery algorithm
[    0.590097] gpio-f7188x: Not a Fintek device at 0x0000002e
[    0.590097] gpio-f7188x: Not a Fintek device at 0x0000002e
[    0.591723] gpio-f7188x: Not a Fintek device at 0x0000004e
[    0.591723] gpio-f7188x: Not a Fintek device at 0x0000004e
[    0.593804] ACPI: Added _OSI(Module Device)
[    0.593804] ACPI: Added _OSI(Module Device)
[    0.595218] ACPI: Added _OSI(Processor Device)
[    0.595218] ACPI: Added _OSI(Processor Device)
[    0.596676] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.596676] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.598247] ACPI: Added _OSI(Processor Aggregator Device)
[    0.598247] ACPI: Added _OSI(Processor Aggregator Device)
[    0.611140] ACPI: Interpreter enabled
[    0.611140] ACPI: Interpreter enabled
[    0.612386] ACPI Exception: AE_NOT_FOUND,=20
[    0.612386] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_]While evaluating Sleep State [\_S1_] (20140926/hwxface-580)
 (20140926/hwxface-580)
[    0.615143] ACPI Exception: AE_NOT_FOUND,=20
[    0.615143] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_]While evaluating Sleep State [\_S2_] (20140926/hwxface-580)
 (20140926/hwxface-580)
[    0.617460] ACPI: (supports S0 S3 S5)
[    0.617460] ACPI: (supports S0 S3 S5)
[    0.618694] ACPI: Using IOAPIC for interrupt routing
[    0.618694] ACPI: Using IOAPIC for interrupt routing
[    0.620095] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.620095] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.638712] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.638712] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.640017] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.640017] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.641829] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.641829] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.643918] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.643918] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.646868] PCI host bridge to bus 0000:00
[    0.646868] PCI host bridge to bus 0000:00
[    0.648250] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.648250] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.650010] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.650010] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.653345] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.653345] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.655411] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.655411] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.656677] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.656677] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.659040] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.659040] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.660943] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.660943] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.664007] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.664007] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.668720] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.668720] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.671219] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.671219] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.673342] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.673342] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.675416] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.675416] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.676675] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.676675] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.679072] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.679072] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.680561] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.680561] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.682454] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.682454] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.683984] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.683984] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.687442] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.687442] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.690709] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.690709] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.698761] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.698761] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.701141] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.701141] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.703343] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.703343] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.706298] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.706298] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.711578] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.711578] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.713958] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.713958] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.716440] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.716440] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.725332] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.725332] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.727400] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.727400] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.729465] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.729465] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.730718] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.730718] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.732626] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.732626] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.736953] SCSI subsystem initialized
[    0.736953] SCSI subsystem initialized
[    0.738185] libata version 3.00 loaded.
[    0.738185] libata version 3.00 loaded.
[    0.740323] media: Linux media interface: v0.10
[    0.740323] media: Linux media interface: v0.10
[    0.741728] Linux video capture interface: v2.00
[    0.741728] Linux video capture interface: v2.00
[    0.743175] pps_core: LinuxPPS API ver. 1 registered
[    0.743175] pps_core: LinuxPPS API ver. 1 registered
[    0.743340] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.743340] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.746103] EDAC MC: Ver: 3.0.0
[    0.746103] EDAC MC: Ver: 3.0.0
[    0.747075] EDAC DEBUG: edac_mc_sysfs_init: device mc created
[    0.747075] EDAC DEBUG: edac_mc_sysfs_init: device mc created
[    0.750638] Advanced Linux Sound Architecture Driver Initialized.
[    0.750638] Advanced Linux Sound Architecture Driver Initialized.
[    0.752566] PCI: Using ACPI for IRQ routing
[    0.752566] PCI: Using ACPI for IRQ routing
[    0.753362] PCI: pci_cache_line_size set to 64 bytes
[    0.753362] PCI: pci_cache_line_size set to 64 bytes
[    0.755044] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.755044] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.756681] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.756681] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.762065] hpet0: at MMIO 0xfed00000, IRQs
[    0.762065] hpet0: at MMIO 0xfed00000, IRQs 2 2, 8, 8, 0, 0

[    0.763624] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.763624] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.769988] Switched to clocksource kvm-clock
[    0.769988] Switched to clocksource kvm-clock
[    0.769988] FS-Cache: Loaded
[    0.769988] FS-Cache: Loaded
[    0.769988] pnp: PnP ACPI init
[    0.769988] pnp: PnP ACPI init
[    0.770597] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.770597] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.773075] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.773075] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.785173] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.785173] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.787802] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.787802] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.789871] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.789871] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.791002] ------------[ cut here ]------------
[    0.791002] ------------[ cut here ]------------
[    0.791002] WARNING: CPU: 0 PID: 1 at kernel/time/timekeeping.c:1337 upd=
ate_wall_time+0x3a8/0x56f()
[    0.791002] WARNING: CPU: 0 PID: 1 at kernel/time/timekeeping.c:1337 upd=
ate_wall_time+0x3a8/0x56f()
[    0.791002] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc2-g6067dc=
5 #280
[    0.791002] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc2-g6067dc=
5 #280
[    0.791002]  0000000000000009 ffff880013803e68 ffffffff81a5803b 00000000=
00000068
[    0.791002]  0000000000000009 ffff880013803e68 ffffffff81a5803b 00000000=
00000068
[    0.791002]  0000000000000000 ffff880013803ea8 ffffffff810b6c41 00000001=
a41ccc22
[    0.791002]  0000000000000000 ffff880013803ea8 ffffffff810b6c41 00000001=
a41ccc22
[    0.791002]  ffffffff811089fb 000000000023a910 0000000000000000 00000000=
00000000
[    0.791002]  ffffffff811089fb 000000000023a910 0000000000000000 00000000=
00000000
[    0.791002] Call Trace:
[    0.791002] Call Trace:
[    0.791002]  <IRQ>  [<ffffffff81a5803b>] dump_stack+0x4f/0x7c
[    0.791002]  <IRQ>  [<ffffffff81a5803b>] dump_stack+0x4f/0x7c
[    0.791002]  [<ffffffff810b6c41>] warn_slowpath_common+0x72/0x8c
[    0.791002]  [<ffffffff810b6c41>] warn_slowpath_common+0x72/0x8c
[    0.791002]  [<ffffffff811089fb>] ? update_wall_time+0x3a8/0x56f
[    0.791002]  [<ffffffff811089fb>] ? update_wall_time+0x3a8/0x56f
[    0.791002]  [<ffffffff810b6d12>] warn_slowpath_null+0x15/0x17
[    0.791002]  [<ffffffff810b6d12>] warn_slowpath_null+0x15/0x17
[    0.791002]  [<ffffffff811089fb>] update_wall_time+0x3a8/0x56f
[    0.791002]  [<ffffffff811089fb>] update_wall_time+0x3a8/0x56f
[    0.791002]  [<ffffffff8110eaa7>] ? tick_do_update_jiffies64+0xdc/0x110
[    0.791002]  [<ffffffff8110eaa7>] ? tick_do_update_jiffies64+0xdc/0x110
[    0.791002]  [<ffffffff8110eaac>] tick_do_update_jiffies64+0xe1/0x110
[    0.791002]  [<ffffffff8110eaac>] tick_do_update_jiffies64+0xe1/0x110
[    0.791002]  [<ffffffff8110eb76>] tick_nohz_handler+0x67/0xdd
[    0.791002]  [<ffffffff8110eb76>] tick_nohz_handler+0x67/0xdd
[    0.791002]  [<ffffffff81020b77>] local_apic_timer_interrupt+0x4f/0x53
[    0.791002]  [<ffffffff81020b77>] local_apic_timer_interrupt+0x4f/0x53
[    0.791002]  [<ffffffff81021055>] smp_apic_timer_interrupt+0x3b/0x4d
[    0.791002]  [<ffffffff81021055>] smp_apic_timer_interrupt+0x3b/0x4d
[    0.791002]  [<ffffffff81a6450d>] apic_timer_interrupt+0x6d/0x80
[    0.791002]  [<ffffffff81a6450d>] apic_timer_interrupt+0x6d/0x80
[    0.791002]  <EOI>  [<ffffffff8154a37a>] ? serial8250_console_write+0x13=
f/0x156
[    0.791002]  <EOI>  [<ffffffff8154a37a>] ? serial8250_console_write+0x13=
f/0x156
[    0.791002]  [<ffffffff810f2d70>] ? console_unlock+0x2c3/0x371
[    0.791002]  [<ffffffff810f2d70>] ? console_unlock+0x2c3/0x371
[    0.791002]  [<ffffffff810f3202>] vprintk_emit+0x3e4/0x446
[    0.791002]  [<ffffffff810f3202>] vprintk_emit+0x3e4/0x446
[    0.791002]  [<ffffffff810246db>] ? default_apic_id_valid+0x11/0x11
[    0.791002]  [<ffffffff810246db>] ? default_apic_id_valid+0x11/0x11
[    0.791002]  [<ffffffff81a54f3f>] printk+0x48/0x4a
[    0.791002]  [<ffffffff81a54f3f>] printk+0x48/0x4a
[    0.791002]  [<ffffffff8102327d>] io_apic_setup_irq_pin+0x108/0x1e8
[    0.791002]  [<ffffffff8102327d>] io_apic_setup_irq_pin+0x108/0x1e8
[    0.791002]  [<ffffffff81a5f4e4>] ? mutex_lock_nested+0x323/0x343
[    0.791002]  [<ffffffff81a5f4e4>] ? mutex_lock_nested+0x323/0x343
[    0.791002]  [<ffffffff81024038>] mp_irqdomain_map+0x9c/0xa7
[    0.791002]  [<ffffffff81024038>] mp_irqdomain_map+0x9c/0xa7
[    0.791002]  [<ffffffff810241ba>] mp_map_pin_to_irq+0x177/0x1b3
[    0.791002]  [<ffffffff810241ba>] mp_map_pin_to_irq+0x177/0x1b3
[    0.791002]  [<ffffffff8102424c>] mp_map_gsi_to_irq+0x56/0x5f
[    0.791002]  [<ffffffff8102424c>] mp_map_gsi_to_irq+0x56/0x5f
[    0.791002]  [<ffffffff8101e4ff>] acpi_register_gsi_ioapic+0x8a/0x15f
[    0.791002]  [<ffffffff8101e4ff>] acpi_register_gsi_ioapic+0x8a/0x15f
[    0.791002]  [<ffffffff810ea0a8>] ? put_lock_stats+0xe/0x21
[    0.791002]  [<ffffffff810ea0a8>] ? put_lock_stats+0xe/0x21
[    0.791002]  [<ffffffff8101e62b>] acpi_register_gsi+0xa/0xc
[    0.791002]  [<ffffffff8101e62b>] acpi_register_gsi+0xa/0xc
[    0.791002]  [<ffffffff814f77b9>] acpi_dev_get_irqresource+0xc0/0xf2
[    0.791002]  [<ffffffff814f77b9>] acpi_dev_get_irqresource+0xc0/0xf2
[    0.791002]  [<ffffffff8151d7a5>] ? pnpacpi_type_resources+0x3f/0x3f
[    0.791002]  [<ffffffff8151d7a5>] ? pnpacpi_type_resources+0x3f/0x3f
[    0.791002]  [<ffffffff814f7886>] acpi_dev_resource_interrupt+0x9b/0xa3
[    0.791002]  [<ffffffff814f7886>] acpi_dev_resource_interrupt+0x9b/0xa3
[    0.791002]  [<ffffffff8151d80c>] pnpacpi_allocated_resource+0x67/0x22e
[    0.791002]  [<ffffffff8151d80c>] pnpacpi_allocated_resource+0x67/0x22e
[    0.791002]  [<ffffffff8151d7a5>] ? pnpacpi_type_resources+0x3f/0x3f
[    0.791002]  [<ffffffff8151d7a5>] ? pnpacpi_type_resources+0x3f/0x3f
[    0.791002]  [<ffffffff8150fd80>] acpi_walk_resource_buffer+0x48/0x80
[    0.791002]  [<ffffffff8150fd80>] acpi_walk_resource_buffer+0x48/0x80
[    0.791002]  [<ffffffff8151d7a5>] ? pnpacpi_type_resources+0x3f/0x3f
[    0.791002]  [<ffffffff8151d7a5>] ? pnpacpi_type_resources+0x3f/0x3f
[    0.791002]  [<ffffffff8150fe2a>] acpi_walk_resources+0x72/0x8d
[    0.791002]  [<ffffffff8150fe2a>] acpi_walk_resources+0x72/0x8d
[    0.791002]  [<ffffffff8151da2d>] pnpacpi_parse_allocated_resource+0x5a/=
0x82
[    0.791002]  [<ffffffff8151da2d>] pnpacpi_parse_allocated_resource+0x5a/=
0x82
[    0.791002]  [<ffffffff82314d4f>] pnpacpi_add_device_handler+0x180/0x21e
[    0.791002]  [<ffffffff82314d4f>] pnpacpi_add_device_handler+0x180/0x21e
[    0.791002]  [<ffffffff8150b828>] acpi_ns_get_device_callback+0x13a/0x149
[    0.791002]  [<ffffffff8150b828>] acpi_ns_get_device_callback+0x13a/0x149
[    0.791002]  [<ffffffff81a62a17>] ? _raw_spin_unlock_irqrestore+0x3b/0x51
[    0.791002]  [<ffffffff81a62a17>] ? _raw_spin_unlock_irqrestore+0x3b/0x51
[    0.791002]  [<ffffffff810e92b1>] ? up+0x34/0x39
[    0.791002]  [<ffffffff810e92b1>] ? up+0x34/0x39
[    0.791002]  [<ffffffff8150b63e>] acpi_ns_walk_namespace+0xda/0x18a
[    0.791002]  [<ffffffff8150b63e>] acpi_ns_walk_namespace+0xda/0x18a
[    0.791002]  [<ffffffff8150b6ee>] ? acpi_ns_walk_namespace+0x18a/0x18a
[    0.791002]  [<ffffffff8150b6ee>] ? acpi_ns_walk_namespace+0x18a/0x18a
[    0.791002]  [<ffffffff8150bc9f>] acpi_get_devices+0x56/0x6c
[    0.791002]  [<ffffffff8150bc9f>] acpi_get_devices+0x56/0x6c
[    0.791002]  [<ffffffff82314bcf>] ? ispnpidacpi+0x84/0x84
[    0.791002]  [<ffffffff82314bcf>] ? ispnpidacpi+0x84/0x84
[    0.791002]  [<ffffffff82314ded>] ? pnpacpi_add_device_handler+0x21e/0x2=
1e
[    0.791002]  [<ffffffff82314ded>] ? pnpacpi_add_device_handler+0x21e/0x2=
1e
[    0.791002]  [<ffffffff82314ded>] ? pnpacpi_add_device_handler+0x21e/0x2=
1e
[    0.791002]  [<ffffffff82314ded>] ? pnpacpi_add_device_handler+0x21e/0x2=
1e
[    0.791002]  [<ffffffff82314e3f>] pnpacpi_init+0x52/0x74
[    0.791002]  [<ffffffff82314e3f>] pnpacpi_init+0x52/0x74
[    0.791002]  [<ffffffff822e8114>] do_one_initcall+0x18e/0x1a3
[    0.791002]  [<ffffffff822e8114>] do_one_initcall+0x18e/0x1a3
[    0.791002]  [<ffffffff822e8243>] kernel_init_freeable+0x11a/0x1a2
[    0.791002]  [<ffffffff822e8243>] kernel_init_freeable+0x11a/0x1a2
[    0.791002]  [<ffffffff81a5312d>] ? rest_init+0xc1/0xc1
[    0.791002]  [<ffffffff81a5312d>] ? rest_init+0xc1/0xc1
[    0.791002]  [<ffffffff81a53136>] kernel_init+0x9/0xd5
[    0.791002]  [<ffffffff81a53136>] kernel_init+0x9/0xd5
[    0.791002]  [<ffffffff81a6363c>] ret_from_fork+0x7c/0xb0
[    0.791002]  [<ffffffff81a6363c>] ret_from_fork+0x7c/0xb0
[    0.791002]  [<ffffffff81a5312d>] ? rest_init+0xc1/0xc1
[    0.791002]  [<ffffffff81a5312d>] ? rest_init+0xc1/0xc1
[    0.791002] ---[ end trace 5517bfb60b8a8dda ]---
[    0.791002] ---[ end trace 5517bfb60b8a8dda ]---
[    0.961190] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.961190] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.973392] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.973392] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.975785] pnp 00:03: [dma 2]
[    0.975785] pnp 00:03: [dma 2]
[    0.976834] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.976834] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.978925] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.978925] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.981445] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.981445] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.983538] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.983538] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.986020] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.986020] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.988016] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.988016] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.990400] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.990400] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.993052] pnp: PnP ACPI: found 7 devices
[    0.993052] pnp: PnP ACPI: found 7 devices
[    1.000672] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.000672] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.002192] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.002192] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.003932] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.003932] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.005782] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.005782] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.007596] NET: Registered protocol family 1
[    1.007596] NET: Registered protocol family 1
[    1.008779] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.008779] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.010554] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.010554] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.012283] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.012283] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.014041] pci 0000:00:02.0: Video device with shadowed ROM
[    1.014041] pci 0000:00:02.0: Video device with shadowed ROM
[    1.015551] PCI: CLS 0 bytes, default 64
[    1.015551] PCI: CLS 0 bytes, default 64
[    1.017094] Unpacking initramfs...
[    1.017094] Unpacking initramfs...
[    1.229994] debug: unmapping init [mem 0xffff880013ce6000-0xffff880013fe=
ffff]
[    1.229994] debug: unmapping init [mem 0xffff880013ce6000-0xffff880013fe=
ffff]
[    1.246559] cryptomgr_test (26) used greatest stack depth: 14624 bytes l=
eft
[    1.246559] cryptomgr_test (26) used greatest stack depth: 14624 bytes l=
eft
[    1.252821] AVX version of gcm_enc/dec engaged.
[    1.252821] AVX version of gcm_enc/dec engaged.
[    1.254290] AES CTR mode by8 optimization enabled
[    1.254290] AES CTR mode by8 optimization enabled
[    1.257411] sha1_ssse3: Using AVX optimized SHA-1 implementation
[    1.257411] sha1_ssse3: Using AVX optimized SHA-1 implementation
[    1.259262] sha256_ssse3: Using AVX optimized SHA-256 implementation
[    1.259262] sha256_ssse3: Using AVX optimized SHA-256 implementation
[    1.261397] sha512_ssse3: Using AVX optimized SHA-512 implementation
[    1.261397] sha512_ssse3: Using AVX optimized SHA-512 implementation
[    1.268162] AVX2 instructions are not detected.
[    1.268162] AVX2 instructions are not detected.
[    1.269479] rcu-torture:--- Start of test: nreaders=3D1 nfakewriters=3D4=
 stat_interval=3D60 verbose=3D1 test_no_idle_hz=3D1 shuffle_interval=3D3 st=
utter=3D5 irqreader=3D1 fqs_duration=3D0 fqs_holdoff=3D0 fqs_stutter=3D3 te=
st_boost=3D1/0 test_boost_interval=3D7 test_boost_duration=3D4 shutdown_sec=
s=3D0 stall_cpu=3D0 stall_cpu_holdoff=3D10 n_barrier_cbs=3D0 onoff_interval=
=3D0 onoff_holdoff=3D0
[    1.269479] rcu-torture:--- Start of test: nreaders=3D1 nfakewriters=3D4=
 stat_interval=3D60 verbose=3D1 test_no_idle_hz=3D1 shuffle_interval=3D3 st=
utter=3D5 irqreader=3D1 fqs_duration=3D0 fqs_holdoff=3D0 fqs_stutter=3D3 te=
st_boost=3D1/0 test_boost_interval=3D7 test_boost_duration=3D4 shutdown_sec=
s=3D0 stall_cpu=3D0 stall_cpu_holdoff=3D10 n_barrier_cbs=3D0 onoff_interval=
=3D0 onoff_holdoff=3D0
[    1.278351] rcu-torture: Creating rcu_torture_writer task
[    1.278351] rcu-torture: Creating rcu_torture_writer task
[    1.279983] rcu-torture: Creating rcu_torture_fakewriter task
[    1.279983] rcu-torture: Creating rcu_torture_fakewriter task
[    1.281708] rcu-torture: rcu_torture_writer task started
[    1.281708] rcu-torture: rcu_torture_writer task started
[    1.283174] rcu-torture: Creating rcu_torture_fakewriter task
[    1.283174] rcu-torture: Creating rcu_torture_fakewriter task
[    1.285479] rcu-torture: rcu_torture_fakewriter task started
[    1.285479] rcu-torture: rcu_torture_fakewriter task started
[    1.287487] rcu-torture: Creating rcu_torture_fakewriter task
[    1.287487] rcu-torture: Creating rcu_torture_fakewriter task
[    1.289029] rcu-torture: rcu_torture_fakewriter task started
[    1.289029] rcu-torture: rcu_torture_fakewriter task started
[    1.290831] rcu-torture: Creating rcu_torture_fakewriter task
[    1.290831] rcu-torture: Creating rcu_torture_fakewriter task
[    1.292575] rcu-torture: rcu_torture_fakewriter task started
[    1.292575] rcu-torture: rcu_torture_fakewriter task started
[    1.294348] rcu-torture: Creating rcu_torture_reader task
[    1.294348] rcu-torture: Creating rcu_torture_reader task
[    1.295986] rcu-torture: rcu_torture_fakewriter task started
[    1.295986] rcu-torture: rcu_torture_fakewriter task started
[    1.297574] rcu-torture: Creating rcu_torture_stats task
[    1.297574] rcu-torture: Creating rcu_torture_stats task
[    1.298989] rcu-torture: rcu_torture_reader task started
[    1.298989] rcu-torture: rcu_torture_reader task started
[    1.300675] rcu-torture: Creating torture_shuffle task
[    1.300675] rcu-torture: Creating torture_shuffle task
[    1.302239] rcu-torture: rcu_torture_stats task started
[    1.302239] rcu-torture: rcu_torture_stats task started
[    1.303778] rcu-torture: Creating torture_stutter task
[    1.303778] rcu-torture: Creating torture_stutter task
[    1.305149] rcu-torture: torture_shuffle task started
[    1.305149] rcu-torture: torture_shuffle task started
[    1.306557] rcu-torture: Creating rcu_torture_cbflood task
[    1.306557] rcu-torture: Creating rcu_torture_cbflood task
[    1.308702] rcu-torture: torture_stutter task started
[    1.308702] rcu-torture: torture_stutter task started
[    1.311093] futex hash table entries: 16 (order: -1, 2048 bytes)
[    1.311093] futex hash table entries: 16 (order: -1, 2048 bytes)
[    1.313785] rcu-torture: rcu_torture_cbflood task started
[    1.313785] rcu-torture: rcu_torture_cbflood task started
[    1.330938] VFS: Disk quotas dquot_6.5.2
[    1.330938] VFS: Disk quotas dquot_6.5.2
[    1.332409] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.332409] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.338891] ntfs: driver 2.1.31 [Flags: R/O].
[    1.338891] ntfs: driver 2.1.31 [Flags: R/O].
[    1.340824] efs: 1.0a - http://aeschi.ch.eu.org/efs/
[    1.340824] efs: 1.0a - http://aeschi.ch.eu.org/efs/
[    1.345165] romfs: ROMFS MTD (C) 2007 Red Hat, Inc.
[    1.345165] romfs: ROMFS MTD (C) 2007 Red Hat, Inc.
[    1.347042] qnx6: QNX6 filesystem 1.0.0 registered.
[    1.347042] qnx6: QNX6 filesystem 1.0.0 registered.
[    1.348736] fuse init (API version 7.23)
[    1.348736] fuse init (API version 7.23)
[    1.350984] JFS: nTxBlock =3D 2202, nTxLock =3D 17622
[    1.350984] JFS: nTxBlock =3D 2202, nTxLock =3D 17622
[    1.365645] SGI XFS with ACLs, security attributes, no debug enabled
[    1.365645] SGI XFS with ACLs, security attributes, no debug enabled
[    1.369766] befs: version: 0.9.3
[    1.369766] befs: version: 0.9.3
[    1.372873] gfs2: GFS2 installed
[    1.372873] gfs2: GFS2 installed
[    1.378097] msgmni has been set to 550
[    1.378097] msgmni has been set to 550
[    1.379289] Key type big_key registered
[    1.379289] Key type big_key registered
[    1.393389] cryptomgr_test (167) used greatest stack depth: 14432 bytes =
left
[    1.393389] cryptomgr_test (167) used greatest stack depth: 14432 bytes =
left
[    1.402983] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    1.402983] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    1.410889] io scheduler noop registered
[    1.410889] io scheduler noop registered
[    1.412410] io scheduler cfq registered (default)
[    1.412410] io scheduler cfq registered (default)
[    1.413861] test_string_helpers: Running tests...
[    1.413861] test_string_helpers: Running tests...
[    1.415783] test_firmware: interface ready
[    1.415783] test_firmware: interface ready
[    1.417646] crc32: CRC_LE_BITS =3D 32, CRC_BE BITS =3D 32
[    1.417646] crc32: CRC_LE_BITS =3D 32, CRC_BE BITS =3D 32
[    1.419192] crc32: self tests passed, processed 225944 bytes in 261909 n=
sec
[    1.419192] crc32: self tests passed, processed 225944 bytes in 261909 n=
sec
[    1.435222] crc32c: CRC_LE_BITS =3D 32
[    1.435222] crc32c: CRC_LE_BITS =3D 32
[    1.436538] crc32c: self tests passed, processed 225944 bytes in 131761 =
nsec
[    1.436538] crc32c: self tests passed, processed 225944 bytes in 131761 =
nsec
[    1.457297] crc32_combine: 8373 self tests passed
[    1.457297] crc32_combine: 8373 self tests passed
[    1.476859] crc32c_combine: 8373 self tests passed
[    1.476859] crc32c_combine: 8373 self tests passed
[    1.478890] xz_dec_test: module loaded
[    1.478890] xz_dec_test: module loaded
[    1.480030] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
250 0' and write .xz files to it.
[    1.480030] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
250 0' and write .xz files to it.
[    1.483086] glob: 64 self-tests passed, 0 failed
[    1.483086] glob: 64 self-tests passed, 0 failed
[    1.484333] rbtree testing
[    1.484333] rbtree testing -> 13460 cycles
 -> 13460 cycles
[    2.054168] augmented rbtree testing
[    2.054168] augmented rbtree testing

[    2.233443] tsc: Refined TSC clocksource calibration: 2693.501 MHz
[    2.233443] tsc: Refined TSC clocksource calibration: 2693.501 MHz
[    3.127152]  -> 28874 cycles
[    3.127152]  -> 28874 cycles
[    3.226554] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.226554] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.228066] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.228066] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.230599] nvidiafb_setup START
[    3.230599] nvidiafb_setup START
[    3.231602] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    3.231602] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    3.243790] no IO addresses supplied
[    3.243790] no IO addresses supplied
[    3.244925] hgafb: HGA card not detected.
[    3.244925] hgafb: HGA card not detected.
[    3.245973] hgafb: probe of hgafb.0 failed with error -22
[    3.245973] hgafb: probe of hgafb.0 failed with error -22
[    3.247651] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    3.247651] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    3.254960] hv_vmbus: registering driver hyperv_fb
[    3.254960] hv_vmbus: registering driver hyperv_fb
[    3.263736] ipmi message handler version 39.2
[    3.263736] ipmi message handler version 39.2
[    3.264880] ipmi device interface
[    3.264880] ipmi device interface
[    3.265830] IPMI System Interface driver.
[    3.265830] IPMI System Interface driver.
[    3.266975] ipmi_si: Adding default-specified kcs state machine
[    3.266975] ipmi_si: Adding default-specified kcs state machine

[    3.268515] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    3.268515] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    3.271112] ipmi_si: Interface detection failed
[    3.271112] ipmi_si: Interface detection failed
[    3.272284] ipmi_si: Adding default-specified smic state machine
[    3.272284] ipmi_si: Adding default-specified smic state machine

[    3.283895] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    3.283895] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    3.286450] ipmi_si: Interface detection failed
[    3.286450] ipmi_si: Interface detection failed
[    3.287629] ipmi_si: Adding default-specified bt state machine
[    3.287629] ipmi_si: Adding default-specified bt state machine

[    3.289131] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    3.289131] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    3.291650] ipmi_si: Interface detection failed
[    3.291650] ipmi_si: Interface detection failed
[    3.292944] ipmi_si: Unable to find any System Interface(s)
[    3.292944] ipmi_si: Unable to find any System Interface(s)
[    3.304419] IPMI Watchdog: driver initialized
[    3.304419] IPMI Watchdog: driver initialized
[    3.306814] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    3.306814] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    3.308719] ACPI: Power Button [PWRF]
[    3.308719] ACPI: Power Button [PWRF]
[    3.310053] button: probe of LNXPWRBN:00 failed with error -22
[    3.310053] button: probe of LNXPWRBN:00 failed with error -22
[    3.311597] ERST DBG: ERST support is disabled.
[    3.311597] ERST DBG: ERST support is disabled.
[    3.381890] HDLC line discipline maxframe=3D4096
[    3.381890] HDLC line discipline maxframe=3D4096
[    3.383046] N_HDLC line discipline registered.
[    3.383046] N_HDLC line discipline registered.
[    3.384230] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.384230] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.433669] serial 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 1=
15200) is a 16550A
[    3.433669] serial 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 1=
15200) is a 16550A
[    3.437981] serial: Freescale lpuart driver
[    3.437981] serial: Freescale lpuart driver
[    3.439195] Cyclades driver 2.6
[    3.439195] Cyclades driver 2.6
[    3.440175] MOXA Smartio/Industio family driver version 2.0.5
[    3.440175] MOXA Smartio/Industio family driver version 2.0.5
[    3.441726] Initializing Nozomi driver 2.1d
[    3.441726] Initializing Nozomi driver 2.1d
[    3.442907] SyncLink GT
[    3.442907] SyncLink GT
[    3.453614] SyncLink GT, tty major#242
[    3.453614] SyncLink GT, tty major#242
[    3.454632] SyncLink GT no devices found
[    3.454632] SyncLink GT no devices found
[    3.455660] SyncLink MultiPort driver $Revision: 4.38 $
[    3.455660] SyncLink MultiPort driver $Revision: 4.38 $
[    3.479536] SyncLink MultiPort driver $Revision: 4.38 $, tty major#241
[    3.479536] SyncLink MultiPort driver $Revision: 4.38 $, tty major#241
[    3.481958] ppdev: user-space parallel port driver
[    3.481958] ppdev: user-space parallel port driver
[    3.483208] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    3.483208] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    3.484605] smapi::smapi_init, ERROR invalid usSmapiID
[    3.484605] smapi::smapi_init, ERROR invalid usSmapiID
[    3.485923] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    3.485923] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    3.488321] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    3.488321] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    3.490192] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    3.490192] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    3.491816] Linux agpgart interface v0.103
[    3.491816] Linux agpgart interface v0.103
[    3.493677] intelfb: intelfb_init
[    3.493677] intelfb: intelfb_init
[    3.494538] intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855=
GM/865G/915G/915GM/945G/945GM/945GME/965G/965GM chipsets
[    3.494538] intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855=
GM/865G/915G/915GM/945G/945GM/945GME/965G/965GM chipsets
[    3.497483] intelfb: Version 0.9.6
[    3.497483] intelfb: Version 0.9.6
[    3.498360] intelfb: intelfb_setup
[    3.498360] intelfb: intelfb_setup
[    3.499221] intelfb: no options
[    3.499221] intelfb: no options
[    3.500176] parport_pc 00:04: reported by Plug and Play ACPI
[    3.500176] parport_pc 00:04: reported by Plug and Play ACPI
[    3.501785] parport0: PC-style at 0x378
[    3.501785] parport0: PC-style at 0x378, irq 7, irq 7 [ [PCSPPPCSPP,TRIS=
TATE,TRISTATE]
]
[    3.588257] loop: module loaded
[    3.588257] loop: module loaded
[    3.589614] skd:  v2.2.1-b0260 loaded
[    3.589614] skd:  v2.2.1-b0260 loaded
[    3.590704] mtip32xx Version 1.3.1
[    3.590704] mtip32xx Version 1.3.1
[    3.591900] lkdtm: No crash points registered, enable through debugfs
[    3.591900] lkdtm: No crash points registered, enable through debugfs
[    3.593695] Phantom Linux Driver, version n0.9.8, init OK
[    3.593695] Phantom Linux Driver, version n0.9.8, init OK
[    3.595351] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    3.595351] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    3.597382] Guest personality initialized and is inactive
[    3.597382] Guest personality initialized and is inactive
[    3.599061] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D61)
[    3.599061] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D61)
[    3.600806] Initialized host personality
[    3.600806] Initialized host personality
[    3.602575] Uniform Multi-Platform E-IDE driver
[    3.602575] Uniform Multi-Platform E-IDE driver
[    3.614494] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[    3.614494] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[    3.616319] piix 0000:00:01.1: not 100% native mode: will probe irqs lat=
er
[    3.616319] piix 0000:00:01.1: not 100% native mode: will probe irqs lat=
er
[    3.618601]     ide0: BM-DMA at 0xc040-0xc047
[    3.618601]     ide0: BM-DMA at 0xc040-0xc047
[    3.619765]     ide1: BM-DMA at 0xc048-0xc04f
[    3.619765]     ide1: BM-DMA at 0xc048-0xc04f
[    3.620915] Probing IDE interface ide0...
[    3.620915] Probing IDE interface ide0...
[    4.173617] Probing IDE interface ide1...
[    4.173617] Probing IDE interface ide1...
[    4.876833] hdc: QEMU DVD-ROM, ATAPI=20
[    4.876833] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROMCD/DVD-ROM drive
 drive
[    5.516941] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[    5.516941] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[    5.519289] hdc: MWDMA2 mode selected
[    5.519289] hdc: MWDMA2 mode selected
[    5.520875] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    5.520875] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14

[    5.522582] ide1 at 0x170-0x177,0x376 on irq 15
[    5.522582] ide1 at 0x170-0x177,0x376 on irq 15

[    5.525713] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[    5.525713] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[    5.529140] ide-gd driver 1.18
[    5.529140] ide-gd driver 1.18
[    5.530324] ide-cd driver 5.00
[    5.530324] ide-cd driver 5.00
[    5.531876] ide-cd: hdc: ATAPI
[    5.531876] ide-cd: hdc: ATAPI 4X 4X DVD-ROM DVD-ROM drive drive, 512kB =
Cache
, 512kB Cache
[    5.543976] cdrom: Uniform CD-ROM driver Revision: 3.20
[    5.543976] cdrom: Uniform CD-ROM driver Revision: 3.20
[    5.548587] rdac: device handler registered
[    5.548587] rdac: device handler registered
[    5.550768] emc: device handler registered
[    5.550768] emc: device handler registered
[    5.552484] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    5.552484] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    5.564855] isci: Intel(R) C600 SAS Controller Driver - version 1.2.0
[    5.564855] isci: Intel(R) C600 SAS Controller Driver - version 1.2.0
[    5.566989] scsi: <fdomain> Detection failed (no card)
[    5.566989] scsi: <fdomain> Detection failed (no card)
[    5.568751] DC390: clustering now enabled by default. If you get problem=
s load
[    5.568751] DC390: clustering now enabled by default. If you get problem=
s load
[    5.570985]        with "disable_clustering=3D1" and report to maintaine=
rs
[    5.570985]        with "disable_clustering=3D1" and report to maintaine=
rs
[    5.574013] megasas: 06.805.06.00-rc1 Thu. Sep. 4 17:00:00 PDT 2014
[    5.574013] megasas: 06.805.06.00-rc1 Thu. Sep. 4 17:00:00 PDT 2014
[    5.576044] mpt2sas version 18.100.00.00 loaded
[    5.576044] mpt2sas version 18.100.00.00 loaded
[    5.577688] mpt3sas version 04.100.00.00 loaded
[    5.577688] mpt3sas version 04.100.00.00 loaded
[    5.579475] 3ware Storage Controller device driver for Linux v1.26.02.00=
3.
[    5.579475] 3ware Storage Controller device driver for Linux v1.26.02.00=
3.
[    5.581646] LSI 3ware SAS/SATA-RAID Controller device driver for Linux v=
3.26.02.000.
[    5.581646] LSI 3ware SAS/SATA-RAID Controller device driver for Linux v=
3.26.02.000.
[    5.584136] ppa: Version 2.07 (for Linux 2.4.x)
[    5.584136] ppa: Version 2.07 (for Linux 2.4.x)
[    5.587940] ipr: IBM Power RAID SCSI Device Driver version: 2.6.0 (Novem=
ber 16, 2012)
[    5.587940] ipr: IBM Power RAID SCSI Device Driver version: 2.6.0 (Novem=
ber 16, 2012)
[    5.590429] stex: Promise SuperTrak EX Driver version: 4.6.0000.4
[    5.590429] stex: Promise SuperTrak EX Driver version: 4.6.0000.4
[    5.592567] esas2r: driver will not be loaded because no ATTO esas2r dev=
ices were found
[    5.592567] esas2r: driver will not be loaded because no ATTO esas2r dev=
ices were found
[    5.596309] hv_vmbus: registering driver hv_storvsc
[    5.596309] hv_vmbus: registering driver hv_storvsc
[    5.598016] SCSI Media Changer driver v0.25=20
[    5.598016] SCSI Media Changer driver v0.25=20
[    5.612555] scsi_debug: host protection
[    5.612555] scsi_debug: host protection
[    5.613860] scsi host0: scsi_debug, version 1.84 [20140706], dev_size_mb=
=3D8, opts=3D0x0
[    5.613860] scsi host0: scsi_debug, version 1.84 [20140706], dev_size_mb=
=3D8, opts=3D0x0
[    5.619579] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       01=
84 PQ: 0 ANSI: 6
[    5.619579] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       01=
84 PQ: 0 ANSI: 6
[    5.623624] SSFDC read-only Flash Translation layer
[    5.623624] SSFDC read-only Flash Translation layer
[    5.625217] scsi 0:0:0:0: Attached scsi generic sg0 type 0
[    5.625217] scsi 0:0:0:0: Attached scsi generic sg0 type 0
[    5.664062] No valid DiskOnChip devices found
[    5.664062] No valid DiskOnChip devices found
[    5.665851] parport_pc 00:04: registered master spi32766 (dynamic)
[    5.665851] parport_pc 00:04: registered master spi32766 (dynamic)
[    5.667973] spi spi32766.0: spi_bitbang_setup, 166 nsec/bit
[    5.667973] spi spi32766.0: spi_bitbang_setup, 166 nsec/bit
[    5.669702] spi spi32766.0: setup mode 0, 3wire, 8 bits/w, 6000000 Hz ma=
x --> 0
[    5.669702] spi spi32766.0: setup mode 0, 3wire, 8 bits/w, 6000000 Hz ma=
x --> 0
[    5.672067] parport_pc 00:04: registered child spi32766.0
[    5.672067] parport_pc 00:04: registered child spi32766.0
[    5.673904] spi spi32766.0: spidev_lm70 at spi32766.0
[    5.673904] spi spi32766.0: spidev_lm70 at spi32766.0
[    5.675587] HSI/SSI char device loaded
[    5.675587] HSI/SSI char device loaded
[    5.676787] Fusion MPT base driver 3.04.20
[    5.676787] Fusion MPT base driver 3.04.20
[    5.678028] Copyright (c) 1999-2008 LSI Corporation
[    5.678028] Copyright (c) 1999-2008 LSI Corporation
[    5.679541] Fusion MPT SPI Host driver 3.04.20
[    5.679541] Fusion MPT SPI Host driver 3.04.20
[    5.681957] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    5.681957] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    5.687852] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.687852] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.689561] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.689561] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.691999] mousedev: PS/2 mouse device common for all mice
[    5.691999] mousedev: PS/2 mouse device common for all mice
[    5.694537] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    5.694537] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    5.697729] rtc_cmos 00:00: RTC can wake from S4
[    5.697729] rtc_cmos 00:00: RTC can wake from S4
[    5.699481] rtc (null): alarm rollover: day
[    5.699481] rtc (null): alarm rollover: day
[    5.704862] rtc rtc0: rtc_cmos: dev (254:0)
[    5.704862] rtc rtc0: rtc_cmos: dev (254:0)
[    5.706149] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    5.706149] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    5.708593] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    5.708593] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    5.712247] i2c /dev entries driver
[    5.712247] i2c /dev entries driver
[    5.713883] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[    5.713883] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[    5.727307] i2c-parport: adapter type unspecified
[    5.727307] i2c-parport: adapter type unspecified
[    5.728901] i2c-parport-light: adapter type unspecified
[    5.728901] i2c-parport-light: adapter type unspecified
[    5.732815] m2m-testdev m2m-testdev.0: Device registered as /dev/video0
[    5.732815] m2m-testdev m2m-testdev.0: Device registered as /dev/video0
[    5.735353] pps_ldisc: PPS line discipline registered
[    5.735353] pps_ldisc: PPS line discipline registered
[    5.737101] pps_parport: parallel port PPS client
[    5.737101] pps_parport: parallel port PPS client
[    5.738688] parport0: no more devices allowed
[    5.738688] parport0: no more devices allowed
[    5.743755] pps_parport: couldn't register with parport0
[    5.743755] pps_parport: couldn't register with parport0
[    5.745581] Driver for 1-wire Dallas network protocol.
[    5.745581] Driver for 1-wire Dallas network protocol.
[    5.747532] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    5.747532] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    5.749624] 1-Wire driver for the DS2760 battery monitor chip - (c) 2004=
-2005, Szabolcs Gyurko
[    5.749624] 1-Wire driver for the DS2760 battery monitor chip - (c) 2004=
-2005, Szabolcs Gyurko
[    5.752820] power_supply test_ac: uevent
[    5.752820] power_supply test_ac: uevent
[    5.754174] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    5.754174] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    5.756060] power_supply test_ac: prop ONLINE=3D1
[    5.756060] power_supply test_ac: prop ONLINE=3D1
[    5.757628] power_supply test_ac: power_supply_changed
[    5.757628] power_supply test_ac: power_supply_changed
[    5.759420] power_supply test_ac: power_supply_changed_work
[    5.759420] power_supply test_ac: power_supply_changed_work
[    5.761330] power_supply test_ac: uevent
[    5.761330] power_supply test_ac: uevent
[    5.762651] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    5.762651] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    5.764747] power_supply test_battery: uevent
[    5.764747] power_supply test_battery: uevent
[    5.766221] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    5.766221] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    5.768430] power_supply test_ac: prop ONLINE=3D1
[    5.768430] power_supply test_ac: prop ONLINE=3D1
[    5.769978] power_supply test_battery: prop STATUS=3DDischarging
[    5.769978] power_supply test_battery: prop STATUS=3DDischarging
[    5.771968] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    5.771968] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    5.773896] power_supply test_battery: prop HEALTH=3DGood
[    5.773896] power_supply test_battery: prop HEALTH=3DGood
[    5.775674] power_supply test_battery: prop PRESENT=3D1
[    5.775674] power_supply test_battery: prop PRESENT=3D1
[    5.777430] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    5.777430] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    5.779361] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    5.779361] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    5.781456] power_supply test_battery: prop CHARGE_FULL=3D100
[    5.781456] power_supply test_battery: prop CHARGE_FULL=3D100
[    5.783357] power_supply test_battery: prop CHARGE_NOW=3D50
[    5.783357] power_supply test_battery: prop CHARGE_NOW=3D50
[    5.785165] power_supply test_battery: prop CAPACITY=3D50
[    5.785165] power_supply test_battery: prop CAPACITY=3D50
[    5.786939] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    5.786939] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    5.788969] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    5.788969] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    5.791059] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    5.791059] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    5.793104] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    5.793104] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    5.795234] power_supply test_battery: prop MANUFACTURER=3DLinux
[    5.795234] power_supply test_battery: prop MANUFACTURER=3DLinux
[    5.797199] power_supply test_battery: prop SERIAL_NUMBER=3D3.18.0-rc2-g=
6067dc5
[    5.797199] power_supply test_battery: prop SERIAL_NUMBER=3D3.18.0-rc2-g=
6067dc5
[    5.799595] power_supply test_battery: prop TEMP=3D26
[    5.799595] power_supply test_battery: prop TEMP=3D26
[    5.801249] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    5.801249] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    5.803599] power_supply test_battery: power_supply_changed
[    5.803599] power_supply test_battery: power_supply_changed
[    5.805510] power_supply test_battery: power_supply_changed_work
[    5.805510] power_supply test_battery: power_supply_changed_work
[    5.807561] power_supply test_battery: uevent
[    5.807561] power_supply test_battery: uevent
[    5.809017] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    5.809017] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    5.811314] power_supply test_usb: uevent
[    5.811314] power_supply test_usb: uevent
[    5.812661] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    5.812661] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    5.814633] power_supply test_battery: prop STATUS=3DDischarging
[    5.814633] power_supply test_battery: prop STATUS=3DDischarging
[    5.816583] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    5.816583] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    5.818519] power_supply test_usb: prop ONLINE=3D1
[    5.818519] power_supply test_usb: prop ONLINE=3D1
[    5.820100] power_supply test_usb: power_supply_changed
[    5.820100] power_supply test_usb: power_supply_changed
[    5.822727] power_supply test_battery: prop HEALTH=3DGood
[    5.822727] power_supply test_battery: prop HEALTH=3DGood
[    5.824520] power_supply test_battery: prop PRESENT=3D1
[    5.824520] power_supply test_battery: prop PRESENT=3D1
[    5.826212] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    5.826212] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    5.828249] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    5.828249] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    5.830339] power_supply test_battery: prop CHARGE_FULL=3D100
[    5.830339] power_supply test_battery: prop CHARGE_FULL=3D100
[    5.832205] power_supply test_battery: prop CHARGE_NOW=3D50
[    5.832205] power_supply test_battery: prop CHARGE_NOW=3D50
[    5.834137] power_supply test_battery: prop CAPACITY=3D50
[    5.834137] power_supply test_battery: prop CAPACITY=3D50
[    5.835889] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    5.835889] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    5.837957] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    5.837957] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    5.840133] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    5.840133] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    5.842172] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    5.842172] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    5.844308] power_supply test_battery: prop MANUFACTURER=3DLinux
[    5.844308] power_supply test_battery: prop MANUFACTURER=3DLinux
[    5.846244] power_supply test_battery: prop SERIAL_NUMBER=3D3.18.0-rc2-g=
6067dc5
[    5.846244] power_supply test_battery: prop SERIAL_NUMBER=3D3.18.0-rc2-g=
6067dc5
[    5.848762] power_supply test_battery: prop TEMP=3D26
[    5.848762] power_supply test_battery: prop TEMP=3D26
[    5.850418] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    5.850418] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    5.852345] power_supply test_usb: power_supply_changed_work
[    5.852345] power_supply test_usb: power_supply_changed_work
[    5.854366] power_supply test_usb: uevent
[    5.854366] power_supply test_usb: uevent
[    5.855710] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    5.855710] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    5.857659] power_supply test_usb: prop ONLINE=3D1
[    5.857659] power_supply test_usb: prop ONLINE=3D1
[    6.308347] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[    6.308347] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[   13.073592] EDAC DEBUG: i7300_init:=20
[   13.073592] EDAC DEBUG: i7300_init:=20
[   13.074853] EDAC DEBUG: i3000_init: i3000 pci_get_device fail
[   13.074853] EDAC DEBUG: i3000_init: i3000 pci_get_device fail
[   13.076661] EDAC DEBUG: i3200_init: i3200 pci_get_device fail
[   13.076661] EDAC DEBUG: i3200_init: i3200 pci_get_device fail
[   13.080098] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[   13.080098] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[   13.082435] No iBFT detected.
[   13.082435] No iBFT detected.
[   13.083977]  fake-fmc-carrier: mezzanine 0
[   13.083977]  fake-fmc-carrier: mezzanine 0
[   13.085262]       Manufacturer: fake-vendor
[   13.085262]       Manufacturer: fake-vendor
[   13.086514]       Product name: fake-design-for-testing
[   13.086514]       Product name: fake-design-for-testing
[   13.088219] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   13.088219] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   13.094414] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eep=
rom: no busid passed, refusing all cards
[   13.094414] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eep=
rom: no busid passed, refusing all cards
[   13.104585] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   13.104585] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   13.106934] fmc_chardev fake-design-for-testing-f001: Created misc devic=
e "fake-design-for-testing-f001"
[   13.106934] fmc_chardev fake-design-for-testing-f001: Created misc devic=
e "fake-design-for-testing-f001"
[   13.125885] no UART detected at 0x1
[   13.125885] no UART detected at 0x1
[   13.127416] parport0: no more devices allowed
[   13.127416] parport0: no more devices allowed
[   13.128776] snd_mts64: probe of snd_mts64.0 failed with error -5
[   13.128776] snd_mts64: probe of snd_mts64.0 failed with error -5
[   13.139044]=20
[   13.139044] printing PIC contents
[   13.139044]=20
[   13.139044] printing PIC contents
[   13.140532] ... PIC  IMR: ffff
[   13.140532] ... PIC  IMR: ffff
[   13.143847] ... PIC  IRR: 9113
[   13.143847] ... PIC  IRR: 9113
[   13.163527] ... PIC  ISR: 0000
[   13.163527] ... PIC  ISR: 0000
[   13.164458] ... PIC ELCR: 0c00
[   13.164458] ... PIC ELCR: 0c00
[   13.166198] printing local APIC contents on CPU#0/0:
[   13.166198] printing local APIC contents on CPU#0/0:
[   13.166835] ... APIC ID:      00000000 (0)
[   13.166835] ... APIC ID:      00000000 (0)
[   13.166835] ... APIC VERSION: 01050014
[   13.166835] ... APIC VERSION: 01050014
[   13.166835] ... APIC TASKPRI: 00000000 (00)
[   13.166835] ... APIC TASKPRI: 00000000 (00)
[   13.166835] ... APIC PROCPRI: 00000000
[   13.166835] ... APIC PROCPRI: 00000000
[   13.166835] ... APIC LDR: 01000000
[   13.166835] ... APIC LDR: 01000000
[   13.166835] ... APIC DFR: ffffffff
[   13.166835] ... APIC DFR: ffffffff
[   13.166835] ... APIC SPIV: 000001ff
[   13.166835] ... APIC SPIV: 000001ff
[   13.166835] ... APIC ISR field:
[   13.166835] ... APIC ISR field:
[   13.166835] 00000000
[   13.166835] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[   13.166835] ... APIC TMR field:
[   13.166835] ... APIC TMR field:
[   13.166835] 00000000
[   13.166835] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[   13.166835] ... APIC IRR field:
[   13.166835] ... APIC IRR field:
[   13.166835] 00000000
[   13.166835] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000800000008000

[   13.166835] ... APIC ESR: 00000000
[   13.166835] ... APIC ESR: 00000000
[   13.166835] ... APIC ICR: 00000831
[   13.166835] ... APIC ICR: 00000831
[   13.166835] ... APIC ICR2: 01000000
[   13.166835] ... APIC ICR2: 01000000
[   13.166835] ... APIC LVTT: 000400ef
[   13.166835] ... APIC LVTT: 000400ef
[   13.166835] ... APIC LVTPC: 00010000
[   13.166835] ... APIC LVTPC: 00010000
[   13.166835] ... APIC LVT0: 00010700
[   13.166835] ... APIC LVT0: 00010700
[   13.166835] ... APIC LVT1: 00000400
[   13.166835] ... APIC LVT1: 00000400
[   13.166835] ... APIC LVTERR: 000000fe
[   13.166835] ... APIC LVTERR: 000000fe
[   13.166835] ... APIC TMICT: 00000000
[   13.166835] ... APIC TMICT: 00000000
[   13.166835] ... APIC TMCCT: 00000000
[   13.166835] ... APIC TMCCT: 00000000
[   13.166835] ... APIC TDCR: 00000000
[   13.166835] ... APIC TDCR: 00000000
[   13.166835]=20
[   13.166835]=20
[   13.199083] number of MP IRQ sources: 15.
[   13.199083] number of MP IRQ sources: 15.
[   13.200303] number of IO-APIC #0 registers: 24.
[   13.200303] number of IO-APIC #0 registers: 24.
[   13.201671] testing the IO APIC.......................
[   13.201671] testing the IO APIC.......................
[   13.203213] IO APIC #0......
[   13.203213] IO APIC #0......
[   13.204216] .... register #00: 00000000
[   13.204216] .... register #00: 00000000
[   13.205365] .......    : physical APIC id: 00
[   13.205365] .......    : physical APIC id: 00
[   13.206648] .......    : Delivery Type: 0
[   13.206648] .......    : Delivery Type: 0
[   13.207851] .......    : LTS          : 0
[   13.207851] .......    : LTS          : 0
[   13.209031] .... register #01: 00170011
[   13.209031] .... register #01: 00170011
[   13.210205] .......     : max redirection entries: 17
[   13.210205] .......     : max redirection entries: 17
[   13.211700] .......     : PRQ implemented: 0
[   13.211700] .......     : PRQ implemented: 0
[   13.212967] .......     : IO APIC version: 11
[   13.212967] .......     : IO APIC version: 11
[   13.214292] .... register #02: 00000000
[   13.214292] .... register #02: 00000000
[   13.215439] .......     : arbitration: 00
[   13.215439] .......     : arbitration: 00
[   13.216630] .... IRQ redirection table:
[   13.216630] .... IRQ redirection table:
[   13.217821] 1    0    0   0   0    0    0    00
[   13.217821] 1    0    0   0   0    0    0    00
[   13.219182] 0    0    0   0   0    1    1    31
[   13.219182] 0    0    0   0   0    1    1    31
[   13.220631] 0    0    0   0   0    1    1    30
[   13.220631] 0    0    0   0   0    1    1    30
[   13.222010] 0    0    0   0   0    1    1    33
[   13.222010] 0    0    0   0   0    1    1    33
[   13.223431] 1    0    0   0   0    1    1    34
[   13.223431] 1    0    0   0   0    1    1    34
[   13.224801] 1    1    0   0   0    1    1    35
[   13.224801] 1    1    0   0   0    1    1    35
[   13.226166] 0    0    0   0   0    1    1    36
[   13.226166] 0    0    0   0   0    1    1    36
[   13.227592] 0    0    0   0   0    1    1    37
[   13.227592] 0    0    0   0   0    1    1    37
[   13.228952] 0    0    0   0   0    1    1    38
[   13.228952] 0    0    0   0   0    1    1    38
[   13.230377] 1    1    0   0   0    1    1    39
[   13.230377] 1    1    0   0   0    1    1    39
[   13.231779] 1    1    0   0   0    1    1    3A
[   13.231779] 1    1    0   0   0    1    1    3A
[   13.233446] 1    1    0   0   0    1    1    3B
[   13.233446] 1    1    0   0   0    1    1    3B
[   13.234824] 0    0    0   0   0    1    1    3C
[   13.234824] 0    0    0   0   0    1    1    3C
[   13.236185] 0    0    0   0   0    1    1    3D
[   13.236185] 0    0    0   0   0    1    1    3D
[   13.237585] 0    0    0   0   0    1    1    3E
[   13.237585] 0    0    0   0   0    1    1    3E
[   13.238977] 0    0    0   0   0    1    1    3F
[   13.238977] 0    0    0   0   0    1    1    3F
[   13.240621] 1    0    0   0   0    0    0    00
[   13.240621] 1    0    0   0   0    0    0    00
[   13.242020] 1    0    0   0   0    0    0    00
[   13.242020] 1    0    0   0   0    0    0    00
[   13.243447] 1    0    0   0   0    0    0    00
[   13.243447] 1    0    0   0   0    0    0    00
[   13.244839] 1    0    0   0   0    0    0    00
[   13.244839] 1    0    0   0   0    0    0    00
[   13.246374] 1    0    0   0   0    0    0    00
[   13.246374] 1    0    0   0   0    0    0    00
[   13.247765] 1    0    0   0   0    0    0    00
[   13.247765] 1    0    0   0   0    0    0    00
[   13.249365] 1    0    0   0   0    0    0    00
[   13.249365] 1    0    0   0   0    0    0    00
[   13.250743] 1    0    0   0   0    0    0    00
[   13.250743] 1    0    0   0   0    0    0    00
[   13.252101] IRQ to pin mappings:
[   13.252101] IRQ to pin mappings:
[   13.253069] IRQ0=20
[   13.253069] IRQ0 -> 0:2-> 0:2

[   13.253908] IRQ1=20
[   13.253908] IRQ1 -> 0:1-> 0:1

[   13.254911] IRQ3=20
[   13.254911] IRQ3 -> 0:3-> 0:3

[   13.255725] IRQ4=20
[   13.255725] IRQ4 -> 0:4-> 0:4

[   13.256536] IRQ5=20
[   13.256536] IRQ5 -> 0:5-> 0:5

[   13.257345] IRQ6=20
[   13.257345] IRQ6 -> 0:6-> 0:6

[   13.258200] IRQ7=20
[   13.258200] IRQ7 -> 0:7-> 0:7

[   13.258997] IRQ8=20
[   13.258997] IRQ8 -> 0:8-> 0:8

[   13.259783] IRQ9=20
[   13.259783] IRQ9 -> 0:9-> 0:9

[   13.260608] IRQ10=20
[   13.260608] IRQ10 -> 0:10-> 0:10

[   13.261445] IRQ11=20
[   13.261445] IRQ11 -> 0:11-> 0:11

[   13.262270] IRQ12=20
[   13.262270] IRQ12 -> 0:12-> 0:12

[   13.263111] IRQ13=20
[   13.263111] IRQ13 -> 0:13-> 0:13

[   13.263976] IRQ14=20
[   13.263976] IRQ14 -> 0:14-> 0:14

[   13.264962] IRQ15=20
[   13.264962] IRQ15 -> 0:15-> 0:15

[   13.265822] .................................... done.
[   13.265822] .................................... done.
[   13.268267] bootconsole [earlyser0] disabled
[   13.268267] bootconsole [earlyser0] disabled
[   13.275742] Btrfs loaded, assert=3Don, integrity-checker=3Don
[   13.277179] Key type trusted registered
[   13.278174] RIO: rio_register_scan for mport_id=3D-1
[   13.279014] cryptomgr_probe (202) used greatest stack depth: 13872 bytes=
 left
[   13.280900] ALSA device list:
[   13.281381]   #0: Dummy 1
[   13.281789]   #1: Loopback 1
[   13.282455]   #2: Virtual MIDI Card 1
[   13.283997] debug: unmapping init [mem 0xffffffff82114000-0xffffffff823b=
7fff]
[   13.300718] stty (208) used greatest stack depth: 13728 bytes left
/etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: not found
[   13.306313] S00fbsetup (209) used greatest stack depth: 13568 bytes left

Please wait: booting...
Starting udev
/etc/rcS.d/S03udev: line 72: can't create /proc/sys/kernel/hotplug: nonexis=
tent directory
error initializing inotify
error sending message: Connection refused
[   13.472114] power_supply test_ac: uevent
[   13.472694] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[   13.473619] power_supply test_ac: prop ONLINE=3D1
[   13.474301] power_supply test_battery: uevent
[   13.474899] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[   13.475763] power_supply test_battery: prop STATUS=3DDischarging
[   13.476553] power_supply test_battery: prop CHARGE_TYPE=3DFast
[   13.477352] power_supply test_battery: prop HEALTH=3DGood
[   13.478054] power_supply test_battery: prop PRESENT=3D1
[   13.478739] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[   13.479518] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[   13.480671] power_supply test_battery: prop CHARGE_FULL=3D100
[   13.481431] power_supply test_battery: prop CHARGE_NOW=3D50
[   13.482150] power_supply test_battery: prop CAPACITY=3D50
[   13.482864] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[   13.483726] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[   13.484561] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[   13.485380] power_supply test_battery: prop MODEL_NAME=3DTest battery
[   13.486214] power_supply test_battery: prop MANUFACTURER=3DLinux
[   13.487080] power_supply test_battery: prop SERIAL_NUMBER=3D3.18.0-rc2-g=
6067dc5
[   13.488039] power_supply test_battery: prop TEMP=3D26
[   13.488698] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[   13.489522] power_supply test_usb: uevent
[   13.490102] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[   13.490892] power_supply test_usb: prop ONLINE=3D1
error sending message: Connection refused
Starting Bootlog daemon: bootlogd: cannot find console device 4:64 under /d=
ev
bootlogd.
[   13.548139] gfs2: path_lookup on rootfs returned error -2
[   13.550058] mount (236) used greatest stack depth: 13552 bytes left
Configuring network interfaces... ifconfig: socket: Address family not supp=
orted by protocol
done.
hwclock: can't open '/dev/misc/rtc': No such file or directory
Running postinst /etc/rpm-postinsts/100...
[   61.303416] rcu-torture: rtc: ffffffff82e8a680 ver: 1 tfle: 0 rta: 1 rta=
f: 0 rtf: 0 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1 onoff: 0/0:0/0 =
-1,0:-1,0 0:0 (HZ=3D300) barrier: 0/0:0 cbflood: 1
[   61.306229] rcu-torture: Reader Pipe:  2 0 0 0 0 0 0 0 0 0 0
[   61.307467] rcu-torture: Reader Batch:  2 0 0 0 0 0 0 0 0 0 0
[   61.308649] rcu-torture: Free-Block Circulation:  0 0 0 0 0 0 0 0 0 0 0
[   82.823515] Unregister pv shared memory for cpu 0
[   82.824420] rcu-torture: Unscheduled system shutdown detected
[   82.825400] no ifx modem active;
[   82.828257] reboot: Restarting system
[   82.828892] reboot: machine restart
Elapsed time: 90
qemu-system-x86_64 -enable-kvm -cpu Haswell,+smep,+smap -kernel /kernel/x86=
_64-randconfig-ha2-1124/6067dc5a8c2b1b57e67eaf1125db1d63c1ed6361/vmlinuz-3.=
18.0-rc2-g6067dc5 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 d=
ebug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100=
 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ram=
disk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnor=
mal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconf=
ig-ha2-1124/next:master:6067dc5a8c2b1b57e67eaf1125db1d63c1ed6361:bisect-lin=
ux-7/.vmlinuz-6067dc5a8c2b1b57e67eaf1125db1d63c1ed6361-20141126125540-20-kb=
uild branch=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-ha2-1124/6=
067dc5a8c2b1b57e67eaf1125db1d63c1ed6361/vmlinuz-3.18.0-rc2-g6067dc5 drbd.mi=
nor_count=3D8'  -initrd /kernel-tests/initrd/yocto-minimal-x86_64.cgz -m 32=
0 -smp 1 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dn=
c -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kbo=
ot/pid-yocto-kbuild-20 -serial file:/dev/shm/kboot/serial-yocto-kbuild-20 -=
daemonize -display none -monitor null=20

--Y5rl02BVI9TCfPar
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.18.0-rc2-g6067dc5"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.18.0-rc2 Kernel Configuration
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
CONFIG_FIX_EARLYCON_MEM=y
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
# CONFIG_KERNEL_GZIP is not set
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_FHANDLE is not set
CONFIG_USELIB=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
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
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
# CONFIG_TASKS_RCU is not set
CONFIG_RCU_STALL_COMMON=y
# CONFIG_RCU_USER_QS is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_RCU_FAST_NO_HZ=y
CONFIG_TREE_RCU_TRACE=y
# CONFIG_RCU_BOOST is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
# CONFIG_NUMA_BALANCING_DEFAULT_ENABLED is not set
CONFIG_NUMA_BALANCING=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
CONFIG_USER_NS=y
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
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
# CONFIG_SGETMASK_SYSCALL is not set
# CONFIG_SYSFS_SYSCALL is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
# CONFIG_ADVISE_SYSCALLS is not set
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
# CONFIG_SLUB_DEBUG is not set
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_SLUB_CPU_PARTIAL is not set
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
# CONFIG_UPROBES is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
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
CONFIG_HAVE_CC_STACKPROTECTOR=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR_NONE is not set
CONFIG_CC_STACKPROTECTOR_REGULAR=y
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
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
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_THROTTLING is not set
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_AIX_PARTITION=y
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
CONFIG_ATARI_PARTITION=y
# CONFIG_MAC_PARTITION is not set
# CONFIG_MSDOS_PARTITION is not set
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
CONFIG_CMDLINE_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
CONFIG_QUEUE_RWLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
CONFIG_MK8=y
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
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
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
# CONFIG_X86_16BIT is not set
CONFIG_I8K=y
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
# CONFIG_X86_64_ACPI_NUMA is not set
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
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
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_MOVABLE_NODE=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_MEMORY_BALLOON=y
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CLEANCACHE is not set
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
CONFIG_CMA_AREAS=7
# CONFIG_MEM_SOFT_DIRTY is not set
# CONFIG_ZPOOL is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
CONFIG_PGTABLE_MAPPING=y
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
# CONFIG_EFI_MIXED is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
# CONFIG_KEXEC_FILE is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
CONFIG_DEBUG_HOTPLUG_CPU0=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_EC_DEBUGFS=y
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_DOCK is not set
# CONFIG_ACPI_PROCESSOR is not set
CONFIG_ACPI_IPMI=y
CONFIG_ACPI_NUMA=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
CONFIG_ACPI_CUSTOM_METHOD=y
# CONFIG_ACPI_BGRT is not set
CONFIG_ACPI_REDUCED_HARDWARE_ONLY=y
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
# CONFIG_ACPI_APEI_GHES is not set
# CONFIG_ACPI_APEI_PCIEAER is not set
# CONFIG_ACPI_APEI_EINJ is not set
CONFIG_ACPI_APEI_ERST_DEBUG=y
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
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
CONFIG_X86_P4_CLOCKMOD=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
# CONFIG_PCIEAER_INJECT is not set
# CONFIG_PCIEASPM is not set
CONFIG_PCIE_PME=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_PRI=y
# CONFIG_PCI_PASID is not set
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
# CONFIG_ISA_DMA_API is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PD6729=y
CONFIG_I82092=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_TSI721=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
# CONFIG_RAPIDIO_DMA_ENGINE is not set
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_ENUM_BASIC=y

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=y
# CONFIG_RAPIDIO_CPS_XX is not set
CONFIG_RAPIDIO_TSI568=y
CONFIG_RAPIDIO_CPS_GEN2=y
CONFIG_X86_SYSFB=y

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
CONFIG_PMC_ATOM=y
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
# CONFIG_NET_PTP_CLASSIFY is not set
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
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_HSR is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

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
# CONFIG_UEVENT_HELPER is not set
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
CONFIG_DISABLE_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_FENCE_TRACE=y
CONFIG_DMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=16
CONFIG_CMA_SIZE_PERCENTAGE=10
# CONFIG_CMA_SIZE_SEL_MBYTES is not set
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
CONFIG_CMA_SIZE_SEL_MAX=y
CONFIG_CMA_ALIGNMENT=8

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
CONFIG_FTL=y
CONFIG_NFTL=y
CONFIG_NFTL_RW=y
CONFIG_INFTL=y
# CONFIG_RFD_FTL is not set
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
# CONFIG_MTD_CFI_NOSWAP is not set
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
CONFIG_MTD_CFI_LE_BYTE_SWAP=y
CONFIG_MTD_CFI_GEOMETRY=y
# CONFIG_MTD_MAP_BANK_WIDTH_1 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_2 is not set
CONFIG_MTD_MAP_BANK_WIDTH_4=y
CONFIG_MTD_MAP_BANK_WIDTH_8=y
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
CONFIG_MTD_CFI_I4=y
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_OTP=y
CONFIG_MTD_CFI_INTELEXT=y
# CONFIG_MTD_CFI_AMDSTD is not set
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=y
# CONFIG_MTD_PHYSMAP_COMPAT is not set
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
CONFIG_MTD_INTEL_VR_NOR=y
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=y
# CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
CONFIG_MTD_DATAFLASH_OTP=y
CONFIG_MTD_M25P80=y
# CONFIG_MTD_SST25L is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_BCH=y
CONFIG_MTD_NAND_ECC_BCH=y
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=y
# CONFIG_MTD_NAND_DENALI_PCI is not set
CONFIG_MTD_NAND_GPIO=y
# CONFIG_MTD_NAND_OMAP_BCH_BUILD is not set
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=y
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
# CONFIG_MTD_NAND_DOCG4 is not set
CONFIG_MTD_NAND_CAFE=y
# CONFIG_MTD_NAND_NANDSIM is not set
CONFIG_MTD_NAND_PLATFORM=y
# CONFIG_MTD_ONENAND is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_SPI_NOR=y
CONFIG_MTD_SPI_NOR_USE_4K_SECTORS=y
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_MTD_UBI_GLUEBI=y
CONFIG_MTD_UBI_BLOCK=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
CONFIG_PARPORT_SERIAL=y
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_PC_PCMCIA is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_PARIDE is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
# CONFIG_ZRAM is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
CONFIG_BLK_DEV_DAC960=y
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=y

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
CONFIG_BLK_DEV_NVME=y
CONFIG_BLK_DEV_SKD=y
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
CONFIG_BLK_DEV_RSXX=y

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
# CONFIG_AD525X_DPOT_SPI is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
CONFIG_ICS932S401=y
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_HP_ILO=y
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
CONFIG_DS1682=y
CONFIG_TI_DAC7512=y
CONFIG_VMWARE_BALLOON=y
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_BMP085_SPI is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_LATTICE_ECP3_CONFIG=y
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_AT25=y
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
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
# Intel MIC Bus Driver
#
# CONFIG_INTEL_MIC_BUS is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
# CONFIG_GENWQE is not set
CONFIG_ECHO=y
# CONFIG_CXL_BASE is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
CONFIG_IDE_GD_ATAPI=y
CONFIG_BLK_DEV_IDECS=y
CONFIG_BLK_DEV_DELKIN=y
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
CONFIG_BLK_DEV_PLATFORM=y
CONFIG_BLK_DEV_CMD640=y
# CONFIG_BLK_DEV_CMD640_ENHANCED is not set
CONFIG_BLK_DEV_IDEPNP=y
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
CONFIG_BLK_DEV_OFFBOARD=y
# CONFIG_BLK_DEV_GENERIC is not set
CONFIG_BLK_DEV_OPTI621=y
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
CONFIG_BLK_DEV_ALI15X3=y
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
CONFIG_BLK_DEV_CMD64X=y
CONFIG_BLK_DEV_TRIFLEX=y
CONFIG_BLK_DEV_HPT366=y
CONFIG_BLK_DEV_JMICRON=y
CONFIG_BLK_DEV_PIIX=y
CONFIG_BLK_DEV_IT8172=y
CONFIG_BLK_DEV_IT8213=y
CONFIG_BLK_DEV_IT821X=y
CONFIG_BLK_DEV_NS87415=y
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
CONFIG_BLK_DEV_PDC202XX_NEW=y
CONFIG_BLK_DEV_SVWKS=y
# CONFIG_BLK_DEV_SIIMAGE is not set
CONFIG_BLK_DEV_SIS5513=y
# CONFIG_BLK_DEV_SLC90E66 is not set
CONFIG_BLK_DEV_TRM290=y
# CONFIG_BLK_DEV_VIA82CXXX is not set
CONFIG_BLK_DEV_TC86C001=y
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_MQ_DEFAULT=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_BOOT_SYSFS=y
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BE2ISCSI is not set
CONFIG_BLK_DEV_3W_XXXX_RAID=y
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
CONFIG_SCSI_3W_SAS=y
CONFIG_SCSI_ACARD=y
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_BUILD_FIRMWARE is not set
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
# CONFIG_AIC79XX_BUILD_FIRMWARE is not set
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC94XX=y
# CONFIG_AIC94XX_DEBUG is not set
CONFIG_SCSI_MVSAS=y
CONFIG_SCSI_MVSAS_DEBUG=y
CONFIG_SCSI_MVSAS_TASKLET=y
CONFIG_SCSI_MVUMI=y
# CONFIG_SCSI_DPT_I2O is not set
CONFIG_SCSI_ADVANSYS=y
CONFIG_SCSI_ARCMSR=y
CONFIG_SCSI_ESAS2R=y
CONFIG_MEGARAID_NEWGEN=y
# CONFIG_MEGARAID_MM is not set
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS_LOGGING is not set
CONFIG_SCSI_MPT3SAS=y
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_LOGGING=y
CONFIG_SCSI_UFSHCD=y
# CONFIG_SCSI_UFSHCD_PCI is not set
CONFIG_SCSI_UFSHCD_PLATFORM=y
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_HYPERV_STORAGE=y
CONFIG_SCSI_DMX3191D=y
CONFIG_SCSI_FUTURE_DOMAIN=y
CONFIG_SCSI_ISCI=y
# CONFIG_SCSI_IPS is not set
CONFIG_SCSI_INITIO=y
CONFIG_SCSI_INIA100=y
CONFIG_SCSI_PPA=y
# CONFIG_SCSI_IMM is not set
CONFIG_SCSI_IZIP_EPP16=y
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
CONFIG_SCSI_STEX=y
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
# CONFIG_SCSI_SYM53C8XX_MMIO is not set
CONFIG_SCSI_IPR=y
# CONFIG_SCSI_IPR_TRACE is not set
# CONFIG_SCSI_IPR_DUMP is not set
CONFIG_SCSI_QLOGIC_1280=y
# CONFIG_SCSI_QLA_ISCSI is not set
CONFIG_SCSI_DC395x=y
CONFIG_SCSI_DC390T=y
CONFIG_SCSI_DEBUG=y
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
CONFIG_SCSI_VIRTIO=y
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
# CONFIG_SCSI_DH_HP_SW is not set
CONFIG_SCSI_DH_EMC=y
# CONFIG_SCSI_DH_ALUA is not set
CONFIG_SCSI_OSD_INITIATOR=y
# CONFIG_SCSI_OSD_ULD is not set
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
# CONFIG_ATA_ACPI is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
CONFIG_SATA_AHCI_PLATFORM=y
# CONFIG_SATA_INIC162X is not set
CONFIG_SATA_ACARD_AHCI=y
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
# CONFIG_FUSION_SAS is not set
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_CTL is not set
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
# CONFIG_FIREWIRE_SBP2 is not set
CONFIG_FIREWIRE_NOSY=y
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
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
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
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
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=y
CONFIG_CYZ_INTR=y
# CONFIG_MOXA_INTELLIO is not set
CONFIG_MOXA_SMARTIO=y
CONFIG_SYNCLINKMP=y
CONFIG_SYNCLINK_GT=y
CONFIG_NOZOMI=y
CONFIG_ISI=y
CONFIG_N_HDLC=y
# CONFIG_N_GSM is not set
CONFIG_TRACE_ROUTER=y
CONFIG_TRACE_SINK=y
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set
CONFIG_SERIAL_8250_DW=y
CONFIG_SERIAL_8250_FINTEK=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_MAX310X=y
CONFIG_SERIAL_MFD_HSU=y
CONFIG_SERIAL_MFD_HSU_CONSOLE=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
CONFIG_SERIAL_SC16IS7XX=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
CONFIG_SERIAL_IFX6X60=y
CONFIG_SERIAL_ARC=y
CONFIG_SERIAL_ARC_CONSOLE=y
CONFIG_SERIAL_ARC_NR_PORTS=1
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
CONFIG_SERIAL_FSL_LPUART=y
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_SI_PROBE_DEFAULTS=y
CONFIG_IPMI_WATCHDOG=y
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_HW_RANDOM_TPM is not set
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
CONFIG_MWAVE=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_ATMEL is not set
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_TIS_I2C_NUVOTON=y
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
CONFIG_TCG_INFINEON=y
CONFIG_TCG_ST33_I2C=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_XILLYBUS=y

#
# I2C support
#
CONFIG_I2C=y
# CONFIG_ACPI_I2C_OPREGION is not set
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_ISMT=y
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
# CONFIG_I2C_NFORCE2_S4985 is not set
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
CONFIG_I2C_SCMI=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_GPIO=y
CONFIG_I2C_KEMPLD=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_TAOS_EVM=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_CROS_EC_TUNNEL=y
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_LM70_LLP=y
# CONFIG_SPI_OC_TINY is not set
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=y
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=y
# CONFIG_SPI_XCOMM is not set
CONFIG_SPI_XILINX=y
CONFIG_SPI_DESIGNWARE=y
# CONFIG_SPI_DW_PCI is not set
# CONFIG_SPI_DW_MMIO is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
CONFIG_SPI_TLE62X0=y
CONFIG_SPMI=y
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
CONFIG_HSI_CHAR=y

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
# CONFIG_NTP_PPS is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=y
CONFIG_PPS_CLIENT_PARPORT=y
CONFIG_PPS_CLIENT_GPIO=y

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
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_DWAPB is not set
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_SCH311X=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
CONFIG_GPIO_LYNXPOINT=y

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
CONFIG_GPIO_CRYSTAL_COVE=y
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_RC5T583=y
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_TC3589X is not set
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TWL4030=y
# CONFIG_GPIO_WM831X is not set
# CONFIG_GPIO_WM8994 is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=y
# CONFIG_GPIO_AMD8111 is not set
CONFIG_GPIO_INTEL_MID=y
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
# CONFIG_GPIO_MCP23S08 is not set
CONFIG_GPIO_MC33880=y

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
CONFIG_GPIO_KEMPLD=y

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_PALMAS is not set
CONFIG_GPIO_TPS65910=y

#
# USB GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=y
# CONFIG_W1_SLAVE_DS2406 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
# CONFIG_W1_SLAVE_DS2780 is not set
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
# CONFIG_MAX8925_POWER is not set
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
CONFIG_TEST_POWER=y
CONFIG_BATTERY_88PM860X=y
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_88PM860X=y
# CONFIG_CHARGER_PCF50633 is not set
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_TWL4030=y
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_MAX14577=y
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_BQ24735=y
CONFIG_CHARGER_SMB347=y
CONFIG_CHARGER_TPS65090=y
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=y
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_MC13783_ADC=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_GL518SM=y
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_GPIO_FAN=y
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_POWR1220 is not set
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LTC2945=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=y
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4260=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=y
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
# CONFIG_SENSORS_HTU21 is not set
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LM95234=y
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_NCT6683=y
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SHTC1=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_DME1737=y
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
# CONFIG_SENSORS_TMP103 is not set
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=y
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_WM831X is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
CONFIG_SENSORS_ATK0110=y
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_BANG_BANG is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
CONFIG_INTEL_POWERCLAMP=y
CONFIG_INTEL_SOC_DTS_THERMAL=y
# CONFIG_INT340X_THERMAL is not set

#
# Texas Instruments thermal drivers
#
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_AS3711=y
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
CONFIG_MFD_AXP20X=y
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
CONFIG_LPC_ICH=y
# CONFIG_LPC_SCH is not set
CONFIG_INTEL_SOC_PMIC=y
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
# CONFIG_MFD_MENF21BMC is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_RETU is not set
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
# CONFIG_PCF50633_GPIO is not set
# CONFIG_UCB1400_CORE is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_RN5T618 is not set
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS65218=y
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
CONFIG_MFD_TWL4030_AUDIO=y
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM5102 is not set
# CONFIG_MFD_WM5110 is not set
# CONFIG_MFD_WM8997 is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_88PM8607 is not set
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
# CONFIG_REGULATOR_ARIZONA is not set
CONFIG_REGULATOR_AS3711=y
CONFIG_REGULATOR_AXP20X=y
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_DA9211=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL9305=y
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_LP8755=y
# CONFIG_REGULATOR_LTC3589 is not set
CONFIG_REGULATOR_MAX14577=y
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8925 is not set
CONFIG_REGULATOR_MAX8952=y
# CONFIG_REGULATOR_MAX8973 is not set
# CONFIG_REGULATOR_MAX8998 is not set
# CONFIG_REGULATOR_MAX77686 is not set
CONFIG_REGULATOR_MAX77802=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
# CONFIG_REGULATOR_MC13892 is not set
CONFIG_REGULATOR_PALMAS=y
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_RC5T583=y
CONFIG_REGULATOR_S2MPA01=y
# CONFIG_REGULATOR_S2MPS11 is not set
CONFIG_REGULATOR_S5M8767=y
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS6105X=y
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65090=y
CONFIG_REGULATOR_TPS65217=y
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_TPS65910=y
# CONFIG_REGULATOR_TPS65912 is not set
CONFIG_REGULATOR_TWL4030=y
CONFIG_REGULATOR_WM831X=y
# CONFIG_REGULATOR_WM8400 is not set
CONFIG_REGULATOR_WM8994=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_SDR_SUPPORT=y
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=y
# CONFIG_VIDEO_V4L2_SUBDEV_API is not set
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_V4L2_MEM2MEM_DEV=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_VMALLOC=y
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
# CONFIG_MEDIA_PCI_SUPPORT is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
CONFIG_V4L_TEST_DRIVERS=y
# CONFIG_VIDEO_VIVID is not set
CONFIG_VIDEO_MEM2MEM_TESTDEV=y

#
# Supported MMC/SDIO adapters
#
# CONFIG_MEDIA_PARPORT_SUPPORT is not set
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_TEA575X=y
# CONFIG_RADIO_SI470X is not set
CONFIG_RADIO_SI4713=y
CONFIG_PLATFORM_SI4713=y
CONFIG_I2C_SI4713=y
CONFIG_RADIO_SI476X=y
CONFIG_RADIO_MAXIRADIO=y
# CONFIG_RADIO_TEA5764 is not set
CONFIG_RADIO_SAA7706H=y
CONFIG_RADIO_TEF6862=y
# CONFIG_RADIO_WL1273 is not set

#
# Texas Instruments WL128x FM driver (ST based)
#

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
CONFIG_VIDEO_TDA7432=y
CONFIG_VIDEO_TDA9840=y
CONFIG_VIDEO_TEA6415C=y
# CONFIG_VIDEO_TEA6420 is not set
CONFIG_VIDEO_MSP3400=y
# CONFIG_VIDEO_CS5345 is not set
CONFIG_VIDEO_CS53L32A=y
CONFIG_VIDEO_TLV320AIC23B=y
# CONFIG_VIDEO_UDA1342 is not set
# CONFIG_VIDEO_WM8775 is not set
CONFIG_VIDEO_WM8739=y
# CONFIG_VIDEO_VP27SMPX is not set
CONFIG_VIDEO_SONY_BTF_MPX=y

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set

#
# Video decoders
#
# CONFIG_VIDEO_ADV7180 is not set
# CONFIG_VIDEO_ADV7183 is not set
CONFIG_VIDEO_BT819=y
CONFIG_VIDEO_BT856=y
CONFIG_VIDEO_BT866=y
CONFIG_VIDEO_KS0127=y
# CONFIG_VIDEO_ML86V7667 is not set
CONFIG_VIDEO_SAA7110=y
CONFIG_VIDEO_SAA711X=y
# CONFIG_VIDEO_SAA7191 is not set
CONFIG_VIDEO_TVP514X=y
# CONFIG_VIDEO_TVP5150 is not set
# CONFIG_VIDEO_TVP7002 is not set
CONFIG_VIDEO_TW2804=y
# CONFIG_VIDEO_TW9903 is not set
CONFIG_VIDEO_TW9906=y
CONFIG_VIDEO_VPX3220=y

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
CONFIG_VIDEO_ADV7170=y
# CONFIG_VIDEO_ADV7175 is not set
CONFIG_VIDEO_ADV7343=y
CONFIG_VIDEO_ADV7393=y
CONFIG_VIDEO_AK881X=y
CONFIG_VIDEO_THS8200=y

#
# Camera sensor devices
#
CONFIG_VIDEO_OV7640=y
# CONFIG_VIDEO_OV7670 is not set
CONFIG_VIDEO_VS6624=y
CONFIG_VIDEO_MT9V011=y
# CONFIG_VIDEO_SR030PC30 is not set

#
# Flash devices
#
CONFIG_VIDEO_ADP1653=y
# CONFIG_VIDEO_AS3645A is not set
# CONFIG_VIDEO_LM3560 is not set
CONFIG_VIDEO_LM3646=y

#
# Video improvement chips
#
# CONFIG_VIDEO_UPD64031A is not set
CONFIG_VIDEO_UPD64083=y

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=y

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
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MSI001=y
CONFIG_MEDIA_TUNER_MT20XX=y
# CONFIG_MEDIA_TUNER_MT2060 is not set
CONFIG_MEDIA_TUNER_MT2063=y
CONFIG_MEDIA_TUNER_MT2266=y
CONFIG_MEDIA_TUNER_MT2131=y
CONFIG_MEDIA_TUNER_QT1010=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
# CONFIG_MEDIA_TUNER_MXL5005S is not set
CONFIG_MEDIA_TUNER_MXL5007T=y
CONFIG_MEDIA_TUNER_MC44S803=y
# CONFIG_MEDIA_TUNER_MAX2165 is not set
CONFIG_MEDIA_TUNER_TDA18218=y
CONFIG_MEDIA_TUNER_FC0011=y
# CONFIG_MEDIA_TUNER_FC0012 is not set
# CONFIG_MEDIA_TUNER_FC0013 is not set
CONFIG_MEDIA_TUNER_TDA18212=y
CONFIG_MEDIA_TUNER_E4000=y
CONFIG_MEDIA_TUNER_FC2580=y
# CONFIG_MEDIA_TUNER_M88TS2022 is not set
CONFIG_MEDIA_TUNER_TUA9001=y
CONFIG_MEDIA_TUNER_SI2157=y
CONFIG_MEDIA_TUNER_IT913X=y
CONFIG_MEDIA_TUNER_R820T=y
CONFIG_MEDIA_TUNER_MXL301RF=y
CONFIG_MEDIA_TUNER_QM1D1C0042=y

#
# Customise DVB Frontends
#
CONFIG_DVB_AU8522=y
CONFIG_DVB_AU8522_V4L=y
CONFIG_DVB_TUNER_DIB0070=y
CONFIG_DVB_TUNER_DIB0090=y

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
CONFIG_AGP_VIA=y
CONFIG_INTEL_GTT=y
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
# CONFIG_DRM is not set

#
# Frame buffer Devices
#
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_CMDLINE=y
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
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
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_EFI is not set
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_OPENCORES=y
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=y
CONFIG_FB_NVIDIA_I2C=y
CONFIG_FB_NVIDIA_DEBUG=y
CONFIG_FB_NVIDIA_BACKLIGHT=y
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
CONFIG_FB_INTEL=y
CONFIG_FB_INTEL_DEBUG=y
# CONFIG_FB_INTEL_I2C is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
CONFIG_FB_ATY128=y
# CONFIG_FB_ATY128_BACKLIGHT is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=y
# CONFIG_FB_SIS_300 is not set
CONFIG_FB_SIS_315=y
CONFIG_FB_VIA=y
CONFIG_FB_VIA_DIRECT_PROCFS=y
CONFIG_FB_VIA_X_COMPATIBILITY=y
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=y
# CONFIG_FB_VT8623 is not set
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
# CONFIG_FB_CARMINE is not set
CONFIG_FB_SM501=y
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
# CONFIG_FB_AUO_K1901 is not set
CONFIG_FB_HYPERV=y
# CONFIG_FB_SIMPLE is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
CONFIG_LCD_LTV350QV=y
CONFIG_LCD_ILI922X=y
CONFIG_LCD_ILI9320=y
CONFIG_LCD_TDO24M=y
CONFIG_LCD_VGG2432A4=y
CONFIG_LCD_PLATFORM=y
CONFIG_LCD_S6E63M0=y
CONFIG_LCD_LD9040=y
CONFIG_LCD_AMS369FG06=y
# CONFIG_LCD_LMS501KF03 is not set
# CONFIG_LCD_HX8357 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
# CONFIG_BACKLIGHT_DA9052 is not set
CONFIG_BACKLIGHT_MAX8925=y
CONFIG_BACKLIGHT_APPLE=y
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_88PM860X=y
# CONFIG_BACKLIGHT_PCF50633 is not set
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_PANDORA=y
CONFIG_BACKLIGHT_TPS65217=y
CONFIG_BACKLIGHT_AS3711=y
# CONFIG_BACKLIGHT_GPIO is not set
CONFIG_BACKLIGHT_LV5207LP=y
# CONFIG_BACKLIGHT_BD6107 is not set
CONFIG_VGASTATE=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_DMAENGINE_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=y
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
CONFIG_SND_PCM_OSS=y
# CONFIG_SND_PCM_OSS_PLUGINS is not set
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_KCTL_JACK=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=y
CONFIG_SND_OPL3_LIB_SEQ=y
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
CONFIG_SND_EMU10K1_SEQ=y
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_AC97_CODEC=y
CONFIG_SND_DRIVERS=y
CONFIG_SND_DUMMY=y
CONFIG_SND_ALOOP=y
CONFIG_SND_VIRMIDI=y
# CONFIG_SND_MTPAV is not set
CONFIG_SND_MTS64=y
CONFIG_SND_SERIAL_U16550=y
CONFIG_SND_MPU401=y
# CONFIG_SND_PORTMAN2X4 is not set
# CONFIG_SND_AC97_POWER_SAVE is not set
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=y
CONFIG_SND_ALS300=y
CONFIG_SND_ALI5451=y
# CONFIG_SND_ASIHPI is not set
CONFIG_SND_ATIIXP=y
# CONFIG_SND_ATIIXP_MODEM is not set
CONFIG_SND_AU8810=y
CONFIG_SND_AU8820=y
CONFIG_SND_AU8830=y
CONFIG_SND_AW2=y
CONFIG_SND_AZT3328=y
CONFIG_SND_BT87X=y
CONFIG_SND_BT87X_OVERCLOCK=y
CONFIG_SND_CA0106=y
CONFIG_SND_CMIPCI=y
CONFIG_SND_OXYGEN_LIB=y
CONFIG_SND_OXYGEN=y
CONFIG_SND_CS4281=y
CONFIG_SND_CS46XX=y
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CTXFI=y
CONFIG_SND_DARLA20=y
CONFIG_SND_GINA20=y
CONFIG_SND_LAYLA20=y
CONFIG_SND_DARLA24=y
# CONFIG_SND_GINA24 is not set
CONFIG_SND_LAYLA24=y
CONFIG_SND_MONA=y
# CONFIG_SND_MIA is not set
CONFIG_SND_ECHO3G=y
# CONFIG_SND_INDIGO is not set
CONFIG_SND_INDIGOIO=y
CONFIG_SND_INDIGODJ=y
# CONFIG_SND_INDIGOIOX is not set
CONFIG_SND_INDIGODJX=y
CONFIG_SND_EMU10K1=y
CONFIG_SND_EMU10K1X=y
# CONFIG_SND_ENS1370 is not set
CONFIG_SND_ENS1371=y
CONFIG_SND_ES1938=y
CONFIG_SND_ES1968=y
# CONFIG_SND_ES1968_INPUT is not set
CONFIG_SND_ES1968_RADIO=y
CONFIG_SND_FM801=y
# CONFIG_SND_FM801_TEA575X_BOOL is not set
CONFIG_SND_HDSP=y

#
# Don't forget to add built-in firmwares for HDSP driver
#
CONFIG_SND_HDSPM=y
# CONFIG_SND_ICE1712 is not set
CONFIG_SND_ICE1724=y
CONFIG_SND_INTEL8X0=y
CONFIG_SND_INTEL8X0M=y
CONFIG_SND_KORG1212=y
CONFIG_SND_LOLA=y
# CONFIG_SND_LX6464ES is not set
CONFIG_SND_MAESTRO3=y
# CONFIG_SND_MAESTRO3_INPUT is not set
CONFIG_SND_MIXART=y
# CONFIG_SND_NM256 is not set
CONFIG_SND_PCXHR=y
CONFIG_SND_RIPTIDE=y
# CONFIG_SND_RME32 is not set
CONFIG_SND_RME96=y
CONFIG_SND_RME9652=y
CONFIG_SND_SONICVIBES=y
# CONFIG_SND_TRIDENT is not set
CONFIG_SND_VIA82XX=y
CONFIG_SND_VIA82XX_MODEM=y
CONFIG_SND_VIRTUOSO=y
# CONFIG_SND_VX222 is not set
CONFIG_SND_YMFPCI=y

#
# HD-Audio
#
CONFIG_SND_HDA=y
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_DSP_LOADER=y
CONFIG_SND_HDA_PREALLOC_SIZE=64
# CONFIG_SND_HDA_HWDEP is not set
# CONFIG_SND_HDA_RECONFIG is not set
# CONFIG_SND_HDA_INPUT_BEEP is not set
# CONFIG_SND_HDA_INPUT_JACK is not set
# CONFIG_SND_HDA_PATCH_LOADER is not set
# CONFIG_SND_HDA_CODEC_REALTEK is not set
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
# CONFIG_SND_HDA_CODEC_HDMI is not set
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CA0132=y
CONFIG_SND_HDA_CODEC_CA0132_DSP=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
# CONFIG_SND_SPI is not set
CONFIG_SND_FIREWIRE=y
CONFIG_SND_FIREWIRE_LIB=y
# CONFIG_SND_DICE is not set
CONFIG_SND_FIREWIRE_SPEAKERS=y
# CONFIG_SND_ISIGHT is not set
# CONFIG_SND_SCS1X is not set
CONFIG_SND_FIREWORKS=y
# CONFIG_SND_BEBOB is not set
# CONFIG_SND_PCMCIA is not set
CONFIG_SND_SOC=y
CONFIG_SND_SOC_GENERIC_DMAENGINE_PCM=y
CONFIG_SND_ATMEL_SOC=y

#
# SoC Audio for Freescale CPUs
#

#
# Common SoC Audio options for Freescale CPUs:
#
CONFIG_SND_SOC_FSL_ASRC=y
# CONFIG_SND_SOC_FSL_SAI is not set
CONFIG_SND_SOC_FSL_SSI=y
CONFIG_SND_SOC_FSL_SPDIF=y
# CONFIG_SND_SOC_FSL_ESAI is not set
CONFIG_SND_SOC_IMX_AUDMUX=y
# CONFIG_SND_SOC_INTEL_SST is not set
CONFIG_SND_SOC_I2C_AND_SPI=y

#
# CODEC drivers
#
CONFIG_SND_SOC_ADAU1701=y
# CONFIG_SND_SOC_AK4104 is not set
CONFIG_SND_SOC_AK4554=y
# CONFIG_SND_SOC_AK4642 is not set
CONFIG_SND_SOC_AK5386=y
CONFIG_SND_SOC_ALC5623=y
# CONFIG_SND_SOC_CS35L32 is not set
# CONFIG_SND_SOC_CS42L52 is not set
# CONFIG_SND_SOC_CS42L56 is not set
CONFIG_SND_SOC_CS42L73=y
CONFIG_SND_SOC_CS4265=y
CONFIG_SND_SOC_CS4270=y
CONFIG_SND_SOC_CS4271=y
CONFIG_SND_SOC_CS42XX8=y
CONFIG_SND_SOC_CS42XX8_I2C=y
# CONFIG_SND_SOC_HDMI_CODEC is not set
# CONFIG_SND_SOC_ES8328 is not set
CONFIG_SND_SOC_PCM1681=y
# CONFIG_SND_SOC_PCM1792A is not set
CONFIG_SND_SOC_PCM512x=y
# CONFIG_SND_SOC_PCM512x_I2C is not set
CONFIG_SND_SOC_PCM512x_SPI=y
CONFIG_SND_SOC_SGTL5000=y
CONFIG_SND_SOC_SI476X=y
CONFIG_SND_SOC_SIGMADSP=y
CONFIG_SND_SOC_SIGMADSP_I2C=y
CONFIG_SND_SOC_SIRF_AUDIO_CODEC=y
CONFIG_SND_SOC_SPDIF=y
# CONFIG_SND_SOC_SSM2602_SPI is not set
# CONFIG_SND_SOC_SSM2602_I2C is not set
# CONFIG_SND_SOC_SSM4567 is not set
CONFIG_SND_SOC_STA350=y
CONFIG_SND_SOC_TAS2552=y
CONFIG_SND_SOC_TAS5086=y
# CONFIG_SND_SOC_TLV320AIC31XX is not set
CONFIG_SND_SOC_TLV320AIC3X=y
# CONFIG_SND_SOC_WM8510 is not set
# CONFIG_SND_SOC_WM8523 is not set
# CONFIG_SND_SOC_WM8580 is not set
CONFIG_SND_SOC_WM8711=y
# CONFIG_SND_SOC_WM8728 is not set
# CONFIG_SND_SOC_WM8731 is not set
CONFIG_SND_SOC_WM8737=y
CONFIG_SND_SOC_WM8741=y
# CONFIG_SND_SOC_WM8750 is not set
CONFIG_SND_SOC_WM8753=y
# CONFIG_SND_SOC_WM8770 is not set
CONFIG_SND_SOC_WM8776=y
CONFIG_SND_SOC_WM8804=y
CONFIG_SND_SOC_WM8903=y
# CONFIG_SND_SOC_WM8962 is not set
# CONFIG_SND_SOC_WM8978 is not set
# CONFIG_SND_SOC_TPA6130A2 is not set
CONFIG_SND_SIMPLE_CARD=y
CONFIG_SOUND_PRIME=y
CONFIG_AC97_BUS=y

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_PRODIKEYS is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_RMI is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_HYPERV_MOUSE is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_XINMO is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_GADGET is not set
CONFIG_UWB=y
# CONFIG_UWB_WHCI is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=y
CONFIG_MS_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_MEMSTICK_R592=y
CONFIG_MEMSTICK_REALTEK_PCI=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_DAC124S085=y
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_LM355x=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_E752X=y
# CONFIG_EDAC_I82975X is not set
CONFIG_EDAC_I3000=y
CONFIG_EDAC_I3200=y
CONFIG_EDAC_IE31200=y
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I5000 is not set
CONFIG_EDAC_I5100=y
CONFIG_EDAC_I7300=y
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
# CONFIG_RTC_INTF_PROC is not set
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM860X=y
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8925=y
CONFIG_RTC_DRV_MAX8998=y
CONFIG_RTC_DRV_MAX77686=y
# CONFIG_RTC_DRV_MAX77802 is not set
CONFIG_RTC_DRV_RS5C372=y
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_ISL12057 is not set
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PALMAS=y
CONFIG_RTC_DRV_PCF2127=y
CONFIG_RTC_DRV_PCF8523=y
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF85063=y
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=y
CONFIG_RTC_DRV_TWL4030=y
CONFIG_RTC_DRV_TPS65910=y
# CONFIG_RTC_DRV_RC5T583 is not set
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y
# CONFIG_RTC_DRV_EM3027 is not set
CONFIG_RTC_DRV_RV3029C2=y
CONFIG_RTC_DRV_S5M=y

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
CONFIG_RTC_DRV_M41T94=y
CONFIG_RTC_DRV_DS1305=y
CONFIG_RTC_DRV_DS1343=y
# CONFIG_RTC_DRV_DS1347 is not set
CONFIG_RTC_DRV_DS1390=y
# CONFIG_RTC_DRV_MAX6902 is not set
CONFIG_RTC_DRV_R9701=y
CONFIG_RTC_DRV_RS5C348=y
CONFIG_RTC_DRV_DS3234=y
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_RX4581 is not set
CONFIG_RTC_DRV_MCP795=y

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
# CONFIG_RTC_DRV_DS2404 is not set
# CONFIG_RTC_DRV_DA9052 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_WM831X=y
CONFIG_RTC_DRV_PCF50633=y

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=y
CONFIG_RTC_DRV_XGENE=y

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
CONFIG_DW_DMAC_CORE=y
# CONFIG_DW_DMAC is not set
CONFIG_DW_DMAC_PCI=y
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=y
CONFIG_AUXDISPLAY=y
# CONFIG_KS0108 is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=y
CONFIG_UIO_PDRV_GENIRQ=y
# CONFIG_UIO_DMEM_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y
CONFIG_UIO_MF624=y
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=y
# CONFIG_HYPERV_BALLOON is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
CONFIG_CHROME_PLATFORMS=y
# CONFIG_CHROMEOS_PSTORE is not set

#
# SOC (System On Chip) specific Drivers
#
CONFIG_SOC_TI=y

#
# Hardware Spinlock drivers
#

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_ATMEL_PIT is not set
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
CONFIG_MAILBOX=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#

#
# SOC (System On Chip) specific Drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_ARIZONA is not set
# CONFIG_EXTCON_GPIO is not set
# CONFIG_EXTCON_MAX14577 is not set
CONFIG_EXTCON_PALMAS=y
CONFIG_EXTCON_RT8973A=y
CONFIG_EXTCON_SM5502=y
CONFIG_MEMORY=y
# CONFIG_IIO is not set
CONFIG_NTB=y
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
# CONFIG_VME_TSI148 is not set

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=y

#
# VME Device Drivers
#
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
CONFIG_SERIAL_IPOCTAL=y
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
# CONFIG_POWERCAP is not set
# CONFIG_MCB is not set
CONFIG_RAS=y
# CONFIG_THUNDERBOLT is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=y
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
# CONFIG_EFI_VARS_PSTORE is not set
CONFIG_EFI_RUNTIME_MAP=y
CONFIG_EFI_RUNTIME_WRAPPERS=y
CONFIG_UEFI_CPER=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4_FS is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
# CONFIG_REISERFS_FS_POSIX_ACL is not set
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=y
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
CONFIG_BTRFS_ASSERT=y
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_DEBUG=y
# CONFIG_QFMT_V1 is not set
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set
# CONFIG_OVERLAYFS_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_FSCACHE_OBJECT_LIST=y
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
# CONFIG_MSDOS_FS is not set
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
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
CONFIG_ADFS_FS_RW=y
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=y
# CONFIG_ECRYPT_FS_MESSAGING is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
CONFIG_JFFS2_FS_WBUF_VERIFY=y
# CONFIG_JFFS2_SUMMARY is not set
CONFIG_JFFS2_FS_XATTR=y
# CONFIG_JFFS2_FS_POSIX_ACL is not set
# CONFIG_JFFS2_FS_SECURITY is not set
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
CONFIG_JFFS2_LZO=y
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
# CONFIG_JFFS2_CMODE_NONE is not set
# CONFIG_JFFS2_CMODE_PRIORITY is not set
# CONFIG_JFFS2_CMODE_SIZE is not set
CONFIG_JFFS2_CMODE_FAVOURLZO=y
CONFIG_UBIFS_FS=y
CONFIG_UBIFS_FS_ADVANCED_COMPR=y
# CONFIG_UBIFS_FS_LZO is not set
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
# CONFIG_OMFS_FS is not set
CONFIG_HPFS_FS=y
# CONFIG_QNX4FS_FS is not set
CONFIG_QNX6FS_FS=y
# CONFIG_QNX6FS_DEBUG is not set
CONFIG_ROMFS_FS=y
# CONFIG_ROMFS_BACKED_BY_BLOCK is not set
CONFIG_ROMFS_BACKED_BY_MTD=y
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_RAM=y
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
# CONFIG_F2FS_FS is not set
CONFIG_EFIVAR_FS=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
# CONFIG_NLS_UTF8 is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_VMACACHE=y
CONFIG_DEBUG_VM_RB=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_SCHED_STACK_END_CHECK is not set
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_PREEMPT=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PI_LIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST_RUNNABLE is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_VERBOSE=y
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
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
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_TEST_RHASHTABLE is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_FIRMWARE=y
# CONFIG_TEST_UDELAY is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_EARLY_PRINTK_EFI=y
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_BIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
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
CONFIG_CRYPTO_MCRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
CONFIG_CRYPTO_ABLK_HELPER=y
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
# CONFIG_CRYPTO_PCBC is not set
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
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=y
CONFIG_CRYPTO_SHA1_MB=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

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
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=y
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_DES3_EDE_X86_64=y
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_DRBG_MENU=y
# CONFIG_CRYPTO_DRBG_HMAC is not set
# CONFIG_CRYPTO_DRBG_HASH is not set
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
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
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
# CONFIG_CRC_CCITT is not set
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
CONFIG_GLOB_SELFTEST=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_UCS2_STRING=y
CONFIG_FONT_SUPPORT=y
CONFIG_FONT_8x16=y
CONFIG_FONT_AUTOSELECT=y
CONFIG_ARCH_HAS_SG_CHAIN=y

--Y5rl02BVI9TCfPar
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--Y5rl02BVI9TCfPar--
