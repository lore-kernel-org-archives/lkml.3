Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab3JSM2m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 08:28:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:15160 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab3JSM2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 08:28:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,528,1378882800"; 
   d="log'?scan'208";a="413700712"
Date: Sat, 19 Oct 2013 08:51:29 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: [sched] WARNING: CPU: 0 PID: 3166 at kernel/cpu.c:84
 put_online_cpus()
Message-ID: <20131019005129.GA5979@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit 6acce3ef84520537f8a09a12c9ddbe814a584dd2
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Fri Oct 11 14:38:20 2013 +0200

    sched: Remove get_online_cpus() usage
    
    Remove get_online_cpus() usage from the scheduler; there's 4 sites that
    use it:
    
     - sched_init_smp(); where its completely superfluous since we're in
       'early' boot and there simply cannot be any hotplugging.
    
     - sched_getaffinity(); we already take a raw spinlock to protect the
       task cpus_allowed mask, this disables preemption and therefore
       also stabilizes cpu_online_mask as that's modified using
       stop_machine. However switch to active mask for symmetry with
       sched_setaffinity()/set_cpus_allowed_ptr(). We guarantee active
       mask stability by inserting sync_rcu/sched() into _cpu_down.
    
     - sched_setaffinity(); we don't appear to need get_online_cpus()
       either, there's two sites where hotplug appears relevant:
        * cpuset_cpus_allowed(); for the !cpuset case we use possible_mask,
          for the cpuset case we hold task_lock, which is a spinlock and
          thus for mainline disables preemption (might cause pain on RT).
        * set_cpus_allowed_ptr(); Holds all scheduler locks and thus has
          preemption properly disabled; also it already deals with hotplug
          races explicitly where it releases them.
    
     - migrate_swap(); we can make stop_two_cpus() do the heavy lifting for
       us with a little trickery. By adding a sync_sched/rcu() after the
       CPU_DOWN_PREPARE notifier we can provide preempt/rcu guarantees for
       cpu_active_mask. Use these to validate that both our cpus are active
       when queueing the stop work before we queue the stop_machine works
       for take_cpu_down().
    
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
    Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
    Cc: Mel Gorman <mgorman@suse.de>
    Cc: Rik van Riel <riel@redhat.com>
    Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    Cc: Andrea Arcangeli <aarcange@redhat.com>
    Cc: Johannes Weiner <hannes@cmpxchg.org>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: Steven Rostedt <rostedt@goodmis.org>
    Cc: Oleg Nesterov <oleg@redhat.com>
    Link: http://lkml.kernel.org/r/20131011123820.GV3081@twins.programming.kicks-ass.net
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

[3165] Watchdog is alive
[3159] Started watchdog thread 3165
[   58.695502] ------------[ cut here ]------------
[   58.697835] WARNING: CPU: 0 PID: 3166 at kernel/cpu.c:84 put_online_cpus+0x43/0x70()
[   58.702423] Modules linked in:
[   58.704404] CPU: 0 PID: 3166 Comm: trinity-child0 Not tainted 3.12.0-rc5-01882-gf3db366 #1172
[   58.708530] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   58.710992]  0000000000000000 ffff88000acfbe50 ffffffff81a24643 0000000000000000
[   58.715410]  ffff88000acfbe88 ffffffff810c3e6b ffffffff810c3fef 0000000000000000
[   58.719826]  0000000000000000 0000000000006ee0 0000000000000ffc ffff88000acfbe98
[   58.724348] Call Trace:
[   58.726190]  [<ffffffff81a24643>] dump_stack+0x4d/0x66
[   58.728531]  [<ffffffff810c3e6b>] warn_slowpath_common+0x7f/0x98
[   58.731069]  [<ffffffff810c3fef>] ? put_online_cpus+0x43/0x70
[   58.733664]  [<ffffffff810c3f32>] warn_slowpath_null+0x1a/0x1c
[   58.736258]  [<ffffffff810c3fef>] put_online_cpus+0x43/0x70
[   58.738686]  [<ffffffff810efd59>] sched_setaffinity+0x7d/0x1f9
[   58.741210]  [<ffffffff810efce1>] ? sched_setaffinity+0x5/0x1f9
[   58.743775]  [<ffffffff81a2f724>] ? _raw_spin_unlock_irq+0x2c/0x3e
[   58.746417]  [<ffffffff810c7012>] ? do_setitimer+0x194/0x1f5
[   58.748899]  [<ffffffff810eff37>] SyS_sched_setaffinity+0x62/0x71
[   58.751481]  [<ffffffff81a373a9>] system_call_fastpath+0x16/0x1b
[   58.754070] ---[ end trace 034818a1f6f06868 ]---
[   58.757521] ------------[ cut here ]------------

git bisect start f3db36699379159b761cdbc093347822a633c616 2fe80d3bbf1c8bd9efc5b8154207c8dd104e7306 --
git bisect good 0f2a02d75d0f37f1624585c50c3250b6d096f050  # 12:02     21+     19  kvm tools: fix function name
git bisect good ee6946e6810792f208662507055e6f9c32f42898  # 13:47     21+      0  x86: perf -- Allow perf watchdog to use perfmon bit for msr index computation
git bisect good 2eb3090631e1f3c5920e27e0a51ed876e88fe871  # 15:07     21+      0  Merge branch 'linus'
git bisect good bf2575c121ca11247ef07fd02b43f7430834f7b1  # 15:58     21+      0  perf trace: Add summary option to dump syscall statistics
git bisect good d6099aeb4a9aad5e7ab1c72eb119ebd52dee0d52  # 16:36     21+      0  Merge branch 'fixes' of git://git.linaro.org/people/rmk/linux-arm
git bisect good 54d54a7146ce2718738f97374d714dd6f5e103b0  # 16:56     21+      0  Merge branch 'x86/urgent'
git bisect good ed8ada393388ef7ccfcfb3a88d8718f7df4b3165  # 17:44     21+      0  Merge tag 'rdma-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband
git bisect good f773934fb39d11608b8285db621ae65ca1465bf3  # 18:09     21+      0  Merge branch 'perf/core'
git bisect  bad c2d816443ef305aba8eaf0bf368f4d3d87494f06  # 18:09      0-      9  sched/wait: Introduce prepare_to_wait_event()
git bisect good 746023159c40c523b08a3bc3d213dac212385895  # 18:45     21+      1  sched: Fix race in migrate_swap_stop()
git bisect  bad 8922915b38cd8b72f8e5af614b95be71d1d299d4  # 19:00      0-      1  sched/wait: Add ___wait_cond_timeout() to wait_event*_timeout() too
git bisect  bad 6acce3ef84520537f8a09a12c9ddbe814a584dd2  # 19:13      0-      1  sched: Remove get_online_cpus() usage
git bisect good 746023159c40c523b08a3bc3d213dac212385895  # 20:01     63+      3  sched: Fix race in migrate_swap_stop()
git bisect  bad f3db36699379159b761cdbc093347822a633c616  # 20:01      0-     16  Merge branch 'sched/core'
git bisect good 8df5f2f7724ba6566e92c87cf2354735aac4b9ed  # 20:53     63+     11  Revert "sched: Remove get_online_cpus() usage"
git bisect good 04919afb85c8f007b7326c4da5eb61c52e91b9c7  # 21:36     63+      3  Merge branch 'for-linus' of git://git.samba.org/sfrench/cifs-2.6
git bisect good a0cf1abc25ac197dd97b857c0f6341066a8cb1cf  # 22:29     63+      6  Add linux-next specific files for 20130927
git bisect  bad 574c653ee9062a8fcc619e7ec83a36ba2dfc5a26  # 22:43      0-      2  Merge branch 'core/rcu'

Thanks,
Fengguang

--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-roam-31:20131018034405:x86_64-lkp:3.12.0-rc5-01882-gf3db366:1172"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-rc5-01882-gf3db366 (kbuild@inn) (gcc ve=
rsion 4.8.1 (Debian 4.8.1-8) ) #1172 SMP Fri Oct 18 03:40:41 CST 2013
[    0.000000] Command line: hung_task_panic=3D1 rcutree.rcu_cpu_stall_time=
out=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug d=
ynamic_printk sysrq_always_enabled panic=3D10 load_ramdisk=3D2 prompt_ramdi=
sk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal ip=3D::::yocto-ro=
am-31::dhcp nfsroot=3D192.168.1.1:/nfsroot/wfg,tcp,v3,nocto,actimeo=3D600,n=
olock,rsize=3D524288,wsize=3D524288 rw link=3D/kernel-tests/run-queue/kvm/x=
86_64-lkp/tip:master/.vmlinuz-f3db36699379159b761cdbc093347822a633c616-2013=
1018034115-9-roam branch=3Dtip/master BOOT_IMAGE=3D/kernel/x86_64-lkp/f3db3=
6699379159b761cdbc093347822a633c616/vmlinuz-3.12.0-rc5-01882-gf3db366
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at =
[ffff8800000fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02fe1000, 0x02fe1fff] PGTABLE
[    0.000000] BRK [0x02fe2000, 0x02fe2fff] PGTABLE
[    0.000000] BRK [0x02fe3000, 0x02fe3fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0fc00000-0x0fdfffff]
[    0.000000]  [mem 0x0fc00000-0x0fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0fbfffff]
[    0.000000]  [mem 0x0c000000-0x0fbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0fe00000-0x0fffdfff]
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x02fe4000, 0x02fe4fff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 1044704(99%)
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
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f7000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0f7f9000-0x0f7fdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:f7f5001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000ea0000=
0-ffff88000edfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 960 pages used for memmap
[    0.000000]   DMA32 zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f7000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f6000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:2 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff88000e600000 s1920832 r8=
192 d20672 u2097152
[    0.000000] pcpu-alloc: s1920832 r8192 d20672 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:f7f5001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr e60d240
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 64391
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10 load_ramdisk=3D2 promp=
t_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal ip=3D::::y=
octo-roam-31::dhcp nfsroot=3D192.168.1.1:/nfsroot/wfg,tcp,v3,nocto,actimeo=
=3D600,nolock,rsize=3D524288,wsize=3D524288 rw link=3D/kernel-tests/run-que=
ue/kvm/x86_64-lkp/tip:master/.vmlinuz-f3db36699379159b761cdbc093347822a633c=
616-20131018034115-9-roam branch=3Dtip/master BOOT_IMAGE=3D/kernel/x86_64-l=
kp/f3db36699379159b761cdbc093347822a633c616/vmlinuz-3.12.0-rc5-01882-gf3db3=
66
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 212124K/261744K available (10482K kernel code, 1387K=
 rwdata, 5340K rodata, 3188K init, 9584K bss, 49620K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000] NR_IRQS:16640 nr_irqs:512 16
[    0.000000] Console: colour VGA+ 80x25
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
[    0.000000]  memory used by lock dependency info: 6335 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] allocated 1048576 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2893.000 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5786.00 Bogo=
MIPS (lpj=3D11572000)
[    0.010169] pid_max: default: 32768 minimum: 301
[    0.012164] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.014542] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.016059] Mount-cache hash table entries: 256
[    0.017995] Initializing cgroup subsys memory
[    0.019466] Initializing cgroup subsys blkio
[    0.020013] Initializing cgroup subsys perf_event
[    0.021842] Initializing cgroup subsys hugetlb
[    0.024150] mce: CPU supports 10 MCE banks
[    0.025929] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.025929] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.025929] tlb_flushall_shift: 6
[    0.028141] Freeing SMP alternatives memory: 40K (ffffffff82679000 - fff=
fffff82683000)
[    0.040074] ACPI: Core revision 20130725
[    0.044066] ACPI: All ACPI Tables successfully acquired
[    0.046045] ftrace: allocating 39547 entries in 155 pages
[    0.060243] Getting VERSION: 50014
[    0.061265] Getting VERSION: 50014
[    0.063148] Getting ID: 0
[    0.064023] Getting ID: ff000000
[    0.065842] Getting LVT0: 8700
[    0.068012] Getting LVT1: 8400
[    0.069401] enabled ExtINT on CPU#0
[    0.073166] ENABLING IO-APIC IRQs
[    0.074555] init IO_APIC IRQs
[    0.075852]  apic 0 pin 0 not connected
[    0.076024] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.080034] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.082907] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.084030] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.088036] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.090863] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.092032] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.096030] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.100030] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.102844] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.104033] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.108030] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.112030] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.114890] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.116035] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.120029]  apic 0 pin 16 not connected
[    0.121476]  apic 0 pin 17 not connected
[    0.122957]  apic 0 pin 18 not connected
[    0.124006]  apic 0 pin 19 not connected
[    0.125457]  apic 0 pin 20 not connected
[    0.128005]  apic 0 pin 21 not connected
[    0.129460]  apic 0 pin 22 not connected
[    0.130903]  apic 0 pin 23 not connected
[    0.132177] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.134528] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.139184] Using local APIC timer interrupts.
[    0.139184] calibrating APIC timer ...
[    0.144000] ... lapic delta =3D 6249410
[    0.144000] ... PM-Timer delta =3D 357943
[    0.144000] ... PM-Timer result ok
[    0.144000] ..... delta 6249410
[    0.144000] ..... mult: 268410115
[    0.144000] ..... calibration result: 3999622
[    0.144000] ..... CPU clock speed is 2892.3007 MHz.
[    0.144000] ..... host bus clock speed is 999.3622 MHz.
[    0.144092] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.148999] x86: Booting SMP configuration:
[    0.150321] .... node  #0, CPUs:      #1
[    0.008000] kvm-clock: cpu 1, msr 0:f7f5041, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1

[    0.168148] x86: Booted up 1 node, 2 CPUs
[    0.168087] KVM setup async PF for cpu 1
[    0.168087] kvm-stealtime: cpu 1, msr e80d240
[    0.172005] smpboot: Total of 2 processors activated (11572.00 BogoMIPS)
[    0.176445] CPU0 attaching sched-domain:
[    0.177398]  domain 0: span 0-1 level CPU
[    0.178432]   groups: 0 1
[    0.179481] CPU1 attaching sched-domain:
[    0.180026]  domain 0: span 0-1 level CPU
[    0.181061]   groups: 1 0
[    0.182240] devtmpfs: initialized
[    0.189443] xor: measuring software checksum speed
[    0.228008]    prefetch64-sse: 11786.000 MB/sec
[    0.268008]    generic_sse: 11021.000 MB/sec
[    0.269021] xor: using function: prefetch64-sse (11786.000 MB/sec)
[    0.270253] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.271728] NET: Registered protocol family 16
[    0.272551] cpuidle: using governor ladder
[    0.273055] cpuidle: using governor menu
[    0.276498] ACPI: bus type PCI registered
[    0.277465] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.278810] PCI: Using configuration type 1 for base access
[    0.332167] bio: create slab <bio-0> at 0
[    0.400017] raid6: sse2x1    6703 MB/s
[    0.468010] raid6: sse2x2    7062 MB/s
[    0.536009] raid6: sse2x4    8335 MB/s
[    0.537198] raid6: using algorithm sse2x4 (8335 MB/s)
[    0.538531] raid6: using intx1 recovery algorithm
[    0.539902] ACPI: Added _OSI(Module Device)
[    0.540007] ACPI: Added _OSI(Processor Device)
[    0.541252] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.542436] ACPI: Added _OSI(Processor Aggregator Device)
[    0.546129] ACPI: EC: Look up EC in DSDT
[    0.553087] ACPI: Interpreter enabled
[    0.554264] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20130725/hwxface-571)
[    0.556910] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20130725/hwxface-571)
[    0.559609] ACPI: (supports S0 S3 S4 S5)
[    0.560004] ACPI: Using IOAPIC for interrupt routing
[    0.561500] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.565049] ACPI: No dock devices found.
[    0.584470] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.588057] acpi PNP0A03:00: ACPI _OSC support notification failed, disa=
bling PCIe ASPM
[    0.590792] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.592399] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.596447] acpiphp: Slot [3] registered
[    0.600216] acpiphp: Slot [4] registered
[    0.601808] acpiphp: Slot [5] registered
[    0.604178] acpiphp: Slot [6] registered
[    0.605741] acpiphp: Slot [7] registered
[    0.608149] acpiphp: Slot [8] registered
[    0.609773] acpiphp: Slot [9] registered
[    0.612104] acpiphp: Slot [10] registered
[    0.613871] acpiphp: Slot [11] registered
[    0.613871] acpiphp: Slot [12] registered
[    0.616928] acpiphp: Slot [13] registered
[    0.620232] acpiphp: Slot [14] registered
[    0.621741] acpiphp: Slot [15] registered
[    0.624207] acpiphp: Slot [16] registered
[    0.625692] acpiphp: Slot [17] registered
[    0.628071] acpiphp: Slot [18] registered
[    0.629676] acpiphp: Slot [19] registered
[    0.636087] acpiphp: Slot [20] registered
[    0.637689] acpiphp: Slot [21] registered
[    0.640178] acpiphp: Slot [22] registered
[    0.641686] acpiphp: Slot [23] registered
[    0.641745] acpiphp: Slot [24] registered
[    0.644181] acpiphp: Slot [25] registered
[    0.645808] acpiphp: Slot [26] registered
[    0.648180] acpiphp: Slot [27] registered
[    0.652180] acpiphp: Slot [28] registered
[    0.653783] acpiphp: Slot [29] registered
[    0.656097] acpiphp: Slot [30] registered
[    0.657723] acpiphp: Slot [31] registered
[    0.657723] PCI host bridge to bus 0000:00
[    0.660022] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.661840] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.664007] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.665976] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.668007] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.670163] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.672859] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.677089] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.685361] pci 0000:00:01.1: reg 0x20: [io  0xc1e0-0xc1ef]
[    0.689415] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.692263] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.695119] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.696535] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.702136] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.705980] pci 0000:00:02.0: reg 0x14: [mem 0xfebe0000-0xfebe0fff]
[    0.716975] pci 0000:00:02.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.720536] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.723015] pci 0000:00:03.0: reg 0x10: [io  0xc1c0-0xc1df]
[    0.724028] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    0.732759] pci 0000:00:03.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.736088] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.741797] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.745691] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.756866] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.759386] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.762067] pci 0000:00:05.0: reg 0x10: [io  0xc040-0xc07f]
[    0.765720] pci 0000:00:05.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[    0.778434] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.781781] pci 0000:00:06.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.785814] pci 0000:00:06.0: reg 0x14: [mem 0xfebe3000-0xfebe3fff]
[    0.798497] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.801844] pci 0000:00:07.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.805793] pci 0000:00:07.0: reg 0x14: [mem 0xfebe4000-0xfebe4fff]
[    0.817609] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.820910] pci 0000:00:08.0: reg 0x10: [io  0xc100-0xc13f]
[    0.824929] pci 0000:00:08.0: reg 0x14: [mem 0xfebe5000-0xfebe5fff]
[    0.836735] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.840014] pci 0000:00:09.0: reg 0x10: [io  0xc140-0xc17f]
[    0.844007] pci 0000:00:09.0: reg 0x14: [mem 0xfebe6000-0xfebe6fff]
[    0.855383] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.856013] pci 0000:00:0a.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.860024] pci 0000:00:0a.0: reg 0x14: [mem 0xfebe7000-0xfebe7fff]
[    0.872194] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    0.876921] pci 0000:00:0b.0: reg 0x10: [mem 0xfebe8000-0xfebe800f]
[    0.885563] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.888243] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.890804] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.893632] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.896128] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.898896] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.900035] ACPI: \_SB_.PCI0: notify handler is installed
[    0.901923] Found 1 acpi root devices
[    0.904302] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.908023] vgaarb: loaded
[    0.909244] vgaarb: bridge control possible 0000:00:02.0
[    0.912207] SCSI subsystem initialized
[    0.913605] libata version 3.00 loaded.
[    0.916171] ACPI: bus type USB registered
[    0.917653] usbcore: registered new interface driver usbfs
[    0.920132] usbcore: registered new interface driver hub
[    0.921869] usbcore: registered new device driver usb
[    0.924222] pps_core: LinuxPPS API ver. 1 registered
[    0.925646] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.928176] PTP clock support registered
[    0.932106] EDAC MC: Ver: 3.0.0
[    0.933792] PCI: Using ACPI for IRQ routing
[    0.936021] PCI: pci_cache_line_size set to 64 bytes
[    0.937983] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.937983] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.940338] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.942222] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.944029] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.952100] Switched to clocksource kvm-clock
[    0.994950] pnp: PnP ACPI init
[    0.996542] ACPI: bus type PNP registered
[    0.998273] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    1.001484] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.003715] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    1.007153] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.009408] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    1.012891] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.015130] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    1.018353] pnp 00:03: [dma 2]
[    1.020048] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.022329] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    1.026150] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.033656] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    1.039826] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.042651] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.045064] pnp: PnP ACPI: found 7 devices
[    1.046675] ACPI: bus type PNP unregistered
[    1.086938] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.088610] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.090485] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.092925] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.095209] NET: Registered protocol family 2
[    1.096744] TCP established hash table entries: 2048 (order: 3, 32768 by=
tes)
[    1.098450] TCP bind hash table entries: 2048 (order: 5, 163840 bytes)
[    1.100041] TCP: Hash tables configured (established 2048 bind 2048)
[    1.101869] TCP: reno registered
[    1.103359] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    1.105562] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    1.107457] NET: Registered protocol family 1
[    1.109357] RPC: Registered named UNIX socket transport module.
[    1.111291] RPC: Registered udp transport module.
[    1.113004] RPC: Registered tcp transport module.
[    1.114670] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.116699] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.118620] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.120538] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.122311] pci 0000:00:02.0: Boot video device
[    1.123802] PCI: CLS 0 bytes, default 64
[    1.137573] DMA-API: preallocated 65536 debug entries
[    1.138695] DMA-API: debugging enabled by kernel config
[    1.140305] kvm: no hardware support
[    1.141368] Machine check injector initialized
[    1.142692] Scanning for low memory corruption every 60 seconds
[    1.144221] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    1.146214] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    1.148340] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    1.151892] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.153353] PCLMULQDQ-NI instructions are not detected.
[    1.154625] AVX or AES-NI instructions are not detected.
[    1.155744] AVX instructions are not detected.
[    1.156781] AVX instructions are not detected.
[    1.157794] AVX instructions are not detected.
[    1.159002] AVX instructions are not detected.
[    1.199189] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.212367] VFS: Disk quotas dquot_6.5.2
[    1.213543] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.218903] NFS: Registering the id_resolver key type
[    1.220065] Key type id_resolver registered
[    1.221049] Key type id_legacy registered
[    1.222140] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.224687] ROMFS MTD (C) 2007 Red Hat, Inc.
[    1.226681] fuse init (API version 7.22)
[    1.228579] SGI XFS with ACLs, security attributes, realtime, large bloc=
k/inode numbers, debug enabled
[    1.234968] bio: create slab <bio-1> at 1
[    1.237321] Btrfs loaded
[    1.238121] msgmni has been set to 414
[    1.246461] NET: Registered protocol family 38
[    1.248058] Key type asymmetric registered
[    1.249437] Asymmetric key parser 'x509' registered
[    1.251212] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    1.253399] io scheduler noop registered
[    1.254477] io scheduler deadline registered
[    1.255913] io scheduler cfq registered (default)
[    1.258247] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.260246] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.262597] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    1.264606] ACPI: Power Button [PWRF]
[    1.266804] GHES: HEST is not enabled!
[    1.275425] ERST DBG: ERST support is disabled.
[    1.277768] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    1.279518] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:3)
[    1.283003] virtio-pci 0000:00:03.0: setting latency timer to 64
[    1.286147] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    1.288121] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:3)
[    1.291550] virtio-pci 0000:00:05.0: setting latency timer to 64
[    1.295255] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    1.297731] virtio-pci 0000:00:06.0: setting latency timer to 64
[    1.302582] virtio-pci 0000:00:07.0: setting latency timer to 64
[    1.306545] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    1.310412] virtio-pci 0000:00:08.0: setting latency timer to 64
[    1.317791] virtio-pci 0000:00:09.0: setting latency timer to 64
[    1.324230] virtio-pci 0000:00:0a.0: setting latency timer to 64
[    1.329097] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.356668] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    1.363307] Non-volatile memory driver v1.3
[    1.375359] brd: module loaded
[    1.381327] loop: module loaded
[    1.382841] virtio-pci 0000:00:05.0: irq 40 for MSI/MSI-X
[    1.384493] virtio-pci 0000:00:05.0: irq 41 for MSI/MSI-X
[    1.387797]  vda: unknown partition table
[    1.393993] virtio-pci 0000:00:06.0: irq 42 for MSI/MSI-X
[    1.395786] virtio-pci 0000:00:06.0: irq 43 for MSI/MSI-X
[    1.398713]  vdb: unknown partition table
[    1.402982] virtio-pci 0000:00:07.0: irq 44 for MSI/MSI-X
[    1.404848] virtio-pci 0000:00:07.0: irq 45 for MSI/MSI-X
[    1.407632]  vdc: unknown partition table
[    1.412110] virtio-pci 0000:00:08.0: irq 46 for MSI/MSI-X
[    1.413325] virtio-pci 0000:00:08.0: irq 47 for MSI/MSI-X
[    1.415707]  vdd: unknown partition table
[    1.420089] virtio-pci 0000:00:09.0: irq 48 for MSI/MSI-X
[    1.422094] virtio-pci 0000:00:09.0: irq 49 for MSI/MSI-X
[    1.424573]  vde: unknown partition table
[    1.427627] virtio-pci 0000:00:0a.0: irq 50 for MSI/MSI-X
[    1.429243] virtio-pci 0000:00:0a.0: irq 51 for MSI/MSI-X
[    1.431269]  vdf: unknown partition table
[    1.434476] lkdtm: No crash points registered, enable through debugfs
[    1.436629] Loading iSCSI transport class v2.0-870.
[    1.439783] Adaptec aacraid driver 1.2-0[30200]-ms
[    1.441975] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    1.444883] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 8.06.00.08-k.
[    1.448759] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 ES=
T 2006)
[    1.451768] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 20=
06)
[    1.453744] megasas: 06.700.06.00-rc1 Sat. Aug. 31 17:00:00 PDT 2013
[    1.455453] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    1.456857] RocketRAID 3xxx/4xxx Controller driver v1.8
[    1.463284] scsi_debug: host protection
[    1.464330] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[    1.466830] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[    1.469132] ata_piix 0000:00:01.1: version 2.13
[    1.472209] ata_piix 0000:00:01.1: setting latency timer to 64
[    1.474665] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.477079] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.=
00 MiB)
[    1.482344] scsi1 : ata_piix
[    1.483663] scsi2 : ata_piix
[    1.484070] sd 0:0:0:0: [sda] Write Protect is off
[    1.484074] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    1.487511] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc1e0 irq 14
[    1.488903] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc1e8 irq 15
[    1.492118] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[    1.497390] virtio-pci 0000:00:03.0: irq 52 for MSI/MSI-X
[    1.499706] virtio-pci 0000:00:03.0: irq 53 for MSI/MSI-X
[    1.502126] virtio-pci 0000:00:03.0: irq 54 for MSI/MSI-X
[    1.507425] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.=
de
[    1.510545] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    1.512885] Copyright (c) 2007 Atheros Corporation.
[    1.515994] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[    1.519109] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.=
com>
[    1.519109]   http://www.scyld.com/network/drivers.html
[    1.524763] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-2=
9)
[    1.527851] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    1.530389] e100: Copyright(c) 1999-2006 Intel Corporation
[    1.532875]  sda: unknown partition table
[    1.536163] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-=
NAPI
[    1.539186] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    1.545621] e1000 0000:00:04.0: setting latency timer to 64
[    1.564179] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.644939] ata2.01: NODEV after polling detection
[    1.647003] ata2.00: ATAPI: QEMU DVD-ROM, 1.5.0, max UDMA/100
[    1.649455] ata2.00: configured for MWDMA2
[    1.651845] scsi 2:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     1.=
5. PQ: 0 ANSI: 5
[    1.655637] scsi 2:0:0:0: Attached scsi generic sg1 type 5
[    1.900961] e1000 0000:00:04.0 eth1: (PCI:33MHz:32-bit) 52:54:00:12:34:57
[    1.903636] e1000 0000:00:04.0 eth1: Intel(R) PRO/1000 Network Connection
[    1.905800] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    1.907457] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    1.909397] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.=
5-k
[    1.911249] igb: Copyright (c) 2007-2013 Intel Corporation.
[    1.913154] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - vers=
ion 3.15.1-k
[    1.915703] ixgbe: Copyright (c) 1999-2013 Intel Corporation.
[    1.917637] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2=
-NAPI
[    1.919521] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    1.922144] sky2: driver version 1.30
[    1.925368] usbcore: registered new interface driver catc
[    1.927154] usbcore: registered new interface driver kaweth
[    1.928812] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[    1.931725] usbcore: registered new interface driver pegasus
[    1.933626] usbcore: registered new interface driver rtl8150
[    1.935459] usbcore: registered new interface driver asix
[    1.937278] usbcore: registered new interface driver ax88179_178a
[    1.939180] usbcore: registered new interface driver cdc_ether
[    1.941120] usbcore: registered new interface driver r815x
[    1.942951] usbcore: registered new interface driver cdc_eem
[    1.944818] usbcore: registered new interface driver dm9601
[    1.946630] usbcore: registered new interface driver smsc75xx
[    1.948538] usbcore: registered new interface driver smsc95xx
[    1.950381] usbcore: registered new interface driver gl620a
[    1.952250] usbcore: registered new interface driver net1080
[    1.954082] usbcore: registered new interface driver plusb
[    1.955896] usbcore: registered new interface driver rndis_host
[    1.957832] usbcore: registered new interface driver cdc_subset
[    1.959702] usbcore: registered new interface driver zaurus
[    1.961571] usbcore: registered new interface driver MOSCHIP usb-etherne=
t driver
[    1.964343] usbcore: registered new interface driver int51x1
[    1.966166] usbcore: registered new interface driver ipheth
[    1.967978] usbcore: registered new interface driver sierra_net
[    1.969920] usbcore: registered new interface driver cdc_ncm
[    1.971548] Fusion MPT base driver 3.04.20
[    1.972994] Copyright (c) 1999-2008 LSI Corporation
[    1.974502] Fusion MPT SPI Host driver 3.04.20
[    1.976160] Fusion MPT FC Host driver 3.04.20
[    1.977688] Fusion MPT SAS Host driver 3.04.20
[    1.979410] Fusion MPT misc device (ioctl) driver 3.04.20
[    1.980860] mptctl: Registered with Fusion MPT base driver
[    1.982131] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[    1.983812] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.985524] ehci-pci: EHCI PCI platform driver
[    1.987414] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.989463] ohci-pci: OHCI PCI platform driver
[    1.991401] uhci_hcd: USB Universal Host Controller Interface driver
[    1.993953] usbcore: registered new interface driver usb-storage
[    1.996345] usbcore: registered new interface driver ums-alauda
[    1.998298] usbcore: registered new interface driver ums-datafab
[    2.000439] usbcore: registered new interface driver ums-freecom
[    2.002588] usbcore: registered new interface driver ums-isd200
[    2.004797] usbcore: registered new interface driver ums-jumpshot
[    2.007024] usbcore: registered new interface driver ums-sddr09
[    2.009297] usbcore: registered new interface driver ums-sddr55
[    2.011994] usbcore: registered new interface driver ums-usbat
[    2.014210] usbcore: registered new interface driver usbtest
[    2.016615] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    2.020170] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.021311] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.023084] mousedev: PS/2 mouse device common for all mice
[    2.027236] rtc_cmos 00:00: RTC can wake from S4
[    2.029847] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    2.034166] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    2.036275] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    2.038692] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    2.041515] i6300esb: initialized (0xffffc900008f8000). heartbeat=3D30 s=
ec (nowayout=3D0)
[    2.044676] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    2.046106] iTCO_vendor_support: vendor-support=3D0
[    2.047344] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    2.050287] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    2.053804] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D0)
[    2.057604] md: linear personality registered for level -1
[    2.059345] md: raid0 personality registered for level 0
[    2.061072] md: raid1 personality registered for level 1
[    2.063027] md: raid10 personality registered for level 10
[    2.065450] md: raid6 personality registered for level 6
[    2.078861] md: raid5 personality registered for level 5
[    2.080659] md: raid4 personality registered for level 4
[    2.082218] md: multipath personality registered for level -4
[    2.083633] md: faulty personality registered for level -5
[    2.086218] device-mapper: ioctl: 4.26.0-ioctl (2013-08-15) initialised:=
 dm-devel@redhat.com
[    2.089404] device-mapper: multipath: version 1.5.1 loaded
[    2.091238] device-mapper: multipath round-robin: version 1.0.0 loaded
[    2.093804] device-mapper: cache-policy-mq: version 1.0.0 loaded
[    2.096211] device-mapper: cache cleaner: version 1.0.0 loaded
[    2.098355] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    2.104582] usbcore: registered new interface driver usbhid
[    2.106574] usbhid: USB HID core driver
[    2.108705] oprofile: using NMI interrupt.
[    2.110601] TCP: bic registered
[    2.111743] Initializing XFRM netlink socket
[    2.119304] NET: Registered protocol family 10
[    2.121414] sit: IPv6 over IPv4 tunneling driver
[    2.125156] NET: Registered protocol family 17
[    2.126897] 8021q: 802.1Q VLAN Support v1.8
[    2.128660] sctp: Hash tables configured (established 819 bind 819)
[    2.130959] Key type dns_resolver registered
[    2.136089]=20
[    2.136089] printing PIC contents
[    2.138926] ... PIC  IMR: ffff
[    2.140183] tsc: Refined TSC clocksource calibration: 2892.985 MHz
[    2.140011] ... PIC  IRR: 9113
[    2.144994] ... PIC  ISR: 0000
[    2.146362] ... PIC ELCR: 0c00
[    2.148189] printing local APIC contents on CPU#0/0:
[    2.149844] ... APIC ID:      00000000 (0)
[    2.151291] ... APIC VERSION: 00050014
[    2.152178] ... APIC TASKPRI: 00000000 (00)
[    2.152178] ... APIC PROCPRI: 00000000
[    2.152178] ... APIC LDR: 01000000
[    2.152178] ... APIC DFR: ffffffff
[    2.152178] ... APIC SPIV: 000001ff
[    2.152178] ... APIC ISR field:
[    2.152178] 000000000000000000000000000000000000000000000000000000000000=
0000
[    2.152178] ... APIC TMR field:
[    2.152178] 000000000200000000000000000000000000000000000000000000000000=
0000
[    2.152178] ... APIC IRR field:
[    2.152178] 000000000000000000000000000000000000000000000000000000000000=
8000
[    2.152178] ... APIC ESR: 00000000
[    2.152178] ... APIC ICR: 000008fd
[    2.152178] ... APIC ICR2: 02000000
[    2.152178] ... APIC LVTT: 000000ef
[    2.152178] ... APIC LVTPC: 00010000
[    2.152178] ... APIC LVT0: 00010700
[    2.152178] ... APIC LVT1: 00000400
[    2.152178] ... APIC LVTERR: 000000fe
[    2.152178] ... APIC TMICT: 0003c8ac
[    2.152178] ... APIC TMCCT: 00000000
[    2.152178] ... APIC TDCR: 00000003
[    2.152178]=20
[    2.188633] number of MP IRQ sources: 15.
[    2.190209] number of IO-APIC #0 registers: 24.
[    2.191884] testing the IO APIC.......................
[    2.193696] IO APIC #0......
[    2.195012] .... register #00: 00000000
[    2.196467] .......    : physical APIC id: 00
[    2.198082] .......    : Delivery Type: 0
[    2.199539] .......    : LTS          : 0
[    2.201108] .... register #01: 00170011
[    2.202554] .......     : max redirection entries: 17
[    2.204299] .......     : PRQ implemented: 0
[    2.205813] .......     : IO APIC version: 11
[    2.207378] .... register #02: 00000000
[    2.208856] .......     : arbitration: 00
[    2.210322] .... IRQ redirection table:
[    2.211862] 1    0    0   0   0    0    0    00
[    2.213458] 0    0    0   0   0    1    1    31
[    2.215099] 0    0    0   0   0    1    1    30
[    2.216681] 0    0    0   0   0    1    1    33
[    2.218318] 1    0    0   0   0    1    1    34
[    2.219892] 1    1    0   0   0    1    1    35
[    2.221566] 0    0    0   0   0    1    1    36
[    2.223157] 0    0    0   0   0    1    1    37
[    2.224825] 0    0    0   0   0    1    1    38
[    2.226386] 0    1    0   0   0    1    1    39
[    2.228051] 1    1    0   0   0    1    1    3A
[    2.229615] 1    1    0   0   0    1    1    3B
[    2.231260] 0    0    0   0   0    1    1    3C
[    2.232896] 0    0    0   0   0    1    1    3D
[    2.234532] 0    0    0   0   0    1    1    3E
[    2.236122] 0    0    0   0   0    1    1    3F
[    2.237768] 1    0    0   0   0    0    0    00
[    2.239334] 1    0    0   0   0    0    0    00
[    2.241013] 1    0    0   0   0    0    0    00
[    2.242622] 1    0    0   0   0    0    0    00
[    2.244280] 1    0    0   0   0    0    0    00
[    2.245859] 1    0    0   0   0    0    0    00
[    2.247483] 1    0    0   0   0    0    0    00
[    2.249104] 1    0    0   0   0    0    0    00
[    2.250698] IRQ to pin mappings:
[    2.252094] IRQ0 -> 0:2
[    2.253497] IRQ1 -> 0:1
[    2.254980] IRQ3 -> 0:3
[    2.256405] IRQ4 -> 0:4
[    2.257887] IRQ5 -> 0:5
[    2.259285] IRQ6 -> 0:6
[    2.260771] IRQ7 -> 0:7
[    2.262240] IRQ8 -> 0:8
[    2.263651] IRQ9 -> 0:9
[    2.265144] IRQ10 -> 0:10
[    2.266569] IRQ11 -> 0:11
[    2.268103] IRQ12 -> 0:12
[    2.269532] IRQ13 -> 0:13
[    2.271040] IRQ14 -> 0:14
[    2.272530] IRQ15 -> 0:15
[    2.274014] .................................... done.
[    2.276558] PM: Hibernation image not present or could not be loaded.
[    2.278619] registered taskstats version 1
[    2.281833] rtc_cmos 00:00: setting system clock to 2013-10-17 19:41:32 =
UTC (1382038892)
[    2.284912] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    2.290093] 8021q: adding VLAN 0 to HW filter on device eth0
[    2.303208] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[    2.306790] 8021q: adding VLAN 0 to HW filter on device eth1
[    2.324125] Sending DHCP requests ., OK
[    2.348063] IP-Config: Got DHCP answer from 10.0.2.2, my address is 10.0=
=2E2.15
[    2.407707] IP-Config: Complete:
[    2.409210]      device=3Deth0, hwaddr=3D52:54:00:12:34:56, ipaddr=3D10.=
0.2.15, mask=3D255.255.255.0, gw=3D10.0.2.2
[    2.412516]      host=3Dyocto-roam-31, domain=3D, nis-domain=3D(none)
[    2.414396]      bootserver=3D10.0.2.2, rootserver=3D192.168.1.1, rootpa=
th=3D
[    2.415729]      nameserver0=3D10.0.2.3
[    2.683503] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input2
[    2.687647] md: Skipping autodetection of RAID arrays. (raid=3Dautodetec=
t will force)
[    2.698735] VFS: Mounted root (nfs filesystem) on device 0:13.
[    2.703257] Freeing unused kernel memory: 3188K (ffffffff8235c000 - ffff=
ffff82679000)
[    2.706221] Write protecting the kernel read-only data: 18432k
[    2.715528] Freeing unused kernel memory: 1792K (ffff880001a40000 - ffff=
880001c00000)
[    2.721323] Freeing unused kernel memory: 804K (ffff880002137000 - ffff8=
80002200000)
[   41.461259] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recov=
ery directory
[   41.466335] NFSD: starting 90-second grace period (net ffffffff8230b900)
Kernel tests: Boot OK!
[   43.322984] Unregister pv shared memory for cpu 1
[   43.344269] CPU0 attaching NULL sched-domain.
[   43.346461] CPU1 attaching NULL sched-domain.
[   43.348717] CPU0 attaching NULL sched-domain.
[   43.362808] smpboot: CPU 1 is now offline
[   43.471292] x86: Booting SMP configuration:
[   43.473518] smpboot: Booting Node 0 Processor 1 APIC 0x1
[   43.364029] kvm-clock: cpu 1, msr 0:f7f5041, secondary cpu clock
[   43.364029] masked ExtINT on CPU#1
[   43.508895] CPU0 attaching NULL sched-domain.
[   43.511133] CPU0 attaching sched-domain:
[   43.513257]  domain 0: span 0-1 level CPU
[   43.515467]   groups: 0 1
[   43.517665] CPU1 attaching sched-domain:
[   43.519674]  domain 0: span 0-1 level CPU
[   43.521948]   groups: 1 0
[   43.524338] KVM setup async PF for cpu 1
[   43.526426] kvm-stealtime: cpu 1, msr e80d240
[   44.585719] Unregister pv shared memory for cpu 1
[   44.620299] CPU0 attaching NULL sched-domain.
[   44.622480] CPU1 attaching NULL sched-domain.
[   44.624695] CPU0 attaching NULL sched-domain.
[   44.638925] smpboot: CPU 1 is now offline
Trinity v1.0  Dave Jones <davej@redhat.com> 2012
[3159] Marking 64-bit syscall 274 (get_robust_list) as AVOID
[3159] Marking 32-bit syscall 312 (get_robust_list) as AVOID
[   47.151882] Bits 55-60 of /proc/PID/pagemap entries are about to stop be=
ing page-shift some time soon. See the linux/Documentation/vm/pagemap.txt f=
or details.
Couldn't open /dev/net/tun : No such device
[   54.653309] x86: Booting SMP configuration:
[   54.655520] smpboot: Booting Node 0 Processor 1 APIC 0x1
[   44.640110] kvm-clock: cpu 1, msr 0:f7f5041, secondary cpu clock
[   44.640110] masked ExtINT on CPU#1
[   54.690649] CPU0 attaching NULL sched-domain.
[   54.692943] CPU0 attaching sched-domain:
[   54.694983]  domain 0: span 0-1 level CPU
[   54.697280]   groups: 0 1
[   54.699497] CPU1 attaching sched-domain:
[   54.701620]  domain 0: span 0-1 level CPU
[   54.703871]   groups: 1 0
[   54.706359] KVM setup async PF for cpu 1
[   54.707998] kvm-stealtime: cpu 1, msr e80d240
[3165] Watchdog is alive
[3159] Started watchdog thread 3165
[   58.695502] ------------[ cut here ]------------
[   58.697835] WARNING: CPU: 0 PID: 3166 at kernel/cpu.c:84 put_online_cpus=
+0x43/0x70()
[   58.702423] Modules linked in:
[   58.704404] CPU: 0 PID: 3166 Comm: trinity-child0 Not tainted 3.12.0-rc5=
-01882-gf3db366 #1172
[   58.708530] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   58.710992]  0000000000000000 ffff88000acfbe50 ffffffff81a24643 00000000=
00000000
[   58.715410]  ffff88000acfbe88 ffffffff810c3e6b ffffffff810c3fef 00000000=
00000000
[   58.719826]  0000000000000000 0000000000006ee0 0000000000000ffc ffff8800=
0acfbe98
[   58.724348] Call Trace:
[   58.726190]  [<ffffffff81a24643>] dump_stack+0x4d/0x66
[   58.728531]  [<ffffffff810c3e6b>] warn_slowpath_common+0x7f/0x98
[   58.731069]  [<ffffffff810c3fef>] ? put_online_cpus+0x43/0x70
[   58.733664]  [<ffffffff810c3f32>] warn_slowpath_null+0x1a/0x1c
[   58.736258]  [<ffffffff810c3fef>] put_online_cpus+0x43/0x70
[   58.738686]  [<ffffffff810efd59>] sched_setaffinity+0x7d/0x1f9
[   58.741210]  [<ffffffff810efce1>] ? sched_setaffinity+0x5/0x1f9
[   58.743775]  [<ffffffff81a2f724>] ? _raw_spin_unlock_irq+0x2c/0x3e
[   58.746417]  [<ffffffff810c7012>] ? do_setitimer+0x194/0x1f5
[   58.748899]  [<ffffffff810eff37>] SyS_sched_setaffinity+0x62/0x71
[   58.751481]  [<ffffffff81a373a9>] system_call_fastpath+0x16/0x1b
[   58.754070] ---[ end trace 034818a1f6f06868 ]---
[   58.757521] ------------[ cut here ]------------
[   58.759760] WARNING: CPU: 0 PID: 3166 at kernel/cpu.c:84 put_online_cpus=
+0x43/0x70()
[   58.765286] Modules linked in:
[   58.767253] CPU: 0 PID: 3166 Comm: trinity-child0 Tainted: G        W   =
 3.12.0-rc5-01882-gf3db366 #1172
[   58.771575] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   58.774131]  0000000000000000 ffff88000acfbe50 ffffffff81a24643 00000000=
00000000
[   58.778614]  ffff88000acfbe88 ffffffff810c3e6b ffffffff810c3fef 00000000=
00000000
[   58.783043]  0000000000000000 00000000000032da 0000000000000800 ffff8800=
0acfbe98
[   58.787502] Call Trace:
[   58.789229]  [<ffffffff81a24643>] dump_stack+0x4d/0x66
[   58.791529]  [<ffffffff810c3e6b>] warn_slowpath_common+0x7f/0x98
[   58.794112]  [<ffffffff810c3fef>] ? put_online_cpus+0x43/0x70
[   58.796590]  [<ffffffff810c3f32>] warn_slowpath_null+0x1a/0x1c
[   58.799063]  [<ffffffff810c3fef>] put_online_cpus+0x43/0x70
[   58.801507]  [<ffffffff810efd59>] sched_setaffinity+0x7d/0x1f9
[   58.804046]  [<ffffffff810efce1>] ? sched_setaffinity+0x5/0x1f9
[   58.806567]  [<ffffffff81a2f724>] ? _raw_spin_unlock_irq+0x2c/0x3e
[   58.809157]  [<ffffffff810c7012>] ? do_setitimer+0x194/0x1f5
[   58.811620]  [<ffffffff810eff37>] SyS_sched_setaffinity+0x62/0x71
[   58.814249]  [<ffffffff81a373a9>] system_call_fastpath+0x16/0x1b
[   58.816807] ---[ end trace 034818a1f6f06869 ]---
[   58.825814] ------------[ cut here ]------------
[   58.828079] WARNING: CPU: 0 PID: 3166 at kernel/cpu.c:84 put_online_cpus=
+0x43/0x70()
[   58.832560] Modules linked in:
[   58.834561] CPU: 0 PID: 3166 Comm: trinity-child0 Tainted: G        W   =
 3.12.0-rc5-01882-gf3db366 #1172
[   58.838880] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   58.841406]  0000000000000000 ffff88000acfbe50 ffffffff81a24643 00000000=
00000000
[   58.845865]  ffff88000acfbe88 ffffffff810c3e6b ffffffff810c3fef 00000000=
00000000
[   58.850280]  0000000000000000 0000000000005a26 0000000000f55ffc ffff8800=
0acfbe98
[   58.854784] Call Trace:
[   58.856482]  [<ffffffff81a24643>] dump_stack+0x4d/0x66
[   58.858802]  [<ffffffff810c3e6b>] warn_slowpath_common+0x7f/0x98
[   58.861349]  [<ffffffff810c3fef>] ? put_online_cpus+0x43/0x70
[   58.863812]  [<ffffffff810c3f32>] warn_slowpath_null+0x1a/0x1c
[   58.866336]  [<ffffffff810c3fef>] put_online_cpus+0x43/0x70
[   58.868808]  [<ffffffff810efd59>] sched_setaffinity+0x7d/0x1f9
[   58.871311]  [<ffffffff810efce1>] ? sched_setaffinity+0x5/0x1f9
[   58.873884]  [<ffffffff81a2f724>] ? _raw_spin_unlock_irq+0x2c/0x3e
[   58.876477]  [<ffffffff810c7012>] ? do_setitimer+0x194/0x1f5
[   58.878906]  [<ffffffff810eff37>] SyS_sched_setaffinity+0x62/0x71
[   58.881479]  [<ffffffff81a373a9>] system_call_fastpath+0x16/0x1b
[   58.884035] ---[ end trace 034818a1f6f0686a ]---
487 iterations.
[3159] Bailing main loop
[3159] Waiting for watchdog (0) to exit.

Ran 486 syscalls (0 retries). Successes: 52  Failures: 434
/etc/kernel-tests/99-trinity: line 17: kill: (3159) - No such process
run-parts: /etc/kernel-tests/99-trinity exited with return code 1
[  147.152965] nfsd: last server has exited, flushing export cache
[  152.825876] Unregister pv shared memory for cpu 0
[  152.828166] Unregister pv shared memory for cpu 1
[  152.831171] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  152.853522] reboot: Restarting system
[  152.855474] reboot: machine restart
Elapsed time: 155
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-lkp/f3db36=
699379159b761cdbc093347822a633c616/vmlinuz-3.12.0-rc5-01882-gf3db366 -appen=
d 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_timeout=3D100 log_buf_len=3D8M=
 ignore_loglevel debug sched_debug apic=3Ddebug dynamic_printk sysrq_always=
_enabled panic=3D10 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115=
200 console=3Dtty0 vga=3Dnormal ip=3D::::yocto-roam-31::dhcp nfsroot=3D192.=
168.1.1:/nfsroot/wfg,tcp,v3,nocto,actimeo=3D600,nolock,rsize=3D524288,wsize=
=3D524288 rw link=3D/kernel-tests/run-queue/kvm/x86_64-lkp/tip:master/.vmli=
nuz-f3db36699379159b761cdbc093347822a633c616-20131018034115-9-roam branch=
=3Dtip/master BOOT_IMAGE=3D/kernel/x86_64-lkp/f3db36699379159b761cdbc093347=
822a633c616/vmlinuz-3.12.0-rc5-01882-gf3db366'  -m 256M -smp 2 -net nic,vla=
n=3D0,macaddr=3D00:00:00:00:00:00,model=3Dvirtio -net user,vlan=3D0,hostfwd=
=3Dtcp::46262-:22 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot =
order=3Dnc -no-reboot -watchdog i6300esb -drive file=3D/fs/LABEL=3DKVM/disk=
0-yocto-roam-31,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk=
1-yocto-roam-31,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk=
2-yocto-roam-31,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk=
3-yocto-roam-31,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk=
4-yocto-roam-31,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk=
5-yocto-roam-31,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-yocto-=
roam-31 -serial file:/dev/shm/kboot/serial-yocto-roam-31 -daemonize -displa=
y none -monitor null=20

--UugvWAfsgieZRqgk
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-f3db36699379159b761cdbc093347822a633c616-x86_64-lkp-at-kernel-cpu-c:-100183.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDJmZTgwZDNiYmYxYzhiZDllZmM1YjgxNTQyMDdjOGRkMTA0ZTczMDYK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgZjNkYjM2Ni4uLiBNZXJnZSBicmFuY2ggJ3Nj
aGVkL2NvcmUnCkhFQUQgaXMgbm93IGF0IDJmZTgwZDMuLi4gYmNhY2hlOiBGaXggYSBudWxs
IHB0ciBkZXJlZiByZWdyZXNzaW9uCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2
bS94ODZfNjQtbGtwL3RpcDptYXN0ZXI6MmZlODBkM2JiZjFjOGJkOWVmYzViODE1NDIwN2M4
ZGQxMDRlNzMwNjpiaXNlY3QtbmV0CgoyMDEzLTEwLTE4LTA4OjMyOjIzIDJmZTgwZDNiYmYx
YzhiZDllZmM1YjgxNTQyMDdjOGRkMTA0ZTczMDYgcmV1c2UgL2tlcm5lbC94ODZfNjQtbGtw
LzJmZTgwZDNiYmYxYzhiZDllZmM1YjgxNTQyMDdjOGRkMTA0ZTczMDYvdm1saW51ei0zLjEy
LjAtcmM0LTAwMDYyLWcyZmU4MGQzCgoyMDEzLTEwLTE4LTA4OjMyOjI0IGRldGVjdGluZyBi
b290IHN0YXRlIC4uLi4uLgkxMS4uLi4uLi4uLi4JMTMuCTE1CTE2CTE4LgkyMC4uLi4uLi4u
Li4uLi4uLi4uCTIxIFNVQ0NFU1MKCmJpc2VjdDogZ29vZCBjb21taXQgMmZlODBkM2JiZjFj
OGJkOWVmYzViODE1NDIwN2M4ZGQxMDRlNzMwNgpnaXQgYmlzZWN0IHN0YXJ0IGYzZGIzNjY5
OTM3OTE1OWI3NjFjZGJjMDkzMzQ3ODIyYTYzM2M2MTYgMmZlODBkM2JiZjFjOGJkOWVmYzVi
ODE1NDIwN2M4ZGQxMDRlNzMwNiAtLQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyAyZmU4
MGQzLi4uIGJjYWNoZTogRml4IGEgbnVsbCBwdHIgZGVyZWYgcmVncmVzc2lvbgpTd2l0Y2hl
ZCB0byBicmFuY2ggJ21hc3RlcicKWW91ciBicmFuY2ggaXMgYmVoaW5kICdvcmlnaW4vbWFz
dGVyJyBieSA0MTIxMyBjb21taXRzLCBhbmQgY2FuIGJlIGZhc3QtZm9yd2FyZGVkLgogICh1
c2UgImdpdCBwdWxsIiB0byB1cGRhdGUgeW91ciBsb2NhbCBicmFuY2gpCkJpc2VjdGluZzog
OTg1IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMCBzdGVw
cykKWzBmMmEwMmQ3NWQwZjM3ZjE2MjQ1ODVjNTBjMzI1MGI2ZDA5NmYwNTBdIGt2bSB0b29s
czogZml4IGZ1bmN0aW9uIG5hbWUKZ2l0IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbmV0L29iai1iaXNlY3QKcnVu
bmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21l
L3dmZy9uZXQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
eDg2XzY0LWxrcC90aXA6bWFzdGVyOjBmMmEwMmQ3NWQwZjM3ZjE2MjQ1ODVjNTBjMzI1MGI2
ZDA5NmYwNTA6YmlzZWN0LW5ldAoKMjAxMy0xMC0xOC0wODo1Mzo1OSAwZjJhMDJkNzVkMGYz
N2YxNjI0NTg1YzUwYzMyNTBiNmQwOTZmMDUwIGNvbXBpbGluZwozNDggcmVhbCAgMTIwNyB1
c2VyICAxMDcgc3lzICAzNzcuMjclIGNwdSAJeDg2XzY0LWxrcAoKMjAxMy0xMC0xOC0wOTow
MDoxOSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjAuMC1yYzUtMDA5ODUtZzBmMmEwMmQuLi4u
Li4uLi4uLi4uLi4uLi4uCTEuCTIuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sx
OzM1bWFkZF90b19ydW5fcXVldWUgMTkbWzBtCi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLgk0CTE2CTIwCTIxIFNVQ0NFU1MKCkJpc2VjdGluZzogNTczIHJldmlzaW9u
cyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA5IHN0ZXBzKQpbZWU2OTQ2ZTY4
MTA3OTJmMjA4NjYyNTA3MDU1ZTZmOWMzMmY0Mjg5OF0geDg2OiBwZXJmIC0tIEFsbG93IHBl
cmYgd2F0Y2hkb2cgdG8gdXNlIHBlcmZtb24gYml0IGZvciBtc3IgaW5kZXggY29tcHV0YXRp
b24KcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9ob21lL3dmZy9uZXQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0veDg2XzY0LWxrcC90aXA6bWFzdGVyOmVlNjk0NmU2ODEwNzkyZjIwODY2MjUwNzA1
NWU2ZjljMzJmNDI4OTg6YmlzZWN0LW5ldAoKMjAxMy0xMC0xOC0xMjowMjo1NiBlZTY5NDZl
NjgxMDc5MmYyMDg2NjI1MDcwNTVlNmY5YzMyZjQyODk4IGNvbXBpbGluZwo0MTI3IHJlYWwg
IDE1NzQgdXNlciAgMTM1IHN5cyAgNDEuNDMlIGNwdSAJeDg2XzY0LWxrcAoKMjAxMy0xMC0x
OC0xMzoxNDoxNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtcmMzLTAxNTgzLWdlZTY5
NDZlLi4uLi4uCTEuLi4uLi4uLi4uCTIuCTMuCTQJNi4JNy4JMTMuLi4uLi4uLi4uLi4uCTE5
Li4uLi4uLi4JMjAuLi4uLi4uLi4uLi4uLi4uCTIxIFNVQ0NFU1MKCkJpc2VjdGluZzogMjgy
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpb
MmViMzA5MDYzMWUxZjNjNTkyMGUyN2UwYTUxZWQ4NzZlODhmZTg3MV0gTWVyZ2UgYnJhbmNo
ICdsaW51cycKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9ob21lL3dmZy9uZXQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0veDg2XzY0LWxrcC90aXA6bWFzdGVyOjJlYjMwOTA2MzFlMWYzYzU5MjBl
MjdlMGE1MWVkODc2ZTg4ZmU4NzE6YmlzZWN0LW5ldAoKMjAxMy0xMC0xOC0xMzo0Nzo1OCAy
ZWIzMDkwNjMxZTFmM2M1OTIwZTI3ZTBhNTFlZDg3NmU4OGZlODcxIGNvbXBpbGluZwozOTYx
IHJlYWwgIDE1OTEgdXNlciAgMTM2IHN5cyAgNDMuNjIlIGNwdSAJeDg2XzY0LWxrcAoKMjAx
My0xMC0xOC0xNDo1NToyOSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtcmM0LTAwMzUz
LWcyZWIzMDkwLi4uLi4uLi4uLi4uLi4JNgk5CTEzCTE3Li4uCTE4CTIxIFNVQ0NFU1MKCkJp
c2VjdGluZzogMTQxIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hs
eSA3IHN0ZXBzKQpbYmYyNTc1YzEyMWNhMTEyNDdlZjA3ZmQwMmI0M2Y3NDMwODM0ZjdiMV0g
cGVyZiB0cmFjZTogQWRkIHN1bW1hcnkgb3B0aW9uIHRvIGR1bXAgc3lzY2FsbCBzdGF0aXN0
aWNzCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aCAvaG9tZS93ZmcvbmV0L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL3g4Nl82NC1sa3AvdGlwOm1hc3RlcjpiZjI1NzVjMTIxY2ExMTI0N2VmMDdmZDAy
YjQzZjc0MzA4MzRmN2IxOmJpc2VjdC1uZXQKCjIwMTMtMTAtMTgtMTU6MDc6MDIgYmYyNTc1
YzEyMWNhMTEyNDdlZjA3ZmQwMmI0M2Y3NDMwODM0ZjdiMSBjb21waWxpbmcKNTM3IHJlYWwg
IDE3MzMgdXNlciAgMTQ4IHN5cyAgMzQ5LjkzJSBjcHUgCXg4Nl82NC1sa3AKCjIwMTMtMTAt
MTgtMTU6MjE6MTkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMi4wLXJjMi0wMDM2MS1nYmYy
NTc1Yy4uLi4uCTEuLi4uLi4uLi4uLgkyLi4JNQk3CTkJMTMuLi4uLi4uLi4uLi4uCTE0Li4u
Li4uLi4uLi4uLi4uLi4uLgkxNgkxNy4uLi4uLi4uLgkxOAkxOS4uLi4JMjEgU1VDQ0VTUwoK
QmlzZWN0aW5nOiA2OCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdo
bHkgNiBzdGVwcykKW2Q2MDk5YWViNGE5YWFkNWU3YWIxYzcyZWIxMTllYmQ1MmRlZTBkNTJd
IE1lcmdlIGJyYW5jaCAnZml4ZXMnIG9mIGdpdDovL2dpdC5saW5hcm8ub3JnL3Blb3BsZS9y
bWsvbGludXgtYXJtCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvaG9tZS93ZmcvbmV0L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1sa3AvdGlwOm1hc3RlcjpkNjA5OWFlYjRhOWFhZDVl
N2FiMWM3MmViMTE5ZWJkNTJkZWUwZDUyOmJpc2VjdC1uZXQKCjIwMTMtMTAtMTgtMTU6NTg6
NTYgZDYwOTlhZWI0YTlhYWQ1ZTdhYjFjNzJlYjExOWViZDUyZGVlMGQ1MiByZXVzZSAva2Vy
bmVsL3g4Nl82NC1sa3AvZDYwOTlhZWI0YTlhYWQ1ZTdhYjFjNzJlYjExOWViZDUyZGVlMGQ1
Mi92bWxpbnV6LTMuMTIuMC1yYzUtMDAwMTYtZ2Q2MDk5YWUKCjIwMTMtMTAtMTgtMTU6NTg6
NTYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4uLi4uLi4JMTAuLi4uLgkxMS4JMTQJ
MTYuLi4uLi4uLi4uLi4uCTE3Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkxOC4uLi4uCTE5
Li4JMjAJMjEgU1VDQ0VTUwoKQmlzZWN0aW5nOiAzNSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0
IGFmdGVyIHRoaXMgKHJvdWdobHkgNSBzdGVwcykKWzU0ZDU0YTcxNDZjZTI3MTg3MzhmOTcz
NzRkNzE0ZGQ2ZjVlMTAzYjBdIE1lcmdlIGJyYW5jaCAneDg2L3VyZ2VudCcKcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9u
ZXQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LWxrcC90aXA6bWFzdGVyOjU0ZDU0YTcxNDZjZTI3MTg3MzhmOTczNzRkNzE0ZGQ2ZjVlMTAz
YjA6YmlzZWN0LW5ldAoKMjAxMy0xMC0xOC0xNjozNjowNCA1NGQ1NGE3MTQ2Y2UyNzE4NzM4
Zjk3Mzc0ZDcxNGRkNmY1ZTEwM2IwIGNvbXBpbGluZwoyNzAgcmVhbCAgMTcyOSB1c2VyICAx
NDkgc3lzICA2OTQuNzQlIGNwdSAJeDg2XzY0LWxrcAoKMjAxMy0xMC0xOC0xNjo0NDoxNiBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtcmM1LTAxODI0LWc1NGQ1NGE3Li4uLi4JMS4u
Li4uLi4JMi4JNAk2Li4uLgk3CTkJMTYJMjEgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxNyByZXZp
c2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNCBzdGVwcykKW2VkOGFk
YTM5MzM4OGVmN2NjZmNmYjNhODhkODcxOGY3ZGY0YjMxNjVdIE1lcmdlIHRhZyAncmRtYS1m
b3ItbGludXMnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVs
L2dpdC9yb2xhbmQvaW5maW5pYmFuZApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL25ldC9vYmotYmlzZWN0CmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtbGtwL3RpcDptYXN0ZXI6ZWQ4YWRh
MzkzMzg4ZWY3Y2NmY2ZiM2E4OGQ4NzE4ZjdkZjRiMzE2NTpiaXNlY3QtbmV0CgoyMDEzLTEw
LTE4LTE2OjU2OjQ3IGVkOGFkYTM5MzM4OGVmN2NjZmNmYjNhODhkODcxOGY3ZGY0YjMxNjUg
Y29tcGlsaW5nCjI0MCByZWFsICAxNzQzIHVzZXIgIDE1MiBzeXMgIDc4OS41MyUgY3B1IAl4
ODZfNjQtbGtwCgoyMDEzLTEwLTE4LTE3OjAxOjAzIGRldGVjdGluZyBib290IHN0YXRlIDMu
MTIuMC1yYzUtMDAwMzQtZ2VkOGFkYTMuLi4uLi4uLi4uLgkxLi4JMy4uLi4uLi4JNC4JNwkx
MwkxNAkxNS4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgkxNy4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4JMTgJMTkuLi4uCTIwLgkyMSBTVUNDRVNTCgpCaXNlY3Rpbmc6IDkgcmV2aXNpb25z
IGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDMgc3RlcHMpCltmNzczOTM0ZmIz
OWQxMTYwOGI4Mjg1ZGI2MjFhZTY1Y2ExNDY1YmYzXSBNZXJnZSBicmFuY2ggJ3BlcmYvY29y
ZScKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9ob21lL3dmZy9uZXQvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0veDg2XzY0LWxrcC90aXA6bWFzdGVyOmY3NzM5MzRmYjM5ZDExNjA4YjgyODVkYjYy
MWFlNjVjYTE0NjViZjM6YmlzZWN0LW5ldAoKMjAxMy0xMC0xOC0xNzo0NDozNyBmNzczOTM0
ZmIzOWQxMTYwOGI4Mjg1ZGI2MjFhZTY1Y2ExNDY1YmYzIHJldXNlIC9rZXJuZWwveDg2XzY0
LWxrcC9mNzczOTM0ZmIzOWQxMTYwOGI4Mjg1ZGI2MjFhZTY1Y2ExNDY1YmYzL3ZtbGludXot
My4xMi4wLXJjNS0wMTg3Mi1nZjc3MzkzNAoKMjAxMy0xMC0xOC0xNzo0NDozNyBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAuLi4uLi4uLi4uLi4uLi4uLi4uLi4JMTAuCTExCTEyCTE3CTE5Li4u
Li4uLi4uLi4uLi4uLi4uLi4uLgkyMSBTVUNDRVNTCgpCaXNlY3Rpbmc6IDQgcmV2aXNpb25z
IGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDIgc3RlcHMpCltjMmQ4MTY0NDNl
ZjMwNWFiYThlYWYwYmYzNjhmNGQzZDg3NDk0ZjA2XSBzY2hlZC93YWl0OiBJbnRyb2R1Y2Ug
cHJlcGFyZV90b193YWl0X2V2ZW50KCkKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9uZXQvb2JqLWJpc2VjdApscyAtYSAv
a2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LWxrcC90aXA6bWFzdGVyOmMyZDgx
NjQ0M2VmMzA1YWJhOGVhZjBiZjM2OGY0ZDNkODc0OTRmMDY6YmlzZWN0LW5ldAogVEVTVCBG
QUlMVVJFClszMTk5XSBTdGFydGVkIHdhdGNoZG9nIHRocmVhZCAzMjA2ClsgIDQxNy42ODY2
NTVdIHdhcm5pbmc6IHByb2Nlc3MgYHRyaW5pdHktY2hpbGQwJyB1c2VkIHRoZSBkZXByZWNh
dGVkIHN5c2N0bCBzeXN0ZW0gY2FsbCB3aXRoIApbICA0MTcuNzQyNzE3XSAtLS0tLS0tLS0t
LS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgNDE3Ljc0NDY1OV0gV0FSTklORzogQ1BV
OiAwIFBJRDogMzIwNyBhdCBrZXJuZWwvY3B1LmM6ODQgcHV0X29ubGluZV9jcHVzKzB4NDMv
MHg3MCgpClsgIDQxNy43NDg0ODVdIE1vZHVsZXMgbGlua2VkIGluOgpbICA0MTcuNzUwMTIw
XSBDUFU6IDAgUElEOiAzMjA3IENvbW06IHRyaW5pdHktY2hpbGQwIE5vdCB0YWludGVkIDMu
MTIuMC1yYzQtMDAxNzktZ2MyZDgxNjQgIzExNzAKWyAgNDE3Ljc1MzU2OF0gSGFyZHdhcmUg
bmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICA0MTcuNzU1Njg5
XSAgMDAwMDAwMDAwMDAwMDAwMCBmZmZmODgwMDE5NDM1ZTUwIGZmZmZmZmZmODFhMjQ0M2Yg
MDAwMDAwMDAwMDAwMDAwMApbICA0MTcuNzYwNTA1XSAgZmZmZjg4MDAxOTQzNWU4OCBmZmZm
ZmZmZjgxMGMzZWViIGZmZmZmZmZmODEwYzQwNmYgMDAwMDAwMDAwMDAwMDAwMApbICA0MTcu
NzY0MTg1XSAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDA1ZTg2IDAwMDA3ZjgyMjFm
NjdmZmYgZmZmZjg4MDAxOTQzNWU5OApbICA0MTcuNzY3ODQ3XSBDYWxsIFRyYWNlOgpbICA0
MTcuNzY5MjgyXSAgWzxmZmZmZmZmZjgxYTI0NDNmPl0gZHVtcF9zdGFjaysweDRkLzB4NjYK
WyAgNDE3Ljc3MTIxNV0gIFs8ZmZmZmZmZmY4MTBjM2VlYj5dIHdhcm5fc2xvd3BhdGhfY29t
bW9uKzB4N2YvMHg5OApbICA0MTcuNzczMzg4XSAgWzxmZmZmZmZmZjgxMGM0MDZmPl0gPyBw
dXRfb25saW5lX2NwdXMrMHg0My8weDcwClsgIDQxNy43NzU2MjNdICBbPGZmZmZmZmZmODEw
YzNmYjI+XSB3YXJuX3Nsb3dwYXRoX251bGwrMHgxYS8weDFjClsgIDQxNy43Nzc4NzJdICBb
PGZmZmZmZmZmODEwYzQwNmY+XSBwdXRfb25saW5lX2NwdXMrMHg0My8weDcwClsgIDQxNy43
Nzk5MjddICBbPGZmZmZmZmZmODEwZWZkMzg+XSBzY2hlZF9zZXRhZmZpbml0eSsweDdkLzB4
MWY5ClsgIDQxNy43ODIwODJdICBbPGZmZmZmZmZmODEwZWZjYzA+XSA/IHNjaGVkX3NldGFm
ZmluaXR5KzB4NS8weDFmOQpbICA0MTcuNzg0MjE0XSAgWzxmZmZmZmZmZjgxYTJmNTI0Pl0g
PyBfcmF3X3NwaW5fdW5sb2NrX2lycSsweDJjLzB4M2UKWyAgNDE3Ljc4NjM3M10gIFs8ZmZm
ZmZmZmY4MTBjNzA5Mj5dID8gZG9fc2V0aXRpbWVyKzB4MTk0LzB4MWY1ClsgIDQxNy43ODg1
MzBdICBbPGZmZmZmZmZmODEwZWZmMTY+XSBTeVNfc2NoZWRfc2V0YWZmaW5pdHkrMHg2Mi8w
eDcxClsgIDQxNy43OTA2MjJdICBbPGZmZmZmZmZmODFhMzcyYTk+XSBzeXN0ZW1fY2FsbF9m
YXN0cGF0aCsweDE2LzB4MWIKWyAgNDE3Ljc5Mjc5MF0gLS0tWyBlbmQgdHJhY2UgZDU4Yjhh
YzllMDlhNjA5ZCBdLS0tClsgIDQxNy44MDg2MjBdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUg
XS0tLS0tLS0tLS0tLQova2VybmVsL3g4Nl82NC1sa3AvYzJkODE2NDQzZWYzMDVhYmE4ZWFm
MGJmMzY4ZjRkM2Q4NzQ5NGYwNi9kbWVzZy15b2N0by1zdG9ha2xleS00OjIwMTMxMDE4MDIx
MzU0Ong4Nl82NC1sa3A6My4xMi4wLXJjNC0wMDE3OS1nYzJkODE2NDoxMTcwCi9rZXJuZWwv
eDg2XzY0LWxrcC9jMmQ4MTY0NDNlZjMwNWFiYThlYWYwYmYzNjhmNGQzZDg3NDk0ZjA2L2Rt
ZXNnLW5mc3Jvb3QtYXRoZW5zLTk6MjAxMzEwMTgwMjE1Mzg6eDg2XzY0LWxrcDozLjEyLjAt
cmM0LTAwMTc5LWdjMmQ4MTY0OjExNzAKL2tlcm5lbC94ODZfNjQtbGtwL2MyZDgxNjQ0M2Vm
MzA1YWJhOGVhZjBiZjM2OGY0ZDNkODc0OTRmMDYvZG1lc2ctbmZzcm9vdC1jYWlyby0xNzoy
MDEzMTAxODAyMTUwNjp4ODZfNjQtbGtwOjMuMTIuMC1yYzQtMDAxNzktZ2MyZDgxNjQ6MTE3
MAova2VybmVsL3g4Nl82NC1sa3AvYzJkODE2NDQzZWYzMDVhYmE4ZWFmMGJmMzY4ZjRkM2Q4
NzQ5NGYwNi9kbWVzZy1xdWFudGFsLXJvYW0tNToyMDEzMTAxODAyMTg0MTp4ODZfNjQtbGtw
OjMuMTIuMC1yYzQtMDAxNzktZ2MyZDgxNjQ6MTE3MAova2VybmVsL3g4Nl82NC1sa3AvYzJk
ODE2NDQzZWYzMDVhYmE4ZWFmMGJmMzY4ZjRkM2Q4NzQ5NGYwNi9kbWVzZy1xdWFudGFsLWJl
bnMtMjoyMDEzMTAxODAyMTQzNjp4ODZfNjQtbGtwOjMuMTIuMC1yYzQtMDAxNzktZ2MyZDgx
NjQ6MTE3MAova2VybmVsL3g4Nl82NC1sa3AvYzJkODE2NDQzZWYzMDVhYmE4ZWFmMGJmMzY4
ZjRkM2Q4NzQ5NGYwNi9kbWVzZy1uZnNyb290LXhpYW4tMjE6MjAxMzEwMTgwMjE1MzQ6eDg2
XzY0LWxrcDozLjEyLjAtcmM0LTAwMTc5LWdjMmQ4MTY0OjExNzAKL2tlcm5lbC94ODZfNjQt
bGtwL2MyZDgxNjQ0M2VmMzA1YWJhOGVhZjBiZjM2OGY0ZDNkODc0OTRmMDYvZG1lc2ctcXVh
bnRhbC1sa3AtdHQwMi03OjIwMTMxMDE3MTY1NDIzOng4Nl82NC1sa3A6My4xMi4wLXJjNC0w
MDE3OS1nYzJkODE2NDoxMTcwCi9rZXJuZWwveDg2XzY0LWxrcC9jMmQ4MTY0NDNlZjMwNWFi
YThlYWYwYmYzNjhmNGQzZDg3NDk0ZjA2L2RtZXNnLXF1YW50YWwtY2Fpcm8tMjM6MjAxMzEw
MTgwMjE1MDY6eDg2XzY0LWxrcDozLjEyLjAtcmM0LTAwMTc5LWdjMmQ4MTY0OjExNzAKL2tl
cm5lbC94ODZfNjQtbGtwL2MyZDgxNjQ0M2VmMzA1YWJhOGVhZjBiZjM2OGY0ZDNkODc0OTRm
MDYvZG1lc2ctcXVhbnRhbC13YWltZWEtMzoyMDEzMTAxODEwMDkzMDp4ODZfNjQtbGtwOjMu
MTIuMC1yYzQtMDAxNzktZ2MyZDgxNjQ6MTE3MAowOjk6OSBhbGxfZ29vZDpiYWQ6YWxsX2Jh
ZCBib290cwoKQmlzZWN0aW5nOiAyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSAxIHN0ZXApCls3NDYwMjMxNTljNDBjNTIzYjA4YTNiYzNkMjEzZGFjMjEy
Mzg1ODk1XSBzY2hlZDogRml4IHJhY2UgaW4gbWlncmF0ZV9zd2FwX3N0b3AoKQpydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2Zn
L25ldC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZf
NjQtbGtwL3RpcDptYXN0ZXI6NzQ2MDIzMTU5YzQwYzUyM2IwOGEzYmMzZDIxM2RhYzIxMjM4
NTg5NTpiaXNlY3QtbmV0CgoyMDEzLTEwLTE4LTE4OjA5OjQzIDc0NjAyMzE1OWM0MGM1MjNi
MDhhM2JjM2QyMTNkYWMyMTIzODU4OTUgY29tcGlsaW5nCjI0OSByZWFsICAxNzIzIHVzZXIg
IDE0OSBzeXMgIDc1MC45MCUgY3B1IAl4ODZfNjQtbGtwCgoyMDEzLTEwLTE4LTE4OjE0OjA4
IGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1yYzQtMDAxNzYtZzc0NjAyMzEuLi4uLgkx
Li4uLi4uCTIuCTQJNgk4LgkxMS4uCTEzCTE0CTE1CTE4Li4JMjAuLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uCTIxIFNVQ0NFU1MKCkJpc2VjdGluZzogMCByZXZpc2lvbnMg
bGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMSBzdGVwKQpbODkyMjkxNWIzOGNk
OGI3MmY4ZTVhZjYxNGI5NWJlNzFkMWQyOTlkNF0gc2NoZWQvd2FpdDogQWRkIF9fX3dhaXRf
Y29uZF90aW1lb3V0KCkgdG8gd2FpdF9ldmVudCpfdGltZW91dCgpIHRvbwpydW5uaW5nIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL25l
dC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQt
bGtwL3RpcDptYXN0ZXI6ODkyMjkxNWIzOGNkOGI3MmY4ZTVhZjYxNGI5NWJlNzFkMWQyOTlk
NDpiaXNlY3QtbmV0CgoyMDEzLTEwLTE4LTE4OjQ1OjQ1IDg5MjI5MTViMzhjZDhiNzJmOGU1
YWY2MTRiOTViZTcxZDFkMjk5ZDQgY29tcGlsaW5nCjI0MyByZWFsICAxNzQxIHVzZXIgIDE1
NyBzeXMgIDc4MC43NSUgY3B1IAl4ODZfNjQtbGtwCgoyMDEzLTEwLTE4LTE4OjUwOjAxIGRl
dGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1yYzQtMDAxNzgtZzg5MjI5MTUuLi4uLi4uLi4u
Li4uLi4uLi4uLiBURVNUIEZBSUxVUkUKWzMyMzldIFdhdGNoZG9nIGlzIGFsaXZlClszMjI5
XSBTdGFydGVkIHdhdGNoZG9nIHRocmVhZCAzMjM5ClsgIDM4Ny45NjQ3NzZdIC0tLS0tLS0t
LS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbICAzODcuOTY2Mzc2XSBXQVJOSU5HOiBD
UFU6IDAgUElEOiAzMjQwIGF0IGtlcm5lbC9jcHUuYzo4NCBwdXRfb25saW5lX2NwdXMrMHg0
My8weDcwKCkKWyAgMzg3Ljk2OTQwN10gTW9kdWxlcyBsaW5rZWQgaW46ClsgIDM4Ny45NzA4
MDZdIENQVTogMCBQSUQ6IDMyNDAgQ29tbTogdHJpbml0eS1jaGlsZDAgTm90IHRhaW50ZWQg
My4xMi4wLXJjNC0wMDE3OC1nODkyMjkxNSAjNDU2ClsgIDM4Ny45NzM3MjZdIEhhcmR3YXJl
IG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgMzg3Ljk3NTUx
M10gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAxYTY3YmU1MCBmZmZmZmZmZjgxYTIzM2Rm
IDAwMDAwMDAwMDAwMDAwMDAKWyAgMzg3Ljk3ODczNl0gIGZmZmY4ODAwMWE2N2JlODggZmZm
ZmZmZmY4MTBjM2VlYiBmZmZmZmZmZjgxMGM0MDZmIDAwMDAwMDAwMDAwMDAwMDAKWyAgMzg3
Ljk4MTk0OV0gIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwNDgxYiAwMDAwN2ZhYzAz
NTQ4ZmZjIGZmZmY4ODAwMWE2N2JlOTgKWyAgMzg3Ljk4NTE4M10gQ2FsbCBUcmFjZToKWyAg
Mzg3Ljk4NjM1OF0gIFs8ZmZmZmZmZmY4MWEyMzNkZj5dIGR1bXBfc3RhY2srMHg0ZC8weDY2
ClsgIDM4Ny45ODgwODRdICBbPGZmZmZmZmZmODEwYzNlZWI+XSB3YXJuX3Nsb3dwYXRoX2Nv
bW1vbisweDdmLzB4OTgKWyAgMzg3Ljk4OTk2Nl0gIFs8ZmZmZmZmZmY4MTBjNDA2Zj5dID8g
cHV0X29ubGluZV9jcHVzKzB4NDMvMHg3MApbICAzODcuOTkxODA0XSAgWzxmZmZmZmZmZjgx
MGMzZmIyPl0gd2Fybl9zbG93cGF0aF9udWxsKzB4MWEvMHgxYwpbICAzODcuOTkzNjk1XSAg
WzxmZmZmZmZmZjgxMGM0MDZmPl0gcHV0X29ubGluZV9jcHVzKzB4NDMvMHg3MApbICAzODcu
OTk1NDUyXSAgWzxmZmZmZmZmZjgxMGVmYzk5Pl0gc2NoZWRfc2V0YWZmaW5pdHkrMHg3ZC8w
eDFmOQpbICAzODcuOTk3MzMwXSAgWzxmZmZmZmZmZjgxMGVmYzIxPl0gPyBzY2hlZF9zZXRh
ZmZpbml0eSsweDUvMHgxZjkKWyAgMzg3Ljk5OTIzNl0gIFs8ZmZmZmZmZmY4MWEyZTRjND5d
ID8gX3Jhd19zcGluX3VubG9ja19pcnErMHgyYy8weDNlClsgIDM4OC4wMDExODRdICBbPGZm
ZmZmZmZmODEwYzcwOTI+XSA/IGRvX3NldGl0aW1lcisweDE5NC8weDFmNQpbICAzODguMDAy
OTk0XSAgWzxmZmZmZmZmZjgxMGVmZTc3Pl0gU3lTX3NjaGVkX3NldGFmZmluaXR5KzB4NjIv
MHg3MQpbICAzODguMDA0OTIwXSAgWzxmZmZmZmZmZjgxYTM2MjI5Pl0gc3lzdGVtX2NhbGxf
ZmFzdHBhdGgrMHgxNi8weDFiClsgIDM4OC4wMDY4MTddIC0tLVsgZW5kIHRyYWNlIDQyOTA5
ZDQ4NDkxY2RmMjAgXS0tLQpbICAzODguMDEzNjYxXSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJl
IF0tLS0tLS0tLS0tLS0KL2tlcm5lbC94ODZfNjQtbGtwLzg5MjI5MTViMzhjZDhiNzJmOGU1
YWY2MTRiOTViZTcxZDFkMjk5ZDQvZG1lc2ctbmZzcm9vdC13YWltZWEtMTI6MjAxMzEwMTkw
MjUzMjg6eDg2XzY0LWxrcDozLjEyLjAtcmM0LTAwMTc4LWc4OTIyOTE1OjQ1NgowOjE6MSBh
bGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0
IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAwIHN0ZXBzKQpbNmFjY2UzZWY4NDUyMDUz
N2Y4YTA5YTEyYzlkZGJlODE0YTU4NGRkMl0gc2NoZWQ6IFJlbW92ZSBnZXRfb25saW5lX2Nw
dXMoKSB1c2FnZQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2hvbWUvd2ZnL25ldC9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS94ODZfNjQtbGtwL3RpcDptYXN0ZXI6NmFjY2UzZWY4NDUyMDUzN2Y4
YTA5YTEyYzlkZGJlODE0YTU4NGRkMjpiaXNlY3QtbmV0CgoyMDEzLTEwLTE4LTE5OjAwOjA3
IDZhY2NlM2VmODQ1MjA1MzdmOGEwOWExMmM5ZGRiZTgxNGE1ODRkZDIgY29tcGlsaW5nCjI2
MiByZWFsICAxNzI0IHVzZXIgIDE1MyBzeXMgIDcxNi4zNyUgY3B1IAl4ODZfNjQtbGtwCgoy
MDEzLTEwLTE4LTE5OjA1OjQ4IGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1yYzQtMDAx
NzctZzZhY2NlM2UuLi4uLi4uLi4uLi4uLi4gVEVTVCBGQUlMVVJFClsgIDMzOS41MjIxODNd
IHdhcm5pbmc6IHByb2Nlc3MgYHRyaW5pdHktY2hpbGQxJyB1c2VkIHRoZSBkZXByZWNhdGVk
IHN5c2N0bCBzeXN0ZW0gY2FsbCB3aXRoIAo4OSBpdGVyYXRpb25zLgpbICAzMzkuNTM2Nzky
XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgMzM5LjUzNzc2Nl0g
V0FSTklORzogQ1BVOiAwIFBJRDogMzIzMSBhdCBrZXJuZWwvY3B1LmM6ODQgcHV0X29ubGlu
ZV9jcHVzKzB4NDMvMHg3MCgpClsgIDMzOS41Mzk1MThdIE1vZHVsZXMgbGlua2VkIGluOgpb
ICAzMzkuNTQwMzk3XSBDUFU6IDAgUElEOiAzMjMxIENvbW06IHRyaW5pdHktY2hpbGQxIE5v
dCB0YWludGVkIDMuMTIuMC1yYzQtMDAxNzctZzZhY2NlM2UgIzQ1NwpbICAzMzkuNTQyMTM1
XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsg
IDMzOS41NDMyMjhdICAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMWIwM2JlNTAgZmZmZmZm
ZmY4MWEyMzE2ZiAwMDAwMDAwMDAwMDAwMDAwClsgIDMzOS41NDUxOTVdICBmZmZmODgwMDFi
MDNiZTg4IGZmZmZmZmZmODEwYzNlZWIgZmZmZmZmZmY4MTBjNDA2ZiAwMDAwMDAwMDAwMDAw
MDAwClsgIDMzOS41NDcxNDZdICAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDc4NTQg
MDAwMDAwMDAwMGY1NWZmZiBmZmZmODgwMDFiMDNiZTk4ClsgIDMzOS41NDkxMThdIENhbGwg
VHJhY2U6ClsgIDMzOS41NDk4MDFdICBbPGZmZmZmZmZmODFhMjMxNmY+XSBkdW1wX3N0YWNr
KzB4NGQvMHg2NgpbICAzMzkuNTUwODI4XSAgWzxmZmZmZmZmZjgxMGMzZWViPl0gd2Fybl9z
bG93cGF0aF9jb21tb24rMHg3Zi8weDk4ClsgIDMzOS41NTE5NjNdICBbPGZmZmZmZmZmODEw
YzQwNmY+XSA/IHB1dF9vbmxpbmVfY3B1cysweDQzLzB4NzAKWyAgMzM5LjU1MzA4N10gIFs8
ZmZmZmZmZmY4MTBjM2ZiMj5dIHdhcm5fc2xvd3BhdGhfbnVsbCsweDFhLzB4MWMKWyAgMzM5
LjU1NDIwMV0gIFs8ZmZmZmZmZmY4MTBjNDA2Zj5dIHB1dF9vbmxpbmVfY3B1cysweDQzLzB4
NzAKWyAgMzM5LjU1NTI3OF0gIFs8ZmZmZmZmZmY4MTBlZmM5OT5dIHNjaGVkX3NldGFmZmlu
aXR5KzB4N2QvMHgxZjkKWyAgMzM5LjU1NjQwM10gIFs8ZmZmZmZmZmY4MTBlZmMyMT5dID8g
c2NoZWRfc2V0YWZmaW5pdHkrMHg1LzB4MWY5ClsgIDMzOS41NTc1MjVdICBbPGZmZmZmZmZm
ODFhMmUyNTQ+XSA/IF9yYXdfc3Bpbl91bmxvY2tfaXJxKzB4MmMvMHgzZQpbICAzMzkuNTU4
NjcwXSAgWzxmZmZmZmZmZjgxMGM3MDkyPl0gPyBkb19zZXRpdGltZXIrMHgxOTQvMHgxZjUK
WyAgMzM5LjU1OTc2NV0gIFs8ZmZmZmZmZmY4MTBlZmU3Nz5dIFN5U19zY2hlZF9zZXRhZmZp
bml0eSsweDYyLzB4NzEKWyAgMzM5LjU2MDkyNl0gIFs8ZmZmZmZmZmY4MWEzNWZlOT5dIHN5
c3RlbV9jYWxsX2Zhc3RwYXRoKzB4MTYvMHgxYgpbICAzMzkuNTYyMDUxXSAtLS1bIGVuZCB0
cmFjZSA5NDQzZWMwZjU5MzJiMzk3IF0tLS0KWyAgMzM5LjU3MTUyNl0gLS0tLS0tLS0tLS0t
WyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tCi9rZXJuZWwveDg2XzY0LWxrcC82YWNjZTNlZjg0
NTIwNTM3ZjhhMDlhMTJjOWRkYmU4MTRhNTg0ZGQyL2RtZXNnLW5mc3Jvb3Qtd2FpbWVhLTEw
OjIwMTMxMDE5MDMwNjQzOng4Nl82NC1sa3A6My4xMi4wLXJjNC0wMDE3Ny1nNmFjY2UzZTo0
NTcKMDoxOjEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCjZhY2NlM2VmODQ1MjA1Mzdm
OGEwOWExMmM5ZGRiZTgxNGE1ODRkZDIgaXMgdGhlIGZpcnN0IGJhZCBjb21taXQKY29tbWl0
IDZhY2NlM2VmODQ1MjA1MzdmOGEwOWExMmM5ZGRiZTgxNGE1ODRkZDIKQXV0aG9yOiBQZXRl
ciBaaWpsc3RyYSA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+CkRhdGU6ICAgRnJpIE9jdCAxMSAx
NDozODoyMCAyMDEzICswMjAwCgogICAgc2NoZWQ6IFJlbW92ZSBnZXRfb25saW5lX2NwdXMo
KSB1c2FnZQogICAgCiAgICBSZW1vdmUgZ2V0X29ubGluZV9jcHVzKCkgdXNhZ2UgZnJvbSB0
aGUgc2NoZWR1bGVyOyB0aGVyZSdzIDQgc2l0ZXMgdGhhdAogICAgdXNlIGl0OgogICAgCiAg
ICAgLSBzY2hlZF9pbml0X3NtcCgpOyB3aGVyZSBpdHMgY29tcGxldGVseSBzdXBlcmZsdW91
cyBzaW5jZSB3ZSdyZSBpbgogICAgICAgJ2Vhcmx5JyBib290IGFuZCB0aGVyZSBzaW1wbHkg
Y2Fubm90IGJlIGFueSBob3RwbHVnZ2luZy4KICAgIAogICAgIC0gc2NoZWRfZ2V0YWZmaW5p
dHkoKTsgd2UgYWxyZWFkeSB0YWtlIGEgcmF3IHNwaW5sb2NrIHRvIHByb3RlY3QgdGhlCiAg
ICAgICB0YXNrIGNwdXNfYWxsb3dlZCBtYXNrLCB0aGlzIGRpc2FibGVzIHByZWVtcHRpb24g
YW5kIHRoZXJlZm9yZQogICAgICAgYWxzbyBzdGFiaWxpemVzIGNwdV9vbmxpbmVfbWFzayBh
cyB0aGF0J3MgbW9kaWZpZWQgdXNpbmcKICAgICAgIHN0b3BfbWFjaGluZS4gSG93ZXZlciBz
d2l0Y2ggdG8gYWN0aXZlIG1hc2sgZm9yIHN5bW1ldHJ5IHdpdGgKICAgICAgIHNjaGVkX3Nl
dGFmZmluaXR5KCkvc2V0X2NwdXNfYWxsb3dlZF9wdHIoKS4gV2UgZ3VhcmFudGVlIGFjdGl2
ZQogICAgICAgbWFzayBzdGFiaWxpdHkgYnkgaW5zZXJ0aW5nIHN5bmNfcmN1L3NjaGVkKCkg
aW50byBfY3B1X2Rvd24uCiAgICAKICAgICAtIHNjaGVkX3NldGFmZmluaXR5KCk7IHdlIGRv
bid0IGFwcGVhciB0byBuZWVkIGdldF9vbmxpbmVfY3B1cygpCiAgICAgICBlaXRoZXIsIHRo
ZXJlJ3MgdHdvIHNpdGVzIHdoZXJlIGhvdHBsdWcgYXBwZWFycyByZWxldmFudDoKICAgICAg
ICAqIGNwdXNldF9jcHVzX2FsbG93ZWQoKTsgZm9yIHRoZSAhY3B1c2V0IGNhc2Ugd2UgdXNl
IHBvc3NpYmxlX21hc2ssCiAgICAgICAgICBmb3IgdGhlIGNwdXNldCBjYXNlIHdlIGhvbGQg
dGFza19sb2NrLCB3aGljaCBpcyBhIHNwaW5sb2NrIGFuZAogICAgICAgICAgdGh1cyBmb3Ig
bWFpbmxpbmUgZGlzYWJsZXMgcHJlZW1wdGlvbiAobWlnaHQgY2F1c2UgcGFpbiBvbiBSVCku
CiAgICAgICAgKiBzZXRfY3B1c19hbGxvd2VkX3B0cigpOyBIb2xkcyBhbGwgc2NoZWR1bGVy
IGxvY2tzIGFuZCB0aHVzIGhhcwogICAgICAgICAgcHJlZW1wdGlvbiBwcm9wZXJseSBkaXNh
YmxlZDsgYWxzbyBpdCBhbHJlYWR5IGRlYWxzIHdpdGggaG90cGx1ZwogICAgICAgICAgcmFj
ZXMgZXhwbGljaXRseSB3aGVyZSBpdCByZWxlYXNlcyB0aGVtLgogICAgCiAgICAgLSBtaWdy
YXRlX3N3YXAoKTsgd2UgY2FuIG1ha2Ugc3RvcF90d29fY3B1cygpIGRvIHRoZSBoZWF2eSBs
aWZ0aW5nIGZvcgogICAgICAgdXMgd2l0aCBhIGxpdHRsZSB0cmlja2VyeS4gQnkgYWRkaW5n
IGEgc3luY19zY2hlZC9yY3UoKSBhZnRlciB0aGUKICAgICAgIENQVV9ET1dOX1BSRVBBUkUg
bm90aWZpZXIgd2UgY2FuIHByb3ZpZGUgcHJlZW1wdC9yY3UgZ3VhcmFudGVlcyBmb3IKICAg
ICAgIGNwdV9hY3RpdmVfbWFzay4gVXNlIHRoZXNlIHRvIHZhbGlkYXRlIHRoYXQgYm90aCBv
dXIgY3B1cyBhcmUgYWN0aXZlCiAgICAgICB3aGVuIHF1ZXVlaW5nIHRoZSBzdG9wIHdvcmsg
YmVmb3JlIHdlIHF1ZXVlIHRoZSBzdG9wX21hY2hpbmUgd29ya3MKICAgICAgIGZvciB0YWtl
X2NwdV9kb3duKCkuCiAgICAKICAgIFNpZ25lZC1vZmYtYnk6IFBldGVyIFppamxzdHJhIDxw
ZXRlcnpAaW5mcmFkZWFkLm9yZz4KICAgIENjOiAiU3JpdmF0c2EgUy4gQmhhdCIgPHNyaXZh
dHNhLmJoYXRAbGludXgudm5ldC5pYm0uY29tPgogICAgQ2M6IFBhdWwgTWNLZW5uZXkgPHBh
dWxtY2tAbGludXgudm5ldC5pYm0uY29tPgogICAgQ2M6IE1lbCBHb3JtYW4gPG1nb3JtYW5A
c3VzZS5kZT4KICAgIENjOiBSaWsgdmFuIFJpZWwgPHJpZWxAcmVkaGF0LmNvbT4KICAgIENj
OiBTcmlrYXIgRHJvbmFtcmFqdSA8c3Jpa2FyQGxpbnV4LnZuZXQuaWJtLmNvbT4KICAgIENj
OiBBbmRyZWEgQXJjYW5nZWxpIDxhYXJjYW5nZUByZWRoYXQuY29tPgogICAgQ2M6IEpvaGFu
bmVzIFdlaW5lciA8aGFubmVzQGNtcHhjaGcub3JnPgogICAgQ2M6IExpbnVzIFRvcnZhbGRz
IDx0b3J2YWxkc0BsaW51eC1mb3VuZGF0aW9uLm9yZz4KICAgIENjOiBBbmRyZXcgTW9ydG9u
IDxha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnPgogICAgQ2M6IFN0ZXZlbiBSb3N0ZWR0IDxy
b3N0ZWR0QGdvb2RtaXMub3JnPgogICAgQ2M6IE9sZWcgTmVzdGVyb3YgPG9sZWdAcmVkaGF0
LmNvbT4KICAgIExpbms6IGh0dHA6Ly9sa21sLmtlcm5lbC5vcmcvci8yMDEzMTAxMTEyMzgy
MC5HVjMwODFAdHdpbnMucHJvZ3JhbW1pbmcua2lja3MtYXNzLm5ldAogICAgU2lnbmVkLW9m
Zi1ieTogSW5nbyBNb2xuYXIgPG1pbmdvQGtlcm5lbC5vcmc+Cgo6MDQwMDAwIDA0MDAwMCA5
Zjc0NDczOTM2YmQ0ZTYyMTExNWIyOTZiYjc0N2RmNTM2MGEwM2IyIGFkMTllYTkwMDVhNWFl
OTkyOWY2NGE3N2Q1ZTg4ODMyMDc3ODhkMzQgTQlrZXJuZWwKYmlzZWN0IHJ1biBzdWNjZXNz
CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtbGtwL3RpcDptYXN0
ZXI6NzQ2MDIzMTU5YzQwYzUyM2IwOGEzYmMzZDIxM2RhYzIxMjM4NTg5NTpiaXNlY3QtbmV0
CgoyMDEzLTEwLTE4LTE5OjEzOjMyIDc0NjAyMzE1OWM0MGM1MjNiMDhhM2JjM2QyMTNkYWMy
MTIzODU4OTUgcmV1c2UgL2tlcm5lbC94ODZfNjQtbGtwLzc0NjAyMzE1OWM0MGM1MjNiMDhh
M2JjM2QyMTNkYWMyMTIzODU4OTUvdm1saW51ei0zLjEyLjAtcmM0LTAwMTc2LWc3NDYwMjMx
CgoyMDEzLTEwLTE4LTE5OjEzOjMzIGRldGVjdGluZyBib290IHN0YXRlIC4uLi4uCTEJNQk2
Li4uCTcuLgk4CTkJMTAJMTEuCTEyLi4uLgkxNC4JMjAJMjIJMjkJMzQJMzkJNDAJNDcJNDkJ
NTAuLi4uCTU0CTU3Lgk2MC4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLgk2Mi4uCTYzIFNVQ0NFU1MKCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS94ODZfNjQtbGtwL3RpcDptYXN0ZXI6ZjNkYjM2Njk5Mzc5MTU5Yjc2MWNkYmMw
OTMzNDc4MjJhNjMzYzYxNjpiaXNlY3QtbmV0CiBURVNUIEZBSUxVUkUKWzMxNDVdIFdhdGNo
ZG9nIGlzIGFsaXZlClszMTM3XSBTdGFydGVkIHdhdGNoZG9nIHRocmVhZCAzMTQ1ClsgMTA1
Mi4zODc3OTVdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpbIDEwNTIu
MzkzNjEwXSBXQVJOSU5HOiBDUFU6IDAgUElEOiAzMTQ2IGF0IGtlcm5lbC9jcHUuYzo4NCBw
dXRfb25saW5lX2NwdXMrMHg0My8weDcwKCkKWyAxMDUyLjQwMjg5N10gTW9kdWxlcyBsaW5r
ZWQgaW46ClsgMTA1Mi40MDg2MDddIENQVTogMCBQSUQ6IDMxNDYgQ29tbTogdHJpbml0eS1j
aGlsZDAgTm90IHRhaW50ZWQgMy4xMi4wLXJjNS0wMTg4Mi1nZjNkYjM2NiAjMTE3MgpbIDEw
NTIuNDE3NDM3XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8w
MS8yMDExClsgMTA1Mi40MjI0NjFdICAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMWIyYjll
NTAgZmZmZmZmZmY4MWEyNDY0MyAwMDAwMDAwMDAwMDAwMDAwClsgMTA1Mi40MzEyNTZdICBm
ZmZmODgwMDFiMmI5ZTg4IGZmZmZmZmZmODEwYzNlNmIgZmZmZmZmZmY4MTBjM2ZlZiAwMDAw
MDAwMDAwMDAwMDAwClsgMTA1Mi40NDE4ODddICAwMDAwMDAwMDAwMDAwMDIwIDAwMDAwMDAw
MDAwMDY0ZmEgMDAwMDAwMDAwMGY1NTgwMCBmZmZmODgwMDFiMmI5ZTk4ClsgMTA1Mi40NTE4
MzldIENhbGwgVHJhY2U6ClsgMTA1Mi40NTU0MTddICBbPGZmZmZmZmZmODFhMjQ2NDM+XSBk
dW1wX3N0YWNrKzB4NGQvMHg2NgpbIDEwNTIuNDYwNTA0XSAgWzxmZmZmZmZmZjgxMGMzZTZi
Pl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg3Zi8weDk4ClsgMTA1Mi40NjYwMTZdICBbPGZm
ZmZmZmZmODEwYzNmZWY+XSA/IHB1dF9vbmxpbmVfY3B1cysweDQzLzB4NzAKWyAxMDUyLjQ3
MTMyNF0gIFs8ZmZmZmZmZmY4MTBjM2YzMj5dIHdhcm5fc2xvd3BhdGhfbnVsbCsweDFhLzB4
MWMKWyAxMDUyLjQ3ODU2N10gIFs8ZmZmZmZmZmY4MTBjM2ZlZj5dIHB1dF9vbmxpbmVfY3B1
cysweDQzLzB4NzAKWyAxMDUyLjQ4Mzg4OF0gIFs8ZmZmZmZmZmY4MTBlZmQ1OT5dIHNjaGVk
X3NldGFmZmluaXR5KzB4N2QvMHgxZjkKWyAxMDUyLjQ4OTMxMl0gIFs8ZmZmZmZmZmY4MTBl
ZmNlMT5dID8gc2NoZWRfc2V0YWZmaW5pdHkrMHg1LzB4MWY5ClsgMTA1Mi40OTQ1OTFdICBb
PGZmZmZmZmZmODFhMmY3MjQ+XSA/IF9yYXdfc3Bpbl91bmxvY2tfaXJxKzB4MmMvMHgzZQpb
IDEwNTIuNTAxMTQ5XSAgWzxmZmZmZmZmZjgxMGM3MDEyPl0gPyBkb19zZXRpdGltZXIrMHgx
OTQvMHgxZjUKWyAxMDUyLjUwNjQ2NV0gIFs8ZmZmZmZmZmY4MTBlZmYzNz5dIFN5U19zY2hl
ZF9zZXRhZmZpbml0eSsweDYyLzB4NzEKWyAxMDUyLjUxMTk1OV0gIFs8ZmZmZmZmZmY4MWEz
NzNhOT5dIHN5c3RlbV9jYWxsX2Zhc3RwYXRoKzB4MTYvMHgxYgpbIDEwNTIuNTE3NTY2XSAt
LS1bIGVuZCB0cmFjZSBmZmYxNGRlYmExYTUyODNlIF0tLS0KWyAxMDUyLjUyMzE3M10gLS0t
LS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tCi9rZXJuZWwveDg2XzY0LWxrcC9m
M2RiMzY2OTkzNzkxNTliNzYxY2RiYzA5MzM0NzgyMmE2MzNjNjE2L2RtZXNnLW5mc3Jvb3Qt
d2FpbWVhLTU6MjAxMzEwMTgxNjI1MTM6eDg2XzY0LWxrcDozLjEyLjAtcmM1LTAxODgyLWdm
M2RiMzY2OjExNzIKL2tlcm5lbC94ODZfNjQtbGtwL2YzZGIzNjY5OTM3OTE1OWI3NjFjZGJj
MDkzMzQ3ODIyYTYzM2M2MTYvZG1lc2cteW9jdG8tcm9hbS0zMToyMDEzMTAxODAzNDQwNTp4
ODZfNjQtbGtwOjMuMTIuMC1yYzUtMDE4ODItZ2YzZGIzNjY6MTE3Mgova2VybmVsL3g4Nl82
NC1sa3AvZjNkYjM2Njk5Mzc5MTU5Yjc2MWNkYmMwOTMzNDc4MjJhNjMzYzYxNi9kbWVzZy1x
dWFudGFsLWlubi0zMToyMDEzMTAxODAzNDgxNzp4ODZfNjQtbGtwOjMuMTIuMC1yYzUtMDE4
ODItZ2YzZGIzNjY6MTE3Mgova2VybmVsL3g4Nl82NC1sa3AvZjNkYjM2Njk5Mzc5MTU5Yjc2
MWNkYmMwOTMzNDc4MjJhNjMzYzYxNi9kbWVzZy15b2N0by1uaG00LTQ6MjAxMzEwMTgwMDQy
MzU6eDg2XzY0LWxrcDozLjEyLjAtcmM1LTAxODgyLWdmM2RiMzY2OjExNzIKL2tlcm5lbC94
ODZfNjQtbGtwL2YzZGIzNjY5OTM3OTE1OWI3NjFjZGJjMDkzMzQ3ODIyYTYzM2M2MTYvZG1l
c2cteW9jdG8taW5uLTQ3OjIwMTMxMDE4MDM0NDA3Ong4Nl82NC1sa3A6My4xMi4wLXJjNS0w
MTg4Mi1nZjNkYjM2NjoxMTcyCi9rZXJuZWwveDg2XzY0LWxrcC9mM2RiMzY2OTkzNzkxNTli
NzYxY2RiYzA5MzM0NzgyMmE2MzNjNjE2L2RtZXNnLW5mc3Jvb3QtbGtwLXR0MDItNjoyMDEz
MTAxNzIzMTE1ODp4ODZfNjQtbGtwOjMuMTIuMC1yYzUtMDE4ODItZ2YzZGIzNjY6MTE3Mgov
a2VybmVsL3g4Nl82NC1sa3AvZjNkYjM2Njk5Mzc5MTU5Yjc2MWNkYmMwOTMzNDc4MjJhNjMz
YzYxNi9kbWVzZy15b2N0by1hdGhlbnMtMjU6MjAxMzEwMTgwODM1MzU6eDg2XzY0LWxrcDoz
LjEyLjAtcmM1LTAxODgyLWdmM2RiMzY2OjExNzIKL2tlcm5lbC94ODZfNjQtbGtwL2YzZGIz
NjY5OTM3OTE1OWI3NjFjZGJjMDkzMzQ3ODIyYTYzM2M2MTYvZG1lc2ctcXVhbnRhbC1sa3At
c3QwMS03OjIwMTMxMDE4MDM0NDE0Ong4Nl82NC1sa3A6My4xMi4wLXJjNS0wMTg4Mi1nZjNk
YjM2NjoxMTcyCi9rZXJuZWwveDg2XzY0LWxrcC9mM2RiMzY2OTkzNzkxNTliNzYxY2RiYzA5
MzM0NzgyMmE2MzNjNjE2L2RtZXNnLXlvY3RvLXJvYW0tMTM6MjAxMzEwMTgwMzQ5NTg6eDg2
XzY0LWxrcDozLjEyLjAtcmM1LTAxODgyLWdmM2RiMzY2OjExNzIKL2tlcm5lbC94ODZfNjQt
bGtwL2YzZGIzNjY5OTM3OTE1OWI3NjFjZGJjMDkzMzQ3ODIyYTYzM2M2MTYvZG1lc2ctcXVh
bnRhbC1uaG00LTM6MjAxMzEwMTcxOTU4MDA6eDg2XzY0LWxrcDozLjEyLjAtcmM1LTAxODgy
LWdmM2RiMzY2OjExNzIKL2tlcm5lbC94ODZfNjQtbGtwL2YzZGIzNjY5OTM3OTE1OWI3NjFj
ZGJjMDkzMzQ3ODIyYTYzM2M2MTYvZG1lc2ctbmZzcm9vdC14aWFuLTg6MjAxMzEwMTgwODM1
MDE6eDg2XzY0LWxrcDozLjEyLjAtcmM1LTAxODgyLWdmM2RiMzY2OjExNzIKL2tlcm5lbC94
ODZfNjQtbGtwL2YzZGIzNjY5OTM3OTE1OWI3NjFjZGJjMDkzMzQ3ODIyYTYzM2M2MTYvZG1l
c2ctbmZzcm9vdC1yb2FtLTIxOjIwMTMxMDE4MDM0OTQ3Ong4Nl82NC1sa3A6My4xMi4wLXJj
NS0wMTg4Mi1nZjNkYjM2NjoxMTcyCi9rZXJuZWwveDg2XzY0LWxrcC9mM2RiMzY2OTkzNzkx
NTliNzYxY2RiYzA5MzM0NzgyMmE2MzNjNjE2L2RtZXNnLW5mc3Jvb3QtamFrZXRvd24tMTA6
MjAxMzEwMTgwNDAwMTY6eDg2XzY0LWxrcDozLjEyLjAtcmM1LTAxODgyLWdmM2RiMzY2OjEx
NzIKL2tlcm5lbC94ODZfNjQtbGtwL2YzZGIzNjY5OTM3OTE1OWI3NjFjZGJjMDkzMzQ3ODIy
YTYzM2M2MTYvZG1lc2ctbmZzcm9vdC13YWltZWEtNzoyMDEzMTAxODE2MjQ1ODp4ODZfNjQt
bGtwOjMuMTIuMC1yYzUtMDE4ODItZ2YzZGIzNjY6MTE3Mgova2VybmVsL3g4Nl82NC1sa3Av
ZjNkYjM2Njk5Mzc5MTU5Yjc2MWNkYmMwOTMzNDc4MjJhNjMzYzYxNi9kbWVzZy1xdWFudGFs
LXdhaW1lYS0zOjIwMTMxMDE4MTYyNTAxOng4Nl82NC1sa3A6My4xMi4wLXJjNS0wMTg4Mi1n
ZjNkYjM2NjoxMTcyCjM6MTU6MTYgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCltkZXRh
Y2hlZCBIRUFEIDhkZjVmMmZdIFJldmVydCAic2NoZWQ6IFJlbW92ZSBnZXRfb25saW5lX2Nw
dXMoKSB1c2FnZSIKIDMgZmlsZXMgY2hhbmdlZCwgMTUgaW5zZXJ0aW9ucygrKSwgNDggZGVs
ZXRpb25zKC0pCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtbGtw
L3RpcDptYXN0ZXI6OGRmNWYyZjc3MjRiYTY1NjZlOTJjODdjZjIzNTQ3MzVhYWM0YjllZDpi
aXNlY3QtbmV0CgoyMDEzLTEwLTE4LTIwOjAxOjA4IDhkZjVmMmY3NzI0YmE2NTY2ZTkyYzg3
Y2YyMzU0NzM1YWFjNGI5ZWQgY29tcGlsaW5nCgoyMDEzLTEwLTE4LTIwOjA1OjU1IGRldGVj
dGluZyBib290IHN0YXRlIDMuMTIuMC1yYzUtMDE4ODMtZzhkZjVmMmYuLi4uLgkxLi4JMi4u
Li4uLi4uLgkzLgk1CTYJOAkxNS4JMTcuLgkyMAkyNAkyNQkzMwkzNQkzNgkzOS4uCTQwCTQx
Li4uLi4uCTQyLi4uCTQ0Lgk0Nwk0OAk0OQk1MC4uLi4uLi4uCTUxLi4uLi4uLi4uLi4uLi4u
Lgk1Mi4uLi4uLi4JNTMJNTUJNTgJNTkuCTYxCTYyCTYzIFNVQ0NFU1MKCgo9PT09PT09PT0g
dXBzdHJlYW0gPT09PT09PT09CkZldGNoaW5nIGxpbnVzCmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS94ODZfNjQtbGtwL3RpcDptYXN0ZXI6MDQ5MTlhZmI4NWM4ZjAwN2I3
MzI2YzRkYTVlYjYxYzUyZTkxYjljNzpiaXNlY3QtbmV0CgoyMDEzLTEwLTE4LTIwOjU0OjAy
IDA0OTE5YWZiODVjOGYwMDdiNzMyNmM0ZGE1ZWI2MWM1MmU5MWI5YzcgcmV1c2UgL2tlcm5l
bC94ODZfNjQtbGtwLzA0OTE5YWZiODVjOGYwMDdiNzMyNmM0ZGE1ZWI2MWM1MmU5MWI5Yzcv
dm1saW51ei0zLjEyLjAtcmM1LTAwMTIzLWcwNDkxOWFmCgoyMDEzLTEwLTE4LTIwOjU0OjAy
IGRldGVjdGluZyBib290IHN0YXRlIC4uLi4uLgkxMAkxMS4uLi4uLi4JMTIuLi4JMTQJMTUu
CTE2CTE3CTIwLi4JMjEJMjMJMjUJMjYuCTI4LgkyOQkzMQkzMgk0Mgk0Ngk0OQk1Mi4JNTUJ
NTYJNTcuCTU4Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTU5Li4JNjAJNjEJNjIu
CTYzIFNVQ0NFU1MKCgo9PT09PT09PT0gbGludXgtbmV4dCA9PT09PT09PT0KRmV0Y2hpbmcg
bmV4dApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LWxrcC90aXA6
bWFzdGVyOmEwY2YxYWJjMjVhYzE5N2RkOTdiODU3YzBmNjM0MTA2NmE4Y2IxY2Y6YmlzZWN0
LW5ldAoKMjAxMy0xMC0xOC0yMTozNjo0MSBhMGNmMWFiYzI1YWMxOTdkZDk3Yjg1N2MwZjYz
NDEwNjZhOGNiMWNmIGNvbXBpbGluZwoKMjAxMy0xMC0xOC0yMTo0NzozOCBkZXRlY3Rpbmcg
Ym9vdCBzdGF0ZSAzLjEyLjAtcmMyLW5leHQtMjAxMzA5MjctMDMxMDAtZ2EwY2YxYWIuLi4u
Li4uLgkxLgkzLi4uLi4uLi4uCTYuLi4uCTcuCTkJMTAuCTExCTE0CTE1CTE2CTIyCTI2CTMz
LgkzNS4JMzkJNDAJNDQJNDkJNTAJNTMJNTQuLi4uLi4uLi4uLgk1Ngk1OC4uLgk2MC4uLi4u
Li4uLi4uLgk2MS4uLi4uLgk2MyBTVUNDRVNTCgoKPT09PT09PT09IHRpcC9tYXN0ZXIgPT09
PT09PT09CkZldGNoaW5nIHRpcApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
eDg2XzY0LWxrcC90aXA6bWFzdGVyOjU3NGM2NTNlZTkwNjJhOGZjYzYxOWU3ZWM4M2EzNmJh
MmRmYzVhMjY6YmlzZWN0LW5ldAoKMjAxMy0xMC0xOC0yMjoyOTo1NSA1NzRjNjUzZWU5MDYy
YThmY2M2MTllN2VjODNhMzZiYTJkZmM1YTI2IGNvbXBpbGluZwoKMjAxMy0xMC0xOC0yMjoz
NjoxNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAtcmM1LTAyMDI4LWc1NzRjNjUzLi4u
Li4uLi4uLi4uLi4gVEVTVCBGQUlMVVJFClszMTM4XSBXYXRjaGRvZyBpcyBhbGl2ZQpbMzEz
MV0gU3RhcnRlZCB3YXRjaGRvZyB0aHJlYWQgMzEzOApbICAyMDMuNjMxMjIzXSAtLS0tLS0t
LS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgMjAzLjYzMjg3MV0gV0FSTklORzog
Q1BVOiAwIFBJRDogMzEzOSBhdCBrZXJuZWwvY3B1LmM6ODQgcHV0X29ubGluZV9jcHVzKzB4
NDMvMHg3MCgpClsgIDIwMy42MzU4NTNdIE1vZHVsZXMgbGlua2VkIGluOgpbICAyMDMuNjM3
MzQ4XSBDUFU6IDAgUElEOiAzMTM5IENvbW06IHRyaW5pdHktY2hpbGQwIE5vdCB0YWludGVk
IDMuMTIuMC1yYzUtMDIwMjgtZzU3NGM2NTMgIzQ2MApbICAyMDMuNjQwMzAxXSBIYXJkd2Fy
ZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgIDIwMy42NDIx
NDldICAwMDAwMDAwMDAwMDAwMDAwIGZmZmY4ODAwMWE2OTdlNTAgZmZmZmZmZmY4MWEyMTcw
MyAwMDAwMDAwMDAwMDAwMDAwClsgIDIwMy42NDU0NjBdICBmZmZmODgwMDFhNjk3ZTg4IGZm
ZmZmZmZmODEwYzNlNmIgZmZmZmZmZmY4MTBjM2ZlZiAwMDAwMDAwMDAwMDAwMDAwClsgIDIw
My42NDg3NzZdICAwMDAwMDAwMDAwMDAwMDIwIDAwMDAwMDAwMDAwMDI1ZDAgMDAwMDAwMDAw
MGY1NWZmZiBmZmZmODgwMDFhNjk3ZTk4ClsgIDIwMy42NTIwOTddIENhbGwgVHJhY2U6Clsg
IDIwMy42NTMyNzVdICBbPGZmZmZmZmZmODFhMjE3MDM+XSBkdW1wX3N0YWNrKzB4NGQvMHg2
NgpbICAyMDMuNjU1MDE3XSAgWzxmZmZmZmZmZjgxMGMzZTZiPl0gd2Fybl9zbG93cGF0aF9j
b21tb24rMHg3Zi8weDk4ClsgIDIwMy42NTY5NDFdICBbPGZmZmZmZmZmODEwYzNmZWY+XSA/
IHB1dF9vbmxpbmVfY3B1cysweDQzLzB4NzAKWyAgMjAzLjY1ODc4NF0gIFs8ZmZmZmZmZmY4
MTBjM2YzMj5dIHdhcm5fc2xvd3BhdGhfbnVsbCsweDFhLzB4MWMKWyAgMjAzLjY2MDY4OF0g
IFs8ZmZmZmZmZmY4MTBjM2ZlZj5dIHB1dF9vbmxpbmVfY3B1cysweDQzLzB4NzAKWyAgMjAz
LjY2MjU1MF0gIFs8ZmZmZmZmZmY4MTBlZjI0ND5dIHNjaGVkX3NldGFmZmluaXR5KzB4N2Qv
MHgxZjkKWyAgMjAzLjY2NDQ5Ml0gIFs8ZmZmZmZmZmY4MTBlZjFjYz5dID8gc2NoZWRfc2V0
YWZmaW5pdHkrMHg1LzB4MWY5ClsgIDIwMy42NjYzMzFdICBbPGZmZmZmZmZmODFhMmM3ZTQ+
XSA/IF9yYXdfc3Bpbl91bmxvY2tfaXJxKzB4MmMvMHgzZQpbICAyMDMuNjY4MjYxXSAgWzxm
ZmZmZmZmZjgxMGM3MDEyPl0gPyBkb19zZXRpdGltZXIrMHgxOTQvMHgxZjUKWyAgMjAzLjY3
MDEzNl0gIFs8ZmZmZmZmZmY4MTBlZjQyMj5dIFN5U19zY2hlZF9zZXRhZmZpbml0eSsweDYy
LzB4NzEKWyAgMjAzLjY3MzA5M10gIFs8ZmZmZmZmZmY4MWEzNDQ2OT5dIHN5c3RlbV9jYWxs
X2Zhc3RwYXRoKzB4MTYvMHgxYgpbICAyMDMuNjc1MTEwXSAtLS1bIGVuZCB0cmFjZSA2MDRh
ZDgxZjIzYjA2YmIxIF0tLS0KWyAgMjAzLjY3ODA4OF0gd2FybmluZzogcHJvY2VzcyBgdHJp
bml0eS1jaGlsZDAnIHVzZWQgdGhlIGRlcHJlY2F0ZWQgc3lzY3RsIHN5c3RlbSBjYWxsIHdp
dGggCi9rZXJuZWwveDg2XzY0LWxrcC81NzRjNjUzZWU5MDYyYThmY2M2MTllN2VjODNhMzZi
YTJkZmM1YTI2L2RtZXNnLW5mc3Jvb3Qtd2FpbWVhLTI6MjAxMzEwMTkwNjM2Mzc6eDg2XzY0
LWxrcDozLjEyLjAtcmM1LTAyMDI4LWc1NzRjNjUzOjQ2MAova2VybmVsL3g4Nl82NC1sa3Av
NTc0YzY1M2VlOTA2MmE4ZmNjNjE5ZTdlYzgzYTM2YmEyZGZjNWEyNi9kbWVzZy1xdWFudGFs
LWxrcC1zdDAxLTExOjIwMTMxMDE4MjI0MzEyOng4Nl82NC1sa3A6My4xMi4wLXJjNS0wMjAy
OC1nNTc0YzY1Mzo0NjAKMDoyOjIgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCg==

--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.12.0-rc5-01882-gf3db366"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.12.0-rc5 Kernel Configuration
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
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
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
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
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
# CONFIG_NO_HZ_FULL is not set
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
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
# CONFIG_RCU_USER_QS is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_NOCB_CPU=y
CONFIG_RCU_NOCB_CPU_NONE=y
# CONFIG_RCU_NOCB_CPU_ZERO is not set
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=20
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_ARCH_USES_NUMA_PROT_NONE=y
# CONFIG_NUMA_BALANCING_DEFAULT_ENABLED is not set
CONFIG_NUMA_BALANCING=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_SWAP_ENABLED=y
CONFIG_MEMCG_KMEM=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
# CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
# CONFIG_SCHED_AUTOGROUP is not set
CONFIG_MM_OWNER=y
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
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
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

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_UPROBES=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
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
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

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
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set
CONFIG_BLOCK_COMPAT=y

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
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
# CONFIG_KVMTOOL_TEST_ENABLE is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
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
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=256
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
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
# CONFIG_MOVABLE_NODE is not set
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_BALLOON_COMPACTION=y
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
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_TEST_SUSPEND=y
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
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
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ_CPB=y
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
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_IOAPIC=y
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
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
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
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
CONFIG_IP_MROUTE=y
# CONFIG_IP_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=y
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
# CONFIG_TCP_CONG_CUBIC is not set
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
CONFIG_DEFAULT_BIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="bic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_GRE is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
# CONFIG_NET_SCTPPROBE is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_COOKIE_HMAC_SHA1 is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_VLAN_8021Q_MVRP is not set
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
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
# CONFIG_DMA_SHARED_BUFFER is not set

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
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
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ATMEL_SSC is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
CONFIG_SCSI_ACARD=y
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=4
CONFIG_AIC7XXX_RESET_DELAY_MS=15000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC7XXX_OLD=y
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=4
CONFIG_AIC79XX_RESET_DELAY_MS=15000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC94XX=y
# CONFIG_AIC94XX_DEBUG is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_MPT2SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS_LOGGING is not set
CONFIG_SCSI_MPT3SAS=m
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
# CONFIG_SCSI_MPT3SAS_LOGGING is not set
# CONFIG_SCSI_UFSHCD is not set
CONFIG_SCSI_HPTIOP=y
CONFIG_SCSI_BUSLOGIC=y
# CONFIG_SCSI_FLASHPOINT is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
CONFIG_SCSI_GDTH=y
CONFIG_SCSI_ISCI=m
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLA_FC=y
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
CONFIG_SCSI_DEBUG=y
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=y
# CONFIG_SCSI_CHELSIO_FCOE is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
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
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
# CONFIG_SATA_HIGHBANK is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_RCAR is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_AUTODETECT is not set
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MD_MULTIPATH=y
CONFIG_MD_FAULTY=y
CONFIG_BCACHE=y
# CONFIG_BCACHE_DEBUG is not set
# CONFIG_BCACHE_EDEBUG is not set
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=y
CONFIG_DM_BIO_PRISON=y
CONFIG_DM_PERSISTENT_DATA=y
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
# CONFIG_DM_THIN_PROVISIONING is not set
CONFIG_DM_CACHE=y
CONFIG_DM_CACHE_MQ=y
CONFIG_DM_CACHE_CLEANER=y
CONFIG_DM_MIRROR=y
# CONFIG_DM_RAID is not set
# CONFIG_DM_LOG_USERSPACE is not set
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
# CONFIG_DM_MULTIPATH_QL is not set
# CONFIG_DM_MULTIPATH_ST is not set
CONFIG_DM_DELAY=y
# CONFIG_DM_UEVENT is not set
CONFIG_DM_FLAKEY=y
# CONFIG_DM_VERITY is not set
# CONFIG_DM_SWITCH is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=40
CONFIG_FUSION_CTL=y
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=y
# CONFIG_NLMON is not set
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
# CONFIG_NET_DSA_MV88E6XXX is not set
# CONFIG_NET_DSA_MV88E6060 is not set
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
CONFIG_ACENIC=y
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_NET_VENDOR_AMD=y
CONFIG_AMD8111_ETH=y
CONFIG_PCNET32=y
# CONFIG_PCMCIA_NMCLAN is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
CONFIG_ATL1=y
CONFIG_ATL1E=y
CONFIG_ATL1C=y
# CONFIG_ALX is not set
CONFIG_NET_CADENCE=y
# CONFIG_ARM_AT91_ETHER is not set
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
CONFIG_BNX2=y
# CONFIG_CNIC is not set
CONFIG_TIGON3=y
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
CONFIG_TULIP=y
# CONFIG_TULIP_MWI is not set
# CONFIG_TULIP_MMIO is not set
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=y
CONFIG_WINBOND_840=y
CONFIG_DM9102=y
CONFIG_ULI526X=y
# CONFIG_PCMCIA_XIRCOM is not set
CONFIG_NET_VENDOR_DLINK=y
CONFIG_DL2K=y
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_FUJITSU=y
# CONFIG_PCMCIA_FMVJ18X is not set
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=y
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
# CONFIG_IGBVF is not set
CONFIG_IXGB=y
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
# CONFIG_IXGBEVF is not set
# CONFIG_I40E is not set
CONFIG_NET_VENDOR_I825XX=y
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
CONFIG_SKGE=y
CONFIG_SKGE_DEBUG=y
# CONFIG_SKGE_GENESIS is not set
CONFIG_SKY2=y
CONFIG_SKY2_DEBUG=y
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_MLX5_CORE is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_8390=y
# CONFIG_PCMCIA_AXNET is not set
CONFIG_NE2K_PCI=y
# CONFIG_PCMCIA_PCNET is not set
CONFIG_NET_VENDOR_NVIDIA=y
CONFIG_FORCEDETH=y
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_8139CP=y
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=y
# CONFIG_SH_ETH is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
CONFIG_SIS900=y
# CONFIG_SIS190 is not set
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_PCMCIA_SMC91C92 is not set
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
CONFIG_VIA_RHINE=y
# CONFIG_VIA_RHINE_MMIO is not set
CONFIG_VIA_VELOCITY=y
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_NET_VENDOR_XIRCOM=y
# CONFIG_PCMCIA_XIRC2PS is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
# CONFIG_AMD_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
CONFIG_BROADCOM_PHY=y
# CONFIG_BCM87XX_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=y
# CONFIG_USB_RTL8152 is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=y
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=y
# CONFIG_USB_NET_CDC_MBIM is not set
CONFIG_USB_NET_DM9601=y
# CONFIG_USB_NET_SR9700 is not set
CONFIG_USB_NET_SMSC75XX=y
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=y
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_NET_QMI_WWAN is not set
CONFIG_USB_NET_INT51X1=y
CONFIG_USB_IPHETH=y
CONFIG_USB_SIERRA_NET=y
# CONFIG_USB_VL600 is not set
CONFIG_WLAN=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_HOSTAP is not set
# CONFIG_WL_TI is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
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
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
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
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
# CONFIG_GAMEPORT is not set

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
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
# CONFIG_N_HDLC is not set
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
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_ST_ASC is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
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
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
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

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
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
CONFIG_GPIO_DEVRES=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_HTU21 is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IBMAEM is not set
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
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
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_CPU_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_X86_PKG_TEMP_THERMAL=m

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
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
# CONFIG_IE6XX_WDT is not set
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
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
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_LPC_ICH=y
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
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
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_EXYNOS_VIDEO is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
# CONFIG_HID_APPLEIR is not set
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_HUION is not set
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=m
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=y
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

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
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_FUSBH200_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HSIC_USB3503 is not set

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_AM335X_PHY_USB is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_RCAR_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_GHES=y
CONFIG_EDAC_E752X=y
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I7CORE is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
# CONFIG_EDAC_SBRIDGE is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF2127 is not set
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set
# CONFIG_RTC_DRV_DS2404 is not set

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MOXART is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_CHROMEOS_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_ARM_ARCH_TIMER_EVTSTREAM is not set
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set
# CONFIG_INTEL_IOMMU is not set
# CONFIG_IRQ_REMAP is not set

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
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
# CONFIG_EFI_VARS is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_DEBUG=y
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_NTFS_FS is not set

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
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_FTRACE is not set
# CONFIG_PSTORE_RAM is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_F2FS_FS is not set
# CONFIG_EFIVAR_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V2=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
# CONFIG_NFS_V4_2 is not set
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
CONFIG_ROOT_NFS=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFSD=y
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
# CONFIG_NFSD_FAULT_INJECTION is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_SUNRPC_DEBUG is not set
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
# CONFIG_CIFS_UPCALL is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_ACL is not set
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_SMB2 is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
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
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
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
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
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
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
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
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
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
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
# CONFIG_MMIOTRACE_TEST is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_DMA_API_DEBUG=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
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
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
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
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m
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
# CONFIG_CRYPTO_CRCT10DIF_PCLMUL is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
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
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
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
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
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
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_BINARY_PRINTF=y

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
CONFIG_PERCPU_RWSEM=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
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
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y

--UugvWAfsgieZRqgk--
