Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbbAYEe4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 23:34:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:45915 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbbAYEes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 23:34:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="444747987"
Date: Sat, 24 Jan 2015 20:34:28 -0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: [perf] WARNING: CPU: 0 PID: 1457 at kernel/events/core.c:890
 add_event_to_ctx()
Message-ID: <20150125043428.GA6109@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git perf/core

commit d26bb7f73a2881f2412c340a27438b185f0cc3dc
Author:     Mark Rutland <mark.rutland@arm.com>
AuthorDate: Wed Jan 7 15:01:54 2015 +0000
Commit:     Peter Zijlstra <peterz@infradead.org>
CommitDate: Fri Jan 23 15:17:56 2015 +0100

    perf: decouple unthrottling and rotating
    
    Currently the adjusments made as part of perf_event_task_tick use the
    percpu rotation lists to iterate over any active PMU contexts, but these
    are not used by the context rotation code, having been replaced by
    separate (per-context) hrtimer callbacks. However, some manipulation of
    the rotation lists (i.e. removal of contexts) has remained in
    perf_rotate_context. This leads to the following issues:
    
    * Contexts are not always removed from the rotation lists. Removal of
      PMUs which have been placed in rotation lists, but have not been
      removed by a hrtimer callback can result in corruption of the rotation
      lists (when memory backing the context is freed).
    
      This has been observed to result in hangs when PMU drivers built as
      modules are inserted and removed around the creation of events for
      said PMUs.
    
    * Contexts which do not require rotation may be removed from the
      rotation lists as a result of a hrtimer, and will not be considered by
      the unthrottling code in perf_event_task_tick.
    
    This patch solves these issues by moving any and all removal of contexts
    from rotation lists to only occur when the final event is removed from a
    context, mirroring the addition which only occurs when the first event
    is added to a context. The vestigal manipulation of the rotation lists
    is removed from perf_event_rotate_context.
    
    As the rotation_list variables are not used for rotation, these are
    renamed to active_ctx_list, which better matches their current function.
    perf_pmu_rotate_{start,stop} are renamed to
    perf_pmu_ctx_{activate,deactivate}.
    
    Cc: Will Deacon <will.deacon@arm.com>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Ingo Molnar <mingo@redhat.com>
    Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
    Cc: Will Deacon <will.deacon@arm.com>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Ingo Molnar <mingo@redhat.com>
    Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
    Cc: Mark Rutland <mark.rutland@arm.com>
    Signed-off-by: Mark Rutland <mark.rutland@arm.com>
    Reported-by: Johannes Jensen <johannes.jensen@arm.com>
    Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
    Link: http://lkml.kernel.org/r/1420642914-22760-1-git-send-email-mark.rutland@arm.com

===================================================
PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
===================================================

Attached dmesg for the parent commit, too, to help confirm whether it is a noise error.
Fengguang: the old OOM errors look like independent noises. 

+------------------------------------------------------------------+------------+------------+------------+
|                                                                  | 2e67200461 | d26bb7f73a | b0f9997908 |
+------------------------------------------------------------------+------------+------------+------------+
| boot_successes                                                   | 0          | 0          | 0          |
| boot_failures                                                    | 1900       | 900        | 22         |
| page_allocation_failure:order:#,mode                             | 1040       | 567        | 10         |
| Kernel_panic-not_syncing:Out_of_memory_and_no_killable_processes | 1040       | 567        | 10         |
| backtrace:ring_buffer_consumer_thread                            | 1040       | 567        | 10         |
| backtrace:lock_torture_stats                                     | 1040       | 567        | 10         |
| WARNING:at_net/netlink/genetlink.c:#genl_unbind()                | 860        | 54         |            |
| backtrace:do_group_exit                                          | 860        | 5          |            |
| backtrace:SyS_exit_group                                         | 860        | 5          |            |
| backtrace:netlink_setsockopt                                     | 236        | 49         |            |
| backtrace:SyS_setsockopt                                         | 236        | 49         |            |
| backtrace:SyS_socketcall                                         | 236        | 49         |            |
| WARNING:at_kernel/events/core.c:#add_event_to_ctx()              | 0          | 333        | 12         |
| BUG:kernel_test_hang                                             | 0          | 333        | 12         |
| backtrace:inherit_group                                          | 0          | 328        | 12         |
| backtrace:perf_event_init_task                                   | 0          | 328        | 12         |
| backtrace:do_fork                                                | 0          | 328        | 12         |
| backtrace:SyS_clone                                              | 0          | 328        | 12         |
| backtrace:perf_install_in_context                                | 0          | 5          |            |
| backtrace:SyS_perf_event_open                                    | 0          | 5          |            |
+------------------------------------------------------------------+------------+------------+------------+

[main] Setsockopt(1 8 80d1000 4) on fd 86 [1:1:1]
[main] Setsockopt(1 2a 80d1000 4) on fd 87 [1:1:1]
[   34.700861] ------------[ cut here ]------------
[   34.701372] WARNING: CPU: 0 PID: 1457 at kernel/events/core.c:890 add_event_to_ctx+0x253/0x270()
[   34.702515] CPU: 0 PID: 1457 Comm: trinity-main Not tainted 3.19.0-rc4-gd26bb7f #2
[   34.702931]  00000000 00000000 c0911e2c cd8a61df c0911e48 cd052cfa 0000037a cd0d32f3
[   34.702931]  c0c206d0 c0c20590 d3c9e0a0 c0911e58 cd052dd4 00000009 00000000 c0911e78
[   34.702931]  cd0d32f3 d3c9e214 00000000 00000000 c0c20598 00000246 c0c50990 c0911e90
[   34.702931] Call Trace:
[   34.702931]  [<cd8a61df>] dump_stack+0x16/0x18
[   34.702931]  [<cd052cfa>] warn_slowpath_common+0x6a/0xa0
[   34.702931]  [<cd0d32f3>] ? add_event_to_ctx+0x253/0x270
[   34.702931]  [<cd052dd4>] warn_slowpath_null+0x14/0x20
[   34.702931]  [<cd0d32f3>] add_event_to_ctx+0x253/0x270
[   34.702931]  [<cd0da60f>] inherit_event+0xef/0x240
[   34.702931]  [<cd0da778>] inherit_group+0x18/0x70
[   34.702931]  [<cd0d2884>] ? alloc_perf_context+0x24/0x50
[   34.702931]  [<cd0db927>] perf_event_init_task+0x117/0x310
[   34.702931]  [<cd050c67>] copy_process+0x477/0x14f0
[   34.702931]  [<cd052063>] do_fork+0xb3/0x430
[   34.702931]  [<cd0923fd>] ? do_setitimer+0x13d/0x220
[   34.702931]  [<cd09251a>] ? alarm_setitimer+0x3a/0x60
[   34.702931]  [<cd05246b>] SyS_clone+0x1b/0x20
[   34.702931]  [<cd8ad3bd>] syscall_call+0x7/0x7
[   34.702931]  [<cd8a0000>] ? xen_chk_extra_mem+0x10/0x70
[   34.702931] ---[ end trace 19d6cac21f26a758 ]---

git bisect start b0f99979082f6aafe6f2d4342e44907a4bb6b710 ec6f34e5b552fb0a52e6aae1a5afbbb1605cc6cc --
git bisect  bad 7c4e3ef2ae4f008776d1d2d13c862179146bbb07  # 08:44      0-     28  Merge 'arm-platforms/irq/die-gic-arch-extn-die-die-die' into devel-roam-rand-201501240027
git bisect  bad 5dcbd81bc253c6fb786a3c4d0c2304d00353cc83  # 08:45      0-    928  Merge 'peterz-queue/perf/urgent' into devel-roam-rand-201501240027
git bisect good bd0e15d797d00b7115e1950ee13fec7ce001f064  # 09:09    900+    900  Merge 'peterz-queue/locking/core' into devel-roam-rand-201501240027
git bisect  bad d8c008a82490f75ca16101567e167213486288aa  # 10:14    351-    358  Merge 'peterz-queue/perf/core' into devel-roam-rand-201501240027
git bisect  bad 18966e0b34261132be50b8624be368db80b529cf  # 11:19    291-    293  perf, x86: use context switch callback to flush LBR stack
git bisect good 44b4c3b252ffefe36900df247d528e9550ee20c4  # 12:31    900+    900  perf: Add pmu callbacks to track event mapping and unmapping
git bisect  bad d26bb7f73a2881f2412c340a27438b185f0cc3dc  # 13:34    509-    510  perf: decouple unthrottling and rotating
git bisect good e8923a02fab8e3a2e74cebace2ae73cbf1f0dd09  # 14:00    900+    900  x86, perf: Only allow rdpmc if a perf_event is mapped
git bisect good 2e67200461d1eec17062de4947d07f3e6afd0848  # 14:26    900+    900  x86, perf: Add /sys/devices/cpu/rdpmc=2 to allow rdpmc for all tasks
# first bad commit: [d26bb7f73a2881f2412c340a27438b185f0cc3dc] perf: decouple unthrottling and rotating
git bisect good 2e67200461d1eec17062de4947d07f3e6afd0848  # 14:44   1000+   1900  x86, perf: Add /sys/devices/cpu/rdpmc=2 to allow rdpmc for all tasks
# extra tests with DEBUG_INFO
# extra tests on HEAD of linux-devel/devel-roam-rand-201501240027
git bisect  bad b0f99979082f6aafe6f2d4342e44907a4bb6b710  # 14:48      0-     22  0day head guard for 'devel-roam-rand-201501240027'
# extra tests on tree/branch peterz-queue/perf/core
git bisect  bad 6f637dfc22bc3e963c6936cdf1bb6550a9d3e955  # 16:02    274-    278  perf,powerpc: Fix up flush_branch_stack users
# extra tests on tree/branch linus/master
git bisect good c4e00f1d31c4c83d15162782491689229bd92527  # 17:12   1000+    644  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
# extra tests on tree/branch next/master
git bisect good de3d2c5b941c632685ab58613f981bf14a42676f  # 17:23   1000+    528  Add linux-next specific files for 20150123


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-i386.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-cpu kvm64
	-enable-kvm
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
	panic=-1
	softlockup_panic=1
	nmi_watchdog=panic
	oops=panic
	load_ramdisk=2
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

--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-ivb41-39:20150124134027:i386-randconfig-r2-0121:3.19.0-rc4-gd26bb7f:2"
Content-Transfer-Encoding: quoted-printable

early console in setup code
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.19.0-rc4-gd26bb7f (kbuild@roam) (gcc version=
 4.9.1 (Debian 4.9.1-19) ) #2 Sat Jan 24 12:33:19 CST 2015
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x1000000
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
[    0.000000] found SMP MP-table at [mem 0x000f0ed0-0x000f0edf] mapped at =
[c00f0ed0]
[    0.000000]   mpc: f0ee0-f0fb0
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x0e9fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 4k
[    0.000000] BRK [0x0e498000, 0x0e498fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x139fffff]
[    0.000000]  [mem 0x00100000-0x139fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13fdffff]
[    0.000000]  [mem 0x13c00000-0x13fdffff] page 4k
[    0.000000] BRK [0x0e499000, 0x0e499fff] PGTABLE
[    0.000000] BRK [0x0e49a000, 0x0e49afff] PGTABLE
[    0.000000] BRK [0x0e49b000, 0x0e49bfff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13ca5000-0x13fd7fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000F0CF0 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FE1854 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FE0B37 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACS 0x13FE0000 000040
[    0.000000] ACPI: SSDT 0x13FE0BAB 000BF9 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FE17A4 000078 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FE181C 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13fe0000
[    0.000000]   low ram: 0 - 13fe0000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13fdf001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x13fdffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000] free_area_init_node: node 0, pgdat cdcf6c80, node_mem_map d3=
958020
[    0.000000]   Normal zone: 640 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 81790 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffb000 (fec00000)
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr dc37340
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81150
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-r=
andconfig-r2-0121/linux-devel:devel-roam-rand-201501240027:d26bb7f73a2881f2=
412c340a27438b185f0cc3dc:bisect-linux-8/.vmlinuz-d26bb7f73a2881f2412c340a27=
438b185f0cc3dc-20150124123334-357-ivb41 branch=3Dlinux-devel/devel-roam-ran=
d-201501240027 BOOT_IMAGE=3D/kernel/i386-randconfig-r2-0121/d26bb7f73a2881f=
2412c340a27438b185f0cc3dc/vmlinuz-3.19.0-rc4-gd26bb7f drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 299520K/327160K available (8890K kernel code, 964K r=
wdata, 3468K rodata, 672K init, 6612K bss, 27640K reserved, 0K cma-reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa2000 - 0xfffff000   ( 372 kB)
[    0.000000]     vmalloc : 0xd47e0000 - 0xfffa0000   ( 695 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3fe0000   ( 319 MB)
[    0.000000]       .init : 0xcdd06000 - 0xcddae000   ( 672 kB)
[    0.000000]       .data : 0xcd8aedf9 - 0xcdd04040   (4436 kB)
[    0.000000]       .text : 0xcd000000 - 0xcd8aedf9   (8891 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000]=20
[    0.000000] **********************************************************
[    0.000000] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.000000] **                                                      **
[    0.000000] ** trace_printk() being used. Allocating extra memory.  **
[    0.000000] **                                                      **
[    0.000000] ** This means that this is a DEBUG kernel and it is     **
[    0.000000] ** unsafe for production use.                           **
[    0.000000] **                                                      **
[    0.000000] ** If you see this message and you are not debugging    **
[    0.000000] ** the kernel, report this immediately to your vendor!  **
[    0.000000] **                                                      **
[    0.000000] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.000000] **********************************************************
[    0.000000] Testing tracer nop: PASSED
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3Dc01fa000 soft=3Dc01fc000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 4895 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 5389.47 Bogo=
MIPS (lpj=3D8978360)
[    0.010004] pid_max: default: 4096 minimum: 301
[    0.010519] ACPI: Core revision 20141107
[    0.015415] ACPI: All ACPI Tables successfully acquired
[    0.016090] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.016673] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 by=
tes)
[    0.020190] Initializing cgroup subsys freezer
[    0.020699] Initializing cgroup subsys blkio
[    0.021192] Initializing cgroup subsys debug
[    0.021737] mce: CPU supports 10 MCE banks
[    0.022250] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.022250] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.023337] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.028206] ftrace: allocating 35504 entries in 70 pages
[    0.040093] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.043958] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.046672] Getting VERSION: 1050014
[    0.047076] Getting VERSION: 1050014
[    0.047493] Getting ID: 0
[    0.047796] Getting ID: f000000
[    0.048151] Getting LVT0: 8700
[    0.048503] Getting LVT1: 8400
[    0.048865] enabled ExtINT on CPU#0
[    0.050298] ENABLING IO-APIC IRQs
[    0.050691] init IO_APIC IRQs
[    0.051027]  apic 0 pin 0 not connected
[    0.051476] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.052358] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.053242] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.053357] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.056689] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.057575] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.058459] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.059351] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.060023] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.060913] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.061798] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.063356] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.066689] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.067586] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.068496] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.069398] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.070020]  apic 0 pin 16 not connected
[    0.070463]  apic 0 pin 17 not connected
[    0.070899]  apic 0 pin 18 not connected
[    0.071335]  apic 0 pin 19 not connected
[    0.071768]  apic 0 pin 20 not connected
[    0.072202]  apic 0 pin 21 not connected
[    0.072642]  apic 0 pin 22 not connected
[    0.073335]  apic 0 pin 23 not connected
[    0.073922] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.074570] Using local APIC timer interrupts.
[    0.074570] calibrating APIC timer ...
[    0.076666] ... lapic delta =3D 11505879
[    0.076666] ... PM-Timer delta =3D 658966
[    0.076666] APIC calibration not consistent with PM-Timer: 184ms instead=
 of 100ms
[    0.076666] APIC delta adjusted to PM-Timer: 6250057 (11505879)
[    0.076666] TSC delta adjusted to PM-Timer: 269349917 (495852645)
[    0.076666] ..... delta 6250057
[    0.076666] ..... mult: 268437930
[    0.076666] ..... calibration result: 3333363
[    0.076666] ..... CPU clock speed is 2693.2561 MHz.
[    0.076666] ..... host bus clock speed is 1000.0363 MHz.
[    0.078186] Testing tracer function: PASSED
[    0.298266] Testing dynamic ftrace: PASSED
[    0.536794] Testing dynamic ftrace ops #1: (1 0 1 0 0) (1 1 2 0 0) (2 1 =
3 0 23331) (2 2 4 0 23448) PASSED
[    0.788623] Testing dynamic ftrace ops #2: (1 0 1 23233 0) (1 1 2 23350 =
0) (2 1 3 1 130) (2 2 4 110 239) PASSED
[    1.026154] Testing ftrace recursion: PASSED
[    1.055513] Testing ftrace recursion safe: PASSED
[    1.097048] Testing ftrace regs: PASSED
[    1.128744] xor: measuring software checksum speed
[    1.163343]    pIII_sse  :  9464.400 MB/sec
[    1.196684]    prefetch64-sse: 10142.400 MB/sec
[    1.197211] xor: using function: prefetch64-sse (10142.400 MB/sec)
[    1.197892] prandom: seed boundary self test passed
[    1.199218] prandom: 100 self tests passed
[    1.200013] atomic64_test: passed for i586+ platform with CX8 and with S=
SE
[    1.201148] RTC time: 12:38:08, date: 01/24/15
[    1.203484] NET: Registered protocol family 16
[    1.204715] cpuidle: using governor ladder
[    1.205170] cpuidle: using governor menu
[    1.206115] ACPI: bus type PCI registered
[    1.206838] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    1.207766] PCI: PCI BIOS revision 2.10 entry at 0xfd456, last bus=3D0
[    1.208445] PCI: Using configuration type 1 for base access
[    1.276683] raid6: mmxx1     2323 MB/s
[    1.333339] raid6: mmxx2     2546 MB/s
[    1.390016] raid6: sse1x1    2049 MB/s
[    1.446684] raid6: sse1x2    2681 MB/s
[    1.506678] raid6: sse2x1    4207 MB/s
[    1.563342] raid6: sse2x2    5130 MB/s
[    1.563790] raid6: using algorithm sse2x2 (5130 MB/s)
[    1.564340] raid6: using intx1 recovery algorithm
[    1.565216] ACPI: Added _OSI(Module Device)
[    1.565677] ACPI: Added _OSI(Processor Device)
[    1.566168] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.566670] ACPI: Added _OSI(Processor Aggregator Device)
[    1.568443] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    1.573477] ACPI: Interpreter enabled
[    1.573904] ACPI: (supports S0 S5)
[    1.574270] ACPI: Using IOAPIC for interrupt routing
[    1.574850] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    1.586168] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.586688] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    1.587299] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.590392] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    1.591739] PCI host bridge to bus 0000:00
[    1.593338] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.593936] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.594591] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    1.595251] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    1.595916] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    1.596670] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    1.597340] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.598079] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    1.598853] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.600555] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.603994] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.612096] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    1.613632] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    1.614402] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    1.615098] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    1.615853] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    1.616966] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.617975] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    1.620015] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    1.621104] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.623099] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.624606] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.633957] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.635069] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.637190] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    1.638832] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.647169] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    1.648215] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    1.649399] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    1.653847] pci_bus 0000:00: on NUMA node 0
[    1.655341] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.656797] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.658081] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.659088] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.659852] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    1.660810] ACPI: Enabled 16 GPEs in block 00 to 0F
[    1.664138] vgaarb: setting as boot device: PCI:0000:00:02.0
[    1.664744] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.665607] vgaarb: loaded
[    1.665909] vgaarb: bridge control possible 0000:00:02.0
[    1.667285] SCSI subsystem initialized
[    1.667933] libata version 3.00 loaded.
[    1.668572] ACPI: bus type USB registered
[    1.669275] usbcore: registered new interface driver usbfs
[    1.670058] usbcore: registered new interface driver hub
[    1.670688] usbcore: registered new device driver usb
[    1.671366] media: Linux media interface: v0.10
[    1.671909] Linux video capture interface: v2.00
[    1.672454] pps_core: LinuxPPS API ver. 1 registered
[    1.673335] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.676952] PCI: Using ACPI for IRQ routing
[    1.677420] PCI: pci_cache_line_size set to 64 bytes
[    1.678066] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.678711] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    1.680913] Switched to clocksource kvm-clock
[    1.717180] FS-Cache: Loaded
[    1.717723] pnp: PnP ACPI init
[    1.718248] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    1.719293] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.720186] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    1.721154] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.721911] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    1.722863] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.723636] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    1.724505] pnp 00:03: [dma 2]
[    1.724916] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.751742] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    1.752681] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.753472] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    1.754385] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.755802] pnp: PnP ACPI: found 6 devices
[    1.791864] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.792488] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    1.793076] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    1.793676] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    1.794332] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    1.795016] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    1.795697] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    1.796387] NET: Registered protocol family 1
[    1.796873] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.797523] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.798146] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.798846] pci 0000:00:02.0: Video device with shadowed ROM
[    1.799481] PCI: CLS 0 bytes, default 64
[    1.800028] Unpacking initramfs...
[    1.954811] debug: unmapping init [mem 0xd3ca5000-0xd3fd7fff]
[    1.956211] Machine check injector initialized
[    1.956709] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
[    1.957378] apm: overridden by ACPI.
[    1.970795] Scanning for low memory corruption every 60 seconds
[    1.971699] cryptomgr_test (17) used greatest stack depth: 7400 bytes le=
ft
[    1.972854] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    1.973863] NatSemi SCx200 Driver
[    1.974296] spin_lock-torture:--- Start of test [debug]: nwriters_stress=
=3D2 nreaders_stress=3D0 stat_interval=3D60 verbose=3D1 shuffle_interval=3D=
3 stutter=3D5 shutdown_secs=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    1.976388] spin_lock-torture: Creating torture_shuffle task
[    1.977048] spin_lock-torture: Creating torture_stutter task
[    1.977685] spin_lock-torture: torture_shuffle task started
[    1.978288] spin_lock-torture: Creating lock_torture_writer task
[    1.978968] spin_lock-torture: torture_stutter task started
[    1.979590] spin_lock-torture: Creating lock_torture_writer task
[    1.980264] spin_lock-torture: lock_torture_writer task started
[    1.980919] spin_lock-torture: Creating lock_torture_stats task
[    1.981578] spin_lock-torture: lock_torture_writer task started
[    1.982233] torture_init_begin: refusing rcu init: spin_lock running
[    1.996425] futex hash table entries: 16 (order: -3, 704 bytes)
[    1.997147] spin_lock-torture: lock_torture_stats task started
[    2.009188] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.022976] page_owner is disabled
[    2.023639] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    2.024438] ntfs: driver 2.1.31 [Flags: R/W DEBUG].
[    2.024971] efs: 1.0a - http://aeschi.ch.eu.org/efs/
[    2.026225] romfs: ROMFS MTD (C) 2007 Red Hat, Inc.
[    2.026764] QNX4 filesystem 0.2.3 registered.
[    2.027236] qnx6: QNX6 filesystem 1.0.0 registered.
[    2.028040] fuse init (API version 7.23)
[    2.028767] befs: version: 0.9.3
[    2.030779] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    2.031686] io scheduler noop registered (default)
[    2.032241] io scheduler deadline registered
[    2.032731] io scheduler cfq registered
[    2.033162] start plist test
[    2.044181] end plist test
[    2.044496] test_string_helpers: Running tests...
[    2.045322] test_firmware: interface ready
[    2.046237] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    2.046793] crc32: self tests passed, processed 225944 bytes in 205687 n=
sec
[    2.047742] crc32c: CRC_LE_BITS =3D 64
[    2.048127] crc32c: self tests passed, processed 225944 bytes in 101781 =
nsec
[    2.100296] crc32_combine: 8373 self tests passed
[    2.141839] crc32c_combine: 8373 self tests passed
[    2.142517] xz_dec_test: module loaded
[    2.142930] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
249 0' and write .xz files to it.
[    2.144552] glob: 64 self-tests passed, 0 failed
[    2.145785] no IO addresses supplied
[    2.146316] hgafb: HGA card not detected.
[    2.146768] hgafb: probe of hgafb.0 failed with error -22
[    2.147459] usbcore: registered new interface driver udlfb
[    2.148105] ipmi message handler version 39.2
[    2.148589] ipmi device interface
[    2.149013] IPMI System Interface driver.
[    2.149551] ipmi_si: Adding default-specified kcs state machine
[    2.150203] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    2.195876] ipmi_si: Interface detection failed
[    2.196402] ipmi_si: Adding default-specified smic state machine
[    2.197062] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    2.198143] ipmi_si: Interface detection failed
[    2.198641] ipmi_si: Adding default-specified bt state machine
[    2.199279] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    2.200341] ipmi_si: Interface detection failed
[    2.200926] ipmi_si: Unable to find any System Interface(s)
[    2.201538] IPMI SSIF Interface driver
[    2.201976] IPMI Watchdog: driver initialized
[    2.202461] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    2.203621] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    2.235483] ACPI: Power Button [PWRF]
[    2.236755] r3964: Philips r3964 Driver $Revision: 1.10 $
[    2.237363] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.299333] serial 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 1=
15200) is a 16550A
[    2.301892] lp: driver loaded but no devices found
[    2.302455] toshiba: not a supported Toshiba laptop
[    2.303011] ppdev: user-space parallel port driver
[    2.303547] scx200_gpio: no SCx200 gpio present
[    2.304125] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    2.304913] platform pc8736x_gpio.0: no device found
[    2.305550] nsc_gpio initializing
[    2.305915] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    2.306926] [drm] Initialized drm 1.1.0 20060810
[    2.307462] usbcore: registered new interface driver udl
[    2.308729] parport_pc 00:04: reported by Plug and Play ACPI
[    2.309476] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    2.498151] lp0: using parport0 (interrupt-driven).
[    2.502208] dummy-irq: no IRQ given.  Use irq=3DN
[    2.502891] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    2.503828] c2port c2port0: C2 port uc added
[    2.504288] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    2.505240] usbcore: registered new interface driver rtsx_usb
[    2.506066] usbcore: registered new interface driver viperboard
[    2.506762] usbcore: registered new interface driver dln2
[    2.507362] Uniform Multi-Platform E-IDE driver
[    2.508319] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[    2.509376] ide-cd driver 5.00
[    2.509943] hp_sw: device handler registered
[    2.528435] ppa: Version 2.07 (for Linux 2.4.x)
[    2.531193] osst :I: Tape driver with OnStream support version 0.99.4
[    2.531193] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    2.532776] SCSI Media Changer driver v0.25=20
[    2.533307] osd: LOADED open-osd 0.2.1
[    2.533990] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    2.535159] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    2.535893] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    2.536746] platform physmap-flash.0: failed to claim resource 0
[    2.557430] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
[    2.558127] scx200_docflash: NatSemi SCx200 DOCCS Flash Driver
[    2.558826] slram: not enough parameters.
[    2.560244] ftl_cs: FTL header not found.
[    2.562093] parport0: cannot grant exclusive access for device spi-lm70l=
lp
[    2.562847] spi-lm70llp: spi_lm70llp probe fail, status -12
[    2.563547] HSI/SSI char device loaded
[    2.564120] usbcore: registered new interface driver hwa-rc
[    2.564840] usbcore: registered new interface driver i1480-dfu-usb
[    2.565895] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.584677] ehci-pci: EHCI PCI platform driver
[    2.585186] ehci-platform: EHCI generic platform driver
[    2.585980] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    2.586772] usbcore: registered new interface driver cdc_acm
[    2.587380] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    2.588254] usbcore: registered new interface driver cdc_wdm
[    2.588892] usbcore: registered new interface driver uas
[    2.589490] usbcore: registered new interface driver usb-storage
[    2.590141] usbcore: registered new interface driver ums-alauda
[    2.590795] usbcore: registered new interface driver ums-cypress
[    2.591463] usbcore: registered new interface driver ums-jumpshot
[    2.592263] usbcore: registered new interface driver ums-karma
[    2.593004] usbcore: registered new interface driver ums-onetouch
[    2.611740] usbcore: registered new interface driver ums-realtek
[    2.612417] usbcore: registered new interface driver ums-sddr09
[    2.613069] usbcore: registered new interface driver ums-sddr55
[    2.613723] usbcore: registered new interface driver ums-usbat
[    2.614420] usbcore: registered new interface driver mdc800
[    2.615018] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    2.615871] usbcore: registered new interface driver microtekX6
[    2.616537] usbcore: registered new interface driver adutux
[    2.617152] usbcore: registered new interface driver cypress_cy7c63
[    2.617829] ftdi_elan: driver ftdi-elan
[    2.618354] usbcore: registered new interface driver ftdi-elan
[    2.619135] usbcore: registered new interface driver idmouse
[    2.619854] usbcore: registered new interface driver iowarrior
[    2.638585] usbcore: registered new interface driver isight_firmware
[    2.639309] usbcore: registered new interface driver usblcd
[    2.639936] usbcore: registered new interface driver ldusb
[    2.640594] usbcore: registered new interface driver usbled
[    2.641213] usbcore: registered new interface driver legousbtower
[    2.641893] usbcore: registered new interface driver usbtest
[    2.642537] usbcore: registered new interface driver usb_ehset_test
[    2.643228] usbcore: registered new interface driver trancevibrator
[    2.643925] usbcore: registered new interface driver uss720
[    2.644526] uss720: v0.6:USB Parport Cable driver for Cables using the L=
ucent Technologies USS720 Chip
[    2.645528] uss720: NOTE: this is a special purpose driver to allow nons=
tandard
[    2.646405] uss720: protocols (eg. bitbang) over USS720 usb to parallel =
cables
[    2.647272] uss720: If you just want to connect to a printer, use usblp =
instead
[    2.666148] usbcore: registered new interface driver usbsevseg
[    2.666805] usbcore: registered new interface driver yurex
[    2.667454] usbcore: registered new interface driver lvs
[    2.668324] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 M=
ay 2005
[    2.669164] dummy_hcd dummy_hcd.0: Dummy host controller
[    2.669828] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus =
number 1
[    2.670740] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    2.671471] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    2.672247] usb usb1: Product: Dummy host controller
[    2.672840] usb usb1: Manufacturer: Linux 3.19.0-rc4-gd26bb7f dummy_hcd
[    2.673638] usb usb1: SerialNumber: dummy_hcd.0
[    2.692579] hub 1-0:1.0: USB hub found
[    2.693023] hub 1-0:1.0: 1 port detected
[    2.694183] udc dummy_udc.0: registering UDC driver [g_mass_storage]
[    2.694889] Number of LUNs=3D8
[    2.695207] Mass Storage Function, version: 2009/09/11
[    2.695787] LUN: removable file: (no medium)
[    2.696258] Number of LUNs=3D1
[    2.696581] no file given for LUN0
[    2.696968] g_mass_storage dummy_udc.0: failed to start g_mass_storage: =
-22
[    2.697834] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    2.699422] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.700040] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.701130] mousedev: PS/2 mouse device common for all mice
[    2.719434] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    2.720611] usbcore: registered new interface driver appletouch
[    2.721269] usbcore: registered new interface driver bcm5974
[    2.723477] usbcore: registered new interface driver synaptics_usb
[    2.724169] usbcore: registered new interface driver usb_acecad
[    2.724839] usbcore: registered new interface driver aiptek
[    2.725536] usbcore: registered new interface driver gtco
[    2.726148] usbcore: registered new interface driver hanwang
[    2.726959] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    2.748997] usbcore: registered new interface driver ims_pcu
[    2.749767] usbcore: registered new interface driver powermate
[    2.750483] usbcore: registered new interface driver yealink
[    2.751094] ideapad_slidebar: DMI does not match
[    2.751726] rtc_cmos 00:00: RTC can wake from S4
[    2.752487] rtc (null): alarm rollover: day
[    2.753074] rtc rtc0: rtc_cmos: dev (254:0)
[    2.753564] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    2.773327] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    2.775117] usbcore: registered new interface driver i2c-diolan-u2c
[    2.775839] i2c-parport-light: adapter type unspecified
[    2.776436] usbcore: registered new interface driver i2c-tiny-usb
[    2.777374] pps_ldisc: PPS line discipline registered
[    2.777930] pps_parport: parallel port PPS client
[    2.778456] parport0: cannot grant exclusive access for device pps_parpo=
rt
[    2.779198] pps_parport: couldn't register with parport0
[    2.779778] Driver for 1-wire Dallas network protocol.
[    2.780457] usbcore: registered new interface driver DS9490R
[    2.781094] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    2.781806] 1-Wire driver for the DS2760 battery monitor chip - (c) 2004=
-2005, Szabolcs Gyurko
[    2.784061] applesmc: supported laptop not found!
[    2.784581] applesmc: driver init failed (ret=3D-19)!
[    2.785349] f71882fg: Not a Fintek device
[    2.785825] f71882fg: Not a Fintek device
[    2.787217] pc87360: PC8736x not detected, module not inserted
[    2.788459] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[    2.797795] md: raid0 personality registered for level 0
[    2.798374] md: raid1 personality registered for level 1
[    2.798960] md: raid10 personality registered for level 10
[    2.799722] md: raid6 personality registered for level 6
[    2.800292] md: raid5 personality registered for level 5
[    2.800863] md: raid4 personality registered for level 4
[    2.801435] md: multipath personality registered for level -4
[    2.802046] md: faulty personality registered for level -5
[    2.802798] device-mapper: ioctl: 4.29.0-ioctl (2014-10-28) initialised:=
 dm-devel@redhat.com
[    2.803891] device-mapper: multipath: version 1.7.0 loaded
[    2.804505] device-mapper: multipath round-robin: version 1.0.0 loaded
[    2.818106] device-mapper: multipath service-time: version 0.2.0 loaded
[    2.818875] device-mapper: raid: Loading target version 1.6.0
[    2.819579] cpufreq-nforce2: No nForce2 chipset.
[    2.820081] Driver 'mmc_test' needs updating - please use bus_type metho=
ds
[    2.820928] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0400
[    2.821727] usbcore: registered new interface driver vub300
[    2.822400] usbcore: registered new interface driver ushc
[    2.823740] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    2.825756] usbcore: registered new interface driver usbhid
[    2.826361] usbhid: USB HID core driver
[    2.828596] oprofile: using NMI interrupt.
[    2.829835] ... APIC ID:      00000000 (0)
[    2.830280] ... APIC VERSION: 01050014
[    2.832382] 000000000000000000000000000000000000000000000000000000000000=
0000
[    2.832382] 000000000e20000000000000000000000000000000000000000000000000=
0000
[    2.832382] 000000000000000000000000000000000000000000000000000000000000=
8000
[    2.832382]=20
[    2.846521] number of MP IRQ sources: 15.
[    2.846950] number of IO-APIC #0 registers: 24.
[    2.847439] testing the IO APIC.......................
[    2.847998] IO APIC #0......
[    2.848309] .... register #00: 00000000
[    2.848730] .......    : physical APIC id: 00
[    2.849206] .......    : Delivery Type: 0
[    2.849646] .......    : LTS          : 0
[    2.850076] .... register #01: 00170011
[    2.850493] .......     : max redirection entries: 17
[    2.851028] .......     : PRQ implemented: 0
[    2.851491] .......     : IO APIC version: 11
[    2.851956] .... register #02: 00000000
[    2.852372] .......     : arbitration: 00
[    2.852810] .... IRQ redirection table:
[    2.853234] 1    0    0   0   0    0    0    00
[    2.853738] 0    0    0   0   0    1    1    31
[    2.854229] 0    0    0   0   0    1    1    30
[    2.854729] 0    0    0   0   0    1    1    33
[    2.855220] 1    0    0   0   0    1    1    34
[    2.855728] 1    1    0   0   0    1    1    35
[    2.856219] 0    0    0   0   0    1    1    36
[    2.869729] 0    0    0   0   0    1    1    37
[    2.870225] 0    0    0   0   0    1    1    38
[    2.870720] 0    1    0   0   0    1    1    39
[    2.871208] 1    1    0   0   0    1    1    3A
[    2.871707] 1    1    0   0   0    1    1    3B
[    2.872207] 0    0    0   0   0    1    1    3C
[    2.872708] 0    0    0   0   0    1    1    3D
[    2.873194] 0    0    0   0   0    1    1    3E
[    2.873694] 0    0    0   0   0    1    1    3F
[    2.874183] 1    0    0   0   0    0    0    00
[    2.874681] 1    0    0   0   0    0    0    00
[    2.875172] 1    0    0   0   0    0    0    00
[    2.875677] 1    0    0   0   0    0    0    00
[    2.876175] 1    0    0   0   0    0    0    00
[    2.876706] 1    0    0   0   0    0    0    00
[    2.877197] 1    0    0   0   0    0    0    00
[    2.877695] 1    0    0   0   0    0    0    00
[    2.878177] IRQ to pin mappings:
[    2.878535] IRQ0 -> 0:2
[    2.878835] IRQ1 -> 0:1
[    2.879146] IRQ3 -> 0:3
[    2.889261] IRQ4 -> 0:4
[    2.889571] IRQ5 -> 0:5
[    2.889870] IRQ6 -> 0:6
[    2.890169] IRQ7 -> 0:7
[    2.890476] IRQ8 -> 0:8
[    2.890775] IRQ9 -> 0:9
[    2.891073] IRQ10 -> 0:10
[    2.891391] IRQ11 -> 0:11
[    2.891718] IRQ12 -> 0:12
[    2.892036] IRQ13 -> 0:13
[    2.892360] IRQ14 -> 0:14
[    2.892684] IRQ15 -> 0:15
[    2.892998] .................................... done.
[    2.893553] Using IPI Shortcut mode
[    2.894035] usb usb1: dummy_bus_suspend
[    2.894734] Running tests on trace events:
[    2.895184] Testing event xen_cpu_set_ldt: OK
[    2.914521] Testing event xen_cpu_write_gdt_entry: OK
[    2.950404] Testing event xen_cpu_load_idt: OK
[    2.959975] Testing event xen_cpu_write_idt_entry: OK
[    2.978935] Testing event xen_cpu_write_ldt_entry: OK
[    2.985621] Testing event xen_mmu_write_cr3: OK
[    2.995616] Testing event xen_mmu_flush_tlb_others: OK
[    3.042289] Testing event xen_mmu_flush_tlb_single: OK
[    3.078927] Testing event xen_mmu_flush_tlb: OK
[    3.096878] Testing event xen_mmu_flush_tlb_all: OK
[    3.105619] Testing event xen_mmu_pgd_unpin: OK
[    3.147796] Testing event xen_mmu_pgd_pin: OK
[    3.152282] Testing event xen_mmu_release_ptpage: OK
[    3.175339] Testing event xen_mmu_alloc_ptpage: OK
[    3.192383] Testing event xen_mmu_ptep_modify_prot_commit: OK
[    3.242991] Testing event xen_mmu_ptep_modify_prot_start: OK
[    3.249305] Testing event xen_mmu_pgd_clear: OK
[    3.268960] Testing event xen_mmu_set_pud: OK
[    3.303704] Testing event xen_mmu_pmd_clear: OK
[    3.308950] Testing event xen_mmu_set_pmd: OK
[    3.333311] Testing event xen_mmu_pte_clear: OK
[    3.353248] Testing event xen_mmu_set_pte_at: OK
[    3.359221] Testing event xen_mmu_set_domain_pte: OK
[    3.381063] Testing event xen_mmu_set_pte_atomic: OK
[    3.385745] Testing event xen_mmu_set_pte: OK
[    3.409264] Testing event xen_mc_extend_args: OK
[    3.426591] Testing event xen_mc_flush: OK
[    3.444585] Testing event xen_mc_flush_reason: OK
[    3.448961] Testing event xen_mc_callback: OK
[    3.462545] Testing event xen_mc_entry_alloc: OK
[    3.485626] Testing event xen_mc_entry: OK
[    3.496569] Testing event xen_mc_issue: OK
[    3.508959] Testing event xen_mc_batch: OK
[    3.520065] Testing event thermal_apic_exit: OK
[    3.530734] Testing event thermal_apic_entry: OK
[    3.548933] Testing event threshold_apic_exit: OK
[    3.555630] Testing event threshold_apic_entry: OK
[    3.565732] Testing event call_function_single_exit: OK
[    3.595319] Testing event call_function_single_entry: OK
[    3.616668] Testing event call_function_exit: OK
[    3.622420] Testing event call_function_entry: OK
[    3.640521] Testing event irq_work_exit: OK
[    3.645619] Testing event irq_work_entry: OK
[    3.669371] Testing event x86_platform_ipi_exit: OK
[    3.687482] Testing event x86_platform_ipi_entry:=20
[    3.702423] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[    3.718907] tsc: Refined TSC clocksource calibration: 2693.509 MHz
[    3.722222] OK
[    3.722430] Testing event error_apic_exit: OK
[    3.748954] Testing event error_apic_entry: OK
[    3.769463] Testing event spurious_apic_exit: OK
[    3.778959] Testing event spurious_apic_entry: OK
[    3.800189] Testing event reschedule_exit: OK
[    3.818415] Testing event reschedule_entry: OK
[    3.825624] Testing event local_timer_exit: OK
[    3.892834] Testing event local_timer_entry: OK
[    3.900181] Testing event nmi_handler: OK
[    3.912691] Testing event sys_exit: OK
[    3.939579] Testing event sys_enter: OK
[    3.956513] Testing event mce_record: OK
[    3.962291] Testing event tlb_flush: OK
[    3.988956] Testing event page_fault_kernel: OK
[    4.048385] Testing event page_fault_user: OK
[    4.077062] Testing event task_rename: OK
[    4.082295] Testing event task_newtask: OK
[    4.130497] Testing event softirq_raise: OK
[    4.135624] Testing event softirq_exit: OK
[    4.165183] Testing event softirq_entry: OK
[    4.189343] Testing event irq_handler_exit: OK
[    4.221709] Testing event irq_handler_entry: OK
[    4.240972] Testing event signal_deliver: OK
[    4.261833] Testing event signal_generate: OK
[    4.272299] Testing event workqueue_execute_end: OK
[    4.334234] Testing event workqueue_execute_start: OK
[    4.365228] Testing event workqueue_activate_work: OK
[    4.385735] Testing event workqueue_queue_work: OK
[    4.415984] Testing event sched_wake_idle_without_ipi: OK
[    4.439518] Testing event sched_swap_numa: OK
[    4.474509] Testing event sched_stick_numa: OK
[    4.512290] Testing event sched_move_numa: OK
[    4.568459] Testing event sched_pi_setprio: OK
[    4.599998] Testing event sched_stat_runtime:=20
[    4.615561] test-events (174) used greatest stack depth: 7176 bytes left
[    4.616324] OK
[    4.616525] Testing event sched_stat_blocked: OK
[    4.640511] Testing event sched_stat_iowait: OK
[    4.692278] Testing event sched_stat_sleep: OK
[    4.713524] Testing event sched_stat_wait: OK
[    4.746902] Testing event sched_process_exec: OK
[    4.769988] Testing event sched_process_fork: OK
[    4.775632] Testing event sched_process_wait: OK
[    4.792297] Testing event sched_wait_task: OK
[    4.855681] Testing event sched_process_exit: OK
[    4.885633] Testing event sched_process_free: OK
[    4.912300] Testing event sched_migrate_task: OK
[    4.979911] Testing event sched_switch: OK
[    4.985988] Testing event sched_wakeup_new: OK
[    5.001532] Testing event sched_wakeup: OK
[    5.024402] Testing event sched_kthread_stop_ret: OK
[    5.054936] Testing event sched_kthread_stop: OK
[    5.075539] Testing event lock_release: OK
[    5.108999] Testing event lock_acquire: OK
[    5.209792] Testing event console: OK
[    5.231422] Testing event rcu_utilization: OK
[    5.235632] Testing event itimer_expire: OK
[    5.281980] Testing event itimer_state: OK
[    5.292005] Testing event hrtimer_cancel: OK
[    5.312298] Testing event hrtimer_expire_exit: OK
[    5.336228] Testing event hrtimer_expire_entry: OK
[    5.357036] Testing event hrtimer_start: OK
[    5.374824] Testing event hrtimer_init: OK
[    5.382301] Testing event timer_cancel: OK
[    5.436400] Testing event timer_expire_exit: OK
[    5.443006] Testing event timer_expire_entry: OK
[    5.462706] Testing event timer_start: OK
[    5.472302] Testing event timer_init: OK
[    5.513050] Testing event ftrace_test_filter: OK
[    5.519734] Testing event dev_pm_qos_remove_request: OK
[    5.539181] Testing event dev_pm_qos_update_request: OK
[    5.548970] Testing event dev_pm_qos_add_request: OK
[    5.591027] Testing event pm_qos_update_flags: OK
[    5.595634] Testing event pm_qos_update_target: OK
[    5.618948] Testing event pm_qos_update_request_timeout: OK
[    5.625641] Testing event pm_qos_remove_request: OK
[    5.673103] Testing event pm_qos_update_request: OK
[    5.679505] Testing event pm_qos_add_request: OK
[    5.700899] Testing event power_domain_target: OK
[    5.705638] Testing event clock_set_rate: OK
[    5.732302] Testing event clock_disable: OK
[    5.768946] Testing event clock_enable: OK
[    5.800777] Testing event wakeup_source_deactivate: OK
[    5.831809] Testing event wakeup_source_activate: OK
[    5.838976] Testing event suspend_resume: OK
[    5.880843] Testing event device_pm_callback_end: OK
[    5.885651] Testing event device_pm_callback_start: OK
[    5.911532] Testing event cpu_frequency: OK
[    5.941529] Testing event pstate_sample: OK
[    5.964495] Testing event cpu_idle: OK
[    5.968982] Testing event rpm_return_int: OK
[    6.007293] Testing event rpm_idle: OK
[    6.033540] Testing event rpm_resume: OK
[    6.060509] Testing event rpm_suspend: OK
[    6.065640] Testing event mm_filemap_add_to_page_cache: OK
[    6.115643] Testing event mm_filemap_delete_from_page_cache: OK
[    6.122307] Testing event oom_score_adj_update: OK
[    6.145642] Testing event mm_lru_activate: OK
[    6.188981] Testing event mm_lru_insertion: OK
[    6.205506] Testing event mm_vmscan_lru_shrink_inactive: OK
[    6.236888] Testing event mm_vmscan_writepage: OK
[    6.266519] Testing event mm_vmscan_memcg_isolate: OK
[    6.319509] Testing event mm_vmscan_lru_isolate: OK
[    6.351033] Testing event mm_shrink_slab_end: OK
[    6.381380] Testing event mm_shrink_slab_start: OK
[    6.398980] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[    6.420514] Testing event mm_vmscan_memcg_reclaim_end: OK
[    6.453011] Testing event mm_vmscan_direct_reclaim_end: OK
[    6.465505] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[    6.498202] Testing event mm_vmscan_memcg_reclaim_begin: OK
[    6.533799] Testing event mm_vmscan_direct_reclaim_begin: OK
[    6.538971] Testing event mm_vmscan_wakeup_kswapd: OK
[    6.565650] Testing event mm_vmscan_kswapd_wake: OK
[    6.591688] Testing event mm_vmscan_kswapd_sleep: OK
[    6.616275] Testing event mm_page_alloc_extfrag: OK
[    6.638530] Testing event mm_page_pcpu_drain: OK
[    6.667964] Testing event mm_page_alloc_zone_locked: OK
[    6.697684] Testing event mm_page_alloc: OK
[    6.716520] Testing event mm_page_free_batched: OK
[    6.747685] Testing event mm_page_free: OK
[    6.752314] Testing event kmem_cache_free: OK
[    6.778986] Testing event kfree: OK
[    6.805635] Testing event kmem_cache_alloc_node: OK
[    6.822553] Testing event kmalloc_node: OK
[    6.850885] Testing event kmem_cache_alloc: OK
[    6.867008] Testing event kmalloc: OK
[    6.872316] Testing event mm_compaction_end: OK
[    6.900537] Testing event mm_compaction_begin: OK
[    6.945562] Testing event mm_compaction_migratepages: OK
[    6.968989] Testing event mm_compaction_isolate_freepages: OK
[    7.026859] Testing event mm_compaction_isolate_migratepages: OK
[    7.049814] Testing event mm_numa_migrate_ratelimit: OK
[    7.075506] Testing event mm_migrate_pages: OK
[    7.134047] Testing event writeback_single_inode: OK
[    7.138978] Testing event writeback_single_inode_start: OK
[    7.189987] Testing event writeback_wait_iff_congested: OK
[    7.195663] Testing event writeback_congestion_wait: OK
[    7.223154] Testing event writeback_sb_inodes_requeue: OK
[    7.245649] Testing event balance_dirty_pages: OK
[    7.275672] Testing event bdi_dirty_ratelimit: OK
[    7.295663] Testing event global_dirty_state: OK
[    7.345641] Testing event writeback_queue_io: OK
[    7.368513] Testing event wbc_writepage: OK
[    7.402471] Testing event writeback_bdi_unregister: OK
[    7.446537] Testing event writeback_bdi_register: OK
[    7.452320] Testing event writeback_wake_background: OK
[    7.499551] Testing event writeback_nowork: OK
[    7.567302] Testing event writeback_pages_written: OK
[    7.589105] Testing event writeback_wait: OK
[    7.615564] Testing event writeback_written: OK
[    7.685103] Testing event writeback_start: OK
[    7.708994] Testing event writeback_exec: OK
[    7.762691] Testing event writeback_queue: OK
[    7.787508] Testing event writeback_write_inode: OK
[    7.822322] Testing event writeback_write_inode_start: OK
[    7.871516] Testing event writeback_dirty_inode: OK
[    7.904278] Testing event writeback_dirty_inode_start: OK
[    7.925537] Testing event writeback_dirty_page: OK
[    7.987103] Testing event time_out_leases: OK
[    8.013525] Testing event generic_delete_lease: OK
[    8.045126] Testing event generic_add_lease: OK
[    8.055661] Testing event break_lease_unblock: OK
[    8.075521] Testing event break_lease_block: OK
[    8.109787] Testing event break_lease_noblock: OK
[    8.147204] Testing event ext3_load_inode: OK
[    8.170511] Testing event ext3_get_blocks_exit: OK
[    8.178992] Testing event ext3_get_blocks_enter: OK
[    8.243777] Testing event ext3_truncate_exit: OK
[    8.263507] Testing event ext3_truncate_enter: OK
[    8.292507] Testing event ext3_unlink_exit: OK
[    8.298993] Testing event ext3_unlink_enter: OK
[    8.353058] Testing event ext3_direct_IO_exit: OK
[    8.377733] Testing event ext3_direct_IO_enter: OK
[    8.382321] Testing event ext3_read_block_bitmap: OK
[    8.428772] Testing event ext3_forget: OK
[    8.438481] Testing event ext3_reserved: OK
[    8.459642] Testing event ext3_alloc_new_reservation: OK
[    8.466448] Testing event ext3_discard_reservation: OK
[    8.486810] Testing event ext3_rsv_window_add: OK
[    8.547483] Testing event ext3_sync_fs: OK
[    8.552327] Testing event ext3_sync_file_exit: OK
[    8.606068] Testing event ext3_sync_file_enter: OK
[    8.640323] Testing event ext3_free_blocks: OK
[    8.658552] Testing event ext3_allocate_blocks: OK
[    8.667499] Testing event ext3_request_blocks: OK
[    8.691277] Testing event ext3_discard_blocks: OK
[    8.695663] Testing event ext3_invalidatepage: OK
[    8.725679] Testing event ext3_releasepage: OK
[    8.775850] Testing event ext3_readpage: OK
[    8.802268] Testing event ext3_journalled_writepage: OK
[    8.820511] Testing event ext3_writeback_writepage: OK
[    8.846506] Testing event ext3_ordered_writepage: OK
[    8.873660] Testing event ext3_journalled_write_end: OK
[    8.878992] Testing event ext3_writeback_write_end: OK
[    8.898061] Testing event ext3_ordered_write_end: OK
[    8.922175] Testing event ext3_write_begin: OK
[    8.940202] Testing event ext3_mark_inode_dirty: OK
[    8.963429] Testing event ext3_drop_inode: OK
[    8.988517] Testing event ext3_evict_inode: OK
[    9.039338] Testing event ext3_allocate_inode: OK
[    9.046877] Testing event ext3_request_inode: OK
[    9.066103] Testing event ext3_free_inode: OK
[    9.093507] Testing event ext4_es_shrink: OK
[    9.155645] Testing event ext4_collapse_range: OK
[    9.181730] Testing event ext4_es_shrink_scan_exit: OK
[    9.207795] Testing event ext4_es_shrink_scan_enter: OK
[    9.233135] Testing event ext4_es_shrink_count: OK
[    9.239554] Testing event ext4_es_lookup_extent_exit: OK
[    9.259643] Testing event ext4_es_lookup_extent_enter: OK
[    9.286508] Testing event ext4_es_find_delayed_extent_range_exit: OK
[    9.345332] Testing event ext4_es_find_delayed_extent_range_enter: OK
[    9.367508] Testing event ext4_es_remove_extent: OK
[    9.399302] Testing event ext4_es_cache_extent: OK
[    9.405669] Testing event ext4_es_insert_extent: OK
[    9.452325] Testing event ext4_ext_remove_space_done: OK
[    9.472738] Testing event ext4_ext_remove_space: OK
[    9.527243] Testing event ext4_ext_rm_idx: OK
[    9.532331] Testing event ext4_ext_rm_leaf: OK
[    9.559011] Testing event ext4_remove_blocks: OK
[    9.585668] Testing event ext4_ext_show_extent: OK
[    9.607902] Testing event ext4_get_reserved_cluster_alloc: OK
[    9.615676] Testing event ext4_find_delalloc_range: OK
[    9.653836] Testing event ext4_ext_in_cache: OK
[    9.658999] Testing event ext4_ext_put_in_cache: OK
[    9.687269] Testing event ext4_get_implied_cluster_alloc_exit: OK
[    9.721075] Testing event ext4_ext_handle_unwritten_extents: OK
[    9.725667] Testing event ext4_trim_all_free: OK
[    9.773872] Testing event ext4_trim_extent: OK
[    9.779003] Testing event ext4_journal_start_reserved: OK
[    9.805647] Testing event ext4_journal_start: OK
[    9.824511] Testing event ext4_load_inode: OK
[    9.852342] Testing event ext4_ext_load_extent: OK
[    9.879004] Testing event ext4_ind_map_blocks_exit: OK
[    9.928730] Testing event ext4_ext_map_blocks_exit: OK
[    9.957343] Testing event ext4_ind_map_blocks_enter: OK
[    9.975511] Testing event ext4_ext_map_blocks_enter: OK
[   10.006548] Testing event ext4_ext_convert_to_initialized_fastpath: OK
[   10.027510] Testing event ext4_ext_convert_to_initialized_enter: OK
[   10.056870] Testing event ext4_truncate_exit: OK
[   10.078516] Testing event ext4_truncate_enter: OK
[   10.110064] Testing event ext4_unlink_exit: OK
[   10.133750] Testing event ext4_unlink_enter: OK
[   10.163538] Testing event ext4_fallocate_exit: OK
[   10.195681] Testing event ext4_zero_range: OK
[   10.222316] Testing event ext4_punch_hole: OK
[   10.246531] Testing event ext4_fallocate_enter: OK
[   10.306029] Testing event ext4_direct_IO_exit: OK
[   10.327502] Testing event ext4_direct_IO_enter: OK
[   10.361248] Testing event ext4_load_inode_bitmap: OK
[   10.365673] Testing event ext4_read_block_bitmap_load: OK
[   10.412317] Testing event ext4_mb_buddy_bitmap_load: OK
[   10.431222] Testing event ext4_mb_bitmap_load: OK
[   10.461493] Testing event ext4_da_release_space: OK
[   10.490404] Testing event ext4_da_reserve_space: OK
[   10.513040] Testing event ext4_da_update_reserve_space: OK
[   10.537518] Testing event ext4_forget: OK
[   10.567240] Testing event ext4_mballoc_free: OK
[   10.572342] Testing event ext4_mballoc_discard: OK
[   10.596096] Testing event ext4_mballoc_prealloc: OK
[   10.612506] Testing event ext4_mballoc_alloc: OK
[   10.666509] Testing event ext4_alloc_da_blocks: OK
[   10.722327] Testing event ext4_sync_fs: OK
[   10.747181] Testing event ext4_sync_file_exit: OK
[   10.767515] Testing event ext4_sync_file_enter: OK
[   10.799012] Testing event ext4_free_blocks: OK
[   10.842319] Testing event ext4_allocate_blocks: OK
[   10.871370] Testing event ext4_request_blocks: OK
[   10.900167] Testing event ext4_mb_discard_preallocations: OK
[   10.923764] Testing event ext4_discard_preallocations: OK
[   10.929014] Testing event ext4_mb_release_group_pa: OK
[   10.959656] Testing event ext4_mb_release_inode_pa: OK
[   10.969014] Testing event ext4_mb_new_group_pa: OK
[   11.018067] Testing event ext4_mb_new_inode_pa: OK
[   11.048158] Testing event ext4_discard_blocks: OK
[   11.072386] Testing event ext4_journalled_invalidatepage: OK
[   11.105707] Testing event ext4_invalidatepage: OK
[   11.140757] Testing event ext4_releasepage: OK
[   11.158364] Testing event ext4_readpage: OK
[   11.162347] Testing event ext4_writepage: OK
[   11.202341] Testing event ext4_writepages_result: OK
[   11.225588] Testing event ext4_da_write_pages_extent: OK
[   11.232451] Testing event ext4_da_write_pages: OK
[   11.255710] Testing event ext4_writepages: OK
[   11.306567] Testing event ext4_da_write_end: OK
[   11.362459] Testing event ext4_journalled_write_end: OK
[   11.392329] Testing event ext4_write_end: OK
[   11.417897] Testing event ext4_da_write_begin: OK
[   11.452296] Testing event ext4_write_begin: OK
[   11.472345] Testing event ext4_begin_ordered_truncate: OK
[   11.495115] Testing event ext4_mark_inode_dirty: OK
[   11.532839] Testing event ext4_drop_inode: OK
[   11.559022] Testing event ext4_evict_inode: OK
[   11.614687] Testing event ext4_allocate_inode: OK
[   11.619017] Testing event ext4_request_inode: OK
[   11.652348] Testing event ext4_free_inode: OK
[   11.693512] Testing event journal_write_superblock: OK
[   11.712667] Testing event jbd_cleanup_journal_tail: OK
[   11.725714] Testing event jbd_do_submit_data: OK
[   11.755718] Testing event jbd_end_commit: OK
[   11.772377] Testing event jbd_drop_transaction: OK
[   11.830554] Testing event jbd_commit_logging: OK
[   11.854280] Testing event jbd_commit_flushing: OK
[   11.859019] Testing event jbd_commit_locking: OK
[   11.882358] Testing event jbd_start_commit: OK
[   11.939991] Testing event jbd_checkpoint: OK
[   11.962501] Testing event jbd2_lock_buffer_stall: OK
[   11.969002] Testing event jbd2_write_superblock: OK
[   11.975678] Testing event jbd2_update_log_tail: OK
[   11.982336] Testing event jbd2_checkpoint_stats: OK
[   11.989007] Testing event jbd2_run_stats: OK
[   11.995673] Testing event jbd2_handle_stats: OK
[   12.002337] Testing event jbd2_handle_extend: OK
[   12.009021] Testing event jbd2_handle_start: OK
[   12.015676] Testing event jbd2_submit_inode_data: OK
[   12.022340] Testing event jbd2_end_commit: OK
[   12.029008] Testing event jbd2_drop_transaction: OK
[   12.035674] Testing event jbd2_commit_logging: OK
[   12.042341] Testing event jbd2_commit_flushing: OK
[   12.049003] Testing event jbd2_commit_locking: OK
[   12.055679] Testing event jbd2_start_commit: OK
[   12.062338] Testing event jbd2_checkpoint: OK
[   12.069032] Testing event btrfs_qgroup_record_ref: OK
[   12.075683] Testing event btrfs_qgroup_account: OK
[   12.082341] Testing event btrfs_workqueue_destroy: OK
[   12.089019] Testing event btrfs_workqueue_alloc: OK
[   12.095685] Testing event btrfs_ordered_sched: OK
[   12.102345] Testing event btrfs_all_work_done: OK
[   12.109027] Testing event btrfs_work_sched: OK
[   12.115684] Testing event btrfs_work_queued: OK
[   12.122350] Testing event free_extent_state: OK
[   12.129006] Testing event alloc_extent_state: OK
[   12.135686] Testing event btrfs_setup_cluster: OK
[   12.142343] Testing event btrfs_failed_cluster_setup: OK
[   12.149005] Testing event btrfs_find_cluster: OK
[   12.155681] Testing event btrfs_reserve_extent_cluster: OK
[   12.162350] Testing event btrfs_reserve_extent: OK
[   12.169007] Testing event find_free_extent: OK
[   12.175685] Testing event btrfs_reserved_extent_free: OK
[   12.182344] Testing event btrfs_reserved_extent_alloc: OK
[   12.189011] Testing event btrfs_space_reservation: OK
[   12.195682] Testing event btrfs_cow_block: OK
[   12.202340] Testing event btrfs_chunk_free: OK
[   12.209011] Testing event btrfs_chunk_alloc: OK
[   12.215681] Testing event run_delayed_ref_head: OK
[   12.222343] Testing event add_delayed_ref_head: OK
[   12.229028] Testing event run_delayed_data_ref: OK
[   12.235684] Testing event add_delayed_data_ref: OK
[   12.242348] Testing event run_delayed_tree_ref: OK
[   12.249006] Testing event add_delayed_tree_ref: OK
[   12.255677] Testing event btrfs_sync_fs: OK
[   12.262340] Testing event btrfs_sync_file: OK
[   12.269005] Testing event btrfs_writepage_end_io_hook: OK
[   12.275681] Testing event __extent_writepage: OK
[   12.282338] Testing event btrfs_ordered_extent_put: OK
[   12.289009] Testing event btrfs_ordered_extent_start: OK
[   12.295675] Testing event btrfs_ordered_extent_remove: OK
[   12.302340] Testing event btrfs_ordered_extent_add: OK
[   12.309009] Testing event btrfs_get_extent: OK
[   12.315676] Testing event btrfs_inode_evict: OK
[   12.322342] Testing event btrfs_inode_request: OK
[   12.329006] Testing event btrfs_inode_new: OK
[   12.335676] Testing event btrfs_transaction_commit: OK
[   12.342345] Testing event block_rq_remap: OK
[   12.349006] Testing event block_bio_remap: OK
[   12.355681] Testing event block_split: OK
[   12.362339] Testing event block_unplug: OK
[   12.369009] Testing event block_plug: OK
[   12.375680] Testing event block_sleeprq: OK
[   12.382348] Testing event block_getrq: OK
[   12.389042] Testing event block_bio_queue: OK
[   12.395680] Testing event block_bio_frontmerge: OK
[   12.402340] Testing event block_bio_backmerge: OK
[   12.409011] Testing event block_bio_complete: OK
[   12.415711] Testing event block_bio_bounce: OK
[   12.422350] Testing event block_rq_issue: OK
[   12.429008] Testing event block_rq_insert: OK
[   12.435706] Testing event block_rq_complete: OK
[   12.442352] Testing event block_rq_requeue: OK
[   12.449007] Testing event block_rq_abort: OK
[   12.455694] Testing event block_dirty_buffer: OK
[   12.462342] Testing event block_touch_buffer: OK
[   12.469021] Testing event swiotlb_bounced: OK
[   12.475682] Testing event gpio_value: OK
[   12.482341] Testing event gpio_direction: OK
[   12.489013] Testing event regulator_set_voltage_complete: OK
[   12.495679] Testing event regulator_set_voltage: OK
[   12.502340] Testing event regulator_disable_complete: OK
[   12.509011] Testing event regulator_disable: OK
[   12.515680] Testing event regulator_enable_complete: OK
[   12.522344] Testing event regulator_enable_delay: OK
[   12.529008] Testing event regulator_enable: OK
[   12.535679] Testing event urandom_read: OK
[   12.542346] Testing event random_read: OK
[   12.549008] Testing event extract_entropy_user: OK
[   12.555682] Testing event extract_entropy: OK
[   12.562357] Testing event get_random_bytes_arch: OK
[   12.569010] Testing event get_random_bytes: OK
[   12.575685] Testing event xfer_secondary_pool: OK
[   12.582342] Testing event add_disk_randomness: OK
[   12.589013] Testing event add_input_randomness: OK
[   12.595682] Testing event debit_entropy: OK
[   12.602344] Testing event push_to_pool: OK
[   12.609019] Testing event credit_entropy_bits: OK
[   12.615680] Testing event mix_pool_bytes_nolock: OK
[   12.622346] Testing event mix_pool_bytes: OK
[   12.629011] Testing event add_device_randomness: OK
[   12.635712] Testing event drm_vblank_event_delivered: OK
[   12.642376] Testing event drm_vblank_event_queued: OK
[   12.649010] Testing event drm_vblank_event: OK
[   12.655684] Testing event regcache_drop_region: OK
[   12.662345] Testing event regmap_async_complete_done: OK
[   12.669050] Testing event regmap_async_complete_start: OK
[   12.675686] Testing event regmap_async_io_complete: OK
[   12.682349] Testing event regmap_async_write_start: OK
[   12.689014] Testing event regmap_cache_bypass: OK
[   12.695682] Testing event regmap_cache_only: OK
[   12.703004] Testing event regcache_sync: OK
[   12.709020] Testing event regmap_hw_write_done: OK
[   12.715684] Testing event regmap_hw_write_start: OK
[   12.722353] Testing event regmap_hw_read_done: OK
[   12.729011] Testing event regmap_hw_read_start: OK
[   12.735689] Testing event regmap_reg_read_cache: OK
[   12.742380] Testing event regmap_reg_read: OK
[   12.749022] Testing event regmap_reg_write: OK
[   12.755697] Testing event fence_wait_end: OK
[   12.762345] Testing event fence_wait_start: OK
[   12.769033] Testing event fence_signaled: OK
[   12.775690] Testing event fence_enable_signal: OK
[   12.782356] Testing event fence_destroy: OK
[   12.789016] Testing event fence_init: OK
[   12.795682] Testing event fence_emit: OK
[   12.802351] Testing event fence_annotate_wait_on: OK
[   12.809016] Testing event scsi_eh_wakeup: OK
[   12.815696] Testing event scsi_dispatch_cmd_timeout: OK
[   12.822350] Testing event scsi_dispatch_cmd_done: OK
[   12.829015] Testing event scsi_dispatch_cmd_error: OK
[   12.835682] Testing event scsi_dispatch_cmd_start: OK
[   12.842354] Testing event target_cmd_complete: OK
[   12.849012] Testing event target_sequencer_start: OK
[   12.855687] Testing event docg3_io: OK
[   12.862346] Testing event spi_transfer_stop: OK
[   12.869011] Testing event spi_transfer_start: OK
[   12.875686] Testing event spi_message_done: OK
[   12.882346] Testing event spi_message_start: OK
[   12.889019] Testing event spi_message_submit: OK
[   12.895684] Testing event spi_master_busy: OK
[   12.902346] Testing event spi_master_idle: OK
[   12.909017] Testing event dwc3_complete_trb: OK
[   12.915683] Testing event dwc3_prepare_trb: OK
[   12.922349] Testing event dwc3_gadget_ep_cmd: OK
[   12.929012] Testing event dwc3_gadget_generic_cmd: OK
[   12.935681] Testing event dwc3_gadget_giveback: OK
[   12.942348] Testing event dwc3_ep_dequeue: OK
[   12.949014] Testing event dwc3_ep_queue: OK
[   12.955693] Testing event dwc3_free_request: OK
[   12.962345] Testing event dwc3_alloc_request: OK
[   12.969013] Testing event dwc3_ctrl_req: OK
[   12.975685] Testing event dwc3_event: OK
[   12.982345] Testing event dwc3_ep0: OK
[   12.989015] Testing event dwc3_writel: OK
[   12.995682] Testing event dwc3_readl: OK
[   13.002345] Testing event xhci_cmd_completion: OK
[   13.009016] Testing event xhci_address_ctx: OK
[   13.015681] Testing event xhci_dbg_ring_expansion: OK
[   13.022349] Testing event xhci_dbg_init: OK
[   13.029012] Testing event xhci_dbg_cancel_urb: OK
[   13.035682] Testing event xhci_dbg_reset_ep: OK
[   13.042349] Testing event xhci_dbg_quirks: OK
[   13.049013] Testing event xhci_dbg_context_change: OK
[   13.055689] Testing event xhci_dbg_address: OK
[   13.062346] Testing event smbus_result: OK
[   13.069012] Testing event smbus_reply: OK
[   13.075687] Testing event smbus_read: OK
[   13.082348] Testing event smbus_write: OK
[   13.089017] Testing event i2c_result: OK
[   13.095682] Testing event i2c_reply: OK
[   13.102348] Testing event i2c_read: OK
[   13.109018] Testing event i2c_write: OK
[   13.115682] Testing event v4l2_qbuf: OK
[   13.122350] Testing event v4l2_dqbuf: OK
[   13.129014] Testing event thermal_zone_trip: OK
[   13.135683] Testing event cdev_update: OK
[   13.142349] Testing event thermal_temperature: OK
[   13.149013] Testing event bcache_writeback_collision: OK
[   13.155688] Testing event bcache_writeback: OK
[   13.162348] Testing event bcache_alloc_fail: OK
[   13.169013] Testing event bcache_alloc: OK
[   13.175686] Testing event bcache_invalidate: OK
[   13.182348] Testing event bcache_keyscan: OK
[   13.189017] Testing event bcache_btree_set_root: OK
[   13.195697] Testing event bcache_btree_node_compact: OK
[   13.202348] Testing event bcache_btree_node_split: OK
[   13.209021] Testing event bcache_btree_insert_key: OK
[   13.215685] Testing event bcache_gc_copy_collision: OK
[   13.222355] Testing event bcache_gc_copy: OK
[   13.229023] Testing event bcache_gc_end: OK
[   13.235690] Testing event bcache_gc_start: OK
[   13.242356] Testing event bcache_btree_gc_coalesce: OK
[   13.249015] Testing event bcache_btree_node_free: OK
[   13.255687] Testing event bcache_btree_node_alloc_fail: OK
[   13.262347] Testing event bcache_btree_node_alloc: OK
[   13.269014] Testing event bcache_btree_write: OK
[   13.275695] Testing event bcache_btree_read: OK
[   13.282349] Testing event bcache_btree_cache_cannibalize: OK
[   13.289017] Testing event bcache_journal_write: OK
[   13.295686] Testing event bcache_journal_entry_full: OK
[   13.302348] Testing event bcache_journal_full: OK
[   13.309021] Testing event bcache_journal_replay_key: OK
[   13.315684] Testing event bcache_cache_insert: OK
[   13.322353] Testing event bcache_read_retry: OK
[   13.329014] Testing event bcache_write: OK
[   13.335685] Testing event bcache_read: OK
[   13.342351] Testing event bcache_bypass_congested: OK
[   13.349015] Testing event bcache_bypass_sequential: OK
[   13.355688] Testing event bcache_request_end: OK
[   13.362348] Testing event bcache_request_start: OK
[   13.369018] Testing event udp_fail_queue_rcv_skb: OK
[   13.375689] Testing event sock_exceed_buf_limit: OK
[   13.382348] Testing event sock_rcvqueue_full: OK
[   13.389020] Testing event napi_poll: OK
[   13.395684] Testing event netif_rx_ni_entry: OK
[   13.402349] Testing event netif_rx_entry: OK
[   13.409020] Testing event netif_receive_skb_entry: OK
[   13.415685] Testing event napi_gro_receive_entry: OK
[   13.422352] Testing event napi_gro_frags_entry: OK
[   13.429016] Testing event netif_rx: OK
[   13.435686] Testing event netif_receive_skb: OK
[   13.442352] Testing event net_dev_queue: OK
[   13.449016] Testing event net_dev_xmit: OK
[   13.455688] Testing event net_dev_start_xmit: OK
[   13.462349] Testing event skb_copy_datagram_iovec: OK
[   13.469016] Testing event consume_skb: OK
[   13.475688] Testing event kfree_skb: OK
[   13.482349] Running tests on trace event systems:
[   13.482864] Testing event system skb: OK
[   13.489030] Testing event system net: OK
[   13.495699] Testing event system napi: OK
[   13.502359] Testing event system sock: OK
[   13.509032] Testing event system udp: OK
[   13.515697] Testing event system bcache: OK
[   13.522377] Testing event system thermal: OK
[   13.529028] Testing event system v4l2: OK
[   13.535697] Testing event system i2c: OK
[   13.542366] Testing event system xhci-hcd: OK
[   13.549030] Testing event system dwc3: OK
[   13.555705] Testing event system spi: OK
[   13.562362] Testing event system docg3: OK
[   13.569026] Testing event system target: OK
[   13.575699] Testing event system scsi: OK
[   13.582362] Testing event system fence: OK
[   13.589033] Testing event system regmap: OK
[   13.595702] Testing event system drm: OK
[   13.602361] Testing event system random: OK
[   13.609036] Testing event system regulator: OK
[   13.615700] Testing event system gpio: OK
[   13.622363] Testing event system swiotlb: OK
[   13.629027] Testing event system block: OK
[   13.635704] Testing event system btrfs: OK
[   13.642382] Testing event system jbd2: OK
[   13.649034] Testing event system jbd: OK
[   13.655703] Testing event system ext4: OK
[   13.662407] Testing event system ext3: OK
[   13.669044] Testing event system filelock: OK
[   13.675702] Testing event system writeback: OK
[   13.682374] Testing event system migrate: OK
[   13.689031] Testing event system compaction: OK
[   13.695699] Testing event system kmem: OK
[   13.702366] Testing event system vmscan: OK
[   13.709038] Testing event system pagemap: OK
[   13.715701] Testing event system oom: OK
[   13.722365] Testing event system filemap: OK
[   13.729028] Testing event system rpm: OK
[   13.735699] Testing event system power: OK
[   13.742375] Testing event system test: OK
[   13.749028] Testing event system timer: OK
[   13.755709] Testing event system rcu: OK
[   13.762362] Testing event system printk: OK
[   13.769028] Testing event system lock: OK
[   13.775760] Testing event system sched: OK
[   13.782378] Testing event system workqueue: OK
[   13.789037] Testing event system signal: OK
[   13.795699] Testing event system irq: OK
[   13.802366] Testing event system task: OK
[   13.809033] Testing event system exceptions: OK
[   13.815702] Testing event system tlb: OK
[   13.822366] Testing event system mce: OK
[   13.829028] Testing event system raw_syscalls: OK
[   13.835705] Testing event system nmi: OK
[   13.842368] Testing event system irq_vectors: OK
[   13.849044] Testing event system xen: OK
[   13.855749] Running tests on all trace events:
[   13.856224] Testing all events: OK
[   13.997736] Running tests again, along with the function tracer
[   13.998522] Running tests on trace events:
[   13.999069] Testing event xen_cpu_set_ldt: OK
[   14.015808] Testing event xen_cpu_write_gdt_entry:=20
[   14.016601] test-events (730) used greatest stack depth: 7152 bytes left
[   14.022485] OK
[   14.022726] Testing event xen_cpu_load_idt: OK
[   14.029151] Testing event xen_cpu_write_idt_entry: OK
[   14.035795] Testing event xen_cpu_write_ldt_entry: OK
[   14.042491] Testing event xen_mmu_write_cr3: OK
[   14.049149] Testing event xen_mmu_flush_tlb_others: OK
[   14.055820] Testing event xen_mmu_flush_tlb_single: OK
[   14.062467] Testing event xen_mmu_flush_tlb: OK
[   14.069150] Testing event xen_mmu_flush_tlb_all: OK
[   14.075817] Testing event xen_mmu_pgd_unpin: OK
[   14.082483] Testing event xen_mmu_pgd_pin: OK
[   14.089171] Testing event xen_mmu_release_ptpage: OK
[   14.095793] Testing event xen_mmu_alloc_ptpage: OK
[   14.102468] Testing event xen_mmu_ptep_modify_prot_commit: OK
[   14.109176] Testing event xen_mmu_ptep_modify_prot_start: OK
[   14.115788] Testing event xen_mmu_pgd_clear: OK
[   14.122479] Testing event xen_mmu_set_pud: OK
[   14.129142] Testing event xen_mmu_pmd_clear: OK
[   14.135787] Testing event xen_mmu_set_pmd: OK
[   14.142480] Testing event xen_mmu_pte_clear: OK
[   14.149140] Testing event xen_mmu_set_pte_at: OK
[   14.155859] Testing event xen_mmu_set_domain_pte: OK
[   14.162462] Testing event xen_mmu_set_pte_atomic: OK
[   14.169140] Testing event xen_mmu_set_pte: OK
[   14.175806] Testing event xen_mc_extend_args: OK
[   14.182459] Testing event xen_mc_flush: OK
[   14.189159] Testing event xen_mc_flush_reason: OK
[   14.195788] Testing event xen_mc_callback: OK
[   14.202459] Testing event xen_mc_entry_alloc: OK
[   14.209160] Testing event xen_mc_entry: OK
[   14.215786] Testing event xen_mc_issue: OK
[   14.222477] Testing event xen_mc_batch: OK
[   14.229139] Testing event thermal_apic_exit: OK
[   14.235789] Testing event thermal_apic_entry: OK
[   14.242479] Testing event threshold_apic_exit: OK
[   14.249142] Testing event threshold_apic_entry: OK
[   14.255810] Testing event call_function_single_exit: OK
[   14.262463] Testing event call_function_single_entry: OK
[   14.269142] Testing event call_function_exit: OK
[   14.275808] Testing event call_function_entry: OK
[   14.282459] Testing event irq_work_exit: OK
[   14.289164] Testing event irq_work_entry: OK
[   14.295788] Testing event x86_platform_ipi_exit: OK
[   14.302502] Testing event x86_platform_ipi_entry: OK
[   14.309202] Testing event error_apic_exit: OK
[   14.315790] Testing event error_apic_entry: OK
[   14.323661] Testing event spurious_apic_exit: OK
[   14.329150] Testing event spurious_apic_entry: OK
[   14.335789] Testing event reschedule_exit: OK
[   14.342481] Testing event reschedule_entry: OK
[   14.349143] Testing event local_timer_exit: OK
[   14.355810] Testing event local_timer_entry: OK
[   14.362463] Testing event nmi_handler: OK
[   14.369145] Testing event sys_exit: OK
[   14.375814] Testing event sys_enter: OK
[   14.382467] Testing event mce_record:=20
[   14.383054] test-events (785) used greatest stack depth: 7140 bytes left
[   14.389092] OK
[   14.389337] Testing event tlb_flush: OK
[   14.395830] Testing event page_fault_kernel: OK
[   14.402470] Testing event page_fault_user: OK
[   14.409167] Testing event task_rename: OK
[   14.415811] Testing event task_newtask: OK
[   14.422488] Testing event softirq_raise: OK
[   14.429144] Testing event softirq_exit: OK
[   14.435788] Testing event softirq_entry: OK
[   14.442500] Testing event irq_handler_exit: OK
[   14.449166] Testing event irq_handler_entry: OK
[   14.455816] Testing event signal_deliver: OK
[   14.462462] Testing event signal_generate: OK
[   14.469191] Testing event workqueue_execute_end: OK
[   14.475853] Testing event workqueue_execute_start: OK
[   14.482463] Testing event workqueue_activate_work: OK
[   14.489165] Testing event workqueue_queue_work: OK
[   14.495788] Testing event sched_wake_idle_without_ipi: OK
[   14.502462] Testing event sched_swap_numa: OK
[   14.509164] Testing event sched_stick_numa: OK
[   14.515816] Testing event sched_move_numa: OK
[   14.522483] Testing event sched_pi_setprio: OK
[   14.529144] Testing event sched_stat_runtime: OK
[   14.535804] Testing event sched_stat_blocked: OK
[   14.542484] Testing event sched_stat_iowait: OK
[   14.549181] Testing event sched_stat_sleep: OK
[   14.555814] Testing event sched_stat_wait: OK
[   14.562480] Testing event sched_process_exec: OK
[   14.569155] Testing event sched_process_fork: OK
[   14.575811] Testing event sched_process_wait: OK
[   14.582464] Testing event sched_wait_task: OK
[   14.589164] Testing event sched_process_exit: OK
[   14.595790] Testing event sched_process_free: OK
[   14.602463] Testing event sched_migrate_task: OK
[   14.609166] Testing event sched_switch: OK
[   14.615794] Testing event sched_wakeup_new: OK
[   14.622483] Testing event sched_wakeup: OK
[   14.629147] Testing event sched_kthread_stop_ret: OK
[   14.635792] Testing event sched_kthread_stop: OK
[   14.642484] Testing event lock_release: OK
[   14.649185] Testing event lock_acquire: OK
[   14.655845] Testing event console: OK
[   14.662465] Testing event rcu_utilization: OK
[   14.669179] Testing event itimer_expire: OK
[   14.675821] Testing event itimer_state: OK
[   14.682462] Testing event hrtimer_cancel: OK
[   14.689192] Testing event hrtimer_expire_exit: OK
[   14.695797] Testing event hrtimer_expire_entry: OK
[   14.702465] Testing event hrtimer_start: OK
[   14.709210] Testing event hrtimer_init: OK
[   14.715812] Testing event timer_cancel: OK
[   14.722486] Testing event timer_expire_exit: OK
[   14.729146] Testing event timer_expire_entry: OK
[   14.735793] Testing event timer_start: OK
[   14.742486] Testing event timer_init: OK
[   14.749163] Testing event ftrace_test_filter: OK
[   14.755819] Testing event dev_pm_qos_remove_request: OK
[   14.762495] Testing event dev_pm_qos_update_request: OK
[   14.769174] Testing event dev_pm_qos_add_request: OK
[   14.775814] Testing event pm_qos_update_flags: OK
[   14.782479] Testing event pm_qos_update_target: OK
[   14.789196] Testing event pm_qos_update_request_timeout: OK
[   14.795795] Testing event pm_qos_remove_request: OK
[   14.802474] Testing event pm_qos_update_request: OK
[   14.809201] Testing event pm_qos_add_request: OK
[   14.815812] Testing event power_domain_target: OK
[   14.822488] Testing event clock_set_rate: OK
[   14.829153] Testing event clock_disable: OK
[   14.835824] Testing event clock_enable: OK
[   14.842499] Testing event wakeup_source_deactivate: OK
[   14.849147] Testing event wakeup_source_activate: OK
[   14.855814] Testing event suspend_resume: OK
[   14.862477] Testing event device_pm_callback_end: OK
[   14.869148] Testing event device_pm_callback_start: OK
[   14.875821] Testing event cpu_frequency: OK
[   14.882477] Testing event pstate_sample: OK
[   14.889170] Testing event cpu_idle: OK
[   14.895800] Testing event rpm_return_int: OK
[   14.902476] Testing event rpm_idle: OK
[   14.909169] Testing event rpm_resume: OK
[   14.915793] Testing event rpm_suspend: OK
[   14.922500] Testing event mm_filemap_add_to_page_cache: OK
[   14.929148] Testing event mm_filemap_delete_from_page_cache: OK
[   14.935793] Testing event oom_score_adj_update: OK
[   14.942486] Testing event mm_lru_activate: OK
[   14.949200] Testing event mm_lru_insertion: OK
[   14.955854] Testing event mm_vmscan_lru_shrink_inactive: OK
[   14.962477] Testing event mm_vmscan_writepage: OK
[   14.969149] Testing event mm_vmscan_memcg_isolate: OK
[   14.975815] Testing event mm_vmscan_lru_isolate: OK
[   14.982477] Testing event mm_shrink_slab_end: OK
[   14.989168] Testing event mm_shrink_slab_start: OK
[   14.995795] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[   15.002468] Testing event mm_vmscan_memcg_reclaim_end: OK
[   15.009171] Testing event mm_vmscan_direct_reclaim_end: OK
[   15.015794] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[   15.022489] Testing event mm_vmscan_memcg_reclaim_begin: OK
[   15.029149] Testing event mm_vmscan_direct_reclaim_begin: OK
[   15.035807] Testing event mm_vmscan_wakeup_kswapd: OK
[   15.042505] Testing event mm_vmscan_kswapd_wake: OK
[   15.049152] Testing event mm_vmscan_kswapd_sleep: OK
[   15.055816] Testing event mm_page_alloc_extfrag: OK
[   15.062468] Testing event mm_page_pcpu_drain: OK
[   15.069159] Testing event mm_page_alloc_zone_locked: OK
[   15.075816] Testing event mm_page_alloc: OK
[   15.082468] Testing event mm_page_free_batched: OK
[   15.089168] Testing event mm_page_free: OK
[   15.095793] Testing event kmem_cache_free: OK
[   15.102467] Testing event kfree: OK
[   15.109175] Testing event kmem_cache_alloc_node: OK
[   15.115794] Testing event kmalloc_node: OK
[   15.122823] Testing event kmem_cache_alloc: OK
[   15.129156] Testing event kmalloc: OK
[   15.135809] Testing event mm_compaction_end: OK
[   15.142497] Testing event mm_compaction_begin: OK
[   15.149156] Testing event mm_compaction_migratepages: OK
[   15.155823] Testing event mm_compaction_isolate_freepages: OK
[   15.162478] Testing event mm_compaction_isolate_migratepages: OK
[   15.169156] Testing event mm_numa_migrate_ratelimit: OK
[   15.175831] Testing event mm_migrate_pages: OK
[   15.182484] Testing event writeback_single_inode: OK
[   15.189184] Testing event writeback_single_inode_start: OK
[   15.195809] Testing event writeback_wait_iff_congested: OK
[   15.202479] Testing event writeback_congestion_wait: OK
[   15.209193] Testing event writeback_sb_inodes_requeue: OK
[   15.215807] Testing event balance_dirty_pages: OK
[   15.222500] Testing event bdi_dirty_ratelimit: OK
[   15.229185] Testing event global_dirty_state: OK
[   15.235807] Testing event writeback_queue_io: OK
[   15.242522] Testing event wbc_writepage: OK
[   15.249165] Testing event writeback_bdi_unregister: OK
[   15.255829] Testing event writeback_bdi_register: OK
[   15.262499] Testing event writeback_wake_background: OK
[   15.269167] Testing event writeback_nowork: OK
[   15.275839] Testing event writeback_pages_written: OK
[   15.282480] Testing event writeback_wait: OK
[   15.289188] Testing event writeback_written: OK
[   15.295805] Testing event writeback_start: OK
[   15.302525] Testing event writeback_exec: OK
[   15.309224] Testing event writeback_queue: OK
[   15.315802] Testing event writeback_write_inode: OK
[   15.322499] Testing event writeback_write_inode_start: OK
[   15.329161] Testing event writeback_dirty_inode: OK
[   15.335819] Testing event writeback_dirty_inode_start: OK
[   15.342514] Testing event writeback_dirty_page: OK
[   15.349151] Testing event time_out_leases: OK
[   15.355817] Testing event generic_delete_lease: OK
[   15.362470] Testing event generic_add_lease: OK
[   15.369156] Testing event break_lease_unblock: OK
[   15.375819] Testing event break_lease_block: OK
[   15.382481] Testing event break_lease_noblock: OK
[   15.389172] Testing event ext3_load_inode: OK
[   15.395802] Testing event ext3_get_blocks_exit: OK
[   15.402471] Testing event ext3_get_blocks_enter: OK
[   15.409179] Testing event ext3_truncate_exit: OK
[   15.415810] Testing event ext3_truncate_enter: OK
[   15.422502] Testing event ext3_unlink_exit: OK
[   15.429150] Testing event ext3_unlink_enter: OK
[   15.435811] Testing event ext3_direct_IO_exit: OK
[   15.442492] Testing event ext3_direct_IO_enter: OK
[   15.449155] Testing event ext3_read_block_bitmap: OK
[   15.455828] Testing event ext3_forget: OK
[   15.462472] Testing event ext3_reserved: OK
[   15.469153] Testing event ext3_alloc_new_reservation: OK
[   15.475818] Testing event ext3_discard_reservation: OK
[   15.484708] Testing event ext3_rsv_window_add: OK
[   15.489171] Testing event ext3_sync_fs: OK
[   15.495798] Testing event ext3_sync_file_exit: OK
[   15.502469] Testing event ext3_sync_file_enter: OK
[   15.509185] Testing event ext3_free_blocks: OK
[   15.515797] Testing event ext3_allocate_blocks: OK
[   15.522489] Testing event ext3_request_blocks: OK
[   15.529151] Testing event ext3_discard_blocks: OK
[   15.537186] Testing event ext3_invalidatepage: OK
[   15.542494] Testing event ext3_releasepage: OK
[   15.549152] Testing event ext3_readpage: OK
[   15.555817] Testing event ext3_journalled_writepage: OK
[   15.562475] Testing event ext3_writeback_writepage: OK
[   15.569152] Testing event ext3_ordered_writepage: OK
[   15.575819] Testing event ext3_journalled_write_end: OK
[   15.582476] Testing event ext3_writeback_write_end: OK
[   15.589171] Testing event ext3_ordered_write_end: OK
[   15.595796] Testing event ext3_write_begin: OK
[   15.602471] Testing event ext3_mark_inode_dirty: OK
[   15.609173] Testing event ext3_drop_inode: OK
[   15.615806] Testing event ext3_evict_inode: OK
[   15.622491] Testing event ext3_allocate_inode: OK
[   15.629152] Testing event ext3_request_inode: OK
[   15.635797] Testing event ext3_free_inode: OK
[   15.642491] Testing event ext4_es_shrink: OK
[   15.649154] Testing event ext4_collapse_range: OK
[   15.655817] Testing event ext4_es_shrink_scan_exit: OK
[   15.662469] Testing event ext4_es_shrink_scan_enter: OK
[   15.669154] Testing event ext4_es_shrink_count: OK
[   15.675827] Testing event ext4_es_lookup_extent_exit: OK
[   15.682472] Testing event ext4_es_lookup_extent_enter: OK
[   15.689172] Testing event ext4_es_find_delayed_extent_range_exit: OK
[   15.695798] Testing event ext4_es_find_delayed_extent_range_enter: OK
[   15.702470] Testing event ext4_es_remove_extent: OK
[   15.709173] Testing event ext4_es_cache_extent: OK
[   15.715800] Testing event ext4_es_insert_extent: OK
[   15.722492] Testing event ext4_ext_remove_space_done: OK
[   15.729152] Testing event ext4_ext_remove_space: OK
[   15.735798] Testing event ext4_ext_rm_idx: OK
[   15.742492] Testing event ext4_ext_rm_leaf: OK
[   15.749153] Testing event ext4_remove_blocks: OK
[   15.755818] Testing event ext4_ext_show_extent: OK
[   15.762471] Testing event ext4_get_reserved_cluster_alloc: OK
[   15.769154] Testing event ext4_find_delalloc_range: OK
[   15.775818] Testing event ext4_ext_in_cache: OK
[   15.782470] Testing event ext4_ext_put_in_cache: OK
[   15.789173] Testing event ext4_get_implied_cluster_alloc_exit: OK
[   15.795799] Testing event ext4_ext_handle_unwritten_extents: OK
[   15.802472] Testing event ext4_trim_all_free: OK
[   15.809173] Testing event ext4_trim_extent: OK
[   15.815799] Testing event ext4_journal_start_reserved: OK
[   15.822491] Testing event ext4_journal_start: OK
[   15.829154] Testing event ext4_load_inode: OK
[   15.835801] Testing event ext4_ext_load_extent: OK
[   15.842492] Testing event ext4_ind_map_blocks_exit: OK
[   15.849153] Testing event ext4_ext_map_blocks_exit: OK
[   15.855821] Testing event ext4_ind_map_blocks_enter: OK
[   15.862472] Testing event ext4_ext_map_blocks_enter: OK
[   15.869168] Testing event ext4_ext_convert_to_initialized_fastpath: OK
[   15.875821] Testing event ext4_ext_convert_to_initialized_enter: OK
[   15.882471] Testing event ext4_truncate_exit: OK
[   15.889174] Testing event ext4_truncate_enter: OK
[   15.895799] Testing event ext4_unlink_exit: OK
[   15.905393] Testing event ext4_unlink_enter: OK
[   15.912472] Testing event ext4_fallocate_exit: OK
[   15.919153] Testing event ext4_zero_range: OK
[   15.925819] Testing event ext4_punch_hole: OK
[   15.932473] Testing event ext4_fallocate_enter: OK
[   15.939161] Testing event ext4_direct_IO_exit: OK
[   15.945800] Testing event ext4_direct_IO_enter: OK
[   15.952474] Testing event ext4_load_inode_bitmap: OK
[   15.959175] Testing event ext4_read_block_bitmap_load: OK
[   15.965809] Testing event ext4_mb_buddy_bitmap_load: OK
[   15.972470] Testing event ext4_mb_bitmap_load:=20
[   15.973143] test-events (1023) used greatest stack depth: 7100 bytes left
[   15.979075] OK
[   15.979313] Testing event ext4_da_release_space: OK
[   15.985800] Testing event ext4_da_reserve_space: OK
[   15.992492] Testing event ext4_da_update_reserve_space: OK
[   15.999162] Testing event ext4_forget: OK
[   16.005804] Testing event ext4_mballoc_free: OK
[   16.012483] Testing event ext4_mballoc_discard: OK
[   16.019155] Testing event ext4_mballoc_prealloc: OK
[   16.025827] Testing event ext4_mballoc_alloc: OK
[   16.032478] Testing event ext4_alloc_da_blocks: OK
[   16.039167] Testing event ext4_sync_fs: OK
[   16.045800] Testing event ext4_sync_file_exit: OK
[   16.052499] Testing event ext4_sync_file_enter: OK
[   16.059178] Testing event ext4_free_blocks: OK
[   16.065804] Testing event ext4_allocate_blocks: OK
[   16.072505] Testing event ext4_request_blocks: OK
[   16.079170] Testing event ext4_mb_discard_preallocations: OK
[   16.085803] Testing event ext4_discard_preallocations: OK
[   16.092501] Testing event ext4_mb_release_group_pa: OK
[   16.099157] Testing event ext4_mb_release_inode_pa: OK
[   16.105818] Testing event ext4_mb_new_group_pa: OK
[   16.112479] Testing event ext4_mb_new_inode_pa: OK
[   16.119162] Testing event ext4_discard_blocks: OK
[   16.125836] Testing event ext4_journalled_invalidatepage: OK
[   16.132476] Testing event ext4_invalidatepage: OK
[   16.139166] Testing event ext4_releasepage: OK
[   16.145812] Testing event ext4_readpage: OK
[   16.152477] Testing event ext4_writepage: OK
[   16.159184] Testing event ext4_writepages_result: OK
[   16.165811] Testing event ext4_da_write_pages_extent: OK
[   16.172475] Testing event ext4_da_write_pages: OK
[   16.179169] Testing event ext4_writepages: OK
[   16.185813] Testing event ext4_da_write_end: OK
[   16.192496] Testing event ext4_journalled_write_end: OK
[   16.199161] Testing event ext4_write_end: OK
[   16.205811] Testing event ext4_da_write_begin: OK
[   16.212480] Testing event ext4_write_begin: OK
[   16.219168] Testing event ext4_begin_ordered_truncate: OK
[   16.225824] Testing event ext4_mark_inode_dirty: OK
[   16.232474] Testing event ext4_drop_inode: OK
[   16.239208] Testing event ext4_evict_inode: OK
[   16.245812] Testing event ext4_allocate_inode: OK
[   16.252476] Testing event ext4_request_inode: OK
[   16.259184] Testing event ext4_free_inode: OK
[   16.265820] Testing event journal_write_superblock: OK
[   16.272478] Testing event jbd_cleanup_journal_tail: OK
[   16.279157] Testing event jbd_do_submit_data: OK
[   16.285826] Testing event jbd_end_commit: OK
[   16.292515] Testing event jbd_drop_transaction: OK
[   16.299159] Testing event jbd_commit_logging: OK
[   16.305854] Testing event jbd_commit_flushing: OK
[   16.312478] Testing event jbd_commit_locking: OK
[   16.319163] Testing event jbd_start_commit: OK
[   16.325823] Testing event jbd_checkpoint: OK
[   16.332481] Testing event jbd2_lock_buffer_stall: OK
[   16.339158] Testing event jbd2_write_superblock: OK
[   16.345805] Testing event jbd2_update_log_tail: OK
[   16.352482] Testing event jbd2_checkpoint_stats: OK
[   16.359179] Testing event jbd2_run_stats: OK
[   16.365804] Testing event jbd2_handle_stats: OK
[   16.372488] Testing event jbd2_handle_extend: OK
[   16.379166] Testing event jbd2_handle_start: OK
[   16.385804] Testing event jbd2_submit_inode_data: OK
[   16.392514] Testing event jbd2_end_commit: OK
[   16.399171] Testing event jbd2_drop_transaction: OK
[   16.405810] Testing event jbd2_commit_logging: OK
[   16.412478] Testing event jbd2_commit_flushing: OK
[   16.419174] Testing event jbd2_commit_locking: OK
[   16.425838] Testing event jbd2_start_commit: OK
[   16.432480] Testing event jbd2_checkpoint: OK
[   16.441174] Testing event btrfs_qgroup_record_ref: OK
[   16.445835] Testing event btrfs_qgroup_account: OK
[   16.452484] Testing event btrfs_workqueue_destroy: OK
[   16.459185] Testing event btrfs_workqueue_alloc: OK
[   16.465844] Testing event btrfs_ordered_sched: OK
[   16.472484] Testing event btrfs_all_work_done: OK
[   16.479171] Testing event btrfs_work_sched: OK
[   16.485806] Testing event btrfs_work_queued: OK
[   16.492508] Testing event free_extent_state: OK
[   16.499161] Testing event alloc_extent_state: OK
[   16.505807] Testing event btrfs_setup_cluster: OK
[   16.512493] Testing event btrfs_failed_cluster_setup: OK
[   16.519191] Testing event btrfs_find_cluster: OK
[   16.525858] Testing event btrfs_reserve_extent_cluster: OK
[   16.532485] Testing event btrfs_reserve_extent: OK
[   16.539160] Testing event find_free_extent: OK
[   16.545838] Testing event btrfs_reserved_extent_free: OK
[   16.552485] Testing event btrfs_reserved_extent_alloc: OK
[   16.559231] Testing event btrfs_space_reservation: OK
[   16.565809] Testing event btrfs_cow_block: OK
[   16.572498] Testing event btrfs_chunk_free: OK
[   16.579166] Testing event btrfs_chunk_alloc: OK
[   16.585838] Testing event run_delayed_ref_head: OK
[   16.592509] Testing event add_delayed_ref_head: OK
[   16.599163] Testing event run_delayed_data_ref: OK
[   16.605815] Testing event add_delayed_data_ref: OK
[   16.612494] Testing event run_delayed_tree_ref: OK
[   16.619165] Testing event add_delayed_tree_ref: OK
[   16.625877] Testing event btrfs_sync_fs: OK
[   16.632503] Testing event btrfs_sync_file: OK
[   16.639183] Testing event btrfs_writepage_end_io_hook: OK
[   16.645809] Testing event __extent_writepage: OK
[   16.652479] Testing event btrfs_ordered_extent_put: OK
[   16.659211] Testing event btrfs_ordered_extent_start: OK
[   16.665815] Testing event btrfs_ordered_extent_remove: OK
[   16.672509] Testing event btrfs_ordered_extent_add: OK
[   16.679169] Testing event btrfs_get_extent: OK
[   16.685808] Testing event btrfs_inode_evict: OK
[   16.692513] Testing event btrfs_inode_request: OK
[   16.699161] Testing event btrfs_inode_new: OK
[   16.705831] Testing event btrfs_transaction_commit: OK
[   16.712489] Testing event block_rq_remap: OK
[   16.719166] Testing event block_bio_remap: OK
[   16.725884] Testing event block_split: OK
[   16.732518] Testing event block_unplug: OK
[   16.739168] Testing event block_plug: OK
[   16.745808] Testing event block_sleeprq: OK
[   16.752485] Testing event block_getrq: OK
[   16.759193] Testing event block_bio_queue: OK
[   16.765810] Testing event block_bio_frontmerge: OK
[   16.772479] Testing event block_bio_backmerge: OK
[   16.779196] Testing event block_bio_complete: OK
[   16.785843] Testing event block_bio_bounce: OK
[   16.792505] Testing event block_rq_issue: OK
[   16.799191] Testing event block_rq_insert: OK
[   16.805821] Testing event block_rq_complete: OK
[   16.812513] Testing event block_rq_requeue: OK
[   16.819174] Testing event block_rq_abort: OK
[   16.825848] Testing event block_dirty_buffer: OK
[   16.832510] Testing event block_touch_buffer: OK
[   16.839164] Testing event swiotlb_bounced: OK
[   16.845843] Testing event gpio_value: OK
[   16.852511] Testing event gpio_direction: OK
[   16.859187] Testing event regulator_set_voltage_complete: OK
[   16.865808] Testing event regulator_set_voltage: OK
[   16.872488] Testing event regulator_disable_complete: OK
[   16.879171] Testing event regulator_disable: OK
[   16.885810] Testing event regulator_enable_complete: OK
[   16.892504] Testing event regulator_enable_delay: OK
[   16.899162] Testing event regulator_enable: OK
[   16.905820] Testing event urandom_read: OK
[   16.912485] Testing event random_read: OK
[   16.919176] Testing event extract_entropy_user: OK
[   16.925876] Testing event extract_entropy: OK
[   16.932489] Testing event get_random_bytes_arch: OK
[   16.939176] Testing event get_random_bytes: OK
[   16.945808] Testing event xfer_secondary_pool: OK
[   16.952488] Testing event add_disk_randomness: OK
[   16.959183] Testing event add_input_randomness: OK
[   16.965809] Testing event debit_entropy: OK
[   16.972539] Testing event push_to_pool: OK
[   16.979194] Testing event credit_entropy_bits: OK
[   16.985814] Testing event mix_pool_bytes_nolock: OK
[   16.992520] Testing event mix_pool_bytes: OK
[   16.999181] Testing event add_device_randomness: OK
[   17.005812] Testing event drm_vblank_event_delivered: OK
[   17.012506] Testing event drm_vblank_event_queued: OK
[   17.019184] Testing event drm_vblank_event: OK
[   17.025839] Testing event regcache_drop_region: OK
[   17.032506] Testing event regmap_async_complete_done: OK
[   17.039175] Testing event regmap_async_complete_start: OK
[   17.045810] Testing event regmap_async_io_complete: OK
[   17.052528] Testing event regmap_async_write_start: OK
[   17.059213] Testing event regmap_cache_bypass: OK
[   17.065834] Testing event regmap_cache_only: OK
[   17.072496] Testing event regcache_sync: OK
[   17.079172] Testing event regmap_hw_write_done: OK
[   17.085836] Testing event regmap_hw_write_start: OK
[   17.092548] Testing event regmap_hw_read_done: OK
[   17.099168] Testing event regmap_hw_read_start: OK
[   17.105821] Testing event regmap_reg_read_cache: OK
[   17.112494] Testing event regmap_reg_read: OK
[   17.119170] Testing event regmap_reg_write: OK
[   17.125829] Testing event fence_wait_end: OK
[   17.132482] Testing event fence_wait_start: OK
[   17.139182] Testing event fence_signaled: OK
[   17.145811] Testing event fence_enable_signal: OK
[   17.152491] Testing event fence_destroy: OK
[   17.159186] Testing event fence_init: OK
[   17.165809] Testing event fence_emit: OK
[   17.172483] Testing event fence_annotate_wait_on: OK
[   17.179166] Testing event scsi_eh_wakeup: OK
[   17.185810] Testing event scsi_dispatch_cmd_timeout: OK
[   17.192503] Testing event scsi_dispatch_cmd_done: OK
[   17.199177] Testing event scsi_dispatch_cmd_error: OK
[   17.205815] Testing event scsi_dispatch_cmd_start: OK
[   17.212484] Testing event target_cmd_complete: OK
[   17.219165] Testing event target_sequencer_start: OK
[   17.225831] Testing event docg3_io: OK
[   17.235826] Testing event spi_transfer_stop: OK
[   17.242514] Testing event spi_transfer_start: OK
[   17.249157] Testing event spi_message_done: OK
[   17.255814] Testing event spi_message_start: OK
[   17.262565] Testing event spi_message_submit: OK
[   17.269156] Testing event spi_master_busy: OK
[   17.275814] Testing event spi_master_idle: OK
[   17.282505] Testing event dwc3_complete_trb: OK
[   17.289160] Testing event dwc3_prepare_trb: OK
[   17.295871] Testing event dwc3_gadget_ep_cmd: OK
[   17.302528] Testing event dwc3_gadget_generic_cmd: OK
[   17.309210] Testing event dwc3_gadget_giveback: OK
[   17.315820] Testing event dwc3_ep_dequeue: OK
[   17.322515] Testing event dwc3_ep_queue: OK
[   17.329177] Testing event dwc3_free_request: OK
[   17.338609] Testing event dwc3_alloc_request: OK
[   17.345837] Testing event dwc3_ctrl_req: OK
[   17.355841] Testing event dwc3_event: OK
[   17.362517] Testing event dwc3_ep0: OK
[   17.369158] Testing event dwc3_writel: OK
[   17.375851] Testing event dwc3_readl: OK
[   17.382507] Testing event xhci_cmd_completion: OK
[   17.389145] Testing event xhci_address_ctx: OK
[   17.395868] Testing event xhci_dbg_ring_expansion: OK
[   17.402487] Testing event xhci_dbg_init: OK
[   17.412600] Testing event xhci_dbg_cancel_urb: OK
[   17.419194] Testing event xhci_dbg_reset_ep: OK
[   17.425824] Testing event xhci_dbg_quirks: OK
[   17.432520] Testing event xhci_dbg_context_change: OK
[   17.439177] Testing event xhci_dbg_address: OK
[   17.445817] Testing event smbus_result: OK
[   17.452506] Testing event smbus_reply: OK
[   17.459173] Testing event smbus_read: OK
[   17.465845] Testing event smbus_write: OK
[   17.472488] Testing event i2c_result: OK
[   17.479166] Testing event i2c_reply: OK
[   17.485879] Testing event i2c_read: OK
[   17.492486] Testing event i2c_write: OK
[   17.499188] Testing event v4l2_qbuf: OK
[   17.505811] Testing event v4l2_dqbuf: OK
[   17.512483] Testing event thermal_zone_trip: OK
[   17.519187] Testing event cdev_update: OK
[   17.525817] Testing event thermal_temperature: OK
[   17.532506] Testing event bcache_writeback_collision: OK
[   17.539165] Testing event bcache_writeback: OK
[   17.545811] Testing event bcache_alloc_fail: OK
[   17.552512] Testing event bcache_alloc: OK
[   17.559167] Testing event bcache_invalidate: OK
[   17.565833] Testing event bcache_keyscan: OK
[   17.572498] Testing event bcache_btree_set_root: OK
[   17.579172] Testing event bcache_btree_node_compact: OK
[   17.585836] Testing event bcache_btree_node_split: OK
[   17.592497] Testing event bcache_btree_insert_key: OK
[   17.599188] Testing event bcache_gc_copy_collision: OK
[   17.605815] Testing event bcache_gc_copy: OK
[   17.612488] Testing event bcache_gc_end: OK
[   17.619189] Testing event bcache_gc_start: OK
[   17.625824] Testing event bcache_btree_gc_coalesce: OK
[   17.632511] Testing event bcache_btree_node_free: OK
[   17.639167] Testing event bcache_btree_node_alloc_fail: OK
[   17.645812] Testing event bcache_btree_node_alloc: OK
[   17.653133] Testing event bcache_btree_write: OK
[   17.659166] Testing event bcache_btree_read: OK
[   17.665834] Testing event bcache_btree_cache_cannibalize: OK
[   17.672487] Testing event bcache_journal_write: OK
[   17.679211] Testing event bcache_journal_entry_full: OK
[   17.685878] Testing event bcache_journal_full: OK
[   17.692495] Testing event bcache_journal_replay_key: OK
[   17.699188] Testing event bcache_cache_insert: OK
[   17.705814] Testing event bcache_read_retry: OK
[   17.712485] Testing event bcache_write: OK
[   17.719203] Testing event bcache_read: OK
[   17.725815] Testing event bcache_bypass_congested: OK
[   17.732509] Testing event bcache_bypass_sequential: OK
[   17.739168] Testing event bcache_request_end: OK
[   17.745817] Testing event bcache_request_start: OK
[   17.752507] Testing event udp_fail_queue_rcv_skb: OK
[   17.759169] Testing event sock_exceed_buf_limit: OK
[   17.765846] Testing event sock_rcvqueue_full: OK
[   17.772490] Testing event napi_poll: OK
[   17.779167] Testing event netif_rx_ni_entry: OK
[   17.785837] Testing event netif_rx_entry: OK
[   17.792486] Testing event netif_receive_skb_entry: OK
[   17.799189] Testing event napi_gro_receive_entry: OK
[   17.805816] Testing event napi_gro_frags_entry: OK
[   17.812489] Testing event netif_rx: OK
[   17.819191] Testing event netif_receive_skb: OK
[   17.825814] Testing event net_dev_queue: OK
[   17.832506] Testing event net_dev_xmit: OK
[   17.839195] Testing event net_dev_start_xmit: OK
[   17.845824] Testing event skb_copy_datagram_iovec: OK
[   17.852509] Testing event consume_skb: OK
[   17.859170] Testing event kfree_skb: OK
[   17.865838] Running tests on trace event systems:
[   17.866444] Testing event system skb: OK
[   17.872620] Testing event system net: OK
[   17.879316] Testing event system napi: OK
[   17.885954] Testing event system sock: OK
[   17.892623] Testing event system udp: OK
[   17.899311] Testing event system bcache: OK
[   17.906040] Testing event system thermal: OK
[   17.912627] Testing event system v4l2: OK
[   17.919339] Testing event system i2c: OK
[   17.925971] Testing event system xhci-hcd: OK
[   17.932656] Testing event system dwc3: OK
[   17.939349] Testing event system spi: OK
[   17.945963] Testing event system docg3: OK
[   17.952641] Testing event system target: OK
[   17.959295] Testing event system scsi: OK
[   17.965979] Testing event system fence: OK
[   17.972632] Testing event system regmap: OK
[   17.979334] Testing event system drm: OK
[   17.987034] Testing event system random: OK
[   17.992653] Testing event system regulator: OK
[   17.999328] Testing event system gpio: OK
[   18.005941] Testing event system swiotlb: OK
[   18.012610] Testing event system block: OK
[   18.019368] Testing event system btrfs: OK
[   18.028855] Testing event system jbd2: OK
[   18.036005] Testing event system jbd: OK
[   18.042636] Testing event system ext4: OK
[   18.049586] Testing event system ext3: OK
[   18.056052] Testing event system filelock: OK
[   18.062660] Testing event system writeback: OK
[   18.072742] Testing event system migrate: OK
[   18.079279] Testing event system compaction: OK
[   18.085949] Testing event system kmem: OK
[   18.092662] Testing event system vmscan: OK
[   18.099328] Testing event system pagemap: OK
[   18.105959] Testing event system oom: OK
[   18.112629] Testing event system filemap: OK
[   18.119272] Testing event system rpm: OK
[   18.125947] Testing event system power: OK
[   18.132691] Testing event system test: OK
[   18.139288] Testing event system timer: OK
[   18.145974] Testing event system rcu: OK
[   18.152635] Testing event system printk: OK
[   18.159272] Testing event system lock: OK
[   18.165997] Testing event system sched: OK
[   18.172725] Testing event system workqueue: OK
[   18.179281] Testing event system signal: OK
[   18.185940] Testing event system irq: OK
[   18.192646] Testing event system task: OK
[   18.199272] Testing event system exceptions: OK
[   18.205963] Testing event system tlb: OK
[   18.212627] Testing event system mce: OK
[   18.219270] Testing event system raw_syscalls: OK
[   18.225948] Testing event system nmi: OK
[   18.232629] Testing event system irq_vectors: OK
[   18.239377] Testing event system xen: OK
[   18.246036] Running tests on all trace events:
[   18.246602] Testing all events: OK
[   18.375944] Testing ftrace filter: OK
[   18.396062] Btrfs loaded, debug=3Don, assert=3Don, integrity-checker=3Don
[   18.396810] BTRFS: selftest: Running btrfs free space cache tests
[   18.397470] BTRFS: selftest: Running extent only tests
[   18.398033] BTRFS: selftest: Running bitmap only tests
[   18.398605] BTRFS: selftest: Running bitmap and extent tests
[   18.399243] BTRFS: selftest: Running space stealing from bitmap to extent
[   18.400270] BTRFS: selftest: Free space cache tests finished
[   18.400880] BTRFS: selftest: Running extent buffer operation tests
[   18.401522] BTRFS: selftest: Running btrfs_split_item tests
[   18.402176] BTRFS: selftest: Running find delalloc tests
[   18.817940] BTRFS: selftest: Running btrfs_get_extent tests
[   18.818711] BTRFS: selftest: Running hole first btrfs_get_extent test
[   18.819461] BTRFS: selftest: Running qgroup tests
[   18.819970] BTRFS: selftest: Qgroup basic add
[   18.820484] BTRFS: selftest: Qgroup multiple refs test
[   18.821221] raid6test: testing the 4-disk case...
[   18.821800] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[   18.822566] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(P) =
 OK
[   18.823299] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(Q) =
 OK
[   18.824051] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(P) =
 OK
[   18.837926] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(Q) =
 OK
[   18.838671] raid6test: test_disks(2, 3): faila=3D  2(P)  failb=3D  3(Q) =
 OK
[   18.839443] raid6test: testing the 5-disk case...
[   18.840003] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[   18.840762] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[   18.841512] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(P) =
 OK
[   18.842247] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(Q) =
 OK
[   18.843013] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[   18.843771] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(P) =
 OK
[   18.844513] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(Q) =
 OK
[   18.845262] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(P) =
 OK
[   18.846016] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(Q) =
 OK
[   18.846760] raid6test: test_disks(3, 4): faila=3D  3(P)  failb=3D  4(Q) =
 OK
[   18.847591] raid6test: testing the 11-disk case...
[   18.848163] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[   18.848934] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[   18.849716] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[   18.866502] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[   18.867267] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[   18.868044] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[   18.868817] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[   18.869595] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[   18.870348] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(P) =
 OK
[   18.871101] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(Q)=
  OK
[   18.871876] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[   18.872651] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[   18.873415] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[   18.874172] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[   18.874942] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[   18.875719] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[   18.876490] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[   18.877242] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(P) =
 OK
[   18.877993] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(Q)=
  OK
[   18.878771] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[   18.899559] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[   18.900326] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[   18.901098] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[   18.901869] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[   18.902653] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[   18.903416] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(P) =
 OK
[   18.904162] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(Q)=
  OK
[   18.904940] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[   18.905722] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[   18.906486] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[   18.907244] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[   18.908012] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[   18.908778] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(P) =
 OK
[   18.909539] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(Q)=
  OK
[   18.910313] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[   18.911085] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[   18.911853] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[   18.925638] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[   18.926407] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(P) =
 OK
[   18.927151] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(Q)=
  OK
[   18.927927] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[   18.928691] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[   18.929470] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[   18.930222] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(P) =
 OK
[   18.930972] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(Q)=
  OK
[   18.931748] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[   18.932525] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[   18.933281] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(P) =
 OK
[   18.934026] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(Q)=
  OK
[   18.934800] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[   18.935558] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(P) =
 OK
[   18.936304] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(Q)=
  OK
[   18.937071] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(P) =
 OK
[   18.937818] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(Q)=
  OK
[   18.951586] raid6test: test_disks(9, 10): faila=3D  9(P)  failb=3D 10(Q)=
  OK
[   18.952451] raid6test: testing the 12-disk case...
[   18.953026] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[   18.953794] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[   18.954570] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[   18.955326] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[   18.956111] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[   18.956886] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[   18.957654] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[   18.958420] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[   18.959198] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(D) =
 OK
[   18.959963] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(P)=
  OK
[   18.960725] raid6test: test_disks(0, 11): faila=3D  0(D)  failb=3D 11(Q)=
  OK
[   18.961502] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[   18.962263] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[   18.963040] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[   18.963810] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[   18.977588] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[   18.978354] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[   18.979143] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[   18.979920] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(D) =
 OK
[   18.980688] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(P)=
  OK
[   18.981449] raid6test: test_disks(1, 11): faila=3D  1(D)  failb=3D 11(Q)=
  OK
[   18.982223] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[   18.983005] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[   18.983777] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[   18.984547] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[   18.985309] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[   18.986089] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[   18.986862] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(D) =
 OK
[   18.987652] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(P)=
  OK
[   18.988416] raid6test: test_disks(2, 11): faila=3D  2(D)  failb=3D 11(Q)=
  OK
[   18.989208] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[   18.989983] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[   18.990753] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[   18.991522] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[   18.992282] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[   18.993061] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(D) =
 OK
[   18.993820] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(P)=
  OK
[   18.994580] raid6test: test_disks(3, 11): faila=3D  3(D)  failb=3D 11(Q)=
  OK
[   18.995349] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[   18.996127] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[   18.996900] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[   18.997671] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[   18.998441] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(D) =
 OK
[   18.999213] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(P)=
  OK
[   18.999982] raid6test: test_disks(4, 11): faila=3D  4(D)  failb=3D 11(Q)=
  OK
[   19.013770] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[   19.014538] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[   19.015301] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[   19.016078] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(D) =
 OK
[   19.016842] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(P)=
  OK
[   19.017606] raid6test: test_disks(5, 11): faila=3D  5(D)  failb=3D 11(Q)=
  OK
[   19.018382] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[   19.019168] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[   19.019948] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(D) =
 OK
[   19.020711] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(P)=
  OK
[   19.021474] raid6test: test_disks(6, 11): faila=3D  6(D)  failb=3D 11(Q)=
  OK
[   19.022246] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[   19.023028] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(D) =
 OK
[   19.023796] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(P)=
  OK
[   19.024558] raid6test: test_disks(7, 11): faila=3D  7(D)  failb=3D 11(Q)=
  OK
[   19.025330] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(D) =
 OK
[   19.026104] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(P)=
  OK
[   19.038914] raid6test: test_disks(8, 11): faila=3D  8(D)  failb=3D 11(Q)=
  OK
[   19.039697] raid6test: test_disks(9, 10): faila=3D  9(D)  failb=3D 10(P)=
  OK
[   19.040459] raid6test: test_disks(9, 11): faila=3D  9(D)  failb=3D 11(Q)=
  OK
[   19.041207] raid6test: test_disks(10, 11): faila=3D 10(P)  failb=3D 11(Q=
)  OK
[   19.042213] raid6test: testing the 24-disk case...
[   19.042824] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[   19.043616] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[   19.044406] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[   19.045188] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[   19.045991] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[   19.046786] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[   19.047572] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[   19.048356] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[   19.049161] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(D) =
 OK
[   19.049953] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(D)=
  OK
[   19.050840] raid6test: test_disks(0, 11): faila=3D  0(D)  failb=3D 11(D)=
  OK
[   19.064803] raid6test: test_disks(0, 12): faila=3D  0(D)  failb=3D 12(D)=
  OK
[   19.065731] raid6test: test_disks(0, 13): faila=3D  0(D)  failb=3D 13(D)=
  OK
[   19.066582] raid6test: test_disks(0, 14): faila=3D  0(D)  failb=3D 14(D)=
  OK
[   19.067431] raid6test: test_disks(0, 15): faila=3D  0(D)  failb=3D 15(D)=
  OK
[   19.068274] raid6test: test_disks(0, 16): faila=3D  0(D)  failb=3D 16(D)=
  OK
[   19.069137] raid6test: test_disks(0, 17): faila=3D  0(D)  failb=3D 17(D)=
  OK
[   19.069949] raid6test: test_disks(0, 18): faila=3D  0(D)  failb=3D 18(D)=
  OK
[   19.070752] raid6test: test_disks(0, 19): faila=3D  0(D)  failb=3D 19(D)=
  OK
[   19.071555] raid6test: test_disks(0, 20): faila=3D  0(D)  failb=3D 20(D)=
  OK
[   19.072365] raid6test: test_disks(0, 21): faila=3D  0(D)  failb=3D 21(D)=
  OK
[   19.073161] raid6test: test_disks(0, 22): faila=3D  0(D)  failb=3D 22(P)=
  OK
[   19.089022] raid6test: test_disks(0, 23): faila=3D  0(D)  failb=3D 23(Q)=
  OK
[   19.089827] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[   19.090618] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[   19.091408] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[   19.092191] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[   19.092985] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[   19.093777] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[   19.094565] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[   19.095348] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(D) =
 OK
[   19.111194] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(D)=
  OK
[   19.111995] raid6test: test_disks(1, 11): faila=3D  1(D)  failb=3D 11(D)=
  OK
[   19.112817] raid6test: test_disks(1, 12): faila=3D  1(D)  failb=3D 12(D)=
  OK
[   19.113620] raid6test: test_disks(1, 13): faila=3D  1(D)  failb=3D 13(D)=
  OK
[   19.114417] raid6test: test_disks(1, 14): faila=3D  1(D)  failb=3D 14(D)=
  OK
[   19.115208] raid6test: test_disks(1, 15): faila=3D  1(D)  failb=3D 15(D)=
  OK
[   19.116013] raid6test: test_disks(1, 16): faila=3D  1(D)  failb=3D 16(D)=
  OK
[   19.116813] raid6test: test_disks(1, 17): faila=3D  1(D)  failb=3D 17(D)=
  OK
[   19.117608] raid6test: test_disks(1, 18): faila=3D  1(D)  failb=3D 18(D)=
  OK
[   19.118415] raid6test: test_disks(1, 19): faila=3D  1(D)  failb=3D 19(D)=
  OK
[   19.119217] raid6test: test_disks(1, 20): faila=3D  1(D)  failb=3D 20(D)=
  OK
[   19.129172] raid6test: test_disks(1, 21): faila=3D  1(D)  failb=3D 21(D)=
  OK
[   19.129969] raid6test: test_disks(1, 22): faila=3D  1(D)  failb=3D 22(P)=
  OK
[   19.130755] raid6test: test_disks(1, 23): faila=3D  1(D)  failb=3D 23(Q)=
  OK
[   19.131557] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[   19.132349] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[   19.133146] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[   19.133932] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[   19.134724] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[   19.135509] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[   19.136296] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(D) =
 OK
[   19.137087] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(D)=
  OK
[   19.137883] raid6test: test_disks(2, 11): faila=3D  2(D)  failb=3D 11(D)=
  OK
[   19.138685] raid6test: test_disks(2, 12): faila=3D  2(D)  failb=3D 12(D)=
  OK
[   19.139493] raid6test: test_disks(2, 13): faila=3D  2(D)  failb=3D 13(D)=
  OK
[   19.140286] raid6test: test_disks(2, 14): faila=3D  2(D)  failb=3D 14(D)=
  OK
[   19.154093] raid6test: test_disks(2, 15): faila=3D  2(D)  failb=3D 15(D)=
  OK
[   19.154897] raid6test: test_disks(2, 16): faila=3D  2(D)  failb=3D 16(D)=
  OK
[   19.155703] raid6test: test_disks(2, 17): faila=3D  2(D)  failb=3D 17(D)=
  OK
[   19.156583] raid6test: test_disks(2, 18): faila=3D  2(D)  failb=3D 18(D)=
  OK
[   19.162705] raid6test: test_disks(2, 19): faila=3D  2(D)  failb=3D 19(D)=
  OK
[   19.163524] raid6test: test_disks(2, 20): faila=3D  2(D)  failb=3D 20(D)=
  OK
[   19.164328] raid6test: test_disks(2, 21): faila=3D  2(D)  failb=3D 21(D)=
  OK
[   19.165116] raid6test: test_disks(2, 22): faila=3D  2(D)  failb=3D 22(P)=
  OK
[   19.165907] raid6test: test_disks(2, 23): faila=3D  2(D)  failb=3D 23(Q)=
  OK
[   19.166706] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[   19.167494] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[   19.168278] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[   19.169074] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[   19.169867] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[   19.170681] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(D) =
 OK
[   19.188898] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(D)=
  OK
[   19.189713] raid6test: test_disks(3, 11): faila=3D  3(D)  failb=3D 11(D)=
  OK
[   19.190514] raid6test: test_disks(3, 12): faila=3D  3(D)  failb=3D 12(D)=
  OK
[   19.191308] raid6test: test_disks(3, 13): faila=3D  3(D)  failb=3D 13(D)=
  OK
[   19.192278] raid6test: test_disks(3, 14): faila=3D  3(D)  failb=3D 14(D)=
  OK
[   19.193167] raid6test: test_disks(3, 15): faila=3D  3(D)  failb=3D 15(D)=
  OK
[   19.193967] raid6test: test_disks(3, 16): faila=3D  3(D)  failb=3D 16(D)=
  OK
[   19.194766] raid6test: test_disks(3, 17): faila=3D  3(D)  failb=3D 17(D)=
  OK
[   19.195558] raid6test: test_disks(3, 18): faila=3D  3(D)  failb=3D 18(D)=
  OK
[   19.196365] raid6test: test_disks(3, 19): faila=3D  3(D)  failb=3D 19(D)=
  OK
[   19.197169] raid6test: test_disks(3, 20): faila=3D  3(D)  failb=3D 20(D)=
  OK
[   19.197968] raid6test: test_disks(3, 21): faila=3D  3(D)  failb=3D 21(D)=
  OK
[   19.198757] raid6test: test_disks(3, 22): faila=3D  3(D)  failb=3D 22(P)=
  OK
[   19.219518] raid6test: test_disks(3, 23): faila=3D  3(D)  failb=3D 23(Q)=
  OK
[   19.220314] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[   19.221109] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[   19.221904] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[   19.222710] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[   19.225473] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(D) =
 OK
[   19.226271] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(D)=
  OK
[   19.227075] raid6test: test_disks(4, 11): faila=3D  4(D)  failb=3D 11(D)=
  OK
[   19.227869] raid6test: test_disks(4, 12): faila=3D  4(D)  failb=3D 12(D)=
  OK
[   19.228672] raid6test: test_disks(4, 13): faila=3D  4(D)  failb=3D 13(D)=
  OK
[   19.229477] raid6test: test_disks(4, 14): faila=3D  4(D)  failb=3D 14(D)=
  OK
[   19.230265] raid6test: test_disks(4, 15): faila=3D  4(D)  failb=3D 15(D)=
  OK
[   19.231059] raid6test: test_disks(4, 16): faila=3D  4(D)  failb=3D 16(D)=
  OK
[   19.231855] raid6test: test_disks(4, 17): faila=3D  4(D)  failb=3D 17(D)=
  OK
[   19.232659] raid6test: test_disks(4, 18): faila=3D  4(D)  failb=3D 18(D)=
  OK
[   19.233457] raid6test: test_disks(4, 19): faila=3D  4(D)  failb=3D 19(D)=
  OK
[   19.234247] raid6test: test_disks(4, 20): faila=3D  4(D)  failb=3D 20(D)=
  OK
[   19.235046] raid6test: test_disks(4, 21): faila=3D  4(D)  failb=3D 21(D)=
  OK
[   19.235852] raid6test: test_disks(4, 22): faila=3D  4(D)  failb=3D 22(P)=
  OK
[   19.236639] raid6test: test_disks(4, 23): faila=3D  4(D)  failb=3D 23(Q)=
  OK
[   19.250450] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[   19.251234] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[   19.252025] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[   19.252824] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(D) =
 OK
[   19.253616] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(D)=
  OK
[   19.254413] raid6test: test_disks(5, 11): faila=3D  5(D)  failb=3D 11(D)=
  OK
[   19.255206] raid6test: test_disks(5, 12): faila=3D  5(D)  failb=3D 12(D)=
  OK
[   19.256017] raid6test: test_disks(5, 13): faila=3D  5(D)  failb=3D 13(D)=
  OK
[   19.256818] raid6test: test_disks(5, 14): faila=3D  5(D)  failb=3D 14(D)=
  OK
[   19.257618] raid6test: test_disks(5, 15): faila=3D  5(D)  failb=3D 15(D)=
  OK
[   19.258418] raid6test: test_disks(5, 16): faila=3D  5(D)  failb=3D 16(D)=
  OK
[   19.259219] raid6test: test_disks(5, 17): faila=3D  5(D)  failb=3D 17(D)=
  OK
[   19.260020] raid6test: test_disks(5, 18): faila=3D  5(D)  failb=3D 18(D)=
  OK
[   19.260817] raid6test: test_disks(5, 19): faila=3D  5(D)  failb=3D 19(D)=
  OK
[   19.261619] raid6test: test_disks(5, 20): faila=3D  5(D)  failb=3D 20(D)=
  OK
[   19.262431] raid6test: test_disks(5, 21): faila=3D  5(D)  failb=3D 21(D)=
  OK
[   19.263212] raid6test: test_disks(5, 22): faila=3D  5(D)  failb=3D 22(P)=
  OK
[   19.277018] raid6test: test_disks(5, 23): faila=3D  5(D)  failb=3D 23(Q)=
  OK
[   19.277822] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[   19.278612] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[   19.279403] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(D) =
 OK
[   19.280188] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(D)=
  OK
[   19.280987] raid6test: test_disks(6, 11): faila=3D  6(D)  failb=3D 11(D)=
  OK
[   19.281785] raid6test: test_disks(6, 12): faila=3D  6(D)  failb=3D 12(D)=
  OK
[   19.282587] raid6test: test_disks(6, 13): faila=3D  6(D)  failb=3D 13(D)=
  OK
[   19.283375] raid6test: test_disks(6, 14): faila=3D  6(D)  failb=3D 14(D)=
  OK
[   19.284173] raid6test: test_disks(6, 15): faila=3D  6(D)  failb=3D 15(D)=
  OK
[   19.284970] raid6test: test_disks(6, 16): faila=3D  6(D)  failb=3D 16(D)=
  OK
[   19.285782] raid6test: test_disks(6, 17): faila=3D  6(D)  failb=3D 17(D)=
  OK
[   19.286581] raid6test: test_disks(6, 18): faila=3D  6(D)  failb=3D 18(D)=
  OK
[   19.287369] raid6test: test_disks(6, 19): faila=3D  6(D)  failb=3D 19(D)=
  OK
[   19.288169] raid6test: test_disks(6, 20): faila=3D  6(D)  failb=3D 20(D)=
  OK
[   19.288972] raid6test: test_disks(6, 21): faila=3D  6(D)  failb=3D 21(D)=
  OK
[   19.302776] raid6test: test_disks(6, 22): faila=3D  6(D)  failb=3D 22(P)=
  OK
[   19.303558] raid6test: test_disks(6, 23): faila=3D  6(D)  failb=3D 23(Q)=
  OK
[   19.304347] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[   19.305136] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(D) =
 OK
[   19.305938] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(D)=
  OK
[   19.306738] raid6test: test_disks(7, 11): faila=3D  7(D)  failb=3D 11(D)=
  OK
[   19.307533] raid6test: test_disks(7, 12): faila=3D  7(D)  failb=3D 12(D)=
  OK
[   19.308324] raid6test: test_disks(7, 13): faila=3D  7(D)  failb=3D 13(D)=
  OK
[   19.309135] raid6test: test_disks(7, 14): faila=3D  7(D)  failb=3D 14(D)=
  OK
[   19.309940] raid6test: test_disks(7, 15): faila=3D  7(D)  failb=3D 15(D)=
  OK
[   19.310739] raid6test: test_disks(7, 16): faila=3D  7(D)  failb=3D 16(D)=
  OK
[   19.311539] raid6test: test_disks(7, 17): faila=3D  7(D)  failb=3D 17(D)=
  OK
[   19.312338] raid6test: test_disks(7, 18): faila=3D  7(D)  failb=3D 18(D)=
  OK
[   19.313139] raid6test: test_disks(7, 19): faila=3D  7(D)  failb=3D 19(D)=
  OK
[   19.313937] raid6test: test_disks(7, 20): faila=3D  7(D)  failb=3D 20(D)=
  OK
[   19.314735] raid6test: test_disks(7, 21): faila=3D  7(D)  failb=3D 21(D)=
  OK
[   19.328534] raid6test: test_disks(7, 22): faila=3D  7(D)  failb=3D 22(P)=
  OK
[   19.329324] raid6test: test_disks(7, 23): faila=3D  7(D)  failb=3D 23(Q)=
  OK
[   19.330125] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(D) =
 OK
[   19.330913] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(D)=
  OK
[   19.331710] raid6test: test_disks(8, 11): faila=3D  8(D)  failb=3D 11(D)=
  OK
[   19.332517] raid6test: test_disks(8, 12): faila=3D  8(D)  failb=3D 12(D)=
  OK
[   19.333306] raid6test: test_disks(8, 13): faila=3D  8(D)  failb=3D 13(D)=
  OK
[   19.334105] raid6test: test_disks(8, 14): faila=3D  8(D)  failb=3D 14(D)=
  OK
[   19.334901] raid6test: test_disks(8, 15): faila=3D  8(D)  failb=3D 15(D)=
  OK
[   19.335709] raid6test: test_disks(8, 16): faila=3D  8(D)  failb=3D 16(D)=
  OK
[   19.336511] raid6test: test_disks(8, 17): faila=3D  8(D)  failb=3D 17(D)=
  OK
[   19.337300] raid6test: test_disks(8, 18): faila=3D  8(D)  failb=3D 18(D)=
  OK
[   19.338095] raid6test: test_disks(8, 19): faila=3D  8(D)  failb=3D 19(D)=
  OK
[   19.338894] raid6test: test_disks(8, 20): faila=3D  8(D)  failb=3D 20(D)=
  OK
[   19.339707] raid6test: test_disks(8, 21): faila=3D  8(D)  failb=3D 21(D)=
  OK
[   19.340500] raid6test: test_disks(8, 22): faila=3D  8(D)  failb=3D 22(P)=
  OK
[   19.341272] raid6test: test_disks(8, 23): faila=3D  8(D)  failb=3D 23(Q)=
  OK
[   19.355082] raid6test: test_disks(9, 10): faila=3D  9(D)  failb=3D 10(D)=
  OK
[   19.355889] raid6test: test_disks(9, 11): faila=3D  9(D)  failb=3D 11(D)=
  OK
[   19.356685] raid6test: test_disks(9, 12): faila=3D  9(D)  failb=3D 12(D)=
  OK
[   19.357485] raid6test: test_disks(9, 13): faila=3D  9(D)  failb=3D 13(D)=
  OK
[   19.358279] raid6test: test_disks(9, 14): faila=3D  9(D)  failb=3D 14(D)=
  OK
[   19.359092] raid6test: test_disks(9, 15): faila=3D  9(D)  failb=3D 15(D)=
  OK
[   19.359901] raid6test: test_disks(9, 16): faila=3D  9(D)  failb=3D 16(D)=
  OK
[   19.360697] raid6test: test_disks(9, 17): faila=3D  9(D)  failb=3D 17(D)=
  OK
[   19.361493] raid6test: test_disks(9, 18): faila=3D  9(D)  failb=3D 18(D)=
  OK
[   19.362282] raid6test: test_disks(9, 19): faila=3D  9(D)  failb=3D 19(D)=
  OK
[   19.363087] raid6test: test_disks(9, 20): faila=3D  9(D)  failb=3D 20(D)=
  OK
[   19.363891] raid6test: test_disks(9, 21): faila=3D  9(D)  failb=3D 21(D)=
  OK
[   19.364683] raid6test: test_disks(9, 22): faila=3D  9(D)  failb=3D 22(P)=
  OK
[   19.365463] raid6test: test_disks(9, 23): faila=3D  9(D)  failb=3D 23(Q)=
  OK
[   19.366260] raid6test: test_disks(10, 11): faila=3D 10(D)  failb=3D 11(D=
)  OK
[   19.367070] raid6test: test_disks(10, 12): faila=3D 10(D)  failb=3D 12(D=
)  OK
[   19.386895] raid6test: test_disks(10, 13): faila=3D 10(D)  failb=3D 13(D=
)  OK
[   19.387706] raid6test: test_disks(10, 14): faila=3D 10(D)  failb=3D 14(D=
)  OK
[   19.388513] raid6test: test_disks(10, 15): faila=3D 10(D)  failb=3D 15(D=
)  OK
[   19.389327] raid6test: test_disks(10, 16): faila=3D 10(D)  failb=3D 16(D=
)  OK
[   19.390136] raid6test: test_disks(10, 17): faila=3D 10(D)  failb=3D 17(D=
)  OK
[   19.390952] raid6test: test_disks(10, 18): faila=3D 10(D)  failb=3D 18(D=
)  OK
[   19.391760] raid6test: test_disks(10, 19): faila=3D 10(D)  failb=3D 19(D=
)  OK
[   19.392581] raid6test: test_disks(10, 20): faila=3D 10(D)  failb=3D 20(D=
)  OK
[   19.393385] raid6test: test_disks(10, 21): faila=3D 10(D)  failb=3D 21(D=
)  OK
[   19.394184] raid6test: test_disks(10, 22): faila=3D 10(D)  failb=3D 22(P=
)  OK
[   19.406956] raid6test: test_disks(10, 23): faila=3D 10(D)  failb=3D 23(Q=
)  OK
[   19.407770] raid6test: test_disks(11, 12): faila=3D 11(D)  failb=3D 12(D=
)  OK
[   19.408581] raid6test: test_disks(11, 13): faila=3D 11(D)  failb=3D 13(D=
)  OK
[   19.409387] raid6test: test_disks(11, 14): faila=3D 11(D)  failb=3D 14(D=
)  OK
[   19.410193] raid6test: test_disks(11, 15): faila=3D 11(D)  failb=3D 15(D=
)  OK
[   19.411002] raid6test: test_disks(11, 16): faila=3D 11(D)  failb=3D 16(D=
)  OK
[   19.411811] raid6test: test_disks(11, 17): faila=3D 11(D)  failb=3D 17(D=
)  OK
[   19.412626] raid6test: test_disks(11, 18): faila=3D 11(D)  failb=3D 18(D=
)  OK
[   19.413432] raid6test: test_disks(11, 19): faila=3D 11(D)  failb=3D 19(D=
)  OK
[   19.414229] raid6test: test_disks(11, 20): faila=3D 11(D)  failb=3D 20(D=
)  OK
[   19.415036] raid6test: test_disks(11, 21): faila=3D 11(D)  failb=3D 21(D=
)  OK
[   19.415846] raid6test: test_disks(11, 22): faila=3D 11(D)  failb=3D 22(P=
)  OK
[   19.416639] raid6test: test_disks(11, 23): faila=3D 11(D)  failb=3D 23(Q=
)  OK
[   19.417445] raid6test: test_disks(12, 13): faila=3D 12(D)  failb=3D 13(D=
)  OK
[   19.418245] raid6test: test_disks(12, 14): faila=3D 12(D)  failb=3D 14(D=
)  OK
[   19.419069] raid6test: test_disks(12, 15): faila=3D 12(D)  failb=3D 15(D=
)  OK
[   19.432889] raid6test: test_disks(12, 16): faila=3D 12(D)  failb=3D 16(D=
)  OK
[   19.433696] raid6test: test_disks(12, 17): faila=3D 12(D)  failb=3D 17(D=
)  OK
[   19.434503] raid6test: test_disks(12, 18): faila=3D 12(D)  failb=3D 18(D=
)  OK
[   19.435306] raid6test: test_disks(12, 19): faila=3D 12(D)  failb=3D 19(D=
)  OK
[   19.436128] raid6test: test_disks(12, 20): faila=3D 12(D)  failb=3D 20(D=
)  OK
[   19.436940] raid6test: test_disks(12, 21): faila=3D 12(D)  failb=3D 21(D=
)  OK
[   19.437733] raid6test: test_disks(12, 22): faila=3D 12(D)  failb=3D 22(P=
)  OK
[   19.438527] raid6test: test_disks(12, 23): faila=3D 12(D)  failb=3D 23(Q=
)  OK
[   19.439335] raid6test: test_disks(13, 14): faila=3D 13(D)  failb=3D 14(D=
)  OK
[   19.440143] raid6test: test_disks(13, 15): faila=3D 13(D)  failb=3D 15(D=
)  OK
[   19.440954] raid6test: test_disks(13, 16): faila=3D 13(D)  failb=3D 16(D=
)  OK
[   19.441764] raid6test: test_disks(13, 17): faila=3D 13(D)  failb=3D 17(D=
)  OK
[   19.442581] raid6test: test_disks(13, 18): faila=3D 13(D)  failb=3D 18(D=
)  OK
[   19.443382] raid6test: test_disks(13, 19): faila=3D 13(D)  failb=3D 19(D=
)  OK
[   19.444188] raid6test: test_disks(13, 20): faila=3D 13(D)  failb=3D 20(D=
)  OK
[   19.444995] raid6test: test_disks(13, 21): faila=3D 13(D)  failb=3D 21(D=
)  OK
[   19.458819] raid6test: test_disks(13, 22): faila=3D 13(D)  failb=3D 22(P=
)  OK
[   19.459626] raid6test: test_disks(13, 23): faila=3D 13(D)  failb=3D 23(Q=
)  OK
[   19.460433] raid6test: test_disks(14, 15): faila=3D 14(D)  failb=3D 15(D=
)  OK
[   19.461232] raid6test: test_disks(14, 16): faila=3D 14(D)  failb=3D 16(D=
)  OK
[   19.462038] raid6test: test_disks(14, 17): faila=3D 14(D)  failb=3D 17(D=
)  OK
[   19.462850] raid6test: test_disks(14, 18): faila=3D 14(D)  failb=3D 18(D=
)  OK
[   19.463656] raid6test: test_disks(14, 19): faila=3D 14(D)  failb=3D 19(D=
)  OK
[   19.464462] raid6test: test_disks(14, 20): faila=3D 14(D)  failb=3D 20(D=
)  OK
[   19.465262] raid6test: test_disks(14, 21): faila=3D 14(D)  failb=3D 21(D=
)  OK
[   19.466069] raid6test: test_disks(14, 22): faila=3D 14(D)  failb=3D 22(P=
)  OK
[   19.466864] raid6test: test_disks(14, 23): faila=3D 14(D)  failb=3D 23(Q=
)  OK
[   19.467671] raid6test: test_disks(15, 16): faila=3D 15(D)  failb=3D 16(D=
)  OK
[   19.468477] raid6test: test_disks(15, 17): faila=3D 15(D)  failb=3D 17(D=
)  OK
[   19.469288] raid6test: test_disks(15, 18): faila=3D 15(D)  failb=3D 18(D=
)  OK
[   19.470095] raid6test: test_disks(15, 19): faila=3D 15(D)  failb=3D 19(D=
)  OK
[   19.470901] raid6test: test_disks(15, 20): faila=3D 15(D)  failb=3D 20(D=
)  OK
[   19.484725] raid6test: test_disks(15, 21): faila=3D 15(D)  failb=3D 21(D=
)  OK
[   19.485525] raid6test: test_disks(15, 22): faila=3D 15(D)  failb=3D 22(P=
)  OK
[   19.486319] raid6test: test_disks(15, 23): faila=3D 15(D)  failb=3D 23(Q=
)  OK
[   19.487132] raid6test: test_disks(16, 17): faila=3D 16(D)  failb=3D 17(D=
)  OK
[   19.487942] raid6test: test_disks(16, 18): faila=3D 16(D)  failb=3D 18(D=
)  OK
[   19.488748] raid6test: test_disks(16, 19): faila=3D 16(D)  failb=3D 19(D=
)  OK
[   19.489560] raid6test: test_disks(16, 20): faila=3D 16(D)  failb=3D 20(D=
)  OK
[   19.490361] raid6test: test_disks(16, 21): faila=3D 16(D)  failb=3D 21(D=
)  OK
[   19.491162] raid6test: test_disks(16, 22): faila=3D 16(D)  failb=3D 22(P=
)  OK
[   19.491961] raid6test: test_disks(16, 23): faila=3D 16(D)  failb=3D 23(Q=
)  OK
[   19.492773] raid6test: test_disks(17, 18): faila=3D 17(D)  failb=3D 18(D=
)  OK
[   19.493576] raid6test: test_disks(17, 19): faila=3D 17(D)  failb=3D 19(D=
)  OK
[   19.494373] raid6test: test_disks(17, 20): faila=3D 17(D)  failb=3D 20(D=
)  OK
[   19.495175] raid6test: test_disks(17, 21): faila=3D 17(D)  failb=3D 21(D=
)  OK
[   19.495990] raid6test: test_disks(17, 22): faila=3D 17(D)  failb=3D 22(P=
)  OK
[   19.496789] raid6test: test_disks(17, 23): faila=3D 17(D)  failb=3D 23(Q=
)  OK
[   19.497593] raid6test: test_disks(18, 19): faila=3D 18(D)  failb=3D 19(D=
)  OK
[   19.498402] raid6test: test_disks(18, 20): faila=3D 18(D)  failb=3D 20(D=
)  OK
[   19.499218] raid6test: test_disks(18, 21): faila=3D 18(D)  failb=3D 21(D=
)  OK
[   19.500021] raid6test: test_disks(18, 22): faila=3D 18(D)  failb=3D 22(P=
)  OK
[   19.500809] raid6test: test_disks(18, 23): faila=3D 18(D)  failb=3D 23(Q=
)  OK
[   19.501617] raid6test: test_disks(19, 20): faila=3D 19(D)  failb=3D 20(D=
)  OK
[   19.502426] raid6test: test_disks(19, 21): faila=3D 19(D)  failb=3D 21(D=
)  OK
[   19.503219] raid6test: test_disks(19, 22): faila=3D 19(D)  failb=3D 22(P=
)  OK
[   19.504010] raid6test: test_disks(19, 23): faila=3D 19(D)  failb=3D 23(Q=
)  OK
[   19.517829] raid6test: test_disks(20, 21): faila=3D 20(D)  failb=3D 21(D=
)  OK
[   19.518633] raid6test: test_disks(20, 22): faila=3D 20(D)  failb=3D 22(P=
)  OK
[   19.519428] raid6test: test_disks(20, 23): faila=3D 20(D)  failb=3D 23(Q=
)  OK
[   19.520224] raid6test: test_disks(21, 22): faila=3D 21(D)  failb=3D 22(P=
)  OK
[   19.521014] raid6test: test_disks(21, 23): faila=3D 21(D)  failb=3D 23(Q=
)  OK
[   19.521801] raid6test: test_disks(22, 23): faila=3D 22(P)  failb=3D 23(Q=
)  OK
[   19.523240] raid6test: testing the 64-disk case...
[   19.523908] raid6test: test_disks(0, 1): faila=3D  0(D)  failb=3D  1(D) =
 OK
[   19.524766] raid6test: test_disks(0, 2): faila=3D  0(D)  failb=3D  2(D) =
 OK
[   19.525621] raid6test: test_disks(0, 3): faila=3D  0(D)  failb=3D  3(D) =
 OK
[   19.526494] raid6test: test_disks(0, 4): faila=3D  0(D)  failb=3D  4(D) =
 OK
[   19.527344] raid6test: test_disks(0, 5): faila=3D  0(D)  failb=3D  5(D) =
 OK
[   19.528211] raid6test: test_disks(0, 6): faila=3D  0(D)  failb=3D  6(D) =
 OK
[   19.529082] raid6test: test_disks(0, 7): faila=3D  0(D)  failb=3D  7(D) =
 OK
[   19.529944] raid6test: test_disks(0, 8): faila=3D  0(D)  failb=3D  8(D) =
 OK
[   19.543809] raid6test: test_disks(0, 9): faila=3D  0(D)  failb=3D  9(D) =
 OK
[   19.544668] raid6test: test_disks(0, 10): faila=3D  0(D)  failb=3D 10(D)=
  OK
[   19.545529] raid6test: test_disks(0, 11): faila=3D  0(D)  failb=3D 11(D)=
  OK
[   19.546407] raid6test: test_disks(0, 12): faila=3D  0(D)  failb=3D 12(D)=
  OK
[   19.547265] raid6test: test_disks(0, 13): faila=3D  0(D)  failb=3D 13(D)=
  OK
[   19.548131] raid6test: test_disks(0, 14): faila=3D  0(D)  failb=3D 14(D)=
  OK
[   19.549014] raid6test: test_disks(0, 15): faila=3D  0(D)  failb=3D 15(D)=
  OK
[   19.549881] raid6test: test_disks(0, 16): faila=3D  0(D)  failb=3D 16(D)=
  OK
[   19.550745] raid6test: test_disks(0, 17): faila=3D  0(D)  failb=3D 17(D)=
  OK
[   19.551610] raid6test: test_disks(0, 18): faila=3D  0(D)  failb=3D 18(D)=
  OK
[   19.552491] raid6test: test_disks(0, 19): faila=3D  0(D)  failb=3D 19(D)=
  OK
[   19.553352] raid6test: test_disks(0, 20): faila=3D  0(D)  failb=3D 20(D)=
  OK
[   19.554219] raid6test: test_disks(0, 21): faila=3D  0(D)  failb=3D 21(D)=
  OK
[   19.555090] raid6test: test_disks(0, 22): faila=3D  0(D)  failb=3D 22(D)=
  OK
[   19.555968] raid6test: test_disks(0, 23): faila=3D  0(D)  failb=3D 23(D)=
  OK
[   19.566109] raid6test: test_disks(0, 24): faila=3D  0(D)  failb=3D 24(D)=
  OK
[   19.566982] raid6test: test_disks(0, 25): faila=3D  0(D)  failb=3D 25(D)=
  OK
[   19.567850] raid6test: test_disks(0, 26): faila=3D  0(D)  failb=3D 26(D)=
  OK
[   19.568716] raid6test: test_disks(0, 27): faila=3D  0(D)  failb=3D 27(D)=
  OK
[   19.569591] raid6test: test_disks(0, 28): faila=3D  0(D)  failb=3D 28(D)=
  OK
[   19.570455] raid6test: test_disks(0, 29): faila=3D  0(D)  failb=3D 29(D)=
  OK
[   19.571316] raid6test: test_disks(0, 30): faila=3D  0(D)  failb=3D 30(D)=
  OK
[   19.572189] raid6test: test_disks(0, 31): faila=3D  0(D)  failb=3D 31(D)=
  OK
[   19.573068] raid6test: test_disks(0, 32): faila=3D  0(D)  failb=3D 32(D)=
  OK
[   19.573936] raid6test: test_disks(0, 33): faila=3D  0(D)  failb=3D 33(D)=
  OK
[   19.574802] raid6test: test_disks(0, 34): faila=3D  0(D)  failb=3D 34(D)=
  OK
[   19.575685] raid6test: test_disks(0, 35): faila=3D  0(D)  failb=3D 35(D)=
  OK
[   19.576558] raid6test: test_disks(0, 36): faila=3D  0(D)  failb=3D 36(D)=
  OK
[   19.577430] raid6test: test_disks(0, 37): faila=3D  0(D)  failb=3D 37(D)=
  OK
[   19.578292] raid6test: test_disks(0, 38): faila=3D  0(D)  failb=3D 38(D)=
  OK
[   19.592187] raid6test: test_disks(0, 39): faila=3D  0(D)  failb=3D 39(D)=
  OK
[   19.593073] raid6test: test_disks(0, 40): faila=3D  0(D)  failb=3D 40(D)=
  OK
[   19.593938] raid6test: test_disks(0, 41): faila=3D  0(D)  failb=3D 41(D)=
  OK
[   19.594806] raid6test: test_disks(0, 42): faila=3D  0(D)  failb=3D 42(D)=
  OK
[   19.595683] raid6test: test_disks(0, 43): faila=3D  0(D)  failb=3D 43(D)=
  OK
[   19.596611] raid6test: test_disks(0, 44): faila=3D  0(D)  failb=3D 44(D)=
  OK
[   19.597568] raid6test: test_disks(0, 45): faila=3D  0(D)  failb=3D 45(D)=
  OK
[   19.598445] raid6test: test_disks(0, 46): faila=3D  0(D)  failb=3D 46(D)=
  OK
[   19.599321] raid6test: test_disks(0, 47): faila=3D  0(D)  failb=3D 47(D)=
  OK
[   19.600192] raid6test: test_disks(0, 48): faila=3D  0(D)  failb=3D 48(D)=
  OK
[   19.601060] raid6test: test_disks(0, 49): faila=3D  0(D)  failb=3D 49(D)=
  OK
[   19.601932] raid6test: test_disks(0, 50): faila=3D  0(D)  failb=3D 50(D)=
  OK
[   19.602815] raid6test: test_disks(0, 51): faila=3D  0(D)  failb=3D 51(D)=
  OK
[   19.603684] raid6test: test_disks(0, 52): faila=3D  0(D)  failb=3D 52(D)=
  OK
[   19.617555] raid6test: test_disks(0, 53): faila=3D  0(D)  failb=3D 53(D)=
  OK
[   19.618425] raid6test: test_disks(0, 54): faila=3D  0(D)  failb=3D 54(D)=
  OK
[   19.619293] raid6test: test_disks(0, 55): faila=3D  0(D)  failb=3D 55(D)=
  OK
[   19.620162] raid6test: test_disks(0, 56): faila=3D  0(D)  failb=3D 56(D)=
  OK
[   19.621027] raid6test: test_disks(0, 57): faila=3D  0(D)  failb=3D 57(D)=
  OK
[   19.621893] raid6test: test_disks(0, 58): faila=3D  0(D)  failb=3D 58(D)=
  OK
[   19.622778] raid6test: test_disks(0, 59): faila=3D  0(D)  failb=3D 59(D)=
  OK
[   19.623831] raid6test: test_disks(0, 60): faila=3D  0(D)  failb=3D 60(D)=
  OK
[   19.624704] raid6test: test_disks(0, 61): faila=3D  0(D)  failb=3D 61(D)=
  OK
[   19.625560] raid6test: test_disks(0, 62): faila=3D  0(D)  failb=3D 62(P)=
  OK
[   19.626436] raid6test: test_disks(0, 63): faila=3D  0(D)  failb=3D 63(Q)=
  OK
[   19.627295] raid6test: test_disks(1, 2): faila=3D  1(D)  failb=3D  2(D) =
 OK
[   19.628159] raid6test: test_disks(1, 3): faila=3D  1(D)  failb=3D  3(D) =
 OK
[   19.629042] raid6test: test_disks(1, 4): faila=3D  1(D)  failb=3D  4(D) =
 OK
[   19.629902] raid6test: test_disks(1, 5): faila=3D  1(D)  failb=3D  5(D) =
 OK
[   19.643771] raid6test: test_disks(1, 6): faila=3D  1(D)  failb=3D  6(D) =
 OK
[   19.644637] raid6test: test_disks(1, 7): faila=3D  1(D)  failb=3D  7(D) =
 OK
[   19.645499] raid6test: test_disks(1, 8): faila=3D  1(D)  failb=3D  8(D) =
 OK
[   19.646355] raid6test: test_disks(1, 9): faila=3D  1(D)  failb=3D  9(D) =
 OK
[   19.647219] raid6test: test_disks(1, 10): faila=3D  1(D)  failb=3D 10(D)=
  OK
[   19.648092] raid6test: test_disks(1, 11): faila=3D  1(D)  failb=3D 11(D)=
  OK
[   19.648960] raid6test: test_disks(1, 12): faila=3D  1(D)  failb=3D 12(D)=
  OK
[   19.649838] raid6test: test_disks(1, 13): faila=3D  1(D)  failb=3D 13(D)=
  OK
[   19.650708] raid6test: test_disks(1, 14): faila=3D  1(D)  failb=3D 14(D)=
  OK
[   19.651579] raid6test: test_disks(1, 15): faila=3D  1(D)  failb=3D 15(D)=
  OK
[   19.652465] raid6test: test_disks(1, 16): faila=3D  1(D)  failb=3D 16(D)=
  OK
[   19.653328] raid6test: test_disks(1, 17): faila=3D  1(D)  failb=3D 17(D)=
  OK
[   19.654193] raid6test: test_disks(1, 18): faila=3D  1(D)  failb=3D 18(D)=
  OK
[   19.655062] raid6test: test_disks(1, 19): faila=3D  1(D)  failb=3D 19(D)=
  OK
[   19.655940] raid6test: test_disks(1, 20): faila=3D  1(D)  failb=3D 20(D)=
  OK
[   19.669813] raid6test: test_disks(1, 21): faila=3D  1(D)  failb=3D 21(D)=
  OK
[   19.670680] raid6test: test_disks(1, 22): faila=3D  1(D)  failb=3D 22(D)=
  OK
[   19.671546] raid6test: test_disks(1, 23): faila=3D  1(D)  failb=3D 23(D)=
  OK
[   19.672428] raid6test: test_disks(1, 24): faila=3D  1(D)  failb=3D 24(D)=
  OK
[   19.673287] raid6test: test_disks(1, 25): faila=3D  1(D)  failb=3D 25(D)=
  OK
[   19.674154] raid6test: test_disks(1, 26): faila=3D  1(D)  failb=3D 26(D)=
  OK
[   19.675021] raid6test: test_disks(1, 27): faila=3D  1(D)  failb=3D 27(D)=
  OK
[   19.675895] raid6test: test_disks(1, 28): faila=3D  1(D)  failb=3D 28(D)=
  OK
[   19.676763] raid6test: test_disks(1, 29): faila=3D  1(D)  failb=3D 29(D)=
  OK
[   19.677630] raid6test: test_disks(1, 30): faila=3D  1(D)  failb=3D 30(D)=
  OK
[   19.678497] raid6test: test_disks(1, 31): faila=3D  1(D)  failb=3D 31(D)=
  OK
[   19.679365] raid6test: test_disks(1, 32): faila=3D  1(D)  failb=3D 32(D)=
  OK
[   19.680235] raid6test: test_disks(1, 33): faila=3D  1(D)  failb=3D 33(D)=
  OK
[   19.681102] raid6test: test_disks(1, 34): faila=3D  1(D)  failb=3D 34(D)=
  OK
[   19.681972] raid6test: test_disks(1, 35): faila=3D  1(D)  failb=3D 35(D)=
  OK
[   19.705865] raid6test: test_disks(1, 36): faila=3D  1(D)  failb=3D 36(D)=
  OK
[   19.706738] raid6test: test_disks(1, 37): faila=3D  1(D)  failb=3D 37(D)=
  OK
[   19.707600] raid6test: test_disks(1, 38): faila=3D  1(D)  failb=3D 38(D)=
  OK
[   19.708472] raid6test: test_disks(1, 39): faila=3D  1(D)  failb=3D 39(D)=
  OK
[   19.709336] raid6test: test_disks(1, 40): faila=3D  1(D)  failb=3D 40(D)=
  OK
[   19.710202] raid6test: test_disks(1, 41): faila=3D  1(D)  failb=3D 41(D)=
  OK
[   19.711072] raid6test: test_disks(1, 42): faila=3D  1(D)  failb=3D 42(D)=
  OK
[   19.711937] raid6test: test_disks(1, 43): faila=3D  1(D)  failb=3D 43(D)=
  OK
[   19.712891] raid6test: test_disks(1, 44): faila=3D  1(D)  failb=3D 44(D)=
  OK
[   19.713795] raid6test: test_disks(1, 45): faila=3D  1(D)  failb=3D 45(D)=
  OK
[   19.714667] raid6test: test_disks(1, 46): faila=3D  1(D)  failb=3D 46(D)=
  OK
[   19.715532] raid6test: test_disks(1, 47): faila=3D  1(D)  failb=3D 47(D)=
  OK
[   19.716410] raid6test: test_disks(1, 48): faila=3D  1(D)  failb=3D 48(D)=
  OK
[   19.717269] raid6test: test_disks(1, 49): faila=3D  1(D)  failb=3D 49(D)=
  OK
[   19.718138] raid6test: test_disks(1, 50): faila=3D  1(D)  failb=3D 50(D)=
  OK
[   19.732027] raid6test: test_disks(1, 51): faila=3D  1(D)  failb=3D 51(D)=
  OK
[   19.732908] raid6test: test_disks(1, 52): faila=3D  1(D)  failb=3D 52(D)=
  OK
[   19.733777] raid6test: test_disks(1, 53): faila=3D  1(D)  failb=3D 53(D)=
  OK
[   19.734649] raid6test: test_disks(1, 54): faila=3D  1(D)  failb=3D 54(D)=
  OK
[   19.735514] raid6test: test_disks(1, 55): faila=3D  1(D)  failb=3D 55(D)=
  OK
[   19.736387] raid6test: test_disks(1, 56): faila=3D  1(D)  failb=3D 56(D)=
  OK
[   19.737250] raid6test: test_disks(1, 57): faila=3D  1(D)  failb=3D 57(D)=
  OK
[   19.738120] raid6test: test_disks(1, 58): faila=3D  1(D)  failb=3D 58(D)=
  OK
[   19.738996] raid6test: test_disks(1, 59): faila=3D  1(D)  failb=3D 59(D)=
  OK
[   19.739862] raid6test: test_disks(1, 60): faila=3D  1(D)  failb=3D 60(D)=
  OK
[   19.740724] raid6test: test_disks(1, 61): faila=3D  1(D)  failb=3D 61(D)=
  OK
[   19.741585] raid6test: test_disks(1, 62): faila=3D  1(D)  failb=3D 62(P)=
  OK
[   19.742450] raid6test: test_disks(1, 63): faila=3D  1(D)  failb=3D 63(Q)=
  OK
[   19.743308] raid6test: test_disks(2, 3): faila=3D  2(D)  failb=3D  3(D) =
 OK
[   19.744165] raid6test: test_disks(2, 4): faila=3D  2(D)  failb=3D  4(D) =
 OK
[   19.758037] raid6test: test_disks(2, 5): faila=3D  2(D)  failb=3D  5(D) =
 OK
[   19.758904] raid6test: test_disks(2, 6): faila=3D  2(D)  failb=3D  6(D) =
 OK
[   19.759772] raid6test: test_disks(2, 7): faila=3D  2(D)  failb=3D  7(D) =
 OK
[   19.760634] raid6test: test_disks(2, 8): faila=3D  2(D)  failb=3D  8(D) =
 OK
[   19.761491] raid6test: test_disks(2, 9): faila=3D  2(D)  failb=3D  9(D) =
 OK
[   19.762351] raid6test: test_disks(2, 10): faila=3D  2(D)  failb=3D 10(D)=
  OK
[   19.763220] raid6test: test_disks(2, 11): faila=3D  2(D)  failb=3D 11(D)=
  OK
[   19.764089] raid6test: test_disks(2, 12): faila=3D  2(D)  failb=3D 12(D)=
  OK
[   19.764961] raid6test: test_disks(2, 13): faila=3D  2(D)  failb=3D 13(D)=
  OK
[   19.765843] raid6test: test_disks(2, 14): faila=3D  2(D)  failb=3D 14(D)=
  OK
[   19.775737] raid6test: test_disks(2, 15): faila=3D  2(D)  failb=3D 15(D)=
  OK
[   19.776603] raid6test: test_disks(2, 16): faila=3D  2(D)  failb=3D 16(D)=
  OK
[   19.777475] raid6test: test_disks(2, 17): faila=3D  2(D)  failb=3D 17(D)=
  OK
[   19.778339] raid6test: test_disks(2, 18): faila=3D  2(D)  failb=3D 18(D)=
  OK
[   19.779225] raid6test: test_disks(2, 19): faila=3D  2(D)  failb=3D 19(D)=
  OK
[   19.780092] raid6test: test_disks(2, 20): faila=3D  2(D)  failb=3D 20(D)=
  OK
[   19.780961] raid6test: test_disks(2, 21): faila=3D  2(D)  failb=3D 21(D)=
  OK
[   19.781831] raid6test: test_disks(2, 22): faila=3D  2(D)  failb=3D 22(D)=
  OK
[   19.782702] raid6test: test_disks(2, 23): faila=3D  2(D)  failb=3D 23(D)=
  OK
[   19.783570] raid6test: test_disks(2, 24): faila=3D  2(D)  failb=3D 24(D)=
  OK
[   19.797495] raid6test: test_disks(2, 25): faila=3D  2(D)  failb=3D 25(D)=
  OK
[   19.798361] raid6test: test_disks(2, 26): faila=3D  2(D)  failb=3D 26(D)=
  OK
[   19.799244] raid6test: test_disks(2, 27): faila=3D  2(D)  failb=3D 27(D)=
  OK
[   19.800114] raid6test: test_disks(2, 28): faila=3D  2(D)  failb=3D 28(D)=
  OK
[   19.800980] raid6test: test_disks(2, 29): faila=3D  2(D)  failb=3D 29(D)=
  OK
[   19.801848] raid6test: test_disks(2, 30): faila=3D  2(D)  failb=3D 30(D)=
  OK
[   19.802724] raid6test: test_disks(2, 31): faila=3D  2(D)  failb=3D 31(D)=
  OK
[   19.803591] raid6test: test_disks(2, 32): faila=3D  2(D)  failb=3D 32(D)=
  OK
[   19.804461] raid6test: test_disks(2, 33): faila=3D  2(D)  failb=3D 33(D)=
  OK
[   19.805324] raid6test: test_disks(2, 34): faila=3D  2(D)  failb=3D 34(D)=
  OK
[   19.806202] raid6test: test_disks(2, 35): faila=3D  2(D)  failb=3D 35(D)=
  OK
[   19.825088] raid6test: test_disks(2, 36): faila=3D  2(D)  failb=3D 36(D)=
  OK
[   19.825964] raid6test: test_disks(2, 37): faila=3D  2(D)  failb=3D 37(D)=
  OK
[   19.826832] raid6test: test_disks(2, 38): faila=3D  2(D)  failb=3D 38(D)=
  OK
[   19.827699] raid6test: test_disks(2, 39): faila=3D  2(D)  failb=3D 39(D)=
  OK
[   19.828569] raid6test: test_disks(2, 40): faila=3D  2(D)  failb=3D 40(D)=
  OK
[   19.829439] raid6test: test_disks(2, 41): faila=3D  2(D)  failb=3D 41(D)=
  OK
[   19.830307] raid6test: test_disks(2, 42): faila=3D  2(D)  failb=3D 42(D)=
  OK
[   19.831180] raid6test: test_disks(2, 43): faila=3D  2(D)  failb=3D 43(D)=
  OK
[   19.832047] raid6test: test_disks(2, 44): faila=3D  2(D)  failb=3D 44(D)=
  OK
[   19.832932] raid6test: test_disks(2, 45): faila=3D  2(D)  failb=3D 45(D)=
  OK
[   19.867873] raid6test: test_disks(2, 46): faila=3D  2(D)  failb=3D 46(D)=
  OK
[   19.868751] raid6test: test_disks(2, 47): faila=3D  2(D)  failb=3D 47(D)=
  OK
[   19.869628] raid6test: test_disks(2, 48): faila=3D  2(D)  failb=3D 48(D)=
  OK
[   19.870497] raid6test: test_disks(2, 49): faila=3D  2(D)  failb=3D 49(D)=
  OK
[   19.871364] raid6test: test_disks(2, 50): faila=3D  2(D)  failb=3D 50(D)=
  OK
[   19.872240] raid6test: test_disks(2, 51): faila=3D  2(D)  failb=3D 51(D)=
  OK
[   19.873123] raid6test: test_disks(2, 52): faila=3D  2(D)  failb=3D 52(D)=
  OK
[   19.873999] raid6test: test_disks(2, 53): faila=3D  2(D)  failb=3D 53(D)=
  OK
[   19.874868] raid6test: test_disks(2, 54): faila=3D  2(D)  failb=3D 54(D)=
  OK
[   19.875750] raid6test: test_disks(2, 55): faila=3D  2(D)  failb=3D 55(D)=
  OK
[   19.898690] raid6test: test_disks(2, 56): faila=3D  2(D)  failb=3D 56(D)=
  OK
[   19.899583] raid6test: test_disks(2, 57): faila=3D  2(D)  failb=3D 57(D)=
  OK
[   19.900583] raid6test: test_disks(2, 58): faila=3D  2(D)  failb=3D 58(D)=
  OK
[   19.901463] raid6test: test_disks(2, 59): faila=3D  2(D)  failb=3D 59(D)=
  OK
[   19.902345] raid6test: test_disks(2, 60): faila=3D  2(D)  failb=3D 60(D)=
  OK
[   19.903222] raid6test: test_disks(2, 61): faila=3D  2(D)  failb=3D 61(D)=
  OK
[   19.904087] raid6test: test_disks(2, 62): faila=3D  2(D)  failb=3D 62(P)=
  OK
[   19.904966] raid6test: test_disks(2, 63): faila=3D  2(D)  failb=3D 63(Q)=
  OK
[   19.905853] raid6test: test_disks(3, 4): faila=3D  3(D)  failb=3D  4(D) =
 OK
[   19.906724] raid6test: test_disks(3, 5): faila=3D  3(D)  failb=3D  5(D) =
 OK
[   19.907597] raid6test: test_disks(3, 6): faila=3D  3(D)  failb=3D  6(D) =
 OK
[   19.908480] raid6test: test_disks(3, 7): faila=3D  3(D)  failb=3D  7(D) =
 OK
[   19.909367] raid6test: test_disks(3, 8): faila=3D  3(D)  failb=3D  8(D) =
 OK
[   19.910242] raid6test: test_disks(3, 9): faila=3D  3(D)  failb=3D  9(D) =
 OK
[   19.911126] raid6test: test_disks(3, 10): faila=3D  3(D)  failb=3D 10(D)=
  OK
[   19.925071] raid6test: test_disks(3, 11): faila=3D  3(D)  failb=3D 11(D)=
  OK
[   19.926058] raid6test: test_disks(3, 12): faila=3D  3(D)  failb=3D 12(D)=
  OK
[   19.926983] raid6test: test_disks(3, 13): faila=3D  3(D)  failb=3D 13(D)=
  OK
[   19.927867] raid6test: test_disks(3, 14): faila=3D  3(D)  failb=3D 14(D)=
  OK
[   19.928756] raid6test: test_disks(3, 15): faila=3D  3(D)  failb=3D 15(D)=
  OK
[   19.929652] raid6test: test_disks(3, 16): faila=3D  3(D)  failb=3D 16(D)=
  OK
[   19.930540] raid6test: test_disks(3, 17): faila=3D  3(D)  failb=3D 17(D)=
  OK
[   19.931424] raid6test: test_disks(3, 18): faila=3D  3(D)  failb=3D 18(D)=
  OK
[   19.932304] raid6test: test_disks(3, 19): faila=3D  3(D)  failb=3D 19(D)=
  OK
[   19.933199] raid6test: test_disks(3, 20): faila=3D  3(D)  failb=3D 20(D)=
  OK
[   19.934089] raid6test: test_disks(3, 21): faila=3D  3(D)  failb=3D 21(D)=
  OK
[   19.934965] raid6test: test_disks(3, 22): faila=3D  3(D)  failb=3D 22(D)=
  OK
[   19.935839] raid6test: test_disks(3, 23): faila=3D  3(D)  failb=3D 23(D)=
  OK
[   19.936707] raid6test: test_disks(3, 24): faila=3D  3(D)  failb=3D 24(D)=
  OK
[   19.950620] raid6test: test_disks(3, 25): faila=3D  3(D)  failb=3D 25(D)=
  OK
[   19.951494] raid6test: test_disks(3, 26): faila=3D  3(D)  failb=3D 26(D)=
  OK
[   19.952373] raid6test: test_disks(3, 27): faila=3D  3(D)  failb=3D 27(D)=
  OK
[   19.953263] raid6test: test_disks(3, 28): faila=3D  3(D)  failb=3D 28(D)=
  OK
[   19.954145] raid6test: test_disks(3, 29): faila=3D  3(D)  failb=3D 29(D)=
  OK
[   19.955019] raid6test: test_disks(3, 30): faila=3D  3(D)  failb=3D 30(D)=
  OK
[   19.955990] raid6test: test_disks(3, 31): faila=3D  3(D)  failb=3D 31(D)=
  OK
[   19.956862] raid6test: test_disks(3, 32): faila=3D  3(D)  failb=3D 32(D)=
  OK
[   19.957731] raid6test: test_disks(3, 33): faila=3D  3(D)  failb=3D 33(D)=
  OK
[   19.958599] raid6test: test_disks(3, 34): faila=3D  3(D)  failb=3D 34(D)=
  OK
[   19.959511] raid6test: test_disks(3, 35): faila=3D  3(D)  failb=3D 35(D)=
  OK
[   19.960381] raid6test: test_disks(3, 36): faila=3D  3(D)  failb=3D 36(D)=
  OK
[   19.961257] raid6test: test_disks(3, 37): faila=3D  3(D)  failb=3D 37(D)=
  OK
[   19.962126] raid6test: test_disks(3, 38): faila=3D  3(D)  failb=3D 38(D)=
  OK
[   19.963002] raid6test: test_disks(3, 39): faila=3D  3(D)  failb=3D 39(D)=
  OK
[   19.963866] raid6test: test_disks(3, 40): faila=3D  3(D)  failb=3D 40(D)=
  OK
[   19.964732] raid6test: test_disks(3, 41): faila=3D  3(D)  failb=3D 41(D)=
  OK
[   19.965595] raid6test: test_disks(3, 42): faila=3D  3(D)  failb=3D 42(D)=
  OK
[   19.966481] raid6test: test_disks(3, 43): faila=3D  3(D)  failb=3D 43(D)=
  OK
[   19.967344] raid6test: test_disks(3, 44): faila=3D  3(D)  failb=3D 44(D)=
  OK
[   19.968211] raid6test: test_disks(3, 45): faila=3D  3(D)  failb=3D 45(D)=
  OK
[   19.969103] raid6test: test_disks(3, 46): faila=3D  3(D)  failb=3D 46(D)=
  OK
[   19.969977] raid6test: test_disks(3, 47): faila=3D  3(D)  failb=3D 47(D)=
  OK
[   19.970843] raid6test: test_disks(3, 48): faila=3D  3(D)  failb=3D 48(D)=
  OK
[   19.971708] raid6test: test_disks(3, 49): faila=3D  3(D)  failb=3D 49(D)=
  OK
[   19.985596] raid6test: test_disks(3, 50): faila=3D  3(D)  failb=3D 50(D)=
  OK
[   19.986469] raid6test: test_disks(3, 51): faila=3D  3(D)  failb=3D 51(D)=
  OK
[   19.987324] raid6test: test_disks(3, 52): faila=3D  3(D)  failb=3D 52(D)=
  OK
[   19.988188] raid6test: test_disks(3, 53): faila=3D  3(D)  failb=3D 53(D)=
  OK
[   19.989073] raid6test: test_disks(3, 54): faila=3D  3(D)  failb=3D 54(D)=
  OK
[   19.989939] raid6test: test_disks(3, 55): faila=3D  3(D)  failb=3D 55(D)=
  OK
[   19.990805] raid6test: test_disks(3, 56): faila=3D  3(D)  failb=3D 56(D)=
  OK
[   19.991676] raid6test: test_disks(3, 57): faila=3D  3(D)  failb=3D 57(D)=
  OK
[   19.992539] raid6test: test_disks(3, 58): faila=3D  3(D)  failb=3D 58(D)=
  OK
[   19.993624] raid6test: test_disks(3, 59): faila=3D  3(D)  failb=3D 59(D)=
  OK
[   19.994664] raid6test: test_disks(3, 60): faila=3D  3(D)  failb=3D 60(D)=
  OK
[   19.995606] raid6test: test_disks(3, 61): faila=3D  3(D)  failb=3D 61(D)=
  OK
[   19.996560] raid6test: test_disks(3, 62): faila=3D  3(D)  failb=3D 62(P)=
  OK
[   19.997422] raid6test: test_disks(3, 63): faila=3D  3(D)  failb=3D 63(Q)=
  OK
[   19.998285] raid6test: test_disks(4, 5): faila=3D  4(D)  failb=3D  5(D) =
 OK
[   20.012176] raid6test: test_disks(4, 6): faila=3D  4(D)  failb=3D  6(D) =
 OK
[   20.013047] raid6test: test_disks(4, 7): faila=3D  4(D)  failb=3D  7(D) =
 OK
[   20.014036] raid6test: test_disks(4, 8): faila=3D  4(D)  failb=3D  8(D) =
 OK
[   20.015144] raid6test: test_disks(4, 9): faila=3D  4(D)  failb=3D  9(D) =
 OK
[   20.016254] raid6test: test_disks(4, 10): faila=3D  4(D)  failb=3D 10(D)=
  OK
[   20.017342] raid6test: test_disks(4, 11): faila=3D  4(D)  failb=3D 11(D)=
  OK
[   20.018424] raid6test: test_disks(4, 12): faila=3D  4(D)  failb=3D 12(D)=
  OK
[   20.019502] raid6test: test_disks(4, 13): faila=3D  4(D)  failb=3D 13(D)=
  OK
[   20.036517] raid6test: test_disks(4, 14): faila=3D  4(D)  failb=3D 14(D)=
  OK
[   20.037388] raid6test: test_disks(4, 15): faila=3D  4(D)  failb=3D 15(D)=
  OK
[   20.038262] raid6test: test_disks(4, 16): faila=3D  4(D)  failb=3D 16(D)=
  OK
[   20.039137] raid6test: test_disks(4, 17): faila=3D  4(D)  failb=3D 17(D)=
  OK
[   20.040009] raid6test: test_disks(4, 18): faila=3D  4(D)  failb=3D 18(D)=
  OK
[   20.040878] raid6test: test_disks(4, 19): faila=3D  4(D)  failb=3D 19(D)=
  OK
[   20.041751] raid6test: test_disks(4, 20): faila=3D  4(D)  failb=3D 20(D)=
  OK
[   20.042636] raid6test: test_disks(4, 21): faila=3D  4(D)  failb=3D 21(D)=
  OK
[   20.043504] raid6test: test_disks(4, 22): faila=3D  4(D)  failb=3D 22(D)=
  OK
[   20.044365] raid6test: test_disks(4, 23): faila=3D  4(D)  failb=3D 23(D)=
  OK
[   20.045237] raid6test: test_disks(4, 24): faila=3D  4(D)  failb=3D 24(D)=
  OK
[   20.064125] raid6test: test_disks(4, 25): faila=3D  4(D)  failb=3D 25(D)=
  OK
[   20.064999] raid6test: test_disks(4, 26): faila=3D  4(D)  failb=3D 26(D)=
  OK
[   20.065874] raid6test: test_disks(4, 27): faila=3D  4(D)  failb=3D 27(D)=
  OK
[   20.066744] raid6test: test_disks(4, 28): faila=3D  4(D)  failb=3D 28(D)=
  OK
[   20.067611] raid6test: test_disks(4, 29): faila=3D  4(D)  failb=3D 29(D)=
  OK
[   20.087940] raid6test: test_disks(4, 30): faila=3D  4(D)  failb=3D 30(D)=
  OK
[   20.088819] raid6test: test_disks(4, 31): faila=3D  4(D)  failb=3D 31(D)=
  OK
[   20.089695] raid6test: test_disks(4, 32): faila=3D  4(D)  failb=3D 32(D)=
  OK
[   20.090562] raid6test: test_disks(4, 33): faila=3D  4(D)  failb=3D 33(D)=
  OK
[   20.091426] raid6test: test_disks(4, 34): faila=3D  4(D)  failb=3D 34(D)=
  OK
[   20.092285] raid6test: test_disks(4, 35): faila=3D  4(D)  failb=3D 35(D)=
  OK
[   20.093158] raid6test: test_disks(4, 36): faila=3D  4(D)  failb=3D 36(D)=
  OK
[   20.094021] raid6test: test_disks(4, 37): faila=3D  4(D)  failb=3D 37(D)=
  OK
[   20.094888] raid6test: test_disks(4, 38): faila=3D  4(D)  failb=3D 38(D)=
  OK
[   20.095771] raid6test: test_disks(4, 39): faila=3D  4(D)  failb=3D 39(D)=
  OK
[   20.096639] raid6test: test_disks(4, 40): faila=3D  4(D)  failb=3D 40(D)=
  OK
[   20.097501] raid6test: test_disks(4, 41): faila=3D  4(D)  failb=3D 41(D)=
  OK
[   20.098360] raid6test: test_disks(4, 42): faila=3D  4(D)  failb=3D 42(D)=
  OK
[   20.099244] raid6test: test_disks(4, 43): faila=3D  4(D)  failb=3D 43(D)=
  OK
[   20.117969] raid6test: test_disks(4, 44): faila=3D  4(D)  failb=3D 44(D)=
  OK
[   20.118845] raid6test: test_disks(4, 45): faila=3D  4(D)  failb=3D 45(D)=
  OK
[   20.119722] raid6test: test_disks(4, 46): faila=3D  4(D)  failb=3D 46(D)=
  OK
[   20.120589] raid6test: test_disks(4, 47): faila=3D  4(D)  failb=3D 47(D)=
  OK
[   20.121456] raid6test: test_disks(4, 48): faila=3D  4(D)  failb=3D 48(D)=
  OK
[   20.122314] raid6test: test_disks(4, 49): faila=3D  4(D)  failb=3D 49(D)=
  OK
[   20.123193] raid6test: test_disks(4, 50): faila=3D  4(D)  failb=3D 50(D)=
  OK
[   20.124058] raid6test: test_disks(4, 51): faila=3D  4(D)  failb=3D 51(D)=
  OK
[   20.124927] raid6test: test_disks(4, 52): faila=3D  4(D)  failb=3D 52(D)=
  OK
[   20.125800] raid6test: test_disks(4, 53): faila=3D  4(D)  failb=3D 53(D)=
  OK
[   20.135367] raid6test: test_disks(4, 54): faila=3D  4(D)  failb=3D 54(D)=
  OK
[   20.136252] raid6test: test_disks(4, 55): faila=3D  4(D)  failb=3D 55(D)=
  OK
[   20.137125] raid6test: test_disks(4, 56): faila=3D  4(D)  failb=3D 56(D)=
  OK
[   20.137990] raid6test: test_disks(4, 57): faila=3D  4(D)  failb=3D 57(D)=
  OK
[   20.138855] raid6test: test_disks(4, 58): faila=3D  4(D)  failb=3D 58(D)=
  OK
[   20.139726] raid6test: test_disks(4, 59): faila=3D  4(D)  failb=3D 59(D)=
  OK
[   20.140590] raid6test: test_disks(4, 60): faila=3D  4(D)  failb=3D 60(D)=
  OK
[   20.141455] raid6test: test_disks(4, 61): faila=3D  4(D)  failb=3D 61(D)=
  OK
[   20.142300] raid6test: test_disks(4, 62): faila=3D  4(D)  failb=3D 62(P)=
  OK
[   20.143168] raid6test: test_disks(4, 63): faila=3D  4(D)  failb=3D 63(Q)=
  OK
[   20.144033] raid6test: test_disks(5, 6): faila=3D  5(D)  failb=3D  6(D) =
 OK
[   20.144891] raid6test: test_disks(5, 7): faila=3D  5(D)  failb=3D  7(D) =
 OK
[   20.145755] raid6test: test_disks(5, 8): faila=3D  5(D)  failb=3D  8(D) =
 OK
[   20.146609] raid6test: test_disks(5, 9): faila=3D  5(D)  failb=3D  9(D) =
 OK
[   20.160484] raid6test: test_disks(5, 10): faila=3D  5(D)  failb=3D 10(D)=
  OK
[   20.161344] raid6test: test_disks(5, 11): faila=3D  5(D)  failb=3D 11(D)=
  OK
[   20.162213] raid6test: test_disks(5, 12): faila=3D  5(D)  failb=3D 12(D)=
  OK
[   20.163091] raid6test: test_disks(5, 13): faila=3D  5(D)  failb=3D 13(D)=
  OK
[   20.163955] raid6test: test_disks(5, 14): faila=3D  5(D)  failb=3D 14(D)=
  OK
[   20.164820] raid6test: test_disks(5, 15): faila=3D  5(D)  failb=3D 15(D)=
  OK
[   20.165699] raid6test: test_disks(5, 16): faila=3D  5(D)  failb=3D 16(D)=
  OK
[   20.166564] raid6test: test_disks(5, 17): faila=3D  5(D)  failb=3D 17(D)=
  OK
[   20.167429] raid6test: test_disks(5, 18): faila=3D  5(D)  failb=3D 18(D)=
  OK
[   20.168288] raid6test: test_disks(5, 19): faila=3D  5(D)  failb=3D 19(D)=
  OK
[   20.169160] raid6test: test_disks(5, 20): faila=3D  5(D)  failb=3D 20(D)=
  OK
[   20.170024] raid6test: test_disks(5, 21): faila=3D  5(D)  failb=3D 21(D)=
  OK
[   20.170891] raid6test: test_disks(5, 22): faila=3D  5(D)  failb=3D 22(D)=
  OK
[   20.171758] raid6test: test_disks(5, 23): faila=3D  5(D)  failb=3D 23(D)=
  OK
[   20.172638] raid6test: test_disks(5, 24): faila=3D  5(D)  failb=3D 24(D)=
  OK
[   20.186514] raid6test: test_disks(5, 25): faila=3D  5(D)  failb=3D 25(D)=
  OK
[   20.187382] raid6test: test_disks(5, 26): faila=3D  5(D)  failb=3D 26(D)=
  OK
[   20.188249] raid6test: test_disks(5, 27): faila=3D  5(D)  failb=3D 27(D)=
  OK
[   20.189129] raid6test: test_disks(5, 28): faila=3D  5(D)  failb=3D 28(D)=
  OK
[   20.189995] raid6test: test_disks(5, 29): faila=3D  5(D)  failb=3D 29(D)=
  OK
[   20.190863] raid6test: test_disks(5, 30): faila=3D  5(D)  failb=3D 30(D)=
  OK
[   20.191731] raid6test: test_disks(5, 31): faila=3D  5(D)  failb=3D 31(D)=
  OK
[   20.192615] raid6test: test_disks(5, 32): faila=3D  5(D)  failb=3D 32(D)=
  OK
[   20.193482] raid6test: test_disks(5, 33): faila=3D  5(D)  failb=3D 33(D)=
  OK
[   20.194337] raid6test: test_disks(5, 34): faila=3D  5(D)  failb=3D 34(D)=
  OK
[   20.195203] raid6test: test_disks(5, 35): faila=3D  5(D)  failb=3D 35(D)=
  OK
[   20.196074] raid6test: test_disks(5, 36): faila=3D  5(D)  failb=3D 36(D)=
  OK
[   20.196938] raid6test: test_disks(5, 37): faila=3D  5(D)  failb=3D 37(D)=
  OK
[   20.197804] raid6test: test_disks(5, 38): faila=3D  5(D)  failb=3D 38(D)=
  OK
[   20.198669] raid6test: test_disks(5, 39): faila=3D  5(D)  failb=3D 39(D)=
  OK
[   20.212558] raid6test: test_disks(5, 40): faila=3D  5(D)  failb=3D 40(D)=
  OK
[   20.213418] raid6test: test_disks(5, 41): faila=3D  5(D)  failb=3D 41(D)=
  OK
[   20.214277] raid6test: test_disks(5, 42): faila=3D  5(D)  failb=3D 42(D)=
  OK
[   20.215145] raid6test: test_disks(5, 43): faila=3D  5(D)  failb=3D 43(D)=
  OK
[   20.216025] raid6test: test_disks(5, 44): faila=3D  5(D)  failb=3D 44(D)=
  OK
[   20.216893] raid6test: test_disks(5, 45): faila=3D  5(D)  failb=3D 45(D)=
  OK
[   20.217763] raid6test: test_disks(5, 46): faila=3D  5(D)  failb=3D 46(D)=
  OK
[   20.218627] raid6test: test_disks(5, 47): faila=3D  5(D)  failb=3D 47(D)=
  OK
[   20.219500] raid6test: test_disks(5, 48): faila=3D  5(D)  failb=3D 48(D)=
  OK
[   20.220361] raid6test: test_disks(5, 49): faila=3D  5(D)  failb=3D 49(D)=
  OK
[   20.221222] raid6test: test_disks(5, 50): faila=3D  5(D)  failb=3D 50(D)=
  OK
[   20.222093] raid6test: test_disks(5, 51): faila=3D  5(D)  failb=3D 51(D)=
  OK
[   20.222967] raid6test: test_disks(5, 52): faila=3D  5(D)  failb=3D 52(D)=
  OK
[   20.223830] raid6test: test_disks(5, 53): faila=3D  5(D)  failb=3D 53(D)=
  OK
[   20.224693] raid6test: test_disks(5, 54): faila=3D  5(D)  failb=3D 54(D)=
  OK
[   20.238566] raid6test: test_disks(5, 55): faila=3D  5(D)  failb=3D 55(D)=
  OK
[   20.239441] raid6test: test_disks(5, 56): faila=3D  5(D)  failb=3D 56(D)=
  OK
[   20.240298] raid6test: test_disks(5, 57): faila=3D  5(D)  failb=3D 57(D)=
  OK
[   20.241161] raid6test: test_disks(5, 58): faila=3D  5(D)  failb=3D 58(D)=
  OK
[   20.242027] raid6test: test_disks(5, 59): faila=3D  5(D)  failb=3D 59(D)=
  OK
[   20.242909] raid6test: test_disks(5, 60): faila=3D  5(D)  failb=3D 60(D)=
  OK
[   20.243779] raid6test: test_disks(5, 61): faila=3D  5(D)  failb=3D 61(D)=
  OK
[   20.244635] raid6test: test_disks(5, 62): faila=3D  5(D)  failb=3D 62(P)=
  OK
[   20.245489] raid6test: test_disks(5, 63): faila=3D  5(D)  failb=3D 63(Q)=
  OK
[   20.246354] raid6test: test_disks(6, 7): faila=3D  6(D)  failb=3D  7(D) =
 OK
[   20.247211] raid6test: test_disks(6, 8): faila=3D  6(D)  failb=3D  8(D) =
 OK
[   20.248061] raid6test: test_disks(6, 9): faila=3D  6(D)  failb=3D  9(D) =
 OK
[   20.248923] raid6test: test_disks(6, 10): faila=3D  6(D)  failb=3D 10(D)=
  OK
[   20.249801] raid6test: test_disks(6, 11): faila=3D  6(D)  failb=3D 11(D)=
  OK
[   20.250665] raid6test: test_disks(6, 12): faila=3D  6(D)  failb=3D 12(D)=
  OK
[   20.260543] raid6test: test_disks(6, 13): faila=3D  6(D)  failb=3D 13(D)=
  OK
[   20.261415] raid6test: test_disks(6, 14): faila=3D  6(D)  failb=3D 14(D)=
  OK
[   20.262272] raid6test: test_disks(6, 15): faila=3D  6(D)  failb=3D 15(D)=
  OK
[   20.263154] raid6test: test_disks(6, 16): faila=3D  6(D)  failb=3D 16(D)=
  OK
[   20.264021] raid6test: test_disks(6, 17): faila=3D  6(D)  failb=3D 17(D)=
  OK
[   20.264886] raid6test: test_disks(6, 18): faila=3D  6(D)  failb=3D 18(D)=
  OK
[   20.265766] raid6test: test_disks(6, 19): faila=3D  6(D)  failb=3D 19(D)=
  OK
[   20.266636] raid6test: test_disks(6, 20): faila=3D  6(D)  failb=3D 20(D)=
  OK
[   20.267498] raid6test: test_disks(6, 21): faila=3D  6(D)  failb=3D 21(D)=
  OK
[   20.268363] raid6test: test_disks(6, 22): faila=3D  6(D)  failb=3D 22(D)=
  OK
[   20.269241] raid6test: test_disks(6, 23): faila=3D  6(D)  failb=3D 23(D)=
  OK
[   20.288145] raid6test: test_disks(6, 24): faila=3D  6(D)  failb=3D 24(D)=
  OK
[   20.289037] raid6test: test_disks(6, 25): faila=3D  6(D)  failb=3D 25(D)=
  OK
[   20.289904] raid6test: test_disks(6, 26): faila=3D  6(D)  failb=3D 26(D)=
  OK
[   20.290771] raid6test: test_disks(6, 27): faila=3D  6(D)  failb=3D 27(D)=
  OK
[   20.291641] raid6test: test_disks(6, 28): faila=3D  6(D)  failb=3D 28(D)=
  OK
[   20.292526] raid6test: test_disks(6, 29): faila=3D  6(D)  failb=3D 29(D)=
  OK
[   20.293389] raid6test: test_disks(6, 30): faila=3D  6(D)  failb=3D 30(D)=
  OK
[   20.294255] raid6test: test_disks(6, 31): faila=3D  6(D)  failb=3D 31(D)=
  OK
[   20.295127] raid6test: test_disks(6, 32): faila=3D  6(D)  failb=3D 32(D)=
  OK
[   20.296007] raid6test: test_disks(6, 33): faila=3D  6(D)  failb=3D 33(D)=
  OK
[   20.310891] raid6test: test_disks(6, 34): faila=3D  6(D)  failb=3D 34(D)=
  OK
[   20.311764] raid6test: test_disks(6, 35): faila=3D  6(D)  failb=3D 35(D)=
  OK
[   20.312648] raid6test: test_disks(6, 36): faila=3D  6(D)  failb=3D 36(D)=
  OK
[   20.313522] raid6test: test_disks(6, 37): faila=3D  6(D)  failb=3D 37(D)=
  OK
[   20.314383] raid6test: test_disks(6, 38): faila=3D  6(D)  failb=3D 38(D)=
  OK
[   20.315250] raid6test: test_disks(6, 39): faila=3D  6(D)  failb=3D 39(D)=
  OK
[   20.316120] raid6test: test_disks(6, 40): faila=3D  6(D)  failb=3D 40(D)=
  OK
[   20.316985] raid6test: test_disks(6, 41): faila=3D  6(D)  failb=3D 41(D)=
  OK
[   20.317853] raid6test: test_disks(6, 42): faila=3D  6(D)  failb=3D 42(D)=
  OK
[   20.318723] raid6test: test_disks(6, 43): faila=3D  6(D)  failb=3D 43(D)=
  OK
[   20.337605] raid6test: test_disks(6, 44): faila=3D  6(D)  failb=3D 44(D)=
  OK
[   20.338482] raid6test: test_disks(6, 45): faila=3D  6(D)  failb=3D 45(D)=
  OK
[   20.339358] raid6test: test_disks(6, 46): faila=3D  6(D)  failb=3D 46(D)=
  OK
[   20.340230] raid6test: test_disks(6, 47): faila=3D  6(D)  failb=3D 47(D)=
  OK
[   20.341103] raid6test: test_disks(6, 48): faila=3D  6(D)  failb=3D 48(D)=
  OK
[   20.341973] raid6test: test_disks(6, 49): faila=3D  6(D)  failb=3D 49(D)=
  OK
[   20.342848] raid6test: test_disks(6, 50): faila=3D  6(D)  failb=3D 50(D)=
  OK
[   20.343714] raid6test: test_disks(6, 51): faila=3D  6(D)  failb=3D 51(D)=
  OK
[   20.344583] raid6test: test_disks(6, 52): faila=3D  6(D)  failb=3D 52(D)=
  OK
[   20.345453] raid6test: test_disks(6, 53): faila=3D  6(D)  failb=3D 53(D)=
  OK
[   20.346320] raid6test: test_disks(6, 54): faila=3D  6(D)  failb=3D 54(D)=
  OK
[   20.369875] raid6test: test_disks(6, 55): faila=3D  6(D)  failb=3D 55(D)=
  OK
[   20.370747] raid6test: test_disks(6, 56): faila=3D  6(D)  failb=3D 56(D)=
  OK
[   20.371616] raid6test: test_disks(6, 57): faila=3D  6(D)  failb=3D 57(D)=
  OK
[   20.372493] raid6test: test_disks(6, 58): faila=3D  6(D)  failb=3D 58(D)=
  OK
[   20.373358] raid6test: test_disks(6, 59): faila=3D  6(D)  failb=3D 59(D)=
  OK
[   20.374225] raid6test: test_disks(6, 60): faila=3D  6(D)  failb=3D 60(D)=
  OK
[   20.384114] raid6test: test_disks(6, 61): faila=3D  6(D)  failb=3D 61(D)=
  OK
[   20.384984] raid6test: test_disks(6, 62): faila=3D  6(D)  failb=3D 62(P)=
  OK
[   20.385858] raid6test: test_disks(6, 63): faila=3D  6(D)  failb=3D 63(Q)=
  OK
[   20.386730] raid6test: test_disks(7, 8): faila=3D  7(D)  failb=3D  8(D) =
 OK
[   20.387587] raid6test: test_disks(7, 9): faila=3D  7(D)  failb=3D  9(D) =
 OK
[   20.388447] raid6test: test_disks(7, 10): faila=3D  7(D)  failb=3D 10(D)=
  OK
[   20.389313] raid6test: test_disks(7, 11): faila=3D  7(D)  failb=3D 11(D)=
  OK
[   20.390185] raid6test: test_disks(7, 12): faila=3D  7(D)  failb=3D 12(D)=
  OK
[   20.391050] raid6test: test_disks(7, 13): faila=3D  7(D)  failb=3D 13(D)=
  OK
[   20.391921] raid6test: test_disks(7, 14): faila=3D  7(D)  failb=3D 14(D)=
  OK
[   20.405822] raid6test: test_disks(7, 15): faila=3D  7(D)  failb=3D 15(D)=
  OK
[   20.407041] raid6test: test_disks(7, 16): faila=3D  7(D)  failb=3D 16(D)=
  OK
[   20.407909] raid6test: test_disks(7, 17): faila=3D  7(D)  failb=3D 17(D)=
  OK
[   20.408774] raid6test: test_disks(7, 18): faila=3D  7(D)  failb=3D 18(D)=
  OK
[   20.409669] raid6test: test_disks(7, 19): faila=3D  7(D)  failb=3D 19(D)=
  OK
[   20.410535] raid6test: test_disks(7, 20): faila=3D  7(D)  failb=3D 20(D)=
  OK
[   20.411392] raid6test: test_disks(7, 21): faila=3D  7(D)  failb=3D 21(D)=
  OK
[   20.412257] raid6test: test_disks(7, 22): faila=3D  7(D)  failb=3D 22(D)=
  OK
[   20.413134] raid6test: test_disks(7, 23): faila=3D  7(D)  failb=3D 23(D)=
  OK
[   20.414002] raid6test: test_disks(7, 24): faila=3D  7(D)  failb=3D 24(D)=
  OK
[   20.432930] raid6test: test_disks(7, 25): faila=3D  7(D)  failb=3D 25(D)=
  OK
[   20.433797] raid6test: test_disks(7, 26): faila=3D  7(D)  failb=3D 26(D)=
  OK
[   20.434662] raid6test: test_disks(7, 27): faila=3D  7(D)  failb=3D 27(D)=
  OK
[   20.435527] raid6test: test_disks(7, 28): faila=3D  7(D)  failb=3D 28(D)=
  OK
[   20.436411] raid6test: test_disks(7, 29): faila=3D  7(D)  failb=3D 29(D)=
  OK
[   20.437271] raid6test: test_disks(7, 30): faila=3D  7(D)  failb=3D 30(D)=
  OK
[   20.438137] raid6test: test_disks(7, 31): faila=3D  7(D)  failb=3D 31(D)=
  OK
[   20.439016] raid6test: test_disks(7, 32): faila=3D  7(D)  failb=3D 32(D)=
  OK
[   20.439881] raid6test: test_disks(7, 33): faila=3D  7(D)  failb=3D 33(D)=
  OK
[   20.440750] raid6test: test_disks(7, 34): faila=3D  7(D)  failb=3D 34(D)=
  OK
[   20.454661] raid6test: test_disks(7, 35): faila=3D  7(D)  failb=3D 35(D)=
  OK
[   20.455533] raid6test: test_disks(7, 36): faila=3D  7(D)  failb=3D 36(D)=
  OK
[   20.456426] raid6test: test_disks(7, 37): faila=3D  7(D)  failb=3D 37(D)=
  OK
[   20.457285] raid6test: test_disks(7, 38): faila=3D  7(D)  failb=3D 38(D)=
  OK
[   20.458155] raid6test: test_disks(7, 39): faila=3D  7(D)  failb=3D 39(D)=
  OK
[   20.459029] raid6test: test_disks(7, 40): faila=3D  7(D)  failb=3D 40(D)=
  OK
[   20.459893] raid6test: test_disks(7, 41): faila=3D  7(D)  failb=3D 41(D)=
  OK
[   20.460758] raid6test: test_disks(7, 42): faila=3D  7(D)  failb=3D 42(D)=
  OK
[   20.461620] raid6test: test_disks(7, 43): faila=3D  7(D)  failb=3D 43(D)=
  OK
[   20.462498] raid6test: test_disks(7, 44): faila=3D  7(D)  failb=3D 44(D)=
  OK
[   20.463353] raid6test: test_disks(7, 45): faila=3D  7(D)  failb=3D 45(D)=
  OK
[   20.464218] raid6test: test_disks(7, 46): faila=3D  7(D)  failb=3D 46(D)=
  OK
[   20.465084] raid6test: test_disks(7, 47): faila=3D  7(D)  failb=3D 47(D)=
  OK
[   20.465962] raid6test: test_disks(7, 48): faila=3D  7(D)  failb=3D 48(D)=
  OK
[   20.501251] raid6test: test_disks(7, 49): faila=3D  7(D)  failb=3D 49(D)=
  OK
[   20.502131] raid6test: test_disks(7, 50): faila=3D  7(D)  failb=3D 50(D)=
  OK
[   20.503018] raid6test: test_disks(7, 51): faila=3D  7(D)  failb=3D 51(D)=
  OK
[   20.503890] raid6test: test_disks(7, 52): faila=3D  7(D)  failb=3D 52(D)=
  OK
[   20.504761] raid6test: test_disks(7, 53): faila=3D  7(D)  failb=3D 53(D)=
  OK
[   20.505630] raid6test: test_disks(7, 54): faila=3D  7(D)  failb=3D 54(D)=
  OK
[   20.506514] raid6test: test_disks(7, 55): faila=3D  7(D)  failb=3D 55(D)=
  OK
[   20.507372] raid6test: test_disks(7, 56): faila=3D  7(D)  failb=3D 56(D)=
  OK
[   20.508241] raid6test: test_disks(7, 57): faila=3D  7(D)  failb=3D 57(D)=
  OK
[   20.509121] raid6test: test_disks(7, 58): faila=3D  7(D)  failb=3D 58(D)=
  OK
[   20.519142] raid6test: test_disks(7, 59): faila=3D  7(D)  failb=3D 59(D)=
  OK
[   20.520008] raid6test: test_disks(7, 60): faila=3D  7(D)  failb=3D 60(D)=
  OK
[   20.520873] raid6test: test_disks(7, 61): faila=3D  7(D)  failb=3D 61(D)=
  OK
[   20.521730] raid6test: test_disks(7, 62): faila=3D  7(D)  failb=3D 62(P)=
  OK
[   20.522603] raid6test: test_disks(7, 63): faila=3D  7(D)  failb=3D 63(Q)=
  OK
[   20.523468] raid6test: test_disks(8, 9): faila=3D  8(D)  failb=3D  9(D) =
 OK
[   20.524314] raid6test: test_disks(8, 10): faila=3D  8(D)  failb=3D 10(D)=
  OK
[   20.525178] raid6test: test_disks(8, 11): faila=3D  8(D)  failb=3D 11(D)=
  OK
[   20.526081] raid6test: test_disks(8, 12): faila=3D  8(D)  failb=3D 12(D)=
  OK
[   20.544822] raid6test: test_disks(8, 13): faila=3D  8(D)  failb=3D 13(D)=
  OK
[   20.545704] raid6test: test_disks(8, 14): faila=3D  8(D)  failb=3D 14(D)=
  OK
[   20.546568] raid6test: test_disks(8, 15): faila=3D  8(D)  failb=3D 15(D)=
  OK
[   20.547432] raid6test: test_disks(8, 16): faila=3D  8(D)  failb=3D 16(D)=
  OK
[   20.548282] raid6test: test_disks(8, 17): faila=3D  8(D)  failb=3D 17(D)=
  OK
[   20.549170] raid6test: test_disks(8, 18): faila=3D  8(D)  failb=3D 18(D)=
  OK
[   20.550036] raid6test: test_disks(8, 19): faila=3D  8(D)  failb=3D 19(D)=
  OK
[   20.550901] raid6test: test_disks(8, 20): faila=3D  8(D)  failb=3D 20(D)=
  OK
[   20.551766] raid6test: test_disks(8, 21): faila=3D  8(D)  failb=3D 21(D)=
  OK
[   20.552654] raid6test: test_disks(8, 22): faila=3D  8(D)  failb=3D 22(D)=
  OK
[   20.553521] raid6test: test_disks(8, 23): faila=3D  8(D)  failb=3D 23(D)=
  OK
[   20.554381] raid6test: test_disks(8, 24): faila=3D  8(D)  failb=3D 24(D)=
  OK
[   20.555241] raid6test: test_disks(8, 25): faila=3D  8(D)  failb=3D 25(D)=
  OK
[   20.556117] raid6test: test_disks(8, 26): faila=3D  8(D)  failb=3D 26(D)=
  OK
[   20.573070] raid6test: test_disks(8, 27): faila=3D  8(D)  failb=3D 27(D)=
  OK
[   20.573938] raid6test: test_disks(8, 28): faila=3D  8(D)  failb=3D 28(D)=
  OK
[   20.574801] raid6test: test_disks(8, 29): faila=3D  8(D)  failb=3D 29(D)=
  OK
[   20.575691] raid6test: test_disks(8, 30): faila=3D  8(D)  failb=3D 30(D)=
  OK
[   20.576565] raid6test: test_disks(8, 31): faila=3D  8(D)  failb=3D 31(D)=
  OK
[   20.587348] raid6test: test_disks(8, 32): faila=3D  8(D)  failb=3D 32(D)=
  OK
[   20.588266] raid6test: test_disks(8, 33): faila=3D  8(D)  failb=3D 33(D)=
  OK
[   20.589152] raid6test: test_disks(8, 34): faila=3D  8(D)  failb=3D 34(D)=
  OK
[   20.590022] raid6test: test_disks(8, 35): faila=3D  8(D)  failb=3D 35(D)=
  OK
[   20.590885] raid6test: test_disks(8, 36): faila=3D  8(D)  failb=3D 36(D)=
  OK
[   20.591751] raid6test: test_disks(8, 37): faila=3D  8(D)  failb=3D 37(D)=
  OK
[   20.592632] raid6test: test_disks(8, 38): faila=3D  8(D)  failb=3D 38(D)=
  OK
[   20.593499] raid6test: test_disks(8, 39): faila=3D  8(D)  failb=3D 39(D)=
  OK
[   20.594356] raid6test: test_disks(8, 40): faila=3D  8(D)  failb=3D 40(D)=
  OK
[   20.595222] raid6test: test_disks(8, 41): faila=3D  8(D)  failb=3D 41(D)=
  OK
[   20.596098] raid6test: test_disks(8, 42): faila=3D  8(D)  failb=3D 42(D)=
  OK
[   20.596961] raid6test: test_disks(8, 43): faila=3D  8(D)  failb=3D 43(D)=
  OK
[   20.597822] raid6test: test_disks(8, 44): faila=3D  8(D)  failb=3D 44(D)=
  OK
[   20.598687] raid6test: test_disks(8, 45): faila=3D  8(D)  failb=3D 45(D)=
  OK
[   20.612564] raid6test: test_disks(8, 46): faila=3D  8(D)  failb=3D 46(D)=
  OK
[   20.613430] raid6test: test_disks(8, 47): faila=3D  8(D)  failb=3D 47(D)=
  OK
[   20.614285] raid6test: test_disks(8, 48): faila=3D  8(D)  failb=3D 48(D)=
  OK
[   20.615148] raid6test: test_disks(8, 49): faila=3D  8(D)  failb=3D 49(D)=
  OK
[   20.616032] raid6test: test_disks(8, 50): faila=3D  8(D)  failb=3D 50(D)=
  OK
[   20.616900] raid6test: test_disks(8, 51): faila=3D  8(D)  failb=3D 51(D)=
  OK
[   20.617768] raid6test: test_disks(8, 52): faila=3D  8(D)  failb=3D 52(D)=
  OK
[   20.618634] raid6test: test_disks(8, 53): faila=3D  8(D)  failb=3D 53(D)=
  OK
[   20.619514] raid6test: test_disks(8, 54): faila=3D  8(D)  failb=3D 54(D)=
  OK
[   20.620374] raid6test: test_disks(8, 55): faila=3D  8(D)  failb=3D 55(D)=
  OK
[   20.621240] raid6test: test_disks(8, 56): faila=3D  8(D)  failb=3D 56(D)=
  OK
[   20.622106] raid6test: test_disks(8, 57): faila=3D  8(D)  failb=3D 57(D)=
  OK
[   20.622979] raid6test: test_disks(8, 58): faila=3D  8(D)  failb=3D 58(D)=
  OK
[   20.623845] raid6test: test_disks(8, 59): faila=3D  8(D)  failb=3D 59(D)=
  OK
[   20.624710] raid6test: test_disks(8, 60): faila=3D  8(D)  failb=3D 60(D)=
  OK
[   20.638606] raid6test: test_disks(8, 61): faila=3D  8(D)  failb=3D 61(D)=
  OK
[   20.639467] raid6test: test_disks(8, 62): faila=3D  8(D)  failb=3D 62(P)=
  OK
[   20.640311] raid6test: test_disks(8, 63): faila=3D  8(D)  failb=3D 63(Q)=
  OK
[   20.641170] raid6test: test_disks(9, 10): faila=3D  9(D)  failb=3D 10(D)=
  OK
[   20.642040] raid6test: test_disks(9, 11): faila=3D  9(D)  failb=3D 11(D)=
  OK
[   20.642911] raid6test: test_disks(9, 12): faila=3D  9(D)  failb=3D 12(D)=
  OK
[   20.643774] raid6test: test_disks(9, 13): faila=3D  9(D)  failb=3D 13(D)=
  OK
[   20.644636] raid6test: test_disks(9, 14): faila=3D  9(D)  failb=3D 14(D)=
  OK
[   20.645503] raid6test: test_disks(9, 15): faila=3D  9(D)  failb=3D 15(D)=
  OK
[   20.646378] raid6test: test_disks(9, 16): faila=3D  9(D)  failb=3D 16(D)=
  OK
[   20.647254] raid6test: test_disks(9, 17): faila=3D  9(D)  failb=3D 17(D)=
  OK
[   20.648126] raid6test: test_disks(9, 18): faila=3D  9(D)  failb=3D 18(D)=
  OK
[   20.649003] raid6test: test_disks(9, 19): faila=3D  9(D)  failb=3D 19(D)=
  OK
[   20.649868] raid6test: test_disks(9, 20): faila=3D  9(D)  failb=3D 20(D)=
  OK
[   20.650734] raid6test: test_disks(9, 21): faila=3D  9(D)  failb=3D 21(D)=
  OK
[   20.660716] raid6test: test_disks(9, 22): faila=3D  9(D)  failb=3D 22(D)=
  OK
[   20.661582] raid6test: test_disks(9, 23): faila=3D  9(D)  failb=3D 23(D)=
  OK
[   20.662462] raid6test: test_disks(9, 24): faila=3D  9(D)  failb=3D 24(D)=
  OK
[   20.663317] raid6test: test_disks(9, 25): faila=3D  9(D)  failb=3D 25(D)=
  OK
[   20.664188] raid6test: test_disks(9, 26): faila=3D  9(D)  failb=3D 26(D)=
  OK
[   20.665058] raid6test: test_disks(9, 27): faila=3D  9(D)  failb=3D 27(D)=
  OK
[   20.665937] raid6test: test_disks(9, 28): faila=3D  9(D)  failb=3D 28(D)=
  OK
[   20.666808] raid6test: test_disks(9, 29): faila=3D  9(D)  failb=3D 29(D)=
  OK
[   20.667673] raid6test: test_disks(9, 30): faila=3D  9(D)  failb=3D 30(D)=
  OK
[   20.668532] raid6test: test_disks(9, 31): faila=3D  9(D)  failb=3D 31(D)=
  OK
[   20.669412] raid6test: test_disks(9, 32): faila=3D  9(D)  failb=3D 32(D)=
  OK
[   20.670271] raid6test: test_disks(9, 33): faila=3D  9(D)  failb=3D 33(D)=
  OK
[   20.706002] raid6test: test_disks(9, 34): faila=3D  9(D)  failb=3D 34(D)=
  OK
[   20.706873] raid6test: test_disks(9, 35): faila=3D  9(D)  failb=3D 35(D)=
  OK
[   20.707747] raid6test: test_disks(9, 36): faila=3D  9(D)  failb=3D 36(D)=
  OK
[   20.708618] raid6test: test_disks(9, 37): faila=3D  9(D)  failb=3D 37(D)=
  OK
[   20.709476] raid6test: test_disks(9, 38): faila=3D  9(D)  failb=3D 38(D)=
  OK
[   20.710644] raid6test: test_disks(9, 39): faila=3D  9(D)  failb=3D 39(D)=
  OK
[   20.711795] raid6test: test_disks(9, 40): faila=3D  9(D)  failb=3D 40(D)=
  OK
[   20.712988] raid6test: test_disks(9, 41): faila=3D  9(D)  failb=3D 41(D)=
  OK
[   20.713851] raid6test: test_disks(9, 42): faila=3D  9(D)  failb=3D 42(D)=
  OK
[   20.714716] raid6test: test_disks(9, 43): faila=3D  9(D)  failb=3D 43(D)=
  OK
[   20.715581] raid6test: test_disks(9, 44): faila=3D  9(D)  failb=3D 44(D)=
  OK
[   20.716458] raid6test: test_disks(9, 45): faila=3D  9(D)  failb=3D 45(D)=
  OK
[   20.717313] raid6test: test_disks(9, 46): faila=3D  9(D)  failb=3D 46(D)=
  OK
[   20.718179] raid6test: test_disks(9, 47): faila=3D  9(D)  failb=3D 47(D)=
  OK
[   20.721085] raid6test: test_disks(9, 48): faila=3D  9(D)  failb=3D 48(D)=
  OK
[   20.721952] raid6test: test_disks(9, 49): faila=3D  9(D)  failb=3D 49(D)=
  OK
[   20.722827] raid6test: test_disks(9, 50): faila=3D  9(D)  failb=3D 50(D)=
  OK
[   20.723694] raid6test: test_disks(9, 51): faila=3D  9(D)  failb=3D 51(D)=
  OK
[   20.724562] raid6test: test_disks(9, 52): faila=3D  9(D)  failb=3D 52(D)=
  OK
[   20.725430] raid6test: test_disks(9, 53): faila=3D  9(D)  failb=3D 53(D)=
  OK
[   20.726304] raid6test: test_disks(9, 54): faila=3D  9(D)  failb=3D 54(D)=
  OK
[   20.727170] raid6test: test_disks(9, 55): faila=3D  9(D)  failb=3D 55(D)=
  OK
[   20.728040] raid6test: test_disks(9, 56): faila=3D  9(D)  failb=3D 56(D)=
  OK
[   20.728908] raid6test: test_disks(9, 57): faila=3D  9(D)  failb=3D 57(D)=
  OK
[   20.729785] raid6test: test_disks(9, 58): faila=3D  9(D)  failb=3D 58(D)=
  OK
[   20.730648] raid6test: test_disks(9, 59): faila=3D  9(D)  failb=3D 59(D)=
  OK
[   20.731510] raid6test: test_disks(9, 60): faila=3D  9(D)  failb=3D 60(D)=
  OK
[   20.732387] raid6test: test_disks(9, 61): faila=3D  9(D)  failb=3D 61(D)=
  OK
[   20.733248] raid6test: test_disks(9, 62): faila=3D  9(D)  failb=3D 62(P)=
  OK
[   20.734109] raid6test: test_disks(9, 63): faila=3D  9(D)  failb=3D 63(Q)=
  OK
[   20.734978] raid6test: test_disks(10, 11): faila=3D 10(D)  failb=3D 11(D=
)  OK
[   20.735870] raid6test: test_disks(10, 12): faila=3D 10(D)  failb=3D 12(D=
)  OK
[   20.736746] raid6test: test_disks(10, 13): faila=3D 10(D)  failb=3D 13(D=
)  OK
[   20.737625] raid6test: test_disks(10, 14): faila=3D 10(D)  failb=3D 14(D=
)  OK
[   20.738501] raid6test: test_disks(10, 15): faila=3D 10(D)  failb=3D 15(D=
)  OK
[   20.739380] raid6test: test_disks(10, 16): faila=3D 10(D)  failb=3D 16(D=
)  OK
[   20.740263] raid6test: test_disks(10, 17): faila=3D 10(D)  failb=3D 17(D=
)  OK
[   20.741140] raid6test: test_disks(10, 18): faila=3D 10(D)  failb=3D 18(D=
)  OK
[   20.742022] raid6test: test_disks(10, 19): faila=3D 10(D)  failb=3D 19(D=
)  OK
[   20.742906] raid6test: test_disks(10, 20): faila=3D 10(D)  failb=3D 20(D=
)  OK
[   20.743784] raid6test: test_disks(10, 21): faila=3D 10(D)  failb=3D 21(D=
)  OK
[   20.744658] raid6test: test_disks(10, 22): faila=3D 10(D)  failb=3D 22(D=
)  OK
[   20.745533] raid6test: test_disks(10, 23): faila=3D 10(D)  failb=3D 23(D=
)  OK
[   20.746426] raid6test: test_disks(10, 24): faila=3D 10(D)  failb=3D 24(D=
)  OK
[   20.747298] raid6test: test_disks(10, 25): faila=3D 10(D)  failb=3D 25(D=
)  OK
[   20.748183] raid6test: test_disks(10, 26): faila=3D 10(D)  failb=3D 26(D=
)  OK
[   20.749074] raid6test: test_disks(10, 27): faila=3D 10(D)  failb=3D 27(D=
)  OK
[   20.749950] raid6test: test_disks(10, 28): faila=3D 10(D)  failb=3D 28(D=
)  OK
[   20.750825] raid6test: test_disks(10, 29): faila=3D 10(D)  failb=3D 29(D=
)  OK
[   20.751700] raid6test: test_disks(10, 30): faila=3D 10(D)  failb=3D 30(D=
)  OK
[   20.752590] raid6test: test_disks(10, 31): faila=3D 10(D)  failb=3D 31(D=
)  OK
[   20.753468] raid6test: test_disks(10, 32): faila=3D 10(D)  failb=3D 32(D=
)  OK
[   20.754334] raid6test: test_disks(10, 33): faila=3D 10(D)  failb=3D 33(D=
)  OK
[   20.755208] raid6test: test_disks(10, 34): faila=3D 10(D)  failb=3D 34(D=
)  OK
[   20.756099] raid6test: test_disks(10, 35): faila=3D 10(D)  failb=3D 35(D=
)  OK
[   20.756982] raid6test: test_disks(10, 36): faila=3D 10(D)  failb=3D 36(D=
)  OK
[   20.757859] raid6test: test_disks(10, 37): faila=3D 10(D)  failb=3D 37(D=
)  OK
[   20.758735] raid6test: test_disks(10, 38): faila=3D 10(D)  failb=3D 38(D=
)  OK
[   20.759621] raid6test: test_disks(10, 39): faila=3D 10(D)  failb=3D 39(D=
)  OK
[   20.760496] raid6test: test_disks(10, 40): faila=3D 10(D)  failb=3D 40(D=
)  OK
[   20.761362] raid6test: test_disks(10, 41): faila=3D 10(D)  failb=3D 41(D=
)  OK
[   20.762235] raid6test: test_disks(10, 42): faila=3D 10(D)  failb=3D 42(D=
)  OK
[   20.763118] raid6test: test_disks(10, 43): faila=3D 10(D)  failb=3D 43(D=
)  OK
[   20.763997] raid6test: test_disks(10, 44): faila=3D 10(D)  failb=3D 44(D=
)  OK
[   20.764871] raid6test: test_disks(10, 45): faila=3D 10(D)  failb=3D 45(D=
)  OK
[   20.765766] raid6test: test_disks(10, 46): faila=3D 10(D)  failb=3D 46(D=
)  OK
[   20.766645] raid6test: test_disks(10, 47): faila=3D 10(D)  failb=3D 47(D=
)  OK
[   20.767519] raid6test: test_disks(10, 48): faila=3D 10(D)  failb=3D 48(D=
)  OK
[   20.768388] raid6test: test_disks(10, 49): faila=3D 10(D)  failb=3D 49(D=
)  OK
[   20.769272] raid6test: test_disks(10, 50): faila=3D 10(D)  failb=3D 50(D=
)  OK
[   20.770150] raid6test: test_disks(10, 51): faila=3D 10(D)  failb=3D 51(D=
)  OK
[   20.771026] raid6test: test_disks(10, 52): faila=3D 10(D)  failb=3D 52(D=
)  OK
[   20.771901] raid6test: test_disks(10, 53): faila=3D 10(D)  failb=3D 53(D=
)  OK
[   20.772783] raid6test: test_disks(10, 54): faila=3D 10(D)  failb=3D 54(D=
)  OK
[   20.773660] raid6test: test_disks(10, 55): faila=3D 10(D)  failb=3D 55(D=
)  OK
[   20.774533] raid6test: test_disks(10, 56): faila=3D 10(D)  failb=3D 56(D=
)  OK
[   20.775406] raid6test: test_disks(10, 57): faila=3D 10(D)  failb=3D 57(D=
)  OK
[   20.776284] raid6test: test_disks(10, 58): faila=3D 10(D)  failb=3D 58(D=
)  OK
[   20.777165] raid6test: test_disks(10, 59): faila=3D 10(D)  failb=3D 59(D=
)  OK
[   20.778045] raid6test: test_disks(10, 60): faila=3D 10(D)  failb=3D 60(D=
)  OK
[   20.778923] raid6test: test_disks(10, 61): faila=3D 10(D)  failb=3D 61(D=
)  OK
[   20.779797] raid6test: test_disks(10, 62): faila=3D 10(D)  failb=3D 62(P=
)  OK
[   20.780668] raid6test: test_disks(10, 63): faila=3D 10(D)  failb=3D 63(Q=
)  OK
[   20.781543] raid6test: test_disks(11, 12): faila=3D 11(D)  failb=3D 12(D=
)  OK
[   20.782430] raid6test: test_disks(11, 13): faila=3D 11(D)  failb=3D 13(D=
)  OK
[   20.783298] raid6test: test_disks(11, 14): faila=3D 11(D)  failb=3D 14(D=
)  OK
[   20.784174] raid6test: test_disks(11, 15): faila=3D 11(D)  failb=3D 15(D=
)  OK
[   20.785053] raid6test: test_disks(11, 16): faila=3D 11(D)  failb=3D 16(D=
)  OK
[   20.785948] raid6test: test_disks(11, 17): faila=3D 11(D)  failb=3D 17(D=
)  OK
[   20.786828] raid6test: test_disks(11, 18): faila=3D 11(D)  failb=3D 18(D=
)  OK
[   20.787708] raid6test: test_disks(11, 19): faila=3D 11(D)  failb=3D 19(D=
)  OK
[   20.788582] raid6test: test_disks(11, 20): faila=3D 11(D)  failb=3D 20(D=
)  OK
[   20.789469] raid6test: test_disks(11, 21): faila=3D 11(D)  failb=3D 21(D=
)  OK
[   20.790336] raid6test: test_disks(11, 22): faila=3D 11(D)  failb=3D 22(D=
)  OK
[   20.791208] raid6test: test_disks(11, 23): faila=3D 11(D)  failb=3D 23(D=
)  OK
[   20.792084] raid6test: test_disks(11, 24): faila=3D 11(D)  failb=3D 24(D=
)  OK
[   20.792966] raid6test: test_disks(11, 25): faila=3D 11(D)  failb=3D 25(D=
)  OK
[   20.793843] raid6test: test_disks(11, 26): faila=3D 11(D)  failb=3D 26(D=
)  OK
[   20.794723] raid6test: test_disks(11, 27): faila=3D 11(D)  failb=3D 27(D=
)  OK
[   20.795600] raid6test: test_disks(11, 28): faila=3D 11(D)  failb=3D 28(D=
)  OK
[   20.796500] raid6test: test_disks(11, 29): faila=3D 11(D)  failb=3D 29(D=
)  OK
[   20.797371] raid6test: test_disks(11, 30): faila=3D 11(D)  failb=3D 30(D=
)  OK
[   20.798246] raid6test: test_disks(11, 31): faila=3D 11(D)  failb=3D 31(D=
)  OK
[   20.799135] raid6test: test_disks(11, 32): faila=3D 11(D)  failb=3D 32(D=
)  OK
[   20.800011] raid6test: test_disks(11, 33): faila=3D 11(D)  failb=3D 33(D=
)  OK
[   20.800888] raid6test: test_disks(11, 34): faila=3D 11(D)  failb=3D 34(D=
)  OK
[   20.801769] raid6test: test_disks(11, 35): faila=3D 11(D)  failb=3D 35(D=
)  OK
[   20.802658] raid6test: test_disks(11, 36): faila=3D 11(D)  failb=3D 36(D=
)  OK
[   20.803539] raid6test: test_disks(11, 37): faila=3D 11(D)  failb=3D 37(D=
)  OK
[   20.804417] raid6test: test_disks(11, 38): faila=3D 11(D)  failb=3D 38(D=
)  OK
[   20.805290] raid6test: test_disks(11, 39): faila=3D 11(D)  failb=3D 39(D=
)  OK
[   20.806181] raid6test: test_disks(11, 40): faila=3D 11(D)  failb=3D 40(D=
)  OK
[   20.807058] raid6test: test_disks(11, 41): faila=3D 11(D)  failb=3D 41(D=
)  OK
[   20.807932] raid6test: test_disks(11, 42): faila=3D 11(D)  failb=3D 42(D=
)  OK
[   20.808810] raid6test: test_disks(11, 43): faila=3D 11(D)  failb=3D 43(D=
)  OK
[   20.809692] raid6test: test_disks(11, 44): faila=3D 11(D)  failb=3D 44(D=
)  OK
[   20.810573] raid6test: test_disks(11, 45): faila=3D 11(D)  failb=3D 45(D=
)  OK
[   20.811454] raid6test: test_disks(11, 46): faila=3D 11(D)  failb=3D 46(D=
)  OK
[   20.812326] raid6test: test_disks(11, 47): faila=3D 11(D)  failb=3D 47(D=
)  OK
[   20.813207] raid6test: test_disks(11, 48): faila=3D 11(D)  failb=3D 48(D=
)  OK
[   20.814086] raid6test: test_disks(11, 49): faila=3D 11(D)  failb=3D 49(D=
)  OK
[   20.814962] raid6test: test_disks(11, 50): faila=3D 11(D)  failb=3D 50(D=
)  OK
[   20.815850] raid6test: test_disks(11, 51): faila=3D 11(D)  failb=3D 51(D=
)  OK
[   20.816724] raid6test: test_disks(11, 52): faila=3D 11(D)  failb=3D 52(D=
)  OK
[   20.817597] raid6test: test_disks(11, 53): faila=3D 11(D)  failb=3D 53(D=
)  OK
[   20.818473] raid6test: test_disks(11, 54): faila=3D 11(D)  failb=3D 54(D=
)  OK
[   20.819356] raid6test: test_disks(11, 55): faila=3D 11(D)  failb=3D 55(D=
)  OK
[   20.820236] raid6test: test_disks(11, 56): faila=3D 11(D)  failb=3D 56(D=
)  OK
[   20.821111] raid6test: test_disks(11, 57): faila=3D 11(D)  failb=3D 57(D=
)  OK
[   20.821989] raid6test: test_disks(11, 58): faila=3D 11(D)  failb=3D 58(D=
)  OK
[   20.822873] raid6test: test_disks(11, 59): faila=3D 11(D)  failb=3D 59(D=
)  OK
[   20.823750] raid6test: test_disks(11, 60): faila=3D 11(D)  failb=3D 60(D=
)  OK
[   20.824628] raid6test: test_disks(11, 61): faila=3D 11(D)  failb=3D 61(D=
)  OK
[   20.825494] raid6test: test_disks(11, 62): faila=3D 11(D)  failb=3D 62(P=
)  OK
[   20.826367] raid6test: test_disks(11, 63): faila=3D 11(D)  failb=3D 63(Q=
)  OK
[   20.827243] raid6test: test_disks(12, 13): faila=3D 12(D)  failb=3D 13(D=
)  OK
[   20.828121] raid6test: test_disks(12, 14): faila=3D 12(D)  failb=3D 14(D=
)  OK
[   20.829007] raid6test: test_disks(12, 15): faila=3D 12(D)  failb=3D 15(D=
)  OK
[   20.829880] raid6test: test_disks(12, 16): faila=3D 12(D)  failb=3D 16(D=
)  OK
[   20.830751] raid6test: test_disks(12, 17): faila=3D 12(D)  failb=3D 17(D=
)  OK
[   20.831629] raid6test: test_disks(12, 18): faila=3D 12(D)  failb=3D 18(D=
)  OK
[   20.832526] raid6test: test_disks(12, 19): faila=3D 12(D)  failb=3D 19(D=
)  OK
[   20.833395] raid6test: test_disks(12, 20): faila=3D 12(D)  failb=3D 20(D=
)  OK
[   20.834265] raid6test: test_disks(12, 21): faila=3D 12(D)  failb=3D 21(D=
)  OK
[   20.835142] raid6test: test_disks(12, 22): faila=3D 12(D)  failb=3D 22(D=
)  OK
[   20.836028] raid6test: test_disks(12, 23): faila=3D 12(D)  failb=3D 23(D=
)  OK
[   20.836907] raid6test: test_disks(12, 24): faila=3D 12(D)  failb=3D 24(D=
)  OK
[   20.837781] raid6test: test_disks(12, 25): faila=3D 12(D)  failb=3D 25(D=
)  OK
[   20.838657] raid6test: test_disks(12, 26): faila=3D 12(D)  failb=3D 26(D=
)  OK
[   20.839538] raid6test: test_disks(12, 27): faila=3D 12(D)  failb=3D 27(D=
)  OK
[   20.840413] raid6test: test_disks(12, 28): faila=3D 12(D)  failb=3D 28(D=
)  OK
[   20.841278] raid6test: test_disks(12, 29): faila=3D 12(D)  failb=3D 29(D=
)  OK
[   20.842153] raid6test: test_disks(12, 30): faila=3D 12(D)  failb=3D 30(D=
)  OK
[   20.843039] raid6test: test_disks(12, 31): faila=3D 12(D)  failb=3D 31(D=
)  OK
[   20.843917] raid6test: test_disks(12, 32): faila=3D 12(D)  failb=3D 32(D=
)  OK
[   20.844792] raid6test: test_disks(12, 33): faila=3D 12(D)  failb=3D 33(D=
)  OK
[   20.845686] raid6test: test_disks(12, 34): faila=3D 12(D)  failb=3D 34(D=
)  OK
[   20.846559] raid6test: test_disks(12, 35): faila=3D 12(D)  failb=3D 35(D=
)  OK
[   20.847426] raid6test: test_disks(12, 36): faila=3D 12(D)  failb=3D 36(D=
)  OK
[   20.848299] raid6test: test_disks(12, 37): faila=3D 12(D)  failb=3D 37(D=
)  OK
[   20.849182] raid6test: test_disks(12, 38): faila=3D 12(D)  failb=3D 38(D=
)  OK
[   20.850059] raid6test: test_disks(12, 39): faila=3D 12(D)  failb=3D 39(D=
)  OK
[   20.850930] raid6test: test_disks(12, 40): faila=3D 12(D)  failb=3D 40(D=
)  OK
[   20.851809] raid6test: test_disks(12, 41): faila=3D 12(D)  failb=3D 41(D=
)  OK
[   20.865717] raid6test: test_disks(12, 42): faila=3D 12(D)  failb=3D 42(D=
)  OK
[   20.866601] raid6test: test_disks(12, 43): faila=3D 12(D)  failb=3D 43(D=
)  OK
[   20.867474] raid6test: test_disks(12, 44): faila=3D 12(D)  failb=3D 44(D=
)  OK
[   20.868341] raid6test: test_disks(12, 45): faila=3D 12(D)  failb=3D 45(D=
)  OK
[   20.869222] raid6test: test_disks(12, 46): faila=3D 12(D)  failb=3D 46(D=
)  OK
[   20.870097] raid6test: test_disks(12, 47): faila=3D 12(D)  failb=3D 47(D=
)  OK
[   20.870972] raid6test: test_disks(12, 48): faila=3D 12(D)  failb=3D 48(D=
)  OK
[   20.871846] raid6test: test_disks(12, 49): faila=3D 12(D)  failb=3D 49(D=
)  OK
[   20.872729] raid6test: test_disks(12, 50): faila=3D 12(D)  failb=3D 50(D=
)  OK
[   20.873606] raid6test: test_disks(12, 51): faila=3D 12(D)  failb=3D 51(D=
)  OK
[   20.874480] raid6test: test_disks(12, 52): faila=3D 12(D)  failb=3D 52(D=
)  OK
[   20.875350] raid6test: test_disks(12, 53): faila=3D 12(D)  failb=3D 53(D=
)  OK
[   20.876238] raid6test: test_disks(12, 54): faila=3D 12(D)  failb=3D 54(D=
)  OK
[   20.877118] raid6test: test_disks(12, 55): faila=3D 12(D)  failb=3D 55(D=
)  OK
[   20.877995] raid6test: test_disks(12, 56): faila=3D 12(D)  failb=3D 56(D=
)  OK
[   20.891882] raid6test: test_disks(12, 57): faila=3D 12(D)  failb=3D 57(D=
)  OK
[   20.892775] raid6test: test_disks(12, 58): faila=3D 12(D)  failb=3D 58(D=
)  OK
[   20.893659] raid6test: test_disks(12, 59): faila=3D 12(D)  failb=3D 59(D=
)  OK
[   20.894561] raid6test: test_disks(12, 60): faila=3D 12(D)  failb=3D 60(D=
)  OK
[   20.895435] raid6test: test_disks(12, 61): faila=3D 12(D)  failb=3D 61(D=
)  OK
[   20.896308] raid6test: test_disks(12, 62): faila=3D 12(D)  failb=3D 62(P=
)  OK
[   20.897182] raid6test: test_disks(12, 63): faila=3D 12(D)  failb=3D 63(Q=
)  OK
[   20.898059] raid6test: test_disks(13, 14): faila=3D 13(D)  failb=3D 14(D=
)  OK
[   20.898941] raid6test: test_disks(13, 15): faila=3D 13(D)  failb=3D 15(D=
)  OK
[   20.899827] raid6test: test_disks(13, 16): faila=3D 13(D)  failb=3D 16(D=
)  OK
[   20.900705] raid6test: test_disks(13, 17): faila=3D 13(D)  failb=3D 17(D=
)  OK
[   20.901581] raid6test: test_disks(13, 18): faila=3D 13(D)  failb=3D 18(D=
)  OK
[   20.902465] raid6test: test_disks(13, 19): faila=3D 13(D)  failb=3D 19(D=
)  OK
[   20.903336] raid6test: test_disks(13, 20): faila=3D 13(D)  failb=3D 20(D=
)  OK
[   20.904215] raid6test: test_disks(13, 21): faila=3D 13(D)  failb=3D 21(D=
)  OK
[   20.905091] raid6test: test_disks(13, 22): faila=3D 13(D)  failb=3D 22(D=
)  OK
[   20.905980] raid6test: test_disks(13, 23): faila=3D 13(D)  failb=3D 23(D=
)  OK
[   20.906861] raid6test: test_disks(13, 24): faila=3D 13(D)  failb=3D 24(D=
)  OK
[   20.920752] raid6test: test_disks(13, 25): faila=3D 13(D)  failb=3D 25(D=
)  OK
[   20.921628] raid6test: test_disks(13, 26): faila=3D 13(D)  failb=3D 26(D=
)  OK
[   20.922509] raid6test: test_disks(13, 27): faila=3D 13(D)  failb=3D 27(D=
)  OK
[   20.923376] raid6test: test_disks(13, 28): faila=3D 13(D)  failb=3D 28(D=
)  OK
[   20.924246] raid6test: test_disks(13, 29): faila=3D 13(D)  failb=3D 29(D=
)  OK
[   20.925120] raid6test: test_disks(13, 30): faila=3D 13(D)  failb=3D 30(D=
)  OK
[   20.926032] raid6test: test_disks(13, 31): faila=3D 13(D)  failb=3D 31(D=
)  OK
[   20.926910] raid6test: test_disks(13, 32): faila=3D 13(D)  failb=3D 32(D=
)  OK
[   20.927782] raid6test: test_disks(13, 33): faila=3D 13(D)  failb=3D 33(D=
)  OK
[   20.928657] raid6test: test_disks(13, 34): faila=3D 13(D)  failb=3D 34(D=
)  OK
[   20.929542] raid6test: test_disks(13, 35): faila=3D 13(D)  failb=3D 35(D=
)  OK
[   20.930419] raid6test: test_disks(13, 36): faila=3D 13(D)  failb=3D 36(D=
)  OK
[   20.931285] raid6test: test_disks(13, 37): faila=3D 13(D)  failb=3D 37(D=
)  OK
[   20.932160] raid6test: test_disks(13, 38): faila=3D 13(D)  failb=3D 38(D=
)  OK
[   20.933050] raid6test: test_disks(13, 39): faila=3D 13(D)  failb=3D 39(D=
)  OK
[   20.933923] raid6test: test_disks(13, 40): faila=3D 13(D)  failb=3D 40(D=
)  OK
[   20.934798] raid6test: test_disks(13, 41): faila=3D 13(D)  failb=3D 41(D=
)  OK
[   20.935695] raid6test: test_disks(13, 42): faila=3D 13(D)  failb=3D 42(D=
)  OK
[   20.936575] raid6test: test_disks(13, 43): faila=3D 13(D)  failb=3D 43(D=
)  OK
[   20.937447] raid6test: test_disks(13, 44): faila=3D 13(D)  failb=3D 44(D=
)  OK
[   20.938311] raid6test: test_disks(13, 45): faila=3D 13(D)  failb=3D 45(D=
)  OK
[   20.952195] raid6test: test_disks(13, 46): faila=3D 13(D)  failb=3D 46(D=
)  OK
[   20.953074] raid6test: test_disks(13, 47): faila=3D 13(D)  failb=3D 47(D=
)  OK
[   20.953949] raid6test: test_disks(13, 48): faila=3D 13(D)  failb=3D 48(D=
)  OK
[   20.954823] raid6test: test_disks(13, 49): faila=3D 13(D)  failb=3D 49(D=
)  OK
[   20.955718] raid6test: test_disks(13, 50): faila=3D 13(D)  failb=3D 50(D=
)  OK
[   20.969610] raid6test: test_disks(13, 51): faila=3D 13(D)  failb=3D 51(D=
)  OK
[   20.970487] raid6test: test_disks(13, 52): faila=3D 13(D)  failb=3D 52(D=
)  OK
[   20.971356] raid6test: test_disks(13, 53): faila=3D 13(D)  failb=3D 53(D=
)  OK
[   20.972232] raid6test: test_disks(13, 54): faila=3D 13(D)  failb=3D 54(D=
)  OK
[   20.973123] raid6test: test_disks(13, 55): faila=3D 13(D)  failb=3D 55(D=
)  OK
[   20.974001] raid6test: test_disks(13, 56): faila=3D 13(D)  failb=3D 56(D=
)  OK
[   20.974880] raid6test: test_disks(13, 57): faila=3D 13(D)  failb=3D 57(D=
)  OK
[   20.975774] raid6test: test_disks(13, 58): faila=3D 13(D)  failb=3D 58(D=
)  OK
[   20.976655] raid6test: test_disks(13, 59): faila=3D 13(D)  failb=3D 59(D=
)  OK
[   20.977527] raid6test: test_disks(13, 60): faila=3D 13(D)  failb=3D 60(D=
)  OK
[   20.978404] raid6test: test_disks(13, 61): faila=3D 13(D)  failb=3D 61(D=
)  OK
[   20.979272] raid6test: test_disks(13, 62): faila=3D 13(D)  failb=3D 62(P=
)  OK
[   20.980142] raid6test: test_disks(13, 63): faila=3D 13(D)  failb=3D 63(Q=
)  OK
[   20.981020] raid6test: test_disks(14, 15): faila=3D 14(D)  failb=3D 15(D=
)  OK
[   20.981899] raid6test: test_disks(14, 16): faila=3D 14(D)  failb=3D 16(D=
)  OK
[   20.995804] raid6test: test_disks(14, 17): faila=3D 14(D)  failb=3D 17(D=
)  OK
[   20.996682] raid6test: test_disks(14, 18): faila=3D 14(D)  failb=3D 18(D=
)  OK
[   20.997558] raid6test: test_disks(14, 19): faila=3D 14(D)  failb=3D 19(D=
)  OK
[   20.998434] raid6test: test_disks(14, 20): faila=3D 14(D)  failb=3D 20(D=
)  OK
[   20.999312] raid6test: test_disks(14, 21): faila=3D 14(D)  failb=3D 21(D=
)  OK
[   21.000185] raid6test: test_disks(14, 22): faila=3D 14(D)  failb=3D 22(D=
)  OK
[   21.001064] raid6test: test_disks(14, 23): faila=3D 14(D)  failb=3D 23(D=
)  OK
[   21.001941] raid6test: test_disks(14, 24): faila=3D 14(D)  failb=3D 24(D=
)  OK
[   21.002826] raid6test: test_disks(14, 25): faila=3D 14(D)  failb=3D 25(D=
)  OK
[   21.003705] raid6test: test_disks(14, 26): faila=3D 14(D)  failb=3D 26(D=
)  OK
[   21.004581] raid6test: test_disks(14, 27): faila=3D 14(D)  failb=3D 27(D=
)  OK
[   21.005451] raid6test: test_disks(14, 28): faila=3D 14(D)  failb=3D 28(D=
)  OK
[   21.006326] raid6test: test_disks(14, 29): faila=3D 14(D)  failb=3D 29(D=
)  OK
[   21.007211] raid6test: test_disks(14, 30): faila=3D 14(D)  failb=3D 30(D=
)  OK
[   21.008085] raid6test: test_disks(14, 31): faila=3D 14(D)  failb=3D 31(D=
)  OK
[   21.021971] raid6test: test_disks(14, 32): faila=3D 14(D)  failb=3D 32(D=
)  OK
[   21.022855] raid6test: test_disks(14, 33): faila=3D 14(D)  failb=3D 33(D=
)  OK
[   21.023732] raid6test: test_disks(14, 34): faila=3D 14(D)  failb=3D 34(D=
)  OK
[   21.024608] raid6test: test_disks(14, 35): faila=3D 14(D)  failb=3D 35(D=
)  OK
[   21.025479] raid6test: test_disks(14, 36): faila=3D 14(D)  failb=3D 36(D=
)  OK
[   21.026364] raid6test: test_disks(14, 37): faila=3D 14(D)  failb=3D 37(D=
)  OK
[   21.027243] raid6test: test_disks(14, 38): faila=3D 14(D)  failb=3D 38(D=
)  OK
[   21.028120] raid6test: test_disks(14, 39): faila=3D 14(D)  failb=3D 39(D=
)  OK
[   21.029006] raid6test: test_disks(14, 40): faila=3D 14(D)  failb=3D 40(D=
)  OK
[   21.029882] raid6test: test_disks(14, 41): faila=3D 14(D)  failb=3D 41(D=
)  OK
[   21.030754] raid6test: test_disks(14, 42): faila=3D 14(D)  failb=3D 42(D=
)  OK
[   21.031630] raid6test: test_disks(14, 43): faila=3D 14(D)  failb=3D 43(D=
)  OK
[   21.032517] raid6test: test_disks(14, 44): faila=3D 14(D)  failb=3D 44(D=
)  OK
[   21.033391] raid6test: test_disks(14, 45): faila=3D 14(D)  failb=3D 45(D=
)  OK
[   21.034268] raid6test: test_disks(14, 46): faila=3D 14(D)  failb=3D 46(D=
)  OK
[   21.048157] raid6test: test_disks(14, 47): faila=3D 14(D)  failb=3D 47(D=
)  OK
[   21.049056] raid6test: test_disks(14, 48): faila=3D 14(D)  failb=3D 48(D=
)  OK
[   21.049933] raid6test: test_disks(14, 49): faila=3D 14(D)  failb=3D 49(D=
)  OK
[   21.050812] raid6test: test_disks(14, 50): faila=3D 14(D)  failb=3D 50(D=
)  OK
[   21.051692] raid6test: test_disks(14, 51): faila=3D 14(D)  failb=3D 51(D=
)  OK
[   21.052582] raid6test: test_disks(14, 52): faila=3D 14(D)  failb=3D 52(D=
)  OK
[   21.053465] raid6test: test_disks(14, 53): faila=3D 14(D)  failb=3D 53(D=
)  OK
[   21.054334] raid6test: test_disks(14, 54): faila=3D 14(D)  failb=3D 54(D=
)  OK
[   21.055213] raid6test: test_disks(14, 55): faila=3D 14(D)  failb=3D 55(D=
)  OK
[   21.056105] raid6test: test_disks(14, 56): faila=3D 14(D)  failb=3D 56(D=
)  OK
[   21.056985] raid6test: test_disks(14, 57): faila=3D 14(D)  failb=3D 57(D=
)  OK
[   21.057860] raid6test: test_disks(14, 58): faila=3D 14(D)  failb=3D 58(D=
)  OK
[   21.058737] raid6test: test_disks(14, 59): faila=3D 14(D)  failb=3D 59(D=
)  OK
[   21.059622] raid6test: test_disks(14, 60): faila=3D 14(D)  failb=3D 60(D=
)  OK
[   21.062528] raid6test: test_disks(14, 61): faila=3D 14(D)  failb=3D 61(D=
)  OK
[   21.063386] raid6test: test_disks(14, 62): faila=3D 14(D)  failb=3D 62(P=
)  OK
[   21.064245] raid6test: test_disks(14, 63): faila=3D 14(D)  failb=3D 63(Q=
)  OK
[   21.065115] raid6test: test_disks(15, 16): faila=3D 15(D)  failb=3D 16(D=
)  OK
[   21.066005] raid6test: test_disks(15, 17): faila=3D 15(D)  failb=3D 17(D=
)  OK
[   21.066885] raid6test: test_disks(15, 18): faila=3D 15(D)  failb=3D 18(D=
)  OK
[   21.067759] raid6test: test_disks(15, 19): faila=3D 15(D)  failb=3D 19(D=
)  OK
[   21.068635] raid6test: test_disks(15, 20): faila=3D 15(D)  failb=3D 20(D=
)  OK
[   21.069524] raid6test: test_disks(15, 21): faila=3D 15(D)  failb=3D 21(D=
)  OK
[   21.070396] raid6test: test_disks(15, 22): faila=3D 15(D)  failb=3D 22(D=
)  OK
[   21.071272] raid6test: test_disks(15, 23): faila=3D 15(D)  failb=3D 23(D=
)  OK
[   21.072150] raid6test: test_disks(15, 24): faila=3D 15(D)  failb=3D 24(D=
)  OK
[   21.073034] raid6test: test_disks(15, 25): faila=3D 15(D)  failb=3D 25(D=
)  OK
[   21.073911] raid6test: test_disks(15, 26): faila=3D 15(D)  failb=3D 26(D=
)  OK
[   21.074788] raid6test: test_disks(15, 27): faila=3D 15(D)  failb=3D 27(D=
)  OK
[   21.088679] raid6test: test_disks(15, 28): faila=3D 15(D)  failb=3D 28(D=
)  OK
[   21.089571] raid6test: test_disks(15, 29): faila=3D 15(D)  failb=3D 29(D=
)  OK
[   21.090439] raid6test: test_disks(15, 30): faila=3D 15(D)  failb=3D 30(D=
)  OK
[   21.091305] raid6test: test_disks(15, 31): faila=3D 15(D)  failb=3D 31(D=
)  OK
[   21.092176] raid6test: test_disks(15, 32): faila=3D 15(D)  failb=3D 32(D=
)  OK
[   21.093065] raid6test: test_disks(15, 33): faila=3D 15(D)  failb=3D 33(D=
)  OK
[   21.093942] raid6test: test_disks(15, 34): faila=3D 15(D)  failb=3D 34(D=
)  OK
[   21.094818] raid6test: test_disks(15, 35): faila=3D 15(D)  failb=3D 35(D=
)  OK
[   21.095715] raid6test: test_disks(15, 36): faila=3D 15(D)  failb=3D 36(D=
)  OK
[   21.096593] raid6test: test_disks(15, 37): faila=3D 15(D)  failb=3D 37(D=
)  OK
[   21.097467] raid6test: test_disks(15, 38): faila=3D 15(D)  failb=3D 38(D=
)  OK
[   21.098336] raid6test: test_disks(15, 39): faila=3D 15(D)  failb=3D 39(D=
)  OK
[   21.099216] raid6test: test_disks(15, 40): faila=3D 15(D)  failb=3D 40(D=
)  OK
[   21.100089] raid6test: test_disks(15, 41): faila=3D 15(D)  failb=3D 41(D=
)  OK
[   21.100958] raid6test: test_disks(15, 42): faila=3D 15(D)  failb=3D 42(D=
)  OK
[   21.114850] raid6test: test_disks(15, 43): faila=3D 15(D)  failb=3D 43(D=
)  OK
[   21.115745] raid6test: test_disks(15, 44): faila=3D 15(D)  failb=3D 44(D=
)  OK
[   21.116619] raid6test: test_disks(15, 45): faila=3D 15(D)  failb=3D 45(D=
)  OK
[   21.117491] raid6test: test_disks(15, 46): faila=3D 15(D)  failb=3D 46(D=
)  OK
[   21.118359] raid6test: test_disks(15, 47): faila=3D 15(D)  failb=3D 47(D=
)  OK
[   21.119238] raid6test: test_disks(15, 48): faila=3D 15(D)  failb=3D 48(D=
)  OK
[   21.120113] raid6test: test_disks(15, 49): faila=3D 15(D)  failb=3D 49(D=
)  OK
[   21.120990] raid6test: test_disks(15, 50): faila=3D 15(D)  failb=3D 50(D=
)  OK
[   21.121865] raid6test: test_disks(15, 51): faila=3D 15(D)  failb=3D 51(D=
)  OK
[   21.122754] raid6test: test_disks(15, 52): faila=3D 15(D)  failb=3D 52(D=
)  OK
[   21.123630] raid6test: test_disks(15, 53): faila=3D 15(D)  failb=3D 53(D=
)  OK
[   21.124506] raid6test: test_disks(15, 54): faila=3D 15(D)  failb=3D 54(D=
)  OK
[   21.125372] raid6test: test_disks(15, 55): faila=3D 15(D)  failb=3D 55(D=
)  OK
[   21.126255] raid6test: test_disks(15, 56): faila=3D 15(D)  failb=3D 56(D=
)  OK
[   21.127130] raid6test: test_disks(15, 57): faila=3D 15(D)  failb=3D 57(D=
)  OK
[   21.141017] raid6test: test_disks(15, 58): faila=3D 15(D)  failb=3D 58(D=
)  OK
[   21.141898] raid6test: test_disks(15, 59): faila=3D 15(D)  failb=3D 59(D=
)  OK
[   21.142786] raid6test: test_disks(15, 60): faila=3D 15(D)  failb=3D 60(D=
)  OK
[   21.143659] raid6test: test_disks(15, 61): faila=3D 15(D)  failb=3D 61(D=
)  OK
[   21.144526] raid6test: test_disks(15, 62): faila=3D 15(D)  failb=3D 62(P=
)  OK
[   21.145392] raid6test: test_disks(15, 63): faila=3D 15(D)  failb=3D 63(Q=
)  OK
[   21.146282] raid6test: test_disks(16, 17): faila=3D 16(D)  failb=3D 17(D=
)  OK
[   21.147166] raid6test: test_disks(16, 18): faila=3D 16(D)  failb=3D 18(D=
)  OK
[   21.148042] raid6test: test_disks(16, 19): faila=3D 16(D)  failb=3D 19(D=
)  OK
[   21.148918] raid6test: test_disks(16, 20): faila=3D 16(D)  failb=3D 20(D=
)  OK
[   21.149807] raid6test: test_disks(16, 21): faila=3D 16(D)  failb=3D 21(D=
)  OK
[   21.150689] raid6test: test_disks(16, 22): faila=3D 16(D)  failb=3D 22(D=
)  OK
[   21.151564] raid6test: test_disks(16, 23): faila=3D 16(D)  failb=3D 23(D=
)  OK
[   21.152451] raid6test: test_disks(16, 24): faila=3D 16(D)  failb=3D 24(D=
)  OK
[   21.153323] raid6test: test_disks(16, 25): faila=3D 16(D)  failb=3D 25(D=
)  OK
[   21.167214] raid6test: test_disks(16, 26): faila=3D 16(D)  failb=3D 26(D=
)  OK
[   21.168098] raid6test: test_disks(16, 27): faila=3D 16(D)  failb=3D 27(D=
)  OK
[   21.168977] raid6test: test_disks(16, 28): faila=3D 16(D)  failb=3D 28(D=
)  OK
[   21.169861] raid6test: test_disks(16, 29): faila=3D 16(D)  failb=3D 29(D=
)  OK
[   21.170738] raid6test: test_disks(16, 30): faila=3D 16(D)  failb=3D 30(D=
)  OK
[   21.171618] raid6test: test_disks(16, 31): faila=3D 16(D)  failb=3D 31(D=
)  OK
[   21.172501] raid6test: test_disks(16, 32): faila=3D 16(D)  failb=3D 32(D=
)  OK
[   21.173371] raid6test: test_disks(16, 33): faila=3D 16(D)  failb=3D 33(D=
)  OK
[   21.174245] raid6test: test_disks(16, 34): faila=3D 16(D)  failb=3D 34(D=
)  OK
[   21.175125] raid6test: test_disks(16, 35): faila=3D 16(D)  failb=3D 35(D=
)  OK
[   21.176014] raid6test: test_disks(16, 36): faila=3D 16(D)  failb=3D 36(D=
)  OK
[   21.176897] raid6test: test_disks(16, 37): faila=3D 16(D)  failb=3D 37(D=
)  OK
[   21.177778] raid6test: test_disks(16, 38): faila=3D 16(D)  failb=3D 38(D=
)  OK
[   21.178658] raid6test: test_disks(16, 39): faila=3D 16(D)  failb=3D 39(D=
)  OK
[   21.192549] raid6test: test_disks(16, 40): faila=3D 16(D)  failb=3D 40(D=
)  OK
[   21.193428] raid6test: test_disks(16, 41): faila=3D 16(D)  failb=3D 41(D=
)  OK
[   21.194297] raid6test: test_disks(16, 42): faila=3D 16(D)  failb=3D 42(D=
)  OK
[   21.195170] raid6test: test_disks(16, 43): faila=3D 16(D)  failb=3D 43(D=
)  OK
[   21.196058] raid6test: test_disks(16, 44): faila=3D 16(D)  failb=3D 44(D=
)  OK
[   21.196934] raid6test: test_disks(16, 45): faila=3D 16(D)  failb=3D 45(D=
)  OK
[   21.197806] raid6test: test_disks(16, 46): faila=3D 16(D)  failb=3D 46(D=
)  OK
[   21.198678] raid6test: test_disks(16, 47): faila=3D 16(D)  failb=3D 47(D=
)  OK
[   21.199564] raid6test: test_disks(16, 48): faila=3D 16(D)  failb=3D 48(D=
)  OK
[   21.200438] raid6test: test_disks(16, 49): faila=3D 16(D)  failb=3D 49(D=
)  OK
[   21.201304] raid6test: test_disks(16, 50): faila=3D 16(D)  failb=3D 50(D=
)  OK
[   21.215993] raid6test: test_disks(16, 51): faila=3D 16(D)  failb=3D 51(D=
)  OK
[   21.216872] raid6test: test_disks(16, 52): faila=3D 16(D)  failb=3D 52(D=
)  OK
[   21.217748] raid6test: test_disks(16, 53): faila=3D 16(D)  failb=3D 53(D=
)  OK
[   21.218628] raid6test: test_disks(16, 54): faila=3D 16(D)  failb=3D 54(D=
)  OK
[   21.219523] raid6test: test_disks(16, 55): faila=3D 16(D)  failb=3D 55(D=
)  OK
[   21.220393] raid6test: test_disks(16, 56): faila=3D 16(D)  failb=3D 56(D=
)  OK
[   21.221271] raid6test: test_disks(16, 57): faila=3D 16(D)  failb=3D 57(D=
)  OK
[   21.222153] raid6test: test_disks(16, 58): faila=3D 16(D)  failb=3D 58(D=
)  OK
[   21.223038] raid6test: test_disks(16, 59): faila=3D 16(D)  failb=3D 59(D=
)  OK
[   21.223910] raid6test: test_disks(16, 60): faila=3D 16(D)  failb=3D 60(D=
)  OK
[   21.224784] raid6test: test_disks(16, 61): faila=3D 16(D)  failb=3D 61(D=
)  OK
[   21.225650] raid6test: test_disks(16, 62): faila=3D 16(D)  failb=3D 62(P=
)  OK
[   21.226526] raid6test: test_disks(16, 63): faila=3D 16(D)  failb=3D 63(Q=
)  OK
[   21.227390] raid6test: test_disks(17, 18): faila=3D 17(D)  failb=3D 18(D=
)  OK
[   21.237279] raid6test: test_disks(17, 19): faila=3D 17(D)  failb=3D 19(D=
)  OK
[   21.238160] raid6test: test_disks(17, 20): faila=3D 17(D)  failb=3D 20(D=
)  OK
[   21.239050] raid6test: test_disks(17, 21): faila=3D 17(D)  failb=3D 21(D=
)  OK
[   21.239920] raid6test: test_disks(17, 22): faila=3D 17(D)  failb=3D 22(D=
)  OK
[   21.240791] raid6test: test_disks(17, 23): faila=3D 17(D)  failb=3D 23(D=
)  OK
[   21.241664] raid6test: test_disks(17, 24): faila=3D 17(D)  failb=3D 24(D=
)  OK
[   21.242542] raid6test: test_disks(17, 25): faila=3D 17(D)  failb=3D 25(D=
)  OK
[   21.243417] raid6test: test_disks(17, 26): faila=3D 17(D)  failb=3D 26(D=
)  OK
[   21.244287] raid6test: test_disks(17, 27): faila=3D 17(D)  failb=3D 27(D=
)  OK
[   21.245164] raid6test: test_disks(17, 28): faila=3D 17(D)  failb=3D 28(D=
)  OK
[   21.264101] raid6test: test_disks(17, 29): faila=3D 17(D)  failb=3D 29(D=
)  OK
[   21.264981] raid6test: test_disks(17, 30): faila=3D 17(D)  failb=3D 30(D=
)  OK
[   21.265862] raid6test: test_disks(17, 31): faila=3D 17(D)  failb=3D 31(D=
)  OK
[   21.266738] raid6test: test_disks(17, 32): faila=3D 17(D)  failb=3D 32(D=
)  OK
[   21.267611] raid6test: test_disks(17, 33): faila=3D 17(D)  failb=3D 33(D=
)  OK
[   21.268489] raid6test: test_disks(17, 34): faila=3D 17(D)  failb=3D 34(D=
)  OK
[   21.269373] raid6test: test_disks(17, 35): faila=3D 17(D)  failb=3D 35(D=
)  OK
[   21.270253] raid6test: test_disks(17, 36): faila=3D 17(D)  failb=3D 36(D=
)  OK
[   21.271132] raid6test: test_disks(17, 37): faila=3D 17(D)  failb=3D 37(D=
)  OK
[   21.272012] raid6test: test_disks(17, 38): faila=3D 17(D)  failb=3D 38(D=
)  OK
[   21.286923] raid6test: test_disks(17, 39): faila=3D 17(D)  failb=3D 39(D=
)  OK
[   21.287797] raid6test: test_disks(17, 40): faila=3D 17(D)  failb=3D 40(D=
)  OK
[   21.288680] raid6test: test_disks(17, 41): faila=3D 17(D)  failb=3D 41(D=
)  OK
[   21.289559] raid6test: test_disks(17, 42): faila=3D 17(D)  failb=3D 42(D=
)  OK
[   21.303263] raid6test: test_disks(17, 43): faila=3D 17(D)  failb=3D 43(D=
)  OK
[   21.304143] raid6test: test_disks(17, 44): faila=3D 17(D)  failb=3D 44(D=
)  OK
[   21.305026] raid6test: test_disks(17, 45): faila=3D 17(D)  failb=3D 45(D=
)  OK
[   21.305923] raid6test: test_disks(17, 46): faila=3D 17(D)  failb=3D 46(D=
)  OK
[   21.306803] raid6test: test_disks(17, 47): faila=3D 17(D)  failb=3D 47(D=
)  OK
[   21.307677] raid6test: test_disks(17, 48): faila=3D 17(D)  failb=3D 48(D=
)  OK
[   21.308551] raid6test: test_disks(17, 49): faila=3D 17(D)  failb=3D 49(D=
)  OK
[   21.309433] raid6test: test_disks(17, 50): faila=3D 17(D)  failb=3D 50(D=
)  OK
[   21.310304] raid6test: test_disks(17, 51): faila=3D 17(D)  failb=3D 51(D=
)  OK
[   21.311173] raid6test: test_disks(17, 52): faila=3D 17(D)  failb=3D 52(D=
)  OK
[   21.325082] raid6test: test_disks(17, 53): faila=3D 17(D)  failb=3D 53(D=
)  OK
[   21.328989] raid6test: test_disks(17, 54): faila=3D 17(D)  failb=3D 54(D=
)  OK
[   21.329882] raid6test: test_disks(17, 55): faila=3D 17(D)  failb=3D 55(D=
)  OK
[   21.330763] raid6test: test_disks(17, 56): faila=3D 17(D)  failb=3D 56(D=
)  OK
[   21.331637] raid6test: test_disks(17, 57): faila=3D 17(D)  failb=3D 57(D=
)  OK
[   21.332524] raid6test: test_disks(17, 58): faila=3D 17(D)  failb=3D 58(D=
)  OK
[   21.333394] raid6test: test_disks(17, 59): faila=3D 17(D)  failb=3D 59(D=
)  OK
[   21.334268] raid6test: test_disks(17, 60): faila=3D 17(D)  failb=3D 60(D=
)  OK
[   21.335148] raid6test: test_disks(17, 61): faila=3D 17(D)  failb=3D 61(D=
)  OK
[   21.336040] raid6test: test_disks(17, 62): faila=3D 17(D)  failb=3D 62(P=
)  OK
[   21.336941] raid6test: test_disks(17, 63): faila=3D 17(D)  failb=3D 63(Q=
)  OK
[   21.337821] raid6test: test_disks(18, 19): faila=3D 18(D)  failb=3D 19(D=
)  OK
[   21.338696] raid6test: test_disks(18, 20): faila=3D 18(D)  failb=3D 20(D=
)  OK
[   21.339587] raid6test: test_disks(18, 21): faila=3D 18(D)  failb=3D 21(D=
)  OK
[   21.340464] raid6test: test_disks(18, 22): faila=3D 18(D)  failb=3D 22(D=
)  OK
[   21.341335] raid6test: test_disks(18, 23): faila=3D 18(D)  failb=3D 23(D=
)  OK
[   21.355245] raid6test: test_disks(18, 24): faila=3D 18(D)  failb=3D 24(D=
)  OK
[   21.356141] raid6test: test_disks(18, 25): faila=3D 18(D)  failb=3D 25(D=
)  OK
[   21.357022] raid6test: test_disks(18, 26): faila=3D 18(D)  failb=3D 26(D=
)  OK
[   21.357896] raid6test: test_disks(18, 27): faila=3D 18(D)  failb=3D 27(D=
)  OK
[   21.358773] raid6test: test_disks(18, 28): faila=3D 18(D)  failb=3D 28(D=
)  OK
[   21.359654] raid6test: test_disks(18, 29): faila=3D 18(D)  failb=3D 29(D=
)  OK
[   21.360529] raid6test: test_disks(18, 30): faila=3D 18(D)  failb=3D 30(D=
)  OK
[   21.361409] raid6test: test_disks(18, 31): faila=3D 18(D)  failb=3D 31(D=
)  OK
[   21.362277] raid6test: test_disks(18, 32): faila=3D 18(D)  failb=3D 32(D=
)  OK
[   21.363162] raid6test: test_disks(18, 33): faila=3D 18(D)  failb=3D 33(D=
)  OK
[   21.364043] raid6test: test_disks(18, 34): faila=3D 18(D)  failb=3D 34(D=
)  OK
[   21.364923] raid6test: test_disks(18, 35): faila=3D 18(D)  failb=3D 35(D=
)  OK
[   21.365821] raid6test: test_disks(18, 36): faila=3D 18(D)  failb=3D 36(D=
)  OK
[   21.366697] raid6test: test_disks(18, 37): faila=3D 18(D)  failb=3D 37(D=
)  OK
[   21.380587] raid6test: test_disks(18, 38): faila=3D 18(D)  failb=3D 38(D=
)  OK
[   21.381466] raid6test: test_disks(18, 39): faila=3D 18(D)  failb=3D 39(D=
)  OK
[   21.382346] raid6test: test_disks(18, 40): faila=3D 18(D)  failb=3D 40(D=
)  OK
[   21.383223] raid6test: test_disks(18, 41): faila=3D 18(D)  failb=3D 41(D=
)  OK
[   21.384099] raid6test: test_disks(18, 42): faila=3D 18(D)  failb=3D 42(D=
)  OK
[   21.384977] raid6test: test_disks(18, 43): faila=3D 18(D)  failb=3D 43(D=
)  OK
[   21.385866] raid6test: test_disks(18, 44): faila=3D 18(D)  failb=3D 44(D=
)  OK
[   21.386749] raid6test: test_disks(18, 45): faila=3D 18(D)  failb=3D 45(D=
)  OK
[   21.387631] raid6test: test_disks(18, 46): faila=3D 18(D)  failb=3D 46(D=
)  OK
[   21.388513] raid6test: test_disks(18, 47): faila=3D 18(D)  failb=3D 47(D=
)  OK
[   21.412940] raid6test: test_disks(18, 48): faila=3D 18(D)  failb=3D 48(D=
)  OK
[   21.413845] raid6test: test_disks(18, 49): faila=3D 18(D)  failb=3D 49(D=
)  OK
[   21.414722] raid6test: test_disks(18, 50): faila=3D 18(D)  failb=3D 50(D=
)  OK
[   21.415598] raid6test: test_disks(18, 51): faila=3D 18(D)  failb=3D 51(D=
)  OK
[   21.416488] raid6test: test_disks(18, 52): faila=3D 18(D)  failb=3D 52(D=
)  OK
[   21.417362] raid6test: test_disks(18, 53): faila=3D 18(D)  failb=3D 53(D=
)  OK
[   21.418304] raid6test: test_disks(18, 54): faila=3D 18(D)  failb=3D 54(D=
)  OK
[   21.419186] raid6test: test_disks(18, 55): faila=3D 18(D)  failb=3D 55(D=
)  OK
[   21.420067] raid6test: test_disks(18, 56): faila=3D 18(D)  failb=3D 56(D=
)  OK
[   21.420939] raid6test: test_disks(18, 57): faila=3D 18(D)  failb=3D 57(D=
)  OK
[   21.421821] raid6test: test_disks(18, 58): faila=3D 18(D)  failb=3D 58(D=
)  OK
[   21.422703] raid6test: test_disks(18, 59): faila=3D 18(D)  failb=3D 59(D=
)  OK
[   21.423579] raid6test: test_disks(18, 60): faila=3D 18(D)  failb=3D 60(D=
)  OK
[   21.424454] raid6test: test_disks(18, 61): faila=3D 18(D)  failb=3D 61(D=
)  OK
[   21.425303] raid6test: test_disks(18, 62): faila=3D 18(D)  failb=3D 62(P=
)  OK
[   21.439217] raid6test: test_disks(18, 63): faila=3D 18(D)  failb=3D 63(Q=
)  OK
[   21.440094] raid6test: test_disks(19, 20): faila=3D 19(D)  failb=3D 20(D=
)  OK
[   21.440972] raid6test: test_disks(19, 21): faila=3D 19(D)  failb=3D 21(D=
)  OK
[   21.441845] raid6test: test_disks(19, 22): faila=3D 19(D)  failb=3D 22(D=
)  OK
[   21.442736] raid6test: test_disks(19, 23): faila=3D 19(D)  failb=3D 23(D=
)  OK
[   21.443639] raid6test: test_disks(19, 24): faila=3D 19(D)  failb=3D 24(D=
)  OK
[   21.461504] raid6test: test_disks(19, 25): faila=3D 19(D)  failb=3D 25(D=
)  OK
[   21.462406] raid6test: test_disks(19, 26): faila=3D 19(D)  failb=3D 26(D=
)  OK
[   21.463273] raid6test: test_disks(19, 27): faila=3D 19(D)  failb=3D 27(D=
)  OK
[   21.464149] raid6test: test_disks(19, 28): faila=3D 19(D)  failb=3D 28(D=
)  OK
[   21.465024] raid6test: test_disks(19, 29): faila=3D 19(D)  failb=3D 29(D=
)  OK
[   21.465912] raid6test: test_disks(19, 30): faila=3D 19(D)  failb=3D 30(D=
)  OK
[   21.466794] raid6test: test_disks(19, 31): faila=3D 19(D)  failb=3D 31(D=
)  OK
[   21.467670] raid6test: test_disks(19, 32): faila=3D 19(D)  failb=3D 32(D=
)  OK
[   21.468543] raid6test: test_disks(19, 33): faila=3D 19(D)  failb=3D 33(D=
)  OK
[   21.469437] raid6test: test_disks(19, 34): faila=3D 19(D)  failb=3D 34(D=
)  OK
[   21.470305] raid6test: test_disks(19, 35): faila=3D 19(D)  failb=3D 35(D=
)  OK
[   21.471183] raid6test: test_disks(19, 36): faila=3D 19(D)  failb=3D 36(D=
)  OK
[   21.472059] raid6test: test_disks(19, 37): faila=3D 19(D)  failb=3D 37(D=
)  OK
[   21.472951] raid6test: test_disks(19, 38): faila=3D 19(D)  failb=3D 38(D=
)  OK
[   21.486911] raid6test: test_disks(19, 39): faila=3D 19(D)  failb=3D 39(D=
)  OK
[   21.487788] raid6test: test_disks(19, 40): faila=3D 19(D)  failb=3D 40(D=
)  OK
[   21.488670] raid6test: test_disks(19, 41): faila=3D 19(D)  failb=3D 41(D=
)  OK
[   21.489554] raid6test: test_disks(19, 42): faila=3D 19(D)  failb=3D 42(D=
)  OK
[   21.490431] raid6test: test_disks(19, 43): faila=3D 19(D)  failb=3D 43(D=
)  OK
[   21.491297] raid6test: test_disks(19, 44): faila=3D 19(D)  failb=3D 44(D=
)  OK
[   21.492189] raid6test: test_disks(19, 45): faila=3D 19(D)  failb=3D 45(D=
)  OK
[   21.493085] raid6test: test_disks(19, 46): faila=3D 19(D)  failb=3D 46(D=
)  OK
[   21.493964] raid6test: test_disks(19, 47): faila=3D 19(D)  failb=3D 47(D=
)  OK
[   21.494842] raid6test: test_disks(19, 48): faila=3D 19(D)  failb=3D 48(D=
)  OK
[   21.495728] raid6test: test_disks(19, 49): faila=3D 19(D)  failb=3D 49(D=
)  OK
[   21.496607] raid6test: test_disks(19, 50): faila=3D 19(D)  failb=3D 50(D=
)  OK
[   21.507510] raid6test: test_disks(19, 51): faila=3D 19(D)  failb=3D 51(D=
)  OK
[   21.508394] raid6test: test_disks(19, 52): faila=3D 19(D)  failb=3D 52(D=
)  OK
[   21.509281] raid6test: test_disks(19, 53): faila=3D 19(D)  failb=3D 53(D=
)  OK
[   21.510164] raid6test: test_disks(19, 54): faila=3D 19(D)  failb=3D 54(D=
)  OK
[   21.511042] raid6test: test_disks(19, 55): faila=3D 19(D)  failb=3D 55(D=
)  OK
[   21.511923] raid6test: test_disks(19, 56): faila=3D 19(D)  failb=3D 56(D=
)  OK
[   21.512951] raid6test: test_disks(19, 57): faila=3D 19(D)  failb=3D 57(D=
)  OK
[   21.513821] raid6test: test_disks(19, 58): faila=3D 19(D)  failb=3D 58(D=
)  OK
[   21.514696] raid6test: test_disks(19, 59): faila=3D 19(D)  failb=3D 59(D=
)  OK
[   21.515568] raid6test: test_disks(19, 60): faila=3D 19(D)  failb=3D 60(D=
)  OK
[   21.528477] raid6test: test_disks(19, 61): faila=3D 19(D)  failb=3D 61(D=
)  OK
[   21.529362] raid6test: test_disks(19, 62): faila=3D 19(D)  failb=3D 62(P=
)  OK
[   21.530240] raid6test: test_disks(19, 63): faila=3D 19(D)  failb=3D 63(Q=
)  OK
[   21.531116] raid6test: test_disks(20, 21): faila=3D 20(D)  failb=3D 21(D=
)  OK
[   21.531996] raid6test: test_disks(20, 22): faila=3D 20(D)  failb=3D 22(D=
)  OK
[   21.532877] raid6test: test_disks(20, 23): faila=3D 20(D)  failb=3D 23(D=
)  OK
[   21.533755] raid6test: test_disks(20, 24): faila=3D 20(D)  failb=3D 24(D=
)  OK
[   21.534635] raid6test: test_disks(20, 25): faila=3D 20(D)  failb=3D 25(D=
)  OK
[   21.535509] raid6test: test_disks(20, 26): faila=3D 20(D)  failb=3D 26(D=
)  OK
[   21.536389] raid6test: test_disks(20, 27): faila=3D 20(D)  failb=3D 27(D=
)  OK
[   21.537268] raid6test: test_disks(20, 28): faila=3D 20(D)  failb=3D 28(D=
)  OK
[   21.547536] raid6test: test_disks(20, 29): faila=3D 20(D)  failb=3D 29(D=
)  OK
[   21.548408] raid6test: test_disks(20, 30): faila=3D 20(D)  failb=3D 30(D=
)  OK
[   21.549286] raid6test: test_disks(20, 31): faila=3D 20(D)  failb=3D 31(D=
)  OK
[   21.550170] raid6test: test_disks(20, 32): faila=3D 20(D)  failb=3D 32(D=
)  OK
[   21.551045] raid6test: test_disks(20, 33): faila=3D 20(D)  failb=3D 33(D=
)  OK
[   21.551923] raid6test: test_disks(20, 34): faila=3D 20(D)  failb=3D 34(D=
)  OK
[   21.552819] raid6test: test_disks(20, 35): faila=3D 20(D)  failb=3D 35(D=
)  OK
[   21.553699] raid6test: test_disks(20, 36): faila=3D 20(D)  failb=3D 36(D=
)  OK
[   21.554574] raid6test: test_disks(20, 37): faila=3D 20(D)  failb=3D 37(D=
)  OK
[   21.555452] raid6test: test_disks(20, 38): faila=3D 20(D)  failb=3D 38(D=
)  OK
[   21.556329] raid6test: test_disks(20, 39): faila=3D 20(D)  failb=3D 39(D=
)  OK
[   21.557212] raid6test: test_disks(20, 40): faila=3D 20(D)  failb=3D 40(D=
)  OK
[   21.558088] raid6test: test_disks(20, 41): faila=3D 20(D)  failb=3D 41(D=
)  OK
[   21.558970] raid6test: test_disks(20, 42): faila=3D 20(D)  failb=3D 42(D=
)  OK
[   21.570019] raid6test: test_disks(20, 43): faila=3D 20(D)  failb=3D 43(D=
)  OK
[   21.570895] raid6test: test_disks(20, 44): faila=3D 20(D)  failb=3D 44(D=
)  OK
[   21.571767] raid6test: test_disks(20, 45): faila=3D 20(D)  failb=3D 45(D=
)  OK
[   21.572655] raid6test: test_disks(20, 46): faila=3D 20(D)  failb=3D 46(D=
)  OK
[   21.573526] raid6test: test_disks(20, 47): faila=3D 20(D)  failb=3D 47(D=
)  OK
[   21.574392] raid6test: test_disks(20, 48): faila=3D 20(D)  failb=3D 48(D=
)  OK
[   21.575264] raid6test: test_disks(20, 49): faila=3D 20(D)  failb=3D 49(D=
)  OK
[   21.576157] raid6test: test_disks(20, 50): faila=3D 20(D)  failb=3D 50(D=
)  OK
[   21.577035] raid6test: test_disks(20, 51): faila=3D 20(D)  failb=3D 51(D=
)  OK
[   21.577906] raid6test: test_disks(20, 52): faila=3D 20(D)  failb=3D 52(D=
)  OK
[   21.578779] raid6test: test_disks(20, 53): faila=3D 20(D)  failb=3D 53(D=
)  OK
[   21.579666] raid6test: test_disks(20, 54): faila=3D 20(D)  failb=3D 54(D=
)  OK
[   21.580540] raid6test: test_disks(20, 55): faila=3D 20(D)  failb=3D 55(D=
)  OK
[   21.581413] raid6test: test_disks(20, 56): faila=3D 20(D)  failb=3D 56(D=
)  OK
[   21.582278] raid6test: test_disks(20, 57): faila=3D 20(D)  failb=3D 57(D=
)  OK
[   21.593063] raid6test: test_disks(20, 58): faila=3D 20(D)  failb=3D 58(D=
)  OK
[   21.593939] raid6test: test_disks(20, 59): faila=3D 20(D)  failb=3D 59(D=
)  OK
[   21.594809] raid6test: test_disks(20, 60): faila=3D 20(D)  failb=3D 60(D=
)  OK
[   21.595700] raid6test: test_disks(20, 61): faila=3D 20(D)  failb=3D 61(D=
)  OK
[   21.596565] raid6test: test_disks(20, 62): faila=3D 20(D)  failb=3D 62(P=
)  OK
[   21.597425] raid6test: test_disks(20, 63): faila=3D 20(D)  failb=3D 63(Q=
)  OK
[   21.598295] raid6test: test_disks(21, 22): faila=3D 21(D)  failb=3D 22(D=
)  OK
[   21.599182] raid6test: test_disks(21, 23): faila=3D 21(D)  failb=3D 23(D=
)  OK
[   21.600056] raid6test: test_disks(21, 24): faila=3D 21(D)  failb=3D 24(D=
)  OK
[   21.619985] raid6test: test_disks(21, 25): faila=3D 21(D)  failb=3D 25(D=
)  OK
[   21.620859] raid6test: test_disks(21, 26): faila=3D 21(D)  failb=3D 26(D=
)  OK
[   21.621742] raid6test: test_disks(21, 27): faila=3D 21(D)  failb=3D 27(D=
)  OK
[   21.622630] raid6test: test_disks(21, 28): faila=3D 21(D)  failb=3D 28(D=
)  OK
[   21.623509] raid6test: test_disks(21, 29): faila=3D 21(D)  failb=3D 29(D=
)  OK
[   21.624374] raid6test: test_disks(21, 30): faila=3D 21(D)  failb=3D 30(D=
)  OK
[   21.625250] raid6test: test_disks(21, 31): faila=3D 21(D)  failb=3D 31(D=
)  OK
[   21.626136] raid6test: test_disks(21, 32): faila=3D 21(D)  failb=3D 32(D=
)  OK
[   21.627014] raid6test: test_disks(21, 33): faila=3D 21(D)  failb=3D 33(D=
)  OK
[   21.627885] raid6test: test_disks(21, 34): faila=3D 21(D)  failb=3D 34(D=
)  OK
[   21.641105] raid6test: test_disks(21, 35): faila=3D 21(D)  failb=3D 35(D=
)  OK
[   21.641985] raid6test: test_disks(21, 36): faila=3D 21(D)  failb=3D 36(D=
)  OK
[   21.642866] raid6test: test_disks(21, 37): faila=3D 21(D)  failb=3D 37(D=
)  OK
[   21.643737] raid6test: test_disks(21, 38): faila=3D 21(D)  failb=3D 38(D=
)  OK
[   21.644611] raid6test: test_disks(21, 39): faila=3D 21(D)  failb=3D 39(D=
)  OK
[   21.645486] raid6test: test_disks(21, 40): faila=3D 21(D)  failb=3D 40(D=
)  OK
[   21.646365] raid6test: test_disks(21, 41): faila=3D 21(D)  failb=3D 41(D=
)  OK
[   21.647241] raid6test: test_disks(21, 42): faila=3D 21(D)  failb=3D 42(D=
)  OK
[   21.648151] raid6test: test_disks(21, 43): faila=3D 21(D)  failb=3D 43(D=
)  OK
[   21.649045] raid6test: test_disks(21, 44): faila=3D 21(D)  failb=3D 44(D=
)  OK
[   21.662094] raid6test: test_disks(21, 45): faila=3D 21(D)  failb=3D 45(D=
)  OK
[   21.665136] raid6test: test_disks(21, 46): faila=3D 21(D)  failb=3D 46(D=
)  OK
[   21.666032] raid6test: test_disks(21, 47): faila=3D 21(D)  failb=3D 47(D=
)  OK
[   21.666910] raid6test: test_disks(21, 48): faila=3D 21(D)  failb=3D 48(D=
)  OK
[   21.667787] raid6test: test_disks(21, 49): faila=3D 21(D)  failb=3D 49(D=
)  OK
[   21.668660] raid6test: test_disks(21, 50): faila=3D 21(D)  failb=3D 50(D=
)  OK
[   21.669532] raid6test: test_disks(21, 51): faila=3D 21(D)  failb=3D 51(D=
)  OK
[   21.670558] raid6test: test_disks(21, 52): faila=3D 21(D)  failb=3D 52(D=
)  OK
[   21.671476] raid6test: test_disks(21, 53): faila=3D 21(D)  failb=3D 53(D=
)  OK
[   21.672365] raid6test: test_disks(21, 54): faila=3D 21(D)  failb=3D 54(D=
)  OK
[   21.673243] raid6test: test_disks(21, 55): faila=3D 21(D)  failb=3D 55(D=
)  OK
[   21.674116] raid6test: test_disks(21, 56): faila=3D 21(D)  failb=3D 56(D=
)  OK
[   21.674993] raid6test: test_disks(21, 57): faila=3D 21(D)  failb=3D 57(D=
)  OK
[   21.675879] raid6test: test_disks(21, 58): faila=3D 21(D)  failb=3D 58(D=
)  OK
[   21.676757] raid6test: test_disks(21, 59): faila=3D 21(D)  failb=3D 59(D=
)  OK
[   21.689953] raid6test: test_disks(21, 60): faila=3D 21(D)  failb=3D 60(D=
)  OK
[   21.690835] raid6test: test_disks(21, 61): faila=3D 21(D)  failb=3D 61(D=
)  OK
[   21.691711] raid6test: test_disks(21, 62): faila=3D 21(D)  failb=3D 62(P=
)  OK
[   21.692595] raid6test: test_disks(21, 63): faila=3D 21(D)  failb=3D 63(Q=
)  OK
[   21.693477] raid6test: test_disks(22, 23): faila=3D 22(D)  failb=3D 23(D=
)  OK
[   21.694349] raid6test: test_disks(22, 24): faila=3D 22(D)  failb=3D 24(D=
)  OK
[   21.695230] raid6test: test_disks(22, 25): faila=3D 22(D)  failb=3D 25(D=
)  OK
[   21.696140] raid6test: test_disks(22, 26): faila=3D 22(D)  failb=3D 26(D=
)  OK
[   21.697022] raid6test: test_disks(22, 27): faila=3D 22(D)  failb=3D 27(D=
)  OK
[   21.697897] raid6test: test_disks(22, 28): faila=3D 22(D)  failb=3D 28(D=
)  OK
[   21.716913] raid6test: test_disks(22, 29): faila=3D 22(D)  failb=3D 29(D=
)  OK
[   21.717799] raid6test: test_disks(22, 30): faila=3D 22(D)  failb=3D 30(D=
)  OK
[   21.718685] raid6test: test_disks(22, 31): faila=3D 22(D)  failb=3D 31(D=
)  OK
[   21.719572] raid6test: test_disks(22, 32): faila=3D 22(D)  failb=3D 32(D=
)  OK
[   21.720458] raid6test: test_disks(22, 33): faila=3D 22(D)  failb=3D 33(D=
)  OK
[   21.721329] raid6test: test_disks(22, 34): faila=3D 22(D)  failb=3D 34(D=
)  OK
[   21.722432] raid6test: test_disks(22, 35): faila=3D 22(D)  failb=3D 35(D=
)  OK
[   21.723376] raid6test: test_disks(22, 36): faila=3D 22(D)  failb=3D 36(D=
)  OK
[   21.724251] raid6test: test_disks(22, 37): faila=3D 22(D)  failb=3D 37(D=
)  OK
[   21.725132] raid6test: test_disks(22, 38): faila=3D 22(D)  failb=3D 38(D=
)  OK
[   21.746176] raid6test: test_disks(22, 39): faila=3D 22(D)  failb=3D 39(D=
)  OK
[   21.747061] raid6test: test_disks(22, 40): faila=3D 22(D)  failb=3D 40(D=
)  OK
[   21.747943] raid6test: test_disks(22, 41): faila=3D 22(D)  failb=3D 41(D=
)  OK
[   21.748834] raid6test: test_disks(22, 42): faila=3D 22(D)  failb=3D 42(D=
)  OK
[   21.749719] raid6test: test_disks(22, 43): faila=3D 22(D)  failb=3D 43(D=
)  OK
[   21.750597] raid6test: test_disks(22, 44): faila=3D 22(D)  failb=3D 44(D=
)  OK
[   21.751474] raid6test: test_disks(22, 45): faila=3D 22(D)  failb=3D 45(D=
)  OK
[   21.752376] raid6test: test_disks(22, 46): faila=3D 22(D)  failb=3D 46(D=
)  OK
[   21.753255] raid6test: test_disks(22, 47): faila=3D 22(D)  failb=3D 47(D=
)  OK
[   21.754261] raid6test: test_disks(22, 48): faila=3D 22(D)  failb=3D 48(D=
)  OK
[   21.776248] raid6test: test_disks(22, 49): faila=3D 22(D)  failb=3D 49(D=
)  OK
[   21.777136] raid6test: test_disks(22, 50): faila=3D 22(D)  failb=3D 50(D=
)  OK
[   21.778028] raid6test: test_disks(22, 51): faila=3D 22(D)  failb=3D 51(D=
)  OK
[   21.778907] raid6test: test_disks(22, 52): faila=3D 22(D)  failb=3D 52(D=
)  OK
[   21.779794] raid6test: test_disks(22, 53): faila=3D 22(D)  failb=3D 53(D=
)  OK
[   21.780659] raid6test: test_disks(22, 54): faila=3D 22(D)  failb=3D 54(D=
)  OK
[   21.781543] raid6test: test_disks(22, 55): faila=3D 22(D)  failb=3D 55(D=
)  OK
[   21.782449] raid6test: test_disks(22, 56): faila=3D 22(D)  failb=3D 56(D=
)  OK
[   21.783460] raid6test: test_disks(22, 57): faila=3D 22(D)  failb=3D 57(D=
)  OK
[   21.784332] raid6test: test_disks(22, 58): faila=3D 22(D)  failb=3D 58(D=
)  OK
[   21.803459] raid6test: test_disks(22, 59): faila=3D 22(D)  failb=3D 59(D=
)  OK
[   21.804493] raid6test: test_disks(22, 60): faila=3D 22(D)  failb=3D 60(D=
)  OK
[   21.805487] raid6test: test_disks(22, 61): faila=3D 22(D)  failb=3D 61(D=
)  OK
[   21.806502] raid6test: test_disks(22, 62): faila=3D 22(D)  failb=3D 62(P=
)  OK
[   21.807494] raid6test: test_disks(22, 63): faila=3D 22(D)  failb=3D 63(Q=
)  OK
[   21.808364] raid6test: test_disks(23, 24): faila=3D 23(D)  failb=3D 24(D=
)  OK
[   21.809262] raid6test: test_disks(23, 25): faila=3D 23(D)  failb=3D 25(D=
)  OK
[   21.810143] raid6test: test_disks(23, 26): faila=3D 23(D)  failb=3D 26(D=
)  OK
[   21.811018] raid6test: test_disks(23, 27): faila=3D 23(D)  failb=3D 27(D=
)  OK
[   21.829982] raid6test: test_disks(23, 28): faila=3D 23(D)  failb=3D 28(D=
)  OK
[   21.831009] raid6test: test_disks(23, 29): faila=3D 23(D)  failb=3D 29(D=
)  OK
[   21.831947] raid6test: test_disks(23, 30): faila=3D 23(D)  failb=3D 30(D=
)  OK
[   21.832844] raid6test: test_disks(23, 31): faila=3D 23(D)  failb=3D 31(D=
)  OK
[   21.833728] raid6test: test_disks(23, 32): faila=3D 23(D)  failb=3D 32(D=
)  OK
[   21.834576] raid6test: test_disks(23, 33): faila=3D 23(D)  failb=3D 33(D=
)  OK
[   21.835463] raid6test: test_disks(23, 34): faila=3D 23(D)  failb=3D 34(D=
)  OK
[   21.836351] raid6test: test_disks(23, 35): faila=3D 23(D)  failb=3D 35(D=
)  OK
[   21.837232] raid6test: test_disks(23, 36): faila=3D 23(D)  failb=3D 36(D=
)  OK
[   21.838109] raid6test: test_disks(23, 37): faila=3D 23(D)  failb=3D 37(D=
)  OK
[   21.854089] raid6test: test_disks(23, 38): faila=3D 23(D)  failb=3D 38(D=
)  OK
[   21.854973] raid6test: test_disks(23, 39): faila=3D 23(D)  failb=3D 39(D=
)  OK
[   21.855859] raid6test: test_disks(23, 40): faila=3D 23(D)  failb=3D 40(D=
)  OK
[   21.856745] raid6test: test_disks(23, 41): faila=3D 23(D)  failb=3D 41(D=
)  OK
[   21.857783] raid6test: test_disks(23, 42): faila=3D 23(D)  failb=3D 42(D=
)  OK
[   21.869240] raid6test: test_disks(23, 43): faila=3D 23(D)  failb=3D 43(D=
)  OK
[   21.870122] raid6test: test_disks(23, 44): faila=3D 23(D)  failb=3D 44(D=
)  OK
[   21.870999] raid6test: test_disks(23, 45): faila=3D 23(D)  failb=3D 45(D=
)  OK
[   21.872022] raid6test: test_disks(23, 46): faila=3D 23(D)  failb=3D 46(D=
)  OK
[   21.883145] raid6test: test_disks(23, 47): faila=3D 23(D)  failb=3D 47(D=
)  OK
[   21.884030] raid6test: test_disks(23, 48): faila=3D 23(D)  failb=3D 48(D=
)  OK
[   21.884925] raid6test: test_disks(23, 49): faila=3D 23(D)  failb=3D 49(D=
)  OK
[   21.885830] raid6test: test_disks(23, 50): faila=3D 23(D)  failb=3D 50(D=
)  OK
[   21.899457] raid6test: test_disks(23, 51): faila=3D 23(D)  failb=3D 51(D=
)  OK
[   21.900329] raid6test: test_disks(23, 52): faila=3D 23(D)  failb=3D 52(D=
)  OK
[   21.901205] raid6test: test_disks(23, 53): faila=3D 23(D)  failb=3D 53(D=
)  OK
[   21.902086] raid6test: test_disks(23, 54): faila=3D 23(D)  failb=3D 54(D=
)  OK
[   21.913040] raid6test: test_disks(23, 55): faila=3D 23(D)  failb=3D 55(D=
)  OK
[   21.913923] raid6test: test_disks(23, 56): faila=3D 23(D)  failb=3D 56(D=
)  OK
[   21.914806] raid6test: test_disks(23, 57): faila=3D 23(D)  failb=3D 57(D=
)  OK
[   21.915696] raid6test: test_disks(23, 58): faila=3D 23(D)  failb=3D 58(D=
)  OK
[   21.929175] raid6test: test_disks(23, 59): faila=3D 23(D)  failb=3D 59(D=
)  OK
[   21.930052] raid6test: test_disks(23, 60): faila=3D 23(D)  failb=3D 60(D=
)  OK
[   21.930931] raid6test: test_disks(23, 61): faila=3D 23(D)  failb=3D 61(D=
)  OK
[   21.931803] raid6test: test_disks(23, 62): faila=3D 23(D)  failb=3D 62(P=
)  OK
[   21.941703] raid6test: test_disks(23, 63): faila=3D 23(D)  failb=3D 63(Q=
)  OK
[   21.951569] raid6test: test_disks(24, 25): faila=3D 24(D)  failb=3D 25(D=
)  OK
[   21.952466] raid6test: test_disks(24, 26): faila=3D 24(D)  failb=3D 26(D=
)  OK
[   21.953340] raid6test: test_disks(24, 27): faila=3D 24(D)  failb=3D 27(D=
)  OK
[   21.954211] raid6test: test_disks(24, 28): faila=3D 24(D)  failb=3D 28(D=
)  OK
[   21.955087] raid6test: test_disks(24, 29): faila=3D 24(D)  failb=3D 29(D=
)  OK
[   21.955972] raid6test: test_disks(24, 30): faila=3D 24(D)  failb=3D 30(D=
)  OK
[   21.956968] raid6test: test_disks(24, 31): faila=3D 24(D)  failb=3D 31(D=
)  OK
[   21.966860] raid6test: test_disks(24, 32): faila=3D 24(D)  failb=3D 32(D=
)  OK
[   21.967734] raid6test: test_disks(24, 33): faila=3D 24(D)  failb=3D 33(D=
)  OK
[   21.968606] raid6test: test_disks(24, 34): faila=3D 24(D)  failb=3D 34(D=
)  OK
[   21.969500] raid6test: test_disks(24, 35): faila=3D 24(D)  failb=3D 35(D=
)  OK
[   21.970371] raid6test: test_disks(24, 36): faila=3D 24(D)  failb=3D 36(D=
)  OK
[   21.971241] raid6test: test_disks(24, 37): faila=3D 24(D)  failb=3D 37(D=
)  OK
[   21.972115] raid6test: test_disks(24, 38): faila=3D 24(D)  failb=3D 38(D=
)  OK
[   21.973002] raid6test: test_disks(24, 39): faila=3D 24(D)  failb=3D 39(D=
)  OK
[   21.973874] raid6test: test_disks(24, 40): faila=3D 24(D)  failb=3D 40(D=
)  OK
[   21.974747] raid6test: test_disks(24, 41): faila=3D 24(D)  failb=3D 41(D=
)  OK
[   21.993645] raid6test: test_disks(24, 42): faila=3D 24(D)  failb=3D 42(D=
)  OK
[   21.994517] raid6test: test_disks(24, 43): faila=3D 24(D)  failb=3D 43(D=
)  OK
[   21.995387] raid6test: test_disks(24, 44): faila=3D 24(D)  failb=3D 44(D=
)  OK
[   21.996283] raid6test: test_disks(24, 45): faila=3D 24(D)  failb=3D 45(D=
)  OK
[   21.997165] raid6test: test_disks(24, 46): faila=3D 24(D)  failb=3D 46(D=
)  OK
[   21.998039] raid6test: test_disks(24, 47): faila=3D 24(D)  failb=3D 47(D=
)  OK
[   21.998921] raid6test: test_disks(24, 48): faila=3D 24(D)  failb=3D 48(D=
)  OK
[   21.999805] raid6test: test_disks(24, 49): faila=3D 24(D)  failb=3D 49(D=
)  OK
[   22.000677] raid6test: test_disks(24, 50): faila=3D 24(D)  failb=3D 50(D=
)  OK
[   22.001543] raid6test: test_disks(24, 51): faila=3D 24(D)  failb=3D 51(D=
)  OK
[   22.015661] raid6test: test_disks(24, 52): faila=3D 24(D)  failb=3D 52(D=
)  OK
[   22.016561] raid6test: test_disks(24, 53): faila=3D 24(D)  failb=3D 53(D=
)  OK
[   22.017443] raid6test: test_disks(24, 54): faila=3D 24(D)  failb=3D 54(D=
)  OK
[   22.018317] raid6test: test_disks(24, 55): faila=3D 24(D)  failb=3D 55(D=
)  OK
[   22.019209] raid6test: test_disks(24, 56): faila=3D 24(D)  failb=3D 56(D=
)  OK
[   22.020090] raid6test: test_disks(24, 57): faila=3D 24(D)  failb=3D 57(D=
)  OK
[   22.020975] raid6test: test_disks(24, 58): faila=3D 24(D)  failb=3D 58(D=
)  OK
[   22.021855] raid6test: test_disks(24, 59): faila=3D 24(D)  failb=3D 59(D=
)  OK
[   22.022745] raid6test: test_disks(24, 60): faila=3D 24(D)  failb=3D 60(D=
)  OK
[   22.023627] raid6test: test_disks(24, 61): faila=3D 24(D)  failb=3D 61(D=
)  OK
[   22.024485] raid6test: test_disks(24, 62): faila=3D 24(D)  failb=3D 62(P=
)  OK
[   22.025494] raid6test: test_disks(24, 63): faila=3D 24(D)  failb=3D 63(Q=
)  OK
[   22.026383] raid6test: test_disks(25, 26): faila=3D 25(D)  failb=3D 26(D=
)  OK
[   22.027266] raid6test: test_disks(25, 27): faila=3D 25(D)  failb=3D 27(D=
)  OK
[   22.028145] raid6test: test_disks(25, 28): faila=3D 25(D)  failb=3D 28(D=
)  OK
[   22.042038] raid6test: test_disks(25, 29): faila=3D 25(D)  failb=3D 29(D=
)  OK
[   22.042933] raid6test: test_disks(25, 30): faila=3D 25(D)  failb=3D 30(D=
)  OK
[   22.043822] raid6test: test_disks(25, 31): faila=3D 25(D)  failb=3D 31(D=
)  OK
[   22.044699] raid6test: test_disks(25, 32): faila=3D 25(D)  failb=3D 32(D=
)  OK
[   22.045578] raid6test: test_disks(25, 33): faila=3D 25(D)  failb=3D 33(D=
)  OK
[   22.046468] raid6test: test_disks(25, 34): faila=3D 25(D)  failb=3D 34(D=
)  OK
[   22.047342] raid6test: test_disks(25, 35): faila=3D 25(D)  failb=3D 35(D=
)  OK
[   22.048221] raid6test: test_disks(25, 36): faila=3D 25(D)  failb=3D 36(D=
)  OK
[   22.049110] raid6test: test_disks(25, 37): faila=3D 25(D)  failb=3D 37(D=
)  OK
[   22.049987] raid6test: test_disks(25, 38): faila=3D 25(D)  failb=3D 38(D=
)  OK
[   22.050869] raid6test: test_disks(25, 39): faila=3D 25(D)  failb=3D 39(D=
)  OK
[   22.051747] raid6test: test_disks(25, 40): faila=3D 25(D)  failb=3D 40(D=
)  OK
[   22.052632] raid6test: test_disks(25, 41): faila=3D 25(D)  failb=3D 41(D=
)  OK
[   22.053510] raid6test: test_disks(25, 42): faila=3D 25(D)  failb=3D 42(D=
)  OK
[   22.054380] raid6test: test_disks(25, 43): faila=3D 25(D)  failb=3D 43(D=
)  OK
[   22.055258] raid6test: test_disks(25, 44): faila=3D 25(D)  failb=3D 44(D=
)  OK
[   22.056145] raid6test: test_disks(25, 45): faila=3D 25(D)  failb=3D 45(D=
)  OK
[   22.070046] raid6test: test_disks(25, 46): faila=3D 25(D)  failb=3D 46(D=
)  OK
[   22.070930] raid6test: test_disks(25, 47): faila=3D 25(D)  failb=3D 47(D=
)  OK
[   22.071810] raid6test: test_disks(25, 48): faila=3D 25(D)  failb=3D 48(D=
)  OK
[   22.072693] raid6test: test_disks(25, 49): faila=3D 25(D)  failb=3D 49(D=
)  OK
[   22.073569] raid6test: test_disks(25, 50): faila=3D 25(D)  failb=3D 50(D=
)  OK
[   22.074443] raid6test: test_disks(25, 51): faila=3D 25(D)  failb=3D 51(D=
)  OK
[   22.075313] raid6test: test_disks(25, 52): faila=3D 25(D)  failb=3D 52(D=
)  OK
[   22.076199] raid6test: test_disks(25, 53): faila=3D 25(D)  failb=3D 53(D=
)  OK
[   22.077081] raid6test: test_disks(25, 54): faila=3D 25(D)  failb=3D 54(D=
)  OK
[   22.077964] raid6test: test_disks(25, 55): faila=3D 25(D)  failb=3D 55(D=
)  OK
[   22.096851] raid6test: test_disks(25, 56): faila=3D 25(D)  failb=3D 56(D=
)  OK
[   22.097730] raid6test: test_disks(25, 57): faila=3D 25(D)  failb=3D 57(D=
)  OK
[   22.098607] raid6test: test_disks(25, 58): faila=3D 25(D)  failb=3D 58(D=
)  OK
[   22.099503] raid6test: test_disks(25, 59): faila=3D 25(D)  failb=3D 59(D=
)  OK
[   22.100376] raid6test: test_disks(25, 60): faila=3D 25(D)  failb=3D 60(D=
)  OK
[   22.101250] raid6test: test_disks(25, 61): faila=3D 25(D)  failb=3D 61(D=
)  OK
[   22.102123] raid6test: test_disks(25, 62): faila=3D 25(D)  failb=3D 62(P=
)  OK
[   22.103011] raid6test: test_disks(25, 63): faila=3D 25(D)  failb=3D 63(Q=
)  OK
[   22.103890] raid6test: test_disks(26, 27): faila=3D 26(D)  failb=3D 27(D=
)  OK
[   22.104765] raid6test: test_disks(26, 28): faila=3D 26(D)  failb=3D 28(D=
)  OK
[   22.123651] raid6test: test_disks(26, 29): faila=3D 26(D)  failb=3D 29(D=
)  OK
[   22.124530] raid6test: test_disks(26, 30): faila=3D 26(D)  failb=3D 30(D=
)  OK
[   22.125406] raid6test: test_disks(26, 31): faila=3D 26(D)  failb=3D 31(D=
)  OK
[   22.126282] raid6test: test_disks(26, 32): faila=3D 26(D)  failb=3D 32(D=
)  OK
[   22.127158] raid6test: test_disks(26, 33): faila=3D 26(D)  failb=3D 33(D=
)  OK
[   22.128036] raid6test: test_disks(26, 34): faila=3D 26(D)  failb=3D 34(D=
)  OK
[   22.128916] raid6test: test_disks(26, 35): faila=3D 26(D)  failb=3D 35(D=
)  OK
[   22.129804] raid6test: test_disks(26, 36): faila=3D 26(D)  failb=3D 36(D=
)  OK
[   22.130688] raid6test: test_disks(26, 37): faila=3D 26(D)  failb=3D 37(D=
)  OK
[   22.131573] raid6test: test_disks(26, 38): faila=3D 26(D)  failb=3D 38(D=
)  OK
[   22.132466] raid6test: test_disks(26, 39): faila=3D 26(D)  failb=3D 39(D=
)  OK
[   22.133343] raid6test: test_disks(26, 40): faila=3D 26(D)  failb=3D 40(D=
)  OK
[   22.134216] raid6test: test_disks(26, 41): faila=3D 26(D)  failb=3D 41(D=
)  OK
[   22.135120] raid6test: test_disks(26, 42): faila=3D 26(D)  failb=3D 42(D=
)  OK
[   22.136011] raid6test: test_disks(26, 43): faila=3D 26(D)  failb=3D 43(D=
)  OK
[   22.160930] raid6test: test_disks(26, 44): faila=3D 26(D)  failb=3D 44(D=
)  OK
[   22.161820] raid6test: test_disks(26, 45): faila=3D 26(D)  failb=3D 45(D=
)  OK
[   22.162707] raid6test: test_disks(26, 46): faila=3D 26(D)  failb=3D 46(D=
)  OK
[   22.163587] raid6test: test_disks(26, 47): faila=3D 26(D)  failb=3D 47(D=
)  OK
[   22.164466] raid6test: test_disks(26, 48): faila=3D 26(D)  failb=3D 48(D=
)  OK
[   22.165341] raid6test: test_disks(26, 49): faila=3D 26(D)  failb=3D 49(D=
)  OK
[   22.166230] raid6test: test_disks(26, 50): faila=3D 26(D)  failb=3D 50(D=
)  OK
[   22.167109] raid6test: test_disks(26, 51): faila=3D 26(D)  failb=3D 51(D=
)  OK
[   22.167989] raid6test: test_disks(26, 52): faila=3D 26(D)  failb=3D 52(D=
)  OK
[   22.168867] raid6test: test_disks(26, 53): faila=3D 26(D)  failb=3D 53(D=
)  OK
[   22.188797] raid6test: test_disks(26, 54): faila=3D 26(D)  failb=3D 54(D=
)  OK
[   22.189691] raid6test: test_disks(26, 55): faila=3D 26(D)  failb=3D 55(D=
)  OK
[   22.190566] raid6test: test_disks(26, 56): faila=3D 26(D)  failb=3D 56(D=
)  OK
[   22.191448] raid6test: test_disks(26, 57): faila=3D 26(D)  failb=3D 57(D=
)  OK
[   22.192317] raid6test: test_disks(26, 58): faila=3D 26(D)  failb=3D 58(D=
)  OK
[   22.193202] raid6test: test_disks(26, 59): faila=3D 26(D)  failb=3D 59(D=
)  OK
[   22.194081] raid6test: test_disks(26, 60): faila=3D 26(D)  failb=3D 60(D=
)  OK
[   22.194962] raid6test: test_disks(26, 61): faila=3D 26(D)  failb=3D 61(D=
)  OK
[   22.195849] raid6test: test_disks(26, 62): faila=3D 26(D)  failb=3D 62(P=
)  OK
[   22.196724] raid6test: test_disks(26, 63): faila=3D 26(D)  failb=3D 63(Q=
)  OK
[   22.206681] raid6test: test_disks(27, 28): faila=3D 27(D)  failb=3D 28(D=
)  OK
[   22.207562] raid6test: test_disks(27, 29): faila=3D 27(D)  failb=3D 29(D=
)  OK
[   22.208450] raid6test: test_disks(27, 30): faila=3D 27(D)  failb=3D 30(D=
)  OK
[   22.209331] raid6test: test_disks(27, 31): faila=3D 27(D)  failb=3D 31(D=
)  OK
[   22.210210] raid6test: test_disks(27, 32): faila=3D 27(D)  failb=3D 32(D=
)  OK
[   22.211085] raid6test: test_disks(27, 33): faila=3D 27(D)  failb=3D 33(D=
)  OK
[   22.211962] raid6test: test_disks(27, 34): faila=3D 27(D)  failb=3D 34(D=
)  OK
[   22.212857] raid6test: test_disks(27, 35): faila=3D 27(D)  failb=3D 35(D=
)  OK
[   22.213740] raid6test: test_disks(27, 36): faila=3D 27(D)  failb=3D 36(D=
)  OK
[   22.214617] raid6test: test_disks(27, 37): faila=3D 27(D)  failb=3D 37(D=
)  OK
[   22.226729] raid6test: test_disks(27, 38): faila=3D 27(D)  failb=3D 38(D=
)  OK
[   22.227619] raid6test: test_disks(27, 39): faila=3D 27(D)  failb=3D 39(D=
)  OK
[   22.228500] raid6test: test_disks(27, 40): faila=3D 27(D)  failb=3D 40(D=
)  OK
[   22.229381] raid6test: test_disks(27, 41): faila=3D 27(D)  failb=3D 41(D=
)  OK
[   22.230259] raid6test: test_disks(27, 42): faila=3D 27(D)  failb=3D 42(D=
)  OK
[   22.231140] raid6test: test_disks(27, 43): faila=3D 27(D)  failb=3D 43(D=
)  OK
[   22.232019] raid6test: test_disks(27, 44): faila=3D 27(D)  failb=3D 44(D=
)  OK
[   22.232912] raid6test: test_disks(27, 45): faila=3D 27(D)  failb=3D 45(D=
)  OK
[   22.233789] raid6test: test_disks(27, 46): faila=3D 27(D)  failb=3D 46(D=
)  OK
[   22.234670] raid6test: test_disks(27, 47): faila=3D 27(D)  failb=3D 47(D=
)  OK
[   22.235544] raid6test: test_disks(27, 48): faila=3D 27(D)  failb=3D 48(D=
)  OK
[   22.236439] raid6test: test_disks(27, 49): faila=3D 27(D)  failb=3D 49(D=
)  OK
[   22.237310] raid6test: test_disks(27, 50): faila=3D 27(D)  failb=3D 50(D=
)  OK
[   22.238187] raid6test: test_disks(27, 51): faila=3D 27(D)  failb=3D 51(D=
)  OK
[   22.239086] raid6test: test_disks(27, 52): faila=3D 27(D)  failb=3D 52(D=
)  OK
[   22.258987] raid6test: test_disks(27, 53): faila=3D 27(D)  failb=3D 53(D=
)  OK
[   22.259876] raid6test: test_disks(27, 54): faila=3D 27(D)  failb=3D 54(D=
)  OK
[   22.260758] raid6test: test_disks(27, 55): faila=3D 27(D)  failb=3D 55(D=
)  OK
[   22.261647] raid6test: test_disks(27, 56): faila=3D 27(D)  failb=3D 56(D=
)  OK
[   22.262540] raid6test: test_disks(27, 57): faila=3D 27(D)  failb=3D 57(D=
)  OK
[   22.263416] raid6test: test_disks(27, 58): faila=3D 27(D)  failb=3D 58(D=
)  OK
[   22.264285] raid6test: test_disks(27, 59): faila=3D 27(D)  failb=3D 59(D=
)  OK
[   22.265165] raid6test: test_disks(27, 60): faila=3D 27(D)  failb=3D 60(D=
)  OK
[   22.266059] raid6test: test_disks(27, 61): faila=3D 27(D)  failb=3D 61(D=
)  OK
[   22.266928] raid6test: test_disks(27, 62): faila=3D 27(D)  failb=3D 62(P=
)  OK
[   22.267797] raid6test: test_disks(27, 63): faila=3D 27(D)  failb=3D 63(Q=
)  OK
[   22.268675] raid6test: test_disks(28, 29): faila=3D 28(D)  failb=3D 29(D=
)  OK
[   22.269567] raid6test: test_disks(28, 30): faila=3D 28(D)  failb=3D 30(D=
)  OK
[   22.270443] raid6test: test_disks(28, 31): faila=3D 28(D)  failb=3D 31(D=
)  OK
[   22.271313] raid6test: test_disks(28, 32): faila=3D 28(D)  failb=3D 32(D=
)  OK
[   22.272191] raid6test: test_disks(28, 33): faila=3D 28(D)  failb=3D 33(D=
)  OK
[   22.273075] raid6test: test_disks(28, 34): faila=3D 28(D)  failb=3D 34(D=
)  OK
[   22.273953] raid6test: test_disks(28, 35): faila=3D 28(D)  failb=3D 35(D=
)  OK
[   22.287856] raid6test: test_disks(28, 36): faila=3D 28(D)  failb=3D 36(D=
)  OK
[   22.288739] raid6test: test_disks(28, 37): faila=3D 28(D)  failb=3D 37(D=
)  OK
[   22.289621] raid6test: test_disks(28, 38): faila=3D 28(D)  failb=3D 38(D=
)  OK
[   22.290493] raid6test: test_disks(28, 39): faila=3D 28(D)  failb=3D 39(D=
)  OK
[   22.291369] raid6test: test_disks(28, 40): faila=3D 28(D)  failb=3D 40(D=
)  OK
[   22.292243] raid6test: test_disks(28, 41): faila=3D 28(D)  failb=3D 41(D=
)  OK
[   22.293128] raid6test: test_disks(28, 42): faila=3D 28(D)  failb=3D 42(D=
)  OK
[   22.294006] raid6test: test_disks(28, 43): faila=3D 28(D)  failb=3D 43(D=
)  OK
[   22.294888] raid6test: test_disks(28, 44): faila=3D 28(D)  failb=3D 44(D=
)  OK
[   22.295783] raid6test: test_disks(28, 45): faila=3D 28(D)  failb=3D 45(D=
)  OK
[   22.296691] raid6test: test_disks(28, 46): faila=3D 28(D)  failb=3D 46(D=
)  OK
[   22.297727] raid6test: test_disks(28, 47): faila=3D 28(D)  failb=3D 47(D=
)  OK
[   22.298610] raid6test: test_disks(28, 48): faila=3D 28(D)  failb=3D 48(D=
)  OK
[   22.299496] raid6test: test_disks(28, 49): faila=3D 28(D)  failb=3D 49(D=
)  OK
[   22.300369] raid6test: test_disks(28, 50): faila=3D 28(D)  failb=3D 50(D=
)  OK
[   22.314262] raid6test: test_disks(28, 51): faila=3D 28(D)  failb=3D 51(D=
)  OK
[   22.315141] raid6test: test_disks(28, 52): faila=3D 28(D)  failb=3D 52(D=
)  OK
[   22.316028] raid6test: test_disks(28, 53): faila=3D 28(D)  failb=3D 53(D=
)  OK
[   22.317016] raid6test: test_disks(28, 54): faila=3D 28(D)  failb=3D 54(D=
)  OK
[   22.317909] raid6test: test_disks(28, 55): faila=3D 28(D)  failb=3D 55(D=
)  OK
[   22.318790] raid6test: test_disks(28, 56): faila=3D 28(D)  failb=3D 56(D=
)  OK
[   22.319680] raid6test: test_disks(28, 57): faila=3D 28(D)  failb=3D 57(D=
)  OK
[   22.320561] raid6test: test_disks(28, 58): faila=3D 28(D)  failb=3D 58(D=
)  OK
[   22.321443] raid6test: test_disks(28, 59): faila=3D 28(D)  failb=3D 59(D=
)  OK
[   22.322310] raid6test: test_disks(28, 60): faila=3D 28(D)  failb=3D 60(D=
)  OK
[   22.323204] raid6test: test_disks(28, 61): faila=3D 28(D)  failb=3D 61(D=
)  OK
[   22.324076] raid6test: test_disks(28, 62): faila=3D 28(D)  failb=3D 62(P=
)  OK
[   22.342983] raid6test: test_disks(28, 63): faila=3D 28(D)  failb=3D 63(Q=
)  OK
[   22.343861] raid6test: test_disks(29, 30): faila=3D 29(D)  failb=3D 30(D=
)  OK
[   22.344740] raid6test: test_disks(29, 31): faila=3D 29(D)  failb=3D 31(D=
)  OK
[   22.345616] raid6test: test_disks(29, 32): faila=3D 29(D)  failb=3D 32(D=
)  OK
[   22.346508] raid6test: test_disks(29, 33): faila=3D 29(D)  failb=3D 33(D=
)  OK
[   22.347375] raid6test: test_disks(29, 34): faila=3D 29(D)  failb=3D 34(D=
)  OK
[   22.348255] raid6test: test_disks(29, 35): faila=3D 29(D)  failb=3D 35(D=
)  OK
[   22.349142] raid6test: test_disks(29, 36): faila=3D 29(D)  failb=3D 36(D=
)  OK
[   22.350020] raid6test: test_disks(29, 37): faila=3D 29(D)  failb=3D 37(D=
)  OK
[   22.350893] raid6test: test_disks(29, 38): faila=3D 29(D)  failb=3D 38(D=
)  OK
[   22.351771] raid6test: test_disks(29, 39): faila=3D 29(D)  failb=3D 39(D=
)  OK
[   22.352671] raid6test: test_disks(29, 40): faila=3D 29(D)  failb=3D 40(D=
)  OK
[   22.353544] raid6test: test_disks(29, 41): faila=3D 29(D)  failb=3D 41(D=
)  OK
[   22.354414] raid6test: test_disks(29, 42): faila=3D 29(D)  failb=3D 42(D=
)  OK
[   22.355278] raid6test: test_disks(29, 43): faila=3D 29(D)  failb=3D 43(D=
)  OK
[   22.370182] raid6test: test_disks(29, 44): faila=3D 29(D)  failb=3D 44(D=
)  OK
[   22.371061] raid6test: test_disks(29, 45): faila=3D 29(D)  failb=3D 45(D=
)  OK
[   22.371940] raid6test: test_disks(29, 46): faila=3D 29(D)  failb=3D 46(D=
)  OK
[   22.372828] raid6test: test_disks(29, 47): faila=3D 29(D)  failb=3D 47(D=
)  OK
[   22.373707] raid6test: test_disks(29, 48): faila=3D 29(D)  failb=3D 48(D=
)  OK
[   22.374584] raid6test: test_disks(29, 49): faila=3D 29(D)  failb=3D 49(D=
)  OK
[   22.375459] raid6test: test_disks(29, 50): faila=3D 29(D)  failb=3D 50(D=
)  OK
[   22.376344] raid6test: test_disks(29, 51): faila=3D 29(D)  failb=3D 51(D=
)  OK
[   22.396241] raid6test: test_disks(29, 52): faila=3D 29(D)  failb=3D 52(D=
)  OK
[   22.397122] raid6test: test_disks(29, 53): faila=3D 29(D)  failb=3D 53(D=
)  OK
[   22.407120] raid6test: test_disks(29, 54): faila=3D 29(D)  failb=3D 54(D=
)  OK
[   22.408008] raid6test: test_disks(29, 55): faila=3D 29(D)  failb=3D 55(D=
)  OK
[   22.408883] raid6test: test_disks(29, 56): faila=3D 29(D)  failb=3D 56(D=
)  OK
[   22.409782] raid6test: test_disks(29, 57): faila=3D 29(D)  failb=3D 57(D=
)  OK
[   22.410661] raid6test: test_disks(29, 58): faila=3D 29(D)  failb=3D 58(D=
)  OK
[   22.411536] raid6test: test_disks(29, 59): faila=3D 29(D)  failb=3D 59(D=
)  OK
[   22.412421] raid6test: test_disks(29, 60): faila=3D 29(D)  failb=3D 60(D=
)  OK
[   22.413282] raid6test: test_disks(29, 61): faila=3D 29(D)  failb=3D 61(D=
)  OK
[   22.414145] raid6test: test_disks(29, 62): faila=3D 29(D)  failb=3D 62(P=
)  OK
[   22.415013] raid6test: test_disks(29, 63): faila=3D 29(D)  failb=3D 63(Q=
)  OK
[   22.434028] raid6test: test_disks(30, 31): faila=3D 30(D)  failb=3D 31(D=
)  OK
[   22.434908] raid6test: test_disks(30, 32): faila=3D 30(D)  failb=3D 32(D=
)  OK
[   22.435807] raid6test: test_disks(30, 33): faila=3D 30(D)  failb=3D 33(D=
)  OK
[   22.436684] raid6test: test_disks(30, 34): faila=3D 30(D)  failb=3D 34(D=
)  OK
[   22.437559] raid6test: test_disks(30, 35): faila=3D 30(D)  failb=3D 35(D=
)  OK
[   22.438429] raid6test: test_disks(30, 36): faila=3D 30(D)  failb=3D 36(D=
)  OK
[   22.439312] raid6test: test_disks(30, 37): faila=3D 30(D)  failb=3D 37(D=
)  OK
[   22.440192] raid6test: test_disks(30, 38): faila=3D 30(D)  failb=3D 38(D=
)  OK
[   22.441066] raid6test: test_disks(30, 39): faila=3D 30(D)  failb=3D 39(D=
)  OK
[   22.441938] raid6test: test_disks(30, 40): faila=3D 30(D)  failb=3D 40(D=
)  OK
[   22.460970] raid6test: test_disks(30, 41): faila=3D 30(D)  failb=3D 41(D=
)  OK
[   22.461850] raid6test: test_disks(30, 42): faila=3D 30(D)  failb=3D 42(D=
)  OK
[   22.462745] raid6test: test_disks(30, 43): faila=3D 30(D)  failb=3D 43(D=
)  OK
[   22.463623] raid6test: test_disks(30, 44): faila=3D 30(D)  failb=3D 44(D=
)  OK
[   22.464500] raid6test: test_disks(30, 45): faila=3D 30(D)  failb=3D 45(D=
)  OK
[   22.465364] raid6test: test_disks(30, 46): faila=3D 30(D)  failb=3D 46(D=
)  OK
[   22.466329] raid6test: test_disks(30, 47): faila=3D 30(D)  failb=3D 47(D=
)  OK
[   22.467303] raid6test: test_disks(30, 48): faila=3D 30(D)  failb=3D 48(D=
)  OK
[   22.468277] raid6test: test_disks(30, 49): faila=3D 30(D)  failb=3D 49(D=
)  OK
[   22.469255] raid6test: test_disks(30, 50): faila=3D 30(D)  failb=3D 50(D=
)  OK
[   22.488419] raid6test: test_disks(30, 51): faila=3D 30(D)  failb=3D 51(D=
)  OK
[   22.489409] raid6test: test_disks(30, 52): faila=3D 30(D)  failb=3D 52(D=
)  OK
[   22.490371] raid6test: test_disks(30, 53): faila=3D 30(D)  failb=3D 53(D=
)  OK
[   22.491312] raid6test: test_disks(30, 54): faila=3D 30(D)  failb=3D 54(D=
)  OK
[   22.492183] raid6test: test_disks(30, 55): faila=3D 30(D)  failb=3D 55(D=
)  OK
[   22.493158] raid6test: test_disks(30, 56): faila=3D 30(D)  failb=3D 56(D=
)  OK
[   22.494102] raid6test: test_disks(30, 57): faila=3D 30(D)  failb=3D 57(D=
)  OK
[   22.494982] raid6test: test_disks(30, 58): faila=3D 30(D)  failb=3D 58(D=
)  OK
[   22.495870] raid6test: test_disks(30, 59): faila=3D 30(D)  failb=3D 59(D=
)  OK
[   22.514858] raid6test: test_disks(30, 60): faila=3D 30(D)  failb=3D 60(D=
)  OK
[   22.515758] raid6test: test_disks(30, 61): faila=3D 30(D)  failb=3D 61(D=
)  OK
[   22.516625] raid6test: test_disks(30, 62): faila=3D 30(D)  failb=3D 62(P=
)  OK
[   22.517589] raid6test: test_disks(30, 63): faila=3D 30(D)  failb=3D 63(Q=
)  OK
[   22.518555] raid6test: test_disks(31, 32): faila=3D 31(D)  failb=3D 32(D=
)  OK
[   22.519537] raid6test: test_disks(31, 33): faila=3D 31(D)  failb=3D 33(D=
)  OK
[   22.520506] raid6test: test_disks(31, 34): faila=3D 31(D)  failb=3D 34(D=
)  OK
[   22.521478] raid6test: test_disks(31, 35): faila=3D 31(D)  failb=3D 35(D=
)  OK
[   22.522454] raid6test: test_disks(31, 36): faila=3D 31(D)  failb=3D 36(D=
)  OK
[   22.541452] raid6test: test_disks(31, 37): faila=3D 31(D)  failb=3D 37(D=
)  OK
[   22.542529] raid6test: test_disks(31, 38): faila=3D 31(D)  failb=3D 38(D=
)  OK
[   22.543454] raid6test: test_disks(31, 39): faila=3D 31(D)  failb=3D 39(D=
)  OK
[   22.544324] raid6test: test_disks(31, 40): faila=3D 31(D)  failb=3D 40(D=
)  OK
[   22.545199] raid6test: test_disks(31, 41): faila=3D 31(D)  failb=3D 41(D=
)  OK
[   22.546078] raid6test: test_disks(31, 42): faila=3D 31(D)  failb=3D 42(D=
)  OK
[   22.546957] raid6test: test_disks(31, 43): faila=3D 31(D)  failb=3D 43(D=
)  OK
[   22.547835] raid6test: test_disks(31, 44): faila=3D 31(D)  failb=3D 44(D=
)  OK
[   22.548716] raid6test: test_disks(31, 45): faila=3D 31(D)  failb=3D 45(D=
)  OK
[   22.549606] raid6test: test_disks(31, 46): faila=3D 31(D)  failb=3D 46(D=
)  OK
[   22.568577] raid6test: test_disks(31, 47): faila=3D 31(D)  failb=3D 47(D=
)  OK
[   22.569507] raid6test: test_disks(31, 48): faila=3D 31(D)  failb=3D 48(D=
)  OK
[   22.570379] raid6test: test_disks(31, 49): faila=3D 31(D)  failb=3D 49(D=
)  OK
[   22.571250] raid6test: test_disks(31, 50): faila=3D 31(D)  failb=3D 50(D=
)  OK
[   22.572221] raid6test: test_disks(31, 51): faila=3D 31(D)  failb=3D 51(D=
)  OK
[   22.573194] raid6test: test_disks(31, 52): faila=3D 31(D)  failb=3D 52(D=
)  OK
[   22.574168] raid6test: test_disks(31, 53): faila=3D 31(D)  failb=3D 53(D=
)  OK
[   22.575138] raid6test: test_disks(31, 54): faila=3D 31(D)  failb=3D 54(D=
)  OK
[   22.576136] raid6test: test_disks(31, 55): faila=3D 31(D)  failb=3D 55(D=
)  OK
[   22.577110] raid6test: test_disks(31, 56): faila=3D 31(D)  failb=3D 56(D=
)  OK
[   22.596271] raid6test: test_disks(31, 57): faila=3D 31(D)  failb=3D 57(D=
)  OK
[   22.597245] raid6test: test_disks(31, 58): faila=3D 31(D)  failb=3D 58(D=
)  OK
[   22.598217] raid6test: test_disks(31, 59): faila=3D 31(D)  failb=3D 59(D=
)  OK
[   22.599196] raid6test: test_disks(31, 60): faila=3D 31(D)  failb=3D 60(D=
)  OK
[   22.600165] raid6test: test_disks(31, 61): faila=3D 31(D)  failb=3D 61(D=
)  OK
[   22.601125] raid6test: test_disks(31, 62): faila=3D 31(D)  failb=3D 62(P=
)  OK
[   22.602017] raid6test: test_disks(31, 63): faila=3D 31(D)  failb=3D 63(Q=
)  OK
[   22.602913] raid6test: test_disks(32, 33): faila=3D 32(D)  failb=3D 33(D=
)  OK
[   22.603788] raid6test: test_disks(32, 34): faila=3D 32(D)  failb=3D 34(D=
)  OK
[   22.622834] raid6test: test_disks(32, 35): faila=3D 32(D)  failb=3D 35(D=
)  OK
[   22.623796] raid6test: test_disks(32, 36): faila=3D 32(D)  failb=3D 36(D=
)  OK
[   22.624758] raid6test: test_disks(32, 37): faila=3D 32(D)  failb=3D 37(D=
)  OK
[   22.625734] raid6test: test_disks(32, 38): faila=3D 32(D)  failb=3D 38(D=
)  OK
[   22.626696] raid6test: test_disks(32, 39): faila=3D 32(D)  failb=3D 39(D=
)  OK
[   22.627665] raid6test: test_disks(32, 40): faila=3D 32(D)  failb=3D 40(D=
)  OK
[   22.628630] raid6test: test_disks(32, 41): faila=3D 32(D)  failb=3D 41(D=
)  OK
[   22.629625] raid6test: test_disks(32, 42): faila=3D 32(D)  failb=3D 42(D=
)  OK
[   22.630595] raid6test: test_disks(32, 43): faila=3D 32(D)  failb=3D 43(D=
)  OK
[   22.649580] raid6test: test_disks(32, 44): faila=3D 32(D)  failb=3D 44(D=
)  OK
[   22.650463] raid6test: test_disks(32, 45): faila=3D 32(D)  failb=3D 45(D=
)  OK
[   22.651331] raid6test: test_disks(32, 46): faila=3D 32(D)  failb=3D 46(D=
)  OK
[   22.652209] raid6test: test_disks(32, 47): faila=3D 32(D)  failb=3D 47(D=
)  OK
[   22.653097] raid6test: test_disks(32, 48): faila=3D 32(D)  failb=3D 48(D=
)  OK
[   22.653991] raid6test: test_disks(32, 49): faila=3D 32(D)  failb=3D 49(D=
)  OK
[   22.654905] raid6test: test_disks(32, 50): faila=3D 32(D)  failb=3D 50(D=
)  OK
[   22.655892] raid6test: test_disks(32, 51): faila=3D 32(D)  failb=3D 51(D=
)  OK
[   22.656866] raid6test: test_disks(32, 52): faila=3D 32(D)  failb=3D 52(D=
)  OK
[   22.657835] raid6test: test_disks(32, 53): faila=3D 32(D)  failb=3D 53(D=
)  OK
[   22.676801] raid6test: test_disks(32, 54): faila=3D 32(D)  failb=3D 54(D=
)  OK
[   22.677674] raid6test: test_disks(32, 55): faila=3D 32(D)  failb=3D 55(D=
)  OK
[   22.678544] raid6test: test_disks(32, 56): faila=3D 32(D)  failb=3D 56(D=
)  OK
[   22.679424] raid6test: test_disks(32, 57): faila=3D 32(D)  failb=3D 57(D=
)  OK
[   22.680291] raid6test: test_disks(32, 58): faila=3D 32(D)  failb=3D 58(D=
)  OK
[   22.681170] raid6test: test_disks(32, 59): faila=3D 32(D)  failb=3D 59(D=
)  OK
[   22.682042] raid6test: test_disks(32, 60): faila=3D 32(D)  failb=3D 60(D=
)  OK
[   22.682926] raid6test: test_disks(32, 61): faila=3D 32(D)  failb=3D 61(D=
)  OK
[   22.683794] raid6test: test_disks(32, 62): faila=3D 32(D)  failb=3D 62(P=
)  OK
[   22.684672] raid6test: test_disks(32, 63): faila=3D 32(D)  failb=3D 63(Q=
)  OK
[   22.703737] raid6test: test_disks(33, 34): faila=3D 33(D)  failb=3D 34(D=
)  OK
[   22.704616] raid6test: test_disks(33, 35): faila=3D 33(D)  failb=3D 35(D=
)  OK
[   22.705487] raid6test: test_disks(33, 36): faila=3D 33(D)  failb=3D 36(D=
)  OK
[   22.706359] raid6test: test_disks(33, 37): faila=3D 33(D)  failb=3D 37(D=
)  OK
[   22.707235] raid6test: test_disks(33, 38): faila=3D 33(D)  failb=3D 38(D=
)  OK
[   22.708113] raid6test: test_disks(33, 39): faila=3D 33(D)  failb=3D 39(D=
)  OK
[   22.708978] raid6test: test_disks(33, 40): faila=3D 33(D)  failb=3D 40(D=
)  OK
[   22.709871] raid6test: test_disks(33, 41): faila=3D 33(D)  failb=3D 41(D=
)  OK
[   22.710746] raid6test: test_disks(33, 42): faila=3D 33(D)  failb=3D 42(D=
)  OK
[   22.711616] raid6test: test_disks(33, 43): faila=3D 33(D)  failb=3D 43(D=
)  OK
[   22.730510] raid6test: test_disks(33, 44): faila=3D 33(D)  failb=3D 44(D=
)  OK
[   22.731382] raid6test: test_disks(33, 45): faila=3D 33(D)  failb=3D 45(D=
)  OK
[   22.732250] raid6test: test_disks(33, 46): faila=3D 33(D)  failb=3D 46(D=
)  OK
[   22.733133] raid6test: test_disks(33, 47): faila=3D 33(D)  failb=3D 47(D=
)  OK
[   22.734004] raid6test: test_disks(33, 48): faila=3D 33(D)  failb=3D 48(D=
)  OK
[   22.734876] raid6test: test_disks(33, 49): faila=3D 33(D)  failb=3D 49(D=
)  OK
[   22.735771] raid6test: test_disks(33, 50): faila=3D 33(D)  failb=3D 50(D=
)  OK
[   22.736640] raid6test: test_disks(33, 51): faila=3D 33(D)  failb=3D 51(D=
)  OK
[   22.737510] raid6test: test_disks(33, 52): faila=3D 33(D)  failb=3D 52(D=
)  OK
[   22.738379] raid6test: test_disks(33, 53): faila=3D 33(D)  failb=3D 53(D=
)  OK
[   22.739258] raid6test: test_disks(33, 54): faila=3D 33(D)  failb=3D 54(D=
)  OK
[   22.758153] raid6test: test_disks(33, 55): faila=3D 33(D)  failb=3D 55(D=
)  OK
[   22.759042] raid6test: test_disks(33, 56): faila=3D 33(D)  failb=3D 56(D=
)  OK
[   22.759915] raid6test: test_disks(33, 57): faila=3D 33(D)  failb=3D 57(D=
)  OK
[   22.760804] raid6test: test_disks(33, 58): faila=3D 33(D)  failb=3D 58(D=
)  OK
[   22.761677] raid6test: test_disks(33, 59): faila=3D 33(D)  failb=3D 59(D=
)  OK
[   22.762555] raid6test: test_disks(33, 60): faila=3D 33(D)  failb=3D 60(D=
)  OK
[   22.763428] raid6test: test_disks(33, 61): faila=3D 33(D)  failb=3D 61(D=
)  OK
[   22.764286] raid6test: test_disks(33, 62): faila=3D 33(D)  failb=3D 62(P=
)  OK
[   22.765154] raid6test: test_disks(33, 63): faila=3D 33(D)  failb=3D 63(Q=
)  OK
[   22.766040] raid6test: test_disks(34, 35): faila=3D 34(D)  failb=3D 35(D=
)  OK
[   22.776961] raid6test: test_disks(34, 36): faila=3D 34(D)  failb=3D 36(D=
)  OK
[   22.777845] raid6test: test_disks(34, 37): faila=3D 34(D)  failb=3D 37(D=
)  OK
[   22.778730] raid6test: test_disks(34, 38): faila=3D 34(D)  failb=3D 38(D=
)  OK
[   22.779621] raid6test: test_disks(34, 39): faila=3D 34(D)  failb=3D 39(D=
)  OK
[   22.780496] raid6test: test_disks(34, 40): faila=3D 34(D)  failb=3D 40(D=
)  OK
[   22.781366] raid6test: test_disks(34, 41): faila=3D 34(D)  failb=3D 41(D=
)  OK
[   22.782240] raid6test: test_disks(34, 42): faila=3D 34(D)  failb=3D 42(D=
)  OK
[   22.783144] raid6test: test_disks(34, 43): faila=3D 34(D)  failb=3D 43(D=
)  OK
[   22.784022] raid6test: test_disks(34, 44): faila=3D 34(D)  failb=3D 44(D=
)  OK
[   22.784901] raid6test: test_disks(34, 45): faila=3D 34(D)  failb=3D 45(D=
)  OK
[   22.803803] raid6test: test_disks(34, 46): faila=3D 34(D)  failb=3D 46(D=
)  OK
[   22.804678] raid6test: test_disks(34, 47): faila=3D 34(D)  failb=3D 47(D=
)  OK
[   22.805559] raid6test: test_disks(34, 48): faila=3D 34(D)  failb=3D 48(D=
)  OK
[   22.806447] raid6test: test_disks(34, 49): faila=3D 34(D)  failb=3D 49(D=
)  OK
[   22.807318] raid6test: test_disks(34, 50): faila=3D 34(D)  failb=3D 50(D=
)  OK
[   22.808201] raid6test: test_disks(34, 51): faila=3D 34(D)  failb=3D 51(D=
)  OK
[   22.809099] raid6test: test_disks(34, 52): faila=3D 34(D)  failb=3D 52(D=
)  OK
[   22.809983] raid6test: test_disks(34, 53): faila=3D 34(D)  failb=3D 53(D=
)  OK
[   22.810864] raid6test: test_disks(34, 54): faila=3D 34(D)  failb=3D 54(D=
)  OK
[   22.811746] raid6test: test_disks(34, 55): faila=3D 34(D)  failb=3D 55(D=
)  OK
[   22.830647] raid6test: test_disks(34, 56): faila=3D 34(D)  failb=3D 56(D=
)  OK
[   22.831530] raid6test: test_disks(34, 57): faila=3D 34(D)  failb=3D 57(D=
)  OK
[   22.832427] raid6test: test_disks(34, 58): faila=3D 34(D)  failb=3D 58(D=
)  OK
[   22.833302] raid6test: test_disks(34, 59): faila=3D 34(D)  failb=3D 59(D=
)  OK
[   22.834183] raid6test: test_disks(34, 60): faila=3D 34(D)  failb=3D 60(D=
)  OK
[   22.835058] raid6test: test_disks(34, 61): faila=3D 34(D)  failb=3D 61(D=
)  OK
[   22.835941] raid6test: test_disks(34, 62): faila=3D 34(D)  failb=3D 62(P=
)  OK
[   22.836814] raid6test: test_disks(34, 63): faila=3D 34(D)  failb=3D 63(Q=
)  OK
[   22.837691] raid6test: test_disks(35, 36): faila=3D 35(D)  failb=3D 36(D=
)  OK
[   22.838571] raid6test: test_disks(35, 37): faila=3D 35(D)  failb=3D 37(D=
)  OK
[   22.857519] raid6test: test_disks(35, 38): faila=3D 35(D)  failb=3D 38(D=
)  OK
[   22.858431] raid6test: test_disks(35, 39): faila=3D 35(D)  failb=3D 39(D=
)  OK
[   22.859317] raid6test: test_disks(35, 40): faila=3D 35(D)  failb=3D 40(D=
)  OK
[   22.860200] raid6test: test_disks(35, 41): faila=3D 35(D)  failb=3D 41(D=
)  OK
[   22.861079] raid6test: test_disks(35, 42): faila=3D 35(D)  failb=3D 42(D=
)  OK
[   22.861960] raid6test: test_disks(35, 43): faila=3D 35(D)  failb=3D 43(D=
)  OK
[   22.862849] raid6test: test_disks(35, 44): faila=3D 35(D)  failb=3D 44(D=
)  OK
[   22.863727] raid6test: test_disks(35, 45): faila=3D 35(D)  failb=3D 45(D=
)  OK
[   22.864605] raid6test: test_disks(35, 46): faila=3D 35(D)  failb=3D 46(D=
)  OK
[   22.865492] raid6test: test_disks(35, 47): faila=3D 35(D)  failb=3D 47(D=
)  OK
[   22.866369] raid6test: test_disks(35, 48): faila=3D 35(D)  failb=3D 48(D=
)  OK
[   22.888284] raid6test: test_disks(35, 49): faila=3D 35(D)  failb=3D 49(D=
)  OK
[   22.889176] raid6test: test_disks(35, 50): faila=3D 35(D)  failb=3D 50(D=
)  OK
[   22.890074] raid6test: test_disks(35, 51): faila=3D 35(D)  failb=3D 51(D=
)  OK
[   22.890950] raid6test: test_disks(35, 52): faila=3D 35(D)  failb=3D 52(D=
)  OK
[   22.891828] raid6test: test_disks(35, 53): faila=3D 35(D)  failb=3D 53(D=
)  OK
[   22.892717] raid6test: test_disks(35, 54): faila=3D 35(D)  failb=3D 54(D=
)  OK
[   22.893596] raid6test: test_disks(35, 55): faila=3D 35(D)  failb=3D 55(D=
)  OK
[   22.894473] raid6test: test_disks(35, 56): faila=3D 35(D)  failb=3D 56(D=
)  OK
[   22.895348] raid6test: test_disks(35, 57): faila=3D 35(D)  failb=3D 57(D=
)  OK
[   22.896246] raid6test: test_disks(35, 58): faila=3D 35(D)  failb=3D 58(D=
)  OK
[   22.897126] raid6test: test_disks(35, 59): faila=3D 35(D)  failb=3D 59(D=
)  OK
[   22.898003] raid6test: test_disks(35, 60): faila=3D 35(D)  failb=3D 60(D=
)  OK
[   22.916900] raid6test: test_disks(35, 61): faila=3D 35(D)  failb=3D 61(D=
)  OK
[   22.917772] raid6test: test_disks(35, 62): faila=3D 35(D)  failb=3D 62(P=
)  OK
[   22.918644] raid6test: test_disks(35, 63): faila=3D 35(D)  failb=3D 63(Q=
)  OK
[   22.919530] raid6test: test_disks(36, 37): faila=3D 36(D)  failb=3D 37(D=
)  OK
[   22.920405] raid6test: test_disks(36, 38): faila=3D 36(D)  failb=3D 38(D=
)  OK
[   22.921266] raid6test: test_disks(36, 39): faila=3D 36(D)  failb=3D 39(D=
)  OK
[   22.922284] raid6test: test_disks(36, 40): faila=3D 36(D)  failb=3D 40(D=
)  OK
[   22.923254] raid6test: test_disks(36, 41): faila=3D 36(D)  failb=3D 41(D=
)  OK
[   22.924180] raid6test: test_disks(36, 42): faila=3D 36(D)  failb=3D 42(D=
)  OK
[   22.925095] raid6test: test_disks(36, 43): faila=3D 36(D)  failb=3D 43(D=
)  OK
[   22.944003] raid6test: test_disks(36, 44): faila=3D 36(D)  failb=3D 44(D=
)  OK
[   22.944882] raid6test: test_disks(36, 45): faila=3D 36(D)  failb=3D 45(D=
)  OK
[   22.945781] raid6test: test_disks(36, 46): faila=3D 36(D)  failb=3D 46(D=
)  OK
[   22.946667] raid6test: test_disks(36, 47): faila=3D 36(D)  failb=3D 47(D=
)  OK
[   22.947543] raid6test: test_disks(36, 48): faila=3D 36(D)  failb=3D 48(D=
)  OK
[   22.948422] raid6test: test_disks(36, 49): faila=3D 36(D)  failb=3D 49(D=
)  OK
[   22.949308] raid6test: test_disks(36, 50): faila=3D 36(D)  failb=3D 50(D=
)  OK
[   22.950191] raid6test: test_disks(36, 51): faila=3D 36(D)  failb=3D 51(D=
)  OK
[   22.951072] raid6test: test_disks(36, 52): faila=3D 36(D)  failb=3D 52(D=
)  OK
[   22.951952] raid6test: test_disks(36, 53): faila=3D 36(D)  failb=3D 53(D=
)  OK
[   22.970850] raid6test: test_disks(36, 54): faila=3D 36(D)  failb=3D 54(D=
)  OK
[   22.971731] raid6test: test_disks(36, 55): faila=3D 36(D)  failb=3D 55(D=
)  OK
[   22.972625] raid6test: test_disks(36, 56): faila=3D 36(D)  failb=3D 56(D=
)  OK
[   22.973506] raid6test: test_disks(36, 57): faila=3D 36(D)  failb=3D 57(D=
)  OK
[   22.974381] raid6test: test_disks(36, 58): faila=3D 36(D)  failb=3D 58(D=
)  OK
[   22.975260] raid6test: test_disks(36, 59): faila=3D 36(D)  failb=3D 59(D=
)  OK
[   22.976159] raid6test: test_disks(36, 60): faila=3D 36(D)  failb=3D 60(D=
)  OK
[   22.977040] raid6test: test_disks(36, 61): faila=3D 36(D)  failb=3D 61(D=
)  OK
[   22.977911] raid6test: test_disks(36, 62): faila=3D 36(D)  failb=3D 62(P=
)  OK
[   22.978786] raid6test: test_disks(36, 63): faila=3D 36(D)  failb=3D 63(Q=
)  OK
[   22.997736] raid6test: test_disks(37, 38): faila=3D 37(D)  failb=3D 38(D=
)  OK
[   22.998619] raid6test: test_disks(37, 39): faila=3D 37(D)  failb=3D 39(D=
)  OK
[   22.999508] raid6test: test_disks(37, 40): faila=3D 37(D)  failb=3D 40(D=
)  OK
[   23.000374] raid6test: test_disks(37, 41): faila=3D 37(D)  failb=3D 41(D=
)  OK
[   23.001251] raid6test: test_disks(37, 42): faila=3D 37(D)  failb=3D 42(D=
)  OK
[   23.002133] raid6test: test_disks(37, 43): faila=3D 37(D)  failb=3D 43(D=
)  OK
[   23.003028] raid6test: test_disks(37, 44): faila=3D 37(D)  failb=3D 44(D=
)  OK
[   23.003903] raid6test: test_disks(37, 45): faila=3D 37(D)  failb=3D 45(D=
)  OK
[   23.004783] raid6test: test_disks(37, 46): faila=3D 37(D)  failb=3D 46(D=
)  OK
[   23.005665] raid6test: test_disks(37, 47): faila=3D 37(D)  failb=3D 47(D=
)  OK
[   23.031600] raid6test: test_disks(37, 48): faila=3D 37(D)  failb=3D 48(D=
)  OK
[   23.032510] raid6test: test_disks(37, 49): faila=3D 37(D)  failb=3D 49(D=
)  OK
[   23.033388] raid6test: test_disks(37, 50): faila=3D 37(D)  failb=3D 50(D=
)  OK
[   23.034267] raid6test: test_disks(37, 51): faila=3D 37(D)  failb=3D 51(D=
)  OK
[   23.035144] raid6test: test_disks(37, 52): faila=3D 37(D)  failb=3D 52(D=
)  OK
[   23.036027] raid6test: test_disks(37, 53): faila=3D 37(D)  failb=3D 53(D=
)  OK
[   23.036906] raid6test: test_disks(37, 54): faila=3D 37(D)  failb=3D 54(D=
)  OK
[   23.037785] raid6test: test_disks(37, 55): faila=3D 37(D)  failb=3D 55(D=
)  OK
[   23.038664] raid6test: test_disks(37, 56): faila=3D 37(D)  failb=3D 56(D=
)  OK
[   23.039552] raid6test: test_disks(37, 57): faila=3D 37(D)  failb=3D 57(D=
)  OK
[   23.058449] raid6test: test_disks(37, 58): faila=3D 37(D)  failb=3D 58(D=
)  OK
[   23.059341] raid6test: test_disks(37, 59): faila=3D 37(D)  failb=3D 59(D=
)  OK
[   23.060224] raid6test: test_disks(37, 60): faila=3D 37(D)  failb=3D 60(D=
)  OK
[   23.061105] raid6test: test_disks(37, 61): faila=3D 37(D)  failb=3D 61(D=
)  OK
[   23.061980] raid6test: test_disks(37, 62): faila=3D 37(D)  failb=3D 62(P=
)  OK
[   23.062868] raid6test: test_disks(37, 63): faila=3D 37(D)  failb=3D 63(Q=
)  OK
[   23.063746] raid6test: test_disks(38, 39): faila=3D 38(D)  failb=3D 39(D=
)  OK
[   23.064622] raid6test: test_disks(38, 40): faila=3D 38(D)  failb=3D 40(D=
)  OK
[   23.065502] raid6test: test_disks(38, 41): faila=3D 38(D)  failb=3D 41(D=
)  OK
[   23.066405] raid6test: test_disks(38, 42): faila=3D 38(D)  failb=3D 42(D=
)  OK
[   23.067276] raid6test: test_disks(38, 43): faila=3D 38(D)  failb=3D 43(D=
)  OK
[   23.079196] raid6test: test_disks(38, 44): faila=3D 38(D)  failb=3D 44(D=
)  OK
[   23.080072] raid6test: test_disks(38, 45): faila=3D 38(D)  failb=3D 45(D=
)  OK
[   23.080944] raid6test: test_disks(38, 46): faila=3D 38(D)  failb=3D 46(D=
)  OK
[   23.081822] raid6test: test_disks(38, 47): faila=3D 38(D)  failb=3D 47(D=
)  OK
[   23.082703] raid6test: test_disks(38, 48): faila=3D 38(D)  failb=3D 48(D=
)  OK
[   23.083578] raid6test: test_disks(38, 49): faila=3D 38(D)  failb=3D 49(D=
)  OK
[   23.084454] raid6test: test_disks(38, 50): faila=3D 38(D)  failb=3D 50(D=
)  OK
[   23.085325] raid6test: test_disks(38, 51): faila=3D 38(D)  failb=3D 51(D=
)  OK
[   23.086220] raid6test: test_disks(38, 52): faila=3D 38(D)  failb=3D 52(D=
)  OK
[   23.087095] raid6test: test_disks(38, 53): faila=3D 38(D)  failb=3D 53(D=
)  OK
[   23.097038] raid6test: test_disks(38, 54): faila=3D 38(D)  failb=3D 54(D=
)  OK
[   23.097921] raid6test: test_disks(38, 55): faila=3D 38(D)  failb=3D 55(D=
)  OK
[   23.098800] raid6test: test_disks(38, 56): faila=3D 38(D)  failb=3D 56(D=
)  OK
[   23.099688] raid6test: test_disks(38, 57): faila=3D 38(D)  failb=3D 57(D=
)  OK
[   23.100562] raid6test: test_disks(38, 58): faila=3D 38(D)  failb=3D 58(D=
)  OK
[   23.101438] raid6test: test_disks(38, 59): faila=3D 38(D)  failb=3D 59(D=
)  OK
[   23.102310] raid6test: test_disks(38, 60): faila=3D 38(D)  failb=3D 60(D=
)  OK
[   23.103208] raid6test: test_disks(38, 61): faila=3D 38(D)  failb=3D 61(D=
)  OK
[   23.104077] raid6test: test_disks(38, 62): faila=3D 38(D)  failb=3D 62(P=
)  OK
[   23.104948] raid6test: test_disks(38, 63): faila=3D 38(D)  failb=3D 63(Q=
)  OK
[   23.123953] raid6test: test_disks(39, 40): faila=3D 39(D)  failb=3D 40(D=
)  OK
[   23.124836] raid6test: test_disks(39, 41): faila=3D 39(D)  failb=3D 41(D=
)  OK
[   23.125741] raid6test: test_disks(39, 42): faila=3D 39(D)  failb=3D 42(D=
)  OK
[   23.126627] raid6test: test_disks(39, 43): faila=3D 39(D)  failb=3D 43(D=
)  OK
[   23.127501] raid6test: test_disks(39, 44): faila=3D 39(D)  failb=3D 44(D=
)  OK
[   23.128370] raid6test: test_disks(39, 45): faila=3D 39(D)  failb=3D 45(D=
)  OK
[   23.129270] raid6test: test_disks(39, 46): faila=3D 39(D)  failb=3D 46(D=
)  OK
[   23.130155] raid6test: test_disks(39, 47): faila=3D 39(D)  failb=3D 47(D=
)  OK
[   23.131032] raid6test: test_disks(39, 48): faila=3D 39(D)  failb=3D 48(D=
)  OK
[   23.131911] raid6test: test_disks(39, 49): faila=3D 39(D)  failb=3D 49(D=
)  OK
[   23.132801] raid6test: test_disks(39, 50): faila=3D 39(D)  failb=3D 50(D=
)  OK
[   23.133673] raid6test: test_disks(39, 51): faila=3D 39(D)  failb=3D 51(D=
)  OK
[   23.134544] raid6test: test_disks(39, 52): faila=3D 39(D)  failb=3D 52(D=
)  OK
[   23.135423] raid6test: test_disks(39, 53): faila=3D 39(D)  failb=3D 53(D=
)  OK
[   23.136303] raid6test: test_disks(39, 54): faila=3D 39(D)  failb=3D 54(D=
)  OK
[   23.164364] raid6test: test_disks(39, 55): faila=3D 39(D)  failb=3D 55(D=
)  OK
[   23.165255] raid6test: test_disks(39, 56): faila=3D 39(D)  failb=3D 56(D=
)  OK
[   23.166135] raid6test: test_disks(39, 57): faila=3D 39(D)  failb=3D 57(D=
)  OK
[   23.167131] raid6test: test_disks(39, 58): faila=3D 39(D)  failb=3D 58(D=
)  OK
[   23.168009] raid6test: test_disks(39, 59): faila=3D 39(D)  failb=3D 59(D=
)  OK
[   23.168891] raid6test: test_disks(39, 60): faila=3D 39(D)  failb=3D 60(D=
)  OK
[   23.169801] raid6test: test_disks(39, 61): faila=3D 39(D)  failb=3D 61(D=
)  OK
[   23.170674] raid6test: test_disks(39, 62): faila=3D 39(D)  failb=3D 62(P=
)  OK
[   23.171554] raid6test: test_disks(39, 63): faila=3D 39(D)  failb=3D 63(Q=
)  OK
[   23.190515] raid6test: test_disks(40, 41): faila=3D 40(D)  failb=3D 41(D=
)  OK
[   23.191423] raid6test: test_disks(40, 42): faila=3D 40(D)  failb=3D 42(D=
)  OK
[   23.192295] raid6test: test_disks(40, 43): faila=3D 40(D)  failb=3D 43(D=
)  OK
[   23.193178] raid6test: test_disks(40, 44): faila=3D 40(D)  failb=3D 44(D=
)  OK
[   23.194056] raid6test: test_disks(40, 45): faila=3D 40(D)  failb=3D 45(D=
)  OK
[   23.194935] raid6test: test_disks(40, 46): faila=3D 40(D)  failb=3D 46(D=
)  OK
[   23.195837] raid6test: test_disks(40, 47): faila=3D 40(D)  failb=3D 47(D=
)  OK
[   23.196719] raid6test: test_disks(40, 48): faila=3D 40(D)  failb=3D 48(D=
)  OK
[   23.197599] raid6test: test_disks(40, 49): faila=3D 40(D)  failb=3D 49(D=
)  OK
[   23.198476] raid6test: test_disks(40, 50): faila=3D 40(D)  failb=3D 50(D=
)  OK
[   23.199360] raid6test: test_disks(40, 51): faila=3D 40(D)  failb=3D 51(D=
)  OK
[   23.200235] raid6test: test_disks(40, 52): faila=3D 40(D)  failb=3D 52(D=
)  OK
[   23.201106] raid6test: test_disks(40, 53): faila=3D 40(D)  failb=3D 53(D=
)  OK
[   23.201980] raid6test: test_disks(40, 54): faila=3D 40(D)  failb=3D 54(D=
)  OK
[   23.202864] raid6test: test_disks(40, 55): faila=3D 40(D)  failb=3D 55(D=
)  OK
[   23.221893] raid6test: test_disks(40, 56): faila=3D 40(D)  failb=3D 56(D=
)  OK
[   23.222792] raid6test: test_disks(40, 57): faila=3D 40(D)  failb=3D 57(D=
)  OK
[   23.223668] raid6test: test_disks(40, 58): faila=3D 40(D)  failb=3D 58(D=
)  OK
[   23.224542] raid6test: test_disks(40, 59): faila=3D 40(D)  failb=3D 59(D=
)  OK
[   23.225423] raid6test: test_disks(40, 60): faila=3D 40(D)  failb=3D 60(D=
)  OK
[   23.226300] raid6test: test_disks(40, 61): faila=3D 40(D)  failb=3D 61(D=
)  OK
[   23.227166] raid6test: test_disks(40, 62): faila=3D 40(D)  failb=3D 62(P=
)  OK
[   23.228034] raid6test: test_disks(40, 63): faila=3D 40(D)  failb=3D 63(Q=
)  OK
[   23.228911] raid6test: test_disks(41, 42): faila=3D 41(D)  failb=3D 42(D=
)  OK
[   23.229811] raid6test: test_disks(41, 43): faila=3D 41(D)  failb=3D 43(D=
)  OK
[   23.248826] raid6test: test_disks(41, 44): faila=3D 41(D)  failb=3D 44(D=
)  OK
[   23.249714] raid6test: test_disks(41, 45): faila=3D 41(D)  failb=3D 45(D=
)  OK
[   23.250591] raid6test: test_disks(41, 46): faila=3D 41(D)  failb=3D 46(D=
)  OK
[   23.251463] raid6test: test_disks(41, 47): faila=3D 41(D)  failb=3D 47(D=
)  OK
[   23.252331] raid6test: test_disks(41, 48): faila=3D 41(D)  failb=3D 48(D=
)  OK
[   23.253229] raid6test: test_disks(41, 49): faila=3D 41(D)  failb=3D 49(D=
)  OK
[   23.254107] raid6test: test_disks(41, 50): faila=3D 41(D)  failb=3D 50(D=
)  OK
[   23.254982] raid6test: test_disks(41, 51): faila=3D 41(D)  failb=3D 51(D=
)  OK
[   23.255871] raid6test: test_disks(41, 52): faila=3D 41(D)  failb=3D 52(D=
)  OK
[   23.256750] raid6test: test_disks(41, 53): faila=3D 41(D)  failb=3D 53(D=
)  OK
[   23.270803] raid6test: test_disks(41, 54): faila=3D 41(D)  failb=3D 54(D=
)  OK
[   23.271682] raid6test: test_disks(41, 55): faila=3D 41(D)  failb=3D 55(D=
)  OK
[   23.272575] raid6test: test_disks(41, 56): faila=3D 41(D)  failb=3D 56(D=
)  OK
[   23.273459] raid6test: test_disks(41, 57): faila=3D 41(D)  failb=3D 57(D=
)  OK
[   23.274326] raid6test: test_disks(41, 58): faila=3D 41(D)  failb=3D 58(D=
)  OK
[   23.275200] raid6test: test_disks(41, 59): faila=3D 41(D)  failb=3D 59(D=
)  OK
[   23.276089] raid6test: test_disks(41, 60): faila=3D 41(D)  failb=3D 60(D=
)  OK
[   23.276965] raid6test: test_disks(41, 61): faila=3D 41(D)  failb=3D 61(D=
)  OK
[   23.277837] raid6test: test_disks(41, 62): faila=3D 41(D)  failb=3D 62(P=
)  OK
[   23.278710] raid6test: test_disks(41, 63): faila=3D 41(D)  failb=3D 63(Q=
)  OK
[   23.297747] raid6test: test_disks(42, 43): faila=3D 42(D)  failb=3D 43(D=
)  OK
[   23.298630] raid6test: test_disks(42, 44): faila=3D 42(D)  failb=3D 44(D=
)  OK
[   23.299532] raid6test: test_disks(42, 45): faila=3D 42(D)  failb=3D 45(D=
)  OK
[   23.300415] raid6test: test_disks(42, 46): faila=3D 42(D)  failb=3D 46(D=
)  OK
[   23.301285] raid6test: test_disks(42, 47): faila=3D 42(D)  failb=3D 47(D=
)  OK
[   23.302167] raid6test: test_disks(42, 48): faila=3D 42(D)  failb=3D 48(D=
)  OK
[   23.303064] raid6test: test_disks(42, 49): faila=3D 42(D)  failb=3D 49(D=
)  OK
[   23.303946] raid6test: test_disks(42, 50): faila=3D 42(D)  failb=3D 50(D=
)  OK
[   23.304829] raid6test: test_disks(42, 51): faila=3D 42(D)  failb=3D 51(D=
)  OK
[   23.305716] raid6test: test_disks(42, 52): faila=3D 42(D)  failb=3D 52(D=
)  OK
[   23.328725] raid6test: test_disks(42, 53): faila=3D 42(D)  failb=3D 53(D=
)  OK
[   23.329614] raid6test: test_disks(42, 54): faila=3D 42(D)  failb=3D 54(D=
)  OK
[   23.330488] raid6test: test_disks(42, 55): faila=3D 42(D)  failb=3D 55(D=
)  OK
[   23.331354] raid6test: test_disks(42, 56): faila=3D 42(D)  failb=3D 56(D=
)  OK
[   23.332237] raid6test: test_disks(42, 57): faila=3D 42(D)  failb=3D 57(D=
)  OK
[   23.333130] raid6test: test_disks(42, 58): faila=3D 42(D)  failb=3D 58(D=
)  OK
[   23.334012] raid6test: test_disks(42, 59): faila=3D 42(D)  failb=3D 59(D=
)  OK
[   23.334894] raid6test: test_disks(42, 60): faila=3D 42(D)  failb=3D 60(D=
)  OK
[   23.335796] raid6test: test_disks(42, 61): faila=3D 42(D)  failb=3D 61(D=
)  OK
[   23.336666] raid6test: test_disks(42, 62): faila=3D 42(D)  failb=3D 62(P=
)  OK
[   23.346575] raid6test: test_disks(42, 63): faila=3D 42(D)  failb=3D 63(Q=
)  OK
[   23.347475] raid6test: test_disks(43, 44): faila=3D 43(D)  failb=3D 44(D=
)  OK
[   23.348352] raid6test: test_disks(43, 45): faila=3D 43(D)  failb=3D 45(D=
)  OK
[   23.349239] raid6test: test_disks(43, 46): faila=3D 43(D)  failb=3D 46(D=
)  OK
[   23.350121] raid6test: test_disks(43, 47): faila=3D 43(D)  failb=3D 47(D=
)  OK
[   23.350999] raid6test: test_disks(43, 48): faila=3D 43(D)  failb=3D 48(D=
)  OK
[   23.351884] raid6test: test_disks(43, 49): faila=3D 43(D)  failb=3D 49(D=
)  OK
[   23.352786] raid6test: test_disks(43, 50): faila=3D 43(D)  failb=3D 50(D=
)  OK
[   23.353667] raid6test: test_disks(43, 51): faila=3D 43(D)  failb=3D 51(D=
)  OK
[   23.354543] raid6test: test_disks(43, 52): faila=3D 43(D)  failb=3D 52(D=
)  OK
[   23.373451] raid6test: test_disks(43, 53): faila=3D 43(D)  failb=3D 53(D=
)  OK
[   23.374375] raid6test: test_disks(43, 54): faila=3D 43(D)  failb=3D 54(D=
)  OK
[   23.375252] raid6test: test_disks(43, 55): faila=3D 43(D)  failb=3D 55(D=
)  OK
[   23.376155] raid6test: test_disks(43, 56): faila=3D 43(D)  failb=3D 56(D=
)  OK
[   23.377034] raid6test: test_disks(43, 57): faila=3D 43(D)  failb=3D 57(D=
)  OK
[   23.377915] raid6test: test_disks(43, 58): faila=3D 43(D)  failb=3D 58(D=
)  OK
[   23.378793] raid6test: test_disks(43, 59): faila=3D 43(D)  failb=3D 59(D=
)  OK
[   23.379685] raid6test: test_disks(43, 60): faila=3D 43(D)  failb=3D 60(D=
)  OK
[   23.380576] raid6test: test_disks(43, 61): faila=3D 43(D)  failb=3D 61(D=
)  OK
[   23.381442] raid6test: test_disks(43, 62): faila=3D 43(D)  failb=3D 62(P=
)  OK
[   23.382303] raid6test: test_disks(43, 63): faila=3D 43(D)  failb=3D 63(Q=
)  OK
[   23.396202] raid6test: test_disks(44, 45): faila=3D 44(D)  failb=3D 45(D=
)  OK
[   23.397081] raid6test: test_disks(44, 46): faila=3D 44(D)  failb=3D 46(D=
)  OK
[   23.397966] raid6test: test_disks(44, 47): faila=3D 44(D)  failb=3D 47(D=
)  OK
[   23.405843] raid6test: test_disks(44, 48): faila=3D 44(D)  failb=3D 48(D=
)  OK
[   23.406723] raid6test: test_disks(44, 49): faila=3D 44(D)  failb=3D 49(D=
)  OK
[   23.407598] raid6test: test_disks(44, 50): faila=3D 44(D)  failb=3D 50(D=
)  OK
[   23.408477] raid6test: test_disks(44, 51): faila=3D 44(D)  failb=3D 51(D=
)  OK
[   23.409362] raid6test: test_disks(44, 52): faila=3D 44(D)  failb=3D 52(D=
)  OK
[   23.410232] raid6test: test_disks(44, 53): faila=3D 44(D)  failb=3D 53(D=
)  OK
[   23.411104] raid6test: test_disks(44, 54): faila=3D 44(D)  failb=3D 54(D=
)  OK
[   23.411981] raid6test: test_disks(44, 55): faila=3D 44(D)  failb=3D 55(D=
)  OK
[   23.412874] raid6test: test_disks(44, 56): faila=3D 44(D)  failb=3D 56(D=
)  OK
[   23.413755] raid6test: test_disks(44, 57): faila=3D 44(D)  failb=3D 57(D=
)  OK
[   23.432650] raid6test: test_disks(44, 58): faila=3D 44(D)  failb=3D 58(D=
)  OK
[   23.433527] raid6test: test_disks(44, 59): faila=3D 44(D)  failb=3D 59(D=
)  OK
[   23.434403] raid6test: test_disks(44, 60): faila=3D 44(D)  failb=3D 60(D=
)  OK
[   23.435271] raid6test: test_disks(44, 61): faila=3D 44(D)  failb=3D 61(D=
)  OK
[   23.436152] raid6test: test_disks(44, 62): faila=3D 44(D)  failb=3D 62(P=
)  OK
[   23.437019] raid6test: test_disks(44, 63): faila=3D 44(D)  failb=3D 63(Q=
)  OK
[   23.437893] raid6test: test_disks(45, 46): faila=3D 45(D)  failb=3D 46(D=
)  OK
[   23.438769] raid6test: test_disks(45, 47): faila=3D 45(D)  failb=3D 47(D=
)  OK
[   23.439654] raid6test: test_disks(45, 48): faila=3D 45(D)  failb=3D 48(D=
)  OK
[   23.440529] raid6test: test_disks(45, 49): faila=3D 45(D)  failb=3D 49(D=
)  OK
[   23.441396] raid6test: test_disks(45, 50): faila=3D 45(D)  failb=3D 50(D=
)  OK
[   23.458299] raid6test: test_disks(45, 51): faila=3D 45(D)  failb=3D 51(D=
)  OK
[   23.459198] raid6test: test_disks(45, 52): faila=3D 45(D)  failb=3D 52(D=
)  OK
[   23.460080] raid6test: test_disks(45, 53): faila=3D 45(D)  failb=3D 53(D=
)  OK
[   23.460958] raid6test: test_disks(45, 54): faila=3D 45(D)  failb=3D 54(D=
)  OK
[   23.461843] raid6test: test_disks(45, 55): faila=3D 45(D)  failb=3D 55(D=
)  OK
[   23.471738] raid6test: test_disks(45, 56): faila=3D 45(D)  failb=3D 56(D=
)  OK
[   23.472625] raid6test: test_disks(45, 57): faila=3D 45(D)  failb=3D 57(D=
)  OK
[   23.473501] raid6test: test_disks(45, 58): faila=3D 45(D)  failb=3D 58(D=
)  OK
[   23.474372] raid6test: test_disks(45, 59): faila=3D 45(D)  failb=3D 59(D=
)  OK
[   23.475249] raid6test: test_disks(45, 60): faila=3D 45(D)  failb=3D 60(D=
)  OK
[   23.476141] raid6test: test_disks(45, 61): faila=3D 45(D)  failb=3D 61(D=
)  OK
[   23.477010] raid6test: test_disks(45, 62): faila=3D 45(D)  failb=3D 62(P=
)  OK
[   23.477883] raid6test: test_disks(45, 63): faila=3D 45(D)  failb=3D 63(Q=
)  OK
[   23.478766] raid6test: test_disks(46, 47): faila=3D 46(D)  failb=3D 47(D=
)  OK
[   23.479658] raid6test: test_disks(46, 48): faila=3D 46(D)  failb=3D 48(D=
)  OK
[   23.498566] raid6test: test_disks(46, 49): faila=3D 46(D)  failb=3D 49(D=
)  OK
[   23.499469] raid6test: test_disks(46, 50): faila=3D 46(D)  failb=3D 50(D=
)  OK
[   23.500339] raid6test: test_disks(46, 51): faila=3D 46(D)  failb=3D 51(D=
)  OK
[   23.501215] raid6test: test_disks(46, 52): faila=3D 46(D)  failb=3D 52(D=
)  OK
[   23.502099] raid6test: test_disks(46, 53): faila=3D 46(D)  failb=3D 53(D=
)  OK
[   23.502992] raid6test: test_disks(46, 54): faila=3D 46(D)  failb=3D 54(D=
)  OK
[   23.503875] raid6test: test_disks(46, 55): faila=3D 46(D)  failb=3D 55(D=
)  OK
[   23.504755] raid6test: test_disks(46, 56): faila=3D 46(D)  failb=3D 56(D=
)  OK
[   23.505634] raid6test: test_disks(46, 57): faila=3D 46(D)  failb=3D 57(D=
)  OK
[   23.506522] raid6test: test_disks(46, 58): faila=3D 46(D)  failb=3D 58(D=
)  OK
[   23.507392] raid6test: test_disks(46, 59): faila=3D 46(D)  failb=3D 59(D=
)  OK
[   23.526293] raid6test: test_disks(46, 60): faila=3D 46(D)  failb=3D 60(D=
)  OK
[   23.527176] raid6test: test_disks(46, 61): faila=3D 46(D)  failb=3D 61(D=
)  OK
[   23.528048] raid6test: test_disks(46, 62): faila=3D 46(D)  failb=3D 62(P=
)  OK
[   23.528929] raid6test: test_disks(46, 63): faila=3D 46(D)  failb=3D 63(Q=
)  OK
[   23.529823] raid6test: test_disks(47, 48): faila=3D 47(D)  failb=3D 48(D=
)  OK
[   23.530702] raid6test: test_disks(47, 49): faila=3D 47(D)  failb=3D 49(D=
)  OK
[   23.531577] raid6test: test_disks(47, 50): faila=3D 47(D)  failb=3D 50(D=
)  OK
[   23.532464] raid6test: test_disks(47, 51): faila=3D 47(D)  failb=3D 51(D=
)  OK
[   23.533338] raid6test: test_disks(47, 52): faila=3D 47(D)  failb=3D 52(D=
)  OK
[   23.534215] raid6test: test_disks(47, 53): faila=3D 47(D)  failb=3D 53(D=
)  OK
[   23.535098] raid6test: test_disks(47, 54): faila=3D 47(D)  failb=3D 54(D=
)  OK
[   23.535992] raid6test: test_disks(47, 55): faila=3D 47(D)  failb=3D 55(D=
)  OK
[   23.536875] raid6test: test_disks(47, 56): faila=3D 47(D)  failb=3D 56(D=
)  OK
[   23.537758] raid6test: test_disks(47, 57): faila=3D 47(D)  failb=3D 57(D=
)  OK
[   23.551647] raid6test: test_disks(47, 58): faila=3D 47(D)  failb=3D 58(D=
)  OK
[   23.552540] raid6test: test_disks(47, 59): faila=3D 47(D)  failb=3D 59(D=
)  OK
[   23.553424] raid6test: test_disks(47, 60): faila=3D 47(D)  failb=3D 60(D=
)  OK
[   23.554290] raid6test: test_disks(47, 61): faila=3D 47(D)  failb=3D 61(D=
)  OK
[   23.555162] raid6test: test_disks(47, 62): faila=3D 47(D)  failb=3D 62(P=
)  OK
[   23.556054] raid6test: test_disks(47, 63): faila=3D 47(D)  failb=3D 63(Q=
)  OK
[   23.556935] raid6test: test_disks(48, 49): faila=3D 48(D)  failb=3D 49(D=
)  OK
[   23.557819] raid6test: test_disks(48, 50): faila=3D 48(D)  failb=3D 50(D=
)  OK
[   23.558699] raid6test: test_disks(48, 51): faila=3D 48(D)  failb=3D 51(D=
)  OK
[   23.559585] raid6test: test_disks(48, 52): faila=3D 48(D)  failb=3D 52(D=
)  OK
[   23.560465] raid6test: test_disks(48, 53): faila=3D 48(D)  failb=3D 53(D=
)  OK
[   23.561335] raid6test: test_disks(48, 54): faila=3D 48(D)  failb=3D 54(D=
)  OK
[   23.562219] raid6test: test_disks(48, 55): faila=3D 48(D)  failb=3D 55(D=
)  OK
[   23.563107] raid6test: test_disks(48, 56): faila=3D 48(D)  failb=3D 56(D=
)  OK
[   23.563990] raid6test: test_disks(48, 57): faila=3D 48(D)  failb=3D 57(D=
)  OK
[   23.577898] raid6test: test_disks(48, 58): faila=3D 48(D)  failb=3D 58(D=
)  OK
[   23.578781] raid6test: test_disks(48, 59): faila=3D 48(D)  failb=3D 59(D=
)  OK
[   23.579667] raid6test: test_disks(48, 60): faila=3D 48(D)  failb=3D 60(D=
)  OK
[   23.580544] raid6test: test_disks(48, 61): faila=3D 48(D)  failb=3D 61(D=
)  OK
[   23.581414] raid6test: test_disks(48, 62): faila=3D 48(D)  failb=3D 62(P=
)  OK
[   23.582280] raid6test: test_disks(48, 63): faila=3D 48(D)  failb=3D 63(Q=
)  OK
[   23.583177] raid6test: test_disks(49, 50): faila=3D 49(D)  failb=3D 50(D=
)  OK
[   23.584059] raid6test: test_disks(49, 51): faila=3D 49(D)  failb=3D 51(D=
)  OK
[   23.584936] raid6test: test_disks(49, 52): faila=3D 49(D)  failb=3D 52(D=
)  OK
[   23.585830] raid6test: test_disks(49, 53): faila=3D 49(D)  failb=3D 53(D=
)  OK
[   23.586715] raid6test: test_disks(49, 54): faila=3D 49(D)  failb=3D 54(D=
)  OK
[   23.587594] raid6test: test_disks(49, 55): faila=3D 49(D)  failb=3D 55(D=
)  OK
[   23.588475] raid6test: test_disks(49, 56): faila=3D 49(D)  failb=3D 56(D=
)  OK
[   23.589354] raid6test: test_disks(49, 57): faila=3D 49(D)  failb=3D 57(D=
)  OK
[   23.590236] raid6test: test_disks(49, 58): faila=3D 49(D)  failb=3D 58(D=
)  OK
[   23.604125] raid6test: test_disks(49, 59): faila=3D 49(D)  failb=3D 59(D=
)  OK
[   23.605010] raid6test: test_disks(49, 60): faila=3D 49(D)  failb=3D 60(D=
)  OK
[   23.605906] raid6test: test_disks(49, 61): faila=3D 49(D)  failb=3D 61(D=
)  OK
[   23.606777] raid6test: test_disks(49, 62): faila=3D 49(D)  failb=3D 62(P=
)  OK
[   23.607651] raid6test: test_disks(49, 63): faila=3D 49(D)  failb=3D 63(Q=
)  OK
[   23.608532] raid6test: test_disks(50, 51): faila=3D 50(D)  failb=3D 51(D=
)  OK
[   23.609420] raid6test: test_disks(50, 52): faila=3D 50(D)  failb=3D 52(D=
)  OK
[   23.610295] raid6test: test_disks(50, 53): faila=3D 50(D)  failb=3D 53(D=
)  OK
[   23.611179] raid6test: test_disks(50, 54): faila=3D 50(D)  failb=3D 54(D=
)  OK
[   23.612062] raid6test: test_disks(50, 55): faila=3D 50(D)  failb=3D 55(D=
)  OK
[   23.612951] raid6test: test_disks(50, 56): faila=3D 50(D)  failb=3D 56(D=
)  OK
[   23.613831] raid6test: test_disks(50, 57): faila=3D 50(D)  failb=3D 57(D=
)  OK
[   23.614709] raid6test: test_disks(50, 58): faila=3D 50(D)  failb=3D 58(D=
)  OK
[   23.615591] raid6test: test_disks(50, 59): faila=3D 50(D)  failb=3D 59(D=
)  OK
[   23.629495] raid6test: test_disks(50, 60): faila=3D 50(D)  failb=3D 60(D=
)  OK
[   23.630367] raid6test: test_disks(50, 61): faila=3D 50(D)  failb=3D 61(D=
)  OK
[   23.631246] raid6test: test_disks(50, 62): faila=3D 50(D)  failb=3D 62(P=
)  OK
[   23.632120] raid6test: test_disks(50, 63): faila=3D 50(D)  failb=3D 63(Q=
)  OK
[   23.633006] raid6test: test_disks(51, 52): faila=3D 51(D)  failb=3D 52(D=
)  OK
[   23.633887] raid6test: test_disks(51, 53): faila=3D 51(D)  failb=3D 53(D=
)  OK
[   23.634766] raid6test: test_disks(51, 54): faila=3D 51(D)  failb=3D 54(D=
)  OK
[   23.635645] raid6test: test_disks(51, 55): faila=3D 51(D)  failb=3D 55(D=
)  OK
[   23.636540] raid6test: test_disks(51, 56): faila=3D 51(D)  failb=3D 56(D=
)  OK
[   23.637421] raid6test: test_disks(51, 57): faila=3D 51(D)  failb=3D 57(D=
)  OK
[   23.638292] raid6test: test_disks(51, 58): faila=3D 51(D)  failb=3D 58(D=
)  OK
[   23.639182] raid6test: test_disks(51, 59): faila=3D 51(D)  failb=3D 59(D=
)  OK
[   23.640066] raid6test: test_disks(51, 60): faila=3D 51(D)  failb=3D 60(D=
)  OK
[   23.640946] raid6test: test_disks(51, 61): faila=3D 51(D)  failb=3D 61(D=
)  OK
[   23.641818] raid6test: test_disks(51, 62): faila=3D 51(D)  failb=3D 62(P=
)  OK
[   23.660725] raid6test: test_disks(51, 63): faila=3D 51(D)  failb=3D 63(Q=
)  OK
[   23.661603] raid6test: test_disks(52, 53): faila=3D 52(D)  failb=3D 53(D=
)  OK
[   23.662493] raid6test: test_disks(52, 54): faila=3D 52(D)  failb=3D 54(D=
)  OK
[   23.663370] raid6test: test_disks(52, 55): faila=3D 52(D)  failb=3D 55(D=
)  OK
[   23.664249] raid6test: test_disks(52, 56): faila=3D 52(D)  failb=3D 56(D=
)  OK
[   23.665131] raid6test: test_disks(52, 57): faila=3D 52(D)  failb=3D 57(D=
)  OK
[   23.666027] raid6test: test_disks(52, 58): faila=3D 52(D)  failb=3D 58(D=
)  OK
[   23.666915] raid6test: test_disks(52, 59): faila=3D 52(D)  failb=3D 59(D=
)  OK
[   23.667797] raid6test: test_disks(52, 60): faila=3D 52(D)  failb=3D 60(D=
)  OK
[   23.668678] raid6test: test_disks(52, 61): faila=3D 52(D)  failb=3D 61(D=
)  OK
[   23.687573] raid6test: test_disks(52, 62): faila=3D 52(D)  failb=3D 62(P=
)  OK
[   23.688450] raid6test: test_disks(52, 63): faila=3D 52(D)  failb=3D 63(Q=
)  OK
[   23.689329] raid6test: test_disks(53, 54): faila=3D 53(D)  failb=3D 54(D=
)  OK
[   23.690209] raid6test: test_disks(53, 55): faila=3D 53(D)  failb=3D 55(D=
)  OK
[   23.691087] raid6test: test_disks(53, 56): faila=3D 53(D)  failb=3D 56(D=
)  OK
[   23.691967] raid6test: test_disks(53, 57): faila=3D 53(D)  failb=3D 57(D=
)  OK
[   23.692848] raid6test: test_disks(53, 58): faila=3D 53(D)  failb=3D 58(D=
)  OK
[   23.693726] raid6test: test_disks(53, 59): faila=3D 53(D)  failb=3D 59(D=
)  OK
[   23.694606] raid6test: test_disks(53, 60): faila=3D 53(D)  failb=3D 60(D=
)  OK
[   23.695486] raid6test: test_disks(53, 61): faila=3D 53(D)  failb=3D 61(D=
)  OK
[   23.696364] raid6test: test_disks(53, 62): faila=3D 53(D)  failb=3D 62(P=
)  OK
[   23.715272] raid6test: test_disks(53, 63): faila=3D 53(D)  failb=3D 63(Q=
)  OK
[   23.716173] raid6test: test_disks(54, 55): faila=3D 54(D)  failb=3D 55(D=
)  OK
[   23.717052] raid6test: test_disks(54, 56): faila=3D 54(D)  failb=3D 56(D=
)  OK
[   23.717933] raid6test: test_disks(54, 57): faila=3D 54(D)  failb=3D 57(D=
)  OK
[   23.718817] raid6test: test_disks(54, 58): faila=3D 54(D)  failb=3D 58(D=
)  OK
[   23.719714] raid6test: test_disks(54, 59): faila=3D 54(D)  failb=3D 59(D=
)  OK
[   23.720596] raid6test: test_disks(54, 60): faila=3D 54(D)  failb=3D 60(D=
)  OK
[   23.721475] raid6test: test_disks(54, 61): faila=3D 54(D)  failb=3D 61(D=
)  OK
[   23.722340] raid6test: test_disks(54, 62): faila=3D 54(D)  failb=3D 62(P=
)  OK
[   23.723223] raid6test: test_disks(54, 63): faila=3D 54(D)  failb=3D 63(Q=
)  OK
[   23.724104] raid6test: test_disks(55, 56): faila=3D 55(D)  failb=3D 56(D=
)  OK
[   23.724985] raid6test: test_disks(55, 57): faila=3D 55(D)  failb=3D 57(D=
)  OK
[   23.725873] raid6test: test_disks(55, 58): faila=3D 55(D)  failb=3D 58(D=
)  OK
[   23.726754] raid6test: test_disks(55, 59): faila=3D 55(D)  failb=3D 59(D=
)  OK
[   23.740660] raid6test: test_disks(55, 60): faila=3D 55(D)  failb=3D 60(D=
)  OK
[   23.741538] raid6test: test_disks(55, 61): faila=3D 55(D)  failb=3D 61(D=
)  OK
[   23.742426] raid6test: test_disks(55, 62): faila=3D 55(D)  failb=3D 62(P=
)  OK
[   23.743299] raid6test: test_disks(55, 63): faila=3D 55(D)  failb=3D 63(Q=
)  OK
[   23.744176] raid6test: test_disks(56, 57): faila=3D 56(D)  failb=3D 57(D=
)  OK
[   23.745057] raid6test: test_disks(56, 58): faila=3D 56(D)  failb=3D 58(D=
)  OK
[   23.745946] raid6test: test_disks(56, 59): faila=3D 56(D)  failb=3D 59(D=
)  OK
[   23.746824] raid6test: test_disks(56, 60): faila=3D 56(D)  failb=3D 60(D=
)  OK
[   23.747705] raid6test: test_disks(56, 61): faila=3D 56(D)  failb=3D 61(D=
)  OK
[   23.748580] raid6test: test_disks(56, 62): faila=3D 56(D)  failb=3D 62(P=
)  OK
[   23.749471] raid6test: test_disks(56, 63): faila=3D 56(D)  failb=3D 63(Q=
)  OK
[   23.750343] raid6test: test_disks(57, 58): faila=3D 57(D)  failb=3D 58(D=
)  OK
[   23.751224] raid6test: test_disks(57, 59): faila=3D 57(D)  failb=3D 59(D=
)  OK
[   23.752105] raid6test: test_disks(57, 60): faila=3D 57(D)  failb=3D 60(D=
)  OK
[   23.752992] raid6test: test_disks(57, 61): faila=3D 57(D)  failb=3D 61(D=
)  OK
[   23.766879] raid6test: test_disks(57, 62): faila=3D 57(D)  failb=3D 62(P=
)  OK
[   23.767752] raid6test: test_disks(57, 63): faila=3D 57(D)  failb=3D 63(Q=
)  OK
[   23.768638] raid6test: test_disks(58, 59): faila=3D 58(D)  failb=3D 59(D=
)  OK
[   23.769530] raid6test: test_disks(58, 60): faila=3D 58(D)  failb=3D 60(D=
)  OK
[   23.770413] raid6test: test_disks(58, 61): faila=3D 58(D)  failb=3D 61(D=
)  OK
[   23.771275] raid6test: test_disks(58, 62): faila=3D 58(D)  failb=3D 62(P=
)  OK
[   23.772153] raid6test: test_disks(58, 63): faila=3D 58(D)  failb=3D 63(Q=
)  OK
[   23.773042] raid6test: test_disks(59, 60): faila=3D 59(D)  failb=3D 60(D=
)  OK
[   23.773920] raid6test: test_disks(59, 61): faila=3D 59(D)  failb=3D 61(D=
)  OK
[   23.774791] raid6test: test_disks(59, 62): faila=3D 59(D)  failb=3D 62(P=
)  OK
[   23.775671] raid6test: test_disks(59, 63): faila=3D 59(D)  failb=3D 63(Q=
)  OK
[   23.776557] raid6test: test_disks(60, 61): faila=3D 60(D)  failb=3D 61(D=
)  OK
[   23.777430] raid6test: test_disks(60, 62): faila=3D 60(D)  failb=3D 62(P=
)  OK
[   23.778296] raid6test: test_disks(60, 63): faila=3D 60(D)  failb=3D 63(Q=
)  OK
[   23.779181] raid6test: test_disks(61, 62): faila=3D 61(D)  failb=3D 62(P=
)  OK
[   23.793071] raid6test: test_disks(61, 63): faila=3D 61(D)  failb=3D 63(Q=
)  OK
[   23.793928] raid6test: test_disks(62, 63): faila=3D 62(P)  failb=3D 63(Q=
)  OK
[   23.794658] raid6test:=20
[   23.794929] raid6test: complete (2429 tests, 0 failures)
[   23.804842]   Magic number: 15:624:633
[   23.805736] rtc_cmos 00:00: setting system clock to 2015-01-24 12:38:31 =
UTC (1422103111)
[   23.806728] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[   23.807462] EDD information not available.
[   23.808445] debug: unmapping init [mem 0xcdd06000-0xcddadfff]
mount: mounting proc on /proc failed: No such device
/etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: No such file or directory
[   23.836726] S00fbsetup (1369) used greatest stack depth: 6988 bytes left

Please wait: booting...
mount: mounting proc on /proc failed: No such device
grep: /proc/filesystems: No such file or directory
Starting Bootlog daemon: bootlogd: cannot allocate pseudo tty: No such file=
 or directory
bootlogd.
mount: can't read '/proc/mounts': No such file or directory
[   23.891961] mount (1387) used greatest stack depth: 6940 bytes left
/etc/rcS.d/S37populate-volatile.sh: line 172: /proc/cmdline: No such file o=
r directory
grep: /proc/filesystems: No such file or directory
Configuring network interfaces... ifconfig: socket: Address family not supp=
orted by protocol
ifup: can't open '/var/run/ifstate': No such file or directory
done.
hwclock: can't open '/dev/misc/rtc': No such file or directory
Running postinst /etc/rpm-postinsts/100...
mount: no /proc/mounts
wfg: skip syslogd
Kernel tests: Boot OK!
Kernel tests: Boot OK!
mount: mounting proc on /proc failed: No such device
/etc/rc5.d/S99-rc.local: line 19: /proc/1438/oom_score_adj: No such file or=
 directory
sed: /lib/modules/3.19.0-rc4-gd26bb7f/modules.dep: No such file or directory
xargs: modprobe: No such file or directory
[   24.057020] 01-modprobe (1441) used greatest stack depth: 6932 bytes left
run-parts: /etc/kernel-tests/01-modprobe exited with code 127
grep: /proc/cmdline: No such file or directory
grep: /proc/cmdline: No such file or directory
Trinity v1.4pre  Dave Jones <davej@redhat.com>
[   24.078601] random: trinity urandom read with 5 bits of entropy available
Trinity v1.4pre  Dave Jones <davej@redhat.com>
Trinity v1.4pre  Dave Jones <davej@redhat.com>
[init] Marking syscall get_robust_list (312) as to be disabled.
Done parsing arguments.
Marking all syscalls as enabled.
[init] Disabling syscalls marked as disabled by command line options
[init] Marked syscall get_robust_list (312) as deactivated.
[init] Enabled 350 syscalls. Disabled 1 syscalls.
DANGER: RUNNING AS ROOT.
Trinity v1.4pre  Dave Jones <davej@redhat.com>
Done parsing arguments.
Marking all syscalls as enabled.
[init] Enabled 351 syscalls. Disabled 0 syscalls.
DANGER: RUNNING AS ROOT.
Unless you are running in a virtual machine, this could cause serious probl=
ems such as overwriting CMOS
or similar which could potentially make this machine unbootable without a f=
irmware reset.

Done parsing arguments.
## couldn't open logfile trinity.log
Unless you are running in a virtual machine, this could cause serious probl=
ems such as overwriting CMOS
or similar which could potentially make this machine unbootable without a f=
irmware reset.

ctrl-c now unless you really know what you are doing.
ctrl-c now unless you really know what you are doing.
Done parsing arguments.
## couldn't open logfile trinity.log
Couldn't read pid_max from proc
[init] Using pid_max =3D 32768
[init] Kernel was tainted on startup. Will ignore flags that are already se=
t.
[init] Started watchdog process, PID is 1456
[main] Main thread is alive.
[main] Couldn't find socket cachefile. Regenerating.
[main] Setsockopt(1 7 80d1000 4) on fd 7 [1:1:1]
[main] Setsockopt(1 9 80d1000 b7) on fd 8 [1:5:1]
[main] Setsockopt(1 22 80d1000 35) on fd 9 [1:1:1]
[main] Setsockopt(1 2d 80d1000 d2) on fd 11 [1:1:1]
[main] Setsockopt(1 10 80d1000 4) on fd 13 [16:2:4]
fopen: No such file or directory
Couldn't read pid_max from proc
[init] Using pid_max =3D 32768
[init] Kernel was tainted on startup. Will ignore flags that are already se=
t.
[init] Started watchdog process, PID is 1458
[main] Setsockopt(1 2 80d1000 4) on fd 14 [1:2:1]
[main] Setsockopt(1 b 80d1000 9b) on fd 16 [16:2:2]
[   34.236550] sock: process `trinity-main' is using obsolete setsockopt SO=
_BSDCOMPAT
[main] Setsockopt(1 e 80d1000 4) on fd 17 [1:5:1]
[main] Setsockopt(1 7 80d1000 ec) on fd 20 [16:3:4]
[main] Main thread is alive.
[main] Setsockopt(1 2a 80d1000 8) on fd 21 [1:2:1]
[main] Setsockopt(10e 3 80d1000 4) on fd 23 [16:3:15]
[main] Setsockopt(1 2b 80d1000 9e) on fd 24 [1:5:1]
[main] Setsockopt(1 24 80d1000 91) on fd 26 [1:2:1]
[main] Setsockopt(1 21 80d1000 7) on fd 27 [16:3:2]
[main] Setsockopt(1 2f 80d1000 4) on fd 28 [1:2:1]
[main] Setsockopt(1 2e 80d1000 4) on fd 30 [1:5:1]
[main] Setsockopt(1 12 80d1000 4) on fd 31 [1:2:1]
[main] Setsockopt(1 a 80d1000 fb) on fd 32 [16:3:0]
[main] Setsockopt(1 1d 80d1000 4) on fd 36 [1:2:1]
[main] Setsockopt(1 10 80d1000 4) on fd 37 [1:1:1]
[main] Setsockopt(1 10 80d1000 a2) on fd 38 [1:2:1]
[main] Setsockopt(1 23 80d1000 4) on fd 39 [1:1:1]
[main] Setsockopt(1 5 80d1000 c1) on fd 40 [1:5:1]
[main] Setsockopt(1 23 80d1000 43) on fd 42 [1:5:1]
[main] Setsockopt(1 12 80d1000 4) on fd 44 [1:1:1]
[main] Setsockopt(1 6 80d1000 4) on fd 47 [16:2:16]
[main] Setsockopt(1 22 80d1000 96) on fd 48 [1:1:1]
[main] Setsockopt(1 d 80d1000 8) on fd 50 [1:1:1]
[main] Setsockopt(1 12 80d1000 18) on fd 51 [1:1:1]
[main] Setsockopt(1 a 80d1000 9b) on fd 52 [16:3:4]
[main] Setsockopt(1 f 80d1000 4) on fd 59 [16:2:4]
[main] Setsockopt(1 2b 80d1000 4) on fd 60 [1:2:1]
[main] Setsockopt(1 2a 80d1000 4) on fd 61 [1:5:1]
[main] Setsockopt(10e 2 80d1000 4) on fd 62 [16:3:15]
[main] Setsockopt(1 8 80d1000 4) on fd 64 [16:2:16]
[main] Setsockopt(10e 1 80d1000 f6) on fd 66 [16:2:2]
[main] Setsockopt(1 2f 80d1000 4) on fd 67 [1:1:1]
[main] Setsockopt(1 8 80d1000 7e) on fd 70 [1:2:1]
[main] Setsockopt(1 f 80d1000 4) on fd 71 [1:1:1]
[main] Setsockopt(1 b 80d1000 4) on fd 72 [1:1:1]
[main] Setsockopt(1 2f 80d1000 2b) on fd 73 [1:1:1]
[main] Setsockopt(1 2e 80d1000 4) on fd 74 [1:2:1]
[main] Setsockopt(1 28 80d1000 4) on fd 75 [1:2:1]
[main] Setsockopt(10e 1 80d1000 4) on fd 76 [16:3:16]
[main] Setsockopt(1 2b 80d1000 4) on fd 79 [1:1:1]
[main] Setsockopt(1 29 80d1000 d6) on fd 84 [1:5:1]
[main] Setsockopt(1 10 80d1000 1e) on fd 86 [1:1:1]
[main] Setsockopt(1 1d 80d1000 85) on fd 87 [1:1:1]
[main] Setsockopt(10e 3 80d1000 4) on fd 88 [16:3:15]
[main] Setsockopt(1 e 80d1000 4) on fd 89 [1:1:1]
[main] Setsockopt(1 d 80d1000 8) on fd 91 [1:1:1]
[main] Setsockopt(1 10 80d1000 1a) on fd 92 [1:1:1]
[main] Setsockopt(1 e 80d1000 6d) on fd 94 [1:1:1]
[main] Setsockopt(1 9 80d1000 71) on fd 96 [1:2:1]
[main] Setsockopt(1 2c 80d1000 4) on fd 97 [1:1:1]
[main] Setsockopt(1 f 80d1000 4) on fd 100 [1:2:1]
[main] Setsockopt(1 29 80d1000 1e) on fd 101 [16:3:2]
[main] Setsockopt(1 8 80d1000 dc) on fd 102 [1:5:1]
[main] Setsockopt(1 20 80d1000 ba) on fd 103 [1:5:1]
[main] Setsockopt(1 2b 80d1000 21) on fd 104 [1:2:1]
[main] Setsockopt(1 28 80d1000 f4) on fd 105 [1:2:1]
[main] Setsockopt(1 28 80d1000 4) on fd 110 [1:1:1]
[main] Setsockopt(1 12 80d1000 f1) on fd 111 [1:1:1]
[main] Setsockopt(1 2f 80d1000 9d) on fd 112 [1:1:1]
[main] Setsockopt(1 8 80d1000 4) on fd 118 [1:5:1]
[main] Setsockopt(1 d 80d1000 8) on fd 120 [1:5:1]
[main] Setsockopt(1 b 80d1000 4) on fd 124 [1:1:1]
[main] Setsockopt(1 6 80d1000 1d) on fd 125 [1:5:1]
[main] Setsockopt(1 2b 80d1000 4) on fd 126 [16:2:2]
[main] Setsockopt(10e 3 80d1000 4) on fd 128 [16:3:0]
[main] Setsockopt(1 2f 80d1000 1e) on fd 129 [1:1:1]
[main] Setsockopt(1 7 80d1000 4) on fd 132 [1:2:1]
[main] Setsockopt(1 28 80d1000 4) on fd 133 [1:2:1]
[main] Setsockopt(1 24 80d1000 4) on fd 134 [16:2:4]
[main] Setsockopt(1 b 80d1000 61) on fd 136 [1:2:1]
[main] Setsockopt(10e 3 80d1000 4) on fd 137 [16:3:2]
[main] Setsockopt(1 29 80d1000 4) on fd 138 [1:5:1]
[main] Setsockopt(1 1 80d1000 d1) on fd 139 [1:2:1]
[main] Setsockopt(1 1 80d1000 e6) on fd 140 [16:2:15]
[main] Setsockopt(10e 5 80d1000 4) on fd 142 [16:2:15]
[main] Setsockopt(1 23 80d1000 4) on fd 145 [1:1:1]
[main] Setsockopt(1 6 80d1000 f5) on fd 146 [16:2:0]
[main] Setsockopt(1 2a 80d1000 4) on fd 148 [1:2:1]
[main] Setsockopt(1 25 80d1000 4) on fd 149 [16:2:2]
[main] Setsockopt(1 a 80d1000 a) on fd 150 [1:1:1]
[main] Setsockopt(10e 4 80d1000 e4) on fd 151 [16:2:16]
[main] Setsockopt(1 2c 80d1000 4) on fd 153 [1:2:1]
[main] Setsockopt(1 2 80d1000 4) on fd 155 [16:3:15]
[main] Setsockopt(1 c 80d1000 4) on fd 156 [1:5:1]
[main] Setsockopt(1 2d 80d1000 4) on fd 157 [16:3:4]
[main] Setsockopt(1 a 80d1000 4) on fd 159 [1:1:1]
[main] Setsockopt(1 8 80d1000 4) on fd 161 [1:1:1]
[main] Setsockopt(10e 4 80d1000 4) on fd 162 [16:3:15]
[main] Setsockopt(1 f 80d1000 4) on fd 163 [1:1:1]
[main] Setsockopt(1 24 80d1000 75) on fd 164 [1:5:1]
[main] Setsockopt(1 24 80d1000 4) on fd 165 [1:5:1]
[main] Setsockopt(1 22 80d1000 4) on fd 168 [1:2:1]
[main] Setsockopt(1 f 80d1000 4) on fd 169 [1:5:1]
[main] Setsockopt(1 2c 80d1000 4) on fd 171 [1:2:1]
[main] Setsockopt(1 12 80d1000 1c) on fd 172 [1:2:1]
[main] Setsockopt(1 21 80d1000 71) on fd 175 [1:5:1]
[main] Setsockopt(1 1d 80d1000 4) on fd 176 [16:2:0]
[main] Setsockopt(1 e 80d1000 4) on fd 177 [1:1:1]
[main] Setsockopt(1 8 80d1000 72) on fd 179 [1:5:1]
[main] Setsockopt(1 7 80d1000 d3) on fd 181 [1:2:1]
[main] Setsockopt(1 a 80d1000 8d) on fd 182 [1:2:1]
[main] Setsockopt(1 2e 80d1000 d6) on fd 183 [1:5:1]
[main] Setsockopt(1 23 80d1000 53) on fd 186 [1:5:1]
[main] Setsockopt(1 8 80d1000 4) on fd 187 [1:5:1]
[main] Setsockopt(1 10 80d1000 4) on fd 188 [16:3:16]
[main] Setsockopt(1 2 80d1000 8d) on fd 189 [1:1:1]
[main] Setsockopt(1 2a 80d1000 be) on fd 190 [1:5:1]
[main] Setsockopt(10e 5 80d1000 4) on fd 191 [16:3:2]
[main] Setsockopt(1 2f 80d1000 f1) on fd 192 [1:5:1]
[main] Setsockopt(1 20 80d1000 4) on fd 193 [1:2:1]
[main] Setsockopt(1 29 80d1000 e8) on fd 197 [1:2:1]
[main] Setsockopt(1 21 80d1000 4) on fd 198 [1:2:1]
[main] Setsockopt(1 23 80d1000 ce) on fd 199 [1:5:1]
[main] Setsockopt(1 1 80d1000 4) on fd 200 [16:3:2]
[main] Setsockopt(1 2 80d1000 40) on fd 201 [1:1:1]
[main] Setsockopt(1 20 80d1000 4) on fd 202 [1:1:1]
[main] Setsockopt(1 20 80d1000 4) on fd 204 [16:2:16]
[main] Setsockopt(1 2d 80d1000 4) on fd 205 [1:5:1]
[main] Setsockopt(1 28 80d1000 4) on fd 207 [1:5:1]
[main] Setsockopt(1 28 80d1000 f4) on fd 212 [16:2:0]
[main] Setsockopt(1 f 80d1000 4) on fd 213 [1:5:1]
[main] Setsockopt(1 29 80d1000 32) on fd 214 [1:5:1]
[main] Setsockopt(10e 3 80d1000 4) on fd 215 [16:3:16]
[main] Setsockopt(1 1d 80d1000 4) on fd 217 [1:1:1]
[main] Setsockopt(1 2 80d1000 4) on fd 220 [16:3:16]
[main] Setsockopt(1 25 80d1000 38) on fd 223 [1:5:1]
[main] Setsockopt(1 7 80d1000 cf) on fd 224 [1:5:1]
[main] Setsockopt(1 2b 80d1000 db) on fd 225 [1:5:1]
[main] Setsockopt(1 24 80d1000 4) on fd 227 [1:5:1]
[main] Setsockopt(1 29 80d1000 4) on fd 228 [16:2:15]
[main] Setsockopt(1 9 80d1000 4) on fd 229 [1:2:1]
[main] Setsockopt(10e 4 80d1000 4) on fd 232 [16:3:0]
[main] Setsockopt(1 28 80d1000 4) on fd 238 [1:2:1]
[main] Setsockopt(1 d 80d1000 8) on fd 241 [1:1:1]
[main] Setsockopt(1 2e 80d1000 e6) on fd 242 [1:2:1]
[main] Setsockopt(1 23 80d1000 71) on fd 244 [1:1:1]
[main] Setsockopt(10e 5 80d1000 4) on fd 245 [16:2:0]
[main] Setsockopt(1 f 80d1000 d5) on fd 246 [1:1:1]
[main] Setsockopt(1 23 80d1000 c7) on fd 247 [1:5:1]
[main] Setsockopt(1 2d 80d1000 46) on fd 248 [1:2:1]
[main] Setsockopt(1 b 80d1000 43) on fd 249 [1:2:1]
[main] Setsockopt(10e 4 80d1000 ad) on fd 250 [16:2:4]
[main] Setsockopt(1 12 80d1000 86) on fd 252 [16:2:15]
[main] Setsockopt(1 2 80d1000 27) on fd 253 [1:5:1]
[main] Setsockopt(10e 5 80d1000 41) on fd 254 [16:3:4]
[main] Setsockopt(10e 5 80d1000 4) on fd 256 [16:3:16]
[main] Setsockopt(1 5 80d1000 4) on fd 257 [1:2:1]
[main] Setsockopt(1 2d 80d1000 84) on fd 261 [1:5:1]
[main] Setsockopt(1 24 80d1000 4) on fd 262 [1:2:1]
[main] Setsockopt(1 7 80d1000 27) on fd 265 [1:1:1]
[main] Setsockopt(10e 4 80d1000 4) on fd 266 [16:3:2]
[main] Setsockopt(1 29 80d1000 af) on fd 267 [1:1:1]
[main] Setsockopt(1 2d 80d1000 6c) on fd 268 [1:5:1]
[main] Setsockopt(1 2e 80d1000 4) on fd 269 [1:1:1]
[main] Setsockopt(1 23 80d1000 4) on fd 272 [16:2:4]
[main] Setsockopt(1 25 80d1000 4) on fd 273 [1:5:1]
[main] Setsockopt(1 8 80d1000 30) on fd 274 [1:5:1]
[main] Setsockopt(1 2c 80d1000 e) on fd 275 [1:5:1]
[main] Setsockopt(1 29 80d1000 a1) on fd 276 [1:1:1]
[main] Setsockopt(1 12 80d1000 4) on fd 277 [1:5:1]
[main] Setsockopt(1 5 80d1000 c4) on fd 279 [1:2:1]
[main] Setsockopt(10e 2 80d1000 4) on fd 280 [16:3:4]
[main] Setsockopt(1 21 80d1000 4) on fd 282 [16:2:4]
[main] Setsockopt(1 24 80d1000 4) on fd 286 [1:2:1]
[main] Setsockopt(1 12 80d1000 a9) on fd 287 [1:2:1]
[main] Setsockopt(1 2d 80d1000 4) on fd 288 [1:5:1]
[main] Setsockopt(10e 4 80d1000 a4) on fd 289 [16:2:2]
[main] Setsockopt(1 10 80d1000 4) on fd 290 [1:2:1]
[main] Setsockopt(1 c 80d1000 30) on fd 292 [16:2:15]
[main] Setsockopt(10e 5 80d1000 4) on fd 294 [16:2:2]
[main] Setsockopt(1 12 80d1000 4) on fd 296 [1:1:1]
[main] Setsockopt(1 21 80d1000 67) on fd 297 [1:2:1]
[main] Setsockopt(1 12 80d1000 a2) on fd 300 [1:2:1]
[main] Setsockopt(1 2a 80d1000 c2) on fd 301 [1:2:1]
[main] Setsockopt(1 23 80d1000 4) on fd 302 [1:5:1]
[main] Setsockopt(1 23 80d1000 4) on fd 305 [1:2:1]
[main] Setsockopt(1 5 80d1000 34) on fd 306 [1:1:1]
[main] Setsockopt(1 1 80d1000 8d) on fd 307 [1:2:1]
[main] Setsockopt(1 a 80d1000 28) on fd 314 [1:5:1]
[main] Setsockopt(1 a 80d1000 4) on fd 316 [16:2:4]
[main] Setsockopt(1 9 80d1000 4) on fd 317 [1:1:1]
[main] Setsockopt(1 8 80d1000 b2) on fd 320 [1:2:1]
[main] Setsockopt(1 d 80d1000 8) on fd 323 [1:2:1]
[main] Setsockopt(1 20 80d1000 6f) on fd 324 [1:5:1]
[main] Setsockopt(1 14 80d1000 8) on fd 325 [1:2:1]
[main] Setsockopt(1 20 80d1000 32) on fd 330 [16:3:2]
[main] Setsockopt(1 1d 80d1000 d4) on fd 331 [1:1:1]
[main] Setsockopt(1 2f 80d1000 90) on fd 332 [1:2:1]
[main] Setsockopt(1 a 80d1000 4) on fd 334 [1:1:1]
[main] Setsockopt(10e 3 80d1000 f7) on fd 335 [16:2:0]
[main] Setsockopt(1 a 80d1000 4) on fd 336 [1:5:1]
[main] Setsockopt(1 24 80d1000 4b) on fd 337 [1:2:1]
[main] Setsockopt(1 21 80d1000 4) on fd 338 [1:1:1]
[main] Setsockopt(1 1 80d1000 78) on fd 339 [1:1:1]
[main] Setsockopt(1 28 80d1000 34) on fd 340 [1:1:1]
[main] Setsockopt(1 14 80d1000 8) on fd 341 [1:2:1]
[main] Setsockopt(1 2f 80d1000 f1) on fd 342 [1:2:1]
[main] Setsockopt(1 14 80d1000 8) on fd 343 [1:2:1]
[main] Setsockopt(1 2b 80d1000 4) on fd 344 [1:2:1]
[main] Setsockopt(10e 3 80d1000 4) on fd 346 [16:2:4]
[main] Setsockopt(1 24 80d1000 bb) on fd 348 [1:2:1]
[main] Setsockopt(1 28 80d1000 d2) on fd 350 [1:1:1]
[main] Setsockopt(1 12 80d1000 4) on fd 351 [1:2:1]
[main] Setsockopt(1 a 80d1000 8f) on fd 353 [1:5:1]
[main] Setsockopt(1 28 80d1000 94) on fd 356 [1:5:1]
[main] Setsockopt(1 d 80d1000 8) on fd 361 [1:5:1]
[main] Setsockopt(1 1d 80d1000 87) on fd 364 [1:5:1]
[main] Setsockopt(1 10 80d1000 4) on fd 365 [1:1:1]
[main] Setsockopt(1 c 80d1000 4) on fd 368 [1:1:1]
[main] Setsockopt(1 2c 80d1000 4) on fd 370 [1:2:1]
[main] Setsockopt(1 a 80d1000 4) on fd 371 [16:2:16]
[main] Setsockopt(1 e 80d1000 4) on fd 372 [1:1:1]
[main] Setsockopt(10e 4 80d1000 cc) on fd 374 [16:3:2]
[main] Setsockopt(1 2f 80d1000 4) on fd 375 [1:5:1]
[main] Setsockopt(1 2a 80d1000 4) on fd 376 [1:1:1]
[main] Setsockopt(1 8 80d1000 14) on fd 378 [1:1:1]
[main] Setsockopt(1 1d 80d1000 8f) on fd 379 [1:5:1]
[main] Setsockopt(1 f 80d1000 88) on fd 380 [16:2:4]
[main] Setsockopt(1 2b 80d1000 4) on fd 6 [1:2:1]
[main] Setsockopt(1 22 80d1000 8c) on fd 8 [1:5:1]
[main] Setsockopt(1 e 80d1000 bc) on fd 9 [1:1:1]
[main] Setsockopt(1 2b 80d1000 4) on fd 12 [1:5:1]
[main] Setsockopt(1 2b 80d1000 4) on fd 13 [16:2:4]
[main] Setsockopt(1 e 80d1000 4) on fd 15 [1:1:1]
[main] created 375 sockets
[main] Setsockopt(10e 5 80d1000 4) on fd 16 [16:2:2]
[main] Setsockopt(1 12 80d1000 4) on fd 18 [1:1:1]
[main] Setsockopt(1 d 80d1000 8) on fd 19 [1:5:1]
[main] Setsockopt(1 20 80d1000 ec) on fd 20 [16:3:4]
[main] Setsockopt(1 10 80d1000 4) on fd 22 [1:5:1]
[main] Setsockopt(1 1d 80d1000 35) on fd 23 [16:3:15]
[main] Setsockopt(1 5 80d1000 aa) on fd 24 [1:5:1]
[main] Setsockopt(1 1d 80d1000 93) on fd 25 [1:2:1]
[main] Setsockopt(1 c 80d1000 4) on fd 26 [1:2:1]
[main] Setsockopt(1 10 80d1000 4) on fd 27 [16:3:2]
[main] Setsockopt(1 2a 80d1000 ce) on fd 28 [1:2:1]
[main] Setsockopt(1 2f 80d1000 4) on fd 29 [1:2:1]
[main] Setsockopt(1 1 80d1000 bd) on fd 30 [1:5:1]
[main] Setsockopt(1 5 80d1000 90) on fd 31 [1:2:1]
[main] Setsockopt(1 c 80d1000 e1) on fd 33 [1:2:1]
[main] Setsockopt(1 5 80d1000 71) on fd 34 [1:2:1]
[main] Setsockopt(10e 3 80d1000 62) on fd 35 [16:3:4]
[main] Setsockopt(1 5 80d1000 60) on fd 36 [1:2:1]
[main] Setsockopt(1 2b 80d1000 e) on fd 41 [16:3:15]
[main] Setsockopt(1 25 80d1000 4) on fd 44 [1:1:1]
[main] Setsockopt(1 1d 80d1000 b2) on fd 45 [1:2:1]
[main] Setsockopt(1 2c 80d1000 4) on fd 47 [16:2:16]
[main] Setsockopt(1 2a 80d1000 22) on fd 48 [1:1:1]
[main] Setsockopt(1 23 80d1000 5f) on fd 54 [1:2:1]
[main] Setsockopt(1 22 80d1000 4) on fd 55 [1:2:1]
[main] Setsockopt(1 2c 80d1000 6d) on fd 56 [1:2:1]
[main] Setsockopt(1 f 80d1000 4) on fd 58 [1:2:1]
[main] Setsockopt(1 24 80d1000 4) on fd 60 [1:2:1]
[main] Setsockopt(1 5 80d1000 b) on fd 63 [1:5:1]
[main] Setsockopt(1 5 80d1000 4) on fd 66 [16:2:2]
[main] Setsockopt(1 12 80d1000 5b) on fd 67 [1:1:1]
[main] Setsockopt(1 2c 80d1000 d7) on fd 69 [1:5:1]
[main] Setsockopt(1 2f 80d1000 4) on fd 71 [1:1:1]
[main] Setsockopt(1 23 80d1000 4) on fd 74 [1:2:1]
[main] Setsockopt(1 c 80d1000 3a) on fd 75 [1:2:1]
[main] Setsockopt(1 1d 80d1000 4) on fd 77 [1:2:1]
[main] Setsockopt(1 5 80d1000 4) on fd 78 [1:5:1]
[main] Setsockopt(1 2f 80d1000 4) on fd 79 [1:1:1]
[main] Generating file descriptors
[main] Added 50 filenames from /dev
[main] Added 1 filenames from /proc
[main] Added 1 filenames from /sys
[main] Setsockopt(1 1 80d1000 4) on fd 80 [1:2:1]
[main] Setsockopt(1 28 80d1000 c4) on fd 81 [16:2:2]
[main] Setsockopt(1 5 80d1000 4) on fd 82 [1:2:1]
[main] Setsockopt(1 24 80d1000 85) on fd 83 [1:5:1]
[main] Setsockopt(1 2b 80d1000 4) on fd 84 [1:5:1]
[main] Setsockopt(1 2a 80d1000 e2) on fd 85 [1:5:1]
[main] Setsockopt(1 8 80d1000 4) on fd 86 [1:1:1]
[main] Setsockopt(1 2a 80d1000 4) on fd 87 [1:1:1]
[   34.700861] ------------[ cut here ]------------
[   34.701372] WARNING: CPU: 0 PID: 1457 at kernel/events/core.c:890 add_ev=
ent_to_ctx+0x253/0x270()
[   34.702515] CPU: 0 PID: 1457 Comm: trinity-main Not tainted 3.19.0-rc4-g=
d26bb7f #2
[   34.702931]  00000000 00000000 c0911e2c cd8a61df c0911e48 cd052cfa 00000=
37a cd0d32f3
[   34.702931]  c0c206d0 c0c20590 d3c9e0a0 c0911e58 cd052dd4 00000009 00000=
000 c0911e78
[   34.702931]  cd0d32f3 d3c9e214 00000000 00000000 c0c20598 00000246 c0c50=
990 c0911e90
[   34.702931] Call Trace:
[   34.702931]  [<cd8a61df>] dump_stack+0x16/0x18
[   34.702931]  [<cd052cfa>] warn_slowpath_common+0x6a/0xa0
[   34.702931]  [<cd0d32f3>] ? add_event_to_ctx+0x253/0x270
[   34.702931]  [<cd052dd4>] warn_slowpath_null+0x14/0x20
[   34.702931]  [<cd0d32f3>] add_event_to_ctx+0x253/0x270
[   34.702931]  [<cd0da60f>] inherit_event+0xef/0x240
[   34.702931]  [<cd0da778>] inherit_group+0x18/0x70
[   34.702931]  [<cd0d2884>] ? alloc_perf_context+0x24/0x50
[   34.702931]  [<cd0db927>] perf_event_init_task+0x117/0x310
[   34.702931]  [<cd050c67>] copy_process+0x477/0x14f0
[   34.702931]  [<cd052063>] do_fork+0xb3/0x430
[   34.702931]  [<cd0923fd>] ? do_setitimer+0x13d/0x220
[   34.702931]  [<cd09251a>] ? alarm_setitimer+0x3a/0x60
[   34.702931]  [<cd05246b>] SyS_clone+0x1b/0x20
[   34.702931]  [<cd8ad3bd>] syscall_call+0x7/0x7
[   34.702931]  [<cd8a0000>] ? xen_chk_extra_mem+0x10/0x70
[   34.702931] ---[ end trace 19d6cac21f26a758 ]---

BUG: kernel test hang
Elapsed time: 3605
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-r=
2-0121/d26bb7f73a2881f2412c340a27438b185f0cc3dc/vmlinuz-3.19.0-rc4-gd26bb7f=
 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=3Ddebug=
 sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D-1 softl=
ockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_r=
amdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/=
ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-r2-0121/linux-de=
vel:devel-roam-rand-201501240027:d26bb7f73a2881f2412c340a27438b185f0cc3dc:b=
isect-linux-8/.vmlinuz-d26bb7f73a2881f2412c340a27438b185f0cc3dc-20150124123=
334-357-ivb41 branch=3Dlinux-devel/devel-roam-rand-201501240027 BOOT_IMAGE=
=3D/kernel/i386-randconfig-r2-0121/d26bb7f73a2881f2412c340a27438b185f0cc3dc=
/vmlinuz-3.19.0-rc4-gd26bb7f drbd.minor_count=3D8'  -initrd /kernel-tests/i=
nitrd/yocto-minimal-i386.cgz -m 320 -smp 1 -net nic,vlan=3D1,model=3De1000 =
-net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=
=3Dlocaltime -pidfile /dev/shm/kboot/pid-yocto-ivb41-39 -serial file:/dev/s=
hm/kboot/serial-yocto-ivb41-39 -daemonize -display none -monitor null=20

--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-client1-10:20150124141037:i386-randconfig-r2-0121:3.19.0-rc4-g2e67200:4"
Content-Transfer-Encoding: quoted-printable

early console in setup code
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.19.0-rc4-g2e67200 (kbuild@roam) (gcc version=
 4.9.1 (Debian 4.9.1-19) ) #4 Sat Jan 24 14:05:30 CST 2015
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x1000000
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
[    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at =
[c00f0eb0]
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] initial memory mapped: [mem 0x00000000-0x0d5fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12400000-0x125fffff]
[    0.000000]  [mem 0x12400000-0x125fffff] page 4k
[    0.000000] BRK [0x0d08e000, 0x0d08efff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x123fffff]
[    0.000000]  [mem 0x00100000-0x123fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12600000-0x13fdffff]
[    0.000000]  [mem 0x12600000-0x13fdffff] page 4k
[    0.000000] BRK [0x0d08f000, 0x0d08ffff] PGTABLE
[    0.000000] BRK [0x0d090000, 0x0d090fff] PGTABLE
[    0.000000] BRK [0x0d091000, 0x0d091fff] PGTABLE
[    0.000000] BRK [0x0d092000, 0x0d092fff] PGTABLE
[    0.000000] BRK [0x0d093000, 0x0d093fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x12793000-0x13fd7fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000F0C90 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FE18BD 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FE0B37 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACS 0x13FE0000 000040
[    0.000000] ACPI: SSDT 0x13FE0BAB 000C5A (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FE1805 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FE1885 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13fe0000
[    0.000000]   low ram: 0 - 13fe0000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13fde001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x13fdffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000] free_area_init_node: node 0, pgdat cc8f6c80, node_mem_map d2=
351020
[    0.000000]   Normal zone: 640 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 81790 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffb000 (fec00000)
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr c837340
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81150
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-r=
andconfig-r2-0121/linux-devel:devel-roam-rand-201501240027:2e67200461d1eec1=
7062de4947d07f3e6afd0848:bisect-linux-8/.vmlinuz-2e67200461d1eec17062de4947=
d07f3e6afd0848-20150124140541-21-client1 branch=3Dlinux-devel/devel-roam-ra=
nd-201501240027 BOOT_IMAGE=3D/kernel/i386-randconfig-r2-0121/2e67200461d1ee=
c17062de4947d07f3e6afd0848/vmlinuz-3.19.0-rc4-g2e67200 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 277952K/327160K available (8890K kernel code, 960K r=
wdata, 3468K rodata, 672K init, 6612K bss, 49208K reserved, 0K cma-reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa2000 - 0xfffff000   ( 372 kB)
[    0.000000]     vmalloc : 0xd47e0000 - 0xfffa0000   ( 695 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3fe0000   ( 319 MB)
[    0.000000]       .init : 0xcc906000 - 0xcc9ae000   ( 672 kB)
[    0.000000]       .data : 0xcc4aeeb9 - 0xcc904040   (4436 kB)
[    0.000000]       .text : 0xcbc00000 - 0xcc4aeeb9   (8891 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000]=20
[    0.000000] **********************************************************
[    0.000000] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.000000] **                                                      **
[    0.000000] ** trace_printk() being used. Allocating extra memory.  **
[    0.000000] **                                                      **
[    0.000000] ** This means that this is a DEBUG kernel and it is     **
[    0.000000] ** unsafe for production use.                           **
[    0.000000] **                                                      **
[    0.000000] ** If you see this message and you are not debugging    **
[    0.000000] ** the kernel, report this immediately to your vendor!  **
[    0.000000] **                                                      **
[    0.000000] **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
[    0.000000] **********************************************************
[    0.000000] Testing tracer nop: PASSED
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3Dc01fa000 soft=3Dc01fc000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 4895 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2992.398 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 5987.16 Bogo=
MIPS (lpj=3D9974660)
[    0.007139] pid_max: default: 4096 minimum: 301
[    0.010015] ACPI: Core revision 20141107
[    0.015221] ACPI: All ACPI Tables successfully acquired
[    0.016214] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.016677] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 by=
tes)
[    0.018163] Initializing cgroup subsys freezer
[    0.018929] Initializing cgroup subsys blkio
[    0.020048] Initializing cgroup subsys debug
[    0.020953] mce: CPU supports 10 MCE banks
[    0.021771] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.021771] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.023348] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.030904] ftrace: allocating 35504 entries in 70 pages
[    0.040305] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.042227] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.043355] Getting VERSION: 1050014
[    0.043960] Getting VERSION: 1050014
[    0.046687] Getting ID: 0
[    0.047140] Getting ID: f000000
[    0.047680] Getting LVT0: 8700
[    0.048223] Getting LVT1: 8400
[    0.050084] enabled ExtINT on CPU#0
[    0.054101] ENABLING IO-APIC IRQs
[    0.054795] init IO_APIC IRQs
[    0.055335]  apic 0 pin 0 not connected
[    0.056002] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.056698] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.060040] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.061393] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.063363] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.064685] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.066708] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.070024] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.073381] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.076674] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.078008] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.080045] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.081377] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.083366] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.086688] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.088023] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.090024]  apic 0 pin 16 not connected
[    0.090664]  apic 0 pin 17 not connected
[    0.093345]  apic 0 pin 18 not connected
[    0.094004]  apic 0 pin 19 not connected
[    0.094640]  apic 0 pin 20 not connected
[    0.095290]  apic 0 pin 21 not connected
[    0.095940]  apic 0 pin 22 not connected
[    0.096671]  apic 0 pin 23 not connected
[    0.097511] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.098974] Using local APIC timer interrupts.
[    0.098974] calibrating APIC timer ...
[    0.103333] ... lapic delta =3D 8956477
[    0.103333] ... PM-Timer delta =3D 513076
[    0.103333] APIC calibration not consistent with PM-Timer: 143ms instead=
 of 100ms
[    0.103333] APIC delta adjusted to PM-Timer: 6248600 (8956477)
[    0.103333] TSC delta adjusted to PM-Timer: 299238791 (428916124)
[    0.103333] ..... delta 6248600
[    0.103333] ..... mult: 268375353
[    0.103333] ..... calibration result: 3332586
[    0.103333] ..... CPU clock speed is 2992.2290 MHz.
[    0.103333] ..... host bus clock speed is 999.2919 MHz.
[    0.104963] Testing tracer function: PASSED
[    0.341756] Testing dynamic ftrace: PASSED
[    0.570186] Testing dynamic ftrace ops #1: (1 0 1 0 0) (1 1 2 0 0) (2 1 =
3 0 23285) (2 2 4 0 23402) PASSED
[    0.793336] Testing dynamic ftrace ops #2: (1 0 1 23277 0) (1 1 2 23456 =
0) (2 1 3 1 68) (2 2 4 106 173) PASSED
[    1.046652] Testing ftrace recursion: PASSED
[    1.076671] Testing ftrace recursion safe: PASSED
[    1.100003] Testing ftrace regs: PASSED
[    1.130146] xor: measuring software checksum speed
[    1.163340]    pIII_sse  :  9283.200 MB/sec
[    1.200009]    prefetch64-sse: 10992.000 MB/sec
[    1.203336] xor: using function: prefetch64-sse (10992.000 MB/sec)
[    1.206689] prandom: seed boundary self test passed
[    1.208389] prandom: 100 self tests passed
[    1.210011] atomic64_test: passed for i586+ platform with CX8 and with S=
SE
[    1.213782] RTC time: 14:09:08, date: 01/24/15
[    1.214924] NET: Registered protocol family 16
[    1.216875] cpuidle: using governor ladder
[    1.220008] cpuidle: using governor menu
[    1.221385] ACPI: bus type PCI registered
[    1.222501] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    1.223350] PCI: PCI BIOS revision 2.10 entry at 0xfd456, last bus=3D0
[    1.226668] PCI: Using configuration type 1 for base access
[    1.293349] raid6: mmxx1     2212 MB/s
[    1.350023] raid6: mmxx2     2810 MB/s
[    1.410048] raid6: sse1x1    1207 MB/s
[    1.466703] raid6: sse1x2    1201 MB/s
[    1.523362] raid6: sse2x1    1978 MB/s
[    1.580018] raid6: sse2x2    3137 MB/s
[    1.583336] raid6: using algorithm sse2x2 (3137 MB/s)
[    1.584560] raid6: using intx1 recovery algorithm
[    1.587076] ACPI: Added _OSI(Module Device)
[    1.590002] ACPI: Added _OSI(Processor Device)
[    1.591082] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.593336] ACPI: Added _OSI(Processor Aggregator Device)
[    1.597719] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    1.601993] ACPI: Interpreter enabled
[    1.603344] ACPI: (supports S0 S5)
[    1.604188] ACPI: Using IOAPIC for interrupt routing
[    1.606746] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    1.619861] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.620030] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    1.623374] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.625269] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    1.626977] PCI host bridge to bus 0000:00
[    1.630007] pci_bus 0000:00: root bus resource [bus 00-ff]
[    1.631344] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.633338] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    1.634868] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    1.636385] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    1.636676] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    1.640004] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    1.643339] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    1.645133] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    1.647492] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    1.650789] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    1.656945] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    1.660976] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    1.662754] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    1.663338] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    1.666669] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    1.670438] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    1.672397] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    1.673349] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    1.677135] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    1.681833] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    1.686710] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    1.693407] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    1.697454] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    1.700006] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    1.704234] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    1.713347] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    1.720045] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    1.722189] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    1.731761] pci_bus 0000:00: on NUMA node 0
[    1.734921] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    1.737338] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    1.740113] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    1.746918] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    1.748525] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    1.751250] ACPI: Enabled 16 GPEs in block 00 to 0F
[    1.754138] vgaarb: setting as boot device: PCI:0000:00:02.0
[    1.755502] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    1.756670] vgaarb: loaded
[    1.760003] vgaarb: bridge control possible 0000:00:02.0
[    1.766906] SCSI subsystem initialized
[    1.770057] libata version 3.00 loaded.
[    1.773336] ACPI: bus type USB registered
[    1.774390] usbcore: registered new interface driver usbfs
[    1.775716] usbcore: registered new interface driver hub
[    1.776735] usbcore: registered new device driver usb
[    1.780173] media: Linux media interface: v0.10
[    1.781281] Linux video capture interface: v2.00
[    1.783396] pps_core: LinuxPPS API ver. 1 registered
[    1.784591] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    1.787154] PCI: Using ACPI for IRQ routing
[    1.788166] PCI: pci_cache_line_size set to 64 bytes
[    1.790195] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    1.793344] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    1.795814] Switched to clocksource kvm-clock
[    1.847616] FS-Cache: Loaded
[    1.857008] pnp: PnP ACPI init
[    1.857867] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    1.859855] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.861656] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    1.872619] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.881221] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    1.883215] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.884850] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    1.886760] pnp 00:03: [dma 2]
[    1.887565] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.906509] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    1.908522] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    1.910156] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    1.912134] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.914286] pnp: PnP ACPI: found 6 devices
[    1.973056] PM-Timer running at invalid rate: 174% of normal - aborting.
[    1.974731] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.976069] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    1.981270] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    1.982458] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    1.983643] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    1.984839] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    1.986182] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    1.987549] NET: Registered protocol family 1
[    2.009507] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.010809] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    2.012077] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    2.013417] pci 0000:00:02.0: Video device with shadowed ROM
[    2.014665] PCI: CLS 0 bytes, default 64
[    2.015700] Unpacking initramfs...
[    3.813323] debug: unmapping init [mem 0xd2793000-0xd3fd7fff]
[    3.824676] Machine check injector initialized
[    3.825646] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
[    3.827017] apm: overridden by ACPI.
[    3.833604] Scanning for low memory corruption every 60 seconds
[    3.851769] cryptomgr_test (17) used greatest stack depth: 7400 bytes le=
ft
[    3.853825] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    3.865055] NatSemi SCx200 Driver
[    3.866005] spin_lock-torture:--- Start of test [debug]: nwriters_stress=
=3D2 nreaders_stress=3D0 stat_interval=3D60 verbose=3D1 shuffle_interval=3D=
3 stutter=3D5 shutdown_secs=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    3.875657] spin_lock-torture: Creating torture_shuffle task
[    3.876936] spin_lock-torture: Creating torture_stutter task
[    3.884963] spin_lock-torture: torture_shuffle task started
[    3.886187] spin_lock-torture: torture_stutter task started
[    3.890772] spin_lock-torture: Creating lock_torture_writer task
[    3.892096] spin_lock-torture: Creating lock_torture_writer task
[    3.893872] spin_lock-torture: lock_torture_writer task started
[    3.905244] spin_lock-torture: Creating lock_torture_stats task
[    3.906547] spin_lock-torture: lock_torture_writer task started
[    3.914560] torture_init_begin: refusing rcu init: spin_lock running
[    3.916669] futex hash table entries: 16 (order: -3, 704 bytes)
[    3.925941] spin_lock-torture: lock_torture_stats task started
[    3.943616] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    3.951746] page_owner is disabled
[    3.952780] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    3.960978] ntfs: driver 2.1.31 [Flags: R/W DEBUG].
[    3.962058] efs: 1.0a - http://aeschi.ch.eu.org/efs/
[    3.971269] romfs: ROMFS MTD (C) 2007 Red Hat, Inc.
[    3.972307] QNX4 filesystem 0.2.3 registered.
[    3.973251] qnx6: QNX6 filesystem 1.0.0 registered.
[    3.981085] fuse init (API version 7.23)
[    3.982102] befs: version: 0.9.3
[    3.990898] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    3.992612] io scheduler noop registered (default)
[    3.993662] io scheduler deadline registered
[    4.001330] io scheduler cfq registered
[    4.002165] start plist test
[    4.010839] end plist test
[    4.011440] test_string_helpers: Running tests...
[    4.012792] test_firmware: interface ready
[    4.020731] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    4.021815] crc32: self tests passed, processed 225944 bytes in 6860199 =
nsec
[    4.023471] crc32c: CRC_LE_BITS =3D 64
[    4.030962] crc32c: self tests passed, processed 225944 bytes in 70743 n=
sec
[    4.072696] crc32_combine: 8373 self tests passed
[    4.106786] crc32c_combine: 8373 self tests passed
[    4.132837] xz_dec_test: module loaded
[    4.133760] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
249 0' and write .xz files to it.
[    4.142536] glob: 64 self-tests passed, 0 failed
[    4.144943] no IO addresses supplied
[    4.146294] hgafb: HGA card not detected.
[    4.164440] hgafb: probe of hgafb.0 failed with error -22
[    4.166052] usbcore: registered new interface driver udlfb
[    4.167439] ipmi message handler version 39.2
[    4.168494] ipmi device interface
[    4.169370] IPMI System Interface driver.
[    4.170453] ipmi_si: Adding default-specified kcs state machine
[    4.171963] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    4.182608] ipmi_si: Interface detection failed
[    4.192628] ipmi_si: Adding default-specified smic state machine
[    4.194113] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    4.196498] ipmi_si: Interface detection failed
[    4.197594] ipmi_si: Adding default-specified bt state machine
[    4.199021] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    4.209408] ipmi_si: Interface detection failed
[    4.210620] ipmi_si: Unable to find any System Interface(s)
[    4.215105] IPMI SSIF Interface driver
[    4.216050] IPMI Watchdog: driver initialized
[    4.217108] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    4.224942] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    4.226705] ACPI: Power Button [PWRF]
[    4.236539] r3964: Philips r3964 Driver $Revision: 1.10 $
[    4.243855] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    4.304051] serial 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 1=
15200) is a 16550A
[    4.307885] lp: driver loaded but no devices found
[    4.308843] toshiba: not a supported Toshiba laptop
[    4.309796] ppdev: user-space parallel port driver
[    4.316771] scx200_gpio: no SCx200 gpio present
[    4.317754] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    4.319164] platform pc8736x_gpio.0: no device found
[    4.320232] nsc_gpio initializing
[    4.320872] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    4.322766] [drm] Initialized drm 1.1.0 20060810
[    4.329153] usbcore: registered new interface driver udl
[    4.331263] parport_pc 00:04: reported by Plug and Play ACPI
[    4.332579] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    4.477638] lp0: using parport0 (interrupt-driven).
[    4.479402] dummy-irq: no IRQ given.  Use irq=3DN
[    4.480473] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    4.488010] c2port c2port0: C2 port uc added
[    4.488816] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    4.490526] usbcore: registered new interface driver rtsx_usb
[    4.491914] usbcore: registered new interface driver viperboard
[    4.502077] usbcore: registered new interface driver dln2
[    4.503151] Uniform Multi-Platform E-IDE driver
[    4.505192] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[    4.507084] ide-cd driver 5.00
[    4.514101] hp_sw: device handler registered
[    4.514935] ppa: Version 2.07 (for Linux 2.4.x)
[    4.518397] osst :I: Tape driver with OnStream support version 0.99.4
[    4.518397] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    4.527310] SCSI Media Changer driver v0.25=20
[    4.528202] osd: LOADED open-osd 0.2.1
[    4.529495] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[    4.531415] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    4.532675] L440GX flash mapping: failed to find PIIX4 ISA bridge, canno=
t continue
[    4.542200] platform physmap-flash.0: failed to claim resource 0
[    4.543390] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
[    4.544501] scx200_docflash: NatSemi SCx200 DOCCS Flash Driver
[    4.545666] slram: not enough parameters.
[    4.553962] ftl_cs: FTL header not found.
[    4.558841] parport0: cannot grant exclusive access for device spi-lm70l=
lp
[    4.563229] spi-lm70llp: spi_lm70llp probe fail, status -12
[    4.564621] HSI/SSI char device loaded
[    4.565521] usbcore: registered new interface driver hwa-rc
[    4.566718] usbcore: registered new interface driver i1480-dfu-usb
[    4.568618] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.569885] ehci-pci: EHCI PCI platform driver
[    4.570791] ehci-platform: EHCI generic platform driver
[    4.572026] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    4.573386] usbcore: registered new interface driver cdc_acm
[    4.574523] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    4.589312] usbcore: registered new interface driver cdc_wdm
[    4.590470] usbcore: registered new interface driver uas
[    4.604507] usbcore: registered new interface driver usb-storage
[    4.605682] usbcore: registered new interface driver ums-alauda
[    4.606862] usbcore: registered new interface driver ums-cypress
[    4.608141] usbcore: registered new interface driver ums-jumpshot
[    4.609314] usbcore: registered new interface driver ums-karma
[    4.610470] usbcore: registered new interface driver ums-onetouch
[    4.611646] usbcore: registered new interface driver ums-realtek
[    4.612743] usbcore: registered new interface driver ums-sddr09
[    4.616518] usbcore: registered new interface driver ums-sddr55
[    4.617679] usbcore: registered new interface driver ums-usbat
[    4.618884] usbcore: registered new interface driver mdc800
[    4.629068] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[    4.630565] usbcore: registered new interface driver microtekX6
[    4.631725] usbcore: registered new interface driver adutux
[    4.632814] usbcore: registered new interface driver cypress_cy7c63
[    4.636068] ftdi_elan: driver ftdi-elan
[    4.637388] usbcore: registered new interface driver ftdi-elan
[    4.638513] usbcore: registered new interface driver idmouse
[    4.639605] usbcore: registered new interface driver iowarrior
[    4.640763] usbcore: registered new interface driver isight_firmware
[    4.641985] usbcore: registered new interface driver usblcd
[    4.643078] usbcore: registered new interface driver ldusb
[    4.663242] usbcore: registered new interface driver usbled
[    4.664327] usbcore: registered new interface driver legousbtower
[    4.665507] usbcore: registered new interface driver usbtest
[    4.666629] usbcore: registered new interface driver usb_ehset_test
[    4.667922] usbcore: registered new interface driver trancevibrator
[    4.669158] usbcore: registered new interface driver uss720
[    4.670246] uss720: v0.6:USB Parport Cable driver for Cables using the L=
ucent Technologies USS720 Chip
[    4.693034] uss720: NOTE: this is a special purpose driver to allow nons=
tandard
[    4.694436] uss720: protocols (eg. bitbang) over USS720 usb to parallel =
cables
[    4.695805] uss720: If you just want to connect to a printer, use usblp =
instead
[    4.697319] usbcore: registered new interface driver usbsevseg
[    4.698457] usbcore: registered new interface driver yurex
[    4.699567] usbcore: registered new interface driver lvs
[    4.701132] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 M=
ay 2005
[    4.728763] dummy_hcd dummy_hcd.0: Dummy host controller
[    4.729907] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus =
number 1
[    4.731680] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    4.732976] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    4.734374] usb usb1: Product: Dummy host controller
[    4.735362] usb usb1: Manufacturer: Linux 3.19.0-rc4-g2e67200 dummy_hcd
[    4.736635] usb usb1: SerialNumber: dummy_hcd.0
[    4.737967] hub 1-0:1.0: USB hub found
[    4.738720] hub 1-0:1.0: 1 port detected
[    4.740353] udc dummy_udc.0: registering UDC driver [g_mass_storage]
[    4.759608] Number of LUNs=3D8
[    4.760195] Mass Storage Function, version: 2009/09/11
[    4.761181] LUN: removable file: (no medium)
[    4.762017] Number of LUNs=3D1
[    4.762585] no file given for LUN0
[    4.763347] g_mass_storage dummy_udc.0: failed to start g_mass_storage: =
-22
[    4.764929] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    4.767386] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.788527] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.791057] mousedev: PS/2 mouse device common for all mice
[    4.793054] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    4.795022] usbcore: registered new interface driver appletouch
[    4.796180] usbcore: registered new interface driver bcm5974
[    4.813276] usbcore: registered new interface driver synaptics_usb
[    4.814583] usbcore: registered new interface driver usb_acecad
[    4.815771] usbcore: registered new interface driver aiptek
[    4.835361] usbcore: registered new interface driver gtco
[    4.836524] usbcore: registered new interface driver hanwang
[    4.837890] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    4.840509] usbcore: registered new interface driver ims_pcu
[    4.842409] usbcore: registered new interface driver powermate
[    4.843895] usbcore: registered new interface driver yealink
[    4.862606] ideapad_slidebar: DMI does not match
[    4.863854] rtc_cmos 00:00: RTC can wake from S4
[    4.865145] rtc (null): alarm rollover: day
[    4.866798] rtc rtc0: rtc_cmos: dev (254:0)
[    4.868668] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    4.881271] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    4.884205] usbcore: registered new interface driver i2c-diolan-u2c
[    4.885451] i2c-parport-light: adapter type unspecified
[    4.886505] usbcore: registered new interface driver i2c-tiny-usb
[    4.888037] pps_ldisc: PPS line discipline registered
[    4.889045] pps_parport: parallel port PPS client
[    4.909492] parport0: cannot grant exclusive access for device pps_parpo=
rt
[    4.910818] pps_parport: couldn't register with parport0
[    4.911851] Driver for 1-wire Dallas network protocol.
[    4.926556] usbcore: registered new interface driver DS9490R
[    4.927666] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    4.928876] 1-Wire driver for the DS2760 battery monitor chip - (c) 2004=
-2005, Szabolcs Gyurko
[    4.932353] applesmc: supported laptop not found!
[    4.933323] applesmc: driver init failed (ret=3D-19)!
[    4.944595] f71882fg: Not a Fintek device
[    4.945418] f71882fg: Not a Fintek device
[    4.947171] pc87360: PC8736x not detected, module not inserted
[    4.948922] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[    4.950356] md: raid0 personality registered for level 0
[    4.951397] md: raid1 personality registered for level 1
[    4.972444] md: raid10 personality registered for level 10
[    4.973579] usb usb1: dummy_bus_suspend
[    4.974579] md: raid6 personality registered for level 6
[    4.975635] md: raid5 personality registered for level 5
[    4.976699] md: raid4 personality registered for level 4
[    4.977734] md: multipath personality registered for level -4
[    4.978917] md: faulty personality registered for level -5
[    4.980290] device-mapper: ioctl: 4.29.0-ioctl (2014-10-28) initialised:=
 dm-devel@redhat.com
[    5.003630] device-mapper: multipath: version 1.7.0 loaded
[    5.004764] device-mapper: multipath round-robin: version 1.0.0 loaded
[    5.006050] device-mapper: multipath service-time: version 0.2.0 loaded
[    5.007381] device-mapper: raid: Loading target version 1.6.0
[    5.026869] cpufreq-nforce2: No nForce2 chipset.
[    5.027810] Driver 'mmc_test' needs updating - please use bus_type metho=
ds
[    5.029696] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0400
[    5.031325] usbcore: registered new interface driver vub300
[    5.032502] usbcore: registered new interface driver ushc
[    5.034404] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    5.056237] usbcore: registered new interface driver usbhid
[    5.057354] usbhid: USB HID core driver
[    5.060014] oprofile: using NMI interrupt.
[    5.061909] ... APIC ID:      00000000 (0)
[    5.062733] ... APIC VERSION: 01050014
[    5.063120] 000000000000000000000000000000000000000000000000000000000000=
0000
[    5.063120] 000000000e20000000000000000000000000000000000000000000000000=
0000
[    5.063120] 000000000000000000000000000000000000000000000000000000000000=
8000
[    5.063120]=20
[    5.086826] number of MP IRQ sources: 15.
[    5.087613] number of IO-APIC #0 registers: 24.
[    5.088498] testing the IO APIC.......................
[    5.089511] IO APIC #0......
[    5.110191] .... register #00: 00000000
[    5.110950] .......    : physical APIC id: 00
[    5.111829] .......    : Delivery Type: 0
[    5.112698] .......    : LTS          : 0
[    5.113669] .... register #01: 00170011
[    5.114465] .......     : max redirection entries: 17
[    5.115447] .......     : PRQ implemented: 0
[    5.116301] .......     : IO APIC version: 11
[    5.117228] .... register #02: 00000000
[    5.117984] .......     : arbitration: 00
[    5.118794] .... IRQ redirection table:
[    5.134754] 1    0    0   0   0    0    0    00
[    5.135679] 0    0    0   0   0    1    1    31
[    5.136587] 0    0    0   0   0    1    1    30
[    5.137468] 0    0    0   0   0    1    1    33
[    5.138370] 1    0    0   0   0    1    1    34
[    5.139275] 1    1    0   0   0    1    1    35
[    5.140191] 0    0    0   0   0    1    1    36
[    5.141094] 0    0    0   0   0    1    1    37
[    5.141976] 0    0    0   0   0    1    1    38
[    5.142873] 0    1    0   0   0    1    1    39
[    5.143813] 1    1    0   0   0    1    1    3A
[    5.164775] 1    1    0   0   0    1    1    3B
[    5.165718] 0    0    0   0   0    1    1    3C
[    5.166639] 0    0    0   0   0    1    1    3D
[    5.167550] 0    0    0   0   0    1    1    3E
[    5.168471] 0    0    0   0   0    1    1    3F
[    5.169425] 1    0    0   0   0    0    0    00
[    5.170398] 1    0    0   0   0    0    0    00
[    5.171348] 1    0    0   0   0    0    0    00
[    5.172311] 1    0    0   0   0    0    0    00
[    5.199327] 1    0    0   0   0    0    0    00
[    5.200235] 1    0    0   0   0    0    0    00
[    5.201139] 1    0    0   0   0    0    0    00
[    5.202041] 1    0    0   0   0    0    0    00
[    5.202930] IRQ to pin mappings:
[    5.203607] IRQ0 -> 0:2
[    5.204200] IRQ1 -> 0:1
[    5.204748] IRQ3 -> 0:3
[    5.205296] IRQ4 -> 0:4
[    5.205833] IRQ5 -> 0:5
[    5.206389] IRQ6 -> 0:6
[    5.206922] IRQ7 -> 0:7
[    5.207469] IRQ8 -> 0:8
[    5.228052] IRQ9 -> 0:9
[    5.228617] IRQ10 -> 0:10
[    5.229191] IRQ11 -> 0:11
[    5.229769] IRQ12 -> 0:12
[    5.230358] IRQ13 -> 0:13
[    5.230920] IRQ14 -> 0:14
[    5.231505] IRQ15 -> 0:15
[    5.232132] .................................... done.
[    5.233173] Using IPI Shortcut mode
[    5.235598] Running tests on trace events:
[    5.236449] Testing event xen_cpu_set_ldt: OK
[    5.259829] Testing event xen_cpu_write_gdt_entry: OK
[    5.306474] Testing event xen_cpu_load_idt: OK
[    5.353694] Testing event xen_cpu_write_idt_entry: OK
[    5.359802] Testing event xen_cpu_write_ldt_entry: OK
[    5.382785] Testing event xen_mmu_write_cr3: OK
[    5.428099] Testing event xen_mmu_flush_tlb_others: OK
[    5.436445] Testing event xen_mmu_flush_tlb_single: OK
[    5.487843] Testing event xen_mmu_flush_tlb: OK
[    5.519984] Testing event xen_mmu_flush_tlb_all: OK
[    5.539978] Testing event xen_mmu_pgd_unpin: OK
[    5.571190] Testing event xen_mmu_pgd_pin: OK
[    5.617143] Testing event xen_mmu_release_ptpage: OK
[    5.649615] Testing event xen_mmu_alloc_ptpage: OK
[    5.671241] Testing event xen_mmu_ptep_modify_prot_commit: OK
[    5.679875] Testing event xen_mmu_ptep_modify_prot_start: OK
[    5.703077] Testing event xen_mmu_pgd_clear: OK
[    5.743301] Testing event xen_mmu_set_pud: OK
[    5.773080] Testing event xen_mmu_pmd_clear: OK
[    5.798190] Testing event xen_mmu_set_pmd: OK
[    5.856499] Testing event xen_mmu_pte_clear: OK
[    5.863025] Testing event xen_mmu_set_pte_at: OK
[    5.914274] Testing event xen_mmu_set_domain_pte:=20
[    5.919626] tsc: Refined TSC clocksource calibration: 2992.396 MHz
[    5.942984] OK
[    5.943344] Testing event xen_mmu_set_pte_atomic: OK
[    5.953576] Testing event xen_mmu_set_pte: OK
[    5.989182] Testing event xen_mc_extend_args: OK
[    5.997453] Testing event xen_mc_flush: OK
[    6.020512] Testing event xen_mc_flush_reason: OK
[    6.042986] Testing event xen_mc_callback: OK
[    6.067108] Testing event xen_mc_entry_alloc: OK
[    6.125499] Testing event xen_mc_entry: OK
[    6.132941] Testing event xen_mc_issue: OK
[    6.180276] Testing event xen_mc_batch: OK
[    6.221481] Testing event thermal_apic_exit:=20
[    6.227840] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[    6.246411] OK
[    6.246748] Testing event thermal_apic_entry: OK
[    6.299015] Testing event threshold_apic_exit: OK
[    6.323343] Testing event threshold_apic_entry: OK
[    6.379659] Testing event call_function_single_exit: OK
[    6.399591] Testing event call_function_single_entry: OK
[    6.448589] Testing event call_function_exit: OK
[    6.476142] Testing event call_function_entry: OK
[    6.523222] Testing event irq_work_exit: OK
[    6.543379] Testing event irq_work_entry: OK
[    6.567102] Testing event x86_platform_ipi_exit: OK
[    6.572878] Testing event x86_platform_ipi_entry: OK
[    6.614268] Testing event error_apic_exit: OK
[    6.629515] Testing event error_apic_entry: OK
[    6.679314] Testing event spurious_apic_exit: OK
[    6.701217] Testing event spurious_apic_entry: OK
[    6.725415] Testing event reschedule_exit: OK
[    6.748074] Testing event reschedule_entry: OK
[    6.780282] Testing event local_timer_exit: OK
[    6.800174] Testing event local_timer_entry: OK
[    6.822412] Testing event nmi_handler: OK
[    6.832792] Testing event sys_exit: OK
[    6.858263] Testing event sys_enter: OK
[    6.868210] Testing event mce_record: OK
[    6.900273] Testing event tlb_flush: OK
[    6.912247] Testing event page_fault_kernel: OK
[    6.921545] Testing event page_fault_user: OK
[    6.930236] Testing event task_rename: OK
[    6.941419] Testing event task_newtask: OK
[    6.948210] Testing event softirq_raise: OK
[    6.964193] Testing event softirq_exit: OK
[    6.975019] Testing event softirq_entry: OK
[    6.988576] Testing event irq_handler_exit: OK
[    7.007300] Testing event irq_handler_entry: OK
[    7.020349] Testing event signal_deliver: OK
[    7.030832] Testing event signal_generate: OK
[    7.042054] Testing event workqueue_execute_end: OK
[    7.062372] Testing event workqueue_execute_start: OK
[    7.073807] Testing event workqueue_activate_work: OK
[    7.090741] Testing event workqueue_queue_work: OK
[    7.119499] Testing event sched_wake_idle_without_ipi: OK
[    7.127766] Testing event sched_swap_numa: OK
[    7.146307] Testing event sched_stick_numa: OK
[    7.154560] Testing event sched_move_numa: OK
[    7.173875] Testing event sched_pi_setprio: OK
[    7.179870] Testing event sched_stat_runtime:=20
[    7.187547] test-events (174) used greatest stack depth: 7164 bytes left
[    7.192307] OK
[    7.192652] Testing event sched_stat_blocked: OK
[    7.201936] Testing event sched_stat_iowait: OK
[    7.219710] Testing event sched_stat_sleep: OK
[    7.228079] Testing event sched_stat_wait: OK
[    7.251367] Testing event sched_process_exec: OK
[    7.268839] Testing event sched_process_fork: OK
[    7.280092] Testing event sched_process_wait: OK
[    7.306811] Testing event sched_wait_task: OK
[    7.315723] Testing event sched_process_exit: OK
[    7.351225] Testing event sched_process_free: OK
[    7.373213] Testing event sched_migrate_task: OK
[    7.410387] Testing event sched_switch: OK
[    7.425126] Testing event sched_wakeup_new: OK
[    7.460959] Testing event sched_wakeup: OK
[    7.482118] Testing event sched_kthread_stop_ret: OK
[    7.497028] Testing event sched_kthread_stop: OK
[    7.518109] Testing event lock_release: OK
[    7.590947] Testing event lock_acquire: OK
[    7.602895] Testing event console: OK
[    7.612123] Testing event rcu_utilization: OK
[    7.637162] Testing event itimer_expire: OK
[    7.653457] Testing event itimer_state: OK
[    7.669850] Testing event hrtimer_cancel: OK
[    7.701247] Testing event hrtimer_expire_exit: OK
[    7.720316] Testing event hrtimer_expire_entry: OK
[    7.733191] Testing event hrtimer_start: OK
[    7.768116] Testing event hrtimer_init: OK
[    7.798826] Testing event timer_cancel: OK
[    7.824186] Testing event timer_expire_exit: OK
[    7.857214] Testing event timer_expire_entry: OK
[    7.878125] Testing event timer_start: OK
[    7.921129] Testing event timer_init: OK
[    7.957501] Testing event ftrace_test_filter: OK
[    7.972055] Testing event dev_pm_qos_remove_request: OK
[    7.985480] Testing event dev_pm_qos_update_request: OK
[    7.996307] Testing event dev_pm_qos_add_request: OK
[    8.036887] Testing event pm_qos_update_flags: OK
[    8.047926] Testing event pm_qos_update_target: OK
[    8.082133] Testing event pm_qos_update_request_timeout: OK
[    8.102126] Testing event pm_qos_remove_request: OK
[    8.120204] Testing event pm_qos_update_request: OK
[    8.155754] Testing event pm_qos_add_request: OK
[    8.176161] Testing event power_domain_target: OK
[    8.205173] Testing event clock_set_rate: OK
[    8.222176] Testing event clock_disable: OK
[    8.247137] Testing event clock_enable: OK
[    8.268140] Testing event wakeup_source_deactivate: OK
[    8.288360] Testing event wakeup_source_activate: OK
[    8.312486] Testing event suspend_resume: OK
[    8.366131] Testing event device_pm_callback_end: OK
[    8.386135] Testing event device_pm_callback_start: OK
[    8.410116] Testing event cpu_frequency: OK
[    8.438578] Testing event pstate_sample: OK
[    8.449118] Testing event cpu_idle: OK
[    8.470878] Testing event rpm_return_int: OK
[    8.480895] Testing event rpm_idle: OK
[    8.494179] Testing event rpm_resume: OK
[    8.512520] Testing event rpm_suspend: OK
[    8.520906] Testing event mm_filemap_add_to_page_cache: OK
[    8.535750] Testing event mm_filemap_delete_from_page_cache: OK
[    8.550897] Testing event oom_score_adj_update: OK
[    8.567595] Testing event mm_lru_activate: OK
[    8.590120] Testing event mm_lru_insertion: OK
[    8.597567] Testing event mm_vmscan_lru_shrink_inactive: OK
[    8.617576] Testing event mm_vmscan_writepage: OK
[    8.655142] Testing event mm_vmscan_memcg_isolate: OK
[    8.674184] Testing event mm_vmscan_lru_isolate: OK
[    8.728215] Testing event mm_shrink_slab_end: OK
[    8.746149] Testing event mm_shrink_slab_start: OK
[    8.780199] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[    8.820130] Testing event mm_vmscan_memcg_reclaim_end: OK
[    8.877155] Testing event mm_vmscan_direct_reclaim_end: OK
[    8.902141] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[    8.945429] Testing event mm_vmscan_memcg_reclaim_begin: OK
[    8.974169] Testing event mm_vmscan_direct_reclaim_begin: OK
[    8.994122] Testing event mm_vmscan_wakeup_kswapd: OK
[    9.019121] Testing event mm_vmscan_kswapd_wake: OK
[    9.037963] Testing event mm_vmscan_kswapd_sleep: OK
[    9.049343] Testing event mm_page_alloc_extfrag: OK
[    9.061496] Testing event mm_page_pcpu_drain: OK
[    9.082296] Testing event mm_page_alloc_zone_locked: OK
[    9.101081] Testing event mm_page_alloc: OK
[    9.124590] Testing event mm_page_free_batched: OK
[    9.144500] Testing event mm_page_free: OK
[    9.157825] Testing event kmem_cache_free: OK
[    9.166077] Testing event kfree: OK
[    9.177818] Testing event kmem_cache_alloc_node: OK
[    9.186492] Testing event kmalloc_node: OK
[    9.202611] Testing event kmem_cache_alloc: OK
[    9.209271] Testing event kmalloc: OK
[    9.215959] Testing event mm_compaction_end: OK
[    9.222265] Testing event mm_compaction_begin: OK
[    9.240049] Testing event mm_compaction_migratepages: OK
[    9.247877] Testing event mm_compaction_isolate_freepages: OK
[    9.259537] Testing event mm_compaction_isolate_migratepages: OK
[    9.267852] Testing event mm_numa_migrate_ratelimit: OK
[    9.276735] Testing event mm_migrate_pages: OK
[    9.291174] Testing event writeback_single_inode: OK
[    9.301142] Testing event writeback_single_inode_start: OK
[    9.321138] Testing event writeback_wait_iff_congested: OK
[    9.341165] Testing event writeback_congestion_wait: OK
[    9.354593] Testing event writeback_sb_inodes_requeue: OK
[    9.363030] Testing event balance_dirty_pages: OK
[    9.371221] Testing event bdi_dirty_ratelimit: OK
[    9.383128] Testing event global_dirty_state: OK
[    9.391229] Testing event writeback_queue_io: OK
[    9.399184] Testing event wbc_writepage: OK
[    9.415378] Testing event writeback_bdi_unregister: OK
[    9.435474] Testing event writeback_bdi_register: OK
[    9.443098] Testing event writeback_wake_background: OK
[    9.451228] Testing event writeback_nowork: OK
[    9.463368] Testing event writeback_pages_written: OK
[    9.484136] Testing event writeback_wait: OK
[    9.501160] Testing event writeback_written: OK
[    9.512245] Testing event writeback_start: OK
[    9.534628] Testing event writeback_exec: OK
[    9.562223] Testing event writeback_queue: OK
[    9.591026] Testing event writeback_write_inode: OK
[    9.608842] Testing event writeback_write_inode_start: OK
[    9.651891] Testing event writeback_dirty_inode: OK
[    9.684084] Testing event writeback_dirty_inode_start: OK
[    9.708874] Testing event writeback_dirty_page: OK
[    9.738891] Testing event time_out_leases: OK
[    9.745470] Testing event generic_delete_lease: OK
[    9.799205] Testing event generic_add_lease: OK
[    9.805448] Testing event break_lease_unblock: OK
[    9.833199] Testing event break_lease_block: OK
[    9.872170] Testing event break_lease_noblock: OK
[    9.888806] Testing event ext3_load_inode: OK
[    9.943381] Testing event ext3_get_blocks_exit: OK
[    9.953953] Testing event ext3_get_blocks_enter: OK
[    9.981759] Testing event ext3_truncate_exit: OK
[   10.012680] Testing event ext3_truncate_enter: OK
[   10.039248] Testing event ext3_unlink_exit: OK
[   10.092103] Testing event ext3_unlink_enter: OK
[   10.121158] Testing event ext3_direct_IO_exit: OK
[   10.167757] Testing event ext3_direct_IO_enter: OK
[   10.187736] Testing event ext3_read_block_bitmap: OK
[   10.205159] Testing event ext3_forget: OK
[   10.227819] Testing event ext3_reserved: OK
[   10.248215] Testing event ext3_alloc_new_reservation: OK
[   10.261149] Testing event ext3_discard_reservation: OK
[   10.278018] Testing event ext3_rsv_window_add: OK
[   10.307813] Testing event ext3_sync_fs: OK
[   10.323726] Testing event ext3_sync_file_exit: OK
[   10.328654] Testing event ext3_sync_file_enter: OK
[   10.389792] Testing event ext3_free_blocks: OK
[   10.403145] Testing event ext3_allocate_blocks: OK
[   10.427480] Testing event ext3_request_blocks: OK
[   10.461980] Testing event ext3_discard_blocks: OK
[   10.494969] Testing event ext3_invalidatepage: OK
[   10.505301] Testing event ext3_releasepage: OK
[   10.542019] Testing event ext3_readpage: OK
[   10.556173] Testing event ext3_journalled_writepage: OK
[   10.597531] Testing event ext3_writeback_writepage: OK
[   10.608600] Testing event ext3_ordered_writepage: OK
[   10.639258] Testing event ext3_journalled_write_end: OK
[   10.661944] Testing event ext3_writeback_write_end: OK
[   10.682171] Testing event ext3_ordered_write_end: OK
[   10.688577] Testing event ext3_write_begin: OK
[   10.712119] Testing event ext3_mark_inode_dirty: OK
[   10.718572] Testing event ext3_drop_inode: OK
[   10.741911] Testing event ext3_evict_inode: OK
[   10.751902] Testing event ext3_allocate_inode: OK
[   10.785662] Testing event ext3_request_inode: OK
[   10.811904] Testing event ext3_free_inode: OK
[   10.844217] Testing event ext4_es_shrink: OK
[   10.875910] Testing event ext4_collapse_range: OK
[   10.891140] Testing event ext4_es_shrink_scan_exit: OK
[   10.901912] Testing event ext4_es_shrink_scan_enter: OK
[   10.948371] Testing event ext4_es_shrink_count: OK
[   10.958566] Testing event ext4_es_lookup_extent_exit: OK
[   10.998073] Testing event ext4_es_lookup_extent_enter: OK
[   11.031204] Testing event ext4_es_find_delayed_extent_range_exit: OK
[   11.053799] Testing event ext4_es_find_delayed_extent_range_enter: OK
[   11.075155] Testing event ext4_es_remove_extent: OK
[   11.085469] Testing event ext4_es_cache_extent: OK
[   11.091825] Testing event ext4_es_insert_extent: OK
[   11.125196] Testing event ext4_ext_remove_space_done: OK
[   11.137380] Testing event ext4_ext_remove_space: OK
[   11.155898] Testing event ext4_ext_rm_idx: OK
[   11.167909] Testing event ext4_ext_rm_leaf: OK
[   11.194598] Testing event ext4_remove_blocks: OK
[   11.211266] Testing event ext4_ext_show_extent: OK
[   11.241802] Testing event ext4_get_reserved_cluster_alloc: OK
[   11.274436] Testing event ext4_find_delalloc_range: OK
[   11.319411] Testing event ext4_ext_in_cache: OK
[   11.331193] Testing event ext4_ext_put_in_cache: OK
[   11.354893] Testing event ext4_get_implied_cluster_alloc_exit: OK
[   11.369603] Testing event ext4_ext_handle_unwritten_extents: OK
[   11.381223] Testing event ext4_trim_all_free: OK
[   11.390471] Testing event ext4_trim_extent: OK
[   11.402108] Testing event ext4_journal_start_reserved: OK
[   11.441509] Testing event ext4_journal_start: OK
[   11.465106] Testing event ext4_load_inode: OK
[   11.483217] Testing event ext4_ext_load_extent: OK
[   11.503734] Testing event ext4_ind_map_blocks_exit: OK
[   11.524015] Testing event ext4_ext_map_blocks_exit: OK
[   11.545339] Testing event ext4_ind_map_blocks_enter: OK
[   11.553172] Testing event ext4_ext_map_blocks_enter: OK
[   11.574169] Testing event ext4_ext_convert_to_initialized_fastpath: OK
[   11.640081] Testing event ext4_ext_convert_to_initialized_enter: OK
[   11.668731] Testing event ext4_truncate_exit: OK
[   11.675046] Testing event ext4_truncate_enter: OK
[   11.698434] Testing event ext4_unlink_exit: OK
[   11.720235] Testing event ext4_unlink_enter: OK
[   11.740592] Testing event ext4_fallocate_exit: OK
[   11.767315] Testing event ext4_zero_range: OK
[   11.795056] Testing event ext4_punch_hole: OK
[   11.801672] Testing event ext4_fallocate_enter: OK
[   11.845805] Testing event ext4_direct_IO_exit: OK
[   11.851675] Testing event ext4_direct_IO_enter: OK
[   11.872309] Testing event ext4_load_inode_bitmap: OK
[   11.893078] Testing event ext4_read_block_bitmap_load: OK
[   11.898308] Testing event ext4_mb_buddy_bitmap_load: OK
[   11.931197] Testing event ext4_mb_bitmap_load: OK
[   11.939056] Testing event ext4_da_release_space: OK
[   11.946082] Testing event ext4_da_reserve_space: OK
[   11.952197] Testing event ext4_da_update_reserve_space: OK
[   11.985962] Testing event ext4_forget: OK
[   12.009670] Testing event ext4_mballoc_free: OK
[   12.038227] Testing event ext4_mballoc_discard: OK
[   12.065273] Testing event ext4_mballoc_prealloc: OK
[   12.073396] Testing event ext4_mballoc_alloc: OK
[   12.096470] Testing event ext4_alloc_da_blocks: OK
[   12.102471] Testing event ext4_sync_fs: OK
[   12.112957] Testing event ext4_sync_file_exit: OK
[   12.118600] Testing event ext4_sync_file_enter: OK
[   12.130214] Testing event ext4_free_blocks: OK
[   12.176546] Testing event ext4_allocate_blocks: OK
[   12.184952] Testing event ext4_request_blocks: OK
[   12.228279] Testing event ext4_mb_discard_preallocations: OK
[   12.234894] Testing event ext4_discard_preallocations: OK
[   12.258312] Testing event ext4_mb_release_group_pa: OK
[   12.304155] Testing event ext4_mb_release_inode_pa: OK
[   12.323745] Testing event ext4_mb_new_group_pa: OK
[   12.346172] Testing event ext4_mb_new_inode_pa: OK
[   12.356380] Testing event ext4_discard_blocks: OK
[   12.393138] Testing event ext4_journalled_invalidatepage: OK
[   12.399742] Testing event ext4_invalidatepage: OK
[   12.413342] Testing event ext4_releasepage: OK
[   12.434426] Testing event ext4_readpage: OK
[   12.450128] Testing event ext4_writepage: OK
[   12.470092] Testing event ext4_writepages_result: OK
[   12.501340] Testing event ext4_da_write_pages_extent: OK
[   12.560177] Testing event ext4_da_write_pages: OK
[   12.588247] Testing event ext4_writepages: OK
[   12.613255] Testing event ext4_da_write_end: OK
[   12.652940] Testing event ext4_journalled_write_end: OK
[   12.671540] Testing event ext4_write_end: OK
[   12.708318] Testing event ext4_da_write_begin: OK
[   12.733673] Testing event ext4_write_begin: OK
[   12.759571] Testing event ext4_begin_ordered_truncate: OK
[   12.798179] Testing event ext4_mark_inode_dirty: OK
[   12.815185] Testing event ext4_drop_inode: OK
[   12.854134] Testing event ext4_evict_inode: OK
[   12.871591] Testing event ext4_allocate_inode: OK
[   12.898621] Testing event ext4_request_inode: OK
[   12.918175] Testing event ext4_free_inode: OK
[   12.957868] Testing event journal_write_superblock: OK
[   12.985143] Testing event jbd_cleanup_journal_tail: OK
[   13.007178] Testing event jbd_do_submit_data: OK
[   13.027155] Testing event jbd_end_commit: OK
[   13.041146] Testing event jbd_drop_transaction: OK
[   13.065284] Testing event jbd_commit_logging: OK
[   13.093170] Testing event jbd_commit_flushing: OK
[   13.116146] Testing event jbd_commit_locking: OK
[   13.129162] Testing event jbd_start_commit: OK
[   13.144499] Testing event jbd_checkpoint: OK
[   13.164520] Testing event jbd2_lock_buffer_stall: OK
[   13.184386] Testing event jbd2_write_superblock: OK
[   13.207825] Testing event jbd2_update_log_tail: OK
[   13.249810] Testing event jbd2_checkpoint_stats: OK
[   13.274497] Testing event jbd2_run_stats: OK
[   13.293376] Testing event jbd2_handle_stats: OK
[   13.321165] Testing event jbd2_handle_extend: OK
[   13.347855] Testing event jbd2_handle_start: OK
[   13.367819] Testing event jbd2_submit_inode_data: OK
[   13.384472] Testing event jbd2_end_commit: OK
[   13.401155] Testing event jbd2_drop_transaction: OK
[   13.411833] Testing event jbd2_commit_logging: OK
[   13.457828] Testing event jbd2_commit_flushing: OK
[   13.487832] Testing event jbd2_commit_locking: OK
[   13.504131] Testing event jbd2_start_commit: OK
[   13.590224] Testing event jbd2_checkpoint: OK
[   13.604122] Testing event btrfs_qgroup_record_ref: OK
[   13.653255] Testing event btrfs_qgroup_account: OK
[   13.711358] Testing event btrfs_workqueue_destroy: OK
[   13.738414] Testing event btrfs_workqueue_alloc: OK
[   13.768644] Testing event btrfs_ordered_sched: OK
[   13.786577] Testing event btrfs_all_work_done: OK
[   13.830414] Testing event btrfs_work_sched: OK
[   13.855754] Testing event btrfs_work_queued: OK
[   13.861325] Testing event free_extent_state: OK
[   13.872233] Testing event alloc_extent_state: OK
[   13.881235] Testing event btrfs_setup_cluster: OK
[   13.887924] Testing event btrfs_failed_cluster_setup: OK
[   13.894685] Testing event btrfs_find_cluster: OK
[   13.908114] Testing event btrfs_reserve_extent_cluster: OK
[   13.914486] Testing event btrfs_reserve_extent: OK
[   13.921160] Testing event find_free_extent: OK
[   13.927830] Testing event btrfs_reserved_extent_free: OK
[   13.934488] Testing event btrfs_reserved_extent_alloc: OK
[   13.941153] Testing event btrfs_space_reservation: OK
[   13.947817] Testing event btrfs_cow_block: OK
[   13.954493] Testing event btrfs_chunk_free: OK
[   13.961169] Testing event btrfs_chunk_alloc: OK
[   13.967812] Testing event run_delayed_ref_head: OK
[   13.974504] Testing event add_delayed_ref_head: OK
[   13.981302] Testing event run_delayed_data_ref: OK
[   13.997821] Testing event add_delayed_data_ref: OK
[   14.004540] Testing event run_delayed_tree_ref: OK
[   14.011287] Testing event add_delayed_tree_ref: OK
[   14.017885] Testing event btrfs_sync_fs: OK
[   14.024547] Testing event btrfs_sync_file: OK
[   14.034107] Testing event btrfs_writepage_end_io_hook: OK
[   14.041149] Testing event __extent_writepage: OK
[   14.047927] Testing event btrfs_ordered_extent_put: OK
[   14.058109] Testing event btrfs_ordered_extent_start: OK
[   14.064593] Testing event btrfs_ordered_extent_remove: OK
[   14.071290] Testing event btrfs_ordered_extent_add: OK
[   14.081142] Testing event btrfs_get_extent: OK
[   14.091113] Testing event btrfs_inode_evict: OK
[   14.097783] Testing event btrfs_inode_request: OK
[   14.104445] Testing event btrfs_inode_new: OK
[   14.111184] Testing event btrfs_transaction_commit: OK
[   14.117817] Testing event block_rq_remap: OK
[   14.127778] Testing event block_bio_remap: OK
[   14.134443] Testing event block_split: OK
[   14.141117] Testing event block_unplug: OK
[   14.151116] Testing event block_plug: OK
[   14.157777] Testing event block_sleeprq: OK
[   14.164440] Testing event block_getrq: OK
[   14.174440] Testing event block_bio_queue: OK
[   14.181111] Testing event block_bio_frontmerge: OK
[   14.187767] Testing event block_bio_backmerge: OK
[   14.194435] Testing event block_bio_complete: OK
[   14.201109] Testing event block_bio_bounce: OK
[   14.207767] Testing event block_rq_issue: OK
[   14.214439] Testing event block_rq_insert: OK
[   14.221111] Testing event block_rq_complete: OK
[   14.227769] Testing event block_rq_requeue: OK
[   14.234425] Testing event block_rq_abort: OK
[   14.241118] Testing event block_dirty_buffer: OK
[   14.247773] Testing event block_touch_buffer: OK
[   14.254418] Testing event swiotlb_bounced: OK
[   14.261113] Testing event gpio_value: OK
[   14.270125] Testing event gpio_direction: OK
[   14.274421] Testing event regulator_set_voltage_complete: OK
[   14.281114] Testing event regulator_set_voltage: OK
[   14.287773] Testing event regulator_disable_complete: OK
[   14.294417] Testing event regulator_disable: OK
[   14.301087] Testing event regulator_enable_complete: OK
[   14.307757] Testing event regulator_enable_delay: OK
[   14.314419] Testing event regulator_enable: OK
[   14.321102] Testing event urandom_read: OK
[   14.327761] Testing event random_read: OK
[   14.334400] Testing event extract_entropy_user: OK
[   14.341088] Testing event extract_entropy: OK
[   14.347785] Testing event get_random_bytes_arch: OK
[   14.354398] Testing event get_random_bytes: OK
[   14.361087] Testing event xfer_secondary_pool: OK
[   14.367762] Testing event add_disk_randomness: OK
[   14.374429] Testing event add_input_randomness: OK
[   14.381091] Testing event debit_entropy: OK
[   14.387733] Testing event push_to_pool: OK
[   14.394406] Testing event credit_entropy_bits: OK
[   14.401064] Testing event mix_pool_bytes_nolock: OK
[   14.407724] Testing event mix_pool_bytes: OK
[   14.414381] Testing event add_device_randomness: OK
[   14.421060] Testing event drm_vblank_event_delivered: OK
[   14.427717] Testing event drm_vblank_event_queued: OK
[   14.434393] Testing event drm_vblank_event: OK
[   14.441074] Testing event regcache_drop_region: OK
[   14.447724] Testing event regmap_async_complete_done: OK
[   14.454380] Testing event regmap_async_complete_start: OK
[   14.461058] Testing event regmap_async_io_complete: OK
[   14.467711] Testing event regmap_async_write_start: OK
[   14.474382] Testing event regmap_cache_bypass: OK
[   14.481050] Testing event regmap_cache_only: OK
[   14.487701] Testing event regcache_sync: OK
[   14.494366] Testing event regmap_hw_write_done: OK
[   14.501053] Testing event regmap_hw_write_start: OK
[   14.507711] Testing event regmap_hw_read_done: OK
[   14.514358] Testing event regmap_hw_read_start: OK
[   14.521037] Testing event regmap_reg_read_cache: OK
[   14.527694] Testing event regmap_reg_read: OK
[   14.534352] Testing event regmap_reg_write: OK
[   14.541036] Testing event fence_wait_end: OK
[   14.547686] Testing event fence_wait_start: OK
[   14.554350] Testing event fence_signaled: OK
[   14.561030] Testing event fence_enable_signal: OK
[   14.567682] Testing event fence_destroy: OK
[   14.574346] Testing event fence_init: OK
[   14.581031] Testing event fence_emit: OK
[   14.587679] Testing event fence_annotate_wait_on: OK
[   14.594344] Testing event scsi_eh_wakeup: OK
[   14.601022] Testing event scsi_dispatch_cmd_timeout: OK
[   14.607672] Testing event scsi_dispatch_cmd_done: OK
[   14.614330] Testing event scsi_dispatch_cmd_error: OK
[   14.621013] Testing event scsi_dispatch_cmd_start: OK
[   14.627671] Testing event target_cmd_complete: OK
[   14.634326] Testing event target_sequencer_start: OK
[   14.641008] Testing event docg3_io: OK
[   14.647658] Testing event spi_transfer_stop: OK
[   14.654321] Testing event spi_transfer_start: OK
[   14.660989] Testing event spi_message_done: OK
[   14.667654] Testing event spi_message_start: OK
[   14.674316] Testing event spi_message_submit: OK
[   14.680982] Testing event spi_master_busy: OK
[   14.687650] Testing event spi_master_idle: OK
[   14.694318] Testing event dwc3_complete_trb: OK
[   14.700978] Testing event dwc3_prepare_trb: OK
[   14.707656] Testing event dwc3_gadget_ep_cmd: OK
[   14.714307] Testing event dwc3_gadget_generic_cmd: OK
[   14.720984] Testing event dwc3_gadget_giveback: OK
[   14.727644] Testing event dwc3_ep_dequeue: OK
[   14.734330] Testing event dwc3_ep_queue: OK
[   14.740971] Testing event dwc3_free_request: OK
[   14.747636] Testing event dwc3_alloc_request: OK
[   14.754304] Testing event dwc3_ctrl_req: OK
[   14.760966] Testing event dwc3_event: OK
[   14.767655] Testing event dwc3_ep0: OK
[   14.774294] Testing event dwc3_writel: OK
[   14.780963] Testing event dwc3_readl: OK
[   14.787640] Testing event xhci_cmd_completion: OK
[   14.794292] Testing event xhci_address_ctx: OK
[   14.800956] Testing event xhci_dbg_ring_expansion: OK
[   14.807623] Testing event xhci_dbg_init: OK
[   14.814284] Testing event xhci_dbg_cancel_urb: OK
[   14.820954] Testing event xhci_dbg_reset_ep: OK
[   14.827621] Testing event xhci_dbg_quirks: OK
[   14.834282] Testing event xhci_dbg_context_change: OK
[   14.840945] Testing event xhci_dbg_address: OK
[   14.847613] Testing event smbus_result: OK
[   14.854278] Testing event smbus_reply: OK
[   14.860944] Testing event smbus_read: OK
[   14.867608] Testing event smbus_write: OK
[   14.874272] Testing event i2c_result: OK
[   14.880938] Testing event i2c_reply: OK
[   14.887605] Testing event i2c_read: OK
[   14.894269] Testing event i2c_write: OK
[   14.900932] Testing event v4l2_qbuf: OK
[   14.907605] Testing event v4l2_dqbuf: OK
[   14.914264] Testing event thermal_zone_trip: OK
[   14.920927] Testing event cdev_update: OK
[   14.927598] Testing event thermal_temperature: OK
[   14.934257] Testing event bcache_writeback_collision: OK
[   14.940930] Testing event bcache_writeback: OK
[   14.947593] Testing event bcache_alloc_fail: OK
[   14.954253] Testing event bcache_alloc: OK
[   14.960923] Testing event bcache_invalidate: OK
[   14.967587] Testing event bcache_keyscan: OK
[   14.974253] Testing event bcache_btree_set_root: OK
[   14.980925] Testing event bcache_btree_node_compact: OK
[   14.987581] Testing event bcache_btree_node_split: OK
[   14.994248] Testing event bcache_btree_insert_key: OK
[   15.000923] Testing event bcache_gc_copy_collision: OK
[   15.007576] Testing event bcache_gc_copy: OK
[   15.014239] Testing event bcache_gc_end: OK
[   15.020925] Testing event bcache_gc_start: OK
[   15.027576] Testing event bcache_btree_gc_coalesce: OK
[   15.034237] Testing event bcache_btree_node_free: OK
[   15.040905] Testing event bcache_btree_node_alloc_fail: OK
[   15.047568] Testing event bcache_btree_node_alloc: OK
[   15.054231] Testing event bcache_btree_write: OK
[   15.060897] Testing event bcache_btree_read: OK
[   15.067563] Testing event bcache_btree_cache_cannibalize: OK
[   15.074226] Testing event bcache_journal_write: OK
[   15.080891] Testing event bcache_journal_entry_full: OK
[   15.087571] Testing event bcache_journal_full: OK
[   15.094224] Testing event bcache_journal_replay_key: OK
[   15.100892] Testing event bcache_cache_insert: OK
[   15.107556] Testing event bcache_read_retry: OK
[   15.114217] Testing event bcache_write: OK
[   15.120882] Testing event bcache_read: OK
[   15.127557] Testing event bcache_bypass_congested: OK
[   15.134212] Testing event bcache_bypass_sequential: OK
[   15.140878] Testing event bcache_request_end: OK
[   15.147556] Testing event bcache_request_start: OK
[   15.154208] Testing event udp_fail_queue_rcv_skb: OK
[   15.160878] Testing event sock_exceed_buf_limit: OK
[   15.167542] Testing event sock_rcvqueue_full: OK
[   15.174205] Testing event napi_poll: OK
[   15.180870] Testing event netif_rx_ni_entry: OK
[   15.187536] Testing event netif_rx_entry: OK
[   15.194201] Testing event netif_receive_skb_entry: OK
[   15.200869] Testing event napi_gro_receive_entry: OK
[   15.207532] Testing event napi_gro_frags_entry: OK
[   15.214195] Testing event netif_rx: OK
[   15.220859] Testing event netif_receive_skb: OK
[   15.227529] Testing event net_dev_queue: OK
[   15.234190] Testing event net_dev_xmit: OK
[   15.240854] Testing event net_dev_start_xmit: OK
[   15.247523] Testing event skb_copy_datagram_iovec: OK
[   15.254186] Testing event consume_skb: OK
[   15.260858] Testing event kfree_skb: OK
[   15.267519] Running tests on trace event systems:
[   15.268275] Testing event system skb: OK
[   15.274191] Testing event system net: OK
[   15.280857] Testing event system napi: OK
[   15.287533] Testing event system sock: OK
[   15.294187] Testing event system udp: OK
[   15.300849] Testing event system bcache: OK
[   15.307555] Testing event system thermal: OK
[   15.314186] Testing event system v4l2: OK
[   15.320849] Testing event system i2c: OK
[   15.327520] Testing event system xhci-hcd: OK
[   15.334193] Testing event system dwc3: OK
[   15.340844] Testing event system spi: OK
[   15.347511] Testing event system docg3: OK
[   15.354174] Testing event system target: OK
[   15.360847] Testing event system scsi: OK
[   15.367507] Testing event system fence: OK
[   15.374186] Testing event system regmap: OK
[   15.380885] Testing event system drm: OK
[   15.387509] Testing event system random: OK
[   15.394170] Testing event system regulator: OK
[   15.400835] Testing event system gpio: OK
[   15.407494] Testing event system swiotlb: OK
[   15.414159] Testing event system block: OK
[   15.420829] Testing event system btrfs: OK
[   15.427508] Testing event system jbd2: OK
[   15.434156] Testing event system jbd: OK
[   15.440821] Testing event system ext4: OK
[   15.447519] Testing event system ext3: OK
[   15.454160] Testing event system filelock: OK
[   15.460816] Testing event system writeback: OK
[   15.467489] Testing event system migrate: OK
[   15.474144] Testing event system compaction: OK
[   15.480824] Testing event system kmem: OK
[   15.487483] Testing event system vmscan: OK
[   15.494157] Testing event system pagemap: OK
[   15.500803] Testing event system oom: OK
[   15.507487] Testing event system filemap: OK
[   15.514135] Testing event system rpm: OK
[   15.520802] Testing event system power: OK
[   15.527481] Testing event system test: OK
[   15.534129] Testing event system timer: OK
[   15.540809] Testing event system rcu: OK
[   15.547462] Testing event system printk: OK
[   15.554123] Testing event system lock: OK
[   15.560825] Testing event system sched: OK
[   15.567474] Testing event system workqueue: OK
[   15.574123] Testing event system signal: OK
[   15.580786] Testing event system irq: OK
[   15.587457] Testing event system task: OK
[   15.594126] Testing event system exceptions: OK
[   15.600783] Testing event system tlb: OK
[   15.607449] Testing event system mce: OK
[   15.614127] Testing event system raw_syscalls: OK
[   15.620792] Testing event system nmi: OK
[   15.627447] Testing event system irq_vectors: OK
[   15.634140] Testing event system xen: OK
[   15.640782] Running tests on all trace events:
[   15.641514] Testing all events: OK
[   15.794982] Running tests again, along with the function tracer
[   15.796217] Running tests on trace events:
[   15.797161] Testing event xen_cpu_set_ldt:=20
[   15.814111] test-events (730) used greatest stack depth: 7140 bytes left
[   15.815640] OK
[   15.816046] Testing event xen_cpu_write_gdt_entry: OK
[   15.827238] Testing event xen_cpu_load_idt: OK
[   15.834176] Testing event xen_cpu_write_idt_entry: OK
[   15.840852] Testing event xen_cpu_write_ldt_entry: OK
[   15.847511] Testing event xen_mmu_write_cr3: OK
[   15.854175] Testing event xen_mmu_flush_tlb_others: OK
[   15.860856] Testing event xen_mmu_flush_tlb_single: OK
[   15.867499] Testing event xen_mmu_flush_tlb: OK
[   15.874165] Testing event xen_mmu_flush_tlb_all: OK
[   15.880863] Testing event xen_mmu_pgd_unpin: OK
[   15.887482] Testing event xen_mmu_pgd_pin: OK
[   15.894166] Testing event xen_mmu_release_ptpage: OK
[   15.900838] Testing event xen_mmu_alloc_ptpage: OK
[   15.907494] Testing event xen_mmu_ptep_modify_prot_commit: OK
[   15.914182] Testing event xen_mmu_ptep_modify_prot_start: OK
[   15.920828] Testing event xen_mmu_pgd_clear: OK
[   15.927472] Testing event xen_mmu_set_pud: OK
[   15.934162] Testing event xen_mmu_pmd_clear: OK
[   15.940825] Testing event xen_mmu_set_pmd: OK
[   15.947494] Testing event xen_mmu_pte_clear: OK
[   15.954159] Testing event xen_mmu_set_pte_at: OK
[   15.960821] Testing event xen_mmu_set_domain_pte: OK
[   15.967476] Testing event xen_mmu_set_pte_atomic: OK
[   15.974153] Testing event xen_mmu_set_pte: OK
[   15.980835] Testing event xen_mc_extend_args: OK
[   15.987483] Testing event xen_mc_flush: OK
[   15.994144] Testing event xen_mc_flush_reason: OK
[   16.000817] Testing event xen_mc_callback: OK
[   16.007465] Testing event xen_mc_entry_alloc: OK
[   16.014162] Testing event xen_mc_entry: OK
[   16.020805] Testing event xen_mc_issue: OK
[   16.027455] Testing event xen_mc_batch: OK
[   16.034138] Testing event thermal_apic_exit: OK
[   16.040814] Testing event thermal_apic_entry: OK
[   16.047470] Testing event threshold_apic_exit: OK
[   16.054138] Testing event threshold_apic_entry: OK
[   16.060811] Testing event call_function_single_exit: OK
[   16.067444] Testing event call_function_single_entry: OK
[   16.074123] Testing event call_function_exit: OK
[   16.080823] Testing event call_function_entry: OK
[   16.087449] Testing event irq_work_exit:=20
[   16.088463] test-events (770) used greatest stack depth: 7120 bytes left
[   16.093984] OK
[   16.094406] Testing event irq_work_entry: OK
[   16.100816] Testing event x86_platform_ipi_exit: OK
[   16.107440] Testing event x86_platform_ipi_entry: OK
[   16.114143] Testing event error_apic_exit: OK
[   16.120792] Testing event error_apic_entry: OK
[   16.127439] Testing event spurious_apic_exit: OK
[   16.134115] Testing event spurious_apic_entry: OK
[   16.140777] Testing event reschedule_exit: OK
[   16.147446] Testing event reschedule_entry: OK
[   16.154102] Testing event local_timer_exit: OK
[   16.160782] Testing event local_timer_entry: OK
[   16.167424] Testing event nmi_handler: OK
[   16.174105] Testing event sys_exit: OK
[   16.180790] Testing event sys_enter: OK
[   16.187430] Testing event mce_record: OK
[   16.194098] Testing event tlb_flush: OK
[   16.200768] Testing event page_fault_kernel: OK
[   16.207412] Testing event page_fault_user: OK
[   16.214112] Testing event task_rename: OK
[   16.220766] Testing event task_newtask: OK
[   16.227410] Testing event softirq_raise: OK
[   16.234082] Testing event softirq_exit: OK
[   16.240738] Testing event softirq_entry: OK
[   16.247406] Testing event irq_handler_exit: OK
[   16.254071] Testing event irq_handler_entry: OK
[   16.260734] Testing event signal_deliver: OK
[   16.267378] Testing event signal_generate: OK
[   16.274089] Testing event workqueue_execute_end: OK
[   16.280746] Testing event workqueue_execute_start: OK
[   16.287374] Testing event workqueue_activate_work: OK
[   16.294051] Testing event workqueue_queue_work: OK
[   16.300723] Testing event sched_wake_idle_without_ipi: OK
[   16.307371] Testing event sched_swap_numa: OK
[   16.314066] Testing event sched_stick_numa: OK
[   16.320725] Testing event sched_move_numa: OK
[   16.327365] Testing event sched_pi_setprio: OK
[   16.334044] Testing event sched_stat_runtime: OK
[   16.340734] Testing event sched_stat_blocked: OK
[   16.347377] Testing event sched_stat_iowait: OK
[   16.354039] Testing event sched_stat_sleep: OK
[   16.360710] Testing event sched_stat_wait: OK
[   16.367363] Testing event sched_process_exec: OK
[   16.374040] Testing event sched_process_fork: OK
[   16.380724] Testing event sched_process_wait: OK
[   16.387351] Testing event sched_wait_task: OK
[   16.394036] Testing event sched_process_exit: OK
[   16.400702] Testing event sched_process_free: OK
[   16.407341] Testing event sched_migrate_task: OK
[   16.414046] Testing event sched_switch: OK
[   16.420696] Testing event sched_wakeup_new: OK
[   16.427344] Testing event sched_wakeup: OK
[   16.434025] Testing event sched_kthread_stop_ret: OK
[   16.440696] Testing event sched_kthread_stop: OK
[   16.447360] Testing event lock_release: OK
[   16.454045] Testing event lock_acquire: OK
[   16.460718] Testing event console: OK
[   16.467355] Testing event rcu_utilization: OK
[   16.474011] Testing event itimer_expire: OK
[   16.480703] Testing event itimer_state: OK
[   16.487335] Testing event hrtimer_cancel: OK
[   16.494005] Testing event hrtimer_expire_exit: OK
[   16.500707] Testing event hrtimer_expire_entry: OK
[   16.507582] Testing event hrtimer_start: OK
[   16.514060] Testing event hrtimer_init: OK
[   16.520679] Testing event timer_cancel: OK
[   16.527323] Testing event timer_expire_exit: OK
[   16.533984] Testing event timer_expire_entry: OK
[   16.540676] Testing event timer_start: OK
[   16.547337] Testing event timer_init: OK
[   16.553981] Testing event ftrace_test_filter: OK
[   16.560674] Testing event dev_pm_qos_remove_request: OK
[   16.567311] Testing event dev_pm_qos_update_request: OK
[   16.573980] Testing event dev_pm_qos_add_request: OK
[   16.580686] Testing event pm_qos_update_flags: OK
[   16.587309] Testing event pm_qos_update_target: OK
[   16.593971] Testing event pm_qos_update_request_timeout: OK
[   16.600654] Testing event pm_qos_remove_request: OK
[   16.607300] Testing event pm_qos_update_request: OK
[   16.613987] Testing event pm_qos_add_request: OK
[   16.620648] Testing event power_domain_target: OK
[   16.627302] Testing event clock_set_rate: OK
[   16.633960] Testing event clock_disable: OK
[   16.640661] Testing event clock_enable: OK
[   16.647310] Testing event wakeup_source_deactivate: OK
[   16.653957] Testing event wakeup_source_activate: OK
[   16.660639] Testing event suspend_resume: OK
[   16.667291] Testing event device_pm_callback_end: OK
[   16.673949] Testing event device_pm_callback_start: OK
[   16.680673] Testing event cpu_frequency: OK
[   16.687282] Testing event pstate_sample: OK
[   16.693949] Testing event cpu_idle: OK
[   16.700635] Testing event rpm_return_int: OK
[   16.707278] Testing event rpm_idle: OK
[   16.713963] Testing event rpm_resume: OK
[   16.720627] Testing event rpm_suspend: OK
[   16.727287] Testing event mm_filemap_add_to_page_cache: OK
[   16.733940] Testing event mm_filemap_delete_from_page_cache: OK
[   16.740624] Testing event oom_score_adj_update: OK
[   16.747283] Testing event mm_lru_activate: OK
[   16.753933] Testing event mm_lru_insertion: OK
[   16.760618] Testing event mm_vmscan_lru_shrink_inactive: OK
[   16.767261] Testing event mm_vmscan_writepage: OK
[   16.773929] Testing event mm_vmscan_memcg_isolate: OK
[   16.780634] Testing event mm_vmscan_lru_isolate: OK
[   16.787260] Testing event mm_shrink_slab_end: OK
[   16.793923] Testing event mm_shrink_slab_start: OK
[   16.800612] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[   16.807257] Testing event mm_vmscan_memcg_reclaim_end: OK
[   16.813937] Testing event mm_vmscan_direct_reclaim_end: OK
[   16.820606] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[   16.827249] Testing event mm_vmscan_memcg_reclaim_begin: OK
[   16.833916] Testing event mm_vmscan_direct_reclaim_begin: OK
[   16.840597] Testing event mm_vmscan_wakeup_kswapd: OK
[   16.847266] Testing event mm_vmscan_kswapd_wake: OK
[   16.853913] Testing event mm_vmscan_kswapd_sleep: OK
[   16.860596] Testing event mm_page_alloc_extfrag: OK
[   16.867247] Testing event mm_page_pcpu_drain: OK
[   16.873905] Testing event mm_page_alloc_zone_locked: OK
[   16.880608] Testing event mm_page_alloc: OK
[   16.887240] Testing event mm_page_free_batched: OK
[   16.893902] Testing event mm_page_free: OK
[   16.900587] Testing event kmem_cache_free: OK
[   16.907233] Testing event kfree: OK
[   16.913917] Testing event kmem_cache_alloc_node: OK
[   16.920579] Testing event kmalloc_node: OK
[   16.927227] Testing event kmem_cache_alloc: OK
[   16.933891] Testing event kmalloc: OK
[   16.940581] Testing event mm_compaction_end: OK
[   16.947237] Testing event mm_compaction_begin: OK
[   16.953892] Testing event mm_compaction_migratepages: OK
[   16.960571] Testing event mm_compaction_isolate_freepages: OK
[   16.967221] Testing event mm_compaction_isolate_migratepages: OK
[   16.973881] Testing event mm_numa_migrate_ratelimit: OK
[   16.980589] Testing event mm_migrate_pages: OK
[   16.987210] Testing event writeback_single_inode: OK
[   16.993882] Testing event writeback_single_inode_start: OK
[   17.000559] Testing event writeback_wait_iff_congested: OK
[   17.007215] Testing event writeback_congestion_wait: OK
[   17.013890] Testing event writeback_sb_inodes_requeue: OK
[   17.020562] Testing event balance_dirty_pages: OK
[   17.027202] Testing event bdi_dirty_ratelimit: OK
[   17.033872] Testing event global_dirty_state: OK
[   17.040553] Testing event writeback_queue_io: OK
[   17.047223] Testing event wbc_writepage:=20
[   17.048062] test-events (914) used greatest stack depth: 7088 bytes left
[   17.053763] OK
[   17.054109] Testing event writeback_bdi_unregister: OK
[   17.060548] Testing event writeback_bdi_register: OK
[   17.067203] Testing event writeback_wake_background: OK
[   17.073858] Testing event writeback_nowork: OK
[   17.080567] Testing event writeback_pages_written: OK
[   17.087197] Testing event writeback_wait: OK
[   17.093862] Testing event writeback_written: OK
[   17.100539] Testing event writeback_start: OK
[   17.107232] Testing event writeback_exec: OK
[   17.113869] Testing event writeback_queue: OK
[   17.120539] Testing event writeback_write_inode: OK
[   17.127196] Testing event writeback_write_inode_start: OK
[   17.133848] Testing event writeback_dirty_inode: OK
[   17.140528] Testing event writeback_dirty_inode_start: OK
[   17.147215] Testing event writeback_dirty_page: OK
[   17.153841] Testing event time_out_leases: OK
[   17.160529] Testing event generic_delete_lease: OK
[   17.167185] Testing event generic_add_lease: OK
[   17.173846] Testing event break_lease_unblock: OK
[   17.180537] Testing event break_lease_block: OK
[   17.187188] Testing event break_lease_noblock: OK
[   17.193830] Testing event ext3_load_inode: OK
[   17.200520] Testing event ext3_get_blocks_exit: OK
[   17.207182] Testing event ext3_get_blocks_enter: OK
[   17.213845] Testing event ext3_truncate_exit: OK
[   17.220519] Testing event ext3_truncate_enter: OK
[   17.227172] Testing event ext3_unlink_exit: OK
[   17.233824] Testing event ext3_unlink_enter: OK
[   17.240513] Testing event ext3_direct_IO_exit: OK
[   17.247182] Testing event ext3_direct_IO_enter: OK
[   17.253822] Testing event ext3_read_block_bitmap: OK
[   17.260502] Testing event ext3_forget: OK
[   17.267182] Testing event ext3_reserved: OK
[   17.273820] Testing event ext3_alloc_new_reservation: OK
[   17.280520] Testing event ext3_discard_reservation: OK
[   17.287166] Testing event ext3_rsv_window_add: OK
[   17.293827] Testing event ext3_sync_fs: OK
[   17.300498] Testing event ext3_sync_file_exit: OK
[   17.307154] Testing event ext3_sync_file_enter: OK
[   17.313828] Testing event ext3_free_blocks: OK
[   17.320491] Testing event ext3_allocate_blocks: OK
[   17.327150] Testing event ext3_request_blocks: OK
[   17.333802] Testing event ext3_discard_blocks: OK
[   17.340487] Testing event ext3_invalidatepage: OK
[   17.347166] Testing event ext3_releasepage: OK
[   17.353800] Testing event ext3_readpage: OK
[   17.360490] Testing event ext3_journalled_writepage: OK
[   17.367151] Testing event ext3_writeback_writepage: OK
[   17.373799] Testing event ext3_ordered_writepage: OK
[   17.380496] Testing event ext3_journalled_write_end: OK
[   17.387136] Testing event ext3_writeback_write_end: OK
[   17.393789] Testing event ext3_ordered_write_end: OK
[   17.400470] Testing event ext3_write_begin: OK
[   17.407143] Testing event ext3_mark_inode_dirty: OK
[   17.413799] Testing event ext3_drop_inode: OK
[   17.420469] Testing event ext3_evict_inode: OK
[   17.427138] Testing event ext3_allocate_inode: OK
[   17.433780] Testing event ext3_request_inode: OK
[   17.440465] Testing event ext3_free_inode: OK
[   17.447146] Testing event ext4_es_shrink: OK
[   17.453775] Testing event ext4_collapse_range: OK
[   17.460460] Testing event ext4_es_shrink_scan_exit: OK
[   17.467121] Testing event ext4_es_shrink_scan_enter: OK
[   17.473770] Testing event ext4_es_shrink_count: OK
[   17.480474] Testing event ext4_es_lookup_extent_exit: OK
[   17.487114] Testing event ext4_es_lookup_extent_enter: OK
[   17.493772] Testing event ext4_es_find_delayed_extent_range_exit: OK
[   17.500453] Testing event ext4_es_find_delayed_extent_range_enter: OK
[   17.507113] Testing event ext4_es_remove_extent: OK
[   17.513775] Testing event ext4_es_cache_extent: OK
[   17.520448] Testing event ext4_es_insert_extent: OK
[   17.527104] Testing event ext4_ext_remove_space_done: OK
[   17.533758] Testing event ext4_ext_remove_space: OK
[   17.540440] Testing event ext4_ext_rm_idx: OK
[   17.547121] Testing event ext4_ext_rm_leaf: OK
[   17.553748] Testing event ext4_remove_blocks: OK
[   17.560439] Testing event ext4_ext_show_extent: OK
[   17.567092] Testing event ext4_get_reserved_cluster_alloc: OK
[   17.573750] Testing event ext4_find_delalloc_range: OK
[   17.580447] Testing event ext4_ext_in_cache: OK
[   17.587092] Testing event ext4_ext_put_in_cache: OK
[   17.593747] Testing event ext4_get_implied_cluster_alloc_exit: OK
[   17.600423] Testing event ext4_ext_handle_unwritten_extents: OK
[   17.607088] Testing event ext4_trim_all_free: OK
[   17.613753] Testing event ext4_trim_extent: OK
[   17.620422] Testing event ext4_journal_start_reserved: OK
[   17.627077] Testing event ext4_journal_start: OK
[   17.633734] Testing event ext4_load_inode: OK
[   17.640440] Testing event ext4_ext_load_extent: OK
[   17.647103] Testing event ext4_ind_map_blocks_exit: OK
[   17.653732] Testing event ext4_ext_map_blocks_exit: OK
[   17.660420] Testing event ext4_ind_map_blocks_enter: OK
[   17.667073] Testing event ext4_ext_map_blocks_enter: OK
[   17.673722] Testing event ext4_ext_convert_to_initialized_fastpath: OK
[   17.680438] Testing event ext4_ext_convert_to_initialized_enter: OK
[   17.687067] Testing event ext4_truncate_exit: OK
[   17.693722] Testing event ext4_truncate_enter: OK
[   17.700403] Testing event ext4_unlink_exit: OK
[   17.707067] Testing event ext4_unlink_enter: OK
[   17.713737] Testing event ext4_fallocate_exit: OK
[   17.720403] Testing event ext4_zero_range: OK
[   17.727057] Testing event ext4_punch_hole: OK
[   17.733710] Testing event ext4_fallocate_enter: OK
[   17.740395] Testing event ext4_direct_IO_exit: OK
[   17.747075] Testing event ext4_direct_IO_enter: OK
[   17.753705] Testing event ext4_load_inode_bitmap: OK
[   17.760394] Testing event ext4_read_block_bitmap_load: OK
[   17.767045] Testing event ext4_mb_buddy_bitmap_load: OK
[   17.773702] Testing event ext4_mb_bitmap_load: OK
[   17.780407] Testing event ext4_da_release_space: OK
[   17.787045] Testing event ext4_da_reserve_space: OK
[   17.793694] Testing event ext4_da_update_reserve_space: OK
[   17.800386] Testing event ext4_forget: OK
[   17.807036] Testing event ext4_mballoc_free: OK
[   17.813716] Testing event ext4_mballoc_discard: OK
[   17.820379] Testing event ext4_mballoc_prealloc: OK
[   17.827036] Testing event ext4_mballoc_alloc: OK
[   17.833690] Testing event ext4_alloc_da_blocks: OK
[   17.840377] Testing event ext4_sync_fs: OK
[   17.847048] Testing event ext4_sync_file_exit: OK
[   17.853685] Testing event ext4_sync_file_enter: OK
[   17.860370] Testing event ext4_free_blocks: OK
[   17.867044] Testing event ext4_allocate_blocks: OK
[   17.873679] Testing event ext4_request_blocks: OK
[   17.880383] Testing event ext4_mb_discard_preallocations: OK
[   17.887027] Testing event ext4_discard_preallocations: OK
[   17.893677] Testing event ext4_mb_release_group_pa: OK
[   17.900368] Testing event ext4_mb_release_inode_pa: OK
[   17.907012] Testing event ext4_mb_new_group_pa: OK
[   17.913689] Testing event ext4_mb_new_inode_pa: OK
[   17.920358] Testing event ext4_discard_blocks: OK
[   17.927011] Testing event ext4_journalled_invalidatepage: OK
[   17.933664] Testing event ext4_invalidatepage: OK
[   17.940357] Testing event ext4_releasepage: OK
[   17.947027] Testing event ext4_readpage: OK
[   17.953658] Testing event ext4_writepage: OK
[   17.960358] Testing event ext4_writepages_result: OK
[   17.966990] Testing event ext4_da_write_pages_extent: OK
[   17.973664] Testing event ext4_da_write_pages: OK
[   17.980387] Testing event ext4_writepages: OK
[   17.986990] Testing event ext4_da_write_end: OK
[   17.993649] Testing event ext4_journalled_write_end: OK
[   18.000356] Testing event ext4_write_end: OK
[   18.006985] Testing event ext4_da_write_begin: OK
[   18.013670] Testing event ext4_write_begin: OK
[   18.020336] Testing event ext4_begin_ordered_truncate: OK
[   18.026979] Testing event ext4_mark_inode_dirty: OK
[   18.033643] Testing event ext4_drop_inode: OK
[   18.040331] Testing event ext4_evict_inode: OK
[   18.047010] Testing event ext4_allocate_inode: OK
[   18.053656] Testing event ext4_request_inode: OK
[   18.060332] Testing event ext4_free_inode: OK
[   18.066969] Testing event journal_write_superblock: OK
[   18.073649] Testing event jbd_cleanup_journal_tail: OK
[   18.080342] Testing event jbd_do_submit_data: OK
[   18.086987] Testing event jbd_end_commit: OK
[   18.093638] Testing event jbd_drop_transaction: OK
[   18.100319] Testing event jbd_commit_logging: OK
[   18.106963] Testing event jbd_commit_flushing: OK
[   18.113643] Testing event jbd_commit_locking: OK
[   18.120314] Testing event jbd_start_commit: OK
[   18.126977] Testing event jbd_checkpoint: OK
[   18.133640] Testing event jbd2_lock_buffer_stall: OK
[   18.140321] Testing event jbd2_write_superblock: OK
[   18.146971] Testing event jbd2_update_log_tail: OK
[   18.153615] Testing event jbd2_checkpoint_stats: OK
[   18.160305] Testing event jbd2_run_stats: OK
[   18.166950] Testing event jbd2_handle_stats: OK
[   18.173610] Testing event jbd2_handle_extend: OK
[   18.180320] Testing event jbd2_handle_start: OK
[   18.186940] Testing event jbd2_submit_inode_data: OK
[   18.193608] Testing event jbd2_end_commit: OK
[   18.200297] Testing event jbd2_drop_transaction: OK
[   18.206940] Testing event jbd2_commit_logging: OK
[   18.213616] Testing event jbd2_commit_flushing: OK
[   18.220286] Testing event jbd2_commit_locking: OK
[   18.226928] Testing event jbd2_start_commit: OK
[   18.233599] Testing event jbd2_checkpoint: OK
[   18.240285] Testing event btrfs_qgroup_record_ref: OK
[   18.246960] Testing event btrfs_qgroup_account: OK
[   18.253594] Testing event btrfs_workqueue_destroy: OK
[   18.260281] Testing event btrfs_workqueue_alloc: OK
[   18.266925] Testing event btrfs_ordered_sched: OK
[   18.273595] Testing event btrfs_all_work_done: OK
[   18.280293] Testing event btrfs_work_sched: OK
[   18.286921] Testing event btrfs_work_queued: OK
[   18.293583] Testing event free_extent_state: OK
[   18.300274] Testing event alloc_extent_state: OK
[   18.306915] Testing event btrfs_setup_cluster: OK
[   18.313600] Testing event btrfs_failed_cluster_setup: OK
[   18.320270] Testing event btrfs_find_cluster: OK
[   18.326912] Testing event btrfs_reserve_extent_cluster: OK
[   18.333574] Testing event btrfs_reserve_extent: OK
[   18.340263] Testing event find_free_extent: OK
[   18.346927] Testing event btrfs_reserved_extent_free: OK
[   18.353571] Testing event btrfs_reserved_extent_alloc: OK
[   18.360257] Testing event btrfs_space_reservation: OK
[   18.366911] Testing event btrfs_cow_block: OK
[   18.373570] Testing event btrfs_chunk_free: OK
[   18.380270] Testing event btrfs_chunk_alloc: OK
[   18.386893] Testing event run_delayed_ref_head: OK
[   18.393565] Testing event add_delayed_ref_head: OK
[   18.400249] Testing event run_delayed_data_ref: OK
[   18.406892] Testing event add_delayed_data_ref: OK
[   18.413577] Testing event run_delayed_tree_ref: OK
[   18.420244] Testing event add_delayed_tree_ref: OK
[   18.426885] Testing event btrfs_sync_fs: OK
[   18.433551] Testing event btrfs_sync_file: OK
[   18.440244] Testing event btrfs_writepage_end_io_hook: OK
[   18.446902] Testing event __extent_writepage: OK
[   18.453551] Testing event btrfs_ordered_extent_put: OK
[   18.460235] Testing event btrfs_ordered_extent_start: OK
[   18.466878] Testing event btrfs_ordered_extent_remove: OK
[   18.473547] Testing event btrfs_ordered_extent_add: OK
[   18.480244] Testing event btrfs_get_extent: OK
[   18.486878] Testing event btrfs_inode_evict: OK
[   18.493541] Testing event btrfs_inode_request: OK
[   18.500223] Testing event btrfs_inode_new: OK
[   18.506870] Testing event btrfs_transaction_commit: OK
[   18.513549] Testing event block_rq_remap: OK
[   18.520227] Testing event block_bio_remap: OK
[   18.526862] Testing event block_split: OK
[   18.533534] Testing event block_unplug: OK
[   18.540243] Testing event block_plug: OK
[   18.546878] Testing event block_sleeprq: OK
[   18.553531] Testing event block_getrq: OK
[   18.560223] Testing event block_bio_queue: OK
[   18.566856] Testing event block_bio_frontmerge: OK
[   18.573523] Testing event block_bio_backmerge: OK
[   18.580236] Testing event block_bio_complete: OK
[   18.586852] Testing event block_bio_bounce: OK
[   18.593513] Testing event block_rq_issue: OK
[   18.600215] Testing event block_rq_insert: OK
[   18.606852] Testing event block_rq_complete: OK
[   18.613529] Testing event block_rq_requeue: OK
[   18.620216] Testing event block_rq_abort: OK
[   18.626840] Testing event block_dirty_buffer: OK
[   18.633508] Testing event block_touch_buffer: OK
[   18.640213] Testing event swiotlb_bounced: OK
[   18.646858] Testing event gpio_value: OK
[   18.653501] Testing event gpio_direction: OK
[   18.660200] Testing event regulator_set_voltage_complete: OK
[   18.666831] Testing event regulator_set_voltage: OK
[   18.673500] Testing event regulator_disable_complete: OK
[   18.680212] Testing event regulator_disable: OK
[   18.686826] Testing event regulator_enable_complete: OK
[   18.693495] Testing event regulator_enable_delay: OK
[   18.700238] Testing event regulator_enable: OK
[   18.706825] Testing event urandom_read: OK
[   18.713504] Testing event random_read: OK
[   18.720219] Testing event extract_entropy_user: OK
[   18.726816] Testing event extract_entropy: OK
[   18.733486] Testing event get_random_bytes_arch: OK
[   18.740191] Testing event get_random_bytes: OK
[   18.746832] Testing event xfer_secondary_pool: OK
[   18.753478] Testing event add_disk_randomness: OK
[   18.760179] Testing event add_input_randomness: OK
[   18.766822] Testing event debit_entropy: OK
[   18.773489] Testing event push_to_pool: OK
[   18.780190] Testing event credit_entropy_bits: OK
[   18.786818] Testing event mix_pool_bytes_nolock: OK
[   18.793475] Testing event mix_pool_bytes: OK
[   18.800176] Testing event add_device_randomness: OK
[   18.806807] Testing event drm_vblank_event_delivered: OK
[   18.813500] Testing event drm_vblank_event_queued: OK
[   18.820163] Testing event drm_vblank_event: OK
[   18.826834] Testing event regcache_drop_region: OK
[   18.833465] Testing event regmap_async_complete_done: OK
[   18.840172] Testing event regmap_async_complete_start: OK
[   18.846815] Testing event regmap_async_io_complete: OK
[   18.853470] Testing event regmap_async_write_start: OK
[   18.860165] Testing event regmap_cache_bypass: OK
[   18.866798] Testing event regmap_cache_only: OK
[   18.873458] Testing event regcache_sync: OK
[   18.880201] Testing event regmap_hw_write_done: OK
[   18.886812] Testing event regmap_hw_write_start: OK
[   18.893468] Testing event regmap_hw_read_done: OK
[   18.900213] Testing event regmap_hw_read_start: OK
[   18.906779] Testing event regmap_reg_read_cache: OK
[   18.913467] Testing event regmap_reg_read: OK
[   18.920153] Testing event regmap_reg_write: OK
[   18.926801] Testing event fence_wait_end: OK
[   18.933453] Testing event fence_wait_start: OK
[   18.940172] Testing event fence_signaled: OK
[   18.946847] Testing event fence_enable_signal: OK
[   18.953440] Testing event fence_destroy: OK
[   18.960139] Testing event fence_init: OK
[   18.966784] Testing event fence_emit: OK
[   18.973437] Testing event fence_annotate_wait_on: OK
[   18.980150] Testing event scsi_eh_wakeup: OK
[   18.986761] Testing event scsi_dispatch_cmd_timeout: OK
[   18.993445] Testing event scsi_dispatch_cmd_done: OK
[   19.000151] Testing event scsi_dispatch_cmd_error: OK
[   19.006779] Testing event scsi_dispatch_cmd_start: OK
[   19.013452] Testing event target_cmd_complete: OK
[   19.020124] Testing event target_sequencer_start: OK
[   19.026763] Testing event docg3_io: OK
[   19.033438] Testing event spi_transfer_stop: OK
[   19.040148] Testing event spi_transfer_start: OK
[   19.046803] Testing event spi_message_done: OK
[   19.053418] Testing event spi_message_start: OK
[   19.060112] Testing event spi_message_submit: OK
[   19.066764] Testing event spi_master_busy: OK
[   19.073408] Testing event spi_master_idle: OK
[   19.080147] Testing event dwc3_complete_trb: OK
[   19.086741] Testing event dwc3_prepare_trb: OK
[   19.093426] Testing event dwc3_gadget_ep_cmd: OK
[   19.100102] Testing event dwc3_gadget_generic_cmd: OK
[   19.106737] Testing event dwc3_gadget_giveback: OK
[   19.113419] Testing event dwc3_ep_dequeue: OK
[   19.120111] Testing event dwc3_ep_queue: OK
[   19.126728] Testing event dwc3_free_request: OK
[   19.133398] Testing event dwc3_alloc_request: OK
[   19.140114] Testing event dwc3_ctrl_req: OK
[   19.146746] Testing event dwc3_event: OK
[   19.153392] Testing event dwc3_ep0: OK
[   19.160088] Testing event dwc3_writel: OK
[   19.166719] Testing event dwc3_readl: OK
[   19.173385] Testing event xhci_cmd_completion: OK
[   19.180111] Testing event xhci_address_ctx: OK
[   19.186717] Testing event xhci_dbg_ring_expansion: OK
[   19.193389] Testing event xhci_dbg_init: OK
[   19.200079] Testing event xhci_dbg_cancel_urb: OK
[   19.206713] Testing event xhci_dbg_reset_ep: OK
[   19.213417] Testing event xhci_dbg_quirks: OK
[   19.220080] Testing event xhci_dbg_context_change: OK
[   19.226722] Testing event xhci_dbg_address: OK
[   19.233374] Testing event smbus_result: OK
[   19.240094] Testing event smbus_reply: OK
[   19.246728] Testing event smbus_read: OK
[   19.253378] Testing event smbus_write: OK
[   19.260074] Testing event i2c_result: OK
[   19.266696] Testing event i2c_reply: OK
[   19.273365] Testing event i2c_read: OK
[   19.280076] Testing event i2c_write: OK
[   19.286693] Testing event v4l2_qbuf: OK
[   19.293364] Testing event v4l2_dqbuf: OK
[   19.300068] Testing event thermal_zone_trip: OK
[   19.306688] Testing event cdev_update: OK
[   19.313378] Testing event thermal_temperature: OK
[   19.320054] Testing event bcache_writeback_collision: OK
[   19.326687] Testing event bcache_writeback: OK
[   19.333350] Testing event bcache_alloc_fail: OK
[   19.340052] Testing event bcache_alloc: OK
[   19.346696] Testing event bcache_invalidate: OK
[   19.353343] Testing event bcache_keyscan: OK
[   19.360066] Testing event bcache_btree_set_root: OK
[   19.366717] Testing event bcache_btree_node_compact: OK
[   19.373362] Testing event bcache_btree_node_split: OK
[   19.380084] Testing event bcache_btree_insert_key: OK
[   19.386693] Testing event bcache_gc_copy_collision: OK
[   19.393358] Testing event bcache_gc_copy: OK
[   19.400040] Testing event bcache_gc_end: OK
[   19.406688] Testing event bcache_gc_start: OK
[   19.413375] Testing event bcache_btree_gc_coalesce: OK
[   19.420056] Testing event bcache_btree_node_free: OK
[   19.426682] Testing event bcache_btree_node_alloc_fail: OK
[   19.433347] Testing event bcache_btree_node_alloc: OK
[   19.440054] Testing event bcache_btree_write: OK
[   19.446692] Testing event bcache_btree_read: OK
[   19.453346] Testing event bcache_btree_cache_cannibalize: OK
[   19.460021] Testing event bcache_journal_write: OK
[   19.466682] Testing event bcache_journal_entry_full: OK
[   19.473318] Testing event bcache_journal_full: OK
[   19.480059] Testing event bcache_journal_replay_key: OK
[   19.486680] Testing event bcache_cache_insert: OK
[   19.493339] Testing event bcache_read_retry: OK
[   19.500030] Testing event bcache_write: OK
[   19.506673] Testing event bcache_read: OK
[   19.513326] Testing event bcache_bypass_congested: OK
[   19.520027] Testing event bcache_bypass_sequential: OK
[   19.526680] Testing event bcache_request_end: OK
[   19.533325] Testing event bcache_request_start: OK
[   19.540041] Testing event udp_fail_queue_rcv_skb: OK
[   19.546653] Testing event sock_exceed_buf_limit: OK
[   19.553301] Testing event sock_rcvqueue_full: OK
[   19.560020] Testing event napi_poll: OK
[   19.566631] Testing event netif_rx_ni_entry: OK
[   19.573293] Testing event netif_rx_entry: OK
[   19.580018] Testing event netif_receive_skb_entry: OK
[   19.586624] Testing event napi_gro_receive_entry: OK
[   19.593305] Testing event napi_gro_frags_entry: OK
[   19.599975] Testing event netif_rx: OK
[   19.606622] Testing event netif_receive_skb: OK
[   19.613304] Testing event net_dev_queue: OK
[   19.619969] Testing event net_dev_xmit: OK
[   19.626613] Testing event net_dev_start_xmit: OK
[   19.633282] Testing event skb_copy_datagram_iovec: OK
[   19.639967] Testing event consume_skb: OK
[   19.646626] Testing event kfree_skb: OK
[   19.653285] Running tests on trace event systems:
[   19.654172] Testing event system skb: OK
[   19.660088] Testing event system net: OK
[   19.666735] Testing event system napi: OK
[   19.673380] Testing event system sock: OK
[   19.680114] Testing event system udp: OK
[   19.686703] Testing event system bcache: OK
[   19.693463] Testing event system thermal: OK
[   19.700082] Testing event system v4l2: OK
[   19.706705] Testing event system i2c: OK
[   19.713405] Testing event system xhci-hcd: OK
[   19.720083] Testing event system dwc3: OK
[   19.726776] Testing event system spi: OK
[   19.733419] Testing event system docg3: OK
[   19.740091] Testing event system target: OK
[   19.746719] Testing event system scsi: OK
[   19.753396] Testing event system fence: OK
[   19.760081] Testing event system regmap: OK
[   19.766754] Testing event system drm: OK
[   19.773383] Testing event system random: OK
[   19.780140] Testing event system regulator: OK
[   19.786725] Testing event system gpio: OK
[   19.793378] Testing event system swiotlb: OK
[   19.800085] Testing event system block: OK
[   19.806757] Testing event system btrfs: OK
[   19.813498] Testing event system jbd2: OK
[   19.820114] Testing event system jbd: OK
[   19.826729] Testing event system ext4: OK
[   19.833681] Testing event system ext3: OK
[   19.840185] Testing event system filelock: OK
[   19.846730] Testing event system writeback: OK
[   19.853430] Testing event system migrate: OK
[   19.860135] Testing event system compaction: OK
[   19.866712] Testing event system kmem: OK
[   19.873373] Testing event system vmscan: OK
[   19.880115] Testing event system pagemap: OK
[   19.886669] Testing event system oom: OK
[   19.893355] Testing event system filemap: OK
[   19.900061] Testing event system rpm: OK
[   19.906690] Testing event system power: OK
[   19.913478] Testing event system test: OK
[   19.920046] Testing event system timer: OK
[   19.926717] Testing event system rcu: OK
[   19.933343] Testing event system printk: OK
[   19.940051] Testing event system lock: OK
[   19.946754] Testing event system sched: OK
[   19.953389] Testing event system workqueue: OK
[   19.960093] Testing event system signal: OK
[   19.966653] Testing event system irq: OK
[   19.973323] Testing event system task: OK
[   19.980028] Testing event system exceptions: OK
[   19.986646] Testing event system tlb: OK
[   19.993315] Testing event system mce: OK
[   20.000007] Testing event system raw_syscalls: OK
[   20.006638] Testing event system nmi: OK
[   20.013334] Testing event system irq_vectors: OK
[   20.020080] Testing event system xen: OK
[   20.026721] Running tests on all trace events:
[   20.027542] Testing all events: OK
[   20.152948] Testing ftrace filter: OK
[   20.164478] Btrfs loaded, debug=3Don, assert=3Don, integrity-checker=3Don
[   20.178561] BTRFS: selftest: Running btrfs free space cache tests
[   20.180041] BTRFS: selftest: Running extent only tests
[   20.181288] BTRFS: selftest: Running bitmap only tests
[   20.182525] BTRFS: selftest: Running bitmap and extent tests
[   20.184666] BTRFS: selftest: Running space stealing from bitmap to extent
[   20.187258] BTRFS: selftest: Free space cache tests finished
[   20.188649] BTRFS: selftest: Running extent buffer operation tests
[   20.190109] BTRFS: selftest: Running btrfs_split_item tests
[   20.191555] BTRFS: selftest: Running find delalloc tests
[   25.085282] rb_consumer: page allocation failure: order:0, mode:0x10d0
[   25.086852] CPU: 0 PID: 33 Comm: rb_consumer Not tainted 3.19.0-rc4-g2e6=
7200 #4
[   25.091990]  00000001 00000001 cb30de38 cc4a629f cb30de60 cbce350b cc715=
718 cb30725c
[   25.094061]  00000000 000010d0 00000000 00000000 00000040 00000000 cb30d=
efc cbce5b3d
[   25.098898]  000010d0 00000000 00000000 00000003 01c70e35 00000040 00000=
000 00000010
[   25.101192] Call Trace:
[   25.105037]  [<cc4a629f>] dump_stack+0x16/0x18
[   25.106110]  [<cbce350b>] warn_alloc_failed+0xab/0xf0
[   25.107304]  [<cbce5b3d>] __alloc_pages_nodemask+0x66d/0x920
[   25.111476]  [<cbcb8f36>] ring_buffer_alloc_read_page+0x16/0x40
[   25.112885]  [<cbcb9aa5>] ring_buffer_consumer_thread+0x135/0x490
[   25.114460]  [<cbcb9970>] ? ring_buffer_producer_thread+0x5c0/0x5c0
[   25.119172]  [<cbc69535>] kthread+0xb5/0xd0
[   25.120169]  [<cc4ad300>] ret_from_kernel_thread+0x20/0x30
[   25.121557]  [<cbc69480>] ? __kthread_parkme+0x90/0x90
[   25.125501] Mem-Info:
[   25.126062] Normal per-cpu:
[   25.126730] CPU    0: hi:   90, btch:  15 usd:   0
[   25.131262] active_anon:0 inactive_anon:0 isolated_anon:0
[   25.131262]  active_file:2010 inactive_file:44581 isolated_file:0
[   25.131262]  unevictable:17874 dirty:0 writeback:0 unstable:0
[   25.131262]  free:527 slab_reclaimable:0 slab_unreclaimable:0
[   25.131262]  mapped:0 shmem:0 pagetables:0 bounce:0
[   25.131262]  free_cma:0
[   25.144654] Normal free:2108kB min:2108kB low:2632kB high:3160kB active_=
anon:0kB inactive_anon:0kB active_file:8040kB inactive_file:178324kB unevic=
table:71496kB isolated(anon):0kB isolated(file):0kB present:327160kB manage=
d:277952kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_re=
claimable:0kB slab_unreclaimable:0kB kernel_stack:384kB pagetables:0kB unst=
able:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:12666888 a=
ll_unreclaimable? yes
[   25.160566] lowmem_reserve[]: 0 0
[   25.164483] Normal: 1*4kB (R) 1*8kB (R) 1*16kB (R) 1*32kB (R) 0*64kB 0*1=
28kB 0*256kB 0*512kB 0*1024kB 1*2048kB (R) 0*4096kB =3D 2108kB
[   25.171653] Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepages_surp=
=3D0 hugepages_size=3D2048kB
[   25.176347] 64465 total pagecache pages
[   25.177979] 81790 pages RAM
[   25.184533] 0 pages HighMem/MovableOnly
[   25.185457] 12302 pages reserved
[   25.186235] 0 pages hwpoisoned
[   25.668415] rb_consumer: page allocation failure: order:0, mode:0x10d0
[   25.669970] CPU: 0 PID: 33 Comm: rb_consumer Not tainted 3.19.0-rc4-g2e6=
7200 #4
[   25.671749]  00000001 00000001 cb30de38 cc4a629f cb30de60 cbce350b cc715=
718 cb30725c
[   25.673807]  00000000 000010d0 00000000 00000000 00000040 00000000 cb30d=
efc cbce5b3d
[   25.676007]  000010d0 00000000 00000000 00000003 01307000 00000040 00000=
000 00000010
[   25.678123] Call Trace:
[   25.678722]  [<cc4a629f>] dump_stack+0x16/0x18
[   25.679778]  [<cbce350b>] warn_alloc_failed+0xab/0xf0
[   25.680975]  [<cbce5b3d>] __alloc_pages_nodemask+0x66d/0x920
[   25.682377]  [<cbcb8f36>] ring_buffer_alloc_read_page+0x16/0x40
[   25.683757]  [<cbcb9aa5>] ring_buffer_consumer_thread+0x135/0x490
[   25.685335]  [<cbcb9970>] ? ring_buffer_producer_thread+0x5c0/0x5c0
[   25.686799]  [<cbc69535>] kthread+0xb5/0xd0
[   25.687849]  [<cc4ad300>] ret_from_kernel_thread+0x20/0x30
[   25.689161]  [<cbc69480>] ? __kthread_parkme+0x90/0x90
[   25.690367] Mem-Info:
[   25.690910] Normal per-cpu:
[   25.691650] CPU    0: hi:   90, btch:  15 usd:   0
[   25.692785] active_anon:0 inactive_anon:0 isolated_anon:0
[   25.692785]  active_file:2010 inactive_file:44581 isolated_file:0
[   25.692785]  unevictable:17874 dirty:0 writeback:0 unstable:0
[   25.692785]  free:527 slab_reclaimable:0 slab_unreclaimable:0
[   25.692785]  mapped:0 shmem:0 pagetables:0 bounce:0
[   25.692785]  free_cma:0
[   25.699944] Normal free:2108kB min:2108kB low:2632kB high:3160kB active_=
anon:0kB inactive_anon:0kB active_file:8040kB inactive_file:178324kB unevic=
table:71496kB isolated(anon):0kB isolated(file):0kB present:327160kB manage=
d:277952kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_re=
claimable:0kB slab_unreclaimable:0kB kernel_stack:384kB pagetables:0kB unst=
able:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:14176848 a=
ll_unreclaimable? yes
[   25.709694] lowmem_reserve[]: 0 0
[   25.710581] Normal: 1*4kB (R) 1*8kB (R) 1*16kB (R) 1*32kB (R) 0*64kB 0*1=
28kB 0*256kB 0*512kB 0*1024kB 1*2048kB (R) 0*4096kB =3D 2108kB
[   25.713953] Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepages_surp=
=3D0 hugepages_size=3D2048kB
[   25.715990] 64465 total pagecache pages
[   25.716901] 81790 pages RAM
[   25.717579] 0 pages HighMem/MovableOnly
[   25.718632] 12302 pages reserved
[   25.719405] 0 pages hwpoisoned
[   26.474888] rb_consumer: page allocation failure: order:0, mode:0x10d0
[   26.479287] CPU: 0 PID: 33 Comm: rb_consumer Not tainted 3.19.0-rc4-g2e6=
7200 #4
[   26.484481]  00000001 00000001 cb30de38 cc4a629f cb30de60 cbce350b cc715=
718 cb30725c
[   26.486562]  00000000 000010d0 00000000 00000000 00000040 00000000 cb30d=
efc cbce5b3d
[   26.491973]  000010d0 00000000 00000000 00000003 01307000 00000040 00000=
000 00000010
[   26.494070] Call Trace:
[   26.497944]  [<cc4a629f>] dump_stack+0x16/0x18
[   26.499036]  [<cbce350b>] warn_alloc_failed+0xab/0xf0
[   26.500237]  [<cbce5b3d>] __alloc_pages_nodemask+0x66d/0x920
[   26.504562]  [<cbcb8f36>] ring_buffer_alloc_read_page+0x16/0x40
[   26.505982]  [<cbcb9aa5>] ring_buffer_consumer_thread+0x135/0x490
[   26.508094]  [<cbcb9970>] ? ring_buffer_producer_thread+0x5c0/0x5c0
[   26.512246]  [<cbc69535>] kthread+0xb5/0xd0
[   26.513253]  [<cc4ad300>] ret_from_kernel_thread+0x20/0x30
[   26.517936]  [<cbc69480>] ? __kthread_parkme+0x90/0x90
[   26.520141] Mem-Info:
[   26.520691] Normal per-cpu:
[   26.521434] CPU    0: hi:   90, btch:  15 usd:   0
[   26.524469] active_anon:0 inactive_anon:0 isolated_anon:0
[   26.524469]  active_file:2010 inactive_file:44571 isolated_file:10
[   26.524469]  unevictable:17874 dirty:0 writeback:0 unstable:0
[   26.524469]  free:527 slab_reclaimable:0 slab_unreclaimable:0
[   26.524469]  mapped:0 shmem:0 pagetables:0 bounce:0
[   26.524469]  free_cma:0
[   26.537323] Normal free:2108kB min:2108kB low:2632kB high:3160kB active_=
anon:0kB inactive_anon:0kB active_file:8040kB inactive_file:178284kB unevic=
table:71496kB isolated(anon):0kB isolated(file):40kB present:327160kB manag=
ed:277952kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_r=
eclaimable:0kB slab_unreclaimable:0kB kernel_stack:384kB pagetables:0kB uns=
table:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:17046488 =
all_unreclaimable? yes
[   26.561377] lowmem_reserve[]: 0 0
[   26.562192] Normal: 1*4kB (R) 1*8kB (R) 1*16kB (R) 1*32kB (R) 0*64kB 0*1=
28kB 0*256kB 0*512kB 0*1024kB 1*2048kB (R) 0*4096kB =3D 2108kB
[   26.577777] Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepages_surp=
=3D0 hugepages_size=3D2048kB
[   26.579770] 64465 total pagecache pages
[   26.581187] 81790 pages RAM
[   26.584654] 0 pages HighMem/MovableOnly
[   26.585584] 12302 pages reserved
[   26.586367] 0 pages hwpoisoned
[   27.254433] rb_consumer: page allocation failure: order:0, mode:0x10d0
[   27.258185] CPU: 0 PID: 33 Comm: rb_consumer Not tainted 3.19.0-rc4-g2e6=
7200 #4
[   27.259903]  00000001 00000001 cb30de38 cc4a629f cb30de60 cbce350b cc715=
718 cb30725c
[   27.265233]  00000000 000010d0 00000000 00000000 00000040 00000000 cb30d=
efc cbce5b3d
[   27.267851]  000010d0 00000000 00000000 00000003 01307000 00000040 00000=
000 00000010
[   27.272681] Call Trace:
[   27.274674]  [<cc4a629f>] dump_stack+0x16/0x18
[   27.277800]  [<cbce350b>] warn_alloc_failed+0xab/0xf0
[   27.282118]  [<cbce5b3d>] __alloc_pages_nodemask+0x66d/0x920
[   27.284703]  [<cbcb8f36>] ring_buffer_alloc_read_page+0x16/0x40
[   27.291272]  [<cbcb9aa5>] ring_buffer_consumer_thread+0x135/0x490
[   27.292715]  [<cbcb9970>] ? ring_buffer_producer_thread+0x5c0/0x5c0
[   27.295468]  [<cbc69535>] kthread+0xb5/0xd0
[   27.301332]  [<cc4ad300>] ret_from_kernel_thread+0x20/0x30
[   27.302627]  [<cbc69480>] ? __kthread_parkme+0x90/0x90
[   27.305310] Mem-Info:
[   27.305857] Normal per-cpu:
[   27.311513] CPU    0: hi:   90, btch:  15 usd:   0
[   27.312650] active_anon:0 inactive_anon:0 isolated_anon:0
[   27.312650]  active_file:2010 inactive_file:44581 isolated_file:0
[   27.312650]  unevictable:17874 dirty:0 writeback:0 unstable:0
[   27.312650]  free:527 slab_reclaimable:0 slab_unreclaimable:0
[   27.312650]  mapped:0 shmem:0 pagetables:0 bounce:0
[   27.312650]  free_cma:0
[   27.331141] Normal free:2108kB min:2108kB low:2632kB high:3160kB active_=
anon:0kB inactive_anon:0kB active_file:8040kB inactive_file:178324kB unevic=
table:71496kB isolated(anon):0kB isolated(file):0kB present:327160kB manage=
d:277952kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_re=
claimable:0kB slab_unreclaimable:0kB kernel_stack:384kB pagetables:0kB unst=
able:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:19146088 a=
ll_unreclaimable? yes
[   27.359094] lowmem_reserve[]: 0 0
[   27.359971] Normal: 1*4kB (R) 1*8kB (R) 1*16kB (R) 1*32kB (R) 0*64kB 0*1=
28kB 0*256kB 0*512kB 0*1024kB 1*2048kB (R) 0*4096kB =3D 2108kB
[   27.369611] Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepages_surp=
=3D0 hugepages_size=3D2048kB
[   27.377844] 64465 total pagecache pages
[   27.378770] 81790 pages RAM
[   27.379458] 0 pages HighMem/MovableOnly
[   27.380399] 12302 pages reserved
[   27.384570] 0 pages hwpoisoned
[   28.110068] rb_consumer: page allocation failure: order:0, mode:0x10d0
[   28.113562] CPU: 0 PID: 33 Comm: rb_consumer Not tainted 3.19.0-rc4-g2e6=
7200 #4
[   28.117858]  00000001 00000001 cb30de38 cc4a629f cb30de60 cbce350b cc715=
718 cb30725c
[   28.121108]  00000000 000010d0 00000000 00000000 00000040 00000000 cb30d=
efc cbce5b3d
[   28.125162]  000010d0 00000000 00000000 00000003 01307000 00000040 00000=
000 00000010
[   28.127867] Call Trace:
[   28.131581]  [<cc4a629f>] dump_stack+0x16/0x18
[   28.132648]  [<cbce350b>] warn_alloc_failed+0xab/0xf0
[   28.133869]  [<cbce5b3d>] __alloc_pages_nodemask+0x66d/0x920
[   28.136825]  [<cbcb8f36>] ring_buffer_alloc_read_page+0x16/0x40
[   28.141680]  [<cbcb9aa5>] ring_buffer_consumer_thread+0x135/0x490
[   28.143151]  [<cbcb9970>] ? ring_buffer_producer_thread+0x5c0/0x5c0
[   28.144711]  [<cbc69535>] kthread+0xb5/0xd0
[   28.148415]  [<cc4ad300>] ret_from_kernel_thread+0x20/0x30
[   28.149714]  [<cbc69480>] ? __kthread_parkme+0x90/0x90
[   28.151269] Mem-Info:
[   28.154873] Normal per-cpu:
[   28.155566] CPU    0: hi:   90, btch:  15 usd:   0
[   28.156738] active_anon:0 inactive_anon:0 isolated_anon:0
[   28.156738]  active_file:2010 inactive_file:44581 isolated_file:0
[   28.156738]  unevictable:17874 dirty:0 writeback:0 unstable:0
[   28.156738]  free:527 slab_reclaimable:0 slab_unreclaimable:0
[   28.156738]  mapped:0 shmem:0 pagetables:0 bounce:0
[   28.156738]  free_cma:0
[   28.164182] Normal free:2108kB min:2108kB low:2632kB high:3160kB active_=
anon:0kB inactive_anon:0kB active_file:8040kB inactive_file:178324kB unevic=
table:71496kB isolated(anon):0kB isolated(file):0kB present:327160kB manage=
d:277952kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_re=
claimable:0kB slab_unreclaimable:0kB kernel_stack:384kB pagetables:0kB unst=
able:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:21638008 a=
ll_unreclaimable? yes
[   28.179520] lowmem_reserve[]: 0 0
[   28.181359] Normal: 1*4kB (R) 1*8kB (R) 1*16kB (R) 1*32kB (R) 0*64kB 0*1=
28kB 0*256kB 0*512kB 0*1024kB 1*2048kB (R) 0*4096kB =3D 2108kB
[   28.187835] Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepages_surp=
=3D0 hugepages_size=3D2048kB
[   28.193595] 64465 total pagecache pages
[   28.194697] 81790 pages RAM
[   28.198077] 0 pages HighMem/MovableOnly
[   28.198981] 12302 pages reserved
[   28.199781] 0 pages hwpoisoned
[   28.444510] rb_consumer: page allocation failure: order:0, mode:0x10d0
[   28.447802] CPU: 0 PID: 33 Comm: rb_consumer Not tainted 3.19.0-rc4-g2e6=
7200 #4
[   28.449543]  00000001 00000001 cb30de38 cc4a629f cb30de60 cbce350b cc715=
718 cb30725c
[   28.454742]  00000000 000010d0 00000000 00000000 00000040 00000000 cb30d=
efc cbce5b3d
[   28.458282]  000010d0 00000000 00000000 00000003 01307000 00000040 00000=
000 00000010
[   28.462259] Call Trace:
[   28.462852]  [<cc4a629f>] dump_stack+0x16/0x18
[   28.465115]  [<cbce350b>] warn_alloc_failed+0xab/0xf0
[   28.469610]  [<cbce5b3d>] __alloc_pages_nodemask+0x66d/0x920
[   28.471305]  [<cbcb8f36>] ring_buffer_alloc_read_page+0x16/0x40
[   28.475403]  [<cbcb9aa5>] ring_buffer_consumer_thread+0x135/0x490
[   28.476838]  [<cbcb9970>] ? ring_buffer_producer_thread+0x5c0/0x5c0
[   28.481717]  [<cbc69535>] kthread+0xb5/0xd0
[   28.482724]  [<cc4ad300>] ret_from_kernel_thread+0x20/0x30
[   28.484063]  [<cbc69480>] ? __kthread_parkme+0x90/0x90
[   28.489382] Mem-Info:
[   28.489959] Normal per-cpu:
[   28.490645] CPU    0: hi:   90, btch:  15 usd:   0
[   28.491853] active_anon:0 inactive_anon:0 isolated_anon:0
[   28.491853]  active_file:2010 inactive_file:44581 isolated_file:0
[   28.491853]  unevictable:17874 dirty:0 writeback:0 unstable:0
[   28.491853]  free:527 slab_reclaimable:0 slab_unreclaimable:0
[   28.491853]  mapped:0 shmem:0 pagetables:0 bounce:0
[   28.491853]  free_cma:0
[   28.505087] Normal free:2108kB min:2108kB low:2632kB high:3160kB active_=
anon:0kB inactive_anon:0kB active_file:8040kB inactive_file:178324kB unevic=
table:71496kB isolated(anon):0kB isolated(file):0kB present:327160kB manage=
d:277952kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_re=
claimable:0kB slab_unreclaimable:0kB kernel_stack:384kB pagetables:0kB unst=
able:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:22409848 a=
ll_unreclaimable? yes
[   28.524082] lowmem_reserve[]: 0 0
[   28.527778] Normal: 1*4kB (R) 1*8kB (R) 1*16kB (R) 1*32kB (R) 0*64kB 0*1=
28kB 0*256kB 0*512kB 0*1024kB 1*2048kB (R) 0*4096kB =3D 2108kB
[   28.534180] Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepages_surp=
=3D0 hugepages_size=3D2048kB
[   28.536262] 64465 total pagecache pages
[   28.537183] 81790 pages RAM
[   28.541314] 0 pages HighMem/MovableOnly
[   28.543236] 12302 pages reserved
[   28.544020] 0 pages hwpoisoned
[   29.214273] rb_consumer: page allocation failure: order:0, mode:0x10d0
[   29.221488] CPU: 0 PID: 33 Comm: rb_consumer Not tainted 3.19.0-rc4-g2e6=
7200 #4
[   29.223270]  00000001 00000001 cb30de38 cc4a629f cb30de60 cbce350b cc715=
718 cb30725c
[   29.231939]  00000000 000010d0 00000000 00000000 00000040 00000000 cb30d=
efc cbce5b3d
[   29.235931]  000010d0 00000000 00000000 00000003 01307000 00000040 00000=
000 00000010
[   29.241133] Call Trace:
[   29.241734]  [<cc4a629f>] dump_stack+0x16/0x18
[   29.242856]  [<cbce350b>] warn_alloc_failed+0xab/0xf0
[   29.245486]  [<cbce5b3d>] __alloc_pages_nodemask+0x66d/0x920
[   29.248704]  [<cbcb8f36>] ring_buffer_alloc_read_page+0x16/0x40
[   29.251384]  [<cbcb9aa5>] ring_buffer_consumer_thread+0x135/0x490
[   29.254473]  [<cbcb9970>] ? ring_buffer_producer_thread+0x5c0/0x5c0
[   29.256962]  [<cbc69535>] kthread+0xb5/0xd0
[   29.266223]  [<cc4ad300>] ret_from_kernel_thread+0x20/0x30
[   29.267569]  [<cbc69480>] ? __kthread_parkme+0x90/0x90
[   29.271390] Mem-Info:
[   29.271942] Normal per-cpu:
[   29.272625] CPU    0: hi:   90, btch:  15 usd:   0
[   29.273762] active_anon:0 inactive_anon:0 isolated_anon:0
[   29.273762]  active_file:2010 inactive_file:44581 isolated_file:0
[   29.273762]  unevictable:17874 dirty:0 writeback:0 unstable:0
[   29.273762]  free:527 slab_reclaimable:0 slab_unreclaimable:0
[   29.273762]  mapped:0 shmem:0 pagetables:0 bounce:0
[   29.273762]  free_cma:0
[   29.289500] Normal free:2108kB min:2108kB low:2632kB high:3160kB active_=
anon:0kB inactive_anon:0kB active_file:8040kB inactive_file:178324kB unevic=
table:71496kB isolated(anon):0kB isolated(file):0kB present:327160kB manage=
d:277952kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_re=
claimable:0kB slab_unreclaimable:0kB kernel_stack:384kB pagetables:0kB unst=
able:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:24607088 a=
ll_unreclaimable? yes
[   29.306956] lowmem_reserve[]: 0 0
[   29.311251] Normal: 1*4kB (R) 1*8kB (R) 1*16kB (R) 1*32kB (R) 0*64kB 0*1=
28kB 0*256kB 0*512kB 0*1024kB 1*2048kB (R) 0*4096kB =3D 2108kB
[   29.317894] Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepages_surp=
=3D0 hugepages_size=3D2048kB
[   29.319884] 64465 total pagecache pages
[   29.321424] 81790 pages RAM
[   29.324778] 0 pages HighMem/MovableOnly
[   29.325699] 12302 pages reserved
[   29.326478] 0 pages hwpoisoned
[   73.654232] rb_consumer: page allocation failure: order:0, mode:0x10d0
[   73.660455] CPU: 0 PID: 33 Comm: rb_consumer Not tainted 3.19.0-rc4-g2e6=
7200 #4
[   73.663714]  00000001 00000001 cb30de38 cc4a629f cb30de60 cbce350b cc715=
718 cb30725c
[   73.670645]  00000000 000010d0 00000000 00000000 00000040 00000000 cb30d=
efc cbce5b3d
[   73.672745]  000010d0 00000000 00000000 00000003 01c70e35 00000040 00000=
000 00000010
[   73.677636] Call Trace:
[   73.678243]  [<cc4a629f>] dump_stack+0x16/0x18
[   73.680264]  [<cbce350b>] warn_alloc_failed+0xab/0xf0
[   73.683666]  [<cbce5b3d>] __alloc_pages_nodemask+0x66d/0x920
[   73.685040]  [<cbcb8f36>] ring_buffer_alloc_read_page+0x16/0x40
[   73.687068]  [<cbcb9aa5>] ring_buffer_consumer_thread+0x135/0x490
[   73.690895]  [<cbcb9970>] ? ring_buffer_producer_thread+0x5c0/0x5c0
[   73.692376]  [<cbc69535>] kthread+0xb5/0xd0
[   73.694046]  [<cc4ad300>] ret_from_kernel_thread+0x20/0x30
[   73.697713]  [<cbc69480>] ? __kthread_parkme+0x90/0x90
[   73.698920] Mem-Info:
[   73.700159] Normal per-cpu:
[   73.701030] CPU    0: hi:   90, btch:  15 usd:   0
[   73.704351] active_anon:0 inactive_anon:0 isolated_anon:0
[   73.704351]  active_file:2010 inactive_file:44571 isolated_file:10
[   73.704351]  unevictable:17874 dirty:0 writeback:0 unstable:0
[   73.704351]  free:527 slab_reclaimable:0 slab_unreclaimable:0
[   73.704351]  mapped:0 shmem:0 pagetables:0 bounce:0
[   73.704351]  free_cma:0
[   73.717432] Normal free:2108kB min:2108kB low:2632kB high:3160kB active_=
anon:0kB inactive_anon:0kB active_file:8040kB inactive_file:178284kB unevic=
table:71496kB isolated(anon):0kB isolated(file):40kB present:327160kB manag=
ed:277952kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_r=
eclaimable:0kB slab_unreclaimable:0kB kernel_stack:384kB pagetables:0kB uns=
table:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:154562248=
 all_unreclaimable? yes
[   73.733789] lowmem_reserve[]: 0 0
[   73.736945] Normal: 1*4kB (R) 1*8kB (R) 1*16kB (R) 1*32kB (R) 0*64kB 0*1=
28kB 0*256kB 0*512kB 0*1024kB 1*2048kB (R) 0*4096kB =3D 2108kB
[   73.743353] Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepages_surp=
=3D0 hugepages_size=3D2048kB
[   73.745350] 64465 total pagecache pages
[   73.747621] 81790 pages RAM
[   73.748301] 0 pages HighMem/MovableOnly
[   73.750301] 12302 pages reserved
[   73.751094] 0 pages hwpoisoned
[   74.620633] rb_consumer: page allocation failure: order:0, mode:0x10d0
[   74.627311] CPU: 0 PID: 33 Comm: rb_consumer Not tainted 3.19.0-rc4-g2e6=
7200 #4
[   74.631054]  00000001 00000001 cb30de38 cc4a629f cb30de60 cbce350b cc715=
718 cb30725c
[   74.635013]  00000000 000010d0 00000000 00000000 00000040 00000000 cb30d=
efc cbce5b3d
[   74.644495]  000010d0 00000000 00000000 00000003 01307000 00000040 00000=
000 00000010
[   74.646564] Call Trace:
[   74.648064]  [<cc4a629f>] dump_stack+0x16/0x18
[   74.654106]  [<cbce350b>] warn_alloc_failed+0xab/0xf0
[   74.655331]  [<cbce5b3d>] __alloc_pages_nodemask+0x66d/0x920
[   74.657798]  [<cbcb8f36>] ring_buffer_alloc_read_page+0x16/0x40
[   74.663088]  [<cbcb9aa5>] ring_buffer_consumer_thread+0x135/0x490
[   74.667648]  [<cbcb9970>] ? ring_buffer_producer_thread+0x5c0/0x5c0
[   74.670903]  [<cbc69535>] kthread+0xb5/0xd0
[   74.672681]  [<cc4ad300>] ret_from_kernel_thread+0x20/0x30
[   74.677701]  [<cbc69480>] ? __kthread_parkme+0x90/0x90
[   74.681641] Mem-Info:
[   74.682203] Normal per-cpu:
[   74.682871] CPU    0: hi:   90, btch:  15 usd:   0
[   74.684908] active_anon:0 inactive_anon:0 isolated_anon:0
[   74.684908]  active_file:2010 inactive_file:44581 isolated_file:0
[   74.684908]  unevictable:17874 dirty:0 writeback:0 unstable:0
[   74.684908]  free:527 slab_reclaimable:0 slab_unreclaimable:0
[   74.684908]  mapped:0 shmem:0 pagetables:0 bounce:0
[   74.684908]  free_cma:0
[   74.700827] Normal free:2108kB min:2108kB low:2632kB high:3160kB active_=
anon:0kB inactive_anon:0kB active_file:8040kB inactive_file:178324kB unevic=
table:71496kB isolated(anon):0kB isolated(file):0kB present:327160kB manage=
d:277952kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_re=
claimable:0kB slab_unreclaimable:0kB kernel_stack:384kB pagetables:0kB unst=
able:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:157240608 =
all_unreclaimable? yes
[   74.717965] lowmem_reserve[]: 0 0
[   74.720519] Normal: 1*4kB (R) 1*8kB (R) 1*16kB (R) 1*32kB (R) 0*64kB 0*1=
28kB 0*256kB 0*512kB 0*1024kB 1*2048kB (R) 0*4096kB =3D 2108kB
[   74.726644] Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepages_surp=
=3D0 hugepages_size=3D2048kB
[   74.729422] 64465 total pagecache pages
[   74.731110] 81790 pages RAM
[   74.732157] 0 pages HighMem/MovableOnly
[   74.734630] 12302 pages reserved
[   74.735409] 0 pages hwpoisoned
[   75.206244] rb_consumer: page allocation failure: order:0, mode:0x10d0
[   75.207856] CPU: 0 PID: 33 Comm: rb_consumer Not tainted 3.19.0-rc4-g2e6=
7200 #4
[   75.210489]  00000001 00000001 cb30de38 cc4a629f cb30de60 cbce350b cc715=
718 cb30725c
[   75.214783]  00000000 000010d0 00000000 00000000 00000040 00000000 cb30d=
efc cbce5b3d
[   75.220057]  000010d0 00000000 00000000 00000003 01307000 00000040 00000=
000 00000010
[   75.222123] Call Trace:
[   75.222919]  [<cc4a629f>] dump_stack+0x16/0x18
[   75.225957]  [<cbce350b>] warn_alloc_failed+0xab/0xf0
[   75.227188]  [<cbce5b3d>] __alloc_pages_nodemask+0x66d/0x920
[   75.229845]  [<cbcb8f36>] ring_buffer_alloc_read_page+0x16/0x40
[   75.232873]  [<cbcb9aa5>] ring_buffer_consumer_thread+0x135/0x490
[   75.236419]  [<cbcb9970>] ? ring_buffer_producer_thread+0x5c0/0x5c0
[   75.237900]  [<cbc69535>] kthread+0xb5/0xd0
[   75.239684]  [<cc4ad300>] ret_from_kernel_thread+0x20/0x30
[   75.243373]  [<cbc69480>] ? __kthread_parkme+0x90/0x90
[   75.244587] Mem-Info:
[   75.245174] Normal per-cpu:
[   75.246279] CPU    0: hi:   90, btch:  15 usd:   0
[   75.249742] active_anon:0 inactive_anon:0 isolated_anon:0
[   75.249742]  active_file:2010 inactive_file:44581 isolated_file:0
[   75.249742]  unevictable:17874 dirty:0 writeback:0 unstable:0
[   75.249742]  free:527 slab_reclaimable:0 slab_unreclaimable:0
[   75.249742]  mapped:0 shmem:0 pagetables:0 bounce:0
[   75.249742]  free_cma:0
[   75.262798] Normal free:2108kB min:2108kB low:2632kB high:3160kB active_=
anon:0kB inactive_anon:0kB active_file:8040kB inactive_file:178324kB unevic=
table:71496kB isolated(anon):0kB isolated(file):0kB present:327160kB manage=
d:277952kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_re=
claimable:0kB slab_unreclaimable:0kB kernel_stack:384kB pagetables:0kB unst=
able:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:158606288 =
all_unreclaimable? yes
[   75.280022] lowmem_reserve[]: 0 0
[   75.280911] Normal: 1*4kB (R) 1*8kB (R) 1*16kB (R) 1*32kB (R) 0*64kB 0*1=
28kB 0*256kB 0*512kB 0*1024kB 1*2048kB (R) 0*4096kB =3D 2108kB
[   75.287515] Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepages_surp=
=3D0 hugepages_size=3D2048kB
[   75.292175] 64465 total pagecache pages
[   75.293105] 81790 pages RAM
[   75.293781] 0 pages HighMem/MovableOnly
[   75.294695] 12302 pages reserved
[   75.296429] 0 pages hwpoisoned
[   75.830042] rb_consumer: page allocation failure: order:0, mode:0x10d0
[   75.831662] CPU: 0 PID: 33 Comm: rb_consumer Not tainted 3.19.0-rc4-g2e6=
7200 #4
[   75.834873]  00000001 00000001 cb30de38 cc4a629f cb30de60 cbce350b cc715=
718 cb30725c
[   75.838801]  00000000 000010d0 00000000 00000000 00000040 00000000 cb30d=
efc cbce5b3d
[   75.842677]  000010d0 00000000 00000000 00000003 01307000 00000040 00000=
000 00000010
[   75.847613] Call Trace:
[   75.848248]  [<cc4a629f>] dump_stack+0x16/0x18
[   75.849489]  [<cbce350b>] warn_alloc_failed+0xab/0xf0
[   75.851950]  [<cbce5b3d>] __alloc_pages_nodemask+0x66d/0x920
[   75.854851]  [<cbcb8f36>] ring_buffer_alloc_read_page+0x16/0x40
[   75.857987]  [<cbcb9aa5>] ring_buffer_consumer_thread+0x135/0x490
[   75.859442]  [<cbcb9970>] ? ring_buffer_producer_thread+0x5c0/0x5c0
[   75.861930]  [<cbc69535>] kthread+0xb5/0xd0
[   75.865294]  [<cc4ad300>] ret_from_kernel_thread+0x20/0x30
[   75.866585]  [<cbc69480>] ? __kthread_parkme+0x90/0x90
[   75.868298] Mem-Info:
[   75.871643] Normal per-cpu:
[   75.872326] CPU    0: hi:   90, btch:  15 usd:   0
[   75.873461] active_anon:0 inactive_anon:0 isolated_anon:0
[   75.873461]  active_file:2010 inactive_file:44581 isolated_file:0
[   75.873461]  unevictable:17874 dirty:0 writeback:0 unstable:0
[   75.873461]  free:527 slab_reclaimable:0 slab_unreclaimable:0
[   75.873461]  mapped:0 shmem:0 pagetables:0 bounce:0
[   75.873461]  free_cma:0
[   75.887219] Normal free:2108kB min:2108kB low:2632kB high:3160kB active_=
anon:0kB inactive_anon:0kB active_file:8040kB inactive_file:178324kB unevic=
table:71496kB isolated(anon):0kB isolated(file):0kB present:327160kB manage=
d:277952kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_re=
claimable:0kB slab_unreclaimable:0kB kernel_stack:384kB pagetables:0kB unst=
able:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:160332568 =
all_unreclaimable? yes
[   75.904762] lowmem_reserve[]: 0 0
[   75.907692] Normal: 1*4kB (R) 1*8kB (R) 1*16kB (R) 1*32kB (R) 0*64kB 0*1=
28kB 0*256kB 0*512kB 0*1024kB 1*2048kB (R) 0*4096kB =3D 2108kB
[   75.913330] Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepages_surp=
=3D0 hugepages_size=3D2048kB
[   75.916738] 64465 total pagecache pages
[   75.917713] 81790 pages RAM
[   75.919623] 0 pages HighMem/MovableOnly
[   75.921177] 12302 pages reserved
[   75.922094] 0 pages hwpoisoned
[   76.133615] rb_consumer: page allocation failure: order:0, mode:0x10d0
[   76.140206] CPU: 0 PID: 33 Comm: rb_consumer Not tainted 3.19.0-rc4-g2e6=
7200 #4
[   76.142281]  00000001 00000001 cb30de38 cc4a629f cb30de60 cbce350b cc715=
718 cb30725c
[   76.146996]  00000000 000010d0 00000000 00000000 00000040 00000000 cb30d=
efc cbce5b3d
[   76.151410]  000010d0 00000000 00000000 00000003 01307000 00000040 00000=
000 00000010
[   76.153994] Call Trace:
[   76.154909]  [<cc4a629f>] dump_stack+0x16/0x18
[   76.157857]  [<cbce350b>] warn_alloc_failed+0xab/0xf0
[   76.159062]  [<cbce5b3d>] __alloc_pages_nodemask+0x66d/0x920
[   76.163280]  [<cbcb8f36>] ring_buffer_alloc_read_page+0x16/0x40
[   76.164751]  [<cbcb9aa5>] ring_buffer_consumer_thread+0x135/0x490
[   76.167281]  [<cbcb9970>] ? ring_buffer_producer_thread+0x5c0/0x5c0
[   76.169726]  [<cbc69535>] kthread+0xb5/0xd0
[   76.172184]  [<cc4ad300>] ret_from_kernel_thread+0x20/0x30
[   76.173918]  [<cbc69480>] ? __kthread_parkme+0x90/0x90
[   76.178703] Mem-Info:
[   76.179975] Normal per-cpu:
[   76.180704] CPU    0: hi:   90, btch:  15 usd:   0
[   76.181849] active_anon:0 inactive_anon:0 isolated_anon:0
[   76.181849]  active_file:2010 inactive_file:44581 isolated_file:0
[   76.181849]  unevictable:17874 dirty:0 writeback:0 unstable:0
[   76.181849]  free:527 slab_reclaimable:0 slab_unreclaimable:0
[   76.181849]  mapped:0 shmem:0 pagetables:0 bounce:0
[   76.181849]  free_cma:0
[   76.195153] Normal free:2108kB min:2108kB low:2632kB high:3160kB active_=
anon:0kB inactive_anon:0kB active_file:8040kB inactive_file:178324kB unevic=
table:71496kB isolated(anon):0kB isolated(file):0kB present:327160kB manage=
d:277952kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_re=
claimable:0kB slab_unreclaimable:0kB kernel_stack:384kB pagetables:0kB unst=
able:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:160825288 =
all_unreclaimable? yes
[   76.213661] lowmem_reserve[]: 0 0
[   76.214567] Normal: 1*4kB (R) 1*8kB (R) 1*16kB (R) 1*32kB (R) 0*64kB 0*1=
28kB 0*256kB 0*512kB 0*1024kB 1*2048kB (R) 0*4096kB =3D 2108kB
[   76.220155] Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepages_surp=
=3D0 hugepages_size=3D2048kB
[   76.223506] 64465 total pagecache pages
[   76.227791] 81790 pages RAM
[   76.228471] 0 pages HighMem/MovableOnly
[   76.229403] 12302 pages reserved
[   76.230186] 0 pages hwpoisoned
[   76.689060] rb_consumer: page allocation failure: order:0, mode:0x10d0
[   76.690680] CPU: 0 PID: 33 Comm: rb_consumer Not tainted 3.19.0-rc4-g2e6=
7200 #4
[   76.692415]  00000001 00000001 cb30de38 cc4a629f cb30de60 cbce350b cc715=
718 cb30725c
[   76.697668]  00000000 000010d0 00000000 00000000 00000040 00000000 cb30d=
efc cbce5b3d
[   76.702558]  000010d0 00000000 00000000 00000003 01307000 00000040 00000=
000 00000010
[   76.704634] Call Trace:
[   76.705242]  [<cc4a629f>] dump_stack+0x16/0x18
[   76.709555]  [<cbce350b>] warn_alloc_failed+0xab/0xf0
[   76.710757]  [<cbce5b3d>] __alloc_pages_nodemask+0x66d/0x920
[   76.712114]  [<cbcb8f36>] ring_buffer_alloc_read_page+0x16/0x40
[   76.716208]  [<cbcb9aa5>] ring_buffer_consumer_thread+0x135/0x490
[   76.717661]  [<cbcb9970>] ? ring_buffer_producer_thread+0x5c0/0x5c0
[   76.722490]  [<cbc69535>] kthread+0xb5/0xd0
[   76.723499]  [<cc4ad300>] ret_from_kernel_thread+0x20/0x30
[   76.724799]  [<cbc69480>] ? __kthread_parkme+0x90/0x90
[   76.726041] Mem-Info:
[   76.729271] Normal per-cpu:
[   76.729938] CPU    0: hi:   90, btch:  15 usd:   0
[   76.731089] active_anon:0 inactive_anon:0 isolated_anon:0
[   76.731089]  active_file:2010 inactive_file:44581 isolated_file:0
[   76.731089]  unevictable:17874 dirty:0 writeback:0 unstable:0
[   76.731089]  free:527 slab_reclaimable:0 slab_unreclaimable:0
[   76.731089]  mapped:0 shmem:0 pagetables:0 bounce:0
[   76.731089]  free_cma:0
[   76.744113] Normal free:2108kB min:2108kB low:2632kB high:3160kB active_=
anon:0kB inactive_anon:0kB active_file:8040kB inactive_file:178324kB unevic=
table:71496kB isolated(anon):0kB isolated(file):0kB present:327160kB manage=
d:277952kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_re=
claimable:0kB slab_unreclaimable:0kB kernel_stack:384kB pagetables:0kB unst=
able:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:162324808 =
all_unreclaimable? yes
[   76.763091] lowmem_reserve[]: 0 0
[   76.763978] Normal: 1*4kB (R) 1*8kB (R) 1*16kB (R) 1*32kB (R) 0*64kB 0*1=
28kB 0*256kB 0*512kB 0*1024kB 1*2048kB (R) 0*4096kB =3D 2108kB
[   76.769896] Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepages_surp=
=3D0 hugepages_size=3D2048kB
[   76.771883] 64465 total pagecache pages
[   76.776132] 81790 pages RAM
[   76.776805] 0 pages HighMem/MovableOnly
[   76.777723] 12302 pages reserved
[   76.778505] 0 pages hwpoisoned
[   77.025042] rb_consumer: page allocation failure: order:0, mode:0x10d0
[   77.026631] CPU: 0 PID: 33 Comm: rb_consumer Not tainted 3.19.0-rc4-g2e6=
7200 #4
[   77.028386]  00000001 00000001 cb30de38 cc4a629f cb30de60 cbce350b cc715=
718 cb30725c
[   77.033615]  00000000 000010d0 00000000 00000000 00000040 00000000 cb30d=
efc cbce5b3d
[   77.038507]  000010d0 00000000 00000000 00000003 01307000 00000040 00000=
000 00000010
[   77.040578] Call Trace:
[   77.041186]  [<cc4a629f>] dump_stack+0x16/0x18
[   77.046207]  [<cbce350b>] warn_alloc_failed+0xab/0xf0
[   77.047417]  [<cbce5b3d>] __alloc_pages_nodemask+0x66d/0x920
[   77.048779]  [<cbcb8f36>] ring_buffer_alloc_read_page+0x16/0x40
[   77.051718]  [<cbcb9aa5>] ring_buffer_consumer_thread+0x135/0x490
[   77.054310]  [<cbcb9970>] ? ring_buffer_producer_thread+0x5c0/0x5c0
[   77.057409]  [<cbc69535>] kthread+0xb5/0xd0
[   77.058427]  [<cc4ad300>] ret_from_kernel_thread+0x20/0x30
[   77.060744]  [<cbc69480>] ? __kthread_parkme+0x90/0x90
[   77.064735] Mem-Info:
[   77.065313] Normal per-cpu:
[   77.065979] CPU    0: hi:   90, btch:  15 usd:   0
[   77.067151] active_anon:0 inactive_anon:0 isolated_anon:0
[   77.067151]  active_file:2010 inactive_file:44581 isolated_file:0
[   77.067151]  unevictable:17874 dirty:0 writeback:0 unstable:0
[   77.067151]  free:527 slab_reclaimable:0 slab_unreclaimable:0
[   77.067151]  mapped:0 shmem:0 pagetables:0 bounce:0
[   77.067151]  free_cma:0
[   77.082133] Normal free:2108kB min:2108kB low:2632kB high:3160kB active_=
anon:0kB inactive_anon:0kB active_file:8040kB inactive_file:178324kB unevic=
table:71496kB isolated(anon):0kB isolated(file):0kB present:327160kB manage=
d:277952kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_re=
claimable:0kB slab_unreclaimable:0kB kernel_stack:384kB pagetables:0kB unst=
able:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:163092568 =
all_unreclaimable? yes
[   77.098623] lowmem_reserve[]: 0 0
[   77.099514] Normal: 1*4kB (R) 1*8kB (R) 1*16kB (R) 1*32kB (R) 0*64kB 0*1=
28kB 0*256kB 0*512kB 0*1024kB 1*2048kB (R) 0*4096kB =3D 2108kB
[   77.105938] Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepages_surp=
=3D0 hugepages_size=3D2048kB
[   77.109038] 64465 total pagecache pages
[   77.111926] 81790 pages RAM
[   77.112605] 0 pages HighMem/MovableOnly
[   77.113522] 12302 pages reserved
[   77.115215] 0 pages hwpoisoned
[   81.042553] lock_torture_st invoked oom-killer: gfp_mask=3D0x40d0, order=
=3D2, oom_score_adj=3D0
[   81.047724] lock_torture_st cpuset=3D/ mems_allowed=3D0
[   81.050197] CPU: 0 PID: 32 Comm: lock_torture_st Not tainted 3.19.0-rc4-=
g2e67200 #4
[   81.055206]  cb226000 cb226000 d1433dd4 cc4a629f d1433e1c cbce1451 cc715=
3c4 cb22625c
[   81.063348]  000040d0 00000002 00000000 cb226000 00000000 cc83e5b0 d1433=
e1c 00000246
[   81.069594]  00000001 00000002 cbce1f21 ca9568b0 00000002 000040d0 d1433=
e54 cbce1f90
[   81.073047] Call Trace:
[   81.073583]  [<cc4a629f>] dump_stack+0x16/0x18
[   81.077888]  [<cbce1451>] dump_header+0x71/0x210
[   81.079025]  [<cbce1f21>] ? out_of_memory+0x281/0x300
[   81.084622]  [<cbce1f90>] out_of_memory+0x2f0/0x300
[   81.085663]  [<cbce5dde>] __alloc_pages_nodemask+0x90e/0x920
[   81.093130]  [<cbd13944>] slob_new_pages+0x14/0x40
[   81.096487]  [<cbd13b6b>] __kmalloc+0x6b/0x160
[   81.099314]  [<cbc7fe63>] ? lock_torture_stats_print+0x43/0xd0
[   81.103924]  [<cbc7fef0>] ? lock_torture_stats_print+0xd0/0xd0
[   81.107405]  [<cbc7fe63>] lock_torture_stats_print+0x43/0xd0
[   81.108595]  [<cbc7ff1c>] lock_torture_stats+0x2c/0x70
[   81.114243]  [<cbc69535>] kthread+0xb5/0xd0
[   81.115146]  [<cc4ad300>] ret_from_kernel_thread+0x20/0x30
[   81.120832]  [<cbc69480>] ? __kthread_parkme+0x90/0x90
[   81.121930] Mem-Info:
[   81.122436] Normal per-cpu:
[   81.127573] CPU    0: hi:   90, btch:  15 usd:   0
[   81.128591] active_anon:0 inactive_anon:0 isolated_anon:0
[   81.128591]  active_file:2010 inactive_file:44581 isolated_file:0
[   81.128591]  unevictable:17874 dirty:0 writeback:0 unstable:0
[   81.128591]  free:527 slab_reclaimable:0 slab_unreclaimable:0
[   81.128591]  mapped:0 shmem:0 pagetables:0 bounce:0
[   81.128591]  free_cma:0
[   81.148025] Normal free:2108kB min:2108kB low:2632kB high:3160kB active_=
anon:0kB inactive_anon:0kB active_file:8040kB inactive_file:178324kB unevic=
table:71496kB isolated(anon):0kB isolated(file):0kB present:327160kB manage=
d:277952kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_re=
claimable:0kB slab_unreclaimable:0kB kernel_stack:384kB pagetables:0kB unst=
able:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:175353008 =
all_unreclaimable? yes
[   81.184273] lowmem_reserve[]: 0 0
[   81.189371] Normal: 1*4kB (R) 1*8kB (R) 1*16kB (R) 1*32kB (R) 0*64kB 0*1=
28kB 0*256kB 0*512kB 0*1024kB 1*2048kB (R) 0*4096kB =3D 2108kB
[   81.201179] Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepages_surp=
=3D0 hugepages_size=3D2048kB
[   81.208021] 64465 total pagecache pages
[   81.208931] 81790 pages RAM
[   81.213183] 0 pages HighMem/MovableOnly
[   81.218440] 12302 pages reserved
[   81.219229] 0 pages hwpoisoned
[   81.219959] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_s=
core_adj name
[   81.227015] Kernel panic - not syncing: Out of memory and no killable pr=
ocesses...
[   81.227015]=20
[   81.230041] CPU: 0 PID: 32 Comm: lock_torture_st Not tainted 3.19.0-rc4-=
g2e67200 #4
[   81.230275]  ca9568b0 ca9568b0 d1433e00 cc4a629f d1433e18 cc4a21f5 00000=
002 ca9568b0
[   81.230275]  00000002 000040d0 d1433e54 cbce1f9a cc71559c 00000002 00004=
0d0 ca95e000
[   81.230275]  00000000 00000000 00010f70 00000000 00000000 cc822774 00000=
000 cc8f7330
[   81.230275] Call Trace:
[   81.230275]  [<cc4a629f>] dump_stack+0x16/0x18
[   81.230275]  [<cc4a21f5>] panic+0x81/0x187
[   81.230275]  [<cbce1f9a>] out_of_memory+0x2fa/0x300
[   81.230275]  [<cbce5dde>] __alloc_pages_nodemask+0x90e/0x920
[   81.230275]  [<cbd13944>] slob_new_pages+0x14/0x40
[   81.230275]  [<cbd13b6b>] __kmalloc+0x6b/0x160
[   81.230275]  [<cbc7fe63>] ? lock_torture_stats_print+0x43/0xd0
[   81.230275]  [<cbc7fef0>] ? lock_torture_stats_print+0xd0/0xd0
[   81.230275]  [<cbc7fe63>] lock_torture_stats_print+0x43/0xd0
[   81.230275]  [<cbc7ff1c>] lock_torture_stats+0x2c/0x70
[   81.230275]  [<cbc69535>] kthread+0xb5/0xd0
[   81.230275]  [<cc4ad300>] ret_from_kernel_thread+0x20/0x30
[   81.230275]  [<cbc69480>] ? __kthread_parkme+0x90/0x90
[   81.230275] Kernel Offset: 0xac00000 from 0xc1000000 (relocation range: =
0xc0000000-0xd47dffff)

Elapsed time: 95
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-r=
2-0121/2e67200461d1eec17062de4947d07f3e6afd0848/vmlinuz-3.19.0-rc4-g2e67200=
 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=3Ddebug=
 sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D-1 softl=
ockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 prompt_r=
amdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/=
ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-r2-0121/linux-de=
vel:devel-roam-rand-201501240027:2e67200461d1eec17062de4947d07f3e6afd0848:b=
isect-linux-8/.vmlinuz-2e67200461d1eec17062de4947d07f3e6afd0848-20150124140=
541-21-client1 branch=3Dlinux-devel/devel-roam-rand-201501240027 BOOT_IMAGE=
=3D/kernel/i386-randconfig-r2-0121/2e67200461d1eec17062de4947d07f3e6afd0848=
/vmlinuz-3.19.0-rc4-g2e67200 drbd.minor_count=3D8'  -initrd /kernel-tests/i=
nitrd/quantal-core-i386.cgz -m 320 -smp 2 -net nic,vlan=3D1,model=3De1000 -=
net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=
=3Dlocaltime -pidfile /dev/shm/kboot/pid-quantal-client1-10 -serial file:/d=
ev/shm/kboot/serial-quantal-client1-10 -daemonize -display none -monitor nu=
ll=20

--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.19.0-rc4-gd26bb7f"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.19.0-rc4 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_PERF_EVENTS_INTEL_UNCORE=y
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
CONFIG_FIX_EARLYCON_MEM=y
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
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_FHANDLE is not set
# CONFIG_USELIB is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
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
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_TASKS_RCU is not set
# CONFIG_RCU_STALL_COMMON is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_HUGETLB is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_INIT_FALLBACK=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BPF=y
CONFIG_EXPERT=y
CONFIG_UID16=y
# CONFIG_SGETMASK_SYSCALL is not set
# CONFIG_SYSFS_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
# CONFIG_EVENTFD is not set
# CONFIG_BPF_SYSCALL is not set
CONFIG_SHMEM=y
CONFIG_AIO=y
# CONFIG_ADVISE_SYSCALLS is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
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
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
# CONFIG_UPROBES is not set
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
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# CONFIG_GCOV_PROFILE_ALL is not set
CONFIG_GCOV_FORMAT_AUTODETECT=y
# CONFIG_GCOV_FORMAT_3_4 is not set
# CONFIG_GCOV_FORMAT_4_7 is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_THROTTLING=y
CONFIG_BLK_CMDLINE_PARSER=y

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
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_CFQ_GROUP_IOSCHED is not set
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
# CONFIG_SMP is not set
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_IOSF_MBI is not set
# CONFIG_X86_RDC321X is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_XEN=y
CONFIG_XEN_DOM0=y
CONFIG_XEN_PVHVM=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=64
CONFIG_XEN_SAVE_RESTORE=y
CONFIG_XEN_DEBUG_FS=y
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
CONFIG_MVIAC3_2=y
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_ALIGNMENT_16=y
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
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
CONFIG_X86_ANCIENT_MCE=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
# CONFIG_VM86 is not set
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX32=y
CONFIG_TOSHIBA=y
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_MICROCODE_EARLY is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
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
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
# CONFIG_CMA is not set
# CONFIG_ZPOOL is not set
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
CONFIG_PGTABLE_MAPPING=y
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
# CONFIG_X86_PAT is not set
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_X86_INTEL_MPX=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_RANDOMIZE_BASE_MAX_OFFSET=0x20000000
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_PM_SLEEP=y
# CONFIG_PM_AUTOSLEEP is not set
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_DPM_WATCHDOG is not set
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_EXTLOG is not set
# CONFIG_PMIC_OPREGION is not set
# CONFIG_SFI is not set
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
# CONFIG_APM_IGNORE_USER_SUSPEND is not set
CONFIG_APM_DO_ENABLE=y
# CONFIG_APM_CPU_IDLE is not set
CONFIG_APM_DISPLAY_BLANK=y
# CONFIG_APM_ALLOW_INTS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=y
CONFIG_X86_P4_CLOCKMOD=y
CONFIG_X86_CPUFREQ_NFORCE2=y
CONFIG_X86_LONGRUN=y
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
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
CONFIG_PCI_XEN=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_XEN_PCIDEV_FRONTEND=y
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_SCx200=y
# CONFIG_SCx200HR_TIMER is not set
CONFIG_ALIX=y
CONFIG_NET5501=y
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
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_PMC_ATOM=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NET_PTP_CLASSIFY is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
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
# CONFIG_BATMAN_ADV is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_HSR is not set
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
# CONFIG_ALLOW_DEV_COREDUMP is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_SPMI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_FENCE_TRACE is not set

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
CONFIG_FTL=y
# CONFIG_NFTL is not set
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
# CONFIG_SSFDC is not set
CONFIG_SM_FTL=y
CONFIG_MTD_OOPS=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
CONFIG_MTD_JEDECPROBE=y
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
CONFIG_MTD_OTP=y
CONFIG_MTD_CFI_INTELEXT=y
CONFIG_MTD_CFI_AMDSTD=y
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
CONFIG_MTD_SBC_GXX=y
CONFIG_MTD_SCx200_DOCFLASH=y
CONFIG_MTD_AMD76XROM=y
CONFIG_MTD_ICHXROM=y
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
# CONFIG_MTD_PCI is not set
CONFIG_MTD_GPIO_ADDR=y
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set
CONFIG_MTD_LATCH_ADDR=y

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=y
CONFIG_MTD_DATAFLASH_WRITE_VERIFY=y
CONFIG_MTD_DATAFLASH_OTP=y
# CONFIG_MTD_M25P80 is not set
CONFIG_MTD_SST25L=y
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
CONFIG_MTD_MTDRAM=y
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTDRAM_ABS_POS=0
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
# CONFIG_MTD_NAND is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
CONFIG_MTD_SPI_NOR=y
# CONFIG_MTD_SPI_NOR_USE_4K_SECTORS is not set
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
# CONFIG_MTD_UBI_BLOCK is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
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
# CONFIG_ZRAM is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_OSD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_XEN_BLKDEV_FRONTEND=y
# CONFIG_XEN_BLKDEV_BACKEND is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
# CONFIG_AD525X_DPOT_SPI is not set
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
CONFIG_DS1682=y
# CONFIG_TI_DAC7512 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_BMP085_SPI=y
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_LATTICE_ECP3_CONFIG=y
CONFIG_SRAM=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_93XX46=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Bus Driver
#

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
# CONFIG_ECHO is not set
# CONFIG_CXL_BASE is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_IDE_GD is not set
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
CONFIG_BLK_DEV_PLATFORM=y
CONFIG_BLK_DEV_CMD640=y
# CONFIG_BLK_DEV_CMD640_ENHANCED is not set
# CONFIG_BLK_DEV_IDEPNP is not set

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
# CONFIG_BLK_DEV_IDEDMA is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_MQ_DEFAULT=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_ENCLOSURE=y
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPT3SAS is not set
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_XEN_SCSI_FRONTEND=y
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
CONFIG_SCSI_PPA=y
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_IZIP_EPP16 is not set
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_AM53C974 is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_WD719X is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_VIRTIO is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
CONFIG_SCSI_DH_HP_SW=y
# CONFIG_SCSI_DH_EMC is not set
# CONFIG_SCSI_DH_ALUA is not set
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=y
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
CONFIG_SATA_AHCI_PLATFORM=y
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_AUTODETECT is not set
# CONFIG_MD_LINEAR is not set
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MD_MULTIPATH=y
CONFIG_MD_FAULTY=y
CONFIG_BCACHE=y
# CONFIG_BCACHE_DEBUG is not set
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=y
CONFIG_DM_BIO_PRISON=y
CONFIG_DM_PERSISTENT_DATA=y
CONFIG_DM_DEBUG_BLOCK_STACK_TRACING=y
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_THIN_PROVISIONING=y
# CONFIG_DM_CACHE is not set
# CONFIG_DM_ERA is not set
# CONFIG_DM_MIRROR is not set
CONFIG_DM_RAID=y
# CONFIG_DM_ZERO is not set
CONFIG_DM_MULTIPATH=y
# CONFIG_DM_MULTIPATH_QL is not set
CONFIG_DM_MULTIPATH_ST=y
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
CONFIG_DM_FLAKEY=y
CONFIG_DM_VERITY=y
CONFIG_DM_SWITCH=y
CONFIG_TARGET_CORE=y
# CONFIG_TCM_IBLOCK is not set
CONFIG_TCM_FILEIO=y
CONFIG_TCM_PSCSI=y
# CONFIG_TCM_USER is not set
# CONFIG_LOOPBACK_TARGET is not set
# CONFIG_ISCSI_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
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
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
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
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
# CONFIG_MOUSE_PS2_ALPS is not set
# CONFIG_MOUSE_PS2_LOGIPS2PP is not set
# CONFIG_MOUSE_PS2_SYNAPTICS is not set
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=y
CONFIG_MOUSE_APPLETOUCH=y
CONFIG_MOUSE_BCM5974=y
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_ELAN_I2C is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=y
CONFIG_MOUSE_SYNAPTICS_USB=y
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
CONFIG_TABLET_USB_AIPTEK=y
CONFIG_TABLET_USB_GTCO=y
CONFIG_TABLET_USB_HANWANG=y
# CONFIG_TABLET_USB_KBTAB is not set
CONFIG_TABLET_SERIAL_WACOM4=y
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM80X_ONKEY=y
CONFIG_INPUT_AD714X=y
CONFIG_INPUT_AD714X_I2C=y
CONFIG_INPUT_AD714X_SPI=y
# CONFIG_INPUT_BMA150 is not set
CONFIG_INPUT_MAX8925_ONKEY=y
# CONFIG_INPUT_MAX8997_HAPTIC is not set
CONFIG_INPUT_MC13783_PWRBUTTON=y
CONFIG_INPUT_MMA8450=y
# CONFIG_INPUT_MPU3050 is not set
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=y
# CONFIG_INPUT_GPIO_BEEPER is not set
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_POWERMATE=y
CONFIG_INPUT_YEALINK=y
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_TWL6040_VIBRA=y
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_PCF8574 is not set
CONFIG_INPUT_PWM_BEEPER=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
# CONFIG_INPUT_DA9052_ONKEY is not set
CONFIG_INPUT_DA9055_ONKEY=y
# CONFIG_INPUT_WM831X_ON is not set
CONFIG_INPUT_PCAP=y
# CONFIG_INPUT_ADXL34X is not set
CONFIG_INPUT_IMS_PCU=y
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=y
CONFIG_INPUT_IDEAPAD_SLIDEBAR=y
CONFIG_INPUT_DRV260X_HAPTICS=y
CONFIG_INPUT_DRV2667_HAPTICS=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_ROUTER is not set
CONFIG_TRACE_SINK=y
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DW=y
# CONFIG_SERIAL_8250_FINTEK is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=y
CONFIG_SERIAL_MAX310X=y
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=y
CONFIG_SERIAL_SCCNXP_CONSOLE=y
CONFIG_SERIAL_SC16IS7XX=y
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_IFX6X60=y
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
# CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
CONFIG_TTY_PRINTK=y
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
# CONFIG_HVC_XEN is not set
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_SI_PROBE_DEFAULTS=y
CONFIG_IPMI_SSIF=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_XILLYBUS is not set

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
CONFIG_I2C_MUX_PCA9541=y
# CONFIG_I2C_MUX_PCA954x is not set
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
CONFIG_I2C_GPIO=y
CONFIG_I2C_KEMPLD=y
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
CONFIG_I2C_DLN2=y
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=y
# CONFIG_I2C_VIPERBOARD is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_SLAVE=y
CONFIG_I2C_SLAVE_EEPROM=y
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_BUTTERFLY is not set
CONFIG_SPI_GPIO=y
CONFIG_SPI_LM70_LLP=y
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_XCOMM=y
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=y
CONFIG_SPMI=y
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
CONFIG_HSI_CHAR=y

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
CONFIG_NTP_PPS=y

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=y
CONFIG_PPS_CLIENT_PARPORT=y
# CONFIG_PPS_CLIENT_GPIO is not set

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
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=y
# CONFIG_GPIO_F7188X is not set
CONFIG_GPIO_SCH311X=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
# CONFIG_GPIO_CRYSTAL_COVE is not set
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_TWL6040=y
# CONFIG_GPIO_WM831X is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_INTEL_MID is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
CONFIG_GPIO_MCP23S08=y
# CONFIG_GPIO_MC33880 is not set

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
CONFIG_GPIO_TPS65910=y

#
# USB GPIO expanders:
#
CONFIG_GPIO_VIPERBOARD=y
CONFIG_GPIO_DLN2=y
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2406=y
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
# CONFIG_MAX8925_POWER is not set
CONFIG_WM831X_BACKUP=y
# CONFIG_WM831X_POWER is not set
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2760=y
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
CONFIG_BATTERY_DA9030=y
CONFIG_BATTERY_DA9052=y
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_CHARGER_ISP1704=y
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_LP8788=y
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_MAX14577=y
# CONFIG_CHARGER_MAX8997 is not set
CONFIG_CHARGER_MAX8998=y
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
# CONFIG_CHARGER_BQ24735 is not set
CONFIG_CHARGER_SMB347=y
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=y
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_MC13783_ADC=y
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_IBMAEM=y
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IIO_HWMON=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_POWR1220=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LTC2945=y
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=y
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_MAX1111=y
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_MENF21BMC_HWMON=y
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=y
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LM95234=y
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_NTC_THERMISTOR=y
# CONFIG_SENSORS_NCT6683 is not set
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_NCT7802 is not set
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
CONFIG_SENSORS_PMBUS=y
CONFIG_SENSORS_ADM1275=y
# CONFIG_SENSORS_LM25066 is not set
CONFIG_SENSORS_LTC2978=y
# CONFIG_SENSORS_LTC2978_REGULATOR is not set
CONFIG_SENSORS_MAX16064=y
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_TPS40422=y
CONFIG_SENSORS_UCD9000=y
# CONFIG_SENSORS_UCD9200 is not set
CONFIG_SENSORS_ZL6100=y
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SHTC1=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_ADC128D818=y
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP103=y
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_BANG_BANG is not set
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_THERMAL_EMULATION is not set
CONFIG_INTEL_POWERCLAMP=y
# CONFIG_INT340X_THERMAL is not set

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
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
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
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_AS3711=y
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_BCM590XX=y
CONFIG_MFD_AXP20X=y
# CONFIG_MFD_CROS_EC is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_DLN2=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
CONFIG_INTEL_SOC_PMIC=y
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX14577=y
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
CONFIG_MFD_MENF21BMC=y
CONFIG_EZX_PCAP=y
CONFIG_MFD_VIPERBOARD=y
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RTSX_USB=y
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_RN5T618=y
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP3943 is not set
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS65218=y
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS65910=y
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
CONFIG_MFD_TPS80031=y
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_88PM800=y
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_AS3711=y
CONFIG_REGULATOR_AXP20X=y
CONFIG_REGULATOR_BCM590XX=y
CONFIG_REGULATOR_DA903X=y
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_DA9211=y
# CONFIG_REGULATOR_FAN53555 is not set
# CONFIG_REGULATOR_GPIO is not set
CONFIG_REGULATOR_ISL9305=y
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_LP3971 is not set
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LP8788=y
# CONFIG_REGULATOR_LTC3589 is not set
CONFIG_REGULATOR_MAX14577=y
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MAX8997=y
CONFIG_REGULATOR_MAX8998=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
# CONFIG_REGULATOR_MC13892 is not set
# CONFIG_REGULATOR_PCAP is not set
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_PWM=y
# CONFIG_REGULATOR_RN5T618 is not set
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS6105X=y
# CONFIG_REGULATOR_TPS62360 is not set
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_TPS65910=y
CONFIG_REGULATOR_TPS80031=y
# CONFIG_REGULATOR_WM831X is not set
CONFIG_REGULATOR_WM8400=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_SDR_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_RC_CORE=y
CONFIG_RC_MAP=y
# CONFIG_RC_DECODERS is not set
# CONFIG_RC_DEVICES is not set
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_CYPRESS_FIRMWARE=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_VIDEO_IR_I2C=y

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
# Audio/Video compression chips
#

#
# Miscellaneous helper chips
#

#
# Sensors used on soc_camera driver
#

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

#
# Direct Rendering Manager
#
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_ADV7511=y
CONFIG_DRM_I2C_CH7006=y
CONFIG_DRM_I2C_SIL164=y
# CONFIG_DRM_I2C_NXP_TDA998X is not set
CONFIG_DRM_PTN3460=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
CONFIG_DRM_UDL=y
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_BOCHS is not set

#
# Frame buffer Devices
#
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_CMDLINE=y
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
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
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
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_VESA=y
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_OPENCORES=y
CONFIG_FB_S1D13XXX=y
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
# CONFIG_FB_SMSCUFX is not set
CONFIG_FB_UDL=y
# CONFIG_FB_VIRTUAL is not set
CONFIG_XEN_FBDEV_FRONTEND=y
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
# CONFIG_FB_AUO_K1900 is not set
CONFIG_FB_AUO_K1901=y
CONFIG_FB_SIMPLE=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_L4F00242T03=y
CONFIG_LCD_LMS283GF05=y
CONFIG_LCD_LTV350QV=y
# CONFIG_LCD_ILI922X is not set
CONFIG_LCD_ILI9320=y
CONFIG_LCD_TDO24M=y
# CONFIG_LCD_VGG2432A4 is not set
# CONFIG_LCD_PLATFORM is not set
# CONFIG_LCD_S6E63M0 is not set
CONFIG_LCD_LD9040=y
CONFIG_LCD_AMS369FG06=y
CONFIG_LCD_LMS501KF03=y
CONFIG_LCD_HX8357=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_PWM=y
CONFIG_BACKLIGHT_DA903X=y
# CONFIG_BACKLIGHT_DA9052 is not set
# CONFIG_BACKLIGHT_MAX8925 is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_WM831X is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_LM3630A=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
# CONFIG_BACKLIGHT_LP8788 is not set
CONFIG_BACKLIGHT_AS3711=y
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
# CONFIG_VGASTATE is not set
CONFIG_HDMI=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
CONFIG_LOGO_LINUX_VGA16=y
# CONFIG_LOGO_LINUX_CLUT224 is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
CONFIG_UHID=y
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
CONFIG_HID_APPLEIR=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CP2112 is not set
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_ELO=y
# CONFIG_HID_EZKEY is not set
CONFIG_HID_HOLTEK=y
CONFIG_HOLTEK_FF=y
# CONFIG_HID_GT683R is not set
# CONFIG_HID_HUION is not set
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
# CONFIG_HID_GYRATION is not set
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LENOVO=y
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_HIDPP is not set
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
# CONFIG_HID_NTRIG is not set
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PENMOUNT=y
CONFIG_HID_PETALYNX=y
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PLANTRONICS is not set
CONFIG_HID_PRIMAX=y
# CONFIG_HID_ROCCAT is not set
CONFIG_HID_SAITEK=y
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SONY=y
CONFIG_SONY_FF=y
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_RMI=y
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=y
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_HID_SENSOR_HUB=y

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
CONFIG_I2C_HID=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DEFAULT_PERSIST is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_OTG=y
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_OTG_FSM=y
CONFIG_USB_MON=y
CONFIG_USB_WUSB=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_PCI=y
CONFIG_USB_XHCI_PLATFORM=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
# CONFIG_USB_OXU210HP_HCD is not set
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_FUSBH200_HCD=y
# CONFIG_USB_FOTG210_HCD is not set
# CONFIG_USB_MAX3421_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_U132_HCD is not set
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_HCD_ISO is not set
CONFIG_USB_R8A66597_HCD=y
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set
CONFIG_USB_HCD_BCMA=y
# CONFIG_USB_HCD_SSB is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
# CONFIG_USB_PRINTER is not set
CONFIG_USB_WDM=y
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
CONFIG_USB_STORAGE_DEBUG=y
CONFIG_USB_STORAGE_REALTEK=y
# CONFIG_REALTEK_AUTOPM is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
CONFIG_USB_UAS=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y
# CONFIG_USBIP_CORE is not set
CONFIG_USB_MUSB_HDRC=y
# CONFIG_USB_MUSB_HOST is not set
# CONFIG_USB_MUSB_GADGET is not set
CONFIG_USB_MUSB_DUAL_ROLE=y

#
# Platform Glue Layer
#
# CONFIG_USB_MUSB_TUSB6010 is not set
# CONFIG_USB_MUSB_UX500 is not set
CONFIG_MUSB_PIO_ONLY=y
CONFIG_USB_DWC3=y
# CONFIG_USB_DWC3_HOST is not set
# CONFIG_USB_DWC3_GADGET is not set
CONFIG_USB_DWC3_DUAL_ROLE=y

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_PCI=y

#
# Debugging features
#
# CONFIG_USB_DWC3_DEBUG is not set
# CONFIG_DWC3_HOST_USB3_LPM_ENABLE is not set
# CONFIG_USB_DWC2 is not set
CONFIG_USB_CHIPIDEA=y
CONFIG_USB_CHIPIDEA_UDC=y
CONFIG_USB_CHIPIDEA_HOST=y
# CONFIG_USB_CHIPIDEA_DEBUG is not set

#
# USB port drivers
#
CONFIG_USB_USS720=y
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
CONFIG_USB_EHSET_TEST_FIXTURE=y
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y
# CONFIG_USB_EZUSB_FX2 is not set
CONFIG_USB_HSIC_USB3503=y
CONFIG_USB_LINK_LAYER_TEST=y

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_NOP_USB_XCEIV=y
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_ISP1301 is not set
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_DEBUG=y
# CONFIG_USB_GADGET_VERBOSE is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FOTG210_UDC=y
# CONFIG_USB_GR_UDC is not set
CONFIG_USB_R8A66597=y
CONFIG_USB_PXA27X=y
CONFIG_USB_MV_UDC=y
# CONFIG_USB_MV_U3D is not set
CONFIG_USB_M66592=y
CONFIG_USB_BDC_UDC=y

#
# Platform Support
#
CONFIG_USB_BDC_PCI=y
# CONFIG_USB_AMD5536UDC is not set
CONFIG_USB_NET2272=y
CONFIG_USB_NET2272_DMA=y
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
CONFIG_USB_DUMMY_HCD=y
CONFIG_USB_LIBCOMPOSITE=y
CONFIG_USB_F_MASS_STORAGE=y
# CONFIG_USB_CONFIGFS is not set
# CONFIG_USB_ZERO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
CONFIG_USB_MASS_STORAGE=y
# CONFIG_USB_GADGET_TARGET is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_USB_G_WEBCAM is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=y
# CONFIG_UWB_WHCI is not set
CONFIG_UWB_I1480U=y
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
CONFIG_SDIO_UART=y
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_SPI=y
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_VUB300=y
CONFIG_MMC_USHC=y
CONFIG_MMC_USDHI6ROL0=y
# CONFIG_MMC_REALTEK_USB is not set
# CONFIG_MMC_TOSHIBA_PCI is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_NET48XX is not set
# CONFIG_LEDS_WRAP is not set
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_LP5562 is not set
CONFIG_LEDS_LP8501=y
# CONFIG_LEDS_LP8788 is not set
CONFIG_LEDS_LP8860=y
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_DA903X=y
CONFIG_LEDS_DA9052=y
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_PWM is not set
CONFIG_LEDS_REGULATOR=y
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_LT3593 is not set
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_MAX8997=y
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
CONFIG_LEDS_MENF21BMC=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
CONFIG_ACCESSIBILITY=y
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=y
CONFIG_EDAC_MCE_INJ=y
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
# CONFIG_RTC_SYSTOHC is not set
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_88PM80X is not set
CONFIG_RTC_DRV_DS1307=y
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=y
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_LP8788 is not set
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8907=y
# CONFIG_RTC_DRV_MAX8925 is not set
CONFIG_RTC_DRV_MAX8998=y
CONFIG_RTC_DRV_MAX8997=y
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
# CONFIG_RTC_DRV_ISL12022 is not set
CONFIG_RTC_DRV_ISL12057=y
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF2127=y
# CONFIG_RTC_DRV_PCF8523 is not set
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF85063=y
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
# CONFIG_RTC_DRV_M41T80_WDT is not set
CONFIG_RTC_DRV_BQ32K=y
CONFIG_RTC_DRV_TPS65910=y
# CONFIG_RTC_DRV_TPS80031 is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
CONFIG_RTC_DRV_RX8025=y
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1305 is not set
CONFIG_RTC_DRV_DS1343=y
CONFIG_RTC_DRV_DS1347=y
# CONFIG_RTC_DRV_DS1390 is not set
CONFIG_RTC_DRV_MAX6902=y
CONFIG_RTC_DRV_R9701=y
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_DS3234 is not set
# CONFIG_RTC_DRV_PCF2123 is not set
CONFIG_RTC_DRV_RX4581=y
CONFIG_RTC_DRV_MCP795=y

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=y
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
# CONFIG_RTC_DRV_DS2404 is not set
CONFIG_RTC_DRV_DA9052=y
CONFIG_RTC_DRV_DA9055=y
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_M48T86=y
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=y
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_RP5C01=y
# CONFIG_RTC_DRV_V3020 is not set
CONFIG_RTC_DRV_WM831X=y

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_PCAP=y
CONFIG_RTC_DRV_MC13XXX=y
CONFIG_RTC_DRV_XGENE=y

#
# HID Sensor RTC drivers
#
CONFIG_RTC_DRV_HID_SENSOR_TIME=y
# CONFIG_DMADEVICES is not set
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
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set

#
# Xen driver support
#
CONFIG_XEN_BALLOON=y
CONFIG_XEN_SCRUB_PAGES=y
CONFIG_XEN_DEV_EVTCHN=y
CONFIG_XEN_BACKEND=y
# CONFIG_XENFS is not set
# CONFIG_XEN_SYS_HYPERVISOR is not set
CONFIG_XEN_XENBUS_FRONTEND=y
CONFIG_XEN_GNTDEV=y
# CONFIG_XEN_GRANT_DEV_ALLOC is not set
CONFIG_SWIOTLB_XEN=y
CONFIG_XEN_PCIDEV_BACKEND=y
# CONFIG_XEN_SCSI_BACKEND is not set
CONFIG_XEN_PRIVCMD=y
CONFIG_XEN_ACPI_PROCESSOR=y
CONFIG_XEN_HAVE_PVMMU=y
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
CONFIG_CHROME_PLATFORMS=y
# CONFIG_CHROMEOS_PSTORE is not set

#
# SOC (System On Chip) specific Drivers
#
# CONFIG_SOC_TI is not set

#
# Hardware Spinlock drivers
#

#
# Clock Source drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_ATMEL_PIT is not set
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
CONFIG_MAILBOX=y
# CONFIG_PCC is not set
CONFIG_IOMMU_SUPPORT=y

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_STE_MODEM_RPROC=y

#
# Rpmsg drivers
#

#
# SOC (System On Chip) specific Drivers
#
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
CONFIG_DEVFREQ_GOV_POWERSAVE=y
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
# CONFIG_EXTCON_ADC_JACK is not set
CONFIG_EXTCON_GPIO=y
CONFIG_EXTCON_MAX14577=y
# CONFIG_EXTCON_MAX8997 is not set
CONFIG_EXTCON_RT8973A=y
CONFIG_EXTCON_SM5502=y
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
CONFIG_BMA180=y
CONFIG_BMC150_ACCEL=y
# CONFIG_HID_SENSOR_ACCEL_3D is not set
# CONFIG_IIO_ST_ACCEL_3AXIS is not set
CONFIG_KXSD9=y
CONFIG_MMA8452=y
# CONFIG_KXCJK1013 is not set

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
CONFIG_AD7266=y
# CONFIG_AD7291 is not set
# CONFIG_AD7298 is not set
CONFIG_AD7476=y
CONFIG_AD7791=y
# CONFIG_AD7793 is not set
CONFIG_AD7887=y
CONFIG_AD7923=y
# CONFIG_AD799X is not set
CONFIG_AXP288_ADC=y
CONFIG_LP8788_ADC=y
# CONFIG_MAX1027 is not set
CONFIG_MAX1363=y
CONFIG_MCP320X=y
CONFIG_MCP3422=y
CONFIG_NAU7802=y
CONFIG_QCOM_SPMI_IADC=y
CONFIG_TI_ADC081C=y
# CONFIG_TI_ADC128S052 is not set
# CONFIG_TI_AM335X_ADC is not set
CONFIG_VIPERBOARD_ADC=y

#
# Amplifiers
#
CONFIG_AD8366=y

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_SPI=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
CONFIG_AD5064=y
# CONFIG_AD5360 is not set
CONFIG_AD5380=y
CONFIG_AD5421=y
CONFIG_AD5446=y
# CONFIG_AD5449 is not set
# CONFIG_AD5504 is not set
CONFIG_AD5624R_SPI=y
CONFIG_AD5686=y
CONFIG_AD5755=y
# CONFIG_AD5764 is not set
# CONFIG_AD5791 is not set
# CONFIG_AD7303 is not set
CONFIG_MAX517=y
CONFIG_MCP4725=y
CONFIG_MCP4922=y

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
# CONFIG_AD9523 is not set

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
CONFIG_ADIS16260=y
CONFIG_ADXRS450=y
CONFIG_BMG160=y
CONFIG_HID_SENSOR_GYRO_3D=y
# CONFIG_IIO_ST_GYRO_3AXIS is not set
CONFIG_ITG3200=y

#
# Humidity sensors
#
CONFIG_DHT11=y
CONFIG_SI7005=y
CONFIG_SI7020=y

#
# Inertial measurement units
#
# CONFIG_ADIS16400 is not set
CONFIG_ADIS16480=y
CONFIG_INV_MPU6050_IIO=y
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
# CONFIG_AL3320A is not set
# CONFIG_APDS9300 is not set
CONFIG_CM32181=y
CONFIG_CM36651=y
CONFIG_GP2AP020A00F=y
CONFIG_ISL29125=y
CONFIG_HID_SENSOR_ALS=y
CONFIG_HID_SENSOR_PROX=y
CONFIG_LTR501=y
# CONFIG_TCS3414 is not set
# CONFIG_TCS3472 is not set
CONFIG_SENSORS_TSL2563=y
CONFIG_TSL4531=y
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
CONFIG_AK09911=y
# CONFIG_MAG3110 is not set
CONFIG_HID_SENSOR_MAGNETOMETER_3D=y
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
CONFIG_IIO_ST_MAGN_SPI_3AXIS=y

#
# Inclinometer sensors
#
# CONFIG_HID_SENSOR_INCLINOMETER_3D is not set
# CONFIG_HID_SENSOR_DEVICE_ROTATION is not set

#
# Triggers - standalone
#
# CONFIG_IIO_INTERRUPT_TRIGGER is not set
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Pressure sensors
#
CONFIG_BMP280=y
CONFIG_HID_SENSOR_PRESS=y
CONFIG_MPL115=y
CONFIG_MPL3115=y
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y
CONFIG_IIO_ST_PRESS_SPI=y
# CONFIG_T5403 is not set

#
# Lightning sensors
#
CONFIG_AS3935=y

#
# Temperature sensors
#
CONFIG_MLX90614=y
# CONFIG_TMP006 is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_LPSS=y
# CONFIG_PWM_LPSS_PCI is not set
# CONFIG_PWM_LPSS_PLATFORM is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
CONFIG_POWERCAP=y
# CONFIG_MCB is not set
# CONFIG_THUNDERBOLT is not set

#
# Android
#
# CONFIG_ANDROID is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
CONFIG_EXT4_FS_SECURITY=y
CONFIG_EXT4_DEBUG=y
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y
CONFIG_BTRFS_DEBUG=y
CONFIG_BTRFS_ASSERT=y
# CONFIG_NILFS2_FS is not set
# CONFIG_FS_POSIX_ACL is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y
CONFIG_OVERLAY_FS=y

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_DEBUG=y
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
# CONFIG_ZISOFS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
# CONFIG_HFSPLUS_FS_POSIX_ACL is not set
CONFIG_BEFS_FS=y
CONFIG_BEFS_DEBUG=y
# CONFIG_BFS_FS is not set
CONFIG_EFS_FS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
# CONFIG_JFFS2_SUMMARY is not set
CONFIG_JFFS2_FS_XATTR=y
# CONFIG_JFFS2_FS_POSIX_ACL is not set
CONFIG_JFFS2_FS_SECURITY=y
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
CONFIG_JFFS2_LZO=y
CONFIG_JFFS2_RTIME=y
CONFIG_JFFS2_RUBIN=y
CONFIG_JFFS2_CMODE_NONE=y
# CONFIG_JFFS2_CMODE_PRIORITY is not set
# CONFIG_JFFS2_CMODE_SIZE is not set
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
# CONFIG_UBIFS_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=y
CONFIG_SQUASHFS_FILE_CACHE=y
# CONFIG_SQUASHFS_FILE_DIRECT is not set
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y
# CONFIG_SQUASHFS_XATTR is not set
# CONFIG_SQUASHFS_ZLIB is not set
# CONFIG_SQUASHFS_LZ4 is not set
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=y
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
# CONFIG_ROMFS_BACKED_BY_MTD is not set
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_FTRACE=y
# CONFIG_PSTORE_RAM is not set
CONFIG_SYSV_FS=y
# CONFIG_UFS_FS is not set
# CONFIG_EXOFS_FS is not set
# CONFIG_F2FS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_PAGE_OWNER=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_PAGE_EXTENSION=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
# CONFIG_DEBUG_OBJECTS_WORK is not set
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
# CONFIG_SCHED_STACK_END_CHECK is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_PI_LIST=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST_RUNNABLE=y
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
# CONFIG_FAULT_INJECTION is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
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
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
# CONFIG_TRACER_SNAPSHOT is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
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
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_ASYNC_RAID6_TEST=y
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_FIRMWARE=y
CONFIG_TEST_UDELAY=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
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
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
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
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_MCRYPTD=y
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
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
# CONFIG_CRYPTO_HMAC is not set
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
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
# CONFIG_CRYPTO_TWOFISH_586 is not set

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
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_DRBG_MENU is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
# CONFIG_CRYPTO_DEV_CCP is not set
# CONFIG_CRYPTO_DEV_QAT_DH895xCC is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
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
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
# CONFIG_CRC_CCITT is not set
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
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
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
# CONFIG_XZ_DEC_POWERPC is not set
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
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_GLOB=y
CONFIG_GLOB_SELFTEST=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_ARCH_HAS_SG_CHAIN=y

--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--tKW2IUtsqtDRztdT--
