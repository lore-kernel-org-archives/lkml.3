Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646Ab3CGOMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 09:12:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:37449 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932149Ab3CGOMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 09:12:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,803,1355126400"; 
   d="log'?scan'208";a="296803521"
Date: Thu, 7 Mar 2013 22:12:24 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: fengguang.wu@intel.com, Nathan Zimmer <nzimmer@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: [procfs] BUG: sleeping function called from invalid context at
 mm/slub.c:925
Message-ID: <20130307141224.GA6506@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit a21813be23329e2788164eab532e79cb0e513cfc
Author: Nathan Zimmer <nzimmer@sgi.com>
Date:   Sat Mar 2 15:25:37 2013 +1100

    procfs: improve scaling in proc
    
    I am currently tracking a hotlock reported by a customer on a large
    system, 512 cores.  I am currently running 3.8-rc7 but the issue looks
    like it has been this way for a very long time.  The offending lock is
    proc_dir_entry->pde_unload_lock.
    
    This patch converts the lock to use rcu.  However the pde_openers list
    still is controlled by a spin lock.  I tested on a 4096 machine and the
    lock doesn't seem hot at least according to perf.
    
    This is a refresh of what was orignally suggested by Eric Dumazet some
    time ago.  I have also taken in some comments from Andrew and several
    other people whose names escape me but I am quite grateful too.
    
    Supporting numbers, lower is better, they are from the test I posted earlier.
    cpuinfo baseline        Rcu
    tasks   read-sec        read-sec
    1       0.0141          0.0141
    2       0.0140          0.0142
    4       0.0140          0.0141
    8       0.0145          0.0140
    16      0.0553          0.0168
    32      0.1688          0.0549
    64      0.5017          0.1690
    128     1.7005          0.5038
    256     5.2513          2.0804
    512     8.0529          3.0162
    
    Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
    Cc: "Eric W. Biederman" <ebiederm@xmission.com>
    Cc: Eric Dumazet <eric.dumazet@gmail.com>
    Cc: Alexander Viro <viro@zeniv.linux.org.uk>
    Cc: David Woodhouse <dwmw2@infradead.org>
    Cc: Alexey Dobriyan <adobriyan@gmail.com>
    Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

[   78.994163] atkbd: probe of serio1 rejects match -19
[   79.196148] Freeing unused kernel memory: 664k freed
[   80.786460] BUG: sleeping function called from invalid context at /c/kernel-tests/src/tip/mm/slub.c:925
[   80.787886] in_atomic(): 0, irqs_disabled(): 0, pid: 29, name: modprobe
[   80.789636] 2 locks held by modprobe/29:
[   80.790343]  #0:  (rcu_read_lock){.+.+.+}, at: [<ffffffff8117347b>] rcu_read_lock+0x0/0xbc
[   80.794346]  #1:  (rcu_read_lock){.+.+.+}, at: [<ffffffff8117347b>] rcu_read_lock+0x0/0xbc
[   80.797089] Pid: 29, comm: modprobe Not tainted 3.9.0-rc1-01618-gdf2363d #223
[   80.798113] Call Trace:
[   80.798856]  [<ffffffff8106fc60>] __might_sleep+0x266/0x275
[   80.799830]  [<ffffffff81146311>] ? single_open+0x30/0xb6
[   80.801733]  [<ffffffff811132fd>] slab_pre_alloc_hook.isra.48+0x42/0x4f
[   80.802779]  [<ffffffff81114f7b>] kmem_cache_alloc+0x2a/0xf6
[   80.803746]  [<ffffffff8117e899>] ? cmdline_proc_open+0x25/0x25
[   80.805383]  [<ffffffff81146311>] single_open+0x30/0xb6
[   80.806281]  [<ffffffff810c05df>] ? rcu_is_cpu_idle+0x42/0x8a
[   80.807242]  [<ffffffff8114556d>] ? seq_release_private+0x59/0x59
[   80.808865]  [<ffffffff8117e890>] cmdline_proc_open+0x1c/0x25
[   80.809811]  [<ffffffff811738e6>] proc_reg_open+0x128/0x1e3
[   80.810684]  [<ffffffff811737be>] ? proc_reg_release+0x246/0x246
[   80.811602]  [<ffffffff81119d82>] do_dentry_open+0x228/0x34a
[   80.813260]  [<ffffffff8112a226>] ? __inode_permission+0x115/0x12b
[   80.814223]  [<ffffffff81119f00>] finish_open+0x5c/0x7a
[   80.815056]  [<ffffffff8112b5bb>] do_last.isra.16+0xbcc/0xecb
[   80.815945]  [<ffffffff8112a2bd>] ? inode_permission+0x81/0x8a
[   80.817660]  [<ffffffff8112cfa6>] path_openat.isra.17+0xf0/0x494
[   80.818623]  [<ffffffff8112e7c6>] do_filp_open+0x3a/0xad
[   80.819475]  [<ffffffff8113eef6>] ? __alloc_fd+0x25e/0x277
[   80.821142]  [<ffffffff8111b4dd>] do_sys_open+0x91/0x17b
[   80.822065]  [<ffffffff8111b5f2>] SyS_open+0x2b/0x3b
[   80.822873]  [<ffffffff813d6f6b>] system_call_fastpath+0x1a/0x1f
[   80.827403] 
[   80.827765] ================================================

git bisect start df2363d9ad7ffd43b5e86604c7a28f4adc6bd75e 725a7c316ea0d1329b630e31f82d0a2e762e0a65 --
git bisect good 62159550cf357e60632a7ac147b4c66b1e2b0630  #    18  2013-03-07 21:37:08  freezer: do not send a fake signal to a PF_DUMPCORE thread
git bisect  bad bcbe478b5a2c1c5831dbe1c31d4b6a7d7438ccee  #     0  2013-03-07 21:39:14  aio: kill struct aio_ring_info
git bisect  bad 93102c910da3c99169b97ed03fdd53c64eadc284  #     0  2013-03-07 21:41:16  gadget: remove only user of aio retry
git bisect  bad df2c264613410a2f59d4f13082207d5e4c0381fe  #     0  2013-03-07 21:43:13  ipc: set EFAULT as default error in load_msg()
git bisect  bad 1b716364563aa3fcd04eddea6fe08bd49574ec7f  #     0  2013-03-07 21:44:39  kexec: Use min() and min_t() to simplify logic
git bisect  bad a21813be23329e2788164eab532e79cb0e513cfc  #     0  2013-03-07 21:46:14  procfs: improve scaling in proc
git bisect good c391a36c9b415f3276d1059594a635e66d3f5d7a  #    12  2013-03-07 21:47:58  coredump: make wait_for_dump_helpers() freezable
git bisect good c391a36c9b415f3276d1059594a635e66d3f5d7a  #    38  2013-03-07 21:49:41  coredump: make wait_for_dump_helpers() freezable
git bisect  bad df2363d9ad7ffd43b5e86604c7a28f4adc6bd75e  #     0  2013-03-07 21:51:39  kernel/sys.c: make prctl(PR_SET_MM) generally available
git bisect good 91ce46c0d79238fc84ee5f8c0936d4dcb66d1fd3  #    31  2013-03-07 21:54:23  Revert "procfs: improve scaling in proc"
git bisect  bad 9edbffb58ae00067e264ef70d5141c1d85049029  #     0  2013-03-07 21:57:05  Add linux-next specific files for 20130307

Thanks,
Fengguang

--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-ant-6398-2013-03-07-12-53-09-3.9.0-rc1-01618-gdf2363d-223"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.9.0-rc1-01618-gdf2363d (kbuild@snb) (gcc version 4.7.2 (Debian 4.7.2-4) ) #223 PREEMPT Thu Mar 7 12:50:58 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=next/akpm log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2013-03-07-12-51-38-next:akpm:df2363d9ad7ffd43b5e86604c7a28f4adc6bd75e-df2363d9ad7ffd43b5e86604c7a28f4adc6bd75e-x86_64-randconfig-s009-0306-1-ant noapic nolapic nohz=off BOOT_IMAGE=/kernel/x86_64-randconfig-s009-0306/df2363d9ad7ffd43b5e86604c7a28f4adc6bd75e/vmlinuz-3.9.0-rc1-01618-gdf2363d
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at [ffff8800000fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x024e9000, 0x024e9fff] PGTABLE
[    0.000000] BRK [0x024ea000, 0x024eafff] PGTABLE
[    0.000000] BRK [0x024eb000, 0x024ebfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0e8d5fff]
[    0.000000]  [mem 0x0e800000-0x0e8d5fff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e7fffff]
[    0.000000]  [mem 0x0c000000-0x0e7fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e8d6000-0x0fffdfff]
[    0.000000]  [mem 0x0e8d6000-0x0e9fffff] page 2M
[    0.000000]  [mem 0x0ea00000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x024ec000, 0x024ecfff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128044(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd930 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000000ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000d400000-ffff88000d7fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65424
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3986 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 960 pages used for memmap
[    0.000000]   DMA32 zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1         
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1/0x1 ignored.
[    0.000000] Bus #0 is PCI   
[    0.000000] Bus #1 is ISA   
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 09
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 10, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 14, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 18, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 1c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 20, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 24, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, APIC LINT 01
[    0.000000] Processors: 1
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfffbffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64379
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=next/akpm log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2013-03-07-12-51-38-next:akpm:df2363d9ad7ffd43b5e86604c7a28f4adc6bd75e-df2363d9ad7ffd43b5e86604c7a28f4adc6bd75e-x86_64-randconfig-s009-0306-1-ant noapic nolapic nohz=off BOOT_IMAGE=/kernel/x86_64-randconfig-s009-0306/df2363d9ad7ffd43b5e86604c7a28f4adc6bd75e/vmlinuz-3.9.0-rc1-01618-gdf2363d
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Memory: 203212k/262136k available (3943k kernel code, 440k absent, 58484k reserved, 4973k data, 664k init)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
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
[    0.000000] ODEBUG: 4 of 4 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3192.033 MHz processor
[    0.016704] Calibrating delay loop (skipped), value calculated using timer frequency.. 6384.06 BogoMIPS (lpj=12768132)
[    0.021044] pid_max: default: 32768 minimum: 301
[    0.027085] Security Framework initialized
[    0.032610] Smack:  Initializing.
[    0.037501] Mount-cache hash table entries: 256
[    0.113815] Initializing cgroup subsys debug
[    0.116834] Initializing cgroup subsys devices
[    0.127192] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.127192] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.127192] tlb_flushall_shift: -1
[    0.128296] CPU: AMD QEMU Virtual CPU version 1.1.0 (fam: 06, model: 02, stepping: 03)
[    0.153982] ACPI: Core revision 20130117
[    0.423463] ACPI: All ACPI Tables successfully acquired
[    0.425285] ACPI: setting ELCR to 0200 (from 0c00)
[    0.481852] Performance Events: 
[    0.482793] no APIC, boot with the "lapic" boot parameter to force-enable it.
[    0.484306] no hardware sampling interrupt available.
[    0.485777] Broken PMU hardware detected, using software events only.
[    0.486744] Failed to access perfctr msr (MSR c0010004 is 0)
[    0.546081] Apic disabled
[    0.568966] device: 'platform': device_add
[    0.573680] PM: Adding info for No Bus:platform
[    0.581551] bus: 'platform': registered
[    0.583561] bus: 'cpu': registered
[    0.584698] device: 'cpu': device_add
[    0.586796] PM: Adding info for No Bus:cpu
[    0.589859] bus: 'memory': registered
[    0.590655] device: 'memory': device_add
[    0.592559] PM: Adding info for No Bus:memory
[    0.597160] device: 'memory0': device_add
[    0.599465] bus: 'memory': add device memory0
[    0.604626] PM: Adding info for memory:memory0
[    0.613578] device: 'memory1': device_add
[    0.614553] bus: 'memory': add device memory1
[    0.616465] PM: Adding info for memory:memory1
[    0.809740] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.810864] device class 'regulator': registering
[    0.834134] Registering platform device 'reg-dummy'. Parent at platform
[    0.835172] device: 'reg-dummy': device_add
[    0.836628] bus: 'platform': add device reg-dummy
[    0.838118] PM: Adding info for platform:reg-dummy
[    0.840920] bus: 'platform': add driver reg-dummy
[    0.844753] bus: 'platform': driver_probe_device: matched device reg-dummy with driver reg-dummy
[    0.846000] bus: 'platform': really_probe: probing driver reg-dummy with device reg-dummy
[    0.856349] device: 'regulator.0': device_add
[    0.867078] PM: Adding info for No Bus:regulator.0
[    0.876603] regulator-dummy: no parameters
[    0.885370] driver: 'reg-dummy': driver_bound: bound to device 'reg-dummy'
[    0.888551] bus: 'platform': really_probe: bound device reg-dummy to driver reg-dummy
[    0.909809] NET: Registered protocol family 16
[    0.920477] device class 'bdi': registering
[    0.924456] device class 'pci_bus': registering
[    0.928851] bus: 'pci': registered
[    0.929500] device class 'tty': registering
[    0.934492] bus: 'spi': registered
[    0.935115] device class 'spi_master': registering
[    1.006075] ACPI: bus type PCI registered
[    1.006985] device class 'dma': registering
[    1.010583] bus: 'platform': add driver clk-lpt
[    1.016343] PCI: Using configuration type 1 for base access
[    1.018360] device: 'cpu0': device_add
[    1.019280] bus: 'cpu': add device cpu0
[    1.020872] PM: Adding info for cpu:cpu0
[    1.107032] device: 'default': device_add
[    1.110431] PM: Adding info for No Bus:default
[    1.125325] bus: 'platform': add driver lp_gpio
[    1.130805] ACPI: Added _OSI(Module Device)
[    1.132253] ACPI: Added _OSI(Processor Device)
[    1.133060] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.133850] ACPI: Added _OSI(Processor Aggregator Device)
[    1.318590] ACPI: EC: Look up EC in DSDT
[    1.852349] ACPI: Interpreter enabled
[    1.853752] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130117/hwxface-568)
[    1.855595] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130117/hwxface-568)
[    1.860970] ACPI: (supports S0 S3 S5)
[    1.861742] ACPI: Using PIC for interrupt routing
[    1.865962] bus: 'acpi': registered
[    1.866820] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    2.156511] device: 'LNXSYSTM:00': device_add
[    2.160764] bus: 'acpi': add device LNXSYSTM:00
[    2.164451] PM: Adding info for acpi:LNXSYSTM:00
[    2.185511] device: 'LNXSYBUS:00': device_add
[    2.186610] bus: 'acpi': add device LNXSYBUS:00
[    2.188487] PM: Adding info for acpi:LNXSYBUS:00
[    2.198751] device: 'PNP0A03:00': device_add
[    2.200452] bus: 'acpi': add device PNP0A03:00
[    2.201669] PM: Adding info for acpi:PNP0A03:00
[    2.221001] device: 'device:00': device_add
[    2.222095] bus: 'acpi': add device device:00
[    2.223407] PM: Adding info for acpi:device:00
[    2.234422] device: 'device:01': device_add
[    2.235526] bus: 'acpi': add device device:01
[    2.236787] PM: Adding info for acpi:device:01
[    2.246500] device: 'PNP0B00:00': device_add
[    2.247566] bus: 'acpi': add device PNP0B00:00
[    2.248786] PM: Adding info for acpi:PNP0B00:00
[    2.262078] device: 'PNP0303:00': device_add
[    2.263170] bus: 'acpi': add device PNP0303:00
[    2.264787] PM: Adding info for acpi:PNP0303:00
[    2.277736] device: 'PNP0F13:00': device_add
[    2.278837] bus: 'acpi': add device PNP0F13:00
[    2.280782] PM: Adding info for acpi:PNP0F13:00
[    2.293570] device: 'PNP0700:00': device_add
[    2.294660] bus: 'acpi': add device PNP0700:00
[    2.296483] PM: Adding info for acpi:PNP0700:00
[    2.314647] device: 'PNP0400:00': device_add
[    2.316383] bus: 'acpi': add device PNP0400:00
[    2.317606] PM: Adding info for acpi:PNP0400:00
[    2.336713] device: 'PNP0501:00': device_add
[    2.337820] bus: 'acpi': add device PNP0501:00
[    2.339035] PM: Adding info for acpi:PNP0501:00
[    2.354673] device: 'device:02': device_add
[    2.356430] bus: 'acpi': add device device:02
[    2.357665] PM: Adding info for acpi:device:02
[    2.370384] device: 'device:03': device_add
[    2.371452] bus: 'acpi': add device device:03
[    2.372813] PM: Adding info for acpi:device:03
[    2.383281] device: 'device:04': device_add
[    2.384634] bus: 'acpi': add device device:04
[    2.385950] PM: Adding info for acpi:device:04
[    2.398520] device: 'device:05': device_add
[    2.399599] bus: 'acpi': add device device:05
[    2.400908] PM: Adding info for acpi:device:05
[    2.413462] device: 'device:06': device_add
[    2.414517] bus: 'acpi': add device device:06
[    2.416298] PM: Adding info for acpi:device:06
[    2.427462] device: 'device:07': device_add
[    2.428642] bus: 'acpi': add device device:07
[    2.429841] PM: Adding info for acpi:device:07
[    2.442019] device: 'device:08': device_add
[    2.443067] bus: 'acpi': add device device:08
[    2.444899] PM: Adding info for acpi:device:08
[    2.456885] device: 'device:09': device_add
[    2.457944] bus: 'acpi': add device device:09
[    2.459151] PM: Adding info for acpi:device:09
[    2.470822] device: 'device:0a': device_add
[    2.472502] bus: 'acpi': add device device:0a
[    2.473715] PM: Adding info for acpi:device:0a
[    2.485463] device: 'device:0b': device_add
[    2.486519] bus: 'acpi': add device device:0b
[    2.488406] PM: Adding info for acpi:device:0b
[    2.499460] device: 'device:0c': device_add
[    2.500640] bus: 'acpi': add device device:0c
[    2.501842] PM: Adding info for acpi:device:0c
[    2.513907] device: 'device:0d': device_add
[    2.514951] bus: 'acpi': add device device:0d
[    2.516738] PM: Adding info for acpi:device:0d
[    2.528298] device: 'device:0e': device_add
[    2.529350] bus: 'acpi': add device device:0e
[    2.530536] PM: Adding info for acpi:device:0e
[    2.542303] device: 'device:0f': device_add
[    2.543355] bus: 'acpi': add device device:0f
[    2.544784] PM: Adding info for acpi:device:0f
[    2.556753] device: 'device:10': device_add
[    2.557798] bus: 'acpi': add device device:10
[    2.558977] PM: Adding info for acpi:device:10
[    2.570680] device: 'device:11': device_add
[    2.572312] bus: 'acpi': add device device:11
[    2.573517] PM: Adding info for acpi:device:11
[    2.585211] device: 'device:12': device_add
[    2.586243] bus: 'acpi': add device device:12
[    2.587421] PM: Adding info for acpi:device:12
[    2.599056] device: 'device:13': device_add
[    2.600621] bus: 'acpi': add device device:13
[    2.601809] PM: Adding info for acpi:device:13
[    2.613475] device: 'device:14': device_add
[    2.614514] bus: 'acpi': add device device:14
[    2.616286] PM: Adding info for acpi:device:14
[    2.627403] device: 'device:15': device_add
[    2.628639] bus: 'acpi': add device device:15
[    2.629821] PM: Adding info for acpi:device:15
[    2.641881] device: 'device:16': device_add
[    2.642919] bus: 'acpi': add device device:16
[    2.644682] PM: Adding info for acpi:device:16
[    2.655748] device: 'device:17': device_add
[    2.656635] bus: 'acpi': add device device:17
[    2.657958] PM: Adding info for acpi:device:17
[    2.670314] device: 'device:18': device_add
[    2.671347] bus: 'acpi': add device device:18
[    2.672785] PM: Adding info for acpi:device:18
[    2.684785] device: 'device:19': device_add
[    2.685824] bus: 'acpi': add device device:19
[    2.687008] PM: Adding info for acpi:device:19
[    2.698617] device: 'device:1a': device_add
[    2.699759] bus: 'acpi': add device device:1a
[    2.700790] PM: Adding info for acpi:device:1a
[    2.713044] device: 'device:1b': device_add
[    2.714173] bus: 'acpi': add device device:1b
[    2.715345] PM: Adding info for acpi:device:1b
[    2.726892] device: 'device:1c': device_add
[    2.728512] bus: 'acpi': add device device:1c
[    2.729697] PM: Adding info for acpi:device:1c
[    2.741274] device: 'device:1d': device_add
[    2.742306] bus: 'acpi': add device device:1d
[    2.743473] PM: Adding info for acpi:device:1d
[    2.754963] device: 'device:1e': device_add
[    2.756709] bus: 'acpi': add device device:1e
[    2.757898] PM: Adding info for acpi:device:1e
[    2.769590] device: 'device:1f': device_add
[    2.770620] bus: 'acpi': add device device:1f
[    2.772430] PM: Adding info for acpi:device:1f
[    2.783445] device: 'device:20': device_add
[    2.784644] bus: 'acpi': add device device:20
[    2.785824] PM: Adding info for acpi:device:20
[    2.798243] device: 'device:21': device_add
[    2.799278] bus: 'acpi': add device device:21
[    2.800884] PM: Adding info for acpi:device:21
[    2.829613] device: 'PNP0103:00': device_add
[    2.830732] bus: 'acpi': add device PNP0103:00
[    2.832586] PM: Adding info for acpi:PNP0103:00
[    2.853791] device: 'PNP0C0F:00': device_add
[    2.854892] bus: 'acpi': add device PNP0C0F:00
[    2.856721] PM: Adding info for acpi:PNP0C0F:00
[    2.876323] device: 'PNP0C0F:01': device_add
[    2.877402] bus: 'acpi': add device PNP0C0F:01
[    2.878718] PM: Adding info for acpi:PNP0C0F:01
[    2.898306] device: 'PNP0C0F:02': device_add
[    2.899393] bus: 'acpi': add device PNP0C0F:02
[    2.900805] PM: Adding info for acpi:PNP0C0F:02
[    2.920901] device: 'PNP0C0F:03': device_add
[    2.921985] bus: 'acpi': add device PNP0C0F:03
[    2.923195] PM: Adding info for acpi:PNP0C0F:03
[    2.942808] device: 'PNP0C0F:04': device_add
[    2.944529] bus: 'acpi': add device PNP0C0F:04
[    2.945862] PM: Adding info for acpi:PNP0C0F:04
[    2.960906] device: 'LNXCPU:00': device_add
[    2.961965] bus: 'acpi': add device LNXCPU:00
[    2.963156] PM: Adding info for acpi:LNXCPU:00
[    2.975486] device: 'LNXCPU:01': device_add
[    2.976673] bus: 'acpi': add device LNXCPU:01
[    2.977869] PM: Adding info for acpi:LNXCPU:01
[    2.989950] device: 'LNXSYBUS:01': device_add
[    2.991002] bus: 'acpi': add device LNXSYBUS:01
[    2.992769] PM: Adding info for acpi:LNXSYBUS:01
[    3.011783] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    3.013808] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    3.016504] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    3.027380] device: 'pci0000:00': device_add
[    3.033100] PM: Adding info for No Bus:pci0000:00
[    3.034259] device: '0000:00': device_add
[    3.038006] PM: Adding info for No Bus:0000:00
[    3.040926] PCI host bridge to bus 0000:00
[    3.044620] pci_bus 0000:00: root bus resource [bus 00-ff]
[    3.045804] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    3.046735] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    3.048334] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    3.049355] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebfffff]
[    3.055729] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    3.065781] device: '0000:00:00.0': device_add
[    3.091503] bus: 'pci': add device 0000:00:00.0
[    3.095175] PM: Adding info for pci:0000:00:00.0
[    3.101327] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    3.108462] device: '0000:00:01.0': device_add
[    3.112584] bus: 'pci': add device 0000:00:01.0
[    3.116704] PM: Adding info for pci:0000:00:01.0
[    3.118624] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    3.127230] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    3.132873] device: '0000:00:01.1': device_add
[    3.157703] bus: 'pci': add device 0000:00:01.1
[    3.161848] PM: Adding info for pci:0000:00:01.1
[    3.164651] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    3.170806] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    3.172500] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    3.174604] device: '0000:00:01.3': device_add
[    3.179087] bus: 'pci': add device 0000:00:01.3
[    3.182932] PM: Adding info for pci:0000:00:01.3
[    3.185809] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    3.189506] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    3.193062] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    3.204341] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    3.206135] device: '0000:00:02.0': device_add
[    3.210062] bus: 'pci': add device 0000:00:02.0
[    3.214074] PM: Adding info for pci:0000:00:02.0
[    3.216613] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    3.219549] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    3.222148] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    3.234117] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    3.236976] device: '0000:00:03.0': device_add
[    3.243160] bus: 'pci': add device 0000:00:03.0
[    3.247046] PM: Adding info for pci:0000:00:03.0
[    3.250148] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    3.254197] pci 0000:00:04.0: reg 10: [io  0xc040-0xc07f]
[    3.257340] pci 0000:00:04.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
[    3.271328] device: '0000:00:04.0': device_add
[    3.278801] bus: 'pci': add device 0000:00:04.0
[    3.282944] PM: Adding info for pci:0000:00:04.0
[    3.285652] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    3.289351] pci 0000:00:05.0: reg 10: [io  0xc080-0xc0bf]
[    3.292334] pci 0000:00:05.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[    3.306280] device: '0000:00:05.0': device_add
[    3.314278] bus: 'pci': add device 0000:00:05.0
[    3.321066] PM: Adding info for pci:0000:00:05.0
[    3.323153] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    3.326553] pci 0000:00:06.0: reg 10: [io  0xc0c0-0xc0ff]
[    3.330145] pci 0000:00:06.0: reg 14: [mem 0xfebf3000-0xfebf3fff]
[    3.344532] device: '0000:00:06.0': device_add
[    3.353387] bus: 'pci': add device 0000:00:06.0
[    3.357542] PM: Adding info for pci:0000:00:06.0
[    3.359781] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    3.362542] pci 0000:00:07.0: reg 10: [io  0xc100-0xc13f]
[    3.366122] pci 0000:00:07.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    3.381057] device: '0000:00:07.0': device_add
[    3.390385] bus: 'pci': add device 0000:00:07.0
[    3.394609] PM: Adding info for pci:0000:00:07.0
[    3.397340] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    3.401214] pci 0000:00:08.0: reg 10: [io  0xc140-0xc17f]
[    3.404335] pci 0000:00:08.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    3.418162] device: '0000:00:08.0': device_add
[    3.428536] bus: 'pci': add device 0000:00:08.0
[    3.432602] PM: Adding info for pci:0000:00:08.0
[    3.434683] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    3.438386] pci 0000:00:09.0: reg 10: [io  0xc180-0xc1bf]
[    3.441349] pci 0000:00:09.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    3.455362] device: '0000:00:09.0': device_add
[    3.466572] bus: 'pci': add device 0000:00:09.0
[    3.470573] PM: Adding info for pci:0000:00:09.0
[    3.473091] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    3.475326] pci 0000:00:0a.0: reg 10: [mem 0xfebf7000-0xfebf700f]
[    3.485806] device: '0000:00:0a.0': device_add
[    3.497446] bus: 'pci': add device 0000:00:0a.0
[    3.501552] PM: Adding info for pci:0000:00:0a.0
[    3.506139] pci_bus 0000:00: on NUMA node 0
[    3.506879] ACPI _OSC control for PCIe not granted, disabling ASPM
[    3.627053] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    3.646457] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    3.664871] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    3.682555] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    3.700417] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    3.726108] device: 'LNXPWRBN:00': device_add
[    3.727246] bus: 'acpi': add device LNXPWRBN:00
[    3.728817] PM: Adding info for acpi:LNXPWRBN:00
[    3.736000] ACPI: Enabled 16 GPEs in block 00 to 0F
[    3.740530] acpi root: \_SB_.PCI0 notify handler is installed
[    3.753551] Found 1 acpi root devices
[    3.754394] bus: 'acpi': add driver ec
[    3.905766] ACPI: No dock devices found.
[    3.908647] bus: 'pnp': registered
[    3.909732] device class 'misc': registering
[    3.913432] bus: 'spi': add driver tps65912
[    3.916459] bus: 'spi': add driver da9052
[    3.919573] bus: 'serio': registered
[    3.920308] device class 'input': registering
[    3.922795] device class 'power_supply': registering
[    3.925019] device class 'watchdog': registering
[    3.926633] device class 'devfreq': registering
[    3.932682] PCI: Using ACPI for IRQ routing
[    3.933707] PCI: pci_cache_line_size set to 64 bytes
[    3.939241] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    3.940647] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    3.945161] device class 'net': registering
[    3.953932] device: 'lo': device_add
[    3.967396] PM: Adding info for No Bus:lo
[    3.997893] NetLabel: Initializing
[    3.998504] NetLabel:  domain hash size = 128
[    3.999138] NetLabel:  protocols = UNLABELED CIPSOv4
[    4.009367] NetLabel:  unlabeled traffic allowed by default
[    4.011221] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    4.012890] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    4.014095] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    4.041860] Switching to clocksource hpet
[    4.048860] CE: hpet increased min_delta_ns to 5000 nsec
[    4.071012] bus: 'pnp': add driver system
[    4.073699] pnp: PnP ACPI init
[    4.075524] device: 'pnp0': device_add
[    4.077361] PM: Adding info for No Bus:pnp0
[    4.078182] ACPI: bus type PNP registered
[    4.088143] device: '00:00': device_add
[    4.090841] bus: 'pnp': add device 00:00
[    4.093174] PM: Adding info for pnp:00:00
[    4.097211] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    4.103953] device: '00:01': device_add
[    4.106469] bus: 'pnp': add device 00:01
[    4.107959] PM: Adding info for pnp:00:01
[    4.110012] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    4.116815] device: '00:02': device_add
[    4.118544] bus: 'pnp': add device 00:02
[    4.120005] PM: Adding info for pnp:00:02
[    4.122034] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    4.129203] pnp 00:03: [dma 2]
[    4.130075] device: '00:03': device_add
[    4.131830] bus: 'pnp': add device 00:03
[    4.134171] PM: Adding info for pnp:00:03
[    4.135469] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    4.145571] device: '00:04': device_add
[    4.147408] bus: 'pnp': add device 00:04
[    4.149644] PM: Adding info for pnp:00:04
[    4.150991] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    4.159919] device: '00:05': device_add
[    4.162507] bus: 'pnp': add device 00:05
[    4.163997] PM: Adding info for pnp:00:05
[    4.166033] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    4.201141] device: '00:06': device_add
[    4.203894] bus: 'pnp': add device 00:06
[    4.206252] PM: Adding info for pnp:00:06
[    4.207568] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    4.231332] pnp: PnP ACPI: found 7 devices
[    4.232895] ACPI: bus type PNP unregistered
[    4.234021] device class 'mem': registering
[    4.235594] device: 'mem': device_add
[    4.238517] PM: Adding info for No Bus:mem
[    4.242758] device: 'kmem': device_add
[    4.245336] PM: Adding info for No Bus:kmem
[    4.246676] device: 'null': device_add
[    4.249156] PM: Adding info for No Bus:null
[    4.250698] device: 'port': device_add
[    4.253355] PM: Adding info for No Bus:port
[    4.254695] device: 'zero': device_add
[    4.257165] PM: Adding info for No Bus:zero
[    4.258669] device: 'full': device_add
[    4.261156] PM: Adding info for No Bus:full
[    4.262521] device: 'random': device_add
[    4.265021] PM: Adding info for No Bus:random
[    4.266472] device: 'urandom': device_add
[    4.269063] PM: Adding info for No Bus:urandom
[    4.270447] device: 'kmsg': device_add
[    4.272908] PM: Adding info for No Bus:kmsg
[    4.274663] device: 'tty': device_add
[    4.277369] PM: Adding info for No Bus:tty
[    4.281390] device: 'console': device_add
[    4.283271] PM: Adding info for No Bus:console
[    4.294417] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    4.295267] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    4.296844] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    4.297774] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    4.302341] NET: Registered protocol family 2
[    4.339050] TCP established hash table entries: 2048 (order: 3, 32768 bytes)
[    4.342869] TCP bind hash table entries: 2048 (order: 5, 131072 bytes)
[    4.361119] TCP: Hash tables configured (established 2048 bind 2048)
[    4.365282] TCP: reno registered
[    4.366425] UDP hash table entries: 256 (order: 3, 40960 bytes)
[    4.371833] UDP-Lite hash table entries: 256 (order: 3, 40960 bytes)
[    4.395115] NET: Registered protocol family 1
[    4.397649] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    4.398974] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    4.401453] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    4.403063] pci 0000:00:02.0: Boot video device
[    4.405928] PCI: CLS 0 bytes, default 64
[    4.459714] Unpacking initramfs...
[   77.183313] Freeing initrd memory: 23656k freed
[   77.458751] Registering platform device 'pcspkr'. Parent at platform
[   77.459844] device: 'pcspkr': device_add
[   77.461550] bus: 'platform': add device pcspkr
[   77.462869] PM: Adding info for platform:pcspkr
[   77.474844] bus: 'clocksource': registered
[   77.475872] device: 'clocksource': device_add
[   77.477804] PM: Adding info for No Bus:clocksource
[   77.478865] device: 'clocksource0': device_add
[   77.479939] bus: 'clocksource': add device clocksource0
[   77.481895] PM: Adding info for clocksource:clocksource0
[   77.484901] bus: 'platform': add driver alarmtimer
[   77.487093] Registering platform device 'alarmtimer'. Parent at platform
[   77.488189] device: 'alarmtimer': device_add
[   77.489829] bus: 'platform': add device alarmtimer
[   77.491166] PM: Adding info for platform:alarmtimer
[   77.493233] bus: 'platform': driver_probe_device: matched device alarmtimer with driver alarmtimer
[   77.494403] bus: 'platform': really_probe: probing driver alarmtimer with device alarmtimer
[   77.496143] driver: 'alarmtimer': driver_bound: bound to device 'alarmtimer'
[   77.497974] bus: 'platform': really_probe: bound device alarmtimer to driver alarmtimer
[   77.505505] Initialise system trusted keyring
[   77.551932] bus: 'event_source': registered
[   77.554239] device: 'breakpoint': device_add
[   77.555610] bus: 'event_source': add device breakpoint
[   77.558508] PM: Adding info for event_source:breakpoint
[   77.562692] device: 'software': device_add
[   77.563809] bus: 'event_source': add device software
[   77.566080] PM: Adding info for event_source:software
[   77.590095] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[   77.994656] VFS: Disk quotas dquot_6.5.2
[   78.003210] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[   78.033253] msgmni has been set to 443
[   78.127997] cryptomgr_test (20) used greatest stack depth: 5752 bytes left
[   78.206232] alg: No test for stdrng (krng)
[   78.211297] Key type asymmetric registered
[   78.214531] Asymmetric key parser 'x509' registered
[   78.407597] crc32: CRC_LE_BITS = 1, CRC_BE BITS = 1
[   78.409089] crc32: self tests passed, processed 225944 bytes in 56446650 nsec
[   78.475263] tsc: Refined TSC clocksource calibration: 3191.998 MHz
[   78.478193] Switching to clocksource tsc
[   78.479466] crc32c: CRC_LE_BITS = 1
[   78.480725] crc32c: self tests passed, processed 225944 bytes in 28210880 nsec
[   78.481870] bus: 'pci': add driver langwell_gpio
[   78.487117] bus: 'platform': add driver wp_gpio
[   78.498104] bus: 'pci_express': registered
[   78.498859] bus: 'pci': add driver pcieport
[   78.503363] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   78.509593] bus: 'pnp': add driver serial
[   78.511620] bus: 'pnp': driver_probe_device: matched device 00:05 with driver serial
[   78.513450] bus: 'pnp': really_probe: probing driver serial with device 00:05
[   78.553791] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   78.558255] device: 'ttyS0': device_add
[   78.569982] PM: Adding info for No Bus:ttyS0
[   78.578001] driver: '00:05': driver_bound: bound to device 'serial'
[   78.579017] bus: 'pnp': really_probe: bound device 00:05 to driver serial
[   78.582078] Registering platform device 'serial8250'. Parent at platform
[   78.583097] device: 'serial8250': device_add
[   78.584839] bus: 'platform': add device serial8250
[   78.586168] PM: Adding info for platform:serial8250
[   78.590338] device: 'ttyS1': device_add
[   78.597067] PM: Adding info for No Bus:ttyS1
[   78.601603] device: 'ttyS2': device_add
[   78.606320] PM: Adding info for No Bus:ttyS2
[   78.610599] device: 'ttyS3': device_add
[   78.615319] PM: Adding info for No Bus:ttyS3
[   78.618851] bus: 'platform': add driver serial8250
[   78.620823] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[   78.621989] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[   78.623646] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[   78.625464] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[   78.627495] bus: 'spi': add driver max310x
[   78.633635] device: 'hpet': device_add
[   78.639333] PM: Adding info for No Bus:hpet
[   78.645120] bus: 'acpi': add driver hpet
[   78.647415] bus: 'acpi': driver_probe_device: matched device PNP0103:00 with driver hpet
[   78.649212] bus: 'acpi': really_probe: probing driver hpet with device PNP0103:00
[   78.655886] hpet: probe of PNP0103:00 rejects match -19
[   78.658658] bus: 'pnp': add driver tpm_tis
[   78.662930] bus: 'pnp': add driver i8042 kbd
[   78.664832] bus: 'pnp': driver_probe_device: matched device 00:01 with driver i8042 kbd
[   78.665889] bus: 'pnp': really_probe: probing driver i8042 kbd with device 00:01
[   78.669035] driver: '00:01': driver_bound: bound to device 'i8042 kbd'
[   78.670149] bus: 'pnp': really_probe: bound device 00:01 to driver i8042 kbd
[   78.672939] bus: 'pnp': add driver i8042 aux
[   78.674181] bus: 'pnp': driver_probe_device: matched device 00:02 with driver i8042 aux
[   78.675238] bus: 'pnp': really_probe: probing driver i8042 aux with device 00:02
[   78.677645] driver: '00:02': driver_bound: bound to device 'i8042 aux'
[   78.678723] bus: 'pnp': really_probe: bound device 00:02 to driver i8042 aux
[   78.681604] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[   78.685135] Registering platform device 'i8042'. Parent at platform
[   78.686061] device: 'i8042': device_add
[   78.687071] bus: 'platform': add device i8042
[   78.689047] PM: Adding info for platform:i8042
[   78.690652] bus: 'platform': add driver i8042
[   78.691840] bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
[   78.693743] bus: 'platform': really_probe: probing driver i8042 with device i8042
[   78.728776] serio: i8042 KBD port at 0x60,0x64 irq 1
[   78.737471] serio: i8042 AUX port at 0x60,0x64 irq 12
[   78.738673] driver: 'i8042': driver_bound: bound to device 'i8042'
[   78.739652] bus: 'platform': really_probe: bound device i8042 to driver i8042
[   78.746995] bus: 'serio': add driver atkbd
[   78.751261] cpuidle: using governor ladder
[   78.753337] device: 'serio0': device_add
[   78.757799] bus: 'serio': add device serio0
[   78.761387] cpuidle: using governor menu
[   78.765055] PM: Adding info for serio:serio0
[   78.767696] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[   78.776883] bus: 'serio': really_probe: probing driver atkbd with device serio0
[   78.783381] 
[   78.783381] printing PIC contents
[   78.784860] ... PIC  IMR: edf8
[   78.785380] ... PIC  IRR: 0010
[   78.785964] ... PIC  ISR: 0000
[   78.786469] ... PIC ELCR: 0200
[   78.800878] device: 'cpu_dma_latency': device_add
[   78.802914] PM: Adding info for No Bus:cpu_dma_latency
[   78.810647] device: 'network_latency': device_add
[   78.813475] PM: Adding info for No Bus:network_latency
[   78.815696] device: 'network_throughput': device_add
[   78.829573] PM: Adding info for No Bus:network_throughput
[   78.831728] Loading compiled-in X.509 certificates
[   78.855732] device: 'input0': device_add
[   78.879733] PM: Adding info for No Bus:input0
[   78.909061] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[   78.920866] driver: 'serio0': driver_bound: bound to device 'atkbd'
[   78.921935] bus: 'serio': really_probe: bound device serio0 to driver atkbd
[   78.931272] Loaded X.509 cert 'Magrathea: Glacier signing key: e65d649f9894f1a838b5d88f2e9b8a6d69a42be5'
[   78.933867] device: 'serio1': device_add
[   78.935596] bus: 'serio': add device serio1
[   78.939054] PM: Adding info for serio:serio1
[   78.942042] registered taskstats version 1
[   78.943422] IMA: No TPM chip found, activating TPM-bypass!
[   78.950980] bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
[   78.952126] bus: 'serio': really_probe: probing driver atkbd with device serio1
[   78.959841] atkbd: probe of serio1 rejects match -19
[   78.971072] bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
[   78.972833] bus: 'serio': really_probe: probing driver atkbd with device serio1
[   78.994163] atkbd: probe of serio1 rejects match -19
[   79.196148] Freeing unused kernel memory: 664k freed
[   80.786460] BUG: sleeping function called from invalid context at /c/kernel-tests/src/tip/mm/slub.c:925
[   80.787886] in_atomic(): 0, irqs_disabled(): 0, pid: 29, name: modprobe
[   80.789636] 2 locks held by modprobe/29:
[   80.790343]  #0:  (rcu_read_lock){.+.+.+}, at: [<ffffffff8117347b>] rcu_read_lock+0x0/0xbc
[   80.794346]  #1:  (rcu_read_lock){.+.+.+}, at: [<ffffffff8117347b>] rcu_read_lock+0x0/0xbc
[   80.797089] Pid: 29, comm: modprobe Not tainted 3.9.0-rc1-01618-gdf2363d #223
[   80.798113] Call Trace:
[   80.798856]  [<ffffffff8106fc60>] __might_sleep+0x266/0x275
[   80.799830]  [<ffffffff81146311>] ? single_open+0x30/0xb6
[   80.801733]  [<ffffffff811132fd>] slab_pre_alloc_hook.isra.48+0x42/0x4f
[   80.802779]  [<ffffffff81114f7b>] kmem_cache_alloc+0x2a/0xf6
[   80.803746]  [<ffffffff8117e899>] ? cmdline_proc_open+0x25/0x25
[   80.805383]  [<ffffffff81146311>] single_open+0x30/0xb6
[   80.806281]  [<ffffffff810c05df>] ? rcu_is_cpu_idle+0x42/0x8a
[   80.807242]  [<ffffffff8114556d>] ? seq_release_private+0x59/0x59
[   80.808865]  [<ffffffff8117e890>] cmdline_proc_open+0x1c/0x25
[   80.809811]  [<ffffffff811738e6>] proc_reg_open+0x128/0x1e3
[   80.810684]  [<ffffffff811737be>] ? proc_reg_release+0x246/0x246
[   80.811602]  [<ffffffff81119d82>] do_dentry_open+0x228/0x34a
[   80.813260]  [<ffffffff8112a226>] ? __inode_permission+0x115/0x12b
[   80.814223]  [<ffffffff81119f00>] finish_open+0x5c/0x7a
[   80.815056]  [<ffffffff8112b5bb>] do_last.isra.16+0xbcc/0xecb
[   80.815945]  [<ffffffff8112a2bd>] ? inode_permission+0x81/0x8a
[   80.817660]  [<ffffffff8112cfa6>] path_openat.isra.17+0xf0/0x494
[   80.818623]  [<ffffffff8112e7c6>] do_filp_open+0x3a/0xad
[   80.819475]  [<ffffffff8113eef6>] ? __alloc_fd+0x25e/0x277
[   80.821142]  [<ffffffff8111b4dd>] do_sys_open+0x91/0x17b
[   80.822065]  [<ffffffff8111b5f2>] SyS_open+0x2b/0x3b
[   80.822873]  [<ffffffff813d6f6b>] system_call_fastpath+0x1a/0x1f
[   80.827403] 
[   80.827765] ================================================
[   80.829125] [ BUG: lock held when returning to user space! ]
[   80.830056] 3.9.0-rc1-01618-gdf2363d #223 Not tainted
[   80.830778] ------------------------------------------------
[   80.831542] modprobe/29 is leaving the kernel with locks still held!
[   80.832931] 2 locks held by modprobe/29:
[   80.833566]  #0:  (rcu_read_lock){.+.+.+}, at: [<ffffffff8117347b>] rcu_read_lock+0x0/0xbc
[   80.835004]  #1:  (rcu_read_lock){.+.+.+}, at: [<ffffffff8117347b>] rcu_read_lock+0x0/0xbc
modprobe: FATAL: Could not load /lib/modules/3.9.0-rc1-01618-gdf2363d/modules.dep: No such file or directory


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="df2363d9ad7ffd43b5e86604c7a28f4adc6bd75e-bisect.log"

git checkout 725a7c316ea0d1329b630e31f82d0a2e762e0a65
Previous HEAD position was df2363d... kernel/sys.c: make prctl(PR_SET_MM) generally available
HEAD is now at 725a7c3... Merge remote-tracking branch 'modem_shm/remoteproc-next'

2013-03-07-21:32:34 725a7c316ea0d1329b630e31f82d0a2e762e0a65 compiling
/home/wfg/linux

2013-03-07-21:34:10 detecting boot state 3.9.0-rc1-bisect-01478-g725a7c3 #242  SUCCESS
bisect: good commit 725a7c316ea0d1329b630e31f82d0a2e762e0a65
git bisect start df2363d9ad7ffd43b5e86604c7a28f4adc6bd75e 725a7c316ea0d1329b630e31f82d0a2e762e0a65 --
Previous HEAD position was 725a7c3... Merge remote-tracking branch 'modem_shm/remoteproc-next'
HEAD is now at 1e51120... userns: Convert 9p's uid/gid handling
Bisecting: 78 revisions left to test after this (roughly 6 steps)
[62159550cf357e60632a7ac147b4c66b1e2b0630] freezer: do not send a fake signal to a PF_DUMPCORE thread
git bisect run /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-03-07-21:35:00 62159550cf357e60632a7ac147b4c66b1e2b0630 compiling
/home/wfg/linux

2013-03-07-21:36:38 detecting boot state 3.9.0-rc1-bisect-01557-g6215955 #243  SUCCESS
Bisecting: 39 revisions left to test after this (roughly 5 steps)
[bcbe478b5a2c1c5831dbe1c31d4b6a7d7438ccee] aio: kill struct aio_ring_info
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-03-07-21:37:10 bcbe478b5a2c1c5831dbe1c31d4b6a7d7438ccee compiling
/home/wfg/linux

2013-03-07-21:38:44 detecting boot state 3.9.0-rc1-bisect-01596-gbcbe478 #244  TEST FAILURE
Bisecting: 19 revisions left to test after this (roughly 4 steps)
[93102c910da3c99169b97ed03fdd53c64eadc284] gadget: remove only user of aio retry
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-03-07-21:39:15 93102c910da3c99169b97ed03fdd53c64eadc284 compiling
/home/wfg/linux

2013-03-07-21:40:46 detecting boot state 3.9.0-rc1-bisect-01576-g93102c9 #245  TEST FAILURE
Bisecting: 9 revisions left to test after this (roughly 3 steps)
[df2c264613410a2f59d4f13082207d5e4c0381fe] ipc: set EFAULT as default error in load_msg()
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-03-07-21:41:17 df2c264613410a2f59d4f13082207d5e4c0381fe compiling
/home/wfg/linux

2013-03-07-21:42:43 detecting boot state 3.9.0-rc1-bisect-01566-gdf2c264 #246  TEST FAILURE
Bisecting: 4 revisions left to test after this (roughly 2 steps)
[1b716364563aa3fcd04eddea6fe08bd49574ec7f] kexec: Use min() and min_t() to simplify logic
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-03-07-21:43:13 1b716364563aa3fcd04eddea6fe08bd49574ec7f compiling
/home/wfg/linux

2013-03-07-21:44:09 detecting boot state 3.9.0-rc1-bisect-01561-g1b71636 #247  TEST FAILURE
Bisecting: 1 revision left to test after this (roughly 1 step)
[a21813be23329e2788164eab532e79cb0e513cfc] procfs: improve scaling in proc
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-03-07-21:44:40 a21813be23329e2788164eab532e79cb0e513cfc compiling
/home/wfg/linux

2013-03-07-21:45:44 detecting boot state 3.9.0-rc1-bisect-01559-ga21813b #248  TEST FAILURE
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[c391a36c9b415f3276d1059594a635e66d3f5d7a] coredump: make wait_for_dump_helpers() freezable
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-03-07-21:46:15 c391a36c9b415f3276d1059594a635e66d3f5d7a compiling
/home/wfg/linux

2013-03-07-21:47:28 detecting boot state 3.9.0-rc1-bisect-01558-gc391a36 #249  SUCCESS
a21813be23329e2788164eab532e79cb0e513cfc is the first bad commit
commit a21813be23329e2788164eab532e79cb0e513cfc
Author: Nathan Zimmer <nzimmer@sgi.com>
Date:   Sat Mar 2 15:25:37 2013 +1100

    procfs: improve scaling in proc
    
    I am currently tracking a hotlock reported by a customer on a large
    system, 512 cores.  I am currently running 3.8-rc7 but the issue looks
    like it has been this way for a very long time.  The offending lock is
    proc_dir_entry->pde_unload_lock.
    
    This patch converts the lock to use rcu.  However the pde_openers list
    still is controlled by a spin lock.  I tested on a 4096 machine and the
    lock doesn't seem hot at least according to perf.
    
    This is a refresh of what was orignally suggested by Eric Dumazet some
    time ago.  I have also taken in some comments from Andrew and several
    other people whose names escape me but I am quite grateful too.
    
    Supporting numbers, lower is better, they are from the test I posted earlier.
    cpuinfo baseline        Rcu
    tasks   read-sec        read-sec
    1       0.0141          0.0141
    2       0.0140          0.0142
    4       0.0140          0.0141
    8       0.0145          0.0140
    16      0.0553          0.0168
    32      0.1688          0.0549
    64      0.5017          0.1690
    128     1.7005          0.5038
    256     5.2513          2.0804
    512     8.0529          3.0162
    
    Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
    Cc: "Eric W. Biederman" <ebiederm@xmission.com>
    Cc: Eric Dumazet <eric.dumazet@gmail.com>
    Cc: Alexander Viro <viro@zeniv.linux.org.uk>
    Cc: David Woodhouse <dwmw2@infradead.org>
    Cc: Alexey Dobriyan <adobriyan@gmail.com>
    Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

:040000 040000 743664f10bf54723657eef666d27f1298f8c4298 cc1c9c861c02251227cbe9585a0a47ca45dc170c M	fs
:040000 040000 7374d65efc70771f24e5d82b972aeb7ddb1bf01a b9ce9679b875a1877919823e4080de1f771820b2 M	include
bisect run success

2013-03-07-21:47:59 c391a36c9b415f3276d1059594a635e66d3f5d7a compiling
/home/wfg/linux

2013-03-07-21:48:40 detecting boot state 3.9.0-rc1-bisect-01558-gc391a36 #249 	9 SUCCESS

2013-03-07-21:49:49 df2363d9ad7ffd43b5e86604c7a28f4adc6bd75e compiling
/home/wfg/linux

2013-03-07-21:51:09 detecting boot state 3.9.0-rc1-bisect-01636-gdf2363d #250  TEST FAILURE
ERROR# 1: /c/kernel-tests/bisect:58: main: $BISECT_TEST $KBUILD_OUTPUT
[detached HEAD 91ce46c] Revert "procfs: improve scaling in proc"
 3 files changed, 106 insertions(+), 123 deletions(-)

2013-03-07-21:51:43 91ce46c0d79238fc84ee5f8c0936d4dcb66d1fd3 compiling
/home/wfg/linux

2013-03-07-21:52:53 detecting boot state 3.9.0-rc1-bisect-01637-g91ce46c #251 	9	20 SUCCESS

========= linux-next =========
Fetching next

2013-03-07-21:54:40 9edbffb58ae00067e264ef70d5141c1d85049029 compiling
/home/wfg/linux

2013-03-07-21:56:35 detecting boot state 3.9.0-rc1-bisect-next-20130307 #252  TEST FAILURE
ERROR# 1: /c/kernel-tests/bisect:72: main: $BISECT_TEST $KBUILD_OUTPUT

--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.9.0-rc1 Kernel Configuration
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
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
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
CONFIG_CONSTRUCTORS=y
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
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_KERNEL_XZ=y
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
CONFIG_POSIX_MQUEUE=y
CONFIG_FHANDLE=y
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
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_ALWAYS_USE_PERSISTENT_CLOCK=y
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
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
# CONFIG_TINY_PREEMPT_RCU is not set
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_TREE_RCU_TRACE=y
# CONFIG_RCU_BOOST is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
CONFIG_UIDGID_CONVERTED=y
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
CONFIG_RD_LZMA=y
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_HAVE_UID16=y
# CONFIG_UID16 is not set
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
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
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
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
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
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_VIRT_TO_BUS=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_MODULE_SIG=y
CONFIG_MODULE_SIG_FORCE=y
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
# CONFIG_MODULE_SIG_SHA256 is not set
CONFIG_MODULE_SIG_SHA384=y
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha384"
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
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_INTEL_LPSS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_PARAVIRT_DEBUG=y
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
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_DIRECT_GBPAGES is not set
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_CLK=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
# CONFIG_ACPI_BUTTON is not set
# CONFIG_ACPI_FAN is not set
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=m
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
# CONFIG_ACPI_THERMAL is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_DEBUG_FUNC_TRACE is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
CONFIG_ACPI_CUSTOM_METHOD=m
CONFIG_ACPI_APEI=y
# CONFIG_ACPI_APEI_GHES is not set
# CONFIG_ACPI_APEI_EINJ is not set
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=m
CONFIG_CPU_FREQ_STAT=m
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=m
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=m
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=m
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
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
CONFIG_PCI_CNB20LE_QUIRK=y
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
# CONFIG_PCIEAER is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
# CONFIG_PCIEASPM_DEFAULT is not set
# CONFIG_PCIEASPM_POWERSAVE is not set
CONFIG_PCIEASPM_PERFORMANCE=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=m
# CONFIG_HT_IRQ is not set
# CONFIG_PCI_ATS is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
# CONFIG_ISA_DMA_API is not set
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=m
CONFIG_HOTPLUG_PCI_ACPI=m
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=m
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=m
# CONFIG_HOTPLUG_PCI_SHPC is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=m
CONFIG_X86_X32=y
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
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=m
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_PNP=y
# CONFIG_IP_PNP_DHCP is not set
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
# CONFIG_NET_IPGRE_DEMUX is not set
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_NET_IPVTI is not set
CONFIG_INET_AH=m
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_INET_UDP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=m
# CONFIG_TCP_CONG_WESTWOOD is not set
CONFIG_TCP_CONG_HTCP=m
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
CONFIG_DEFAULT_RENO=y
CONFIG_DEFAULT_TCP_CONG="reno"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
CONFIG_INET6_IPCOMP=m
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
# CONFIG_IPV6_SIT is not set
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_GRE=m
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_NETLABEL=y
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
CONFIG_RDS=m
CONFIG_RDS_RDMA=m
CONFIG_RDS_TCP=m
CONFIG_RDS_DEBUG=y
CONFIG_TIPC=m
CONFIG_TIPC_PORTS=8191
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
CONFIG_ATM_CLIP_NO_ICMP=y
# CONFIG_ATM_LANE is not set
CONFIG_ATM_BR2684=m
CONFIG_ATM_BR2684_IPFILTER=y
# CONFIG_L2TP is not set
CONFIG_STP=m
CONFIG_GARP=m
# CONFIG_BRIDGE is not set
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_VLAN_8021Q_MVRP is not set
CONFIG_DECNET=m
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
CONFIG_X25=m
CONFIG_LAPB=m
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
CONFIG_NETPRIO_CGROUP=m
CONFIG_BQL=y
CONFIG_BPF_JIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
# CONFIG_CAN_GW is not set

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
CONFIG_CAN_SLCAN=m
CONFIG_CAN_DEV=m
# CONFIG_CAN_CALC_BITTIMING is not set
CONFIG_CAN_LEDS=y
# CONFIG_CAN_MCP251X is not set
# CONFIG_PCH_CAN is not set
CONFIG_CAN_SJA1000=m
# CONFIG_CAN_SJA1000_ISA is not set
CONFIG_CAN_SJA1000_PLATFORM=m
CONFIG_CAN_EMS_PCI=m
# CONFIG_CAN_PEAK_PCI is not set
CONFIG_CAN_KVASER_PCI=m
CONFIG_CAN_PLX_PCI=m
CONFIG_CAN_C_CAN=m
# CONFIG_CAN_C_CAN_PLATFORM is not set
CONFIG_CAN_C_CAN_PCI=m
# CONFIG_CAN_CC770 is not set
# CONFIG_CAN_SOFTING is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
# CONFIG_BT_HCIUART_H4 is not set
CONFIG_BT_HCIUART_BCSP=y
# CONFIG_BT_HCIUART_ATH3K is not set
# CONFIG_BT_HCIUART_LL is not set
# CONFIG_BT_HCIUART_3WIRE is not set
# CONFIG_BT_HCIVHCI is not set
CONFIG_BT_MRVL=m
CONFIG_BT_MRVL_SDIO=m
CONFIG_AF_RXRPC=m
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=m
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_REGULATOR=m
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=m
CONFIG_NET_9P_VIRTIO=m
# CONFIG_NET_9P_RDMA is not set
CONFIG_NET_9P_DEBUG=y
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=m
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
CONFIG_NFC=m
CONFIG_NFC_NCI=m
# CONFIG_NFC_HCI is not set
CONFIG_NFC_LLCP=y

#
# Near Field Communication (NFC) devices
#
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
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=m
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
CONFIG_DEBUG_DRIVER=y
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=m
CONFIG_REGMAP_IRQ=y
# CONFIG_DMA_SHARED_BUFFER is not set

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=m
CONFIG_MTD_TESTS=m
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
# CONFIG_MTD_CHAR is not set
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
CONFIG_MTD_CFI_ADV_OPTIONS=y
# CONFIG_MTD_CFI_NOSWAP is not set
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
CONFIG_MTD_CFI_LE_BYTE_SWAP=y
CONFIG_MTD_CFI_GEOMETRY=y
# CONFIG_MTD_MAP_BANK_WIDTH_1 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_2 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_4 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
CONFIG_MTD_MAP_BANK_WIDTH_16=y
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
CONFIG_MTD_CFI_I8=y
# CONFIG_MTD_OTP is not set
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
# CONFIG_MTD_RAM is not set
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=m
# CONFIG_MTD_PHYSMAP_COMPAT is not set
# CONFIG_MTD_TS5500 is not set
CONFIG_MTD_AMD76XROM=m
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=m
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_DATAFLASH is not set
# CONFIG_MTD_M25P80 is not set
# CONFIG_MTD_SST25L is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOC2000 is not set
CONFIG_MTD_DOC2001=m
CONFIG_MTD_DOC2001PLUS=m
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_DOCPROBE=m
CONFIG_MTD_DOCECC=m
CONFIG_MTD_DOCPROBE_ADVANCED=y
CONFIG_MTD_DOCPROBE_ADDRESS=0x0
# CONFIG_MTD_DOCPROBE_HIGH is not set
CONFIG_MTD_DOCPROBE_55AA=y
CONFIG_MTD_NAND_ECC=m
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=m
# CONFIG_MTD_NAND_ECC_BCH is not set
CONFIG_MTD_SM_COMMON=m
CONFIG_MTD_NAND_DENALI=m
# CONFIG_MTD_NAND_DENALI_PCI is not set
# CONFIG_MTD_NAND_DENALI_DT is not set
CONFIG_MTD_NAND_IDS=m
CONFIG_MTD_NAND_RICOH=m
# CONFIG_MTD_NAND_DISKONCHIP is not set
# CONFIG_MTD_NAND_DOCG4 is not set
CONFIG_MTD_NAND_CAFE=m
# CONFIG_MTD_NAND_NANDSIM is not set
# CONFIG_MTD_NAND_PLATFORM is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=m
CONFIG_MTD_QINFO_PROBE=m
# CONFIG_MTD_UBI is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
# CONFIG_PARPORT_PC_FIFO is not set
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
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
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
CONFIG_ATMEL_PWM=m
CONFIG_IBM_ASM=m
# CONFIG_PHANTOM is not set
CONFIG_INTEL_MID_PTI=m
CONFIG_SGI_IOC4=m
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
CONFIG_ATMEL_SSC=m
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_HP_ILO is not set
CONFIG_TI_DAC7512=m
CONFIG_VMWARE_BALLOON=m
# CONFIG_BMP085_SPI is not set
CONFIG_PCH_PHUB=m
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_93CX6=m
CONFIG_EEPROM_93XX46=m
CONFIG_CB710_CORE=m
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set

#
# Altera FPGA firmware download module
#
# CONFIG_INTEL_MEI is not set
# CONFIG_VMWARE_VMCI is not set
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
CONFIG_FIREWIRE=m
# CONFIG_FIREWIRE_OHCI is not set
CONFIG_FIREWIRE_NET=m
CONFIG_FIREWIRE_NOSY=m
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
# CONFIG_NETDEVICES is not set

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
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_LKKBD=m
CONFIG_KEYBOARD_GPIO=m
CONFIG_KEYBOARD_GPIO_POLLED=m
CONFIG_KEYBOARD_MATRIX=m
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
CONFIG_KEYBOARD_SAMSUNG=m
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_XTKBD=m
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=m
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=m
CONFIG_JOYSTICK_GRIP=m
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=m
# CONFIG_JOYSTICK_IFORCE_232 is not set
CONFIG_JOYSTICK_WARRIOR=m
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=m
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
CONFIG_JOYSTICK_TWIDJOY=m
CONFIG_JOYSTICK_ZHENHUA=m
# CONFIG_JOYSTICK_DB9 is not set
# CONFIG_JOYSTICK_GAMECON is not set
CONFIG_JOYSTICK_TURBOGRAFX=m
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
# CONFIG_JOYSTICK_WALKERA0701 is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_MC13783_PWRBUTTON is not set
CONFIG_INPUT_GPIO_TILT_POLLED=m
CONFIG_INPUT_ATLAS_BTNS=m
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=m
# CONFIG_INPUT_PWM_BEEPER is not set
CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
# CONFIG_INPUT_DA9052_ONKEY is not set
CONFIG_INPUT_ADXL34X=m
CONFIG_INPUT_ADXL34X_SPI=m
CONFIG_INPUT_CMA3000=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=m
CONFIG_SERIO_ARC_PS2=m
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
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
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=m
CONFIG_N_GSM=m
CONFIG_TRACE_ROUTER=m
CONFIG_TRACE_SINK=m
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_DMA=y
# CONFIG_SERIAL_8250_PCI is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_DW=m

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_MAX310X=y
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_UARTLITE=m
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=m
CONFIG_SERIAL_TIMBERDALE=m
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
# CONFIG_IPMI_POWEROFF is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=m
# CONFIG_RTC is not set
CONFIG_GEN_RTC=m
CONFIG_GEN_RTC_X=y
CONFIG_R3964=m
CONFIG_APPLICOM=m
CONFIG_MWAVE=m
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_NSC=m
# CONFIG_TCG_ATMEL is not set
CONFIG_TCG_INFINEON=m
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=m
CONFIG_SPI_BITBANG=m
CONFIG_SPI_BUTTERFLY=m
CONFIG_SPI_GPIO=m
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_TOPCLIFF_PCH=m
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
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
CONFIG_PPS=m
CONFIG_PPS_DEBUG=y

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_PARPORT=m
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=m

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PTP_1588_CLOCK_PCH=m
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=m
CONFIG_GPIO_DA9052=m
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=m
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_TS5500=m
# CONFIG_GPIO_SCH is not set
CONFIG_GPIO_ICH=m
# CONFIG_GPIO_VX855 is not set
CONFIG_GPIO_LYNXPOINT=y

#
# I2C GPIO expanders:
#
CONFIG_GPIO_TPS65912=m

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
CONFIG_GPIO_AMD8111=m
CONFIG_GPIO_LANGWELL=y
CONFIG_GPIO_PCH=m
CONFIG_GPIO_ML_IOH=m
# CONFIG_GPIO_TIMBERDALE is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=m
# CONFIG_GPIO_MCP23S08 is not set
# CONFIG_GPIO_MC33880 is not set
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

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS1WM=m
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=m
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=m
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=m
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=m
# CONFIG_W1_SLAVE_DS2781 is not set
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2780=m
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_BQ27x00=m
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9052=m
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_GPIO=m
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_AD7314=m
# CONFIG_SENSORS_ADCXX is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_DA9052_ADC is not set
CONFIG_SENSORS_I5K_AMB=m
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=m
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IBMAEM=m
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_LM70 is not set
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SIS5595=m
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83627HF=m
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_SENSORS_MC13783_ADC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=m
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_CPU_THERMAL is not set
CONFIG_THERMAL_EMULATION=y
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_DA9052_WATCHDOG is not set
CONFIG_ACQUIRE_WDT=m
CONFIG_ADVANTECH_WDT=m
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=m
CONFIG_SP5100_TCO=m
CONFIG_SC520_WDT=m
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=m
CONFIG_IE6XX_WDT=m
CONFIG_ITCO_WDT=m
# CONFIG_ITCO_VENDOR_SUPPORT is not set
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=m
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
CONFIG_CPU5_WDT=m
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=m
CONFIG_W83697HF_WDT=m
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=m
# CONFIG_W83977F_WDT is not set
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
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
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_SM501=m
# CONFIG_MFD_SM501_GPIO is not set
CONFIG_MFD_RTSX_PCI=m
CONFIG_MFD_TI_AM335X_TSCADC=m
# CONFIG_HTC_PASIC3 is not set
# CONFIG_UCB1400_CORE is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_SPI=y
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_TMIO is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM831X_SPI is not set
CONFIG_MFD_MC13783=m
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_SPI=m
# CONFIG_ABX500_CORE is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_TIMBERDALE=m
CONFIG_LPC_SCH=m
CONFIG_LPC_ICH=m
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_DUMMY=y
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_GPIO is not set
# CONFIG_REGULATOR_DA9052 is not set
# CONFIG_REGULATOR_MC13783 is not set
# CONFIG_REGULATOR_MC13892 is not set
# CONFIG_REGULATOR_TPS6524X is not set
# CONFIG_REGULATOR_TPS65912 is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=m
# CONFIG_AGP_AMD64 is not set
# CONFIG_AGP_INTEL is not set
CONFIG_AGP_SIS=m
# CONFIG_AGP_VIA is not set
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=m
# CONFIG_LCD_S6E63M0 is not set
CONFIG_LCD_LD9040=m
CONFIG_LCD_AMS369FG06=m
CONFIG_LCD_LMS501KF03=m
CONFIG_LCD_HX8357=m
CONFIG_BACKLIGHT_CLASS_DEVICE=m
CONFIG_BACKLIGHT_ATMEL_PWM=m
CONFIG_BACKLIGHT_GENERIC=m
CONFIG_BACKLIGHT_PWM=m
CONFIG_BACKLIGHT_DA9052=m
CONFIG_BACKLIGHT_APPLE=m
CONFIG_BACKLIGHT_SAHARA=m
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_HRTIMER is not set
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
CONFIG_SND_DUMMY=m
CONFIG_SND_ALOOP=m
# CONFIG_SND_MTPAV is not set
CONFIG_SND_MTS64=m
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=m
CONFIG_SND_PORTMAN2X4=m
# CONFIG_SND_AC97_POWER_SAVE is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
CONFIG_SND_ALS300=m
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ASIHPI is not set
# CONFIG_SND_ATIIXP is not set
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
# CONFIG_SND_AU8820 is not set
CONFIG_SND_AU8830=m
CONFIG_SND_AW2=m
CONFIG_SND_AZT3328=m
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
CONFIG_SND_CMIPCI=m
CONFIG_SND_OXYGEN_LIB=m
CONFIG_SND_OXYGEN=m
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
CONFIG_SND_CS5535AUDIO=m
CONFIG_SND_CTXFI=m
CONFIG_SND_DARLA20=m
CONFIG_SND_GINA20=m
CONFIG_SND_LAYLA20=m
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
CONFIG_SND_LAYLA24=m
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
CONFIG_SND_INDIGOIO=m
# CONFIG_SND_INDIGODJ is not set
CONFIG_SND_INDIGOIOX=m
CONFIG_SND_INDIGODJX=m
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1X=m
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
CONFIG_SND_ES1938=m
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
CONFIG_SND_HDSP=m
# CONFIG_SND_HDSPM is not set
CONFIG_SND_ICE1712=m
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
CONFIG_SND_KORG1212=m
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
CONFIG_SND_MIXART=m
CONFIG_SND_NM256=m
# CONFIG_SND_PCXHR is not set
CONFIG_SND_RIPTIDE=m
# CONFIG_SND_RME32 is not set
CONFIG_SND_RME96=m
CONFIG_SND_RME9652=m
# CONFIG_SND_SONICVIBES is not set
CONFIG_SND_TRIDENT=m
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_SPI=y
# CONFIG_SND_AT73C213 is not set
# CONFIG_SND_FIREWIRE is not set
# CONFIG_SND_SOC is not set
CONFIG_SOUND_PRIME=m
CONFIG_AC97_BUS=m

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
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=m
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_PRODIKEYS is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=m
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_PS3REMOTE is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_HCD_BCMA is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#
# CONFIG_OMAP_USB3 is not set
# CONFIG_OMAP_CONTROL_USB is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
CONFIG_UWB=m
CONFIG_UWB_WHCI=m
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_SDIO_UART=m
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_SDHCI_PXAV3 is not set
CONFIG_MMC_SDHCI_PXAV2=m
CONFIG_MMC_TIFM_SD=m
CONFIG_MMC_SPI=m
# CONFIG_MMC_CB710 is not set
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MMC_REALTEK_PCI=m
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
CONFIG_LEDS_ATMEL_PWM=m
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_DA9052 is not set
CONFIG_LEDS_DAC124S085=m
# CONFIG_LEDS_PWM is not set
CONFIG_LEDS_REGULATOR=m
CONFIG_LEDS_LT3593=m
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_OT200=m
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
# CONFIG_INFINIBAND_MTHCA is not set
CONFIG_INFINIBAND_QIB=m
# CONFIG_INFINIBAND_AMSO1100 is not set
CONFIG_INFINIBAND_NES=m
# CONFIG_INFINIBAND_NES_DEBUG is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=m
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC=m
CONFIG_DW_DMAC_BIG_ENDIAN_IO=y
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_ASYNC_TX_DMA is not set
# CONFIG_DMATEST is not set
CONFIG_AUXDISPLAY=y
# CONFIG_KS0108 is not set
CONFIG_UIO=m
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV is not set
CONFIG_UIO_PDRV_GENIRQ=m
CONFIG_UIO_DMEM_GENIRQ=m
# CONFIG_UIO_AEC is not set
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
CONFIG_UIO_NETX=m
CONFIG_VFIO_IOMMU_TYPE1=m
CONFIG_VFIO=m
CONFIG_VFIO_PCI=m
CONFIG_VIRTIO=m

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=m
# CONFIG_VIRTIO_BALLOON is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACERHDF=m
# CONFIG_ASUS_LAPTOP is not set
CONFIG_DELL_LAPTOP=m
CONFIG_FUJITSU_LAPTOP=m
CONFIG_FUJITSU_LAPTOP_DEBUG=y
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_AMILO_RFKILL is not set
# CONFIG_HP_ACCEL is not set
CONFIG_MSI_LAPTOP=m
CONFIG_PANASONIC_LAPTOP=m
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_IDEAPAD_LAPTOP is not set
CONFIG_THINKPAD_ACPI=m
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
CONFIG_THINKPAD_ACPI_UNSAFE_LEDS=y
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_SENSORS_HDAPS=m
CONFIG_EEEPC_LAPTOP=m
# CONFIG_ACPI_WMI is not set
CONFIG_TOPSTAR_LAPTOP=m
CONFIG_TOSHIBA_BT_RFKILL=m
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
CONFIG_IBM_RTL=m
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_LAPTOP is not set
# CONFIG_INTEL_OAKTRAIL is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
CONFIG_COMMON_CLK_DEBUG=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_AMD_IOMMU=y
# CONFIG_AMD_IOMMU_STATS is not set
# CONFIG_INTEL_IOMMU is not set
# CONFIG_IRQ_REMAP is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=m
CONFIG_STE_MODEM_RPROC=m

#
# Rpmsg drivers
#
# CONFIG_VIRT_DRIVERS is not set
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
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
CONFIG_VME_BUS=m

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=m
CONFIG_VME_TSI148=m

#
# VME Board Drivers
#
# CONFIG_VMIVME_7805 is not set

#
# VME Device Drivers
#
CONFIG_PWM=y
CONFIG_IPACK_BUS=m
CONFIG_BOARD_TPCI200=m
# CONFIG_SERIAL_IPOCTAL is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=m
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QFMT_V1=m
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_FSCACHE_OBJECT_LIST=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_SYSCTL is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ECRYPT_FS=m
# CONFIG_ECRYPT_FS_MESSAGING is not set
# CONFIG_JFFS2_FS is not set
# CONFIG_LOGFS is not set
CONFIG_ROMFS_FS=m
CONFIG_ROMFS_BACKED_BY_MTD=y
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_RAM=m
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=m
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=m
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=m
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=m
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=m
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_PREEMPT=y
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
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_LIST=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
CONFIG_PROVE_RCU_DELAY=y
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_NOTIFIER_ERROR_INJECTION=m
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=m
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
# CONFIG_DEBUG_PAGEALLOC is not set
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
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
CONFIG_RBTREE_TEST=m
CONFIG_INTERVAL_TREE_TEST=m
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_KSTRTOX=m
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
# CONFIG_EARLY_PRINTK is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
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
# CONFIG_DEBUG_BOOT_PARAMS is not set
CONFIG_CPA_DEBUG=y
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_SECURITY_SMACK=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_YAMA_STACKED is not set
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_APPRAISE=y
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_SMACK=y
# CONFIG_DEFAULT_SECURITY_YAMA is not set
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="smack"
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
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
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_ABLK_HELPER_X86=m
CONFIG_CRYPTO_GLUE_HELPER_X86=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_X86_64=y
CONFIG_CRYPTO_CRC32C_INTEL=m
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=m
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_SEED=m
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
CONFIG_CRYPTO_TEA=m
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_X86_64 is not set
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
# CONFIG_PKCS7_MESSAGE_PARSER is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

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
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_CRC8=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_ATA_SFF is not set
# CONFIG_DRM_TTM is not set
# CONFIG_ISDN_DRV_LOOP is not set

--gBBFr7Ir9EOA20Yy--
