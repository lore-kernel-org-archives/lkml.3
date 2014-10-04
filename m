Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaJDNsB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 09:48:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:53593 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbaJDNr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 09:47:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,653,1406617200"; 
   d="log'?scan'208";a="481945745"
Date: Sat, 4 Oct 2014 21:47:29 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: [x86LKP] PANIC: double fault, error_code: 0xffffffffffffffff
Message-ID: <20141004134729.GB5214@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="WhfpMioaduB5tiZL"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WhfpMioaduB5tiZL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Andi,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc.git x86/fsgs-2

commit b8a868e9ea876a1b40020397305533c095921d7a
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Wed Apr 23 13:26:20 2014 -0700
Commit:     Andi Kleen <ak@linux.intel.com>
CommitDate: Fri Oct 3 15:19:56 2014 -0700

    x86: Add support for rd/wr fs/gs base
    
    IvyBridge added new instructions to directly write the fs and gs
    64bit base registers. Previously this had to be done with a system
    call to write to MSRs. The main use case is fast user space threading
    and switching the fs/gs registers quickly there. Another use
    case is having (relatively) cheap access to a new address
    register per thread.
    
    The instructions are opt-in and have to be explicitely enabled
    by the OS.
    
    Previously Linux couldn't support this because the paranoid
    entry code relied on the gs base never being negative outside
    the kernel to decide when to use swaps. It would check the gs MSR
    value and assume it was already running in kernel if the value
    was already negative.
    
    To make this work we have to revamp the paranoid exception
    path to not rely on this. We can use the new instructions
    to get (relatively) quick access to the values.
    
    This is also significantly faster than a MSR read, so will speed
    NMIs (critical for profiling)
    
    The original patch compared the gs with the kernel gs and
    assumed that if it was the same swapgs is not needed
    (and no user space processing was needed). This
    was nice and simple and didn't need a lot of changes.
    
    But this had the side effect that if a user process set its
    GS to the same as the kernel it may lose rescheduling
    checks (so a racing reschedule IPI would have been
    only acted upon the next non paranoid interrupt)
    
    This version now switches to full save/restore of the GS.
    This requires quite some changes in the paranoid path.
    Unfortunately didn't come up with a simpler scheme:
    
    The kernel gs for the paranoid path is now stored at the
    bottom of the IST stack (so that it can be derived from RSP).
    For this we need to know the size of the IST stack
    (4K or 8K), which is now passed in as a stack parameter
    to save_paranoid.
    
    Previously we had a flag in EBX that indicated whether
    SWAPGS needs to be called later or not. In the new scheme
    this turns into a tristate, with a new "restore from R15"
    mode. The exit paths are all adjusted to handle this correctly.
    
    There is one complication: to allow debuggers (especially
    from the int3 or debug vectors) access to the user GS
    we need to save it in the task struct. Normally
    the next context switch would overwrite it with the wrong
    value from kernel_gs, so we set new flag also in task_struct
    that prevents it.
    
    Also to prevent recursive interrupts clobbering this
    state in the task_struct this is only done for interrupts
    coming from ring 3.
    
    After a schedule comes back we check if the flag is still
    set. If it wasn't set the GS is back in the (swapped) kernel
    gs so we revert to the SWAPGS mode, instead of restoring GS.
    
    Then after these changes we need to also use the new instructions
    to save/restore fs and gs, so that the new values set by the
    users won't disappear.  This is also significantly
    faster for the case when the 64bit base has to be switched
    (that is when GS is larger than 4GB), as we can replace
    the slow MSR write with a faster wr[fg]sbase execution.
    
    The instructions do not context switch
    the segment index, so the old invariant that fs or gs index
    have to be 0 for a different 64bit value to stick is still
    true. Previously it was enforced by arch_prctl, now the user
    program has to make sure it keeps the segment indexes zero.
    If it doesn't the changes may not stick.
    
    This is in term enables fast switching when there are
    enough threads that their TLS segment does not fit below 4GB,
    or alternatively programs that use fs as an additional base
    register will not get a sigificant context switch penalty.
    
    It is all done in a single patch to avoid bisect crash
    holes.
    
    v2: Change to save/restore GS instead of using swapgs
    based on the value. Large scale changes.
    Signed-off-by: Andi Kleen <ak@linux.intel.com>

+------------------------------------------+------------+------------+------------+
|                                          | 598d570a05 | b8a868e9ea | 8048975233 |
+------------------------------------------+------------+------------+------------+
| boot_successes                           | 900        | 280        | 79         |
| boot_failures                            | 0          | 20         | 2          |
| PANIC:double_fault,                      | 0          | 12         | 2          |
| Kernel_panic-not_syncing:Machine_halted  | 0          | 11         | 2          |
| BUG:unable_to_handle_kernel              | 0          | 5          |            |
| Oops                                     | 0          | 3          |            |
| RIP:pgd_free                             | 0          | 1          |            |
| BUG:kernel_boot_crashed                  | 0          | 4          |            |
| RIP:show_stack_log_lvl                   | 0          | 1          |            |
| Kernel_panic-not_syncing:Fatal_exception | 0          | 1          |            |
+------------------------------------------+------------+------------+------------+

[    5.087621] Freeing unused kernel memory: 1248K (ffff8800014c8000 - ffff880001600000)
[    5.136856] Freeing unused kernel memory: 1936K (ffff88000181c000 - ffff880001a00000)
[    5.167951] random: init urandom read with 5 bits of entropy available
[   19.307116] PANIC: double fault, error_code: 0xffffffffffffffff
[   19.309941] Kernel panic - not syncing: Machine halted.
[   19.310083] CPU: 1 PID: 150 Comm: trinity-main Not tainted 3.17.0-rc7-00004-gb8a868e #130
[   19.310083] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[   19.310083]  0000000000000000 ffff880012707e88 ffffffff814befff ffffffff8174c441
[   19.310083]  ffff880012707f08 ffffffff814bcd7d 0000000000000008 ffff880012707f18
[   19.310083]  ffff880012707eb0 ffffffff81ba8d00 0000000000000046 ffff880010c7ffd8
[   19.310083] Call Trace:
[   19.310083]  <#DF>  [<ffffffff814befff>] dump_stack+0x4d/0x66
[   19.310083]  [<ffffffff814bcd7d>] panic+0xc4/0x1d6
[   19.310083]  [<ffffffff8102a96c>] df_debug+0x2c/0x2c
[   19.310083]  [<ffffffff81002df9>] do_double_fault+0x62/0x7d
[   19.310083]  [<ffffffff814c5d8e>] double_fault+0x2e/0x40
[   19.310083]  [<ffffffff814c610d>] ? async_page_fault+0xd/0x30
[   19.310083]  <<EOE>>  <UNK> 
[   19.310083] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)

git bisect start 80489752332f4e4f75343d6b539095b366013bc6 fe82dcec644244676d55a1384c958d5f67979adb --
git bisect  bad 0e3e2d7a608587a01aaa9eaabd7f75cad56cb8ea  # 07:18     19-      6  Merge 'ak/x86/fsgs-2' into devel-lkp-hsx02-x86_64-201410040643
git bisect good 63007bebe851b304d6e2d66fd08307a4fd35cc50  # 08:09    300+      1  0day base guard for 'devel-lkp-hsx02-x86_64-201410040643'
git bisect  bad b8a868e9ea876a1b40020397305533c095921d7a  # 08:18     78-     19  x86: Add support for rd/wr fs/gs base
git bisect good a0b0be64599f50dc2c9fa85734026701221f186a  # 08:27    300+      0  x86: Naturally align the debug IST stack
git bisect good 598d570a05cd31500fb15a843a92f68ddb1b3618  # 08:33    300+      0  x86: Add intrinsics/macros for new rd/wr fs/gs base instructions
# first bad commit: [b8a868e9ea876a1b40020397305533c095921d7a] x86: Add support for rd/wr fs/gs base
git bisect good 598d570a05cd31500fb15a843a92f68ddb1b3618  # 08:38    900+      0  x86: Add intrinsics/macros for new rd/wr fs/gs base instructions
git bisect  bad 80489752332f4e4f75343d6b539095b366013bc6  # 08:38      0-      2  0day head guard for 'devel-lkp-hsx02-x86_64-201410040643'
git bisect good 126d4576cb73c8a440adc37c129589cd66051bcc  # 08:43    900+      0  Merge branch 'i2c/for-current' of git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux
git bisect good 2e1d004b9645628c64a2db55ef6b81fadf5e6e91  # 08:55    900+      0  Add linux-next specific files for 20141003


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=quantal-core-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-cpu kvm64
	-enable-kvm
	-kernel $kernel
	-initrd $initrd
	-m 320
	-smp 2
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

--WhfpMioaduB5tiZL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-lkp-nex04-6:20141004081755:x86_64-randconfig-hxb1-1004::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-rc7-00004-gb8a868e (kbuild@lkp-hsx02) (=
gcc version 4.9.1 (Debian 4.9.1-11) ) #130 SMP Sat Oct 4 08:16:48 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-hxb1-1004/linux-devel:devel-lkp-hsx02-x86_64-201410040643:b8a868e9ea87=
6a1b40020397305533c095921d7a:bisect-linux-2/.vmlinuz-b8a868e9ea876a1b400203=
97305533c095921d7a-20141004081702-171-lkp-nex04 branch=3Dlinux-devel/devel-=
lkp-hsx02-x86_64-201410040643 BOOT_IMAGE=3D/kernel/x86_64-randconfig-hxb1-1=
004/b8a868e9ea876a1b40020397305533c095921d7a/vmlinuz-3.17.0-rc7-00004-gb8a8=
68e drbd.minor_count=3D8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-2014=
0531_083030-gandalf 04/01/2014
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x400000000
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01c02000, 0x01c02fff] PGTABLE
[    0.000000] BRK [0x01c03000, 0x01c03fff] PGTABLE
[    0.000000] BRK [0x01c04000, 0x01c04fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13fdffff]
[    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13fdffff] page 4k
[    0.000000] BRK [0x01c05000, 0x01c05fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x12925000-0x13fd7fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0C90 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FE18BD 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FE0B37 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FE0000 000040
[    0.000000] ACPI: SSDT 0x0000000013FE0BAB 000C5A (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FE1805 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FE1885 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013fdffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13fdffff]
[    0.000000]   NODE_DATA [mem 0x13fdb000-0x13fdffff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13fda001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880011a0000=
0-ffff880011ffffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1064 pages used for memmap
[    0.000000]   DMA32 zone: 77792 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff880012600000 s73600 r8192=
 d20608 u1048576
[    0.000000] pcpu-alloc: s73600 r8192 d20608 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1260ce40
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80649
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-hxb1-1004/linux-devel:devel-lkp-hsx02-x86_64-201410040643:b8a86=
8e9ea876a1b40020397305533c095921d7a:bisect-linux-2/.vmlinuz-b8a868e9ea876a1=
b40020397305533c095921d7a-20141004081702-171-lkp-nex04 branch=3Dlinux-devel=
/devel-lkp-hsx02-x86_64-201410040643 BOOT_IMAGE=3D/kernel/x86_64-randconfig=
-hxb1-1004/b8a868e9ea876a1b40020397305533c095921d7a/vmlinuz-3.17.0-rc7-0000=
4-gb8a868e drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Memory: 284912K/327160K available (4891K kernel code, 616K r=
wdata, 2160K rodata, 832K init, 576K bss, 42248K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:56 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-rc7-00004-gb8a868e (kbuild@lkp-hsx02) (=
gcc version 4.9.1 (Debian 4.9.1-11) ) #130 SMP Sat Oct 4 08:16:48 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-hxb1-1004/linux-devel:devel-lkp-hsx02-x86_64-201410040643:b8a868e9ea87=
6a1b40020397305533c095921d7a:bisect-linux-2/.vmlinuz-b8a868e9ea876a1b400203=
97305533c095921d7a-20141004081702-171-lkp-nex04 branch=3Dlinux-devel/devel-=
lkp-hsx02-x86_64-201410040643 BOOT_IMAGE=3D/kernel/x86_64-randconfig-hxb1-1=
004/b8a868e9ea876a1b40020397305533c095921d7a/vmlinuz-3.17.0-rc7-00004-gb8a8=
68e drbd.minor_count=3D8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-2014=
0531_083030-gandalf 04/01/2014
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x400000000
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01c02000, 0x01c02fff] PGTABLE
[    0.000000] BRK [0x01c03000, 0x01c03fff] PGTABLE
[    0.000000] BRK [0x01c04000, 0x01c04fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13fdffff]
[    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13fdffff] page 4k
[    0.000000] BRK [0x01c05000, 0x01c05fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x12925000-0x13fd7fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0C90 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FE18BD 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FE0B37 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FE0000 000040
[    0.000000] ACPI: SSDT 0x0000000013FE0BAB 000C5A (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FE1805 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FE1885 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013fdffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13fdffff]
[    0.000000]   NODE_DATA [mem 0x13fdb000-0x13fdffff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13fda001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880011a0000=
0-ffff880011ffffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1064 pages used for memmap
[    0.000000]   DMA32 zone: 77792 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff880012600000 s73600 r8192=
 d20608 u1048576
[    0.000000] pcpu-alloc: s73600 r8192 d20608 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1260ce40
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80649
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-hxb1-1004/linux-devel:devel-lkp-hsx02-x86_64-201410040643:b8a86=
8e9ea876a1b40020397305533c095921d7a:bisect-linux-2/.vmlinuz-b8a868e9ea876a1=
b40020397305533c095921d7a-20141004081702-171-lkp-nex04 branch=3Dlinux-devel=
/devel-lkp-hsx02-x86_64-201410040643 BOOT_IMAGE=3D/kernel/x86_64-randconfig=
-hxb1-1004/b8a868e9ea876a1b40020397305533c095921d7a/vmlinuz-3.17.0-rc7-0000=
4-gb8a868e drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Memory: 284912K/327160K available (4891K kernel code, 616K r=
wdata, 2160K rodata, 832K init, 576K bss, 42248K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:56 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 1572864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2260.998 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 4521.99 Bogo=
MIPS (lpj=3D22609980)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] ACPI: Core revision 20140724
[    0.023598] ACPI: All ACPI Tables successfully acquired
[    0.026048] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.030170] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.040100] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.042284] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.044801] Initializing cgroup subsys memory
[    0.046635] Initializing cgroup subsys devices
[    0.050018] Initializing cgroup subsys freezer
[    0.051881] Initializing cgroup subsys hugetlb
[    0.053801] mce: CPU supports 10 MCE banks
[    0.055488] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.055488] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.060180] Freeing SMP alternatives memory: 20K (ffffffff81b6c000 - fff=
fffff81b71000)
[    0.068322] Getting VERSION: 1050014
[    0.070019] Getting VERSION: 1050014
[    0.071682] Getting ID: 0
[    0.073133] Getting ID: ff000000
[    0.074725] Getting LVT0: 8700
[    0.076245] Getting LVT1: 8400
[    0.077875] enabled ExtINT on CPU#0
[    0.091169] ENABLING IO-APIC IRQs
[    0.092663] init IO_APIC IRQs
[    0.094087]  apic 0 pin 0 not connected
[    0.095695] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.100052] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.103431] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.106787] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.110039] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.113372] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.116848] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.120040] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.130032] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.133584] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.140044] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.150032] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.153423] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.160038] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.170033] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.173365] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.180043]  apic 0 pin 16 not connected
[    0.190005]  apic 0 pin 17 not connected
[    0.191607]  apic 0 pin 18 not connected
[    0.193243]  apic 0 pin 19 not connected
[    0.194828]  apic 0 pin 20 not connected
[    0.196476]  apic 0 pin 21 not connected
[    0.200012]  apic 0 pin 22 not connected
[    0.210004]  apic 0 pin 23 not connected
[    0.211795] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.214181] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.220013] Using local APIC timer interrupts.
[    0.220013] calibrating APIC timer ...
[    0.240000] ... lapic delta =3D 9374425
[    0.240000] ... PM-Timer delta =3D 536895
[    0.240000] APIC calibration not consistent with PM-Timer: 149ms instead=
 of 100ms
[    0.240000] APIC delta adjusted to PM-Timer: 6250035 (9374425)
[    0.240000] TSC delta adjusted to PM-Timer: 226098153 (339124491)
[    0.240000] ..... delta 6250035
[    0.240000] ..... mult: 268436959
[    0.240000] ..... calibration result: 10000056
[    0.240000] ..... CPU clock speed is 2260.9815 MHz.
[    0.240000] ..... host bus clock speed is 1000.0056 MHz.
[    0.240126] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.245323] x86: Booting SMP configuration:
[    0.250014] .... node  #0, CPUs:      #1
[    0.020000] kvm-clock: cpu 1, msr 0:13fda041, secondary cpu clock
[    0.020000] masked ExtINT on CPU#1
[    0.280100] x86: Booted up 1 node, 2 CPUs
[    0.280063] KVM setup async PF for cpu 1
[    0.280063] kvm-stealtime: cpu 1, msr 1270ce40
[    0.290011] smpboot: Total of 2 processors activated (9043.99 BogoMIPS)
[    0.330040] prandom: seed boundary self test passed
[    0.332866] prandom: 100 self tests passed
[    0.334532] pinctrl core: initialized pinctrl subsystem
[    0.340197] regulator-dummy: no parameters
[    0.350181] NET: Registered protocol family 16
[    0.360000] cpuidle: using governor ladder
[    0.361769] cpuidle: using governor menu
[    0.363892] ACPI: bus type PCI registered
[    0.370128] PCI: Using configuration type 1 for base access
[    0.418651] ACPI: Added _OSI(Module Device)
[    0.420005] ACPI: Added _OSI(Processor Device)
[    0.421786] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.423548] ACPI: Added _OSI(Processor Aggregator Device)
[    0.426301] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:3)
[    0.440180] ACPI: Interpreter enabled
[    0.441706] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140724/hwxface-580)
[    0.451245] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140724/hwxface-580)
[    0.455081] ACPI: (supports S0 S3 S5)
[    0.456705] ACPI: Using IOAPIC for interrupt routing
[    0.460050] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.481077] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.483217] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments]
[    0.490015] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.492932] PCI host bridge to bus 0000:00
[    0.500020] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.510008] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.512154] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.514305] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.516456] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.518475] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.520023] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.522345] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.524752] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.530661] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.533576] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.553083] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.556633] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.559168] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.560006] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.562391] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.564921] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.567589] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.570027] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.572834] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.582104] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.586194] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.603678] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.610255] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.621567] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.625173] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.661437] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.663963] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.670447] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.683278] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.691817] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.694577] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.697306] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.720141] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.723171] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.725366] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.727298] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.730008] vgaarb: loaded
[    0.740008] vgaarb: bridge control possible 0000:00:02.0
[    0.741980] media: Linux media interface: v0.10
[    0.743783] pps_core: LinuxPPS API ver. 1 registered
[    0.750010] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.760147] Advanced Linux Sound Architecture Driver Initialized.
[    0.762205] PCI: Using ACPI for IRQ routing
[    0.763838] PCI: pci_cache_line_size set to 64 bytes
[    0.770170] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.772168] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    0.780748] Switched to clocksource kvm-clock
[    0.782695] pnp: PnP ACPI init
[    0.784251] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.787342] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.806895] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.810123] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.812404] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.833735] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.836014] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.888565] pnp 00:03: [dma 2]
[    0.890094] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.892437] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.909106] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.911336] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.914466] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.931849] pnp: PnP ACPI: found 6 devices
[    0.933553] INFO_MDMA: LNW DMA Driver Version 1.1.0
[    0.959608] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.961627] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    0.963585] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    0.981590] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    0.983614] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    0.985622] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    0.987772] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    0.989984] NET: Registered protocol family 1
[    1.009817] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.011940] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.032074] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.034250] pci 0000:00:02.0: Video device with shadowed ROM
[    1.036306] PCI: CLS 0 bytes, default 64
[    1.038090] Unpacking initramfs...
[    3.328238] Freeing initrd memory: 23244K (ffff880012925000 - ffff880013=
fd8000)
[    3.367072] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    3.379688] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    3.397099] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    3.413282] PCLMULQDQ-NI instructions are not detected.
[    3.415218] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    3.421443] futex hash table entries: 512 (order: 3, 32768 bytes)
[    3.423614] Initialise system trusted keyring
[    3.446569] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.448830] zpool: loaded
[    3.450271] zbud: loaded
[    3.462164] ntfs: driver 2.1.30 [Flags: R/W DEBUG].
[    3.470159] efs: 1.0a - http://aeschi.ch.eu.org/efs/
[    3.472103] romfs: ROMFS MTD (C) 2007 Red Hat, Inc.
[    3.480121] QNX4 filesystem 0.2.3 registered.
[    3.490348] msgmni has been set to 601
[    3.510840] Key type asymmetric registered
[    3.512677] Asymmetric key parser 'x509' registered
[    3.514746] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    3.517820] io scheduler noop registered
[    3.519464] io scheduler deadline registered (default)
[    3.531547] test_firmware: interface ready
[    3.533826] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    3.535878] crc32: self tests passed, processed 225944 bytes in 227681 n=
sec
[    3.558659] crc32c: CRC_LE_BITS =3D 64
[    3.560455] crc32c: self tests passed, processed 225944 bytes in 134188 =
nsec
[    3.624888] crc32_combine: 8373 self tests passed
[    3.712355] crc32c_combine: 8373 self tests passed
[    3.714664] ipmi message handler version 39.2
[    3.765197] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.877137] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    3.880810] serial: Freescale lpuart driver
[    3.882554] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    3.884414] Linux agpgart interface v0.103
[    3.886171] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    3.909499] Uniform Multi-Platform E-IDE driver
[    3.912095] ide-gd driver 1.18
[    3.913893] SSFDC read-only Flash Translation layer
[    3.933736] platform physmap-flash.0: failed to claim resource 0
[    3.935914] slram: not enough parameters.
[    3.950298] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel =
Networks.
[    3.953505] pmc551: not detected
[    3.955208] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    3.983954] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.985844] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.999412] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    4.000245] mk712: device not present
[    4.000309] ideapad_slidebar: DMI does not match
[    4.000312] IR RC6 protocol handler initialized
[    4.000382] pps pps0: new PPS source ktimer
[    4.000385] pps pps0: ktimer PPS source registered
[    4.000389] pps_ldisc: PPS line discipline registered
[    4.000391] Driver for 1-wire Dallas network protocol.
[    4.000439] 1-Wire driver for the DS2760 battery monitor chip - (c) 2004=
-2005, Szabolcs Gyurko
[    4.000499] power_supply test_ac: uevent
[    4.000501] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    4.000508] power_supply test_ac: prop ONLINE=3D1
[    4.000514] power_supply test_ac: power_supply_changed
[    4.000523] power_supply test_ac: power_supply_changed_work
[    4.000529] power_supply test_ac: uevent
[    4.000531] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[    4.000536] power_supply test_ac: prop ONLINE=3D1
[    4.000596] power_supply test_battery: uevent
[    4.000598] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    4.000603] power_supply test_battery: prop STATUS=3DDischarging
[    4.000607] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    4.000610] power_supply test_battery: prop HEALTH=3DGood
[    4.000613] power_supply test_battery: prop PRESENT=3D1
[    4.000616] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    4.000619] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    4.000622] power_supply test_battery: prop CHARGE_FULL=3D100
[    4.000625] power_supply test_battery: prop CHARGE_NOW=3D50
[    4.000628] power_supply test_battery: prop CAPACITY=3D50
[    4.000632] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    4.000635] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    4.000638] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    4.000641] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    4.000645] power_supply test_battery: prop MANUFACTURER=3DLinux
[    4.000648] power_supply test_battery: prop SERIAL_NUMBER=3D3.17.0-rc7-0=
0004-gb8a868e
[    4.000651] power_supply test_battery: prop TEMP=3D26
[    4.000654] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    4.000685] power_supply test_battery: power_supply_changed
[    4.000691] power_supply test_battery: power_supply_changed_work
[    4.000696] power_supply test_battery: uevent
[    4.000698] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[    4.000703] power_supply test_battery: prop STATUS=3DDischarging
[    4.000706] power_supply test_battery: prop CHARGE_TYPE=3DFast
[    4.000709] power_supply test_battery: prop HEALTH=3DGood
[    4.000712] power_supply test_battery: prop PRESENT=3D1
[    4.000715] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[    4.000718] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[    4.000721] power_supply test_battery: prop CHARGE_FULL=3D100
[    4.000723] power_supply test_battery: prop CHARGE_NOW=3D50
[    4.000726] power_supply test_battery: prop CAPACITY=3D50
[    4.000729] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[    4.000732] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[    4.000735] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[    4.000738] power_supply test_battery: prop MODEL_NAME=3DTest battery
[    4.000741] power_supply test_battery: prop MANUFACTURER=3DLinux
[    4.000745] power_supply test_battery: prop SERIAL_NUMBER=3D3.17.0-rc7-0=
0004-gb8a868e
[    4.000748] power_supply test_battery: prop TEMP=3D26
[    4.000751] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[    4.000787] power_supply test_usb: uevent
[    4.000789] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    4.000794] power_supply test_usb: prop ONLINE=3D1
[    4.000797] power_supply test_usb: power_supply_changed
[    4.000804] power_supply test_usb: power_supply_changed_work
[    4.000809] power_supply test_usb: uevent
[    4.000811] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[    4.000815] power_supply test_usb: prop ONLINE=3D1
[    4.000835] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[    4.000843] vme_user: VME User Space Access Driver
[    4.000844] vme_user: No cards, skipping registration
[    4.000926] input: Speakup as /devices/virtual/input/input1
[    4.001064] initialized device: /dev/synth, node (MAJOR 10, MINOR 25)
[    4.001090] speakup 3.1.6: initialized
[    4.001091] synth name on entry is: (null)
[    4.001100] dgap-1.3-16, Digi International Part Number 40002347_C
[    4.001101] For the tools package please visit http://www.digi.com
[    4.001659] ASIHPI driver 4.10.01
[    4.002755]=20
[    4.002755] printing PIC contents
[    4.002765] ... PIC  IMR: ffff
[    4.002771] ... PIC  IRR: 1013
[    4.002784] ... PIC  ISR: 0000
[    4.002790] ... PIC ELCR: 0c00
[    4.002796] printing local APIC contents on CPU#0/0:
[    4.002803] ... APIC ID:      00000000 (0)
[    4.002807] ... APIC VERSION: 01050014
[    4.002811] ... APIC TASKPRI: 00000000 (00)
[    4.002815] ... APIC PROCPRI: 00000000
[    4.002819] ... APIC LDR: 01000000
[    4.002823] ... APIC DFR: ffffffff
[    4.002827] ... APIC SPIV: 000001ff
[    4.002828] ... APIC ISR field:
[    4.002855] 000000000000000000000000000000000000000000000000000000000000=
0000
[    4.002855] ... APIC TMR field:
[    4.002882] 000000000e20000000000000000000000000000000000000000000000000=
0000
[    4.002883] ... APIC IRR field:
[    4.002909] 000000000000000000000000000000000000000000000000000000000000=
0000
[    4.002916] ... APIC ESR: 00000000
[    4.002923] ... APIC ICR: 000008fd
[    4.002924] ... APIC ICR2: 02000000
[    4.002928] ... APIC LVTT: 000000ef
[    4.002931] ... APIC LVTPC: 00010000
[    4.002935] ... APIC LVT0: 00010700
[    4.002939] ... APIC LVT1: 00000400
[    4.002943] ... APIC LVTERR: 000000fe
[    4.002946] ... APIC TMICT: 00098356
[    4.002950] ... APIC TMCCT: 0006ba6a
[    4.002954] ... APIC TDCR: 00000003
[    4.002954]=20
[    4.002956] number of MP IRQ sources: 15.
[    4.002957] number of IO-APIC #0 registers: 24.
[    4.002958] testing the IO APIC.......................
[    4.002978] IO APIC #0......
[    4.002979] .... register #00: 00000000
[    4.002979] .......    : physical APIC id: 00
[    4.002980] .......    : Delivery Type: 0
[    4.002981] .......    : LTS          : 0
[    4.002982] .... register #01: 00170011
[    4.002982] .......     : max redirection entries: 17
[    4.002983] .......     : PRQ implemented: 0
[    4.002984] .......     : IO APIC version: 11
[    4.002984] .... register #02: 00000000
[    4.002985] .......     : arbitration: 00
[    4.002986] .... IRQ redirection table:
[    4.003000] 1    0    0   0   0    0    0    00
[    4.003014] 0    0    0   0   0    1    1    31
[    4.003028] 0    0    0   0   0    1    1    30
[    4.003042] 0    0    0   0   0    1    1    33
[    4.003057] 1    0    0   0   0    1    1    34
[    4.003071] 1    1    0   0   0    1    1    35
[    4.003085] 0    0    0   0   0    1    1    36
[    4.003100] 0    0    0   0   0    1    1    37
[    4.003113] 0    0    0   0   0    1    1    38
[    4.003127] 0    1    0   0   0    1    1    39
[    4.003141] 1    1    0   0   0    1    1    3A
[    4.003156] 1    1    0   0   0    1    1    3B
[    4.003169] 0    0    0   0   0    1    1    3C
[    4.003183] 0    0    0   0   0    1    1    3D
[    4.003197] 0    0    0   0   0    1    1    3E
[    4.003211] 0    0    0   0   0    1    1    3F
[    4.003225] 1    0    0   0   0    0    0    00
[    4.003239] 1    0    0   0   0    0    0    00
[    4.003253] 1    0    0   0   0    0    0    00
[    4.003266] 1    0    0   0   0    0    0    00
[    4.003280] 1    0    0   0   0    0    0    00
[    4.003294] 1    0    0   0   0    0    0    00
[    4.003308] 1    0    0   0   0    0    0    00
[    4.003322] 1    0    0   0   0    0    0    00
[    4.003323] IRQ to pin mappings:
[    4.003325] IRQ0 -> 0:2
[    4.003326] IRQ1 -> 0:1
[    4.003328] IRQ3 -> 0:3
[    4.003330] IRQ4 -> 0:4
[    4.003332] IRQ5 -> 0:5
[    4.003334] IRQ6 -> 0:6
[    4.003335] IRQ7 -> 0:7
[    4.003337] IRQ8 -> 0:8
[    4.003339] IRQ9 -> 0:9
[    4.003341] IRQ10 -> 0:10
[    4.003342] IRQ11 -> 0:11
[    4.003344] IRQ12 -> 0:12
[    4.003346] IRQ13 -> 0:13
[    4.003347] IRQ14 -> 0:14
[    4.003349] IRQ15 -> 0:15
[    4.003350] .................................... done.
[    4.003482] Loading compiled-in X.509 certificates
[    4.005031] Loaded X.509 cert 'Magrathea: Glacier signing key: 4b3b25eb1=
aa6e7d9a60ab125d6345c2dbfe76e63'
[    4.005256] Key type encrypted registered
[    4.005821] ALSA device list:
[    4.005822]   No soundcards found.
[    5.004531] tsc: Refined TSC clocksource calibration: 2260.996 MHz
[    5.007751] Freeing unused kernel memory: 832K (ffffffff81a9c000 - fffff=
fff81b6c000)
[    5.007753] Write protecting the kernel read-only data: 10240k
[    5.087621] Freeing unused kernel memory: 1248K (ffff8800014c8000 - ffff=
880001600000)
[    5.136856] Freeing unused kernel memory: 1936K (ffff88000181c000 - ffff=
880001a00000)
[    5.167951] random: init urandom read with 5 bits of entropy available
[   19.307116] PANIC: double fault, error_code: 0xffffffffffffffff
[   19.309941] Kernel panic - not syncing: Machine halted.
[   19.310083] CPU: 1 PID: 150 Comm: trinity-main Not tainted 3.17.0-rc7-00=
004-gb8a868e #130
[   19.310083] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.7.5-20140531_083030-gandalf 04/01/2014
[   19.310083]  0000000000000000 ffff880012707e88 ffffffff814befff ffffffff=
8174c441
[   19.310083]  ffff880012707f08 ffffffff814bcd7d 0000000000000008 ffff8800=
12707f18
[   19.310083]  ffff880012707eb0 ffffffff81ba8d00 0000000000000046 ffff8800=
10c7ffd8
[   19.310083] Call Trace:
[   19.310083]  <#DF>  [<ffffffff814befff>] dump_stack+0x4d/0x66
[   19.310083]  [<ffffffff814bcd7d>] panic+0xc4/0x1d6
[   19.310083]  [<ffffffff8102a96c>] df_debug+0x2c/0x2c
[   19.310083]  [<ffffffff81002df9>] do_double_fault+0x62/0x7d
[   19.310083]  [<ffffffff814c5d8e>] double_fault+0x2e/0x40
[   19.310083]  [<ffffffff814c610d>] ? async_page_fault+0xd/0x30
[   19.310083]  <<EOE>>  <UNK>=20
[   19.310083] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range=
: 0xffffffff80000000-0xffffffff9fffffff)

Elapsed time: 30
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-hxb1-1004/b8a868e9ea876a1b40020397305533c095921d7a/vmlinuz-3.17.0-rc7-0000=
4-gb8a868e -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug ap=
ic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=
=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=
=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal =
 root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-h=
xb1-1004/linux-devel:devel-lkp-hsx02-x86_64-201410040643:b8a868e9ea876a1b40=
020397305533c095921d7a:bisect-linux-2/.vmlinuz-b8a868e9ea876a1b400203973055=
33c095921d7a-20141004081702-171-lkp-nex04 branch=3Dlinux-devel/devel-lkp-hs=
x02-x86_64-201410040643 BOOT_IMAGE=3D/kernel/x86_64-randconfig-hxb1-1004/b8=
a868e9ea876a1b40020397305533c095921d7a/vmlinuz-3.17.0-rc7-00004-gb8a868e dr=
bd.minor_count=3D8'  -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz -=
m 320 -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=
=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm=
/kboot/pid-quantal-lkp-nex04-6 -serial file:/dev/shm/kboot/serial-quantal-l=
kp-nex04-6 -daemonize -display none -monitor null=20

--WhfpMioaduB5tiZL
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-hxb1-1004-80489752332f4e4f75343d6b539095b366013bc6-PANIC:-double-116710.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgODA0ODk3NS4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1s
a3AtaHN4MDIteDg2XzY0LTIwMTQxMDA0MDY0MycKZ2l0IGNoZWNrb3V0IGZlODJkY2VjNjQ0
MjQ0Njc2ZDU1YTEzODRjOTU4ZDVmNjc5NzlhZGIKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4t
cXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWh4YjEtMTAwNC9saW51eC1kZXZlbDpkZXZl
bC1sa3AtaHN4MDIteDg2XzY0LTIwMTQxMDA0MDY0MzpmZTgyZGNlYzY0NDI0NDY3NmQ1NWEx
Mzg0Yzk1OGQ1ZjY3OTc5YWRiOmJpc2VjdC1saW51eC0yCgoyMDE0LTEwLTA0IDA3OjA5OjIy
IGZlODJkY2VjNjQ0MjQ0Njc2ZDU1YTEzODRjOTU4ZDVmNjc5NzlhZGIgY29tcGlsaW5nClF1
ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAy
L3g4Nl82NC1yYW5kY29uZmlnLWh4YjEtMTAwNC1mZTgyZGNlYzY0NDI0NDY3NmQ1NWExMzg0
Yzk1OGQ1ZjY3OTc5YWRiCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1oeGIxLTEwMDQvZmU4MmRjZWM2NDQyNDQ2NzZkNTVhMTM4NGM5NThkNWY2Nzk3
OWFkYgprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHhiMS0xMDA0L2ZlODJk
Y2VjNjQ0MjQ0Njc2ZDU1YTEzODRjOTU4ZDVmNjc5NzlhZGIvdm1saW51ei0zLjE3LjAtcmM3
CgoyMDE0LTEwLTA0IDA3OjEwOjIyIGRldGVjdGluZyBib290IHN0YXRlIAkxCTcJODIJMTE2
CTE5NQkyMzIJMjg3CTMwMCBTVUNDRVNTCgpiaXNlY3Q6IGdvb2QgY29tbWl0IGZlODJkY2Vj
NjQ0MjQ0Njc2ZDU1YTEzODRjOTU4ZDVmNjc5NzlhZGIKZ2l0IGJpc2VjdCBzdGFydCA4MDQ4
OTc1MjMzMmY0ZTRmNzUzNDNkNmI1MzkwOTViMzY2MDEzYmM2IGZlODJkY2VjNjQ0MjQ0Njc2
ZDU1YTEzODRjOTU4ZDVmNjc5NzlhZGIgLS0KL2Mva2VybmVsLXRlc3RzL2xpbmVhci1iaXNl
Y3Q6IFsiLWIiLCAiODA0ODk3NTIzMzJmNGU0Zjc1MzQzZDZiNTM5MDk1YjM2NjAxM2JjNiIs
ICItZyIsICJmZTgyZGNlYzY0NDI0NDY3NmQ1NWExMzg0Yzk1OGQ1ZjY3OTc5YWRiIiwgIi9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2giLCAiL2MvYm9vdC1i
aXNlY3QvbGludXgtMi9vYmotYmlzZWN0Il0KQmlzZWN0aW5nOiAxMTYgcmV2aXNpb25zIGxl
ZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDcgc3RlcHMpClswZTNlMmQ3YTYwODU4
N2EwMWFhYTllYWFiZDdmNzVjYWQ1NmNiOGVhXSBNZXJnZSAnYWsveDg2L2ZzZ3MtMicgaW50
byBkZXZlbC1sa3AtaHN4MDIteDg2XzY0LTIwMTQxMDA0MDY0MwpydW5uaW5nIC9jL2tlcm5l
bC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGlu
dXgtMi9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZf
NjQtcmFuZGNvbmZpZy1oeGIxLTEwMDQvbGludXgtZGV2ZWw6ZGV2ZWwtbGtwLWhzeDAyLXg4
Nl82NC0yMDE0MTAwNDA2NDM6MGUzZTJkN2E2MDg1ODdhMDFhYWE5ZWFhYmQ3Zjc1Y2FkNTZj
YjhlYTpiaXNlY3QtbGludXgtMgoKMjAxNC0xMC0wNCAwNzoxNDo0NCAwZTNlMmQ3YTYwODU4
N2EwMWFhYTllYWFiZDdmNzVjYWQ1NmNiOGVhIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFz
ayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMi94ODZfNjQtcmFuZGNv
bmZpZy1oeGIxLTEwMDQtMGUzZTJkN2E2MDg1ODdhMDFhYWE5ZWFhYmQ3Zjc1Y2FkNTZjYjhl
YQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHhiMS0x
MDA0LzBlM2UyZDdhNjA4NTg3YTAxYWFhOWVhYWJkN2Y3NWNhZDU2Y2I4ZWEKd2FpdGluZyBm
b3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMi94
ODZfNjQtcmFuZGNvbmZpZy1oeGIxLTEwMDQtMGUzZTJkN2E2MDg1ODdhMDFhYWE5ZWFhYmQ3
Zjc1Y2FkNTZjYjhlYQobWzE7MzVtMjAxNC0xMC0wNCAwNzoxNjo0NCBObyBidWlsZCBzZXJ2
ZWQgZmlsZSAva2J1aWxkLXRlc3RzL2J1aWxkLXNlcnZlZC94ODZfNjQtcmFuZGNvbmZpZy1o
eGIxLTEwMDQtMGUzZTJkN2E2MDg1ODdhMDFhYWE5ZWFhYmQ3Zjc1Y2FkNTZjYjhlYRtbMG0K
UmV0cnkgYnVpbGQgLi4Ka2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWh4YjEt
MTAwNC8wZTNlMmQ3YTYwODU4N2EwMWFhYTllYWFiZDdmNzVjYWQ1NmNiOGVhL3ZtbGludXot
My4xNy4wLXJjNy0wMDAwOS1nMGUzZTJkNwoKMjAxNC0xMC0wNCAwNzoxNzo0NCBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAuCTE5IFRFU1QgRkFJTFVSRQpbICAgIDEuMTAyNDM3XSBGcmVlaW5n
IHVudXNlZCBrZXJuZWwgbWVtb3J5OiAxMjQ4SyAoZmZmZjg4MDAwMTRjODAwMCAtIGZmZmY4
ODAwMDE2MDAwMDApClsgICAgMS4xMTEyOTRdIEZyZWVpbmcgdW51c2VkIGtlcm5lbCBtZW1v
cnk6IDE5MzZLIChmZmZmODgwMDAxODFjMDAwIC0gZmZmZjg4MDAwMWEwMDAwMCkKWyAgICAx
LjExNzg2Nl0gcmFuZG9tOiBpbml0IHVyYW5kb20gcmVhZCB3aXRoIDMgYml0cyBvZiBlbnRy
b3B5IGF2YWlsYWJsZQpbICAgMTIuMDAyMzA0XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2Vy
bmVsIApFbGFwc2VkIHRpbWU6IDE1CnFlbXUtc3lzdGVtLXg4Nl82NCAtY3B1IGt2bTY0IC1l
bmFibGUta3ZtIC1rZXJuZWwgL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oeGIxLTEwMDQv
MGUzZTJkN2E2MDg1ODdhMDFhYWE5ZWFhYmQ3Zjc1Y2FkNTZjYjhlYS92bWxpbnV6LTMuMTcu
MC1yYzctMDAwMDktZzBlM2UyZDcgLWFwcGVuZCAnaHVuZ190YXNrX3BhbmljPTEgZWFybHlw
cmludGs9dHR5UzAsMTE1MjAwIGRlYnVnIGFwaWM9ZGVidWcgc3lzcnFfYWx3YXlzX2VuYWJs
ZWQgcmN1cGRhdGUucmN1X2NwdV9zdGFsbF90aW1lb3V0PTEwMCBwYW5pYz0tMSBzb2Z0bG9j
a3VwX3BhbmljPTEgbm1pX3dhdGNoZG9nPXBhbmljIG9vcHM9cGFuaWMgbG9hZF9yYW1kaXNr
PTIgcHJvbXB0X3JhbWRpc2s9MCBjb25zb2xlPXR0eVMwLDExNTIwMCBjb25zb2xlPXR0eTAg
dmdhPW5vcm1hbCAgcm9vdD0vZGV2L3JhbTAgcncgbGluaz0va2J1aWxkLXRlc3RzL3J1bi1x
dWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaHhiMS0xMDA0L2xpbnV4LWRldmVsOmRldmVs
LWxrcC1oc3gwMi14ODZfNjQtMjAxNDEwMDQwNjQzOjBlM2UyZDdhNjA4NTg3YTAxYWFhOWVh
YWJkN2Y3NWNhZDU2Y2I4ZWE6YmlzZWN0LWxpbnV4LTIvLnZtbGludXotMGUzZTJkN2E2MDg1
ODdhMDFhYWE5ZWFhYmQ3Zjc1Y2FkNTZjYjhlYS0yMDE0MTAwNDA3MTcxNy0yMjktaXZiNDEg
YnJhbmNoPWxpbnV4LWRldmVsL2RldmVsLWxrcC1oc3gwMi14ODZfNjQtMjAxNDEwMDQwNjQz
IEJPT1RfSU1BR0U9L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oeGIxLTEwMDQvMGUzZTJk
N2E2MDg1ODdhMDFhYWE5ZWFhYmQ3Zjc1Y2FkNTZjYjhlYS92bWxpbnV6LTMuMTcuMC1yYzct
MDAwMDktZzBlM2UyZDcgZHJiZC5taW5vcl9jb3VudD04JyAgLWluaXRyZCAva2VybmVsLXRl
c3RzL2luaXRyZC9xdWFudGFsLWNvcmUteDg2XzY0LmNneiAtbSAzMjAgLXNtcCAyIC1uZXQg
bmljLHZsYW49MSxtb2RlbD1lMTAwMCAtbmV0IHVzZXIsdmxhbj0xIC1ib290IG9yZGVyPW5j
IC1uby1yZWJvb3QgLXdhdGNoZG9nIGk2MzAwZXNiIC1ydGMgYmFzZT1sb2NhbHRpbWUgLXBp
ZGZpbGUgL2Rldi9zaG0va2Jvb3QvcGlkLXF1YW50YWwtaXZiNDEtMTI0IC1zZXJpYWwgZmls
ZTovZGV2L3NobS9rYm9vdC9zZXJpYWwtcXVhbnRhbC1pdmI0MS0xMjQgLWRhZW1vbml6ZSAt
ZGlzcGxheSBub25lIC1tb25pdG9yIG51bGwgCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
aHhiMS0xMDA0LzBlM2UyZDdhNjA4NTg3YTAxYWFhOWVhYWJkN2Y3NWNhZDU2Y2I4ZWEvZG1l
c2ctcXVhbnRhbC1pdmI0MS01MjoyMDE0MTAwNDA3MTgxODp4ODZfNjQtcmFuZGNvbmZpZy1o
eGIxLTEwMDQ6OgoyNDoxOjYgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIw
MTQtMTAtMDQgMDc6MTg6NDQgUkVQRUFUIENPVU5UOiAzMDAgICMgL2MvYm9vdC1iaXNlY3Qv
bGludXgtMi9vYmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDkgcmV2aXNpb25z
IGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDQgc3RlcHMpCls2MzAwN2JlYmU4
NTFiMzA0ZDZlMmQ2NmZkMDgzMDdhNGZkMzVjYzUwXSAwZGF5IGJhc2UgZ3VhcmQgZm9yICdk
ZXZlbC1sa3AtaHN4MDIteDg2XzY0LTIwMTQxMDA0MDY0MycKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4
LTIvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LXJhbmRjb25maWctaHhiMS0xMDA0L2xpbnV4LWRldmVsOmRldmVsLWxrcC1oc3gwMi14ODZf
NjQtMjAxNDEwMDQwNjQzOjYzMDA3YmViZTg1MWIzMDRkNmUyZDY2ZmQwODMwN2E0ZmQzNWNj
NTA6YmlzZWN0LWxpbnV4LTIKCjIwMTQtMTAtMDQgMDc6MTg6NDUgNjMwMDdiZWJlODUxYjMw
NGQ2ZTJkNjZmZDA4MzA3YTRmZDM1Y2M1MCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sg
dG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDIveDg2XzY0LXJhbmRjb25m
aWctaHhiMS0xMDA0LTYzMDA3YmViZTg1MWIzMDRkNmUyZDY2ZmQwODMwN2E0ZmQzNWNjNTAK
Q2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWh4YjEtMTAw
NC82MzAwN2JlYmU4NTFiMzA0ZDZlMmQ2NmZkMDgzMDdhNGZkMzVjYzUwCndhaXRpbmcgZm9y
IGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDIveDg2
XzY0LXJhbmRjb25maWctaHhiMS0xMDA0LTYzMDA3YmViZTg1MWIzMDRkNmUyZDY2ZmQwODMw
N2E0ZmQzNWNjNTAKG1sxOzM1bTIwMTQtMTAtMDQgMDc6MjA6NDUgTm8gYnVpbGQgc2VydmVk
IGZpbGUgL2tidWlsZC10ZXN0cy9idWlsZC1zZXJ2ZWQveDg2XzY0LXJhbmRjb25maWctaHhi
MS0xMDA0LTYzMDA3YmViZTg1MWIzMDRkNmUyZDY2ZmQwODMwN2E0ZmQzNWNjNTAbWzBtClJl
dHJ5IGJ1aWxkIC4uCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oeGIxLTEw
MDQvNjMwMDdiZWJlODUxYjMwNGQ2ZTJkNjZmZDA4MzA3YTRmZDM1Y2M1MC92bWxpbnV6LTMu
MTcuMC1yYzctMDAwMDEtZzYzMDA3YmUKCjIwMTQtMTAtMDQgMDc6MjE6NDUgZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgLgkzCTIxCTM3CTYxLgk4NQk5Ni4JMTI2CTEzNgkxMzcJMTQ3LgkxNDgu
LgkxNTAJMTUxCTE1OS4JMTYxLgkxNzMuCTE3NwkxODAuCTE5OC4JMjAwCTIwMgkyMDgJMjA5
LgkyMTAuCTIxNQkyMTcuCTIxOS4JMjIwCTIyMi4JMjI1Li4JMjI2LgkyMjcuCTIyOC4uCTIy
OS4JMjMwLi4uLi4uCTIzMS4uLgkyMzIuLgkyMzUuCTIzNi4JMjM3CTIzOQkyNDAJMjQyCTI0
My4uLgkyNDQuLi4JMjQ2Li4uLi4JMjY0CTI4NAkzMDAgU1VDQ0VTUwoKbGluZWFyLWJpc2Vj
dDogYmFkIGJyYW5jaCBtYXkgYmUgYWsveDg2L2ZzZ3MtMgpsaW5lYXItYmlzZWN0OiBoYW5k
bGUgb3ZlciB0byBnaXQgYmlzZWN0CmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3Qgc3RhcnQg
MGUzZTJkN2E2MDg1ODdhMDFhYWE5ZWFhYmQ3Zjc1Y2FkNTZjYjhlYSA2MzAwN2JlYmU4NTFi
MzA0ZDZlMmQ2NmZkMDgzMDdhNGZkMzVjYzUwIC0tClByZXZpb3VzIEhFQUQgcG9zaXRpb24g
d2FzIDYzMDA3YmUuLi4gMGRheSBiYXNlIGd1YXJkIGZvciAnZGV2ZWwtbGtwLWhzeDAyLXg4
Nl82NC0yMDE0MTAwNDA2NDMnCkhFQUQgaXMgbm93IGF0IDNmM2EwMTkuLi4gTWVyZ2UgYnJh
bmNoICdha3BtL21hc3RlcicKQmlzZWN0aW5nOiAzIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3Qg
YWZ0ZXIgdGhpcyAocm91Z2hseSAyIHN0ZXBzKQpbYjhhODY4ZTllYTg3NmExYjQwMDIwMzk3
MzA1NTMzYzA5NTkyMWQ3YV0geDg2OiBBZGQgc3VwcG9ydCBmb3IgcmQvd3IgZnMvZ3MgYmFz
ZQpsaW5lYXItYmlzZWN0OiBnaXQgYmlzZWN0IHJ1biAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTIvb2JqLWJpc2Vj
dApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2MvYm9vdC1iaXNlY3QvbGludXgtMi9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMv
cnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oeGIxLTEwMDQvbGludXgtZGV2ZWw6
ZGV2ZWwtbGtwLWhzeDAyLXg4Nl82NC0yMDE0MTAwNDA2NDM6YjhhODY4ZTllYTg3NmExYjQw
MDIwMzk3MzA1NTMzYzA5NTkyMWQ3YTpiaXNlY3QtbGludXgtMgoKMjAxNC0xMC0wNCAwODox
MDowNiBiOGE4NjhlOWVhODc2YTFiNDAwMjAzOTczMDU1MzNjMDk1OTIxZDdhIGNvbXBpbGlu
ZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1o
c3gwMi94ODZfNjQtcmFuZGNvbmZpZy1oeGIxLTEwMDQtYjhhODY4ZTllYTg3NmExYjQwMDIw
Mzk3MzA1NTMzYzA5NTkyMWQ3YQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctaHhiMS0xMDA0L2I4YTg2OGU5ZWE4NzZhMWI0MDAyMDM5NzMwNTUzM2Mw
OTU5MjFkN2EKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL2xrcC1oc3gwMi94ODZfNjQtcmFuZGNvbmZpZy1oeGIxLTEwMDQtYjhhODY4ZTll
YTg3NmExYjQwMDIwMzk3MzA1NTMzYzA5NTkyMWQ3YQprZXJuZWw6IC9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctaHhiMS0xMDA0L2I4YTg2OGU5ZWE4NzZhMWI0MDAyMDM5NzMwNTUzM2Mw
OTU5MjFkN2Evdm1saW51ei0zLjE3LjAtcmM3LTAwMDA0LWdiOGE4NjhlCgoyMDE0LTEwLTA0
IDA4OjE3OjA2IGRldGVjdGluZyBib290IHN0YXRlIC4uCTc4IFRFU1QgRkFJTFVSRQpbICAg
IDUuNzMzMzMwXSBGcmVlaW5nIHVudXNlZCBrZXJuZWwgbWVtb3J5OiAxMjQ4SyAoZmZmZjg4
MDAwMTRjODAwMCAtIGZmZmY4ODAwMDE2MDAwMDApClsgICAgNS43NjAzNTVdIEZyZWVpbmcg
dW51c2VkIGtlcm5lbCBtZW1vcnk6IDE5MzZLIChmZmZmODgwMDAxODFjMDAwIC0gZmZmZjg4
MDAwMWEwMDAwMCkKWyAgICA1LjgwNTU3MV0gcmFuZG9tOiBpbml0IHVyYW5kb20gcmVhZCB3
aXRoIDUgYml0cyBvZiBlbnRyb3B5IGF2YWlsYWJsZQpbICAgMTkuNTY1NDM1XSBQQU5JQzog
ZG91YmxlIGZhdWx0LCBlcnJvcl9jb2RlOiAweGZmZmZmZmZmZmZmZmZmZmYKWyAgIDE5LjU2
OTIwM10gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IE1hY2hpbmUgaGFsdGVkLgpbICAg
MTkuNTcwMDY3XSBDUFU6IDEgUElEOiAxNTAgQ29tbTogdHJpbml0eS1tYWluIE5vdCB0YWlu
dGVkIDMuMTcuMC1yYzctMDAwMDQtZ2I4YTg2OGUgIzEzMApbICAgMTkuNTgwMDY1XSBIYXJk
d2FyZSBuYW1lOiBRRU1VIFN0YW5kYXJkIFBDIChpNDQwRlggKyBQSUlYLCAxOTk2KSwgQklP
UyAxLjcuNS0yMDE0MDUzMV8wODMwMzAtZ2FuZGFsZiAwNC8wMS8yMDE0ClsgICAxOS41ODAw
NjVdICAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMTI3MDdlODggZmZmZmZmZmY4MTRiZWZm
ZiBmZmZmZmZmZjgxNzRjNDQxClsgICAxOS41ODAwNjVdICBmZmZmODgwMDEyNzA3ZjA4IGZm
ZmZmZmZmODE0YmNkN2QgMDAwMDAwMDAwMDAwMDAwOCBmZmZmODgwMDEyNzA3ZjE4ClsgICAx
OS41ODAwNjVdICBmZmZmODgwMDEyNzA3ZWIwIGZmZmZmZmZmODFiYThkMDAgMDAwMDAwMDAw
MDAwMDA0NiBmZmZmODgwMDEzOThiZmQ4ClsgICAxOS41ODAwNjVdIENhbGwgVHJhY2U6Clsg
ICAxOS41ODAwNjVdICA8I0RGPiAgWzxmZmZmZmZmZjgxNGJlZmZmPl0gZHVtcF9zdGFjaysw
eDRkLzB4NjYKWyAgIDE5LjU4MDA2NV0gIFs8ZmZmZmZmZmY4MTRiY2Q3ZD5dIHBhbmljKzB4
YzQvMHgxZDYKWyAgIDE5LjU4MDA2NV0gIFs8ZmZmZmZmZmY4MTAyYTk2Yz5dIGRmX2RlYnVn
KzB4MmMvMHgyYwpbICAgMTkuNTgwMDY1XSAgWzxmZmZmZmZmZjgxMDAyZGY5Pl0gZG9fZG91
YmxlX2ZhdWx0KzB4NjIvMHg3ZApbICAgMTkuNTgwMDY1XSAgWzxmZmZmZmZmZjgxNGM1ZDhl
Pl0gZG91YmxlX2ZhdWx0KzB4MmUvMHg0MApbICAgMTkuNTgwMDY1XSAgWzxmZmZmZmZmZjgx
NGM2MTBkPl0gPyBhc3luY19wYWdlX2ZhdWx0KzB4ZC8weDMwClsgICAxOS41ODAwNjVdICA8
PEVPRT4+ICA8VU5LPiAKWyAgIDE5LjU4MDA2NV0gS2VybmVsIE9mZnNldDogMHgwIGZyb20g
MHhmZmZmZmZmZjgxMDAwMDAwIChyZWxvY2F0aW9uIHJhbmdlOiAweGZmZmZmZmZmODAwMDAw
MDAtMHhmZmZmZmZmZjlmZmZmZmZmKQoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oeGIx
LTEwMDQvYjhhODY4ZTllYTg3NmExYjQwMDIwMzk3MzA1NTMzYzA5NTkyMWQ3YS9kbWVzZy1x
dWFudGFsLWxrcC1uZXgwNC0xNjc6MjAxNDEwMDQwODE4MDE6eDg2XzY0LXJhbmRjb25maWct
aHhiMS0xMDA0OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oeGIxLTEwMDQvYjhhODY4
ZTllYTg3NmExYjQwMDIwMzk3MzA1NTMzYzA5NTkyMWQ3YS9kbWVzZy1xdWFudGFsLWxrcC1u
ZXgwNC0xNzc6MjAxNDEwMDQwODE4MDE6eDg2XzY0LXJhbmRjb25maWctaHhiMS0xMDA0OjoK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oeGIxLTEwMDQvYjhhODY4ZTllYTg3NmExYjQw
MDIwMzk3MzA1NTMzYzA5NTkyMWQ3YS9kbWVzZy1xdWFudGFsLWxrcC1uZXgwNC02OjIwMTQx
MDA0MDgxNzU1Ong4Nl82NC1yYW5kY29uZmlnLWh4YjEtMTAwNDo6Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctaHhiMS0xMDA0L2I4YTg2OGU5ZWE4NzZhMWI0MDAyMDM5NzMwNTUzM2Mw
OTU5MjFkN2EvZG1lc2ctcXVhbnRhbC1sa3AtbmV4MDQtMTY0OjIwMTQxMDA0MDgxODA2Ong4
Nl82NC1yYW5kY29uZmlnLWh4YjEtMTAwNDo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
aHhiMS0xMDA0L2I4YTg2OGU5ZWE4NzZhMWI0MDAyMDM5NzMwNTUzM2MwOTU5MjFkN2EvZG1l
c2ctcXVhbnRhbC1sa3AtbmV4MDQtMTY2OjIwMTQxMDA0MDgxODA1Ong4Nl82NC1yYW5kY29u
ZmlnLWh4YjEtMTAwNDo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHhiMS0xMDA0L2I4
YTg2OGU5ZWE4NzZhMWI0MDAyMDM5NzMwNTUzM2MwOTU5MjFkN2EvZG1lc2ctcXVhbnRhbC1s
a3AtbmV4MDQtMTA4OjIwMTQxMDA0MDgxODA5Ong4Nl82NC1yYW5kY29uZmlnLWh4YjEtMTAw
NDo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHhiMS0xMDA0L2I4YTg2OGU5ZWE4NzZh
MWI0MDAyMDM5NzMwNTUzM2MwOTU5MjFkN2EvZG1lc2ctcXVhbnRhbC1sa3AtbmV4MDQtMTg6
MjAxNDEwMDQwODE4MDg6eDg2XzY0LXJhbmRjb25maWctaHhiMS0xMDA0OjoKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1oeGIxLTEwMDQvYjhhODY4ZTllYTg3NmExYjQwMDIwMzk3MzA1
NTMzYzA5NTkyMWQ3YS9kbWVzZy1xdWFudGFsLWxrcC1uZXgwNC0yOToyMDE0MTAwNDA4MTgw
ODp4ODZfNjQtcmFuZGNvbmZpZy1oeGIxLTEwMDQ6Ogova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLWh4YjEtMTAwNC9iOGE4NjhlOWVhODc2YTFiNDAwMjAzOTczMDU1MzNjMDk1OTIxZDdh
L2RtZXNnLXF1YW50YWwtbGtwLW5leDA0LTcxOjIwMTQxMDA0MDgxODE4Ong4Nl82NC1yYW5k
Y29uZmlnLWh4YjEtMTAwNDo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHhiMS0xMDA0
L2I4YTg2OGU5ZWE4NzZhMWI0MDAyMDM5NzMwNTUzM2MwOTU5MjFkN2EvZG1lc2ctcXVhbnRh
bC1sa3AtbmV4MDQtMTI0OjIwMTQxMDA0MDgxODMxOng4Nl82NC1yYW5kY29uZmlnLWh4YjEt
MTAwNDo6Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHhiMS0xMDA0L2I4YTg2OGU5ZWE4
NzZhMWI0MDAyMDM5NzMwNTUzM2MwOTU5MjFkN2EvZG1lc2ctcXVhbnRhbC1sa3AtbmV4MDQt
NTg6MjAxNDEwMDQwODE4Mjg6eDg2XzY0LXJhbmRjb25maWctaHhiMS0xMDA0OjoKNzE6MTE6
MTkgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2VjdGluZzogMSByZXZpc2lvbiBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0ZXApClthMGIwYmU2NDU5OWY1
MGRjMmM5ZmE4NTczNDAyNjcwMTIyMWYxODZhXSB4ODY6IE5hdHVyYWxseSBhbGlnbiB0aGUg
ZGVidWcgSVNUIHN0YWNrCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJv
b3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC0yL29iai1iaXNlY3QKbHMgLWEg
L2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWh4YjEtMTAw
NC9saW51eC1kZXZlbDpkZXZlbC1sa3AtaHN4MDIteDg2XzY0LTIwMTQxMDA0MDY0MzphMGIw
YmU2NDU5OWY1MGRjMmM5ZmE4NTczNDAyNjcwMTIyMWYxODZhOmJpc2VjdC1saW51eC0yCgoy
MDE0LTEwLTA0IDA4OjE4OjM3IGEwYjBiZTY0NTk5ZjUwZGMyYzlmYTg1NzM0MDI2NzAxMjIx
ZjE4NmEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVp
bGQtcXVldWUvbGtwLWhzeDAyL3g4Nl82NC1yYW5kY29uZmlnLWh4YjEtMTAwNC1hMGIwYmU2
NDU5OWY1MGRjMmM5ZmE4NTczNDAyNjcwMTIyMWYxODZhCkNoZWNrIGZvciBrZXJuZWwgaW4g
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oeGIxLTEwMDQvYTBiMGJlNjQ1OTlmNTBkYzJj
OWZhODU3MzQwMjY3MDEyMjFmMTg2YQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVp
bGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAyL3g4Nl82NC1yYW5kY29uZmlnLWh4YjEt
MTAwNC1hMGIwYmU2NDU5OWY1MGRjMmM5ZmE4NTczNDAyNjcwMTIyMWYxODZhChtbMTszNW0y
MDE0LTEwLTA0IDA4OjIwOjM4IE5vIGJ1aWxkIHNlcnZlZCBmaWxlIC9rYnVpbGQtdGVzdHMv
YnVpbGQtc2VydmVkL3g4Nl82NC1yYW5kY29uZmlnLWh4YjEtMTAwNC1hMGIwYmU2NDU5OWY1
MGRjMmM5ZmE4NTczNDAyNjcwMTIyMWYxODZhG1swbQpSZXRyeSBidWlsZCAuLgprZXJuZWw6
IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHhiMS0xMDA0L2EwYjBiZTY0NTk5ZjUwZGMy
YzlmYTg1NzM0MDI2NzAxMjIxZjE4NmEvdm1saW51ei0zLjE3LjAtcmM3LTAwMDAyLWdhMGIw
YmU2CgoyMDE0LTEwLTA0IDA4OjIxOjM4IGRldGVjdGluZyBib290IHN0YXRlIC4JMTAwCTE0
NwkxNDgJMTc5CTE4MC4uLi4JMzAwIFNVQ0NFU1MKCkJpc2VjdGluZzogMCByZXZpc2lvbnMg
bGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMCBzdGVwcykKWzU5OGQ1NzBhMDVj
ZDMxNTAwZmIxNWE4NDNhOTJmNjhkZGIxYjM2MThdIHg4NjogQWRkIGludHJpbnNpY3MvbWFj
cm9zIGZvciBuZXcgcmQvd3IgZnMvZ3MgYmFzZSBpbnN0cnVjdGlvbnMKcnVubmluZyAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0
L2xpbnV4LTIvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
eDg2XzY0LXJhbmRjb25maWctaHhiMS0xMDA0L2xpbnV4LWRldmVsOmRldmVsLWxrcC1oc3gw
Mi14ODZfNjQtMjAxNDEwMDQwNjQzOjU5OGQ1NzBhMDVjZDMxNTAwZmIxNWE4NDNhOTJmNjhk
ZGIxYjM2MTg6YmlzZWN0LWxpbnV4LTIKCjIwMTQtMTAtMDQgMDg6Mjg6MDUgNTk4ZDU3MGEw
NWNkMzE1MDBmYjE1YTg0M2E5MmY2OGRkYjFiMzYxOCBjb21waWxpbmcKUXVldWVkIGJ1aWxk
IHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDIveDg2XzY0LXJh
bmRjb25maWctaHhiMS0xMDA0LTU5OGQ1NzBhMDVjZDMxNTAwZmIxNWE4NDNhOTJmNjhkZGIx
YjM2MTgKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWh4
YjEtMTAwNC81OThkNTcwYTA1Y2QzMTUwMGZiMTVhODQzYTkyZjY4ZGRiMWIzNjE4CndhaXRp
bmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4
MDIteDg2XzY0L3g4Nl82NC1yYW5kY29uZmlnLWh4YjEtMTAwNC01OThkNTcwYTA1Y2QzMTUw
MGZiMTVhODQzYTkyZjY4ZGRiMWIzNjE4Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1oeGIxLTEwMDQvNTk4ZDU3MGEwNWNkMzE1MDBmYjE1YTg0M2E5MmY2OGRkYjFiMzYx
OC92bWxpbnV6LTMuMTcuMC1yYzctMDAwMDMtZzU5OGQ1NzBhCgoyMDE0LTEwLTA0IDA4OjMw
OjA1IGRldGVjdGluZyBib290IHN0YXRlIC4JNzkJMTIyCTE1MgkyNjQJMzAwIFNVQ0NFU1MK
CmI4YTg2OGU5ZWE4NzZhMWI0MDAyMDM5NzMwNTUzM2MwOTU5MjFkN2EgaXMgdGhlIGZpcnN0
IGJhZCBjb21taXQKY29tbWl0IGI4YTg2OGU5ZWE4NzZhMWI0MDAyMDM5NzMwNTUzM2MwOTU5
MjFkN2EKQXV0aG9yOiBBbmRpIEtsZWVuIDxha0BsaW51eC5pbnRlbC5jb20+CkRhdGU6ICAg
V2VkIEFwciAyMyAxMzoyNjoyMCAyMDE0IC0wNzAwCgogICAgeDg2OiBBZGQgc3VwcG9ydCBm
b3IgcmQvd3IgZnMvZ3MgYmFzZQogICAgCiAgICBJdnlCcmlkZ2UgYWRkZWQgbmV3IGluc3Ry
dWN0aW9ucyB0byBkaXJlY3RseSB3cml0ZSB0aGUgZnMgYW5kIGdzCiAgICA2NGJpdCBiYXNl
IHJlZ2lzdGVycy4gUHJldmlvdXNseSB0aGlzIGhhZCB0byBiZSBkb25lIHdpdGggYSBzeXN0
ZW0KICAgIGNhbGwgdG8gd3JpdGUgdG8gTVNScy4gVGhlIG1haW4gdXNlIGNhc2UgaXMgZmFz
dCB1c2VyIHNwYWNlIHRocmVhZGluZwogICAgYW5kIHN3aXRjaGluZyB0aGUgZnMvZ3MgcmVn
aXN0ZXJzIHF1aWNrbHkgdGhlcmUuIEFub3RoZXIgdXNlCiAgICBjYXNlIGlzIGhhdmluZyAo
cmVsYXRpdmVseSkgY2hlYXAgYWNjZXNzIHRvIGEgbmV3IGFkZHJlc3MKICAgIHJlZ2lzdGVy
IHBlciB0aHJlYWQuCiAgICAKICAgIFRoZSBpbnN0cnVjdGlvbnMgYXJlIG9wdC1pbiBhbmQg
aGF2ZSB0byBiZSBleHBsaWNpdGVseSBlbmFibGVkCiAgICBieSB0aGUgT1MuCiAgICAKICAg
IFByZXZpb3VzbHkgTGludXggY291bGRuJ3Qgc3VwcG9ydCB0aGlzIGJlY2F1c2UgdGhlIHBh
cmFub2lkCiAgICBlbnRyeSBjb2RlIHJlbGllZCBvbiB0aGUgZ3MgYmFzZSBuZXZlciBiZWlu
ZyBuZWdhdGl2ZSBvdXRzaWRlCiAgICB0aGUga2VybmVsIHRvIGRlY2lkZSB3aGVuIHRvIHVz
ZSBzd2Fwcy4gSXQgd291bGQgY2hlY2sgdGhlIGdzIE1TUgogICAgdmFsdWUgYW5kIGFzc3Vt
ZSBpdCB3YXMgYWxyZWFkeSBydW5uaW5nIGluIGtlcm5lbCBpZiB0aGUgdmFsdWUKICAgIHdh
cyBhbHJlYWR5IG5lZ2F0aXZlLgogICAgCiAgICBUbyBtYWtlIHRoaXMgd29yayB3ZSBoYXZl
IHRvIHJldmFtcCB0aGUgcGFyYW5vaWQgZXhjZXB0aW9uCiAgICBwYXRoIHRvIG5vdCByZWx5
IG9uIHRoaXMuIFdlIGNhbiB1c2UgdGhlIG5ldyBpbnN0cnVjdGlvbnMKICAgIHRvIGdldCAo
cmVsYXRpdmVseSkgcXVpY2sgYWNjZXNzIHRvIHRoZSB2YWx1ZXMuCiAgICAKICAgIFRoaXMg
aXMgYWxzbyBzaWduaWZpY2FudGx5IGZhc3RlciB0aGFuIGEgTVNSIHJlYWQsIHNvIHdpbGwg
c3BlZWQKICAgIE5NSXMgKGNyaXRpY2FsIGZvciBwcm9maWxpbmcpCiAgICAKICAgIFRoZSBv
cmlnaW5hbCBwYXRjaCBjb21wYXJlZCB0aGUgZ3Mgd2l0aCB0aGUga2VybmVsIGdzIGFuZAog
ICAgYXNzdW1lZCB0aGF0IGlmIGl0IHdhcyB0aGUgc2FtZSBzd2FwZ3MgaXMgbm90IG5lZWRl
ZAogICAgKGFuZCBubyB1c2VyIHNwYWNlIHByb2Nlc3Npbmcgd2FzIG5lZWRlZCkuIFRoaXMK
ICAgIHdhcyBuaWNlIGFuZCBzaW1wbGUgYW5kIGRpZG4ndCBuZWVkIGEgbG90IG9mIGNoYW5n
ZXMuCiAgICAKICAgIEJ1dCB0aGlzIGhhZCB0aGUgc2lkZSBlZmZlY3QgdGhhdCBpZiBhIHVz
ZXIgcHJvY2VzcyBzZXQgaXRzCiAgICBHUyB0byB0aGUgc2FtZSBhcyB0aGUga2VybmVsIGl0
IG1heSBsb3NlIHJlc2NoZWR1bGluZwogICAgY2hlY2tzIChzbyBhIHJhY2luZyByZXNjaGVk
dWxlIElQSSB3b3VsZCBoYXZlIGJlZW4KICAgIG9ubHkgYWN0ZWQgdXBvbiB0aGUgbmV4dCBu
b24gcGFyYW5vaWQgaW50ZXJydXB0KQogICAgCiAgICBUaGlzIHZlcnNpb24gbm93IHN3aXRj
aGVzIHRvIGZ1bGwgc2F2ZS9yZXN0b3JlIG9mIHRoZSBHUy4KICAgIFRoaXMgcmVxdWlyZXMg
cXVpdGUgc29tZSBjaGFuZ2VzIGluIHRoZSBwYXJhbm9pZCBwYXRoLgogICAgVW5mb3J0dW5h
dGVseSBkaWRuJ3QgY29tZSB1cCB3aXRoIGEgc2ltcGxlciBzY2hlbWU6CiAgICAKICAgIFRo
ZSBrZXJuZWwgZ3MgZm9yIHRoZSBwYXJhbm9pZCBwYXRoIGlzIG5vdyBzdG9yZWQgYXQgdGhl
CiAgICBib3R0b20gb2YgdGhlIElTVCBzdGFjayAoc28gdGhhdCBpdCBjYW4gYmUgZGVyaXZl
ZCBmcm9tIFJTUCkuCiAgICBGb3IgdGhpcyB3ZSBuZWVkIHRvIGtub3cgdGhlIHNpemUgb2Yg
dGhlIElTVCBzdGFjawogICAgKDRLIG9yIDhLKSwgd2hpY2ggaXMgbm93IHBhc3NlZCBpbiBh
cyBhIHN0YWNrIHBhcmFtZXRlcgogICAgdG8gc2F2ZV9wYXJhbm9pZC4KICAgIAogICAgUHJl
dmlvdXNseSB3ZSBoYWQgYSBmbGFnIGluIEVCWCB0aGF0IGluZGljYXRlZCB3aGV0aGVyCiAg
ICBTV0FQR1MgbmVlZHMgdG8gYmUgY2FsbGVkIGxhdGVyIG9yIG5vdC4gSW4gdGhlIG5ldyBz
Y2hlbWUKICAgIHRoaXMgdHVybnMgaW50byBhIHRyaXN0YXRlLCB3aXRoIGEgbmV3ICJyZXN0
b3JlIGZyb20gUjE1IgogICAgbW9kZS4gVGhlIGV4aXQgcGF0aHMgYXJlIGFsbCBhZGp1c3Rl
ZCB0byBoYW5kbGUgdGhpcyBjb3JyZWN0bHkuCiAgICAKICAgIFRoZXJlIGlzIG9uZSBjb21w
bGljYXRpb246IHRvIGFsbG93IGRlYnVnZ2VycyAoZXNwZWNpYWxseQogICAgZnJvbSB0aGUg
aW50MyBvciBkZWJ1ZyB2ZWN0b3JzKSBhY2Nlc3MgdG8gdGhlIHVzZXIgR1MKICAgIHdlIG5l
ZWQgdG8gc2F2ZSBpdCBpbiB0aGUgdGFzayBzdHJ1Y3QuIE5vcm1hbGx5CiAgICB0aGUgbmV4
dCBjb250ZXh0IHN3aXRjaCB3b3VsZCBvdmVyd3JpdGUgaXQgd2l0aCB0aGUgd3JvbmcKICAg
IHZhbHVlIGZyb20ga2VybmVsX2dzLCBzbyB3ZSBzZXQgbmV3IGZsYWcgYWxzbyBpbiB0YXNr
X3N0cnVjdAogICAgdGhhdCBwcmV2ZW50cyBpdC4KICAgIAogICAgQWxzbyB0byBwcmV2ZW50
IHJlY3Vyc2l2ZSBpbnRlcnJ1cHRzIGNsb2JiZXJpbmcgdGhpcwogICAgc3RhdGUgaW4gdGhl
IHRhc2tfc3RydWN0IHRoaXMgaXMgb25seSBkb25lIGZvciBpbnRlcnJ1cHRzCiAgICBjb21p
bmcgZnJvbSByaW5nIDMuCiAgICAKICAgIEFmdGVyIGEgc2NoZWR1bGUgY29tZXMgYmFjayB3
ZSBjaGVjayBpZiB0aGUgZmxhZyBpcyBzdGlsbAogICAgc2V0LiBJZiBpdCB3YXNuJ3Qgc2V0
IHRoZSBHUyBpcyBiYWNrIGluIHRoZSAoc3dhcHBlZCkga2VybmVsCiAgICBncyBzbyB3ZSBy
ZXZlcnQgdG8gdGhlIFNXQVBHUyBtb2RlLCBpbnN0ZWFkIG9mIHJlc3RvcmluZyBHUy4KICAg
IAogICAgVGhlbiBhZnRlciB0aGVzZSBjaGFuZ2VzIHdlIG5lZWQgdG8gYWxzbyB1c2UgdGhl
IG5ldyBpbnN0cnVjdGlvbnMKICAgIHRvIHNhdmUvcmVzdG9yZSBmcyBhbmQgZ3MsIHNvIHRo
YXQgdGhlIG5ldyB2YWx1ZXMgc2V0IGJ5IHRoZQogICAgdXNlcnMgd29uJ3QgZGlzYXBwZWFy
LiAgVGhpcyBpcyBhbHNvIHNpZ25pZmljYW50bHkKICAgIGZhc3RlciBmb3IgdGhlIGNhc2Ug
d2hlbiB0aGUgNjRiaXQgYmFzZSBoYXMgdG8gYmUgc3dpdGNoZWQKICAgICh0aGF0IGlzIHdo
ZW4gR1MgaXMgbGFyZ2VyIHRoYW4gNEdCKSwgYXMgd2UgY2FuIHJlcGxhY2UKICAgIHRoZSBz
bG93IE1TUiB3cml0ZSB3aXRoIGEgZmFzdGVyIHdyW2ZnXXNiYXNlIGV4ZWN1dGlvbi4KICAg
IAogICAgVGhlIGluc3RydWN0aW9ucyBkbyBub3QgY29udGV4dCBzd2l0Y2gKICAgIHRoZSBz
ZWdtZW50IGluZGV4LCBzbyB0aGUgb2xkIGludmFyaWFudCB0aGF0IGZzIG9yIGdzIGluZGV4
CiAgICBoYXZlIHRvIGJlIDAgZm9yIGEgZGlmZmVyZW50IDY0Yml0IHZhbHVlIHRvIHN0aWNr
IGlzIHN0aWxsCiAgICB0cnVlLiBQcmV2aW91c2x5IGl0IHdhcyBlbmZvcmNlZCBieSBhcmNo
X3ByY3RsLCBub3cgdGhlIHVzZXIKICAgIHByb2dyYW0gaGFzIHRvIG1ha2Ugc3VyZSBpdCBr
ZWVwcyB0aGUgc2VnbWVudCBpbmRleGVzIHplcm8uCiAgICBJZiBpdCBkb2Vzbid0IHRoZSBj
aGFuZ2VzIG1heSBub3Qgc3RpY2suCiAgICAKICAgIFRoaXMgaXMgaW4gdGVybSBlbmFibGVz
IGZhc3Qgc3dpdGNoaW5nIHdoZW4gdGhlcmUgYXJlCiAgICBlbm91Z2ggdGhyZWFkcyB0aGF0
IHRoZWlyIFRMUyBzZWdtZW50IGRvZXMgbm90IGZpdCBiZWxvdyA0R0IsCiAgICBvciBhbHRl
cm5hdGl2ZWx5IHByb2dyYW1zIHRoYXQgdXNlIGZzIGFzIGFuIGFkZGl0aW9uYWwgYmFzZQog
ICAgcmVnaXN0ZXIgd2lsbCBub3QgZ2V0IGEgc2lnaWZpY2FudCBjb250ZXh0IHN3aXRjaCBw
ZW5hbHR5LgogICAgCiAgICBJdCBpcyBhbGwgZG9uZSBpbiBhIHNpbmdsZSBwYXRjaCB0byBh
dm9pZCBiaXNlY3QgY3Jhc2gKICAgIGhvbGVzLgogICAgCiAgICB2MjogQ2hhbmdlIHRvIHNh
dmUvcmVzdG9yZSBHUyBpbnN0ZWFkIG9mIHVzaW5nIHN3YXBncwogICAgYmFzZWQgb24gdGhl
IHZhbHVlLiBMYXJnZSBzY2FsZSBjaGFuZ2VzLgogICAgU2lnbmVkLW9mZi1ieTogQW5kaSBL
bGVlbiA8YWtAbGludXguaW50ZWwuY29tPgoKOjA0MDAwMCAwNDAwMDAgNzJiZTVlYzQ0OWYy
NzIyNmUxOWZhNzU3ODM5Y2EzZjMyY2M5Y2I1MyA0MDg0OWFmY2E5ODY3YjZiYjM1MzhmZTgx
NTY3YWZhNTJkZTM2MjM4IE0JYXJjaApiaXNlY3QgcnVuIHN1Y2Nlc3MKSEVBRCBpcyBub3cg
YXQgNTk4ZDU3MGEuLi4geDg2OiBBZGQgaW50cmluc2ljcy9tYWNyb3MgZm9yIG5ldyByZC93
ciBmcy9ncyBiYXNlIGluc3RydWN0aW9ucwpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1
ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaHhiMS0xMDA0L2xpbnV4LWRldmVsOmRldmVsLWxr
cC1oc3gwMi14ODZfNjQtMjAxNDEwMDQwNjQzOjU5OGQ1NzBhMDVjZDMxNTAwZmIxNWE4NDNh
OTJmNjhkZGIxYjM2MTg6YmlzZWN0LWxpbnV4LTIKCjIwMTQtMTAtMDQgMDg6MzM6MDUgNTk4
ZDU3MGEwNWNkMzE1MDBmYjE1YTg0M2E5MmY2OGRkYjFiMzYxOCByZXVzZSAva2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLWh4YjEtMTAwNC81OThkNTcwYTA1Y2QzMTUwMGZiMTVhODQzYTky
ZjY4ZGRiMWIzNjE4L3ZtbGludXotMy4xNy4wLXJjNy0wMDAwMy1nNTk4ZDU3MGEKCjIwMTQt
MTAtMDQgMDg6MzM6MDYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uCTM5Nwk1MDgJNTY5CTYy
MAk3OTgJODU2CTkwMCBTVUNDRVNTCgpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA1OThk
NTcwYS4uLiB4ODY6IEFkZCBpbnRyaW5zaWNzL21hY3JvcyBmb3IgbmV3IHJkL3dyIGZzL2dz
IGJhc2UgaW5zdHJ1Y3Rpb25zCkhFQUQgaXMgbm93IGF0IDgwNDg5NzUuLi4gMGRheSBoZWFk
IGd1YXJkIGZvciAnZGV2ZWwtbGtwLWhzeDAyLXg4Nl82NC0yMDE0MTAwNDA2NDMnCmxzIC1h
IC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oeGIxLTEw
MDQvbGludXgtZGV2ZWw6ZGV2ZWwtbGtwLWhzeDAyLXg4Nl82NC0yMDE0MTAwNDA2NDM6ODA0
ODk3NTIzMzJmNGU0Zjc1MzQzZDZiNTM5MDk1YjM2NjAxM2JjNjpiaXNlY3QtbGludXgtMgog
VEVTVCBGQUlMVVJFClsgICAgMC45Mjg3MzZdIEZyZWVpbmcgdW51c2VkIGtlcm5lbCBtZW1v
cnk6IDEyNDhLIChmZmZmODgwMDAxNGM4MDAwIC0gZmZmZjg4MDAwMTYwMDAwMCkKWyAgICAw
LjkzMzg0Nl0gRnJlZWluZyB1bnVzZWQga2VybmVsIG1lbW9yeTogMTkzNksgKGZmZmY4ODAw
MDE4MWMwMDAgLSBmZmZmODgwMDAxYTAwMDAwKQpbICAgIDAuOTM4NTQyXSByYW5kb206IGlu
aXQgdXJhbmRvbSByZWFkIHdpdGggMiBiaXRzIG9mIGVudHJvcHkgYXZhaWxhYmxlClsgICAx
Mi4xMDg4NjNdIFBBTklDOiBkb3VibGUgZmF1bHQsIGVycm9yX2NvZGU6IDB4ZmZmZmZmZmZm
ZmZmZmZmZgpbICAgMTIuMTEwMDEyXSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogTWFj
aGluZSBoYWx0ZWQuClsgICAxMi4xMTAwMTJdIENQVTogMCBQSUQ6IDE1MCBDb21tOiB0cmlu
aXR5LW1haW4gTm90IHRhaW50ZWQgMy4xNy4wLXJjNy0wMDExNi1nODA0ODk3NSAjODUKWyAg
IDEyLjExMDAxMl0gSGFyZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQQyAoaTQ0MEZYICsg
UElJWCwgMTk5NiksIEJJT1MgMS43LjUtMjAxNDA1MzFfMDgzMDMwLWdhbmRhbGYgMDQvMDEv
MjAxNApbICAgMTIuMTEwMDEyXSAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDEyNjA3ZTg4
IGZmZmZmZmZmODE0YmYwYTkgZmZmZmZmZmY4MTc0YzQ0ZgpbICAgMTIuMTEwMDEyXSAgZmZm
Zjg4MDAxMjYwN2YwOCBmZmZmZmZmZjgxNGJjZTBkIDAwMDAwMDAwMDAwMDAwMDggZmZmZjg4
MDAxMjYwN2YxOApbICAgMTIuMTEwMDEyXSAgZmZmZjg4MDAxMjYwN2ViMCBmZmZmZmZmZjgx
YmE4ZDAwIDAwMDAwMDAwMDAwMDAwNDYgZmZmZjg4MDAxMzlhYmZkOApbICAgMTIuMTEwMDEy
XSBDYWxsIFRyYWNlOgpbICAgMTIuMTEwMDEyXSAgPCNERj4gIFs8ZmZmZmZmZmY4MTRiZjBh
OT5dIGR1bXBfc3RhY2srMHg0ZC8weDY2ClsgICAxMi4xMTAwMTJdICBbPGZmZmZmZmZmODE0
YmNlMGQ+XSBwYW5pYysweGM0LzB4MWQ2ClsgICAxMi4xMTAwMTJdICBbPGZmZmZmZmZmODEw
MmE5N2M+XSBkZl9kZWJ1ZysweDJjLzB4MmMKWyAgIDEyLjExMDAxMl0gIFs8ZmZmZmZmZmY4
MTAwMmRmOT5dIGRvX2RvdWJsZV9mYXVsdCsweDYyLzB4N2QKWyAgIDEyLjExMDAxMl0gIFs8
ZmZmZmZmZmY4MTRjNWU0ZT5dIGRvdWJsZV9mYXVsdCsweDJlLzB4NDAKWyAgIDEyLjExMDAx
Ml0gIFs8ZmZmZmZmZmY4MTRjNjFjZD5dID8gYXN5bmNfcGFnZV9mYXVsdCsweGQvMHgzMApb
ICAgMTIuMTEwMDEyXSAgPDxFT0U+PiAgPFVOSz4gClsgICAxMi4xMTAwMTJdIEtlcm5lbCBP
ZmZzZXQ6IDB4MCBmcm9tIDB4ZmZmZmZmZmY4MTAwMDAwMCAocmVsb2NhdGlvbiByYW5nZTog
MHhmZmZmZmZmZjgwMDAwMDAwLTB4ZmZmZmZmZmY5ZmZmZmZmZikKCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctaHhiMS0xMDA0LzgwNDg5NzUyMzMyZjRlNGY3NTM0M2Q2YjUzOTA5NWIz
NjYwMTNiYzYvZG1lc2ctcXVhbnRhbC1pdmI0MS0xMDQ6MjAxNDEwMDQwNjQ1MzE6eDg2XzY0
LXJhbmRjb25maWctaHhiMS0xMDA0OjoKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oeGIx
LTEwMDQvODA0ODk3NTIzMzJmNGU0Zjc1MzQzZDZiNTM5MDk1YjM2NjAxM2JjNi9kbWVzZy1x
dWFudGFsLWl2YjQxLTczOjIwMTQxMDA0MDcwOTE0Ong4Nl82NC1yYW5kY29uZmlnLWh4YjEt
MTAwNDo6Cjc5OjI6MiBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKSEVBRCBpcyBub3cg
YXQgODA0ODk3NSAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1sa3AtaHN4MDIteDg2XzY0
LTIwMTQxMDA0MDY0MycKCj09PT09PT09PSBsaW51cy9tYXN0ZXIgPT09PT09PT09Ck5vdGU6
IGNoZWNraW5nIG91dCAnbGludXMvbWFzdGVyJy4KCllvdSBhcmUgaW4gJ2RldGFjaGVkIEhF
QUQnIHN0YXRlLiBZb3UgY2FuIGxvb2sgYXJvdW5kLCBtYWtlIGV4cGVyaW1lbnRhbApjaGFu
Z2VzIGFuZCBjb21taXQgdGhlbSwgYW5kIHlvdSBjYW4gZGlzY2FyZCBhbnkgY29tbWl0cyB5
b3UgbWFrZSBpbiB0aGlzCnN0YXRlIHdpdGhvdXQgaW1wYWN0aW5nIGFueSBicmFuY2hlcyBi
eSBwZXJmb3JtaW5nIGFub3RoZXIgY2hlY2tvdXQuCgpJZiB5b3Ugd2FudCB0byBjcmVhdGUg
YSBuZXcgYnJhbmNoIHRvIHJldGFpbiBjb21taXRzIHlvdSBjcmVhdGUsIHlvdSBtYXkKZG8g
c28gKG5vdyBvciBsYXRlcikgYnkgdXNpbmcgLWIgd2l0aCB0aGUgY2hlY2tvdXQgY29tbWFu
ZCBhZ2Fpbi4gRXhhbXBsZToKCiAgZ2l0IGNoZWNrb3V0IC1iIG5ld19icmFuY2hfbmFtZQoK
SEVBRCBpcyBub3cgYXQgMTI2ZDQ1Ny4uLiBNZXJnZSBicmFuY2ggJ2kyYy9mb3ItY3VycmVu
dCcgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3dz
YS9saW51eApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRj
b25maWctaHhiMS0xMDA0L2xpbnVzOm1hc3RlcjoxMjZkNDU3NmNiNzNjOGE0NDBhZGMzN2Mx
Mjk1ODljZDY2MDUxYmNjOmJpc2VjdC1saW51eC0yCgoyMDE0LTEwLTA0IDA4OjM4OjI4IDEy
NmQ0NTc2Y2I3M2M4YTQ0MGFkYzM3YzEyOTU4OWNkNjYwNTFiY2MgcmV1c2UgL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1oeGIxLTEwMDQvMTI2ZDQ1NzZjYjczYzhhNDQwYWRjMzdjMTI5
NTg5Y2Q2NjA1MWJjYy92bWxpbnV6LTMuMTcuMC1yYzctMDAwOTMtZzEyNmQ0NTcKCjIwMTQt
MTAtMDQgMDg6Mzg6MjkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMjkJMjgwCTM1MAkzOTkJ
NTQ1CTcwMgk4MDEJOTAwIFNVQ0NFU1MKCgo9PT09PT09PT0gbmV4dC9tYXN0ZXIgPT09PT09
PT09CkZyb20gZ2l0Oi8vZ2l0bWlycm9yL25leHQKICsgNDJmY2Q0Mi4uLmRkZjY3OGIgYWtw
bSAgICAgICAtPiBuZXh0L2FrcG0gIChmb3JjZWQgdXBkYXRlKQogKyAyNDlhNTQxLi4uNzA4
NmU3OCBha3BtLWJhc2UgIC0+IG5leHQvYWtwbS1iYXNlICAoZm9yY2VkIHVwZGF0ZSkKICsg
ODk1MzMzOC4uLjJlMWQwMDQgbWFzdGVyICAgICAtPiBuZXh0L21hc3RlciAgKGZvcmNlZCB1
cGRhdGUpCiAgIGZlODJkY2UuLmI2MDFjZTAgIHN0YWJsZSAgICAgLT4gbmV4dC9zdGFibGUK
RnJvbSBnaXQ6Ly9naXRtaXJyb3IvbmV4dAogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIw
MTQxMDAyIC0+IG5leHQtMjAxNDEwMDIKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0
MTAwMyAtPiBuZXh0LTIwMTQxMDAzClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDEyNmQ0
NTcuLi4gTWVyZ2UgYnJhbmNoICdpMmMvZm9yLWN1cnJlbnQnIG9mIGdpdDovL2dpdC5rZXJu
ZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC93c2EvbGludXgKSEVBRCBpcyBub3cg
YXQgMmUxZDAwNC4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAxNDEw
MDMKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmln
LWh4YjEtMTAwNC9uZXh0Om1hc3RlcjoyZTFkMDA0Yjk2NDU2MjhjNjRhMmRiNTVlZjZiODFm
YWRmNWU2ZTkxOmJpc2VjdC1saW51eC0yCgoyMDE0LTEwLTA0IDA4OjQ0OjI2IDJlMWQwMDRi
OTY0NTYyOGM2NGEyZGI1NWVmNmI4MWZhZGY1ZTZlOTEgY29tcGlsaW5nClF1ZXVlZCBidWls
ZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAyL3g4Nl82NC1y
YW5kY29uZmlnLWh4YjEtMTAwNC0yZTFkMDA0Yjk2NDU2MjhjNjRhMmRiNTVlZjZiODFmYWRm
NWU2ZTkxCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1o
eGIxLTEwMDQvMmUxZDAwNGI5NjQ1NjI4YzY0YTJkYjU1ZWY2YjgxZmFkZjVlNmU5MQp3YWl0
aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWhz
eDAyL3g4Nl82NC1yYW5kY29uZmlnLWh4YjEtMTAwNC0yZTFkMDA0Yjk2NDU2MjhjNjRhMmRi
NTVlZjZiODFmYWRmNWU2ZTkxChtbMTszNW0yMDE0LTEwLTA0IDA4OjQ3OjI2IE5vIGJ1aWxk
IHNlcnZlZCBmaWxlIC9rYnVpbGQtdGVzdHMvYnVpbGQtc2VydmVkL3g4Nl82NC1yYW5kY29u
ZmlnLWh4YjEtMTAwNC0yZTFkMDA0Yjk2NDU2MjhjNjRhMmRiNTVlZjZiODFmYWRmNWU2ZTkx
G1swbQpSZXRyeSBidWlsZCAuLgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAyLXg4Nl82NC94ODZfNjQtcmFuZGNvbmZpZy1o
eGIxLTEwMDQtMmUxZDAwNGI5NjQ1NjI4YzY0YTJkYjU1ZWY2YjgxZmFkZjVlNmU5MQprZXJu
ZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaHhiMS0xMDA0LzJlMWQwMDRiOTY0NTYy
OGM2NGEyZGI1NWVmNmI4MWZhZGY1ZTZlOTEvdm1saW51ei0zLjE3LjAtcmM3LW5leHQtMjAx
NDEwMDMKCjIwMTQtMTAtMDQgMDg6NTA6MjYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JNDIJ
MTMwCTE1OAkyMTEJMzQzCTQ5OQk3MDYJODM2CTkwMCBTVUNDRVNTCgo=

--WhfpMioaduB5tiZL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.17.0-rc7-00004-gb8a868e"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.17.0-rc7 Kernel Configuration
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
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
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
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
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
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ_FULL is not set
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
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_RCU_USER_QS=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_NUMA_BALANCING is not set
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
# CONFIG_MEMCG_SWAP is not set
CONFIG_MEMCG_KMEM=y
CONFIG_CGROUP_HUGETLB=y
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
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
CONFIG_SYSTEM_TRUSTED_KEYRING=y
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
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
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
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
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
# CONFIG_MODULE_SIG_SHA256 is not set
CONFIG_MODULE_SIG_SHA384=y
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha384"
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
# CONFIG_ACORN_PARTITION_EESOX is not set
CONFIG_ACORN_PARTITION_ICS=y
# CONFIG_ACORN_PARTITION_ADFS is not set
# CONFIG_ACORN_PARTITION_POWERTEC is not set
# CONFIG_ACORN_PARTITION_RISCIX is not set
CONFIG_AIX_PARTITION=y
# CONFIG_OSF_PARTITION is not set
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=m
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
CONFIG_QUEUE_RWLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_INTEL_LPSS=y
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
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
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_I8K=m
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_MICROCODE_EARLY=y
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
# CONFIG_X86_64_ACPI_NUMA is not set
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
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_HWPOISON_INJECT is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
CONFIG_CMA_AREAS=7
CONFIG_ZSWAP=y
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
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
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_EC_DEBUGFS=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
# CONFIG_ACPI_BUTTON is not set
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_INITRD_TABLE_OVERRIDE=y
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=y
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
# CONFIG_ACPI_APEI_GHES is not set
# CONFIG_ACPI_APEI_PCIEAER is not set
# CONFIG_ACPI_APEI_MEMORY_FAILURE is not set
# CONFIG_ACPI_APEI_EINJ is not set
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
CONFIG_ACPI_EXTLOG=m
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
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
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
# CONFIG_PCIEASPM_DEFAULT is not set
# CONFIG_PCIEASPM_POWERSAVE is not set
CONFIG_PCIEASPM_PERFORMANCE=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
# CONFIG_IA32_EMULATION is not set
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_IOSF_MBI=m
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
# CONFIG_BPF_JIT is not set
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
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_FENCE_TRACE is not set
# CONFIG_DMA_CMA is not set

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
CONFIG_MTD_TESTS=m
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
# CONFIG_MTD_BLOCK is not set
CONFIG_MTD_BLOCK_RO=m
CONFIG_FTL=y
CONFIG_NFTL=m
CONFIG_NFTL_RW=y
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
CONFIG_SSFDC=y
CONFIG_SM_FTL=y
# CONFIG_MTD_OOPS is not set
CONFIG_MTD_SWAP=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
CONFIG_MTD_CFI_BE_BYTE_SWAP=y
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
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
CONFIG_MTD_AMD76XROM=y
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
CONFIG_MTD_CK804XROM=y
CONFIG_MTD_SCB2_FLASH=m
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=m
CONFIG_MTD_PCI=y
CONFIG_MTD_GPIO_ADDR=m
CONFIG_MTD_INTEL_VR_NOR=y
CONFIG_MTD_PLATRAM=y
# CONFIG_MTD_LATCH_ADDR is not set

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
# CONFIG_MTD_PMC551_BUGFIX is not set
CONFIG_MTD_PMC551_DEBUG=y
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=m
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
# CONFIG_MTD_NAND is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
CONFIG_MTD_SPI_NOR=m
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
# CONFIG_MTD_UBI_BLOCK is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
# CONFIG_PARPORT is not set
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
# CONFIG_ZRAM is not set
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
# CONFIG_BLK_DEV_SKD is not set
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
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=m
CONFIG_AD525X_DPOT_I2C=m
CONFIG_DUMMY_IRQ=m
CONFIG_IBM_ASM=m
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_HP_ILO=m
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1780=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=m
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=m
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
CONFIG_USB_SWITCH_FSA9480=m
CONFIG_SRAM=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
CONFIG_VMWARE_VMCI=m

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
CONFIG_GENWQE=m
CONFIG_GENWQE_PLATFORM_ERROR_RECOVERY=0
CONFIG_ECHO=m
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
CONFIG_IDE_GD_ATAPI=y
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
CONFIG_BLK_DEV_IDEACPI=y
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
# CONFIG_BLK_DEV_PLATFORM is not set
CONFIG_BLK_DEV_CMD640=y
CONFIG_BLK_DEV_CMD640_ENHANCED=y
CONFIG_BLK_DEV_IDEPNP=m
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
CONFIG_BLK_DEV_OFFBOARD=y
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
CONFIG_BLK_DEV_AMD74XX=y
# CONFIG_BLK_DEV_ATIIXP is not set
CONFIG_BLK_DEV_CMD64X=m
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_HPT366 is not set
CONFIG_BLK_DEV_JMICRON=m
CONFIG_BLK_DEV_PIIX=m
CONFIG_BLK_DEV_IT8172=m
CONFIG_BLK_DEV_IT8213=y
CONFIG_BLK_DEV_IT821X=m
# CONFIG_BLK_DEV_NS87415 is not set
CONFIG_BLK_DEV_PDC202XX_OLD=m
CONFIG_BLK_DEV_PDC202XX_NEW=m
CONFIG_BLK_DEV_SVWKS=y
CONFIG_BLK_DEV_SIIMAGE=y
CONFIG_BLK_DEV_SIS5513=y
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
CONFIG_BLK_DEV_VIA82CXXX=y
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
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
CONFIG_I2O=m
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
# CONFIG_I2O_EXT_ADAPTEC is not set
CONFIG_I2O_CONFIG=m
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=m
# CONFIG_I2O_BLOCK is not set
# CONFIG_I2O_PROC is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=m
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
# CONFIG_INPUT_SPARSEKMAP is not set
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
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
# CONFIG_KEYBOARD_SAMSUNG is not set
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
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
CONFIG_MOUSE_VSXXXAA=m
CONFIG_MOUSE_GPIO=y
CONFIG_MOUSE_SYNAPTICS_I2C=m
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
CONFIG_TABLET_SERIAL_WACOM4=y
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_AD7879=m
CONFIG_TOUCHSCREEN_AD7879_I2C=m
CONFIG_TOUCHSCREEN_ATMEL_MXT=m
CONFIG_TOUCHSCREEN_AUO_PIXCIR=m
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
CONFIG_TOUCHSCREEN_DYNAPRO=y
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=m
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=m
CONFIG_TOUCHSCREEN_GUNZE=m
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=m
CONFIG_TOUCHSCREEN_WACOM_I2C=m
CONFIG_TOUCHSCREEN_MAX11801=m
# CONFIG_TOUCHSCREEN_MCS5000 is not set
CONFIG_TOUCHSCREEN_MMS114=m
# CONFIG_TOUCHSCREEN_MTOUCH is not set
CONFIG_TOUCHSCREEN_INEXIO=m
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_PENMOUNT=m
CONFIG_TOUCHSCREEN_EDT_FT5X06=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=m
CONFIG_TOUCHSCREEN_UCB1400=m
CONFIG_TOUCHSCREEN_PIXCIR=m
# CONFIG_TOUCHSCREEN_WM97XX is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_TOUCHSCREEN_TSC_SERIO=m
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_TOUCHSCREEN_ST1232=m
CONFIG_TOUCHSCREEN_TPS6507X=m
CONFIG_TOUCHSCREEN_ZFORCE=m
CONFIG_INPUT_MISC=y
CONFIG_INPUT_AD714X=m
# CONFIG_INPUT_AD714X_I2C is not set
CONFIG_INPUT_BMA150=m
# CONFIG_INPUT_PCSPKR is not set
CONFIG_INPUT_MMA8450=m
CONFIG_INPUT_MPU3050=m
# CONFIG_INPUT_APANEL is not set
CONFIG_INPUT_GP2A=m
CONFIG_INPUT_GPIO_BEEPER=y
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
CONFIG_INPUT_ATLAS_BTNS=m
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=m
# CONFIG_INPUT_KXTJ9_POLLED_MODE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_RETU_PWRBUTTON=m
# CONFIG_INPUT_UINPUT is not set
CONFIG_INPUT_PCF8574=m
CONFIG_INPUT_PWM_BEEPER=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=m
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_IDEAPAD_SLIDEBAR=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=m
CONFIG_SERIO_PS2MULT=m
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_HYPERV_KEYBOARD=m
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

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
CONFIG_NOZOMI=m
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

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
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MFD_HSU=m
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
CONFIG_SERIAL_SCCNXP=m
CONFIG_SERIAL_SC16IS7XX=m
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
CONFIG_SERIAL_RP2=m
CONFIG_SERIAL_RP2_NR_UARTS=32
CONFIG_SERIAL_FSL_LPUART=y
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
# CONFIG_SERIAL_MEN_Z135 is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
# CONFIG_IPMI_SI_PROBE_DEFAULTS is not set
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=m
CONFIG_R3964=m
# CONFIG_APPLICOM is not set
CONFIG_MWAVE=m
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y

#
# I2C support
#
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=m
CONFIG_I2C_MUX_PCA9541=m
# CONFIG_I2C_MUX_PCA954x is not set
CONFIG_I2C_MUX_PINCTRL=m
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=m
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
CONFIG_I2C_SIS5595=m
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_VIA=m
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=m
CONFIG_I2C_DESIGNWARE_CORE=m
CONFIG_I2C_DESIGNWARE_PLATFORM=m
CONFIG_I2C_DESIGNWARE_PCI=m
CONFIG_I2C_GPIO=m
CONFIG_I2C_KEMPLD=m
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_TAOS_EVM=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_SPMI=y
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

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
# CONFIG_PTP_1588_CLOCK is not set

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PINCTRL=y

#
# Pin controllers
#
# CONFIG_DEBUG_PINCTRL is not set
CONFIG_PINCTRL_BAYTRAIL=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=m

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=m
CONFIG_GPIO_IT8761E=y
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_SCH311X is not set
CONFIG_GPIO_SCH=m
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_LP3943 is not set
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=m
CONFIG_GPIO_ADP5588=m

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
CONFIG_GPIO_AMD8111=y
# CONFIG_GPIO_INTEL_MID is not set
CONFIG_GPIO_ML_IOH=m
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#

#
# AC97 GPIO expanders:
#
CONFIG_GPIO_UCB1400=m

#
# LPC GPIO expanders:
#
CONFIG_GPIO_KEMPLD=m

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=m

#
# USB GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_DS1WM=m
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
CONFIG_W1_SLAVE_DS2413=m
CONFIG_W1_SLAVE_DS2406=m
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=m
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=m
CONFIG_GENERIC_ADC_BATTERY=y
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_DS2780=m
CONFIG_BATTERY_DS2781=m
CONFIG_BATTERY_DS2782=m
CONFIG_BATTERY_SBS=m
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_MAX17040=m
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_BQ24190=m
CONFIG_CHARGER_BQ24735=m
# CONFIG_CHARGER_SMB347 is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
CONFIG_SENSORS_AD7414=m
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_G762=m
CONFIG_SENSORS_GPIO_FAN=m
CONFIG_SENSORS_HIH6130=m
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
# CONFIG_SENSORS_IIO_HWMON is not set
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
CONFIG_SENSORS_POWR1220=m
CONFIG_SENSORS_LINEAGE=m
CONFIG_SENSORS_LTC2945=m
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4222 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=m
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=m
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=m
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_HTU21=m
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LM95234=m
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_NTC_THERMISTOR=m
CONFIG_SENSORS_NCT6683=m
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=m
# CONFIG_SENSORS_PMBUS is not set
# CONFIG_SENSORS_ADM1275 is not set
CONFIG_SENSORS_LM25066=m
# CONFIG_SENSORS_LTC2978 is not set
# CONFIG_SENSORS_MAX16064 is not set
# CONFIG_SENSORS_MAX34440 is not set
CONFIG_SENSORS_MAX8688=m
CONFIG_SENSORS_TPS40422=m
# CONFIG_SENSORS_UCD9000 is not set
CONFIG_SENSORS_UCD9200=m
CONFIG_SENSORS_ZL6100=m
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
CONFIG_SENSORS_SHTC1=m
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=m
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_SMM665=m
CONFIG_SENSORS_ADC128D818=m
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
CONFIG_SENSORS_TMP103=m
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
CONFIG_SENSORS_ATK0110=m
CONFIG_THERMAL=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
CONFIG_INTEL_POWERCLAMP=y
# CONFIG_X86_PKG_TEMP_THERMAL is not set
# CONFIG_ACPI_INT3403_THERMAL is not set
CONFIG_INTEL_SOC_DTS_THERMAL=m

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
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_BCM590XX=m
# CONFIG_MFD_CROS_EC is not set
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=m
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=m
CONFIG_MFD_KEMPLD=m
CONFIG_MFD_RETU=m
# CONFIG_MFD_PCF50633 is not set
CONFIG_UCB1400_CORE=m
# CONFIG_MFD_RDC321X is not set
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_SI476X_CORE=m
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
CONFIG_ABX500_CORE=y
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=m
CONFIG_MFD_LP3943=m
CONFIG_TPS6105X=m
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=m
CONFIG_MFD_TPS65217=m
CONFIG_MFD_TPS65218=m
CONFIG_MFD_TPS65912=y
CONFIG_MFD_WL1273_CORE=m
CONFIG_MFD_LM3533=m
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=m
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_ACT8865 is not set
CONFIG_REGULATOR_AD5398=m
CONFIG_REGULATOR_BCM590XX=m
CONFIG_REGULATOR_DA9210=m
CONFIG_REGULATOR_DA9211=m
CONFIG_REGULATOR_FAN53555=m
CONFIG_REGULATOR_GPIO=m
CONFIG_REGULATOR_ISL6271A=m
CONFIG_REGULATOR_LP3971=m
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=m
# CONFIG_REGULATOR_LP8755 is not set
CONFIG_REGULATOR_LTC3589=m
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_MAX8649=m
CONFIG_REGULATOR_MAX8660=m
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8973=m
CONFIG_REGULATOR_PFUZE100=m
# CONFIG_REGULATOR_TPS51632 is not set
# CONFIG_REGULATOR_TPS6105X is not set
CONFIG_REGULATOR_TPS62360=m
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=m
# CONFIG_REGULATOR_TPS65217 is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_SDR_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_V4L2_MEM2MEM_DEV=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_DMA_CONTIG=m
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_RC_CORE=y
# CONFIG_RC_MAP is not set
CONFIG_RC_DECODERS=y
# CONFIG_LIRC is not set
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=y
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_SONY_DECODER=m
# CONFIG_IR_SANYO_DECODER is not set
CONFIG_IR_SHARP_DECODER=m
CONFIG_IR_MCE_KBD_DECODER=m
# CONFIG_IR_XMP_DECODER is not set
# CONFIG_RC_DEVICES is not set
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#
# CONFIG_V4L_PLATFORM_DRIVERS is not set
CONFIG_V4L_MEM2MEM_DRIVERS=y
CONFIG_VIDEO_MEM2MEM_DEINTERLACE=m
CONFIG_VIDEO_SH_VEU=m
# CONFIG_VIDEO_RENESAS_VSP1 is not set
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_TEA575X=m
CONFIG_RADIO_SI470X=y
CONFIG_I2C_SI470X=m
# CONFIG_RADIO_SI4713 is not set
# CONFIG_RADIO_SI476X is not set
CONFIG_RADIO_MAXIRADIO=m
# CONFIG_RADIO_TEA5764 is not set
# CONFIG_RADIO_SAA7706H is not set
CONFIG_RADIO_TEF6862=m
# CONFIG_RADIO_WL1273 is not set

#
# Texas Instruments WL128x FM driver (ST based)
#

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=m

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_TVAUDIO is not set
# CONFIG_VIDEO_TDA7432 is not set
# CONFIG_VIDEO_TDA9840 is not set
CONFIG_VIDEO_TEA6415C=m
# CONFIG_VIDEO_TEA6420 is not set
# CONFIG_VIDEO_MSP3400 is not set
CONFIG_VIDEO_CS5345=m
# CONFIG_VIDEO_CS53L32A is not set
CONFIG_VIDEO_TLV320AIC23B=m
CONFIG_VIDEO_UDA1342=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
# CONFIG_VIDEO_VP27SMPX is not set
# CONFIG_VIDEO_SONY_BTF_MPX is not set

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=m

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=m
CONFIG_VIDEO_ADV7183=m
CONFIG_VIDEO_ADV7604=m
CONFIG_VIDEO_ADV7842=m
CONFIG_VIDEO_BT819=m
CONFIG_VIDEO_BT856=m
CONFIG_VIDEO_BT866=m
# CONFIG_VIDEO_KS0127 is not set
CONFIG_VIDEO_ML86V7667=m
CONFIG_VIDEO_SAA7110=m
CONFIG_VIDEO_SAA711X=m
# CONFIG_VIDEO_SAA7191 is not set
# CONFIG_VIDEO_TVP514X is not set
CONFIG_VIDEO_TVP5150=m
CONFIG_VIDEO_TVP7002=m
CONFIG_VIDEO_TW2804=m
CONFIG_VIDEO_TW9903=m
# CONFIG_VIDEO_TW9906 is not set
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_CX25840=m

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m
CONFIG_VIDEO_SAA7185=m
# CONFIG_VIDEO_ADV7170 is not set
CONFIG_VIDEO_ADV7175=m
CONFIG_VIDEO_ADV7343=m
CONFIG_VIDEO_ADV7393=m
CONFIG_VIDEO_ADV7511=m
CONFIG_VIDEO_AD9389B=m
CONFIG_VIDEO_AK881X=m
CONFIG_VIDEO_THS8200=m

#
# Camera sensor devices
#
CONFIG_VIDEO_SMIAPP_PLL=m
# CONFIG_VIDEO_OV7640 is not set
# CONFIG_VIDEO_OV7670 is not set
CONFIG_VIDEO_OV9650=m
CONFIG_VIDEO_VS6624=m
# CONFIG_VIDEO_MT9M032 is not set
# CONFIG_VIDEO_MT9P031 is not set
CONFIG_VIDEO_MT9T001=m
CONFIG_VIDEO_MT9V011=m
CONFIG_VIDEO_MT9V032=m
CONFIG_VIDEO_SR030PC30=m
# CONFIG_VIDEO_NOON010PC30 is not set
CONFIG_VIDEO_M5MOLS=m
CONFIG_VIDEO_S5K6AA=m
# CONFIG_VIDEO_S5K6A3 is not set
CONFIG_VIDEO_S5K4ECGX=m
# CONFIG_VIDEO_S5K5BAF is not set
CONFIG_VIDEO_SMIAPP=m

#
# Flash devices
#
CONFIG_VIDEO_ADP1653=m
CONFIG_VIDEO_AS3645A=m
# CONFIG_VIDEO_LM3560 is not set
# CONFIG_VIDEO_LM3646 is not set

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=m

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_THS7303=m
CONFIG_VIDEO_M52790=m

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=m

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
# CONFIG_MEDIA_TUNER_MT2060 is not set
# CONFIG_MEDIA_TUNER_MT2063 is not set
# CONFIG_MEDIA_TUNER_MT2266 is not set
# CONFIG_MEDIA_TUNER_MT2131 is not set
# CONFIG_MEDIA_TUNER_QT1010 is not set
CONFIG_MEDIA_TUNER_XC2028=m
# CONFIG_MEDIA_TUNER_XC5000 is not set
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_MAX2165=m
# CONFIG_MEDIA_TUNER_TDA18218 is not set
CONFIG_MEDIA_TUNER_FC0011=m
CONFIG_MEDIA_TUNER_FC0012=m
# CONFIG_MEDIA_TUNER_FC0013 is not set
CONFIG_MEDIA_TUNER_TDA18212=m
CONFIG_MEDIA_TUNER_E4000=m
# CONFIG_MEDIA_TUNER_FC2580 is not set
CONFIG_MEDIA_TUNER_M88TS2022=m
CONFIG_MEDIA_TUNER_TUA9001=m
# CONFIG_MEDIA_TUNER_SI2157 is not set
CONFIG_MEDIA_TUNER_IT913X=m
CONFIG_MEDIA_TUNER_R820T=m

#
# Customise DVB Frontends
#
# CONFIG_DVB_AU8522_V4L is not set
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_AMD64 is not set
# CONFIG_AGP_INTEL is not set
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=m
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
# CONFIG_DRM is not set

#
# Frame buffer Devices
#
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
# CONFIG_VGASTATE is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
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
CONFIG_SND_SEQUENCER=m
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=m
# CONFIG_SND_SEQ_HRTIMER_DEFAULT is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
CONFIG_SND_PCM_XRUN_DEBUG=y
CONFIG_SND_VMASTER=y
CONFIG_SND_KCTL_JACK=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
CONFIG_SND_OPL3_LIB_SEQ=m
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
CONFIG_SND_EMU10K1_SEQ=m
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_VX_LIB=y
CONFIG_SND_AC97_CODEC=y
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_SB_COMMON=y
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=m
CONFIG_SND_ALS300=m
CONFIG_SND_ALS4000=y
# CONFIG_SND_ALI5451 is not set
CONFIG_SND_ASIHPI=y
# CONFIG_SND_ATIIXP is not set
CONFIG_SND_ATIIXP_MODEM=m
# CONFIG_SND_AU8810 is not set
CONFIG_SND_AU8820=y
# CONFIG_SND_AU8830 is not set
CONFIG_SND_AW2=m
CONFIG_SND_AZT3328=m
# CONFIG_SND_BT87X is not set
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=y
CONFIG_SND_OXYGEN_LIB=y
CONFIG_SND_OXYGEN=y
CONFIG_SND_CS4281=m
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CTXFI=m
CONFIG_SND_DARLA20=m
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
CONFIG_SND_DARLA24=y
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
CONFIG_SND_MONA=y
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
CONFIG_SND_INDIGODJ=y
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1X=y
# CONFIG_SND_ENS1370 is not set
CONFIG_SND_ENS1371=m
CONFIG_SND_ES1938=m
CONFIG_SND_ES1968=y
CONFIG_SND_ES1968_INPUT=y
CONFIG_SND_FM801=y
# CONFIG_SND_HDSP is not set
CONFIG_SND_HDSPM=m
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=y
CONFIG_SND_INTEL8X0=y
CONFIG_SND_INTEL8X0M=m
# CONFIG_SND_KORG1212 is not set
CONFIG_SND_LOLA=y
# CONFIG_SND_LX6464ES is not set
CONFIG_SND_MAESTRO3=y
CONFIG_SND_MAESTRO3_INPUT=y
CONFIG_SND_MIXART=y
# CONFIG_SND_NM256 is not set
CONFIG_SND_PCXHR=y
CONFIG_SND_RIPTIDE=m
CONFIG_SND_RME32=y
CONFIG_SND_RME96=y
CONFIG_SND_RME9652=m
CONFIG_SND_SONICVIBES=y
CONFIG_SND_TRIDENT=m
CONFIG_SND_VIA82XX=m
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
CONFIG_SND_VX222=y
CONFIG_SND_YMFPCI=m

#
# HD-Audio
#
CONFIG_SND_HDA=y
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_DSP_LOADER=y
CONFIG_SND_HDA_PREALLOC_SIZE=64
CONFIG_SND_HDA_HWDEP=y
# CONFIG_SND_HDA_RECONFIG is not set
# CONFIG_SND_HDA_INPUT_BEEP is not set
# CONFIG_SND_HDA_INPUT_JACK is not set
# CONFIG_SND_HDA_PATCH_LOADER is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
# CONFIG_SND_HDA_CODEC_ANALOG is not set
CONFIG_SND_HDA_CODEC_SIGMATEL=y
# CONFIG_SND_HDA_CODEC_VIA is not set
# CONFIG_SND_HDA_CODEC_HDMI is not set
# CONFIG_SND_HDA_CODEC_CIRRUS is not set
# CONFIG_SND_HDA_CODEC_CONEXANT is not set
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CA0132=y
CONFIG_SND_HDA_CODEC_CA0132_DSP=y
CONFIG_SND_HDA_CODEC_CMEDIA=m

#
# Set to Y if you want auto-loading the codec driver
#
# CONFIG_SND_HDA_CODEC_SI3054 is not set
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
CONFIG_SND_SOC=y
CONFIG_SND_SOC_GENERIC_DMAENGINE_PCM=y
CONFIG_SND_ATMEL_SOC=y
CONFIG_SND_DESIGNWARE_I2S=m

#
# SoC Audio for Freescale CPUs
#

#
# Common SoC Audio options for Freescale CPUs:
#
CONFIG_SND_SOC_FSL_ASRC=y
CONFIG_SND_SOC_FSL_SAI=m
# CONFIG_SND_SOC_FSL_SSI is not set
CONFIG_SND_SOC_FSL_SPDIF=m
# CONFIG_SND_SOC_FSL_ESAI is not set
CONFIG_SND_SOC_IMX_AUDMUX=y
CONFIG_SND_SOC_INTEL_SST=y
CONFIG_SND_SOC_INTEL_SST_ACPI=y
CONFIG_SND_SOC_INTEL_BAYTRAIL=m
# CONFIG_SND_SOC_INTEL_HASWELL_MACH is not set
CONFIG_SND_SOC_INTEL_BYT_RT5640_MACH=m
CONFIG_SND_SOC_INTEL_BYT_MAX98090_MACH=m
CONFIG_SND_SOC_I2C_AND_SPI=m

#
# CODEC drivers
#
# CONFIG_SND_SOC_ADAU1701 is not set
# CONFIG_SND_SOC_AK4554 is not set
CONFIG_SND_SOC_AK4642=m
CONFIG_SND_SOC_AK5386=m
CONFIG_SND_SOC_ALC5623=m
# CONFIG_SND_SOC_CS42L52 is not set
CONFIG_SND_SOC_CS42L56=m
CONFIG_SND_SOC_CS42L73=m
CONFIG_SND_SOC_CS4265=m
CONFIG_SND_SOC_CS4270=m
CONFIG_SND_SOC_CS4271=m
CONFIG_SND_SOC_CS42XX8=m
CONFIG_SND_SOC_CS42XX8_I2C=m
# CONFIG_SND_SOC_HDMI_CODEC is not set
CONFIG_SND_SOC_MAX98090=m
CONFIG_SND_SOC_PCM1681=m
CONFIG_SND_SOC_PCM512x=m
CONFIG_SND_SOC_PCM512x_I2C=m
CONFIG_SND_SOC_RL6231=m
CONFIG_SND_SOC_RT5640=m
CONFIG_SND_SOC_SGTL5000=m
CONFIG_SND_SOC_SIRF_AUDIO_CODEC=m
# CONFIG_SND_SOC_SPDIF is not set
CONFIG_SND_SOC_STA350=m
CONFIG_SND_SOC_TAS2552=m
CONFIG_SND_SOC_TAS5086=m
# CONFIG_SND_SOC_TLV320AIC31XX is not set
CONFIG_SND_SOC_TLV320AIC3X=m
CONFIG_SND_SOC_WM8510=m
CONFIG_SND_SOC_WM8523=m
CONFIG_SND_SOC_WM8580=m
# CONFIG_SND_SOC_WM8711 is not set
# CONFIG_SND_SOC_WM8728 is not set
CONFIG_SND_SOC_WM8731=m
CONFIG_SND_SOC_WM8737=m
# CONFIG_SND_SOC_WM8741 is not set
CONFIG_SND_SOC_WM8750=m
# CONFIG_SND_SOC_WM8753 is not set
CONFIG_SND_SOC_WM8776=m
CONFIG_SND_SOC_WM8804=m
# CONFIG_SND_SOC_WM8903 is not set
CONFIG_SND_SOC_WM8962=m
# CONFIG_SND_SOC_TPA6130A2 is not set
CONFIG_SND_SIMPLE_CARD=m
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=y

#
# HID support
#
# CONFIG_HID is not set

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
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_TAHVO_USB is not set
# CONFIG_USB_GADGET is not set
CONFIG_UWB=y
# CONFIG_UWB_WHCI is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
CONFIG_LEDS_LM3530=m
CONFIG_LEDS_LM3533=m
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8501=m
CONFIG_LEDS_CLEVO_MAIL=m
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=m
CONFIG_LEDS_LT3593=m
CONFIG_LEDS_TCA6507=m
# CONFIG_LEDS_LM355x is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC_CORE=m
# CONFIG_DW_DMAC is not set
CONFIG_DW_DMAC_PCI=m
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=m
CONFIG_UIO_AEC=y
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=y
# CONFIG_HYPERV_BALLOON is not set
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_COMEDI is not set

#
# IIO staging drivers
#

#
# Accelerometers
#

#
# Analog to digital converters
#
CONFIG_AD7606=m
# CONFIG_AD7606_IFACE_PARALLEL is not set

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=m
# CONFIG_ADT7316_I2C is not set

#
# Capacitance to digital converters
#
CONFIG_AD7150=m
# CONFIG_AD7152 is not set
# CONFIG_AD7746 is not set

#
# Direct Digital Synthesis
#

#
# Digital gyroscope sensors
#

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=m
# CONFIG_SENSORS_ISL29028 is not set
# CONFIG_TSL2583 is not set
# CONFIG_TSL2x7x is not set

#
# Magnetometer sensors
#
CONFIG_SENSORS_HMC5843=m
CONFIG_SENSORS_HMC5843_I2C=m

#
# Active energy metering IC
#
CONFIG_ADE7854=m
CONFIG_ADE7854_I2C=m

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
CONFIG_IIO_SIMPLE_DUMMY=m
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
# CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set
CONFIG_FT1000=m

#
# Speakup console speech
#
CONFIG_SPEAKUP=y
CONFIG_SPEAKUP_SYNTH_ACNTSA=m
# CONFIG_SPEAKUP_SYNTH_APOLLO is not set
CONFIG_SPEAKUP_SYNTH_AUDPTR=m
CONFIG_SPEAKUP_SYNTH_BNS=m
CONFIG_SPEAKUP_SYNTH_DECTLK=y
CONFIG_SPEAKUP_SYNTH_DECEXT=y
# CONFIG_SPEAKUP_SYNTH_LTLK is not set
CONFIG_SPEAKUP_SYNTH_SOFT=m
# CONFIG_SPEAKUP_SYNTH_SPKOUT is not set
CONFIG_SPEAKUP_SYNTH_TXPRT=y
CONFIG_SPEAKUP_SYNTH_DUMMY=y
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=m
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=m
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_XILLYBUS is not set
CONFIG_DGNC=m
CONFIG_DGAP=y
CONFIG_GS_FPGABOOT=m
CONFIG_CRYPTO_SKEIN=y
CONFIG_CRYPTO_THREEFISH=y
# CONFIG_UNISYSSPAR is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_LAPTOP=m
CONFIG_CHROMEOS_PSTORE=y

#
# SOC (System On Chip) specific Drivers
#
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
CONFIG_COMMON_CLK_SI5351=m

#
# Hardware Spinlock drivers
#

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
# CONFIG_MAILBOX is not set
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
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
CONFIG_DEVFREQ_GOV_USERSPACE=m

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_ADC_JACK is not set
CONFIG_EXTCON_GPIO=m
# CONFIG_EXTCON_SM5502 is not set
CONFIG_MEMORY=y
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
# CONFIG_BMA180 is not set
CONFIG_IIO_ST_ACCEL_3AXIS=m
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=m
CONFIG_MMA8452=m
# CONFIG_KXCJK1013 is not set

#
# Analog to digital converters
#
# CONFIG_AD7291 is not set
# CONFIG_AD799X is not set
CONFIG_MAX1363=m
CONFIG_MCP3422=m
# CONFIG_MEN_Z188_ADC is not set
CONFIG_NAU7802=m
# CONFIG_TI_ADC081C is not set
# CONFIG_TI_AM335X_ADC is not set

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_IIO_ST_SENSORS_I2C=m
CONFIG_IIO_ST_SENSORS_CORE=m

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
# CONFIG_AD5380 is not set
CONFIG_AD5446=m
# CONFIG_MAX517 is not set
# CONFIG_MCP4725 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital gyroscope sensors
#
# CONFIG_IIO_ST_GYRO_3AXIS is not set
CONFIG_ITG3200=m

#
# Humidity sensors
#
CONFIG_DHT11=y
CONFIG_SI7005=m

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=m

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
# CONFIG_APDS9300 is not set
CONFIG_CM32181=m
# CONFIG_CM36651 is not set
# CONFIG_GP2AP020A00F is not set
# CONFIG_ISL29125 is not set
CONFIG_SENSORS_LM3533=m
CONFIG_LTR501=m
CONFIG_TCS3414=m
# CONFIG_TCS3472 is not set
CONFIG_SENSORS_TSL2563=m
CONFIG_TSL4531=m
CONFIG_VCNL4000=m

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
# CONFIG_AK09911 is not set
CONFIG_MAG3110=m
CONFIG_IIO_ST_MAGN_3AXIS=m
CONFIG_IIO_ST_MAGN_I2C_3AXIS=m

#
# Inclinometer sensors
#

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=m
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure sensors
#
CONFIG_MPL115=m
CONFIG_MPL3115=m
CONFIG_IIO_ST_PRESS=m
CONFIG_IIO_ST_PRESS_I2C=m
CONFIG_T5403=m

#
# Lightning sensors
#

#
# Temperature sensors
#
# CONFIG_MLX90614 is not set
CONFIG_TMP006=m
CONFIG_NTB=m
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
# CONFIG_VME_CA91CX42 is not set
CONFIG_VME_TSI148=m

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=m

#
# VME Device Drivers
#
CONFIG_VME_USER=y
# CONFIG_VME_PIO2 is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_LP3943 is not set
CONFIG_PWM_LPSS=y
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
CONFIG_SERIAL_IPOCTAL=m
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
# CONFIG_FMC_FAKEDEV is not set
CONFIG_FMC_TRIVIAL=y
# CONFIG_FMC_WRITE_EEPROM is not set
# CONFIG_FMC_CHARDEV is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
# CONFIG_POWERCAP is not set
CONFIG_MCB=y
CONFIG_MCB_PCI=m
CONFIG_RAS=y
# CONFIG_THUNDERBOLT is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=m
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=m
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
CONFIG_GOOGLE_MEMCONSOLE=y
CONFIG_UEFI_CPER=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=m
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=m
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_EXT4_DEBUG=y
CONFIG_JBD=m
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_PROC_INFO=y
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
CONFIG_XFS_DEBUG=y
CONFIG_GFS2_FS=m
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=m
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y
CONFIG_BTRFS_DEBUG=y
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_VMCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
# CONFIG_ADFS_FS_RW is not set
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=y
# CONFIG_ECRYPT_FS_MESSAGING is not set
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=y
CONFIG_HFSPLUS_FS_POSIX_ACL=y
# CONFIG_BEFS_FS is not set
CONFIG_BFS_FS=m
CONFIG_EFS_FS=y
# CONFIG_JFFS2_FS is not set
CONFIG_UBIFS_FS=m
# CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=m
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
CONFIG_SQUASHFS_DECOMP_SINGLE=y
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
CONFIG_SQUASHFS_XATTR=y
# CONFIG_SQUASHFS_ZLIB is not set
# CONFIG_SQUASHFS_LZO is not set
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=m
CONFIG_OMFS_FS=m
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=y
# CONFIG_QNX6FS_FS is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
# CONFIG_ROMFS_BACKED_BY_MTD is not set
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_RAM=m
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
CONFIG_UFS_FS_WRITE=y
CONFIG_UFS_DEBUG=y
CONFIG_F2FS_FS=y
# CONFIG_F2FS_STAT_FS is not set
CONFIG_F2FS_FS_XATTR=y
# CONFIG_F2FS_FS_POSIX_ACL is not set
# CONFIG_F2FS_FS_SECURITY is not set
# CONFIG_F2FS_CHECK_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=m
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=m
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=m
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=m
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=m
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=m
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=y
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=m
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
CONFIG_UNUSED_SYMBOLS=y
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
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
# CONFIG_STACKTRACE is not set
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
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
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
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
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
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=m
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_MODULE=m
CONFIG_TEST_USER_COPY=m
# CONFIG_TEST_BPF is not set
CONFIG_TEST_FIRMWARE=y
# CONFIG_TEST_UDELAY is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
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
# CONFIG_PERSISTENT_KEYRINGS is not set
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=m
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
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER=m
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=m
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256_SSSE3=y
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=m
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6=m
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_DES3_EDE_X86_64=m
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_X86_64=y
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=m
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_DRBG_MENU=m
# CONFIG_CRYPTO_DRBG_HMAC is not set
# CONFIG_CRYPTO_DRBG_HASH is not set
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=m
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
# CONFIG_PKCS7_MESSAGE_PARSER is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_BITREVERSE=y
CONFIG_RATIONAL=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=m
CONFIG_CRC8=m
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=m
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_ARCH_HAS_SG_CHAIN=y

--WhfpMioaduB5tiZL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--WhfpMioaduB5tiZL--
