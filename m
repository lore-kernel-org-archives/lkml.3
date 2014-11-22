Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbaKVSrf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 13:47:35 -0500
Received: from mga14.intel.com ([192.55.52.115]:20532 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbaKVSrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 13:47:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,438,1413270000"; 
   d="scan'208";a="626741118"
Date: Sat, 22 Nov 2014 10:47:15 -0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "pang.xunlei" <pang.xunlei@linaro.org>
Cc: John Stultz <john.stultz@linaro.org>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [time] WARNING: CPU: 0 PID: 1 at kernel/time/timekeeping.c:1337
 update_wall_time()
Message-ID: <20141122184715.GD29361@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="C+ts3FVlLX8+P6JN"
Content-Disposition: inline
In-Reply-To: <20141122184506.GC29361@wfg-t540p.sh.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C+ts3FVlLX8+P6JN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Xunlei,

FYI, here is another bisect result.

https://git.linaro.org/people/john.stultz/linux.git fortglx/3.19/time

commit 59fa38d60ca4bc7a2efffae1b40aa7960374ef9d
Author:     pang.xunlei <pang.xunlei@linaro.org>
AuthorDate: Wed Oct 8 15:03:34 2014 +0800
Commit:     John Stultz <john.stultz@linaro.org>
CommitDate: Thu Oct 23 21:26:24 2014 -0700

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

+---------------------------------------------------------+------------+------------+------------+
|                                                         | 3953d54968 | 59fa38d60c | 59fa38d60c |
+---------------------------------------------------------+------------+------------+------------+
| boot_successes                                          | 60         | 0          | 0          |
| boot_failures                                           | 0          | 11         | 11         |
| WARNING:at_kernel/time/timekeeping.c:update_wall_time() | 0          | 11         | 11         |
| backtrace:event_create_dir                              | 0          | 11         | 11         |
| backtrace:event_trace_init                              | 0          | 11         | 11         |
| backtrace:kernel_init_freeable                          | 0          | 11         | 11         |
+---------------------------------------------------------+------------+------------+------------+

[    0.489933] Warning: could not register all branches stats
[    0.491673] Warning: could not register annotated branches stats
[    0.500012] ------------[ cut here ]------------
[    0.500012] WARNING: CPU: 0 PID: 1 at kernel/time/timekeeping.c:1337 update_wall_time+0x5d8/0x8dc()
[    0.500012] Modules linked in:
[    0.500012] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc1-00274-g59fa38d #496
[    0.500012] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.500012]  0000000000000009 ffff880013a03e58 ffffffff818a545a 0000000000000000
[    0.500012]  0000000000000000 ffff880013a03e98 ffffffff810cd4d6 0000000100000000
[    0.500012]  ffffffff811659ec 0000000000002201 0000000000000001 0000000000000001
[    0.500012] Call Trace:
[    0.500012]  <IRQ>  [<ffffffff818a545a>] dump_stack+0x7e/0xaa
[    0.500012]  [<ffffffff810cd4d6>] warn_slowpath_common+0x98/0xb2
[    0.500012]  [<ffffffff811659ec>] ? update_wall_time+0x5d8/0x8dc
[    0.500012]  [<ffffffff810cd593>] warn_slowpath_null+0x1a/0x1c
[    0.500012]  [<ffffffff811659ec>] update_wall_time+0x5d8/0x8dc
[    0.500012]  [<ffffffff8116c91c>] tick_periodic+0x9d/0xc6
[    0.500012]  [<ffffffff8116cb91>] ? tick_handle_periodic+0x27/0xa7
[    0.500012]  [<ffffffff8116cb91>] tick_handle_periodic+0x27/0xa7
[    0.500012]  [<ffffffff8103ba1d>] local_apic_timer_interrupt+0x6c/0x70
[    0.500012]  [<ffffffff818b3de3>] smp_apic_timer_interrupt+0x40/0x52
[    0.500012]  [<ffffffff818b2a82>] apic_timer_interrupt+0x72/0x80
[    0.500012]  <EOI>  [<ffffffff811244ec>] ? __lock_acquire+0x7f4/0xc24
[    0.500012]  [<ffffffff811249e8>] ? lock_acquire+0xcc/0x12b
[    0.500012]  [<ffffffff81255903>] ? __d_instantiate+0x33/0x1c7
[    0.500012]  [<ffffffff818b0712>] _raw_spin_lock+0x36/0x84
[    0.500012]  [<ffffffff81255903>] ? __d_instantiate+0x33/0x1c7
[    0.500012]  [<ffffffff81255903>] __d_instantiate+0x33/0x1c7
[    0.500012]  [<ffffffff8125826f>] d_instantiate+0x7f/0xb1
[    0.500012]  [<ffffffff8126d12e>] simple_lookup+0x76/0x84
[    0.500012]  [<ffffffff81243b9a>] lookup_real+0x6d/0xb6
[    0.500012]  [<ffffffff812452b5>] __lookup_hash+0x42/0x49
[    0.500012]  [<ffffffff8124a95c>] lookup_one_len+0x224/0x233
[    0.500012]  [<ffffffff81388d70>] __create_file+0xbf/0x24c
[    0.500012]  [<ffffffff81388f1e>] debugfs_create_file+0x21/0x23
[    0.500012]  [<ffffffff81191990>] trace_create_file+0x12/0x33
[    0.500012]  [<ffffffff8119a176>] event_create_dir+0x36b/0x411
[    0.500012]  [<ffffffff82741dcf>] event_trace_init+0x1b9/0x23c
[    0.500012]  [<ffffffff82741c16>] ? event_trace_enable+0x170/0x170
[    0.500012]  [<ffffffff81000391>] do_one_initcall+0x14d/0x257
[    0.500012]  [<ffffffff810f3a28>] ? parse_args+0x352/0x433
[    0.500012]  [<ffffffff82718565>] kernel_init_freeable+0x111/0x1da
[    0.500012]  [<ffffffff8189c993>] ? rest_init+0xc7/0xc7
[    0.500012]  [<ffffffff8189c9a1>] kernel_init+0xe/0x157
[    0.500012]  [<ffffffff818b1a7c>] ret_from_fork+0x7c/0xb0
[    0.500012]  [<ffffffff8189c993>] ? rest_init+0xc7/0xc7
[    0.500012] ---[ end trace e756a48c2bb7ada1 ]---
[    0.713574] FS-Cache: Loaded

git bisect start 59fa38d60ca4bc7a2efffae1b40aa7960374ef9d 816fb4175c29b16948fb24a92053bea1e79908cc --
git bisect good 3953d54968793e0db56c8a7ffbdedc2ba9cb6d82  # 14:37     20+      0  time: Rename udelay_test.c to test_udelay.c
# first bad commit: [59fa38d60ca4bc7a2efffae1b40aa7960374ef9d] time: Avoid possible NTP adjustment mult overflow.
git bisect good 3953d54968793e0db56c8a7ffbdedc2ba9cb6d82  # 14:41     60+      0  time: Rename udelay_test.c to test_udelay.c
git bisect  bad b6adbbd9a2171aa4764ea8a56c4c1a5f63f2cca6  # 14:41      0-      2  Merge commit '039348d8c131329742e80e37122f11d230fd270b' into fortglx/3.19/time
git bisect good fc14f9c1272f62c3e8d01300f52467c0d9af50f9  # 14:44     60+      8  Linux 3.18-rc5
git bisect good 5b83d7ad910674ab8c059f3a5ff9c2b0c0a4b685  # 14:48     60+      0  Add linux-next specific files for 20141120


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

--C+ts3FVlLX8+P6JN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-kbuild-13:20141121140855:x86_64-randconfig-ha2-1109:3.18.0-rc1-00274-g59fa38d:496"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Linux version 3.18.0-rc1-00274-g59fa38d (kbuild@lkp-hsx01) (=
gcc version 4.9.1 (Debian 4.9.1-19) ) #496 SMP Fri Nov 21 14:05:44 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-ha2-1109/time:fortglx:3.19:time/.vmlinuz-59fa38d60ca4bc7a2efffae1b40aa=
7960374ef9d-20141121140749-1-kbuild branch=3Dtime/fortglx/3.19/time BOOT_IM=
AGE=3D/kernel/x86_64-randconfig-ha2-1109/59fa38d60ca4bc7a2efffae1b40aa79603=
74ef9d/vmlinuz-3.18.0-rc1-00274-g59fa38d drbd.minor_count=3D8
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
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
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
[    0.000000] found SMP MP-table at [mem 0x000fdb00-0x000fdb0f] mapped at =
[ffff8800000fdb00]
[    0.000000]   mpc: fdb10-fdbf0
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x03381000, 0x03381fff] PGTABLE
[    0.000000] BRK [0x03382000, 0x03382fff] PGTABLE
[    0.000000] BRK [0x03383000, 0x03383fff] PGTABLE
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
[    0.000000] BRK [0x03384000, 0x03384fff] PGTABLE
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
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
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
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 478 pages/cpu @ffff880013a00000 s1918720 r8=
192 d30976 u2097152
[    0.000000] pcpu-alloc: s1918720 r8192 d30976 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 13a0cd40
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-ha2-1109/time:fortglx:3.19:time/.vmlinuz-59fa38d60ca4bc7a2efffa=
e1b40aa7960374ef9d-20141121140749-1-kbuild branch=3Dtime/fortglx/3.19/time =
BOOT_IMAGE=3D/kernel/x86_64-randconfig-ha2-1109/59fa38d60ca4bc7a2efffae1b40=
aa7960374ef9d/vmlinuz-3.18.0-rc1-00274-g59fa38d drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standar=
d form
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 278796K/327280K available (8914K kernel code, 5378K =
rwdata, 6144K rodata, 2916K init, 11640K bss, 48484K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D1
[    0.000000] NR_IRQS:4352 nr_irqs:48 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Linux version 3.18.0-rc1-00274-g59fa38d (kbuild@lkp-hsx01) (=
gcc version 4.9.1 (Debian 4.9.1-19) ) #496 SMP Fri Nov 21 14:05:44 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-ha2-1109/time:fortglx:3.19:time/.vmlinuz-59fa38d60ca4bc7a2efffae1b40aa=
7960374ef9d-20141121140749-1-kbuild branch=3Dtime/fortglx/3.19/time BOOT_IM=
AGE=3D/kernel/x86_64-randconfig-ha2-1109/59fa38d60ca4bc7a2efffae1b40aa79603=
74ef9d/vmlinuz-3.18.0-rc1-00274-g59fa38d drbd.minor_count=3D8
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
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
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
[    0.000000] found SMP MP-table at [mem 0x000fdb00-0x000fdb0f] mapped at =
[ffff8800000fdb00]
[    0.000000]   mpc: fdb10-fdbf0
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x03381000, 0x03381fff] PGTABLE
[    0.000000] BRK [0x03382000, 0x03382fff] PGTABLE
[    0.000000] BRK [0x03383000, 0x03383fff] PGTABLE
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
[    0.000000] BRK [0x03384000, 0x03384fff] PGTABLE
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
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
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
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 478 pages/cpu @ffff880013a00000 s1918720 r8=
192 d30976 u2097152
[    0.000000] pcpu-alloc: s1918720 r8192 d30976 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 13a0cd40
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-ha2-1109/time:fortglx:3.19:time/.vmlinuz-59fa38d60ca4bc7a2efffa=
e1b40aa7960374ef9d-20141121140749-1-kbuild branch=3Dtime/fortglx/3.19/time =
BOOT_IMAGE=3D/kernel/x86_64-randconfig-ha2-1109/59fa38d60ca4bc7a2efffae1b40=
aa7960374ef9d/vmlinuz-3.18.0-rc1-00274-g59fa38d drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standar=
d form
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 278796K/327280K available (8914K kernel code, 5378K =
rwdata, 6144K rodata, 2916K init, 11640K bss, 48484K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D1
[    0.000000] NR_IRQS:4352 nr_irqs:48 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8639 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]                  A-B-B-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]              A-B-B-C-C-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]              A-B-C-A-B-C deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |faile=
d|failed|failed|
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |  ok  |     =
        |failed|
[    0.000000]            recursive read-lock #2:             |  ok  |     =
        |failed|
[    0.000000]             mixed read-write-lock:             |failed|     =
        |failed|
[    0.000000]             mixed write-read-lock:             |failed|     =
        |failed|
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:failed|failed|  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/123:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/132:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/213:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/231:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/312:failed|failed|  ok  |
[    0.000000]       hard-irq lock-inversion/321:failed|failed|  ok  |
[    0.000000]       soft-irq lock-inversion/321:failed|failed|  ok  |
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
[    0.000000]                ww contexts mixing:failed|  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]            spinlock nest unlocked:  ok  |
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:failed|  ok  |  ok  |
[    0.000000]                               try:failed|  ok  |failed|
[    0.000000]                             block:failed|  ok  |failed|
[    0.000000]                          spinlock:failed|  ok  |failed|
[    0.000000] --------------------------------------------------------
[    0.000000] 141 out of 253 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.528 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 5389.51 Bogo=
MIPS (lpj=3D8978426)
[    0.008488] pid_max: default: 32768 minimum: 301
[    0.010060] ACPI: Core revision 20140828
[    0.022153] ACPI: All ACPI Tables successfully acquired
[    0.023506] Security Framework initialized
[    0.024979] Smack:  Initializing.
[    0.026741] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.028632] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.030990] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.030990] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.061539] Freeing SMP alternatives memory: 24K (ffffffff8281b000 - fff=
fffff82821000)
[    0.069055] Getting VERSION: 1050014
[    0.070017] Getting VERSION: 1050014
[    0.073350] Getting ID: 0
[    0.074548] Getting ID: ff000000
[    0.076688] Getting LVT0: 8700
[    0.080012] Getting LVT1: 8400
[    0.081395] enabled ExtINT on CPU#0
[    0.087871] ENABLING IO-APIC IRQs
[    0.089230] init IO_APIC IRQs
[    0.090011]  apic 0 pin 0 not connected
[    0.093385] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.096707] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.100037] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.103370] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.106701] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.110038] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.113372] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.116708] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.120039] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.123371] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.126128] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.126704] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.130036] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.133370] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.136706] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.140039] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.143364]  apic 0 pin 16 not connected
[    0.146674]  apic 0 pin 17 not connected
[    0.150008]  apic 0 pin 18 not connected
[    0.151422]  apic 0 pin 19 not connected
[    0.153341]  apic 0 pin 20 not connected
[    0.154749]  apic 0 pin 21 not connected
[    0.156675]  apic 0 pin 22 not connected
[    0.160008]  apic 0 pin 23 not connected
[    0.163493] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.165257] smpboot: CPU0: Intel Core Processor (Haswell) (fam: 06, mode=
l: 3c, stepping: 01)
[    0.170053] TSC deadline timer enabled
[    0.171502] Performance Events: unsupported p6 CPU model 60 no PMU drive=
r, software events only.
[    0.176149] x86: Booted up 1 node, 1 CPUs
[    0.176684] smpboot: Total of 1 processors activated (5389.51 BogoMIPS)
[    0.183520] evm: security.SMACK64
[    0.184833] evm: security.SMACK64EXEC
[    0.186171] evm: security.SMACK64TRANSMUTE
[    0.186677] evm: security.SMACK64MMAP
[    0.188017] evm: security.ima
[    0.189243] evm: security.capability
[    0.195634] prandom: seed boundary self test passed
[    0.197373] prandom: 100 self tests passed
[    0.199323] NET: Registered protocol family 16
[    0.201156] cpuidle: using governor ladder
[    0.203356] cpuidle: using governor menu
[    0.205282] ACPI: bus type PCI registered
[    0.206678] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.208673] dca service started, version 1.12.1
[    0.210086] PCI: Using configuration type 1 for base access
[    0.224810] Running resizable hashtable tests...
[    0.226378]   Adding 2048 keys
[    0.227901]   Traversal complete: counted=3D2048, nelems=3D2048, entries=
=3D2048
[    0.229999]   Table expansion iteration 0...
[    0.231883]   Verifying lookups...
[    0.233533]   Table expansion iteration 1...
[    0.235862]   Verifying lookups...
[    0.236870]   Table expansion iteration 2...
[    0.240819]   Verifying lookups...
[    0.242375]   Table expansion iteration 3...
[    0.245030]   Verifying lookups...
[    0.246586]   Table shrinkage iteration 0...
[    0.246921]   Verifying lookups...
[    0.248468]   Table shrinkage iteration 1...
[    0.249999]   Verifying lookups...
[    0.253518]   Table shrinkage iteration 2...
[    0.255058]   Verifying lookups...
[    0.256548]   Table shrinkage iteration 3...
[    0.256710]   Verifying lookups...
[    0.258210]   Deleting 2048 keys
[    0.260656] ACPI: Added _OSI(Module Device)
[    0.263347] ACPI: Added _OSI(Processor Device)
[    0.264841] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.266479] ACPI: Added _OSI(Processor Aggregator Device)
[    0.271131] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.286135] ACPI: Interpreter enabled
[    0.286689] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140828/hwxface-580)
[    0.290017] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140828/hwxface-580)
[    0.293422] ACPI: (supports S0 S3 S4 S5)
[    0.294882] ACPI: Using IOAPIC for interrupt routing
[    0.296624] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.317464] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.319357] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments]
[    0.320048] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.325346] acpiphp: Slot [3] registered
[    0.326793] acpiphp: Slot [4] registered
[    0.328418] acpiphp: Slot [5] registered
[    0.329962] acpiphp: Slot [6] registered
[    0.330117] acpiphp: Slot [7] registered
[    0.331696] acpiphp: Slot [8] registered
[    0.333233] acpiphp: Slot [9] registered
[    0.333453] acpiphp: Slot [10] registered
[    0.335019] acpiphp: Slot [11] registered
[    0.336641] acpiphp: Slot [12] registered
[    0.336814] acpiphp: Slot [13] registered
[    0.338396] acpiphp: Slot [14] registered
[    0.339998] acpiphp: Slot [15] registered
[    0.340531] acpiphp: Slot [24] registered
[    0.342652] acpiphp: Slot [25] registered
[    0.343450] acpiphp: Slot [26] registered
[    0.345043] acpiphp: Slot [27] registered
[    0.346627] acpiphp: Slot [28] registered
[    0.347347] acpiphp: Slot [29] registered
[    0.348950] acpiphp: Slot [30] registered
[    0.350125] acpiphp: Slot [31] registered
[    0.351604] PCI host bridge to bus 0000:00
[    0.353137] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.353347] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.355263] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.356680] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.358702] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.360106] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.363072] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.364720] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.369477] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.371273] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.373347] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.375334] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.376679] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.379399] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.380685] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.383363] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.386246] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.391884] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.395191] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.403452] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.407420] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.410015] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.413134] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.418931] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.420757] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.423320] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.428045] pci_bus 0000:00: on NUMA node 0
[    0.431572] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.433700] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.436510] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.438526] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.441113] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.444261] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.447023] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.448870] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.450016] vgaarb: loaded
[    0.451283] vgaarb: bridge control possible 0000:00:02.0
[    0.453724] SCSI subsystem initialized
[    0.455650] libata version 3.00 loaded.
[    0.456763] ACPI: bus type USB registered
[    0.458453] usbcore: registered new interface driver usbfs
[    0.460123] usbcore: registered new interface driver hub
[    0.461962] usbcore: registered new device driver usb
[    0.463716] pps_core: LinuxPPS API ver. 1 registered
[    0.465459] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.466845] wmi: Mapper loaded
[    0.468591] PCI: Using ACPI for IRQ routing
[    0.470018] PCI: pci_cache_line_size set to 64 bytes
[    0.471911] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.473361] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.476435] NET: Registered protocol family 8
[    0.476682] NET: Registered protocol family 20
[    0.478383] NetLabel: Initializing
[    0.479772] NetLabel:  domain hash size =3D 128
[    0.480010] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.481775] NetLabel:  unlabeled traffic allowed by default
[    0.483921] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.486117] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.489933] Switched to clocksource kvm-clock
[    0.489933] Warning: could not register all branches stats
[    0.491673] Warning: could not register annotated branches stats
[    0.500012] ------------[ cut here ]------------
[    0.500012] WARNING: CPU: 0 PID: 1 at kernel/time/timekeeping.c:1337 upd=
ate_wall_time+0x5d8/0x8dc()
[    0.500012] Modules linked in:
[    0.500012] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc1-00274-g=
59fa38d #496
[    0.500012] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.500012]  0000000000000009 ffff880013a03e58 ffffffff818a545a 00000000=
00000000
[    0.500012]  0000000000000000 ffff880013a03e98 ffffffff810cd4d6 00000001=
00000000
[    0.500012]  ffffffff811659ec 0000000000002201 0000000000000001 00000000=
00000001
[    0.500012] Call Trace:
[    0.500012]  <IRQ>  [<ffffffff818a545a>] dump_stack+0x7e/0xaa
[    0.500012]  [<ffffffff810cd4d6>] warn_slowpath_common+0x98/0xb2
[    0.500012]  [<ffffffff811659ec>] ? update_wall_time+0x5d8/0x8dc
[    0.500012]  [<ffffffff810cd593>] warn_slowpath_null+0x1a/0x1c
[    0.500012]  [<ffffffff811659ec>] update_wall_time+0x5d8/0x8dc
[    0.500012]  [<ffffffff8116c91c>] tick_periodic+0x9d/0xc6
[    0.500012]  [<ffffffff8116cb91>] ? tick_handle_periodic+0x27/0xa7
[    0.500012]  [<ffffffff8116cb91>] tick_handle_periodic+0x27/0xa7
[    0.500012]  [<ffffffff8103ba1d>] local_apic_timer_interrupt+0x6c/0x70
[    0.500012]  [<ffffffff818b3de3>] smp_apic_timer_interrupt+0x40/0x52
[    0.500012]  [<ffffffff818b2a82>] apic_timer_interrupt+0x72/0x80
[    0.500012]  <EOI>  [<ffffffff811244ec>] ? __lock_acquire+0x7f4/0xc24
[    0.500012]  [<ffffffff811249e8>] ? lock_acquire+0xcc/0x12b
[    0.500012]  [<ffffffff81255903>] ? __d_instantiate+0x33/0x1c7
[    0.500012]  [<ffffffff818b0712>] _raw_spin_lock+0x36/0x84
[    0.500012]  [<ffffffff81255903>] ? __d_instantiate+0x33/0x1c7
[    0.500012]  [<ffffffff81255903>] __d_instantiate+0x33/0x1c7
[    0.500012]  [<ffffffff8125826f>] d_instantiate+0x7f/0xb1
[    0.500012]  [<ffffffff8126d12e>] simple_lookup+0x76/0x84
[    0.500012]  [<ffffffff81243b9a>] lookup_real+0x6d/0xb6
[    0.500012]  [<ffffffff812452b5>] __lookup_hash+0x42/0x49
[    0.500012]  [<ffffffff8124a95c>] lookup_one_len+0x224/0x233
[    0.500012]  [<ffffffff81388d70>] __create_file+0xbf/0x24c
[    0.500012]  [<ffffffff81388f1e>] debugfs_create_file+0x21/0x23
[    0.500012]  [<ffffffff81191990>] trace_create_file+0x12/0x33
[    0.500012]  [<ffffffff8119a176>] event_create_dir+0x36b/0x411
[    0.500012]  [<ffffffff82741dcf>] event_trace_init+0x1b9/0x23c
[    0.500012]  [<ffffffff82741c16>] ? event_trace_enable+0x170/0x170
[    0.500012]  [<ffffffff81000391>] do_one_initcall+0x14d/0x257
[    0.500012]  [<ffffffff810f3a28>] ? parse_args+0x352/0x433
[    0.500012]  [<ffffffff82718565>] kernel_init_freeable+0x111/0x1da
[    0.500012]  [<ffffffff8189c993>] ? rest_init+0xc7/0xc7
[    0.500012]  [<ffffffff8189c9a1>] kernel_init+0xe/0x157
[    0.500012]  [<ffffffff818b1a7c>] ret_from_fork+0x7c/0xb0
[    0.500012]  [<ffffffff8189c993>] ? rest_init+0xc7/0xc7
[    0.500012] ---[ end trace e756a48c2bb7ada1 ]---
[    0.713574] FS-Cache: Loaded
[    0.715114] CacheFiles: Loaded
[    0.716557] pnp: PnP ACPI init
[    0.718221] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.721419] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.723539] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.726559] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.728715] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.731825] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.733974] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.736935] pnp 00:03: [dma 2]
[    0.738397] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.740565] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.743622] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.745793] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.748852] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.751049] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.754070] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.757131] pnp: PnP ACPI: found 7 devices
[    0.770654] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.772514] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.774381] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.776401] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.778544] NET: Registered protocol family 2
[    0.781159] TCP established hash table entries: 4096 (order: 3, 32768 by=
tes)
[    0.783387] TCP bind hash table entries: 4096 (order: 6, 327680 bytes)
[    0.785887] TCP: Hash tables configured (established 4096 bind 4096)
[    0.788269] TCP: reno registered
[    0.789645] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    0.791662] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    0.794165] NET: Registered protocol family 1
[    0.795835] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.797780] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.799645] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.801678] pci 0000:00:02.0: Video device with shadowed ROM
[    0.803563] PCI: CLS 0 bytes, default 64
[    0.805766] Unpacking initramfs...
[    0.977302] Freeing initrd memory: 3112K (ffff880013ce6000 - ffff880013f=
f0000)
[    0.997203] AVX version of gcm_enc/dec engaged.
[    0.998845] AES CTR mode by8 optimization enabled
[    1.002918] sha1_ssse3: Using AVX optimized SHA-1 implementation
[    1.009925] AVX2 or AES-NI instructions are not detected.
[    1.012007] AVX2 instructions are not detected.
[    1.013737] spin_lock-torture:--- Start of test [debug]: nwriters_stress=
=3D2 nreaders_stress=3D0 stat_interval=3D60 verbose=3D1 shuffle_interval=3D=
3 stutter=3D5 shutdown_secs=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    1.019139] spin_lock-torture: Creating torture_shuffle task
[    1.021473] spin_lock-torture: Creating torture_stutter task
[    1.023380] spin_lock-torture: torture_shuffle task started
[    1.025254] spin_lock-torture: Creating lock_torture_writer task
[    1.027265] spin_lock-torture: torture_stutter task started
[    1.029165] spin_lock-torture: Creating lock_torture_writer task
[    1.031170] spin_lock-torture: lock_torture_writer task started
[    1.033087] spin_lock-torture: Creating lock_torture_stats task
[    1.035085] spin_lock-torture: lock_torture_writer task started
[    1.038393] futex hash table entries: 256 (order: 3, 32768 bytes)
[    1.040418] spin_lock-torture: lock_torture_stats task started
[    1.042334] Initialise system trusted keyring
[    1.066815] ntfs: driver 2.1.31 [Flags: R/O DEBUG].
[    1.069139] efs: 1.0a - http://aeschi.ch.eu.org/efs/
[    1.072413] JFS: nTxBlock =3D 2202, nTxLock =3D 17620
[    1.078595] gfs2: GFS2 installed
[    1.086722] NET: Registered protocol family 38
[    1.088422] Key type asymmetric registered
[    1.089974] Asymmetric key parser 'x509' registered
[    1.092124] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 252)
[    1.095028] io scheduler noop registered (default)
[    1.097258] io scheduler cfq registered
[    1.098770] start plist test
[    1.108599] end plist test
[    1.110625] glob: 64 self-tests passed, 0 failed
[    1.113114] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.115177] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.117247] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver =
version: 0.1
[    1.120128] cpcihp_generic: not configured, disabling.
[    1.121999] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    1.124403] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    1.126566] HDLC line discipline maxframe=3D4096
[    1.128245] N_HDLC line discipline registered.
[    1.130136] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.159552] serial 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 1=
15200) is a 16550A
[    1.165442] serial: Freescale lpuart driver
[    1.167130] SyncLink GT
[    1.168466] SyncLink GT, tty major#247
[    1.170090] SyncLink GT no devices found
[    1.171690] SyncLink MultiPort driver $Revision: 4.38 $
[    1.185010] SyncLink MultiPort driver $Revision: 4.38 $, tty major#246
[    1.187081] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    1.189495] ac.o: No PCI boards found.
[    1.191065] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    1.194807] Non-volatile memory driver v1.3
[    1.196451] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    1.198376] smapi::smapi_init, ERROR invalid usSmapiID
[    1.200146] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    1.203446] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    1.206318] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    1.208399] Linux agpgart interface v0.103
[    1.210741] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    1.212991] lkdtm: No crash points registered, enable through debugfs
[    1.216104] Loading iSCSI transport class v2.0-870.
[    1.219162] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.221334] ehci-pci: EHCI PCI platform driver
[    1.223153] usbcore: registered new interface driver cdc_wdm
[    1.226147] usbcore: registered new interface driver mdc800
[    1.228615] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    1.231694] usbcore: registered new interface driver microtekX6
[    1.233688] usbcore: registered new interface driver cytherm
[    1.235676] usbcore: registered new interface driver emi26 - firmware lo=
ader
[    1.237933] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    1.240178] usbcore: registered new interface driver legousbtower
[    1.242277] usbcore: registered new interface driver rio500
[    1.244303] usbcore: registered new interface driver usbtest
[    1.246248] usbcore: registered new interface driver usbsevseg
[    1.248286] usbcore: registered new interface driver lvs
[    1.250108] usbip_core: usbip_core_init:761: USB/IP Core v1.0.0
[    1.252303] vhci_hcd: vhci_hcd_probe:1000: name vhci_hcd id -1
[    1.254341] vhci_hcd vhci_hcd: USB/IP Virtual Host Controller
[    1.256502] vhci_hcd vhci_hcd: new USB bus registered, assigned bus numb=
er 1
[    1.258741] vhci_hcd: vhci_start:883: enter vhci_start
[    1.262480] hub 1-0:1.0: USB hub found
[    1.264060] vhci_hcd: vhci_hub_control:244: typeReq a006 wValue 2900 wIn=
dex 0
[    1.266779] vhci_hcd: vhci_hub_control:302:  GetHubDescriptor
[    1.268720] vhci_hcd: vhci_hub_control:396: port -1
[    1.270480] vhci_hcd: vhci_hub_control:403:  bye
[    1.272263] hub 1-0:1.0: 8 ports detected
[    1.273886] vhci_hcd: vhci_hub_control:244: typeReq a000 wValue 0 wIndex=
 0
[    1.276040] vhci_hcd: vhci_hub_control:306:  GetHubStatus
[    1.277922] vhci_hcd: vhci_hub_control:396: port -1
[    1.279652] vhci_hcd: vhci_hub_control:403:  bye
[    1.282008] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 1
[    1.284140] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    1.286246] vhci_hcd: vhci_hub_control:396: port 0
[    1.287989] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    1.291059] vhci_hcd: dump_port_status_diff:115:  +POWER
[    1.292857] vhci_hcd: dump_port_status_diff:119:=20
[    1.294616] vhci_hcd: vhci_hub_control:403:  bye
[    1.296360] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 2
[    1.298530] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    1.300585] vhci_hcd: vhci_hub_control:396: port 1
[    1.302344] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    1.305418] vhci_hcd: dump_port_status_diff:115:  +POWER
[    1.318676] vhci_hcd: dump_port_status_diff:119:=20
[    1.320404] vhci_hcd: vhci_hub_control:403:  bye
[    1.322149] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 3
[    1.324341] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    1.326369] vhci_hcd: vhci_hub_control:396: port 2
[    1.328118] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    1.331181] vhci_hcd: dump_port_status_diff:115:  +POWER
[    1.333001] vhci_hcd: dump_port_status_diff:119:=20
[    1.334744] vhci_hcd: vhci_hub_control:403:  bye
[    1.336481] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 4
[    1.338642] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    1.340703] vhci_hcd: vhci_hub_control:396: port 3
[    1.342465] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    1.345542] vhci_hcd: dump_port_status_diff:115:  +POWER
[    1.347371] vhci_hcd: dump_port_status_diff:119:=20
[    1.349066] vhci_hcd: vhci_hub_control:403:  bye
[    1.350807] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 5
[    1.352956] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    1.355054] vhci_hcd: vhci_hub_control:396: port 4
[    1.356779] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    1.359814] vhci_hcd: dump_port_status_diff:115:  +POWER
[    1.361704] vhci_hcd: dump_port_status_diff:119:=20
[    1.363425] vhci_hcd: vhci_hub_control:403:  bye
[    1.365181] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 6
[    1.367338] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    1.369407] vhci_hcd: vhci_hub_control:396: port 5
[    1.371160] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    1.374221] vhci_hcd: dump_port_status_diff:115:  +POWER
[    1.376083] vhci_hcd: dump_port_status_diff:119:=20
[    1.377828] vhci_hcd: vhci_hub_control:403:  bye
[    1.379576] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 7
[    1.381742] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    1.383790] vhci_hcd: vhci_hub_control:396: port 6
[    1.385545] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    1.388617] vhci_hcd: dump_port_status_diff:115:  +POWER
[    1.390440] vhci_hcd: dump_port_status_diff:119:=20
[    1.392147] vhci_hcd: vhci_hub_control:403:  bye
[    1.393886] vhci_hcd: vhci_hub_control:244: typeReq 2303 wValue 8 wIndex=
 8
[    1.396033] vhci_hcd: vhci_hub_control:382:  SetPortFeature: default 8
[    1.398126] vhci_hcd: vhci_hub_control:396: port 7
[    1.399824] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00000 -> 00000100
[    1.402907] vhci_hcd: dump_port_status_diff:115:  +POWER
[    1.404790] vhci_hcd: dump_port_status_diff:119:=20
[    1.406495] vhci_hcd: vhci_hub_control:403:  bye
[    1.408619] vhci_hcd: vhci_hcd_probe:1028: bye
[    1.410311] vhci_hcd: vhci_hcd_init:1150: USB/IP 'Virtual' Host Controll=
er (VHCI) Driver v1.0.0
[    1.413695] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    1.417987] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.419765] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.422317] mousedev: PS/2 mouse device common for all mice
[    1.425483] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    1.428766] usbcore: registered new interface driver bcm5974
[    1.430797] usbcore: registered new interface driver usb_acecad
[    1.432833] usbcore: registered new interface driver aiptek
[    1.435300] rtc_cmos 00:00: RTC can wake from S4
[    1.437408] rtc (null): alarm rollover: day
[    1.439344] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    1.441667] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    1.444461] Driver for 1-wire Dallas network protocol.
[    1.446402] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    1.448902] power_supply test_ac: uevent
[    1.450484] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    1.452406] power_supply test_ac: prop ONLINE=3D1
[    1.454125] power_supply test_ac: power_supply_changed
[    1.456043] power_supply test_ac: power_supply_changed_work
[    1.458111] power_supply test_ac: uevent
[    1.459659] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    1.461854] power_supply test_battery: uevent
[    1.463522] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    1.465581] power_supply test_battery: prop STATUS=3DDischarging
[    1.467552] power_supply test_ac: prop ONLINE=3D1
[    1.469297] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    1.471249] power_supply test_battery: prop HEALTH=3DGood
[    1.473038] power_supply test_battery: prop PRESENT=3D1
[    1.474874] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    1.476811] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    1.478821] power_supply test_battery: prop CHARGE_FULL=3D100
[    1.480709] power_supply test_battery: prop CHARGE_NOW=3D50
[    1.482513] power_supply test_battery: prop CAPACITY=3D50
[    1.484374] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    1.486331] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    1.488404] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    1.490468] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    1.492517] power_supply test_battery: prop MANUFACTURER=3DLinux
[    1.494485] power_supply test_battery: prop SERIAL_NUMBER=3D3.18.0-rc1-0=
0274-g59fa38d
[    1.497439] power_supply test_battery: prop TEMP=3D26
[    1.499173] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    1.501128] power_supply test_battery: power_supply_changed
[    1.503099] power_supply test_battery: power_supply_changed_work
[    1.505092] power_supply test_battery: uevent
[    1.506749] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    1.509015] power_supply test_usb: uevent
[    1.511582] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    1.513524] power_supply test_battery: prop STATUS=3DDischarging
[    1.515471] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    1.517395] power_supply test_battery: prop HEALTH=3DGood
[    1.519225] power_supply test_battery: prop PRESENT=3D1
[    1.521054] power_supply test_usb: prop ONLINE=3D1
[    1.522753] power_supply test_usb: power_supply_changed
[    1.524656] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    1.526555] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    1.528908] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    1.531910] Initializing HPQ6001 module
[    1.533592] hdaps: supported laptop not found!
[    1.535307] hdaps: driver init failed (ret=3D-19)!
[    1.537016] power_supply test_battery: prop CHARGE_FULL=3D100
[    1.538922] power_supply test_battery: prop CHARGE_NOW=3D50
[    1.540791] power_supply test_battery: prop CAPACITY=3D50
[    1.543023] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    1.545169] msi_wmi: This machine doesn't have neither MSI-hotkeys nor b=
acklight through WMI
[    1.549416] oprofile: using timer interrupt.
[    1.551151] drop_monitor: Initializing network drop monitor service
[    1.553394] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    1.555413] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    1.557421] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    1.559452] power_supply test_battery: prop MANUFACTURER=3DLinux
[    1.561515] Mirror/redirect action on
[    1.563035] Simple TC action Loaded
[    1.564798] ipip: IPv4 over IPv4 tunneling driver
[    1.566721] power_supply test_battery: prop SERIAL_NUMBER=3D3.18.0-rc1-0=
0274-g59fa38d
[    1.569688] power_supply test_battery: prop TEMP=3D26
[    1.572285] TCP: westwood registered
[    1.573781] TCP: hybla registered
[    1.575271] TCP: htcp registered
[    1.576655] TCP: vegas registered
[    1.578154] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    1.580097] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 1
[    1.582276] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 1
[    1.584283] vhci_hcd: vhci_hub_control:353:  GetPortStatus bye 100 0
[    1.586275] vhci_hcd: vhci_hub_control:396: port 0
[    1.588013] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    1.591083] vhci_hcd: dump_port_status_diff:115:   POWER
[    1.592890] vhci_hcd: dump_port_status_diff:119:=20
[    1.594644] vhci_hcd: vhci_hub_control:403:  bye
[    1.596384] TCP: yeah registered
[    1.597859] NET: Registered protocol family 17
[    1.599582] NET: Registered protocol family 15
[    1.601381] NET: Registered protocol family 4
[    1.603086] NET: Registered protocol family 5
[    1.604822] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 2
[    1.606958] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 2
[    1.608949] vhci_hcd: vhci_hub_control:353:  GetPortStatus bye 100 0
[    1.611013] vhci_hcd: vhci_hub_control:396: port 1
[    1.612720] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    1.615802] vhci_hcd: dump_port_status_diff:115:   POWER
[    1.617672] vhci_hcd: dump_port_status_diff:119:=20
[    1.619368] vhci_hcd: vhci_hub_control:403:  bye
[    1.621372] Key type dns_resolver registered
[    1.623027] Key type ceph registered
[    1.625312] libceph: loaded (mon/osd proto 15/24)
[    1.627246] batman_adv: B.A.T.M.A.N. advanced 2014.4.0 (compatibility ve=
rsion 15) loaded
[    1.630650] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 3
[    1.632792] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 3
[    1.634803] vhci_hcd: vhci_hub_control:353:  GetPortStatus bye 100 0
[    1.636821] vhci_hcd: vhci_hub_control:396: port 2
[    1.638568] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    1.641636] vhci_hcd: dump_port_status_diff:115:   POWER
[    1.643460] vhci_hcd: dump_port_status_diff:119:=20
[    1.645160] vhci_hcd: vhci_hub_control:403:  bye
[    1.646937]=20
[    1.646937] printing PIC contents
[    1.649360] ... PIC  IMR: ffff
[    1.650172] ... PIC  IRR: 1113
[    1.663632] ... PIC  ISR: 0000
[    1.665033] ... PIC ELCR: 0c00
[    1.666423] printing local APIC contents on CPU#0/0:
[    1.666941] ... APIC ID:      00000000 (0)
[    1.666941] ... APIC VERSION: 01050014
[    1.666941] ... APIC TASKPRI: 00000000 (00)
[    1.666941] ... APIC PROCPRI: 00000000
[    1.666941] ... APIC LDR: 01000000
[    1.666941] ... APIC DFR: ffffffff
[    1.666941] ... APIC SPIV: 000001ff
[    1.666941] ... APIC ISR field:
[    1.666941] 000000000000000000000000000000000000000000000000000000000000=
0000
[    1.666941] ... APIC TMR field:
[    1.666941] 000000000200000000000000000000000000000000000000000000000000=
0000
[    1.666941] ... APIC IRR field:
[    1.666941] 000000000000000000000000000000000000000000000000000000000000=
8000
[    1.666941] ... APIC ESR: 00000000
[    1.666941] ... APIC ICR: 00000831
[    1.666941] ... APIC ICR2: 01000000
[    1.666941] ... APIC LVTT: 000400ef
[    1.666941] ... APIC LVTPC: 00010000
[    1.666941] ... APIC LVT0: 00010700
[    1.666941] ... APIC LVT1: 00000400
[    1.666941] ... APIC LVTERR: 000000fe
[    1.666941] ... APIC TMICT: 00000000
[    1.666941] ... APIC TMCCT: 00000000
[    1.666941] ... APIC TDCR: 00000000
[    1.666941]=20
[    1.710389] number of MP IRQ sources: 15.
[    1.711954] number of IO-APIC #0 registers: 24.
[    1.713629] testing the IO APIC.......................
[    1.715457] IO APIC #0......
[    1.716785] .... register #00: 00000000
[    1.718347] .......    : physical APIC id: 00
[    1.719939] .......    : Delivery Type: 0
[    1.721572] .......    : LTS          : 0
[    1.723111] .... register #01: 00170011
[    1.724694] .......     : max redirection entries: 17
[    1.726456] .......     : PRQ implemented: 0
[    1.728100] .......     : IO APIC version: 11
[    1.729718] .... register #02: 00000000
[    1.731315] .......     : arbitration: 00
[    1.732836] .... IRQ redirection table:
[    1.734446] 1    0    0   0   0    0    0    00
[    1.736094] 0    0    0   0   0    1    1    31
[    1.737814] 0    0    0   0   0    1    1    30
[    1.739498] 0    0    0   0   0    1    1    33
[    1.741241] 1    0    0   0   0    1    1    34
[    1.742878] 1    1    0   0   0    1    1    35
[    1.744618] 0    0    0   0   0    1    1    36
[    1.746300] 0    0    0   0   0    1    1    37
[    1.747999] 0    0    0   0   0    1    1    38
[    1.749679] 0    1    0   0   0    1    1    39
[    1.751424] 1    1    0   0   0    1    1    3A
[    1.753061] 1    1    0   0   0    1    1    3B
[    1.754790] 0    0    0   0   0    1    1    3C
[    1.756478] 0    0    0   0   0    1    1    3D
[    1.758179] 0    0    0   0   0    1    1    3E
[    1.759841] 0    0    0   0   0    1    1    3F
[    1.761586] 1    0    0   0   0    0    0    00
[    1.763267] 1    0    0   0   0    0    0    00
[    1.764963] 1    0    0   0   0    0    0    00
[    1.766639] 1    0    0   0   0    0    0    00
[    1.768382] 1    0    0   0   0    0    0    00
[    1.770045] 1    0    0   0   0    0    0    00
[    1.771749] 1    0    0   0   0    0    0    00
[    1.773448] 1    0    0   0   0    0    0    00
[    1.775115] IRQ to pin mappings:
[    1.776596] IRQ0 -> 0:2
[    1.778143] IRQ1 -> 0:1
[    1.779651] IRQ3 -> 0:3
[    1.781227] IRQ4 -> 0:4
[    1.782706] IRQ5 -> 0:5
[    1.784279] IRQ6 -> 0:6
[    1.785756] IRQ7 -> 0:7
[    1.787298] IRQ8 -> 0:8
[    1.788813] IRQ9 -> 0:9
[    1.790351] IRQ10 -> 0:10
[    1.791903] IRQ11 -> 0:11
[    1.793476] IRQ12 -> 0:12
[    1.795032] IRQ13 -> 0:13
[    1.796574] IRQ14 -> 0:14
[    1.798150] IRQ15 -> 0:15
[    1.799686] .................................... done.
[    1.801587] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 4
[    1.803704] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 4
[    1.805686] vhci_hcd: vhci_hub_control:353:  GetPortStatus bye 100 0
[    1.807729] vhci_hcd: vhci_hub_control:396: port 3
[    1.809443] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    1.812520] vhci_hcd: dump_port_status_diff:115:   POWER
[    1.814383] vhci_hcd: dump_port_status_diff:119:=20
[    1.816047] vhci_hcd: vhci_hub_control:403:  bye
[    1.817826] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 5
[    1.819925] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 5
[    1.821945] vhci_hcd: vhci_hub_control:353:  GetPortStatus bye 100 0
[    1.823955] vhci_hcd: vhci_hub_control:396: port 4
[    1.825690] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    1.828754] vhci_hcd: dump_port_status_diff:115:   POWER
[    1.830577] vhci_hcd: dump_port_status_diff:119:=20
[    1.832308] vhci_hcd: vhci_hub_control:403:  bye
[    1.834572] Loading compiled-in X.509 certificates
[    1.837871] Loaded X.509 cert 'Magrathea: Glacier signing key: 01d27cf26=
089e473d0c94bcd134a7ad37bfa2d67'
[    1.842797] Key type encrypted registered
[    1.844646] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 6
[    1.846777] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 6
[    1.848762] vhci_hcd: vhci_hub_control:353:  GetPortStatus bye 100 0
[    1.850773] vhci_hcd: vhci_hub_control:396: port 5
[    1.852522] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    1.855575] vhci_hcd: dump_port_status_diff:115:   POWER
[    1.857399] vhci_hcd: dump_port_status_diff:119:=20
[    1.859094] vhci_hcd: vhci_hub_control:403:  bye
[    1.861139] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 7
[    1.863271] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 7
[    1.865287] vhci_hcd: vhci_hub_control:353:  GetPortStatus bye 100 0
[    1.867300] vhci_hcd: vhci_hub_control:396: port 6
[    1.869008] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    1.872070] vhci_hcd: dump_port_status_diff:115:   POWER
[    1.873886] vhci_hcd: dump_port_status_diff:119:=20
[    1.875611] vhci_hcd: vhci_hub_control:403:  bye
[    1.877887] ima: No TPM chip found, activating TPM-bypass!
[    1.880129] evm: HMAC attrs: 0x1
[    1.882323] vhci_hcd: vhci_hub_control:244: typeReq a300 wValue 0 wIndex=
 8
[    1.884489] vhci_hcd: vhci_hub_control:310:  GetPortStatus port 8
[    1.886437] vhci_hcd: vhci_hub_control:353:  GetPortStatus bye 100 0
[    1.888498] vhci_hcd: vhci_hub_control:396: port 7
[    1.890224] vhci_hcd: dump_port_status_diff:101: status prev -> new: 000=
00100 -> 00000100
[    1.893267] vhci_hcd: dump_port_status_diff:115:   POWER
[    1.895105] vhci_hcd: dump_port_status_diff:119:=20
[    1.896855] vhci_hcd: vhci_hub_control:403:  bye
[    1.898923] rtc_cmos 00:00: setting system clock to 2014-11-21 14:07:43 =
UTC (1416578863)
[    1.902006] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.903948] EDD information not available.
[    1.905874] geneve: Geneve driver
[    1.907380] PM: Hibernation image not present or could not be loaded
--C+ts3FVlLX8+P6JN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--C+ts3FVlLX8+P6JN--
