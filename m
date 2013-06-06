Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab3FFNZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 09:25:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:37547 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab3FFNZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:25:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,815,1363158000"; 
   d="log'?scan'208";a="345788819"
Date: Thu, 6 Jun 2013 21:25:22 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>, linux-kernel@vger.kernel.org
Subject: [IPC] INFO: suspicious RCU usage.
Message-ID: <20130606132522.GA18959@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit 1f6587114a689a5d7fdfb0d4abc818117e3182a5
Author: Davidlohr Bueso <davidlohr.bueso@hp.com>
Date:   Thu Jun 6 10:41:56 2013 +1000

    ipc: move rcu lock out of ipc_addid
    
    This patchset continues the work that began in the sysv ipc semaphore
    scaling series: https://lkml.org/lkml/2013/3/20/546
    
    Just like semaphores used to be, sysv shared memory and msg queues also
    abuse the ipc lock, unnecessarily holding it for operations such as
    permission and security checks.  This patchset mostly deals with mqueues,
    and while shared mem can be done in a very similar way, I want to get
    these patches out in the open first.  It also does some pending cleanups,
    mostly focused on the two level locking we have in ipc code, taking care
    of ipc_addid() and ipcctl_pre_down_nolock() - yes there are still
    functions that need to be updated as well.
    
    This patch:
    
    Make all callers explicitly take and release the RCU read lock.
    
    This addresses the two level locking seen in newary(), newseg() and
    newqueue().  For the last two, explicitly unlock the ipc object and the
    rcu lock, instead of calling the custom shm_unlock and msg_unlock
    functions.  The next patch will deal with the open coded locking for
    ->perm.lock
    
    Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
    Cc: Andi Kleen <andi@firstfloor.org>
    Cc: Rik van Riel <riel@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

[   51.524946] 
[   51.525983] ===============================
[   51.532875] [ INFO: suspicious RCU usage. ]
[   51.535385] 3.10.0-rc4-next-20130606 #6 Not tainted
[   51.538304] -------------------------------
[   51.540937] /c/kernel-tests/src/stable/include/linux/rcupdate.h:471 Illegal context switch in RCU read-side critical section!
[   51.548110] 
[   51.548110] other info that might help us debug this:
[   51.548110] 
[   51.553055] 
[   51.553055] rcu_scheduler_active = 1, debug_locks = 1
[   51.557199] 2 locks held by trinity/1107:
[   51.560168]  #0:  (&ids->rw_mutex){+.+.+.}, at: [<ffffffff811e15ee>] ipcget+0x38/0x2b3
[   51.566465]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff811e7698>] newseg+0x19d/0x3fd
[   51.572413] 
[   51.572413] stack backtrace:
[   51.574761] CPU: 0 PID: 1107 Comm: trinity Not tainted 3.10.0-rc4-next-20130606 #6
[   51.579331] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   51.583068]  0000000000000001 ffff880004a07d88 ffffffff817b1f5c ffff880004a07db8
[   51.592119]  ffffffff810f2f1d ffffffff81b78569 00000000000001a8 0000000000000000
[   51.596726]  0000000000000000 ffff880004a07de8 ffffffff810ded5e ffff880004a07fd8
[   51.605189] Call Trace:
[   51.606409]  [<ffffffff817b1f5c>] dump_stack+0x19/0x1b
[   51.609632]  [<ffffffff810f2f1d>] lockdep_rcu_suspicious+0xeb/0xf4
[   51.612905]  [<ffffffff810ded5e>] __might_sleep+0x59/0x1dc
[   51.618614]  [<ffffffff81238623>] idr_preload+0x9b/0x142
[   51.621939]  [<ffffffff811e0e56>] ipc_addid+0x3d/0x193
[   51.624373]  [<ffffffff811e771c>] newseg+0x221/0x3fd
[   51.626596]  [<ffffffff811e7698>] ? newseg+0x19d/0x3fd
[   51.630177]  [<ffffffff811e1774>] ipcget+0x1be/0x2b3
[   51.633174]  [<ffffffff817bc094>] ? retint_swapgs+0x13/0x1b
[   51.636356]  [<ffffffff811e7a5a>] SyS_shmget+0x59/0x5d
[   51.639576]  [<ffffffff811e74fb>] ? shm_try_destroy_orphaned+0xbf/0xbf
[   51.643673]  [<ffffffff811e6ce5>] ? shm_get_unmapped_area+0x20/0x20
[   51.647321]  [<ffffffff811e6cf0>] ? shm_security+0xb/0xb
[   51.650831]  [<ffffffff817bcb27>] system_call_fastpath+0x16/0x1b

git bisect start 4e1e7059d375482daeeda395bba2939679b1ee14 e3e160d1c8b68beede8e47b281bf6369b833f1c5 --
git bisect good 04eb3039eba693d510952e8867fc0b057955f840  #    10  2013-06-06 19:18:45  shrinker: convert remaining shrinkers to count/scan API
git bisect good 870ce17d96260246bd343f55b55b6adb468aab76  #    10  2013-06-06 19:46:15  rtc: rtc-mpc5121: use devm_*() functions
git bisect good e75aff7f353f503d38863fd0a3e1d1e4a3312325  #    10  2013-06-06 19:52:37  x86: kill TIF_DEBUG
git bisect  bad 93f94fca3e3edc76bd3f392edcd8ddc13629c626  #     0  2013-06-06 19:58:13  ipc/sem.c: rename try_atomic_semop() to perform_atomic_semop(), docu update
git bisect good e6391c3a76e29b92a6c0183f4d94776c1ca9ecbc  #    10  2013-06-06 20:45:47  ia64: remove setting for saved_max_pfn
git bisect  bad 47cde6c8674ec0598b6da4c0813ec984ee209d97  #     0  2013-06-06 20:50:16  ipc,msg: shorten critical region in msgctl_down
git bisect good 343ff671539e6ce9bc849d881fcec5c004342e0a  #    10  2013-06-06 20:55:29  ipc/shmc.c: eliminate ugly 80-col tricks
git bisect  bad e3a7780fbb54d93fd053182d4b1f8c5596b37247  #     0  2013-06-06 21:02:39  ipc: introduce ipc object locking helpers
git bisect  bad 1f6587114a689a5d7fdfb0d4abc818117e3182a5  #     0  2013-06-06 21:12:01  ipc: move rcu lock out of ipc_addid
git bisect good 343ff671539e6ce9bc849d881fcec5c004342e0a  #    30  2013-06-06 21:15:37  ipc/shmc.c: eliminate ugly 80-col tricks
git bisect  bad 4e1e7059d375482daeeda395bba2939679b1ee14  #     0  2013-06-06 21:15:40  Add linux-next specific files for 20130606
git bisect  bad 4e1e7059d375482daeeda395bba2939679b1ee14  #     0  2013-06-06 21:15:52  Add linux-next specific files for 20130606

Thanks,
Fengguang

--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-cairo-52292-20130606163350-3.10.0-rc4-next-20130606-6"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.10.0-rc4-next-20130606 (kbuild@hive) (gcc version 4.7.1 (GCC) ) #6 Thu Jun 6 16:31:14 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-h005-0606/next:master/.vmlinuz-4e1e7059d375482daeeda395bba2939679b1ee14-20130606163250-9-cairo branch=next/master  BOOT_IMAGE=/kernel/x86_64-randconfig-h005-0606/4e1e7059d375482daeeda395bba2939679b1ee14/vmlinuz-3.10.0-rc4-next-20130606
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x400000000
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at [ffff8800000fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x029c8000, 0x029c8fff] PGTABLE
[    0.000000] BRK [0x029c9000, 0x029c9fff] PGTABLE
[    0.000000] BRK [0x029ca000, 0x029cafff] PGTABLE
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
[    0.000000] BRK [0x029cb000, 0x029cbfff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127432(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000000ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000d400000-ffff88000d7fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65424
[    0.000000]   DMA32 zone: 1024 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 65424 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1e2bf80
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64379
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-h005-0606/next:master/.vmlinuz-4e1e7059d375482daeeda395bba2939679b1ee14-20130606163250-9-cairo branch=next/master  BOOT_IMAGE=/kernel/x86_64-randconfig-h005-0606/4e1e7059d375482daeeda395bba2939679b1ee14/vmlinuz-3.10.0-rc4-next-20130606
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 198776K/261696K available (7933K kernel code, 1788K rwdata, 4260K rodata, 1204K init, 9060K bss, 62920K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
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
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2893.002 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5786.00 BogoMIPS (lpj=28930020)
[    0.020017] pid_max: default: 32768 minimum: 301
[    0.021604] Security Framework initialized
[    0.022843] AppArmor: AppArmor initialized
[    0.028225] Mount-cache hash table entries: 256
[    0.034719] Initializing cgroup subsys debug
[    0.036000] Initializing cgroup subsys devices
[    0.037343] Initializing cgroup subsys perf_event
[    0.038785] Initializing cgroup subsys net_prio
[    0.040247] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.040247] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.040247] tlb_flushall_shift: 6
[    0.048075] CPU: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.062899] ACPI: Core revision 20130418
[    0.107974] ACPI: All ACPI Tables successfully acquired
[    0.110145] ftrace: allocating 31043 entries in 122 pages
[    0.130252] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.133566] ftrace: Allocated trace_printk buffers
[    0.145207] Testing tracer nop: PASSED
[    0.147063] Getting VERSION: 50014
[    0.148000] Getting VERSION: 50014
[    0.150027] Getting ID: 0
[    0.150798] Getting ID: ff000000
[    0.151684] Getting LVT0: 8700
[    0.152510] Getting LVT1: 8400
[    0.153439] enabled ExtINT on CPU#0
[    0.161382] ENABLING IO-APIC IRQs
[    0.162426] init IO_APIC IRQs
[    0.170015]  apic 2 pin 0 not connected
[    0.171072] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.173165] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.175273] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.177392] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.180063] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.182245] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.190057] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.192119] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.196325] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.198570] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.200061] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.202367] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.210051] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.212269] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.220063] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.222294]  apic 2 pin 16 not connected
[    0.223405]  apic 2 pin 17 not connected
[    0.230015]  apic 2 pin 18 not connected
[    0.231042]  apic 2 pin 19 not connected
[    0.232154]  apic 2 pin 20 not connected
[    0.240015]  apic 2 pin 21 not connected
[    0.241111]  apic 2 pin 22 not connected
[    0.242140]  apic 2 pin 23 not connected
[    0.243453] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.246058] Using local APIC timer interrupts.
[    0.246058] calibrating APIC timer ...
[    0.260000] ... lapic delta = 6516424
[    0.260000] ... PM-Timer delta = 373210
[    0.260000] APIC calibration not consistent with PM-Timer: 104ms instead of 100ms
[    0.260000] APIC delta adjusted to PM-Timer: 6250046 (6516424)
[    0.260000] TSC delta adjusted to PM-Timer: 289295047 (301624803)
[    0.260000] ..... delta 6250046
[    0.260000] ..... mult: 268437431
[    0.260000] ..... calibration result: 10000073
[    0.260000] ..... CPU clock speed is 2892.9504 MHz.
[    0.260000] ..... host bus clock speed is 1000.0073 MHz.
[    0.265550] EVM: security.capability
[    0.268089] Testing tracer function: PASSED
[    0.461698] Testing dynamic ftrace: PASSED
[    0.800469] Testing dynamic ftrace ops #1: (1 0 1 1 0) (1 1 2 1 0) (2 1 3 1 4) (2 2 4 1 82) PASSED
[    1.084729] Testing dynamic ftrace ops #2: (1 0 1 4 0) (1 1 2 82 0) (2 1 3 1 5) (2 2 4 79 83) PASSED
[    1.668098] Testing ftrace recursion: PASSED
[    1.711841] Testing ftrace recursion safe: PASSED
[    1.752940] Testing ftrace regs: PASSED
[    1.789374] Testing tracer irqsoff: PASSED
[    1.932929] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    1.937659] regulator-dummy: no parameters
[    1.940336] RTC time:  8:31:50, date: 06/06/13
[    1.943073] NET: Registered protocol family 16
[    1.947494] ACPI: bus type PCI registered
[    1.950095] PCI: Using configuration type 1 for base access
[    2.000475] ACPI: Added _OSI(Module Device)
[    2.002316] ACPI: Added _OSI(Processor Device)
[    2.004288] ACPI: Added _OSI(3.0 _SCP Extensions)
[    2.006473] ACPI: Added _OSI(Processor Aggregator Device)
[    2.015592] ACPI: EC: Look up EC in DSDT
[    2.081307] ACPI: Interpreter enabled
[    2.083400] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130418/hwxface-568)
[    2.092856] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130418/hwxface-568)
[    2.102924] ACPI: (supports S0 S3 S5)
[    2.110014] ACPI: Using IOAPIC for interrupt routing
[    2.112812] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    2.271267] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    2.273305] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    2.275628] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    2.279101] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    2.280016] acpi PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    2.283934] PCI: root bus 00: using default resources
[    2.290291] PCI host bridge to bus 0000:00
[    2.292298] pci_bus 0000:00: root bus resource [bus 00-ff]
[    2.294842] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    2.300034] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
[    2.310153] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    2.322191] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    2.331449] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    2.336949] pci 0000:00:01.1: reg 0x20: [io  0xc1e0-0xc1ef]
[    2.347793] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    2.360134] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    2.366228] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    2.375000] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    2.384123] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    2.388807] pci 0000:00:02.0: reg 0x14: [mem 0xfebe0000-0xfebe0fff]
[    2.401904] pci 0000:00:02.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    2.406551] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    2.411042] pci 0000:00:03.0: reg 0x10: [io  0xc1c0-0xc1df]
[    2.416165] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    2.430868] pci 0000:00:03.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    2.434833] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    2.438637] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    2.440854] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    2.452080] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    2.459051] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    2.461003] pci 0000:00:05.0: reg 0x10: [io  0xc040-0xc07f]
[    2.467658] pci 0000:00:05.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[    2.480466] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    2.484099] pci 0000:00:06.0: reg 0x10: [io  0xc080-0xc0bf]
[    2.490014] pci 0000:00:06.0: reg 0x14: [mem 0xfebe3000-0xfebe3fff]
[    2.503224] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    2.511097] pci 0000:00:07.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    2.517488] pci 0000:00:07.0: reg 0x14: [mem 0xfebe4000-0xfebe4fff]
[    2.525536] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    2.530987] pci 0000:00:08.0: reg 0x10: [io  0xc100-0xc13f]
[    2.534254] pci 0000:00:08.0: reg 0x14: [mem 0xfebe5000-0xfebe5fff]
[    2.543310] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    2.550016] pci 0000:00:09.0: reg 0x10: [io  0xc140-0xc17f]
[    2.556500] pci 0000:00:09.0: reg 0x14: [mem 0xfebe6000-0xfebe6fff]
[    2.574709] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    2.580015] pci 0000:00:0a.0: reg 0x10: [io  0xc180-0xc1bf]
[    2.585528] pci 0000:00:0a.0: reg 0x14: [mem 0xfebe7000-0xfebe7fff]
[    2.594672] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    2.597767] pci 0000:00:0b.0: reg 0x10: [mem 0xfebe8000-0xfebe800f]
[    2.603975] pci_bus 0000:00: on NUMA node 0
[    2.606022] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    2.624316] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    2.628717] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    2.632378] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    2.651804] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    2.662192] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    2.688212] ACPI: Enabled 16 GPEs in block 00 to 0F
[    2.690069] ACPI: \_SB_.PCI0: notify handler is installed
[    2.691868] Found 1 acpi root devices
[    2.706177] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    2.710023] vgaarb: loaded
[    2.710926] vgaarb: bridge control possible 0000:00:02.0
[    2.721431] ACPI: bus type USB registered
[    2.723062] usbcore: registered new interface driver usbfs
[    2.730157] usbcore: registered new interface driver hub
[    2.732382] usbcore: registered new device driver usb
[    2.740514] Linux video capture interface: v2.00
[    2.742201] pps_core: LinuxPPS API ver. 1 registered
[    2.750012] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    2.757008] PTP clock support registered
[    2.760892] PCI: Using ACPI for IRQ routing
[    2.762224] PCI: pci_cache_line_size set to 64 bytes
[    2.770469] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    2.772387] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    2.782532] cfg80211: Calling CRDA to update world regulatory domain
[    2.790420] nfc: nfc_init: NFC Core ver 0.1
[    2.791947] NET: Registered protocol family 39
[    2.800869] Switching to clocksource kvm-clock
[    2.808750] Warning: could not register annotated branches stats
[    3.041861] FS-Cache: Loaded
[    3.043913] AppArmor: AppArmor Filesystem Enabled
[    3.046596] pnp: PnP ACPI init
[    3.051079] ACPI: bus type PNP registered
[    3.053334] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    3.057664] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    3.061526] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    3.065798] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    3.069584] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    3.077222] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    3.081271] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    3.085303] pnp 00:03: [dma 2]
[    3.087133] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    3.095586] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    3.109983] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    3.121604] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    3.131564] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    3.144773] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    3.150304] pnp: PnP ACPI: found 7 devices
[    3.159409] ACPI: bus type PNP unregistered
[    3.174224] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    3.176991] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[    3.184664] NET: Registered protocol family 1
[    3.186795] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    3.194351] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    3.201805] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    3.204970] pci 0000:00:02.0: Boot video device
[    3.211760] PCI: CLS 0 bytes, default 64
[    3.214574] Unpacking initramfs...
[    7.274698] Freeing initrd memory: 23656K (ffff88000e8d6000 - ffff88000fff0000)
[    7.950633] DMA-API: preallocated 65536 debug entries
[    7.953119] DMA-API: debugging enabled by kernel config
[    7.956220] kvm: no hardware support
[    7.972105] has_svm: not amd
[    7.973627] kvm: no hardware support
[    7.977058] cryptomgr_test (12) used greatest stack depth: 6544 bytes left
[    7.990916] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
[    8.005766] twofish-x86_64-3way: performance on this CPU would be suboptimal: disabling twofish-x86_64-3way.
[    8.015411] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    8.028767] AVX or AES-NI instructions are not detected.
[    8.031541] AVX instructions are not detected.
[    8.036156] AVX instructions are not detected.
[    8.045168] AVX2 instructions are not detected.
[    8.056341] audit: initializing netlink socket (disabled)
[    8.059228] type=2000 audit(1370507517.050:1): initialized
[    8.062117] rcu-torture:--- Start of test: nreaders=2 nfakewriters=4 stat_interval=60 verbose=0 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 stall_cpu=0 stall_cpu_holdoff=10 n_barrier_cbs=0 onoff_interval=0 onoff_holdoff=0
[    8.110607] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    8.163398] fuse init (API version 7.22)
[    8.174711] msgmni has been set to 434
[    8.200780] NET: Registered protocol family 38
[    8.205792] Key type asymmetric registered
[    8.212780] Asymmetric key parser 'x509' registered
[    8.215133] test_string_helpers: Running tests...
[    8.226288] xz_dec_test: module loaded
[    8.228320] xz_dec_test: Create a device node with 'mknod xz_dec_test c 250 0' and write .xz files to it.
[    8.234353] no IO addresses supplied
[    8.242768] hgafb: HGA card not detected.
[    8.244946] hgafb: probe of hgafb.0 failed with error -22
[    8.256751] usbcore: registered new interface driver udlfb
[    8.273820] kworker/u2:0 (85) used greatest stack depth: 5536 bytes left
[    8.287604] uvesafb: failed to execute /sbin/v86d
[    8.290172] uvesafb: make sure that the v86d helper is installed and executable
[    8.293757] uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
[    8.296871] uvesafb: vbe_init() failed with -22
[    8.305403] uvesafb: probe of uvesafb.0 failed with error -22
[    8.317024] ipmi message handler version 39.2
[    8.319321] ipmi device interface
[    8.321373] IPMI System Interface driver.
[    8.332764] ipmi_si: Adding default-specified kcs state machine
[    8.335853] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[    8.355463] ipmi_si: Interface detection failed
[    8.358246] ipmi_si: Adding default-specified smic state machine
[    8.361618] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[    8.373805] ipmi_si: Interface detection failed
[    8.376130] ipmi_si: Adding default-specified bt state machine
[    8.389020] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[    8.396624] ipmi_si: Interface detection failed
[    8.400424] ipmi_si: Unable to find any System Interface(s)
[    8.406293] IPMI Watchdog: driver initialized
[    8.419176] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[    8.423841] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    8.441746] ACPI: Power Button [PWRF]
[    8.628671] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    8.692309] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    8.707568] Non-volatile memory driver v1.3
[    8.709783] telclk_interrupt = 0xf non-mcpbl0010 hw.
[    8.722638] SyncLink PC Card driver $Revision: 4.34 $, tty major#248
[    8.725941] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    8.735070] Hangcheck: Using getrawmonotonic().
[    8.742005] [drm:drm_core_init] *ERROR* Cannot create /proc/dri
[    8.745290] dummy-irq: no IRQ given.  Use irq=N
[    8.756444] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[    8.760534] c2port c2port0: C2 port uc added
[    8.762794] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
[    8.778643] usbcore: registered new interface driver viperboard
[    8.781909] usbcore: registered new interface driver pn533
[    8.784751] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
[    8.807914] libphy: Fixed MDIO Bus: probed
[    8.810806] tun: Universal TUN/TAP device driver, 1.6
[    8.813367] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    8.819959] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.tc.umn.edu>
[    8.824652] ipddp0: Appletalk-IP Decap. mode by Jay Schulist <jschlst@samba.org>
[    8.843682] vcan: Virtual CAN interface driver
[    8.845985] CAN device driver interface
[    8.848084] usbcore: registered new interface driver ems_usb
[    8.851101] usbcore: registered new interface driver esd_usb2
[    8.854247] sja1000 CAN netdevice driver
[    8.856247] sja1000_isa: insufficient parameters supplied
[    8.863307] cc770: CAN netdevice driver
[    8.865395] cc770_isa: insufficient parameters supplied
[    8.873781] AX.25: 6pack driver, Revision: 0.3.0
[    8.876247] AX.25: bpqether driver version 004
[    8.882633] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    8.882633] baycom_ser_hdx: version 0.10
[    8.890650] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[    8.893669] hdlcdrv: version 0.8
[    8.905892] hdlc: HDLC support module revision 1.22
[    8.908453] LAPB Ethernet driver version 0.02
[    8.910841] airo(): Probing for PCI adapters
[    8.913528] airo(): Finished probing for PCI adapters
[    8.916439] Broadcom 43xx-legacy driver loaded [ Features: PLID ]
[    8.934410] usbcore: registered new interface driver zd1211rw
[    8.945780] usbcore: registered new interface driver zd1201
[    8.953398] usbcore: registered new interface driver usb8797
[    8.956403] usbcore: registered new interface driver i2400m_usb
[    8.969795] usbcore: registered new interface driver catc
[    8.979180] usbcore: registered new interface driver kaweth
[    8.981972] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
[    8.996600] usbcore: registered new interface driver pegasus
[    9.008738] usbcore: registered new interface driver rtl8150
[    9.011834] usbcore: registered new interface driver r8152
[    9.026138] hso: /c/kernel-tests/src/stable/drivers/net/usb/hso.c: Option Wireless
[    9.034363] usbcore: registered new interface driver hso
[    9.037157] usbcore: registered new interface driver asix
[    9.050220] usbcore: registered new interface driver ax88179_178a
[    9.056718] usbcore: registered new interface driver cdc_ether
[    9.064688] usbcore: registered new interface driver cdc_eem
[    9.075756] usbcore: registered new interface driver smsc95xx
[    9.078856] usbcore: registered new interface driver gl620a
[    9.081778] usbcore: registered new interface driver net1080
[    9.094900] usbcore: registered new interface driver plusb
[    9.102026] usbcore: registered new interface driver rndis_host
[    9.105194] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    9.116238] usbcore: registered new interface driver int51x1
[    9.123258] usbcore: registered new interface driver sierra_net
[    9.126359] usbcore: registered new interface driver cx82310_eth
[    9.139701] usbcore: registered new interface driver cdc_ncm
[    9.142669] usbcore: registered new interface driver cdc_mbim
[    9.162095] usbcore: registered new interface driver cdc_acm
[    9.164782] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[    9.173943] usbcore: registered new interface driver usblp
[    9.176864] usbcore: registered new interface driver cdc_wdm
[    9.192061] usbcore: registered new interface driver usbtmc
[    9.194898] usbcore: registered new interface driver mdc800
[    9.205769] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
[    9.210658] usbcore: registered new interface driver appledisplay
[    9.216154] usbcore: registered new interface driver emi62 - firmware loader
[    9.227917] driver ftdi-elan
[    9.230597] usbcore: registered new interface driver ftdi-elan
[    9.233330] usbcore: registered new interface driver idmouse
[    9.240239] usbcore: registered new interface driver usblcd
[    9.243515] usbcore: registered new interface driver ldusb
[    9.258510] usbcore: registered new interface driver usbled
[    9.261160] usbcore: registered new interface driver legousbtower
[    9.263904] usbcore: registered new interface driver usbtest
[    9.266899] usbcore: registered new interface driver trancevibrator
[    9.278416] usbcore: registered new interface driver usbsevseg
[    9.281602] usbcore: registered new interface driver yurex
[    9.288938] usbcore: registered new interface driver sisusb
[    9.292664] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 May 2005
[    9.304830] dummy_hcd dummy_hcd.0: Dummy host controller
[    9.322714] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus number 1
[    9.326946] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    9.340414] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    9.343921] usb usb1: Product: Dummy host controller
[    9.352770] usb usb1: Manufacturer: Linux 3.10.0-rc4-next-20130606 dummy_hcd
[    9.359167] usb usb1: SerialNumber: dummy_hcd.0
[    9.362831] hub 1-0:1.0: USB hub found
[    9.373278] hub 1-0:1.0: 1 port detected
[    9.387661] udc dummy_udc.0: registering UDC driver [g_ether]
[    9.390782] g_ether gadget: using random self ethernet address
[    9.398871] g_ether gadget: using random host ethernet address
[    9.402854] usb0: MAC 46:e6:21:28:87:fd
[    9.412795] usb0: HOST MAC 76:73:90:3e:fe:34
[    9.414930] g_ether gadget: adding config #2 'RNDIS'/ffffffff81eb99c0
[    9.425149] g_ether gadget: adding 'rndis'/ffff880004dc0d20 to config 'RNDIS'/ffffffff81eb99c0
[    9.433441] rndis_register: configNr = 0
[    9.435480] rndis_set_param_medium: 0 0
[    9.443189] g_ether gadget: RNDIS: super speed IN/ep1in-bulk OUT/ep2out-bulk NOTIFY/ep5in-int
[    9.447212] g_ether gadget: cfg 2/ffffffff81eb99c0 speeds: super high full
[    9.454178] g_ether gadget:   interface 0 = rndis/ffff880004dc0d20
[    9.457232] g_ether gadget:   interface 1 = rndis/ffff880004dc0d20
[    9.464315] g_ether gadget: adding config #1 'CDC Ethernet (EEM)'/ffffffff81eb98a0
[    9.477081] g_ether gadget: adding 'cdc_eem'/ffff880004dc1068 to config 'CDC Ethernet (EEM)'/ffffffff81eb98a0
[    9.481836] g_ether gadget: CDC Ethernet (EEM): super speed IN/ep1in-bulk OUT/ep2out-bulk
[    9.494259] g_ether gadget: cfg 1/ffffffff81eb98a0 speeds: super high full
[    9.497574] g_ether gadget:   interface 0 = cdc_eem/ffff880004dc1068
[    9.500611] g_ether gadget: Ethernet Gadget, version: Memorial Day 2008
[    9.508310] g_ether gadget: g_ether ready
[    9.510432] dummy_udc dummy_udc.0: binding gadget driver 'g_ether'
[    9.518583] dummy_udc dummy_udc.0: This device can perform faster if you connect it to a super-speed port...
[    9.523215] dummy_hcd dummy_hcd.0: port status 0x00010101 has changes
[    9.533186] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    9.543294] serio: i8042 KBD port at 0x60,0x64 irq 1
[    9.565782] serio: i8042 AUX port at 0x60,0x64 irq 12
[    9.875068] mousedev: PS/2 mouse device common for all mice
[    9.910990] tsc: Refined TSC clocksource calibration: 2893.028 MHz
[    9.920396] dummy_hcd dummy_hcd.0: port status 0x00010101 has changes
[    9.934910] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    9.986326] i2c /dev entries driver
[    9.988467] usbcore: registered new interface driver i2c-diolan-u2c
[   10.001875] i2c-parport-light: adapter type unspecified
[   10.008492] usbcore: registered new interface driver i2c-tiny-usb
[   10.012577] pps pps0: new PPS source ktimer
[   10.015748] pps pps0: ktimer PPS source registered
[   10.018431] Driver for 1-wire Dallas network protocol.
[   10.022997] usbcore: registered new interface driver DS9490R
[   10.025906] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[   10.032023] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
[   10.047056] f71882fg: Not a Fintek device
[   10.060309] f71882fg: Not a Fintek device
[   10.076416] usbcore: registered new interface driver pcwd_usb
[   10.084220] advantechwdt: WDT driver for Advantech single board computer initialising
[   10.092640] advantechwdt: initialized. timeout=60 sec (nowayout=0)
[   10.100585] sc520_wdt: cannot register miscdev on minor=130 (err=-16)
[   10.119136] ib700wdt: WDT driver for IB700 single board computer initialising
[   10.122927] ib700wdt: START method I/O 443 is not available
[   10.132181] ib700wdt: probe of ib700wdt failed with error -5
[   10.134950] sc1200wdt: build 20020303
[   10.136809] sc1200wdt: io parameter must be specified
[   10.139243] sbc60xxwdt: I/O address 0x0443 already in use
[   10.143141] cpu5wdt: misc_register failed
[   10.144992] w83627hf_wdt: WDT driver for the Winbond(TM) W83627HF/THF/HG/DHG Super I/O chip initialising
[   10.149373] w83627hf_wdt: Watchdog already running. Resetting timeout to 60 sec
[   10.153706] w83627hf_wdt: cannot register miscdev on minor=130 (err=-16)
[   10.156565] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Super I/O chip initialising
[   10.160674] w83697ug_wdt: No W83697UG/UF could be found
[   10.162787] w83877f_wdt: I/O address 0x0443 already in use
[   10.164785] w83977f_wdt: driver v1.00
[   10.166177] w83977f_wdt: cannot register miscdev on minor=130 (err=-16)
[   10.168847] machzwd: MachZ ZF-Logic Watchdog driver initializing
[   10.171096] machzwd: no ZF-Logic found
[   10.172963] cpuidle: using governor ladder
[   10.174850] cpuidle: using governor menu
[   10.177274] sdhci: Secure Digital Host Controller Interface driver
[   10.180258] sdhci: Copyright(c) Pierre Ossman
[   10.182411] wbsd: Winbond W83L51xD SD/MMC card interface driver
[   10.185131] wbsd: Copyright(c) Pierre Ossman
[   10.191549] VUB300 Driver rom wait states = 1C irqpoll timeout = 0400
[   10.213515] usbcore: registered new interface driver vub300
[   10.216369] sdhci-pltfm: SDHCI platform and OF driver helper
[   10.219940] ledtrig-cpu: registered to indicate activity on CPUs
[   10.233741] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   10.239128] usbcore: registered new interface driver usbhid
[   10.241789] usbhid: USB HID core driver
[   10.243974] usbcore: registered new interface driver w35und
[   10.254071] usbcore: registered new interface driver asus-oled
[   10.256906] usbcore: registered new interface driver tranzport
[   10.265175] usbcore: registered new interface driver alphatrack
[   10.274940] usbcore: registered new interface driver cedusb
[   10.283013] oprofile: using NMI interrupt.
[   10.285016] NET: Registered protocol family 26
[   10.287565] NET: Registered protocol family 17
[   10.289288] g_ether gadget: resume
[   10.292698] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
[   10.297330] NET: Registered protocol family 15
[   10.305509] Ebtables v2.0 registered
[   10.312381] NET: Registered protocol family 4
[   10.315934] NET: Registered protocol family 5
[   10.322286] NET: Registered protocol family 9
[   10.325036] X.25 for Linux Version 0.2
[   10.335003] NET: Registered protocol family 6
[   10.348978] NET: Registered protocol family 11
[   10.352042] NET: Registered protocol family 3
[   10.358728] can: controller area network core (rev 20120528 abi 9)
[   10.366280] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
[   10.373775] NET: Registered protocol family 29
[   10.375945] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[   10.384998] DECnet: Routing cache hash table of 256 buckets, 16Kbytes
[   10.388426] NET: Registered protocol family 12
[   10.396232] 8021q: 802.1Q VLAN Support v1.8
[   10.402598] lib80211: common routines for IEEE802.11 drivers
[   10.405298] lib80211_crypt: registered algorithm 'NULL'
[   10.412145] lib80211_crypt: registered algorithm 'WEP'
[   10.414514] lib80211_crypt: registered algorithm 'CCMP'
[   10.422498] lib80211_crypt: registered algorithm 'TKIP'
[   10.425818] NET: Registered protocol family 37
[   10.430415] Key type dns_resolver registered
[   10.432733] usb 1-1: new high-speed USB device number 2 using dummy_hcd
[   10.444710] batman_adv: B.A.T.M.A.N. advanced 2013.3.0 (compatibility version 14) loaded
[   10.448642] openvswitch: Open vSwitch switching datapath
[   10.464754] 
[   10.464754] printing PIC contents
[   10.467081] ... PIC  IMR: ffff
[   10.473553] ... PIC  IRR: 1013
[   10.475433] ... PIC  ISR: 0000
[   10.476795] ... PIC ELCR: 0c00
[   10.482655] printing local APIC contents on CPU#0/0:
[   10.485933] ... APIC ID:      00000000 (0)
[   10.487891] ... APIC VERSION: 00050014
[   10.489910] ... APIC TASKPRI: 00000000 (00)
[   10.492472] ... APIC PROCPRI: 00000000
[   10.492623] ... APIC LDR: 01000000
[   10.492623] ... APIC DFR: ffffffff
[   10.492623] ... APIC SPIV: 000001ff
[   10.492623] ... APIC ISR field:
[   10.492623] 0000000000000000000000000000000000000000000000000000000000000000
[   10.492623] ... APIC TMR field:
[   10.492623] 0000000000000000000000000000000000000000000000000000000000000000
[   10.492623] ... APIC IRR field:
[   10.492623] 0000000000000000000000000000000000000000000000000000000000008000
[   10.492623] ... APIC ESR: 00000000
[   10.492623] ... APIC ICR: 00000831
[   10.492623] ... APIC ICR2: 01000000
[   10.492623] ... APIC LVTT: 000000ef
[   10.492623] ... APIC LVTPC: 00010000
[   10.492623] ... APIC LVT0: 00010700
[   10.492623] ... APIC LVT1: 00000400
[   10.492623] ... APIC LVTERR: 000000fe
[   10.492623] ... APIC TMICT: 00070795
[   10.492623] ... APIC TMCCT: 00000000
[   10.492623] ... APIC TDCR: 00000003
[   10.492623] 
[   10.623832] number of MP IRQ sources: 15.
[   10.625712] number of IO-APIC #2 registers: 24.
[   10.637319] testing the IO APIC.......................
[   10.645623] IO APIC #2......
[   10.647014] .... register #00: 00000000
[   10.653922] .......    : physical APIC id: 00
[   10.662533] .......    : Delivery Type: 0
[   10.671759] .......    : LTS          : 0
[   10.672972] .... register #01: 00170011
[   10.674084] .......     : max redirection entries: 17
[   10.684644] .......     : PRQ implemented: 0
[   10.685920] .......     : IO APIC version: 11
[   10.687159] .... register #02: 00000000
[   10.702488] .......     : arbitration: 00
[   10.703488] .... IRQ redirection table:
[   10.704388] 1    0    0   0   0    0    0    00
[   10.712564] 0    0    0   0   0    1    1    31
[   10.713641] 0    0    0   0   0    1    1    30
[   10.714700] 0    0    0   0   0    1    1    33
[   10.715864] 1    0    0   0   0    1    1    34
[   10.727343] 1    1    0   0   0    1    1    35
[   10.732743] 0    0    0   0   0    1    1    36
[   10.734075] 0    0    0   0   0    1    1    37
[   10.743564] 0    0    0   0   0    1    1    38
[   10.744903] 0    1    0   0   0    1    1    39
[   10.746251] 1    1    0   0   0    1    1    3A
[   10.754299] 1    1    0   0   0    1    1    3B
[   10.756455] 0    0    0   0   0    1    1    3C
[   10.765972] 0    0    0   0   0    1    1    3D
[   10.768394] 0    0    0   0   0    1    1    3E
[   10.778643] 0    0    0   0   0    1    1    3F
[   10.782061] 1    0    0   0   0    0    0    00
[   10.784754] 1    0    0   0   0    0    0    00
[   10.786989] 1    0    0   0   0    0    0    00
[   10.793424] 1    0    0   0   0    0    0    00
[   10.796650] 1    0    0   0   0    0    0    00
[   10.803212] 1    0    0   0   0    0    0    00
[   10.805389] 1    0    0   0   0    0    0    00
[   10.812575] 1    0    0   0   0    0    0    00
[   10.814825] IRQ to pin mappings:
[   10.816371] IRQ0 -> 0:2
[   10.822684] IRQ1 -> 0:1
[   10.823999] IRQ3 -> 0:3
[   10.825223] IRQ4 -> 0:4
[   10.826628] IRQ5 -> 0:5
[   10.827907] IRQ6 -> 0:6
[   10.829197] IRQ7 -> 0:7
[   10.830586] IRQ8 -> 0:8
[   10.831856] IRQ9 -> 0:9
[   10.833132] IRQ10 -> 0:10
[   10.835244] IRQ11 -> 0:11
[   10.842906] IRQ12 -> 0:12
[   10.844253] IRQ13 -> 0:13
[   10.846587] IRQ14 -> 0:14
[   10.852254] IRQ15 -> 0:15
[   10.853664] .................................... done.
[   10.856770] registered taskstats version 1
[   10.859184] Running tests on trace events:
[   10.861667] Testing event kvm_async_pf_completed: OK
[   10.880760] Testing event kvm_async_pf_ready: OK
[   10.900543] Testing event kvm_async_pf_not_present: OK
[   10.921185] Testing event kvm_async_pf_doublefault: [   10.964575] g_ether gadget: resume
[   10.966279] dummy_hcd dummy_hcd.0: port status 0x00100503 has changes
OK
[   10.970808] Testing event kvm_try_async_get_page: OK
[   11.003567] Testing event kvm_age_page: OK
[   11.020841] Testing event kvm_fpu: [   11.030062] dummy_udc dummy_udc.0: set_address = 2
OK
[   11.040595] Testing event kvm_mmio: [   11.063862] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
OK
[   11.069657] Testing event kvm_ack_irq: OK
[   11.112648] Testing event kvm_msi_set_irq: OK
[   11.135705] Testing event kvm_ioapic_set_irq: OK
[   11.164571] Testing event kvm_set_irq: [   11.170112] usb 1-1: New USB device found, idVendor=0525, idProduct=a4a2
[   11.181408] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   11.192241] usb 1-1: Product: RNDIS/Ethernet Gadget
[   11.197391] usb 1-1: Manufacturer: Linux 3.10.0-rc4-next-20130606 with dummy_udc
OK
[   11.206391] Testing event kvm_userspace_exit: [   11.217606] g_ether gadget: high-speed config #1: CDC Ethernet (EEM)
[   11.220777] g_ether gadget: init eem
[   11.225134] g_ether gadget: activate eem
[   11.227553] dummy_udc dummy_udc.0: enabled ep1in-bulk (ep1in-bulk) maxpacket 512 stream disabled
[   11.227553] dummy_udc dummy_udc.0: enabled ep2out-bulk (ep2out-bulk) maxpacket 512 stream disabled
[   11.227553] usb0: qlen 10
[   11.260064] g_ether gadget: reset eem
[   11.261784] usb0: gether_disconnect
[   11.263254] dummy_udc dummy_udc.0: disabled ep1in-bulk
[   11.265395] dummy_udc dummy_udc.0: disabled ep2out-bulk
[   11.270025] g_ether gadget: init eem
[   11.270025] g_ether gadget: activate eem
[   11.270025] dummy_udc dummy_udc.0: enabled ep1in-bulk (ep1in-bulk) maxpacket 512 stream disabled
[   11.270025] dummy_udc dummy_udc.0: enabled ep2out-bulk (ep2out-bulk) maxpacket 512 stream disabled
[   11.270025] usb0: qlen 10
[   11.295435] cdc_eem 1-1:1.0 usb1: register 'cdc_eem' at usb-dummy_hcd.0-1, CDC EEM Device, f6:58:50:5d:9c:f8
OK
[   11.305172] Testing event kvm_track_tsc: OK
[   11.348632] Testing event kvm_update_master_clock: OK
[   11.370545] Testing event vcpu_match_mmio: OK
[   11.404048] Testing event kvm_emulate_insn: OK
[   11.421481] Testing event kvm_skinit: OK
[   11.440899] Testing event kvm_invlpga: OK
[   11.509933] Testing event kvm_nested_intr_vmexit: OK
[   11.535619] Testing event kvm_nested_vmexit_inject: OK
[   11.560248] Testing event kvm_nested_vmexit: OK
[   11.580545] Testing event kvm_nested_intercepts: OK
[   11.642973] Testing event kvm_nested_vmrun: OK
[   11.668858] Testing event kvm_pv_eoi: OK
[   11.710977] Testing event kvm_eoi: OK
[   11.738933] Testing event kvm_apic_accept_irq: OK
[   11.760809] Testing event kvm_apic_ipi: OK
[   11.791384] Testing event kvm_pic_set_irq: OK
[   11.812437] Testing event kvm_cr: OK
[   11.830841] Testing event kvm_msr: OK
[   11.886266] Testing event kvm_page_fault: OK
[   11.901569] Testing event kvm_inj_exception: OK
[   11.930229] Testing event kvm_inj_virq: OK
[   11.951120] Testing event kvm_exit: OK
[   11.971796] Testing event kvm_apic: OK
[   11.990540] Testing event kvm_cpuid: OK
[   12.018082] Testing event kvm_pio: OK
[   12.070319] Testing event kvm_hv_hypercall: OK
[   12.090985] Testing event kvm_hypercall: OK
[   12.110555] Testing event kvm_entry: OK
[   12.138748] Testing event fast_page_fault: OK
[   12.208128] Testing event handle_mmio_page_fault: OK
[   12.230522] Testing event mark_mmio_spte: OK
[   12.252527] Testing event kvm_mmu_prepare_zap_page: OK
[   12.294167] Testing event kvm_mmu_unsync_page: OK
[   12.310535] Testing event kvm_mmu_sync_page: OK
[   12.336068] Testing event kvm_mmu_get_page: OK
[   12.350533] Testing event kvm_mmu_walker_error: OK
[   12.370585] Testing event kvm_mmu_set_dirty_bit: OK
[   12.390614] Testing event kvm_mmu_set_accessed_bit: OK
[   12.449893] Testing event kvm_mmu_paging_element: OK
[   12.471073] Testing event kvm_mmu_pagetable_walk: OK
[   12.490629] Testing event emulate_vsyscall: OK
[   12.549833] Testing event sys_exit: OK
[   12.570665] Testing event sys_enter: OK
[   12.610529] Testing event task_rename: OK
[   12.643980] Testing event task_newtask: OK
[   12.661393] Testing event console: OK
[   12.680462] Testing event softirq_raise: OK
[   12.700478] Testing event softirq_exit: OK
[   12.721765] Testing event softirq_entry: OK
[   12.778211] Testing event irq_handler_exit: OK
[   12.800956] Testing event irq_handler_entry: OK
[   12.847706] Testing event tick_stop: OK
[   12.938754] Testing event itimer_expire: OK
[   12.961740] Testing event itimer_state: OK
[   12.980539] Testing event hrtimer_cancel: OK
[   13.000529] Testing event hrtimer_expire_exit: OK
[   13.030842] Testing event hrtimer_expire_entry: OK
[   13.050630] Testing event hrtimer_start: OK
[   13.089611] Testing event hrtimer_init: OK
[   13.110747] Testing event timer_cancel: OK
[   13.191654] Testing event timer_expire_exit: OK
[   13.215571] Testing event timer_expire_entry: OK
[   13.230553] Testing event timer_start: OK
[   13.253288] Testing event timer_init: OK
[   13.282782] Testing event signal_deliver: OK
[   13.300581] Testing event signal_generate: OK
[   13.362704] Testing event workqueue_execute_end: OK
[   13.401117] Testing event workqueue_execute_start: OK
[   13.483106] Testing event workqueue_activate_work: OK
[   13.503406] Testing event workqueue_queue_work: OK
[   13.541867] Testing event rcu_utilization: OK
[   13.560566] Testing event sched_pi_setprio: OK
[   13.603258] Testing event sched_stat_runtime: OK
[   13.620570] Testing event sched_stat_blocked: OK
[   13.686161] Testing event sched_stat_iowait: OK
[   13.725565] Testing event sched_stat_sleep: OK
[   13.740540] Testing event sched_stat_wait: OK
[   13.810431] Testing event sched_process_exec: OK
[   13.850468] Testing event sched_process_fork: OK
[   13.872150] Testing event sched_process_wait: OK
[   13.897201] Testing event sched_wait_task: OK
[   13.910550] Testing event sched_process_exit: OK
[   13.943002] Testing event sched_process_free: OK
[   13.961027] Testing event sched_migrate_task: OK
[   13.983046] Testing event sched_switch: OK
[   14.040538] Testing event sched_wakeup_new: OK
[   14.062664] Testing event sched_wakeup: OK
[   14.121448] Testing event sched_kthread_stop_ret: OK
[   14.151301] Testing event sched_kthread_stop: OK
[   14.212003] Testing event lock_release: OK
[   14.290519] Testing event lock_acquire: OK
[   14.361667] Testing event ftrace_test_filter: OK
[   14.394945] Testing event power_domain_target: OK
[   14.432330] Testing event clock_set_rate: OK
[   14.495683] Testing event clock_disable: OK
[   14.541862] Testing event clock_enable: OK
[   14.585651] Testing event wakeup_source_deactivate: OK
[   14.606305] Testing event wakeup_source_activate: OK
[   14.649694] Testing event machine_suspend: OK
[   14.703249] Testing event cpu_frequency: OK
[   14.746398] Testing event cpu_idle: OK
[   14.795532] Testing event mm_filemap_add_to_page_cache: OK
[   14.867172] Testing event mm_filemap_delete_from_page_cache: OK
[   14.912067] Testing event oom_score_adj_update: OK
[   14.936552] Testing event mm_lru_activate: OK
[   14.981921] Testing event mm_lru_insertion: OK
[   15.004660] Testing event mm_vmscan_lru_shrink_inactive: OK
[   15.043011] Testing event mm_vmscan_writepage: OK
[   15.084405] Testing event mm_vmscan_memcg_isolate: OK
[   15.127168] Testing event mm_vmscan_lru_isolate: OK
[   15.175895] Testing event mm_shrink_slab_end: OK
[   15.196949] Testing event mm_shrink_slab_start: OK
[   15.214988] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[   15.243790] Testing event mm_vmscan_memcg_reclaim_end: OK
[   15.316256] Testing event mm_vmscan_direct_reclaim_end: OK
[   15.353635] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[   15.381419] Testing event mm_vmscan_memcg_reclaim_begin: OK
[   15.415676] Testing event mm_vmscan_direct_reclaim_begin: OK
[   15.471976] Testing event mm_vmscan_wakeup_kswapd: OK
[   15.498650] Testing event mm_vmscan_kswapd_wake: OK
[   15.523948] Testing event mm_vmscan_kswapd_sleep: OK
[   15.547788] Testing event mm_page_alloc_extfrag: OK
[   15.571533] Testing event mm_page_pcpu_drain: OK
[   15.595000] Testing event mm_page_alloc_zone_locked: OK
[   15.610582] Testing event mm_page_alloc: OK
[   15.693567] Testing event mm_page_free_batched: OK
[   15.731664] Testing event mm_page_free: OK
[   15.769297] Testing event kmem_cache_free: OK
[   15.830465] Testing event kfree: OK
[   15.864676] Testing event kmem_cache_alloc_node: OK
[   15.888862] Testing event kmalloc_node: OK
[   15.926674] Testing event kmem_cache_alloc: OK
[   15.972363] Testing event kmalloc: OK
[   15.999059] Testing event mm_compaction_migratepages: OK
[   16.038092] Testing event mm_compaction_isolate_freepages: OK
[   16.079131] Testing event mm_compaction_isolate_migratepages: OK
[   16.109749] Testing event mm_migrate_pages: OK
[   16.152933] Testing event writeback_single_inode: OK
[   16.189870] Testing event writeback_single_inode_start: OK
[   16.226710] Testing event writeback_wait_iff_congested: OK
[   16.268485] Testing event writeback_congestion_wait: OK
[   16.310504] Testing event writeback_sb_inodes_requeue: OK
[   16.347792] Testing event balance_dirty_pages: OK
[   16.384725] Testing event bdi_dirty_ratelimit: OK
[   16.443852] Testing event global_dirty_state: OK
[   16.476464] Testing event writeback_queue_io: OK
[   16.580200] Testing event wbc_writepage: OK
[   16.600556] Testing event writeback_bdi_unregister: OK
[   16.636165] Testing event writeback_bdi_register: OK
[   16.752210] Testing event writeback_wake_background: OK
[   16.784797] Testing event writeback_nowork: OK
[   16.822567] Testing event writeback_pages_written: OK
[   16.850472] Testing event writeback_wait: OK
[   16.877010] Testing event writeback_written: OK
[   16.937043] Testing event writeback_start: OK
[   16.985788] Testing event writeback_exec: OK
[   17.017394] Testing event writeback_queue: OK
[   17.067946] Testing event writeback_write_inode: OK
[   17.107741] Testing event writeback_write_inode_start: OK
[   17.148817] Testing event writeback_dirty_inode: OK
[   17.188707] Testing event writeback_dirty_inode_start: OK
[   17.216716] Testing event writeback_dirty_page: OK
[   17.244031] Testing event gpio_value: OK
[   17.282906] Testing event gpio_direction: OK
[   17.319359] Testing event regulator_set_voltage_complete: OK
[   17.352973] Testing event regulator_set_voltage: OK
[   17.379606] Testing event regulator_disable_complete: OK
[   17.432488] Testing event regulator_disable: OK
[   17.456945] Testing event regulator_enable_complete: OK
[   17.496930] Testing event regulator_enable_delay: OK
[   17.563512] Testing event regulator_enable: OK
[   17.606352] Testing event extract_entropy_user: OK
[   17.632016] Testing event extract_entropy: OK
[   17.725907] Testing event get_random_bytes: OK
[   17.762549] Testing event credit_entropy_bits: OK
[   17.793103] Testing event mix_pool_bytes_nolock: OK
[   17.825129] Testing event mix_pool_bytes: OK
[   17.848039] Testing event drm_vblank_event_delivered: OK
[   17.906995] Testing event drm_vblank_event_queued: OK
[   17.922014] Testing event drm_vblank_event: OK
[   17.945550] Testing event regcache_drop_region: OK
[   18.019092] Testing event regmap_async_complete_done: OK
[   18.042014] Testing event regmap_async_complete_start: OK
[   18.060957] Testing event regmap_async_io_complete: OK
[   18.084000] Testing event regmap_async_write_start: OK
[   18.102075] Testing event regmap_cache_bypass: OK
[   18.122711] Testing event regmap_cache_only: OK
[   18.146853] Testing event regcache_sync: OK
[   18.166752] Testing event regmap_hw_write_done: OK
[   18.182557] Testing event regmap_hw_write_start: OK
[   18.207735] Testing event regmap_hw_read_done: OK
[   18.231668] Testing event regmap_hw_read_start: OK
[   18.261663] Testing event regmap_reg_read_cache: OK
[   18.285899] Testing event regmap_reg_read: OK
[   18.310555] Testing event regmap_reg_write: OK
[   18.336087] Testing event sync_pt: OK
[   18.371907] Testing event sync_wait: OK
[   18.390879] Testing event sync_timeline: OK
[   18.413366] Testing event udp_fail_queue_rcv_skb: OK
[   18.432666] Testing event sock_exceed_buf_limit: OK
[   18.453890] Testing event sock_rcvqueue_full: OK
[   18.472070] Testing event napi_poll: OK
[   18.492010] Testing event netif_rx: OK
[   18.511150] Testing event netif_receive_skb: OK
[   18.534086] Testing event net_dev_queue: OK
[   18.551358] Testing event net_dev_xmit: OK
[   18.573085] Testing event skb_copy_datagram_iovec: OK
[   18.591126] Testing event consume_skb: OK
[   18.617812] Testing event kfree_skb: OK
[   18.636184] Testing event cfg80211_ft_event: OK
[   18.652732] Testing event cfg80211_report_wowlan_wakeup: OK
[   18.673212] Testing event cfg80211_return_u32: OK
[   18.694943] Testing event cfg80211_return_uint: OK
[   18.712859] Testing event cfg80211_return_bss: OK
[   18.732187] Testing event cfg80211_inform_bss_frame: OK
[   18.752212] Testing event cfg80211_get_bss: OK
[   18.773233] Testing event cfg80211_sched_scan_stopped: OK
[   18.791487] Testing event cfg80211_sched_scan_results: OK
[   18.811893] Testing event cfg80211_scan_done: OK
[   18.834305] Testing event cfg80211_tdls_oper_request: OK
[   18.850615] Testing event cfg80211_report_obss_beacon: OK
[   18.881942] Testing event cfg80211_pmksa_candidate_notify: OK
[   18.902289] Testing event cfg80211_gtk_rekey_notify: OK
[   18.921142] Testing event cfg80211_cqm_pktloss_notify: OK
[   18.941279] Testing event cfg80211_probe_status: OK
[   18.963575] Testing event cfg80211_rx_unexpected_4addr_frame: OK
[   18.981353] Testing event cfg80211_rx_spurious_frame: OK
[   19.004701] Testing event cfg80211_ibss_joined: OK
[   19.022104] Testing event cfg80211_cac_event: OK
[   19.046519] Testing event cfg80211_radar_event: OK
[   19.068098] Testing event cfg80211_ch_switch_notify: OK
[   19.092765] Testing event cfg80211_chandef_dfs_required: OK
[   19.116377] Testing event cfg80211_reg_can_beacon: OK
[   19.147675] Testing event cfg80211_cqm_rssi_notify: OK
[   19.171764] Testing event cfg80211_mgmt_tx_status: OK
[   19.190943] Testing event cfg80211_rx_mgmt: OK
[   19.211622] Testing event cfg80211_del_sta: OK
[   19.235702] Testing event cfg80211_new_sta: OK
[   19.251974] Testing event cfg80211_ready_on_channel_expired: OK
[   19.370247] Testing event cfg80211_ready_on_channel: OK
[   19.394708] Testing event cfg80211_michael_mic_failure: OK
[   19.425582] Testing event cfg80211_send_assoc_timeout: OK
[   19.441592] Testing event cfg80211_send_auth_timeout: OK
[   19.461009] Testing event cfg80211_send_unprot_disassoc: OK
[   19.573896] Testing event cfg80211_send_unprot_deauth: OK
[   19.597690] Testing event cfg80211_send_disassoc: OK
[   19.620639] Testing event cfg80211_send_deauth: OK
[   19.641771] Testing event cfg80211_send_rx_assoc: OK
[   19.668071] Testing event cfg80211_send_rx_auth: OK
[   19.690870] Testing event cfg80211_notify_new_peer_candidate: OK
[   19.721304] Testing event cfg80211_return_bool: OK
[   19.742135] Testing event rdev_crit_proto_stop: OK
[   19.760580] Testing event rdev_crit_proto_start: OK
[   19.781350] Testing event rdev_update_ft_ies: OK
[   19.803071] Testing event rdev_set_mac_acl: OK
[   19.827320] Testing event rdev_stop_p2p_device: OK
[   19.841221] Testing event rdev_start_p2p_device: OK
[   19.860828] Testing event rdev_return_chandef: OK
[   19.881730] Testing event rdev_get_channel: OK
[   19.911221] Testing event rdev_get_et_strings: OK
[   19.933948] Testing event rdev_get_et_sset_count: OK
[   19.955841] Testing event rdev_set_noack_map: OK
[   19.971906] Testing event rdev_mgmt_tx: OK
[   19.992311] Testing event rdev_cancel_remain_on_channel: OK
[   20.013280] Testing event rdev_return_int_cookie: OK
[   20.031211] Testing event rdev_remain_on_channel: OK
[   20.051533] Testing event rdev_del_pmksa: OK
[   20.070967] Testing event rdev_set_pmksa: OK
[   20.092776] Testing event rdev_probe_client: OK
[   20.110877] Testing event rdev_tdls_oper: OK
[   20.133497] Testing event rdev_return_int_survey_info: OK
[   20.151376] Testing event rdev_dump_survey: OK
[   20.171575] Testing event rdev_tdls_mgmt: OK
[   20.191916] Testing event rdev_sched_scan_start: OK
[   20.212666] Testing event rdev_set_antenna: OK
[   20.231553] Testing event rdev_set_ringparam: OK
[   20.251202] Testing event rdev_return_void_tx_rx: OK
[   20.270546] Testing event rdev_return_int_tx_rx: OK
[   20.292447] Testing event rdev_mgmt_frame_register: OK
[   20.311715] Testing event rdev_set_bitrate_mask: OK
[   20.338546] Testing event rdev_testmode_dump: OK
[   20.365961] Testing event rdev_testmode_cmd: OK
[   20.381825] Testing event rdev_return_int_int: OK
[   20.400809] Testing event rdev_set_tx_power: OK
[   20.421460] Testing event rdev_get_tx_power: OK
[   20.443258] Testing event rdev_set_wiphy_params: OK
[   20.461624] Testing event rdev_join_ibss: OK
[   20.482266] Testing event rdev_disconnect: OK
[   20.503065] Testing event rdev_set_cqm_txe_config: OK
[   20.525942] Testing event rdev_set_cqm_rssi_config: OK
[   20.540749] Testing event rdev_connect: OK
[   20.561403] Testing event rdev_set_power_mgmt: OK
[   20.581663] Testing event rdev_mgmt_tx_cancel_wait: OK
[   20.601535] Testing event rdev_disassoc: OK
[   20.621803] Testing event rdev_deauth: OK
[   20.643271] Testing event rdev_assoc: OK
[   20.660958] Testing event rdev_auth: OK
[   20.689089] Testing event rdev_set_monitor_channel: OK
[   20.723605] Testing event rdev_libertas_set_mesh_channel: OK
[   20.752436] Testing event rdev_set_txq_params: OK
[   20.774196] Testing event rdev_change_bss: OK
[   20.792614] Testing event rdev_join_mesh: OK
[   20.812628] Testing event rdev_update_mesh_config: OK
[   20.832098] Testing event rdev_return_int_mesh_config: OK
[   20.851818] Testing event rdev_return_int_mpath_info: OK
[   20.872689] Testing event rdev_dump_mpath: OK
[   20.891962] Testing event rdev_get_mpath: OK
[   20.915702] Testing event rdev_change_mpath: OK
[   20.931840] Testing event rdev_add_mpath: OK
[   20.951659] Testing event rdev_return_int_station_info: OK
[   20.971600] Testing event rdev_dump_station: OK
[   20.991522] Testing event rdev_set_wds_peer: OK
[   21.014629] Testing event rdev_del_mpath: OK
[   21.030637] Testing event rdev_get_station: OK
[   21.051102] Testing event rdev_del_station: OK
[   21.071586] Testing event rdev_change_station: OK
[   21.090831] Testing event rdev_add_station: OK
[   21.111248] Testing event rdev_flush_pmksa: OK
[   21.130707] Testing event rdev_leave_ibss: OK
[   21.151354] Testing event rdev_leave_mesh: OK
[   21.172513] Testing event rdev_get_mesh_config: OK
[   21.190994] Testing event rdev_set_rekey_data: OK
[   21.211458] Testing event rdev_sched_scan_stop: OK
[   21.231249] Testing event rdev_get_et_stats: OK
[   21.253420] Testing event rdev_stop_ap: OK
[   21.271623] Testing event rdev_change_beacon: OK
[   21.292298] Testing event rdev_start_ap: OK
[   21.310817] Testing event rdev_set_default_mgmt_key: OK
[   21.331834] Testing event rdev_set_default_key: OK
[   21.354782] Testing event rdev_del_key: OK
[   21.373498] Testing event rdev_get_key: OK
[   21.391709] Testing event rdev_add_key: OK
[   21.412893] Testing event rdev_change_virtual_intf: OK
[   21.431059] Testing event rdev_del_virtual_intf: OK
[   21.452302] Testing event rdev_return_wdev: OK
[   21.471528] Testing event rdev_add_virtual_intf: OK
[   21.490865] Testing event rdev_set_wakeup: OK
[   21.511570] Testing event rdev_rfkill_poll: OK
[   21.532393] Testing event rdev_get_antenna: OK
[   21.550702] Testing event rdev_get_ringparam: OK
[   21.571282] Testing event rdev_return_void: OK
[   21.591309] Testing event rdev_resume: OK
[   21.611212] Testing event rdev_scan: OK
[   21.637933] Testing event rdev_return_int: OK
[   21.665953] Testing event rdev_suspend: OK
[   21.683678] Testing event mac80211_err: OK
[   21.707121] Testing event mac80211_dbg: OK
[   21.725179] Testing event mac80211_info: OK
[   21.754253] Testing event api_radar_detected: OK
[   21.770947] Testing event drv_set_default_unicast_key: OK
[   21.795536] Testing event stop_queue: OK
[   21.812601] Testing event wake_queue: OK
[   21.832297] Testing event api_eosp: OK
[   21.851689] Testing event api_enable_rssi_reports: OK
[   21.870975] Testing event api_gtk_rekey_notify: OK
[   21.890645] Testing event api_remain_on_channel_expired: OK
[   21.911266] Testing event api_ready_on_channel: OK
[   21.931207] Testing event api_chswitch_done: OK
[   22.010412] Testing event api_sta_block_awake: OK
[   22.030999] Testing event api_sched_scan_stopped: OK
[   22.058852] Testing event api_sched_scan_results: OK
[   22.083867] Testing event api_scan_completed: OK
[   22.117866] Testing event api_cqm_rssi_notify: OK
[   22.142569] Testing event api_connection_loss: OK
[   22.168785] Testing event api_beacon_loss: OK
[   22.191153] Testing event api_restart_hw: OK
[   22.211479] Testing event api_stop_tx_ba_cb: OK
[   22.238718] Testing event api_stop_tx_ba_session: OK
[   22.261596] Testing event api_start_tx_ba_cb: OK
[   22.288541] Testing event api_start_tx_ba_session: OK
[   22.312277] Testing event drv_restart_complete: OK
[   22.331413] Testing event drv_stop_ap: OK
[   22.350767] Testing event drv_start_ap: OK
[   22.370637] Testing event drv_unassign_vif_chanctx: OK
[   22.392098] Testing event drv_assign_vif_chanctx: OK
[   22.410862] Testing event drv_change_chanctx: OK
[   22.431128] Testing event drv_remove_chanctx: OK
[   22.451285] Testing event drv_add_chanctx: OK
[   22.471946] Testing event drv_mgd_prepare_tx: OK
[   22.492496] Testing event drv_get_rssi: OK
[   22.511176] Testing event drv_allow_buffered_frames: OK
[   22.533016] Testing event drv_release_buffered_frames: OK
[   22.556930] Testing event drv_rssi_callback: OK
[   22.589039] Testing event drv_set_rekey_data: OK
[   22.615926] Testing event drv_set_bitrate_mask: OK
[   22.632558] Testing event drv_offchannel_tx_cancel_wait: OK
[   22.654703] Testing event drv_tx_frames_pending: OK
[   22.685362] Testing event drv_get_ringparam: OK
[   22.705377] Testing event drv_set_ringparam: OK
[   22.722023] Testing event drv_cancel_remain_on_channel: OK
[   22.743547] Testing event drv_remain_on_channel: OK
[   22.762720] Testing event drv_get_antenna: OK
[   22.783787] Testing event drv_set_antenna: OK
[   22.815813] Testing event drv_channel_switch: OK
[   22.832347] Testing event drv_flush: OK
[   22.854671] Testing event drv_get_survey: OK
[   22.872071] Testing event drv_ampdu_action: OK
[   22.890693] Testing event drv_tx_last_beacon: OK
[   22.911554] Testing event drv_reset_tsf: OK
[   23.018180] Testing event drv_set_tsf: OK
[   23.042008] Testing event drv_get_tsf: OK
[   23.063803] Testing event drv_conf_tx: OK
[   23.086179] Testing event drv_sta_remove: OK
[   23.100729] Testing event drv_sta_add: OK
[   23.121241] Testing event drv_sta_rc_update: OK
[   23.141778] Testing event drv_sta_state: OK
[   23.160672] Testing event drv_sta_notify: OK
[   23.180689] Testing event drv_set_coverage_class: OK
[   23.200671] Testing event drv_set_rts_threshold: OK
[   23.220811] Testing event drv_set_frag_threshold: OK
[   23.241313] Testing event drv_get_tkip_seq: OK
[   23.260713] Testing event drv_get_stats: OK
[   23.280648] Testing event drv_sw_scan_complete: OK
[   23.301169] Testing event drv_sw_scan_start: OK
[   23.320987] Testing event drv_sched_scan_stop: OK
[   23.340942] Testing event drv_sched_scan_start: OK
[   23.364821] Testing event drv_cancel_hw_scan: OK
[   23.380823] Testing event drv_hw_scan: OK
[   23.400741] Testing event drv_update_tkip_key: OK
[   23.420796] Testing event drv_set_key: OK
[   23.440616] Testing event drv_set_tim: OK
[   23.461730] Testing event drv_configure_filter: OK
[   23.480720] Testing event drv_set_multicast_list: OK
[   23.501255] Testing event drv_prepare_multicast: OK
[   23.523868] Testing event drv_bss_info_changed: OK
[   23.552864] Testing event drv_config: OK
[   23.571677] Testing event drv_remove_interface: OK
[   23.594093] Testing event drv_change_interface: OK
[   23.611715] Testing event drv_add_interface: OK
[   23.634276] Testing event drv_stop: OK
[   23.651018] Testing event drv_set_wakeup: OK
[   23.676719] Testing event drv_resume: OK
[   23.700636] Testing event drv_suspend: OK
[   23.720659] Testing event drv_get_et_stats: OK
[   23.740610] Testing event drv_get_et_sset_count: OK
[   23.760525] Testing event drv_get_et_strings: OK
[   23.780636] Testing event drv_start: OK
[   23.800628] Testing event drv_return_u64: OK
[   23.822749] Testing event drv_return_bool: OK
[   23.840487] Testing event drv_return_int: OK
[   23.860479] Testing event drv_return_void: OK
[   23.882336] Running tests on trace event systems:
[   23.883692] Testing event system mac80211: OK
[   23.916376] Testing event system mac80211_msg: OK
[   23.934933] Testing event system cfg80211: OK
[   23.971086] Testing event system skb: OK
[   23.991238] Testing event system net: OK
[   24.010759] Testing event system napi: OK
[   24.032111] Testing event system sock: OK
[   24.054128] Testing event system udp: OK
[   24.071900] Testing event system sync: OK
[   24.090631] Testing event system regmap: OK
[   24.111478] Testing event system drm: OK
[   24.130632] Testing event system random: OK
[   24.150808] Testing event system regulator: OK
[   24.170813] Testing event system gpio: OK
[   24.190591] Testing event system writeback: OK
[   24.212967] Testing event system migrate: OK
[   24.233292] Testing event system compaction: OK
[   24.252133] Testing event system kmem: OK
[   24.271187] Testing event system vmscan: OK
[   24.291829] Testing event system pagemap: OK
[   24.311114] Testing event system oom: OK
[   24.330797] Testing event system filemap: OK
[   24.350577] Testing event system power: OK
[   24.370866] Testing event system test: OK
[   24.393630] Testing event system lock: OK
[   24.410807] Testing event system sched: OK
[   24.431299] Testing event system rcu: OK
[   24.450579] Testing event system workqueue: OK
[   24.472155] Testing event system signal: OK
[   24.490619] Testing event system timer: OK
[   24.511043] Testing event system irq: OK
[   24.531054] Testing event system printk: OK
[   24.550598] Testing event system task: OK
[   24.570864] Testing event system raw_syscalls: OK
[   24.594214] Testing event system vsyscall: OK
[   24.610737] Testing event system syscalls: OK
[   24.633185] Testing event system kvmmmu: OK
[   24.652101] Testing event system kvm: OK
[   24.674153] Running tests on all trace events:
[   24.683949] Testing all events: OK
[   25.052088] Running tests again, along with the function tracer
[   25.055359] Running tests on trace events:
[   25.062562] Testing event kvm_async_pf_completed: OK
[   25.614206] Testing event kvm_async_pf_ready: OK
[   25.687224] Testing event kvm_async_pf_not_present: OK
[   25.728698] Testing event kvm_async_pf_doublefault: OK
[   25.754440] Testing event kvm_try_async_get_page: OK
[   25.783606] Testing event kvm_age_page: OK
[   25.822613] Testing event kvm_fpu: OK
[   25.884493] Testing event kvm_mmio: OK
[   25.941496] Testing event kvm_ack_irq: OK
[   25.988947] Testing event kvm_msi_set_irq: OK
[   26.024181] Testing event kvm_ioapic_set_irq: OK
[   26.067968] Testing event kvm_set_irq: OK
[   26.112242] Testing event kvm_userspace_exit: OK
[   26.156433] Testing event kvm_track_tsc: OK
[   26.183311] Testing event kvm_update_master_clock: OK
[   26.228774] Testing event vcpu_match_mmio: OK
[   26.264256] Testing event kvm_emulate_insn: OK
[   26.317341] Testing event kvm_skinit: OK
[   26.359511] Testing event kvm_invlpga: OK
[   26.393722] Testing event kvm_nested_intr_vmexit: OK
[   26.453911] Testing event kvm_nested_vmexit_inject: OK
[   26.483760] Testing event kvm_nested_vmexit: OK
[   26.548365] Testing event kvm_nested_intercepts: OK
[   26.594926] Testing event kvm_nested_vmrun: OK
[   26.641654] Testing event kvm_pv_eoi: OK
[   26.681267] Testing event kvm_eoi: OK
[   26.727264] Testing event kvm_apic_accept_irq: OK
[   26.762407] Testing event kvm_apic_ipi: OK
[   26.811038] Testing event kvm_pic_set_irq: OK
[   26.843035] Testing event kvm_cr: OK
[   26.879832] Testing event kvm_msr: OK
[   26.924948] Testing event kvm_page_fault: OK
[   26.965167] Testing event kvm_inj_exception: OK
[   26.995439] Testing event kvm_inj_virq: OK
[   27.044938] Testing event kvm_exit: OK
[   27.091921] Testing event kvm_apic: OK
[   27.124905] Testing event kvm_cpuid: OK
[   27.163914] Testing event kvm_pio: OK
[   27.205020] Testing event kvm_hv_hypercall: OK
[   27.244033] Testing event kvm_hypercall: OK
[   27.295024] Testing event kvm_entry: OK
[   27.334952] Testing event fast_page_fault: OK
[   27.368079] Testing event handle_mmio_page_fault: OK
[   27.408598] Testing event mark_mmio_spte: OK
[   27.457821] Testing event kvm_mmu_prepare_zap_page: OK
[   27.485155] Testing event kvm_mmu_unsync_page: OK
[   27.557260] Testing event kvm_mmu_sync_page: OK
[   27.593904] Testing event kvm_mmu_get_page: OK
[   27.633357] Testing event kvm_mmu_walker_error: OK
[   27.686166] Testing event kvm_mmu_set_dirty_bit: OK
[   27.714688] Testing event kvm_mmu_set_accessed_bit: OK
[   27.754036] Testing event kvm_mmu_paging_element: OK
[   27.806540] Testing event kvm_mmu_pagetable_walk: OK
[   27.843683] Testing event emulate_vsyscall: OK
[   27.883921] Testing event sys_exit: OK
[   27.925067] Testing event sys_enter: OK
[   27.963549] Testing event task_rename: OK
[   28.012869] Testing event task_newtask: OK
[   28.079602] Testing event console: OK
[   28.143179] Testing event softirq_raise: OK
[   28.186750] Testing event softirq_exit: OK
[   28.262801] Testing event softirq_entry: OK
[   28.330011] Testing event irq_handler_exit: OK
[   28.403491] Testing event irq_handler_entry: OK
[   28.463884] Testing event tick_stop: OK
[   28.502746] Testing event itimer_expire: OK
[   28.545228] Testing event itimer_state: OK
[   28.603646] Testing event hrtimer_cancel: OK
[   28.648083] Testing event hrtimer_expire_exit: OK
[   28.698457] Testing event hrtimer_expire_entry: OK
[   28.743403] Testing event hrtimer_start: OK
[   28.777455] Testing event hrtimer_init: OK
[   28.803249] Testing event timer_cancel: OK
[   28.845729] Testing event timer_expire_exit: OK
[   28.899166] Testing event timer_expire_entry: OK
[   28.934818] Testing event timer_start: OK
[   28.987483] Testing event timer_init: OK
[   29.052340] Testing event signal_deliver: OK
[   29.106871] Testing event signal_generate: OK
[   29.165769] Testing event workqueue_execute_end: OK
[   29.231611] Testing event workqueue_execute_start: OK
[   29.285817] Testing event workqueue_activate_work: OK
[   29.352073] Testing event workqueue_queue_work: OK
[   29.394209] Testing event rcu_utilization: OK
[   29.442945] Testing event sched_pi_setprio: OK
[   29.486975] Testing event sched_stat_runtime: OK
[   29.546009] Testing event sched_stat_blocked: OK
[   29.599202] Testing event sched_stat_iowait: OK
[   29.667491] Testing event sched_stat_sleep: OK
[   29.704357] Testing event sched_stat_wait: OK
[   29.754542] Testing event sched_process_exec: OK
[   29.796685] Testing event sched_process_fork: OK
[   29.872836] Testing event sched_process_wait: OK
[   29.928568] Testing event sched_wait_task: OK
[   29.985881] Testing event sched_process_exit: OK
[   30.023815] Testing event sched_process_free: OK
[   30.085476] Testing event sched_migrate_task: OK
[   30.125436] Testing event sched_switch: OK
[   30.175143] Testing event sched_wakeup_new: OK
[   30.223574] Testing event sched_wakeup: OK
[   30.261994] Testing event sched_kthread_stop_ret: OK
[   30.297319] Testing event sched_kthread_stop: OK
[   30.336760] Testing event lock_release: OK
[   30.376169] Testing event lock_acquire: OK
[   30.429143] Testing event ftrace_test_filter: OK
[   30.475718] Testing event power_domain_target: OK
[   30.519791] Testing event clock_set_rate: OK
[   30.563366] Testing event clock_disable: OK
[   30.603940] Testing event clock_enable: OK
[   30.677674] Testing event wakeup_source_deactivate: OK
[   30.716365] Testing event wakeup_source_activate: OK
[   30.765106] Testing event machine_suspend: OK
[   30.819613] Testing event cpu_frequency: OK
[   30.854730] Testing event cpu_idle: OK
[   30.917973] Testing event mm_filemap_add_to_page_cache: OK
[   30.962324] Testing event mm_filemap_delete_from_page_cache: OK
[   31.002864] Testing event oom_score_adj_update: OK
[   31.033205] Testing event mm_lru_activate: OK
[   31.101816] Testing event mm_lru_insertion: OK
[   31.153185] Testing event mm_vmscan_lru_shrink_inactive: OK
[   31.193245] Testing event mm_vmscan_writepage: OK
[   31.234013] Testing event mm_vmscan_memcg_isolate: OK
[   31.274024] Testing event mm_vmscan_lru_isolate: OK
[   31.302455] Testing event mm_shrink_slab_end: OK
[   31.335419] Testing event mm_shrink_slab_start: OK
[   31.374451] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[   31.402647] Testing event mm_vmscan_memcg_reclaim_end: OK
[   31.445262] Testing event mm_vmscan_direct_reclaim_end: OK
[   31.487122] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[   31.556971] Testing event mm_vmscan_memcg_reclaim_begin: OK
[   31.593640] Testing event mm_vmscan_direct_reclaim_begin: OK
[   31.624637] Testing event mm_vmscan_wakeup_kswapd: OK
[   31.673160] Testing event mm_vmscan_kswapd_wake: OK
[   31.713893] Testing event mm_vmscan_kswapd_sleep: OK
[   31.745469] Testing event mm_page_alloc_extfrag: OK
[   31.789515] Testing event mm_page_pcpu_drain: OK
[   31.824290] Testing event mm_page_alloc_zone_locked: OK
[   31.857729] Testing event mm_page_alloc: OK
[   31.888112] Testing event mm_page_free_batched: OK
[   31.925944] Testing event mm_page_free: OK
[   31.975941] Testing event kmem_cache_free: OK
[   32.011995] Testing event kfree: OK
[   32.056294] Testing event kmem_cache_alloc_node: OK
[   32.094307] Testing event kmalloc_node: OK
[   32.127961] Testing event kmem_cache_alloc: OK
[   32.156963] Testing event kmalloc: OK
[   32.185320] Testing event mm_compaction_migratepages: OK
[   32.224746] Testing event mm_compaction_isolate_freepages: OK
[   32.255716] Testing event mm_compaction_isolate_migratepages: OK
[   32.297347] Testing event mm_migrate_pages: OK
[   32.334609] Testing event writeback_single_inode: OK
[   32.364684] Testing event writeback_single_inode_start: OK
[   32.395337] Testing event writeback_wait_iff_congested: OK
[   32.434827] Testing event writeback_congestion_wait: OK
[   32.474641] Testing event writeback_sb_inodes_requeue: OK
[   32.527799] Testing event balance_dirty_pages: OK
[   32.581744] Testing event bdi_dirty_ratelimit: OK
[   32.632296] Testing event global_dirty_state: OK
[   32.698013] Testing event writeback_queue_io: OK
[   32.742394] Testing event wbc_writepage: OK
[   32.774695] Testing event writeback_bdi_unregister: OK
[   32.805864] Testing event writeback_bdi_register: OK
[   32.849562] Testing event writeback_wake_background: OK
[   32.897887] Testing event writeback_nowork: OK
[   32.969361] Testing event writeback_pages_written: OK
[   32.998036] Testing event writeback_wait: OK
[   33.034008] Testing event writeback_written: OK
[   33.074844] Testing event writeback_start: OK
[   33.116396] Testing event writeback_exec: OK
[   33.179828] Testing event writeback_queue: OK
[   33.221119] Testing event writeback_write_inode: OK
[   33.259738] Testing event writeback_write_inode_start: OK
[   33.297285] Testing event writeback_dirty_inode: OK
[   33.353144] Testing event writeback_dirty_inode_start: OK
[   33.392182] Testing event writeback_dirty_page: OK
[   33.424054] Testing event gpio_value: OK
[   33.467394] Testing event gpio_direction: OK
[   33.542701] Testing event regulator_set_voltage_complete: OK
[   33.592810] Testing event regulator_set_voltage: OK
[   33.632547] Testing event regulator_disable_complete: OK
[   33.698609] Testing event regulator_disable: OK
[   33.738140] Testing event regulator_enable_complete: OK
[   33.763834] Testing event regulator_enable_delay: OK
[   33.804370] Testing event regulator_enable: OK
[   33.853410] Testing event extract_entropy_user: OK
[   33.894424] Testing event extract_entropy: OK
[   33.924748] Testing event get_random_bytes: OK
[   33.956078] Testing event credit_entropy_bits: OK
[   33.999620] Testing event mix_pool_bytes_nolock: OK
[   34.036227] Testing event mix_pool_bytes: OK
[   34.064905] Testing event drm_vblank_event_delivered: OK
[   34.095964] Testing event drm_vblank_event_queued: OK
[   34.151001] Testing event drm_vblank_event: OK
[   34.192849] Testing event regcache_drop_region: OK
[   34.252462] Testing event regmap_async_complete_done: OK
[   34.290667] Testing event regmap_async_complete_start: OK
[   34.326292] Testing event regmap_async_io_complete: OK
[   34.359535] Testing event regmap_async_write_start: OK
[   34.385813] Testing event regmap_cache_bypass: OK
[   34.419517] Testing event regmap_cache_only: OK
[   34.454488] Testing event regcache_sync: OK
[   34.495118] Testing event regmap_hw_write_done: OK
[   34.525500] Testing event regmap_hw_write_start: OK
[   34.558818] Testing event regmap_hw_read_done: OK
[   34.586111] Testing event regmap_hw_read_start: OK
[   34.622763] Testing event regmap_reg_read_cache: OK
[   34.653736] Testing event regmap_reg_read: OK
[   34.695487] Testing event regmap_reg_write: OK
[   34.732641] Testing event sync_pt: OK
[   34.777796] Testing event sync_wait: OK
[   34.806107] Testing event sync_timeline: OK
[   34.838160] Testing event udp_fail_queue_rcv_skb: OK
[   34.865901] Testing event sock_exceed_buf_limit: OK
[   34.901769] Testing event sock_rcvqueue_full: OK
[   34.945000] Testing event napi_poll: OK
[   34.987219] Testing event netif_rx: OK
[   35.025743] Testing event netif_receive_skb: OK
[   35.055729] Testing event net_dev_queue: OK
[   35.095559] Testing event net_dev_xmit: OK
[   35.143092] Testing event skb_copy_datagram_iovec: OK
[   35.178801] Testing event consume_skb: OK
[   35.217936] Testing event kfree_skb: OK
[   35.259162] Testing event cfg80211_ft_event: OK
[   35.306429] Testing event cfg80211_report_wowlan_wakeup: OK
[   35.337513] Testing event cfg80211_return_u32: OK
[   35.367133] Testing event cfg80211_return_uint: OK
[   35.397424] Testing event cfg80211_return_bss: OK
[   35.426672] Testing event cfg80211_inform_bss_frame: OK
[   35.492637] Testing event cfg80211_get_bss: OK
[   35.543425] Testing event cfg80211_sched_scan_stopped: OK
[   35.575492] Testing event cfg80211_sched_scan_results: OK
[   35.621010] Testing event cfg80211_scan_done: OK
[   35.665945] Testing event cfg80211_tdls_oper_request: OK
[   35.699105] Testing event cfg80211_report_obss_beacon: OK
[   35.740418] Testing event cfg80211_pmksa_candidate_notify: OK
[   35.798032] Testing event cfg80211_gtk_rekey_notify: OK
[   35.842979] Testing event cfg80211_cqm_pktloss_notify: OK
[   35.875405] Testing event cfg80211_probe_status: OK
[   35.925749] Testing event cfg80211_rx_unexpected_4addr_frame: OK
[   35.966448] Testing event cfg80211_rx_spurious_frame: OK
[   35.993346] Testing event cfg80211_ibss_joined: OK
[   36.028202] Testing event cfg80211_cac_event: OK
[   36.063597] Testing event cfg80211_radar_event: OK
[   36.104421] Testing event cfg80211_ch_switch_notify: OK
[   36.144373] Testing event cfg80211_chandef_dfs_required: OK
[   36.186149] Testing event cfg80211_reg_can_beacon: OK
[   36.236318] Testing event cfg80211_cqm_rssi_notify: OK
[   36.282198] Testing event cfg80211_mgmt_tx_status: OK
[   36.322186] Testing event cfg80211_rx_mgmt: OK
[   36.355840] Testing event cfg80211_del_sta: OK
[   36.402893] Testing event cfg80211_new_sta: OK
[   36.438001] Testing event cfg80211_ready_on_channel_expired: OK
[   36.475848] Testing event cfg80211_ready_on_channel: OK
[   36.515816] Testing event cfg80211_michael_mic_failure: OK
[   36.555862] Testing event cfg80211_send_assoc_timeout: OK
[   36.602258] Testing event cfg80211_send_auth_timeout: OK
[   36.651144] Testing event cfg80211_send_unprot_disassoc: OK
[   36.695785] Testing event cfg80211_send_unprot_deauth: OK
[   36.738925] Testing event cfg80211_send_disassoc: OK
[   36.798869] Testing event cfg80211_send_deauth: OK
[   36.866042] Testing event cfg80211_send_rx_assoc: OK
[   36.908200] Testing event cfg80211_send_rx_auth: OK
[   36.957939] Testing event cfg80211_notify_new_peer_candidate: OK
[   37.017049] Testing event cfg80211_return_bool: OK
[   37.060435] Testing event rdev_crit_proto_stop: OK
[   37.104137] Testing event rdev_crit_proto_start: OK
[   37.157150] Testing event rdev_update_ft_ies: OK
[   37.214251] Testing event rdev_set_mac_acl: OK
[   37.246619] Testing event rdev_stop_p2p_device: OK
[   37.276823] Testing event rdev_start_p2p_device: OK
[   37.318133] Testing event rdev_return_chandef: OK
[   37.347486] Testing event rdev_get_channel: OK
[   37.384815] Testing event rdev_get_et_strings: OK
[   37.415789] Testing event rdev_get_et_sset_count: OK
[   37.449728] Testing event rdev_set_noack_map: OK
[   37.479574] Testing event rdev_mgmt_tx: OK
[   37.519085] Testing event rdev_cancel_remain_on_channel: OK
[   37.557267] Testing event rdev_return_int_cookie: OK
[   37.590920] Testing event rdev_remain_on_channel: OK
[   37.626967] Testing event rdev_del_pmksa: OK
[   37.658814] Testing event rdev_set_pmksa: OK
[   37.685861] Testing event rdev_probe_client: OK
[   37.726517] Testing event rdev_tdls_oper: OK
[   37.764950] Testing event rdev_return_int_survey_info: OK
[   37.799527] Testing event rdev_dump_survey: OK
[   37.838521] Testing event rdev_tdls_mgmt: OK
[   37.870000] Testing event rdev_sched_scan_start: OK
[   37.905164] Testing event rdev_set_antenna: OK
[   37.952818] Testing event rdev_set_ringparam: OK
[   37.989048] Testing event rdev_return_void_tx_rx: OK
[   38.024992] Testing event rdev_return_int_tx_rx: OK
[   38.064256] Testing event rdev_mgmt_frame_register: OK
[   38.106827] Testing event rdev_set_bitrate_mask: OK
[   38.163279] Testing event rdev_testmode_dump: OK
[   38.197145] Testing event rdev_testmode_cmd: OK
[   38.224561] Testing event rdev_return_int_int: OK
[   38.256976] Testing event rdev_set_tx_power: OK
[   38.284456] Testing event rdev_get_tx_power: OK
[   38.314922] Testing event rdev_set_wiphy_params: OK
[   38.354824] Testing event rdev_join_ibss: OK
[   38.385287] Testing event rdev_disconnect: OK
[   38.423934] Testing event rdev_set_cqm_txe_config: OK
[   38.454788] Testing event rdev_set_cqm_rssi_config: OK
[   38.485674] Testing event rdev_connect: OK
[   38.523163] Testing event rdev_set_power_mgmt: OK
[   38.561833] Testing event rdev_mgmt_tx_cancel_wait: OK
[   38.606801] Testing event rdev_disassoc: OK
[   38.651920] Testing event rdev_deauth: OK
[   38.701829] Testing event rdev_assoc: OK
[   38.750539] Testing event rdev_auth: OK
[   38.815112] Testing event rdev_set_monitor_channel: OK
[   38.852405] Testing event rdev_libertas_set_mesh_channel: OK
[   38.912692] Testing event rdev_set_txq_params: OK
[   38.958201] Testing event rdev_change_bss: OK
[   39.003345] Testing event rdev_join_mesh: OK
[   39.043589] Testing event rdev_update_mesh_config: OK
[   39.079815] Testing event rdev_return_int_mesh_config: OK
[   39.113025] Testing event rdev_return_int_mpath_info: OK
[   39.152658] Testing event rdev_dump_mpath: OK
[   39.193871] Testing event rdev_get_mpath: OK
[   39.227927] Testing event rdev_change_mpath: OK
[   39.263460] Testing event rdev_add_mpath: OK
[   39.298318] Testing event rdev_return_int_station_info: OK
[   39.330905] Testing event rdev_dump_station: OK
[   39.363213] Testing event rdev_set_wds_peer: OK
[   39.425202] Testing event rdev_del_mpath: OK
[   39.478753] Testing event rdev_get_station: OK
[   39.534423] Testing event rdev_del_station: OK
[   39.567425] Testing event rdev_change_station: OK
[   39.607499] Testing event rdev_add_station: OK
[   39.647238] Testing event rdev_flush_pmksa: OK
[   39.685564] Testing event rdev_leave_ibss: OK
[   39.734445] Testing event rdev_leave_mesh: OK
[   39.772108] Testing event rdev_get_mesh_config: OK
[   39.804156] Testing event rdev_set_rekey_data: OK
[   39.837310] Testing event rdev_sched_scan_stop: OK
[   39.873617] Testing event rdev_get_et_stats: OK
[   39.907407] Testing event rdev_stop_ap: OK
[   39.949088] Testing event rdev_change_beacon: OK
[   39.984792] Testing event rdev_start_ap: OK
[   40.017909] Testing event rdev_set_default_mgmt_key: OK
[   40.073576] Testing event rdev_set_default_key: OK
[   40.107602] Testing event rdev_del_key: OK
[   40.138114] Testing event rdev_get_key: OK
[   40.167899] Testing event rdev_add_key: OK
[   40.197735] Testing event rdev_change_virtual_intf: OK
[   40.237832] Testing event rdev_del_virtual_intf: OK
[   40.274775] Testing event rdev_return_wdev: OK
[   40.304546] Testing event rdev_add_virtual_intf: OK
[   40.333902] Testing event rdev_set_wakeup: OK
[   40.362659] Testing event rdev_rfkill_poll: OK
[   40.382631] Testing event rdev_get_antenna: OK
[   40.413457] Testing event rdev_get_ringparam: OK
[   40.444989] Testing event rdev_return_void: OK
[   40.472290] Testing event rdev_resume: OK
[   40.492919] Testing event rdev_scan: OK
[   40.522482] Testing event rdev_return_int: OK
[   40.545951] Testing event rdev_suspend: OK
[   40.578621] Testing event mac80211_err: OK
[   40.613905] Testing event mac80211_dbg: OK
[   40.644244] Testing event mac80211_info: OK
[   40.697413] Testing event api_radar_detected: OK
[   40.751704] Testing event drv_set_default_unicast_key: OK
[   40.798320] Testing event stop_queue: OK
[   40.872974] Testing event wake_queue: OK
[   40.917884] Testing event api_eosp: OK
[   40.943909] Testing event api_enable_rssi_reports: OK
[   41.004435] Testing event api_gtk_rekey_notify: OK
[   41.037653] Testing event api_remain_on_channel_expired: OK
[   41.062698] Testing event api_ready_on_channel: OK
[   41.095220] Testing event api_chswitch_done: OK
[   41.125406] Testing event api_sta_block_awake: OK
[   41.152797] Testing event api_sched_scan_stopped: OK
[   41.182611] Testing event api_sched_scan_results: OK
[   41.223169] Testing event api_scan_completed: OK
[   41.254517] Testing event api_cqm_rssi_notify: OK
[   41.285691] Testing event api_connection_loss: OK
[   41.324603] Testing event api_beacon_loss: OK
[   41.355079] Testing event api_restart_hw: OK
[   41.403410] Testing event api_stop_tx_ba_cb: OK
[   41.448315] Testing event api_stop_tx_ba_session: OK
[   41.487372] Testing event api_start_tx_ba_cb: OK
[   41.527834] Testing event api_start_tx_ba_session: OK
[   41.564615] Testing event drv_restart_complete: OK
[   41.613672] Testing event drv_stop_ap: OK
[   41.652119] Testing event drv_start_ap: OK
[   41.687462] Testing event drv_unassign_vif_chanctx: OK
[   41.732372] Testing event drv_assign_vif_chanctx: OK
[   41.764894] Testing event drv_change_chanctx: OK
[   41.806471] Testing event drv_remove_chanctx: OK
[   41.847279] Testing event drv_add_chanctx: OK
[   41.884789] Testing event drv_mgd_prepare_tx: OK
[   41.926732] Testing event drv_get_rssi: OK
[   41.965796] Testing event drv_allow_buffered_frames: OK
[   42.007216] Testing event drv_release_buffered_frames: OK
[   42.049404] Testing event drv_rssi_callback: OK
[   42.084492] Testing event drv_set_rekey_data: OK
[   42.117853] Testing event drv_set_bitrate_mask: OK
[   42.163352] Testing event drv_offchannel_tx_cancel_wait: OK
[   42.197123] Testing event drv_tx_frames_pending: OK
[   42.234666] Testing event drv_get_ringparam: OK
[   42.271963] Testing event drv_set_ringparam: OK
[   42.313210] Testing event drv_cancel_remain_on_channel: OK
[   42.345451] Testing event drv_remain_on_channel: OK
[   42.377373] Testing event drv_get_antenna: OK
[   42.414379] Testing event drv_set_antenna: OK
[   42.444703] Testing event drv_channel_switch: OK
[   42.475248] Testing event drv_flush: OK
[   42.505218] Testing event drv_get_survey: OK
[   42.542106] Testing event drv_ampdu_action: OK
[   42.576278] Testing event drv_tx_last_beacon: OK
[   42.621976] Testing event drv_reset_tsf: OK
[   42.657346] Testing event drv_set_tsf: OK
[   42.697196] Testing event drv_get_tsf: OK
[   42.733503] Testing event drv_conf_tx: OK
[   42.765886] Testing event drv_sta_remove: OK
[   42.807779] Testing event drv_sta_add: OK
[   42.843878] Testing event drv_sta_rc_update: OK
[   42.884932] Testing event drv_sta_state: OK
[   42.927318] Testing event drv_sta_notify: OK
[   42.965419] Testing event drv_set_coverage_class: OK
[   43.004412] Testing event drv_set_rts_threshold: OK
[   43.048322] Testing event drv_set_frag_threshold: OK
[   43.088321] Testing event drv_get_tkip_seq: OK
[   43.122832] Testing event drv_get_stats: OK
[   43.155500] Testing event drv_sw_scan_complete: OK
[   43.183618] Testing event drv_sw_scan_start: OK
[   43.214065] Testing event drv_sched_scan_stop: OK
[   43.243986] Testing event drv_sched_scan_start: OK
[   43.273700] Testing event drv_cancel_hw_scan: OK
[   43.322858] Testing event drv_hw_scan: OK
[   43.352554] Testing event drv_update_tkip_key: OK
[   43.390815] Testing event drv_set_key: OK
[   43.462089] Testing event drv_set_tim: OK
[   43.501239] Testing event drv_configure_filter: OK
[   43.534923] Testing event drv_set_multicast_list: OK
[   43.567934] Testing event drv_prepare_multicast: OK
[   43.596962] Testing event drv_bss_info_changed: OK
[   43.632196] Testing event drv_config: OK
[   43.674212] Testing event drv_remove_interface: OK
[   43.714925] Testing event drv_change_interface: OK
[   43.756046] Testing event drv_add_interface: OK
[   43.805280] Testing event drv_stop: OK
[   43.849874] Testing event drv_set_wakeup: OK
[   43.894035] Testing event drv_resume: OK
[   43.942951] Testing event drv_suspend: OK
[   43.975426] Testing event drv_get_et_stats: OK
[   44.015225] Testing event drv_get_et_sset_count: OK
[   44.048208] Testing event drv_get_et_strings: OK
[   44.075055] Testing event drv_start: OK
[   44.115946] Testing event drv_return_u64: OK
[   44.165232] Testing event drv_return_bool: OK
[   44.195259] Testing event drv_return_int: OK
[   44.223964] Testing event drv_return_void: OK
[   44.255146] Running tests on trace event systems:
[   44.263129] Testing event system mac80211: OK
[   44.544040] Testing event system mac80211_msg: OK
[   44.630314] Testing event system cfg80211: OK
[   45.155205] Testing event system skb: OK
[   45.283875] Testing event system net: OK
[   45.344987] Testing event system napi: OK
[   45.394139] Testing event system sock: OK
[   45.452193] Testing event system udp: OK
[   45.486257] Testing event system sync: OK
[   45.536909] Testing event system regmap: OK
[   45.648757] Testing event system drm: OK
[   45.698370] Testing event system random: OK
[   45.748217] Testing event system regulator: OK
[   45.787651] Testing event system gpio: OK
[   45.834017] Testing event system writeback: OK
[   45.937980] Testing event system migrate: OK
[   45.975765] Testing event system compaction: OK
[   46.015410] Testing event system kmem: OK
[   46.101893] Testing event system vmscan: OK
[   46.219851] Testing event system pagemap: OK
[   46.270695] Testing event system oom: OK
[   46.306040] Testing event system filemap: OK
[   46.344843] Testing event system power: OK
[   46.423847] Testing event system test: OK
[   46.464108] Testing event system lock: OK
[   46.504714] Testing event system sched: OK
[   46.619008] Testing event system rcu: OK
[   46.663147] Testing event system workqueue: OK
[   46.724617] Testing event system signal: OK
[   46.788983] Testing event system timer: OK
[   46.895401] Testing event system irq: OK
[   47.006203] Testing event system printk: OK
[   47.062926] Testing event system task: OK
[   47.142772] Testing event system raw_syscalls: OK
[   47.196226] Testing event system vsyscall: OK
[   47.236086] Testing event system syscalls: OK
[   47.316849] Testing event system kvmmmu: OK
[   47.404071] Testing event system kvm: OK
[   47.706916] Running tests on all trace events:
[   47.725725] Testing all events: OK
[   50.869247] Testing ftrace filter: OK
[   50.897207] Key type encrypted registered
[   50.899172] IMA: No TPM chip found, activating TPM-bypass!
[   50.908691]   Magic number: 1:773:522
[   50.911302] console [netcon0] enabled
[   50.913522] netconsole: network logging started
[   50.917028] /c/kernel-tests/src/stable/drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[   50.936787] Freeing unused kernel memory: 1204K (ffffffff81fc1000 - ffffffff820ee000)
[   50.947042] Write protecting the kernel read-only data: 14336k
[   50.956764] Freeing unused kernel memory: 252K (ffff8800017c1000 - ffff880001800000)
[   50.989595] Freeing unused kernel memory: 1884K (ffff880001c29000 - ffff880001e00000)
[   51.064638] hostname (1090) used greatest stack depth: 5176 bytes left
/bin/sh: /proc/self/fd/9: No such file or directory
[   51.240530] sh (1096) used greatest stack depth: 4976 bytes left
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
[   51.524946] 
[   51.525983] ===============================
[   51.532875] [ INFO: suspicious RCU usage. ]
[   51.535385] 3.10.0-rc4-next-20130606 #6 Not tainted
[   51.538304] -------------------------------
[   51.540937] /c/kernel-tests/src/stable/include/linux/rcupdate.h:471 Illegal context switch in RCU read-side critical section!
[   51.548110] 
[   51.548110] other info that might help us debug this:
[   51.548110] 
[   51.553055] 
[   51.553055] rcu_scheduler_active = 1, debug_locks = 1
[   51.557199] 2 locks held by trinity/1107:
[   51.560168]  #0:  (&ids->rw_mutex){+.+.+.}, at: [<ffffffff811e15ee>] ipcget+0x38/0x2b3
[   51.566465]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff811e7698>] newseg+0x19d/0x3fd
[   51.572413] 
[   51.572413] stack backtrace:
[   51.574761] CPU: 0 PID: 1107 Comm: trinity Not tainted 3.10.0-rc4-next-20130606 #6
[   51.579331] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   51.583068]  0000000000000001 ffff880004a07d88 ffffffff817b1f5c ffff880004a07db8
[   51.592119]  ffffffff810f2f1d ffffffff81b78569 00000000000001a8 0000000000000000
[   51.596726]  0000000000000000 ffff880004a07de8 ffffffff810ded5e ffff880004a07fd8
[   51.605189] Call Trace:
[   51.606409]  [<ffffffff817b1f5c>] dump_stack+0x19/0x1b
[   51.609632]  [<ffffffff810f2f1d>] lockdep_rcu_suspicious+0xeb/0xf4
[   51.612905]  [<ffffffff810ded5e>] __might_sleep+0x59/0x1dc
[   51.618614]  [<ffffffff81238623>] idr_preload+0x9b/0x142
[   51.621939]  [<ffffffff811e0e56>] ipc_addid+0x3d/0x193
[   51.624373]  [<ffffffff811e771c>] newseg+0x221/0x3fd
[   51.626596]  [<ffffffff811e7698>] ? newseg+0x19d/0x3fd
[   51.630177]  [<ffffffff811e1774>] ipcget+0x1be/0x2b3
[   51.633174]  [<ffffffff817bc094>] ? retint_swapgs+0x13/0x1b
[   51.636356]  [<ffffffff811e7a5a>] SyS_shmget+0x59/0x5d
[   51.639576]  [<ffffffff811e74fb>] ? shm_try_destroy_orphaned+0xbf/0xbf
[   51.643673]  [<ffffffff811e6ce5>] ? shm_get_unmapped_area+0x20/0x20
[   51.647321]  [<ffffffff811e6cf0>] ? shm_security+0xb/0xb
[   51.650831]  [<ffffffff817bcb27>] system_call_fastpath+0x16/0x1b
[   51.654332] BUG: sleeping function called from invalid context at /c/kernel-tests/src/stable/lib/idr.c:424
[   51.660001] in_atomic(): 1, irqs_disabled(): 0, pid: 1107, name: trinity
[   51.663625] 2 locks held by trinity/1107:
[   51.665481]  #0:  (&ids->rw_mutex){+.+.+.}, at: [<ffffffff811e15ee>] ipcget+0x38/0x2b3
[   51.669691]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff811e7698>] newseg+0x19d/0x3fd
[   51.674778] CPU: 0 PID: 1107 Comm: trinity Not tainted 3.10.0-rc4-next-20130606 #6
[   51.679134] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   51.682437]  00000000000001a8 ffff880004a07db8 ffffffff817b1f5c ffff880004a07de8
[   51.687930]  ffffffff810deed9 ffff880004a07fd8 ffff88000491ad00 ffffffff81e62338
[   51.692813]  00000000000000d0 ffff880004a07e18 ffffffff81238623 ffff88000491adc8
[   51.696526] Call Trace:
[   51.697674]  [<ffffffff817b1f5c>] dump_stack+0x19/0x1b
[   51.701918]  [<ffffffff810deed9>] __might_sleep+0x1d4/0x1dc
[   51.705308]  [<ffffffff81238623>] idr_preload+0x9b/0x142
[   51.708775]  [<ffffffff811e0e56>] ipc_addid+0x3d/0x193
[   51.711719]  [<ffffffff811e771c>] newseg+0x221/0x3fd
[   51.714556]  [<ffffffff811e7698>] ? newseg+0x19d/0x3fd
[   51.719299]  [<ffffffff811e1774>] ipcget+0x1be/0x2b3
[   51.722319]  [<ffffffff817bc094>] ? retint_swapgs+0x13/0x1b
[   51.725646]  [<ffffffff811e7a5a>] SyS_shmget+0x59/0x5d
[   51.731221]  [<ffffffff811e74fb>] ? shm_try_destroy_orphaned+0xbf/0xbf
[   51.735203]  [<ffffffff811e6ce5>] ? shm_get_unmapped_area+0x20/0x20
[   51.738994]  [<ffffffff811e6cf0>] ? shm_security+0xb/0xb
[   51.742525]  [<ffffffff817bcb27>] system_call_fastpath+0x16/0x1b
[   68.080175] rcu-torture: rtc: ffffffff8295a890 ver: 1134 tfle: 0 rta: 1134 rtaf: 0 rtf: 1133 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2160 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=100) barrier: 0/0:0
[   68.080175] rcu-torture: Reader Pipe:  1572858 0 0 0 0 0 0 0 0 0 0
[   68.080175] rcu-torture: Reader Batch:  1572858 0 0 0 0 0 0 0 0 0 0
[   68.080175] rcu-torture: Free-Block Circulation:  1133 1133 1133 1133 1133 1133 1133 1133 1133 1133 0
[   80.707447] BUG: sleeping function called from invalid context at /c/kernel-tests/src/stable/lib/idr.c:424
[   80.713570] in_atomic(): 1, irqs_disabled(): 0, pid: 1111, name: trinity-child0
[   80.718166] 2 locks held by trinity-child0/1111:
[   80.721094]  #0:  (&ids->rw_mutex){+.+.+.}, at: [<ffffffff811e1605>] ipcget+0x4f/0x2b3
[   80.725561]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff811e1d29>] newque+0x6b/0x280
[   80.730432] CPU: 0 PID: 1111 Comm: trinity-child0 Not tainted 3.10.0-rc4-next-20130606 #6
[   80.735404] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   80.738357]  00000000000001a8 ffff880004583dd8 ffffffff817b1f5c ffff880004583e08
[   80.742865]  ffffffff810deed9 ffff880004583fd8 ffff88000491bd00 ffffffff81e62258
[   80.747517]  00000000000000d0 ffff880004583e38 ffffffff81238623 ffff88000491bdc0
[   80.751269] Call Trace:
[   80.752692]  [<ffffffff817b1f5c>] dump_stack+0x19/0x1b
[   80.755921]  [<ffffffff810deed9>] __might_sleep+0x1d4/0x1dc
[   80.759519]  [<ffffffff81238623>] idr_preload+0x9b/0x142
[   80.762140]  [<ffffffff811e0e56>] ipc_addid+0x3d/0x193
[   80.763939]  [<ffffffff811e1daf>] newque+0xf1/0x280
[   80.765632]  [<ffffffff811e1d29>] ? newque+0x6b/0x280
[   80.767767]  [<ffffffff817b9240>] ? down_write+0x44/0x65
[   80.769873]  [<ffffffff811e1774>] ipcget+0x1be/0x2b3
[   80.772569]  [<ffffffff811e27f3>] SyS_msgget+0x55/0x59
[   80.775403]  [<ffffffff811e1cbe>] ? expunge_all+0x53/0x53
[   80.777495]  [<ffffffff811e1bb4>] ? load_msg+0x159/0x159
[   80.779793]  [<ffffffff817bcb27>] system_call_fastpath+0x16/0x1b
[   92.807953] BUG: sleeping function called from invalid context at /c/kernel-tests/src/stable/lib/idr.c:424
[   92.810813] in_atomic(): 1, irqs_disabled(): 0, pid: 1115, name: trinity-child0
[   92.813007] 2 locks held by trinity-child0/1115:
[   92.814386]  #0:  (&ids->rw_mutex){+.+.+.}, at: [<ffffffff811e1605>] ipcget+0x4f/0x2b3
[   92.816783]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff811e1d29>] newque+0x6b/0x280
[   92.819217] CPU: 0 PID: 1115 Comm: trinity-child0 Not tainted 3.10.0-rc4-next-20130606 #6
[   92.821561] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[   92.823422]  00000000000001a8 ffff88000458fdd8 ffffffff817b1f5c ffff88000458fe08
[   92.825665]  ffffffff810deed9 ffff88000458ffd8 ffff88000491bb00 ffffffff81e62258
[   92.827904]  00000000000000d0 ffff88000458fe38 ffffffff81238623 ffff88000491bb78
[   92.830244] Call Trace:
[   92.830956]  [<ffffffff817b1f5c>] dump_stack+0x19/0x1b
[   92.832399]  [<ffffffff810deed9>] __might_sleep+0x1d4/0x1dc
[   92.834034]  [<ffffffff81238623>] idr_preload+0x9b/0x142
[   92.835642]  [<ffffffff811e0e56>] ipc_addid+0x3d/0x193
[   92.837109]  [<ffffffff811e1daf>] newque+0xf1/0x280
[   92.838565]  [<ffffffff811e1d29>] ? newque+0x6b/0x280
[   92.839974]  [<ffffffff811e1774>] ipcget+0x1be/0x2b3
[   92.841455]  [<ffffffff811e27f3>] SyS_msgget+0x55/0x59
[   92.842954]  [<ffffffff811e1cbe>] ? expunge_all+0x53/0x53
[   92.844423]  [<ffffffff811e1bb4>] ? load_msg+0x159/0x159
[   92.846197]  [<ffffffff817bcb27>] system_call_fastpath+0x16/0x1b
[   92.850988] warning: process `trinity-child0' used the deprecated sysctl system call with 
[  107.875221] BUG: sleeping function called from invalid context at /c/kernel-tests/src/stable/lib/idr.c:424
[  107.879336] in_atomic(): 1, irqs_disabled(): 0, pid: 1120, name: trinity-child0
[  107.882724] 2 locks held by trinity-child0/1120:
[  107.884652]  #0:  (&ids->rw_mutex){+.+.+.}, at: [<ffffffff811e1605>] ipcget+0x4f/0x2b3
[  107.887240]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff811e1d29>] newque+0x6b/0x280
[  107.890689] CPU: 0 PID: 1120 Comm: trinity-child0 Not tainted 3.10.0-rc4-next-20130606 #6
[  107.894402] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  107.896773]  00000000000001a8 ffff8800045a7dd8 ffffffff817b1f5c ffff8800045a7e08
[  107.899170]  ffffffff810deed9 ffff8800045a7fd8 ffff88000491b400 ffffffff81e62258
[  107.902742]  00000000000000d0 ffff8800045a7e38 ffffffff81238623 ffff88000491b4a0
[  107.906330] Call Trace:
[  107.907487]  [<ffffffff817b1f5c>] dump_stack+0x19/0x1b
[  107.909406]  [<ffffffff810deed9>] __might_sleep+0x1d4/0x1dc
[  107.911716]  [<ffffffff81238623>] idr_preload+0x9b/0x142
[  107.914098]  [<ffffffff811e0e56>] ipc_addid+0x3d/0x193
[  107.916436]  [<ffffffff811e1daf>] newque+0xf1/0x280
[  107.918692]  [<ffffffff811e1d29>] ? newque+0x6b/0x280
[  107.920735]  [<ffffffff811e1774>] ipcget+0x1be/0x2b3
[  107.922786]  [<ffffffff811e27f3>] SyS_msgget+0x55/0x59
[  107.924976]  [<ffffffff811e1cbe>] ? expunge_all+0x53/0x53
[  107.927444]  [<ffffffff811e1bb4>] ? load_msg+0x159/0x159
[  107.929383]  [<ffffffff817bcb27>] system_call_fastpath+0x16/0x1b
[  111.504979] 99-trinity (1095) used greatest stack depth: 4888 bytes left
 * Asking all remaining processes to terminate...       
killall5[1146]: mount returned non-zero exit status
killall5[1146]: /proc not mounted, failed to mount.

mount: proc has wrong device number or fs type proc not supported
killall5[1154]: mount returned non-zero exit status
killall5[1154]: /proc not mounted, failed to mount.
 * All processes ended within 1 seconds....       
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
mount: / is busy
 * Will now restart
[  116.920926] Unregister pv shared memory for cpu 0
[  116.924878] Restarting system.
[  116.926355] reboot: machine restart

--2fHTh5uZTiUOsy+g
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="4e1e7059d375482daeeda395bba2939679b1ee14-bisect.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IGUzZTE2MGQxYzhiNjhiZWVkZThlNDdiMjgxYmY2MzY5YjgzM2YxYzUK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgNGUxZTcwNS4uLiBBZGQgbGludXgtbmV4dCBz
cGVjaWZpYyBmaWxlcyBmb3IgMjAxMzA2MDYKSEVBRCBpcyBub3cgYXQgZTNlMTYwZC4uLiBN
ZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdsem8tdXBkYXRlL2x6by11cGRhdGUnCmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oMDA1
LTA2MDYvbmV4dDptYXN0ZXI6ZTNlMTYwZDFjOGI2OGJlZWRlOGU0N2IyODFiZjYzNjliODMz
ZjFjNTpiaXNlY3QtbGludXgKCjIwMTMtMDYtMDYtMTY6NDI6NTkgZTNlMTYwZDFjOGI2OGJl
ZWRlOGU0N2IyODFiZjYzNjliODMzZjFjNSBjb21waWxpbmcKMTg4IHJlYWwgIDEwNjUgdXNl
ciAgMTExIHN5cyAgNjI1LjgwJSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLWgwMDUtMDYwNgoK
MjAxMy0wNi0wNi0xNjo0NjozMiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEwLjAtcmM0LTA0
MTk1LWdlM2UxNjBkLi4uCTIJMy4JNwk4Li4uLi4uLi4uLi4uLi4uLi4JOS4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1bWFkZF90b19ydW5f
cXVldWUgMRtbMG0KLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4JMTAgU1VDQ0VTUwoKYmlzZWN0OiBnb29kIGNvbW1pdCBlM2Ux
NjBkMWM4YjY4YmVlZGU4ZTQ3YjI4MWJmNjM2OWI4MzNmMWM1CmdpdCBiaXNlY3Qgc3RhcnQg
NGUxZTcwNTlkMzc1NDgyZGFlZWRhMzk1YmJhMjkzOTY3OWIxZWUxNCBlM2UxNjBkMWM4YjY4
YmVlZGU4ZTQ3YjI4MWJmNjM2OWI4MzNmMWM1IC0tClByZXZpb3VzIEhFQUQgcG9zaXRpb24g
d2FzIGUzZTE2MGQuLi4gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAnbHpvLXVwZGF0
ZS9sem8tdXBkYXRlJwpIRUFEIGlzIG5vdyBhdCAxZTUxMTIwLi4uIHVzZXJuczogQ29udmVy
dCA5cCdzIHVpZC9naWQgaGFuZGxpbmcKQmlzZWN0aW5nOiAyODkgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDggc3RlcHMpClswNGViMzAzOWViYTY5M2Q1
MTA5NTJlODg2N2ZjMGIwNTc5NTVmODQwXSBzaHJpbmtlcjogY29udmVydCByZW1haW5pbmcg
c2hyaW5rZXJzIHRvIGNvdW50L3NjYW4gQVBJCmdpdCBiaXNlY3QgcnVuIC9jL2tlcm5lbC10
ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggb2JqLWJpc2VjdApydW5uaW5nIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggb2JqLWJpc2VjdAps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaDAw
NS0wNjA2L25leHQ6bWFzdGVyOjA0ZWIzMDM5ZWJhNjkzZDUxMDk1MmU4ODY3ZmMwYjA1Nzk1
NWY4NDA6YmlzZWN0LWxpbnV4CgoyMDEzLTA2LTA2LTE4OjIwOjMyIDA0ZWIzMDM5ZWJhNjkz
ZDUxMDk1MmU4ODY3ZmMwYjA1Nzk1NWY4NDAgY29tcGlsaW5nCjEzOSByZWFsICAxMTY2IHVz
ZXIgIDEwOCBzeXMgIDkxNi41MSUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1oMDA1LTA2MDYK
CjIwMTMtMDYtMDYtMTg6MjM6MTMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMC4wLXJjNC0w
NDQ4NS1nMDRlYjMwMy4uLi4uLi4uLi4uLi4uCTEuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
CTIuLi4uLi4uLi4uCTMuLi4uLi4uLi4uLi4JNC4JNS4uLi4uLi4uCTYuLi4JNy4uCTguLi4u
Li4uLgk5Li4uLi4uLi4uLi4uLi4uLi4uCTEwIFNVQ0NFU1MKCkJpc2VjdGluZzogMTQ0IHJl
dmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA3IHN0ZXBzKQpbODcw
Y2UxN2Q5NjI2MDI0NmJkMzQzZjU1YjU1YjZhZGI0NjhhYWI3Nl0gcnRjOiBydGMtbXBjNTEy
MTogdXNlIGRldm1fKigpIGZ1bmN0aW9ucwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaDAwNS0wNjA2L25leHQ6bWFzdGVy
Ojg3MGNlMTdkOTYyNjAyNDZiZDM0M2Y1NWI1NWI2YWRiNDY4YWFiNzY6YmlzZWN0LWxpbnV4
CgoyMDEzLTA2LTA2LTE5OjE4OjQ2IDg3MGNlMTdkOTYyNjAyNDZiZDM0M2Y1NWI1NWI2YWRi
NDY4YWFiNzYgY29tcGlsaW5nCjEyOCByZWFsICAxMTMyIHVzZXIgIDEwNiBzeXMgIDk2NC4x
NyUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1oMDA1LTA2MDYKCjIwMTMtMDYtMDYtMTk6MjE6
MTEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMC4wLXJjNC0wNDYzMC1nODcwY2UxNy4uLi4u
LgkxLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMgk1CTYuCTguLi4uLi4uLi4uCTkuLi4JMTAg
U1VDQ0VTUwoKQmlzZWN0aW5nOiA3MiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgNiBzdGVwcykKW2U3NWFmZjdmMzUzZjUwM2QzODg2M2ZkMGEzZTFkMWU0
YTMzMTIzMjVdIHg4Njoga2lsbCBUSUZfREVCVUcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIG9iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10
ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWgwMDUtMDYwNi9uZXh0Om1h
c3RlcjplNzVhZmY3ZjM1M2Y1MDNkMzg4NjNmZDBhM2UxZDFlNGEzMzEyMzI1OmJpc2VjdC1s
aW51eAoKMjAxMy0wNi0wNi0xOTo0NjoxNyBlNzVhZmY3ZjM1M2Y1MDNkMzg4NjNmZDBhM2Ux
ZDFlNGEzMzEyMzI1IGNvbXBpbGluZwoxNDUgcmVhbCAgMTE1MCB1c2VyICAxMDMgc3lzICA4
NjEuMDglIGNwdSAJeDg2XzY0LXJhbmRjb25maWctaDAwNS0wNjA2CgoyMDEzLTA2LTA2LTE5
OjQ5OjM2IGRldGVjdGluZyBib290IHN0YXRlIDMuMTAuMC1yYzQtMDQ3MDItZ2U3NWFmZjcu
Li4JNS4JMTAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAzNiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0
IGFmdGVyIHRoaXMgKHJvdWdobHkgNSBzdGVwcykKWzkzZjk0ZmNhM2UzZWRjNzZiZDNmMzky
ZWRjZDhkZGMxMzYyOWM2MjZdIGlwYy9zZW0uYzogcmVuYW1lIHRyeV9hdG9taWNfc2Vtb3Ao
KSB0byBwZXJmb3JtX2F0b21pY19zZW1vcCgpLCBkb2N1IHVwZGF0ZQpydW5uaW5nIC9jL2tl
cm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggb2JqLWJpc2VjdApscyAt
YSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaDAwNS0w
NjA2L25leHQ6bWFzdGVyOjkzZjk0ZmNhM2UzZWRjNzZiZDNmMzkyZWRjZDhkZGMxMzYyOWM2
MjY6YmlzZWN0LWxpbnV4CgoyMDEzLTA2LTA2LTE5OjUyOjM5IDkzZjk0ZmNhM2UzZWRjNzZi
ZDNmMzkyZWRjZDhkZGMxMzYyOWM2MjYgY29tcGlsaW5nCjE0OCByZWFsICAxMTU0IHVzZXIg
IDEwNSBzeXMgIDg0Ni40MCUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1oMDA1LTA2MDYKCjIw
MTMtMDYtMDYtMTk6NTY6MTIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMC4wLXJjNC0wNDcz
OC1nOTNmOTRmYy4uLi4gVEVTVCBGQUlMVVJFCmRtZXNnLWt2bS1jYWlyby00ODQ5Ni0yMDEz
MDYwNjE5NTkwNS0zLjEwLjAtcmM0LTA0NzM4LWc5M2Y5NGZjLTE2CmRtZXNnLWt2bS1rYnVp
bGQtMzg1ODQtMjAxMzA2MDYxOTUxNTMtMy4xMC4wLXJjNC0wNDczOC1nOTNmOTRmYy0xNgpk
bWVzZy1rdm0td2FpbWVhLTM4NjItMjAxMzA2MDYyMDAxMDQtMy4xMC4wLXJjNC0wNDczOC1n
OTNmOTRmYy0xNgoKQmlzZWN0aW5nOiAxNyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgNCBzdGVwcykKW2U2MzkxYzNhNzZlMjliOTJhNmMwMTgzZjRkOTQ3
NzZjMWNhOWVjYmNdIGlhNjQ6IHJlbW92ZSBzZXR0aW5nIGZvciBzYXZlZF9tYXhfcGZuCnJ1
bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCBvYmot
YmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNv
bmZpZy1oMDA1LTA2MDYvbmV4dDptYXN0ZXI6ZTYzOTFjM2E3NmUyOWI5MmE2YzAxODNmNGQ5
NDc3NmMxY2E5ZWNiYzpiaXNlY3QtbGludXgKCjIwMTMtMDYtMDYtMTk6NTg6MTMgZTYzOTFj
M2E3NmUyOWI5MmE2YzAxODNmNGQ5NDc3NmMxY2E5ZWNiYyBjb21waWxpbmcKMTMzIHJlYWwg
IDExNTcgdXNlciAgMTAzIHN5cyAgOTQ2LjU3JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLWgw
MDUtMDYwNgoKMjAxMy0wNi0wNi0yMDowMDo0MyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEw
LjAtcmM0LTA0NzIwLWdlNjM5MWMzLi4uCTcJOC4uLi4uLi4uCTkuLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4JMTAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA4IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3Qg
YWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbNDdjZGU2Yzg2NzRlYzA1OThiNmRhNGMw
ODEzZWM5ODRlZTIwOWQ5N10gaXBjLG1zZzogc2hvcnRlbiBjcml0aWNhbCByZWdpb24gaW4g
bXNnY3RsX2Rvd24KcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIG9iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3Zt
L3g4Nl82NC1yYW5kY29uZmlnLWgwMDUtMDYwNi9uZXh0Om1hc3Rlcjo0N2NkZTZjODY3NGVj
MDU5OGI2ZGE0YzA4MTNlYzk4NGVlMjA5ZDk3OmJpc2VjdC1saW51eAoKMjAxMy0wNi0wNi0y
MDo0NTo0OCA0N2NkZTZjODY3NGVjMDU5OGI2ZGE0YzA4MTNlYzk4NGVlMjA5ZDk3IGNvbXBp
bGluZwoxMzMgcmVhbCAgMTE0NSB1c2VyICAxMDYgc3lzICA5MzkuNjMlIGNwdSAJeDg2XzY0
LXJhbmRjb25maWctaDAwNS0wNjA2CgoyMDEzLTA2LTA2LTIwOjQ4OjE2IGRldGVjdGluZyBi
b290IHN0YXRlIDMuMTAuMC1yYzQtMDQ3MjktZzQ3Y2RlNmMuLi4uIFRFU1QgRkFJTFVSRQpk
bWVzZy1rdm0tcm9hbS0xNDc1MS0yMDEzMDYwNjIwNTAzMi0zLjEwLjAtcmM0LTA0NzI5LWc0
N2NkZTZjLTE4CmRtZXNnLWt2bS13YWltZWEtMjYyMzQtMjAxMzA2MDYyMDUzMDUtMy4xMC4w
LXJjNC0wNDcyOS1nNDdjZGU2Yy0xOApkbWVzZy1rdm0tY2Fpcm8tNjA2MTMtMjAxMzA2MDYy
MDUxMDktMy4xMC4wLXJjNC0wNDcyOS1nNDdjZGU2Yy0xOApkbWVzZy1rdm0taW5uLTQ1NDIx
LTIwMTMwNjA2MjA0ODAzLTMuMTAuMC1yYzQtMDQ3MjktZzQ3Y2RlNmMtMTgKZG1lc2cta3Zt
LXZwLTI5OTM0LTIwMTMwNjA2MjA1MjIwLTMuMTAuMC1yYzQtMDQ3MjktZzQ3Y2RlNmMtMTgK
CkJpc2VjdGluZzogNCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdo
bHkgMiBzdGVwcykKWzM0M2ZmNjcxNTM5ZTZjZTliYzg0OWQ4ODFmY2VjNWMwMDQzNDJlMGFd
IGlwYy9zaG1jLmM6IGVsaW1pbmF0ZSB1Z2x5IDgwLWNvbCB0cmlja3MKcnVubmluZyAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIG9iai1iaXNlY3QKbHMg
LWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLWgwMDUt
MDYwNi9uZXh0Om1hc3RlcjozNDNmZjY3MTUzOWU2Y2U5YmM4NDlkODgxZmNlYzVjMDA0MzQy
ZTBhOmJpc2VjdC1saW51eAoKMjAxMy0wNi0wNi0yMDo1MDoxOCAzNDNmZjY3MTUzOWU2Y2U5
YmM4NDlkODgxZmNlYzVjMDA0MzQyZTBhIGNvbXBpbGluZwoxMzUgcmVhbCAgMTE0OSB1c2Vy
ICAxMDYgc3lzICA5MjcuMDMlIGNwdSAJeDg2XzY0LXJhbmRjb25maWctaDAwNS0wNjA2Cgoy
MDEzLTA2LTA2LTIwOjUyOjU5IGRldGVjdGluZyBib290IHN0YXRlIDMuMTAuMC1yYzQtMDQ3
MjQtZzM0M2ZmNjcuLi4JNwkxMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDIgcmV2aXNpb25zIGxl
ZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEgc3RlcCkKW2UzYTc3ODBmYmI1NGQ5
M2ZkMDUzMTgyZDRiMWY4YzU1OTZiMzcyNDddIGlwYzogaW50cm9kdWNlIGlwYyBvYmplY3Qg
bG9ja2luZyBoZWxwZXJzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJv
b3QtZmFpbHVyZS5zaCBvYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS94ODZfNjQtcmFuZGNvbmZpZy1oMDA1LTA2MDYvbmV4dDptYXN0ZXI6ZTNhNzc4MGZi
YjU0ZDkzZmQwNTMxODJkNGIxZjhjNTU5NmIzNzI0NzpiaXNlY3QtbGludXgKCjIwMTMtMDYt
MDYtMjA6NTU6MzMgZTNhNzc4MGZiYjU0ZDkzZmQwNTMxODJkNGIxZjhjNTU5NmIzNzI0NyBj
b21waWxpbmcKMTUzIHJlYWwgIDExMjggdXNlciAgMTA0IHN5cyAgODAzLjA1JSBjcHUgCXg4
Nl82NC1yYW5kY29uZmlnLWgwMDUtMDYwNgoKMjAxMy0wNi0wNi0yMTowMDozOCBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAzLjEwLjAtcmM0LTA0NzI2LWdlM2E3NzgwLi4uLiBURVNUIEZBSUxV
UkUKZG1lc2cta3ZtLXdhaW1lYS0yNjIzNC0yMDEzMDYwNjIxMDUxMi0zLjEwLjAtcmM0LTA0
NzI2LWdlM2E3NzgwLTIwCmRtZXNnLWt2bS13YWltZWEtMzkwMC0yMDEzMDYwNjIxMDUxMy0z
LjEwLjAtcmM0LTA0NzI2LWdlM2E3NzgwLTIwCmRtZXNnLWt2bS13YWltZWEtMzkzOC0yMDEz
MDYwNjIxMDUxMi0zLjEwLjAtcmM0LTA0NzI2LWdlM2E3NzgwLTIwCmRtZXNnLWt2bS12cC0y
NjE5Mi0yMDEzMDYwNjIxMDQyOC0zLjEwLjAtcmM0LTA0NzI2LWdlM2E3NzgwLTIwCmRtZXNn
LWt2bS12cC0yODIzMC0yMDEzMDYwNjIxMDQyOS0zLjEwLjAtcmM0LTA0NzI2LWdlM2E3Nzgw
LTIwCmRtZXNnLWt2bS12cC0yODU5NS0yMDEzMDYwNjIxMDQyNy0zLjEwLjAtcmM0LTA0NzI2
LWdlM2E3NzgwLTIwCmRtZXNnLWt2bS12cC0yOTc2OS0yMDEzMDYwNjIxMDQyOC0zLjEwLjAt
cmM0LTA0NzI2LWdlM2E3NzgwLTIwCmRtZXNnLWt2bS13YWltZWEtMjYyNzktMjAxMzA2MDYy
MTA1MTUtMy4xMC4wLXJjNC0wNDcyNi1nZTNhNzc4MC0yMApkbWVzZy1rdm0teGd3by0yMjU0
Ny0yMDEzMDYwNjIxMDIxNy0zLjEwLjAtcmM0LTA0NzI2LWdlM2E3NzgwLTIwCgpCaXNlY3Rp
bmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDAgc3Rl
cHMpClsxZjY1ODcxMTRhNjg5YTVkN2ZkZmIwZDRhYmM4MTgxMTdlMzE4MmE1XSBpcGM6IG1v
dmUgcmN1IGxvY2sgb3V0IG9mIGlwY19hZGRpZApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctaDAwNS0wNjA2L25leHQ6bWFz
dGVyOjFmNjU4NzExNGE2ODlhNWQ3ZmRmYjBkNGFiYzgxODExN2UzMTgyYTU6YmlzZWN0LWxp
bnV4CgoyMDEzLTA2LTA2LTIxOjAyOjQ3IDFmNjU4NzExNGE2ODlhNWQ3ZmRmYjBkNGFiYzgx
ODExN2UzMTgyYTUgY29tcGlsaW5nCjIxNCByZWFsICAxMTYwIHVzZXIgIDEwMiBzeXMgIDU4
OS44OCUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1oMDA1LTA2MDYKCjIwMTMtMDYtMDYtMjE6
MDk6NTcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMC4wLXJjNC0wNDcyNS1nMWY2NTg3MS4u
Li4gVEVTVCBGQUlMVVJFCmRtZXNnLWt2bS13YWltZWEtMzYzMi0yMDEzMDYwNjIxMTQ0Mi0z
LjEwLjAtcmM0LTA0NzI1LWcxZjY1ODcxLTIxCmRtZXNnLWt2bS12cC0zMzMyNS0yMDEzMDYw
NjIxMTM1Mi0zLjEwLjAtcmM0LTA0NzI1LWcxZjY1ODcxLTIxCmRtZXNnLWt2bS12cC0yNjE5
Mi0yMDEzMDYwNjIxMTM1Mi0zLjEwLjAtcmM0LTA0NzI1LWcxZjY1ODcxLTIxCmRtZXNnLWt2
bS12cC0yODIzMC0yMDEzMDYwNjIxMTM1Mi0zLjEwLjAtcmM0LTA0NzI1LWcxZjY1ODcxLTIx
CmRtZXNnLWt2bS12cC0yOTc2OS0yMDEzMDYwNjIxMTM1My0zLjEwLjAtcmM0LTA0NzI1LWcx
ZjY1ODcxLTIxCmRtZXNnLWt2bS12cC0zMDE0NC0yMDEzMDYwNjIxMTM1Mi0zLjEwLjAtcmM0
LTA0NzI1LWcxZjY1ODcxLTIxCmRtZXNnLWt2bS1iZW5zLTc2MjEtMjAxMzA2MDYyMTExMDAt
My4xMC4wLXJjNC0wNDcyNS1nMWY2NTg3MS0yMQpkbWVzZy1rdm0tYmVucy03ODk2LTIwMTMw
NjA2MjExMDU5LTMuMTAuMC1yYzQtMDQ3MjUtZzFmNjU4NzEtMjEKZG1lc2cta3ZtLXhnd28t
MTk3NjYtMjAxMzA2MDYyMTExMzgtMy4xMC4wLXJjNC0wNDcyNS1nMWY2NTg3MS0yMQpkbWVz
Zy1rdm0teGd3by0yMzQzOC0yMDEzMDYwNjIxMTEzOC0zLjEwLjAtcmM0LTA0NzI1LWcxZjY1
ODcxLTIxCgoxZjY1ODcxMTRhNjg5YTVkN2ZkZmIwZDRhYmM4MTgxMTdlMzE4MmE1IGlzIHRo
ZSBmaXJzdCBiYWQgY29tbWl0CmNvbW1pdCAxZjY1ODcxMTRhNjg5YTVkN2ZkZmIwZDRhYmM4
MTgxMTdlMzE4MmE1CkF1dGhvcjogRGF2aWRsb2hyIEJ1ZXNvIDxkYXZpZGxvaHIuYnVlc29A
aHAuY29tPgpEYXRlOiAgIFRodSBKdW4gNiAxMDo0MTo1NiAyMDEzICsxMDAwCgogICAgaXBj
OiBtb3ZlIHJjdSBsb2NrIG91dCBvZiBpcGNfYWRkaWQKICAgIAogICAgVGhpcyBwYXRjaHNl
dCBjb250aW51ZXMgdGhlIHdvcmsgdGhhdCBiZWdhbiBpbiB0aGUgc3lzdiBpcGMgc2VtYXBo
b3JlCiAgICBzY2FsaW5nIHNlcmllczogaHR0cHM6Ly9sa21sLm9yZy9sa21sLzIwMTMvMy8y
MC81NDYKICAgIAogICAgSnVzdCBsaWtlIHNlbWFwaG9yZXMgdXNlZCB0byBiZSwgc3lzdiBz
aGFyZWQgbWVtb3J5IGFuZCBtc2cgcXVldWVzIGFsc28KICAgIGFidXNlIHRoZSBpcGMgbG9j
aywgdW5uZWNlc3NhcmlseSBob2xkaW5nIGl0IGZvciBvcGVyYXRpb25zIHN1Y2ggYXMKICAg
IHBlcm1pc3Npb24gYW5kIHNlY3VyaXR5IGNoZWNrcy4gIFRoaXMgcGF0Y2hzZXQgbW9zdGx5
IGRlYWxzIHdpdGggbXF1ZXVlcywKICAgIGFuZCB3aGlsZSBzaGFyZWQgbWVtIGNhbiBiZSBk
b25lIGluIGEgdmVyeSBzaW1pbGFyIHdheSwgSSB3YW50IHRvIGdldAogICAgdGhlc2UgcGF0
Y2hlcyBvdXQgaW4gdGhlIG9wZW4gZmlyc3QuICBJdCBhbHNvIGRvZXMgc29tZSBwZW5kaW5n
IGNsZWFudXBzLAogICAgbW9zdGx5IGZvY3VzZWQgb24gdGhlIHR3byBsZXZlbCBsb2NraW5n
IHdlIGhhdmUgaW4gaXBjIGNvZGUsIHRha2luZyBjYXJlCiAgICBvZiBpcGNfYWRkaWQoKSBh
bmQgaXBjY3RsX3ByZV9kb3duX25vbG9jaygpIC0geWVzIHRoZXJlIGFyZSBzdGlsbAogICAg
ZnVuY3Rpb25zIHRoYXQgbmVlZCB0byBiZSB1cGRhdGVkIGFzIHdlbGwuCiAgICAKICAgIFRo
aXMgcGF0Y2g6CiAgICAKICAgIE1ha2UgYWxsIGNhbGxlcnMgZXhwbGljaXRseSB0YWtlIGFu
ZCByZWxlYXNlIHRoZSBSQ1UgcmVhZCBsb2NrLgogICAgCiAgICBUaGlzIGFkZHJlc3NlcyB0
aGUgdHdvIGxldmVsIGxvY2tpbmcgc2VlbiBpbiBuZXdhcnkoKSwgbmV3c2VnKCkgYW5kCiAg
ICBuZXdxdWV1ZSgpLiAgRm9yIHRoZSBsYXN0IHR3bywgZXhwbGljaXRseSB1bmxvY2sgdGhl
IGlwYyBvYmplY3QgYW5kIHRoZQogICAgcmN1IGxvY2ssIGluc3RlYWQgb2YgY2FsbGluZyB0
aGUgY3VzdG9tIHNobV91bmxvY2sgYW5kIG1zZ191bmxvY2sKICAgIGZ1bmN0aW9ucy4gIFRo
ZSBuZXh0IHBhdGNoIHdpbGwgZGVhbCB3aXRoIHRoZSBvcGVuIGNvZGVkIGxvY2tpbmcgZm9y
CiAgICAtPnBlcm0ubG9jawogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBEYXZpZGxvaHIgQnVl
c28gPGRhdmlkbG9oci5idWVzb0BocC5jb20+CiAgICBDYzogQW5kaSBLbGVlbiA8YW5kaUBm
aXJzdGZsb29yLm9yZz4KICAgIENjOiBSaWsgdmFuIFJpZWwgPHJpZWxAcmVkaGF0LmNvbT4K
ICAgIFNpZ25lZC1vZmYtYnk6IEFuZHJldyBNb3J0b24gPGFrcG1AbGludXgtZm91bmRhdGlv
bi5vcmc+Cgo6MDQwMDAwIDA0MDAwMCBjN2E1YjZmYjcxMzc5OGIzMmQyMTc2ZjQ0Zjc2NDJk
MTgxZWZlZGU0IDg4MjA0MDg2YzM2Y2YxNTFhZmUyNmY1NzFjM2IxOTI4ZDkzNWYzOTYgTQlp
cGMKYmlzZWN0IHJ1biBzdWNjZXNzCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2
bS94ODZfNjQtcmFuZGNvbmZpZy1oMDA1LTA2MDYvbmV4dDptYXN0ZXI6MzQzZmY2NzE1Mzll
NmNlOWJjODQ5ZDg4MWZjZWM1YzAwNDM0MmUwYTpiaXNlY3QtbGludXgKCjIwMTMtMDYtMDYt
MjE6MTI6MDYgMzQzZmY2NzE1MzllNmNlOWJjODQ5ZDg4MWZjZWM1YzAwNDM0MmUwYSByZXVz
ZSAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWgwMDUtMDYwNi8zNDNmZjY3MTUzOWU2Y2U5
YmM4NDlkODgxZmNlYzVjMDA0MzQyZTBhL3ZtbGludXotMy4xMC4wLXJjNC0wNDcyNC1nMzQz
ZmY2NwoKMjAxMy0wNi0wNi0yMToxMjowNiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4JMTMJ
MTkJMjkJMzAgU1VDQ0VTUwoKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4
Nl82NC1yYW5kY29uZmlnLWgwMDUtMDYwNi9uZXh0Om1hc3Rlcjo0ZTFlNzA1OWQzNzU0ODJk
YWVlZGEzOTViYmEyOTM5Njc5YjFlZTE0OmJpc2VjdC1saW51eAogVEVTVCBGQUlMVVJFCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctaDAwNS0wNjA2LzRlMWU3MDU5ZDM3NTQ4MmRhZWVk
YTM5NWJiYTI5Mzk2NzliMWVlMTQvZG1lc2cta3ZtLWNhaXJvLTUyMjkyLTIwMTMwNjA2MTYz
MzUwLTMuMTAuMC1yYzQtbmV4dC0yMDEzMDYwNi02Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaDAwNS0wNjA2LzRlMWU3MDU5ZDM3NTQ4MmRhZWVkYTM5NWJiYTI5Mzk2NzliMWVlMTQv
ZG1lc2cta3ZtLWlubi00OTI0Mi0yMDEzMDYwNjE2MzM1Ni0zLjEwLjAtcmM0LW5leHQtMjAx
MzA2MDYtNgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWgwMDUtMDYwNi80ZTFlNzA1OWQz
NzU0ODJkYWVlZGEzOTViYmEyOTM5Njc5YjFlZTE0L2RtZXNnLWt2bS1pbm4tNTUzMTEtMjAx
MzA2MDYxNjMyNDMtMy4xMC4wLXJjNC1uZXh0LTIwMTMwNjA2LTYKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1oMDA1LTA2MDYvNGUxZTcwNTlkMzc1NDgyZGFlZWRhMzk1YmJhMjkzOTY3
OWIxZWUxNC9kbWVzZy1rdm0taW5uLTY1MDAyLTIwMTMwNjA2MTYzMzQ5LTMuMTAuMC1yYzQt
bmV4dC0yMDEzMDYwNi02Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctaDAwNS0wNjA2LzRl
MWU3MDU5ZDM3NTQ4MmRhZWVkYTM5NWJiYTI5Mzk2NzliMWVlMTQvZG1lc2cta3ZtLXJvYW0t
ODgzNy0yMDEzMDYwNjE2MzIzNy0zLjEwLjAtcmM0LW5leHQtMjAxMzA2MDYtNgova2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLWgwMDUtMDYwNi80ZTFlNzA1OWQzNzU0ODJkYWVlZGEzOTVi
YmEyOTM5Njc5YjFlZTE0L2RtZXNnLWt2bS12cC0zMTA2MC0yMDEzMDYwNjE2Mzc1MS0zLjEw
LjAtcmM0LW5leHQtMjAxMzA2MDYtNgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWgwMDUt
MDYwNi80ZTFlNzA1OWQzNzU0ODJkYWVlZGEzOTViYmEyOTM5Njc5YjFlZTE0L2RtZXNnLWt2
bS12cC0zMTc2OC0yMDEzMDYwNjE2MzcxMS0zLjEwLjAtcmM0LW5leHQtMjAxMzA2MDYtNgov
a2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWgwMDUtMDYwNi80ZTFlNzA1OWQzNzU0ODJkYWVl
ZGEzOTViYmEyOTM5Njc5YjFlZTE0L2RtZXNnLWt2bS13YWltZWEtMjY0OTEtMjAxMzA2MDYx
NjM3MzQtMy4xMC4wLXJjNC1uZXh0LTIwMTMwNjA2LTYKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1oMDA1LTA2MDYvNGUxZTcwNTlkMzc1NDgyZGFlZWRhMzk1YmJhMjkzOTY3OWIxZWUx
NC9kbWVzZy1rdm0teGd3by0yNDMyNS0yMDEzMDYwNjE2Mzc1Ni0zLjEwLjAtcmM0LW5leHQt
MjAxMzA2MDYtNgoKSEVBRCBpcyBub3cgYXQgNGUxZTcwNSBBZGQgbGludXgtbmV4dCBzcGVj
aWZpYyBmaWxlcyBmb3IgMjAxMzA2MDYKCj09PT09PT09PSBsaW51eC1uZXh0ID09PT09PT09
PQpGZXRjaGluZyBuZXh0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZf
NjQtcmFuZGNvbmZpZy1oMDA1LTA2MDYvbmV4dDptYXN0ZXI6NGUxZTcwNTlkMzc1NDgyZGFl
ZWRhMzk1YmJhMjkzOTY3OWIxZWUxNDpiaXNlY3QtbGludXgKIFRFU1QgRkFJTFVSRQova2Vy
bmVsL3g4Nl82NC1yYW5kY29uZmlnLWgwMDUtMDYwNi80ZTFlNzA1OWQzNzU0ODJkYWVlZGEz
OTViYmEyOTM5Njc5YjFlZTE0L2RtZXNnLWt2bS1jYWlyby01MjI5Mi0yMDEzMDYwNjE2MzM1
MC0zLjEwLjAtcmM0LW5leHQtMjAxMzA2MDYtNgova2VybmVsL3g4Nl82NC1yYW5kY29uZmln
LWgwMDUtMDYwNi80ZTFlNzA1OWQzNzU0ODJkYWVlZGEzOTViYmEyOTM5Njc5YjFlZTE0L2Rt
ZXNnLWt2bS1pbm4tNDkyNDItMjAxMzA2MDYxNjMzNTYtMy4xMC4wLXJjNC1uZXh0LTIwMTMw
NjA2LTYKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oMDA1LTA2MDYvNGUxZTcwNTlkMzc1
NDgyZGFlZWRhMzk1YmJhMjkzOTY3OWIxZWUxNC9kbWVzZy1rdm0taW5uLTU1MzExLTIwMTMw
NjA2MTYzMjQzLTMuMTAuMC1yYzQtbmV4dC0yMDEzMDYwNi02Ci9rZXJuZWwveDg2XzY0LXJh
bmRjb25maWctaDAwNS0wNjA2LzRlMWU3MDU5ZDM3NTQ4MmRhZWVkYTM5NWJiYTI5Mzk2Nzli
MWVlMTQvZG1lc2cta3ZtLWlubi02NTAwMi0yMDEzMDYwNjE2MzM0OS0zLjEwLjAtcmM0LW5l
eHQtMjAxMzA2MDYtNgova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLWgwMDUtMDYwNi80ZTFl
NzA1OWQzNzU0ODJkYWVlZGEzOTViYmEyOTM5Njc5YjFlZTE0L2RtZXNnLWt2bS1yb2FtLTg4
MzctMjAxMzA2MDYxNjMyMzctMy4xMC4wLXJjNC1uZXh0LTIwMTMwNjA2LTYKL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1oMDA1LTA2MDYvNGUxZTcwNTlkMzc1NDgyZGFlZWRhMzk1YmJh
MjkzOTY3OWIxZWUxNC9kbWVzZy1rdm0tdnAtMzEwNjAtMjAxMzA2MDYxNjM3NTEtMy4xMC4w
LXJjNC1uZXh0LTIwMTMwNjA2LTYKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oMDA1LTA2
MDYvNGUxZTcwNTlkMzc1NDgyZGFlZWRhMzk1YmJhMjkzOTY3OWIxZWUxNC9kbWVzZy1rdm0t
dnAtMzE3NjgtMjAxMzA2MDYxNjM3MTEtMy4xMC4wLXJjNC1uZXh0LTIwMTMwNjA2LTYKL2tl
cm5lbC94ODZfNjQtcmFuZGNvbmZpZy1oMDA1LTA2MDYvNGUxZTcwNTlkMzc1NDgyZGFlZWRh
Mzk1YmJhMjkzOTY3OWIxZWUxNC9kbWVzZy1rdm0td2FpbWVhLTI2NDkxLTIwMTMwNjA2MTYz
NzM0LTMuMTAuMC1yYzQtbmV4dC0yMDEzMDYwNi02Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25m
aWctaDAwNS0wNjA2LzRlMWU3MDU5ZDM3NTQ4MmRhZWVkYTM5NWJiYTI5Mzk2NzliMWVlMTQv
ZG1lc2cta3ZtLXhnd28tMjQzMjUtMjAxMzA2MDYxNjM3NTYtMy4xMC4wLXJjNC1uZXh0LTIw
MTMwNjA2LTYKCg==

--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.10.0-rc4 Kernel Configuration
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
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
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
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SYSVIPC=y
CONFIG_POSIX_MQUEUE=y
CONFIG_FHANDLE=y
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set
# CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
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
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
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
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
CONFIG_UIDGID_CONVERTED=y
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
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
# CONFIG_RD_LZ4 is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
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
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
CONFIG_UPROBES=y
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
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
# CONFIG_BLOCK is not set
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
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
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
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
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
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
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
# CONFIG_X86_PAT is not set
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_I2C=y
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
CONFIG_SFI=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
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
CONFIG_I7300_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
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
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
# CONFIG_IA32_EMULATION is not set
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_NETFILTER_XTABLES=y

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=y
CONFIG_BRIDGE_NF_EBTABLES=y
# CONFIG_BRIDGE_EBT_BROUTE is not set
CONFIG_BRIDGE_EBT_T_FILTER=y
# CONFIG_BRIDGE_EBT_T_NAT is not set
CONFIG_BRIDGE_EBT_802_3=y
# CONFIG_BRIDGE_EBT_AMONG is not set
CONFIG_BRIDGE_EBT_ARP=y
# CONFIG_BRIDGE_EBT_IP is not set
CONFIG_BRIDGE_EBT_LIMIT=y
# CONFIG_BRIDGE_EBT_MARK is not set
# CONFIG_BRIDGE_EBT_PKTTYPE is not set
CONFIG_BRIDGE_EBT_STP=y
# CONFIG_BRIDGE_EBT_VLAN is not set
# CONFIG_BRIDGE_EBT_DNAT is not set
CONFIG_BRIDGE_EBT_MARK_T=y
# CONFIG_BRIDGE_EBT_REDIRECT is not set
CONFIG_BRIDGE_EBT_SNAT=y
CONFIG_BRIDGE_EBT_LOG=y
CONFIG_BRIDGE_EBT_ULOG=y
CONFIG_BRIDGE_EBT_NFLOG=y
# CONFIG_ATM is not set
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_VLAN_8021Q_MVRP is not set
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_IPDDP=y
# CONFIG_IPDDP_ENCAP is not set
CONFIG_X25=y
CONFIG_LAPB=y
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_NC=y
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
CONFIG_NETLINK_MMAP=y
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
CONFIG_NETPRIO_CGROUP=y
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
CONFIG_ROSE=y

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
CONFIG_6PACK=y
CONFIG_BPQETHER=y
# CONFIG_BAYCOM_SER_FDX is not set
CONFIG_BAYCOM_SER_HDX=y
# CONFIG_YAM is not set
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
# CONFIG_CAN_BCM is not set
# CONFIG_CAN_GW is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=y
CONFIG_CAN_CALC_BITTIMING=y
CONFIG_CAN_LEDS=y
# CONFIG_PCH_CAN is not set
CONFIG_CAN_SJA1000=y
CONFIG_CAN_SJA1000_ISA=y
# CONFIG_CAN_SJA1000_PLATFORM is not set
CONFIG_CAN_EMS_PCMCIA=y
# CONFIG_CAN_EMS_PCI is not set
# CONFIG_CAN_PEAK_PCMCIA is not set
# CONFIG_CAN_PEAK_PCI is not set
# CONFIG_CAN_KVASER_PCI is not set
# CONFIG_CAN_PLX_PCI is not set
CONFIG_CAN_C_CAN=y
CONFIG_CAN_C_CAN_PLATFORM=y
# CONFIG_CAN_C_CAN_PCI is not set
CONFIG_CAN_CC770=y
CONFIG_CAN_CC770_ISA=y
CONFIG_CAN_CC770_PLATFORM=y

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=y
CONFIG_CAN_ESD_USB2=y
# CONFIG_CAN_KVASER_USB is not set
# CONFIG_CAN_PEAK_USB is not set
# CONFIG_CAN_8DEV_USB is not set
CONFIG_CAN_SOFTING=y
CONFIG_CAN_SOFTING_CS=y
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=y
CONFIG_NL80211_TESTMODE=y
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
CONFIG_CFG80211_REG_DEBUG=y
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=y
# CONFIG_MAC80211_RC_PID is not set
# CONFIG_MAC80211_RC_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT=""

#
# Some wireless drivers require a rate control algorithm
#
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
CONFIG_MAC80211_MESSAGE_TRACING=y
CONFIG_MAC80211_DEBUG_MENU=y
# CONFIG_MAC80211_NOINLINE is not set
# CONFIG_MAC80211_VERBOSE_DEBUG is not set
# CONFIG_MAC80211_MLME_DEBUG is not set
CONFIG_MAC80211_STA_DEBUG=y
# CONFIG_MAC80211_HT_DEBUG is not set
# CONFIG_MAC80211_IBSS_DEBUG is not set
# CONFIG_MAC80211_PS_DEBUG is not set
# CONFIG_MAC80211_MPL_DEBUG is not set
CONFIG_MAC80211_MPATH_DEBUG=y
# CONFIG_MAC80211_MHWMP_DEBUG is not set
# CONFIG_MAC80211_MESH_SYNC_DEBUG is not set
CONFIG_MAC80211_MESH_PS_DEBUG=y
# CONFIG_MAC80211_TDLS_DEBUG is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
# CONFIG_CAIF_NETDEV is not set
CONFIG_CAIF_USB=y
CONFIG_NFC=y
CONFIG_NFC_NCI=y
CONFIG_NFC_HCI=y
# CONFIG_NFC_SHDLC is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_PN533=y
CONFIG_NFC_WILINK=y
CONFIG_NFC_PN544=y
CONFIG_NFC_MICROREAD=y
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
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
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
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
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
CONFIG_DS1682=y
CONFIG_VMWARE_BALLOON=y
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
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
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_DUMMY is not set
CONFIG_EQUALIZER=y
CONFIG_MII=y
CONFIG_NET_TEAM=y
CONFIG_NET_TEAM_MODE_BROADCAST=y
# CONFIG_NET_TEAM_MODE_ROUNDROBIN is not set
CONFIG_NET_TEAM_MODE_RANDOM=y
# CONFIG_NET_TEAM_MODE_ACTIVEBACKUP is not set
CONFIG_NET_TEAM_MODE_LOADBALANCE=y
CONFIG_MACVLAN=y
CONFIG_MACVTAP=y
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=y
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=y
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#
# CONFIG_CAIF_TTY is not set
CONFIG_CAIF_SPI_SLAVE=y
CONFIG_CAIF_SPI_SYNC=y
CONFIG_CAIF_HSI=y
CONFIG_CAIF_VIRTIO=y
CONFIG_VHOST_NET=y
CONFIG_VHOST_RING=y

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_ETHERNET=y
CONFIG_NET_VENDOR_3COM=y
CONFIG_PCMCIA_3C574=y
CONFIG_PCMCIA_3C589=y
# CONFIG_VORTEX is not set
# CONFIG_TYPHOON is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
# CONFIG_NET_VENDOR_AMD is not set
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
CONFIG_NET_CADENCE=y
CONFIG_ARM_AT91_ETHER=y
CONFIG_MACB=y
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_FUJITSU=y
CONFIG_PCMCIA_FMVJ18X=y
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
# CONFIG_NET_VENDOR_INTEL is not set
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
CONFIG_ETHOC=y
CONFIG_NET_PACKET_ENGINE=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R8169 is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
# CONFIG_NET_VENDOR_SEEQ is not set
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
CONFIG_PCMCIA_SMC91C92=y
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_NET_VENDOR_WIZNET is not set
CONFIG_NET_VENDOR_XIRCOM=y
CONFIG_PCMCIA_XIRC2PS=y
# CONFIG_FDDI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
# CONFIG_AMD_PHY is not set
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
# CONFIG_BROADCOM_PHY is not set
CONFIG_BCM87XX_PHY=y
# CONFIG_ICPLUS_PHY is not set
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
# CONFIG_MICREL_PHY is not set
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_GPIO=y
# CONFIG_PPP is not set
# CONFIG_SLIP is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=y
CONFIG_USB_RTL8152=y
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=y
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=y
CONFIG_USB_NET_CDC_MBIM=y
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SMSC75XX is not set
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
# CONFIG_USB_NET_CDC_SUBSET is not set
# CONFIG_USB_NET_ZAURUS is not set
CONFIG_USB_NET_CX82310_ETH=y
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_NET_QMI_WWAN is not set
CONFIG_USB_HSO=y
CONFIG_USB_NET_INT51X1=y
# CONFIG_USB_IPHETH is not set
CONFIG_USB_SIERRA_NET=y
# CONFIG_USB_VL600 is not set
CONFIG_WLAN=y
CONFIG_PCMCIA_RAYCS=y
CONFIG_LIBERTAS_THINFIRM=y
CONFIG_LIBERTAS_THINFIRM_DEBUG=y
# CONFIG_LIBERTAS_THINFIRM_USB is not set
# CONFIG_AIRO is not set
CONFIG_ATMEL=y
# CONFIG_PCI_ATMEL is not set
CONFIG_PCMCIA_ATMEL=y
# CONFIG_AT76C50X_USB is not set
CONFIG_AIRO_CS=y
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
CONFIG_USB_ZD1201=y
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
# CONFIG_ATH_CARDS is not set
# CONFIG_B43 is not set
CONFIG_B43LEGACY=y
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
# CONFIG_B43LEGACY_DEBUG is not set
CONFIG_B43LEGACY_DMA=y
CONFIG_B43LEGACY_PIO=y
CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
# CONFIG_B43LEGACY_DMA_MODE is not set
# CONFIG_B43LEGACY_PIO_MODE is not set
# CONFIG_BRCMFMAC is not set
CONFIG_HOSTAP=y
# CONFIG_HOSTAP_FIRMWARE is not set
# CONFIG_HOSTAP_PLX is not set
# CONFIG_HOSTAP_PCI is not set
CONFIG_HOSTAP_CS=y
# CONFIG_IPW2100 is not set
# CONFIG_IWLWIFI is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_LIBERTAS is not set
CONFIG_P54_COMMON=y
# CONFIG_P54_USB is not set
# CONFIG_P54_PCI is not set
CONFIG_P54_LEDS=y
# CONFIG_RT2X00 is not set
CONFIG_RTLWIFI=y
CONFIG_RTLWIFI_DEBUG=y
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8723AE is not set
# CONFIG_RTL8188EE is not set
# CONFIG_RTL8192CU is not set
CONFIG_WL_TI=y
CONFIG_WL1251=y
CONFIG_WL1251_SDIO=y
CONFIG_WL12XX=y
CONFIG_WL18XX=y
CONFIG_WLCORE=y
CONFIG_WLCORE_SDIO=y
# CONFIG_WILINK_PLATFORM_DATA is not set
CONFIG_ZD1211RW=y
# CONFIG_ZD1211RW_DEBUG is not set
CONFIG_MWIFIEX=y
# CONFIG_MWIFIEX_SDIO is not set
# CONFIG_MWIFIEX_PCIE is not set
CONFIG_MWIFIEX_USB=y
# CONFIG_CW1200 is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=y
CONFIG_WIMAX_I2400M_USB=y
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=y
CONFIG_HDLC_RAW=y
CONFIG_HDLC_RAW_ETH=y
# CONFIG_HDLC_CISCO is not set
CONFIG_HDLC_FR=y
CONFIG_HDLC_PPP=y
# CONFIG_HDLC_X25 is not set
# CONFIG_PCI200SYN is not set
# CONFIG_WANXL is not set
# CONFIG_PC300TOO is not set
# CONFIG_FARSYNC is not set
# CONFIG_DLCI is not set
CONFIG_LAPBETHER=y
# CONFIG_X25_ASY is not set
CONFIG_SBNI=y
CONFIG_SBNI_MULTILINE=y
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5520 is not set
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
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
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
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=y
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
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
# CONFIG_CARDMAN_4000 is not set
CONFIG_CARDMAN_4040=y
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_PCA9541 is not set
CONFIG_I2C_MUX_PCA954x=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
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
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_TAOS_EVM=y
CONFIG_I2C_TINY_USB=y
CONFIG_I2C_VIPERBOARD=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_GPIO=y

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_DP83640_PHY=y
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9052=y
# CONFIG_GPIO_DA9055 is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
CONFIG_GPIO_MAX7300=y
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_RC5T583=y
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_STMPE=y
# CONFIG_GPIO_TC3589X is not set
CONFIG_GPIO_TWL4030=y
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_ADP5520=y
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
# CONFIG_GPIO_MCP23S08 is not set

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_PALMAS=y

#
# USB GPIO expanders:
#
CONFIG_GPIO_VIPERBOARD=y
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
# CONFIG_W1_MASTER_DS2482 is not set
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
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_MAX8925_POWER is not set
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9030 is not set
# CONFIG_BATTERY_DA9052 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_PCF50633 is not set
# CONFIG_BATTERY_RX51 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_TWL4030 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_LP8788 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MANAGER is not set
# CONFIG_CHARGER_MAX8998 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_DA9055 is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IIO_HWMON=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95234=y
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=y
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
# CONFIG_SENSORS_PMBUS is not set
# CONFIG_SENSORS_ADM1275 is not set
CONFIG_SENSORS_LM25066=y
CONFIG_SENSORS_LTC2978=y
# CONFIG_SENSORS_MAX16064 is not set
# CONFIG_SENSORS_MAX34440 is not set
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=y
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_TWL4030_MADC=y
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
# CONFIG_SENSORS_APPLESMC is not set

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
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_DA9052_WATCHDOG is not set
CONFIG_DA9055_WATCHDOG=y
CONFIG_WM831X_WATCHDOG=y
CONFIG_TWL4030_WATCHDOG=y
CONFIG_RETU_WATCHDOG=y
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
CONFIG_SC520_WDT=y
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
CONFIG_SC1200_WDT=y
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
# CONFIG_SBC8360_WDT is not set
CONFIG_CPU5_WDT=y
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
# CONFIG_W83697HF_WDT is not set
CONFIG_W83697UG_WDT=y
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_SILENT is not set
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
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_AS3711=y
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_CROS_EC=y
# CONFIG_MFD_CROS_EC_I2C is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
# CONFIG_PCF50633_GPIO is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=y
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
# CONFIG_STMPE_I2C is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_TPS80031=y
CONFIG_TWL4030_CORE=y
CONFIG_TWL4030_MADC=y
CONFIG_MFD_TWL4030_AUDIO=y
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_WM5102 is not set
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_AD5398=y
# CONFIG_REGULATOR_AAT2870 is not set
CONFIG_REGULATOR_DA903X=y
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=y
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8925=y
# CONFIG_REGULATOR_MAX8952 is not set
CONFIG_REGULATOR_MAX8973=y
# CONFIG_REGULATOR_MAX8997 is not set
CONFIG_REGULATOR_MAX8998=y
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LP8788=y
CONFIG_REGULATOR_PCF50633=y
# CONFIG_REGULATOR_RC5T583 is not set
CONFIG_REGULATOR_AB3100=y
CONFIG_REGULATOR_PALMAS=y
CONFIG_REGULATOR_TPS51632=y
# CONFIG_REGULATOR_TPS6105X is not set
CONFIG_REGULATOR_TPS62360=y
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_TPS80031 is not set
CONFIG_REGULATOR_TWL4030=y
# CONFIG_REGULATOR_WM831X is not set
# CONFIG_REGULATOR_WM8400 is not set
CONFIG_REGULATOR_AS3711=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_V4L2_INT_DEVICE=y
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
CONFIG_V4L_PLATFORM_DRIVERS=y
# CONFIG_VIDEO_CAFE_CCIC is not set
# CONFIG_SOC_CAMERA is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
# CONFIG_CYPRESS_FIRMWARE is not set

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y

#
# Audio decoders, processors and mixers
#

#
# RDS decoders
#

#
# Video decoders
#

#
# Video and audio decoders
#

#
# Video encoders
#

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#

#
# Miscelaneous helper chips
#

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MC44S803=y

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
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y
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
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
CONFIG_FB_VESA=y
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_SM501=y
# CONFIG_FB_SMSCUFX is not set
CONFIG_FB_UDL=y
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
CONFIG_FB_AUO_K1901=y
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_DA903X=y
CONFIG_BACKLIGHT_DA9052=y
# CONFIG_BACKLIGHT_MAX8925 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
# CONFIG_BACKLIGHT_WM831X is not set
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_PCF50633 is not set
# CONFIG_BACKLIGHT_AAT2870 is not set
# CONFIG_BACKLIGHT_LM3630 is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=y
# CONFIG_BACKLIGHT_LP8788 is not set
CONFIG_BACKLIGHT_PANDORA=y
CONFIG_BACKLIGHT_AS3711=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
# CONFIG_LOGO_LINUX_VGA16 is not set
# CONFIG_LOGO_LINUX_CLUT224 is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_APPLEIR is not set
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_ELO is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_HUION is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_PS3REMOTE is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
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

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DEFAULT_PERSIST is not set
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_OTG_BLACKLIST_HUB=y
CONFIG_USB_MON=y
CONFIG_USB_WUSB_CBAF=y
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
# CONFIG_USB_XHCI_HCD is not set
# CONFIG_USB_EHCI_HCD is not set
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1362_HCD=y
# CONFIG_USB_FUSBH200_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_U132_HCD is not set
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_HCD_ISO is not set
CONFIG_USB_SL811_CS=y
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_RENESAS_USBHS_HCD=y
# CONFIG_USB_HCD_SSB is not set
CONFIG_USB_MUSB_HDRC=y
# CONFIG_USB_MUSB_HOST is not set
# CONFIG_USB_MUSB_GADGET is not set
CONFIG_USB_MUSB_DUAL_ROLE=y
CONFIG_USB_MUSB_TUSB6010=y
# CONFIG_USB_MUSB_DSPS is not set
# CONFIG_USB_MUSB_UX500 is not set
CONFIG_MUSB_PIO_ONLY=y
CONFIG_USB_RENESAS_USBHS=y

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

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_DWC3=y
# CONFIG_USB_DWC3_HOST is not set
CONFIG_USB_DWC3_GADGET=y
# CONFIG_USB_DWC3_DUAL_ROLE is not set
# CONFIG_USB_DWC3_DEBUG is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
CONFIG_USB_SEVSEG=y
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=y
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
# CONFIG_USB_ISIGHTFW is not set
CONFIG_USB_YUREX=y
CONFIG_USB_EZUSB_FX2=y
# CONFIG_USB_HSIC_USB3503 is not set
# CONFIG_USB_PHY is not set
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_DEBUG=y
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_R8A66597=y
# CONFIG_USB_RENESAS_USBHS_UDC is not set
# CONFIG_USB_PXA27X is not set
# CONFIG_USB_MV_UDC is not set
CONFIG_USB_MV_U3D=y
CONFIG_USB_M66592=y
# CONFIG_USB_AMD5536UDC is not set
CONFIG_USB_NET2272=y
# CONFIG_USB_NET2272_DMA is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
CONFIG_USB_DUMMY_HCD=y
CONFIG_USB_LIBCOMPOSITE=y
# CONFIG_USB_ZERO is not set
CONFIG_USB_ETH=y
CONFIG_USB_ETH_RNDIS=y
CONFIG_USB_ETH_EEM=y
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_USB_G_WEBCAM is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_SDIO_UART=y
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_VUB300=y
# CONFIG_MMC_USHC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3533=y
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8788=y
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_PCA9633 is not set
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_DA903X=y
# CONFIG_LEDS_DA9052 is not set
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_ADP5520 is not set
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_MAX8997=y
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_CPU=y
# CONFIG_LEDS_TRIGGER_GPIO is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_LEDS_TRIGGER_CAMERA=y
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_DEV is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM80X=y
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_DS3232=y
# CONFIG_RTC_DRV_LP8788 is not set
CONFIG_RTC_DRV_MAX6900=y
# CONFIG_RTC_DRV_MAX8907 is not set
# CONFIG_RTC_DRV_MAX8925 is not set
CONFIG_RTC_DRV_MAX8998=y
CONFIG_RTC_DRV_MAX8997=y
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
# CONFIG_RTC_DRV_ISL12022 is not set
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PALMAS=y
# CONFIG_RTC_DRV_PCF8523 is not set
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF8583=y
# CONFIG_RTC_DRV_M41T80 is not set
CONFIG_RTC_DRV_BQ32K=y
# CONFIG_RTC_DRV_TWL4030 is not set
CONFIG_RTC_DRV_TPS80031=y
# CONFIG_RTC_DRV_RC5T583 is not set
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=y
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_DA9052=y
# CONFIG_RTC_DRV_DA9055 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
# CONFIG_RTC_DRV_V3020 is not set
CONFIG_RTC_DRV_DS2404=y
# CONFIG_RTC_DRV_WM831X is not set
CONFIG_RTC_DRV_PCF50633=y
# CONFIG_RTC_DRV_AB3100 is not set

#
# on-CPU RTC drivers
#

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV is not set
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
# CONFIG_USBIP_CORE is not set
CONFIG_W35UND=y
# CONFIG_PRISM2_USB is not set
CONFIG_ECHO=y
CONFIG_ASUS_OLED=y
# CONFIG_R8712U is not set
CONFIG_TRANZPORT=y
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#

#
# Accelerometers
#

#
# Analog to digital converters
#
# CONFIG_AD7291 is not set
CONFIG_AD7606=y
# CONFIG_AD7606_IFACE_PARALLEL is not set
CONFIG_AD799X=y
CONFIG_AD799X_RING_BUFFER=y

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=y
# CONFIG_ADT7316_I2C is not set

#
# Capacitance to digital converters
#
CONFIG_AD7150=y
CONFIG_AD7152=y
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
CONFIG_ADE7854=y
CONFIG_ADE7854_I2C=y

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
CONFIG_IIO_PERIODIC_RTC_TRIGGER=y
CONFIG_IIO_GPIO_TRIGGER=y
CONFIG_IIO_DUMMY_EVGEN=y
# CONFIG_IIO_SIMPLE_DUMMY is not set
CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
# CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set
CONFIG_ZSMALLOC=y
# CONFIG_WLAGS49_H2 is not set
CONFIG_WLAGS49_H25=y
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_CXT1E1 is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_SBE_2T3E3 is not set
# CONFIG_BCM_WIMAX is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
# CONFIG_ANDROID_LOGGER is not set
# CONFIG_ANDROID_TIMED_OUTPUT is not set
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
CONFIG_ANDROID_INTF_ALARM_DEV=y
CONFIG_SYNC=y
# CONFIG_SW_SYNC is not set
# CONFIG_USB_WPAN_HCD is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_NET_VENDOR_SILICOM is not set
CONFIG_CED1401=y
CONFIG_DGRP=y
CONFIG_USB_DWC2=y
CONFIG_USB_DWC2_DEBUG=y
# CONFIG_USB_DWC2_VERBOSE is not set
CONFIG_USB_DWC2_TRACK_MISSED_SOFS=y
CONFIG_USB_DWC2_DEBUG_PERIODIC=y
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
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
# CONFIG_IIO_ST_ACCEL_3AXIS is not set

#
# Analog to digital converters
#
CONFIG_LP8788_ADC=y
# CONFIG_MAX1363 is not set
# CONFIG_TI_ADC081C is not set
CONFIG_TI_AM335X_ADC=y
CONFIG_VIPERBOARD_ADC=y

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
CONFIG_AD5380=y
# CONFIG_AD5446 is not set
CONFIG_MAX517=y
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
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
# CONFIG_ITG3200 is not set

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=y

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
# CONFIG_SENSORS_LM3533 is not set
CONFIG_SENSORS_TSL2563=y
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
CONFIG_AK8975=y
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y

#
# Triggers - standalone
#
CONFIG_IIO_SYSFS_TRIGGER=y
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_FIRMWARE_MEMMAP is not set
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_DMIID is not set
# CONFIG_DMI_SYSFS is not set
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
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_DEBUG is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NCP_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
# CONFIG_NLS_UTF8 is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_DEBUG_ON=y
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_WRITECOUNT=y
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_LIST=y
# CONFIG_TEST_LIST_SORT is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_RCU_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST_RUNNABLE=y
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
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
# CONFIG_FUNCTION_GRAPH_TRACER is not set
CONFIG_IRQSOFF_TRACER=y
# CONFIG_SCHED_TRACER is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_BRANCH_TRACER is not set
# CONFIG_STACK_TRACER is not set
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_EVENT_TRACE_TEST_SYSCALLS=y
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
# CONFIG_EARLY_PRINTK is not set
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
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
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_AUDIT=y
# CONFIG_IMA_APPRAISE is not set
CONFIG_EVM=y
CONFIG_EVM_HMAC_VERSION=2
CONFIG_DEFAULT_SECURITY_APPARMOR=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="apparmor"
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
CONFIG_CRYPTO_ABLK_HELPER_X86=y
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
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
# CONFIG_CRYPTO_CRCT10DIF_PCLMUL is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
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
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
CONFIG_KVM_AMD=y
# CONFIG_KVM_MMU_AUDIT is not set
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
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
# CONFIG_XZ_DEC_ARMTHUMB is not set
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
# CONFIG_ATA_SFF is not set
# CONFIG_DRM_TTM is not set
# CONFIG_ISDN_DRV_LOOP is not set
# CONFIG_PCI_ATS is not set

--2fHTh5uZTiUOsy+g--
