Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab3KKB3l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 20:29:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:59776 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab3KKB3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 20:29:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,674,1378882800"; 
   d="log'?scan'208";a="425305549"
Date: Mon, 11 Nov 2013 09:29:27 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [seqcount] INFO: trying to register non-static key.
Message-ID: <20131111012927.GA404@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit 1ca7d67cf5d5a2aef26a8d9afd789006fa098347
Author: John Stultz <john.stultz@linaro.org>
Date:   Mon Oct 7 15:51:59 2013 -0700

    seqcount: Add lockdep functionality to seqcount/seqlock structures
    
    Currently seqlocks and seqcounts don't support lockdep.
    
    After running across a seqcount related deadlock in the timekeeping
    code, I used a less-refined and more focused variant of this patch
    to narrow down the cause of the issue.
    
    This is a first-pass attempt to properly enable lockdep functionality
    on seqlocks and seqcounts.
    
    Since seqcounts are used in the vdso gettimeofday code, I've provided
    non-lockdep accessors for those needs.
    
    I've also handled one case where there were nested seqlock writers
    and there may be more edge cases.
    
    Comments and feedback would be appreciated!
    
    Signed-off-by: John Stultz <john.stultz@linaro.org>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Cc: Eric Dumazet <eric.dumazet@gmail.com>
    Cc: Li Zefan <lizefan@huawei.com>
    Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    Cc: Steven Rostedt <rostedt@goodmis.org>
    Cc: "David S. Miller" <davem@davemloft.net>
    Cc: netdev@vger.kernel.org
    Link: http://lkml.kernel.org/r/1381186321-4906-3-git-send-email-john.stultz@linaro.org
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

+----------------------------------------+----+
|                                        |    |
+----------------------------------------+----+
| has_kernel_error_warning               | 19 |
| INFO:trying_to_register_non-static_key | 19 |
+----------------------------------------+----+

[    4.124336] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[    4.125354] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    4.126299] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    4.127282] INFO: trying to register non-static key.
[    4.128027] the code is fine but needs lockdep annotation.
[    4.128027] turning off the locking correctness validator.
[    4.128027] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-next-20131108-10601-gbad570d #2
[    4.128027] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.128027] Workqueue: events_unbound async_run_entry_fn
[    4.128027]  7908e744 00000000 78019968 79dc7cf2 7a80e0a8 780199a0 7908953e 7a1b7f4d
[    4.128027]  7a1b7fa7 7a1b7f7d 7f368608 00000000 00000011 44374011 0000a805 7f368110
[    4.128027]  7f368110 85bf2a70 00000000 780199cc 7908a1c5 00000000 00000001 00000000
[    4.128027] Call Trace:
[    4.128027]  [<7908e744>] ? console_unlock+0x353/0x380
[    4.128027]  [<79dc7cf2>] dump_stack+0x48/0x60
[    4.128027]  [<7908953e>] __lock_acquire.isra.26+0x7e3/0xceb
[    4.128027]  [<7908a1c5>] lock_acquire+0x71/0x9a
[    4.128027]  [<794079aa>] ? blk_throtl_bio+0x1c3/0x485
[    4.128027]  [<7940658b>] throtl_update_dispatch_stats+0x7c/0x153
[    4.128027]  [<794079aa>] ? blk_throtl_bio+0x1c3/0x485
[    4.128027]  [<794079aa>] blk_throtl_bio+0x1c3/0x485
[    4.128027]  [<7907c7f9>] ? sched_clock_local+0x17/0x106
[    4.128027]  [<7907ca8b>] ? sched_clock_cpu+0x105/0x113
[    4.128027]  [<793f2fee>] generic_make_request_checks+0x3ca/0x3e1
[    4.128027]  [<7907ca8b>] ? sched_clock_cpu+0x105/0x113
[    4.128027]  [<793f4613>] generic_make_request+0xf/0xb0
[    4.128027]  [<793f4723>] submit_bio+0x6f/0xd8
[    4.128027]  [<79116695>] _submit_bh+0x228/0x245
[    4.128027]  [<791166bc>] submit_bh+0xa/0xc
[    4.128027]  [<7911768e>] block_read_full_page+0x2a8/0x2c3
[    4.128027]  [<7911a555>] ? bio_dirty_fn+0x6f/0x6f
[    4.128027]  [<790bed0c>] ? add_to_page_cache_locked+0xb4/0xe2
[    4.128027]  [<7911a7eb>] ? blkdev_write_begin+0x20/0x20
[    4.128027]  [<7911a7eb>] ? blkdev_write_begin+0x20/0x20
[    4.128027]  [<7911a7fa>] blkdev_readpage+0xf/0x11
[    4.128027]  [<790bf877>] do_read_cache_page+0x6e/0x11b
[    4.128027]  [<790c0649>] read_cache_page_async+0x19/0x1e
[    4.128027]  [<7911a7eb>] ? blkdev_write_begin+0x20/0x20
[    4.128027]  [<790c067a>] read_cache_page+0xb/0x12
[    4.128027]  [<7940170d>] read_dev_sector+0x26/0x61
[    4.128027]  [<7940215b>] read_lba+0xae/0xf9
[    4.128027]  [<790e60b6>] ? kmem_cache_alloc+0xf9/0x12b
[    4.128027]  [<7940268b>] efi_partition+0x17a/0x9c0
[    4.128027]  [<790c4c4f>] ? __alloc_pages_nodemask+0xe3/0x61e
[    4.128027]  [<79415849>] ? string.isra.4+0x29/0x93
[    4.128027]  [<79415849>] ? string.isra.4+0x29/0x93
[    4.128027]  [<794165e9>] ? vsnprintf+0x81/0x28b
[    4.128027]  [<79416ab2>] ? snprintf+0x15/0x17
[    4.128027]  [<79401844>] check_partition+0xe4/0x178
[    4.128027]  [<79401844>] ? check_partition+0xe4/0x178
[    4.128027]  [<79401496>] rescan_partitions+0x89/0x267
[    4.128027]  [<7911a8df>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    4.128027]  [<7911b696>] __blkdev_get+0x173/0x363
[    4.128027]  [<7911b8d1>] blkdev_get+0x4b/0x23d
[    4.128027]  [<7911af8f>] ? bdget+0xf8/0x105
[    4.128027]  [<796bc6c5>] ? put_device+0xf/0x11
[    4.128027]  [<793ff4c9>] add_disk+0x26b/0x3b5
[    4.128027]  [<796c4599>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    4.128027]  [<797e4d73>] sd_probe_async+0x111/0x198
[    4.128027]  [<79075b0a>] async_run_entry_fn+0x59/0xff
[    4.128027]  [<7906cb54>] process_one_work+0x1ef/0x349
[    4.128027]  [<7906cafb>] ? process_one_work+0x196/0x349
[    4.128027]  [<7906d0a5>] worker_thread+0x1a3/0x274
[    4.128027]  [<7906cf02>] ? rescuer_thread+0x233/0x233
[    4.128027]  [<79071767>] kthread+0xa5/0xaa
[    4.128027]  [<79070000>] ? maybe_kfree_parameter+0xc/0x3d
[    4.128027]  [<79ddb6bb>] ret_from_kernel_thread+0x1b/0x30
[    4.128027]  [<790716c2>] ? __kthread_parkme+0x50/0x50
[    4.178057]  sda: unknown partition table
[    4.182119] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.516964] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56

git bisect start e1e958029781a5f22a47807f9648ab9d221746f4 v3.12 --
git bisect good 513e72b3ae0e7d35b09b72c360e548781b345fe7  # 19:09     20+      0  Merge remote-tracking branch 'pm/linux-next'
git bisect good a73f39d6bb13cd0eadf566e202dbfd114de2b9bc  # 19:23     20+      0  Merge remote-tracking branch 'virtio/virtio-next'
git bisect good 8d31e8536540635a1d56c9cd4a30eefe7f236644  # 19:40     20+      0  Merge remote-tracking branch 'spi/for-next'
git bisect  bad 47b8d9c8c38a956094e7f6b231371331dd2dd0d9  # 19:56      0-      4  Merge branch 'x86/hyperv'
git bisect good 8a4d0b56b031455adcbe4a9383c3b497456fcfac  # 20:20     20+      0  Merge branch 'uprobes/core' of git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc into perf/core
git bisect good c90423d1de12fbeaf0c898e1db0e962de347302b  # 20:37     20+      0  Merge branch 'sched/core' into core/locking, to prepare the kernel/locking/ file move
git bisect  bad 25c1bd1db04d58967bbd979bea71e82db2292407  # 20:53      0-     11  Merge branch 'timers/core'
git bisect good 8a749de5e32d2b72def93f7bd7a2745580d75872  # 21:12     20+      0  Merge branch 'fortglx/3.13/time' of git://git.linaro.org/people/jstultz/linux into timers/core
git bisect  bad 226e4c81385ac8d47962d5660c54ff9df629c15e  # 21:30      0-      8  Merge branch 'irq/core'
git bisect  bad 5ac68e7c34a4797aa4ca9615e5a6603bda1abe9b  # 21:46      0-      4  ipv6: Fix possible ipv6 seqlock deadlock
git bisect good ed428bfc3caaa4b1e6cd15ea12c90c30291903f0  # 21:59     20+      0  locking: Move the rwsem code to kernel/locking/
git bisect good 827da44c61419f29ae3be198c342e2147f1a10cb  # 22:09     20+      0  net: Explicitly initialize u64_stats_sync structures for lockdep
git bisect  bad db751fe3ea6880ff5ac5abe60cb7b80deb5a4140  # 22:26      0-      1  cpuset: Fix potential deadlock w/ set_mems_allowed
git bisect  bad 1ca7d67cf5d5a2aef26a8d9afd789006fa098347  # 22:31      0-      6  seqcount: Add lockdep functionality to seqcount/seqlock structures
git bisect good 827da44c61419f29ae3be198c342e2147f1a10cb  # 22:33     60+      0  net: Explicitly initialize u64_stats_sync structures for lockdep
git bisect  bad bad570d77024cba808126d68a2072f6f8ce64c27  # 22:33      0-     19  Add linux-next specific files for 20131108
git bisect good 7b0833043b88a3188ffd2d6ea4b72bafb04ba4bd  # 22:54     60+      1  Revert "seqcount: Add lockdep functionality to seqcount/seqlock structures"
git bisect good 6c86ae2928f9e4cbf0d5844f5fcfd549e3450b8c  # 23:03     60+      0  Merge tag 'ftrace-urgent-3.12-v2' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace
git bisect  bad bad570d77024cba808126d68a2072f6f8ce64c27  # 23:03      0-     19  Add linux-next specific files for 20131108

Thanks,
Fengguang

--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-roam-7:20131109022732:i386-randconfig-j7-11082318:3.12.0-next-20131108-10601-gbad570d:2"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-next-20131108-10601-gbad570d (kbuild@ja=
ketown) (gcc version 4.8.1 (Debian 4.8.1-8) ) #2 SMP Sat Nov 9 02:13:35 CST=
 2013
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   UMC UMC UMC UMC
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
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
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[780fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x033fffff]
[    0.000000] Base memory trampoline at [7809b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e000000-0x0e3fffff]
[    0.000000]  [mem 0x0e000000-0x0e3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0dffffff]
[    0.000000]  [mem 0x08000000-0x0dffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x07ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0fffdfff]
[    0.000000]  [mem 0x0e400000-0x0fbfffff] page 2M
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x02cba000, 0x02cbafff] PGTABLE
[    0.000000] BRK [0x02cbb000, 0x02cbcfff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128392(97%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe450 000034 (v01 BOCHS  BXPCRSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: FACP 0fffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXP=
C 00000001)
[    0.000000] ACPI: DSDT 0fffe490 0011A9 (v01   BXPC   BXDSDT 00000001 INT=
L 20100528)
[    0.000000] ACPI: FACS 0fffff40 000040
[    0.000000] ACPI: SSDT 0ffff7a0 000796 (v01 BOCHS  BXPCSSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: APIC 0ffff680 000080 (v01 BOCHS  BXPCAPIC 00000001 BXP=
C 00000001)
[    0.000000] ACPI: HPET 0ffff640 000038 (v01 BOCHS  BXPCHPET 00000001 BXP=
C 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] BRK [0x02cbd000, 0x02cbdfff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 480 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
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
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffff9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:2 nr_cpu_ids:2 nr_n=
ode_ids:1
[    0.000000] PERCPU: Embedded 331 pages/cpu @85aa9000 s1340168 r0 d15608 =
u1355776
[    0.000000] pcpu-alloc: s1340168 r0 d15608 u1355776 alloc=3D331*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr daab7c0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64924
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/i386-randconfig-j7-11082318/next:master/.vml=
inuz-bad570d77024cba808126d68a2072f6f8ce64c27-20131109021750-6-roam branch=
=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randconfig-j7-11082318/bad570d7702=
4cba808126d68a2072f6f8ce64c27/vmlinuz-3.12.0-next-20131108-10601-gbad570d
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 193836K/261744K available (14198K kernel code, 1195K=
 rwdata, 5976K rodata, 1948K init, 5980K bss, 67908K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffa95000 - 0xfffff000   (5544 kB)
[    0.000000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.000000]     vmalloc : 0x887fe000 - 0xff3fe000   (1900 MB)
[    0.000000]     lowmem  : 0x78000000 - 0x87ffe000   ( 255 MB)
[    0.000000]       .init : 0x7a4e1000 - 0x7a6c8000   (1948 kB)
[    0.000000]       .data : 0x79dddb9b - 0x7a4e0e00   (7180 kB)
[    0.000000]       .text : 0x79000000 - 0x79dddb9b   (14198 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3D8540c000 soft=3D8540e000
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
[    0.000000] allocated 524288 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2892.982 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 5785.96 Bogo=
MIPS (lpj=3D2892982)
[    0.003382] pid_max: default: 4096 minimum: 301
[    0.004248] Security Framework initialized
[    0.005018] AppArmor: AppArmor disabled by boot time parameter
[    0.006134] Mount-cache hash table entries: 512
[    0.008465] Initializing cgroup subsys memory
[    0.009037] Initializing cgroup subsys devices
[    0.009646] Initializing cgroup subsys blkio
[    0.010012] Initializing cgroup subsys net_prio
[    0.011151] mce: CPU supports 10 MCE banks
[    0.012015] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.012015] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.012015] tlb_flushall_shift: 6
[    0.018375] Freeing SMP alternatives memory: 52K (7a6c8000 - 7a6d5000)
[    0.026494] ACPI: Core revision 20130927
[    0.030837] ACPI: All ACPI Tables successfully acquired
[    0.032431] Getting VERSION: 50014
[    0.033017] Getting VERSION: 50014
[    0.034015] Getting ID: 0
[    0.034398] Getting ID: f000000
[    0.035019] Getting LVT0: 8700
[    0.035510] Getting LVT1: 8400
[    0.036010] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.037101] enabled ExtINT on CPU#0
[    0.039776] ENABLING IO-APIC IRQs
[    0.040015] init IO_APIC IRQs
[    0.041010]  apic 0 pin 0 not connected
[    0.041739] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.042038] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.043038] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.044037] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.045035] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.047009] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.048033] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.049035] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.050030] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.051041] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.052042] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.053035] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.054032] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.055036] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.056033] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.058005]  apic 0 pin 16 not connected
[    0.058713]  apic 0 pin 17 not connected
[    0.059005]  apic 0 pin 18 not connected
[    0.059522]  apic 0 pin 19 not connected
[    0.060005]  apic 0 pin 20 not connected
[    0.061006]  apic 0 pin 21 not connected
[    0.061553]  apic 0 pin 22 not connected
[    0.062005]  apic 0 pin 23 not connected
[    0.062688] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.063006] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.064216] Using local APIC timer interrupts.
[    0.064216] calibrating APIC timer ...
[    0.066000] ... lapic delta =3D 6249994
[    0.066000] ... PM-Timer delta =3D 357894
[    0.066000] ... PM-Timer result ok
[    0.066000] ..... delta 6249994
[    0.066000] ..... mult: 268435198
[    0.066000] ..... calibration result: 999999
[    0.066000] ..... CPU clock speed is 2892.0375 MHz.
[    0.066000] ..... host bus clock speed is 999.0999 MHz.
[    0.066093] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.072573] CPU 1 irqstacks, hard=3D85522000 soft=3D85524000
[    0.073006] x86: Booting SMP configuration:
[    0.074005] .... node  #0, CPUs:      #1
[    0.002000] Initializing CPU#1
[    0.003000] kvm-clock: cpu 1, msr 0:fffd041, secondary cpu clock
[    0.003000] masked ExtINT on CPU#1

[    0.089134] x86: Booted up 1 node, 2 CPUs
[    0.089083] KVM setup async PF for cpu 1
[    0.089083] kvm-stealtime: cpu 1, msr dbf67c0
[    0.090011] smpboot: Total of 2 processors activated (11571.92 BogoMIPS)
[    0.094013] devtmpfs: initialized
[    0.097337] EVM: security.selinux
[    0.097918] EVM: security.SMACK64
[    0.098006] EVM: security.ima
[    0.099006] EVM: security.capability
[    0.101501] xor: measuring software checksum speed
[    0.112019]    pIII_sse  :   140.000 MB/sec
[    0.122034]    prefetch64-sse:   148.000 MB/sec
[    0.122828] xor: using function: prefetch64-sse (148.000 MB/sec)
[    0.124556] regulator-dummy: no parameters
[    0.125467] NET: Registered protocol family 16
[    0.128728] cpuidle: using governor ladder
[    0.129008] cpuidle: using governor menu
[    0.131705] ACPI: bus type PCI registered
[    0.132074] dca service started, version 1.12.1
[    0.133111] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.170803] bio: create slab <bio-0> at 0
[    0.189014] raid6: mmxx1     2285 MB/s
[    0.206036] raid6: mmxx2     2660 MB/s
[    0.223026] raid6: sse1x1    2015 MB/s
[    0.240024] raid6: sse1x2    2625 MB/s
[    0.257023] raid6: sse2x1    3925 MB/s
[    0.274016] raid6: sse2x2    5121 MB/s
[    0.274689] raid6: using algorithm sse2x2 (5121 MB/s)
[    0.275006] raid6: using intx1 recovery algorithm
[    0.277297] ACPI: Added _OSI(Module Device)
[    0.278008] ACPI: Added _OSI(Processor Device)
[    0.279007] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.279805] ACPI: Added _OSI(Processor Aggregator Device)
[    0.295462] ACPI: Interpreter enabled
[    0.296022] ACPI: (supports S0 S5)
[    0.296603] ACPI: Using IOAPIC for interrupt routing
[    0.297082] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.320182] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.321016] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.322039] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.324517] PCI host bridge to bus 0000:00
[    0.325010] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.326009] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.327009] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.328009] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.329010] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.330065] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.333030] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.335463] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.341489] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.345456] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.347342] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.348026] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.350212] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.354082] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.358067] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.370125] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.372686] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.375010] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.377000] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.378000] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.379284] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.382009] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.385009] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.396880] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.398000] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.399875] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.410803] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.413009] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.416009] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.427481] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.430015] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.433009] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.444117] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.447010] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.449010] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.460638] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.463009] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.466009] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.477144] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.479080] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.486692] pci_bus 0000:00: on NUMA node 0
[    0.489672] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.491210] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.492641] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.494160] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.495445] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.497866] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.498021] ACPI: \_SB_.PCI0: notify handler is installed
[    0.500188] Found 1 acpi root devices
[    0.505314] SCSI subsystem initialized
[    0.506154] libata version 3.00 loaded.
[    0.507147] ACPI: bus type USB registered
[    0.507992] usbcore: registered new interface driver usbfs
[    0.509065] usbcore: registered new interface driver hub
[    0.510273] usbcore: registered new device driver usb
[    0.511400] pps_core: LinuxPPS API ver. 1 registered
[    0.512006] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.514032] PTP clock support registered
[    0.515241] wmi: Mapper loaded
[    0.515937] PCI: Using ACPI for IRQ routing
[    0.516014] PCI: pci_cache_line_size set to 64 bytes
[    0.517390] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.519009] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.521227] NET: Registered protocol family 23
[    0.522141] Bluetooth: Core ver 2.17
[    0.522846] NET: Registered protocol family 31
[    0.523006] Bluetooth: HCI device and connection manager initialized
[    0.524049] Bluetooth: HCI socket layer initialized
[    0.525018] Bluetooth: L2CAP socket layer initialized
[    0.526045] Bluetooth: SCO socket layer initialized
[    0.527042] NET: Registered protocol family 8
[    0.528007] NET: Registered protocol family 20
[    0.529118] NetLabel: Initializing
[    0.529691] NetLabel:  domain hash size =3D 128
[    0.530005] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.531184] NetLabel:  unlabeled traffic allowed by default
[    0.532020] nfc: nfc_init: NFC Core ver 0.1
[    0.533124] NET: Registered protocol family 39
[    0.536420] Switched to clocksource kvm-clock
[    0.537192] FS-Cache: Loaded
[    0.537938] CacheFiles: Loaded
[    0.538504] pnp: PnP ACPI init
[    0.538964] ACPI: bus type PNP registered
[    0.539642] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.540814] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.541745] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.542992] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.543882] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.545110] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.546070] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.547124] pnp 00:03: [dma 2]
[    0.547630] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.548679] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.549811] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.550783] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.551883] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.553454] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.554655] pnp: PnP ACPI: found 7 devices
[    0.555251] ACPI: bus type PNP unregistered
[    0.592035] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.592752] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.593501] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.594365] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.595480] NET: Registered protocol family 2
[    0.597099] TCP established hash table entries: 2048 (order: 1, 8192 byt=
es)
[    0.598066] TCP bind hash table entries: 2048 (order: 4, 90112 bytes)
[    0.599157] TCP: Hash tables configured (established 2048 bind 2048)
[    0.600182] TCP: reno registered
[    0.600596] UDP hash table entries: 128 (order: 1, 12288 bytes)
[    0.601415] UDP-Lite hash table entries: 128 (order: 1, 12288 bytes)
[    0.602626] NET: Registered protocol family 1
[    0.603967] RPC: Registered named UNIX socket transport module.
[    0.604792] RPC: Registered udp transport module.
[    0.605393] RPC: Registered tcp transport module.
[    0.605989] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.606871] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.607648] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.608424] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.609360] pci 0000:00:02.0: Boot video device
[    0.610042] PCI: CLS 0 bytes, default 64
[    0.611446] Unpacking initramfs...
[    2.306871] Freeing initrd memory: 25284K (8673f000 - 87ff0000)
[    2.309348] kvm: no hardware support
[    2.310312] Machine check injector initialized
[    2.312110] cryptomgr_test (24) used greatest stack depth: 7320 bytes le=
ft
[    2.313317] PCLMULQDQ-NI instructions are not detected.
[    2.314288] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    2.317825] Initializing RT-Tester: OK
[    2.319281] audit: initializing netlink socket (disabled)
[    2.320375] type=3D2000 audit(1383935242.496:1): initialized
[    2.322234] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    2.324138] VFS: Disk quotas dquot_6.5.2
[    2.324955] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.327169] DLM installed
[    2.329647] FS-Cache: Netfs 'nfs' registered for caching
[    2.331954] Key type cifs.spnego registered
[    2.332797] Key type cifs.idmap registered
[    2.333778] JFS: nTxBlock =3D 1712, nTxLock =3D 13698
[    2.336285] 9p: Installing v9fs 9p2000 file system support
[    2.337323] FS-Cache: Netfs '9p' registered for caching
[    2.338457] NILFS version 2 loaded
[    2.339148] OCFS2 1.5.0
[    2.340044] ocfs2: Registered cluster interface o2cb
[    2.340949] OCFS2 DLMFS 1.5.0
[    2.341781] OCFS2 User DLM kernel interface loaded
[    2.342681] OCFS2 Node Manager 1.5.0
[    2.343882] OCFS2 DLM 1.5.0
[    2.344959] bio: create slab <bio-1> at 1
[    2.346490] Btrfs loaded, debug=3Don, assert=3Don
[    2.347318] btrfs: selftest: Running btrfs free space cache tests
[    2.348433] btrfs: selftest: Running extent only tests
[    2.349451] btrfs: selftest: Running bitmap only tests
[    2.350458] btrfs: selftest: Running bitmap and extent tests
[    2.351579] btrfs: selftest: Free space cache tests finished
[    2.353774] GFS2 installed
[    2.358108] cryptomgr_test (70) used greatest stack depth: 7248 bytes le=
ft
[    2.361683] NET: Registered protocol family 38
[    2.362561] Key type asymmetric registered
[    2.363440] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    2.364978] io scheduler noop registered (default)
[    2.365879] io scheduler deadline registered
[    2.366758] io scheduler cfq registered
[    2.367464] list_sort_test: start testing list_sort()
[    2.369068] test_string_helpers: Running tests...
[    2.376578] crc32: CRC_LE_BITS =3D 1, CRC_BE BITS =3D 1
[    2.377463] crc32: self tests passed, processed 225944 bytes in 3226180 =
nsec
[    2.382205] crc32c: CRC_LE_BITS =3D 1
[    2.382846] crc32c: self tests passed, processed 225944 bytes in 1692935=
 nsec
[    2.864613] crc32_combine: 8373 self tests passed
[    3.313182] tsc: Refined TSC clocksource calibration: 2892.960 MHz
[    3.344878] crc32c_combine: 8373 self tests passed
[    3.346604] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.347622] cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
[    3.348985] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.350723] rivafb_setup START
[    3.351601] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    3.353211] no IO addresses supplied
[    3.354801] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    3.356922] usbcore: registered new interface driver smscufx
[    3.358875] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    3.360630] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.385009] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    3.388331] Cyclades driver 2.6
[    3.389124] MOXA Intellio family driver version 6.0k
[    3.390186] Initializing Nozomi driver 2.1d
[    3.391079] RocketPort device driver module, version 2.09, 12-June-2003
[    3.392335] No rocketport ports found; unloading driver
[    3.393282] SyncLink GT
[    3.393760] SyncLink GT, tty major#247
[    3.394503] SyncLink GT no devices found
[    3.395239] SyncLink MultiPort driver $Revision: 4.38 $
[    3.417934] SyncLink MultiPort driver $Revision: 4.38 $, tty major#246
[    3.419183] SyncLink serial driver $Revision: 4.38 $
[    3.440701] SyncLink serial driver $Revision: 4.38 $, tty major#245
[    3.442537] lp: driver loaded but no devices found
[    3.443421] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    3.444714] ac.o: No PCI boards found.
[    3.445400] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    3.446686] toshiba: not a supported Toshiba laptop
[    3.447605] ppdev: user-space parallel port driver
[    3.448649] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    3.449959] platform pc8736x_gpio.0: no device found
[    3.451096] nsc_gpio initializing
[    3.451771] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    3.453352] Hangcheck: Using getrawmonotonic().
[    3.454466] [drm] Initialized drm 1.1.0 20060810
[    3.455707] [drm] radeon kernel modesetting enabled.
[    3.457379] parport_pc 00:04: reported by Plug and Play ACPI
[    3.458501] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[    3.460387] lp0: using parport0 (interrupt-driven).
[    3.462357] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    3.463660] dummy-irq: no IRQ given.  Use irq=3DN
[    3.464540] lkdtm: No crash points registered, enable through debugfs
[    3.465804] Phantom Linux Driver, version n0.9.8, init OK
[    3.467045] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    3.468545] c2port c2port0: C2 port uc added
[    3.469370] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    3.471124] Guest personality initialized and is inactive
[    3.472365] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D59)
[    3.473574] Initialized host personality
[    3.474892] usbcore: registered new interface driver viperboard
[    3.476459] usbcore: registered new interface driver port100
[    3.478040] Loading iSCSI transport class v2.0-870.
[    3.480571] iscsi: registered transport (tcp)
[    3.481829] Adaptec aacraid driver 1.2-0[30200]-ms
[    3.483811] isci: Intel(R) C600 SAS Controller Driver - version 1.1.0
[    3.485306] scsi: <fdomain> Detection failed (no card)
[    3.488136] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    3.489235] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:3)
[    3.492250] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    3.493305] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:3)
[    3.496314] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    3.498908] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    3.967729] DC390: clustering now enabled by default. If you get problem=
s load
[    3.969096]        with "disable_clustering=3D1" and report to maintaine=
rs
[    3.970383] megasas: 06.700.06.00-rc1 Sat. Aug. 31 17:00:00 PDT 2013
[    3.971683] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    3.972923] 3ware Storage Controller device driver for Linux v1.26.02.00=
3.
[    3.974208] imm: Version 2.05 (for Linux 2.4.0)
[    3.975725] ipr: IBM Power RAID SCSI Device Driver version: 2.6.0 (Novem=
ber 16, 2012)
[    3.977210] RocketRAID 3xxx/4xxx Controller driver v1.8
[    3.978209] stex: Promise SuperTrak EX Driver version: 4.6.0000.4
[    3.979391] libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age =
0xf, 4 bits.
[    3.980781] libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx=
 0.
[    3.982023] Chelsio T3 iSCSI Driver cxgb3i v2.0.0 (Jun. 2010)
[    3.983170] iscsi: registered transport (cxgb3i)
[    3.984041] Chelsio T4/T5 iSCSI Driver cxgb4i v0.9.4
[    3.984988] iscsi: registered transport (cxgb4i)
[    3.985937] iscsi: registered transport (be2iscsi)
[    3.986829] In beiscsi_module_init, tt=3D7a44069c
[    3.987869] esas2r: driver will not be loaded because no ATTO esas2r dev=
ices were found
[    3.989846] SCSI Media Changer driver v0.25=20
[    3.993825] scsi_debug: host protection
[    3.994545] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[    3.996851] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[    3.999087] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.=
00 MiB)
[    4.000330] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.002175] SSFDC read-only Flash Translation layer
[    4.004782] device id =3D 2440
[    4.005239] device id =3D 2480
[    4.005614] device id =3D 24c0
[    4.005993] device id =3D 24d0
[    4.006387] device id =3D 25a1
[    4.006800] device id =3D 2670
[    4.007429] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel =
Networks.
[    4.008408] pmc551: not detected
[    4.009258] sd 0:0:0:0: [sda] Write Protect is off
[    4.010002] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    4.012475] Spectra MTD driver built on Nov  9 2013 @ 01:11:48
[    4.053623] No valid DiskOnChip devices found
[    4.054339] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    4.055545] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    4.056783] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    4.057960] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    4.059205] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    4.060450] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    4.061681] NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba N=
AND 128MiB 1,8V 8-bit)
[    4.062768] NAND device: 128MiB, SLC, page size: 512, OOB size: 16
[    4.063742] flash size: 128 MiB
[    4.064206] page size: 512 bytes
[    4.064681] OOB area size: 16 bytes
[    4.065140] sector size: 16 KiB
[    4.065527] pages number: 262144
[    4.065933] pages per sector: 32
[    4.066356] bus width: 8
[    4.066732] bits in sector size: 14
[    4.067193] bits in page size: 9
[    4.067626] bits in OOB size: 4
[    4.068030] flash size with OOB: 135168 KiB
[    4.068545] page address bytes: 4
[    4.070338] sector address bytes: 3
[    4.070779] options: 0x42
[    4.071690] Scanning device for bad blocks
[    4.110271] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    4.111153] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    4.112419] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[    4.114592] parport0: cannot grant exclusive access for device spi-lm70l=
lp
[    4.115465] spi-lm70llp: spi_lm70llp probe fail, status -12
[    4.117789] libphy: Fixed MDIO Bus: probed
[    4.119458] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.=
de
[    4.120430] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.18 (Sept 0=
1, 2013)
[    4.122432] enic: Cisco VIC Ethernet NIC Driver, ver 2.1.1.50
[    4.123253] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[    4.124336] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-2=
9)
[    4.125354] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-=
NAPI
[    4.126299] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    4.127282] INFO: trying to register non-static key.
[    4.128027] the code is fine but needs lockdep annotation.
[    4.128027] turning off the locking correctness validator.
[    4.128027] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-next-20=
131108-10601-gbad570d #2
[    4.128027] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.128027] Workqueue: events_unbound async_run_entry_fn
[    4.128027]  7908e744 00000000 78019968 79dc7cf2 7a80e0a8 780199a0 79089=
53e 7a1b7f4d
[    4.128027]  7a1b7fa7 7a1b7f7d 7f368608 00000000 00000011 44374011 0000a=
805 7f368110
[    4.128027]  7f368110 85bf2a70 00000000 780199cc 7908a1c5 00000000 00000=
001 00000000
[    4.128027] Call Trace:
[    4.128027]  [<7908e744>] ? console_unlock+0x353/0x380
[    4.128027]  [<79dc7cf2>] dump_stack+0x48/0x60
[    4.128027]  [<7908953e>] __lock_acquire.isra.26+0x7e3/0xceb
[    4.128027]  [<7908a1c5>] lock_acquire+0x71/0x9a
[    4.128027]  [<794079aa>] ? blk_throtl_bio+0x1c3/0x485
[    4.128027]  [<7940658b>] throtl_update_dispatch_stats+0x7c/0x153
[    4.128027]  [<794079aa>] ? blk_throtl_bio+0x1c3/0x485
[    4.128027]  [<794079aa>] blk_throtl_bio+0x1c3/0x485
[    4.128027]  [<7907c7f9>] ? sched_clock_local+0x17/0x106
[    4.128027]  [<7907ca8b>] ? sched_clock_cpu+0x105/0x113
[    4.128027]  [<793f2fee>] generic_make_request_checks+0x3ca/0x3e1
[    4.128027]  [<7907ca8b>] ? sched_clock_cpu+0x105/0x113
[    4.128027]  [<793f4613>] generic_make_request+0xf/0xb0
[    4.128027]  [<793f4723>] submit_bio+0x6f/0xd8
[    4.128027]  [<79116695>] _submit_bh+0x228/0x245
[    4.128027]  [<791166bc>] submit_bh+0xa/0xc
[    4.128027]  [<7911768e>] block_read_full_page+0x2a8/0x2c3
[    4.128027]  [<7911a555>] ? bio_dirty_fn+0x6f/0x6f
[    4.128027]  [<790bed0c>] ? add_to_page_cache_locked+0xb4/0xe2
[    4.128027]  [<7911a7eb>] ? blkdev_write_begin+0x20/0x20
[    4.128027]  [<7911a7eb>] ? blkdev_write_begin+0x20/0x20
[    4.128027]  [<7911a7fa>] blkdev_readpage+0xf/0x11
[    4.128027]  [<790bf877>] do_read_cache_page+0x6e/0x11b
[    4.128027]  [<790c0649>] read_cache_page_async+0x19/0x1e
[    4.128027]  [<7911a7eb>] ? blkdev_write_begin+0x20/0x20
[    4.128027]  [<790c067a>] read_cache_page+0xb/0x12
[    4.128027]  [<7940170d>] read_dev_sector+0x26/0x61
[    4.128027]  [<7940215b>] read_lba+0xae/0xf9
[    4.128027]  [<790e60b6>] ? kmem_cache_alloc+0xf9/0x12b
[    4.128027]  [<7940268b>] efi_partition+0x17a/0x9c0
[    4.128027]  [<790c4c4f>] ? __alloc_pages_nodemask+0xe3/0x61e
[    4.128027]  [<79415849>] ? string.isra.4+0x29/0x93
[    4.128027]  [<79415849>] ? string.isra.4+0x29/0x93
[    4.128027]  [<794165e9>] ? vsnprintf+0x81/0x28b
[    4.128027]  [<79416ab2>] ? snprintf+0x15/0x17
[    4.128027]  [<79401844>] check_partition+0xe4/0x178
[    4.128027]  [<79401844>] ? check_partition+0xe4/0x178
[    4.128027]  [<79401496>] rescan_partitions+0x89/0x267
[    4.128027]  [<7911a8df>] ? bdev_inode_switch_bdi+0xd2/0xe6
[    4.128027]  [<7911b696>] __blkdev_get+0x173/0x363
[    4.128027]  [<7911b8d1>] blkdev_get+0x4b/0x23d
[    4.128027]  [<7911af8f>] ? bdget+0xf8/0x105
[    4.128027]  [<796bc6c5>] ? put_device+0xf/0x11
[    4.128027]  [<793ff4c9>] add_disk+0x26b/0x3b5
[    4.128027]  [<796c4599>] ? __pm_runtime_use_autosuspend+0x4a/0x4f
[    4.128027]  [<797e4d73>] sd_probe_async+0x111/0x198
[    4.128027]  [<79075b0a>] async_run_entry_fn+0x59/0xff
[    4.128027]  [<7906cb54>] process_one_work+0x1ef/0x349
[    4.128027]  [<7906cafb>] ? process_one_work+0x196/0x349
[    4.128027]  [<7906d0a5>] worker_thread+0x1a3/0x274
[    4.128027]  [<7906cf02>] ? rescuer_thread+0x233/0x233
[    4.128027]  [<79071767>] kthread+0xa5/0xaa
[    4.128027]  [<79070000>] ? maybe_kfree_parameter+0xc/0x3d
[    4.128027]  [<79ddb6bb>] ret_from_kernel_thread+0x1b/0x30
[    4.128027]  [<790716c2>] ? __kthread_parkme+0x50/0x50
[    4.178057]  sda: unknown partition table
[    4.182119] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.516964] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56
[    4.518881] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
[    4.520169] igbvf: Intel(R) Gigabit Virtual Function Network Driver - ve=
rsion 2.0.2-k
[    4.521652] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[    4.522873] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - vers=
ion 3.15.1-k
[    4.524300] ixgbe: Copyright (c) 1999-2013 Intel Corporation.
[    4.525410] i40e: Intel(R) Ethernet Connection XL710 Network Driver - ve=
rsion 0.3.11-k
[    4.526926] i40e: Copyright (c) 2013 Intel Corporation.
[    4.527964] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2=
-NAPI
[    4.529267] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    4.530414] sky2: driver version 1.30
[    4.531278] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[    4.532716] pch_gbe: EG20T PCH Gigabit Ethernet Driver - version 1.01
[    4.534186] Solarflare NET driver v4.0
[    4.536952] usbcore: registered new interface driver stir4200
[    4.539189] usbcore: registered new interface driver mcs7780
[    4.540591] usbcore: registered new interface driver ksdazzle-sir
[    4.541791] usbcore: registered new interface driver ks959-sir
[    4.542946] PPP generic driver version 2.4.2
[    4.543960] PPP Deflate Compression module registered
[    4.544904] PPP MPPE Compression module registered
[    4.545845] NET: Registered protocol family 24
[    4.546676] PPTP driver version 0.8.5
[    4.547485] usbcore: registered new interface driver i2400m_usb
[    4.549715] VMware vmxnet3 virtual NIC driver - version 1.2.0.0-k-NAPI
[    4.551054] usbcore: registered new interface driver catc
[    4.552177] usbcore: registered new interface driver r8152
[    4.553257] usbcore: registered new interface driver ipheth
[    4.554376] Madge ATM Ambassador driver version 1.2.4
[    4.555370] amb: debug bitmap is 0
[    4.556066] Madge ATM Horizon [Ultra] driver version 1.2.1
[    4.557136] hrz: debug bitmap is 0
[    4.557860] fore200e: FORE Systems 200E-series ATM driver - version 0.3e
[    4.559250] idt77252_init: at 7a51b529
[    4.559971] Solos PCI Driver Version 1.04
[    4.560830] adummy: version 1.0
[    4.562140] parport0: cannot grant exclusive access for device ks0108
[    4.563278] ks0108: ERROR: parport didn't register new device
[    4.564288] cfag12864b: ERROR: ks0108 is not initialized
[    4.565211] cfag12864bfb: ERROR: cfag12864b is not initialized
[    4.566668] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.567822] ehci-pci: EHCI PCI platform driver
[    4.568853] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.569932] uhci_hcd: USB Universal Host Controller Interface driver
[    4.571200] driver u132_hcd
[    4.571891] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    4.572940] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[    4.574512] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    4.575526]=20
[    4.577185] usbcore: registered new interface driver cdc_acm
[    4.578164] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    4.579603] usbcore: registered new interface driver usblp
[    4.580592] usbcore: registered new interface driver cdc_wdm
[    4.581624] usbcore: registered new interface driver usbtmc
[    4.582754] usbcore: registered new interface driver mdc800
[    4.583741] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    4.585251] usbcore: registered new interface driver usbserial
[    4.586314] usbcore: registered new interface driver usbserial_generic
[    4.587501] usbserial: USB Serial support registered for generic
[    4.588623] usbcore: registered new interface driver aircable
[    4.589635] usbserial: USB Serial support registered for aircable
[    4.590722] usbcore: registered new interface driver ark3116
[    4.591828] usbserial: USB Serial support registered for ark3116
[    4.592926] usbcore: registered new interface driver belkin_sa
[    4.593981] usbserial: USB Serial support registered for Belkin / Peraco=
m / GoHubs USB Serial Adapter
[    4.595596] usbcore: registered new interface driver ch341
[    4.596601] usbserial: USB Serial support registered for ch341-uart
[    4.597749] usbcore: registered new interface driver cp210x
[    4.598777] usbserial: USB Serial support registered for cp210x
[    4.599854] usbcore: registered new interface driver cyberjack
[    4.600906] usbserial: USB Serial support registered for Reiner SCT Cybe=
rjack USB card reader
[    4.602480] usbcore: registered new interface driver cypress_m8
[    4.603548] usbserial: USB Serial support registered for DeLorme Earthma=
te USB
[    4.604836] usbserial: USB Serial support registered for HID->COM RS232 =
Adapter
[    4.606134] usbserial: USB Serial support registered for Nokia CA-42 V2 =
Adapter
[    4.607443] usbcore: registered new interface driver usb_debug
[    4.608506] usbserial: USB Serial support registered for debug
[    4.609603] usbcore: registered new interface driver f81232
[    4.610599] usbserial: USB Serial support registered for f81232
[    4.611665] usbcore: registered new interface driver ftdi_sio
[    4.612891] usbserial: USB Serial support registered for FTDI USB Serial=
 Device
[    4.614198] usbcore: registered new interface driver garmin_gps
[    4.615266] usbserial: USB Serial support registered for Garmin GPS usb/=
tty
[    4.616507] usbcore: registered new interface driver kl5kusb105
[    4.617561] usbserial: USB Serial support registered for KL5KUSB105D / P=
almConnect
[    4.618946] usbcore: registered new interface driver metro_usb
[    4.619997] usbserial: USB Serial support registered for Metrologic USB =
to Serial
[    4.621342] usbcore: registered new interface driver mos7720
[    4.622464] usbserial: USB Serial support registered for Moschip 2 port =
adapter
[    4.623759] usbcore: registered new interface driver mos7840
[    4.624786] usbserial: USB Serial support registered for Moschip 7840/78=
20 USB Serial Driver
[    4.626268] usbcore: registered new interface driver navman
[    4.627280] usbserial: USB Serial support registered for navman
[    4.628349] usbcore: registered new interface driver opticon
[    4.629398] usbserial: USB Serial support registered for opticon
[    4.630458] usbcore: registered new interface driver oti6858
[    4.631481] usbserial: USB Serial support registered for oti6858
[    4.632671] usbcore: registered new interface driver qcaux
[    4.633672] usbserial: USB Serial support registered for qcaux
[    4.634716] usbcore: registered new interface driver quatech2
[    4.635758] usbserial: USB Serial support registered for Quatech 2nd gen=
 USB to Serial Driver
[    4.637300] usbcore: registered new interface driver usb_serial_simple
[    4.638487] usbserial: USB Serial support registered for zio
[    4.639540] usbserial: USB Serial support registered for funsoft
[    4.640648] usbserial: USB Serial support registered for flashloader
[    4.641892] usbserial: USB Serial support registered for vivopay
[    4.643001] usbserial: USB Serial support registered for moto_modem
[    4.644157] usbserial: USB Serial support registered for hp4x
[    4.645215] usbserial: USB Serial support registered for suunto
[    4.646299] usbserial: USB Serial support registered for siemens_mpi
[    4.647493] usbcore: registered new interface driver spcp8x5
[    4.648533] usbserial: USB Serial support registered for SPCP8x5
[    4.649678] usbcore: registered new interface driver ssu100
[    4.650709] usbserial: USB Serial support registered for Quatech SSU-100=
 USB to Serial Driver
[    4.652295] usbcore: registered new interface driver symbolserial
[    4.653388] usbserial: USB Serial support registered for symbol
[    4.654449] usbcore: registered new interface driver ti_usb_3410_5052
[    4.655616] usbserial: USB Serial support registered for TI USB 3410 1 p=
ort adapter
[    4.656966] usbserial: USB Serial support registered for TI USB 5052 2 p=
ort adapter
[    4.658334] usbcore: registered new interface driver visor
[    4.659372] usbserial: USB Serial support registered for Handspring Viso=
r / Palm OS
[    4.660735] usbserial: USB Serial support registered for Sony Clie 5.0
[    4.661982] usbserial: USB Serial support registered for Sony Clie 3.5
[    4.663167] usbcore: registered new interface driver wishbone_serial
[    4.664306] usbserial: USB Serial support registered for wishbone_serial
[    4.665494] usbcore: registered new interface driver whiteheat
[    4.666539] usbserial: USB Serial support registered for Connect Tech - =
WhiteHEAT - (prerenumeration)
[    4.668164] usbserial: USB Serial support registered for Connect Tech - =
WhiteHEAT
[    4.669522] usbcore: registered new interface driver xsens_mt
[    4.670567] usbserial: USB Serial support registered for xsens_mt
[    4.671762] usbcore: registered new interface driver zte_ev
[    4.672775] usbserial: USB Serial support registered for zte_ev
[    4.673834] usbcore: registered new interface driver adutux
[    4.674836] usbcore: registered new interface driver cypress_cy7c63
[    4.675976] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    4.677205] driver ftdi-elan
[    4.679915] usbcore: registered new interface driver ftdi-elan
[    4.680985] usbcore: registered new interface driver idmouse
[    4.682106] usbcore: registered new interface driver iowarrior
[    4.683169] usbcore: registered new interface driver isight_firmware
[    4.684306] usbcore: registered new interface driver usblcd
[    4.685301] usbcore: registered new interface driver ldusb
[    4.686298] usbcore: registered new interface driver usbled
[    4.687315] usbcore: registered new interface driver legousbtower
[    4.688417] usbcore: registered new interface driver rio500
[    4.690443] usbcore: registered new interface driver uss720
[    4.691418] uss720: v0.6:USB Parport Cable driver for Cables using the L=
ucent Technologies USS720 Chip
[    4.693085] uss720: NOTE: this is a special purpose driver to allow nons=
tandard
[    4.694348] uss720: protocols (eg. bitbang) over USS720 usb to parallel =
cables
[    4.695593] uss720: If you just want to connect to a printer, use usblp =
instead
[    4.696990] usbcore: registered new interface driver sisusb
[    4.698681] couldn't find an available UDC
[    4.699503] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    4.703313] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.704205] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.705132] parport0: cannot grant exclusive access for device parkbd
[    4.797659] mousedev: PS/2 mouse device common for all mice
[    4.799004] usbcore: registered new interface driver bcm5974
[    4.800083] usbcore: registered new interface driver synaptics_usb
[    4.801658] usbcore: registered new interface driver xpad
[    4.802651] parport0: cannot grant exclusive access for device walkera07=
01
[    4.803848] walkera0701: failed to register parport device
[    4.804850] usbcore: registered new interface driver aiptek
[    4.805856] usbcore: registered new interface driver gtco
[    4.806841] usbcore: registered new interface driver hanwang
[    4.807880] usbcore: registered new interface driver wacom
[    4.810092] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    4.811633] input: PC Speaker as /devices/platform/pcspkr/input/input0
[    4.812793] evbug: Connected device: input0 (PC Speaker at isa0061/input=
0)
[    4.814066] usbcore: registered new interface driver powermate
[    4.815718] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    4.817209] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    4.819148] i2c /dev entries driver
[    4.820156] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[    4.822594] i2c-parport: adapter type unspecified
[    4.824681] pps pps0: new PPS source ktimer
[    4.825425] pps pps0: ktimer PPS source registered
[    4.826291] pps_ldisc: PPS line discipline registered
[    4.827175] pps_parport: parallel port PPS client
[    4.827991] parport0: cannot grant exclusive access for device pps_parpo=
rt
[    4.829221] pps_parport: couldn't register with parport0
[    4.830245] Driver for 1-wire Dallas network protocol.
[    4.831378] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    4.832485] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[    5.016074] applesmc: supported laptop not found!
[    5.016903] applesmc: driver init failed (ret=3D-19)!
[    6.903345] pc87360: PC8736x not detected, module not inserted
[    7.026150] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[    7.027419] usbcore: registered new interface driver bcm203x
[    7.028356] usbcore: registered new interface driver bfusb
[    7.029370] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[    7.030662] CAPI 2.0 started up with major 68 (no middleware)
[    7.031661] b1pci: revision 1.1.2.2
[    7.032229] b1: revision 1.1.2.2
[    7.032761] b1dma: revision 1.1.2.3
[    7.033362] t1pci: revision 1.1.2.2
[    7.033933] gigaset: Driver for Gigaset 307x
[    7.034626] gigaset: Kernel CAPI interface
[    7.035366] lguest: switcher text too large (4384)
[    7.036201] sdhci: Secure Digital Host Controller Interface driver
[    7.037175] sdhci: Copyright(c) Pierre Ossman
[    7.038085] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0400
[    7.049568] usbcore: registered new interface driver vub300
[    7.050572] usbcore: registered new interface driver ushc
[    7.051496] sdhci-pltfm: SDHCI platform and OF driver helper
[    7.053313] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    7.054592] hidraw: raw HID events driver (C) Jiri Kosina
[    7.056341] usbcore: registered new interface driver usbkbd
[    7.160081] panel: driver version 0.9.5 registered on parport0 (io=3D0x3=
78).
[    7.161228] usbcore: registered new interface driver serqt_usb2
[    7.162204] usbserial: USB Serial support registered for Quatech USB to =
Serial Driver
[    7.163429] vme_user: VME User Space Access Driver
[    7.164178] vme_user: No cards, skipping registration
[    7.164902] vme_pio2: No cards, skipping registration
[    7.167251] zram: Created 1 device(s) ...
[    7.167966] Loading crystalhd 0.9.27
[    7.168735] usbcore: registered new interface driver ft1000usb
[    7.169919] ashmem: initialized
[    7.171635] logger: created 256K log 'log_main'
[    7.172551] logger: created 256K log 'log_events'
[    7.173466] logger: created 256K log 'log_radio'
[    7.174387] logger: created 256K log 'log_system'
[    7.175494] ozwpan ozwpan: Ozmo Devices WPAN
[    7.176386] ozwpan ozwpan: new USB bus registered, assigned bus number 1
[    7.177947] hub 1-0:1.0: USB hub found
[    7.178605] hub 1-0:1.0: 8 ports detected
[    7.179937] usbcore: registered new interface driver gdm_wimax
[    7.181298] dgap: dgap-1.3-16, Digi International Part Number 40002347_C
[    7.182382] dgap: For the tools package or updated drivers please visit =
http://www.digi.com
[    7.185727] intel_rapl: driver does not support CPU family 15 model 6
[    7.186760] oprofile: using NMI interrupt.
[    7.187536] pktgen: Packet Generator for packet performance testing. Ver=
sion: 2.74
[    7.189159] NET: Registered protocol family 26
[    7.190151] u32 classifier
[    7.190660] gre: GRE over IPv4 demultiplexor driver
[    7.191434] ip_gre: GRE over IPv4 tunneling driver
[    7.192721] IPv4 over IPSec tunneling driver
[    7.193580] TCP: bic registered
[    7.194100] TCP: cubic registered
[    7.194630] TCP: hybla registered
[    7.195183] TCP: vegas registered
[    7.195689] TCP: veno registered
[    7.196219] TCP: scalable registered
[    7.196787] TCP: lp registered
[    7.197283] TCP: illinois registered
[    7.198133] NET: Registered protocol family 10
[    7.200152] mip6: Mobile IPv6
[    7.200974] sit: IPv6 over IPv4 tunneling driver
[    7.202405] ip6_gre: GRE over IPv6 tunneling driver
[    7.203519] NET: Registered protocol family 15
[    7.204428] NET: Registered protocol family 4
[    7.205160] NET: Registered protocol family 5
[    7.205892] NET: Registered protocol family 9
[    7.206601] X.25 for Linux Version 0.2
[    7.207233] can: controller area network core (rev 20120528 abi 9)
[    7.208301] NET: Registered protocol family 29
[    7.209051] can: broadcast manager protocol (rev 20120528 t)
[    7.209941] can: netlink gateway (rev 20130117) max_hops=3D1
[    7.211632] Bluetooth: RFCOMM TTY layer initialized
[    7.212447] Bluetooth: RFCOMM socket layer initialized
[    7.213314] Bluetooth: RFCOMM ver 1.11
[    7.214031] NET: Registered protocol family 33
[    7.214693] Key type rxrpc registered
[    7.215273] Key type rxrpc_s registered
[    7.216175] cryptomgr_probe (122) used greatest stack depth: 7060 bytes =
left
[    7.217346] RxRPC: Registered security type 2 'rxkad'
[    7.218104] lec:lane_module_init: lec.c: initialized
[    7.218806] mpoa:atm_mpoa_init: mpc.c: initialized
[    7.219469] l2tp_core: L2TP core driver, V2.0
[    7.220222] l2tp_ppp: PPPoL2TP kernel driver, V2.0
[    7.220979] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[    7.228829] DECnet: Routing cache hash table of 256 buckets, 11Kbytes
[    7.230066] NET: Registered protocol family 12
[    7.230800] 8021q: 802.1Q VLAN Support v1.8
[    7.232644] DCCP: Activated CCID 2 (TCP-like)
[    7.233471] DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
[    7.234914] sctp: Hash tables configured (established 1365 bind 1489)
[    7.248732] NET: Registered protocol family 21
[    7.249671] Registered RDS/tcp transport
[    7.250459] tipc: Activated (version 2.0.0)
[    7.251475] NET: Registered protocol family 30
[    7.252562] tipc: Started in single node mode
[    7.253379] 9pnet: Installing 9P2000 support
[    7.254241] NET: Registered protocol family 37
[    7.255113] Key type dns_resolver registered
[    7.255925] Key type ceph registered
[    7.256732] libceph: loaded (mon/osd proto 15/24)
[    7.268805] batman_adv: B.A.T.M.A.N. advanced 2013.5.0 (compatibility ve=
rsion 15) loaded
[    7.270467] NET: Registered protocol family 40
[    7.271285] mpls_gso: MPLS GSO support
[    7.273650]=20
[    7.273650] printing PIC contents
[    7.274510] ... PIC  IMR: ffff
[    7.275080] ... PIC  IRR: 1013
[    7.275645] ... PIC  ISR: 0000
[    7.276212] ... PIC ELCR: 0c00
[    7.276781] printing local APIC contents on CPU#0/0:
[    7.277193] ... APIC ID:      00000000 (0)
[    7.277193] ... APIC VERSION: 00050014
[    7.277193] ... APIC TASKPRI: 00000000 (00)
[    7.277193] ... APIC PROCPRI: 00000000
[    7.277193] ... APIC LDR: 01000000
[    7.277193] ... APIC DFR: ffffffff
[    7.277193] ... APIC SPIV: 000001ff
[    7.277193] ... APIC ISR field:
[    7.277193] 000000000000000000000000000000000000000000000000000000000000=
0000
[    7.277193] ... APIC TMR field:
[    7.277193] 000000000200000000000000000000000000000000000000000000000000=
0000
[    7.277193] ... APIC IRR field:
[    7.277193] 000000000000000000000000000000000000000000000000000000000000=
8000
[    7.277193] ... APIC ESR: 00000000
[    7.277193] ... APIC ICR: 000008fd
[    7.277193] ... APIC ICR2: 02000000
[    7.277193] ... APIC LVTT: 000000ef
[    7.277193] ... APIC LVTPC: 00010000
[    7.277193] ... APIC LVT0: 00010700
[    7.277193] ... APIC LVT1: 00000400
[    7.277193] ... APIC LVTERR: 000000fe
[    7.277193] ... APIC TMICT: 0000c44c
[    7.277193] ... APIC TMCCT: 00000000
[    7.277193] ... APIC TDCR: 00000003
[    7.277193]=20
[    7.295544] number of MP IRQ sources: 15.
[    7.296290] number of IO-APIC #0 registers: 24.
[    7.297105] testing the IO APIC.......................
[    7.298048] IO APIC #0......
[    7.298538] .... register #00: 00000000
[    7.299271] .......    : physical APIC id: 00
[    7.300043] .......    : Delivery Type: 0
[    7.300750] .......    : LTS          : 0
[    7.301462] .... register #01: 00170011
[    7.302156] .......     : max redirection entries: 17
[    7.303060] .......     : PRQ implemented: 0
[    7.303792] .......     : IO APIC version: 11
[    7.304583] .... register #02: 00000000
[    7.305253] .......     : arbitration: 00
[    7.305967] .... IRQ redirection table:
[    7.306675] 1    0    0   0   0    0    0    00
[    7.307496] 0    0    0   0   0    1    1    31
[    7.308329] 0    0    0   0   0    1    1    30
[    7.309181] 0    0    0   0   0    1    1    33
[    7.309997] 1    0    0   0   0    1    1    34
[    7.310822] 1    1    0   0   0    1    1    35
[    7.311660] 0    0    0   0   0    1    1    36
[    7.312487] 0    0    0   0   0    1    1    37
[    7.313306] 0    0    0   0   0    1    1    38
[    7.314137] 0    1    0   0   0    1    1    39
[    7.314935] 1    1    0   0   0    1    1    3A
[    7.315773] 1    1    0   0   0    1    1    3B
[    7.316624] 0    0    0   0   0    1    1    3C
[    7.317435] 0    0    0   0   0    1    1    3D
[    7.318264] 0    0    0   0   0    1    1    3E
[    7.319134] 0    0    0   0   0    1    1    3F
[    7.319935] 1    0    0   0   0    0    0    00
[    7.320775] 1    0    0   0   0    0    0    00
[    7.321601] 1    0    0   0   0    0    0    00
[    7.322417] 1    0    0   0   0    0    0    00
[    7.323257] 1    0    0   0   0    0    0    00
[    7.324073] 1    0    0   0   0    0    0    00
[    7.324881] 1    0    0   0   0    0    0    00
[    7.325712] 1    0    0   0   0    0    0    00
[    7.326514] IRQ to pin mappings:
[    7.327106] IRQ0 -> 0:2
[    7.327608] IRQ1 -> 0:1
[    7.328098] IRQ3 -> 0:3
[    7.328632] IRQ4 -> 0:4
[    7.329133] IRQ5 -> 0:5
[    7.329618] IRQ6 -> 0:6
[    7.330136] IRQ7 -> 0:7
[    7.330623] IRQ8 -> 0:8
[    7.331123] IRQ9 -> 0:9
[    7.331622] IRQ10 -> 0:10
[    7.332139] IRQ11 -> 0:11
[    7.332670] IRQ12 -> 0:12
[    7.333201] IRQ13 -> 0:13
[    7.333716] IRQ14 -> 0:14
[    7.334269] IRQ15 -> 0:15
[    7.334772] .................................... done.
[    7.335695] Using IPI No-Shortcut mode
[    7.336741] registered taskstats version 1
[    7.337479] kAFS: Red Hat AFS client v0.1 registering.
[    7.338489] FS-Cache: Netfs 'afs' registered for caching
[    7.340388] cryptomgr_probe (129) used greatest stack depth: 7004 bytes =
left
[    7.340400] Key type encrypted registered
[    7.340588] IMA: No TPM chip found, activating TPM-bypass!
[    7.343139] Unregister pv shared memory for cpu 0
[    7.350640] CPU 0 is now offline
[    7.353387] Freeing unused kernel memory: 1948K (7a4e1000 - 7a6c8000)
[    7.364116] random: init urandom read with 14 bits of entropy available
mountall: ply-event-loop.c:497: ply_event_loop_new: Assertion `loop->epoll_=
fd >=3D 0' failed.
[    7.405533] mountall (142) used greatest stack depth: 6956 bytes left
General error mounting filesystems.
A maintenance shell will now be started.
CONTROL-D will terminate this shell and reboot the system.
wfg: rebooting
[    7.430765] Unregister pv shared memory for cpu 1
[    7.431561] no ifx modem active;
[    7.458724] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[    7.469092] trinity (152) used greatest stack depth: 6812 bytes left
[    7.473657] reboot: Restarting system
[    7.474224] reboot: machine restart
Elapsed time: 15
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-j=
7-11082318/bad570d77024cba808126d68a2072f6f8ce64c27/vmlinuz-3.12.0-next-201=
31108-10601-gbad570d -append 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_tim=
eout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug =
dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/ke=
rnel-tests/run-queue/kvm/i386-randconfig-j7-11082318/next:master/.vmlinuz-b=
ad570d77024cba808126d68a2072f6f8ce64c27-20131109021750-6-roam branch=3Dnext=
/master BOOT_IMAGE=3D/kernel/i386-randconfig-j7-11082318/bad570d77024cba808=
126d68a2072f6f8ce64c27/vmlinuz-3.12.0-next-20131108-10601-gbad570d'  -initr=
d /kernel-tests/initrd/quantal-core-i386.cgz -m 256M -smp 2 -net nic,vlan=
=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog=
 i6300esb -drive file=3D/fs/LABEL=3DKVM/disk0-quantal-roam-7,media=3Ddisk,i=
f=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1-quantal-roam-7,media=3Ddisk,=
if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk2-quantal-roam-7,media=3Ddisk=
,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-quantal-roam-7,media=3Ddis=
k,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk4-quantal-roam-7,media=3Ddi=
sk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk5-quantal-roam-7,media=3Dd=
isk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-quantal-roam-7 -serial file:/de=
v/shm/kboot/serial-quantal-roam-7 -daemonize -display none -monitor null=20

--HlL+5n6rz5pIUxbD
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-bad570d77024cba808126d68a2072f6f8ce64c27-i386-randconfig-j7-11082318-INFO:-trying-to-register-non-static-key--23799.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IGUxZTk1ODAyOTc4MWE1ZjIyYTQ3ODA3Zjk2NDhhYjlkMjIxNzQ2ZjQK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgYmFkNTcwZC4uLiBBZGQgbGludXgtbmV4dCBz
cGVjaWZpYyBmaWxlcyBmb3IgMjAxMzExMDgKSEVBRCBpcyBub3cgYXQgZTFlOTU4MC4uLiBN
ZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdhaW8vbWFzdGVyJwpscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWo3LTExMDgyMzE4L25leHQ6
bWFzdGVyOmUxZTk1ODAyOTc4MWE1ZjIyYTQ3ODA3Zjk2NDhhYjlkMjIxNzQ2ZjQ6YmlzZWN0
LW1tCgoyMDEzLTExLTEwLTE4OjMzOjU1IGUxZTk1ODAyOTc4MWE1ZjIyYTQ3ODA3Zjk2NDhh
YjlkMjIxNzQ2ZjQgY29tcGlsaW5nCjU5MyByZWFsICAyNTIwIHVzZXIgIDIxOSBzeXMgIDQ2
MS42OSUgY3B1IAlpMzg2LXJhbmRjb25maWctajctMTEwODIzMTgKCjIwMTMtMTEtMTAtMTg6
NDc6NDYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLTEwMTczLWdlMWU5NTgwLiBURVNU
IEZBSUxVUkUKWyAgICAyLjIxNjAzNV0gc2QgMDowOjA6MDogW3NkYV0gV3JpdGUgY2FjaGU6
IGVuYWJsZWQsIHJlYWQgY2FjaGU6IGVuYWJsZWQsIHN1cHBvcnRzIERQTyBhbmQgRlVBClsg
ICAgMi4yMTY5NTZdIHBtYzU1MTogbm90IGRldGVjdGVkClsgICAgMi4yMTg3MjFdIFNwZWN0
cmEgTVREIGRyaXZlciBidWlsdCBvbiBOb3YgMTAgMjAxMyBAIDE4OjQwOjM2ClsgICAgMi4y
MjExMTldIElORk86IHRyeWluZyB0byByZWdpc3RlciBub24tc3RhdGljIGtleS4KWyAgICAy
LjIyMTU1Ml0gdGhlIGNvZGUgaXMgZmluZSBidXQgbmVlZHMgbG9ja2RlcCBhbm5vdGF0aW9u
LgpbICAgIDIuMjIyMDA5XSB0dXJuaW5nIG9mZiB0aGUgbG9ja2luZyBjb3JyZWN0bmVzcyB2
YWxpZGF0b3IuClsgICAgMi4yMjIwMTNdIENQVTogMCBQSUQ6IDk2IENvbW06IGt3b3JrZXIv
dTQ6MSBOb3QgdGFpbnRlZCAzLjEyLjAtMTAxNzMtZ2UxZTk1ODAgIzQ5OApbICAgIDIuMjIy
MDEzXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDEx
ClsgICAgMi4yMjIwMTNdIFdvcmtxdWV1ZTogZXZlbnRzX3VuYm91bmQgYXN5bmNfcnVuX2Vu
dHJ5X2ZuClsgICAgMi4yMjIwMTNdICA3OTA4ZTk4ZiAwMDAwMDAwMCA3ODAyMzk2OCA3OWRj
M2M4NiA3YTdmZmE0NCA3ODAyMzlhMCA3OTA4OTc4MyA3YTFiMmZhYwpbICAgIDIuMjIyMDEz
XSAgN2ExYjMwMDYgN2ExYjJmZGMgN2YzYTBhNzggMDAwMDAwMDAgMDAwMDAwMTEgNDgzNWMw
MTEgMDAwMGE4ODUgN2YzYTA1OTAKWyAgICAyLjIyMjAxM10gIDdmM2EwNTkwIDg1YmYzNTQw
IDAwMDAwMDAwIDc4MDIzOWNjIDc5MDhhNDBhIDAwMDAwMDAwIDAwMDAwMDAxIDAwMDAwMDAw
ClsgICAgMi4yMjIwMTNdIENhbGwgVHJhY2U6ClsgICAgMi4yMjIwMTNdICBbPDc5MDhlOThm
Pl0gPyBjb25zb2xlX3VubG9jaysweDM1My8weDM4MApbICAgIDIuMjIyMDEzXSAgWzw3OWRj
M2M4Nj5dIGR1bXBfc3RhY2srMHg0OC8weDYwClsgICAgMi4yMjIwMTNdICBbPDc5MDg5Nzgz
Pl0gX19sb2NrX2FjcXVpcmUuaXNyYS4yNisweDdlYS8weGNmMgpbICAgIDIuMjIyMDEzXSAg
Wzw3OTA4YTQwYT5dIGxvY2tfYWNxdWlyZSsweDcxLzB4OWEKWyAgICAyLjIyMjAxM10gIFs8
Nzk0MDNlYzU+XSA/IGJsa190aHJvdGxfYmlvKzB4MWMzLzB4NDg1ClsgICAgMi4yMjIwMTNd
ICBbPDc5NDAyYWE2Pl0gdGhyb3RsX3VwZGF0ZV9kaXNwYXRjaF9zdGF0cysweDdjLzB4MTUz
ClsgICAgMi4yMjIwMTNdICBbPDc5NDAzZWM1Pl0gPyBibGtfdGhyb3RsX2JpbysweDFjMy8w
eDQ4NQpbICAgIDIuMjIyMDEzXSAgWzw3OTQwM2VjNT5dIGJsa190aHJvdGxfYmlvKzB4MWMz
LzB4NDg1ClsgICAgMi4yMjIwMTNdICBbPDc5MDdjOWZjPl0gPyBzY2hlZF9jbG9ja19sb2Nh
bCsweDE3LzB4MTA2ClsgICAgMi4yMjIwMTNdICBbPDc5MDdjYzhlPl0gPyBzY2hlZF9jbG9j
a19jcHUrMHgxMDUvMHgxMTMKWyAgICAyLjIyMjAxM10gIFs8NzkzZWY0NmU+XSBnZW5lcmlj
X21ha2VfcmVxdWVzdF9jaGVja3MrMHgzY2EvMHgzZTEKWyAgICAyLjIyMjAxM10gIFs8Nzkw
N2NjOGU+XSA/IHNjaGVkX2Nsb2NrX2NwdSsweDEwNS8weDExMwpbICAgIDIuMjIyMDEzXSAg
Wzw3OTNmMGE5Mz5dIGdlbmVyaWNfbWFrZV9yZXF1ZXN0KzB4Zi8weGIwClsgICAgMi4yMjIw
MTNdICBbPDc5M2YwYmEzPl0gc3VibWl0X2JpbysweDZmLzB4ZDgKWyAgICAyLjIyMjAxM10g
IFs8NzkxMTYxODg+XSBfc3VibWl0X2JoKzB4MjI4LzB4MjQ1ClsgICAgMi4yMjIwMTNdICBb
PDc5MTE2MWFmPl0gc3VibWl0X2JoKzB4YS8weGMKWyAgICAyLjIyMjAxM10gIFs8NzkxMTcx
ODQ+XSBibG9ja19yZWFkX2Z1bGxfcGFnZSsweDJhYS8weDJjNQpbICAgIDIuMjIyMDEzXSAg
Wzw3OTExYTA0Zj5dID8gYmlvX2RpcnR5X2ZuKzB4NmYvMHg2ZgpbICAgIDIuMjIyMDEzXSAg
Wzw3OTBiZjEzNz5dID8gYWRkX3RvX3BhZ2VfY2FjaGVfbG9ja2VkKzB4YjQvMHhlMgpbICAg
IDIuMjIyMDEzXSAgWzw3OTExYTJlNT5dID8gYmxrZGV2X3dyaXRlX2JlZ2luKzB4MjAvMHgy
MApbICAgIDIuMjIyMDEzXSAgWzw3OTExYTJlNT5dID8gYmxrZGV2X3dyaXRlX2JlZ2luKzB4
MjAvMHgyMApbICAgIDIuMjIyMDEzXSAgWzw3OTExYTJmND5dIGJsa2Rldl9yZWFkcGFnZSsw
eGYvMHgxMQpbICAgIDIuMjIyMDEzXSAgWzw3OTBiZmNhMj5dIGRvX3JlYWRfY2FjaGVfcGFn
ZSsweDZlLzB4MTFiClsgICAgMi4yMjIwMTNdICBbPDc5MGMwOWIwPl0gcmVhZF9jYWNoZV9w
YWdlX2FzeW5jKzB4MTkvMHgxZQpbICAgIDIuMjIyMDEzXSAgWzw3OTExYTJlNT5dID8gYmxr
ZGV2X3dyaXRlX2JlZ2luKzB4MjAvMHgyMApbICAgIDIuMjIyMDEzXSAgWzw3OTBjMDllMT5d
IHJlYWRfY2FjaGVfcGFnZSsweGIvMHgxMgpbICAgIDIuMjIyMDEzXSAgWzw3OTNmZGMyNj5d
IHJlYWRfZGV2X3NlY3RvcisweDI2LzB4NjEKWyAgICAyLjIyMjAxM10gIFs8NzkzZmU2NzQ+
XSByZWFkX2xiYSsweGFlLzB4ZjkKWyAgICAyLjIyMjAxM10gIFs8NzkwZTVkY2Q+XSA/IGtt
ZW1fY2FjaGVfYWxsb2MrMHhmOS8weDEyYgpbICAgIDIuMjIyMDEzXSAgWzw3OTNmZWJhND5d
IGVmaV9wYXJ0aXRpb24rMHgxN2EvMHg5YzIKWyAgICAyLjIyMjAxM10gIFs8NzkwYzRmN2E+
XSA/IF9fYWxsb2NfcGFnZXNfbm9kZW1hc2srMHhlMy8weDYxZQpbICAgIDIuMjIyMDEzXSAg
Wzw3OTQxMWU2Mj5dID8gc3RyaW5nLmlzcmEuNCsweDI5LzB4OTMKWyAgICAyLjIyMjAxM10g
IFs8Nzk0MTFlNjI+XSA/IHN0cmluZy5pc3JhLjQrMHgyOS8weDkzClsgICAgMi4yMjIwMTNd
ICBbPDc5NDEyYzA3Pl0gPyB2c25wcmludGYrMHg4MS8weDI2ZgpbICAgIDIuMjIyMDEzXSAg
Wzw3OTQxMzA5ND5dID8gc25wcmludGYrMHgxNS8weDE3ClsgICAgMi4yMjIwMTNdICBbPDc5
M2ZkZDVkPl0gY2hlY2tfcGFydGl0aW9uKzB4ZTQvMHgxNzgKWyAgICAyLjIyMjAxM10gIFs8
NzkzZmRkNWQ+XSA/IGNoZWNrX3BhcnRpdGlvbisweGU0LzB4MTc4ClsgICAgMi4yMjIwMTNd
ICBbPDc5M2ZkOWFmPl0gcmVzY2FuX3BhcnRpdGlvbnMrMHg4OS8weDI2NwpbICAgIDIuMjIy
MDEzXSAgWzw3OTExYTNkOT5dID8gYmRldl9pbm9kZV9zd2l0Y2hfYmRpKzB4ZDIvMHhlNgpb
ICAgIDIuMjIyMDEzXSAgWzw3OTExYjE5MD5dIF9fYmxrZGV2X2dldCsweDE3My8weDM2Mwpb
ICAgIDIuMjIyMDEzXSAgWzw3OTExYjNjYj5dIGJsa2Rldl9nZXQrMHg0Yi8weDIzZApbICAg
IDIuMjIyMDEzXSAgWzw3OTExYWE4OT5dID8gYmRnZXQrMHhmOC8weDEwNQpbICAgIDIuMjIy
MDEzXSAgWzw3OTZiODI0MD5dID8gcHV0X2RldmljZSsweGYvMHgxMQpbICAgIDIuMjIyMDEz
XSAgWzw3OTNmYjllMD5dIGFkZF9kaXNrKzB4MjZiLzB4M2I1ClsgICAgMi4yMjIwMTNdICBb
PDc5NmMwMTE0Pl0gPyBfX3BtX3J1bnRpbWVfdXNlX2F1dG9zdXNwZW5kKzB4NGEvMHg0Zgpb
ICAgIDIuMjIyMDEzXSAgWzw3OTdlMGI4ZT5dIHNkX3Byb2JlX2FzeW5jKzB4MTExLzB4MTk4
ClsgICAgMi4yMjIwMTNdICBbPDc5MDc1ZDA0Pl0gYXN5bmNfcnVuX2VudHJ5X2ZuKzB4NTkv
MHhmZgpbICAgIDIuMjIyMDEzXSAgWzw3OTA2Y2RkND5dIHByb2Nlc3Nfb25lX3dvcmsrMHgx
ZWYvMHgzNDkKWyAgICAyLjIyMjAxM10gIFs8NzkwNmNkN2I+XSA/IHByb2Nlc3Nfb25lX3dv
cmsrMHgxOTYvMHgzNDkKWyAgICAyLjIyMjAxM10gIFs8NzkwNmQzMjU+XSB3b3JrZXJfdGhy
ZWFkKzB4MWEzLzB4Mjc0ClsgICAgMi4yMjIwMTNdICBbPDc5MDZkMTgyPl0gPyByZXNjdWVy
X3RocmVhZCsweDIzMy8weDIzMwpbICAgIDIuMjIyMDEzXSAgWzw3OTA3MTljYz5dIGt0aHJl
YWQrMHg4YS8weDhmClsgICAgMi4yMjIwMTNdICBbPDc5MDcwMDAwPl0gPyBwYXJhbV9hcnJh
eV9nZXQrMHgzYy8weDdhClsgICAgMi4yMjIwMTNdICBbPDc5ZGQ3NjNiPl0gcmV0X2Zyb21f
a2VybmVsX3RocmVhZCsweDFiLzB4MzAKWyAgICAyLjIyMjAxM10gIFs8NzkwNzE5NDI+XSA/
IF9fa3RocmVhZF9wYXJrbWUrMHg1MC8weDUwClsgICAgMi4yNTEwNDNdICBzZGE6IHVua25v
d24gcGFydGl0aW9uIHRhYmxlClsgICAgMi4yNTUwNzNdIHNkIDA6MDowOjA6IFtzZGFdIEF0
dGFjaGVkIFNDU0kgZGlzawpbICAgIDIuMjU3MzM0XSBObyB2YWxpZCBEaXNrT25DaGlwIGRl
dmljZXMgZm91bmQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajctMTEwODIzMTgvZTFlOTU4
MDI5NzgxYTVmMjJhNDc4MDdmOTY0OGFiOWQyMjE3NDZmNC9kbWVzZy1xdWFudGFsLWlubi00
NDoyMDEzMTExMDE4NDc1NzppMzg2LXJhbmRjb25maWctajctMTEwODIzMTg6My4xMi4wLTEw
MTczLWdlMWU5NTgwOjQ5OAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxOC9l
MWU5NTgwMjk3ODFhNWYyMmE0NzgwN2Y5NjQ4YWI5ZDIyMTc0NmY0L2RtZXNnLXF1YW50YWwt
aW5uLTQ2OjIwMTMxMTEwMTg0ODAyOmkzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxODozLjEy
LjAtMTAxNzMtZ2UxZTk1ODA6NDk4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo3LTExMDgy
MzE4L2UxZTk1ODAyOTc4MWE1ZjIyYTQ3ODA3Zjk2NDhhYjlkMjIxNzQ2ZjQvZG1lc2ctcXVh
bnRhbC1sa3AtdHQwMi0xODoyMDEzMTExMDA5MzkyNDppMzg2LXJhbmRjb25maWctajctMTEw
ODIzMTg6My4xMi4wLTEwMTczLWdlMWU5NTgwOjQ5OAova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1qNy0xMTA4MjMxOC9lMWU5NTgwMjk3ODFhNWYyMmE0NzgwN2Y5NjQ4YWI5ZDIyMTc0NmY0
L2RtZXNnLXF1YW50YWwtcm9hbS04OjIwMTMxMTEwMTg0ODA2OmkzODYtcmFuZGNvbmZpZy1q
Ny0xMTA4MjMxODozLjEyLjAtMTAxNzMtZ2UxZTk1ODA6NDk4Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWo3LTExMDgyMzE4L2UxZTk1ODAyOTc4MWE1ZjIyYTQ3ODA3Zjk2NDhhYjlkMjIx
NzQ2ZjQvZG1lc2ctcXVhbnRhbC1zbmItNDU6MjAxMzExMTAxODQ4MDE6aTM4Ni1yYW5kY29u
ZmlnLWo3LTExMDgyMzE4OjMuMTIuMC0xMDE3My1nZTFlOTU4MDo0OTgKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctajctMTEwODIzMTgvZTFlOTU4MDI5NzgxYTVmMjJhNDc4MDdmOTY0OGFi
OWQyMjE3NDZmNC9kbWVzZy1xdWFudGFsLXNuYi00OjIwMTMxMTEwMTg0ODAxOmkzODYtcmFu
ZGNvbmZpZy1qNy0xMTA4MjMxODozLjEyLjAtMTAxNzMtZ2UxZTk1ODA6NDk4Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWo3LTExMDgyMzE4L2UxZTk1ODAyOTc4MWE1ZjIyYTQ3ODA3Zjk2
NDhhYjlkMjIxNzQ2ZjQvZG1lc2ctcXVhbnRhbC1zdG9ha2xleS0yOjIwMTMxMTEwMTg0ODAx
OmkzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxODozLjEyLjAtMTAxNzMtZ2UxZTk1ODA6NDk4
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo3LTExMDgyMzE4L2UxZTk1ODAyOTc4MWE1ZjIy
YTQ3ODA3Zjk2NDhhYjlkMjIxNzQ2ZjQvZG1lc2ctcXVhbnRhbC1sa3AtdHQwMi0yNDoyMDEz
MTExMDA5MzkyOTppMzg2LXJhbmRjb25maWctajctMTEwODIzMTg6My4xMi4wLTEwMTczLWdl
MWU5NTgwOjQ5OAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxOC9lMWU5NTgw
Mjk3ODFhNWYyMmE0NzgwN2Y5NjQ4YWI5ZDIyMTc0NmY0L2RtZXNnLXF1YW50YWwtc25iLTEz
OjIwMTMxMTEwMTg0ODA3OmkzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxODozLjEyLjAtMTAx
NzMtZ2UxZTk1ODA6NDk4CjA6OTo5IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTsz
NW1SRVBFQVQgQ09VTlQ6IDIwICAjIC9jYy93ZmcvbW0tYmlzZWN0Ly5yZXBlYXQbWzBtCgpi
aXNlY3Q6IGJhZCBjb21taXQgZTFlOTU4MDI5NzgxYTVmMjJhNDc4MDdmOTY0OGFiOWQyMjE3
NDZmNApnaXQgY2hlY2tvdXQgdjMuMTIKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgZTFl
OTU4MC4uLiBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdhaW8vbWFzdGVyJwpIRUFE
IGlzIG5vdyBhdCA1ZTAxZGM3Li4uIExpbnV4IDMuMTIKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxOC9uZXh0Om1hc3Rlcjo1
ZTAxZGM3YjI2ZDlmMjRmMzlhYmFjZTVkYTk4Y2NiZDZhNWNlYjUyOmJpc2VjdC1tbQogU1VD
Q0VTUwoKYmlzZWN0OiBnb29kIGNvbW1pdCB2My4xMgpnaXQgYmlzZWN0IHN0YXJ0IGUxZTk1
ODAyOTc4MWE1ZjIyYTQ3ODA3Zjk2NDhhYjlkMjIxNzQ2ZjQgdjMuMTIgLS0KUHJldmlvdXMg
SEVBRCBwb3NpdGlvbiB3YXMgNWUwMWRjNy4uLiBMaW51eCAzLjEyCkhFQUQgaXMgbm93IGF0
IDNjMGVlZTMuLi4gTGludXggMi42LjM3CkJpc2VjdGluZzogNTAyMCByZXZpc2lvbnMgbGVm
dCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTIgc3RlcHMpCls1MTNlNzJiM2FlMGU3
ZDM1YjA5YjcyYzM2MGU1NDg3ODFiMzQ1ZmU3XSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJh
bmNoICdwbS9saW51eC1uZXh0JwpnaXQgYmlzZWN0IHJ1biAvYy9rZXJuZWwtdGVzdHMvYmlz
ZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9tbS9vYmotYmlzZWN0CnJ1bm5p
bmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93
ZmcvbW0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4
Ni1yYW5kY29uZmlnLWo3LTExMDgyMzE4L25leHQ6bWFzdGVyOjUxM2U3MmIzYWUwZTdkMzVi
MDliNzJjMzYwZTU0ODc4MWIzNDVmZTc6YmlzZWN0LW1tCgoyMDEzLTExLTEwLTE4OjQ5OjE1
IDUxM2U3MmIzYWUwZTdkMzViMDliNzJjMzYwZTU0ODc4MWIzNDVmZTcgY29tcGlsaW5nCjcy
NSByZWFsICAyNTIyIHVzZXIgIDIxMyBzeXMgIDM3Ny4yMCUgY3B1IAlpMzg2LXJhbmRjb25m
aWctajctMTEwODIzMTgKCjIwMTMtMTEtMTAtMTk6MDc6NDcgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgMy4xMi4wLTA1MTUyLWc1MTNlNzJiCTUJOAkxNAkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6
IDI1MjcgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDExIHN0
ZXBzKQpbYTczZjM5ZDZiYjEzY2QwZWFkZjU2NmUyMDJkYmZkMTE0ZGUyYjliY10gTWVyZ2Ug
cmVtb3RlLXRyYWNraW5nIGJyYW5jaCAndmlydGlvL3ZpcnRpby1uZXh0JwpydW5uaW5nIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21t
L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFu
ZGNvbmZpZy1qNy0xMTA4MjMxOC9uZXh0Om1hc3RlcjphNzNmMzlkNmJiMTNjZDBlYWRmNTY2
ZTIwMmRiZmQxMTRkZTJiOWJjOmJpc2VjdC1tbQoKMjAxMy0xMS0xMC0xOTowOTo1MiBhNzNm
MzlkNmJiMTNjZDBlYWRmNTY2ZTIwMmRiZmQxMTRkZTJiOWJjIGNvbXBpbGluZwo1MzUgcmVh
bCAgMjUyMyB1c2VyICAyMjEgc3lzICA1MTIuNTElIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWo3
LTExMDgyMzE4CgoyMDEzLTExLTEwLTE5OjIxOjAwIGRldGVjdGluZyBib290IHN0YXRlIDMu
MTIuMC0wNzY0NS1nYTczZjM5ZAkxCTEwCTEyCTE4CTIwIFNVQ0NFU1MKCkJpc2VjdGluZzog
MTI3OSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTAgc3Rl
cHMpCls4ZDMxZTg1MzY1NDA2MzVhMWQ1NmM5Y2Q0YTMwZWVmZTdmMjM2NjQ0XSBNZXJnZSBy
ZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdzcGkvZm9yLW5leHQnCnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJp
c2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmln
LWo3LTExMDgyMzE4L25leHQ6bWFzdGVyOjhkMzFlODUzNjU0MDYzNWExZDU2YzljZDRhMzBl
ZWZlN2YyMzY2NDQ6YmlzZWN0LW1tCgoyMDEzLTExLTEwLTE5OjIzOjM0IDhkMzFlODUzNjU0
MDYzNWExZDU2YzljZDRhMzBlZWZlN2YyMzY2NDQgY29tcGlsaW5nCjgxNyByZWFsICAyNTI2
IHVzZXIgIDIxNiBzeXMgIDMzNS41MiUgY3B1IAlpMzg2LXJhbmRjb25maWctajctMTEwODIz
MTgKCjIwMTMtMTEtMTAtMTk6Mzg6MTIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLTA4
ODkzLWc4ZDMxZTg1CTQJMTIJMTMJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA2NDUgcmV2aXNp
b25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDkgc3RlcHMpCls0N2I4ZDlj
OGMzOGE5NTYwOTRlN2Y2YjIzMTM3MTMzMWRkMmRkMGQ5XSBNZXJnZSBicmFuY2ggJ3g4Ni9o
eXBlcnYnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVy
ZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1x
dWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWo3LTExMDgyMzE4L25leHQ6bWFzdGVyOjQ3Yjhk
OWM4YzM4YTk1NjA5NGU3ZjZiMjMxMzcxMzMxZGQyZGQwZDk6YmlzZWN0LW1tCgoyMDEzLTEx
LTEwLTE5OjQwOjE5IDQ3YjhkOWM4YzM4YTk1NjA5NGU3ZjZiMjMxMzcxMzMxZGQyZGQwZDkg
Y29tcGlsaW5nCjc4NiByZWFsICAyNTA4IHVzZXIgIDIxMiBzeXMgIDM0NS44MSUgY3B1IAlp
Mzg2LXJhbmRjb25maWctajctMTEwODIzMTgKCjIwMTMtMTEtMTAtMTk6NTU6MzIgZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLTAwNjM0LWc0N2I4ZDljLiBURVNUIEZBSUxVUkUKWyAg
ICAyLjYxMDQ2MV0gbGlicGh5OiBGaXhlZCBNRElPIEJ1czogcHJvYmVkClsgICAgMi42MTE0
MjVdIHBjbmV0MzI6IHBjbmV0MzIuYzp2MS4zNSAyMS5BcHIuMjAwOCB0c2JvZ2VuZEBhbHBo
YS5mcmFua2VuLmRlClsgICAgMi42MTIwMzFdIGNuaWM6IEJyb2FkY29tIE5ldFh0cmVtZSBJ
SSBDTklDIERyaXZlciBjbmljIHYyLjUuMTggKFNlcHQgMDEsIDIwMTMpClsgICAgMi42MTIx
ODhdIElORk86IHRyeWluZyB0byByZWdpc3RlciBub24tc3RhdGljIGtleS4KWyAgICAyLjYx
MjE4OV0gdGhlIGNvZGUgaXMgZmluZSBidXQgbmVlZHMgbG9ja2RlcCBhbm5vdGF0aW9uLgpb
ICAgIDIuNjEyMTkwXSB0dXJuaW5nIG9mZiB0aGUgbG9ja2luZyBjb3JyZWN0bmVzcyB2YWxp
ZGF0b3IuClsgICAgMi42MTIxOTRdIENQVTogMCBQSUQ6IDk2IENvbW06IGt3b3JrZXIvdTQ6
MSBOb3QgdGFpbnRlZCAzLjEyLjAtMDA2MzQtZzQ3YjhkOWMgIzUwMgpbICAgIDIuNjEyMTk1
XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsg
ICAgMi42MTIyMDNdIFdvcmtxdWV1ZTogZXZlbnRzX3VuYm91bmQgYXN5bmNfcnVuX2VudHJ5
X2ZuClsgICAgMi42MTIyMDhdICA3ODI4ZTI4ZSAwMDAwMDAwMCA3ZjNjZDk2OCA3OGZhNzUy
MyA3OTljZmEzYyA3ZjNjZDlhMCA3ODI4OGJiOCA3OTM4YTBhOQpbICAgIDIuNjEyMjEzXSAg
NzkzOGExMDMgNzkzOGEwZDkgN2YzYTQ4OTggMDAwMDAwMDAgMDAwMDAwMTEgNDQzNjIwMTEg
MDAwMGE4MDUgN2YzYTQzYjAKWyAgICAyLjYxMjIxN10gIDdmM2E0M2IwIDg1YmYzNTQwIDAw
MDAwMDAwIDdmM2NkOWNjIDc4Mjg5ODNmIDAwMDAwMDAwIDAwMDAwMDAxIDAwMDAwMDAwClsg
ICAgMi42MTIyMTddIENhbGwgVHJhY2U6ClsgICAgMi42MTIyMjRdICBbPDc4MjhlMjhlPl0g
PyB2cHJpbnRrX2VtaXQrMHg0MjYvMHg0YTAKWyAgICAyLjYxMjIzMF0gIFs8NzhmYTc1MjM+
XSBkdW1wX3N0YWNrKzB4NDgvMHg2MApbICAgIDIuNjEyMjMyXSAgWzw3ODI4OGJiOD5dIF9f
bG9ja19hY3F1aXJlLmlzcmEuMjYrMHg3ZWEvMHhjZjIKWyAgICAyLjYxMjIzNV0gIFs8Nzgy
ODk4M2Y+XSBsb2NrX2FjcXVpcmUrMHg3MS8weDlhClsgICAgMi42MTIyMzldICBbPDc4NWZk
Y2E2Pl0gPyBibGtfdGhyb3RsX2JpbysweDFjMy8weDQ4NQpbICAgIDIuNjEyMjQxXSAgWzw3
ODVmYzg4Nz5dIHRocm90bF91cGRhdGVfZGlzcGF0Y2hfc3RhdHMrMHg3Yy8weDE1MwpbICAg
IDIuNjEyMjQ0XSAgWzw3ODVmZGNhNj5dID8gYmxrX3Rocm90bF9iaW8rMHgxYzMvMHg0ODUK
WyAgICAyLjYxMjI0Nl0gIFs8Nzg1ZmRjYTY+XSBibGtfdGhyb3RsX2JpbysweDFjMy8weDQ4
NQpbICAgIDIuNjEyMjQ5XSAgWzw3ODI3YmUzMT5dID8gc2NoZWRfY2xvY2tfbG9jYWwrMHgx
Ny8weDEwNgpbICAgIDIuNjEyMjUxXSAgWzw3ODI3YzBjMz5dID8gc2NoZWRfY2xvY2tfY3B1
KzB4MTA1LzB4MTEzClsgICAgMi42MTIyNTVdICBbPDc4NWVjMWIyPl0gZ2VuZXJpY19tYWtl
X3JlcXVlc3RfY2hlY2tzKzB4M2JiLzB4M2QyClsgICAgMi42MTIyNThdICBbPDc4MjdjMGMz
Pl0gPyBzY2hlZF9jbG9ja19jcHUrMHgxMDUvMHgxMTMKWyAgICAyLjYxMjI2MF0gIFs8Nzg1
ZWQ5NDc+XSBnZW5lcmljX21ha2VfcmVxdWVzdCsweGYvMHhiNQpbICAgIDIuNjEyMjYyXSAg
Wzw3ODVlZGE1Mj5dIHN1Ym1pdF9iaW8rMHg2NS8weGQyClsgICAgMi42MTIyNjddICBbPDc4
MzE0Y2E1Pl0gX3N1Ym1pdF9iaCsweDIyNi8weDI0MwpbICAgIDIuNjEyMjY5XSAgWzw3ODMx
NGNjYz5dIHN1Ym1pdF9iaCsweGEvMHhjClsgICAgMi42MTIyNzFdICBbPDc4MzE1Y2ExPl0g
YmxvY2tfcmVhZF9mdWxsX3BhZ2UrMHgyYWEvMHgyYzUKWyAgICAyLjYxMjI3M10gIFs8Nzgz
MTg5NTk+XSA/IGJpb19kaXJ0eV9mbisweDY4LzB4NjgKWyAgICAyLjYxMjI3OV0gIFs8Nzgy
YmU0YTE+XSA/IGFkZF90b19wYWdlX2NhY2hlX2xvY2tlZCsweGI0LzB4ZTIKWyAgICAyLjYx
MjI4MV0gIFs8NzgzMThiZWY+XSA/IGJsa2Rldl93cml0ZV9iZWdpbisweDIwLzB4MjAKWyAg
ICAyLjYxMjI4NF0gIFs8NzgzMThiZWY+XSA/IGJsa2Rldl93cml0ZV9iZWdpbisweDIwLzB4
MjAKWyAgICAyLjYxMjI4Nl0gIFs8NzgzMThiZmU+XSBibGtkZXZfcmVhZHBhZ2UrMHhmLzB4
MTEKWyAgICAyLjYxMjI4OV0gIFs8NzgyYmYwMGM+XSBkb19yZWFkX2NhY2hlX3BhZ2UrMHg2
ZS8weDExYgpbICAgIDIuNjEyMjkyXSAgWzw3ODJiZmQxYT5dIHJlYWRfY2FjaGVfcGFnZV9h
c3luYysweDE5LzB4MWUKWyAgICAyLjYxMjI5NF0gIFs8NzgzMThiZWY+XSA/IGJsa2Rldl93
cml0ZV9iZWdpbisweDIwLzB4MjAKWyAgICAyLjYxMjI5N10gIFs8NzgyYmZkNGI+XSByZWFk
X2NhY2hlX3BhZ2UrMHhiLzB4MTIKWyAgICAyLjYxMjI5OV0gIFs8Nzg1Zjc5ZmQ+XSByZWFk
X2Rldl9zZWN0b3IrMHgyNi8weDYxClsgICAgMi42MTIzMDFdICBbPDc4NWY4NDRiPl0gcmVh
ZF9sYmErMHhhZS8weGY5ClsgICAgMi42MTIzMDRdICBbPDc4MmU1MWMxPl0gPyBrbWVtX2Nh
Y2hlX2FsbG9jKzB4ZjkvMHgxMmIKWyAgICAyLjYxMjMwN10gIFs8Nzg1Zjg5N2I+XSBlZmlf
cGFydGl0aW9uKzB4MTdhLzB4OWMyClsgICAgMi42MTIzMDldICBbPDc4MmM0MmU0Pl0gPyBf
X2FsbG9jX3BhZ2VzX25vZGVtYXNrKzB4ZTMvMHg2MWUKWyAgICAyLjYxMjMxMl0gIFs8Nzg2
MGJhOWQ+XSA/IHN0cmluZy5pc3JhLjQrMHgyOS8weDkzClsgICAgMi42MTIzMTVdICBbPDc4
NjBiYTlkPl0gPyBzdHJpbmcuaXNyYS40KzB4MjkvMHg5MwpbICAgIDIuNjEyMzQwXSAgWzw3
ODYwYzg0Mj5dID8gdnNucHJpbnRmKzB4ODEvMHgyNmYKWyAgICAyLjYxMjM0Ml0gIFs8Nzg2
MGNjY2Y+XSA/IHNucHJpbnRmKzB4MTUvMHgxNwpbICAgIDIuNjEyMzQ1XSAgWzw3ODVmN2Iz
ND5dIGNoZWNrX3BhcnRpdGlvbisweGU0LzB4MTc4ClsgICAgMi42MTIzNDddICBbPDc4NWY3
YjM0Pl0gPyBjaGVja19wYXJ0aXRpb24rMHhlNC8weDE3OApbICAgIDIuNjEyMzQ5XSAgWzw3
ODVmNzc4Nj5dIHJlc2Nhbl9wYXJ0aXRpb25zKzB4ODkvMHgyNjcKWyAgICAyLjYxMjM1Ml0g
IFs8NzgzMThjZTM+XSA/IGJkZXZfaW5vZGVfc3dpdGNoX2JkaSsweGQyLzB4ZTYKWyAgICAy
LjYxMjM1NF0gIFs8NzgzMTlhOWE+XSBfX2Jsa2Rldl9nZXQrMHgxNzMvMHgzNjMKWyAgICAy
LjYxMjM1N10gIFs8NzgzMTljZDU+XSBibGtkZXZfZ2V0KzB4NGIvMHgyM2QKWyAgICAyLjYx
MjM1OV0gIFs8NzgzMTkzOTM+XSA/IGJkZ2V0KzB4ZjgvMHgxMDUKWyAgICAyLjYxMjM2M10g
IFs8Nzg4YWRiYjY+XSA/IHB1dF9kZXZpY2UrMHhmLzB4MTEKWyAgICAyLjYxMjM2NV0gIFs8
Nzg1ZjU3NjM+XSBhZGRfZGlzaysweDI2Yi8weDNiNQpbICAgIDIuNjEyMzY4XSAgWzw3ODhi
NWNkMD5dID8gX19wbV9ydW50aW1lX3VzZV9hdXRvc3VzcGVuZCsweDRhLzB4NGYKWyAgICAy
LjYxMjM3MV0gIFs8Nzg5ZDJkYjU+XSBzZF9wcm9iZV9hc3luYysweDExMS8weDE5OApbICAg
IDIuNjEyMzc0XSAgWzw3ODI3NTEzOT5dIGFzeW5jX3J1bl9lbnRyeV9mbisweDU5LzB4ZmYK
WyAgICAyLjYxMjM3OF0gIFs8NzgyNmMyNjU+XSBwcm9jZXNzX29uZV93b3JrKzB4MWVmLzB4
MzQ5ClsgICAgMi42MTIzODBdICBbPDc4MjZjMjBjPl0gPyBwcm9jZXNzX29uZV93b3JrKzB4
MTk2LzB4MzQ5ClsgICAgMi42MTIzODNdICBbPDc4MjZjN2I2Pl0gd29ya2VyX3RocmVhZCsw
eDFhMy8weDI3NApbICAgIDIuNjEyMzg2XSAgWzw3ODI2YzYxMz5dID8gcmVzY3Vlcl90aHJl
YWQrMHgyMzMvMHgyMzMKWyAgICAyLjYxMjM4OF0gIFs8NzgyNzBlMDE+XSBrdGhyZWFkKzB4
OGEvMHg4ZgpbICAgIDIuNjEyMzkxXSAgWzw3ODI3MDAwMD5dID8gY29tbW9uX3RpbWVyX3Nl
dCsweGZjLzB4MTQzClsgICAgMi42MTIzOTRdICBbPDc4ZmJhYTdiPl0gcmV0X2Zyb21fa2Vy
bmVsX3RocmVhZCsweDFiLzB4MzAKWyAgICAyLjYxMjM5Nl0gIFs8NzgyNzBkNzc+XSA/IF9f
a3RocmVhZF9wYXJrbWUrMHg1MC8weDUwClsgICAgMi42MTQwNDhdICBzZGE6IHVua25vd24g
cGFydGl0aW9uIHRhYmxlClsgICAgMi42MTgwOTBdIHNkIDA6MDowOjA6IFtzZGFdIEF0dGFj
aGVkIFNDU0kgZGlzawpbICAgIDIuNjQwMTI1XSBlbmljOiBDaXNjbyBWSUMgRXRoZXJuZXQg
TklDIERyaXZlciwgdmVyIDIuMS4xLjUwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo3LTEx
MDgyMzE4LzQ3YjhkOWM4YzM4YTk1NjA5NGU3ZjZiMjMxMzcxMzMxZGQyZGQwZDkvZG1lc2ct
cXVhbnRhbC1pbm4tMTU6MjAxMzExMTAxOTU1NDQ6aTM4Ni1yYW5kY29uZmlnLWo3LTExMDgy
MzE4OjMuMTIuMC0wMDYzNC1nNDdiOGQ5Yzo1MDIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
ajctMTEwODIzMTgvNDdiOGQ5YzhjMzhhOTU2MDk0ZTdmNmIyMzEzNzEzMzFkZDJkZDBkOS9k
bWVzZy1xdWFudGFsLWlubi0zMDoyMDEzMTExMDE5NTU0MTppMzg2LXJhbmRjb25maWctajct
MTEwODIzMTg6My4xMi4wLTAwNjM0LWc0N2I4ZDljOjUwMgova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1qNy0xMTA4MjMxOC80N2I4ZDljOGMzOGE5NTYwOTRlN2Y2YjIzMTM3MTMzMWRkMmRk
MGQ5L2RtZXNnLXF1YW50YWwtaW5uLTQzOjIwMTMxMTEwMTk1NTQ4OmkzODYtcmFuZGNvbmZp
Zy1qNy0xMTA4MjMxODozLjEyLjAtMDA2MzQtZzQ3YjhkOWM6NTAyCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWo3LTExMDgyMzE4LzQ3YjhkOWM4YzM4YTk1NjA5NGU3ZjZiMjMxMzcxMzMx
ZGQyZGQwZDkvZG1lc2ctcXVhbnRhbC14cHMtMjoyMDEzMTExMTAzNTMxMzppMzg2LXJhbmRj
b25maWctajctMTEwODIzMTg6My4xMi4wLTAwNjM0LWc0N2I4ZDljOjUwMgowOjQ6NCBhbGxf
Z29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtUkVQRUFUIENPVU5UOiAyMCAgIyAvY2Mv
d2ZnL21tLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiAzMjkgcmV2aXNpb25zIGxl
ZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDggc3RlcHMpCls4YTRkMGI1NmIwMzE0
NTVhZGNiZTRhOTM4M2MzYjQ5NzQ1NmZjZmFjXSBNZXJnZSBicmFuY2ggJ3Vwcm9iZXMvY29y
ZScgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L29s
ZWcvbWlzYyBpbnRvIHBlcmYvY29yZQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tL29iai1iaXNlY3QKbHMgLWEgL2tl
cm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxOC9u
ZXh0Om1hc3Rlcjo4YTRkMGI1NmIwMzE0NTVhZGNiZTRhOTM4M2MzYjQ5NzQ1NmZjZmFjOmJp
c2VjdC1tbQoKMjAxMy0xMS0xMC0xOTo1NjowOCA4YTRkMGI1NmIwMzE0NTVhZGNiZTRhOTM4
M2MzYjQ5NzQ1NmZjZmFjIGNvbXBpbGluZwo3NjYgcmVhbCAgMjUxNCB1c2VyICAyMjggc3lz
ICAzNTcuOTAlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWo3LTExMDgyMzE4CgoyMDEzLTExLTEw
LTIwOjEyOjMzIGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC0wMDMwNC1nOGE0ZDBiNTYJ
MTAJMTIJMTMJMTguLi4JMTkuLi4uLi4uCTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMTU4IHJl
dmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA3IHN0ZXBzKQpbYzkw
NDIzZDFkZTEyZmJlYWYwYzg5OGUxZGIwZTk2MmRlMzQ3MzAyYl0gTWVyZ2UgYnJhbmNoICdz
Y2hlZC9jb3JlJyBpbnRvIGNvcmUvbG9ja2luZywgdG8gcHJlcGFyZSB0aGUga2VybmVsL2xv
Y2tpbmcvIGZpbGUgbW92ZQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10
ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxOC9uZXh0Om1h
c3RlcjpjOTA0MjNkMWRlMTJmYmVhZjBjODk4ZTFkYjBlOTYyZGUzNDczMDJiOmJpc2VjdC1t
bQoKMjAxMy0xMS0xMC0yMDoyMDozOCBjOTA0MjNkMWRlMTJmYmVhZjBjODk4ZTFkYjBlOTYy
ZGUzNDczMDJiIGNvbXBpbGluZwo3MzQgcmVhbCAgMjUwOSB1c2VyICAyMjUgc3lzICAzNzIu
NDYlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWo3LTExMDgyMzE4CgoyMDEzLTExLTEwLTIwOjM0
OjE3IGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC0wMDE3MS1nYzkwNDIzZAk5LgkxMwkx
OS4uCTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogNjYgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDYgc3RlcHMpClsyNWMxYmQxZGIwNGQ1ODk2N2JiZDk3OWJl
YTcxZTgyZGIyMjkyNDA3XSBNZXJnZSBicmFuY2ggJ3RpbWVycy9jb3JlJwpydW5uaW5nIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21t
L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFu
ZGNvbmZpZy1qNy0xMTA4MjMxOC9uZXh0Om1hc3RlcjoyNWMxYmQxZGIwNGQ1ODk2N2JiZDk3
OWJlYTcxZTgyZGIyMjkyNDA3OmJpc2VjdC1tbQoKMjAxMy0xMS0xMC0yMDozNzo1MSAyNWMx
YmQxZGIwNGQ1ODk2N2JiZDk3OWJlYTcxZTgyZGIyMjkyNDA3IGNvbXBpbGluZwo3NDAgcmVh
bCAgMjUwMyB1c2VyICAyMjQgc3lzICAzNjguNjklIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWo3
LTExMDgyMzE4CgoyMDEzLTExLTEwLTIwOjUyOjQwIGRldGVjdGluZyBib290IHN0YXRlIDMu
MTIuMC0wMDU2Ny1nMjVjMWJkMS4gVEVTVCBGQUlMVVJFClsgICAgMS45MzUwNjldIHNkIDA6
MDowOjA6IFtzZGFdIFdyaXRlIGNhY2hlOiBlbmFibGVkLCByZWFkIGNhY2hlOiBlbmFibGVk
LCBzdXBwb3J0cyBEUE8gYW5kIEZVQQpbICAgIDEuOTM2Mjk2XSBwbWM1NTE6IG5vdCBkZXRl
Y3RlZApbICAgIDEuOTM4MDUyXSBTcGVjdHJhIE1URCBkcml2ZXIgYnVpbHQgb24gTm92IDEw
IDIwMTMgQCAyMDo0NDo0NwpbICAgIDEuOTQxMTg2XSBJTkZPOiB0cnlpbmcgdG8gcmVnaXN0
ZXIgbm9uLXN0YXRpYyBrZXkuClsgICAgMS45NDE2NjRdIHRoZSBjb2RlIGlzIGZpbmUgYnV0
IG5lZWRzIGxvY2tkZXAgYW5ub3RhdGlvbi4KWyAgICAxLjk0MjAyOV0gdHVybmluZyBvZmYg
dGhlIGxvY2tpbmcgY29ycmVjdG5lc3MgdmFsaWRhdG9yLgpbICAgIDEuOTQyMDI5XSBDUFU6
IDAgUElEOiA5NiBDb21tOiBrd29ya2VyL3U0OjEgTm90IHRhaW50ZWQgMy4xMi4wLTAwNTY3
LWcyNWMxYmQxICM1MDUKWyAgICAxLjk0MjAyOV0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9j
aHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDEuOTQyMDI5XSBXb3JrcXVldWU6IGV2
ZW50c191bmJvdW5kIGFzeW5jX3J1bl9lbnRyeV9mbgpbICAgIDEuOTQyMDI5XSAgNzgyOGQ5
OTkgMDAwMDAwMDAgODc4MDU5NjggNzhmYTNlZjggNzk5YzlhM2MgODc4MDU5YTAgNzgyODg3
NDIgNzkzODVmMTgKWyAgICAxLjk0MjAyOV0gIDc5Mzg1ZjcyIDc5Mzg1ZjQ4IDdmM2QzMzA4
IDAwMDAwMDAwIDAwMDAwMDExIDQ4MzU2MDExIDAwMDBhODg1IDdmM2QyZTIwClsgICAgMS45
NDIwMjldICA3ZjNkMmUyMCA4NWJmMzU0MCAwMDAwMDAwMCA4NzgwNTljYyA3ODI4OTNjOSAw
MDAwMDAwMCAwMDAwMDAwMSAwMDAwMDAwMApbICAgIDEuOTQyMDI5XSBDYWxsIFRyYWNlOgpb
ICAgIDEuOTQyMDI5XSAgWzw3ODI4ZDk5OT5dID8gY29uc29sZV91bmxvY2srMHgzNTMvMHgz
ODAKWyAgICAxLjk0MjAyOV0gIFs8NzhmYTNlZjg+XSBkdW1wX3N0YWNrKzB4NDgvMHg2MApb
ICAgIDEuOTQyMDI5XSAgWzw3ODI4ODc0Mj5dIF9fbG9ja19hY3F1aXJlLmlzcmEuMjYrMHg3
ZWEvMHhjZjIKWyAgICAxLjk0MjAyOV0gIFs8NzgyODkzYzk+XSBsb2NrX2FjcXVpcmUrMHg3
MS8weDlhClsgICAgMS45NDIwMjldICBbPDc4NWZjZTg0Pl0gPyBibGtfdGhyb3RsX2Jpbysw
eDFjMy8weDQ4NQpbICAgIDEuOTQyMDI5XSAgWzw3ODVmYmE2NT5dIHRocm90bF91cGRhdGVf
ZGlzcGF0Y2hfc3RhdHMrMHg3Yy8weDE1MwpbICAgIDEuOTQyMDI5XSAgWzw3ODVmY2U4ND5d
ID8gYmxrX3Rocm90bF9iaW8rMHgxYzMvMHg0ODUKWyAgICAxLjk0MjAyOV0gIFs8Nzg1ZmNl
ODQ+XSBibGtfdGhyb3RsX2JpbysweDFjMy8weDQ4NQpbICAgIDEuOTQyMDI5XSAgWzw3ODI3
YjliYj5dID8gc2NoZWRfY2xvY2tfbG9jYWwrMHgxNy8weDEwNgpbICAgIDEuOTQyMDI5XSAg
Wzw3ODI3YmM0ZD5dID8gc2NoZWRfY2xvY2tfY3B1KzB4MTA1LzB4MTEzClsgICAgMS45NDIw
MjldICBbPDc4NWViNDUyPl0gZ2VuZXJpY19tYWtlX3JlcXVlc3RfY2hlY2tzKzB4M2JiLzB4
M2QyClsgICAgMS45NDIwMjldICBbPDc4MjdiYzRkPl0gPyBzY2hlZF9jbG9ja19jcHUrMHgx
MDUvMHgxMTMKWyAgICAxLjk0MjAyOV0gIFs8Nzg1ZWNiZTc+XSBnZW5lcmljX21ha2VfcmVx
dWVzdCsweGYvMHhiNQpbICAgIDEuOTQyMDI5XSAgWzw3ODVlY2NmMj5dIHN1Ym1pdF9iaW8r
MHg2NS8weGQyClsgICAgMS45NDIwMjldICBbPDc4MzE0NTM1Pl0gX3N1Ym1pdF9iaCsweDIy
Ni8weDI0MwpbICAgIDEuOTQyMDI5XSAgWzw3ODMxNDU1Yz5dIHN1Ym1pdF9iaCsweGEvMHhj
ClsgICAgMS45NDIwMjldICBbPDc4MzE1NTMxPl0gYmxvY2tfcmVhZF9mdWxsX3BhZ2UrMHgy
YWEvMHgyYzUKWyAgICAxLjk0MjAyOV0gIFs8NzgzMTgxY2Q+XSA/IGJpb19kaXJ0eV9mbisw
eDY4LzB4NjgKWyAgICAxLjk0MjAyOV0gIFs8NzgyYmRmNTA+XSA/IGFkZF90b19wYWdlX2Nh
Y2hlX2xvY2tlZCsweGI0LzB4ZTIKWyAgICAxLjk0MjAyOV0gIFs8NzgzMTg0NjM+XSA/IGJs
a2Rldl93cml0ZV9iZWdpbisweDIwLzB4MjAKWyAgICAxLjk0MjAyOV0gIFs8NzgzMTg0NjM+
XSA/IGJsa2Rldl93cml0ZV9iZWdpbisweDIwLzB4MjAKWyAgICAxLjk0MjAyOV0gIFs8Nzgz
MTg0NzI+XSBibGtkZXZfcmVhZHBhZ2UrMHhmLzB4MTEKWyAgICAxLjk0MjAyOV0gIFs8Nzgy
YmVhYmI+XSBkb19yZWFkX2NhY2hlX3BhZ2UrMHg2ZS8weDExYgpbICAgIDEuOTQyMDI5XSAg
Wzw3ODJiZjdjOT5dIHJlYWRfY2FjaGVfcGFnZV9hc3luYysweDE5LzB4MWUKWyAgICAxLjk0
MjAyOV0gIFs8NzgzMTg0NjM+XSA/IGJsa2Rldl93cml0ZV9iZWdpbisweDIwLzB4MjAKWyAg
ICAxLjk0MjAyOV0gIFs8NzgyYmY3ZmE+XSByZWFkX2NhY2hlX3BhZ2UrMHhiLzB4MTIKWyAg
ICAxLjk0MjAyOV0gIFs8Nzg1ZjZjMTQ+XSByZWFkX2Rldl9zZWN0b3IrMHgyNi8weDYxClsg
ICAgMS45NDIwMjldICBbPDc4NWY3NjYyPl0gcmVhZF9sYmErMHhhZS8weGY5ClsgICAgMS45
NDIwMjldICBbPDc4MmU0YzJkPl0gPyBrbWVtX2NhY2hlX2FsbG9jKzB4ZjkvMHgxMmIKWyAg
ICAxLjk0MjAyOV0gIFs8Nzg1ZjdiOTI+XSBlZmlfcGFydGl0aW9uKzB4MTdhLzB4OWMyClsg
ICAgMS45NDIwMjldICBbPDc4MmMzZDkzPl0gPyBfX2FsbG9jX3BhZ2VzX25vZGVtYXNrKzB4
ZTMvMHg2MWUKWyAgICAxLjk0MjAyOV0gIFs8Nzg2MGFjN2I+XSA/IHN0cmluZy5pc3JhLjQr
MHgyOS8weDkzClsgICAgMS45NDIwMjldICBbPDc4NjBhYzdiPl0gPyBzdHJpbmcuaXNyYS40
KzB4MjkvMHg5MwpbICAgIDEuOTQyMDI5XSAgWzw3ODYwYmEyMD5dID8gdnNucHJpbnRmKzB4
ODEvMHgyNmYKWyAgICAxLjk0MjAyOV0gIFs8Nzg2MGJlYWQ+XSA/IHNucHJpbnRmKzB4MTUv
MHgxNwpbICAgIDEuOTQyMDI5XSAgWzw3ODVmNmQ0Yj5dIGNoZWNrX3BhcnRpdGlvbisweGU0
LzB4MTc4ClsgICAgMS45NDIwMjldICBbPDc4NWY2ZDRiPl0gPyBjaGVja19wYXJ0aXRpb24r
MHhlNC8weDE3OApbICAgIDEuOTQyMDI5XSAgWzw3ODVmNjk5ZD5dIHJlc2Nhbl9wYXJ0aXRp
b25zKzB4ODkvMHgyNjcKWyAgICAxLjk0MjAyOV0gIFs8NzgzMTg1NTc+XSA/IGJkZXZfaW5v
ZGVfc3dpdGNoX2JkaSsweGQyLzB4ZTYKWyAgICAxLjk0MjAyOV0gIFs8NzgzMTkzMGU+XSBf
X2Jsa2Rldl9nZXQrMHgxNzMvMHgzNjMKWyAgICAxLjk0MjAyOV0gIFs8NzgzMTk1NDk+XSBi
bGtkZXZfZ2V0KzB4NGIvMHgyM2QKWyAgICAxLjk0MjAyOV0gIFs8NzgzMThjMDc+XSA/IGJk
Z2V0KzB4ZjgvMHgxMDUKWyAgICAxLjk0MjAyOV0gIFs8Nzg4YWMzZGE+XSA/IHB1dF9kZXZp
Y2UrMHhmLzB4MTEKWyAgICAxLjk0MjAyOV0gIFs8Nzg1ZjQ5ZjA+XSBhZGRfZGlzaysweDI2
Yi8weDNiNQpbICAgIDEuOTQyMDI5XSAgWzw3ODhiNDRmND5dID8gX19wbV9ydW50aW1lX3Vz
ZV9hdXRvc3VzcGVuZCsweDRhLzB4NGYKWyAgICAxLjk0MjAyOV0gIFs8Nzg5ZDEyNmQ+XSBz
ZF9wcm9iZV9hc3luYysweDExMS8weDE5OApbICAgIDEuOTQyMDI5XSAgWzw3ODI3NGNlYz5d
IGFzeW5jX3J1bl9lbnRyeV9mbisweDU5LzB4ZmYKWyAgICAxLjk0MjAyOV0gIFs8NzgyNmJl
NmU+XSBwcm9jZXNzX29uZV93b3JrKzB4MWVmLzB4MzQ5ClsgICAgMS45NDIwMjldICBbPDc4
MjZiZTE1Pl0gPyBwcm9jZXNzX29uZV93b3JrKzB4MTk2LzB4MzQ5ClsgICAgMS45NDIwMjld
ICBbPDc4MjZjM2JmPl0gd29ya2VyX3RocmVhZCsweDFhMy8weDI3NApbICAgIDEuOTQyMDI5
XSAgWzw3ODI2YzIxYz5dID8gcmVzY3Vlcl90aHJlYWQrMHgyMzMvMHgyMzMKWyAgICAxLjk0
MjAyOV0gIFs8NzgyNzA5Y2Y+XSBrdGhyZWFkKzB4OGEvMHg4ZgpbICAgIDEuOTQyMDI5XSAg
Wzw3ODI3MDAwMD5dID8gcG9zaXhfdGltZXJzX3JlZ2lzdGVyX2Nsb2NrKzB4NGMvMHg0ZQpb
ICAgIDEuOTQyMDI5XSAgWzw3OGZiNzQzYj5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgx
Yi8weDMwClsgICAgMS45NDIwMjldICBbPDc4MjcwOTQ1Pl0gPyBfX2t0aHJlYWRfcGFya21l
KzB4NTAvMHg1MApbICAgIDEuOTc1MDU2XSAgc2RhOiB1bmtub3duIHBhcnRpdGlvbiB0YWJs
ZQpbICAgIDEuOTc2NzE3XSBObyB2YWxpZCBEaXNrT25DaGlwIGRldmljZXMgZm91bmQKWyAg
ICAxLjk3NzEzOV0gW25hbmRzaW1dIHdhcm5pbmc6IHJlYWRfYnl0ZTogdW5leHBlY3RlZCBk
YXRhIG91dHB1dCBjeWNsZSwgc3RhdGUgaXMgU1RBVEVfUkVBRFkgcmV0dXJuIDB4MAova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxOC8yNWMxYmQxZGIwNGQ1ODk2N2JiZDk3
OWJlYTcxZTgyZGIyMjkyNDA3L2RtZXNnLXF1YW50YWwtY2Fpcm8tMjM6MjAxMzExMTAyMDUy
NDg6aTM4Ni1yYW5kY29uZmlnLWo3LTExMDgyMzE4OjMuMTIuMC0wMDU2Ny1nMjVjMWJkMTo1
MDUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajctMTEwODIzMTgvMjVjMWJkMWRiMDRkNTg5
NjdiYmQ5NzliZWE3MWU4MmRiMjI5MjQwNy9kbWVzZy1xdWFudGFsLWNhaXJvLTM3OjIwMTMx
MTEwMjA1MjQ5OmkzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxODozLjEyLjAtMDA1NjctZzI1
YzFiZDE6NTA1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo3LTExMDgyMzE4LzI1YzFiZDFk
YjA0ZDU4OTY3YmJkOTc5YmVhNzFlODJkYjIyOTI0MDcvZG1lc2ctcXVhbnRhbC1pbm4tMTE6
MjAxMzExMTAyMDUyNTA6aTM4Ni1yYW5kY29uZmlnLWo3LTExMDgyMzE4OjMuMTIuMC0wMDU2
Ny1nMjVjMWJkMTo1MDUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajctMTEwODIzMTgvMjVj
MWJkMWRiMDRkNTg5NjdiYmQ5NzliZWE3MWU4MmRiMjI5MjQwNy9kbWVzZy1xdWFudGFsLWlu
bi0xOToyMDEzMTExMDIwNTI0ODppMzg2LXJhbmRjb25maWctajctMTEwODIzMTg6My4xMi4w
LTAwNTY3LWcyNWMxYmQxOjUwNQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMx
OC8yNWMxYmQxZGIwNGQ1ODk2N2JiZDk3OWJlYTcxZTgyZGIyMjkyNDA3L2RtZXNnLXF1YW50
YWwtaW5uLTQ3OjIwMTMxMTEwMjA1MjUwOmkzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxODoz
LjEyLjAtMDA1NjctZzI1YzFiZDE6NTA1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo3LTEx
MDgyMzE4LzI1YzFiZDFkYjA0ZDU4OTY3YmJkOTc5YmVhNzFlODJkYjIyOTI0MDcvZG1lc2ct
cXVhbnRhbC1jYWlyby0xOjIwMTMxMTEwMjA1MjUwOmkzODYtcmFuZGNvbmZpZy1qNy0xMTA4
MjMxODozLjEyLjAtMDA1NjctZzI1YzFiZDE6NTA1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWo3LTExMDgyMzE4LzI1YzFiZDFkYjA0ZDU4OTY3YmJkOTc5YmVhNzFlODJkYjIyOTI0MDcv
ZG1lc2ctcXVhbnRhbC1pbm4tMzc6MjAxMzExMTAyMDUyNTU6aTM4Ni1yYW5kY29uZmlnLWo3
LTExMDgyMzE4OjMuMTIuMC0wMDU2Ny1nMjVjMWJkMTo1MDUKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctajctMTEwODIzMTgvMjVjMWJkMWRiMDRkNTg5NjdiYmQ5NzliZWE3MWU4MmRiMjI5
MjQwNy9kbWVzZy1xdWFudGFsLWlubi00NToyMDEzMTExMDIwNTI1MTppMzg2LXJhbmRjb25m
aWctajctMTEwODIzMTg6My4xMi4wLTAwNTY3LWcyNWMxYmQxOjUwNQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1qNy0xMTA4MjMxOC8yNWMxYmQxZGIwNGQ1ODk2N2JiZDk3OWJlYTcxZTgy
ZGIyMjkyNDA3L2RtZXNnLXF1YW50YWwtbGtwLXR0MDItNDoyMDEzMTExMDExNDQyNTppMzg2
LXJhbmRjb25maWctajctMTEwODIzMTg6My4xMi4wLTAwNTY3LWcyNWMxYmQxOjUwNQova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxOC8yNWMxYmQxZGIwNGQ1ODk2N2JiZDk3
OWJlYTcxZTgyZGIyMjkyNDA3L2RtZXNnLXF1YW50YWwtc3RvYWtsZXktNjoyMDEzMTExMDIw
NTI1NTppMzg2LXJhbmRjb25maWctajctMTEwODIzMTg6My4xMi4wLTAwNTY3LWcyNWMxYmQx
OjUwNQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxOC8yNWMxYmQxZGIwNGQ1
ODk2N2JiZDk3OWJlYTcxZTgyZGIyMjkyNDA3L2RtZXNnLXF1YW50YWwteGd3by0xOjIwMTMx
MTExMDQ0OTE2OmkzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxODozLjEyLjAtMDA1NjctZzI1
YzFiZDE6NTA1CjA6MTE6MTEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bVJF
UEVBVCBDT1VOVDogMjAgICMgL2NjL3dmZy9tbS1iaXNlY3QvLnJlcGVhdBtbMG0KCkJpc2Vj
dGluZzogNDMgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDYg
c3RlcHMpCls4YTc0OWRlNWUzMmQyYjcyZGVmOTNmN2JkN2EyNzQ1NTgwZDc1ODcyXSBNZXJn
ZSBicmFuY2ggJ2ZvcnRnbHgvMy4xMy90aW1lJyBvZiBnaXQ6Ly9naXQubGluYXJvLm9yZy9w
ZW9wbGUvanN0dWx0ei9saW51eCBpbnRvIHRpbWVycy9jb3JlCnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJp
c2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmln
LWo3LTExMDgyMzE4L25leHQ6bWFzdGVyOjhhNzQ5ZGU1ZTMyZDJiNzJkZWY5M2Y3YmQ3YTI3
NDU1ODBkNzU4NzI6YmlzZWN0LW1tCgoyMDEzLTExLTEwLTIwOjUzOjE1IDhhNzQ5ZGU1ZTMy
ZDJiNzJkZWY5M2Y3YmQ3YTI3NDU1ODBkNzU4NzIgY29tcGlsaW5nCjg3OSByZWFsICAyNTAw
IHVzZXIgIDIxNiBzeXMgIDMwOC45MCUgY3B1IAlpMzg2LXJhbmRjb25maWctajctMTEwODIz
MTgKCjIwMTMtMTEtMTAtMjE6MDk6MDggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLXJj
My0wMDA0OC1nOGE3NDlkZQk0CTYJMTgJMTkuLgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDE5
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA1IHN0ZXBzKQpb
MjI2ZTRjODEzODVhYzhkNDc5NjJkNTY2MGM1NGZmOWRmNjI5YzE1ZV0gTWVyZ2UgYnJhbmNo
ICdpcnEvY29yZScKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9ob21lL3dmZy9tbS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajctMTEwODIzMTgvbmV4dDptYXN0ZXI6
MjI2ZTRjODEzODVhYzhkNDc5NjJkNTY2MGM1NGZmOWRmNjI5YzE1ZTpiaXNlY3QtbW0KCjIw
MTMtMTEtMTAtMjE6MTI6NDEgMjI2ZTRjODEzODVhYzhkNDc5NjJkNTY2MGM1NGZmOWRmNjI5
YzE1ZSBjb21waWxpbmcKMTAwMCByZWFsICAyNDk2IHVzZXIgIDIwNiBzeXMgIDI3MC4yMSUg
Y3B1IAlpMzg2LXJhbmRjb25maWctajctMTEwODIzMTgKCjIwMTMtMTEtMTAtMjE6MzA6Mjgg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLTAwMTk1LWcyMjZlNGM4LiBURVNUIEZBSUxV
UkUKWyAgICAxLjkzNDMwOV0gUmFtaXggUE1DNTUxIFBDSSBNZXp6YW5pbmUgUmFtIERyaXZl
ci4gKEMpIDE5OTksMjAwMCBOb3J0ZWwgTmV0d29ya3MuClsgICAgMS45MzQzMTVdIHBtYzU1
MTogbm90IGRldGVjdGVkClsgICAgMS45MzU5ODVdIFNwZWN0cmEgTVREIGRyaXZlciBidWls
dCBvbiBOb3YgMTAgMjAxMyBAIDIxOjE2OjA1ClsgICAgMS45NDY0NDVdIElORk86IHRyeWlu
ZyB0byByZWdpc3RlciBub24tc3RhdGljIGtleS4KWyAgICAxLjk0NzA2OV0gdGhlIGNvZGUg
aXMgZmluZSBidXQgbmVlZHMgbG9ja2RlcCBhbm5vdGF0aW9uLgpbICAgIDEuOTQ3MDY5XSB0
dXJuaW5nIG9mZiB0aGUgbG9ja2luZyBjb3JyZWN0bmVzcyB2YWxpZGF0b3IuClsgICAgMS45
NDcwNjldIENQVTogMCBQSUQ6IDk1IENvbW06IGt3b3JrZXIvdTQ6MSBOb3QgdGFpbnRlZCAz
LjEyLjAtMDAxOTUtZzIyNmU0YzggIzUwNwpbICAgIDEuOTQ3MDY5XSBIYXJkd2FyZSBuYW1l
OiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMS45NDcwNjldIFdv
cmtxdWV1ZTogZXZlbnRzX3VuYm91bmQgYXN5bmNfcnVuX2VudHJ5X2ZuClsgICAgMS45NDcw
NjldICA3ODI4ZDZlZCAwMDAwMDAwMCA3ZjNjNTk2OCA3OGZhM2JjMiA3OTljOWEzYyA3ZjNj
NTlhMCA3ODI4ODQ5NiA3OTM4NWM2YQpbICAgIDEuOTQ3MDY5XSAgNzkzODVjYzQgNzkzODVj
OWEgODU2N2E1MTggMDAwMDAwMDAgMDAwMDAwMTEgMzgzNWEwMTEgMDAwMGE2ODUgODU2N2Ew
MzAKWyAgICAxLjk0NzA2OV0gIDg1NjdhMDMwIDg1YmYzNTQwIDAwMDAwMDAwIDdmM2M1OWNj
IDc4Mjg5MTFkIDAwMDAwMDAwIDAwMDAwMDAxIDAwMDAwMDAwClsgICAgMS45NDcwNjldIENh
bGwgVHJhY2U6ClsgICAgMS45NDcwNjldICBbPDc4MjhkNmVkPl0gPyBjb25zb2xlX3VubG9j
aysweDM1My8weDM4MApbICAgIDEuOTQ3MDY5XSAgWzw3OGZhM2JjMj5dIGR1bXBfc3RhY2sr
MHg0OC8weDYwClsgICAgMS45NDcwNjldICBbPDc4Mjg4NDk2Pl0gX19sb2NrX2FjcXVpcmUu
aXNyYS4yNisweDdlYS8weGNmMgpbICAgIDEuOTQ3MDY5XSAgWzw3ODI4OTExZD5dIGxvY2tf
YWNxdWlyZSsweDcxLzB4OWEKWyAgICAxLjk0NzA2OV0gIFs8Nzg1ZmNiMDQ+XSA/IGJsa190
aHJvdGxfYmlvKzB4MWMzLzB4NDg1ClsgICAgMS45NDcwNjldICBbPDc4NWZiNmU1Pl0gdGhy
b3RsX3VwZGF0ZV9kaXNwYXRjaF9zdGF0cysweDdjLzB4MTUzClsgICAgMS45NDcwNjldICBb
PDc4NWZjYjA0Pl0gPyBibGtfdGhyb3RsX2JpbysweDFjMy8weDQ4NQpbICAgIDEuOTQ3MDY5
XSAgWzw3ODVmY2IwND5dIGJsa190aHJvdGxfYmlvKzB4MWMzLzB4NDg1ClsgICAgMS45NDcw
NjldICBbPDc4MjdiNzBmPl0gPyBzY2hlZF9jbG9ja19sb2NhbCsweDE3LzB4MTA2ClsgICAg
MS45NDcwNjldICBbPDc4MjdiOWExPl0gPyBzY2hlZF9jbG9ja19jcHUrMHgxMDUvMHgxMTMK
WyAgICAxLjk0NzA2OV0gIFs8Nzg1ZWIwZDI+XSBnZW5lcmljX21ha2VfcmVxdWVzdF9jaGVj
a3MrMHgzYmIvMHgzZDIKWyAgICAxLjk0NzA2OV0gIFs8NzgyN2I5YTE+XSA/IHNjaGVkX2Ns
b2NrX2NwdSsweDEwNS8weDExMwpbICAgIDEuOTQ3MDY5XSAgWzw3ODVlYzg2Nz5dIGdlbmVy
aWNfbWFrZV9yZXF1ZXN0KzB4Zi8weGI1ClsgICAgMS45NDcwNjldICBbPDc4NWVjOTcyPl0g
c3VibWl0X2JpbysweDY1LzB4ZDIKWyAgICAxLjk0NzA2OV0gIFs8NzgzMTQxYmY+XSBfc3Vi
bWl0X2JoKzB4MjI2LzB4MjQzClsgICAgMS45NDcwNjldICBbPDc4MzE0MWU2Pl0gc3VibWl0
X2JoKzB4YS8weGMKWyAgICAxLjk0NzA2OV0gIFs8NzgzMTUxYmI+XSBibG9ja19yZWFkX2Z1
bGxfcGFnZSsweDJhYS8weDJjNQpbICAgIDEuOTQ3MDY5XSAgWzw3ODMxN2U1Nz5dID8gYmlv
X2RpcnR5X2ZuKzB4NjgvMHg2OApbICAgIDEuOTQ3MDY5XSAgWzw3ODJiZGJkYT5dID8gYWRk
X3RvX3BhZ2VfY2FjaGVfbG9ja2VkKzB4YjQvMHhlMgpbICAgIDEuOTQ3MDY5XSAgWzw3ODMx
ODBlZD5dID8gYmxrZGV2X3dyaXRlX2JlZ2luKzB4MjAvMHgyMApbICAgIDEuOTQ3MDY5XSAg
Wzw3ODMxODBlZD5dID8gYmxrZGV2X3dyaXRlX2JlZ2luKzB4MjAvMHgyMApbICAgIDEuOTQ3
MDY5XSAgWzw3ODMxODBmYz5dIGJsa2Rldl9yZWFkcGFnZSsweGYvMHgxMQpbICAgIDEuOTQ3
MDY5XSAgWzw3ODJiZTc0NT5dIGRvX3JlYWRfY2FjaGVfcGFnZSsweDZlLzB4MTFiClsgICAg
MS45NDcwNjldICBbPDc4MmJmNDUzPl0gcmVhZF9jYWNoZV9wYWdlX2FzeW5jKzB4MTkvMHgx
ZQpbICAgIDEuOTQ3MDY5XSAgWzw3ODMxODBlZD5dID8gYmxrZGV2X3dyaXRlX2JlZ2luKzB4
MjAvMHgyMApbICAgIDEuOTQ3MDY5XSAgWzw3ODJiZjQ4ND5dIHJlYWRfY2FjaGVfcGFnZSsw
eGIvMHgxMgpbICAgIDEuOTQ3MDY5XSAgWzw3ODVmNjg5ND5dIHJlYWRfZGV2X3NlY3Rvcisw
eDI2LzB4NjEKWyAgICAxLjk0NzA2OV0gIFs8Nzg1ZjcyZTI+XSByZWFkX2xiYSsweGFlLzB4
ZjkKWyAgICAxLjk0NzA2OV0gIFs8NzgyZTQ4Yjc+XSA/IGttZW1fY2FjaGVfYWxsb2MrMHhm
OS8weDEyYgpbICAgIDEuOTQ3MDY5XSAgWzw3ODVmNzgxMj5dIGVmaV9wYXJ0aXRpb24rMHgx
N2EvMHg5YzIKWyAgICAxLjk0NzA2OV0gIFs8NzgyYzNhMWQ+XSA/IF9fYWxsb2NfcGFnZXNf
bm9kZW1hc2srMHhlMy8weDYxZQpbICAgIDEuOTQ3MDY5XSAgWzw3ODYwYThmYj5dID8gc3Ry
aW5nLmlzcmEuNCsweDI5LzB4OTMKWyAgICAxLjk0NzA2OV0gIFs8Nzg2MGE4ZmI+XSA/IHN0
cmluZy5pc3JhLjQrMHgyOS8weDkzClsgICAgMS45NDcwNjldICBbPDc4NjBiNmEwPl0gPyB2
c25wcmludGYrMHg4MS8weDI2ZgpbICAgIDEuOTc0MTUwXSBObyB2YWxpZCBEaXNrT25DaGlw
IGRldmljZXMgZm91bmQKWyAgICAxLjk3NDE2Nl0gW25hbmRzaW1dIHdhcm5pbmc6IHJlYWRf
Ynl0ZTogdW5leHBlY3RlZCBkYXRhIG91dHB1dCBjeWNsZSwgc3RhdGUgaXMgU1RBVEVfUkVB
RFkgcmV0dXJuIDB4MApbICAgIDEuOTc0MTY3XSBbbmFuZHNpbV0gd2FybmluZzogcmVhZF9i
eXRlOiB1bmV4cGVjdGVkIGRhdGEgb3V0cHV0IGN5Y2xlLCBzdGF0ZSBpcyBTVEFURV9SRUFE
WSByZXR1cm4gMHgwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo3LTExMDgyMzE4LzIyNmU0
YzgxMzg1YWM4ZDQ3OTYyZDU2NjBjNTRmZjlkZjYyOWMxNWUvZG1lc2ctcXVhbnRhbC14aWFu
LTE1OjIwMTMxMTEwMjEzMDM3OmkzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxODozLjEyLjAt
MDAxOTUtZzIyNmU0Yzg6NTA3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo3LTExMDgyMzE4
LzIyNmU0YzgxMzg1YWM4ZDQ3OTYyZDU2NjBjNTRmZjlkZjYyOWMxNWUvZG1lc2ctcXVhbnRh
bC14aWFuLTMzOjIwMTMxMTEwMjEzMDM3OmkzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxODoz
LjEyLjAtMDAxOTUtZzIyNmU0Yzg6NTA3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo3LTEx
MDgyMzE4LzIyNmU0YzgxMzg1YWM4ZDQ3OTYyZDU2NjBjNTRmZjlkZjYyOWMxNWUvZG1lc2ct
cXVhbnRhbC14aWFuLTM3OjIwMTMxMTEwMjEzMDM3OmkzODYtcmFuZGNvbmZpZy1qNy0xMTA4
MjMxODozLjEyLjAtMDAxOTUtZzIyNmU0Yzg6NTA3Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWo3LTExMDgyMzE4LzIyNmU0YzgxMzg1YWM4ZDQ3OTYyZDU2NjBjNTRmZjlkZjYyOWMxNWUv
ZG1lc2ctcXVhbnRhbC1jYWlyby03OjIwMTMxMTEwMjEzMDQzOmkzODYtcmFuZGNvbmZpZy1q
Ny0xMTA4MjMxODozLjEyLjAtMDAxOTUtZzIyNmU0Yzg6NTA3Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWo3LTExMDgyMzE4LzIyNmU0YzgxMzg1YWM4ZDQ3OTYyZDU2NjBjNTRmZjlkZjYy
OWMxNWUvZG1lc2ctcXVhbnRhbC1pbm4tNDoyMDEzMTExMDIxMzAzOTppMzg2LXJhbmRjb25m
aWctajctMTEwODIzMTg6My4xMi4wLTAwMTk1LWcyMjZlNGM4OjUwNwova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1qNy0xMTA4MjMxOC8yMjZlNGM4MTM4NWFjOGQ0Nzk2MmQ1NjYwYzU0ZmY5
ZGY2MjljMTVlL2RtZXNnLXF1YW50YWwtc3RvYWtsZXktMzoyMDEzMTExMDIxMzA0NTppMzg2
LXJhbmRjb25maWctajctMTEwODIzMTg6My4xMi4wLTAwMTk1LWcyMjZlNGM4OjUwNwova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxOC8yMjZlNGM4MTM4NWFjOGQ0Nzk2MmQ1
NjYwYzU0ZmY5ZGY2MjljMTVlL2RtZXNnLXF1YW50YWwtc3RvYWtsZXktNjoyMDEzMTExMDIx
MzAzODppMzg2LXJhbmRjb25maWctajctMTEwODIzMTg6My4xMi4wLTAwMTk1LWcyMjZlNGM4
OjUwNwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxOC8yMjZlNGM4MTM4NWFj
OGQ0Nzk2MmQ1NjYwYzU0ZmY5ZGY2MjljMTVlL2RtZXNnLXF1YW50YWwteGlhbi0zMjoyMDEz
MTExMDIxMzA0MTppMzg2LXJhbmRjb25maWctajctMTEwODIzMTg6My4xMi4wLTAwMTk1LWcy
MjZlNGM4OjUwNwowOjg6OCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtUkVQ
RUFUIENPVU5UOiAyMCAgIyAvY2Mvd2ZnL21tLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0
aW5nOiAxMSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNCBz
dGVwcykKWzVhYzY4ZTdjMzRhNDc5N2FhNGNhOTYxNWU1YTY2MDNiZGExYWJlOWJdIGlwdjY6
IEZpeCBwb3NzaWJsZSBpcHY2IHNlcWxvY2sgZGVhZGxvY2sKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9tbS9vYmotYmlz
ZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
ajctMTEwODIzMTgvbmV4dDptYXN0ZXI6NWFjNjhlN2MzNGE0Nzk3YWE0Y2E5NjE1ZTVhNjYw
M2JkYTFhYmU5YjpiaXNlY3QtbW0KCjIwMTMtMTEtMTAtMjE6MzE6MDcgNWFjNjhlN2MzNGE0
Nzk3YWE0Y2E5NjE1ZTVhNjYwM2JkYTFhYmU5YiBjb21waWxpbmcKNjY3IHJlYWwgIDE2NTQg
dXNlciAgMTMwIHN5cyAgMjY3LjU1JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMx
OAoKMjAxMy0xMS0xMC0yMTo0NTo0MSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtMDAx
ODMtZzVhYzY4ZTcuIFRFU1QgRkFJTFVSRQpbICAgIDIuMTQxNzY0XSBSYW1peCBQTUM1NTEg
UENJIE1lenphbmluZSBSYW0gRHJpdmVyLiAoQykgMTk5OSwyMDAwIE5vcnRlbCBOZXR3b3Jr
cy4KWyAgICAyLjE0MjU1M10gcG1jNTUxOiBub3QgZGV0ZWN0ZWQKWyAgICAyLjE0NDU5N10g
U3BlY3RyYSBNVEQgZHJpdmVyIGJ1aWx0IG9uIE5vdiAxMCAyMDEzIEAgMjE6MTY6MDUKWyAg
ICAyLjE0NzE1Ml0gSU5GTzogdHJ5aW5nIHRvIHJlZ2lzdGVyIG5vbi1zdGF0aWMga2V5Lgpb
ICAgIDIuMTQ3Njk2XSB0aGUgY29kZSBpcyBmaW5lIGJ1dCBuZWVkcyBsb2NrZGVwIGFubm90
YXRpb24uClsgICAgMi4xNDgwMTJdIHR1cm5pbmcgb2ZmIHRoZSBsb2NraW5nIGNvcnJlY3Ru
ZXNzIHZhbGlkYXRvci4KWyAgICAyLjE0ODAxMl0gQ1BVOiAxIFBJRDogOTYgQ29tbToga3dv
cmtlci91NDoxIE5vdCB0YWludGVkIDMuMTIuMC0wMDE4My1nNWFjNjhlNyAjNTA4ClsgICAg
Mi4xNDgwMTJdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAx
LzIwMTEKWyAgICAyLjE0ODAxMl0gV29ya3F1ZXVlOiBldmVudHNfdW5ib3VuZCBhc3luY19y
dW5fZW50cnlfZm4KWyAgICAyLjE0ODAxMl0gIDc4MjhkNmU3IDAwMDAwMDAwIDdmM2NiOTY4
IDc4ZmEzYmMyIDc5OWM4MjRjIDdmM2NiOWEwIDc4Mjg4NDkwIDc5Mzg1YzdkClsgICAgMi4x
NDgwMTJdICA3OTM4NWNkNyA3OTM4NWNhZCA3ZjNjZjMwOCAwMDAwMDAwMCAwMDAwMDAxMSA1
MDM1MjAxMSAwMDAwYTk4NSA3ZjNjZWUyMApbICAgIDIuMTQ4MDEyXSAgN2YzY2VlMjAgODVk
M2U1NDAgMDAwMDAwMDAgN2YzY2I5Y2MgNzgyODkxMTcgMDAwMDAwMDAgMDAwMDAwMDEgMDAw
MDAwMDAKWyAgICAyLjE0ODAxMl0gQ2FsbCBUcmFjZToKWyAgICAyLjE0ODAxMl0gIFs8Nzgy
OGQ2ZTc+XSA/IGNvbnNvbGVfdW5sb2NrKzB4MzUzLzB4MzgwClsgICAgMi4xNDgwMTJdICBb
PDc4ZmEzYmMyPl0gZHVtcF9zdGFjaysweDQ4LzB4NjAKWyAgICAyLjE0ODAxMl0gIFs8Nzgy
ODg0OTA+XSBfX2xvY2tfYWNxdWlyZS5pc3JhLjI2KzB4N2VhLzB4Y2YyClsgICAgMi4xNDgw
MTJdICBbPDc4Mjg5MTE3Pl0gbG9ja19hY3F1aXJlKzB4NzEvMHg5YQpbICAgIDIuMTQ4MDEy
XSAgWzw3ODVmY2IwND5dID8gYmxrX3Rocm90bF9iaW8rMHgxYzMvMHg0ODUKWyAgICAyLjE0
ODAxMl0gIFs8Nzg1ZmI2ZTU+XSB0aHJvdGxfdXBkYXRlX2Rpc3BhdGNoX3N0YXRzKzB4N2Mv
MHgxNTMKWyAgICAyLjE0ODAxMl0gIFs8Nzg1ZmNiMDQ+XSA/IGJsa190aHJvdGxfYmlvKzB4
MWMzLzB4NDg1ClsgICAgMi4xNDgwMTJdICBbPDc4NWZjYjA0Pl0gYmxrX3Rocm90bF9iaW8r
MHgxYzMvMHg0ODUKWyAgICAyLjE0ODAxMl0gIFs8NzgyN2I3MDk+XSA/IHNjaGVkX2Nsb2Nr
X2xvY2FsKzB4MTcvMHgxMDYKWyAgICAyLjE0ODAxMl0gIFs8NzgyN2I5OWI+XSA/IHNjaGVk
X2Nsb2NrX2NwdSsweDEwNS8weDExMwpbICAgIDIuMTQ4MDEyXSAgWzw3ODVlYjBkMj5dIGdl
bmVyaWNfbWFrZV9yZXF1ZXN0X2NoZWNrcysweDNiYi8weDNkMgpbICAgIDIuMTQ4MDEyXSAg
Wzw3ODI3Yjk5Yj5dID8gc2NoZWRfY2xvY2tfY3B1KzB4MTA1LzB4MTEzClsgICAgMi4xNDgw
MTJdICBbPDc4NWVjODY3Pl0gZ2VuZXJpY19tYWtlX3JlcXVlc3QrMHhmLzB4YjUKWyAgICAy
LjE0ODAxMl0gIFs8Nzg1ZWM5NzI+XSBzdWJtaXRfYmlvKzB4NjUvMHhkMgpbICAgIDIuMTQ4
MDEyXSAgWzw3ODMxNDFiOT5dIF9zdWJtaXRfYmgrMHgyMjYvMHgyNDMKWyAgICAyLjE0ODAx
Ml0gIFs8NzgzMTQxZTA+XSBzdWJtaXRfYmgrMHhhLzB4YwpbICAgIDIuMTQ4MDEyXSAgWzw3
ODMxNTFiNT5dIGJsb2NrX3JlYWRfZnVsbF9wYWdlKzB4MmFhLzB4MmM1ClsgICAgMi4xNDgw
MTJdICBbPDc4MzE3ZTUxPl0gPyBiaW9fZGlydHlfZm4rMHg2OC8weDY4ClsgICAgMi4xNDgw
MTJdICBbPDc4MmJkYmQ0Pl0gPyBhZGRfdG9fcGFnZV9jYWNoZV9sb2NrZWQrMHhiNC8weGUy
ClsgICAgMi4xNDgwMTJdICBbPDc4MzE4MGU3Pl0gPyBibGtkZXZfd3JpdGVfYmVnaW4rMHgy
MC8weDIwClsgICAgMi4xNDgwMTJdICBbPDc4MzE4MGU3Pl0gPyBibGtkZXZfd3JpdGVfYmVn
aW4rMHgyMC8weDIwClsgICAgMi4xNDgwMTJdICBbPDc4MzE4MGY2Pl0gYmxrZGV2X3JlYWRw
YWdlKzB4Zi8weDExClsgICAgMi4xNDgwMTJdICBbPDc4MmJlNzNmPl0gZG9fcmVhZF9jYWNo
ZV9wYWdlKzB4NmUvMHgxMWIKWyAgICAyLjE0ODAxMl0gIFs8NzgyYmY0NGQ+XSByZWFkX2Nh
Y2hlX3BhZ2VfYXN5bmMrMHgxOS8weDFlClsgICAgMi4xNDgwMTJdICBbPDc4MzE4MGU3Pl0g
PyBibGtkZXZfd3JpdGVfYmVnaW4rMHgyMC8weDIwClsgICAgMi4xNDgwMTJdICBbPDc4MmJm
NDdlPl0gcmVhZF9jYWNoZV9wYWdlKzB4Yi8weDEyClsgICAgMi4xNDgwMTJdICBbPDc4NWY2
ODk0Pl0gcmVhZF9kZXZfc2VjdG9yKzB4MjYvMHg2MQpbICAgIDIuMTQ4MDEyXSAgWzw3ODVm
NzJlMj5dIHJlYWRfbGJhKzB4YWUvMHhmOQpbICAgIDIuMTQ4MDEyXSAgWzw3ODJlNDhiMT5d
ID8ga21lbV9jYWNoZV9hbGxvYysweGY5LzB4MTJiClsgICAgMi4xNDgwMTJdICBbPDc4NWY3
ODEyPl0gZWZpX3BhcnRpdGlvbisweDE3YS8weDljMgpbICAgIDIuMTQ4MDEyXSAgWzw3ODJj
M2ExNz5dID8gX19hbGxvY19wYWdlc19ub2RlbWFzaysweGUzLzB4NjFlClsgICAgMi4xNDgw
MTJdICBbPDc4NjBhOGZiPl0gPyBzdHJpbmcuaXNyYS40KzB4MjkvMHg5MwpbICAgIDIuMTQ4
MDEyXSAgWzw3ODYwYThmYj5dID8gc3RyaW5nLmlzcmEuNCsweDI5LzB4OTMKWyAgICAyLjE0
ODAxMl0gIFs8Nzg2MGI2YTA+XSA/IHZzbnByaW50ZisweDgxLzB4MjZmClsgICAgMi4xNDgw
MTJdICBbPDc4NjBiYjJkPl0gPyBzbnByaW50ZisweDE1LzB4MTcKWyAgICAyLjE0ODAxMl0g
IFs8Nzg1ZjY5Y2I+XSBjaGVja19wYXJ0aXRpb24rMHhlNC8weDE3OApbICAgIDIuMTQ4MDEy
XSAgWzw3ODVmNjljYj5dID8gY2hlY2tfcGFydGl0aW9uKzB4ZTQvMHgxNzgKWyAgICAyLjE0
ODAxMl0gIFs8Nzg1ZjY2MWQ+XSByZXNjYW5fcGFydGl0aW9ucysweDg5LzB4MjY3ClsgICAg
Mi4xNDgwMTJdICBbPDc4MzE4MWRiPl0gPyBiZGV2X2lub2RlX3N3aXRjaF9iZGkrMHhkMi8w
eGU2ClsgICAgMi4xNDgwMTJdICBbPDc4MzE4ZjkyPl0gX19ibGtkZXZfZ2V0KzB4MTczLzB4
MzYzClsgICAgMi4xNDgwMTJdICBbPDc4MzE5MWNkPl0gYmxrZGV2X2dldCsweDRiLzB4MjNk
ClsgICAgMi4xNDgwMTJdICBbPDc4MzE4ODhiPl0gPyBiZGdldCsweGY4LzB4MTA1ClsgICAg
Mi4xNDgwMTJdICBbPDc4OGFjMGNhPl0gPyBwdXRfZGV2aWNlKzB4Zi8weDExClsgICAgMi4x
NDgwMTJdICBbPDc4NWY0NjcwPl0gYWRkX2Rpc2srMHgyNmIvMHgzYjUKWyAgICAyLjE0ODAx
Ml0gIFs8Nzg4YjQxZTQ+XSA/IF9fcG1fcnVudGltZV91c2VfYXV0b3N1c3BlbmQrMHg0YS8w
eDRmClsgICAgMi4xNDgwMTJdICBbPDc4OWQwZjVkPl0gc2RfcHJvYmVfYXN5bmMrMHgxMTEv
MHgxOTgKWyAgICAyLjE0ODAxMl0gIFs8NzgyNzRhODY+XSBhc3luY19ydW5fZW50cnlfZm4r
MHg1OS8weGZmClsgICAgMi4xNDgwMTJdICBbPDc4MjZiYzA4Pl0gcHJvY2Vzc19vbmVfd29y
aysweDFlZi8weDM0OQpbICAgIDIuMTQ4MDEyXSAgWzw3ODI2YmJhZj5dID8gcHJvY2Vzc19v
bmVfd29yaysweDE5Ni8weDM0OQpbICAgIDIuMTQ4MDEyXSAgWzw3ODI2YzE1OT5dIHdvcmtl
cl90aHJlYWQrMHgxYTMvMHgyNzQKWyAgICAyLjE0ODAxMl0gIFs8NzgyNmJmYjY+XSA/IHJl
c2N1ZXJfdGhyZWFkKzB4MjMzLzB4MjMzClsgICAgMi4xNDgwMTJdICBbPDc4MjcwNzY5Pl0g
a3RocmVhZCsweDhhLzB4OGYKWyAgICAyLjE0ODAxMl0gIFs8NzgyNzAwMDA+XSA/IFN5U190
aW1lcl9jcmVhdGUrMHgyNjQvMHgzNDEKWyAgICAyLjE0ODAxMl0gIFs8NzhmYjcwZmI+XSBy
ZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MWIvMHgzMApbICAgIDIuMTgzMzc2XSBObyB2YWxp
ZCBEaXNrT25DaGlwIGRldmljZXMgZm91bmQKWyAgICAyLjE4MzM5NF0gW25hbmRzaW1dIHdh
cm5pbmc6IHJlYWRfYnl0ZTogdW5leHBlY3RlZCBkYXRhIG91dHB1dCBjeWNsZSwgc3RhdGUg
aXMgU1RBVEVfUkVBRFkgcmV0dXJuIDB4MApbICAgIDIuMTgzMzk1XSBbbmFuZHNpbV0gd2Fy
bmluZzogcmVhZF9ieXRlOiB1bmV4cGVjdGVkIGRhdGEgb3V0cHV0IGN5Y2xlLCBzdGF0ZSBp
cyBTVEFURV9SRUFEWSByZXR1cm4gMHgwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo3LTEx
MDgyMzE4LzVhYzY4ZTdjMzRhNDc5N2FhNGNhOTYxNWU1YTY2MDNiZGExYWJlOWIvZG1lc2ct
cXVhbnRhbC13YWltZWEtMTE6MjAxMzExMTEwNTQxNTM6aTM4Ni1yYW5kY29uZmlnLWo3LTEx
MDgyMzE4OjMuMTIuMC0wMDE4My1nNWFjNjhlNzo1MDgKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctajctMTEwODIzMTgvNWFjNjhlN2MzNGE0Nzk3YWE0Y2E5NjE1ZTVhNjYwM2JkYTFhYmU5
Yi9kbWVzZy1xdWFudGFsLXNuYi0yOjIwMTMxMTEwMjE0NTU5OmkzODYtcmFuZGNvbmZpZy1q
Ny0xMTA4MjMxODozLjEyLjAtMDAxODMtZzVhYzY4ZTc6NTA4Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWo3LTExMDgyMzE4LzVhYzY4ZTdjMzRhNDc5N2FhNGNhOTYxNWU1YTY2MDNiZGEx
YWJlOWIvZG1lc2ctcXVhbnRhbC1zbmItNDA6MjAxMzExMTAyMTQ1NTk6aTM4Ni1yYW5kY29u
ZmlnLWo3LTExMDgyMzE4OjMuMTIuMC0wMDE4My1nNWFjNjhlNzo1MDgKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctajctMTEwODIzMTgvNWFjNjhlN2MzNGE0Nzk3YWE0Y2E5NjE1ZTVhNjYw
M2JkYTFhYmU5Yi9kbWVzZy1xdWFudGFsLXhnd28tNDoyMDEzMTExMTA1NDIwODppMzg2LXJh
bmRjb25maWctajctMTEwODIzMTg6My4xMi4wLTAwMTgzLWc1YWM2OGU3OjUwOAowOjQ6NCBh
bGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtUkVQRUFUIENPVU5UOiAyMCAgIyAv
Y2Mvd2ZnL21tLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiA1IHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbZWQ0MjhiZmMzY2Fh
YTRiMWU2Y2QxNWVhMTJjOTBjMzAyOTE5MDNmMF0gbG9ja2luZzogTW92ZSB0aGUgcndzZW0g
Y29kZSB0byBrZXJuZWwvbG9ja2luZy8KcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9tbS9vYmotYmlzZWN0CmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctajctMTEwODIzMTgv
bmV4dDptYXN0ZXI6ZWQ0MjhiZmMzY2FhYTRiMWU2Y2QxNWVhMTJjOTBjMzAyOTE5MDNmMDpi
aXNlY3QtbW0KCjIwMTMtMTEtMTAtMjE6NDY6MTYgZWQ0MjhiZmMzY2FhYTRiMWU2Y2QxNWVh
MTJjOTBjMzAyOTE5MDNmMCBjb21waWxpbmcKNTU5IHJlYWwgIDI0ODcgdXNlciAgMjExIHN5
cyAgNDgyLjMyJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxOAoKMjAxMy0xMS0x
MC0yMTo1NzozNSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtMDAxNzctZ2VkNDI4YmYJ
OS4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0
ZXIgdGhpcyAocm91Z2hseSAyIHN0ZXBzKQpbODI3ZGE0NGM2MTQxOWYyOWFlM2JlMTk4YzM0
MmUyMTQ3ZjFhMTBjYl0gbmV0OiBFeHBsaWNpdGx5IGluaXRpYWxpemUgdTY0X3N0YXRzX3N5
bmMgc3RydWN0dXJlcyBmb3IgbG9ja2RlcApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tL29iai1iaXNlY3QKbHMgLWEg
L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMx
OC9uZXh0Om1hc3Rlcjo4MjdkYTQ0YzYxNDE5ZjI5YWUzYmUxOThjMzQyZTIxNDdmMWExMGNi
OmJpc2VjdC1tbQoKMjAxMy0xMS0xMC0yMTo1OTowOCA4MjdkYTQ0YzYxNDE5ZjI5YWUzYmUx
OThjMzQyZTIxNDdmMWExMGNiIGNvbXBpbGluZwo0NDkgcmVhbCAgODMzIHVzZXIgIDY4IHN5
cyAgMjAwLjY5JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxOAoKMjAxMy0xMS0x
MC0yMjowNzo1MCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtMDAxODAtZzgyN2RhNDQJ
MTMJMTUJMTgJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0ZXApCltkYjc1MWZlM2VhNjg4MGZmNWFjNWFi
ZTYwY2I3YjgwZGViNWE0MTQwXSBjcHVzZXQ6IEZpeCBwb3RlbnRpYWwgZGVhZGxvY2sgdy8g
c2V0X21lbXNfYWxsb3dlZApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10
ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxOC9uZXh0Om1h
c3RlcjpkYjc1MWZlM2VhNjg4MGZmNWFjNWFiZTYwY2I3YjgwZGViNWE0MTQwOmJpc2VjdC1t
bQoKMjAxMy0xMS0xMC0yMjowOTo1MiBkYjc1MWZlM2VhNjg4MGZmNWFjNWFiZTYwY2I3Yjgw
ZGViNWE0MTQwIGNvbXBpbGluZwo5MjQgcmVhbCAgMjUwOCB1c2VyICAyMTIgc3lzICAyOTQu
MDklIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWo3LTExMDgyMzE4CgoyMDEzLTExLTEwLTIyOjI1
OjUxIGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC0wMDE4Mi1nZGI3NTFmZS4gVEVTVCBG
QUlMVVJFClsgICAgMi4yODY2NzVdIGRldmljZSBpZCA9IDI0NDAKWyAgICAyLjI4NzMxMV0g
ZGV2aWNlIGlkID0gMjQ4MApbICAgIDIuMjg3ODg2XSBkZXZpY2UgaWQgPSAyNGMwClsgICAg
Mi4yODgzMDVdIElORk86IHRyeWluZyB0byByZWdpc3RlciBub24tc3RhdGljIGtleS4KWyAg
ICAyLjI4ODMwNl0gdGhlIGNvZGUgaXMgZmluZSBidXQgbmVlZHMgbG9ja2RlcCBhbm5vdGF0
aW9uLgpbICAgIDIuMjg4MzA3XSB0dXJuaW5nIG9mZiB0aGUgbG9ja2luZyBjb3JyZWN0bmVz
cyB2YWxpZGF0b3IuClsgICAgMi4yODgzMTBdIENQVTogMCBQSUQ6IDk2IENvbW06IGt3b3Jr
ZXIvdTQ6MSBOb3QgdGFpbnRlZCAzLjEyLjAtMDAxODItZ2RiNzUxZmUgIzUxMQpbICAgIDIu
Mjg4MzExXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8y
MDExClsgICAgMi4yODgzMjBdIFdvcmtxdWV1ZTogZXZlbnRzX3VuYm91bmQgYXN5bmNfcnVu
X2VudHJ5X2ZuClsgICAgMi4yODgzMjVdICA3ODI4ZGIzYSAwMDAwMDAwMCA3ZjNjMTk2OCA3
OGZhM2JiMiA3OTljOWEzYyA3ZjNjMTlhMCA3ODI4ODQ5MCA3OTM4NWM3ZApbICAgIDIuMjg4
MzI5XSAgNzkzODVjZDcgNzkzODVjYWQgN2YzODQ3MTggMDAwMDAwMDAgMDAwMDAwMTEgM2Mz
NDgwMTEgMDAwMGE3MDUgN2YzODQyMzAKWyAgICAyLjI4ODMzM10gIDdmMzg0MjMwIDg1YmYz
NTQwIDAwMDAwMDAwIDdmM2MxOWNjIDc4Mjg5MTE3IDAwMDAwMDAwIDAwMDAwMDAxIDAwMDAw
MDAwClsgICAgMi4yODgzMzRdIENhbGwgVHJhY2U6ClsgICAgMi4yODgzMzldICBbPDc4Mjhk
YjNhPl0gPyB2cHJpbnRrX2VtaXQrMHg0MjYvMHg0YTAKWyAgICAyLjI4ODM0NV0gIFs8Nzhm
YTNiYjI+XSBkdW1wX3N0YWNrKzB4NDgvMHg2MApbICAgIDIuMjg4MzQ4XSAgWzw3ODI4ODQ5
MD5dIF9fbG9ja19hY3F1aXJlLmlzcmEuMjYrMHg3ZWEvMHhjZjIKWyAgICAyLjI4ODM1MF0g
IFs8NzgyODkxMTc+XSBsb2NrX2FjcXVpcmUrMHg3MS8weDlhClsgICAgMi4yODgzNTVdICBb
PDc4NWZjYjA0Pl0gPyBibGtfdGhyb3RsX2JpbysweDFjMy8weDQ4NQpbICAgIDIuMjg4MzU3
XSAgWzw3ODVmYjZlNT5dIHRocm90bF91cGRhdGVfZGlzcGF0Y2hfc3RhdHMrMHg3Yy8weDE1
MwpbICAgIDIuMjg4MzYwXSAgWzw3ODVmY2IwND5dID8gYmxrX3Rocm90bF9iaW8rMHgxYzMv
MHg0ODUKWyAgICAyLjI4ODM2Ml0gIFs8Nzg1ZmNiMDQ+XSBibGtfdGhyb3RsX2JpbysweDFj
My8weDQ4NQpbICAgIDIuMjg4MzY1XSAgWzw3ODI3YjcwOT5dID8gc2NoZWRfY2xvY2tfbG9j
YWwrMHgxNy8weDEwNgpbICAgIDIuMjg4MzY4XSAgWzw3ODI3Yjk5Yj5dID8gc2NoZWRfY2xv
Y2tfY3B1KzB4MTA1LzB4MTEzClsgICAgMi4yODgzNzNdICBbPDc4NWViMGQyPl0gZ2VuZXJp
Y19tYWtlX3JlcXVlc3RfY2hlY2tzKzB4M2JiLzB4M2QyClsgICAgMi4yODgzNzVdICBbPDc4
MjdiOTliPl0gPyBzY2hlZF9jbG9ja19jcHUrMHgxMDUvMHgxMTMKWyAgICAyLjI4ODM3OF0g
IFs8Nzg1ZWM4Njc+XSBnZW5lcmljX21ha2VfcmVxdWVzdCsweGYvMHhiNQpbICAgIDIuMjg4
MzgwXSAgWzw3ODVlYzk3Mj5dIHN1Ym1pdF9iaW8rMHg2NS8weGQyClsgICAgMi4yODgzODRd
ICBbPDc4MzE0MWI5Pl0gX3N1Ym1pdF9iaCsweDIyNi8weDI0MwpbICAgIDIuMjg4Mzg3XSAg
Wzw3ODMxNDFlMD5dIHN1Ym1pdF9iaCsweGEvMHhjClsgICAgMi4yODgzODldICBbPDc4MzE1
MWI1Pl0gYmxvY2tfcmVhZF9mdWxsX3BhZ2UrMHgyYWEvMHgyYzUKWyAgICAyLjI4ODM5Ml0g
IFs8NzgzMTdlNTE+XSA/IGJpb19kaXJ0eV9mbisweDY4LzB4NjgKWyAgICAyLjI4ODM5N10g
IFs8NzgyYmRiZDQ+XSA/IGFkZF90b19wYWdlX2NhY2hlX2xvY2tlZCsweGI0LzB4ZTIKWyAg
ICAyLjI4ODM5OV0gIFs8NzgzMTgwZTc+XSA/IGJsa2Rldl93cml0ZV9iZWdpbisweDIwLzB4
MjAKWyAgICAyLjI4ODQwMl0gIFs8NzgzMTgwZTc+XSA/IGJsa2Rldl93cml0ZV9iZWdpbisw
eDIwLzB4MjAKWyAgICAyLjI4ODQwNF0gIFs8NzgzMTgwZjY+XSBibGtkZXZfcmVhZHBhZ2Ur
MHhmLzB4MTEKWyAgICAyLjI4ODQwN10gIFs8NzgyYmU3M2Y+XSBkb19yZWFkX2NhY2hlX3Bh
Z2UrMHg2ZS8weDExYgpbICAgIDIuMjg4NDA5XSAgWzw3ODJiZjQ0ZD5dIHJlYWRfY2FjaGVf
cGFnZV9hc3luYysweDE5LzB4MWUKWyAgICAyLjI4ODQxMl0gIFs8NzgzMTgwZTc+XSA/IGJs
a2Rldl93cml0ZV9iZWdpbisweDIwLzB4MjAKWyAgICAyLjI4ODQxNF0gIFs8NzgyYmY0N2U+
XSByZWFkX2NhY2hlX3BhZ2UrMHhiLzB4MTIKWyAgICAyLjI4ODQxN10gIFs8Nzg1ZjY4OTQ+
XSByZWFkX2Rldl9zZWN0b3IrMHgyNi8weDYxClsgICAgMi4yODg0MTldICBbPDc4NWY3MmUy
Pl0gcmVhZF9sYmErMHhhZS8weGY5ClsgICAgMi4yODg0MjNdICBbPDc4MmU0OGIxPl0gPyBr
bWVtX2NhY2hlX2FsbG9jKzB4ZjkvMHgxMmIKWyAgICAyLjI4ODQyNV0gIFs8Nzg1Zjc4MTI+
XSBlZmlfcGFydGl0aW9uKzB4MTdhLzB4OWMyClsgICAgMi4yODg0MzBdICBbPDc4NjBhOGZi
Pl0gPyBzdHJpbmcuaXNyYS40KzB4MjkvMHg5MwpbICAgIDIuMjg4NDMyXSAgWzw3ODYwYThm
Yj5dID8gc3RyaW5nLmlzcmEuNCsweDI5LzB4OTMKWyAgICAyLjI4ODQzNV0gIFs8Nzg2MGI2
YTA+XSA/IHZzbnByaW50ZisweDgxLzB4MjZmClsgICAgMi4yODg0MzhdICBbPDc4NjBiYjJk
Pl0gPyBzbnByaW50ZisweDE1LzB4MTcKWyAgICAyLjI4ODQ0MF0gIFs8Nzg1ZjY5Y2I+XSBj
aGVja19wYXJ0aXRpb24rMHhlNC8weDE3OApbICAgIDIuMjg4NDQyXSAgWzw3ODVmNjljYj5d
ID8gY2hlY2tfcGFydGl0aW9uKzB4ZTQvMHgxNzgKWyAgICAyLjI4ODQ0NV0gIFs8Nzg1ZjY2
MWQ+XSByZXNjYW5fcGFydGl0aW9ucysweDg5LzB4MjY3ClsgICAgMi4yODg0NDddICBbPDc4
MzE4MWRiPl0gPyBiZGV2X2lub2RlX3N3aXRjaF9iZGkrMHhkMi8weGU2ClsgICAgMi4yODg0
NTBdICBbPDc4MzE4ZjkyPl0gX19ibGtkZXZfZ2V0KzB4MTczLzB4MzYzClsgICAgMi4yODg0
NTJdICBbPDc4MzE5MWNkPl0gYmxrZGV2X2dldCsweDRiLzB4MjNkClsgICAgMi4yODg0NTRd
ICBbPDc4MzE4ODhiPl0gPyBiZGdldCsweGY4LzB4MTA1ClsgICAgMi4yODg0NTldICBbPDc4
OGFjMGNhPl0gPyBwdXRfZGV2aWNlKzB4Zi8weDExClsgICAgMi4yODg0NjFdICBbPDc4NWY0
NjcwPl0gYWRkX2Rpc2srMHgyNmIvMHgzYjUKWyAgICAyLjI4ODQ2NV0gIFs8Nzg4YjQxZTQ+
XSA/IF9fcG1fcnVudGltZV91c2VfYXV0b3N1c3BlbmQrMHg0YS8weDRmClsgICAgMi4yODg0
NjldICBbPDc4OWQwZjVkPl0gc2RfcHJvYmVfYXN5bmMrMHgxMTEvMHgxOTgKWyAgICAyLjI4
ODQ3MV0gIFs8NzgyNzRhODY+XSBhc3luY19ydW5fZW50cnlfZm4rMHg1OS8weGZmClsgICAg
Mi4yODg0NzZdICBbPDc4MjZiYzA4Pl0gcHJvY2Vzc19vbmVfd29yaysweDFlZi8weDM0OQpb
ICAgIDIuMjg4NDgwXSAgWzw3ODI2YmJhZj5dID8gcHJvY2Vzc19vbmVfd29yaysweDE5Ni8w
eDM0OQpbICAgIDIuMjg4NDgyXSAgWzw3ODI2YzE1OT5dIHdvcmtlcl90aHJlYWQrMHgxYTMv
MHgyNzQKWyAgICAyLjI4ODQ4NV0gIFs8NzgyNmJmYjY+XSA/IHJlc2N1ZXJfdGhyZWFkKzB4
MjMzLzB4MjMzClsgICAgMi4yODg0ODhdICBbPDc4MjcwNzY5Pl0ga3RocmVhZCsweDhhLzB4
OGYKWyAgICAyLjI4ODQ5MF0gIFs8NzgyNzAwMDA+XSA/IFN5U190aW1lcl9jcmVhdGUrMHgy
NjQvMHgzNDEKWyAgICAyLjI4ODQ5NF0gIFs8NzhmYjcwZmI+XSByZXRfZnJvbV9rZXJuZWxf
dGhyZWFkKzB4MWIvMHgzMApbICAgIDIuMjg4NDk2XSAgWzw3ODI3MDZkZj5dID8gX19rdGhy
ZWFkX3BhcmttZSsweDUwLzB4NTAKWyAgICAyLjI5MDA3OV0gIHNkYTogdW5rbm93biBwYXJ0
aXRpb24gdGFibGUKWyAgICAyLjI5NDExOF0gc2QgMDowOjA6MDogW3NkYV0gQXR0YWNoZWQg
U0NTSSBkaXNrClsgICAgMi4zNTYzNTFdIGRldmljZSBpZCA9IDI0ZDAKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctajctMTEwODIzMTgvZGI3NTFmZTNlYTY4ODBmZjVhYzVhYmU2MGNiN2I4
MGRlYjVhNDE0MC9kbWVzZy1xdWFudGFsLWxrcC10dDAyLTIyOjIwMTMxMTEwMTMxNzQxOmkz
ODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxODozLjEyLjAtMDAxODItZ2RiNzUxZmU6NTExCjA6
MToxIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW1SRVBFQVQgQ09VTlQ6IDIw
ICAjIC9jYy93ZmcvbW0tYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDAgcmV2aXNp
b25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDAgc3RlcHMpClsxY2E3ZDY3
Y2Y1ZDVhMmFlZjI2YThkOWFmZDc4OTAwNmZhMDk4MzQ3XSBzZXFjb3VudDogQWRkIGxvY2tk
ZXAgZnVuY3Rpb25hbGl0eSB0byBzZXFjb3VudC9zZXFsb2NrIHN0cnVjdHVyZXMKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dm
Zy9tbS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWctajctMTEwODIzMTgvbmV4dDptYXN0ZXI6MWNhN2Q2N2NmNWQ1YTJhZWYy
NmE4ZDlhZmQ3ODkwMDZmYTA5ODM0NzpiaXNlY3QtbW0KCjIwMTMtMTEtMTAtMjI6MjY6Mjgg
MWNhN2Q2N2NmNWQ1YTJhZWYyNmE4ZDlhZmQ3ODkwMDZmYTA5ODM0NyBjb21waWxpbmcKMzMg
cmVhbCAgNjMgdXNlciAgOSBzeXMgIDIyMC42NSUgY3B1IAlpMzg2LXJhbmRjb25maWctajct
MTEwODIzMTgKCjIwMTMtMTEtMTAtMjI6MzA6MzkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4x
Mi4wLTAwMTgxLWcxY2E3ZDY3LiBURVNUIEZBSUxVUkUKWyAgICAyLjc3MDk3MV0gcGFnZSBz
aXplOiA1MTIgYnl0ZXMKWyAgICAyLjc3MTUwMl0gT09CIGFyZWEgc2l6ZTogMTYgYnl0ZXMK
WyAgICAyLjc3MjA3M10gc2VjdG9yIHNpemU6IDE2IEtpQgpbICAgIDIuNzcyMjQ3XSBJTkZP
OiB0cnlpbmcgdG8gcmVnaXN0ZXIgbm9uLXN0YXRpYyBrZXkuClsgICAgMi43NzIyNDhdIHRo
ZSBjb2RlIGlzIGZpbmUgYnV0IG5lZWRzIGxvY2tkZXAgYW5ub3RhdGlvbi4KWyAgICAyLjc3
MjI0OF0gdHVybmluZyBvZmYgdGhlIGxvY2tpbmcgY29ycmVjdG5lc3MgdmFsaWRhdG9yLgpb
ICAgIDIuNzcyMjU3XSBDUFU6IDEgUElEOiA5NiBDb21tOiBrd29ya2VyL3U0OjEgTm90IHRh
aW50ZWQgMy4xMi4wLTAwMTgxLWcxY2E3ZDY3ICM1MTIKWyAgICAyLjc3MjI1OF0gSGFyZHdh
cmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDIuNzcy
Mjk3XSBXb3JrcXVldWU6IGV2ZW50c191bmJvdW5kIGFzeW5jX3J1bl9lbnRyeV9mbgpbICAg
IDIuNzcyMzAxXSAgNzgyOGRiM2EgMDAwMDAwMDAgN2YzY2Y5NjggNzhmYTNiYjIgNzk5Yzgy
NGMgN2YzY2Y5YTAgNzgyODg0OTAgNzkzODVjN2QKWyAgICAyLjc3MjMwNV0gIDc5Mzg1Y2Q3
IDc5Mzg1Y2FkIDdmM2Q3MzA4IDAwMDAwMDAwIDAwMDAwMDExIDQwMzVhMDExIDAwMDBhNzg1
IDdmM2Q2ZTIwClsgICAgMi43NzIzMDldICA3ZjNkNmUyMCA4NWQzZTU0MCAwMDAwMDAwMCA3
ZjNjZjljYyA3ODI4OTExNyAwMDAwMDAwMCAwMDAwMDAwMSAwMDAwMDAwMApbICAgIDIuNzcy
MzA5XSBDYWxsIFRyYWNlOgpbICAgIDIuNzcyMzIzXSAgWzw3ODI4ZGIzYT5dID8gdnByaW50
a19lbWl0KzB4NDI2LzB4NGEwClsgICAgMi43NzIzNThdICBbPDc4ZmEzYmIyPl0gZHVtcF9z
dGFjaysweDQ4LzB4NjAKWyAgICAyLjc3MjM2MV0gIFs8NzgyODg0OTA+XSBfX2xvY2tfYWNx
dWlyZS5pc3JhLjI2KzB4N2VhLzB4Y2YyClsgICAgMi43NzIzNjRdICBbPDc4Mjg5MTE3Pl0g
bG9ja19hY3F1aXJlKzB4NzEvMHg5YQpbICAgIDIuNzcyMzc4XSAgWzw3ODVmY2IwND5dID8g
YmxrX3Rocm90bF9iaW8rMHgxYzMvMHg0ODUKWyAgICAyLjc3MjM4MV0gIFs8Nzg1ZmI2ZTU+
XSB0aHJvdGxfdXBkYXRlX2Rpc3BhdGNoX3N0YXRzKzB4N2MvMHgxNTMKWyAgICAyLjc3MjM4
M10gIFs8Nzg1ZmNiMDQ+XSA/IGJsa190aHJvdGxfYmlvKzB4MWMzLzB4NDg1ClsgICAgMi43
NzIzODVdICBbPDc4NWZjYjA0Pl0gYmxrX3Rocm90bF9iaW8rMHgxYzMvMHg0ODUKWyAgICAy
Ljc3MjM4OF0gIFs8NzgyN2I3MDk+XSA/IHNjaGVkX2Nsb2NrX2xvY2FsKzB4MTcvMHgxMDYK
WyAgICAyLjc3MjM5MF0gIFs8NzgyN2I5OWI+XSA/IHNjaGVkX2Nsb2NrX2NwdSsweDEwNS8w
eDExMwpbICAgIDIuNzcyMzk1XSAgWzw3ODVlYjBkMj5dIGdlbmVyaWNfbWFrZV9yZXF1ZXN0
X2NoZWNrcysweDNiYi8weDNkMgpbICAgIDIuNzcyMzk3XSAgWzw3ODI3Yjk5Yj5dID8gc2No
ZWRfY2xvY2tfY3B1KzB4MTA1LzB4MTEzClsgICAgMi43NzI0MDBdICBbPDc4NWVjODY3Pl0g
Z2VuZXJpY19tYWtlX3JlcXVlc3QrMHhmLzB4YjUKWyAgICAyLjc3MjQwMl0gIFs8Nzg1ZWM5
NzI+XSBzdWJtaXRfYmlvKzB4NjUvMHhkMgpbICAgIDIuNzcyNDEyXSAgWzw3ODMxNDFiOT5d
IF9zdWJtaXRfYmgrMHgyMjYvMHgyNDMKWyAgICAyLjc3MjQxNF0gIFs8NzgzMTQxZTA+XSBz
dWJtaXRfYmgrMHhhLzB4YwpbICAgIDIuNzcyNDE2XSAgWzw3ODMxNTFiNT5dIGJsb2NrX3Jl
YWRfZnVsbF9wYWdlKzB4MmFhLzB4MmM1ClsgICAgMi43NzI0MTldICBbPDc4MzE3ZTUxPl0g
PyBiaW9fZGlydHlfZm4rMHg2OC8weDY4ClsgICAgMi43NzI0MjZdICBbPDc4MmJkYmQ0Pl0g
PyBhZGRfdG9fcGFnZV9jYWNoZV9sb2NrZWQrMHhiNC8weGUyClsgICAgMi43NzI0MjldICBb
PDc4MzE4MGU3Pl0gPyBibGtkZXZfd3JpdGVfYmVnaW4rMHgyMC8weDIwClsgICAgMi43NzI0
MzFdICBbPDc4MzE4MGU3Pl0gPyBibGtkZXZfd3JpdGVfYmVnaW4rMHgyMC8weDIwClsgICAg
Mi43NzI0MzRdICBbPDc4MzE4MGY2Pl0gYmxrZGV2X3JlYWRwYWdlKzB4Zi8weDExClsgICAg
Mi43NzI0MzldICBbPDc4MmJlNzNmPl0gZG9fcmVhZF9jYWNoZV9wYWdlKzB4NmUvMHgxMWIK
WyAgICAyLjc3MjQ0Ml0gIFs8NzgyYmY0NGQ+XSByZWFkX2NhY2hlX3BhZ2VfYXN5bmMrMHgx
OS8weDFlClsgICAgMi43NzI0NDRdICBbPDc4MzE4MGU3Pl0gPyBibGtkZXZfd3JpdGVfYmVn
aW4rMHgyMC8weDIwClsgICAgMi43NzI0NDZdICBbPDc4MmJmNDdlPl0gcmVhZF9jYWNoZV9w
YWdlKzB4Yi8weDEyClsgICAgMi43NzI0NDhdICBbPDc4NWY2ODk0Pl0gcmVhZF9kZXZfc2Vj
dG9yKzB4MjYvMHg2MQpbICAgIDIuNzcyNDUwXSAgWzw3ODVmNzJlMj5dIHJlYWRfbGJhKzB4
YWUvMHhmOQpbICAgIDIuNzcyNDYwXSAgWzw3ODJlNDhiMT5dID8ga21lbV9jYWNoZV9hbGxv
YysweGY5LzB4MTJiClsgICAgMi43NzI0NjJdICBbPDc4NWY3ODEyPl0gZWZpX3BhcnRpdGlv
bisweDE3YS8weDljMgpbICAgIDIuNzcyNDY1XSAgWzw3ODJjM2ExNz5dID8gX19hbGxvY19w
YWdlc19ub2RlbWFzaysweGUzLzB4NjFlClsgICAgMi43NzI0NzJdICBbPDc4NjBhOGZiPl0g
PyBzdHJpbmcuaXNyYS40KzB4MjkvMHg5MwpbICAgIDIuNzcyNDc0XSAgWzw3ODYwYThmYj5d
ID8gc3RyaW5nLmlzcmEuNCsweDI5LzB4OTMKWyAgICAyLjc3MjQ3N10gIFs8Nzg2MGI2YTA+
XSA/IHZzbnByaW50ZisweDgxLzB4MjZmClsgICAgMi43NzI0NzldICBbPDc4NjBiYjJkPl0g
PyBzbnByaW50ZisweDE1LzB4MTcKWyAgICAyLjc3MjQ4MV0gIFs8Nzg1ZjY5Y2I+XSBjaGVj
a19wYXJ0aXRpb24rMHhlNC8weDE3OApbICAgIDIuNzcyNDgzXSAgWzw3ODVmNjljYj5dID8g
Y2hlY2tfcGFydGl0aW9uKzB4ZTQvMHgxNzgKWyAgICAyLjc3MjQ4NV0gIFs8Nzg1ZjY2MWQ+
XSByZXNjYW5fcGFydGl0aW9ucysweDg5LzB4MjY3ClsgICAgMi43NzI0ODddICBbPDc4MzE4
MWRiPl0gPyBiZGV2X2lub2RlX3N3aXRjaF9iZGkrMHhkMi8weGU2ClsgICAgMi43NzI0OTBd
ICBbPDc4MzE4ZjkyPl0gX19ibGtkZXZfZ2V0KzB4MTczLzB4MzYzClsgICAgMi43NzI0OTJd
ICBbPDc4MzE5MWNkPl0gYmxrZGV2X2dldCsweDRiLzB4MjNkClsgICAgMi43NzI0OTRdICBb
PDc4MzE4ODhiPl0gPyBiZGdldCsweGY4LzB4MTA1ClsgICAgMi43NzI1MTNdICBbPDc4OGFj
MGNhPl0gPyBwdXRfZGV2aWNlKzB4Zi8weDExClsgICAgMi43NzI1MTVdICBbPDc4NWY0Njcw
Pl0gYWRkX2Rpc2srMHgyNmIvMHgzYjUKWyAgICAyLjc3MjUyMV0gIFs8Nzg4YjQxZTQ+XSA/
IF9fcG1fcnVudGltZV91c2VfYXV0b3N1c3BlbmQrMHg0YS8weDRmClsgICAgMi43NzI1Mjld
ICBbPDc4OWQwZjVkPl0gc2RfcHJvYmVfYXN5bmMrMHgxMTEvMHgxOTgKWyAgICAyLjc3MjUz
Ml0gIFs8NzgyNzRhODY+XSBhc3luY19ydW5fZW50cnlfZm4rMHg1OS8weGZmClsgICAgMi43
NzI1MzZdICBbPDc4MjZiYzA4Pl0gcHJvY2Vzc19vbmVfd29yaysweDFlZi8weDM0OQpbICAg
IDIuNzcyNTQyXSAgWzw3ODI2YmJhZj5dID8gcHJvY2Vzc19vbmVfd29yaysweDE5Ni8weDM0
OQpbICAgIDIuNzcyNTQ1XSAgWzw3ODI2YzE1OT5dIHdvcmtlcl90aHJlYWQrMHgxYTMvMHgy
NzQKWyAgICAyLjc3MjU0N10gIFs8NzgyNmJmYjY+XSA/IHJlc2N1ZXJfdGhyZWFkKzB4MjMz
LzB4MjMzClsgICAgMi43NzI1NDldICBbPDc4MjcwNzY5Pl0ga3RocmVhZCsweDhhLzB4OGYK
WyAgICAyLjc3MjU1Ml0gIFs8NzgyNzAwMDA+XSA/IFN5U190aW1lcl9jcmVhdGUrMHgyNjQv
MHgzNDEKWyAgICAyLjc3MjU1OF0gIFs8NzhmYjcwZmI+XSByZXRfZnJvbV9rZXJuZWxfdGhy
ZWFkKzB4MWIvMHgzMApbICAgIDIuNzcyNTYxXSAgWzw3ODI3MDZkZj5dID8gX19rdGhyZWFk
X3BhcmttZSsweDUwLzB4NTAKWyAgICAyLjgyNTU5MF0gcGFnZXMgbnVtYmVyOiAyNjIxNDQK
WyAgICAyLjgyNjEyM10gcGFnZXMgcGVyIHNlY3RvcjogMzIKWyAgICAyLjgyNjYzNV0gYnVz
IHdpZHRoOiA4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo3LTExMDgyMzE4LzFjYTdkNjdj
ZjVkNWEyYWVmMjZhOGQ5YWZkNzg5MDA2ZmEwOTgzNDcvZG1lc2ctcXVhbnRhbC1iZW5zLTI6
MjAxMzExMTAyMjMxMDM6aTM4Ni1yYW5kY29uZmlnLWo3LTExMDgyMzE4OjMuMTIuMC0wMDE4
MS1nMWNhN2Q2Nzo1MTIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajctMTEwODIzMTgvMWNh
N2Q2N2NmNWQ1YTJhZWYyNmE4ZDlhZmQ3ODkwMDZmYTA5ODM0Ny9kbWVzZy1xdWFudGFsLWxr
cC10dDAyLTEwOjIwMTMxMTEwMTMyMjMwOmkzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxODoz
LjEyLjAtMDAxODEtZzFjYTdkNjc6NTEyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo3LTEx
MDgyMzE4LzFjYTdkNjdjZjVkNWEyYWVmMjZhOGQ5YWZkNzg5MDA2ZmEwOTgzNDcvZG1lc2ct
cXVhbnRhbC1zdG9ha2xleS0zOjIwMTMxMTEwMjIzMTAxOmkzODYtcmFuZGNvbmZpZy1qNy0x
MTA4MjMxODozLjEyLjAtMDAxODEtZzFjYTdkNjc6NTEyCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWo3LTExMDgyMzE4LzFjYTdkNjdjZjVkNWEyYWVmMjZhOGQ5YWZkNzg5MDA2ZmEwOTgz
NDcvZG1lc2ctcXVhbnRhbC1zdG9ha2xleS01OjIwMTMxMTEwMjIzMTAwOmkzODYtcmFuZGNv
bmZpZy1qNy0xMTA4MjMxODozLjEyLjAtMDAxODEtZzFjYTdkNjc6NTEyCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWo3LTExMDgyMzE4LzFjYTdkNjdjZjVkNWEyYWVmMjZhOGQ5YWZkNzg5
MDA2ZmEwOTgzNDcvZG1lc2ctcXVhbnRhbC13YWltZWEtNToyMDEzMTExMTA2MjcwODppMzg2
LXJhbmRjb25maWctajctMTEwODIzMTg6My4xMi4wLTAwMTgxLWcxY2E3ZDY3OjUxMgova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxOC8xY2E3ZDY3Y2Y1ZDVhMmFlZjI2YThk
OWFmZDc4OTAwNmZhMDk4MzQ3L2RtZXNnLXF1YW50YWwteGd3by0zOjIwMTMxMTExMDYyNzE2
OmkzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxODozLjEyLjAtMDAxODEtZzFjYTdkNjc6NTEy
CjA6Njo2IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW1SRVBFQVQgQ09VTlQ6
IDIwICAjIC9jYy93ZmcvbW0tYmlzZWN0Ly5yZXBlYXQbWzBtCgoxY2E3ZDY3Y2Y1ZDVhMmFl
ZjI2YThkOWFmZDc4OTAwNmZhMDk4MzQ3IGlzIHRoZSBmaXJzdCBiYWQgY29tbWl0CmNvbW1p
dCAxY2E3ZDY3Y2Y1ZDVhMmFlZjI2YThkOWFmZDc4OTAwNmZhMDk4MzQ3CkF1dGhvcjogSm9o
biBTdHVsdHogPGpvaG4uc3R1bHR6QGxpbmFyby5vcmc+CkRhdGU6ICAgTW9uIE9jdCA3IDE1
OjUxOjU5IDIwMTMgLTA3MDAKCiAgICBzZXFjb3VudDogQWRkIGxvY2tkZXAgZnVuY3Rpb25h
bGl0eSB0byBzZXFjb3VudC9zZXFsb2NrIHN0cnVjdHVyZXMKICAgIAogICAgQ3VycmVudGx5
IHNlcWxvY2tzIGFuZCBzZXFjb3VudHMgZG9uJ3Qgc3VwcG9ydCBsb2NrZGVwLgogICAgCiAg
ICBBZnRlciBydW5uaW5nIGFjcm9zcyBhIHNlcWNvdW50IHJlbGF0ZWQgZGVhZGxvY2sgaW4g
dGhlIHRpbWVrZWVwaW5nCiAgICBjb2RlLCBJIHVzZWQgYSBsZXNzLXJlZmluZWQgYW5kIG1v
cmUgZm9jdXNlZCB2YXJpYW50IG9mIHRoaXMgcGF0Y2gKICAgIHRvIG5hcnJvdyBkb3duIHRo
ZSBjYXVzZSBvZiB0aGUgaXNzdWUuCiAgICAKICAgIFRoaXMgaXMgYSBmaXJzdC1wYXNzIGF0
dGVtcHQgdG8gcHJvcGVybHkgZW5hYmxlIGxvY2tkZXAgZnVuY3Rpb25hbGl0eQogICAgb24g
c2VxbG9ja3MgYW5kIHNlcWNvdW50cy4KICAgIAogICAgU2luY2Ugc2VxY291bnRzIGFyZSB1
c2VkIGluIHRoZSB2ZHNvIGdldHRpbWVvZmRheSBjb2RlLCBJJ3ZlIHByb3ZpZGVkCiAgICBu
b24tbG9ja2RlcCBhY2Nlc3NvcnMgZm9yIHRob3NlIG5lZWRzLgogICAgCiAgICBJJ3ZlIGFs
c28gaGFuZGxlZCBvbmUgY2FzZSB3aGVyZSB0aGVyZSB3ZXJlIG5lc3RlZCBzZXFsb2NrIHdy
aXRlcnMKICAgIGFuZCB0aGVyZSBtYXkgYmUgbW9yZSBlZGdlIGNhc2VzLgogICAgCiAgICBD
b21tZW50cyBhbmQgZmVlZGJhY2sgd291bGQgYmUgYXBwcmVjaWF0ZWQhCiAgICAKICAgIFNp
Z25lZC1vZmYtYnk6IEpvaG4gU3R1bHR6IDxqb2huLnN0dWx0ekBsaW5hcm8ub3JnPgogICAg
U2lnbmVkLW9mZi1ieTogUGV0ZXIgWmlqbHN0cmEgPHBldGVyekBpbmZyYWRlYWQub3JnPgog
ICAgQ2M6IEVyaWMgRHVtYXpldCA8ZXJpYy5kdW1hemV0QGdtYWlsLmNvbT4KICAgIENjOiBM
aSBaZWZhbiA8bGl6ZWZhbkBodWF3ZWkuY29tPgogICAgQ2M6IE1hdGhpZXUgRGVzbm95ZXJz
IDxtYXRoaWV1LmRlc25veWVyc0BlZmZpY2lvcy5jb20+CiAgICBDYzogU3RldmVuIFJvc3Rl
ZHQgPHJvc3RlZHRAZ29vZG1pcy5vcmc+CiAgICBDYzogIkRhdmlkIFMuIE1pbGxlciIgPGRh
dmVtQGRhdmVtbG9mdC5uZXQ+CiAgICBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZwogICAg
TGluazogaHR0cDovL2xrbWwua2VybmVsLm9yZy9yLzEzODExODYzMjEtNDkwNi0zLWdpdC1z
ZW5kLWVtYWlsLWpvaG4uc3R1bHR6QGxpbmFyby5vcmcKICAgIFNpZ25lZC1vZmYtYnk6IElu
Z28gTW9sbmFyIDxtaW5nb0BrZXJuZWwub3JnPgoKOjA0MDAwMCAwNDAwMDAgY2ZlZTlkNTZk
YWM5MTkyZTFmZjQ1YTBiYjFkZmI5NTNjODc3OThhOCBjOTliMzkyMWI2MWJlMmJhYzdkZTk2
YmRjNjhmYTRhM2VjYmU3ZGVkIE0JYXJjaAo6MDQwMDAwIDA0MDAwMCA5ZGVkNGU4Y2M5NzFh
NzY4NDg4YWIwMDQxOTYyYzFmMmVkYzE1OTI3IDlmYjQwYTU0N2Y4MDNjZDM2Y2NhZGI4ZjJj
MDMzMTFjYmVlMDIxYjUgTQlmcwo6MDQwMDAwIDA0MDAwMCA3MTU1NzIwMzlkODllYzNjNWE2
MWVlOTZlMmI4MDU4MjkxYjM5ZDBhIDY4MmY0MDIzMzY5Y2U2MjJiNjZmZmI2YTdhM2UwZDdi
NDc4YTZjNTEgTQlpbmNsdWRlCjowNDAwMDAgMDQwMDAwIGZkZGZiNWUzYzg2YmI5MzBiZGI5
NzkxODViMDU5OTA0YTQ2OWI5MTkgOGRkNzA1MjBhZWJhYzRmN2FiYWVhZjQwYThkZmVkYmJl
ZTAwMjlhYSBNCW1tCmJpc2VjdCBydW4gc3VjY2VzcwpscyAtYSAva2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWo3LTExMDgyMzE4L25leHQ6bWFzdGVyOjgy
N2RhNDRjNjE0MTlmMjlhZTNiZTE5OGMzNDJlMjE0N2YxYTEwY2I6YmlzZWN0LW1tCgoyMDEz
LTExLTEwLTIyOjMxOjIxIDgyN2RhNDRjNjE0MTlmMjlhZTNiZTE5OGMzNDJlMjE0N2YxYTEw
Y2IgcmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajctMTEwODIzMTgvODI3ZGE0NGM2
MTQxOWYyOWFlM2JlMTk4YzM0MmUyMTQ3ZjFhMTBjYi92bWxpbnV6LTMuMTIuMC0wMDE4MC1n
ODI3ZGE0NAoKMjAxMy0xMS0xMC0yMjozMToyMiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMjQJ
MzgJNDIJNTgJNjAgU1VDQ0VTUwoKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3Zt
L2kzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxOC9uZXh0Om1hc3RlcjpiYWQ1NzBkNzcwMjRj
YmE4MDgxMjZkNjhhMjA3MmY2ZjhjZTY0YzI3OmJpc2VjdC1tbQogVEVTVCBGQUlMVVJFClsg
ICAgNC4wNTAwOTVdIGUxMDAwOiBJbnRlbChSKSBQUk8vMTAwMCBOZXR3b3JrIERyaXZlciAt
IHZlcnNpb24gNy4zLjIxLWs4LU5BUEkKWyAgICA0LjA1MTIwOF0gZTEwMDA6IENvcHlyaWdo
dCAoYykgMTk5OS0yMDA2IEludGVsIENvcnBvcmF0aW9uLgpbICAgIDQuMDU0NzY1XSBzZCAw
OjA6MDowOiBbc2RhXSBXcml0ZSBjYWNoZTogZW5hYmxlZCwgcmVhZCBjYWNoZTogZW5hYmxl
ZCwgc3VwcG9ydHMgRFBPIGFuZCBGVUEKWyAgICA0LjA2MTI3Ml0gSU5GTzogdHJ5aW5nIHRv
IHJlZ2lzdGVyIG5vbi1zdGF0aWMga2V5LgpbICAgIDQuMDYyMDM2XSB0aGUgY29kZSBpcyBm
aW5lIGJ1dCBuZWVkcyBsb2NrZGVwIGFubm90YXRpb24uClsgICAgNC4wNjIwMzZdIHR1cm5p
bmcgb2ZmIHRoZSBsb2NraW5nIGNvcnJlY3RuZXNzIHZhbGlkYXRvci4KWyAgICA0LjA2MjAz
Nl0gQ1BVOiAxIFBJRDogOTYgQ29tbToga3dvcmtlci91NDoxIE5vdCB0YWludGVkIDMuMTIu
MC1uZXh0LTIwMTMxMTA4LTEwNjAxLWdiYWQ1NzBkICMyClsgICAgNC4wNjIwMzZdIEhhcmR3
YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICA0LjA2
MjAzNl0gV29ya3F1ZXVlOiBldmVudHNfdW5ib3VuZCBhc3luY19ydW5fZW50cnlfZm4KWyAg
ICA0LjA2MjAzNl0gIDgwODhlNzQ0IDAwMDAwMDAwIDdkM2IxOTY4IDgxNWM3Y2YyIDgyMDBj
OGI4IDdkM2IxOWEwIDgwODg5NTNlIDgxOWI3ZjRkClsgICAgNC4wNjIwMzZdICA4MTliN2Zh
NyA4MTliN2Y3ZCA3ZDM5NjUwOCAwMDAwMDAwMCAwMDAwMDAxMSA1MDM3NjAxMSAwMDAwYTkw
NSA3ZDM5NjAxMApbICAgIDQuMDYyMDM2XSAgN2QzOTYwMTAgODVkM2RhNzAgMDAwMDAwMDAg
N2QzYjE5Y2MgODA4OGExYzUgMDAwMDAwMDAgMDAwMDAwMDEgMDAwMDAwMDAKWyAgICA0LjA2
MjAzNl0gQ2FsbCBUcmFjZToKWyAgICA0LjA2MjAzNl0gIFs8ODA4OGU3NDQ+XSA/IGNvbnNv
bGVfdW5sb2NrKzB4MzUzLzB4MzgwClsgICAgNC4wNjIwMzZdICBbPDgxNWM3Y2YyPl0gZHVt
cF9zdGFjaysweDQ4LzB4NjAKWyAgICA0LjA2MjAzNl0gIFs8ODA4ODk1M2U+XSBfX2xvY2tf
YWNxdWlyZS5pc3JhLjI2KzB4N2UzLzB4Y2ViClsgICAgNC4wNjIwMzZdICBbPDgwODhhMWM1
Pl0gbG9ja19hY3F1aXJlKzB4NzEvMHg5YQpbICAgIDQuMDYyMDM2XSAgWzw4MGMwNzlhYT5d
ID8gYmxrX3Rocm90bF9iaW8rMHgxYzMvMHg0ODUKWyAgICA0LjA2MjAzNl0gIFs8ODBjMDY1
OGI+XSB0aHJvdGxfdXBkYXRlX2Rpc3BhdGNoX3N0YXRzKzB4N2MvMHgxNTMKWyAgICA0LjA2
MjAzNl0gIFs8ODBjMDc5YWE+XSA/IGJsa190aHJvdGxfYmlvKzB4MWMzLzB4NDg1ClsgICAg
NC4wNjIwMzZdICBbPDgwYzA3OWFhPl0gYmxrX3Rocm90bF9iaW8rMHgxYzMvMHg0ODUKWyAg
ICA0LjA2MjAzNl0gIFs8ODA4N2M3Zjk+XSA/IHNjaGVkX2Nsb2NrX2xvY2FsKzB4MTcvMHgx
MDYKWyAgICA0LjA2MjAzNl0gIFs8ODA4N2NhOGI+XSA/IHNjaGVkX2Nsb2NrX2NwdSsweDEw
NS8weDExMwpbICAgIDQuMDYyMDM2XSAgWzw4MGJmMmZlZT5dIGdlbmVyaWNfbWFrZV9yZXF1
ZXN0X2NoZWNrcysweDNjYS8weDNlMQpbICAgIDQuMDYyMDM2XSAgWzw4MDg3Y2E4Yj5dID8g
c2NoZWRfY2xvY2tfY3B1KzB4MTA1LzB4MTEzClsgICAgNC4wNjIwMzZdICBbPDgwYmY0NjEz
Pl0gZ2VuZXJpY19tYWtlX3JlcXVlc3QrMHhmLzB4YjAKWyAgICA0LjA2MjAzNl0gIFs8ODBi
ZjQ3MjM+XSBzdWJtaXRfYmlvKzB4NmYvMHhkOApbICAgIDQuMDYyMDM2XSAgWzw4MDkxNjY5
NT5dIF9zdWJtaXRfYmgrMHgyMjgvMHgyNDUKWyAgICA0LjA2MjAzNl0gIFs8ODA5MTY2YmM+
XSBzdWJtaXRfYmgrMHhhLzB4YwpbICAgIDQuMDYyMDM2XSAgWzw4MDkxNzY4ZT5dIGJsb2Nr
X3JlYWRfZnVsbF9wYWdlKzB4MmE4LzB4MmMzClsgICAgNC4wNjIwMzZdICBbPDgwOTFhNTU1
Pl0gPyBiaW9fZGlydHlfZm4rMHg2Zi8weDZmClsgICAgNC4wNjIwMzZdICBbPDgwOGJlZDBj
Pl0gPyBhZGRfdG9fcGFnZV9jYWNoZV9sb2NrZWQrMHhiNC8weGUyClsgICAgNC4wNjIwMzZd
ICBbPDgwOTFhN2ViPl0gPyBibGtkZXZfd3JpdGVfYmVnaW4rMHgyMC8weDIwClsgICAgNC4w
NjIwMzZdICBbPDgwOTFhN2ViPl0gPyBibGtkZXZfd3JpdGVfYmVnaW4rMHgyMC8weDIwClsg
ICAgNC4wNjIwMzZdICBbPDgwOTFhN2ZhPl0gYmxrZGV2X3JlYWRwYWdlKzB4Zi8weDExClsg
ICAgNC4wNjIwMzZdICBbPDgwOGJmODc3Pl0gZG9fcmVhZF9jYWNoZV9wYWdlKzB4NmUvMHgx
MWIKWyAgICA0LjA2MjAzNl0gIFs8ODA4YzA2NDk+XSByZWFkX2NhY2hlX3BhZ2VfYXN5bmMr
MHgxOS8weDFlClsgICAgNC4wNjIwMzZdICBbPDgwOTFhN2ViPl0gPyBibGtkZXZfd3JpdGVf
YmVnaW4rMHgyMC8weDIwClsgICAgNC4wNjIwMzZdICBbPDgwOGMwNjdhPl0gcmVhZF9jYWNo
ZV9wYWdlKzB4Yi8weDEyClsgICAgNC4wNjIwMzZdICBbPDgwYzAxNzBkPl0gcmVhZF9kZXZf
c2VjdG9yKzB4MjYvMHg2MQpbICAgIDQuMDYyMDM2XSAgWzw4MGMwMjE1Yj5dIHJlYWRfbGJh
KzB4YWUvMHhmOQpbICAgIDQuMDYyMDM2XSAgWzw4MDhlNjBiNj5dID8ga21lbV9jYWNoZV9h
bGxvYysweGY5LzB4MTJiClsgICAgNC4wNjIwMzZdICBbPDgwYzAyNjhiPl0gZWZpX3BhcnRp
dGlvbisweDE3YS8weDljMApbICAgIDQuMDYyMDM2XSAgWzw4MDhjNGM0Zj5dID8gX19hbGxv
Y19wYWdlc19ub2RlbWFzaysweGUzLzB4NjFlClsgICAgNC4wNjIwMzZdICBbPDgwYzE1ODQ5
Pl0gPyBzdHJpbmcuaXNyYS40KzB4MjkvMHg5MwpbICAgIDQuMDYyMDM2XSAgWzw4MGMxNTg0
OT5dID8gc3RyaW5nLmlzcmEuNCsweDI5LzB4OTMKWyAgICA0LjA2MjAzNl0gIFs8ODBjMTY1
ZTk+XSA/IHZzbnByaW50ZisweDgxLzB4MjhiClsgICAgNC4wNjIwMzZdICBbPDgwYzE2YWIy
Pl0gPyBzbnByaW50ZisweDE1LzB4MTcKWyAgICA0LjA2MjAzNl0gIFs8ODBjMDE4NDQ+XSBj
aGVja19wYXJ0aXRpb24rMHhlNC8weDE3OApbICAgIDQuMDYyMDM2XSAgWzw4MGMwMTg0ND5d
ID8gY2hlY2tfcGFydGl0aW9uKzB4ZTQvMHgxNzgKWyAgICA0LjA2MjAzNl0gIFs8ODBjMDE0
OTY+XSByZXNjYW5fcGFydGl0aW9ucysweDg5LzB4MjY3ClsgICAgNC4wNjIwMzZdICBbPDgw
OTFhOGRmPl0gPyBiZGV2X2lub2RlX3N3aXRjaF9iZGkrMHhkMi8weGU2ClsgICAgNC4wNjIw
MzZdICBbPDgwOTFiNjk2Pl0gX19ibGtkZXZfZ2V0KzB4MTczLzB4MzYzClsgICAgNC4wNjIw
MzZdICBbPDgwOTFiOGQxPl0gYmxrZGV2X2dldCsweDRiLzB4MjNkClsgICAgNC4wNjIwMzZd
ICBbPDgwOTFhZjhmPl0gPyBiZGdldCsweGY4LzB4MTA1ClsgICAgNC4wNjIwMzZdICBbPDgw
ZWJjNmM1Pl0gPyBwdXRfZGV2aWNlKzB4Zi8weDExClsgICAgNC4wNjIwMzZdICBbPDgwYmZm
NGM5Pl0gYWRkX2Rpc2srMHgyNmIvMHgzYjUKWyAgICA0LjA2MjAzNl0gIFs8ODBlYzQ1OTk+
XSA/IF9fcG1fcnVudGltZV91c2VfYXV0b3N1c3BlbmQrMHg0YS8weDRmClsgICAgNC4wNjIw
MzZdICBbPDgwZmU0ZDczPl0gc2RfcHJvYmVfYXN5bmMrMHgxMTEvMHgxOTgKWyAgICA0LjA2
MjAzNl0gIFs8ODA4NzViMGE+XSBhc3luY19ydW5fZW50cnlfZm4rMHg1OS8weGZmClsgICAg
NC4wNjIwMzZdICBbPDgwODZjYjU0Pl0gcHJvY2Vzc19vbmVfd29yaysweDFlZi8weDM0OQpb
ICAgIDQuMDYyMDM2XSAgWzw4MDg2Y2FmYj5dID8gcHJvY2Vzc19vbmVfd29yaysweDE5Ni8w
eDM0OQpbICAgIDQuMDYyMDM2XSAgWzw4MDg2ZDBhNT5dIHdvcmtlcl90aHJlYWQrMHgxYTMv
MHgyNzQKWyAgICA0LjA2MjAzNl0gIFs8ODA4NmNmMDI+XSA/IHJlc2N1ZXJfdGhyZWFkKzB4
MjMzLzB4MjMzClsgICAgNC4wNjIwMzZdICBbPDgwODcxNzY3Pl0ga3RocmVhZCsweGE1LzB4
YWEKWyAgICA0LjA2MjAzNl0gIFs8ODA4NzAwMDA+XSA/IG1heWJlX2tmcmVlX3BhcmFtZXRl
cisweGMvMHgzZApbICAgIDQuMDYyMDM2XSAgWzw4MTVkYjZiYj5dIHJldF9mcm9tX2tlcm5l
bF90aHJlYWQrMHgxYi8weDMwClsgICAgNC4wNjIwMzZdICBbPDgwODcxNmMyPl0gPyBfX2t0
aHJlYWRfcGFya21lKzB4NTAvMHg1MApbICAgIDQuMTE4MDU2XSAgc2RhOiB1bmtub3duIHBh
cnRpdGlvbiB0YWJsZQpbICAgIDQuMTI2MDc5XSBzZCAwOjA6MDowOiBbc2RhXSBBdHRhY2hl
ZCBTQ1NJIGRpc2sKWyAgICA0LjQ1MDMxNV0gZTEwMDAgMDAwMDowMDowMy4wIGV0aDA6IChQ
Q0k6MzNNSHo6MzItYml0KSA1Mjo1NDowMDoxMjozNDo1Ngova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1qNy0xMTA4MjMxOC9iYWQ1NzBkNzcwMjRjYmE4MDgxMjZkNjhhMjA3MmY2ZjhjZTY0
YzI3L2RtZXNnLXF1YW50YWwtbGtwLXR0MDItMTk6MjAxMzExMTAwOTIzNDI6aTM4Ni1yYW5k
Y29uZmlnLWo3LTExMDgyMzE4OjMuMTIuMC1uZXh0LTIwMTMxMTA4LTEwNjAxLWdiYWQ1NzBk
OjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajctMTEwODIzMTgvYmFkNTcwZDc3MDI0Y2Jh
ODA4MTI2ZDY4YTIwNzJmNmY4Y2U2NGMyNy9kbWVzZy1xdWFudGFsLXJvYW0tNzoyMDEzMTEw
OTAyMjczMjppMzg2LXJhbmRjb25maWctajctMTEwODIzMTg6My4xMi4wLW5leHQtMjAxMzEx
MDgtMTA2MDEtZ2JhZDU3MGQ6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMx
OC9iYWQ1NzBkNzcwMjRjYmE4MDgxMjZkNjhhMjA3MmY2ZjhjZTY0YzI3L2RtZXNnLXF1YW50
YWwtcm9hbS00OjIwMTMxMTEwMTgzMjExOmkzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxODoz
LjEyLjAtbmV4dC0yMDEzMTEwOC0xMDYwMS1nYmFkNTcwZDoyCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWo3LTExMDgyMzE4L2JhZDU3MGQ3NzAyNGNiYTgwODEyNmQ2OGEyMDcyZjZmOGNl
NjRjMjcvZG1lc2cteW9jdG8tc3RvYWtsZXktNDoyMDEzMTEwOTAyMjkyODppMzg2LXJhbmRj
b25maWctajctMTEwODIzMTg6My4xMi4wLW5leHQtMjAxMzExMDgtMTA2MDEtZ2JhZDU3MGQ6
Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxOC9iYWQ1NzBkNzcwMjRjYmE4
MDgxMjZkNjhhMjA3MmY2ZjhjZTY0YzI3L2RtZXNnLXlvY3RvLWlubi00ODoyMDEzMTExMDE4
MzMxMTppMzg2LXJhbmRjb25maWctajctMTEwODIzMTg6My4xMi4wLW5leHQtMjAxMzExMDgt
MTA2MDEtZ2JhZDU3MGQ6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxOC9i
YWQ1NzBkNzcwMjRjYmE4MDgxMjZkNjhhMjA3MmY2ZjhjZTY0YzI3L2RtZXNnLXlvY3RvLWlu
bi00MToyMDEzMTEwOTAyMjk1OTppMzg2LXJhbmRjb25maWctajctMTEwODIzMTg6My4xMi4w
LW5leHQtMjAxMzExMDgtMTA2MDEtZ2JhZDU3MGQ6Mgova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1qNy0xMTA4MjMxOC9iYWQ1NzBkNzcwMjRjYmE4MDgxMjZkNjhhMjA3MmY2ZjhjZTY0YzI3
L2RtZXNnLXlvY3RvLWxrcC10dDAyLTE4OjIwMTMxMTA4MTcyMTU4OmkzODYtcmFuZGNvbmZp
Zy1qNy0xMTA4MjMxODozLjEyLjAtbmV4dC0yMDEzMTEwOC0xMDYwMS1nYmFkNTcwZDoyCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo3LTExMDgyMzE4L2JhZDU3MGQ3NzAyNGNiYTgwODEy
NmQ2OGEyMDcyZjZmOGNlNjRjMjcvZG1lc2cteW9jdG8tbGtwLXN0MDEtODoyMDEzMTEwOTEw
MjAzNzppMzg2LXJhbmRjb25maWctajctMTEwODIzMTg6My4xMi4wLW5leHQtMjAxMzExMDgt
MTA2MDEtZ2JhZDU3MGQ6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxOC9i
YWQ1NzBkNzcwMjRjYmE4MDgxMjZkNjhhMjA3MmY2ZjhjZTY0YzI3L2RtZXNnLXF1YW50YWwt
c25iLTQ1OjIwMTMxMTEwMTgzMjEwOmkzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxODozLjEy
LjAtbmV4dC0yMDEzMTEwOC0xMDYwMS1nYmFkNTcwZDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWo3LTExMDgyMzE4L2JhZDU3MGQ3NzAyNGNiYTgwODEyNmQ2OGEyMDcyZjZmOGNlNjRj
MjcvZG1lc2ctcXVhbnRhbC1pbm4tMzM6MjAxMzExMTAxODMyMTE6aTM4Ni1yYW5kY29uZmln
LWo3LTExMDgyMzE4OjMuMTIuMC1uZXh0LTIwMTMxMTA4LTEwNjAxLWdiYWQ1NzBkOjIKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctajctMTEwODIzMTgvYmFkNTcwZDc3MDI0Y2JhODA4MTI2
ZDY4YTIwNzJmNmY4Y2U2NGMyNy9kbWVzZy15b2N0by1pbm4tNjoyMDEzMTExMDE4MzMyMDpp
Mzg2LXJhbmRjb25maWctajctMTEwODIzMTg6My4xMi4wLW5leHQtMjAxMzExMDgtMTA2MDEt
Z2JhZDU3MGQ6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxOC9iYWQ1NzBk
NzcwMjRjYmE4MDgxMjZkNjhhMjA3MmY2ZjhjZTY0YzI3L2RtZXNnLXlvY3RvLWlubi0yMToy
MDEzMTExMDE4MzMxNTppMzg2LXJhbmRjb25maWctajctMTEwODIzMTg6My4xMi4wLW5leHQt
MjAxMzExMDgtMTA2MDEtZ2JhZDU3MGQ6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0x
MTA4MjMxOC9iYWQ1NzBkNzcwMjRjYmE4MDgxMjZkNjhhMjA3MmY2ZjhjZTY0YzI3L2RtZXNn
LXlvY3RvLXhwcy00OjIwMTMxMTA5MTAyMTM5OmkzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMx
ODozLjEyLjAtbmV4dC0yMDEzMTEwOC0xMDYwMS1nYmFkNTcwZDoyCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWo3LTExMDgyMzE4L2JhZDU3MGQ3NzAyNGNiYTgwODEyNmQ2OGEyMDcyZjZm
OGNlNjRjMjcvZG1lc2cteW9jdG8tc25iLTM0OjIwMTMxMTEwMTgzMzEzOmkzODYtcmFuZGNv
bmZpZy1qNy0xMTA4MjMxODozLjEyLjAtbmV4dC0yMDEzMTEwOC0xMDYwMS1nYmFkNTcwZDoy
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo3LTExMDgyMzE4L2JhZDU3MGQ3NzAyNGNiYTgw
ODEyNmQ2OGEyMDcyZjZmOGNlNjRjMjcvZG1lc2ctcXVhbnRhbC14cHMtNzoyMDEzMTEwOTEw
MjY0MzppMzg2LXJhbmRjb25maWctajctMTEwODIzMTg6My4xMi4wLW5leHQtMjAxMzExMDgt
MTA2MDEtZ2JhZDU3MGQ6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxOC9i
YWQ1NzBkNzcwMjRjYmE4MDgxMjZkNjhhMjA3MmY2ZjhjZTY0YzI3L2RtZXNnLXF1YW50YWwt
YmVucy0yOjIwMTMxMTA5MDIxODI0OmkzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxODozLjEy
LjAtbmV4dC0yMDEzMTEwOC0xMDYwMS1nYmFkNTcwZDoyCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWo3LTExMDgyMzE4L2JhZDU3MGQ3NzAyNGNiYTgwODEyNmQ2OGEyMDcyZjZmOGNlNjRj
MjcvZG1lc2cteW9jdG8tamFrZXRvd24tNDI6MjAxMzExMTAxODMzMjk6aTM4Ni1yYW5kY29u
ZmlnLWo3LTExMDgyMzE4OjMuMTIuMC1uZXh0LTIwMTMxMTA4LTEwNjAxLWdiYWQ1NzBkOjIK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctajctMTEwODIzMTgvYmFkNTcwZDc3MDI0Y2JhODA4
MTI2ZDY4YTIwNzJmNmY4Y2U2NGMyNy9kbWVzZy15b2N0by1qYWtldG93bi00MzoyMDEzMTEw
OTAyMzIxNTppMzg2LXJhbmRjb25maWctajctMTEwODIzMTg6My4xMi4wLW5leHQtMjAxMzEx
MDgtMTA2MDEtZ2JhZDU3MGQ6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMx
OC9iYWQ1NzBkNzcwMjRjYmE4MDgxMjZkNjhhMjA3MmY2ZjhjZTY0YzI3L2RtZXNnLXF1YW50
YWwtcm9hbS0zNDoyMDEzMTExMDE4MzIxMDppMzg2LXJhbmRjb25maWctajctMTEwODIzMTg6
My4xMi4wLW5leHQtMjAxMzExMDgtMTA2MDEtZ2JhZDU3MGQ6MgowOjE5OjE5IGFsbF9nb29k
OmJhZDphbGxfYmFkIGJvb3RzCgpbZGV0YWNoZWQgSEVBRCA3YjA4MzMwXSBSZXZlcnQgInNl
cWNvdW50OiBBZGQgbG9ja2RlcCBmdW5jdGlvbmFsaXR5IHRvIHNlcWNvdW50L3NlcWxvY2sg
c3RydWN0dXJlcyIKIDcgZmlsZXMgY2hhbmdlZCwgMjEgaW5zZXJ0aW9ucygrKSwgOTAgZGVs
ZXRpb25zKC0pCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRj
b25maWctajctMTEwODIzMTgvbmV4dDptYXN0ZXI6N2IwODMzMDQzYjg4YTMxODhmZmQyZDZl
YTRiNzJiYWZiMDRiYTRiZDpiaXNlY3QtbW0KCjIwMTMtMTEtMTAtMjI6MzQ6MDYgN2IwODMz
MDQzYjg4YTMxODhmZmQyZDZlYTRiNzJiYWZiMDRiYTRiZCBjb21waWxpbmcKCjIwMTMtMTEt
MTAtMjI6NDM6MDcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLW5leHQtMjAxMzExMDgt
MDAwMDEtZzdiMDgzMzAJNwkyNwkzNwk0Nwk1Mi4JNTMuCTU0CTU4CTU5Li4uLi4uLi4uLgk2
MCBTVUNDRVNTCgoKPT09PT09PT09IHVwc3RyZWFtID09PT09PT09PQpGZXRjaGluZyBsaW51
cwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWo3
LTExMDgyMzE4L25leHQ6bWFzdGVyOjZjODZhZTI5MjhmOWU0Y2JmMGQ1ODQ0ZjVmY2ZkNTQ5
ZTM0NTBiOGM6YmlzZWN0LW1tCgoyMDEzLTExLTEwLTIyOjU0OjE5IDZjODZhZTI5MjhmOWU0
Y2JmMGQ1ODQ0ZjVmY2ZkNTQ5ZTM0NTBiOGMgY29tcGlsaW5nCgoyMDEzLTExLTEwLTIyOjU5
OjQ1IGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC0wMTkxNS1nNmM4NmFlMgkxNQk0NAk0
OQk1NQk1OAk1OS4JNjAgU1VDQ0VTUwoKCj09PT09PT09PSBsaW51eC1uZXh0ID09PT09PT09
PQpGZXRjaGluZyBuZXh0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWctajctMTEwODIzMTgvbmV4dDptYXN0ZXI6YmFkNTcwZDc3MDI0Y2JhODA4
MTI2ZDY4YTIwNzJmNmY4Y2U2NGMyNzpiaXNlY3QtbW0KIFRFU1QgRkFJTFVSRQpbICAgIDQu
MDUwMDk1XSBlMTAwMDogSW50ZWwoUikgUFJPLzEwMDAgTmV0d29yayBEcml2ZXIgLSB2ZXJz
aW9uIDcuMy4yMS1rOC1OQVBJClsgICAgNC4wNTEyMDhdIGUxMDAwOiBDb3B5cmlnaHQgKGMp
IDE5OTktMjAwNiBJbnRlbCBDb3Jwb3JhdGlvbi4KWyAgICA0LjA1NDc2NV0gc2QgMDowOjA6
MDogW3NkYV0gV3JpdGUgY2FjaGU6IGVuYWJsZWQsIHJlYWQgY2FjaGU6IGVuYWJsZWQsIHN1
cHBvcnRzIERQTyBhbmQgRlVBClsgICAgNC4wNjEyNzJdIElORk86IHRyeWluZyB0byByZWdp
c3RlciBub24tc3RhdGljIGtleS4KWyAgICA0LjA2MjAzNl0gdGhlIGNvZGUgaXMgZmluZSBi
dXQgbmVlZHMgbG9ja2RlcCBhbm5vdGF0aW9uLgpbICAgIDQuMDYyMDM2XSB0dXJuaW5nIG9m
ZiB0aGUgbG9ja2luZyBjb3JyZWN0bmVzcyB2YWxpZGF0b3IuClsgICAgNC4wNjIwMzZdIENQ
VTogMSBQSUQ6IDk2IENvbW06IGt3b3JrZXIvdTQ6MSBOb3QgdGFpbnRlZCAzLjEyLjAtbmV4
dC0yMDEzMTEwOC0xMDYwMS1nYmFkNTcwZCAjMgpbICAgIDQuMDYyMDM2XSBIYXJkd2FyZSBu
YW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgNC4wNjIwMzZd
IFdvcmtxdWV1ZTogZXZlbnRzX3VuYm91bmQgYXN5bmNfcnVuX2VudHJ5X2ZuClsgICAgNC4w
NjIwMzZdICA4MDg4ZTc0NCAwMDAwMDAwMCA3ZDNiMTk2OCA4MTVjN2NmMiA4MjAwYzhiOCA3
ZDNiMTlhMCA4MDg4OTUzZSA4MTliN2Y0ZApbICAgIDQuMDYyMDM2XSAgODE5YjdmYTcgODE5
YjdmN2QgN2QzOTY1MDggMDAwMDAwMDAgMDAwMDAwMTEgNTAzNzYwMTEgMDAwMGE5MDUgN2Qz
OTYwMTAKWyAgICA0LjA2MjAzNl0gIDdkMzk2MDEwIDg1ZDNkYTcwIDAwMDAwMDAwIDdkM2Ix
OWNjIDgwODhhMWM1IDAwMDAwMDAwIDAwMDAwMDAxIDAwMDAwMDAwClsgICAgNC4wNjIwMzZd
IENhbGwgVHJhY2U6ClsgICAgNC4wNjIwMzZdICBbPDgwODhlNzQ0Pl0gPyBjb25zb2xlX3Vu
bG9jaysweDM1My8weDM4MApbICAgIDQuMDYyMDM2XSAgWzw4MTVjN2NmMj5dIGR1bXBfc3Rh
Y2srMHg0OC8weDYwClsgICAgNC4wNjIwMzZdICBbPDgwODg5NTNlPl0gX19sb2NrX2FjcXVp
cmUuaXNyYS4yNisweDdlMy8weGNlYgpbICAgIDQuMDYyMDM2XSAgWzw4MDg4YTFjNT5dIGxv
Y2tfYWNxdWlyZSsweDcxLzB4OWEKWyAgICA0LjA2MjAzNl0gIFs8ODBjMDc5YWE+XSA/IGJs
a190aHJvdGxfYmlvKzB4MWMzLzB4NDg1ClsgICAgNC4wNjIwMzZdICBbPDgwYzA2NThiPl0g
dGhyb3RsX3VwZGF0ZV9kaXNwYXRjaF9zdGF0cysweDdjLzB4MTUzClsgICAgNC4wNjIwMzZd
ICBbPDgwYzA3OWFhPl0gPyBibGtfdGhyb3RsX2JpbysweDFjMy8weDQ4NQpbICAgIDQuMDYy
MDM2XSAgWzw4MGMwNzlhYT5dIGJsa190aHJvdGxfYmlvKzB4MWMzLzB4NDg1ClsgICAgNC4w
NjIwMzZdICBbPDgwODdjN2Y5Pl0gPyBzY2hlZF9jbG9ja19sb2NhbCsweDE3LzB4MTA2Clsg
ICAgNC4wNjIwMzZdICBbPDgwODdjYThiPl0gPyBzY2hlZF9jbG9ja19jcHUrMHgxMDUvMHgx
MTMKWyAgICA0LjA2MjAzNl0gIFs8ODBiZjJmZWU+XSBnZW5lcmljX21ha2VfcmVxdWVzdF9j
aGVja3MrMHgzY2EvMHgzZTEKWyAgICA0LjA2MjAzNl0gIFs8ODA4N2NhOGI+XSA/IHNjaGVk
X2Nsb2NrX2NwdSsweDEwNS8weDExMwpbICAgIDQuMDYyMDM2XSAgWzw4MGJmNDYxMz5dIGdl
bmVyaWNfbWFrZV9yZXF1ZXN0KzB4Zi8weGIwClsgICAgNC4wNjIwMzZdICBbPDgwYmY0NzIz
Pl0gc3VibWl0X2JpbysweDZmLzB4ZDgKWyAgICA0LjA2MjAzNl0gIFs8ODA5MTY2OTU+XSBf
c3VibWl0X2JoKzB4MjI4LzB4MjQ1ClsgICAgNC4wNjIwMzZdICBbPDgwOTE2NmJjPl0gc3Vi
bWl0X2JoKzB4YS8weGMKWyAgICA0LjA2MjAzNl0gIFs8ODA5MTc2OGU+XSBibG9ja19yZWFk
X2Z1bGxfcGFnZSsweDJhOC8weDJjMwpbICAgIDQuMDYyMDM2XSAgWzw4MDkxYTU1NT5dID8g
YmlvX2RpcnR5X2ZuKzB4NmYvMHg2ZgpbICAgIDQuMDYyMDM2XSAgWzw4MDhiZWQwYz5dID8g
YWRkX3RvX3BhZ2VfY2FjaGVfbG9ja2VkKzB4YjQvMHhlMgpbICAgIDQuMDYyMDM2XSAgWzw4
MDkxYTdlYj5dID8gYmxrZGV2X3dyaXRlX2JlZ2luKzB4MjAvMHgyMApbICAgIDQuMDYyMDM2
XSAgWzw4MDkxYTdlYj5dID8gYmxrZGV2X3dyaXRlX2JlZ2luKzB4MjAvMHgyMApbICAgIDQu
MDYyMDM2XSAgWzw4MDkxYTdmYT5dIGJsa2Rldl9yZWFkcGFnZSsweGYvMHgxMQpbICAgIDQu
MDYyMDM2XSAgWzw4MDhiZjg3Nz5dIGRvX3JlYWRfY2FjaGVfcGFnZSsweDZlLzB4MTFiClsg
ICAgNC4wNjIwMzZdICBbPDgwOGMwNjQ5Pl0gcmVhZF9jYWNoZV9wYWdlX2FzeW5jKzB4MTkv
MHgxZQpbICAgIDQuMDYyMDM2XSAgWzw4MDkxYTdlYj5dID8gYmxrZGV2X3dyaXRlX2JlZ2lu
KzB4MjAvMHgyMApbICAgIDQuMDYyMDM2XSAgWzw4MDhjMDY3YT5dIHJlYWRfY2FjaGVfcGFn
ZSsweGIvMHgxMgpbICAgIDQuMDYyMDM2XSAgWzw4MGMwMTcwZD5dIHJlYWRfZGV2X3NlY3Rv
cisweDI2LzB4NjEKWyAgICA0LjA2MjAzNl0gIFs8ODBjMDIxNWI+XSByZWFkX2xiYSsweGFl
LzB4ZjkKWyAgICA0LjA2MjAzNl0gIFs8ODA4ZTYwYjY+XSA/IGttZW1fY2FjaGVfYWxsb2Mr
MHhmOS8weDEyYgpbICAgIDQuMDYyMDM2XSAgWzw4MGMwMjY4Yj5dIGVmaV9wYXJ0aXRpb24r
MHgxN2EvMHg5YzAKWyAgICA0LjA2MjAzNl0gIFs8ODA4YzRjNGY+XSA/IF9fYWxsb2NfcGFn
ZXNfbm9kZW1hc2srMHhlMy8weDYxZQpbICAgIDQuMDYyMDM2XSAgWzw4MGMxNTg0OT5dID8g
c3RyaW5nLmlzcmEuNCsweDI5LzB4OTMKWyAgICA0LjA2MjAzNl0gIFs8ODBjMTU4NDk+XSA/
IHN0cmluZy5pc3JhLjQrMHgyOS8weDkzClsgICAgNC4wNjIwMzZdICBbPDgwYzE2NWU5Pl0g
PyB2c25wcmludGYrMHg4MS8weDI4YgpbICAgIDQuMDYyMDM2XSAgWzw4MGMxNmFiMj5dID8g
c25wcmludGYrMHgxNS8weDE3ClsgICAgNC4wNjIwMzZdICBbPDgwYzAxODQ0Pl0gY2hlY2tf
cGFydGl0aW9uKzB4ZTQvMHgxNzgKWyAgICA0LjA2MjAzNl0gIFs8ODBjMDE4NDQ+XSA/IGNo
ZWNrX3BhcnRpdGlvbisweGU0LzB4MTc4ClsgICAgNC4wNjIwMzZdICBbPDgwYzAxNDk2Pl0g
cmVzY2FuX3BhcnRpdGlvbnMrMHg4OS8weDI2NwpbICAgIDQuMDYyMDM2XSAgWzw4MDkxYThk
Zj5dID8gYmRldl9pbm9kZV9zd2l0Y2hfYmRpKzB4ZDIvMHhlNgpbICAgIDQuMDYyMDM2XSAg
Wzw4MDkxYjY5Nj5dIF9fYmxrZGV2X2dldCsweDE3My8weDM2MwpbICAgIDQuMDYyMDM2XSAg
Wzw4MDkxYjhkMT5dIGJsa2Rldl9nZXQrMHg0Yi8weDIzZApbICAgIDQuMDYyMDM2XSAgWzw4
MDkxYWY4Zj5dID8gYmRnZXQrMHhmOC8weDEwNQpbICAgIDQuMDYyMDM2XSAgWzw4MGViYzZj
NT5dID8gcHV0X2RldmljZSsweGYvMHgxMQpbICAgIDQuMDYyMDM2XSAgWzw4MGJmZjRjOT5d
IGFkZF9kaXNrKzB4MjZiLzB4M2I1ClsgICAgNC4wNjIwMzZdICBbPDgwZWM0NTk5Pl0gPyBf
X3BtX3J1bnRpbWVfdXNlX2F1dG9zdXNwZW5kKzB4NGEvMHg0ZgpbICAgIDQuMDYyMDM2XSAg
Wzw4MGZlNGQ3Mz5dIHNkX3Byb2JlX2FzeW5jKzB4MTExLzB4MTk4ClsgICAgNC4wNjIwMzZd
ICBbPDgwODc1YjBhPl0gYXN5bmNfcnVuX2VudHJ5X2ZuKzB4NTkvMHhmZgpbICAgIDQuMDYy
MDM2XSAgWzw4MDg2Y2I1ND5dIHByb2Nlc3Nfb25lX3dvcmsrMHgxZWYvMHgzNDkKWyAgICA0
LjA2MjAzNl0gIFs8ODA4NmNhZmI+XSA/IHByb2Nlc3Nfb25lX3dvcmsrMHgxOTYvMHgzNDkK
WyAgICA0LjA2MjAzNl0gIFs8ODA4NmQwYTU+XSB3b3JrZXJfdGhyZWFkKzB4MWEzLzB4Mjc0
ClsgICAgNC4wNjIwMzZdICBbPDgwODZjZjAyPl0gPyByZXNjdWVyX3RocmVhZCsweDIzMy8w
eDIzMwpbICAgIDQuMDYyMDM2XSAgWzw4MDg3MTc2Nz5dIGt0aHJlYWQrMHhhNS8weGFhClsg
ICAgNC4wNjIwMzZdICBbPDgwODcwMDAwPl0gPyBtYXliZV9rZnJlZV9wYXJhbWV0ZXIrMHhj
LzB4M2QKWyAgICA0LjA2MjAzNl0gIFs8ODE1ZGI2YmI+XSByZXRfZnJvbV9rZXJuZWxfdGhy
ZWFkKzB4MWIvMHgzMApbICAgIDQuMDYyMDM2XSAgWzw4MDg3MTZjMj5dID8gX19rdGhyZWFk
X3BhcmttZSsweDUwLzB4NTAKWyAgICA0LjExODA1Nl0gIHNkYTogdW5rbm93biBwYXJ0aXRp
b24gdGFibGUKWyAgICA0LjEyNjA3OV0gc2QgMDowOjA6MDogW3NkYV0gQXR0YWNoZWQgU0NT
SSBkaXNrClsgICAgNC40NTAzMTVdIGUxMDAwIDAwMDA6MDA6MDMuMCBldGgwOiAoUENJOjMz
TUh6OjMyLWJpdCkgNTI6NTQ6MDA6MTI6MzQ6NTYKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
ajctMTEwODIzMTgvYmFkNTcwZDc3MDI0Y2JhODA4MTI2ZDY4YTIwNzJmNmY4Y2U2NGMyNy9k
bWVzZy1xdWFudGFsLWxrcC10dDAyLTE5OjIwMTMxMTEwMDkyMzQyOmkzODYtcmFuZGNvbmZp
Zy1qNy0xMTA4MjMxODozLjEyLjAtbmV4dC0yMDEzMTEwOC0xMDYwMS1nYmFkNTcwZDoyCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWo3LTExMDgyMzE4L2JhZDU3MGQ3NzAyNGNiYTgwODEy
NmQ2OGEyMDcyZjZmOGNlNjRjMjcvZG1lc2ctcXVhbnRhbC1yb2FtLTc6MjAxMzExMDkwMjI3
MzI6aTM4Ni1yYW5kY29uZmlnLWo3LTExMDgyMzE4OjMuMTIuMC1uZXh0LTIwMTMxMTA4LTEw
NjAxLWdiYWQ1NzBkOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajctMTEwODIzMTgvYmFk
NTcwZDc3MDI0Y2JhODA4MTI2ZDY4YTIwNzJmNmY4Y2U2NGMyNy9kbWVzZy1xdWFudGFsLXJv
YW0tNDoyMDEzMTExMDE4MzIxMTppMzg2LXJhbmRjb25maWctajctMTEwODIzMTg6My4xMi4w
LW5leHQtMjAxMzExMDgtMTA2MDEtZ2JhZDU3MGQ6Mgova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1qNy0xMTA4MjMxOC9iYWQ1NzBkNzcwMjRjYmE4MDgxMjZkNjhhMjA3MmY2ZjhjZTY0YzI3
L2RtZXNnLXlvY3RvLXN0b2FrbGV5LTQ6MjAxMzExMDkwMjI5Mjg6aTM4Ni1yYW5kY29uZmln
LWo3LTExMDgyMzE4OjMuMTIuMC1uZXh0LTIwMTMxMTA4LTEwNjAxLWdiYWQ1NzBkOjIKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctajctMTEwODIzMTgvYmFkNTcwZDc3MDI0Y2JhODA4MTI2
ZDY4YTIwNzJmNmY4Y2U2NGMyNy9kbWVzZy15b2N0by1pbm4tNDg6MjAxMzExMTAxODMzMTE6
aTM4Ni1yYW5kY29uZmlnLWo3LTExMDgyMzE4OjMuMTIuMC1uZXh0LTIwMTMxMTA4LTEwNjAx
LWdiYWQ1NzBkOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajctMTEwODIzMTgvYmFkNTcw
ZDc3MDI0Y2JhODA4MTI2ZDY4YTIwNzJmNmY4Y2U2NGMyNy9kbWVzZy15b2N0by1pbm4tNDE6
MjAxMzExMDkwMjI5NTk6aTM4Ni1yYW5kY29uZmlnLWo3LTExMDgyMzE4OjMuMTIuMC1uZXh0
LTIwMTMxMTA4LTEwNjAxLWdiYWQ1NzBkOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajct
MTEwODIzMTgvYmFkNTcwZDc3MDI0Y2JhODA4MTI2ZDY4YTIwNzJmNmY4Y2U2NGMyNy9kbWVz
Zy15b2N0by1sa3AtdHQwMi0xODoyMDEzMTEwODE3MjE1ODppMzg2LXJhbmRjb25maWctajct
MTEwODIzMTg6My4xMi4wLW5leHQtMjAxMzExMDgtMTA2MDEtZ2JhZDU3MGQ6Mgova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxOC9iYWQ1NzBkNzcwMjRjYmE4MDgxMjZkNjhh
MjA3MmY2ZjhjZTY0YzI3L2RtZXNnLXlvY3RvLWxrcC1zdDAxLTg6MjAxMzExMDkxMDIwMzc6
aTM4Ni1yYW5kY29uZmlnLWo3LTExMDgyMzE4OjMuMTIuMC1uZXh0LTIwMTMxMTA4LTEwNjAx
LWdiYWQ1NzBkOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajctMTEwODIzMTgvYmFkNTcw
ZDc3MDI0Y2JhODA4MTI2ZDY4YTIwNzJmNmY4Y2U2NGMyNy9kbWVzZy1xdWFudGFsLXNuYi00
NToyMDEzMTExMDE4MzIxMDppMzg2LXJhbmRjb25maWctajctMTEwODIzMTg6My4xMi4wLW5l
eHQtMjAxMzExMDgtMTA2MDEtZ2JhZDU3MGQ6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1q
Ny0xMTA4MjMxOC9iYWQ1NzBkNzcwMjRjYmE4MDgxMjZkNjhhMjA3MmY2ZjhjZTY0YzI3L2Rt
ZXNnLXF1YW50YWwtaW5uLTMzOjIwMTMxMTEwMTgzMjExOmkzODYtcmFuZGNvbmZpZy1qNy0x
MTA4MjMxODozLjEyLjAtbmV4dC0yMDEzMTEwOC0xMDYwMS1nYmFkNTcwZDoyCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWo3LTExMDgyMzE4L2JhZDU3MGQ3NzAyNGNiYTgwODEyNmQ2OGEy
MDcyZjZmOGNlNjRjMjcvZG1lc2cteW9jdG8taW5uLTY6MjAxMzExMTAxODMzMjA6aTM4Ni1y
YW5kY29uZmlnLWo3LTExMDgyMzE4OjMuMTIuMC1uZXh0LTIwMTMxMTA4LTEwNjAxLWdiYWQ1
NzBkOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajctMTEwODIzMTgvYmFkNTcwZDc3MDI0
Y2JhODA4MTI2ZDY4YTIwNzJmNmY4Y2U2NGMyNy9kbWVzZy15b2N0by1pbm4tMjE6MjAxMzEx
MTAxODMzMTU6aTM4Ni1yYW5kY29uZmlnLWo3LTExMDgyMzE4OjMuMTIuMC1uZXh0LTIwMTMx
MTA4LTEwNjAxLWdiYWQ1NzBkOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajctMTEwODIz
MTgvYmFkNTcwZDc3MDI0Y2JhODA4MTI2ZDY4YTIwNzJmNmY4Y2U2NGMyNy9kbWVzZy15b2N0
by14cHMtNDoyMDEzMTEwOTEwMjEzOTppMzg2LXJhbmRjb25maWctajctMTEwODIzMTg6My4x
Mi4wLW5leHQtMjAxMzExMDgtMTA2MDEtZ2JhZDU3MGQ6Mgova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1qNy0xMTA4MjMxOC9iYWQ1NzBkNzcwMjRjYmE4MDgxMjZkNjhhMjA3MmY2ZjhjZTY0
YzI3L2RtZXNnLXlvY3RvLXNuYi0zNDoyMDEzMTExMDE4MzMxMzppMzg2LXJhbmRjb25maWct
ajctMTEwODIzMTg6My4xMi4wLW5leHQtMjAxMzExMDgtMTA2MDEtZ2JhZDU3MGQ6Mgova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1qNy0xMTA4MjMxOC9iYWQ1NzBkNzcwMjRjYmE4MDgxMjZk
NjhhMjA3MmY2ZjhjZTY0YzI3L2RtZXNnLXF1YW50YWwteHBzLTc6MjAxMzExMDkxMDI2NDM6
aTM4Ni1yYW5kY29uZmlnLWo3LTExMDgyMzE4OjMuMTIuMC1uZXh0LTIwMTMxMTA4LTEwNjAx
LWdiYWQ1NzBkOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajctMTEwODIzMTgvYmFkNTcw
ZDc3MDI0Y2JhODA4MTI2ZDY4YTIwNzJmNmY4Y2U2NGMyNy9kbWVzZy1xdWFudGFsLWJlbnMt
MjoyMDEzMTEwOTAyMTgyNDppMzg2LXJhbmRjb25maWctajctMTEwODIzMTg6My4xMi4wLW5l
eHQtMjAxMzExMDgtMTA2MDEtZ2JhZDU3MGQ6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1q
Ny0xMTA4MjMxOC9iYWQ1NzBkNzcwMjRjYmE4MDgxMjZkNjhhMjA3MmY2ZjhjZTY0YzI3L2Rt
ZXNnLXlvY3RvLWpha2V0b3duLTQyOjIwMTMxMTEwMTgzMzI5OmkzODYtcmFuZGNvbmZpZy1q
Ny0xMTA4MjMxODozLjEyLjAtbmV4dC0yMDEzMTEwOC0xMDYwMS1nYmFkNTcwZDoyCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWo3LTExMDgyMzE4L2JhZDU3MGQ3NzAyNGNiYTgwODEyNmQ2
OGEyMDcyZjZmOGNlNjRjMjcvZG1lc2cteW9jdG8tamFrZXRvd24tNDM6MjAxMzExMDkwMjMy
MTU6aTM4Ni1yYW5kY29uZmlnLWo3LTExMDgyMzE4OjMuMTIuMC1uZXh0LTIwMTMxMTA4LTEw
NjAxLWdiYWQ1NzBkOjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctajctMTEwODIzMTgvYmFk
NTcwZDc3MDI0Y2JhODA4MTI2ZDY4YTIwNzJmNmY4Y2U2NGMyNy9kbWVzZy1xdWFudGFsLXJv
YW0tMzQ6MjAxMzExMTAxODMyMTA6aTM4Ni1yYW5kY29uZmlnLWo3LTExMDgyMzE4OjMuMTIu
MC1uZXh0LTIwMTMxMTA4LTEwNjAxLWdiYWQ1NzBkOjIKMDoxOToxOSBhbGxfZ29vZDpiYWQ6
YWxsX2JhZCBib290cwoK

--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.12.0-next-20131108-10601-gbad570d"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.12.0 Kernel Configuration
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
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
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
# CONFIG_KERNEL_UNCOMPRESSED is not set
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
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
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
# CONFIG_MEMCG_KMEM is not set
# CONFIG_CGROUP_HUGETLB is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
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
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
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
CONFIG_USER_RETURN_NOTIFIER=y
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
CONFIG_BASE_SMALL=1
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLK_DEV_THROTTLING=y
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
# CONFIG_MSDOS_PARTITION is not set
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
CONFIG_CMDLINE_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_BIGSMP=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_DEBUG=y
CONFIG_PARAVIRT_SPINLOCKS=y
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
CONFIG_KVM_DEBUG_FS=y
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_M486 is not set
# CONFIG_M586 is not set
CONFIG_M586TSC=y
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
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
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_F00F_BUG=y
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_TSC=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_CYRIX_32 is not set
CONFIG_CPU_SUP_AMD=y
# CONFIG_CPU_SUP_CENTAUR is not set
# CONFIG_CPU_SUP_TRANSMETA_32 is not set
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=32
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
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
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_INJECT=y
CONFIG_VM86=y
CONFIG_TOSHIBA=y
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
CONFIG_MICROCODE_AMD_EARLY=y
CONFIG_MICROCODE_EARLY=y
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
CONFIG_VMSPLIT_2G_OPT=y
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x78000000
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
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
# CONFIG_HIGHPTE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_RANDOMIZE_BASE_MAX_OFFSET=0x20000000
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
CONFIG_DEBUG_HOTPLUG_CPU0=y
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
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
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_BIOS=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
# CONFIG_ALIX is not set
# CONFIG_NET5501 is not set
CONFIG_GEOS=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
CONFIG_YENTA=y
# CONFIG_YENTA_O2 is not set
# CONFIG_YENTA_RICOH is not set
# CONFIG_YENTA_TI is not set
# CONFIG_YENTA_TOSHIBA is not set
CONFIG_PD6729=y
CONFIG_I82092=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_COMPAQ=y
# CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM is not set
# CONFIG_HOTPLUG_PCI_IBM is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

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
# CONFIG_PACKET is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_USER is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
# CONFIG_IP_MULTIPLE_TABLES is not set
CONFIG_IP_ROUTE_MULTIPATH=y
# CONFIG_IP_ROUTE_VERBOSE is not set
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
# CONFIG_IP_PNP_RARP is not set
# CONFIG_NET_IPIP is not set
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
CONFIG_NET_IPGRE=y
# CONFIG_SYN_COOKIES is not set
CONFIG_NET_IPVTI=y
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=y
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=y
CONFIG_TCP_CONG_SCALABLE=y
CONFIG_TCP_CONG_LP=y
CONFIG_TCP_CONG_VENO=y
# CONFIG_TCP_CONG_YEAH is not set
CONFIG_TCP_CONG_ILLINOIS=y
# CONFIG_DEFAULT_BIC is not set
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HYBLA is not set
CONFIG_DEFAULT_VEGAS=y
# CONFIG_DEFAULT_VENO is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="vegas"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
# CONFIG_IPV6_ROUTE_INFO is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
CONFIG_INET6_ESP=y
CONFIG_INET6_IPCOMP=y
CONFIG_IPV6_MIP6=y
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
CONFIG_IPV6_VTI=y
CONFIG_IPV6_SIT=y
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_GRE=y
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
# CONFIG_IPV6_MROUTE_MULTIPLE_TABLES is not set
# CONFIG_IPV6_PIMSM_V2 is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=y

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_TFRC_LIB=y

#
# DCCP Kernel Hacking
#
CONFIG_IP_DCCP_DEBUG=y
CONFIG_IP_SCTP=y
CONFIG_SCTP_DBG_OBJCNT=y
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_RDS=y
CONFIG_RDS_TCP=y
# CONFIG_RDS_DEBUG is not set
CONFIG_TIPC=y
CONFIG_TIPC_PORTS=8191
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=y
CONFIG_ATM_MPOA=y
CONFIG_ATM_BR2684=y
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=y
# CONFIG_L2TP_DEBUGFS is not set
# CONFIG_L2TP_V3 is not set
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_VLAN_8021Q_MVRP is not set
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=y
# CONFIG_DEV_APPLETALK is not set
CONFIG_X25=y
CONFIG_LAPB=y
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
# CONFIG_NET_SCH_PRIO is not set
CONFIG_NET_SCH_MULTIQ=y
CONFIG_NET_SCH_RED=y
# CONFIG_NET_SCH_SFB is not set
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_MQPRIO=y
# CONFIG_NET_SCH_CHOKE is not set
CONFIG_NET_SCH_QFQ=y
# CONFIG_NET_SCH_CODEL is not set
CONFIG_NET_SCH_FQ_CODEL=y
# CONFIG_NET_SCH_FQ is not set
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
# CONFIG_CLS_U32_PERF is not set
# CONFIG_CLS_U32_MARK is not set
# CONFIG_NET_CLS_RSVP is not set
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
# CONFIG_NET_CLS_CGROUP is not set
# CONFIG_NET_CLS_BPF is not set
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=y
CONFIG_NET_EMATCH_NBYTE=y
CONFIG_NET_EMATCH_U32=y
# CONFIG_NET_EMATCH_META is not set
CONFIG_NET_EMATCH_TEXT=y
CONFIG_NET_EMATCH_CANID=y
# CONFIG_NET_CLS_ACT is not set
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_BLA=y
CONFIG_BATMAN_ADV_DAT=y
CONFIG_BATMAN_ADV_NC=y
CONFIG_BATMAN_ADV_DEBUG=y
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=y
CONFIG_VMWARE_VMCI_VSOCKETS=y
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=y
# CONFIG_HSR is not set
CONFIG_NETPRIO_CGROUP=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
CONFIG_CAN_BCM=y
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
# CONFIG_CAN_SLCAN is not set
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
CONFIG_IRNET=y
# CONFIG_IRCOMM is not set
CONFIG_IRDA_ULTRA=y

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
# CONFIG_KINGSUN_DONGLE is not set
CONFIG_KSDAZZLE_DONGLE=y
CONFIG_KS959_DONGLE=y

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
CONFIG_SIGMATEL_FIR=y
# CONFIG_NSC_FIR is not set
CONFIG_WINBOND_FIR=y
CONFIG_TOSHIBA_FIR=y
CONFIG_SMC_IRCC_FIR=y
CONFIG_ALI_FIR=y
CONFIG_VLSI_FIR=y
CONFIG_VIA_FIR=y
CONFIG_MCS_FIR=y
CONFIG_BT=y
CONFIG_BT_RFCOMM=y
CONFIG_BT_RFCOMM_TTY=y
# CONFIG_BT_BNEP is not set
# CONFIG_BT_CMTP is not set
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTUSB is not set
CONFIG_BT_HCIBTSDIO=y
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIBCM203X=y
# CONFIG_BT_HCIBPA10X is not set
CONFIG_BT_HCIBFUSB=y
CONFIG_BT_HCIDTL1=y
CONFIG_BT_HCIBT3C=y
CONFIG_BT_HCIBLUECARD=y
CONFIG_BT_HCIBTUART=y
# CONFIG_BT_HCIVHCI is not set
CONFIG_BT_MRVL=y
# CONFIG_BT_MRVL_SDIO is not set
CONFIG_BT_WILINK=y
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
CONFIG_RFKILL_REGULATOR=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
CONFIG_CAIF_NETDEV=y
CONFIG_CAIF_USB=y
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
# CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
CONFIG_NFC=y
CONFIG_NFC_DIGITAL=y
# CONFIG_NFC_NCI is not set
CONFIG_NFC_HCI=y
# CONFIG_NFC_SHDLC is not set

#
# Near Field Communication (NFC) devices
#
# CONFIG_NFC_PN533 is not set
CONFIG_NFC_SIM=y
CONFIG_NFC_PORT100=y
# CONFIG_NFC_PN544 is not set
# CONFIG_NFC_MICROREAD is not set

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
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
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
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
CONFIG_MTD_GEN_PROBE=y
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
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
CONFIG_MTD_CFI_INTELEXT=y
# CONFIG_MTD_CFI_AMDSTD is not set
CONFIG_MTD_CFI_STAA=y
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=y
# CONFIG_MTD_PHYSMAP_COMPAT is not set
# CONFIG_MTD_SC520CDP is not set
# CONFIG_MTD_NETSC520 is not set
# CONFIG_MTD_TS5500 is not set
CONFIG_MTD_AMD76XROM=y
# CONFIG_MTD_ICHXROM is not set
CONFIG_MTD_ESB2ROM=y
CONFIG_MTD_CK804XROM=y
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
CONFIG_MTD_INTEL_VR_NOR=y
CONFIG_MTD_PLATRAM=y

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
CONFIG_MTD_PMC551_BUGFIX=y
# CONFIG_MTD_PMC551_DEBUG is not set
CONFIG_MTD_DATAFLASH=y
CONFIG_MTD_DATAFLASH_WRITE_VERIFY=y
# CONFIG_MTD_DATAFLASH_OTP is not set
CONFIG_MTD_M25P80=y
# CONFIG_MTD_SST25L is not set
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
CONFIG_MTD_NAND_DENALI=y
CONFIG_MTD_NAND_DENALI_PCI=y
CONFIG_MTD_NAND_DENALI_SCRATCH_REG_ADDR=0xFF108018
# CONFIG_MTD_NAND_GPIO is not set
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=y
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
# CONFIG_MTD_NAND_DOCG4 is not set
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_CS553X=y
CONFIG_MTD_NAND_NANDSIM=y
CONFIG_MTD_NAND_PLATFORM=y
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
# CONFIG_MTD_UBI is not set
CONFIG_PARPORT=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT_PC=y
CONFIG_PARPORT_SERIAL=y
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_PC_PCMCIA is not set
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
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_AD525X_DPOT_SPI=y
CONFIG_DUMMY_IRQ=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ATMEL_SSC is not set
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_HP_ILO=y
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_TI_DAC7512 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_BMP085_SPI is not set
CONFIG_PCH_PHUB=y
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
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

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
# CONFIG_IDE is not set

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
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
CONFIG_ISCSI_BOOT_SYSFS=y
CONFIG_SCSI_CXGB3_ISCSI=y
CONFIG_SCSI_CXGB4_ISCSI=y
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_SCSI_BNX2X_FCOE is not set
CONFIG_BE2ISCSI=y
CONFIG_BLK_DEV_3W_XXXX_RAID=y
CONFIG_SCSI_HPSA=y
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
CONFIG_SCSI_ACARD=y
CONFIG_SCSI_AACRAID=y
# CONFIG_SCSI_AIC7XXX is not set
CONFIG_SCSI_AIC7XXX_OLD=y
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
CONFIG_SCSI_ADVANSYS=y
CONFIG_SCSI_ARCMSR=y
CONFIG_SCSI_ESAS2R=y
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=y
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPT3SAS is not set
CONFIG_SCSI_UFSHCD=y
# CONFIG_SCSI_UFSHCD_PCI is not set
# CONFIG_SCSI_UFSHCD_PLATFORM is not set
CONFIG_SCSI_HPTIOP=y
CONFIG_SCSI_BUSLOGIC=y
# CONFIG_SCSI_FLASHPOINT is not set
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
CONFIG_FCOE=y
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
CONFIG_SCSI_EATA=y
# CONFIG_SCSI_EATA_TAGGED_QUEUE is not set
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=y
CONFIG_SCSI_GDTH=y
CONFIG_SCSI_ISCI=y
CONFIG_SCSI_IPS=y
# CONFIG_SCSI_INITIO is not set
CONFIG_SCSI_INIA100=y
# CONFIG_SCSI_PPA is not set
CONFIG_SCSI_IMM=y
# CONFIG_SCSI_IZIP_EPP16 is not set
CONFIG_SCSI_IZIP_SLOW_CTR=y
CONFIG_SCSI_STEX=y
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
# CONFIG_SCSI_SYM53C8XX_MMIO is not set
CONFIG_SCSI_IPR=y
CONFIG_SCSI_IPR_TRACE=y
# CONFIG_SCSI_IPR_DUMP is not set
CONFIG_SCSI_QLOGIC_1280=y
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
CONFIG_SCSI_DC390T=y
# CONFIG_SCSI_NSP32 is not set
CONFIG_SCSI_DEBUG=y
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
CONFIG_SCSI_SRP=y
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=y
# CONFIG_SCSI_CHELSIO_FCOE is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=y
# CONFIG_SCSI_OSD_ULD is not set
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
CONFIG_SATA_AHCI_PLATFORM=y
CONFIG_AHCI_IMX=y
CONFIG_SATA_INIC162X=y
CONFIG_SATA_ACARD_AHCI=y
CONFIG_SATA_SIL24=y
# CONFIG_ATA_SFF is not set
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
# CONFIG_FIREWIRE_OHCI is not set
# CONFIG_FIREWIRE_SBP2 is not set
# CONFIG_FIREWIRE_NET is not set
CONFIG_FIREWIRE_NOSY=y
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
# CONFIG_NET_CORE is not set
CONFIG_SUNGEM_PHY=y
# CONFIG_ARCNET is not set
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=y
# CONFIG_ATM_TCP is not set
# CONFIG_ATM_LANAI is not set
CONFIG_ATM_ENI=y
CONFIG_ATM_ENI_DEBUG=y
# CONFIG_ATM_ENI_TUNE_BURST is not set
CONFIG_ATM_FIRESTREAM=y
CONFIG_ATM_ZATM=y
# CONFIG_ATM_ZATM_DEBUG is not set
CONFIG_ATM_NICSTAR=y
CONFIG_ATM_NICSTAR_USE_SUNI=y
CONFIG_ATM_NICSTAR_USE_IDT77105=y
CONFIG_ATM_IDT77252=y
CONFIG_ATM_IDT77252_DEBUG=y
# CONFIG_ATM_IDT77252_RCV_ALL is not set
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=y
CONFIG_ATM_AMBASSADOR_DEBUG=y
CONFIG_ATM_HORIZON=y
CONFIG_ATM_HORIZON_DEBUG=y
CONFIG_ATM_IA=y
# CONFIG_ATM_IA_DEBUG is not set
CONFIG_ATM_FORE200E=y
CONFIG_ATM_FORE200E_USE_TASKLET=y
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
# CONFIG_ATM_HE is not set
CONFIG_ATM_SOLOS=y

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=y
CONFIG_CAIF_SPI_SLAVE=y
# CONFIG_CAIF_SPI_SYNC is not set
CONFIG_CAIF_HSI=y
CONFIG_CAIF_VIRTIO=y
# CONFIG_VHOST_NET is not set
CONFIG_VHOST_RING=y

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
# CONFIG_NET_DSA_MV88E6060 is not set
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
CONFIG_ADAPTEC_STARFIRE=y
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
CONFIG_PCNET32=y
CONFIG_PCMCIA_NMCLAN=y
CONFIG_NET_VENDOR_ARC=y
# CONFIG_NET_VENDOR_ATHEROS is not set
# CONFIG_NET_CADENCE is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
CONFIG_BNX2=y
CONFIG_CNIC=y
CONFIG_TIGON3=y
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=y
CONFIG_CHELSIO_T1=y
# CONFIG_CHELSIO_T1_1G is not set
CONFIG_CHELSIO_T3=y
CONFIG_CHELSIO_T4=y
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=y
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
CONFIG_DE2104X=y
CONFIG_DE2104X_DSL=0
CONFIG_TULIP=y
# CONFIG_TULIP_MWI is not set
# CONFIG_TULIP_MMIO is not set
CONFIG_TULIP_NAPI=y
# CONFIG_TULIP_NAPI_HW_MITIGATION is not set
CONFIG_DE4X5=y
# CONFIG_WINBOND_840 is not set
CONFIG_DM9102=y
CONFIG_ULI526X=y
# CONFIG_NET_VENDOR_DLINK is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=y
# CONFIG_NET_VENDOR_EXAR is not set
# CONFIG_NET_VENDOR_FUJITSU is not set
CONFIG_NET_VENDOR_HP=y
CONFIG_HP100=y
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
# CONFIG_E1000E is not set
# CONFIG_IGB is not set
CONFIG_IGBVF=y
CONFIG_IXGB=y
CONFIG_IXGBE=y
# CONFIG_IXGBE_HWMON is not set
# CONFIG_IXGBE_DCA is not set
# CONFIG_IXGBE_DCB is not set
CONFIG_I40E=y
CONFIG_NET_VENDOR_I825XX=y
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
CONFIG_SKY2=y
CONFIG_SKY2_DEBUG=y
# CONFIG_NET_VENDOR_MELLANOX is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MICROCHIP is not set
# CONFIG_NET_VENDOR_MYRI is not set
CONFIG_FEALNX=y
CONFIG_NET_VENDOR_NATSEMI=y
CONFIG_NATSEMI=y
CONFIG_NS83820=y
CONFIG_NET_VENDOR_8390=y
CONFIG_PCMCIA_AXNET=y
CONFIG_NE2K_PCI=y
CONFIG_PCMCIA_PCNET=y
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
CONFIG_PCH_GBE=y
CONFIG_ETHOC=y
# CONFIG_NET_PACKET_ENGINE is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
# CONFIG_NET_VENDOR_REALTEK is not set
CONFIG_SH_ETH=y
CONFIG_NET_VENDOR_RDC=y
CONFIG_R6040=y
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
CONFIG_SC92031=y
CONFIG_NET_VENDOR_SIS=y
CONFIG_SIS900=y
CONFIG_SIS190=y
CONFIG_SFC=y
# CONFIG_SFC_MTD is not set
# CONFIG_SFC_MCDI_MON is not set
CONFIG_SFC_SRIOV=y
CONFIG_NET_VENDOR_SMSC=y
CONFIG_PCMCIA_SMC91C92=y
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
CONFIG_SMSC9420=y
# CONFIG_NET_VENDOR_STMICRO is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
CONFIG_SUNGEM=y
CONFIG_CASSINI=y
# CONFIG_NIU is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
CONFIG_NET_VENDOR_XIRCOM=y
CONFIG_PCMCIA_XIRC2PS=y
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
# CONFIG_AMD_PHY is not set
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
CONFIG_CICADA_PHY=y
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
# CONFIG_BCM87XX_PHY is not set
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MICREL_PHY=y
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_GPIO=y
# CONFIG_MICREL_KS8995MA is not set
# CONFIG_PLIP is not set
CONFIG_PPP=y
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=y
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPPOATM=y
# CONFIG_PPPOE is not set
CONFIG_PPTP=y
CONFIG_PPPOL2TP=y
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
# CONFIG_SLIP is not set
CONFIG_SLHC=y

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_RTL8152=y
# CONFIG_USB_USBNET is not set
CONFIG_USB_IPHETH=y
# CONFIG_WLAN is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=y
CONFIG_WIMAX_I2400M_USB=y
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
# CONFIG_WAN is not set
CONFIG_VMXNET3=y
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
CONFIG_ISDN_CAPI=y
# CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON is not set
CONFIG_CAPI_TRACE=y
# CONFIG_ISDN_CAPI_MIDDLEWARE is not set
CONFIG_ISDN_CAPI_CAPI20=y

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
CONFIG_ISDN_DRV_AVMB1_B1PCI=y
# CONFIG_ISDN_DRV_AVMB1_B1PCIV4 is not set
# CONFIG_ISDN_DRV_AVMB1_B1PCMCIA is not set
CONFIG_ISDN_DRV_AVMB1_T1PCI=y
# CONFIG_ISDN_DRV_AVMB1_C4 is not set
# CONFIG_CAPI_EICON is not set
CONFIG_ISDN_DRV_GIGASET=y
CONFIG_GIGASET_CAPI=y
# CONFIG_GIGASET_DUMMYLL is not set
# CONFIG_GIGASET_BASE is not set
# CONFIG_GIGASET_M105 is not set
CONFIG_GIGASET_M101=y
# CONFIG_GIGASET_DEBUG is not set
# CONFIG_MISDN is not set

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
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5588=y
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
CONFIG_KEYBOARD_LKKBD=y
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
CONFIG_KEYBOARD_TCA6416=y
CONFIG_KEYBOARD_TCA8418=y
CONFIG_KEYBOARD_MATRIX=y
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_OPENCORES=y
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_XTKBD=y
# CONFIG_INPUT_LEDS is not set
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
CONFIG_MOUSE_BCM5974=y
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=y
CONFIG_MOUSE_SYNAPTICS_USB=y
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
# CONFIG_JOYSTICK_GRIP is not set
CONFIG_JOYSTICK_GRIP_MP=y
# CONFIG_JOYSTICK_GUILLEMOT is not set
CONFIG_JOYSTICK_INTERACT=y
# CONFIG_JOYSTICK_SIDEWINDER is not set
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=y
# CONFIG_JOYSTICK_IFORCE_USB is not set
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
# CONFIG_JOYSTICK_DB9 is not set
CONFIG_JOYSTICK_GAMECON=y
CONFIG_JOYSTICK_TURBOGRAFX=y
# CONFIG_JOYSTICK_AS5011 is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
CONFIG_JOYSTICK_XPAD=y
CONFIG_JOYSTICK_XPAD_FF=y
# CONFIG_JOYSTICK_XPAD_LEDS is not set
CONFIG_JOYSTICK_WALKERA0701=y
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
CONFIG_TABLET_USB_AIPTEK=y
CONFIG_TABLET_USB_GTCO=y
CONFIG_TABLET_USB_HANWANG=y
# CONFIG_TABLET_USB_KBTAB is not set
CONFIG_TABLET_USB_WACOM=y
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM80X_ONKEY=y
CONFIG_INPUT_AD714X=y
CONFIG_INPUT_AD714X_I2C=y
CONFIG_INPUT_AD714X_SPI=y
CONFIG_INPUT_BMA150=y
CONFIG_INPUT_PCSPKR=y
# CONFIG_INPUT_MAX8925_ONKEY is not set
CONFIG_INPUT_MC13783_PWRBUTTON=y
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=y
CONFIG_INPUT_GPIO_TILT_POLLED=y
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=y
# CONFIG_INPUT_KXTJ9_POLLED_MODE is not set
CONFIG_INPUT_POWERMATE=y
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_RETU_PWRBUTTON=y
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_PCF50633_PMU is not set
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
# CONFIG_INPUT_DA9055_ONKEY is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_IMS_PCU is not set
CONFIG_INPUT_CMA3000=y
CONFIG_INPUT_CMA3000_I2C=y
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=y
CONFIG_CYCLADES=y
CONFIG_CYZ_INTR=y
CONFIG_MOXA_INTELLIO=y
# CONFIG_MOXA_SMARTIO is not set
CONFIG_SYNCLINK=y
CONFIG_SYNCLINKMP=y
CONFIG_SYNCLINK_GT=y
CONFIG_NOZOMI=y
CONFIG_ISI=y
# CONFIG_N_HDLC is not set
CONFIG_N_GSM=y
CONFIG_TRACE_ROUTER=y
CONFIG_TRACE_SINK=y
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
# CONFIG_SERIAL_8250_DMA is not set
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_MAX310X=y
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_UARTLITE=y
# CONFIG_SERIAL_UARTLITE_CONSOLE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS=y
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
CONFIG_SERIAL_IFX6X60=y
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
CONFIG_TTY_PRINTK=y
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
CONFIG_CARDMAN_4040=y
CONFIG_IPWIRELESS=y
# CONFIG_MWAVE is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=y
CONFIG_TCG_TIS_I2C_INFINEON=y
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
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
CONFIG_I2C_MUX_PCA954x=y
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=y
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_ISMT=y
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_VIA=y
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
CONFIG_I2C_DESIGNWARE_PCI=y
CONFIG_I2C_EG20T=y
CONFIG_I2C_GPIO=y
CONFIG_I2C_KEMPLD=y
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT=y
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIPERBOARD is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_SCx200_ACB is not set
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
# CONFIG_SPI_BUTTERFLY is not set
CONFIG_SPI_GPIO=y
CONFIG_SPI_LM70_LLP=y
CONFIG_SPI_OC_TINY=y
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=y
CONFIG_SPI_PXA2XX_PCI=y
# CONFIG_SPI_SC18IS602 is not set
CONFIG_SPI_TOPCLIFF_PCH=y
CONFIG_SPI_XCOMM=y
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
CONFIG_SPI_TLE62X0=y
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
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_DA9055=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=y
# CONFIG_GPIO_F7188X is not set
CONFIG_GPIO_TS5500=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_RC5T583=y
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_WM8350=y
CONFIG_GPIO_WM8994=y
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_INTEL_MID=y
# CONFIG_GPIO_PCH is not set
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_TIMBERDALE=y
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MCP23S08 is not set
# CONFIG_GPIO_MC33880 is not set
CONFIG_GPIO_74X164=y

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
# CONFIG_GPIO_JANZ_TTL is not set
# CONFIG_GPIO_PALMAS is not set
# CONFIG_GPIO_TPS6586X is not set

#
# USB GPIO expanders:
#
CONFIG_GPIO_VIPERBOARD=y
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
# CONFIG_W1_MASTER_DS2490 is not set
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
# CONFIG_W1_SLAVE_DS2780 is not set
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
# CONFIG_MAX8925_POWER is not set
# CONFIG_WM8350_POWER is not set
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2760=y
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9030=y
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
# CONFIG_CHARGER_PCF50633 is not set
# CONFIG_CHARGER_ISP1704 is not set
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
# CONFIG_CHARGER_BQ24735 is not set
CONFIG_CHARGER_SMB347=y
CONFIG_CHARGER_TPS65090=y
CONFIG_POWER_RESET=y
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7314=y
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADCXX=y
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_G762=y
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IIO_HWMON=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX1111=y
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
CONFIG_SENSORS_VIA686A=y
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
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM8350=y
CONFIG_SENSORS_APPLESMC=y
# CONFIG_SENSORS_MC13783_ADC is not set

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
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
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
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
# CONFIG_MFD_CROS_EC is not set
CONFIG_PMIC_DA903X=y
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
# CONFIG_MFD_MAX8907 is not set
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
# CONFIG_PCF50633_GPIO is not set
# CONFIG_MFD_RDC321X is not set
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RC5T583=y
CONFIG_MFD_SEC_CORE=y
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_ARIZONA_SPI=y
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
# CONFIG_MFD_WM8997 is not set
CONFIG_MFD_WM8400=y
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_88PM800=y
# CONFIG_REGULATOR_AD5398 is not set
# CONFIG_REGULATOR_ANATOP is not set
CONFIG_REGULATOR_AAT2870=y
CONFIG_REGULATOR_DA903X=y
# CONFIG_REGULATOR_DA9055 is not set
CONFIG_REGULATOR_DA9210=y
# CONFIG_REGULATOR_FAN53555 is not set
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
# CONFIG_REGULATOR_LP8755 is not set
# CONFIG_REGULATOR_LP8788 is not set
# CONFIG_REGULATOR_MAX1586 is not set
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
# CONFIG_REGULATOR_MAX8997 is not set
# CONFIG_REGULATOR_MAX8998 is not set
CONFIG_REGULATOR_MAX77686=y
CONFIG_REGULATOR_MAX77693=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
# CONFIG_REGULATOR_MC13892 is not set
CONFIG_REGULATOR_PALMAS=y
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
# CONFIG_REGULATOR_RC5T583 is not set
# CONFIG_REGULATOR_S2MPS11 is not set
CONFIG_REGULATOR_S5M8767=y
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65090=y
CONFIG_REGULATOR_TPS65217=y
# CONFIG_REGULATOR_TPS6524X is not set
# CONFIG_REGULATOR_TPS6586X is not set
CONFIG_REGULATOR_TPS80031=y
CONFIG_REGULATOR_WM8350=y
CONFIG_REGULATOR_WM8400=y
# CONFIG_REGULATOR_WM8994 is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
# CONFIG_DRM_I2C_SIL164 is not set
CONFIG_DRM_I2C_NXP_TDA998X=y
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_UMS=y
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
CONFIG_DRM_MGA=y
CONFIG_DRM_VIA=y
# CONFIG_DRM_SAVAGE is not set
CONFIG_DRM_VMWGFX=y
CONFIG_DRM_VMWGFX_FBCON=y
CONFIG_DRM_GMA500=y
CONFIG_DRM_GMA600=y
CONFIG_DRM_GMA3600=y
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=y
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
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
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
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
CONFIG_FB_CYBER2000=y
CONFIG_FB_CYBER2000_DDC=y
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
CONFIG_FB_S1D13XXX=y
# CONFIG_FB_NVIDIA is not set
CONFIG_FB_RIVA=y
CONFIG_FB_RIVA_I2C=y
CONFIG_FB_RIVA_DEBUG=y
CONFIG_FB_RIVA_BACKLIGHT=y
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=y
# CONFIG_FB_ATY_CT is not set
# CONFIG_FB_ATY_GX is not set
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=y
CONFIG_FB_S3_DDC=y
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=y
CONFIG_FB_VIA_DIRECT_PROCFS=y
CONFIG_FB_VIA_X_COMPATIBILITY=y
# CONFIG_FB_NEOMAGIC is not set
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
CONFIG_FB_3DFX_ACCEL=y
# CONFIG_FB_3DFX_I2C is not set
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=y
CONFIG_FB_TMIO_ACCELL=y
CONFIG_FB_SMSCUFX=y
# CONFIG_FB_UDL is not set
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
CONFIG_FB_BROADSHEET=y
# CONFIG_FB_AUO_K190X is not set
# CONFIG_FB_SIMPLE is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_LM3533 is not set
CONFIG_BACKLIGHT_PWM=y
CONFIG_BACKLIGHT_DA903X=y
# CONFIG_BACKLIGHT_MAX8925 is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_PCF50633=y
CONFIG_BACKLIGHT_AAT2870=y
# CONFIG_BACKLIGHT_LM3630A is not set
CONFIG_BACKLIGHT_LM3639=y
# CONFIG_BACKLIGHT_LP855X is not set
CONFIG_BACKLIGHT_LP8788=y
CONFIG_BACKLIGHT_TPS65217=y
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
# CONFIG_HID_EZKEY is not set
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MICROSOFT is not set
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_ORTEK=y
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=y
# CONFIG_HID_PICOLCD_FB is not set
# CONFIG_HID_PICOLCD_BACKLIGHT is not set
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SPEEDLINK=y
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=y
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
# CONFIG_USB_HID is not set
CONFIG_HID_PID=y

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=y
# CONFIG_USB_MOUSE is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB_CBAF=y
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_FUSBH200_HCD=y
CONFIG_USB_FOTG210_HCD=y
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_PCI is not set
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=y
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_HCD_ISO is not set
CONFIG_USB_SL811_CS=y
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_HCD_TEST_MODE=y
CONFIG_USB_MUSB_HDRC=y
# CONFIG_USB_MUSB_HOST is not set
# CONFIG_USB_MUSB_GADGET is not set
CONFIG_USB_MUSB_DUAL_ROLE=y
CONFIG_USB_MUSB_TUSB6010=y
# CONFIG_USB_MUSB_UX500 is not set
CONFIG_MUSB_PIO_ONLY=y
# CONFIG_USB_RENESAS_USBHS is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
# CONFIG_USB_STORAGE is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
# CONFIG_USB_MICROTEK is not set
CONFIG_USB_DWC3=y
# CONFIG_USB_DWC3_HOST is not set
# CONFIG_USB_DWC3_GADGET is not set
CONFIG_USB_DWC3_DUAL_ROLE=y

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_OMAP=y
# CONFIG_USB_DWC3_EXYNOS is not set
CONFIG_USB_DWC3_PCI=y

#
# Debugging features
#
CONFIG_USB_DWC3_DEBUG=y
# CONFIG_USB_DWC3_VERBOSE is not set
CONFIG_USB_CHIPIDEA=y
CONFIG_USB_CHIPIDEA_UDC=y
CONFIG_USB_CHIPIDEA_HOST=y
CONFIG_USB_CHIPIDEA_DEBUG=y

#
# USB port drivers
#
CONFIG_USB_USS720=y
CONFIG_USB_SERIAL=y
# CONFIG_USB_SERIAL_CONSOLE is not set
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_SIMPLE=y
CONFIG_USB_SERIAL_AIRCABLE=y
CONFIG_USB_SERIAL_ARK3116=y
CONFIG_USB_SERIAL_BELKIN=y
CONFIG_USB_SERIAL_CH341=y
CONFIG_USB_SERIAL_WHITEHEAT=y
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
CONFIG_USB_SERIAL_CP210X=y
CONFIG_USB_SERIAL_CYPRESS_M8=y
# CONFIG_USB_SERIAL_EMPEG is not set
CONFIG_USB_SERIAL_FTDI_SIO=y
CONFIG_USB_SERIAL_VISOR=y
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
CONFIG_USB_SERIAL_F81232=y
CONFIG_USB_SERIAL_GARMIN=y
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
CONFIG_USB_SERIAL_KLSI=y
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
CONFIG_USB_SERIAL_METRO=y
CONFIG_USB_SERIAL_MOS7720=y
# CONFIG_USB_SERIAL_MOS7715_PARPORT is not set
CONFIG_USB_SERIAL_MOS7840=y
CONFIG_USB_SERIAL_NAVMAN=y
# CONFIG_USB_SERIAL_PL2303 is not set
CONFIG_USB_SERIAL_OTI6858=y
CONFIG_USB_SERIAL_QCAUX=y
# CONFIG_USB_SERIAL_QUALCOMM is not set
CONFIG_USB_SERIAL_SPCP8X5=y
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
CONFIG_USB_SERIAL_SYMBOL=y
CONFIG_USB_SERIAL_TI=y
CONFIG_USB_SERIAL_CYBERJACK=y
# CONFIG_USB_SERIAL_XIRCOM is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
CONFIG_USB_SERIAL_OPTICON=y
CONFIG_USB_SERIAL_XSENS_MT=y
CONFIG_USB_SERIAL_WISHBONE=y
CONFIG_USB_SERIAL_ZTE=y
CONFIG_USB_SERIAL_SSU100=y
CONFIG_USB_SERIAL_QT2=y
CONFIG_USB_SERIAL_DEBUG=y

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
# CONFIG_USB_EMI26 is not set
CONFIG_USB_ADUTUX=y
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
# CONFIG_USB_APPLEDISPLAY is not set
CONFIG_USB_SISUSBVGA=y
CONFIG_USB_LD=y
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=y
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
CONFIG_USB_ISIGHTFW=y
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=y
# CONFIG_USB_ATM is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
CONFIG_SAMSUNG_USB3PHY=y
# CONFIG_USB_GPIO_VBUS is not set
CONFIG_USB_ISP1301=y
# CONFIG_USB_RCAR_PHY is not set
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_DEBUG=y
CONFIG_USB_GADGET_VERBOSE=y
CONFIG_USB_GADGET_DEBUG_FILES=y
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FUSB300=y
# CONFIG_USB_FOTG210_UDC is not set
CONFIG_USB_R8A66597=y
CONFIG_USB_PXA27X=y
# CONFIG_USB_MV_UDC is not set
CONFIG_USB_MV_U3D=y
CONFIG_USB_M66592=y
CONFIG_USB_AMD5536UDC=y
# CONFIG_USB_NET2272 is not set
CONFIG_USB_NET2280=y
CONFIG_USB_GOKU=y
CONFIG_USB_EG20T=y
# CONFIG_USB_DUMMY_HCD is not set
CONFIG_USB_LIBCOMPOSITE=y
CONFIG_USB_U_ETHER=y
CONFIG_USB_F_NCM=y
# CONFIG_USB_CONFIGFS is not set
# CONFIG_USB_ZERO is not set
# CONFIG_USB_ETH is not set
CONFIG_USB_G_NCM=y
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_MASS_STORAGE is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
# CONFIG_MMC_BLOCK_BOUNCE is not set
# CONFIG_SDIO_UART is not set
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
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_SDRICOH_CS=y
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MMC_VUB300=y
CONFIG_MMC_USHC=y
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
CONFIG_LEDS_PCA9532=y
CONFIG_LEDS_PCA9532_GPIO=y
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_LP8788=y
CONFIG_LEDS_CLEVO_MAIL=y
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_PCA9685 is not set
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DA903X=y
# CONFIG_LEDS_DAC124S085 is not set
CONFIG_LEDS_PWM=y
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_MAX8997=y
# CONFIG_LEDS_LM355x is not set
CONFIG_LEDS_OT200=y
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
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
# CONFIG_DW_DMAC is not set
# CONFIG_DW_DMAC_PCI is not set
CONFIG_TIMB_DMA=y
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
CONFIG_DCA=y
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=y
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=y
CONFIG_CFAG12864B_RATE=20
CONFIG_UIO=y
CONFIG_UIO_CIF=y
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y
CONFIG_UIO_MF624=y
CONFIG_VIRT_DRIVERS=y
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
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
CONFIG_ET131X=y
CONFIG_SLICOSS=y
# CONFIG_USBIP_CORE is not set
CONFIG_ECHO=y
CONFIG_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
# CONFIG_PANEL_CHANGE_MESSAGE is not set
# CONFIG_RTS5139 is not set
# CONFIG_TRANZPORT is not set
CONFIG_USB_SERIAL_QUATECH2=y
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#

#
# Accelerometers
#
# CONFIG_ADIS16201 is not set
# CONFIG_ADIS16203 is not set
# CONFIG_ADIS16204 is not set
# CONFIG_ADIS16209 is not set
CONFIG_ADIS16220=y
CONFIG_ADIS16240=y
# CONFIG_LIS3L02DQ is not set
CONFIG_SCA3000=y

#
# Analog to digital converters
#
# CONFIG_AD7291 is not set
CONFIG_AD7606=y
# CONFIG_AD7606_IFACE_PARALLEL is not set
CONFIG_AD7606_IFACE_SPI=y
# CONFIG_AD799X is not set
CONFIG_AD7780=y
CONFIG_AD7816=y
CONFIG_AD7192=y
# CONFIG_AD7280 is not set

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=y
CONFIG_ADT7316_SPI=y
CONFIG_ADT7316_I2C=y

#
# Capacitance to digital converters
#
CONFIG_AD7150=y
CONFIG_AD7152=y
CONFIG_AD7746=y

#
# Direct Digital Synthesis
#
CONFIG_AD5930=y
# CONFIG_AD9832 is not set
CONFIG_AD9834=y
# CONFIG_AD9850 is not set
CONFIG_AD9852=y
CONFIG_AD9910=y
CONFIG_AD9951=y

#
# Digital gyroscope sensors
#
CONFIG_ADIS16060=y

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=y

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=y
CONFIG_SENSORS_ISL29028=y
CONFIG_TSL2583=y
CONFIG_TSL2x7x=y

#
# Magnetometer sensors
#
CONFIG_SENSORS_HMC5843=y

#
# Active energy metering IC
#
CONFIG_ADE7753=y
CONFIG_ADE7754=y
CONFIG_ADE7758=y
# CONFIG_ADE7759 is not set
CONFIG_ADE7854=y
CONFIG_ADE7854_I2C=y
CONFIG_ADE7854_SPI=y

#
# Resolver to digital converters
#
# CONFIG_AD2S90 is not set
CONFIG_AD2S1200=y
CONFIG_AD2S1210=y

#
# Triggers - standalone
#
CONFIG_IIO_DUMMY_EVGEN=y
CONFIG_IIO_SIMPLE_DUMMY=y
CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
CONFIG_ZSMALLOC=y
CONFIG_ZRAM=y
CONFIG_ZRAM_DEBUG=y
CONFIG_FB_SM7XX=y
CONFIG_CRYSTALHD=y
CONFIG_FB_XGI=y
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_BCM_WIMAX is not set
CONFIG_FT1000=y
CONFIG_FT1000_USB=y
# CONFIG_FT1000_PCMCIA is not set

#
# Speakup console speech
#
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
CONFIG_ASHMEM=y
CONFIG_ANDROID_LOGGER=y
# CONFIG_ANDROID_TIMED_OUTPUT is not set
# CONFIG_ANDROID_LOW_MEMORY_KILLER is not set
# CONFIG_SYNC is not set
CONFIG_USB_WPAN_HCD=y
CONFIG_WIMAX_GDM72XX=y
# CONFIG_WIMAX_GDM72XX_QOS is not set
CONFIG_WIMAX_GDM72XX_K_MODE=y
CONFIG_WIMAX_GDM72XX_WIMAX2=y
CONFIG_WIMAX_GDM72XX_USB=y
# CONFIG_WIMAX_GDM72XX_SDIO is not set
CONFIG_WIMAX_GDM72XX_USB_PM=y
# CONFIG_NET_VENDOR_SILICOM is not set
# CONFIG_CED1401 is not set
CONFIG_DGRP=y
CONFIG_FIREWIRE_SERIAL=y
CONFIG_MTD_SPINAND_MT29F=y
CONFIG_MTD_SPINAND_ONDIEECC=y
CONFIG_USB_DWC2=y
# CONFIG_USB_DWC2_DEBUG is not set
CONFIG_USB_DWC2_TRACK_MISSED_SOFS=y
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
CONFIG_DGAP=y
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_CHROMEOS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WMI is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ASUS_WMI is not set
CONFIG_ACPI_WMI=y
# CONFIG_MSI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=y
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
# CONFIG_ARM_ARCH_TIMER_EVTSTREAM is not set
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
# CONFIG_EXTCON_ADC_JACK is not set
# CONFIG_EXTCON_MAX77693 is not set
CONFIG_EXTCON_MAX8997=y
# CONFIG_EXTCON_PALMAS is not set
CONFIG_MEMORY=y
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
CONFIG_BMA180=y
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y
CONFIG_IIO_ST_ACCEL_SPI_3AXIS=y
CONFIG_KXSD9=y

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
CONFIG_AD7266=y
CONFIG_AD7298=y
CONFIG_AD7476=y
CONFIG_AD7791=y
# CONFIG_AD7793 is not set
CONFIG_AD7887=y
# CONFIG_AD7923 is not set
# CONFIG_LP8788_ADC is not set
CONFIG_MAX1363=y
CONFIG_MCP320X=y
CONFIG_MCP3422=y
# CONFIG_NAU7802 is not set
CONFIG_TI_ADC081C=y
CONFIG_VIPERBOARD_ADC=y

#
# Amplifiers
#
# CONFIG_AD8366 is not set

#
# Hid Sensor IIO Common
#
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_SPI=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
CONFIG_AD5360=y
CONFIG_AD5380=y
# CONFIG_AD5421 is not set
# CONFIG_AD5446 is not set
CONFIG_AD5449=y
# CONFIG_AD5504 is not set
CONFIG_AD5624R_SPI=y
CONFIG_AD5686=y
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
# CONFIG_ADF4350 is not set

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
# CONFIG_ITG3200 is not set

#
# Inertial measurement units
#
# CONFIG_ADIS16400 is not set
# CONFIG_ADIS16480 is not set
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y
CONFIG_INV_MPU6050_IIO=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
CONFIG_APDS9300=y
CONFIG_CM36651=y
# CONFIG_GP2AP020A00F is not set
CONFIG_SENSORS_LM3533=y
# CONFIG_TCS3472 is not set
# CONFIG_SENSORS_TSL2563 is not set
CONFIG_TSL4531=y
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
# CONFIG_MAG3110 is not set
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
CONFIG_IIO_ST_MAGN_SPI_3AXIS=y

#
# Triggers - standalone
#
# CONFIG_IIO_INTERRUPT_TRIGGER is not set
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure sensors
#
# CONFIG_IIO_ST_PRESS is not set

#
# Temperature sensors
#
# CONFIG_TMP006 is not set
CONFIG_NTB=y
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
# CONFIG_VME_TSI148 is not set

#
# VME Board Drivers
#
# CONFIG_VMIVME_7805 is not set

#
# VME Device Drivers
#
CONFIG_VME_USER=y
CONFIG_VME_PIO2=y
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
CONFIG_SERIAL_IPOCTAL=y
CONFIG_RESET_CONTROLLER=y
# CONFIG_FMC is not set
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_DMIID is not set
CONFIG_DMI_SYSFS=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
# CONFIG_GOOGLE_SMI is not set
CONFIG_GOOGLE_MEMCONSOLE=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4_USE_FOR_EXT23 is not set
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_PROC_INFO=y
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
# CONFIG_JFS_SECURITY is not set
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=y
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
# CONFIG_OCFS2_FS_USERSPACE_CLUSTER is not set
CONFIG_OCFS2_FS_STATS=y
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
CONFIG_OCFS2_DEBUG_FS=y
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y
CONFIG_BTRFS_DEBUG=y
CONFIG_BTRFS_ASSERT=y
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=y
CONFIG_CACHEFILES_DEBUG=y
CONFIG_CACHEFILES_HISTOGRAM=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
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
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
# CONFIG_PROC_VMCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V2=y
# CONFIG_NFS_V3 is not set
# CONFIG_NFS_V4 is not set
# CONFIG_NFS_SWAP is not set
# CONFIG_ROOT_NFS is not set
CONFIG_NFS_FSCACHE=y
CONFIG_NFS_DEBUG=y
# CONFIG_NFSD is not set
CONFIG_LOCKD=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
# CONFIG_RPCSEC_GSS_KRB5 is not set
CONFIG_SUNRPC_DEBUG=y
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=y
CONFIG_CIFS_STATS=y
# CONFIG_CIFS_STATS2 is not set
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_ACL=y
CONFIG_CIFS_DEBUG=y
CONFIG_CIFS_DEBUG2=y
# CONFIG_CIFS_DFS_UPCALL is not set
CONFIG_CIFS_SMB2=y
# CONFIG_CIFS_FSCACHE is not set
CONFIG_NCP_FS=y
# CONFIG_NCPFS_PACKET_SIGNING is not set
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
CONFIG_NCPFS_NFS_NS=y
# CONFIG_NCPFS_OS2_NS is not set
CONFIG_NCPFS_SMALLDOS=y
# CONFIG_NCPFS_NLS is not set
CONFIG_NCPFS_EXTRAS=y
CONFIG_CODA_FS=y
CONFIG_AFS_FS=y
CONFIG_AFS_DEBUG=y
CONFIG_AFS_FSCACHE=y
CONFIG_9P_FS=y
CONFIG_9P_FSCACHE=y
# CONFIG_9P_FS_POSIX_ACL is not set
CONFIG_9P_FS_SECURITY=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
# CONFIG_DLM_DEBUG is not set

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
CONFIG_DYNAMIC_DEBUG=y

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
CONFIG_HEADERS_CHECK=y
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
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_DEBUG_SLAB=y
# CONFIG_DEBUG_SLAB_LEAK is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_DEBUG_HIGHMEM=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_SCHED_DEBUG is not set
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
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
CONFIG_LKDTM=y
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DOUBLEFAULT is not set
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
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
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
CONFIG_SECURITY_PATH=y
CONFIG_LSM_MMAP_MIN_ADDR=65536
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
# CONFIG_SECURITY_SELINUX_DISABLE is not set
# CONFIG_SECURITY_SELINUX_DEVELOP is not set
# CONFIG_SECURITY_SELINUX_AVC_STATS is not set
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
CONFIG_SECURITY_SMACK=y
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
# CONFIG_SECURITY_APPARMOR_HASH is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_YAMA_STACKED is not set
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
CONFIG_INTEGRITY_AUDIT=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_LSM_RULES=y
# CONFIG_IMA_TEMPLATE is not set
# CONFIG_IMA_NG_TEMPLATE is not set
CONFIG_IMA_SIG_TEMPLATE=y
CONFIG_IMA_DEFAULT_TEMPLATE="ima-sig"
# CONFIG_IMA_DEFAULT_HASH_SHA1 is not set
# CONFIG_IMA_DEFAULT_HASH_SHA256 is not set
# CONFIG_IMA_DEFAULT_HASH_SHA512 is not set
CONFIG_IMA_DEFAULT_HASH_WP512=y
CONFIG_IMA_DEFAULT_HASH="wp512"
CONFIG_IMA_APPRAISE=y
CONFIG_EVM=y
CONFIG_EVM_HMAC_VERSION=2
# CONFIG_DEFAULT_SECURITY_SELINUX is not set
# CONFIG_DEFAULT_SECURITY_SMACK is not set
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
# CONFIG_DEFAULT_SECURITY_YAMA is not set
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
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
# CONFIG_CRYPTO_PCRYPT is not set
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
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
# CONFIG_CRYPTO_XTS is not set

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
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
# CONFIG_X509_CERTIFICATE_PARSER is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
# CONFIG_KVM_AMD is not set
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
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
# CONFIG_CRC64_ECMA is not set
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=y

--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--HlL+5n6rz5pIUxbD--
