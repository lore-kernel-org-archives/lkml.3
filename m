Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbaH1EOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 00:14:36 -0400
Received: from mga14.intel.com ([192.55.52.115]:61152 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbaH1EOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 00:14:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,415,1406617200"; 
   d="scan'208";a="582706659"
Date: Thu, 28 Aug 2014 12:14:04 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [xhci] kernel BUG at arch/x86/mm/physaddr.c:26!
Message-ID: <20140828041404.GB4252@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="EuxKj2iCbKjpUGkD"
Content-Disposition: inline
In-Reply-To: <20140827170931.GA27641@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EuxKj2iCbKjpUGkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dan,

Just in case it helps, here we find a different bug message in the
same commit.

git://git.kernel.org/pub/scm/linux/kernel/git/djbw/usb.git td-fragments-v1

commit e65e21a542cab81d794db4e5fe919c4e1d624ea7
Author:     Dan Williams <dan.j.williams@intel.com>
AuthorDate: Tue Jul 22 00:08:51 2014 -0700
Commit:     Dan Williams <dan.j.williams@intel.com>
CommitDate: Fri Aug 22 10:06:50 2014 -0700

    xhci: unit test ring enqueue/dequeue routines
    
    Given the complexity of satisfying xhci 1.0+ host trb boundary
    constraints, provide a test case that exercises inserting mid-segment
    links into a ring.
    
    The linker --wrap= option is used to not pollute the global identifier
    space and to make it clear which standard xhci driver routines are being
    mocked-up.  The --wrap= option does not come into play when both
    xhci-hcd and xhci-test are built-in to the kernel, so namespace
    collisions are prevented by excluding xhci-test from the build when
    xhci-hcd is built-in.
    
    It's unfortunate that this is an in-kernel test rather than userspace
    and that the infrastructure is custom rather than generic.  That said,
    it serves its purpose of exercising the corner cases of the scatterlist
    parsing implementation in xhci.
    
    Cc: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

+------------------------------------------+------------+------------+
|                                          | fb6fa3e625 | e65e21a542 |
+------------------------------------------+------------+------------+
| boot_successes                           | 60         | 0          |
| boot_failures                            | 0          | 20         |
| kernel_BUG_at_arch/x86/mm/physaddr.c     | 0          | 20         |
| invalid_opcode                           | 0          | 20         |
| RIP:__phys_addr                          | 0          | 20         |
| Kernel_panic-not_syncing:Fatal_exception | 0          | 20         |
| backtrace:setup_test_skip64              | 0          | 20         |
| backtrace:xhci_test_init                 | 0          | 20         |
| backtrace:kernel_init_freeable           | 0          | 20         |
+------------------------------------------+------------+------------+

[    4.350603] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.351690] ohci-pci: OHCI PCI platform driver
[    4.353334] ------------[ cut here ]------------
[    4.353963] kernel BUG at arch/x86/mm/physaddr.c:26!
[    4.354861] invalid opcode: 0000 [#1] 
[    4.355395] CPU: 0 PID: 1 Comm: swapper Not tainted 3.16.0-rc5-00225-ge65e21a #6
[    4.356374] task: ffff880000160000 ti: ffff880000168000 task.ti: ffff880000168000
[    4.357360] RIP: 0010:[<ffffffff810709e7>]  [<ffffffff810709e7>] __phys_addr+0x51/0x7c
[    4.358429] RSP: 0000:ffff88000016bce0  EFLAGS: 00010206
[    4.359135] RAX: 000078000000ffe0 RBX: ffff880010328000 RCX: 0000000000000040
[    4.360029] RDX: 000000008000ffe0 RSI: 000000000000ffe0 RDI: 000000000000ffe0
[    4.360029] RBP: ffff88000016bce0 R08: ffffffff8164a813 R09: 00000001000d0001
[    4.360029] R10: 0000000000000040 R11: 0000000000000018 R12: 000000000000ffe0
[    4.360029] R13: 0000000000000040 R14: 000000000000ffe0 R15: 000000000000ffe0
[    4.360029] FS:  0000000000000000(0000) GS:ffffffff8287b000(0000) knlGS:0000000000000000
[    4.360029] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    4.360029] CR2: 0000000000000000 CR3: 0000000002841000 CR4: 00000000000006b0
[    4.360029] Stack:
[    4.360029]  ffff88000016bd08 ffffffff819c1ca5 ffff88000016be38 0000000000000000
[    4.360029]  0000000000000001 ffff88000016bd70 ffffffff819c5fd0 000000400016bd70
[    4.360029]  ffff880010328000 ffff88000016be04 ffff88000016be10 ffff880010260820
[    4.360029] Call Trace:
[    4.360029]  [<ffffffff819c1ca5>] sg_set_buf+0x21/0xb5
[    4.360029]  [<ffffffff819c5fd0>] setup_test_skip64+0x126/0x1b3
[    4.360029]  [<ffffffff830f6e5d>] xhci_test_init+0x229/0x862
[    4.360029]  [<ffffffff810ff671>] ? trace_hardirqs_on_caller+0x211/0x2cd
[    4.360029]  [<ffffffff819c5eaa>] ? setup_test_wrap64+0x21a/0x21a
[    4.360029]  [<ffffffff81efe6c0>] ? __slab_free+0x216/0x401
[    4.360029]  [<ffffffff810ff671>] ? trace_hardirqs_on_caller+0x211/0x2cd
[    4.360029]  [<ffffffff819c5eaa>] ? setup_test_wrap64+0x21a/0x21a
[    4.360029]  [<ffffffff819c605d>] ? setup_test_skip64+0x1b3/0x1b3
[    4.360029]  [<ffffffff819c5c90>] ? setup_test_dont_trim+0x200/0x200
[    4.360029]  [<ffffffff819c5a90>] ? xhci_ring_alloc+0x100/0x100
[    4.360029]  [<ffffffff830f6c34>] ? ohci_pci_init+0x7d/0x7d
[    4.360029]  [<ffffffff830b071d>] do_one_initcall+0x17c/0x26d
[    4.360029]  [<ffffffff810dd5db>] ? parameq+0x24/0x2d
[    4.360029]  [<ffffffff810dd875>] ? parse_args+0x291/0x3e4
[    4.360029]  [<ffffffff830b0b63>] kernel_init_freeable+0x355/0x461
[    4.360029]  [<ffffffff830af92a>] ? do_early_param+0xd7/0xd7
[    4.360029]  [<ffffffff81ef5194>] ? rest_init+0x218/0x218
[    4.360029]  [<ffffffff81ef51a4>] kernel_init+0x10/0x169
[    4.360029]  [<ffffffff81f16ffa>] ret_from_fork+0x7a/0xb0
[    4.360029]  [<ffffffff81ef5194>] ? rest_init+0x218/0x218
[    4.360029] Code: 76 52 48 ff 05 4b e2 19 02 0f 0b 48 ff 05 4a e2 19 02 48 b8 00 00 00 00 00 78 00 00 48 ff 05 29 e2 19 02 48 01 f8 48 39 d0 76 09 <0f> 0b 48 ff 05 40 e2 19 02 0f b6 0d d2 27 03 02 48 89 c2 48 ff 
[    4.360029] RIP  [<ffffffff810709e7>] __phys_addr+0x51/0x7c
[    4.360029]  RSP <ffff88000016bce0>
[    4.392028] ---[ end trace 68ef4c4340f54dcf ]---
[    4.392651] Kernel panic - not syncing: Fatal exception

git bisect start 87e45e9aee6e16808da24d42620c30e62ef78f72 52addcf9d6669fa439387610bc65c92fa0980cef --
git bisect good 21e7954c90927f091ef81611f7f186d8f2f068a7  # 02:54     20+      0  Merge 'ipvs/master' into devel-hourly-2014082801
git bisect good db76ed1b63ae17ebfbbcac90a25e9b15d7c81593  # 03:02     20+      0  Merge 'robclark/msm-fixes-3.17' into devel-hourly-2014082801
git bisect  bad d742d6a6a9ba64655ff7c57b5995f5e88e417c4d  # 03:06      0-     20  Merge 'xen-tip/devel/for-linus-3.18' into devel-hourly-2014082801
git bisect good b590845ddf136fab351e0fbed14e3d1b1e655d56  # 03:13     20+      1  Merge 'regulator/for-next' into devel-hourly-2014082801
git bisect  bad a768419190a3acf1db12e2e27d3589035d2ca713  # 03:24      0-     20  Merge 'djbw-usb/td-fragments-v1' into devel-hourly-2014082801
git bisect good e705f1f3500d34055a829cec1178012108c2b5aa  # 03:28     20+      0  Merge 'stericsson/tcm' into devel-hourly-2014082801
git bisect good a75ef911cf100b8cf7d25baf6dac8052328a96e7  # 03:39     20+      0  xhci: clarify "ring valid" checks
git bisect good 652b7ee36207f186f3d701675483df43b4845c5c  # 03:45     20+      0  xhci: kill ->num_trbs_free_temp in struct xhci_ring
git bisect good 1c11eb8545a3321e7ca27fc7ba8c56b6e6df2b57  # 03:51     20+      0  xhci: add xhci_ring_reap_td() helper
git bisect  bad e65e21a542cab81d794db4e5fe919c4e1d624ea7  # 03:56      0-     20  xhci: unit test ring enqueue/dequeue routines
git bisect good fb6fa3e625e1e453aea9eeb97d58bee30e1c0781  # 04:07     20+      0  xhci: v1.0 scatterlist enqueue support (td-fragment rework)
# first bad commit: [e65e21a542cab81d794db4e5fe919c4e1d624ea7] xhci: unit test ring enqueue/dequeue routines
git bisect good fb6fa3e625e1e453aea9eeb97d58bee30e1c0781  # 04:10     60+      0  xhci: v1.0 scatterlist enqueue support (td-fragment rework)
git bisect  bad 87e45e9aee6e16808da24d42620c30e62ef78f72  # 04:10      0-     11  0day head guard for 'devel-hourly-2014082801'
git bisect good ff0c57ac70434bc936cb0110eaf033a0a1a62e52  # 04:19     60+      5  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid
git bisect good d05446ae2128064a4bb8f74c84f6901ffb5c94bc  # 04:22     60+      0  Add linux-next specific files for 20140827


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

--EuxKj2iCbKjpUGkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-vp-51:20140828035557:x86_64-randconfig-hsxa2-08281025:3.16.0-rc5-00225-ge65e21a:6"
Content-Transfer-Encoding: quoted-printable

early console in setup code
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-rc5-00225-ge65e21a (kbuild@lkp-hsx01) (=
gcc version 4.8.2 (Debian 4.8.2-18) ) #6 Thu Aug 28 11:54:57 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-hsxa2-08281025/linux-devel:devel-hourly-2014082801:e65e21a542cab81d794=
db4e5fe919c4e1d624ea7:bisect-linux-5/.vmlinuz-e65e21a542cab81d794db4e5fe919=
c4e1d624ea7-20140828115559-4-vp branch=3Dlinux-devel/devel-hourly-201408280=
1 BOOT_IMAGE=3D/kernel/x86_64-randconfig-hsxa2-08281025/e65e21a542cab81d794=
db4e5fe919c4e1d624ea7/vmlinuz-3.16.0-rc5-00225-ge65e21a drbd.minor_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdad0-0x000fdadf] mapped at =
[ffff8800000fdad0]
[    0.000000]   mpc: fdae0-fdbe8
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x047f3000, 0x047f3fff] PGTABLE
[    0.000000] BRK [0x047f4000, 0x047f4fff] PGTABLE
[    0.000000] BRK [0x047f5000, 0x047f5fff] PGTABLE
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
[    0.000000] BRK [0x047f6000, 0x047f6fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD970 000014 (v00 BOCHS )
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
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA32 zone: 1280 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 81820 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 2890900
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
-randconfig-hsxa2-08281025/linux-devel:devel-hourly-2014082801:e65e21a542ca=
b81d794db4e5fe919c4e1d624ea7:bisect-linux-5/.vmlinuz-e65e21a542cab81d794db4=
e5fe919c4e1d624ea7-20140828115559-4-vp branch=3Dlinux-devel/devel-hourly-20=
14082801 BOOT_IMAGE=3D/kernel/x86_64-randconfig-hsxa2-08281025/e65e21a542ca=
b81d794db4e5fe919c4e1d624ea7/vmlinuz-3.16.0-rc5-00225-ge65e21a drbd.minor_c=
ount=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] Memory: 259740K/327280K available (15468K kernel code, 8717K=
 rwdata, 9208K rodata, 952K init, 22872K bss, 67540K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
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
[    0.000000]  memory used by lock dependency info: 8671 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
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
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.468 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5386.93 Bogo=
MIPS (lpj=3D26934680)
[    0.020000] pid_max: default: 4096 minimum: 301
[    0.020000] ACPI: Core revision 20140424
[    0.050175] ACPI: All ACPI Tables successfully acquired
[    0.050950] Security Framework initialized
[    0.051380] AppArmor: AppArmor initialized
[    0.051803] Yama: becoming mindful.
[    0.052266] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.052931] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.055559] Initializing cgroup subsys freezer
[    0.056033] Initializing cgroup subsys blkio
[    0.056483] Initializing cgroup subsys debug
[    0.057202] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.057202] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.057202] tlb_flushall_shift: -1
[    0.058613] CPU: GenuineIntel Common KVM processor (fam: 0f, model: 06, =
stepping: 01)
[    0.061148] Performance Events: no PMU driver, software events only.
[    0.062905] Getting VERSION: 50014
[    0.063241] Getting VERSION: 50014
[    0.063569] Getting ID: 0
[    0.063831] Getting ID: ff000000
[    0.064161] Getting LVT0: 8700
[    0.064458] Getting LVT1: 8400
[    0.064815] enabled ExtINT on CPU#0
[    0.065980] ENABLING IO-APIC IRQs
[    0.066303] init IO_APIC IRQs
[    0.066589]  apic 0 pin 0 not connected
[    0.066985] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.067748] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.068541] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.069330] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.070049] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.070710] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.071485] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.072251] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.073029] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.073780] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.074526] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.075322] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.076087] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.076890] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.077651] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.078455] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.079218]  apic 0 pin 16 not connected
[    0.079586]  apic 0 pin 17 not connected
[    0.080005]  apic 0 pin 18 not connected
[    0.080376]  apic 0 pin 19 not connected
[    0.080774]  apic 0 pin 20 not connected
[    0.081141]  apic 0 pin 21 not connected
[    0.081536]  apic 0 pin 22 not connected
[    0.081907]  apic 0 pin 23 not connected
[    0.082417] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.082963] Using local APIC timer interrupts.
[    0.082963] calibrating APIC timer ...
[    0.090000] ... lapic delta =3D 6250042
[    0.090000] ... PM-Timer delta =3D 357947
[    0.090000] ... PM-Timer result ok
[    0.090000] ..... delta 6250042
[    0.090000] ..... mult: 268437259
[    0.090000] ..... calibration result: 10000067
[    0.090000] ..... CPU clock speed is 2694.8065 MHz.
[    0.090000] ..... host bus clock speed is 1000.0067 MHz.
[    0.090000] gcov: version magic: 0x3430382a
[    0.090000] xor: measuring software checksum speed
[    0.180009]    prefetch64-sse: 12838.000 MB/sec
[    0.280004]    generic_sse: 12103.600 MB/sec
[    0.280413] xor: using function: prefetch64-sse (12838.000 MB/sec)
[    0.282408] regulator-dummy: no parameters
[    0.283700] NET: Registered protocol family 16
[    0.286499] cpuidle: using governor menu
[    0.287654] ACPI: bus type PCI registered
[    0.288116] PCI: Using configuration type 1 for base access
[    0.530019] raid6: sse2x1    3586 MB/s
[    0.700021] raid6: sse2x2    4124 MB/s
[    0.870018] raid6: sse2x4    4333 MB/s
[    0.870386] raid6: using algorithm sse2x4 (4333 MB/s)
[    0.870871] raid6: using intx1 recovery algorithm
[    0.871473] gpio-f7188x: Not a Fintek device at 0x0000002e
[    0.872054] gpio-f7188x: Not a Fintek device at 0x0000004e
[    0.874198] ACPI: Added _OSI(Module Device)
[    0.874604] ACPI: Added _OSI(Processor Device)
[    0.875054] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.875484] ACPI: Added _OSI(Processor Aggregator Device)
[    0.922478] ACPI: Interpreter enabled
[    0.922882] ACPI: (supports S0 S5)
[    0.923200] ACPI: Using IOAPIC for interrupt routing
[    0.923890] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.989797] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.990032] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.990676] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.996036] PCI host bridge to bus 0000:00
[    0.996448] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.996956] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.997528] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.998098] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.998733] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.999440] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.002265] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.005317] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.008529] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    1.010537] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    1.011210] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    1.011821] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    1.012514] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    1.015094] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.016027] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    1.016742] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    1.019489] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.024248] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.026189] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.033057] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.036320] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.037841] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    1.039346] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.044194] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    1.046890] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    1.048436] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    1.050006] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    1.057498] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    1.059046] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    1.060496] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    1.068003] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.070006] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    1.071470] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    1.078979] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.080491] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    1.081960] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    1.089442] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.091009] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    1.092469] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    1.099933] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.101005] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    1.102466] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    1.110450] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    1.111516] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    1.117248] pci_bus 0000:00: on NUMA node 0
[    1.124334] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.126546] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.128739] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.130945] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.132172] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    1.135477] ACPI: Enabled 16 GPEs in block 00 to 0F
[    1.140574] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.141321] vgaarb: loaded
[    1.141575] vgaarb: bridge control possible 0000:00:02.0
[    1.146774] SCSI subsystem initialized
[    1.147759] libata version 3.00 loaded.
[    1.148747] ACPI: bus type USB registered
[    1.149471] usbcore: registered new interface driver usbfs
[    1.150179] usbcore: registered new interface driver hub
[    1.150898] usbcore: registered new device driver usb
[    1.152429] media: Linux media interface: v0.10
[    1.153047] Linux video capture interface: v2.00
[    1.153715] pps_core: LinuxPPS API ver. 1 registered
[    1.154181] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.155092] PTP clock support registered
[    1.157353] Advanced Linux Sound Architecture Driver Initialized.
[    1.158061] PCI: Using ACPI for IRQ routing
[    1.158454] PCI: pci_cache_line_size set to 64 bytes
[    1.159136] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.159701] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    1.162229] NET: Registered protocol family 8
[    1.162644] NET: Registered protocol family 20
[    1.163221] NetLabel: Initializing
[    1.163547] NetLabel:  domain hash size =3D 128
[    1.163948] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    1.164606] NetLabel:  unlabeled traffic allowed by default
[    1.165315] nfc: nfc_init: NFC Core ver 0.1
[    1.165876] NET: Registered protocol family 39
[    1.167036] Switched to clocksource kvm-clock
[    1.168917] AppArmor: AppArmor Filesystem Enabled
[    1.169578] pnp: PnP ACPI init
[    1.169876] ACPI: bus type PNP registered
[    1.169876] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    1.169876] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.169876] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    1.169876] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.169876] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    1.169876] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.169876] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    1.170295] pnp 00:03: [dma 2]
[    1.170872] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.171948] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    1.172988] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.174081] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    1.175108] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.176184] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    1.177218] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.181327] pnp: PnP ACPI: found 7 devices
[    1.181717] ACPI: bus type PNP unregistered
[    1.189435] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.189955] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.190484] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.191057] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.191838] NET: Registered protocol family 2
[    1.193558] TCP established hash table entries: 4096 (order: 3, 32768 by=
tes)
[    1.194293] TCP bind hash table entries: 4096 (order: 6, 327680 bytes)
[    1.195405] TCP: Hash tables configured (established 4096 bind 4096)
[    1.196125] TCP: reno registered
[    1.196440] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    1.197059] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    1.198312] NET: Registered protocol family 1
[    1.199867] RPC: Registered named UNIX socket transport module.
[    1.200432] RPC: Registered udp transport module.
[    1.200868] RPC: Registered tcp transport module.
[    1.201299] RPC: Registered tcp NFSv4.1 backchannel transport module
--EuxKj2iCbKjpUGkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--EuxKj2iCbKjpUGkD--
