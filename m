Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab3HTPey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 11:34:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:50775 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab3HTPes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:34:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,921,1367996400"; 
   d="log'?scan'208";a="383805669"
Date: Tue, 20 Aug 2013 23:34:00 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: fengguang.wu@intel.com, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [cpufreq] swapper/1 is trying to release lock cpufreq_rwsem at
 cpufreq_add_dev()
Message-ID: <20130820153400.GA7980@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit 6eed9404ab3c4baea54ce4c7e862e69df1d39f38
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Tue Aug 6 22:53:11 2013 +0530

    cpufreq: Use rwsem for protecting critical sections
    
    Critical sections of the cpufreq core are protected with the help of
    the driver module owner's refcount, which isn't the correct approach,
    because it causes rmmod to return an error when some routine has
    updated that refcount.
    
    Let's use rwsem for this purpose instead.  Only
    cpufreq_unregister_driver() will use write sem
    and everybody else will use read sem.
    
    [rjw: Subject & changelog]
    Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>


[   21.664908] 3.11.0-rc5-next-20130816-05970-g1e712b0 #17 Not tainted
[   21.664908] -------------------------------------
[   21.664908] swapper/1 is trying to release lock (cpufreq_rwsem) at:
[   21.664908] [<ffffffff8164fa12>] cpufreq_add_dev+0x232/0x360
[   21.664908] but there are no more locks to release!
[   21.664908] 
[   21.664908] other info that might help us debug this:
[   21.664908] 1 lock held by swapper/1:
[   21.664908]  #0:  (subsys mutex){+.+.+.}, at: [<ffffffff813e26a4>] subsys_interface_register+0x54/0xf0
[   21.664908] 
[   21.664908] stack backtrace:
[   21.664908] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-rc5-next-20130816-05970-g1e712b0 #17
[   21.664908]  ffffffff8164fa12 ffff88000dc63ce8 ffffffff81886d70 ffff88000dc63d10
[   21.664908]  ffffffff810c755c ffffffff81d66b50 ffff88000dc59040 ffffffff8164fa12
[   21.664908]  ffff88000dc63d88 ffffffff810cbf56 ffffffff810c8430 000000070dc63d68
[   21.664908] Call Trace:
[   21.664908]  [<ffffffff8164fa12>] ? cpufreq_add_dev+0x232/0x360
[   21.664908]  [<ffffffff81886d70>] dump_stack+0x19/0x1b
[   21.664908]  [<ffffffff810c755c>] print_unlock_imbalance_bug+0xec/0x100
[   21.664908]  [<ffffffff8164fa12>] ? cpufreq_add_dev+0x232/0x360
[   21.664908]  [<ffffffff810cbf56>] lock_release_non_nested+0x226/0x300
[   21.664908]  [<ffffffff810c8430>] ? mark_held_locks+0xb0/0x130
[   21.664908]  [<ffffffff81130489>] ? kfree+0xe9/0x140
[   21.664908]  [<ffffffff8164fa12>] ? cpufreq_add_dev+0x232/0x360
[   21.664908]  [<ffffffff810cc0b8>] lock_release+0x88/0x1b0
[   21.664908]  [<ffffffff810ae60a>] up_read+0x1a/0x40
[   21.664908]  [<ffffffff8164fa12>] cpufreq_add_dev+0x232/0x360
[   21.664908]  [<ffffffff813e26f9>] subsys_interface_register+0xa9/0xf0
[   21.664908]  [<ffffffff81650f34>] cpufreq_register_driver+0x84/0x130
[   21.664908]  [<ffffffff81de4f9d>] ? cpufreq_gov_dbs_init+0x12/0x12
[   21.664908]  [<ffffffff81de4fee>] acpi_cpufreq_init+0x51/0x134
[   21.664908]  [<ffffffff81dac003>] do_one_initcall+0x8c/0x138
[   21.664908]  [<ffffffff810a8b18>] ? parse_args+0x1f8/0x330
[   21.664908]  [<ffffffff81dac1c2>] kernel_init_freeable+0x113/0x18e
[   21.664908]  [<ffffffff81dab860>] ? do_early_param+0x88/0x88
[   21.664908]  [<ffffffff8187f390>] ? rest_init+0x150/0x150
[   21.664908]  [<ffffffff8187f399>] kernel_init+0x9/0x180
[   21.664908]  [<ffffffff818a0dba>] ret_from_fork+0x7a/0xb0
[   21.664908]  [<ffffffff8187f390>] ? rest_init+0x150/0x150
[   21.689085] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[   21.758668] Freeing unused kernel memory: 772K (ffffffff81dab000 - ffffffff81e6c000)

git bisect start 233035a7f291ea27aec280270bc05293da3b0e7c v3.10 --
git bisect good 496322bc91e35007ed754184dcd447a02b6dd685  # 19:57     60+  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
git bisect  bad 1be61c8552a7fb4b1f3229b25bfaa2f1ae834730  # 20:04      0-  Merge remote-tracking branch 'slave-dma/next'
git bisect good 549f3a1218ba18fcde11ef0e22b07e6365645788  # 20:17     60+  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux
git bisect good 3227db39cc40b6d933ef8629094feb9ce1a0492e  # 20:27     60+  Merge remote-tracking branch 'net/master'
git bisect good 978ff9279fad8d3eeef71062b268f0da429d619a  # 20:32     60+  Merge remote-tracking branch 'vfs/for-next'
git bisect good 164aa191a5625d5fe37e01cfc13849f87910c676  # 20:56     60+  Merge remote-tracking branch 'libata/for-next'
git bisect good 84a55797049fbbb7d8da9fe3e664c7dc96601fa5  # 21:17     60+  Merge branch 'pm-cpuidle'
git bisect  bad 832a373ea2343d616ec769e7939f7eb6810713aa  # 21:22      0-  Merge branch 'fixes-next' into linux-next
git bisect  bad b678c5d3074d55cb49d7cc96875d04bd47ae847e  # 21:28      0-  Merge branch 'pm-sleep' into linux-next
git bisect good 1133bfa6dcf034639486982629d29472737d5e96  # 21:41     60+  Merge branch 'pm-cpufreq-ondemand' into pm-cpufreq
git bisect good fe492f3f0332e23cc6ca4913e5a2ed78e1888902  # 21:46     60+  cpufreq: Fix broken usage of governor->owner's refcount
git bisect  bad 3de9bdeb28638e164d1f0eb38dd68e3f5d2ac95c  # 21:53      0-  cpufreq: improve error checking on return values of __cpufreq_governor()
git bisect  bad adc97d6a735dbb1e94cb4f1bf0b55f258b349941  # 21:57      0-  cpufreq: Drop the owner field from struct cpufreq_driver
git bisect  bad 6eed9404ab3c4baea54ce4c7e862e69df1d39f38  # 22:01      0-  cpufreq: Use rwsem for protecting critical sections
git bisect good fe492f3f0332e23cc6ca4913e5a2ed78e1888902  # 22:24    180+  cpufreq: Fix broken usage of governor->owner's refcount
git bisect  bad 1e712b0818569846d6b926ecb6bf32b3dea73609  # 22:24      0-  Add linux-next specific files for 20130816
git bisect good fd3930f70c8d14008f3377d51ce039806dfc542e  # 23:14    180+  proc: more readdir conversion bug-fixes
git bisect  bad d7949dff8fd98d8dd7ee46a8b1a089fe80099869  # 23:19      0-  Add linux-next specific files for 20130820

Thanks,
Fengguang

--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg-kvm-ant-19071-20130818122323--
Content-Transfer-Encoding: quoted-printable

[    0.000000] Linux version 3.11.0-rc5-next-20130816-05970-g1e712b0 (kbuil=
d@athens) (gcc version 4.8.1 (Debian 4.8.1-8) ) #17 Sun Aug 18 12:22:44 CST=
 2013
[    0.000000] Command line: hung_task_panic=3D1 rcutree.rcu_cpu_stall_time=
out=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug d=
ynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/ke=
rnel-tests/run-queue/kvm/x86_64-randconfig-a06-0818/next:master/.vmlinuz-1e=
712b0818569846d6b926ecb6bf32b3dea73609-20130818122400-2-ant branch=3Dnext/m=
aster noapic nolapic nohz=3Doff BOOT_IMAGE=3D/kernel/x86_64-randconfig-a06-=
0818/1e712b0818569846d6b926ecb6bf32b3dea73609/vmlinuz-3.11.0-rc5-next-20130=
816-05970-g1e712b0
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x400000000
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
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at =
[ffff8800000fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0282e000, 0x0282efff] PGTABLE
[    0.000000] BRK [0x0282f000, 0x0282ffff] PGTABLE
[    0.000000] BRK [0x02830000, 0x02830fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x02831000, 0x02831fff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127664(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 00034 (v01 BOCHS  BXPCRSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000=
001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 011A9 (v01   BXPC   BXDSDT 00000=
001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000=
001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 00080 (v01 BOCHS  BXPCAPIC 00000=
001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 00038 (v01 BOCHS  BXPCHPET 00000=
001 BXPC 00000001)
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 840 pages used for memmap
[    0.000000]   DMA32 zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1        =20
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
[    0.000000] Bus #0 is PCI  =20
[    0.000000] Bus #1 is ISA  =20
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 09
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 10, APIC ID 0, APIC =
INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 14, APIC ID 0, APIC =
INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 18, APIC ID 0, APIC =
INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 1c, APIC ID 0, APIC =
INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 20, APIC ID 0, APIC =
INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 24, APIC ID 0, APIC =
INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 28, APIC ID 0, APIC =
INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC=
 LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, API=
C LINT 01
[    0.000000] Processors: 1
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfffbffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64519
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-a06-0818/next:master/.vmli=
nuz-1e712b0818569846d6b926ecb6bf32b3dea73609-20130818122400-2-ant branch=3D=
next/master noapic nolapic nohz=3Doff BOOT_IMAGE=3D/kernel/x86_64-randconfi=
g-a06-0818/1e712b0818569846d6b926ecb6bf32b3dea73609/vmlinuz-3.11.0-rc5-next=
-20130816-05970-g1e712b0
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.000000] Memory: 200988K/261744K available (8847K kernel code, 1406K =
rwdata, 3728K rodata, 772K init, 9992K bss, 60756K reserved)
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
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
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] allocated 1048576 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] ODEBUG: 2 of 2 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3192.002 MHz processor
[    0.008000] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 6384.00 BogoMIPS (lpj=3D3192002)
[    0.009200] pid_max: default: 4096 minimum: 301
[    0.013346] Mount-cache hash table entries: 256
[    0.035153] Initializing cgroup subsys debug
[    0.036525] Initializing cgroup subsys memory
[    0.039501] Initializing cgroup subsys devices
[    0.040379] Initializing cgroup subsys perf_event
[    0.045931] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.045931] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.045931] tlb_flushall_shift: -1
[    0.046109] CPU: AMD QEMU Virtual CPU version 1.5.0 (fam: 06, model: 02,=
 stepping: 03)
[    0.071506] ACPI: Core revision 20130725
[    0.176164] ACPI: All ACPI Tables successfully acquired
[    0.177118] ACPI: setting ELCR to 0200 (from 0c00)
[    0.202417] Performance Events:=20
[    0.203212] no APIC, boot with the "lapic" boot parameter to force-enabl=
e it.
[    0.203717] no hardware sampling interrupt available.
[    0.204471] Broken PMU hardware detected, using software events only.
[    0.205119] Failed to access perfctr msr (MSR c0010004 is 0)
[    0.226765] Apic disabled
[    0.230628] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.256529] devtmpfs: initialized
[    0.290694] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.292524] RTC time:  4:22:37, date: 08/18/13
[    0.298080] NET: Registered protocol family 16
[    0.325437] cpuidle: using governor ladder
[    0.326299] cpuidle: using governor menu
[    0.337588] ACPI: bus type PCI registered
[    0.339229] dca service started, version 1.12.1
[    0.342664] PCI: Using configuration type 1 for base access
[    0.684349] ACPI: Added _OSI(Module Device)
[    0.684718] ACPI: Added _OSI(Processor Device)
[    0.685091] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.685427] ACPI: Added _OSI(Processor Aggregator Device)
[    0.724282] ACPI: EC: Look up EC in DSDT
[    0.914358] ACPI: Interpreter enabled
[    0.915366] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20130725/hwxface-571)
[    0.916479] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20130725/hwxface-571)
[    0.919155] ACPI: (supports S0 S3 S5)
[    0.919576] ACPI: Using PIC for interrupt routing
[    0.921589] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.965289] ACPI: No dock devices found.
[    1.355965] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.376316] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    1.382270] PCI host bridge to bus 0000:00
[    1.383352] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.384383] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.385105] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.385570] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.386111] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    1.389478] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.406351] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.412298] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.422157] pci 0000:00:01.1: reg 0x20: [io  0xc1e0-0xc1ef]
[    1.436230] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.438541] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    1.439172] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    1.449545] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.453166] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.457123] pci 0000:00:02.0: reg 0x14: [mem 0xfebe0000-0xfebe0fff]
[    1.472158] pci 0000:00:02.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    1.478164] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    1.480124] pci 0000:00:03.0: reg 0x10: [io  0xc1c0-0xc1df]
[    1.484121] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    1.497123] pci 0000:00:03.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    1.507493] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    1.510125] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    1.512120] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    1.524220] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    1.534151] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    1.536129] pci 0000:00:05.0: reg 0x10: [io  0xc040-0xc07f]
[    1.540122] pci 0000:00:05.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[    1.564217] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.566243] pci 0000:00:06.0: reg 0x10: [io  0xc080-0xc0bf]
[    1.569123] pci 0000:00:06.0: reg 0x14: [mem 0xfebe3000-0xfebe3fff]
[    1.591372] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.594126] pci 0000:00:07.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    1.597131] pci 0000:00:07.0: reg 0x14: [mem 0xfebe4000-0xfebe4fff]
[    1.618331] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.621158] pci 0000:00:08.0: reg 0x10: [io  0xc100-0xc13f]
[    1.623240] pci 0000:00:08.0: reg 0x14: [mem 0xfebe5000-0xfebe5fff]
[    1.645218] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.647240] pci 0000:00:09.0: reg 0x10: [io  0xc140-0xc17f]
[    1.650139] pci 0000:00:09.0: reg 0x14: [mem 0xfebe6000-0xfebe6fff]
[    1.672407] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    1.675127] pci 0000:00:0a.0: reg 0x10: [io  0xc180-0xc1bf]
[    1.678103] pci 0000:00:0a.0: reg 0x14: [mem 0xfebe7000-0xfebe7fff]
[    1.699623] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    1.702124] pci 0000:00:0b.0: reg 0x10: [mem 0xfebe8000-0xfebe800f]
[    1.725295] pci_bus 0000:00: on NUMA node 0
[    1.726207] acpi PNP0A03:00: ACPI _OSC support notification failed, disa=
bling PCIe ASPM
[    1.726792] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    1.766586] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.776525] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.785454] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.793649] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.798211] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    1.827000] ACPI: Enabled 16 GPEs in block 00 to 0F
[    1.828306] ACPI: \_SB_.PCI0: notify handler is installed
[    1.831434] Found 1 acpi root devices
[    1.849000] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.849229] vgaarb: loaded
[    1.849538] vgaarb: bridge control possible 0000:00:02.0
[    1.856242] tps65010: version 2 May 2005
[    1.883715] tps65010: no chip?
[    1.893541] Linux video capture interface: v2.00
[    1.895665] pps_core: LinuxPPS API ver. 1 registered
[    1.896101] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.897372] PTP clock support registered
[    1.899270] EDAC MC: Ver: 3.0.0
[    1.906272] wmi: Mapper loaded
[    1.910710] PCI: Using ACPI for IRQ routing
[    1.911429] PCI: pci_cache_line_size set to 64 bytes
[    1.914541] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.915545] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    1.947823] NET: Registered protocol family 23
[    1.950460] Bluetooth: Core ver 2.16
[    1.951617] NET: Registered protocol family 31
[    1.952124] Bluetooth: HCI device and connection manager initialized
[    1.953512] Bluetooth: HCI socket layer initialized
[    1.954306] Bluetooth: L2CAP socket layer initialized
[    1.955629] Bluetooth: SCO socket layer initialized
[    1.956221] NET: Registered protocol family 8
[    1.957105] NET: Registered protocol family 20
[    1.963601] nfc: nfc_init: NFC Core ver 0.1
[    1.966349] NET: Registered protocol family 39
[    1.974519] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    1.985000] Switched to clocksource hpet
[    1.990223] FS-Cache: Loaded
[    1.991634] pnp: PnP ACPI init
[    1.993379] ACPI: bus type PNP registered
[    2.004683] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.009099] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.012378] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    2.016241] pnp 00:03: [dma 2]
[    2.018104] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    2.022300] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    2.026463] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.039280] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    2.048180] pnp: PnP ACPI: found 7 devices
[    2.048622] ACPI: bus type PNP unregistered
[    2.049317] INFO_MDMA: LNW DMA Driver Version 1.1.0
[    2.082628] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.083445] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.084142] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.084571] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    2.086275] NET: Registered protocol family 1
[    2.087160] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.087719] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    2.089132] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    2.090075] pci 0000:00:02.0: Boot video device
[    2.091261] PCI: CLS 0 bytes, default 64
[    2.106653] Unpacking initramfs...
[   16.006937] Freeing initrd memory: 23656K (ffff88000e8d6000 - ffff88000f=
ff0000)
[   16.492509] DMA-API: preallocated 65536 debug entries
[   16.493264] DMA-API: debugging enabled by kernel config
[   16.513707] microcode: AMD CPU family 0x6 not supported
[   16.706453] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[   16.707354] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[   16.708081] AVX or AES-NI instructions are not detected.
[   16.708491] AVX instructions are not detected.
[   16.709125] AVX instructions are not detected.
[   16.709484] AVX instructions are not detected.
[   16.710113] AVX instructions are not detected.
[   16.724290] audit: initializing netlink socket (disabled)
[   16.727741] type=3D2000 audit(1376799773.725:1): initialized
[   16.748286] VFS: Disk quotas dquot_6.5.2
[   16.749217] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   16.765374] jffs2: version 2.2. (NAND) (SUMMARY) =20
[   16.774343] ROMFS MTD (C) 2007 Red Hat, Inc.
[   16.775587] msgmni has been set to 438
[   16.970205] alg: No test for crc32 (crc32-table)
[   16.977099] alg: No test for lz4hc (lz4hc-generic)
[   16.979144] alg: No test for stdrng (krng)
[   17.194694] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[   17.200222] NET: Registered protocol family 38
[   17.201544] Key type asymmetric registered
[   17.202464] Asymmetric key parser 'x509' registered
[   17.203188] list_sort_test: start testing list_sort()
[   17.238652] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[   17.240526] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[   17.248416] nvidiafb_setup START
[   17.251743] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[   17.257156] vmlfb: initializing
[   17.258301] Could not find Carillo Ranch MCH device.
[   17.262247] hgafb: HGA card not detected.
[   17.263072] hgafb: probe of hgafb.0 failed with error -22
[   17.276357] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[   17.300336] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   17.301679] ACPI: Power Button [PWRF]
[   17.316434] GHES: HEST is not enabled!
[   17.317149] ERST DBG: ERST support is disabled.
[   17.317516] ioatdma: Intel(R) QuickData Technology Driver 4.00
[   17.355505] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[   17.356517] PCI: setting IRQ 11 as level-triggered
[   17.359440] virtio-pci 0000:00:03.0: setting latency timer to 64
[   17.390405] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[   17.391116] PCI: setting IRQ 10 as level-triggered
[   17.393413] virtio-pci 0000:00:05.0: setting latency timer to 64
[   17.421755] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[   17.424689] virtio-pci 0000:00:06.0: setting latency timer to 64
[   17.449132] virtio-pci 0000:00:07.0: setting latency timer to 64
[   17.477441] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[   17.481246] virtio-pci 0000:00:08.0: setting latency timer to 64
[   17.506220] virtio-pci 0000:00:09.0: setting latency timer to 64
[   17.533170] virtio-pci 0000:00:0a.0: setting latency timer to 64
[   17.540083] tsc: Refined TSC clocksource calibration: 3191.999 MHz
[   17.541175] Switched to clocksource tsc
[   17.543226] HDLC line discipline maxframe=3D4096
[   17.543601] N_HDLC line discipline registered.
[   17.545168] r3964: Philips r3964 Driver $Revision: 1.10 $
[   17.545644] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   17.576467] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[   17.610504] Cyclades driver 2.6
[   17.613165] MOXA Intellio family driver version 6.0k
[   17.615544] MOXA Smartio/Industio family driver version 2.0.5
[   17.617319] RocketPort device driver module, version 2.09, 12-June-2003
[   17.619036] No rocketport ports found; unloading driver
[   17.620343] SyncLink GT
[   17.621052] SyncLink GT, tty major#247
[   17.622182] SyncLink GT no devices found
[   17.622522] SyncLink MultiPort driver $Revision: 4.38 $
[   17.831470] SyncLink MultiPort driver $Revision: 4.38 $, tty major#246
[   17.832322] SyncLink serial driver $Revision: 4.38 $
[   18.042167] SyncLink serial driver $Revision: 4.38 $, tty major#245
[   18.047184] Non-volatile memory driver v1.3
[   18.048473] ppdev: user-space parallel port driver
[   18.049424] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[   18.051129] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[   18.051698] Hangcheck: Using getrawmonotonic().
[   18.059054] parport_pc 00:04: reported by Plug and Play ACPI
[   18.062284] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[   18.088194] dummy-irq: no IRQ given.  Use irq=3DN
[   18.090595] Phantom Linux Driver, version n0.9.8, init OK
[   18.106859] Driver for timberdale has been successfully registered.
[   18.118455] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[   18.120269] device id =3D 2440
[   18.120622] device id =3D 2480
[   18.121189] device id =3D 24c0
[   18.121471] device id =3D 24d0
[   18.122002] device id =3D 25a1
[   18.122288] device id =3D 2670
[   18.124753] platform physmap-flash.0: failed to claim resource 0
[   18.126158] NetSc520 flash device: 0x100000 at 0x200000
[   18.127095] Failed to ioremap_nocache
[   18.127448] Failed to ioremap_nocache
[   18.128503] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[   18.131188] slram: not enough parameters.
[   18.171138] No valid DiskOnChip devices found
[   18.176190] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[   18.177069] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[   18.177644] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[   18.178517] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[   18.179380] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[   18.180227] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[   18.181626] NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba N=
AND 128MiB 1,8V 8-bit), 128MiB, page size: 512, OOB size: 16
[   18.185118] flash size: 128 MiB
[   18.185394] page size: 512 bytes
[   18.185651] OOB area size: 16 bytes
[   18.186230] sector size: 16 KiB
[   18.186492] pages number: 262144
[   18.187008] pages per sector: 32
[   18.187274] bus width: 8
[   18.187495] bits in sector size: 14
[   18.188044] bits in page size: 9
[   18.188315] bits in OOB size: 4
[   18.188573] flash size with OOB: 135168 KiB
[   18.189177] page address bytes: 4
[   18.189447] sector address bytes: 3
[   18.189750] options: 0x42
[   18.209269] Scanning device for bad blocks
[   18.830386] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[   18.831689] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[   18.965408] parport0: AVR Butterfly
[   18.970276] HSI/SSI char device loaded
[   18.979201] I2O subsystem v1.325
[   18.979535] i2o: max drivers =3D 8
[   18.983443] I2O Bus Adapter OSM v1.317
[   18.984427] I2O ProcFS OSM v1.316
[   18.994069] VFIO - User Level meta-driver version: 0.3
[   19.000644] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   19.010135] serio: i8042 KBD port at 0x60,0x64 irq 1
[   19.012130] serio: i8042 AUX port at 0x60,0x64 irq 12
[   19.020444] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[   19.046181] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[   19.073309] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   19.074867] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[   19.092468] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[   19.104051] i2c-parport-light: adapter type unspecified
[   19.115859] saa7146: register extension 'budget dvb'
[   19.117200] saa7146: register extension 'budget_patch dvb'
[   19.118375] saa7146: register extension 'av7110'
[   19.119515] nGene PCIE bridge driver, Copyright (C) 2005-2007 Micronas
[   19.121024] Digital Devices PCIE bridge driver, Copyright (C) 2010-11 Di=
gital Devices GmbH
[   19.123292] saa7130/34: v4l2 driver version 0, 2, 17 loaded
[   19.137172] pps_ldisc: PPS line discipline registered
[   19.137573] pps_parport: parallel port PPS client
[   19.138425] parport0: cannot grant exclusive access for device pps_parpo=
rt
[   19.139261] pps_parport: couldn't register with parport0
[   19.140362] Driver for 1-wire Dallas network protocol.
[   19.144178] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[   19.147071] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[   19.192042] w83793: Detection failed at check vendor id
[   19.198005] w83793: Detection failed at check vendor id
[   19.204026] w83793: Detection failed at check vendor id
[   19.210006] w83793: Detection failed at check vendor id
[   19.215148] i2c i2c-0: w83795: Detection failed at addr 0x2c, check bank
[   19.219031] i2c i2c-0: w83795: Detection failed at addr 0x2d, check bank
[   19.223028] i2c i2c-0: w83795: Detection failed at addr 0x2e, check bank
[   19.227026] i2c i2c-0: w83795: Detection failed at addr 0x2f, check bank
[   19.232062] i2c i2c-0: Detection of w83781d chip failed at step 3
[   19.236027] i2c i2c-0: Detection of w83781d chip failed at step 3
[   19.240020] i2c i2c-0: Detection of w83781d chip failed at step 3
[   19.244042] i2c i2c-0: Detection of w83781d chip failed at step 3
[   19.248022] i2c i2c-0: Detection of w83781d chip failed at step 3
[   19.252020] i2c i2c-0: Detection of w83781d chip failed at step 3
[   19.256021] i2c i2c-0: Detection of w83781d chip failed at step 3
[   19.260018] i2c i2c-0: Detection of w83781d chip failed at step 3
[   19.282067] i2c i2c-0: ADM1025 detection failed at 0x2c
[   19.286026] i2c i2c-0: ADM1025 detection failed at 0x2d
[   19.290025] i2c i2c-0: ADM1025 detection failed at 0x2e
[   19.393067] i2c i2c-0: detect fail: address match, 0x2c
[   19.397026] i2c i2c-0: detect fail: address match, 0x2d
[   19.401026] i2c i2c-0: detect fail: address match, 0x2e
[   19.405024] i2c i2c-0: detect fail: address match, 0x2f
[   19.411121]  (null): Wrong manufacturer ID. Got 255, expected 65
[   19.415023]  (null): Wrong manufacturer ID. Got 255, expected 65
[   19.419023]  (null): Wrong manufacturer ID. Got 255, expected 65
[   19.517192] f71882fg: Not a Fintek device
[   19.517611] f71882fg: Not a Fintek device
[   19.531068]  (null): Unknown chip type, skipping
[   19.535016]  (null): Unknown chip type, skipping
[   19.633070] i2c i2c-0: Unsupported chip (man_id=3D0xFF, chip_id=3D0xFF)
[   19.647027] i2c i2c-0: Unsupported chip (man_id=3D0xFF, chip_id=3D0xFF)
[   19.661027] i2c i2c-0: Unsupported chip (man_id=3D0xFF, chip_id=3D0xFF)
[   21.012219] i2c i2c-0: Unsupported chip at 0x18 (man_id=3D0xFF, chip_id=
=3D0xFF)
[   21.023001] i2c i2c-0: Unsupported chip at 0x19 (man_id=3D0xFF, chip_id=
=3D0xFF)
[   21.032998] i2c i2c-0: Unsupported chip at 0x1a (man_id=3D0xFF, chip_id=
=3D0xFF)
[   21.042999] i2c i2c-0: Unsupported chip at 0x29 (man_id=3D0xFF, chip_id=
=3D0xFF)
[   21.052998] i2c i2c-0: Unsupported chip at 0x2a (man_id=3D0xFF, chip_id=
=3D0xFF)
[   21.062999] i2c i2c-0: Unsupported chip at 0x2b (man_id=3D0xFF, chip_id=
=3D0xFF)
[   21.073021] i2c i2c-0: Unsupported chip at 0x48 (man_id=3D0xFF, chip_id=
=3D0xFF)
[   21.082999] i2c i2c-0: Unsupported chip at 0x49 (man_id=3D0xFF, chip_id=
=3D0xFF)
[   21.092999] i2c i2c-0: Unsupported chip at 0x4a (man_id=3D0xFF, chip_id=
=3D0xFF)
[   21.102999] i2c i2c-0: Unsupported chip at 0x4b (man_id=3D0xFF, chip_id=
=3D0xFF)
[   21.113041] i2c i2c-0: Unsupported chip at 0x4c (man_id=3D0xFF, chip_id=
=3D0xFF)
[   21.122998] i2c i2c-0: Unsupported chip at 0x4d (man_id=3D0xFF, chip_id=
=3D0xFF)
[   21.132998] i2c i2c-0: Unsupported chip at 0x4e (man_id=3D0xFF, chip_id=
=3D0xFF)
[   21.142998] i2c i2c-0: Unsupported chip at 0x4f (man_id=3D0xFF, chip_id=
=3D0xFF)
[   21.186037] i2c i2c-0: MAX1619 detection failed at 0x18
[   21.194015] i2c i2c-0: MAX1619 detection failed at 0x19
[   21.201993] i2c i2c-0: MAX1619 detection failed at 0x1a
[   21.209993] i2c i2c-0: MAX1619 detection failed at 0x29
[   21.217994] i2c i2c-0: MAX1619 detection failed at 0x2a
[   21.225994] i2c i2c-0: MAX1619 detection failed at 0x2b
[   21.234015] i2c i2c-0: MAX1619 detection failed at 0x4c
[   21.241994] i2c i2c-0: MAX1619 detection failed at 0x4d
[   21.249994] i2c i2c-0: MAX1619 detection failed at 0x4e
[   21.285613] pc87360: PC8736x not detected, module not inserted
[   21.289052] i2c i2c-0: amc6821_detect called.
[   21.293037] i2c i2c-0: amc6821: detection failed at 0x18.
[   21.294996] i2c i2c-0: amc6821_detect called.
[   21.298994] i2c i2c-0: amc6821: detection failed at 0x19.
[   21.300991] i2c i2c-0: amc6821_detect called.
[   21.304996] i2c i2c-0: amc6821: detection failed at 0x1a.
[   21.306992] i2c i2c-0: amc6821_detect called.
[   21.310993] i2c i2c-0: amc6821: detection failed at 0x2c.
[   21.312993] i2c i2c-0: amc6821_detect called.
[   21.316993] i2c i2c-0: amc6821: detection failed at 0x2d.
[   21.318991] i2c i2c-0: amc6821_detect called.
[   21.322992] i2c i2c-0: amc6821: detection failed at 0x2e.
[   21.324993] i2c i2c-0: amc6821_detect called.
[   21.328993] i2c i2c-0: amc6821: detection failed at 0x4c.
[   21.330994] i2c i2c-0: amc6821_detect called.
[   21.334996] i2c i2c-0: amc6821: detection failed at 0x4d.
[   21.336992] i2c i2c-0: amc6821_detect called.
[   21.340994] i2c i2c-0: amc6821: detection failed at 0x4e.
[   21.379042] i2c i2c-0: w83l785ts: Read 0xff from register 0x40.
[   21.379512] i2c i2c-0: W83L785TS-S detection failed at 0x2e
[   21.384059] i2c i2c-0: W83L786NG detection failed at 0x2e
[   21.387995] i2c i2c-0: W83L786NG detection failed at 0x2f
[   21.392376] intel_powerclamp: Intel powerclamp does not run on family 6 =
model 2
[   21.393144] Bluetooth: Virtual HCI driver ver 1.3
[   21.395513] Bluetooth: HCI UART driver ver 2.2
[   21.429565] hidraw: raw HID events driver (C) Jiri Kosina
[   21.452656] compal_laptop: Motherboard not recognized (You could try the=
 module's force-parameter)
[   21.457081] msi_wmi: This machine doesn't have neither MSI-hotkeys nor b=
acklight through WMI
[   21.458458] toshiba_acpi: Unable to create proc dir toshiba
[   21.461207] intel_oaktrail: Platform not recognized (You could try the m=
odule's force-parameter)
[   21.463204] AMD IOMMUv2 driver by Joerg Roedel <joerg.roedel@amd.com>
[   21.463726] AMD IOMMUv2 functionality not available on this system
[   21.482293]  fake-fmc-carrier: mezzanine 0
[   21.483317]       Manufacturer: fake-vendor
[   21.483639]       Product name: fake-design-for-testing
[   21.486084] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   21.487025] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eep=
rom: no busid passed, refusing all cards
[   21.488373] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   21.492391] fmc_chardev fake-design-for-testing-f001: Created misc devic=
e "fake-design-for-testing-f001"
[   21.501222] Audio Excel DSP 16 init driver Copyright (C) Riccardo Facche=
tti 1995-98
[   21.501982] aedsp16: I/O, IRQ and DMA are mandatory
[   21.502424] pss: mss_io, mss_dma, mss_irq and pss_io must be set.
[   21.503120] ad1848/cs4248 codec driver Copyright (C) by Hannu Savolainen=
 1993-1996
[   21.504032] ad1848: No ISAPnP cards found, trying standard ones...
[   21.504531] Pro Audio Spectrum driver Copyright (C) by Hannu Savolainen =
1993-1996
[   21.505290] I/O, IRQ, DMA and type are mandatory
[   21.505675] sb: Init: Starting Probe...
[   21.506973] sb: Init: Done
[   21.507735] uart6850: irq and io must be set.
[   21.508340] YM3812 and OPL-3 driver Copyright (C) by Hannu Savolainen, R=
ob Hooft 1993-1996
[   21.509124] MIDI Loopback device driver
[   21.514339] oprofile: using timer interrupt.
[   21.516541] NET: Registered protocol family 26
[   21.519619] NET: Registered protocol family 15
[   21.522559] NET: Registered protocol family 5
[   21.534411] IrCOMM protocol (Dag Brattli)
[   21.583455] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   21.584284] Bluetooth: HIDP socket layer initialized
[   21.585240] lec:lane_module_init: lec.c: initialized
[   21.588594] 8021q: 802.1Q VLAN Support v1.8
[   21.592559] 9pnet: Installing 9P2000 support
[   21.597190] NET: Registered protocol family 37
[   21.598193] NET: Registered protocol family 36
[   21.601970] Key type dns_resolver registered
[   21.607008] batman_adv: B.A.T.M.A.N. advanced 2013.3.0 (compatibility ve=
rsion 14) loaded
[   21.607567] openvswitch: Open vSwitch switching datapath
[   21.611184] mpls_gso: MPLS GSO support
[   21.618160]=20
[   21.618160] printing PIC contents
[   21.618590] ... PIC  IMR: ed78
[   21.618894] ... PIC  IRR: 0011
[   21.619388] ... PIC  ISR: 0000
[   21.619666] ... PIC ELCR: 0e00
[   21.638142] Key type trusted registered
[   21.647048] RIO: rio_register_scan for mport_id=3D-1
[   21.651514] dmaengine: __dma_request_channel: fail ((null))
[   21.657028]   Magic number: 9:608:363
[   21.664908]=20
[   21.664908] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   21.664908] [ BUG: bad unlock balance detected! ]
[   21.664908] 3.11.0-rc5-next-20130816-05970-g1e712b0 #17 Not tainted
[   21.664908] -------------------------------------
[   21.664908] swapper/1 is trying to release lock (cpufreq_rwsem) at:
[   21.664908] [<ffffffff8164fa12>] cpufreq_add_dev+0x232/0x360
[   21.664908] but there are no more locks to release!
[   21.664908]=20
[   21.664908] other info that might help us debug this:
[   21.664908] 1 lock held by swapper/1:
[   21.664908]  #0:  (subsys mutex){+.+.+.}, at: [<ffffffff813e26a4>] subsy=
s_interface_register+0x54/0xf0
[   21.664908]=20
[   21.664908] stack backtrace:
[   21.664908] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-rc5-next-2013=
0816-05970-g1e712b0 #17
[   21.664908]  ffffffff8164fa12 ffff88000dc63ce8 ffffffff81886d70 ffff8800=
0dc63d10
[   21.664908]  ffffffff810c755c ffffffff81d66b50 ffff88000dc59040 ffffffff=
8164fa12
[   21.664908]  ffff88000dc63d88 ffffffff810cbf56 ffffffff810c8430 00000007=
0dc63d68
[   21.664908] Call Trace:
[   21.664908]  [<ffffffff8164fa12>] ? cpufreq_add_dev+0x232/0x360
[   21.664908]  [<ffffffff81886d70>] dump_stack+0x19/0x1b
[   21.664908]  [<ffffffff810c755c>] print_unlock_imbalance_bug+0xec/0x100
[   21.664908]  [<ffffffff8164fa12>] ? cpufreq_add_dev+0x232/0x360
[   21.664908]  [<ffffffff810cbf56>] lock_release_non_nested+0x226/0x300
[   21.664908]  [<ffffffff810c8430>] ? mark_held_locks+0xb0/0x130
[   21.664908]  [<ffffffff81130489>] ? kfree+0xe9/0x140
[   21.664908]  [<ffffffff8164fa12>] ? cpufreq_add_dev+0x232/0x360
[   21.664908]  [<ffffffff810cc0b8>] lock_release+0x88/0x1b0
[   21.664908]  [<ffffffff810ae60a>] up_read+0x1a/0x40
[   21.664908]  [<ffffffff8164fa12>] cpufreq_add_dev+0x232/0x360
[   21.664908]  [<ffffffff813e26f9>] subsys_interface_register+0xa9/0xf0
[   21.664908]  [<ffffffff81650f34>] cpufreq_register_driver+0x84/0x130
[   21.664908]  [<ffffffff81de4f9d>] ? cpufreq_gov_dbs_init+0x12/0x12
[   21.664908]  [<ffffffff81de4fee>] acpi_cpufreq_init+0x51/0x134
[   21.664908]  [<ffffffff81dac003>] do_one_initcall+0x8c/0x138
[   21.664908]  [<ffffffff810a8b18>] ? parse_args+0x1f8/0x330
[   21.664908]  [<ffffffff81dac1c2>] kernel_init_freeable+0x113/0x18e
[   21.664908]  [<ffffffff81dab860>] ? do_early_param+0x88/0x88
[   21.664908]  [<ffffffff8187f390>] ? rest_init+0x150/0x150
[   21.664908]  [<ffffffff8187f399>] kernel_init+0x9/0x180
[   21.664908]  [<ffffffff818a0dba>] ret_from_fork+0x7a/0xb0
[   21.664908]  [<ffffffff8187f390>] ? rest_init+0x150/0x150
[   21.689085] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[   21.758668] Freeing unused kernel memory: 772K (ffffffff81dab000 - fffff=
fff81e6c000)
/bin/sh: /proc/self/fd/9: No such file or directory
plymouth-upstart-bridge: ply-event-loop.c:497: ply_event_loop_new: Assertio=
n `loop->epoll_fd >=3D 0' failed.
/bin/sh: /proc/self/fd/9: No such file or directory
/etc/lsb-base-logging.sh: line 5:   132 Aborted                 plymouth --=
ping > /dev/null 2>&1
 * Asking all remaining processes to terminate...      =20
killall5[135]: mount returned non-zero exit status
killall5[135]: /proc not mounted, failed to mount.
/etc/lsb-base-logging.sh: line 5:   137 Aborted                 plymouth --=
ping > /dev/null 2>&1

mount: proc has wrong device number or fs type proc not supported
killall5[143]: mount returned non-zero exit status
killall5[143]: /proc not mounted, failed to mount.
/etc/lsb-base-logging.sh: line 5:   153 Aborted                 plymouth --=
ping > /dev/null 2>&1
 * All processes ended within 1 seconds....      =20

/etc/rc6.d/S40umountfs: line 20: /proc/mounts: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
cat: /proc/1/maps: No such file or directory
umount: /var/run: not mounted
umount: /var/lock: not mounted
umount: /dev/shm: not mounted
 * Will now restart
[   44.618848] no ifx modem active;
[   44.647679] reboot: Restarting system
[   44.647839] reboot: machine restart
Elapsed time: 55
qemu-system-x86_64 -kernel /tmp//kernel/x86_64-randconfig-a06-0818/1e712b08=
18569846d6b926ecb6bf32b3dea73609/vmlinuz-3.11.0-rc5-next-20130816-05970-g1e=
712b0-19071 -append 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_timeout=3D10=
0 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_p=
rintk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,1=
15200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests=
/run-queue/kvm/x86_64-randconfig-a06-0818/next:master/.vmlinuz-1e712b081856=
9846d6b926ecb6bf32b3dea73609-20130818122400-2-ant branch=3Dnext/master noap=
ic nolapic nohz=3Doff BOOT_IMAGE=3D/kernel/x86_64-randconfig-a06-0818/1e712=
b0818569846d6b926ecb6bf32b3dea73609/vmlinuz-3.11.0-rc5-next-20130816-05970-=
g1e712b0'  -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz -m 256M -sm=
p 2 -net nic,vlan=3D0,macaddr=3D00:00:00:00:00:00,model=3Dvirtio -net user,=
vlan=3D0,hostfwd=3Dtcp::23167-:22 -net nic,vlan=3D1,model=3De1000 -net user=
,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -drive file=3D/fs/=
sdc1/disk0-ant-19071,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdc1/disk1-=
ant-19071,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdc1/disk2-ant-19071,m=
edia=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdc1/disk3-ant-19071,media=3Ddisk=
,if=3Dvirtio -drive file=3D/fs/sdc1/disk4-ant-19071,media=3Ddisk,if=3Dvirti=
o -drive file=3D/fs/sdc1/disk5-ant-19071,media=3Ddisk,if=3Dvirtio -pidfile =
/dev/shm/kboot/pid-ant-lkp-19071 -serial file:/dev/shm/kboot/serial-ant-lkp=
-19071 -daemonize -display none -monitor null=20

--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="bisect-1e712b0818569846d6b926ecb6bf32b3dea73609-x86_64-randconfig-a06-0818-BUG:-bad-unlock-balance-detected-93225.log"

git checkout 233035a7f291ea27aec280270bc05293da3b0e7c
Previous HEAD position was 1e712b0... Add linux-next specific files for 20130816
HEAD is now at 233035a... Merge remote-tracking branch 'aio/master'
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a06-0818/next:master:233035a7f291ea27aec280270bc05293da3b0e7c:bisect-usb
 TEST FAILURE
[   20.458920] 3.11.0-rc5-05578-g233035a #16 Not tainted
[   20.458920] -------------------------------------
[   20.458920] swapper/1 is trying to release lock (cpufreq_rwsem) at:
[   20.458920] [<ffffffff8164d582>] cpufreq_add_dev+0x232/0x360
[   20.458920] but there are no more locks to release!
[   20.458920] 
[   20.458920] other info that might help us debug this:
[   20.458920] 1 lock held by swapper/1:
[   20.458920]  #0:  (subsys mutex){+.+.+.}, at: [<ffffffff813e0224>] subsys_interface_register+0x54/0xf0
[   20.458920] 
[   20.458920] stack backtrace:
[   20.458920] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-rc5-05578-g233035a #16
[   20.458920]  ffffffff8164d582 ffff88000dc63ce8 ffffffff81884426 ffff88000dc63d10
[   20.458920]  ffffffff810c709c ffffffff81d63b10 ffff88000dc5a040 ffffffff8164d582
[   20.458920]  ffff88000dc63d88 ffffffff810cba96 ffffffff810c7f70 000000070dc63d68
[   20.458920] Call Trace:
[   20.458920]  [<ffffffff8164d582>] ? cpufreq_add_dev+0x232/0x360
[   20.458920]  [<ffffffff81884426>] dump_stack+0x19/0x1b
[   20.458920]  [<ffffffff810c709c>] print_unlock_imbalance_bug+0xec/0x100
[   20.458920]  [<ffffffff8164d582>] ? cpufreq_add_dev+0x232/0x360
[   20.458920]  [<ffffffff810cba96>] lock_release_non_nested+0x226/0x300
[   20.458920]  [<ffffffff810c7f70>] ? mark_held_locks+0xb0/0x130
[   20.458920]  [<ffffffff8112f1c9>] ? kfree+0xe9/0x140
[   20.458920]  [<ffffffff8164d582>] ? cpufreq_add_dev+0x232/0x360
[   20.458920]  [<ffffffff810cbbf8>] lock_release+0x88/0x1b0
[   20.458920]  [<ffffffff810ae14a>] up_read+0x1a/0x40
[   20.458920]  [<ffffffff8164d582>] cpufreq_add_dev+0x232/0x360
[   20.458920]  [<ffffffff813e0279>] subsys_interface_register+0xa9/0xf0
[   20.458920]  [<ffffffff8164eaa4>] cpufreq_register_driver+0x84/0x130
[   20.458920]  [<ffffffff81de1f42>] ? cpufreq_gov_dbs_init+0x12/0x12
[   20.458920]  [<ffffffff81de1f93>] acpi_cpufreq_init+0x51/0x134
[   20.458920]  [<ffffffff81da9003>] do_one_initcall+0x8c/0x138
[   20.458920]  [<ffffffff810a8688>] ? parse_args+0x1f8/0x330
[   20.458920]  [<ffffffff81da91c2>] kernel_init_freeable+0x113/0x18e
[   20.458920]  [<ffffffff81da8860>] ? do_early_param+0x88/0x88
[   20.458920]  [<ffffffff8187ca70>] ? rest_init+0x150/0x150
[   20.458920]  [<ffffffff8187ca79>] kernel_init+0x9/0x180
[   20.458920]  [<ffffffff8189e47a>] ret_from_fork+0x7a/0xb0
[   20.458920]  [<ffffffff8187ca70>] ? rest_init+0x150/0x150
[   20.482114] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[   20.553160] Freeing unused kernel memory: 776K (ffffffff81da8000 - ffffffff81e6a000)
/kernel/x86_64-randconfig-a06-0818/233035a7f291ea27aec280270bc05293da3b0e7c/dmesg-kvm-ant-2559-20130818130138-3.11.0-rc5-05578-g233035a-16
/kernel/x86_64-randconfig-a06-0818/233035a7f291ea27aec280270bc05293da3b0e7c/dmesg-kvm-ant-9274-20130818123530-3.11.0-rc5-05578-g233035a-16
/kernel/x86_64-randconfig-a06-0818/233035a7f291ea27aec280270bc05293da3b0e7c/dmesg-kvm-bay-14388-20130818123511-3.11.0-rc5-05578-g233035a-16
/kernel/x86_64-randconfig-a06-0818/233035a7f291ea27aec280270bc05293da3b0e7c/dmesg-kvm-bay-17400-20130818120054-3.11.0-rc5-05578-g233035a-16
/kernel/x86_64-randconfig-a06-0818/233035a7f291ea27aec280270bc05293da3b0e7c/dmesg-kvm-bay-17400-20130818120140-3.11.0-rc5-05578-g233035a-16
/kernel/x86_64-randconfig-a06-0818/233035a7f291ea27aec280270bc05293da3b0e7c/dmesg-kvm-roam-11415-20130818130139-3.11.0-rc5-05578-g233035a-16
/kernel/x86_64-randconfig-a06-0818/233035a7f291ea27aec280270bc05293da3b0e7c/dmesg-kvm-roam-8265-20130818123448-3.11.0-rc5-05578-g233035a-16
/kernel/x86_64-randconfig-a06-0818/233035a7f291ea27aec280270bc05293da3b0e7c/dmesg-kvm-roam-8265-20130818123508-3.11.0-rc5-05578-g233035a-16
/kernel/x86_64-randconfig-a06-0818/233035a7f291ea27aec280270bc05293da3b0e7c/dmesg-kvm-snb-12480-20130818123604--
/kernel/x86_64-randconfig-a06-0818/233035a7f291ea27aec280270bc05293da3b0e7c/dmesg-kvm-snb-19074-20130818123603-3.11.0-rc5-05578-g233035a-16
/kernel/x86_64-randconfig-a06-0818/233035a7f291ea27aec280270bc05293da3b0e7c/dmesg-kvm-snb-19074-20130818123622-3.11.0-rc5-05578-g233035a-16
/kernel/x86_64-randconfig-a06-0818/233035a7f291ea27aec280270bc05293da3b0e7c/dmesg-kvm-snb-20172-20130818130108-3.11.0-rc5-05578-g233035a-16
/kernel/x86_64-randconfig-a06-0818/233035a7f291ea27aec280270bc05293da3b0e7c/dmesg-kvm-snb-20172-20130818130127-3.11.0-rc5-05578-g233035a-16
/kernel/x86_64-randconfig-a06-0818/233035a7f291ea27aec280270bc05293da3b0e7c/dmesg-kvm-snb-20172-20130818130155-3.11.0-rc5-05578-g233035a-16
/kernel/x86_64-randconfig-a06-0818/233035a7f291ea27aec280270bc05293da3b0e7c/dmesg-kvm-snb-23413-20130818120334-3.11.0-rc5-05578-g233035a-16
/kernel/x86_64-randconfig-a06-0818/233035a7f291ea27aec280270bc05293da3b0e7c/dmesg-kvm-snb-30149-20130818130306--
/kernel/x86_64-randconfig-a06-0818/233035a7f291ea27aec280270bc05293da3b0e7c/dmesg-kvm-snb-55946-20130818123608--
/kernel/x86_64-randconfig-a06-0818/233035a7f291ea27aec280270bc05293da3b0e7c/dmesg-kvm-snb-55946-20130818123627--
/kernel/x86_64-randconfig-a06-0818/233035a7f291ea27aec280270bc05293da3b0e7c/dmesg-kvm-snb-6056-20130818130252-3.11.0-rc5-03189-gb9cf00c-18
/kernel/x86_64-randconfig-a06-0818/233035a7f291ea27aec280270bc05293da3b0e7c/dmesg-kvm-snb-62567-20130818130249-3.11.0-rc5-03189-gb9cf00c-18
/kernel/x86_64-randconfig-a06-0818/233035a7f291ea27aec280270bc05293da3b0e7c/dmesg-kvm-snb-9971-20130818130241-3.11.0-rc5-05578-g233035a-16

bisect: bad commit 233035a7f291ea27aec280270bc05293da3b0e7c
git checkout v3.10
Previous HEAD position was 233035a... Merge remote-tracking branch 'aio/master'
HEAD is now at 8bb495e... Linux 3.10
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a06-0818/next:master:8bb495e3f02401ee6f76d1b1d77f3ac9f079e376:bisect-usb

2013-08-20-17:58:12 8bb495e3f02401ee6f76d1b1d77f3ac9f079e376 compiling
286 real  1102 user  105 sys  421.82% cpu 	x86_64-randconfig-a06-0818

2013-08-20-18:03:30 detecting boot state 3.10.0.	1....	2	4....	5	6.....	8.	9	10.	11.	12..	13.............	14	16.	18..	23	25	30	43	54	58..	60 SUCCESS

bisect: good commit v3.10
git bisect start 233035a7f291ea27aec280270bc05293da3b0e7c v3.10 --
Previous HEAD position was 8bb495e... Linux 3.10
HEAD is now at c1be5a5... Linux 3.9
Bisecting: 8400 revisions left to test after this (roughly 13 steps)
[496322bc91e35007ed754184dcd447a02b6dd685] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
git bisect run /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a06-0818/next:master:496322bc91e35007ed754184dcd447a02b6dd685:bisect-usb

2013-08-20-18:32:58 496322bc91e35007ed754184dcd447a02b6dd685 compiling
214 real  1129 user  102 sys  575.34% cpu 	x86_64-randconfig-a06-0818

2013-08-20-18:36:44 detecting boot state 3.10.0-08587-g496322b.....	1	2.....	3	5.....	7......	8.....	9.....	10......	11	12	13	14..........	15	16........	18..............	19...	20.	21.	22...	23.....	24..	25..	27.......	28.	29.	32.......	33...	35....	36	37	38	40	43	48	52	54	55...	56.	57..	58.....	59	60 SUCCESS

Bisecting: 4455 revisions left to test after this (roughly 12 steps)
[1be61c8552a7fb4b1f3229b25bfaa2f1ae834730] Merge remote-tracking branch 'slave-dma/next'
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a06-0818/next:master:1be61c8552a7fb4b1f3229b25bfaa2f1ae834730:bisect-usb

2013-08-20-19:57:50 1be61c8552a7fb4b1f3229b25bfaa2f1ae834730 compiling
193 real  1152 user  114 sys  656.24% cpu 	x86_64-randconfig-a06-0818

2013-08-20-20:01:19 detecting boot state 3.11.0-rc5-01738-g1be61c8...... TEST FAILURE
[    3.702616] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eeprom: no busid passed, refusing all cards
[    3.704007] fmc fake-design-for-testing-f001: Driver has no ID: matches all
[    3.704987] BUG: scheduling while atomic: swapper/1/0x00000002
[    3.704987] 4 locks held by swapper/1:
[    3.704987]  #0:  (&__lockdep_no_validate__){......}, at: [<ffffffff813e0aa3>] __driver_attach+0x43/0x90
[    3.704987]  #1:  (&__lockdep_no_validate__){......}, at: [<ffffffff813e0ab1>] __driver_attach+0x51/0x90
[    3.704987]  #2:  (fc_lock){+.+.+.}, at: [<ffffffff8174333c>] fc_probe+0x8c/0x140
[    3.704987]  #3:  (misc_mtx){+.+.+.}, at: [<ffffffff813c8614>] misc_register+0x24/0x120
[    3.704987] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-rc5-01738-g1be61c8 #324
[    3.704987]  7fffffffffffffff ffff88000dc619e0 ffffffff81882ee7 ffff88000dc619f8
[    3.704987]  ffffffff81880116 7fffffffffffffff ffff88000dc61a58 ffffffff8189a133
[    3.704987]  ffff88000dc58610 ffff88000dc58040 ffff88000dc61fd8 ffff88000dc61fd8
[    3.704987] Call Trace:
[    3.704987]  [<ffffffff81882ee7>] dump_stack+0x19/0x1b
[    3.704987]  [<ffffffff81880116>] __schedule_bug+0x5b/0x6a
[    3.704987]  [<ffffffff8189a133>] __schedule+0x563/0x5d0
[    3.704987]  [<ffffffff8189a1b4>] schedule+0x14/0x20
[    3.704987]  [<ffffffff81897225>] schedule_timeout+0x145/0x1a0
[    3.704987]  [<ffffffff810c7f50>] ? mark_held_locks+0xb0/0x130
[    3.704987]  [<ffffffff8189bc37>] ? _raw_spin_unlock_irq+0x27/0x40
[    3.704987]  [<ffffffff810c80cd>] ? trace_hardirqs_on_caller+0xfd/0x1c0
[    3.704987]  [<ffffffff8189a55c>] wait_for_completion+0xcc/0x100
[    3.704987]  [<ffffffff810b3820>] ? try_to_wake_up+0x160/0x160
[    3.704987]  [<ffffffff813e4e5b>] devtmpfs_create_node+0x10b/0x140
[    3.704987]  [<ffffffff813dcdde>] device_add+0x23e/0x720
[    3.724814]  [<ffffffff810ab046>] ? __init_waitqueue_head+0x36/0x50
[    3.725646]  [<ffffffff813dd398>] device_create_groups_vargs+0xd8/0x100
[    3.726534]  [<ffffffff813ddd6c>] device_create+0x3c/0x40
[    3.727266]  [<ffffffff813c86b6>] misc_register+0xc6/0x120
[    3.728002]  [<ffffffff81743345>] fc_probe+0x95/0x140
[    3.728670]  [<ffffffff81741172>] fmc_probe+0x12/0x20
[    3.729358]  [<ffffffff813e0880>] driver_probe_device+0x70/0x210
[    3.730170]  [<ffffffff813e0aeb>] __driver_attach+0x8b/0x90
[    3.730921]  [<ffffffff813e0a60>] ? __device_attach+0x40/0x40
[    3.731670]  [<ffffffff813decc3>] bus_for_each_dev+0x63/0xa0
[    3.732420]  [<ffffffff813e0799>] driver_attach+0x19/0x20
[    3.733151]  [<ffffffff813df788>] bus_add_driver+0x1d8/0x270
[    3.733938]  [<ffffffff81743270>] ? fc_read+0xa0/0xa0
[    3.734611]  [<ffffffff813e125f>] driver_register+0x6f/0x150
[    3.735380]  [<ffffffff81743270>] ? fc_read+0xa0/0xa0
[    3.736060]  [<ffffffff81741310>] fmc_driver_register+0x30/0x40
[    3.736845]  [<ffffffff81743280>] fc_init+0x10/0x20
[    3.737499]  [<ffffffff81da3001>] do_one_initcall+0x8c/0x138
[    3.738261]  [<ffffffff810a8658>] ? parse_args+0x1f8/0x330
[    3.739001]  [<ffffffff81da31c0>] kernel_init_freeable+0x113/0x18e
[    3.739826]  [<ffffffff81da285e>] ? do_early_param+0x88/0x88
[    3.740581]  [<ffffffff8187b530>] ? rest_init+0x150/0x150
[    3.741308]  [<ffffffff8187b539>] kernel_init+0x9/0x180
[    3.742015]  [<ffffffff8189ceba>] ret_from_fork+0x7a/0xb0
[    3.742734]  [<ffffffff8187b530>] ? rest_init+0x150/0x150
[    3.743514] fmc_chardev fake-design-for-testing-f001: Created misc device "fake-design-for-testing-f001"
[    3.744984] Audio Excel DSP 16 init driver Copyright (C) Riccardo Facchetti 1995-98
/kernel/x86_64-randconfig-a06-0818/1be61c8552a7fb4b1f3229b25bfaa2f1ae834730/dmesg-kvm-roam-11919-20130820200323-3.11.0-rc5-01738-g1be61c8-324

Bisecting: 1973 revisions left to test after this (roughly 11 steps)
[549f3a1218ba18fcde11ef0e22b07e6365645788] Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a06-0818/next:master:549f3a1218ba18fcde11ef0e22b07e6365645788:bisect-usb

2013-08-20-20:04:25 549f3a1218ba18fcde11ef0e22b07e6365645788 compiling
175 real  1153 user  116 sys  723.43% cpu 	x86_64-randconfig-a06-0818

2013-08-20-20:07:31 detecting boot state 3.11.0-rc2-00144-g549f3a1......	2.	4	8	12	17	20	24	34	44	48	55	60 SUCCESS

Bisecting: 984 revisions left to test after this (roughly 10 steps)
[3227db39cc40b6d933ef8629094feb9ce1a0492e] Merge remote-tracking branch 'net/master'
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a06-0818/next:master:3227db39cc40b6d933ef8629094feb9ce1a0492e:bisect-usb

2013-08-20-20:17:04 3227db39cc40b6d933ef8629094feb9ce1a0492e compiling
182 real  1138 user  111 sys  686.46% cpu 	x86_64-randconfig-a06-0818

2013-08-20-20:20:16 detecting boot state 3.11.0-rc5-00753-g3227db3.	4	9	17	36	39	45	46	48	49	50	52	57	60 SUCCESS

Bisecting: 509 revisions left to test after this (roughly 9 steps)
[978ff9279fad8d3eeef71062b268f0da429d619a] Merge remote-tracking branch 'vfs/for-next'
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a06-0818/next:master:978ff9279fad8d3eeef71062b268f0da429d619a:bisect-usb

2013-08-20-20:27:19 978ff9279fad8d3eeef71062b268f0da429d619a compiling
174 real  1126 user  103 sys  703.81% cpu 	x86_64-randconfig-a06-0818

2013-08-20-20:30:26 detecting boot state 3.11.0-rc5-01228-g978ff92	6	22	48	60 SUCCESS

Bisecting: 254 revisions left to test after this (roughly 8 steps)
[164aa191a5625d5fe37e01cfc13849f87910c676] Merge remote-tracking branch 'libata/for-next'
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a06-0818/next:master:164aa191a5625d5fe37e01cfc13849f87910c676:bisect-usb

2013-08-20-20:32:28 164aa191a5625d5fe37e01cfc13849f87910c676 compiling
166 real  1116 user  102 sys  730.32% cpu 	x86_64-randconfig-a06-0818

2013-08-20-20:35:31 detecting boot state 3.11.0-rc5-01483-g164aa19.	1.	12.........	13..	14.........	15	16	17	20	21	22	23.	24	39	52	56	59..	60 SUCCESS

Bisecting: 125 revisions left to test after this (roughly 7 steps)
[84a55797049fbbb7d8da9fe3e664c7dc96601fa5] Merge branch 'pm-cpuidle'
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a06-0818/next:master:84a55797049fbbb7d8da9fe3e664c7dc96601fa5:bisect-usb

2013-08-20-20:56:34 84a55797049fbbb7d8da9fe3e664c7dc96601fa5 compiling
187 real  1145 user  106 sys  667.59% cpu 	x86_64-randconfig-a06-0818

2013-08-20-20:59:52 detecting boot state 3.11.0-rc5-00745-g84a5579..	1	2	3..............	4.	5.	6.	7	10..	13	16	26	45	50	57	60 SUCCESS

Bisecting: 64 revisions left to test after this (roughly 6 steps)
[832a373ea2343d616ec769e7939f7eb6810713aa] Merge branch 'fixes-next' into linux-next
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a06-0818/next:master:832a373ea2343d616ec769e7939f7eb6810713aa:bisect-usb

2013-08-20-21:17:54 832a373ea2343d616ec769e7939f7eb6810713aa compiling
173 real  1130 user  106 sys  712.53% cpu 	x86_64-randconfig-a06-0818

2013-08-20-21:20:57 detecting boot state 3.11.0-rc5-00806-g832a373... TEST FAILURE
[    5.156674] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eeprom: no busid passed, refusing all cards
[    5.159111] fmc fake-design-for-testing-f001: Driver has no ID: matches all
[    5.160889] BUG: scheduling while atomic: swapper/1/0x00000002
[    5.162295] 4 locks held by swapper/1:
[    5.163196]  #0:  (&__lockdep_no_validate__){......}, at: [<ffffffff813e0213>] __driver_attach+0x43/0x90
[    5.174799]  #1:  (&__lockdep_no_validate__){......}, at: [<ffffffff813e0221>] __driver_attach+0x51/0x90
[    5.177216]  #2:  (fc_lock){+.+.+.}, at: [<ffffffff8174227c>] fc_probe+0x8c/0x140
[    5.179162]  #3:  (misc_mtx){+.+.+.}, at: [<ffffffff813c7d84>] misc_register+0x24/0x120
[    5.181227] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-rc5-00806-g832a373 #330
[    5.183027]  7fffffffffffffff ffff88000dc619e0 ffffffff81881d27 ffff88000dc619f8
[    5.184023]  ffffffff8187ef56 7fffffffffffffff ffff88000dc61a58 ffffffff81898f63
[    5.184023]  ffff88000dc58610 ffff88000dc58040 ffff88000dc61fd8 ffff88000dc61fd8
[    5.184023] Call Trace:
[    5.184023]  [<ffffffff81881d27>] dump_stack+0x19/0x1b
[    5.184023]  [<ffffffff8187ef56>] __schedule_bug+0x5b/0x6a
[    5.200904]  [<ffffffff81898f63>] __schedule+0x563/0x5d0
[    5.202186]  [<ffffffff81898fe4>] schedule+0x14/0x20
[    5.203181]  [<ffffffff81896055>] schedule_timeout+0x145/0x1a0
[    5.203181]  [<ffffffff810c7ec0>] ? mark_held_locks+0xb0/0x130
[    5.203181]  [<ffffffff8189aa67>] ? _raw_spin_unlock_irq+0x27/0x40
[    5.203181]  [<ffffffff810c803d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
[    5.203181]  [<ffffffff8189938c>] wait_for_completion+0xcc/0x100
[    5.219854]  [<ffffffff810b3860>] ? try_to_wake_up+0x160/0x160
[    5.221254]  [<ffffffff813e45cb>] devtmpfs_create_node+0x10b/0x140
[    5.222247]  [<ffffffff813dc54e>] device_add+0x23e/0x720
[    5.222247]  [<ffffffff810ab086>] ? __init_waitqueue_head+0x36/0x50
[    5.222247]  [<ffffffff813dcb08>] device_create_groups_vargs+0xd8/0x100
[    5.222247]  [<ffffffff813dd4dc>] device_create+0x3c/0x40
[    5.222247]  [<ffffffff813c7e26>] misc_register+0xc6/0x120
[    5.222247]  [<ffffffff81742285>] fc_probe+0x95/0x140
[    5.239975]  [<ffffffff817400b2>] fmc_probe+0x12/0x20
[    5.241196]  [<ffffffff813dfff0>] driver_probe_device+0x70/0x210
[    5.242635]  [<ffffffff813e025b>] __driver_attach+0x8b/0x90
[    5.243980]  [<ffffffff813e01d0>] ? __device_attach+0x40/0x40
[    5.244975]  [<ffffffff813de433>] bus_for_each_dev+0x63/0xa0
[    5.244975]  [<ffffffff813dff09>] driver_attach+0x19/0x20
[    5.244975]  [<ffffffff813deef8>] bus_add_driver+0x1d8/0x270
[    5.244975]  [<ffffffff817421b0>] ? fc_read+0xa0/0xa0
[    5.244975]  [<ffffffff813e09cf>] driver_register+0x6f/0x150
[    5.244975]  [<ffffffff817421b0>] ? fc_read+0xa0/0xa0
[    5.244975]  [<ffffffff81740250>] fmc_driver_register+0x30/0x40
[    5.244975]  [<ffffffff817421c0>] fc_init+0x10/0x20
[    5.273962]  [<ffffffff81da5001>] do_one_initcall+0x8c/0x138
[    5.275317]  [<ffffffff810a8698>] ? parse_args+0x1f8/0x330
[    5.276632]  [<ffffffff81da51c0>] kernel_init_freeable+0x113/0x18e
[    5.278127]  [<ffffffff81da485e>] ? do_early_param+0x88/0x88
[    5.279120]  [<ffffffff8187a320>] ? rest_init+0x150/0x150
[    5.279120]  [<ffffffff8187a329>] kernel_init+0x9/0x180
[    5.279120]  [<ffffffff8189bcfa>] ret_from_fork+0x7a/0xb0
[    5.283289]  [<ffffffff8187a320>] ? rest_init+0x150/0x150
[    5.294006] fmc_chardev fake-design-for-testing-f001: Created misc device "fake-design-for-testing-f001"
[    5.296572] Audio Excel DSP 16 init driver Copyright (C) Riccardo Facchetti 1995-98
/kernel/x86_64-randconfig-a06-0818/832a373ea2343d616ec769e7939f7eb6810713aa/dmesg-kvm-inn-7463-20130820212126-3.11.0-rc6-01329-ga18cf87-37
/kernel/x86_64-randconfig-a06-0818/832a373ea2343d616ec769e7939f7eb6810713aa/dmesg-kvm-inn-7589-20130820212119-3.11.0-rc6-00033-g5222d3f-70
/kernel/x86_64-randconfig-a06-0818/832a373ea2343d616ec769e7939f7eb6810713aa/dmesg-kvm-inn-8156-20130820212121-3.11.0-rc5-00173-g41c8bd1-36
/kernel/x86_64-randconfig-a06-0818/832a373ea2343d616ec769e7939f7eb6810713aa/dmesg-kvm-inn-8723-20130820212119-3.11.0-rc6-wl-68459-gbd52fa9-40
/kernel/x86_64-randconfig-a06-0818/832a373ea2343d616ec769e7939f7eb6810713aa/dmesg-kvm-bens-3607-20130820211754-3.11.0-rc5-00806-g832a373-330
/kernel/x86_64-randconfig-a06-0818/832a373ea2343d616ec769e7939f7eb6810713aa/dmesg-kvm-inn-10178-20130820212122-3.11.0-rc5-00173-g41c8bd1-36
/kernel/x86_64-randconfig-a06-0818/832a373ea2343d616ec769e7939f7eb6810713aa/dmesg-kvm-inn-10304-20130820212115-3.11.0-rc6-00033-g5222d3f-55

Bisecting: 29 revisions left to test after this (roughly 5 steps)
[b678c5d3074d55cb49d7cc96875d04bd47ae847e] Merge branch 'pm-sleep' into linux-next
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a06-0818/next:master:b678c5d3074d55cb49d7cc96875d04bd47ae847e:bisect-usb

2013-08-20-21:22:31 b678c5d3074d55cb49d7cc96875d04bd47ae847e compiling
170 real  1121 user  103 sys  716.82% cpu 	x86_64-randconfig-a06-0818

2013-08-20-21:25:30 detecting boot state 3.11.0-rc5-00776-gb678c5d...... TEST FAILURE
[    3.982411] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eeprom: no busid passed, refusing all cards
[    3.984612] fmc fake-design-for-testing-f001: Driver has no ID: matches all
[    3.986319] BUG: scheduling while atomic: swapper/1/0x00000002
[    3.987601] 4 locks held by swapper/1:
[    3.988386]  #0:  (&__lockdep_no_validate__){......}, at: [<ffffffff813e0213>] __driver_attach+0x43/0x90
[    3.990878]  #1:  (&__lockdep_no_validate__){......}, at: [<ffffffff813e0221>] __driver_attach+0x51/0x90
[    3.993047]  #2:  (fc_lock){+.+.+.}, at: [<ffffffff8174227c>] fc_probe+0x8c/0x140
[    3.994865]  #3:  (misc_mtx){+.+.+.}, at: [<ffffffff813c7d84>] misc_register+0x24/0x120
[    3.996732] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-rc5-00776-gb678c5d #331
[    3.998652]  7fffffffffffffff ffff88000dc619e0 ffffffff81881d27 ffff88000dc619f8
[    3.999648]  ffffffff8187ef56 7fffffffffffffff ffff88000dc61a58 ffffffff81898f63
[    4.001933]  ffff88000dc58610 ffff88000dc58040 ffff88000dc61fd8 ffff88000dc61fd8
[    4.001933] Call Trace:
[    4.001933]  [<ffffffff81881d27>] dump_stack+0x19/0x1b
[    4.005702]  [<ffffffff8187ef56>] __schedule_bug+0x5b/0x6a
[    4.006694]  [<ffffffff81898f63>] __schedule+0x563/0x5d0
[    4.006694]  [<ffffffff81898fe4>] schedule+0x14/0x20
[    4.006694]  [<ffffffff81896055>] schedule_timeout+0x145/0x1a0
[    4.006694]  [<ffffffff810c7eb0>] ? mark_held_locks+0xb0/0x130
[    4.006694]  [<ffffffff8189aa67>] ? _raw_spin_unlock_irq+0x27/0x40
[    4.013557]  [<ffffffff810c802d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
[    4.014988]  [<ffffffff8189938c>] wait_for_completion+0xcc/0x100
[    4.015983]  [<ffffffff810b3860>] ? try_to_wake_up+0x160/0x160
[    4.017596]  [<ffffffff813e45cb>] devtmpfs_create_node+0x10b/0x140
[    4.018929]  [<ffffffff813dc54e>] device_add+0x23e/0x720
[    4.019924]  [<ffffffff810ab086>] ? __init_waitqueue_head+0x36/0x50
[    4.021658]  [<ffffffff813dcb08>] device_create_groups_vargs+0xd8/0x100
[    4.022653]  [<ffffffff813dd4dc>] device_create+0x3c/0x40
[    4.022653]  [<ffffffff813c7e26>] misc_register+0xc6/0x120
[    4.025463]  [<ffffffff81742285>] fc_probe+0x95/0x140
[    4.026545]  [<ffffffff817400b2>] fmc_probe+0x12/0x20
[    4.027652]  [<ffffffff813dfff0>] driver_probe_device+0x70/0x210
[    4.028647]  [<ffffffff813e025b>] __driver_attach+0x8b/0x90
[    4.030380]  [<ffffffff813e01d0>] ? __device_attach+0x40/0x40
[    4.031637]  [<ffffffff813de433>] bus_for_each_dev+0x63/0xa0
[    4.032630]  [<ffffffff813dff09>] driver_attach+0x19/0x20
[    4.032630]  [<ffffffff813deef8>] bus_add_driver+0x1d8/0x270
[    4.032630]  [<ffffffff817421b0>] ? fc_read+0xa0/0xa0
[    4.032630]  [<ffffffff813e09cf>] driver_register+0x6f/0x150
[    4.037836]  [<ffffffff817421b0>] ? fc_read+0xa0/0xa0
[    4.038830]  [<ffffffff81740250>] fmc_driver_register+0x30/0x40
[    4.040173]  [<ffffffff817421c0>] fc_init+0x10/0x20
[    4.041168]  [<ffffffff81da5001>] do_one_initcall+0x8c/0x138
[    4.041168]  [<ffffffff810a8698>] ? parse_args+0x1f8/0x330
[    4.041168]  [<ffffffff81da51c0>] kernel_init_freeable+0x113/0x18e
[    4.041168]  [<ffffffff81da485e>] ? do_early_param+0x88/0x88
[    4.041168]  [<ffffffff8187a320>] ? rest_init+0x150/0x150
[    4.041168]  [<ffffffff8187a329>] kernel_init+0x9/0x180
[    4.041168]  [<ffffffff8189bcfa>] ret_from_fork+0x7a/0xb0
[    4.041168]  [<ffffffff8187a320>] ? rest_init+0x150/0x150
[    4.051393] fmc_chardev fake-design-for-testing-f001: Created misc device "fake-design-for-testing-f001"
[    4.053948] Audio Excel DSP 16 init driver Copyright (C) Riccardo Facchetti 1995-98
/kernel/x86_64-randconfig-a06-0818/b678c5d3074d55cb49d7cc96875d04bd47ae847e/dmesg-kvm-bens-3773-20130820212317-3.11.0-rc5-00776-gb678c5d-331

Bisecting: 14 revisions left to test after this (roughly 4 steps)
[1133bfa6dcf034639486982629d29472737d5e96] Merge branch 'pm-cpufreq-ondemand' into pm-cpufreq
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a06-0818/next:master:1133bfa6dcf034639486982629d29472737d5e96:bisect-usb

2013-08-20-21:28:33 1133bfa6dcf034639486982629d29472737d5e96 compiling
169 real  1125 user  106 sys  727.01% cpu 	x86_64-randconfig-a06-0818

2013-08-20-21:31:31 detecting boot state 3.11.0-rc4-00411-g1133bfa.....	2..	3	5.	6	8	17	32	48	54	59	60 SUCCESS

Bisecting: 7 revisions left to test after this (roughly 3 steps)
[fe492f3f0332e23cc6ca4913e5a2ed78e1888902] cpufreq: Fix broken usage of governor->owner's refcount
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a06-0818/next:master:fe492f3f0332e23cc6ca4913e5a2ed78e1888902:bisect-usb

2013-08-20-21:41:02 fe492f3f0332e23cc6ca4913e5a2ed78e1888902 compiling
159 real  1111 user  101 sys  758.67% cpu 	x86_64-randconfig-a06-0818

2013-08-20-21:43:51 detecting boot state 3.11.0-rc4-00418-gfe492f3.	2	3	15	39	60 SUCCESS

Bisecting: 4 revisions left to test after this (roughly 2 steps)
[3de9bdeb28638e164d1f0eb38dd68e3f5d2ac95c] cpufreq: improve error checking on return values of __cpufreq_governor()
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a06-0818/next:master:3de9bdeb28638e164d1f0eb38dd68e3f5d2ac95c:bisect-usb

2013-08-20-21:46:52 3de9bdeb28638e164d1f0eb38dd68e3f5d2ac95c compiling
169 real  1114 user  99 sys  714.28% cpu 	x86_64-randconfig-a06-0818

2013-08-20-21:49:52 detecting boot state 3.11.0-rc4-00421-g3de9bde....... TEST FAILURE
[    3.817504] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eeprom: no busid passed, refusing all cards
[    3.819272] fmc fake-design-for-testing-f001: Driver has no ID: matches all
[    3.820549] BUG: scheduling while atomic: swapper/1/0x00000002
[    3.821556] 4 locks held by swapper/1:
[    3.822219]  #0:  (&__lockdep_no_validate__){......}, at: [<ffffffff813e03a3>] __driver_attach+0x43/0x90
[    3.823998]  #1:  (&__lockdep_no_validate__){......}, at: [<ffffffff813e03b1>] __driver_attach+0x51/0x90
[    3.825738]  #2:  (fc_lock){+.+.+.}, at: [<ffffffff817422dc>] fc_probe+0x8c/0x140
[    3.827172]  #3:  (misc_mtx){+.+.+.}, at: [<ffffffff813c7f54>] misc_register+0x24/0x120
[    3.828679] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-rc4-00421-g3de9bde #334
[    3.829978]  7fffffffffffffff ffff88000dc619e0 ffffffff81881d87 ffff88000dc619f8
[    3.830974]  ffffffff8187efb6 7fffffffffffffff ffff88000dc61a58 ffffffff81899043
[    3.830974]  ffff88000dc58610 ffff88000dc58040 ffff88000dc61fd8 ffff88000dc61fd8
[    3.830974] Call Trace:
[    3.830974]  [<ffffffff81881d87>] dump_stack+0x19/0x1b
[    3.835409]  [<ffffffff8187efb6>] __schedule_bug+0x5b/0x6a
[    3.836369]  [<ffffffff81899043>] __schedule+0x563/0x5d0
[    3.837298]  [<ffffffff818990c4>] schedule+0x14/0x20
[    3.838166]  [<ffffffff81896135>] schedule_timeout+0x145/0x1a0
[    3.839184]  [<ffffffff810c7e00>] ? mark_held_locks+0xb0/0x130
[    3.840193]  [<ffffffff8189ab47>] ? _raw_spin_unlock_irq+0x27/0x40
[    3.841257]  [<ffffffff810c7f7d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
[    3.842393]  [<ffffffff8189946c>] wait_for_completion+0xcc/0x100
[    3.843432]  [<ffffffff810b37b0>] ? try_to_wake_up+0x160/0x160
[    3.844440]  [<ffffffff813e475b>] devtmpfs_create_node+0x10b/0x140
[    3.845507]  [<ffffffff813dc6de>] device_add+0x23e/0x720
[    3.846429]  [<ffffffff810aafd6>] ? __init_waitqueue_head+0x36/0x50
[    3.847510]  [<ffffffff813dcc98>] device_create_groups_vargs+0xd8/0x100
[    3.848659]  [<ffffffff813dd66c>] device_create+0x3c/0x40
[    3.849590]  [<ffffffff813c7ff6>] misc_register+0xc6/0x120
[    3.850541]  [<ffffffff817422e5>] fc_probe+0x95/0x140
[    3.851420]  [<ffffffff81740112>] fmc_probe+0x12/0x20
[    3.852299]  [<ffffffff813e0180>] driver_probe_device+0x70/0x210
[    3.853336]  [<ffffffff813e03eb>] __driver_attach+0x8b/0x90
[    3.854304]  [<ffffffff813e0360>] ? __device_attach+0x40/0x40
[    3.855296]  [<ffffffff813de5c3>] bus_for_each_dev+0x63/0xa0
[    3.856272]  [<ffffffff813e0099>] driver_attach+0x19/0x20
[    3.857205]  [<ffffffff813df088>] bus_add_driver+0x1d8/0x270
[    3.858179]  [<ffffffff81742210>] ? fc_read+0xa0/0xa0
[    3.859062]  [<ffffffff813e0b5f>] driver_register+0x6f/0x150
[    3.860038]  [<ffffffff81742210>] ? fc_read+0xa0/0xa0
[    3.860914]  [<ffffffff817402b0>] fmc_driver_register+0x30/0x40
[    3.861936]  [<ffffffff81742220>] fc_init+0x10/0x20
[    3.862790]  [<ffffffff81da5001>] do_one_initcall+0x8c/0x138
[    3.863771]  [<ffffffff810a85e8>] ? parse_args+0x1f8/0x330
[    3.864723]  [<ffffffff81da51c0>] kernel_init_freeable+0x113/0x18e
[    3.865789]  [<ffffffff81da485e>] ? do_early_param+0x88/0x88
[    3.866770]  [<ffffffff8187a380>] ? rest_init+0x150/0x150
[    3.867707]  [<ffffffff8187a389>] kernel_init+0x9/0x180
[    3.868617]  [<ffffffff8189bdfa>] ret_from_fork+0x7a/0xb0
[    3.869546]  [<ffffffff8187a380>] ? rest_init+0x150/0x150
[    3.870541] fmc_chardev fake-design-for-testing-f001: Created misc device "fake-design-for-testing-f001"
[    3.872367] Audio Excel DSP 16 init driver Copyright (C) Riccardo Facchetti 1995-98
/kernel/x86_64-randconfig-a06-0818/3de9bdeb28638e164d1f0eb38dd68e3f5d2ac95c/dmesg-kvm-stoakley-7509-20130820215320-3.11.0-rc4-00421-g3de9bde-334

Bisecting: 0 revisions left to test after this (roughly 1 step)
[adc97d6a735dbb1e94cb4f1bf0b55f258b349941] cpufreq: Drop the owner field from struct cpufreq_driver
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a06-0818/next:master:adc97d6a735dbb1e94cb4f1bf0b55f258b349941:bisect-usb

2013-08-20-21:53:26 adc97d6a735dbb1e94cb4f1bf0b55f258b349941 compiling
164 real  1130 user  103 sys  752.50% cpu 	x86_64-randconfig-a06-0818

2013-08-20-21:56:18 detecting boot state 3.11.0-rc4-00420-gadc97d6.. TEST FAILURE
[    3.443178] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eeprom: no busid passed, refusing all cards
[    3.444693] fmc fake-design-for-testing-f001: Driver has no ID: matches all
[    3.445676] BUG: scheduling while atomic: swapper/1/0x00000002
[    3.445676] 4 locks held by swapper/1:
[    3.445676]  #0:  (&__lockdep_no_validate__){......}, at: [<ffffffff813e03a3>] __driver_attach+0x43/0x90
[    3.445676]  #1:  (&__lockdep_no_validate__){......}, at: [<ffffffff813e03b1>] __driver_attach+0x51/0x90
[    3.445676]  #2:  (fc_lock){+.+.+.}, at: [<ffffffff8174225c>] fc_probe+0x8c/0x140
[    3.451417]  #3:  (misc_mtx){+.+.+.}, at: [<ffffffff813c7f54>] misc_register+0x24/0x120
[    3.452712] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-rc4-00420-gadc97d6 #335
[    3.453814]  7fffffffffffffff ffff88000dc619e0 ffffffff81881d07 ffff88000dc619f8
[    3.455003]  ffffffff8187ef36 7fffffffffffffff ffff88000dc61a58 ffffffff81898fc3
[    3.456184]  ffff88000dc58610 ffff88000dc58040 ffff88000dc61fd8 ffff88000dc61fd8
[    3.457373] Call Trace:
[    3.457754]  [<ffffffff81881d07>] dump_stack+0x19/0x1b
[    3.458535]  [<ffffffff8187ef36>] __schedule_bug+0x5b/0x6a
[    3.459362]  [<ffffffff81898fc3>] __schedule+0x563/0x5d0
[    3.460163]  [<ffffffff81899044>] schedule+0x14/0x20
[    3.460907]  [<ffffffff818960b5>] schedule_timeout+0x145/0x1a0
[    3.461653]  [<ffffffff810c7e00>] ? mark_held_locks+0xb0/0x130
[    3.462537]  [<ffffffff8189aac7>] ? _raw_spin_unlock_irq+0x27/0x40
[    3.463471]  [<ffffffff810c7f7d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
[    3.464462]  [<ffffffff818993ec>] wait_for_completion+0xcc/0x100
[    3.465343]  [<ffffffff810b37b0>] ? try_to_wake_up+0x160/0x160
[    3.466228]  [<ffffffff813e475b>] devtmpfs_create_node+0x10b/0x140
[    3.467149]  [<ffffffff813dc6de>] device_add+0x23e/0x720
[    3.467955]  [<ffffffff810aafd6>] ? __init_waitqueue_head+0x36/0x50
[    3.468901]  [<ffffffff813dcc98>] device_create_groups_vargs+0xd8/0x100
[    3.469892]  [<ffffffff813dd66c>] device_create+0x3c/0x40
[    3.470711]  [<ffffffff813c7ff6>] misc_register+0xc6/0x120
[    3.471543]  [<ffffffff81742265>] fc_probe+0x95/0x140
[    3.472314]  [<ffffffff81740092>] fmc_probe+0x12/0x20
[    3.473077]  [<ffffffff813e0180>] driver_probe_device+0x70/0x210
[    3.473987]  [<ffffffff813e03eb>] __driver_attach+0x8b/0x90
[    3.474834]  [<ffffffff813e0360>] ? __device_attach+0x40/0x40
[    3.475705]  [<ffffffff813de5c3>] bus_for_each_dev+0x63/0xa0
[    3.476563]  [<ffffffff813e0099>] driver_attach+0x19/0x20
[    3.477385]  [<ffffffff813df088>] bus_add_driver+0x1d8/0x270
[    3.478241]  [<ffffffff81742190>] ? fc_read+0xa0/0xa0
[    3.479003]  [<ffffffff813e0b5f>] driver_register+0x6f/0x150
[    3.479868]  [<ffffffff81742190>] ? fc_read+0xa0/0xa0
[    3.480640]  [<ffffffff81740230>] fmc_driver_register+0x30/0x40
[    3.481534]  [<ffffffff817421a0>] fc_init+0x10/0x20
[    3.482273]  [<ffffffff81da5001>] do_one_initcall+0x8c/0x138
[    3.483119]  [<ffffffff810a85e8>] ? parse_args+0x1f8/0x330
[    3.483950]  [<ffffffff81da51c0>] kernel_init_freeable+0x113/0x18e
[    3.484880]  [<ffffffff81da485e>] ? do_early_param+0x88/0x88
[    3.485744]  [<ffffffff8187a300>] ? rest_init+0x150/0x150
[    3.486565]  [<ffffffff8187a309>] kernel_init+0x9/0x180
[    3.487366]  [<ffffffff8189bd7a>] ret_from_fork+0x7a/0xb0
[    3.488175]  [<ffffffff8187a300>] ? rest_init+0x150/0x150
[    3.489037] fmc_chardev fake-design-for-testing-f001: Created misc device "fake-design-for-testing-f001"
[    3.490622] Audio Excel DSP 16 init driver Copyright (C) Riccardo Facchetti 1995-98
/kernel/x86_64-randconfig-a06-0818/adc97d6a735dbb1e94cb4f1bf0b55f258b349941/dmesg-kvm-nhm4-21894-20130820135233-3.11.0-rc4-00420-gadc97d6-335
/kernel/x86_64-randconfig-a06-0818/adc97d6a735dbb1e94cb4f1bf0b55f258b349941/dmesg-kvm-waimea-27189-20130820215640-3.11.0-rc4-00420-gadc97d6-335

Bisecting: 0 revisions left to test after this (roughly 0 steps)
[6eed9404ab3c4baea54ce4c7e862e69df1d39f38] cpufreq: Use rwsem for protecting critical sections
running /c/kernel-tests/bisect-test-boot-failure.sh /home/wfg/usb/obj-bisect
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a06-0818/next:master:6eed9404ab3c4baea54ce4c7e862e69df1d39f38:bisect-usb

2013-08-20-21:57:21 6eed9404ab3c4baea54ce4c7e862e69df1d39f38 compiling
172 real  1110 user  104 sys  703.11% cpu 	x86_64-randconfig-a06-0818

2013-08-20-22:00:22 detecting boot state 3.11.0-rc4-00419-g6eed940... TEST FAILURE
[    3.293099] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eeprom: no busid passed, refusing all cards
[    3.294275] fmc fake-design-for-testing-f001: Driver has no ID: matches all
[    3.295137] BUG: scheduling while atomic: swapper/1/0x00000002
[    3.295818] 4 locks held by swapper/1:
[    3.296250]  #0:  (&__lockdep_no_validate__){......}, at: [<ffffffff813e03a3>] __driver_attach+0x43/0x90
[    3.297423]  #1:  (&__lockdep_no_validate__){......}, at: [<ffffffff813e03b1>] __driver_attach+0x51/0x90
[    3.298584]  #2:  (fc_lock){+.+.+.}, at: [<ffffffff8174227c>] fc_probe+0x8c/0x140
[    3.299551]  #3:  (misc_mtx){+.+.+.}, at: [<ffffffff813c7f54>] misc_register+0x24/0x120
[    3.300565] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-rc4-00419-g6eed940 #336
[    3.301436]  7fffffffffffffff ffff88000dc619e0 ffffffff81881d27 ffff88000dc619f8
[    3.302354]  ffffffff8187ef56 7fffffffffffffff ffff88000dc61a58 ffffffff81898fe3
[    3.303268]  ffff88000dc58610 ffff88000dc58040 ffff88000dc61fd8 ffff88000dc61fd8
[    3.304201] Call Trace:
[    3.304497]  [<ffffffff81881d27>] dump_stack+0x19/0x1b
[    3.305091]  [<ffffffff8187ef56>] __schedule_bug+0x5b/0x6a
[    3.305726]  [<ffffffff81898fe3>] __schedule+0x563/0x5d0
[    3.306338]  [<ffffffff81899064>] schedule+0x14/0x20
[    3.306916]  [<ffffffff818960d5>] schedule_timeout+0x145/0x1a0
[    3.307586]  [<ffffffff810c7e00>] ? mark_held_locks+0xb0/0x130
[    3.308259]  [<ffffffff8189aae7>] ? _raw_spin_unlock_irq+0x27/0x40
[    3.308977]  [<ffffffff810c7f7d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
[    3.309750]  [<ffffffff8189940c>] wait_for_completion+0xcc/0x100
[    3.310440]  [<ffffffff810b37b0>] ? try_to_wake_up+0x160/0x160
[    3.311110]  [<ffffffff813e475b>] devtmpfs_create_node+0x10b/0x140
[    3.311821]  [<ffffffff813dc6de>] device_add+0x23e/0x720
[    3.312436]  [<ffffffff810aafd6>] ? __init_waitqueue_head+0x36/0x50
[    3.313160]  [<ffffffff813dcc98>] device_create_groups_vargs+0xd8/0x100
[    3.313937]  [<ffffffff813dd66c>] device_create+0x3c/0x40
[    3.314559]  [<ffffffff813c7ff6>] misc_register+0xc6/0x120
[    3.315191]  [<ffffffff81742285>] fc_probe+0x95/0x140
[    3.315781]  [<ffffffff817400b2>] fmc_probe+0x12/0x20
[    3.316367]  [<ffffffff813e0180>] driver_probe_device+0x70/0x210
[    3.317058]  [<ffffffff813e03eb>] __driver_attach+0x8b/0x90
[    3.317701]  [<ffffffff813e0360>] ? __device_attach+0x40/0x40
[    3.318362]  [<ffffffff813de5c3>] bus_for_each_dev+0x63/0xa0
[    3.319015]  [<ffffffff813e0099>] driver_attach+0x19/0x20
[    3.319635]  [<ffffffff813df088>] bus_add_driver+0x1d8/0x270
[    3.320296]  [<ffffffff817421b0>] ? fc_read+0xa0/0xa0
[    3.320889]  [<ffffffff813e0b5f>] driver_register+0x6f/0x150
[    3.321554]  [<ffffffff817421b0>] ? fc_read+0xa0/0xa0
[    3.322148]  [<ffffffff81740250>] fmc_driver_register+0x30/0x40
[    3.322843]  [<ffffffff817421c0>] fc_init+0x10/0x20
[    3.323426]  [<ffffffff81da5001>] do_one_initcall+0x8c/0x138
[    3.324086]  [<ffffffff810a85e8>] ? parse_args+0x1f8/0x330
[    3.324727]  [<ffffffff81da51c0>] kernel_init_freeable+0x113/0x18e
[    3.325436]  [<ffffffff81da485e>] ? do_early_param+0x88/0x88
[    3.326089]  [<ffffffff8187a320>] ? rest_init+0x150/0x150
[    3.326717]  [<ffffffff8187a329>] kernel_init+0x9/0x180
[    3.327315]  [<ffffffff8189bd7a>] ret_from_fork+0x7a/0xb0
[    3.327940]  [<ffffffff8187a320>] ? rest_init+0x150/0x150
[    3.328629] fmc_chardev fake-design-for-testing-f001: Created misc device "fake-design-for-testing-f001"
[    3.329874] Audio Excel DSP 16 init driver Copyright (C) Riccardo Facchetti 1995-98
/kernel/x86_64-randconfig-a06-0818/6eed9404ab3c4baea54ce4c7e862e69df1d39f38/dmesg-kvm-inn-9479-20130820220112-3.11.0-rc4-00419-g6eed940-336

6eed9404ab3c4baea54ce4c7e862e69df1d39f38 is the first bad commit
commit 6eed9404ab3c4baea54ce4c7e862e69df1d39f38
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Tue Aug 6 22:53:11 2013 +0530

    cpufreq: Use rwsem for protecting critical sections
    
    Critical sections of the cpufreq core are protected with the help of
    the driver module owner's refcount, which isn't the correct approach,
    because it causes rmmod to return an error when some routine has
    updated that refcount.
    
    Let's use rwsem for this purpose instead.  Only
    cpufreq_unregister_driver() will use write sem
    and everybody else will use read sem.
    
    [rjw: Subject & changelog]
    Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

:040000 040000 4a5001e33f27bb54ae4dda22bcefaaf37720be2a 4f4d01acac5307a959e0059fec627b0818031a6a M	drivers
bisect run success
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a06-0818/next:master:fe492f3f0332e23cc6ca4913e5a2ed78e1888902:bisect-usb

2013-08-20-22:01:57 fe492f3f0332e23cc6ca4913e5a2ed78e1888902 reuse /kernel/x86_64-randconfig-a06-0818/fe492f3f0332e23cc6ca4913e5a2ed78e1888902/vmlinuz-3.11.0-rc4-00418-gfe492f3

2013-08-20-22:01:57 detecting boot state .....	2...	3.	4.....	5....	7	10	11.	12	15	22	57	87	110	155	176	179..........	180 SUCCESS

ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a06-0818/next:master:1e712b0818569846d6b926ecb6bf32b3dea73609:bisect-usb
 TEST FAILURE
[   21.664908] 3.11.0-rc5-next-20130816-05970-g1e712b0 #17 Not tainted
[   21.664908] -------------------------------------
[   21.664908] swapper/1 is trying to release lock (cpufreq_rwsem) at:
[   21.664908] [<ffffffff8164fa12>] cpufreq_add_dev+0x232/0x360
[   21.664908] but there are no more locks to release!
[   21.664908] 
[   21.664908] other info that might help us debug this:
[   21.664908] 1 lock held by swapper/1:
[   21.664908]  #0:  (subsys mutex){+.+.+.}, at: [<ffffffff813e26a4>] subsys_interface_register+0x54/0xf0
[   21.664908] 
[   21.664908] stack backtrace:
[   21.664908] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-rc5-next-20130816-05970-g1e712b0 #17
[   21.664908]  ffffffff8164fa12 ffff88000dc63ce8 ffffffff81886d70 ffff88000dc63d10
[   21.664908]  ffffffff810c755c ffffffff81d66b50 ffff88000dc59040 ffffffff8164fa12
[   21.664908]  ffff88000dc63d88 ffffffff810cbf56 ffffffff810c8430 000000070dc63d68
[   21.664908] Call Trace:
[   21.664908]  [<ffffffff8164fa12>] ? cpufreq_add_dev+0x232/0x360
[   21.664908]  [<ffffffff81886d70>] dump_stack+0x19/0x1b
[   21.664908]  [<ffffffff810c755c>] print_unlock_imbalance_bug+0xec/0x100
[   21.664908]  [<ffffffff8164fa12>] ? cpufreq_add_dev+0x232/0x360
[   21.664908]  [<ffffffff810cbf56>] lock_release_non_nested+0x226/0x300
[   21.664908]  [<ffffffff810c8430>] ? mark_held_locks+0xb0/0x130
[   21.664908]  [<ffffffff81130489>] ? kfree+0xe9/0x140
[   21.664908]  [<ffffffff8164fa12>] ? cpufreq_add_dev+0x232/0x360
[   21.664908]  [<ffffffff810cc0b8>] lock_release+0x88/0x1b0
[   21.664908]  [<ffffffff810ae60a>] up_read+0x1a/0x40
[   21.664908]  [<ffffffff8164fa12>] cpufreq_add_dev+0x232/0x360
[   21.664908]  [<ffffffff813e26f9>] subsys_interface_register+0xa9/0xf0
[   21.664908]  [<ffffffff81650f34>] cpufreq_register_driver+0x84/0x130
[   21.664908]  [<ffffffff81de4f9d>] ? cpufreq_gov_dbs_init+0x12/0x12
[   21.664908]  [<ffffffff81de4fee>] acpi_cpufreq_init+0x51/0x134
[   21.664908]  [<ffffffff81dac003>] do_one_initcall+0x8c/0x138
[   21.664908]  [<ffffffff810a8b18>] ? parse_args+0x1f8/0x330
[   21.664908]  [<ffffffff81dac1c2>] kernel_init_freeable+0x113/0x18e
[   21.664908]  [<ffffffff81dab860>] ? do_early_param+0x88/0x88
[   21.664908]  [<ffffffff8187f390>] ? rest_init+0x150/0x150
[   21.664908]  [<ffffffff8187f399>] kernel_init+0x9/0x180
[   21.664908]  [<ffffffff818a0dba>] ret_from_fork+0x7a/0xb0
[   21.664908]  [<ffffffff8187f390>] ? rest_init+0x150/0x150
[   21.689085] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[   21.758668] Freeing unused kernel memory: 772K (ffffffff81dab000 - ffffffff81e6c000)
/kernel/x86_64-randconfig-a06-0818/1e712b0818569846d6b926ecb6bf32b3dea73609/dmesg-kvm-ant-19071-20130818122323--
/kernel/x86_64-randconfig-a06-0818/1e712b0818569846d6b926ecb6bf32b3dea73609/dmesg-kvm-ant-22544-20130818122322-3.11.0-rc5-next-20130816-05970-g1e712b0-17
/kernel/x86_64-randconfig-a06-0818/1e712b0818569846d6b926ecb6bf32b3dea73609/dmesg-kvm-bens-3971-20130820175627-3.11.0-rc5-next-20130816-05970-g1e712b0-17
/kernel/x86_64-randconfig-a06-0818/1e712b0818569846d6b926ecb6bf32b3dea73609/dmesg-kvm-inn-10367-20130818122416--
/kernel/x86_64-randconfig-a06-0818/1e712b0818569846d6b926ecb6bf32b3dea73609/dmesg-kvm-inn-11564-20130820182150-3.11.0-rc1-00101-g4f4b7b9-25
/kernel/x86_64-randconfig-a06-0818/1e712b0818569846d6b926ecb6bf32b3dea73609/dmesg-kvm-inn-6325-20130818122415-3.11.0-rc5-next-20130816-05970-g1e712b0-17
/kernel/x86_64-randconfig-a06-0818/1e712b0818569846d6b926ecb6bf32b3dea73609/dmesg-kvm-inn-6388-20130820182231-3.11.0-rc5-next-20130816-05970-g1e712b0-17
/kernel/x86_64-randconfig-a06-0818/1e712b0818569846d6b926ecb6bf32b3dea73609/dmesg-kvm-inn-6707-20130820182134-3.11.0-rc5-next-20130816-05970-g1e712b0-17
/kernel/x86_64-randconfig-a06-0818/1e712b0818569846d6b926ecb6bf32b3dea73609/dmesg-kvm-inn-9542-20130820182234-3.11.0-rc6-00693-g05f0325-14
/kernel/x86_64-randconfig-a06-0818/1e712b0818569846d6b926ecb6bf32b3dea73609/dmesg-kvm-nhm4-15984-20130820095447-3.11.0-rc5-next-20130816-05970-g1e712b0-17
/kernel/x86_64-randconfig-a06-0818/1e712b0818569846d6b926ecb6bf32b3dea73609/dmesg-kvm-nhm4-4190-20130820100535-3.11.0-rc5-next-20130816-05970-g1e712b0-17
/kernel/x86_64-randconfig-a06-0818/1e712b0818569846d6b926ecb6bf32b3dea73609/dmesg-kvm-nhm4-6732-20130820100144-3.11.0-rc1-00091-g5d5f4bc-43
/kernel/x86_64-randconfig-a06-0818/1e712b0818569846d6b926ecb6bf32b3dea73609/dmesg-kvm-nhm4-8319-20130820095218-3.11.0-rc6-00599-gdb03a7a-19
/kernel/x86_64-randconfig-a06-0818/1e712b0818569846d6b926ecb6bf32b3dea73609/dmesg-kvm-roam-6876-20130818122429-3.11.0-rc5-next-20130816-05970-g1e712b0-17
/kernel/x86_64-randconfig-a06-0818/1e712b0818569846d6b926ecb6bf32b3dea73609/dmesg-kvm-stoakley-14155-20130820181436-3.11.0-rc5-next-20130816-05970-g1e712b0-17
/kernel/x86_64-randconfig-a06-0818/1e712b0818569846d6b926ecb6bf32b3dea73609/dmesg-kvm-stoakley-3331-20130818122408--
/kernel/x86_64-randconfig-a06-0818/1e712b0818569846d6b926ecb6bf32b3dea73609/dmesg-kvm-stoakley-8706-20130818122406-3.11.0-rc5-next-20130816-05970-g1e712b0-17
/kernel/x86_64-randconfig-a06-0818/1e712b0818569846d6b926ecb6bf32b3dea73609/dmesg-kvm-waimea-14017-20130820181441-3.11.0-rc5-next-20130816-05970-g1e712b0-17
/kernel/x86_64-randconfig-a06-0818/1e712b0818569846d6b926ecb6bf32b3dea73609/dmesg-kvm-waimea-18203-20130820180943-3.11.0-rc1-00101-g4f4b7b9-44
/kernel/x86_64-randconfig-a06-0818/1e712b0818569846d6b926ecb6bf32b3dea73609/dmesg-kvm-waimea-7892-20130820180102-3.11.0-rc5-next-20130816-05970-g1e712b0-17
/kernel/x86_64-randconfig-a06-0818/1e712b0818569846d6b926ecb6bf32b3dea73609/dmesg-kvm-waimea-8981-20130820181957-3.11.0-rc5-next-20130816-05970-g1e712b0-17
/kernel/x86_64-randconfig-a06-0818/1e712b0818569846d6b926ecb6bf32b3dea73609/dmesg-kvm-waimea-9287-20130820180904-3.11.0-rc5-next-20130816-05970-g1e712b0-17
/kernel/x86_64-randconfig-a06-0818/1e712b0818569846d6b926ecb6bf32b3dea73609/dmesg-kvm-xian-12217-20130818122429-3.11.0-rc5-next-20130816-05970-g1e712b0-17
/kernel/x86_64-randconfig-a06-0818/1e712b0818569846d6b926ecb6bf32b3dea73609/dmesg-kvm-xian-8553-20130818122432--
/kernel/x86_64-randconfig-a06-0818/1e712b0818569846d6b926ecb6bf32b3dea73609/dmesg-kvm-xps-10637-20130820181543-3.11.0-rc5-next-20130816-05970-g1e712b0-17
/kernel/x86_64-randconfig-a06-0818/1e712b0818569846d6b926ecb6bf32b3dea73609/dmesg-kvm-xps-14216-20130820180015-3.11.0-rc5-next-20130816-05970-g1e712b0-17
/kernel/x86_64-randconfig-a06-0818/1e712b0818569846d6b926ecb6bf32b3dea73609/dmesg-kvm-xps-14755-20130820175558-3.11.0-rc5-next-20130816-05970-g1e712b0-17
/kernel/x86_64-randconfig-a06-0818/1e712b0818569846d6b926ecb6bf32b3dea73609/dmesg-kvm-xps-16750-20130820175729-3.11.0-rc5-next-20130816-05970-g1e712b0-17
/kernel/x86_64-randconfig-a06-0818/1e712b0818569846d6b926ecb6bf32b3dea73609/dmesg-kvm-xps-16750-20130820180054-3.11.0-rc5-next-20130816-05970-g1e712b0-17

[detached HEAD ecc07b5] Revert "cpufreq: Use rwsem for protecting critical sections"
 1 file changed, 78 insertions(+), 57 deletions(-)
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a06-0818/next:master:ecc07b5c65be50e1829abf4b58e2105ac3faaf9f:bisect-usb

2013-08-20-22:25:04 ecc07b5c65be50e1829abf4b58e2105ac3faaf9f compiling
2013-08-20-22:27:54 ecc07b5c65be50e1829abf4b58e2105ac3faaf9f SKIP BROKEN BUILD
Check erros in /cc/wfg/usb-bisect and /tmp/kernel/x86_64-randconfig-a06-0818/ecc07b5c65be50e1829abf4b58e2105ac3faaf9f

========= upstream =========
Fetching linus
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a06-0818/next:master:fd3930f70c8d14008f3377d51ce039806dfc542e:bisect-usb

2013-08-20-22:28:05 fd3930f70c8d14008f3377d51ce039806dfc542e compiling

2013-08-20-22:31:19 detecting boot state 3.11.0-rc6-00815-gfd3930f...	1....	2.	3.........................	4..	5...	6.	7.	9.	10	13	16	19...	26	29	31	42	53	63	74	82	89	96	99	101	106	111	117	121	132	147	156	170	174.	176.	177..	179.	180 SUCCESS


========= linux-next =========
Fetching next
ls -a /kernel-tests/run-queue/kvm/x86_64-randconfig-a06-0818/next:master:d7949dff8fd98d8dd7ee46a8b1a089fe80099869:bisect-usb

2013-08-20-23:14:33 d7949dff8fd98d8dd7ee46a8b1a089fe80099869 compiling

2013-08-20-23:18:08 detecting boot state 3.11.0-rc6-next-20130820-07258-gd7949df... TEST FAILURE
[    3.907350] 3.11.0-rc6-next-20130820-07258-gd7949df #338 Not tainted
[    3.907350] -------------------------------------
[    3.907350] swapper/1 is trying to release lock (cpufreq_rwsem) at:
[    3.907350] [<ffffffff81651da2>] cpufreq_add_dev+0x232/0x360
[    3.907350] but there are no more locks to release!
[    3.907350] 
[    3.907350] other info that might help us debug this:
[    3.907350] 1 lock held by swapper/1:
[    3.907350]  #0:  (subsys mutex){+.+.+.}, at: [<ffffffff813e42a4>] subsys_interface_register+0x54/0xf0
[    3.907350] 
[    3.907350] stack backtrace:
[    3.907350] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-rc6-next-20130820-07258-gd7949df #338
[    3.907350]  ffffffff81651da2 ffff88000dc63ce8 ffffffff8188991f ffff88000dc63d10
[    3.907350]  ffffffff810c7c4c ffffffff81d670f0 ffff88000dc59040 ffffffff81651da2
[    3.907350]  ffff88000dc63d88 ffffffff810cc646 ffffffff810c8b20 000000070dc63d68
[    3.907350] Call Trace:
[    3.907350]  [<ffffffff81651da2>] ? cpufreq_add_dev+0x232/0x360
[    3.907350]  [<ffffffff8188991f>] dump_stack+0x19/0x1b
[    3.907350]  [<ffffffff810c7c4c>] print_unlock_imbalance_bug+0xec/0x100
[    3.907350]  [<ffffffff81651da2>] ? cpufreq_add_dev+0x232/0x360
[    3.907350]  [<ffffffff810cc646>] lock_release_non_nested+0x226/0x300
[    3.907350]  [<ffffffff810c8b20>] ? mark_held_locks+0xb0/0x130
[    3.907350]  [<ffffffff81130da9>] ? kfree+0xe9/0x140
[    3.907350]  [<ffffffff81651da2>] ? cpufreq_add_dev+0x232/0x360
[    3.907350]  [<ffffffff810cc7a8>] lock_release+0x88/0x1b0
[    3.907350]  [<ffffffff810aecea>] up_read+0x1a/0x40
[    3.907350]  [<ffffffff81651da2>] cpufreq_add_dev+0x232/0x360
[    3.907350]  [<ffffffff813e42f9>] subsys_interface_register+0xa9/0xf0
[    3.907350]  [<ffffffff816532c4>] cpufreq_register_driver+0x84/0x130
[    3.907350]  [<ffffffff81de6000>] ? cpufreq_gov_dbs_init+0x12/0x12
[    3.907350]  [<ffffffff81de6051>] acpi_cpufreq_init+0x51/0x134
[    3.907350]  [<ffffffff81dad003>] do_one_initcall+0x8c/0x138
[    3.907350]  [<ffffffff810a91f8>] ? parse_args+0x1f8/0x330
[    3.907350]  [<ffffffff81dad1c2>] kernel_init_freeable+0x113/0x18e
[    3.907350]  [<ffffffff81dac860>] ? do_early_param+0x88/0x88
[    3.907350]  [<ffffffff81881f30>] ? rest_init+0x150/0x150
[    3.907350]  [<ffffffff81881f39>] kernel_init+0x9/0x180
[    3.907350]  [<ffffffff818a39ba>] ret_from_fork+0x7a/0xb0
[    3.907350]  [<ffffffff81881f30>] ? rest_init+0x150/0x150
[    3.944888] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    3.947449] Freeing unused kernel memory: 772K (ffffffff81dac000 - ffffffff81e6d000)
/kernel/x86_64-randconfig-a06-0818/d7949dff8fd98d8dd7ee46a8b1a089fe80099869/dmesg-kvm-stoakley-14144-20130820231858-3.11.0-rc6-next-20130820-07258-gd7949df-338


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.11.0-rc5-next-20130816-05970-g1e712b0"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.11.0-rc5 Kernel Configuration
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
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
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
CONFIG_HAVE_INTEL_TXT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
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
CONFIG_KERNEL_XZ=y
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
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
CONFIG_GENERIC_IRQ_CHIP=y
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
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
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
CONFIG_MEMCG=y
CONFIG_MEMCG_KMEM=y
CONFIG_CGROUP_PERF=y
# CONFIG_CGROUP_SCHED is not set
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
CONFIG_UIDGID_CONVERTED=y
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
# CONFIG_SCHED_AUTOGROUP is not set
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
# CONFIG_RD_LZMA is not set
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
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
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
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
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
# CONFIG_BLOCK is not set
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
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
# CONFIG_DMI is not set
# CONFIG_GART_IOMMU is not set
CONFIG_CALGARY_IOMMU=y
# CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
CONFIG_I8K=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_MICROCODE_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
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
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
# CONFIG_ZBUD is not set
CONFIG_MEM_SOFT_DIRTY=y
# CONFIG_CMA is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
# CONFIG_X86_PAT is not set
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_SLEEP_DEBUG=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_EC_DEBUGFS=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
# CONFIG_ACPI_FAN is not set
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_I2C=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
# CONFIG_ACPI_THERMAL is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_INITRD_TABLE_OVERRIDE=y
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_EINJ=y
CONFIG_ACPI_APEI_ERST_DEBUG=y
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
CONFIG_X86_PCC_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_ACPI_CPUFREQ_CPB is not set
CONFIG_X86_POWERNOW_K8=y
# CONFIG_X86_AMD_FREQ_SENSITIVITY is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
CONFIG_CPU_IDLE_GOV_LADDER=y
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
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=y
# CONFIG_PCIEASPM is not set
CONFIG_PCIE_PME=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
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
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_TSI721=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
CONFIG_RAPIDIO_DMA_ENGINE=y
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_ENUM_BASIC=y

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=y
CONFIG_RAPIDIO_CPS_XX=y
CONFIG_RAPIDIO_TSI568=y
CONFIG_RAPIDIO_CPS_GEN2=y
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_BINFMT_SCRIPT is not set
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_SUB_POLICY=y
# CONFIG_XFRM_MIGRATE is not set
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
CONFIG_ATM=y
CONFIG_ATM_LANE=y
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_VLAN_8021Q_MVRP is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
CONFIG_ATALK=y
# CONFIG_DEV_APPLETALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
CONFIG_PHONET=y
CONFIG_IEEE802154=y
CONFIG_MAC802154=y
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_NC is not set
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
CONFIG_NET_MPLS_GSO=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
CONFIG_IRCOMM=y
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
# CONFIG_IRDA_FAST_RR is not set
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=y

#
# Dongle support
#
# CONFIG_DONGLE is not set

#
# FIR device drivers
#
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
CONFIG_SMC_IRCC_FIR=y
CONFIG_ALI_FIR=y
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
CONFIG_BT=y
# CONFIG_BT_RFCOMM is not set
# CONFIG_BT_BNEP is not set
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUART=y
# CONFIG_BT_HCIUART_H4 is not set
# CONFIG_BT_HCIUART_BCSP is not set
# CONFIG_BT_HCIUART_ATH3K is not set
# CONFIG_BT_HCIUART_LL is not set
# CONFIG_BT_HCIUART_3WIRE is not set
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
# CONFIG_BT_WILINK is not set
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_INPUT=y
CONFIG_NET_9P=y
# CONFIG_NET_9P_VIRTIO is not set
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
CONFIG_CAIF_NETDEV=y
CONFIG_CAIF_USB=y
CONFIG_NFC=y
CONFIG_NFC_NCI=y
CONFIG_NFC_NCI_SPI=y
CONFIG_NFC_HCI=y
# CONFIG_NFC_SHDLC is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_WILINK=y
# CONFIG_NFC_SIM is not set
# CONFIG_NFC_PN544 is not set
# CONFIG_NFC_MICROREAD is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
# CONFIG_DMA_SHARED_BUFFER is not set

#
# Bus devices
#
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
# CONFIG_MTD_CMDLINE_PARTS is not set
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_OOPS=y

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
CONFIG_MTD_OTP=y
# CONFIG_MTD_CFI_INTELEXT is not set
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
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
# CONFIG_MTD_SC520CDP is not set
CONFIG_MTD_NETSC520=y
CONFIG_MTD_TS5500=y
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
CONFIG_MTD_ESB2ROM=y
CONFIG_MTD_CK804XROM=y
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
CONFIG_MTD_INTEL_VR_NOR=y
CONFIG_MTD_PLATRAM=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_DATAFLASH is not set
# CONFIG_MTD_M25P80 is not set
CONFIG_MTD_SST25L=y
CONFIG_MTD_SLRAM=y
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set

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
CONFIG_MTD_SM_COMMON=y
# CONFIG_MTD_NAND_DENALI is not set
# CONFIG_MTD_NAND_GPIO is not set
CONFIG_MTD_NAND_IDS=y
CONFIG_MTD_NAND_RICOH=y
CONFIG_MTD_NAND_DISKONCHIP=y
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
CONFIG_MTD_NAND_DOCG4=y
CONFIG_MTD_NAND_CAFE=y
CONFIG_MTD_NAND_NANDSIM=y
CONFIG_MTD_NAND_PLATFORM=y
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
# CONFIG_MTD_ONENAND_GENERIC is not set
CONFIG_MTD_ONENAND_OTP=y
# CONFIG_MTD_ONENAND_2X_PROGRAM is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
# CONFIG_MTD_UBI_GLUEBI is not set
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
# CONFIG_ICS932S401 is not set
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_CS5535_MFGPT is not set
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
# CONFIG_BMP085_I2C is not set
CONFIG_BMP085_SPI=y
CONFIG_PCH_PHUB=y
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_LATTICE_ECP3_CONFIG=y
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_93XX46=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_FUSION=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
# CONFIG_FIREWIRE_NOSY is not set
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
# CONFIG_I2O_CONFIG is not set
CONFIG_I2O_BUS=y
CONFIG_I2O_PROC=y
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_NETDEVICES is not set

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
CONFIG_INPUT_JOYDEV=y
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5520=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=y
CONFIG_KEYBOARD_QT2160=y
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_GPIO=y
CONFIG_KEYBOARD_GPIO_POLLED=y
# CONFIG_KEYBOARD_TCA6416 is not set
CONFIG_KEYBOARD_TCA8418=y
CONFIG_KEYBOARD_MATRIX=y
CONFIG_KEYBOARD_LM8323=y
# CONFIG_KEYBOARD_LM8333 is not set
CONFIG_KEYBOARD_MAX7359=y
CONFIG_KEYBOARD_MCS=y
# CONFIG_KEYBOARD_MPR121 is not set
CONFIG_KEYBOARD_NEWTON=y
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_KEYBOARD_SUNKBD=y
# CONFIG_KEYBOARD_TWL4030 is not set
CONFIG_KEYBOARD_XTKBD=y
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=y
# CONFIG_JOYSTICK_GUILLEMOT is not set
CONFIG_JOYSTICK_INTERACT=y
# CONFIG_JOYSTICK_SIDEWINDER is not set
CONFIG_JOYSTICK_TMDC=y
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_DB9=y
CONFIG_JOYSTICK_GAMECON=y
CONFIG_JOYSTICK_TURBOGRAFX=y
# CONFIG_JOYSTICK_AS5011 is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=y
# CONFIG_TOUCHSCREEN_AD7877 is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
# CONFIG_TOUCHSCREEN_BU21013 is not set
CONFIG_TOUCHSCREEN_CY8CTMG110=y
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
# CONFIG_TOUCHSCREEN_DA9052 is not set
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
# CONFIG_TOUCHSCREEN_EETI is not set
CONFIG_TOUCHSCREEN_FUJITSU=y
# CONFIG_TOUCHSCREEN_ILI210X is not set
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
CONFIG_TOUCHSCREEN_MAX11801=y
CONFIG_TOUCHSCREEN_MCS5000=y
# CONFIG_TOUCHSCREEN_MMS114 is not set
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_WM831X is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_MC13783 is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC2005=y
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_PCAP=y
CONFIG_TOUCHSCREEN_ST1232=y
# CONFIG_TOUCHSCREEN_TPS6507X is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM80X_ONKEY=y
CONFIG_INPUT_AD714X=y
CONFIG_INPUT_AD714X_I2C=y
CONFIG_INPUT_AD714X_SPI=y
CONFIG_INPUT_BMA150=y
# CONFIG_INPUT_MAX8925_ONKEY is not set
CONFIG_INPUT_MC13783_PWRBUTTON=y
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=y
CONFIG_INPUT_GPIO_TILT_POLLED=y
CONFIG_INPUT_ATLAS_BTNS=y
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_RETU_PWRBUTTON=y
# CONFIG_INPUT_TWL4030_PWRBUTTON is not set
CONFIG_INPUT_TWL4030_VIBRA=y
CONFIG_INPUT_TWL6040_VIBRA=y
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF50633_PMU=y
CONFIG_INPUT_PCF8574=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_DA9052_ONKEY=y
# CONFIG_INPUT_DA9055_ONKEY is not set
# CONFIG_INPUT_WM831X_ON is not set
CONFIG_INPUT_PCAP=y
# CONFIG_INPUT_ADXL34X is not set
CONFIG_INPUT_CMA3000=y
CONFIG_INPUT_CMA3000_I2C=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PARKBD is not set
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=y
CONFIG_CYCLADES=y
CONFIG_CYZ_INTR=y
CONFIG_MOXA_INTELLIO=y
CONFIG_MOXA_SMARTIO=y
CONFIG_SYNCLINK=y
CONFIG_SYNCLINKMP=y
CONFIG_SYNCLINK_GT=y
# CONFIG_NOZOMI is not set
CONFIG_ISI=y
CONFIG_N_HDLC=y
CONFIG_N_GSM=y
CONFIG_TRACE_ROUTER=y
CONFIG_TRACE_SINK=y
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
# CONFIG_SERIAL_8250_DMA is not set
# CONFIG_SERIAL_8250_PCI is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=y
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MRST_MAX3110 is not set
CONFIG_SERIAL_MFD_HSU=y
# CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
CONFIG_SERIAL_UARTLITE=y
CONFIG_SERIAL_UARTLITE_CONSOLE=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_SERIAL_SCCNXP=y
CONFIG_SERIAL_SCCNXP_CONSOLE=y
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_IFX6X60=y
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_ST_ASC is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
CONFIG_TCG_INFINEON=y
CONFIG_TCG_ST33_I2C=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y
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
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
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
CONFIG_I2C_EG20T=y
CONFIG_I2C_GPIO=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set

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
CONFIG_SPI_ALTERA=y
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
CONFIG_SPI_OC_TINY=y
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=y
CONFIG_SPI_PXA2XX_PCI=y
# CONFIG_SPI_SC18IS602 is not set
CONFIG_SPI_TOPCLIFF_PCH=y
CONFIG_SPI_XCOMM=y
# CONFIG_SPI_XILINX is not set
CONFIG_SPI_DESIGNWARE=y
CONFIG_SPI_DW_PCI=y
# CONFIG_SPI_DW_MID_DMA is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=y
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

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_TS5500=y
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=y
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_TWL4030=y
# CONFIG_GPIO_TWL6040 is not set
# CONFIG_GPIO_WM831X is not set
CONFIG_GPIO_WM8350=y
CONFIG_GPIO_ADP5520=y
CONFIG_GPIO_ADP5588=y
CONFIG_GPIO_ADP5588_IRQ=y

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=y
CONFIG_GPIO_BT8XX=y
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_LANGWELL is not set
# CONFIG_GPIO_PCH is not set
CONFIG_GPIO_ML_IOH=y
# CONFIG_GPIO_TIMBERDALE is not set
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
# CONFIG_GPIO_MCP23S08 is not set
# CONFIG_GPIO_MC33880 is not set
CONFIG_GPIO_74X164=y

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
# CONFIG_GPIO_TPS6586X is not set

#
# USB GPIO expanders:
#
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
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
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
# CONFIG_W1_SLAVE_DS2780 is not set
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
# CONFIG_MAX8925_POWER is not set
# CONFIG_WM831X_BACKUP is not set
CONFIG_WM831X_POWER=y
CONFIG_WM8350_POWER=y
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2760=y
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9052 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
# CONFIG_CHARGER_PCF50633 is not set
CONFIG_BATTERY_RX51=y
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_TWL4030 is not set
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_SMB347=y
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_DA9055 is not set
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IIO_HWMON=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=y
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95234=y
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
# CONFIG_SENSORS_PMBUS is not set
CONFIG_SENSORS_ADM1275=y
CONFIG_SENSORS_LM25066=y
CONFIG_SENSORS_LTC2978=y
CONFIG_SENSORS_MAX16064=y
# CONFIG_SENSORS_MAX34440 is not set
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SHT15=y
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_TWL4030_MADC is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
# CONFIG_SENSORS_WM8350 is not set
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_MC13783_ADC=y

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
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DRIVER_GPIO is not set
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=y
# CONFIG_MFD_AS3711 is not set
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
# CONFIG_MFD_CROS_EC_SPI is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
# CONFIG_MFD_KEMPLD is not set
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
CONFIG_EZX_PCAP=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
CONFIG_PCF50633_GPIO=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
CONFIG_TPS65010=y
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
CONFIG_TWL4030_MADC=y
CONFIG_MFD_TWL4030_AUDIO=y
CONFIG_TWL6040_CORE=y
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_ARIZONA_SPI=y
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_TUNER=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
CONFIG_VIDEOBUF_DVB=y
# CONFIG_VIDEO_V4L2_INT_DEVICE is not set
CONFIG_DVB_CORE=y
CONFIG_TTPCI_EEPROM=y
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y

#
# Media drivers
#
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture/analog/hybrid TV support
#
# CONFIG_VIDEO_CX25821 is not set
CONFIG_VIDEO_SAA7134=y
CONFIG_VIDEO_SAA7134_DVB=y
# CONFIG_VIDEO_SAA7164 is not set

#
# Media digital TV PCI Adapters
#
CONFIG_DVB_AV7110=y
CONFIG_DVB_AV7110_OSD=y
CONFIG_DVB_BUDGET_CORE=y
CONFIG_DVB_BUDGET=y
# CONFIG_DVB_BUDGET_AV is not set
CONFIG_DVB_BUDGET_PATCH=y
# CONFIG_DVB_B2C2_FLEXCOP_PCI is not set
# CONFIG_DVB_PLUTO2 is not set
# CONFIG_DVB_PT1 is not set
CONFIG_DVB_NGENE=y
CONFIG_DVB_DDBRIDGE=y

#
# Supported MMC/SDIO adapters
#
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_SI470X is not set
CONFIG_I2C_SI4713=y
# CONFIG_RADIO_SI4713 is not set
CONFIG_RADIO_TEA5764=y
CONFIG_RADIO_TEA5764_XTAL=y
CONFIG_RADIO_SAA7706H=y
CONFIG_RADIO_TEF6862=y
# CONFIG_RADIO_TIMBERDALE is not set
# CONFIG_RADIO_WL1273 is not set

#
# Texas Instruments WL128x FM driver (ST based)
#
CONFIG_RADIO_WL128X=y

#
# Supported FireWire (IEEE 1394) Adapters
#
# CONFIG_DVB_FIREDTV is not set
CONFIG_VIDEO_TVEEPROM=y
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
CONFIG_VIDEO_TVAUDIO=y
# CONFIG_VIDEO_TDA7432 is not set
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
# CONFIG_VIDEO_SONY_BTF_MPX is not set

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
CONFIG_VIDEO_BT856=y
# CONFIG_VIDEO_BT866 is not set
# CONFIG_VIDEO_KS0127 is not set
CONFIG_VIDEO_ML86V7667=y
CONFIG_VIDEO_SAA7110=y
# CONFIG_VIDEO_SAA711X is not set
# CONFIG_VIDEO_SAA7191 is not set
# CONFIG_VIDEO_TVP514X is not set
# CONFIG_VIDEO_TVP5150 is not set
# CONFIG_VIDEO_TVP7002 is not set
CONFIG_VIDEO_TW2804=y
CONFIG_VIDEO_TW9903=y
CONFIG_VIDEO_TW9906=y
CONFIG_VIDEO_VPX3220=y

#
# Video and audio decoders
#
# CONFIG_VIDEO_SAA717X is not set
# CONFIG_VIDEO_CX25840 is not set

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=y
# CONFIG_VIDEO_SAA7185 is not set
CONFIG_VIDEO_ADV7170=y
# CONFIG_VIDEO_ADV7175 is not set
CONFIG_VIDEO_ADV7343=y
CONFIG_VIDEO_ADV7393=y
# CONFIG_VIDEO_AK881X is not set
CONFIG_VIDEO_THS8200=y

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=y
CONFIG_VIDEO_UPD64083=y

#
# Miscelaneous helper chips
#
# CONFIG_VIDEO_THS7303 is not set
# CONFIG_VIDEO_M52790 is not set

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
CONFIG_MEDIA_TUNER_MT20XX=y
# CONFIG_MEDIA_TUNER_MT2060 is not set
CONFIG_MEDIA_TUNER_MT2063=y
CONFIG_MEDIA_TUNER_MT2266=y
CONFIG_MEDIA_TUNER_MT2131=y
# CONFIG_MEDIA_TUNER_QT1010 is not set
# CONFIG_MEDIA_TUNER_XC2028 is not set
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
# CONFIG_MEDIA_TUNER_MXL5005S is not set
# CONFIG_MEDIA_TUNER_MXL5007T is not set
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_MEDIA_TUNER_MAX2165=y
CONFIG_MEDIA_TUNER_TDA18218=y
# CONFIG_MEDIA_TUNER_FC0011 is not set
# CONFIG_MEDIA_TUNER_FC0012 is not set
CONFIG_MEDIA_TUNER_FC0013=y
CONFIG_MEDIA_TUNER_TDA18212=y
CONFIG_MEDIA_TUNER_E4000=y
CONFIG_MEDIA_TUNER_FC2580=y
CONFIG_MEDIA_TUNER_TUA9001=y
CONFIG_MEDIA_TUNER_IT913X=y
CONFIG_MEDIA_TUNER_R820T=y

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=y
# CONFIG_DVB_STB6100 is not set
CONFIG_DVB_STV090x=y
CONFIG_DVB_STV6110x=y

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=y
# CONFIG_DVB_TDA18271C2DD is not set

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=y
# CONFIG_DVB_CX24123 is not set
CONFIG_DVB_MT312=y
CONFIG_DVB_ZL10036=y
# CONFIG_DVB_ZL10039 is not set
# CONFIG_DVB_S5H1420 is not set
# CONFIG_DVB_STV0288 is not set
CONFIG_DVB_STB6000=y
# CONFIG_DVB_STV0299 is not set
# CONFIG_DVB_STV6110 is not set
CONFIG_DVB_STV0900=y
CONFIG_DVB_TDA8083=y
CONFIG_DVB_TDA10086=y
CONFIG_DVB_TDA8261=y
CONFIG_DVB_VES1X93=y
# CONFIG_DVB_TUNER_ITD1000 is not set
# CONFIG_DVB_TUNER_CX24113 is not set
CONFIG_DVB_TDA826X=y
CONFIG_DVB_TUA6100=y
CONFIG_DVB_CX24116=y
# CONFIG_DVB_SI21XX is not set
# CONFIG_DVB_TS2020 is not set
# CONFIG_DVB_DS3000 is not set
# CONFIG_DVB_MB86A16 is not set
CONFIG_DVB_TDA10071=y

#
# DVB-T (terrestrial) frontends
#
# CONFIG_DVB_SP8870 is not set
CONFIG_DVB_SP887X=y
CONFIG_DVB_CX22700=y
CONFIG_DVB_CX22702=y
CONFIG_DVB_S5H1432=y
CONFIG_DVB_DRXD=y
# CONFIG_DVB_L64781 is not set
# CONFIG_DVB_TDA1004X is not set
# CONFIG_DVB_NXT6000 is not set
CONFIG_DVB_MT352=y
CONFIG_DVB_ZL10353=y
CONFIG_DVB_DIB3000MB=y
# CONFIG_DVB_DIB3000MC is not set
CONFIG_DVB_DIB7000M=y
CONFIG_DVB_DIB7000P=y
# CONFIG_DVB_DIB9000 is not set
CONFIG_DVB_TDA10048=y
CONFIG_DVB_AF9013=y
CONFIG_DVB_EC100=y
CONFIG_DVB_HD29L2=y
# CONFIG_DVB_STV0367 is not set
CONFIG_DVB_CXD2820R=y
# CONFIG_DVB_RTL2830 is not set
# CONFIG_DVB_RTL2832 is not set

#
# DVB-C (cable) frontends
#
# CONFIG_DVB_VES1820 is not set
CONFIG_DVB_TDA10021=y
CONFIG_DVB_TDA10023=y
CONFIG_DVB_STV0297=y

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=y
CONFIG_DVB_OR51211=y
CONFIG_DVB_OR51132=y
CONFIG_DVB_BCM3510=y
CONFIG_DVB_LGDT330X=y
CONFIG_DVB_LGDT3305=y
# CONFIG_DVB_LG2160 is not set
CONFIG_DVB_S5H1409=y
CONFIG_DVB_AU8522=y
# CONFIG_DVB_AU8522_DTV is not set
CONFIG_DVB_AU8522_V4L=y
CONFIG_DVB_S5H1411=y

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=y
# CONFIG_DVB_DIB8000 is not set
CONFIG_DVB_MB86A20S=y

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=y
CONFIG_DVB_TUNER_DIB0070=y
CONFIG_DVB_TUNER_DIB0090=y

#
# SEC control devices for DVB-S
#
# CONFIG_DVB_LNBP21 is not set
CONFIG_DVB_LNBP22=y
CONFIG_DVB_ISL6405=y
# CONFIG_DVB_ISL6421 is not set
CONFIG_DVB_ISL6423=y
CONFIG_DVB_A8293=y
# CONFIG_DVB_LGS8GL5 is not set
CONFIG_DVB_LGS8GXX=y
CONFIG_DVB_ATBM8830=y
CONFIG_DVB_TDA665x=y
CONFIG_DVB_IX2505V=y
CONFIG_DVB_IT913X_FE=y
# CONFIG_DVB_M88RS2000 is not set
# CONFIG_DVB_AF9033 is not set

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=y

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
# CONFIG_DRM is not set
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=y
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
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
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=y
CONFIG_FB_PM2=y
CONFIG_FB_PM2_FIFO_DISCONNECT=y
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=y
CONFIG_FB_ASILIANT=y
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=y
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
CONFIG_FB_NVIDIA_I2C=y
CONFIG_FB_NVIDIA_DEBUG=y
CONFIG_FB_NVIDIA_BACKLIGHT=y
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
CONFIG_FB_MATROX=y
CONFIG_FB_MATROX_MILLENIUM=y
# CONFIG_FB_MATROX_MYSTIQUE is not set
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=y
CONFIG_FB_MATROX_MAVEN=y
CONFIG_FB_RADEON=y
# CONFIG_FB_RADEON_I2C is not set
# CONFIG_FB_RADEON_BACKLIGHT is not set
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=y
# CONFIG_FB_S3_DDC is not set
CONFIG_FB_SAVAGE=y
CONFIG_FB_SAVAGE_I2C=y
# CONFIG_FB_SAVAGE_ACCEL is not set
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=y
# CONFIG_FB_VIA_DIRECT_PROCFS is not set
CONFIG_FB_VIA_X_COMPATIBILITY=y
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=y
# CONFIG_FB_CARMINE is not set
CONFIG_FB_TMIO=y
CONFIG_FB_TMIO_ACCELL=y
CONFIG_FB_SM501=y
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
# CONFIG_FB_SIMPLE is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_L4F00242T03=y
# CONFIG_LCD_LMS283GF05 is not set
CONFIG_LCD_LTV350QV=y
# CONFIG_LCD_ILI922X is not set
CONFIG_LCD_ILI9320=y
CONFIG_LCD_TDO24M=y
CONFIG_LCD_VGG2432A4=y
CONFIG_LCD_PLATFORM=y
CONFIG_LCD_S6E63M0=y
CONFIG_LCD_LD9040=y
CONFIG_LCD_AMS369FG06=y
CONFIG_LCD_LMS501KF03=y
CONFIG_LCD_HX8357=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_LM3533 is not set
CONFIG_BACKLIGHT_CARILLO_RANCH=y
CONFIG_BACKLIGHT_DA9052=y
CONFIG_BACKLIGHT_MAX8925=y
CONFIG_BACKLIGHT_APPLE=y
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
# CONFIG_BACKLIGHT_ADP5520 is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_PCF50633=y
CONFIG_BACKLIGHT_AAT2870=y
# CONFIG_BACKLIGHT_LM3630 is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_PANDORA=y
CONFIG_BACKLIGHT_TPS65217=y
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
# CONFIG_SND is not set
CONFIG_SOUND_PRIME=y
CONFIG_SOUND_OSS=y
# CONFIG_SOUND_TRACEINIT is not set
CONFIG_SOUND_DMAP=y
CONFIG_SOUND_VMIDI=y
# CONFIG_SOUND_TRIX is not set
CONFIG_SOUND_MSS=y
# CONFIG_SOUND_MPU401 is not set
CONFIG_SOUND_PAS=y
# CONFIG_PAS_JOYSTICK is not set
CONFIG_SOUND_PSS=y
# CONFIG_PSS_MIXER is not set
# CONFIG_SOUND_SB is not set
CONFIG_SOUND_YM3812=y
CONFIG_SOUND_UART6850=y
CONFIG_SOUND_AEDSP16=y
# CONFIG_SC6600 is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
CONFIG_UHID=y
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
CONFIG_HID_AUREAL=y
# CONFIG_HID_BELKIN is not set
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_CYPRESS is not set
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
# CONFIG_HID_PICOLCD_BACKLIGHT is not set
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SPEEDLINK=y
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=y
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=y
# CONFIG_HID_SENSOR_HUB is not set

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
# CONFIG_AM335X_PHY_USB is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_GADGET is not set
CONFIG_UWB=y
CONFIG_UWB_WHCI=y
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_MEMSTICK_R592=y
CONFIG_MEMSTICK_REALTEK_PCI=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=y
# CONFIG_LEDS_LM3533 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_PCA9633 is not set
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DA9052=y
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_ADP5520=y
CONFIG_LEDS_DELL_NETBOOKS=y
CONFIG_LEDS_MC13783=y
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=y
# CONFIG_INFINIBAND_USER_MAD is not set
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_MTHCA=y
CONFIG_INFINIBAND_MTHCA_DEBUG=y
# CONFIG_INFINIBAND_IPATH is not set
CONFIG_INFINIBAND_QIB=y
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_GHES is not set
# CONFIG_EDAC_E752X is not set
CONFIG_EDAC_I82975X=y
CONFIG_EDAC_I3000=y
CONFIG_EDAC_I3200=y
CONFIG_EDAC_X38=y
CONFIG_EDAC_I5400=y
CONFIG_EDAC_I5000=y
CONFIG_EDAC_I5100=y
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
CONFIG_INTEL_IOATDMA=y
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
CONFIG_DW_DMAC_PCI=y
CONFIG_TIMB_DMA=y
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=y
CONFIG_DCA=y
CONFIG_AUXDISPLAY=y
# CONFIG_KS0108 is not set
# CONFIG_UIO is not set
CONFIG_VFIO_IOMMU_TYPE1=y
CONFIG_VFIO=y
# CONFIG_VFIO_PCI is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
CONFIG_ASUS_LAPTOP=y
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
CONFIG_FUJITSU_TABLET=y
CONFIG_AMILO_RFKILL=y
# CONFIG_HP_ACCEL is not set
CONFIG_HP_WMI=y
# CONFIG_MSI_LAPTOP is not set
CONFIG_PANASONIC_LAPTOP=y
CONFIG_COMPAL_LAPTOP=y
CONFIG_SONY_LAPTOP=y
CONFIG_SONYPI_COMPAT=y
CONFIG_IDEAPAD_LAPTOP=y
CONFIG_THINKPAD_ACPI=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
# CONFIG_THINKPAD_ACPI_VIDEO is not set
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_SENSORS_HDAPS is not set
CONFIG_ACPI_WMI=y
CONFIG_MSI_WMI=y
CONFIG_TOPSTAR_LAPTOP=y
CONFIG_ACPI_TOSHIBA=y
CONFIG_TOSHIBA_BT_RFKILL=y
CONFIG_ACPI_CMPC=y
CONFIG_INTEL_IPS=y
CONFIG_IBM_RTL=y
CONFIG_XO15_EBOOK=y
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_MXM_WMI=y
CONFIG_INTEL_OAKTRAIL=y
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
CONFIG_INTEL_RST=y
# CONFIG_INTEL_SMARTCONNECT is not set
CONFIG_PVPANIC=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_AMD_IOMMU=y
CONFIG_AMD_IOMMU_STATS=y
CONFIG_AMD_IOMMU_V2=y
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
CONFIG_INTEL_IOMMU_DEFAULT_ON=y
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
# CONFIG_IRQ_REMAP is not set

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
# CONFIG_IIO_ST_ACCEL_3AXIS is not set
CONFIG_KXSD9=y

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
CONFIG_AD7266=y
CONFIG_AD7298=y
CONFIG_AD7476=y
CONFIG_AD7791=y
CONFIG_AD7793=y
CONFIG_AD7887=y
# CONFIG_AD7923 is not set
CONFIG_MAX1363=y
# CONFIG_MCP320X is not set
# CONFIG_NAU7802 is not set
CONFIG_TI_ADC081C=y
CONFIG_TI_AM335X_ADC=y

#
# Amplifiers
#
CONFIG_AD8366=y

#
# Hid Sensor IIO Common
#
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_SPI=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
CONFIG_AD5360=y
# CONFIG_AD5380 is not set
CONFIG_AD5421=y
CONFIG_AD5446=y
# CONFIG_AD5449 is not set
# CONFIG_AD5504 is not set
CONFIG_AD5624R_SPI=y
CONFIG_AD5686=y
# CONFIG_AD5755 is not set
# CONFIG_AD5764 is not set
CONFIG_AD5791=y
CONFIG_AD7303=y
# CONFIG_MAX517 is not set
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
# CONFIG_ADIS16080 is not set
CONFIG_ADIS16130=y
CONFIG_ADIS16136=y
# CONFIG_ADIS16260 is not set
# CONFIG_ADXRS450 is not set
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_IIO_ST_GYRO_SPI_3AXIS=y
CONFIG_ITG3200=y

#
# Inertial measurement units
#
# CONFIG_ADIS16400 is not set
CONFIG_ADIS16480=y
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y
# CONFIG_INV_MPU6050_IIO is not set

#
# Light sensors
#
CONFIG_ADJD_S311=y
# CONFIG_APDS9300 is not set
# CONFIG_SENSORS_LM3533 is not set
CONFIG_SENSORS_TSL2563=y
# CONFIG_VCNL4000 is not set

#
# Magnetometer sensors
#
CONFIG_AK8975=y
# CONFIG_IIO_ST_MAGN_3AXIS is not set

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure sensors
#
# CONFIG_IIO_ST_PRESS is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
CONFIG_SERIAL_IPOCTAL=y
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
# CONFIG_DCDBAS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_DEBUG is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ECRYPT_FS=y
CONFIG_ECRYPT_FS_MESSAGING=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
CONFIG_JFFS2_FS_WBUF_VERIFY=y
CONFIG_JFFS2_SUMMARY=y
# CONFIG_JFFS2_FS_XATTR is not set
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
CONFIG_JFFS2_LZO=y
# CONFIG_JFFS2_RTIME is not set
CONFIG_JFFS2_RUBIN=y
# CONFIG_JFFS2_CMODE_NONE is not set
CONFIG_JFFS2_CMODE_PRIORITY=y
# CONFIG_JFFS2_CMODE_SIZE is not set
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
CONFIG_UBIFS_FS=y
CONFIG_UBIFS_FS_ADVANCED_COMPR=y
CONFIG_UBIFS_FS_LZO=y
# CONFIG_UBIFS_FS_ZLIB is not set
CONFIG_LOGFS=y
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_MTD=y
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_RAM is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
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
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
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
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
# CONFIG_FAULT_INJECTION is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
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
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_FIREWIRE_OHCI_REMOTE_DMA=y
# CONFIG_BUILD_DOCSRC is not set
CONFIG_DMA_API_DEBUG=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
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
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_NMI_SELFTEST=y
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_INTEL_TXT=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
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
CONFIG_CRYPTO_USER=y
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_GCM=y
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
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_CRC32=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=y
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
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
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
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

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
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
# CONFIG_CRC64_ECMA is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y

--RnlQjJ0d97Da+TV1--
