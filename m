Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbaLJX0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 18:26:52 -0500
Received: from mga03.intel.com ([134.134.136.65]:32590 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756847AbaLJX0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 18:26:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,554,1413270000"; 
   d="scan'208";a="621872943"
Date: Wed, 10 Dec 2014 15:26:45 -0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Michael Turquette <mturquette@deferred.io>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: [sched] WARNING: CPU: 0 PID: 0 at arch/x86/kernel/cpu/common.c:1439
 warn_pre_alternatives()
Message-ID: <20141210232645.GD24163@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="48TaNjbzBVislYPb"
Content-Disposition: inline
In-Reply-To: <20141210232049.GC24163@wfg-t540p.sh.intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--48TaNjbzBVislYPb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dietmar,

FYI, here is another bisect result.

https://git.linaro.org/people/mturquette/linux.git eas-next
commit 1fadb581b0be9420b143e43ff2f4a07ea7e45f6c
Author:     Dietmar Eggemann <dietmar.eggemann@arm.com>
AuthorDate: Tue Dec 2 14:06:24 2014 +0000
Commit:     Michael Turquette <mturquette@deferred.io>
CommitDate: Tue Dec 9 20:33:17 2014 -0800

    sched: Make usage and load tracking cpu scale-invariant
    
    Besides the existing frequency scale-invariance correction factor, apply
    cpu scale-invariance correction factor to usage and load tracking.
    
    Cpu scale-invariance takes cpu performance deviations due to
    micro-architectural differences (i.e. instructions per seconds) between
    cpus in HMP systems (e.g. big.LITTLE) and differences in the frequency
    value of the highest OPP between cpus in SMP systems into consideration.
    
    Each segment of the sched_avg::{running_avg_sum, runnable_avg_sum}
    geometric series is now scaled by the cpu performance factor too so the
    sched_avg::{utilization_avg_contrib, load_avg_contrib} of each entity will
    be invariant from the particular cpu of the HMP/SMP system it is gathered
    on. As a result, cfs_rq::runnable_load_avg which is the sum of
    sched_avg::load_avg_contrib, becomes cpu scale-invariant too.
    
    So the {usage, load} level that is returned by {get_cpu_usage,
    weighted_cpuload} stays relative to the max cpu performance of the system.
    
    Cc: Ingo Molnar <mingo@redhat.com>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>

===================================================
PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
===================================================

Attached dmesg for the parent commit, too, to help confirm whether it is a noise error.

+------------------------------------------------------------------+------------+------------+------------+
|                                                                  | e754569101 | 1fadb581b0 | 1e7327cb22 |
+------------------------------------------------------------------+------------+------------+------------+
| boot_successes                                                   | 0          | 0          | 0          |
| boot_failures                                                    | 80         | 20         | 14         |
| Kernel_panic-not_syncing:Out_of_memory_and_no_killable_processes | 80         |            |            |
| backtrace:lock_torture_stats                                     | 80         |            |            |
| WARNING:at_arch/x86/kernel/cpu/common.c:#warn_pre_alternatives() | 0          | 19         | 14         |
| BUG:unable_to_handle_kernel                                      | 0          | 19         | 14         |
| Oops                                                             | 0          | 19         | 14         |
| RIP:arch_scale_cpu_capacity                                      | 0          | 19         | 14         |
| Kernel_panic-not_syncing:Fatal_exception_in_interrupt            | 0          | 19         | 14         |
| backtrace:acpi_load_tables                                       | 0          | 19         | 14         |
| backtrace:acpi_early_init                                        | 0          | 19         | 14         |
| BUG:kernel_boot_crashed                                          | 0          | 1          |            |
+------------------------------------------------------------------+------------+------------+------------+

[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] ACPI: Core revision 20140926
[    0.020006] ------------[ cut here ]------------
[    0.021391] WARNING: CPU: 0 PID: 0 at arch/x86/kernel/cpu/common.c:1439 warn_pre_alternatives+0x2e/0x40()
[    0.024425] You're using static_cpu_has before alternatives have run!
[    0.026159] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.18.0-rc2-g1fadb58 #507
[    0.028350] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.029899]  0000000000000009 ffff8800126039f8 ffffffff82d77315 ffff880012603a48
[    0.030000]  0000000000000009 ffff880012603a38 ffffffff81105674 0000000000000000
[    0.030000]  0000000000000050 ffffffff83c7de40 0000000000000000 0000000000000060
[    0.030000] Call Trace:
[    0.030000]  <IRQ>  [<ffffffff82d77315>] dump_stack+0xc5/0x175
[    0.030000]  [<ffffffff81105674>] warn_slowpath_common+0xc4/0x100
[    0.030000]  [<ffffffff81105746>] warn_slowpath_fmt+0x56/0x60
[    0.030000]  [<ffffffff81034dde>] warn_pre_alternatives+0x2e/0x40
[    0.030000]  [<ffffffff81092831>] __do_page_fault+0x4f1/0x1060
[    0.030000]  [<ffffffff81093601>] trace_do_page_fault+0xe1/0x450
[    0.030000]  [<ffffffff8190042a>] ? trace_hardirqs_off_thunk+0x3a/0x3f
[    0.030000]  [<ffffffff81083a8f>] do_async_page_fault+0x3f/0x200
[    0.030000]  [<ffffffff82d9a898>] async_page_fault+0x28/0x30
[    0.030000]  [<ffffffff81179edd>] ? arch_scale_cpu_capacity+0xd/0x30
[    0.030000]  [<ffffffff81179f35>] ? contrib_scale_factor+0x35/0x50
[    0.030000]  [<ffffffff8117eff0>] task_tick_fair+0x2b0/0xe50
[    0.030000]  [<ffffffff81170062>] ? sched_clock_cpu+0x212/0x2e0
[    0.030000]  [<ffffffff8116551b>] scheduler_tick+0x7b/0xf0
[    0.030000]  [<ffffffff811ef834>] update_process_times+0xb4/0xe0
[    0.030000]  [<ffffffff8120b14f>] tick_periodic+0xcf/0xe0
[    0.030000]  [<ffffffff8120b762>] tick_handle_periodic+0x32/0x110
[    0.030000]  [<ffffffff8100df9d>] timer_interrupt+0x1d/0x30
[    0.030000]  [<ffffffff811bcec7>] handle_irq_event_percpu+0x147/0x670
[    0.030000]  [<ffffffff82d96a84>] ? _raw_spin_lock_irqsave+0xc4/0x170
[    0.030000]  [<ffffffff811bd441>] handle_irq_event+0x51/0x90
[    0.030000]  [<ffffffff811c4ada>] handle_level_irq+0x1ba/0x240
[    0.030000]  [<ffffffff8100cd1c>] handle_irq+0x7c/0xa0
[    0.030000]  [<ffffffff8100b9c9>] do_IRQ+0x69/0x190
[    0.030000]  [<ffffffff81aad401>] ? acpi_os_create_cache+0x11/0x64
[    0.030000]  [<ffffffff82d99832>] common_interrupt+0x72/0x72
[    0.030000]  <EOI>  [<ffffffff8102ce07>] ? save_stack_trace+0x37/0x90
[    0.030000]  [<ffffffff81084b7e>] ? native_restore_fl+0xe/0x20
[    0.030000]  [<ffffffff82d96f37>] _raw_spin_unlock_irqrestore+0xe7/0x150
[    0.030000]  [<ffffffff8137f6cc>] __slab_free+0xcc/0x6b0
[    0.030000]  [<ffffffff8137f853>] ? __slab_free+0x253/0x6b0
[    0.030000]  [<ffffffff8137e801>] ? __slab_alloc+0xdf1/0xf60
[    0.030000]  [<ffffffff813820eb>] kmem_cache_free+0x57b/0x630
[    0.030000]  [<ffffffff81aad4a9>] ? acpi_os_release_object+0x15/0x20
[    0.030000]  [<ffffffff81aad4a9>] acpi_os_release_object+0x15/0x20
[    0.030000]  [<ffffffff81afa9c9>] acpi_ps_free_op+0x5f/0x84
[    0.030000]  [<ffffffff81afaaab>] acpi_ps_delete_parse_tree+0x62/0x10c
[    0.030000]  [<ffffffff81af99f3>] acpi_ps_complete_this_op+0x4dd/0x4f3
[    0.030000]  [<ffffffff81af8c67>] acpi_ps_complete_op+0x2f/0x461
[    0.030000]  [<ffffffff81af845d>] acpi_ps_parse_loop+0xd5a/0xdcb
[    0.030000]  [<ffffffff81af9ccd>] acpi_ps_parse_aml+0x167/0x6e6
[    0.030000]  [<ffffffff81aef51c>] acpi_ns_one_complete_parse+0x2ad/0x2da
[    0.030000]  [<ffffffff81aef570>] acpi_ns_parse_table+0x27/0x85
[    0.030000]  [<ffffffff81aee112>] acpi_ns_load_table+0xcb/0x171
[    0.030000]  [<ffffffff84d50199>] acpi_load_tables+0x137/0x2cb
[    0.030000]  [<ffffffff84d4dcd6>] acpi_early_init+0x149/0x295
[    0.030000]  [<ffffffff84cc9aad>] start_kernel+0x737/0x80f
[    0.030000]  [<ffffffff84cc8120>] ? early_idt_handlers+0x120/0x120
[    0.030000]  [<ffffffff84cc866c>] x86_64_start_reservations+0x64/0x6d
[    0.030000]  [<ffffffff84cc8862>] x86_64_start_kernel+0x1ed/0x203
[    0.030000] ---[ end trace 99ec80f6857ad667 ]---
[    0.030000] ------------[ cut here ]------------

git bisect start 1e7327cb22aa5bbd32c80399d05f7668ea5b6ad7 b2776bf7149bddd1f4161f14f79520f17fc1d71d --
git bisect  bad 0673f0768824bc10d94c12c74af0c48fe937f0de  # 16:00      0-     20  Merge 'clk/eas-next' into devel-lkp-nhm1-smoke-201412101539
git bisect good d6e8730ed98528a493522074b36ace58a95a9b97  # 16:13     20+     20  0day base guard for 'devel-lkp-nhm1-smoke-201412101539'
git bisect good c1a1272dcf10f1bea314226c76245604fbf91c87  # 16:22     20+     20  sched: updated comments of CLONE_NEWUTS and CLONE_NEWIPC
git bisect good 7c2684baf9042237fa3f72c9f230637911fe9b53  # 16:35     20+     20  sched: energy_model: simple cpu frequency scaling policy
git bisect good 123c1de3f5f485b44b1b84c50b40cbafe1e379d6  # 16:47     20+     20  sched: add ftrace for io latency tracking
git bisect  bad 318e8cc222050c8c542c7471224fe3ba1ac18062  # 16:53      1-     20  arm: Frequency invariant scheduler load-tracking support
git bisect good b9ed965defe8f8ee2e57e0a9372c70b883a4ea3f  # 17:11     20+     20  Merge remote-tracking branch 'eas-next/eas-next' into sched/cpuidle/eas-next
git bisect  bad 1fadb581b0be9420b143e43ff2f4a07ea7e45f6c  # 17:19      1-     20  sched: Make usage and load tracking cpu scale-invariant
git bisect good e754569101f392e1924d8ce6f087ea4cfad91d69  # 17:34     20+     20  sched: Make load tracking frequency scale-invariant
# first bad commit: [1fadb581b0be9420b143e43ff2f4a07ea7e45f6c] sched: Make usage and load tracking cpu scale-invariant
git bisect good e754569101f392e1924d8ce6f087ea4cfad91d69  # 17:38     60+     80  sched: Make load tracking frequency scale-invariant
# extra tests on HEAD of linux-devel/devel-lkp-nhm1-smoke-201412101539
git bisect  bad 1e7327cb22aa5bbd32c80399d05f7668ea5b6ad7  # 17:38      0-     14  0day head guard for 'devel-lkp-nhm1-smoke-201412101539'
# extra tests on tree/branch clk/eas-next
git bisect  bad 67cc03886394320689d30d65d65b386756d47e39  # 17:51      1-     11  sched: Include blocked load in weighted_cpuload
# extra tests on tree/branch linus/master
git bisect good 86c6a2fddf0b89b494c7616f2c06cf915c4bff01  # 17:57     60+     64  Merge branch 'sched-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
# extra tests on tree/branch next/master
git bisect good 12fd07251e19050ca979d9ce5d4b6bcb41dc00e9  # 18:09     60+     60  Add linux-next specific files for 20141210


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1

kvm=(
	qemu-system-x86_64
	-enable-kvm
	-cpu Haswell,+smep,+smap
	-kernel $kernel
	-m 320
	-smp 2
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

--48TaNjbzBVislYPb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-kbuild-7:20141210171614:x86_64-randconfig-n0-12101521:3.18.0-rc2-g1fadb58:507"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc2-g1fadb58 (kbuild@lkp-nhm1) (gcc ver=
sion 4.9.1 (Debian 4.9.1-19) ) #507 SMP PREEMPT Wed Dec 10 17:14:47 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-n0-12101521/linux-devel:devel-lkp-nhm1-smoke-201412101539:1fadb581b0be=
9420b143e43ff2f4a07ea7e45f6c:bisect-linux-0/.vmlinuz-1fadb581b0be9420b143e4=
3ff2f4a07ea7e45f6c-20141210171632-20-kbuild branch=3Dlinux-devel/devel-lkp-=
nhm1-smoke-201412101539 BOOT_IMAGE=3D/kernel/x86_64-randconfig-n0-12101521/=
1fadb581b0be9420b143e43ff2f4a07ea7e45f6c/vmlinuz-3.18.0-rc2-g1fadb58 drbd.m=
inor_count=3D8
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
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
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
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[ffff8800000fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x05956000, 0x05956fff] PGTABLE
[    0.000000] BRK [0x05957000, 0x05957fff] PGTABLE
[    0.000000] BRK [0x05958000, 0x05958fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
[    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x05959000, 0x05959fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE450 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE490 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF680 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF640 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] NODE_DATA(0) allocated [mem 0x1292a000-0x1293cfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880011a0000=
0-ffff880011ffffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 39 pages/cpu @ffff880012600000 s130752 r0 d=
28992 u1048576
[    0.000000] pcpu-alloc: s130752 r0 d28992 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1260db40
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-n0-12101521/linux-devel:devel-lkp-nhm1-smoke-201412101539:1fadb=
581b0be9420b143e43ff2f4a07ea7e45f6c:bisect-linux-0/.vmlinuz-1fadb581b0be942=
0b143e43ff2f4a07ea7e45f6c-20141210171632-20-kbuild branch=3Dlinux-devel/dev=
el-lkp-nhm1-smoke-201412101539 BOOT_IMAGE=3D/kernel/x86_64-randconfig-n0-12=
101521/1fadb581b0be9420b143e43ff2f4a07ea7e45f6c/vmlinuz-3.18.0-rc2-g1fadb58=
 drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standar=
d form
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 222240K/327280K available (30325K kernel code, 16684=
K rwdata, 14984K rodata, 1660K init, 11288K bss, 105040K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:440 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc2-g1fadb58 (kbuild@lkp-nhm1) (gcc ver=
sion 4.9.1 (Debian 4.9.1-19) ) #507 SMP PREEMPT Wed Dec 10 17:14:47 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-n0-12101521/linux-devel:devel-lkp-nhm1-smoke-201412101539:1fadb581b0be=
9420b143e43ff2f4a07ea7e45f6c:bisect-linux-0/.vmlinuz-1fadb581b0be9420b143e4=
3ff2f4a07ea7e45f6c-20141210171632-20-kbuild branch=3Dlinux-devel/devel-lkp-=
nhm1-smoke-201412101539 BOOT_IMAGE=3D/kernel/x86_64-randconfig-n0-12101521/=
1fadb581b0be9420b143e43ff2f4a07ea7e45f6c/vmlinuz-3.18.0-rc2-g1fadb58 drbd.m=
inor_count=3D8
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
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x400000000
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
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at =
[ffff8800000fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x05956000, 0x05956fff] PGTABLE
[    0.000000] BRK [0x05957000, 0x05957fff] PGTABLE
[    0.000000] BRK [0x05958000, 0x05958fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
[    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x05959000, 0x05959fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FFE450 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FFFF80 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FFE490 0011A9 (v01 BXPC   BXDSDT   00=
000001 INTL 20100528)
[    0.000000] ACPI: FACS 0x0000000013FFFF40 000040
[    0.000000] ACPI: SSDT 0x0000000013FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FFF680 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FFF640 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
[    0.000000] NODE_DATA(0) allocated [mem 0x1292a000-0x1293cfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880011a0000=
0-ffff880011ffffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 39 pages/cpu @ffff880012600000 s130752 r0 d=
28992 u1048576
[    0.000000] pcpu-alloc: s130752 r0 d28992 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1260db40
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-n0-12101521/linux-devel:devel-lkp-nhm1-smoke-201412101539:1fadb=
581b0be9420b143e43ff2f4a07ea7e45f6c:bisect-linux-0/.vmlinuz-1fadb581b0be942=
0b143e43ff2f4a07ea7e45f6c-20141210171632-20-kbuild branch=3Dlinux-devel/dev=
el-lkp-nhm1-smoke-201412101539 BOOT_IMAGE=3D/kernel/x86_64-randconfig-n0-12=
101521/1fadb581b0be9420b143e43ff2f4a07ea7e45f6c/vmlinuz-3.18.0-rc2-g1fadb58=
 drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standar=
d form
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 222240K/327280K available (30325K kernel code, 16684=
K rwdata, 14984K rodata, 1660K init, 11288K bss, 105040K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:440 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
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
[    0.000000]                     double unlock:failed|failed|failed|  ok =
 |failed|failed|
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
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
[    0.000000]                ww contexts mixing:failed|  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]            spinlock nest unlocked:failed|
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:failed|  ok  |  ok  |
[    0.000000]                               try:failed|  ok  |failed|
[    0.000000]                             block:failed|  ok  |failed|
[    0.000000]                          spinlock:failed|  ok  |failed|
[    0.000000] --------------------------------------------------------
[    0.000000] 153 out of 253 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.528 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5387.05 Bogo=
MIPS (lpj=3D26935280)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] ACPI: Core revision 20140926
[    0.020006] ------------[ cut here ]------------
[    0.021391] WARNING: CPU: 0 PID: 0 at arch/x86/kernel/cpu/common.c:1439 =
warn_pre_alternatives+0x2e/0x40()
[    0.024425] You're using static_cpu_has before alternatives have run!
[    0.026159] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.18.0-rc2-g1fadb5=
8 #507
[    0.028350] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.029899]  0000000000000009 ffff8800126039f8 ffffffff82d77315 ffff8800=
12603a48
[    0.030000]  0000000000000009 ffff880012603a38 ffffffff81105674 00000000=
00000000
[    0.030000]  0000000000000050 ffffffff83c7de40 0000000000000000 00000000=
00000060
[    0.030000] Call Trace:
[    0.030000]  <IRQ>  [<ffffffff82d77315>] dump_stack+0xc5/0x175
[    0.030000]  [<ffffffff81105674>] warn_slowpath_common+0xc4/0x100
[    0.030000]  [<ffffffff81105746>] warn_slowpath_fmt+0x56/0x60
[    0.030000]  [<ffffffff81034dde>] warn_pre_alternatives+0x2e/0x40
[    0.030000]  [<ffffffff81092831>] __do_page_fault+0x4f1/0x1060
[    0.030000]  [<ffffffff81093601>] trace_do_page_fault+0xe1/0x450
[    0.030000]  [<ffffffff8190042a>] ? trace_hardirqs_off_thunk+0x3a/0x3f
[    0.030000]  [<ffffffff81083a8f>] do_async_page_fault+0x3f/0x200
[    0.030000]  [<ffffffff82d9a898>] async_page_fault+0x28/0x30
[    0.030000]  [<ffffffff81179edd>] ? arch_scale_cpu_capacity+0xd/0x30
[    0.030000]  [<ffffffff81179f35>] ? contrib_scale_factor+0x35/0x50
[    0.030000]  [<ffffffff8117eff0>] task_tick_fair+0x2b0/0xe50
[    0.030000]  [<ffffffff81170062>] ? sched_clock_cpu+0x212/0x2e0
[    0.030000]  [<ffffffff8116551b>] scheduler_tick+0x7b/0xf0
[    0.030000]  [<ffffffff811ef834>] update_process_times+0xb4/0xe0
[    0.030000]  [<ffffffff8120b14f>] tick_periodic+0xcf/0xe0
[    0.030000]  [<ffffffff8120b762>] tick_handle_periodic+0x32/0x110
[    0.030000]  [<ffffffff8100df9d>] timer_interrupt+0x1d/0x30
[    0.030000]  [<ffffffff811bcec7>] handle_irq_event_percpu+0x147/0x670
[    0.030000]  [<ffffffff82d96a84>] ? _raw_spin_lock_irqsave+0xc4/0x170
[    0.030000]  [<ffffffff811bd441>] handle_irq_event+0x51/0x90
[    0.030000]  [<ffffffff811c4ada>] handle_level_irq+0x1ba/0x240
[    0.030000]  [<ffffffff8100cd1c>] handle_irq+0x7c/0xa0
[    0.030000]  [<ffffffff8100b9c9>] do_IRQ+0x69/0x190
[    0.030000]  [<ffffffff81aad401>] ? acpi_os_create_cache+0x11/0x64
[    0.030000]  [<ffffffff82d99832>] common_interrupt+0x72/0x72
[    0.030000]  <EOI>  [<ffffffff8102ce07>] ? save_stack_trace+0x37/0x90
[    0.030000]  [<ffffffff81084b7e>] ? native_restore_fl+0xe/0x20
[    0.030000]  [<ffffffff82d96f37>] _raw_spin_unlock_irqrestore+0xe7/0x150
[    0.030000]  [<ffffffff8137f6cc>] __slab_free+0xcc/0x6b0
[    0.030000]  [<ffffffff8137f853>] ? __slab_free+0x253/0x6b0
[    0.030000]  [<ffffffff8137e801>] ? __slab_alloc+0xdf1/0xf60
[    0.030000]  [<ffffffff813820eb>] kmem_cache_free+0x57b/0x630
[    0.030000]  [<ffffffff81aad4a9>] ? acpi_os_release_object+0x15/0x20
[    0.030000]  [<ffffffff81aad4a9>] acpi_os_release_object+0x15/0x20
[    0.030000]  [<ffffffff81afa9c9>] acpi_ps_free_op+0x5f/0x84
[    0.030000]  [<ffffffff81afaaab>] acpi_ps_delete_parse_tree+0x62/0x10c
[    0.030000]  [<ffffffff81af99f3>] acpi_ps_complete_this_op+0x4dd/0x4f3
[    0.030000]  [<ffffffff81af8c67>] acpi_ps_complete_op+0x2f/0x461
[    0.030000]  [<ffffffff81af845d>] acpi_ps_parse_loop+0xd5a/0xdcb
[    0.030000]  [<ffffffff81af9ccd>] acpi_ps_parse_aml+0x167/0x6e6
[    0.030000]  [<ffffffff81aef51c>] acpi_ns_one_complete_parse+0x2ad/0x2da
[    0.030000]  [<ffffffff81aef570>] acpi_ns_parse_table+0x27/0x85
[    0.030000]  [<ffffffff81aee112>] acpi_ns_load_table+0xcb/0x171
[    0.030000]  [<ffffffff84d50199>] acpi_load_tables+0x137/0x2cb
[    0.030000]  [<ffffffff84d4dcd6>] acpi_early_init+0x149/0x295
[    0.030000]  [<ffffffff84cc9aad>] start_kernel+0x737/0x80f
[    0.030000]  [<ffffffff84cc8120>] ? early_idt_handlers+0x120/0x120
[    0.030000]  [<ffffffff84cc866c>] x86_64_start_reservations+0x64/0x6d
[    0.030000]  [<ffffffff84cc8862>] x86_64_start_kernel+0x1ed/0x203
[    0.030000] ---[ end trace 99ec80f6857ad667 ]---
[    0.030000] ------------[ cut here ]------------
[    0.030000] WARNING: CPU: 0 PID: 0 at arch/x86/kernel/cpu/common.c:1439 =
warn_pre_alternatives+0x2e/0x40()
[    0.030000] You're using static_cpu_has before alternatives have run!
[    0.030000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W      3.18.=
0-rc2-g1fadb58 #507
[    0.030000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.030000]  0000000000000009 ffff8800126039f8 ffffffff82d77315 ffff8800=
12603a48
[    0.030000]  0000000000000009 ffff880012603a38 ffffffff81105674 00000000=
00000000
[    0.030000]  0000000000000050 ffffffff83c7de40 0000000000000000 00000000=
00000060
[    0.030000] Call Trace:
[    0.030000]  <IRQ>  [<ffffffff82d77315>] dump_stack+0xc5/0x175
[    0.030000]  [<ffffffff81105674>] warn_slowpath_common+0xc4/0x100
[    0.030000]  [<ffffffff81105746>] warn_slowpath_fmt+0x56/0x60
[    0.030000]  [<ffffffff81034dde>] warn_pre_alternatives+0x2e/0x40
[    0.030000]  [<ffffffff8109288b>] __do_page_fault+0x54b/0x1060
[    0.030000]  [<ffffffff81093601>] trace_do_page_fault+0xe1/0x450
[    0.030000]  [<ffffffff8190042a>] ? trace_hardirqs_off_thunk+0x3a/0x3f
[    0.030000]  [<ffffffff81083a8f>] do_async_page_fault+0x3f/0x200
[    0.030000]  [<ffffffff82d9a898>] async_page_fault+0x28/0x30
[    0.030000]  [<ffffffff81179edd>] ? arch_scale_cpu_capacity+0xd/0x30
[    0.030000]  [<ffffffff81179f35>] ? contrib_scale_factor+0x35/0x50
[    0.030000]  [<ffffffff8117eff0>] task_tick_fair+0x2b0/0xe50
[    0.030000]  [<ffffffff81170062>] ? sched_clock_cpu+0x212/0x2e0
[    0.030000]  [<ffffffff8116551b>] scheduler_tick+0x7b/0xf0
[    0.030000]  [<ffffffff811ef834>] update_process_times+0xb4/0xe0
[    0.030000]  [<ffffffff8120b14f>] tick_periodic+0xcf/0xe0
[    0.030000]  [<ffffffff8120b762>] tick_handle_periodic+0x32/0x110
[    0.030000]  [<ffffffff8100df9d>] timer_interrupt+0x1d/0x30
[    0.030000]  [<ffffffff811bcec7>] handle_irq_event_percpu+0x147/0x670
[    0.030000]  [<ffffffff82d96a84>] ? _raw_spin_lock_irqsave+0xc4/0x170
[    0.030000]  [<ffffffff811bd441>] handle_irq_event+0x51/0x90
[    0.030000]  [<ffffffff811c4ada>] handle_level_irq+0x1ba/0x240
[    0.030000]  [<ffffffff8100cd1c>] handle_irq+0x7c/0xa0
[    0.030000]  [<ffffffff8100b9c9>] do_IRQ+0x69/0x190
[    0.030000]  [<ffffffff81aad401>] ? acpi_os_create_cache+0x11/0x64
[    0.030000]  [<ffffffff82d99832>] common_interrupt+0x72/0x72
[    0.030000]  <EOI>  [<ffffffff8102ce07>] ? save_stack_trace+0x37/0x90
[    0.030000]  [<ffffffff81084b7e>] ? native_restore_fl+0xe/0x20
[    0.030000]  [<ffffffff82d96f37>] _raw_spin_unlock_irqrestore+0xe7/0x150
[    0.030000]  [<ffffffff8137f6cc>] __slab_free+0xcc/0x6b0
[    0.030000]  [<ffffffff8137f853>] ? __slab_free+0x253/0x6b0
[    0.030000]  [<ffffffff8137e801>] ? __slab_alloc+0xdf1/0xf60
[    0.030000]  [<ffffffff813820eb>] kmem_cache_free+0x57b/0x630
[    0.030000]  [<ffffffff81aad4a9>] ? acpi_os_release_object+0x15/0x20
[    0.030000]  [<ffffffff81aad4a9>] acpi_os_release_object+0x15/0x20
[    0.030000]  [<ffffffff81afa9c9>] acpi_ps_free_op+0x5f/0x84
[    0.030000]  [<ffffffff81afaaab>] acpi_ps_delete_parse_tree+0x62/0x10c
[    0.030000]  [<ffffffff81af99f3>] acpi_ps_complete_this_op+0x4dd/0x4f3
[    0.030000]  [<ffffffff81af8c67>] acpi_ps_complete_op+0x2f/0x461
[    0.030000]  [<ffffffff81af845d>] acpi_ps_parse_loop+0xd5a/0xdcb
[    0.030000]  [<ffffffff81af9ccd>] acpi_ps_parse_aml+0x167/0x6e6
[    0.030000]  [<ffffffff81aef51c>] acpi_ns_one_complete_parse+0x2ad/0x2da
[    0.030000]  [<ffffffff81aef570>] acpi_ns_parse_table+0x27/0x85
[    0.030000]  [<ffffffff81aee112>] acpi_ns_load_table+0xcb/0x171
[    0.030000]  [<ffffffff84d50199>] acpi_load_tables+0x137/0x2cb
[    0.030000]  [<ffffffff84d4dcd6>] acpi_early_init+0x149/0x295
[    0.030000]  [<ffffffff84cc9aad>] start_kernel+0x737/0x80f
[    0.030000]  [<ffffffff84cc8120>] ? early_idt_handlers+0x120/0x120
[    0.030000]  [<ffffffff84cc866c>] x86_64_start_reservations+0x64/0x6d
[    0.030000]  [<ffffffff84cc8862>] x86_64_start_kernel+0x1ed/0x203
[    0.030000] ---[ end trace 99ec80f6857ad668 ]---
[    0.030000] BUG: unable to handle kernel NULL pointer dereference at 000=
0000000000050
[    0.030000] IP: [<ffffffff81179edd>] arch_scale_cpu_capacity+0xd/0x30
[    0.030000] PGD 0=20
[    0.030000] Oops: 0000 [#1] PREEMPT SMP=20
[    0.030000] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W      3.18.=
0-rc2-g1fadb58 #507
[    0.030000] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.030000] task: ffffffff83c7de40 ti: ffffffff83c5c000 task.ti: fffffff=
f83c5c000
[    0.030000] RIP: 0010:[<ffffffff81179edd>]  [<ffffffff81179edd>] arch_sc=
ale_cpu_capacity+0xd/0x30
[    0.030000] RSP: 0000:ffff880012603cf8  EFLAGS: 00010046
[    0.030000] RAX: 0000000000000400 RBX: 0000000000000400 RCX: 00000000000=
00000
[    0.030000] RDX: 0000000000000120 RSI: 0000000000000000 RDI: 00000000000=
00000
[    0.030000] RBP: ffff880012603d18 R08: 0000000000000001 R09: 00000000000=
04c4b
[    0.030000] R10: 0000003b9aca0000 R11: 0000000000000001 R12: 00000000000=
00000
[    0.030000] R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff83c=
7dea8
[    0.030000] FS:  0000000000000000(0000) GS:ffff880012600000(0000) knlGS:=
0000000000000000
[    0.030000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.030000] CR2: 0000000000000050 CR3: 0000000003c76000 CR4: 00000000000=
406b0
[    0.030000] Stack:
[    0.030000]  ffff880012603d18 ffffffff81179f35 ffff88001261f278 ffff8800=
1261f278
[    0.030000]  ffff880012603dc8 ffffffff8117eff0 ffff880012603d48 00000000=
00000002
[    0.030000]  ffff88001261fc40 000000000001fc40 0000000000000000 00000000=
00000000
[    0.030000] Call Trace:
[    0.030000]  <IRQ>=20
[    0.030000]  [<ffffffff81179f35>] ? contrib_scale_factor+0x35/0x50
[    0.030000]  [<ffffffff8117eff0>] task_tick_fair+0x2b0/0xe50
[    0.030000]  [<ffffffff81170062>] ? sched_clock_cpu+0x212/0x2e0
[    0.030000]  [<ffffffff8116551b>] scheduler_tick+0x7b/0xf0
[    0.030000]  [<ffffffff811ef834>] update_process_times+0xb4/0xe0
[    0.030000]  [<ffffffff8120b14f>] tick_periodic+0xcf/0xe0
[    0.030000]  [<ffffffff8120b762>] tick_handle_periodic+0x32/0x110
[    0.030000]  [<ffffffff8100df9d>] timer_interrupt+0x1d/0x30
[    0.030000]  [<ffffffff811bcec7>] handle_irq_event_percpu+0x147/0x670
[    0.030000]  [<ffffffff82d96a84>] ? _raw_spin_lock_irqsave+0xc4/0x170
[    0.030000]  [<ffffffff811bd441>] handle_irq_event+0x51/0x90
[    0.030000]  [<ffffffff811c4ada>] handle_level_irq+0x1ba/0x240
[    0.030000]  [<ffffffff8100cd1c>] handle_irq+0x7c/0xa0
[    0.030000]  [<ffffffff8100b9c9>] do_IRQ+0x69/0x190
[    0.030000]  [<ffffffff81aad401>] ? acpi_os_create_cache+0x11/0x64
[    0.030000]  [<ffffffff82d99832>] common_interrupt+0x72/0x72
[    0.030000]  <EOI>=20
[    0.030000]  [<ffffffff8102ce07>] ? save_stack_trace+0x37/0x90
[    0.030000]  [<ffffffff81084b7e>] ? native_restore_fl+0xe/0x20
[    0.030000]  [<ffffffff82d96f37>] _raw_spin_unlock_irqrestore+0xe7/0x150
[    0.030000]  [<ffffffff8137f6cc>] __slab_free+0xcc/0x6b0
[    0.030000]  [<ffffffff8137f853>] ? __slab_free+0x253/0x6b0
[    0.030000]  [<ffffffff8137e801>] ? __slab_alloc+0xdf1/0xf60
[    0.030000]  [<ffffffff813820eb>] kmem_cache_free+0x57b/0x630
[    0.030000]  [<ffffffff81aad4a9>] ? acpi_os_release_object+0x15/0x20
[    0.030000]  [<ffffffff81aad4a9>] acpi_os_release_object+0x15/0x20
[    0.030000]  [<ffffffff81afa9c9>] acpi_ps_free_op+0x5f/0x84
[    0.030000]  [<ffffffff81afaaab>] acpi_ps_delete_parse_tree+0x62/0x10c
[    0.030000]  [<ffffffff81af99f3>] acpi_ps_complete_this_op+0x4dd/0x4f3
[    0.030000]  [<ffffffff81af8c67>] acpi_ps_complete_op+0x2f/0x461
[    0.030000]  [<ffffffff81af845d>] acpi_ps_parse_loop+0xd5a/0xdcb
[    0.030000]  [<ffffffff81af9ccd>] acpi_ps_parse_aml+0x167/0x6e6
[    0.030000]  [<ffffffff81aef51c>] acpi_ns_one_complete_parse+0x2ad/0x2da
[    0.030000]  [<ffffffff81aef570>] acpi_ns_parse_table+0x27/0x85
[    0.030000]  [<ffffffff81aee112>] acpi_ns_load_table+0xcb/0x171
[    0.030000]  [<ffffffff84d50199>] acpi_load_tables+0x137/0x2cb
[    0.030000]  [<ffffffff84d4dcd6>] acpi_early_init+0x149/0x295
[    0.030000]  [<ffffffff84cc9aad>] start_kernel+0x737/0x80f
[    0.030000]  [<ffffffff84cc8120>] ? early_idt_handlers+0x120/0x120
[    0.030000]  [<ffffffff84cc866c>] x86_64_start_reservations+0x64/0x6d
[    0.030000]  [<ffffffff84cc8862>] x86_64_start_kernel+0x1ed/0x203
[    0.030000] Code: 0d c2 01 55 b8 00 04 00 00 48 83 05 c5 45 d9 03 01 48 =
89 e5 5d c3 0f 1f 84 00 00 00 00 00 e8 9b 0d c2 01 55 48 8d 97 20 01 00 00 =
<8b> 77 50 8b 7f 48 48 83 05 a5 45 d9 03 01 48 89 e5 e8 6d 9d ff=20
[    0.030000] RIP  [<ffffffff81179edd>] arch_scale_cpu_capacity+0xd/0x30
[    0.030000]  RSP <ffff880012603cf8>
[    0.030000] CR2: 0000000000000050
[    0.030000] ---[ end trace 99ec80f6857ad669 ]---
[    0.030000] Kernel panic - not syncing: Fatal exception in interrupt

Elapsed time: 10
qemu-system-x86_64 -enable-kvm -cpu Haswell,+smep,+smap -kernel /kernel/x86=
_64-randconfig-n0-12101521/1fadb581b0be9420b143e43ff2f4a07ea7e45f6c/vmlinuz=
-3.18.0-rc2-g1fadb58 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,11520=
0 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D=
100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_=
ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3D=
normal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randc=
onfig-n0-12101521/linux-devel:devel-lkp-nhm1-smoke-201412101539:1fadb581b0b=
e9420b143e43ff2f4a07ea7e45f6c:bisect-linux-0/.vmlinuz-1fadb581b0be9420b143e=
43ff2f4a07ea7e45f6c-20141210171632-20-kbuild branch=3Dlinux-devel/devel-lkp=
-nhm1-smoke-201412101539 BOOT_IMAGE=3D/kernel/x86_64-randconfig-n0-12101521=
/1fadb581b0be9420b143e43ff2f4a07ea7e45f6c/vmlinuz-3.18.0-rc2-g1fadb58 drbd.=
minor_count=3D8'  -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz -m 3=
20 -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3D=
nc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kb=
oot/pid-quantal-kbuild-7 -serial file:/dev/shm/kboot/serial-quantal-kbuild-=
7 -daemonize -display none -monitor null=20

--48TaNjbzBVislYPb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-client1-11:20141210173336:x86_64-randconfig-n0-12101521:3.18.0-rc2-ge754569:509"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc2-ge754569 (kbuild@lkp-nhm1) (gcc ver=
sion 4.9.1 (Debian 4.9.1-19) ) #509 SMP PREEMPT Wed Dec 10 17:26:00 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-n0-12101521/linux-devel:devel-lkp-nhm1-smoke-201412101539:e754569101f3=
92e1924d8ce6f087ea4cfad91d69:bisect-linux-0/.vmlinuz-e754569101f392e1924d8c=
e6f087ea4cfad91d69-20141210172745-8-client1 branch=3Dlinux-devel/devel-lkp-=
nhm1-smoke-201412101539 BOOT_IMAGE=3D/kernel/x86_64-randconfig-n0-12101521/=
e754569101f392e1924d8ce6f087ea4cfad91d69/vmlinuz-3.18.0-rc2-ge754569 drbd.m=
inor_count=3D8
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
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-2014=
0531_083030-gandalf 04/01/2014
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x400000000
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at =
[ffff8800000f0eb0]
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x05956000, 0x05956fff] PGTABLE
[    0.000000] BRK [0x05957000, 0x05957fff] PGTABLE
[    0.000000] BRK [0x05958000, 0x05958fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13fdffff]
[    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13fdffff] page 4k
[    0.000000] BRK [0x05959000, 0x05959fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x12925000-0x13fd7fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0C90 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FE18BD 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FE0B37 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FE0000 000040
[    0.000000] ACPI: SSDT 0x0000000013FE0BAB 000C5A (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FE1805 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FE1885 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013fdffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x12912000-0x12924fff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13fdf001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880011a0000=
0-ffff880011ffffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77792 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 39 pages/cpu @ffff880012600000 s130752 r0 d=
28992 u1048576
[    0.000000] pcpu-alloc: s130752 r0 d28992 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1260db40
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80489
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-n0-12101521/linux-devel:devel-lkp-nhm1-smoke-201412101539:e7545=
69101f392e1924d8ce6f087ea4cfad91d69:bisect-linux-0/.vmlinuz-e754569101f392e=
1924d8ce6f087ea4cfad91d69-20141210172745-8-client1 branch=3Dlinux-devel/dev=
el-lkp-nhm1-smoke-201412101539 BOOT_IMAGE=3D/kernel/x86_64-randconfig-n0-12=
101521/e754569101f392e1924d8ce6f087ea4cfad91d69/vmlinuz-3.18.0-rc2-ge754569=
 drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 222120K/327160K available (30325K kernel code, 16684=
K rwdata, 14984K rodata, 1660K init, 11288K bss, 105040K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:440 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc2-ge754569 (kbuild@lkp-nhm1) (gcc ver=
sion 4.9.1 (Debian 4.9.1-19) ) #509 SMP PREEMPT Wed Dec 10 17:26:00 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_r=
amdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randco=
nfig-n0-12101521/linux-devel:devel-lkp-nhm1-smoke-201412101539:e754569101f3=
92e1924d8ce6f087ea4cfad91d69:bisect-linux-0/.vmlinuz-e754569101f392e1924d8c=
e6f087ea4cfad91d69-20141210172745-8-client1 branch=3Dlinux-devel/devel-lkp-=
nhm1-smoke-201412101539 BOOT_IMAGE=3D/kernel/x86_64-randconfig-n0-12101521/=
e754569101f392e1924d8ce6f087ea4cfad91d69/vmlinuz-3.18.0-rc2-ge754569 drbd.m=
inor_count=3D8
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
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-2014=
0531_083030-gandalf 04/01/2014
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x400000000
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
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at =
[ffff8800000f0eb0]
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x05956000, 0x05956fff] PGTABLE
[    0.000000] BRK [0x05957000, 0x05957fff] PGTABLE
[    0.000000] BRK [0x05958000, 0x05958fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
[    0.000000]  [mem 0x12600000-0x127fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12800000-0x13fdffff]
[    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13fdffff] page 4k
[    0.000000] BRK [0x05959000, 0x05959fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x12925000-0x13fd7fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0C90 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0000000013FE18BD 000034 (v01 BOCHS  BXPCRSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x0000000013FE0B37 000074 (v01 BOCHS  BXPCFACP 00=
000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x0000000013FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x0000000013FE0000 000040
[    0.000000] ACPI: SSDT 0x0000000013FE0BAB 000C5A (v01 BOCHS  BXPCSSDT 00=
000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x0000000013FE1805 000080 (v01 BOCHS  BXPCAPIC 00=
000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x0000000013FE1885 000038 (v01 BOCHS  BXPCHPET 00=
000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013fdffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x12912000-0x12924fff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13fdf001, primary cpu clock
[    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880011a0000=
0-ffff880011ffffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1216 pages used for memmap
[    0.000000]   DMA32 zone: 77792 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 39 pages/cpu @ffff880012600000 s130752 r0 d=
28992 u1048576
[    0.000000] pcpu-alloc: s130752 r0 d28992 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1260db40
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 80489
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64=
-randconfig-n0-12101521/linux-devel:devel-lkp-nhm1-smoke-201412101539:e7545=
69101f392e1924d8ce6f087ea4cfad91d69:bisect-linux-0/.vmlinuz-e754569101f392e=
1924d8ce6f087ea4cfad91d69-20141210172745-8-client1 branch=3Dlinux-devel/dev=
el-lkp-nhm1-smoke-201412101539 BOOT_IMAGE=3D/kernel/x86_64-randconfig-n0-12=
101521/e754569101f392e1924d8ce6f087ea4cfad91d69/vmlinuz-3.18.0-rc2-ge754569=
 drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 222120K/327160K available (30325K kernel code, 16684=
K rwdata, 14984K rodata, 1660K init, 11288K bss, 105040K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:440 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
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
[    0.000000]                     double unlock:failed|failed|failed|  ok =
 |failed|failed|
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
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
[    0.000000]                ww contexts mixing:failed|  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]            spinlock nest unlocked:failed|
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:failed|  ok  |  ok  |
[    0.000000]                               try:failed|  ok  |failed|
[    0.000000]                             block:failed|  ok  |failed|
[    0.000000]                          spinlock:failed|  ok  |failed|
[    0.000000] --------------------------------------------------------
[    0.000000] 153 out of 253 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2992.588 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value.. 5985.17 Bogo=
MIPS (lpj=3D29925880)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] ACPI: Core revision 20140926
[    0.090318] ACPI: All ACPI Tables successfully acquired
[    0.092597] Dentry cache hash table entries: 65536 (order: 7, 524288 byt=
es)
[    0.094780] Inode-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.096766] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.099583] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 by=
tes)
[    0.101851] Initializing cgroup subsys debug
[    0.103348] numa_add_cpu cpu 0 node 0: mask now 0
[    0.104699] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.104699] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.108254] Freeing SMP alternatives memory: 32K (ffffffff84e47000 - fff=
fffff84e4f000)
[    0.115234] Getting VERSION: 1050014
[    0.116587] Getting VERSION: 1050014
[    0.117725] Getting ID: 0
[    0.120027] Getting ID: ff000000
[    0.121099] Getting LVT0: 8700
[    0.122130] Getting LVT1: 8400
[    0.123231] enabled ExtINT on CPU#0
[    0.125290] ENABLING IO-APIC IRQs
[    0.126398] init IO_APIC IRQs
[    0.127415]  apic 0 pin 0 not connected
[    0.128691] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.130053] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.132375] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.134702] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.138147] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.140047] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.142363] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.144693] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.147069] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.150058] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.152370] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.154716] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.157239] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.160047] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.162411] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.164773] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.167142]  apic 0 pin 16 not connected
[    0.168335]  apic 0 pin 17 not connected
[    0.170006]  apic 0 pin 18 not connected
[    0.171195]  apic 0 pin 19 not connected
[    0.172383]  apic 0 pin 20 not connected
[    0.173568]  apic 0 pin 21 not connected
[    0.174759]  apic 0 pin 22 not connected
[    0.175958]  apic 0 pin 23 not connected
[    0.177313] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.180006] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.187399] Using local APIC timer interrupts.
[    0.187399] calibrating APIC timer ...
[    0.200000] ... lapic delta =3D 6249974
[    0.200000] ... PM-Timer delta =3D 358011
[    0.200000] ... PM-Timer result ok
[    0.200000] ..... delta 6249974
[    0.200000] ..... mult: 268434339
[    0.200000] ..... calibration result: 9999958
[    0.200000] ..... CPU clock speed is 2993.0522 MHz.
[    0.200000] ..... host bus clock speed is 999.9958 MHz.
[    0.200208] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.240322] Testing tracer nop: PASSED
[    0.260016] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.280887] x86: Booting SMP configuration:
[    0.282266] .... node  #0, CPUs:      #1
[    0.262064] kvm-clock: cpu 1, msr 0:13fdf041, secondary cpu clock
[    0.262064] masked ExtINT on CPU#1
[    0.262064] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.300000] TSC synchronization [CPU#0 -> CPU#1]:
[    0.300000] Measured 159 cycles TSC warp between CPUs, turning off TSC c=
lock.
[    0.300000] tsc: Marking TSC unstable due to check_tsc_sync_source failed
[    0.300494] x86: Booted up 1 node, 2 CPUs
[    0.300440] KVM setup async PF for cpu 1
[    0.300440] kvm-stealtime: cpu 1, msr 1270db40
[    0.304438] smpboot: Total of 2 processors activated (11970.35 BogoMIPS)
[    0.314202] gcov: version magic: 0x3430392a
[    0.350064] Testing tracer function: PASSED
[    0.514476] Testing ftrace regs(no arch support): PASSED
[    0.580058] Testing tracer irqsoff: PASSED
[    0.674259] xor: measuring software checksum speed
[    0.770019]    prefetch64-sse: 10201.600 MB/sec
[    0.870008]    generic_sse:  9280.000 MB/sec
[    0.871266] xor: using function: prefetch64-sse (10201.600 MB/sec)
[    0.874887] regulator-dummy: no parameters
[    0.876480] RTC time: 17:29:24, date: 12/10/14
[    0.878762] NET: Registered protocol family 16
[    0.890046] cpuidle: using governor ladder
[    0.900029] cpuidle: using governor menu
[    0.910028] cpuidle: using governor select
[    0.912294] ACPI: bus type PCI registered
[    0.914583] PCI: Using configuration type 1 for base access
[    1.080233] Running resizable hashtable tests...
[    1.081629]   Adding 2048 keys
[    1.343822]   Traversal complete: counted=3D2048, nelems=3D2048, entries=
=3D2048
[    1.345897]   Table expansion iteration 0...
[    1.370065]   Verifying lookups...
[    1.371442]   Table expansion iteration 1...
[    1.410080]   Verifying lookups...
[    1.411372]   Table expansion iteration 2...
[    1.440129]   Verifying lookups...
[    1.441390]   Table expansion iteration 3...
[    1.470231]   Verifying lookups...
[    1.471503]   Table shrinkage iteration 0...
[    1.480036]   Verifying lookups...
[    1.481295]   Table shrinkage iteration 1...
[    1.490032]   Verifying lookups...
[    1.491297]   Table shrinkage iteration 2...
[    1.500029]   Verifying lookups...
[    1.501302]   Table shrinkage iteration 3...
[    1.510028]   Verifying lookups...
[    1.511321]   Deleting 2048 keys
[    1.780036] raid6: sse2x1    1579 MB/s
[    1.950041] raid6: sse2x2    1841 MB/s
[    2.120026] raid6: sse2x4    1776 MB/s
[    2.121213] raid6: using algorithm sse2x2 (1841 MB/s)
[    2.122609] raid6: using intx1 recovery algorithm
[    2.124302] gpio-f7188x: Not a Fintek device at 0x0000002e
[    2.125837] gpio-f7188x: Not a Fintek device at 0x0000004e
[    2.129840] ACPI: Added _OSI(Module Device)
[    2.130029] ACPI: Added _OSI(Processor Device)
[    2.131394] ACPI: Added _OSI(3.0 _SCP Extensions)
[    2.132785] ACPI: Added _OSI(Processor Aggregator Device)
[    2.136465] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:3)
[    2.165107] ACPI: Interpreter enabled
[    2.166319] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140926/hwxface-580)
[    2.169136] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140926/hwxface-580)
[    2.172014] ACPI: (supports S0 S3 S5)
[    2.173145] ACPI: Using IOAPIC for interrupt routing
[    2.174875] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    2.298970] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    2.300060] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments]
[    2.301882] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    2.309345] PCI host bridge to bus 0000:00
[    2.310034] pci_bus 0000:00: root bus resource [bus 00-ff]
[    2.311524] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    2.313143] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    2.314763] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    2.316411] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    2.318030] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    2.320032] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    2.321786] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    2.323604] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    2.330305] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    2.335887] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    2.339964] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    2.340971] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    2.342751] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    2.344434] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    2.346289] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    2.352834] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    2.355035] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    2.357230] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    2.362630] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    2.366589] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    2.369548] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    2.375442] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    2.382693] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    2.385158] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    2.387663] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    2.393365] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    2.398757] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    2.400508] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    2.420534] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    2.425129] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    2.429725] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    2.433629] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    2.436770] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    2.447894] ACPI: Enabled 16 GPEs in block 00 to 0F
[    2.456057] vgaarb: setting as boot device: PCI:0000:00:02.0
[    2.457775] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    2.460021] vgaarb: loaded
[    2.460970] vgaarb: bridge control possible 0000:00:02.0
[    2.466022] SCSI subsystem initialized
[    2.471207] pps_core: LinuxPPS API ver. 1 registered
[    2.472641] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    2.475574] wmi: Mapper loaded
[    2.475574] Advanced Linux Sound Architecture Driver Initialized.
[    2.480290] PCI: Using ACPI for IRQ routing
[    2.481534] PCI: pci_cache_line_size set to 64 bytes
[    2.483084] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    2.484672] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    2.491315] Switched to clocksource kvm-clock
[    2.493982] Warning: could not register all branches stats
[    2.495487] Warning: could not register annotated branches stats
[    2.568182] FS-Cache: Loaded
[    2.569867] CacheFiles: Loaded
[    2.571284] pnp: PnP ACPI init
[    2.573060] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    2.576143] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    2.578284] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    2.581182] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    2.583265] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    2.586231] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    2.588724] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    2.592192] pnp 00:03: [dma 2]
[    2.593995] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    2.596651] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    2.599568] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    2.602076] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    2.604986] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    2.614879] pnp: PnP ACPI: found 6 devices
[    2.666076] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.667588] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    2.669076] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    2.670591] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    2.672077] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    2.673601] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    2.675218] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    2.677002] NET: Registered protocol family 1
[    2.678354] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    2.679921] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    2.681492] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    2.683127] pci 0000:00:02.0: Video device with shadowed ROM
[    2.684674] PCI: CLS 0 bytes, default 64
[    2.686517] Trying to unpack rootfs image as initramfs...
[    4.058382] Freeing initrd memory: 23244K (ffff880012925000 - ffff880013=
fd8000)
[    4.067477] des3_ede-x86_64: performance on this CPU would be suboptimal=
: disabling des3_ede-x86_64.
[    4.074236] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    4.077253] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    4.087940] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/usab=
le.
[    4.089745] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    4.091558] AVX instructions are not detected.
[    4.092846] AVX instructions are not detected.
[    4.094136] AVX instructions are not detected.
[    4.095430] AVX2 instructions are not detected.
[    4.096953] spin_lock-torture:--- Start of test: nwriters_stress=3D4 nre=
aders_stress=3D0 stat_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutte=
r=3D5 shutdown_secs=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    4.101260] spin_lock-torture: Creating torture_shuffle task
[    4.103163] spin_lock-torture: Creating torture_stutter task
[    4.103248] spin_lock-torture: torture_shuffle task started
[    4.106545] spin_lock-torture: Creating lock_torture_writer task
[    4.106623] spin_lock-torture: torture_stutter task started
[    4.110006] spin_lock-torture: Creating lock_torture_writer task
[    4.110153] spin_lock-torture: lock_torture_writer task started
[    4.110330] spin_lock-torture: Creating lock_torture_writer task
[    4.110407] spin_lock-torture: lock_torture_writer task started
[    4.117201] spin_lock-torture: Creating lock_torture_writer task
[    4.118417] spin_lock-torture: lock_torture_writer task started
[    4.120959] spin_lock-torture: Creating lock_torture_stats task
[    4.121034] spin_lock-torture: lock_torture_writer task started
[    4.124609] spin_lock-torture: lock_torture_stats task started
[    4.131029] futex hash table entries: 512 (order: 3, 32768 bytes)
[    5.889662] zpool: loaded
[    5.918601] ntfs: driver 2.1.31 [Flags: R/O].
[    5.924499] fuse init (API version 7.23)
[    5.933147] NILFS version 2 loaded
[    5.968446] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    5.970810] io scheduler noop registered
[    5.973121] io scheduler deadline registered (default)
[    5.976491] io scheduler cfq registered
[    5.977725] start plist test
[    5.984572] end plist test
[    5.991961] test_string_helpers: Running tests...
[    5.998917] test_firmware: interface ready
[    6.001582] crc32: CRC_LE_BITS =3D 8, CRC_BE BITS =3D 8
[    6.002950] crc32: self tests passed, processed 225944 bytes in 709302 n=
sec
[    6.005338] crc32c: CRC_LE_BITS =3D 8
[    6.006448] crc32c: self tests passed, processed 225944 bytes in 329885 =
nsec
[    6.060243] crc32_combine: 8373 self tests passed
[    6.100944] crc32c_combine: 8373 self tests passed
[    6.102685] xz_dec_test: module loaded
[    6.103839] xz_dec_test: Create a device node with 'mknod xz_dec_test c =
249 0' and write .xz files to it.
[    6.106701] rbtree testing -> 57688 cycles
[    8.134904] augmented rbtree testing -> 70764 cycles
[   10.643872] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   10.645462] cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
[   10.647448] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver =
version: 0.1
[   10.649692] cpcihp_generic: not configured, disabling.
[   10.654767] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[   10.656291] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[   10.660247] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[   10.664042] vmlfb: initializing
[   10.665699] no IO addresses supplied
[   10.668266] ipmi message handler version 39.2
[   10.669760] IPMI System Interface driver.
[   10.671387] ipmi_si: Adding default-specified kcs state machine
[   10.673086] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[   10.675778] ipmi_si: Interface detection failed
[   10.680171] ipmi_si: Adding default-specified smic state machine
[   10.681915] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[   10.686634] ipmi_si: Interface detection failed
[   10.690145] ipmi_si: Adding default-specified bt state machine
[   10.691829] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[   10.694893] ipmi_si: Interface detection failed
[   10.710518] ipmi_si: Unable to find any System Interface(s)
[   10.714089] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   10.716730] ACPI: Power Button [PWRF]
[   10.742291] r3964: Philips r3964 Driver $Revision: 1.10 $
[   10.744315] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   10.771842] serial 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 1=
15200) is a 16550A
[   10.783603] serial: Freescale lpuart driver
[   10.785520] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[   10.787700] ac.o: No PCI boards found.
[   10.788866] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[   10.791663] Non-volatile memory driver v1.3
[   10.793207] smapi::smapi_init, ERROR invalid usSmapiID
[   10.794719] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[   10.797639] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[   10.800379] mwave: mwavedd::mwave_init: Error: Failed to initialize
[   10.802038] Linux agpgart interface v0.103
[   10.819958] [drm] Initialized drm 1.1.0 20060810
[   10.822191] [drm] radeon kernel modesetting enabled.
[   10.882514] brd: module loaded
[   10.907436] loop: module loaded
[   10.908529] HP CISS Driver (v 3.6.26)
[   10.912789] skd:  v2.2.1-b0260 loaded
[   10.914369] MM: desc_per_page =3D 128
[   10.916334] mtip32xx Version 1.3.1
[   10.923579]  nullb0: unknown partition table
[   10.929148]  nullb1: unknown partition table
[   10.932034] null: module loaded
[   10.934503] Phantom Linux Driver, version n0.9.8, init OK
[   10.938196] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[   10.942969] Guest personality initialized and is inactive
[   10.945383] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D59)
[   10.947098] Initialized host personality
[   10.949168] mic_init not running on X100 ret -19
[   10.957000] rdac: device handler registered
[   10.958987] hp_sw: device handler registered
[   10.960322] emc: device handler registered
[   10.961590] alua: device handler registered
[   10.963573] Adaptec aacraid driver 1.2-0[30300]-ms
[   10.965825] isci: Intel(R) C600 SAS Controller Driver - version 1.2.0
[   10.968096] scsi: <fdomain> Detection failed (no card)
[   10.970636] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 ES=
T 2006)
[   10.973749] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 20=
06)
[   10.976135] megasas: 06.805.06.00-rc1 Thu. Sep. 4 17:00:00 PDT 2014
[   10.978138] mpt2sas version 18.100.00.00 loaded
[   10.980484] mpt3sas version 04.100.00.00 loaded
[   10.983675] 3ware Storage Controller device driver for Linux v1.26.02.00=
3.
[   10.985964] 3ware 9000 Storage Controller device driver for Linux v2.26.=
02.014.
[   10.988415] LSI 3ware SAS/SATA-RAID Controller device driver for Linux v=
3.26.02.000.
[   10.991309] stex: Promise SuperTrak EX Driver version: 4.6.0000.4
[   10.993416] esas2r: driver will not be loaded because no ATTO esas2r dev=
ices were found
[   10.997551] VMware PVSCSI driver - version 1.0.5.0-k
[   10.999601] osst :I: Tape driver with OnStream support version 0.99.4
[   10.999601] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[   11.034005] scsi_debug: host protection
[   11.035238] scsi host0: scsi_debug, version 1.84 [20140706], dev_size_mb=
=3D8, opts=3D0x0
[   11.053071] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       01=
84 PQ: 0 ANSI: 6
[   11.069710] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   11.082440] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[   11.090852] HSI/SSI char device loaded
[   11.092521] Fusion MPT base driver 3.04.20
[   11.093814] Copyright (c) 1999-2008 LSI Corporation
[   11.095438] Fusion MPT SPI Host driver 3.04.20
[   11.097345] Fusion MPT SAS Host driver 3.04.20
[   11.098866] Fusion MPT misc device (ioctl) driver 3.04.20
[   11.100108] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.=
00 MiB)
[   11.105372] mptctl: Registered with Fusion MPT base driver
[   11.106939] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[   11.110285] sd 0:0:0:0: [sda] Write Protect is off
[   11.111665] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[   11.112342] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   11.135419] serio: i8042 KBD port at 0x60,0x64 irq 1
[   11.137695] serio: i8042 AUX port at 0x60,0x64 irq 12
[   11.148359] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[   11.220107]  sda: unknown partition table
[   11.229933] mousedev: PS/2 mouse device common for all mice
[   11.234621] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   11.243311] rtc_cmos 00:00: RTC can wake from S4
[   11.246347] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[   11.248347] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[   11.260811] i2c-parport-light: adapter type unspecified
[   11.264080] pps pps0: new PPS source ktimer
[   11.265338] pps pps0: ktimer PPS source registered
[   11.266697] pps_ldisc: PPS line discipline registered
[   11.269356] Driver for 1-wire Dallas network protocol.
[   11.270250] sd 0:0:0:0: [sda] Attached SCSI disk
[   11.273144] 1-Wire driver for the DS2760 battery monitor chip - (c) 2004=
-2005, Szabolcs Gyurko
[   11.280460] applesmc: supported laptop not found!
[   11.286064] applesmc: driver init failed (ret=3D-19)!
[   11.299057] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[   11.302020] acquirewdt: I/O address 0x0043 already in use
[   11.303551] acquirewdt: probe of acquirewdt failed with error -5
[   11.305516] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[   11.309070] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D1)
[   11.310806] alim7101_wdt: Steve Hill <steve@navaho.co.uk>
[   11.312291] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[   11.313897] sp5100_tco: SP5100/SB800 TCO WatchDog Timer Driver v0.05
[   11.316416] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[   11.318908] ib700wdt: START method I/O 443 is not available
[   11.320537] ib700wdt: probe of ib700wdt failed with error -5
[   11.322403] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[   11.324691] wafer5823wdt: I/O address 0x0443 already in use
[   11.326364] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[   11.328146] i6300esb: cannot register miscdev on minor=3D130 (err=3D-16)
[   11.329880] i6300ESB timer: probe of 0000:00:04.0 failed with error -16
[   11.331800] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[   11.333604] it87_wdt: no device
[   11.334871] pc87413_wdt: Version 1.1 at io 0x2E
[   11.336188] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[   11.337918] nv_tco: NV TCO WatchDog Timer Driver v0.01
[   11.340200] sbc60xxwdt: I/O address 0x0443 already in use
[   11.341712] cpu5wdt: misc_register failed
[   11.343021] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[   11.346373] smsc37b787_wdt: Unable to register miscdev on minor 130
[   11.348023] w83977f_wdt: driver v1.00
[   11.349166] w83977f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[   11.350917] machzwd: MachZ ZF-Logic Watchdog driver initializing
[   11.352519] machzwd: no ZF-Logic found
[   11.354970] md: linear personality registered for level -1
[   11.356479] md: raid0 personality registered for level 0
[   11.357942] md: raid1 personality registered for level 1
[   11.359409] md: raid10 personality registered for level 10
[   11.361877] md: raid6 personality registered for level 6
[   11.363343] md: raid5 personality registered for level 5
[   11.364797] md: raid4 personality registered for level 4
[   11.366281] md: faulty personality registered for level -5
[   11.373529] device-mapper: ioctl: 4.28.0-ioctl (2014-09-17) initialised:=
 dm-devel@redhat.com
[   11.378105] device-mapper: raid: Loading target version 1.6.0
[   11.381620] device-mapper: cache-policy-mq: version 1.2.0 loaded
[   11.383234] device-mapper: cache cleaner: version 1.0.0 loaded
[   11.389225] leds_ss4200: no LED devices found
[   11.395145] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[   11.397411] Initializing Realtek PCIE storage driver...
[   11.404802] input: Speakup as /devices/virtual/input/input3
[   11.408414] initialized device: /dev/synth, node (MAJOR 10, MINOR 25)
[   11.410371] speakup 3.1.6: initialized
[   11.411547] synth name on entry is: (null)
[   11.412967] dgap: dgap-1.3-16, Digi International Part Number 40002347_C
[   11.414715] dgap: For the tools package please visit http://www.digi.com
[   11.417456] FPGA DOWNLOAD --->
[   11.418505] FPGA image file name: xlinx_fpga_firmware.bit
[   11.420577] GPIO INIT FAIL!!
[   11.421814] hdaps: supported laptop not found!
[   11.423122] hdaps: driver init failed (ret=3D-19)!
[   11.441675] ASIHPI driver 4.10.01
[   11.450266]=20
[   11.450266] printing PIC contents
[   11.451964] ... PIC  IMR: ffff
[   11.453006] ... PIC  IRR: 1113
[   11.454051] ... PIC  ISR: 0000
[   11.455093] ... PIC ELCR: 0c00
[   11.456157] printing local APIC contents on CPU#0/0:
[   11.457586] ... APIC ID:      00000000 (0)
[   11.458817] ... APIC VERSION: 01050014
[   11.459990] ... APIC TASKPRI: 00000000 (00)
[   11.461241] ... APIC PROCPRI: 00000000
[   11.462460] ... APIC LDR: 01000000
[   11.463625] ... APIC DFR: ffffffff
[   11.464721] ... APIC SPIV: 000001ff
[   11.465852] ... APIC ISR field:
[   11.466147] 000000000000000000000000000000000000000000000000000000000000=
0000
[   11.466147] ... APIC TMR field:
[   11.466147] 000000000e20000000000000000000000000000000000000000000000000=
0000
[   11.466147] ... APIC IRR field:
[   11.466147] 000000000000000000000000000000000000000000000000000000000000=
8000
[   11.466147] ... APIC ESR: 00000000
[   11.466147] ... APIC ICR: 000008fd
[   11.466147] ... APIC ICR2: 02000000
[   11.466147] ... APIC LVTT: 000000ef
[   11.466147] ... APIC LVTPC: 00010000
[   11.466147] ... APIC LVT0: 00010700
[   11.466147] ... APIC LVT1: 00000400
[   11.466147] ... APIC LVTERR: 000000fe
[   11.466147] ... APIC TMICT: 001c8689
[   11.466147] ... APIC TMCCT: 00000000
[   11.466147] ... APIC TDCR: 00000003
[   11.466147]=20
[   11.514567] number of MP IRQ sources: 15.
[   11.515922] number of IO-APIC #0 registers: 24.
[   11.517240] testing the IO APIC.......................
[   11.518693] IO APIC #0......
[   11.519703] .... register #00: 00000000
[   11.520933] .......    : physical APIC id: 00
[   11.522223] .......    : Delivery Type: 0
[   11.523457] .......    : LTS          : 0
[   11.524674] .... register #01: 00170011
[   11.525862] .......     : max redirection entries: 17
[   11.527291] .......     : PRQ implemented: 0
[   11.528586] .......     : IO APIC version: 11
[   11.529873] .... register #02: 00000000
[   11.531209] .......     : arbitration: 00
[   11.532451] .... IRQ redirection table:
[   11.533657] 1    0    0   0   0    0    0    00
[   11.534995] 0    0    0   0   0    1    1    31
[   11.536338] 0    0    0   0   0    1    1    30
[   11.537667] 0    0    0   0   0    1    1    33
[   11.538999] 1    0    0   0   0    1    1    34
[   11.540418] 1    1    0   0   0    1    1    35
[   11.541750] 0    0    0   0   0    1    1    36
[   11.543080] 0    0    0   0   0    1    1    37
[   11.544420] 0    0    0   0   0    1    1    38
[   11.545759] 0    1    0   0   0    1    1    39
[   11.547084] 1    1    0   0   0    1    1    3A
[   11.548415] 1    1    0   0   0    1    1    3B
[   11.549742] 0    0    0   0   0    1    1    3C
[   11.551092] 0    0    0   0   0    1    1    3D
[   11.552428] 0    0    0   0   0    1    1    3E
[   11.553757] 0    0    0   0   0    1    1    3F
[   11.555086] 1    0    0   0   0    0    0    00
[   11.556423] 1    0    0   0   0    0    0    00
[   11.557751] 1    0    0   0   0    0    0    00
[   11.559074] 1    0    0   0   0    0    0    00
[   11.560431] 1    0    0   0   0    0    0    00
[   11.561758] 1    0    0   0   0    0    0    00
[   11.563088] 1    0    0   0   0    0    0    00
[   11.564428] 1    0    0   0   0    0    0    00
[   11.565748] IRQ to pin mappings:
[   11.566821] IRQ0 -> 0:2
[   11.568010] IRQ1 -> 0:1
[   11.569194] IRQ3 -> 0:3
[   11.570418] IRQ4 -> 0:4
[   11.571605] IRQ5 -> 0:5
[   11.572787] IRQ6 -> 0:6
[   11.573971] IRQ7 -> 0:7
[   11.575155] IRQ8 -> 0:8
[   11.576352] IRQ9 -> 0:9
[   11.577539] IRQ10 -> 0:10
[   11.578754] IRQ11 -> 0:11
[   11.579976] IRQ12 -> 0:12
[   11.581229] IRQ13 -> 0:13
[   11.582458] IRQ14 -> 0:14
[   11.583685] IRQ15 -> 0:15
[   11.584904] .................................... done.
[   11.588813] Running tests on trace events:
[   11.590104] Testing event thermal_apic_exit: OK
[   11.631264] Testing event thermal_apic_entry: OK
[   11.671085] Testing event threshold_apic_exit: OK
[   11.741147] Testing event threshold_apic_entry: OK
[   11.801187] Testing event call_function_single_exit: OK
[   11.843415] Testing event call_function_single_entry: OK
[   11.883662] Testing event call_function_exit: OK
[   11.926012] Testing event call_function_entry: OK
[   11.961611] Testing event irq_work_exit: OK
[   12.001312] Testing event irq_work_entry: OK
[   12.098875] Testing event x86_platform_ipi_exit: OK
[   12.160117] Testing event x86_platform_ipi_entry: OK
[   12.211317] Testing event error_apic_exit: OK
[   12.279721] Testing event error_apic_entry: OK
[   12.349067] Testing event spurious_apic_exit: OK
[   12.419232] Testing event spurious_apic_entry: OK
[   12.556878] Testing event reschedule_exit: OK
[   12.632668] Testing event reschedule_entry: OK
[   12.702744] Testing event local_timer_exit: OK
[   12.754952] Testing event local_timer_entry: OK
[   12.801714] Testing event nmi_handler: OK
[   12.846439] Testing event emulate_vsyscall: OK
[   12.891284] Testing event sys_exit: OK
[   12.931382] Testing event sys_enter: OK
[   12.971309] Testing event ipi_exit: OK
[   13.017881] Testing event ipi_entry: OK
[   13.062336] Testing event ipi_raise: OK
[   13.105621] Testing event tlb_flush: OK
[   13.147519] Testing event page_fault_kernel: OK
[   13.191378] Testing event page_fault_user: OK
[   13.238132] Testing event task_rename: OK
[   13.286825] Testing event task_newtask: OK
[   13.332180] Testing event softirq_raise: OK
[   13.380262] Testing event softirq_exit: OK
[   13.434446] Testing event softirq_entry: OK
[   13.472378] Testing event irq_handler_exit: OK
[   13.530615] Testing event irq_handler_entry: OK
[   13.585094] Testing event signal_deliver: OK
[   13.637647] Testing event signal_generate: OK
[   13.682019] Testing event workqueue_execute_end: OK
[   13.721997] Testing event workqueue_execute_start: OK
[   13.803725] Testing event workqueue_activate_work: OK
[   13.847252] Testing event workqueue_queue_work: OK
[   13.902591] Testing event sched_wake_idle_without_ipi: OK
[   13.964923] Testing event sched_swap_numa: OK
[   14.039603] Testing event sched_stick_numa: OK
[   14.083318] Testing event sched_move_numa: OK
[   14.121434] Testing event sched_pi_setprio: OK
[   14.166840] Testing event sched_stat_runtime: OK
[   14.227588] Testing event sched_stat_blocked: OK
[   14.277176] Testing event sched_stat_iowait: OK
[   14.321421] Testing event sched_stat_sleep: OK
[   14.361351] Testing event sched_stat_wait: OK
[   14.401398] Testing event sched_process_exec: OK
[   14.441422] Testing event sched_process_fork: OK
[   14.481361] Testing event sched_process_wait: OK
[   14.521437] Testing event sched_wait_task: OK
[   14.561454] Testing event sched_process_exit: OK
[   14.601407] Testing event sched_process_free: OK
[   14.669507] Testing event sched_migrate_task: OK
[   14.725622] Testing event sched_switch: OK
[   14.775654] Testing event sched_wakeup_new: OK
[   14.827581] Testing event sched_wakeup: OK
[   14.887613] Testing event sched_kthread_stop_ret: OK
[   14.945617] Testing event sched_kthread_stop: OK
[   15.001300] Testing event console: OK
[   15.045750] Testing event rcu_barrier: OK
[   15.108991] Testing event rcu_torture_read: OK
[   15.162787] Testing event rcu_batch_end: OK
[   15.216004] Testing event rcu_invoke_kfree_callback: OK
[   15.261955] Testing event rcu_invoke_callback: OK
[   15.315979] Testing event rcu_batch_start: OK
[   15.362462] Testing event rcu_kfree_callback: OK
[   15.406404] Testing event rcu_callback: OK
[   15.465939] Testing event rcu_prep_idle: OK
[   15.505175] Testing event rcu_dyntick: OK
[   15.566266] Testing event rcu_fqs: OK
[   15.620736] Testing event rcu_quiescent_state_report: OK
[   15.666091] Testing event rcu_unlock_preempted_task: OK
[   15.722243] Testing event rcu_preempt_task: OK
[   15.775979] Testing event rcu_nocb_wake: OK
[   15.822185] Testing event rcu_grace_period_init: OK
[   15.866060] Testing event rcu_future_grace_period: OK
[   15.924122] Testing event rcu_grace_period: OK
[   15.963370] Testing event rcu_utilization: OK
[   16.002712] Testing event tick_stop: OK
[   16.042394] Testing event itimer_expire: OK
[   16.082180] Testing event itimer_state: OK
[   16.122524] Testing event hrtimer_cancel: OK
[   16.162661] Testing event hrtimer_expire_exit: OK
[   16.202030] Testing event hrtimer_expire_entry: OK
[   16.241369] Testing event hrtimer_start: OK
[   16.281364] Testing event hrtimer_init: OK
[   16.322459] Testing event timer_cancel: OK
[   16.362757] Testing event timer_expire_exit: OK
[   16.402094] Testing event timer_expire_entry: OK
[   16.451672] Testing event timer_start: OK
[   16.493012] Testing event timer_init: OK
[   16.541784] Testing event ftrace_test_filter: OK
[   16.582705] Testing event dev_pm_qos_remove_request: OK
[   16.621582] Testing event dev_pm_qos_update_request: OK
[   16.662438] Testing event dev_pm_qos_add_request: OK
[   16.702047] Testing event pm_qos_update_flags: OK
[   16.742010] Testing event pm_qos_update_target: OK
[   16.784418] Testing event pm_qos_update_request_timeout: OK
[   16.822363] Testing event pm_qos_remove_request: OK
[   16.864202] Testing event pm_qos_update_request: OK
[   16.902250] Testing event pm_qos_add_request: OK
[   16.942088] Testing event power_domain_target: OK
[   16.981335] Testing event clock_set_rate: OK
[   17.021167] Testing event clock_disable: OK
[   17.072629] Testing event clock_enable: OK
[   17.112027] Testing event wakeup_source_deactivate: OK
[   17.152076] Testing event wakeup_source_activate: OK
[   17.191881] Testing event suspend_resume: OK
[   17.248847] Testing event device_pm_callback_end: OK
[   17.302764] Testing event device_pm_callback_start: OK
[   17.343523] Testing event cpu_frequency: OK
[   17.382662] Testing event pstate_sample: OK
[   17.431419] Testing event cpu_idle: OK
[   17.472120] Testing event rpm_return_int: OK
[   17.511834] Testing event rpm_idle: OK
[   17.551411] Testing event rpm_resume: OK
[   17.601626] Testing event rpm_suspend: OK
[   17.641451] Testing event benchmark_event: OK
[   17.751541] Testing event user_exit: OK
[   17.792073] Testing event user_enter: OK
[   17.831421] Testing event mm_filemap_add_to_page_cache: OK
[   17.872297] Testing event mm_filemap_delete_from_page_cache: OK
[   17.912155] Testing event oom_score_adj_update: OK
[   17.952277] Testing event mm_lru_activate: OK
[   17.991397] Testing event mm_lru_insertion: OK
[   18.031516] Testing event mm_vmscan_lru_shrink_inactive: OK
[   18.071790] Testing event mm_vmscan_writepage: OK
[   18.112101] Testing event mm_vmscan_memcg_isolate: OK
[   18.162003] Testing event mm_vmscan_lru_isolate: OK
[   18.201992] Testing event mm_shrink_slab_end: OK
[   18.242610] Testing event mm_shrink_slab_start: OK
[   18.281925] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[   18.321759] Testing event mm_vmscan_memcg_reclaim_end: OK
[   18.361324] Testing event mm_vmscan_direct_reclaim_end: OK
[   18.401339] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[   18.441190] Testing event mm_vmscan_memcg_reclaim_begin: OK
[   18.481186] Testing event mm_vmscan_direct_reclaim_begin: OK
[   18.521327] Testing event mm_vmscan_wakeup_kswapd: OK
[   18.561454] Testing event mm_vmscan_kswapd_wake: OK
[   18.601441] Testing event mm_vmscan_kswapd_sleep: OK
[   18.641441] Testing event mm_page_alloc_extfrag: OK
[   18.681393] Testing event mm_page_pcpu_drain: OK
[   18.721358] Testing event mm_page_alloc_zone_locked: OK
[   18.761334] Testing event mm_page_alloc: OK
[   18.801368] Testing event mm_page_free_batched: OK
[   18.841321] Testing event mm_page_free: OK
[   18.881359] Testing event kmem_cache_free: OK
[   18.921330] Testing event kfree: OK
[   18.961314] Testing event kmem_cache_alloc_node: OK
[   19.001307] Testing event kmalloc_node: OK
[   19.041870] Testing event kmem_cache_alloc: OK
[   19.081347] Testing event kmalloc: OK
[   19.121638] Testing event mm_compaction_end: OK
[   19.161232] Testing event mm_compaction_begin: OK
[   19.201310] Testing event mm_compaction_migratepages: OK
[   19.241293] Testing event mm_compaction_isolate_freepages: OK
[   19.281314] Testing event mm_compaction_isolate_migratepages: OK
[   19.321306] Testing event mm_numa_migrate_ratelimit: OK
[   19.364100] Testing event mm_migrate_pages: OK
[   19.401762] Testing event writeback_single_inode: OK
[   19.441358] Testing event writeback_single_inode_start: OK
[   19.481337] Testing event writeback_wait_iff_congested: OK
[   19.521252] Testing event writeback_congestion_wait: OK
[   19.561285] Testing event writeback_sb_inodes_requeue: OK
[   19.601423] Testing event balance_dirty_pages: OK
[   19.641416] Testing event bdi_dirty_ratelimit: OK
[   19.681327] Testing event global_dirty_state: OK
[   19.721329] Testing event writeback_queue_io: OK
[   19.761348] Testing event wbc_writepage: OK
[   19.801466] Testing event writeback_bdi_unregister: OK
[   19.841357] Testing event writeback_bdi_register: OK
[   19.881306] Testing event writeback_wake_background: OK
[   19.921281] Testing event writeback_nowork: OK
[   19.961327] Testing event writeback_pages_written: OK
[   20.001437] Testing event writeback_wait: OK
[   20.041356] Testing event writeback_written: OK
[   20.081328] Testing event writeback_start: OK
[   20.121414] Testing event writeback_exec: OK
[   20.171886] Testing event writeback_queue: OK
[   20.212154] Testing event writeback_write_inode: OK
[   20.251744] Testing event writeback_write_inode_start: OK
[   20.292416] Testing event writeback_dirty_inode: OK
[   20.332367] Testing event writeback_dirty_inode_start: OK
[   20.371730] Testing event writeback_dirty_page: OK
[   20.412285] Testing event time_out_leases: OK
[   20.451711] Testing event generic_delete_lease: OK
[   20.491980] Testing event generic_add_lease: OK
[   20.532100] Testing event break_lease_unblock: OK
[   20.572148] Testing event break_lease_block: OK
[   20.611803] Testing event break_lease_noblock: OK
[   20.651846] Testing event ext3_load_inode: OK
[   20.691912] Testing event ext3_get_blocks_exit: OK
[   20.731644] Testing event ext3_get_blocks_enter: OK
[   20.771988] Testing event ext3_truncate_exit: OK
[   20.812427] Testing event ext3_truncate_enter: OK
[   20.851364] Testing event ext3_unlink_exit: OK
[   20.901991] Testing event ext3_unlink_enter: OK
[   20.942062] Testing event ext3_direct_IO_exit: OK
[   20.992314] Testing event ext3_direct_IO_enter: OK
[   21.032072] Testing event ext3_read_block_bitmap: OK
[   21.071954] Testing event ext3_forget: OK
[   21.115622] Testing event ext3_reserved: OK
[   21.153257] Testing event ext3_alloc_new_reservation: OK
[   21.192265] Testing event ext3_discard_reservation: OK
[   21.232053] Testing event ext3_rsv_window_add: OK
[   21.271958] Testing event ext3_sync_fs: OK
[   21.311658] Testing event ext3_sync_file_exit: OK
[   21.352204] Testing event ext3_sync_file_enter: OK
[   21.391957] Testing event ext3_free_blocks: OK
[   21.432247] Testing event ext3_allocate_blocks: OK
[   21.471948] Testing event ext3_request_blocks: OK
[   21.512118] Testing event ext3_discard_blocks: OK
[   21.551550] Testing event ext3_invalidatepage: OK
[   21.592171] Testing event ext3_releasepage: OK
[   21.632072] Testing event ext3_readpage: OK
[   21.672253] Testing event ext3_journalled_writepage: OK
[   21.712372] Testing event ext3_writeback_writepage: OK
[   21.751996] Testing event ext3_ordered_writepage: OK
[   21.791584] Testing event ext3_journalled_write_end: OK
[   21.831786] Testing event ext3_writeback_write_end: OK
[   21.872574] Testing event ext3_ordered_write_end: OK
[   21.912092] Testing event ext3_write_begin: OK
[   21.953815] Testing event ext3_mark_inode_dirty: OK
[   21.992121] Testing event ext3_drop_inode: OK
[   22.031733] Testing event ext3_evict_inode: OK
[   22.072373] Testing event ext3_allocate_inode: OK
[   22.112043] Testing event ext3_request_inode: OK
[   22.151313] Testing event ext3_free_inode: OK
[   22.191355] Testing event ext4_es_shrink: OK
[   22.231261] Testing event ext4_collapse_range: OK
[   22.271241] Testing event ext4_es_shrink_scan_exit: OK
[   22.311267] Testing event ext4_es_shrink_scan_enter: OK
[   22.351374] Testing event ext4_es_shrink_count: OK
[   22.391877] Testing event ext4_es_lookup_extent_exit: OK
[   22.431657] Testing event ext4_es_lookup_extent_enter: OK
[   22.472171] Testing event ext4_es_find_delayed_extent_range_exit: OK
[   22.521983] Testing event ext4_es_find_delayed_extent_range_enter: OK
[   22.561406] Testing event ext4_es_remove_extent: OK
[   22.602685] Testing event ext4_es_cache_extent: OK
[   22.641434] Testing event ext4_es_insert_extent: OK
[   22.681294] Testing event ext4_ext_remove_space_done: OK
[   22.721369] Testing event ext4_ext_remove_space: OK
[   22.761356] Testing event ext4_ext_rm_idx: OK
[   22.801262] Testing event ext4_ext_rm_leaf: OK
[   22.841593] Testing event ext4_remove_blocks: OK
[   22.881933] Testing event ext4_ext_show_extent: OK
[   22.922233] Testing event ext4_get_reserved_cluster_alloc: OK
[   22.972041] Testing event ext4_find_delalloc_range: OK
[   23.011925] Testing event ext4_ext_in_cache: OK
[   23.051731] Testing event ext4_ext_put_in_cache: OK
[   23.091680] Testing event ext4_get_implied_cluster_alloc_exit: OK
[   23.131981] Testing event ext4_ext_handle_unwritten_extents: OK
[   23.171758] Testing event ext4_trim_all_free: OK
[   23.211713] Testing event ext4_trim_extent: OK
[   23.252023] Testing event ext4_journal_start_reserved: OK
[   23.291694] Testing event ext4_journal_start: OK
[   23.333401] Testing event ext4_load_inode: OK
[   23.381750] Testing event ext4_ext_load_extent: OK
[   23.421940] Testing event ext4_ind_map_blocks_exit: OK
[   23.462517] Testing event ext4_ext_map_blocks_exit: OK
[   23.501657] Testing event ext4_ind_map_blocks_enter: OK
[   23.543149] Testing event ext4_ext_map_blocks_enter: OK
[   23.581789] Testing event ext4_ext_convert_to_initialized_fastpath: OK
[   23.622294] Testing event ext4_ext_convert_to_initialized_enter: OK
[   23.661585] Testing event ext4_truncate_exit: OK
[   23.701802] Testing event ext4_truncate_enter: OK
[   23.751856] Testing event ext4_unlink_exit: OK
[   23.791799] Testing event ext4_unlink_enter: OK
[   23.831935] Testing event ext4_fallocate_exit: OK
[   23.871929] Testing event ext4_zero_range: OK
[   23.911723] Testing event ext4_punch_hole: OK
[   23.951461] Testing event ext4_fallocate_enter: OK
[   23.991253] Testing event ext4_direct_IO_exit: OK
[   24.072157] Testing event ext4_direct_IO_enter: OK
[   24.111417] Testing event ext4_load_inode_bitmap: OK
[   24.151236] Testing event ext4_read_block_bitmap_load: OK
[   24.192831] Testing event ext4_mb_buddy_bitmap_load: OK
[   24.233724] Testing event ext4_mb_bitmap_load: OK
[   24.273421] Testing event ext4_da_release_space: OK
[   24.312081] Testing event ext4_da_reserve_space: OK
[   24.352263] Testing event ext4_da_update_reserve_space: OK
[   24.392239] Testing event ext4_forget: OK
[   24.432131] Testing event ext4_mballoc_free: OK
[   24.473593] Testing event ext4_mballoc_discard: OK
[   24.511874] Testing event ext4_mballoc_prealloc: OK
[   24.552250] Testing event ext4_mballoc_alloc: OK
[   24.591959] Testing event ext4_alloc_da_blocks: OK
[   24.631720] Testing event ext4_sync_fs: OK
[   24.671626] Testing event ext4_sync_file_exit: OK
[   24.711784] Testing event ext4_sync_file_enter: OK
[   24.752254] Testing event ext4_free_blocks: OK
[   24.792177] Testing event ext4_allocate_blocks: OK
[   24.833119] Testing event ext4_request_blocks: OK
[   24.871695] Testing event ext4_mb_discard_preallocations: OK
[   24.922088] Testing event ext4_discard_preallocations: OK
[   24.962142] Testing event ext4_mb_release_group_pa: OK
[   25.001868] Testing event ext4_mb_release_inode_pa: OK
[   25.041840] Testing event ext4_mb_new_group_pa: OK
[   25.082012] Testing event ext4_mb_new_inode_pa: OK
[   25.122120] Testing event ext4_discard_blocks: OK
[   25.173071] Testing event ext4_journalled_invalidatepage: OK
[   25.212247] Testing event ext4_invalidatepage: OK
[   25.251966] Testing event ext4_releasepage: OK
[   25.292214] Testing event ext4_readpage: OK
[   25.332114] Testing event ext4_writepage: OK
[   25.371671] Testing event ext4_writepages_result: OK
[   25.412047] Testing event ext4_da_write_pages_extent: OK
[   25.451827] Testing event ext4_da_write_pages: OK
[   25.492077] Testing event ext4_writepages: OK
[   25.531788] Testing event ext4_da_write_end: OK
[   25.571935] Testing event ext4_journalled_write_end: OK
[   25.612113] Testing event ext4_write_end: OK
[   25.651698] Testing event ext4_da_write_begin: OK
[   25.691771] Testing event ext4_write_begin: OK
[   25.731779] Testing event ext4_begin_ordered_truncate: OK
[   25.782009] Testing event ext4_mark_inode_dirty: OK
[   25.835380] Testing event ext4_drop_inode: OK
[   25.871697] Testing event ext4_evict_inode: OK
[   25.911821] Testing event ext4_allocate_inode: OK
[   25.954639] Testing event ext4_request_inode: OK
[   25.996013] Testing event ext4_free_inode: OK
[   26.035610] Testing event journal_write_superblock: OK
[   26.084357] Testing event jbd_cleanup_journal_tail: OK
[   26.121225] Testing event jbd_do_submit_data: OK
[   26.161448] Testing event jbd_end_commit: OK
[   26.201341] Testing event jbd_drop_transaction: OK
[   26.241432] Testing event jbd_commit_logging: OK
[   26.281567] Testing event jbd_commit_flushing: OK
[   26.321252] Testing event jbd_commit_locking: OK
[   26.361264] Testing event jbd_start_commit: OK
[   26.419494] Testing event jbd_checkpoint: OK
[   26.469387] Testing event jbd2_lock_buffer_stall: OK
[   26.519416] Testing event jbd2_write_superblock: OK
[   26.569380] Testing event jbd2_update_log_tail: OK
[   26.619393] Testing event jbd2_checkpoint_stats: OK
[   26.669417] Testing event jbd2_run_stats: OK
[   26.719387] Testing event jbd2_handle_stats: OK
[   26.769416] Testing event jbd2_handle_extend: OK
[   26.817392] Testing event jbd2_handle_start: OK
[   26.861186] Testing event jbd2_submit_inode_data: OK
[   26.901265] Testing event jbd2_end_commit: OK
[   26.941170] Testing event jbd2_drop_transaction: OK
[   26.981237] Testing event jbd2_commit_logging: OK
[   27.021304] Testing event jbd2_commit_flushing: OK
[   27.061167] Testing event jbd2_commit_locking: OK
[   27.101260] Testing event jbd2_start_commit: OK
[   27.177628] Testing event jbd2_checkpoint: OK
[   27.243967] Testing event btrfs_qgroup_record_ref: OK
[   27.297105] Testing event btrfs_qgroup_account: OK
[   27.346079] Testing event btrfs_workqueue_destroy: OK
[   27.428535] Testing event btrfs_workqueue_alloc: OK
[   27.490072] Testing event btrfs_ordered_sched: OK
[   27.546097] Testing event btrfs_all_work_done: OK
[   27.596408] Testing event btrfs_work_sched: OK
[   27.643820] Testing event btrfs_work_queued: OK
[   27.704036] Testing event free_extent_state: OK
[   27.766941] Testing event alloc_extent_state: OK
[   27.816929] Testing event btrfs_setup_cluster: OK
[   27.866073] Testing event btrfs_failed_cluster_setup: OK
[   27.916882] Testing event btrfs_find_cluster: OK
[   27.966130] Testing event btrfs_reserve_extent_cluster: OK
[   28.016175] Testing event btrfs_reserve_extent: OK
[   28.075104] Testing event find_free_extent: OK
[   28.125924] Testing event btrfs_reserved_extent_free: OK
[   28.176508] Testing event btrfs_reserved_extent_alloc: OK
[   28.227165] Testing event btrfs_space_reservation: OK
[   28.289689] Testing event btrfs_cow_block: OK
[   28.336100] Testing event btrfs_chunk_free: OK
[   28.385781] Testing event btrfs_chunk_alloc: OK
[   28.436444] Testing event run_delayed_ref_head: OK
[   28.486316] Testing event add_delayed_ref_head: OK
[   28.535775] Testing event run_delayed_data_ref: OK
[   28.586300] Testing event add_delayed_data_ref: OK
[   28.636321] Testing event run_delayed_tree_ref: OK
[   28.684884] Testing event add_delayed_tree_ref: OK
[   28.736386] Testing event btrfs_sync_fs: OK
[   28.786422] Testing event btrfs_sync_file: OK
[   28.847459] Testing event btrfs_writepage_end_io_hook: OK
[   28.919646] Testing event __extent_writepage: OK
[   29.000557] Testing event btrfs_ordered_extent_put: OK
[   29.107213] Testing event btrfs_ordered_extent_start: OK
[   29.184935] Testing event btrfs_ordered_extent_remove: OK
[   29.250364] Testing event btrfs_ordered_extent_add: OK
[   29.326343] Testing event btrfs_get_extent: OK
[   29.390624] Testing event btrfs_inode_evict: OK
[   29.470229] Testing event btrfs_inode_request: OK
[   29.563312] Testing event btrfs_inode_new: OK
[   29.683346] Testing event btrfs_transaction_commit: OK
[   29.809572] Testing event block_rq_remap: OK
[   29.910443] Testing event block_bio_remap: OK
[   30.011609] Testing event block_split: OK
[   30.094163] Testing event block_unplug: OK
[   30.164633] Testing event block_plug: OK
[   30.221488] Testing event block_sleeprq: OK
[   30.291216] Testing event block_getrq: OK
[   30.364470] Testing event block_bio_queue: OK
[   30.541147] Testing event block_bio_frontmerge: OK
[   30.729120] Testing event block_bio_backmerge: OK
[   30.829604] Testing event block_bio_complete: OK
[   30.872628] Testing event block_bio_bounce: OK
[   30.911809] Testing event block_rq_issue: OK
[   30.951880] Testing event block_rq_insert: OK
[   30.991878] Testing event block_rq_complete: OK
[   31.032364] Testing event block_rq_requeue: OK
[   31.085538] Testing event block_rq_abort: OK
[   31.128362] Testing event block_dirty_buffer: OK
[   31.180574] Testing event block_touch_buffer: OK
[   31.233534] Testing event swiotlb_bounced: OK
[   31.313391] Testing event gpio_value: OK
[   31.360793] Testing event gpio_direction: OK
[   31.413122] Testing event regulator_set_voltage_complete: OK
[   31.486487] Testing event regulator_set_voltage: OK
[   31.549384] Testing event regulator_disable_complete: OK
[   31.629973] Testing event regulator_disable: OK
[   31.693422] Testing event regulator_enable_complete: OK
[   31.773364] Testing event regulator_enable_delay: OK
[   31.826086] Testing event regulator_enable: OK
[   31.889632] Testing event urandom_read: OK
[   31.958299] Testing event random_read: OK
[   32.036246] Testing event extract_entropy_user: OK
[   32.093876] Testing event extract_entropy: OK
[   32.136001] Testing event get_random_bytes_arch: OK
[   32.187141] Testing event get_random_bytes: OK
[   32.227451] Testing event xfer_secondary_pool: OK
[   32.278310] Testing event add_disk_randomness: OK
[   32.345717] Testing event add_input_randomness: OK
[   32.400788] Testing event debit_entropy: OK
[   32.442121] Testing event push_to_pool: OK
[   32.482402] Testing event credit_entropy_bits: OK
[   32.538566] Testing event mix_pool_bytes_nolock: OK
[   32.586580] Testing event mix_pool_bytes: OK
[   32.632525] Testing event add_device_randomness: OK
[   32.676958] Testing event drm_vblank_event_delivered: OK
[   32.728252] Testing event drm_vblank_event_queued: OK
[   32.785262] Testing event drm_vblank_event: OK
[   32.827286] Testing event radeon_semaphore_wait: OK
[   32.873692] Testing event radeon_semaphore_signale: OK
[   32.912862] Testing event radeon_fence_wait_end: OK
[   32.951990] Testing event radeon_fence_wait_begin: OK
[   32.991953] Testing event radeon_fence_emit: OK
[   33.032457] Testing event radeon_vm_flush: OK
[   33.071912] Testing event radeon_vm_set_page: OK
[   33.112904] Testing event radeon_vm_bo_update: OK
[   33.161905] Testing event radeon_vm_grab_id: OK
[   33.239611] Testing event radeon_cs: OK
[   33.281566] Testing event radeon_bo_create: OK
[   33.321968] Testing event regcache_drop_region: OK
[   33.361609] Testing event regmap_async_complete_done: OK
[   33.402569] Testing event regmap_async_complete_start: OK
[   33.442044] Testing event regmap_async_io_complete: OK
[   33.481808] Testing event regmap_async_write_start: OK
[   33.521956] Testing event regmap_cache_bypass: OK
[   33.574022] Testing event regmap_cache_only: OK
[   33.632235] Testing event regcache_sync: OK
[   33.682659] Testing event regmap_hw_write_done: OK
[   33.722385] Testing event regmap_hw_write_start: OK
[   33.763179] Testing event regmap_hw_read_done: OK
[   33.801856] Testing event regmap_hw_read_start: OK
[   33.841817] Testing event regmap_reg_read_cache: OK
[   33.881835] Testing event regmap_reg_read: OK
[   33.931892] Testing event regmap_reg_write: OK
[   33.976357] Testing event fence_wait_end: OK
[   34.012236] Testing event fence_wait_start: OK
[   34.095422] Testing event fence_signaled: OK
[   34.132511] Testing event fence_enable_signal: OK
[   34.172599] Testing event fence_destroy: OK
[   34.212130] Testing event fence_init: OK
[   34.252309] Testing event fence_emit: OK
[   34.292403] Testing event fence_annotate_wait_on: OK
[   34.331938] Testing event scsi_eh_wakeup: OK
[   34.382418] Testing event scsi_dispatch_cmd_timeout: OK
[   34.422080] Testing event scsi_dispatch_cmd_done: OK
[   34.483050] Testing event scsi_dispatch_cmd_error: OK
[   34.522152] Testing event scsi_dispatch_cmd_start: OK
[   34.565156] Testing event target_cmd_complete: OK
[   34.606296] Testing event target_sequencer_start: OK
[   34.652079] Testing event spi_transfer_stop: OK
[   34.702089] Testing event spi_transfer_start: OK
[   34.742557] Testing event spi_message_done: OK
[   34.792233] Testing event spi_message_start: OK
[   34.835351] Testing event spi_message_submit: OK
[   34.872432] Testing event spi_master_busy: OK
[   34.921973] Testing event spi_master_idle: OK
[   34.982192] Testing event smbus_result: OK
[   35.033116] Testing event smbus_reply: OK
[   35.072228] Testing event smbus_read: OK
[   35.112088] Testing event smbus_write: OK
[   35.152715] Testing event i2c_result: OK
[   35.202902] Testing event i2c_reply: OK
[   35.252620] Testing event i2c_read: OK
[   35.292407] Testing event i2c_write: OK
[   35.332763] Testing event thermal_zone_trip: OK
[   35.382247] Testing event cdev_update: OK
[   35.422120] Testing event thermal_temperature: OK
[   35.463351] Testing event bcache_writeback_collision: OK
[   35.502174] Testing event bcache_writeback: OK
[   35.542199] Testing event bcache_alloc_fail: OK
[   35.582342] Testing event bcache_alloc: OK
[   35.622208] Testing event bcache_invalidate: OK
[   35.662243] Testing event bcache_keyscan: OK
[   35.702257] Testing event bcache_btree_set_root: OK
[   35.752524] Testing event bcache_btree_node_compact: OK
[   35.802072] Testing event bcache_btree_node_split: OK
[   35.853795] Testing event bcache_btree_insert_key: OK
[   35.902196] Testing event bcache_gc_copy_collision: OK
[   35.941988] Testing event bcache_gc_copy: OK
[   35.982034] Testing event bcache_gc_end: OK
[   36.032103] Testing event bcache_gc_start: OK
[   36.081978] Testing event bcache_btree_gc_coalesce: OK
[   36.121960] Testing event bcache_btree_node_free: OK
[   36.162375] Testing event bcache_btree_node_alloc_fail: OK
[   36.202205] Testing event bcache_btree_node_alloc: OK
[   36.242067] Testing event bcache_btree_write: OK
[   36.282111] Testing event bcache_btree_read: OK
[   36.322079] Testing event bcache_btree_cache_cannibalize: OK
[   36.362249] Testing event bcache_journal_write: OK
[   36.402191] Testing event bcache_journal_entry_full: OK
[   36.441595] Testing event bcache_journal_full: OK
[   36.481364] Testing event bcache_journal_replay_key: OK
[   36.521350] Testing event bcache_cache_insert: OK
[   36.561385] Testing event bcache_read_retry: OK
[   36.601366] Testing event bcache_write: OK
[   36.641459] Testing event bcache_read: OK
[   36.681368] Testing event bcache_bypass_congested: OK
[   36.721335] Testing event bcache_bypass_sequential: OK
[   36.761412] Testing event bcache_request_end: OK
[   36.801398] Testing event bcache_request_start: OK
[   36.842319] Testing event aer_event: OK
[   36.881460] Testing event mc_event: OK
[   36.921234] Testing event hda_unsol_event: OK
[   36.961329] Testing event hda_power_count: OK
[   37.001408] Testing event hda_power_up: OK
[   37.042257] Testing event hda_power_down: OK
[   37.082034] Testing event hda_bus_reset: OK
[   37.122562] Testing event hda_get_response: OK
[   37.171920] Testing event hda_send_cmd: OK
[   37.211479] Testing event azx_get_position: OK
[   37.269882] Testing event azx_pcm_trigger: OK
[   37.311974] Testing event udp_fail_queue_rcv_skb: OK
[   37.351786] Testing event sock_exceed_buf_limit: OK
[   37.391962] Testing event sock_rcvqueue_full: OK
[   37.433129] Testing event napi_poll: OK
[   37.472540] Testing event netif_rx_ni_entry: OK
[   37.516547] Testing event netif_rx_entry: OK
[   37.551824] Testing event netif_receive_skb_entry: OK
[   37.592250] Testing event napi_gro_receive_entry: OK
[   37.632015] Testing event napi_gro_frags_entry: OK
[   37.671890] Testing event netif_rx: OK
[   37.712382] Testing event netif_receive_skb: OK
[   37.751896] Testing event net_dev_queue: OK
[   37.802608] Testing event net_dev_xmit: OK
[   37.841992] Testing event net_dev_start_xmit: OK
[   37.881943] Testing event skb_copy_datagram_iovec: OK
[   37.922020] Testing event consume_skb: OK
[   37.962355] Testing event kfree_skb: OK
[   38.002143] Running tests on trace event systems:
[   38.003547] Testing event system skb: OK
[   38.072945] Testing event system net: OK
[   38.116975] Testing event system napi: OK
[   38.151983] Testing event system sock: OK
[   38.192170] Testing event system udp: OK
[   38.236321] Testing event system hda_intel: OK
[   38.272037] Testing event system hda: OK
[   38.312928] Testing event system ras: OK
[   38.352033] Testing event system bcache: OK
[   38.408282] Testing event system thermal: OK
[   38.452449] Testing event system i2c: OK
[   38.493569] Testing event system spi: OK
[   38.533032] Testing event system target: OK
[   38.574206] Testing event system scsi: OK
[   38.613149] Testing event system fence: OK
[   38.654186] Testing event system regmap: OK
[   38.706128] Testing event system radeon: OK
[   38.754106] Testing event system drm: OK
[   38.792355] Testing event system random: OK
[   38.835010] Testing event system regulator: OK
[   38.883836] Testing event system gpio: OK
[   38.923590] Testing event system swiotlb: OK
[   38.962090] Testing event system block: OK
[   39.018409] Testing event system btrfs: OK
[   39.107096] Testing event system jbd2: OK
[   39.154824] Testing event system jbd: OK
[   39.203895] Testing event system ext4: OK
[   39.282285] Testing event system ext3: OK
[   39.339959] Testing event system filelock: OK
[   39.383089] Testing event system writeback: OK
[   39.437516] Testing event system migrate: OK
[   39.472791] Testing event system compaction: OK
[   39.515193] Testing event system kmem: OK
[   39.566020] Testing event system vmscan: OK
[   39.613769] Testing event system pagemap: OK
[   39.652065] Testing event system oom: OK
[   39.692050] Testing event system filemap: OK
[   39.732280] Testing event system context_tracking: OK
[   39.772058] Testing event system benchmark: OK
[   39.881939] Testing event system rpm: OK
[   39.923155] Testing event system power: OK
[   39.995862] Testing event system test: OK
[   40.031877] Testing event system timer: OK
[   40.090397] Testing event system rcu: OK
[   40.166873] Testing event system printk: OK
[   40.211844] Testing event system sched: OK
[   40.266299] Testing event system workqueue: OK
[   40.312443] Testing event system signal: OK
[   40.352738] Testing event system irq: OK
[   40.395388] Testing event system task: OK
[   40.432000] Testing event system exceptions: OK
[   40.472089] Testing event system tlb: OK
[   40.513791] Testing event system ipi: OK
[   40.556243] Testing event system raw_syscalls: OK
[   40.592975] Testing event system vsyscall: OK
[   40.631847] Testing event system nmi: OK
[   40.671907] Testing event system irq_vectors: OK
[   40.715551] Running tests on all trace events:
[   40.716905] Testing all events: OK
[   41.175309] Running tests again, along with the function tracer
[   41.177676] Running tests on trace events:
[   41.179382] Testing event thermal_apic_exit: OK
[   41.357214] Testing event thermal_apic_entry: OK
[   41.505598] Testing event threshold_apic_exit: OK
[   41.654778] Testing event threshold_apic_entry: OK
[   41.757800] Testing event call_function_single_exit: OK
[   41.876785] Testing event call_function_single_entry: OK
[   41.977352] Testing event call_function_exit: OK
[   42.197577] Testing event call_function_entry: OK
[   42.329970] Testing event irq_work_exit: OK
[   42.468821] Testing event irq_work_entry: OK
[   42.619417] Testing event x86_platform_ipi_exit: OK
[   42.794921] Testing event x86_platform_ipi_entry: OK
[   42.911840] Testing event error_apic_exit: OK
[   42.997089] Testing event error_apic_entry: OK
[   43.186845] Testing event spurious_apic_exit: OK
[   43.255363] Testing event spurious_apic_entry: OK
[   43.339178] Testing event reschedule_exit: OK
[   43.458245] Testing event reschedule_entry: OK
[   43.616040] Testing event local_timer_exit: OK
[   43.719381] Testing event local_timer_entry: OK
[   43.924215] Testing event nmi_handler: OK
[   44.029586] Testing event emulate_vsyscall: OK
[   44.209851] Testing event sys_exit: OK
[   44.385682] Testing event sys_enter: OK
[   44.474526] Testing event ipi_exit: OK
[   44.606289] Testing event ipi_entry: OK
[   44.728178] Testing event ipi_raise: OK
[   44.842188] Testing event tlb_flush: OK
[   44.994041] Testing event page_fault_kernel: OK
[   45.068931] Testing event page_fault_user: OK
[   45.177950] Testing event task_rename: OK
[   45.256037] Testing event task_newtask: OK
[   45.344251] Testing event softirq_raise: OK
[   45.499979] Testing event softirq_exit: OK
[   45.585065] Testing event softirq_entry: OK
[   45.657658] Testing event irq_handler_exit: OK
[   45.779895] Testing event irq_handler_entry: OK
[   45.898705] Testing event signal_deliver: OK
[   46.069793] Testing event signal_generate: OK
[   46.273410] Testing event workqueue_execute_end: OK
[   46.394544] Testing event workqueue_execute_start: OK
[   46.507264] Testing event workqueue_activate_work: OK
[   46.617155] Testing event workqueue_queue_work: OK
[   46.725520] Testing event sched_wake_idle_without_ipi: OK
[   46.823940] Testing event sched_swap_numa: OK
[   46.897554] Testing event sched_stick_numa: OK
[   47.017590] Testing event sched_move_numa: OK
[   47.167751] Testing event sched_pi_setprio: OK
[   47.296744] Testing event sched_stat_runtime: OK
[   47.397780] Testing event sched_stat_blocked: OK
[   47.488745] Testing event sched_stat_iowait: OK
[   47.599901] Testing event sched_stat_sleep: OK
[   47.732443] Testing event sched_stat_wait: OK
[   47.842872] Testing event sched_process_exec: OK
[   47.993684] Testing event sched_process_fork: OK
[   48.159951] Testing event sched_process_wait: OK
[   48.268385] Testing event sched_wait_task: OK
[   48.351042] Testing event sched_process_exit: OK
[   48.448278] Testing event sched_process_free: OK
[   48.556986] Testing event sched_migrate_task: OK
[   48.668749] Testing event sched_switch: OK
[   48.737768] Testing event sched_wakeup_new: OK
[   48.866495] Testing event sched_wakeup: OK
[   48.967172] Testing event sched_kthread_stop_ret: OK
[   49.147227] Testing event sched_kthread_stop: OK
[   49.266436] Testing event console: OK
[   49.409814] Testing event rcu_barrier: OK
[   49.556780] Testing event rcu_torture_read: OK
[   49.687898] Testing event rcu_batch_end: OK
[   49.828108] Testing event rcu_invoke_kfree_callback: OK
[   49.898840] Testing event rcu_invoke_callback: OK
[   50.006711] Testing event rcu_batch_start: OK
[   50.218010] Testing event rcu_kfree_callback: OK
[   50.370887] Testing event rcu_callback: OK
[   50.494185] Testing event rcu_prep_idle: OK
[   50.549064] Testing event rcu_dyntick: OK
[   50.709799] Testing event rcu_fqs: OK
[   50.811234] Testing event rcu_quiescent_state_report: OK
[   50.928124] Testing event rcu_unlock_preempted_task: OK
[   51.074178] Testing event rcu_preempt_task: OK
[   51.229022] Testing event rcu_nocb_wake: OK
[   51.327084] Testing event rcu_grace_period_init: OK
[   51.416184] Testing event rcu_future_grace_period: OK
[   51.528457] Testing event rcu_grace_period: OK
[   51.635150] Testing event rcu_utilization: OK
[   51.708084] Testing event tick_stop: OK
[   51.779943] Testing event itimer_expire: OK
[   51.838586] Testing event itimer_state: OK
[   51.906425] Testing event hrtimer_cancel: OK
[   51.979439] Testing event hrtimer_expire_exit: OK
[   52.064616] Testing event hrtimer_expire_entry: OK
[   52.186806] Testing event hrtimer_start: OK
[   52.266544] Testing event hrtimer_init: OK
[   52.368380] Testing event timer_cancel: OK
[   52.457656] Testing event timer_expire_exit: OK
[   52.526298] Testing event timer_expire_entry: OK
[   52.624036] Testing event timer_start: OK
[   52.739541] Testing event timer_init: OK
[   52.811475] Testing event ftrace_test_filter: OK
[   52.886287] Testing event dev_pm_qos_remove_request: OK
[   52.975798] Testing event dev_pm_qos_update_request: OK
[   53.148463] Testing event dev_pm_qos_add_request: OK
[   53.228673] Testing event pm_qos_update_flags: OK
[   53.315849] Testing event pm_qos_update_target: OK
[   53.376825] Testing event pm_qos_update_request_timeout: OK
[   53.427966] Testing event pm_qos_remove_request: OK
[   53.477819] Testing event pm_qos_update_request: OK
[   53.543177] Testing event pm_qos_add_request: OK
[   53.595718] Testing event power_domain_target: OK
[   53.646436] Testing event clock_set_rate: OK
[   53.697613] Testing event clock_disable: OK
[   53.746644] Testing event clock_enable: OK
[   53.797771] Testing event wakeup_source_deactivate: OK
[   53.848856] Testing event wakeup_source_activate: OK
[   53.919794] Testing event suspend_resume: OK
[   54.093707] Testing event device_pm_callback_end: OK
[   54.176082] Testing event device_pm_callback_start: OK
[   54.271767] Testing event cpu_frequency: OK
[   54.374482] Testing event pstate_sample: OK
[   54.479059] Testing event cpu_idle: OK
[   54.631431] Testing event rpm_return_int: OK
[   54.839979] Testing event rpm_idle: OK
[   54.973202] Testing event rpm_resume: OK
[   55.085786] Testing event rpm_suspend: OK
[   55.172549] Testing event benchmark_event: OK
[   55.327571] Testing event user_exit: OK
[   55.414172] Testing event user_enter: OK
[   55.497906] Testing event mm_filemap_add_to_page_cache: OK
[   55.622700] Testing event mm_filemap_delete_from_page_cache: OK
[   55.718028] Testing event oom_score_adj_update: OK
[   55.834704] Testing event mm_lru_activate: OK
[   55.919674] Testing event mm_lru_insertion: OK
[   55.993981] Testing event mm_vmscan_lru_shrink_inactive: OK
[   56.128370] Testing event mm_vmscan_writepage: OK
[   56.243097] Testing event mm_vmscan_memcg_isolate: OK
[   56.416656] Testing event mm_vmscan_lru_isolate: OK
[   56.586098] Testing event mm_shrink_slab_end: OK
[   56.638683] Testing event mm_shrink_slab_start: OK
[   56.697618] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[   56.763855] Testing event mm_vmscan_memcg_reclaim_end: OK
[   56.919655] Testing event mm_vmscan_direct_reclaim_end: OK
[   57.139778] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[   57.274519] Testing event mm_vmscan_memcg_reclaim_begin: OK
[   57.349317] Testing event mm_vmscan_direct_reclaim_begin: OK
[   57.552446] Testing event mm_vmscan_wakeup_kswapd: OK
[   57.693219] Testing event mm_vmscan_kswapd_wake: OK
[   57.848291] Testing event mm_vmscan_kswapd_sleep: OK
[   58.129143] Testing event mm_page_alloc_extfrag: OK
[   58.275648] Testing event mm_page_pcpu_drain: OK
[   58.408426] Testing event mm_page_alloc_zone_locked: OK
[   58.589852] Testing event mm_page_alloc: OK
[   58.750032] Testing event mm_page_free_batched: OK
[   58.895658] Testing event mm_page_free: OK
[   59.087187] Testing event kmem_cache_free: OK
[   59.209355] Testing event kfree: OK
[   59.367952] Testing event kmem_cache_alloc_node: OK
[   59.495822] Testing event kmalloc_node: OK
[   59.667106] Testing event kmem_cache_alloc: OK
[   59.818352] Testing event kmalloc: OK
[   59.919889] Testing event mm_compaction_end: OK
[   60.087411] Testing event mm_compaction_begin: OK
[   60.254686] Testing event mm_compaction_migratepages: OK
[   60.428233] Testing event mm_compaction_isolate_freepages: OK
[   60.513567] Testing event mm_compaction_isolate_migratepages: OK
[   60.625848] Testing event mm_numa_migrate_ratelimit: OK
[   60.739784] Testing event mm_migrate_pages: OK
[   60.853180] Testing event writeback_single_inode: OK
[   60.918308] Testing event writeback_single_inode_start: OK
[   61.028357] Testing event writeback_wait_iff_congested: OK
[   61.113045] Testing event writeback_congestion_wait: OK
[   61.165650] Testing event writeback_sb_inodes_requeue: OK
[   61.226391] Testing event balance_dirty_pages: OK
[   61.309337] Testing event bdi_dirty_ratelimit: OK
[   61.377742] Testing event global_dirty_state: OK
[   61.483449] Testing event writeback_queue_io: OK
[   61.547106] Testing event wbc_writepage: OK
[   61.601716] Testing event writeback_bdi_unregister: OK
[   61.681741] Testing event writeback_bdi_register: OK
[   61.785834] Testing event writeback_wake_background: OK
[   61.876071] Testing event writeback_nowork: OK
[   62.011662] Testing event writeback_pages_written: OK
[   62.076483] Testing event writeback_wait: OK
[   62.135758] Testing event writeback_written: OK
[   62.218090] Testing event writeback_start: OK
[   62.292391] Testing event writeback_exec: OK
[   62.407052] Testing event writeback_queue: OK
[   62.548437] Testing event writeback_write_inode: OK
[   62.666956] Testing event writeback_write_inode_start: OK
[   62.787008] Testing event writeback_dirty_inode: OK
[   62.857729] Testing event writeback_dirty_inode_start: OK
[   62.916832] Testing event writeback_dirty_page: OK
[   62.966468] Testing event time_out_leases: OK
[   63.118571] Testing event generic_delete_lease: OK
[   63.268578] Testing event generic_add_lease: OK
[   63.362512] Testing event break_lease_unblock: OK
[   63.418202] Testing event break_lease_block: OK
[   63.477900] Testing event break_lease_noblock: OK
[   63.556029] Testing event ext3_load_inode: OK
[   63.648215] Testing event ext3_get_blocks_exit: OK
[   63.745463] Testing event ext3_get_blocks_enter: OK
[   63.844182] Testing event ext3_truncate_exit: OK
[   64.003616] Testing event ext3_truncate_enter:=20
[   64.123553] Writes:  Total: 4  Max/Min: 0/0   Fail: 0=20
[   64.149471] OK
[   64.152019] Testing event ext3_unlink_exit: OK
[   64.309672] Testing event ext3_unlink_enter: OK
[   64.447350] Testing event ext3_direct_IO_exit: OK
[   64.569117] Testing event ext3_direct_IO_enter: OK
[   64.641057] Testing event ext3_read_block_bitmap: OK
[   64.729445] Testing event ext3_forget: OK
[   64.807559] Testing event ext3_reserved: OK
[   65.006428] Testing event ext3_alloc_new_reservation: OK
[   65.127503] Testing event ext3_discard_reservation: OK
[   65.239834] Testing event ext3_rsv_window_add: OK
[   65.324404] Testing event ext3_sync_fs: OK
[   65.426233] Testing event ext3_sync_file_exit: OK
[   65.537786] Testing event ext3_sync_file_enter: OK
[   65.613197] Testing event ext3_free_blocks: OK
[   65.679198] Testing event ext3_allocate_blocks: OK
[   65.763372] Testing event ext3_request_blocks: OK
[   65.851620] Testing event ext3_discard_blocks: OK
[   65.936743] Testing event ext3_invalidatepage: OK
[   65.989257] Testing event ext3_releasepage: OK
[   66.093709] Testing event ext3_readpage: OK
[   66.170366] Testing event ext3_journalled_writepage: OK
[   66.264051] Testing event ext3_writeback_writepage: OK
[   66.366497] Testing event ext3_ordered_writepage: OK
[   66.447230] Testing event ext3_journalled_write_end: OK
[   66.541289] Testing event ext3_writeback_write_end: OK
[   66.648646] Testing event ext3_ordered_write_end: OK
[   66.723582] Testing event ext3_write_begin: OK
[   66.803221] Testing event ext3_mark_inode_dirty: OK
[   66.891763] Testing event ext3_drop_inode: OK
[   66.986437] Testing event ext3_evict_inode: OK
[   67.068087] Testing event ext3_allocate_inode: OK
[   67.147482] Testing event ext3_request_inode: OK
[   67.249217] Testing event ext3_free_inode: OK
[   67.334752] Testing event ext4_es_shrink: OK
[   67.414575] Testing event ext4_collapse_range: OK
[   67.511324] Testing event ext4_es_shrink_scan_exit: OK
[   67.669072] Testing event ext4_es_shrink_scan_enter: OK
[   67.752989] Testing event ext4_es_shrink_count: OK
[   67.821796] Testing event ext4_es_lookup_extent_exit: OK
[   67.948599] Testing event ext4_es_lookup_extent_enter: OK
[   68.010780] Testing event ext4_es_find_delayed_extent_range_exit: OK
[   68.089866] Testing event ext4_es_find_delayed_extent_range_enter: OK
[   68.177664] Testing event ext4_es_remove_extent: OK
[   68.338893] Testing event ext4_es_cache_extent: OK
[   68.458404] Testing event ext4_es_insert_extent: OK
[   68.577984] Testing event ext4_ext_remove_space_done: OK
[   68.788996] Testing event ext4_ext_remove_space: OK
[   68.969515] Testing event ext4_ext_rm_idx: OK
[   69.089766] Testing event ext4_ext_rm_leaf: OK
[   69.226163] Testing event ext4_remove_blocks: OK
[   69.334974] Testing event ext4_ext_show_extent: OK
[   69.421836] Testing event ext4_get_reserved_cluster_alloc: OK
[   69.577511] Testing event ext4_find_delalloc_range: OK
[   69.679398] Testing event ext4_ext_in_cache: OK
[   69.809155] Testing event ext4_ext_put_in_cache: OK
[   69.938538] Testing event ext4_get_implied_cluster_alloc_exit: OK
[   70.129801] Testing event ext4_ext_handle_unwritten_extents: OK
[   70.277128] Testing event ext4_trim_all_free: OK
[   70.445768] Testing event ext4_trim_extent: OK
[   70.588741] Testing event ext4_journal_start_reserved: OK
[   70.738462] Testing event ext4_journal_start: OK
[   70.875640] Testing event ext4_load_inode: OK
[   71.016441] Testing event ext4_ext_load_extent: OK
[   71.138498] Testing event ext4_ind_map_blocks_exit: OK
[   71.241497] Testing event ext4_ext_map_blocks_exit: OK
[   71.378556] Testing event ext4_ind_map_blocks_enter: OK
[   71.483933] Testing event ext4_ext_map_blocks_enter: OK
[   71.627594] Testing event ext4_ext_convert_to_initialized_fastpath: OK
[   71.734139] Testing event ext4_ext_convert_to_initialized_enter: OK
[   71.834810] Testing event ext4_truncate_exit: OK
[   72.004846] Testing event ext4_truncate_enter: OK
[   72.128134] Testing event ext4_unlink_exit: OK
[   72.298323] Testing event ext4_unlink_enter: OK
[   72.426659] Testing event ext4_fallocate_exit: OK
[   72.580031] Testing event ext4_zero_range: OK
[   72.737571] Testing event ext4_punch_hole: OK
[   72.886531] Testing event ext4_fallocate_enter: OK
[   72.993623] Testing event ext4_direct_IO_exit: OK
[   73.146285] Testing event ext4_direct_IO_enter: OK
[   73.269688] Testing event ext4_load_inode_bitmap: OK
[   73.405402] Testing event ext4_read_block_bitmap_load: OK
[   73.479392] Testing event ext4_mb_buddy_bitmap_load: OK
[   73.525953] Testing event ext4_mb_bitmap_load: OK
[   73.675659] Testing event ext4_da_release_space: OK
[   73.726280] Testing event ext4_da_reserve_space: OK
[   73.775897] Testing event ext4_da_update_reserve_space: OK
[   73.933437] Testing event ext4_forget: OK
[   74.032668] Testing event ext4_mballoc_free: OK
[   74.157724] Testing event ext4_mballoc_discard: OK
[   74.348534] Testing event ext4_mballoc_prealloc: OK
[   74.497689] Testing event ext4_mballoc_alloc: OK
[   74.558980] Testing event ext4_alloc_da_blocks: OK
[   74.698008] Testing event ext4_sync_fs: OK
[   74.833997] Testing event ext4_sync_file_exit: OK
[   74.967447] Testing event ext4_sync_file_enter: OK
[   75.078861] Testing event ext4_free_blocks: OK
[   75.207939] Testing event ext4_allocate_blocks: OK
[   75.343873] Testing event ext4_request_blocks: OK
[   75.496439] Testing event ext4_mb_discard_preallocations: OK
[   75.609931] Testing event ext4_discard_preallocations: OK
[   75.741816] Testing event ext4_mb_release_group_pa: OK
[   75.845210] Testing event ext4_mb_release_inode_pa: OK
[   75.970877] Testing event ext4_mb_new_group_pa: OK
[   76.145388] Testing event ext4_mb_new_inode_pa: OK
[   76.299662] Testing event ext4_discard_blocks: OK
[   76.469964] Testing event ext4_journalled_invalidatepage: OK
[   76.589419] Testing event ext4_invalidatepage: OK
[   76.748823] Testing event ext4_releasepage: OK
[   76.916482] Testing event ext4_readpage: OK
[   77.109936] Testing event ext4_writepage: OK
[   77.307219] Testing event ext4_writepages_result: OK
[   77.454836] Testing event ext4_da_write_pages_extent: OK
[   77.643761] Testing event ext4_da_write_pages: OK
[   77.787903] Testing event ext4_writepages: OK
[   77.938888] Testing event ext4_da_write_end: OK
[   78.017521] Testing event ext4_journalled_write_end: OK
[   78.194722] Testing event ext4_write_end: OK
[   78.338592] Testing event ext4_da_write_begin: OK
[   78.484765] Testing event ext4_write_begin: OK
[   78.609571] Testing event ext4_begin_ordered_truncate: OK
[   78.761209] Testing event ext4_mark_inode_dirty: OK
[   78.913732] Testing event ext4_drop_inode: OK
[   79.068213] Testing event ext4_evict_inode: OK
[   79.166263] Testing event ext4_allocate_inode: OK
[   79.247129] Testing event ext4_request_inode: OK
[   79.387005] Testing event ext4_free_inode: OK
[   79.527849] Testing event journal_write_superblock: OK
[   79.676797] Testing event jbd_cleanup_journal_tail: OK
[   79.877055] Testing event jbd_do_submit_data: OK
[   80.078973] Testing event jbd_end_commit: OK
[   80.201978] Testing event jbd_drop_transaction: OK
[   80.313868] Testing event jbd_commit_logging: OK
[   80.468465] Testing event jbd_commit_flushing: OK
[   80.616737] Testing event jbd_commit_locking: OK
[   80.755033] Testing event jbd_start_commit: OK
[   80.875114] Testing event jbd_checkpoint: OK
[   81.027535] Testing event jbd2_lock_buffer_stall: OK
[   81.156121] Testing event jbd2_write_superblock: OK
[   81.337380] Testing event jbd2_update_log_tail: OK
[   81.458668] Testing event jbd2_checkpoint_stats: OK
[   81.588759] Testing event jbd2_run_stats: OK
[   81.732544] Testing event jbd2_handle_stats: OK
[   81.886792] Testing event jbd2_handle_extend: OK
[   82.068594] Testing event jbd2_handle_start: OK
[   82.198197] Testing event jbd2_submit_inode_data: OK
[   82.337381] Testing event jbd2_end_commit: OK
[   82.415289] Testing event jbd2_drop_transaction: OK
[   82.475134] Testing event jbd2_commit_logging: OK
[   82.525916] Testing event jbd2_commit_flushing: OK
[   82.586871] Testing event jbd2_commit_locking: OK
[   82.646838] Testing event jbd2_start_commit: OK
[   82.698119] Testing event jbd2_checkpoint: OK
[   82.745558] Testing event btrfs_qgroup_record_ref: OK
[   82.799474] Testing event btrfs_qgroup_account: OK
[   82.849001] Testing event btrfs_workqueue_destroy: OK
[   82.900906] Testing event btrfs_workqueue_alloc: OK
[   82.949462] Testing event btrfs_ordered_sched: OK
[   83.029641] Testing event btrfs_all_work_done: OK
[   83.259075] Testing event btrfs_work_sched: OK
[   83.458043] Testing event btrfs_work_queued: OK
[   83.578250] Testing event free_extent_state: OK
[   83.778946] Testing event alloc_extent_state: OK
[   83.976852] Testing event btrfs_setup_cluster: OK
[   84.128256] Testing event btrfs_failed_cluster_setup: OK
[   84.267373] Testing event btrfs_find_cluster: OK
[   84.316197] Testing event btrfs_reserve_extent_cluster: OK
[   84.370937] Testing event btrfs_reserve_extent: OK
[   84.504993] Testing event find_free_extent: OK
[   84.625641] Testing event btrfs_reserved_extent_free: OK
[   84.835524] Testing event btrfs_reserved_extent_alloc: OK
[   84.978323] Testing event btrfs_space_reservation: OK
[   85.332843] Testing event btrfs_cow_block: OK
[   85.469653] Testing event btrfs_chunk_free: OK
[   85.586781] Testing event btrfs_chunk_alloc: OK
[   85.725558] Testing event run_delayed_ref_head: OK
[   85.911044] Testing event add_delayed_ref_head: OK
[   85.975998] Testing event run_delayed_data_ref: OK
[   86.178244] Testing event add_delayed_data_ref: OK
[   86.380856] Testing event run_delayed_tree_ref: OK
[   86.563032] Testing event add_delayed_tree_ref: OK
[   86.719198] Testing event btrfs_sync_fs: OK
[   86.879073] Testing event btrfs_sync_file: OK
[   87.014567] Testing event btrfs_writepage_end_io_hook: OK
[   87.167195] Testing event __extent_writepage: OK
[   87.296725] Testing event btrfs_ordered_extent_put: OK
[   87.449975] Testing event btrfs_ordered_extent_start: OK
[   87.623529] Testing event btrfs_ordered_extent_remove: OK
[   87.785350] Testing event btrfs_ordered_extent_add: OK
[   87.967330] Testing event btrfs_get_extent: OK
[   88.157331] Testing event btrfs_inode_evict: OK
[   88.309800] Testing event btrfs_inode_request: OK
[   88.429971] Testing event btrfs_inode_new: OK
[   88.596991] Testing event btrfs_transaction_commit: OK
[   88.794211] Testing event block_rq_remap: OK
[   88.938008] Testing event block_bio_remap: OK
[   89.149956] Testing event block_split: OK
[   89.258414] Testing event block_unplug: OK
[   89.415177] Testing event block_plug: OK
[   89.633044] Testing event block_sleeprq: OK
[   89.803970] Testing event block_getrq: OK
[   89.942617] Testing event block_bio_queue: OK
[   90.083663] Testing event block_bio_frontmerge: OK
[   90.229574] Testing event block_bio_backmerge: OK
[   90.435899] Testing event block_bio_complete: OK
[   90.638332] Testing event block_bio_bounce: OK
[   90.789446] Testing event block_rq_issue: OK
[   90.955806] Testing event block_rq_insert: OK
[   91.129140] Testing event block_rq_complete: OK
[   91.306242] Testing event block_rq_requeue: OK
[   91.432616] Testing event block_rq_abort: OK
[   91.611401] Testing event block_dirty_buffer: OK
[   91.725396] Testing event block_touch_buffer: OK
[   91.884355] Testing event swiotlb_bounced: OK
[   92.089811] Testing event gpio_value: OK
[   92.228808] Testing event gpio_direction: OK
[   92.388208] Testing event regulator_set_voltage_complete: OK
[   92.528519] Testing event regulator_set_voltage: OK
[   92.691010] Testing event regulator_disable_complete: OK
[   92.836825] Testing event regulator_disable: OK
[   92.909953] Testing event regulator_enable_complete: OK
[   93.155713] Testing event regulator_enable_delay: OK
[   93.256799] Testing event regulator_enable: OK
[   93.423660] Testing event urandom_read: OK
[   93.637983] Testing event random_read: OK
[   93.814149] Testing event extract_entropy_user: OK
[   93.978404] Testing event extract_entropy: OK
[   94.189478] Testing event get_random_bytes_arch: OK
[   94.338612] Testing event get_random_bytes: OK
[   94.478351] Testing event xfer_secondary_pool: OK
[   94.677998] Testing event add_disk_randomness: OK
[   94.845510] Testing event add_input_randomness: OK
[   94.931487] Testing event debit_entropy: OK
[   95.116857] Testing event push_to_pool: OK
[   95.256688] Testing event credit_entropy_bits: OK
[   95.471819] Testing event mix_pool_bytes_nolock: OK
[   95.668351] Testing event mix_pool_bytes: OK
[   95.808042] Testing event add_device_randomness: OK
[   95.978686] Testing event drm_vblank_event_delivered: OK
[   96.199709] Testing event drm_vblank_event_queued: OK
[   96.378937] Testing event drm_vblank_event: OK
[   96.518698] Testing event radeon_semaphore_wait: OK
[   96.656399] Testing event radeon_semaphore_signale: OK
[   96.855596] Testing event radeon_fence_wait_end: OK
[   96.969490] Testing event radeon_fence_wait_begin: OK
[   97.061802] Testing event radeon_fence_emit: OK
[   97.248138] Testing event radeon_vm_flush: OK
[   97.448988] Testing event radeon_vm_set_page: OK
[   97.556144] Testing event radeon_vm_bo_update: OK
[   97.645098] Testing event radeon_vm_grab_id: OK
[   97.809624] Testing event radeon_cs: OK
[   97.996782] Testing event radeon_bo_create: OK
[   98.159280] Testing event regcache_drop_region: OK
[   98.276609] Testing event regmap_async_complete_done: OK
[   98.509538] Testing event regmap_async_complete_start: OK
[   98.649652] Testing event regmap_async_io_complete: OK
[   98.812502] Testing event regmap_async_write_start: OK
[   99.034978] Testing event regmap_cache_bypass: OK
[   99.198987] Testing event regmap_cache_only: OK
[   99.367345] Testing event regcache_sync: OK
[   99.498427] Testing event regmap_hw_write_done: OK
[   99.586590] Testing event regmap_hw_write_start: OK
[   99.787657] Testing event regmap_hw_read_done: OK
[   99.929136] Testing event regmap_hw_read_start: OK
[  100.093361] Testing event regmap_reg_read_cache: OK
[  100.236169] Testing event regmap_reg_read: OK
[  100.418891] Testing event regmap_reg_write: OK
[  100.619144] Testing event fence_wait_end: OK
[  100.761101] Testing event fence_wait_start: OK
[  100.887407] Testing event fence_signaled: OK
[  101.078821] Testing event fence_enable_signal: OK
[  101.242153] Testing event fence_destroy: OK
[  101.417691] Testing event fence_init: OK
[  101.578299] Testing event fence_emit: OK
[  101.749748] Testing event fence_annotate_wait_on: OK
[  101.879806] Testing event scsi_eh_wakeup: OK
[  101.996113] Testing event scsi_dispatch_cmd_timeout: OK
[  102.229681] Testing event scsi_dispatch_cmd_done: OK
[  102.371367] Testing event scsi_dispatch_cmd_error: OK
[  102.548056] Testing event scsi_dispatch_cmd_start: OK
[  102.739170] Testing event target_cmd_complete: OK
[  102.947468] Testing event target_sequencer_start: OK
[  103.098973] Testing event spi_transfer_stop: OK
[  103.266721] Testing event spi_transfer_start: OK
[  103.425711] Testing event spi_message_done: OK
[  103.588915] Testing event spi_message_start: OK
[  103.746083] Testing event spi_message_submit: OK
[  103.921973] Testing event spi_master_busy: OK
[  104.049351] Testing event spi_master_idle: OK
[  104.185831] Testing event smbus_result: OK
[  104.360597] Testing event smbus_reply: OK
[  104.557146] Testing event smbus_read: OK
[  104.747349] Testing event smbus_write: OK
[  104.841800] Testing event i2c_result: OK
[  104.934857] Testing event i2c_reply: OK
[  105.037182] Testing event i2c_read: OK
[  105.247917] Testing event i2c_write: OK
[  105.413885] Testing event thermal_zone_trip: OK
[  105.573721] Testing event cdev_update: OK
[  105.737302] Testing event thermal_temperature: OK
[  105.932321] Testing event bcache_writeback_collision: OK
[  106.156384] Testing event bcache_writeback: OK
[  106.326109] Testing event bcache_alloc_fail: OK
[  106.553061] Testing event bcache_alloc: OK
[  106.685556] Testing event bcache_invalidate: OK
[  106.858917] Testing event bcache_keyscan: OK
[  107.016772] Testing event bcache_btree_set_root: OK
[  107.188048] Testing event bcache_btree_node_compact: OK
[  107.389553] Testing event bcache_btree_node_split: OK
[  107.564469] Testing event bcache_btree_insert_key: OK
[  107.698752] Testing event bcache_gc_copy_collision: OK
[  107.842049] Testing event bcache_gc_copy: OK
[  108.078345] Testing event bcache_gc_end: OK
[  108.202194] Testing event bcache_gc_start: OK
[  108.409195] Testing event bcache_btree_gc_coalesce: OK
[  108.657162] Testing event bcache_btree_node_free: OK
[  108.775644] Testing event bcache_btree_node_alloc_fail: OK
[  108.997595] Testing event bcache_btree_node_alloc: OK
[  109.091612] Testing event bcache_btree_write: OK
[  109.218750] Testing event bcache_btree_read: OK
[  109.373356] Testing event bcache_btree_cache_cannibalize: OK
[  109.536215] Testing event bcache_journal_write: OK
[  109.707033] Testing event bcache_journal_entry_full: OK
[  109.825502] Testing event bcache_journal_full: OK
[  109.974890] Testing event bcache_journal_replay_key: OK
[  110.168444] Testing event bcache_cache_insert: OK
[  110.308988] Testing event bcache_read_retry: OK
[  110.460781] Testing event bcache_write: OK
[  110.654655] Testing event bcache_read: OK
[  110.814657] Testing event bcache_bypass_congested: OK
[  110.947804] Testing event bcache_bypass_sequential: OK
[  111.109567] Testing event bcache_request_end: OK
[  111.288799] Testing event bcache_request_start: OK
[  111.468265] Testing event aer_event: OK
[  111.585441] Testing event mc_event: OK
[  111.757953] Testing event hda_unsol_event: OK
[  111.949811] Testing event hda_power_count: OK
[  112.142606] Testing event hda_power_up: OK
[  112.329695] Testing event hda_power_down: OK
[  112.496296] Testing event hda_bus_reset: OK
[  112.621017] Testing event hda_get_response: OK
[  112.829106] Testing event hda_send_cmd: OK
[  112.976382] Testing event azx_get_position: OK
[  113.124090] Testing event azx_pcm_trigger: OK
[  113.356127] Testing event udp_fail_queue_rcv_skb: OK
[  113.527346] Testing event sock_exceed_buf_limit: OK
[  113.667747] Testing event sock_rcvqueue_full: OK
[  113.839735] Testing event napi_poll: OK
[  114.017549] Testing event netif_rx_ni_entry: OK
[  114.226957] Testing event netif_rx_entry: OK
[  114.368482] Testing event netif_receive_skb_entry: OK
[  114.618799] Testing event napi_gro_receive_entry: OK
[  114.789405] Testing event napi_gro_frags_entry: OK
[  114.936028] Testing event netif_rx: OK
[  115.067383] Testing event netif_receive_skb: OK
[  115.226959] Testing event net_dev_queue: OK
[  115.379661] Testing event net_dev_xmit: OK
[  115.517885] Testing event net_dev_start_xmit: OK
[  115.667933] Testing event skb_copy_datagram_iovec: OK
[  115.848172] Testing event consume_skb: OK
[  115.965181] Testing event kfree_skb: OK
[  116.127567] Running tests on trace event systems:
[  116.129351] Testing event system skb: OK
[  116.419927] Testing event system net: OK
[  116.677962] Testing event system napi: OK
[  116.846641] Testing event system sock: OK
[  117.009836] Testing event system udp: OK
[  117.076466] Testing event system hda_intel: OK
[  117.246670] Testing event system hda: OK
[  117.467581] Testing event system ras: OK
[  117.643415] Testing event system bcache: OK
[  118.087230] Testing event system thermal: OK
[  118.297803] Testing event system i2c: OK
[  118.538159] Testing event system spi: OK
[  118.762806] Testing event system target: OK
[  118.975076] Testing event system scsi: OK
[  119.177031] Testing event system fence: OK
[  119.417797] Testing event system regmap: OK
[  119.838818] Testing event system radeon: OK
[  120.151629] Testing event system drm: OK
[  120.314993] Testing event system random: OK
[  120.595380] Testing event system regulator: OK
[  120.807262] Testing event system gpio: OK
[  121.078908] Testing event system swiotlb: OK
[  121.206009] Testing event system block: OK
[  121.504842] Testing event system btrfs: OK
[  122.281992] Testing event system jbd2: OK
[  122.597252] Testing event system jbd: OK
[  122.915237] Testing event system ext4: OK
[  123.585358] Testing event system ext3: OK
[  123.764934] Testing event system filelock: OK
[  123.842034] Testing event system writeback: OK
[  123.998625] Testing event system migrate:=20
[  124.123762] Writes:  Total: 4  Max/Min: 0/0   Fail: 0=20
[  124.138935] OK
[  124.143567] Testing event system compaction: OK
[  124.259797] Testing event system kmem: OK
[  124.390639] Testing event system vmscan: OK
[  124.535022] Testing event system pagemap: OK
[  124.621830] Testing event system oom: OK
[  124.801618] Testing event system filemap: OK
[  124.896254] Testing event system context_tracking: OK
[  124.998434] Testing event system benchmark: OK
[  125.193134] Testing event system rpm: OK
[  125.377600] Testing event system power: OK
[  125.656833] Testing event system test: OK
[  125.847686] Testing event system timer: OK
[  126.156378] Testing event system rcu: OK
[  126.502638] Testing event system printk: OK
[  126.642311] Testing event system sched: OK
[  126.853768] Testing event system workqueue: OK
[  126.951796] Testing event system signal: OK
[  127.093863] Testing event system irq: OK
[  127.196102] Testing event system task: OK
[  127.290245] Testing event system exceptions: OK
[  127.385575] Testing event system tlb: OK
[  127.525613] Testing event system ipi: OK
[  127.652935] Testing event system raw_syscalls: OK
[  127.717257] Testing event system vsyscall: OK
[  127.787555] Testing event system nmi: OK
[  127.849852] Testing event system irq_vectors: OK
[  128.125948] Running tests on all trace events:
[  128.129835] Testing all events: OK
[  133.700477] Testing ftrace filter: OK
[  133.896050] Btrfs loaded, assert=3Don
[  133.897396] BTRFS: selftest: Running btrfs free space cache tests
[  133.899024] BTRFS: selftest: Running extent only tests
[  133.913931] BTRFS: selftest: Running bitmap only tests
[  133.915599] BTRFS: selftest: Running bitmap and extent tests
[  133.917327] BTRFS: selftest: Running space stealing from bitmap to extent
[  133.919744] BTRFS: selftest: Free space cache tests finished
[  133.921356] BTRFS: selftest: Running extent buffer operation tests
[  133.922658] BTRFS: selftest: Running btrfs_split_item tests
[  133.924827] BTRFS: selftest: Running find delalloc tests
[  184.122769] Writes:  Total: 4  Max/Min: 0/0   Fail: 0=20
[  245.451282] lock_torture_st invoked oom-killer: gfp_mask=3D0x40d0, order=
=3D2, oom_score_adj=3D0
[  245.453757] lock_torture_st cpuset=3D/ mems_allowed=3D0
[  245.455518] CPU: 1 PID: 54 Comm: lock_torture_st Not tainted 3.18.0-rc2-=
ge754569 #509
[  245.457842] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.7.5-20140531_083030-gandalf 04/01/2014
[  245.460739]  0000000000000000 ffff88000bb2fae8 ffffffff82d77375 00000000=
00000000
[  245.463635]  0000000000000000 ffff88000bb2fb68 ffffffff82d7156c ffff8800=
0bb2fbc8
[  245.466528]  0000000000000000 ffff88000bb2fb58 0000000000000000 ffff8800=
108ec000
[  245.469427] Call Trace:
[  245.470545]  [<ffffffff82d77375>] dump_stack+0xc5/0x175
[  245.472060]  [<ffffffff82d7156c>] dump_header+0xbe/0x363
[  245.473717]  [<ffffffff812ec62b>] out_of_memory+0x9bb/0x9e0
[  245.475312]  [<ffffffff812f994c>] __alloc_pages_nodemask+0x1cec/0x1e80
[  245.477083]  [<ffffffff811eeb88>] ? try_to_del_timer_sync+0x98/0xb0
[  245.478814]  [<ffffffff81371e4a>] alloc_pages_current+0x21a/0x2a0
[  245.480595]  [<ffffffff812f0f6e>] alloc_kmem_pages+0x1e/0x30
[  245.482201]  [<ffffffff813294f0>] kmalloc_order+0x20/0x70
[  245.483762]  [<ffffffff8132956c>] kmalloc_order_trace+0x2c/0x1d0
[  245.485440]  [<ffffffff81382352>] __kmalloc+0x92/0x6b0
[  245.486938]  [<ffffffff811ea1e0>] ? internal_add_timer+0x360/0x360
[  245.488647]  [<ffffffff811abd30>] ? lock_torture_cleanup+0x400/0x400
[  245.494715]  [<ffffffff811ab77c>] lock_torture_stats_print+0x7c/0x230
[  245.496479]  [<ffffffff811abd30>] ? lock_torture_cleanup+0x400/0x400
[  245.498216]  [<ffffffff811abd84>] lock_torture_stats+0x54/0xd0
[  245.499858]  [<ffffffff8114a5de>] kthread+0x18e/0x1a0
[  245.501476]  [<ffffffff81150000>] ? __async_schedule+0x80/0x260
[  245.503130]  [<ffffffff8114a450>] ? __kthread_unpark+0xd0/0xd0
[  245.504768]  [<ffffffff82d98b7c>] ret_from_fork+0x7c/0xb0
[  245.506328]  [<ffffffff8114a450>] ? __kthread_unpark+0xd0/0xd0
[  245.508088] Mem-Info:
[  245.509017] Node 0 DMA per-cpu:
[  245.510425] CPU    0: hi:    0, btch:   1 usd:   0
[  245.511842] CPU    1: hi:    0, btch:   1 usd:   0
[  245.513255] Node 0 DMA32 per-cpu:
[  245.514545] CPU    0: hi:   90, btch:  15 usd:  14
[  245.515956] CPU    1: hi:   90, btch:  15 usd:   0
[  245.517397] active_anon:0 inactive_anon:0 isolated_anon:0
[  245.517397]  active_file:1914 inactive_file:26617 isolated_file:0
[  245.517397]  unevictable:16885 dirty:0 writeback:0 unstable:0
[  245.517397]  free:700 slab_reclaimable:6078 slab_unreclaimable:5341
[  245.517397]  mapped:0 shmem:0 pagetables:0 bounce:0
[  245.517397]  free_cma:0
[  245.525543] Node 0 DMA free:1004kB min:128kB low:160kB high:192kB active=
_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:12868kB unevictab=
le:0kB isolated(anon):0kB isolated(file):0kB present:15992kB managed:15908k=
B mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable=
:96kB slab_unreclaimable:700kB kernel_stack:64kB pagetables:0kB unstable:0k=
B bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:85356 all_unrecla=
imable? yes
[  245.535985] lowmem_reserve[]: 0 224 224 224
[  245.538003] Node 0 DMA32 free:1796kB min:1848kB low:2308kB high:2772kB a=
ctive_anon:0kB inactive_anon:0kB active_file:7656kB inactive_file:93600kB u=
nevictable:67540kB isolated(anon):0kB isolated(file):0kB present:311168kB m=
anaged:229488kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB sl=
ab_reclaimable:24216kB slab_unreclaimable:20664kB kernel_stack:992kB pageta=
bles:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scann=
ed:731484 all_unreclaimable? yes
[  245.560132] lowmem_reserve[]: 0 0 0 0
[  245.561963] Node 0 DMA: 1*4kB (R) 1*8kB (R) 0*16kB 1*32kB (R) 1*64kB (R)=
 1*128kB (R) 1*256kB (R) 1*512kB (R) 0*1024kB 0*2048kB 0*4096kB =3D 1004kB
[  245.567848] Node 0 DMA32: 0*4kB 1*8kB (R) 1*16kB (R) 0*32kB 0*64kB 0*128=
kB 1*256kB (R) 1*512kB (R) 1*1024kB (R) 0*2048kB 0*4096kB =3D 1816kB
[  245.583595] 45422 total pagecache pages
[  245.584829] 81790 pages RAM
[  245.585862] 0 pages HighMem/MovableOnly
[  245.587093] 20420 pages reserved
[  245.588207] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_s=
core_adj name
[  245.590672] Kernel panic - not syncing: Out of memory and no killable pr=
ocesses...
[  245.590672]=20
[  245.593560] CPU: 0 PID: 54 Comm: lock_torture_st Not tainted 3.18.0-rc2-=
ge754569 #509
[  245.595889] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.7.5-20140531_083030-gandalf 04/01/2014
[  245.598673]  ffffffff83c7e1c8 ffff88000bb2fae8 ffffffff82d77375 ffffffff=
83aaf958
[  245.600574]  ffffffff83c7e1c8 ffff88000bb2fb68 ffffffff82d70db5 ffff8800=
0bb2fbc8
[  245.600574]  0000000000000008 ffff88000bb2fb78 ffff88000bb2fb18 ffff8800=
108ec000
[  245.600574] Call Trace:
[  245.600574]  [<ffffffff82d77375>] dump_stack+0xc5/0x175
[  245.600574]  [<ffffffff82d70db5>] panic+0x164/0x3e3
[  245.600574]  [<ffffffff812ec641>] out_of_memory+0x9d1/0x9e0
[  245.600574]  [<ffffffff812f994c>] __alloc_pages_nodemask+0x1cec/0x1e80
[  245.600574]  [<ffffffff811eeb88>] ? try_to_del_timer_sync+0x98/0xb0
[  245.600574]  [<ffffffff81371e4a>] alloc_pages_current+0x21a/0x2a0
[  245.600574]  [<ffffffff812f0f6e>] alloc_kmem_pages+0x1e/0x30
[  245.600574]  [<ffffffff813294f0>] kmalloc_order+0x20/0x70
[  245.600574]  [<ffffffff8132956c>] kmalloc_order_trace+0x2c/0x1d0
[  245.600574]  [<ffffffff81382352>] __kmalloc+0x92/0x6b0
[  245.600574]  [<ffffffff811ea1e0>] ? internal_add_timer+0x360/0x360
[  245.600574]  [<ffffffff811abd30>] ? lock_torture_cleanup+0x400/0x400
[  245.600574]  [<ffffffff811ab77c>] lock_torture_stats_print+0x7c/0x230
[  245.600574]  [<ffffffff811abd30>] ? lock_torture_cleanup+0x400/0x400
[  245.600574]  [<ffffffff811abd84>] lock_torture_stats+0x54/0xd0
[  245.600574]  [<ffffffff8114a5de>] kthread+0x18e/0x1a0
[  245.600574]  [<ffffffff81150000>] ? __async_schedule+0x80/0x260
[  245.600574]  [<ffffffff8114a450>] ? __kthread_unpark+0xd0/0xd0
[  245.600574]  [<ffffffff82d98b7c>] ret_from_fork+0x7c/0xb0
[  245.600574]  [<ffffffff8114a450>] ? __kthread_unpark+0xd0/0xd0
[  245.600574] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range=
: 0xffffffff80000000-0xffffffff9fffffff)

Elapsed time: 255
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-n0-12101521/e754569101f392e1924d8ce6f087ea4cfad91d69/vmlinuz-3.18.0-rc2-ge=
754569 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D=
-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 =
prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=
=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/x86_64-randconfig-n0-121=
01521/linux-devel:devel-lkp-nhm1-smoke-201412101539:e754569101f392e1924d8ce=
6f087ea4cfad91d69:bisect-linux-0/.vmlinuz-e754569101f392e1924d8ce6f087ea4cf=
ad91d69-20141210172745-8-client1 branch=3Dlinux-devel/devel-lkp-nhm1-smoke-=
201412101539 BOOT_IMAGE=3D/kernel/x86_64-randconfig-n0-12101521/e754569101f=
392e1924d8ce6f087ea4cfad91d69/vmlinuz-3.18.0-rc2-ge754569 drbd.minor_count=
=3D8'  -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz -m 320 -smp 2 -=
net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-rebo=
ot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-qua=
ntal-client1-11 -serial file:/dev/shm/kboot/serial-quantal-client1-11 -daem=
onize -display none -monitor null=20

--48TaNjbzBVislYPb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.18.0-rc2-g1fadb58"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.18.0-rc2 Kernel Configuration
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
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
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
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
CONFIG_KERNEL_LZMA=y
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_FHANDLE=y
CONFIG_USELIB=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
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
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
# CONFIG_NO_HZ_FULL_ALL is not set
# CONFIG_NO_HZ_FULL_SYSIDLE is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_TASKS_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_RCU_USER_QS=y
CONFIG_CONTEXT_TRACKING_FORCE=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
CONFIG_RCU_FAST_NO_HZ=y
CONFIG_TREE_RCU_TRACE=y
# CONFIG_RCU_BOOST is not set
CONFIG_RCU_NOCB_CPU=y
# CONFIG_RCU_NOCB_CPU_NONE is not set
# CONFIG_RCU_NOCB_CPU_ZERO is not set
CONFIG_RCU_NOCB_CPU_ALL=y
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
# CONFIG_NUMA_BALANCING is not set
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SCHED_IO_LATENCY is not set
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
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
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
CONFIG_ADVISE_SYSCALLS=y
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
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
CONFIG_UPROBES=y
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
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
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
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
CONFIG_GCOV_FORMAT_AUTODETECT=y
# CONFIG_GCOV_FORMAT_3_4 is not set
# CONFIG_GCOV_FORMAT_4_7 is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
CONFIG_QUEUE_RWLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_VSMP=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_IOSF_MBI is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=12
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
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
# CONFIG_I8K is not set
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
# CONFIG_AMD_NUMA is not set
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
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
CONFIG_MOVABLE_NODE=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
CONFIG_ZPOOL=y
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
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
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
CONFIG_DEBUG_HOTPLUG_CPU0=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_CPU_IDLE_GOV_SELECT=y
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
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
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
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=y
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=y
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
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
CONFIG_X86_X32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_X86_DEV_DMA_OPS=y
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
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_HSR is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

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
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
# CONFIG_UEVENT_HELPER is not set
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_FENCE_TRACE is not set

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=y
# CONFIG_BLK_DEV_FD is not set
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

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
CONFIG_BLK_DEV_SKD=y
CONFIG_BLK_DEV_SX8=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=y
CONFIG_BLK_DEV_HD=y
CONFIG_BLK_DEV_RSXX=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_AD525X_DPOT_SPI=y
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
CONFIG_ICS932S401=y
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=y
CONFIG_VMWARE_BALLOON=y
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_BMP085_SPI is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_LATTICE_ECP3_CONFIG=y
CONFIG_SRAM=y
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_93XX46 is not set
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
CONFIG_INTEL_MEI_TXE=y
CONFIG_VMWARE_VMCI=y

#
# Intel MIC Bus Driver
#
CONFIG_INTEL_MIC_BUS=y

#
# Intel MIC Host Driver
#
CONFIG_INTEL_MIC_HOST=y

#
# Intel MIC Card Driver
#
CONFIG_INTEL_MIC_CARD=y
CONFIG_GENWQE=y
CONFIG_GENWQE_PLATFORM_ERROR_RECOVERY=0
CONFIG_ECHO=y
# CONFIG_CXL_BASE is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_MQ_DEFAULT=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_ENCLOSURE is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BE2ISCSI is not set
CONFIG_BLK_DEV_3W_XXXX_RAID=y
# CONFIG_SCSI_HPSA is not set
CONFIG_SCSI_3W_9XXX=y
CONFIG_SCSI_3W_SAS=y
CONFIG_SCSI_ACARD=y
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
CONFIG_SCSI_ADVANSYS=y
# CONFIG_SCSI_ARCMSR is not set
CONFIG_SCSI_ESAS2R=y
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS_LOGGING=y
CONFIG_SCSI_MPT3SAS=y
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
# CONFIG_SCSI_MPT3SAS_LOGGING is not set
CONFIG_SCSI_UFSHCD=y
CONFIG_SCSI_UFSHCD_PCI=y
# CONFIG_SCSI_UFSHCD_PLATFORM is not set
# CONFIG_SCSI_HPTIOP is not set
CONFIG_SCSI_BUSLOGIC=y
CONFIG_SCSI_FLASHPOINT=y
CONFIG_VMWARE_PVSCSI=y
CONFIG_SCSI_DMX3191D=y
CONFIG_SCSI_EATA=y
# CONFIG_SCSI_EATA_TAGGED_QUEUE is not set
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=y
# CONFIG_SCSI_GDTH is not set
CONFIG_SCSI_ISCI=y
# CONFIG_SCSI_IPS is not set
CONFIG_SCSI_INITIO=y
CONFIG_SCSI_INIA100=y
CONFIG_SCSI_STEX=y
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
CONFIG_SCSI_QLOGIC_1280=y
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
CONFIG_SCSI_DEBUG=y
# CONFIG_SCSI_PMCRAID is not set
CONFIG_SCSI_PM8001=y
CONFIG_SCSI_VIRTIO=y
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
# CONFIG_SCSI_OSD_INITIATOR is not set
# CONFIG_ATA is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_AUTODETECT is not set
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
# CONFIG_MD_MULTIPATH is not set
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
# CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
CONFIG_DM_CRYPT=y
# CONFIG_DM_SNAPSHOT is not set
# CONFIG_DM_THIN_PROVISIONING is not set
CONFIG_DM_CACHE=y
CONFIG_DM_CACHE_MQ=y
CONFIG_DM_CACHE_CLEANER=y
CONFIG_DM_ERA=y
# CONFIG_DM_MIRROR is not set
CONFIG_DM_RAID=y
CONFIG_DM_ZERO=y
# CONFIG_DM_MULTIPATH is not set
CONFIG_DM_DELAY=y
# CONFIG_DM_UEVENT is not set
# CONFIG_DM_FLAKEY is not set
# CONFIG_DM_VERITY is not set
CONFIG_DM_SWITCH=y
CONFIG_TARGET_CORE=y
# CONFIG_TCM_IBLOCK is not set
CONFIG_TCM_FILEIO=y
# CONFIG_TCM_PSCSI is not set
# CONFIG_TCM_USER is not set
CONFIG_LOOPBACK_TARGET=y
# CONFIG_ISCSI_TARGET is not set
# CONFIG_SBP_TARGET is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
# CONFIG_FIREWIRE_OHCI is not set
CONFIG_FIREWIRE_SBP2=y
CONFIG_FIREWIRE_NOSY=y
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
# CONFIG_NETDEVICES is not set
# CONFIG_VHOST_NET is not set
CONFIG_VHOST_RING=y

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=y
# CONFIG_INPUT_SPARSEKMAP is not set
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
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5520=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=y
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_GPIO=y
# CONFIG_KEYBOARD_GPIO_POLLED is not set
CONFIG_KEYBOARD_TCA6416=y
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
CONFIG_KEYBOARD_LM8323=y
CONFIG_KEYBOARD_LM8333=y
# CONFIG_KEYBOARD_MAX7359 is not set
CONFIG_KEYBOARD_MCS=y
CONFIG_KEYBOARD_MPR121=y
CONFIG_KEYBOARD_NEWTON=y
# CONFIG_KEYBOARD_OPENCORES is not set
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_TC3589X=y
CONFIG_KEYBOARD_XTKBD=y
CONFIG_KEYBOARD_CROS_EC=y
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=y
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_GPIO=y
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
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
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
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
CONFIG_TRACE_ROUTER=y
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
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
# CONFIG_SERIAL_8250_RSA is not set
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
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
# CONFIG_SERIAL_SC16IS7XX is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS=y
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_ARC is not set
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
CONFIG_SERIAL_FSL_LPUART=y
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
CONFIG_IPMI_SI_PROBE_DEFAULTS=y
# CONFIG_IPMI_WATCHDOG is not set
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_NVRAM=y
CONFIG_R3964=y
CONFIG_APPLICOM=y
CONFIG_MWAVE=y
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_XILLYBUS=y

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
CONFIG_I2C_MUX_PCA9541=y
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
CONFIG_I2C_ALI1535=y
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
# CONFIG_I2C_NFORCE2_S4985 is not set
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
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
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_TAOS_EVM=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_CROS_EC_TUNNEL=y
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
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_OC_TINY=y
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=y
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=y
# CONFIG_SPI_XCOMM is not set
CONFIG_SPI_XILINX=y
CONFIG_SPI_DESIGNWARE=y
# CONFIG_SPI_DW_PCI is not set
CONFIG_SPI_DW_MMIO=y

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set
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
# CONFIG_NTP_PPS is not set

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
# CONFIG_PTP_1588_CLOCK is not set

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_DWAPB=y
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_F7188X=y
# CONFIG_GPIO_SCH311X is not set
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=y
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
CONFIG_GPIO_CRYSTAL_COVE=y
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_RC5T583 is not set
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_TC3589X=y
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_WM8350=y
# CONFIG_GPIO_WM8994 is not set
CONFIG_GPIO_ADP5520=y
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=y
# CONFIG_GPIO_AMD8111 is not set
CONFIG_GPIO_INTEL_MID=y
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
# CONFIG_GPIO_MCP23S08 is not set
CONFIG_GPIO_MC33880=y

#
# AC97 GPIO expanders:
#
CONFIG_GPIO_UCB1400=y

#
# LPC GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=y
CONFIG_GPIO_TPS65910=y

#
# USB GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_DS1WM is not set
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2408_READBACK is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2406=y
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_MAX8925_POWER is not set
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
# CONFIG_WM8350_POWER is not set
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9030=y
# CONFIG_BATTERY_DA9052 is not set
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_PCF50633=y
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_LP8788=y
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MANAGER=y
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_BQ24190=y
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7310 is not set
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=y
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=y
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_APPLESMC=y
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_DA9055 is not set
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_MC13783_ADC=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_IIO_HWMON=y
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_POWR1220 is not set
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LTC2945=y
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=y
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4260=y
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
# CONFIG_SENSORS_HTU21 is not set
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_MENF21BMC_HWMON=y
CONFIG_SENSORS_ADCXX=y
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM70 is not set
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LM95234=y
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_PCF8591=y
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_DME1737=y
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_ADC128D818 is not set
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
# CONFIG_SENSORS_TMP103 is not set
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_WM831X is not set
CONFIG_SENSORS_WM8350=y

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
# CONFIG_THERMAL_GOV_BANG_BANG is not set
# CONFIG_THERMAL_GOV_USER_SPACE is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
# CONFIG_INT340X_THERMAL is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_DA9052_WATCHDOG=y
CONFIG_DA9055_WATCHDOG=y
CONFIG_DA9063_WATCHDOG=y
CONFIG_MENF21BMC_WATCHDOG=y
CONFIG_WM831X_WATCHDOG=y
CONFIG_WM8350_WATCHDOG=y
CONFIG_XILINX_WATCHDOG=y
CONFIG_DW_WATCHDOG=y
CONFIG_RN5T618_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=y
# CONFIG_F71808E_WDT is not set
CONFIG_SP5100_TCO=y
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=y
CONFIG_ITCO_WDT=y
# CONFIG_ITCO_VENDOR_SUPPORT is not set
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
CONFIG_HP_WATCHDOG=y
# CONFIG_HPWDT_NMI_DECODING is not set
# CONFIG_SC1200_WDT is not set
CONFIG_PC87413_WDT=y
CONFIG_NV_TCO=y
CONFIG_60XX_WDT=y
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83877F_WDT is not set
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_MEN_A21_WDT=y

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
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_AS3711=y
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_BCM590XX=y
# CONFIG_MFD_AXP20X is not set
CONFIG_MFD_CROS_EC=y
# CONFIG_MFD_CROS_EC_I2C is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=y
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_INTEL_SOC_PMIC=y
CONFIG_MFD_JANZ_CMODIO=y
# CONFIG_MFD_KEMPLD is not set
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_MENF21BMC=y
CONFIG_EZX_PCAP=y
# CONFIG_MFD_RETU is not set
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
# CONFIG_PCF50633_GPIO is not set
CONFIG_UCB1400_CORE=y
# CONFIG_MFD_RDC321X is not set
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RC5T583=y
CONFIG_MFD_RN5T618=y
CONFIG_MFD_SEC_CORE=y
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP3943 is not set
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS65218=y
# CONFIG_MFD_TPS6586X is not set
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_TPS65912_SPI=y
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_ARIZONA_SPI is not set
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
# CONFIG_MFD_WM8997 is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_88PM800 is not set
CONFIG_REGULATOR_ACT8865=y
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_ANATOP=y
# CONFIG_REGULATOR_AS3711 is not set
CONFIG_REGULATOR_BCM590XX=y
CONFIG_REGULATOR_DA903X=y
CONFIG_REGULATOR_DA9052=y
CONFIG_REGULATOR_DA9055=y
# CONFIG_REGULATOR_DA9063 is not set
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_DA9211=y
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_GPIO=y
# CONFIG_REGULATOR_ISL9305 is not set
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
# CONFIG_REGULATOR_LP3972 is not set
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LP8788=y
# CONFIG_REGULATOR_LTC3589 is not set
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8925=y
# CONFIG_REGULATOR_MAX8952 is not set
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
# CONFIG_REGULATOR_PCAP is not set
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
# CONFIG_REGULATOR_RC5T583 is not set
CONFIG_REGULATOR_RN5T618=y
CONFIG_REGULATOR_S2MPA01=y
# CONFIG_REGULATOR_S2MPS11 is not set
CONFIG_REGULATOR_S5M8767=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=y
CONFIG_REGULATOR_TPS62360=y
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65217=y
CONFIG_REGULATOR_TPS6524X=y
# CONFIG_REGULATOR_TPS65910 is not set
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_WM831X=y
# CONFIG_REGULATOR_WM8350 is not set
CONFIG_REGULATOR_WM8400=y
# CONFIG_REGULATOR_WM8994 is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
CONFIG_DRM_I2C_SIL164=y
CONFIG_DRM_I2C_NXP_TDA998X=y
CONFIG_DRM_PTN3460=y
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_UMS=y
CONFIG_DRM_NOUVEAU=y
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
CONFIG_DRM_SIS=y
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
CONFIG_DRM_MGAG200=y
# CONFIG_DRM_CIRRUS_QEMU is not set
CONFIG_DRM_QXL=y
CONFIG_DRM_BOCHS=y

#
# Frame buffer Devices
#
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_CMDLINE=y
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
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
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
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=y
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=y
CONFIG_FB_CYBER2000_DDC=y
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
CONFIG_FB_VESA=y
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
CONFIG_FB_LE80578=y
# CONFIG_FB_CARILLO_RANCH is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
# CONFIG_FB_ATY_GENERIC_LCD is not set
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
# CONFIG_FB_S3 is not set
CONFIG_FB_SAVAGE=y
# CONFIG_FB_SAVAGE_I2C is not set
# CONFIG_FB_SAVAGE_ACCEL is not set
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=y
# CONFIG_FB_VIA_DIRECT_PROCFS is not set
# CONFIG_FB_VIA_X_COMPATIBILITY is not set
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
# CONFIG_FB_3DFX_ACCEL is not set
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
# CONFIG_FB_PM3 is not set
CONFIG_FB_CARMINE=y
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
CONFIG_FB_AUO_K1901=y
# CONFIG_FB_SIMPLE is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_L4F00242T03 is not set
CONFIG_LCD_LMS283GF05=y
CONFIG_LCD_LTV350QV=y
# CONFIG_LCD_ILI922X is not set
CONFIG_LCD_ILI9320=y
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=y
CONFIG_LCD_S6E63M0=y
CONFIG_LCD_LD9040=y
CONFIG_LCD_AMS369FG06=y
CONFIG_LCD_LMS501KF03=y
# CONFIG_LCD_HX8357 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_CARILLO_RANCH=y
CONFIG_BACKLIGHT_DA903X=y
CONFIG_BACKLIGHT_DA9052=y
# CONFIG_BACKLIGHT_MAX8925 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
# CONFIG_BACKLIGHT_WM831X is not set
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_PCF50633=y
CONFIG_BACKLIGHT_LM3639=y
# CONFIG_BACKLIGHT_TPS65217 is not set
CONFIG_BACKLIGHT_AS3711=y
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
CONFIG_VGASTATE=y
CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_JACK=y
# CONFIG_SND_SEQUENCER is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PROCFS is not set
CONFIG_SND_VERBOSE_PRINTK=y
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_KCTL_JACK=y
CONFIG_SND_DMA_SGBUF=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_AC97_CODEC=y
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_SB_COMMON=y
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=y
CONFIG_SND_ALS300=y
CONFIG_SND_ALS4000=y
# CONFIG_SND_ALI5451 is not set
CONFIG_SND_ASIHPI=y
CONFIG_SND_ATIIXP=y
CONFIG_SND_ATIIXP_MODEM=y
# CONFIG_SND_AU8810 is not set
CONFIG_SND_AU8820=y
CONFIG_SND_AU8830=y
CONFIG_SND_AW2=y
CONFIG_SND_AZT3328=y
CONFIG_SND_BT87X=y
CONFIG_SND_BT87X_OVERCLOCK=y
CONFIG_SND_CA0106=y
CONFIG_SND_CMIPCI=y
CONFIG_SND_OXYGEN_LIB=y
# CONFIG_SND_OXYGEN is not set
CONFIG_SND_CS4281=y
CONFIG_SND_CS46XX=y
# CONFIG_SND_CS46XX_NEW_DSP is not set
CONFIG_SND_CTXFI=y
CONFIG_SND_DARLA20=y
CONFIG_SND_GINA20=y
# CONFIG_SND_LAYLA20 is not set
CONFIG_SND_DARLA24=y
CONFIG_SND_GINA24=y
CONFIG_SND_LAYLA24=y
CONFIG_SND_MONA=y
CONFIG_SND_MIA=y
CONFIG_SND_ECHO3G=y
# CONFIG_SND_INDIGO is not set
CONFIG_SND_INDIGOIO=y
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
CONFIG_SND_INDIGODJX=y
CONFIG_SND_EMU10K1=y
# CONFIG_SND_EMU10K1X is not set
CONFIG_SND_ENS1370=y
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
CONFIG_SND_ES1968=y
# CONFIG_SND_ES1968_INPUT is not set
CONFIG_SND_FM801=y
CONFIG_SND_HDSP=y

#
# Don't forget to add built-in firmwares for HDSP driver
#
CONFIG_SND_HDSPM=y
# CONFIG_SND_ICE1712 is not set
CONFIG_SND_ICE1724=y
# CONFIG_SND_INTEL8X0 is not set
CONFIG_SND_INTEL8X0M=y
# CONFIG_SND_KORG1212 is not set
CONFIG_SND_LOLA=y
# CONFIG_SND_LX6464ES is not set
CONFIG_SND_MAESTRO3=y
CONFIG_SND_MAESTRO3_INPUT=y
CONFIG_SND_MIXART=y
CONFIG_SND_NM256=y
CONFIG_SND_PCXHR=y
# CONFIG_SND_RIPTIDE is not set
CONFIG_SND_RME32=y
# CONFIG_SND_RME96 is not set
CONFIG_SND_RME9652=y
CONFIG_SND_SONICVIBES=y
CONFIG_SND_TRIDENT=y
CONFIG_SND_VIA82XX=y
CONFIG_SND_VIA82XX_MODEM=y
CONFIG_SND_VIRTUOSO=y
# CONFIG_SND_VX222 is not set
CONFIG_SND_YMFPCI=y

#
# HD-Audio
#
CONFIG_SND_HDA=y
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_DSP_LOADER=y
CONFIG_SND_HDA_PREALLOC_SIZE=64
# CONFIG_SND_HDA_HWDEP is not set
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=1
# CONFIG_SND_HDA_INPUT_JACK is not set
CONFIG_SND_HDA_PATCH_LOADER=y
CONFIG_SND_HDA_CODEC_REALTEK=y
# CONFIG_SND_HDA_CODEC_ANALOG is not set
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
# CONFIG_SND_HDA_CODEC_HDMI is not set
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CA0132=y
CONFIG_SND_HDA_CODEC_CA0132_DSP=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
# CONFIG_SND_SPI is not set
# CONFIG_SND_FIREWIRE is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=y

#
# HID support
#
# CONFIG_HID is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
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
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_GADGET is not set
CONFIG_UWB=y
# CONFIG_UWB_WHCI is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=y
CONFIG_MS_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_MEMSTICK_R592=y
CONFIG_MEMSTICK_REALTEK_PCI=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_PCA9532=y
CONFIG_LEDS_PCA9532_GPIO=y
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
CONFIG_LEDS_LP8788=y
CONFIG_LEDS_CLEVO_MAIL=y
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_WM8350=y
# CONFIG_LEDS_DA903X is not set
# CONFIG_LEDS_DA9052 is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_INTEL_SS4200=y
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_ADP5520=y
# CONFIG_LEDS_DELL_NETBOOKS is not set
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_MENF21BMC is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_GPIO=y
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
# CONFIG_ACCESSIBILITY is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
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
# CONFIG_RTC_DRV_88PM80X is not set
# CONFIG_RTC_DRV_DS1307 is not set
CONFIG_RTC_DRV_DS1374=y
# CONFIG_RTC_DRV_DS1672 is not set
CONFIG_RTC_DRV_DS3232=y
CONFIG_RTC_DRV_LP8788=y
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8925=y
# CONFIG_RTC_DRV_RS5C372 is not set
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=y
# CONFIG_RTC_DRV_ISL12057 is not set
CONFIG_RTC_DRV_X1205=y
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_PCF8523=y
CONFIG_RTC_DRV_PCF8563=y
# CONFIG_RTC_DRV_PCF85063 is not set
CONFIG_RTC_DRV_PCF8583=y
# CONFIG_RTC_DRV_M41T80 is not set
CONFIG_RTC_DRV_BQ32K=y
CONFIG_RTC_DRV_TPS65910=y
CONFIG_RTC_DRV_RC5T583=y
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y
# CONFIG_RTC_DRV_EM3027 is not set
CONFIG_RTC_DRV_RV3029C2=y
CONFIG_RTC_DRV_S5M=y

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
CONFIG_RTC_DRV_M41T94=y
CONFIG_RTC_DRV_DS1305=y
CONFIG_RTC_DRV_DS1343=y
CONFIG_RTC_DRV_DS1347=y
CONFIG_RTC_DRV_DS1390=y
CONFIG_RTC_DRV_MAX6902=y
CONFIG_RTC_DRV_R9701=y
CONFIG_RTC_DRV_RS5C348=y
CONFIG_RTC_DRV_DS3234=y
CONFIG_RTC_DRV_PCF2123=y
CONFIG_RTC_DRV_RX4581=y
# CONFIG_RTC_DRV_MCP795 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=y
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_DS2404=y
CONFIG_RTC_DRV_DA9052=y
# CONFIG_RTC_DRV_DA9055 is not set
CONFIG_RTC_DRV_DA9063=y
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
CONFIG_RTC_DRV_V3020=y
# CONFIG_RTC_DRV_WM831X is not set
CONFIG_RTC_DRV_WM8350=y
# CONFIG_RTC_DRV_PCF50633 is not set

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_PCAP=y
CONFIG_RTC_DRV_MC13XXX=y
CONFIG_RTC_DRV_XGENE=y

#
# HID Sensor RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y
CONFIG_UIO_MF624=y
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
CONFIG_RTS5208=y

#
# IIO staging drivers
#

#
# Accelerometers
#
# CONFIG_ADIS16201 is not set
# CONFIG_ADIS16203 is not set
CONFIG_ADIS16204=y
CONFIG_ADIS16209=y
# CONFIG_ADIS16220 is not set
# CONFIG_ADIS16240 is not set
# CONFIG_LIS3L02DQ is not set
# CONFIG_SCA3000 is not set

#
# Analog to digital converters
#
CONFIG_AD7606=y
# CONFIG_AD7606_IFACE_PARALLEL is not set
CONFIG_AD7606_IFACE_SPI=y
# CONFIG_AD7780 is not set
CONFIG_AD7816=y
CONFIG_AD7192=y
CONFIG_AD7280=y

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=y
CONFIG_ADT7316_SPI=y
# CONFIG_ADT7316_I2C is not set

#
# Capacitance to digital converters
#
CONFIG_AD7150=y
# CONFIG_AD7152 is not set
CONFIG_AD7746=y

#
# Direct Digital Synthesis
#
CONFIG_AD9832=y
CONFIG_AD9834=y

#
# Digital gyroscope sensors
#
# CONFIG_ADIS16060 is not set

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=y
# CONFIG_SENSORS_ISL29028 is not set
# CONFIG_TSL2583 is not set
CONFIG_TSL2x7x=y

#
# Magnetometer sensors
#
CONFIG_SENSORS_HMC5843=y
CONFIG_SENSORS_HMC5843_I2C=y
CONFIG_SENSORS_HMC5843_SPI=y

#
# Active energy metering IC
#
# CONFIG_ADE7753 is not set
CONFIG_ADE7754=y
# CONFIG_ADE7758 is not set
CONFIG_ADE7759=y
CONFIG_ADE7854=y
CONFIG_ADE7854_I2C=y
CONFIG_ADE7854_SPI=y

#
# Resolver to digital converters
#
CONFIG_AD2S90=y
# CONFIG_AD2S1200 is not set
# CONFIG_AD2S1210 is not set

#
# Triggers - standalone
#
# CONFIG_IIO_PERIODIC_RTC_TRIGGER is not set
# CONFIG_IIO_SIMPLE_DUMMY is not set
CONFIG_FB_XGI=y
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_SPEAKUP=y
# CONFIG_SPEAKUP_SYNTH_ACNTSA is not set
# CONFIG_SPEAKUP_SYNTH_APOLLO is not set
# CONFIG_SPEAKUP_SYNTH_AUDPTR is not set
CONFIG_SPEAKUP_SYNTH_BNS=y
CONFIG_SPEAKUP_SYNTH_DECTLK=y
CONFIG_SPEAKUP_SYNTH_DECEXT=y
CONFIG_SPEAKUP_SYNTH_LTLK=y
CONFIG_SPEAKUP_SYNTH_SOFT=y
CONFIG_SPEAKUP_SYNTH_SPKOUT=y
CONFIG_SPEAKUP_SYNTH_TXPRT=y
# CONFIG_SPEAKUP_SYNTH_DUMMY is not set
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
CONFIG_STAGING_MEDIA=y

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_FIREWIRE_SERIAL is not set
# CONFIG_DGNC is not set
CONFIG_DGAP=y
CONFIG_GS_FPGABOOT=y
CONFIG_CRYPTO_SKEIN=y
CONFIG_CRYPTO_THREEFISH=y
# CONFIG_UNISYSSPAR is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ACERHDF is not set
# CONFIG_ALIENWARE_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
# CONFIG_DELL_SMO8800 is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WIRELESS is not set
# CONFIG_HP_WMI is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ASUS_WMI is not set
CONFIG_ACPI_WMI=y
# CONFIG_MSI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
CONFIG_IBM_RTL=y
# CONFIG_SAMSUNG_LAPTOP is not set
CONFIG_MXM_WMI=y
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# SOC (System On Chip) specific Drivers
#
CONFIG_SOC_TI=y

#
# Hardware Spinlock drivers
#

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_ATMEL_PIT is not set
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
CONFIG_MAILBOX=y
# CONFIG_IOMMU_SUPPORT is not set

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
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
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
CONFIG_EXTCON_ADC_JACK=y
# CONFIG_EXTCON_GPIO is not set
CONFIG_EXTCON_RT8973A=y
# CONFIG_EXTCON_SM5502 is not set
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
# CONFIG_BMA180 is not set
# CONFIG_BMC150_ACCEL is not set
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y
CONFIG_IIO_ST_ACCEL_SPI_3AXIS=y
# CONFIG_KXSD9 is not set
CONFIG_MMA8452=y
CONFIG_KXCJK1013=y

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
# CONFIG_AD7266 is not set
CONFIG_AD7291=y
CONFIG_AD7298=y
# CONFIG_AD7476 is not set
# CONFIG_AD7791 is not set
CONFIG_AD7793=y
CONFIG_AD7887=y
# CONFIG_AD7923 is not set
CONFIG_AD799X=y
CONFIG_LP8788_ADC=y
CONFIG_MAX1027=y
# CONFIG_MAX1363 is not set
CONFIG_MCP320X=y
CONFIG_MCP3422=y
CONFIG_NAU7802=y
CONFIG_TI_ADC081C=y
CONFIG_TI_ADC128S052=y
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
CONFIG_AD5504=y
CONFIG_AD5624R_SPI=y
CONFIG_AD5686=y
CONFIG_AD5755=y
CONFIG_AD5764=y
# CONFIG_AD5791 is not set
# CONFIG_AD7303 is not set
# CONFIG_MAX517 is not set
CONFIG_MCP4725=y
# CONFIG_MCP4922 is not set

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
CONFIG_ADIS16260=y
CONFIG_ADXRS450=y
CONFIG_BMG160=y
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_IIO_ST_GYRO_SPI_3AXIS=y
# CONFIG_ITG3200 is not set

#
# Humidity sensors
#
CONFIG_DHT11=y
# CONFIG_SI7005 is not set

#
# Inertial measurement units
#
CONFIG_ADIS16400=y
CONFIG_ADIS16480=y
# CONFIG_INV_MPU6050_IIO is not set
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
CONFIG_AL3320A=y
CONFIG_APDS9300=y
CONFIG_CM32181=y
# CONFIG_CM36651 is not set
# CONFIG_GP2AP020A00F is not set
CONFIG_ISL29125=y
CONFIG_LTR501=y
CONFIG_TCS3414=y
# CONFIG_TCS3472 is not set
CONFIG_SENSORS_TSL2563=y
CONFIG_TSL4531=y
# CONFIG_VCNL4000 is not set

#
# Magnetometer sensors
#
CONFIG_AK8975=y
# CONFIG_AK09911 is not set
# CONFIG_MAG3110 is not set
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
CONFIG_IIO_ST_MAGN_SPI_3AXIS=y

#
# Inclinometer sensors
#

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure sensors
#
CONFIG_MPL115=y
CONFIG_MPL3115=y
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y
CONFIG_IIO_ST_PRESS_SPI=y
CONFIG_T5403=y

#
# Lightning sensors
#
CONFIG_AS3935=y

#
# Temperature sensors
#
CONFIG_MLX90614=y
CONFIG_TMP006=y
CONFIG_NTB=y
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
CONFIG_SERIAL_IPOCTAL=y
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
CONFIG_POWERCAP=y
# CONFIG_INTEL_RAPL is not set
# CONFIG_MCB is not set
CONFIG_RAS=y
CONFIG_THUNDERBOLT=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
CONFIG_GOOGLE_MEMCONSOLE=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
CONFIG_EXT4_FS_POSIX_ACL=y
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
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y
# CONFIG_BTRFS_DEBUG is not set
CONFIG_BTRFS_ASSERT=y
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set
# CONFIG_OVERLAYFS_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=y
CONFIG_CACHEFILES_DEBUG=y
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
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
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
# CONFIG_NLS_MAC_TURKISH is not set
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
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_DEBUG_ON=y
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_PER_CPU_MAPS=y
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
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHED_IDLE_DEBUG is not set
CONFIG_SCHEDSTATS=y
CONFIG_SCHED_STACK_END_CHECK=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_PREEMPT is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
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
# CONFIG_PREEMPT_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
# CONFIG_BRANCH_TRACER is not set
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_DYNAMIC_FTRACE is not set
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_EVENT_TRACE_TEST_SYSCALLS=y
CONFIG_MMIOTRACE=y
CONFIG_TRACEPOINT_BENCHMARK=y
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_ASYNC_RAID6_TEST=y
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
CONFIG_TEST_RHASHTABLE=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_FIRMWARE=y
# CONFIG_TEST_UDELAY is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
# CONFIG_KEYS is not set
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
CONFIG_CRYPTO_MCRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER=y
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
# CONFIG_CRYPTO_PCBC is not set
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
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA1_MB=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
# CONFIG_CRYPTO_AES is not set
# CONFIG_CRYPTO_AES_X86_64 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_DES3_EDE_X86_64=y
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
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
# CONFIG_CRYPTO_LZO is not set
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_DRBG_MENU is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
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
CONFIG_PERCPU_RWSEM=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
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
CONFIG_INTERVAL_TREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
CONFIG_DDR=y
CONFIG_FONT_SUPPORT=y
CONFIG_FONTS=y
# CONFIG_FONT_8x8 is not set
CONFIG_FONT_8x16=y
CONFIG_FONT_6x11=y
# CONFIG_FONT_7x14 is not set
CONFIG_FONT_PEARL_8x8=y
CONFIG_FONT_ACORN_8x8=y
CONFIG_FONT_MINI_4x6=y
# CONFIG_FONT_6x10 is not set
CONFIG_FONT_SUN8x16=y
CONFIG_FONT_SUN12x22=y
# CONFIG_FONT_10x18 is not set
CONFIG_ARCH_HAS_SG_CHAIN=y

--48TaNjbzBVislYPb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--48TaNjbzBVislYPb--
