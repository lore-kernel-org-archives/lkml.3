Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbaCENVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 08:21:51 -0500
Received: from mga03.intel.com ([143.182.124.21]:17270 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486AbaCENVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 08:21:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,593,1389772800"; 
   d="scan'208";a="486445336"
Date: Wed, 5 Mar 2014 21:21:12 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Hong Zhiguo <zhiguohong@tencent.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: [blkg] inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
Message-ID: <20140305132112.GA10880@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit 2c575026fae6e63771bd2a4c1d407214a8096a89
Author:     Hong Zhiguo <zhiguohong@tencent.com>
AuthorDate: Wed Nov 20 10:35:05 2013 -0700
Commit:     Jens Axboe <axboe@kernel.dk>
CommitDate: Wed Nov 20 15:33:04 2013 -0700

    Update of blkg_stat and blkg_rwstat may happen in bh context.
    While u64_stats_fetch_retry is only preempt_disable on 32bit
    UP system. This is not enough to avoid preemption by bh and
    may read strange 64 bit value.


+------------------------------------------------------------+----+
|                                                            |    |
+------------------------------------------------------------+----+
| boot_successes                                             | 0  |
| boot_failures                                              | 19 |
| inconsistent_IN-HARDIRQ-W-HARDIRQ-ON-W_usage               | 12 |
| backtrace:vfs_read                                         | 10 |
| backtrace:SyS_read                                         | 10 |
| BUG:spinlock_lockup_suspected_on_CPU                       | 1  |
| WARNING:CPU:PID:at_kernel/softirq.c:__local_bh_enable_ip() | 9  |
| backtrace:do_mount                                         | 9  |
| backtrace:SyS_mount                                        | 9  |
| inconsistent_SOFTIRQ-ON-W-IN-SOFTIRQ-W_usage               | 7  |
| backtrace:floppy_work_workfn                               | 7  |
+------------------------------------------------------------+----+

[   91.904407] [ INFO: inconsistent lock state ]
[   91.905533] 3.14.0-rc3-wl-01773-g311db85 #11 Tainted: G        W   
[   91.906880] ---------------------------------
[   91.908013] inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
[   91.909378] blkid/3517 [HC0[0]:SC0[0]:HE1:SE1] takes:
[   91.910360]  (&(&q->__queue_lock)->rlock){?.-...}, at: [<c143f35a>] blk_flush_plug_list+0x15a/0x240
[   91.910360] {IN-HARDIRQ-W} state was registered at:
[   91.910360]   [<c106235a>] __lock_acquire+0xb5a/0x1aa0
[   91.910360]   [<c10639c7>] lock_acquire+0x77/0xa0
[   91.910360]   [<c200b83d>] _raw_spin_lock_irqsave+0x4d/0x60
[   91.910360]   [<c143e9fb>] blk_end_bidi_request+0x3b/0x60
[   91.910360]   [<c143eab2>] blk_end_request+0x12/0x20
[   91.910360]   [<c16382c7>] ide_end_rq+0x27/0x50
[   91.910360]   [<c1638467>] ide_complete_rq+0x27/0x50
[   91.910360]   [<c164ff75>] cdrom_newpc_intr+0x315/0x8e0
[   91.910360]   [<c163873a>] ide_intr+0x15a/0x1f0
[   91.910360]   [<c106a270>] handle_irq_event_percpu+0x20/0x120
[   91.910360]   [<c106a39c>] handle_irq_event+0x2c/0x50
[   91.910360]   [<c106c376>] handle_edge_irq+0x66/0x120
[   91.910360] irq event stamp: 2248
[   91.910360] hardirqs last  enabled at (2245): [<c200b9d2>] _raw_spin_unlock_irq+0x22/0x50
[   91.910360] hardirqs last disabled at (2246): [<c143f2f7>] blk_flush_plug_list+0xf7/0x240
[   91.910360] softirqs last  enabled at (2248): [<c1456ea5>] __cfq_set_active_queue+0x45/0x1d0
[   91.910360] softirqs last disabled at (2247): [<c1456ea5>] __cfq_set_active_queue+0x45/0x1d0
[   91.910360] 
[   91.910360] other info that might help us debug this:
[   91.910360]  Possible unsafe locking scenario:
[   91.910360] 
[   91.910360]        CPU0
[   91.910360]        ----
[   91.910360]   lock(&(&q->__queue_lock)->rlock);
[   91.910360]   <Interrupt>
[   91.910360]     lock(&(&q->__queue_lock)->rlock);
[   91.910360] 
[   91.910360]  *** DEADLOCK ***
[   91.910360] 
[   91.910360] 1 lock held by blkid/3517:
[   91.910360]  #0:  (&(&q->__queue_lock)->rlock){?.-...}, at: [<c143f35a>] blk_flush_plug_list+0x15a/0x240
[   91.910360] 
[   91.910360] stack backtrace:
[   91.910360] CPU: 0 PID: 3517 Comm: blkid Tainted: G        W    3.14.0-rc3-wl-01773-g311db85 #11
[   91.910360] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   91.910360]  c9908000 c9908000 c995db00 c1ff5ece c995db3c c1ff174d c231c847 c231cb6d
[   91.910360]  00000dbd 00000000 00000000 00000000 00000000 00000001 00000001 c231cb6d
[   91.910360]  00000002 c99084dc c105f270 c995db70 c1060234 00000002 00000000 c231e494
[   91.910360] Call Trace:
[   91.910360]  [<c1ff5ece>] dump_stack+0x16/0x18
[   91.910360]  [<c1ff174d>] print_usage_bug.part.35+0x252/0x25a
[   91.910360]  [<c105f270>] ? print_shortest_lock_dependencies+0x1a0/0x1a0
[   91.910360]  [<c1060234>] mark_lock+0x5d4/0x690
[   91.910360]  [<c105f270>] ? print_shortest_lock_dependencies+0x1a0/0x1a0
[   91.910360]  [<c106035f>] mark_held_locks+0x6f/0xf0
[   91.910360]  [<c102f55a>] ? print_oops_end_marker+0x2a/0x30
[   91.910360]  [<c1032c51>] ? __local_bh_enable_ip+0x61/0xd0
[   91.910360]  [<c106047f>] trace_hardirqs_on_caller+0x9f/0x1b0
[   91.910360]  [<c1456ea5>] ? __cfq_set_active_queue+0x45/0x1d0
[   91.910360]  [<c106059b>] trace_hardirqs_on+0xb/0x10
[   91.910360]  [<c1032c51>] __local_bh_enable_ip+0x61/0xd0
[   91.910360]  [<c1456ef9>] __cfq_set_active_queue+0x99/0x1d0
[   91.910360]  [<c145002f>] ? blkg_create+0x36f/0x4b0
[   91.910360]  [<c1459b16>] ? cfq_add_cfqq_rr+0x66/0xb0
[   91.910360]  [<c1456d94>] ? cfq_update_idle_window.isra.84+0xa4/0xf0
[   91.910360]  [<c1464619>] ? __delay+0x9/0x10
[   91.910360]  [<c14595c4>] cfq_dispatch_requests+0x4d4/0x9c0
[   91.910360]  [<c1023ad3>] ? kvm_clock_read+0x13/0x30
[   91.910360]  [<c1008d38>] ? sched_clock+0x8/0x10
[   91.910360]  [<c1459dbf>] ? cfq_insert_request+0x1af/0x480
[   91.910360]  [<c143dca3>] ? submit_bio+0x43/0xf0
[   91.910360]  [<c1468766>] ? list_sort+0x146/0x1b0
[   91.910360]  [<c143ecf4>] blk_peek_request+0x114/0x1a0
[   91.910360]  [<c1659917>] scsi_request_fn+0x37/0x4d0
[   91.910360]  [<c143cccc>] __blk_run_queue+0x2c/0x40
[   91.910360]  [<c143f39e>] blk_flush_plug_list+0x19e/0x240
[   91.910360]  [<c143f63d>] blk_finish_plug+0xd/0x30
[   91.910360]  [<c10a3761>] __do_page_cache_readahead+0x1e1/0x270
[   91.910360]  [<c10a3626>] ? __do_page_cache_readahead+0xa6/0x270
[   91.910360]  [<c10a3c4c>] force_page_cache_readahead+0x6c/0x90
[   91.910360]  [<c10a3d0d>] page_cache_sync_readahead+0x4d/0x50
[   91.910360]  [<c109ac9a>] generic_file_aio_read+0x54a/0x700
[   91.910360]  [<c10fe52f>] blkdev_aio_read+0x6f/0xb0
[   91.910360]  [<c10d0371>] do_sync_read+0x51/0x80
[   91.910360]  [<c10d0320>] ? no_llseek+0x10/0x10
[   91.910360]  [<c10d0eab>] vfs_read+0x6b/0x110
[   91.910360]  [<c10d129c>] SyS_read+0x4c/0x90
[   91.910360]  [<c200cbca>] sysenter_do_call+0x12/0x3c
[   92.092982] init: Failed to create pty - disabling logging for job
[   92.094569] init: Temporary process spawn error: No such file or directory
[   92.172247] init: Failed to create pty - disabling logging for job

git bisect start v3.13 v3.12 --
git bisect good 3bad8bb5cd3048a67df43ac6b1e2f191f19d9ff0  # 01:27     25+      0  Merge branch 'for-next' of git://git.samba.org/sfrench/cifs-2.6
git bisect  bad dd0508093b79141e0044ca02f0acb6319f69f546  # 01:31      0-      4  Merge branch 'sched-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect  bad 3f02ff5c2c69753666787ed125708d283a823ffb  # 01:35      0-      3  Merge tag 'tty-3.13-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
git bisect good 1ab231b274ba51a54acebec23c6aded0f3cdf54e  # 01:40     25+      0  Merge branch 'timers-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect  bad 5ee540613db504a10e15fafaf4c08cac96aa1823  # 01:45      0-      1  Merge branch 'for-linus' of git://git.kernel.dk/linux-block
git bisect good 53c6de50262a8edd6932bb59a32db7b9d92f8d67  # 01:48     25+      0  Merge branch 'x86/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 59fb2f0e9e30ad99a8bab0ff1efaf8f4a3b7105f  # 01:52     25+      0  Merge tag 'fbdev-fixes-3.13' of git://git.kernel.org/pub/scm/linux/kernel/git/tomba/linux
git bisect good ef1e4e32d595d3e6c9a6d3d2956f087d5886c5e5  # 01:56     25+      0  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
git bisect good 29be6345bbaec8502a70c4e2204d5818b48c4e8f  # 02:00     25+      0  Merge tag 'nfs-for-3.13-3' of git://git.linux-nfs.org/projects/trondmy/linux-nfs
git bisect  bad e345d767f6530ec9cb0aabab7ea248072a9c6975  # 02:04      0-      5  Merge branch 'stable/for-jens-3.13-take-two' of git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip into for-linus
git bisect  bad c170bbb45febc03ac4d34ba2b8bb55e06104b7e7  # 02:07      0-      7  block: submit_bio_wait() conversions
git bisect  bad 2c575026fae6e63771bd2a4c1d407214a8096a89  # 02:10      5-      4  Update of blkg_stat and blkg_rwstat may happen in bh context. While u64_stats_fetch_retry is only preempt_disable on 32bit UP system. This is not enough to avoid preemption by bh and may read strange 64 bit value.
# first bad commit: [2c575026fae6e63771bd2a4c1d407214a8096a89] Update of blkg_stat and blkg_rwstat may happen in bh context. While u64_stats_fetch_retry is only preempt_disable on 32bit UP system. This is not enough to avoid preemption by bh and may read strange 64 bit value.
git bisect good 82023bb7f75b0052f40d3e74169d191c3e4e6286  # 02:15    108+      0  Merge tag 'pm+acpi-2-3.13-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
git bisect  bad 311db85e8948921a53da32bcbf22b988380d948c  # 02:15      0-     19  0day head guard for 'devel-hourly-2014022117'
git bisect good 28007194d83767477f15be95a790446edfcbc383  # 02:21    108+      1  Revert "Update of blkg_stat and blkg_rwstat may happen in bh context."
git bisect  bad 86c7654f4a0afcbbd2fedefec01082f292b14cb4  # 02:26      1-      2  Merge tag 'metag-fixes-v3.14' of git://git.kernel.org/pub/scm/linux/kernel/git/jhogan/metag
git bisect  bad b148a42ba7823e34971cd4e5b05a5c74fa3311ed  # 02:32      3-      4  Add linux-next specific files for 20140228

Thanks,
Fengguang

--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-xian-28:20140224212828:i386-randconfig-st1-02241939:3.14.0-rc3-wl-01773-g311db85:11"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc3-wl-01773-g311db85 (kbuild@stoakley)=
 (gcc version 4.8.1 (Debian 4.8.1-8) ) #11 PREEMPT Mon Feb 24 20:12:56 CST =
2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
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
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x1000000
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
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[c00fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x031fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12400000-0x125fffff]
[    0.000000]  [mem 0x12400000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x123fffff]
[    0.000000]  [mem 0x10000000-0x123fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12600000-0x13ffdfff]
[    0.000000]  [mem 0x12600000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x02c81000, 0x02c81fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
[    0.000000] ACPI: RSDP 0x000FD930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x13FFFF40 000040
[    0.000000] ACPI: SSDT 0x13FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, boot clock
[    0.000000] BRK [0x02c82000, 0x02c82fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   Normal zone: 640 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 81820 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
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
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 2511240
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-st1-02241939/linux-devel:devel-hourly-2014022117/.vmlinu=
z-311db85e8948921a53da32bcbf22b988380d948c-20140224201508-2-xian branch=3Dl=
inux-devel/devel-hourly-2014022117 BOOT_IMAGE=3D/kernel/i386-randconfig-st1=
-02241939/311db85e8948921a53da32bcbf22b988380d948c/vmlinuz-3.14.0-rc3-wl-01=
773-g311db85
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 268448K/327280K available (16437K kernel code, 1017K=
 rwdata, 5048K rodata, 692K init, 5880K bss, 58832K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa1000 - 0xfffff000   ( 376 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xffbfe000   ( 692 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xc25fc000 - 0xc26a9000   ( 692 kB)
[    0.000000]       .data : 0xc200d9d8 - 0xc25fb7a0   (6071 kB)
[    0.000000]       .text : 0xc1000000 - 0xc200d9d8   (16438 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3Dc0090000 soft=3Dc0092000
[    0.000000] ACPI: Core revision 20140114
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc3-wl-01773-g311db85 (kbuild@stoakley)=
 (gcc version 4.8.1 (Debian 4.8.1-8) ) #11 PREEMPT Mon Feb 24 20:12:56 CST =
2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
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
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x1000000
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
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[c00fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x031fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12400000-0x125fffff]
[    0.000000]  [mem 0x12400000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x123fffff]
[    0.000000]  [mem 0x10000000-0x123fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12600000-0x13ffdfff]
[    0.000000]  [mem 0x12600000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x02c81000, 0x02c81fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
[    0.000000] ACPI: RSDP 0x000FD930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE490 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x13FFFF40 000040
[    0.000000] ACPI: SSDT 0x13FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FFF640 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, boot clock
[    0.000000] BRK [0x02c82000, 0x02c82fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   Normal zone: 640 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 81820 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
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
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 2511240
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-st1-02241939/linux-devel:devel-hourly-2014022117/.vmlinu=
z-311db85e8948921a53da32bcbf22b988380d948c-20140224201508-2-xian branch=3Dl=
inux-devel/devel-hourly-2014022117 BOOT_IMAGE=3D/kernel/i386-randconfig-st1=
-02241939/311db85e8948921a53da32bcbf22b988380d948c/vmlinuz-3.14.0-rc3-wl-01=
773-g311db85
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 268448K/327280K available (16437K kernel code, 1017K=
 rwdata, 5048K rodata, 692K init, 5880K bss, 58832K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa1000 - 0xfffff000   ( 376 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xffbfe000   ( 692 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xc25fc000 - 0xc26a9000   ( 692 kB)
[    0.000000]       .data : 0xc200d9d8 - 0xc25fb7a0   (6071 kB)
[    0.000000]       .text : 0xc1000000 - 0xc200d9d8   (16438 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3Dc0090000 soft=3Dc0092000
[    0.000000] ACPI: Core revision 20140114
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] allocated 1048576 bytes of page_cgroup
[    0.000000] allocated 1048576 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2892.998 MHz processor
[    0.000000] tsc: Detected 2892.998 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value..=20
[    0.020000] Calibrating delay loop (skipped) preset value.. 5785.99 Bogo=
MIPS (lpj=3D28929980)
5785.99 BogoMIPS (lpj=3D28929980)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] Mount-cache hash table entries: 512
[    0.020000] Mount-cache hash table entries: 512
[    0.020000] Initializing cgroup subsys debug
[    0.020000] Initializing cgroup subsys debug
[    0.020023] Initializing cgroup subsys memory
[    0.020023] Initializing cgroup subsys memory
[    0.023627] Initializing cgroup subsys devices
[    0.023627] Initializing cgroup subsys devices
[    0.026441] Initializing cgroup subsys freezer
[    0.026441] Initializing cgroup subsys freezer
[    0.030032] Initializing cgroup subsys net_cls
[    0.030032] Initializing cgroup subsys net_cls
[    0.033694] Initializing cgroup subsys blkio
[    0.033694] Initializing cgroup subsys blkio
[    0.036141] mce: CPU supports 10 MCE banks
[    0.036141] mce: CPU supports 10 MCE banks
[    0.040019] mce: unknown CPU type - not enabling MCE support
[    0.040019] mce: unknown CPU type - not enabling MCE support
[    0.043267] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.043267] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.043267] tlb_flushall_shift: -1
[    0.043267] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.043267] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.043267] tlb_flushall_shift: -1
[    0.050016] CPU:=20
[    0.050016] CPU: GenuineIntel GenuineIntel Common KVM processorCommon KV=
M processor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.062802] Performance Events:=20
[    0.062802] Performance Events: no PMU driver, software events only.
no PMU driver, software events only.
[    0.065710] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.065710] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.068137] Getting VERSION: 50014
[    0.068137] Getting VERSION: 50014
[    0.069025] Getting VERSION: 50014
[    0.069025] Getting VERSION: 50014
[    0.070047] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.070047] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.071754] Getting ID: 0
[    0.071754] Getting ID: 0
[    0.072427] Getting ID: f000000
[    0.072427] Getting ID: f000000
[    0.073257] Getting LVT0: 8700
[    0.073257] Getting LVT0: 8700
[    0.074058] Getting LVT1: 8400
[    0.074058] Getting LVT1: 8400
[    0.074916] enabled ExtINT on CPU#0
[    0.074916] enabled ExtINT on CPU#0
[    0.077009] ENABLING IO-APIC IRQs
[    0.077009] ENABLING IO-APIC IRQs
[    0.077903] init IO_APIC IRQs
[    0.077903] init IO_APIC IRQs
[    0.078689]  apic 0 pin 0 not connected
[    0.078689]  apic 0 pin 0 not connected
[    0.079713] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.079713] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.080038] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.080038] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.083067] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.083067] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.085162] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.085162] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.087211] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.087211] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.090039] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.090039] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.092065] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.092065] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.094032] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.094032] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.097108] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.097108] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.100036] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.100036] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.102115] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.102115] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.104223] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.104223] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.106319] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.106319] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.108421] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.108421] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.110043] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.110043] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.112121]  apic 0 pin 16 not connected
[    0.112121]  apic 0 pin 16 not connected
[    0.113137]  apic 0 pin 17 not connected
[    0.113137]  apic 0 pin 17 not connected
[    0.114157]  apic 0 pin 18 not connected
[    0.114157]  apic 0 pin 18 not connected
[    0.115170]  apic 0 pin 19 not connected
[    0.115170]  apic 0 pin 19 not connected
[    0.116190]  apic 0 pin 20 not connected
[    0.116190]  apic 0 pin 20 not connected
[    0.117180]  apic 0 pin 21 not connected
[    0.117180]  apic 0 pin 21 not connected
[    0.120009]  apic 0 pin 22 not connected
[    0.120009]  apic 0 pin 22 not connected
[    0.121044]  apic 0 pin 23 not connected
[    0.121044]  apic 0 pin 23 not connected
[    0.122248] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.122248] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.124807] Using local APIC timer interrupts.
[    0.124807] calibrating APIC timer ...
[    0.124807] Using local APIC timer interrupts.
[    0.124807] calibrating APIC timer ...
[    0.130000] ... lapic delta =3D 6247361
[    0.130000] ... lapic delta =3D 6247361
[    0.130000] ... PM-Timer delta =3D 357849
[    0.130000] ... PM-Timer delta =3D 357849
[    0.130000] ... PM-Timer result ok
[    0.130000] ... PM-Timer result ok
[    0.130000] ..... delta 6247361
[    0.130000] ..... delta 6247361
[    0.130000] ..... mult: 268322111
[    0.130000] ..... mult: 268322111
[    0.130000] ..... calibration result: 9995777
[    0.130000] ..... calibration result: 9995777
[    0.130000] ..... CPU clock speed is 2892.2115 MHz.
[    0.130000] ..... CPU clock speed is 2892.2115 MHz.
[    0.130000] ..... host bus clock speed is 999.5777 MHz.
[    0.130000] ..... host bus clock speed is 999.5777 MHz.
[    0.131935] xor: measuring software checksum speed
[    0.131935] xor: measuring software checksum speed
[    0.230044]    pIII_sse  : 10451.600 MB/sec
[    0.230044]    pIII_sse  : 10451.600 MB/sec
[    0.330014]    prefetch64-sse: 10923.600 MB/sec
[    0.330014]    prefetch64-sse: 10923.600 MB/sec
[    0.332441] xor: using function: prefetch64-sse (10923.600 MB/sec)
[    0.332441] xor: using function: prefetch64-sse (10923.600 MB/sec)
[    0.335800] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.335800] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.339536] NET: Registered protocol family 16
[    0.339536] NET: Registered protocol family 16
[    0.341648] EISA bus registered
[    0.341648] EISA bus registered
[    0.343390] cpuidle: using governor menu
[    0.343390] cpuidle: using governor menu
[    0.346571] ACPI: bus type PCI registered
[    0.346571] ACPI: bus type PCI registered
[    0.350212] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.350212] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.353981] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.353981] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.357282] PCI: Using configuration type 1 for base access
[    0.357282] PCI: Using configuration type 1 for base access
[    0.398030] bio: create slab <bio-0> at 0
[    0.398030] bio: create slab <bio-0> at 0
[    0.570049] raid6: mmxx1     2942 MB/s
[    0.570049] raid6: mmxx1     2942 MB/s
[    0.740034] raid6: mmxx2     3310 MB/s
[    0.740034] raid6: mmxx2     3310 MB/s
[    0.910045] raid6: sse1x1    2328 MB/s
[    0.910045] raid6: sse1x1    2328 MB/s
[    1.080024] raid6: sse1x2    2833 MB/s
[    1.080024] raid6: sse1x2    2833 MB/s
[    1.250019] raid6: sse2x1    3699 MB/s
[    1.250019] raid6: sse2x1    3699 MB/s
[    1.420023] raid6: sse2x2    6005 MB/s
[    1.420023] raid6: sse2x2    6005 MB/s
[    1.422014] raid6: using algorithm sse2x2 (6005 MB/s)
[    1.422014] raid6: using algorithm sse2x2 (6005 MB/s)
[    1.424613] raid6: using intx1 recovery algorithm
[    1.424613] raid6: using intx1 recovery algorithm
[    1.427074] gpio-f7188x: Not a Fintek device at 0x0000002e
[    1.427074] gpio-f7188x: Not a Fintek device at 0x0000002e
[    1.430010] gpio-f7188x: Not a Fintek device at 0x0000004e
[    1.430010] gpio-f7188x: Not a Fintek device at 0x0000004e
[    1.433290] ACPI: Added _OSI(Module Device)
[    1.433290] ACPI: Added _OSI(Module Device)
[    1.435501] ACPI: Added _OSI(Processor Device)
[    1.435501] ACPI: Added _OSI(Processor Device)
[    1.437680] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.437680] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.440012] ACPI: Added _OSI(Processor Aggregator Device)
[    1.440012] ACPI: Added _OSI(Processor Aggregator Device)
[    1.451638] ACPI: Interpreter enabled
[    1.451638] ACPI: Interpreter enabled
[    1.453484] ACPI: (supports S0 S5)
[    1.453484] ACPI: (supports S0 S5)
[    1.455289] ACPI: Using IOAPIC for interrupt routing
[    1.455289] ACPI: Using IOAPIC for interrupt routing
[    1.457861] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    1.457861] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    1.473759] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.473759] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.477240] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    1.477240] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    1.480078] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.480078] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.484357] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    1.484357] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    1.490210] PCI host bridge to bus 0000:00
[    1.490210] PCI host bridge to bus 0000:00
[    1.492231] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.492231] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.495066] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.495066] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.498337] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.498337] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.500019] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.500019] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.503400] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    1.503400] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    1.506766] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.506766] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.510873] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.510873] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.515087] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.515087] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.523669] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    1.523669] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    1.528198] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.528198] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.530491] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    1.530491] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    1.534199] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    1.534199] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    1.538611] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.538611] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.544965] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.544965] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.552069] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.552069] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.565273] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.565273] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.570216] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.570216] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.574754] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    1.574754] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    1.579302] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.579302] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.586859] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    1.586859] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    1.590499] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    1.590499] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    1.594991] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    1.594991] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    1.601399] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    1.601399] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    1.612048] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    1.612048] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    1.616556] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    1.616556] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    1.620711] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    1.620711] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    1.631297] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.631297] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    1.635548] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    1.635548] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    1.640014] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    1.640014] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    1.650738] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.650738] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    1.655115] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    1.655115] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    1.659440] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    1.659440] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    1.670426] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.670426] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    1.674911] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    1.674911] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    1.679379] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    1.679379] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    1.687280] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.687280] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    1.691417] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    1.691417] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    1.695662] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    1.695662] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    1.706952] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    1.706952] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    1.710792] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    1.710792] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    1.720624] pci_bus 0000:00: on NUMA node 0
[    1.720624] pci_bus 0000:00: on NUMA node 0
[    1.724106] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    1.724106] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    1.727558] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    1.727558] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    1.731132] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    1.731132] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    1.734613] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    1.734613] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    1.737785] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    1.737785] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    1.741704] ACPI:=20
[    1.741704] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    1.744709] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.744709] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.748732] vgaarb: loaded
[    1.748732] vgaarb: loaded
[    1.750009] vgaarb: bridge control possible 0000:00:02.0
[    1.750009] vgaarb: bridge control possible 0000:00:02.0
[    1.754049] SCSI subsystem initialized
[    1.754049] SCSI subsystem initialized
[    1.756401] media: Linux media interface: v0.10
[    1.756401] media: Linux media interface: v0.10
[    1.758714] Linux video capture interface: v2.00
[    1.758714] Linux video capture interface: v2.00
[    1.760189] pps_core: LinuxPPS API ver. 1 registered
[    1.760189] pps_core: LinuxPPS API ver. 1 registered
[    1.762750] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.762750] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.767391] PTP clock support registered
[    1.767391] PTP clock support registered
[    1.770077] EDAC MC: Ver: 3.0.0
[    1.770077] EDAC MC: Ver: 3.0.0
[    1.772759] PCI: Using ACPI for IRQ routing
[    1.772759] PCI: Using ACPI for IRQ routing
[    1.774944] PCI: pci_cache_line_size set to 64 bytes
[    1.774944] PCI: pci_cache_line_size set to 64 bytes
[    1.777765] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.777765] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.780047] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    1.780047] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    1.783903] irda_init()
[    1.783903] irda_init()
[    1.785320] NET: Registered protocol family 23
[    1.785320] NET: Registered protocol family 23
[    1.787647] Bluetooth: Core ver 2.19
[    1.787647] Bluetooth: Core ver 2.19
[    1.790187] NET: Registered protocol family 31
[    1.790187] NET: Registered protocol family 31
[    1.792618] Bluetooth: HCI device and connection manager initialized
[    1.792618] Bluetooth: HCI device and connection manager initialized
[    1.796074] Bluetooth: HCI socket layer initialized
[    1.796074] Bluetooth: HCI socket layer initialized
[    1.798559] Bluetooth: L2CAP socket layer initialized
[    1.798559] Bluetooth: L2CAP socket layer initialized
[    1.800111] Bluetooth: SCO socket layer initialized
[    1.800111] Bluetooth: SCO socket layer initialized
[    1.802648] nfc: nfc_init: NFC Core ver 0.1
[    1.802648] nfc: nfc_init: NFC Core ver 0.1
[    1.804911] NET: Registered protocol family 39
[    1.804911] NET: Registered protocol family 39
[    1.811101] Switched to clocksource kvm-clock
[    1.811101] Switched to clocksource kvm-clock
[    1.813982] pnp: PnP ACPI init
[    1.813982] pnp: PnP ACPI init
[    1.815711] ACPI: bus type PNP registered
[    1.815711] ACPI: bus type PNP registered
[    1.818037] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    1.818037] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    1.821150] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.821150] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.824427] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    1.824427] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    1.828346] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.828346] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.831674] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    1.831674] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    1.836100] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.836100] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.839674] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    1.839674] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    1.843820] pnp 00:03: [dma 2]
[    1.843820] pnp 00:03: [dma 2]
[    1.845421] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.845421] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.848842] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    1.848842] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    1.852995] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.852995] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.856494] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    1.856494] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    1.860865] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.860865] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.864765] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.864765] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.868455] pnp: PnP ACPI: found 7 devices
[    1.868455] pnp: PnP ACPI: found 7 devices
[    1.870611] ACPI: bus type PNP unregistered
[    1.870611] ACPI: bus type PNP unregistered
[    1.908593] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.908593] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.911420] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.911420] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.914240] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.914240] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.917401] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.917401] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.920704] NET: Registered protocol family 2
[    1.920704] NET: Registered protocol family 2
[    1.923227] TCP established hash table entries: 4096 (order: 2, 16384 by=
tes)
[    1.923227] TCP established hash table entries: 4096 (order: 2, 16384 by=
tes)
[    1.926086] TCP bind hash table entries: 4096 (order: 5, 147456 bytes)
[    1.926086] TCP bind hash table entries: 4096 (order: 5, 147456 bytes)
[    1.931936] TCP: Hash tables configured (established 4096 bind 4096)
[    1.931936] TCP: Hash tables configured (established 4096 bind 4096)
[    1.934849] TCP: reno registered
[    1.934849] TCP: reno registered
[    1.936281] UDP hash table entries: 256 (order: 2, 20480 bytes)
[    1.936281] UDP hash table entries: 256 (order: 2, 20480 bytes)
[    1.939410] UDP-Lite hash table entries: 256 (order: 2, 20480 bytes)
[    1.939410] UDP-Lite hash table entries: 256 (order: 2, 20480 bytes)
[    1.943047] NET: Registered protocol family 1
[    1.943047] NET: Registered protocol family 1
[    1.945395] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.945395] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.948371] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.948371] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.951495] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.951495] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.954650] pci 0000:00:02.0: Boot video device
[    1.954650] pci 0000:00:02.0: Boot video device
[    1.956925] PCI: CLS 0 bytes, default 64
[    1.956925] PCI: CLS 0 bytes, default 64
[    1.959621] Unpacking initramfs...
[    1.959621] Unpacking initramfs...
[    3.665746] Freeing initrd memory: 24852K (d27ab000 - d3ff0000)
[    3.665746] Freeing initrd memory: 24852K (d27ab000 - d3ff0000)
[    4.391560] DMA-API: preallocated 65536 debug entries
[    4.391560] DMA-API: preallocated 65536 debug entries
[    4.393774] DMA-API: debugging enabled by kernel config
[    4.393774] DMA-API: debugging enabled by kernel config
[    4.396831] Machine check injector initialized
[    4.396831] Machine check injector initialized
[    4.399419] microcode: no support for this CPU vendor
[    4.399419] microcode: no support for this CPU vendor
[    4.405552] PCLMULQDQ-NI instructions are not detected.
[    4.405552] PCLMULQDQ-NI instructions are not detected.
[    4.408517] NatSemi SCx200 Driver
[    4.408517] NatSemi SCx200 Driver
[    4.414143] futex hash table entries: 256 (order: 1, 10240 bytes)
[    4.414143] futex hash table entries: 256 (order: 1, 10240 bytes)
[    4.417755] Initialise system trusted keyring
[    4.417755] Initialise system trusted keyring
[    4.423601] VFS: Disk quotas dquot_6.5.2
[    4.423601] VFS: Disk quotas dquot_6.5.2
[    4.427547] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    4.427547] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    4.431924] DLM installed
[    4.431924] DLM installed
[    4.435236] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    4.435236] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    4.438674] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    4.438674] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    4.441586] jffs2: version 2.2.=20
[    4.441586] jffs2: version 2.2.=20
[    4.444688] QNX4 filesystem 0.2.3 registered.
[    4.444688] QNX4 filesystem 0.2.3 registered.
[    4.447062] QNX6 filesystem 1.0.0 registered.
[    4.447062] QNX6 filesystem 1.0.0 registered.
[    4.449470] fuse init (API version 7.22)
[    4.449470] fuse init (API version 7.22)
[    4.453583] SGI XFS with security attributes, no debug enabled
[    4.453583] SGI XFS with security attributes, no debug enabled
[    4.460665] NILFS version 2 loaded
[    4.460665] NILFS version 2 loaded
[    4.462678] BeFS version: 0.9.3
[    4.462678] BeFS version: 0.9.3
[    4.464754] ocfs2: Registered cluster interface o2cb
[    4.464754] ocfs2: Registered cluster interface o2cb
[    4.469758] ocfs2: Registered cluster interface user
[    4.469758] ocfs2: Registered cluster interface user
[    4.473447] OCFS2 User DLM kernel interface loaded
[    4.473447] OCFS2 User DLM kernel interface loaded
[    4.491272] NET: Registered protocol family 38
[    4.491272] NET: Registered protocol family 38
[    4.494111] Key type asymmetric registered
[    4.494111] Key type asymmetric registered
[    4.496408] Asymmetric key parser 'x509' registered
[    4.496408] Asymmetric key parser 'x509' registered
[    4.499324] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    4.499324] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    4.503656] io scheduler noop registered
[    4.503656] io scheduler noop registered
[    4.505875] io scheduler deadline registered
[    4.505875] io scheduler deadline registered
[    4.508658] io scheduler cfq registered (default)
[    4.508658] io scheduler cfq registered (default)
[    4.511465] test_string_helpers: Running tests...
[    4.511465] test_string_helpers: Running tests...
[    4.523808] no IO addresses supplied
[    4.523808] no IO addresses supplied
[    4.526018] hgafb: HGA card not detected.
[    4.526018] hgafb: HGA card not detected.
[    4.528423] hgafb: probe of hgafb.0 failed with error -22
[    4.528423] hgafb: probe of hgafb.0 failed with error -22
[    4.532033] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    4.532033] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    4.540754] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    4.540754] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    4.544855] ACPI: Power Button [PWRF]
[    4.544855] ACPI: Power Button [PWRF]
[    4.552415] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    4.552415] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    4.555600] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    4.555600] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    4.568364] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    4.568364] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    4.572538] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    4.572538] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    4.582817] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    4.582817] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    4.592654] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    4.592654] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    4.622975] HDLC line discipline maxframe=3D4096
[    4.622975] HDLC line discipline maxframe=3D4096
[    4.625635] N_HDLC line discipline registered.
[    4.625635] N_HDLC line discipline registered.
[    4.628174] r3964: Philips r3964 Driver $Revision: 1.10 $
[    4.628174] r3964: Philips r3964 Driver $Revision: 1.10 $
[    4.631374] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    4.631374] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    4.661050] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    4.661050] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    4.676673] serial: Freescale lpuart driver
[    4.676673] serial: Freescale lpuart driver
[    4.679095] Cyclades driver 2.6
[    4.679095] Cyclades driver 2.6
[    4.707885] MOXA Intellio family driver version 6.0k
[    4.707885] MOXA Intellio family driver version 6.0k
[    4.712874] MOXA Smartio/Industio family driver version 2.0.5
[    4.712874] MOXA Smartio/Industio family driver version 2.0.5
[    4.716071] Initializing Nozomi driver 2.1d
[    4.716071] Initializing Nozomi driver 2.1d
[    4.721909] SyncLink GT
[    4.721909] SyncLink GT
[    4.723338] SyncLink GT, tty major#246
[    4.723338] SyncLink GT, tty major#246
[    4.725562] SyncLink GT no devices found
[    4.725562] SyncLink GT no devices found
[    4.727793] SyncLink MultiPort driver $Revision: 4.38 $
[    4.727793] SyncLink MultiPort driver $Revision: 4.38 $
[    4.787046] SyncLink MultiPort driver $Revision: 4.38 $, tty major#245
[    4.787046] SyncLink MultiPort driver $Revision: 4.38 $, tty major#245
[    4.790798] SyncLink serial driver $Revision: 4.38 $
[    4.790798] SyncLink serial driver $Revision: 4.38 $
[    4.842239] SyncLink serial driver $Revision: 4.38 $, tty major#244
[    4.842239] SyncLink serial driver $Revision: 4.38 $, tty major#244
[    4.848753] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    4.848753] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    4.853872] ac.o: No PCI boards found.
[    4.853872] ac.o: No PCI boards found.
[    4.855965] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    4.855965] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    4.860091] sonypi: Sony Programmable I/O Controller Driver v1.26.
[    4.860091] sonypi: Sony Programmable I/O Controller Driver v1.26.
[    4.863971] Non-volatile memory driver v1.3
[    4.863971] Non-volatile memory driver v1.3
[    4.867406] toshiba: not a supported Toshiba laptop
[    4.867406] toshiba: not a supported Toshiba laptop
[    4.870251] scx200_gpio: no SCx200 gpio present
[    4.870251] scx200_gpio: no SCx200 gpio present
[    4.872892] nsc_gpio initializing
[    4.872892] nsc_gpio initializing
[    4.875665] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    4.875665] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    4.878779] smapi::smapi_init, ERROR invalid usSmapiID
[    4.878779] smapi::smapi_init, ERROR invalid usSmapiID
[    4.882446] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    4.882446] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    4.889017] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    4.889017] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    4.893548] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    4.893548] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    4.906536] Floppy drive(s):
[    4.906536] Floppy drive(s): fd0 is 1.44M fd0 is 1.44M

[    4.940850] loop: module loaded
[    4.940850] loop: module loaded
[    4.942712] HP CISS Driver (v 3.6.26)
[    4.942712] HP CISS Driver (v 3.6.26)
[    4.947750] FDC 0 is a S82078B
[    4.947750] FDC 0 is a S82078B
[    4.959717] MM: desc_per_page =3D 128
[    4.959717] MM: desc_per_page =3D 128
[    4.967983] nbd: registered device at major 43
[    4.967983] nbd: registered device at major 43
[    5.408218] tsc: Refined TSC clocksource calibration: 2892.981 MHz
[    5.408218] tsc: Refined TSC clocksource calibration: 2892.981 MHz
[    5.513467] drbd: initialized. Version: 8.4.3 (api:1/proto:86-101)
[    5.513467] drbd: initialized. Version: 8.4.3 (api:1/proto:86-101)
[    5.516034] drbd: built-in
[    5.516034] drbd: built-in
[    5.517158] drbd: registered as block device major 147
[    5.517158] drbd: registered as block device major 147
[    5.519549] rbd: loaded
[    5.519549] rbd: loaded
[    5.520639] mtip32xx Version 1.3.0
[    5.520639] mtip32xx Version 1.3.0
[    5.524454] blk-mq: CPU -> queue map
[    5.524454] blk-mq: CPU -> queue map
[    5.526042]   CPU 0 -> Queue 0
[    5.526042]   CPU 0 -> Queue 0
[    5.530816]  nullb0: unknown partition table
[    5.530816]  nullb0: unknown partition table
[    5.535195] blk-mq: CPU -> queue map
[    5.535195] blk-mq: CPU -> queue map
[    5.536755]   CPU 0 -> Queue 0
[    5.536755]   CPU 0 -> Queue 0
[    5.541232]  nullb1: unknown partition table
[    5.541232]  nullb1: unknown partition table
[    5.545502] null: module loaded
[    5.545502] null: module loaded
[    5.546945] dummy-irq: no IRQ given.  Use irq=3DN
[    5.546945] dummy-irq: no IRQ given.  Use irq=3DN
[    5.549129] Phantom Linux Driver, version n0.9.8, init OK
[    5.549129] Phantom Linux Driver, version n0.9.8, init OK
[    5.554009] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    5.554009] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    5.557381] c2port c2port0: C2 port uc added
[    5.557381] c2port c2port0: C2 port uc added
[    5.559272] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    5.559272] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    5.564916] Guest personality initialized and is inactive
[    5.564916] Guest personality initialized and is inactive
[    5.567409] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D58)
[    5.567409] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D58)
[    5.570365] Initialized host personality
[    5.570365] Initialized host personality
[    5.578707] Uniform Multi-Platform E-IDE driver
[    5.578707] Uniform Multi-Platform E-IDE driver
[    5.582998] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[    5.582998] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[    5.586083] piix 0000:00:01.1: not 100% native mode: will probe irqs lat=
er
[    5.586083] piix 0000:00:01.1: not 100% native mode: will probe irqs lat=
er
[    5.590915]     ide0: BM-DMA at 0xc1c0-0xc1c7
[    5.590915]     ide0: BM-DMA at 0xc1c0-0xc1c7
[    5.592833]     ide1: BM-DMA at 0xc1c8-0xc1cf
[    5.592833]     ide1: BM-DMA at 0xc1c8-0xc1cf
[    5.594665] Probing IDE interface ide0...
[    5.594665] Probing IDE interface ide0...
[    6.197213] Probing IDE interface ide1...
[    6.197213] Probing IDE interface ide1...
[    6.986842] hdc: QEMU DVD-ROM, ATAPI=20
[    6.986842] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROMCD/DVD-ROM drive
 drive
[    7.708516] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[    7.708516] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[    7.710343] hdc: MWDMA2 mode selected
[    7.710343] hdc: MWDMA2 mode selected
[    7.713456] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    7.713456] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14

[    7.716223] ide1 at 0x170-0x177,0x376 on irq 15
[    7.716223] ide1 at 0x170-0x177,0x376 on irq 15

[    7.745947] ide-gd driver 1.18
[    7.745947] ide-gd driver 1.18
[    7.749064] ide-cd driver 5.00
[    7.749064] ide-cd driver 5.00
[    7.753804] ide-cd: hdc: ATAPI
[    7.753804] ide-cd: hdc: ATAPI 4X 4X DVD-ROM DVD-ROM drive drive, 512kB =
Cache
, 512kB Cache
[    7.760180] cdrom: Uniform CD-ROM driver Revision: 3.20
[    7.760180] cdrom: Uniform CD-ROM driver Revision: 3.20
[    7.801865] Loading iSCSI transport class v2.0-870.
[    7.801865] Loading iSCSI transport class v2.0-870.
[    7.810543] bnx2fc: Broadcom NetXtreme II FCoE Driver bnx2fc v2.4.1 (Sep=
 17, 2013)
[    7.810543] bnx2fc: Broadcom NetXtreme II FCoE Driver bnx2fc v2.4.1 (Sep=
 17, 2013)
[    7.825928] iscsi: registered transport (tcp)
[    7.825928] iscsi: registered transport (tcp)
[    7.869612] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[    7.869612] Loading Adaptec I2O RAID: Version 2.4 Build 5go
[    7.875877] Detecting Adaptec I2O RAID controllers...
[    7.875877] Detecting Adaptec I2O RAID controllers...
[    7.883908] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    7.883908] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    7.897932] isci: Intel(R) C600 SAS Controller Driver - version 1.1.0
[    7.897932] isci: Intel(R) C600 SAS Controller Driver - version 1.1.0
[    7.908781] scsi: <fdomain> Detection failed (no card)
[    7.908781] scsi: <fdomain> Detection failed (no card)
[    7.916134] NCR53c406a: no available ports found
[    7.916134] NCR53c406a: no available ports found
[    7.922293] sym53c416.c: Version 1.0.0-ac
[    7.922293] sym53c416.c: Version 1.0.0-ac
[    7.923610] iscsi: registered transport (qla4xxx)
[    7.923610] iscsi: registered transport (qla4xxx)
[    7.924986] QLogic iSCSI HBA Driver
[    7.924986] QLogic iSCSI HBA Driver
[    7.931747] Brocade BFA FC/FCOE SCSI driver - version: 3.2.23.0
[    7.931747] Brocade BFA FC/FCOE SCSI driver - version: 3.2.23.0
[    7.978596] Failed initialization of WD-7000 SCSI card!
[    7.978596] Failed initialization of WD-7000 SCSI card!
[    9.130911] DC390: clustering now enabled by default. If you get problem=
s load
[    9.130911] DC390: clustering now enabled by default. If you get problem=
s load
[    9.134847]        with "disable_clustering=3D1" and report to maintaine=
rs
[    9.134847]        with "disable_clustering=3D1" and report to maintaine=
rs
[    9.138320] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 ES=
T 2006)
[    9.138320] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 ES=
T 2006)
[    9.142282] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 20=
06)
[    9.142282] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 20=
06)
[    9.148522] megasas: 06.700.06.00-rc1 Sat. Aug. 31 17:00:00 PDT 2013
[    9.148522] megasas: 06.700.06.00-rc1 Sat. Aug. 31 17:00:00 PDT 2013
[    9.152033] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    9.152033] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    9.155214] 3ware Storage Controller device driver for Linux v1.26.02.00=
3.
[    9.155214] 3ware Storage Controller device driver for Linux v1.26.02.00=
3.
[    9.161545] 3ware 9000 Storage Controller device driver for Linux v2.26.=
02.014.
[    9.161545] 3ware 9000 Storage Controller device driver for Linux v2.26.=
02.014.
[    9.165490] LSI 3ware SAS/SATA-RAID Controller device driver for Linux v=
3.26.02.000.
[    9.165490] LSI 3ware SAS/SATA-RAID Controller device driver for Linux v=
3.26.02.000.
[    9.169493] nsp32: loading...
[    9.169493] nsp32: loading...
[    9.171068] RocketRAID 3xxx/4xxx Controller driver v1.8
[    9.171068] RocketRAID 3xxx/4xxx Controller driver v1.8
[    9.176280] libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age =
0xf, 4 bits.
[    9.176280] libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age =
0xf, 4 bits.
[    9.180724] libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx=
 0.
[    9.180724] libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx=
 0.
[    9.184556] Chelsio T3 iSCSI Driver cxgb3i v2.0.0 (Jun. 2010)
[    9.184556] Chelsio T3 iSCSI Driver cxgb3i v2.0.0 (Jun. 2010)
[    9.187596] iscsi: registered transport (cxgb3i)
[    9.187596] iscsi: registered transport (cxgb3i)
[    9.190126] Chelsio T4/T5 iSCSI Driver cxgb4i v0.9.4
[    9.190126] Chelsio T4/T5 iSCSI Driver cxgb4i v0.9.4
[    9.193115] iscsi: registered transport (cxgb4i)
[    9.193115] iscsi: registered transport (cxgb4i)
[    9.195676] esas2r: driver will not be loaded because no ATTO esas2r dev=
ices were found
[    9.195676] esas2r: driver will not be loaded because no ATTO esas2r dev=
ices were found
[    9.200182] VMware PVSCSI driver - version 1.0.2.0-k
[    9.200182] VMware PVSCSI driver - version 1.0.2.0-k
[    9.202726] osst :I: Tape driver with OnStream support version 0.99.4
[    9.202726] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    9.202726] osst :I: Tape driver with OnStream support version 0.99.4
[    9.202726] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    9.212081] SCSI Media Changer driver v0.25=20
[    9.212081] SCSI Media Changer driver v0.25=20
[    9.229981] scsi_debug: host protection
[    9.229981] scsi_debug: host protection
[    9.231988] scsi2 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[    9.231988] scsi2 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[    9.239108] scsi 2:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[    9.239108] scsi 2:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[    9.252501] SSFDC read-only Flash Translation layer
[    9.252501] SSFDC read-only Flash Translation layer
[    9.255633] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    9.255633] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    9.259363] sd 2:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.=
00 MiB)
[    9.259363] sd 2:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.=
00 MiB)
[    9.264335] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    9.264335] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    9.268333] sd 2:0:0:0: [sda] Write Protect is off
[    9.268333] sd 2:0:0:0: [sda] Write Protect is off
[    9.271262] sd 2:0:0:0: [sda] Mode Sense: 73 00 10 08
[    9.271262] sd 2:0:0:0: [sda] Mode Sense: 73 00 10 08
[    9.274047] Could not find PAR responsible for SC520CDP Flash Bank #1
[    9.274047] Could not find PAR responsible for SC520CDP Flash Bank #1
[    9.280062] Trying default address 0x8c00000
[    9.280062] Trying default address 0x8c00000
[    9.282417] SC520 CDP flash device: 0x800000 at 0x8800000
[    9.282417] SC520 CDP flash device: 0x800000 at 0x8800000
[    9.285239] Failed to ioremap_nocache
[    9.285239] Failed to ioremap_nocache
[    9.287312] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[    9.287312] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[    9.346637] No valid DiskOnChip devices found
[    9.346637] No valid DiskOnChip devices found
[    9.357946]  sda: unknown partition table
[    9.357946]  sda: unknown partition table
[    9.375627] arcnet loaded.
[    9.375627] arcnet loaded.
[    9.377409] arcnet: RFC1201 "standard" (`a') encapsulation support loade=
d.
[    9.377409] arcnet: RFC1201 "standard" (`a') encapsulation support loade=
d.
[    9.381341] arcnet: RFC1051 "simple standard" (`s') encapsulation suppor=
t loaded.
[    9.381341] arcnet: RFC1051 "simple standard" (`s') encapsulation suppor=
t loaded.
[    9.385256] arcnet: raw mode (`r') encapsulation support loaded.
[    9.385256] arcnet: raw mode (`r') encapsulation support loaded.
[    9.388945] arcnet: RIM I (entirely mem-mapped) support
[    9.388945] arcnet: RIM I (entirely mem-mapped) support
[    9.391774] E-mail me if you actually test the RIM I driver, please!
[    9.391774] E-mail me if you actually test the RIM I driver, please!
[    9.395233] Given: node 00h, shmem 0h, irq 0
[    9.395233] Given: node 00h, shmem 0h, irq 0
[    9.399941] No autoprobe for RIM I; you must specify the shmem and irq!
[    9.399941] No autoprobe for RIM I; you must specify the shmem and irq!
[    9.403370] arcnet: COM20020 ISA support (by David Woodhouse et al.)
[    9.403370] arcnet: COM20020 ISA support (by David Woodhouse et al.)
[    9.409487]  arc%d: No autoprobe (yet) for IO mapped cards; you must spe=
cify the base address!
[    9.409487]  arc%d: No autoprobe (yet) for IO mapped cards; you must spe=
cify the base address!
[    9.416988] sd 2:0:0:0: [sda] Attached SCSI disk
[    9.416988] sd 2:0:0:0: [sda] Attached SCSI disk
[    9.460069] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    9.460069] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    9.462840] Copyright (c) 2007 Atheros Corporation.
[    9.462840] Copyright (c) 2007 Atheros Corporation.
[    9.468159] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.19 (Decemb=
er 19, 2013)
[    9.468159] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.19 (Decemb=
er 19, 2013)
[    9.472233] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ether=
net Driver bnx2x 1.78.19-0 (2014/02/10)
[    9.472233] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ether=
net Driver bnx2x 1.78.19-0 (2014/02/10)
[    9.478053] Brocade 10G Ethernet driver - version: 3.2.23.0
[    9.478053] Brocade 10G Ethernet driver - version: 3.2.23.0
[    9.486990] jme: JMicron JMC2XX ethernet driver version 1.0.8
[    9.486990] jme: JMicron JMC2XX ethernet driver version 1.0.8
[    9.495364] QLogic 1/10 GbE Converged/Intelligent Ethernet Driver v5.3.55
[    9.495364] QLogic 1/10 GbE Converged/Intelligent Ethernet Driver v5.3.55
[    9.499056] QLogic/NetXen Network Driver v4.0.82
[    9.499056] QLogic/NetXen Network Driver v4.0.82
[    9.504384] Solarflare NET driver v4.0
[    9.504384] Solarflare NET driver v4.0
[    9.509352] tlan: ThunderLAN driver v1.17
[    9.509352] tlan: ThunderLAN driver v1.17
[    9.511471] tlan: 0 devices installed, PCI: 0  EISA: 0
[    9.511471] tlan: 0 devices installed, PCI: 0  EISA: 0
[    9.517102] w83977af_init()
[    9.517102] w83977af_init()
[    9.518537] w83977af_open()
[    9.518537] w83977af_open()
[    9.520022] w83977af_probe()
[    9.520022] w83977af_probe()
[    9.521553] w83977af_probe(), Wrong chip version
[    9.521553] w83977af_probe(), Wrong chip version

[    9.523632] w83977af_probe()
[    9.523632] w83977af_probe()
[    9.525500] w83977af_probe(), Wrong chip version
[    9.525500] w83977af_probe(), Wrong chip version

[    9.528336] VMware vmxnet3 virtual NIC driver - version 1.2.0.0-k-NAPI
[    9.528336] VMware vmxnet3 virtual NIC driver - version 1.2.0.0-k-NAPI
[    9.531944] Fusion MPT base driver 3.04.20
[    9.531944] Fusion MPT base driver 3.04.20
[    9.534026] Copyright (c) 1999-2008 LSI Corporation
[    9.534026] Copyright (c) 1999-2008 LSI Corporation
[    9.536565] Fusion MPT SPI Host driver 3.04.20
[    9.536565] Fusion MPT SPI Host driver 3.04.20
[    9.541233] Fusion MPT FC Host driver 3.04.20
[    9.541233] Fusion MPT FC Host driver 3.04.20
[    9.543465] Fusion MPT SAS Host driver 3.04.20
[    9.543465] Fusion MPT SAS Host driver 3.04.20
[    9.546046] Fusion MPT misc device (ioctl) driver 3.04.20
[    9.546046] Fusion MPT misc device (ioctl) driver 3.04.20
[    9.548799] mptctl: Registered with Fusion MPT base driver
[    9.548799] mptctl: Registered with Fusion MPT base driver
[    9.551604] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[    9.551604] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[    9.559950] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    9.559950] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    9.565733] serio: i8042 KBD port at 0x60,0x64 irq 1
[    9.565733] serio: i8042 KBD port at 0x60,0x64 irq 1
[    9.570926] serio: i8042 AUX port at 0x60,0x64 irq 12
[    9.570926] serio: i8042 AUX port at 0x60,0x64 irq 12
[    9.656177] mousedev: PS/2 mouse device common for all mice
[    9.656177] mousedev: PS/2 mouse device common for all mice
[    9.659103] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    9.659103] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[    9.666515] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    9.666515] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    9.672045] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    9.672045] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    9.691438] rtc-test rtc-test.0: rtc core: registered test as rtc0
[    9.691438] rtc-test rtc-test.0: rtc core: registered test as rtc0
[    9.695678] rtc-test rtc-test.1: rtc core: registered test as rtc1
[    9.695678] rtc-test rtc-test.1: rtc core: registered test as rtc1
[    9.701153] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[    9.701153] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[    9.708523] i2c-parport-light: adapter type unspecified
[    9.708523] i2c-parport-light: adapter type unspecified
[    9.710182] isa i2c-pca-isa.0: Please specify I/O base
[    9.710182] isa i2c-pca-isa.0: Please specify I/O base
[    9.711687] scx200_i2c: no SCx200 gpio pins available
[    9.711687] scx200_i2c: no SCx200 gpio pins available
[    9.725564] lirc_dev: IR Remote Control driver registered, major 236=20
[    9.725564] lirc_dev: IR Remote Control driver registered, major 236=20
[    9.727493] IR NEC protocol handler initialized
[    9.727493] IR NEC protocol handler initialized
[    9.728792] IR RC6 protocol handler initialized
[    9.728792] IR RC6 protocol handler initialized
[    9.730083] IR JVC protocol handler initialized
[    9.730083] IR JVC protocol handler initialized
[    9.731379] IR Sony protocol handler initialized
[    9.731379] IR Sony protocol handler initialized
[    9.732710] IR RC5 (streamzap) protocol handler initialized
[    9.732710] IR RC5 (streamzap) protocol handler initialized
[    9.734388] IR SANYO protocol handler initialized
[    9.734388] IR SANYO protocol handler initialized
[    9.735763] IR LIRC bridge handler initialized
[    9.735763] IR LIRC bridge handler initialized
[    9.737037] Marvell M88ALP01 'CAFE' Camera Controller version 2
[    9.737037] Marvell M88ALP01 'CAFE' Camera Controller version 2
[    9.741032] saa7146: register extension 'budget_av'
[    9.741032] saa7146: register extension 'budget_av'
[    9.744700] nGene PCIE bridge driver, Copyright (C) 2005-2007 Micronas
[    9.744700] nGene PCIE bridge driver, Copyright (C) 2005-2007 Micronas
[    9.747137] saa7146: register extension 'Multimedia eXtension Board'
[    9.747137] saa7146: register extension 'Multimedia eXtension Board'
[    9.749524] ivtv: Start initialization, version 1.4.3
[    9.749524] ivtv: Start initialization, version 1.4.3
[    9.751328] ivtv: End initialization
[    9.751328] ivtv: End initialization
[    9.753269] ivtvfb:  no cards found
[    9.753269] ivtvfb:  no cards found
[    9.754354] Zoran MJPEG board driver version 0.10.1
[    9.754354] Zoran MJPEG board driver version 0.10.1
[    9.756078] Linux video codec intermediate layer: v0.2
[    9.756078] Linux video codec intermediate layer: v0.2
[    9.758064] cx18:  Start initialization, version 1.5.1
[    9.758064] cx18:  Start initialization, version 1.5.1
[    9.759860] cx18:  End initialization
[    9.759860] cx18:  End initialization
[    9.765058] cx2388x blackbird driver version 0.0.9 loaded
[    9.765058] cx2388x blackbird driver version 0.0.9 loaded
[    9.766944] cx88/2: registering cx8802 driver, type: blackbird access: s=
hared
[    9.766944] cx88/2: registering cx8802 driver, type: blackbird access: s=
hared
[    9.769235] cx88/2: cx2388x dvb driver version 0.0.9 loaded
[    9.769235] cx88/2: cx2388x dvb driver version 0.0.9 loaded
[    9.771043] cx88/2: registering cx8802 driver, type: dvb access: shared
[    9.771043] cx88/2: registering cx8802 driver, type: dvb access: shared
[    9.773457] pps pps0: new PPS source ktimer
[    9.773457] pps pps0: new PPS source ktimer
[    9.774887] pps pps0: ktimer PPS source registered
[    9.774887] pps pps0: ktimer PPS source registered
[    9.776536] pps_ldisc: PPS line discipline registered
[    9.776536] pps_ldisc: PPS line discipline registered
[    9.781361] Driver for 1-wire Dallas network protocol.
[    9.781361] Driver for 1-wire Dallas network protocol.
[    9.785642] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    9.785642] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    9.787625] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    9.787625] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[   12.324516] i2c i2c-0: detect fail: address match, 0x2c
[   12.324516] i2c i2c-0: detect fail: address match, 0x2c
[   12.364497] i2c i2c-0: detect fail: address match, 0x2d
[   12.364497] i2c i2c-0: detect fail: address match, 0x2d
[   12.404890] i2c i2c-0: detect fail: address match, 0x2e
[   12.404890] i2c i2c-0: detect fail: address match, 0x2e
[   12.445377] i2c i2c-0: detect fail: address match, 0x2f
[   12.445377] i2c i2c-0: detect fail: address match, 0x2f
[   12.744332] applesmc: supported laptop not found!
[   12.744332] applesmc: supported laptop not found!
[   12.746569] applesmc: driver init failed (ret=3D-19)!
[   12.746569] applesmc: driver init failed (ret=3D-19)!
[   31.496601] Bluetooth: Virtual HCI driver ver 1.4
[   31.496601] Bluetooth: Virtual HCI driver ver 1.4
[   31.499786] Bluetooth: HCI UART driver ver 2.2
[   31.499786] Bluetooth: HCI UART driver ver 2.2
[   31.500922] Bluetooth: HCI H4 protocol initialized
[   31.500922] Bluetooth: HCI H4 protocol initialized
[   31.502349] Bluetooth: HCI BCSP protocol initialized
[   31.502349] Bluetooth: HCI BCSP protocol initialized
[   31.503511] Bluetooth: HCILL protocol initialized
[   31.503511] Bluetooth: HCILL protocol initialized
[   31.504809] Bluetooth: HCI Three-wire UART (H5) protocol initialized
[   31.504809] Bluetooth: HCI Three-wire UART (H5) protocol initialized
[   31.531992] ISDN subsystem Rev: 1.1.2.3/
[   31.531992] ISDN subsystem Rev: 1.1.2.3/1.1.2.2/1.1.2.2/none/none/1.1.2.=
2/1.1.2.2/1.1.2.21.1.2.2

[   31.533822] CAPI 2.0 started up with major 68 (no middleware)
[   31.533822] CAPI 2.0 started up with major 68 (no middleware)
[   31.535351] Modular ISDN core version 1.1.29
[   31.535351] Modular ISDN core version 1.1.29
[   31.538393] NET: Registered protocol family 34
[   31.538393] NET: Registered protocol family 34
[   31.539601] DSP module 2.0
[   31.539601] DSP module 2.0
[   31.540377] mISDN_dsp: DSP clocks every 80 samples. This equals 1 jiffie=
s.
[   31.540377] mISDN_dsp: DSP clocks every 80 samples. This equals 1 jiffie=
s.
[   31.544281] b1isa: revision 1.1.2.3
[   31.544281] b1isa: revision 1.1.2.3
[   31.545516] b1: revision 1.1.2.2
[   31.545516] b1: revision 1.1.2.2
[   31.546499] t1pci: revision 1.1.2.2
[   31.546499] t1pci: revision 1.1.2.2
[   31.547597] b1dma: revision 1.1.2.3
[   31.547597] b1dma: revision 1.1.2.3
[   31.548858] c4: revision 1.1.2.2
[   31.548858] c4: revision 1.1.2.2
[   31.549991] mISDN: HFC-multi driver 2.03
[   31.549991] mISDN: HFC-multi driver 2.03
[   31.553343] AVM Fritz PCI driver Rev. 2.3
[   31.553343] AVM Fritz PCI driver Rev. 2.3
[   31.554323] Sedlbauer Speedfax+ Driver Rev. 2.0
[   31.554323] Sedlbauer Speedfax+ Driver Rev. 2.0
[   31.555588] Infineon ISDN Driver Rev. 1.0
[   31.555588] Infineon ISDN Driver Rev. 1.0
[   31.556582] Winbond W6692 PCI driver Rev. 2.0
[   31.556582] Winbond W6692 PCI driver Rev. 2.0
[   31.557686] Netjet PCI driver Rev. 2.0
[   31.557686] Netjet PCI driver Rev. 2.0
[   31.560605] mISDNipac module version 2.0
[   31.560605] mISDNipac module version 2.0
[   31.561542] mISDN: ISAR driver Rev. 2.1
[   31.561542] mISDN: ISAR driver Rev. 2.1
[   31.562543] dss1_divert module successfully installed
[   31.562543] dss1_divert module successfully installed
[   31.563775] HiSax: Linux Driver for passive ISDN cards
[   31.563775] HiSax: Linux Driver for passive ISDN cards
[   31.565021] HiSax: Version 3.5 (kernel)
[   31.565021] HiSax: Version 3.5 (kernel)
[   31.565989] HiSax: Layer1 Revision 2.46.2.5
[   31.565989] HiSax: Layer1 Revision 2.46.2.5
[   31.566984] HiSax: Layer2 Revision 2.30.2.4
[   31.566984] HiSax: Layer2 Revision 2.30.2.4
[   31.568006] HiSax: TeiMgr Revision 2.20.2.3
[   31.568006] HiSax: TeiMgr Revision 2.20.2.3
[   31.568967] HiSax: Layer3 Revision 2.22.2.3
[   31.568967] HiSax: Layer3 Revision 2.22.2.3
[   31.569960] HiSax: LinkLayer Revision 2.59.2.4
[   31.569960] HiSax: LinkLayer Revision 2.59.2.4
[   31.571055] HiSax: Total 1 card defined
[   31.571055] HiSax: Total 1 card defined
[   31.572118] HiSax: Card 1 Protocol EDSS1 Id=3DHiSax (0)
[   31.572118] HiSax: Card 1 Protocol EDSS1 Id=3DHiSax (0)
[   31.573329] HiSax: W6692 driver Rev. 1.18.2.4
[   31.573329] HiSax: W6692 driver Rev. 1.18.2.4
[   31.574374] W6692: No PCI card found
[   31.574374] W6692: No PCI card found
[   31.575500] HiSax: Card Winbond 6692 not installed !
[   31.575500] HiSax: Card Winbond 6692 not installed !
[   31.576634] HFC-4S/8S: Layer 1 driver module for HFC-4S/8S isdn chips, R=
evision: 1.10
[   31.576634] HFC-4S/8S: Layer 1 driver module for HFC-4S/8S isdn chips, R=
evision: 1.10
[   31.578322] HFC-4S/8S: (C) 2003 Cornelius Consult, www.cornelius-consult=
=2Ede
[   31.578322] HFC-4S/8S: (C) 2003 Cornelius Consult, www.cornelius-consult=
=2Ede
[   31.580162] HFC-4S/8S: found 0 cards
[   31.580162] HFC-4S/8S: found 0 cards
[   31.581114] PCBIT-D device driver v 0.5-fjpc0 19991204 - Copyright (C) 1=
996 Universidade de Lisboa
[   31.581114] PCBIT-D device driver v 0.5-fjpc0 19991204 - Copyright (C) 1=
996 Universidade de Lisboa
[   31.582993] Trying to detect board using default settings
[   31.582993] Trying to detect board using default settings
[   31.584874] isdnloop: (loop0) virtual card added
[   31.584874] isdnloop: (loop0) virtual card added
[   31.598207] lguest: mapped switcher at fff9d000
[   31.598207] lguest: mapped switcher at fff9d000
[   31.603666] leds_ss4200: no LED devices found
[   31.603666] leds_ss4200: no LED devices found
[   39.622850]  (null): enodev DEV ADDR =3D 0xFF
[   39.622850]  (null): enodev DEV ADDR =3D 0xFF
[   39.624761] ledtrig-cpu: registered to indicate activity on CPUs
[   39.624761] ledtrig-cpu: registered to indicate activity on CPUs
[   39.648859] rts5208: Initializing Realtek PCIE storage driver...
[   39.648859] rts5208: Initializing Realtek PCIE storage driver...
[   39.654033] Loading crystalhd 0.9.27
[   39.654033] Loading crystalhd 0.9.27
[   39.669722] ion_chunk_heap_create: base 167772160 size 4194304 align 163=
84
[   39.669722] ion_chunk_heap_create: base 167772160 size 4194304 align 163=
84
[   39.675236] logger: created 256K log 'log_main'
[   39.675236] logger: created 256K log 'log_main'
[   39.679344] logger: created 256K log 'log_events'
[   39.679344] logger: created 256K log 'log_events'
[   39.680957] logger: created 256K log 'log_radio'
[   39.680957] logger: created 256K log 'log_radio'
[   39.682868] logger: created 256K log 'log_system'
[   39.682868] logger: created 256K log 'log_system'
[   39.687597] dgnc:=20
[   39.687597] dgnc: dgnc-1.3-16, Digi International Part Number 40002369_F
dgnc-1.3-16, Digi International Part Number 40002369_F
[   39.690867] dgnc:=20
[   39.690867] dgnc: For the tools package or updated drivers please visit =
http://www.digi.com
For the tools package or updated drivers please visit http://www.digi.com
[   39.699713] dgap:=20
[   39.699713] dgap: dgap-1.3-16, Digi International Part Number 40002347_C
dgap-1.3-16, Digi International Part Number 40002347_C
[   39.702198] dgap:=20
[   39.702198] dgap: For the tools package or updated drivers please visit =
http://www.digi.com
For the tools package or updated drivers please visit http://www.digi.com
[   39.707464] goldfish_pdev_bus goldfish_pdev_bus: unable to reserve Goldf=
ish MMIO.
[   39.707464] goldfish_pdev_bus goldfish_pdev_bus: unable to reserve Goldf=
ish MMIO.
[   39.710515] goldfish_pdev_bus: probe of goldfish_pdev_bus failed with er=
ror -16
[   39.710515] goldfish_pdev_bus: probe of goldfish_pdev_bus failed with er=
ror -16
[   39.716644]  fake-fmc-carrier: mezzanine 0
[   39.716644]  fake-fmc-carrier: mezzanine 0
[   39.718613]       Manufacturer: fake-vendor
[   39.718613]       Manufacturer: fake-vendor
[   39.720491]       Product name: fake-design-for-testing
[   39.720491]       Product name: fake-design-for-testing
[   39.722853] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   39.722853] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   39.725593] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eep=
rom: no busid passed, refusing all cards
[   39.725593] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eep=
rom: no busid passed, refusing all cards
[   39.729899] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   39.729899] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   39.732501] fmc_chardev fake-design-for-testing-f001: Created misc devic=
e "fake-design-for-testing-f001"
[   39.732501] fmc_chardev fake-design-for-testing-f001: Created misc devic=
e "fake-design-for-testing-f001"
[   39.739455] oprofile: using timer interrupt.
[   39.739455] oprofile: using timer interrupt.
[   39.741390] pktgen: Packet Generator for packet performance testing. Ver=
sion: 2.74
[   39.741390] pktgen: Packet Generator for packet performance testing. Ver=
sion: 2.74
[   39.744069] NET: Registered protocol family 26
[   39.744069] NET: Registered protocol family 26
[   39.745299] gre: GRE over IPv4 demultiplexor driver
[   39.745299] gre: GRE over IPv4 demultiplexor driver
[   39.746786] TCP: cubic registered
[   39.746786] TCP: cubic registered
[   39.747962] Initializing XFRM netlink socket
[   39.747962] Initializing XFRM netlink socket
[   39.749763] NET: Registered protocol family 10
[   39.749763] NET: Registered protocol family 10
[   39.756399] sit: IPv6 over IPv4 tunneling driver
[   39.756399] sit: IPv6 over IPv4 tunneling driver
[   39.766335] ip6_gre: GRE over IPv6 tunneling driver
[   39.766335] ip6_gre: GRE over IPv6 tunneling driver
[   39.772273] NET: Registered protocol family 17
[   39.772273] NET: Registered protocol family 17
[   39.776024] NET: Registered protocol family 15
[   39.776024] NET: Registered protocol family 15
[   39.783073] IrCOMM protocol (Dag Brattli)
[   39.783073] IrCOMM protocol (Dag Brattli)
[   39.797540] Bluetooth: RFCOMM socket layer initialized
[   39.797540] Bluetooth: RFCOMM socket layer initialized
[   39.799892] Bluetooth: RFCOMM ver 1.11
[   39.799892] Bluetooth: RFCOMM ver 1.11
[   39.805444] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   39.805444] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   39.807540] Bluetooth: BNEP filters: protocol=20
[   39.807540] Bluetooth: BNEP filters: protocol=20
[   39.809205] Bluetooth: BNEP socket layer initialized
[   39.809205] Bluetooth: BNEP socket layer initialized
[   39.811120] Bluetooth: CMTP (CAPI Emulation) ver 1.0
[   39.811120] Bluetooth: CMTP (CAPI Emulation) ver 1.0
[   39.813090] Bluetooth: CMTP socket layer initialized
[   39.813090] Bluetooth: CMTP socket layer initialized
[   39.815012] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   39.815012] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   39.817164] Bluetooth: HIDP socket layer initialized
[   39.817164] Bluetooth: HIDP socket layer initialized
[   39.819105] NET: Registered protocol family 33
[   39.819105] NET: Registered protocol family 33
[   39.820694] Key type rxrpc registered
[   39.820694] Key type rxrpc registered
[   39.821864] Key type rxrpc_s registered
[   39.821864] Key type rxrpc_s registered
[   39.823585] RxRPC: Registered security type 2 'rxkad'
[   39.823585] RxRPC: Registered security type 2 'rxkad'
[   39.825352] l2tp_core: L2TP core driver, V2.0
[   39.825352] l2tp_core: L2TP core driver, V2.0
[   39.826758] l2tp_debugfs: L2TP debugfs support
[   39.826758] l2tp_debugfs: L2TP debugfs support
[   39.828163] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[   39.828163] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[   39.830738] DECnet: Routing cache hash table of 256 buckets, 9Kbytes
[   39.830738] DECnet: Routing cache hash table of 256 buckets, 9Kbytes
[   39.832989] NET: Registered protocol family 12
[   39.832989] NET: Registered protocol family 12
[   39.834575] NET: Registered protocol family 35
[   39.834575] NET: Registered protocol family 35
[   39.836910] DCCP: Activated CCID 2 (TCP-like)
[   39.836910] DCCP: Activated CCID 2 (TCP-like)
[   39.838348] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
[   39.838348] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
[   39.840945] sctp: Hash tables configured (established 4096 bind 3640)
[   39.840945] sctp: Hash tables configured (established 4096 bind 3640)
[   39.847656] NET: Registered protocol family 21
[   39.847656] NET: Registered protocol family 21
[   39.849320] tipc: Activated (version 2.0.0)
[   39.849320] tipc: Activated (version 2.0.0)
[   39.851366] NET: Registered protocol family 30
[   39.851366] NET: Registered protocol family 30
[   39.853965] tipc: Started in single node mode
[   39.853965] tipc: Started in single node mode
[   39.855627] 9pnet: Installing 9P2000 support
[   39.855627] 9pnet: Installing 9P2000 support
[   39.857511] NET: Registered protocol family 37
[   39.857511] NET: Registered protocol family 37
[   39.859280] Key type dns_resolver registered
[   39.859280] Key type dns_resolver registered
[   39.860973] Key type ceph registered
[   39.860973] Key type ceph registered
[   39.862478] libceph: loaded (mon/osd proto 15/24)
[   39.862478] libceph: loaded (mon/osd proto 15/24)
[   39.866673] batman_adv: B.A.T.M.A.N. advanced 2014.1.0 (compatibility ve=
rsion 15) loaded
[   39.866673] batman_adv: B.A.T.M.A.N. advanced 2014.1.0 (compatibility ve=
rsion 15) loaded
[   39.870044] NET: Registered protocol family 40
[   39.870044] NET: Registered protocol family 40
[   39.872989]=20
[   39.872989] printing PIC contents
[   39.872989]=20
[   39.872989] printing PIC contents
[   39.874820] ... PIC  IMR: ffff
[   39.874820] ... PIC  IMR: ffff
[   39.876023] ... PIC  IRR: 9053
[   39.876023] ... PIC  IRR: 9053
[   39.877253] ... PIC  ISR: 0000
[   39.877253] ... PIC  ISR: 0000
[   39.878779] ... PIC ELCR: 0c00
[   39.878779] ... PIC ELCR: 0c00
[   39.880019] printing local APIC contents on CPU#0/0:
[   39.880019] printing local APIC contents on CPU#0/0:
[   39.882220] ... APIC ID:      00000000 (0)
[   39.882220] ... APIC ID:      00000000 (0)
[   39.882622] ... APIC VERSION: 00050014
[   39.882622] ... APIC VERSION: 00050014
[   39.882622] ... APIC TASKPRI: 00000000 (00)
[   39.882622] ... APIC TASKPRI: 00000000 (00)
[   39.882622] ... APIC PROCPRI: 00000000
[   39.882622] ... APIC PROCPRI: 00000000
[   39.882622] ... APIC LDR: 01000000
[   39.882622] ... APIC LDR: 01000000
[   39.882622] ... APIC DFR: ffffffff
[   39.882622] ... APIC DFR: ffffffff
[   39.882622] ... APIC SPIV: 000001ff
[   39.882622] ... APIC SPIV: 000001ff
[   39.882622] ... APIC ISR field:
[   39.882622] ... APIC ISR field:
[   39.882622] 00000000
[   39.882622] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[   39.882622] ... APIC TMR field:
[   39.882622] ... APIC TMR field:
[   39.882622] 00000000
[   39.882622] 000000000220000002200000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000000000000000

[   39.882622] ... APIC IRR field:
[   39.882622] ... APIC IRR field:
[   39.882622] 00000000
[   39.882622] 000000000000000000000000000000000000000000000000000000000000=
000000000000000000000000000000000000000000000000800000008000

[   39.882622] ... APIC ESR: 00000000
[   39.882622] ... APIC ESR: 00000000
[   39.882622] ... APIC ICR: 000408f6
[   39.882622] ... APIC ICR: 000408f6
[   39.882622] ... APIC ICR2: 01000000
[   39.882622] ... APIC ICR2: 01000000
[   39.882622] ... APIC LVTT: 000200ef
[   39.882622] ... APIC LVTT: 000200ef
[   39.882622] ... APIC LVTPC: 00010000
[   39.882622] ... APIC LVTPC: 00010000
[   39.882622] ... APIC LVT0: 00010700
[   39.882622] ... APIC LVT0: 00010700
[   39.882622] ... APIC LVT1: 00000400
[   39.882622] ... APIC LVT1: 00000400
[   39.882622] ... APIC LVTERR: 000000fe
[   39.882622] ... APIC LVTERR: 000000fe
[   39.882622] ... APIC TMICT: 00098860
[   39.882622] ... APIC TMICT: 00098860
[   39.882622] ... APIC TMCCT: 0002cf61
[   39.882622] ... APIC TMCCT: 0002cf61
[   39.882622] ... APIC TDCR: 00000003
[   39.882622] ... APIC TDCR: 00000003
[   39.882622]=20
[   39.882622]=20
[   39.922938] number of MP IRQ sources: 15.
[   39.922938] number of MP IRQ sources: 15.
[   39.924432] number of IO-APIC #0 registers: 24.
[   39.924432] number of IO-APIC #0 registers: 24.
[   39.925830] testing the IO APIC.......................
[   39.925830] testing the IO APIC.......................
[   39.927426] IO APIC #0......
[   39.927426] IO APIC #0......
[   39.928199] .... register #00: 00000000
[   39.928199] .... register #00: 00000000
[   39.929264] .......    : physical APIC id: 00
[   39.929264] .......    : physical APIC id: 00
[   39.930734] .......    : Delivery Type: 0
[   39.930734] .......    : Delivery Type: 0
[   39.931900] .......    : LTS          : 0
[   39.931900] .......    : LTS          : 0
[   39.933139] .... register #01: 00170011
[   39.933139] .... register #01: 00170011
[   39.935176] .......     : max redirection entries: 17
[   39.935176] .......     : max redirection entries: 17
[   39.936224] .......     : PRQ implemented: 0
[   39.936224] .......     : PRQ implemented: 0
[   39.937077] .......     : IO APIC version: 11
[   39.937077] .......     : IO APIC version: 11
[   39.937876] .... register #02: 00000000
[   39.937876] .... register #02: 00000000
[   39.938676] .......     : arbitration: 00
[   39.938676] .......     : arbitration: 00
[   39.939464] .... IRQ redirection table:
[   39.939464] .... IRQ redirection table:
[   39.940255] 1    0    0   0   0    0    0    00
[   39.940255] 1    0    0   0   0    0    0    00
[   39.941099] 0    0    0   0   0    1    1    31
[   39.941099] 0    0    0   0   0    1    1    31
[   39.942018] 0    0    0   0   0    1    1    30
[   39.942018] 0    0    0   0   0    1    1    30
[   39.942942] 0    0    0   0   0    1    1    33
[   39.942942] 0    0    0   0   0    1    1    33
[   39.944379] 1    0    0   0   0    1    1    34
[   39.944379] 1    0    0   0   0    1    1    34
[   39.945867] 0    1    0   0   0    1    1    35
[   39.945867] 0    1    0   0   0    1    1    35
[   39.947423] 0    0    0   0   0    1    1    36
[   39.947423] 0    0    0   0   0    1    1    36
[   39.948934] 0    0    0   0   0    1    1    37
[   39.948934] 0    0    0   0   0    1    1    37
[   39.950469] 0    0    0   0   0    1    1    38
[   39.950469] 0    0    0   0   0    1    1    38
[   39.951931] 0    1    0   0   0    1    1    39
[   39.951931] 0    1    0   0   0    1    1    39
[   39.953514] 1    1    0   0   0    1    1    3A
[   39.953514] 1    1    0   0   0    1    1    3A
[   39.955005] 1    1    0   0   0    1    1    3B
[   39.955005] 1    1    0   0   0    1    1    3B
[   39.956526] 0    0    0   0   0    1    1    3C
[   39.956526] 0    0    0   0   0    1    1    3C
[   39.958022] 0    0    0   0   0    1    1    3D
[   39.958022] 0    0    0   0   0    1    1    3D
[   39.959539] 0    0    0   0   0    1    1    3E
[   39.959539] 0    0    0   0   0    1    1    3E
[   39.961072] 0    0    0   0   0    1    1    3F
[   39.961072] 0    0    0   0   0    1    1    3F
[   39.962650] 1    0    0   0   0    0    0    00
[   39.962650] 1    0    0   0   0    0    0    00
[   39.964228] 1    0    0   0   0    0    0    00
[   39.964228] 1    0    0   0   0    0    0    00
[   39.965771] 1    0    0   0   0    0    0    00
[   39.965771] 1    0    0   0   0    0    0    00
[   39.967338] 1    0    0   0   0    0    0    00
[   39.967338] 1    0    0   0   0    0    0    00
[   39.968840] 1    0    0   0   0    0    0    00
[   39.968840] 1    0    0   0   0    0    0    00
[   39.970385] 1    0    0   0   0    0    0    00
[   39.970385] 1    0    0   0   0    0    0    00
[   39.971918] 1    0    0   0   0    0    0    00
[   39.971918] 1    0    0   0   0    0    0    00
[   39.973501] 1    0    0   0   0    0    0    00
[   39.973501] 1    0    0   0   0    0    0    00
[   39.975003] IRQ to pin mappings:
[   39.975003] IRQ to pin mappings:
[   39.976081] IRQ0=20
[   39.976081] IRQ0 -> 0:2-> 0:2

[   39.976959] IRQ1=20
[   39.976959] IRQ1 -> 0:1-> 0:1

[   39.977822] IRQ3=20
[   39.977822] IRQ3 -> 0:3-> 0:3

[   39.978923] IRQ4=20
[   39.978923] IRQ4 -> 0:4-> 0:4

[   39.979803] IRQ5=20
[   39.979803] IRQ5 -> 0:5-> 0:5

[   39.980783] IRQ6=20
[   39.980783] IRQ6 -> 0:6-> 0:6

[   39.981904] IRQ7=20
[   39.981904] IRQ7 -> 0:7-> 0:7

[   39.982857] IRQ8=20
[   39.982857] IRQ8 -> 0:8-> 0:8

[   39.983729] IRQ9=20
[   39.983729] IRQ9 -> 0:9-> 0:9

[   39.984648] IRQ10=20
[   39.984648] IRQ10 -> 0:10-> 0:10

[   39.985631] IRQ11=20
[   39.985631] IRQ11 -> 0:11-> 0:11

[   39.986578] IRQ12=20
[   39.986578] IRQ12 -> 0:12-> 0:12

[   39.987552] IRQ13=20
[   39.987552] IRQ13 -> 0:13-> 0:13

[   39.988465] IRQ14=20
[   39.988465] IRQ14 -> 0:14-> 0:14

[   39.989436] IRQ15=20
[   39.989436] IRQ15 -> 0:15-> 0:15

[   39.990360] .................................... done.
[   39.990360] .................................... done.
[   39.992192] Using IPI Shortcut mode
[   39.992192] Using IPI Shortcut mode
[   39.995862] bootconsole [earlyser0] disabled
[   39.995862] bootconsole [earlyser0] disabled
[   39.997505] Loading compiled-in X.509 certificates
[   39.998657] Problem loading in-kernel X.509 certificate (-65)
[   39.999677] registered taskstats version 1
[   40.000495] bio: create slab <bio-1> at 1
[   40.003498] Btrfs loaded
[   40.004495] Key type encrypted registered
[   40.010659] rtc-test rtc-test.0: setting system clock to 2014-02-24 13:2=
7:19 UTC (1393248439)
[   40.014799] Freeing unused kernel memory: 692K (c25fc000 - c26a9000)
[   40.067964] random: init urandom read with 19 bits of entropy available
mountall: Event failed
mount: unknown filesystem type 'devpts'
mountall: mount /dev/pts [3379] terminated with status 32
mountall: Filesystem could not be mounted: /dev/pts
mountall: Skipping mounting /dev/pts since Plymouth is not available
udevd[3421]: error: runtime directory '/run/udev' not writable, for now fal=
ling back to '/dev/.udev'
udevd[3431]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:LN=
XSYSTM:': No such file or directory

udevd[3433]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv input:b=
0019v0000p0001e0000-e0,1,k74,ramlsfw': No such file or directory

udevd[3435]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:LN=
XCPU:': No such file or directory

udevd[3438]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PN=
P0103:': No such file or directory

udevd[3439]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:LN=
XCPU:': No such file or directory

udevd[3441]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PN=
P0A03:': No such file or directory

udevd[3443]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PN=
P0C0F:': No such file or directory

udevd[3446]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PN=
P0C0F:': No such file or directory

udevd[3448]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PN=
P0C0F:': No such file or directory

udevd[3451]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PN=
P0C0F:': No such file or directory

udevd[3457]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PN=
P0C0F:': No such file or directory

udevd[3481]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PN=
P0303:': No such file or directory

udevd[3483]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PN=
P0700:': No such file or directory
udevd[3482]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PN=
P0400:': No such file or directory
udevd[3484]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PN=
P0B00:': No such file or directory



udevd[3487]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PN=
P0501:': No such file or directory

udevd[3485]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PN=
P0501:': No such file or directory

udevd[3486]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv acpi:PN=
P0F13:': No such file or directory

udevd[3489]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv pci:v00=
008086d00001237sv00001AF4sd00001100bc06sc00i00': No such file or directory

udevd[3492]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv virtio:=
d00000002v00001AF4': No such file or directory
udevd[3491]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv pci:v00=
008086d0000100Esv00001AF4sd00001100bc02sc00i00': No such file or directory
udevd[3490]: failed to execute '/sbin/modprobe' '/sbin/modprobe -q fbcon': =
No such file or directory
udevd[3488]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv pci:v00=
008086d00007000sv00001AF4sd00001100bc06sc01i00': No such file or directory




udevd[3495]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv virtio:=
d00000002v00001AF4': No such file or directory

udevd[3496]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv virtio:=
d00000002v00001AF4': No such file or directory

udevd[3493]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv virtio:=
d00000002v00001AF4': No such file or directory

udevd[3498]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv platfor=
m:goldfish_pdev_bus': No such file or directory

udevd[3501]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv virtio:=
d00000002v00001AF4': No such file or directory

udevd[3497]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv pci:v00=
008086d000025ABsv00001AF4sd00001100bc08sc80i00': No such file or directory

udevd[3500]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv virtio:=
d00000002v00001AF4': No such file or directory
udevd[3499]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv platfor=
m:hgafb': No such file or directory
udevd[3502]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv platfor=
m:platform-framebuffer': No such file or directory
udevd[3503]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv platfor=
m:i5k_amb': No such file or directory

udevd[3505]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv input:b=
0011v0001p0001eAB41-e0,1,4,11,14,k71,72,73,74,75,76,77,79,7A,7B,7C,7D,7E,7F=
,80,8C,8E,8F,9B,9C,9D,9E,9F,A3,A4,A5,A6,AC,AD,B7,B8,B9,D9,E2,ram4,l0,1,2,sf=
w': No such file or directory


udevd[3504]: failed to execute '/sbin/modprobe' '/sbin/modprobe -bv serio:t=
y01pr00id00ex00': No such file or directory



[   91.903015]=20
[   91.903363] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[   91.904407] [ INFO: inconsistent lock state ]
[   91.905533] 3.14.0-rc3-wl-01773-g311db85 #11 Tainted: G        W  =20
[   91.906880] ---------------------------------
[   91.908013] inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
[   91.909378] blkid/3517 [HC0[0]:SC0[0]:HE1:SE1] takes:
[   91.910360]  (&(&q->__queue_lock)->rlock){?.-...}, at: [<c143f35a>] blk_=
flush_plug_list+0x15a/0x240
[   91.910360] {IN-HARDIRQ-W} state was registered at:
[   91.910360]   [<c106235a>] __lock_acquire+0xb5a/0x1aa0
[   91.910360]   [<c10639c7>] lock_acquire+0x77/0xa0
[   91.910360]   [<c200b83d>] _raw_spin_lock_irqsave+0x4d/0x60
[   91.910360]   [<c143e9fb>] blk_end_bidi_request+0x3b/0x60
[   91.910360]   [<c143eab2>] blk_end_request+0x12/0x20
[   91.910360]   [<c16382c7>] ide_end_rq+0x27/0x50
[   91.910360]   [<c1638467>] ide_complete_rq+0x27/0x50
[   91.910360]   [<c164ff75>] cdrom_newpc_intr+0x315/0x8e0
[   91.910360]   [<c163873a>] ide_intr+0x15a/0x1f0
[   91.910360]   [<c106a270>] handle_irq_event_percpu+0x20/0x120
[   91.910360]   [<c106a39c>] handle_irq_event+0x2c/0x50
[   91.910360]   [<c106c376>] handle_edge_irq+0x66/0x120
[   91.910360] irq event stamp: 2248
[   91.910360] hardirqs last  enabled at (2245): [<c200b9d2>] _raw_spin_unl=
ock_irq+0x22/0x50
[   91.910360] hardirqs last disabled at (2246): [<c143f2f7>] blk_flush_plu=
g_list+0xf7/0x240
[   91.910360] softirqs last  enabled at (2248): [<c1456ea5>] __cfq_set_act=
ive_queue+0x45/0x1d0
[   91.910360] softirqs last disabled at (2247): [<c1456ea5>] __cfq_set_act=
ive_queue+0x45/0x1d0
[   91.910360]=20
[   91.910360] other info that might help us debug this:
[   91.910360]  Possible unsafe locking scenario:
[   91.910360]=20
[   91.910360]        CPU0
[   91.910360]        ----
[   91.910360]   lock(&(&q->__queue_lock)->rlock);
[   91.910360]   <Interrupt>
[   91.910360]     lock(&(&q->__queue_lock)->rlock);
[   91.910360]=20
[   91.910360]  *** DEADLOCK ***
[   91.910360]=20
[   91.910360] 1 lock held by blkid/3517:
[   91.910360]  #0:  (&(&q->__queue_lock)->rlock){?.-...}, at: [<c143f35a>]=
 blk_flush_plug_list+0x15a/0x240
[   91.910360]=20
[   91.910360] stack backtrace:
[   91.910360] CPU: 0 PID: 3517 Comm: blkid Tainted: G        W    3.14.0-r=
c3-wl-01773-g311db85 #11
[   91.910360] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   91.910360]  c9908000 c9908000 c995db00 c1ff5ece c995db3c c1ff174d c231c=
847 c231cb6d
[   91.910360]  00000dbd 00000000 00000000 00000000 00000000 00000001 00000=
001 c231cb6d
[   91.910360]  00000002 c99084dc c105f270 c995db70 c1060234 00000002 00000=
000 c231e494
[   91.910360] Call Trace:
[   91.910360]  [<c1ff5ece>] dump_stack+0x16/0x18
[   91.910360]  [<c1ff174d>] print_usage_bug.part.35+0x252/0x25a
[   91.910360]  [<c105f270>] ? print_shortest_lock_dependencies+0x1a0/0x1a0
[   91.910360]  [<c1060234>] mark_lock+0x5d4/0x690
[   91.910360]  [<c105f270>] ? print_shortest_lock_dependencies+0x1a0/0x1a0
[   91.910360]  [<c106035f>] mark_held_locks+0x6f/0xf0
[   91.910360]  [<c102f55a>] ? print_oops_end_marker+0x2a/0x30
[   91.910360]  [<c1032c51>] ? __local_bh_enable_ip+0x61/0xd0
[   91.910360]  [<c106047f>] trace_hardirqs_on_caller+0x9f/0x1b0
[   91.910360]  [<c1456ea5>] ? __cfq_set_active_queue+0x45/0x1d0
[   91.910360]  [<c106059b>] trace_hardirqs_on+0xb/0x10
[   91.910360]  [<c1032c51>] __local_bh_enable_ip+0x61/0xd0
[   91.910360]  [<c1456ef9>] __cfq_set_active_queue+0x99/0x1d0
[   91.910360]  [<c145002f>] ? blkg_create+0x36f/0x4b0
[   91.910360]  [<c1459b16>] ? cfq_add_cfqq_rr+0x66/0xb0
[   91.910360]  [<c1456d94>] ? cfq_update_idle_window.isra.84+0xa4/0xf0
[   91.910360]  [<c1464619>] ? __delay+0x9/0x10
[   91.910360]  [<c14595c4>] cfq_dispatch_requests+0x4d4/0x9c0
[   91.910360]  [<c1023ad3>] ? kvm_clock_read+0x13/0x30
[   91.910360]  [<c1008d38>] ? sched_clock+0x8/0x10
[   91.910360]  [<c1459dbf>] ? cfq_insert_request+0x1af/0x480
[   91.910360]  [<c143dca3>] ? submit_bio+0x43/0xf0
[   91.910360]  [<c1468766>] ? list_sort+0x146/0x1b0
[   91.910360]  [<c143ecf4>] blk_peek_request+0x114/0x1a0
[   91.910360]  [<c1659917>] scsi_request_fn+0x37/0x4d0
[   91.910360]  [<c143cccc>] __blk_run_queue+0x2c/0x40
[   91.910360]  [<c143f39e>] blk_flush_plug_list+0x19e/0x240
[   91.910360]  [<c143f63d>] blk_finish_plug+0xd/0x30
[   91.910360]  [<c10a3761>] __do_page_cache_readahead+0x1e1/0x270
[   91.910360]  [<c10a3626>] ? __do_page_cache_readahead+0xa6/0x270
[   91.910360]  [<c10a3c4c>] force_page_cache_readahead+0x6c/0x90
[   91.910360]  [<c10a3d0d>] page_cache_sync_readahead+0x4d/0x50
[   91.910360]  [<c109ac9a>] generic_file_aio_read+0x54a/0x700
[   91.910360]  [<c10fe52f>] blkdev_aio_read+0x6f/0xb0
[   91.910360]  [<c10d0371>] do_sync_read+0x51/0x80
[   91.910360]  [<c10d0320>] ? no_llseek+0x10/0x10
[   91.910360]  [<c10d0eab>] vfs_read+0x6b/0x110
[   91.910360]  [<c10d129c>] SyS_read+0x4c/0x90
[   91.910360]  [<c200cbca>] sysenter_do_call+0x12/0x3c
[   92.092982] init: Failed to create pty - disabling logging for job
[   92.094569] init: Temporary process spawn error: No such file or directo=
ry
[   92.172247] init: Failed to create pty - disabling logging for job
[   92.173962] init: Temporary process spawn error: No such file or directo=
ry
[   92.586726] init: Failed to create pty - disabling logging for job
[   92.588086] init: Temporary process spawn error: No such file or directo=
ry
[   92.714021] init: Failed to create pty - disabling logging for job
[   92.715704] init: Temporary process spawn error: No such file or directo=
ry
[   92.763952] init: network-interface (ip6tnl0) pre-start process (3522) t=
erminated with status 1
[   92.790183] init: network-interface (lo) pre-start process (3523) termin=
ated with status 1
[   92.810734] init: network-interface (sit0) pre-start process (3526) term=
inated with status 1
[   92.821459] init: network-interface (ip6gre0) pre-start process (3530) t=
erminated with status 1
[   93.001585] init: network-interface (irlan0) pre-start process (3532) te=
rminated with status 1
[   93.082599] init: network-interface (ip6tnl0) post-stop process (3544) t=
erminated with status 1
[   93.090682] init: network-interface (lo) post-stop process (3545) termin=
ated with status 1
[   93.112695] init: network-interface (ip6gre0) post-stop process (3547) t=
erminated with status 1
[   93.122634] init: network-interface (sit0) post-stop process (3546) term=
inated with status 1
[   93.169175] init: network-interface (irlan0) post-stop process (3549) te=
rminated with status 1
[   94.482939] init: Failed to create pty - disabling logging for job
[   94.484307] init: Temporary process spawn error: No such file or directo=
ry
[   94.540871] init: Failed to create pty - disabling logging for job
[   94.542477] init: Temporary process spawn error: No such file or directo=
ry
[   94.634719] init: networking main process (3556) terminated with status 1
[  100.669054] init: Failed to create pty - disabling logging for job
[  100.673389] init: Temporary process spawn error: No such file or directo=
ry
[  100.857172] init: plymouth-upstart-bridge main process (3562) terminated=
 with status 1
[  100.903895] init: hwclock-save main process (3561) terminated with statu=
s 70
 * Asking all remaining processes to terminate...      =20
[  101.516985] init: failsafe main process (3536) terminated with status 143

 * All processes ended within 1 seconds....      =20
 * Deactivating swap...      =20
umount: /run/lock: not mounted
 * Will now restart
[  103.646460] Unregister pv shared memory for cpu 0
[  103.647330] sd 2:0:0:0: [sda] Synchronizing SCSI cache
[  103.648494] reboot: Restarting system
[  103.648937] reboot: machine restart
Elapsed time: 55
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-s=
t1-02241939/311db85e8948921a53da32bcbf22b988380d948c/vmlinuz-3.14.0-rc3-wl-=
01773-g311db85 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debu=
g apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=3D1 nmi_wat=
chdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=
=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/i386-rand=
config-st1-02241939/linux-devel:devel-hourly-2014022117/.vmlinuz-311db85e89=
48921a53da32bcbf22b988380d948c-20140224201508-2-xian branch=3Dlinux-devel/d=
evel-hourly-2014022117 BOOT_IMAGE=3D/kernel/i386-randconfig-st1-02241939/31=
1db85e8948921a53da32bcbf22b988380d948c/vmlinuz-3.14.0-rc3-wl-01773-g311db85=
'  -initrd /kernel-tests/initrd/quantal-core-i386.cgz -m 320 -smp 2 -net ni=
c,vlan=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::14105-:22 -boot =
order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -drive file=
=3D/fs/LABEL=3DKVM/disk0-quantal-xian-28,media=3Ddisk,if=3Dvirtio -drive fi=
le=3D/fs/LABEL=3DKVM/disk1-quantal-xian-28,media=3Ddisk,if=3Dvirtio -drive =
file=3D/fs/LABEL=3DKVM/disk2-quantal-xian-28,media=3Ddisk,if=3Dvirtio -driv=
e file=3D/fs/LABEL=3DKVM/disk3-quantal-xian-28,media=3Ddisk,if=3Dvirtio -dr=
ive file=3D/fs/LABEL=3DKVM/disk4-quantal-xian-28,media=3Ddisk,if=3Dvirtio -=
drive file=3D/fs/LABEL=3DKVM/disk5-quantal-xian-28,media=3Ddisk,if=3Dvirtio=
 -pidfile /dev/shm/kboot/pid-quantal-xian-28 -serial file:/dev/shm/kboot/se=
rial-quantal-xian-28 -daemonize -display none -monitor null=20

--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc3-wl-01773-g311db85"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.14.0-rc3 Kernel Configuration
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
CONFIG_NEED_DMA_MAP_STATE=y
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
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
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
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
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
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
# CONFIG_TASK_XACCT is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
# CONFIG_RCU_NOCB_CPU is not set
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
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
# CONFIG_MEMCG_SWAP is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
CONFIG_SCHED_AUTOGROUP=y
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
CONFIG_AIO=y
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
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
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
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
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
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_SYSTEM_TRUSTED_KEYRING=y
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_CMDLINE_PARSER is not set

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
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
CONFIG_GOLDFISH=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_GOLDFISH=y
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
CONFIG_LGUEST_GUEST=y
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
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
# CONFIG_CPU_SUP_CYRIX_32 is not set
CONFIG_CPU_SUP_AMD=y
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_ANCIENT_MCE=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_VM86=y
CONFIG_TOSHIBA=y
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
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
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
# CONFIG_BOUNCE is not set
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSWAP is not set
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
CONFIG_HIGHPTE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_EXTLOG is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

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
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_EISA=y
# CONFIG_EISA_VLB_PRIMING is not set
CONFIG_EISA_PCI_EISA=y
# CONFIG_EISA_VIRTUAL_ROOT is not set
CONFIG_EISA_NAMES=y
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
# CONFIG_ALIX is not set
# CONFIG_NET5501 is not set
# CONFIG_GEOS is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
# CONFIG_YENTA_O2 is not set
CONFIG_YENTA_RICOH=y
# CONFIG_YENTA_TI is not set
CONFIG_YENTA_TOSHIBA=y
CONFIG_PCMCIA_PROBE=y
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
# CONFIG_RAPIDIO_DMA_ENGINE is not set
# CONFIG_RAPIDIO_DEBUG is not set
CONFIG_RAPIDIO_ENUM_BASIC=y

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=y
CONFIG_RAPIDIO_CPS_XX=y
# CONFIG_RAPIDIO_TSI568 is not set
CONFIG_RAPIDIO_CPS_GEN2=y
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
# CONFIG_NET_IPGRE is not set
CONFIG_IP_MROUTE=y
# CONFIG_IP_PIMSM_V1 is not set
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=y
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
# CONFIG_IPV6_ROUTE_INFO is not set
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
CONFIG_INET6_IPCOMP=y
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_BEET is not set
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
CONFIG_IPV6_SIT=y
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_GRE=y
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=y

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
# CONFIG_SCTP_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_RDS=y
# CONFIG_RDS_TCP is not set
# CONFIG_RDS_DEBUG is not set
CONFIG_TIPC=y
CONFIG_TIPC_PORTS=8191
# CONFIG_ATM is not set
CONFIG_L2TP=y
CONFIG_L2TP_DEBUGFS=y
# CONFIG_L2TP_V3 is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
CONFIG_PHONET=y
# CONFIG_IEEE802154 is not set
CONFIG_6LOWPAN_IPHC=y
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_BLA is not set
CONFIG_BATMAN_ADV_DAT=y
CONFIG_BATMAN_ADV_NC=y
CONFIG_BATMAN_ADV_DEBUG=y
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=y
CONFIG_VMWARE_VMCI_VSOCKETS=y
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=y
# CONFIG_NET_MPLS_GSO is not set
CONFIG_HSR=y
# CONFIG_CGROUP_NET_PRIO is not set
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
# CONFIG_CAN is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
CONFIG_IRCOMM=y
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
CONFIG_IRDA_FAST_RR=y
CONFIG_IRDA_DEBUG=y

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
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=y
CONFIG_TOSHIBA_FIR=y
CONFIG_SMC_IRCC_FIR=y
CONFIG_ALI_FIR=y
CONFIG_VLSI_FIR=y
# CONFIG_VIA_FIR is not set
CONFIG_BT=y
CONFIG_BT_RFCOMM=y
# CONFIG_BT_RFCOMM_TTY is not set
CONFIG_BT_BNEP=y
# CONFIG_BT_BNEP_MC_FILTER is not set
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_CMTP=y
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUART=y
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
# CONFIG_BT_HCIUART_ATH3K is not set
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIUART_3WIRE=y
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
# CONFIG_BT_WILINK is not set
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_NET_9P_DEBUG=y
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
# CONFIG_CAIF_NETDEV is not set
# CONFIG_CAIF_USB is not set
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
CONFIG_NFC=y
CONFIG_NFC_DIGITAL=y
CONFIG_NFC_NCI=y
CONFIG_NFC_HCI=y
# CONFIG_NFC_SHDLC is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_WILINK=y
# CONFIG_NFC_SIM is not set
# CONFIG_NFC_PN544 is not set
# CONFIG_NFC_MICROREAD is not set
CONFIG_NFC_MRVL=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_CMA is not set

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
# CONFIG_FTL is not set
CONFIG_NFTL=y
CONFIG_NFTL_RW=y
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
CONFIG_SSFDC=y
CONFIG_SM_FTL=y
CONFIG_MTD_OOPS=y
# CONFIG_MTD_SWAP is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
CONFIG_MTD_CFI_ADV_OPTIONS=y
CONFIG_MTD_CFI_NOSWAP=y
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
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
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_PHYSMAP is not set
CONFIG_MTD_SC520CDP=y
# CONFIG_MTD_NETSC520 is not set
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_SBC_GXX is not set
# CONFIG_MTD_SCx200_DOCFLASH is not set
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
# CONFIG_MTD_ESB2ROM is not set
CONFIG_MTD_CK804XROM=y
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
# CONFIG_MTD_PCI is not set
# CONFIG_MTD_GPIO_ADDR is not set
CONFIG_MTD_INTEL_VR_NOR=y
CONFIG_MTD_PLATRAM=y
CONFIG_MTD_LATCH_ADDR=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
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
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
# CONFIG_MTD_NAND_DOCG4 is not set
CONFIG_MTD_NAND_CAFE=y
CONFIG_MTD_NAND_CS553X=y
# CONFIG_MTD_NAND_NANDSIM is not set
CONFIG_MTD_NAND_PLATFORM=y
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
# CONFIG_MTD_ONENAND_GENERIC is not set
# CONFIG_MTD_ONENAND_OTP is not set
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
CONFIG_MTD_UBI_GLUEBI=y
# CONFIG_PARPORT is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=y
CONFIG_BLK_DEV_FD=y
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
# CONFIG_ZRAM is not set
CONFIG_BLK_CPQ_CISS_DA=y
# CONFIG_CISS_SCSI_TAPE is not set
CONFIG_BLK_DEV_DAC960=y
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=y
CONFIG_BLK_DEV_DRBD=y
# CONFIG_DRBD_FAULT_INJECTION is not set
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_NVME=y
CONFIG_BLK_DEV_SX8=y
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_BLK_DEV_RBD=y
CONFIG_BLK_DEV_RSXX=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
# CONFIG_AD525X_DPOT is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
CONFIG_SGI_IOC4=y
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ATMEL_SSC is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_CS5535_MFGPT is not set
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=y
# CONFIG_BMP085_I2C is not set
CONFIG_PCH_PHUB=y
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_VMWARE_VMCI=y

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_IDE_LEGACY=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
CONFIG_IDE_GD_ATAPI=y
CONFIG_BLK_DEV_DELKIN=y
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
CONFIG_BLK_DEV_PLATFORM=y
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=y
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=y
CONFIG_BLK_DEV_ALI15X3=y
# CONFIG_BLK_DEV_AMD74XX is not set
CONFIG_BLK_DEV_ATIIXP=y
CONFIG_BLK_DEV_CMD64X=y
CONFIG_BLK_DEV_TRIFLEX=y
# CONFIG_BLK_DEV_CS5520 is not set
CONFIG_BLK_DEV_CS5530=y
# CONFIG_BLK_DEV_CS5535 is not set
CONFIG_BLK_DEV_CS5536=y
CONFIG_BLK_DEV_HPT366=y
CONFIG_BLK_DEV_JMICRON=y
CONFIG_BLK_DEV_SC1200=y
CONFIG_BLK_DEV_PIIX=y
CONFIG_BLK_DEV_IT8172=y
CONFIG_BLK_DEV_IT8213=y
# CONFIG_BLK_DEV_IT821X is not set
CONFIG_BLK_DEV_NS87415=y
CONFIG_BLK_DEV_PDC202XX_OLD=y
CONFIG_BLK_DEV_PDC202XX_NEW=y
CONFIG_BLK_DEV_SVWKS=y
CONFIG_BLK_DEV_SIIMAGE=y
CONFIG_BLK_DEV_SIS5513=y
CONFIG_BLK_DEV_SLC90E66=y
CONFIG_BLK_DEV_TRM290=y
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
# CONFIG_BLK_DEV_UMC8672 is not set
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
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=y
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_FC_TGT_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_SRP_TGT_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
CONFIG_ISCSI_BOOT_SYSFS=y
CONFIG_SCSI_CXGB3_ISCSI=y
CONFIG_SCSI_CXGB4_ISCSI=y
# CONFIG_SCSI_BNX2_ISCSI is not set
CONFIG_SCSI_BNX2X_FCOE=y
# CONFIG_BE2ISCSI is not set
CONFIG_BLK_DEV_3W_XXXX_RAID=y
CONFIG_SCSI_HPSA=y
CONFIG_SCSI_3W_9XXX=y
CONFIG_SCSI_3W_SAS=y
CONFIG_SCSI_7000FASST=y
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AHA152X=y
CONFIG_SCSI_AHA1542=y
CONFIG_SCSI_AHA1740=y
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC79XX is not set
CONFIG_SCSI_AIC94XX=y
# CONFIG_AIC94XX_DEBUG is not set
CONFIG_SCSI_MVSAS=y
# CONFIG_SCSI_MVSAS_DEBUG is not set
# CONFIG_SCSI_MVSAS_TASKLET is not set
CONFIG_SCSI_MVUMI=y
CONFIG_SCSI_DPT_I2O=y
CONFIG_SCSI_ADVANSYS=y
CONFIG_SCSI_IN2000=y
CONFIG_SCSI_ARCMSR=y
CONFIG_SCSI_ESAS2R=y
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPT3SAS is not set
# CONFIG_SCSI_UFSHCD is not set
CONFIG_SCSI_HPTIOP=y
# CONFIG_SCSI_BUSLOGIC is not set
CONFIG_VMWARE_PVSCSI=y
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
CONFIG_SCSI_DMX3191D=y
# CONFIG_SCSI_DTC3280 is not set
CONFIG_SCSI_EATA=y
CONFIG_SCSI_EATA_TAGGED_QUEUE=y
# CONFIG_SCSI_EATA_LINKED_COMMANDS is not set
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=y
CONFIG_SCSI_GDTH=y
CONFIG_SCSI_ISCI=y
CONFIG_SCSI_GENERIC_NCR5380=y
CONFIG_SCSI_GENERIC_NCR5380_MMIO=y
# CONFIG_SCSI_GENERIC_NCR53C400 is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
CONFIG_SCSI_INIA100=y
CONFIG_SCSI_NCR53C406A=y
# CONFIG_SCSI_STEX is not set
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
# CONFIG_SCSI_SYM53C8XX_MMIO is not set
CONFIG_SCSI_PAS16=y
# CONFIG_SCSI_QLOGIC_FAS is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
CONFIG_SCSI_QLA_ISCSI=y
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_SIM710 is not set
CONFIG_SCSI_SYM53C416=y
CONFIG_SCSI_DC395x=y
CONFIG_SCSI_DC390T=y
CONFIG_SCSI_T128=y
CONFIG_SCSI_U14_34F=y
# CONFIG_SCSI_U14_34F_TAGGED_QUEUE is not set
# CONFIG_SCSI_U14_34F_LINKED_COMMANDS is not set
CONFIG_SCSI_U14_34F_MAX_TAGS=8
CONFIG_SCSI_ULTRASTOR=y
CONFIG_SCSI_NSP32=y
CONFIG_SCSI_DEBUG=y
CONFIG_SCSI_PMCRAID=y
CONFIG_SCSI_PM8001=y
CONFIG_SCSI_SRP=y
CONFIG_SCSI_BFA_FC=y
# CONFIG_SCSI_VIRTIO is not set
# CONFIG_SCSI_CHELSIO_FCOE is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
CONFIG_FIREWIRE_NOSY=y
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
# CONFIG_NET_CORE is not set
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
CONFIG_ARCNET_1051=y
CONFIG_ARCNET_RAW=y
# CONFIG_ARCNET_CAP is not set
# CONFIG_ARCNET_COM90xx is not set
# CONFIG_ARCNET_COM90xxIO is not set
CONFIG_ARCNET_RIM_I=y
CONFIG_ARCNET_COM20020=y
CONFIG_ARCNET_COM20020_ISA=y
# CONFIG_ARCNET_COM20020_PCI is not set

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=y
CONFIG_CAIF_SPI_SLAVE=y
# CONFIG_CAIF_SPI_SYNC is not set
# CONFIG_CAIF_HSI is not set
# CONFIG_CAIF_VIRTIO is not set
# CONFIG_VHOST_NET is not set

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_ETHERNET=y
CONFIG_MDIO=y
CONFIG_NET_VENDOR_3COM=y
CONFIG_EL3=y
CONFIG_3C515=y
# CONFIG_VORTEX is not set
CONFIG_TYPHOON=y
# CONFIG_NET_VENDOR_ADAPTEC is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_VENDOR_ARC is not set
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
CONFIG_ATL1=y
CONFIG_ATL1E=y
CONFIG_ATL1C=y
CONFIG_ALX=y
CONFIG_NET_CADENCE=y
CONFIG_ARM_AT91_ETHER=y
CONFIG_MACB=y
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=y
CONFIG_CNIC=y
CONFIG_TIGON3=y
CONFIG_BNX2X=y
CONFIG_NET_VENDOR_BROCADE=y
CONFIG_BNA=y
CONFIG_NET_CALXEDA_XGMAC=y
CONFIG_NET_VENDOR_CHELSIO=y
CONFIG_CHELSIO_T1=y
CONFIG_CHELSIO_T1_1G=y
CONFIG_CHELSIO_T3=y
CONFIG_CHELSIO_T4=y
CONFIG_CHELSIO_T4VF=y
# CONFIG_NET_VENDOR_CIRRUS is not set
# CONFIG_NET_VENDOR_CISCO is not set
CONFIG_DNET=y
# CONFIG_NET_VENDOR_DEC is not set
CONFIG_NET_VENDOR_DLINK=y
CONFIG_DL2K=y
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=y
# CONFIG_NET_VENDOR_EXAR is not set
CONFIG_NET_VENDOR_HP=y
CONFIG_HP100=y
# CONFIG_NET_VENDOR_INTEL is not set
CONFIG_IP1000=y
CONFIG_JME=y
# CONFIG_NET_VENDOR_MARVELL is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
CONFIG_NET_VENDOR_MICREL=y
CONFIG_KS8851_MLL=y
CONFIG_KSZ884X_PCI=y
# CONFIG_NET_VENDOR_MYRI is not set
CONFIG_FEALNX=y
CONFIG_NET_VENDOR_NATSEMI=y
CONFIG_NATSEMI=y
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_8390=y
CONFIG_NE2000=y
# CONFIG_NE2K_PCI is not set
# CONFIG_ULTRA is not set
# CONFIG_WD80x3 is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
CONFIG_QLCNIC=y
# CONFIG_QLCNIC_DCB is not set
CONFIG_QLGE=y
CONFIG_NETXEN_NIC=y
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_8139CP is not set
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
CONFIG_8139TOO_TUNE_TWISTER=y
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=y
CONFIG_SH_ETH=y
CONFIG_NET_VENDOR_RDC=y
CONFIG_R6040=y
# CONFIG_NET_VENDOR_SEEQ is not set
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
CONFIG_SFC=y
# CONFIG_SFC_MTD is not set
# CONFIG_SFC_MCDI_MON is not set
CONFIG_NET_VENDOR_SMSC=y
CONFIG_SMC9194=y
CONFIG_EPIC100=y
CONFIG_SMSC911X=y
# CONFIG_SMSC911X_ARCH_HOOKS is not set
CONFIG_SMSC9420=y
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
CONFIG_TLAN=y
CONFIG_NET_VENDOR_VIA=y
CONFIG_VIA_RHINE=y
CONFIG_VIA_RHINE_MMIO=y
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
CONFIG_WIZNET_W5300=y
# CONFIG_WIZNET_BUS_DIRECT is not set
CONFIG_WIZNET_BUS_INDIRECT=y
# CONFIG_WIZNET_BUS_ANY is not set
CONFIG_FDDI=y
CONFIG_DEFXX=y
CONFIG_DEFXX_MMIO=y
CONFIG_SKFP=y
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
# CONFIG_AMD_PHY is not set
CONFIG_MARVELL_PHY=y
# CONFIG_DAVICOM_PHY is not set
CONFIG_QSEMI_PHY=y
# CONFIG_LXT_PHY is not set
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
CONFIG_BCM7XXX_PHY=y
CONFIG_BCM87XX_PHY=y
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
CONFIG_NATIONAL_PHY=y
# CONFIG_STE10XP is not set
CONFIG_LSI_ET1011C_PHY=y
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_GPIO=y
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_WLAN is not set

#
# WiMAX Wireless Broadband devices
#

#
# Enable USB support to see WiMAX USB drivers
#
# CONFIG_WAN is not set
CONFIG_VMXNET3=y
CONFIG_ISDN=y
CONFIG_ISDN_I4L=y
# CONFIG_ISDN_PPP is not set
CONFIG_ISDN_AUDIO=y
CONFIG_ISDN_TTY_FAX=y

#
# ISDN feature submodules
#
CONFIG_ISDN_DRV_LOOP=y
CONFIG_ISDN_DIVERSION=y

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=y

#
# D-channel protocol features
#
CONFIG_HISAX_EURO=y
CONFIG_DE_AOC=y
CONFIG_HISAX_NO_SENDCOMPLETE=y
CONFIG_HISAX_NO_LLC=y
CONFIG_HISAX_NO_KEYPAD=y
CONFIG_HISAX_1TR6=y
# CONFIG_HISAX_NI1 is not set
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
# CONFIG_HISAX_16_0 is not set
# CONFIG_HISAX_16_3 is not set
# CONFIG_HISAX_TELESPCI is not set
# CONFIG_HISAX_S0BOX is not set
# CONFIG_HISAX_AVM_A1 is not set
# CONFIG_HISAX_FRITZPCI is not set
CONFIG_HISAX_AVM_A1_PCMCIA=y
# CONFIG_HISAX_ELSA is not set
CONFIG_HISAX_IX1MICROR2=y
# CONFIG_HISAX_DIEHLDIVA is not set
# CONFIG_HISAX_ASUSCOM is not set
CONFIG_HISAX_TELEINT=y
CONFIG_HISAX_HFCS=y
# CONFIG_HISAX_SEDLBAUER is not set
CONFIG_HISAX_SPORTSTER=y
CONFIG_HISAX_MIC=y
CONFIG_HISAX_NETJET=y
# CONFIG_HISAX_NETJET_U is not set
CONFIG_HISAX_NICCY=y
CONFIG_HISAX_ISURF=y
# CONFIG_HISAX_HSTSAPHIR is not set
# CONFIG_HISAX_BKM_A4T is not set
# CONFIG_HISAX_SCT_QUADRO is not set
CONFIG_HISAX_GAZEL=y
CONFIG_HISAX_HFC_PCI=y
CONFIG_HISAX_W6692=y
# CONFIG_HISAX_HFC_SX is not set
# CONFIG_HISAX_ENTERNOW_PCI is not set
CONFIG_HISAX_DEBUG=y

#
# HiSax PCMCIA card service modules
#

#
# HiSax sub driver modules
#
CONFIG_HISAX_HFC4S8S=y
# CONFIG_HISAX_FRITZ_PCIPNP is not set

#
# Active cards
#
# CONFIG_ISDN_DRV_ICN is not set
CONFIG_ISDN_DRV_PCBIT=y
# CONFIG_ISDN_DRV_SC is not set
# CONFIG_ISDN_DRV_ACT2000 is not set
CONFIG_ISDN_CAPI=y
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
# CONFIG_CAPI_TRACE is not set
# CONFIG_ISDN_CAPI_MIDDLEWARE is not set
CONFIG_ISDN_CAPI_CAPI20=y
CONFIG_ISDN_CAPI_CAPIDRV=y

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
CONFIG_ISDN_DRV_AVMB1_B1ISA=y
# CONFIG_ISDN_DRV_AVMB1_B1PCI is not set
# CONFIG_ISDN_DRV_AVMB1_T1ISA is not set
CONFIG_ISDN_DRV_AVMB1_T1PCI=y
CONFIG_ISDN_DRV_AVMB1_C4=y
# CONFIG_CAPI_EICON is not set
# CONFIG_ISDN_DRV_GIGASET is not set
CONFIG_MISDN=y
CONFIG_MISDN_DSP=y
# CONFIG_MISDN_L1OIP is not set

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=y
CONFIG_MISDN_HFCMULTI=y
CONFIG_MISDN_AVMFRITZ=y
CONFIG_MISDN_SPEEDFAX=y
CONFIG_MISDN_INFINEON=y
CONFIG_MISDN_W6692=y
CONFIG_MISDN_NETJET=y
CONFIG_MISDN_IPAC=y
CONFIG_MISDN_ISAR=y
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
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

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
# CONFIG_KEYBOARD_GOLDFISH_EVENTS is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
# CONFIG_JOYSTICK_ADI is not set
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
# CONFIG_JOYSTICK_GUILLEMOT is not set
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=y
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
# CONFIG_JOYSTICK_SPACEORB is not set
CONFIG_JOYSTICK_SPACEBALL=y
# CONFIG_JOYSTICK_STINGER is not set
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_AS5011=y
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
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
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=y
CONFIG_CYZ_INTR=y
CONFIG_MOXA_INTELLIO=y
CONFIG_MOXA_SMARTIO=y
CONFIG_SYNCLINK=y
CONFIG_SYNCLINKMP=y
CONFIG_SYNCLINK_GT=y
CONFIG_NOZOMI=y
CONFIG_ISI=y
CONFIG_N_HDLC=y
# CONFIG_N_GSM is not set
# CONFIG_TRACE_ROUTER is not set
CONFIG_TRACE_SINK=y
CONFIG_GOLDFISH_TTY=y
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_UARTLITE=y
CONFIG_SERIAL_UARTLITE_CONSOLE=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
# CONFIG_TTY_PRINTK is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_DTLK is not set
CONFIG_R3964=y
CONFIG_APPLICOM=y
CONFIG_SONYPI=y
CONFIG_MWAVE=y
CONFIG_SCx200_GPIO=y
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=y
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
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
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=y
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_VIA=y
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
CONFIG_I2C_DESIGNWARE_PCI=y
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
CONFIG_I2C_KEMPLD=y
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_TAOS_EVM=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_ELEKTOR is not set
CONFIG_I2C_PCA_ISA=y
CONFIG_SCx200_I2C=y
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
CONFIG_NTP_PPS=y

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
CONFIG_PPS_CLIENT_LDISC=y
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
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_F7188X=y
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
CONFIG_GPIO_ICH=y
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_TC3589X=y
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TWL4030=y
# CONFIG_GPIO_TWL6040 is not set
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=y
CONFIG_GPIO_BT8XX=y
# CONFIG_GPIO_AMD8111 is not set
CONFIG_GPIO_INTEL_MID=y
CONFIG_GPIO_PCH=y
# CONFIG_GPIO_ML_IOH is not set
CONFIG_GPIO_TIMBERDALE=y
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
# CONFIG_GPIO_KEMPLD is not set

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=y
CONFIG_GPIO_TPS6586X=y

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
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_88PM860X is not set
CONFIG_BATTERY_DS2760=y
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_MAX17040=y
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_BATTERY_TWL4030_MADC=y
CONFIG_CHARGER_PCF50633=y
# CONFIG_BATTERY_RX51 is not set
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_TWL4030 is not set
CONFIG_CHARGER_LP8727=y
# CONFIG_CHARGER_GPIO is not set
CONFIG_CHARGER_MAX14577=y
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_BQ24190=y
CONFIG_CHARGER_BQ24735=y
CONFIG_CHARGER_SMB347=y
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
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
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_NTC_THERMISTOR=y
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
# CONFIG_SENSORS_PMBUS is not set
CONFIG_SENSORS_ADM1275=y
# CONFIG_SENSORS_LM25066 is not set
# CONFIG_SENSORS_LTC2978 is not set
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=y
# CONFIG_SENSORS_MAX8688 is not set
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SHT15=y
# CONFIG_SENSORS_SHT21 is not set
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_TWL4030_MADC=y
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
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
CONFIG_X86_PKG_TEMP_THERMAL=y
# CONFIG_ACPI_INT3403_THERMAL is not set

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
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DRIVER_GPIO is not set
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=y
CONFIG_MFD_AS3711=y
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_CROS_EC=y
# CONFIG_MFD_CROS_EC_I2C is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=y
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
CONFIG_TWL4030_MADC=y
# CONFIG_MFD_TWL4030_AUDIO is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=y
# CONFIG_VIDEO_V4L2_SUBDEV_API is not set
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_TUNER=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
CONFIG_VIDEOBUF_VMALLOC=y
CONFIG_VIDEOBUF_DVB=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_CONTIG=y
CONFIG_VIDEOBUF2_VMALLOC=y
CONFIG_DVB_CORE=y
# CONFIG_DVB_NET is not set
CONFIG_TTPCI_EEPROM=y
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y

#
# Media drivers
#
CONFIG_RC_CORE=y
CONFIG_RC_MAP=y
CONFIG_RC_DECODERS=y
CONFIG_LIRC=y
CONFIG_IR_LIRC_CODEC=y
CONFIG_IR_NEC_DECODER=y
# CONFIG_IR_RC5_DECODER is not set
CONFIG_IR_RC6_DECODER=y
CONFIG_IR_JVC_DECODER=y
CONFIG_IR_SONY_DECODER=y
CONFIG_IR_RC5_SZ_DECODER=y
CONFIG_IR_SANYO_DECODER=y
# CONFIG_IR_MCE_KBD_DECODER is not set
# CONFIG_RC_DEVICES is not set
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#

#
# Media capture/analog TV support
#
CONFIG_VIDEO_IVTV=y
CONFIG_VIDEO_FB_IVTV=y
CONFIG_VIDEO_ZORAN=y
CONFIG_VIDEO_ZORAN_DC30=y
# CONFIG_VIDEO_ZORAN_ZR36060 is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
CONFIG_VIDEO_MXB=y

#
# Media capture/analog/hybrid TV support
#
CONFIG_VIDEO_CX18=y
# CONFIG_VIDEO_CX25821 is not set
CONFIG_VIDEO_CX88=y
CONFIG_VIDEO_CX88_BLACKBIRD=y
CONFIG_VIDEO_CX88_DVB=y
# CONFIG_VIDEO_CX88_ENABLE_VP3054 is not set
CONFIG_VIDEO_CX88_MPEG=y
# CONFIG_VIDEO_BT848 is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_SAA7164 is not set

#
# Media digital TV PCI Adapters
#
# CONFIG_DVB_AV7110 is not set
CONFIG_DVB_BUDGET_CORE=y
# CONFIG_DVB_BUDGET is not set
# CONFIG_DVB_BUDGET_CI is not set
CONFIG_DVB_BUDGET_AV=y
# CONFIG_DVB_B2C2_FLEXCOP_PCI is not set
CONFIG_DVB_PLUTO2=y
# CONFIG_DVB_DM1105 is not set
CONFIG_DVB_PT1=y
CONFIG_MANTIS_CORE=y
# CONFIG_DVB_MANTIS is not set
CONFIG_DVB_HOPPER=y
CONFIG_DVB_NGENE=y
# CONFIG_DVB_DDBRIDGE is not set
CONFIG_V4L_PLATFORM_DRIVERS=y
CONFIG_VIDEO_CAFE_CCIC=y
CONFIG_SOC_CAMERA=y
CONFIG_SOC_CAMERA_SCALE_CROP=y
# CONFIG_SOC_CAMERA_PLATFORM is not set
CONFIG_VIDEO_RCAR_VIN=y
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
# CONFIG_MEDIA_PARPORT_SUPPORT is not set
CONFIG_VIDEO_CX2341X=y
CONFIG_VIDEO_BTCX=y
CONFIG_VIDEO_TVEEPROM=y
CONFIG_VIDEO_SAA7146=y
CONFIG_VIDEO_SAA7146_VV=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_VIDEO_IR_I2C=y

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TDA9840=y
CONFIG_VIDEO_TEA6415C=y
CONFIG_VIDEO_TEA6420=y
CONFIG_VIDEO_MSP3400=y
CONFIG_VIDEO_CS5345=y
CONFIG_VIDEO_CS53L32A=y
CONFIG_VIDEO_WM8775=y
CONFIG_VIDEO_WM8739=y
CONFIG_VIDEO_VP27SMPX=y

#
# RDS decoders
#

#
# Video decoders
#
CONFIG_VIDEO_SAA711X=y
CONFIG_VIDEO_VPX3220=y

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=y
CONFIG_VIDEO_CX25840=y

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=y
CONFIG_VIDEO_ADV7175=y

#
# Camera sensor devices
#
CONFIG_VIDEO_OV7670=y

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=y
CONFIG_VIDEO_UPD64083=y

#
# Audio/Video compression chips
#

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_M52790=y

#
# Sensors used on soc_camera driver
#

#
# soc_camera sensor drivers
#
CONFIG_SOC_CAMERA_IMX074=y
CONFIG_SOC_CAMERA_MT9M001=y
# CONFIG_SOC_CAMERA_MT9M111 is not set
CONFIG_SOC_CAMERA_MT9T031=y
CONFIG_SOC_CAMERA_MT9T112=y
# CONFIG_SOC_CAMERA_MT9V022 is not set
CONFIG_SOC_CAMERA_OV2640=y
CONFIG_SOC_CAMERA_OV5642=y
CONFIG_SOC_CAMERA_OV6650=y
CONFIG_SOC_CAMERA_OV772X=y
CONFIG_SOC_CAMERA_OV9640=y
CONFIG_SOC_CAMERA_OV9740=y
CONFIG_SOC_CAMERA_RJ54N1=y
CONFIG_SOC_CAMERA_TW9910=y
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_MT2131=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MXL5005S=y
CONFIG_MEDIA_TUNER_MC44S803=y

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=y
CONFIG_DVB_STB6100=y
CONFIG_DVB_STV090x=y
CONFIG_DVB_STV6110x=y

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=y
CONFIG_DVB_TDA18271C2DD=y

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24123=y
CONFIG_DVB_STV0288=y
CONFIG_DVB_STB6000=y
CONFIG_DVB_STV0299=y
CONFIG_DVB_STV0900=y
CONFIG_DVB_TDA8261=y
CONFIG_DVB_TUA6100=y
CONFIG_DVB_CX24116=y
CONFIG_DVB_TS2020=y
CONFIG_DVB_DS3000=y

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_CX22702=y
CONFIG_DVB_TDA1004X=y
CONFIG_DVB_MT352=y
CONFIG_DVB_ZL10353=y

#
# DVB-C (cable) frontends
#
CONFIG_DVB_TDA10021=y
CONFIG_DVB_TDA10023=y

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=y
CONFIG_DVB_OR51132=y
CONFIG_DVB_LGDT330X=y
CONFIG_DVB_S5H1409=y
CONFIG_DVB_S5H1411=y

#
# ISDB-T (terrestrial) frontends
#

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=y

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=y
CONFIG_DVB_ISL6421=y

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
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
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_OPENCORES=y
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
CONFIG_FB_RIVA=y
# CONFIG_FB_RIVA_I2C is not set
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
CONFIG_FB_RADEON_DEBUG=y
# CONFIG_FB_ATY128 is not set
CONFIG_FB_ATY=y
# CONFIG_FB_ATY_CT is not set
# CONFIG_FB_ATY_GX is not set
# CONFIG_FB_ATY_BACKLIGHT is not set
CONFIG_FB_S3=y
CONFIG_FB_S3_DDC=y
CONFIG_FB_SAVAGE=y
# CONFIG_FB_SAVAGE_I2C is not set
# CONFIG_FB_SAVAGE_ACCEL is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
# CONFIG_FB_CARMINE is not set
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=y
# CONFIG_FB_GEODE_GX is not set
CONFIG_FB_GEODE_GX1=y
CONFIG_FB_TMIO=y
CONFIG_FB_TMIO_ACCELL=y
CONFIG_FB_SM501=y
CONFIG_FB_GOLDFISH=y
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
# CONFIG_FB_AUO_K1900 is not set
# CONFIG_FB_AUO_K1901 is not set
# CONFIG_FB_SIMPLE is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_LM3533 is not set
CONFIG_BACKLIGHT_PWM=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
# CONFIG_BACKLIGHT_WM831X is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=y
# CONFIG_BACKLIGHT_88PM860X is not set
# CONFIG_BACKLIGHT_PCF50633 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
# CONFIG_BACKLIGHT_PANDORA is not set
# CONFIG_BACKLIGHT_AS3711 is not set
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
# CONFIG_SND is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
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
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=y
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_PRIMAX=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEELSERIES=y
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
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
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_TAHVO_USB is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_NET48XX is not set
# CONFIG_LEDS_WRAP is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_PCA9685 is not set
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_PWM=y
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_INTEL_SS4200=y
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_MAX8997=y
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_IDE_DISK=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=y
CONFIG_EDAC_MCE_INJ=y
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_AMD76X=y
CONFIG_EDAC_E7XXX=y
CONFIG_EDAC_E752X=y
CONFIG_EDAC_I82875P=y
# CONFIG_EDAC_I82975X is not set
CONFIG_EDAC_I3000=y
CONFIG_EDAC_I3200=y
CONFIG_EDAC_X38=y
# CONFIG_EDAC_I5400 is not set
CONFIG_EDAC_I7CORE=y
CONFIG_EDAC_I82860=y
CONFIG_EDAC_R82600=y
CONFIG_EDAC_I5000=y
CONFIG_EDAC_I5100=y
CONFIG_EDAC_I7300=y
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
# CONFIG_RTC_SYSTOHC is not set
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
CONFIG_RTC_INTF_PROC=y
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_88PM860X is not set
# CONFIG_RTC_DRV_88PM80X is not set
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=y
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_MAX6900=y
# CONFIG_RTC_DRV_MAX8907 is not set
CONFIG_RTC_DRV_MAX8997=y
CONFIG_RTC_DRV_RS5C372=y
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
CONFIG_RTC_DRV_ISL12057=y
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_PCF8523=y
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF8583=y
# CONFIG_RTC_DRV_M41T80 is not set
CONFIG_RTC_DRV_BQ32K=y
# CONFIG_RTC_DRV_TWL4030 is not set
CONFIG_RTC_DRV_TPS6586X=y
# CONFIG_RTC_DRV_TPS80031 is not set
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=y
CONFIG_RTC_DRV_RV3029C2=y
CONFIG_RTC_DRV_S5M=y

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1742=y
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
CONFIG_RTC_DRV_MSM6242=y
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_RP5C01=y
# CONFIG_RTC_DRV_V3020 is not set
# CONFIG_RTC_DRV_DS2404 is not set
CONFIG_RTC_DRV_WM831X=y
CONFIG_RTC_DRV_PCF50633=y

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=y
# CONFIG_RTC_DRV_MOXART is not set

#
# HID Sensor RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=y
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
# CONFIG_UIO_NETX is not set
CONFIG_UIO_MF624=y
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
# CONFIG_VIRTIO_BALLOON is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
CONFIG_ET131X=y
CONFIG_SLICOSS=y
CONFIG_ECHO=y
CONFIG_RTS5208=y
CONFIG_RTS5208_DEBUG=y
CONFIG_DX_SEP=y
CONFIG_FB_SM7XX=y
CONFIG_CRYSTALHD=y
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_FT1000=y

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ANDROID_LOGGER=y
# CONFIG_ANDROID_TIMED_OUTPUT is not set
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
# CONFIG_ANDROID_INTF_ALARM_DEV is not set
# CONFIG_SYNC is not set
CONFIG_ION=y
CONFIG_ION_TEST=y
CONFIG_ION_DUMMY=y
# CONFIG_NET_VENDOR_SILICOM is not set
CONFIG_DGRP=y
CONFIG_GOLDFISH_AUDIO=y
CONFIG_MTD_GOLDFISH_NAND=y
CONFIG_XILLYBUS=y
# CONFIG_XILLYBUS_PCIE is not set
CONFIG_DGNC=y
CONFIG_DGAP=y
# CONFIG_X86_PLATFORM_DEVICES is not set
CONFIG_GOLDFISH_PIPE=y
# CONFIG_CHROME_PLATFORMS is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y

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
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_GPIO is not set
CONFIG_EXTCON_MAX14577=y
# CONFIG_EXTCON_MAX8997 is not set
CONFIG_MEMORY=y
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_TWL=y
# CONFIG_PWM_TWL_LED is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set
CONFIG_POWERCAP=y
# CONFIG_INTEL_RAPL is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
# CONFIG_GOOGLE_MEMCONSOLE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
# CONFIG_EXT2_FS_POSIX_ACL is not set
# CONFIG_EXT2_FS_SECURITY is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
# CONFIG_REISERFS_FS_POSIX_ACL is not set
CONFIG_REISERFS_FS_SECURITY=y
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
CONFIG_XFS_WARN=y
# CONFIG_XFS_DEBUG is not set
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=y
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
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
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
# CONFIG_PROC_VMCORE is not set
CONFIG_PROC_SYSCTL=y
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_SYSFS=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=y
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=y
# CONFIG_HFSPLUS_FS_POSIX_ACL is not set
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
# CONFIG_BFS_FS is not set
CONFIG_EFS_FS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
# CONFIG_JFFS2_FS_WRITEBUFFER is not set
# CONFIG_JFFS2_SUMMARY is not set
CONFIG_JFFS2_FS_XATTR=y
CONFIG_JFFS2_FS_POSIX_ACL=y
# CONFIG_JFFS2_FS_SECURITY is not set
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
# CONFIG_JFFS2_ZLIB is not set
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
# CONFIG_JFFS2_CMODE_NONE is not set
# CONFIG_JFFS2_CMODE_PRIORITY is not set
CONFIG_JFFS2_CMODE_SIZE=y
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
# CONFIG_UBIFS_FS is not set
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
CONFIG_SQUASHFS_DECOMP_MULTI=y
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
# CONFIG_SQUASHFS_XATTR is not set
CONFIG_SQUASHFS_ZLIB=y
CONFIG_SQUASHFS_LZO=y
# CONFIG_SQUASHFS_XZ is not set
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
# CONFIG_OMFS_FS is not set
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_RAM is not set
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
CONFIG_UFS_DEBUG=y
CONFIG_F2FS_FS=y
# CONFIG_F2FS_STAT_FS is not set
# CONFIG_F2FS_FS_XATTR is not set
# CONFIG_F2FS_CHECK_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=y
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
CONFIG_DLM_DEBUG=y

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
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
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
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=y
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_PREEMPT is not set

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
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
CONFIG_PROVE_RCU_DELAY=y
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_TORTURE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_VERBOSE=y
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_FAULT_INJECTION=y
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MAKE_REQUEST is not set
CONFIG_FAIL_IO_TIMEOUT=y
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
CONFIG_LATENCYTOP=y
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
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_DMA_API_DEBUG=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DOUBLEFAULT is not set
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
CONFIG_DEBUG_NMI_SELFTEST=y
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
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
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y

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
# CONFIG_CRYPTO_LRW is not set
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
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_CCP is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_LGUEST=y
# CONFIG_BINARY_PRINTF is not set

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
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
# CONFIG_XZ_DEC_ARMTHUMB is not set
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_LRU_CACHE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y

--pWyiEgJYm5f9v55/--
