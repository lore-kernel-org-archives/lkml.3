Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaGHCMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 22:12:54 -0400
Received: from mga14.intel.com ([192.55.52.115]:20669 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbaGHCMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 22:12:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,622,1400050800"; 
   d="log'?scan'208";a="558605997"
Date: Tue, 8 Jul 2014 10:11:49 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: [workqueue] WARNING: CPU: 0 PID: 76 at drivers/block/floppy.c:968
 schedule_bh()
Message-ID: <20140708021149.GA12956@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
commit b22ce2785d97423846206cceec4efee0c4afd980
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Wed Aug 28 17:33:37 2013 -0400
Commit:     Tejun Heo <tj@kernel.org>
CommitDate: Thu Aug 29 09:19:28 2013 -0400

    workqueue: cond_resched() after processing each work item
    
    If !PREEMPT, a kworker running work items back to back can hog CPU.
    This becomes dangerous when a self-requeueing work item which is
    waiting for something to happen races against stop_machine.  Such
    self-requeueing work item would requeue itself indefinitely hogging
    the kworker and CPU it's running on while stop_machine would wait for
    that CPU to enter stop_machine while preventing anything else from
    happening on all other CPUs.  The two would deadlock.
    
    Jamie Liu reports that this deadlock scenario exists around
    scsi_requeue_run_queue() and libata port multiplier support, where one
    port may exclude command processing from other ports.  With the right
    timing, scsi_requeue_run_queue() can end up requeueing itself trying
    to execute an IO which is asked to be retried while another device has
    an exclusive access, which in turn can't make forward progress due to
    stop_machine.
    
    Fix it by invoking cond_resched() after executing each work item.
    
    Signed-off-by: Tejun Heo <tj@kernel.org>
    Reported-by: Jamie Liu <jamieliu@google.com>
    References: http://thread.gmane.org/gmane.linux.kernel/1552567
    Cc: stable@vger.kernel.org
    --
     kernel/workqueue.c |    9 +++++++++
     1 file changed, 9 insertions(+)

+---------------------------------------------------------+------------+------------+------------------+
|                                                         | c95389b4cd | b22ce2785d | v3.16-rc4_070708 |
+---------------------------------------------------------+------------+------------+------------------+
| boot_successes                                          | 900        | 249        | 79               |
| boot_failures                                           | 0          | 51         | 2                |
| WARNING:CPU:PID:at_drivers/block/floppy.c:schedule_bh() | 0          | 51         | 2                |
| backtrace:user_reset_fdc                                | 0          | 51         | 2                |
| backtrace:floppy_async_init                             | 0          | 51         | 2                |
| backtrace:async_run_entry_fn                            | 0          | 51         | 2                |
+---------------------------------------------------------+------------+------------+------------------+

[   45.121121] PCI: setting IRQ 11 as level-triggered
[   45.407538] e1000 0000:00:03.0: setting latency timer to 64
[   45.686040] ------------[ cut here ]------------
[   45.975060] WARNING: CPU: 0 PID: 76 at drivers/block/floppy.c:968 schedule_bh+0x47/0x80()
[   47.312537] CPU: 0 PID: 76 Comm: kworker/u2:1 Not tainted 3.11.0-rc7-00025-gb22ce27 #8
[   47.848171] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
[   48.433222] Workqueue: events_unbound async_run_entry_fn
[   48.725491]  00000000 d25d7e0c c2745b10 d25d7e3c c105472d c2ff0b10 00000000 0000004c
[   49.494639]  c30df57c 000003c8 c1a2fb57 c1a2fb57 00000001 c1a33aa0 c39a0ca0 d25d7e4c
[   51.548252]  c1054812 00000009 00000000 d25d7e5c c1a2fb57 00000000 00000000 d25d7e84
[   56.319716] Call Trace:
[   58.164457]  [<c2745b10>] dump_stack+0x16/0x18
[   61.355641]  [<c105472d>] warn_slowpath_common+0x8d/0xb0
[   61.822789]  [<c1a2fb57>] ? schedule_bh+0x47/0x80
[   62.103589]  [<c1a2fb57>] ? schedule_bh+0x47/0x80
[   62.538170]  [<c1a33aa0>] ? floppy_hardint+0x1a0/0x1a0
[   62.920432]  [<c1054812>] warn_slowpath_null+0x22/0x30
[   63.411821]  [<c1a2fb57>] schedule_bh+0x47/0x80
[   66.271423]  [<c1a33ed5>] wait_til_done+0x15/0x230
[   71.033237]  [<c1063260>] ? cascade+0xa0/0xa0
[   75.990887]  [<c1a348d7>] user_reset_fdc+0xa7/0x110
[   78.921153]  [<c384c939>] floppy_async_init+0x9ee/0x1263
[   83.512228]  [<c108a0e4>] async_run_entry_fn+0x44/0x1e0
[   85.519262]  [<c16901b2>] ? __list_del_entry+0x202/0x220
[   87.120223]  [<c1075687>] ? pwq_dec_nr_in_flight+0x137/0x140
[   89.499077]  [<c1075f5b>] process_one_work+0x33b/0x840
[   90.274017]  [<c108f542>] ? ttwu_do_wakeup+0x12/0x90
[   91.294072]  [<c16901b2>] ? __list_del_entry+0x202/0x220
[   91.634105]  [<c1076874>] worker_thread+0x414/0x890
[   91.994817]  [<c1076460>] ? process_one_work+0x840/0x840
[   92.265965]  [<c1080ba6>] kthread+0xa6/0xb0
[   92.658144]  [<c2763f57>] ret_from_kernel_thread+0x1b/0x28
[   92.971880]  [<c1080b00>] ? __kthread_unpark+0x70/0x70
[   93.254541] ---[ end trace 857f8343e4eb716b ]---
[   93.508601] floppy0: no floppy controllers found

git bisect start v3.11 v3.10 --
git bisect good 89d0abe3d695103505c025dde6e07b9c3dd772f4  # 13:01    300+      0  Merge tag 'arm64-stable' of git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64
git bisect good 8742f229b635bf1c1c84a3dfe5e47c814c20b5c8  # 13:18    300+      0  userns: limit the maximum depth of user_namespace->parent chain
git bisect good 94fc5d9de5bd757ad46f0d94bc4ebf617c4487f6  # 13:35    300+      0  proc: return on proc_readdir error
git bisect good 5e25e4f304ce53004dcd01725938c0bc45c75d35  # 13:48    300+      0  Merge tag 'usb-3.11-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb
git bisect good 06a557f7a68e126181f09831cb2fac6f7a7f43c2  # 14:22    300+      1  Merge tag 'nfs-for-3.11-5' of git://git.linux-nfs.org/projects/trondmy/linux-nfs
git bisect  bad 936dbcc3f2fc7314f3c1645fc39ea51117f6d73b  # 14:36     15-      2  Merge tag 'sound-3.11' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
git bisect  bad 155e3a353943a3e713cd33357cfd58e995900a81  # 14:50     13-      1  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input
git bisect  bad ff497452636f4687e517964817b7e2bd99f4b44b  # 15:06     48-      2  Merge branch 'for-3.11-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq
git bisect  bad b22ce2785d97423846206cceec4efee0c4afd980  # 15:51     13-      2  workqueue: cond_resched() after processing each work item
# first bad commit: [b22ce2785d97423846206cceec4efee0c4afd980] workqueue: cond_resched() after processing each work item
git bisect good c95389b4cd6a4b52af78bea706a274453e886251  # 16:51    900+      0  Merge branch 'akpm' (patches from Andrew Morton)
git bisect  bad 98610962bbb418f6d847c402637ca14e78c38344  # 16:51      0-      2  0day head guard for 'devel-hourly-2014070708'
git bisect  bad cd3de83f147601356395b57a8673e9c5ff1e59d1  # 16:51      0-     34  Linux 3.16-rc4
git bisect  bad d584f2acf5cc6c4a14c330930222d8e70fe024a6  # 18:02     62-      1  Add linux-next specific files for 20140707


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

--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-ivb41-99:20140707155130:i386-randconfig-c1-07070935::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.11.0-rc7-00025-gb22ce27 (kbuild@jaketown) (g=
cc version 4.8.2 (Debian 4.8.2-18) ) #8 Mon Jul 7 15:41:03 CST 2014
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
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/0=
1/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x100000
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
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] initial memory mapped: [mem 0x00000000-0x03bfffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13800000-0x13bfffff]
[    0.000000]  [mem 0x13800000-0x13bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x137fffff]
[    0.000000]  [mem 0x10000000-0x137fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x039cd000, 0x039cdfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
[    0.000000] ACPI: RSDP 000f0d00 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 13fffc2a 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACP 13fff1c0 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC=
 00000001)
[    0.000000] ACPI: DSDT 13ffe040 01180 (v01 BOCHS  BXPCDSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACS 13ffe000 00040
[    0.000000] ACPI: SSDT 13fff234 0093E (v01 BOCHS  BXPCSSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: APIC 13fffb72 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC=
 00000001)
[    0.000000] ACPI: HPET 13fffbf2 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC=
 00000001)
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat c32b9fc0, node_mem_map d3=
a3d020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 608 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 31e6fc0
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-c1-07070935/linux-d=
evel:devel-hourly-2014070708:b22ce2785d97423846206cceec4efee0c4afd980:bisec=
t-linux3/.vmlinuz-b22ce2785d97423846206cceec4efee0c4afd980-20140707154539-1=
20-ivb41 branch=3Dlinux-devel/devel-hourly-2014070708 BOOT_IMAGE=3D/kernel/=
i386-randconfig-c1-07070935/b22ce2785d97423846206cceec4efee0c4afd980/vmlinu=
z-3.11.0-rc7-00025-gb22ce27 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 278104K/327280K available (23955K kernel code, 6236K=
 rwdata, 10684K rodata, 1236K init, 620K bss, 49176K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe3000 - 0xfffff000   ( 112 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xfffe1000   ( 695 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xc37ed000 - 0xc3922000   (1236 kB)
[    0.000000]       .data : 0xc2765115 - 0xc37ec140   (16924 kB)
[    0.000000]       .text : 0xc1000000 - 0xc2765115   (23956 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D1, =
Nodes=3D1
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3Dd3408000 soft=3Dd340a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled, bootconsole disabled
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.11.0-rc7-00025-gb22ce27 (kbuild@jaketown) (g=
cc version 4.8.2 (Debian 4.8.2-18) ) #8 Mon Jul 7 15:41:03 CST 2014
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
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/0=
1/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x100000
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
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] initial memory mapped: [mem 0x00000000-0x03bfffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13800000-0x13bfffff]
[    0.000000]  [mem 0x13800000-0x13bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x137fffff]
[    0.000000]  [mem 0x10000000-0x137fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x039cd000, 0x039cdfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
[    0.000000] ACPI: RSDP 000f0d00 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 13fffc2a 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACP 13fff1c0 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC=
 00000001)
[    0.000000] ACPI: DSDT 13ffe040 01180 (v01 BOCHS  BXPCDSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACS 13ffe000 00040
[    0.000000] ACPI: SSDT 13fff234 0093E (v01 BOCHS  BXPCSSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: APIC 13fffb72 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC=
 00000001)
[    0.000000] ACPI: HPET 13fffbf2 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC=
 00000001)
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat c32b9fc0, node_mem_map d3=
a3d020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 608 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 31e6fc0
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramd=
isk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram=
0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-c1-07070935/linux-d=
evel:devel-hourly-2014070708:b22ce2785d97423846206cceec4efee0c4afd980:bisec=
t-linux3/.vmlinuz-b22ce2785d97423846206cceec4efee0c4afd980-20140707154539-1=
20-ivb41 branch=3Dlinux-devel/devel-hourly-2014070708 BOOT_IMAGE=3D/kernel/=
i386-randconfig-c1-07070935/b22ce2785d97423846206cceec4efee0c4afd980/vmlinu=
z-3.11.0-rc7-00025-gb22ce27 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 278104K/327280K available (23955K kernel code, 6236K=
 rwdata, 10684K rodata, 1236K init, 620K bss, 49176K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe3000 - 0xfffff000   ( 112 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xfffe1000   ( 695 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xc37ed000 - 0xc3922000   (1236 kB)
[    0.000000]       .data : 0xc2765115 - 0xc37ec140   (16924 kB)
[    0.000000]       .text : 0xc1000000 - 0xc2765115   (23956 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D1, =
Nodes=3D1
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3Dd3408000 soft=3Dd340a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled, bootconsole disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 5389.47 Bogo=
MIPS (lpj=3D8978360)
[    0.006666] pid_max: default: 32768 minimum: 301
[    0.006724] Security Framework initialized
[    0.007431] Yama: becoming mindful.
[    0.008072] Mount-cache hash table entries: 512
[    0.009046] Initializing cgroup subsys debug
[    0.010010] Initializing cgroup subsys devices
[    0.011063] Initializing cgroup subsys net_cls
[    0.012062] Initializing cgroup subsys blkio
[    0.013413] mce: CPU supports 10 MCE banks
[    0.014413] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014413] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014413] tlb_flushall_shift: 6
[    0.016672] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.041524] ACPI: Core revision 20130517
[    0.044234] ACPI: All ACPI Tables successfully acquired
[    0.045611] ACPI: setting ELCR to 0200 (from 0c00)
[    0.046751] ftrace: allocating 56485 entries in 111 pages
[    0.073437] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.082714] regulator-dummy: no parameters
[    0.083412] NET: Registered protocol family 16
[    0.087287] EISA bus registered
[    0.088528] ACPI: bus type PCI registered
[    0.089181] dca service started, version 1.12.1
[    0.089916] PCI: PCI BIOS revision 2.10 entry at 0xfd456, last bus=3D0
[    0.107825] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.110538] bio: create slab <bio-0> at 0
[    0.113943] ACPI: Added _OSI(Module Device)
[    0.116677] ACPI: Added _OSI(Processor Device)
[    0.120008] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.123343] ACPI: Added _OSI(Processor Aggregator Device)
[    0.132651] ACPI: EC: Look up EC in DSDT
[    0.147406] ACPI: Interpreter enabled
[    0.150017] ACPI: (supports S0 S5)
[    0.153340] ACPI: Using PIC for interrupt routing
[    0.156713] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.200110] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.207813] PCI host bridge to bus 0000:00
[    0.210013] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.213347] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.216683] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.220013] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.223348] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.226681] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.230017] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.233349] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.236725] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.245617] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.251991] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.268439] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.280701] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.284702] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.286691] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.294507] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.301643] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.310023] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.348775] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.353364] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.363345] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.373345] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.406682] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.410824] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.415111] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.423956] pci_bus 0000:00: on NUMA node 0
[    0.425919] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.427607] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.431585] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.435102] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.438384] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.441893] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.445261] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.446680] ACPI: \_SB_.PCI0: notify handler is installed
[    0.450046] Found 1 acpi root devices
[    0.452304] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.453341] vgaarb: loaded
[    0.456673] vgaarb: bridge control possible 0000:00:02.0
[    0.458951] SCSI subsystem initialized
[    0.460014] ACPI: bus type ATA registered
[    0.461634] libata version 3.00 loaded.
[    0.463500] media: Linux media interface: v0.10
[    0.465222] Linux video capture interface: v2.00
[    0.466688] pps_core: LinuxPPS API ver. 1 registered
[    0.470006] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.473355] PTP clock support registered
[    0.476769] EDAC MC: Ver: 3.0.0
[    0.479214] PCI: Using ACPI for IRQ routing
[    0.480010] PCI: pci_cache_line_size set to 64 bytes
[    0.486995] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.490011] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.492154] Bluetooth: Core ver 2.16
[    0.493361] NET: Registered protocol family 31
[    0.496674] Bluetooth: HCI device and connection manager initialized
[    0.498517] Bluetooth: HCI socket layer initialized
[    0.500011] Bluetooth: L2CAP socket layer initialized
[    0.501860] Bluetooth: SCO socket layer initialized
[    0.503340] NetLabel: Initializing
[    0.506674] NetLabel:  domain hash size =3D 128
[    0.508194] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.510045] NetLabel:  unlabeled traffic allowed by default
[    0.511916] nfc: nfc_init: NFC Core ver 0.1
[    0.513370] NET: Registered protocol family 39
[    0.518249] Switched to clocksource kvm-clock
[    0.519999] Warning: could not register all branches stats
[    0.521406] Warning: could not register annotated branches stats
[    0.546152] FS-Cache: Loaded
[    0.547743] pnp: PnP ACPI init
[    0.549180] ACPI: bus type PNP registered
[    0.551304] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.554569] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.557195] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.559906] pnp 00:03: [dma 2]
[    0.563330] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.566219] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.569145] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.571888] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.575757] pnp 00:07: Plug and Play ACPI device, IDs PNP0a06 (active)
[    0.578293] pnp: PnP ACPI: found 8 devices
[    0.579955] ACPI: bus type PNP unregistered
[    1.312990] mdacon: MDA with 8K of memory detected.
[    1.315909] Console: switching consoles 13-16 to MDA-2
[    1.360992] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.365523] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    1.370171] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    1.375069] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    1.379225] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    1.406538] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    1.425545] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    1.430495] NET: Registered protocol family 2
[    1.435228] TCP established hash table entries: 4096 (order: 3, 32768 by=
tes)
[    1.439934] TCP bind hash table entries: 4096 (order: 2, 16384 bytes)
[    1.444501] TCP: Hash tables configured (established 4096 bind 4096)
[    1.449516] TCP: reno registered
[    1.452916] UDP hash table entries: 256 (order: 0, 4096 bytes)
[    1.455730] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
[    1.458163] NET: Registered protocol family 1
[    1.459758] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.461883] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.468944] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.471063] pci 0000:00:02.0: Boot video device
[    1.473011] PCI: CLS 0 bytes, default 64
[    1.475253] Unpacking initramfs...
[    1.660930] Freeing initrd memory: 3276K (d3cbd000 - d3ff0000)
[    1.665192] Machine check injector initialized
[    1.667284] cryptomgr_test (18) used greatest stack depth: 7460 bytes le=
ft
[    1.669965] cryptomgr_probe (25) used greatest stack depth: 7252 bytes l=
eft
[    1.672845] cryptomgr_test (24) used greatest stack depth: 6404 bytes le=
ft
[    1.675910] PCLMULQDQ-NI instructions are not detected.
[    1.677558] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    1.681075] NatSemi SCx200 Driver
[    1.688102] VFS: Disk quotas dquot_6.5.2
[    1.689708] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.693923] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    1.697057] NTFS driver 2.1.30 [Flags: R/W].
[    1.699993] QNX6 filesystem 1.0.0 registered.
[    1.705993] JFS: nTxBlock =3D 2198, nTxLock =3D 17586
[    1.709360] SGI XFS with security attributes, debug enabled
[    1.712899] OCFS2 1.5.0
[    1.714493] ocfs2: Registered cluster interface o2cb
[    1.716427] OCFS2 DLMFS 1.5.0
[    1.718122] OCFS2 User DLM kernel interface loaded
[    1.719656] OCFS2 Node Manager 1.5.0
[    1.721682] OCFS2 DLM 1.5.0
[    1.723096] msgmni has been set to 549
[    1.730346] alg: No test for lz4 (lz4-generic)
[    1.732019] alg: No test for stdrng (krng)
[    1.734281] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    1.737215] io scheduler noop registered
[    1.738998] io scheduler cfq registered (default)
[    1.751794] list_sort_test: start testing list_sort()
[    1.755228] xz_dec_test: module loaded
[    1.756524] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
250 0' and write .xz files to it.
[    1.760339] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.762268] cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
[    1.764845] Console: switching consoles 13-16 to MDA-2
[    1.767150] nvidiafb_setup START
[    1.772960] vmlfb: initializing
[    1.774556] no IO addresses supplied
[    1.776868] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    1.780147] fbcon: CL Picasso4 (fb0) is primary device
[    2.331901] Console: switching to colour frame buffer device 80x30
[    2.558242] uvesafb: Getting VBE info block failed (eax=3D0x10a, err=3D0)
[    2.568347] uvesafb: vbe_init() failed with -22
[    2.577515] uvesafb: probe of uvesafb.0 failed with error -22
[    2.587395] ipmi message handler version 39.2
[    3.016243] ipmi device interface
[    3.284097] IPMI System Interface driver.
[    3.557588] ipmi_si: Adding default-specified kcs state machine
[    3.824875] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    4.373609] ipmi_si: Interface detection failed
[    4.640794] tsc: Refined TSC clocksource calibration: 2693.508 MHz
[    4.845955] ipmi_si: Adding default-specified smic state machine
[    5.134200] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    5.665705] ipmi_si: Interface detection failed
[    5.899108] ipmi_si: Adding default-specified bt state machine
[    6.130162] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    6.595807] ipmi_si: Interface detection failed
[    6.803041] ipmi_si: Unable to find any System Interface(s)
[    7.008325] IPMI Watchdog: driver initialized
[    7.223017] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    7.649469] ACPI: Power Button [PWRF]
[    7.866138] isapnp: Scanning for PnP cards...
[    8.410036] isapnp: No Plug & Play device found
[    8.623847] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    8.849439] r3964: Philips r3964 Driver $Revision: 1.10 $
[    9.054924] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    9.295536] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    9.478848] serial: Freescale lpuart driver
[    9.675321] Initializing Nozomi driver 2.1d
[    9.886256] lp: driver loaded but no devices found
[   10.089521] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[   10.301678] ac.o: No PCI boards found.
[   10.521240] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[   10.747214] Non-volatile memory driver v1.3
[   10.975727] toshiba: not a supported Toshiba laptop
[   11.211282] ppdev: user-space parallel port driver
[   11.430420] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[   11.653955] platform pc8736x_gpio.0: no device found
[   11.876891] nsc_gpio initializing
[   12.099252] Linux agpgart interface v0.103
[   12.323122] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[   13.252159] Hangcheck: Using getrawmonotonic().
[   13.926173] [drm] Initialized drm 1.1.0 20060810
[   14.579707] [drm] radeon kernel modesetting enabled.
[   15.263626] parport_pc 00:04: reported by Plug and Play ACPI
[   15.936515] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[   16.375879] lp0: using parport0 (interrupt-driven).
[   16.599293] loop: module loaded
[   16.822724] Floppy drive(s): fd0 is 1.44M
[   17.050224] MM: desc_per_page =3D 128
[   17.274843] nbd: registered device at major 43
[   17.495086] lkdtm: No crash points registered, enable through debugfs
[   17.727679] Phantom Linux Driver, version n0.9.8, init OK
[   17.951344] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[   18.399573] c2port c2port0: C2 port uc added
[   18.628125] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[   19.340512] Guest personality initialized and is inactive
[   19.587134] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D60)
[   19.828404] Initialized host personality
[   20.065081] Uniform Multi-Platform E-IDE driver
[   20.294874] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[   20.759246] ide-gd driver 1.18
[   20.992090] Loading iSCSI transport class v2.0-870.
[   21.293905] fnic: Cisco FCoE HBA Driver, ver 1.5.0.23
[   21.524714] fnic: Successfully Initialized Trace Buffer
[   21.794972] bnx2fc: Broadcom NetXtreme II FCoE Driver bnx2fc v1.0.14 (Ma=
r 08, 2013)
[   22.250913] iscsi: registered transport (tcp)
[   22.483918] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[   22.717739] Detecting Adaptec I2O RAID controllers...
[   22.962772] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[   23.201260] isci: Intel(R) C600 SAS Controller Driver - version 1.1.0
[   23.446029] scsi: <fdomain> Detection failed (no card)
[   23.691096] NCR53c406a: no available ports found
[   23.937650] sym53c416.c: Version 1.0.0-ac
[   24.185889] qlogicfas: no cards were found, please specify I/O address a=
nd IRQ using iobase=3D and irq=3D options
[   24.459154] iscsi: registered transport (qla4xxx)
[   24.976517] QLogic iSCSI HBA Driver
[   25.235061] Brocade BFA FC/FCOE SCSI driver - version: 3.2.21.1
[   25.520138] csiostor: Chelsio FCoE driver 1.0.0
[   27.032268] DC390: clustering now enabled by default. If you get problem=
s load
[   27.534028]        with "disable_clustering=3D1" and report to maintaine=
rs
[   27.785611] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 ES=
T 2006)
[   28.280625] megasas: 06.600.18.00-rc1 Wed. May. 15 17:00:00 PDT 2013
[   28.535685] mpt2sas version 15.100.00.00 loaded
[   28.796092] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[   29.052716] LSI 3ware SAS/SATA-RAID Controller device driver for Linux v=
3.26.02.000.
[   30.658277] ppa: Version 2.07 (for Linux 2.4.x)
[   33.614599] RocketRAID 3xxx/4xxx Controller driver v1.8
[   35.446609] stex: Promise SuperTrak EX Driver version: 4.6.0000.4
[   35.790858] Broadcom NetXtreme II iSCSI Driver bnx2i v2.7.2.2 (Apr 25, 2=
012)
[   36.116120] iscsi: registered transport (bnx2i)
[   36.378527] VMware PVSCSI driver - version 1.0.2.0-k
[   36.802527] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[   37.125105] osst :I: Tape driver with OnStream support version 0.99.4
[   37.125105] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[   37.634304] SCSI Media Changer driver v0.25=20
[   37.892972] no cont in shutdown!
[   38.284734] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[   38.843019] HSI/SSI char device loaded
[   39.162077] bonding: Ethernet Channel Bonding Driver: v3.7.1 (April 27, =
2011)
[   39.435682] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S.=
 Miller (davem@redhat.com)
[   39.966842] libphy: Fixed MDIO Bus: probed
[   40.237368] Atheros(R) L2 Ethernet Driver - version 2.2.3
[   40.502287] Copyright (c) 2007 Atheros Corporation.
[   40.773744] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.16 (Dec 05=
, 2012)
[   41.954486] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ether=
net Driver bnx2x 1.78.17-0 (2013/04/11)
[   43.150021] enic: Cisco VIC Ethernet NIC Driver, ver 2.1.1.39
[   43.423867] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[   43.679621] e100: Copyright(c) 1999-2006 Intel Corporation
[   43.934863] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-=
NAPI
[   44.297710] e1000: Copyright (c) 1999-2006 Intel Corporation.
[   44.712978] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[   45.121121] PCI: setting IRQ 11 as level-triggered
[   45.407538] e1000 0000:00:03.0: setting latency timer to 64
[   45.686040] ------------[ cut here ]------------
[   45.975060] WARNING: CPU: 0 PID: 76 at drivers/block/floppy.c:968 schedu=
le_bh+0x47/0x80()
[   47.312537] CPU: 0 PID: 76 Comm: kworker/u2:1 Not tainted 3.11.0-rc7-000=
25-gb22ce27 #8
[   47.848171] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
Bochs 01/01/2011
[   48.433222] Workqueue: events_unbound async_run_entry_fn
[   48.725491]  00000000 d25d7e0c c2745b10 d25d7e3c c105472d c2ff0b10 00000=
000 0000004c
[   49.494639]  c30df57c 000003c8 c1a2fb57 c1a2fb57 00000001 c1a33aa0 c39a0=
ca0 d25d7e4c
[   51.548252]  c1054812 00000009 00000000 d25d7e5c c1a2fb57 00000000 00000=
000 d25d7e84
[   56.319716] Call Trace:
[   58.164457]  [<c2745b10>] dump_stack+0x16/0x18
[   61.355641]  [<c105472d>] warn_slowpath_common+0x8d/0xb0
[   61.822789]  [<c1a2fb57>] ? schedule_bh+0x47/0x80
[   62.103589]  [<c1a2fb57>] ? schedule_bh+0x47/0x80
[   62.538170]  [<c1a33aa0>] ? floppy_hardint+0x1a0/0x1a0
[   62.920432]  [<c1054812>] warn_slowpath_null+0x22/0x30
[   63.411821]  [<c1a2fb57>] schedule_bh+0x47/0x80
[   66.271423]  [<c1a33ed5>] wait_til_done+0x15/0x230
[   71.033237]  [<c1063260>] ? cascade+0xa0/0xa0
[   75.990887]  [<c1a348d7>] user_reset_fdc+0xa7/0x110
[   78.921153]  [<c384c939>] floppy_async_init+0x9ee/0x1263
[   83.512228]  [<c108a0e4>] async_run_entry_fn+0x44/0x1e0
[   85.519262]  [<c16901b2>] ? __list_del_entry+0x202/0x220
[   87.120223]  [<c1075687>] ? pwq_dec_nr_in_flight+0x137/0x140
[   89.499077]  [<c1075f5b>] process_one_work+0x33b/0x840
[   90.274017]  [<c108f542>] ? ttwu_do_wakeup+0x12/0x90
[   91.294072]  [<c16901b2>] ? __list_del_entry+0x202/0x220
[   91.634105]  [<c1076874>] worker_thread+0x414/0x890
[   91.994817]  [<c1076460>] ? process_one_work+0x840/0x840
[   92.265965]  [<c1080ba6>] kthread+0xa6/0xb0
[   92.658144]  [<c2763f57>] ret_from_kernel_thread+0x1b/0x28
[   92.971880]  [<c1080b00>] ? __kthread_unpark+0x70/0x70
[   93.254541] ---[ end trace 857f8343e4eb716b ]---
[   93.508601] floppy0: no floppy controllers found
[   93.763265] work still pending
[   94.318578] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56
[   94.557614] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
[   94.791213] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[   95.021682] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[   95.254756] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.=
3-k
[   95.503720] igb: Copyright (c) 2007-2013 Intel Corporation.
[   95.745052] igbvf: Intel(R) Gigabit Virtual Function Network Driver - ve=
rsion 2.0.2-k
[   96.239386] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[   96.521620] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - vers=
ion 3.13.10-k
[   97.063498] ixgbe: Copyright (c) 1999-2013 Intel Corporation.
[   97.355608] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2=
-NAPI
[   97.639478] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[   97.921158] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[   98.200182] pch_gbe: EG20T PCH Gigabit Ethernet Driver - version 1.01
[   98.469150] atp.c:v1.09=3Dac 2002/10/01 Donald Becker <becker@scyld.com>
[   98.740423] Solarflare NET driver v3.2
[   99.014989] NET3 PLIP version 2.4-parport gniibe@mri.co.jp
[   99.412125] plip0: Parallel port at 0x378, using IRQ 7.
[   99.679184] PPP generic driver version 2.4.2
[   99.935786] PPP Deflate Compression module registered
[  100.169965] PPP MPPE Compression module registered
[  100.405789] hdlc: HDLC support module revision 1.22
[  100.640303] DLCI driver v0.35, 4 Jan 1997, mike.mclagan@linux.org.
[  101.213025] VMware vmxnet3 virtual NIC driver - version 1.1.30.0-k-NAPI
[  101.929352] Fusion MPT base driver 3.04.20
[  102.242401] Copyright (c) 1999-2008 LSI Corporation
[  102.482196] Fusion MPT FC Host driver 3.04.20
[  102.725663] Fusion MPT SAS Host driver 3.04.20
[  103.208266] Fusion MPT misc device (ioctl) driver 3.04.20
[  104.055770] mptctl: Registered with Fusion MPT base driver
[  105.217926] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[  106.405504] aoe: AoE v83 initialised.
[  108.188744] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[  109.158846] serio: i8042 KBD port at 0x60,0x64 irq 1
[  109.850636] serio: i8042 AUX port at 0x60,0x64 irq 12
[  111.803543] parport0: cannot grant exclusive access for device parkbd
[  113.805335] mousedev: PS/2 mouse device common for all mice
[  114.639765] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[  115.108558] mk712: device not present
[  115.336050] i2c /dev entries driver
[  116.391847] i2c-parport-light: adapter type unspecified
[  118.713167] isa i2c-pca-isa.0: Please specify I/O base
[  120.943533] m2m-testdev m2m-testdev.0: Device registered as /dev/video0
[  121.176051] saa7146: register extension 'Multimedia eXtension Board'
[  121.412676] saa7146: register extension 'hexium HV-PCI6 Orion'
[  121.649027] saa7146: register extension 'hexium gemini'
[  123.128577] Zoran MJPEG board driver version 0.10.1
[  127.384608] Linux video codec intermediate layer: v0.2
[  129.195841] cx25821: driver version 0.0.106 loaded
[  131.849627] Colour QuickCam for Video4Linux v0.06
[  134.104665] PMS: not enabled, use pms.enable=3D1 to probe
[  134.336634] pps pps0: new PPS source ktimer
[  134.574072] pps pps0: ktimer PPS source registered
[  134.809084] pps_ldisc: PPS line discipline registered
[  135.041159] pps_parport: parallel port PPS client
[  135.275774] parport0: cannot grant exclusive access for device pps_parpo=
rt
[  135.513499] pps_parport: couldn't register with parport0
[  135.756644] Driver for 1-wire Dallas network protocol.
[  136.051954] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[  136.298541] power_supply test_ac: uevent
[  136.540336] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[  136.776157] power_supply test_ac: prop ONLINE=3D1
[  137.004006] power_supply test_ac: power_supply_changed
[  137.227180] power_supply test_battery: uevent
[  137.444303] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[  137.659721] power_supply test_battery: prop STATUS=3DDischarging
[  137.862071] power_supply test_battery: prop CHARGE_TYPE=3DFast
[  138.064405] power_supply test_battery: prop HEALTH=3DGood
[  138.259275] power_supply test_battery: prop PRESENT=3D1
[  138.463806] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[  138.655219] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[  138.835481] power_supply test_battery: prop CHARGE_FULL=3D100
[  139.014542] power_supply test_battery: prop CHARGE_NOW=3D50
[  139.178817] power_supply test_battery: prop CAPACITY=3D50
[  139.345906] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[  139.510179] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[  139.673086] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[  139.827928] power_supply test_battery: prop MODEL_NAME=3DTest battery
[  139.984044] power_supply test_battery: prop MANUFACTURER=3DLinux
[  140.131323] power_supply test_battery: prop SERIAL_NUMBER=3D3.11.0-rc7-0=
0025-gb22ce27
[  140.425564] power_supply test_battery: prop TEMP=3D26
[  140.579369] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[  140.724386] power_supply test_battery: power_supply_changed
[  140.871930] power_supply test_usb: uevent
[  141.009612] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[  141.145245] power_supply test_usb: prop ONLINE=3D1
[  141.282007] power_supply test_usb: power_supply_changed
[  141.409004] applesmc: supported laptop not found!
[  141.539259] applesmc: driver init failed (ret=3D-19)!
[  141.669401] pc87360: PC8736x not detected, module not inserted
[  141.807373] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[  142.098931] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[  142.431203] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[  142.799645] power_supply test_ac: power_supply_changed_work
[  145.201212] power_supply test_ac: uevent
[  149.891369] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[  151.919659] power_supply test_ac: prop ONLINE=3D1
[  154.137219] device-mapper: uevent: version 1.0.3
[  155.280921] device-mapper: ioctl: 4.25.0-ioctl (2013-06-26) initialised:=
 dm-devel@redhat.com
[  156.104628] device-mapper: multipath: version 1.5.1 loaded
[  156.788263] device-mapper: multipath round-robin: version 1.0.0 loaded
[  157.568059] device-mapper: multipath queue-length: version 0.1.0 loaded
[  158.023321] device-mapper: multipath service-time: version 0.2.0 loaded
[  158.472328] device-mapper: dm-log-userspace: version 1.1.0 loaded
[  158.924452] Bluetooth: HCI UART driver ver 2.2
[  159.365352] Bluetooth: HCI BCSP protocol initialized
[  159.823133] Bluetooth: HCI Three-wire UART (H5) protocol initialized
[  160.490332] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[  161.230891] lguest: mapped switcher at fffdf000
[  161.831419] cpufreq-nforce2: No nForce2 chipset.
[  162.293738] cpuidle: using governor ladder
[  162.770148] cpuidle: using governor menu
[  163.225430] sdhci: Secure Digital Host Controller Interface driver
[  163.698985] sdhci: Copyright(c) Pierre Ossman
[  164.343756] sdhci-pltfm: SDHCI platform and OF driver helper
[  164.696686] leds_ss4200: no LED devices found
[  164.932861] iscsi: registered transport (iser)
[  165.161618] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[  165.606067] hdaps: supported laptop not found!
[  165.830380] hdaps: driver init failed (ret=3D-19)!
[  166.038125] pktgen: Packet Generator for packet performance testing. Ver=
sion: 2.74
[  167.483623] drop_monitor: Initializing network drop monitor service
[  167.983316] GACT probability NOT on
[  168.701342] Mirror/redirect action on
[  170.848064] Simple TC action Loaded
[  171.319090] ipip: IPv4 over IPv4 tunneling driver
[  171.550676] TCP: cubic registered
[  171.788791] NET: Registered protocol family 10
[  172.029122] mip6: Mobile IPv6
[  172.509359] sit: IPv6 over IPv4 tunneling driver
[  173.218637] NET: Registered protocol family 17
[  173.973897] NET: Registered protocol family 15
[  174.693625] NET: Registered protocol family 4
[  175.613575] Bluetooth: RFCOMM socket layer initialized
[  176.831077] Bluetooth: RFCOMM ver 1.11
[  177.285107] NET: Registered protocol family 33
[  177.544827] Key type rxrpc registered
[  178.090192] Key type rxrpc_s registered
[  178.647418] RxRPC: Registered security type 2 'rxkad'
[  183.388355] l2tp_core: L2TP core driver, V2.0
[  187.090339] l2tp_ip: L2TP IP encapsulation support (L2TPv3)
[  191.914998] l2tp_netlink: L2TP netlink interface
[  192.263345] l2tp_eth: L2TP ethernet pseudowire support (L2TPv3)
[  192.585156] l2tp_ip6: L2TP IP encapsulation support for IPv6 (L2TPv3)
[  192.826074] NET: Registered protocol family 35
[  193.060267] 8021q: 802.1Q VLAN Support v1.8
[  193.414000] DCCP: Activated CCID 2 (TCP-like)
[  193.631261] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
[  193.858969] sctp: Hash tables configured (established 16384 bind 32768)
[  194.081393] 9pnet: Installing 9P2000 support
[  194.297914] power_supply test_battery: power_supply_changed_work
[  194.618020] power_supply test_battery: uevent
[  194.967047] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[  195.323112] power_supply test_battery: prop STATUS=3DDischarging
[  195.571073] power_supply test_battery: prop CHARGE_TYPE=3DFast
[  196.457490] power_supply test_battery: prop HEALTH=3DGood
[  196.779872] power_supply test_battery: prop PRESENT=3D1
[  196.975699] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[  197.160137] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[  197.345306] power_supply test_battery: prop CHARGE_FULL=3D100
[  197.523582] power_supply test_battery: prop CHARGE_NOW=3D50
[  197.715371] power_supply test_battery: prop CAPACITY=3D50
[  197.894118] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[  198.074766] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[  198.243756] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[  198.419307] power_supply test_battery: prop MODEL_NAME=3DTest battery
[  198.591847] power_supply test_battery: prop MANUFACTURER=3DLinux
[  198.763201] power_supply test_battery: prop SERIAL_NUMBER=3D3.11.0-rc7-0=
0025-gb22ce27
[  199.278185] power_supply test_battery: prop TEMP=3D26
[  199.650295] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[  200.001659] power_supply test_usb: power_supply_changed_work
[  200.362643] power_supply test_usb: uevent
[  200.654222] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[  200.905270] power_supply test_usb: prop ONLINE=3D1
[  201.105206] batman_adv: B.A.T.M.A.N. advanced 2013.3.0 (compatibility ve=
rsion 14) loaded
[  201.609970] openvswitch: Open vSwitch switching datapath
[  201.816022] mpls_gso: MPLS GSO support
[  201.968479] Key type encrypted registered
[  202.125484] hd: no drives specified - use hd=3Dcyl,head,sectors on kerne=
l command line
[  202.450858] console [netcon0] enabled
[  202.700588] netconsole: network logging started
[  203.061744] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[  203.433234] EDD information not available.
[  203.818445] ### dt-test ### No testcase data in device tree; not running=
 tests
[  204.640393] Freeing unused kernel memory: 1236K (c37ed000 - c3922000)
[  205.112685] Write protecting the kernel text: 23960k
[  205.835125] Write protecting the kernel read-only data: 10684k
[  208.162670] S00fbsetup (142) used greatest stack depth: 6312 bytes left
[  213.447089] udevd (154) used greatest stack depth: 6164 bytes left
[  215.803840] power_supply test_ac: uevent
[  221.457412] power_supply test_ac: POWER_SUPPLY_NAME=3Dtest_ac
[  225.065535] power_supply test_ac: prop ONLINE=3D1
[  227.809922] power_supply test_battery: uevent
[  230.389223] power_supply test_battery: POWER_SUPPLY_NAME=3Dtest_battery
[  232.635544] power_supply test_battery: prop STATUS=3DDischarging
[  233.813673] power_supply test_battery: prop CHARGE_TYPE=3DFast
[  234.538548] power_supply test_battery: prop HEALTH=3DGood
[  234.973575] power_supply test_battery: prop PRESENT=3D1
[  235.499319] power_supply test_battery: prop TECHNOLOGY=3DLi-ion
[  238.193769] power_supply test_battery: prop CHARGE_FULL_DESIGN=3D100
[  238.500316] power_supply test_battery: prop CHARGE_FULL=3D100
[  238.709805] power_supply test_battery: prop CHARGE_NOW=3D50
[  239.556096] power_supply test_battery: prop CAPACITY=3D50
[  239.844290] power_supply test_battery: prop CAPACITY_LEVEL=3DNormal
[  240.037437] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3D3600
[  240.227254] power_supply test_battery: prop TIME_TO_FULL_NOW=3D3600
[  240.405022] power_supply test_battery: prop MODEL_NAME=3DTest battery
[  240.590300] power_supply test_battery: prop MANUFACTURER=3DLinux
[  240.765947] power_supply test_battery: prop SERIAL_NUMBER=3D3.11.0-rc7-0=
0025-gb22ce27
[  241.103464] power_supply test_battery: prop TEMP=3D26
[  241.277083] power_supply test_battery: prop VOLTAGE_NOW=3D3300
[  241.447180] power_supply test_usb: uevent
[  241.622719] power_supply test_usb: POWER_SUPPLY_NAME=3Dtest_usb
[  241.792301] power_supply test_usb: prop ONLINE=3D1
Kernel tests: Boot OK!
[  270.616351] hrtimer: interrupt took 8174272 ns
[  307.660141] sock: process `trinity-main' is using obsolete setsockopt SO=
_BSDCOMPAT
[  336.938833] trinity-main (354) used greatest stack depth: 5964 bytes left
[  347.155504] Unregister pv shared memory for cpu 0
[  348.828491] reboot: Restarting system
[  348.830165] reboot: machine restart
Elapsed time: 350
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-c=
1-07070935/b22ce2785d97423846206cceec4efee0c4afd980/vmlinuz-3.11.0-rc7-0002=
5-gb22ce27 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug ap=
ic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=
=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kb=
uild-tests/run-queue/kvm/i386-randconfig-c1-07070935/linux-devel:devel-hour=
ly-2014070708:b22ce2785d97423846206cceec4efee0c4afd980:bisect-linux3/.vmlin=
uz-b22ce2785d97423846206cceec4efee0c4afd980-20140707154539-120-ivb41 branch=
=3Dlinux-devel/devel-hourly-2014070708 BOOT_IMAGE=3D/kernel/i386-randconfig=
-c1-07070935/b22ce2785d97423846206cceec4efee0c4afd980/vmlinuz-3.11.0-rc7-00=
025-gb22ce27 drbd.minor_count=3D8'  -initrd /kernel-tests/initrd/yocto-mini=
mal-i386.cgz -m 320 -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=
=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -=
pidfile /dev/shm/kboot/pid-yocto-ivb41-99 -serial file:/dev/shm/kboot/seria=
l-yocto-ivb41-99 -daemonize -display none -monitor null=20

--HcAYCG3uE/tztfnV
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-c1-07070935-98610962bbb418f6d847c402637ca14e78c38344-WARNING:---at----schedule_bh+-x-71922.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgOTg2MTA5Ni4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1o
b3VybHktMjAxNDA3MDcwOCcKZ2l0IGNoZWNrb3V0IGNkM2RlODNmMTQ3NjAxMzU2Mzk1YjU3
YTg2NzNlOWM1ZmYxZTU5ZDEKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kz
ODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAx
NDA3MDcwODpjZDNkZTgzZjE0NzYwMTM1NjM5NWI1N2E4NjczZTljNWZmMWU1OWQxOmJpc2Vj
dC1saW51eDMKCjIwMTQtMDctMDctMTA6NTY6NTAgY2QzZGU4M2YxNDc2MDEzNTYzOTViNTdh
ODY3M2U5YzVmZjFlNTlkMSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUtY2QzZGU4
M2YxNDc2MDEzNTYzOTViNTdhODY3M2U5YzVmZjFlNTlkMQpDaGVjayBmb3Iga2VybmVsIGlu
IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1L2NkM2RlODNmMTQ3NjAxMzU2
Mzk1YjU3YTg2NzNlOWM1ZmYxZTU5ZDEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS1jZDNk
ZTgzZjE0NzYwMTM1NjM5NWI1N2E4NjczZTljNWZmMWU1OWQxCndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9jYWlyby1zbW9rZS9pMzg2LXJh
bmRjb25maWctYzEtMDcwNzA5MzUtY2QzZGU4M2YxNDc2MDEzNTYzOTViNTdhODY3M2U5YzVm
ZjFlNTlkMQprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1L2Nk
M2RlODNmMTQ3NjAxMzU2Mzk1YjU3YTg2NzNlOWM1ZmYxZTU5ZDEvdm1saW51ei0zLjE2LjAt
cmM0CgoyMDE0LTA3LTA3LTExOjAyOjUwIGRldGVjdGluZyBib290IHN0YXRlIC4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uCTE4LgkyNAkzMgk0Mwk0OQk1NS4JNjAgVEVTVCBGQUlM
VVJFClsgICAzOC40MjEzNTddIElPQVBJQ1swXTogU2V0IHJvdXRpbmcgZW50cnkgKDAtMTEg
LT4gMHgzYiAtPiBJUlEgMTEgTW9kZToxIEFjdGl2ZTowIERlc3Q6MSkKWyAgIDM5LjE3NzA2
NV0gbm8gY29udCBpbiBzaHV0ZG93biEKWyAgIDQwLjEwNjIwNF0gLS0tLS0tLS0tLS0tWyBj
dXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICA0MC41Njk0NThdIFdBUk5JTkc6IENQVTogMCBQ
SUQ6IDgyIGF0IC9rYnVpbGQvc3JjL3Ntb2tlL2RyaXZlcnMvYmxvY2svZmxvcHB5LmM6OTc1
IHNjaGVkdWxlX2JoKzB4NDcvMHg4MCgpClsgICA0MS40NjcwMjBdIENQVTogMCBQSUQ6IDgy
IENvbW06IGt3b3JrZXIvdTI6MSBOb3QgdGFpbnRlZCAzLjE2LjAtcmM0ICMxClsgICA0MS44
MDc5NjBdIEhhcmR3YXJlIG5hbWU6IFFFTVUgU3RhbmRhcmQgUEMgKGk0NDBGWCArIFBJSVgs
IDE5OTYpLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgIDQyLjcwNDIzNl0gV29ya3F1ZXVl
OiBldmVudHNfdW5ib3VuZCBhc3luY19ydW5fZW50cnlfZm4KWyAgIDQzLjE4Mjg1Ml0gIDAw
MDAwMDAwIGNjYWQ5ZTE4IGMyOTFjMDBjIGNjYWQ5ZTQ4IGMxMDYxYTNkIGMzMjljZmE0IDAw
MDAwMDAwIDAwMDAwMDUyClsgICA0NC4xODM0ODFdICBjMzM5N2EzYyAwMDAwMDNjZiBjMWFk
ZTI4NyBjMWFkZTI4NyAwMDAwMDAwMSBjMWFkZmE5MCBjM2QwMTE2MCBjY2FkOWU1OApbICAg
NDQuOTg2NjQxXSAgYzEwNjFiMjIgMDAwMDAwMDkgMDAwMDAwMDAgY2NhZDllNjggYzFhZGUy
ODcgMDAwMDAwMDAgMDAwMDAwMDAgY2NhZDllODgKWyAgIDQ1LjYxNDk2NV0gQ2FsbCBUcmFj
ZToKWyAgIDQ1LjkxMDYwNl0gIFs8YzI5MWMwMGM+XSBkdW1wX3N0YWNrKzB4MTYvMHgxOApb
ICAgNDYuMjA5MzkwXSAgWzxjMTA2MWEzZD5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4OGQv
MHhiMApbICAgNDYuNTA5NTM5XSAgWzxjMWFkZTI4Nz5dID8gc2NoZWR1bGVfYmgrMHg0Ny8w
eDgwClsgICA0Ni43OTkxMzZdICBbPGMxYWRlMjg3Pl0gPyBzY2hlZHVsZV9iaCsweDQ3LzB4
ODAKWyAgIDQ3LjA4NjQ3MF0gIFs8YzFhZGZhOTA+XSA/IGxvY2tfZmRjLmlzcmEuMTIrMHgx
YjAvMHgxYjAKWyAgIDQ3LjQ4MjQzNF0gIFs8YzEwNjFiMjI+XSB3YXJuX3Nsb3dwYXRoX251
bGwrMHgyMi8weDMwClsgICA0Ny45MTgzNTBdICBbPGMxYWRlMjg3Pl0gc2NoZWR1bGVfYmgr
MHg0Ny8weDgwClsgICA0OC4zMzYwNTNdICBbPGMxYWRmZWIzPl0gd2FpdF90aWxfZG9uZSsw
eDEzLzB4MjAwClsgICA0OC43MTQzMzNdICBbPGMxMDZmZDQwPl0gPyBjYXNjYWRlKzB4YTAv
MHhhMApbICAgNDkuMTM3Mzk3XSAgWzxjMWFlMDc3Nz5dIHVzZXJfcmVzZXRfZmRjKzB4YTcv
MHgxMTAKWyAgIDQ5LjYyNTE5Nl0gIFs8YzNiYjY2MDk+XSBmbG9wcHlfYXN5bmNfaW5pdCsw
eDlkZS8weDEyNTYKWyAgIDUwLjA0MzQ2Nl0gIFs8YzEwOTQ5OTQ+XSBhc3luY19ydW5fZW50
cnlfZm4rMHg0NC8weDFkMApbICAgNTAuNDg3Nzk4XSAgWzxjMTZkMzMxMj5dID8gX19saXN0
X2RlbF9lbnRyeSsweDIwMi8weDIyMApbICAgNTAuOTA4ODE2XSAgWzxjMTA4MjUwZj5dID8g
cHdxX2RlY19ucl9pbl9mbGlnaHQrMHgxMGYvMHgxMzAKWyAgIDUxLjMwNDcwMl0gIFs8YzEw
ODJiNzI+XSBwcm9jZXNzX29uZV93b3JrKzB4MzIyLzB4ODAwClsgICA1MS42Nzg0MzddICBb
PGMxNmQzMzEyPl0gPyBfX2xpc3RfZGVsX2VudHJ5KzB4MjAyLzB4MjIwClsgICA1Mi4wNTky
NTRdICBbPGMxMDgzNjE0Pl0gd29ya2VyX3RocmVhZCsweDVjNC8weGIyMApbICAgNTIuNDA4
ODE4XSAgWzxjMTA4MzA1MD5dID8gcHJvY2Vzc19vbmVfd29yaysweDgwMC8weDgwMApbICAg
NTIuODQ4Nzg3XSAgWzxjMTA4YzE4Mj5dIGt0aHJlYWQrMHhlMi8weGYwClsgICA1My4xODYw
OTJdICBbPGMxMDgzMDUwPl0gPyBwcm9jZXNzX29uZV93b3JrKzB4ODAwLzB4ODAwClsgICA1
My41OTcwNTRdICBbPGMyOTNhODYwPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDIwLzB4
MzAKWyAgIDUzLjk1NzUyMl0gIFs8YzEwOGMwYTA+XSA/IF9fa3RocmVhZF91bnBhcmsrMHg3
MC8weDcwClsgICA1NC4zNTIzMzJdIC0tLVsgZW5kIHRyYWNlIGZlNzFhY2U0ZDQ5N2U1YmYg
XS0tLQpbICAgNTUuMTk1MDMzXSBlMTAwMCAwMDAwOjAwOjAzLjAgZXRoMDogKFBDSTozM01I
ejozMi1iaXQpIDUyOjU0OjAwOjEyOjM0OjU2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMx
LTA3MDcwOTM1L2NkM2RlODNmMTQ3NjAxMzU2Mzk1YjU3YTg2NzNlOWM1ZmYxZTU5ZDEvZG1l
c2ctcXVhbnRhbC1pdmI0My0zODoyMDE0MDcwNzExMTkyNTppMzg2LXJhbmRjb25maWctYzEt
MDcwNzA5MzU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS9jZDNkZTgz
ZjE0NzYwMTM1NjM5NWI1N2E4NjczZTljNWZmMWU1OWQxL2RtZXNnLXF1YW50YWwtaXZiNDMt
MzY6MjAxNDA3MDcxMTE5MzE6aTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1OjoKNjI6Mjox
IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA3LTA3IDExOjIxOjUy
IFJFUEVBVCBDT1VOVDogMzAwICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4My9vYmotYmlzZWN0
Ly5yZXBlYXQbWzBtCgpiaXNlY3Q6IGJhZCBjb21taXQgY2QzZGU4M2YxNDc2MDEzNTYzOTVi
NTdhODY3M2U5YzVmZjFlNTlkMQpnaXQgY2hlY2tvdXQgdjMuMTUKbHMgLWEgL2tidWlsZC10
ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS9saW51eC1k
ZXZlbDpkZXZlbC1ob3VybHktMjAxNDA3MDcwODoxODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4
YWVkZGZmZTVhZmQ5ZDBkOmJpc2VjdC1saW51eDMKCjIwMTQtMDctMDctMTE6MjE6NTggMTg2
MGUzNzk4NzVkZmU3MjcxYzY0OTA1OGFlZGRmZmU1YWZkOWQwZCBjb21waWxpbmcKUXVldWVk
IGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25m
aWctYzEtMDcwNzA5MzUtMTg2MGUzNzk4NzVkZmU3MjcxYzY0OTA1OGFlZGRmZmU1YWZkOWQw
ZApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcw
OTM1LzE4NjBlMzc5ODc1ZGZlNzI3MWM2NDkwNThhZWRkZmZlNWFmZDlkMGQKd2FpdGluZyBm
b3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNv
bmZpZy1jMS0wNzA3MDkzNS0xODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVkZGZmZTVhZmQ5
ZDBkCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1
ZS9jYWlyby1zbW9rZS9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUtMTg2MGUzNzk4NzVk
ZmU3MjcxYzY0OTA1OGFlZGRmZmU1YWZkOWQwZAprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWMxLTA3MDcwOTM1LzE4NjBlMzc5ODc1ZGZlNzI3MWM2NDkwNThhZWRkZmZlNWFm
ZDlkMGQvdm1saW51ei0zLjE1LjAKCjIwMTQtMDctMDctMTE6Mjg6NTggZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgLi4uLi4uLi4uCTMJMTAgVEVTVCBGQUlMVVJFClsgICA0MC44NTMxMjVdIElP
QVBJQ1swXTogU2V0IHJvdXRpbmcgZW50cnkgKDAtMTEgLT4gMHgzYiAtPiBJUlEgMTEgTW9k
ZToxIEFjdGl2ZTowIERlc3Q6MSkKWyAgIDQxLjgzNzczOF0gbm8gY29udCBpbiBzaHV0ZG93
biEKWyAgIDQyLjMzMjkyOF0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0t
ClsgICA0Mi43NDgxNTVdIFdBUk5JTkc6IENQVTogMCBQSUQ6IDgyIGF0IC9rYnVpbGQvc3Jj
L3Ntb2tlL2RyaXZlcnMvYmxvY2svZmxvcHB5LmM6OTc1IHNjaGVkdWxlX2JoKzB4NDcvMHg4
MCgpClsgICA0My45NTY3MjldIENQVTogMCBQSUQ6IDgyIENvbW06IGt3b3JrZXIvdTI6MSBO
b3QgdGFpbnRlZCAzLjE1LjAgIzEKWyAgIDQ0LjU1MzcyOF0gSGFyZHdhcmUgbmFtZTogUUVN
VSBTdGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5NiksIEJJT1MgQm9jaHMgMDEvMDEv
MjAxMQpbICAgNDUuNzUwODUyXSBXb3JrcXVldWU6IGV2ZW50c191bmJvdW5kIGFzeW5jX3J1
bl9lbnRyeV9mbgpbICAgNDYuMzkxNzg0XSAgMDAwMDAwMDAgYzAxYWJlMTQgYzI5MGI0OGIg
YzAxYWJlNDQgYzEwNjEyMWQgYzMyNzJjYzQgMDAwMDAwMDAgMDAwMDAwNTIKWyAgIDQ3LjUy
NDA4Ml0gIGMzMzZhN2U0IDAwMDAwM2NmIGMxYWM4MDc3IGMxYWM4MDc3IDAwMDAwMDAxIGMx
YWM5ODgwIGMzY2UzYjIwIGMwMWFiZTU0ClsgICA0OC4yMjMzMzZdICBjMTA2MTMwMiAwMDAw
MDAwOSAwMDAwMDAwMCBjMDFhYmU2NCBjMWFjODA3NyAwMDAwMDAwMCAwMDAwMDAwMCBjMDFh
YmU4NApbICAgNDkuMDY5MzQ4XSBDYWxsIFRyYWNlOgpbICAgNDkuNTA4NTg3XSAgWzxjMjkw
YjQ4Yj5dIGR1bXBfc3RhY2srMHgxNi8weDE4ClsgICA0OS45NDg1MDVdICBbPGMxMDYxMjFk
Pl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg4ZC8weGIwClsgICA1MC41NTczOTddICBbPGMx
YWM4MDc3Pl0gPyBzY2hlZHVsZV9iaCsweDQ3LzB4ODAKWyAgIDUxLjEzNDE4Nl0gIFs8YzFh
YzgwNzc+XSA/IHNjaGVkdWxlX2JoKzB4NDcvMHg4MApbICAgNTEuNjg0MDg3XSAgWzxjMWFj
OTg4MD5dID8gbG9ja19mZGMuaXNyYS4xMisweDFiMC8weDFiMApbICAgNTIuMDgwMDQ0XSAg
WzxjMTA2MTMwMj5dIHdhcm5fc2xvd3BhdGhfbnVsbCsweDIyLzB4MzAKWyAgIDUyLjM3NTcz
Nl0gIFs8YzFhYzgwNzc+XSBzY2hlZHVsZV9iaCsweDQ3LzB4ODAKWyAgIDUyLjgzMDIzOF0g
IFs8YzFhYzljYTM+XSB3YWl0X3RpbF9kb25lKzB4MTMvMHgyMDAKWyAgIDUzLjMwMTkyN10g
IFs8YzEwNmY0MDA+XSA/IGNhc2NhZGUrMHhhMC8weGEwClsgICA1My44MzYyNzddICBbPGMx
YWNhNTY3Pl0gdXNlcl9yZXNldF9mZGMrMHhhNy8weDExMApbICAgNTQuNDEwNjI5XSAgWzxj
M2I3YWQxNj5dIGZsb3BweV9hc3luY19pbml0KzB4OWRlLzB4MTI1NgpbICAgNTQuODQ3MTYx
XSAgWzxjMTA5NDIwND5dIGFzeW5jX3J1bl9lbnRyeV9mbisweDQ0LzB4MWQwClsgICA1NS4y
NTkwNzNdICBbPGMxNmM1YjAyPl0gPyBfX2xpc3RfZGVsX2VudHJ5KzB4MjAyLzB4MjIwClsg
ICA1NS42OTMxNzldICBbPGMxMDgxZmJmPl0gPyBwd3FfZGVjX25yX2luX2ZsaWdodCsweDEw
Zi8weDEzMApbICAgNTYuMjMwNDMxXSAgWzxjMTA4MjYyMj5dIHByb2Nlc3Nfb25lX3dvcmsr
MHgzMjIvMHg4MDAKWyAgIDU2Ljc3MDg2NV0gIFs8YzE2YzViMDI+XSA/IF9fbGlzdF9kZWxf
ZW50cnkrMHgyMDIvMHgyMjAKWyAgIDU3LjMwNjMxMl0gIFs8YzEwODJlZmM+XSB3b3JrZXJf
dGhyZWFkKzB4M2ZjLzB4ODcwClsgICA1Ny44NDQ4NDRdICBbPGMxMDgyYjAwPl0gPyBwcm9j
ZXNzX29uZV93b3JrKzB4ODAwLzB4ODAwClsgICA1OC41Mzg0MzRdICBbPGMxMDhiOWYyPl0g
a3RocmVhZCsweGUyLzB4ZjAKWyAgIDU5LjIyNjY2OF0gIFs8YzEwODJiMDA+XSA/IHByb2Nl
c3Nfb25lX3dvcmsrMHg4MDAvMHg4MDAKWyAgIDU5Ljg1MDYyMV0gIFs8YzI5MmFhZTA+XSBy
ZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MjAvMHgzMApbICAgNjAuNTUyNTA2XSAgWzxjMTA4
YjkxMD5dID8gX19rdGhyZWFkX3VucGFyaysweDcwLzB4NzAKWyAgIDYxLjE3Mzc3M10gLS0t
WyBlbmQgdHJhY2UgYzc0NzQyOTY0YTU3ZDBhMSBdLS0tClsgICA2Mi40NjMxNzddIHNwaW5f
bG9jay10b3J0dXJlOiBXcml0ZXM6ICBUb3RhbDogMiAgTWF4L01pbjogMC8wICAgRmFpbDog
MCAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUvMTg2MGUzNzk4NzVkZmU3
MjcxYzY0OTA1OGFlZGRmZmU1YWZkOWQwZC9kbWVzZy1xdWFudGFsLWl2YjQzLTEwODoyMDE0
MDcwNzExMzIwMjppMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzU6Ogova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1jMS0wNzA3MDkzNS8xODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVkZGZm
ZTVhZmQ5ZDBkL2RtZXNnLXF1YW50YWwtaXZiNDMtNzA6MjAxNDA3MDcxMTMxNTc6aTM4Ni1y
YW5kY29uZmlnLWMxLTA3MDcwOTM1OjoKMTA6MjoyIGFsbF9nb29kOmJhZDphbGxfYmFkIGJv
b3RzCgpiaXNlY3Q6IGJhZCBjb21taXQgdjMuMTUKZ2l0IGNoZWNrb3V0IHYzLjE0CmxzIC1h
IC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5
MzUvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNzA3MDg6NDU1YzZmZGJkMjE5MTYx
YmQwOWIxMTY1ZjExNjk5ZDZkNzNkZTExYzpiaXNlY3QtbGludXgzCgoyMDE0LTA3LTA3LTEx
OjM0OjM0IDQ1NWM2ZmRiZDIxOTE2MWJkMDliMTE2NWYxMTY5OWQ2ZDczZGUxMWMgY29tcGls
aW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4
Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1LTQ1NWM2ZmRiZDIxOTE2MWJkMDliMTE2NWYxMTY5
OWQ2ZDczZGUxMWMKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1jMS0wNzA3MDkzNS80NTVjNmZkYmQyMTkxNjFiZDA5YjExNjVmMTE2OTlkNmQ3M2RlMTFj
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9p
Mzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUtNDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjEx
Njk5ZDZkNzNkZTExYwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUvamFrZXRvd24tY29uc3VtZXIvaTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcw
OTM1LTQ1NWM2ZmRiZDIxOTE2MWJkMDliMTE2NWYxMTY5OWQ2ZDczZGUxMWMKa2VybmVsOiAv
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS80NTVjNmZkYmQyMTkxNjFiZDA5
YjExNjVmMTE2OTlkNmQ3M2RlMTFjL3ZtbGludXotMy4xNC4wCgoyMDE0LTA3LTA3LTExOjQ2
OjM0IGRldGVjdGluZyBib290IHN0YXRlIC4uLi4uCTEuLgk2CTEyIFRFU1QgRkFJTFVSRQpb
ICAgIDMuNjcxMTEzXSB4el9kZWNfdGVzdDogQ3JlYXRlIGEgZGV2aWNlIG5vZGUgd2l0aCAn
bWtub2QgeHpfZGVjX3Rlc3QgYyAyNTAgMCcgYW5kIHdyaXRlIC54eiBmaWxlcyB0byBpdC4K
WyAgICAzLjY3NDIyNF0gcmJ0cmVlIHRlc3RpbmcgLT4gMjY5NDk4IGN5Y2xlcwpbICAgMTUu
OTYzMjAxXSBhdWdtZW50ZWQgcmJ0cmVlIHRlc3RpbmcKWyAgIDQwLjI1ODg3NV0gQlVHOiBz
b2Z0IGxvY2t1cCAtIENQVSMwIHN0dWNrIGZvciAyMnMhIFtzd2FwcGVyOjFdClsgICA0MC4y
NjE2NjldIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjE0LjAg
IzEKWyAgIDQwLjI2MjE5NF0gSGFyZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQQyAoaTQ0
MEZYICsgUElJWCwgMTk5NiksIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgNDAuMjYyMTk0
XSB0YXNrOiBkMjA1ODAwMCB0aTogZDIwNWMwMDAgdGFzay50aTogZDIwNWMwMDAKWyAgIDQw
LjI2MjE5NF0gRUlQOiAwMDYwOls8YzE2YzQ3Y2Y+XSBFRkxBR1M6IDAwMDAwMjQ2IENQVTog
MApbICAgNDAuMjYyMTk0XSBFSVAgaXMgYXQgX19yYl9pbnNlcnRfYXVnbWVudGVkKzB4OGYv
MHgyYjAKWyAgIDQwLjI2MjE5NF0gRUFYOiBjM2M1NjhiYyBFQlg6IGMzYzU2NTQ0IEVDWDog
YzNjNTY3Y2MgRURYOiAwMGVjN2UwMQpbICAgNDAuMjYyMTk0XSBFU0k6IDAwMDAwMDAxIEVE
STogMDA3NGRkMDkgRUJQOiBkMjA1ZGViYyBFU1A6IGQyMDVkZWE0ClsgICA0MC4yNjIxOTRd
ICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDAwMCBHUzogMDAwMCBTUzogMDA2OApbICAgNDAu
MjYyMTk0XSBDUjA6IDgwMDUwMDNiIENSMjogMDAwMDAwMDAgQ1IzOiAwM2JlMTAwMCBDUjQ6
IDAwMDAwNmQwClsgICA0MC4yNjIxOTRdIFN0YWNrOgpbICAgNDAuMjYyMTk0XSAgYzNjNTZh
ZTAgYzNjNTY5MWMgYzE2ZWViNDAgODhiMzFkY2IgYzNjNTY5MTggYzNjNTY3ZDAgZDIwNWRl
ZDQgYzI4ZDQ1MTUKWyAgIDQwLjI2MjE5NF0gIGMzYzU2OTE4IDAwMDAyNWM2IGMzYzU2OTMw
IDAwMDAwMDAwIGQyMDVkZjAwIGMzYWUwZjY1IGMzMjg4NzIxIDAwMDQxY2JhClsgICA0MC4y
NjIxOTRdICAwMDAwMDAwMCBkM2ZhMWU1YyA0MmEwMjk1YyAwMDAwMDAxNiBjM2FlMGRmNiBj
M2JhMzgwMCAwMDAwMDAwMCBkMjA1ZGY3MApbICAgNDAuMjYyMTk0XSBDYWxsIFRyYWNlOgpb
ICAgNDAuMjYyMTk0XSAgWzxjMTZlZWI0MD5dID8gYXVnbWVudF9yZWNvbXB1dGUrMHg5MC8w
eDkwClsgICA0MC4yNjIxOTRdICBbPGMyOGQ0NTE1Pl0gaW5zZXJ0X2F1Z21lbnRlZC5jb25z
dHByb3AuNisweDhmLzB4OTUKWyAgIDQwLjI2MjE5NF0gIFs8YzNhZTBmNjU+XSByYnRyZWVf
dGVzdF9pbml0KzB4MTZmLzB4MjU0ClsgICA0MC4yNjIxOTRdICBbPGMzYWUwZGY2Pl0gPyBl
cnJfaW5qZWN0X2luaXQrMHgzNi8weDM2ClsgICA0MC4yNjIxOTRdICBbPGMzYThhZTEwPl0g
ZG9fb25lX2luaXRjYWxsKzB4OGEvMHgxN2MKWyAgIDQwLjI2MjE5NF0gIFs8YzNhOGE1YjU+
XSA/IHJlcGFpcl9lbnZfc3RyaW5nKzB4MmEvMHg5OQpbICAgNDAuMjYyMTk0XSAgWzxjMTA4
YTFjNj5dID8gcGFyc2VfYXJncysweDMzNi8weDUwMApbICAgNDAuMjYyMTk0XSAgWzxjM2E4
YWZmND5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4ZjIvMHgxZGEKWyAgIDQwLjI2MjE5NF0g
IFs8YzNhOGE1OGI+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4YjUvMHhiNQpbICAgNDAuMjYyMTk0
XSAgWzxjMjhhZWU2MT5dIGtlcm5lbF9pbml0KzB4MTEvMHgxNjAKWyAgIDQwLjI2MjE5NF0g
IFs8YzEwOWNlNTc+XSA/IHNjaGVkdWxlX3RhaWwrMHgxNy8weDYwClsgICA0MC4yNjIxOTRd
ICBbPGMyOGYyZGY3Pl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDFiLzB4MjgKWyAgIDQw
LjI2MjE5NF0gIFs8YzI4YWVlNTA+XSA/IHJlc3RfaW5pdCsweDcwLzB4NzAKWyAgIDQwLjI2
MjE5NF0gQ29kZTogYzEgMGYgOTUgYzIgMGYgYjYgZjIgOGIgM2MgYjUgMTQgZjMgNmYgYzMg
ODMgYzcgMDEgODQgZDIgODkgM2MgYjUgMTQgZjMgNmYgYzMgMGYgODQgOGMgMDAgMDAgMDAg
ODUgYzAgMGYgODQgODQgMDEgMDAgMDAgZjYgMDAgMDEgPDBmPiA4NCA2YiAwMSAwMCAwMCBl
OSA3NiAwMSAwMCAwMCA4ZCBiNiAwMCAwMCAwMCAwMCA4YiA1NyAwOCAzMQpbICAgNDAuMjYy
MTk0XSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogc29mdGxvY2t1cDogaHVuZyB0YXNr
cwpbICAgNDAuMjYyMTk0XSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50
ZWQgMy4xNC4wICMxClsgICA0MC4yNjIxOTRdIEhhcmR3YXJlIG5hbWU6IFFFTVUgU3RhbmRh
cmQgUEMgKGk0NDBGWCArIFBJSVgsIDE5OTYpLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAg
IDQwLjI2MjE5NF0gIDAwMDAwMDAwIGQyMDVkZDgwIGMyOGQzNDRiIGQyMDVkZGEwIGMyOGIy
ZDcyIGMzMjE5NzVjIGMzYmVkZTAwIGMxNmM0N2E0ClsgICA0MC4yNjIxOTRdICBkMjA1ODAw
MCAwMDAwMDAwMCAwMDAwMDAwNyBkMjA1ZGRkMCBjMTBlNzkzYyBjMzIxODJlNyAwMDAwMDAw
MCAwMDAwMDAxNgpbICAgNDAuMjYyMTk0XSAgZDIwNTgyMmMgMDAwMDAwMDEgZDIwNWRlNjgg
MDAwMDAwMGYgYzM0MzIwMDAgMDAwMDAwMDAgYzEwZTc3OTAgZDIwNWRkZjQKWyAgIDQwLjI2
MjE5NF0gQ2FsbCBUcmFjZToKWyAgIDQwLjI2MjE5NF0gIFs8YzI4ZDM0NGI+XSBkdW1wX3N0
YWNrKzB4MTYvMHgxOApbICAgNDAuMjYyMTk0XSAgWzxjMjhiMmQ3Mj5dIHBhbmljKzB4YmEv
MHgyMmMKWyAgIDQwLjI2MjE5NF0gIFs8YzE2YzQ3YTQ+XSA/IF9fcmJfaW5zZXJ0X2F1Z21l
bnRlZCsweDY0LzB4MmIwClsgICA0MC4yNjIxOTRdICBbPGMxMGU3OTNjPl0gd2F0Y2hkb2df
dGltZXJfZm4rMHgxYWMvMHgyMzAKWyAgIDQwLjI2MjE5NF0gIFs8YzEwZTc3OTA+XSA/IHdh
dGNoZG9nX3Nob3VsZF9ydW4rMHgyMC8weDIwClsgICA0MC4yNjIxOTRdICBbPGMxMDkwZWE4
Pl0gX19ydW5faHJ0aW1lcisweGQ4LzB4MzAwClsgICA0MC4yNjIxOTRdICBbPGMxMGU3Nzkw
Pl0gPyB3YXRjaGRvZ19zaG91bGRfcnVuKzB4MjAvMHgyMApbICAgNDAuMjYyMTk0XSAgWzxj
MTA5MWYzOD5dIGhydGltZXJfaW50ZXJydXB0KzB4MWE4LzB4NDEwClsgICA0MC4yNjIxOTRd
ICBbPGMxMDNhMjc5Pl0gbG9jYWxfYXBpY190aW1lcl9pbnRlcnJ1cHQrMHg2OS8weDcwClsg
ICA0MC4yNjIxOTRdICBbPGMxMDY3MjRkPl0gPyBpcnFfZW50ZXIrMHgzZC8weDkwClsgICA0
MC4yNjIxOTRdICBbPGMyOGYzNTIxPl0gc21wX2FwaWNfdGltZXJfaW50ZXJydXB0KzB4MzEv
MHg1MApbICAgNDAuMjYyMTk0XSAgWzxjMjhmMjkyNj5dIGFwaWNfdGltZXJfaW50ZXJydXB0
KzB4MzIvMHgzOApbICAgNDAuMjYyMTk0XSAgWzxjMTZlMDAwMD5dID8gbG9uZ2VzdF9tYXRj
aCsweDJiMC8weDMyMApbICAgNDAuMjYyMTk0XSAgWzxjMTZjNDdjZj5dID8gX19yYl9pbnNl
cnRfYXVnbWVudGVkKzB4OGYvMHgyYjAKWyAgIDQwLjI2MjE5NF0gIFs8YzE2ZWViNDA+XSA/
IGF1Z21lbnRfcmVjb21wdXRlKzB4OTAvMHg5MApbICAgNDAuMjYyMTk0XSAgWzxjMjhkNDUx
NT5dIGluc2VydF9hdWdtZW50ZWQuY29uc3Rwcm9wLjYrMHg4Zi8weDk1ClsgICA0MC4yNjIx
OTRdICBbPGMzYWUwZjY1Pl0gcmJ0cmVlX3Rlc3RfaW5pdCsweDE2Zi8weDI1NApbICAgNDAu
MjYyMTk0XSAgWzxjM2FlMGRmNj5dID8gZXJyX2luamVjdF9pbml0KzB4MzYvMHgzNgpbICAg
NDAuMjYyMTk0XSAgWzxjM2E4YWUxMD5dIGRvX29uZV9pbml0Y2FsbCsweDhhLzB4MTdjClsg
ICA0MC4yNjIxOTRdICBbPGMzYThhNWI1Pl0gPyByZXBhaXJfZW52X3N0cmluZysweDJhLzB4
OTkKWyAgIDQwLjI2MjE5NF0gIFs8YzEwOGExYzY+XSA/IHBhcnNlX2FyZ3MrMHgzMzYvMHg1
MDAKWyAgIDQwLjI2MjE5NF0gIFs8YzNhOGFmZjQ+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsw
eGYyLzB4MWRhClsgICA0MC4yNjIxOTRdICBbPGMzYThhNThiPl0gPyBkb19lYXJseV9wYXJh
bSsweGI1LzB4YjUKWyAgIDQwLjI2MjE5NF0gIFs8YzI4YWVlNjE+XSBrZXJuZWxfaW5pdCsw
eDExLzB4MTYwClsgICA0MC4yNjIxOTRdICBbPGMxMDljZTU3Pl0gPyBzY2hlZHVsZV90YWls
KzB4MTcvMHg2MApbICAgNDAuMjYyMTk0XSAgWzxjMjhmMmRmNz5dIHJldF9mcm9tX2tlcm5l
bF90aHJlYWQrMHgxYi8weDI4ClsgICA0MC4yNjIxOTRdICBbPGMyOGFlZTUwPl0gPyByZXN0
X2luaXQrMHg3MC8weDcwClsgICA0MC4yNjIxOTRdIEtlcm5lbCBPZmZzZXQ6IDB4MCBmcm9t
IDB4YzEwMDAwMDAgKHJlbG9jYXRpb24gcmFuZ2U6IDB4YzAwMDAwMDAtMHhkNDdmZGZmZikK
WyAgIDQwLjI2MjE5NF0gUmVib290aW5nIGluIDEwIHNlY29uZHMuLgpFbGFwc2VkIHRpbWU6
IDYwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1LzQ1NWM2ZmRiZDIxOTE2
MWJkMDliMTE2NWYxMTY5OWQ2ZDczZGUxMWMvZG1lc2ctcXVhbnRhbC1pdmI0My0xMDE6MjAx
NDA3MDcxMTQ4NTc6aTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1OjoKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctYzEtMDcwNzA5MzUvNDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjExNjk5
ZDZkNzNkZTExYy9kbWVzZy1xdWFudGFsLWl2YjQzLTI2OjIwMTQwNzA3MTE0OTExOmkzODYt
cmFuZGNvbmZpZy1jMS0wNzA3MDkzNTo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA3
MDcwOTM1LzQ1NWM2ZmRiZDIxOTE2MWJkMDliMTE2NWYxMTY5OWQ2ZDczZGUxMWMvZG1lc2ct
cXVhbnRhbC1pdmI0My00OjIwMTQwNzA3MTE0OTE1OmkzODYtcmFuZGNvbmZpZy1jMS0wNzA3
MDkzNTo6CjExOjM6NCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKYmlzZWN0OiBiYWQg
Y29tbWl0IHYzLjE0CmdpdCBjaGVja291dCB2My4xMwpscyAtYSAva2J1aWxkLXRlc3RzL3J1
bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1L2xpbnV4LWRldmVsOmRl
dmVsLWhvdXJseS0yMDE0MDcwNzA4OmQ4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIx
MGYwZTY0YmU6YmlzZWN0LWxpbnV4MwoKMjAxNC0wNy0wNy0xMTo1MTo0MCBkOGVjMjZkN2Y4
Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQg
dGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1jMS0w
NzA3MDkzNS1kOGVjMjZkN2Y4Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlCkNoZWNr
IGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUvZDhl
YzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZQp3YWl0aW5nIGZvciBjb21w
bGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWMx
LTA3MDcwOTM1LWQ4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUKd2Fp
dGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2NhaXJv
LXNtb2tlL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS1kOGVjMjZkN2Y4Mjg3ZjU3ODhh
NDk0ZjU2ZTg4MTQyMTBmMGU2NGJlCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
YzEtMDcwNzA5MzUvZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZS92
bWxpbnV6LTMuMTMuMAoKMjAxNC0wNy0wNy0xMTo1NTo0MCBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAuLi4uLgkxCTIuLgk4IFRFU1QgRkFJTFVSRQpbICAgNzAuMDI4MTg1XSBBQ1BJOiBQQ0kg
SW50ZXJydXB0IExpbmsgW0xOS0NdIGVuYWJsZWQgYXQgSVJRIDExClsgICA3MC4yODE5Njdd
IElPQVBJQ1swXTogU2V0IHJvdXRpbmcgZW50cnkgKDAtMTEgLT4gMHgzYiAtPiBJUlEgMTEg
TW9kZToxIEFjdGl2ZTowIERlc3Q6MSkKWyAgIDcwLjc5OTQzMF0gLS0tLS0tLS0tLS0tWyBj
dXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICA3MS4xMTA5NzJdIFdBUk5JTkc6IENQVTogMCBQ
SUQ6IDc3IGF0IC9rYnVpbGQvc3JjL3Ntb2tlL2RyaXZlcnMvYmxvY2svZmxvcHB5LmM6OTY4
IHNjaGVkdWxlX2JoKzB4NDcvMHg4MCgpClsgICA3MS43MjcxMTNdIENQVTogMCBQSUQ6IDc3
IENvbW06IGt3b3JrZXIvdTI6MSBOb3QgdGFpbnRlZCAzLjEzLjAgIzEKWyAgIDcyLjAyNzI3
M10gSGFyZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5
NiksIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgNzIuNjMwMTYwXSBXb3JrcXVldWU6IGV2
ZW50c191bmJvdW5kIGFzeW5jX3J1bl9lbnRyeV9mbgpbICAgNzIuOTQ0NDE3XSAgMDAwMDAw
MDAgYzAxY2RlMTQgYzI4M2I1ODcgYzAxY2RlNDQgYzEwNWUyMWQgYzMxNDk2YjggMDAwMDAw
MDAgMDAwMDAwNGQKWyAgIDczLjYwNjc1OV0gIGMzMjQwODE0IDAwMDAwM2M4IGMxYThiOWI3
IGMxYThiOWI3IDAwMDAwMDAxIGMxYThlNmYwIGMzYjZiYmMwIGMwMWNkZTU0ClsgICA3NC4y
NzIzMTldICBjMTA1ZTMwMiAwMDAwMDAwOSAwMDAwMDAwMCBjMDFjZGU2NCBjMWE4YjliNyAw
MDAwMDAwMCAwMDAwMDAwMCBjMDFjZGU4NApbICAgNzQuOTM2MDQxXSBDYWxsIFRyYWNlOgpb
ICAgNzUuMjQzMDEwXSAgWzxjMjgzYjU4Nz5dIGR1bXBfc3RhY2srMHgxNi8weDE4ClsgICA3
NS41NTUzMjBdICBbPGMxMDVlMjFkPl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg4ZC8weGIw
ClsgICA3NS44NjUxMDldICBbPGMxYThiOWI3Pl0gPyBzY2hlZHVsZV9iaCsweDQ3LzB4ODAK
WyAgIDc2LjE3MTQxMV0gIFs8YzFhOGI5Yjc+XSA/IHNjaGVkdWxlX2JoKzB4NDcvMHg4MApb
ICAgNzYuNDY2NzAxXSAgWzxjMWE4ZTZmMD5dID8gbWFrZV9yYXdfcndfcmVxdWVzdCsweDEx
YzAvMHgxMWMwClsgICA3Ni43NDE0MzFdICBbPGMxMDVlMzAyPl0gd2Fybl9zbG93cGF0aF9u
dWxsKzB4MjIvMHgzMApbICAgNzcuMDE2MTczXSAgWzxjMWE4YjliNz5dIHNjaGVkdWxlX2Jo
KzB4NDcvMHg4MApbICAgNzcuMjkyNjQyXSAgWzxjMWE4ZWIxMz5dIHdhaXRfdGlsX2RvbmUr
MHgxMy8weDIwMApbICAgNzcuNTY3MjEzXSAgWzxjMTA2Y2M2MD5dID8gY2FzY2FkZSsweGEw
LzB4YTAKWyAgIDc3LjgzNjUzMF0gIFs8YzFhOGY0ZTc+XSB1c2VyX3Jlc2V0X2ZkYysweGE3
LzB4MTEwClsgICA3OC4xMTQwNjldICBbPGMzYTA5MDI0Pl0gZmxvcHB5X2FzeW5jX2luaXQr
MHg5ZGUvMHgxMjU2ClsgICA3OC4zOTI3ODZdICBbPGMxMDkwNmU0Pl0gYXN5bmNfcnVuX2Vu
dHJ5X2ZuKzB4NDQvMHgxZDAKWyAgIDc4LjY3MDg5Nl0gIFs8YzE2YWZiYTI+XSA/IF9fbGlz
dF9kZWxfZW50cnkrMHgyMDIvMHgyMjAKWyAgIDc4Ljk0MTIzMF0gIFs8YzEwN2VmMGY+XSA/
IHB3cV9kZWNfbnJfaW5fZmxpZ2h0KzB4MTBmLzB4MTQwClsgICA3OS4yOTUzNTNdICBbPGMx
MDdmNTdlPl0gcHJvY2Vzc19vbmVfd29yaysweDMxZS8weDgxMApbICAgNzkuNjQwNjU2XSAg
WzxjMTZhZmJhMj5dID8gX19saXN0X2RlbF9lbnRyeSsweDIwMi8weDIyMApbICAgNzkuODk3
OTg3XSAgWzxjMTA3ZmU2Yz5dIHdvcmtlcl90aHJlYWQrMHgzZmMvMHg4NzAKWyAgIDgwLjE1
Nzk4M10gIFs8YzEwN2ZhNzA+XSA/IHByb2Nlc3Nfb25lX3dvcmsrMHg4MTAvMHg4MTAKWyAg
IDgwLjQxMTU0OF0gIFs8YzEwODhiMDI+XSBrdGhyZWFkKzB4ZTIvMHhmMApbICAgODAuNjY3
NjQ0XSAgWzxjMTA3ZmE3MD5dID8gcHJvY2Vzc19vbmVfd29yaysweDgxMC8weDgxMApbICAg
ODAuOTI0NTYzXSAgWzxjMjg1YmNkNz5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8w
eDI4ClsgICA4MS4xNjYwNzRdICBbPGMxMDg4YTIwPl0gPyBfX2t0aHJlYWRfdW5wYXJrKzB4
NzAvMHg3MApbICAgODEuNDA5NjAxXSAtLS1bIGVuZCB0cmFjZSAyMzZiMzZhMTczMWFmNWE3
IF0tLS0KWyAgIDgxLjY1MDM2Ml0gZmxvcHB5MDogbm8gZmxvcHB5IGNvbnRyb2xsZXJzIGZv
dW5kCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1L2Q4ZWMyNmQ3ZjgyODdm
NTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUvZG1lc2ctcXVhbnRhbC1pdmI0MS01MToyMDE0
MDcwNzEyMDAwNDppMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzU6Ogo2OjE6MyBhbGxfZ29v
ZDpiYWQ6YWxsX2JhZCBib290cwoKYmlzZWN0OiBiYWQgY29tbWl0IHYzLjEzCmdpdCBjaGVj
a291dCB2My4xMgpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5k
Y29uZmlnLWMxLTA3MDcwOTM1L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDcwNzA4
OjVlMDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTI6YmlzZWN0LWxpbnV4
MwoKMjAxNC0wNy0wNy0xMjowMDo1MCA1ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2Ni
ZDZhNWNlYjUyIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS01ZTAxZGM3YjI2ZDlm
MjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUvNWUwMWRjN2IyNmQ5ZjI0ZjM5YWJhY2U1
ZGE5OGNjYmQ2YTVjZWI1Mgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1LTVlMDFkYzdiMjZk
OWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2ViNTIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2NhaXJvLXNtb2tlL2kzODYtcmFuZGNvbmZp
Zy1jMS0wNzA3MDkzNS01ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUy
Cmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUvNWUwMWRjN2Iy
NmQ5ZjI0ZjM5YWJhY2U1ZGE5OGNjYmQ2YTVjZWI1Mi92bWxpbnV6LTMuMTIuMAoKMjAxNC0w
Ny0wNy0xMjowNTo1MCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uCTEuLgkyCTggVEVTVCBG
QUlMVVJFClsgICA0NS4zNjU3MzZdIElPQVBJQ1swXTogU2V0IHJvdXRpbmcgZW50cnkgKDAt
MTEgLT4gMHgzYiAtPiBJUlEgMTEgTW9kZToxIEFjdGl2ZTowIERlc3Q6MSkKWyAgIDQ2Ljc3
MDU2MF0gZTEwMDAgMDAwMDowMDowMy4wOiBzZXR0aW5nIGxhdGVuY3kgdGltZXIgdG8gNjQK
WyAgIDQ3LjA4NDM0OV0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsg
ICA0Ny4zOTQ1NTJdIFdBUk5JTkc6IENQVTogMCBQSUQ6IDc3IGF0IC9rYnVpbGQvc3JjL3Nt
b2tlL2RyaXZlcnMvYmxvY2svZmxvcHB5LmM6OTY4IHNjaGVkdWxlX2JoKzB4NDcvMHg4MCgp
ClsgICA0Ny45Njc2OTNdIENQVTogMCBQSUQ6IDc3IENvbW06IGt3b3JrZXIvdTI6MSBOb3Qg
dGFpbnRlZCAzLjEyLjAgIzEKWyAgIDQ4LjI2MzU1MF0gSGFyZHdhcmUgbmFtZTogUUVNVSBT
dGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5NiksIEJJT1MgQm9jaHMgMDEvMDEvMjAx
MQpbICAgNDguODMwMjg4XSBXb3JrcXVldWU6IGV2ZW50c191bmJvdW5kIGFzeW5jX3J1bl9l
bnRyeV9mbgpbICAgNDkuMTQwNjcwXSAgMDAwMDAwMDAgZDNhMmZlMGMgYzI4MWNkZjIgZDNh
MmZlM2MgYzEwNWUxNWQgYzMxMGZhNGMgMDAwMDAwMDAgMDAwMDAwNGQKWyAgIDUwLjE4Njgz
Ml0gIGMzMjA0Y2EwIDAwMDAwM2M4IGMxYTg0OWM3IGMxYTg0OWM3IDAwMDAwMDAxIGMxYTg4
OTEwIGMzYjE3YjYwIGQzYTJmZTRjClsgICA1Mi4wMzI4NTJdICBjMTA1ZTI0MiAwMDAwMDAw
OSAwMDAwMDAwMCBkM2EyZmU1YyBjMWE4NDljNyAwMDAwMDAwMCAwMDAwMDAwMCBkM2EyZmU4
NApbICAgNTMuMzM1MTg2XSBDYWxsIFRyYWNlOgpbICAgNTQuMDM1MzUwXSAgWzxjMjgxY2Rm
Mj5dIGR1bXBfc3RhY2srMHgxNi8weDE4ClsgICA1NS4xMDU5OTldICBbPGMxMDVlMTVkPl0g
d2Fybl9zbG93cGF0aF9jb21tb24rMHg4ZC8weGIwClsgICA1NS40MTEyNDRdICBbPGMxYTg0
OWM3Pl0gPyBzY2hlZHVsZV9iaCsweDQ3LzB4ODAKWyAgIDU1LjcwNjQxNl0gIFs8YzFhODQ5
Yzc+XSA/IHNjaGVkdWxlX2JoKzB4NDcvMHg4MApbICAgNTUuOTk0NzA5XSAgWzxjMWE4ODkx
MD5dID8gZmxvcHB5X2hhcmRpbnQrMHgxYTAvMHgxYTAKWyAgIDU2LjI3MTcyM10gIFs8YzEw
NWUyNDI+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgyMi8weDMwClsgICA1Ni41NDkwMjBdICBb
PGMxYTg0OWM3Pl0gc2NoZWR1bGVfYmgrMHg0Ny8weDgwClsgICA1Ni44Mjc2NDddICBbPGMx
YTg4ZDQ1Pl0gd2FpdF90aWxfZG9uZSsweDE1LzB4MjMwClsgICA1Ny40NzI5MjhdICBbPGMx
MDZjZDIwPl0gPyBjYXNjYWRlKzB4YTAvMHhhMApbICAgNTkuNTUzODY3XSAgWzxjMWE4OTc0
Nz5dIHVzZXJfcmVzZXRfZmRjKzB4YTcvMHgxMTAKWyAgIDU5Ljg2MDMzMl0gIFs8YzM5YjZl
NGM+XSBmbG9wcHlfYXN5bmNfaW5pdCsweDllZS8weDEyNjMKWyAgIDYwLjE3ODcxNV0gIFs8
YzEwOTQyNzQ+XSBhc3luY19ydW5fZW50cnlfZm4rMHg0NC8weDFlMApbICAgNjAuNTAwNzAx
XSAgWzxjMTZiMDViMj5dID8gX19saXN0X2RlbF9lbnRyeSsweDIwMi8weDIyMApbICAgNjAu
ODE2Mzk1XSAgWzxjMTA3ZjU5Nz5dID8gcHdxX2RlY19ucl9pbl9mbGlnaHQrMHgxMzcvMHgx
NDAKWyAgIDYxLjEwMTQ0Ml0gIFs8YzEwN2ZlNmI+XSBwcm9jZXNzX29uZV93b3JrKzB4MzNi
LzB4ODQwClsgICA2MS4zNzI3MTBdICBbPGMxMDk5OGIyPl0gPyB0dHd1X2RvX3dha2V1cCsw
eDEyLzB4OTAKWyAgIDYxLjY0MzgzMl0gIFs8YzE2YjA1YjI+XSA/IF9fbGlzdF9kZWxfZW50
cnkrMHgyMDIvMHgyMjAKWyAgIDYxLjk3NDM4MV0gIFs8YzEwODA3ODQ+XSB3b3JrZXJfdGhy
ZWFkKzB4NDE0LzB4ODkwClsgICA2Mi4yMzA2MTRdICBbPGMxMDgwMzcwPl0gPyBwcm9jZXNz
X29uZV93b3JrKzB4ODQwLzB4ODQwClsgICA2Mi40ODUxNDRdICBbPGMxMDhhZDA2Pl0ga3Ro
cmVhZCsweGE2LzB4YjAKWyAgIDYyLjczODcyNF0gIFs8YzI4M2M5Yjc+XSByZXRfZnJvbV9r
ZXJuZWxfdGhyZWFkKzB4MWIvMHgyOApbICAgNjIuOTcxMzIzXSAgWzxjMTA4YWM2MD5dID8g
X19rdGhyZWFkX3VucGFyaysweDcwLzB4NzAKWyAgIDYzLjIxMTMyMF0gLS0tWyBlbmQgdHJh
Y2UgYzM0MWZiZWM1MzgwNmJkYSBdLS0tClsgICA2My40NDIxNzhdIGZsb3BweTA6IG5vIGZs
b3BweSBjb250cm9sbGVycyBmb3VuZAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3
MDkzNS81ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyL2RtZXNnLXF1
YW50YWwtaXZiNDEtMzoyMDE0MDcwNzEyMDkzNDppMzg2LXJhbmRjb25maWctYzEtMDcwNzA5
MzU6Ogo3OjE6MiBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKYmlzZWN0OiBiYWQgY29t
bWl0IHYzLjEyCmdpdCBjaGVja291dCB2My4xMQpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1x
dWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1L2xpbnV4LWRldmVsOmRldmVs
LWhvdXJseS0yMDE0MDcwNzA4OjZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMx
OTIxM2U6YmlzZWN0LWxpbnV4MwoKMjAxNC0wNy0wNy0xMjoxMDoyOCA2ZTQ2NjQ1MjViMWRi
MjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFz
ayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3
MDkzNS02ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlCkNoZWNrIGZv
ciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUvNmU0NjY0
NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEzZQp3YWl0aW5nIGZvciBjb21wbGV0
aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWMxLTA3
MDcwOTM1LTZlNDY2NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UKd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2pha2V0b3du
LWNvbnN1bWVyL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS02ZTQ2NjQ1MjViMWRiMjhm
OGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctYzEtMDcwNzA5MzUvNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEz
ZS92bWxpbnV6LTMuMTEuMAoKMjAxNC0wNy0wNy0xMjoxNzoyOCBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAuLi4uLi4JMQk5CTIxIFRFU1QgRkFJTFVSRQpbICAgNDQuOTQ1OTk4XSBQQ0k6IHNl
dHRpbmcgSVJRIDExIGFzIGxldmVsLXRyaWdnZXJlZApbICAgNDUuMjE4NjM1XSBlMTAwMCAw
MDAwOjAwOjAzLjA6IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2NApbICAgNDUuNTU0NDEx
XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgIDQ1Ljg0NjM1MV0g
V0FSTklORzogQ1BVOiAwIFBJRDogNzYgYXQgL2tidWlsZC9zcmMvY29uc3VtZXIvZHJpdmVy
cy9ibG9jay9mbG9wcHkuYzo5Njggc2NoZWR1bGVfYmgrMHg0Ny8weDgwKCkKWyAgIDQ2LjQw
NTcwMV0gQ1BVOiAwIFBJRDogNzYgQ29tbToga3dvcmtlci91MjoxIE5vdCB0YWludGVkIDMu
MTEuMCAjMgpbICAgNDYuNzM1OTM1XSBIYXJkd2FyZSBuYW1lOiBRRU1VIFN0YW5kYXJkIFBD
IChpNDQwRlggKyBQSUlYLCAxOTk2KSwgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICA0Ny42
MDk5MTBdIFdvcmtxdWV1ZTogZXZlbnRzX3VuYm91bmQgYXN5bmNfcnVuX2VudHJ5X2ZuClsg
ICA0Ny45MDc4NDhdICAwMDAwMDAwMCBkM2E0M2UwYyBjMjc0NjRiMCBkM2E0M2UzYyBjMTA1
NDcyZCBjMmZmMjBhNCAwMDAwMDAwMCAwMDAwMDA0YwpbICAgNTMuNzA2NDE1XSAgYzMwZTBh
ZTggMDAwMDAzYzggYzFhMmZjNDcgYzFhMmZjNDcgMDAwMDAwMDEgYzFhMzNiOTAgYzM5YTBj
YTAgZDNhNDNlNGMKWyAgIDU0LjQzMDMyMl0gIGMxMDU0ODEyIDAwMDAwMDA5IDAwMDAwMDAw
IGQzYTQzZTVjIGMxYTJmYzQ3IDAwMDAwMDAwIDAwMDAwMDAwIGQzYTQzZTg0ClsgICA1NS4y
NDUzNjldIENhbGwgVHJhY2U6ClsgICA1NS44MzI1NzVdICBbPGMyNzQ2NGIwPl0gZHVtcF9z
dGFjaysweDE2LzB4MTgKWyAgIDU2LjExNDAyOF0gIFs8YzEwNTQ3MmQ+XSB3YXJuX3Nsb3dw
YXRoX2NvbW1vbisweDhkLzB4YjAKWyAgIDU2LjQxMDY3NF0gIFs8YzFhMmZjNDc+XSA/IHNj
aGVkdWxlX2JoKzB4NDcvMHg4MApbICAgNTYuNjk0MTIwXSAgWzxjMWEyZmM0Nz5dID8gc2No
ZWR1bGVfYmgrMHg0Ny8weDgwClsgICA1Ni45NjA0MTddICBbPGMxYTMzYjkwPl0gPyBmbG9w
cHlfaGFyZGludCsweDFhMC8weDFhMApbICAgNTcuMjQ5MjU4XSAgWzxjMTA1NDgxMj5dIHdh
cm5fc2xvd3BhdGhfbnVsbCsweDIyLzB4MzAKWyAgIDU3LjUyODE3M10gIFs8YzFhMmZjNDc+
XSBzY2hlZHVsZV9iaCsweDQ3LzB4ODAKWyAgIDU3Ljk3MDM1NV0gIFs8YzFhMzNmYzU+XSB3
YWl0X3RpbF9kb25lKzB4MTUvMHgyMzAKWyAgIDU4LjQwODg2N10gIFs8YzEwNjMyNjA+XSA/
IGNhc2NhZGUrMHhhMC8weGEwClsgICA1OC43NTYwNzRdICBbPGMxYTM0OWM3Pl0gdXNlcl9y
ZXNldF9mZGMrMHhhNy8weDExMApbICAgNTkuMTgzNTkzXSAgWzxjMzg0Yzk0NT5dIGZsb3Bw
eV9hc3luY19pbml0KzB4OWVlLzB4MTI2MwpbICAgNTkuNjg4MjM3XSAgWzxjMTA4YTBlND5d
IGFzeW5jX3J1bl9lbnRyeV9mbisweDQ0LzB4MWUwClsgICA2MC4xNzU5MDRdICBbPGMxNjkw
MjEyPl0gPyBfX2xpc3RfZGVsX2VudHJ5KzB4MjAyLzB4MjIwClsgICA2MC40Mjk5ODddICBb
PGMxMDc1Njg3Pl0gPyBwd3FfZGVjX25yX2luX2ZsaWdodCsweDEzNy8weDE0MApbICAgNjAu
NjgzMDkyXSAgWzxjMTA3NWY1Yj5dIHByb2Nlc3Nfb25lX3dvcmsrMHgzM2IvMHg4NDAKWyAg
IDYxLjI3NTU0N10gIFs8YzEwOGY1NDI+XSA/IHR0d3VfZG9fd2FrZXVwKzB4MTIvMHg5MApb
ICAgNjIuNDg3MTU3XSAgWzxjMTY5MDIxMj5dID8gX19saXN0X2RlbF9lbnRyeSsweDIwMi8w
eDIyMApbICAgNjQuMTYwMjI3XSAgWzxjMTA3Njg3ND5dIHdvcmtlcl90aHJlYWQrMHg0MTQv
MHg4OTAKWyAgIDY0LjYwMTU2Ml0gIFs8YzEwNzY0NjA+XSA/IHByb2Nlc3Nfb25lX3dvcmsr
MHg4NDAvMHg4NDAKWyAgIDY0Ljg4NTExMl0gIFs8YzEwODBiYTY+XSBrdGhyZWFkKzB4YTYv
MHhiMApbICAgNjUuMTMzOTc0XSAgWzxjMjc2NDhkNz5dIHJldF9mcm9tX2tlcm5lbF90aHJl
YWQrMHgxYi8weDI4ClsgICA2NS4zNzIxMDRdICBbPGMxMDgwYjAwPl0gPyBfX2t0aHJlYWRf
dW5wYXJrKzB4NzAvMHg3MApbICAgNjUuNjE3MzQ3XSAtLS1bIGVuZCB0cmFjZSA0YzNkYjdj
NTQ4NzE4NmQyIF0tLS0KWyAgIDY1Ljg0OTk5Nl0gZmxvcHB5MDogbm8gZmxvcHB5IGNvbnRy
b2xsZXJzIGZvdW5kCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1LzZlNDY2
NDUyNWIxZGIyOGY4YzRlMTEzMDk1N2Y3MGE5NGMxOTIxM2UvZG1lc2ctcXVhbnRhbC1pdmI0
MS0yMDoyMDE0MDcwNzEyMjA1NjppMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzU6Ogova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS82ZTQ2NjQ1MjViMWRiMjhmOGM0ZTEx
MzA5NTdmNzBhOTRjMTkyMTNlL2RtZXNnLXF1YW50YWwtaXZiNDEtNjA6MjAxNDA3MDcxMjIx
MDU6aTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctYzEtMDcwNzA5MzUvNmU0NjY0NTI1YjFkYjI4ZjhjNGUxMTMwOTU3ZjcwYTk0YzE5MjEz
ZS9kbWVzZy1xdWFudGFsLWl2YjQzLTEwNzoyMDE0MDcwNzEyMTk0MDppMzg2LXJhbmRjb25m
aWctYzEtMDcwNzA5MzU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS82
ZTQ2NjQ1MjViMWRiMjhmOGM0ZTExMzA5NTdmNzBhOTRjMTkyMTNlL2RtZXNnLXF1YW50YWwt
aXZiNDMtNzA6MjAxNDA3MDcxMjE5NDI6aTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1OjoK
MjE6NDo0IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpiaXNlY3Q6IGJhZCBjb21taXQg
djMuMTEKZ2l0IGNoZWNrb3V0IHYzLjEwCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUvbGludXgtZGV2ZWw6ZGV2ZWwtaG91
cmx5LTIwMTQwNzA3MDg6OGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3
NjpiaXNlY3QtbGludXgzCgoyMDE0LTA3LTA3LTEyOjIyOjAzIDhiYjQ5NWUzZjAyNDAxZWU2
Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRv
IC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1
LThiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3N2YzYWM5ZjA3OWUzNzYKQ2hlY2sgZm9yIGtl
cm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS84YmI0OTVlM2Yw
MjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2CndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5
MzUtOGJiNDk1ZTNmMDI0MDFlZTZmNzZkMWIxZDc3ZjNhYzlmMDc5ZTM3Ngp3YWl0aW5nIGZv
ciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvY2Fpcm8tc21va2Uv
aTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1LThiYjQ5NWUzZjAyNDAxZWU2Zjc2ZDFiMWQ3
N2YzYWM5ZjA3OWUzNzYKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3
MDkzNS84YmI0OTVlM2YwMjQwMWVlNmY3NmQxYjFkNzdmM2FjOWYwNzllMzc2L3ZtbGludXot
My4xMC4wCgoyMDE0LTA3LTA3LTEyOjI4OjAzIGRldGVjdGluZyBib290IHN0YXRlIC4uLi4u
LgkxCTQJMTgJMjQJNDYJNzQJMTA4CTE0NAkyMDEJMjU0CTI5NgkyOTkJMzAwIFNVQ0NFU1MK
CmJpc2VjdDogZ29vZCBjb21taXQgdjMuMTAKZ2l0IGJpc2VjdCBzdGFydCB2My4xMSB2My4x
MCAtLQovYy9rZXJuZWwtdGVzdHMvbGluZWFyLWJpc2VjdDogWyItYiIsICJ2My4xMSIsICIt
ZyIsICJ2My4xMCIsICIvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIiwgIi9jL2Jvb3QtYmlzZWN0L2xpbnV4My9vYmotYmlzZWN0Il0KQmlzZWN0aW5nOiAx
MTg1MSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTQgc3Rl
cHMpCls4OWQwYWJlM2Q2OTUxMDM1MDVjMDI1ZGRlNmUwN2I5YzNkZDc3MmY0XSBNZXJnZSB0
YWcgJ2FybTY0LXN0YWJsZScgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51
eC9rZXJuZWwvZ2l0L2NtYXJpbmFzL2xpbnV4LWFhcmNoNjQKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4
My9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJh
bmRjb25maWctYzEtMDcwNzA5MzUvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNzA3
MDg6ODlkMGFiZTNkNjk1MTAzNTA1YzAyNWRkZTZlMDdiOWMzZGQ3NzJmNDpiaXNlY3QtbGlu
dXgzCgoyMDE0LTA3LTA3LTEyOjM3OjQyIDg5ZDBhYmUzZDY5NTEwMzUwNWMwMjVkZGU2ZTA3
YjljM2RkNzcyZjQgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1LTg5ZDBhYmUzZDY5
NTEwMzUwNWMwMjVkZGU2ZTA3YjljM2RkNzcyZjQKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS84OWQwYWJlM2Q2OTUxMDM1MDVjMDI1
ZGRlNmUwN2I5YzNkZDc3MmY0CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUtODlkMGFiZTNk
Njk1MTAzNTA1YzAyNWRkZTZlMDdiOWMzZGQ3NzJmNAp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvamFrZXRvd24tY29uc3VtZXIvaTM4Ni1y
YW5kY29uZmlnLWMxLTA3MDcwOTM1LTg5ZDBhYmUzZDY5NTEwMzUwNWMwMjVkZGU2ZTA3Yjlj
M2RkNzcyZjQKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS84
OWQwYWJlM2Q2OTUxMDM1MDVjMDI1ZGRlNmUwN2I5YzNkZDc3MmY0L3ZtbGludXotMy4xMS4w
LXJjMS0wMDE5Ni1nODlkMGFiZQoKMjAxNC0wNy0wNy0xMjo1MTo0MiBkZXRlY3RpbmcgYm9v
dCBzdGF0ZSAuLi4uLi4JMQkzCTEyCTI4CTQ3CTc2CTk2CTE0NQkyMDAJMjI5CTI3NgkyOTgJ
MzAwIFNVQ0NFU1MKCkJpc2VjdGluZzogMTQ5NCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgMTEgc3RlcHMpCls4NzQyZjIyOWI2MzViZjFjMWM4NGEzZGZl
NWU0N2M4MTRjMjBiNWM4XSB1c2VybnM6IGxpbWl0IHRoZSBtYXhpbXVtIGRlcHRoIG9mIHVz
ZXJfbmFtZXNwYWNlLT5wYXJlbnQgY2hhaW4KcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlz
ZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4My9vYmotYmlz
ZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
YzEtMDcwNzA5MzUvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNzA3MDg6ODc0MmYy
MjliNjM1YmYxYzFjODRhM2RmZTVlNDdjODE0YzIwYjVjODpiaXNlY3QtbGludXgzCgoyMDE0
LTA3LTA3LTEzOjAxOjE1IDg3NDJmMjI5YjYzNWJmMWMxYzg0YTNkZmU1ZTQ3YzgxNGMyMGI1
YzggY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQt
cXVldWUvaTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1LTg3NDJmMjI5YjYzNWJmMWMxYzg0
YTNkZmU1ZTQ3YzgxNGMyMGI1YzgKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYt
cmFuZGNvbmZpZy1jMS0wNzA3MDkzNS84NzQyZjIyOWI2MzViZjFjMWM4NGEzZGZlNWU0N2M4
MTRjMjBiNWM4CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUtODc0MmYyMjliNjM1YmYxYzFj
ODRhM2RmZTVlNDdjODE0YzIwYjVjOAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVp
bGQtdGVzdHMvYnVpbGQtcXVldWUvamFrZXRvd24tY29uc3VtZXIvaTM4Ni1yYW5kY29uZmln
LWMxLTA3MDcwOTM1LTg3NDJmMjI5YjYzNWJmMWMxYzg0YTNkZmU1ZTQ3YzgxNGMyMGI1YzgK
a2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS84NzQyZjIyOWI2
MzViZjFjMWM4NGEzZGZlNWU0N2M4MTRjMjBiNWM4L3ZtbGludXotMy4xMS4wLXJjNC0wMDEw
MS1nODc0MmYyMgoKMjAxNC0wNy0wNy0xMzowOToxNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAu
Li4uLi4uCTIJMTUJMjgJNTEJNzgJMTE4CTE2MAkxODMJMjQzCTI4NQkyOTMJMzAwIFNVQ0NF
U1MKCkJpc2VjdGluZzogNTYxIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAo
cm91Z2hseSAxMCBzdGVwcykKWzk0ZmM1ZDlkZTViZDc1N2FkNDZmMGQ5NGJjNGViZjYxN2M0
NDg3ZjZdIHByb2M6IHJldHVybiBvbiBwcm9jX3JlYWRkaXIgZXJyb3IKcnVubmluZyAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0
L2xpbnV4My9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9p
Mzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIw
MTQwNzA3MDg6OTRmYzVkOWRlNWJkNzU3YWQ0NmYwZDk0YmM0ZWJmNjE3YzQ0ODdmNjpiaXNl
Y3QtbGludXgzCgoyMDE0LTA3LTA3LTEzOjE4OjQ5IDk0ZmM1ZDlkZTViZDc1N2FkNDZmMGQ5
NGJjNGViZjYxN2M0NDg3ZjYgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVp
bGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1LTk0ZmM1
ZDlkZTViZDc1N2FkNDZmMGQ5NGJjNGViZjYxN2M0NDg3ZjYKQ2hlY2sgZm9yIGtlcm5lbCBp
biAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS85NGZjNWQ5ZGU1YmQ3NTdh
ZDQ2ZjBkOTRiYzRlYmY2MTdjNDQ4N2Y2CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2ti
dWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUtOTRm
YzVkOWRlNWJkNzU3YWQ0NmYwZDk0YmM0ZWJmNjE3YzQ0ODdmNgp3YWl0aW5nIGZvciBjb21w
bGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvY2Fpcm8tc21va2UvaTM4Ni1y
YW5kY29uZmlnLWMxLTA3MDcwOTM1LTk0ZmM1ZDlkZTViZDc1N2FkNDZmMGQ5NGJjNGViZjYx
N2M0NDg3ZjYKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS85
NGZjNWQ5ZGU1YmQ3NTdhZDQ2ZjBkOTRiYzRlYmY2MTdjNDQ4N2Y2L3ZtbGludXotMy4xMS4w
LXJjNi0wMDAyNy1nOTRmYzVkOQoKMjAxNC0wNy0wNy0xMzoyNTo0OSBkZXRlY3RpbmcgYm9v
dCBzdGF0ZSAuLi4uCTEJMgkxMAkyNAkzNAk0OAk2NgkxMDMJMTUzCTE5OAkyNDIJMjY5CTI5
MgkyOTgJMzAwIFNVQ0NFU1MKCkJpc2VjdGluZzogMjQzIHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpbNWUyNWU0ZjMwNGNlNTMwMDRkY2Qw
MTcyNTkzOGMwYmM0NWM3NWQzNV0gTWVyZ2UgdGFnICd1c2ItMy4xMS1yYzcnIG9mIGdpdDov
L2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9ncmVna2gvdXNiCnJ1
bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9i
b290LWJpc2VjdC9saW51eDMvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1x
dWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1L2xpbnV4LWRldmVsOmRldmVs
LWhvdXJseS0yMDE0MDcwNzA4OjVlMjVlNGYzMDRjZTUzMDA0ZGNkMDE3MjU5MzhjMGJjNDVj
NzVkMzU6YmlzZWN0LWxpbnV4MwoKMjAxNC0wNy0wNy0xMzozNToyMCA1ZTI1ZTRmMzA0Y2U1
MzAwNGRjZDAxNzI1OTM4YzBiYzQ1Yzc1ZDM1IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFz
ayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3
MDkzNS01ZTI1ZTRmMzA0Y2U1MzAwNGRjZDAxNzI1OTM4YzBiYzQ1Yzc1ZDM1CkNoZWNrIGZv
ciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUvNWUyNWU0
ZjMwNGNlNTMwMDRkY2QwMTcyNTkzOGMwYmM0NWM3NWQzNQp3YWl0aW5nIGZvciBjb21wbGV0
aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWMxLTA3
MDcwOTM1LTVlMjVlNGYzMDRjZTUzMDA0ZGNkMDE3MjU5MzhjMGJjNDVjNzVkMzUKd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2NhaXJvLXNt
b2tlL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS01ZTI1ZTRmMzA0Y2U1MzAwNGRjZDAx
NzI1OTM4YzBiYzQ1Yzc1ZDM1Cmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEt
MDcwNzA5MzUvNWUyNWU0ZjMwNGNlNTMwMDRkY2QwMTcyNTkzOGMwYmM0NWM3NWQzNS92bWxp
bnV6LTMuMTEuMC1yYzYtMDAxNjItZzVlMjVlNGYKCjIwMTQtMDctMDctMTM6Mzk6MjAgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uCTIJMTIJMzEJNDgJNzAJOTYJMTM1CTE5OQkyMzQJ
Mjc2CTI5OAkzMDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxMDggcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDcgc3RlcHMpClswNmE1NTdmN2E2OGUxMjYxODFm
MDk4MzFjYjJmYWM2ZjdhN2Y0M2MyXSBNZXJnZSB0YWcgJ25mcy1mb3ItMy4xMS01JyBvZiBn
aXQ6Ly9naXQubGludXgtbmZzLm9yZy9wcm9qZWN0cy90cm9uZG15L2xpbnV4LW5mcwpydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9v
dC1iaXNlY3QvbGludXgzL29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVl
dWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS9saW51eC1kZXZlbDpkZXZlbC1o
b3VybHktMjAxNDA3MDcwODowNmE1NTdmN2E2OGUxMjYxODFmMDk4MzFjYjJmYWM2ZjdhN2Y0
M2MyOmJpc2VjdC1saW51eDMKCjIwMTQtMDctMDctMTM6NDg6MjcgMDZhNTU3ZjdhNjhlMTI2
MTgxZjA5ODMxY2IyZmFjNmY3YTdmNDNjMiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sg
dG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5
MzUtMDZhNTU3ZjdhNjhlMTI2MTgxZjA5ODMxY2IyZmFjNmY3YTdmNDNjMgpDaGVjayBmb3Ig
a2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1LzA2YTU1N2Y3
YTY4ZTEyNjE4MWYwOTgzMWNiMmZhYzZmN2E3ZjQzYzIKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3
MDkzNS0wNmE1NTdmN2E2OGUxMjYxODFmMDk4MzFjYjJmYWM2ZjdhN2Y0M2MyCndhaXRpbmcg
Zm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9qYWtldG93bi1j
b25zdW1lci9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUtMDZhNTU3ZjdhNjhlMTI2MTgx
ZjA5ODMxY2IyZmFjNmY3YTdmNDNjMgprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWMxLTA3MDcwOTM1LzA2YTU1N2Y3YTY4ZTEyNjE4MWYwOTgzMWNiMmZhYzZmN2E3ZjQzYzIv
dm1saW51ei0zLjExLjAtcmM3LTAwMDI2LWcwNmE1NTdmCgoyMDE0LTA3LTA3LTE0OjA2OjI3
IGRldGVjdGluZyBib290IHN0YXRlIC4uLi4JMQkyCTUJMTYJMjkJNDMJNjIJODEJMTA0CTEx
NgkxMjYJMTI5CTEzMAkxMzMJMTM1CTE0NAkxNTIJMTY4CTE4OQkyMDMJMjI2CTI0NQkyNTUJ
MjYzCTI3MQkyODYJMjk3CTMwMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDc3IHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA3IHN0ZXBzKQpbOTM2ZGJjYzNmMmZj
NzMxNGYzYzE2NDVmYzM5ZWE1MTExN2Y2ZDczYl0gTWVyZ2UgdGFnICdzb3VuZC0zLjExJyBv
ZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGl3YWkv
c291bmQKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4My9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVz
dHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUvbGludXgtZGV2
ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNzA3MDg6OTM2ZGJjYzNmMmZjNzMxNGYzYzE2NDVmYzM5
ZWE1MTExN2Y2ZDczYjpiaXNlY3QtbGludXgzCgoyMDE0LTA3LTA3LTE0OjIyOjI3IDkzNmRi
Y2MzZjJmYzczMTRmM2MxNjQ1ZmMzOWVhNTExMTdmNmQ3M2IgY29tcGlsaW5nClF1ZXVlZCBi
dWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmln
LWMxLTA3MDcwOTM1LTkzNmRiY2MzZjJmYzczMTRmM2MxNjQ1ZmMzOWVhNTExMTdmNmQ3M2IK
Q2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkz
NS85MzZkYmNjM2YyZmM3MzE0ZjNjMTY0NWZjMzllYTUxMTE3ZjZkNzNiCndhaXRpbmcgZm9y
IGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25m
aWctYzEtMDcwNzA5MzUtOTM2ZGJjYzNmMmZjNzMxNGYzYzE2NDVmYzM5ZWE1MTExN2Y2ZDcz
Ygp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUv
amFrZXRvd24tY29uc3VtZXIvaTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1LTkzNmRiY2Mz
ZjJmYzczMTRmM2MxNjQ1ZmMzOWVhNTExMTdmNmQ3M2IKa2VybmVsOiAva2VybmVsL2kzODYt
cmFuZGNvbmZpZy1jMS0wNzA3MDkzNS85MzZkYmNjM2YyZmM3MzE0ZjNjMTY0NWZjMzllYTUx
MTE3ZjZkNzNiL3ZtbGludXotMy4xMS4wLXJjNy0wMDA0Ni1nOTM2ZGJjYwoKMjAxNC0wNy0w
Ny0xNDozMToyNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4uLi4uCTEJNgkxNSBURVNUIEZB
SUxVUkUKWyAgIDU1LjExNDM2M10gUENJOiBzZXR0aW5nIElSUSAxMSBhcyBsZXZlbC10cmln
Z2VyZWQKWyAgIDU2LjM3NTI2NV0gZTEwMDAgMDAwMDowMDowMy4wOiBzZXR0aW5nIGxhdGVu
Y3kgdGltZXIgdG8gNjQKWyAgIDU2LjY0MTcyNl0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBd
LS0tLS0tLS0tLS0tClsgICA1Ni45MTQ2ODldIFdBUk5JTkc6IENQVTogMCBQSUQ6IDc2IGF0
IC9rYnVpbGQvc3JjL2NvbnN1bWVyL2RyaXZlcnMvYmxvY2svZmxvcHB5LmM6OTY4IHNjaGVk
dWxlX2JoKzB4NDcvMHg4MCgpClsgICA1Ny40NjkzMjNdIENQVTogMCBQSUQ6IDc2IENvbW06
IGt3b3JrZXIvdTI6MSBOb3QgdGFpbnRlZCAzLjExLjAtcmM3LTAwMDQ2LWc5MzZkYmNjICM2
ClsgICA1OC4wMTE1MzddIEhhcmR3YXJlIG5hbWU6IFFFTVUgU3RhbmRhcmQgUEMgKGk0NDBG
WCArIFBJSVgsIDE5OTYpLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgIDU4Ljk2MzgxM10g
V29ya3F1ZXVlOiBldmVudHNfdW5ib3VuZCBhc3luY19ydW5fZW50cnlfZm4KWyAgIDU5LjI2
NDQ4M10gIDAwMDAwMDAwIGQzYTQ1ZTBjIGMyNzQ1YzAwIGQzYTQ1ZTNjIGMxMDU0NzJkIGMy
ZmYwYjIwIDAwMDAwMDAwIDAwMDAwMDRjClsgICA2MC4zMjU3ODldICBjMzBkZjU4YyAwMDAw
MDNjOCBjMWEyZmM0NyBjMWEyZmM0NyAwMDAwMDAwMSBjMWEzM2I5MCBjMzlhMGNhMCBkM2E0
NWU0YwpbICAgNjEuMTQ2MDg2XSAgYzEwNTQ4MTIgMDAwMDAwMDkgMDAwMDAwMDAgZDNhNDVl
NWMgYzFhMmZjNDcgMDAwMDAwMDAgMDAwMDAwMDAgZDNhNDVlODQKWyAgIDYxLjk5Njk0N10g
Q2FsbCBUcmFjZToKWyAgIDYyLjQ4NzMxNF0gIFs8YzI3NDVjMDA+XSBkdW1wX3N0YWNrKzB4
MTYvMHgxOApbICAgNjIuNzk2OTEyXSAgWzxjMTA1NDcyZD5dIHdhcm5fc2xvd3BhdGhfY29t
bW9uKzB4OGQvMHhiMApbICAgNjMuMTAzNjU0XSAgWzxjMWEyZmM0Nz5dID8gc2NoZWR1bGVf
YmgrMHg0Ny8weDgwClsgICA2My40MDU3NzRdICBbPGMxYTJmYzQ3Pl0gPyBzY2hlZHVsZV9i
aCsweDQ3LzB4ODAKWyAgIDYzLjcyMzUyMV0gIFs8YzFhMzNiOTA+XSA/IGZsb3BweV9oYXJk
aW50KzB4MWEwLzB4MWEwClsgICA2NC4wMDQ4NzRdICBbPGMxMDU0ODEyPl0gd2Fybl9zbG93
cGF0aF9udWxsKzB4MjIvMHgzMApbICAgNjQuMjgwNjM2XSAgWzxjMWEyZmM0Nz5dIHNjaGVk
dWxlX2JoKzB4NDcvMHg4MApbICAgNjUuNzMzMTE3XSAgWzxjMWEzM2ZjNT5dIHdhaXRfdGls
X2RvbmUrMHgxNS8weDIzMApbICAgNzEuNTEwODcxXSAgWzxjMTA2MzI2MD5dID8gY2FzY2Fk
ZSsweGEwLzB4YTAKWyAgIDcyLjIwMzA5NV0gIFs8YzFhMzQ5Yzc+XSB1c2VyX3Jlc2V0X2Zk
YysweGE3LzB4MTEwClsgICA3Mi40ODI5ODVdICBbPGMzODRjOTM5Pl0gZmxvcHB5X2FzeW5j
X2luaXQrMHg5ZWUvMHgxMjYzClsgICA3My4zMjM1MTJdICBbPGMxMDhhMGU0Pl0gYXN5bmNf
cnVuX2VudHJ5X2ZuKzB4NDQvMHgxZTAKWyAgIDczLjc5MzE0Ml0gIFs8YzE2OTAyMTI+XSA/
IF9fbGlzdF9kZWxfZW50cnkrMHgyMDIvMHgyMjAKWyAgIDc0LjIyMjY3MV0gIFs8YzEwNzU2
ODc+XSA/IHB3cV9kZWNfbnJfaW5fZmxpZ2h0KzB4MTM3LzB4MTQwClsgICA3NC41MDY4MDRd
ICBbPGMxMDc1ZjViPl0gcHJvY2Vzc19vbmVfd29yaysweDMzYi8weDg0MApbICAgNzQuNzk4
NDExXSAgWzxjMTA4ZjU0Mj5dID8gdHR3dV9kb193YWtldXArMHgxMi8weDkwClsgICA3NS4x
NTg2MDVdICBbPGMxNjkwMjEyPl0gPyBfX2xpc3RfZGVsX2VudHJ5KzB4MjAyLzB4MjIwClsg
ICA3OS42Njc5NTZdICBbPGMxMDc2ODc0Pl0gd29ya2VyX3RocmVhZCsweDQxNC8weDg5MApb
ICAgODEuMzM1MzUxXSAgWzxjMTA3NjQ2MD5dID8gcHJvY2Vzc19vbmVfd29yaysweDg0MC8w
eDg0MApbICAgODMuNjcxODQ1XSAgWzxjMTA4MGJhNj5dIGt0aHJlYWQrMHhhNi8weGIwClsg
ICA4NS4wMTQ1MjRdICBbPGMyNzY0MDM3Pl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDFi
LzB4MjgKWyAgIDg2LjAzOTUxMl0gIFs8YzEwODBiMDA+XSA/IF9fa3RocmVhZF91bnBhcmsr
MHg3MC8weDcwClsgICA4Ny4zNDYzODVdIC0tLVsgZW5kIHRyYWNlIGRkZDAyN2NhNjQ4N2Mz
N2MgXS0tLQpbICAgODcuNjMyODkxXSBmbG9wcHkwOiBubyBmbG9wcHkgY29udHJvbGxlcnMg
Zm91bmQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUvOTM2ZGJjYzNmMmZj
NzMxNGYzYzE2NDVmYzM5ZWE1MTExN2Y2ZDczYi9kbWVzZy15b2N0by1pdmI0MS04OjIwMTQw
NzA3MTQzNTM1OmkzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNTo6Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWMxLTA3MDcwOTM1LzkzNmRiY2MzZjJmYzczMTRmM2MxNjQ1ZmMzOWVhNTEx
MTdmNmQ3M2IvZG1lc2ctcXVhbnRhbC1pdmI0MS02NToyMDE0MDcwNzE0MzU0NjppMzg2LXJh
bmRjb25maWctYzEtMDcwNzA5MzU6OgoxNToyOjIgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9v
dHMKCkJpc2VjdGluZzogMjAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChy
b3VnaGx5IDUgc3RlcHMpClsxNTVlM2EzNTM5NDNhM2U3MTNjZDMzMzU3Y2ZkNThlOTk1OTAw
YTgxXSBNZXJnZSBicmFuY2ggJ2Zvci1saW51cycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcv
cHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2R0b3IvaW5wdXQKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4
My9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJh
bmRjb25maWctYzEtMDcwNzA5MzUvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNzA3
MDg6MTU1ZTNhMzUzOTQzYTNlNzEzY2QzMzM1N2NmZDU4ZTk5NTkwMGE4MTpiaXNlY3QtbGlu
dXgzCgoyMDE0LTA3LTA3LTE0OjM2OjI5IDE1NWUzYTM1Mzk0M2EzZTcxM2NkMzMzNTdjZmQ1
OGU5OTU5MDBhODEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVz
dHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1LTE1NWUzYTM1Mzk0
M2EzZTcxM2NkMzMzNTdjZmQ1OGU5OTU5MDBhODEKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS8xNTVlM2EzNTM5NDNhM2U3MTNjZDMz
MzU3Y2ZkNThlOTk1OTAwYTgxCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUtMTU1ZTNhMzUz
OTQzYTNlNzEzY2QzMzM1N2NmZDU4ZTk5NTkwMGE4MQp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvamFrZXRvd24tY29uc3VtZXIvaTM4Ni1y
YW5kY29uZmlnLWMxLTA3MDcwOTM1LTE1NWUzYTM1Mzk0M2EzZTcxM2NkMzMzNTdjZmQ1OGU5
OTU5MDBhODEKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS8x
NTVlM2EzNTM5NDNhM2U3MTNjZDMzMzU3Y2ZkNThlOTk1OTAwYTgxL3ZtbGludXotMy4xMS4w
LXJjNy0wMDAzNS1nMTU1ZTNhMwoKMjAxNC0wNy0wNy0xNDo0MDoyOSBkZXRlY3RpbmcgYm9v
dCBzdGF0ZSAuLi4uLi4uLi4uLi4uLi4uCTEJMgk5CTEzIFRFU1QgRkFJTFVSRQpbICAgNzYu
MDg1MDUxXSBQQ0k6IHNldHRpbmcgSVJRIDExIGFzIGxldmVsLXRyaWdnZXJlZApbICAgNzYu
MzEzNDIxXSBlMTAwMCAwMDAwOjAwOjAzLjA6IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2
NApbICAgNzYuODg2MDI4XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0K
WyAgIDc3LjY4NzgwN10gV0FSTklORzogQ1BVOiAwIFBJRDogNzYgYXQgL2tidWlsZC9zcmMv
Y29uc3VtZXIvZHJpdmVycy9ibG9jay9mbG9wcHkuYzo5Njggc2NoZWR1bGVfYmgrMHg0Ny8w
eDgwKCkKWyAgIDc5LjQzNTIzN10gQ1BVOiAwIFBJRDogNzYgQ29tbToga3dvcmtlci91Mjox
IE5vdCB0YWludGVkIDMuMTEuMC1yYzctMDAwMzUtZzE1NWUzYTMgIzcKWyAgIDgxLjk5NzM1
MF0gSGFyZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5
NiksIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgODQuODUyMTI4XSBXb3JrcXVldWU6IGV2
ZW50c191bmJvdW5kIGFzeW5jX3J1bl9lbnRyeV9mbgpbICAgODYuMzM5NTkwXSAgMDAwMDAw
MDAgZDNhNDVlMGMgYzI3NDViNzAgZDNhNDVlM2MgYzEwNTQ3MmQgYzJmZjBiMTAgMDAwMDAw
MDAgMDAwMDAwNGMKWyAgIDg2Ljk5NDIwMF0gIGMzMGRmNTdjIDAwMDAwM2M4IGMxYTJmYmI3
IGMxYTJmYmI3IDAwMDAwMDAxIGMxYTMzYjAwIGMzOWEwY2EwIGQzYTQ1ZTRjClsgICA4OC4y
MDQ2NjldICBjMTA1NDgxMiAwMDAwMDAwOSAwMDAwMDAwMCBkM2E0NWU1YyBjMWEyZmJiNyAw
MDAwMDAwMCAwMDAwMDAwMCBkM2E0NWU4NApbICAgODkuNzkzNDE5XSBDYWxsIFRyYWNlOgpb
ICAgOTAuODQwMTg5XSAgWzxjMjc0NWI3MD5dIGR1bXBfc3RhY2srMHgxNi8weDE4ClsgICA5
MS40MDMyOTFdICBbPGMxMDU0NzJkPl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg4ZC8weGIw
ClsgICA5MS42OTg2MjNdICBbPGMxYTJmYmI3Pl0gPyBzY2hlZHVsZV9iaCsweDQ3LzB4ODAK
WyAgIDkyLjUwMDI5OF0gIFs8YzFhMmZiYjc+XSA/IHNjaGVkdWxlX2JoKzB4NDcvMHg4MApb
ICAgOTMuMzc1NzQ0XSAgWzxjMWEzM2IwMD5dID8gZmxvcHB5X2hhcmRpbnQrMHgxYTAvMHgx
YTAKWyAgIDkzLjg2ODE4OV0gIFs8YzEwNTQ4MTI+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgy
Mi8weDMwClsgICA5NC4xMzk4MTldICBbPGMxYTJmYmI3Pl0gc2NoZWR1bGVfYmgrMHg0Ny8w
eDgwClsgICA5NC40NzM3NjVdICBbPGMxYTMzZjM1Pl0gd2FpdF90aWxfZG9uZSsweDE1LzB4
MjMwClsgICA5NC43NDM2MzVdICBbPGMxMDYzMjYwPl0gPyBjYXNjYWRlKzB4YTAvMHhhMApb
ICAgOTUuMDI3MDE5XSAgWzxjMWEzNDkzNz5dIHVzZXJfcmVzZXRfZmRjKzB4YTcvMHgxMTAK
WyAgIDk1LjY0MTExN10gIFs8YzM4NGM5Mzk+XSBmbG9wcHlfYXN5bmNfaW5pdCsweDllZS8w
eDEyNjMKWyAgIDk2LjAxODIwOF0gIFs8YzEwOGEwZTQ+XSBhc3luY19ydW5fZW50cnlfZm4r
MHg0NC8weDFlMApbICAgOTYuNTk0NjQ0XSAgWzxjMTY5MDIxMj5dID8gX19saXN0X2RlbF9l
bnRyeSsweDIwMi8weDIyMApbICAgOTcuNDAzNTUzXSAgWzxjMTA3NTY4Nz5dID8gcHdxX2Rl
Y19ucl9pbl9mbGlnaHQrMHgxMzcvMHgxNDAKWyAgIDk4LjE5MzczMV0gIFs8YzEwNzVmNWI+
XSBwcm9jZXNzX29uZV93b3JrKzB4MzNiLzB4ODQwClsgIDEwMi4wNjk2MjVdICBbPGMxMDhm
NTQyPl0gPyB0dHd1X2RvX3dha2V1cCsweDEyLzB4OTAKWyAgMTA2LjM5NDg0NV0gIFs8YzE2
OTAyMTI+XSA/IF9fbGlzdF9kZWxfZW50cnkrMHgyMDIvMHgyMjAKWyAgMTA5LjAxMDQ5MV0g
IFs8YzEwNzY4NzQ+XSB3b3JrZXJfdGhyZWFkKzB4NDE0LzB4ODkwClsgIDExMS45MDEzODFd
ICBbPGMxMDc2NDYwPl0gPyBwcm9jZXNzX29uZV93b3JrKzB4ODQwLzB4ODQwClsgIDExMy4y
MDM2OTNdICBbPGMxMDgwYmE2Pl0ga3RocmVhZCsweGE2LzB4YjAKWyAgMTE2LjYxMzE4OV0g
IFs8YzI3NjNmYjc+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MWIvMHgyOApbICAxMTgu
MDY2NzcwXSAgWzxjMTA4MGIwMD5dID8gX19rdGhyZWFkX3VucGFyaysweDcwLzB4NzAKWyAg
MTE4Ljk4MTE4NF0gLS0tWyBlbmQgdHJhY2UgZjBkZTE2MzBlYmYxMzZmYiBdLS0tClsgIDEy
MC4yMjAxMjZdIGZsb3BweTA6IG5vIGZsb3BweSBjb250cm9sbGVycyBmb3VuZAova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS8xNTVlM2EzNTM5NDNhM2U3MTNjZDMzMzU3
Y2ZkNThlOTk1OTAwYTgxL2RtZXNnLXF1YW50YWwtaXZiNDEtMTI6MjAxNDA3MDcxNDQ5Mzk6
aTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1OjoKMTM6MToxIGFsbF9nb29kOmJhZDphbGxf
YmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDkgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0
aGlzIChyb3VnaGx5IDQgc3RlcHMpCltmZjQ5NzQ1MjYzNmY0Njg3ZTUxNzk2NDgxN2I3ZTJi
ZDk5ZjRiNDRiXSBNZXJnZSBicmFuY2ggJ2Zvci0zLjExLWZpeGVzJyBvZiBnaXQ6Ly9naXQu
a2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGovd3EKcnVubmluZyAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0
L2xpbnV4My9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9p
Mzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIw
MTQwNzA3MDg6ZmY0OTc0NTI2MzZmNDY4N2U1MTc5NjQ4MTdiN2UyYmQ5OWY0YjQ0YjpiaXNl
Y3QtbGludXgzCgoyMDE0LTA3LTA3LTE0OjUwOjMxIGZmNDk3NDUyNjM2ZjQ2ODdlNTE3OTY0
ODE3YjdlMmJkOTlmNGI0NGIgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVp
bGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1LWZmNDk3
NDUyNjM2ZjQ2ODdlNTE3OTY0ODE3YjdlMmJkOTlmNGI0NGIKQ2hlY2sgZm9yIGtlcm5lbCBp
biAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS9mZjQ5NzQ1MjYzNmY0Njg3
ZTUxNzk2NDgxN2I3ZTJiZDk5ZjRiNDRiCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2ti
dWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUtZmY0
OTc0NTI2MzZmNDY4N2U1MTc5NjQ4MTdiN2UyYmQ5OWY0YjQ0Ygp3YWl0aW5nIGZvciBjb21w
bGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvY2Fpcm8tc21va2UvaTM4Ni1y
YW5kY29uZmlnLWMxLTA3MDcwOTM1LWZmNDk3NDUyNjM2ZjQ2ODdlNTE3OTY0ODE3YjdlMmJk
OTlmNGI0NGIKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS9m
ZjQ5NzQ1MjYzNmY0Njg3ZTUxNzk2NDgxN2I3ZTJiZDk5ZjRiNDRiL3ZtbGludXotMy4xMS4w
LXJjNy0wMDAyOC1nZmY0OTc0NQoKMjAxNC0wNy0wNy0xNDo1NDozMSBkZXRlY3RpbmcgYm9v
dCBzdGF0ZSAuLi4uLi4uLi4uLi4uLi4uLi4JMwk2CTcJMjAJMzEJNDggVEVTVCBGQUlMVVJF
ClsgICA4Ni4yNDgxNDldIFBDSTogc2V0dGluZyBJUlEgMTEgYXMgbGV2ZWwtdHJpZ2dlcmVk
ClsgICA4Ni40ODkwODRdIGUxMDAwIDAwMDA6MDA6MDMuMDogc2V0dGluZyBsYXRlbmN5IHRp
bWVyIHRvIDY0ClsgICA4Ni43NzExNDFdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0t
LS0tLS0tLQpbICAgODguODI4MDk4XSBXQVJOSU5HOiBDUFU6IDAgUElEOiA3NiBhdCAva2J1
aWxkL3NyYy9zbW9rZS9kcml2ZXJzL2Jsb2NrL2Zsb3BweS5jOjk2OCBzY2hlZHVsZV9iaCsw
eDQ3LzB4ODAoKQpbICAgOTUuNTg4MTg4XSBDUFU6IDAgUElEOiA3NiBDb21tOiBrd29ya2Vy
L3UyOjEgTm90IHRhaW50ZWQgMy4xMS4wLXJjNy0wMDAyOC1nZmY0OTc0NSAjMQpbICAgOTku
NTk1MzExXSBIYXJkd2FyZSBuYW1lOiBRRU1VIFN0YW5kYXJkIFBDIChpNDQwRlggKyBQSUlY
LCAxOTk2KSwgQklPUyBCb2NocyAwMS8wMS8yMDExClsgIDExMS42OTU5NThdIFdvcmtxdWV1
ZTogZXZlbnRzX3VuYm91bmQgYXN5bmNfcnVuX2VudHJ5X2ZuClsgIDExNC44MDc0NjFdICAw
MDAwMDAwMCBkM2E0NWUwYyBjMjc0NWIxMCBkM2E0NWUzYyBjMTA1NDcyZCBjMmZmMDhlMCAw
MDAwMDAwMCAwMDAwMDA0YwpbICAxMTcuNjEzMDY3XSAgYzMwZGRkODAgMDAwMDAzYzggYzFh
MmZiNTcgYzFhMmZiNTcgMDAwMDAwMDEgYzFhMzNhYTAgYzM5OWNjYTAgZDNhNDVlNGMKWyAg
MTE5LjkzMDY2NF0gIGMxMDU0ODEyIDAwMDAwMDA5IDAwMDAwMDAwIGQzYTQ1ZTVjIGMxYTJm
YjU3IDAwMDAwMDAwIDAwMDAwMDAwIGQzYTQ1ZTg0ClsgIDEyMS4yNDYxNTBdIENhbGwgVHJh
Y2U6ClsgIDEyMS45NTY5MzhdICBbPGMyNzQ1YjEwPl0gZHVtcF9zdGFjaysweDE2LzB4MTgK
WyAgMTIyLjY0Mjg3MF0gIFs8YzEwNTQ3MmQ+XSB3YXJuX3Nsb3dwYXRoX2NvbW1vbisweDhk
LzB4YjAKWyAgMTIyLjk2MTkzMl0gIFs8YzFhMmZiNTc+XSA/IHNjaGVkdWxlX2JoKzB4NDcv
MHg4MApbICAxMjYuNjA2NDkyXSAgWzxjMWEyZmI1Nz5dID8gc2NoZWR1bGVfYmgrMHg0Ny8w
eDgwClsgIDEyNy4zMzg3NjRdICBbPGMxYTMzYWEwPl0gPyBmbG9wcHlfaGFyZGludCsweDFh
MC8weDFhMApbICAxMzEuODgyNjUyXSAgWzxjMTA1NDgxMj5dIHdhcm5fc2xvd3BhdGhfbnVs
bCsweDIyLzB4MzAKWyAgMTMyLjQ2Nzc5OF0gIFs8YzFhMmZiNTc+XSBzY2hlZHVsZV9iaCsw
eDQ3LzB4ODAKWyAgMTM0LjE4NzMwMV0gIFs8YzFhMzNlZDU+XSB3YWl0X3RpbF9kb25lKzB4
MTUvMHgyMzAKWyAgMTM0Ljk5NTk4N10gIFs8YzEwNjMyNjA+XSA/IGNhc2NhZGUrMHhhMC8w
eGEwClsgIDEzNS43OTE1MTBdICBbPGMxYTM0OGQ3Pl0gdXNlcl9yZXNldF9mZGMrMHhhNy8w
eDExMApbICAxMzYuNDk2NTEwXSAgWzxjMzg0ODkzOT5dIGZsb3BweV9hc3luY19pbml0KzB4
OWVlLzB4MTI2MwpbICAxMzcuNDkyMDcwXSAgWzxjMTA4YTBlND5dIGFzeW5jX3J1bl9lbnRy
eV9mbisweDQ0LzB4MWUwClsgIDEzNy43NzE2MzddICBbPGMxNjkwMWIyPl0gPyBfX2xpc3Rf
ZGVsX2VudHJ5KzB4MjAyLzB4MjIwClsgIDEzOC4wODA5ODVdICBbPGMxMDc1Njg3Pl0gPyBw
d3FfZGVjX25yX2luX2ZsaWdodCsweDEzNy8weDE0MApbICAxMzkuNDc0NjIyXSAgWzxjMTA3
NWY1Yj5dIHByb2Nlc3Nfb25lX3dvcmsrMHgzM2IvMHg4NDAKWyAgMTQxLjE4MDE2Ml0gIFs8
YzEwOGY1NDI+XSA/IHR0d3VfZG9fd2FrZXVwKzB4MTIvMHg5MApbICAxNDIuMDk3NTI4XSAg
WzxjMTY5MDFiMj5dID8gX19saXN0X2RlbF9lbnRyeSsweDIwMi8weDIyMApbICAxNDMuOTEy
NjY1XSAgWzxjMTA3Njg3ND5dIHdvcmtlcl90aHJlYWQrMHg0MTQvMHg4OTAKWyAgMTQ1LjY2
NjY4N10gIFs8YzEwNzY0NjA+XSA/IHByb2Nlc3Nfb25lX3dvcmsrMHg4NDAvMHg4NDAKWyAg
MTQ3LjMzODQyOF0gIFs8YzEwODBiYTY+XSBrdGhyZWFkKzB4YTYvMHhiMApbICAxNDkuMzIz
NzgwXSAgWzxjMjc2M2Y1Nz5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDI4Clsg
IDE1Mi42NzkzODVdICBbPGMxMDgwYjAwPl0gPyBfX2t0aHJlYWRfdW5wYXJrKzB4NzAvMHg3
MApbICAxNTUuODkzMDgwXSAtLS1bIGVuZCB0cmFjZSA3ZWFhMzYwZTJjZDU3NmUzIF0tLS0K
WyAgMTU5LjU3ODY2OV0gZmxvcHB5MDogbm8gZmxvcHB5IGNvbnRyb2xsZXJzIGZvdW5kCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1L2ZmNDk3NDUyNjM2ZjQ2ODdlNTE3
OTY0ODE3YjdlMmJkOTlmNGI0NGIvZG1lc2ctcXVhbnRhbC1pdmI0MS0xMDI6MjAxNDA3MDcx
NTA1Mjc6aTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1OjoKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYzEtMDcwNzA5MzUvZmY0OTc0NTI2MzZmNDY4N2U1MTc5NjQ4MTdiN2UyYmQ5OWY0
YjQ0Yi9kbWVzZy15b2N0by1pdmI0MS0zMDoyMDE0MDcwNzE1MDUzNzppMzg2LXJhbmRjb25m
aWctYzEtMDcwNzA5MzU6Ogo0ODoyOjIgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCmxp
bmVhci1iaXNlY3Q6IGJhZCBicmFuY2ggbWF5IGJlIGJyYW5jaCAnZm9yLTMuMTEtZml4ZXMn
IG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90ai93
cQpsaW5lYXItYmlzZWN0OiBoYW5kbGUgb3ZlciB0byBnaXQgYmlzZWN0CmxpbmVhci1iaXNl
Y3Q6IGdpdCBiaXNlY3Qgc3RhcnQgZmY0OTc0NTI2MzZmNDY4N2U1MTc5NjQ4MTdiN2UyYmQ5
OWY0YjQ0YiAwNmE1NTdmN2E2OGUxMjYxODFmMDk4MzFjYjJmYWM2ZjdhN2Y0M2MyIC0tClBy
ZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIGZmNDk3NDUuLi4gTWVyZ2UgYnJhbmNoICdmb3It
My4xMS1maXhlcycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJu
ZWwvZ2l0L3RqL3dxCkhFQUQgaXMgbm93IGF0IDU0YWY2MWQuLi4gTWVyZ2UgYnJhbmNoICdh
a3BtLWN1cnJlbnQvY3VycmVudCcKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAwIHN0ZXBzKQpbYjIyY2UyNzg1ZDk3NDIzODQ2MjA2
Y2NlZWM0ZWZlZTBjNGFmZDk4MF0gd29ya3F1ZXVlOiBjb25kX3Jlc2NoZWQoKSBhZnRlciBw
cm9jZXNzaW5nIGVhY2ggd29yayBpdGVtCmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3QgcnVu
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1i
aXNlY3QvbGludXgzL29iai1iaXNlY3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4My9vYmotYmlzZWN0
CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctYzEt
MDcwNzA5MzUvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwNzA3MDg6YjIyY2UyNzg1
ZDk3NDIzODQ2MjA2Y2NlZWM0ZWZlZTBjNGFmZDk4MDpiaXNlY3QtbGludXgzCgoyMDE0LTA3
LTA3LTE1OjA4OjMxIGIyMmNlMjc4NWQ5NzQyMzg0NjIwNmNjZWVjNGVmZWUwYzRhZmQ5ODAg
Y29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVl
dWUvaTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1LWIyMmNlMjc4NWQ5NzQyMzg0NjIwNmNj
ZWVjNGVmZWUwYzRhZmQ5ODAKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1jMS0wNzA3MDkzNS9iMjJjZTI3ODVkOTc0MjM4NDYyMDZjY2VlYzRlZmVlMGM0
YWZkOTgwCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUtYjIyY2UyNzg1ZDk3NDIzODQ2MjA2
Y2NlZWM0ZWZlZTBjNGFmZDk4MAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUvamFrZXRvd24tY29uc3VtZXIvaTM4Ni1yYW5kY29uZmlnLWMx
LTA3MDcwOTM1LWIyMmNlMjc4NWQ5NzQyMzg0NjIwNmNjZWVjNGVmZWUwYzRhZmQ5ODAKa2Vy
bmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS9iMjJjZTI3ODVkOTc0
MjM4NDYyMDZjY2VlYzRlZmVlMGM0YWZkOTgwL3ZtbGludXotMy4xMS4wLXJjNy0wMDAyNS1n
YjIyY2UyNwoKMjAxNC0wNy0wNy0xNTo0NjozMSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4u
LgkyLgk2CTEzIFRFU1QgRkFJTFVSRQpbICAgNjMuMTg0NTE2XSBQQ0k6IHNldHRpbmcgSVJR
IDExIGFzIGxldmVsLXRyaWdnZXJlZApbICAgNjMuNDIyMTk5XSBlMTAwMCAwMDAwOjAwOjAz
LjA6IHNldHRpbmcgbGF0ZW5jeSB0aW1lciB0byA2NApbICAgNjMuNzAzMTg5XSAtLS0tLS0t
LS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgIDYzLjk4NjU3MF0gV0FSTklORzog
Q1BVOiAwIFBJRDogNzYgYXQgL2tidWlsZC9zcmMvY29uc3VtZXIvZHJpdmVycy9ibG9jay9m
bG9wcHkuYzo5Njggc2NoZWR1bGVfYmgrMHg0Ny8weDgwKCkKWyAgIDY0LjUzMjQ2Ml0gQ1BV
OiAwIFBJRDogNzYgQ29tbToga3dvcmtlci91MjoxIE5vdCB0YWludGVkIDMuMTEuMC1yYzct
MDAwMjUtZ2IyMmNlMjcgIzgKWyAgIDY1LjE4NDI2Ml0gSGFyZHdhcmUgbmFtZTogUUVNVSBT
dGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5NiksIEJJT1MgQm9jaHMgMDEvMDEvMjAx
MQpbICAgNjYuMDc2MzQ5XSBXb3JrcXVldWU6IGV2ZW50c191bmJvdW5kIGFzeW5jX3J1bl9l
bnRyeV9mbgpbICAgNjYuMzc1Mjk5XSAgMDAwMDAwMDAgZDNhNDNlMGMgYzI3NDViMTAgZDNh
NDNlM2MgYzEwNTQ3MmQgYzJmZjBiMTAgMDAwMDAwMDAgMDAwMDAwNGMKWyAgIDY3LjAwMjU2
Ml0gIGMzMGRmNTdjIDAwMDAwM2M4IGMxYTJmYjU3IGMxYTJmYjU3IDAwMDAwMDAxIGMxYTMz
YWEwIGMzOWEwY2EwIGQzYTQzZTRjClsgICA2OS43MjA4NjBdICBjMTA1NDgxMiAwMDAwMDAw
OSAwMDAwMDAwMCBkM2E0M2U1YyBjMWEyZmI1NyAwMDAwMDAwMCAwMDAwMDAwMCBkM2E0M2U4
NApbICAgNzQuNTAxMDA5XSBDYWxsIFRyYWNlOgpbICAgNzYuNTg1NjkwXSAgWzxjMjc0NWIx
MD5dIGR1bXBfc3RhY2srMHgxNi8weDE4ClsgICA3Ny4yODM3NjRdICBbPGMxMDU0NzJkPl0g
d2Fybl9zbG93cGF0aF9jb21tb24rMHg4ZC8weGIwClsgICA3OC4zNDI1NTBdICBbPGMxYTJm
YjU3Pl0gPyBzY2hlZHVsZV9iaCsweDQ3LzB4ODAKWyAgIDgwLjQxMTE2NV0gIFs8YzFhMmZi
NTc+XSA/IHNjaGVkdWxlX2JoKzB4NDcvMHg4MApbICAgODEuODI3NTIyXSAgWzxjMWEzM2Fh
MD5dID8gZmxvcHB5X2hhcmRpbnQrMHgxYTAvMHgxYTAKWyAgIDgyLjU2OTQ4NF0gIFs8YzEw
NTQ4MTI+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgyMi8weDMwClsgICA4Mi44MzQwMDNdICBb
PGMxYTJmYjU3Pl0gc2NoZWR1bGVfYmgrMHg0Ny8weDgwClsgICA4My4xMDA1ODddICBbPGMx
YTMzZWQ1Pl0gd2FpdF90aWxfZG9uZSsweDE1LzB4MjMwClsgICA4My4zNjgyNDhdICBbPGMx
MDYzMjYwPl0gPyBjYXNjYWRlKzB4YTAvMHhhMApbICAgODMuNjI0MTYwXSAgWzxjMWEzNDhk
Nz5dIHVzZXJfcmVzZXRfZmRjKzB4YTcvMHgxMTAKWyAgIDgzLjg4ODMxNl0gIFs8YzM4NGM5
Mzk+XSBmbG9wcHlfYXN5bmNfaW5pdCsweDllZS8weDEyNjMKWyAgIDg0LjE0ODU1M10gIFs8
YzEwOGEwZTQ+XSBhc3luY19ydW5fZW50cnlfZm4rMHg0NC8weDFlMApbICAgODQuNDE0OTkx
XSAgWzxjMTY5MDFiMj5dID8gX19saXN0X2RlbF9lbnRyeSsweDIwMi8weDIyMApbICAgODQu
NjY5MDc3XSAgWzxjMTA3NTY4Nz5dID8gcHdxX2RlY19ucl9pbl9mbGlnaHQrMHgxMzcvMHgx
NDAKWyAgIDg0LjkzMDAyOV0gIFs8YzEwNzVmNWI+XSBwcm9jZXNzX29uZV93b3JrKzB4MzNi
LzB4ODQwClsgICA4NS40OTU2NjBdICBbPGMxMDhmNTQyPl0gPyB0dHd1X2RvX3dha2V1cCsw
eDEyLzB4OTAKWyAgIDg2LjMxMDM2Ml0gIFs8YzE2OTAxYjI+XSA/IF9fbGlzdF9kZWxfZW50
cnkrMHgyMDIvMHgyMjAKWyAgIDg3LjE0ODg2OF0gIFs8YzEwNzY4NzQ+XSB3b3JrZXJfdGhy
ZWFkKzB4NDE0LzB4ODkwClsgICA4Ny45NTg2MDZdICBbPGMxMDc2NDYwPl0gPyBwcm9jZXNz
X29uZV93b3JrKzB4ODQwLzB4ODQwClsgICA4OC43NTUxNDJdICBbPGMxMDgwYmE2Pl0ga3Ro
cmVhZCsweGE2LzB4YjAKWyAgIDg5LjUwOTEyM10gIFs8YzI3NjNmNTc+XSByZXRfZnJvbV9r
ZXJuZWxfdGhyZWFkKzB4MWIvMHgyOApbICAgODkuODc5NTIyXSAgWzxjMTA4MGIwMD5dID8g
X19rdGhyZWFkX3VucGFyaysweDcwLzB4NzAKWyAgIDkwLjEyMzc5OF0gLS0tWyBlbmQgdHJh
Y2UgYTNiN2FhMjNhY2E0OGFkNCBdLS0tClsgICA5MC4zNjYxMjJdIGZsb3BweTA6IG5vIGZs
b3BweSBjb250cm9sbGVycyBmb3VuZAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3
MDkzNS9iMjJjZTI3ODVkOTc0MjM4NDYyMDZjY2VlYzRlZmVlMGM0YWZkOTgwL2RtZXNnLXF1
YW50YWwtaXZiNDEtNTE6MjAxNDA3MDcxNTQ5NTU6aTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcw
OTM1OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUvYjIyY2UyNzg1ZDk3
NDIzODQ2MjA2Y2NlZWM0ZWZlZTBjNGFmZDk4MC9kbWVzZy15b2N0by1pdmI0MS0yOToyMDE0
MDcwNzE1NDk1MjppMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzU6OgoxMzoyOjIgYWxsX2dv
b2Q6YmFkOmFsbF9iYWQgYm9vdHMKCmIyMmNlMjc4NWQ5NzQyMzg0NjIwNmNjZWVjNGVmZWUw
YzRhZmQ5ODAgaXMgdGhlIGZpcnN0IGJhZCBjb21taXQKY29tbWl0IGIyMmNlMjc4NWQ5NzQy
Mzg0NjIwNmNjZWVjNGVmZWUwYzRhZmQ5ODAKQXV0aG9yOiBUZWp1biBIZW8gPHRqQGtlcm5l
bC5vcmc+CkRhdGU6ICAgV2VkIEF1ZyAyOCAxNzozMzozNyAyMDEzIC0wNDAwCgogICAgd29y
a3F1ZXVlOiBjb25kX3Jlc2NoZWQoKSBhZnRlciBwcm9jZXNzaW5nIGVhY2ggd29yayBpdGVt
CiAgICAKICAgIElmICFQUkVFTVBULCBhIGt3b3JrZXIgcnVubmluZyB3b3JrIGl0ZW1zIGJh
Y2sgdG8gYmFjayBjYW4gaG9nIENQVS4KICAgIFRoaXMgYmVjb21lcyBkYW5nZXJvdXMgd2hl
biBhIHNlbGYtcmVxdWV1ZWluZyB3b3JrIGl0ZW0gd2hpY2ggaXMKICAgIHdhaXRpbmcgZm9y
IHNvbWV0aGluZyB0byBoYXBwZW4gcmFjZXMgYWdhaW5zdCBzdG9wX21hY2hpbmUuICBTdWNo
CiAgICBzZWxmLXJlcXVldWVpbmcgd29yayBpdGVtIHdvdWxkIHJlcXVldWUgaXRzZWxmIGlu
ZGVmaW5pdGVseSBob2dnaW5nCiAgICB0aGUga3dvcmtlciBhbmQgQ1BVIGl0J3MgcnVubmlu
ZyBvbiB3aGlsZSBzdG9wX21hY2hpbmUgd291bGQgd2FpdCBmb3IKICAgIHRoYXQgQ1BVIHRv
IGVudGVyIHN0b3BfbWFjaGluZSB3aGlsZSBwcmV2ZW50aW5nIGFueXRoaW5nIGVsc2UgZnJv
bQogICAgaGFwcGVuaW5nIG9uIGFsbCBvdGhlciBDUFVzLiAgVGhlIHR3byB3b3VsZCBkZWFk
bG9jay4KICAgIAogICAgSmFtaWUgTGl1IHJlcG9ydHMgdGhhdCB0aGlzIGRlYWRsb2NrIHNj
ZW5hcmlvIGV4aXN0cyBhcm91bmQKICAgIHNjc2lfcmVxdWV1ZV9ydW5fcXVldWUoKSBhbmQg
bGliYXRhIHBvcnQgbXVsdGlwbGllciBzdXBwb3J0LCB3aGVyZSBvbmUKICAgIHBvcnQgbWF5
IGV4Y2x1ZGUgY29tbWFuZCBwcm9jZXNzaW5nIGZyb20gb3RoZXIgcG9ydHMuICBXaXRoIHRo
ZSByaWdodAogICAgdGltaW5nLCBzY3NpX3JlcXVldWVfcnVuX3F1ZXVlKCkgY2FuIGVuZCB1
cCByZXF1ZXVlaW5nIGl0c2VsZiB0cnlpbmcKICAgIHRvIGV4ZWN1dGUgYW4gSU8gd2hpY2gg
aXMgYXNrZWQgdG8gYmUgcmV0cmllZCB3aGlsZSBhbm90aGVyIGRldmljZSBoYXMKICAgIGFu
IGV4Y2x1c2l2ZSBhY2Nlc3MsIHdoaWNoIGluIHR1cm4gY2FuJ3QgbWFrZSBmb3J3YXJkIHBy
b2dyZXNzIGR1ZSB0bwogICAgc3RvcF9tYWNoaW5lLgogICAgCiAgICBGaXggaXQgYnkgaW52
b2tpbmcgY29uZF9yZXNjaGVkKCkgYWZ0ZXIgZXhlY3V0aW5nIGVhY2ggd29yayBpdGVtLgog
ICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBUZWp1biBIZW8gPHRqQGtlcm5lbC5vcmc+CiAgICBS
ZXBvcnRlZC1ieTogSmFtaWUgTGl1IDxqYW1pZWxpdUBnb29nbGUuY29tPgogICAgUmVmZXJl
bmNlczogaHR0cDovL3RocmVhZC5nbWFuZS5vcmcvZ21hbmUubGludXgua2VybmVsLzE1NTI1
NjcKICAgIENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnCiAgICAtLQogICAgIGtlcm5lbC93
b3JrcXVldWUuYyB8ICAgIDkgKysrKysrKysrCiAgICAgMSBmaWxlIGNoYW5nZWQsIDkgaW5z
ZXJ0aW9ucygrKQoKOjA0MDAwMCAwNDAwMDAgNDZhMjAzN2ZmNTgwM2NiZTU4YjM3NDM2ZDQz
YmE0Y2M3YjMzYzcwZSAyZGNhYTJkNjBjZDZhNDQxMzMyMWZiMDE0ZmRiYmJiNzNmM2RiNjRl
IE0Ja2VybmVsCmJpc2VjdCBydW4gc3VjY2VzcwpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdh
cyBiMjJjZTI3Li4uIHdvcmtxdWV1ZTogY29uZF9yZXNjaGVkKCkgYWZ0ZXIgcHJvY2Vzc2lu
ZyBlYWNoIHdvcmsgaXRlbQpIRUFEIGlzIG5vdyBhdCBjOTUzODliLi4uIE1lcmdlIGJyYW5j
aCAnYWtwbScgKHBhdGNoZXMgZnJvbSBBbmRyZXcgTW9ydG9uKQpscyAtYSAva2J1aWxkLXRl
c3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1L2xpbnV4LWRl
dmVsOmRldmVsLWhvdXJseS0yMDE0MDcwNzA4OmM5NTM4OWI0Y2Q2YTRiNTJhZjc4YmVhNzA2
YTI3NDQ1M2U4ODYyNTE6YmlzZWN0LWxpbnV4MwoKMjAxNC0wNy0wNy0xNTo1MTowMyBjOTUz
ODliNGNkNmE0YjUyYWY3OGJlYTcwNmEyNzQ0NTNlODg2MjUxIGNvbXBpbGluZwpRdWV1ZWQg
YnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZp
Zy1jMS0wNzA3MDkzNS1jOTUzODliNGNkNmE0YjUyYWY3OGJlYTcwNmEyNzQ0NTNlODg2MjUx
CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5
MzUvYzk1Mzg5YjRjZDZhNGI1MmFmNzhiZWE3MDZhMjc0NDUzZTg4NjI1MQp3YWl0aW5nIGZv
ciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29u
ZmlnLWMxLTA3MDcwOTM1LWM5NTM4OWI0Y2Q2YTRiNTJhZjc4YmVhNzA2YTI3NDQ1M2U4ODYy
NTEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
L2NhaXJvLXNtb2tlL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS1jOTUzODliNGNkNmE0
YjUyYWY3OGJlYTcwNmEyNzQ0NTNlODg2MjUxCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYzEtMDcwNzA5MzUvYzk1Mzg5YjRjZDZhNGI1MmFmNzhiZWE3MDZhMjc0NDUzZTg4
NjI1MS92bWxpbnV6LTMuMTEuMC1yYzctMDAwMjQtZ2M5NTM4OWIKCjIwMTQtMDctMDctMTY6
MDU6MDMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLgkxCTIJMwk1CTE5CTM1CTQ0CTYwCTc4
CTEwMQkxMTUJMTI0CTEyNQkxMjgJMTM0CTE0MQkxNDgJMTU3CTE2OAkxODUJMjA0CTIyNAky
NDQJMjQ1CTI1NAkyNTkJMjcxCTI3OQkyODYJMjk3CTMwNgkzMjEJMzMwCTM0MwkzNjIJMzcy
CTM5MgkzOTgJNDA5CTQxNAk0MTYJNDIwCTQyNAk0MjkJNDQ3CTQ3MAk0ODMJNTAzCTUxMAk1
MTgJNTI0CTUzMgk1MzUJNTQxCTU1Mwk1NzYJNTg1CTU5Nwk2MTQJNjIwCTYyNgk2MzQJNjQ0
CTY1Mwk2NjIJNjY3CTY4Mgk2OTgJNzEyCTcyNQk3MzQJNzQyCTc0OQk3NTUJNzY1CTc3Mgk3
ODYJNzkzCTc5OAk4MjQJODM1CTg0NAk4NTUJODY1CTg4MAk4ODgJODk5CTkwMCBTVUNDRVNT
CgpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBjOTUzODliLi4uIE1lcmdlIGJyYW5jaCAn
YWtwbScgKHBhdGNoZXMgZnJvbSBBbmRyZXcgTW9ydG9uKQpIRUFEIGlzIG5vdyBhdCA5ODYx
MDk2Li4uIDBkYXkgaGVhZCBndWFyZCBmb3IgJ2RldmVsLWhvdXJseS0yMDE0MDcwNzA4Jwps
cyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWMxLTA3
MDcwOTM1L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDcwNzA4Ojk4NjEwOTYyYmJi
NDE4ZjZkODQ3YzQwMjYzN2NhMTRlNzhjMzgzNDQ6YmlzZWN0LWxpbnV4MwogVEVTVCBGQUlM
VVJFClsgICAzNy4zMDAyNjJdIElPQVBJQ1swXTogU2V0IHJvdXRpbmcgZW50cnkgKDAtMTEg
LT4gMHgzYiAtPiBJUlEgMTEgTW9kZToxIEFjdGl2ZTowIERlc3Q6MSkKWyAgIDM3Ljc4OTU3
OV0gbm8gY29udCBpbiBzaHV0ZG93biEKWyAgIDM4LjA5MjM1NF0gLS0tLS0tLS0tLS0tWyBj
dXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAzOC4zOTE3ODhdIFdBUk5JTkc6IENQVTogMCBQ
SUQ6IDgyIGF0IC9rYnVpbGQvc3JjL3Ntb2tlL2RyaXZlcnMvYmxvY2svZmxvcHB5LmM6OTc1
IHNjaGVkdWxlX2JoKzB4NDcvMHg4MCgpClsgICAzOS4xMTc5NzBdIENQVTogMCBQSUQ6IDgy
IENvbW06IGt3b3JrZXIvdTI6MSBOb3QgdGFpbnRlZCAzLjE2LjAtcmM0LTAyMDAxLWc5ODYx
MDk2ICMyODYKWyAgIDM5Ljc3NjAxMF0gSGFyZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQ
QyAoaTQ0MEZYICsgUElJWCwgMTk5NiksIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgNDAu
NDUxNzY5XSBXb3JrcXVldWU6IGV2ZW50c191bmJvdW5kIGFzeW5jX3J1bl9lbnRyeV9mbgpb
ICAgNDAuNzQ2NDQ4XSAgMDAwMDAwMDAgY2NhZDllMTggYzI5MWVlZmMgY2NhZDllNDggYzEw
NjFhMWQgYzMyYTEyZDggMDAwMDAwMDAgMDAwMDAwNTIKWyAgIDQxLjM1OTAzOV0gIGMzMzNi
ZjQwIDAwMDAwM2NmIGMxYWRlMDk3IGMxYWRlMDk3IDAwMDAwMDAxIGMxYWRmOGEwIGMzZDA2
MTYwIGNjYWQ5ZTU4ClsgICA0MS45OTkwMzRdICBjMTA2MWIwMiAwMDAwMDAwOSAwMDAwMDAw
MCBjY2FkOWU2OCBjMWFkZTA5NyAwMDAwMDAwMCAwMDAwMDAwMCBjY2FkOWU4OApbICAgNDIu
NjU3NTUwXSBDYWxsIFRyYWNlOgpbICAgNDIuOTU4MzkwXSAgWzxjMjkxZWVmYz5dIGR1bXBf
c3RhY2srMHgxNi8weDE4ClsgICA0My4yNTY0NDldICBbPGMxMDYxYTFkPl0gd2Fybl9zbG93
cGF0aF9jb21tb24rMHg4ZC8weGIwClsgICA0My41NTQ2NjFdICBbPGMxYWRlMDk3Pl0gPyBz
Y2hlZHVsZV9iaCsweDQ3LzB4ODAKWyAgIDQzLjgzODgxMF0gIFs8YzFhZGUwOTc+XSA/IHNj
aGVkdWxlX2JoKzB4NDcvMHg4MApbICAgNDQuMTEwOTY0XSAgWzxjMWFkZjhhMD5dID8gbG9j
a19mZGMuaXNyYS4xMisweDFiMC8weDFiMApbICAgNDQuMzgyMjI5XSAgWzxjMTA2MWIwMj5d
IHdhcm5fc2xvd3BhdGhfbnVsbCsweDIyLzB4MzAKWyAgIDQ0LjY0OTQxNF0gIFs8YzFhZGUw
OTc+XSBzY2hlZHVsZV9iaCsweDQ3LzB4ODAKWyAgIDQ0LjkxMzg5Nl0gIFs8YzFhZGZjYzM+
XSB3YWl0X3RpbF9kb25lKzB4MTMvMHgyMDAKWyAgIDQ1LjE3ODA3NF0gIFs8YzEwNmZkMjA+
XSA/IGNhc2NhZGUrMHhhMC8weGEwClsgICA0NS40NDY5NzRdICBbPGMxYWUwNTg3Pl0gdXNl
cl9yZXNldF9mZGMrMHhhNy8weDExMApbICAgNDUuNzE1OTY5XSAgWzxjM2JiYjYwOT5dIGZs
b3BweV9hc3luY19pbml0KzB4OWRlLzB4MTI1NgpbICAgNDUuOTg3MzQ2XSAgWzxjMTA5NDk3
ND5dIGFzeW5jX3J1bl9lbnRyeV9mbisweDQ0LzB4MWQwClsgICA0Ni4yNDk0MTVdICBbPGMx
NmQzMTEyPl0gPyBfX2xpc3RfZGVsX2VudHJ5KzB4MjAyLzB4MjIwClsgICA0Ni41MDM2NTZd
ICBbPGMxMDgyNGVmPl0gPyBwd3FfZGVjX25yX2luX2ZsaWdodCsweDEwZi8weDEzMApbICAg
NDYuNzYxMzM5XSAgWzxjMTA4MmI1Mj5dIHByb2Nlc3Nfb25lX3dvcmsrMHgzMjIvMHg4MDAK
WyAgIDQ3LjAyODA0NV0gIFs8YzE2ZDMxMTI+XSA/IF9fbGlzdF9kZWxfZW50cnkrMHgyMDIv
MHgyMjAKWyAgIDQ3LjI5NDIzNF0gIFs8YzEwODM1ZjQ+XSB3b3JrZXJfdGhyZWFkKzB4NWM0
LzB4YjIwClsgICA0Ny41NzE2OTJdICBbPGMxMDgzMDMwPl0gPyBwcm9jZXNzX29uZV93b3Jr
KzB4ODAwLzB4ODAwClsgICA0OC4wODU5ODVdICBbPGMxMDhjMTYyPl0ga3RocmVhZCsweGUy
LzB4ZjAKWyAgIDQ4LjM1MjM3MF0gIFs8YzEwODMwMzA+XSA/IHByb2Nlc3Nfb25lX3dvcmsr
MHg4MDAvMHg4MDAKWyAgIDQ4LjU4NzY3NV0gIFs8YzI5M2Q3NDA+XSByZXRfZnJvbV9rZXJu
ZWxfdGhyZWFkKzB4MjAvMHgzMApbICAgNDguODAzNDQ4XSAgWzxjMTA4YzA4MD5dID8gX19r
dGhyZWFkX3VucGFyaysweDcwLzB4NzAKWyAgIDQ5LjAxMTM4M10gLS0tWyBlbmQgdHJhY2Ug
ZjUzNzI5N2NiNzIzYWFjOCBdLS0tClsgICA0OS4xOTk3NDhdIGZsb3BweTA6IG5vIGZsb3Bw
eSBjb250cm9sbGVycyBmb3VuZAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkz
NS85ODYxMDk2MmJiYjQxOGY2ZDg0N2M0MDI2MzdjYTE0ZTc4YzM4MzQ0L2RtZXNnLXF1YW50
YWwtaXZiNDEtNDoyMDE0MDcwNzEwNTYwMDppMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzU6
Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS85ODYxMDk2MmJiYjQxOGY2
ZDg0N2M0MDI2MzdjYTE0ZTc4YzM4MzQ0L2RtZXNnLXF1YW50YWwtaXZiNDMtMTA3OjIwMTQw
NzA3MDk0NDEzOmkzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNTo6Cjc5OjI6MiBhbGxfZ29v
ZDpiYWQ6YWxsX2JhZCBib290cwoKSEVBRCBpcyBub3cgYXQgOTg2MTA5NiAwZGF5IGhlYWQg
Z3VhcmQgZm9yICdkZXZlbC1ob3VybHktMjAxNDA3MDcwOCcKCj09PT09PT09PSB1cHN0cmVh
bSA9PT09PT09PT0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgOTg2MTA5Ni4uLiAwZGF5
IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1ob3VybHktMjAxNDA3MDcwOCcKSEVBRCBpcyBub3cg
YXQgY2QzZGU4My4uLiBMaW51eCAzLjE2LXJjNApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1x
dWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1L2xpbnVzOm1hc3RlcjpjZDNk
ZTgzZjE0NzYwMTM1NjM5NWI1N2E4NjczZTljNWZmMWU1OWQxOmJpc2VjdC1saW51eDMKIFRF
U1QgRkFJTFVSRQpbICAxMjQuNzEwMzYzXSBJT0FQSUNbMF06IFNldCByb3V0aW5nIGVudHJ5
ICgwLTExIC0+IDB4M2IgLT4gSVJRIDExIE1vZGU6MSBBY3RpdmU6MCBEZXN0OjEpClsgIDEy
Ni42MzQzODJdIHNwaW5fbG9jay10b3J0dXJlOiBXcml0ZXM6ICBUb3RhbDogMiAgTWF4L01p
bjogMC8wICAgRmFpbDogMCAKWyAgMTI4Ljc5NTIwOV0gLS0tLS0tLS0tLS0tWyBjdXQgaGVy
ZSBdLS0tLS0tLS0tLS0tClsgIDEyOS44NzkyNDBdIFdBUk5JTkc6IENQVTogMCBQSUQ6IDgy
IGF0IC9rYnVpbGQvc3JjL3Ntb2tlL2RyaXZlcnMvYmxvY2svZmxvcHB5LmM6OTc1IHNjaGVk
dWxlX2JoKzB4NDcvMHg4MCgpClsgIDEzMS45NDE1MzhdIENQVTogMCBQSUQ6IDgyIENvbW06
IGt3b3JrZXIvdTI6MSBOb3QgdGFpbnRlZCAzLjE2LjAtcmM0ICMxClsgIDEzMi45MjE5MDZd
IEhhcmR3YXJlIG5hbWU6IFFFTVUgU3RhbmRhcmQgUEMgKGk0NDBGWCArIFBJSVgsIDE5OTYp
LCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgMTM1LjA1MTgxMl0gV29ya3F1ZXVlOiBldmVu
dHNfdW5ib3VuZCBhc3luY19ydW5fZW50cnlfZm4KWyAgMTM2LjIxMzM2N10gIDAwMDAwMDAw
IGNjYWQ5ZTE4IGMyOTFjMDBjIGNjYWQ5ZTQ4IGMxMDYxYTNkIGMzMjljZmE0IDAwMDAwMDAw
IDAwMDAwMDUyClsgIDEzOC41Mzg0MTFdICBjMzM5N2EzYyAwMDAwMDNjZiBjMWFkZTI4NyBj
MWFkZTI4NyAwMDAwMDAwMSBjMWFkZmE5MCBjM2QwMTE2MCBjY2FkOWU1OApbICAxNDAuODM1
Nzg1XSAgYzEwNjFiMjIgMDAwMDAwMDkgMDAwMDAwMDAgY2NhZDllNjggYzFhZGUyODcgMDAw
MDAwMDAgMDAwMDAwMDAgY2NhZDllODgKWyAgMTQyLjk2ODI4Ml0gQ2FsbCBUcmFjZToKWyAg
MTQ0LjA5NjkyM10gIFs8YzI5MWMwMGM+XSBkdW1wX3N0YWNrKzB4MTYvMHgxOApbICAxNDUu
MTY4OTU3XSAgWzxjMTA2MWEzZD5dIHdhcm5fc2xvd3BhdGhfY29tbW9uKzB4OGQvMHhiMApb
ICAxNDYuMTM0Mjg5XSAgWzxjMWFkZTI4Nz5dID8gc2NoZWR1bGVfYmgrMHg0Ny8weDgwClsg
IDE0Ny4xNjY0NTBdICBbPGMxYWRlMjg3Pl0gPyBzY2hlZHVsZV9iaCsweDQ3LzB4ODAKWyAg
MTQ4LjE1NDYyMV0gIFs8YzFhZGZhOTA+XSA/IGxvY2tfZmRjLmlzcmEuMTIrMHgxYjAvMHgx
YjAKWyAgMTQ5LjA1Mjg4M10gIFs8YzEwNjFiMjI+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgy
Mi8weDMwClsgIDE0OS42OTEzNThdICBbPGMxYWRlMjg3Pl0gc2NoZWR1bGVfYmgrMHg0Ny8w
eDgwClsgIDE1MC40NTUyNzNdICBbPGMxYWRmZWIzPl0gd2FpdF90aWxfZG9uZSsweDEzLzB4
MjAwClsgIDE1MS40MTk1MTBdICBbPGMxMDZmZDQwPl0gPyBjYXNjYWRlKzB4YTAvMHhhMApb
ICAxNTIuMzc1MDg2XSAgWzxjMWFlMDc3Nz5dIHVzZXJfcmVzZXRfZmRjKzB4YTcvMHgxMTAK
WyAgMTUzLjQwMDI1NF0gIFs8YzNiYjY2MDk+XSBmbG9wcHlfYXN5bmNfaW5pdCsweDlkZS8w
eDEyNTYKWyAgMTU0LjQ0NzY5Nl0gIFs8YzEwOTQ5OTQ+XSBhc3luY19ydW5fZW50cnlfZm4r
MHg0NC8weDFkMApbICAxNTUuMDg5OTEwXSAgWzxjMTZkMzMxMj5dID8gX19saXN0X2RlbF9l
bnRyeSsweDIwMi8weDIyMApbICAxNTUuOTkwMTAyXSAgWzxjMTA4MjUwZj5dID8gcHdxX2Rl
Y19ucl9pbl9mbGlnaHQrMHgxMGYvMHgxMzAKWyAgMTU2Ljg0NTMwNl0gIFs8YzEwODJiNzI+
XSBwcm9jZXNzX29uZV93b3JrKzB4MzIyLzB4ODAwClsgIDE1Ny43NDAwMjBdICBbPGMxNmQz
MzEyPl0gPyBfX2xpc3RfZGVsX2VudHJ5KzB4MjAyLzB4MjIwClsgIDE1OC42NjQ1MzJdICBb
PGMxMDgzNjE0Pl0gd29ya2VyX3RocmVhZCsweDVjNC8weGIyMApbICAxNTkuNDUyNjY5XSAg
WzxjMTA4MzA1MD5dID8gcHJvY2Vzc19vbmVfd29yaysweDgwMC8weDgwMApbICAxNjAuMDMx
MTI5XSAgWzxjMTA4YzE4Mj5dIGt0aHJlYWQrMHhlMi8weGYwClsgIDE2MC44MjMyNjVdICBb
PGMxMDgzMDUwPl0gPyBwcm9jZXNzX29uZV93b3JrKzB4ODAwLzB4ODAwClsgIDE2MS41NDg0
MjhdICBbPGMyOTNhODYwPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDIwLzB4MzAKWyAg
MTYyLjMwMzYwNF0gIFs8YzEwOGMwYTA+XSA/IF9fa3RocmVhZF91bnBhcmsrMHg3MC8weDcw
ClsgIDE2My4wODMzOTBdIC0tLVsgZW5kIHRyYWNlIDNjZjYxZjM2ZjQ5ZDdmYzcgXS0tLQpb
ICAxNjQuMDE3NjA1XSBlMTAwMCAwMDAwOjAwOjAzLjAgZXRoMDogKFBDSTozM01IejozMi1i
aXQpIDUyOjU0OjAwOjEyOjM0OjU2Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcw
OTM1L2NkM2RlODNmMTQ3NjAxMzU2Mzk1YjU3YTg2NzNlOWM1ZmYxZTU5ZDEvZG1lc2cteW9j
dG8taXZiNDMtMzoyMDE0MDcwNzExMjU0OTppMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzU6
Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS9jZDNkZTgzZjE0NzYwMTM1
NjM5NWI1N2E4NjczZTljNWZmMWU1OWQxL2RtZXNnLXF1YW50YWwtaXZiNDMtMzQ6MjAxNDA3
MDcxMTI1NTE6aTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1OjoKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctYzEtMDcwNzA5MzUvY2QzZGU4M2YxNDc2MDEzNTYzOTViNTdhODY3M2U5YzVm
ZjFlNTlkMS9kbWVzZy1xdWFudGFsLWl2YjQzLTU2OjIwMTQwNzA3MTEyMTQ1OmkzODYtcmFu
ZGNvbmZpZy1jMS0wNzA3MDkzNTo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcw
OTM1L2NkM2RlODNmMTQ3NjAxMzU2Mzk1YjU3YTg2NzNlOWM1ZmYxZTU5ZDEvZG1lc2ctcXVh
bnRhbC1pdmI0My0xMjc6MjAxNDA3MDcxMTI1NDE6aTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcw
OTM1OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUvY2QzZGU4M2YxNDc2
MDEzNTYzOTViNTdhODY3M2U5YzVmZjFlNTlkMS9kbWVzZy15b2N0by1pdmI0MS02MDoyMDE0
MDcwNzExMjgyMzppMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzU6Ogova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1jMS0wNzA3MDkzNS9jZDNkZTgzZjE0NzYwMTM1NjM5NWI1N2E4NjczZTlj
NWZmMWU1OWQxL2RtZXNnLXlvY3RvLWl2YjQzLTE5OjIwMTQwNzA3MTEyNjMxOmkzODYtcmFu
ZGNvbmZpZy1jMS0wNzA3MDkzNTo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcw
OTM1L2NkM2RlODNmMTQ3NjAxMzU2Mzk1YjU3YTg2NzNlOWM1ZmYxZTU5ZDEvZG1lc2ctcXVh
bnRhbC1pdmI0My01MjoyMDE0MDcwNzExMjA1NjppMzg2LXJhbmRjb25maWctYzEtMDcwNzA5
MzU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS9jZDNkZTgzZjE0NzYw
MTM1NjM5NWI1N2E4NjczZTljNWZmMWU1OWQxL2RtZXNnLXF1YW50YWwtaXZiNDMtMzI6MjAx
NDA3MDcxMTI1Mzc6aTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1OjoKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctYzEtMDcwNzA5MzUvY2QzZGU4M2YxNDc2MDEzNTYzOTViNTdhODY3M2U5
YzVmZjFlNTlkMS9kbWVzZy1xdWFudGFsLWl2YjQzLTY3OjIwMTQwNzA3MTEyMjU4OmkzODYt
cmFuZGNvbmZpZy1jMS0wNzA3MDkzNTo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA3
MDcwOTM1L2NkM2RlODNmMTQ3NjAxMzU2Mzk1YjU3YTg2NzNlOWM1ZmYxZTU5ZDEvZG1lc2ct
eW9jdG8taXZiNDEtOTI6MjAxNDA3MDcxMTI4MjM6aTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcw
OTM1OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUvY2QzZGU4M2YxNDc2
MDEzNTYzOTViNTdhODY3M2U5YzVmZjFlNTlkMS9kbWVzZy1xdWFudGFsLWl2YjQzLTI1OjIw
MTQwNzA3MTEyNDUxOmkzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNTo6Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1L2NkM2RlODNmMTQ3NjAxMzU2Mzk1YjU3YTg2NzNl
OWM1ZmYxZTU5ZDEvZG1lc2cteW9jdG8taXZiNDMtMTE6MjAxNDA3MDcxMTI2MjE6aTM4Ni1y
YW5kY29uZmlnLWMxLTA3MDcwOTM1OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDcw
NzA5MzUvY2QzZGU4M2YxNDc2MDEzNTYzOTViNTdhODY3M2U5YzVmZjFlNTlkMS9kbWVzZy1x
dWFudGFsLWl2YjQzLTcxOjIwMTQwNzA3MTEyMzE2OmkzODYtcmFuZGNvbmZpZy1jMS0wNzA3
MDkzNTo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1L2NkM2RlODNmMTQ3
NjAxMzU2Mzk1YjU3YTg2NzNlOWM1ZmYxZTU5ZDEvZG1lc2ctcXVhbnRhbC1pdmI0My0zNjoy
MDE0MDcwNzExMTkzMTppMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzU6Ogova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS9jZDNkZTgzZjE0NzYwMTM1NjM5NWI1N2E4Njcz
ZTljNWZmMWU1OWQxL2RtZXNnLXlvY3RvLWl2YjQzLTEyOjIwMTQwNzA3MTEyNTU3OmkzODYt
cmFuZGNvbmZpZy1jMS0wNzA3MDkzNTo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA3
MDcwOTM1L2NkM2RlODNmMTQ3NjAxMzU2Mzk1YjU3YTg2NzNlOWM1ZmYxZTU5ZDEvZG1lc2ct
cXVhbnRhbC1pdmI0My0xMTc6MjAxNDA3MDcxMTI0NDU6aTM4Ni1yYW5kY29uZmlnLWMxLTA3
MDcwOTM1OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUvY2QzZGU4M2Yx
NDc2MDEzNTYzOTViNTdhODY3M2U5YzVmZjFlNTlkMS9kbWVzZy15b2N0by1pdmI0MS0xMDQ6
MjAxNDA3MDcxMTI4MjM6aTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1OjoKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUvY2QzZGU4M2YxNDc2MDEzNTYzOTViNTdhODY3
M2U5YzVmZjFlNTlkMS9kbWVzZy1xdWFudGFsLWl2YjQzLTM4OjIwMTQwNzA3MTExOTI1Omkz
ODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNTo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMx
LTA3MDcwOTM1L2NkM2RlODNmMTQ3NjAxMzU2Mzk1YjU3YTg2NzNlOWM1ZmYxZTU5ZDEvZG1l
c2ctcXVhbnRhbC1pdmI0My0yOjIwMTQwNzA3MTEyMzExOmkzODYtcmFuZGNvbmZpZy1jMS0w
NzA3MDkzNTo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1L2NkM2RlODNm
MTQ3NjAxMzU2Mzk1YjU3YTg2NzNlOWM1ZmYxZTU5ZDEvZG1lc2ctcXVhbnRhbC1pdmI0My0x
MjU6MjAxNDA3MDcxMTI1NDc6aTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1OjoKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUvY2QzZGU4M2YxNDc2MDEzNTYzOTViNTdh
ODY3M2U5YzVmZjFlNTlkMS9kbWVzZy15b2N0by1pdmI0My0xNDoyMDE0MDcwNzExMjYyMjpp
Mzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1j
MS0wNzA3MDkzNS9jZDNkZTgzZjE0NzYwMTM1NjM5NWI1N2E4NjczZTljNWZmMWU1OWQxL2Rt
ZXNnLXlvY3RvLWl2YjQzLTk6MjAxNDA3MDcxMTI2MTc6aTM4Ni1yYW5kY29uZmlnLWMxLTA3
MDcwOTM1OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUvY2QzZGU4M2Yx
NDc2MDEzNTYzOTViNTdhODY3M2U5YzVmZjFlNTlkMS9kbWVzZy1xdWFudGFsLWl2YjQzLTU4
OjIwMTQwNzA3MTEyMTU5OmkzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNTo6Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1L2NkM2RlODNmMTQ3NjAxMzU2Mzk1YjU3YTg2
NzNlOWM1ZmYxZTU5ZDEvZG1lc2cteW9jdG8taXZiNDEtMToyMDE0MDcwNzExMjgyMzppMzg2
LXJhbmRjb25maWctYzEtMDcwNzA5MzU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0w
NzA3MDkzNS9jZDNkZTgzZjE0NzYwMTM1NjM5NWI1N2E4NjczZTljNWZmMWU1OWQxL2RtZXNn
LXF1YW50YWwtaXZiNDMtMTExOjIwMTQwNzA3MTEyNDU0OmkzODYtcmFuZGNvbmZpZy1jMS0w
NzA3MDkzNTo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1L2NkM2RlODNm
MTQ3NjAxMzU2Mzk1YjU3YTg2NzNlOWM1ZmYxZTU5ZDEvZG1lc2cteW9jdG8taXZiNDEtODoy
MDE0MDcwNzExMjgyMzppMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzU6Ogova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS9jZDNkZTgzZjE0NzYwMTM1NjM5NWI1N2E4Njcz
ZTljNWZmMWU1OWQxL2RtZXNnLXF1YW50YWwtaXZiNDMtNjU6MjAxNDA3MDcxMTIyMjk6aTM4
Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEt
MDcwNzA5MzUvY2QzZGU4M2YxNDc2MDEzNTYzOTViNTdhODY3M2U5YzVmZjFlNTlkMS9kbWVz
Zy1xdWFudGFsLWl2YjQzLTEyNjoyMDE0MDcwNzExMjU0OTppMzg2LXJhbmRjb25maWctYzEt
MDcwNzA5MzU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS9jZDNkZTgz
ZjE0NzYwMTM1NjM5NWI1N2E4NjczZTljNWZmMWU1OWQxL2RtZXNnLXF1YW50YWwtaXZiNDMt
MzM6MjAxNDA3MDcxMTI1MTE6aTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1OjoKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUvY2QzZGU4M2YxNDc2MDEzNTYzOTViNTdh
ODY3M2U5YzVmZjFlNTlkMS9kbWVzZy1xdWFudGFsLWl2YjQzLTQ5OjIwMTQwNzA3MTEyMTEw
OmkzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNTo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWMxLTA3MDcwOTM1L2NkM2RlODNmMTQ3NjAxMzU2Mzk1YjU3YTg2NzNlOWM1ZmYxZTU5ZDEv
ZG1lc2ctcXVhbnRhbC1pdmI0My0xMTU6MjAxNDA3MDcxMTI0NDY6aTM4Ni1yYW5kY29uZmln
LWMxLTA3MDcwOTM1OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUvY2Qz
ZGU4M2YxNDc2MDEzNTYzOTViNTdhODY3M2U5YzVmZjFlNTlkMS9kbWVzZy15b2N0by1pdmI0
MS0xNjoyMDE0MDcwNzExMjgyMzppMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzU6Ogova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS9jZDNkZTgzZjE0NzYwMTM1NjM5NWI1
N2E4NjczZTljNWZmMWU1OWQxL2RtZXNnLXF1YW50YWwtaXZiNDMtMTEzOjIwMTQwNzA3MTEy
NTEzOmkzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNTo6CjI2NjozMzozNCBhbGxfZ29vZDpi
YWQ6YWxsX2JhZCBib290cwoKCj09PT09PT09PSBsaW51eC1uZXh0ID09PT09PT09PQpGcm9t
IGdpdDovL2dpdG1pcnJvci9uZXh0CiArIGZhYzg0N2IuLi5hMWUzZGQxIGFrcG0gICAgICAg
LT4gbmV4dC9ha3BtICAoZm9yY2VkIHVwZGF0ZSkKICsgODJjMjM3Ni4uLjkyZjY4ODYgYWtw
bS1iYXNlICAtPiBuZXh0L2FrcG0tYmFzZSAgKGZvcmNlZCB1cGRhdGUpCiArIGJiNjJjNzku
Li5kNTg0ZjJhIG1hc3RlciAgICAgLT4gbmV4dC9tYXN0ZXIgIChmb3JjZWQgdXBkYXRlKQog
ICA1MTcwYTNiLi5jZDNkZTgzICBzdGFibGUgICAgIC0+IG5leHQvc3RhYmxlCkZyb20gZ2l0
Oi8vZ2l0bWlycm9yL25leHQKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDcwNyAt
PiBuZXh0LTIwMTQwNzA3ClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIGNkM2RlODMuLi4g
TGludXggMy4xNi1yYzQKSEVBRCBpcyBub3cgYXQgZDU4NGYyYS4uLiBBZGQgbGludXgtbmV4
dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAxNDA3MDcKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4t
cXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS9uZXh0Om1hc3RlcjpkNTg0
ZjJhY2Y1Y2M2YzRhMTRjMzMwOTMwMjIyZDhlNzBmZTAyNGE2OmJpc2VjdC1saW51eDMKCjIw
MTQtMDctMDctMTY6NTI6MzQgZDU4NGYyYWNmNWNjNmM0YTE0YzMzMDkzMDIyMmQ4ZTcwZmUw
MjRhNiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctYzEtMDcwNzA5MzUtZDU4NGYyYWNmNWNjNmM0YTE0
YzMzMDkzMDIyMmQ4ZTcwZmUwMjRhNgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1L2Q1ODRmMmFjZjVjYzZjNGExNGMzMzA5MzAyMjJk
OGU3MGZlMDI0YTYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1jMS0wNzA3MDkzNS1kNTg0ZjJhY2Y1Y2M2YzRh
MTRjMzMwOTMwMjIyZDhlNzBmZTAyNGE2CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2ti
dWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9jYWlyby1zbW9rZS9pMzg2LXJhbmRjb25maWctYzEt
MDcwNzA5MzUtZDU4NGYyYWNmNWNjNmM0YTE0YzMzMDkzMDIyMmQ4ZTcwZmUwMjRhNgprZXJu
ZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWMxLTA3MDcwOTM1L2Q1ODRmMmFjZjVjYzZj
NGExNGMzMzA5MzAyMjJkOGU3MGZlMDI0YTYvdm1saW51ei0zLjE2LjAtcmM0LW5leHQtMjAx
NDA3MDcKCjIwMTQtMDctMDctMTc6MzE6MzQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4u
CTQJNi4uCTgJMTEJMTIJMTQJMTUJMTYuCTE4CTIyLi4uCTI3Li4uCTI5Li4JMzAJMzMJMzYu
CTM3CTQwLgk0Mgk0OAk0OS4JNTEuLgk1My4uLi4uLi4uLgk1NS4JNTYJNTcuLgk2MS4JNjIg
VEVTVCBGQUlMVVJFClsgIDEwOS45NjYwNDNdIFNDU0kgTWVkaWEgQ2hhbmdlciBkcml2ZXIg
djAuMjUgClsgIDExMC42MDM1NTBdIFJvdW5kaW5nIGRvd24gYWxpZ25lZCBtYXhfc2VjdG9y
cyBmcm9tIDQyOTQ5NjcyOTUgdG8gNDI5NDk2NzI4OApbICAxMTIuMjExNDkyXSAtLS0tLS0t
LS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgMTEyLjkwMDUzOV0gV0FSTklORzog
Q1BVOiAwIFBJRDogODIgYXQgL2tidWlsZC9zcmMvc21va2UvZHJpdmVycy9ibG9jay9mbG9w
cHkuYzo5NzUgc2NoZWR1bGVfYmgrMHg0Ny8weDgwKCkKWyAgMTE0LjEwODAyOF0gQ1BVOiAw
IFBJRDogODIgQ29tbToga3dvcmtlci91MjoxIE5vdCB0YWludGVkIDMuMTYuMC1yYzQtbmV4
dC0yMDE0MDcwNyAjMQpbICAxMTUuNDAyNjM1XSBIYXJkd2FyZSBuYW1lOiBRRU1VIFN0YW5k
YXJkIFBDIChpNDQwRlggKyBQSUlYLCAxOTk2KSwgQklPUyBCb2NocyAwMS8wMS8yMDExClsg
IDExNy40NzYwNjVdIFdvcmtxdWV1ZTogZXZlbnRzX3VuYm91bmQgYXN5bmNfcnVuX2VudHJ5
X2ZuClsgIDExOC4xNDEzODBdICAwMDAwMDAwMCBjMDFhYmUxOCBjMjkyYzEwNCBjMDFhYmU0
OCBjMTA2MjE0ZCBjMzJiMzRmNCAwMDAwMDAwMCAwMDAwMDA1MgpbICAxMTkuMjk1MDAxXSAg
YzMzYjAxM2MgMDAwMDAzY2YgYzFhZTQ1NTcgYzFhZTQ1NTcgMDAwMDAwMDEgYzFhZTVkNjAg
YzNkMWUyNDAgYzAxYWJlNTgKWyAgMTIwLjE4ODUzM10gIGMxMDYyMjMyIDAwMDAwMDA5IDAw
MDAwMDAwIGMwMWFiZTY4IGMxYWU0NTU3IDAwMDAwMDAwIDAwMDAwMDAwIGMwMWFiZTg4Clsg
IDEyMS43ODI5NTBdIENhbGwgVHJhY2U6ClsgIDEyMi43NTQ2ODJdICBbPGMyOTJjMTA0Pl0g
ZHVtcF9zdGFjaysweDE2LzB4MTgKWyAgMTIzLjQ5Njg1OF0gIFs8YzEwNjIxNGQ+XSB3YXJu
X3Nsb3dwYXRoX2NvbW1vbisweDhkLzB4YjAKWyAgMTI0LjAwNTgzNF0gIFs8YzFhZTQ1NTc+
XSA/IHNjaGVkdWxlX2JoKzB4NDcvMHg4MApbICAxMjQuNzM0ODgzXSAgWzxjMWFlNDU1Nz5d
ID8gc2NoZWR1bGVfYmgrMHg0Ny8weDgwClsgIDEyNS4zNTU0NzFdICBbPGMxYWU1ZDYwPl0g
PyBsb2NrX2ZkYy5pc3JhLjEyKzB4MWIwLzB4MWIwClsgIDEyNS45MzQ0ODldICBbPGMxMDYy
MjMyPl0gd2Fybl9zbG93cGF0aF9udWxsKzB4MjIvMHgzMApbICAxMjYuNDAzNjUyXSAgWzxj
MWFlNDU1Nz5dIHNjaGVkdWxlX2JoKzB4NDcvMHg4MApbICAxMjcuMDAzNTgwXSAgWzxjMWFl
NjE4Mz5dIHdhaXRfdGlsX2RvbmUrMHgxMy8weDIwMApbICAxMjcuNTI5OTM1XSAgWzxjMTBi
YTdhMD5dID8gY2FzY2FkZSsweGEwLzB4YTAKWyAgMTI4LjA5MzU1MV0gIFs8YzFhZTZhNDc+
XSB1c2VyX3Jlc2V0X2ZkYysweGE3LzB4MTEwClsgIDEyOC42OTAwNzddICBbPGMzYmQyYmRl
Pl0gZmxvcHB5X2FzeW5jX2luaXQrMHg5ZGUvMHgxMjU2ClsgIDEyOS4zNTQ5ODZdICBbPGMx
MDg5NDE0Pl0gYXN5bmNfcnVuX2VudHJ5X2ZuKzB4NDQvMHgxZDAKWyAgMTI5Ljk3OTEyOF0g
IFs8YzE2ZDdiMTI+XSA/IF9fbGlzdF9kZWxfZW50cnkrMHgyMDIvMHgyMjAKWyAgMTMwLjYy
MzY0M10gIFs8YzEwN2ViZjI+XSBwcm9jZXNzX29uZV93b3JrKzB4MzEyLzB4N2YwClsgIDEz
MS4zMTg0MzVdICBbPGMxNmQ3YjEyPl0gPyBfX2xpc3RfZGVsX2VudHJ5KzB4MjAyLzB4MjIw
ClsgIDEzMi42MzMyMDhdICBbPGMxMDdmNjk0Pl0gd29ya2VyX3RocmVhZCsweDVjNC8weGIy
MApbICAxMzMuNjg1Nzk0XSAgWzxjMTA3ZjBkMD5dID8gcHJvY2Vzc19vbmVfd29yaysweDdm
MC8weDdmMApbICAxMzQuMzMxNTY1XSAgWzxjMTA4NWUxMj5dIGt0aHJlYWQrMHhlMi8weGYw
ClsgIDEzNS4yODQwMzldICBbPGMxMDdmMGQwPl0gPyBwcm9jZXNzX29uZV93b3JrKzB4N2Yw
LzB4N2YwClsgIDEzNS44OTA2NzZdICBbPGMyOTRhOTAwPl0gcmV0X2Zyb21fa2VybmVsX3Ro
cmVhZCsweDIwLzB4MzAKWyAgMTM2LjM3NzQ1N10gIFs8YzEwODVkMzA+XSA/IF9fa3RocmVh
ZF91bnBhcmsrMHg3MC8weDcwClsgIDEzNi44MDE5MjNdIC0tLVsgZW5kIHRyYWNlIGI5YzYx
MWRmNmE1MTZhMDkgXS0tLQpbICAxMzcuMjQzMjcwXSBzcGluX2xvY2stdG9ydHVyZTogV3Jp
dGVzOiAgVG90YWw6IDIgIE1heC9NaW46IDAvMCAgIEZhaWw6IDAgCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWMxLTA3MDcwOTM1L2Q1ODRmMmFjZjVjYzZjNGExNGMzMzA5MzAyMjJkOGU3
MGZlMDI0YTYvZG1lc2ctcXVhbnRhbC1pdmI0MS04NzoyMDE0MDcwNzE4MDEzMzppMzg2LXJh
bmRjb25maWctYzEtMDcwNzA5MzU6Ogo2MjoxOjEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9v
dHMKCg==

--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.11.0-rc7-00025-gb22ce27"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.11.0-rc7 Kernel Configuration
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
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_COMPILE_TEST=y
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
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
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
CONFIG_GENERIC_IRQ_CHIP=y
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
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
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
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_IPC_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
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
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
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
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
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
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_THROTTLING is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y

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
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_WANT_INTEL_MID is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_RDC321X is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
# CONFIG_MPENTIUMII is not set
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
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=5
CONFIG_X86_L1_CACHE_SHIFT=5
# CONFIG_X86_PPRO_FENCE is not set
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=1
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
# CONFIG_X86_UP_APIC is not set
CONFIG_X86_MCE=y
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_INJECT=y
CONFIG_VM86=y
CONFIG_TOSHIBA=y
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_MICROCODE_EARLY=y
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
# CONFIG_X86_PAE is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_HWPOISON_INJECT is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
# CONFIG_ZBUD is not set
# CONFIG_ZSWAP is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
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
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_I2C=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K6=y
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_POWERNOW_K7_ACPI=y
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
CONFIG_X86_P4_CLOCKMOD=y
CONFIG_X86_CPUFREQ_NFORCE2=y
CONFIG_X86_LONGRUN=y
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
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
CONFIG_PCI_GOBIOS=y
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_BIOS=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
CONFIG_PCI_PASID=y
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_EISA=y
CONFIG_EISA_VLB_PRIMING=y
# CONFIG_EISA_PCI_EISA is not set
# CONFIG_EISA_VIRTUAL_ROOT is not set
# CONFIG_EISA_NAMES is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_OLPC=y
# CONFIG_OLPC_XO15_SCI is not set
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
# CONFIG_GEOS is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PCMCIA_PROBE=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_COMPAQ=y
CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
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
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=y
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_NET_IPVTI is not set
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=y
# CONFIG_INET6_ESP is not set
CONFIG_INET6_IPCOMP=y
CONFIG_IPV6_MIP6=y
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
# CONFIG_IPV6_GRE is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=y

#
# DCCP CCIDs Configuration
#
CONFIG_IP_DCCP_CCID2_DEBUG=y
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_TFRC_LIB=y

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
CONFIG_IP_SCTP=y
CONFIG_SCTP_DBG_OBJCNT=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
CONFIG_L2TP=y
# CONFIG_L2TP_DEBUGFS is not set
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=y
CONFIG_L2TP_ETH=y
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_VLAN_8021Q_MVRP is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
CONFIG_PHONET=y
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_MULTIQ=y
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFB=y
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
# CONFIG_NET_SCH_NETEM is not set
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_MQPRIO=y
CONFIG_NET_SCH_CHOKE=y
# CONFIG_NET_SCH_QFQ is not set
CONFIG_NET_SCH_CODEL=y
# CONFIG_NET_SCH_FQ_CODEL is not set
CONFIG_NET_SCH_INGRESS=y
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_FW=y
# CONFIG_NET_CLS_U32 is not set
CONFIG_NET_CLS_RSVP=y
# CONFIG_NET_CLS_RSVP6 is not set
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=y
CONFIG_NET_EMATCH_NBYTE=y
CONFIG_NET_EMATCH_U32=y
# CONFIG_NET_EMATCH_META is not set
# CONFIG_NET_EMATCH_TEXT is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=y
# CONFIG_GACT_PROB is not set
CONFIG_NET_ACT_MIRRED=y
# CONFIG_NET_ACT_NAT is not set
CONFIG_NET_ACT_PEDIT=y
CONFIG_NET_ACT_SIMP=y
# CONFIG_NET_ACT_SKBEDIT is not set
# CONFIG_NET_ACT_CSUM is not set
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_BLA is not set
# CONFIG_BATMAN_ADV_DAT is not set
CONFIG_BATMAN_ADV_NC=y
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_OPENVSWITCH=y
# CONFIG_VSOCKETS is not set
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
CONFIG_NET_DROP_MONITOR=y
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=y
CONFIG_BT_RFCOMM=y
# CONFIG_BT_RFCOMM_TTY is not set
# CONFIG_BT_BNEP is not set
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTSDIO=y
CONFIG_BT_HCIUART=y
# CONFIG_BT_HCIUART_H4 is not set
CONFIG_BT_HCIUART_BCSP=y
# CONFIG_BT_HCIUART_ATH3K is not set
# CONFIG_BT_HCIUART_LL is not set
CONFIG_BT_HCIUART_3WIRE=y
# CONFIG_BT_HCIVHCI is not set
CONFIG_BT_MRVL=y
# CONFIG_BT_MRVL_SDIO is not set
# CONFIG_BT_WILINK is not set
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_REGULATOR=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_RDMA is not set
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
CONFIG_NFC=y
CONFIG_NFC_NCI=y
CONFIG_NFC_HCI=y
CONFIG_NFC_SHDLC=y

#
# Near Field Communication (NFC) devices
#
# CONFIG_NFC_WILINK is not set
CONFIG_NFC_SIM=y
# CONFIG_NFC_PN544 is not set
# CONFIG_NFC_MICROREAD is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
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
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_CMA is not set

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
# CONFIG_PROC_DEVICETREE is not set
CONFIG_OF_SELFTEST=y
CONFIG_OF_PROMTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_I2C=y
CONFIG_OF_NET=y
CONFIG_OF_MDIO=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_ISAPNP=y
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_NVME=y
CONFIG_BLK_DEV_SX8=y
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
CONFIG_ATA_OVER_ETH=y
CONFIG_VIRTIO_BLK=y
CONFIG_BLK_DEV_HD=y
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
CONFIG_INTEL_MID_PTI=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_CS5535_MFGPT is not set
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
CONFIG_PCH_PHUB=y
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_SRAM=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_VMWARE_VMCI=y
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_IDE_LEGACY=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=y
# CONFIG_IDE_GD_ATA is not set
CONFIG_IDE_GD_ATAPI=y
# CONFIG_BLK_DEV_IDECD is not set
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
CONFIG_BLK_DEV_CMD640=y
# CONFIG_BLK_DEV_CMD640_ENHANCED is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=y
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=y
CONFIG_BLK_DEV_ALI15X3=y
CONFIG_BLK_DEV_AMD74XX=y
# CONFIG_BLK_DEV_ATIIXP is not set
CONFIG_BLK_DEV_CMD64X=y
CONFIG_BLK_DEV_TRIFLEX=y
CONFIG_BLK_DEV_CS5520=y
CONFIG_BLK_DEV_CS5530=y
CONFIG_BLK_DEV_CS5535=y
CONFIG_BLK_DEV_CS5536=y
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8172 is not set
CONFIG_BLK_DEV_IT8213=y
# CONFIG_BLK_DEV_IT821X is not set
CONFIG_BLK_DEV_NS87415=y
CONFIG_BLK_DEV_PDC202XX_OLD=y
CONFIG_BLK_DEV_PDC202XX_NEW=y
CONFIG_BLK_DEV_SVWKS=y
# CONFIG_BLK_DEV_SIIMAGE is not set
CONFIG_BLK_DEV_SIS5513=y
CONFIG_BLK_DEV_SLC90E66=y
# CONFIG_BLK_DEV_TRM290 is not set
CONFIG_BLK_DEV_VIA82CXXX=y
# CONFIG_BLK_DEV_TC86C001 is not set

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
CONFIG_BLK_DEV_4DRIVES=y
CONFIG_BLK_DEV_ALI14XX=y
CONFIG_BLK_DEV_DTC2278=y
CONFIG_BLK_DEV_HT6560B=y
# CONFIG_BLK_DEV_QD65XX is not set
CONFIG_BLK_DEV_UMC8672=y
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_ENCLOSURE=y
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_FC_TGT_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
CONFIG_ISCSI_BOOT_SYSFS=y
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
CONFIG_SCSI_BNX2_ISCSI=y
CONFIG_SCSI_BNX2X_FCOE=y
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
CONFIG_SCSI_3W_SAS=y
# CONFIG_SCSI_7000FASST is not set
CONFIG_SCSI_ACARD=y
CONFIG_SCSI_AHA152X=y
# CONFIG_SCSI_AHA1542 is not set
# CONFIG_SCSI_AHA1740 is not set
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_BUILD_FIRMWARE is not set
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
CONFIG_SCSI_AIC94XX=y
CONFIG_AIC94XX_DEBUG=y
CONFIG_SCSI_MVSAS=y
CONFIG_SCSI_MVSAS_DEBUG=y
CONFIG_SCSI_MVSAS_TASKLET=y
# CONFIG_SCSI_MVUMI is not set
CONFIG_SCSI_DPT_I2O=y
CONFIG_SCSI_ADVANSYS=y
# CONFIG_SCSI_IN2000 is not set
CONFIG_SCSI_ARCMSR=y
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
# CONFIG_MEGARAID_MAILBOX is not set
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS_LOGGING is not set
CONFIG_SCSI_MPT3SAS=y
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_LOGGING=y
# CONFIG_SCSI_UFSHCD is not set
CONFIG_SCSI_HPTIOP=y
CONFIG_SCSI_BUSLOGIC=y
# CONFIG_SCSI_FLASHPOINT is not set
CONFIG_VMWARE_PVSCSI=y
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
CONFIG_FCOE=y
CONFIG_FCOE_FNIC=y
# CONFIG_SCSI_DMX3191D is not set
CONFIG_SCSI_DTC3280=y
CONFIG_SCSI_EATA=y
CONFIG_SCSI_EATA_TAGGED_QUEUE=y
# CONFIG_SCSI_EATA_LINKED_COMMANDS is not set
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=y
CONFIG_SCSI_GDTH=y
CONFIG_SCSI_ISCI=y
CONFIG_SCSI_GENERIC_NCR5380=y
CONFIG_SCSI_GENERIC_NCR5380_MMIO=y
CONFIG_SCSI_GENERIC_NCR53C400=y
CONFIG_SCSI_IPS=y
CONFIG_SCSI_INITIO=y
# CONFIG_SCSI_INIA100 is not set
CONFIG_SCSI_PPA=y
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_IZIP_EPP16 is not set
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
CONFIG_SCSI_NCR53C406A=y
CONFIG_SCSI_STEX=y
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
# CONFIG_SCSI_IPR is not set
CONFIG_SCSI_PAS16=y
CONFIG_SCSI_QLOGIC_FAS=y
CONFIG_SCSI_QLOGIC_1280=y
# CONFIG_SCSI_QLA_FC is not set
CONFIG_SCSI_QLA_ISCSI=y
# CONFIG_SCSI_LPFC is not set
CONFIG_SCSI_SIM710=y
CONFIG_SCSI_SYM53C416=y
# CONFIG_SCSI_DC395x is not set
CONFIG_SCSI_DC390T=y
CONFIG_SCSI_T128=y
CONFIG_SCSI_U14_34F=y
# CONFIG_SCSI_U14_34F_TAGGED_QUEUE is not set
CONFIG_SCSI_U14_34F_LINKED_COMMANDS=y
CONFIG_SCSI_U14_34F_MAX_TAGS=8
CONFIG_SCSI_ULTRASTOR=y
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
CONFIG_SCSI_PMCRAID=y
CONFIG_SCSI_PM8001=y
CONFIG_SCSI_SRP=y
CONFIG_SCSI_BFA_FC=y
# CONFIG_SCSI_VIRTIO is not set
CONFIG_SCSI_CHELSIO_FCOE=y
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=y
# CONFIG_SCSI_OSD_ULD is not set
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
# CONFIG_SATA_AHCI_PLATFORM is not set
CONFIG_SATA_INIC162X=y
CONFIG_SATA_ACARD_AHCI=y
CONFIG_SATA_SIL24=y
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
CONFIG_BCACHE=y
CONFIG_BCACHE_DEBUG=y
# CONFIG_BCACHE_EDEBUG is not set
CONFIG_BCACHE_CLOSURES_DEBUG=y
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
# CONFIG_DM_CRYPT is not set
CONFIG_DM_SNAPSHOT=y
# CONFIG_DM_THIN_PROVISIONING is not set
# CONFIG_DM_CACHE is not set
CONFIG_DM_MIRROR=y
# CONFIG_DM_RAID is not set
CONFIG_DM_LOG_USERSPACE=y
# CONFIG_DM_ZERO is not set
CONFIG_DM_MULTIPATH=y
CONFIG_DM_MULTIPATH_QL=y
CONFIG_DM_MULTIPATH_ST=y
CONFIG_DM_DELAY=y
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=y
# CONFIG_DM_VERITY is not set
# CONFIG_DM_SWITCH is not set
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=y
CONFIG_TCM_FILEIO=y
CONFIG_TCM_PSCSI=y
# CONFIG_LOOPBACK_TARGET is not set
CONFIG_TCM_FC=y
CONFIG_ISCSI_TARGET=y
# CONFIG_SBP_TARGET is not set
CONFIG_FUSION=y
# CONFIG_FUSION_SPI is not set
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_SBP2=y
CONFIG_FIREWIRE_NET=y
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
CONFIG_BONDING=y
CONFIG_DUMMY=y
CONFIG_EQUALIZER=y
# CONFIG_NET_FC is not set
CONFIG_IFB=y
CONFIG_NET_TEAM=y
CONFIG_NET_TEAM_MODE_BROADCAST=y
CONFIG_NET_TEAM_MODE_ROUNDROBIN=y
# CONFIG_NET_TEAM_MODE_RANDOM is not set
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=y
# CONFIG_NET_TEAM_MODE_LOADBALANCE is not set
CONFIG_MACVLAN=y
CONFIG_MACVTAP=y
CONFIG_VXLAN=y
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_TUN is not set
CONFIG_VETH=y
# CONFIG_VIRTIO_NET is not set
CONFIG_NLMON=y
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
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_NET_VENDOR_AMD is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_ARC_EMAC=y
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
CONFIG_ATL1=y
CONFIG_ATL1E=y
# CONFIG_ATL1C is not set
CONFIG_ALX=y
# CONFIG_NET_CADENCE is not set
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=y
CONFIG_CNIC=y
CONFIG_TIGON3=y
CONFIG_BNX2X=y
# CONFIG_NET_VENDOR_BROCADE is not set
CONFIG_NET_CALXEDA_XGMAC=y
# CONFIG_NET_VENDOR_CHELSIO is not set
# CONFIG_NET_VENDOR_CIRRUS is not set
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=y
CONFIG_DNET=y
# CONFIG_NET_VENDOR_DEC is not set
CONFIG_NET_VENDOR_DLINK=y
CONFIG_DL2K=y
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=y
# CONFIG_NET_VENDOR_EXAR is not set
CONFIG_NET_VENDOR_FUJITSU=y
# CONFIG_NET_VENDOR_HP is not set
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=y
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
CONFIG_IGB_DCA=y
CONFIG_IGBVF=y
CONFIG_IXGB=y
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
# CONFIG_IXGBE_DCA is not set
# CONFIG_NET_VENDOR_I825XX is not set
CONFIG_IP1000=y
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_MVMDIO=y
CONFIG_SKGE=y
# CONFIG_SKGE_DEBUG is not set
CONFIG_SKGE_GENESIS=y
# CONFIG_SKY2 is not set
CONFIG_NET_VENDOR_MELLANOX=y
CONFIG_MLX4_EN=y
CONFIG_MLX4_CORE=y
CONFIG_MLX4_DEBUG=y
CONFIG_MLX5_CORE=y
CONFIG_MLX5_DEBUG=y
CONFIG_NET_VENDOR_MICREL=y
CONFIG_KS8842=y
# CONFIG_KS8851_MLL is not set
CONFIG_KSZ884X_PCI=y
# CONFIG_NET_VENDOR_MYRI is not set
CONFIG_FEALNX=y
CONFIG_NET_VENDOR_NATSEMI=y
CONFIG_NATSEMI=y
CONFIG_NS83820=y
CONFIG_NET_VENDOR_8390=y
# CONFIG_NE2000 is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_ULTRA is not set
CONFIG_WD80x3=y
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
CONFIG_PCH_GBE=y
CONFIG_ETHOC=y
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_ATP=y
# CONFIG_8139CP is not set
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
CONFIG_8139TOO_TUNE_TWISTER=y
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=y
CONFIG_SH_ETH=y
# CONFIG_NET_VENDOR_RDC is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
CONFIG_SC92031=y
CONFIG_NET_VENDOR_SIS=y
CONFIG_SIS900=y
CONFIG_SIS190=y
CONFIG_SFC=y
CONFIG_SFC_MCDI_MON=y
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_SMC9194 is not set
CONFIG_EPIC100=y
CONFIG_SMSC911X=y
# CONFIG_SMSC911X_ARCH_HOOKS is not set
CONFIG_SMSC9420=y
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
CONFIG_FDDI=y
CONFIG_DEFXX=y
CONFIG_DEFXX_MMIO=y
# CONFIG_SKFP is not set
CONFIG_HIPPI=y
# CONFIG_ROADRUNNER is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
CONFIG_BCM87XX_PHY=y
# CONFIG_ICPLUS_PHY is not set
CONFIG_REALTEK_PHY=y
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=y
# CONFIG_LSI_ET1011C_PHY is not set
CONFIG_MICREL_PHY=y
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_GPIO=y
CONFIG_MDIO_BUS_MUX=y
CONFIG_MDIO_BUS_MUX_GPIO=y
# CONFIG_MDIO_BUS_MUX_MMIOREG is not set
CONFIG_PLIP=y
CONFIG_PPP=y
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=y
# CONFIG_PPP_MULTILINK is not set
# CONFIG_PPPOE is not set
# CONFIG_PPPOL2TP is not set
CONFIG_PPP_ASYNC=y
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
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=y
CONFIG_HDLC_RAW=y
# CONFIG_HDLC_RAW_ETH is not set
# CONFIG_HDLC_CISCO is not set
CONFIG_HDLC_FR=y
# CONFIG_HDLC_PPP is not set
CONFIG_HDLC_X25=y
CONFIG_PCI200SYN=y
CONFIG_WANXL=y
# CONFIG_WANXL_BUILD_FIRMWARE is not set
CONFIG_PC300TOO=y
CONFIG_N2=y
CONFIG_C101=y
CONFIG_FARSYNC=y
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
# CONFIG_SDLA is not set
# CONFIG_SBNI is not set
CONFIG_VMXNET3=y
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
CONFIG_KEYBOARD_ADP5588=y
CONFIG_KEYBOARD_ADP5589=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
CONFIG_KEYBOARD_QT2160=y
CONFIG_KEYBOARD_LKKBD=y
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
CONFIG_KEYBOARD_TCA8418=y
CONFIG_KEYBOARD_MATRIX=y
CONFIG_KEYBOARD_LM8323=y
CONFIG_KEYBOARD_LM8333=y
# CONFIG_KEYBOARD_MAX7359 is not set
CONFIG_KEYBOARD_MCS=y
CONFIG_KEYBOARD_MPR121=y
CONFIG_KEYBOARD_NEWTON=y
# CONFIG_KEYBOARD_OPENCORES is not set
CONFIG_KEYBOARD_STOWAWAY=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TWL4030 is not set
CONFIG_KEYBOARD_XTKBD=y
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
CONFIG_TOUCHSCREEN_BU21013=y
CONFIG_TOUCHSCREEN_CY8CTMG110=y
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
CONFIG_TOUCHSCREEN_DA9052=y
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
CONFIG_TOUCHSCREEN_EGALAX=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=y
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_WACOM_I2C=y
# CONFIG_TOUCHSCREEN_MAX11801 is not set
CONFIG_TOUCHSCREEN_MCS5000=y
CONFIG_TOUCHSCREEN_MMS114=y
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_HTCPEN=y
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_PIXCIR=y
# CONFIG_TOUCHSCREEN_WM831X is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_TOUCHSCREEN_TSC_SERIO=y
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_TOUCHSCREEN_ST1232=y
CONFIG_TOUCHSCREEN_TPS6507X=y
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_SERIO_APBPS2=y
CONFIG_SERIO_OLPC_APSP=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=y
CONFIG_N_GSM=y
# CONFIG_TRACE_ROUTER is not set
CONFIG_TRACE_SINK=y
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_OF_PLATFORM=y
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS=y
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
CONFIG_SERIAL_PCH_UART=y
# CONFIG_SERIAL_PCH_UART_CONSOLE is not set
CONFIG_SERIAL_XILINX_PS_UART=y
# CONFIG_SERIAL_XILINX_PS_UART_CONSOLE is not set
CONFIG_SERIAL_ARC=y
CONFIG_SERIAL_ARC_CONSOLE=y
CONFIG_SERIAL_ARC_NR_PORTS=1
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
CONFIG_SERIAL_FSL_LPUART=y
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_GEODE is not set
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
# CONFIG_DTLK is not set
CONFIG_R3964=y
CONFIG_APPLICOM=y
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
# CONFIG_SCx200_GPIO is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_ARB_GPIO_CHALLENGE is not set
CONFIG_I2C_MUX_GPIO=y
CONFIG_I2C_MUX_PCA9541=y
CONFIG_I2C_MUX_PCA954x=y
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
CONFIG_I2C_ALI1563=y
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=y
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=y
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=y
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
# CONFIG_I2C_NFORCE2_S4985 is not set
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PCI=y
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_ELEKTOR is not set
CONFIG_I2C_PCA_ISA=y
CONFIG_SCx200_ACB=y
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

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
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

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_DA9055=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_TS5500=y
CONFIG_GPIO_SCH=y
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set
# CONFIG_GPIO_GRGPIO is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_RC5T583=y
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_TWL4030 is not set
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set
CONFIG_GPIO_ADNP=y

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=y
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_AMD8111=y
# CONFIG_GPIO_LANGWELL is not set
CONFIG_GPIO_PCH=y
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_SODAVILLE=y
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MCP23S08=y

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_TPS65910=y

#
# USB GPIO expanders:
#
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_MAX8925_POWER=y
# CONFIG_WM831X_BACKUP is not set
CONFIG_WM831X_POWER=y
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_OLPC=y
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
# CONFIG_BATTERY_DA9052 is not set
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_PCF50633=y
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_TWL4030 is not set
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MAX8997=y
CONFIG_CHARGER_BQ2415X=y
# CONFIG_CHARGER_SMB347 is not set
CONFIG_BATTERY_GOLDFISH=y
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=y
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX16065=y
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
# CONFIG_SENSORS_PMBUS is not set
CONFIG_SENSORS_ADM1275=y
# CONFIG_SENSORS_LM25066 is not set
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
# CONFIG_SENSORS_ZL6100 is not set
CONFIG_SENSORS_SHT15=y
# CONFIG_SENSORS_SHT21 is not set
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=y
# CONFIG_SENSORS_VT1211 is not set
CONFIG_SENSORS_VT8231=y
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_APPLESMC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_CPU_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set
CONFIG_INTEL_POWERCLAMP=y

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
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
# CONFIG_LPC_ICH is not set
CONFIG_LPC_SCH=y
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
# CONFIG_MFD_RETU is not set
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
CONFIG_PCF50633_GPIO=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
# CONFIG_AB3100_OTP is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS65910=y
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_MADC is not set
# CONFIG_MFD_TWL4030_AUDIO is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_DUMMY is not set
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_DA9052=y
# CONFIG_REGULATOR_DA9055 is not set
CONFIG_REGULATOR_FAN53555=y
# CONFIG_REGULATOR_ANATOP is not set
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8925=y
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8997=y
# CONFIG_REGULATOR_MAX8998 is not set
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
# CONFIG_REGULATOR_LP8755 is not set
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_RC5T583=y
CONFIG_REGULATOR_AB3100=y
# CONFIG_REGULATOR_TPS51632 is not set
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65910=y
CONFIG_REGULATOR_TPS80031=y
CONFIG_REGULATOR_TWL4030=y
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8400=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=y
# CONFIG_VIDEO_V4L2_SUBDEV_API is not set
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_TUNER=y
CONFIG_V4L2_MEM2MEM_DEV=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_VMALLOC=y
# CONFIG_VIDEO_V4L2_INT_DEVICE is not set
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#

#
# Media capture/analog TV support
#
CONFIG_VIDEO_ZORAN=y
CONFIG_VIDEO_ZORAN_DC30=y
# CONFIG_VIDEO_ZORAN_ZR36060 is not set
CONFIG_VIDEO_HEXIUM_GEMINI=y
CONFIG_VIDEO_HEXIUM_ORION=y
CONFIG_VIDEO_MXB=y

#
# Media capture/analog/hybrid TV support
#
CONFIG_VIDEO_CX25821=y
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
CONFIG_V4L_TEST_DRIVERS=y
# CONFIG_VIDEO_VIVI is not set
CONFIG_VIDEO_MEM2MEM_TESTDEV=y

#
# Supported MMC/SDIO adapters
#
CONFIG_MEDIA_PARPORT_SUPPORT=y
# CONFIG_VIDEO_BWQCAM is not set
CONFIG_VIDEO_CQCAM=y
CONFIG_VIDEO_PMS=y
CONFIG_VIDEO_BTCX=y
CONFIG_VIDEO_SAA7146=y
CONFIG_VIDEO_SAA7146_VV=y

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
# CONFIG_VIDEO_TVAUDIO is not set
CONFIG_VIDEO_TDA7432=y
CONFIG_VIDEO_TDA9840=y
CONFIG_VIDEO_TEA6415C=y
# CONFIG_VIDEO_TEA6420 is not set
CONFIG_VIDEO_MSP3400=y
# CONFIG_VIDEO_CS5345 is not set
CONFIG_VIDEO_CS53L32A=y
# CONFIG_VIDEO_TLV320AIC23B is not set
CONFIG_VIDEO_UDA1342=y
CONFIG_VIDEO_WM8775=y
# CONFIG_VIDEO_WM8739 is not set
# CONFIG_VIDEO_VP27SMPX is not set
CONFIG_VIDEO_SONY_BTF_MPX=y

#
# RDS decoders
#
# CONFIG_VIDEO_SAA6588 is not set

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=y
CONFIG_VIDEO_ADV7183=y
CONFIG_VIDEO_BT819=y
# CONFIG_VIDEO_BT856 is not set
# CONFIG_VIDEO_BT866 is not set
CONFIG_VIDEO_KS0127=y
CONFIG_VIDEO_ML86V7667=y
CONFIG_VIDEO_SAA7110=y
# CONFIG_VIDEO_SAA711X is not set
# CONFIG_VIDEO_SAA7191 is not set
# CONFIG_VIDEO_TVP514X is not set
CONFIG_VIDEO_TVP5150=y
# CONFIG_VIDEO_TVP7002 is not set
# CONFIG_VIDEO_TW2804 is not set
CONFIG_VIDEO_TW9903=y
CONFIG_VIDEO_TW9906=y
CONFIG_VIDEO_VPX3220=y

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=y
CONFIG_VIDEO_CX25840=y

#
# Video encoders
#
# CONFIG_VIDEO_SAA7127 is not set
CONFIG_VIDEO_SAA7185=y
CONFIG_VIDEO_ADV7170=y
# CONFIG_VIDEO_ADV7175 is not set
# CONFIG_VIDEO_ADV7343 is not set
CONFIG_VIDEO_ADV7393=y
CONFIG_VIDEO_AK881X=y
CONFIG_VIDEO_THS8200=y

#
# Camera sensor devices
#
CONFIG_VIDEO_OV7640=y
# CONFIG_VIDEO_OV7670 is not set
# CONFIG_VIDEO_VS6624 is not set
# CONFIG_VIDEO_MT9V011 is not set
# CONFIG_VIDEO_SR030PC30 is not set

#
# Flash devices
#
CONFIG_VIDEO_ADP1653=y
# CONFIG_VIDEO_AS3645A is not set

#
# Video improvement chips
#
# CONFIG_VIDEO_UPD64031A is not set
CONFIG_VIDEO_UPD64083=y

#
# Miscelaneous helper chips
#
CONFIG_VIDEO_THS7303=y
CONFIG_VIDEO_M52790=y

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
# CONFIG_MEDIA_TUNER_TEA5761 is not set
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
# CONFIG_MEDIA_TUNER_MT2060 is not set
CONFIG_MEDIA_TUNER_MT2063=y
CONFIG_MEDIA_TUNER_MT2266=y
# CONFIG_MEDIA_TUNER_MT2131 is not set
# CONFIG_MEDIA_TUNER_QT1010 is not set
CONFIG_MEDIA_TUNER_XC2028=y
# CONFIG_MEDIA_TUNER_XC5000 is not set
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MXL5005S=y
# CONFIG_MEDIA_TUNER_MXL5007T is not set
CONFIG_MEDIA_TUNER_MC44S803=y
# CONFIG_MEDIA_TUNER_MAX2165 is not set
CONFIG_MEDIA_TUNER_TDA18218=y
CONFIG_MEDIA_TUNER_FC0011=y
CONFIG_MEDIA_TUNER_FC0012=y
CONFIG_MEDIA_TUNER_FC0013=y
CONFIG_MEDIA_TUNER_TDA18212=y
CONFIG_MEDIA_TUNER_E4000=y
CONFIG_MEDIA_TUNER_FC2580=y
# CONFIG_MEDIA_TUNER_TUA9001 is not set
# CONFIG_MEDIA_TUNER_IT913X is not set
# CONFIG_MEDIA_TUNER_R820T is not set

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
CONFIG_AGP_ALI=y
CONFIG_AGP_ATI=y
# CONFIG_AGP_AMD is not set
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
CONFIG_AGP_SIS=y
CONFIG_AGP_SWORKS=y
CONFIG_AGP_VIA=y
# CONFIG_AGP_EFFICEON is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
# CONFIG_DRM_I2C_CH7006 is not set
CONFIG_DRM_I2C_SIL164=y
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
# CONFIG_DRM_RADEON_UMS is not set
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I810=y
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
CONFIG_DRM_SIS=y
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
CONFIG_DRM_VMWGFX=y
CONFIG_DRM_VMWGFX_FBCON=y
CONFIG_DRM_GMA500=y
# CONFIG_DRM_GMA600 is not set
# CONFIG_DRM_GMA3600 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
CONFIG_DRM_MGAG200=y
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_DRM_QXL=y
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
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
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=y
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
CONFIG_FB_VESA=y
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
CONFIG_FB_NVIDIA_DEBUG=y
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
# CONFIG_FB_RIVA is not set
CONFIG_FB_I740=y
# CONFIG_FB_I810 is not set
CONFIG_FB_LE80578=y
# CONFIG_FB_CARILLO_RANCH is not set
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
# CONFIG_FB_RADEON_BACKLIGHT is not set
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=y
# CONFIG_FB_ATY128_BACKLIGHT is not set
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=y
# CONFIG_FB_S3_DDC is not set
CONFIG_FB_SAVAGE=y
# CONFIG_FB_SAVAGE_I2C is not set
# CONFIG_FB_SAVAGE_ACCEL is not set
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
# CONFIG_FB_SIS_315 is not set
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
CONFIG_FB_GEODE=y
# CONFIG_FB_GEODE_LX is not set
CONFIG_FB_GEODE_GX=y
# CONFIG_FB_GEODE_GX1 is not set
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_SM501=y
CONFIG_FB_GOLDFISH=y
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
# CONFIG_FB_AUO_K1901 is not set
# CONFIG_FB_SIMPLE is not set
# CONFIG_EXYNOS_VIDEO is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_MDA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_LOGO is not set
CONFIG_FB_SSD1307=y
# CONFIG_SOUND is not set

#
# HID support
#
# CONFIG_HID is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
# CONFIG_MMC_BLOCK_BOUNCE is not set
CONFIG_SDIO_UART=y
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
# CONFIG_MMC_RICOH_MMC is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=y
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_CB710=y
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_REALTEK_PCI=y
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_CLEVO_MAIL=y
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_PCA9633 is not set
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_DA9052=y
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=y
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_MAX8997=y
# CONFIG_LEDS_LM355x is not set
CONFIG_LEDS_OT200=y
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
CONFIG_ACCESSIBILITY=y
# CONFIG_A11Y_BRAILLE_CONSOLE is not set
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
# CONFIG_INFINIBAND_MTHCA is not set
CONFIG_INFINIBAND_AMSO1100=y
CONFIG_INFINIBAND_AMSO1100_DEBUG=y
CONFIG_MLX4_INFINIBAND=y
CONFIG_MLX5_INFINIBAND=y
# CONFIG_INFINIBAND_NES is not set
CONFIG_INFINIBAND_OCRDMA=y
CONFIG_INFINIBAND_IPOIB=y
# CONFIG_INFINIBAND_IPOIB_CM is not set
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=y
# CONFIG_INFINIBAND_SRPT is not set
CONFIG_INFINIBAND_ISER=y
CONFIG_INFINIBAND_ISERT=y
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_AMD76X is not set
# CONFIG_EDAC_E7XXX is not set
CONFIG_EDAC_E752X=y
CONFIG_EDAC_I82875P=y
CONFIG_EDAC_I82975X=y
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
CONFIG_EDAC_X38=y
CONFIG_EDAC_I5400=y
# CONFIG_EDAC_I82860 is not set
# CONFIG_EDAC_R82600 is not set
CONFIG_EDAC_I5000=y
# CONFIG_EDAC_I5100 is not set
CONFIG_EDAC_I7300=y
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
CONFIG_INTEL_IOATDMA=y
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
# CONFIG_DW_DMAC_PCI is not set
# CONFIG_TIMB_DMA is not set
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y
CONFIG_DMA_OF=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
CONFIG_DCA=y
CONFIG_AUXDISPLAY=y
# CONFIG_KS0108 is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=y
# CONFIG_UIO_PDRV is not set
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
# CONFIG_UIO_PCI_GENERIC is not set
CONFIG_UIO_NETX=y
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_CHROMEOS_LAPTOP is not set
CONFIG_DELL_LAPTOP=y
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
CONFIG_AMILO_RFKILL=y
# CONFIG_HP_ACCEL is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
CONFIG_IBM_RTL=y
# CONFIG_XO1_RFKILL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
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
# CONFIG_EXTCON_GPIO is not set
# CONFIG_EXTCON_MAX8997 is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
CONFIG_VME_TSI148=y

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=y

#
# VME Device Drivers
#
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_PCA9685 is not set
CONFIG_PWM_TWL=y
CONFIG_PWM_TWL_LED=y
CONFIG_IRQCHIP=y
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
CONFIG_SERIAL_IPOCTAL=y
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
# CONFIG_FMC_FAKEDEV is not set
CONFIG_FMC_TRIVIAL=y
CONFIG_FMC_WRITE_EEPROM=y
# CONFIG_FMC_CHARDEV is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_DMIID is not set
CONFIG_DMI_SYSFS=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
CONFIG_XFS_DEBUG=y
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_OCFS2_DEBUG_FS=y
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
# CONFIG_FSCACHE_HISTOGRAM is not set
CONFIG_FSCACHE_DEBUG=y
CONFIG_FSCACHE_OBJECT_LIST=y
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
# CONFIG_ZISOFS is not set
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
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
# CONFIG_ADFS_FS_RW is not set
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=y
# CONFIG_ECRYPT_FS_MESSAGING is not set
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=y
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZO is not set
# CONFIG_SQUASHFS_XZ is not set
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
CONFIG_OMFS_FS=y
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_FTRACE=y
CONFIG_PSTORE_RAM=y
CONFIG_SYSV_FS=y
# CONFIG_UFS_FS is not set
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
# CONFIG_F2FS_FS_XATTR is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
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
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
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
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAIL_MMC_REQUEST=y
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
# CONFIG_LATENCYTOP is not set
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
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
# CONFIG_BRANCH_TRACER is not set
CONFIG_STACK_TRACER=y
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_YAMA=y
CONFIG_SECURITY_YAMA_STACKED=y
# CONFIG_IMA is not set
# CONFIG_EVM is not set
# CONFIG_DEFAULT_SECURITY_YAMA is not set
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
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER_X86=y
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
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_CAMELLIA=y
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_586 is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=y
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
CONFIG_LGUEST=y
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
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
CONFIG_DDR=y
CONFIG_FONT_SUPPORT=y
CONFIG_FONTS=y
# CONFIG_FONT_8x8 is not set
CONFIG_FONT_8x16=y
CONFIG_FONT_6x11=y
# CONFIG_FONT_7x14 is not set
# CONFIG_FONT_PEARL_8x8 is not set
# CONFIG_FONT_ACORN_8x8 is not set
# CONFIG_FONT_MINI_4x6 is not set
# CONFIG_FONT_SUN8x16 is not set
CONFIG_FONT_SUN12x22=y
CONFIG_FONT_10x18=y

--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--HcAYCG3uE/tztfnV--
