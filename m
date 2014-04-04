Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbaDDDPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 23:15:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:44962 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbaDDDPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 23:15:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,792,1389772800"; 
   d="log'?scan'208";a="514564685"
Date: Fri, 4 Apr 2014 11:15:31 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-kernel@vger.kernel.org, Jet Chen <jet.chen@intel.com>
Subject: [hrtimer] BUG: unable to handle kernel NULL pointer dereference at
 00000010
Message-ID: <20140404031531.GA11828@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit 336ca196738842764df39fbd4d3f9129179b3e7d
Author:     Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate: Mon Mar 31 12:33:21 2014 +0530
Commit:     Viresh Kumar <viresh.kumar@linaro.org>
CommitDate: Wed Apr 2 11:15:17 2014 +0530

    hrtimer: Use for_each_active_base() to iterate over active clock bases
    
    There are various places where we are currently running a loop of
    HRTIMER_MAX_CLOCK_BASES iterations. We just run 'continue;' if there are no
    timers added to a clock base. Instead we can use the new for_each_active_base()
    routine to iterate over only the bases which are currently active.
    
    This also updates hrtimer_interrupt() which was earlier modified to use
    ffs(active_bases) directly.
    
    Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

+----------------------------------------------------------+------------+------------+------------+
|                                                          | f2c2345d95 | 336ca19673 | b0e33c34e2 |
+----------------------------------------------------------+------------+------------+------------+
| boot_successes                                           | 171        | 1          | 5          |
| boot_failures                                            | 37         | 28         | 18         |
| BUG:kernel_test_hang                                     | 15         |            |            |
| BUG:kernel_early_hang_without_any_printk_output          | 8          | 0          | 1          |
| BUG:kernel_boot_hang                                     | 12         |            |            |
| BUG:kernel_boot_crashed                                  | 2          |            |            |
| Oops:DEBUG_PAGEALLOC                                     | 0          | 28         | 17         |
| EIP_is_at_hrtimer_force_reprogram                        | 0          | 28         | 17         |
| Kernel_panic-not_syncing:Attempted_to_kill_the_idle_task | 0          | 28         | 17         |
| backtrace:cpu_startup_entry                              | 0          | 28         | 17         |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference     | 0          | 27         | 16         |
+----------------------------------------------------------+------------+------------+------------+

done.
hwclock: can't open '/dev/misc/rtc': No such file or directory
Running postinst /etc/rpm-postinsts/100...
[    2.258025] BUG: unable to handle kernel NULL pointer dereference at 00000010
[    2.258641] IP: [<bd84b778>] hrtimer_force_reprogram+0x3d/0xb1
[    2.259151] *pde = 00000000 
[    2.259412] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    2.259786] CPU: 0 PID: 0 Comm: swapper Not tainted 3.14.0-rc1-00080-g336ca19 #9
[    2.260388] task: bdde5534 ti: bddda000 task.ti: bddda000
[    2.260830] EIP: 0060:[<bd84b778>] EFLAGS: 00210002 CPU: 0
[    2.261278] EIP is at hrtimer_force_reprogram+0x3d/0xb1
[    2.261284] EAX: bddfaf54 EBX: 00000030 ECX: 00000000 EDX: 7fffffff
[    2.261284] ESI: ffffffff EDI: bddfafd8 EBP: bdddbf48 ESP: bdddbf30
[    2.261284]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[    2.261284] CR0: 8005003b CR2: 00000010 CR3: 10f4e000 CR4: 00000690
[    2.261284] Stack:
[    2.261284]  00000000 00000001 00000001 00000000 bdf3f17c bddfafa8 bdddbf64 bd84b845
[    2.261284]  00000000 bdf3f17c bdf3f17c 00000001 00200046 bdddbf78 bd84c153 bdf3f17c
[    2.261284]  00000000 00000000 bdddbf84 bd84c19e 86969207 bdddbfa0 bd8771f0 86969207
[    2.261284] Call Trace:
[    2.261284]  [<bd84b845>] __remove_hrtimer+0x59/0x7b
[    2.261284]  [<bd84c153>] hrtimer_try_to_cancel+0x7b/0xb4
[    2.261284]  [<bd84c19e>] hrtimer_cancel+0x12/0x1d
[    2.261284]  [<bd8771f0>] tick_nohz_idle_exit+0x129/0x1f1
[    2.261284]  [<bd867b07>] cpu_startup_entry+0x1fa/0x290
[    2.261284]  [<bdbf1a96>] rest_init+0xa2/0xa7
[    2.261284]  [<bdfe79f6>] start_kernel+0x3be/0x3c5
[    2.261284]  [<bdfe72c3>] i386_start_kernel+0x79/0x7d
[    2.261284] Code: 55 ec ba ff ff ff 7f 89 75 f0 83 ce ff 83 cb ff 0f bc 7d f0 0f 44 fb 8d 4f 01 6b d9 30 85 c9 89 7d e8 8d 7c 18 54 74 38 8b 4f e0 <8b> 59 10 8b 49 0c 2b 4f f8 1b 5f fc 85 db 79 04 31 c9 31 db 39
[    2.261284] EIP: [<bd84b778>] hrtimer_force_reprogram+0x3d/0xb1 SS:ESP 0068:bdddbf30
[    2.261284] CR2: 0000000000000010
[    2.261284] ---[ end trace e155771ac78a2857 ]---
[    2.261284] Kernel panic - not syncing: Attempted to kill the idle task!

git bisect start b0e33c34e23c7f8ede2f19d992628802308c3afc 455c6fdbd219161bd09b1165f11699d6d73de11c --
git bisect good c055491e20b2cde6b0b95af708ba1e95be080b81  # 23:20     23+      1  Merge 'drm-intel/drm-intel-nightly' into devel-roam-i386-201404021703
git bisect good 2fa442064d8c64d1114e55a8ea07ab681d690580  # 23:33     23+      0  Merge 'drm-exynos/exynos-drm-next' into devel-roam-i386-201404021703
git bisect  bad 9dc0b63c0484a57ff4d11619f8986caac86643a8  # 23:47      1-      4  Merge 'vireshk/timer-cleanup-for-tglx' into devel-roam-i386-201404021703
git bisect good b97f0291a2504291aef850077f98cab68a5a2f33  # 00:13     23+      2  tick: Remove code duplication in tick_handle_periodic()
git bisect good fe04ef37d949ea92dbc37164eff116fe3c4a0930  # 00:39     23+      0  hrtimer: make enqueue_hrtimer() return void
git bisect  bad deab1b2857728ee9d98078d2547fd7ab030ff508  # 00:48      0-      6  hrtimer: call hrtimer_get_softirq_time() only if cpu_base->active_bases is set
git bisect good dcdce37edcaacc6f3b4cc3f1b9a9c2a459b0ed9b  # 01:56     23+      5  hrtimer: use base->hres_active directly instead of hrtimer_hres_active()
git bisect good ca9949bac1a7e54bf7f832e0ffffdaafac8ea5c5  # 02:07     23+      2  hrtimer: replace sizeof(struct hrtimer) with sizeof(*timer)
git bisect  bad 336ca196738842764df39fbd4d3f9129179b3e7d  # 02:07      0-     28  hrtimer: Use for_each_active_base() to iterate over active clock bases
git bisect good f2c2345d95fd44633a1356bad259198673192e21  # 03:15     23+     12  hrtimer: create for_each_active_base()
# first bad commit: [336ca196738842764df39fbd4d3f9129179b3e7d] hrtimer: Use for_each_active_base() to iterate over active clock bases
git bisect good f2c2345d95fd44633a1356bad259198673192e21  # 04:35     69+     37  hrtimer: create for_each_active_base()
git bisect  bad b0e33c34e23c7f8ede2f19d992628802308c3afc  # 04:35      0-     18  0day head guard for 'devel-roam-i386-201404021703'
git bisect good 59ecc26004e77e100c700b1d0da7502b0fdadb46  # 04:46     69+      6  Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
git bisect good 4b22efdd5595f0acb48f02bf664a451ee98f9a2e  # 05:06     69+      2  Add linux-next specific files for 20140403


This script may reproduce the error.

-----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-i386.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/$initrd

kvm=(
	qemu-system-x86_64 -cpu kvm64 -enable-kvm
	-kernel $kernel
	-initrd $initrd
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
Fengguang

--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-lkp-ib04-9:20140404015729:i386-randconfig-r1-0402:3.14.0-rc1-00080-g336ca19:9"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc1-00080-g336ca19 (kbuild@roam) (gcc v=
ersion 4.8.2 (Debian 4.8.2-18) ) #9 Fri Apr 4 01:56:59 CST 2014
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
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x100000
[    0.000000] initial memory mapped: [mem 0x00000000-0x0e7fffff]
[    0.000000] Base memory trampoline at [b009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13800000-0x13bfffff]
[    0.000000]  [mem 0x13800000-0x13bfffff] page 4k
[    0.000000] BRK [0x0e5a1000, 0x0e5a1fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x137fffff]
[    0.000000]  [mem 0x10000000-0x137fffff] page 4k
[    0.000000] BRK [0x0e5a2000, 0x0e5a2fff] PGTABLE
[    0.000000] BRK [0x0e5a3000, 0x0e5a3fff] PGTABLE
[    0.000000] BRK [0x0e5a4000, 0x0e5a4fff] PGTABLE
[    0.000000] BRK [0x0e5a5000, 0x0e5a5fff] PGTABLE
[    0.000000] BRK [0x0e5a6000, 0x0e5a6fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] cma: CMA: reserved 16 MiB at 12800000
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
[    0.000000] ACPI: RSDP 000fd950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 13ffe450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: FACP 13ffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXP=
C 00000001)
[    0.000000] ACPI: DSDT 13ffe490 0011A9 (v01   BXPC   BXDSDT 00000001 INT=
L 20100528)
[    0.000000] ACPI: FACS 13ffff40 000040
[    0.000000] ACPI: SSDT 13fff7a0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: APIC 13fff680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXP=
C 00000001)
[    0.000000] ACPI: HPET 13fff640 000038 (v01 BOCHS  BXPCHPET 00000001 BXP=
C 00000001)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 40 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 760 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr ddf2bc0
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81020
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kernel-tests/run-queue/kvm/i386-randconfig-r1-0402/linux-devel=
:devel-roam-i386-201404021703:336ca196738842764df39fbd4d3f9129179b3e7d:bise=
ct-linux5/.vmlinuz-336ca196738842764df39fbd4d3f9129179b3e7d-20140404015707-=
25-lkp-ib04 branch=3Dlinux-devel/devel-roam-i386-201404021703 BOOT_IMAGE=3D=
/kernel/i386-randconfig-r1-0402/336ca196738842764df39fbd4d3f9129179b3e7d/vm=
linuz-3.14.0-rc1-00080-g336ca19 drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 289836K/327280K available (4092K kernel code, 2102K =
rwdata, 1888K rodata, 372K init, 5260K bss, 37444K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffcd000 - 0xfffff000   ( 200 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xc47fe000 - 0xff7fe000   ( 944 MB)
[    0.000000]     lowmem  : 0xb0000000 - 0xc3ffe000   ( 319 MB)
[    0.000000]       .init : 0xbdfe7000 - 0xbe044000   ( 372 kB)
[    0.000000]       .data : 0xbdbff6cc - 0xbdfe68c0   (3996 kB)
[    0.000000]       .text : 0xbd800000 - 0xbdbff6cc   (4093 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D1, =
Nodes=3D1
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3Dc2406000 soft=3Dc2408000
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] ACPI: setting ELCR to 0200 (from 0c00)
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
[    0.000000]  memory used by lock dependency info: 3807 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ODEBUG: 11 of 11 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2493.918 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 4989.66 Bogo=
MIPS (lpj=3D8313060)
[    0.006666] pid_max: default: 4096 minimum: 301
[    0.006666] Security Framework initialized
[    0.006666] Mount-cache hash table entries: 512
[    0.006666] Initializing cgroup subsys debug
[    0.006666] Initializing cgroup subsys devices
[    0.006678] Initializing cgroup subsys freezer
[    0.007044] Initializing cgroup subsys net_cls
[    0.007406] Initializing cgroup subsys perf_event
[    0.007793] Initializing cgroup subsys net_prio
[    0.008226] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.008226] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.008226] tlb_flushall_shift: 6
[    0.009376] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.012880] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.015125] devtmpfs: initialized
[    0.017744] prandom: seed boundary self test passed
[    0.018615] prandom: 100 self tests passed
[    0.019400] NET: Registered protocol family 16
[    0.020311] cpuidle: using governor ladder
[    0.020663] cpuidle: using governor menu
[    0.021315] ACPI: bus type PCI registered
[    0.021788] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.022312] PCI: Using configuration type 1 for base access
[    0.027340] ACPI: Added _OSI(Module Device)
[    0.027698] ACPI: Added _OSI(Processor Device)
[    0.028063] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.028445] ACPI: Added _OSI(Processor Aggregator Device)
[    0.035188] ACPI: Interpreter enabled
[    0.035505] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20131218/hwxface-580)
[    0.036276] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20131218/hwxface-580)
[    0.036891] ACPI: (supports S0 S3 S5)
[    0.037198] ACPI: Using PIC for interrupt routing
[    0.037613] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.047701] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.048226] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.048679] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.049496] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.050098] PCI host bridge to bus 0000:00
[    0.050445] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.050895] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.051390] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.051889] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.052433] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.053380] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.054339] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.055411] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.058502] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.060210] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.061007] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.061597] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.062511] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.063929] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.065664] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.073389] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.074511] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.075897] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.077111] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.082182] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.083044] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.083818] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.087810] pci_bus 0000:00: on NUMA node 0
[    0.088734] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.089407] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.090130] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.090779] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.091371] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.092422] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.093258] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.093342] vgaarb: loaded
[    0.093574] vgaarb: bridge control possible 0000:00:02.0
[    0.094574] pps_core: LinuxPPS API ver. 1 registered
[    0.094989] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.095739] PTP clock support registered
[    0.096707] EDAC MC: Ver: 3.0.0
[    0.097416] PCI: Using ACPI for IRQ routing
[    0.097772] PCI: pci_cache_line_size set to 64 bytes
[    0.098290] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.098781] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.099598] NET: Registered protocol family 8
[    0.100008] NET: Registered protocol family 20
[    0.100486] nfc: nfc_init: NFC Core ver 0.1
[    0.100902] NET: Registered protocol family 39
[    0.101641] Switched to clocksource kvm-clock
[    0.102517] Warning: could not register annotated branches stats
[    0.138978] pnp: PnP ACPI init
[    0.139292] ACPI: bus type PNP registered
[    0.139752] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.140454] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.141075] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.141663] pnp 00:03: [dma 2]
[    0.141977] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.142632] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.143288] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.143991] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.144853] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.145593] pnp: PnP ACPI: found 8 devices
[    0.145935] ACPI: bus type PNP unregistered
[    0.181869] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.182444] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.182907] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.183498] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.184037] NET: Registered protocol family 1
[    0.184426] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.184921] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.185408] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.185931] pci 0000:00:02.0: Boot video device
[    0.186328] PCI: CLS 0 bytes, default 64
[    0.186938] Unpacking initramfs...
[    0.295164] debug: unmapping init [mem 0xc3cbd000-0xc3feffff]
[    0.296175] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    0.296865] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    0.297786] apm: BIOS not found.
[    0.298273] cryptomgr_test (15) used greatest stack depth: 7384 bytes le=
ft
[    0.299923] futex hash table entries: 16 (order: -3, 768 bytes)
[    0.304726] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.305249] fuse init (API version 7.22)
[    0.308721] NET: Registered protocol family 38
[    0.309113] list_sort_test: start testing list_sort()
[    0.309756] test_string_helpers: Running tests...
[    0.310604] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    0.311021] crc32: self tests passed, processed 225944 bytes in 158900 n=
sec
[    0.311751] crc32c: CRC_LE_BITS =3D 64
[    0.312043] crc32c: self tests passed, processed 225944 bytes in 79601 n=
sec
[    0.523179] crc32_combine: 8373 self tests passed
[    0.732396] crc32c_combine: 8373 self tests passed
[    0.733308] xz_dec_test: module loaded
[    0.733684] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
251 0' and write .xz files to it.
[    0.734496] rbtree testing -> 9243 cycles
[    1.163954] augmented rbtree testing -> 11275 cycles
[    1.693041] ipmi message handler version 39.2
[    1.693510] ipmi device interface
[    1.693834] IPMI System Interface driver.
[    1.694251] ipmi_si: Adding default-specified kcs state machine
[    1.694759] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    1.695577] ipmi_si: Interface detection failed
[    1.695961] tsc: Refined TSC clocksource calibration: 2493.973 MHz
[    1.696485] ipmi_si: Adding default-specified smic state machine
[    1.697055] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    1.697870] ipmi_si: Interface detection failed
[    1.698246] ipmi_si: Adding default-specified bt state machine
[    1.698733] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    1.699533] ipmi_si: Interface detection failed
[    1.699972] ipmi_si: Unable to find any System Interface(s)
[    1.700710] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    1.701341] ACPI: Power Button [PWRF]
[    1.735340] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.757952] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    1.759428] Non-volatile memory driver v1.3
[    1.759787] toshiba: not a supported Toshiba laptop
[    1.760546] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    1.761139] platform pc8736x_gpio.0: no device found
[    1.761651] nsc_gpio initializing
[    1.761939] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    1.762361] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    1.763080] Hangcheck: Using getrawmonotonic().
[    1.763713] dummy-irq: no IRQ given.  Use irq=3DN
[    1.765031] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    1.765649] slram: not enough parameters.
[    1.805105] No valid DiskOnChip devices found
[    1.805534] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    1.806300] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    1.807115] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    1.807883] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    1.808636] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    1.809382] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    1.810182] nand: device found, Manufacturer ID: 0x98, Chip ID: 0x39
[    1.810702] nand: Toshiba NAND 128MiB 1,8V 8-bit
[    1.811074] nand: 128MiB, SLC, page size: 512, OOB size: 16
[    1.811602] flash size: 128 MiB
[    1.811869] page size: 512 bytes
[    1.812132] OOB area size: 16 bytes
[    1.812425] sector size: 16 KiB
[    1.812689] pages number: 262144
[    1.812954] pages per sector: 32
[    1.813223] bus width: 8
[    1.813501] bits in sector size: 14
[    1.813804] bits in page size: 9
[    1.814071] bits in OOB size: 4
[    1.814335] flash size with OOB: 135168 KiB
[    1.814674] page address bytes: 4
[    1.814946] sector address bytes: 3
[    1.815236] options: 0x42
[    1.816856] Scanning device for bad blocks
[    1.861453] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    1.861957] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    1.862970] HSI/SSI char device loaded
[    1.863323] LocalTalk card not found; 220 =3D ff, 240 =3D ff.
[    1.864429] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.t=
c.umn.edu>
[    1.865244] ipddp0: Appletalk-IP Encap. mode by Bradford W. Johnson <joh=
ns393@maroon.tc.umn.edu>
[    1.866015] vcan: Virtual CAN interface driver
[    1.866395] CAN device driver interface
[    1.866764] sja1000 CAN netdevice driver
[    1.867103] sja1000_isa: insufficient parameters supplied
[    1.867877] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    1.867877] baycom_ser_hdx: version 0.10
[    1.869462] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[    1.869937] hdlcdrv: version 0.8
[    1.870267] PPP generic driver version 2.4.2
[    1.870804] PPP BSD Compression module registered
[    1.871211] PPP Deflate Compression module registered
[    1.871632] PPP MPPE Compression module registered
[    1.872026] NET: Registered protocol family 24
[    1.872416] adummy: version 1.0
[    1.872888] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    1.874233] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.874666] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.875398] mousedev: PS/2 mouse device common for all mice
[    1.875970] i2c /dev entries driver
[    1.876498] pps pps0: new PPS source ktimer
[    1.876922] pps pps0: ktimer PPS source registered
[    1.877324] Driver for 1-wire Dallas network protocol.
[    1.877811] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    1.878362] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    1.880076] applesmc: supported laptop not found!
[    1.880474] applesmc: driver init failed (ret=3D-19)!
[    1.881440] pc87360: PC8736x not detected, module not inserted
[    1.882587] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    1.883287] acquirewdt: I/O address 0x0043 already in use
[    1.883798] acquirewdt: probe of acquirewdt failed with error -5
[    1.884369] sc1200wdt: build 20020303
[    1.884686] sc1200wdt: io parameter must be specified
[    1.885106] pc87413_wdt: Version 1.1 at io 0x2E
[    1.885559] pc87413_wdt: initialized. timeout=3D1 min
[    1.885989] pc87413_wdt: cannot request SWC region at 0xffff
[    1.886613] sbc60xxwdt: WDT driver for 60XX single board computer initia=
lised. timeout=3D30 sec (nowayout=3D0)
[    1.887455] sbc7240_wdt: I/O address 0x0443 already in use
[    1.887935] cpu5wdt: misc_register failed
[    1.888270] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[    1.889942] smsc37b787_wdt: Unable to register miscdev on minor 130
[    1.890552] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[    1.891055] w83697hf_wdt: watchdog not found at address 0x2e
[    1.891518] w83697hf_wdt: No W83697HF/HG could be found
[    1.891935] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[    1.892642] w83697ug_wdt: No W83697UG/UF could be found
[    1.893061] w83977f_wdt: driver v1.00
[    1.893434] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    1.893973] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    1.894465] machzwd: no ZF-Logic found
[    1.894771] sbc_epx_c3: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[    1.895393] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    1.896062] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    1.896888] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D0)
[    1.898430] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    1.899096] hidraw: raw HID events driver (C) Jiri Kosina
[    1.900459]  fake-fmc-carrier: mezzanine 0
[    1.900809]       Manufacturer: fake-vendor
[    1.901152]       Product name: fake-design-for-testing
[    1.901637] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    1.902212] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eep=
rom: no busid passed, refusing all cards
[    1.903055] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[    1.903788] fmc_chardev fake-design-for-testing-f001: Created misc devic=
e "fake-design-for-testing-f001"
[    1.904620] intel_rapl: driver does not support CPU family 15 model 6
[    1.905444] Audio Excel DSP 16 init driver Copyright (C) Riccardo Facche=
tti 1995-98
[    1.906070] aedsp16: I/O, IRQ and DMA are mandatory
[    1.906470] pss: mss_io, mss_dma, mss_irq and pss_io must be set.
[    1.907016] ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen=
 1993-1996
[    1.907647] ad1848: No ISAPnP cards found, trying standard ones...
[    1.908143] sb: Init: Starting Probe...
[    1.908487] sb: Init: Done
[    1.908730] Cyrix Kahlua VSA1 XpressAudio support (c) Copyright 2003 Red=
 Hat Inc
[    1.909355] uart6850: irq and io must be set.
[    1.909710] YM3812 and OPL-3 driver Copyright (C) by Hannu Savolainen, R=
ob Hooft 1993-1996
[    1.910433] MIDI Loopback device driver
[    1.910995] NET: Registered protocol family 26
[    1.911579] netem: version 1.3
[    1.911855] u32 classifier
[    1.912084]     Performance counters on
[    1.912445] NET: Registered protocol family 15
[    1.912855] NET: Registered protocol family 4
[    1.913257] NET: Registered protocol family 5
[    1.914412] NET: Registered protocol family 6
[    1.914815] NET: Registered protocol family 3
[    1.915192] can: controller area network core (rev 20120528 abi 9)
[    1.915742] NET: Registered protocol family 29
[    1.916115] can: broadcast manager protocol (rev 20120528 t)
[    1.916596] can: netlink gateway (rev 20130117) max_hops=3D1
[    1.917174] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[    1.917978] DECnet: Routing cache hash table of 256 buckets, 11Kbytes
[    1.918545] NET: Registered protocol family 12
[    1.918958] 8021q: 802.1Q VLAN Support v1.8
[    1.919393] 9pnet: Installing 9P2000 support
[    1.919811] NET: Registered protocol family 37
[    1.920266] mpls_gso: MPLS GSO support
[    1.921157] IMA: No TPM chip found, activating TPM-bypass!
[    1.922137] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.922648] EDD information not available.
[    1.922981] ### dt-test ### No testcase data in device tree; not running=
 tests
[    1.924270] debug: unmapping init [mem 0xbdfe7000-0xbe043fff]
[    1.932521] mount (77) used greatest stack depth: 6932 bytes left
/etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: No such file or directory
[    1.940665] S00fbsetup (79) used greatest stack depth: 6752 bytes left

Please wait: booting...
Starting udev
[    1.960169] pidof (93) used greatest stack depth: 6688 bytes left
error initializing inotify
error sending message: Connection refused
error sending message: Connection refused
Starting Bootlog daemon: bootlogd: cannot find console device 4:64 under /d=
ev
bootlogd.
[    2.102078] chown (155) used greatest stack depth: 6476 bytes left
[    2.150553] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
Configuring network interfaces... ifconfig: socket: Address family not supp=
orted by protocol
done.
hwclock: can't open '/dev/misc/rtc': No such file or directory
Running postinst /etc/rpm-postinsts/100...
[    2.258025] BUG: unable to handle kernel NULL pointer dereference at 000=
00010
[    2.258641] IP: [<bd84b778>] hrtimer_force_reprogram+0x3d/0xb1
[    2.259151] *pde =3D 00000000=20
[    2.259412] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    2.259786] CPU: 0 PID: 0 Comm: swapper Not tainted 3.14.0-rc1-00080-g33=
6ca19 #9
[    2.260388] task: bdde5534 ti: bddda000 task.ti: bddda000
[    2.260830] EIP: 0060:[<bd84b778>] EFLAGS: 00210002 CPU: 0
[    2.261278] EIP is at hrtimer_force_reprogram+0x3d/0xb1
[    2.261284] EAX: bddfaf54 EBX: 00000030 ECX: 00000000 EDX: 7fffffff
[    2.261284] ESI: ffffffff EDI: bddfafd8 EBP: bdddbf48 ESP: bdddbf30
[    2.261284]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[    2.261284] CR0: 8005003b CR2: 00000010 CR3: 10f4e000 CR4: 00000690
[    2.261284] Stack:
[    2.261284]  00000000 00000001 00000001 00000000 bdf3f17c bddfafa8 bdddb=
f64 bd84b845
[    2.261284]  00000000 bdf3f17c bdf3f17c 00000001 00200046 bdddbf78 bd84c=
153 bdf3f17c
[    2.261284]  00000000 00000000 bdddbf84 bd84c19e 86969207 bdddbfa0 bd877=
1f0 86969207
[    2.261284] Call Trace:
[    2.261284]  [<bd84b845>] __remove_hrtimer+0x59/0x7b
[    2.261284]  [<bd84c153>] hrtimer_try_to_cancel+0x7b/0xb4
[    2.261284]  [<bd84c19e>] hrtimer_cancel+0x12/0x1d
[    2.261284]  [<bd8771f0>] tick_nohz_idle_exit+0x129/0x1f1
[    2.261284]  [<bd867b07>] cpu_startup_entry+0x1fa/0x290
[    2.261284]  [<bdbf1a96>] rest_init+0xa2/0xa7
[    2.261284]  [<bdfe79f6>] start_kernel+0x3be/0x3c5
[    2.261284]  [<bdfe72c3>] i386_start_kernel+0x79/0x7d
[    2.261284] Code: 55 ec ba ff ff ff 7f 89 75 f0 83 ce ff 83 cb ff 0f bc =
7d f0 0f 44 fb 8d 4f 01 6b d9 30 85 c9 89 7d e8 8d 7c 18 54 74 38 8b 4f e0 =
<8b> 59 10 8b 49 0c 2b 4f f8 1b 5f fc 85 db 79 04 31 c9 31 db 39
[    2.261284] EIP: [<bd84b778>] hrtimer_force_reprogram+0x3d/0xb1 SS:ESP 0=
068:bdddbf30
[    2.261284] CR2: 0000000000000010
[    2.261284] ---[ end trace e155771ac78a2857 ]---
[    2.261284] Kernel panic - not syncing: Attempted to kill the idle task!
[    2.261284] Kernel Offset: 0xc800000 from 0xb1000000 (relocation range: =
0xb0000000-0xc47fdfff)
[    2.261284] Rebooting in 10 seconds..
Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-r=
1-0402/336ca196738842764df39fbd4d3f9129179b3e7d/vmlinuz-3.14.0-rc1-00080-g3=
36ca19 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D=
10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3D=
ttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kerne=
l-tests/run-queue/kvm/i386-randconfig-r1-0402/linux-devel:devel-roam-i386-2=
01404021703:336ca196738842764df39fbd4d3f9129179b3e7d:bisect-linux5/.vmlinuz=
-336ca196738842764df39fbd4d3f9129179b3e7d-20140404015707-25-lkp-ib04 branch=
=3Dlinux-devel/devel-roam-i386-201404021703 BOOT_IMAGE=3D/kernel/i386-randc=
onfig-r1-0402/336ca196738842764df39fbd4d3f9129179b3e7d/vmlinuz-3.14.0-rc1-0=
0080-g336ca19 drbd.minor_count=3D8'  -initrd /kernel-tests/initrd/yocto-min=
imal-i386.cgz -m 320 -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=
=3D1,hostfwd=3Dtcp::51109-:22 -boot order=3Dnc -no-reboot -watchdog i6300es=
b -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-yocto-lkp-ib04-9 -seria=
l file:/dev/shm/kboot/serial-yocto-lkp-ib04-9 -daemonize -display none -mon=
itor null=20

--X1bOJ3K7DJ5YkBrT
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-r1-0402-b0e33c34e23c7f8ede2f19d992628802308c3afc-BUG:-unable-to-handle-kernel-NULL-pointer-dereference-at-119227.log"
Content-Transfer-Encoding: base64

Tm8gcGF0Y2ggcmVtb3ZlZApIRUFEIGlzIG5vdyBhdCBiMGUzM2MzLi4uIDBkYXkgaGVhZCBn
dWFyZCBmb3IgJ2RldmVsLXJvYW0taTM4Ni0yMDE0MDQwMjE3MDMnCmdpdCBjaGVja291dCA0
NTVjNmZkYmQyMTkxNjFiZDA5YjExNjVmMTE2OTlkNmQ3M2RlMTFjCmxzIC1hIC9rZXJuZWwt
dGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctcjEtMDQwMi9saW51eC1kZXZl
bDpkZXZlbC1yb2FtLWkzODYtMjAxNDA0MDIxNzAzOjQ1NWM2ZmRiZDIxOTE2MWJkMDliMTE2
NWYxMTY5OWQ2ZDczZGUxMWM6YmlzZWN0LXN0YWJsZQoKMjAxNC0wNC0wMy0yMjozMDo1OCA0
NTVjNmZkYmQyMTkxNjFiZDA5YjExNjVmMTE2OTlkNmQ3M2RlMTFjIHJldXNlIC9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXIxLTA0MDIvNDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjExNjk5
ZDZkNzNkZTExYy92bWxpbnV6LTMuMTQuMAoKMjAxNC0wNC0wMy0yMjozMDo1OCBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAuLi4uLi4uLi4JMS4JMi4uLgkzLi4uCTQJNi4JNy4uCTkJMTAuCTEx
Li4JMTIuCTEzLi4uCTE0Li4uCTE1CTE2Li4uLi4uLi4uLi4uLi4uLi4uLi4uCTIzIFNVQ0NF
U1MKCmJpc2VjdDogZ29vZCBjb21taXQgNDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjExNjk5
ZDZkNzNkZTExYwpnaXQgYmlzZWN0IHN0YXJ0IGIwZTMzYzM0ZTIzYzdmOGVkZTJmMTlkOTky
NjI4ODAyMzA4YzNhZmMgNDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjExNjk5ZDZkNzNkZTEx
YyAtLQovYy9rZXJuZWwtdGVzdHMvbGluZWFyLWJpc2VjdDogWyItYiIsICJiMGUzM2MzNGUy
M2M3ZjhlZGUyZjE5ZDk5MjYyODgwMjMwOGMzYWZjIiwgIi1nIiwgIjQ1NWM2ZmRiZDIxOTE2
MWJkMDliMTE2NWYxMTY5OWQ2ZDczZGUxMWMiLCAiL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCIsICIvaG9tZS93Zmcvc3RhYmxlL29iai1iaXNlY3QiXQpC
aXNlY3Rpbmc6IDEwMDEgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3Vn
aGx5IDEwIHN0ZXBzKQpbYzA1NTQ5MWUyMGIyY2RlNmIwYjk1YWY3MDhiYTFlOTViZTA4MGI4
MV0gTWVyZ2UgJ2RybS1pbnRlbC9kcm0taW50ZWwtbmlnaHRseScgaW50byBkZXZlbC1yb2Ft
LWkzODYtMjAxNDA0MDIxNzAzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcvc3RhYmxlL29iai1iaXNlY3QKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yMS0wNDAyL2xpbnV4
LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0MDQwMjE3MDM6YzA1NTQ5MWUyMGIyY2RlNmIw
Yjk1YWY3MDhiYTFlOTViZTA4MGI4MTpiaXNlY3Qtc3RhYmxlCgoyMDE0LTA0LTAzLTIzOjAz
OjMwIGMwNTU0OTFlMjBiMmNkZTZiMGI5NWFmNzA4YmExZTk1YmUwODBiODEgY29tcGlsaW5n
ClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1y
YW5kY29uZmlnLXIxLTA0MDItYzA1NTQ5MWUyMGIyY2RlNmIwYjk1YWY3MDhiYTFlOTViZTA4
MGI4MQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIxLTA0
MDIvYzA1NTQ5MWUyMGIyY2RlNmIwYjk1YWY3MDhiYTFlOTViZTA4MGI4MQp3YWl0aW5nIGZv
ciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29u
ZmlnLXIxLTA0MDItYzA1NTQ5MWUyMGIyY2RlNmIwYjk1YWY3MDhiYTFlOTViZTA4MGI4MQp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkz
ODYtcmFuZGNvbmZpZy1yMS0wNDAyLWMwNTU0OTFlMjBiMmNkZTZiMGI5NWFmNzA4YmExZTk1
YmUwODBiODEKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMS0wNDAyL2MwNTU0
OTFlMjBiMmNkZTZiMGI5NWFmNzA4YmExZTk1YmUwODBiODEvdm1saW51ei0zLjE0LjAtMDA4
OTEtZ2MwNTU0OTEKCjIwMTQtMDQtMDMtMjM6MTg6MzAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
CTEJNQkyMQkyMyBTVUNDRVNTCgpCaXNlY3Rpbmc6IDExMCByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNyBzdGVwcykKWzJmYTQ0MjA2NGQ4YzY0ZDExMTRl
NTVhOGVhMDdhYjY4MWQ2OTA1ODBdIE1lcmdlICdkcm0tZXh5bm9zL2V4eW5vcy1kcm0tbmV4
dCcgaW50byBkZXZlbC1yb2FtLWkzODYtMjAxNDA0MDIxNzAzCnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcvc3RhYmxlL29i
ai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNv
bmZpZy1yMS0wNDAyL2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0MDQwMjE3MDM6
MmZhNDQyMDY0ZDhjNjRkMTExNGU1NWE4ZWEwN2FiNjgxZDY5MDU4MDpiaXNlY3Qtc3RhYmxl
CgoyMDE0LTA0LTAzLTIzOjIwOjMxIDJmYTQ0MjA2NGQ4YzY0ZDExMTRlNTVhOGVhMDdhYjY4
MWQ2OTA1ODAgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rZXJuZWwtdGVzdHMv
YnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXIxLTA0MDItMmZhNDQyMDY0ZDhjNjRkMTEx
NGU1NWE4ZWEwN2FiNjgxZDY5MDU4MApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLXIxLTA0MDIvMmZhNDQyMDY0ZDhjNjRkMTExNGU1NWE4ZWEwN2FiNjgx
ZDY5MDU4MAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQt
cXVldWUvaTM4Ni1yYW5kY29uZmlnLXIxLTA0MDItMmZhNDQyMDY0ZDhjNjRkMTExNGU1NWE4
ZWEwN2FiNjgxZDY5MDU4MAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwtdGVz
dHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1yMS0wNDAyLTJmYTQ0MjA2NGQ4YzY0
ZDExMTRlNTVhOGVhMDdhYjY4MWQ2OTA1ODAKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNv
bmZpZy1yMS0wNDAyLzJmYTQ0MjA2NGQ4YzY0ZDExMTRlNTVhOGVhMDdhYjY4MWQ2OTA1ODAv
dm1saW51ei0zLjE0LjAtMDA5MDctZzJmYTQ0MjAKCjIwMTQtMDQtMDMtMjM6MzA6MzEgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JNAkxNwkyMyBTVUNDRVNTCgpCaXNlY3Rpbmc6IDk0IHJl
dmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA3IHN0ZXBzKQpbOWRj
MGI2M2MwNDg0YTU3ZmY0ZDExNjE5Zjg5ODZjYWFjODY2NDNhOF0gTWVyZ2UgJ3ZpcmVzaGsv
dGltZXItY2xlYW51cC1mb3ItdGdseCcgaW50byBkZXZlbC1yb2FtLWkzODYtMjAxNDA0MDIx
NzAzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aCAvaG9tZS93Zmcvc3RhYmxlL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4t
cXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yMS0wNDAyL2xpbnV4LWRldmVsOmRldmVsLXJv
YW0taTM4Ni0yMDE0MDQwMjE3MDM6OWRjMGI2M2MwNDg0YTU3ZmY0ZDExNjE5Zjg5ODZjYWFj
ODY2NDNhODpiaXNlY3Qtc3RhYmxlCgoyMDE0LTA0LTAzLTIzOjMzOjAyIDlkYzBiNjNjMDQ4
NGE1N2ZmNGQxMTYxOWY4OTg2Y2FhYzg2NjQzYTggY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0
YXNrIHRvIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXIxLTA0
MDItOWRjMGI2M2MwNDg0YTU3ZmY0ZDExNjE5Zjg5ODZjYWFjODY2NDNhOApDaGVjayBmb3Ig
a2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIxLTA0MDIvOWRjMGI2M2MwNDg0
YTU3ZmY0ZDExNjE5Zjg5ODZjYWFjODY2NDNhOAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9m
IC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXIxLTA0MDItOWRj
MGI2M2MwNDg0YTU3ZmY0ZDExNjE5Zjg5ODZjYWFjODY2NDNhOAp3YWl0aW5nIGZvciBjb21w
bGV0aW9uIG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1y
MS0wNDAyLTlkYzBiNjNjMDQ4NGE1N2ZmNGQxMTYxOWY4OTg2Y2FhYzg2NjQzYTgKa2VybmVs
OiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMS0wNDAyLzlkYzBiNjNjMDQ4NGE1N2ZmNGQx
MTYxOWY4OTg2Y2FhYzg2NjQzYTgvdm1saW51ei0zLjE0LjAtMDEwMDAtZzlkYzBiNjMKCjIw
MTQtMDQtMDMtMjM6NDc6MDIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTEgVEVTVCBGQUlMVVJF
ClsgICAgMy41NDI1ODZdICMjIyBkdC10ZXN0ICMjIyBObyB0ZXN0Y2FzZSBkYXRhIGluIGRl
dmljZSB0cmVlOyBub3QgcnVubmluZyB0ZXN0cwpbICAgIDMuNTQ1MTg2XSBkZXZ0bXBmczog
bW91bnRlZApbICAgIDMuNTQ1Njg0XSBkZWJ1ZzogdW5tYXBwaW5nIGluaXQgW21lbSAweGMy
MWVhMDAwLTB4YzIyNDVmZmZdClsgICAgMy41NDcwNzBdIGdlbmVyYWwgcHJvdGVjdGlvbiBm
YXVsdDogMDAwMCBbIzFdIERFQlVHX1BBR0VBTExPQwpbICAgIDMuNTQ3MDcwXSBDUFU6IDAg
UElEOiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xNC4wLTAxMDAwLWc5ZGMwYjYz
ICM0ClsgICAgMy41NDcwNzBdIHRhc2s6IGMwMDQ4MDAwIHRpOiBjMjI1MDAwMCB0YXNrLnRp
OiBjMDA0NjAwMApbICAgIDMuNTQ3MDcwXSBFSVA6IDAwNjA6WzxjMWI3ZmNmMT5dIEVGTEFH
UzogMDAwMTQwODYgQ1BVOiAwClsgICAgMy41NDcwNzBdIEVJUCBpcyBhdCBudW1iZXIuaXNy
YS4yKzB4ZS8weDI1NQpbICAgIDMuNTQ3MDcwXSBFQVg6IGMyNjZmMjhlIEVCWDogYzI2NmYy
OGUgRUNYOiBmZmZmMDAyMSBFRFg6IGMyNjZmNjUwClsgICAgMy41NDcwNzBdIEVTSTogYzFm
NWEyZDMgRURJOiBmZmZmMDAyMSBFQlA6IGMyMjUwZTU0IEVTUDogYzIyNTBkZTQKWyAgICAz
LjU0NzA3MF0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMDAwIEdTOiAwMGUwIFNTOiAwMDY4
ClsgICAgMy41NDcwNzBdIENSMDogODAwNTAwM2IgQ1IyOiBiZmZmZmZjNCBDUjM6IDEyMjQ5
MDAwIENSNDogMDAwMDA2OTAKWyAgICAzLjU0NzA3MF0gU3RhY2s6ClsgICAgMy41NDcwNzBd
ICAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAw
MCAwMDAwMDAwMCAwMDAwMDAwMApbICAgIDMuNTQ3MDcwXSAgMDAwMDAwMDAgMDAwMDAwMDAg
MDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAK
WyAgICAzLjU0NzA3MF0gIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAw
MDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwClsgICAgMy41NDcwNzBdIENhbGwg
VHJhY2U6ClsgICAgMy41NDcwNzBdICBbPGMxYjgwN2NlPl0gdnNucHJpbnRmKzB4MmJlLzB4
MzE3ClsgICAgMy41NDcwNzBdICBbPGMxYjgwYWJjPl0gdnNjbnByaW50ZisweDEwLzB4NDIK
WyAgICAzLjU0NzA3MF0gIFs8YzFhNjZiYjc+XSB2cHJpbnRrX2VtaXQrMHgxZDcvMHgzYmYK
WyAgICAzLjU0NzA3MF0gIFs8YzFkZjVlZDc+XSBwcmludGsrMHgxYy8weDFlClsgICAgMy41
NDcwNzBdICBbPGMxYTFjOWM2Pl0gZG91YmxlZmF1bHRfZm4rMHgzMS8weGY1ClsgICAgMy41
NDcwNzBdICBbPGMxYTFkNjU1Pl0gPyBrdm1fYXN5bmNfcGZfdGFza193YWtlKzB4MzAvMHhk
YwpbICAgIDMuNTQ3MDcwXSAgWzxjMWExZDY1NT5dID8ga3ZtX2FzeW5jX3BmX3Rhc2tfd2Fr
ZSsweDMwLzB4ZGMKWyAgICAzLjU0NzA3MF0gIFs8YzFhMWQ2NTU+XSA/IGt2bV9hc3luY19w
Zl90YXNrX3dha2UrMHgzMC8weGRjClsgICAgMy41NDcwNzBdICBbPGMxYTFkNjU1Pl0gPyBr
dm1fYXN5bmNfcGZfdGFza193YWtlKzB4MzAvMHhkYwpbICAgIDMuNTQ3MDcwXSAgWzxjMWEx
ZDY1NT5dID8ga3ZtX2FzeW5jX3BmX3Rhc2tfd2FrZSsweDMwLzB4ZGMKWyAgICAzLjU0NzA3
MF0gIFs8YzFhMWQ2NTU+XSA/IGt2bV9hc3luY19wZl90YXNrX3dha2UrMHgzMC8weGRjClsg
ICAgMy41NDcwNzBdICBbPGMxYTFkNjU1Pl0gPyBrdm1fYXN5bmNfcGZfdGFza193YWtlKzB4
MzAvMHhkYwpbICAgIDMuNTQ3MDcwXSAgWzxjMWExZDY1NT5dID8ga3ZtX2FzeW5jX3BmX3Rh
c2tfd2FrZSsweDMwLzB4ZGMKWyAgICAzLjU0NzA3MF0gIFs8YzFhMWQ2NTU+XSA/IGt2bV9h
c3luY19wZl90YXNrX3dha2UrMHgzMC8weGRjClsgICAgMy41NDcwNzBdICBbPGMxYTFkNjU1
Pl0gPyBrdm1fYXN5bmNfcGZfdGFza193YWtlKzB4MzAvMHhkYwpbICAgIDMuNTQ3MDcwXSAg
WzxjMWExZDY1NT5dID8ga3ZtX2FzeW5jX3BmX3Rhc2tfd2FrZSsweDMwLzB4ZGMKWyAgICAz
LjU0NzA3MF0gIFs8YzFhMWQ2NTU+XSA/IGt2bV9hc3luY19wZl90YXNrX3dha2UrMHgzMC8w
eGRjClsgICAgMy41NDcwNzBdICBbPGMxYTFkNjU1Pl0gPyBrdm1fYXN5bmNfcGZfdGFza193
YWtlKzB4MzAvMHhkYwpbICAgIDMuNTQ3MDcwXSAgWzxjMWExZDY1NT5dID8ga3ZtX2FzeW5j
X3BmX3Rhc2tfd2FrZSsweDMwLzB4ZGMKWyAgICAzLjU0NzA3MF0gIFs8YzFhMWQ2NTU+XSA/
IGt2bV9hc3luY19wZl90YXNrX3dha2UrMHgzMC8weGRjClsgICAgMy41NDcwNzBdICBbPGMx
YTFkNjU1Pl0gPyBrdm1fYXN5bmNfcGZfdGFza193YWtlKzB4MzAvMHhkYwpbICAgIDMuNTQ3
MDcwXSAgWzxjMWExZDY1NT5dID8ga3ZtX2FzeW5jX3BmX3Rhc2tfd2FrZSsweDMwLzB4ZGMK
WyAgICAzLjU0NzA3MF0gIFs8YzFhMWQ2NTU+XSA/IGt2bV9hc3luY19wZl90YXNrX3dha2Ur
MHgzMC8weGRjClsgICAgMy41NDcwNzBdICBbPGMxYTFkNjU1Pl0gPyBrdm1fYXN5bmNfcGZf
dGFza193YWtlKzB4MzAvMHhkYwpbICAgIDMuNTQ3MDcwXSAgWzxjMWExZDY1NT5dID8ga3Zt
X2FzeW5jX3BmX3Rhc2tfd2FrZSsweDMwLzB4ZGMKWyAgICAzLjU0NzA3MF0gIFs8YzFhMWQ2
NTU+XSA/IGt2bV9hc3luY19wZl90YXNrX3dha2UrMHgzMC8weGRjClsgICAgMy41NDcwNzBd
ICBbPGMxYTFkNjU1Pl0gPyBrdm1fYXN5bmNfcGZfdGFza193YWtlKzB4MzAvMHhkYwpbICAg
IDMuNTQ3MDcwXSAgWzxjMWExZDY1NT5dID8ga3ZtX2FzeW5jX3BmX3Rhc2tfd2FrZSsweDMw
LzB4ZGMKWyAgICAzLjU0NzA3MF0gIFs8YzFhMWQ2NTU+XSA/IGt2bV9hc3luY19wZl90YXNr
X3dha2UrMHgzMC8weGRjClsgICAgMy41NDcwNzBdICBbPGMxYTFkNjU1Pl0gPyBrdm1fYXN5
bmNfcGZfdGFza193YWtlKzB4MzAvMHhkYwpbICAgIDMuNTQ3MDcwXSAgWzxjMWExZDY1NT5d
ID8ga3ZtX2FzeW5jX3BmX3Rhc2tfd2FrZSsweDMwLzB4ZGMKWyAgICAzLjU0NzA3MF0gIFs8
YzFhMWQ2NTU+XSA/IGt2bV9hc3luY19wZl90YXNrX3dha2UrMHgzMC8weGRjClsgICAgMy41
NDcwNzBdICBbPGMxYTFkNjU1Pl0gPyBrdm1fYXN5bmNfcGZfdGFza193YWtlKzB4MzAvMHhk
YwpbICAgIDMuNTQ3MDcwXSAgWzxjMWExZDY1NT5dID8ga3ZtX2FzeW5jX3BmX3Rhc2tfd2Fr
ZSsweDMwLzB4ZGMKWyAgICAzLjU0NzA3MF0gIFs8YzFhMWQ2NTU+XSA/IGt2bV9hc3luY19w
Zl90YXNrX3dha2UrMHgzMC8weGRjClsgICAgMy41NDcwNzBdICBbPGMxYTFkNjU1Pl0gPyBr
dm1fYXN5bmNfcGZfdGFza193YWtlKzB4MzAvMHhkYwpbICAgIDMuNTQ3MDcwXSAgWzxjMWEx
ZDY1NT5dID8ga3ZtX2FzeW5jX3BmX3Rhc2tfd2FrZSsweDMwLzB4ZGMKWyAgICAzLjU0NzA3
MF0gIFs8YzFhMWQ2NTU+XSA/IGt2bV9hc3luY19wZl90YXNrX3dha2UrMHgzMC8weGRjClsg
ICAgMy41NDcwNzBdICBbPGMxYTFkNjU1Pl0gPyBrdm1fYXN5bmNfcGZfdGFza193YWtlKzB4
MzAvMHhkYwpbICAgIDMuNTQ3MDcwXSAgWzxjMWExZDY1NT5dID8ga3ZtX2FzeW5jX3BmX3Rh
c2tfd2FrZSsweDMwLzB4ZGMKWyAgICAzLjU0NzA3MF0gIFs8YzFhMWQ2NTU+XSA/IGt2bV9h
c3luY19wZl90YXNrX3dha2UrMHgzMC8weGRjClsgICAgMy41NDcwNzBdICBbPGMxYTFkNjU1
Pl0gPyBrdm1fYXN5bmNfcGZfdGFza193YWtlKzB4MzAvMHhkYwpbICAgIDMuNTQ3MDcwXSAg
WzxjMWExZDY1NT5dID8ga3ZtX2FzeW5jX3BmX3Rhc2tfd2FrZSsweDMwLzB4ZGMKWyAgICAz
LjU0NzA3MF0gIFs8YzFhMWQ2NTU+XSA/IGt2bV9hc3luY19wZl90YXNrX3dha2UrMHgzMC8w
eGRjClsgICAgMy41NDcwNzBdICBbPGMxYTFkNjU1Pl0gPyBrdm1fYXN5bmNfcGZfdGFza193
YWtlKzB4MzAvMHhkYwpbICAgIDMuNTQ3MDcwXSAgWzxjMWExZDY1NT5dID8ga3ZtX2FzeW5j
X3BmX3Rhc2tfd2FrZSsweDMwLzB4ZGMKWyAgICAzLjU0NzA3MF0gIFs8YzFhMWQ2NTU+XSA/
IGt2bV9hc3luY19wZl90YXNrX3dha2UrMHgzMC8weGRjClsgICAgMy41NDcwNzBdICBbPGMx
YTFkNjU1Pl0gPyBrdm1fYXN5bmNfcGZfdGFza193YWtlKzB4MzAvMHhkYwpbICAgIDMuNTQ3
MDcwXSAgWzxjMWExZDY1NT5dID8ga3ZtX2FzeW5jX3BmX3Rhc2tfd2FrZSsweDMwLzB4ZGMK
WyAgICAzLjU0NzA3MF0gIFs8YzFhMWQ2NTU+XSA/IGt2bV9hc3luY19wZl90YXNrX3dha2Ur
MHgzMC8weGRjClsgICAgMy41NDcwNzBdICBbPGMxYTFkNjU1Pl0gPyBrdm1fYXN5bmNfcGZf
dGFza193YWtlKzB4MzAvMHhkYwpbICAgIDMuNTQ3MDcwXSAgWzxjMWExZDY1NT5dID8ga3Zt
X2FzeW5jX3BmX3Rhc2tfd2FrZSsweDMwLzB4ZGMKWyAgICAzLjU0NzA3MF0gIFs8YzFhMWQ2
NTU+XSA/IGt2bV9hc3luY19wZl90YXNrX3dha2UrMHgzMC8weGRjClsgICAgMy41NDcwNzBd
ICBbPGMxYTFkNjU1Pl0gPyBrdm1fYXN5bmNfcGZfdGFza193YWtlKzB4MzAvMHhkYwpbICAg
IDMuNTQ3MDcwXSAgWzxjMWExZDY1NT5dID8ga3ZtX2FzeW5jX3BmX3Rhc2tfd2FrZSsweDMw
LzB4ZGMKWyAgICAzLjU0NzA3MF0gIFs8YzFhMWQ2NTU+XSA/IGt2bV9hc3luY19wZl90YXNr
X3dha2UrMHgzMC8weGRjClsgICAgMy41NDcwNzBdICBbPGMxYTFkNjU1Pl0gPyBrdm1fYXN5
bmNfcGZfdGFza193YWtlKzB4MzAvMHhkYwpbICAgIDMuNTQ3MDcwXSAgWzxjMWExZDY1NT5d
ID8ga3ZtX2FzeW5jX3BmX3Rhc2tfd2FrZSsweDMwLzB4ZGMKWyAgICAzLjU0NzA3MF0gIFs8
YzFhMWQ2NTU+XSA/IGt2bV9hc3luY19wZl90YXNrX3dha2UrMHgzMC8weGRjClsgICAgMy41
NDcwNzBdICBbPGMxYTFkNjU1Pl0gPyBrdm1fYXN5bmNfcGZfdGFza193YWtlKzB4MzAvMHhk
YwpbICAgIDMuNTQ3MDcwXSAgWzxjMWExZDY1NT5dID8ga3ZtX2FzeW5jX3BmX3Rhc2tfd2Fr
ZSsweDMwLzB4ZGMKWyAgICAzLjU0NzA3MF0gIFs8YzFhMWQ2NTU+XSA/IGt2bV9hc3luY19w
Zl90YXNrX3dha2UrMHgzMC8weGRjClsgICAgMy41NDcwNzBdICBbPGMxYTFkNjU1Pl0gPyBr
dm1fYXN5bmNfcGZfdGFza193YWtlKzB4MzAvMHhkYwpbICAgIDMuNTQ3MDcwXSAgWzxjMWEx
ZDY1NT5dID8ga3ZtX2FzeW5jX3BmX3Rhc2tfd2FrZSsweDMwLzB4ZGMKWyAgICAzLjU0NzA3
MF0gIFs8YzFhMWQ2NTU+XSA/IGt2bV9hc3luY19wZl90YXNrX3dha2UrMHgzMC8weGRjClsg
ICAgMy41NDcwNzBdICBbPGMxYTFkNjU1Pl0gPyBrdm1fYXN5bmNfcGZfdGFza193YWtlKzB4
MzAvMHhkYwpbICAgIDMuNTQ3MDcwXSAgWzxjMWExZDY1NT5dID8ga3ZtX2FzeW5jX3BmX3Rh
c2tfd2FrZSsweDMwLzB4ZGMKWyAgICAzLjU0NzA3MF0gIFs8YzFhMWQ2NTU+XSA/IGt2bV9h
c3luY19wZl90YXNrX3dha2UrMHgzMC8weGRjClsgICAgMy41NDcwNzBdICBbPGMxYTFkNjU1
Pl0gPyBrdm1fYXN5bmNfcGZfdGFza193YWtlKzB4MzAvMHhkYwpbICAgIDMuNTQ3MDcwXSAg
WzxjMWExZDY1NT5dID8ga3ZtX2FzeW5jX3BmX3Rhc2tfd2FrZSsweDMwLzB4ZGMKWyAgICAz
LjU0NzA3MF0gIFs8YzFhMWQ2NTU+XSA/IGt2bV9hc3luY19wZl90YXNrX3dha2UrMHgzMC8w
eGRjClsgICAgMy41NDcwNzBdICBbPGMxYTFkNjU1Pl0gPyBrdm1fYXN5bmNfcGZfdGFza193
YWtlKzB4MzAvMHhkYwpbICAgIDMuNTQ3MDcwXSAgWzxjMWExZDY1NT5dID8ga3ZtX2FzeW5j
X3BmX3Rhc2tfd2FrZSsweDMwLzB4ZGMKWyAgICAzLjU0NzA3MF0gIFs8YzFhMWQ2NTU+XSA/
IGt2bV9hc3luY19wZl90YXNrX3dha2UrMHgzMC8weGRjClsgICAgMy41NDcwNzBdICBbPGMx
YTFkNjU1Pl0gPyBrdm1fYXN5bmNfcGZfdGFza193YWtlKzB4MzAvMHhkYwpbICAgIDMuNTQ3
MDcwXSAgWzxjMWExZDY1NT5dID8ga3ZtX2FzeW5jX3BmX3Rhc2tfd2FrZSsweDMwLzB4ZGMK
WyAgICAzLjU0NzA3MF0gIFs8YzFhMWQ2NTU+XSA/IGt2bV9hc3luY19wZl90YXNrX3dha2Ur
MHgzMC8weGRjClsgICAgMy41NDcwNzBdICBbPGMxYTFkNjU1Pl0gPyBrdm1fYXN5bmNfcGZf
dGFza193YWtlKzB4MzAvMHhkYwpbICAgIDMuNTQ3MDcwXSAgWzxjMWExZDY1NT5dID8ga3Zt
X2FzeW5jX3BmX3Rhc2tfd2FrZSsweDMwLzB4ZGMKWyAgICAzLjU0NzA3MF0gIFs8YzFhMWQ2
NTU+XSA/IGt2bV9hc3luY19wZl90YXNrX3dha2UrMHgzMC8weGRjClsgICAgMy41NDcwNzBd
ICBbPGMxYTFkNjU1Pl0gPyBrdm1fYXN5bmNfcGZfdGFza193YWtlKzB4MzAvMHhkYwpbICAg
IDMuNTQ3MDcwXSAgWzxjMWExZDY1NT5dID8ga3ZtX2FzeW5jX3BmX3Rhc2tfd2FrZSsweDMw
LzB4ZGMKWyAgICAzLjU0NzA3MF0gIFs8YzFhMWQ2NTU+XSA/IGt2bV9hc3luY19wZl90YXNr
X3dha2UrMHgzMC8weGRjClsgICAgMy41NDcwNzBdICBbPGMxYTFkNjU1Pl0gPyBrdm1fYXN5
bmNfcGZfdGFza193YWtlKzB4MzAvMHhkYwpbICAgIDMuNTQ3MDcwXSAgWzxjMWExZDY1NT5d
ID8ga3ZtX2FzeW5jX3BmX3Rhc2tfd2FrZSsweDMwLzB4ZGMKWyAgICAzLjU0NzA3MF0gIFs8
YzFhMWQ2NTU+XSA/IGt2bV9hc3luY19wZl90YXNrX3dha2UrMHgzMC8weGRjClsgICAgMy41
NDcwNzBdICBbPGMxYTFkNjU1Pl0gPyBrdm1fYXN5bmNfcGZfdGFza193YWtlKzB4MzAvMHhk
YwpbICAgIDMuNTQ3MDcwXSAgWzxjMWExZDY1NT5dID8ga3ZtX2FzeW5jX3BmX3Rhc2tfd2Fr
ZSsweDMwLzB4ZGMKWyAgICAzLjU0NzA3MF0gIFs8YzFhMWQ2NTU+XSA/IGt2bV9hc3luY19w
Zl90YXNrX3dha2UrMHgzMC8weGRjClsgICAgMy41NDcwNzBdICBbPGMxYTFkNjU1Pl0gPyBr
dm1fYXN5bmNfcGZfdGFza193YWtlKzB4MzAvMHhkYwpbICAgIDMuNTQ3MDcwXSAgWzxjMWEx
ZDY1NT5dID8ga3ZtX2FzeW5jX3BmX3Rhc2tfd2FrZSsweDMwLzB4ZGMKWyAgICAzLjU0NzA3
MF0gIFs8YzFhMWQ2NTU+XSA/IGt2bV9hc3luY19wZl90YXNrX3dha2UrMHgzMC8weGRjClsg
ICAgMy41NDcwNzBdICBbPGMxYTFkNjU1Pl0gPyBrdm1fYXN5bmNfcGZfdGFza193YWtlKzB4
MzAvMHhkYwpbICAgIDMuNTQ3MDcwXSAgWzxjMWExZDY1NT5dID8ga3ZtX2FzeW5jX3BmX3Rh
c2tfd2FrZSsweDMwLzB4ZGMKWyAgICAzLjU0NzA3MF0gIFs8YzFhMWQ2NTU+XSA/IGt2bV9h
c3luY19wZl90YXNrX3dha2UrMHgzMC8weGRjClsgICAgMy41NDcwNzBdICBbPGMxYTFkNjU1
Pl0gPyBrdm1fYXN5bmNfcGZfdGFza193YWtlKzB4MzAvMHhkYwpbICAgIDMuNTQ3MDcwXSAg
WzxjMWExZDY1NT5dID8ga3ZtX2FzeW5jX3BmX3Rhc2tfd2FrZSsweDMwLzB4ZGMKWyAgICAz
LjU0NzA3MF0gIFs8YzFhMWQ2NTU+XSA/IGt2bV9hc3luY19wZl90YXNrX3dha2UrMHgzMC8w
eGRjClsgICAgMy41NDcwNzBdICBbPGMxYTFkNjU1Pl0gPyBrdm1fYXN5bmNfcGZfdGFza193
YWtlKzB4MzAvMHhkYwpbICAgIDMuNTQ3MDcwXSAgWzxjMWExZDY1NT5dID8ga3ZtX2FzeW5j
X3BmX3Rhc2tfd2FrZSsweDMwLzB4ZGMKWyAgICAzLjU0NzA3MF0gIFs8YzFhMWQ2NTU+XSA/
IGt2bV9hc3luY19wZl90YXNrX3dha2UrMHgzMC8weGRjClsgICAgMy41NDcwNzBdIENvZGU6
IDAwIDAwIDAxIGYyIDc0IDA3IGU4IDI1IGYzIGZmIGZmIGViIDA5IDgwIDc4IGZmIDMwIDc1
IDAzIDQ4IGViIGY3IDVhIDU5IDViIDVlIDVmIDVkIGMzIDU1IDg5IGU1IDU3IDU2IDUzIDg5
IGMzIDgzIGVjIDY0IDhiIDdkIDEwIDw2NT4gOGIgMzUgMTQgMDAgMDAgMDAgODkgNzUgZjAg
MzEgZjYgOGIgNDUgMDggODkgNTUgYTggOGIgNTUgMGMKWyAgICAzLjU0NzA3MF0gRUlQOiBb
PGMxYjdmY2YxPl0gbnVtYmVyLmlzcmEuMisweGUvMHgyNTUgU1M6RVNQIDAwNjg6YzIyNTBk
ZTQKWyAgICAzLjU0NzA3MF0gLS0tWyBlbmQgdHJhY2UgNThmNTE2MTVkM2U0ZTdjMyBdLS0t
ClsgICAgMy41NDcwNzBdIG5vdGU6IHN3YXBwZXJbMV0gZXhpdGVkIHdpdGggcHJlZW1wdF9j
b3VudCAxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIxLTA0MDIvOWRjMGI2M2MwNDg0YTU3
ZmY0ZDExNjE5Zjg5ODZjYWFjODY2NDNhOC9kbWVzZy15b2N0by1yb2FtLTQ1OjIwMTQwNDAz
MjM0NzA5OmkzODYtcmFuZGNvbmZpZy1yMS0wNDAyOjMuMTQuMC0wMTAwMC1nOWRjMGI2Mzo0
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIxLTA0MDIvOWRjMGI2M2MwNDg0YTU3ZmY0ZDEx
NjE5Zjg5ODZjYWFjODY2NDNhOC9kbWVzZy15b2N0by1sa3AtaWIwNC00MjoyMDE0MDQwMzIz
NDcxNDppMzg2LXJhbmRjb25maWctcjEtMDQwMjozLjE0LjAtMDEwMDAtZzlkYzBiNjM6NAov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMS0wNDAyLzlkYzBiNjNjMDQ4NGE1N2ZmNGQxMTYx
OWY4OTg2Y2FhYzg2NjQzYTgvZG1lc2cteW9jdG8tbGtwLWliMDQtODg6MjAxNDA0MDMyMzQ3
MjQ6aTM4Ni1yYW5kY29uZmlnLXIxLTA0MDI6My4xNC4wLTAxMDAwLWc5ZGMwYjYzOjQKMDoz
OjQgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDQtMDMgMjM6NDc6
MzQgUkVQRUFUIENPVU5UOiAyMyAgIyAvY2Mvd2ZnL3N0YWJsZS1iaXNlY3QvLnJlcGVhdBtb
MG0KCmxpbmVhci1iaXNlY3Q6IGJhZCBicmFuY2ggbWF5IGJlIHZpcmVzaGsvdGltZXItY2xl
YW51cC1mb3ItdGdseApsaW5lYXItYmlzZWN0OiBoYW5kbGUgb3ZlciB0byBnaXQgYmlzZWN0
CmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3Qgc3RhcnQgOWRjMGI2M2MwNDg0YTU3ZmY0ZDEx
NjE5Zjg5ODZjYWFjODY2NDNhOCAyZmE0NDIwNjRkOGM2NGQxMTE0ZTU1YThlYTA3YWI2ODFk
NjkwNTgwIC0tClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDlkYzBiNjMuLi4gTWVyZ2Ug
J3ZpcmVzaGsvdGltZXItY2xlYW51cC1mb3ItdGdseCcgaW50byBkZXZlbC1yb2FtLWkzODYt
MjAxNDA0MDIxNzAzCkhFQUQgaXMgbm93IGF0IDUyMWNiNDAuLi4gTGludXggMi42LjM4CkJp
c2VjdGluZzogNDYgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDYgc3RlcHMpCltiOTdmMDI5MWEyNTA0MjkxYWVmODUwMDc3Zjk4Y2FiNjhhNWEyZjMzXSB0
aWNrOiBSZW1vdmUgY29kZSBkdXBsaWNhdGlvbiBpbiB0aWNrX2hhbmRsZV9wZXJpb2RpYygp
CmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3QgcnVuIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3N0YWJsZS9vYmotYmlzZWN0CnJ1bm5p
bmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93
Zmcvc3RhYmxlL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3Zt
L2kzODYtcmFuZGNvbmZpZy1yMS0wNDAyL2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0y
MDE0MDQwMjE3MDM6Yjk3ZjAyOTFhMjUwNDI5MWFlZjg1MDA3N2Y5OGNhYjY4YTVhMmYzMzpi
aXNlY3Qtc3RhYmxlCgoyMDE0LTA0LTAzLTIzOjQ4OjQ1IGI5N2YwMjkxYTI1MDQyOTFhZWY4
NTAwNzdmOThjYWI2OGE1YTJmMzMgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9r
ZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXIxLTA0MDItYjk3ZjAy
OTFhMjUwNDI5MWFlZjg1MDA3N2Y5OGNhYjY4YTVhMmYzMwpDaGVjayBmb3Iga2VybmVsIGlu
IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIxLTA0MDIvYjk3ZjAyOTFhMjUwNDI5MWFlZjg1
MDA3N2Y5OGNhYjY4YTVhMmYzMwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJuZWwt
dGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXIxLTA0MDItYjk3ZjAyOTFhMjUw
NDI5MWFlZjg1MDA3N2Y5OGNhYjY4YTVhMmYzMwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9m
IC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1yMS0wNDAyLWI5
N2YwMjkxYTI1MDQyOTFhZWY4NTAwNzdmOThjYWI2OGE1YTJmMzMKa2VybmVsOiAva2VybmVs
L2kzODYtcmFuZGNvbmZpZy1yMS0wNDAyL2I5N2YwMjkxYTI1MDQyOTFhZWY4NTAwNzdmOThj
YWI2OGE1YTJmMzMvdm1saW51ei0zLjE0LjAtcmMxLTAwMDQ2LWdiOTdmMDI5CgoyMDE0LTA0
LTA0LTAwOjA0OjQ2IGRldGVjdGluZyBib290IHN0YXRlIC4uLi4uLi4uLi4uLi4uLi4JMjMg
U1VDQ0VTUwoKQmlzZWN0aW5nOiAyMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgNSBzdGVwcykKW2ZlMDRlZjM3ZDk0OWVhOTJkYmMzNzE2NGVmZjExNmZl
M2M0YTA5MzBdIGhydGltZXI6IG1ha2UgZW5xdWV1ZV9ocnRpbWVyKCkgcmV0dXJuIHZvaWQK
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9o
b21lL3dmZy9zdGFibGUvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXIxLTA0MDIvbGludXgtZGV2ZWw6ZGV2ZWwtcm9hbS1p
Mzg2LTIwMTQwNDAyMTcwMzpmZTA0ZWYzN2Q5NDllYTkyZGJjMzcxNjRlZmYxMTZmZTNjNGEw
OTMwOmJpc2VjdC1zdGFibGUKCjIwMTQtMDQtMDQtMDA6MTM6MTcgZmUwNGVmMzdkOTQ5ZWE5
MmRiYzM3MTY0ZWZmMTE2ZmUzYzRhMDkzMCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sg
dG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctcjEtMDQwMi1m
ZTA0ZWYzN2Q5NDllYTkyZGJjMzcxNjRlZmYxMTZmZTNjNGEwOTMwCkNoZWNrIGZvciBrZXJu
ZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjEtMDQwMi9mZTA0ZWYzN2Q5NDllYTky
ZGJjMzcxNjRlZmYxMTZmZTNjNGEwOTMwCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tl
cm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctcjEtMDQwMi1mZTA0ZWYz
N2Q5NDllYTkyZGJjMzcxNjRlZmYxMTZmZTNjNGEwOTMwCndhaXRpbmcgZm9yIGNvbXBsZXRp
b24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLXIxLTA0
MDItZmUwNGVmMzdkOTQ5ZWE5MmRiYzM3MTY0ZWZmMTE2ZmUzYzRhMDkzMAprZXJuZWw6IC9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIxLTA0MDIvZmUwNGVmMzdkOTQ5ZWE5MmRiYzM3MTY0
ZWZmMTE2ZmUzYzRhMDkzMC92bWxpbnV6LTMuMTQuMC1yYzEtMDAwNjktZ2ZlMDRlZjMKCjIw
MTQtMDQtMDQtMDA6MjY6MTcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLgkxMgkyMyBTVUNDRVNTCgpCaXNlY3Rpbmc6IDExIHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA0IHN0ZXBzKQpbZGVhYjFiMjg1NzcyOGVl
OWQ5ODA3OGQyNTQ3ZmQ3YWIwMzBmZjUwOF0gaHJ0aW1lcjogY2FsbCBocnRpbWVyX2dldF9z
b2Z0aXJxX3RpbWUoKSBvbmx5IGlmIGNwdV9iYXNlLT5hY3RpdmVfYmFzZXMgaXMgc2V0CnJ1
bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9t
ZS93Zmcvc3RhYmxlL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUv
a3ZtL2kzODYtcmFuZGNvbmZpZy1yMS0wNDAyL2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4
Ni0yMDE0MDQwMjE3MDM6ZGVhYjFiMjg1NzcyOGVlOWQ5ODA3OGQyNTQ3ZmQ3YWIwMzBmZjUw
ODpiaXNlY3Qtc3RhYmxlCgoyMDE0LTA0LTA0LTAwOjM5OjQ5IGRlYWIxYjI4NTc3MjhlZTlk
OTgwNzhkMjU0N2ZkN2FiMDMwZmY1MDggY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRv
IC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXIxLTA0MDItZGVh
YjFiMjg1NzcyOGVlOWQ5ODA3OGQyNTQ3ZmQ3YWIwMzBmZjUwOApDaGVjayBmb3Iga2VybmVs
IGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIxLTA0MDIvZGVhYjFiMjg1NzcyOGVlOWQ5
ODA3OGQyNTQ3ZmQ3YWIwMzBmZjUwOAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rZXJu
ZWwtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXIxLTA0MDItZGVhYjFiMjg1
NzcyOGVlOWQ5ODA3OGQyNTQ3ZmQ3YWIwMzBmZjUwOAp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rZXJuZWwtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1yMS0wNDAy
LWRlYWIxYjI4NTc3MjhlZTlkOTgwNzhkMjU0N2ZkN2FiMDMwZmY1MDgKa2VybmVsOiAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1yMS0wNDAyL2RlYWIxYjI4NTc3MjhlZTlkOTgwNzhkMjU0
N2ZkN2FiMDMwZmY1MDgvdm1saW51ei0zLjE0LjAtcmMxLTAwMDgxLWdkZWFiMWIyCgoyMDE0
LTA0LTA0LTAwOjQ3OjQ5IGRldGVjdGluZyBib290IHN0YXRlIC4gVEVTVCBGQUlMVVJFClsg
ICAgMi4wMjA5ODBdIFBDSTogQ0xTIDAgYnl0ZXMsIGRlZmF1bHQgNjQKWyAgICAyLjAzOTc2
OV0gVW5wYWNraW5nIGluaXRyYW1mcy4uLgpbICAgIDMuOTAxNzcyXSBkZWJ1ZzogdW5tYXBw
aW5nIGluaXQgW21lbSAweGMzY2JkMDAwLTB4YzNmZWZmZmZdClsgICAgMy45MTAyMDBdIEJV
RzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0
IDAwMDAwMDNjClsgICAgMy45MTAyMDBdIElQOiBbPGIyMWVmMjI1Pl0gcmFwbF9wbXVfaW5p
dCsweGYxLzB4MTY2ClsgICAgMy45MTAyMDBdICpwZGUgPSAwMDAwMDAwMCAKWyAgICAzLjkx
MDIwMF0gT29wczogMDAwMCBbIzFdIERFQlVHX1BBR0VBTExPQwpbICAgIDMuOTEwMjAwXSBD
UFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xNC4wLXJjMS0wMDA4
MS1nZGVhYjFiMiAjNQpbICAgIDMuOTEwMjAwXSB0YXNrOiBjMjQ0MDAwMCB0aTogYzI0NDgw
MDAgdGFzay50aTogYzI0NDgwMDAKWyAgICAzLjkxMDIwMF0gRUlQOiAwMDYwOls8YjIxZWYy
MjU+XSBFRkxBR1M6IDAwMDAwMjQ2IENQVTogMApbICAgIDMuOTEwMjAwXSBFSVAgaXMgYXQg
cmFwbF9wbXVfaW5pdCsweGYxLzB4MTY2ClsgICAgMy45MTAyMDBdIEVBWDogMDAwMDAwMDAg
RUJYOiAwMDAwMDAwMCBFQ1g6IDAwMDAwMDAwIEVEWDogMDAwMDAwMDAKWyAgICAzLjkxMDIw
MF0gRVNJOiAwMDAwMDAwMCBFREk6IDAwMDAwMDAwIEVCUDogYzI0NDlmMzAgRVNQOiBjMjQ0
OWYxYwpbICAgIDMuOTEwMjAwXSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwMDAgR1M6IDAw
ZTAgU1M6IDAwNjgKWyAgICAzLjkxMDIwMF0gQ1IwOiA4MDA1MDAzYiBDUjI6IDAwMDAwMDNj
IENSMzogMDIyNDcwMDAgQ1I0OiAwMDMwMDY5MApbICAgIDMuOTEwMjAwXSBEUjA6IDAwMDAw
MDAwIERSMTogMDAwMDAwMDAgRFIyOiAwMDAwMDAwMCBEUjM6IDAwMDAwMDAwClsgICAgMy45
MTAyMDBdIERSNjogMDAwMDAwMDAgRFI3OiAwMDAwMDAwMApbICAgIDMuOTEwMjAwXSBTdGFj
azoKWyAgICAzLjkxMDIwMF0gIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIGIyMWVmMTM0
IGIyMjM4OTQ0IGMyNDQ5ZjkwIGIyMWU3YTc0IDAwMDAwMDAwClsgICAgMy45MTAyMDBdICBj
M2ZmNjdjYyBjMjQ0OWYwMCBiMjFlNzQ0MyBjM2ZmNjdiYiBiMWZkOGUxYyBjMjQ0OWY4MCBi
MWE0NzlhZSAwMDAwMDE4ZgpbICAgIDMuOTEwMjAwXSAgMDAwNjAwMDYgYjFmZDc1MWMgYzNm
ZjY3Y2QgMDAwMDAyMDAgYjFmZDhlMGMgYjFmYTUwZjYgMDAwMDAwMDYgMDAwMDAxOTAKWyAg
ICAzLjkxMDIwMF0gQ2FsbCBUcmFjZToKWyAgICAzLjkxMDIwMF0gIFs8YjIxZWYxMzQ+XSA/
IGludGVsX3VuY29yZV9pbml0KzB4MjUxLzB4MjUxClsgICAgMy45MTAyMDBdICBbPGIyMWU3
YTc0Pl0gZG9fb25lX2luaXRjYWxsKzB4NzcvMHgxMmUKWyAgICAzLjkxMDIwMF0gIFs8YjIx
ZTc0NDM+XSA/IHJlcGFpcl9lbnZfc3RyaW5nKzB4MTIvMHg1MQpbICAgIDMuOTEwMjAwXSAg
WzxiMWE0NzlhZT5dID8gcGFyc2VfYXJncysweDE3MS8weDIwYwpbICAgIDMuOTEwMjAwXSAg
WzxiMjFlN2NiNz5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MThjLzB4MjA0ClsgICAgMy45
MTAyMDBdICBbPGIxZGYxYTk4Pl0ga2VybmVsX2luaXQrMHhkLzB4ZGEKWyAgICAzLjkxMDIw
MF0gIFs8YjFkZmU3Nzc+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MWIvMHgyOApbICAg
IDMuOTEwMjAwXSAgWzxiMWRmMWE4Yj5dID8gcmVzdF9pbml0KzB4YTcvMHhhNwpbICAgIDMu
OTEwMjAwXSBDb2RlOiBjOCBmMyAxYiBiMiAwZiBiNiBmMyAzMSBjOSA4OSBmMiBlOCA1MSA0
YiA4YSBmZiA4NCBkYiA3NCA2MiBiYSA5MyAwMiAwMCAwMCBiOCA2MCA2NSBmNSBiMSBlOCA2
ZSBmNCA4MyBmZiBlYiA1MSA4YiAxZCA4MCAyMyBmZiBiMSA8OGI+IDQzIDNjIDhiIDUzIDQw
IGU4IDFiIDIwIDg0IGZmIGI5IGU4IDAzIDAwIDAwIDg5IGQ2IGY3IGU5IDg5ClsgICAgMy45
MTAyMDBdIEVJUDogWzxiMjFlZjIyNT5dIHJhcGxfcG11X2luaXQrMHhmMS8weDE2NiBTUzpF
U1AgMDA2ODpjMjQ0OWYxYwpbICAgIDMuOTEwMjAwXSBDUjI6IDAwMDAwMDAwMDAwMDAwM2MK
WyAgICAzLjkxMDIwMF0gLS0tWyBlbmQgdHJhY2UgNTZiMDVlNzY3NjUzMjc4NyBdLS0tClsg
ICAgMy45MTAyMDBdIHN3YXBwZXIgKDEpIHVzZWQgZ3JlYXRlc3Qgc3RhY2sgZGVwdGg6IDYz
MjggYnl0ZXMgbGVmdAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMS0wNDAyL2RlYWIxYjI4
NTc3MjhlZTlkOTgwNzhkMjU0N2ZkN2FiMDMwZmY1MDgvZG1lc2cteW9jdG8tZjEtMzU6MjAx
NDA0MDQwMDQ3MTg6aTM4Ni1yYW5kY29uZmlnLXIxLTA0MDI6My4xNC4wLXJjMS0wMDA4MS1n
ZGVhYjFiMjo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIxLTA0MDIvZGVhYjFiMjg1Nzcy
OGVlOWQ5ODA3OGQyNTQ3ZmQ3YWIwMzBmZjUwOC9kbWVzZy15b2N0by1sa3AtaWIwNC05MToy
MDE0MDQwNDAwNDczNjppMzg2LXJhbmRjb25maWctcjEtMDQwMjozLjE0LjAtcmMxLTAwMDgx
LWdkZWFiMWIyOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjEtMDQwMi9kZWFiMWIyODU3
NzI4ZWU5ZDk4MDc4ZDI1NDdmZDdhYjAzMGZmNTA4L2RtZXNnLXlvY3RvLXJvYW0tMzQ6MjAx
NDA0MDQwMDQ3MzU6aTM4Ni1yYW5kY29uZmlnLXIxLTA0MDI6My4xNC4wLXJjMS0wMDA4MS1n
ZGVhYjFiMjo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIxLTA0MDIvZGVhYjFiMjg1Nzcy
OGVlOWQ5ODA3OGQyNTQ3ZmQ3YWIwMzBmZjUwOC9kbWVzZy15b2N0by1sa3AtaWIwNC03NToy
MDE0MDQwNDAwNDc0OTppMzg2LXJhbmRjb25maWctcjEtMDQwMjozLjE0LjAtcmMxLTAwMDgx
LWdkZWFiMWIyOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjEtMDQwMi9kZWFiMWIyODU3
NzI4ZWU5ZDk4MDc4ZDI1NDdmZDdhYjAzMGZmNTA4L2RtZXNnLXlvY3RvLWxrcC1pYjA0LTM0
OjIwMTQwNDA0MDA0ODAxOmkzODYtcmFuZGNvbmZpZy1yMS0wNDAyOjMuMTQuMC1yYzEtMDAw
ODEtZ2RlYWIxYjI6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMS0wNDAyL2RlYWIxYjI4
NTc3MjhlZTlkOTgwNzhkMjU0N2ZkN2FiMDMwZmY1MDgvZG1lc2cteW9jdG8tbGtwLWliMDQt
ODM6MjAxNDA0MDQwMDQ4MDk6aTM4Ni1yYW5kY29uZmlnLXIxLTA0MDI6My4xNC4wLXJjMS0w
MDA4MS1nZGVhYjFiMjo1CjA6Njo2IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNl
Y3Rpbmc6IDUgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDMg
c3RlcHMpCltkY2RjZTM3ZWRjYWFjYzZmM2I0Y2MzZjFiOWE5YzJhNDU5YjBlZDliXSBocnRp
bWVyOiB1c2UgYmFzZS0+aHJlc19hY3RpdmUgZGlyZWN0bHkgaW5zdGVhZCBvZiBocnRpbWVy
X2hyZXNfYWN0aXZlKCkKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9ob21lL3dmZy9zdGFibGUvb2JqLWJpc2VjdApscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXIxLTA0MDIvbGludXgtZGV2
ZWw6ZGV2ZWwtcm9hbS1pMzg2LTIwMTQwNDAyMTcwMzpkY2RjZTM3ZWRjYWFjYzZmM2I0Y2Mz
ZjFiOWE5YzJhNDU5YjBlZDliOmJpc2VjdC1zdGFibGUKCjIwMTQtMDQtMDQtMDA6NDg6MjIg
ZGNkY2UzN2VkY2FhY2M2ZjNiNGNjM2YxYjlhOWMyYTQ1OWIwZWQ5YiBjb21waWxpbmcKUXVl
dWVkIGJ1aWxkIHRhc2sgdG8gL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRj
b25maWctcjEtMDQwMi1kY2RjZTM3ZWRjYWFjYzZmM2I0Y2MzZjFiOWE5YzJhNDU5YjBlZDli
CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjEtMDQwMi9k
Y2RjZTM3ZWRjYWFjYzZmM2I0Y2MzZjFiOWE5YzJhNDU5YjBlZDliCndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWct
cjEtMDQwMi1kY2RjZTM3ZWRjYWFjYzZmM2I0Y2MzZjFiOWE5YzJhNDU5YjBlZDliCndhaXRp
bmcgZm9yIGNvbXBsZXRpb24gb2YgL2tlcm5lbC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1y
YW5kY29uZmlnLXIxLTA0MDItZGNkY2UzN2VkY2FhY2M2ZjNiNGNjM2YxYjlhOWMyYTQ1OWIw
ZWQ5YgprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIxLTA0MDIvZGNkY2UzN2Vk
Y2FhY2M2ZjNiNGNjM2YxYjlhOWMyYTQ1OWIwZWQ5Yi92bWxpbnV6LTMuMTQuMC1yYzEtMDAw
NzUtZ2RjZGNlMzcKCjIwMTQtMDQtMDQtMDA6NTE6MjIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
Li4uLi4uLgkyCTEyCTIxCTIyLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkyMyBTVUNDRVNTCgpCaXNlY3Rpbmc6IDIg
cmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDIgc3RlcHMpCltj
YTk5NDliYWMxYTdlNTRiZjdmODMyZTBmZmZmZGFhZmFjOGVhNWM1XSBocnRpbWVyOiByZXBs
YWNlIHNpemVvZihzdHJ1Y3QgaHJ0aW1lcikgd2l0aCBzaXplb2YoKnRpbWVyKQpydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2Zn
L3N0YWJsZS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9p
Mzg2LXJhbmRjb25maWctcjEtMDQwMi9saW51eC1kZXZlbDpkZXZlbC1yb2FtLWkzODYtMjAx
NDA0MDIxNzAzOmNhOTk0OWJhYzFhN2U1NGJmN2Y4MzJlMGZmZmZkYWFmYWM4ZWE1YzU6Ymlz
ZWN0LXN0YWJsZQoKMjAxNC0wNC0wNC0wMTo1NjoyOSBjYTk5NDliYWMxYTdlNTRiZjdmODMy
ZTBmZmZmZGFhZmFjOGVhNWM1IHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIxLTA0
MDIvY2E5OTQ5YmFjMWE3ZTU0YmY3ZjgzMmUwZmZmZmRhYWZhYzhlYTVjNS92bWxpbnV6LTMu
MTQuMC1yYzEtMDAwNzgtZ2NhOTk0OWIKCjIwMTQtMDQtMDQtMDE6NTY6MjkgZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgLi4JMTUJMjIuLi4uLi4uLi4uLi4uLi4uLgkyMyBTVUNDRVNTCgpCaXNl
Y3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEg
c3RlcCkKWzMzNmNhMTk2NzM4ODQyNzY0ZGYzOWZiZDRkM2Y5MTI5MTc5YjNlN2RdIGhydGlt
ZXI6IFVzZSBmb3JfZWFjaF9hY3RpdmVfYmFzZSgpIHRvIGl0ZXJhdGUgb3ZlciBhY3RpdmUg
Y2xvY2sgYmFzZXMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9ob21lL3dmZy9zdGFibGUvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXIxLTA0MDIvbGludXgtZGV2ZWw6
ZGV2ZWwtcm9hbS1pMzg2LTIwMTQwNDAyMTcwMzozMzZjYTE5NjczODg0Mjc2NGRmMzlmYmQ0
ZDNmOTEyOTE3OWIzZTdkOmJpc2VjdC1zdGFibGUKIFRFU1QgRkFJTFVSRQp1ZGV2ZFsxNzRd
OiBlcnJvciBpbml0aWFsaXppbmcgaW5vdGlmeQp1ZGV2ZFsxNzZdOiBpbm90aWZ5X2luaXQg
ZmFpbGVkOiBGdW5jdGlvbiBub3QgaW1wbGVtZW50ZWQKdWRldmRbMTc2XTogZXJyb3IgaW5p
dGlhbGl6aW5nIGlub3RpZnkKWyAgIDY0LjU1NzkwM10gSVA6IFs8YjEwNGI3Nzg+XSBocnRp
bWVyX2ZvcmNlX3JlcHJvZ3JhbSsweDNkLzB4YjEKWyAgIDY0LjU1ODU4NV0gKnBkZSA9IDAw
MDAwMDAwIApbICAgNjQuNTU4OTAxXSBPb3BzOiAwMDAwIFsjMV0gREVCVUdfUEFHRUFMTE9D
ClsgICA2NC41NTk0MDNdIENQVTogMCBQSUQ6IDAgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRl
ZCAzLjE0LjAtcmMxLTAwMDgwLWczMzZjYTE5ICM5ClsgICA2NC41NjAxODBdIHRhc2s6IGIx
NWU1NTM0IHRpOiBiMTVkYTAwMCB0YXNrLnRpOiBiMTVkYTAwMApbICAgNjQuNTYwMzI5XSBF
SVA6IDAwNjA6WzxiMTA0Yjc3OD5dIEVGTEFHUzogMDAyMTAwMDIgQ1BVOiAwClsgICA2NC41
NjAzMjldIEVJUCBpcyBhdCBocnRpbWVyX2ZvcmNlX3JlcHJvZ3JhbSsweDNkLzB4YjEKWyAg
IDY0LjU2MDMyOV0gRUFYOiBiMTVmYWY1NCBFQlg6IDAwMDAwMDMwIEVDWDogMDAwMDAwMDAg
RURYOiA3ZmZmZmZmZgpbICAgNjQuNTYwMzI5XSBFU0k6IGZmZmZmZmZmIEVESTogYjE1ZmFm
ZDggRUJQOiBiMTVkYmY0OCBFU1A6IGIxNWRiZjMwClsgICA2NC41NjAzMjldICBEUzogMDA3
YiBFUzogMDA3YiBGUzogMDAwMCBHUzogMDBlMCBTUzogMDA2OApbICAgNjQuNTYwMzI5XSBD
UjA6IDgwMDUwMDNiIENSMjogMDAwMDAwMTAgQ1IzOiAwNzc4YTAwMCBDUjQ6IDAwMDAwNjkw
ClsgICA2NC41NjAzMjldIFN0YWNrOgpbICAgNjQuNTYwMzI5XSAgMDAwMDAwMDAgMDAwMDAw
MDEgMDAwMDAwMDEgMDAwMDAwMGYgYjE3M2YxN2MgYjE1ZmFmYTggYjE1ZGJmNjQgYjEwNGI4
NDUKWyAgIDY0LjU2MDMyOV0gIDAwMDAwMDAwIGIxNzNmMTdjIGIxNzNmMTdjIDAwMDAwMDAx
IDAwMjAwMDQ2IGIxNWRiZjc4IGIxMDRjMTUzIGIxNzNmMTdjClsgICA2NC41NjAzMjldICAw
MDAwMDAwZiAwMDAwMDAwZiBiMTVkYmY4NCBiMTA0YzE5ZSAwN2U2NjdlOCBiMTVkYmZhMCBi
MTA3NzFmMCAwN2U2NjdlOApbICAgNjQuNTYwMzI5XSBDYWxsIFRyYWNlOgpbICAgNjQuNTYw
MzI5XSAgWzxiMTA0Yjg0NT5dIF9fcmVtb3ZlX2hydGltZXIrMHg1OS8weDdiClsgICA2NC41
NjAzMjldICBbPGIxMDRjMTUzPl0gaHJ0aW1lcl90cnlfdG9fY2FuY2VsKzB4N2IvMHhiNApb
ICAgNjQuNTYwMzI5XSAgWzxiMTA0YzE5ZT5dIGhydGltZXJfY2FuY2VsKzB4MTIvMHgxZApb
ICAgNjQuNTYwMzI5XSAgWzxiMTA3NzFmMD5dIHRpY2tfbm9oel9pZGxlX2V4aXQrMHgxMjkv
MHgxZjEKWyAgIDY0LjU2MDMyOV0gIFs8YjEwNjdiMDc+XSBjcHVfc3RhcnR1cF9lbnRyeSsw
eDFmYS8weDI5MApbICAgNjQuNTYwMzI5XSAgWzxiMTNmMWE5Nj5dIHJlc3RfaW5pdCsweGEy
LzB4YTcKWyAgIDY0LjU2MDMyOV0gIFs8YjE3ZTc5ZjY+XSBzdGFydF9rZXJuZWwrMHgzYmUv
MHgzYzUKWyAgIDY0LjU2MDMyOV0gIFs8YjE3ZTcyYzM+XSBpMzg2X3N0YXJ0X2tlcm5lbCsw
eDc5LzB4N2QKWyAgIDY0LjU2MDMyOV0gQ29kZTogNTUgZWMgYmEgZmYgZmYgZmYgN2YgODkg
NzUgZjAgODMgY2UgZmYgODMgY2IgZmYgMGYgYmMgN2QgZjAgMGYgNDQgZmIgOGQgNGYgMDEg
NmIgZDkgMzAgODUgYzkgODkgN2QgZTggOGQgN2MgMTggNTQgNzQgMzggOGIgNGYgZTAgPDhi
PiA1OSAxMCA4YiA0OSAwYyAyYiA0ZiBmOCAxYiA1ZiBmYyA4NSBkYiA3OSAwNCAzMSBjOSAz
MSBkYiAzOQpbICAgNjQuNTYwMzI5XSBFSVA6IFs8YjEwNGI3Nzg+XSBocnRpbWVyX2ZvcmNl
X3JlcHJvZ3JhbSsweDNkLzB4YjEgU1M6RVNQIDAwNjg6YjE1ZGJmMzAKWyAgIDY0LjU2MDMy
OV0gQ1IyOiAwMDAwMDAwMDAwMDAwMDEwClsgICA2NC41NjAzMjldIC0tLVsgZW5kIHRyYWNl
IGM0YzljMjE4YTViMmY2NmMgXS0tLQpbICAgNjQuNTYwMzI5XSBLZXJuZWwgcGFuaWMgLSBu
b3Qgc3luY2luZzogQXR0ZW1wdGVkIHRvIGtpbGwgdGhlIGlkbGUgdGFzayEKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctcjEtMDQwMi8zMzZjYTE5NjczODg0Mjc2NGRmMzlmYmQ0ZDNmOTEy
OTE3OWIzZTdkL2RtZXNnLXlvY3RvLWxrcC1pYjA0LTk6MjAxNDA0MDQwMTU3Mjk6aTM4Ni1y
YW5kY29uZmlnLXIxLTA0MDI6My4xNC4wLXJjMS0wMDA4MC1nMzM2Y2ExOTo5Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXIxLTA0MDIvMzM2Y2ExOTY3Mzg4NDI3NjRkZjM5ZmJkNGQzZjkx
MjkxNzliM2U3ZC9kbWVzZy1xdWFudGFsLWpha2V0b3duLTMyOjIwMTQwNDA0MDE1ODQzOmkz
ODYtcmFuZGNvbmZpZy1yMS0wNDAyOjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjEtMDQw
Mi8zMzZjYTE5NjczODg0Mjc2NGRmMzlmYmQ0ZDNmOTEyOTE3OWIzZTdkL2RtZXNnLXlvY3Rv
LWxrcC1pYjA0LTU6MjAxNDA0MDQwMTU3MzE6aTM4Ni1yYW5kY29uZmlnLXIxLTA0MDI6My4x
NC4wLXJjMS0wMDA4MC1nMzM2Y2ExOTo5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIxLTA0
MDIvMzM2Y2ExOTY3Mzg4NDI3NjRkZjM5ZmJkNGQzZjkxMjkxNzliM2U3ZC9kbWVzZy15b2N0
by1sa3AtaWIwNC01NToyMDE0MDQwNDAxNTcyNDppMzg2LXJhbmRjb25maWctcjEtMDQwMjoz
LjE0LjAtcmMxLTAwMDgwLWczMzZjYTE5OjkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjEt
MDQwMi8zMzZjYTE5NjczODg0Mjc2NGRmMzlmYmQ0ZDNmOTEyOTE3OWIzZTdkL2RtZXNnLXlv
Y3RvLWlubi0yNToyMDE0MDQwNDAxNTczMjppMzg2LXJhbmRjb25maWctcjEtMDQwMjo6Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIxLTA0MDIvMzM2Y2ExOTY3Mzg4NDI3NjRkZjM5ZmJk
NGQzZjkxMjkxNzliM2U3ZC9kbWVzZy15b2N0by1sa3AtaWIwNC05OjIwMTQwNDA0MDE1NzE5
OmkzODYtcmFuZGNvbmZpZy1yMS0wNDAyOjMuMTQuMC1yYzEtMDAwODAtZzMzNmNhMTk6OQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMS0wNDAyLzMzNmNhMTk2NzM4ODQyNzY0ZGYzOWZi
ZDRkM2Y5MTI5MTc5YjNlN2QvZG1lc2cteW9jdG8tcm9hbS00NToyMDE0MDQwNDAxNTcxOTpp
Mzg2LXJhbmRjb25maWctcjEtMDQwMjozLjE0LjAtcmMxLTAwMDgwLWczMzZjYTE5OjkKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctcjEtMDQwMi8zMzZjYTE5NjczODg0Mjc2NGRmMzlmYmQ0
ZDNmOTEyOTE3OWIzZTdkL2RtZXNnLXlvY3RvLWpha2V0b3duLTU6MjAxNDA0MDQwMTU3Mzk6
aTM4Ni1yYW5kY29uZmlnLXIxLTA0MDI6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMS0w
NDAyLzMzNmNhMTk2NzM4ODQyNzY0ZGYzOWZiZDRkM2Y5MTI5MTc5YjNlN2QvZG1lc2ctcXVh
bnRhbC1qYWtldG93bi0xOToyMDE0MDQwNDAxNTg1MTppMzg2LXJhbmRjb25maWctcjEtMDQw
Mjo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIxLTA0MDIvMzM2Y2ExOTY3Mzg4NDI3NjRk
ZjM5ZmJkNGQzZjkxMjkxNzliM2U3ZC9kbWVzZy15b2N0by1sa3AtaWIwNC05MDoyMDE0MDQw
NDAxNTczNDppMzg2LXJhbmRjb25maWctcjEtMDQwMjozLjE0LjAtcmMxLTAwMDgwLWczMzZj
YTE5OjkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjEtMDQwMi8zMzZjYTE5NjczODg0Mjc2
NGRmMzlmYmQ0ZDNmOTEyOTE3OWIzZTdkL2RtZXNnLXlvY3RvLWxrcC1pYjA0LTU6MjAxNDA0
MDQwMTU3MjE6aTM4Ni1yYW5kY29uZmlnLXIxLTA0MDI6My4xNC4wLXJjMS0wMDA4MC1nMzM2
Y2ExOTo5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIxLTA0MDIvMzM2Y2ExOTY3Mzg4NDI3
NjRkZjM5ZmJkNGQzZjkxMjkxNzliM2U3ZC9kbWVzZy15b2N0by1sa3AtaWIwNC03MzoyMDE0
MDQwNDAxNTcyNzppMzg2LXJhbmRjb25maWctcjEtMDQwMjozLjE0LjAtcmMxLTAwMDgwLWcz
MzZjYTE5OjkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjEtMDQwMi8zMzZjYTE5NjczODg0
Mjc2NGRmMzlmYmQ0ZDNmOTEyOTE3OWIzZTdkL2RtZXNnLXlvY3RvLWxrcC1pYjA0LTU1OjIw
MTQwNDA0MDE1NzM0OmkzODYtcmFuZGNvbmZpZy1yMS0wNDAyOjMuMTQuMC1yYzEtMDAwODAt
ZzMzNmNhMTk6OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMS0wNDAyLzMzNmNhMTk2NzM4
ODQyNzY0ZGYzOWZiZDRkM2Y5MTI5MTc5YjNlN2QvZG1lc2cteW9jdG8tamFrZXRvd24tMTk6
MjAxNDA0MDQwMTU3NDA6aTM4Ni1yYW5kY29uZmlnLXIxLTA0MDI6Ogova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1yMS0wNDAyLzMzNmNhMTk2NzM4ODQyNzY0ZGYzOWZiZDRkM2Y5MTI5MTc5
YjNlN2QvZG1lc2cteW9jdG8tcm9hbS00NToyMDE0MDQwNDAxNTczMDppMzg2LXJhbmRjb25m
aWctcjEtMDQwMjozLjE0LjAtcmMxLTAwMDgwLWczMzZjYTE5OjkKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctcjEtMDQwMi8zMzZjYTE5NjczODg0Mjc2NGRmMzlmYmQ0ZDNmOTEyOTE3OWIz
ZTdkL2RtZXNnLXlvY3RvLWlubi0yNToyMDE0MDQwNDAxNTcyMTppMzg2LXJhbmRjb25maWct
cjEtMDQwMjo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIxLTA0MDIvMzM2Y2ExOTY3Mzg4
NDI3NjRkZjM5ZmJkNGQzZjkxMjkxNzliM2U3ZC9kbWVzZy1xdWFudGFsLWlubi0yOjIwMTQw
NDA0MDE1ODIyOmkzODYtcmFuZGNvbmZpZy1yMS0wNDAyOjoKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctcjEtMDQwMi8zMzZjYTE5NjczODg0Mjc2NGRmMzlmYmQ0ZDNmOTEyOTE3OWIzZTdk
L2RtZXNnLXlvY3RvLWpha2V0b3duLTQyOjIwMTQwNDA0MDE1NzI4OmkzODYtcmFuZGNvbmZp
Zy1yMS0wNDAyOjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjEtMDQwMi8zMzZjYTE5Njcz
ODg0Mjc2NGRmMzlmYmQ0ZDNmOTEyOTE3OWIzZTdkL2RtZXNnLXlvY3RvLXJvYW0tNDM6MjAx
NDA0MDQwMTU3MzI6aTM4Ni1yYW5kY29uZmlnLXIxLTA0MDI6My4xNC4wLXJjMS0wMDA4MC1n
MzM2Y2ExOTo5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIxLTA0MDIvMzM2Y2ExOTY3Mzg4
NDI3NjRkZjM5ZmJkNGQzZjkxMjkxNzliM2U3ZC9kbWVzZy15b2N0by1qYWtldG93bi0yOjIw
MTQwNDA0MDE1NzQxOmkzODYtcmFuZGNvbmZpZy1yMS0wNDAyOjoKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctcjEtMDQwMi8zMzZjYTE5NjczODg0Mjc2NGRmMzlmYmQ0ZDNmOTEyOTE3OWIz
ZTdkL2RtZXNnLXF1YW50YWwtaW5uLTI3OjIwMTQwNDA0MDE1ODI0OmkzODYtcmFuZGNvbmZp
Zy1yMS0wNDAyOjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjEtMDQwMi8zMzZjYTE5Njcz
ODg0Mjc2NGRmMzlmYmQ0ZDNmOTEyOTE3OWIzZTdkL2RtZXNnLXF1YW50YWwtamFrZXRvd24t
MTc6MjAxNDA0MDQwMTU4NDY6aTM4Ni1yYW5kY29uZmlnLXIxLTA0MDI6Ogova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1yMS0wNDAyLzMzNmNhMTk2NzM4ODQyNzY0ZGYzOWZiZDRkM2Y5MTI5
MTc5YjNlN2QvZG1lc2cteW9jdG8tamFrZXRvd24tMzQ6MjAxNDA0MDQwMTU3NDA6aTM4Ni1y
YW5kY29uZmlnLXIxLTA0MDI6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMS0wNDAyLzMz
NmNhMTk2NzM4ODQyNzY0ZGYzOWZiZDRkM2Y5MTI5MTc5YjNlN2QvZG1lc2ctcXVhbnRhbC1q
YWtldG93bi0xNjoyMDE0MDQwNDAxNTgzOTppMzg2LXJhbmRjb25maWctcjEtMDQwMjo6Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIxLTA0MDIvMzM2Y2ExOTY3Mzg4NDI3NjRkZjM5ZmJk
NGQzZjkxMjkxNzliM2U3ZC9kbWVzZy15b2N0by1sa3AtaWIwNC02MjoyMDE0MDQwNDAxNTcz
NDppMzg2LXJhbmRjb25maWctcjEtMDQwMjozLjE0LjAtcmMxLTAwMDgwLWczMzZjYTE5OjkK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjEtMDQwMi8zMzZjYTE5NjczODg0Mjc2NGRmMzlm
YmQ0ZDNmOTEyOTE3OWIzZTdkL2RtZXNnLXlvY3RvLWxrcC1pYjA0LTczOjIwMTQwNDA0MDE1
NzE3OmkzODYtcmFuZGNvbmZpZy1yMS0wNDAyOjMuMTQuMC1yYzEtMDAwODAtZzMzNmNhMTk6
OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMS0wNDAyLzMzNmNhMTk2NzM4ODQyNzY0ZGYz
OWZiZDRkM2Y5MTI5MTc5YjNlN2QvZG1lc2cteW9jdG8taW5uLTE1OjIwMTQwNDA0MDE1NzMz
OmkzODYtcmFuZGNvbmZpZy1yMS0wNDAyOjoKMToyNzoyOCBhbGxfZ29vZDpiYWQ6YWxsX2Jh
ZCBib290cwoKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSAwIHN0ZXBzKQpbZjJjMjM0NWQ5NWZkNDQ2MzNhMTM1NmJhZDI1OTE5ODY3
MzE5MmUyMV0gaHJ0aW1lcjogY3JlYXRlIGZvcl9lYWNoX2FjdGl2ZV9iYXNlKCkKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dm
Zy9zdGFibGUvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
aTM4Ni1yYW5kY29uZmlnLXIxLTA0MDIvbGludXgtZGV2ZWw6ZGV2ZWwtcm9hbS1pMzg2LTIw
MTQwNDAyMTcwMzpmMmMyMzQ1ZDk1ZmQ0NDYzM2ExMzU2YmFkMjU5MTk4NjczMTkyZTIxOmJp
c2VjdC1zdGFibGUKCjIwMTQtMDQtMDQtMDI6MDc6MzMgZjJjMjM0NWQ5NWZkNDQ2MzNhMTM1
NmJhZDI1OTE5ODY3MzE5MmUyMSByZXVzZSAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMS0w
NDAyL2YyYzIzNDVkOTVmZDQ0NjMzYTEzNTZiYWQyNTkxOTg2NzMxOTJlMjEvdm1saW51ei0z
LjE0LjAtcmMxLTAwMDc5LWdmMmMyMzQ1CgoyMDE0LTA0LTA0LTAyOjA3OjMzIGRldGVjdGlu
ZyBib290IHN0YXRlIC4uLgkxMwkxNC4uLi4uLi4uLi4JMTkJMjAuLi4uLgkyMS4uLi4uLi4u
Li4uCTIyLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgky
MyBTVUNDRVNTCgozMzZjYTE5NjczODg0Mjc2NGRmMzlmYmQ0ZDNmOTEyOTE3OWIzZTdkIGlz
IHRoZSBmaXJzdCBiYWQgY29tbWl0CmNvbW1pdCAzMzZjYTE5NjczODg0Mjc2NGRmMzlmYmQ0
ZDNmOTEyOTE3OWIzZTdkCkF1dGhvcjogVmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGlu
YXJvLm9yZz4KRGF0ZTogICBNb24gTWFyIDMxIDEyOjMzOjIxIDIwMTQgKzA1MzAKCiAgICBo
cnRpbWVyOiBVc2UgZm9yX2VhY2hfYWN0aXZlX2Jhc2UoKSB0byBpdGVyYXRlIG92ZXIgYWN0
aXZlIGNsb2NrIGJhc2VzCiAgICAKICAgIFRoZXJlIGFyZSB2YXJpb3VzIHBsYWNlcyB3aGVy
ZSB3ZSBhcmUgY3VycmVudGx5IHJ1bm5pbmcgYSBsb29wIG9mCiAgICBIUlRJTUVSX01BWF9D
TE9DS19CQVNFUyBpdGVyYXRpb25zLiBXZSBqdXN0IHJ1biAnY29udGludWU7JyBpZiB0aGVy
ZSBhcmUgbm8KICAgIHRpbWVycyBhZGRlZCB0byBhIGNsb2NrIGJhc2UuIEluc3RlYWQgd2Ug
Y2FuIHVzZSB0aGUgbmV3IGZvcl9lYWNoX2FjdGl2ZV9iYXNlKCkKICAgIHJvdXRpbmUgdG8g
aXRlcmF0ZSBvdmVyIG9ubHkgdGhlIGJhc2VzIHdoaWNoIGFyZSBjdXJyZW50bHkgYWN0aXZl
LgogICAgCiAgICBUaGlzIGFsc28gdXBkYXRlcyBocnRpbWVyX2ludGVycnVwdCgpIHdoaWNo
IHdhcyBlYXJsaWVyIG1vZGlmaWVkIHRvIHVzZQogICAgZmZzKGFjdGl2ZV9iYXNlcykgZGly
ZWN0bHkuCiAgICAKICAgIFNpZ25lZC1vZmYtYnk6IFZpcmVzaCBLdW1hciA8dmlyZXNoLmt1
bWFyQGxpbmFyby5vcmc+Cgo6MDQwMDAwIDA0MDAwMCAwYjY3ODA1MzRkM2I1YWFkZDBiMzdk
YjBlZTcyNjczNmZmMTFhMjllIGE2MDQ3ZGE5NGQ0OWQzZDNiNjk2MDMxNzA2ZTJjZTYxNzU1
MTZhZjIgTQlrZXJuZWwKYmlzZWN0IHJ1biBzdWNjZXNzCkhFQUQgaXMgbm93IGF0IGYyYzIz
NDUuLi4gaHJ0aW1lcjogY3JlYXRlIGZvcl9lYWNoX2FjdGl2ZV9iYXNlKCkKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yMS0wNDAyL2xpbnV4
LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0MDQwMjE3MDM6ZjJjMjM0NWQ5NWZkNDQ2MzNh
MTM1NmJhZDI1OTE5ODY3MzE5MmUyMTpiaXNlY3Qtc3RhYmxlCgoyMDE0LTA0LTA0LTAzOjE1
OjQxIGYyYzIzNDVkOTVmZDQ0NjMzYTEzNTZiYWQyNTkxOTg2NzMxOTJlMjEgcmV1c2UgL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctcjEtMDQwMi9mMmMyMzQ1ZDk1ZmQ0NDYzM2ExMzU2YmFk
MjU5MTk4NjczMTkyZTIxL3ZtbGludXotMy4xNC4wLXJjMS0wMDA3OS1nZjJjMjM0NQoKMjAx
NC0wNC0wNC0wMzoxNTo0MSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgkxCTIJMwk1CTguCTku
CTEwCTExCTEyCTEzCTE1CTE3CTE4Li4JMjAJMjIJMjUJMjYJMjguCTI5CTM0CTM2CTQwCTQy
Lgk0NAk0NS4JNDYJNDcJNTEJNTIJNTMJNTQuLi4uLi4uLi4JNTUJNTguLi4JNTkuLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4JNjAJNjEuLi4uLi4uLi4uLi4uLi4uLgk2Mi4uLgk2My4JNjQuLi4JNjUuCTY3
Lgk2OAk2OSBTVUNDRVNTCgpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBmMmMyMzQ1Li4u
IGhydGltZXI6IGNyZWF0ZSBmb3JfZWFjaF9hY3RpdmVfYmFzZSgpCkhFQUQgaXMgbm93IGF0
IGIwZTMzYzMuLi4gMGRheSBoZWFkIGd1YXJkIGZvciAnZGV2ZWwtcm9hbS1pMzg2LTIwMTQw
NDAyMTcwMycKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNv
bmZpZy1yMS0wNDAyL2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0MDQwMjE3MDM6
YjBlMzNjMzRlMjNjN2Y4ZWRlMmYxOWQ5OTI2Mjg4MDIzMDhjM2FmYzpiaXNlY3Qtc3RhYmxl
CiBURVNUIEZBSUxVUkUKQlVHOiBrZXJuZWwgZWFybHkgaGFuZyB3aXRob3V0IGFueSBwcmlu
dGsgb3V0cHV0CkNvbW1hbmQgbGluZTogaHVuZ190YXNrX3BhbmljPTEgZWFybHlwcmludGs9
dHR5UzAsMTE1MjAwIGRlYnVnIGFwaWM9ZGVidWcgc3lzcnFfYWx3YXlzX2VuYWJsZWQgcmN1
cGRhdGUucmN1X2NwdV9zdGFsbF90aW1lb3V0PTEwMCBwYW5pYz0xMCBzb2Z0bG9ja3VwX3Bh
bmljPTEgbm1pX3dhdGNoZG9nPXBhbmljICBwcm9tcHRfcmFtZGlzaz0wIGNvbnNvbGU9dHR5
UzAsMTE1MjAwIGNvbnNvbGU9dHR5MCB2Z2E9bm9ybWFsICByb290PS9kZXYvcmFtMCBydyBs
aW5rPS9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctcjEtMDQw
Mi9saW51eC1kZXZlbDpkZXZlbC1yb2FtLWkzODYtMjAxNDA0MDIxNzAzLy52bWxpbnV6LWIw
ZTMzYzM0ZTIzYzdmOGVkZTJmMTlkOTkyNjI4ODAyMzA4YzNhZmMtMjAxNDA0MDIxNzEwMDUt
MS1icmlja2xhbmQxIGJyYW5jaD1saW51eC1kZXZlbC9kZXZlbC1yb2FtLWkzODYtMjAxNDA0
MDIxNzAzIEJPT1RfSU1BR0U9L2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjEtMDQwMi9iMGUz
M2MzNGUyM2M3ZjhlZGUyZjE5ZDk5MjYyODgwMjMwOGMzYWZjL3ZtbGludXotMy4xNC4wLTAx
MDAxLWdiMGUzM2MzIGRyYmQubWlub3JfY291bnQ9OApFYXJseSBoYW5nIGtlcm5lbDogdm1s
aW51ei0zLjE0LjAtMDEwMDEtZ2IwZTMzYzMgICMKRWxhcHNlZCB0aW1lOiAzNQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1yMS0wNDAyL2IwZTMzYzM0ZTIzYzdmOGVkZTJmMTlkOTkyNjI4
ODAyMzA4YzNhZmMvZG1lc2cteW9jdG8tYXRoZW5zLTM6MjAxNDA0MDQwMTE4NDk6aTM4Ni1y
YW5kY29uZmlnLXIxLTA0MDI6My4xNC4wLTAxMDAxLWdiMGUzM2MzOjE0NQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1yMS0wNDAyL2IwZTMzYzM0ZTIzYzdmOGVkZTJmMTlkOTkyNjI4ODAy
MzA4YzNhZmMvZG1lc2cteW9jdG8taW5uLTMxOjIwMTQwNDA0MDExOTA3OmkzODYtcmFuZGNv
bmZpZy1yMS0wNDAyOjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjEtMDQwMi9iMGUzM2Mz
NGUyM2M3ZjhlZGUyZjE5ZDk5MjYyODgwMjMwOGMzYWZjL2RtZXNnLXlvY3RvLWxrcC1pYjA0
LTQxOjIwMTQwNDAzMjIzMjExOmkzODYtcmFuZGNvbmZpZy1yMS0wNDAyOjMuMTQuMC0wMTAw
MS1nYjBlMzNjMzoxNDUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjEtMDQwMi9iMGUzM2Mz
NGUyM2M3ZjhlZGUyZjE5ZDk5MjYyODgwMjMwOGMzYWZjL2RtZXNnLXF1YW50YWwtaW5uLTI0
OjIwMTQwNDA0MDEyMDEwOmkzODYtcmFuZGNvbmZpZy1yMS0wNDAyOjoKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctcjEtMDQwMi9iMGUzM2MzNGUyM2M3ZjhlZGUyZjE5ZDk5MjYyODgwMjMw
OGMzYWZjL2RtZXNnLXlvY3RvLWlubi0yMDoyMDE0MDQwMjIzMTUwMDppMzg2LXJhbmRjb25m
aWctcjEtMDQwMjo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIxLTA0MDIvYjBlMzNjMzRl
MjNjN2Y4ZWRlMmYxOWQ5OTI2Mjg4MDIzMDhjM2FmYy9kbWVzZy15b2N0by14aWFuLTY6MjAx
NDA0MDMyMjMxMjI6aTM4Ni1yYW5kY29uZmlnLXIxLTA0MDI6My4xNC4wLTAxMDAxLWdiMGUz
M2MzOjE0NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMS0wNDAyL2IwZTMzYzM0ZTIzYzdm
OGVkZTJmMTlkOTkyNjI4ODAyMzA4YzNhZmMvZG1lc2cteW9jdG8tYXRoZW5zLTIyOjIwMTQw
NDA0MDExODQwOmkzODYtcmFuZGNvbmZpZy1yMS0wNDAyOjMuMTQuMC0wMTAwMS1nYjBlMzNj
MzoxNDUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjEtMDQwMi9iMGUzM2MzNGUyM2M3Zjhl
ZGUyZjE5ZDk5MjYyODgwMjMwOGMzYWZjL2RtZXNnLXF1YW50YWwtYnJpY2tsYW5kMS04OjIw
MTQwNDAyMjMwODMwOmkzODYtcmFuZGNvbmZpZy1yMS0wNDAyOjoKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctcjEtMDQwMi9iMGUzM2MzNGUyM2M3ZjhlZGUyZjE5ZDk5MjYyODgwMjMwOGMz
YWZjL2RtZXNnLXlvY3RvLWlubi0yODoyMDE0MDQwNDAxMTkwMDppMzg2LXJhbmRjb25maWct
cjEtMDQwMjo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIxLTA0MDIvYjBlMzNjMzRlMjNj
N2Y4ZWRlMmYxOWQ5OTI2Mjg4MDIzMDhjM2FmYy9kbWVzZy1xdWFudGFsLWlubi0xMToyMDE0
MDQwMzIyMzYzNDppMzg2LXJhbmRjb25maWctcjEtMDQwMjo6Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXIxLTA0MDIvYjBlMzNjMzRlMjNjN2Y4ZWRlMmYxOWQ5OTI2Mjg4MDIzMDhjM2Fm
Yy9kbWVzZy15b2N0by1sa3Atc3QwMS0xMDoyMDE0MDQwMzIyMzU0NjppMzg2LXJhbmRjb25m
aWctcjEtMDQwMjozLjE0LjAtMDEwMDEtZ2IwZTMzYzM6MTQ1Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXIxLTA0MDIvYjBlMzNjMzRlMjNjN2Y4ZWRlMmYxOWQ5OTI2Mjg4MDIzMDhjM2Fm
Yy9kbWVzZy15b2N0by1yb2FtLTEwOjIwMTQwNDAzMjIzODI2OmkzODYtcmFuZGNvbmZpZy1y
MS0wNDAyOjMuMTQuMC0wMTAwMS1nYjBlMzNjMzoxNDUKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctcjEtMDQwMi9iMGUzM2MzNGUyM2M3ZjhlZGUyZjE5ZDk5MjYyODgwMjMwOGMzYWZjL2Rt
ZXNnLXlvY3RvLWlubi0xNToyMDE0MDQwMzIyMjkyNDppMzg2LXJhbmRjb25maWctcjEtMDQw
Mjo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIxLTA0MDIvYjBlMzNjMzRlMjNjN2Y4ZWRl
MmYxOWQ5OTI2Mjg4MDIzMDhjM2FmYy9kbWVzZy15b2N0by1hdGhlbnMtODoyMDE0MDQwMzIy
MzczNDppMzg2LXJhbmRjb25maWctcjEtMDQwMjozLjE0LjAtMDEwMDEtZ2IwZTMzYzM6MTQ1
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIxLTA0MDIvYjBlMzNjMzRlMjNjN2Y4ZWRlMmYx
OWQ5OTI2Mjg4MDIzMDhjM2FmYy9kbWVzZy1xdWFudGFsLWlubi0zOToyMDE0MDQwNDAxMjAw
NzppMzg2LXJhbmRjb25maWctcjEtMDQwMjo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIx
LTA0MDIvYjBlMzNjMzRlMjNjN2Y4ZWRlMmYxOWQ5OTI2Mjg4MDIzMDhjM2FmYy9kbWVzZy15
b2N0by1qYWtldG93bi0xNjoyMDE0MDQwNDAxMTkwMjppMzg2LXJhbmRjb25maWctcjEtMDQw
Mjo6CjU6MTY6MTggYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkhFQUQgaXMgbm93IGF0
IGIwZTMzYzMgMGRheSBoZWFkIGd1YXJkIGZvciAnZGV2ZWwtcm9hbS1pMzg2LTIwMTQwNDAy
MTcwMycKCj09PT09PT09PSB1cHN0cmVhbSA9PT09PT09PT0KUHJldmlvdXMgSEVBRCBwb3Np
dGlvbiB3YXMgYjBlMzNjMy4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1yb2FtLWkz
ODYtMjAxNDA0MDIxNzAzJwpIRUFEIGlzIG5vdyBhdCA1OWVjYzI2Li4uIE1lcmdlIGdpdDov
L2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9oZXJiZXJ0L2NyeXB0
by0yLjYKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZp
Zy1yMS0wNDAyL2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0MDQwMjE3MDM6NTll
Y2MyNjAwNGU3N2UxMDBjNzAwYjFkMGRhNzUwMmIwZmRhZGI0NjpiaXNlY3Qtc3RhYmxlCgoy
MDE0LTA0LTA0LTA0OjM1OjUzIDU5ZWNjMjYwMDRlNzdlMTAwYzcwMGIxZDBkYTc1MDJiMGZk
YWRiNDYgcmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjEtMDQwMi81OWVjYzI2MDA0
ZTc3ZTEwMGM3MDBiMWQwZGE3NTAyYjBmZGFkYjQ2L3ZtbGludXotMy4xNC4wLTA3MzMzLWc1
OWVjYzI2CgoyMDE0LTA0LTA0LTA0OjM1OjUzIGRldGVjdGluZyBib290IHN0YXRlIC4JMQk0
CTUxCTY4Li4uLi4uLi4uLi4uLi4uLgk2OSBTVUNDRVNTCgoKPT09PT09PT09IGxpbnV4LW5l
eHQgPT09PT09PT09ClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDU5ZWNjMjYuLi4gTWVy
Z2UgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2hlcmJl
cnQvY3J5cHRvLTIuNgpIRUFEIGlzIG5vdyBhdCA0YjIyZWZkLi4uIEFkZCBsaW51eC1uZXh0
IHNwZWNpZmljIGZpbGVzIGZvciAyMDE0MDQwMwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1x
dWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXIxLTA0MDIvbGludXgtZGV2ZWw6ZGV2ZWwtcm9h
bS1pMzg2LTIwMTQwNDAyMTcwMzo0YjIyZWZkZDU1OTVmMGFjYjQ4ZjAyYmY2NjRhNDUxZWU5
OGY5YTJlOmJpc2VjdC1zdGFibGUKCjIwMTQtMDQtMDQtMDQ6NTE6MDYgNGIyMmVmZGQ1NTk1
ZjBhY2I0OGYwMmJmNjY0YTQ1MWVlOThmOWEyZSByZXVzZSAva2VybmVsL2kzODYtcmFuZGNv
bmZpZy1yMS0wNDAyLzRiMjJlZmRkNTU5NWYwYWNiNDhmMDJiZjY2NGE0NTFlZTk4ZjlhMmUv
dm1saW51ei0zLjE0LjAtbmV4dC0yMDE0MDQwMwoKMjAxNC0wNC0wNC0wNDo1MTowNiBkZXRl
Y3RpbmcgYm9vdCBzdGF0ZSAuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMwk3CTE3CTIyCTM5
CTQ3CTY5IFNVQ0NFU1MKCg==

--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc1-00080-g336ca19"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.14.0-rc1 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
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
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
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
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_FHANDLE=y
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
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
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_SLUB_DEBUG is not set
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
CONFIG_UPROBES=y
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
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR_NONE is not set
CONFIG_CC_STACKPROTECTOR_REGULAR=y
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
# CONFIG_GCOV_FORMAT_3_4 is not set
CONFIG_GCOV_FORMAT_4_7=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
# CONFIG_BLOCK is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
CONFIG_MPENTIUMII=y
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS=1
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
# CONFIG_X86_UP_APIC is not set
# CONFIG_X86_MCE is not set
# CONFIG_VM86 is not set
CONFIG_TOSHIBA=y
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_MICROCODE_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
CONFIG_VMSPLIT_3G_OPT=y
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xB0000000
CONFIG_HIGHMEM=y
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_ZBUD is not set
CONFIG_MEM_SOFT_DIRTY=y
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
CONFIG_HIGHPTE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_RANDOMIZE_BASE_MAX_OFFSET=0x20000000
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
CONFIG_APM_IGNORE_USER_SUSPEND=y
# CONFIG_APM_DO_ENABLE is not set
# CONFIG_APM_CPU_IDLE is not set
# CONFIG_APM_DISPLAY_BLANK is not set
CONFIG_APM_ALLOW_INTS=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

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
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_OLPC=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
# CONFIG_SCx200 is not set
CONFIG_OLPC=y
# CONFIG_OLPC_XO15_SCI is not set
# CONFIG_ALIX is not set
# CONFIG_NET5501 is not set
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
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=y
CONFIG_ATM=y
# CONFIG_ATM_LANE is not set
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_MRP=y
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_LTPC=y
# CONFIG_COPS is not set
CONFIG_IPDDP=y
CONFIG_IPDDP_ENCAP=y
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_ATM=y
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_MULTIQ=y
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFB=y
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
# CONFIG_NET_SCH_GRED is not set
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_MQPRIO=y
# CONFIG_NET_SCH_CHOKE is not set
# CONFIG_NET_SCH_QFQ is not set
CONFIG_NET_SCH_CODEL=y
CONFIG_NET_SCH_FQ_CODEL=y
CONFIG_NET_SCH_FQ=y
CONFIG_NET_SCH_HHF=y
# CONFIG_NET_SCH_PIE is not set
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
# CONFIG_NET_CLS_CGROUP is not set
CONFIG_NET_CLS_BPF=y
# CONFIG_NET_EMATCH is not set
# CONFIG_NET_CLS_ACT is not set
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=y
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=y
# CONFIG_HSR is not set
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
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
# CONFIG_AX25_DAMA_SLAVE is not set
CONFIG_NETROM=y
# CONFIG_ROSE is not set

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
# CONFIG_6PACK is not set
# CONFIG_BPQETHER is not set
# CONFIG_DMASCC is not set
# CONFIG_SCC is not set
# CONFIG_BAYCOM_SER_FDX is not set
CONFIG_BAYCOM_SER_HDX=y
# CONFIG_YAM is not set
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
CONFIG_CAN_BCM=y
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=y
CONFIG_CAN_CALC_BITTIMING=y
CONFIG_CAN_LEDS=y
# CONFIG_PCH_CAN is not set
CONFIG_CAN_GRCAN=y
CONFIG_CAN_SJA1000=y
CONFIG_CAN_SJA1000_ISA=y
CONFIG_CAN_SJA1000_PLATFORM=y
CONFIG_CAN_SJA1000_OF_PLATFORM=y
# CONFIG_CAN_EMS_PCI is not set
# CONFIG_CAN_PEAK_PCI is not set
# CONFIG_CAN_KVASER_PCI is not set
# CONFIG_CAN_PLX_PCI is not set
CONFIG_CAN_TSCAN1=y
CONFIG_CAN_C_CAN=y
# CONFIG_CAN_C_CAN_PLATFORM is not set
# CONFIG_CAN_C_CAN_PCI is not set
# CONFIG_CAN_CC770 is not set
# CONFIG_CAN_SOFTING is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_WIRELESS is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
CONFIG_RFKILL_GPIO=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_NET_9P_DEBUG=y
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
CONFIG_CAIF_NETDEV=y
CONFIG_CAIF_USB=y
CONFIG_NFC=y
# CONFIG_NFC_DIGITAL is not set
CONFIG_NFC_NCI=y
# CONFIG_NFC_HCI is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_SIM=y
# CONFIG_NFC_MRVL is not set

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
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
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
# CONFIG_DMA_SHARED_BUFFER is not set
CONFIG_DMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=16
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
CONFIG_CMA_AREAS=7

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=y
# CONFIG_MTD_REDBOOT_PARTS is not set
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_OF_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_OOPS=y

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
# CONFIG_MTD_OTP is not set
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=y
# CONFIG_MTD_PHYSMAP_COMPAT is not set
CONFIG_MTD_PHYSMAP_OF=y
# CONFIG_MTD_SC520CDP is not set
# CONFIG_MTD_NETSC520 is not set
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=y
# CONFIG_MTD_NAND_ECC_BCH is not set
# CONFIG_MTD_SM_COMMON is not set
# CONFIG_MTD_NAND_DENALI is not set
CONFIG_MTD_NAND_GPIO=y
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH is not set
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
CONFIG_MTD_NAND_DOCG4=y
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_CS553X=y
CONFIG_MTD_NAND_NANDSIM=y
CONFIG_MTD_NAND_PLATFORM=y
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=y
CONFIG_MTD_ONENAND_OTP=y
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_MTD_UBI_GLUEBI=y
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
CONFIG_PROC_DEVICETREE=y
CONFIG_OF_SELFTEST=y
CONFIG_OF_PROMTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_NET=y
CONFIG_OF_MDIO=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
CONFIG_OF_MTD=y
# CONFIG_PARPORT is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
CONFIG_DS1682=y
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
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
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_NET_CORE is not set
# CONFIG_ARCNET is not set
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=y
# CONFIG_ATM_LANAI is not set
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_FIRESTREAM is not set
# CONFIG_ATM_ZATM is not set
# CONFIG_ATM_NICSTAR is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_AMBASSADOR is not set
# CONFIG_ATM_HORIZON is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
# CONFIG_ATM_SOLOS is not set

#
# CAIF transport drivers
#
# CONFIG_CAIF_TTY is not set
CONFIG_CAIF_SPI_SLAVE=y
# CONFIG_CAIF_SPI_SYNC is not set
CONFIG_CAIF_HSI=y
CONFIG_CAIF_VIRTIO=y
CONFIG_VHOST_NET=y
CONFIG_VHOST_RING=y
CONFIG_VHOST=y

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
# CONFIG_ETHERNET is not set
# CONFIG_FDDI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
# CONFIG_QSEMI_PHY is not set
CONFIG_LXT_PHY=y
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM87XX_PHY is not set
# CONFIG_ICPLUS_PHY is not set
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_GPIO=y
CONFIG_MDIO_BUS_MUX=y
# CONFIG_MDIO_BUS_MUX_GPIO is not set
CONFIG_MDIO_BUS_MUX_MMIOREG=y
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=y
# CONFIG_PPP_MULTILINK is not set
# CONFIG_PPPOATM is not set
CONFIG_PPPOE=y
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y
# CONFIG_WLAN is not set

#
# WiMAX Wireless Broadband devices
#

#
# Enable USB support to see WiMAX USB drivers
#
# CONFIG_WAN is not set
# CONFIG_ISDN is not set

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
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
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
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
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
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
CONFIG_SERIO_APBPS2=y
# CONFIG_SERIO_OLPC_APSP is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
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
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_OF_PLATFORM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
# CONFIG_IPMI_WATCHDOG is not set
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=y
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=y
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
# CONFIG_TCG_ST33_I2C is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_ARB_GPIO_CHALLENGE=y
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_PCA9541 is not set
CONFIG_I2C_MUX_PCA954x=y
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
CONFIG_I2C_CBUS_GPIO=y
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
# CONFIG_I2C_KEMPLD is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_ELEKTOR is not set
# CONFIG_I2C_PCA_ISA is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

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
CONFIG_PPS_CLIENT_KTIMER=y
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
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9055=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=y
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set
CONFIG_GPIO_GRGPIO=y

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_LP3943 is not set
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_RC5T583 is not set
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_TWL6040 is not set
# CONFIG_GPIO_WM831X is not set
CONFIG_GPIO_WM8350=y
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set
# CONFIG_GPIO_ADNP is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_INTEL_MID is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_SODAVILLE is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MCP23S08=y

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
CONFIG_GPIO_PALMAS=y
# CONFIG_GPIO_TPS6586X is not set
CONFIG_GPIO_TPS65910=y
# CONFIG_GPIO_BCM_KONA is not set

#
# USB GPIO expanders:
#
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
# CONFIG_W1_SLAVE_DS2413 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
# CONFIG_MAX8925_POWER is not set
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
# CONFIG_WM8350_POWER is not set
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_88PM860X is not set
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_OLPC is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9030=y
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
# CONFIG_CHARGER_PCF50633 is not set
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_LP8727=y
# CONFIG_CHARGER_GPIO is not set
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_BQ24735=y
CONFIG_CHARGER_SMB347=y
CONFIG_CHARGER_TPS65090=y
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHMD=y
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_G762=y
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_HTU21 is not set
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IBMAEM is not set
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=y
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95234=y
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_NCT6775 is not set
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
# CONFIG_SENSORS_PMBUS is not set
# CONFIG_SENSORS_ADM1275 is not set
CONFIG_SENSORS_LM25066=y
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_WM8350=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_OF=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
# CONFIG_ACPI_INT3403_THERMAL is not set

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
# CONFIG_DA9055_WATCHDOG is not set
CONFIG_GPIO_WATCHDOG=y
CONFIG_WM831X_WATCHDOG=y
CONFIG_WM8350_WATCHDOG=y
# CONFIG_DW_WATCHDOG is not set
CONFIG_ACQUIRE_WDT=y
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_KEMPLD_WDT is not set
CONFIG_SC1200_WDT=y
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
# CONFIG_SBC8360_WDT is not set
CONFIG_SBC7240_WDT=y
CONFIG_CPU5_WDT=y
# CONFIG_SMSC_SCH311X_WDT is not set
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=y
CONFIG_W83697UG_WDT=y
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y
CONFIG_MEN_A21_WDT=y

#
# ISA-based Watchdog Cards
#
CONFIG_PCWATCHDOG=y
# CONFIG_MIXCOMWD is not set
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_SILENT=y
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
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
CONFIG_MFD_AS3722=y
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
CONFIG_PMIC_DA903X=y
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
# CONFIG_MFD_RETU is not set
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=y
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP3943=y
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
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
CONFIG_VIDEO_OUTPUT_CONTROL=y
# CONFIG_FB is not set
CONFIG_EXYNOS_VIDEO=y
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
# CONFIG_SND is not set
CONFIG_SOUND_PRIME=y
# CONFIG_SOUND_MSNDCLAS is not set
# CONFIG_SOUND_MSNDPIN is not set
CONFIG_SOUND_OSS=y
CONFIG_SOUND_TRACEINIT=y
# CONFIG_SOUND_DMAP is not set
CONFIG_SOUND_VMIDI=y
# CONFIG_SOUND_TRIX is not set
CONFIG_SOUND_MSS=y
# CONFIG_SOUND_MPU401 is not set
# CONFIG_SOUND_PAS is not set
CONFIG_SOUND_PSS=y
CONFIG_PSS_MIXER=y
# CONFIG_PSS_HAVE_BOOT is not set
CONFIG_SOUND_SB=y
CONFIG_SOUND_YM3812=y
CONFIG_SOUND_UART6850=y
CONFIG_SOUND_AEDSP16=y
# CONFIG_SC6600 is not set
CONFIG_SOUND_KAHLUA=y

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
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
# CONFIG_HID_CHERRY is not set
CONFIG_HID_CHICONY=y
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
CONFIG_HID_ICADE=y
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_LEDS=y
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=y
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_XINMO=y
# CONFIG_HID_ZEROPLUS is not set
CONFIG_HID_ZYDACRON=y
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
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
CONFIG_LEDS_LM3530=y
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_PCA9532=y
CONFIG_LEDS_PCA9532_GPIO=y
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_LP8788=y
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_PCA9685=y
# CONFIG_LEDS_WM831X_STATUS is not set
# CONFIG_LEDS_WM8350 is not set
CONFIG_LEDS_DA903X=y
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_MC13783=y
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_MAX8997=y
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
# CONFIG_LEDS_TRIGGER_CAMERA is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_AMD76X is not set
# CONFIG_EDAC_E7XXX is not set
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82875P is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I82860 is not set
# CONFIG_EDAC_R82600 is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
# CONFIG_DW_DMAC_PCI is not set
CONFIG_TIMB_DMA=y
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y
CONFIG_DMA_OF=y

#
# DMA Clients
#
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_STAGING=y
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
CONFIG_ECHO=y
# CONFIG_DX_SEP is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_FT1000=y

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
CONFIG_STAGING_MEDIA=y

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_NET_VENDOR_SILICOM is not set
# CONFIG_DGRP is not set
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
CONFIG_AMILO_RFKILL=y
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
CONFIG_XO1_RFKILL=y
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y
CONFIG_OF_IOMMU=y

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

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
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_OF_EXTCON=y
CONFIG_EXTCON_GPIO=y
# CONFIG_EXTCON_MAX77693 is not set
CONFIG_EXTCON_MAX8997=y
CONFIG_EXTCON_PALMAS=y
CONFIG_MEMORY=y
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IRQCHIP=y
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_EXYNOS_MIPI_VIDEO=y
CONFIG_PHY_EXYNOS_DP_VIDEO=y
# CONFIG_BCM_KONA_USB2_PHY is not set
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

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
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
CONFIG_JFFS2_FS_WBUF_VERIFY=y
CONFIG_JFFS2_SUMMARY=y
CONFIG_JFFS2_FS_XATTR=y
CONFIG_JFFS2_FS_POSIX_ACL=y
CONFIG_JFFS2_FS_SECURITY=y
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
# CONFIG_UBIFS_FS is not set
# CONFIG_LOGFS is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_MTD=y
CONFIG_ROMFS_ON_MTD=y
# CONFIG_PSTORE is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
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
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
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
# CONFIG_NLS_UTF8 is not set

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
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_HIGHMEM=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
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
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
CONFIG_STACK_TRACER=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_DYNAMIC_FTRACE is not set
CONFIG_FUNCTION_PROFILER=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
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
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
# CONFIG_SECURITY_PATH is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
# CONFIG_IMA_TEMPLATE is not set
# CONFIG_IMA_NG_TEMPLATE is not set
CONFIG_IMA_SIG_TEMPLATE=y
CONFIG_IMA_DEFAULT_TEMPLATE="ima-sig"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
# CONFIG_IMA_DEFAULT_HASH_SHA512 is not set
# CONFIG_IMA_DEFAULT_HASH_WP512 is not set
CONFIG_IMA_DEFAULT_HASH="sha1"
# CONFIG_IMA_APPRAISE is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
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
CONFIG_CRYPTO_USER=y
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
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
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
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
# CONFIG_CRYPTO_GHASH is not set
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA256 is not set
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_DES is not set
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

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
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
# CONFIG_LGUEST is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_PERCPU_RWSEM=y
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
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
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
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set

--X1bOJ3K7DJ5YkBrT--
