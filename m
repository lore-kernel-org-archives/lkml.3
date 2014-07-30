Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbaG3D4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 23:56:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:10219 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732AbaG3Dz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 23:55:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,761,1400050800"; 
   d="log'?scan'208";a="569234382"
Date: Wed, 30 Jul 2014 11:55:41 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [delayed_fput] BUG: unable to handle kernel paging request at
 ffff8800122a0ad0
Message-ID: <20140730035541.GD16537@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="G6nVm6DDWH/FONJq"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G6nVm6DDWH/FONJq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
commit 4a9d4b024a3102fc083c925c242d98ac27b1c5f6
Author:     Al Viro <viro@zeniv.linux.org.uk>
AuthorDate: Sun Jun 24 09:56:45 2012 +0400
Commit:     Al Viro <viro@zeniv.linux.org.uk>
CommitDate: Sun Jul 22 23:57:58 2012 +0400

    switch fput to task_work_add
    
    ... and schedule_work() for interrupt/kernel_thread callers
    (and yes, now it *is* OK to call from interrupt).
    
    We are guaranteed that __fput() will be done before we return
    to userland (or exit).  Note that for fput() from a kernel
    thread we get an async behaviour; it's almost always OK, but
    sometimes you might need to have __fput() completed before
    you do anything else.  There are two mechanisms for that -
    a general barrier (flush_delayed_fput()) and explicit
    __fput_sync().  Both should be used with care (as was the
    case for fput() from kernel threads all along).  See comments
    in fs/file_table.c for details.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

+-------------------------------------------------------+------------+------------+---------------+
|                                                       | a2d4c71d15 | 4a9d4b024a | next-20140725 |
+-------------------------------------------------------+------------+------------+---------------+
| boot_successes                                        | 900        | 189        | 14            |
| boot_failures                                         | 0          | 111        | 7             |
| BUG:Bad_page_state_in_process                         | 0          | 1          |               |
| general_protection_fault                              | 0          | 2          | 2             |
| RIP:slob_alloc                                        | 0          | 1          |               |
| Kernel_panic-not_syncing:Fatal_exception              | 0          | 15         | 6             |
| backtrace:cryptomgr_test                              | 0          | 2          | 3             |
| backtrace:kmem_cache_alloc_node                       | 0          | 1          |               |
| backtrace:__delayacct_tsk_init                        | 0          | 1          |               |
| backtrace:do_fork                                     | 0          | 1          |               |
| BUG:kernel_boot_hang                                  | 0          | 85         |               |
| BUG:spinlock_bad_magic_on_CPU                         | 0          | 2          |               |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference  | 0          | 3          | 1             |
| Oops                                                  | 0          | 23         | 5             |
| RIP:dcache_readdir                                    | 0          | 1          |               |
| RIP:kobject_get_path                                  | 0          | 1          |               |
| backtrace:acpi_bus_register_driver                    | 0          | 1          |               |
| backtrace:acpi_button_init                            | 0          | 1          |               |
| RIP:__d_lookup                                        | 0          | 1          |               |
| BUG:unable_to_handle_kernel_paging_request            | 0          | 20         | 6             |
| RIP:slob_page_alloc                                   | 0          | 8          | 2             |
| backtrace:subsys_system_register                      | 0          | 9          |               |
| backtrace:init_clocksource_sysfs                      | 0          | 9          |               |
| RIP:kzfree                                            | 0          | 10         | 2             |
| Kernel_panic-not_syncing:Fatal_exception_in_interrupt | 0          | 10         | 1             |
| backtrace:run_ksoftirqd                               | 0          | 10         |               |
| RIP:set_slob                                          | 0          | 2          |               |
| RIP:do_raw_spin_lock                                  | 0          | 1          |               |
| backtrace:async_schedule                              | 0          | 1          |               |
| backtrace:acpi_battery_init                           | 0          | 1          |               |
| RIP:__d_lookup_rcu                                    | 0          | 0          | 1             |
| backtrace:vfs_stat                                    | 0          | 0          | 1             |
| backtrace:SyS_newstat                                 | 0          | 0          | 1             |
| RIP:no_context                                        | 0          | 0          | 1             |
| RIP:crypto_ahash_setkey                               | 0          | 0          | 1             |
+-------------------------------------------------------+------------+------------+---------------+

[    0.491632] microcode: CPU0 sig=0x306c1, pf=0x1, revision=0x1
[    0.492419] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.495181] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    0.496687] BUG: unable to handle kernel paging request at ffff8800122a0ad0
[    0.496916] IP: [<ffffffff810b8a17>] slob_page_alloc+0x3c/0x1dc
[    0.496916] PGD 15a0063 PUD 15a4063 PMD 13cd5067 PTE 122a0160
[    0.496916] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.496916] CPU 0 
[    0.496916] Modules linked in:
[    0.496916] 
[    0.496916] Pid: 1, comm: swapper Not tainted 3.5.0-rc6-00262-g4a9d4b0 #7 Bochs Bochs
[    0.496916] RIP: 0010:[<ffffffff810b8a17>]  [<ffffffff810b8a17>] slob_page_alloc+0x3c/0x1dc
[    0.496916] RSP: 0018:ffff880012823bd8  EFLAGS: 00010002
[    0.496916] RAX: ffff8800122a0ad0 RBX: ffff88001229df88 RCX: 0000000000000038
[    0.496916] RDX: 0000000000000008 RSI: 0000000000000070 RDI: ffff88001229df88
[    0.496916] RBP: ffff880012823c20 R08: ffff88001229dbc8 R09: ffffffff815c3410
[    0.496916] R10: 0000000000000007 R11: 0000000000000008 R12: ffff8800132ce740
[    0.496916] R13: 0000000000000000 R14: 0000000000000008 R15: ffff8800122a0ad0
[    0.496916] FS:  0000000000000000(0000) GS:ffffffff815b0000(0000) knlGS:0000000000000000
[    0.496916] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.496916] CR2: ffff8800122a0ad0 CR3: 000000000159f000 CR4: 00000000000406f0
[    0.496916] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.496916] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    0.496916] Process swapper (pid: 1, threadinfo ffff880012822000, task ffff88001280e810)
[    0.496916] Stack:
[    0.496916]  0000000000000007 0000003800000008 fffffffffffffff8 0000000000000038
[    0.496916]  ffffffff815c3410 0000000000000070 ffff8800132ce740 0000000000000008
[    0.496916]  0000000000000038 ffff880012823c80 ffffffff810b8c42 0000000000000297
[    0.496916] Call Trace:
[    0.496916]  [<ffffffff810b8c42>] slob_alloc.isra.15+0x8b/0x208
[    0.496916]  [<ffffffff810b8ea7>] kmem_cache_alloc_node+0x28/0x5f
[    0.496916]  [<ffffffff810a1419>] ? kstrdup+0x28/0x41
[    0.496916]  [<ffffffff81100d99>] sysfs_new_dirent+0x51/0x101
[    0.496916]  [<ffffffff81101120>] create_dir+0x33/0xa9
[    0.496916]  [<ffffffff81101462>] sysfs_create_dir+0x95/0xb3
[    0.496916]  [<ffffffff811813f3>] kobject_add_internal+0xca/0x1c1
[    0.496916]  [<ffffffff8118171c>] ? kobject_set_name+0x38/0x3a
[    0.496916]  [<ffffffff81181a66>] kset_register+0x20/0x3e
[    0.496916]  [<ffffffff81181ae7>] kset_create_and_add+0x63/0x7d
[    0.496916]  [<ffffffff81216835>] __bus_register+0x102/0x27b
[    0.496916]  [<ffffffff8164ea8c>] ? clocksource_done_booting+0x5a/0x5a
[    0.496916]  [<ffffffff81216dea>] subsys_system_register+0x1d/0xc1
[    0.496916]  [<ffffffff8164ea8c>] ? clocksource_done_booting+0x5a/0x5a
[    0.496916]  [<ffffffff8164ea9e>] init_clocksource_sysfs+0x12/0x52
[    0.496916]  [<ffffffff81002078>] do_one_initcall+0x78/0x131
[    0.496916]  [<ffffffff8163cca5>] kernel_init+0x14a/0x1c2
[    0.496916]  [<ffffffff8163c502>] ? do_early_param+0x8a/0x8a
[    0.496916]  [<ffffffff813e50d4>] kernel_thread_helper+0x4/0x10
[    0.496916]  [<ffffffff8163cb5b>] ? start_kernel+0x40a/0x40a
[    0.496916]  [<ffffffff813e50d0>] ? gs_change+0x13/0x13
[    0.496916] Code: 41 54 49 89 fc 53 31 db 48 83 ec 20 48 89 45 d0 48 d1 6d d0 48 63 c2 8b 4d d0 4c 8b 7f 20 4c 8d 50 ff 48 f7 d8 31 ff 48 89 45 c8 <66> 45 8b 37 b8 01 00 00 00 66 45 85 f6 44 0f 4e f0 85 d2 74 11 
[    0.496916] RIP  [<ffffffff810b8a17>] slob_page_alloc+0x3c/0x1dc
[    0.496916]  RSP <ffff880012823bd8>
[    0.496916] CR2: ffff8800122a0ad0
[    0.496916] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.496916] Kernel panic - not syncing: Fatal exception

git bisect start v3.6 v3.5 --
git bisect  bad 1dd8372d350583b0acc8d7cfd7a1dee05e1942dc  # 00:14     10-     12  MAINTAINERS: update address for Dan Williams
git bisect  bad a410963ba4c0c768302f0298e258b1ee940e8316  # 00:19    169-      7  Merge branch 'i2c-embedded/for-next' of git://git.pengutronix.de/git/wsa/linux
git bisect  bad e8ff13b0bf88b5e696323a1eec877783d965b3c6  # 00:25     59-     24  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid
git bisect  bad e66d637134b7045ea6f14bdd416cd3695f73ed42  # 00:28      7-     13  Merge tag 'dma' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect good 7cd58b0a3b33ca9e1f1dd15b30c708ef77ba6d3e  # 00:44    300+     13  Merge tag 'regmap-3.6' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap
git bisect  bad a66d2c8f7ec1284206ca7c14569e2a607583f1e3  # 00:54    218-      7  Merge branch 'for-linus-2' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
git bisect good 7100e505b76b4e2efd88b2459d1a932214e29f8a  # 01:11    300+      0  Merge tag 'pm-for-3.6-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
git bisect good 5b160bd426946c85f32b15e5d34d62d2618a5a87  # 01:19    300+      0  Merge branch 'x86-mce-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good a6be1fcbc57f95bb47ef3c8e4ee3d83731b8f21e  # 01:31    300+      0  Merge tag 'mmc-merge-for-3.6-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc
git bisect good 79714f72d3b964611997de512cb29198c9f2dbbb  # 01:43    300+      0  get rid of kern_path_parent()
git bisect  bad 715189d836ab276b3d0fc114681f12b423686ffa  # 01:52     67-      2  hfs: push lock_super down
git bisect good 0bdaea9017b9d2b9996e153a71ee03555969b80e  # 02:12    300+      1  VFS: Split inode_permission()
git bisect  bad 4a9d4b024a3102fc083c925c242d98ac27b1c5f6  # 02:20     43-     35  switch fput to task_work_add
git bisect good 158e1645e07f3e9f7e4962d7a0997f5c3b98311b  # 02:35    300+     74  trim task_work: get rid of hlist
git bisect good ed3e694d78cc75fa79bf29698631b146fd27aa35  # 02:47    300+      0  move exit_task_work() past exit_files() et.al.
git bisect good a2d4c71d1559426155e5da8db3265bfa0d8d398d  # 02:57    300+      0  deal with task_work callbacks adding more work
# first bad commit: [4a9d4b024a3102fc083c925c242d98ac27b1c5f6] switch fput to task_work_add
git bisect good a2d4c71d1559426155e5da8db3265bfa0d8d398d  # 03:04    900+      0  deal with task_work callbacks adding more work
git bisect  bad 5a7439efd1c5c416f768fc550048ca130cf4bf99  # 03:04      0-      7  Add linux-next specific files for 20140725
git bisect  bad 9c5502189fa00ad623aed7ff006d5c2a16b121c0  # 03:11     12-     18  Merge tag 'sound-3.16-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
git bisect  bad 5a7439efd1c5c416f768fc550048ca130cf4bf99  # 03:11      0-      7  Add linux-next specific files for 20140725


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/$initrd

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
	panic=10
	softlockup_panic=1
	nmi_watchdog=panic
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

--G6nVm6DDWH/FONJq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-kbuild-7:20140727021945:x86_64-randconfig-r1-07262119:3.5.0-rc6-00262-g4a9d4b0:7"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.5.0-rc6-00262-g4a9d4b0 (kbuild@jaketown) (gc=
c version 4.8.2 (Debian 4.8.2-18) ) #7 Sun Jul 27 02:17:28 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0=
 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw li=
nk=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-r1-07262119/next:master:=
4a9d4b024a3102fc083c925c242d98ac27b1c5f6:bisect-linux/.vmlinuz-4a9d4b024a31=
02fc083c925c242d98ac27b1c5f6-20140727021804-184-kbuild branch=3Dnext/master=
 BOOT_IMAGE=3D/kernel/x86_64-randconfig-r1-07262119/4a9d4b024a3102fc083c925=
c242d98ac27b1c5f6/vmlinuz-3.5.0-rc6-00262-g4a9d4b0 drbd.minor_count=3D8
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   Centaur CentaurHauls
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
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdb00-0x000fdb0f] mapped at =
[ffff8800000fdb00]
[    0.000000]   mpc: fdb10-fdbf0
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x13ffdfff]
[    0.000000]  [mem 0x00000000-0x13ffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0x13ffdfff @ [mem 0x13c44=
000-0x13ce5fff]
[    0.000000] RAMDISK: [mem 0x13ce6000-0x13feffff]
[    0.000000] ACPI: RSDP 00000000000fd9a0 00014 (v00 BOCHS )
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
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:15b8201, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81805
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3913 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 76606 pages, LIFO batch:15
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
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 15b8080
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-r1-07262119/next:=
master:4a9d4b024a3102fc083c925c242d98ac27b1c5f6:bisect-linux/.vmlinuz-4a9d4=
b024a3102fc083c925c242d98ac27b1c5f6-20140727021804-184-kbuild branch=3Dnext=
/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-r1-07262119/4a9d4b024a3102fc=
083c925c242d98ac27b1c5f6/vmlinuz-3.5.0-rc6-00262-g4a9d4b0 drbd.minor_count=
=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Memory: 308636k/327672k available (3998k kernel code, 452k a=
bsent, 18584k reserved, 2380k data, 400k init)
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] console [ttyS0] enabled
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
[    0.000000]                     double unlock:  ok  |  ok  |failed|faile=
d|failed|failed|
[    0.000000]                   initialize held:failed|failed|failed|faile=
d|failed|failed|
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
[    0.000000] --------------------------------------------------------
[    0.000000] 143 out of 218 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] Detected 2693.332 MHz processor.
[    0.006666] Calibrating delay loop (skipped) preset value.. 5388.10 Bogo=
MIPS (lpj=3D8977773)
[    0.006666] pid_max: default: 32768 minimum: 301
[    0.006688] Security Framework initialized
[    0.007269] AppArmor: AppArmor initialized
[    0.007854] Mount-cache hash table entries: 256
[    0.010051] Initializing cgroup subsys debug
[    0.010647] Initializing cgroup subsys devices
[    0.011276] Initializing cgroup subsys freezer
[    0.011899] Initializing cgroup subsys blkio
[    0.012489] Initializing cgroup subsys perf_event
[    0.013242] mce: CPU supports 10 MCE banks
[    0.013379] CPU: Intel Core Processor (Haswell) stepping 01
[    0.017766] ACPI: Core revision 20120320
[    0.020051] Performance Events: unsupported p6 CPU model 60 no PMU drive=
r, software events only.
[    0.021432] Getting VERSION: 1050014
[    0.021949] Getting VERSION: 1050014
[    0.023166] Getting ID: 0
[    0.023346] Getting ID: ff000000
[    0.023814] Getting LVT0: 8700
[    0.024244] Getting LVT1: 8400
[    0.024746] enabled ExtINT on CPU#0
[    0.026252] ENABLING IO-APIC IRQs
[    0.026674] init IO_APIC IRQs
[    0.027092]  apic 0 pin 0 not connected
[    0.027633] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.028732] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.030020] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.031121] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.032226] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.033351] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.034438] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.035523] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.036684] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.037770] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.038873] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.040020] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.043351] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.044463] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.045567] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.046682]  apic 0 pin 16 not connected
[    0.047218]  apic 0 pin 17 not connected
[    0.047763]  apic 0 pin 18 not connected
[    0.048300]  apic 0 pin 19 not connected
[    0.048844]  apic 0 pin 20 not connected
[    0.049379]  apic 0 pin 21 not connected
[    0.050000]  apic 0 pin 22 not connected
[    0.050551]  apic 0 pin 23 not connected
[    0.051229] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.052033] Using local APIC timer interrupts.
[    0.052033] calibrating APIC timer ...
[    0.056663] ... lapic delta =3D 6459185
[    0.056663] ... PM-Timer delta =3D 369913
[    0.056663] APIC calibration not consistent with PM-Timer: 103ms instead=
 of 100ms
[    0.056663] APIC delta adjusted to PM-Timer: 6250364 (6459185)
[    0.056663] TSC delta adjusted to PM-Timer: 269349801 (278348595)
[    0.056663] ..... delta 6250364
[    0.056663] ..... mult: 268468593
[    0.056663] ..... calibration result: 3333527
[    0.056663] ..... CPU clock speed is 2693.2557 MHz.
[    0.056663] ..... host bus clock speed is 1000.0527 MHz.
[    0.057942] EVM: security.capability
[    0.058711] xor: automatically using best checksumming function:
[    0.090021]    avx       :   136.800 MB/sec
[    0.090716] dummy:=20
[    0.091055] NET: Registered protocol family 16
[    0.092286] ACPI: bus type pci registered
[    0.092852] dca service started, version 1.12.1
[    0.093367] PCI: Using configuration type 1 for base access
[    0.096188] bio: create slab <bio-0> at 0
[    0.153339] raid6: sse2x1    4451 MB/s
[    0.209992] raid6: sse2x2    6029 MB/s
[    0.266663] raid6: sse2x4    7163 MB/s
[    0.267193] raid6: using algorithm sse2x4 (7163 MB/s)
[    0.267866] raid6: using ssse3x2 recovery algorithm
[    0.268538] ACPI: Added _OSI(Module Device)
[    0.269102] ACPI: Added _OSI(Processor Device)
[    0.269696] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.269987] ACPI: Added _OSI(Processor Aggregator Device)
[    0.271349] ACPI: EC: Look up EC in DSDT
[    0.275871] ACPI: Interpreter enabled
[    0.276371] ACPI: (supports S0 S3 S5)
[    0.276841] ACPI: Using IOAPIC for interrupt routing
[    0.282203] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.283480] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.284506] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.285382] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.286255] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x00=
0bffff]
[    0.286654] pci_root PNP0A03:00: host bridge window [mem 0x80000000-0xfe=
bfffff]
[    0.287659] PCI host bridge to bus 0000:00
[    0.288204] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.289986] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.290802] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.291709] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.292691] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.293672] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.294996] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.299352] pci 0000:00:01.1: reg 20: [io  0xc040-0xc04f]
[    0.301292] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.302546] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.303330] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.304451] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.307862] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.311467] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    0.319511] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.320224] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.322173] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.324441] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.331100] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.332080] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.333631] pci 0000:00:04.0: reg 10: [mem 0xfebf1000-0xfebf100f]
[    0.338134] pci_bus 0000:00: on NUMA node 0
[    0.338745] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.341178]  pci0000:00: Unable to request _OSC control (_OSC support ma=
sk: 0x08)
[    0.347612] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.348624] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.349620] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.350369] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.351296] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.352646] Linux video capture interface: v2.00
[    0.353603] PCI: Using ACPI for IRQ routing
[    0.354171] PCI: pci_cache_line_size set to 64 bytes
[    0.354997] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.355796] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.356928] NET: Registered protocol family 23
[    0.357866] Switching to clocksource kvm-clock
[    0.358590] AppArmor: AppArmor Filesystem Enabled
[    0.359263] pnp: PnP ACPI init
[    0.359701] ACPI: bus type pnp registered
[    0.359977] pnp 00:00: [bus 00-ff]
[    0.359977] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.359977] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.360287] pnp 00:00: [io  0x0d00-0xffff window]
[    0.360914] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.361629] pnp 00:00: [mem 0x80000000-0xfebfffff window]
[    0.362389] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.363276] pnp 00:01: [io  0x0070-0x0071]
[    0.363868] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.364933] pnp 00:01: [irq 8]
[    0.365345] pnp 00:01: [io  0x0072-0x0077]
[    0.365943] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.366850] pnp 00:02: [io  0x0060]
[    0.367319] pnp 00:02: [io  0x0064]
[    0.367798] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.368849] pnp 00:02: [irq 1]
[    0.369308] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.370207] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.371287] pnp 00:03: [irq 12]
[    0.371747] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.372662] pnp 00:04: [io  0x03f2-0x03f5]
[    0.373208] pnp 00:04: [io  0x03f7]
[    0.373703] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.376435] pnp 00:04: [irq 6]
[    0.376875] pnp 00:04: [dma 2]
[    0.377339] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.378256] pnp 00:05: [io  0x0378-0x037f]
[    0.378810] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.379865] pnp 00:05: [irq 7]
[    0.380324] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.381258] pnp 00:06: [io  0x03f8-0x03ff]
[    0.381819] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.382873] pnp 00:06: [irq 4]
[    0.383329] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.384275] pnp 00:07: [io  0x02f8-0x02ff]
[    0.384844] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.385902] pnp 00:07: [irq 3]
[    0.386345] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.387412] pnp 00:08: [mem 0xfed00000-0xfed003ff]
[    0.388111] pnp 00:08: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.389142] pnp: PnP ACPI: found 9 devices
[    0.389698] ACPI: ACPI bus type pnp unregistered
[    0.395345] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.396090] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.396847] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.397677] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.398500] NET: Registered protocol family 1
[    0.399088] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.399881] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.400680] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.401518] pci 0000:00:02.0: Boot video device
[    0.402157] PCI: CLS 0 bytes, default 64
[    0.402827] Unpacking initramfs...
[    0.490074] debug: unmapping init [mem 0xffff880013ce6000-0xffff880013fe=
ffff]
[    0.491632] microcode: CPU0 sig=3D0x306c1, pf=3D0x1, revision=3D0x1
[    0.492419] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    0.495181] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    0.496687] BUG: unable to handle kernel paging request at ffff8800122a0=
ad0
[    0.496916] IP: [<ffffffff810b8a17>] slob_page_alloc+0x3c/0x1dc
[    0.496916] PGD 15a0063 PUD 15a4063 PMD 13cd5067 PTE 122a0160
[    0.496916] Oops: 0000 [#1] DEBUG_PAGEALLOC
[    0.496916] CPU 0=20
[    0.496916] Modules linked in:
[    0.496916]=20
[    0.496916] Pid: 1, comm: swapper Not tainted 3.5.0-rc6-00262-g4a9d4b0 #=
7 Bochs Bochs
[    0.496916] RIP: 0010:[<ffffffff810b8a17>]  [<ffffffff810b8a17>] slob_pa=
ge_alloc+0x3c/0x1dc
[    0.496916] RSP: 0018:ffff880012823bd8  EFLAGS: 00010002
[    0.496916] RAX: ffff8800122a0ad0 RBX: ffff88001229df88 RCX: 00000000000=
00038
[    0.496916] RDX: 0000000000000008 RSI: 0000000000000070 RDI: ffff8800122=
9df88
[    0.496916] RBP: ffff880012823c20 R08: ffff88001229dbc8 R09: ffffffff815=
c3410
[    0.496916] R10: 0000000000000007 R11: 0000000000000008 R12: ffff8800132=
ce740
[    0.496916] R13: 0000000000000000 R14: 0000000000000008 R15: ffff8800122=
a0ad0
[    0.496916] FS:  0000000000000000(0000) GS:ffffffff815b0000(0000) knlGS:=
0000000000000000
[    0.496916] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.496916] CR2: ffff8800122a0ad0 CR3: 000000000159f000 CR4: 00000000000=
406f0
[    0.496916] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[    0.496916] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[    0.496916] Process swapper (pid: 1, threadinfo ffff880012822000, task f=
fff88001280e810)
[    0.496916] Stack:
[    0.496916]  0000000000000007 0000003800000008 fffffffffffffff8 00000000=
00000038
[    0.496916]  ffffffff815c3410 0000000000000070 ffff8800132ce740 00000000=
00000008
[    0.496916]  0000000000000038 ffff880012823c80 ffffffff810b8c42 00000000=
00000297
[    0.496916] Call Trace:
[    0.496916]  [<ffffffff810b8c42>] slob_alloc.isra.15+0x8b/0x208
[    0.496916]  [<ffffffff810b8ea7>] kmem_cache_alloc_node+0x28/0x5f
[    0.496916]  [<ffffffff810a1419>] ? kstrdup+0x28/0x41
[    0.496916]  [<ffffffff81100d99>] sysfs_new_dirent+0x51/0x101
[    0.496916]  [<ffffffff81101120>] create_dir+0x33/0xa9
[    0.496916]  [<ffffffff81101462>] sysfs_create_dir+0x95/0xb3
[    0.496916]  [<ffffffff811813f3>] kobject_add_internal+0xca/0x1c1
[    0.496916]  [<ffffffff8118171c>] ? kobject_set_name+0x38/0x3a
[    0.496916]  [<ffffffff81181a66>] kset_register+0x20/0x3e
[    0.496916]  [<ffffffff81181ae7>] kset_create_and_add+0x63/0x7d
[    0.496916]  [<ffffffff81216835>] __bus_register+0x102/0x27b
[    0.496916]  [<ffffffff8164ea8c>] ? clocksource_done_booting+0x5a/0x5a
[    0.496916]  [<ffffffff81216dea>] subsys_system_register+0x1d/0xc1
[    0.496916]  [<ffffffff8164ea8c>] ? clocksource_done_booting+0x5a/0x5a
[    0.496916]  [<ffffffff8164ea9e>] init_clocksource_sysfs+0x12/0x52
[    0.496916]  [<ffffffff81002078>] do_one_initcall+0x78/0x131
[    0.496916]  [<ffffffff8163cca5>] kernel_init+0x14a/0x1c2
[    0.496916]  [<ffffffff8163c502>] ? do_early_param+0x8a/0x8a
[    0.496916]  [<ffffffff813e50d4>] kernel_thread_helper+0x4/0x10
[    0.496916]  [<ffffffff8163cb5b>] ? start_kernel+0x40a/0x40a
[    0.496916]  [<ffffffff813e50d0>] ? gs_change+0x13/0x13
[    0.496916] Code: 41 54 49 89 fc 53 31 db 48 83 ec 20 48 89 45 d0 48 d1 =
6d d0 48 63 c2 8b 4d d0 4c 8b 7f 20 4c 8d 50 ff 48 f7 d8 31 ff 48 89 45 c8 =
<66> 45 8b 37 b8 01 00 00 00 66 45 85 f6 44 0f 4e f0 85 d2 74 11=20
[    0.496916] RIP  [<ffffffff810b8a17>] slob_page_alloc+0x3c/0x1dc
[    0.496916]  RSP <ffff880012823bd8>
[    0.496916] CR2: ffff8800122a0ad0
[    0.496916] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.496916] Kernel panic - not syncing: Fatal exception
[    0.496916] Rebooting in 10 seconds..
Elapsed time: 5
qemu-system-x86_64 -enable-kvm -cpu Haswell,+smep,+smap -kernel /kernel/x86=
_64-randconfig-r1-07262119/4a9d4b024a3102fc083c925c242d98ac27b1c5f6/vmlinuz=
-3.5.0-rc6-00262-g4a9d4b0 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,=
115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeo=
ut=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdi=
sk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0=
 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-r1-07262119/next:m=
aster:4a9d4b024a3102fc083c925c242d98ac27b1c5f6:bisect-linux/.vmlinuz-4a9d4b=
024a3102fc083c925c242d98ac27b1c5f6-20140727021804-184-kbuild branch=3Dnext/=
master BOOT_IMAGE=3D/kernel/x86_64-randconfig-r1-07262119/4a9d4b024a3102fc0=
83c925c242d98ac27b1c5f6/vmlinuz-3.5.0-rc6-00262-g4a9d4b0 drbd.minor_count=
=3D8'  -initrd /kernel-tests/initrd/yocto-minimal-x86_64.cgz -m 320 -smp 1 =
-net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reb=
oot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-yo=
cto-kbuild-7 -serial file:/dev/shm/kboot/serial-yocto-kbuild-7 -daemonize -=
display none -monitor null=20

--G6nVm6DDWH/FONJq
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-r1-07262119-5a7439efd1c5c416f768fc550048ca130cf4bf99-BUG:-unable-to-handle-kernel-paging-request-3032.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgNWE3NDM5ZS4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxl
cyBmb3IgMjAxNDA3MjUKZ2l0IGNoZWNrb3V0IDlhM2M0MTQ1YWYzMjEyNWM1ZWUzOWMwMjcy
NjYyYjQ3MzA3YTgzMjMKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82
NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5L25leHQ6bWFzdGVyOjlhM2M0MTQ1YWYzMjEyNWM1
ZWUzOWMwMjcyNjYyYjQ3MzA3YTgzMjM6YmlzZWN0LWxpbnV4CgoyMDE0LTA3LTI2LTIyOjAz
OjEyIDlhM2M0MTQ1YWYzMjEyNWM1ZWUzOWMwMjcyNjYyYjQ3MzA3YTgzMjMgY29tcGlsaW5n
ClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0
LXJhbmRjb25maWctcjEtMDcyNjIxMTktOWEzYzQxNDVhZjMyMTI1YzVlZTM5YzAyNzI2NjJi
NDczMDdhODMyMwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctcjEtMDcyNjIxMTkvOWEzYzQxNDVhZjMyMTI1YzVlZTM5YzAyNzI2NjJiNDczMDdhODMy
Mwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUv
eDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTktOWEzYzQxNDVhZjMyMTI1YzVlZTM5YzAy
NzI2NjJiNDczMDdhODMyMwprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjEt
MDcyNjIxMTkvOWEzYzQxNDVhZjMyMTI1YzVlZTM5YzAyNzI2NjJiNDczMDdhODMyMy92bWxp
bnV6LTMuMTYuMC1yYzYKCjIwMTQtMDctMjYtMjI6MDU6MTIgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgCTIgVEVTVCBGQUlMVVJFCm1vdW50OiBtb3VudGluZyBwcm9jIG9uIC9wcm9jIGZhaWxl
ZDogTm8gc3VjaCBkZXZpY2UKZ3JlcDogL3Byb2MvZmlsZXN5c3RlbXM6IE5vIHN1Y2ggZmls
ZSBvciBkaXJlY3RvcnkKU3RhcnRpbmcgQm9vdGxvZyBkYWVtb246IApbICAgIDIuODY4MDI4
XSBCVUc6IHNwaW5sb2NrIGJhZCBtYWdpYyBvbiBDUFUjMCwgYm9vdGxvZ2QvMTk4ClsgICAg
Mi44Njk0NTZdIENQVTogMCBQSUQ6IDE5OCBDb21tOiBib290bG9nZCBOb3QgdGFpbnRlZCAz
LjE2LjAtcmM2ICMxClsgICAgMi44NzAwODVdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hz
LCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAyLjg3MDY0MV0gIDAwMDAwMDAwMDAwMDAw
MDAgZmZmZjg4MDAwMGVkM2UxMCBmZmZmZmZmZjgxNTA0ZDg5IGZmZmY4ODAwMDBlZDNlMzAK
WyAgICAyLjg3MTQxM10gIGZmZmZmZmZmODE1MDJjNzAgZmZmZjg4MDAxMjY2MTU2OCBmZmZm
ODgwMDAwZWQ2MDAwIGZmZmY4ODAwMDBlZDNlNTAKWyAgICAyLjg3MjE4M10gIGZmZmZmZmZm
ODE1MDJjOWIgZmZmZjg4MDAxMjY2MTU2OCBmZmZmZmZmZjgxNjdlNzA3IGZmZmY4ODAwMDBl
ZDNlNzgKWyAgICAyLjg3Mjk1NV0gQ2FsbCBUcmFjZToKWyAgICAyLjg3MzIwOF0gIFs8ZmZm
ZmZmZmY4MTUwNGQ4OT5dIGR1bXBfc3RhY2srMHgxOS8weDFiClsgICAgMi44NzM3MjBdICBb
PGZmZmZmZmZmODE1MDJjNzA+XSBzcGluX2R1bXArMHg4NS8weDhhClsgICAgMi44NzQyMjdd
ICBbPGZmZmZmZmZmODE1MDJjOWI+XSBzcGluX2J1ZysweDI2LzB4MjgKWyAgICAyLjg3NDcx
NV0gIFs8ZmZmZmZmZmY4MTBhMzU4Yz5dIGRvX3Jhd19zcGluX2xvY2srMHgyMS8weGJjClsg
ICAgMi44NzUyNjhdICBbPGZmZmZmZmZmODE1MDk2Y2M+XSBfcmF3X3NwaW5fbG9jaysweDEw
LzB4MTIKWyAgICAyLjg3NTgxMF0gIFs8ZmZmZmZmZmY4MTEyZWE4YT5dIGRjYWNoZV9yZWFk
ZGlyKzB4MTRmLzB4MjIwClsgICAgMi44NzYzNjddICBbPGZmZmZmZmZmODExMjAzMDA+XSBp
dGVyYXRlX2RpcisweDgzLzB4MTEyClsgICAgMi44NzY4OTJdICBbPGZmZmZmZmZmODExMjA2
ZTc+XSBTeVNfZ2V0ZGVudHMrMHg3OS8weGQ5ClsgICAgMi44Nzc0MTNdICBbPGZmZmZmZmZm
ODExMjA0NGI+XSA/IGZpbGxvbmVkaXIrMHhiYy8weGJjClsgICAgMi44NzgwMTVdICBbPGZm
ZmZmZmZmODE1MDlkYTc+XSBzeXN0ZW1fY2FsbF9mYXN0cGF0aCsweDE2LzB4MWIKCkVsYXBz
ZWQgdGltZTogNQpxZW11LXN5c3RlbS14ODZfNjQgLWVuYWJsZS1rdm0gLWNwdSBIYXN3ZWxs
LCtzbWVwLCtzbWFwIC1rZXJuZWwgL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2
MjExOS85YTNjNDE0NWFmMzIxMjVjNWVlMzljMDI3MjY2MmI0NzMwN2E4MzIzL3ZtbGludXot
My4xNi4wLXJjNiAtYXBwZW5kICdodW5nX3Rhc2tfcGFuaWM9MSBlYXJseXByaW50az10dHlT
MCwxMTUyMDAgZGVidWcgYXBpYz1kZWJ1ZyBzeXNycV9hbHdheXNfZW5hYmxlZCByY3VwZGF0
ZS5yY3VfY3B1X3N0YWxsX3RpbWVvdXQ9MTAwIHBhbmljPTEwIHNvZnRsb2NrdXBfcGFuaWM9
MSBubWlfd2F0Y2hkb2c9cGFuaWMgIHByb21wdF9yYW1kaXNrPTAgY29uc29sZT10dHlTMCwx
MTUyMDAgY29uc29sZT10dHkwIHZnYT1ub3JtYWwgIHJvb3Q9L2Rldi9yYW0wIHJ3IGxpbms9
L2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYy
MTE5L25leHQ6bWFzdGVyOjlhM2M0MTQ1YWYzMjEyNWM1ZWUzOWMwMjcyNjYyYjQ3MzA3YTgz
MjM6YmlzZWN0LWxpbnV4Ly52bWxpbnV6LTlhM2M0MTQ1YWYzMjEyNWM1ZWUzOWMwMjcyNjYy
YjQ3MzA3YTgzMjMtMjAxNDA3MjcwNjA0NTUtNTUta2J1aWxkIGJyYW5jaD1uZXh0L21hc3Rl
ciBCT09UX0lNQUdFPS9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTkvOWEz
YzQxNDVhZjMyMTI1YzVlZTM5YzAyNzI2NjJiNDczMDdhODMyMy92bWxpbnV6LTMuMTYuMC1y
YzYgZHJiZC5taW5vcl9jb3VudD04JyAgLWluaXRyZCAva2VybmVsLXRlc3RzL2luaXRyZC95
b2N0by1taW5pbWFsLXg4Nl82NC5jZ3ogLW0gMzIwIC1zbXAgMSAtbmV0IG5pYyx2bGFuPTEs
bW9kZWw9ZTEwMDAgLW5ldCB1c2VyLHZsYW49MSAtYm9vdCBvcmRlcj1uYyAtbm8tcmVib290
IC13YXRjaGRvZyBpNjMwMGVzYiAtcnRjIGJhc2U9bG9jYWx0aW1lIC1waWRmaWxlIC9kZXYv
c2htL2tib290L3BpZC15b2N0by1rYnVpbGQtMTcgLXNlcmlhbCBmaWxlOi9kZXYvc2htL2ti
b290L3NlcmlhbC15b2N0by1rYnVpbGQtMTcgLWRhZW1vbml6ZSAtZGlzcGxheSBub25lIC1t
b25pdG9yIG51bGwgCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTkvOWEz
YzQxNDVhZjMyMTI1YzVlZTM5YzAyNzI2NjJiNDczMDdhODMyMy9kbWVzZy15b2N0by1rYnVp
bGQtNjoyMDE0MDcyNjIyMDI1OTp4ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOTozLjE2
LjAtcmM2OjEKMDoxOjMgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCmJpc2VjdDogYmFk
IGNvbW1pdCA5YTNjNDE0NWFmMzIxMjVjNWVlMzljMDI3MjY2MmI0NzMwN2E4MzIzCmdpdCBj
aGVja291dCB2My4xNQpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LXJhbmRjb25maWctcjEtMDcyNjIxMTkvbmV4dDptYXN0ZXI6MTg2MGUzNzk4NzVkZmU3Mjcx
YzY0OTA1OGFlZGRmZmU1YWZkOWQwZDpiaXNlY3QtbGludXgKCjIwMTQtMDctMjYtMjI6MDU6
NDggMTg2MGUzNzk4NzVkZmU3MjcxYzY0OTA1OGFlZGRmZmU1YWZkOWQwZCBjb21waWxpbmcK
UXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQt
cmFuZGNvbmZpZy1yMS0wNzI2MjExOS0xODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVkZGZm
ZTVhZmQ5ZDBkCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1yMS0wNzI2MjExOS8xODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVkZGZmZTVhZmQ5ZDBk
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94
ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS0xODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4
YWVkZGZmZTVhZmQ5ZDBkCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0w
NzI2MjExOS8xODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVkZGZmZTVhZmQ5ZDBkL3ZtbGlu
dXotMy4xNS4wCgoyMDE0LTA3LTI2LTIyOjA3OjQ4IGRldGVjdGluZyBib290IHN0YXRlIC4g
VEVTVCBGQUlMVVJFClsgICAgMC41NDM3NDZdIG1pY3JvY29kZTogTWljcm9jb2RlIFVwZGF0
ZSBEcml2ZXI6IHYyLjAwIDx0aWdyYW5AYWl2YXppYW4uZnNuZXQuY28udWs+LCBQZXRlciBP
cnViYQpbICAgIDAuNTQ2ODE2XSBBVlggdmVyc2lvbiBvZiBnY21fZW5jL2RlYyBlbmdhZ2Vk
LgpbICAgIDAuNTQ5MDAyXSBhbGc6IE5vIHRlc3QgZm9yIF9fZ2NtLWFlcy1hZXNuaSAoX19k
cml2ZXItZ2NtLWFlcy1hZXNuaSkKWyAgICAwLjU1MDUxM10gQlVHOiB1bmFibGUgdG8gaGFu
ZGxlIGtlcm5lbCBwYWdpbmcgcmVxdWVzdCBhdCBmZmZmODgwMDEzNTQyMDAwClsgICAgMC41
NTE1MjBdIElQOiBbPGZmZmZmZmZmODEwZWRjMDQ+XSBremZyZWUrMHgxYi8weDI4ClsgICAg
MC41NTIzMDVdIFBHRCAxOTU2MDY3IFBVRCAxOTU3MDY3IFBNRCAxM2JlNzA2NyBQVEUgODAw
MDAwMDAxMzU0MjA2MApbICAgIDAuNTUzMjk5XSBPb3BzOiAwMDAyIFsjMV0gREVCVUdfUEFH
RUFMTE9DClsgICAgMC41NTMzNDFdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDAuNTUzMzQx
XSBDUFU6IDAgUElEOiA1MSBDb21tOiBjcnlwdG9tZ3JfdGVzdCBOb3QgdGFpbnRlZCAzLjE1
LjAgIzIKWyAgICAwLjU1MzM0MV0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1Mg
Qm9jaHMgMDEvMDEvMjAxMQpbICAgIDAuNTUzMzQxXSB0YXNrOiBmZmZmODgwMDEzNGYwOGMw
IHRpOiBmZmZmODgwMDEyNmZjMDAwIHRhc2sudGk6IGZmZmY4ODAwMTI2ZmMwMDAKWyAgICAw
LjU1MzM0MV0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MTBlZGMwND5dICBbPGZmZmZmZmZmODEw
ZWRjMDQ+XSBremZyZWUrMHgxYi8weDI4ClsgICAgMC41NTMzNDFdIFJTUDogMDAwMDpmZmZm
ODgwMDEyNmZmZDYwICBFRkxBR1M6IDAwMDEwMjQ2ClsgICAgMC41NTMzNDFdIFJBWDogMDAw
MDAwMDAwMDAwMDAwMCBSQlg6IGZmZmY4ODAwMTM1NDAzMTAgUkNYOiAwMDAwMDAwMDEzNTNl
NjIwClsgICAgMC41NTMzNDFdIFJEWDogMDAwMDQ4MDAwMDAwMDg4MCBSU0k6IDAwMDAwMDAw
MDAwMDAyODYgUkRJOiBmZmZmODgwMDEzNTQyMDAwClsgICAgMC41NTMzNDFdIFJCUDogZmZm
Zjg4MDAxMjZmZmQ2OCBSMDg6IDAwMDAwMDAwMDAwMDAwMDAgUjA5OiAwMDAwMDAwMDAwMDAw
MDA0ClsgICAgMC41NTMzNDFdIFIxMDogMDAwMDAwMDAwMDAwMDAwMCBSMTE6IDAwMDAwMDAw
MDAwMDA1ZTggUjEyOiBmZmZmODgwMDEzNTQwMzEwClsgICAgMC41NTMzNDFdIFIxMzogZmZm
Zjg4MDAxMjZmYWU4OCBSMTQ6IDAwMDAwMDAwMDAwMDA0MDAgUjE1OiAwMDAwMDAwMDAwMDAw
MDVmClsgICAgMC41NTMzNDFdIEZTOiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZm
ZmZmZjgxNzM5MDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjU1MzM0
MV0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzMwpb
ICAgIDAuNTUzMzQxXSBDUjI6IGZmZmY4ODAwMTM1NDIwMDAgQ1IzOiAwMDAwMDAwMDAxNzI5
MDAwIENSNDogMDAwMDAwMDAwMDA0MDZmMApbICAgIDAuNTUzMzQxXSBTdGFjazoKWyAgICAw
LjU1MzM0MV0gIGZmZmY4ODAwMTM1NDAzNTggZmZmZjg4MDAxMjZmZmQ5MCBmZmZmZmZmZjgx
MWEzOGI2IGZmZmY4ODAwMTM1NDAyYjAKWyAgICAwLjU1MzM0MV0gIGZmZmY4ODAwMTM1NDAy
NjggZmZmZmZmZmY4MTc0YWJkOCBmZmZmODgwMDEyNmZmZGEwIGZmZmZmZmZmODExYjYzMjYK
WyAgICAwLjU1MzM0MV0gIGZmZmY4ODAwMTI2ZmZkYjAgZmZmZmZmZmY4MTA1OTQwNSBmZmZm
ODgwMDEyNmZmZGQ4IGZmZmZmZmZmODExYTM4OWUKWyAgICAwLjU1MzM0MV0gQ2FsbCBUcmFj
ZToKWyAgICAwLjU1MzM0MV0gIFs8ZmZmZmZmZmY4MTFhMzhiNj5dIGNyeXB0b19kZXN0cm95
X3RmbSsweDQ4LzB4NGYKWyAgICAwLjU1MzM0MV0gIFs8ZmZmZmZmZmY4MTFiNjMyNj5dIGNy
eXB0ZF9mcmVlX2FoYXNoKzB4ZC8weGYKWyAgICAwLjU1MzM0MV0gIFs8ZmZmZmZmZmY4MTA1
OTQwNT5dIGdoYXNoX2FzeW5jX2V4aXRfdGZtKzB4ZC8weGYKWyAgICAwLjU1MzM0MV0gIFs8
ZmZmZmZmZmY4MTFhMzg5ZT5dIGNyeXB0b19kZXN0cm95X3RmbSsweDMwLzB4NGYKWyAgICAw
LjU1MzM0MV0gIFs8ZmZmZmZmZmY4MTFhYzZjOT5dIGFsZ190ZXN0X2hhc2grMHg3ZS8weDg5
ClsgICAgMC41NTMzNDFdICBbPGZmZmZmZmZmODExYWJmNzQ+XSBhbGdfdGVzdCsweDFlYy8w
eDI1MApbICAgIDAuNTUzMzQxXSAgWzxmZmZmZmZmZjgxMGExYjBkPl0gPyBfX3dha2VfdXBf
Y29tbW9uKzB4NDYvMHg3MgpbICAgIDAuNTUzMzQxXSAgWzxmZmZmZmZmZjgxMWE5OTIwPl0g
PyBjcnlwdG9tZ3Jfbm90aWZ5KzB4MzY1LzB4MzY1ClsgICAgMC41NTMzNDFdICBbPGZmZmZm
ZmZmODExYTk5NDM+XSBjcnlwdG9tZ3JfdGVzdCsweDIzLzB4M2UKWyAgICAwLjU1MzM0MV0g
IFs8ZmZmZmZmZmY4MTA5NTZlNz5dIGt0aHJlYWQrMHhlNi8weGVlClsgICAgMC41NTMzNDFd
ICBbPGZmZmZmZmZmODEwOTU2MDE+XSA/IGt0aHJlYWRfY3JlYXRlX29uX25vZGUrMHgxNzUv
MHgxNzUKWyAgICAwLjU1MzM0MV0gIFs8ZmZmZmZmZmY4MTRmNDg0YT5dIHJldF9mcm9tX2Zv
cmsrMHg3YS8weGIwClsgICAgMC41NTMzNDFdICBbPGZmZmZmZmZmODEwOTU2MDE+XSA/IGt0
aHJlYWRfY3JlYXRlX29uX25vZGUrMHgxNzUvMHgxNzUKWyAgICAwLjU1MzM0MV0gQ29kZTog
MDEgMDAgNWIgNGMgODkgZTAgNDEgNWMgNDEgNWQgNDEgNWUgNDEgNWYgNWQgYzMgNTUgNDgg
ODMgZmYgMTAgNDggODkgZTUgNTMgNDggODkgZmIgNzYgMTcgZTggZWMgYTAgMDEgMDAgNDgg
ODkgZGYgNDggODkgYzEgMzEgYzAgPGYzPiBhYSA0OCA4OSBkZiBlOCA0NSBhOSAwMSAwMCA1
YiA1ZCBjMyA1NSA0OCA4OSBlNSA0MSA1NSA0OSA4OSAKWyAgICAwLjU1MzM0MV0gUklQICBb
PGZmZmZmZmZmODEwZWRjMDQ+XSBremZyZWUrMHgxYi8weDI4ClsgICAgMC41NTMzNDFdICBS
U1AgPGZmZmY4ODAwMTI2ZmZkNjA+ClsgICAgMC41NTMzNDFdIENSMjogZmZmZjg4MDAxMzU0
MjAwMApbICAgIDAuNTUzMzQxXSAtLS1bIGVuZCB0cmFjZSBjNTU4Yzg4YWY1ZjJmZjhhIF0t
LS0KWyAgICAwLjU1MzM0MV0gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEZhdGFsIGV4
Y2VwdGlvbgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LzE4NjBlMzc5
ODc1ZGZlNzI3MWM2NDkwNThhZWRkZmZlNWFmZDlkMGQvZG1lc2cteW9jdG8ta2J1aWxkLTIw
OjIwMTQwNzI2MjIwNTQ3Ong4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5OjMuMTUuMDoy
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTkvMTg2MGUzNzk4NzVkZmU3
MjcxYzY0OTA1OGFlZGRmZmU1YWZkOWQwZC9kbWVzZy15b2N0by1rYnVpbGQtMjU6MjAxNDA3
MjYyMjA1NDk6eDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTk6My4xNS4wOjIKMDoyOjIg
YWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCmJpc2VjdDogYmFkIGNvbW1pdCB2My4xNQpn
aXQgY2hlY2tvdXQgdjMuMTQKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5L25leHQ6bWFzdGVyOjQ1NWM2ZmRiZDIxOTE2
MWJkMDliMTE2NWYxMTY5OWQ2ZDczZGUxMWM6YmlzZWN0LWxpbnV4CgoyMDE0LTA3LTI2LTIy
OjEzOjE3IDQ1NWM2ZmRiZDIxOTE2MWJkMDliMTE2NWYxMTY5OWQ2ZDczZGUxMWMgY29tcGls
aW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2
XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTktNDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjEx
Njk5ZDZkNzNkZTExYwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctcjEtMDcyNjIxMTkvNDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjExNjk5ZDZkNzNk
ZTExYwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVl
dWUveDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTktNDU1YzZmZGJkMjE5MTYxYmQwOWIx
MTY1ZjExNjk5ZDZkNzNkZTExYwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUvamFrZXRvd24tY29uc3VtZXIveDg2XzY0LXJhbmRjb25maWct
cjEtMDcyNjIxMTktNDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjExNjk5ZDZkNzNkZTExYwpr
ZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTkvNDU1YzZmZGJk
MjE5MTYxYmQwOWIxMTY1ZjExNjk5ZDZkNzNkZTExYy92bWxpbnV6LTMuMTQuMAoKMjAxNC0w
Ny0yNi0yMjoyMDoxNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJNyBURVNUIEZBSUxVUkUKL2Jp
bi9zaDogL3Byb2Mvc2VsZi9mZC85OiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5Ci9iaW4v
c2g6IC9wcm9jL3NlbGYvZmQvOTogTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQoKQlVHOiBr
ZXJuZWwgYm9vdCBoYW5nCkVsYXBzZWQgdGltZTogMzUKcWVtdS1zeXN0ZW0teDg2XzY0IC1l
bmFibGUta3ZtIC1jcHUgSGFzd2VsbCwrc21lcCwrc21hcCAta2VybmVsIC9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTkvNDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjEx
Njk5ZDZkNzNkZTExYy92bWxpbnV6LTMuMTQuMCAtYXBwZW5kICdodW5nX3Rhc2tfcGFuaWM9
MSBlYXJseXByaW50az10dHlTMCwxMTUyMDAgZGVidWcgYXBpYz1kZWJ1ZyBzeXNycV9hbHdh
eXNfZW5hYmxlZCByY3VwZGF0ZS5yY3VfY3B1X3N0YWxsX3RpbWVvdXQ9MTAwIHBhbmljPTEw
IHNvZnRsb2NrdXBfcGFuaWM9MSBubWlfd2F0Y2hkb2c9cGFuaWMgIHByb21wdF9yYW1kaXNr
PTAgY29uc29sZT10dHlTMCwxMTUyMDAgY29uc29sZT10dHkwIHZnYT1ub3JtYWwgIHJvb3Q9
L2Rldi9yYW0wIHJ3IGxpbms9L2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1y
YW5kY29uZmlnLXIxLTA3MjYyMTE5L25leHQ6bWFzdGVyOjQ1NWM2ZmRiZDIxOTE2MWJkMDli
MTE2NWYxMTY5OWQ2ZDczZGUxMWM6YmlzZWN0LWxpbnV4Ly52bWxpbnV6LTQ1NWM2ZmRiZDIx
OTE2MWJkMDliMTE2NWYxMTY5OWQ2ZDczZGUxMWMtMjAxNDA3MjYyMjE5MTctNTAta2J1aWxk
IGJyYW5jaD1uZXh0L21hc3RlciBCT09UX0lNQUdFPS9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctcjEtMDcyNjIxMTkvNDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjExNjk5ZDZkNzNkZTEx
Yy92bWxpbnV6LTMuMTQuMCBkcmJkLm1pbm9yX2NvdW50PTgnICAtaW5pdHJkIC9rZXJuZWwt
dGVzdHMvaW5pdHJkL3F1YW50YWwtY29yZS14ODZfNjQuY2d6IC1tIDMyMCAtc21wIDIgLW5l
dCBuaWMsdmxhbj0xLG1vZGVsPWUxMDAwIC1uZXQgdXNlcix2bGFuPTEgLWJvb3Qgb3JkZXI9
bmMgLW5vLXJlYm9vdCAtd2F0Y2hkb2cgaTYzMDBlc2IgLXJ0YyBiYXNlPWxvY2FsdGltZSAt
cGlkZmlsZSAvZGV2L3NobS9rYm9vdC9waWQtcXVhbnRhbC1rYnVpbGQtMTMgLXNlcmlhbCBm
aWxlOi9kZXYvc2htL2tib290L3NlcmlhbC1xdWFudGFsLWtidWlsZC0xMyAtZGFlbW9uaXpl
IC1kaXNwbGF5IG5vbmUgLW1vbml0b3IgbnVsbCAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1yMS0wNzI2MjExOS80NTVjNmZkYmQyMTkxNjFiZDA5YjExNjVmMTE2OTlkNmQ3M2RlMTFj
L2RtZXNnLXlvY3RvLWtidWlsZC05OjIwMTQwNzI2MjIxODA0Ong4Nl82NC1yYW5kY29uZmln
LXIxLTA3MjYyMTE5OjMuMTQuMDoxCjA6MTo4IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3Rz
ChtbMTszNW0yMDE0LTA3LTI2IDIyOjIwOjQ4IFJFUEVBVCBDT1VOVDogOTAgICMgL2MvYm9v
dC1iaXNlY3QvbGludXgvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKYmlzZWN0OiBiYWQgY29t
bWl0IHYzLjE0CmdpdCBjaGVja291dCB2My4xMwpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1x
dWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTkvbmV4dDptYXN0ZXI6ZDhl
YzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZTpiaXNlY3QtbGludXgKCjIw
MTQtMDctMjYtMjI6MjE6MjYgZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBl
NjRiZSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS1kOGVjMjZkN2Y4Mjg3ZjU3
ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2
ZTg4MTQyMTBmMGU2NGJlCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0
cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS1kOGVjMjZkN2Y4
Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDEtY29uc3VtZXIveDg2XzY0
LXJhbmRjb25maWctcjEtMDcyNjIxMTktZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0
MjEwZjBlNjRiZQprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIx
MTkvZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZS92bWxpbnV6LTMu
MTMuMAoKMjAxNC0wNy0yNi0yMjozMDoyNiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJNSBURVNU
IEZBSUxVUkUKWyAgICAwLjQxNTIzNF0gbWljcm9jb2RlOiBNaWNyb2NvZGUgVXBkYXRlIERy
aXZlcjogdjIuMDAgPHRpZ3JhbkBhaXZhemlhbi5mc25ldC5jby51az4sIFBldGVyIE9ydWJh
ClsgICAgMC40MTgxMDRdIGFsZzogTm8gdGVzdCBmb3IgX19nY20tYWVzLWFlc25pIChfX2Ry
aXZlci1nY20tYWVzLWFlc25pKQpbICAgIDAuNDE5MjI4XSBzaGE1MTJfc3NzZTM6IFVzaW5n
IEFWWCBvcHRpbWl6ZWQgU0hBLTUxMiBpbXBsZW1lbnRhdGlvbgpbICAgIDAuNDIwMzc1XSBC
VUc6IEJhZCBwYWdlIHN0YXRlIGluIHByb2Nlc3Mga3NvZnRpcnFkLzAgIHBmbjoxMmI2Mwpb
ICAgIDAuNDIwOTY2XSBwYWdlOmZmZmY4ODAwMTMyMTE4YzAgY291bnQ6MCBtYXBjb3VudDo0
MSBtYXBwaW5nOmZmZmY4ODAwMTJiNGQxNjggaW5kZXg6MHhmZmZmODgwMDEyYjYzZGMwClsg
ICAgMC40MjE4NThdIHBhZ2UgZmxhZ3M6IDB4NDgwMDAwMDAwODNjKHJlZmVyZW5jZWR8dXB0
b2RhdGV8ZGlydHl8bHJ1fHByaXZhdGUpClsgICAgMC40MjI2MzRdIE1vZHVsZXMgbGlua2Vk
IGluOgpbICAgIDAuNDIyOTQ5XSBDUFU6IDAgUElEOiAzIENvbW06IGtzb2Z0aXJxZC8wIE5v
dCB0YWludGVkIDMuMTMuMCAjMwpbICAgIDAuNDIzNTUzXSBIYXJkd2FyZSBuYW1lOiBCb2No
cyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMC40MjQxMTNdICAwMDAwMDAw
MDAwMDAwMDAwIGZmZmY4ODAwMTM0MzVjOTggZmZmZmZmZmY4MTRjMDhhMyBmZmZmODgwMDEz
NDM1Y2IwClsgICAgMC40MjQ4NzZdICBmZmZmZmZmZjgxMGM4MDg2IGZmZmY4ODAwMTMyMTE4
YzAgZmZmZjg4MDAxMzQzNWNlOCBmZmZmZmZmZjgxMGM4MTEwClsgICAgMC40MjU2NDVdICBm
ZmZmODgwMDEzMjExOGMwIDAwMDA0ODAwMDAwMDA4M2MgMDAwMDAwMDAwMDAwMDAwYSAwMDAw
MDAwMDAwMDAwMDAwClsgICAgMC40MjY3NTFdIENhbGwgVHJhY2U6ClsgICAgMC40MjcwMThd
ICBbPGZmZmZmZmZmODE0YzA4YTM+XSBkdW1wX3N0YWNrKzB4MTkvMHgxYgpbICAgIDAuNDI3
NTM0XSAgWzxmZmZmZmZmZjgxMGM4MDg2Pl0gYmFkX3BhZ2UrMHgxMDQvMHgxMWQKWyAgICAw
LjQyODAyOF0gIFs8ZmZmZmZmZmY4MTBjODExMD5dIGZyZWVfcGFnZXNfcHJlcGFyZSsweDcx
LzB4YjcKWyAgICAwLjQyODU5NV0gIFs8ZmZmZmZmZmY4MTBjOTdkYz5dIGZyZWVfaG90X2Nv
bGRfcGFnZSsweDFkLzB4MTE0ClsgICAgMC40MjkxNjZdICBbPGZmZmZmZmZmODEwYzk4ZjU+
XSBfX2ZyZWVfcGFnZXMrMHgyMi8weDQzClsgICAgMC40Mjk2ODBdICBbPGZmZmZmZmZmODEw
ZWRmMGE+XSBrZnJlZSsweDc0LzB4NzcKWyAgICAwLjQzMDE1MV0gIFs8ZmZmZmZmZmY4MTBk
NDM5Mj5dIGt6ZnJlZSsweDI1LzB4MjgKWyAgICAwLjQzMDYyN10gIFs8ZmZmZmZmZmY4MTE3
ZjAxZj5dIGFhX2ZyZWVfdGFza19jb250ZXh0KzB4NGQvMHg2NwpbICAgIDAuNDMxMjEyXSAg
WzxmZmZmZmZmZjgxMTg0MWRmPl0gYXBwYXJtb3JfY3JlZF9mcmVlKzB4MTEvMHgxYwpbICAg
IDAuNDMxNzcyXSAgWzxmZmZmZmZmZjgxMTdjOGUzPl0gc2VjdXJpdHlfY3JlZF9mcmVlKzB4
MTEvMHgxMwpbICAgIDAuNDMyMzQ2XSAgWzxmZmZmZmZmZjgxMDgxNjBiPl0gcHV0X2NyZWRf
cmN1KzB4M2EvMHg5MwpbICAgIDAuNDMyODU4XSAgWzxmZmZmZmZmZjgxMDkzNzRmPl0gX19y
Y3VfcHJvY2Vzc19jYWxsYmFja3MrMHg4Mi8weDkxClsgICAgMC40MzM0NzVdICBbPGZmZmZm
ZmZmODEwOTM3NmU+XSByY3VfcHJvY2Vzc19jYWxsYmFja3MrMHgxMC8weDFlClsgICAgMC40
MzQwNjNdICBbPGZmZmZmZmZmODEwNmMyMDY+XSBfX2RvX3NvZnRpcnErMHhiNi8weDFiNwpb
ICAgIDAuNDM0NTkzXSAgWzxmZmZmZmZmZjgxMDZjMzI2Pl0gcnVuX2tzb2Z0aXJxZCsweDFm
LzB4NTAKWyAgICAwLjQzNTEyM10gIFs8ZmZmZmZmZmY4MTA4MmQ0ZT5dIHNtcGJvb3RfdGhy
ZWFkX2ZuKzB4MTI3LzB4MTQxClsgICAgMC40MzU2OTNdICBbPGZmZmZmZmZmODEwODJjMjc+
XSA/IFN5U19zZXRncm91cHMrMHhkMi8weGQyClsgICAgMC40MzYyNDhdICBbPGZmZmZmZmZm
ODEwN2UwYmI+XSBrdGhyZWFkKzB4ZTYvMHhlZQpbICAgIDAuNDM2NzI0XSAgWzxmZmZmZmZm
ZjgxMDdkZmQ1Pl0gPyBrdGhyZWFkX2NyZWF0ZV9vbl9ub2RlKzB4MTc1LzB4MTc1ClsgICAg
MC40MzczNjRdICBbPGZmZmZmZmZmODE0YzVmNGE+XSByZXRfZnJvbV9mb3JrKzB4N2EvMHhi
MApbICAgIDAuNDM3ODgwXSAgWzxmZmZmZmZmZjgxMDdkZmQ1Pl0gPyBrdGhyZWFkX2NyZWF0
ZV9vbl9ub2RlKzB4MTc1LzB4MTc1ClsgICAgMC40Mzg1MTFdIERpc2FibGluZyBsb2NrIGRl
YnVnZ2luZyBkdWUgdG8ga2VybmVsIHRhaW50ClsgICAgMC40NDEyNDRdIEluaXRpYWxpc2Ug
c3lzdGVtIHRydXN0ZWQga2V5cmluZwpbICAgIDAuNDQxNzEyXSBhdWRpdDogaW5pdGlhbGl6
aW5nIG5ldGxpbmsgc29ja2V0IChkaXNhYmxlZCkKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1yMS0wNzI2MjExOS9kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJl
L2RtZXNnLXlvY3RvLWtidWlsZC0yOToyMDE0MDcyNjIyMjg0NDp4ODZfNjQtcmFuZGNvbmZp
Zy1yMS0wNzI2MjExOTozLjEzLjA6Mwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3
MjYyMTE5L2Q4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUvZG1lc2ct
eW9jdG8ta2J1aWxkLTc6MjAxNDA3MjYyMjI4Mzc6eDg2XzY0LXJhbmRjb25maWctcjEtMDcy
NjIxMTk6My4xMy4wOjMKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS9k
OGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlL2RtZXNnLXlvY3RvLWti
dWlsZC0zOjIwMTQwNzI2MjIyODQ4Ong4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5OjMu
MTMuMDozCjA6Mzo4IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpiaXNlY3Q6IGJhZCBj
b21taXQgdjMuMTMKZ2l0IGNoZWNrb3V0IHYzLjEyCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVu
LXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS9uZXh0Om1hc3Rlcjo1
ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyOmJpc2VjdC1saW51eAoK
MjAxNC0wNy0yNi0yMjozMTowMSA1ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZh
NWNlYjUyIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LTVlMDFkYzdiMjZkOWYy
NGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LzVlMDFkYzdiMjZkOWYyNGYzOWFiYWNl
NWRhOThjY2JkNmE1Y2ViNTIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRl
c3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LTVlMDFkYzdi
MjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIKa2VybmVsOiAva2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LzVlMDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThj
Y2JkNmE1Y2ViNTIvdm1saW51ei0zLjEyLjAKCjIwMTQtMDctMjYtMjI6MzM6MDEgZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgCTYgVEVTVCBGQUlMVVJFClN0YXJ0aW5nIEJvb3Rsb2cgZGFlbW9u
OiBib290bG9nZDogY2Fubm90IGFsbG9jYXRlIHBzZXVkbyB0dHk6IE5vIHN1Y2ggZmlsZSBv
ciBkaXJlY3RvcnkKYm9vdGxvZ2QuCm1vdW50OiBjYW4ndCByZWFkICcvcHJvYy9tb3VudHMn
OiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5ClsgICAgMi43Njk1NzJdIEJVRzogdW5hYmxl
IHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0IDAwMDAwMDAw
MDAwMDAwMTkKWyAgICAyLjc3MDAwN10gSVA6IFs8ZmZmZmZmZmY4MTEwODY4NT5dIF9fZF9s
b29rdXArMHg2ZC8weDE0YgpbICAgIDIuNzcwMDA3XSBQR0QgMTFjZDMwNjcgUFVEIDExY2Q4
MDY3IFBNRCAwIApbICAgIDIuNzcwMDA3XSBPb3BzOiAwMDAwIFsjMV0gREVCVUdfUEFHRUFM
TE9DClsgICAgMi43NzAwMDddIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDIuNzcwMDA3XSBD
UFU6IDAgUElEOiAxNzQgQ29tbTogcmMgTm90IHRhaW50ZWQgMy4xMi4wICM0ClsgICAgMi43
NzAwMDddIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIw
MTEKWyAgICAyLjc3MDAwN10gdGFzazogZmZmZjg4MDAxMWM3NTg0MCB0aTogZmZmZjg4MDAx
MWNiYzAwMCB0YXNrLnRpOiBmZmZmODgwMDExY2JjMDAwClsgICAgMi43NzAwMDddIFJJUDog
MDAxMDpbPGZmZmZmZmZmODExMDg2ODU+XSAgWzxmZmZmZmZmZjgxMTA4Njg1Pl0gX19kX2xv
b2t1cCsweDZkLzB4MTRiClsgICAgMi43NzAwMDddIFJTUDogMDAxODpmZmZmODgwMDExY2Jk
YzgwICBFRkxBR1M6IDAwMDEwMjAyClsgICAgMi43NzAwMDddIFJBWDogZmZmZjg4MDAxMWNi
ZGZkOCBSQlg6IGZmZmY4ODAwMTFjYmRkZjAgUkNYOiAwMDAwMDAwMDAwMDAwMDEwClsgICAg
Mi43NzAwMDddIFJEWDogZmZmZjg4MDAxM2M0YTgyMCBSU0k6IGZmZmY4ODAwMTFjYmRkZjAg
UkRJOiBmZmZmODgwMDEzNjhjNTYwClsgICAgMi43NzAwMDddIFJCUDogZmZmZjg4MDAxMWNi
ZGNjMCBSMDg6IDgwODA4MDgwODA4MDgwODAgUjA5OiBmZWZlZmVmZWZlZmVmZWZmClsgICAg
Mi43NzAwMDddIFIxMDogMmYyZjJmMmYyZjJmMmYyZiBSMTE6IGZlZmVmZWZmNjc3MjJkNjQg
UjEyOiBmZmZmODgwMDExY2JkZDQ4ClsgICAgMi43NzAwMDddIFIxMzogMDAwMDAwMDAwMDAw
MDAwMSBSMTQ6IGZmZmY4ODAwMTM2OGM1NjAgUjE1OiAwMDAwMDAwMDRhNzk4MzI4ClsgICAg
Mi43NzAwMDddIEZTOiAgMDAwMDdmOTViMzVmMDcwMCgwMDAwKSBHUzpmZmZmZmZmZjgxNmU2
MDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgICAyLjc3MDAwN10gQ1M6ICAw
MDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzMwpbICAgIDIuNzcw
MDA3XSBDUjI6IDAwMDAwMDAwMDAwMDAwMTkgQ1IzOiAwMDAwMDAwMDExY2UwMDAwIENSNDog
MDAwMDAwMDAwMDA0MDZmMApbICAgIDIuNzcwMDA3XSBTdGFjazoKWyAgICAyLjc3MDAwN10g
IGZmZmY4ODAwMTM2N2MwMGEgZmZmZjg4MDAxMzUzY2NhOCAwMDAwMDAxNDExY2JkZDAwIGZm
ZmY4ODAwMTFjYmRkZTAKWyAgICAyLjc3MDAwN10gIGZmZmY4ODAwMTFjYmRkNDggMDAwMDAw
MDAwMDAwMDAwMSBmZmZmODgwMDExY2JkZDQwIGZmZmY4ODAwMTFjYmRkZTAKWyAgICAyLjc3
MDAwN10gIGZmZmY4ODAwMTFjYmRkMTAgZmZmZmZmZmY4MTBmZTE1MCBmZmZmODgwMDEzNjdj
MDBhIGZmZmY4ODAwMTM0MDJmMjAKWyAgICAyLjc3MDAwN10gQ2FsbCBUcmFjZToKWyAgICAy
Ljc3MDAwN10gIFs8ZmZmZmZmZmY4MTBmZTE1MD5dIGxvb2t1cF9mYXN0KzB4MTZjLzB4MjJl
ClsgICAgMi43NzAwMDddICBbPGZmZmZmZmZmODEwZmZlMjY+XSBwYXRoX2xvb2t1cGF0KzB4
NjA3LzB4NzZjClsgICAgMi43NzAwMDddICBbPGZmZmZmZmZmODEwZmZmYWY+XSBmaWxlbmFt
ZV9sb29rdXArMHgyNC8weDk1ClsgICAgMi43NzAwMDddICBbPGZmZmZmZmZmODExMDI1OWI+
XSB1c2VyX3BhdGhfYXRfZW1wdHkrMHg1NC8weDg3ClsgICAgMi43NzAwMDddICBbPGZmZmZm
ZmZmODExMDI1ZGE+XSB1c2VyX3BhdGhfYXQrMHhjLzB4ZQpbICAgIDIuNzcwMDA3XSAgWzxm
ZmZmZmZmZjgxMGY5MmY3Pl0gdmZzX2ZzdGF0YXQrMHg0NC8weDkxClsgICAgMi43NzAwMDdd
ICBbPGZmZmZmZmZmODEwZjkzNWE+XSB2ZnNfc3RhdCsweDE2LzB4MTgKWyAgICAyLjc3MDAw
N10gIFs8ZmZmZmZmZmY4MTBmOTcwMj5dIFN5U19uZXdzdGF0KzB4MTUvMHgyZQpbICAgIDIu
NzcwMDA3XSAgWzxmZmZmZmZmZjgxMDY5YWM4Pl0gPyB0YXNrX3N0b3BwZWRfY29kZSsweDQx
LzB4NDEKWyAgICAyLjc3MDAwN10gIFs8ZmZmZmZmZmY4MTRjMDJmNz5dIHN5c3RlbV9jYWxs
X2Zhc3RwYXRoKzB4MTYvMHgxYgpbICAgIDIuNzcwMDA3XSBDb2RlOiA2OCAwMCA0OCA4YiAx
NSA4NSA3YSA2OCAwMCA0OCA4ZCAxNCBjMiA0OCA4YiAwNCAyNSA2MCA1MCA2ZSA4MSBmZiA4
MCA0NCBlMCBmZiBmZiA0YyA4YiAyYSA0OSA4MyBlNSBmZSA0ZCA4NSBlZCAwZiA4NCBiYiAw
MCAwMCAwMCA8NDU+IDM5IDdkIDE4IDBmIDg1IGE4IDAwIDAwIDAwIDQ5IDhkIDQ1IDUwIDQ4
IDg5IGM3IDQ4IDg5IDQ1IGM4IApbICAgIDIuNzcwMDA3XSBSSVAgIFs8ZmZmZmZmZmY4MTEw
ODY4NT5dIF9fZF9sb29rdXArMHg2ZC8weDE0YgpbICAgIDIuNzcwMDA3XSAgUlNQIDxmZmZm
ODgwMDExY2JkYzgwPgpbICAgIDIuNzcwMDA3XSBDUjI6IDAwMDAwMDAwMDAwMDAwMTkKWyAg
ICAyLjc5MTkwNV0gLS0tWyBlbmQgdHJhY2UgN2ZiNGJkNGQ4Yjk3ZDYyMSBdLS0tClsgICAg
Mi43OTIzNDBdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBGYXRhbCBleGNlcHRpb24K
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS81ZTAxZGM3YjI2ZDlmMjRm
MzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyL2RtZXNnLXlvY3RvLWtidWlsZC0zOjIwMTQwNzI2
MjIzMDUyOng4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5OjMuMTIuMDo0Ci9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTkvNWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1
ZGE5OGNjYmQ2YTVjZWI1Mi9kbWVzZy15b2N0by1rYnVpbGQtOToyMDE0MDcyNjIyMzA1MTp4
ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOTozLjEyLjA6NAova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXIxLTA3MjYyMTE5LzVlMDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2Jk
NmE1Y2ViNTIvZG1lc2cteW9jdG8ta2J1aWxkLTI4OjIwMTQwNzI2MjIzMTAyOng4Nl82NC1y
YW5kY29uZmlnLXIxLTA3MjYyMTE5OjMuMTIuMDo0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctcjEtMDcyNjIxMTkvNWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1
Mi9kbWVzZy15b2N0by1rYnVpbGQtOToyMDE0MDcyNjIyMzEwNTp4ODZfNjQtcmFuZGNvbmZp
Zy1yMS0wNzI2MjExOTozLjEyLjA6NAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3
MjYyMTE5LzVlMDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIvZG1lc2ct
eW9jdG8ta2J1aWxkLTQ6MjAxNDA3MjYyMjMxMjI6eDg2XzY0LXJhbmRjb25maWctcjEtMDcy
NjIxMTk6My4xMi4wOjQKMDo1OjExIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpiaXNl
Y3Q6IGJhZCBjb21taXQgdjMuMTIKZ2l0IGNoZWNrb3V0IHYzLjExCmxzIC1hIC9rYnVpbGQt
dGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS9uZXh0
Om1hc3Rlcjo2ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlOmJpc2Vj
dC1saW51eAoKMjAxNC0wNy0yNi0yMjozMzozNCA2ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5
NTdmNzBhOTRjMTkyMTNlIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LTZlNDY2
NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UKQ2hlY2sgZm9yIGtlcm5lbCBp
biAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LzZlNDY2NDUyNWIxZGIy
OGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5
LTZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UKa2VybmVsOiAva2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LzZlNDY2NDUyNWIxZGIyOGY4YzRl
MTEzMDk1N2Y3MGE5NGMxOTIxM2Uvdm1saW51ei0zLjExLjAKCjIwMTQtMDctMjYtMjI6MzU6
MzQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTggVEVTVCBGQUlMVVJFClsgICAgMS4xMDcxNzdd
IG1pY3JvY29kZTogTWljcm9jb2RlIFVwZGF0ZSBEcml2ZXI6IHYyLjAwIDx0aWdyYW5AYWl2
YXppYW4uZnNuZXQuY28udWs+LCBQZXRlciBPcnViYQpbICAgIDEuMTExNjQ0XSBhbGc6IE5v
IHRlc3QgZm9yIF9fZ2NtLWFlcy1hZXNuaSAoX19kcml2ZXItZ2NtLWFlcy1hZXNuaSkKWyAg
ICAxLjExMzc0NF0gc2hhNTEyX3Nzc2UzOiBVc2luZyBBVlggb3B0aW1pemVkIFNIQS01MTIg
aW1wbGVtZW50YXRpb24KWyAgICAxLjExNzc5NF0gQlVHOiBCYWQgcGFnZSBzdGF0ZSBpbiBw
cm9jZXNzIGNyeXB0b21ncl90ZXN0ICBwZm46MGZiMjAKWyAgICAxLjExODk4MV0gcGFnZTpm
ZmZmODgwMDExZDUwODAwIGNvdW50OjAgbWFwY291bnQ6MCBtYXBwaW5nOmZmZmY4ODAwMGZi
MTdkNDggaW5kZXg6MHgwClsgICAgMS4xMjA0NjBdIHBhZ2UgZmxhZ3M6IDB4MjgwMDAwMDAw
MDNjKHJlZmVyZW5jZWR8dXB0b2RhdGV8ZGlydHl8bHJ1KQpbICAgIDEuMTIxNzk3XSBNb2R1
bGVzIGxpbmtlZCBpbjoKWyAgICAxLjEyMjQwNF0gQ1BVOiAwIFBJRDogOTcgQ29tbTogY3J5
cHRvbWdyX3Rlc3QgTm90IHRhaW50ZWQgMy4xMS4wICM1ClsgICAgMS4xMjM1OTBdIEhhcmR3
YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAxLjEy
NDY0OV0gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAxMjBmZmEwOCBmZmZmZmZmZjgxNGFk
ZTAwIGZmZmY4ODAwMTIwZmZhMjAKWyAgICAxLjEyNjEwOF0gIGZmZmZmZmZmODEwYzdmNWUg
ZmZmZjg4MDAxMWQ1MDgwMCBmZmZmODgwMDEyMGZmYTU4IGZmZmZmZmZmODEwYzdmZTgKWyAg
ICAxLjEyNzU3MV0gIGZmZmY4ODAwMTFkNTA4MDAgMDAwMDI4MDAwMDAwMDAzYyAwMDAwMDAw
MDAwMDAwMDA0IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAxLjEyOTAyOV0gQ2FsbCBUcmFjZToK
WyAgICAxLjEyOTUxMl0gIFs8ZmZmZmZmZmY4MTRhZGUwMD5dIGR1bXBfc3RhY2srMHgxOS8w
eDFiClsgICAgMS4xMzA0OTNdICBbPGZmZmZmZmZmODEwYzdmNWU+XSBiYWRfcGFnZSsweDEw
NC8weDExZApbICAgIDEuMTMxNDQwXSAgWzxmZmZmZmZmZjgxMGM3ZmU4Pl0gZnJlZV9wYWdl
c19wcmVwYXJlKzB4NzEvMHhiNwpbICAgIDEuMTMyNTA5XSAgWzxmZmZmZmZmZjgxMGM5NTlk
Pl0gZnJlZV9ob3RfY29sZF9wYWdlKzB4MWQvMHgxMTQKWyAgICAxLjEzMzYxN10gIFs8ZmZm
ZmZmZmY4MTBjOTZiNj5dIF9fZnJlZV9wYWdlcysweDIyLzB4M2QKWyAgICAxLjEzNDYwOV0g
IFs8ZmZmZmZmZmY4MTBlY2ViMj5dIGtmcmVlKzB4NzQvMHg3NwpbICAgIDEuMTM1NDg3XSAg
WzxmZmZmZmZmZjgxMDc2YjU2Pl0gY2FsbF91c2VybW9kZWhlbHBlcl9mcmVlaW5mbysweDFi
LzB4MWUKWyAgICAxLjEzNjcyMl0gIFs8ZmZmZmZmZmY4MTA3NzBiOD5dIGNhbGxfdXNlcm1v
ZGVoZWxwZXJfZXhlYysweGQ3LzB4MTBjClsgICAgMS4xMzc5MDhdICBbPGZmZmZmZmZmODEw
NzcyOWU+XSBfX3JlcXVlc3RfbW9kdWxlKzB4MWIxLzB4MWUzClsgICAgMS4xMzg5MDhdICBb
PGZmZmZmZmZmODExODQ2NWU+XSBjcnlwdG9fbGFydmFsX2xvb2t1cCsweDUxLzB4MTI5Clsg
ICAgMS4xNDAwMjJdICBbPGZmZmZmZmZmODExODQ4M2U+XSBjcnlwdG9fYWxnX21vZF9sb29r
dXArMHgxZS8weDZhClsgICAgMS4xNDExNDNdICBbPGZmZmZmZmZmODExODRhMjg+XSBjcnlw
dG9fYWxsb2NfYmFzZSsweDJkLzB4ODIKWyAgICAxLjE0MjIwNF0gIFs8ZmZmZmZmZmY4MTE5
Nzg4MD5dIGNyeXB0ZF9hbGxvY19hYmxrY2lwaGVyKzB4NWEvMHg4ZQpbICAgIDEuMTQzMzY5
XSAgWzxmZmZmZmZmZjgxMWNhNDAwPl0gPyBzY25wcmludGYrMHgxZi8weDNiClsgICAgMS4x
NDQzMzddICBbPGZmZmZmZmZmODEwMmRiZjY+XSBhYmxrX2luaXRfY29tbW9uKzB4MTQvMHgy
ZQpbICAgIDEuMTQ1Mzc0XSAgWzxmZmZmZmZmZjgxMDJkYzQ3Pl0gYWJsa19pbml0KzB4Mzcv
MHgzZQpbICAgIDEuMTQ2Mjk3XSAgWzxmZmZmZmZmZjgxMGVjYjEwPl0gPyBfX2ttYWxsb2Nf
bm9kZSsweDMzLzB4NjYKWyAgICAxLjE0NzM1OF0gIFs8ZmZmZmZmZmY4MTE4NDliMT5dIF9f
Y3J5cHRvX2FsbG9jX3RmbSsweGMyLzB4MTBjClsgICAgMS4xNDg0NTRdICBbPGZmZmZmZmZm
ODExODc3MGY+XSBjcnlwdG9fYWxsb2NfYWJsa2NpcGhlcisweDU3LzB4OTYKWyAgICAxLjE0
OTYyOV0gIFs8ZmZmZmZmZmY4MTE4ZGJhYj5dIGFsZ190ZXN0X3NrY2lwaGVyKzB4MWQvMHg5
NgpbICAgIDEuMTUwNzEwXSAgWzxmZmZmZmZmZjgxMThkMjllPl0gYWxnX3Rlc3QrMHgxZWEv
MHgyM2QKWyAgICAxLjE1MTY3Nl0gIFs8ZmZmZmZmZmY4MTA4NGVhOT5dID8gZGVmYXVsdF93
YWtlX2Z1bmN0aW9uKzB4ZC8weGYKWyAgICAxLjE1MjgwOF0gIFs8ZmZmZmZmZmY4MTA4M2U5
Nz5dID8gX193YWtlX3VwX2NvbW1vbisweDQ2LzB4NzIKWyAgICAxLjE1Mzg4OV0gIFs8ZmZm
ZmZmZmY4MTE4YWM1Mz5dID8gY3J5cHRvbWdyX25vdGlmeSsweDM2Yy8weDM2YwpbICAgIDEu
MTU1MDA1XSAgWzxmZmZmZmZmZjgxMThhYzc2Pl0gY3J5cHRvbWdyX3Rlc3QrMHgyMy8weDNl
ClsgICAgMS4xNTU5OTNdICBbPGZmZmZmZmZmODEwN2UwMTI+XSBrdGhyZWFkKzB4YzYvMHhj
ZQpbICAgIDEuMTU2NzQ2XSAgWzxmZmZmZmZmZjgxMDdkZjRjPl0gPyBrdGhyZWFkX2NyZWF0
ZV9vbl9ub2RlKzB4MTBjLzB4MTBjClsgICAgMS4xNTc3MzBdICBbPGZmZmZmZmZmODE0YjM0
M2E+XSByZXRfZnJvbV9mb3JrKzB4N2EvMHhiMApbICAgIDEuMTU4NTU1XSAgWzxmZmZmZmZm
ZjgxMDdkZjRjPl0gPyBrdGhyZWFkX2NyZWF0ZV9vbl9ub2RlKzB4MTBjLzB4MTBjClsgICAg
MS4xNTk1MzFdIERpc2FibGluZyBsb2NrIGRlYnVnZ2luZyBkdWUgdG8ga2VybmVsIHRhaW50
ClsgICAgMS4xNjE2MTldIEluaXRpYWxpc2UgbW9kdWxlIHZlcmlmaWNhdGlvbgpbICAgIDEu
MTYyMzE4XSBhdWRpdDogaW5pdGlhbGl6aW5nIG5ldGxpbmsgc29ja2V0IChkaXNhYmxlZCkK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS82ZTQ2NjQ1MjViMWRiMjhm
OGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlL2RtZXNnLXlvY3RvLWtidWlsZC0xMToyMDE0MDcy
NjIyMzMxODp4ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOTozLjExLjA6NQova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEz
MDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2cteW9jdG8ta2J1aWxkLTE1OjIwMTQwNzI2MjIzMzE4
Ong4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5OjMuMTEuMDo1Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctcjEtMDcyNjIxMTkvNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3Zjcw
YTk0YzE5MjEzZS9kbWVzZy15b2N0by1rYnVpbGQtMTc6MjAxNDA3MjYyMjMzMTc6eDg2XzY0
LXJhbmRjb25maWctcjEtMDcyNjIxMTk6My4xMS4wOjUKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1yMS0wNzI2MjExOS82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTky
MTNlL2RtZXNnLXlvY3RvLWtidWlsZC0xODoyMDE0MDcyNjIyMzMyMDp4ODZfNjQtcmFuZGNv
bmZpZy1yMS0wNzI2MjExOTozLjExLjA6NQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIx
LTA3MjYyMTE5LzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1l
c2cteW9jdG8ta2J1aWxkLTE5OjIwMTQwNzI2MjIzMzIwOng4Nl82NC1yYW5kY29uZmlnLXIx
LTA3MjYyMTE5OjMuMTEuMDo1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIx
MTkvNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZS9kbWVzZy15b2N0
by1rYnVpbGQtMjM6MjAxNDA3MjYyMjMzMjA6eDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIx
MTk6My4xMS4wOjUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS82ZTQ2
NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlL2RtZXNnLXlvY3RvLWtidWls
ZC0yNDoyMDE0MDcyNjIyMzMyMDp4ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOTozLjEx
LjA6NQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LzZlNDY2NDUyNWIx
ZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2cteW9jdG8ta2J1aWxkLTI4OjIw
MTQwNzI2MjIzMzIwOng4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5OjMuMTEuMDo1Ci9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTkvNmU0NjY0NTI1YjFkYjI4Zjhj
NGUxMTMwOTU3ZjcwYTk0YzE5MjEzZS9kbWVzZy15b2N0by1rYnVpbGQtMzA6MjAxNDA3MjYy
MjMzMjA6eDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTk6My4xMS4wOjUKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5
NTdmNzBhOTRjMTkyMTNlL2RtZXNnLXlvY3RvLWtidWlsZC0zMToyMDE0MDcyNjIyMzMyMDp4
ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOTozLjExLjA6NQova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXIxLTA3MjYyMTE5LzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5
NGMxOTIxM2UvZG1lc2cteW9jdG8ta2J1aWxkLTE1OjIwMTQwNzI2MjIzMzI4Ong4Nl82NC1y
YW5kY29uZmlnLXIxLTA3MjYyMTE5OjMuMTEuMDo1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctcjEtMDcyNjIxMTkvNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEz
ZS9kbWVzZy15b2N0by1rYnVpbGQtMToyMDE0MDcyNjIyMzMyODp4ODZfNjQtcmFuZGNvbmZp
Zy1yMS0wNzI2MjExOTozLjExLjA6NQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3
MjYyMTE5LzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2ct
eW9jdG8ta2J1aWxkLTI0OjIwMTQwNzI2MjIzMzMxOng4Nl82NC1yYW5kY29uZmlnLXIxLTA3
MjYyMTE5OjMuMTEuMDo1Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTkv
NmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZS9kbWVzZy15b2N0by1r
YnVpbGQtMjg6MjAxNDA3MjYyMjMzMzE6eDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTk6
My4xMS4wOjUKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS82ZTQ2NjQ1
MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlL2RtZXNnLXlvY3RvLWtidWlsZC01
OjIwMTQwNzI2MjIzMzMyOng4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5OjMuMTEuMDo1
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTkvNmU0NjY0NTI1YjFkYjI4
ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZS9kbWVzZy15b2N0by1rYnVpbGQtMTQ6MjAxNDA3
MjYyMjMzMzg6eDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTk6My4xMS4wOjUKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTEx
MzA5NTdmNzBhOTRjMTkyMTNlL2RtZXNnLXlvY3RvLWtidWlsZC0zMToyMDE0MDcyNjIyMzM0
NDp4ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOTozLjExLjA6NQova2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LzZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3
MGE5NGMxOTIxM2UvZG1lc2cteW9jdG8ta2J1aWxkLTE0OjIwMTQwNzI2MjIzMzQ5Ong4Nl82
NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5OjMuMTEuMDo1CjA6MTg6MjYgYWxsX2dvb2Q6YmFk
OmFsbF9iYWQgYm9vdHMKCmJpc2VjdDogYmFkIGNvbW1pdCB2My4xMQpnaXQgY2hlY2tvdXQg
djMuMTAKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29u
ZmlnLXIxLTA3MjYyMTE5L25leHQ6bWFzdGVyOjhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3
N2YzYWM5ZjA3OWUzNzY6YmlzZWN0LWxpbnV4CgoyMDE0LTA3LTI2LTIyOjM2OjA4IDhiYjQ5
NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYgY29tcGlsaW5nClF1ZXVlZCBi
dWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25m
aWctcjEtMDcyNjIxMTktOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3
NgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjEtMDcy
NjIxMTkvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ngp3YWl0aW5n
IGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJh
bmRjb25maWctcjEtMDcyNjIxMTktOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlm
MDc5ZTM3Ngp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQt
cXVldWUvamFrZXRvd24tY29uc3VtZXIveDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTkt
OGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3NgprZXJuZWw6IC9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTkvOGJiNDk1ZTNmMDI0MDFlZTZmNzZk
MWIxZDc3ZjNhYzlmMDc5ZTM3Ni92bWxpbnV6LTMuMTAuMAoKMjAxNC0wNy0yNi0yMjo0MTow
OCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJOAkxOSBURVNUIEZBSUxVUkUKL2Jpbi9zaDogL3By
b2Mvc2VsZi9mZC85OiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5Ci9iaW4vc2g6IC9wcm9j
L3NlbGYvZmQvOTogTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQoKQlVHOiBrZXJuZWwgYm9v
dCBoYW5nCkVsYXBzZWQgdGltZTogMzUKcWVtdS1zeXN0ZW0teDg2XzY0IC1lbmFibGUta3Zt
IC1jcHUgSGFzd2VsbCwrc21lcCwrc21hcCAta2VybmVsIC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctcjEtMDcyNjIxMTkvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5
ZTM3Ni92bWxpbnV6LTMuMTAuMCAtYXBwZW5kICdodW5nX3Rhc2tfcGFuaWM9MSBlYXJseXBy
aW50az10dHlTMCwxMTUyMDAgZGVidWcgYXBpYz1kZWJ1ZyBzeXNycV9hbHdheXNfZW5hYmxl
ZCByY3VwZGF0ZS5yY3VfY3B1X3N0YWxsX3RpbWVvdXQ9MTAwIHBhbmljPTEwIHNvZnRsb2Nr
dXBfcGFuaWM9MSBubWlfd2F0Y2hkb2c9cGFuaWMgIHByb21wdF9yYW1kaXNrPTAgY29uc29s
ZT10dHlTMCwxMTUyMDAgY29uc29sZT10dHkwIHZnYT1ub3JtYWwgIHJvb3Q9L2Rldi9yYW0w
IHJ3IGxpbms9L2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmln
LXIxLTA3MjYyMTE5L25leHQ6bWFzdGVyOjhiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2Yz
YWM5ZjA3OWUzNzY6YmlzZWN0LWxpbnV4Ly52bWxpbnV6LThiYjQ5NWUzZjAyNDAxZWU2Zjc2
ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYtMjAxNDA3MjYyMjQwMjMtMzIta2J1aWxkIGJyYW5jaD1u
ZXh0L21hc3RlciBCT09UX0lNQUdFPS9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjEtMDcy
NjIxMTkvOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ni92bWxpbnV6
LTMuMTAuMCBkcmJkLm1pbm9yX2NvdW50PTgnICAtaW5pdHJkIC9rZXJuZWwtdGVzdHMvaW5p
dHJkL3F1YW50YWwtY29yZS14ODZfNjQuY2d6IC1tIDMyMCAtc21wIDIgLW5ldCBuaWMsdmxh
bj0xLG1vZGVsPWUxMDAwIC1uZXQgdXNlcix2bGFuPTEgLWJvb3Qgb3JkZXI9bmMgLW5vLXJl
Ym9vdCAtd2F0Y2hkb2cgaTYzMDBlc2IgLXJ0YyBiYXNlPWxvY2FsdGltZSAtcGlkZmlsZSAv
ZGV2L3NobS9rYm9vdC9waWQtcXVhbnRhbC1rYnVpbGQtMTAgLXNlcmlhbCBmaWxlOi9kZXYv
c2htL2tib290L3NlcmlhbC1xdWFudGFsLWtidWlsZC0xMCAtZGFlbW9uaXplIC1kaXNwbGF5
IG5vbmUgLW1vbml0b3IgbnVsbCAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2
MjExOS84YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2L2RtZXNnLXlv
Y3RvLWtidWlsZC0yOToyMDE0MDcyNjIyNDAwMzp4ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2
MjExOTozLjEwLjA6MgoxMDoxOjEwIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTsz
NW0yMDE0LTA3LTI2IDIyOjQyOjA5IFJFUEVBVCBDT1VOVDogMjEwICAjIC9jL2Jvb3QtYmlz
ZWN0L2xpbnV4L29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCmJpc2VjdDogYmFkIGNvbW1pdCB2
My4xMApnaXQgY2hlY2tvdXQgdjMuOQpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9r
dm0veDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTkvbmV4dDptYXN0ZXI6YzFiZTVhNWIx
YjM1NWQ0MGU2Y2Y3OWNjOTc5ZWI2NmRhZmEyNGFkMTpiaXNlY3QtbGludXgKCjIwMTQtMDct
MjYtMjI6NDI6MTIgYzFiZTVhNWIxYjM1NWQ0MGU2Y2Y3OWNjOTc5ZWI2NmRhZmEyNGFkMSBj
b21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1
ZS94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS1jMWJlNWE1YjFiMzU1ZDQwZTZjZjc5
Y2M5NzllYjY2ZGFmYTI0YWQxCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1yMS0wNzI2MjExOS9jMWJlNWE1YjFiMzU1ZDQwZTZjZjc5Y2M5NzllYjY2
ZGFmYTI0YWQxCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS1jMWJlNWE1YjFiMzU1ZDQw
ZTZjZjc5Y2M5NzllYjY2ZGFmYTI0YWQxCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1yMS0wNzI2MjExOS9jMWJlNWE1YjFiMzU1ZDQwZTZjZjc5Y2M5NzllYjY2ZGFmYTI0
YWQxL3ZtbGludXotMy45LjAKCjIwMTQtMDctMjYtMjI6NDQ6MTIgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkxLgkyLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4JNgkyNCBURVNUIEZBSUxVUkUKL2Jpbi9zaDogL3Byb2Mvc2VsZi9mZC85
OiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5Ci9iaW4vc2g6IC9wcm9jL3NlbGYvZmQvOTog
Tm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQoKQlVHOiBrZXJuZWwgYm9vdCBoYW5nCkVsYXBz
ZWQgdGltZTogMzUKcWVtdS1zeXN0ZW0teDg2XzY0IC1jcHUga3ZtNjQgLWVuYWJsZS1rdm0g
LWtlcm5lbCAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5L2MxYmU1YTVi
MWIzNTVkNDBlNmNmNzljYzk3OWViNjZkYWZhMjRhZDEvdm1saW51ei0zLjkuMCAtYXBwZW5k
ICdodW5nX3Rhc2tfcGFuaWM9MSBlYXJseXByaW50az10dHlTMCwxMTUyMDAgZGVidWcgYXBp
Yz1kZWJ1ZyBzeXNycV9hbHdheXNfZW5hYmxlZCByY3VwZGF0ZS5yY3VfY3B1X3N0YWxsX3Rp
bWVvdXQ9MTAwIHBhbmljPTEwIHNvZnRsb2NrdXBfcGFuaWM9MSBubWlfd2F0Y2hkb2c9cGFu
aWMgIHByb21wdF9yYW1kaXNrPTAgY29uc29sZT10dHlTMCwxMTUyMDAgY29uc29sZT10dHkw
IHZnYT1ub3JtYWwgIHJvb3Q9L2Rldi9yYW0wIHJ3IGxpbms9L2tidWlsZC10ZXN0cy9ydW4t
cXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5L25leHQ6bWFzdGVyOmMx
YmU1YTViMWIzNTVkNDBlNmNmNzljYzk3OWViNjZkYWZhMjRhZDE6YmlzZWN0LWxpbnV4Ly52
bWxpbnV6LWMxYmU1YTViMWIzNTVkNDBlNmNmNzljYzk3OWViNjZkYWZhMjRhZDEtMjAxNDA3
MjcwNjQ0MTctMTM0LWl2YjQzIGJyYW5jaD1uZXh0L21hc3RlciBCT09UX0lNQUdFPS9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTkvYzFiZTVhNWIxYjM1NWQ0MGU2Y2Y3
OWNjOTc5ZWI2NmRhZmEyNGFkMS92bWxpbnV6LTMuOS4wIGRyYmQubWlub3JfY291bnQ9OCcg
IC1pbml0cmQgL2tlcm5lbC10ZXN0cy9pbml0cmQvcXVhbnRhbC1jb3JlLXg4Nl82NC5jZ3og
LW0gMzIwIC1zbXAgMiAtbmV0IG5pYyx2bGFuPTEsbW9kZWw9ZTEwMDAgLW5ldCB1c2VyLHZs
YW49MSAtYm9vdCBvcmRlcj1uYyAtbm8tcmVib290IC13YXRjaGRvZyBpNjMwMGVzYiAtcnRj
IGJhc2U9bG9jYWx0aW1lIC1waWRmaWxlIC9kZXYvc2htL2tib290L3BpZC1xdWFudGFsLWl2
YjQzLTExMSAtc2VyaWFsIGZpbGU6L2Rldi9zaG0va2Jvb3Qvc2VyaWFsLXF1YW50YWwtaXZi
NDMtMTExIC1kYWVtb25pemUgLWRpc3BsYXkgbm9uZSAtbW9uaXRvciBudWxsIAova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5L2MxYmU1YTViMWIzNTVkNDBlNmNmNzlj
Yzk3OWViNjZkYWZhMjRhZDEvZG1lc2cteW9jdG8ta2J1aWxkLTE4OjIwMTQwNzI2MjMzODU1
Ong4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5OjMuOS4wOjYKMzoxOjIyIGFsbF9nb29k
OmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA3LTI2IDIzOjQxOjA1IFJFUEVBVCBD
T1VOVDogMjYwICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4L29iai1iaXNlY3QvLnJlcGVhdBtb
MG0KCmJpc2VjdDogYmFkIGNvbW1pdCB2My45CmdpdCBjaGVja291dCB2My44CmxzIC1hIC9r
YnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjEx
OS9uZXh0Om1hc3RlcjoxOWY5NDlmNTI1OTliYTdjM2Y2N2E1ODk3YWM2YmUxNGJmY2IxMjAw
OmJpc2VjdC1saW51eAoKMjAxNC0wNy0yNi0yMzo0MTowOSAxOWY5NDlmNTI1OTliYTdjM2Y2
N2E1ODk3YWM2YmUxNGJmY2IxMjAwIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5
LTE5Zjk0OWY1MjU5OWJhN2MzZjY3YTU4OTdhYzZiZTE0YmZjYjEyMDAKQ2hlY2sgZm9yIGtl
cm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LzE5Zjk0OWY1
MjU5OWJhN2MzZjY3YTU4OTdhYzZiZTE0YmZjYjEyMDAKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3
MjYyMTE5LTE5Zjk0OWY1MjU5OWJhN2MzZjY3YTU4OTdhYzZiZTE0YmZjYjEyMDAKa2VybmVs
OiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LzE5Zjk0OWY1MjU5OWJh
N2MzZjY3YTU4OTdhYzZiZTE0YmZjYjEyMDAvdm1saW51ei0zLjguMAoKMjAxNC0wNy0yNi0y
Mzo0MzozMCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMyBURVNUIEZBSUxVUkUKWyAgICAwLjAw
MDAwMF0gbWFwcGVkIElPQVBJQyB0byBmZmZmZmZmZmZmNWY5MDAwIChmZWMwMDAwMCkKWyAg
ICAwLjAwMDAwMF0gbnJfaXJxc19nc2k6IDQwClsgICAgMC4wMDAwMDBdIC0tLS0tLS0tLS0t
LVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAgIDAuMDAwMDAwXSBXQVJOSU5HOiBhdCAv
a2J1aWxkL3NyYy9jb25zdW1lci9hcmNoL3g4Ni9rZXJuZWwvcHZjbG9jay5jOjE4MiBwdmNs
b2NrX2luaXRfdnN5c2NhbGwrMHgyMS8weDU5KCkKWyAgICAwLjAwMDAwMF0gSGFyZHdhcmUg
bmFtZTogQm9jaHMKWyAgICAwLjAwMDAwMF0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMC4w
MDAwMDBdIFBpZDogMCwgY29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjguMCAjNwpbICAg
IDAuMDAwMDAwXSBDYWxsIFRyYWNlOgpbICAgIDAuMDAwMDAwXSAgWzxmZmZmZmZmZjgxMDVi
Njg1Pl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg3Yy8weDk0ClsgICAgMC4wMDAwMDBdICBb
PGZmZmZmZmZmODEwNWI3M2M+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgxNS8weDE3ClsgICAg
MC4wMDAwMDBdICBbPGZmZmZmZmZmODE2ZWU5N2M+XSBwdmNsb2NrX2luaXRfdnN5c2NhbGwr
MHgyMS8weDU5ClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODE2ZWU5MTA+XSBrdm1fc2V0
dXBfdnN5c2NhbGxfdGltZWluZm8rMHg0OC8weDc4ClsgICAgMC4wMDAwMDBdICBbPGZmZmZm
ZmZmODE2ZWU1ZmU+XSBrdm1fZ3Vlc3RfaW5pdCsweDE5NS8weDFlZApbICAgIDAuMDAwMDAw
XSAgWzxmZmZmZmZmZjgxNmU0Nzc3Pl0gc2V0dXBfYXJjaCsweGE3Ny8weGFjMgpbICAgIDAu
MDAwMDAwXSAgWzxmZmZmZmZmZjgxNmRlN2NlPl0gc3RhcnRfa2VybmVsKzB4ODgvMHg0MDUK
WyAgICAwLjAwMDAwMF0gIFs8ZmZmZmZmZmY4MTZkZTEyMD5dID8gZWFybHlfaWR0X2hhbmRs
ZXJzKzB4MTIwLzB4MTIwClsgICAgMC4wMDAwMDBdICBbPGZmZmZmZmZmODE2ZGUyNDU+XSB4
ODZfNjRfc3RhcnRfcmVzZXJ2YXRpb25zKzB4YjAvMHhiMwpbICAgIDAuMDAwMDAwXSAgWzxm
ZmZmZmZmZjgxNmRlMzQ4Pl0geDg2XzY0X3N0YXJ0X2tlcm5lbCsweDEwMC8weDEwZApbICAg
IDAuMDAwMDAwXSAtLS1bIGVuZCB0cmFjZSAxMmNjYWIxNzI1ZTZkOWQyIF0tLS0KWyAgICAw
LjAwMDAwMF0gS1ZNIHNldHVwIGFzeW5jIFBGIGZvciBjcHUgMAova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXIxLTA3MjYyMTE5LzE5Zjk0OWY1MjU5OWJhN2MzZjY3YTU4OTdhYzZiZTE0
YmZjYjEyMDAvZG1lc2cteW9jdG8ta2J1aWxkLTIwOjIwMTQwNzI2MjM0MTA3Ong4Nl82NC1y
YW5kY29uZmlnLXIxLTA3MjYyMTE5OjMuOC4wOjcKMDoxOjcgYWxsX2dvb2Q6YmFkOmFsbF9i
YWQgYm9vdHMKCmJpc2VjdDogYmFkIGNvbW1pdCB2My44CmdpdCBjaGVja291dCB2My43Cmxz
IC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1yMS0w
NzI2MjExOS9uZXh0Om1hc3RlcjoyOTU5NDQwNGQ3ZmU3M2NkODBlYWE0ZWU4YzQzZGNjNTM5
NzBjNjBlOmJpc2VjdC1saW51eAoKMjAxNC0wNy0yNi0yMzo0NDo0NyAyOTU5NDQwNGQ3ZmU3
M2NkODBlYWE0ZWU4YzQzZGNjNTM5NzBjNjBlIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFz
ayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3
MjYyMTE5LTI5NTk0NDA0ZDdmZTczY2Q4MGVhYTRlZThjNDNkY2M1Mzk3MGM2MGUKQ2hlY2sg
Zm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LzI5
NTk0NDA0ZDdmZTczY2Q4MGVhYTRlZThjNDNkY2M1Mzk3MGM2MGUKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmln
LXIxLTA3MjYyMTE5LTI5NTk0NDA0ZDdmZTczY2Q4MGVhYTRlZThjNDNkY2M1Mzk3MGM2MGUK
a2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LzI5NTk0NDA0
ZDdmZTczY2Q4MGVhYTRlZThjNDNkY2M1Mzk3MGM2MGUvdm1saW51ei0zLjcuMAoKMjAxNC0w
Ny0yNi0yMzo0Njo1MyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJNyBURVNUIEZBSUxVUkUKWyAg
ICAxLjQ3MjE4M10gbWljcm9jb2RlOiBDUFUwIHNpZz0weDMwNmMxLCBwZj0weDEsIHJldmlz
aW9uPTB4MQpbICAgIDEuNDczNzQ4XSBtaWNyb2NvZGU6IE1pY3JvY29kZSBVcGRhdGUgRHJp
dmVyOiB2Mi4wMCA8dGlncmFuQGFpdmF6aWFuLmZzbmV0LmNvLnVrPiwgUGV0ZXIgT3J1YmEK
WyAgICAxLjQ4Mjk0M10gYWxnOiBObyB0ZXN0IGZvciBfX2djbS1hZXMtYWVzbmkgKF9fZHJp
dmVyLWdjbS1hZXMtYWVzbmkpClsgICAgMS40ODU1MzRdIGdlbmVyYWwgcHJvdGVjdGlvbiBm
YXVsdDogMDAwMCBbIzFdIERFQlVHX1BBR0VBTExPQwpbICAgIDEuNDg3MTI1XSBNb2R1bGVz
IGxpbmtlZCBpbjoKWyAgICAxLjQ4NzkxMF0gQ1BVIDAgClsgICAgMS40ODc5MTBdIFBpZDog
ODIsIGNvbW06IGNyeXB0b21ncl90ZXN0IE5vdCB0YWludGVkIDMuNy4wICM4IEJvY2hzIEJv
Y2hzClsgICAgMS40ODc5MTBdIFJJUDogMDAxMDpbPGZmZmZmZmZmODExNmM0ODM+XSAgWzxm
ZmZmZmZmZjgxMTZjNDgzPl0gY3J5cHRvX2FoYXNoX3NldGtleSsweDFlLzB4OGUKWyAgICAx
LjQ4NzkxMF0gUlNQOiAwMDAwOmZmZmY4ODAwMTE1MTFiMzggIEVGTEFHUzogMDAwMTAyODYK
WyAgICAxLjQ4NzkxMF0gUkFYOiBmMDAwZmY1M2YwMDBmZjUzIFJCWDogZmZmZjg4MDAwMDAw
MDBjYyBSQ1g6IDAwMDAwMDAwZjAwMDAwNTMKWyAgICAxLjQ4NzkxMF0gUkRYOiAwMDAwMDAw
MDAwMDAwMDEwIFJTSTogZmZmZmZmZmY4MTU0ODQ0NiBSREk6IGZmZmY4ODAwMDAwMDAwY2MK
WyAgICAxLjQ4NzkxMF0gUkJQOiBmZmZmODgwMDExNTExYjY4IFIwODogZmZmZjg4MDAxMTUx
MTkxMCBSMDk6IGZmZmY4ODAwMTFkYzMwNjAKWyAgICAxLjQ4NzkxMF0gUjEwOiAwMDAwMDAw
MDAwMDAwMDA3IFIxMTogMDAwMDAwMDAwMDAwNTcwOCBSMTI6IGZmZmZmZmZmODE1NDg0NDYK
WyAgICAxLjQ4NzkxMF0gUjEzOiBmZmZmODgwMDBjNDg4ZTc4IFIxNDogMDAwMDAwMDAwMDAw
MDAwMCBSMTU6IDAwMDAwMDAwMDAwMDAwMTAKWyAgICAxLjQ4NzkxMF0gRlM6ICAwMDAwMDAw
MDAwMDAwMDAwKDAwMDApIEdTOmZmZmZmZmZmODE1ZjIwMDAoMDAwMCkga25sR1M6MDAwMDAw
MDAwMDAwMDAwMApbICAgIDEuNDg3OTEwXSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAg
Q1IwOiAwMDAwMDAwMDgwMDUwMDMzClsgICAgMS40ODc5MTBdIENSMjogMDAwMDAwMDBmZmZm
ZmZmZiBDUjM6IDAwMDAwMDAwMDE1ZTEwMDAgQ1I0OiAwMDAwMDAwMDAwMDQwNmYwClsgICAg
MS40ODc5MTBdIERSMDogMDAwMDAwMDAwMDAwMDAwMCBEUjE6IDAwMDAwMDAwMDAwMDAwMDAg
RFIyOiAwMDAwMDAwMDAwMDAwMDAwClsgICAgMS40ODc5MTBdIERSMzogMDAwMDAwMDAwMDAw
MDAwMCBEUjY6IDAwMDAwMDAwZmZmZjBmZjAgRFI3OiAwMDAwMDAwMDAwMDAwNDAwClsgICAg
MS40ODc5MTBdIFByb2Nlc3MgY3J5cHRvbWdyX3Rlc3QgKHBpZDogODIsIHRocmVhZGluZm8g
ZmZmZjg4MDAxMTUxMDAwMCwgdGFzayBmZmZmODgwMDExNGNmOGEwKQpbICAgIDEuNDg3OTEw
XSBTdGFjazoKWyAgICAxLjQ4NzkxMF0gIDAwMDAwMDAwZjAwMDAwNTMgZmZmZjg4MDAwMDAw
MDBjYyBmZmZmODgwMDBjNDg4ZTc4IGZmZmY4ODAwMGM0ODhlNzgKWyAgICAxLjQ4NzkxMF0g
IDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAxMCBmZmZmODgwMDExNTExYjg4IGZm
ZmZmZmZmODEwNTI4NjIKWyAgICAxLjQ4NzkxMF0gIGZmZmY4ODAwMGM0ODhlNzggZmZmZmZm
ZmY4MTU0ODQ0NiBmZmZmODgwMDExNTExYmM4IGZmZmZmZmZmODExNmM0ZTcKWyAgICAxLjQ4
NzkxMF0gQ2FsbCBUcmFjZToKWyAgICAxLjQ4NzkxMF0gIFs8ZmZmZmZmZmY4MTA1Mjg2Mj5d
IGdoYXNoX2FzeW5jX3NldGtleSsweDMyLzB4NDUKWyAgICAxLjQ4NzkxMF0gIFs8ZmZmZmZm
ZmY4MTE2YzRlNz5dIGNyeXB0b19haGFzaF9zZXRrZXkrMHg4Mi8weDhlClsgICAgMS40ODc5
MTBdICBbPGZmZmZmZmZmODExNmZkNWY+XSB0ZXN0X2hhc2grMHgxNDEvMHg1OGYKWyAgICAx
LjQ4NzkxMF0gIFs8ZmZmZmZmZmY4MTE3ODczOT5dID8gY3J5cHRkX2FsbG9jX2FoYXNoKzB4
NDgvMHg4MApbICAgIDEuNDg3OTEwXSAgWzxmZmZmZmZmZjgxMDUyODE2Pl0gPyBnaGFzaF9h
c3luY19pbml0X3RmbSsweDE4LzB4MzIKWyAgICAxLjQ4NzkxMF0gIFs8ZmZmZmZmZmY4MTE2
NzUzYT5dID8gY3J5cHRvX2NyZWF0ZV90Zm0rMHg1ZC8weDk2ClsgICAgMS40ODc5MTBdICBb
PGZmZmZmZmZmODExNjc1YzM+XSA/IGNyeXB0b19hbGxvY190Zm0rMHg1MC8weDhlClsgICAg
MS40ODc5MTBdICBbPGZmZmZmZmZmODExNzAyMDQ+XSBhbGdfdGVzdF9oYXNoKzB4NTcvMHg4
OQpbICAgIDEuNDg3OTEwXSAgWzxmZmZmZmZmZjgxMTZmYjlkPl0gYWxnX3Rlc3QrMHgxNGYv
MHgxYTQKWyAgICAxLjQ4NzkxMF0gIFs8ZmZmZmZmZmY4MTA3M2Y3Yz5dID8gZGVmYXVsdF93
YWtlX2Z1bmN0aW9uKzB4ZC8weGYKWyAgICAxLjQ4NzkxMF0gIFs8ZmZmZmZmZmY4MTA3MzUy
Mz5dID8gX193YWtlX3VwX2NvbW1vbisweDQ2LzB4NzIKWyAgICAxLjQ4NzkxMF0gIFs8ZmZm
ZmZmZmY4MTE2ZDY1Nz5dID8gY3J5cHRvbWdyX25vdGlmeSsweDM2Yy8weDM2YwpbICAgIDEu
NDg3OTEwXSAgWzxmZmZmZmZmZjgxMTZkNjdhPl0gY3J5cHRvbWdyX3Rlc3QrMHgyMy8weDNl
ClsgICAgMS40ODc5MTBdICBbPGZmZmZmZmZmODEwNmNjNGM+XSBrdGhyZWFkKzB4YzYvMHhj
ZQpbICAgIDEuNDg3OTEwXSAgWzxmZmZmZmZmZjgxMDZjYjg2Pl0gPyBrdGhyZWFkX3N0b3Ar
MHg1ZS8weDVlClsgICAgMS40ODc5MTBdICBbPGZmZmZmZmZmODE0MTM0ZmE+XSByZXRfZnJv
bV9mb3JrKzB4N2EvMHhiMApbICAgIDEuNDg3OTEwXSAgWzxmZmZmZmZmZjgxMDZjYjg2Pl0g
PyBrdGhyZWFkX3N0b3ArMHg1ZS8weDVlClsgICAgMS40ODc5MTBdIENvZGU6IDQ4IDg5IGY3
IDg5IDQ2IDI4IGU4IDBjIGZiIGZmIGZmIDVkIGMzIDU1IDQ4IDg5IGU1IDQxIDU3IDQxIDg5
IGQ3IDQxIDU2IDQxIDU1IDQxIDU0IDQ5IDg5IGY0IDUzIDQ4IDg5IGZiIDUxIDQ4IDhiIDg3
IDk4IDAwIDAwIDAwIDw0ND4gOGIgNzAgMmMgNGMgODUgZjYgNzQgNTggNDEgODkgZDUgYmUg
ZDAgMDAgMDAgMDAgODMgY2EgZmYgNGIgClsgICAgMS40ODc5MTBdIFJJUCAgWzxmZmZmZmZm
ZjgxMTZjNDgzPl0gY3J5cHRvX2FoYXNoX3NldGtleSsweDFlLzB4OGUKWyAgICAxLjQ4Nzkx
MF0gIFJTUCA8ZmZmZjg4MDAxMTUxMWIzOD4KWyAgICAxLjU1NzAxOF0gLS0tWyBlbmQgdHJh
Y2UgZjU2YjIyNjdmZDE0NjUxYiBdLS0tClsgICAgMS41NTgyMDFdIEtlcm5lbCBwYW5pYyAt
IG5vdCBzeW5jaW5nOiBGYXRhbCBleGNlcHRpb24KL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1yMS0wNzI2MjExOS8yOTU5NDQwNGQ3ZmU3M2NkODBlYWE0ZWU4YzQzZGNjNTM5NzBjNjBl
L2RtZXNnLXlvY3RvLWtidWlsZC0xNzoyMDE0MDcyNjIzNDUxNjp4ODZfNjQtcmFuZGNvbmZp
Zy1yMS0wNzI2MjExOTozLjcuMDo4Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjEtMDcy
NjIxMTkvMjk1OTQ0MDRkN2ZlNzNjZDgwZWFhNGVlOGM0M2RjYzUzOTcwYzYwZS9kbWVzZy15
b2N0by1rYnVpbGQtNToyMDE0MDcyNjIzNDUxNTp4ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2
MjExOTozLjcuMDo4CjI6Mjo3IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpiaXNlY3Q6
IGJhZCBjb21taXQgdjMuNwpnaXQgY2hlY2tvdXQgdjMuNgpscyAtYSAva2J1aWxkLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTkvbmV4dDptYXN0
ZXI6YTBkMjcxY2JmZWQxZGQ1MDI3OGM2YjA2YmVhZDNkMDBiYTBhODhmOTpiaXNlY3QtbGlu
dXgKCjIwMTQtMDctMjYtMjM6NTA6MzMgYTBkMjcxY2JmZWQxZGQ1MDI3OGM2YjA2YmVhZDNk
MDBiYTBhODhmOSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0
cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS1hMGQyNzFjYmZl
ZDFkZDUwMjc4YzZiMDZiZWFkM2QwMGJhMGE4OGY5CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS9hMGQyNzFjYmZlZDFkZDUwMjc4
YzZiMDZiZWFkM2QwMGJhMGE4OGY5CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS1hMGQy
NzFjYmZlZDFkZDUwMjc4YzZiMDZiZWFkM2QwMGJhMGE4OGY5CndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9qYWtldG93bi1jb25zdW1lci94
ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS1hMGQyNzFjYmZlZDFkZDUwMjc4YzZiMDZi
ZWFkM2QwMGJhMGE4OGY5Cmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0w
NzI2MjExOS9hMGQyNzFjYmZlZDFkZDUwMjc4YzZiMDZiZWFkM2QwMGJhMGE4OGY5L3ZtbGlu
dXotMy42LjAKCjIwMTQtMDctMjYtMjM6NTc6MzMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkz
IFRFU1QgRkFJTFVSRQovYmluL3NoOiAvcHJvYy9zZWxmL2ZkLzk6IE5vIHN1Y2ggZmlsZSBv
ciBkaXJlY3RvcnkKL2Jpbi9zaDogL3Byb2Mvc2VsZi9mZC85OiBObyBzdWNoIGZpbGUgb3Ig
ZGlyZWN0b3J5CgpCVUc6IGtlcm5lbCBib290IGhhbmcKRWxhcHNlZCB0aW1lOiAzNQpxZW11
LXN5c3RlbS14ODZfNjQgLWVuYWJsZS1rdm0gLWNwdSBIYXN3ZWxsLCtzbWVwLCtzbWFwIC1r
ZXJuZWwgL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS9hMGQyNzFjYmZl
ZDFkZDUwMjc4YzZiMDZiZWFkM2QwMGJhMGE4OGY5L3ZtbGludXotMy42LjAgLWFwcGVuZCAn
aHVuZ190YXNrX3BhbmljPTEgZWFybHlwcmludGs9dHR5UzAsMTE1MjAwIGRlYnVnIGFwaWM9
ZGVidWcgc3lzcnFfYWx3YXlzX2VuYWJsZWQgcmN1cGRhdGUucmN1X2NwdV9zdGFsbF90aW1l
b3V0PTEwMCBwYW5pYz0xMCBzb2Z0bG9ja3VwX3BhbmljPTEgbm1pX3dhdGNoZG9nPXBhbmlj
ICBwcm9tcHRfcmFtZGlzaz0wIGNvbnNvbGU9dHR5UzAsMTE1MjAwIGNvbnNvbGU9dHR5MCB2
Z2E9bm9ybWFsICByb290PS9kZXYvcmFtMCBydyBsaW5rPS9rYnVpbGQtdGVzdHMvcnVuLXF1
ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS9uZXh0Om1hc3RlcjphMGQy
NzFjYmZlZDFkZDUwMjc4YzZiMDZiZWFkM2QwMGJhMGE4OGY5OmJpc2VjdC1saW51eC8udm1s
aW51ei1hMGQyNzFjYmZlZDFkZDUwMjc4YzZiMDZiZWFkM2QwMGJhMGE4OGY5LTIwMTQwNzI2
MjM1NzI5LTEwNi1rYnVpbGQgYnJhbmNoPW5leHQvbWFzdGVyIEJPT1RfSU1BR0U9L2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS9hMGQyNzFjYmZlZDFkZDUwMjc4YzZi
MDZiZWFkM2QwMGJhMGE4OGY5L3ZtbGludXotMy42LjAgZHJiZC5taW5vcl9jb3VudD04JyAg
LWluaXRyZCAva2VybmVsLXRlc3RzL2luaXRyZC9xdWFudGFsLWNvcmUteDg2XzY0LmNneiAt
bSAzMjAgLXNtcCAyIC1uZXQgbmljLHZsYW49MSxtb2RlbD1lMTAwMCAtbmV0IHVzZXIsdmxh
bj0xIC1ib290IG9yZGVyPW5jIC1uby1yZWJvb3QgLXdhdGNoZG9nIGk2MzAwZXNiIC1ydGMg
YmFzZT1sb2NhbHRpbWUgLXBpZGZpbGUgL2Rldi9zaG0va2Jvb3QvcGlkLXF1YW50YWwta2J1
aWxkLTI2IC1zZXJpYWwgZmlsZTovZGV2L3NobS9rYm9vdC9zZXJpYWwtcXVhbnRhbC1rYnVp
bGQtMjYgLWRhZW1vbml6ZSAtZGlzcGxheSBub25lIC1tb25pdG9yIG51bGwgCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTkvYTBkMjcxY2JmZWQxZGQ1MDI3OGM2YjA2
YmVhZDNkMDBiYTBhODhmOS9kbWVzZy1xdWFudGFsLWtidWlsZC0zMDoyMDE0MDcyNjIzNTYy
Mzp4ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOTozLjYuMDozCjA6MTo0IGFsbF9nb29k
OmJhZDphbGxfYmFkIGJvb3RzCgpiaXNlY3Q6IGJhZCBjb21taXQgdjMuNgpnaXQgY2hlY2tv
dXQgdjMuNQpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRj
b25maWctcjEtMDcyNjIxMTkvbmV4dDptYXN0ZXI6MjhhMzNjYmMyNGU0MjU2YzE0M2RjZTk2
YzdkOTNiZjQyMzIyOWY5MjpiaXNlY3QtbGludXgKCjIwMTQtMDctMjYtMjM6NTg6MzcgMjhh
MzNjYmMyNGU0MjU2YzE0M2RjZTk2YzdkOTNiZjQyMzIyOWY5MiBjb21waWxpbmcKUXVldWVk
IGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNv
bmZpZy1yMS0wNzI2MjExOS0yOGEzM2NiYzI0ZTQyNTZjMTQzZGNlOTZjN2Q5M2JmNDIzMjI5
ZjkyCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0w
NzI2MjExOS8yOGEzM2NiYzI0ZTQyNTZjMTQzZGNlOTZjN2Q5M2JmNDIzMjI5ZjkyCndhaXRp
bmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQt
cmFuZGNvbmZpZy1yMS0wNzI2MjExOS0yOGEzM2NiYzI0ZTQyNTZjMTQzZGNlOTZjN2Q5M2Jm
NDIzMjI5ZjkyCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS9sa3AtaHN4MDEtY29uc3VtZXIveDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIx
MTktMjhhMzNjYmMyNGU0MjU2YzE0M2RjZTk2YzdkOTNiZjQyMzIyOWY5MgprZXJuZWw6IC9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTkvMjhhMzNjYmMyNGU0MjU2YzE0
M2RjZTk2YzdkOTNiZjQyMzIyOWY5Mi92bWxpbnV6LTMuNS4wCgoyMDE0LTA3LTI3LTAwOjAy
OjM3IGRldGVjdGluZyBib290IHN0YXRlIC4JMTAJMzcJODUJOTkJMTM5CTE1OAkxOTgJMjA5
CTI0MQkyNjAgU1VDQ0VTUwoKYmlzZWN0OiBnb29kIGNvbW1pdCB2My41CmdpdCBiaXNlY3Qg
c3RhcnQgdjMuNiB2My41IC0tCi9jL2tlcm5lbC10ZXN0cy9saW5lYXItYmlzZWN0OiBbIi1i
IiwgInYzLjYiLCAiLWciLCAidjMuNSIsICIvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3Qt
Ym9vdC1mYWlsdXJlLnNoIiwgIi9jL2Jvb3QtYmlzZWN0L2xpbnV4L29iai1iaXNlY3QiXQpC
aXNlY3Rpbmc6IDExMTMwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91
Z2hseSAxNCBzdGVwcykKWzFkZDgzNzJkMzUwNTgzYjBhY2M4ZDdjZmQ3YTFkZWUwNWUxOTQy
ZGNdIE1BSU5UQUlORVJTOiB1cGRhdGUgYWRkcmVzcyBmb3IgRGFuIFdpbGxpYW1zCnJ1bm5p
bmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290
LWJpc2VjdC9saW51eC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVl
L2t2bS94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS9uZXh0Om1hc3RlcjoxZGQ4Mzcy
ZDM1MDU4M2IwYWNjOGQ3Y2ZkN2ExZGVlMDVlMTk0MmRjOmJpc2VjdC1saW51eAoKMjAxNC0w
Ny0yNy0wMDowOToxMCAxZGQ4MzcyZDM1MDU4M2IwYWNjOGQ3Y2ZkN2ExZGVlMDVlMTk0MmRj
IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LTFkZDgzNzJkMzUwNTgzYjBhY2M4
ZDdjZmQ3YTFkZWUwNWUxOTQyZGMKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LzFkZDgzNzJkMzUwNTgzYjBhY2M4ZDdjZmQ3YTFk
ZWUwNWUxOTQyZGMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LTFkZDgzNzJkMzUwNTgz
YjBhY2M4ZDdjZmQ3YTFkZWUwNWUxOTQyZGMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMS1jb25zdW1lci94ODZfNjQtcmFu
ZGNvbmZpZy1yMS0wNzI2MjExOS0xZGQ4MzcyZDM1MDU4M2IwYWNjOGQ3Y2ZkN2ExZGVlMDVl
MTk0MmRjCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS8x
ZGQ4MzcyZDM1MDU4M2IwYWNjOGQ3Y2ZkN2ExZGVlMDVlMTk0MmRjL3ZtbGludXotMy42LjAt
cmMxLTAwMzc4LWcxZGQ4MzcyCgoyMDE0LTA3LTI3LTAwOjE0OjEwIGRldGVjdGluZyBib290
IHN0YXRlIAkxMCBURVNUIEZBSUxVUkUKWyAgICAxLjQyNDQ2MF0gaW8gc2NoZWR1bGVyIGNm
cSByZWdpc3RlcmVkClsgICAgMS40MjU2MjZdIGlucHV0OiBQb3dlciBCdXR0b24gYXMgL2Rl
dmljZXMvTE5YU1lTVE06MDAvTE5YUFdSQk46MDAvaW5wdXQvaW5wdXQwClsgICAgMS40Mjc0
OTFdIEFDUEk6IFBvd2VyIEJ1dHRvbiBbUFdSRl0KWyAgICAxLjQyODY1NF0gQlVHOiBCYWQg
cGFnZSBzdGF0ZSBpbiBwcm9jZXNzIHN3YXBwZXIgIHBmbjowZDMzYQpbICAgIDEuNDMwMTMw
XSBwYWdlOmZmZmY4ODAwMTFkZTdlODAgY291bnQ6MCBtYXBjb3VudDoxMyBtYXBwaW5nOmZm
ZmY4ODAwMGQzMzM4YTggaW5kZXg6MHhmZmZmODgwMDBkMzNhMWYwClsgICAgMS40MzI0NTZd
IHBhZ2UgZmxhZ3M6IDB4MjgwMDAwMDAwODFjKHJlZmVyZW5jZWR8dXB0b2RhdGV8ZGlydHl8
cHJpdmF0ZSkKWyAgICAxLjQzNDMzNl0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMS40MzUx
NTBdIFBpZDogMSwgY29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjYuMC1yYzEtMDAzNzgt
ZzFkZDgzNzIgIzEwClsgICAgMS40MzY4NzZdIENhbGwgVHJhY2U6ClsgICAgMS40Mzc1MzRd
ICBbPGZmZmZmZmZmODEwYTFiMDc+XSBiYWRfcGFnZSsweDEwNC8weDExOApbICAgIDEuNDM4
ODIxXSAgWzxmZmZmZmZmZjgxMGExYjhjPl0gZnJlZV9wYWdlc19wcmVwYXJlKzB4NzEvMHhi
NwpbICAgIDEuNDQwMjk4XSAgWzxmZmZmZmZmZjgxMGEzMTM4Pl0gZnJlZV9ob3RfY29sZF9w
YWdlKzB4MjQvMHgxMzgKWyAgICAxLjQ0MTc3OF0gIFs8ZmZmZmZmZmY4MTBhNTczNT5dIF9f
cHV0X3NpbmdsZV9wYWdlKzB4MWUvMHgyMQpbICAgIDEuNDQzMjIyXSAgWzxmZmZmZmZmZjgx
MGE1YTcyPl0gcHV0X3BhZ2UrMHgyMy8weDI1ClsgICAgMS40NDQ0OTVdICBbPGZmZmZmZmZm
ODEwYzRkMjc+XSBrZnJlZSsweDY3LzB4NmEKWyAgICAxLjQ0NTY5MV0gIFs8ZmZmZmZmZmY4
MTFkNWJkMj5dIGFjcGlfbnNfZ2V0X25vZGUrMHg5Ny8weGE2ClsgICAgMS40NDcxMjFdICBb
PGZmZmZmZmZmODEwYzQ3ZTM+XSA/IHNsb2JfYWxsb2MuaXNyYS4xNSsweGUyLzB4MjA4Clsg
ICAgMS40NDg2MzhdICBbPGZmZmZmZmZmODExZDM2ODU+XSBhY3BpX25zX2V2YWx1YXRlKzB4
M2MvMHgxYTcKWyAgICAxLjQ1MDA5N10gIFs8ZmZmZmZmZmY4MTFkNWVjZT5dIGFjcGlfZXZh
bHVhdGVfb2JqZWN0KzB4MTI4LzB4MjM2ClsgICAgMS40NTE2NDBdICBbPGZmZmZmZmZmODEx
ZTBkYTE+XSBhY3BpX3Byb2Nlc3Nvcl9nZXRfdGhyb3R0bGluZ19pbmZvKzB4MzcvMHg1MGUK
WyAgICAxLjQ1MzQ4N10gIFs8ZmZmZmZmZmY4MTNiYTA0MT5dIGFjcGlfcHJvY2Vzc29yX3N0
YXJ0KzB4MWEvMHgxMDEKWyAgICAxLjQ1NTAyM10gIFs8ZmZmZmZmZmY4MTY3NjI4Yz5dIGFj
cGlfcHJvY2Vzc29yX2FkZCsweDMzYy8weDM4NApbICAgIDEuNDU2NTMwXSAgWzxmZmZmZmZm
ZjgxMTBjZDAwPl0gPyBzeXNmc19kb19jcmVhdGVfbGluaysweDhkLzB4MTllClsgICAgMS40
NTgxMTddICBbPGZmZmZmZmZmODExYmVmNjc+XSBhY3BpX2RldmljZV9wcm9iZSsweDQ5LzB4
MTExClsgICAgMS40NTk1ODFdICBbPGZmZmZmZmZmODEyMjMxYTE+XSBkcml2ZXJfcHJvYmVf
ZGV2aWNlKzB4OTcvMHgxYmQKWyAgICAxLjQ2MTEwOV0gIFs8ZmZmZmZmZmY4MTIyMzM1Nz5d
IF9fZHJpdmVyX2F0dGFjaCsweDU4LzB4N2EKWyAgICAxLjQ2MjQ5M10gIFs8ZmZmZmZmZmY4
MTIyMzJmZj5dID8gX19kZXZpY2VfYXR0YWNoKzB4MzgvMHgzOApbICAgIDEuNDYzOTU4XSAg
WzxmZmZmZmZmZjgxMjIxOTYzPl0gYnVzX2Zvcl9lYWNoX2RldisweDZlLzB4NzgKWyAgICAx
LjQ2NTM2Nl0gIFs8ZmZmZmZmZmY4MTIyMmQ1OT5dIGRyaXZlcl9hdHRhY2grMHgxOS8weDFi
ClsgICAgMS40NjY3MjhdICBbPGZmZmZmZmZmODEyMjI5YTI+XSBidXNfYWRkX2RyaXZlcisw
eGY5LzB4MjAxClsgICAgMS40NjgxMjldICBbPGZmZmZmZmZmODE2NjRjNDI+XSA/IGFjcGlf
ZmFuX2luaXQrMHgxOC8weDE4ClsgICAgMS40Njk1MTRdICBbPGZmZmZmZmZmODEyMjM4MzE+
XSBkcml2ZXJfcmVnaXN0ZXIrMHg4Ny8weGY4ClsgICAgMS40NzA5MzJdICBbPGZmZmZmZmZm
ODE2NjRjNDI+XSA/IGFjcGlfZmFuX2luaXQrMHgxOC8weDE4ClsgICAgMS40NzIzMjZdICBb
PGZmZmZmZmZmODExYmYxYmI+XSBhY3BpX2J1c19yZWdpc3Rlcl9kcml2ZXIrMHgzNi8weDNl
ClsgICAgMS40NzM5MzRdICBbPGZmZmZmZmZmODE2NjRjNzE+XSBhY3BpX3Byb2Nlc3Nvcl9p
bml0KzB4MmYvMHg0MQpbICAgIDEuNDc1NDE3XSAgWzxmZmZmZmZmZjgxMDAyMDc4Pl0gZG9f
b25lX2luaXRjYWxsKzB4NzgvMHgxMzEKWyAgICAxLjQ3Njg0MV0gIFs8ZmZmZmZmZmY4MTY0
N2M5Nz5dIGtlcm5lbF9pbml0KzB4MTQ3LzB4MWJmClsgICAgMS40NzgyMDRdICBbPGZmZmZm
ZmZmODE2NDc0ZmM+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4ODgvMHg4OApbICAgIDEuNDc5NjE5
XSAgWzxmZmZmZmZmZjgxM2VkMGQ0Pl0ga2VybmVsX3RocmVhZF9oZWxwZXIrMHg0LzB4MTAK
WyAgICAxLjQ4MTEzMF0gIFs8ZmZmZmZmZmY4MTY0N2I1MD5dID8gc3RhcnRfa2VybmVsKzB4
NDBhLzB4NDBhClsgICAgMS40ODI1NDFdICBbPGZmZmZmZmZmODEzZWQwZDA+XSA/IGdzX2No
YW5nZSsweDEzLzB4MTMKWyAgICAxLjQ4Mzg2OV0gRGlzYWJsaW5nIGxvY2sgZGVidWdnaW5n
IGR1ZSB0byBrZXJuZWwgdGFpbnQKWyAgICAxLjQ4NTU3NV0gaW9hdGRtYTogSW50ZWwoUikg
UXVpY2tEYXRhIFRlY2hub2xvZ3kgRHJpdmVyIDQuMDAKWyAgICAxLjUxNTc4Ml0gU2VyaWFs
OiA4MjUwLzE2NTUwIGRyaXZlciwgNCBwb3J0cywgSVJRIHNoYXJpbmcgZGlzYWJsZWQKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS8xZGQ4MzcyZDM1MDU4M2IwYWNj
OGQ3Y2ZkN2ExZGVlMDVlMTk0MmRjL2RtZXNnLXlvY3RvLWtidWlsZC01OjIwMTQwNzI3MDAx
MTU5Ong4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5OjMuNi4wLXJjMS0wMDM3OC1nMWRk
ODM3MjoxMAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LzFkZDgzNzJk
MzUwNTgzYjBhY2M4ZDdjZmQ3YTFkZWUwNWUxOTQyZGMvZG1lc2cteW9jdG8ta2J1aWxkLTE0
OjIwMTQwNzI3MDAxMjI1Ong4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5OjMuNi4wLXJj
MS0wMDM3OC1nMWRkODM3MjoxMAowOjI6MTIgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMK
CkJpc2VjdGluZzogOTUzOSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJv
dWdobHkgMTQgc3RlcHMpClthNDEwOTYzYmE0YzBjNzY4MzAyZjAyOThlMjU4YjFlZTk0MGU4
MzE2XSBNZXJnZSBicmFuY2ggJ2kyYy1lbWJlZGRlZC9mb3ItbmV4dCcgb2YgZ2l0Oi8vZ2l0
LnBlbmd1dHJvbml4LmRlL2dpdC93c2EvbGludXgKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4L29iai1i
aXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29u
ZmlnLXIxLTA3MjYyMTE5L25leHQ6bWFzdGVyOmE0MTA5NjNiYTRjMGM3NjgzMDJmMDI5OGUy
NThiMWVlOTQwZTgzMTY6YmlzZWN0LWxpbnV4CgoyMDE0LTA3LTI3LTAwOjE0OjQzIGE0MTA5
NjNiYTRjMGM3NjgzMDJmMDI5OGUyNThiMWVlOTQwZTgzMTYgY29tcGlsaW5nClF1ZXVlZCBi
dWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25m
aWctcjEtMDcyNjIxMTktYTQxMDk2M2JhNGMwYzc2ODMwMmYwMjk4ZTI1OGIxZWU5NDBlODMx
NgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjEtMDcy
NjIxMTkvYTQxMDk2M2JhNGMwYzc2ODMwMmYwMjk4ZTI1OGIxZWU5NDBlODMxNgp3YWl0aW5n
IGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJh
bmRjb25maWctcjEtMDcyNjIxMTktYTQxMDk2M2JhNGMwYzc2ODMwMmYwMjk4ZTI1OGIxZWU5
NDBlODMxNgprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTkv
YTQxMDk2M2JhNGMwYzc2ODMwMmYwMjk4ZTI1OGIxZWU5NDBlODMxNi92bWxpbnV6LTMuNS4w
LTA3MTM5LWdhNDEwOTYzCgoyMDE0LTA3LTI3LTAwOjE2OjQ3IGRldGVjdGluZyBib290IHN0
YXRlIC4JMgk1OAk4NQkxNjkgVEVTVCBGQUlMVVJFClsgICAgMC41MTY2NzddIG1pY3JvY29k
ZTogQ1BVMCBzaWc9MHgzMDZjMSwgcGY9MHgxLCByZXZpc2lvbj0weDEKWyAgICAwLjUxNzcx
Ml0gbWljcm9jb2RlOiBNaWNyb2NvZGUgVXBkYXRlIERyaXZlcjogdjIuMDAgPHRpZ3JhbkBh
aXZhemlhbi5mc25ldC5jby51az4sIFBldGVyIE9ydWJhClsgICAgMC41MjE2MjhdIGFsZzog
Tm8gdGVzdCBmb3IgX19nY20tYWVzLWFlc25pIChfX2RyaXZlci1nY20tYWVzLWFlc25pKQpb
ICAgIDAuNTIzMTU1XSBnZW5lcmFsIHByb3RlY3Rpb24gZmF1bHQ6IDAwMDAgWyMxXSBERUJV
R19QQUdFQUxMT0MKWyAgICAwLjUyMzM0NV0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMC41
MjMzNDVdIENQVSAwIApbICAgIDAuNTIzMzQ1XSBQaWQ6IDY1LCBjb21tOiBjcnlwdG9tZ3Jf
dGVzdCBOb3QgdGFpbnRlZCAzLjUuMC0wNzEzOS1nYTQxMDk2MyAjMTEgQm9jaHMgQm9jaHMK
WyAgICAwLjUyMzM0NV0gUklQOiAwMDEwOls8ZmZmZmZmZmY4MTE1OWNjMz5dICBbPGZmZmZm
ZmZmODExNTljYzM+XSBjcnlwdG9fYWhhc2hfc2V0a2V5KzB4MWUvMHg4ZQpbICAgIDAuNTIz
MzQ1XSBSU1A6IDAwMTg6ZmZmZjg4MDAxMjhmNWI2OCAgRUZMQUdTOiAwMDAxMDI4NgpbICAg
IDAuNTIzMzQ1XSBSQVg6IGYwMDBmZjUzZjAwMGZmNTMgUkJYOiBmZmZmODgwMDAwMDAwMGNj
IFJDWDogMDAwMDAwMDBmMDAwMDA1MwpbICAgIDAuNTIzMzQ1XSBSRFg6IDAwMDAwMDAwMDAw
MDAwMTAgUlNJOiBmZmZmZmZmZjgxNTE3ODFiIFJESTogZmZmZjg4MDAwMDAwMDBjYwpbICAg
IDAuNTIzMzQ1XSBSQlA6IGZmZmY4ODAwMTI4ZjViOTggUjA4OiBmZmZmODgwMDEyOGY1OTkw
IFIwOTogZmZmZmZmZmY4MTVkM2MxMApbICAgIDAuNTIzMzQ1XSBSMTA6IDAwMDAwMDAwMDAw
MDAwMDcgUjExOiAwMDAwMDAwMDAwMDA2Njk4IFIxMjogZmZmZmZmZmY4MTUxNzgxYgpbICAg
IDAuNTIzMzQ1XSBSMTM6IGZmZmY4ODAwMTIyYTYzMTggUjE0OiAwMDAwMDAwMDAwMDAwMDAw
IFIxNTogMDAwMDAwMDAwMDAwMDAxMApbICAgIDAuNTIzMzQ1XSBGUzogIDAwMDAwMDAwMDAw
MDAwMDAoMDAwMCkgR1M6ZmZmZmZmZmY4MTViZTAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAw
MDAwMDAwClsgICAgMC41MjMzNDVdIENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6
IDAwMDAwMDAwODAwNTAwM2IKWyAgICAwLjUyMzM0NV0gQ1IyOiAwMDAwMDAwMGZmZmZmZmZm
IENSMzogMDAwMDAwMDAwMTVhZDAwMCBDUjQ6IDAwMDAwMDAwMDAwNDA2ZjAKWyAgICAwLjUy
MzM0NV0gRFIwOiAwMDAwMDAwMDAwMDAwMDAwIERSMTogMDAwMDAwMDAwMDAwMDAwMCBEUjI6
IDAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjUyMzM0NV0gRFIzOiAwMDAwMDAwMDAwMDAwMDAw
IERSNjogMDAwMDAwMDBmZmZmMGZmMCBEUjc6IDAwMDAwMDAwMDAwMDA0MDAKWyAgICAwLjUy
MzM0NV0gUHJvY2VzcyBjcnlwdG9tZ3JfdGVzdCAocGlkOiA2NSwgdGhyZWFkaW5mbyBmZmZm
ODgwMDEyOGY0MDAwLCB0YXNrIGZmZmY4ODAwMTI4YmE4YTApClsgICAgMC41MjMzNDVdIFN0
YWNrOgpbICAgIDAuNTIzMzQ1XSAgMDAwMDAwMDBmMDAwMDA1MyBmZmZmODgwMDAwMDAwMGNj
IGZmZmY4ODAwMTIyYTYzMTggZmZmZjg4MDAxMjJhNjMxOApbICAgIDAuNTIzMzQ1XSAgMDAw
MDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDEwIGZmZmY4ODAwMTI4ZjViYjggZmZmZmZm
ZmY4MTA0MWRlNgpbICAgIDAuNTIzMzQ1XSAgZmZmZjg4MDAxMjJhNjMxOCBmZmZmZmZmZjgx
NTE3ODFiIGZmZmY4ODAwMTI4ZjViZjggZmZmZmZmZmY4MTE1OWQyNwpbICAgIDAuNTIzMzQ1
XSBDYWxsIFRyYWNlOgpbICAgIDAuNTIzMzQ1XSAgWzxmZmZmZmZmZjgxMDQxZGU2Pl0gZ2hh
c2hfYXN5bmNfc2V0a2V5KzB4MzIvMHg0NQpbICAgIDAuNTIzMzQ1XSAgWzxmZmZmZmZmZjgx
MTU5ZDI3Pl0gY3J5cHRvX2FoYXNoX3NldGtleSsweDgyLzB4OGUKWyAgICAwLjUyMzM0NV0g
IFs8ZmZmZmZmZmY4MTE1ZDE2ZD5dIHRlc3RfaGFzaCsweDE0MS8weDU4ZgpbICAgIDAuNTIz
MzQ1XSAgWzxmZmZmZmZmZjgxMTY1OTkzPl0gPyBjcnlwdGRfYWxsb2NfYWhhc2grMHg0OC8w
eDgwClsgICAgMC41MjMzNDVdICBbPGZmZmZmZmZmODEwNDFkOWE+XSA/IGdoYXNoX2FzeW5j
X2luaXRfdGZtKzB4MTgvMHgzMgpbICAgIDAuNTIzMzQ1XSAgWzxmZmZmZmZmZjgxMTU0ZDdh
Pl0gPyBjcnlwdG9fY3JlYXRlX3RmbSsweDVkLzB4OTYKWyAgICAwLjUyMzM0NV0gIFs8ZmZm
ZmZmZmY4MTE1NGUwMz5dID8gY3J5cHRvX2FsbG9jX3RmbSsweDUwLzB4OGUKWyAgICAwLjUy
MzM0NV0gIFs8ZmZmZmZmZmY4MTE1ZDYxMj5dIGFsZ190ZXN0X2hhc2grMHg1Ny8weDg5Clsg
ICAgMC41MjMzNDVdICBbPGZmZmZmZmZmODExNWNmYWI+XSBhbGdfdGVzdCsweDE0Zi8weDFh
NApbICAgIDAuNTIzMzQ1XSAgWzxmZmZmZmZmZjgxMDYzMjdjPl0gPyBkZWZhdWx0X3dha2Vf
ZnVuY3Rpb24rMHhkLzB4ZgpbICAgIDAuNTIzMzQ1XSAgWzxmZmZmZmZmZjgxMDYyNmVlPl0g
PyBfX3dha2VfdXBfY29tbW9uKzB4NDYvMHg3MgpbICAgIDAuNTIzMzQ1XSAgWzxmZmZmZmZm
ZjgxMTVhZGQ5Pl0gPyBjcnlwdG9tZ3Jfbm90aWZ5KzB4MzZjLzB4MzZjClsgICAgMC41MjMz
NDVdICBbPGZmZmZmZmZmODExNWFkZmM+XSBjcnlwdG9tZ3JfdGVzdCsweDIzLzB4M2UKWyAg
ICAwLjUyMzM0NV0gIFs8ZmZmZmZmZmY4MTA1YzM3OT5dIGt0aHJlYWQrMHg4NS8weDhkClsg
ICAgMC41MjMzNDVdICBbPGZmZmZmZmZmODEzZWQ5OTQ+XSBrZXJuZWxfdGhyZWFkX2hlbHBl
cisweDQvMHgxMApbICAgIDAuNTIzMzQ1XSAgWzxmZmZmZmZmZjgxMDVjMmY0Pl0gPyBrdGhy
ZWFkX2ZsdXNoX3dvcmtfZm4rMHhmLzB4ZgpbICAgIDAuNTIzMzQ1XSAgWzxmZmZmZmZmZjgx
M2VkOTkwPl0gPyBnc19jaGFuZ2UrMHgxMy8weDEzClsgICAgMC41MjMzNDVdIENvZGU6IDQ4
IDg5IGY3IDg5IDQ2IDI4IGU4IDBjIGZiIGZmIGZmIDVkIGMzIDU1IDQ4IDg5IGU1IDQxIDU3
IDQxIDg5IGQ3IDQxIDU2IDQxIDU1IDQxIDU0IDQ5IDg5IGY0IDUzIDQ4IDg5IGZiIDUxIDQ4
IDhiIDg3IDk4IDAwIDAwIDAwIDw0ND4gOGIgNzAgMmMgNGMgODUgZjYgNzQgNTggNDEgODkg
ZDUgYmUgZDAgMDAgMDAgMDAgODMgY2EgZmYgNGIgClsgICAgMC41MjMzNDVdIFJJUCAgWzxm
ZmZmZmZmZjgxMTU5Y2MzPl0gY3J5cHRvX2FoYXNoX3NldGtleSsweDFlLzB4OGUKWyAgICAw
LjUyMzM0NV0gIFJTUCA8ZmZmZjg4MDAxMjhmNWI2OD4KWyAgICAwLjU2ODcxMF0gLS0tWyBl
bmQgdHJhY2UgNGVhYTJhODZhOGUyZGEyMiBdLS0tClsgICAgMC41Njk0NjVdIEtlcm5lbCBw
YW5pYyAtIG5vdCBzeW5jaW5nOiBGYXRhbCBleGNlcHRpb24KL2tlcm5lbC94ODZfNjQtcmFu
ZGNvbmZpZy1yMS0wNzI2MjExOS9hNDEwOTYzYmE0YzBjNzY4MzAyZjAyOThlMjU4YjFlZTk0
MGU4MzE2L2RtZXNnLXlvY3RvLWtidWlsZC0xMjoyMDE0MDcyNzAwMTY0Mzp4ODZfNjQtcmFu
ZGNvbmZpZy1yMS0wNzI2MjExOTozLjUuMC0wNzEzOS1nYTQxMDk2MzoxMQova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5L2E0MTA5NjNiYTRjMGM3NjgzMDJmMDI5OGUy
NThiMWVlOTQwZTgzMTYvZG1lc2cteW9jdG8ta2J1aWxkLTIxOjIwMTQwNzI3MDAxNjM0Ong4
Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5OjMuNS4wLTA3MTM5LWdhNDEwOTYzOjExCjE2
NjoyOjcgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDctMjcgMDA6
MTk6MjggUkVQRUFUIENPVU5UOiAzMDAgICMgL2MvYm9vdC1iaXNlY3QvbGludXgvb2JqLWJp
c2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiA3MDYyIHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMyBzdGVwcykKW2U4ZmYxM2IwYmY4OGI1ZTY5NjMy
M2ExZWVjODc3NzgzZDk2NWIzYzZdIE1lcmdlIGJyYW5jaCAnZm9yLWxpbnVzJyBvZiBnaXQ6
Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvamlrb3MvaGlkCnJ1
bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9i
b290LWJpc2VjdC9saW51eC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1
ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS9uZXh0Om1hc3RlcjplOGZm
MTNiMGJmODhiNWU2OTYzMjNhMWVlYzg3Nzc4M2Q5NjViM2M2OmJpc2VjdC1saW51eAoKMjAx
NC0wNy0yNy0wMDoxOTo1MiBlOGZmMTNiMGJmODhiNWU2OTYzMjNhMWVlYzg3Nzc4M2Q5NjVi
M2M2IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LWU4ZmYxM2IwYmY4OGI1ZTY5
NjMyM2ExZWVjODc3NzgzZDk2NWIzYzYKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5L2U4ZmYxM2IwYmY4OGI1ZTY5NjMyM2ExZWVj
ODc3NzgzZDk2NWIzYzYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LWU4ZmYxM2IwYmY4
OGI1ZTY5NjMyM2ExZWVjODc3NzgzZDk2NWIzYzYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2pha2V0b3duLWNvbnN1bWVyL3g4Nl82NC1y
YW5kY29uZmlnLXIxLTA3MjYyMTE5LWU4ZmYxM2IwYmY4OGI1ZTY5NjMyM2ExZWVjODc3Nzgz
ZDk2NWIzYzYKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5
L2U4ZmYxM2IwYmY4OGI1ZTY5NjMyM2ExZWVjODc3NzgzZDk2NWIzYzYvdm1saW51ei0zLjUu
MC0wNDI5Mi1nZThmZjEzYgoKMjAxNC0wNy0yNy0wMDoyMzo1MiBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAuLgk1OSBURVNUIEZBSUxVUkUKWyAgICAwLjQ2NTAxMl0gbWljcm9jb2RlOiBDUFUw
IHNpZz0weDMwNmMxLCBwZj0weDEsIHJldmlzaW9uPTB4MQpbICAgIDAuNDY1ODk4XSBtaWNy
b2NvZGU6IE1pY3JvY29kZSBVcGRhdGUgRHJpdmVyOiB2Mi4wMCA8dGlncmFuQGFpdmF6aWFu
LmZzbmV0LmNvLnVrPiwgUGV0ZXIgT3J1YmEKWyAgICAwLjQ2ODc2MF0gYWxnOiBObyB0ZXN0
IGZvciBfX2djbS1hZXMtYWVzbmkgKF9fZHJpdmVyLWdjbS1hZXMtYWVzbmkpClsgICAgMC40
NzA1MDFdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFnaW5nIHJlcXVlc3QgYXQg
ZmZmZjg4MDAxMmMwMDAwMApbICAgIDAuNDcxNTUwXSBJUDogWzxmZmZmZmZmZjgxMGEyYWEy
Pl0ga3pmcmVlKzB4MWIvMHgyOApbICAgIDAuNDcyMzI4XSBQR0QgMTVhMDA2MyBQVUQgMTVh
NDA2MyBQTUQgMTNjZGEwNjcgUFRFIDEyYzAwMTYwClsgICAgMC40NzMyNDVdIE9vcHM6IDAw
MDIgWyMxXSBERUJVR19QQUdFQUxMT0MKWyAgICAwLjQ3MzM0M10gTW9kdWxlcyBsaW5rZWQg
aW46ClsgICAgMC40NzMzNDNdIENQVSAwIApbICAgIDAuNDczMzQzXSBQaWQ6IDMsIGNvbW06
IGtzb2Z0aXJxZC8wIE5vdCB0YWludGVkIDMuNS4wLTA0MjkyLWdlOGZmMTNiICM0IEJvY2hz
IEJvY2hzClsgICAgMC40NzMzNDNdIFJJUDogMDAxMDpbPGZmZmZmZmZmODEwYTJhYTI+XSAg
WzxmZmZmZmZmZjgxMGEyYWEyPl0ga3pmcmVlKzB4MWIvMHgyOApbICAgIDAuNDczMzQzXSBS
U1A6IDAwMTg6ZmZmZjg4MDAxMjgyN2RiOCAgRUZMQUdTOiAwMDAxMDI0NgpbICAgIDAuNDcz
MzQzXSBSQVg6IDAwMDAwMDAwMDAwMDAwMDAgUkJYOiBmZmZmODgwMDEyYTAxMjYwIFJDWDog
MDAwMDAwMDAxMjA5ZTRmOApbICAgIDAuNDczMzQzXSBSRFg6IDAwMDA0ODAwMDAwMDA4ODAg
UlNJOiAwMDAwMDAwMDAwMDAwMDA5IFJESTogZmZmZjg4MDAxMmMwMDAwMApbICAgIDAuNDcz
MzQzXSBSQlA6IGZmZmY4ODAwMTI4MjdkYzAgUjA4OiAwMDAwMDAwMDAwMDAwNjIwIFIwOTog
MDAwMDAwMDAwMDAwMDAwMQpbICAgIDAuNDczMzQzXSBSMTA6IDAwMDAwMDAwMDAwMDAwMDIg
UjExOiAwMDAwMDAwMDAwMDAwMDAxIFIxMjogZmZmZjg4MDAxMmEwMWY0MApbICAgIDAuNDcz
MzQzXSBSMTM6IGZmZmY4ODAwMTI4MjdmZDggUjE0OiAwMDAwMDAwMDAwMDAwMDBhIFIxNTog
MDAwMDAwMDAwMDAwMDEwMQpbICAgIDAuNDczMzQzXSBGUzogIDAwMDAwMDAwMDAwMDAwMDAo
MDAwMCkgR1M6ZmZmZmZmZmY4MTViMDAwMCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAw
ClsgICAgMC40NzMzNDNdIENTOiAgMDAxMCBEUzogMDAwMCBFUzogMDAwMCBDUjA6IDAwMDAw
MDAwODAwNTAwM2IKWyAgICAwLjQ3MzM0M10gQ1IyOiBmZmZmODgwMDEyYzAwMDAwIENSMzog
MDAwMDAwMDAwMTU5ZjAwMCBDUjQ6IDAwMDAwMDAwMDAwNDA2ZjAKWyAgICAwLjQ3MzM0M10g
RFIwOiAwMDAwMDAwMDAwMDAwMDAwIERSMTogMDAwMDAwMDAwMDAwMDAwMCBEUjI6IDAwMDAw
MDAwMDAwMDAwMDAKWyAgICAwLjQ3MzM0M10gRFIzOiAwMDAwMDAwMDAwMDAwMDAwIERSNjog
MDAwMDAwMDBmZmZmMGZmMCBEUjc6IDAwMDAwMDAwMDAwMDA0MDAKWyAgICAwLjQ3MzM0M10g
UHJvY2VzcyBrc29mdGlycWQvMCAocGlkOiAzLCB0aHJlYWRpbmZvIGZmZmY4ODAwMTI4MjYw
MDAsIHRhc2sgZmZmZjg4MDAxMjgxYzAwMCkKWyAgICAwLjQ3MzM0M10gU3RhY2s6ClsgICAg
MC40NzMzNDNdICBmZmZmODgwMDEyYTAxMjYwIGZmZmY4ODAwMTI4MjdkZDggZmZmZmZmZmY4
MTE0NDgzZCBmZmZmODgwMDEyYTAxZjQwClsgICAgMC40NzMzNDNdICBmZmZmODgwMDEyODI3
ZGYwIGZmZmZmZmZmODExNDhiZjEgZmZmZjg4MDAxMmEwMWZjOCBmZmZmODgwMDEyODI3ZTAw
ClsgICAgMC40NzMzNDNdICBmZmZmZmZmZjgxMTQyYzVhIGZmZmY4ODAwMTI4MjdlMjAgZmZm
ZmZmZmY4MTA1OTMyNSBmZmZmODgwMDEyYTAxZmM4ClsgICAgMC40NzMzNDNdIENhbGwgVHJh
Y2U6ClsgICAgMC40NzMzNDNdICBbPGZmZmZmZmZmODExNDQ4M2Q+XSBhYV9mcmVlX3Rhc2tf
Y29udGV4dCsweDZiLzB4NmUKWyAgICAwLjQ3MzM0M10gIFs8ZmZmZmZmZmY4MTE0OGJmMT5d
IGFwcGFybW9yX2NyZWRfZnJlZSsweDExLzB4MWMKWyAgICAwLjQ3MzM0M10gIFs8ZmZmZmZm
ZmY4MTE0MmM1YT5dIHNlY3VyaXR5X2NyZWRfZnJlZSsweDExLzB4MTMKWyAgICAwLjQ3MzM0
M10gIFs8ZmZmZmZmZmY4MTA1OTMyNT5dIHB1dF9jcmVkX3JjdSsweDNhLzB4OGQKWyAgICAw
LjQ3MzM0M10gIFs8ZmZmZmZmZmY4MTA4NzBmND5dIF9fcmN1X3Byb2Nlc3NfY2FsbGJhY2tz
KzB4ODIvMHg5MQpbICAgIDAuNDczMzQzXSAgWzxmZmZmZmZmZjgxMDg3MTEzPl0gcmN1X3By
b2Nlc3NfY2FsbGJhY2tzKzB4MTAvMHgxZQpbICAgIDAuNDczMzQzXSAgWzxmZmZmZmZmZjgx
MDQ0ODE4Pl0gX19kb19zb2Z0aXJxKzB4OTAvMHgxMWYKWyAgICAwLjQ3MzM0M10gIFs8ZmZm
ZmZmZmY4MTA0NDkyZT5dIHJ1bl9rc29mdGlycWQrMHg4Ny8weDEzOQpbICAgIDAuNDczMzQz
XSAgWzxmZmZmZmZmZjgxMDQ0OGE3Pl0gPyBfX2RvX3NvZnRpcnErMHgxMWYvMHgxMWYKWyAg
ICAwLjQ3MzM0M10gIFs8ZmZmZmZmZmY4MTA1NDM1YT5dIGt0aHJlYWQrMHg4NS8weDhkClsg
ICAgMC40NzMzNDNdICBbPGZmZmZmZmZmODEzZTI1OTQ+XSBrZXJuZWxfdGhyZWFkX2hlbHBl
cisweDQvMHgxMApbICAgIDAuNDczMzQzXSAgWzxmZmZmZmZmZjgxMDU0MmQ1Pl0gPyBrdGhy
ZWFkX2ZsdXNoX3dvcmtfZm4rMHhmLzB4ZgpbICAgIDAuNDczMzQzXSAgWzxmZmZmZmZmZjgx
M2UyNTkwPl0gPyBnc19jaGFuZ2UrMHgxMy8weDEzClsgICAgMC40NzMzNDNdIENvZGU6IDQ4
IDg5IGRmIGU4IDlkIDc5IDAxIDAwIDRjIDg5IGUwIDViIDQxIDVjIDVkIGMzIDU1IDQ4IDgz
IGZmIDEwIDQ4IDg5IGU1IDUzIDQ4IDg5IGZiIDc2IDE3IGU4IGNmIDcwIDAxIDAwIDQ4IDg5
IGRmIDQ4IDg5IGMxIDMxIGMwIDxmMz4gYWEgNDggODkgZGYgZTggNzAgNzkgMDEgMDAgNWIg
NWQgYzMgNTUgNDggODkgZTUgNDEgNTUgNDkgODkgClsgICAgMC40NzMzNDNdIFJJUCAgWzxm
ZmZmZmZmZjgxMGEyYWEyPl0ga3pmcmVlKzB4MWIvMHgyOApbICAgIDAuNDczMzQzXSAgUlNQ
IDxmZmZmODgwMDEyODI3ZGI4PgpbICAgIDAuNDczMzQzXSBDUjI6IGZmZmY4ODAwMTJjMDAw
MDAKWyAgICAwLjQ3MzM0M10gLS0tWyBlbmQgdHJhY2UgNGVhYTJhODZhOGUyZGEyMiBdLS0t
ClsgICAgMC40NzMzNDNdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBGYXRhbCBleGNl
cHRpb24gaW4gaW50ZXJydXB0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIx
MTkvZThmZjEzYjBiZjg4YjVlNjk2MzIzYTFlZWM4Nzc3ODNkOTY1YjNjNi9kbWVzZy15b2N0
by1rYnVpbGQtMTE6MjAxNDA3MjcwMDIzMDA6eDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIx
MTk6My41LjAtMDQyOTItZ2U4ZmYxM2I6NAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIx
LTA3MjYyMTE5L2U4ZmYxM2IwYmY4OGI1ZTY5NjMyM2ExZWVjODc3NzgzZDk2NWIzYzYvZG1l
c2cteW9jdG8ta2J1aWxkLTE1OjIwMTQwNzI3MDAyMzAwOng4Nl82NC1yYW5kY29uZmlnLXIx
LTA3MjYyMTE5OjMuNS4wLTA0MjkyLWdlOGZmMTNiOjQKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1yMS0wNzI2MjExOS9lOGZmMTNiMGJmODhiNWU2OTYzMjNhMWVlYzg3Nzc4M2Q5NjVi
M2M2L2RtZXNnLXlvY3RvLWtidWlsZC0yMToyMDE0MDcyNzAwMjMwNTp4ODZfNjQtcmFuZGNv
bmZpZy1yMS0wNzI2MjExOTozLjUuMC0wNDI5Mi1nZThmZjEzYjo0Ci9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctcjEtMDcyNjIxMTkvZThmZjEzYjBiZjg4YjVlNjk2MzIzYTFlZWM4Nzc3
ODNkOTY1YjNjNi9kbWVzZy15b2N0by1rYnVpbGQtMjI6MjAxNDA3MjcwMDIzMDA6eDg2XzY0
LXJhbmRjb25maWctcjEtMDcyNjIxMTk6My41LjAtMDQyOTItZ2U4ZmYxM2I6NAova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5L2U4ZmYxM2IwYmY4OGI1ZTY5NjMyM2Ex
ZWVjODc3NzgzZDk2NWIzYzYvZG1lc2cteW9jdG8ta2J1aWxkLTI1OjIwMTQwNzI3MDAyMzAz
Ong4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5OjMuNS4wLTA0MjkyLWdlOGZmMTNiOjQK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS9lOGZmMTNiMGJmODhiNWU2
OTYzMjNhMWVlYzg3Nzc4M2Q5NjViM2M2L2RtZXNnLXlvY3RvLWtidWlsZC01OjIwMTQwNzI3
MDAyMzAyOng4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5OjMuNS4wLTA0MjkyLWdlOGZm
MTNiOjQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS9lOGZmMTNiMGJm
ODhiNWU2OTYzMjNhMWVlYzg3Nzc4M2Q5NjViM2M2L2RtZXNnLXlvY3RvLWtidWlsZC03OjIw
MTQwNzI3MDAyMzAxOng4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5OjMuNS4wLTA0Mjky
LWdlOGZmMTNiOjQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS9lOGZm
MTNiMGJmODhiNWU2OTYzMjNhMWVlYzg3Nzc4M2Q5NjViM2M2L2RtZXNnLXlvY3RvLWtidWls
ZC04OjIwMTQwNzI3MDAyMzAxOng4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5OjMuNS4w
LTA0MjkyLWdlOGZmMTNiOjQKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjEx
OS9lOGZmMTNiMGJmODhiNWU2OTYzMjNhMWVlYzg3Nzc4M2Q5NjViM2M2L2RtZXNnLXlvY3Rv
LWtidWlsZC0xMzoyMDE0MDcyNzAwMjMxMTp4ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjEx
OTozLjUuMC0wNDI5Mi1nZThmZjEzYjo0Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjEt
MDcyNjIxMTkvZThmZjEzYjBiZjg4YjVlNjk2MzIzYTFlZWM4Nzc3ODNkOTY1YjNjNi9kbWVz
Zy15b2N0by1rYnVpbGQtMjU6MjAxNDA3MjcwMDIzMTk6eDg2XzY0LXJhbmRjb25maWctcjEt
MDcyNjIxMTk6My41LjAtMDQyOTItZ2U4ZmYxM2I6NAova2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXIxLTA3MjYyMTE5L2U4ZmYxM2IwYmY4OGI1ZTY5NjMyM2ExZWVjODc3NzgzZDk2NWIz
YzYvZG1lc2cteW9jdG8ta2J1aWxkLTEzOjIwMTQwNzI3MDAyMzIxOng4Nl82NC1yYW5kY29u
ZmlnLXIxLTA3MjYyMTE5OjMuNS4wLTA0MjkyLWdlOGZmMTNiOjQKNDY6MTE6MjQgYWxsX2dv
b2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2VjdGluZzogMzkzMiByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTIgc3RlcHMpCltlNjZkNjM3MTM0YjcwNDVl
YTZmMTRiZGQ0MTZjZDM2OTVmNzNlZDQyXSBNZXJnZSB0YWcgJ2RtYScgb2YgZ2l0Oi8vZ2l0
Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2FybS9hcm0tc29jCnJ1bm5p
bmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290
LWJpc2VjdC9saW51eC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVl
L2t2bS94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS9uZXh0Om1hc3RlcjplNjZkNjM3
MTM0YjcwNDVlYTZmMTRiZGQ0MTZjZDM2OTVmNzNlZDQyOmJpc2VjdC1saW51eAoKMjAxNC0w
Ny0yNy0wMDoyNToyNSBlNjZkNjM3MTM0YjcwNDVlYTZmMTRiZGQ0MTZjZDM2OTVmNzNlZDQy
IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LWU2NmQ2MzcxMzRiNzA0NWVhNmYx
NGJkZDQxNmNkMzY5NWY3M2VkNDIKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL3g4Nl82
NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5L2U2NmQ2MzcxMzRiNzA0NWVhNmYxNGJkZDQxNmNk
MzY5NWY3M2VkNDIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LWU2NmQ2MzcxMzRiNzA0
NWVhNmYxNGJkZDQxNmNkMzY5NWY3M2VkNDIKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXIxLTA3MjYyMTE5L2U2NmQ2MzcxMzRiNzA0NWVhNmYxNGJkZDQxNmNkMzY5NWY3
M2VkNDIvdm1saW51ei0zLjUuMC0wMTA2Ni1nZTY2ZDYzNwoKMjAxNC0wNy0yNy0wMDoyNzoy
NyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJNyBURVNUIEZBSUxVUkUKWyAgICAwLjQxODg0MF0g
bWljcm9jb2RlOiBDUFUwIHNpZz0weDMwNmMxLCBwZj0weDEsIHJldmlzaW9uPTB4MQpbICAg
IDAuNDE5NDgzXSBtaWNyb2NvZGU6IE1pY3JvY29kZSBVcGRhdGUgRHJpdmVyOiB2Mi4wMCA8
dGlncmFuQGFpdmF6aWFuLmZzbmV0LmNvLnVrPiwgUGV0ZXIgT3J1YmEKWyAgICAwLjQyMTYx
NF0gYWxnOiBObyB0ZXN0IGZvciBfX2djbS1hZXMtYWVzbmkgKF9fZHJpdmVyLWdjbS1hZXMt
YWVzbmkpClsgICAgMC40MjI2NzldIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFn
aW5nIHJlcXVlc3QgYXQgZmZmZjg4MDAxMjI5ZTAwMApbICAgIDAuNDIzNDM0XSBJUDogWzxm
ZmZmZmZmZjgxMGExYTI1Pl0ga3pmcmVlKzB4MWIvMHgyOApbICAgIDAuNDIzNzMwXSBQR0Qg
MTU5ZTA2MyBQVUQgMTVhMjA2MyBQTUQgMTNjZDUwNjcgUFRFIDEyMjllMTYwClsgICAgMC40
MjM3MzBdIE9vcHM6IDAwMDIgWyMxXSBERUJVR19QQUdFQUxMT0MKWyAgICAwLjQyMzczMF0g
TW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMC40MjM3MzBdIENQVSAwIApbICAgIDAuNDIzNzMw
XSBQaWQ6IDMsIGNvbW06IGtzb2Z0aXJxZC8wIE5vdCB0YWludGVkIDMuNS4wLTAxMDY2LWdl
NjZkNjM3ICMxMiBCb2NocyBCb2NocwpbICAgIDAuNDIzNzMwXSBSSVA6IDAwMTA6WzxmZmZm
ZmZmZjgxMGExYTI1Pl0gIFs8ZmZmZmZmZmY4MTBhMWEyNT5dIGt6ZnJlZSsweDFiLzB4MjgK
WyAgICAwLjQyMzczMF0gUlNQOiAwMDE4OmZmZmY4ODAwMTI4MjdkYjggIEVGTEFHUzogMDAw
MTAyNDYKWyAgICAwLjQyMzczMF0gUkFYOiAwMDAwMDAwMDAwMDAwMDAwIFJCWDogZmZmZjg4
MDAxMjI5ZDljMCBSQ1g6IDAwMDAwMDAwMTIyOWQ4NTgKWyAgICAwLjQyMzczMF0gUkRYOiAw
MDAwNDgwMDAwMDAwODgwIFJTSTogMDAwMDAwMDAwMDAwMDAwOSBSREk6IGZmZmY4ODAwMTIy
OWUwMDAKWyAgICAwLjQyMzczMF0gUkJQOiBmZmZmODgwMDEyODI3ZGMwIFIwODogMDAwMDAw
MDAwMDAwMDYyMCBSMDk6IDAwMDAwMDAwMDAwMDAwMDEKWyAgICAwLjQyMzczMF0gUjEwOiAw
MDAwMDAwMDAwMDAwMDA0IFIxMTogMDAwMDAwMDAwMDAwMDAwMSBSMTI6IGZmZmY4ODAwMTIy
OWRkMDAKWyAgICAwLjQyMzczMF0gUjEzOiBmZmZmODgwMDEyODI3ZmQ4IFIxNDogMDAwMDAw
MDAwMDAwMDAwYSBSMTU6IDAwMDAwMDAwMDAwMDAxMDEKWyAgICAwLjQyMzczMF0gRlM6ICAw
MDAwMDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmZmZmZmODE1YWUwMDAoMDAwMCkga25sR1M6
MDAwMDAwMDAwMDAwMDAwMApbICAgIDAuNDIzNzMwXSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6
IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDNiClsgICAgMC40MjM3MzBdIENSMjogZmZmZjg4
MDAxMjI5ZTAwMCBDUjM6IDAwMDAwMDAwMDE1OWQwMDAgQ1I0OiAwMDAwMDAwMDAwMDQwNmYw
ClsgICAgMC40MjM3MzBdIERSMDogMDAwMDAwMDAwMDAwMDAwMCBEUjE6IDAwMDAwMDAwMDAw
MDAwMDAgRFIyOiAwMDAwMDAwMDAwMDAwMDAwClsgICAgMC40MjM3MzBdIERSMzogMDAwMDAw
MDAwMDAwMDAwMCBEUjY6IDAwMDAwMDAwZmZmZjBmZjAgRFI3OiAwMDAwMDAwMDAwMDAwNDAw
ClsgICAgMC40MjM3MzBdIFByb2Nlc3Mga3NvZnRpcnFkLzAgKHBpZDogMywgdGhyZWFkaW5m
byBmZmZmODgwMDEyODI2MDAwLCB0YXNrIGZmZmY4ODAwMTI4MWMwMDApClsgICAgMC40MjM3
MzBdIFN0YWNrOgpbICAgIDAuNDIzNzMwXSAgZmZmZjg4MDAxMjI5ZDljMCBmZmZmODgwMDEy
ODI3ZGQ4IGZmZmZmZmZmODExNDM3Y2MgZmZmZjg4MDAxMjI5ZGQwMApbICAgIDAuNDIzNzMw
XSAgZmZmZjg4MDAxMjgyN2RmMCBmZmZmZmZmZjgxMTQ3YjgwIGZmZmY4ODAwMTIyOWRkODgg
ZmZmZjg4MDAxMjgyN2UwMApbICAgIDAuNDIzNzMwXSAgZmZmZmZmZmY4MTE0MWJiNCBmZmZm
ODgwMDEyODI3ZTIwIGZmZmZmZmZmODEwNTgyYjUgZmZmZjg4MDAxMjI5ZGQ4OApbICAgIDAu
NDIzNzMwXSBDYWxsIFRyYWNlOgpbICAgIDAuNDIzNzMwXSAgWzxmZmZmZmZmZjgxMTQzN2Nj
Pl0gYWFfZnJlZV90YXNrX2NvbnRleHQrMHg2Yi8weDZlClsgICAgMC40MjM3MzBdICBbPGZm
ZmZmZmZmODExNDdiODA+XSBhcHBhcm1vcl9jcmVkX2ZyZWUrMHgxMS8weDFjClsgICAgMC40
MjM3MzBdICBbPGZmZmZmZmZmODExNDFiYjQ+XSBzZWN1cml0eV9jcmVkX2ZyZWUrMHgxMS8w
eDEzClsgICAgMC40MjM3MzBdICBbPGZmZmZmZmZmODEwNTgyYjU+XSBwdXRfY3JlZF9yY3Ur
MHgzYS8weDhkClsgICAgMC40MjM3MzBdICBbPGZmZmZmZmZmODEwODYwNzc+XSBfX3JjdV9w
cm9jZXNzX2NhbGxiYWNrcysweDgyLzB4OTEKWyAgICAwLjQyMzczMF0gIFs8ZmZmZmZmZmY4
MTA4NjA5Nj5dIHJjdV9wcm9jZXNzX2NhbGxiYWNrcysweDEwLzB4MWUKWyAgICAwLjQyMzcz
MF0gIFs8ZmZmZmZmZmY4MTA0MzdhOD5dIF9fZG9fc29mdGlycSsweDkwLzB4MTFmClsgICAg
MC40MjM3MzBdICBbPGZmZmZmZmZmODEwNDM4YmU+XSBydW5fa3NvZnRpcnFkKzB4ODcvMHgx
MzkKWyAgICAwLjQyMzczMF0gIFs8ZmZmZmZmZmY4MTA0MzgzNz5dID8gX19kb19zb2Z0aXJx
KzB4MTFmLzB4MTFmClsgICAgMC40MjM3MzBdICBbPGZmZmZmZmZmODEwNTMyZWE+XSBrdGhy
ZWFkKzB4ODUvMHg4ZApbICAgIDAuNDIzNzMwXSAgWzxmZmZmZmZmZjgxM2UwZjE0Pl0ga2Vy
bmVsX3RocmVhZF9oZWxwZXIrMHg0LzB4MTAKWyAgICAwLjQyMzczMF0gIFs8ZmZmZmZmZmY4
MTA1MzI2NT5dID8ga3RocmVhZF9mbHVzaF93b3JrX2ZuKzB4Zi8weGYKWyAgICAwLjQyMzcz
MF0gIFs8ZmZmZmZmZmY4MTNlMGYxMD5dID8gZ3NfY2hhbmdlKzB4MTMvMHgxMwpbICAgIDAu
NDIzNzMwXSBDb2RlOiA0OCA4OSBkZiBlOCA3NCA3OSAwMSAwMCA0YyA4OSBlMCA1YiA0MSA1
YyA1ZCBjMyA1NSA0OCA4MyBmZiAxMCA0OCA4OSBlNSA1MyA0OCA4OSBmYiA3NiAxNyBlOCBh
NiA3MCAwMSAwMCA0OCA4OSBkZiA0OCA4OSBjMSAzMSBjMCA8ZjM+IGFhIDQ4IDg5IGRmIGU4
IDQ3IDc5IDAxIDAwIDViIDVkIGMzIDU1IDQ4IDg5IGU1IDQxIDU1IDQ5IDg5IApbICAgIDAu
NDIzNzMwXSBSSVAgIFs8ZmZmZmZmZmY4MTBhMWEyNT5dIGt6ZnJlZSsweDFiLzB4MjgKWyAg
ICAwLjQyMzczMF0gIFJTUCA8ZmZmZjg4MDAxMjgyN2RiOD4KWyAgICAwLjQyMzczMF0gQ1Iy
OiBmZmZmODgwMDEyMjllMDAwClsgICAgMC40MjM3MzBdIC0tLVsgZW5kIHRyYWNlIDRlYWEy
YTg2YThlMmRhMjIgXS0tLQpbICAgIDAuNDIzNzMwXSBLZXJuZWwgcGFuaWMgLSBub3Qgc3lu
Y2luZzogRmF0YWwgZXhjZXB0aW9uIGluIGludGVycnVwdAova2VybmVsL3g4Nl82NC1yYW5k
Y29uZmlnLXIxLTA3MjYyMTE5L2U2NmQ2MzcxMzRiNzA0NWVhNmYxNGJkZDQxNmNkMzY5NWY3
M2VkNDIvZG1lc2cteW9jdG8ta2J1aWxkLTExOjIwMTQwNzI3MDAyNTE5Ong4Nl82NC1yYW5k
Y29uZmlnLXIxLTA3MjYyMTE5OjMuNS4wLTAxMDY2LWdlNjZkNjM3OjEyCi9rZXJuZWwveDg2
XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTkvZTY2ZDYzNzEzNGI3MDQ1ZWE2ZjE0YmRkNDE2
Y2QzNjk1ZjczZWQ0Mi9kbWVzZy15b2N0by1rYnVpbGQtNToyMDE0MDcyNzAwMjUzMTp4ODZf
NjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOTozLjUuMC0wMTA2Ni1nZTY2ZDYzNzoxMgova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5L2U2NmQ2MzcxMzRiNzA0NWVhNmYx
NGJkZDQxNmNkMzY5NWY3M2VkNDIvZG1lc2cteW9jdG8ta2J1aWxkLTMwOjIwMTQwNzI3MDAy
NTQwOng4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5OjMuNS4wLTAxMDY2LWdlNjZkNjM3
OjEyCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTkvZTY2ZDYzNzEzNGI3
MDQ1ZWE2ZjE0YmRkNDE2Y2QzNjk1ZjczZWQ0Mi9kbWVzZy15b2N0by1rYnVpbGQtMjY6MjAx
NDA3MjcwMDI1NDk6eDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTk6My41LjAtMDEwNjYt
Z2U2NmQ2Mzc6MTIKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS9lNjZk
NjM3MTM0YjcwNDVlYTZmMTRiZGQ0MTZjZDM2OTVmNzNlZDQyL2RtZXNnLXlvY3RvLWtidWls
ZC0yNzoyMDE0MDcyNzAwMjU1Njp4ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOTozLjUu
MC0wMTA2Ni1nZTY2ZDYzNzoxMgowOjU6MTMgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMK
CkJpc2VjdGluZzogMTA2NiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJv
dWdobHkgMTEgc3RlcHMpCls3Y2Q1OGIwYTNiMzNjYTllMWYxZGQxNWIzMGM3MDhlZjc3YmE2
ZDNlXSBNZXJnZSB0YWcgJ3JlZ21hcC0zLjYnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1
Yi9zY20vbGludXgva2VybmVsL2dpdC9icm9vbmllL3JlZ21hcApydW5uaW5nIC9jL2tlcm5l
bC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGlu
dXgvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LXJhbmRjb25maWctcjEtMDcyNjIxMTkvbmV4dDptYXN0ZXI6N2NkNThiMGEzYjMzY2E5ZTFm
MWRkMTViMzBjNzA4ZWY3N2JhNmQzZTpiaXNlY3QtbGludXgKCjIwMTQtMDctMjctMDA6MzA6
NTYgN2NkNThiMGEzYjMzY2E5ZTFmMWRkMTViMzBjNzA4ZWY3N2JhNmQzZSBjb21waWxpbmcK
UXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQt
cmFuZGNvbmZpZy1yMS0wNzI2MjExOS03Y2Q1OGIwYTNiMzNjYTllMWYxZGQxNWIzMGM3MDhl
Zjc3YmE2ZDNlCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1yMS0wNzI2MjExOS83Y2Q1OGIwYTNiMzNjYTllMWYxZGQxNWIzMGM3MDhlZjc3YmE2ZDNl
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94
ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS03Y2Q1OGIwYTNiMzNjYTllMWYxZGQxNWIz
MGM3MDhlZjc3YmE2ZDNlCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0
cy9idWlsZC1xdWV1ZS9qYWtldG93bi1jb25zdW1lci94ODZfNjQtcmFuZGNvbmZpZy1yMS0w
NzI2MjExOS03Y2Q1OGIwYTNiMzNjYTllMWYxZGQxNWIzMGM3MDhlZjc3YmE2ZDNlCmtlcm5l
bDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS83Y2Q1OGIwYTNiMzNj
YTllMWYxZGQxNWIzMGM3MDhlZjc3YmE2ZDNlL3ZtbGludXotMy41LjAtMDAzMTMtZzdjZDU4
YjAKCjIwMTQtMDctMjctMDA6MzU6NTYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JNDUJNDkJ
NzcJMTEwCTEyOAkxMzkuCTE4NgkxOTAuCTI0MgkyNTIJMjk3CTMwMCBTVUNDRVNTCgpCaXNl
Y3Rpbmc6IDc1MyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
MTAgc3RlcHMpClthNjZkMmM4ZjdlYzEyODQyMDZjYTdjMTQ1NjllMmE2MDc1ODNmMWUzXSBN
ZXJnZSBicmFuY2ggJ2Zvci1saW51cy0yJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIv
c2NtL2xpbnV4L2tlcm5lbC9naXQvdmlyby92ZnMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4L29iai1i
aXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29u
ZmlnLXIxLTA3MjYyMTE5L25leHQ6bWFzdGVyOmE2NmQyYzhmN2VjMTI4NDIwNmNhN2MxNDU2
OWUyYTYwNzU4M2YxZTM6YmlzZWN0LWxpbnV4CgoyMDE0LTA3LTI3LTAwOjQ0OjE3IGE2NmQy
YzhmN2VjMTI4NDIwNmNhN2MxNDU2OWUyYTYwNzU4M2YxZTMgY29tcGlsaW5nClF1ZXVlZCBi
dWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25m
aWctcjEtMDcyNjIxMTktYTY2ZDJjOGY3ZWMxMjg0MjA2Y2E3YzE0NTY5ZTJhNjA3NTgzZjFl
MwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjEtMDcy
NjIxMTkvYTY2ZDJjOGY3ZWMxMjg0MjA2Y2E3YzE0NTY5ZTJhNjA3NTgzZjFlMwp3YWl0aW5n
IGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJh
bmRjb25maWctcjEtMDcyNjIxMTktYTY2ZDJjOGY3ZWMxMjg0MjA2Y2E3YzE0NTY5ZTJhNjA3
NTgzZjFlMwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQt
cXVldWUvbGtwLWhzeDAxLWNvbnN1bWVyL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5
LWE2NmQyYzhmN2VjMTI4NDIwNmNhN2MxNDU2OWUyYTYwNzU4M2YxZTMKa2VybmVsOiAva2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5L2E2NmQyYzhmN2VjMTI4NDIwNmNh
N2MxNDU2OWUyYTYwNzU4M2YxZTMvdm1saW51ei0zLjUuMC0wMDgzNy1nYTY2ZDJjOAoKMjAx
NC0wNy0yNy0wMDo0NzoxNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTE2CTI3Li4JNjAJNjEJ
NjQuCTEwMy4JMTI4CTE2NwkxODkJMjE4IFRFU1QgRkFJTFVSRQovYmluL3NoOiAvcHJvYy9z
ZWxmL2ZkLzk6IE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkKL2Jpbi9zaDogL3Byb2Mvc2Vs
Zi9mZC85OiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5CgpCVUc6IGtlcm5lbCBib290IGhh
bmcKRWxhcHNlZCB0aW1lOiAzNQpxZW11LXN5c3RlbS14ODZfNjQgLWVuYWJsZS1rdm0gLWNw
dSBIYXN3ZWxsLCtzbWVwLCtzbWFwIC1rZXJuZWwgL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZp
Zy1yMS0wNzI2MjExOS9hNjZkMmM4ZjdlYzEyODQyMDZjYTdjMTQ1NjllMmE2MDc1ODNmMWUz
L3ZtbGludXotMy41LjAtMDA4MzctZ2E2NmQyYzggLWFwcGVuZCAnaHVuZ190YXNrX3Bhbmlj
PTEgZWFybHlwcmludGs9dHR5UzAsMTE1MjAwIGRlYnVnIGFwaWM9ZGVidWcgc3lzcnFfYWx3
YXlzX2VuYWJsZWQgcmN1cGRhdGUucmN1X2NwdV9zdGFsbF90aW1lb3V0PTEwMCBwYW5pYz0x
MCBzb2Z0bG9ja3VwX3BhbmljPTEgbm1pX3dhdGNoZG9nPXBhbmljICBwcm9tcHRfcmFtZGlz
az0wIGNvbnNvbGU9dHR5UzAsMTE1MjAwIGNvbnNvbGU9dHR5MCB2Z2E9bm9ybWFsICByb290
PS9kZXYvcmFtMCBydyBsaW5rPS9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQt
cmFuZGNvbmZpZy1yMS0wNzI2MjExOS9uZXh0Om1hc3RlcjphNjZkMmM4ZjdlYzEyODQyMDZj
YTdjMTQ1NjllMmE2MDc1ODNmMWUzOmJpc2VjdC1saW51eC8udm1saW51ei1hNjZkMmM4Zjdl
YzEyODQyMDZjYTdjMTQ1NjllMmE2MDc1ODNmMWUzLTIwMTQwNzI3MDg0NzEzLTIwMi1rYnVp
bGQgYnJhbmNoPW5leHQvbWFzdGVyIEJPT1RfSU1BR0U9L2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1yMS0wNzI2MjExOS9hNjZkMmM4ZjdlYzEyODQyMDZjYTdjMTQ1NjllMmE2MDc1ODNm
MWUzL3ZtbGludXotMy41LjAtMDA4MzctZ2E2NmQyYzggZHJiZC5taW5vcl9jb3VudD04JyAg
LWluaXRyZCAva2VybmVsLXRlc3RzL2luaXRyZC9xdWFudGFsLWNvcmUteDg2XzY0LmNneiAt
bSAzMjAgLXNtcCAyIC1uZXQgbmljLHZsYW49MSxtb2RlbD1lMTAwMCAtbmV0IHVzZXIsdmxh
bj0xIC1ib290IG9yZGVyPW5jIC1uby1yZWJvb3QgLXdhdGNoZG9nIGk2MzAwZXNiIC1ydGMg
YmFzZT1sb2NhbHRpbWUgLXBpZGZpbGUgL2Rldi9zaG0va2Jvb3QvcGlkLXF1YW50YWwta2J1
aWxkLTI4IC1zZXJpYWwgZmlsZTovZGV2L3NobS9rYm9vdC9zZXJpYWwtcXVhbnRhbC1rYnVp
bGQtMjggLWRhZW1vbml6ZSAtZGlzcGxheSBub25lIC1tb25pdG9yIG51bGwgCi9rZXJuZWwv
eDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTkvYTY2ZDJjOGY3ZWMxMjg0MjA2Y2E3YzE0
NTY5ZTJhNjA3NTgzZjFlMy9kbWVzZy15b2N0by1rYnVpbGQtMTA6MjAxNDA3MjcwMDUyNDQ6
eDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTk6My41LjAtMDA4MzctZ2E2NmQyYzg6MTMK
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS9hNjZkMmM4ZjdlYzEyODQy
MDZjYTdjMTQ1NjllMmE2MDc1ODNmMWUzL2RtZXNnLXlvY3RvLWtidWlsZC0yOToyMDE0MDcy
NzAwNTI0NTp4ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOTozLjUuMC0wMDgzNy1nYTY2
ZDJjODoxMwoyMTM6Mjo3IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0
LTA3LTI3IDAwOjU0OjUxIFJFUEVBVCBDT1VOVDogMzAwICAjIC9jL2Jvb3QtYmlzZWN0L2xp
bnV4L29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCkJpc2VjdGluZzogNTI0IHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMCBzdGVwcykKWzcxMDBlNTA1Yjc2
YjRlMmVmZDg4YjI0NTlkMWE5MzIyMTRlMjlmOGFdIE1lcmdlIHRhZyAncG0tZm9yLTMuNi1y
YzEnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9y
YWZhZWwvbGludXgtcG0KcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9v
dC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4L29iai1iaXNlY3QKbHMgLWEgL2ti
dWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5
L25leHQ6bWFzdGVyOjcxMDBlNTA1Yjc2YjRlMmVmZDg4YjI0NTlkMWE5MzIyMTRlMjlmOGE6
YmlzZWN0LWxpbnV4CgoyMDE0LTA3LTI3LTAwOjU0OjUyIDcxMDBlNTA1Yjc2YjRlMmVmZDg4
YjI0NTlkMWE5MzIyMTRlMjlmOGEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTkt
NzEwMGU1MDViNzZiNGUyZWZkODhiMjQ1OWQxYTkzMjIxNGUyOWY4YQpDaGVjayBmb3Iga2Vy
bmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTkvNzEwMGU1MDVi
NzZiNGUyZWZkODhiMjQ1OWQxYTkzMjIxNGUyOWY4YQp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2XzY0LXJhbmRjb25maWctcjEtMDcy
NjIxMTktNzEwMGU1MDViNzZiNGUyZWZkODhiMjQ1OWQxYTkzMjIxNGUyOWY4YQprZXJuZWw6
IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTkvNzEwMGU1MDViNzZiNGUy
ZWZkODhiMjQ1OWQxYTkzMjIxNGUyOWY4YS92bWxpbnV6LTMuNS4wLTAwNjMyLWc3MTAwZTUw
CgoyMDE0LTA3LTI3LTAwOjU2OjUyIGRldGVjdGluZyBib290IHN0YXRlIC4uLgkyMgkyMy4J
MzEJMzYJMzcuCTQxLi4JNjEJNjIJNzIJODQuCTEwMQkxMDYJMTU3CTE2NAkxODMJMjE0CTIy
MAkyNTAJMjc0CTI4MAkzMDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAyMDUgcmV2aXNpb25zIGxl
ZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDggc3RlcHMpCls1YjE2MGJkNDI2OTQ2
Yzg1ZjMyYjE1ZTVkMzRkNjJkMjYxOGE1YTg3XSBNZXJnZSBicmFuY2ggJ3g4Ni1tY2UtZm9y
LWxpbnVzJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9n
aXQvdGlwL3RpcApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgvb2JqLWJpc2VjdApscyAtYSAva2J1aWxk
LXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTkvbmV4
dDptYXN0ZXI6NWIxNjBiZDQyNjk0NmM4NWYzMmIxNWU1ZDM0ZDYyZDI2MThhNWE4NzpiaXNl
Y3QtbGludXgKCjIwMTQtMDctMjctMDE6MTE6MjMgNWIxNjBiZDQyNjk0NmM4NWYzMmIxNWU1
ZDM0ZDYyZDI2MThhNWE4NyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS01YjE2
MGJkNDI2OTQ2Yzg1ZjMyYjE1ZTVkMzRkNjJkMjYxOGE1YTg3CkNoZWNrIGZvciBrZXJuZWwg
aW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS81YjE2MGJkNDI2OTQ2
Yzg1ZjMyYjE1ZTVkMzRkNjJkMjYxOGE1YTg3CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2Yg
L2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjEx
OS01YjE2MGJkNDI2OTQ2Yzg1ZjMyYjE1ZTVkMzRkNjJkMjYxOGE1YTg3Cmtlcm5lbDogL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS81YjE2MGJkNDI2OTQ2Yzg1ZjMy
YjE1ZTVkMzRkNjJkMjYxOGE1YTg3L3ZtbGludXotMy41LjAtMDA2NDYtZzViMTYwYmQKCjIw
MTQtMDctMjctMDE6MTM6MjMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTE3CTU5Lgk3MwkxMTEJ
MTE3CTE2MAkxNjMJMTg2CTIzNAkyNDYJMjc0CTMwMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDE5
MSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOCBzdGVwcykK
W2E2YmUxZmNiYzU3Zjk1YmI0N2VmM2M4ZTRlZTNkODM3MzFiOGYyMWVdIE1lcmdlIHRhZyAn
bW1jLW1lcmdlLWZvci0zLjYtcmMxJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2Nt
L2xpbnV4L2tlcm5lbC9naXQvY2piL21tYwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgvb2JqLWJpc2Vj
dApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWct
cjEtMDcyNjIxMTkvbmV4dDptYXN0ZXI6YTZiZTFmY2JjNTdmOTViYjQ3ZWYzYzhlNGVlM2Q4
MzczMWI4ZjIxZTpiaXNlY3QtbGludXgKCjIwMTQtMDctMjctMDE6MTk6NTMgYTZiZTFmY2Jj
NTdmOTViYjQ3ZWYzYzhlNGVlM2Q4MzczMWI4ZjIxZSBjb21waWxpbmcKUXVldWVkIGJ1aWxk
IHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1y
MS0wNzI2MjExOS1hNmJlMWZjYmM1N2Y5NWJiNDdlZjNjOGU0ZWUzZDgzNzMxYjhmMjFlCkNo
ZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjEx
OS9hNmJlMWZjYmM1N2Y5NWJiNDdlZjNjOGU0ZWUzZDgzNzMxYjhmMjFlCndhaXRpbmcgZm9y
IGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNv
bmZpZy1yMS0wNzI2MjExOS1hNmJlMWZjYmM1N2Y5NWJiNDdlZjNjOGU0ZWUzZDgzNzMxYjhm
MjFlCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS9hNmJl
MWZjYmM1N2Y5NWJiNDdlZjNjOGU0ZWUzZDgzNzMxYjhmMjFlL3ZtbGludXotMy41LjAtMDA3
MDktZ2E2YmUxZmMKCjIwMTQtMDctMjctMDE6MjE6NTMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
Li4JMQkyNAkyNgkyOAk2MAk2Mgk2Mwk5NAk5OAkxMDQJMTI5CTEzMQkxNTcJMTY3CTIwMgky
NTUJMjc4CTMwMCBTVUNDRVNTCgpsaW5lYXItYmlzZWN0OiBiYWQgYnJhbmNoIG1heSBiZSBi
cmFuY2ggJ2Zvci1saW51cy0yJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xp
bnV4L2tlcm5lbC9naXQvdmlyby92ZnMKbGluZWFyLWJpc2VjdDogaGFuZGxlIG92ZXIgdG8g
Z2l0IGJpc2VjdApsaW5lYXItYmlzZWN0OiBnaXQgYmlzZWN0IHN0YXJ0IGE2NmQyYzhmN2Vj
MTI4NDIwNmNhN2MxNDU2OWUyYTYwNzU4M2YxZTMgYTZiZTFmY2JjNTdmOTViYjQ3ZWYzYzhl
NGVlM2Q4MzczMWI4ZjIxZSAtLQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBhNmJlMWZj
Li4uIE1lcmdlIHRhZyAnbW1jLW1lcmdlLWZvci0zLjYtcmMxJyBvZiBnaXQ6Ly9naXQua2Vy
bmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvY2piL21tYwpIRUFEIGlzIG5vdyBh
dCBmY2IyMTMzLi4uIE1lcmdlICdqYmFybmVzL2FzeW5jLWZiLXByb2JlJyBpbnRvIGRldmVs
LXJvYW0taTM4Ni0yMDE0MDUzMDAyMDEKQmlzZWN0aW5nOiA2MyByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNiBzdGVwcykKWzc5NzE0ZjcyZDNiOTY0NjEx
OTk3ZGU1MTJjYjI5MTk4YzlmMmRiYmJdIGdldCByaWQgb2Yga2Vybl9wYXRoX3BhcmVudCgp
CmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3QgcnVuIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgvb2JqLWJpc2VjdApy
dW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2Mv
Ym9vdC1iaXNlY3QvbGludXgvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1x
dWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTkvbmV4dDptYXN0ZXI6Nzk3
MTRmNzJkM2I5NjQ2MTE5OTdkZTUxMmNiMjkxOThjOWYyZGJiYjpiaXNlY3QtbGludXgKCjIw
MTQtMDctMjctMDE6Mzg6NDQgNzk3MTRmNzJkM2I5NjQ2MTE5OTdkZTUxMmNiMjkxOThjOWYy
ZGJiYiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS03OTcxNGY3MmQzYjk2NDYx
MTk5N2RlNTEyY2IyOTE5OGM5ZjJkYmJiCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS83OTcxNGY3MmQzYjk2NDYxMTk5N2RlNTEy
Y2IyOTE5OGM5ZjJkYmJiCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0
cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS03OTcxNGY3MmQz
Yjk2NDYxMTk5N2RlNTEyY2IyOTE5OGM5ZjJkYmJiCmtlcm5lbDogL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1yMS0wNzI2MjExOS83OTcxNGY3MmQzYjk2NDYxMTk5N2RlNTEyY2IyOTE5
OGM5ZjJkYmJiL3ZtbGludXotMy41LjAtcmM2LTAwMjYwLWc3OTcxNGY3CgoyMDE0LTA3LTI3
LTAxOjQwOjQ0IGRldGVjdGluZyBib290IHN0YXRlIAk3CTExMwkxMjMJMjMyCTMwMCBTVUND
RVNTCgpCaXNlY3Rpbmc6IDMxIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAo
cm91Z2hseSA1IHN0ZXBzKQpbNzE1MTg5ZDgzNmFiMjc2YjNkMGZjMTE0NjgxZjEyYjQyMzY4
NmZmYV0gaGZzOiBwdXNoIGxvY2tfc3VwZXIgZG93bgpydW5uaW5nIC9jL2tlcm5lbC10ZXN0
cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgvb2Jq
LWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRj
b25maWctcjEtMDcyNjIxMTkvbmV4dDptYXN0ZXI6NzE1MTg5ZDgzNmFiMjc2YjNkMGZjMTE0
NjgxZjEyYjQyMzY4NmZmYTpiaXNlY3QtbGludXgKCjIwMTQtMDctMjctMDE6NDM6MTYgNzE1
MTg5ZDgzNmFiMjc2YjNkMGZjMTE0NjgxZjEyYjQyMzY4NmZmYSBjb21waWxpbmcKUXVldWVk
IGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNv
bmZpZy1yMS0wNzI2MjExOS03MTUxODlkODM2YWIyNzZiM2QwZmMxMTQ2ODFmMTJiNDIzNjg2
ZmZhCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0w
NzI2MjExOS83MTUxODlkODM2YWIyNzZiM2QwZmMxMTQ2ODFmMTJiNDIzNjg2ZmZhCndhaXRp
bmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQt
cmFuZGNvbmZpZy1yMS0wNzI2MjExOS03MTUxODlkODM2YWIyNzZiM2QwZmMxMTQ2ODFmMTJi
NDIzNjg2ZmZhCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS9qYWtldG93bi1jb25zdW1lci94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjEx
OS03MTUxODlkODM2YWIyNzZiM2QwZmMxMTQ2ODFmMTJiNDIzNjg2ZmZhCmtlcm5lbDogL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS83MTUxODlkODM2YWIyNzZiM2Qw
ZmMxMTQ2ODFmMTJiNDIzNjg2ZmZhL3ZtbGludXotMy41LjAtcmM2LTAwMjcwLWc3MTUxODlk
CgoyMDE0LTA3LTI3LTAxOjQ4OjE2IGRldGVjdGluZyBib290IHN0YXRlIC4uCTE3CTI1Lgk1
Mgk1NAk1NQk2NyBURVNUIEZBSUxVUkUKWyAgICAwLjUxNjE5Nl0gbWljcm9jb2RlOiBDUFUw
IHNpZz0weDMwNmMxLCBwZj0weDEsIHJldmlzaW9uPTB4MQpbICAgIDAuNTE3MDI4XSBtaWNy
b2NvZGU6IE1pY3JvY29kZSBVcGRhdGUgRHJpdmVyOiB2Mi4wMCA8dGlncmFuQGFpdmF6aWFu
LmZzbmV0LmNvLnVrPiwgUGV0ZXIgT3J1YmEKWyAgICAwLjUxOTcyMV0gYWxnOiBObyB0ZXN0
IGZvciBfX2djbS1hZXMtYWVzbmkgKF9fZHJpdmVyLWdjbS1hZXMtYWVzbmkpClsgICAgMC41
MjEwODFdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFnaW5nIHJlcXVlc3QgYXQg
ZmZmZjg4MDAxMjI5ZTAwMApbICAgIDAuNTIyMDM5XSBJUDogWzxmZmZmZmZmZjgxMGExNWRk
Pl0ga3pmcmVlKzB4MWMvMHgyYQpbICAgIDAuNTIyNzQzXSBQR0QgMTVhMDA2MyBQVUQgMTVh
NDA2MyBQTUQgMTNjZDUwNjcgUFRFIDEyMjllMTYwClsgICAgMC41MjM1ODldIE9vcHM6IDAw
MDIgWyMxXSBERUJVR19QQUdFQUxMT0MKWyAgICAwLjUyMzkzN10gQ1BVIDAgClsgICAgMC41
MjM5MzddIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDAuNTIzOTM3XSAKWyAgICAwLjUyMzkz
N10gUGlkOiAzLCBjb21tOiBrc29mdGlycWQvMCBOb3QgdGFpbnRlZCAzLjUuMC1yYzYtMDAy
NzAtZzcxNTE4OWQgIzYgQm9jaHMgQm9jaHMKWyAgICAwLjUyMzkzN10gUklQOiAwMDEwOls8
ZmZmZmZmZmY4MTBhMTVkZD5dICBbPGZmZmZmZmZmODEwYTE1ZGQ+XSBremZyZWUrMHgxYy8w
eDJhClsgICAgMC41MjM5MzddIFJTUDogMDAxODpmZmZmODgwMDEyODI3ZDgwICBFRkxBR1M6
IDAwMDEwMjQ2ClsgICAgMC41MjM5MzddIFJBWDogMDAwMDAwMDAwMDAwMDAwMCBSQlg6IGZm
ZmY4ODAwMTIyOWQ1MDAgUkNYOiAwMDAwMDAwMDEyMjljZDE4ClsgICAgMC41MjM5MzddIFJE
WDogMDAwMDAwMDAwMDAwMDAwMCBSU0k6IDAwMDAwMDAwMDAwMDAwMDkgUkRJOiBmZmZmODgw
MDEyMjllMDAwClsgICAgMC41MjM5MzddIFJCUDogZmZmZjg4MDAxMjgyN2Q5MCBSMDg6IGZm
ZmY4ODAwMDdmZmZmZTAgUjA5OiAwMDAwMDAwMDAwMDAwMDA0ClsgICAgMC41MjM5MzddIFIx
MDogMDAwMDAwMDAwMDAwMDAwMCBSMTE6IDAwMDAwMDAwMDAwMDAwMDEgUjEyOiBmZmZmODgw
MDEyMjlkOGMwClsgICAgMC41MjM5MzddIFIxMzogZmZmZjg4MDAxMjgyN2ZkOCBSMTQ6IDAw
MDAwMDAwMDAwMDAwMGEgUjE1OiAwMDAwMDAwMDAwMDAwMTAxClsgICAgMC41MjM5MzddIEZT
OiAgMDAwMDAwMDAwMDAwMDAwMCgwMDAwKSBHUzpmZmZmZmZmZjgxNWIwMDAwKDAwMDApIGtu
bEdTOjAwMDAwMDAwMDAwMDAwMDAKWyAgICAwLjUyMzkzN10gQ1M6ICAwMDEwIERTOiAwMDAw
IEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzYgpbICAgIDAuNTIzOTM3XSBDUjI6IGZm
ZmY4ODAwMTIyOWUwMDAgQ1IzOiAwMDAwMDAwMDAxNTlmMDAwIENSNDogMDAwMDAwMDAwMDA0
MDZmMApbICAgIDAuNTIzOTM3XSBEUjA6IDAwMDAwMDAwMDAwMDAwMDAgRFIxOiAwMDAwMDAw
MDAwMDAwMDAwIERSMjogMDAwMDAwMDAwMDAwMDAwMApbICAgIDAuNTIzOTM3XSBEUjM6IDAw
MDAwMDAwMDAwMDAwMDAgRFI2OiAwMDAwMDAwMGZmZmYwZmYwIERSNzogMDAwMDAwMDAwMDAw
MDQwMApbICAgIDAuNTIzOTM3XSBQcm9jZXNzIGtzb2Z0aXJxZC8wIChwaWQ6IDMsIHRocmVh
ZGluZm8gZmZmZjg4MDAxMjgyNjAwMCwgdGFzayBmZmZmODgwMDEyODFjMDAwKQpbICAgIDAu
NTIzOTM3XSBTdGFjazoKWyAgICAwLjUyMzkzN10gIGZmZmZmZmZmODE1YzE2MDAgZmZmZjg4
MDAxMjI5ZDUwMCBmZmZmODgwMDEyODI3ZGIwIGZmZmZmZmZmODExNDQ4ZWYKWyAgICAwLjUy
MzkzN10gIGZmZmZmZmZmODE1YzE2YTAgZmZmZjg4MDAxMjI5ZDhjMCBmZmZmODgwMDEyODI3
ZGQwIGZmZmZmZmZmODExNDhkNDIKWyAgICAwLjUyMzkzN10gIGZmZmZmZmZmODE1Yzc4MzAg
ZmZmZjg4MDAxMjI5ZDk0OCBmZmZmODgwMDEyODI3ZGUwIGZmZmZmZmZmODExNDJjYzMKWyAg
ICAwLjUyMzkzN10gQ2FsbCBUcmFjZToKWyAgICAwLjUyMzkzN10gIFs8ZmZmZmZmZmY4MTE0
NDhlZj5dIGFhX2ZyZWVfdGFza19jb250ZXh0KzB4NmMvMHg3MApbICAgIDAuNTIzOTM3XSAg
WzxmZmZmZmZmZjgxMTQ4ZDQyPl0gYXBwYXJtb3JfY3JlZF9mcmVlKzB4MTIvMHgxZQpbICAg
IDAuNTIzOTM3XSAgWzxmZmZmZmZmZjgxMTQyY2MzPl0gc2VjdXJpdHlfY3JlZF9mcmVlKzB4
MTEvMHgxMwpbICAgIDAuNTIzOTM3XSAgWzxmZmZmZmZmZjgxMDU3Nzg0Pl0gcHV0X2NyZWRf
cmN1KzB4M2EvMHg4ZApbICAgIDAuNTIzOTM3XSAgWzxmZmZmZmZmZjgxMDg1OTQ2Pl0gX19y
Y3VfcHJvY2Vzc19jYWxsYmFja3MrMHg4Mi8weDkxClsgICAgMC41MjM5MzddICBbPGZmZmZm
ZmZmODEwODU5NjU+XSByY3VfcHJvY2Vzc19jYWxsYmFja3MrMHgxMC8weDFlClsgICAgMC41
MjM5MzddICBbPGZmZmZmZmZmODEwNDI5Mjk+XSBfX2RvX3NvZnRpcnErMHg5MC8weDEyMQpb
ICAgIDAuNTIzOTM3XSAgWzxmZmZmZmZmZjgxMDQyYTQ0Pl0gcnVuX2tzb2Z0aXJxZCsweDhh
LzB4MTNmClsgICAgMC41MjM5MzddICBbPGZmZmZmZmZmODEwNDI5YmE+XSA/IF9fZG9fc29m
dGlycSsweDEyMS8weDEyMQpbICAgIDAuNTIzOTM3XSAgWzxmZmZmZmZmZjgxMDUyNmY5Pl0g
a3RocmVhZCsweDg1LzB4OGQKWyAgICAwLjUyMzkzN10gIFs8ZmZmZmZmZmY4MTNlNTAxND5d
IGtlcm5lbF90aHJlYWRfaGVscGVyKzB4NC8weDEwClsgICAgMC41MjM5MzddICBbPGZmZmZm
ZmZmODEwNTI2NzQ+XSA/IGt0aHJlYWRfZmx1c2hfd29ya19mbisweGYvMHhmClsgICAgMC41
MjM5MzddICBbPGZmZmZmZmZmODEzZTUwMTA+XSA/IGdzX2NoYW5nZSsweDEzLzB4MTMKWyAg
ICAwLjUyMzkzN10gQ29kZTogODkgZGYgZTggNmUgN2MgMDEgMDAgNGMgODkgZTAgNWIgNDEg
NWMgNWQgYzMgNTUgNDggODMgZmYgMTAgNDggODkgZTUgNTMgNDggODkgZmIgNTIgNzYgMTcg
ZTggOTIgNzMgMDEgMDAgNDggODkgZGYgNDggODkgYzEgMzEgYzAgPGYzPiBhYSA0OCA4OSBk
ZiBlOCA0MCA3YyAwMSAwMCA1OCA1YiA1ZCBjMyA1NSA0OCA4OSBlNSA0MSA1NSA0OSAKWyAg
ICAwLjUyMzkzN10gUklQICBbPGZmZmZmZmZmODEwYTE1ZGQ+XSBremZyZWUrMHgxYy8weDJh
ClsgICAgMC41MjM5MzddICBSU1AgPGZmZmY4ODAwMTI4MjdkODA+ClsgICAgMC41MjM5Mzdd
IENSMjogZmZmZjg4MDAxMjI5ZTAwMApbICAgIDAuNTIzOTM3XSAtLS1bIGVuZCB0cmFjZSA0
ZWFhMmE4NmE4ZTJkYTIyIF0tLS0KWyAgICAwLjUyMzkzN10gS2VybmVsIHBhbmljIC0gbm90
IHN5bmNpbmc6IEZhdGFsIGV4Y2VwdGlvbiBpbiBpbnRlcnJ1cHQKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1yMS0wNzI2MjExOS83MTUxODlkODM2YWIyNzZiM2QwZmMxMTQ2ODFmMTJi
NDIzNjg2ZmZhL2RtZXNnLXlvY3RvLWtidWlsZC0xNzoyMDE0MDcyNzAxNTA0NTp4ODZfNjQt
cmFuZGNvbmZpZy1yMS0wNzI2MjExOTozLjUuMC1yYzYtMDAyNzAtZzcxNTE4OWQ6Ngova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LzcxNTE4OWQ4MzZhYjI3NmIzZDBm
YzExNDY4MWYxMmI0MjM2ODZmZmEvZG1lc2cteW9jdG8ta2J1aWxkLTg6MjAxNDA3MjcwMTUw
NDc6eDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTk6My41LjAtcmM2LTAwMjcwLWc3MTUx
ODlkOjYKNjc6MjoyIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA3
LTI3IDAxOjUyOjQ3IFJFUEVBVCBDT1VOVDogMzAwICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4
L29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCkJpc2VjdGluZzogMTUgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDQgc3RlcHMpClswYmRhZWE5MDE3YjlkMmI5
OTk2ZTE1M2E3MWVlMDM1NTU5NjliODBlXSBWRlM6IFNwbGl0IGlub2RlX3Blcm1pc3Npb24o
KQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2MvYm9vdC1iaXNlY3QvbGludXgvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1
bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTkvbmV4dDptYXN0ZXI6
MGJkYWVhOTAxN2I5ZDJiOTk5NmUxNTNhNzFlZTAzNTU1OTY5YjgwZTpiaXNlY3QtbGludXgK
CjIwMTQtMDctMjctMDE6NTI6NDcgMGJkYWVhOTAxN2I5ZDJiOTk5NmUxNTNhNzFlZTAzNTU1
OTY5YjgwZSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9i
dWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS0wYmRhZWE5MDE3Yjlk
MmI5OTk2ZTE1M2E3MWVlMDM1NTU5NjliODBlCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS8wYmRhZWE5MDE3YjlkMmI5OTk2ZTE1
M2E3MWVlMDM1NTU5NjliODBlCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS0wYmRhZWE5
MDE3YjlkMmI5OTk2ZTE1M2E3MWVlMDM1NTU5NjliODBlCndhaXRpbmcgZm9yIGNvbXBsZXRp
b24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDEtY29uc3VtZXIveDg2
XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTktMGJkYWVhOTAxN2I5ZDJiOTk5NmUxNTNhNzFl
ZTAzNTU1OTY5YjgwZQprZXJuZWw6IC9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjEtMDcy
NjIxMTkvMGJkYWVhOTAxN2I5ZDJiOTk5NmUxNTNhNzFlZTAzNTU1OTY5YjgwZS92bWxpbnV6
LTMuNS4wLXJjNi0wMDI3Ni1nMGJkYWVhOQoKMjAxNC0wNy0yNy0wMTo1ODo0NyBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAuLi4JMTIJMTYJMTcuCTM1CTM2CTgwLgkxMDAJMTI0CTEzMAkxNDIJ
MTU2CTE3MgkxNzgJMTgwCTIwNwkyMjgJMjMyCTI1OAkyNzIJMjgyCTI5OAkzMDAgU1VDQ0VT
UwoKQmlzZWN0aW5nOiA3IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91
Z2hseSAzIHN0ZXBzKQpbNGE5ZDRiMDI0YTMxMDJmYzA4M2M5MjVjMjQyZDk4YWMyN2IxYzVm
Nl0gc3dpdGNoIGZwdXQgdG8gdGFza193b3JrX2FkZApydW5uaW5nIC9jL2tlcm5lbC10ZXN0
cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgvb2Jq
LWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRj
b25maWctcjEtMDcyNjIxMTkvbmV4dDptYXN0ZXI6NGE5ZDRiMDI0YTMxMDJmYzA4M2M5MjVj
MjQyZDk4YWMyN2IxYzVmNjpiaXNlY3QtbGludXgKCjIwMTQtMDctMjctMDI6MTI6NDkgNGE5
ZDRiMDI0YTMxMDJmYzA4M2M5MjVjMjQyZDk4YWMyN2IxYzVmNiBjb21waWxpbmcKUXVldWVk
IGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQtcmFuZGNv
bmZpZy1yMS0wNzI2MjExOS00YTlkNGIwMjRhMzEwMmZjMDgzYzkyNWMyNDJkOThhYzI3YjFj
NWY2CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0w
NzI2MjExOS80YTlkNGIwMjRhMzEwMmZjMDgzYzkyNWMyNDJkOThhYzI3YjFjNWY2CndhaXRp
bmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS94ODZfNjQt
cmFuZGNvbmZpZy1yMS0wNzI2MjExOS00YTlkNGIwMjRhMzEwMmZjMDgzYzkyNWMyNDJkOThh
YzI3YjFjNWY2CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS9qYWtldG93bi1jb25zdW1lci94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjEx
OS00YTlkNGIwMjRhMzEwMmZjMDgzYzkyNWMyNDJkOThhYzI3YjFjNWY2Cmtlcm5lbDogL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS80YTlkNGIwMjRhMzEwMmZjMDgz
YzkyNWMyNDJkOThhYzI3YjFjNWY2L3ZtbGludXotMy41LjAtcmM2LTAwMjYyLWc0YTlkNGIw
CgoyMDE0LTA3LTI3LTAyOjE4OjQ5IGRldGVjdGluZyBib290IHN0YXRlIAk0Li4JNDMgVEVT
VCBGQUlMVVJFCi9iaW4vc2g6IC9wcm9jL3NlbGYvZmQvOTogTm8gc3VjaCBmaWxlIG9yIGRp
cmVjdG9yeQovYmluL3NoOiAvcHJvYy9zZWxmL2ZkLzk6IE5vIHN1Y2ggZmlsZSBvciBkaXJl
Y3RvcnkKCkJVRzoga2VybmVsIGJvb3QgaGFuZwpFbGFwc2VkIHRpbWU6IDM1CnFlbXUtc3lz
dGVtLXg4Nl82NCAtZW5hYmxlLWt2bSAtY3B1IEhhc3dlbGwsK3NtZXAsK3NtYXAgLWtlcm5l
bCAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LzRhOWQ0YjAyNGEzMTAy
ZmMwODNjOTI1YzI0MmQ5OGFjMjdiMWM1ZjYvdm1saW51ei0zLjUuMC1yYzYtMDAyNjItZzRh
OWQ0YjAgLWFwcGVuZCAnaHVuZ190YXNrX3BhbmljPTEgZWFybHlwcmludGs9dHR5UzAsMTE1
MjAwIGRlYnVnIGFwaWM9ZGVidWcgc3lzcnFfYWx3YXlzX2VuYWJsZWQgcmN1cGRhdGUucmN1
X2NwdV9zdGFsbF90aW1lb3V0PTEwMCBwYW5pYz0xMCBzb2Z0bG9ja3VwX3BhbmljPTEgbm1p
X3dhdGNoZG9nPXBhbmljICBwcm9tcHRfcmFtZGlzaz0wIGNvbnNvbGU9dHR5UzAsMTE1MjAw
IGNvbnNvbGU9dHR5MCB2Z2E9bm9ybWFsICByb290PS9kZXYvcmFtMCBydyBsaW5rPS9rYnVp
bGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS9u
ZXh0Om1hc3Rlcjo0YTlkNGIwMjRhMzEwMmZjMDgzYzkyNWMyNDJkOThhYzI3YjFjNWY2OmJp
c2VjdC1saW51eC8udm1saW51ei00YTlkNGIwMjRhMzEwMmZjMDgzYzkyNWMyNDJkOThhYzI3
YjFjNWY2LTIwMTQwNzI3MDIxODA0LTEzNy1rYnVpbGQgYnJhbmNoPW5leHQvbWFzdGVyIEJP
T1RfSU1BR0U9L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS80YTlkNGIw
MjRhMzEwMmZjMDgzYzkyNWMyNDJkOThhYzI3YjFjNWY2L3ZtbGludXotMy41LjAtcmM2LTAw
MjYyLWc0YTlkNGIwIGRyYmQubWlub3JfY291bnQ9OCcgIC1pbml0cmQgL2tlcm5lbC10ZXN0
cy9pbml0cmQvcXVhbnRhbC1jb3JlLXg4Nl82NC5jZ3ogLW0gMzIwIC1zbXAgMiAtbmV0IG5p
Yyx2bGFuPTEsbW9kZWw9ZTEwMDAgLW5ldCB1c2VyLHZsYW49MSAtYm9vdCBvcmRlcj1uYyAt
bm8tcmVib290IC13YXRjaGRvZyBpNjMwMGVzYiAtcnRjIGJhc2U9bG9jYWx0aW1lIC1waWRm
aWxlIC9kZXYvc2htL2tib290L3BpZC1xdWFudGFsLWtidWlsZC0xMSAtc2VyaWFsIGZpbGU6
L2Rldi9zaG0va2Jvb3Qvc2VyaWFsLXF1YW50YWwta2J1aWxkLTExIC1kYWVtb25pemUgLWRp
c3BsYXkgbm9uZSAtbW9uaXRvciBudWxsIAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIx
LTA3MjYyMTE5LzRhOWQ0YjAyNGEzMTAyZmMwODNjOTI1YzI0MmQ5OGFjMjdiMWM1ZjYvZG1l
c2cteW9jdG8ta2J1aWxkLTI1OjIwMTQwNzI3MDIxNzI2Ong4Nl82NC1yYW5kY29uZmlnLXIx
LTA3MjYyMTE5OjMuNS4wLXJjNi0wMDI2Mi1nNGE5ZDRiMDo3Ci9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctcjEtMDcyNjIxMTkvNGE5ZDRiMDI0YTMxMDJmYzA4M2M5MjVjMjQyZDk4YWMy
N2IxYzVmNi9kbWVzZy15b2N0by1rYnVpbGQtMjU6MjAxNDA3MjcwMjE4MDk6eDg2XzY0LXJh
bmRjb25maWctcjEtMDcyNjIxMTk6My41LjAtcmM2LTAwMjYyLWc0YTlkNGIwOjcKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS80YTlkNGIwMjRhMzEwMmZjMDgzYzky
NWMyNDJkOThhYzI3YjFjNWY2L2RtZXNnLXlvY3RvLWtidWlsZC05OjIwMTQwNzI3MDIxODI2
Ong4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5OjMuNS4wLXJjNi0wMDI2Mi1nNGE5ZDRi
MDo3CjExOjM6MzUgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2VjdGluZzogMyBy
ZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMiBzdGVwcykKWzE1
OGUxNjQ1ZTA3ZjNlOWY3ZTQ5NjJkN2EwOTk3ZjVjM2I5ODMxMWJdIHRyaW0gdGFza193b3Jr
OiBnZXQgcmlkIG9mIGhsaXN0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC9vYmotYmlzZWN0CmxzIC1h
IC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2
MjExOS9uZXh0Om1hc3RlcjoxNThlMTY0NWUwN2YzZTlmN2U0OTYyZDdhMDk5N2Y1YzNiOTgz
MTFiOmJpc2VjdC1saW51eAoKMjAxNC0wNy0yNy0wMjoyMDo1MCAxNThlMTY0NWUwN2YzZTlm
N2U0OTYyZDdhMDk5N2Y1YzNiOTgzMTFiIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0
byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYy
MTE5LTE1OGUxNjQ1ZTA3ZjNlOWY3ZTQ5NjJkN2EwOTk3ZjVjM2I5ODMxMWIKQ2hlY2sgZm9y
IGtlcm5lbCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LzE1OGUx
NjQ1ZTA3ZjNlOWY3ZTQ5NjJkN2EwOTk3ZjVjM2I5ODMxMWIKd2FpdGluZyBmb3IgY29tcGxl
dGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIx
LTA3MjYyMTE5LTE1OGUxNjQ1ZTA3ZjNlOWY3ZTQ5NjJkN2EwOTk3ZjVjM2I5ODMxMWIKd2Fp
dGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2pha2V0
b3duLWNvbnN1bWVyL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LTE1OGUxNjQ1ZTA3
ZjNlOWY3ZTQ5NjJkN2EwOTk3ZjVjM2I5ODMxMWIKa2VybmVsOiAva2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXIxLTA3MjYyMTE5LzE1OGUxNjQ1ZTA3ZjNlOWY3ZTQ5NjJkN2EwOTk3ZjVj
M2I5ODMxMWIvdm1saW51ei0zLjUuMC1yYzYtMDAyNTgtZzE1OGUxNjQKCjIwMTQtMDctMjct
MDI6MjY6MDIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTE2CTIyCTMxCTM4CTU3CTY5CTk5CTEw
NgkxMDkJMTE1CTEzNAkxNDcJMTU4CTIxNwkyMzYJMjUxCTI3MQkzMDAgU1VDQ0VTUwoKQmlz
ZWN0aW5nOiAxIHJldmlzaW9uIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEg
c3RlcCkKW2VkM2U2OTRkNzhjYzc1ZmE3OWJmMjk2OTg2MzFiMTQ2ZmQyN2FhMzVdIG1vdmUg
ZXhpdF90YXNrX3dvcmsoKSBwYXN0IGV4aXRfZmlsZXMoKSBldC5hbC4KcnVubmluZyAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0
L2xpbnV4L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5L25leHQ6bWFzdGVyOmVkM2U2OTRkNzhjYzc1
ZmE3OWJmMjk2OTg2MzFiMTQ2ZmQyN2FhMzU6YmlzZWN0LWxpbnV4CgoyMDE0LTA3LTI3LTAy
OjM1OjI2IGVkM2U2OTRkNzhjYzc1ZmE3OWJmMjk2OTg2MzFiMTQ2ZmQyN2FhMzUgY29tcGls
aW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUveDg2
XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTktZWQzZTY5NGQ3OGNjNzVmYTc5YmYyOTY5ODYz
MWIxNDZmZDI3YWEzNQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwveDg2XzY0LXJhbmRj
b25maWctcjEtMDcyNjIxMTkvZWQzZTY5NGQ3OGNjNzVmYTc5YmYyOTY5ODYzMWIxNDZmZDI3
YWEzNQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVl
dWUveDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTktZWQzZTY5NGQ3OGNjNzVmYTc5YmYy
OTY5ODYzMWIxNDZmZDI3YWEzNQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUvbGtwLWhzeDAxLWNvbnN1bWVyL3g4Nl82NC1yYW5kY29uZmln
LXIxLTA3MjYyMTE5LWVkM2U2OTRkNzhjYzc1ZmE3OWJmMjk2OTg2MzFiMTQ2ZmQyN2FhMzUK
a2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5L2VkM2U2OTRk
NzhjYzc1ZmE3OWJmMjk2OTg2MzFiMTQ2ZmQyN2FhMzUvdm1saW51ei0zLjUuMC1yYzYtMDAy
ODItZ2VkM2U2OTQKCjIwMTQtMDctMjctMDI6Mzg6MjYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
Li4JMjYJMzgJNDEJODYJOTIJMTA1CTEyNgkxMjgJMTQ4CTE1MwkxOTEJMjA2CTIyNAkyNzcJ
Mjg5CTMwMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDAgc3RlcHMpClthMmQ0YzcxZDE1NTk0MjYxNTVlNWRhOGRi
MzI2NWJmYTBkOGQzOThkXSBkZWFsIHdpdGggdGFza193b3JrIGNhbGxiYWNrcyBhZGRpbmcg
bW9yZSB3b3JrCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQt
dGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS9uZXh0
Om1hc3RlcjphMmQ0YzcxZDE1NTk0MjYxNTVlNWRhOGRiMzI2NWJmYTBkOGQzOThkOmJpc2Vj
dC1saW51eAoKMjAxNC0wNy0yNy0wMjo0NzozNCBhMmQ0YzcxZDE1NTk0MjYxNTVlNWRhOGRi
MzI2NWJmYTBkOGQzOThkIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LWEyZDRj
NzFkMTU1OTQyNjE1NWU1ZGE4ZGIzMjY1YmZhMGQ4ZDM5OGQKQ2hlY2sgZm9yIGtlcm5lbCBp
biAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5L2EyZDRjNzFkMTU1OTQy
NjE1NWU1ZGE4ZGIzMjY1YmZhMGQ4ZDM5OGQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5
LWEyZDRjNzFkMTU1OTQyNjE1NWU1ZGE4ZGIzMjY1YmZhMGQ4ZDM5OGQKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2pha2V0b3duLWNvbnN1
bWVyL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LWEyZDRjNzFkMTU1OTQyNjE1NWU1
ZGE4ZGIzMjY1YmZhMGQ4ZDM5OGQKa2VybmVsOiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LXIxLTA3MjYyMTE5L2EyZDRjNzFkMTU1OTQyNjE1NWU1ZGE4ZGIzMjY1YmZhMGQ4ZDM5OGQv
dm1saW51ei0zLjUuMC1yYzYtMDAyNjEtZ2EyZDRjNzEKCjIwMTQtMDctMjctMDI6NTM6MzQg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JNzAJMTIyCTE3NAkyMzMJMjk4CTMwMCBTVUNDRVNT
Cgo0YTlkNGIwMjRhMzEwMmZjMDgzYzkyNWMyNDJkOThhYzI3YjFjNWY2IGlzIHRoZSBmaXJz
dCBiYWQgY29tbWl0CmNvbW1pdCA0YTlkNGIwMjRhMzEwMmZjMDgzYzkyNWMyNDJkOThhYzI3
YjFjNWY2CkF1dGhvcjogQWwgVmlybyA8dmlyb0B6ZW5pdi5saW51eC5vcmcudWs+CkRhdGU6
ICAgU3VuIEp1biAyNCAwOTo1Njo0NSAyMDEyICswNDAwCgogICAgc3dpdGNoIGZwdXQgdG8g
dGFza193b3JrX2FkZAogICAgCiAgICAuLi4gYW5kIHNjaGVkdWxlX3dvcmsoKSBmb3IgaW50
ZXJydXB0L2tlcm5lbF90aHJlYWQgY2FsbGVycwogICAgKGFuZCB5ZXMsIG5vdyBpdCAqaXMq
IE9LIHRvIGNhbGwgZnJvbSBpbnRlcnJ1cHQpLgogICAgCiAgICBXZSBhcmUgZ3VhcmFudGVl
ZCB0aGF0IF9fZnB1dCgpIHdpbGwgYmUgZG9uZSBiZWZvcmUgd2UgcmV0dXJuCiAgICB0byB1
c2VybGFuZCAob3IgZXhpdCkuICBOb3RlIHRoYXQgZm9yIGZwdXQoKSBmcm9tIGEga2VybmVs
CiAgICB0aHJlYWQgd2UgZ2V0IGFuIGFzeW5jIGJlaGF2aW91cjsgaXQncyBhbG1vc3QgYWx3
YXlzIE9LLCBidXQKICAgIHNvbWV0aW1lcyB5b3UgbWlnaHQgbmVlZCB0byBoYXZlIF9fZnB1
dCgpIGNvbXBsZXRlZCBiZWZvcmUKICAgIHlvdSBkbyBhbnl0aGluZyBlbHNlLiAgVGhlcmUg
YXJlIHR3byBtZWNoYW5pc21zIGZvciB0aGF0IC0KICAgIGEgZ2VuZXJhbCBiYXJyaWVyIChm
bHVzaF9kZWxheWVkX2ZwdXQoKSkgYW5kIGV4cGxpY2l0CiAgICBfX2ZwdXRfc3luYygpLiAg
Qm90aCBzaG91bGQgYmUgdXNlZCB3aXRoIGNhcmUgKGFzIHdhcyB0aGUKICAgIGNhc2UgZm9y
IGZwdXQoKSBmcm9tIGtlcm5lbCB0aHJlYWRzIGFsbCBhbG9uZykuICBTZWUgY29tbWVudHMK
ICAgIGluIGZzL2ZpbGVfdGFibGUuYyBmb3IgZGV0YWlscy4KICAgIAogICAgU2lnbmVkLW9m
Zi1ieTogQWwgVmlybyA8dmlyb0B6ZW5pdi5saW51eC5vcmcudWs+Cgo6MDQwMDAwIDA0MDAw
MCAwYzE3YTdjMzYzMDI4YzI5MTUwOTk4MzI1YzMwMDM1N2QwOWI4MmFjIDJiMTEwYzFmY2Zk
MGMxZTVlMTY4OTkzZDU4MmVmZTNmYWQxM2YxMmMgTQlmcwo6MDQwMDAwIDA0MDAwMCA4ZWM4
MDU2NmMzNTU0NWM5NGM2NzczMGE1YzU5MmUxNjljNjIwNzczIGZlZjE2MzIzYzY2ZjRjOGI5
ZmQzNDhhZjBkMGJmZjk0ZDE5YjU0ODcgTQlpbmNsdWRlCjowNDAwMDAgMDQwMDAwIDdmNjEy
NTI2NDBjMTkyYTNkYmJiNzk1ZThkMzljNGRhNDU2Nzg1YzEgOTQxMDUxY2Q1MTE0ODNlOTYy
YzVjZTI4NTFmNTgxOThiMWUxMTA4MyBNCWluaXQKYmlzZWN0IHJ1biBzdWNjZXNzCkhFQUQg
aXMgbm93IGF0IGEyZDRjNzEuLi4gZGVhbCB3aXRoIHRhc2tfd29yayBjYWxsYmFja3MgYWRk
aW5nIG1vcmUgd29yawpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LXJhbmRjb25maWctcjEtMDcyNjIxMTkvbmV4dDptYXN0ZXI6YTJkNGM3MWQxNTU5NDI2MTU1
ZTVkYThkYjMyNjViZmEwZDhkMzk4ZDpiaXNlY3QtbGludXgKCjIwMTQtMDctMjctMDI6NTc6
MzQgYTJkNGM3MWQxNTU5NDI2MTU1ZTVkYThkYjMyNjViZmEwZDhkMzk4ZCByZXVzZSAva2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5L2EyZDRjNzFkMTU1OTQyNjE1NWU1
ZGE4ZGIzMjY1YmZhMGQ4ZDM5OGQvdm1saW51ei0zLjUuMC1yYzYtMDAyNjEtZ2EyZDRjNzEK
CjIwMTQtMDctMjctMDI6NTc6MzUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMzIyCTQ5MAk0
OTQJNDk4CTU5Mgk2NTAJNjY2CTc4MS4JNzk2CTg0OQk5MDAgU1VDQ0VTUwoKUHJldmlvdXMg
SEVBRCBwb3NpdGlvbiB3YXMgYTJkNGM3MS4uLiBkZWFsIHdpdGggdGFza193b3JrIGNhbGxi
YWNrcyBhZGRpbmcgbW9yZSB3b3JrCkhFQUQgaXMgbm93IGF0IDVhNzQzOWUuLi4gQWRkIGxp
bnV4LW5leHQgc3BlY2lmaWMgZmlsZXMgZm9yIDIwMTQwNzI1CmxzIC1hIC9rYnVpbGQtdGVz
dHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS9uZXh0Om1h
c3Rlcjo1YTc0MzllZmQxYzVjNDE2Zjc2OGZjNTUwMDQ4Y2ExMzBjZjRiZjk5OmJpc2VjdC1s
aW51eAogVEVTVCBGQUlMVVJFClsgICAgMC40MTY3NTJdIEFWWCB2ZXJzaW9uIG9mIGdjbV9l
bmMvZGVjIGVuZ2FnZWQuClsgICAgMC40MTcxOTZdIEFFUyBDVFIgbW9kZSBieTggb3B0aW1p
emF0aW9uIGVuYWJsZWQKWyAgICAwLjQxODM4NF0gYWxnOiBObyB0ZXN0IGZvciBfX2djbS1h
ZXMtYWVzbmkgKF9fZHJpdmVyLWdjbS1hZXMtYWVzbmkpClsgICAgMC40MTk0MzVdIEJVRzog
dW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFnaW5nIHJlcXVlc3QgYXQgZmZmZjg4MDAxMjU1
MTAwMApbICAgIDAuNDIwMDA2XSBJUDogWzxmZmZmZmZmZjgxMGZmMjM5Pl0ga3pmcmVlKzB4
MWIvMHgyOApbICAgIDAuNDIwMDA2XSBQR0QgMTlhZTA2NyBQVUQgMTlhZjA2NyBQTUQgMTNi
ZWYwNjcgUFRFIDgwMDAwMDAwMTI1NTEwNjAKWyAgICAwLjQyMDAwNl0gVGhyZWFkIG92ZXJy
YW4gc3RhY2ssIG9yIHN0YWNrIGNvcnJ1cHRlZApbICAgIDAuNDIwMDA2XSBPb3BzOiAwMDAy
IFsjMV0gREVCVUdfUEFHRUFMTE9DClsgICAgMC40MjAwMDZdIE1vZHVsZXMgbGlua2VkIGlu
OgpbICAgIDAuNDIwMDA2XSBDUFU6IDAgUElEOiA1NCBDb21tOiBjcnlwdG9tZ3JfdGVzdCBO
b3QgdGFpbnRlZCAzLjE2LjAtcmM2LW5leHQtMjAxNDA3MjUgIzIwOQpbICAgIDAuNDIwMDA2
XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsg
ICAgMC40MjAwMDZdIHRhc2s6IGZmZmY4ODAwMTI1MjM4MTAgdGk6IGZmZmY4ODAwMTI1NGMw
MDAgdGFzay50aTogZmZmZjg4MDAxMjU0YzAwMApbICAgIDAuNDIwMDA2XSBSSVA6IDAwMTA6
WzxmZmZmZmZmZjgxMGZmMjM5Pl0gIFs8ZmZmZmZmZmY4MTBmZjIzOT5dIGt6ZnJlZSsweDFi
LzB4MjgKWyAgICAwLjQyMDAwNl0gUlNQOiAwMDAwOmZmZmY4ODAwMTI1NGZkNjAgIEVGTEFH
UzogMDAwMTAyNDYKWyAgICAwLjQyMDAwNl0gUkFYOiAwMDAwMDAwMDAwMDAwMDAwIFJCWDog
ZmZmZjg4MDAxMjU0YjVjMCBSQ1g6IDAwMDAwMDAwMTI1NDViODAKWyAgICAwLjQyMDAwNl0g
UkRYOiAwMDAwNDgwMDAwMDAwODgwIFJTSTogMDAwMDAwMDAwMDAwMDI4NiBSREk6IGZmZmY4
ODAwMTI1NTEwMDAKWyAgICAwLjQyMDAwNl0gUkJQOiBmZmZmODgwMDEyNTRmZDY4IFIwODog
MDAwMDAwMDAwMDAwMDAwMCBSMDk6IGZmZmZmZmZmODE3YTZmYTAKWyAgICAwLjQyMDAwNl0g
UjEwOiAwMDAwMDAwMDAwMDAwMDA3IFIxMTogMDAwMDAwMDAwMDAwMDQxOCBSMTI6IGZmZmY4
ODAwMTI1NGI1YzAKWyAgICAwLjQyMDAwNl0gUjEzOiBmZmZmODgwMDExNzE0ZDA4IFIxNDog
MDAwMDAwMDAwMDAwMDQwMCBSMTU6IDAwMDAwMDAwMDAwMDAwN2YKWyAgICAwLjQyMDAwNl0g
RlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmZmZmZmODE3ODUwMDAoMDAwMCkg
a25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICAgIDAuNDIwMDA2XSBDUzogIDAwMTAgRFM6IDAw
MDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzClsgICAgMC40MjAwMDZdIENSMjog
ZmZmZjg4MDAxMjU1MTAwMCBDUjM6IDAwMDAwMDAwMDE3NzUwMDAgQ1I0OiAwMDAwMDAwMDAw
MDQwNmYwClsgICAgMC40MjAwMDZdIFN0YWNrOgpbICAgIDAuNDIwMDA2XSAgMDAwMDAwMDAw
MDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAw
MDAwMApbICAgIDAuNDIwMDA2XSAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAw
IDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMApbICAgIDAuNDIwMDA2XSAgMDAw
MDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAw
MDAwMDAwMDAwMApbICAgIDAuNDIwMDA2XSBDYWxsIFRyYWNlOgpbICAgIDAuNDIwMDA2XSBD
b2RlOiAwMSAwMCA1YiA0YyA4OSBlMCA0MSA1YyA0MSA1ZCA0MSA1ZSA0MSA1ZiA1ZCBjMyA1
NSA0OCA4MyBmZiAxMCA0OCA4OSBlNSA1MyA0OCA4OSBmYiA3NiAxNyBlOCAwNiA4YiAwMSAw
MCA0OCA4OSBkZiA0OCA4OSBjMSAzMSBjMCA8ZjM+IGFhIDQ4IDg5IGRmIGU4IDVmIDkzIDAx
IDAwIDViIDVkIGMzIDU1IGY3IGM3IDAwIDIwIDAwIDAwIDQ4IApbICAgIDAuNDIwMDA2XSBS
SVAgIFs8ZmZmZmZmZmY4MTBmZjIzOT5dIGt6ZnJlZSsweDFiLzB4MjgKWyAgICAwLjQyMDAw
Nl0gIFJTUCA8ZmZmZjg4MDAxMjU0ZmQ2MD4KWyAgICAwLjQyMDAwNl0gQ1IyOiBmZmZmODgw
MDEyNTUxMDAwClsgICAgMC40MjAwMDZdIC0tLVsgZW5kIHRyYWNlIDc5MzgzNDM5ZWJiNmFj
MDEgXS0tLQpbICAgIDAuNDIwMDA2XSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogRmF0
YWwgZXhjZXB0aW9uCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTkvNWE3
NDM5ZWZkMWM1YzQxNmY3NjhmYzU1MDA0OGNhMTMwY2Y0YmY5OS9kbWVzZy15b2N0by1rYnVp
bGQtMTU6MjAxNDA3MjYyMjAwNTA6eDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTk6My4x
Ni4wLXJjNi1uZXh0LTIwMTQwNzI1OjIwOQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIx
LTA3MjYyMTE5LzVhNzQzOWVmZDFjNWM0MTZmNzY4ZmM1NTAwNDhjYTEzMGNmNGJmOTkvZG1l
c2cteW9jdG8ta2J1aWxkLTM6MjAxNDA3MjYyMjAxMDI6eDg2XzY0LXJhbmRjb25maWctcjEt
MDcyNjIxMTk6My4xNi4wLXJjNi1uZXh0LTIwMTQwNzI1OjIwOQova2VybmVsL3g4Nl82NC1y
YW5kY29uZmlnLXIxLTA3MjYyMTE5LzVhNzQzOWVmZDFjNWM0MTZmNzY4ZmM1NTAwNDhjYTEz
MGNmNGJmOTkvZG1lc2cteW9jdG8ta2J1aWxkLTI4OjIwMTQwNzI2MjIwMTAxOng4Nl82NC1y
YW5kY29uZmlnLXIxLTA3MjYyMTE5OjMuMTYuMC1yYzYtbmV4dC0yMDE0MDcyNToyMDkKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS81YTc0MzllZmQxYzVjNDE2Zjc2
OGZjNTUwMDQ4Y2ExMzBjZjRiZjk5L2RtZXNnLXlvY3RvLWtidWlsZC0yMToyMDE0MDcyNjIx
MjgwNTp4ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOTozLjE2LjAtcmM2LW5leHQtMjAx
NDA3MjU6MjA5Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTkvNWE3NDM5
ZWZkMWM1YzQxNmY3NjhmYzU1MDA0OGNhMTMwY2Y0YmY5OS9kbWVzZy15b2N0by1rYnVpbGQt
MTA6MjAxNDA3MjYyMjAxMDE6eDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTk6My4xNi4w
LXJjNi1uZXh0LTIwMTQwNzI1OjIwOQova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3
MjYyMTE5LzVhNzQzOWVmZDFjNWM0MTZmNzY4ZmM1NTAwNDhjYTEzMGNmNGJmOTkvZG1lc2ct
eW9jdG8ta2J1aWxkLTI5OjIwMTQwNzI2MjIwMTAxOng4Nl82NC1yYW5kY29uZmlnLXIxLTA3
MjYyMTE5OjMuMTYuMC1yYzYtbmV4dC0yMDE0MDcyNToyMDkKMTQ6Njo3IGFsbF9nb29kOmJh
ZDphbGxfYmFkIGJvb3RzCgpIRUFEIGlzIG5vdyBhdCA1YTc0MzllIEFkZCBsaW51eC1uZXh0
IHNwZWNpZmljIGZpbGVzIGZvciAyMDE0MDcyNQoKPT09PT09PT09IGxpbnVzL21hc3RlciA9
PT09PT09PT0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgNWE3NDM5ZS4uLiBBZGQgbGlu
dXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAxNDA3MjUKSEVBRCBpcyBub3cgYXQgOWM1
NTAyMS4uLiBNZXJnZSB0YWcgJ3NvdW5kLTMuMTYtcmM3JyBvZiBnaXQ6Ly9naXQua2VybmVs
Lm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGl3YWkvc291bmQKbHMgLWEgL2tidWls
ZC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5L2xp
bnVzOm1hc3Rlcjo5YzU1MDIxODlmYTAwYWQ2MjNhZWQ3ZmYwMDZkNWMyYTE2YjEyMWMwOmJp
c2VjdC1saW51eAoKMjAxNC0wNy0yNy0wMzowNDo0NiA5YzU1MDIxODlmYTAwYWQ2MjNhZWQ3
ZmYwMDZkNWMyYTE2YjEyMWMwIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LTlj
NTUwMjE4OWZhMDBhZDYyM2FlZDdmZjAwNmQ1YzJhMTZiMTIxYzAKQ2hlY2sgZm9yIGtlcm5l
bCBpbiAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LzljNTUwMjE4OWZh
MDBhZDYyM2FlZDdmZjAwNmQ1YzJhMTZiMTIxYzAKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYy
MTE5LTljNTUwMjE4OWZhMDBhZDYyM2FlZDdmZjAwNmQ1YzJhMTZiMTIxYzAKd2FpdGluZyBm
b3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2xrcC1oc3gwMS1j
b25zdW1lci94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS05YzU1MDIxODlmYTAwYWQ2
MjNhZWQ3ZmYwMDZkNWMyYTE2YjEyMWMwCmtlcm5lbDogL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1yMS0wNzI2MjExOS85YzU1MDIxODlmYTAwYWQ2MjNhZWQ3ZmYwMDZkNWMyYTE2YjEy
MWMwL3ZtbGludXotMy4xNi4wLXJjNi0wMDEzMy1nOWM1NTAyMQoKMjAxNC0wNy0yNy0wMzox
MDo0NiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTEyIFRFU1QgRkFJTFVSRQpbICAgIDAuNTA4
NDkwXSBtaWNyb2NvZGU6IE1pY3JvY29kZSBVcGRhdGUgRHJpdmVyOiB2Mi4wMCA8dGlncmFu
QGFpdmF6aWFuLmZzbmV0LmNvLnVrPiwgUGV0ZXIgT3J1YmEKWyAgICAwLjUxMjAzNF0gQVZY
IHZlcnNpb24gb2YgZ2NtX2VuYy9kZWMgZW5nYWdlZC4KWyAgICAwLjUxMzk4Nl0gYWxnOiBO
byB0ZXN0IGZvciBfX2djbS1hZXMtYWVzbmkgKF9fZHJpdmVyLWdjbS1hZXMtYWVzbmkpClsg
ICAgMC41MTU1NjhdIGdlbmVyYWwgcHJvdGVjdGlvbiBmYXVsdDogMDAwMCBbIzFdIERFQlVH
X1BBR0VBTExPQwpbICAgIDAuNTE2NDAzXSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAwLjUx
NjY4Ml0gQ1BVOiAwIFBJRDogNTAgQ29tbTogY3J5cHRvbWdyX3Rlc3QgTm90IHRhaW50ZWQg
My4xNi4wLXJjNi0wMDEzMy1nOWM1NTAyMSAjMjAKWyAgICAwLjUxNjY4Ml0gSGFyZHdhcmUg
bmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDAuNTE2Njgy
XSB0YXNrOiBmZmZmODgwMDEyNTAyOGUwIHRpOiBmZmZmODgwMDEyNTRjMDAwIHRhc2sudGk6
IGZmZmY4ODAwMTI1NGMwMDAKWyAgICAwLjUxNjY4Ml0gUklQOiAwMDEwOls8ZmZmZmZmZmY4
MTFhOTQxND5dICBbPGZmZmZmZmZmODExYTk0MTQ+XSBjcnlwdG9fYWhhc2hfc2V0a2V5KzB4
MWIvMHg4NgpbICAgIDAuNTE2NjgyXSBSU1A6IDAwMDA6ZmZmZjg4MDAxMjU0ZmFmOCAgRUZM
QUdTOiAwMDAxMDI4NgpbICAgIDAuNTE2NjgyXSBSQVg6IGYwMDBmZjUzZjAwMGZmNTMgUkJY
OiBmZmZmODgwMDAwMDAwMGNjIFJDWDogMDAwMDAwMDBmMDAwMDA1MwpbICAgIDAuNTE2Njgy
XSBSRFg6IDAwMDAwMDAwMDAwMDAwMTAgUlNJOiBmZmZmZmZmZjgxNjkzYTEwIFJESTogZmZm
Zjg4MDAwMDAwMDBjYwpbICAgIDAuNTE2NjgyXSBSQlA6IGZmZmY4ODAwMTI1NGZiMjggUjA4
OiBmZmZmODgwMDEyNTRmOTEwIFIwOTogZmZmZmZmZmY4MTc3OWYwMApbICAgIDAuNTE2Njgy
XSBSMTA6IDAwMDAwMDAwMDAwMDAwMDcgUjExOiAwMDAwMDAwMDAwMDAzZTU4IFIxMjogZmZm
ZmZmZmY4MTY5M2ExMApbICAgIDAuNTE2NjgyXSBSMTM6IGZmZmZmZmZmODE3OGMwZDAgUjE0
OiAwMDAwMDAwMDAwMDAwMDAwIFIxNTogZmZmZmZmZmY4MTc4YzBkMApbICAgIDAuNTE2Njgy
XSBGUzogIDAwMDAwMDAwMDAwMDAwMDAoMDAwMCkgR1M6ZmZmZmZmZmY4MTc1OTAwMCgwMDAw
KSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwClsgICAgMC41MTY2ODJdIENTOiAgMDAxMCBEUzog
MDAwMCBFUzogMDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwMzMKWyAgICAwLjUxNjY4Ml0gQ1Iy
OiAwMDAwMDAwMGZmZmZmZmZmIENSMzogMDAwMDAwMDAwMTc0OTAwMCBDUjQ6IDAwMDAwMDAw
MDAwNDA2ZjAKWyAgICAwLjUxNjY4Ml0gU3RhY2s6ClsgICAgMC41MTY2ODJdICAwMDAwMDAw
MGYwMDAwMDUzIGZmZmY4ODAwMDAwMDAwY2MgZmZmZjg4MDAxMTcxM2E1OCBmZmZmZmZmZjgx
NzhjMGQwClsgICAgMC41MTY2ODJdICAwMDAwMDAwMDAwMDAwMDAwIGZmZmZmZmZmODE3OGMw
ZDAgZmZmZjg4MDAxMjU0ZmI0OCBmZmZmZmZmZjgxMDU5NGViClsgICAgMC41MTY2ODJdICBm
ZmZmODgwMDExNzEzYTU4IGZmZmZmZmZmODE2OTNhMTAgZmZmZjg4MDAxMjU0ZmI4OCBmZmZm
ZmZmZjgxMWE5NDczClsgICAgMC41MTY2ODJdIENhbGwgVHJhY2U6ClsgICAgMC41MTY2ODJd
ICBbPGZmZmZmZmZmODEwNTk0ZWI+XSBnaGFzaF9hc3luY19zZXRrZXkrMHgzMi8weDQ1Clsg
ICAgMC41MTY2ODJdICBbPGZmZmZmZmZmODExYTk0NzM+XSBjcnlwdG9fYWhhc2hfc2V0a2V5
KzB4N2EvMHg4NgpbICAgIDAuNTE2NjgyXSAgWzxmZmZmZmZmZjgxMWFkMGQ2Pl0gX190ZXN0
X2hhc2grMHgzZDMvMHg1ZDgKWyAgICAwLjUxNjY4Ml0gIFs8ZmZmZmZmZmY4MTFhOTJkNz5d
ID8gY3J5cHRvX2FsbG9jX2FoYXNoKzB4MTQvMHgxNgpbICAgIDAuNTE2NjgyXSAgWzxmZmZm
ZmZmZjgxMWI3MTBiPl0gPyBjcnlwdGRfYWxsb2NfYWhhc2grMHg0OC8weDgwClsgICAgMC41
MTY2ODJdICBbPGZmZmZmZmZmODEwNTk0OWY+XSA/IGdoYXNoX2FzeW5jX2luaXRfdGZtKzB4
MTgvMHgzMgpbICAgIDAuNTE2NjgyXSAgWzxmZmZmZmZmZjgxMWE0M2U3Pl0gPyBjcnlwdG9f
Y3JlYXRlX3RmbSsweDVhLzB4OTMKWyAgICAwLjUxNjY4Ml0gIFs8ZmZmZmZmZmY4MTFhZDJm
ZT5dIHRlc3RfaGFzaCsweDIzLzB4NmYKWyAgICAwLjUxNjY4Ml0gIFs8ZmZmZmZmZmY4MTFh
ZDNhMT5dIGFsZ190ZXN0X2hhc2grMHg1Ny8weDg5ClsgICAgMC41MTY2ODJdICBbPGZmZmZm
ZmZmODExYWNjNzM+XSBhbGdfdGVzdCsweDFlYy8weDI1MApbICAgIDAuNTE2NjgyXSAgWzxm
ZmZmZmZmZjgxMGExYjU0Pl0gPyBfX3dha2VfdXBfY29tbW9uKzB4NDYvMHg3MgpbICAgIDAu
NTE2NjgyXSAgWzxmZmZmZmZmZjgxMWFhNWYzPl0gPyBjcnlwdG9tZ3Jfbm90aWZ5KzB4MzY1
LzB4MzY1ClsgICAgMC41MTY2ODJdICBbPGZmZmZmZmZmODExYWE2MTY+XSBjcnlwdG9tZ3Jf
dGVzdCsweDIzLzB4M2UKWyAgICAwLjUxNjY4Ml0gIFs8ZmZmZmZmZmY4MTA5NTY1ZD5dIGt0
aHJlYWQrMHhlNi8weGVlClsgICAgMC41MTY2ODJdICBbPGZmZmZmZmZmODEwOTU1Nzc+XSA/
IGt0aHJlYWRfY3JlYXRlX29uX25vZGUrMHgxN2EvMHgxN2EKWyAgICAwLjUxNjY4Ml0gIFs8
ZmZmZmZmZmY4MTUwOWQ3YT5dIHJldF9mcm9tX2ZvcmsrMHg3YS8weGIwClsgICAgMC41MTY2
ODJdICBbPGZmZmZmZmZmODEwOTU1Nzc+XSA/IGt0aHJlYWRfY3JlYXRlX29uX25vZGUrMHgx
N2EvMHgxN2EKWyAgICAwLjUxNjY4Ml0gQ29kZTogMDAgZmYgMGYgMDAgMGMgODAgODkgNDYg
MjggZTggMmQgZmIgZmYgZmYgNWQgYzMgNTUgNDggODkgZTUgNDEgNTcgNDEgNTYgNDEgNTUg
NDEgNTQgNDkgODkgZjQgNTMgNDggODkgZmIgNTEgNDggOGIgODcgOTggMDAgMDAgMDAgPDQ0
PiA4YiA3MCAyYyA0YyA4NSBmNiA3NCA1MyA0MSA4OSBkNSBiZSBkMCAwMCAwMCAwMCA4OSA1
NSBkNCA0YiAKWyAgICAwLjUxNjY4Ml0gUklQICBbPGZmZmZmZmZmODExYTk0MTQ+XSBjcnlw
dG9fYWhhc2hfc2V0a2V5KzB4MWIvMHg4NgpbICAgIDAuNTE2NjgyXSAgUlNQIDxmZmZmODgw
MDEyNTRmYWY4PgpbICAgIDAuNTUxMzE0XSAtLS1bIGVuZCB0cmFjZSBmY2NhMDY1YjE1YWQ2
YWJiIF0tLS0KWyAgICAwLjU1MTkzOV0gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEZh
dGFsIGV4Y2VwdGlvbgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5Lzlj
NTUwMjE4OWZhMDBhZDYyM2FlZDdmZjAwNmQ1YzJhMTZiMTIxYzAvZG1lc2cteW9jdG8ta2J1
aWxkLTEzOjIwMTQwNzI3MDMwOTMwOng4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5OjMu
MTYuMC1yYzYtMDAxMzMtZzljNTUwMjE6MjAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1y
MS0wNzI2MjExOS85YzU1MDIxODlmYTAwYWQ2MjNhZWQ3ZmYwMDZkNWMyYTE2YjEyMWMwL2Rt
ZXNnLXlvY3RvLWtidWlsZC0yMzoyMDE0MDcyNzAzMDkzNTp4ODZfNjQtcmFuZGNvbmZpZy1y
MS0wNzI2MjExOTozLjE2LjAtcmM2LTAwMTMzLWc5YzU1MDIxOjIwCi9rZXJuZWwveDg2XzY0
LXJhbmRjb25maWctcjEtMDcyNjIxMTkvOWM1NTAyMTg5ZmEwMGFkNjIzYWVkN2ZmMDA2ZDVj
MmExNmIxMjFjMC9kbWVzZy15b2N0by1rYnVpbGQtMjQ6MjAxNDA3MjcwMzA5MzA6eDg2XzY0
LXJhbmRjb25maWctcjEtMDcyNjIxMTk6My4xNi4wLXJjNi0wMDEzMy1nOWM1NTAyMToyMAov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LzljNTUwMjE4OWZhMDBhZDYy
M2FlZDdmZjAwNmQ1YzJhMTZiMTIxYzAvZG1lc2cteW9jdG8ta2J1aWxkLTI2OjIwMTQwNzI3
MDMwOTMxOng4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5OjMuMTYuMC1yYzYtMDAxMzMt
ZzljNTUwMjE6MjAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS85YzU1
MDIxODlmYTAwYWQ2MjNhZWQ3ZmYwMDZkNWMyYTE2YjEyMWMwL2RtZXNnLXlvY3RvLWtidWls
ZC0yODoyMDE0MDcyNzAzMDkzMDp4ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOTozLjE2
LjAtcmM2LTAwMTMzLWc5YzU1MDIxOjIwCi9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjEt
MDcyNjIxMTkvOWM1NTAyMTg5ZmEwMGFkNjIzYWVkN2ZmMDA2ZDVjMmExNmIxMjFjMC9kbWVz
Zy15b2N0by1rYnVpbGQtODoyMDE0MDcyNzAzMDkzMDp4ODZfNjQtcmFuZGNvbmZpZy1yMS0w
NzI2MjExOTozLjE2LjAtcmM2LTAwMTMzLWc5YzU1MDIxOjIwCjA6NjoxOCBhbGxfZ29vZDpi
YWQ6YWxsX2JhZCBib290cwoKCj09PT09PT09PSBuZXh0L21hc3RlciA9PT09PT09PT0KUHJl
dmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgOWM1NTAyMS4uLiBNZXJnZSB0YWcgJ3NvdW5kLTMu
MTYtcmM3JyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9n
aXQvdGl3YWkvc291bmQKSEVBRCBpcyBub3cgYXQgNWE3NDM5ZS4uLiBBZGQgbGludXgtbmV4
dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAxNDA3MjUKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4t
cXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5L25leHQ6bWFzdGVyOjVh
NzQzOWVmZDFjNWM0MTZmNzY4ZmM1NTAwNDhjYTEzMGNmNGJmOTk6YmlzZWN0LWxpbnV4CiBU
RVNUIEZBSUxVUkUKWyAgICAwLjQxNjc1Ml0gQVZYIHZlcnNpb24gb2YgZ2NtX2VuYy9kZWMg
ZW5nYWdlZC4KWyAgICAwLjQxNzE5Nl0gQUVTIENUUiBtb2RlIGJ5OCBvcHRpbWl6YXRpb24g
ZW5hYmxlZApbICAgIDAuNDE4Mzg0XSBhbGc6IE5vIHRlc3QgZm9yIF9fZ2NtLWFlcy1hZXNu
aSAoX19kcml2ZXItZ2NtLWFlcy1hZXNuaSkKWyAgICAwLjQxOTQzNV0gQlVHOiB1bmFibGUg
dG8gaGFuZGxlIGtlcm5lbCBwYWdpbmcgcmVxdWVzdCBhdCBmZmZmODgwMDEyNTUxMDAwClsg
ICAgMC40MjAwMDZdIElQOiBbPGZmZmZmZmZmODEwZmYyMzk+XSBremZyZWUrMHgxYi8weDI4
ClsgICAgMC40MjAwMDZdIFBHRCAxOWFlMDY3IFBVRCAxOWFmMDY3IFBNRCAxM2JlZjA2NyBQ
VEUgODAwMDAwMDAxMjU1MTA2MApbICAgIDAuNDIwMDA2XSBUaHJlYWQgb3ZlcnJhbiBzdGFj
aywgb3Igc3RhY2sgY29ycnVwdGVkClsgICAgMC40MjAwMDZdIE9vcHM6IDAwMDIgWyMxXSBE
RUJVR19QQUdFQUxMT0MKWyAgICAwLjQyMDAwNl0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAg
MC40MjAwMDZdIENQVTogMCBQSUQ6IDU0IENvbW06IGNyeXB0b21ncl90ZXN0IE5vdCB0YWlu
dGVkIDMuMTYuMC1yYzYtbmV4dC0yMDE0MDcyNSAjMjA5ClsgICAgMC40MjAwMDZdIEhhcmR3
YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAwLjQy
MDAwNl0gdGFzazogZmZmZjg4MDAxMjUyMzgxMCB0aTogZmZmZjg4MDAxMjU0YzAwMCB0YXNr
LnRpOiBmZmZmODgwMDEyNTRjMDAwClsgICAgMC40MjAwMDZdIFJJUDogMDAxMDpbPGZmZmZm
ZmZmODEwZmYyMzk+XSAgWzxmZmZmZmZmZjgxMGZmMjM5Pl0ga3pmcmVlKzB4MWIvMHgyOApb
ICAgIDAuNDIwMDA2XSBSU1A6IDAwMDA6ZmZmZjg4MDAxMjU0ZmQ2MCAgRUZMQUdTOiAwMDAx
MDI0NgpbICAgIDAuNDIwMDA2XSBSQVg6IDAwMDAwMDAwMDAwMDAwMDAgUkJYOiBmZmZmODgw
MDEyNTRiNWMwIFJDWDogMDAwMDAwMDAxMjU0NWI4MApbICAgIDAuNDIwMDA2XSBSRFg6IDAw
MDA0ODAwMDAwMDA4ODAgUlNJOiAwMDAwMDAwMDAwMDAwMjg2IFJESTogZmZmZjg4MDAxMjU1
MTAwMApbICAgIDAuNDIwMDA2XSBSQlA6IGZmZmY4ODAwMTI1NGZkNjggUjA4OiAwMDAwMDAw
MDAwMDAwMDAwIFIwOTogZmZmZmZmZmY4MTdhNmZhMApbICAgIDAuNDIwMDA2XSBSMTA6IDAw
MDAwMDAwMDAwMDAwMDcgUjExOiAwMDAwMDAwMDAwMDAwNDE4IFIxMjogZmZmZjg4MDAxMjU0
YjVjMApbICAgIDAuNDIwMDA2XSBSMTM6IGZmZmY4ODAwMTE3MTRkMDggUjE0OiAwMDAwMDAw
MDAwMDAwNDAwIFIxNTogMDAwMDAwMDAwMDAwMDA3ZgpbICAgIDAuNDIwMDA2XSBGUzogIDAw
MDAwMDAwMDAwMDAwMDAoMDAwMCkgR1M6ZmZmZmZmZmY4MTc4NTAwMCgwMDAwKSBrbmxHUzow
MDAwMDAwMDAwMDAwMDAwClsgICAgMC40MjAwMDZdIENTOiAgMDAxMCBEUzogMDAwMCBFUzog
MDAwMCBDUjA6IDAwMDAwMDAwODAwNTAwMzMKWyAgICAwLjQyMDAwNl0gQ1IyOiBmZmZmODgw
MDEyNTUxMDAwIENSMzogMDAwMDAwMDAwMTc3NTAwMCBDUjQ6IDAwMDAwMDAwMDAwNDA2ZjAK
WyAgICAwLjQyMDAwNl0gU3RhY2s6ClsgICAgMC40MjAwMDZdICAwMDAwMDAwMDAwMDAwMDAw
IDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwClsg
ICAgMC40MjAwMDZdICAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAw
MDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwClsgICAgMC40MjAwMDZdICAwMDAwMDAwMDAw
MDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAw
MDAwClsgICAgMC40MjAwMDZdIENhbGwgVHJhY2U6ClsgICAgMC40MjAwMDZdIENvZGU6IDAx
IDAwIDViIDRjIDg5IGUwIDQxIDVjIDQxIDVkIDQxIDVlIDQxIDVmIDVkIGMzIDU1IDQ4IDgz
IGZmIDEwIDQ4IDg5IGU1IDUzIDQ4IDg5IGZiIDc2IDE3IGU4IDA2IDhiIDAxIDAwIDQ4IDg5
IGRmIDQ4IDg5IGMxIDMxIGMwIDxmMz4gYWEgNDggODkgZGYgZTggNWYgOTMgMDEgMDAgNWIg
NWQgYzMgNTUgZjcgYzcgMDAgMjAgMDAgMDAgNDggClsgICAgMC40MjAwMDZdIFJJUCAgWzxm
ZmZmZmZmZjgxMGZmMjM5Pl0ga3pmcmVlKzB4MWIvMHgyOApbICAgIDAuNDIwMDA2XSAgUlNQ
IDxmZmZmODgwMDEyNTRmZDYwPgpbICAgIDAuNDIwMDA2XSBDUjI6IGZmZmY4ODAwMTI1NTEw
MDAKWyAgICAwLjQyMDAwNl0gLS0tWyBlbmQgdHJhY2UgNzkzODM0MzllYmI2YWMwMSBdLS0t
ClsgICAgMC40MjAwMDZdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBGYXRhbCBleGNl
cHRpb24KL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS81YTc0MzllZmQx
YzVjNDE2Zjc2OGZjNTUwMDQ4Y2ExMzBjZjRiZjk5L2RtZXNnLXlvY3RvLWtidWlsZC0xNToy
MDE0MDcyNjIyMDA1MDp4ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOTozLjE2LjAtcmM2
LW5leHQtMjAxNDA3MjU6MjA5Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIx
MTkvNWE3NDM5ZWZkMWM1YzQxNmY3NjhmYzU1MDA0OGNhMTMwY2Y0YmY5OS9kbWVzZy15b2N0
by1rYnVpbGQtMzoyMDE0MDcyNjIyMDEwMjp4ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjEx
OTozLjE2LjAtcmM2LW5leHQtMjAxNDA3MjU6MjA5Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctcjEtMDcyNjIxMTkvNWE3NDM5ZWZkMWM1YzQxNmY3NjhmYzU1MDA0OGNhMTMwY2Y0YmY5
OS9kbWVzZy15b2N0by1rYnVpbGQtMjg6MjAxNDA3MjYyMjAxMDE6eDg2XzY0LXJhbmRjb25m
aWctcjEtMDcyNjIxMTk6My4xNi4wLXJjNi1uZXh0LTIwMTQwNzI1OjIwOQova2VybmVsL3g4
Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5LzVhNzQzOWVmZDFjNWM0MTZmNzY4ZmM1NTAw
NDhjYTEzMGNmNGJmOTkvZG1lc2cteW9jdG8ta2J1aWxkLTIxOjIwMTQwNzI2MjEyODA1Ong4
Nl82NC1yYW5kY29uZmlnLXIxLTA3MjYyMTE5OjMuMTYuMC1yYzYtbmV4dC0yMDE0MDcyNToy
MDkKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOS81YTc0MzllZmQxYzVj
NDE2Zjc2OGZjNTUwMDQ4Y2ExMzBjZjRiZjk5L2RtZXNnLXlvY3RvLWtidWlsZC0xMDoyMDE0
MDcyNjIyMDEwMTp4ODZfNjQtcmFuZGNvbmZpZy1yMS0wNzI2MjExOTozLjE2LjAtcmM2LW5l
eHQtMjAxNDA3MjU6MjA5Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTkv
NWE3NDM5ZWZkMWM1YzQxNmY3NjhmYzU1MDA0OGNhMTMwY2Y0YmY5OS9kbWVzZy15b2N0by1r
YnVpbGQtMjk6MjAxNDA3MjYyMjAxMDE6eDg2XzY0LXJhbmRjb25maWctcjEtMDcyNjIxMTk6
My4xNi4wLXJjNi1uZXh0LTIwMTQwNzI1OjIwOQoxNDo2OjcgYWxsX2dvb2Q6YmFkOmFsbF9i
YWQgYm9vdHMKCg==

--G6nVm6DDWH/FONJq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.5.0-rc6-00262-g4a9d4b0"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.5.0-rc6 Kernel Configuration
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
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
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
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
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
# CONFIG_EXPERIMENTAL is not set
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
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_FHANDLE is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
# CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
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
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_PCI_QUIRKS=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
# CONFIG_JUMP_LABEL is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
CONFIG_ATARI_PARTITION=y
# CONFIG_MAC_PARTITION is not set
# CONFIG_MSDOS_PARTITION is not set
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=y
# CONFIG_CFQ_GROUP_IOSCHED is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PREEMPT_NOTIFIERS=y
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PRIVILEGED_GUEST=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=500
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_AMD is not set
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_INJECT=m
CONFIG_I8K=m
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
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
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
# CONFIG_HIBERNATION is not set
CONFIG_PM_SLEEP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_CAN_PM_TRACE=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_INTEL_IDLE is not set

#
# Memory power savings
#

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
# CONFIG_PCI_STUB is not set
CONFIG_XEN_PCIDEV_FRONTEND=y
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
# CONFIG_YENTA_O2 is not set
# CONFIG_YENTA_RICOH is not set
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_NET_KEY=y
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
CONFIG_STP=m
CONFIG_BRIDGE=m
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_IPDDP=y
CONFIG_IPDDP_ENCAP=y
# CONFIG_IPDDP_DECAP is not set
CONFIG_PHONET=m
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set

#
# Network testing
#
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=m
# CONFIG_AX25_DAMA_SLAVE is not set
# CONFIG_NETROM is not set
CONFIG_ROSE=m

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
# CONFIG_6PACK is not set
CONFIG_BPQETHER=m
# CONFIG_BAYCOM_SER_FDX is not set
CONFIG_BAYCOM_SER_HDX=m
CONFIG_BAYCOM_PAR=m
CONFIG_YAM=m
CONFIG_CAN=y
CONFIG_CAN_RAW=m
# CONFIG_CAN_BCM is not set
# CONFIG_CAN_GW is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_SLCAN is not set
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
CONFIG_IRNET=m
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
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=y
# CONFIG_SMC_IRCC_FIR is not set
CONFIG_VIA_FIR=y
CONFIG_BT=m
CONFIG_BT_RFCOMM=m
# CONFIG_BT_RFCOMM_TTY is not set
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTSDIO=m
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIVHCI=m
# CONFIG_BT_MRVL is not set
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=m
# CONFIG_RFKILL_INPUT is not set
CONFIG_RFKILL_REGULATOR=m
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
CONFIG_SYS_HYPERVISOR=y
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=y
CONFIG_MTD_TESTS=m
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_CMDLINE_PARTS=y
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
# CONFIG_MTD_CHAR is not set
CONFIG_HAVE_MTD_OTP=y
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
CONFIG_RFD_FTL=y
CONFIG_SSFDC=m
CONFIG_MTD_OOPS=m
# CONFIG_MTD_SWAP is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
CONFIG_MTD_CFI_BE_BYTE_SWAP=y
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
CONFIG_MTD_CFI_GEOMETRY=y
# CONFIG_MTD_MAP_BANK_WIDTH_1 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_2 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_4 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
# CONFIG_MTD_CFI_I1 is not set
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_OTP=y
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=m
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
# CONFIG_MTD_SC520CDP is not set
# CONFIG_MTD_NETSC520 is not set
# CONFIG_MTD_TS5500 is not set
CONFIG_MTD_SBC_GXX=m
# CONFIG_MTD_AMD76XROM is not set
CONFIG_MTD_ICHXROM=m
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
CONFIG_MTD_SCB2_FLASH=m
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=m
CONFIG_MTD_PCI=m
CONFIG_MTD_INTEL_VR_NOR=m
CONFIG_MTD_PLATRAM=m
# CONFIG_MTD_LATCH_ADDR is not set

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
CONFIG_MTD_PMC551_BUGFIX=y
# CONFIG_MTD_PMC551_DEBUG is not set
CONFIG_MTD_SST25L=m
# CONFIG_MTD_SLRAM is not set
CONFIG_MTD_PHRAM=m
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOC2000 is not set
# CONFIG_MTD_DOC2001 is not set
# CONFIG_MTD_DOC2001PLUS is not set
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=m
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=m
# CONFIG_MTD_NAND_VERIFY_WRITE is not set
CONFIG_MTD_NAND_BCH=m
CONFIG_MTD_NAND_ECC_BCH=y
CONFIG_MTD_SM_COMMON=m
# CONFIG_MTD_NAND_MUSEUM_IDS is not set
CONFIG_MTD_NAND_DENALI=m
CONFIG_MTD_NAND_DENALI_SCRATCH_REG_ADDR=0xFF108018
CONFIG_MTD_NAND_IDS=m
CONFIG_MTD_NAND_RICOH=m
CONFIG_MTD_NAND_CAFE=m
CONFIG_MTD_NAND_NANDSIM=m
CONFIG_MTD_NAND_PLATFORM=m
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=m
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y
# CONFIG_MTD_ONENAND_SIM is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
# CONFIG_MTD_UBI is not set
CONFIG_PARPORT=m
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
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
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_XEN_BLKDEV_FRONTEND=y
# CONFIG_XEN_BLKDEV_BACKEND is not set
# CONFIG_BLK_DEV_HD is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=m
CONFIG_AD525X_DPOT_SPI=m
CONFIG_PHANTOM=m
# CONFIG_INTEL_MID_PTI is not set
CONFIG_SGI_IOC4=m
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=m
CONFIG_BMP085_SPI=m
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=m

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_AT25=m
CONFIG_EEPROM_LEGACY=m
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_EEPROM_93XX46 is not set
CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_BLK_DEV_IDE_SATA=y
# CONFIG_IDE_GD is not set
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=m
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
CONFIG_BLK_DEV_PLATFORM=m
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_BLK_DEV_OFFBOARD=y
CONFIG_BLK_DEV_GENERIC=m
CONFIG_BLK_DEV_RZ1000=m
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=m
CONFIG_BLK_DEV_ALI15X3=m
# CONFIG_BLK_DEV_AMD74XX is not set
CONFIG_BLK_DEV_ATIIXP=m
CONFIG_BLK_DEV_CMD64X=m
CONFIG_BLK_DEV_TRIFLEX=m
# CONFIG_BLK_DEV_CS5530 is not set
CONFIG_BLK_DEV_HPT366=m
CONFIG_BLK_DEV_JMICRON=m
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=m
CONFIG_BLK_DEV_IT8172=m
CONFIG_BLK_DEV_IT8213=m
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
CONFIG_BLK_DEV_PDC202XX_OLD=m
CONFIG_BLK_DEV_PDC202XX_NEW=m
CONFIG_BLK_DEV_SVWKS=m
CONFIG_BLK_DEV_SIIMAGE=m
CONFIG_BLK_DEV_SIS5513=m
CONFIG_BLK_DEV_SLC90E66=m
CONFIG_BLK_DEV_TRM290=m
CONFIG_BLK_DEV_VIA82CXXX=m
CONFIG_BLK_DEV_TC86C001=m
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=m
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
# CONFIG_SCSI_ENCLOSURE is not set
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
# CONFIG_SCSI_SAS_ATA is not set
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_BOOT_SYSFS=m
CONFIG_SCSI_BNX2_ISCSI=m
CONFIG_SCSI_BNX2X_FCOE=m
# CONFIG_BE2ISCSI is not set
CONFIG_BLK_DEV_3W_XXXX_RAID=m
# CONFIG_SCSI_HPSA is not set
CONFIG_SCSI_3W_9XXX=m
CONFIG_SCSI_3W_SAS=m
CONFIG_SCSI_ACARD=m
CONFIG_SCSI_AACRAID=m
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC94XX=m
CONFIG_AIC94XX_DEBUG=y
# CONFIG_SCSI_MVSAS is not set
CONFIG_SCSI_MVUMI=m
# CONFIG_SCSI_DPT_I2O is not set
CONFIG_SCSI_ADVANSYS=m
CONFIG_SCSI_ARCMSR=m
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=m
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_SCSI_HPTIOP is not set
CONFIG_SCSI_BUSLOGIC=m
CONFIG_VMWARE_PVSCSI=m
CONFIG_LIBFC=m
CONFIG_LIBFCOE=m
CONFIG_FCOE=m
CONFIG_FCOE_FNIC=m
CONFIG_SCSI_DMX3191D=m
CONFIG_SCSI_EATA=m
# CONFIG_SCSI_EATA_TAGGED_QUEUE is not set
# CONFIG_SCSI_EATA_LINKED_COMMANDS is not set
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=m
CONFIG_SCSI_GDTH=m
CONFIG_SCSI_ISCI=m
CONFIG_SCSI_IPS=m
CONFIG_SCSI_INITIO=m
# CONFIG_SCSI_INIA100 is not set
CONFIG_SCSI_STEX=m
CONFIG_SCSI_SYM53C8XX_2=m
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
# CONFIG_SCSI_SYM53C8XX_MMIO is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=m
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
CONFIG_SCSI_PM8001=m
# CONFIG_SCSI_SRP is not set
CONFIG_SCSI_BFA_FC=m
CONFIG_SCSI_DH=m
CONFIG_SCSI_DH_RDAC=m
CONFIG_SCSI_DH_HP_SW=m
# CONFIG_SCSI_DH_EMC is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
CONFIG_SATA_AHCI_PLATFORM=m
CONFIG_SATA_INIC162X=m
CONFIG_SATA_ACARD_AHCI=m
CONFIG_SATA_SIL24=m
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MD_MULTIPATH=y
CONFIG_MD_FAULTY=y
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
# CONFIG_DM_CRYPT is not set
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_MIRROR=m
CONFIG_DM_RAID=y
# CONFIG_DM_ZERO is not set
CONFIG_DM_MULTIPATH=m
# CONFIG_DM_MULTIPATH_QL is not set
CONFIG_DM_MULTIPATH_ST=m
# CONFIG_DM_UEVENT is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NOSY=m
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
# CONFIG_I2O_EXT_ADAPTEC is not set
CONFIG_I2O_CONFIG=m
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
CONFIG_I2O_BUS=y
# CONFIG_I2O_BLOCK is not set
# CONFIG_I2O_SCSI is not set
CONFIG_I2O_PROC=m
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
CONFIG_MII=y
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
CONFIG_ARCNET=m
CONFIG_ARCNET_1201=m
# CONFIG_ARCNET_1051 is not set
# CONFIG_ARCNET_RAW is not set
# CONFIG_ARCNET_CAP is not set
# CONFIG_ARCNET_COM90xx is not set
CONFIG_ARCNET_COM90xxIO=m
CONFIG_ARCNET_RIM_I=m
CONFIG_ARCNET_COM20020=m
CONFIG_ARCNET_COM20020_PCI=m

#
# CAIF transport drivers
#
CONFIG_ETHERNET=y
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_VENDOR_ATHEROS is not set
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=m
CONFIG_CNIC=m
CONFIG_TIGON3=y
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
CONFIG_BNA=y
CONFIG_NET_CALXEDA_XGMAC=m
# CONFIG_NET_VENDOR_CHELSIO is not set
CONFIG_DNET=y
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
CONFIG_DE2104X_DSL=0
CONFIG_TULIP=m
CONFIG_TULIP_MMIO=y
CONFIG_TULIP_NAPI=y
CONFIG_TULIP_NAPI_HW_MITIGATION=y
CONFIG_DE4X5=m
# CONFIG_WINBOND_840 is not set
# CONFIG_DM9102 is not set
# CONFIG_ULI526X is not set
# CONFIG_PCMCIA_XIRCOM is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DE600 is not set
# CONFIG_DE620 is not set
CONFIG_DL2K=y
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EXAR=y
CONFIG_S2IO=y
# CONFIG_NET_VENDOR_HP is not set
# CONFIG_NET_VENDOR_INTEL is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_SKGE=y
# CONFIG_SKGE_DEBUG is not set
# CONFIG_SKGE_GENESIS is not set
CONFIG_SKY2=y
CONFIG_SKY2_DEBUG=y
# CONFIG_NET_VENDOR_MICREL is not set
CONFIG_FEALNX=y
CONFIG_NET_VENDOR_NATSEMI=y
CONFIG_NATSEMI=y
CONFIG_NS83820=m
CONFIG_NET_VENDOR_8390=y
CONFIG_NE2K_PCI=m
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
# CONFIG_ETHOC is not set
CONFIG_NET_PACKET_ENGINE=y
CONFIG_HAMACHI=m
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=y
CONFIG_QLCNIC=m
# CONFIG_QLGE is not set
CONFIG_NETXEN_NIC=m
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_ATP=m
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
CONFIG_8139_OLD_RX_RESET=y
# CONFIG_R8169 is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
# CONFIG_NET_VENDOR_SIS is not set
# CONFIG_NET_VENDOR_SMSC is not set
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
CONFIG_NET_VENDOR_TEHUTI=y
CONFIG_TEHUTI=m
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
CONFIG_NET_VENDOR_WIZNET=y
CONFIG_WIZNET_W5100=y
CONFIG_WIZNET_W5300=m
# CONFIG_WIZNET_BUS_DIRECT is not set
CONFIG_WIZNET_BUS_INDIRECT=y
# CONFIG_WIZNET_BUS_ANY is not set
# CONFIG_FDDI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AMD_PHY is not set
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
# CONFIG_ICPLUS_PHY is not set
CONFIG_REALTEK_PHY=m
CONFIG_NATIONAL_PHY=y
# CONFIG_STE10XP is not set
CONFIG_LSI_ET1011C_PHY=m
CONFIG_MICREL_PHY=y
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
# CONFIG_MICREL_KS8995MA is not set
CONFIG_PLIP=m
CONFIG_PPP=m
CONFIG_PPP_BSDCOMP=m
# CONFIG_PPP_DEFLATE is not set
# CONFIG_PPP_FILTER is not set
# CONFIG_PPP_ASYNC is not set
# CONFIG_PPP_SYNC_TTY is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=m
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
CONFIG_XEN_NETDEV_FRONTEND=y
# CONFIG_XEN_NETDEV_BACKEND is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5520=m
CONFIG_KEYBOARD_ADP5588=m
CONFIG_KEYBOARD_ADP5589=m
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=m
CONFIG_KEYBOARD_LKKBD=m
CONFIG_KEYBOARD_TCA6416=m
CONFIG_KEYBOARD_TCA8418=m
CONFIG_KEYBOARD_LM8323=m
CONFIG_KEYBOARD_LM8333=m
CONFIG_KEYBOARD_MAX7359=m
CONFIG_KEYBOARD_MCS=m
CONFIG_KEYBOARD_MPR121=m
CONFIG_KEYBOARD_NEWTON=m
CONFIG_KEYBOARD_OPENCORES=m
CONFIG_KEYBOARD_STOWAWAY=m
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_OMAP4 is not set
CONFIG_KEYBOARD_TC3589X=m
CONFIG_KEYBOARD_TWL4030=m
CONFIG_KEYBOARD_XTKBD=m
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM860X_ONKEY=m
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_BMA150=m
CONFIG_INPUT_PCSPKR=m
CONFIG_INPUT_MAX8925_ONKEY=m
CONFIG_INPUT_MC13783_PWRBUTTON=m
CONFIG_INPUT_MMA8450=m
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
CONFIG_INPUT_TWL4030_PWRBUTTON=m
CONFIG_INPUT_TWL4030_VIBRA=m
CONFIG_INPUT_TWL6040_VIBRA=m
CONFIG_INPUT_UINPUT=m
CONFIG_INPUT_PCF50633_PMU=m
# CONFIG_INPUT_WM831X_ON is not set
CONFIG_INPUT_PCAP=m
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PARKBD=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
CONFIG_SERIO_PS2MULT=m
# CONFIG_GAMEPORT is not set

#
# Character devices
#
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX3107 is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=m
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=y
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
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
CONFIG_I2C_ALI1535=m
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=m
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_SIS5595=m
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_DESIGNWARE_PCI=y
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=y

#
# Other I2C/SMBus bus drivers
#
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
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_TOPCLIFF_PCH is not set
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_TLE62X0=m
CONFIG_HSI=m
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=m

#
# PPS support
#

#
# PPS generators support
#

#
# PTP clock support
#

#
# Enable Device Drivers -> PPS to see the PTP clock options.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=m
# CONFIG_W1_MASTER_DS1WM is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2408=m
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=m
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
# CONFIG_MAX8925_POWER is not set
# CONFIG_WM831X_BACKUP is not set
CONFIG_WM831X_POWER=y
CONFIG_WM8350_POWER=y
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=m
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_CHARGER_PCF50633=m
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_TWL4030=y
CONFIG_CHARGER_LP8727=y
# CONFIG_CHARGER_MANAGER is not set
# CONFIG_CHARGER_MAX8997 is not set
# CONFIG_CHARGER_SMB347 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_DS620=y
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=y
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_GL518SM=m
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=y
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=m
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TWL4030_MADC=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=y
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=m
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_WM831X=m
CONFIG_SENSORS_WM8350=m
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_MC13783_ADC=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
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
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_88PM860X=y
CONFIG_MFD_SM501=y
CONFIG_HTC_PASIC3=m
CONFIG_MFD_LM3533=y
# CONFIG_TPS6105X is not set
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65217=m
CONFIG_TWL4030_CORE=y
CONFIG_TWL4030_MADC=y
CONFIG_MFD_TWL4030_AUDIO=y
# CONFIG_TWL6030_PWM is not set
CONFIG_TWL6040_CORE=y
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_S5M_CORE is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=m
CONFIG_PCF50633_GPIO=m
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_ABX500_CORE is not set
CONFIG_EZX_PCAP=y
# CONFIG_MFD_CS5535 is not set
CONFIG_LPC_SCH=m
CONFIG_LPC_ICH=y
# CONFIG_MFD_RDC321X is not set
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_VX855=m
CONFIG_MFD_WL1273_CORE=y
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_PALMAS is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
CONFIG_REGULATOR_AD5398=m
# CONFIG_REGULATOR_MC13783 is not set
# CONFIG_REGULATOR_MC13892 is not set
CONFIG_REGULATOR_ISL6271A=m
# CONFIG_REGULATOR_88PM8607 is not set
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_MAX8649=m
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8925=m
CONFIG_REGULATOR_MAX8952=m
CONFIG_REGULATOR_MAX8997=m
# CONFIG_REGULATOR_PCAP is not set
CONFIG_REGULATOR_LP3971=m
CONFIG_REGULATOR_LP3972=m
CONFIG_REGULATOR_PCF50633=m
CONFIG_REGULATOR_RC5T583=y
CONFIG_REGULATOR_TPS62360=y
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65217=m
# CONFIG_REGULATOR_TPS6524X is not set
# CONFIG_REGULATOR_TWL4030 is not set
CONFIG_REGULATOR_WM831X=y
# CONFIG_REGULATOR_WM8350 is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_COMMON=y
CONFIG_DVB_CORE=y
CONFIG_VIDEO_MEDIA=y

#
# Multimedia drivers
#
CONFIG_RC_CORE=y
CONFIG_LIRC=y
CONFIG_RC_MAP=y
CONFIG_IR_NEC_DECODER=y
CONFIG_IR_RC5_DECODER=y
CONFIG_IR_RC6_DECODER=y
CONFIG_IR_JVC_DECODER=y
CONFIG_IR_SONY_DECODER=y
CONFIG_IR_RC5_SZ_DECODER=y
CONFIG_IR_SANYO_DECODER=y
CONFIG_IR_MCE_KBD_DECODER=y
CONFIG_IR_LIRC_CODEC=y
# CONFIG_RC_ATI_REMOTE is not set
# CONFIG_IR_ENE is not set
# CONFIG_IR_IMON is not set
# CONFIG_IR_MCEUSB is not set
# CONFIG_IR_ITE_CIR is not set
# CONFIG_IR_FINTEK is not set
# CONFIG_IR_NUVOTON is not set
# CONFIG_IR_REDRAT3 is not set
# CONFIG_IR_STREAMZAP is not set
# CONFIG_IR_WINBOND_CIR is not set
# CONFIG_RC_LOOPBACK is not set
# CONFIG_IR_GPIO_CIR is not set
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_CUSTOMISE=y

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2063=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_MEDIA_TUNER_MAX2165=m
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_MEDIA_TUNER_FC0011=m
CONFIG_MEDIA_TUNER_FC0012=m
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=m
CONFIG_MEDIA_TUNER_TUA9001=m
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_CAPTURE_DRIVERS=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
# CONFIG_VIDEO_HELPER_CHIPS_AUTO is not set
CONFIG_VIDEO_IR_I2C=y

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_TVAUDIO is not set
# CONFIG_VIDEO_TDA7432 is not set
# CONFIG_VIDEO_TDA9840 is not set
# CONFIG_VIDEO_TEA6415C is not set
# CONFIG_VIDEO_TEA6420 is not set
# CONFIG_VIDEO_MSP3400 is not set
# CONFIG_VIDEO_CS5345 is not set
# CONFIG_VIDEO_CS53L32A is not set
# CONFIG_VIDEO_WM8775 is not set
# CONFIG_VIDEO_WM8739 is not set
# CONFIG_VIDEO_VP27SMPX is not set

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set

#
# Video decoders
#
# CONFIG_VIDEO_ADV7180 is not set
# CONFIG_VIDEO_ADV7183 is not set
# CONFIG_VIDEO_BT819 is not set
# CONFIG_VIDEO_BT856 is not set
# CONFIG_VIDEO_BT866 is not set
# CONFIG_VIDEO_KS0127 is not set
# CONFIG_VIDEO_SAA7110 is not set
# CONFIG_VIDEO_SAA711X is not set
# CONFIG_VIDEO_SAA7191 is not set
# CONFIG_VIDEO_TVP514X is not set
# CONFIG_VIDEO_TVP5150 is not set
# CONFIG_VIDEO_TVP7002 is not set
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
# CONFIG_VIDEO_SAA717X is not set
# CONFIG_VIDEO_CX25840 is not set

#
# MPEG video encoders
#
# CONFIG_VIDEO_CX2341X is not set

#
# Video encoders
#
# CONFIG_VIDEO_SAA7127 is not set
# CONFIG_VIDEO_SAA7185 is not set
# CONFIG_VIDEO_ADV7170 is not set
# CONFIG_VIDEO_ADV7175 is not set
# CONFIG_VIDEO_ADV7343 is not set
# CONFIG_VIDEO_AK881X is not set

#
# Camera sensor devices
#
# CONFIG_VIDEO_OV7670 is not set
# CONFIG_VIDEO_VS6624 is not set
# CONFIG_VIDEO_MT9V011 is not set
# CONFIG_VIDEO_TCM825X is not set
# CONFIG_VIDEO_SR030PC30 is not set

#
# Flash devices
#

#
# Video improvement chips
#
# CONFIG_VIDEO_UPD64031A is not set
# CONFIG_VIDEO_UPD64083 is not set

#
# Miscelaneous helper chips
#
# CONFIG_VIDEO_THS7303 is not set
# CONFIG_VIDEO_M52790 is not set
CONFIG_V4L_PCI_DRIVERS=y
# CONFIG_VIDEO_BT848 is not set
# CONFIG_VIDEO_CX25821 is not set
# CONFIG_VIDEO_CX88 is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_IVTV is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_SAA7164 is not set
# CONFIG_VIDEO_ZORAN is not set
# CONFIG_V4L_ISA_PARPORT_DRIVERS is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_SI470X=y
CONFIG_I2C_SI470X=m
CONFIG_I2C_SI4713=y
CONFIG_RADIO_SI4713=y
CONFIG_RADIO_TEA5764=m
CONFIG_RADIO_SAA7706H=m
CONFIG_RADIO_TEF6862=m
CONFIG_RADIO_WL1273=y

#
# Texas Instruments WL128x FM driver (ST based)
#
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
# CONFIG_TTPCI_EEPROM is not set
# CONFIG_DVB_AV7110 is not set
# CONFIG_DVB_BUDGET_CORE is not set
CONFIG_SMS_SIANO_MDTV=m

#
# Siano module components
#
CONFIG_SMS_SDIO_DRV=m

#
# Supported FlexCopII (B2C2) Adapters
#
# CONFIG_DVB_B2C2_FLEXCOP is not set

#
# Supported BT878 Adapters
#

#
# Supported Pluto2 Adapters
#
# CONFIG_DVB_PLUTO2 is not set

#
# Supported SDMC DM1105 Adapters
#
# CONFIG_DVB_DM1105 is not set

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=m
CONFIG_DVB_FIREDTV_INPUT=y

#
# Supported Earthsoft PT1 Adapters
#
# CONFIG_DVB_PT1 is not set

#
# Supported Mantis Adapters
#
# CONFIG_MANTIS_CORE is not set

#
# Supported nGene Adapters
#
# CONFIG_DVB_NGENE is not set

#
# Supported ddbridge ('Octopus') Adapters
#
# CONFIG_DVB_DDBRIDGE is not set

#
# Supported DVB Frontends
#
CONFIG_DVB_FE_CUSTOMISE=y

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=m
CONFIG_DVB_STB6100=m
CONFIG_DVB_STV090x=m
CONFIG_DVB_STV6110x=m

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=m
CONFIG_DVB_TDA18271C2DD=m

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=m
CONFIG_DVB_ZL10039=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_STV6110=m
CONFIG_DVB_STV0900=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TUNER_CX24113=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_SI21XX=m
CONFIG_DVB_DS3000=m
CONFIG_DVB_MB86A16=m
CONFIG_DVB_TDA10071=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
CONFIG_DVB_S5H1432=m
CONFIG_DVB_DRXD=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_DIB9000=m
CONFIG_DVB_TDA10048=m
CONFIG_DVB_AF9013=m
CONFIG_DVB_EC100=m
CONFIG_DVB_HD29L2=m
CONFIG_DVB_STV0367=m
CONFIG_DVB_CXD2820R=m
CONFIG_DVB_RTL2830=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_LG2160=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_DTV=m
CONFIG_DVB_AU8522_V4L=m
CONFIG_DVB_S5H1411=m

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=m
CONFIG_DVB_DIB8000=m
CONFIG_DVB_MB86A20S=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=m
CONFIG_DVB_LNBP22=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DVB_ISL6423=m
CONFIG_DVB_A8293=m
CONFIG_DVB_LGS8GL5=m
CONFIG_DVB_LGS8GXX=m
CONFIG_DVB_ATBM8830=m
CONFIG_DVB_TDA665x=m
CONFIG_DVB_IX2505V=m
CONFIG_DVB_IT913X_FE=m
CONFIG_DVB_M88RS2000=m
CONFIG_DVB_AF9033=m

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
# CONFIG_AGP is not set
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=m
CONFIG_DRM_KMS_HELPER=m
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=m
CONFIG_DRM_TDFX=m
CONFIG_DRM_R128=m
CONFIG_DRM_RADEON=m
# CONFIG_DRM_RADEON_KMS is not set
# CONFIG_DRM_NOUVEAU is not set

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
# CONFIG_DRM_MGA is not set
CONFIG_DRM_VIA=m
CONFIG_DRM_SAVAGE=m
# CONFIG_DRM_VMWGFX is not set
# CONFIG_STUB_POULSBO is not set
CONFIG_VGASTATE=m
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_FB=m
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=m
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
# CONFIG_FB_WMT_GE_ROPS is not set
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=m
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=m
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=m
CONFIG_FB_NVIDIA_I2C=y
CONFIG_FB_NVIDIA_DEBUG=y
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=m
# CONFIG_FB_RIVA_I2C is not set
CONFIG_FB_RIVA_DEBUG=y
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_LE80578=m
CONFIG_FB_CARILLO_RANCH=m
CONFIG_FB_MATROX=m
# CONFIG_FB_MATROX_MILLENIUM is not set
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=m
# CONFIG_FB_MATROX_MAVEN is not set
CONFIG_FB_RADEON=m
# CONFIG_FB_RADEON_I2C is not set
# CONFIG_FB_RADEON_BACKLIGHT is not set
# CONFIG_FB_RADEON_DEBUG is not set
# CONFIG_FB_ATY128 is not set
CONFIG_FB_ATY=m
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
# CONFIG_FB_ATY_GX is not set
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=m
CONFIG_FB_S3_DDC=y
CONFIG_FB_SIS=m
# CONFIG_FB_SIS_300 is not set
CONFIG_FB_SIS_315=y
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=m
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
CONFIG_FB_VOODOO1=m
# CONFIG_FB_VT8623 is not set
CONFIG_FB_TRIDENT=m
# CONFIG_FB_ARK is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SM501 is not set
CONFIG_FB_VIRTUAL=m
CONFIG_XEN_FBDEV_FRONTEND=m
# CONFIG_FB_METRONOME is not set
CONFIG_FB_MB862XX=m
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=m
CONFIG_FB_AUO_K1900=m
# CONFIG_FB_AUO_K1901 is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_LTV350QV is not set
CONFIG_LCD_ILI9320=m
# CONFIG_LCD_TDO24M is not set
CONFIG_LCD_VGG2432A4=m
# CONFIG_LCD_PLATFORM is not set
CONFIG_LCD_S6E63M0=m
CONFIG_LCD_LD9040=m
# CONFIG_LCD_AMS369FG06 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=m
CONFIG_BACKLIGHT_GENERIC=m
CONFIG_BACKLIGHT_LM3533=m
# CONFIG_BACKLIGHT_PROGEAR is not set
CONFIG_BACKLIGHT_CARILLO_RANCH=m
CONFIG_BACKLIGHT_MAX8925=m
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_WM831X=m
# CONFIG_BACKLIGHT_ADP5520 is not set
CONFIG_BACKLIGHT_ADP8860=m
CONFIG_BACKLIGHT_ADP8870=m
CONFIG_BACKLIGHT_88PM860X=m
CONFIG_BACKLIGHT_PCF50633=m
# CONFIG_BACKLIGHT_LP855X is not set
CONFIG_BACKLIGHT_PANDORA=m
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
# CONFIG_LOGO_LINUX_CLUT224 is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=m
# CONFIG_HIDRAW is not set
CONFIG_HID_GENERIC=m

#
# Special HID drivers
#
CONFIG_HID_APPLE=m
# CONFIG_HID_ELECOM is not set
CONFIG_HID_MAGICMOUSE=m
# CONFIG_HID_TIVO is not set
CONFIG_HID_WACOM=m
# CONFIG_HID_WIIMOTE is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
CONFIG_MMC=m
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_PLTFM=m
CONFIG_MMC_WBSD=m
# CONFIG_MMC_SPI is not set
CONFIG_MMC_CB710=m
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MEMSTICK=m
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
CONFIG_LEDS_88PM860X=m
CONFIG_LEDS_LM3530=m
CONFIG_LEDS_LM3533=m
CONFIG_LEDS_LP3944=m
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=m
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=m
# CONFIG_LEDS_PCA9633 is not set
CONFIG_LEDS_WM831X_STATUS=m
CONFIG_LEDS_WM8350=m
# CONFIG_LEDS_DAC124S085 is not set
CONFIG_LEDS_REGULATOR=m
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=m
# CONFIG_LEDS_ADP5520 is not set
CONFIG_LEDS_MC13783=m
CONFIG_LEDS_TCA6507=m
CONFIG_LEDS_MAX8997=m
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_TRIGGERS is not set

#
# LED Triggers
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=m
CONFIG_EDAC_E752X=m
# CONFIG_EDAC_I82975X is not set
CONFIG_EDAC_I3000=m
CONFIG_EDAC_X38=m
# CONFIG_EDAC_I5400 is not set
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM860X=y
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_DS3232=y
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8925=y
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8563=m
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
CONFIG_RTC_DRV_BQ32K=y
CONFIG_RTC_DRV_TWL4030=y
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=m
CONFIG_RTC_DRV_EM3027=m
CONFIG_RTC_DRV_RV3029C2=m

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
CONFIG_RTC_DRV_M41T94=m
CONFIG_RTC_DRV_DS1305=y
# CONFIG_RTC_DRV_DS1390 is not set
CONFIG_RTC_DRV_MAX6902=m
CONFIG_RTC_DRV_R9701=y
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_DS3234 is not set
# CONFIG_RTC_DRV_PCF2123 is not set

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=m
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_STK17TA8=y
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
# CONFIG_RTC_DRV_V3020 is not set
CONFIG_RTC_DRV_WM831X=y
CONFIG_RTC_DRV_WM8350=y
# CONFIG_RTC_DRV_PCF50633 is not set

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_PCAP is not set
CONFIG_RTC_DRV_MC13XXX=y
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
# CONFIG_DMADEVICES_VDEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=m
CONFIG_INTEL_IOATDMA=y
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
CONFIG_DCA=y
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=m
CONFIG_UIO_CIF=m
# CONFIG_UIO_PDRV is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_AEC=m
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
CONFIG_UIO_NETX=m
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y

#
# Virtio drivers
#
CONFIG_VIRTIO_BALLOON=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set

#
# Xen driver support
#
# CONFIG_XEN_BALLOON is not set
CONFIG_XEN_DEV_EVTCHN=m
CONFIG_XEN_BACKEND=y
# CONFIG_XENFS is not set
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
CONFIG_XEN_GNTDEV=y
CONFIG_XEN_GRANT_DEV_ALLOC=y
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_TMEM=y
CONFIG_XEN_PCIDEV_BACKEND=m
CONFIG_XEN_PRIVCMD=m
CONFIG_STAGING=y
CONFIG_ET131X=m
# CONFIG_SLICOSS is not set
CONFIG_ECHO=y
# CONFIG_COMEDI is not set
CONFIG_PANEL=m
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
# CONFIG_PANEL_CHANGE_MESSAGE is not set
# CONFIG_RTS_PSTOR is not set
CONFIG_DX_SEP=m

#
# IIO staging drivers
#
# CONFIG_IIO_ST_HWMON is not set
CONFIG_IIO_SW_RING=m

#
# Accelerometers
#
CONFIG_ADIS16201=m
CONFIG_ADIS16203=m
# CONFIG_ADIS16204 is not set
# CONFIG_ADIS16209 is not set
CONFIG_ADIS16220=m
CONFIG_ADIS16240=m
CONFIG_KXSD9=y
CONFIG_SCA3000=y

#
# Analog to digital converters
#
CONFIG_AD7291=y
CONFIG_AD7298=m
CONFIG_AD799X=y
CONFIG_AD799X_RING_BUFFER=y
# CONFIG_AD7476 is not set
CONFIG_AD7887=y
# CONFIG_AD7793 is not set
CONFIG_AD7192=m
# CONFIG_ADT7310 is not set
# CONFIG_ADT7410 is not set
# CONFIG_AD7280 is not set
CONFIG_MAX1363=m
CONFIG_MAX1363_RING_BUFFER=y

#
# Analog digital bi-direction converters
#

#
# Capacitance to digital converters
#
CONFIG_AD7150=y
CONFIG_AD7152=m
CONFIG_AD7746=y

#
# Digital to analog converters
#
CONFIG_AD5064=m
CONFIG_AD5360=y
# CONFIG_AD5380 is not set
# CONFIG_AD5421 is not set
CONFIG_AD5624R_SPI=m
CONFIG_AD5446=y
CONFIG_AD5504=y
CONFIG_AD5764=m
CONFIG_AD5791=m
# CONFIG_AD5686 is not set

#
# Direct Digital Synthesis
#
# CONFIG_AD5930 is not set
CONFIG_AD9832=m
CONFIG_AD9834=m
CONFIG_AD9850=y
# CONFIG_AD9852 is not set
# CONFIG_AD9910 is not set
# CONFIG_AD9951 is not set

#
# Digital gyroscope sensors
#
CONFIG_ADIS16060=m
CONFIG_ADIS16080=m
CONFIG_ADIS16130=y
# CONFIG_ADIS16260 is not set
CONFIG_ADXRS450=m

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=m

#
# Inertial measurement units
#
CONFIG_ADIS16400=m

#
# Light sensors
#
# CONFIG_SENSORS_ISL29018 is not set
CONFIG_SENSORS_ISL29028=y
CONFIG_SENSORS_TSL2563=m
# CONFIG_TSL2583 is not set
# CONFIG_TSL2x7x is not set

#
# Magnetometer sensors
#
CONFIG_SENSORS_HMC5843=y

#
# Active energy metering IC
#
CONFIG_ADE7753=y
CONFIG_ADE7754=y
# CONFIG_ADE7758 is not set
# CONFIG_ADE7759 is not set
CONFIG_ADE7854=m
CONFIG_ADE7854_I2C=m
# CONFIG_ADE7854_SPI is not set

#
# Resolver to digital converters
#
CONFIG_AD2S90=m

#
# Triggers - standalone
#
# CONFIG_IIO_PERIODIC_RTC_TRIGGER is not set
# CONFIG_IIO_SYSFS_TRIGGER is not set
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_ZRAM is not set
# CONFIG_ZCACHE is not set
CONFIG_ZSMALLOC=m
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
CONFIG_FB_XGI=m
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_FT1000=y

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=m
CONFIG_STAGING_MEDIA=y
CONFIG_DVB_CXD2099=y
# CONFIG_VIDEO_DT3155 is not set
# CONFIG_LIRC_STAGING is not set

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_PHONE is not set
# CONFIG_RAMSTER is not set
CONFIG_IPACK_BUS=m
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_WIMAX_GDM72XX=m
# CONFIG_WIMAX_GDM72XX_QOS is not set
CONFIG_WIMAX_GDM72XX_K_MODE=y
# CONFIG_WIMAX_GDM72XX_WIMAX2 is not set
CONFIG_WIMAX_GDM72XX_SDIO=y
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_AMILO_RFKILL is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
CONFIG_IBM_RTL=m
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=m
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
CONFIG_VIRT_DRIVERS=y
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=m

#
# Extcon Device Drivers
#
CONFIG_EXTCON_MAX8997=m
CONFIG_MEMORY=y
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Analog to digital converters
#

#
# Amplifiers
#
CONFIG_AD8366=m
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
# CONFIG_VME_CA91CX42 is not set
CONFIG_VME_TSI148=m

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=y

#
# VME Device Drivers
#
CONFIG_VME_USER=y

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=m
# CONFIG_DMIID is not set
CONFIG_DMI_SYSFS=m
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
# CONFIG_GOOGLE_SMI is not set
# CONFIG_GOOGLE_MEMCONSOLE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=m
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
# CONFIG_EXT3_FS_POSIX_ACL is not set
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=m
CONFIG_EXT4_FS_XATTR=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_EXT4_DEBUG=y
CONFIG_FS_XIP=y
CONFIG_JBD=m
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=m
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=m
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=y
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_OCFS2_DEBUG_FS=y
CONFIG_FS_POSIX_ACL=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=m
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=m

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=m
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=m
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=m
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=m
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=m
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=m
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=m
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
# CONFIG_NLS_UTF8 is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
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
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_LKDTM is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAIL_MMC_REQUEST is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_ASYNC_RAID6_TEST=m
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_KSTRTOX=m
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
# CONFIG_IOMMU_STRESS is not set
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
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
# CONFIG_IMA is not set
CONFIG_EVM=y
CONFIG_DEFAULT_SECURITY_APPARMOR=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="apparmor"
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
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
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_GHASH=m
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=m
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=m
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=m
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
# CONFIG_KVM_INTEL is not set
# CONFIG_KVM_AMD is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y

--G6nVm6DDWH/FONJq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--G6nVm6DDWH/FONJq--
