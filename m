Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbaLWDKF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 22:10:05 -0500
Received: from mga14.intel.com ([192.55.52.115]:64925 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbaLWDKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 22:10:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,628,1413270000"; 
   d="scan'208";a="658804423"
Date: Mon, 22 Dec 2014 19:09:56 -0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: [hwrng] WARNING: CPU: 0 PID: 1 at include/linux/kref.h:47
 set_current_rng()
Message-ID: <20141223030956.GA26839@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master

commit 3a2c0ba5ad00c018c0bef39a2224aca950aa33f2
Author:     Rusty Russell <rusty@rustcorp.com.au>
AuthorDate: Mon Dec 8 16:50:37 2014 +0800
Commit:     Herbert Xu <herbert@gondor.apana.org.au>
CommitDate: Mon Dec 22 23:02:39 2014 +1100

    hwrng: use reference counts on each struct hwrng.
    
    current_rng holds one reference, and we bump it every time we want
    to do a read from it.
    
    This means we only hold the rng_mutex to grab or drop a reference,
    so accessing /sys/devices/virtual/misc/hw_random/rng_current doesn't
    block on read of /dev/hwrng.
    
    Using a kref is overkill (we're always under the rng_mutex), but
    a standard pattern.
    
    This also solves the problem that the hwrng_fillfn thread was
    accessing current_rng without a lock, which could change (eg. to NULL)
    underneath it.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Amos Kong <akong@redhat.com>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

+----------------------------------------------------+------------+------------+------------+
|                                                    | 1dacb395d6 | 3a2c0ba5ad | 02e375a39e |
+----------------------------------------------------+------------+------------+------------+
| boot_successes                                     | 60         | 0          | 0          |
| boot_failures                                      | 0          | 20         | 12         |
| WARNING:at_include/linux/kref.h:#set_current_rng() | 0          | 20         | 12         |
| backtrace:hwrng_register                           | 0          | 20         | 12         |
| backtrace:rng_init                                 | 0          | 20         | 12         |
| backtrace:kernel_init_freeable                     | 0          | 20         | 12         |
| Out_of_memory:Kill_process                         | 0          | 0          | 1          |
+----------------------------------------------------+------------+------------+------------+

[    0.408729] Initializing Nozomi driver 2.1d
[    0.410251] Non-volatile memory driver v1.3
[    0.411671] ------------[ cut here ]------------
[    0.413180] WARNING: CPU: 0 PID: 1 at include/linux/kref.h:47 set_current_rng+0x62/0x70()
[    0.416125] Modules linked in:
[    0.417407] CPU: 0 PID: 1 Comm: swapper Not tainted 3.19.0-rc1-g3a2c0ba #38
[    0.419428] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.421136]  ffffffff81a21a30 ffff880013857de8 ffffffff816f758d ffff880013857e28
[    0.424127]  ffffffff8107ce9a ffff880013857e38 ffffffff81c661c0 ffff880011caae10
[    0.426581]  ffffffff81c661c0 ffffffff81d129f1 0000000000000000 ffff880013857e38
[    0.429174] Call Trace:
[    0.430154]  [<ffffffff816f758d>] dump_stack+0x19/0x1b
[    0.431748]  [<ffffffff8107ce9a>] warn_slowpath_common+0x7a/0xb0
[    0.433367]  [<ffffffff81d129f1>] ? mod_init+0x12b/0x12b
[    0.434353]  [<ffffffff8107cf75>] warn_slowpath_null+0x15/0x20
[    0.435558]  [<ffffffff8136f772>] set_current_rng+0x62/0x70
[    0.436957]  [<ffffffff81370057>] hwrng_register+0x1c7/0x290
[    0.437944]  [<ffffffff81d12a01>] rng_init+0x10/0x12
[    0.439449]  [<ffffffff810002a4>] do_one_initcall+0x84/0x1c0
[    0.440413]  [<ffffffff81cec07a>] kernel_init_freeable+0xfd/0x185
[    0.441653]  [<ffffffff816f0840>] ? rest_init+0x80/0x80
[    0.442925]  [<ffffffff816f0849>] kernel_init+0x9/0xf0
[    0.444286]  [<ffffffff816fea7a>] ret_from_fork+0x7a/0xb0
[    0.445536]  [<ffffffff816f0840>] ? rest_init+0x80/0x80
[    0.446958] ---[ end trace 34fb80111662e761 ]---
[    0.447923] Linux agpgart interface v0.103

git bisect start 02e375a39e183e3f08e12de435a1970b78c4174c 97bf6af1f928216fd6c5a66e8a57bfa95a659672 --
git bisect good 8a29ac1839a7d7d6f680617f870045ce58be3712  # 06:41     20+      0  Merge 'asoc/topic/omap' into devel-lkp-nhm1-smoke-201412230619
git bisect good 5d49b0ab0d9968efbf70afe11f9fffe7d86e21d1  # 06:49     20+      0  Merge 'perf/perf/core' into devel-lkp-nhm1-smoke-201412230619
git bisect good 04b5f77135fd1646b65d9e73733e61859cf72add  # 06:56     20+      0  Merge 'ard.biesheuvel/efi-for-3.20' into devel-lkp-nhm1-smoke-201412230619
git bisect  bad c50aef250e8f1ff63132fd1d1a919b6774ff8635  # 06:59      0-      1  Merge 'asoc/topic/wm8750' into devel-lkp-nhm1-smoke-201412230619
git bisect good 8505c1fd22b13ebe27a4f76ab0db8dba9b10260a  # 07:07     20+      0  Merge 'hid/for-next' into devel-lkp-nhm1-smoke-201412230619
git bisect  bad f1954fab801041ec34f97557b8482bb3f2ea2a8d  # 07:15      0-     13  Merge 'cryptodev/master' into devel-lkp-nhm1-smoke-201412230619
git bisect good 9372b35e11149c5314f56f939775e67d83057604  # 07:23     20+      0  hwrng: place mutex around read functions and buffers.
git bisect  bad 2d2ec0642a85966b6a299bbcd94707982327ace8  # 07:26      0-     20  hwrng: don't init list element we're about to add to list.
git bisect  bad 3a2c0ba5ad00c018c0bef39a2224aca950aa33f2  # 07:31      0-     20  hwrng: use reference counts on each struct hwrng.
git bisect good 1dacb395d68a14825ee48c0843335e3181aea675  # 07:38     20+      0  hwrng: move some code out mutex_lock for avoiding underlying deadlock
# first bad commit: [3a2c0ba5ad00c018c0bef39a2224aca950aa33f2] hwrng: use reference counts on each struct hwrng.
git bisect good 1dacb395d68a14825ee48c0843335e3181aea675  # 07:40     60+      0  hwrng: move some code out mutex_lock for avoiding underlying deadlock
# extra tests on HEAD of linux-devel/devel-lkp-nhm1-smoke-201412230619
git bisect  bad 02e375a39e183e3f08e12de435a1970b78c4174c  # 07:40      0-     12  0day head guard for 'devel-lkp-nhm1-smoke-201412230619'
# extra tests on tree/branch cryptodev/master
git bisect  bad d3f6c142865badc82fa4d151766634b895d693e8  # 07:44      0-     22  crypto: ux500 - fix checkpatch errors
# extra tests on tree/branch linus/master
git bisect good 97bf6af1f928216fd6c5a66e8a57bfa95a659672  # 07:46     60+      1  Linux 3.19-rc1
# extra tests on tree/branch next/master
git bisect good f9f7b9d7aeedb0f6150bc9df08542c3a0b67a4ef  # 07:54     60+      0  Add linux-next specific files for 20141221


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

--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-kbuild-32:20141223072944:x86_64-randconfig-n0-12230617:3.19.0-rc1-g3a2c0ba:38"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Linux version 3.19.0-rc1-g3a2c0ba (kbuild@lkp-nhm1) (gcc ver=
sion 4.9.1 (Debian 4.9.1-19) ) #38 PREEMPT Tue Dec 23 07:26:12 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-n0-12230617/linux-devel:devel-lkp-nhm1-smoke-201412230619:3a2c0ba5ad00=
c018c0bef39a2224aca950aa33f2:bisect-linux-1/.vmlinuz-3a2c0ba5ad00c018c0bef3=
9a2224aca950aa33f2-20141223072715-19-kbuild branch=3Dlinux-devel/devel-lkp-=
nhm1-smoke-201412230619 BOOT_IMAGE=3D/kernel/x86_64-randconfig-n0-12230617/=
3a2c0ba5ad00c018c0bef39a2224aca950aa33f2/vmlinuz-3.19.0-rc1-g3a2c0ba drbd.m=
inor_count=3D8
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
[    0.000000] PAT configuration [0-7]: WB  WC  UC- UC  UC  UC  UC  UC =20
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdb00-0x000fdb0f] mapped at =
[ffff8800000fdb00]
[    0.000000]   mpc: fdb10-fdbf0
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01e95000, 0x01e95fff] PGTABLE
[    0.000000] BRK [0x01e96000, 0x01e96fff] PGTABLE
[    0.000000] BRK [0x01e97000, 0x01e97fff] PGTABLE
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
[    0.000000] BRK [0x01e98000, 0x01e98fff] PGTABLE
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
[    0.000000]   DMA32    [mem 0x01000000-0x13ffdfff]
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
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1c35d80
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-n0-12230617/linux-devel:devel-lkp-nhm1-smoke-201412230619:3a2c0=
ba5ad00c018c0bef39a2224aca950aa33f2:bisect-linux-1/.vmlinuz-3a2c0ba5ad00c01=
8c0bef39a2224aca950aa33f2-20141223072715-19-kbuild branch=3Dlinux-devel/dev=
el-lkp-nhm1-smoke-201412230619 BOOT_IMAGE=3D/kernel/x86_64-randconfig-n0-12=
230617/3a2c0ba5ad00c018c0bef39a2224aca950aa33f2/vmlinuz-3.19.0-rc1-g3a2c0ba=
 drbd.minor_count=3D8
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
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 302016K/327280K available (7178K kernel code, 932K r=
wdata, 3236K rodata, 880K init, 816K bss, 25264K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Linux version 3.19.0-rc1-g3a2c0ba (kbuild@lkp-nhm1) (gcc ver=
sion 4.9.1 (Debian 4.9.1-19) ) #38 PREEMPT Tue Dec 23 07:26:12 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-n0-12230617/linux-devel:devel-lkp-nhm1-smoke-201412230619:3a2c0ba5ad00=
c018c0bef39a2224aca950aa33f2:bisect-linux-1/.vmlinuz-3a2c0ba5ad00c018c0bef3=
9a2224aca950aa33f2-20141223072715-19-kbuild branch=3Dlinux-devel/devel-lkp-=
nhm1-smoke-201412230619 BOOT_IMAGE=3D/kernel/x86_64-randconfig-n0-12230617/=
3a2c0ba5ad00c018c0bef39a2224aca950aa33f2/vmlinuz-3.19.0-rc1-g3a2c0ba drbd.m=
inor_count=3D8
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
[    0.000000] PAT configuration [0-7]: WB  WC  UC- UC  UC  UC  UC  UC =20
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdb00-0x000fdb0f] mapped at =
[ffff8800000fdb00]
[    0.000000]   mpc: fdb10-fdbf0
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01e95000, 0x01e95fff] PGTABLE
[    0.000000] BRK [0x01e96000, 0x01e96fff] PGTABLE
[    0.000000] BRK [0x01e97000, 0x01e97fff] PGTABLE
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
[    0.000000] BRK [0x01e98000, 0x01e98fff] PGTABLE
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
[    0.000000]   DMA32    [mem 0x01000000-0x13ffdfff]
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
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1c35d80
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-n0-12230617/linux-devel:devel-lkp-nhm1-smoke-201412230619:3a2c0=
ba5ad00c018c0bef39a2224aca950aa33f2:bisect-linux-1/.vmlinuz-3a2c0ba5ad00c01=
8c0bef39a2224aca950aa33f2-20141223072715-19-kbuild branch=3Dlinux-devel/dev=
el-lkp-nhm1-smoke-201412230619 BOOT_IMAGE=3D/kernel/x86_64-randconfig-n0-12=
230617/3a2c0ba5ad00c018c0bef39a2224aca950aa33f2/vmlinuz-3.19.0-rc1-g3a2c0ba=
 drbd.minor_count=3D8
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
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 302016K/327280K available (7178K kernel code, 932K r=
wdata, 3236K rodata, 880K init, 816K bss, 25264K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.616 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 5387.23 Bogo=
MIPS (lpj=3D2693616)
[    0.004005] pid_max: default: 32768 minimum: 301
[    0.005011] ACPI: Core revision 20141107
[    0.007045] ACPI: All ACPI Tables successfully acquired
[    0.008185] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.009007] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.010155] Initializing cgroup subsys devices
[    0.011010] Initializing cgroup subsys blkio
[    0.012007] Initializing cgroup subsys perf_event
[    0.013008] Initializing cgroup subsys hugetlb
[    0.014106] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014106] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.016003] CPU: Intel Core Processor (Haswell) (fam: 06, model: 3c, ste=
pping: 01)
[    0.027567] Performance Events: unsupported p6 CPU model 60 no PMU drive=
r, software events only.
[    0.029153] Getting VERSION: 1050014
[    0.030011] Getting VERSION: 1050014
[    0.031010] Getting ID: 0
[    0.032013] Getting ID: ff000000
[    0.033016] Getting LVT0: 8700
[    0.034007] Getting LVT1: 8400
[    0.035076] enabled ExtINT on CPU#0
[    0.037128] ENABLING IO-APIC IRQs
[    0.038009] init IO_APIC IRQs
[    0.038825]  apic 0 pin 0 not connected
[    0.039008] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.040023] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.041020] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.042020] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.043020] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.044020] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.045020] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.046020] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.047020] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.048020] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.049021] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.050026] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.051020] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.052020] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.053021] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.054020] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.055018]  apic 0 pin 16 not connected
[    0.056003]  apic 0 pin 17 not connected
[    0.057003]  apic 0 pin 18 not connected
[    0.058003]  apic 0 pin 19 not connected
[    0.059003]  apic 0 pin 20 not connected
[    0.059959]  apic 0 pin 21 not connected
[    0.060003]  apic 0 pin 22 not connected
[    0.061003]  apic 0 pin 23 not connected
[    0.062152] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.063035] TSC deadline timer enabled
[    0.064000] devtmpfs: initialized
[    0.066267] pinctrl core: initialized pinctrl subsystem
[    0.067143] RTC time:  7:28:29, date: 12/23/14
[    0.068109] NET: Registered protocol family 16
[    0.074010] cpuidle: using governor ladder
[    0.080009] cpuidle: using governor menu
[    0.081137] ACPI: bus type PCI registered
[    0.082060] PCI: Using configuration type 1 for base access
[    0.090229] ACPI: Added _OSI(Module Device)
[    0.091006] ACPI: Added _OSI(Processor Device)
[    0.092012] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.093005] ACPI: Added _OSI(Processor Aggregator Device)
[    0.094484] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.096495] ACPI: Interpreter enabled
[    0.097010] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20141107/hwxface-580)
[    0.098670] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20141107/hwxface-580)
[    0.100017] ACPI: (supports S0 S3 S4 S5)
[    0.100951] ACPI: Using IOAPIC for interrupt routing
[    0.101022] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.104742] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.105011] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    0.106011] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.107163] PCI host bridge to bus 0000:00
[    0.108007] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.109007] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.110006] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.111006] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.112006] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.113051] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.114466] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.115607] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.118529] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.120036] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.121006] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.122006] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.123006] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.124212] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.125451] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.126018] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.127271] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.129685] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.131065] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.137065] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.138533] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.140007] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.142010] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.147511] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.148225] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.149565] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.153440] pci_bus 0000:00: on NUMA node 0
[    0.154474] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.156014] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.157711] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.158993] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.159946] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.160985] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.161438] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.162000] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.162005] vgaarb: loaded
[    0.162744] vgaarb: bridge control possible 0000:00:02.0
[    0.163294] SCSI subsystem initialized
[    0.164031] ACPI: bus type USB registered
[    0.165028] usbcore: registered new interface driver usbfs
[    0.166029] usbcore: registered new interface driver hub
[    0.167047] usbcore: registered new device driver usb
[    0.168093] media: Linux media interface: v0.10
[    0.169025] Linux video capture interface: v2.00
[    0.170034] pps_core: LinuxPPS API ver. 1 registered
[    0.171005] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.172075] wmi: Mapper loaded
[    0.172963] Advanced Linux Sound Architecture Driver Initialized.
[    0.173028] PCI: Using ACPI for IRQ routing
[    0.173997] PCI: pci_cache_line_size set to 64 bytes
[    0.174149] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.175009] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.176570] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.177136] Switched to clocksource kvm-clock
[    0.178153] FS-Cache: Loaded
[    0.178965] pnp: PnP ACPI init
[    0.179856] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.181706] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.183093] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.184923] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.186308] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.188147] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.189557] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.191351] pnp 00:03: [dma 2]
[    0.192174] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.193581] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.195395] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.196800] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.198637] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.200047] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.201860] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.203424] pnp: PnP ACPI: found 7 devices
[    0.211085] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.212289] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.213501] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.214802] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.216141] NET: Registered protocol family 1
[    0.217179] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.218454] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.219725] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.222687] pci 0000:00:02.0: Video device with shadowed ROM
[    0.223937] PCI: CLS 0 bytes, default 64
[    0.225035] Unpacking initramfs...
[    0.289150] Freeing initrd memory: 3112K (ffff880013ce6000 - ffff880013f=
f0000)
[    0.298041] AVX version of gcm_enc/dec engaged.
[    0.299114] AES CTR mode by8 optimization enabled
[    0.300621] sha256_ssse3: Using AVX optimized SHA-256 implementation
[    0.302329] AVX2 or AES-NI instructions are not detected.
[    0.303772] futex hash table entries: 256 (order: 0, 6144 bytes)
[    0.305316] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.308305] zpool: loaded
[    0.309901] NILFS version 2 loaded
[    0.311178] gfs2: GFS2 installed
[    0.312615] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    0.314330] io scheduler noop registered (default)
[    0.315947] crc32: CRC_LE_BITS =3D 32, CRC_BE BITS =3D 32
[    0.317079] crc32: self tests passed, processed 225944 bytes in 258432 n=
sec
[    0.318786] crc32c: CRC_LE_BITS =3D 32
[    0.319698] crc32c: self tests passed, processed 225944 bytes in 129709 =
nsec
[    0.341426] crc32_combine: 8373 self tests passed
[    0.363317] crc32c_combine: 8373 self tests passed
[    0.365139] intel_idle: does not run on family 6 model 60
[    0.379606] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.405412] serial 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 1=
15200) is a 16550A
[    0.408729] Initializing Nozomi driver 2.1d
[    0.410251] Non-volatile memory driver v1.3
[    0.411671] ------------[ cut here ]------------
[    0.413180] WARNING: CPU: 0 PID: 1 at include/linux/kref.h:47 set_curren=
t_rng+0x62/0x70()
[    0.416125] Modules linked in:
[    0.417407] CPU: 0 PID: 1 Comm: swapper Not tainted 3.19.0-rc1-g3a2c0ba =
#38
[    0.419428] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.421136]  ffffffff81a21a30 ffff880013857de8 ffffffff816f758d ffff8800=
13857e28
[    0.424127]  ffffffff8107ce9a ffff880013857e38 ffffffff81c661c0 ffff8800=
11caae10
[    0.426581]  ffffffff81c661c0 ffffffff81d129f1 0000000000000000 ffff8800=
13857e38
[    0.429174] Call Trace:
[    0.430154]  [<ffffffff816f758d>] dump_stack+0x19/0x1b
[    0.431748]  [<ffffffff8107ce9a>] warn_slowpath_common+0x7a/0xb0
[    0.433367]  [<ffffffff81d129f1>] ? mod_init+0x12b/0x12b
[    0.434353]  [<ffffffff8107cf75>] warn_slowpath_null+0x15/0x20
[    0.435558]  [<ffffffff8136f772>] set_current_rng+0x62/0x70
[    0.436957]  [<ffffffff81370057>] hwrng_register+0x1c7/0x290
[    0.437944]  [<ffffffff81d12a01>] rng_init+0x10/0x12
[    0.439449]  [<ffffffff810002a4>] do_one_initcall+0x84/0x1c0
[    0.440413]  [<ffffffff81cec07a>] kernel_init_freeable+0xfd/0x185
[    0.441653]  [<ffffffff816f0840>] ? rest_init+0x80/0x80
[    0.442925]  [<ffffffff816f0849>] kernel_init+0x9/0xf0
[    0.444286]  [<ffffffff816fea7a>] ret_from_fork+0x7a/0xb0
[    0.445536]  [<ffffffff816f0840>] ? rest_init+0x80/0x80
[    0.446958] ---[ end trace 34fb80111662e761 ]---
[    0.447923] Linux agpgart interface v0.103
[    0.448834] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    0.449915] Phantom Linux Driver, version n0.9.8, init OK
[    0.450870] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    0.452234] usbcore: registered new interface driver rtsx_usb
[    0.453414] usbcore: registered new interface driver viperboard
[    0.454691] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    0.456112] isci: Intel(R) C600 SAS Controller Driver - version 1.2.0
[    0.457872] 3ware 9000 Storage Controller device driver for Linux v2.26.=
02.014.
[    0.459653] osst :I: Tape driver with OnStream support version 0.99.4
[    0.459653] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    0.462558] Fusion MPT base driver 3.04.20
[    0.463593] Copyright (c) 1999-2008 LSI Corporation
[    0.464988] Fusion MPT SPI Host driver 3.04.20
[    0.466175] Fusion MPT misc device (ioctl) driver 3.04.20
[    0.467553] mptctl: Registered with Fusion MPT base driver
[    0.468812] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[    0.470386] uhci_hcd: USB Universal Host Controller Interface driver
[    0.471619] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    0.472666] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[    0.474847] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    0.478745] usbcore: registered new interface driver usblp
[    0.480114] usbcore: registered new interface driver usb-storage
[    0.481199] usbcore: registered new interface driver ums-alauda
[    0.482244] usbcore: registered new interface driver ums-datafab
[    0.483796] usbcore: registered new interface driver ums_eneub6250
[    0.485192] usbcore: registered new interface driver ums-freecom
[    0.486812] usbcore: registered new interface driver mdc800
[    0.488210] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    0.489967] usbcore: registered new interface driver idmouse
[    0.491489] usbcore: registered new interface driver iowarrior
[    0.492763] usbcore: registered new interface driver usblcd
[    0.494468] usbcore: registered new interface driver rio500
[    0.495896] usbcore: registered new interface driver usbtest
[    0.497323] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    0.500429] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.501507] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.594787] mousedev: PS/2 mouse device common for all mice
[    0.596903] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    0.599536] usbcore: registered new interface driver xpad
[    0.601016] usbcore: registered new interface driver usbtouchscreen
[    0.602553] usbcore: registered new interface driver sur40
[    0.604253] input: PC Speaker as /devices/platform/pcspkr/input/input2
[    0.606119] usbcore: registered new interface driver powermate
[    0.607698] usbcore: registered new interface driver yealink
[    0.609470] i2c /dev entries driver
[    0.610590] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[    0.636176] usbcore: registered new interface driver i2c-diolan-u2c
[    0.637849] saa7146: register extension 'av7110'
[    0.639122] saa7164 driver loaded
[    0.640157] usbcore: registered new interface driver ttusb-dec
[    0.641600] usbcore: registered new interface driver ttusb
[    0.642941] uvcvideo: Unable to create debugfs directory
[    0.644267] usbcore: registered new interface driver uvcvideo
[    0.645708] USB Video Class driver (1.1.1)
[    0.646826] au0828: au0828 driver loaded
[    0.647942] usbcore: registered new interface driver au0828
[    0.649340] Driver for 1-wire Dallas network protocol.
[    0.650718] power_supply test_ac: uevent
[    0.651780] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    0.653165] power_supply test_ac: prop ONLINE=3D1
[    0.654363] power_supply test_ac: power_supply_changed
[    0.655684] power_supply test_ac: power_supply_changed_work
[    0.657067] power_supply test_ac: uevent
[    0.658123] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    0.659549] power_supply test_battery: uevent
[    0.660704] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    0.662258] power_supply test_battery: prop STATUS=3DDischarging
[    0.663706] power_supply test_ac: prop ONLINE=3D1
[    0.664911] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    0.666282] power_supply test_battery: prop HEALTH=3DGood
[    0.667571] power_supply test_battery: prop PRESENT=3D1
[    0.668849] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    0.670273] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    0.671775] power_supply test_battery: prop CHARGE_FULL=3D100
[    0.673153] power_supply test_battery: prop CHARGE_NOW=3D50
[    0.674463] power_supply test_battery: prop CAPACITY=3D50
[    0.675750] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    0.677216] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    0.678727] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    0.680204] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    0.681700] power_supply test_battery: prop MANUFACTURER=3DLinux
[    0.683098] power_supply test_battery: prop SERIAL_NUMBER=3D3.19.0-rc1-g=
3a2c0ba
[    0.684741] power_supply test_battery: prop TEMP=3D26
[    0.686010] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    0.687501] power_supply test_battery: power_supply_changed
[    0.688911] power_supply test_battery: power_supply_changed_work
[    0.690355] power_supply test_battery: uevent
[    0.691490] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    0.693049] power_supply test_usb: uevent
[    0.694143] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    0.695564] power_supply test_usb: prop ONLINE=3D1
[    0.696788] power_supply test_battery: prop STATUS=3DDischarging
[    0.698195] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    0.699573] power_supply test_battery: prop HEALTH=3DGood
[    0.700876] power_supply test_usb: power_supply_changed
[    0.702374] power_supply test_battery: prop PRESENT=3D1
[    0.703674] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    0.705148] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    0.706609] power_supply test_battery: prop CHARGE_FULL=3D100
[    0.708027] power_supply test_battery: prop CHARGE_NOW=3D50
[    0.709379] power_supply test_battery: prop CAPACITY=3D50
[    0.710745] w83793: Detection failed at check vendor id
[    0.712101] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    0.713565] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    0.715080] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    0.716524] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    0.718103] power_supply test_battery: prop MANUFACTURER=3DLinux
[    0.719547] power_supply test_battery: prop SERIAL_NUMBER=3D3.19.0-rc1-g=
3a2c0ba
[    0.721234] w83793: Detection failed at check vendor id
[    0.722560] power_supply test_battery: prop TEMP=3D26
[    0.723785] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    0.725246] power_supply test_usb: power_supply_changed_work
[    0.726649] power_supply test_usb: uevent
[    0.727809] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    0.731052] w83793: Detection failed at check vendor id
[    0.732370] power_supply test_usb: prop ONLINE=3D1
[    0.738166] w83793: Detection failed at check vendor id
[    0.743054] i2c i2c-0: w83795: Detection failed at addr 0x2c, check bank
[    0.748061] i2c i2c-0: w83795: Detection failed at addr 0x2d, check bank
[    0.753056] i2c i2c-0: w83795: Detection failed at addr 0x2e, check bank
[    0.758053] i2c i2c-0: w83795: Detection failed at addr 0x2f, check bank
[    0.765637] i2c i2c-0: Detecting device at 0,0x2c with COMPANY: 0xff and=
 VERSTEP: 0xff
[    0.768778] i2c i2c-0: Autodetecting device at 0,0x2c...
[    0.770024] i2c i2c-0: Autodetection failed
[    0.777057] i2c i2c-0: Detecting device at 0,0x2d with COMPANY: 0xff and=
 VERSTEP: 0xff
[    0.778998] i2c i2c-0: Autodetecting device at 0,0x2d...
[    0.780245] i2c i2c-0: Autodetection failed
[    0.787059] i2c i2c-0: Detecting device at 0,0x2e with COMPANY: 0xff and=
 VERSTEP: 0xff
[    0.788974] i2c i2c-0: Autodetecting device at 0,0x2e...
[    0.790237] i2c i2c-0: Autodetection failed
[    0.795045] i2c i2c-0: detect fail: address match, 0x2c
[    0.800076] i2c i2c-0: detect fail: address match, 0x2d
[    0.806050] i2c i2c-0: detect fail: address match, 0x2e
[    0.810071] i2c i2c-0: detect fail: address match, 0x2f
[    0.815056]  (null): Wrong manufacturer ID. Got 255, expected 65
[    0.820063]  (null): Wrong manufacturer ID. Got 255, expected 65
[    0.825054]  (null): Wrong manufacturer ID. Got 255, expected 65
[    0.844061] applesmc: supported laptop not found!
[    0.845148] applesmc: driver init failed (ret=3D-19)!
[    0.870053]  (null): Unknown chip type, skipping
[    0.875051]  (null): Unknown chip type, skipping
[    0.940146] sch56xx_common: Unsupported device id: 0xff
[    0.941456] sch56xx_common: Unsupported device id: 0xff
[    0.944073] i2c i2c-0: amc6821_detect called.
[    0.949071] i2c i2c-0: amc6821: detection failed at 0x18.
[    0.952065] i2c i2c-0: amc6821_detect called.
[    0.957045] i2c i2c-0: amc6821: detection failed at 0x19.
[    0.960039] i2c i2c-0: amc6821_detect called.
[    0.964078] i2c i2c-0: amc6821: detection failed at 0x1a.
[    0.967056] i2c i2c-0: amc6821_detect called.
[    0.972063] i2c i2c-0: amc6821: detection failed at 0x2c.
[    0.975041] i2c i2c-0: amc6821_detect called.
[    0.979047] i2c i2c-0: amc6821: detection failed at 0x2d.
[    0.982053] i2c i2c-0: amc6821_detect called.
[    0.987045] i2c i2c-0: amc6821: detection failed at 0x2e.
[    0.990047] i2c i2c-0: amc6821_detect called.
[    0.995058] i2c i2c-0: amc6821: detection failed at 0x4c.
[    0.999040] i2c i2c-0: amc6821_detect called.
[    1.003078] i2c i2c-0: amc6821: detection failed at 0x4d.
[    1.006042] i2c i2c-0: amc6821_detect called.
[    1.011070] i2c i2c-0: amc6821: detection failed at 0x4e.
[    1.032203] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    1.034125] acquirewdt: I/O address 0x0043 already in use
[    1.035365] acquirewdt: probe of acquirewdt failed with error -5
[    1.036807] sc1200wdt: build 20020303
[    1.037781] sc1200wdt: io parameter must be specified
[    1.038976] pc87413_wdt: Version 1.1 at io 0x2E
[    1.040128] pc87413_wdt: initialized. timeout=3D1 min
[    1.041342] pc87413_wdt: cannot request SWC region at 0xffff
[    1.042660] nv_tco: NV TCO WatchDog Timer Driver v0.01
[    1.043946] sbc60xxwdt: WDT driver for 60XX single board computer initia=
lised. timeout=3D30 sec (nowayout=3D0)
[    1.046153] cpu5wdt: misc_register failed
[    1.047222] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    1.048576] machzwd: no ZF-Logic found
[    1.049668] leds_ss4200: no LED devices found
[    1.050753] No iBFT detected.
[    1.051624] hidraw: raw HID events driver (C) Jiri Kosina
[    1.053257] usbcore: registered new interface driver usbhid
[    1.054530] usbhid: USB HID core driver
[    1.055542] usbcore: registered new interface driver line6usb
[    1.057072] input: Speakup as /devices/virtual/input/input3
[    1.058486] initialized device: /dev/synth, node (MAJOR 10, MINOR 25)
[    1.059954] speakup 3.1.6: initialized
[    1.060944] synth name on entry is: (null)
[    1.062071] ashmem: initialized
[    1.063061] FPGA DOWNLOAD --->
[    1.063911] FPGA image file name: xlinx_fpga_firmware.bit
[    1.065213] GPIO INIT FAIL!!
[    1.067837] Motu MidiTimePiece on parallel port irq: 7 ioport: 0x378
[    1.069316] usbcore: registered new interface driver snd-usb-6fire
[    1.071376] ... APIC ID:      00000000 (0)
[    1.072007] ... APIC VERSION: 01050014
[    1.072007] 000000000000000000000000000000000000000000000000000000000000=
0000
[    1.072007] 000000000200000000000000000000000000000000000000000000000000=
0000
[    1.072007] 000000000000000000000000000000000000000000000000000000000000=
8000
[    1.072007]=20
[    1.081446] number of MP IRQ sources: 15.
[    1.082458] number of IO-APIC #0 registers: 24.
[    1.083571] testing the IO APIC.......................
[    1.084789] IO APIC #0......
[    1.085624] .... register #00: 00000000
[    1.086602] .......    : physical APIC id: 00
[    1.087668] .......    : Delivery Type: 0
[    1.088688] .......    : LTS          : 0
[    1.089709] .... register #01: 00170011
[    1.090693] .......     : max redirection entries: 17
[    1.091876] .......     : PRQ implemented: 0
[    1.092940] .......     : IO APIC version: 11
[    1.094014] .... register #02: 00000000
[    1.094982] .......     : arbitration: 00
[    1.096003] .... IRQ redirection table:
[    1.097003] 1    0    0   0   0    0    0    00
[    1.098117] 0    0    0   0   0    1    1    31
[    1.099237] 0    0    0   0   0    1    1    30
[    1.100349] 0    0    0   0   0    1    1    33
[    1.101469] 1    0    0   0   0    1    1    34
[    1.102585] 1    1    0   0   0    1    1    35
[    1.103700] 0    0    0   0   0    1    1    36
[    1.104815] 0    0    0   0   0    1    1    37
[    1.105936] 0    0    0   0   0    1    1    38
[    1.107053] 0    1    0   0   0    1    1    39
[    1.108166] 1    1    0   0   0    1    1    3A
[    1.109296] 1    1    0   0   0    1    1    3B
[    1.110402] 0    0    0   0   0    1    1    3C
[    1.111507] 0    0    0   0   0    1    1    3D
[    1.112618] 0    0    0   0   0    1    1    3E
[    1.113735] 0    0    0   0   0    1    1    3F
[    1.114848] 1    0    0   0   0    0    0    00
[    1.115959] 1    0    0   0   0    0    0    00
[    1.117082] 1    0    0   0   0    0    0    00
[    1.118190] 1    0    0   0   0    0    0    00
[    1.119306] 1    0    0   0   0    0    0    00
[    1.120415] 1    0    0   0   0    0    0    00
[    1.121538] 1    0    0   0   0    0    0    00
[    1.122651] 1    0    0   0   0    0    0    00
[    1.123751] IRQ to pin mappings:
[    1.124634] IRQ0 -> 0:2
[    1.125626] IRQ1 -> 0:1
[    1.126606] IRQ3 -> 0:3
[    1.127589] IRQ4 -> 0:4
[    1.128624] IRQ5 -> 0:5
[    1.129581] IRQ6 -> 0:6
[    1.130528] IRQ7 -> 0:7
[    1.131465] IRQ8 -> 0:8
[    1.132417] IRQ9 -> 0:9
[    1.133362] IRQ10 -> 0:10
[    1.134335] IRQ11 -> 0:11
[    1.135312] IRQ12 -> 0:12
[    1.136295] IRQ13 -> 0:13
[    1.137271] IRQ14 -> 0:14
[    1.138246] IRQ15 -> 0:15
[    1.139234] .................................... done.
[    1.140855]   Magic number: 10:432:471
[    1.141967] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    1.143857] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.145170] EDD information not available.
[    1.146208] PM: Hibernation image not present or could not be loaded
--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--jRHKVT23PllUwdXP--
