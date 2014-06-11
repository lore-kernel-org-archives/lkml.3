Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195AbaFKEFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 00:05:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:16279 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbaFKEFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 00:05:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,455,1400050800"; 
   d="log'?scan'208";a="444112927"
Message-ID: <5397D58C.3080703@intel.com>
Date: Wed, 11 Jun 2014 12:05:32 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Fengguang Wu <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yuanhan Liu <yuanhan.liu@intel.com>
Subject: [seccomp] kernel BUG at kernel/fork.c:1100!
Content-Type: multipart/mixed;
 boundary="------------060601010406010102040703"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060601010406010102040703
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Kees,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git seccomp-tsync-sighand
commit 8c959534443ab563ddbccdcfe6a0f2a4f6fcb863
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Wed May 21 15:18:02 2014 -0700
Commit:     Kees Cook <keescook@chromium.org>
CommitDate: Tue Jun 10 08:02:42 2014 -0700

    seccomp: introduce writer locking
        Normally, task_struct.seccomp.filter is only ever read or modified by
    the task that owns it (current). This property aids in fast access
    during system call filtering as read access is lockless.
        Updating the pointer from another task, however, opens up race
    conditions. To allow cross-thread filter pointer updates, writes to
    the seccomp fields are now protected by the sighand spinlock (which
    is unique to the thread group). Read access remains lockless because
    pointer updates themselves are atomic.  However, writes (or cloning)
    often entail additional checking (like maximum instruction counts)
    which require locking to perform safely.
        In the case of cloning threads, the child is invisible to the system
    until it enters the task list. To make sure a child can't be cloned from
    a thread and left in a prior state, seccomp duplication is additionally
    moved under the tasklist_lock. Then parent and child are certain have
    the same seccomp state when they exit the lock.
        Based on patches by Will Drewry and David Drysdale.
        Signed-off-by: Kees Cook <keescook@chromium.org>

+----------------------------------------------------------+------------+------------+
|                                                          | 6698e20593 | 8c95953444 |
+----------------------------------------------------------+------------+------------+
| boot_successes                                           | 60         | 0          |
| boot_failures                                            | 0          | 20         |
| kernel_BUG_at_kernel/fork.c                              | 0          | 20         |
| invalid_opcode                                           | 0          | 20         |
| RIP:copy_process                                         | 0          | 20         |
| Kernel_panic-not_syncing:Attempted_to_kill_the_idle_task | 0          | 20         |
| backtrace:do_fork                                        | 0          | 20         |
+----------------------------------------------------------+------------+------------+

[    0.029286] CPU: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.051661] ftrace: allocating 55973 entries in 219 pages
[    0.070092] ------------[ cut here ]------------
[    0.070931] kernel BUG at kernel/fork.c:1100!
[    0.072323] invalid opcode: 0000 [#1] [    0.073449] CPU: 0 PID: 0 Comm: swapper Not tainted 3.15.0-07916-g8c95953 #105
[    0.075327] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.076654] task: ffffffff8321a5c0 ti: ffffffff83200000 task.ti: ffffffff83200000
[    0.078514] RIP: 0010:[<ffffffff8109c6f1>]  [<ffffffff8109c6f1>] copy_process.isra.56+0x1421/0x14c0
[    0.080000] RSP: 0000:ffffffff83203e68  EFLAGS: 00010002
[    0.080000] RAX: 0000000000000002 RBX: 0000000000000000 RCX: 0000000000000000
[    0.080000] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88001244f760
[    0.080000] RBP: ffffffff83203ec0 R08: ffff8800124537c0 R09: 0000000000000040
[    0.080000] R10: ffff880012453800 R11: 7908000000000000 R12: ffffffff8281bae0
[    0.080000] R13: 0000000000000000 R14: 0000000000800300 R15: ffff88001244f760
[    0.080000] FS:  0000000000000000(0000) GS:ffffffff83230000(0000) knlGS:0000000000000000
[    0.080000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.080000] CR2: 00000000ffffffff CR3: 0000000003213000 CR4: 00000000000006f0
[    0.080000] Stack:
[    0.080000]  0000000000000000 0000000000000000 0000000000000000 ffff8800124537c0
[    0.080000]  0000000000000000 fffffff400000002 ffffffffffffffff ffffffff83af0900
[    0.080000]  0000000000800300 ffffffff83af72c0 0000000000000000 ffffffff83203f28
[    0.080000] Call Trace:
[    0.080000]  [<ffffffff8109c905>] do_fork+0x75/0x510
[    0.080000]  [<ffffffff828220c1>] ? ftrace_process_locs.constprop.29+0x42b/0x561
[    0.080000]  [<ffffffff8109cdce>] kernel_thread+0x2e/0x40
[    0.080000]  [<ffffffff8281ba33>] rest_init+0x23/0xd0
[    0.080000]  [<ffffffff839f370d>] start_kernel+0x79d/0x7bb
[    0.080000]  [<ffffffff839f2b89>] ? repair_env_string+0x7f/0x7f
[    0.080000]  [<ffffffff839f2120>] ? early_idt_handlers+0x120/0x120
[    0.080000]  [<ffffffff839f26c0>] x86_64_start_reservations+0x46/0x4f
[    0.080000]  [<ffffffff839f2875>] x86_64_start_kernel+0x1ac/0x1c2
[    0.080000] Code: 83 05 33 fa bc 02 01 e8 6e c1 0b 00 48 83 05 2e fa bc 02 01 ff 04 25 a0 fa 22 83 48 83 05 27 fa bc 02 01 48 83 05 ef f7 bc 02 01 <0f> 0b 48 83 05 ed f7 bc 02 01 48 83 05 5d f9 bc 02 01 b8 f4 ff [    0.080000] RIP  [<ffffffff8109c6f1>] copy_process.isra.56+0x1421/0x14c0
[    0.080000]  RSP <ffffffff83203e68>
[    0.080000] ---[ end trace 556cc7dbbd668af6 ]---
[    0.080000] Kernel panic - not syncing: Attempted to kill the idle task!

git bisect start 05a52ec683855fcbf5dbbc50d0c4d23db4ce21a7 1860e379875dfe7271c649058aeddffe5afd9d0d --
git bisect  bad 0541eb1ef76707c491d3285ef2551f0b9764f4bc  # 01:36      0-     10  Merge 'kees/seccomp-tsync-sighand' into devel-lkp-hsx01-x86_64-201406110035
git bisect good 420e289c1eb93124b1b12aed6321179dcb0c129a  # 01:59     20+      0  0day base guard for 'devel-lkp-hsx01-x86_64-201406110035'
git bisect good 0cdca5640a2395fe9e42f5cb27d7d73f64f751d4  # 02:16     20+      0  Merge 'kees/lsm-mod-pin' into devel-lkp-hsx01-x86_64-201406110035
git bisect  bad 1f1757f2320d5f5aa3614d7739a22dd3a8a6ed0c  # 02:36      0-     20  seccomp: move no_new_privs into seccomp
git bisect good 6698e20593e5bfa53888bbf12f4431f4150dc3c1  # 02:49     20+      0  seccomp: split filter prep from check and apply
git bisect  bad 8c959534443ab563ddbccdcfe6a0f2a4f6fcb863  # 03:11      0-     20  seccomp: introduce writer locking
# first bad commit: [8c959534443ab563ddbccdcfe6a0f2a4f6fcb863] seccomp: introduce writer locking
git bisect good 6698e20593e5bfa53888bbf12f4431f4150dc3c1  # 03:14     60+      0  seccomp: split filter prep from check and apply
git bisect  bad 05a52ec683855fcbf5dbbc50d0c4d23db4ce21a7  # 03:14      0-     13  0day head guard for 'devel-lkp-hsx01-x86_64-201406110035'
git bisect good 5b174fd6472b1d6b6402b30210a212f3fd770d96  # 03:32     60+      0  Merge branch 'for-3.16' of git://linux-nfs.org/~bfields/linux
git bisect good 27a4e439fe5cd92b70137ae237c7aa6888c07b5a  # 03:43     60+      0  Add linux-next specific files for 20140610


This script may reproduce the error.

-----------------------------------------------------------------------------
#!/bin/bash

kernel=$1

kvm=(
	qemu-system-x86_64 -cpu kvm64 -enable-kvm
 	-kernel $kernel
	-smp 2
	-m 256M
	-net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio
	-net user,vlan=0
	-net nic,vlan=1,model=e1000
	-net user,vlan=1
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-serial stdio
	-display none
	-monitor null
)

append=(
	debug
	sched_debug
	apic=debug
	ignore_loglevel
	sysrq_always_enabled
	panic=10
	prompt_ramdisk=0
	earlyprintk=ttyS0,115200
	console=ttyS0,115200
	console=tty0
	vga=normal
	root=/dev/ram0
	rw
)

"${kvm[@]}" --append "${append[*]}"
-----------------------------------------------------------------------------

Thanks,
Jet


--------------060601010406010102040703
Content-Type: text/plain; charset=UTF-8;
 name="dmesg-quantal-ivb44-114:20140611031108:x86_64-randconfig-ha4-0611:3.15.0-07916-g8c95953:105"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="dmesg-quantal-ivb44-114:20140611031108:x86_64-randconfig-ha4";
 filename*1="-0611:3.15.0-07916-g8c95953:105"

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.15.0-07916-g8c95953 (kbuild@lkp-hsx01) (gc=
c version 4.8.2 (Debian 4.8.2-18) ) #105 Wed Jun 11 03:10:07 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,1152=
00 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=
=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdi=
sk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ra=
m0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-ha4-0611/linux=
-devel:devel-lkp-hsx01-x86_64-201406110035:8c959534443ab563ddbccdcfe6a0f2=
a4f6fcb863:bisect-linux4/.vmlinuz-8c959534443ab563ddbccdcfe6a0f2a4f6fcb86=
3-20140611031044-20-ivb44 branch=3Dlinux-devel/devel-lkp-hsx01-x86_64-201=
406110035 BOOT_IMAGE=3D/kernel/x86_64-randconfig-ha4-0611/8c959534443ab56=
3ddbccdcfe6a0f2a4f6fcb863/vmlinuz-3.15.0-07916-g8c95953 drbd.minor_count=3D=
8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] res=
erved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
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
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24=
576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x045ca000, 0x045cafff] PGTABLE
[    0.000000] BRK [0x045cb000, 0x045cbfff] PGTABLE
[    0.000000] BRK [0x045cc000, 0x045ccfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
[    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x045cd000, 0x045cdfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE450 000034 (v01 BOCHS  BXPCRSDT =
00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP =
00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE490 0011A9 (v01 BXPC   BXDSDT   =
00000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF7A0 000796 (v01 BOCHS  BXPCSSDT =
00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF680 000080 (v01 BOCHS  BXPCAPIC =
00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF640 000038 (v01 BOCHS  BXPCHPET =
00000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
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
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1064 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor=
 1/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, API=
C INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level=
)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, API=
C INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level=
)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, API=
C INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high lev=
el)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, API=
C INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high lev=
el)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, API=
C INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, API=
C INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, API=
C INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, API=
C INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, API=
C INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, API=
C INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, API=
C INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, API=
C INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, API=
C INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, API=
C INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, API=
C INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 3258540
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI device=
s
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  To=
tal pages: 80679
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3Dtty=
S0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_=
timeout=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  promp=
t_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D=
/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-ha4-061=
1/linux-devel:devel-lkp-hsx01-x86_64-201406110035:8c959534443ab563ddbccdc=
fe6a0f2a4f6fcb863:bisect-linux4/.vmlinuz-8c959534443ab563ddbccdcfe6a0f2a4=
f6fcb863-20140611031044-20-ivb44 branch=3Dlinux-devel/devel-lkp-hsx01-x86=
_64-201406110035 BOOT_IMAGE=3D/kernel/x86_64-randconfig-ha4-0611/8c959534=
443ab563ddbccdcfe6a0f2a4f6fcb863/vmlinuz-3.15.0-07916-g8c95953 drbd.minor=
_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 b=
ytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 by=
tes)
[    0.000000] Memory: 242624K/327280K available (24907K kernel code, 812=
8K rwdata, 6460K rodata, 2136K init, 9984K bss, 84656K reserved)
[    0.000000] NR_IRQS:4352 nr_irqs:48 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.15.0-07916-g8c95953 (kbuild@lkp-hsx01) (gc=
c version 4.8.2 (Debian 4.8.2-18) ) #105 Wed Jun 11 03:10:07 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,1152=
00 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=
=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdi=
sk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ra=
m0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-ha4-0611/linux=
-devel:devel-lkp-hsx01-x86_64-201406110035:8c959534443ab563ddbccdcfe6a0f2=
a4f6fcb863:bisect-linux4/.vmlinuz-8c959534443ab563ddbccdcfe6a0f2a4f6fcb86=
3-20140611031044-20-ivb44 branch=3Dlinux-devel/devel-lkp-hsx01-x86_64-201=
406110035 BOOT_IMAGE=3D/kernel/x86_64-randconfig-ha4-0611/8c959534443ab56=
3ddbccdcfe6a0f2a4f6fcb863/vmlinuz-3.15.0-07916-g8c95953 drbd.minor_count=3D=
8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] res=
erved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
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
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24=
576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x045ca000, 0x045cafff] PGTABLE
[    0.000000] BRK [0x045cb000, 0x045cbfff] PGTABLE
[    0.000000] BRK [0x045cc000, 0x045ccfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
[    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x045cd000, 0x045cdfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE450 000034 (v01 BOCHS  BXPCRSDT =
00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP =
00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE490 0011A9 (v01 BXPC   BXDSDT   =
00000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF7A0 000796 (v01 BOCHS  BXPCSSDT =
00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF680 000080 (v01 BOCHS  BXPCAPIC =
00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF640 000038 (v01 BOCHS  BXPCHPET =
00000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
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
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1064 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor=
 1/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, API=
C INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level=
)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, API=
C INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level=
)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, API=
C INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high lev=
el)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, API=
C INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high lev=
el)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, API=
C INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, API=
C INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, API=
C INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, API=
C INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, API=
C INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, API=
C INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, API=
C INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, API=
C INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, API=
C INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, API=
C INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, API=
C INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 3258540
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI device=
s
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  To=
tal pages: 80679
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3Dtty=
S0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_=
timeout=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  promp=
t_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D=
/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-ha4-061=
1/linux-devel:devel-lkp-hsx01-x86_64-201406110035:8c959534443ab563ddbccdc=
fe6a0f2a4f6fcb863:bisect-linux4/.vmlinuz-8c959534443ab563ddbccdcfe6a0f2a4=
f6fcb863-20140611031044-20-ivb44 branch=3Dlinux-devel/devel-lkp-hsx01-x86=
_64-201406110035 BOOT_IMAGE=3D/kernel/x86_64-randconfig-ha4-0611/8c959534=
443ab563ddbccdcfe6a0f2a4f6fcb863/vmlinuz-3.15.0-07916-g8c95953 drbd.minor=
_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 b=
ytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 by=
tes)
[    0.000000] Memory: 242624K/327280K available (24907K kernel code, 812=
8K rwdata, 6460K rodata, 2136K init, 9984K bss, 84656K reserved)
[    0.000000] NR_IRQS:4352 nr_irqs:48 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 1572864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't w=
ant memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.456 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5386.91 Bo=
goMIPS (lpj=3D26934560)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] ACPI: Core revision 20140424
[    0.020000] ACPI: All ACPI Tables successfully acquired
[    0.020000] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes=
)
[    0.020000] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 =
bytes)
[    0.020283] Initializing cgroup subsys memory
[    0.021438] Initializing cgroup subsys devices
[    0.022301] Initializing cgroup subsys blkio
[    0.023273] Initializing cgroup subsys perf_event
[    0.024414] Initializing cgroup subsys net_prio
[    0.025316] mce: CPU supports 10 MCE banks
[    0.026378] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.026378] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.026378] tlb_flushall_shift: 6
[    0.029286] CPU: Intel Common KVM processor (fam: 0f, model: 06, stepp=
ing: 01)
[    0.051661] ftrace: allocating 55973 entries in 219 pages
[    0.070092] ------------[ cut here ]------------
[    0.070931] kernel BUG at kernel/fork.c:1100!
[    0.072323] invalid opcode: 0000 [#1]=20
[    0.073449] CPU: 0 PID: 0 Comm: swapper Not tainted 3.15.0-07916-g8c95=
953 #105
[    0.075327] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.076654] task: ffffffff8321a5c0 ti: ffffffff83200000 task.ti: fffff=
fff83200000
[    0.078514] RIP: 0010:[<ffffffff8109c6f1>]  [<ffffffff8109c6f1>] copy_=
process.isra.56+0x1421/0x14c0
[    0.080000] RSP: 0000:ffffffff83203e68  EFLAGS: 00010002
[    0.080000] RAX: 0000000000000002 RBX: 0000000000000000 RCX: 000000000=
0000000
[    0.080000] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88001=
244f760
[    0.080000] RBP: ffffffff83203ec0 R08: ffff8800124537c0 R09: 000000000=
0000040
[    0.080000] R10: ffff880012453800 R11: 7908000000000000 R12: ffffffff8=
281bae0
[    0.080000] R13: 0000000000000000 R14: 0000000000800300 R15: ffff88001=
244f760
[    0.080000] FS:  0000000000000000(0000) GS:ffffffff83230000(0000) knlG=
S:0000000000000000
[    0.080000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.080000] CR2: 00000000ffffffff CR3: 0000000003213000 CR4: 000000000=
00006f0
[    0.080000] Stack:
[    0.080000]  0000000000000000 0000000000000000 0000000000000000 ffff88=
00124537c0
[    0.080000]  0000000000000000 fffffff400000002 ffffffffffffffff ffffff=
ff83af0900
[    0.080000]  0000000000800300 ffffffff83af72c0 0000000000000000 ffffff=
ff83203f28
[    0.080000] Call Trace:
[    0.080000]  [<ffffffff8109c905>] do_fork+0x75/0x510
[    0.080000]  [<ffffffff828220c1>] ? ftrace_process_locs.constprop.29+0=
x42b/0x561
[    0.080000]  [<ffffffff8109cdce>] kernel_thread+0x2e/0x40
[    0.080000]  [<ffffffff8281ba33>] rest_init+0x23/0xd0
[    0.080000]  [<ffffffff839f370d>] start_kernel+0x79d/0x7bb
[    0.080000]  [<ffffffff839f2b89>] ? repair_env_string+0x7f/0x7f
[    0.080000]  [<ffffffff839f2120>] ? early_idt_handlers+0x120/0x120
[    0.080000]  [<ffffffff839f26c0>] x86_64_start_reservations+0x46/0x4f
[    0.080000]  [<ffffffff839f2875>] x86_64_start_kernel+0x1ac/0x1c2
[    0.080000] Code: 83 05 33 fa bc 02 01 e8 6e c1 0b 00 48 83 05 2e fa b=
c 02 01 ff 04 25 a0 fa 22 83 48 83 05 27 fa bc 02 01 48 83 05 ef f7 bc 02=
 01 <0f> 0b 48 83 05 ed f7 bc 02 01 48 83 05 5d f9 bc 02 01 b8 f4 ff=20
[    0.080000] RIP  [<ffffffff8109c6f1>] copy_process.isra.56+0x1421/0x14=
c0
[    0.080000]  RSP <ffffffff83203e68>
[    0.080000] ---[ end trace 556cc7dbbd668af6 ]---
[    0.080000] Kernel panic - not syncing: Attempted to kill the idle tas=
k!
[    0.080000] Rebooting in 10 seconds..
Elapsed time: 10
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconf=
ig-ha4-0611/8c959534443ab563ddbccdcfe6a0f2a4f6fcb863/vmlinuz-3.15.0-07916=
-g8c95953 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug a=
pic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 pan=
ic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 con=
sole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-ha4-0611/linux-devel:dev=
el-lkp-hsx01-x86_64-201406110035:8c959534443ab563ddbccdcfe6a0f2a4f6fcb863=
:bisect-linux4/.vmlinuz-8c959534443ab563ddbccdcfe6a0f2a4f6fcb863-20140611=
031044-20-ivb44 branch=3Dlinux-devel/devel-lkp-hsx01-x86_64-201406110035 =
BOOT_IMAGE=3D/kernel/x86_64-randconfig-ha4-0611/8c959534443ab563ddbccdcfe=
6a0f2a4f6fcb863/vmlinuz-3.15.0-07916-g8c95953 drbd.minor_count=3D8'  -ini=
trd /kernel-tests/initrd/quantal-core-x86_64.cgz -m 320 -smp 2 -net nic,v=
lan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -wat=
chdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-quantal-=
ivb44-114 -serial file:/dev/shm/kboot/serial-quantal-ivb44-114 -daemonize=
 -display none -monitor null=20


--------------060601010406010102040703
Content-Type: application/octet-stream;
 name="x86_64-randconfig-ha4-0611-05a52ec683855fcbf5dbbc50d0c4d23db4ce21a7-kernel-BUG-at-43309.log"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="x86_64-randconfig-ha4-0611-05a52ec683855fcbf5dbbc50d0c4d23db";
 filename*1="4ce21a7-kernel-BUG-at-43309.log"

SEVBRCBpcyBub3cgYXQgMDVhNTJlYy4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1s
a3AtaHN4MDEteDg2XzY0LTIwMTQwNjExMDAzNScKZ2l0IGNoZWNrb3V0IDE4NjBlMzc5ODc1
ZGZlNzI3MWM2NDkwNThhZWRkZmZlNWFmZDlkMGQKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4t
cXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExL2xpbnV4LWRldmVsOmRldmVs
LWxrcC1oc3gwMS14ODZfNjQtMjAxNDA2MTEwMDM1OjE4NjBlMzc5ODc1ZGZlNzI3MWM2NDkw
NThhZWRkZmZlNWFmZDlkMGQ6YmlzZWN0LWxpbnV4NAoKMjAxNC0wNi0xMS0wMDo1NDoxMSAx
ODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVkZGZmZTVhZmQ5ZDBkIGNvbXBpbGluZwpRdWV1
ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5k
Y29uZmlnLWhhNC0wNjExLTE4NjBlMzc5ODc1ZGZlNzI3MWM2NDkwNThhZWRkZmZlNWFmZDlk
MGQKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhhNC0w
NjExLzE4NjBlMzc5ODc1ZGZlNzI3MWM2NDkwNThhZWRkZmZlNWFmZDlkMGQKd2FpdGluZyBm
b3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5k
Y29uZmlnLWhhNC0wNjExLTE4NjBlMzc5ODc1ZGZlNzI3MWM2NDkwNThhZWRkZmZlNWFmZDlk
MGQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
Ly54ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMS0xODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4
YWVkZGZmZTVhZmQ5ZDBkCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oYTQt
MDYxMS8xODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVkZGZmZTVhZmQ5ZDBkL3ZtbGludXot
My4xNS4wCgoyMDE0LTA2LTExLTAxOjEyOjExIGRldGVjdGluZyBib290IHN0YXRlIC4uLi4J
MgkxNAkyMCBTVUNDRVNTCgpiaXNlY3Q6IGdvb2QgY29tbWl0IDE4NjBlMzc5ODc1ZGZlNzI3
MWM2NDkwNThhZWRkZmZlNWFmZDlkMGQKZ2l0IGJpc2VjdCBzdGFydCAwNWE1MmVjNjgzODU1
ZmNiZjVkYmJjNTBkMGM0ZDIzZGI0Y2UyMWE3IDE4NjBlMzc5ODc1ZGZlNzI3MWM2NDkwNThh
ZWRkZmZlNWFmZDlkMGQgLS0KL2Mva2VybmVsLXRlc3RzL2xpbmVhci1iaXNlY3Q6IFsiLWIi
LCAiMDVhNTJlYzY4Mzg1NWZjYmY1ZGJiYzUwZDBjNGQyM2RiNGNlMjFhNyIsICItZyIsICIx
ODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVkZGZmZTVhZmQ5ZDBkIiwgIi9jL2tlcm5lbC10
ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2giLCAiL2MvYm9vdC1iaXNlY3QvbGlu
dXg0L29iai1iaXNlY3QiXQpCaXNlY3Rpbmc6IDgwNzggcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDEzIHN0ZXBzKQpbMDU0MWViMWVmNzY3MDdjNDkxZDMy
ODVlZjI1NTFmMGI5NzY0ZjRiY10gTWVyZ2UgJ2tlZXMvc2VjY29tcC10c3luYy1zaWdoYW5k
JyBpbnRvIGRldmVsLWxrcC1oc3gwMS14ODZfNjQtMjAxNDA2MTEwMDM1CnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2Vj
dC9saW51eDQvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
eDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTEvbGludXgtZGV2ZWw6ZGV2ZWwtbGtwLWhzeDAx
LXg4Nl82NC0yMDE0MDYxMTAwMzU6MDU0MWViMWVmNzY3MDdjNDkxZDMyODVlZjI1NTFmMGI5
NzY0ZjRiYzpiaXNlY3QtbGludXg0CgoyMDE0LTA2LTExLTAxOjE1OjQ0IDA1NDFlYjFlZjc2
NzA3YzQ5MWQzMjg1ZWYyNTUxZjBiOTc2NGY0YmMgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0
YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaGE0
LTA2MTEtMDU0MWViMWVmNzY3MDdjNDkxZDMyODVlZjI1NTFmMGI5NzY0ZjRiYwpDaGVjayBm
b3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTEvMDU0MWVi
MWVmNzY3MDdjNDkxZDMyODVlZjI1NTFmMGI5NzY0ZjRiYwp3YWl0aW5nIGZvciBjb21wbGV0
aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaGE0
LTA2MTEtMDU0MWViMWVmNzY3MDdjNDkxZDMyODVlZjI1NTFmMGI5NzY0ZjRiYwp3YWl0aW5n
IGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1y
YW5kY29uZmlnLWhhNC0wNjExLTA1NDFlYjFlZjc2NzA3YzQ5MWQzMjg1ZWYyNTUxZjBiOTc2
NGY0YmMKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExLzA1NDFl
YjFlZjc2NzA3YzQ5MWQzMjg1ZWYyNTUxZjBiOTc2NGY0YmMvdm1saW51ei0zLjE1LjAtMDc5
MjQtZzA1NDFlYjEKCjIwMTQtMDYtMTEtMDE6MzU6NDQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
LiBURVNUIEZBSUxVUkUKWyAgICAwLjAyMjc3Ml0gQ1BVOiBJbnRlbCBDb21tb24gS1ZNIHBy
b2Nlc3NvciAoZmFtOiAwZiwgbW9kZWw6IDA2LCBzdGVwcGluZzogMDEpClsgICAgMC4wNDEw
NzJdIGZ0cmFjZTogYWxsb2NhdGluZyA1NTk3NSBlbnRyaWVzIGluIDIxOSBwYWdlcwpbICAg
IDAuMDYwMDQ4XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAw
LjA2MDc1OF0ga2VybmVsIEJVRyBhdCAva2J1aWxkL3NyYy94ODZfNjQva2VybmVsL2Zvcmsu
YzoxMTAwIQpbICAgIDAuMDYxNTk1XSBpbnZhbGlkIG9wY29kZTogMDAwMCBbIzFdIApbICAg
IDAuMDYyMjk4XSBDUFU6IDAgUElEOiAwIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4x
NS4wLTA3OTI0LWcwNTQxZWIxICM4NApbICAgIDAuMDYzMjQ1XSBIYXJkd2FyZSBuYW1lOiBC
b2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMC4wNjQwNDRdIHRhc2s6
IGZmZmZmZmZmODMyMWE1YzAgdGk6IGZmZmZmZmZmODMyMDAwMDAgdGFzay50aTogZmZmZmZm
ZmY4MzIwMDAwMApbICAgIDAuMDY1MTYyXSBSSVA6IDAwMTA6WzxmZmZmZmZmZjgxMDljNmYx
Pl0gIFs8ZmZmZmZmZmY4MTA5YzZmMT5dIGNvcHlfcHJvY2Vzcy5pc3JhLjU2KzB4MTQyMS8w
eDE0YzAKWyAgICAwLjA2NjUxMl0gUlNQOiAwMDAwOmZmZmZmZmZmODMyMDNlNjggIEVGTEFH
UzogMDAwMTAwMDIKWyAgICAwLjA2NzI2OF0gUkFYOiAwMDAwMDAwMDAwMDAwMDAyIFJCWDog
MDAwMDAwMDAwMDAwMDAwMCBSQ1g6IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjA2ODIxMV0g
UkRYOiAwMDAwMDAwMDAwMDAwMDAwIFJTSTogMDAwMDAwMDAwMDAwMDAwMCBSREk6IGZmZmY4
ODAwMTI0NGY3NzAKWyAgICAwLjA2OTE1OF0gUkJQOiBmZmZmZmZmZjgzMjAzZWMwIFIwODog
ZmZmZjg4MDAxMjQ1MzdjMCBSMDk6IDAwMDAwMDAwMDAwMDAwNDAKWyAgICAwLjA3MDAwMF0g
UjEwOiBmZmZmODgwMDEyNDUzODAwIFIxMTogNzkwODAwMDAwMDAwMDAwMCBSMTI6IGZmZmZm
ZmZmODI4MWJhYzAKWyAgICAwLjA3MDAwMF0gUjEzOiAwMDAwMDAwMDAwMDAwMDAwIFIxNDog
MDAwMDAwMDAwMDgwMDMwMCBSMTU6IGZmZmY4ODAwMTI0NGY3NzAKWyAgICAwLjA3MDAwMF0g
RlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmZmZmZmODMyMzAwMDAoMDAwMCkg
a25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAgIDAuMDcwMDAwXSBDUzogIDAwMTAgRFM6IDAw
MDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDNiClsgICAgMC4wNzAwMDBdIENSMjog
MDAwMDAwMDBmZmZmZmZmZiBDUjM6IDAwMDAwMDAwMDMyMTMwMDAgQ1I0OiAwMDAwMDAwMDAw
MDAwNmYwClsgICAgMC4wNzAwMDBdIFN0YWNrOgpbICAgIDAuMDcwMDAwXSAgMDAwMDAwMDAw
MDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAxMjQ1
MzdjMApbICAgIDAuMDcwMDAwXSAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmZmZmNDAwMDAwMDAy
IGZmZmZmZmZmZmZmZmZmZmYgZmZmZmZmZmY4M2FmMDkwMApbICAgIDAuMDcwMDAwXSAgMDAw
MDAwMDAwMDgwMDMwMCBmZmZmZmZmZjgzYWY3MmMwIDAwMDAwMDAwMDAwMDAwMDAgZmZmZmZm
ZmY4MzIwM2YyOApbICAgIDAuMDcwMDAwXSBDYWxsIFRyYWNlOgpbICAgIDAuMDcwMDAwXSAg
WzxmZmZmZmZmZjgxMDljOTA1Pl0gZG9fZm9yaysweDc1LzB4NTEwClsgICAgMC4wNzAwMDBd
ICBbPGZmZmZmZmZmODI4MjIwYTE+XSA/IGZ0cmFjZV9wcm9jZXNzX2xvY3MuY29uc3Rwcm9w
LjI5KzB4NDJiLzB4NTYxClsgICAgMC4wNzAwMDBdICBbPGZmZmZmZmZmODEwOWNkY2U+XSBr
ZXJuZWxfdGhyZWFkKzB4MmUvMHg0MApbICAgIDAuMDcwMDAwXSAgWzxmZmZmZmZmZjgyODFi
YTEzPl0gcmVzdF9pbml0KzB4MjMvMHhkMApbICAgIDAuMDcwMDAwXSAgWzxmZmZmZmZmZjgz
OWYzNzBkPl0gc3RhcnRfa2VybmVsKzB4NzlkLzB4N2JiClsgICAgMC4wNzAwMDBdICBbPGZm
ZmZmZmZmODM5ZjJiODk+XSA/IHJlcGFpcl9lbnZfc3RyaW5nKzB4N2YvMHg3ZgpbICAgIDAu
MDcwMDAwXSAgWzxmZmZmZmZmZjgzOWYyMTIwPl0gPyBlYXJseV9pZHRfaGFuZGxlcnMrMHgx
MjAvMHgxMjAKWyAgICAwLjA3MDAwMF0gIFs8ZmZmZmZmZmY4MzlmMjZjMD5dIHg4Nl82NF9z
dGFydF9yZXNlcnZhdGlvbnMrMHg0Ni8weDRmClsgICAgMC4wNzAwMDBdICBbPGZmZmZmZmZm
ODM5ZjI4NzU+XSB4ODZfNjRfc3RhcnRfa2VybmVsKzB4MWFjLzB4MWMyClsgICAgMC4wNzAw
MDBdIENvZGU6IDgzIDA1IDMzIDBhIGJkIDAyIDAxIGU4IDRlIGMxIDBiIDAwIDQ4IDgzIDA1
IDJlIDBhIGJkIDAyIDAxIGZmIDA0IDI1IGEwIGZhIDIyIDgzIDQ4IDgzIDA1IDI3IDBhIGJk
IDAyIDAxIDQ4IDgzIDA1IGVmIDA3IGJkIDAyIDAxIDwwZj4gMGIgNDggODMgMDUgZWQgMDcg
YmQgMDIgMDEgNDggODMgMDUgNWQgMDkgYmQgMDIgMDEgYjggZjQgZmYgClsgICAgMC4wNzAw
MDBdIFJJUCAgWzxmZmZmZmZmZjgxMDljNmYxPl0gY29weV9wcm9jZXNzLmlzcmEuNTYrMHgx
NDIxLzB4MTRjMApbICAgIDAuMDcwMDAwXSAgUlNQIDxmZmZmZmZmZjgzMjAzZTY4PgpbICAg
IDAuMDcwMDAwXSAtLS1bIGVuZCB0cmFjZSBmNjMyYTM5NmMzNmYwZTIzIF0tLS0KWyAgICAw
LjA3MDAwMF0gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEF0dGVtcHRlZCB0byBraWxs
IHRoZSBpZGxlIHRhc2shCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTEvMDU0
MWViMWVmNzY3MDdjNDkxZDMyODVlZjI1NTFmMGI5NzY0ZjRiYy9kbWVzZy1xdWFudGFsLWl2
YjQ0LTEyNDoyMDE0MDYxMTAxMzU1OTp4ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMTozLjE1
LjAtMDc5MjQtZzA1NDFlYjE6ODQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYx
MS8wNTQxZWIxZWY3NjcwN2M0OTFkMzI4NWVmMjU1MWYwYjk3NjRmNGJjL2RtZXNnLXF1YW50
YWwtaXZiNDQtNTM6MjAxNDA2MTEwMTM1NTY6eDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTE6
My4xNS4wLTA3OTI0LWcwNTQxZWIxOjg0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaGE0
LTA2MTEvMDU0MWViMWVmNzY3MDdjNDkxZDMyODVlZjI1NTFmMGI5NzY0ZjRiYy9kbWVzZy1x
dWFudGFsLWl2YjQxLTQxOjIwMTQwNjExMDEzNjEwOng4Nl82NC1yYW5kY29uZmlnLWhhNC0w
NjExOjMuMTUuMC0wNzkyNC1nMDU0MWViMTo4NAova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWhhNC0wNjExLzA1NDFlYjFlZjc2NzA3YzQ5MWQzMjg1ZWYyNTUxZjBiOTc2NGY0YmMvZG1l
c2ctcXVhbnRhbC1pdmI0Mi0yMzoyMDE0MDYxMTAxMzYwNDp4ODZfNjQtcmFuZGNvbmZpZy1o
YTQtMDYxMTozLjE1LjAtMDc5MjQtZzA1NDFlYjE6ODQKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1oYTQtMDYxMS8wNTQxZWIxZWY3NjcwN2M0OTFkMzI4NWVmMjU1MWYwYjk3NjRmNGJj
L2RtZXNnLXF1YW50YWwtaXZiNDItNTc6MjAxNDA2MTEwMTM2MDY6eDg2XzY0LXJhbmRjb25m
aWctaGE0LTA2MTE6My4xNS4wLTA3OTI0LWcwNTQxZWIxOjg0Ci9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctaGE0LTA2MTEvMDU0MWViMWVmNzY3MDdjNDkxZDMyODVlZjI1NTFmMGI5NzY0
ZjRiYy9kbWVzZy1xdWFudGFsLWl2YjQ0LTEwMzoyMDE0MDYxMTAxMzYwOTp4ODZfNjQtcmFu
ZGNvbmZpZy1oYTQtMDYxMTozLjE1LjAtMDc5MjQtZzA1NDFlYjE6ODQKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1oYTQtMDYxMS8wNTQxZWIxZWY3NjcwN2M0OTFkMzI4NWVmMjU1MWYw
Yjk3NjRmNGJjL2RtZXNnLXF1YW50YWwtaXZiNDQtMTI0OjIwMTQwNjExMDEzNjA5Ong4Nl82
NC1yYW5kY29uZmlnLWhhNC0wNjExOjMuMTUuMC0wNzkyNC1nMDU0MWViMTo4NAova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExLzA1NDFlYjFlZjc2NzA3YzQ5MWQzMjg1ZWYy
NTUxZjBiOTc2NGY0YmMvZG1lc2ctcXVhbnRhbC1pdmI0NC01MzoyMDE0MDYxMTAxMzYwNjp4
ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMTozLjE1LjAtMDc5MjQtZzA1NDFlYjE6ODQKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMS8wNTQxZWIxZWY3NjcwN2M0OTFkMzI4
NWVmMjU1MWYwYjk3NjRmNGJjL2RtZXNnLXlvY3RvLWl2YjQxLTk0OjIwMTQwNjExMDEzNjA1
Ong4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExOjMuMTUuMC0wNzkyNC1nMDU0MWViMTo4NAov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExLzA1NDFlYjFlZjc2NzA3YzQ5MWQz
Mjg1ZWYyNTUxZjBiOTc2NGY0YmMvZG1lc2cteW9jdG8taXZiNDItMTIxOjIwMTQwNjExMDEz
NjA0Ong4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExOjMuMTUuMC0wNzkyNC1nMDU0MWViMTo4
NAowOjEwOjEwIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA2LTEx
IDAxOjM2OjE1IFJFUEVBVCBDT1VOVDogMjAgICMgL2MvYm9vdC1iaXNlY3QvbGludXg0L29i
ai1iaXNlY3QvLnJlcGVhdBtbMG0KCkJpc2VjdGluZzogNzkyNCByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTMgc3RlcHMpCls0MjBlMjg5YzFlYjkzMTI0
YjFiMTJhZWQ2MzIxMTc5ZGNiMGMxMjlhXSAwZGF5IGJhc2UgZ3VhcmQgZm9yICdkZXZlbC1s
a3AtaHN4MDEteDg2XzY0LTIwMTQwNjExMDAzNScKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4NC9vYmot
YmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNv
bmZpZy1oYTQtMDYxMS9saW51eC1kZXZlbDpkZXZlbC1sa3AtaHN4MDEteDg2XzY0LTIwMTQw
NjExMDAzNTo0MjBlMjg5YzFlYjkzMTI0YjFiMTJhZWQ2MzIxMTc5ZGNiMGMxMjlhOmJpc2Vj
dC1saW51eDQKCjIwMTQtMDYtMTEtMDE6MzY6MTcgNDIwZTI4OWMxZWI5MzEyNGIxYjEyYWVk
NjMyMTE3OWRjYjBjMTI5YSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMS00MjBlMjg5
YzFlYjkzMTI0YjFiMTJhZWQ2MzIxMTc5ZGNiMGMxMjlhCkNoZWNrIGZvciBrZXJuZWwgaW4g
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMS80MjBlMjg5YzFlYjkzMTI0YjFi
MTJhZWQ2MzIxMTc5ZGNiMGMxMjlhCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMS00MjBlMjg5
YzFlYjkzMTI0YjFiMTJhZWQ2MzIxMTc5ZGNiMGMxMjlhCndhaXRpbmcgZm9yIGNvbXBsZXRp
b24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctaGE0
LTA2MTEtNDIwZTI4OWMxZWI5MzEyNGIxYjEyYWVkNjMyMTE3OWRjYjBjMTI5YQprZXJuZWw6
IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTEvNDIwZTI4OWMxZWI5MzEyNGIx
YjEyYWVkNjMyMTE3OWRjYjBjMTI5YS92bWxpbnV6LTMuMTUuMC0wMDAwMS1nNDIwZTI4OQoK
MjAxNC0wNi0xMS0wMTo1NjoxNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uCTExCTIwIFNV
Q0NFU1MKCkJpc2VjdGluZzogNzkyMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgMTMgc3RlcHMpClswY2RjYTU2NDBhMjM5NWZlOWU0MmY1Y2IyN2Q3ZDcz
ZjY0Zjc1MWQ0XSBNZXJnZSAna2Vlcy9sc20tbW9kLXBpbicgaW50byBkZXZlbC1sa3AtaHN4
MDEteDg2XzY0LTIwMTQwNjExMDAzNQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXg0L29iai1iaXNlY3QK
bHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhh
NC0wNjExL2xpbnV4LWRldmVsOmRldmVsLWxrcC1oc3gwMS14ODZfNjQtMjAxNDA2MTEwMDM1
OjBjZGNhNTY0MGEyMzk1ZmU5ZTQyZjVjYjI3ZDdkNzNmNjRmNzUxZDQ6YmlzZWN0LWxpbnV4
NAoKMjAxNC0wNi0xMS0wMTo1OToxOSAwY2RjYTU2NDBhMjM5NWZlOWU0MmY1Y2IyN2Q3ZDcz
ZjY0Zjc1MWQ0IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExLTBjZGNhNTY0MGEyMzk1
ZmU5ZTQyZjVjYjI3ZDdkNzNmNjRmNzUxZDQKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExLzBjZGNhNTY0MGEyMzk1ZmU5ZTQyZjVjYjI3
ZDdkNzNmNjRmNzUxZDQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExLTBjZGNhNTY0MGEyMzk1
ZmU5ZTQyZjVjYjI3ZDdkNzNmNjRmNzUxZDQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMS0w
Y2RjYTU2NDBhMjM5NWZlOWU0MmY1Y2IyN2Q3ZDczZjY0Zjc1MWQ0Cmtlcm5lbDogL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMS8wY2RjYTU2NDBhMjM5NWZlOWU0MmY1Y2Iy
N2Q3ZDczZjY0Zjc1MWQ0L3ZtbGludXotMy4xNS4wLTA3OTE2LWcwY2RjYTU2CgoyMDE0LTA2
LTExLTAyOjE0OjE5IGRldGVjdGluZyBib290IHN0YXRlIC4uLgkzCTIwIFNVQ0NFU1MKCmxp
bmVhci1iaXNlY3Q6IGJhZCBicmFuY2ggbWF5IGJlIGtlZXMvc2VjY29tcC10c3luYy1zaWdo
YW5kCmxpbmVhci1iaXNlY3Q6IGhhbmRsZSBvdmVyIHRvIGdpdCBiaXNlY3QKbGluZWFyLWJp
c2VjdDogZ2l0IGJpc2VjdCBzdGFydCAwNTQxZWIxZWY3NjcwN2M0OTFkMzI4NWVmMjU1MWYw
Yjk3NjRmNGJjIDBjZGNhNTY0MGEyMzk1ZmU5ZTQyZjVjYjI3ZDdkNzNmNjRmNzUxZDQgLS0K
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgMGNkY2E1Ni4uLiBNZXJnZSAna2Vlcy9sc20t
bW9kLXBpbicgaW50byBkZXZlbC1sa3AtaHN4MDEteDg2XzY0LTIwMTQwNjExMDAzNQpIRUFE
IGlzIG5vdyBhdCAxZWE1MmE5Li4uIE1lcmdlICdqYmFybmVzL2FzeW5jLWZiLXByb2JlJyBp
bnRvIGRldmVsLWhvdXJseS0yMDE0MDYwMjEwCkJpc2VjdGluZzogMyByZXZpc2lvbnMgbGVm
dCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMiBzdGVwcykKWzFmMTc1N2YyMzIwZDVm
NWFhMzYxNGQ3NzM5YTIyZGQzYThhNmVkMGNdIHNlY2NvbXA6IG1vdmUgbm9fbmV3X3ByaXZz
IGludG8gc2VjY29tcApsaW5lYXItYmlzZWN0OiBnaXQgYmlzZWN0IHJ1biAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4
NC9vYmotYmlzZWN0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDQvb2JqLWJpc2VjdApscyAtYSAva2J1
aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTEvbGlu
dXgtZGV2ZWw6ZGV2ZWwtbGtwLWhzeDAxLXg4Nl82NC0yMDE0MDYxMTAwMzU6MWYxNzU3ZjIz
MjBkNWY1YWEzNjE0ZDc3MzlhMjJkZDNhOGE2ZWQwYzpiaXNlY3QtbGludXg0CgoyMDE0LTA2
LTExLTAyOjE2OjU0IDFmMTc1N2YyMzIwZDVmNWFhMzYxNGQ3NzM5YTIyZGQzYThhNmVkMGMg
Y29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVl
dWUveDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTEtMWYxNzU3ZjIzMjBkNWY1YWEzNjE0ZDc3
MzlhMjJkZDNhOGE2ZWQwYwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctaGE0LTA2MTEvMWYxNzU3ZjIzMjBkNWY1YWEzNjE0ZDc3MzlhMjJkZDNhOGE2
ZWQwYwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVl
dWUveDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTEtMWYxNzU3ZjIzMjBkNWY1YWEzNjE0ZDc3
MzlhMjJkZDNhOGE2ZWQwYwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExLTFmMTc1N2YyMzIw
ZDVmNWFhMzYxNGQ3NzM5YTIyZGQzYThhNmVkMGMKa2VybmVsOiAva2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWhhNC0wNjExLzFmMTc1N2YyMzIwZDVmNWFhMzYxNGQ3NzM5YTIyZGQzYThh
NmVkMGMvdm1saW51ei0zLjE1LjAtMDc5MTctZzFmMTc1N2YKCjIwMTQtMDYtMTEtMDI6MzU6
NTQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLiBURVNUIEZBSUxVUkUKWyAgICAwLjAyMjY1MV0g
Q1BVOiBJbnRlbCBDb21tb24gS1ZNIHByb2Nlc3NvciAoZmFtOiAwZiwgbW9kZWw6IDA2LCBz
dGVwcGluZzogMDEpClsgICAgMC4wMzk4ODZdIGZ0cmFjZTogYWxsb2NhdGluZyA1NTk3MyBl
bnRyaWVzIGluIDIxOSBwYWdlcwpbICAgIDAuMDYwMDM4XSAtLS0tLS0tLS0tLS1bIGN1dCBo
ZXJlIF0tLS0tLS0tLS0tLS0KWyAgICAwLjA2MDY5NF0ga2VybmVsIEJVRyBhdCAva2J1aWxk
L3NyYy94ODZfNjQva2VybmVsL2ZvcmsuYzoxMTAwIQpbICAgIDAuMDYxNTA5XSBpbnZhbGlk
IG9wY29kZTogMDAwMCBbIzFdIApbICAgIDAuMDYyMTc2XSBDUFU6IDAgUElEOiAwIENvbW06
IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xNS4wLTA3OTE3LWcxZjE3NTdmICM5NApbICAgIDAu
MDYzMDg3XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8y
MDExClsgICAgMC4wNjM4NjVdIHRhc2s6IGZmZmZmZmZmODMyMWE1YzAgdGk6IGZmZmZmZmZm
ODMyMDAwMDAgdGFzay50aTogZmZmZmZmZmY4MzIwMDAwMApbICAgIDAuMDY0OTM2XSBSSVA6
IDAwMTA6WzxmZmZmZmZmZjgxMDljNmYxPl0gIFs8ZmZmZmZmZmY4MTA5YzZmMT5dIGNvcHlf
cHJvY2Vzcy5pc3JhLjU2KzB4MTQyMS8weDE0YzAKWyAgICAwLjA2NjMwNF0gUlNQOiAwMDAw
OmZmZmZmZmZmODMyMDNlNjggIEVGTEFHUzogMDAwMTAwMDIKWyAgICAwLjA2NzAyOF0gUkFY
OiAwMDAwMDAwMDAwMDAwMDAyIFJCWDogMDAwMDAwMDAwMDAwMDAwMCBSQ1g6IDAwMDAwMDAw
MDAwMDAwMDAKWyAgICAwLjA2Nzk1Ml0gUkRYOiAwMDAwMDAwMDAwMDAwMDAwIFJTSTogMDAw
MDAwMDAwMDAwMDAwMCBSREk6IGZmZmY4ODAwMTI0NGY3NzAKWyAgICAwLjA2ODg1OF0gUkJQ
OiBmZmZmZmZmZjgzMjAzZWMwIFIwODogZmZmZjg4MDAxMjQ1MzdjMCBSMDk6IDAwMDAwMDAw
MDAwMDAwNDAKWyAgICAwLjA2OTc4MF0gUjEwOiBmZmZmODgwMDEyNDUzODAwIFIxMTogNzkw
ODAwMDAwMDAwMDAwMCBSMTI6IGZmZmZmZmZmODI4MWJiMDAKWyAgICAwLjA3MDAwMF0gUjEz
OiAwMDAwMDAwMDAwMDAwMDAwIFIxNDogMDAwMDAwMDAwMDgwMDMwMCBSMTU6IGZmZmY4ODAw
MTI0NGY3NzAKWyAgICAwLjA3MDAwMF0gRlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdT
OmZmZmZmZmZmODMyMzAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAgIDAu
MDcwMDAwXSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUw
MDNiClsgICAgMC4wNzAwMDBdIENSMjogMDAwMDAwMDBmZmZmZmZmZiBDUjM6IDAwMDAwMDAw
MDMyMTMwMDAgQ1I0OiAwMDAwMDAwMDAwMDAwNmYwClsgICAgMC4wNzAwMDBdIFN0YWNrOgpb
ICAgIDAuMDcwMDAwXSAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwIDAwMDAw
MDAwMDAwMDAwMDAgZmZmZjg4MDAxMjQ1MzdjMApbICAgIDAuMDcwMDAwXSAgMDAwMDAwMDAw
MDAwMDAwMCBmZmZmZmZmNDAwMDAwMDAyIGZmZmZmZmZmZmZmZmZmZmYgZmZmZmZmZmY4M2Fm
MDkwMApbICAgIDAuMDcwMDAwXSAgMDAwMDAwMDAwMDgwMDMwMCBmZmZmZmZmZjgzYWY3MmMw
IDAwMDAwMDAwMDAwMDAwMDAgZmZmZmZmZmY4MzIwM2YyOApbICAgIDAuMDcwMDAwXSBDYWxs
IFRyYWNlOgpbICAgIDAuMDcwMDAwXSAgWzxmZmZmZmZmZjgxMDljOTA1Pl0gZG9fZm9yaysw
eDc1LzB4NTEwClsgICAgMC4wNzAwMDBdICBbPGZmZmZmZmZmODI4MjIwZTE+XSA/IGZ0cmFj
ZV9wcm9jZXNzX2xvY3MuY29uc3Rwcm9wLjI5KzB4NDJiLzB4NTYxClsgICAgMC4wNzAwMDBd
ICBbPGZmZmZmZmZmODEwOWNkY2U+XSBrZXJuZWxfdGhyZWFkKzB4MmUvMHg0MApbICAgIDAu
MDcwMDAwXSAgWzxmZmZmZmZmZjgyODFiYTUzPl0gcmVzdF9pbml0KzB4MjMvMHhkMApbICAg
IDAuMDcwMDAwXSAgWzxmZmZmZmZmZjgzOWYzNzBkPl0gc3RhcnRfa2VybmVsKzB4NzlkLzB4
N2JiClsgICAgMC4wNzAwMDBdICBbPGZmZmZmZmZmODM5ZjJiODk+XSA/IHJlcGFpcl9lbnZf
c3RyaW5nKzB4N2YvMHg3ZgpbICAgIDAuMDcwMDAwXSAgWzxmZmZmZmZmZjgzOWYyMTIwPl0g
PyBlYXJseV9pZHRfaGFuZGxlcnMrMHgxMjAvMHgxMjAKWyAgICAwLjA3MDAwMF0gIFs8ZmZm
ZmZmZmY4MzlmMjZjMD5dIHg4Nl82NF9zdGFydF9yZXNlcnZhdGlvbnMrMHg0Ni8weDRmClsg
ICAgMC4wNzAwMDBdICBbPGZmZmZmZmZmODM5ZjI4NzU+XSB4ODZfNjRfc3RhcnRfa2VybmVs
KzB4MWFjLzB4MWMyClsgICAgMC4wNzAwMDBdIENvZGU6IDgzIDA1IDMzIGZhIGJjIDAyIDAx
IGU4IDhlIGMxIDBiIDAwIDQ4IDgzIDA1IDJlIGZhIGJjIDAyIDAxIGZmIDA0IDI1IGEwIGZh
IDIyIDgzIDQ4IDgzIDA1IDI3IGZhIGJjIDAyIDAxIDQ4IDgzIDA1IGVmIGY3IGJjIDAyIDAx
IDwwZj4gMGIgNDggODMgMDUgZWQgZjcgYmMgMDIgMDEgNDggODMgMDUgNWQgZjkgYmMgMDIg
MDEgYjggZjQgZmYgClsgICAgMC4wNzAwMDBdIFJJUCAgWzxmZmZmZmZmZjgxMDljNmYxPl0g
Y29weV9wcm9jZXNzLmlzcmEuNTYrMHgxNDIxLzB4MTRjMApbICAgIDAuMDcwMDAwXSAgUlNQ
IDxmZmZmZmZmZjgzMjAzZTY4PgpbICAgIDAuMDcwMDAwXSAtLS1bIGVuZCB0cmFjZSA1ZjY1
MDY0YjY4ZWNkZjAyIF0tLS0KWyAgICAwLjA3MDAwMF0gS2VybmVsIHBhbmljIC0gbm90IHN5
bmNpbmc6IEF0dGVtcHRlZCB0byBraWxsIHRoZSBpZGxlIHRhc2shCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctaGE0LTA2MTEvMWYxNzU3ZjIzMjBkNWY1YWEzNjE0ZDc3MzlhMjJkZDNh
OGE2ZWQwYy9kbWVzZy1xdWFudGFsLWl2YjQyLTEwOToyMDE0MDYxMTAyMzUwNjp4ODZfNjQt
cmFuZGNvbmZpZy1oYTQtMDYxMTozLjE1LjAtMDc5MTctZzFmMTc1N2Y6OTQKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMS8xZjE3NTdmMjMyMGQ1ZjVhYTM2MTRkNzczOWEy
MmRkM2E4YTZlZDBjL2RtZXNnLXF1YW50YWwtaXZiNDItNjY6MjAxNDA2MTEwMjM1MTA6eDg2
XzY0LXJhbmRjb25maWctaGE0LTA2MTE6My4xNS4wLTA3OTE3LWcxZjE3NTdmOjk0Ci9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTEvMWYxNzU3ZjIzMjBkNWY1YWEzNjE0ZDc3
MzlhMjJkZDNhOGE2ZWQwYy9kbWVzZy1xdWFudGFsLWl2YjQyLTY5OjIwMTQwNjExMDIzNTA5
Ong4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExOjMuMTUuMC0wNzkxNy1nMWYxNzU3Zjo5NAov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExLzFmMTc1N2YyMzIwZDVmNWFhMzYx
NGQ3NzM5YTIyZGQzYThhNmVkMGMvZG1lc2cteW9jdG8taXZiNDItMTM6MjAxNDA2MTEwMjM1
MDg6eDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTE6My4xNS4wLTA3OTE3LWcxZjE3NTdmOjk0
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTEvMWYxNzU3ZjIzMjBkNWY1YWEz
NjE0ZDc3MzlhMjJkZDNhOGE2ZWQwYy9kbWVzZy15b2N0by1pdmI0NC0xNDoyMDE0MDYxMTAy
MzUxMDp4ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMTozLjE1LjAtMDc5MTctZzFmMTc1N2Y6
OTQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMS8xZjE3NTdmMjMyMGQ1ZjVh
YTM2MTRkNzczOWEyMmRkM2E4YTZlZDBjL2RtZXNnLXlvY3RvLWl2YjQ0LTIwOjIwMTQwNjEx
MDIzNTA5Ong4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExOjMuMTUuMC0wNzkxNy1nMWYxNzU3
Zjo5NAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExLzFmMTc1N2YyMzIwZDVm
NWFhMzYxNGQ3NzM5YTIyZGQzYThhNmVkMGMvZG1lc2cteW9jdG8taXZiNDQtNDE6MjAxNDA2
MTEwMjM1MTA6eDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTE6My4xNS4wLTA3OTE3LWcxZjE3
NTdmOjk0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTEvMWYxNzU3ZjIzMjBk
NWY1YWEzNjE0ZDc3MzlhMjJkZDNhOGE2ZWQwYy9kbWVzZy1xdWFudGFsLWl2YjQxLTQ2OjIw
MTQwNjExMDIzNTE3Ong4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExOjMuMTUuMC0wNzkxNy1n
MWYxNzU3Zjo5NAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExLzFmMTc1N2Yy
MzIwZDVmNWFhMzYxNGQ3NzM5YTIyZGQzYThhNmVkMGMvZG1lc2ctcXVhbnRhbC1pdmI0Mi00
MToyMDE0MDYxMTAyMzUyMjp4ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMTozLjE1LjAtMDc5
MTctZzFmMTc1N2Y6OTQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMS8xZjE3
NTdmMjMyMGQ1ZjVhYTM2MTRkNzczOWEyMmRkM2E4YTZlZDBjL2RtZXNnLXF1YW50YWwtaXZi
NDItNjY6MjAxNDA2MTEwMjM1MjA6eDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTE6My4xNS4w
LTA3OTE3LWcxZjE3NTdmOjk0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTEv
MWYxNzU3ZjIzMjBkNWY1YWEzNjE0ZDc3MzlhMjJkZDNhOGE2ZWQwYy9kbWVzZy1xdWFudGFs
LWl2YjQyLTY5OjIwMTQwNjExMDIzNTE5Ong4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExOjMu
MTUuMC0wNzkxNy1nMWYxNzU3Zjo5NAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhhNC0w
NjExLzFmMTc1N2YyMzIwZDVmNWFhMzYxNGQ3NzM5YTIyZGQzYThhNmVkMGMvZG1lc2cteW9j
dG8taXZiNDEtNTA6MjAxNDA2MTEwMjM1MTc6eDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTE6
My4xNS4wLTA3OTE3LWcxZjE3NTdmOjk0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaGE0
LTA2MTEvMWYxNzU3ZjIzMjBkNWY1YWEzNjE0ZDc3MzlhMjJkZDNhOGE2ZWQwYy9kbWVzZy15
b2N0by1pdmI0Mi0xMDM6MjAxNDA2MTEwMjM1MjA6eDg2XzY0LXJhbmRjb25maWctaGE0LTA2
MTE6My4xNS4wLTA3OTE3LWcxZjE3NTdmOjk0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
aGE0LTA2MTEvMWYxNzU3ZjIzMjBkNWY1YWEzNjE0ZDc3MzlhMjJkZDNhOGE2ZWQwYy9kbWVz
Zy15b2N0by1pdmI0Mi0xMzoyMDE0MDYxMTAyMzUxODp4ODZfNjQtcmFuZGNvbmZpZy1oYTQt
MDYxMTozLjE1LjAtMDc5MTctZzFmMTc1N2Y6OTQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1oYTQtMDYxMS8xZjE3NTdmMjMyMGQ1ZjVhYTM2MTRkNzczOWEyMmRkM2E4YTZlZDBjL2Rt
ZXNnLXlvY3RvLWl2YjQ0LTE0OjIwMTQwNjExMDIzNTIwOng4Nl82NC1yYW5kY29uZmlnLWhh
NC0wNjExOjMuMTUuMC0wNzkxNy1nMWYxNzU3Zjo5NAova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWhhNC0wNjExLzFmMTc1N2YyMzIwZDVmNWFhMzYxNGQ3NzM5YTIyZGQzYThhNmVkMGMv
ZG1lc2cteW9jdG8taXZiNDQtMTk6MjAxNDA2MTEwMjM1MjI6eDg2XzY0LXJhbmRjb25maWct
aGE0LTA2MTE6My4xNS4wLTA3OTE3LWcxZjE3NTdmOjk0Ci9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaGE0LTA2MTEvMWYxNzU3ZjIzMjBkNWY1YWEzNjE0ZDc3MzlhMjJkZDNhOGE2ZWQw
Yy9kbWVzZy15b2N0by1pdmI0NC0yMDoyMDE0MDYxMTAyMzUxODp4ODZfNjQtcmFuZGNvbmZp
Zy1oYTQtMDYxMTozLjE1LjAtMDc5MTctZzFmMTc1N2Y6OTQKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1oYTQtMDYxMS8xZjE3NTdmMjMyMGQ1ZjVhYTM2MTRkNzczOWEyMmRkM2E4YTZl
ZDBjL2RtZXNnLXlvY3RvLWl2YjQ0LTQxOjIwMTQwNjExMDIzNTE5Ong4Nl82NC1yYW5kY29u
ZmlnLWhhNC0wNjExOjMuMTUuMC0wNzkxNy1nMWYxNzU3Zjo5NAova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLWhhNC0wNjExLzFmMTc1N2YyMzIwZDVmNWFhMzYxNGQ3NzM5YTIyZGQzYThh
NmVkMGMvZG1lc2ctcXVhbnRhbC1pdmI0MS00MzoyMDE0MDYxMTAyMzUyNjp4ODZfNjQtcmFu
ZGNvbmZpZy1oYTQtMDYxMTozLjE1LjAtMDc5MTctZzFmMTc1N2Y6OTQKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1oYTQtMDYxMS8xZjE3NTdmMjMyMGQ1ZjVhYTM2MTRkNzczOWEyMmRk
M2E4YTZlZDBjL2RtZXNnLXF1YW50YWwtaXZiNDQtMTA1OjIwMTQwNjExMDIzNTI1Ong4Nl82
NC1yYW5kY29uZmlnLWhhNC0wNjExOjMuMTUuMC0wNzkxNy1nMWYxNzU3Zjo5NAowOjIwOjIw
IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA2LTExIDAyOjM2OjI0
IFJFUEVBVCBDT1VOVDogMjAgICMgL2MvYm9vdC1iaXNlY3QvbGludXg0L29iai1iaXNlY3Qv
LnJlcGVhdBtbMG0KCkJpc2VjdGluZzogMSByZXZpc2lvbiBsZWZ0IHRvIHRlc3QgYWZ0ZXIg
dGhpcyAocm91Z2hseSAxIHN0ZXApCls2Njk4ZTIwNTkzZTViZmE1Mzg4OGJiZjEyZjQ0MzFm
NDE1MGRjM2MxXSBzZWNjb21wOiBzcGxpdCBmaWx0ZXIgcHJlcCBmcm9tIGNoZWNrIGFuZCBh
cHBseQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2ggL2MvYm9vdC1iaXNlY3QvbGludXg0L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0
cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExL2xpbnV4LWRldmVs
OmRldmVsLWxrcC1oc3gwMS14ODZfNjQtMjAxNDA2MTEwMDM1OjY2OThlMjA1OTNlNWJmYTUz
ODg4YmJmMTJmNDQzMWY0MTUwZGMzYzE6YmlzZWN0LWxpbnV4NAoKMjAxNC0wNi0xMS0wMjoz
NjoyNSA2Njk4ZTIwNTkzZTViZmE1Mzg4OGJiZjEyZjQ0MzFmNDE1MGRjM2MxIGNvbXBpbGlu
ZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82
NC1yYW5kY29uZmlnLWhhNC0wNjExLTY2OThlMjA1OTNlNWJmYTUzODg4YmJmMTJmNDQzMWY0
MTUwZGMzYzEKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWhhNC0wNjExLzY2OThlMjA1OTNlNWJmYTUzODg4YmJmMTJmNDQzMWY0MTUwZGMzYzEKd2Fp
dGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82
NC1yYW5kY29uZmlnLWhhNC0wNjExLTY2OThlMjA1OTNlNWJmYTUzODg4YmJmMTJmNDQzMWY0
MTUwZGMzYzEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlLy54ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMS02Njk4ZTIwNTkzZTViZmE1Mzg4
OGJiZjEyZjQ0MzFmNDE1MGRjM2MxCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1oYTQtMDYxMS82Njk4ZTIwNTkzZTViZmE1Mzg4OGJiZjEyZjQ0MzFmNDE1MGRjM2MxL3Zt
bGludXotMy4xNS4wLTA3OTE1LWc2Njk4ZTIwCgoyMDE0LTA2LTExLTAyOjQ3OjI1IGRldGVj
dGluZyBib290IHN0YXRlIC4uLgkxMAkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDAgcmV2aXNp
b25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDAgc3RlcHMpCls4Yzk1OTUz
NDQ0M2FiNTYzZGRiY2NkY2ZlNmEwZjJhNGY2ZmNiODYzXSBzZWNjb21wOiBpbnRyb2R1Y2Ug
d3JpdGVyIGxvY2tpbmcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4NC9vYmotYmlzZWN0CmxzIC1hIC9r
YnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMS9s
aW51eC1kZXZlbDpkZXZlbC1sa3AtaHN4MDEteDg2XzY0LTIwMTQwNjExMDAzNTo4Yzk1OTUz
NDQ0M2FiNTYzZGRiY2NkY2ZlNmEwZjJhNGY2ZmNiODYzOmJpc2VjdC1saW51eDQKCjIwMTQt
MDYtMTEtMDI6NDk6NTUgOGM5NTk1MzQ0NDNhYjU2M2RkYmNjZGNmZTZhMGYyYTRmNmZjYjg2
MyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMS04Yzk1OTUzNDQ0M2FiNTYzZGRiY2Nk
Y2ZlNmEwZjJhNGY2ZmNiODYzCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1oYTQtMDYxMS84Yzk1OTUzNDQ0M2FiNTYzZGRiY2NkY2ZlNmEwZjJhNGY2
ZmNiODYzCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMS04Yzk1OTUzNDQ0M2FiNTYzZGRiY2Nk
Y2ZlNmEwZjJhNGY2ZmNiODYzCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS8ueDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTEtOGM5NTk1MzQ0
NDNhYjU2M2RkYmNjZGNmZTZhMGYyYTRmNmZjYjg2MwprZXJuZWw6IC9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctaGE0LTA2MTEvOGM5NTk1MzQ0NDNhYjU2M2RkYmNjZGNmZTZhMGYyYTRm
NmZjYjg2My92bWxpbnV6LTMuMTUuMC0wNzkxNi1nOGM5NTk1MwoKMjAxNC0wNi0xMS0wMzox
MDo1NSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuIFRFU1QgRkFJTFVSRQpbICAgIDAuMDI3NTU0
XSBDUFU6IEludGVsIENvbW1vbiBLVk0gcHJvY2Vzc29yIChmYW06IDBmLCBtb2RlbDogMDYs
IHN0ZXBwaW5nOiAwMSkKWyAgICAwLjA1MDM2NV0gZnRyYWNlOiBhbGxvY2F0aW5nIDU1OTcz
IGVudHJpZXMgaW4gMjE5IHBhZ2VzClsgICAgMC4wNzAwNzFdIC0tLS0tLS0tLS0tLVsgY3V0
IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDAuMDcxMDYxXSBrZXJuZWwgQlVHIGF0IC9rYnVp
bGQvc3JjL3g4Nl82NC9rZXJuZWwvZm9yay5jOjExMDAhClsgICAgMC4wNzIyNTJdIGludmFs
aWQgb3Bjb2RlOiAwMDAwIFsjMV0gClsgICAgMC4wNzMxNDhdIENQVTogMCBQSUQ6IDAgQ29t
bTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjE1LjAtMDc5MTYtZzhjOTU5NTMgIzEwNQpbICAg
IDAuMDc0NzY2XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8w
MS8yMDExClsgICAgMC4wNzU4NzFdIHRhc2s6IGZmZmZmZmZmODMyMWE1YzAgdGk6IGZmZmZm
ZmZmODMyMDAwMDAgdGFzay50aTogZmZmZmZmZmY4MzIwMDAwMApbICAgIDAuMDc3MzkxXSBS
SVA6IDAwMTA6WzxmZmZmZmZmZjgxMDljNmYxPl0gIFs8ZmZmZmZmZmY4MTA5YzZmMT5dIGNv
cHlfcHJvY2Vzcy5pc3JhLjU2KzB4MTQyMS8weDE0YzAKWyAgICAwLjA3OTE3NV0gUlNQOiAw
MDAwOmZmZmZmZmZmODMyMDNlNjggIEVGTEFHUzogMDAwMTAwMDIKWyAgICAwLjA4MDAwMF0g
UkFYOiAwMDAwMDAwMDAwMDAwMDAyIFJCWDogMDAwMDAwMDAwMDAwMDAwMCBSQ1g6IDAwMDAw
MDAwMDAwMDAwMDAKWyAgICAwLjA4MDAwMF0gUkRYOiAwMDAwMDAwMDAwMDAwMDAwIFJTSTog
MDAwMDAwMDAwMDAwMDAwMCBSREk6IGZmZmY4ODAwMTI0NGY3NjAKWyAgICAwLjA4MDAwMF0g
UkJQOiBmZmZmZmZmZjgzMjAzZWMwIFIwODogZmZmZjg4MDAxMjQ1MzdjMCBSMDk6IDAwMDAw
MDAwMDAwMDAwNDAKWyAgICAwLjA4MDAwMF0gUjEwOiBmZmZmODgwMDEyNDUzODAwIFIxMTog
NzkwODAwMDAwMDAwMDAwMCBSMTI6IGZmZmZmZmZmODI4MWJhZTAKWyAgICAwLjA4MDAwMF0g
UjEzOiAwMDAwMDAwMDAwMDAwMDAwIFIxNDogMDAwMDAwMDAwMDgwMDMwMCBSMTU6IGZmZmY4
ODAwMTI0NGY3NjAKWyAgICAwLjA4MDAwMF0gRlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDAp
IEdTOmZmZmZmZmZmODMyMzAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAg
IDAuMDgwMDAwXSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgw
MDUwMDNiClsgICAgMC4wODAwMDBdIENSMjogMDAwMDAwMDBmZmZmZmZmZiBDUjM6IDAwMDAw
MDAwMDMyMTMwMDAgQ1I0OiAwMDAwMDAwMDAwMDAwNmYwClsgICAgMC4wODAwMDBdIFN0YWNr
OgpbICAgIDAuMDgwMDAwXSAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwIDAw
MDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAxMjQ1MzdjMApbICAgIDAuMDgwMDAwXSAgMDAwMDAw
MDAwMDAwMDAwMCBmZmZmZmZmNDAwMDAwMDAyIGZmZmZmZmZmZmZmZmZmZmYgZmZmZmZmZmY4
M2FmMDkwMApbICAgIDAuMDgwMDAwXSAgMDAwMDAwMDAwMDgwMDMwMCBmZmZmZmZmZjgzYWY3
MmMwIDAwMDAwMDAwMDAwMDAwMDAgZmZmZmZmZmY4MzIwM2YyOApbICAgIDAuMDgwMDAwXSBD
YWxsIFRyYWNlOgpbICAgIDAuMDgwMDAwXSAgWzxmZmZmZmZmZjgxMDljOTA1Pl0gZG9fZm9y
aysweDc1LzB4NTEwClsgICAgMC4wODAwMDBdICBbPGZmZmZmZmZmODI4MjIwYzE+XSA/IGZ0
cmFjZV9wcm9jZXNzX2xvY3MuY29uc3Rwcm9wLjI5KzB4NDJiLzB4NTYxClsgICAgMC4wODAw
MDBdICBbPGZmZmZmZmZmODEwOWNkY2U+XSBrZXJuZWxfdGhyZWFkKzB4MmUvMHg0MApbICAg
IDAuMDgwMDAwXSAgWzxmZmZmZmZmZjgyODFiYTMzPl0gcmVzdF9pbml0KzB4MjMvMHhkMApb
ICAgIDAuMDgwMDAwXSAgWzxmZmZmZmZmZjgzOWYzNzBkPl0gc3RhcnRfa2VybmVsKzB4Nzlk
LzB4N2JiClsgICAgMC4wODAwMDBdICBbPGZmZmZmZmZmODM5ZjJiODk+XSA/IHJlcGFpcl9l
bnZfc3RyaW5nKzB4N2YvMHg3ZgpbICAgIDAuMDgwMDAwXSAgWzxmZmZmZmZmZjgzOWYyMTIw
Pl0gPyBlYXJseV9pZHRfaGFuZGxlcnMrMHgxMjAvMHgxMjAKWyAgICAwLjA4MDAwMF0gIFs8
ZmZmZmZmZmY4MzlmMjZjMD5dIHg4Nl82NF9zdGFydF9yZXNlcnZhdGlvbnMrMHg0Ni8weDRm
ClsgICAgMC4wODAwMDBdICBbPGZmZmZmZmZmODM5ZjI4NzU+XSB4ODZfNjRfc3RhcnRfa2Vy
bmVsKzB4MWFjLzB4MWMyClsgICAgMC4wODAwMDBdIENvZGU6IDgzIDA1IDMzIGZhIGJjIDAy
IDAxIGU4IDZlIGMxIDBiIDAwIDQ4IDgzIDA1IDJlIGZhIGJjIDAyIDAxIGZmIDA0IDI1IGEw
IGZhIDIyIDgzIDQ4IDgzIDA1IDI3IGZhIGJjIDAyIDAxIDQ4IDgzIDA1IGVmIGY3IGJjIDAy
IDAxIDwwZj4gMGIgNDggODMgMDUgZWQgZjcgYmMgMDIgMDEgNDggODMgMDUgNWQgZjkgYmMg
MDIgMDEgYjggZjQgZmYgClsgICAgMC4wODAwMDBdIFJJUCAgWzxmZmZmZmZmZjgxMDljNmYx
Pl0gY29weV9wcm9jZXNzLmlzcmEuNTYrMHgxNDIxLzB4MTRjMApbICAgIDAuMDgwMDAwXSAg
UlNQIDxmZmZmZmZmZjgzMjAzZTY4PgpbICAgIDAuMDgwMDAwXSAtLS1bIGVuZCB0cmFjZSA4
OTc2NGMwMGM5M2M4ZDk3IF0tLS0KWyAgICAwLjA4MDAwMF0gS2VybmVsIHBhbmljIC0gbm90
IHN5bmNpbmc6IEF0dGVtcHRlZCB0byBraWxsIHRoZSBpZGxlIHRhc2shCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctaGE0LTA2MTEvOGM5NTk1MzQ0NDNhYjU2M2RkYmNjZGNmZTZhMGYy
YTRmNmZjYjg2My9kbWVzZy1xdWFudGFsLWl2YjQyLTg2OjIwMTQwNjExMDMxMDU5Ong4Nl82
NC1yYW5kY29uZmlnLWhhNC0wNjExOjMuMTUuMC0wNzkxNi1nOGM5NTk1MzoxMDUKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMS84Yzk1OTUzNDQ0M2FiNTYzZGRiY2NkY2Zl
NmEwZjJhNGY2ZmNiODYzL2RtZXNnLXlvY3RvLWl2YjQxLTEyNDoyMDE0MDYxMTAzMTA1Nzp4
ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMTozLjE1LjAtMDc5MTYtZzhjOTU5NTM6MTA1Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTEvOGM5NTk1MzQ0NDNhYjU2M2RkYmNj
ZGNmZTZhMGYyYTRmNmZjYjg2My9kbWVzZy15b2N0by1pdmI0Mi01MDoyMDE0MDYxMTAzMTA1
NTp4ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMTozLjE1LjAtMDc5MTYtZzhjOTU5NTM6MTA1
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTEvOGM5NTk1MzQ0NDNhYjU2M2Rk
YmNjZGNmZTZhMGYyYTRmNmZjYjg2My9kbWVzZy1xdWFudGFsLWl2YjQ0LTg3OjIwMTQwNjEx
MDMxMTAyOng4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExOjMuMTUuMC0wNzkxNi1nOGM5NTk1
MzoxMDUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMS84Yzk1OTUzNDQ0M2Fi
NTYzZGRiY2NkY2ZlNmEwZjJhNGY2ZmNiODYzL2RtZXNnLXlvY3RvLWl2YjQxLTM0OjIwMTQw
NjExMDMxMTAyOng4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExOjMuMTUuMC0wNzkxNi1nOGM5
NTk1MzoxMDUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMS84Yzk1OTUzNDQ0
M2FiNTYzZGRiY2NkY2ZlNmEwZjJhNGY2ZmNiODYzL2RtZXNnLXlvY3RvLWl2YjQxLTcyOjIw
MTQwNjExMDMxMTAyOng4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExOjMuMTUuMC0wNzkxNi1n
OGM5NTk1MzoxMDUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMS84Yzk1OTUz
NDQ0M2FiNTYzZGRiY2NkY2ZlNmEwZjJhNGY2ZmNiODYzL2RtZXNnLXlvY3RvLWl2YjQyLTI4
OjIwMTQwNjExMDMxMTAyOng4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExOjMuMTUuMC0wNzkx
Ni1nOGM5NTk1MzoxMDUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMS84Yzk1
OTUzNDQ0M2FiNTYzZGRiY2NkY2ZlNmEwZjJhNGY2ZmNiODYzL2RtZXNnLXF1YW50YWwtaXZi
NDEtNjoyMDE0MDYxMTAzMTEwNTp4ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMTozLjE1LjAt
MDc5MTYtZzhjOTU5NTM6MTA1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTEv
OGM5NTk1MzQ0NDNhYjU2M2RkYmNjZGNmZTZhMGYyYTRmNmZjYjg2My9kbWVzZy1xdWFudGFs
LWl2YjQyLTEwNToyMDE0MDYxMTAzMTEwNjp4ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMToz
LjE1LjAtMDc5MTYtZzhjOTU5NTM6MTA1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaGE0
LTA2MTEvOGM5NTk1MzQ0NDNhYjU2M2RkYmNjZGNmZTZhMGYyYTRmNmZjYjg2My9kbWVzZy1x
dWFudGFsLWl2YjQyLTEwNjoyMDE0MDYxMTAzMTEwNjp4ODZfNjQtcmFuZGNvbmZpZy1oYTQt
MDYxMTozLjE1LjAtMDc5MTYtZzhjOTU5NTM6MTA1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaGE0LTA2MTEvOGM5NTk1MzQ0NDNhYjU2M2RkYmNjZGNmZTZhMGYyYTRmNmZjYjg2My9k
bWVzZy1xdWFudGFsLWl2YjQyLTkyOjIwMTQwNjExMDMxMTExOng4Nl82NC1yYW5kY29uZmln
LWhhNC0wNjExOjMuMTUuMC0wNzkxNi1nOGM5NTk1MzoxMDUKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1oYTQtMDYxMS84Yzk1OTUzNDQ0M2FiNTYzZGRiY2NkY2ZlNmEwZjJhNGY2ZmNi
ODYzL2RtZXNnLXF1YW50YWwtaXZiNDQtMTE0OjIwMTQwNjExMDMxMTA4Ong4Nl82NC1yYW5k
Y29uZmlnLWhhNC0wNjExOjMuMTUuMC0wNzkxNi1nOGM5NTk1MzoxMDUKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1oYTQtMDYxMS84Yzk1OTUzNDQ0M2FiNTYzZGRiY2NkY2ZlNmEwZjJh
NGY2ZmNiODYzL2RtZXNnLXF1YW50YWwtaXZiNDQtMzc6MjAxNDA2MTEwMzExMDM6eDg2XzY0
LXJhbmRjb25maWctaGE0LTA2MTE6My4xNS4wLTA3OTE2LWc4Yzk1OTUzOjEwNQova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExLzhjOTU5NTM0NDQzYWI1NjNkZGJjY2RjZmU2
YTBmMmE0ZjZmY2I4NjMvZG1lc2ctcXVhbnRhbC1pdmI0NC02OjIwMTQwNjExMDMxMTExOng4
Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExOjMuMTUuMC0wNzkxNi1nOGM5NTk1MzoxMDUKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMS84Yzk1OTUzNDQ0M2FiNTYzZGRiY2Nk
Y2ZlNmEwZjJhNGY2ZmNiODYzL2RtZXNnLXF1YW50YWwtaXZiNDQtNzU6MjAxNDA2MTEwMzEx
MDU6eDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTE6My4xNS4wLTA3OTE2LWc4Yzk1OTUzOjEw
NQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExLzhjOTU5NTM0NDQzYWI1NjNk
ZGJjY2RjZmU2YTBmMmE0ZjZmY2I4NjMvZG1lc2cteW9jdG8taXZiNDEtNDY6MjAxNDA2MTEw
MzExMDQ6eDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTE6My4xNS4wLTA3OTE2LWc4Yzk1OTUz
OjEwNQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExLzhjOTU5NTM0NDQzYWI1
NjNkZGJjY2RjZmU2YTBmMmE0ZjZmY2I4NjMvZG1lc2cteW9jdG8taXZiNDItMjY6MjAxNDA2
MTEwMzExMDk6eDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTE6My4xNS4wLTA3OTE2LWc4Yzk1
OTUzOjEwNQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExLzhjOTU5NTM0NDQz
YWI1NjNkZGJjY2RjZmU2YTBmMmE0ZjZmY2I4NjMvZG1lc2cteW9jdG8taXZiNDItNTA6MjAx
NDA2MTEwMzExMDQ6eDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTE6My4xNS4wLTA3OTE2LWc4
Yzk1OTUzOjEwNQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExLzhjOTU5NTM0
NDQzYWI1NjNkZGJjY2RjZmU2YTBmMmE0ZjZmY2I4NjMvZG1lc2cteW9jdG8taXZiNDQtNTA6
MjAxNDA2MTEwMzExMDU6eDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTE6My4xNS4wLTA3OTE2
LWc4Yzk1OTUzOjEwNQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExLzhjOTU5
NTM0NDQzYWI1NjNkZGJjY2RjZmU2YTBmMmE0ZjZmY2I4NjMvZG1lc2ctcXVhbnRhbC1pdmI0
NC04NDoyMDE0MDYxMTAzMTExMzp4ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMTozLjE1LjAt
MDc5MTYtZzhjOTU5NTM6MTA1CjA6MjA6MjAgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMK
G1sxOzM1bTIwMTQtMDYtMTEgMDM6MTE6MjYgUkVQRUFUIENPVU5UOiAyMCAgIyAvYy9ib290
LWJpc2VjdC9saW51eDQvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKOGM5NTk1MzQ0NDNhYjU2
M2RkYmNjZGNmZTZhMGYyYTRmNmZjYjg2MyBpcyB0aGUgZmlyc3QgYmFkIGNvbW1pdApjb21t
aXQgOGM5NTk1MzQ0NDNhYjU2M2RkYmNjZGNmZTZhMGYyYTRmNmZjYjg2MwpBdXRob3I6IEtl
ZXMgQ29vayA8a2Vlc2Nvb2tAY2hyb21pdW0ub3JnPgpEYXRlOiAgIFdlZCBNYXkgMjEgMTU6
MTg6MDIgMjAxNCAtMDcwMAoKICAgIHNlY2NvbXA6IGludHJvZHVjZSB3cml0ZXIgbG9ja2lu
ZwogICAgCiAgICBOb3JtYWxseSwgdGFza19zdHJ1Y3Quc2VjY29tcC5maWx0ZXIgaXMgb25s
eSBldmVyIHJlYWQgb3IgbW9kaWZpZWQgYnkKICAgIHRoZSB0YXNrIHRoYXQgb3ducyBpdCAo
Y3VycmVudCkuIFRoaXMgcHJvcGVydHkgYWlkcyBpbiBmYXN0IGFjY2VzcwogICAgZHVyaW5n
IHN5c3RlbSBjYWxsIGZpbHRlcmluZyBhcyByZWFkIGFjY2VzcyBpcyBsb2NrbGVzcy4KICAg
IAogICAgVXBkYXRpbmcgdGhlIHBvaW50ZXIgZnJvbSBhbm90aGVyIHRhc2ssIGhvd2V2ZXIs
IG9wZW5zIHVwIHJhY2UKICAgIGNvbmRpdGlvbnMuIFRvIGFsbG93IGNyb3NzLXRocmVhZCBm
aWx0ZXIgcG9pbnRlciB1cGRhdGVzLCB3cml0ZXMgdG8KICAgIHRoZSBzZWNjb21wIGZpZWxk
cyBhcmUgbm93IHByb3RlY3RlZCBieSB0aGUgc2lnaGFuZCBzcGlubG9jayAod2hpY2gKICAg
IGlzIHVuaXF1ZSB0byB0aGUgdGhyZWFkIGdyb3VwKS4gUmVhZCBhY2Nlc3MgcmVtYWlucyBs
b2NrbGVzcyBiZWNhdXNlCiAgICBwb2ludGVyIHVwZGF0ZXMgdGhlbXNlbHZlcyBhcmUgYXRv
bWljLiAgSG93ZXZlciwgd3JpdGVzIChvciBjbG9uaW5nKQogICAgb2Z0ZW4gZW50YWlsIGFk
ZGl0aW9uYWwgY2hlY2tpbmcgKGxpa2UgbWF4aW11bSBpbnN0cnVjdGlvbiBjb3VudHMpCiAg
ICB3aGljaCByZXF1aXJlIGxvY2tpbmcgdG8gcGVyZm9ybSBzYWZlbHkuCiAgICAKICAgIElu
IHRoZSBjYXNlIG9mIGNsb25pbmcgdGhyZWFkcywgdGhlIGNoaWxkIGlzIGludmlzaWJsZSB0
byB0aGUgc3lzdGVtCiAgICB1bnRpbCBpdCBlbnRlcnMgdGhlIHRhc2sgbGlzdC4gVG8gbWFr
ZSBzdXJlIGEgY2hpbGQgY2FuJ3QgYmUgY2xvbmVkIGZyb20KICAgIGEgdGhyZWFkIGFuZCBs
ZWZ0IGluIGEgcHJpb3Igc3RhdGUsIHNlY2NvbXAgZHVwbGljYXRpb24gaXMgYWRkaXRpb25h
bGx5CiAgICBtb3ZlZCB1bmRlciB0aGUgdGFza2xpc3RfbG9jay4gVGhlbiBwYXJlbnQgYW5k
IGNoaWxkIGFyZSBjZXJ0YWluIGhhdmUKICAgIHRoZSBzYW1lIHNlY2NvbXAgc3RhdGUgd2hl
biB0aGV5IGV4aXQgdGhlIGxvY2suCiAgICAKICAgIEJhc2VkIG9uIHBhdGNoZXMgYnkgV2ls
bCBEcmV3cnkgYW5kIERhdmlkIERyeXNkYWxlLgogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBL
ZWVzIENvb2sgPGtlZXNjb29rQGNocm9taXVtLm9yZz4KCjowNDAwMDAgMDQwMDAwIGVhOWM2
OWIzYzQ5NWQ3YjI5MGVlYTk2YjBmM2NkYzhjNTU2ZTAzNmMgMmU0YTA4ODkwNWNlNWE0ZGQ4
MTY2ODlkNGUwYTI3ODg3YTUyYTYyNyBNCWluY2x1ZGUKOjA0MDAwMCAwNDAwMDAgMzUyNmNh
OTljZTRjZTZjOWVkOTk1YTc2NDU5MTNlODE4OTg3NzkyMiBhY2VhOTAxOGZiZTAyOTc3OTQ2
MmNjZDY5M2FiMjM2ODRlNjMyM2IwIE0Ja2VybmVsCmJpc2VjdCBydW4gc3VjY2VzcwpQcmV2
aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA4Yzk1OTUzLi4uIHNlY2NvbXA6IGludHJvZHVjZSB3
cml0ZXIgbG9ja2luZwpIRUFEIGlzIG5vdyBhdCA2Njk4ZTIwLi4uIHNlY2NvbXA6IHNwbGl0
IGZpbHRlciBwcmVwIGZyb20gY2hlY2sgYW5kIGFwcGx5CmxzIC1hIC9rYnVpbGQtdGVzdHMv
cnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMS9saW51eC1kZXZlbDpk
ZXZlbC1sa3AtaHN4MDEteDg2XzY0LTIwMTQwNjExMDAzNTo2Njk4ZTIwNTkzZTViZmE1Mzg4
OGJiZjEyZjQ0MzFmNDE1MGRjM2MxOmJpc2VjdC1saW51eDQKCjIwMTQtMDYtMTEtMDM6MTE6
MjcgNjY5OGUyMDU5M2U1YmZhNTM4ODhiYmYxMmY0NDMxZjQxNTBkYzNjMSByZXVzZSAva2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExLzY2OThlMjA1OTNlNWJmYTUzODg4YmJm
MTJmNDQzMWY0MTUwZGMzYzEvdm1saW51ei0zLjE1LjAtMDc5MTUtZzY2OThlMjAKCjIwMTQt
MDYtMTEtMDM6MTE6MjcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4JMzAJNjAgU1VDQ0VT
UwoKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgNjY5OGUyMC4uLiBzZWNjb21wOiBzcGxp
dCBmaWx0ZXIgcHJlcCBmcm9tIGNoZWNrIGFuZCBhcHBseQpIRUFEIGlzIG5vdyBhdCAwNWE1
MmVjLi4uIDBkYXkgaGVhZCBndWFyZCBmb3IgJ2RldmVsLWxrcC1oc3gwMS14ODZfNjQtMjAx
NDA2MTEwMDM1JwpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJh
bmRjb25maWctaGE0LTA2MTEvbGludXgtZGV2ZWw6ZGV2ZWwtbGtwLWhzeDAxLXg4Nl82NC0y
MDE0MDYxMTAwMzU6MDVhNTJlYzY4Mzg1NWZjYmY1ZGJiYzUwZDBjNGQyM2RiNGNlMjFhNzpi
aXNlY3QtbGludXg0CiBURVNUIEZBSUxVUkUKWyAgICAwLjAyMjYwN10gQ1BVOiBJbnRlbCBD
b21tb24gS1ZNIHByb2Nlc3NvciAoZmFtOiAwZiwgbW9kZWw6IDA2LCBzdGVwcGluZzogMDEp
ClsgICAgMC4wNDA0ODRdIGZ0cmFjZTogYWxsb2NhdGluZyA1NTk4NSBlbnRyaWVzIGluIDIx
OSBwYWdlcwpbICAgIDAuMDYwMDQzXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0t
LS0tLS0KWyAgICAwLjA2MDY4M10ga2VybmVsIEJVRyBhdCAva2J1aWxkL3NyYy94ODZfNjQv
a2VybmVsL2ZvcmsuYzoxMTAwIQpbICAgIDAuMDYxNDM0XSBpbnZhbGlkIG9wY29kZTogMDAw
MCBbIzFdIApbICAgIDAuMDYyMDc3XSBDUFU6IDAgUElEOiAwIENvbW06IHN3YXBwZXIgTm90
IHRhaW50ZWQgMy4xNS4wLTA4MDc4LWcwNWE1MmVjICM3MwpbICAgIDAuMDYyOTQyXSBIYXJk
d2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMC4w
NjM2OTFdIHRhc2s6IGZmZmZmZmZmODMyMWE1YzAgdGk6IGZmZmZmZmZmODMyMDAwMDAgdGFz
ay50aTogZmZmZmZmZmY4MzIwMDAwMApbICAgIDAuMDY0NzI2XSBSSVA6IDAwMTA6WzxmZmZm
ZmZmZjgxMDljNmYxPl0gIFs8ZmZmZmZmZmY4MTA5YzZmMT5dIGNvcHlfcHJvY2Vzcy5pc3Jh
LjU2KzB4MTQyMS8weDE0YzAKWyAgICAwLjA2NjA1M10gUlNQOiAwMDAwOmZmZmZmZmZmODMy
MDNlNjggIEVGTEFHUzogMDAwMTAwMDIKWyAgICAwLjA2Njc3M10gUkFYOiAwMDAwMDAwMDAw
MDAwMDAyIFJCWDogMDAwMDAwMDAwMDAwMDAwMCBSQ1g6IDAwMDAwMDAwMDAwMDAwMDAKWyAg
ICAwLjA2NzY2NV0gUkRYOiAwMDAwMDAwMDAwMDAwMDAwIFJTSTogMDAwMDAwMDAwMDAwMDAw
MCBSREk6IGZmZmY4ODAwMTI0NGY3NzAKWyAgICAwLjA2ODUzN10gUkJQOiBmZmZmZmZmZjgz
MjAzZWMwIFIwODogZmZmZjg4MDAxMjQ1MzdjMCBSMDk6IDAwMDAwMDAwMDAwMDAwNDAKWyAg
ICAwLjA2OTM5MF0gUjEwOiBmZmZmODgwMDEyNDUzODAwIFIxMTogNzkwODAwMDAwMDAwMDAw
MCBSMTI6IGZmZmZmZmZmODI4MWMxYTAKWyAgICAwLjA3MDAwMF0gUjEzOiAwMDAwMDAwMDAw
MDAwMDAwIFIxNDogMDAwMDAwMDAwMDgwMDMwMCBSMTU6IGZmZmY4ODAwMTI0NGY3NzAKWyAg
ICAwLjA3MDAwMF0gRlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmZmZmZmODMy
MzAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAgIDAuMDcwMDAwXSBDUzog
IDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDNiClsgICAgMC4w
NzAwMDBdIENSMjogMDAwMDAwMDBmZmZmZmZmZiBDUjM6IDAwMDAwMDAwMDMyMTMwMDAgQ1I0
OiAwMDAwMDAwMDAwMDAwNmYwClsgICAgMC4wNzAwMDBdIFN0YWNrOgpbICAgIDAuMDcwMDAw
XSAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAg
ZmZmZjg4MDAxMjQ1MzdjMApbICAgIDAuMDcwMDAwXSAgMDAwMDAwMDAwMDAwMDAwMCBmZmZm
ZmZmNDAwMDAwMDAyIGZmZmZmZmZmZmZmZmZmZmYgZmZmZmZmZmY4M2FmMDkwMApbICAgIDAu
MDcwMDAwXSAgMDAwMDAwMDAwMDgwMDMwMCBmZmZmZmZmZjgzYWY3MmMwIDAwMDAwMDAwMDAw
MDAwMDAgZmZmZmZmZmY4MzIwM2YyOApbICAgIDAuMDcwMDAwXSBDYWxsIFRyYWNlOgpbICAg
IDAuMDcwMDAwXSAgWzxmZmZmZmZmZjgxMDljOTA1Pl0gZG9fZm9yaysweDc1LzB4NTEwClsg
ICAgMC4wNzAwMDBdICBbPGZmZmZmZmZmODI4MjI3ODE+XSA/IGZ0cmFjZV9wcm9jZXNzX2xv
Y3MuY29uc3Rwcm9wLjI5KzB4NDJiLzB4NTYxClsgICAgMC4wNzAwMDBdICBbPGZmZmZmZmZm
ODEwOWNkY2U+XSBrZXJuZWxfdGhyZWFkKzB4MmUvMHg0MApbICAgIDAuMDcwMDAwXSAgWzxm
ZmZmZmZmZjgyODFjMGYzPl0gcmVzdF9pbml0KzB4MjMvMHhkMApbICAgIDAuMDcwMDAwXSAg
WzxmZmZmZmZmZjgzOWYzNzBkPl0gc3RhcnRfa2VybmVsKzB4NzlkLzB4N2JiClsgICAgMC4w
NzAwMDBdICBbPGZmZmZmZmZmODM5ZjJiODk+XSA/IHJlcGFpcl9lbnZfc3RyaW5nKzB4N2Yv
MHg3ZgpbICAgIDAuMDcwMDAwXSAgWzxmZmZmZmZmZjgzOWYyMTIwPl0gPyBlYXJseV9pZHRf
aGFuZGxlcnMrMHgxMjAvMHgxMjAKWyAgICAwLjA3MDAwMF0gIFs8ZmZmZmZmZmY4MzlmMjZj
MD5dIHg4Nl82NF9zdGFydF9yZXNlcnZhdGlvbnMrMHg0Ni8weDRmClsgICAgMC4wNzAwMDBd
ICBbPGZmZmZmZmZmODM5ZjI4NzU+XSB4ODZfNjRfc3RhcnRfa2VybmVsKzB4MWFjLzB4MWMy
ClsgICAgMC4wNzAwMDBdIENvZGU6IDgzIDA1IDMzIDBhIGJkIDAyIDAxIGU4IDNlIGMxIDBi
IDAwIDQ4IDgzIDA1IDJlIDBhIGJkIDAyIDAxIGZmIDA0IDI1IGEwIGZhIDIyIDgzIDQ4IDgz
IDA1IDI3IDBhIGJkIDAyIDAxIDQ4IDgzIDA1IGVmIDA3IGJkIDAyIDAxIDwwZj4gMGIgNDgg
ODMgMDUgZWQgMDcgYmQgMDIgMDEgNDggODMgMDUgNWQgMDkgYmQgMDIgMDEgYjggZjQgZmYg
ClsgICAgMC4wNzAwMDBdIFJJUCAgWzxmZmZmZmZmZjgxMDljNmYxPl0gY29weV9wcm9jZXNz
LmlzcmEuNTYrMHgxNDIxLzB4MTRjMApbICAgIDAuMDcwMDAwXSAgUlNQIDxmZmZmZmZmZjgz
MjAzZTY4PgpbICAgIDAuMDcwMDAwXSAtLS1bIGVuZCB0cmFjZSAwMzk5MWE4MzY0ZTE3YjUx
IF0tLS0KWyAgICAwLjA3MDAwMF0gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEF0dGVt
cHRlZCB0byBraWxsIHRoZSBpZGxlIHRhc2shCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
aGE0LTA2MTEvMDVhNTJlYzY4Mzg1NWZjYmY1ZGJiYzUwZDBjNGQyM2RiNGNlMjFhNy9kbWVz
Zy15b2N0by1pdmI0NC04MzoyMDE0MDYxMTAwNDcyMjp4ODZfNjQtcmFuZGNvbmZpZy1oYTQt
MDYxMTozLjE1LjAtMDgwNzgtZzA1YTUyZWM6NzMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1oYTQtMDYxMS8wNWE1MmVjNjgzODU1ZmNiZjVkYmJjNTBkMGM0ZDIzZGI0Y2UyMWE3L2Rt
ZXNnLXF1YW50YWwtaXZiNDItNzk6MjAxNDA2MTEwMDUzNTM6eDg2XzY0LXJhbmRjb25maWct
aGE0LTA2MTE6My4xNS4wLTA4MDc4LWcwNWE1MmVjOjczCi9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctaGE0LTA2MTEvMDVhNTJlYzY4Mzg1NWZjYmY1ZGJiYzUwZDBjNGQyM2RiNGNlMjFh
Ny9kbWVzZy15b2N0by1pdmI0Mi0zNjoyMDE0MDYxMTAwNTM0OTp4ODZfNjQtcmFuZGNvbmZp
Zy1oYTQtMDYxMTozLjE1LjAtMDgwNzgtZzA1YTUyZWM6NzMKL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1oYTQtMDYxMS8wNWE1MmVjNjgzODU1ZmNiZjVkYmJjNTBkMGM0ZDIzZGI0Y2Uy
MWE3L2RtZXNnLXF1YW50YWwtaXZiNDQtNzk6MjAxNDA2MTEwMDUzNTU6eDg2XzY0LXJhbmRj
b25maWctaGE0LTA2MTE6My4xNS4wLTA4MDc4LWcwNWE1MmVjOjczCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctaGE0LTA2MTEvMDVhNTJlYzY4Mzg1NWZjYmY1ZGJiYzUwZDBjNGQyM2Ri
NGNlMjFhNy9kbWVzZy15b2N0by1pdmI0Mi0zNjoyMDE0MDYxMTAwNTM1ODp4ODZfNjQtcmFu
ZGNvbmZpZy1oYTQtMDYxMTozLjE1LjAtMDgwNzgtZzA1YTUyZWM6NzMKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1oYTQtMDYxMS8wNWE1MmVjNjgzODU1ZmNiZjVkYmJjNTBkMGM0ZDIz
ZGI0Y2UyMWE3L2RtZXNnLXF1YW50YWwtaXZiNDQtNzY6MjAxNDA2MTEwMDQ3MjQ6eDg2XzY0
LXJhbmRjb25maWctaGE0LTA2MTE6My4xNS4wLTA4MDc4LWcwNWE1MmVjOjczCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTEvMDVhNTJlYzY4Mzg1NWZjYmY1ZGJiYzUwZDBj
NGQyM2RiNGNlMjFhNy9kbWVzZy1xdWFudGFsLWl2YjQxLTExMDoyMDE0MDYxMTAwNTM1NDp4
ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMTozLjE1LjAtMDgwNzgtZzA1YTUyZWM6NzMKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMS8wNWE1MmVjNjgzODU1ZmNiZjVkYmJj
NTBkMGM0ZDIzZGI0Y2UyMWE3L2RtZXNnLXlvY3RvLWl2YjQ0LTczOjIwMTQwNjExMDA0NzIz
Ong4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExOjMuMTUuMC0wODA3OC1nMDVhNTJlYzo3Mwov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExLzA1YTUyZWM2ODM4NTVmY2JmNWRi
YmM1MGQwYzRkMjNkYjRjZTIxYTcvZG1lc2ctcXVhbnRhbC1pdmI0MS0xNToyMDE0MDYxMTAw
NTM1Mzp4ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMTozLjE1LjAtMDgwNzgtZzA1YTUyZWM6
NzMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMS8wNWE1MmVjNjgzODU1ZmNi
ZjVkYmJjNTBkMGM0ZDIzZGI0Y2UyMWE3L2RtZXNnLXlvY3RvLWl2YjQxLTEyMDoyMDE0MDYx
MTAwNTQwMTp4ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMTozLjE1LjAtMDgwNzgtZzA1YTUy
ZWM6NzMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMS8wNWE1MmVjNjgzODU1
ZmNiZjVkYmJjNTBkMGM0ZDIzZGI0Y2UyMWE3L2RtZXNnLXlvY3RvLWl2YjQyLTE1OjIwMTQw
NjExMDA1MzU5Ong4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExOjMuMTUuMC0wODA3OC1nMDVh
NTJlYzo3Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExLzA1YTUyZWM2ODM4
NTVmY2JmNWRiYmM1MGQwYzRkMjNkYjRjZTIxYTcvZG1lc2cteW9jdG8taXZiNDEtNTg6MjAx
NDA2MTEwMDUzNTY6eDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTE6My4xNS4wLTA4MDc4LWcw
NWE1MmVjOjczCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTEvMDVhNTJlYzY4
Mzg1NWZjYmY1ZGJiYzUwZDBjNGQyM2RiNGNlMjFhNy9kbWVzZy15b2N0by1pdmI0Mi04Njoy
MDE0MDYxMTAwNTQwMTp4ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMTozLjE1LjAtMDgwNzgt
ZzA1YTUyZWM6NzMKMDoxMzoxMyBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKSEVBRCBp
cyBub3cgYXQgMDVhNTJlYyAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1sa3AtaHN4MDEt
eDg2XzY0LTIwMTQwNjExMDAzNScKCj09PT09PT09PSB1cHN0cmVhbSA9PT09PT09PT0KRnJv
bSBnaXQ6Ly9naXRtaXJyb3IvbGludXMKICAgZDUzYjQ3Yy4uNWIxNzRmZCAgbWFzdGVyICAg
ICAtPiBsaW51cy9tYXN0ZXIKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgMDVhNTJlYy4u
LiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1sa3AtaHN4MDEteDg2XzY0LTIwMTQwNjEx
MDAzNScKSEVBRCBpcyBub3cgYXQgNWIxNzRmZC4uLiBNZXJnZSBicmFuY2ggJ2Zvci0zLjE2
JyBvZiBnaXQ6Ly9saW51eC1uZnMub3JnL35iZmllbGRzL2xpbnV4CmxzIC1hIC9rYnVpbGQt
dGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMS9saW51czpt
YXN0ZXI6NWIxNzRmZDY0NzJiMWQ2YjY0MDJiMzAyMTBhMjEyZjNmZDc3MGQ5NjpiaXNlY3Qt
bGludXg0CgoyMDE0LTA2LTExLTAzOjE1OjM2IDViMTc0ZmQ2NDcyYjFkNmI2NDAyYjMwMjEw
YTIxMmYzZmQ3NzBkOTYgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTEtNWIxNzRmZDY0
NzJiMWQ2YjY0MDJiMzAyMTBhMjEyZjNmZDc3MGQ5NgpDaGVjayBmb3Iga2VybmVsIGluIC9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTEvNWIxNzRmZDY0NzJiMWQ2YjY0MDJi
MzAyMTBhMjEyZjNmZDc3MGQ5Ngp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctaGE0LTA2MTEtNWIxNzRmZDY0
NzJiMWQ2YjY0MDJiMzAyMTBhMjEyZjNmZDc3MGQ5Ngp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvLng4Nl82NC1yYW5kY29uZmlnLWhhNC0w
NjExLTViMTc0ZmQ2NDcyYjFkNmI2NDAyYjMwMjEwYTIxMmYzZmQ3NzBkOTYKa2VybmVsOiAv
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjExLzViMTc0ZmQ2NDcyYjFkNmI2NDAy
YjMwMjEwYTIxMmYzZmQ3NzBkOTYvdm1saW51ei0zLjE1LjAtMDgxNjMtZzViMTc0ZmQKCjIw
MTQtMDYtMTEtMDM6Mjk6MzYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uCTExCTYwIFNVQ0NF
U1MKCgo9PT09PT09PT0gbGludXgtbmV4dCA9PT09PT09PT0KRnJvbSBnaXQ6Ly9naXRtaXJy
b3IvbmV4dAogKyBjMDM4ZjdiLi4uMzA4MDZmOCBha3BtICAgICAgIC0+IG5leHQvYWtwbSAg
KGZvcmNlZCB1cGRhdGUpCiArIDg3MDliMDcuLi41NmI1NDk4IGFrcG0tYmFzZSAgLT4gbmV4
dC9ha3BtLWJhc2UgIChmb3JjZWQgdXBkYXRlKQogKyBkYjIwNmYzLi4uMjdhNGU0MyBtYXN0
ZXIgICAgIC0+IG5leHQvbWFzdGVyICAoZm9yY2VkIHVwZGF0ZSkKICAgOTUxZTI3My4uMTQy
MDhiMCAgc3RhYmxlICAgICAtPiBuZXh0L3N0YWJsZQpGcm9tIGdpdDovL2dpdG1pcnJvci9u
ZXh0CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQtMjAxNDA2MTAgLT4gbmV4dC0yMDE0MDYx
MApQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA1YjE3NGZkLi4uIE1lcmdlIGJyYW5jaCAn
Zm9yLTMuMTYnIG9mIGdpdDovL2xpbnV4LW5mcy5vcmcvfmJmaWVsZHMvbGludXgKSEVBRCBp
cyBub3cgYXQgMjdhNGU0My4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3Ig
MjAxNDA2MTAKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5k
Y29uZmlnLWhhNC0wNjExL25leHQ6bWFzdGVyOjI3YTRlNDM5ZmU1Y2Q5MmI3MDEzN2FlMjM3
YzdhYTY4ODhjMDdiNWE6YmlzZWN0LWxpbnV4NAoKMjAxNC0wNi0xMS0wMzozMjo0MSAyN2E0
ZTQzOWZlNWNkOTJiNzAxMzdhZTIzN2M3YWE2ODg4YzA3YjVhIGNvbXBpbGluZwpRdWV1ZWQg
YnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29u
ZmlnLWhhNC0wNjExLTI3YTRlNDM5ZmU1Y2Q5MmI3MDEzN2FlMjM3YzdhYTY4ODhjMDdiNWEK
Q2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWhhNC0wNjEx
LzI3YTRlNDM5ZmU1Y2Q5MmI3MDEzN2FlMjM3YzdhYTY4ODhjMDdiNWEKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29u
ZmlnLWhhNC0wNjExLTI3YTRlNDM5ZmU1Y2Q5MmI3MDEzN2FlMjM3YzdhYTY4ODhjMDdiNWEK
d2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlLy54
ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYxMS0yN2E0ZTQzOWZlNWNkOTJiNzAxMzdhZTIzN2M3
YWE2ODg4YzA3YjVhCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oYTQtMDYx
MS8yN2E0ZTQzOWZlNWNkOTJiNzAxMzdhZTIzN2M3YWE2ODg4YzA3YjVhL3ZtbGludXotMy4x
NS4wLW5leHQtMjAxNDA2MTAKCjIwMTQtMDYtMTEtMDM6Mzk6NDEgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgLi4uCTEJMzIJNTYJNjAgU1VDQ0VTUwoK
--------------060601010406010102040703
Content-Type: text/plain; charset=UTF-8;
 name="config-3.15.0-07916-g8c95953"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="config-3.15.0-07916-g8c95953"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.15.0 Kernel Configuration
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
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
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
# CONFIG_KERNEL_BZIP2 is not set
CONFIG_KERNEL_LZMA=y
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_FHANDLE=y
CONFIG_USELIB=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
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
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

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
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
# CONFIG_MEMCG_SWAP is not set
CONFIG_MEMCG_KMEM=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
CONFIG_SCHED_AUTOGROUP=y
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
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
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
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# CONFIG_OPROFILE is not set
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
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
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
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
CONFIG_GCOV_FORMAT_AUTODETECT=y
# CONFIG_GCOV_FORMAT_3_4 is not set
# CONFIG_GCOV_FORMAT_4_7 is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_THROTTLING is not set
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_AMIGA_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
# CONFIG_CFQ_GROUP_IOSCHED is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
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
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
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
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_I8K=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
CONFIG_MICROCODE_AMD_EARLY=y
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
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
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
# CONFIG_FRONTSWAP is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
CONFIG_PGTABLE_MAPPING=y
CONFIG_GENERIC_EARLY_IOREMAP=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

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
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_EC_DEBUGFS=y
CONFIG_ACPI_AC=y
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
CONFIG_ACPI_CUSTOM_METHOD=y
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_EXTLOG is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_P4_CLOCKMOD=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

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
# CONFIG_PCIEAER is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
# CONFIG_PCIEASPM_DEFAULT is not set
CONFIG_PCIEASPM_POWERSAVE=y
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
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
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
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
CONFIG_I82092=y
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=y
# CONFIG_RAPIDIO_TSI721 is not set
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
CONFIG_RAPIDIO_DMA_ENGINE=y
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_ENUM_BASIC=y

#
# RapidIO Switch drivers
#
# CONFIG_RAPIDIO_TSI57X is not set
CONFIG_RAPIDIO_CPS_XX=y
CONFIG_RAPIDIO_TSI568=y
CONFIG_RAPIDIO_CPS_GEN2=y
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
# CONFIG_IA32_EMULATION is not set
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_IOSF_MBI=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set
CONFIG_NETFILTER_XTABLES=y
CONFIG_BRIDGE_NF_EBTABLES=y
CONFIG_BRIDGE_EBT_BROUTE=y
CONFIG_BRIDGE_EBT_T_FILTER=y
CONFIG_BRIDGE_EBT_T_NAT=y
# CONFIG_BRIDGE_EBT_802_3 is not set
# CONFIG_BRIDGE_EBT_AMONG is not set
CONFIG_BRIDGE_EBT_ARP=y
# CONFIG_BRIDGE_EBT_IP is not set
CONFIG_BRIDGE_EBT_LIMIT=y
CONFIG_BRIDGE_EBT_MARK=y
CONFIG_BRIDGE_EBT_PKTTYPE=y
# CONFIG_BRIDGE_EBT_STP is not set
CONFIG_BRIDGE_EBT_VLAN=y
CONFIG_BRIDGE_EBT_DNAT=y
CONFIG_BRIDGE_EBT_MARK_T=y
CONFIG_BRIDGE_EBT_REDIRECT=y
# CONFIG_BRIDGE_EBT_SNAT is not set
# CONFIG_BRIDGE_EBT_LOG is not set
CONFIG_BRIDGE_EBT_ULOG=y
# CONFIG_BRIDGE_EBT_NFLOG is not set
CONFIG_ATM=y
# CONFIG_ATM_LANE is not set
CONFIG_STP=y
CONFIG_MRP=y
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_IPDDP=y
# CONFIG_IPDDP_ENCAP is not set
CONFIG_X25=y
CONFIG_LAPB=y
CONFIG_PHONET=y
CONFIG_IEEE802154=y
CONFIG_MAC802154=y
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=y
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=y
CONFIG_HSR=y
CONFIG_CGROUP_NET_PRIO=y
# CONFIG_CGROUP_NET_CLASSID is not set
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
CONFIG_NETROM=y
# CONFIG_ROSE is not set

#
# AX.25 network device drivers
#
CONFIG_MKISS=y
CONFIG_6PACK=y
# CONFIG_BPQETHER is not set
CONFIG_BAYCOM_SER_FDX=y
CONFIG_BAYCOM_SER_HDX=y
# CONFIG_BAYCOM_PAR is not set
CONFIG_YAM=y
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=y
# CONFIG_CAN_GW is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
CONFIG_CAN_SLCAN=y
CONFIG_CAN_DEV=y
# CONFIG_CAN_CALC_BITTIMING is not set
# CONFIG_CAN_LEDS is not set
# CONFIG_CAN_MCP251X is not set
# CONFIG_CAN_JANZ_ICAN3 is not set
CONFIG_PCH_CAN=y
CONFIG_CAN_SJA1000=y
CONFIG_CAN_SJA1000_ISA=y
CONFIG_CAN_SJA1000_PLATFORM=y
CONFIG_CAN_EMS_PCMCIA=y
# CONFIG_CAN_EMS_PCI is not set
CONFIG_CAN_PEAK_PCMCIA=y
CONFIG_CAN_PEAK_PCI=y
CONFIG_CAN_PEAK_PCIEC=y
CONFIG_CAN_KVASER_PCI=y
CONFIG_CAN_PLX_PCI=y
# CONFIG_CAN_C_CAN is not set
# CONFIG_CAN_CC770 is not set
CONFIG_CAN_SOFTING=y
CONFIG_CAN_SOFTING_CS=y
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
# CONFIG_IRNET is not set
# CONFIG_IRCOMM is not set
CONFIG_IRDA_ULTRA=y

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
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#

#
# FIR device drivers
#
# CONFIG_NSC_FIR is not set
CONFIG_WINBOND_FIR=y
CONFIG_SMC_IRCC_FIR=y
CONFIG_ALI_FIR=y
CONFIG_VLSI_FIR=y
CONFIG_VIA_FIR=y
CONFIG_BT=y
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=y
# CONFIG_BT_BNEP_MC_FILTER is not set
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_CMTP=y
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTSDIO=y
CONFIG_BT_HCIUART=y
# CONFIG_BT_HCIUART_H4 is not set
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_ATH3K=y
# CONFIG_BT_HCIUART_LL is not set
# CONFIG_BT_HCIUART_3WIRE is not set
CONFIG_BT_HCIDTL1=y
CONFIG_BT_HCIBT3C=y
CONFIG_BT_HCIBLUECARD=y
# CONFIG_BT_HCIBTUART is not set
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
CONFIG_BT_MRVL_SDIO=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
CONFIG_CFG80211_REG_DEBUG=y
# CONFIG_CFG80211_DEFAULT_PS is not set
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
# CONFIG_MAC80211_LEDS is not set
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_REGULATOR=y
CONFIG_RFKILL_GPIO=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_NET_9P_DEBUG=y
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
# CONFIG_CAIF_NETDEV is not set
CONFIG_CAIF_USB=y
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
# CONFIG_UEVENT_HELPER is not set
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
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
CONFIG_FTL=y
CONFIG_NFTL=y
CONFIG_NFTL_RW=y
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
CONFIG_SSFDC=y
# CONFIG_SM_FTL is not set
CONFIG_MTD_OOPS=y
# CONFIG_MTD_SWAP is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
CONFIG_MTD_CFI_LE_BYTE_SWAP=y
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
CONFIG_MTD_OTP=y
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
# CONFIG_MTD_RAM is not set
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
# CONFIG_MTD_SC520CDP is not set
# CONFIG_MTD_NETSC520 is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
CONFIG_MTD_PMC551_BUGFIX=y
CONFIG_MTD_PMC551_DEBUG=y
# CONFIG_MTD_DATAFLASH is not set
CONFIG_MTD_M25P80=y
CONFIG_MTD_SST25L=y
# CONFIG_MTD_SLRAM is not set
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_BCH=y
CONFIG_MTD_NAND_ECC_BCH=y
# CONFIG_MTD_SM_COMMON is not set
# CONFIG_MTD_NAND_DENALI is not set
# CONFIG_MTD_NAND_GPIO is not set
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=y
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
# CONFIG_MTD_NAND_DOCG4 is not set
CONFIG_MTD_NAND_CAFE=y
CONFIG_MTD_NAND_NANDSIM=y
CONFIG_MTD_NAND_PLATFORM=y
CONFIG_MTD_ONENAND=y
# CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
CONFIG_MTD_ONENAND_GENERIC=y
CONFIG_MTD_ONENAND_OTP=y
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
CONFIG_MTD_UBI_GLUEBI=y
CONFIG_MTD_UBI_BLOCK=y
CONFIG_PARPORT=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT_PC=y
CONFIG_PARPORT_SERIAL=y
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
CONFIG_PARPORT_PC_PCMCIA=y
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=y
CONFIG_BLK_DEV_FD=y
# CONFIG_PARIDE is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
# CONFIG_ZRAM is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
CONFIG_BLK_DEV_DAC960=y
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_NVME=y
CONFIG_BLK_DEV_SKD=y
CONFIG_BLK_DEV_OSD=y
CONFIG_BLK_DEV_SX8=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
CONFIG_BLK_DEV_RSXX=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
CONFIG_AD525X_DPOT_SPI=y
CONFIG_DUMMY_IRQ=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_CS5535_MFGPT is not set
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=y
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
CONFIG_DS1682=y
# CONFIG_TI_DAC7512 is not set
CONFIG_VMWARE_BALLOON=y
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_BMP085_SPI=y
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_LATTICE_ECP3_CONFIG=y
CONFIG_SRAM=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
CONFIG_INTEL_MEI_TXE=y
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#
CONFIG_INTEL_MIC_HOST=y

#
# Intel MIC Card Driver
#
# CONFIG_INTEL_MIC_CARD is not set
CONFIG_GENWQE=y
CONFIG_ECHO=y
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=y
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_ENCLOSURE=y
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_SRP_TGT_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=y
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_ZPODD=y
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
CONFIG_SATA_AHCI_PLATFORM=y
# CONFIG_SATA_INIC162X is not set
CONFIG_SATA_ACARD_AHCI=y
CONFIG_SATA_SIL24=y
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=y
CONFIG_SATA_QSTOR=y
CONFIG_SATA_SX4=y
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
CONFIG_SATA_MV=y
CONFIG_SATA_NV=y
CONFIG_SATA_PROMISE=y
CONFIG_SATA_SIL=y
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
CONFIG_SATA_ULI=y
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
CONFIG_PATA_ALI=y
CONFIG_PATA_AMD=y
# CONFIG_PATA_ARTOP is not set
CONFIG_PATA_ATIIXP=y
# CONFIG_PATA_ATP867X is not set
CONFIG_PATA_CMD64X=y
CONFIG_PATA_CYPRESS=y
# CONFIG_PATA_EFAR is not set
CONFIG_PATA_HPT366=y
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
CONFIG_PATA_HPT3X3=y
CONFIG_PATA_HPT3X3_DMA=y
CONFIG_PATA_IT8213=y
CONFIG_PATA_IT821X=y
# CONFIG_PATA_JMICRON is not set
CONFIG_PATA_MARVELL=y
CONFIG_PATA_NETCELL=y
CONFIG_PATA_NINJA32=y
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
CONFIG_PATA_PDC_OLD=y
CONFIG_PATA_RADISYS=y
CONFIG_PATA_RDC=y
CONFIG_PATA_SCH=y
CONFIG_PATA_SERVERWORKS=y
CONFIG_PATA_SIL680=y
CONFIG_PATA_SIS=y
# CONFIG_PATA_TOSHIBA is not set
CONFIG_PATA_TRIFLEX=y
CONFIG_PATA_VIA=y
CONFIG_PATA_WINBOND=y

#
# PIO-only SFF controllers
#
CONFIG_PATA_CMD640_PCI=y
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
CONFIG_PATA_OPTI=y
CONFIG_PATA_PCMCIA=y
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_ACPI=y
CONFIG_ATA_GENERIC=y
CONFIG_PATA_LEGACY=y
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
CONFIG_BCACHE=y
# CONFIG_BCACHE_DEBUG is not set
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
# CONFIG_BLK_DEV_DM is not set
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=y
# CONFIG_TCM_FILEIO is not set
# CONFIG_TCM_PSCSI is not set
CONFIG_LOOPBACK_TARGET=y
# CONFIG_ISCSI_TARGET is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
# CONFIG_FUSION_FC is not set
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
# CONFIG_DUMMY is not set
CONFIG_EQUALIZER=y
# CONFIG_NET_FC is not set
# CONFIG_NET_TEAM is not set
CONFIG_MACVLAN=y
# CONFIG_MACVTAP is not set
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_RIONET=y
CONFIG_RIONET_TX_SIZE=128
CONFIG_RIONET_RX_SIZE=128
CONFIG_TUN=y
CONFIG_VETH=y
# CONFIG_VIRTIO_NET is not set
CONFIG_NLMON=y
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
CONFIG_ARCNET_1051=y
CONFIG_ARCNET_RAW=y
CONFIG_ARCNET_CAP=y
CONFIG_ARCNET_COM90xx=y
CONFIG_ARCNET_COM90xxIO=y
CONFIG_ARCNET_RIM_I=y
CONFIG_ARCNET_COM20020=y
CONFIG_ARCNET_COM20020_PCI=y
CONFIG_ARCNET_COM20020_CS=y
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=y
# CONFIG_ATM_LANAI is not set
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_FIRESTREAM is not set
CONFIG_ATM_ZATM=y
CONFIG_ATM_ZATM_DEBUG=y
# CONFIG_ATM_NICSTAR is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_AMBASSADOR is not set
# CONFIG_ATM_HORIZON is not set
# CONFIG_ATM_IA is not set
CONFIG_ATM_FORE200E=y
CONFIG_ATM_FORE200E_USE_TASKLET=y
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
CONFIG_ATM_HE=y
# CONFIG_ATM_HE_USE_SUNI is not set
CONFIG_ATM_SOLOS=y

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=y
CONFIG_CAIF_SPI_SLAVE=y
# CONFIG_CAIF_SPI_SYNC is not set
CONFIG_CAIF_HSI=y
# CONFIG_CAIF_VIRTIO is not set
CONFIG_VHOST_NET=y
CONFIG_VHOST_RING=y
CONFIG_VHOST=y

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
# CONFIG_NET_DSA_MV88E6060 is not set
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
CONFIG_NET_VENDOR_ALTEON=y
CONFIG_ACENIC=y
CONFIG_ACENIC_OMIT_TIGON_I=y
CONFIG_ALTERA_TSE=y
CONFIG_NET_VENDOR_AMD=y
CONFIG_AMD8111_ETH=y
# CONFIG_PCNET32 is not set
CONFIG_PCMCIA_NMCLAN=y
# CONFIG_NET_VENDOR_ARC is not set
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
CONFIG_ATL1=y
CONFIG_ATL1E=y
# CONFIG_ATL1C is not set
CONFIG_ALX=y
# CONFIG_NET_VENDOR_BROADCOM is not set
CONFIG_NET_VENDOR_BROCADE=y
CONFIG_BNA=y
CONFIG_NET_CALXEDA_XGMAC=y
# CONFIG_NET_VENDOR_CHELSIO is not set
# CONFIG_NET_VENDOR_CISCO is not set
CONFIG_CX_ECAT=y
CONFIG_DNET=y
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
CONFIG_DL2K=y
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=y
# CONFIG_NET_VENDOR_EXAR is not set
# CONFIG_NET_VENDOR_FUJITSU is not set
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=y
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
CONFIG_IGB_DCA=y
CONFIG_IGBVF=y
# CONFIG_IXGB is not set
# CONFIG_IXGBE is not set
CONFIG_I40E=y
# CONFIG_NET_VENDOR_I825XX is not set
# CONFIG_IP1000 is not set
CONFIG_JME=y
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_MVMDIO=y
CONFIG_SKGE=y
# CONFIG_SKGE_DEBUG is not set
CONFIG_SKGE_GENESIS=y
CONFIG_SKY2=y
CONFIG_SKY2_DEBUG=y
# CONFIG_NET_VENDOR_MELLANOX is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MICROCHIP is not set
CONFIG_FEALNX=y
CONFIG_NET_VENDOR_NATSEMI=y
CONFIG_NATSEMI=y
CONFIG_NS83820=y
CONFIG_NET_VENDOR_8390=y
# CONFIG_PCMCIA_AXNET is not set
# CONFIG_NE2K_PCI is not set
CONFIG_PCMCIA_PCNET=y
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
CONFIG_PCH_GBE=y
CONFIG_ETHOC=y
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
# CONFIG_NET_VENDOR_REALTEK is not set
# CONFIG_SH_ETH is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
# CONFIG_NET_VENDOR_SAMSUNG is not set
CONFIG_NET_VENDOR_SEEQ=y
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
CONFIG_SFC=y
# CONFIG_SFC_MTD is not set
# CONFIG_SFC_MCDI_MON is not set
CONFIG_SFC_SRIOV=y
# CONFIG_NET_VENDOR_SMSC is not set
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
CONFIG_CASSINI=y
CONFIG_NIU=y
CONFIG_NET_VENDOR_TEHUTI=y
CONFIG_TEHUTI=y
CONFIG_NET_VENDOR_TI=y
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VIA=y
CONFIG_VIA_RHINE=y
# CONFIG_VIA_RHINE_MMIO is not set
CONFIG_VIA_VELOCITY=y
# CONFIG_NET_VENDOR_WIZNET is not set
# CONFIG_NET_VENDOR_XIRCOM is not set
# CONFIG_FDDI is not set
CONFIG_NET_SB1000=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
CONFIG_AMD_PHY=y
# CONFIG_MARVELL_PHY is not set
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
# CONFIG_LXT_PHY is not set
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
# CONFIG_SMSC_PHY is not set
CONFIG_BROADCOM_PHY=y
CONFIG_BCM7XXX_PHY=y
CONFIG_BCM87XX_PHY=y
# CONFIG_ICPLUS_PHY is not set
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
# CONFIG_STE10XP is not set
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MICREL_PHY=y
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_MICREL_KS8995MA=y
# CONFIG_PLIP is not set
CONFIG_PPP=y
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_DEFLATE=y
# CONFIG_PPP_FILTER is not set
CONFIG_PPP_MPPE=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=y
CONFIG_PPPOE=y
# CONFIG_PPP_ASYNC is not set
CONFIG_PPP_SYNC_TTY=y
# CONFIG_SLIP is not set
CONFIG_SLHC=y
# CONFIG_WLAN is not set

#
# WiMAX Wireless Broadband devices
#

#
# Enable USB support to see WiMAX USB drivers
#
CONFIG_WAN=y
CONFIG_LANMEDIA=y
CONFIG_HDLC=y
CONFIG_HDLC_RAW=y
CONFIG_HDLC_RAW_ETH=y
CONFIG_HDLC_CISCO=y
# CONFIG_HDLC_FR is not set
CONFIG_HDLC_PPP=y
CONFIG_HDLC_X25=y
CONFIG_PCI200SYN=y
CONFIG_WANXL=y
# CONFIG_WANXL_BUILD_FIRMWARE is not set
CONFIG_PC300TOO=y
CONFIG_FARSYNC=y
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
CONFIG_LAPBETHER=y
CONFIG_X25_ASY=y
# CONFIG_SBNI is not set
CONFIG_IEEE802154_DRIVERS=y
CONFIG_IEEE802154_FAKEHARD=y
# CONFIG_IEEE802154_FAKELB is not set
CONFIG_IEEE802154_AT86RF230=y
CONFIG_IEEE802154_MRF24J40=y
CONFIG_ISDN=y
CONFIG_ISDN_I4L=y
CONFIG_ISDN_AUDIO=y
# CONFIG_ISDN_TTY_FAX is not set
CONFIG_ISDN_X25=y

#
# ISDN feature submodules
#
# CONFIG_ISDN_DRV_LOOP is not set
CONFIG_ISDN_DIVERSION=y

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
# CONFIG_ISDN_DRV_HISAX is not set

#
# Active cards
#
CONFIG_ISDN_CAPI=y
# CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON is not set
CONFIG_CAPI_TRACE=y
CONFIG_ISDN_CAPI_CAPI20=y
# CONFIG_ISDN_CAPI_MIDDLEWARE is not set
# CONFIG_ISDN_CAPI_CAPIDRV is not set

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
CONFIG_ISDN_DRV_AVMB1_B1PCI=y
# CONFIG_ISDN_DRV_AVMB1_B1PCIV4 is not set
CONFIG_ISDN_DRV_AVMB1_B1PCMCIA=y
CONFIG_ISDN_DRV_AVMB1_AVM_CS=y
CONFIG_ISDN_DRV_AVMB1_T1PCI=y
CONFIG_ISDN_DRV_AVMB1_C4=y
# CONFIG_CAPI_EICON is not set
# CONFIG_ISDN_DRV_GIGASET is not set
CONFIG_MISDN=y
CONFIG_MISDN_DSP=y
CONFIG_MISDN_L1OIP=y

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=y
CONFIG_MISDN_HFCMULTI=y
CONFIG_MISDN_AVMFRITZ=y
# CONFIG_MISDN_SPEEDFAX is not set
CONFIG_MISDN_INFINEON=y
# CONFIG_MISDN_W6692 is not set
CONFIG_MISDN_NETJET=y
CONFIG_MISDN_IPAC=y
CONFIG_ISDN_HDLC=y

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
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ADP5589=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
CONFIG_KEYBOARD_QT2160=y
CONFIG_KEYBOARD_LKKBD=y
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
CONFIG_KEYBOARD_MATRIX=y
CONFIG_KEYBOARD_LM8323=y
# CONFIG_KEYBOARD_LM8333 is not set
CONFIG_KEYBOARD_MAX7359=y
CONFIG_KEYBOARD_MCS=y
# CONFIG_KEYBOARD_MPR121 is not set
CONFIG_KEYBOARD_NEWTON=y
# CONFIG_KEYBOARD_OPENCORES is not set
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_XTKBD=y
CONFIG_KEYBOARD_CROS_EC=y
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=y
CONFIG_TOUCHSCREEN_ADS7846=y
CONFIG_TOUCHSCREEN_AD7877=y
CONFIG_TOUCHSCREEN_AD7879=y
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
CONFIG_TOUCHSCREEN_AD7879_SPI=y
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
CONFIG_TOUCHSCREEN_BU21013=y
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP_I2C is not set
# CONFIG_TOUCHSCREEN_CYTTSP_SPI is not set
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP4_I2C=y
CONFIG_TOUCHSCREEN_CYTTSP4_SPI=y
CONFIG_TOUCHSCREEN_DA9034=y
CONFIG_TOUCHSCREEN_DA9052=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
CONFIG_TOUCHSCREEN_EETI=y
CONFIG_TOUCHSCREEN_FUJITSU=y
CONFIG_TOUCHSCREEN_ILI210X=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
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
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
CONFIG_TOUCHSCREEN_PIXCIR=y
CONFIG_TOUCHSCREEN_WM831X=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_MC13783=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
CONFIG_TOUCHSCREEN_TSC2005=y
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_PCAP=y
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_TOUCHSCREEN_ZFORCE=y
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
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
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=y
CONFIG_N_GSM=y
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=y
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
CONFIG_SERIAL_JSM=y
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
# CONFIG_SERIAL_SC16IS7XX is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS=y
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
# CONFIG_SERIAL_IFX6X60 is not set
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
CONFIG_SERIAL_MEN_Z135=y
# CONFIG_PRINTER is not set
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_SI_PROBE_DEFAULTS=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
CONFIG_R3964=y
CONFIG_APPLICOM=y

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=y
CONFIG_CARDMAN_4040=y
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
CONFIG_I2C_MUX_PCA9541=y
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
# CONFIG_I2C_ALI1563 is not set
CONFIG_I2C_ALI15X3=y
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
# CONFIG_I2C_NFORCE2_S4985 is not set
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_GPIO=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=y
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_CROS_EC_TUNNEL is not set
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
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
CONFIG_SPI_GPIO=y
CONFIG_SPI_LM70_LLP=y
CONFIG_SPI_OC_TINY=y
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=y
CONFIG_SPI_PXA2XX_PCI=y
CONFIG_SPI_SC18IS602=y
CONFIG_SPI_XCOMM=y
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_SPMI is not set
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
CONFIG_PPS_CLIENT_LDISC=y
CONFIG_PPS_CLIENT_PARPORT=y
CONFIG_PPS_CLIENT_GPIO=y

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_DP83640_PHY=y
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_F7188X=y
# CONFIG_GPIO_SCH311X is not set
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=y
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_RC5T583 is not set
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_TPS65912 is not set
# CONFIG_GPIO_WM831X is not set
# CONFIG_GPIO_WM8350 is not set
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_CS5535 is not set
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_AMD8111=y
# CONFIG_GPIO_INTEL_MID is not set
# CONFIG_GPIO_ML_IOH is not set
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

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_JANZ_TTL is not set
CONFIG_GPIO_TPS6586X=y

#
# USB GPIO expanders:
#
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=y
# CONFIG_WM8350_POWER is not set
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_88PM860X=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9030=y
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_88PM860X=y
# CONFIG_CHARGER_PCF50633 is not set
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_LP8788 is not set
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_MAX14577=y
CONFIG_CHARGER_MAX8997=y
CONFIG_CHARGER_BQ2415X=y
# CONFIG_CHARGER_BQ24190 is not set
CONFIG_CHARGER_BQ24735=y
CONFIG_CHARGER_SMB347=y
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_APPLESMC=y
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_MC13783_ADC=y
CONFIG_SENSORS_FSCHMD=y
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IIO_HWMON=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LTC2945=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4260=y
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_ADCXX=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
# CONFIG_SENSORS_ADM1275 is not set
CONFIG_SENSORS_LM25066=y
CONFIG_SENSORS_LTC2978=y
# CONFIG_SENSORS_MAX16064 is not set
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
# CONFIG_SENSORS_SCH5627 is not set
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_ADC128D818=y
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=y
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_WM8350=y

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=y
CONFIG_SENSORS_ATK0110=y
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
CONFIG_THERMAL_EMULATION=y
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_X86_PKG_TEMP_THERMAL=y
CONFIG_ACPI_INT3403_THERMAL=y

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
CONFIG_DA9052_WATCHDOG=y
CONFIG_WM831X_WATCHDOG=y
CONFIG_WM8350_WATCHDOG=y
CONFIG_XILINX_WATCHDOG=y
# CONFIG_DW_WATCHDOG is not set
# CONFIG_RETU_WATCHDOG is not set
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=y
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=y
CONFIG_SP5100_TCO=y
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=y
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
CONFIG_PC87413_WDT=y
CONFIG_NV_TCO=y
CONFIG_60XX_WDT=y
# CONFIG_SBC8360_WDT is not set
CONFIG_CPU5_WDT=y
# CONFIG_SMSC_SCH311X_WDT is not set
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=y
CONFIG_W83697UG_WDT=y
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y
CONFIG_MEN_A21_WDT=y

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
# CONFIG_WDTPCI is not set
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
CONFIG_BCMA_HOST_SOC=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_BCM590XX=y
CONFIG_MFD_AXP20X=y
CONFIG_MFD_CROS_EC=y
# CONFIG_MFD_CROS_EC_I2C is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=y
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
CONFIG_EZX_PCAP=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
CONFIG_MFD_RDC321X=y
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP3943 is not set
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS65218=y
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_MFD_TPS65912_SPI=y
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_88PM8607=y
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_AXP20X=y
CONFIG_REGULATOR_BCM590XX=y
CONFIG_REGULATOR_DA903X=y
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9063=y
# CONFIG_REGULATOR_DA9210 is not set
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LP8788=y
CONFIG_REGULATOR_LTC3589=y
CONFIG_REGULATOR_MAX14577=y
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8907 is not set
CONFIG_REGULATOR_MAX8952=y
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MAX8997=y
CONFIG_REGULATOR_MAX77693=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
# CONFIG_REGULATOR_MC13892 is not set
CONFIG_REGULATOR_PCAP=y
CONFIG_REGULATOR_PCF50633=y
# CONFIG_REGULATOR_PFUZE100 is not set
# CONFIG_REGULATOR_RC5T583 is not set
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_TPS6586X=y
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_WM831X=y
# CONFIG_REGULATOR_WM8350 is not set
# CONFIG_REGULATOR_WM8400 is not set
CONFIG_REGULATOR_WM8994=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_RC_CORE=y
# CONFIG_RC_MAP is not set
CONFIG_RC_DECODERS=y
CONFIG_LIRC=y
CONFIG_IR_LIRC_CODEC=y
CONFIG_IR_NEC_DECODER=y
CONFIG_IR_RC5_DECODER=y
# CONFIG_IR_RC6_DECODER is not set
CONFIG_IR_JVC_DECODER=y
# CONFIG_IR_SONY_DECODER is not set
# CONFIG_IR_RC5_SZ_DECODER is not set
CONFIG_IR_SANYO_DECODER=y
# CONFIG_IR_SHARP_DECODER is not set
# CONFIG_IR_MCE_KBD_DECODER is not set
# CONFIG_RC_DEVICES is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#

#
# Customise DVB Frontends
#
CONFIG_DVB_TUNER_DIB0070=y
# CONFIG_DVB_TUNER_DIB0090 is not set

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
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y

#
# Direct Rendering Manager
#
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
CONFIG_DRM_I2C_SIL164=y
# CONFIG_DRM_I2C_NXP_TDA998X is not set
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
# CONFIG_DRM_RADEON_UMS is not set
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I810=y
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
CONFIG_DRM_I915_FBDEV=y
CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT=y
# CONFIG_DRM_I915_UMS is not set
CONFIG_DRM_MGA=y
CONFIG_DRM_SIS=y
CONFIG_DRM_VIA=y
# CONFIG_DRM_SAVAGE is not set
CONFIG_DRM_VMWGFX=y
# CONFIG_DRM_VMWGFX_FBCON is not set
CONFIG_DRM_GMA500=y
CONFIG_DRM_GMA600=y
CONFIG_DRM_GMA3600=y
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=y
CONFIG_DRM_MGAG200=y
CONFIG_DRM_CIRRUS_QEMU=y
# CONFIG_DRM_QXL is not set
CONFIG_DRM_BOCHS=y
# CONFIG_DRM_PTN3460 is not set

#
# Frame buffer Devices
#
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
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
CONFIG_FB_CYBER2000=y
# CONFIG_FB_CYBER2000_DDC is not set
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
CONFIG_FB_OPENCORES=y
CONFIG_FB_S1D13XXX=y
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
# CONFIG_FB_ATY_GX is not set
CONFIG_FB_ATY_BACKLIGHT=y
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
CONFIG_FB_3DFX=y
CONFIG_FB_3DFX_ACCEL=y
# CONFIG_FB_3DFX_I2C is not set
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=y
# CONFIG_FB_CARMINE is not set
CONFIG_FB_VIRTUAL=y
# CONFIG_FB_METRONOME is not set
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
CONFIG_FB_SIMPLE=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_DA903X=y
CONFIG_BACKLIGHT_DA9052=y
CONFIG_BACKLIGHT_APPLE=y
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_WM831X=y
CONFIG_BACKLIGHT_ADP8860=y
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_88PM860X=y
CONFIG_BACKLIGHT_PCF50633=y
CONFIG_BACKLIGHT_LM3630A=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
# CONFIG_BACKLIGHT_LP8788 is not set
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
CONFIG_VGASTATE=y
CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
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
CONFIG_SND_RAWMIDI=y
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_HRTIMER=y
# CONFIG_SND_SEQ_HRTIMER_DEFAULT is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
CONFIG_SND_DEBUG_VERBOSE=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=y
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=y
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=y
CONFIG_SND_DUMMY=y
CONFIG_SND_ALOOP=y
CONFIG_SND_VIRMIDI=y
CONFIG_SND_MTPAV=y
# CONFIG_SND_MTS64 is not set
CONFIG_SND_SERIAL_U16550=y
CONFIG_SND_MPU401=y
# CONFIG_SND_PORTMAN2X4 is not set
# CONFIG_SND_PCI is not set

#
# HD-Audio
#
# CONFIG_SND_SPI is not set
# CONFIG_SND_PCMCIA is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

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
CONFIG_HID_PRODIKEYS=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
CONFIG_HID_KEYTOUCH=y
# CONFIG_HID_KYE is not set
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
# CONFIG_HID_GYRATION is not set
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
# CONFIG_LOGITECH_FF is not set
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_RMI=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=y
# CONFIG_HID_THRUSTMASTER is not set
CONFIG_HID_WACOM=y
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_XINMO is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_HID_SENSOR_HUB=y

#
# I2C HID support
#
CONFIG_I2C_HID=y
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
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
CONFIG_SDIO_UART=y
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
# CONFIG_MMC_RICOH_MMC is not set
CONFIG_MMC_SDHCI_ACPI=y
CONFIG_MMC_SDHCI_PLTFM=y
# CONFIG_MMC_WBSD is not set
CONFIG_MMC_TIFM_SD=y
# CONFIG_MMC_SPI is not set
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=y
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_MEMSTICK_R592=y
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
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
# CONFIG_LEDS_LP5562 is not set
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_LP8788 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
# CONFIG_LEDS_PCA9685 is not set
# CONFIG_LEDS_WM831X_STATUS is not set
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DA903X=y
# CONFIG_LEDS_DA9052 is not set
CONFIG_LEDS_DAC124S085=y
# CONFIG_LEDS_PWM is not set
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_MAX8997=y
CONFIG_LEDS_LM355x=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_DECODE_MCE=y
CONFIG_EDAC_MCE_INJ=y
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_AMD64 is not set
CONFIG_EDAC_E752X=y
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
CONFIG_EDAC_I5400=y
CONFIG_EDAC_I7CORE=y
CONFIG_EDAC_I5000=y
CONFIG_EDAC_I5100=y
CONFIG_EDAC_I7300=y
CONFIG_EDAC_SBRIDGE=y
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
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_88PM860X is not set
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_DS3232=y
CONFIG_RTC_DRV_LP8788=y
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8907=y
CONFIG_RTC_DRV_MAX8997=y
# CONFIG_RTC_DRV_RS5C372 is not set
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=y
CONFIG_RTC_DRV_ISL12057=y
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF2127=y
CONFIG_RTC_DRV_PCF8523=y
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
CONFIG_RTC_DRV_M41T80=y
# CONFIG_RTC_DRV_M41T80_WDT is not set
CONFIG_RTC_DRV_BQ32K=y
# CONFIG_RTC_DRV_TPS6586X is not set
CONFIG_RTC_DRV_RC5T583=y
CONFIG_RTC_DRV_S35390A=y
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
CONFIG_RTC_DRV_EM3027=y
CONFIG_RTC_DRV_RV3029C2=y

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
CONFIG_RTC_DRV_M41T94=y
CONFIG_RTC_DRV_DS1305=y
# CONFIG_RTC_DRV_DS1343 is not set
CONFIG_RTC_DRV_DS1347=y
CONFIG_RTC_DRV_DS1390=y
CONFIG_RTC_DRV_MAX6902=y
CONFIG_RTC_DRV_R9701=y
CONFIG_RTC_DRV_RS5C348=y
CONFIG_RTC_DRV_DS3234=y
CONFIG_RTC_DRV_PCF2123=y
# CONFIG_RTC_DRV_RX4581 is not set
CONFIG_RTC_DRV_MCP795=y

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=y
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_DA9052=y
CONFIG_RTC_DRV_DA9063=y
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=y
# CONFIG_RTC_DRV_DS2404 is not set
CONFIG_RTC_DRV_WM831X=y
CONFIG_RTC_DRV_WM8350=y
CONFIG_RTC_DRV_PCF50633=y

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_PCAP=y
CONFIG_RTC_DRV_MC13XXX=y
# CONFIG_RTC_DRV_MOXART is not set
CONFIG_RTC_DRV_XGENE=y

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
CONFIG_INTEL_IOATDMA=y
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
# CONFIG_DW_DMAC_PCI is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=y
CONFIG_DMA_ENGINE_RAID=y
CONFIG_DCA=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
# CONFIG_UIO_PCI_GENERIC is not set
CONFIG_UIO_NETX=y
CONFIG_UIO_MF624=y
CONFIG_VIRT_DRIVERS=y
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
CONFIG_ACERHDF=y
CONFIG_ASUS_LAPTOP=y
CONFIG_DELL_LAPTOP=y
CONFIG_FUJITSU_LAPTOP=y
CONFIG_FUJITSU_LAPTOP_DEBUG=y
CONFIG_FUJITSU_TABLET=y
# CONFIG_AMILO_RFKILL is not set
CONFIG_HP_ACCEL=y
CONFIG_HP_WIRELESS=y
CONFIG_MSI_LAPTOP=y
CONFIG_PANASONIC_LAPTOP=y
CONFIG_COMPAL_LAPTOP=y
CONFIG_SONY_LAPTOP=y
CONFIG_SONYPI_COMPAT=y
CONFIG_IDEAPAD_LAPTOP=y
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
CONFIG_INTEL_MENLOW=y
# CONFIG_ACPI_WMI is not set
CONFIG_TOPSTAR_LAPTOP=y
CONFIG_TOSHIBA_BT_RFKILL=y
CONFIG_ACPI_CMPC=y
# CONFIG_INTEL_IPS is not set
CONFIG_IBM_RTL=y
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_INTEL_OAKTRAIL=y
CONFIG_SAMSUNG_Q10=y
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
CONFIG_INTEL_SMARTCONNECT=y
CONFIG_PVPANIC=y
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_LAPTOP=y
# CONFIG_CHROMEOS_PSTORE is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
CONFIG_MAILBOX=y
# CONFIG_IOMMU_SUPPORT is not set

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
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
# CONFIG_IIO_BUFFER_CB is not set
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
CONFIG_BMA180=y
CONFIG_HID_SENSOR_ACCEL_3D=y
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y
CONFIG_IIO_ST_ACCEL_SPI_3AXIS=y
CONFIG_KXSD9=y
# CONFIG_MMA8452 is not set

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
CONFIG_AD7266=y
# CONFIG_AD7298 is not set
CONFIG_AD7476=y
# CONFIG_AD7791 is not set
CONFIG_AD7793=y
CONFIG_AD7887=y
CONFIG_AD7923=y
CONFIG_AD799X=y
CONFIG_LP8788_ADC=y
CONFIG_MAX1363=y
CONFIG_MCP320X=y
CONFIG_MCP3422=y
CONFIG_MEN_Z188_ADC=y
CONFIG_NAU7802=y
CONFIG_TI_ADC081C=y
CONFIG_TI_AM335X_ADC=y

#
# Amplifiers
#
# CONFIG_AD8366 is not set

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_SPI=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
# CONFIG_AD5360 is not set
# CONFIG_AD5380 is not set
CONFIG_AD5421=y
# CONFIG_AD5446 is not set
CONFIG_AD5449=y
# CONFIG_AD5504 is not set
CONFIG_AD5624R_SPI=y
# CONFIG_AD5686 is not set
CONFIG_AD5755=y
CONFIG_AD5764=y
# CONFIG_AD5791 is not set
CONFIG_AD7303=y
CONFIG_MAX517=y
CONFIG_MCP4725=y

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
CONFIG_AD9523=y

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
CONFIG_ADF4350=y

#
# Digital gyroscope sensors
#
CONFIG_ADIS16080=y
CONFIG_ADIS16130=y
CONFIG_ADIS16136=y
# CONFIG_ADIS16260 is not set
CONFIG_ADXRS450=y
# CONFIG_HID_SENSOR_GYRO_3D is not set
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_IIO_ST_GYRO_SPI_3AXIS=y
CONFIG_ITG3200=y

#
# Humidity sensors
#
CONFIG_DHT11=y
CONFIG_SI7005=y

#
# Inertial measurement units
#
CONFIG_ADIS16400=y
# CONFIG_ADIS16480 is not set
CONFIG_INV_MPU6050_IIO=y
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
CONFIG_APDS9300=y
CONFIG_CM32181=y
# CONFIG_CM36651 is not set
CONFIG_GP2AP020A00F=y
CONFIG_HID_SENSOR_ALS=y
# CONFIG_HID_SENSOR_PROX is not set
CONFIG_SENSORS_LM3533=y
CONFIG_LTR501=y
CONFIG_TCS3472=y
CONFIG_SENSORS_TSL2563=y
CONFIG_TSL4531=y
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
CONFIG_AK8975=y
CONFIG_MAG3110=y
CONFIG_HID_SENSOR_MAGNETOMETER_3D=y
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
CONFIG_IIO_ST_MAGN_SPI_3AXIS=y

#
# Inclinometer sensors
#
# CONFIG_HID_SENSOR_INCLINOMETER_3D is not set
CONFIG_HID_SENSOR_DEVICE_ROTATION=y

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure sensors
#
# CONFIG_HID_SENSOR_PRESS is not set
# CONFIG_MPL115 is not set
CONFIG_MPL3115=y
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y
CONFIG_IIO_ST_PRESS_SPI=y

#
# Lightning sensors
#
CONFIG_AS3935=y

#
# Temperature sensors
#
CONFIG_MLX90614=y
CONFIG_TMP006=y
# CONFIG_NTB is not set
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
CONFIG_VME_TSI148=y

#
# VME Board Drivers
#
# CONFIG_VMIVME_7805 is not set

#
# VME Device Drivers
#
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_LPSS=y
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
CONFIG_FMC_TRIVIAL=y
# CONFIG_FMC_WRITE_EEPROM is not set
CONFIG_FMC_CHARDEV=y

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
# CONFIG_PHY_SAMSUNG_USB2 is not set
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y
CONFIG_MCB=y
# CONFIG_MCB_PCI is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_DMIID is not set
# CONFIG_DMI_SYSFS is not set
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
# CONFIG_EXT2_FS_POSIX_ACL is not set
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
CONFIG_XFS_DEBUG=y
CONFIG_GFS2_FS=y
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
# CONFIG_OCFS2_FS_STATS is not set
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_OCFS2_DEBUG_FS=y
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
CONFIG_FSCACHE_DEBUG=y
CONFIG_FSCACHE_OBJECT_LIST=y
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
CONFIG_NTFS_DEBUG=y
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=y
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
# CONFIG_HFSPLUS_FS_POSIX_ACL is not set
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
# CONFIG_EFS_FS is not set
# CONFIG_JFFS2_FS is not set
# CONFIG_UBIFS_FS is not set
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=y
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
CONFIG_ROMFS_FS=y
# CONFIG_ROMFS_BACKED_BY_BLOCK is not set
CONFIG_ROMFS_BACKED_BY_MTD=y
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_FTRACE=y
# CONFIG_PSTORE_RAM is not set
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
CONFIG_UFS_DEBUG=y
CONFIG_EXOFS_FS=y
# CONFIG_EXOFS_DEBUG is not set
# CONFIG_F2FS_FS is not set
CONFIG_ORE=y
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
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
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
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
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_PI_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_TORTURE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
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
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_TRACEPOINT_BENCHMARK=y
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
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
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
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
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
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
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
# CONFIG_CRYPTO_DES is not set
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
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
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
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
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
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
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
CONFIG_DDR=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y


--------------060601010406010102040703
Content-Type: text/plain; charset=UTF-8;
 name="Attached Message Part"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Attached Message Part"

_______________________________________________
LKP mailing list
LKP@linux.intel.com


--------------060601010406010102040703--
