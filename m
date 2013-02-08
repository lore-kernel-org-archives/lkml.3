Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420Ab3BHCHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 21:07:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:54688 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460Ab3BHCHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 21:07:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,626,1355126400"; 
   d="log'?scan'208";a="284283541"
Date: Fri, 8 Feb 2013 10:06:59 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: [console_unlock] WARNING: at kernel/sched/clock.c:219
 sched_clock_cpu()
Message-ID: <20130208020659.GE5224@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="JP+T4n/bALQSJXh8"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JP+T4n/bALQSJXh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below oops and the first bad commit is

commit c6a6e37da505d1cd79d8dfa7ac68ef953d2bf6dd
Author: Jan Kara <jack@suse.cz>
Date:   Wed Feb 6 02:04:42 2013 +0000

    printk: Avoid softlockups in console_unlock()
    
    A CPU can be caught in console_unlock() for a long time (tens of seconds
    are reported by our customers) when other CPUs are using printk heavily
    and serial console makes printing slow.  Despite serial console drivers
    are calling touch_nmi_watchdog() this triggers softlockup warnings because
    interrupts are disabled for the whole time console_unlock() runs (e.g.
    vprintk() calls console_unlock() with interrupts disabled).  Thus IPIs
    cannot be processed and other CPUs get stuck spinning in calls like
    smp_call_function_many().  Also RCU eventually starts reporting lockups.
    
    In my artificial testing I also managed to trigger a situation when disk
    disappeared from the system apparently because commands to / from it could
    not be delivered for long enough.  This is why just silencing watchdogs
    isn't a reliable solution to the problem and we simply have to avoid
    spending too long in console_unlock().
    
    We fix the issue by limiting the time we spend in console_unlock() to
    watchdog_thresh() / 4 (unless we are in an early boot stage or oops is
    happening).  The rest of the buffer will be printed either by further
    callers to printk() or by a queued work.
    
    Signed-off-by: Jan Kara <jack@suse.cz>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Steven Rostedt <rostedt@goodmis.org>
    Cc: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

[    0.000000] Console: colour VGA+ 80x25
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at /c/kernel-tests/src/linux/kernel/sched/clock.c:219 sched_clock_cpu+0x65/0x140()
[    0.000000] Hardware name: Bochs
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 3.8.0-rc6-mm1-00539-g83b324c #39
[    0.000000] Call Trace:
[    0.000000]  [<c102ba37>] warn_slowpath_common+0x87/0xb0
[    0.000000]  [<c1063025>] ? sched_clock_cpu+0x65/0x140
[    0.000000]  [<c1063025>] ? sched_clock_cpu+0x65/0x140
[    0.000000]  [<c102ba82>] warn_slowpath_null+0x22/0x30
[    0.000000]  [<c1063025>] sched_clock_cpu+0x65/0x140
[    0.000000]  [<c102d8f9>] __console_unlock+0x39/0x490
[    0.000000]  [<c12eeb23>] ? printk+0x3d/0x3f
[    0.000000]  [<c102dd5d>] console_unlock+0xd/0x20
[    0.000000]  [<c14bbbb0>] con_init+0x1fb/0x20e
[    0.000000]  [<c14bb1b2>] console_init+0x12/0x20
[    0.000000]  [<c149e969>] start_kernel+0x258/0x35f
[    0.000000]  [<c149e4cc>] ? repair_env_string+0x51/0x51
[    0.000000]  [<c149e376>] i386_start_kernel+0x12c/0x12f
[    0.000000] ---[ end trace e006f8c3d589c9a1 ]---

git bisect start 83b324c5ff5cca85bbeb2ba913d465f108afe472 259d51a40fe48cf12038fb8b5a417d1d21d2732e --
git bisect good f8df01c1d7833ff2dfb45ccd0017c38c7e803872  #    10  2013-02-06 18:47:56  memcg: debugging facility to access dangling memcgs
git bisect  bad 4538bd3e5b6543108230b034cccd8011ba968496  #     0  2013-02-06 19:18:10  Documentation/cgroups/blkio-controller.txt: fix typo
git bisect  bad a612644e542ef0212d668d2ecee308e8d57cd2e4  #     0  2013-02-06 19:19:36  drivers/video/backlight/ld9040.c: use devm_regulator_bulk_get() API
git bisect  bad c48d189f2ef81158f786a84975ad8db05278f6dd  #     0  2013-02-06 19:20:45  backlight: s6e63m0: remove unnecessary NULL deference check
git bisect good d78fb70a902de2247e9e44fcf7b8e73b96a4a7b3  #    10  2013-02-06 19:52:00  kernel/smp.c: cleanups
git bisect  bad 10fdc3252f827e3ab9652870773349e099e2f4d6  #     0  2013-02-06 20:22:12  backlight-add-lms501kf03-lcd-driver-fix-fix
git bisect  bad 6c35e4b5601ad676682232beed50d558bef11331  #     0  2013-02-06 20:23:31  get_maintainer.pl: find maintainers for removed files
git bisect  bad c6a6e37da505d1cd79d8dfa7ac68ef953d2bf6dd  #     0  2013-02-06 20:24:42  printk: Avoid softlockups in console_unlock()
git bisect good 8e798f4e517d1f32fe9794e75802d4e864a916b7  #    10  2013-02-06 20:55:59  lib/vsprintf.c: add git bisect good 8e798f4e517d1f32fe9794e75802d4e864a916b7  #    30  2013-02-06 22:26:32  lib/vsprintf.c: add git bisect good 1587f71ebbf5aedf754062baa11fcc9e9b49ecf0  #    30  2013-02-07 00:27:22  Add linux-next specific files for 20130125

Thanks,
Fengguang

--JP+T4n/bALQSJXh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-inn-53699-2013-02-06-14-21-18-3.8.0-rc6-mm1-00539-g83b324c-39"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8.0-rc6-mm1-00539-g83b324c (kbuild@bee) (gcc=
 version 4.7.2 (Debian 4.7.2-4) ) #39 Wed Feb 6 11:20:20 CST 2013
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] ACPI: RSDP 000fd930 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC=
 00000001)
[    0.000000] ACPI: DSDT 0fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL=
 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: APIC 0ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC=
 00000001)
[    0.000000] ACPI: HPET 0ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC=
 00000001)
[    0.000000] ACPI: SSDT 0ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL=
 20100528)
[    0.000000] initial memory mapped: [mem 0x00000000-0x01ffffff]
[    0.000000] Base memory trampoline at [c008f000] 8f000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0e73efff]
[    0.000000]  [mem 0x0e400000-0x0e73efff] page 2M
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0e3fffff]
[    0.000000]  [mem 0x08000000-0x0e3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x07ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e73f000-0x0fffdfff]
[    0.000000]  [mem 0x0e73f000-0x0e7fffff] page 2M
[    0.000000]  [mem 0x0e800000-0x0fbfffff] page 2M
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x01ae5000, 0x01ae5fff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127492(97%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] BRK [0x01ae6000, 0x01ae6fff] PGTABLE
[    0.000000] sizeof(struct page) =3D 32
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000] Node 0 memmap at 0xcdd3f000 size 2097152 first pfn 0xcdd3f200
[    0.000000] free_area_init_node: node 0, pgdat c147bbc0, node_mem_map cd=
d3f200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3971 pages, LIFO batch:0
[    0.000000]   Normal zone: 480 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1451d40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64897
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 branch=3Dmmotm/master log_buf_len=3D8M ignore_loglevel deb=
ug sched_debug apic=3Ddebug dynamic_printk sysrq_always_enabled panic=3D10 =
 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  roo=
t=3D/dev/ram0 rw link=3Dvmlinuz-2013-02-06-11-20-52-mmotm:master:83b324c-83=
b324c-i386-randconfig-b030-9-waimea-retry-inn BOOT_IMAGE=3Dkernel-tests/ker=
nels/i386-randconfig-b030/83b324c/vmlinuz-3.8.0-rc6-mm1-00539-g83b324c
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] allocated 524144 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 214156k/262136k available (3040k kernel code, 47480k=
 reserved, 1683k data, 424k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe2000 - 0xfffff000   ( 116 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff7fe000   ( 752 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc149e000 - 0xc1508000   ( 424 kB)
[    0.000000]       .data : 0xc12f832d - 0xc149d280   (1683 kB)
[    0.000000]       .text : 0xc1000000 - 0xc12f832d   (3040 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D1, =
Nodes=3D1
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3Dcd80e000 soft=3Dcd810000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at /c/kernel-tests/src/linux/kernel/sched/clock.c:2=
19 sched_clock_cpu+0x65/0x140()
[    0.000000] Hardware name: Bochs
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 3.8.0-rc6-mm1-00539-g83b32=
4c #39
[    0.000000] Call Trace:
[    0.000000]  [<c102ba37>] warn_slowpath_common+0x87/0xb0
[    0.000000]  [<c1063025>] ? sched_clock_cpu+0x65/0x140
[    0.000000]  [<c1063025>] ? sched_clock_cpu+0x65/0x140
[    0.000000]  [<c102ba82>] warn_slowpath_null+0x22/0x30
[    0.000000]  [<c1063025>] sched_clock_cpu+0x65/0x140
[    0.000000]  [<c102d8f9>] __console_unlock+0x39/0x490
[    0.000000]  [<c12eeb23>] ? printk+0x3d/0x3f
[    0.000000]  [<c102dd5d>] console_unlock+0xd/0x20
[    0.000000]  [<c14bbbb0>] con_init+0x1fb/0x20e
[    0.000000]  [<c14bb1b2>] console_init+0x12/0x20
[    0.000000]  [<c149e969>] start_kernel+0x258/0x35f
[    0.000000]  [<c149e4cc>] ? repair_env_string+0x51/0x51
[    0.000000]  [<c149e376>] i386_start_kernel+0x12c/0x12f
[    0.000000] ---[ end trace e006f8c3d589c9a1 ]---
[    0.000000] console [tty0] enabled
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
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
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
[    0.000000] ODEBUG: 6 of 6 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.560 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5387.12 Bogo=
MIPS (lpj=3D26935600)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] Security Framework initialized
[    0.020000] Mount-cache hash table entries: 512
[    0.020000] Initializing cgroup subsys debug
[    0.020000] Initializing cgroup subsys memory
[    0.020000] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020000] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020000] tlb_flushall_shift: 6
[    0.020006] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.024054] ACPI: Core revision 20130117
[    0.057490] ACPI: All ACPI Tables successfully acquired
[    0.058595] ACPI: setting ELCR to 0200 (from 0c00)
[    0.059506] ftrace: allocating 12541 entries in 25 pages
[    0.070418] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.073130] Testing tracer nop: PASSED
[    0.075175] devtmpfs: initialized
[    0.076117] device: 'platform': device_add
[    0.080067] PM: Adding info for No Bus:platform
[    0.081063] bus: 'platform': registered
[    0.081923] bus: 'cpu': registered
[    0.082635] device: 'cpu': device_add
[    0.083463] PM: Adding info for No Bus:cpu
[    0.085014] Testing tracer function: PASSED
[    0.241142] Testing dynamic ftrace: PASSED
[    0.500460] Testing dynamic ftrace ops #1: (1 0 1 1 0) (1 1 2 1 0) (2 1 =
3 1 3) (2 2 4 1 240) PASSED
[    0.608207] Testing dynamic ftrace ops #2: (1 0 1 3 0) (1 1 2 218 0) (2 =
1 3 1 3) (2 2 4 238 240) PASSED
[    0.758826] Testing ftrace recursion: PASSED
[    0.768121] Testing ftrace recursion safe: PASSED
[    0.777467] Testing ftrace regs: PASSED
[    0.786690] Testing tracer wakeup: ret =3D 0
[    0.930052] ftrace-test (10) used greatest stack depth: 7172 bytes left
[    0.931260] PASSED
[    0.931791] Testing tracer wakeup_rt: ret =3D 0
[    1.070091] PASSED
[    1.070703] Testing tracer function_graph: PASSED
[    1.245940] Testing tracer branch: PASSED
[    1.350894] device class 'regulator': registering
[    1.352886] Registering platform device 'reg-dummy'. Parent at platform
[    1.354723] device: 'reg-dummy': device_add
[    1.355558] bus: 'platform': add device reg-dummy
[    1.356520] PM: Adding info for platform:reg-dummy
[    1.357456] bus: 'platform': add driver reg-dummy
[    1.358369] bus: 'platform': driver_probe_device: matched device reg-dum=
my with driver reg-dummy
[    1.360007] bus: 'platform': really_probe: probing driver reg-dummy with=
 device reg-dummy
[    1.361672] device: 'regulator.0': device_add
[    1.362727] PM: Adding info for No Bus:regulator.0
[    1.363737] regulator-dummy: no parameters
[    1.364650] driver: 'reg-dummy': driver_bound: bound to device 'reg-dumm=
y'
[    1.365803] bus: 'platform': really_probe: bound device reg-dummy to dri=
ver reg-dummy
[    1.367777] NET: Registered protocol family 16
[    1.368751] device class 'bdi': registering
[    1.369656] device class 'pci_bus': registering
[    1.370149] bus: 'pci': registered
[    1.370864] device class 'tty': registering
[    1.371733] device class 'vtconsole': registering
[    1.372677] device: 'vtcon0': device_add
[    1.373549] PM: Adding info for No Bus:vtcon0
[    1.374568] bus: 'spi': registered
[    1.375264] device class 'spi_master': registering
[    1.376296] ACPI: bus type pci registered
[    1.377189] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=3D0
[    1.378266] PCI: Using configuration type 1 for base access
[    1.379293] device: 'cpu0': device_add
[    1.380027] bus: 'cpu': add device cpu0
[    1.380837] PM: Adding info for cpu:cpu0
[    1.385995] device: 'default': device_add
[    1.386922] PM: Adding info for No Bus:default
[    1.388211] bio: create slab <bio-0> at 0
[    1.389179] device class 'block': registering
[    1.390373] ACPI: Added _OSI(Module Device)
[    1.391183] ACPI: Added _OSI(Processor Device)
[    1.392008] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.392916] ACPI: Added _OSI(Processor Aggregator Device)
[    1.395498] ACPI: EC: Look up EC in DSDT
[    1.441560] ACPI: Interpreter enabled
[    1.442294] ACPI: (supports S0ACPI Exception: AE_NOT_FOUND, While evalua=
ting Sleep State [\_S1_] (20130117/hwxface-568)
[    1.444361] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20130117/hwxface-568)
[    1.446155]  S3 S5)
[    1.446898] ACPI: Using PIC for interrupt routing
[    1.447902] bus: 'acpi': registered
[    1.448610] PCI: Ignoring host bridge windows from ACPI; if necessary, u=
se "pci=3Duse_crs" and report a bug
[    1.450224] device: 'LNXSYSTM:00': device_add
[    1.452975] bus: 'acpi': add device LNXSYSTM:00
[    1.453879] PM: Adding info for acpi:LNXSYSTM:00
[    1.455500] device: 'LNXSYBUS:00': device_add
[    1.456337] bus: 'acpi': add device LNXSYBUS:00
[    1.457221] PM: Adding info for acpi:LNXSYBUS:00
[    1.458866] device: 'PNP0A03:00': device_add
[    1.460008] bus: 'acpi': add device PNP0A03:00
[    1.460885] PM: Adding info for acpi:PNP0A03:00
[    1.464059] device: 'device:00': device_add
[    1.464873] bus: 'acpi': add device device:00
[    1.465730] PM: Adding info for acpi:device:00
[    1.467273] device: 'device:01': device_add
[    1.468087] bus: 'acpi': add device device:01
[    1.468941] PM: Adding info for acpi:device:01
[    1.470478] device: 'PNP0B00:00': device_add
[    1.471334] bus: 'acpi': add device PNP0B00:00
[    1.472200] PM: Adding info for acpi:PNP0B00:00
[    1.474047] device: 'PNP0303:00': device_add
[    1.474908] bus: 'acpi': add device PNP0303:00
[    1.475796] PM: Adding info for acpi:PNP0303:00
[    1.477646] device: 'PNP0F13:00': device_add
[    1.478469] bus: 'acpi': add device PNP0F13:00
[    1.479369] PM: Adding info for acpi:PNP0F13:00
[    1.481055] device: 'PNP0700:00': device_add
[    1.481876] bus: 'acpi': add device PNP0700:00
[    1.482786] PM: Adding info for acpi:PNP0700:00
[    1.485961] device: 'PNP0400:00': device_add
[    1.486827] bus: 'acpi': add device PNP0400:00
[    1.487715] PM: Adding info for acpi:PNP0400:00
[    1.490961] device: 'PNP0501:00': device_add
[    1.491802] bus: 'acpi': add device PNP0501:00
[    1.492674] PM: Adding info for acpi:PNP0501:00
[    1.494883] device: 'device:02': device_add
[    1.495707] bus: 'acpi': add device device:02
[    1.496575] PM: Adding info for acpi:device:02
[    1.498154] device: 'device:03': device_add
[    1.498998] bus: 'acpi': add device device:03
[    1.499873] PM: Adding info for acpi:device:03
[    1.500755] device: 'device:04': device_add
[    1.501566] bus: 'acpi': add device device:04
[    1.502463] PM: Adding info for acpi:device:04
[    1.504097] device: 'device:05': device_add
[    1.504906] bus: 'acpi': add device device:05
[    1.505768] PM: Adding info for acpi:device:05
[    1.507438] device: 'device:06': device_add
[    1.508264] bus: 'acpi': add device device:06
[    1.509134] PM: Adding info for acpi:device:06
[    1.510864] device: 'device:07': device_add
[    1.511678] bus: 'acpi': add device device:07
[    1.512552] PM: Adding info for acpi:device:07
[    1.514223] device: 'device:08': device_add
[    1.515039] bus: 'acpi': add device device:08
[    1.515900] PM: Adding info for acpi:device:08
[    1.517522] device: 'device:09': device_add
[    1.518367] bus: 'acpi': add device device:09
[    1.519243] PM: Adding info for acpi:device:09
[    1.520817] device: 'device:0a': device_add
[    1.521631] bus: 'acpi': add device device:0a
[    1.522519] PM: Adding info for acpi:device:0a
[    1.524143] device: 'device:0b': device_add
[    1.524977] bus: 'acpi': add device device:0b
[    1.525834] PM: Adding info for acpi:device:0b
[    1.527475] device: 'device:0c': device_add
[    1.528291] bus: 'acpi': add device device:0c
[    1.529170] PM: Adding info for acpi:device:0c
[    1.530824] device: 'device:0d': device_add
[    1.531637] bus: 'acpi': add device device:0d
[    1.532486] PM: Adding info for acpi:device:0d
[    1.534143] device: 'device:0e': device_add
[    1.534958] bus: 'acpi': add device device:0e
[    1.535824] PM: Adding info for acpi:device:0e
[    1.537432] device: 'device:0f': device_add
[    1.538275] bus: 'acpi': add device device:0f
[    1.539141] PM: Adding info for acpi:device:0f
[    1.540827] device: 'device:10': device_add
[    1.541650] bus: 'acpi': add device device:10
[    1.542534] PM: Adding info for acpi:device:10
[    1.544222] device: 'device:11': device_add
[    1.545032] bus: 'acpi': add device device:11
[    1.545919] PM: Adding info for acpi:device:11
[    1.547585] device: 'device:12': device_add
[    1.548393] bus: 'acpi': add device device:12
[    1.550061] PM: Adding info for acpi:device:12
[    1.551751] device: 'device:13': device_add
[    1.552573] bus: 'acpi': add device device:13
[    1.553431] PM: Adding info for acpi:device:13
[    1.555087] device: 'device:14': device_add
[    1.555903] bus: 'acpi': add device device:14
[    1.556758] PM: Adding info for acpi:device:14
[    1.558410] device: 'device:15': device_add
[    1.559262] bus: 'acpi': add device device:15
[    1.560061] PM: Adding info for acpi:device:15
[    1.561702] device: 'device:16': device_add
[    1.562514] bus: 'acpi': add device device:16
[    1.563428] PM: Adding info for acpi:device:16
[    1.565055] device: 'device:17': device_add
[    1.565870] bus: 'acpi': add device device:17
[    1.566764] PM: Adding info for acpi:device:17
[    1.568427] device: 'device:18': device_add
[    1.569252] bus: 'acpi': add device device:18
[    1.570061] PM: Adding info for acpi:device:18
[    1.571730] device: 'device:19': device_add
[    1.572544] bus: 'acpi': add device device:19
[    1.573417] PM: Adding info for acpi:device:19
[    1.575076] device: 'device:1a': device_add
[    1.575903] bus: 'acpi': add device device:1a
[    1.576764] PM: Adding info for acpi:device:1a
[    1.578399] device: 'device:1b': device_add
[    1.579268] bus: 'acpi': add device device:1b
[    1.580065] PM: Adding info for acpi:device:1b
[    1.581709] device: 'device:1c': device_add
[    1.582560] bus: 'acpi': add device device:1c
[    1.583421] PM: Adding info for acpi:device:1c
[    1.585079] device: 'device:1d': device_add
[    1.585894] bus: 'acpi': add device device:1d
[    1.586793] PM: Adding info for acpi:device:1d
[    1.588444] device: 'device:1e': device_add
[    1.589274] bus: 'acpi': add device device:1e
[    1.590070] PM: Adding info for acpi:device:1e
[    1.591731] device: 'device:1f': device_add
[    1.592555] bus: 'acpi': add device device:1f
[    1.593413] PM: Adding info for acpi:device:1f
[    1.595083] device: 'device:20': device_add
[    1.595895] bus: 'acpi': add device device:20
[    1.596762] PM: Adding info for acpi:device:20
[    1.598409] device: 'device:21': device_add
[    1.599244] bus: 'acpi': add device device:21
[    1.600069] PM: Adding info for acpi:device:21
[    1.604595] device: 'PNP0103:00': device_add
[    1.605436] bus: 'acpi': add device PNP0103:00
[    1.606332] PM: Adding info for acpi:PNP0103:00
[    1.609347] device: 'PNP0C0F:00': device_add
[    1.610051] bus: 'acpi': add device PNP0C0F:00
[    1.610949] PM: Adding info for acpi:PNP0C0F:00
[    1.613665] device: 'PNP0C0F:01': device_add
[    1.614521] bus: 'acpi': add device PNP0C0F:01
[    1.615388] PM: Adding info for acpi:PNP0C0F:01
[    1.618128] device: 'PNP0C0F:02': device_add
[    1.618963] bus: 'acpi': add device PNP0C0F:02
[    1.620071] PM: Adding info for acpi:PNP0C0F:02
[    1.622800] device: 'PNP0C0F:03': device_add
[    1.623631] bus: 'acpi': add device PNP0C0F:03
[    1.624510] PM: Adding info for acpi:PNP0C0F:03
[    1.627241] device: 'PNP0C0F:04': device_add
[    1.628071] bus: 'acpi': add device PNP0C0F:04
[    1.628954] PM: Adding info for acpi:PNP0C0F:04
[    1.631026] device: 'LNXCPU:00': device_add
[    1.631851] bus: 'acpi': add device LNXCPU:00
[    1.632715] PM: Adding info for acpi:LNXCPU:00
[    1.634527] device: 'LNXCPU:01': device_add
[    1.635351] bus: 'acpi': add device LNXCPU:01
[    1.636232] PM: Adding info for acpi:LNXCPU:01
[    1.637748] device: 'LNXSYBUS:01': device_add
[    1.638624] bus: 'acpi': add device LNXSYBUS:01
[    1.639515] PM: Adding info for acpi:LNXSYBUS:01
[    1.640320] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.641376] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.650999] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    1.652633] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ign=
ored)
[    1.653781] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ign=
ored)
[    1.654953] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bff=
ff] (ignored)
[    1.656418] acpi PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfff=
ff] (ignored)
[    1.657871] PCI: root bus 00: using default resources
[    1.658821] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    1.660056] device: 'pci0000:00': device_add
[    1.660982] PM: Adding info for No Bus:pci0000:00
[    1.661851] device: '0000:00': device_add
[    1.662815] PM: Adding info for No Bus:0000:00
[    1.663709] PCI host bridge to bus 0000:00
[    1.664501] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.665452] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    1.666520] pci_bus 0000:00: root bus resource [mem 0x00000000-0xfffffff=
f]
[    1.667719] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.668993] device: '0000:00:00.0': device_add
[    1.672204] bus: 'pci': add device 0000:00:00.0
[    1.673247] PM: Adding info for pci:0000:00:00.0
[    1.676076] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.677424] device: '0000:00:01.0': device_add
[    1.678500] bus: 'pci': add device 0000:00:01.0
[    1.680132] PM: Adding info for pci:0000:00:01.0
[    1.681059] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.683733] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    1.685357] device: '0000:00:01.1': device_add
[    1.688408] bus: 'pci': add device 0000:00:01.1
[    1.689449] PM: Adding info for pci:0000:00:01.1
[    1.690104] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.691450] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    1.692818] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    1.694043] device: '0000:00:01.3': device_add
[    1.695176] bus: 'pci': add device 0000:00:01.3
[    1.696197] PM: Adding info for pci:0000:00:01.3
[    1.697145] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.700060] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    1.702002] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    1.706929] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    1.708171] device: '0000:00:02.0': device_add
[    1.709315] bus: 'pci': add device 0000:00:02.0
[    1.710246] PM: Adding info for pci:0000:00:02.0
[    1.711262] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.712893] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    1.714529] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    1.718366] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    1.719536] device: '0000:00:03.0': device_add
[    1.720489] bus: 'pci': add device 0000:00:03.0
[    1.721513] PM: Adding info for pci:0000:00:03.0
[    1.722482] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    1.724156] pci 0000:00:04.0: reg 10: [io  0xc040-0xc07f]
[    1.725692] pci 0000:00:04.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
[    1.730440] device: '0000:00:04.0': device_add
[    1.731831] bus: 'pci': add device 0000:00:04.0
[    1.733098] PM: Adding info for pci:0000:00:04.0
[    1.734038] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    1.735721] pci 0000:00:05.0: reg 10: [io  0xc080-0xc0bf]
[    1.737270] pci 0000:00:05.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[    1.741609] device: '0000:00:05.0': device_add
[    1.743057] bus: 'pci': add device 0000:00:05.0
[    1.744089] PM: Adding info for pci:0000:00:05.0
[    1.745043] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.746683] pci 0000:00:06.0: reg 10: [io  0xc0c0-0xc0ff]
[    1.748248] pci 0000:00:06.0: reg 14: [mem 0xfebf3000-0xfebf3fff]
[    1.752229] device: '0000:00:06.0': device_add
[    1.753715] bus: 'pci': add device 0000:00:06.0
[    1.754765] PM: Adding info for pci:0000:00:06.0
[    1.755710] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.757357] pci 0000:00:07.0: reg 10: [io  0xc100-0xc13f]
[    1.758900] pci 0000:00:07.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    1.763116] device: '0000:00:07.0': device_add
[    1.764672] bus: 'pci': add device 0000:00:07.0
[    1.765698] PM: Adding info for pci:0000:00:07.0
[    1.766673] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.768326] pci 0000:00:08.0: reg 10: [io  0xc140-0xc17f]
[    1.769864] pci 0000:00:08.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    1.773311] device: '0000:00:08.0': device_add
[    1.774962] bus: 'pci': add device 0000:00:08.0
[    1.775990] PM: Adding info for pci:0000:00:08.0
[    1.776928] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.778631] pci 0000:00:09.0: reg 10: [io  0xc180-0xc1bf]
[    1.780603] pci 0000:00:09.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    1.784736] device: '0000:00:09.0': device_add
[    1.786429] bus: 'pci': add device 0000:00:09.0
[    1.787459] PM: Adding info for pci:0000:00:09.0
[    1.788399] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    1.790344] pci 0000:00:0a.0: reg 10: [mem 0xfebf7000-0xfebf700f]
[    1.793332] device: '0000:00:0a.0': device_add
[    1.795072] bus: 'pci': add device 0000:00:0a.0
[    1.796113] PM: Adding info for pci:0000:00:0a.0
[    1.797139] pci_bus 0000:00: on NUMA node 0
[    1.797919] ACPI _OSC control for PCIe not granted, disabling ASPM
[    1.805601] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.808745] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.811847] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.814975] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.817962] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    1.821092] device: 'LNXPWRBN:00': device_add
[    1.821939] bus: 'acpi': add device LNXPWRBN:00
[    1.822866] PM: Adding info for acpi:LNXPWRBN:00
[    1.824012] ACPI: Enabled 16 GPEs in block 00 to 0F
[    1.825026] acpi root: \_SB_.PCI0 notify handler is installed
[    1.826069] Found 1 acpi root devices
[    1.826787] bus: 'acpi': add driver ec
[    1.827861] bus: 'pnp': registered
[    1.828585] device class 'misc': registering
[    1.829542] device: 'vga_arbiter': device_add
[    1.830327] PM: Adding info for No Bus:vga_arbiter
[    1.831291] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.832782] vgaarb: loaded
[    1.833391] vgaarb: bridge control possible 0000:00:02.0
[    1.834314] bus: 'spi': add driver stmpe-spi
[    1.835164] bus: 'spi': add driver ezx-pcap
[    1.836106] bus: 'serio': registered
[    1.836813] device class 'input': registering
[    1.837715] device class 'power_supply': registering
[    1.838638] PCI: Using ACPI for IRQ routing
[    1.839429] PCI: pci_cache_line_size set to 64 bytes
[    1.840198] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    1.841238] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    1.842359] device class 'net': registering
[    1.843303] device: 'lo': device_add
[    1.844427] PM: Adding info for No Bus:lo
[    1.845736] Switching to clocksource kvm-clock
[    1.847483] Warning: could not register annotated branches stats
[    1.864766] bus: 'pnp': add driver system
[    1.865602] pnp: PnP ACPI init
[    1.866276] device: 'pnp0': device_add
[    1.867039] PM: Adding info for No Bus:pnp0
[    1.867838] ACPI: bus type pnp registered
[    1.868846] device: '00:00': device_add
[    1.869653] bus: 'pnp': add device 00:00
[    1.870577] PM: Adding info for pnp:00:00
[    1.871395] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.873008] device: '00:01': device_add
[    1.873814] bus: 'pnp': add device 00:01
[    1.874640] PM: Adding info for pnp:00:01
[    1.875437] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.877034] device: '00:02': device_add
[    1.877850] bus: 'pnp': add device 00:02
[    1.878671] PM: Adding info for pnp:00:02
[    1.879470] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.881133] pnp 00:03: [dma 2]
[    1.881801] device: '00:03': device_add
[    1.882624] bus: 'pnp': add device 00:03
[    1.883446] PM: Adding info for pnp:00:03
[    1.884250] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.886252] device: '00:04': device_add
[    1.887054] bus: 'pnp': add device 00:04
[    1.887885] PM: Adding info for pnp:00:04
[    1.888694] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.890776] device: '00:05': device_add
[    1.891589] bus: 'pnp': add device 00:05
[    1.892418] PM: Adding info for pnp:00:05
[    1.893225] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.896861] device: '00:06': device_add
[    1.897700] bus: 'pnp': add device 00:06
[    1.898521] PM: Adding info for pnp:00:06
[    1.899321] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.902841] pnp: PnP ACPI: found 7 devices
[    1.903615] ACPI: ACPI bus type pnp unregistered
[    1.904452] PnPBIOS: Disabled
[    1.939714] device class 'mem': registering
[    1.940633] device: 'mem': device_add
[    1.941503] PM: Adding info for No Bus:mem
[    1.942358] device: 'kmem': device_add
[    1.943190] PM: Adding info for No Bus:kmem
[    1.944013] device: 'null': device_add
[    1.944852] PM: Adding info for No Bus:null
[    1.945707] device: 'port': device_add
[    1.946549] PM: Adding info for No Bus:port
[    1.947385] device: 'zero': device_add
[    1.948231] PM: Adding info for No Bus:zero
[    1.949050] device: 'full': device_add
[    1.949882] PM: Adding info for No Bus:full
[    1.950800] device: 'random': device_add
[    1.951665] PM: Adding info for No Bus:random
[    1.952519] device: 'urandom': device_add
[    1.953378] PM: Adding info for No Bus:urandom
[    1.954234] device: 'kmsg': device_add
[    1.955097] PM: Adding info for No Bus:kmsg
[    1.955929] device: 'tty': device_add
[    1.956778] PM: Adding info for No Bus:tty
[    1.957621] device: 'console': device_add
[    1.958491] PM: Adding info for No Bus:console
[    1.959385] device: 'tty0': device_add
[    1.960300] PM: Adding info for No Bus:tty0
[    1.961152] device class 'vc': registering
[    1.961989] device: 'vcs': device_add
[    1.962880] PM: Adding info for No Bus:vcs
[    1.963729] device: 'vcsa': device_add
[    1.964563] PM: Adding info for No Bus:vcsa
[    1.965394] device: 'vcs1': device_add
[    1.966241] PM: Adding info for No Bus:vcs1
[    1.967089] device: 'vcsa1': device_add
[    1.967951] PM: Adding info for No Bus:vcsa1
[    1.968849] device: 'tty1': device_add
[    1.969703] PM: Adding info for No Bus:tty1
[    1.972493] device: 'tty2': device_add
[    1.973374] PM: Adding info for No Bus:tty2
[    1.974209] device: 'tty3': device_add
[    1.975061] PM: Adding info for No Bus:tty3
[    1.975912] device: 'tty4': device_add
[    1.976767] PM: Adding info for No Bus:tty4
[    1.977606] device: 'tty5': device_add
[    1.978475] PM: Adding info for No Bus:tty5
[    1.979310] device: 'tty6': device_add
[    1.980260] PM: Adding info for No Bus:tty6
[    1.981099] device: 'tty7': device_add
[    1.981948] PM: Adding info for No Bus:tty7
[    1.982805] device: 'tty8': device_add
[    1.983647] PM: Adding info for No Bus:tty8
[    1.984500] device: 'tty9': device_add
[    1.985366] PM: Adding info for No Bus:tty9
[    1.986202] device: 'tty10': device_add
[    1.987049] PM: Adding info for No Bus:tty10
[    1.987898] device: 'tty11': device_add
[    1.988771] PM: Adding info for No Bus:tty11
[    1.989658] device: 'tty12': device_add
[    1.990587] PM: Adding info for No Bus:tty12
[    1.991437] device: 'tty13': device_add
[    1.992311] PM: Adding info for No Bus:tty13
[    1.993172] device: 'tty14': device_add
[    1.994026] PM: Adding info for No Bus:tty14
[    1.994877] device: 'tty15': device_add
[    1.995743] PM: Adding info for No Bus:tty15
[    1.996616] device: 'tty16': device_add
[    1.997475] PM: Adding info for No Bus:tty16
[    1.998320] device: 'tty17': device_add
[    1.999195] PM: Adding info for No Bus:tty17
[    2.000109] device: 'tty18': device_add
[    2.000984] PM: Adding info for No Bus:tty18
[    2.001833] device: 'tty19': device_add
[    2.002706] PM: Adding info for No Bus:tty19
[    2.003558] device: 'tty20': device_add
[    2.004412] PM: Adding info for No Bus:tty20
[    2.005286] device: 'tty21': device_add
[    2.006151] PM: Adding info for No Bus:tty21
[    2.006996] device: 'tty22': device_add
[    2.007861] PM: Adding info for No Bus:tty22
[    2.008729] device: 'tty23': device_add
[    2.009604] PM: Adding info for No Bus:tty23
[    2.010539] device: 'tty24': device_add
[    2.011402] PM: Adding info for No Bus:tty24
[    2.012260] device: 'tty25': device_add
[    2.013164] PM: Adding info for No Bus:tty25
[    2.014015] device: 'tty26': device_add
[    2.014866] PM: Adding info for No Bus:tty26
[    2.015711] device: 'tty27': device_add
[    2.016580] PM: Adding info for No Bus:tty27
[    2.017438] device: 'tty28': device_add
[    2.018293] PM: Adding info for No Bus:tty28
[    2.019139] device: 'tty29': device_add
[    2.020013] PM: Adding info for No Bus:tty29
[    2.020923] device: 'tty30': device_add
[    2.021797] PM: Adding info for No Bus:tty30
[    2.022654] device: 'tty31': device_add
[    2.023528] PM: Adding info for No Bus:tty31
[    2.024378] device: 'tty32': device_add
[    2.025232] PM: Adding info for No Bus:tty32
[    2.026080] device: 'tty33': device_add
[    2.026943] PM: Adding info for No Bus:tty33
[    2.027801] device: 'tty34': device_add
[    2.028653] PM: Adding info for No Bus:tty34
[    2.029529] device: 'tty35': device_add
[    2.030596] PM: Adding info for No Bus:tty35
[    2.031457] device: 'tty36': device_add
[    2.032359] PM: Adding info for No Bus:tty36
[    2.033209] device: 'tty37': device_add
[    2.034079] PM: Adding info for No Bus:tty37
[    2.034927] device: 'tty38': device_add
[    2.035779] PM: Adding info for No Bus:tty38
[    2.036629] device: 'tty39': device_add
[    2.037494] PM: Adding info for No Bus:tty39
[    2.038351] device: 'tty40': device_add
[    2.039212] PM: Adding info for No Bus:tty40
[    2.040122] device: 'tty41': device_add
[    2.040990] PM: Adding info for No Bus:tty41
[    2.041842] device: 'tty42': device_add
[    2.042710] PM: Adding info for No Bus:tty42
[    2.043554] device: 'tty43': device_add
[    2.044421] PM: Adding info for No Bus:tty43
[    2.045267] device: 'tty44': device_add
[    2.046135] PM: Adding info for No Bus:tty44
[    2.046983] device: 'tty45': device_add
[    2.047847] PM: Adding info for No Bus:tty45
[    2.048714] device: 'tty46': device_add
[    2.049579] PM: Adding info for No Bus:tty46
[    2.050529] device: 'tty47': device_add
[    2.051400] PM: Adding info for No Bus:tty47
[    2.052258] device: 'tty48': device_add
[    2.053137] PM: Adding info for No Bus:tty48
[    2.053978] device: 'tty49': device_add
[    2.054861] PM: Adding info for No Bus:tty49
[    2.055707] device: 'tty50': device_add
[    2.056556] PM: Adding info for No Bus:tty50
[    2.057403] device: 'tty51': device_add
[    2.058268] PM: Adding info for No Bus:tty51
[    2.059127] device: 'tty52': device_add
[    2.059977] PM: Adding info for No Bus:tty52
[    2.060882] device: 'tty53': device_add
[    2.061769] PM: Adding info for No Bus:tty53
[    2.062641] device: 'tty54': device_add
[    2.063509] PM: Adding info for No Bus:tty54
[    2.064357] device: 'tty55': device_add
[    2.065218] PM: Adding info for No Bus:tty55
[    2.066065] device: 'tty56': device_add
[    2.066922] PM: Adding info for No Bus:tty56
[    2.067777] device: 'tty57': device_add
[    2.068643] PM: Adding info for No Bus:tty57
[    2.069504] device: 'tty58': device_add
[    2.070436] PM: Adding info for No Bus:tty58
[    2.071299] device: 'tty59': device_add
[    2.072169] PM: Adding info for No Bus:tty59
[    2.073025] device: 'tty60': device_add
[    2.073878] PM: Adding info for No Bus:tty60
[    2.074726] device: 'tty61': device_add
[    2.075602] PM: Adding info for No Bus:tty61
[    2.076449] device: 'tty62': device_add
[    2.077416] PM: Adding info for No Bus:tty62
[    2.078263] device: 'tty63': device_add
[    2.079181] PM: Adding info for No Bus:tty63
[    2.080292] device class 'firmware': registering
[    2.081191] device class 'thermal': registering
[    2.082211] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    2.083175] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[    2.084304] NET: Registered protocol family 1
[    2.085156] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.086159] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    2.087155] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    2.088212] pci 0000:00:02.0: Boot video device
[    2.089101] PCI: CLS 0 bytes, default 64
[    2.090407] Unpacking initramfs...
[    3.324842] Freeing initrd memory: 25284k freed
[    3.335445] Registering platform device 'pcspkr'. Parent at platform
[    3.336520] device: 'pcspkr': device_add
[    3.337297] bus: 'platform': add device pcspkr
[    3.338169] PM: Adding info for platform:pcspkr
[    3.339393] bus: 'clocksource': registered
[    3.340283] device: 'clocksource': device_add
[    3.341122] PM: Adding info for No Bus:clocksource
[    3.341990] device: 'clocksource0': device_add
[    3.342831] bus: 'clocksource': add device clocksource0
[    3.343815] PM: Adding info for clocksource:clocksource0
[    3.344797] bus: 'platform': add driver alarmtimer
[    3.345745] Registering platform device 'alarmtimer'. Parent at platform
[    3.346838] device: 'alarmtimer': device_add
[    3.347683] bus: 'platform': add device alarmtimer
[    3.348585] PM: Adding info for platform:alarmtimer
[    3.349498] bus: 'platform': driver_probe_device: matched device alarmti=
mer with driver alarmtimer
[    3.351131] bus: 'platform': really_probe: probing driver alarmtimer wit=
h device alarmtimer
[    3.352677] driver: 'alarmtimer': driver_bound: bound to device 'alarmti=
mer'
[    3.353831] bus: 'platform': really_probe: bound device alarmtimer to dr=
iver alarmtimer
[    3.355689] bus: 'event_source': registered
[    3.356506] device: 'breakpoint': device_add
[    3.357322] bus: 'event_source': add device breakpoint
[    3.358297] PM: Adding info for event_source:breakpoint
[    3.359304] device: 'tracepoint': device_add
[    3.360203] bus: 'event_source': add device tracepoint
[    3.361161] PM: Adding info for event_source:tracepoint
[    3.362140] device: 'software': device_add
[    3.362929] bus: 'event_source': add device software
[    3.363884] PM: Adding info for event_source:software
[    3.397781] VFS: Disk quotas dquot_6.5.2
[    3.398992] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    3.400782] msgmni has been set to 467
[    3.402607] device class 'bsg': registering
[    3.403485] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 254)
[    3.404899] io scheduler noop registered (default)
[    3.409414] bus: 'acpi': add driver ac
[    3.410476] bus: 'acpi': add driver button
[    3.411352] bus: 'acpi': driver_probe_device: matched device LNXPWRBN:00=
 with driver button
[    3.412911] bus: 'acpi': really_probe: probing driver button with device=
 LNXPWRBN:00
[    3.416407] device: 'input0': device_add
[    3.417499] PM: Adding info for No Bus:input0
[    3.418449] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    3.419942] ACPI: Power Button [PWRF]
[    3.420766] driver: 'LNXPWRBN:00': driver_bound: bound to device 'button'
[    3.421925] bus: 'acpi': really_probe: bound device LNXPWRBN:00 to drive=
r button
[    3.423635] bus: 'acpi': add driver fan
[    3.424544] bus: 'acpi': add driver processor
[    3.425418] bus: 'acpi': driver_probe_device: matched device LNXCPU:00 w=
ith driver processor
[    3.426943] bus: 'acpi': really_probe: probing driver processor with dev=
ice LNXCPU:00
[    3.430364] device: 'cooling_device0': device_add
[    3.431384] PM: Adding info for No Bus:cooling_device0
[    3.432450] driver: 'LNXCPU:00': driver_bound: bound to device 'processo=
r'
[    3.433582] bus: 'acpi': really_probe: bound device LNXCPU:00 to driver =
processor
[    3.435006] bus: 'acpi': driver_probe_device: matched device LNXCPU:01 w=
ith driver processor
[    3.436540] bus: 'acpi': really_probe: probing driver processor with dev=
ice LNXCPU:01
[    3.439609] driver: 'LNXCPU:01': driver_bound: bound to device 'processo=
r'
[    3.440835] bus: 'acpi': really_probe: bound device LNXCPU:01 to driver =
processor
[    3.442317] bus: 'acpi': add driver thermal
[    3.443383] bus: 'acpi': add driver battery
[    3.444388] device: 'pnp1': device_add
[    3.445197] PM: Adding info for No Bus:pnp1
[    3.445995] isapnp: Scanning for PnP cards...
[    3.808296] isapnp: No Plug & Play device found
[    3.809227] device: 'ptyp0': device_add
[    3.810165] PM: Adding info for No Bus:ptyp0
[    3.811026] device: 'ptyp1': device_add
[    3.811904] PM: Adding info for No Bus:ptyp1
[    3.812767] device: 'ptyp2': device_add
[    3.813626] PM: Adding info for No Bus:ptyp2
[    3.814479] device: 'ptyp3': device_add
[    3.815366] PM: Adding info for No Bus:ptyp3
[    3.816257] device: 'ptyp4': device_add
[    3.817118] PM: Adding info for No Bus:ptyp4
[    3.817964] device: 'ptyp5': device_add
[    3.818842] PM: Adding info for No Bus:ptyp5
[    3.819694] device: 'ptyp6': device_add
[    3.820742] PM: Adding info for No Bus:ptyp6
[    3.821599] device: 'ptyp7': device_add
[    3.822492] PM: Adding info for No Bus:ptyp7
[    3.823371] device: 'ptyp8': device_add
[    3.824236] PM: Adding info for No Bus:ptyp8
[    3.825070] device: 'ptyp9': device_add
[    3.825968] PM: Adding info for No Bus:ptyp9
[    3.826822] device: 'ptypa': device_add
[    3.827698] PM: Adding info for No Bus:ptypa
[    3.828551] device: 'ptypb': device_add
[    3.829429] PM: Adding info for No Bus:ptypb
[    3.830490] device: 'ptypc': device_add
[    3.831424] PM: Adding info for No Bus:ptypc
[    3.832438] device: 'ptypd': device_add
[    3.833503] PM: Adding info for No Bus:ptypd
[    3.835127] device: 'ptype': device_add
[    3.836623] PM: Adding info for No Bus:ptype
[    3.838172] device: 'ptypf': device_add
[    3.839379] PM: Adding info for No Bus:ptypf
[    3.840462] device: 'ptyq0': device_add
[    3.842076] PM: Adding info for No Bus:ptyq0
[    3.843680] device: 'ptyq1': device_add
[    3.845320] PM: Adding info for No Bus:ptyq1
[    3.846821] device: 'ptyq2': device_add
[    3.848388] PM: Adding info for No Bus:ptyq2
[    3.849930] device: 'ptyq3': device_add
[    3.851476] PM: Adding info for No Bus:ptyq3
[    3.852818] device: 'ptyq4': device_add
[    3.854379] PM: Adding info for No Bus:ptyq4
[    3.855870] device: 'ptyq5': device_add
[    3.857303] PM: Adding info for No Bus:ptyq5
[    3.858838] device: 'ptyq6': device_add
[    3.860498] PM: Adding info for No Bus:ptyq6
[    3.862105] device: 'ptyq7': device_add
[    3.863721] PM: Adding info for No Bus:ptyq7
[    3.865226] device: 'ptyq8': device_add
[    3.866778] PM: Adding info for No Bus:ptyq8
[    3.868270] device: 'ptyq9': device_add
[    3.869740] PM: Adding info for No Bus:ptyq9
[    3.871367] device: 'ptyqa': device_add
[    3.872935] PM: Adding info for No Bus:ptyqa
[    3.874250] device: 'ptyqb': device_add
[    3.875408] PM: Adding info for No Bus:ptyqb
[    3.876941] device: 'ptyqc': device_add
[    3.878499] PM: Adding info for No Bus:ptyqc
[    3.880229] device: 'ptyqd': device_add
[    3.881679] PM: Adding info for No Bus:ptyqd
[    3.883258] device: 'ptyqe': device_add
[    3.884821] PM: Adding info for No Bus:ptyqe
[    3.886423] device: 'ptyqf': device_add
[    3.887953] PM: Adding info for No Bus:ptyqf
[    3.889467] device: 'ptyr0': device_add
[    3.891110] PM: Adding info for No Bus:ptyr0
[    3.892700] device: 'ptyr1': device_add
[    3.894286] PM: Adding info for No Bus:ptyr1
[    3.895750] device: 'ptyr2': device_add
[    3.897325] PM: Adding info for No Bus:ptyr2
[    3.898917] device: 'ptyr3': device_add
[    3.900660] PM: Adding info for No Bus:ptyr3
[    3.902110] device: 'ptyr4': device_add
[    3.903663] PM: Adding info for No Bus:ptyr4
[    3.905216] device: 'ptyr5': device_add
[    3.906908] PM: Adding info for No Bus:ptyr5
[    3.908396] device: 'ptyr6': device_add
[    3.909963] PM: Adding info for No Bus:ptyr6
[    3.911532] device: 'ptyr7': device_add
[    3.912919] PM: Adding info for No Bus:ptyr7
[    3.914460] device: 'ptyr8': device_add
[    3.915986] PM: Adding info for No Bus:ptyr8
[    3.917560] device: 'ptyr9': device_add
[    3.919208] PM: Adding info for No Bus:ptyr9
[    3.920780] device: 'ptyra': device_add
[    3.922357] PM: Adding info for No Bus:ptyra
[    3.923553] device: 'ptyrb': device_add
[    3.924443] PM: Adding info for No Bus:ptyrb
[    3.925304] device: 'ptyrc': device_add
[    3.926157] PM: Adding info for No Bus:ptyrc
[    3.926996] device: 'ptyrd': device_add
[    3.927859] PM: Adding info for No Bus:ptyrd
[    3.928700] device: 'ptyre': device_add
[    3.929584] PM: Adding info for No Bus:ptyre
[    3.931264] device: 'ptyrf': device_add
[    3.932603] PM: Adding info for No Bus:ptyrf
[    3.933552] device: 'ptys0': device_add
[    3.934651] PM: Adding info for No Bus:ptys0
[    3.935634] device: 'ptys1': device_add
[    3.936500] PM: Adding info for No Bus:ptys1
[    3.937429] device: 'ptys2': device_add
[    3.938402] PM: Adding info for No Bus:ptys2
[    3.939429] device: 'ptys3': device_add
[    3.940381] PM: Adding info for No Bus:ptys3
[    3.941257] device: 'ptys4': device_add
[    3.942249] PM: Adding info for No Bus:ptys4
[    3.943145] device: 'ptys5': device_add
[    3.944157] PM: Adding info for No Bus:ptys5
[    3.945233] device: 'ptys6': device_add
[    3.946083] PM: Adding info for No Bus:ptys6
[    3.946953] device: 'ptys7': device_add
[    3.947830] PM: Adding info for No Bus:ptys7
[    3.949257] device: 'ptys8': device_add
[    3.950837] PM: Adding info for No Bus:ptys8
[    3.951832] device: 'ptys9': device_add
[    3.952762] PM: Adding info for No Bus:ptys9
[    3.953639] device: 'ptysa': device_add
[    3.954510] PM: Adding info for No Bus:ptysa
[    3.956067] device: 'ptysb': device_add
[    3.957532] PM: Adding info for No Bus:ptysb
[    3.958391] device: 'ptysc': device_add
[    3.959292] PM: Adding info for No Bus:ptysc
[    3.960478] device: 'ptysd': device_add
[    3.962110] PM: Adding info for No Bus:ptysd
[    3.963209] device: 'ptyse': device_add
[    3.964058] PM: Adding info for No Bus:ptyse
[    3.964901] device: 'ptysf': device_add
[    3.966288] PM: Adding info for No Bus:ptysf
[    3.967541] device: 'ptyt0': device_add
[    3.968400] PM: Adding info for No Bus:ptyt0
[    3.969242] device: 'ptyt1': device_add
[    3.970161] PM: Adding info for No Bus:ptyt1
[    3.971003] device: 'ptyt2': device_add
[    3.971879] PM: Adding info for No Bus:ptyt2
[    3.972735] device: 'ptyt3': device_add
[    3.973592] PM: Adding info for No Bus:ptyt3
[    3.974437] device: 'ptyt4': device_add
[    3.975291] PM: Adding info for No Bus:ptyt4
[    3.976144] device: 'ptyt5': device_add
[    3.977711] PM: Adding info for No Bus:ptyt5
[    3.978767] device: 'ptyt6': device_add
[    3.979627] PM: Adding info for No Bus:ptyt6
[    3.980538] device: 'ptyt7': device_add
[    3.981436] PM: Adding info for No Bus:ptyt7
[    3.982286] device: 'ptyt8': device_add
[    3.983152] PM: Adding info for No Bus:ptyt8
[    3.983992] device: 'ptyt9': device_add
[    3.986705] PM: Adding info for No Bus:ptyt9
[    3.987555] device: 'ptyta': device_add
[    3.988442] PM: Adding info for No Bus:ptyta
[    3.989288] device: 'ptytb': device_add
[    3.990265] PM: Adding info for No Bus:ptytb
[    3.991112] device: 'ptytc': device_add
[    3.991958] PM: Adding info for No Bus:ptytc
[    3.992848] device: 'ptytd': device_add
[    3.993711] PM: Adding info for No Bus:ptytd
[    3.994553] device: 'ptyte': device_add
[    3.995416] PM: Adding info for No Bus:ptyte
[    3.996285] device: 'ptytf': device_add
[    3.997148] PM: Adding info for No Bus:ptytf
[    3.997986] device: 'ptyu0': device_add
[    3.998840] PM: Adding info for No Bus:ptyu0
[    3.999707] device: 'ptyu1': device_add
[    4.000661] PM: Adding info for No Bus:ptyu1
[    4.001511] device: 'ptyu2': device_add
[    4.002382] PM: Adding info for No Bus:ptyu2
[    4.003235] device: 'ptyu3': device_add
[    4.004126] PM: Adding info for No Bus:ptyu3
[    4.004967] device: 'ptyu4': device_add
[    4.005820] PM: Adding info for No Bus:ptyu4
[    4.006668] device: 'ptyu5': device_add
[    4.007525] PM: Adding info for No Bus:ptyu5
[    4.008368] device: 'ptyu6': device_add
[    4.009241] PM: Adding info for No Bus:ptyu6
[    4.010162] device: 'ptyu7': device_add
[    4.011032] PM: Adding info for No Bus:ptyu7
[    4.011876] device: 'ptyu8': device_add
[    4.012817] PM: Adding info for No Bus:ptyu8
[    4.013701] device: 'ptyu9': device_add
[    4.014579] PM: Adding info for No Bus:ptyu9
[    4.015418] device: 'ptyua': device_add
[    4.016307] PM: Adding info for No Bus:ptyua
[    4.017169] device: 'ptyub': device_add
[    4.018035] PM: Adding info for No Bus:ptyub
[    4.018881] device: 'ptyuc': device_add
[    4.019738] PM: Adding info for No Bus:ptyuc
[    4.020619] device: 'ptyud': device_add
[    4.021518] PM: Adding info for No Bus:ptyud
[    4.022399] device: 'ptyue': device_add
[    4.023266] PM: Adding info for No Bus:ptyue
[    4.024108] device: 'ptyuf': device_add
[    4.024969] PM: Adding info for No Bus:ptyuf
[    4.025852] device: 'ptyv0': device_add
[    4.026742] PM: Adding info for No Bus:ptyv0
[    4.027600] device: 'ptyv1': device_add
[    4.028459] PM: Adding info for No Bus:ptyv1
[    4.029321] device: 'ptyv2': device_add
[    4.030366] PM: Adding info for No Bus:ptyv2
[    4.031263] device: 'ptyv3': device_add
[    4.032187] PM: Adding info for No Bus:ptyv3
[    4.033029] device: 'ptyv4': device_add
[    4.033921] PM: Adding info for No Bus:ptyv4
[    4.034784] device: 'ptyv5': device_add
[    4.035655] PM: Adding info for No Bus:ptyv5
[    4.036524] device: 'ptyv6': device_add
[    4.037395] PM: Adding info for No Bus:ptyv6
[    4.038251] device: 'ptyv7': device_add
[    4.039113] PM: Adding info for No Bus:ptyv7
[    4.039966] device: 'ptyv8': device_add
[    4.040876] PM: Adding info for No Bus:ptyv8
[    4.041746] device: 'ptyv9': device_add
[    4.042635] PM: Adding info for No Bus:ptyv9
[    4.043493] device: 'ptyva': device_add
[    4.044381] PM: Adding info for No Bus:ptyva
[    4.045242] device: 'ptyvb': device_add
[    4.046119] PM: Adding info for No Bus:ptyvb
[    4.046956] device: 'ptyvc': device_add
[    4.047824] PM: Adding info for No Bus:ptyvc
[    4.048687] device: 'ptyvd': device_add
[    4.049584] PM: Adding info for No Bus:ptyvd
[    4.050530] device: 'ptyve': device_add
[    4.051406] PM: Adding info for No Bus:ptyve
[    4.052283] device: 'ptyvf': device_add
[    4.053177] PM: Adding info for No Bus:ptyvf
[    4.054018] device: 'ptyw0': device_add
[    4.054888] PM: Adding info for No Bus:ptyw0
[    4.055748] device: 'ptyw1': device_add
[    4.056617] PM: Adding info for No Bus:ptyw1
[    4.057478] device: 'ptyw2': device_add
[    4.058346] PM: Adding info for No Bus:ptyw2
[    4.059200] device: 'ptyw3': device_add
[    4.060117] PM: Adding info for No Bus:ptyw3
[    4.060960] device: 'ptyw4': device_add
[    4.061837] PM: Adding info for No Bus:ptyw4
[    4.062703] device: 'ptyw5': device_add
[    4.063577] PM: Adding info for No Bus:ptyw5
[    4.064437] device: 'ptyw6': device_add
[    4.065332] PM: Adding info for No Bus:ptyw6
[    4.066195] device: 'ptyw7': device_add
[    4.067176] PM: Adding info for No Bus:ptyw7
[    4.068025] device: 'ptyw8': device_add
[    4.068937] PM: Adding info for No Bus:ptyw8
[    4.069810] device: 'ptyw9': device_add
[    4.070741] PM: Adding info for No Bus:ptyw9
[    4.071592] device: 'ptywa': device_add
[    4.072473] PM: Adding info for No Bus:ptywa
[    4.073348] device: 'ptywb': device_add
[    4.074215] PM: Adding info for No Bus:ptywb
[    4.075051] device: 'ptywc': device_add
[    4.075906] PM: Adding info for No Bus:ptywc
[    4.076762] device: 'ptywd': device_add
[    4.077651] PM: Adding info for No Bus:ptywd
[    4.078504] device: 'ptywe': device_add
[    4.079363] PM: Adding info for No Bus:ptywe
[    4.080297] device: 'ptywf': device_add
[    4.081177] PM: Adding info for No Bus:ptywf
[    4.082017] device: 'ptyx0': device_add
[    4.082900] PM: Adding info for No Bus:ptyx0
[    4.083761] device: 'ptyx1': device_add
[    4.084642] PM: Adding info for No Bus:ptyx1
[    4.085506] device: 'ptyx2': device_add
[    4.086375] PM: Adding info for No Bus:ptyx2
[    4.087235] device: 'ptyx3': device_add
[    4.088124] PM: Adding info for No Bus:ptyx3
[    4.088966] device: 'ptyx4': device_add
[    4.089828] PM: Adding info for No Bus:ptyx4
[    4.090703] device: 'ptyx5': device_add
[    4.091599] PM: Adding info for No Bus:ptyx5
[    4.092460] device: 'ptyx6': device_add
[    4.093369] PM: Adding info for No Bus:ptyx6
[    4.094215] device: 'ptyx7': device_add
[    4.095078] PM: Adding info for No Bus:ptyx7
[    4.095950] device: 'ptyx8': device_add
[    4.096821] PM: Adding info for No Bus:ptyx8
[    4.097683] device: 'ptyx9': device_add
[    4.098804] PM: Adding info for No Bus:ptyx9
[    4.100292] device: 'ptyxa': device_add
[    4.101844] PM: Adding info for No Bus:ptyxa
[    4.103419] device: 'ptyxb': device_add
[    4.104704] PM: Adding info for No Bus:ptyxb
[    4.105798] device: 'ptyxc': device_add
[    4.107426] PM: Adding info for No Bus:ptyxc
[    4.108959] device: 'ptyxd': device_add
[    4.110688] PM: Adding info for No Bus:ptyxd
[    4.112151] device: 'ptyxe': device_add
[    4.113542] PM: Adding info for No Bus:ptyxe
[    4.115047] device: 'ptyxf': device_add
[    4.116649] PM: Adding info for No Bus:ptyxf
[    4.118026] device: 'ptyy0': device_add
[    4.119129] PM: Adding info for No Bus:ptyy0
[    4.120758] device: 'ptyy1': device_add
[    4.122343] PM: Adding info for No Bus:ptyy1
[    4.123930] device: 'ptyy2': device_add
[    4.125408] PM: Adding info for No Bus:ptyy2
[    4.126711] device: 'ptyy3': device_add
[    4.128289] PM: Adding info for No Bus:ptyy3
[    4.129823] device: 'ptyy4': device_add
[    4.131324] PM: Adding info for No Bus:ptyy4
[    4.132454] device: 'ptyy5': device_add
[    4.133811] PM: Adding info for No Bus:ptyy5
[    4.135326] device: 'ptyy6': device_add
[    4.136884] PM: Adding info for No Bus:ptyy6
[    4.138518] device: 'ptyy7': device_add
[    4.139873] PM: Adding info for No Bus:ptyy7
[    4.141416] device: 'ptyy8': device_add
[    4.143026] PM: Adding info for No Bus:ptyy8
[    4.144456] device: 'ptyy9': device_add
[    4.145733] PM: Adding info for No Bus:ptyy9
[    4.146837] device: 'ptyya': device_add
[    4.148401] PM: Adding info for No Bus:ptyya
[    4.149932] device: 'ptyyb': device_add
[    4.151640] PM: Adding info for No Bus:ptyyb
[    4.153048] device: 'ptyyc': device_add
[    4.154489] PM: Adding info for No Bus:ptyyc
[    4.155978] device: 'ptyyd': device_add
[    4.157544] PM: Adding info for No Bus:ptyyd
[    4.159186] device: 'ptyye': device_add
[    4.160627] PM: Adding info for No Bus:ptyye
[    4.162101] device: 'ptyyf': device_add
[    4.163661] PM: Adding info for No Bus:ptyyf
[    4.165127] device: 'ptyz0': device_add
[    4.166384] PM: Adding info for No Bus:ptyz0
[    4.167391] device: 'ptyz1': device_add
[    4.168953] PM: Adding info for No Bus:ptyz1
[    4.170595] device: 'ptyz2': device_add
[    4.171962] PM: Adding info for No Bus:ptyz2
[    4.173063] device: 'ptyz3': device_add
[    4.178183] PM: Adding info for No Bus:ptyz3
[    4.179774] device: 'ptyz4': device_add
[    4.181191] PM: Adding info for No Bus:ptyz4
[    4.182731] device: 'ptyz5': device_add
[    4.184302] PM: Adding info for No Bus:ptyz5
[    4.185753] device: 'ptyz6': device_add
[    4.187436] PM: Adding info for No Bus:ptyz6
[    4.188577] device: 'ptyz7': device_add
[    4.190148] PM: Adding info for No Bus:ptyz7
[    4.191696] device: 'ptyz8': device_add
[    4.193285] PM: Adding info for No Bus:ptyz8
[    4.194860] device: 'ptyz9': device_add
[    4.195964] PM: Adding info for No Bus:ptyz9
[    4.196846] device: 'ptyza': device_add
[    4.197773] PM: Adding info for No Bus:ptyza
[    4.199422] device: 'ptyzb': device_add
[    4.200457] PM: Adding info for No Bus:ptyzb
[    4.201307] device: 'ptyzc': device_add
[    4.202231] PM: Adding info for No Bus:ptyzc
[    4.203379] device: 'ptyzd': device_add
[    4.204262] PM: Adding info for No Bus:ptyzd
[    4.205214] device: 'ptyze': device_add
[    4.206146] PM: Adding info for No Bus:ptyze
[    4.207263] device: 'ptyzf': device_add
[    4.208158] PM: Adding info for No Bus:ptyzf
[    4.208996] device: 'ptya0': device_add
[    4.209923] PM: Adding info for No Bus:ptya0
[    4.211076] device: 'ptya1': device_add
[    4.211959] PM: Adding info for No Bus:ptya1
[    4.212824] device: 'ptya2': device_add
[    4.214316] PM: Adding info for No Bus:ptya2
[    4.215517] device: 'ptya3': device_add
[    4.216418] PM: Adding info for No Bus:ptya3
[    4.217274] device: 'ptya4': device_add
[    4.218233] PM: Adding info for No Bus:ptya4
[    4.219303] device: 'ptya5': device_add
[    4.220241] PM: Adding info for No Bus:ptya5
[    4.221095] device: 'ptya6': device_add
[    4.222056] PM: Adding info for No Bus:ptya6
[    4.223125] device: 'ptya7': device_add
[    4.223989] PM: Adding info for No Bus:ptya7
[    4.224852] device: 'ptya8': device_add
[    4.225802] PM: Addi
--JP+T4n/bALQSJXh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="83b324c-bisect.log"

git checkout 259d51a40fe48cf12038fb8b5a417d1d21d2732e
Previous HEAD position was 83b324c... add a refcount check in dput()
HEAD is now at 259d51a... video: mmpdisp: add spi port in display controller

2013-02-06-17:16:03 259d51a40fe48cf12038fb8b5a417d1d21d2732e compiling
/home/wfg/linux

2013-02-06-17:17:11 detecting boot state 3.8.0-rc6-bisect-00040-g259d51a #79 	7..........................................................	8 SUCCESS
bisect: good commit 259d51a40fe48cf12038fb8b5a417d1d21d2732e
git bisect start 83b324c5ff5cca85bbeb2ba913d465f108afe472 259d51a40fe48cf12038fb8b5a417d1d21d2732e --
Previous HEAD position was 259d51a... video: mmpdisp: add spi port in display controller
HEAD is now at 1e51120... userns: Convert 9p's uid/gid handling
Bisecting: 249 revisions left to test after this (roughly 8 steps)
[f8df01c1d7833ff2dfb45ccd0017c38c7e803872] memcg: debugging facility to access dangling memcgs
git bisect run /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-02-06-17:48:11 f8df01c1d7833ff2dfb45ccd0017c38c7e803872 compiling
chown: changing group of `/tmp/bisect-bad-kvm_bisect': Operation not permitted
chown: changing group of `/tmp/bisect-build-skip-kvm_bisect': Operation not permitted
chown: changing group of `/tmp/bisect-good-kvm_bisect': Operation not permitted
chown: changing group of `/tmp/bisect-log-kvm_bisect': Operation not permitted
chown: changing group of `/tmp/bisect-skip-kvm_bisect': Operation not permitted
/home/wfg/linux

2013-02-06-17:49:22 detecting boot state 3.8.0-rc6-mm1-bisect-00289-gf8df01c #80 .......................................................	1	10..........................................................	11 SUCCESS
Bisecting: 124 revisions left to test after this (roughly 7 steps)
[4538bd3e5b6543108230b034cccd8011ba968496] Documentation/cgroups/blkio-controller.txt: fix typo
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-02-06-18:47:57 4538bd3e5b6543108230b034cccd8011ba968496 compiling
rm: cannot remove `/tmp/bisect-build-skip-kvm_bisect': Operation not permitted
rm: cannot remove `/tmp/bisect-skip-kvm_bisect': Operation not permitted
rm: cannot remove `/tmp/bisect-good-kvm_bisect': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect': Operation not permitted
/home/wfg/linux

2013-02-06-18:49:08 detecting boot state 3.8.0-rc6-mm1-bisect-00414-g4538bd3 #81 ........................................................	1 TEST FAILURE
Bisecting: 62 revisions left to test after this (roughly 6 steps)
[a612644e542ef0212d668d2ecee308e8d57cd2e4] drivers/video/backlight/ld9040.c: use devm_regulator_bulk_get() API
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-02-06-19:18:11 a612644e542ef0212d668d2ecee308e8d57cd2e4 compiling
rm: cannot remove `/tmp/bisect-build-skip-kvm_bisect': Operation not permitted
rm: cannot remove `/tmp/bisect-skip-kvm_bisect': Operation not permitted
rm: cannot remove `/tmp/bisect-good-kvm_bisect': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect': Operation not permitted
/home/wfg/linux

2013-02-06-19:19:06 detecting boot state 3.8.0-rc6-mm1-bisect-00351-ga612644 #82  TEST FAILURE
Bisecting: 30 revisions left to test after this (roughly 5 steps)
[c48d189f2ef81158f786a84975ad8db05278f6dd] backlight: s6e63m0: remove unnecessary NULL deference check
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-02-06-19:19:37 c48d189f2ef81158f786a84975ad8db05278f6dd compiling
rm: cannot remove `/tmp/bisect-build-skip-kvm_bisect': Operation not permitted
rm: cannot remove `/tmp/bisect-skip-kvm_bisect': Operation not permitted
rm: cannot remove `/tmp/bisect-good-kvm_bisect': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect': Operation not permitted
/home/wfg/linux

2013-02-06-19:20:15 detecting boot state 3.8.0-rc6-mm1-bisect-00320-gc48d189 #83  TEST FAILURE
Bisecting: 15 revisions left to test after this (roughly 4 steps)
[d78fb70a902de2247e9e44fcf7b8e73b96a4a7b3] kernel/smp.c: cleanups
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-02-06-19:20:46 d78fb70a902de2247e9e44fcf7b8e73b96a4a7b3 compiling
rm: cannot remove `/tmp/bisect-build-skip-kvm_bisect': Operation not permitted
rm: cannot remove `/tmp/bisect-skip-kvm_bisect': Operation not permitted
rm: cannot remove `/tmp/bisect-good-kvm_bisect': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect': Operation not permitted
/home/wfg/linux

2013-02-06-19:21:28 detecting boot state 3.8.0-rc6-mm1-bisect-00304-gd78fb70 #84 	3..........................................................	8 SUCCESS
Bisecting: 7 revisions left to test after this (roughly 3 steps)
[10fdc3252f827e3ab9652870773349e099e2f4d6] backlight-add-lms501kf03-lcd-driver-fix-fix
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-02-06-19:52:01 10fdc3252f827e3ab9652870773349e099e2f4d6 compiling
rm: cannot remove `/tmp/bisect-build-skip-kvm_bisect': Operation not permitted
rm: cannot remove `/tmp/bisect-skip-kvm_bisect': Operation not permitted
rm: cannot remove `/tmp/bisect-good-kvm_bisect': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect': Operation not permitted
/home/wfg/linux

2013-02-06-19:53:10 detecting boot state 3.8.0-rc6-mm1-bisect-00312-g10fdc32 #85 ........................................................	5 TEST FAILURE
Bisecting: 3 revisions left to test after this (roughly 2 steps)
[6c35e4b5601ad676682232beed50d558bef11331] get_maintainer.pl: find maintainers for removed files
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-02-06-20:22:13 6c35e4b5601ad676682232beed50d558bef11331 compiling
rm: cannot remove `/tmp/bisect-build-skip-kvm_bisect': Operation not permitted
rm: cannot remove `/tmp/bisect-skip-kvm_bisect': Operation not permitted
rm: cannot remove `/tmp/bisect-good-kvm_bisect': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect': Operation not permitted
/home/wfg/linux

2013-02-06-20:23:01 detecting boot state 3.8.0-rc6-mm1-bisect-00308-g6c35e4b #86  TEST FAILURE
Bisecting: 1 revision left to test after this (roughly 1 step)
[c6a6e37da505d1cd79d8dfa7ac68ef953d2bf6dd] printk: Avoid softlockups in console_unlock()
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-02-06-20:23:32 c6a6e37da505d1cd79d8dfa7ac68ef953d2bf6dd compiling
rm: cannot remove `/tmp/bisect-build-skip-kvm_bisect': Operation not permitted
rm: cannot remove `/tmp/bisect-skip-kvm_bisect': Operation not permitted
rm: cannot remove `/tmp/bisect-good-kvm_bisect': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect': Operation not permitted
/home/wfg/linux

2013-02-06-20:24:12 detecting boot state 3.8.0-rc6-mm1-bisect-00306-gc6a6e37 #87  TEST FAILURE
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[8e798f4e517d1f32fe9794e75802d4e864a916b7] lib/vsprintf.c: add %pa format specifier for phys_addr_t types
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-02-06-20:24:43 8e798f4e517d1f32fe9794e75802d4e864a916b7 compiling
rm: cannot remove `/tmp/bisect-build-skip-kvm_bisect': Operation not permitted
rm: cannot remove `/tmp/bisect-skip-kvm_bisect': Operation not permitted
rm: cannot remove `/tmp/bisect-good-kvm_bisect': Operation not permitted
rm: cannot remove `/tmp/bisect-bad-kvm_bisect': Operation not permitted
/home/wfg/linux

2013-02-06-20:25:27 detecting boot state 3.8.0-rc6-mm1-bisect-00305-g8e798f4 #88 	5..........................................................	7 SUCCESS
/c/kernel-tests/common.sh: line 2784: printf: `p': invalid format character
c6a6e37da505d1cd79d8dfa7ac68ef953d2bf6dd is the first bad commit
commit c6a6e37da505d1cd79d8dfa7ac68ef953d2bf6dd
Author: Jan Kara <jack@suse.cz>
Date:   Wed Feb 6 02:04:42 2013 +0000

    printk: Avoid softlockups in console_unlock()
    
    A CPU can be caught in console_unlock() for a long time (tens of seconds
    are reported by our customers) when other CPUs are using printk heavily
    and serial console makes printing slow.  Despite serial console drivers
    are calling touch_nmi_watchdog() this triggers softlockup warnings because
    interrupts are disabled for the whole time console_unlock() runs (e.g.
    vprintk() calls console_unlock() with interrupts disabled).  Thus IPIs
    cannot be processed and other CPUs get stuck spinning in calls like
    smp_call_function_many().  Also RCU eventually starts reporting lockups.
    
    In my artificial testing I also managed to trigger a situation when disk
    disappeared from the system apparently because commands to / from it could
    not be delivered for long enough.  This is why just silencing watchdogs
    isn't a reliable solution to the problem and we simply have to avoid
    spending too long in console_unlock().
    
    We fix the issue by limiting the time we spend in console_unlock() to
    watchdog_thresh() / 4 (unless we are in an early boot stage or oops is
    happening).  The rest of the buffer will be printed either by further
    callers to printk() or by a queued work.
    
    Signed-off-by: Jan Kara <jack@suse.cz>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Steven Rostedt <rostedt@goodmis.org>
    Cc: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

:040000 040000 5690af7205389aa554d8ff37c392d3714223d706 7cbc219bc23af72e87baa4dcc766a62d79f6e1ee M	include
:040000 040000 cb55853596127ceeda90b184626e80bb4674a245 fa0ec34e2de821679f51aa97d3cb5a43bb285b28 M	kernel
bisect run success

2013-02-06-20:56:00 8e798f4e517d1f32fe9794e75802d4e864a916b7 compiling
/home/wfg/linux

2013-02-06-20:56:21 detecting boot state 3.8.0-rc6-mm1-bisect-00305-g8e798f4 #88 ..........................................................	6	10..........................................................	15	20..........................................................	24 SUCCESS

========= linux-next =========

2013-02-06-22:26:38 1587f71ebbf5aedf754062baa11fcc9e9b49ecf0 compiling
/home/wfg/linux

2013-02-06-22:28:11 detecting boot state 3.8.0-rc4-bisect-next-20130125 #89 .......................................................	5	10..........................................................	12	20...........................................................	30...........................................................	37 SUCCESS

--JP+T4n/bALQSJXh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.8.0-rc6-mm1 Kernel Configuration
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
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
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
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
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
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
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
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set

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
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
# CONFIG_MEMCG_KMEM is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
CONFIG_SCHED_AUTOGROUP=y
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EXPERT is not set
CONFIG_HAVE_UID16=y
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
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
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
# CONFIG_JUMP_LABEL is not set
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
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
# CONFIG_MODULE_SIG is not set
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y

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
CONFIG_IOSCHED_DEADLINE=m
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_WANT_INTEL_MID is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_RDC321X=y
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
# CONFIG_KVMTOOL_TEST_ENABLE is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_LGUEST_GUEST is not set
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
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
CONFIG_X86_PPRO_FENCE=y
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
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
# CONFIG_X86_UP_APIC is not set
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=m
CONFIG_I8K=m
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=m
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
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
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
CONFIG_HIGHPTE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
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
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_I2C=m
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
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
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=m
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=m
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K6=m
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=m
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
# CONFIG_X86_SPEEDSTEP_ICH is not set
CONFIG_X86_SPEEDSTEP_SMI=m
CONFIG_X86_P4_CLOCKMOD=m
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
CONFIG_X86_LONGRUN=m
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
# CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set
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
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
CONFIG_SCx200=m
# CONFIG_SCx200HR_TIMER is not set
# CONFIG_OLPC is not set
CONFIG_ALIX=y
CONFIG_NET5501=y
# CONFIG_GEOS is not set
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=m
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=m
CONFIG_LLC2=m
# CONFIG_IPX is not set
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
# CONFIG_LTPC is not set
# CONFIG_COPS is not set
# CONFIG_IPDDP is not set
CONFIG_X25=m
CONFIG_LAPB=m
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_BATMAN_ADV=m
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=m
CONFIG_NETPRIO_CGROUP=m
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
# CONFIG_CAN_GW is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
CONFIG_CAN_SLCAN=m
# CONFIG_CAN_DEV is not set
CONFIG_CAN_DEBUG_DEVICES=y
# CONFIG_IRDA is not set
CONFIG_BT=m
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=m
# CONFIG_BT_BNEP_MC_FILTER is not set
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIVHCI=m
# CONFIG_BT_MRVL is not set
CONFIG_BT_WILINK=m
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
# CONFIG_CFG80211_DEFAULT_PS is not set
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
CONFIG_MAC80211_DEBUG_MENU=y
CONFIG_MAC80211_NOINLINE=y
# CONFIG_MAC80211_VERBOSE_DEBUG is not set
# CONFIG_MAC80211_MLME_DEBUG is not set
CONFIG_MAC80211_STA_DEBUG=y
CONFIG_MAC80211_HT_DEBUG=y
CONFIG_MAC80211_IBSS_DEBUG=y
CONFIG_MAC80211_PS_DEBUG=y
CONFIG_MAC80211_MPL_DEBUG=y
# CONFIG_MAC80211_MPATH_DEBUG is not set
CONFIG_MAC80211_MHWMP_DEBUG=y
CONFIG_MAC80211_MESH_SYNC_DEBUG=y
# CONFIG_MAC80211_TDLS_DEBUG is not set
# CONFIG_MAC80211_DEBUG_COUNTERS is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_REGULATOR=m
CONFIG_NET_9P=m
CONFIG_NET_9P_VIRTIO=m
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
CONFIG_DEBUG_DRIVER=y
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPI=m
CONFIG_REGMAP_MMIO=m
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_CMA is not set

#
# Bus devices
#
CONFIG_CONNECTOR=m
CONFIG_MTD=m
CONFIG_MTD_TESTS=m
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
# CONFIG_MTD_CMDLINE_PARTS is not set
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
# CONFIG_MTD_CHAR is not set
CONFIG_HAVE_MTD_OTP=y
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
CONFIG_MTD_BLOCK_RO=m
# CONFIG_FTL is not set
CONFIG_NFTL=m
CONFIG_NFTL_RW=y
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
CONFIG_SSFDC=m
# CONFIG_SM_FTL is not set
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
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
CONFIG_MTD_CFI_INTELEXT=m
# CONFIG_MTD_CFI_AMDSTD is not set
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_PHYSMAP is not set
CONFIG_MTD_SC520CDP=m
CONFIG_MTD_NETSC520=m
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_SCx200_DOCFLASH is not set
CONFIG_MTD_AMD76XROM=m
CONFIG_MTD_ICHXROM=m
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=m
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=m

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=m
# CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
# CONFIG_MTD_DATAFLASH_OTP is not set
# CONFIG_MTD_M25P80 is not set
# CONFIG_MTD_SST25L is not set
# CONFIG_MTD_SLRAM is not set
CONFIG_MTD_PHRAM=m
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOC2000=m
# CONFIG_MTD_DOC2001 is not set
# CONFIG_MTD_DOC2001PLUS is not set
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_DOCPROBE=m
CONFIG_MTD_DOCECC=m
# CONFIG_MTD_DOCPROBE_ADVANCED is not set
CONFIG_MTD_DOCPROBE_ADDRESS=0x0
CONFIG_MTD_NAND_ECC=m
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=m
# CONFIG_MTD_NAND_ECC_BCH is not set
# CONFIG_MTD_SM_COMMON is not set
# CONFIG_MTD_NAND_MUSEUM_IDS is not set
# CONFIG_MTD_NAND_DENALI is not set
CONFIG_MTD_NAND_IDS=m
# CONFIG_MTD_NAND_RICOH is not set
# CONFIG_MTD_NAND_DISKONCHIP is not set
CONFIG_MTD_NAND_DOCG4=m
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_CS553X=m
CONFIG_MTD_NAND_NANDSIM=m
# CONFIG_MTD_NAND_PLATFORM is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
# CONFIG_MTD_UBI is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_ISAPNP=y
CONFIG_PNPBIOS=y
# CONFIG_PNPBIOS_PROC_FS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
CONFIG_BLK_DEV_XD=m
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=m
# CONFIG_BLK_DEV_HD is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=m
# CONFIG_AD525X_DPOT_I2C is not set
# CONFIG_AD525X_DPOT_SPI is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=m
# CONFIG_ATMEL_SSC is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=m
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1780=m
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=m
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
# CONFIG_BMP085_I2C is not set
CONFIG_BMP085_SPI=m
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_LATTICE_ECP3_CONFIG is not set
CONFIG_C2PORT=m
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
CONFIG_EEPROM_93XX46=m
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=m
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_IDE_LEGACY=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=m
# CONFIG_IDE_GD_ATA is not set
CONFIG_IDE_GD_ATAPI=y
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
CONFIG_BLK_DEV_PLATFORM=m
# CONFIG_BLK_DEV_CMD640 is not set
CONFIG_BLK_DEV_IDEPNP=m

#
# PCI IDE chipsets support
#
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_CS5536 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
# CONFIG_BLK_DEV_4DRIVES is not set
CONFIG_BLK_DEV_ALI14XX=m
# CONFIG_BLK_DEV_DTC2278 is not set
CONFIG_BLK_DEV_HT6560B=m
CONFIG_BLK_DEV_QD65XX=m
CONFIG_BLK_DEV_UMC8672=m
# CONFIG_BLK_DEV_IDEDMA is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=m
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
# CONFIG_SCSI_SAS_ATA is not set
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=m
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
# CONFIG_BLK_DEV_DM is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
# CONFIG_NETDEVICES is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ADP5589=m
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_GPIO=m
CONFIG_KEYBOARD_GPIO_POLLED=m
CONFIG_KEYBOARD_TCA6416=m
CONFIG_KEYBOARD_TCA8418=m
# CONFIG_KEYBOARD_MATRIX is not set
CONFIG_KEYBOARD_LM8323=m
# CONFIG_KEYBOARD_LM8333 is not set
CONFIG_KEYBOARD_MAX7359=m
CONFIG_KEYBOARD_MCS=m
# CONFIG_KEYBOARD_MPR121 is not set
CONFIG_KEYBOARD_NEWTON=m
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_STMPE is not set
CONFIG_KEYBOARD_XTKBD=m
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
CONFIG_MOUSE_INPORT=m
CONFIG_MOUSE_ATIXL=y
# CONFIG_MOUSE_LOGIBM is not set
# CONFIG_MOUSE_PC110PAD is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=m
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
CONFIG_JOYSTICK_GUILLEMOT=m
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=m
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=m
# CONFIG_JOYSTICK_SPACEBALL is not set
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_AS5011 is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_ARIZONA_HAPTICS is not set
CONFIG_INPUT_BMA150=m
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_MC13783_PWRBUTTON is not set
# CONFIG_INPUT_MMA8450 is not set
CONFIG_INPUT_MPU3050=m
# CONFIG_INPUT_APANEL is not set
CONFIG_INPUT_GP2A=m
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=m
# CONFIG_INPUT_KXTJ9_POLLED_MODE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_PCF50633_PMU is not set
CONFIG_INPUT_PCF8574=m
CONFIG_INPUT_PWM_BEEPER=m
CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
# CONFIG_INPUT_PCAP is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=m
CONFIG_GAMEPORT=m
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=m
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
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=m
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
CONFIG_MOXA_SMARTIO=m
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
# CONFIG_N_HDLC is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y
CONFIG_STALDRV=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=m
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_IFX6X60=m
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_GEODE=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=m
# CONFIG_HW_RANDOM_TPM is not set
CONFIG_NVRAM=m
# CONFIG_RTC is not set
# CONFIG_GEN_RTC is not set
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=m
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=m
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
CONFIG_TCG_INFINEON=m
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_PCA9541 is not set
CONFIG_I2C_MUX_PCA954x=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCA=m

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
CONFIG_I2C_CBUS_GPIO=m
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=m

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_ELEKTOR is not set
CONFIG_I2C_PCA_ISA=m
CONFIG_SCx200_I2C=m
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
CONFIG_I2C_DEBUG_ALGO=y
CONFIG_I2C_DEBUG_BUS=y
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=m
CONFIG_SPI_GPIO=m
CONFIG_SPI_OC_TINY=m
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=m
# CONFIG_SPI_TOPCLIFF_PCH is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
CONFIG_SPI_DESIGNWARE=m
# CONFIG_SPI_DW_PCI is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=m
# CONFIG_HSI is not set

#
# PPS support
#
# CONFIG_PPS is not set

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
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=m
CONFIG_GPIO_TS5500=m
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=m
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=m
# CONFIG_GPIO_STMPE is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=m
# CONFIG_GPIO_MCP23S08 is not set
CONFIG_GPIO_MC33880=m
CONFIG_GPIO_74X164=m

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#

#
# USB GPIO expanders:
#
CONFIG_W1=m
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=m
# CONFIG_W1_MASTER_DS1WM is not set
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=m
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2423=m
CONFIG_W1_SLAVE_DS2431=m
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=m
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2780=m
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=m
CONFIG_BATTERY_BQ27x00=m
# CONFIG_BATTERY_BQ27X00_I2C is not set
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
CONFIG_BATTERY_MAX17040=m
CONFIG_BATTERY_MAX17042=m
CONFIG_CHARGER_PCF50633=m
CONFIG_CHARGER_ISP1704=m
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_SMB347=m
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
CONFIG_SENSORS_AD7314=m
CONFIG_SENSORS_AD7414=m
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADCXX=m
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=m
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=m
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
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
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=m
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=m
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_GPIO_FAN=m
CONFIG_SENSORS_HIH6130=m
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=m
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4151=m
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95241=m
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_MAX1111=m
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
# CONFIG_SENSORS_ADM1275 is not set
CONFIG_SENSORS_LM25066=m
# CONFIG_SENSORS_LTC2978 is not set
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX34440 is not set
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_UCD9000 is not set
# CONFIG_SENSORS_UCD9200 is not set
CONFIG_SENSORS_ZL6100=m
CONFIG_SENSORS_SHT15=m
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=m
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=m
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=m
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=m
CONFIG_SENSORS_TMP401=m
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=m
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=m
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=m
CONFIG_SENSORS_W83795_FANCTRL=y
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_APPLESMC=m
# CONFIG_SENSORS_MC13783_ADC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_FAIR_SHARE is not set
CONFIG_STEP_WISE=y
# CONFIG_USER_SPACE is not set
# CONFIG_CPU_THERMAL is not set
# CONFIG_INTEL_POWERCLAMP is not set
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
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_MFD_LM3533=m
CONFIG_TPS6105X=m
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65217=m
# CONFIG_MFD_TPS65912_SPI is not set
CONFIG_MFD_STMPE=y

#
# STMPE Interface Drivers
#
CONFIG_STMPE_SPI=y
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM5102 is not set
# CONFIG_MFD_WM5110 is not set
# CONFIG_MFD_WM831X_SPI is not set
CONFIG_MFD_PCF50633=m
CONFIG_PCF50633_ADC=m
# CONFIG_PCF50633_GPIO is not set
CONFIG_MFD_MC13783=m
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_SPI=m
CONFIG_MFD_MC13XXX_I2C=m
# CONFIG_ABX500_CORE is not set
CONFIG_EZX_PCAP=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_LPC_SCH is not set
# CONFIG_LPC_ICH is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_WL1273_CORE=m
# CONFIG_MFD_RETU is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=m
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_AD5398=m
# CONFIG_REGULATOR_ARIZONA is not set
CONFIG_REGULATOR_FAN53555=m
CONFIG_REGULATOR_MC13XXX_CORE=m
CONFIG_REGULATOR_MC13783=m
CONFIG_REGULATOR_MC13892=m
# CONFIG_REGULATOR_ISL6271A is not set
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=m
# CONFIG_REGULATOR_MAX8660 is not set
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8973=m
# CONFIG_REGULATOR_PCAP is not set
CONFIG_REGULATOR_LP3971=m
CONFIG_REGULATOR_LP3972=m
# CONFIG_REGULATOR_LP8755 is not set
CONFIG_REGULATOR_PCF50633=m
CONFIG_REGULATOR_TPS51632=m
# CONFIG_REGULATOR_TPS6105X is not set
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=m
CONFIG_REGULATOR_TPS65217=m
# CONFIG_REGULATOR_TPS6524X is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF2_CORE=m
# CONFIG_VIDEO_V4L2_INT_DEVICE is not set
CONFIG_DVB_CORE=m
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y

#
# Media drivers
#
# CONFIG_MEDIA_PCI_SUPPORT is not set
CONFIG_V4L_PLATFORM_DRIVERS=y
# CONFIG_VIDEO_CAFE_CCIC is not set
CONFIG_SOC_CAMERA=m
# CONFIG_SOC_CAMERA_PLATFORM is not set
CONFIG_V4L_MEM2MEM_DRIVERS=y
# CONFIG_VIDEO_SH_VEU is not set
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_MEDIA_PARPORT_SUPPORT=y
CONFIG_VIDEO_PMS=m

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
# CONFIG_VIDEO_TDA7432 is not set
CONFIG_VIDEO_TDA9840=m
# CONFIG_VIDEO_TEA6415C is not set
# CONFIG_VIDEO_TEA6420 is not set
# CONFIG_VIDEO_MSP3400 is not set
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
# CONFIG_VIDEO_TLV320AIC23B is not set
# CONFIG_VIDEO_WM8775 is not set
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=m

#
# Video decoders
#
# CONFIG_VIDEO_ADV7180 is not set
# CONFIG_VIDEO_ADV7183 is not set
CONFIG_VIDEO_BT819=m
CONFIG_VIDEO_BT856=m
# CONFIG_VIDEO_BT866 is not set
CONFIG_VIDEO_KS0127=m
CONFIG_VIDEO_SAA7110=m
# CONFIG_VIDEO_SAA711X is not set
# CONFIG_VIDEO_SAA7191 is not set
# CONFIG_VIDEO_TVP514X is not set
CONFIG_VIDEO_TVP5150=m
# CONFIG_VIDEO_TVP7002 is not set
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_CX25840=m

#
# MPEG video encoders
#
CONFIG_VIDEO_CX2341X=m

#
# Video encoders
#
# CONFIG_VIDEO_SAA7127 is not set
CONFIG_VIDEO_SAA7185=m
# CONFIG_VIDEO_ADV7170 is not set
CONFIG_VIDEO_ADV7175=m
# CONFIG_VIDEO_ADV7343 is not set
CONFIG_VIDEO_ADV7393=m
# CONFIG_VIDEO_AK881X is not set

#
# Camera sensor devices
#
CONFIG_VIDEO_OV7670=m
CONFIG_VIDEO_VS6624=m
CONFIG_VIDEO_MT9V011=m
CONFIG_VIDEO_SR030PC30=m

#
# Flash devices
#

#
# Video improvement chips
#
# CONFIG_VIDEO_UPD64031A is not set
CONFIG_VIDEO_UPD64083=m

#
# Miscelaneous helper chips
#
CONFIG_VIDEO_THS7303=m
CONFIG_VIDEO_M52790=m

#
# Sensors used on soc_camera driver
#

#
# soc_camera sensor drivers
#
# CONFIG_SOC_CAMERA_IMX074 is not set
# CONFIG_SOC_CAMERA_MT9M001 is not set
CONFIG_SOC_CAMERA_MT9M111=m
# CONFIG_SOC_CAMERA_MT9T031 is not set
CONFIG_SOC_CAMERA_MT9T112=m
CONFIG_SOC_CAMERA_MT9V022=m
# CONFIG_SOC_CAMERA_OV2640 is not set
# CONFIG_SOC_CAMERA_OV5642 is not set
CONFIG_SOC_CAMERA_OV6650=m
CONFIG_SOC_CAMERA_OV772X=m
CONFIG_SOC_CAMERA_OV9640=m
CONFIG_SOC_CAMERA_OV9740=m
CONFIG_SOC_CAMERA_RJ54N1=m
# CONFIG_SOC_CAMERA_TW9910 is not set
CONFIG_MEDIA_ATTACH=y

#
# Customize TV tuners
#
# CONFIG_MEDIA_TUNER_SIMPLE is not set
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
# CONFIG_MEDIA_TUNER_TEA5767 is not set
# CONFIG_MEDIA_TUNER_MT20XX is not set
CONFIG_MEDIA_TUNER_MT2060=m
# CONFIG_MEDIA_TUNER_MT2063 is not set
# CONFIG_MEDIA_TUNER_MT2266 is not set
# CONFIG_MEDIA_TUNER_MT2131 is not set
# CONFIG_MEDIA_TUNER_QT1010 is not set
# CONFIG_MEDIA_TUNER_XC2028 is not set
# CONFIG_MEDIA_TUNER_XC5000 is not set
# CONFIG_MEDIA_TUNER_XC4000 is not set
# CONFIG_MEDIA_TUNER_MXL5005S is not set
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
# CONFIG_MEDIA_TUNER_MAX2165 is not set
# CONFIG_MEDIA_TUNER_TDA18218 is not set
CONFIG_MEDIA_TUNER_FC0011=m
# CONFIG_MEDIA_TUNER_FC0012 is not set
# CONFIG_MEDIA_TUNER_FC0013 is not set
# CONFIG_MEDIA_TUNER_TDA18212 is not set
CONFIG_MEDIA_TUNER_E4000=m
# CONFIG_MEDIA_TUNER_FC2580 is not set
CONFIG_MEDIA_TUNER_TUA9001=m

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
# CONFIG_DVB_STB0899 is not set
CONFIG_DVB_STB6100=m
# CONFIG_DVB_STV090x is not set
# CONFIG_DVB_STV6110x is not set

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=m
# CONFIG_DVB_TDA18271C2DD is not set

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
# CONFIG_DVB_CX24123 is not set
CONFIG_DVB_MT312=m
# CONFIG_DVB_ZL10036 is not set
# CONFIG_DVB_ZL10039 is not set
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_STV6110=m
# CONFIG_DVB_STV0900 is not set
CONFIG_DVB_TDA8083=m
# CONFIG_DVB_TDA10086 is not set
# CONFIG_DVB_TDA8261 is not set
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
# CONFIG_DVB_TUNER_CX24113 is not set
# CONFIG_DVB_TDA826X is not set
# CONFIG_DVB_TUA6100 is not set
# CONFIG_DVB_CX24116 is not set
CONFIG_DVB_SI21XX=m
# CONFIG_DVB_TS2020 is not set
CONFIG_DVB_DS3000=m
CONFIG_DVB_MB86A16=m
# CONFIG_DVB_TDA10071 is not set

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
# CONFIG_DVB_S5H1432 is not set
CONFIG_DVB_DRXD=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
# CONFIG_DVB_NXT6000 is not set
# CONFIG_DVB_MT352 is not set
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
# CONFIG_DVB_DIB3000MC is not set
# CONFIG_DVB_DIB7000M is not set
CONFIG_DVB_DIB7000P=m
# CONFIG_DVB_DIB9000 is not set
CONFIG_DVB_TDA10048=m
# CONFIG_DVB_AF9013 is not set
CONFIG_DVB_EC100=m
CONFIG_DVB_HD29L2=m
CONFIG_DVB_STV0367=m
# CONFIG_DVB_CXD2820R is not set
CONFIG_DVB_RTL2830=m
# CONFIG_DVB_RTL2832 is not set

#
# DVB-C (cable) frontends
#
# CONFIG_DVB_VES1820 is not set
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
# CONFIG_DVB_STV0297 is not set

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
# CONFIG_DVB_LGDT330X is not set
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_LG2160=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_DTV=m
# CONFIG_DVB_AU8522_V4L is not set
CONFIG_DVB_S5H1411=m

#
# ISDB-T (terrestrial) frontends
#
# CONFIG_DVB_S921 is not set
CONFIG_DVB_DIB8000=m
# CONFIG_DVB_MB86A20S is not set

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
# CONFIG_DVB_TUNER_DIB0070 is not set
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
# CONFIG_DVB_LGS8GL5 is not set
CONFIG_DVB_LGS8GXX=m
# CONFIG_DVB_ATBM8830 is not set
# CONFIG_DVB_TDA665x is not set
# CONFIG_DVB_IX2505V is not set
CONFIG_DVB_IT913X_FE=m
CONFIG_DVB_M88RS2000=m
# CONFIG_DVB_AF9033 is not set

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=m

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
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
# CONFIG_FB is not set
# CONFIG_EXYNOS_VIDEO is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_MDA_CONSOLE=m
CONFIG_DUMMY_CONSOLE=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_COMPRESS_OFFLOAD=m
CONFIG_SND_JACK=y
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
CONFIG_SND_DEBUG=y
CONFIG_SND_DEBUG_VERBOSE=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_OPL4_LIB=m
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_WSS_LIB=m
CONFIG_SND_SB_COMMON=m
CONFIG_SND_SB8_DSP=m
CONFIG_SND_SB16_DSP=m
CONFIG_SND_ISA=y
# CONFIG_SND_ADLIB is not set
CONFIG_SND_AD1816A=m
CONFIG_SND_AD1848=m
# CONFIG_SND_ALS100 is not set
CONFIG_SND_AZT1605=m
CONFIG_SND_AZT2316=m
CONFIG_SND_AZT2320=m
# CONFIG_SND_CMI8328 is not set
# CONFIG_SND_CMI8330 is not set
CONFIG_SND_CS4231=m
CONFIG_SND_CS4236=m
# CONFIG_SND_ES1688 is not set
# CONFIG_SND_ES18XX is not set
# CONFIG_SND_SC6000 is not set
# CONFIG_SND_GUSCLASSIC is not set
CONFIG_SND_GUSEXTREME=m
CONFIG_SND_GUSMAX=m
CONFIG_SND_INTERWAVE=m
# CONFIG_SND_INTERWAVE_STB is not set
# CONFIG_SND_JAZZ16 is not set
CONFIG_SND_OPL3SA2=m
# CONFIG_SND_OPTI92X_AD1848 is not set
# CONFIG_SND_OPTI92X_CS4231 is not set
CONFIG_SND_OPTI93X=m
CONFIG_SND_MIRO=m
CONFIG_SND_SB8=m
# CONFIG_SND_SB16 is not set
CONFIG_SND_SBAWE=m
# CONFIG_SND_SB16_CSP is not set
CONFIG_SND_SSCAPE=m
CONFIG_SND_WAVEFRONT=m
# CONFIG_SND_MSND_PINNACLE is not set
CONFIG_SND_MSND_CLASSIC=m
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_SPI is not set
CONFIG_SND_SOC=m
# CONFIG_SND_ATMEL_SOC is not set
CONFIG_SND_SOC_I2C_AND_SPI=m
CONFIG_SND_SOC_ALL_CODECS=m
CONFIG_SND_SOC_WM_HUBS=m
CONFIG_SND_SOC_WM_ADSP=m
CONFIG_SND_SOC_AD1836=m
CONFIG_SND_SOC_AD193X=m
CONFIG_SND_SOC_AD73311=m
CONFIG_SND_SOC_ADAU1373=m
CONFIG_SND_SOC_ADAV80X=m
CONFIG_SND_SOC_ADS117X=m
CONFIG_SND_SOC_AK4104=m
CONFIG_SND_SOC_AK4535=m
CONFIG_SND_SOC_AK4641=m
CONFIG_SND_SOC_AK4642=m
CONFIG_SND_SOC_AK4671=m
CONFIG_SND_SOC_ALC5623=m
CONFIG_SND_SOC_ALC5632=m
CONFIG_SND_SOC_CS42L51=m
CONFIG_SND_SOC_CS42L52=m
CONFIG_SND_SOC_CS42L73=m
CONFIG_SND_SOC_CS4270=m
CONFIG_SND_SOC_CS4271=m
CONFIG_SND_SOC_CX20442=m
CONFIG_SND_SOC_JZ4740_CODEC=m
CONFIG_SND_SOC_L3=m
CONFIG_SND_SOC_DA7210=m
CONFIG_SND_SOC_DA732X=m
CONFIG_SND_SOC_DA9055=m
CONFIG_SND_SOC_DFBMCS320=m
CONFIG_SND_SOC_ISABELLE=m
CONFIG_SND_SOC_LM49453=m
CONFIG_SND_SOC_MAX98088=m
CONFIG_SND_SOC_MAX98090=m
CONFIG_SND_SOC_MAX98095=m
CONFIG_SND_SOC_MAX9850=m
CONFIG_SND_SOC_PCM3008=m
CONFIG_SND_SOC_RT5631=m
CONFIG_SND_SOC_SGTL5000=m
CONFIG_SND_SOC_SPDIF=m
CONFIG_SND_SOC_SSM2602=m
CONFIG_SND_SOC_STA32X=m
CONFIG_SND_SOC_STA529=m
CONFIG_SND_SOC_TLV320AIC23=m
CONFIG_SND_SOC_TLV320AIC26=m
CONFIG_SND_SOC_TLV320AIC32X4=m
CONFIG_SND_SOC_TLV320AIC3X=m
CONFIG_SND_SOC_TLV320DAC33=m
CONFIG_SND_SOC_UDA134X=m
CONFIG_SND_SOC_UDA1380=m
CONFIG_SND_SOC_WL1273=m
CONFIG_SND_SOC_WM0010=m
CONFIG_SND_SOC_WM1250_EV1=m
CONFIG_SND_SOC_WM2000=m
CONFIG_SND_SOC_WM2200=m
CONFIG_SND_SOC_WM5100=m
CONFIG_SND_SOC_WM8510=m
CONFIG_SND_SOC_WM8523=m
CONFIG_SND_SOC_WM8580=m
CONFIG_SND_SOC_WM8711=m
CONFIG_SND_SOC_WM8727=m
CONFIG_SND_SOC_WM8728=m
CONFIG_SND_SOC_WM8731=m
CONFIG_SND_SOC_WM8737=m
CONFIG_SND_SOC_WM8741=m
CONFIG_SND_SOC_WM8750=m
CONFIG_SND_SOC_WM8753=m
CONFIG_SND_SOC_WM8770=m
CONFIG_SND_SOC_WM8776=m
CONFIG_SND_SOC_WM8782=m
CONFIG_SND_SOC_WM8804=m
CONFIG_SND_SOC_WM8900=m
CONFIG_SND_SOC_WM8903=m
CONFIG_SND_SOC_WM8904=m
CONFIG_SND_SOC_WM8940=m
CONFIG_SND_SOC_WM8955=m
CONFIG_SND_SOC_WM8960=m
CONFIG_SND_SOC_WM8961=m
CONFIG_SND_SOC_WM8962=m
CONFIG_SND_SOC_WM8971=m
CONFIG_SND_SOC_WM8974=m
CONFIG_SND_SOC_WM8978=m
CONFIG_SND_SOC_WM8983=m
CONFIG_SND_SOC_WM8985=m
CONFIG_SND_SOC_WM8988=m
CONFIG_SND_SOC_WM8990=m
CONFIG_SND_SOC_WM8991=m
CONFIG_SND_SOC_WM8993=m
CONFIG_SND_SOC_WM8995=m
CONFIG_SND_SOC_WM8996=m
CONFIG_SND_SOC_WM9081=m
CONFIG_SND_SOC_WM9090=m
CONFIG_SND_SOC_LM4857=m
CONFIG_SND_SOC_MAX9768=m
CONFIG_SND_SOC_MAX9877=m
CONFIG_SND_SOC_MC13783=m
CONFIG_SND_SOC_ML26124=m
CONFIG_SND_SOC_TPA6130A2=m
CONFIG_SND_SIMPLE_CARD=m
CONFIG_SOUND_PRIME=m
# CONFIG_SOUND_MSNDCLAS is not set
# CONFIG_SOUND_MSNDPIN is not set
CONFIG_SOUND_OSS=m
CONFIG_SOUND_TRACEINIT=y
CONFIG_SOUND_DMAP=y
# CONFIG_SOUND_VMIDI is not set
# CONFIG_SOUND_TRIX is not set
CONFIG_SOUND_MSS=m
# CONFIG_SOUND_MPU401 is not set
# CONFIG_SOUND_PAS is not set
CONFIG_SOUND_PSS=m
CONFIG_PSS_MIXER=y
# CONFIG_PSS_HAVE_BOOT is not set
CONFIG_SOUND_SB=m
CONFIG_SOUND_YM3812=m
# CONFIG_SOUND_UART6850 is not set
# CONFIG_SOUND_AEDSP16 is not set
CONFIG_SOUND_KAHLUA=m

#
# HID support
#
CONFIG_HID=m
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_APPLE=m
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_PS3REMOTE is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=m
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_CHIPIDEA is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#
# CONFIG_USB_HSIC_USB3503 is not set

#
# USB Physical Layer drivers
#
# CONFIG_OMAP_USB3 is not set
# CONFIG_OMAP_CONTROL_USB is not set
CONFIG_USB_ISP1301=m
# CONFIG_USB_RCAR_PHY is not set
CONFIG_USB_GADGET=m
CONFIG_USB_GADGET_DEBUG=y
CONFIG_USB_GADGET_DEBUG_FILES=y
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FUSB300=m
CONFIG_USB_R8A66597=m
# CONFIG_USB_MV_UDC is not set
# CONFIG_USB_M66592 is not set
# CONFIG_USB_AMD5536UDC is not set
CONFIG_USB_NET2272=m
CONFIG_USB_NET2272_DMA=y
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
CONFIG_USB_LIBCOMPOSITE=m
CONFIG_USB_F_ACM=m
CONFIG_USB_F_SS_LB=m
CONFIG_USB_U_SERIAL=m
CONFIG_USB_ZERO=m
# CONFIG_USB_AUDIO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
CONFIG_USB_MASS_STORAGE=m
CONFIG_USB_G_SERIAL=m
# CONFIG_USB_MIDI_GADGET is not set
CONFIG_USB_G_PRINTER=m
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_ACM_MS is not set
CONFIG_USB_G_MULTI=m
CONFIG_USB_G_MULTI_RNDIS=y
CONFIG_USB_G_MULTI_CDC=y
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
CONFIG_USB_G_WEBCAM=m

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=m
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3533 is not set
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_NET48XX=m
CONFIG_LEDS_WRAP=m
CONFIG_LEDS_PCA9532=m
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=m
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA9633 is not set
CONFIG_LEDS_DAC124S085=m
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=m
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_LT3593 is not set
# CONFIG_LEDS_MC13783 is not set
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
CONFIG_VIRTIO=m

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=m
CONFIG_VIRTIO_MMIO=m
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_ECHO is not set
CONFIG_COMEDI=m
# CONFIG_COMEDI_DEBUG is not set
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
CONFIG_COMEDI_MISC_DRIVERS=y
# CONFIG_COMEDI_KCOMEDILIB is not set
CONFIG_COMEDI_TEST=m
# CONFIG_COMEDI_PARPORT is not set
CONFIG_COMEDI_SERIAL2002=m
# CONFIG_COMEDI_SKEL is not set
# CONFIG_COMEDI_ISA_DRIVERS is not set
# CONFIG_COMEDI_PCI_DRIVERS is not set
# CONFIG_COMEDI_8255 is not set
CONFIG_COMEDI_FC=m
# CONFIG_DX_SEP is not set
# CONFIG_ZSMALLOC is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=m
CONFIG_STAGING_MEDIA=y
# CONFIG_DVB_CXD2099 is not set
# CONFIG_VIDEO_DT3155 is not set
# CONFIG_SOLO6X10 is not set

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ASHMEM=y
# CONFIG_ANDROID_LOGGER is not set
CONFIG_ANDROID_TIMED_OUTPUT=y
# CONFIG_ANDROID_TIMED_GPIO is not set
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_NET_VENDOR_SILICOM is not set
CONFIG_DGRP=m
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=m
CONFIG_STE_MODEM_RPROC=m

#
# Rpmsg drivers
#
# CONFIG_VIRT_DRIVERS is not set
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_IPACK_BUS=m
# CONFIG_BOARD_TPCI200 is not set
CONFIG_SERIAL_IPOCTAL=m

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=m
# CONFIG_DMIID is not set
CONFIG_DMI_SYSFS=m
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
# CONFIG_GOOGLE_SMI is not set
CONFIG_GOOGLE_MEMCONSOLE=m

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=m
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=m
CONFIG_JBD_DEBUG=y
CONFIG_REISERFS_FS=m
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
# CONFIG_REISERFS_FS_SECURITY is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=m
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
CONFIG_NILFS2_FS=m
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QFMT_V1=m
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_CUSE=m

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=m
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=m
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=m
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=m
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=m
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=m
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=m
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=m

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
# CONFIG_PAGE_OWNER is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
CONFIG_DEBUG_OBJECTS_WORK=y
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
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
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_SYNCHRO_TEST is not set
# CONFIG_BOOT_PRINTK_DELAY is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_BLOCK_EXT_DEVT=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_LKDTM=m
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAIL_MAKE_REQUEST=y
CONFIG_FAIL_IO_TIMEOUT=y
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
# CONFIG_LATENCYTOP is not set
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
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
# CONFIG_FTRACE_SYSCALLS is not set
# CONFIG_TRACER_SNAPSHOT is not set
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
CONFIG_STACK_TRACER=y
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
# CONFIG_EVENT_TRACE_TEST_SYSCALLS is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
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
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
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
# CONFIG_DEBUG_BOOT_PARAMS is not set
CONFIG_CPA_DEBUG=y
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_APPRAISE=y
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
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER_X86=m
CONFIG_CRYPTO_GLUE_HELPER_X86=m

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
# CONFIG_CRYPTO_CBC is not set
CONFIG_CRYPTO_CTR=m
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_CAMELLIA=m
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=m
# CONFIG_CRYPTO_SALSA20_586 is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_586=m
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_586=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=m
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_USER_API=m
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=m
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
CONFIG_VHOST_NET=m
# CONFIG_VHOST_BLK is not set
CONFIG_LGUEST=m
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
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
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
CONFIG_BCH=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=m
CONFIG_DDR=y
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_DRM_TTM is not set
# CONFIG_ISDN_DRV_LOOP is not set
# CONFIG_PCI_ATS is not set

--JP+T4n/bALQSJXh8--
