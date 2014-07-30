Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750900AbaG3EAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 00:00:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:10851 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbaG3EAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 00:00:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,762,1400050800"; 
   d="log'?scan'208";a="569236116"
Date: Wed, 30 Jul 2014 12:00:08 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: [perf/x86/RAPL] BUG: unable to handle kernel NULL pointer
 dereference at 00000028
Message-ID: <20140730040008.GF16537@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="JbKQpFqZXJ2T76Sg"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JbKQpFqZXJ2T76Sg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
commit 4788e5b4b2338f85fa42a712a182d8afd65d7c58
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue Nov 12 17:58:50 2013 +0100
Commit:     Ingo Molnar <mingo@kernel.org>
CommitDate: Wed Nov 27 11:16:40 2013 +0100

    perf/x86: Add Intel RAPL PMU support
    
    This patch adds a new uncore PMU to expose the Intel
    RAPL energy consumption counters. Up to 3 counters,
    each counting a particular RAPL event are exposed.
    
    The RAPL counters are available on Intel SandyBridge,
    IvyBridge, Haswell. The server skus add a 3rd counter.
    
    The following events are available and exposed in sysfs:
    
      - power/energy-cores: power consumption of all cores on socket
      - power/energy-pkg: power consumption of all cores + LLc cache
      - power/energy-dram: power consumption of DRAM (servers only)
    
    For each event both the unit (Joules) and scale (2^-32 J)
    is exposed in sysfs for use by perf stat and other tools.
    The files are:
    
    	/sys/devices/power/events/energy-*.unit
    	/sys/devices/power/events/energy-*.scale
    
    The RAPL PMU is uncore by nature and is implemented such
    that it only works in system-wide mode. Measuring only
    one CPU per socket is sufficient. The /sys/devices/power/cpumask
    file can be used by tools to figure out which CPUs to monitor
    by default. For instance, on a 2-socket system, 2 CPUs
    (one on each socket) will be shown.
    
    All the counters measure in the same unit (exposed via sysfs).
    The perf_events API exposes all RAPL counters as 64-bit integers
    counting in unit of 1/2^32 Joules (about 0.23 nJ). User level tools
    must convert the counts by multiplying them by 2^-32 to obtain
    Joules. The reason for this is that the kernel avoids
    doing floating point math whenever possible because it is
    expensive (user floating-point state must be saved). The method
    used avoids kernel floating-point usage. There is no loss of
    precision. Thanks to PeterZ for suggesting this approach.
    
    To convert the raw count in Watt:
       W = C * 2.3 / (1e10 * time)
    or ldexp(C, -32).
    
    RAPL PMU is a new standalone PMU which registers with the
    perf_event core subsystem. The PMU type (attr->type) is
    dynamically allocated and is available from /sys/device/power/type.
    
    Sampling is not supported by the RAPL PMU. There is no
    privilege level filtering either.
    
    Signed-off-by: Stephane Eranian <eranian@google.com>
    Reviewed-by: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
    Reviewed-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Cc: acme@redhat.com
    Cc: jolsa@redhat.com
    Cc: zheng.z.yan@intel.com
    Cc: bp@alien8.de
    Link: http://lkml.kernel.org/r/1384275531-10892-4-git-send-email-eranian@google.com
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

+-----------------------------------------------------------+------------+------------+---------------+
|                                                           | 410136f5dd | 4788e5b4b2 | next-20140724 |
+-----------------------------------------------------------+------------+------------+---------------+
| boot_successes                                            | 1000       | 751        | 78            |
| boot_failures                                             | 0          | 149        | 3             |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference      | 0          | 132        | 2             |
| Oops                                                      | 0          | 132        | 2             |
| EIP_is_at_rapl_pmu_init                                   | 0          | 132        |               |
| Kernel_panic-not_syncing:Attempted_to_kill_init_exitcode= | 0          | 132        | 2             |
| backtrace:rapl_pmu_init                                   | 0          | 132        |               |
| backtrace:kernel_init_freeable                            | 0          | 132        | 2             |
| BUG:kernel_boot_hang                                      | 0          | 17         | 1             |
| EIP_is_at_validate_chain                                  | 0          | 0          | 2             |
| backtrace:free_reserved_area                              | 0          | 0          | 2             |
| backtrace:free_init_pages                                 | 0          | 0          | 2             |
| backtrace:populate_rootfs                                 | 0          | 0          | 2             |
+-----------------------------------------------------------+------------+------------+---------------+

[    0.613305] PCI: CLS 0 bytes, default 64
[    0.614699] Unpacking initramfs...
[    0.732188] Freeing initrd memory: 3276K (d3cbd000 - d3ff0000)
[    0.733895] BUG: unable to handle kernel NULL pointer dereference at 00000028
[    0.735603] IP: [<c09b20cb>] rapl_pmu_init+0x11e/0x139
[    0.736012] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 
[    0.736012] Oops: 0000 [#1] PREEMPT 
[    0.736012] Modules linked in:
[    0.736012] CPU: 0 PID: 1 Comm: swapper Not tainted 3.12.0-05711-g4788e5b #11
[    0.736012] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.736012] task: d244c020 ti: d244e000 task.ti: d244e000
[    0.736012] EIP: 0060:[<c09b20cb>] EFLAGS: 00010202 CPU: 0
[    0.736012] EIP is at rapl_pmu_init+0x11e/0x139
[    0.736012] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000001
[    0.736012] ESI: c09b1fad EDI: 000000cc EBP: d244ff00 ESP: d244fef0
[    0.736012]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[    0.736012] CR0: 80050033 CR2: 00000028 CR3: 00a16000 CR4: 000406b0
[    0.736012] Stack:
[    0.736012]  c04ddabe 00000000 00000002 00000000 d244ff74 c0200477 c0251b16 d244ff2c
[    0.736012]  c025467d d3ff63cb d244ff34 c02410cb d3ff63cb d244ff00 c09aa512 c080d71c
[    0.736012]  000000cc d244ff74 c02412d5 c0829fe0 00000286 c023b6d8 00000246 00060006
[    0.736012] Call Trace:
[    0.736012]  [<c04ddabe>] ? register_syscore_ops+0x32/0x35
[    0.736012]  [<c0200477>] do_one_initcall+0xdf/0x138
[    0.736012]  [<c0251b16>] ? lock_release_holdtime.part.20+0x93/0xf8
[    0.736012]  [<c025467d>] ? trace_hardirqs_on_caller+0xeb/0x1ad
[    0.736012]  [<c02410cb>] ? parameq+0x13/0x5e
[    0.736012]  [<c09aa512>] ? repair_env_string+0x12/0x51
[    0.736012]  [<c02412d5>] ? parse_args+0x1bf/0x2f8
[    0.736012]  [<c023b6d8>] ? __usermodehelper_set_disable_depth+0x3e/0x44
[    0.736012]  [<c09aab46>] kernel_init_freeable+0xde/0x178
[    0.736012]  [<c09aa500>] ? do_early_param+0x78/0x78
[    0.736012]  [<c064bd10>] kernel_init+0xb/0xed
[    0.736012]  [<c0249199>] ? schedule_tail+0xc/0x3a
[    0.736012]  [<c0659637>] ret_from_kernel_thread+0x1b/0x28
[    0.736012]  [<c064bd05>] ? rest_init+0xb5/0xb5
[    0.736012] Code: 99 87 ff 89 5c 24 04 c7 04 24 90 bf 76 c0 e8 dd e9 c9 ff 83 c8 ff eb 28 a1 44 bc a1 c0 f3 0f b8 c0 90 89 44 24 08 a1 80 73 82 c0 <8b> 40 28 89 44 24 04 c7 04 24 d4 bf 76 c0 e8 b2 e9 c9 ff 31 c0
[    0.736012] EIP: [<c09b20cb>] rapl_pmu_init+0x11e/0x139 SS:ESP 0068:d244fef0
[    0.736012] CR2: 0000000000000028
[    0.736012] ---[ end trace 0a81712c9fb36a0a ]---
[    0.736012] swapper (1) used greatest stack depth: 5800 bytes left

git bisect start v3.14 v3.13 --
git bisect  bad 09df7c4c8097ca4a11393b1edd4997d786daad52  # 16:18      0-      3  x86: Remove CONFIG_X86_OOSTORE
git bisect  bad 15c81026204da897a05424c79263aea861a782cc  # 16:24      2-      5  Merge branch 'x86-x32-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect  bad a0fa1dd3cdbccec9597fe53b6177a9aa6e20f2f8  # 16:33      0-     15  Merge branch 'sched-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good edde1fb8c41d0db7c8ce17fb32886da2e389b0cc  # 17:48    900+      0  Merge tag 'localmodconfig-v3.14' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-kconfig
git bisect good a693c46e14c9fdadbcd68ddfa94a4f72495531a9  # 17:55    900+      0  Merge branch 'core-rcu-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 2cc3f16cad1561c6fc551aefff559e53726efc8b  # 18:12    900+      0  Merge branch 'irq-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect  bad 9326657abe1a83ed4b4f396b923ca1217fd50cba  # 18:21      9-      2  Merge branch 'perf-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect  bad 7bb73553e2490ac6667387ee723e0faa61e9d999  # 18:38      0-      1  tools lib traceevent: Get rid of die() in reparent_op_arg()
git bisect  bad 3d7c0144491bd8c21d53b43032274a85efdfe434  # 18:41     11-      4  perf tools: Add build and install plugins targets
git bisect  bad ba1ddf42f3c3af111d3adee277534f73c1ef6a9b  # 18:43      0-     15  perf script: Print mmap[2] events also
git bisect  bad a8b4c7014cadfdacd4e1f4c963128593be6f20de  # 18:49      0-      2  perf completion: Rename file to reflect zsh support
git bisect  bad 4788e5b4b2338f85fa42a712a182d8afd65d7c58  # 18:53      0-      1  perf/x86: Add Intel RAPL PMU support
git bisect good c912dae60ae6f659455f239298110adc67a5f3e9  # 19:33    900+     14  uprobes: Cleanup !CONFIG_UPROBES decls, unexport xol_area
git bisect good 09897d78dbc3a544426f2272b5601c62922ccab9  # 19:44    900+      0  Merge branch 'uprobes/core' of git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc into perf/core
git bisect good 410136f5dd96b6013fe6d1011b523b1c247e1ccb  # 19:52    900+      0  tools/perf/stat: Add event unit and scale support
# first bad commit: [4788e5b4b2338f85fa42a712a182d8afd65d7c58] perf/x86: Add Intel RAPL PMU support
git bisect good 410136f5dd96b6013fe6d1011b523b1c247e1ccb  # 19:56   1000+      0  tools/perf/stat: Add event unit and scale support
git bisect  bad 1a58d9909611972fd1c081bb04a9f7dc2571e612  # 19:58      0-      3  Add linux-next specific files for 20140724
git bisect  bad 82e13c71bc655b6dc7110da4e164079dadb44892  # 20:07    448-     10  Merge branch 'for-3.16' of git://linux-nfs.org/~bfields/linux
git bisect  bad 5a7439efd1c5c416f768fc550048ca130cf4bf99  # 20:14      2-      6  Add linux-next specific files for 20140725


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-i386.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-enable-kvm
	-cpu Haswell,+smep,+smap
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
	panic=10
	softlockup_panic=1
	nmi_watchdog=panic
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

--JbKQpFqZXJ2T76Sg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-kbuild-7:20140725185135:i386-randconfig-ib1-07251153:3.12.0-05711-g4788e5b:11"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... Performing relocations... done.
Booting the kernel.
[    0.000000] Linux version 3.12.0-05711-g4788e5b (kbuild@lkp-hsx01) (gcc =
version 4.8.2 (Debian 4.8.2-18) ) #11 PREEMPT Fri Jul 25 18:52:39 CST 2014
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
[    0.000000] found SMP MP-table at [mem 0x000fdb00-0x000fdb0f] mapped at =
[c00fdb00]
[    0.000000]   mpc: fdb10-fdbf0
[    0.000000] initial memory mapped: [mem 0x00000000-0x013fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x00f8f000, 0x00f8ffff] PGTABLE
[    0.000000] cma: CMA: reserved 16 MiB at 12c00000
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
[    0.000000] ACPI: RSDP 000fd9a0 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 13ffe4b0 000034 (v01 BOCHS  BXPCRSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: FACP 13ffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXP=
C 00000001)
[    0.000000] ACPI: DSDT 13ffe4f0 0011A9 (v01   BXPC   BXDSDT 00000001 INT=
L 20100528)
[    0.000000] ACPI: FACS 13ffff40 000040
[    0.000000] ACPI: SSDT 13fff800 000735 (v01 BOCHS  BXPCSSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: APIC 13fff6e0 000078 (v01 BOCHS  BXPCAPIC 00000001 BXP=
C 00000001)
[    0.000000] ACPI: HPET 13fff6a0 000038 (v01 BOCHS  BXPCHPET 00000001 BXP=
C 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
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
[    0.000000] free_area_init_node: node 0, pgdat c09a3960, node_mem_map d2=
980020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 608 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] Using ACPI for processor (LAPIC) configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000]   mpc: fdb10-fdbf0
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1        =20
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC=
 LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, API=
C LINT 01
[    0.000000] Processors: 1
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 827d80
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
0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-ib1-07251153/next:m=
aster:4788e5b4b2338f85fa42a712a182d8afd65d7c58:bisect-linux-9/.vmlinuz-4788=
e5b4b2338f85fa42a712a182d8afd65d7c58-20140725185250-1-kbuild branch=3Dnext/=
master BOOT_IMAGE=3D/kernel/i386-randconfig-ib1-07251153/4788e5b4b2338f85fa=
42a712a182d8afd65d7c58/vmlinuz-3.12.0-05711-g4788e5b drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Memory: 290612K/327280K available (4456K kernel code, 1644K =
rwdata, 1736K rodata, 420K init, 5572K bss, 36668K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe1000 - 0xfffff000   ( 120 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xfffdf000   ( 695 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xc09aa000 - 0xc0a13000   ( 420 kB)
[    0.000000]       .data : 0xc065a6e8 - 0xc09a9280   (3386 kB)
[    0.000000]       .text : 0xc0200000 - 0xc065a6e8   (4457 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3Dd240a000 soft=3Dd240c000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Linux version 3.12.0-05711-g4788e5b (kbuild@lkp-hsx01) (gcc =
version 4.8.2 (Debian 4.8.2-18) ) #11 PREEMPT Fri Jul 25 18:52:39 CST 2014
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
[    0.000000] found SMP MP-table at [mem 0x000fdb00-0x000fdb0f] mapped at =
[c00fdb00]
[    0.000000]   mpc: fdb10-fdbf0
[    0.000000] initial memory mapped: [mem 0x00000000-0x013fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13ffdfff]
[    0.000000]  [mem 0x13c00000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x00f8f000, 0x00f8ffff] PGTABLE
[    0.000000] cma: CMA: reserved 16 MiB at 12c00000
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
[    0.000000] ACPI: RSDP 000fd9a0 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 13ffe4b0 000034 (v01 BOCHS  BXPCRSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: FACP 13ffff80 000074 (v01 BOCHS  BXPCFACP 00000001 BXP=
C 00000001)
[    0.000000] ACPI: DSDT 13ffe4f0 0011A9 (v01   BXPC   BXDSDT 00000001 INT=
L 20100528)
[    0.000000] ACPI: FACS 13ffff40 000040
[    0.000000] ACPI: SSDT 13fff800 000735 (v01 BOCHS  BXPCSSDT 00000001 BXP=
C 00000001)
[    0.000000] ACPI: APIC 13fff6e0 000078 (v01 BOCHS  BXPCAPIC 00000001 BXP=
C 00000001)
[    0.000000] ACPI: HPET 13fff6a0 000038 (v01 BOCHS  BXPCHPET 00000001 BXP=
C 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
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
[    0.000000] free_area_init_node: node 0, pgdat c09a3960, node_mem_map d2=
980020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 608 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] Using ACPI for processor (LAPIC) configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000]   mpc: fdb10-fdbf0
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1        =20
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC=
 LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, API=
C LINT 01
[    0.000000] Processors: 1
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 827d80
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
0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-ib1-07251153/next:m=
aster:4788e5b4b2338f85fa42a712a182d8afd65d7c58:bisect-linux-9/.vmlinuz-4788=
e5b4b2338f85fa42a712a182d8afd65d7c58-20140725185250-1-kbuild branch=3Dnext/=
master BOOT_IMAGE=3D/kernel/i386-randconfig-ib1-07251153/4788e5b4b2338f85fa=
42a712a182d8afd65d7c58/vmlinuz-3.12.0-05711-g4788e5b drbd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Memory: 290612K/327280K available (4456K kernel code, 1644K =
rwdata, 1736K rodata, 420K init, 5572K bss, 36668K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffe1000 - 0xfffff000   ( 120 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xfffdf000   ( 695 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xc09aa000 - 0xc0a13000   ( 420 kB)
[    0.000000]       .data : 0xc065a6e8 - 0xc09a9280   (3386 kB)
[    0.000000]       .text : 0xc0200000 - 0xc065a6e8   (4457 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=3Dd240a000 soft=3Dd240c000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
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
[    0.000000]  memory used by lock dependency info: 3823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.332 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5386.66 Bogo=
MIPS (lpj=3D10773328)
[    0.008007] pid_max: default: 32768 minimum: 301
[    0.009221] Security Framework initialized
[    0.010279] Yama: becoming mindful.
[    0.011292] Mount-cache hash table entries: 512
[    0.012837] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.012837] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.012837] tlb_flushall_shift: 6
[    0.016007] CPU: Intel Core Processor (Haswell) (fam: 06, model: 3c, ste=
pping: 01)
[    0.022461] ACPI: Core revision 20130927
[    0.025672] ACPI: All ACPI Tables successfully acquired
[    0.027052] ACPI: setting ELCR to 0200 (from 0c00)
[    0.028441] Performance Events: unsupported p6 CPU model 60 no PMU drive=
r, software events only.
[    0.032816] Getting VERSION: 1050014
[    0.033819] Getting VERSION: 1050014
[    0.034817] Getting ID: 0
[    0.035678] Getting ID: f000000
[    0.036025] Getting LVT0: 8700
[    0.036946] Getting LVT1: 8400
[    0.040093] enabled ExtINT on CPU#0
[    0.041148] TSC deadline timer enabled
[    0.042805] EVM: security.capability
[    0.044000] regulator-dummy: no parameters
[    0.044349] NET: Registered protocol family 16
[    0.045946] cpuidle: using governor ladder
[    0.047011] cpuidle: using governor menu
[    0.048324] ACPI: bus type PCI registered
[    0.049586] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.051469] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.052009] PCI: Using configuration type 1 for base access
[    0.056509] bio: create slab <bio-0> at 0
[    0.057954] ACPI: Added _OSI(Module Device)
[    0.059032] ACPI: Added _OSI(Processor Device)
[    0.060015] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.064021] ACPI: Added _OSI(Processor Aggregator Device)
[    0.076253] ACPI: Interpreter enabled
[    0.077283] ACPI: (supports S0 S5)
[    0.078237] ACPI: Using PIC for interrupt routing
[    0.079421] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.091897] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.092020] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.093333] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.095244] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.096156] PCI host bridge to bus 0000:00
[    0.097232] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.098501] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.099870] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.100009] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.101556] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.103164] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.104739] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.106948] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.110988] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.113638] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.115427] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.116022] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.118068] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.120762] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.123799] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.130953] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.132725] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.135207] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.137108] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.143843] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.144499] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.146455] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.151828] pci_bus 0000:00: on NUMA node 0
[    0.153621] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.155606] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.157217] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.159255] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.161119] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.163338] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.164025] ACPI: \_SB_.PCI0: notify handler is installed
[    0.165493] Found 1 acpi root devices
[    0.166907] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.168010] vgaarb: loaded
[    0.168861] vgaarb: bridge control possible 0000:00:02.0
[    0.170468] SCSI subsystem initialized
[    0.171571] pps_core: LinuxPPS API ver. 1 registered
[    0.172007] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.174201] PTP clock support registered
[    0.175318] PCI: Using ACPI for IRQ routing
[    0.176011] PCI: pci_cache_line_size set to 64 bytes
[    0.177405] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.178808] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.180598] Bluetooth: Core ver 2.17
[    0.181653] NET: Registered protocol family 31
[    0.182805] Bluetooth: HCI device and connection manager initialized
[    0.184031] Bluetooth: HCI socket layer initialized
[    0.185216] Bluetooth: L2CAP socket layer initialized
[    0.186430] Bluetooth: SCO socket layer initialized
[    0.187631] NET: Registered protocol family 8
[    0.188008] NET: Registered protocol family 20
[    0.189548] Switched to clocksource kvm-clock
[    0.191005] FS-Cache: Loaded
[    0.191929] pnp: PnP ACPI init
[    0.192000] ACPI: bus type PNP registered
[    0.192591] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.194157] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.195314] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.197317] pnp 00:03: [dma 2]
[    0.198301] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.199900] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.201559] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.203101] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.204989] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.206695] pnp: PnP ACPI: found 8 devices
[    0.207757] ACPI: bus type PNP unregistered
[    0.208857] PnPBIOS: Disabled
[    0.552779] mdacon: MDA with 8K of memory detected.
[    0.552878] Console: switching consoles 13-16 to MDA-2
[    0.590231] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.591608] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.592989] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.594387] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.595873] NET: Registered protocol family 2
[    0.597636] TCP established hash table entries: 4096 (order: 2, 16384 by=
tes)
[    0.599217] TCP bind hash table entries: 4096 (order: 5, 180224 bytes)
[    0.601304] TCP: Hash tables configured (established 4096 bind 4096)
[    0.602779] TCP: reno registered
[    0.603706] UDP hash table entries: 256 (order: 2, 24576 bytes)
[    0.605135] UDP-Lite hash table entries: 256 (order: 2, 24576 bytes)
[    0.606847] NET: Registered protocol family 1
[    0.607981] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.609379] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.610711] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.612145] pci 0000:00:02.0: Boot video device
[    0.613305] PCI: CLS 0 bytes, default 64
[    0.614699] Unpacking initramfs...
[    0.732188] Freeing initrd memory: 3276K (d3cbd000 - d3ff0000)
[    0.733895] BUG: unable to handle kernel NULL pointer dereference at 000=
00028
[    0.735603] IP: [<c09b20cb>] rapl_pmu_init+0x11e/0x139
[    0.736012] *pdpt =3D 0000000000000000 *pde =3D f000ff53f000ff53=20
[    0.736012] Oops: 0000 [#1] PREEMPT=20
[    0.736012] Modules linked in:
[    0.736012] CPU: 0 PID: 1 Comm: swapper Not tainted 3.12.0-05711-g4788e5=
b #11
[    0.736012] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.736012] task: d244c020 ti: d244e000 task.ti: d244e000
[    0.736012] EIP: 0060:[<c09b20cb>] EFLAGS: 00010202 CPU: 0
[    0.736012] EIP is at rapl_pmu_init+0x11e/0x139
[    0.736012] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000001
[    0.736012] ESI: c09b1fad EDI: 000000cc EBP: d244ff00 ESP: d244fef0
[    0.736012]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[    0.736012] CR0: 80050033 CR2: 00000028 CR3: 00a16000 CR4: 000406b0
[    0.736012] Stack:
[    0.736012]  c04ddabe 00000000 00000002 00000000 d244ff74 c0200477 c0251=
b16 d244ff2c
[    0.736012]  c025467d d3ff63cb d244ff34 c02410cb d3ff63cb d244ff00 c09aa=
512 c080d71c
[    0.736012]  000000cc d244ff74 c02412d5 c0829fe0 00000286 c023b6d8 00000=
246 00060006
[    0.736012] Call Trace:
[    0.736012]  [<c04ddabe>] ? register_syscore_ops+0x32/0x35
[    0.736012]  [<c0200477>] do_one_initcall+0xdf/0x138
[    0.736012]  [<c0251b16>] ? lock_release_holdtime.part.20+0x93/0xf8
[    0.736012]  [<c025467d>] ? trace_hardirqs_on_caller+0xeb/0x1ad
[    0.736012]  [<c02410cb>] ? parameq+0x13/0x5e
[    0.736012]  [<c09aa512>] ? repair_env_string+0x12/0x51
[    0.736012]  [<c02412d5>] ? parse_args+0x1bf/0x2f8
[    0.736012]  [<c023b6d8>] ? __usermodehelper_set_disable_depth+0x3e/0x44
[    0.736012]  [<c09aab46>] kernel_init_freeable+0xde/0x178
[    0.736012]  [<c09aa500>] ? do_early_param+0x78/0x78
[    0.736012]  [<c064bd10>] kernel_init+0xb/0xed
[    0.736012]  [<c0249199>] ? schedule_tail+0xc/0x3a
[    0.736012]  [<c0659637>] ret_from_kernel_thread+0x1b/0x28
[    0.736012]  [<c064bd05>] ? rest_init+0xb5/0xb5
[    0.736012] Code: 99 87 ff 89 5c 24 04 c7 04 24 90 bf 76 c0 e8 dd e9 c9 =
ff 83 c8 ff eb 28 a1 44 bc a1 c0 f3 0f b8 c0 90 89 44 24 08 a1 80 73 82 c0 =
<8b> 40 28 89 44 24 04 c7 04 24 d4 bf 76 c0 e8 b2 e9 c9 ff 31 c0
[    0.736012] EIP: [<c09b20cb>] rapl_pmu_init+0x11e/0x139 SS:ESP 0068:d244=
fef0
[    0.736012] CR2: 0000000000000028
[    0.736012] ---[ end trace 0a81712c9fb36a0a ]---
[    0.736012] swapper (1) used greatest stack depth: 5800 bytes left
[    0.798045] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x00000009
[    0.798045]=20
[    0.800575] Rebooting in 10 seconds..
Elapsed time: 5
qemu-system-x86_64 -enable-kvm -cpu Haswell,+smep,+smap -kernel /kernel/i38=
6-randconfig-ib1-07251153/4788e5b4b2338f85fa42a712a182d8afd65d7c58/vmlinuz-=
3.12.0-05711-g4788e5b -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,1152=
00 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=
=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=
=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 r=
w link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-ib1-07251153/next:mast=
er:4788e5b4b2338f85fa42a712a182d8afd65d7c58:bisect-linux-9/.vmlinuz-4788e5b=
4b2338f85fa42a712a182d8afd65d7c58-20140725185250-1-kbuild branch=3Dnext/mas=
ter BOOT_IMAGE=3D/kernel/i386-randconfig-ib1-07251153/4788e5b4b2338f85fa42a=
712a182d8afd65d7c58/vmlinuz-3.12.0-05711-g4788e5b drbd.minor_count=3D8'  -i=
nitrd /kernel-tests/initrd/yocto-minimal-i386.cgz -m 320 -smp 1 -net nic,vl=
an=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchd=
og i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-yocto-kbuild-=
7 -serial file:/dev/shm/kboot/serial-yocto-kbuild-7 -daemonize -display non=
e -monitor null=20

--JbKQpFqZXJ2T76Sg
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-ib1-07251153-1a58d9909611972fd1c081bb04a9f7dc2571e612-BUG:-unable-to-handle-kernel-NULL-pointer-dereference-83318.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgMWE1OGQ5OS4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxl
cyBmb3IgMjAxNDA3MjQKZ2l0IGNoZWNrb3V0IDlhM2M0MTQ1YWYzMjEyNWM1ZWUzOWMwMjcy
NjYyYjQ3MzA3YTgzMjMKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYt
cmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvbmV4dDptYXN0ZXI6OWEzYzQxNDVhZjMyMTI1YzVl
ZTM5YzAyNzI2NjJiNDczMDdhODMyMzpiaXNlY3QtbGludXgtOQoKMjAxNC0wNy0yNS0xMjoy
Mjo1MCA5YTNjNDE0NWFmMzIxMjVjNWVlMzljMDI3MjY2MmI0NzMwN2E4MzIzIGNvbXBpbGlu
ZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYt
cmFuZGNvbmZpZy1pYjEtMDcyNTExNTMtOWEzYzQxNDVhZjMyMTI1YzVlZTM5YzAyNzI2NjJi
NDczMDdhODMyMwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWliMS0wNzI1MTE1My85YTNjNDE0NWFmMzIxMjVjNWVlMzljMDI3MjY2MmI0NzMwN2E4MzIz
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9p
Mzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzLTlhM2M0MTQ1YWYzMjEyNWM1ZWUzOWMwMjcy
NjYyYjQ3MzA3YTgzMjMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL2pha2V0b3duLWNvbnN1bWVyL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcy
NTExNTMtOWEzYzQxNDVhZjMyMTI1YzVlZTM5YzAyNzI2NjJiNDczMDdhODMyMwprZXJuZWw6
IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My85YTNjNDE0NWFmMzIxMjVj
NWVlMzljMDI3MjY2MmI0NzMwN2E4MzIzL3ZtbGludXotMy4xNi4wLXJjNgoKMjAxNC0wNy0y
NS0xMjoyNzo1MCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgkyCTQJMTM1CTE3MwkyMTAJMjk5
Li4uLi4uLi4uLi4uLi4uLgkzMDAgU1VDQ0VTUwoKYmlzZWN0OiBnb29kIGNvbW1pdCA5YTNj
NDE0NWFmMzIxMjVjNWVlMzljMDI3MjY2MmI0NzMwN2E4MzIzCmdpdCBiaXNlY3Qgc3RhcnQg
MWE1OGQ5OTA5NjExOTcyZmQxYzA4MWJiMDRhOWY3ZGMyNTcxZTYxMiA5YTNjNDE0NWFmMzIx
MjVjNWVlMzljMDI3MjY2MmI0NzMwN2E4MzIzIC0tCi9jL2tlcm5lbC10ZXN0cy9saW5lYXIt
YmlzZWN0OiBbIi1iIiwgIjFhNThkOTkwOTYxMTk3MmZkMWMwODFiYjA0YTlmN2RjMjU3MWU2
MTIiLCAiLWciLCAiOWEzYzQxNDVhZjMyMTI1YzVlZTM5YzAyNzI2NjJiNDczMDdhODMyMyIs
ICIvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIiwgIi9jL2Jv
b3QtYmlzZWN0L2xpbnV4LTkvb2JqLWJpc2VjdCJdCkJpc2VjdGluZzogODcwMiByZXZpc2lv
bnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTQgc3RlcHMpCltjODM4ZTlh
MDk0NzliMmIyZDg5MTUwZWY5MGRjM2VhYzg4ZjA2YjgxXSBNZXJnZSByZW1vdGUtdHJhY2tp
bmcgYnJhbmNoICd0aGVybWFsL25leHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2Vj
dC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC05L29iai1iaXNl
Y3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1p
YjEtMDcyNTExNTMvbmV4dDptYXN0ZXI6YzgzOGU5YTA5NDc5YjJiMmQ4OTE1MGVmOTBkYzNl
YWM4OGYwNmI4MTpiaXNlY3QtbGludXgtOQoKMjAxNC0wNy0yNS0xMjo0MDoyNCBjODM4ZTlh
MDk0NzliMmIyZDg5MTUwZWY5MGRjM2VhYzg4ZjA2YjgxIGNvbXBpbGluZwpRdWV1ZWQgYnVp
bGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1p
YjEtMDcyNTExNTMtYzgzOGU5YTA5NDc5YjJiMmQ4OTE1MGVmOTBkYzNlYWM4OGYwNmI4MQpD
aGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1
My9jODM4ZTlhMDk0NzliMmIyZDg5MTUwZWY5MGRjM2VhYzg4ZjA2YjgxCndhaXRpbmcgZm9y
IGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25m
aWctaWIxLTA3MjUxMTUzLWM4MzhlOWEwOTQ3OWIyYjJkODkxNTBlZjkwZGMzZWFjODhmMDZi
ODEKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvYzgzOGU5
YTA5NDc5YjJiMmQ4OTE1MGVmOTBkYzNlYWM4OGYwNmI4MS92bWxpbnV6LTMuMTYuMC1yYzYt
MDIyMDctZ2M4MzhlOWEKCjIwMTQtMDctMjUtMTI6NDI6MjQgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgCTI4IFRFU1QgRkFJTFVSRQpbICAgIDAuOTg2NjMwXSBQQ0k6IENMUyAwIGJ5dGVzLCBk
ZWZhdWx0IDY0ClsgICAgMC45ODgwNTVdIFVucGFja2luZyBpbml0cmFtZnMuLi4KWyAgICAw
Ljk5MTk0OF0gSW5pdHJhbWZzIHVucGFja2luZyBmYWlsZWQ6IGp1bmsgaW4gY29tcHJlc3Nl
ZCBhcmNoaXZlClsgICAgMC45OTQyNzNdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwg
TlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0IDAwMDAwMDBjClsgICAgMC45OTQ2NzhdIElQ
OiBbPGQxYzU3OGQxPl0gdmFsaWRhdGVfY2hhaW4uaXNyYS4zNysweGM1LzB4MTBlNQpbICAg
IDAuOTk0Njc4XSAqcGRwdCA9IDAwMDAwMDAwMDAwMDAwMDAgKnBkZSA9IGYwMDBmZjUzZjAw
MGZmNTMgClsgICAgMC45OTQ2NzhdIE9vcHM6IDAwMDAgWyMxXSBQUkVFTVBUIApbICAgIDAu
OTk0Njc4XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAwLjk5NDY3OF0gQ1BVOiAwIFBJRDog
MSBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTYuMC1yYzYtMDIyMDctZ2M4MzhlOWEg
IzEKWyAgICAwLjk5NDY3OF0gSGFyZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQQyAoaTQ0
MEZYICsgUElJWCwgMTk5NiksIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDAuOTk0Njc4
XSB0YXNrOiBkMDQ0YTAxMCB0aTogZDA0NGMwMDAgdGFzay50aTogZDA0NGMwMDAKWyAgICAw
Ljk5NDY3OF0gRUlQOiAwMDYwOls8ZDFjNTc4ZDE+XSBFRkxBR1M6IDAwMDEwMDgyIENQVTog
MApbICAgIDAuOTk0Njc4XSBFSVAgaXMgYXQgdmFsaWRhdGVfY2hhaW4uaXNyYS4zNysweGM1
LzB4MTBlNQpbICAgIDAuOTk0Njc4XSBFQVg6IDAwMDAwMDAwIEVCWDogMDAwMDAwODUgRUNY
OiAwMDAwMDAwMCBFRFg6IGZmZmZmZmZjClsgICAgMC45OTQ2NzhdIEVTSTogZDA0NGE0Zjgg
RURJOiBkMjg1Y2MwOCBFQlA6IGQwNDRkZGQ4IEVTUDogZDA0NGRkNzQKWyAgICAwLjk5NDY3
OF0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMDAwIEdTOiAwMGUwIFNTOiAwMDY4ClsgICAg
MC45OTQ2NzhdIENSMDogODAwNTAwM2IgQ1IyOiAwMDAwMDAwYyBDUjM6IDEyNDVjMDAwIENS
NDogMDAwMDA2YjAKWyAgICAwLjk5NDY3OF0gU3RhY2s6ClsgICAgMC45OTQ2NzhdICAwMDAw
MDA4NSBkMDQ0ZGQ4MCBkMWMyM2U5ZSBkMDQ0ZGQ4OCBkMWMwN2QzNSBkMDQ0ZGRiNCBkMjhh
MWZiMCBkMDQ0YTRmOApbICAgIDAuOTk0Njc4XSAgMDAwMDAwMDEgZDA0NGEwMTAgMDAwMDAw
MDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgZDA0NGEwMTAgMDAwMDAwODUKWyAgICAw
Ljk5NDY3OF0gIGQwNDRkZGQwIGQxYzRkNTg4IDNiNDMyOGQ4IDAwMDAwMDAwIDAwMDAwMDAw
IGQwNDRhMDEwIDAwMDAwMDg1IGQwNDRhMDEwClsgICAgMC45OTQ2NzhdIENhbGwgVHJhY2U6
ClsgICAgMC45OTQ2NzhdICBbPGQxYzIzZTllPl0gPyBrdm1fY2xvY2tfcmVhZCsweDEzLzB4
MjQKWyAgICAwLjk5NDY3OF0gIFs8ZDFjMDdkMzU+XSA/IHNjaGVkX2Nsb2NrKzB4OC8weGIK
WyAgICAwLjk5NDY3OF0gIFs8ZDFjNGQ1ODg+XSA/IHNjaGVkX2Nsb2NrX2NwdSsweGIxLzB4
ZDAKWyAgICAwLjk5NDY3OF0gIFs8ZDFjNTk4NTI+XSBfX2xvY2tfYWNxdWlyZSsweDM1MC8w
eGFhNQpbICAgIDAuOTk0Njc4XSAgWzxkMWM1YTZmNz5dIGxvY2tfYWNxdWlyZSsweDc3LzB4
OTIKWyAgICAwLjk5NDY3OF0gIFs8ZDFjOGU2NDg+XSA/IGFkanVzdF9tYW5hZ2VkX3BhZ2Vf
Y291bnQrMHgxMy8weDRhClsgICAgMC45OTQ2NzhdICBbPGQyMDg3NDhjPl0gX3Jhd19zcGlu
X2xvY2srMHgzYy8weDY5ClsgICAgMC45OTQ2NzhdICBbPGQxYzhlNjQ4Pl0gPyBhZGp1c3Rf
bWFuYWdlZF9wYWdlX2NvdW50KzB4MTMvMHg0YQpbICAgIDAuOTk0Njc4XSAgWzxkMWM4ZTY0
OD5dIGFkanVzdF9tYW5hZ2VkX3BhZ2VfY291bnQrMHgxMy8weDRhClsgICAgMC45OTQ2Nzhd
ICBbPGQxYzkxYTgyPl0gZnJlZV9yZXNlcnZlZF9hcmVhKzB4NmIvMHhkYwpbICAgIDAuOTk0
Njc4XSAgWzxkMWMyNzc5MT5dID8gc2V0X21lbW9yeV9ydysweDQ4LzB4NGEKWyAgICAwLjk5
NDY3OF0gIFs8ZDFjMjRiZTA+XSBmcmVlX2luaXRfcGFnZXMrMHg1Yi8weDdlClsgICAgMC45
OTQ2NzhdICBbPGQyM2YwY2U2Pl0gPyBtYXliZV9saW5rLnBhcnQuMisweGU0LzB4ZTQKWyAg
ICAwLjk5NDY3OF0gIFs8ZDIzZjBjZTY+XSA/IG1heWJlX2xpbmsucGFydC4yKzB4ZTQvMHhl
NApbICAgIDAuOTk0Njc4XSAgWzxkMjNmZDg2Yz5dIGZyZWVfaW5pdHJkX21lbSsweDI2LzB4
MmEKWyAgICAwLjk5NDY3OF0gIFs8ZDIzZjBkYmQ+XSBwb3B1bGF0ZV9yb290ZnMrMHhkNy8w
eGY5ClsgICAgMC45OTQ2NzhdICBbPGQyM2YwY2U2Pl0gPyBtYXliZV9saW5rLnBhcnQuMisw
eGU0LzB4ZTQKWyAgICAwLjk5NDY3OF0gIFs8ZDFjMDA0MjY+XSBkb19vbmVfaW5pdGNhbGwr
MHg3Zi8weDFiOQpbICAgIDAuOTk0Njc4XSAgWzxkMjNmMGNlNj5dID8gbWF5YmVfbGluay5w
YXJ0LjIrMHhlNC8weGU0ClsgICAgMC45OTQ2NzhdICBbPGQxYzQzMTliPl0gPyBwYXJhbWVx
KzB4MTMvMHg1ZQpbICAgIDAuOTk0Njc4XSAgWzxkMjNlZjU5Yj5dID8gcmVwYWlyX2Vudl9z
dHJpbmcrMHgxMi8weDUxClsgICAgMC45OTQ2NzhdICBbPGQxYzQzM2NlPl0gPyBwYXJzZV9h
cmdzKzB4MWU4LzB4MzE4ClsgICAgMC45OTQ2NzhdICBbPGQxYzNkOTFhPl0gPyBfX3VzZXJt
b2RlaGVscGVyX3NldF9kaXNhYmxlX2RlcHRoKzB4M2UvMHg0NApbICAgIDAuOTk0Njc4XSAg
WzxkMjNlZmNlNz5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4ZGUvMHgxNzgKWyAgICAwLjk5
NDY3OF0gIFs8ZDIzZWY1ODk+XSA/IGluaXRjYWxsX2JsYWNrbGlzdCsweDgxLzB4ODEKWyAg
ICAwLjk5NDY3OF0gIFs8ZDIwN2MwMTA+XSBrZXJuZWxfaW5pdCsweGIvMHhjNwpbICAgIDAu
OTk0Njc4XSAgWzxkMWM0YmE4ZT5dID8gc2NoZWR1bGVfdGFpbCsweGMvMHgzYQpbICAgIDAu
OTk0Njc4XSAgWzxkMjA4ODI0MD5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgyMC8weDMw
ClsgICAgMC45OTQ2NzhdICBbPGQyMDdjMDA1Pl0gPyByZXN0X2luaXQrMHhiNS8weGI1Clsg
ICAgMC45OTQ2NzhdIENvZGU6IDg5IDRkIGM0IDM5IGM3IDc0IDQxIDhiIDRkIGM4IDMzIDQ4
IDBjIDhiIDUwIDA4IDMxIGRhIDA5IGQxIDBmIDg0IDU5IDAzIDAwIDAwIDhiIDU1IGM0IDg5
IDc1IGI4IDhiIDQ1IGM4IDg5IDQ1IGM0IGViIDEzIDhiIDRkIGM0IDwzMz4gNDggMGMgOGIg
NzAgMDggMzEgZGUgMDkgZjEgMGYgODQgMzggMDMgMDAgMDAgOGIgNDIgMDQgOGQgNTAKWyAg
ICAwLjk5NDY3OF0gRUlQOiBbPGQxYzU3OGQxPl0gdmFsaWRhdGVfY2hhaW4uaXNyYS4zNysw
eGM1LzB4MTBlNSBTUzpFU1AgMDA2ODpkMDQ0ZGQ3NApbICAgIDAuOTk0Njc4XSBDUjI6IDAw
MDAwMDAwMDAwMDAwMGMKWyAgICAwLjk5NDY3OF0gLS0tWyBlbmQgdHJhY2UgMjQ3NjNmM2Iy
NTBhMjRkNiBdLS0tClsgICAgMC45OTQ2NzhdIG5vdGU6IHN3YXBwZXJbMV0gZXhpdGVkIHdp
dGggcHJlZW1wdF9jb3VudCAxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1
My9jODM4ZTlhMDk0NzliMmIyZDg5MTUwZWY5MGRjM2VhYzg4ZjA2YjgxL2RtZXNnLXF1YW50
YWwtaXZiNDItNTA6MjAxNDA3MjUxMjQ1MzU6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1
Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My9jODM4ZTlhMDk0Nzli
MmIyZDg5MTUwZWY5MGRjM2VhYzg4ZjA2YjgxL2RtZXNnLXF1YW50YWwtaXZiNDItMTExOjIw
MTQwNzI1MTI0NjE4OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTM6OgoyNjoyOjQgYWxs
X2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2VjdGluZzogMjIxMiByZXZpc2lvbnMgbGVm
dCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTIgc3RlcHMpCltmNjc1Yzk0ODI2MTkw
ZDRmYjlkZWMwYjUyOTEzZjgwNzU0YzJiZTZmXSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJh
bmNoICdtNjhrL2Zvci1uZXh0JwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVz
dC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtOS9vYmotYmlzZWN0Cmxz
IC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaWIxLTA3
MjUxMTUzL25leHQ6bWFzdGVyOmY2NzVjOTQ4MjYxOTBkNGZiOWRlYzBiNTI5MTNmODA3NTRj
MmJlNmY6YmlzZWN0LWxpbnV4LTkKCjIwMTQtMDctMjUtMTI6NDM6MTcgZjY3NWM5NDgyNjE5
MGQ0ZmI5ZGVjMGI1MjkxM2Y4MDc1NGMyYmU2ZiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRh
c2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaWIxLTA3
MjUxMTUzLWY2NzVjOTQ4MjYxOTBkNGZiOWRlYzBiNTI5MTNmODA3NTRjMmJlNmYKQ2hlY2sg
Zm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvZjY3
NWM5NDgyNjE5MGQ0ZmI5ZGVjMGI1MjkxM2Y4MDc1NGMyYmU2Zgp3YWl0aW5nIGZvciBjb21w
bGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWli
MS0wNzI1MTE1My1mNjc1Yzk0ODI2MTkwZDRmYjlkZWMwYjUyOTEzZjgwNzU0YzJiZTZmCmtl
cm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzL2Y2NzVjOTQ4MjYx
OTBkNGZiOWRlYzBiNTI5MTNmODA3NTRjMmJlNmYvdm1saW51ei0zLjE2LjAtcmM2LTAxMTg2
LWdmNjc1Yzk0CgoyMDE0LTA3LTI1LTEyOjQ1OjI4IGRldGVjdGluZyBib290IHN0YXRlIAk0
MAk3NQkxMDQJMTMwCTE1NQkxODIJMjA1CTIyMSBURVNUIEZBSUxVUkUKWyAgICAwLjY3MDM0
OF0gUENJOiBDTFMgMCBieXRlcywgZGVmYXVsdCA2NApbICAgIDAuNjcxNjg1XSBVbnBhY2tp
bmcgaW5pdHJhbWZzLi4uClsgICAgMC42NzU1MzldIEluaXRyYW1mcyB1bnBhY2tpbmcgZmFp
bGVkOiBqdW5rIGluIGNvbXByZXNzZWQgYXJjaGl2ZQpbICAgIDAuNjc4MDA0XSBCVUc6IHVu
YWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCAwMDAw
MDAwYwpbICAgIDAuNjc5NzU2XSBJUDogWzxkMWM1NzkzMT5dIHZhbGlkYXRlX2NoYWluLmlz
cmEuMzcrMHhjNS8weDEwZTUKWyAgICAwLjY4MTA3N10gKnBkcHQgPSAwMDAwMDAwMDAwMDAw
MDAwICpwZGUgPSBmMDAwZmY1M2YwMDBmZjUzIApbICAgIDAuNjgxMDc3XSBPb3BzOiAwMDAw
IFsjMV0gUFJFRU1QVCAKWyAgICAwLjY4MTA3N10gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAg
MC42ODEwNzddIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjE2
LjAtcmM2LTAxMTg2LWdmNjc1Yzk0ICMyClsgICAgMC42ODEwNzddIEhhcmR3YXJlIG5hbWU6
IFFFTVUgU3RhbmRhcmQgUEMgKGk0NDBGWCArIFBJSVgsIDE5OTYpLCBCSU9TIEJvY2hzIDAx
LzAxLzIwMTEKWyAgICAwLjY4MTA3N10gdGFzazogZDA0NGEwMTAgdGk6IGQwNDRjMDAwIHRh
c2sudGk6IGQwNDRjMDAwClsgICAgMC42ODEwNzddIEVJUDogMDA2MDpbPGQxYzU3OTMxPl0g
RUZMQUdTOiAwMDAxMDA4NiBDUFU6IDAKWyAgICAwLjY4MTA3N10gRUlQIGlzIGF0IHZhbGlk
YXRlX2NoYWluLmlzcmEuMzcrMHhjNS8weDEwZTUKWyAgICAwLjY4MTA3N10gRUFYOiAwMDAw
MDAwMCBFQlg6IDAwMDAwMDg0IEVDWDogMDAwMDAwMDAgRURYOiBmZmZmZmZmYwpbICAgIDAu
NjgxMDc3XSBFU0k6IGQwNDRhNGY4IEVESTogZDI4NzQzMzAgRUJQOiBkMDQ0ZGRkOCBFU1A6
IGQwNDRkZDc0ClsgICAgMC42ODEwNzddICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDAwMCBH
UzogMDBlMCBTUzogMDA2OApbICAgIDAuNjgxMDc3XSBDUjA6IDgwMDUwMDNiIENSMjogMDAw
MDAwMGMgQ1IzOiAxMjQ1YjAwMCBDUjQ6IDAwMDAwNmIwClsgICAgMC42ODEwNzddIFN0YWNr
OgpbICAgIDAuNjgxMDc3XSAgMDAwMDAwODQgZDA0NGRkODAgZDFjMjNlZmUgZDA0NGRkODgg
ZDFjMDdkMzUgZDA0NGRkYjQgZDI4YTBlODAgZDA0NGE0ZjgKWyAgICAwLjY4MTA3N10gIDAw
MDAwMDAxIGQwNDRhMDEwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIGQw
NDRhMDEwIDAwMDAwMDg0ClsgICAgMC42ODEwNzddICBkMDQ0ZGRkMCBkMWM0ZDVlOCAyODY5
NTIyZSAwMDAwMDAwMCAwMDAwMDAwMCBkMDQ0YTAxMCAwMDAwMDA4NCBkMDQ0YTAxMApbICAg
IDAuNjgxMDc3XSBDYWxsIFRyYWNlOgpbICAgIDAuNjgxMDc3XSAgWzxkMWMyM2VmZT5dID8g
a3ZtX2Nsb2NrX3JlYWQrMHgxMy8weDI0ClsgICAgMC42ODEwNzddICBbPGQxYzA3ZDM1Pl0g
PyBzY2hlZF9jbG9jaysweDgvMHhiClsgICAgMC42ODEwNzddICBbPGQxYzRkNWU4Pl0gPyBz
Y2hlZF9jbG9ja19jcHUrMHhiMS8weGQwClsgICAgMC42ODEwNzddICBbPGQxYzU5OGIyPl0g
X19sb2NrX2FjcXVpcmUrMHgzNTAvMHhhYTUKWyAgICAwLjY4MTA3N10gIFs8ZDFjNWE3NTc+
XSBsb2NrX2FjcXVpcmUrMHg3Ny8weDkyClsgICAgMC42ODEwNzddICBbPGQxYzhlNmE4Pl0g
PyBhZGp1c3RfbWFuYWdlZF9wYWdlX2NvdW50KzB4MTMvMHg0YQpbICAgIDAuNjgxMDc3XSAg
WzxkMjA4Njc4Yz5dIF9yYXdfc3Bpbl9sb2NrKzB4M2MvMHg2OQpbICAgIDAuNjgxMDc3XSAg
WzxkMWM4ZTZhOD5dID8gYWRqdXN0X21hbmFnZWRfcGFnZV9jb3VudCsweDEzLzB4NGEKWyAg
ICAwLjY4MTA3N10gIFs8ZDFjOGU2YTg+XSBhZGp1c3RfbWFuYWdlZF9wYWdlX2NvdW50KzB4
MTMvMHg0YQpbICAgIDAuNjgxMDc3XSAgWzxkMWM5MWFlMj5dIGZyZWVfcmVzZXJ2ZWRfYXJl
YSsweDZiLzB4ZGMKWyAgICAwLjY4MTA3N10gIFs8ZDFjMjc3ZjE+XSA/IHNldF9tZW1vcnlf
cncrMHg0OC8weDRhClsgICAgMC42ODEwNzddICBbPGQxYzI0YzQwPl0gZnJlZV9pbml0X3Bh
Z2VzKzB4NWIvMHg3ZQpbICAgIDAuNjgxMDc3XSAgWzxkMjNlZWNlNj5dID8gbWF5YmVfbGlu
ay5wYXJ0LjIrMHhlNC8weGU0ClsgICAgMC42ODEwNzddICBbPGQyM2VlY2U2Pl0gPyBtYXli
ZV9saW5rLnBhcnQuMisweGU0LzB4ZTQKWyAgICAwLjY4MTA3N10gIFs8ZDIzZmI4NmM+XSBm
cmVlX2luaXRyZF9tZW0rMHgyNi8weDJhClsgICAgMC42ODEwNzddICBbPGQyM2VlZGJkPl0g
cG9wdWxhdGVfcm9vdGZzKzB4ZDcvMHhmOQpbICAgIDAuNjgxMDc3XSAgWzxkMjNlZWNlNj5d
ID8gbWF5YmVfbGluay5wYXJ0LjIrMHhlNC8weGU0ClsgICAgMC42ODEwNzddICBbPGQxYzAw
NDI2Pl0gZG9fb25lX2luaXRjYWxsKzB4N2YvMHgxYjkKWyAgICAwLjY4MTA3N10gIFs8ZDIz
ZWVjZTY+XSA/IG1heWJlX2xpbmsucGFydC4yKzB4ZTQvMHhlNApbICAgIDAuNjgxMDc3XSAg
WzxkMWM1OTIxOD5dID8gdHJhY2VfaGFyZGlycXNfb25fY2FsbGVyKzB4ZWIvMHgxYWYKWyAg
ICAwLjY4MTA3N10gIFs8ZDFjNDMxZmI+XSA/IHBhcmFtZXErMHgxMy8weDVlClsgICAgMC42
ODEwNzddICBbPGQyM2VkNTliPl0gPyByZXBhaXJfZW52X3N0cmluZysweDEyLzB4NTEKWyAg
ICAwLjY4MTA3N10gIFs8ZDFjNDM0MmU+XSA/IHBhcnNlX2FyZ3MrMHgxZTgvMHgzMTgKWyAg
ICAwLjY4MTA3N10gIFs8ZDFjM2Q5N2E+XSA/IF9fdXNlcm1vZGVoZWxwZXJfc2V0X2Rpc2Fi
bGVfZGVwdGgrMHgzZS8weDQ0ClsgICAgMC42ODEwNzddICBbPGQyM2VkY2U3Pl0ga2VybmVs
X2luaXRfZnJlZWFibGUrMHhkZS8weDE3OApbICAgIDAuNjgxMDc3XSAgWzxkMjNlZDU4OT5d
ID8gaW5pdGNhbGxfYmxhY2tsaXN0KzB4ODEvMHg4MQpbICAgIDAuNjgxMDc3XSAgWzxkMjA3
YWQzMD5dIGtlcm5lbF9pbml0KzB4Yi8weGM3ClsgICAgMC42ODEwNzddICBbPGQxYzRiYWVl
Pl0gPyBzY2hlZHVsZV90YWlsKzB4Yy8weDNhClsgICAgMC42ODEwNzddICBbPGQyMDg3NTQw
Pl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDIwLzB4MzAKWyAgICAwLjY4MTA3N10gIFs8
ZDIwN2FkMjU+XSA/IHJlc3RfaW5pdCsweGI1LzB4YjUKWyAgICAwLjY4MTA3N10gQ29kZTog
ODkgNGQgYzQgMzkgYzcgNzQgNDEgOGIgNGQgYzggMzMgNDggMGMgOGIgNTAgMDggMzEgZGEg
MDkgZDEgMGYgODQgNTkgMDMgMDAgMDAgOGIgNTUgYzQgODkgNzUgYjggOGIgNDUgYzggODkg
NDUgYzQgZWIgMTMgOGIgNGQgYzQgPDMzPiA0OCAwYyA4YiA3MCAwOCAzMSBkZSAwOSBmMSAw
ZiA4NCAzOCAwMyAwMCAwMCA4YiA0MiAwNCA4ZCA1MApbICAgIDAuNjgxMDc3XSBFSVA6IFs8
ZDFjNTc5MzE+XSB2YWxpZGF0ZV9jaGFpbi5pc3JhLjM3KzB4YzUvMHgxMGU1IFNTOkVTUCAw
MDY4OmQwNDRkZDc0ClsgICAgMC42ODEwNzddIENSMjogMDAwMDAwMDAwMDAwMDAwYwpbICAg
IDAuNjgxMDc3XSAtLS1bIGVuZCB0cmFjZSAxN2YzODM3NjVlMjk5NmFjIF0tLS0KWyAgICAw
LjY4MTA3N10gbm90ZTogc3dhcHBlclsxXSBleGl0ZWQgd2l0aCBwcmVlbXB0X2NvdW50IDEK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzL2Y2NzVjOTQ4MjYxOTBkNGZi
OWRlYzBiNTI5MTNmODA3NTRjMmJlNmYvZG1lc2ctcXVhbnRhbC1pdmI0My0xNDoyMDE0MDcy
NTEyNTYwODppMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzOjoKMjE4OjE6NSBhbGxfZ29v
ZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wNy0yNSAxMjo0OToyOSBSRVBFQVQg
Q09VTlQ6IDMwMCAgIyAvYy9ib290LWJpc2VjdC9saW51eC05L29iai1iaXNlY3QvLnJlcGVh
dBtbMG0KCkJpc2VjdGluZzogMTE5MSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgMTEgc3RlcHMpCltlYTQ3MWIzZjg1OTIxODdjMTkzMGIyZTBkOGJmMjkx
NjNjMTNkYjU2XSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdzb3VuZC1jdXJyZW50
L2Zvci1saW51cycKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTkvb2JqLWJpc2VjdApscyAtYSAva2J1
aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My9u
ZXh0Om1hc3RlcjplYTQ3MWIzZjg1OTIxODdjMTkzMGIyZTBkOGJmMjkxNjNjMTNkYjU2OmJp
c2VjdC1saW51eC05CgoyMDE0LTA3LTI1LTEyOjQ5OjMxIGVhNDcxYjNmODU5MjE4N2MxOTMw
YjJlMGQ4YmYyOTE2M2MxM2RiNTYgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My1l
YTQ3MWIzZjg1OTIxODdjMTkzMGIyZTBkOGJmMjkxNjNjMTNkYjU2CkNoZWNrIGZvciBrZXJu
ZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzL2VhNDcxYjNmODU5
MjE4N2MxOTMwYjJlMGQ4YmYyOTE2M2MxM2RiNTYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBv
ZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTEx
NTMtZWE0NzFiM2Y4NTkyMTg3YzE5MzBiMmUwZDhiZjI5MTYzYzEzZGI1NgprZXJuZWw6IC9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My9lYTQ3MWIzZjg1OTIxODdjMTkz
MGIyZTBkOGJmMjkxNjNjMTNkYjU2L3ZtbGludXotMy4xNi4wLXJjNi0wMDEyMC1nZWE0NzFi
MwoKMjAxNC0wNy0yNS0xMjo1MTozMSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJOAkyOQk0Ngk2
MAk4MAkxMDAJMTE0CTEyOQkxNjUJMTk3CTIwNgkyMTgJMjUwCTI5MAkyOTIuLi4uLi4uLgky
OTMJMjk0LgkyOTcuLgkyOTguLgkzMDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxMDcxIHJldmlz
aW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMSBzdGVwcykKWzNmNTQx
MjQ4N2MzNzhjODQzZDE3OWY4MzU2YjQwYmE2ZmYzNDE5MzBdIE1lcmdlIHJlbW90ZS10cmFj
a2luZyBicmFuY2ggJ2Jlcmxpbi9iZXJsaW4vZm9yLW5leHQnCnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51
eC05L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYt
cmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvbmV4dDptYXN0ZXI6M2Y1NDEyNDg3YzM3OGM4NDNk
MTc5ZjgzNTZiNDBiYTZmZjM0MTkzMDpiaXNlY3QtbGludXgtOQoKMjAxNC0wNy0yNS0xMzow
ODowNSAzZjU0MTI0ODdjMzc4Yzg0M2QxNzlmODM1NmI0MGJhNmZmMzQxOTMwIGNvbXBpbGlu
ZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYt
cmFuZGNvbmZpZy1pYjEtMDcyNTExNTMtM2Y1NDEyNDg3YzM3OGM4NDNkMTc5ZjgzNTZiNDBi
YTZmZjM0MTkzMApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWliMS0wNzI1MTE1My8zZjU0MTI0ODdjMzc4Yzg0M2QxNzlmODM1NmI0MGJhNmZmMzQxOTMw
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9p
Mzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzLTNmNTQxMjQ4N2MzNzhjODQzZDE3OWY4MzU2
YjQwYmE2ZmYzNDE5MzAKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcy
NTExNTMvM2Y1NDEyNDg3YzM3OGM4NDNkMTc5ZjgzNTZiNDBiYTZmZjM0MTkzMC92bWxpbnV6
LTMuMTYuMC1yYzYtMDA5NzQtZzNmNTQxMjQKCjIwMTQtMDctMjUtMTM6MTA6MDUgZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgCTMJMTQ4CTI5Ny4uLi4uLi4uLi4uLi4uLgkyOTkJMzAwIFNVQ0NF
U1MKCkJpc2VjdGluZzogMjEyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAo
cm91Z2hseSA4IHN0ZXBzKQpbN2Q4NDMzMWYwOGE1NzQ2Y2VmZDEyNDMzNzY4NjI0NWIwMGM4
MjViNF0gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAnc2Ftc3VuZy9mb3ItbmV4dCcK
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9j
L2Jvb3QtYmlzZWN0L2xpbnV4LTkvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1
bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My9uZXh0Om1hc3Rlcjo3
ZDg0MzMxZjA4YTU3NDZjZWZkMTI0MzM3Njg2MjQ1YjAwYzgyNWI0OmJpc2VjdC1saW51eC05
CgoyMDE0LTA3LTI1LTEzOjIwOjQ2IDdkODQzMzFmMDhhNTc0NmNlZmQxMjQzMzc2ODYyNDVi
MDBjODI1YjQgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My03ZDg0MzMxZjA4YTU3
NDZjZWZkMTI0MzM3Njg2MjQ1YjAwYzgyNWI0CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzLzdkODQzMzFmMDhhNTc0NmNlZmQxMjQz
Mzc2ODYyNDViMDBjODI1YjQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRl
c3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMtN2Q4NDMzMWYw
OGE1NzQ2Y2VmZDEyNDMzNzY4NjI0NWIwMGM4MjViNAprZXJuZWw6IC9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWliMS0wNzI1MTE1My83ZDg0MzMxZjA4YTU3NDZjZWZkMTI0MzM3Njg2MjQ1
YjAwYzgyNWI0L3ZtbGludXotMy4xNi4wLXJjNi0wMTExMy1nN2Q4NDMzMQoKMjAxNC0wNy0y
NS0xMzoyMjo0NiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTExCTIzCTMzCTUyCTYzCTkyIFRF
U1QgRkFJTFVSRQpbICAgIDAuNTQ0MTMyXSBQQ0k6IENMUyAwIGJ5dGVzLCBkZWZhdWx0IDY0
ClsgICAgMC41NDU1MTBdIFVucGFja2luZyBpbml0cmFtZnMuLi4KWyAgICAwLjU0NjUwMF0g
SW5pdHJhbWZzIHVucGFja2luZyBmYWlsZWQ6IGp1bmsgaW4gY29tcHJlc3NlZCBhcmNoaXZl
ClsgICAgMC41NDk4NTFdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBwb2lu
dGVyIGRlcmVmZXJlbmNlIGF0IDAwMDAwMDBjClsgICAgMC41NTE2MjJdIElQOiBbPGQxZTU3
OTMxPl0gdmFsaWRhdGVfY2hhaW4uaXNyYS4zNysweGM1LzB4MTBlNQpbICAgIDAuNTUyMTg3
XSAqcGRwdCA9IDAwMDAwMDAwMDAwMDAwMDAgKnBkZSA9IGYwMDBmZjUzZjAwMGZmNTMgClsg
ICAgMC41NTIxODddIE9vcHM6IDAwMDAgWyMxXSBQUkVFTVBUIApbICAgIDAuNTUyMTg3XSBN
b2R1bGVzIGxpbmtlZCBpbjoKWyAgICAwLjU1MjE4N10gQ1BVOiAwIFBJRDogMSBDb21tOiBz
d2FwcGVyIE5vdCB0YWludGVkIDMuMTYuMC1yYzYtMDExMTMtZzdkODQzMzEgIzEKWyAgICAw
LjU1MjE4N10gSGFyZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJ
WCwgMTk5NiksIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDAuNTUyMTg3XSB0YXNrOiBk
MDQ0YTAxMCB0aTogZDA0NGMwMDAgdGFzay50aTogZDA0NGMwMDAKWyAgICAwLjU1MjE4N10g
RUlQOiAwMDYwOls8ZDFlNTc5MzE+XSBFRkxBR1M6IDAwMDEwMDg2IENQVTogMApbICAgIDAu
NTUyMTg3XSBFSVAgaXMgYXQgdmFsaWRhdGVfY2hhaW4uaXNyYS4zNysweGM1LzB4MTBlNQpb
ICAgIDAuNTUyMTg3XSBFQVg6IDAwMDAwMDAwIEVCWDogMDAwMDAwODQgRUNYOiAwMDAwMDAw
MCBFRFg6IGZmZmZmZmZjClsgICAgMC41NTIxODddIEVTSTogZDA0NGE0ZjggRURJOiBkMmE3
NDMzMCBFQlA6IGQwNDRkZGQ4IEVTUDogZDA0NGRkNzQKWyAgICAwLjU1MjE4N10gIERTOiAw
MDdiIEVTOiAwMDdiIEZTOiAwMDAwIEdTOiAwMGUwIFNTOiAwMDY4ClsgICAgMC41NTIxODdd
IENSMDogODAwNTAwM2IgQ1IyOiAwMDAwMDAwYyBDUjM6IDEyNjViMDAwIENSNDogMDAwMDA2
YjAKWyAgICAwLjU1MjE4N10gU3RhY2s6ClsgICAgMC41NTIxODddICAwMDAwMDA4NCBkMDQ0
ZGQ4MCBkMWUyM2VmZSBkMDQ0ZGQ4OCBkMWUwN2QzNSBkMDQ0ZGRiNCBkMmFhMGU4MCBkMDQ0
YTRmOApbICAgIDAuNTUyMTg3XSAgMDAwMDAwMDEgZDA0NGEwMTAgMDAwMDAwMDAgMDAwMDAw
MDAgMDAwMDAwMDAgMDAwMDAwMDAgZDA0NGEwMTAgMDAwMDAwODQKWyAgICAwLjU1MjE4N10g
IGQwNDRkZGQwIGQxZTRkNWU4IDIwYzVkNGVmIDAwMDAwMDAwIDAwMDAwMDAwIGQwNDRhMDEw
IDAwMDAwMDg0IGQwNDRhMDEwClsgICAgMC41NTIxODddIENhbGwgVHJhY2U6ClsgICAgMC41
NTIxODddICBbPGQxZTIzZWZlPl0gPyBrdm1fY2xvY2tfcmVhZCsweDEzLzB4MjQKWyAgICAw
LjU1MjE4N10gIFs8ZDFlMDdkMzU+XSA/IHNjaGVkX2Nsb2NrKzB4OC8weGIKWyAgICAwLjU1
MjE4N10gIFs8ZDFlNGQ1ZTg+XSA/IHNjaGVkX2Nsb2NrX2NwdSsweGIxLzB4ZDAKWyAgICAw
LjU1MjE4N10gIFs8ZDFlNTk4YjI+XSBfX2xvY2tfYWNxdWlyZSsweDM1MC8weGFhNQpbICAg
IDAuNTUyMTg3XSAgWzxkMWU1YTc1Nz5dIGxvY2tfYWNxdWlyZSsweDc3LzB4OTIKWyAgICAw
LjU1MjE4N10gIFs8ZDFlOGU2YTg+XSA/IGFkanVzdF9tYW5hZ2VkX3BhZ2VfY291bnQrMHgx
My8weDRhClsgICAgMC41NTIxODddICBbPGQyMjg2NzhjPl0gX3Jhd19zcGluX2xvY2srMHgz
Yy8weDY5ClsgICAgMC41NTIxODddICBbPGQxZThlNmE4Pl0gPyBhZGp1c3RfbWFuYWdlZF9w
YWdlX2NvdW50KzB4MTMvMHg0YQpbICAgIDAuNTUyMTg3XSAgWzxkMWU4ZTZhOD5dIGFkanVz
dF9tYW5hZ2VkX3BhZ2VfY291bnQrMHgxMy8weDRhClsgICAgMC41NTIxODddICBbPGQxZTkx
YWUyPl0gZnJlZV9yZXNlcnZlZF9hcmVhKzB4NmIvMHhkYwpbICAgIDAuNTUyMTg3XSAgWzxk
MWUyNzdmMT5dID8gc2V0X21lbW9yeV9ydysweDQ4LzB4NGEKWyAgICAwLjU1MjE4N10gIFs8
ZDFlMjRjNDA+XSBmcmVlX2luaXRfcGFnZXMrMHg1Yi8weDdlClsgICAgMC41NTIxODddICBb
PGQyNWVlY2U2Pl0gPyBtYXliZV9saW5rLnBhcnQuMisweGU0LzB4ZTQKWyAgICAwLjU1MjE4
N10gIFs8ZDI1ZWVjZTY+XSA/IG1heWJlX2xpbmsucGFydC4yKzB4ZTQvMHhlNApbICAgIDAu
NTUyMTg3XSAgWzxkMjVmYjg2Yz5dIGZyZWVfaW5pdHJkX21lbSsweDI2LzB4MmEKWyAgICAw
LjU1MjE4N10gIFs8ZDI1ZWVkYmQ+XSBwb3B1bGF0ZV9yb290ZnMrMHhkNy8weGY5ClsgICAg
MC41NTIxODddICBbPGQyNWVlY2U2Pl0gPyBtYXliZV9saW5rLnBhcnQuMisweGU0LzB4ZTQK
WyAgICAwLjU1MjE4N10gIFs8ZDFlMDA0MjY+XSBkb19vbmVfaW5pdGNhbGwrMHg3Zi8weDFi
OQpbICAgIDAuNTUyMTg3XSAgWzxkMjVlZWNlNj5dID8gbWF5YmVfbGluay5wYXJ0LjIrMHhl
NC8weGU0ClsgICAgMC41NTIxODddICBbPGQxZTU5MjE4Pl0gPyB0cmFjZV9oYXJkaXJxc19v
bl9jYWxsZXIrMHhlYi8weDFhZgpbICAgIDAuNTUyMTg3XSAgWzxkMWU0MzFmYj5dID8gcGFy
YW1lcSsweDEzLzB4NWUKWyAgICAwLjU1MjE4N10gIFs8ZDI1ZWQ1OWI+XSA/IHJlcGFpcl9l
bnZfc3RyaW5nKzB4MTIvMHg1MQpbICAgIDAuNTUyMTg3XSAgWzxkMWU0MzQyZT5dID8gcGFy
c2VfYXJncysweDFlOC8weDMxOApbICAgIDAuNTUyMTg3XSAgWzxkMWUzZDk3YT5dID8gX191
c2VybW9kZWhlbHBlcl9zZXRfZGlzYWJsZV9kZXB0aCsweDNlLzB4NDQKWyAgICAwLjU1MjE4
N10gIFs8ZDI1ZWRjZTc+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweGRlLzB4MTc4ClsgICAg
MC41NTIxODddICBbPGQyNWVkNTg5Pl0gPyBpbml0Y2FsbF9ibGFja2xpc3QrMHg4MS8weDgx
ClsgICAgMC41NTIxODddICBbPGQyMjdhZDMwPl0ga2VybmVsX2luaXQrMHhiLzB4YzcKWyAg
ICAwLjU1MjE4N10gIFs8ZDFlNGJhZWU+XSA/IHNjaGVkdWxlX3RhaWwrMHhjLzB4M2EKWyAg
ICAwLjU1MjE4N10gIFs8ZDIyODc1NDA+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MjAv
MHgzMApbICAgIDAuNTUyMTg3XSAgWzxkMjI3YWQyNT5dID8gcmVzdF9pbml0KzB4YjUvMHhi
NQpbICAgIDAuNTUyMTg3XSBDb2RlOiA4OSA0ZCBjNCAzOSBjNyA3NCA0MSA4YiA0ZCBjOCAz
MyA0OCAwYyA4YiA1MCAwOCAzMSBkYSAwOSBkMSAwZiA4NCA1OSAwMyAwMCAwMCA4YiA1NSBj
NCA4OSA3NSBiOCA4YiA0NSBjOCA4OSA0NSBjNCBlYiAxMyA4YiA0ZCBjNCA8MzM+IDQ4IDBj
IDhiIDcwIDA4IDMxIGRlIDA5IGYxIDBmIDg0IDM4IDAzIDAwIDAwIDhiIDQyIDA0IDhkIDUw
ClsgICAgMC41NTIxODddIEVJUDogWzxkMWU1NzkzMT5dIHZhbGlkYXRlX2NoYWluLmlzcmEu
MzcrMHhjNS8weDEwZTUgU1M6RVNQIDAwNjg6ZDA0NGRkNzQKWyAgICAwLjU1MjE4N10gQ1Iy
OiAwMDAwMDAwMDAwMDAwMDBjClsgICAgMC41NTIxODddIC0tLVsgZW5kIHRyYWNlIGQzZGMx
OGU2ZTBkZjc3MTMgXS0tLQpbICAgIDAuNTUyMTg3XSBub3RlOiBzd2FwcGVyWzFdIGV4aXRl
ZCB3aXRoIHByZWVtcHRfY291bnQgMQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcy
NTExNTMvN2Q4NDMzMWYwOGE1NzQ2Y2VmZDEyNDMzNzY4NjI0NWIwMGM4MjViNC9kbWVzZy1x
dWFudGFsLWl2YjQyLTY6MjAxNDA3MjUxMzMwMTI6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1
MTE1Mzo6CjkyOjE6MSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0w
Ny0yNSAxMzoyNjoxOCBSRVBFQVQgQ09VTlQ6IDMwMCAgIyAvYy9ib290LWJpc2VjdC9saW51
eC05L29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCkJpc2VjdGluZzogMTM5IHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpbY2I2YjgwODliOGZm
OWU1YjhiYTg4YTE0NTg4NjgyOTE0YmZmZmZkZl0gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJy
YW5jaCAnbXZlYnUvZm9yLW5leHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC05L29iai1iaXNlY3QK
bHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pYjEt
MDcyNTExNTMvbmV4dDptYXN0ZXI6Y2I2YjgwODliOGZmOWU1YjhiYTg4YTE0NTg4NjgyOTE0
YmZmZmZkZjpiaXNlY3QtbGludXgtOQoKMjAxNC0wNy0yNS0xMzoyNjoyMSBjYjZiODA4OWI4
ZmY5ZTViOGJhODhhMTQ1ODg2ODI5MTRiZmZmZmRmIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQg
dGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjEt
MDcyNTExNTMtY2I2YjgwODliOGZmOWU1YjhiYTg4YTE0NTg4NjgyOTE0YmZmZmZkZgpDaGVj
ayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My9j
YjZiODA4OWI4ZmY5ZTViOGJhODhhMTQ1ODg2ODI5MTRiZmZmZmRmCndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWct
aWIxLTA3MjUxMTUzLWNiNmI4MDg5YjhmZjllNWI4YmE4OGExNDU4ODY4MjkxNGJmZmZmZGYK
a2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvY2I2YjgwODli
OGZmOWU1YjhiYTg4YTE0NTg4NjgyOTE0YmZmZmZkZi92bWxpbnV6LTMuMTYuMC1yYzYtMDEw
MTQtZ2NiNmI4MDgKCjIwMTQtMDctMjUtMTM6Mjg6MjYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
CTkgVEVTVCBGQUlMVVJFClsgICAgMC42NzMxNzFdIFBDSTogQ0xTIDAgYnl0ZXMsIGRlZmF1
bHQgNjQKWyAgICAwLjY3NDY0Ml0gVW5wYWNraW5nIGluaXRyYW1mcy4uLgpbICAgIDAuNjc1
NzM2XSBJbml0cmFtZnMgdW5wYWNraW5nIGZhaWxlZDoganVuayBpbiBjb21wcmVzc2VkIGFy
Y2hpdmUKWyAgICAwLjY3OTM0MV0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxM
IHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQgMDAwMDAwMGMKWyAgICAwLjY4MTI0Ml0gSVA6IFs8
ZDFlNTc5MzE+XSB2YWxpZGF0ZV9jaGFpbi5pc3JhLjM3KzB4YzUvMHgxMGU1ClsgICAgMC42
ODEyOTNdICpwZHB0ID0gMDAwMDAwMDAwMDAwMDAwMCAqcGRlID0gZjAwMGZmNTNmMDAwZmY1
MyAKWyAgICAwLjY4MTI5M10gT29wczogMDAwMCBbIzFdIFBSRUVNUFQgClsgICAgMC42ODEy
OTNdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDAuNjgxMjkzXSBDUFU6IDAgUElEOiAxIENv
bW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xNi4wLXJjNi0wMTAxNC1nY2I2YjgwOCAjMgpb
ICAgIDAuNjgxMjkzXSBIYXJkd2FyZSBuYW1lOiBRRU1VIFN0YW5kYXJkIFBDIChpNDQwRlgg
KyBQSUlYLCAxOTk2KSwgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMC42ODEyOTNdIHRh
c2s6IGQwNDRhMDEwIHRpOiBkMDQ0YzAwMCB0YXNrLnRpOiBkMDQ0YzAwMApbICAgIDAuNjgx
MjkzXSBFSVA6IDAwNjA6WzxkMWU1NzkzMT5dIEVGTEFHUzogMDAwMTAwODYgQ1BVOiAwClsg
ICAgMC42ODEyOTNdIEVJUCBpcyBhdCB2YWxpZGF0ZV9jaGFpbi5pc3JhLjM3KzB4YzUvMHgx
MGU1ClsgICAgMC42ODEyOTNdIEVBWDogMDAwMDAwMDAgRUJYOiAwMDAwMDA4NCBFQ1g6IDAw
MDAwMDAwIEVEWDogZmZmZmZmZmMKWyAgICAwLjY4MTI5M10gRVNJOiBkMDQ0YTRmOCBFREk6
IGQyYTc0MzMwIEVCUDogZDA0NGRkZDggRVNQOiBkMDQ0ZGQ3NApbICAgIDAuNjgxMjkzXSAg
RFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwMDAgR1M6IDAwZTAgU1M6IDAwNjgKWyAgICAwLjY4
MTI5M10gQ1IwOiA4MDA1MDAzYiBDUjI6IDAwMDAwMDBjIENSMzogMTI2NWIwMDAgQ1I0OiAw
MDAwMDZiMApbICAgIDAuNjgxMjkzXSBTdGFjazoKWyAgICAwLjY4MTI5M10gIDAwMDAwMDg0
IGQwNDRkZDgwIGQxZTIzZWZlIGQwNDRkZDg4IGQxZTA3ZDM1IGQwNDRkZGI0IGQyYWEwZTgw
IGQwNDRhNGY4ClsgICAgMC42ODEyOTNdICAwMDAwMDAwMSBkMDQ0YTAxMCAwMDAwMDAwMCAw
MDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCBkMDQ0YTAxMCAwMDAwMDA4NApbICAgIDAuNjgx
MjkzXSAgZDA0NGRkZDAgZDFlNGQ1ZTggMjg3ZGEzZDggMDAwMDAwMDAgMDAwMDAwMDAgZDA0
NGEwMTAgMDAwMDAwODQgZDA0NGEwMTAKWyAgICAwLjY4MTI5M10gQ2FsbCBUcmFjZToKWyAg
ICAwLjY4MTI5M10gIFs8ZDFlMjNlZmU+XSA/IGt2bV9jbG9ja19yZWFkKzB4MTMvMHgyNApb
ICAgIDAuNjgxMjkzXSAgWzxkMWUwN2QzNT5dID8gc2NoZWRfY2xvY2srMHg4LzB4YgpbICAg
IDAuNjgxMjkzXSAgWzxkMWU0ZDVlOD5dID8gc2NoZWRfY2xvY2tfY3B1KzB4YjEvMHhkMApb
ICAgIDAuNjgxMjkzXSAgWzxkMWU1OThiMj5dIF9fbG9ja19hY3F1aXJlKzB4MzUwLzB4YWE1
ClsgICAgMC42ODEyOTNdICBbPGQxZTVhNzU3Pl0gbG9ja19hY3F1aXJlKzB4NzcvMHg5Mgpb
ICAgIDAuNjgxMjkzXSAgWzxkMWU4ZTZhOD5dID8gYWRqdXN0X21hbmFnZWRfcGFnZV9jb3Vu
dCsweDEzLzB4NGEKWyAgICAwLjY4MTI5M10gIFs8ZDIyODY3OGM+XSBfcmF3X3NwaW5fbG9j
aysweDNjLzB4NjkKWyAgICAwLjY4MTI5M10gIFs8ZDFlOGU2YTg+XSA/IGFkanVzdF9tYW5h
Z2VkX3BhZ2VfY291bnQrMHgxMy8weDRhClsgICAgMC42ODEyOTNdICBbPGQxZThlNmE4Pl0g
YWRqdXN0X21hbmFnZWRfcGFnZV9jb3VudCsweDEzLzB4NGEKWyAgICAwLjY4MTI5M10gIFs8
ZDFlOTFhZTI+XSBmcmVlX3Jlc2VydmVkX2FyZWErMHg2Yi8weGRjClsgICAgMC42ODEyOTNd
ICBbPGQxZTI3N2YxPl0gPyBzZXRfbWVtb3J5X3J3KzB4NDgvMHg0YQpbICAgIDAuNjgxMjkz
XSAgWzxkMWUyNGM0MD5dIGZyZWVfaW5pdF9wYWdlcysweDViLzB4N2UKWyAgICAwLjY4MTI5
M10gIFs8ZDI1ZWVjZTY+XSA/IG1heWJlX2xpbmsucGFydC4yKzB4ZTQvMHhlNApbICAgIDAu
NjgxMjkzXSAgWzxkMjVlZWNlNj5dID8gbWF5YmVfbGluay5wYXJ0LjIrMHhlNC8weGU0Clsg
ICAgMC42ODEyOTNdICBbPGQyNWZiODZjPl0gZnJlZV9pbml0cmRfbWVtKzB4MjYvMHgyYQpb
ICAgIDAuNjgxMjkzXSAgWzxkMjVlZWRiZD5dIHBvcHVsYXRlX3Jvb3RmcysweGQ3LzB4ZjkK
WyAgICAwLjY4MTI5M10gIFs8ZDI1ZWVjZTY+XSA/IG1heWJlX2xpbmsucGFydC4yKzB4ZTQv
MHhlNApbICAgIDAuNjgxMjkzXSAgWzxkMWUwMDQyNj5dIGRvX29uZV9pbml0Y2FsbCsweDdm
LzB4MWI5ClsgICAgMC42ODEyOTNdICBbPGQyNWVlY2U2Pl0gPyBtYXliZV9saW5rLnBhcnQu
MisweGU0LzB4ZTQKWyAgICAwLjY4MTI5M10gIFs8ZDFlNTkyMTg+XSA/IHRyYWNlX2hhcmRp
cnFzX29uX2NhbGxlcisweGViLzB4MWFmClsgICAgMC42ODEyOTNdICBbPGQxZTQzMWZiPl0g
PyBwYXJhbWVxKzB4MTMvMHg1ZQpbICAgIDAuNjgxMjkzXSAgWzxkMjVlZDU5Yj5dID8gcmVw
YWlyX2Vudl9zdHJpbmcrMHgxMi8weDUxClsgICAgMC42ODEyOTNdICBbPGQxZTQzNDJlPl0g
PyBwYXJzZV9hcmdzKzB4MWU4LzB4MzE4ClsgICAgMC42ODEyOTNdICBbPGQxZTNkOTdhPl0g
PyBfX3VzZXJtb2RlaGVscGVyX3NldF9kaXNhYmxlX2RlcHRoKzB4M2UvMHg0NApbICAgIDAu
NjgxMjkzXSAgWzxkMjVlZGNlNz5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4ZGUvMHgxNzgK
WyAgICAwLjY4MTI5M10gIFs8ZDI1ZWQ1ODk+XSA/IGluaXRjYWxsX2JsYWNrbGlzdCsweDgx
LzB4ODEKWyAgICAwLjY4MTI5M10gIFs8ZDIyN2FkMzA+XSBrZXJuZWxfaW5pdCsweGIvMHhj
NwpbICAgIDAuNjgxMjkzXSAgWzxkMWU0YmFlZT5dID8gc2NoZWR1bGVfdGFpbCsweGMvMHgz
YQpbICAgIDAuNjgxMjkzXSAgWzxkMjI4NzU0MD5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQr
MHgyMC8weDMwClsgICAgMC42ODEyOTNdICBbPGQyMjdhZDI1Pl0gPyByZXN0X2luaXQrMHhi
NS8weGI1ClsgICAgMC42ODEyOTNdIENvZGU6IDg5IDRkIGM0IDM5IGM3IDc0IDQxIDhiIDRk
IGM4IDMzIDQ4IDBjIDhiIDUwIDA4IDMxIGRhIDA5IGQxIDBmIDg0IDU5IDAzIDAwIDAwIDhi
IDU1IGM0IDg5IDc1IGI4IDhiIDQ1IGM4IDg5IDQ1IGM0IGViIDEzIDhiIDRkIGM0IDwzMz4g
NDggMGMgOGIgNzAgMDggMzEgZGUgMDkgZjEgMGYgODQgMzggMDMgMDAgMDAgOGIgNDIgMDQg
OGQgNTAKWyAgICAwLjY4MTI5M10gRUlQOiBbPGQxZTU3OTMxPl0gdmFsaWRhdGVfY2hhaW4u
aXNyYS4zNysweGM1LzB4MTBlNSBTUzpFU1AgMDA2ODpkMDQ0ZGQ3NApbICAgIDAuNjgxMjkz
XSBDUjI6IDAwMDAwMDAwMDAwMDAwMGMKWyAgICAwLjY4MTI5M10gLS0tWyBlbmQgdHJhY2Ug
NzYyYzcyNjE3MzE1NjZhMCBdLS0tClsgICAgMC42ODEyOTNdIG5vdGU6IHN3YXBwZXJbMV0g
ZXhpdGVkIHdpdGggcHJlZW1wdF9jb3VudCAxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWli
MS0wNzI1MTE1My9jYjZiODA4OWI4ZmY5ZTViOGJhODhhMTQ1ODg2ODI5MTRiZmZmZmRmL2Rt
ZXNnLXF1YW50YWwtaXZiNDItOTc6MjAxNDA3MjUxMzMyMDA6aTM4Ni1yYW5kY29uZmlnLWli
MS0wNzI1MTE1Mzo6Cjk6MToxIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rp
bmc6IDQwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA2IHN0
ZXBzKQpbOTkwZDAzODU5YTJlMTBiMmFhMTEyZGU5N2NkMmE0M2M3MDE0YzkyMl0gTWVyZ2Ug
cmVtb3RlLXRyYWNraW5nIGJyYW5jaCAnZXA5M3h4L2VwOTN4eC1mb3ItbmV4dCcKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3Qt
YmlzZWN0L2xpbnV4LTkvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My9uZXh0Om1hc3Rlcjo5OTBkMDM4
NTlhMmUxMGIyYWExMTJkZTk3Y2QyYTQzYzcwMTRjOTIyOmJpc2VjdC1saW51eC05CgoyMDE0
LTA3LTI1LTEzOjI4OjU5IDk5MGQwMzg1OWEyZTEwYjJhYTExMmRlOTdjZDJhNDNjNzAxNGM5
MjIgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQt
cXVldWUvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My05OTBkMDM4NTlhMmUxMGIyYWEx
MTJkZTk3Y2QyYTQzYzcwMTRjOTIyCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctaWIxLTA3MjUxMTUzLzk5MGQwMzg1OWEyZTEwYjJhYTExMmRlOTdjZDJh
NDNjNzAxNGM5MjIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMtOTkwZDAzODU5YTJlMTBi
MmFhMTEyZGU5N2NkMmE0M2M3MDE0YzkyMgprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWliMS0wNzI1MTE1My85OTBkMDM4NTlhMmUxMGIyYWExMTJkZTk3Y2QyYTQzYzcwMTRj
OTIyL3ZtbGludXotMy4xNi4wLXJjNi0wMDk4OS1nOTkwZDAzOAoKMjAxNC0wNy0yNS0xMzoz
Mjo1OSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTEyCTI5CTQ2CTY2CTgzCTk0CTExMSBURVNU
IEZBSUxVUkUKWyAgICAwLjkyNzc5NF0gUENJOiBDTFMgMCBieXRlcywgZGVmYXVsdCA2NApb
ICAgIDAuOTMwNzg4XSBVbnBhY2tpbmcgaW5pdHJhbWZzLi4uClsgICAgMC45NTAwNzVdIElu
aXRyYW1mcyB1bnBhY2tpbmcgZmFpbGVkOiBqdW5rIGluIGNvbXByZXNzZWQgYXJjaGl2ZQpb
ICAgIDAuOTUyMjk5XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRl
ciBkZXJlZmVyZW5jZSBhdCAwMDAwMDAwYwpbICAgIDAuOTUzNzE2XSBJUDogWzxkMWM1Nzkz
MT5dIHZhbGlkYXRlX2NoYWluLmlzcmEuMzcrMHhjNS8weDEwZTUKWyAgICAwLjk1MzcxNl0g
KnBkcHQgPSAwMDAwMDAwMDAwMDAwMDAwICpwZGUgPSBmMDAwZmY1M2YwMDBmZjUzIApbICAg
IDAuOTUzNzE2XSBPb3BzOiAwMDAwIFsjMV0gUFJFRU1QVCAKWyAgICAwLjk1MzcxNl0gTW9k
dWxlcyBsaW5rZWQgaW46ClsgICAgMC45NTM3MTZdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dh
cHBlciBOb3QgdGFpbnRlZCAzLjE2LjAtcmM2LTAwOTg5LWc5OTBkMDM4ICMzClsgICAgMC45
NTM3MTZdIEhhcmR3YXJlIG5hbWU6IFFFTVUgU3RhbmRhcmQgUEMgKGk0NDBGWCArIFBJSVgs
IDE5OTYpLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAwLjk1MzcxNl0gdGFzazogZDA0
NGEwMTAgdGk6IGQwNDRjMDAwIHRhc2sudGk6IGQwNDRjMDAwClsgICAgMC45NTM3MTZdIEVJ
UDogMDA2MDpbPGQxYzU3OTMxPl0gRUZMQUdTOiAwMDAxMDA4NiBDUFU6IDAKWyAgICAwLjk1
MzcxNl0gRUlQIGlzIGF0IHZhbGlkYXRlX2NoYWluLmlzcmEuMzcrMHhjNS8weDEwZTUKWyAg
ICAwLjk1MzcxNl0gRUFYOiAwMDAwMDAwMCBFQlg6IDAwMDAwMDg0IEVDWDogMDAwMDAwMDAg
RURYOiBmZmZmZmZmYwpbICAgIDAuOTUzNzE2XSBFU0k6IGQwNDRhNGY4IEVESTogZDI4NzQz
MzAgRUJQOiBkMDQ0ZGRkOCBFU1A6IGQwNDRkZDc0ClsgICAgMC45NTM3MTZdICBEUzogMDA3
YiBFUzogMDA3YiBGUzogMDAwMCBHUzogMDBlMCBTUzogMDA2OApbICAgIDAuOTUzNzE2XSBD
UjA6IDgwMDUwMDNiIENSMjogMDAwMDAwMGMgQ1IzOiAxMjQ1YjAwMCBDUjQ6IDAwMDAwNmIw
ClsgICAgMC45NTM3MTZdIFN0YWNrOgpbICAgIDAuOTUzNzE2XSAgMDAwMDAwODQgZDA0NGRk
ODAgZDFjMjNlZmUgZDA0NGRkODggZDFjMDdkMzUgZDA0NGRkYjQgZDI4YTBlODAgZDA0NGE0
ZjgKWyAgICAwLjk1MzcxNl0gIDAwMDAwMDAxIGQwNDRhMDEwIDAwMDAwMDAwIDAwMDAwMDAw
IDAwMDAwMDAwIDAwMDAwMDAwIGQwNDRhMDEwIDAwMDAwMDg0ClsgICAgMC45NTM3MTZdICBk
MDQ0ZGRkMCBkMWM0ZDVlOCAzOGMyYjk0MSAwMDAwMDAwMCAwMDAwMDAwMCBkMDQ0YTAxMCAw
MDAwMDA4NCBkMDQ0YTAxMApbICAgIDAuOTUzNzE2XSBDYWxsIFRyYWNlOgpbICAgIDAuOTUz
NzE2XSAgWzxkMWMyM2VmZT5dID8ga3ZtX2Nsb2NrX3JlYWQrMHgxMy8weDI0ClsgICAgMC45
NTM3MTZdICBbPGQxYzA3ZDM1Pl0gPyBzY2hlZF9jbG9jaysweDgvMHhiClsgICAgMC45NTM3
MTZdICBbPGQxYzRkNWU4Pl0gPyBzY2hlZF9jbG9ja19jcHUrMHhiMS8weGQwClsgICAgMC45
NTM3MTZdICBbPGQxYzU5OGIyPl0gX19sb2NrX2FjcXVpcmUrMHgzNTAvMHhhYTUKWyAgICAw
Ljk1MzcxNl0gIFs8ZDFjNWE3NTc+XSBsb2NrX2FjcXVpcmUrMHg3Ny8weDkyClsgICAgMC45
NTM3MTZdICBbPGQxYzhlNmE4Pl0gPyBhZGp1c3RfbWFuYWdlZF9wYWdlX2NvdW50KzB4MTMv
MHg0YQpbICAgIDAuOTUzNzE2XSAgWzxkMjA4Njc4Yz5dIF9yYXdfc3Bpbl9sb2NrKzB4M2Mv
MHg2OQpbICAgIDAuOTUzNzE2XSAgWzxkMWM4ZTZhOD5dID8gYWRqdXN0X21hbmFnZWRfcGFn
ZV9jb3VudCsweDEzLzB4NGEKWyAgICAwLjk1MzcxNl0gIFs8ZDFjOGU2YTg+XSBhZGp1c3Rf
bWFuYWdlZF9wYWdlX2NvdW50KzB4MTMvMHg0YQpbICAgIDAuOTUzNzE2XSAgWzxkMWM5MWFl
Mj5dIGZyZWVfcmVzZXJ2ZWRfYXJlYSsweDZiLzB4ZGMKWyAgICAwLjk1MzcxNl0gIFs8ZDFj
Mjc3ZjE+XSA/IHNldF9tZW1vcnlfcncrMHg0OC8weDRhClsgICAgMC45NTM3MTZdICBbPGQx
YzI0YzQwPl0gZnJlZV9pbml0X3BhZ2VzKzB4NWIvMHg3ZQpbICAgIDAuOTUzNzE2XSAgWzxk
MjNlZWNlNj5dID8gbWF5YmVfbGluay5wYXJ0LjIrMHhlNC8weGU0ClsgICAgMC45NTM3MTZd
ICBbPGQyM2VlY2U2Pl0gPyBtYXliZV9saW5rLnBhcnQuMisweGU0LzB4ZTQKWyAgICAwLjk1
MzcxNl0gIFs8ZDIzZmI4NmM+XSBmcmVlX2luaXRyZF9tZW0rMHgyNi8weDJhClsgICAgMC45
NTM3MTZdICBbPGQyM2VlZGJkPl0gcG9wdWxhdGVfcm9vdGZzKzB4ZDcvMHhmOQpbICAgIDAu
OTUzNzE2XSAgWzxkMjNlZWNlNj5dID8gbWF5YmVfbGluay5wYXJ0LjIrMHhlNC8weGU0Clsg
ICAgMC45NTM3MTZdICBbPGQxYzAwNDI2Pl0gZG9fb25lX2luaXRjYWxsKzB4N2YvMHgxYjkK
WyAgICAwLjk1MzcxNl0gIFs8ZDIzZWVjZTY+XSA/IG1heWJlX2xpbmsucGFydC4yKzB4ZTQv
MHhlNApbICAgIDAuOTUzNzE2XSAgWzxkMWM1OTIxOD5dID8gdHJhY2VfaGFyZGlycXNfb25f
Y2FsbGVyKzB4ZWIvMHgxYWYKWyAgICAwLjk1MzcxNl0gIFs8ZDFjNDMxZmI+XSA/IHBhcmFt
ZXErMHgxMy8weDVlClsgICAgMC45NTM3MTZdICBbPGQyM2VkNTliPl0gPyByZXBhaXJfZW52
X3N0cmluZysweDEyLzB4NTEKWyAgICAwLjk1MzcxNl0gIFs8ZDFjNDM0MmU+XSA/IHBhcnNl
X2FyZ3MrMHgxZTgvMHgzMTgKWyAgICAwLjk1MzcxNl0gIFs8ZDFjM2Q5N2E+XSA/IF9fdXNl
cm1vZGVoZWxwZXJfc2V0X2Rpc2FibGVfZGVwdGgrMHgzZS8weDQ0ClsgICAgMC45NTM3MTZd
ICBbPGQyM2VkY2U3Pl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHhkZS8weDE3OApbICAgIDAu
OTUzNzE2XSAgWzxkMjNlZDU4OT5dID8gaW5pdGNhbGxfYmxhY2tsaXN0KzB4ODEvMHg4MQpb
ICAgIDAuOTUzNzE2XSAgWzxkMjA3YWQzMD5dIGtlcm5lbF9pbml0KzB4Yi8weGM3ClsgICAg
MC45NTM3MTZdICBbPGQxYzRiYWVlPl0gPyBzY2hlZHVsZV90YWlsKzB4Yy8weDNhClsgICAg
MC45NTM3MTZdICBbPGQyMDg3NTQwPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDIwLzB4
MzAKWyAgICAwLjk1MzcxNl0gIFs8ZDIwN2FkMjU+XSA/IHJlc3RfaW5pdCsweGI1LzB4YjUK
WyAgICAwLjk1MzcxNl0gQ29kZTogODkgNGQgYzQgMzkgYzcgNzQgNDEgOGIgNGQgYzggMzMg
NDggMGMgOGIgNTAgMDggMzEgZGEgMDkgZDEgMGYgODQgNTkgMDMgMDAgMDAgOGIgNTUgYzQg
ODkgNzUgYjggOGIgNDUgYzggODkgNDUgYzQgZWIgMTMgOGIgNGQgYzQgPDMzPiA0OCAwYyA4
YiA3MCAwOCAzMSBkZSAwOSBmMSAwZiA4NCAzOCAwMyAwMCAwMCA4YiA0MiAwNCA4ZCA1MApb
ICAgIDAuOTUzNzE2XSBFSVA6IFs8ZDFjNTc5MzE+XSB2YWxpZGF0ZV9jaGFpbi5pc3JhLjM3
KzB4YzUvMHgxMGU1IFNTOkVTUCAwMDY4OmQwNDRkZDc0ClsgICAgMC45NTM3MTZdIENSMjog
MDAwMDAwMDAwMDAwMDAwYwpbICAgIDAuOTUzNzE2XSAtLS1bIGVuZCB0cmFjZSAyYTA2MmUy
ZWNmYjhlNTg4IF0tLS0KWyAgICAwLjk1MzcxNl0gbm90ZTogc3dhcHBlclsxXSBleGl0ZWQg
d2l0aCBwcmVlbXB0X2NvdW50IDEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUx
MTUzLzk5MGQwMzg1OWEyZTEwYjJhYTExMmRlOTdjZDJhNDNjNzAxNGM5MjIvZG1lc2ctcXVh
bnRhbC1pdmI0Mi03NToyMDE0MDcyNTEzNDA1MzppMzg2LXJhbmRjb25maWctaWIxLTA3MjUx
MTUzOjoKMTEwOjE6MiBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0w
Ny0yNSAxMzozNzowMCBSRVBFQVQgQ09VTlQ6IDMwMCAgIyAvYy9ib290LWJpc2VjdC9saW51
eC05L29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCmxpbmVhci1iaXNlY3Q6IGJhZCBicmFuY2gg
bWF5IGJlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ2VwOTN4eC9lcDkzeHgtZm9yLW5leHQn
CmxpbmVhci1iaXNlY3Q6IGhhbmRsZSBvdmVyIHRvIGdpdCBiaXNlY3QKbGluZWFyLWJpc2Vj
dDogZ2l0IGJpc2VjdCBzdGFydCA5OTBkMDM4NTlhMmUxMGIyYWExMTJkZTk3Y2QyYTQzYzcw
MTRjOTIyIDNmNTQxMjQ4N2MzNzhjODQzZDE3OWY4MzU2YjQwYmE2ZmYzNDE5MzAgLS0KUHJl
dmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgOTkwZDAzOC4uLiBNZXJnZSByZW1vdGUtdHJhY2tp
bmcgYnJhbmNoICdlcDkzeHgvZXA5M3h4LWZvci1uZXh0JwpIRUFEIGlzIG5vdyBhdCBiNGQz
MzE4Li4uIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ2NyeXB0by9tYXN0ZXInCkJp
c2VjdGluZzogNyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
MyBzdGVwcykKWzE2MTlhZjNlNzhiMzFkZTkwNTEwNzI1OTEwMGU4Y2JmYjNkN2FiZTBdIE1l
cmdlIGJyYW5jaCAnZXA5M3h4LWNsZWFudXAnIGludG8gZXA5M3h4LWZvci1uZXh0CmxpbmVh
ci1iaXNlY3Q6IGdpdCBiaXNlY3QgcnVuIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtOS9vYmotYmlzZWN0CnJ1bm5p
bmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290
LWJpc2VjdC9saW51eC05L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVl
dWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvbmV4dDptYXN0ZXI6MTYxOWFm
M2U3OGIzMWRlOTA1MTA3MjU5MTAwZThjYmZiM2Q3YWJlMDpiaXNlY3QtbGludXgtOQoKMjAx
NC0wNy0yNS0xMzozNzoxNSAxNjE5YWYzZTc4YjMxZGU5MDUxMDcyNTkxMDBlOGNiZmIzZDdh
YmUwIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMtMTYxOWFmM2U3OGIzMWRlOTA1
MTA3MjU5MTAwZThjYmZiM2Q3YWJlMApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My8xNjE5YWYzZTc4YjMxZGU5MDUxMDcyNTkxMDBl
OGNiZmIzZDdhYmUwCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9i
dWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzLTE2MTlhZjNlNzhiMzFk
ZTkwNTEwNzI1OTEwMGU4Y2JmYjNkN2FiZTAKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNv
bmZpZy1pYjEtMDcyNTExNTMvMTYxOWFmM2U3OGIzMWRlOTA1MTA3MjU5MTAwZThjYmZiM2Q3
YWJlMC92bWxpbnV6LTMuOS4wLXJjMS0wMDAwNy1nMTYxOWFmMwoKMjAxNC0wNy0yNS0xMzoz
OToxNSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTEyCTE1CTIyCTQwCTY0CTg1CTk2CTExOAkx
NjEJMTg0CTIwNwkyMzkJMjYxCTI4MwkyOTUJMzAwIFNVQ0NFU1MKCkJpc2VjdGluZzogMyBy
ZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMiBzdGVwcykKWzlj
NTliZTc4ZDFlZTRhNzE3Y2EyZjg1YjU0MzU2ZjhmZWQ3ZjQzOWNdIE1lcmdlIGJyYW5jaCAn
ZXA5M3h4LWRldmVsJyBpbnRvIGVwOTN4eC1mb3ItbmV4dApydW5uaW5nIC9jL2tlcm5lbC10
ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgt
OS9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJh
bmRjb25maWctaWIxLTA3MjUxMTUzL25leHQ6bWFzdGVyOjljNTliZTc4ZDFlZTRhNzE3Y2Ey
Zjg1YjU0MzU2ZjhmZWQ3ZjQzOWM6YmlzZWN0LWxpbnV4LTkKCjIwMTQtMDctMjUtMTM6NDk6
MjQgOWM1OWJlNzhkMWVlNGE3MTdjYTJmODViNTQzNTZmOGZlZDdmNDM5YyBjb21waWxpbmcK
UXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJh
bmRjb25maWctaWIxLTA3MjUxMTUzLTljNTliZTc4ZDFlZTRhNzE3Y2EyZjg1YjU0MzU2Zjhm
ZWQ3ZjQzOWMKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1p
YjEtMDcyNTExNTMvOWM1OWJlNzhkMWVlNGE3MTdjYTJmODViNTQzNTZmOGZlZDdmNDM5Ywp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4
Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My05YzU5YmU3OGQxZWU0YTcxN2NhMmY4NWI1NDM1
NmY4ZmVkN2Y0MzljCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUx
MTUzLzljNTliZTc4ZDFlZTRhNzE3Y2EyZjg1YjU0MzU2ZjhmZWQ3ZjQzOWMvdm1saW51ei0z
LjExLjAtcmMxLTAwMDExLWc5YzU5YmU3CgoyMDE0LTA3LTI1LTEzOjUxOjMzIGRldGVjdGlu
ZyBib290IHN0YXRlIC4uCTI3CTM4CTYwCTEzNgkxNDkJMjE2CTMwMCBTVUNDRVNTCgpCaXNl
Y3Rpbmc6IDIgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEg
c3RlcCkKWzY4NjhhODkxZDBiNDVlMjgzYjBhMjBlZjdmN2Y5NDBlYzY1NjQ3MmNdIE1lcmdl
IGJyYW5jaCAnZXA5M3h4LWZpeGVzJyBpbnRvIGVwOTN4eC1mb3ItbmV4dApydW5uaW5nIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNl
Y3QvbGludXgtOS9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2
bS9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzL25leHQ6bWFzdGVyOjY4NjhhODkxZDBi
NDVlMjgzYjBhMjBlZjdmN2Y5NDBlYzY1NjQ3MmM6YmlzZWN0LWxpbnV4LTkKCjIwMTQtMDct
MjUtMTM6NTY6MzAgNjg2OGE4OTFkMGI0NWUyODNiMGEyMGVmN2Y3Zjk0MGVjNjU2NDcyYyBj
b21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1
ZS9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzLTY4NjhhODkxZDBiNDVlMjgzYjBhMjBl
ZjdmN2Y5NDBlYzY1NjQ3MmMKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1pYjEtMDcyNTExNTMvNjg2OGE4OTFkMGI0NWUyODNiMGEyMGVmN2Y3Zjk0MGVj
NjU2NDcyYwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQt
cXVldWUvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My02ODY4YTg5MWQwYjQ1ZTI4M2Iw
YTIwZWY3ZjdmOTQwZWM2NTY0NzJjCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
aWIxLTA3MjUxMTUzLzY4NjhhODkxZDBiNDVlMjgzYjBhMjBlZjdmN2Y5NDBlYzY1NjQ3MmMv
dm1saW51ei0zLjExLjAtcmMxLTAwMDEzLWc2ODY4YTg5CgoyMDE0LTA3LTI1LTEzOjU4OjMw
IGRldGVjdGluZyBib290IHN0YXRlIAkxCTEyNgkzMDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAw
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0ZXApClti
ZmIwNzA5ZmQxN2IxMzQ5OGQ5OTU5MmJiZTEyYzkxMTMwZTM1YTU1XSBNZXJnZSBicmFuY2gg
J2VwOTN4eC1maXhlcycgaW50byBlcDkzeHgtZm9yLW5leHQKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4
LTkvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1y
YW5kY29uZmlnLWliMS0wNzI1MTE1My9uZXh0Om1hc3RlcjpiZmIwNzA5ZmQxN2IxMzQ5OGQ5
OTU5MmJiZTEyYzkxMTMwZTM1YTU1OmJpc2VjdC1saW51eC05CgoyMDE0LTA3LTI1LTE0OjAw
OjAyIGJmYjA3MDlmZDE3YjEzNDk4ZDk5NTkyYmJlMTJjOTExMzBlMzVhNTUgY29tcGlsaW5n
ClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1y
YW5kY29uZmlnLWliMS0wNzI1MTE1My1iZmIwNzA5ZmQxN2IxMzQ5OGQ5OTU5MmJiZTEyYzkx
MTMwZTM1YTU1CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
aWIxLTA3MjUxMTUzL2JmYjA3MDlmZDE3YjEzNDk4ZDk5NTkyYmJlMTJjOTExMzBlMzVhNTUK
d2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kz
ODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMtYmZiMDcwOWZkMTdiMTM0OThkOTk1OTJiYmUx
MmM5MTEzMGUzNWE1NQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUvbGtwLWhzeDAxLWNvbnN1bWVyL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcy
NTExNTMtYmZiMDcwOWZkMTdiMTM0OThkOTk1OTJiYmUxMmM5MTEzMGUzNWE1NQprZXJuZWw6
IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My9iZmIwNzA5ZmQxN2IxMzQ5
OGQ5OTU5MmJiZTEyYzkxMTMwZTM1YTU1L3ZtbGludXotMy4xMS4wLXJjMS0wMDAxNS1nYmZi
MDcwOQoKMjAxNC0wNy0yNS0xNDoxMTowMiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLgkxNTUJ
MjExCTI5NAkzMDAgU1VDQ0VTUwoKOTkwZDAzODU5YTJlMTBiMmFhMTEyZGU5N2NkMmE0M2M3
MDE0YzkyMiBpcyB0aGUgZmlyc3QgYmFkIGNvbW1pdApiaXNlY3QgcnVuIHN1Y2Nlc3MKUHJl
dmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgYmZiMDcwOS4uLiBNZXJnZSBicmFuY2ggJ2VwOTN4
eC1maXhlcycgaW50byBlcDkzeHgtZm9yLW5leHQKSEVBRCBpcyBub3cgYXQgM2Y1NDEyNC4u
LiBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdiZXJsaW4vYmVybGluL2Zvci1uZXh0
JwpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWli
MS0wNzI1MTE1My9uZXh0Om1hc3RlcjozZjU0MTI0ODdjMzc4Yzg0M2QxNzlmODM1NmI0MGJh
NmZmMzQxOTMwOmJpc2VjdC1saW51eC05CgoyMDE0LTA3LTI1LTE0OjE0OjA4IDNmNTQxMjQ4
N2MzNzhjODQzZDE3OWY4MzU2YjQwYmE2ZmYzNDE5MzAgcmV1c2UgL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctaWIxLTA3MjUxMTUzLzNmNTQxMjQ4N2MzNzhjODQzZDE3OWY4MzU2YjQwYmE2
ZmYzNDE5MzAvdm1saW51ei0zLjE2LjAtcmM2LTAwOTc0LWczZjU0MTI0CgoyMDE0LTA3LTI1
LTE0OjE0OjA5IGRldGVjdGluZyBib290IHN0YXRlIAkxLgk4MyBURVNUIEZBSUxVUkUKWyAg
ICAwLjY2NDgxOF0gUENJOiBDTFMgMCBieXRlcywgZGVmYXVsdCA2NApbICAgIDAuNjY2MTc2
XSBVbnBhY2tpbmcgaW5pdHJhbWZzLi4uClsgICAgMC42NjcxNzJdIEluaXRyYW1mcyB1bnBh
Y2tpbmcgZmFpbGVkOiBqdW5rIGluIGNvbXByZXNzZWQgYXJjaGl2ZQpbICAgIDAuNjcwNDc4
XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5j
ZSBhdCAwMDAwMDAwYwpbICAgIDAuNjcyMjc1XSBJUDogWzxkMWU1NzkzMT5dIHZhbGlkYXRl
X2NoYWluLmlzcmEuMzcrMHhjNS8weDEwZTUKWyAgICAwLjY3MjYxNl0gKnBkcHQgPSAwMDAw
MDAwMDAwMDAwMDAwICpwZGUgPSBmMDAwZmY1M2YwMDBmZjUzIApbICAgIDAuNjcyNjE2XSBP
b3BzOiAwMDAwIFsjMV0gUFJFRU1QVCAKWyAgICAwLjY3MjYxNl0gTW9kdWxlcyBsaW5rZWQg
aW46ClsgICAgMC42NzI2MTZdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBOb3QgdGFp
bnRlZCAzLjE2LjAtcmM2LTAwOTc0LWczZjU0MTI0ICMxClsgICAgMC42NzI2MTZdIEhhcmR3
YXJlIG5hbWU6IFFFTVUgU3RhbmRhcmQgUEMgKGk0NDBGWCArIFBJSVgsIDE5OTYpLCBCSU9T
IEJvY2hzIDAxLzAxLzIwMTEKWyAgICAwLjY3MjYxNl0gdGFzazogZDA0NGEwMTAgdGk6IGQw
NDRjMDAwIHRhc2sudGk6IGQwNDRjMDAwClsgICAgMC42NzI2MTZdIEVJUDogMDA2MDpbPGQx
ZTU3OTMxPl0gRUZMQUdTOiAwMDAxMDA4NiBDUFU6IDAKWyAgICAwLjY3MjYxNl0gRUlQIGlz
IGF0IHZhbGlkYXRlX2NoYWluLmlzcmEuMzcrMHhjNS8weDEwZTUKWyAgICAwLjY3MjYxNl0g
RUFYOiAwMDAwMDAwMCBFQlg6IDAwMDAwMDg0IEVDWDogMDAwMDAwMDAgRURYOiBmZmZmZmZm
YwpbICAgIDAuNjcyNjE2XSBFU0k6IGQwNDRhNGY4IEVESTogZDJhNzQzMzAgRUJQOiBkMDQ0
ZGRkOCBFU1A6IGQwNDRkZDc0ClsgICAgMC42NzI2MTZdICBEUzogMDA3YiBFUzogMDA3YiBG
UzogMDAwMCBHUzogMDBlMCBTUzogMDA2OApbICAgIDAuNjcyNjE2XSBDUjA6IDgwMDUwMDNi
IENSMjogMDAwMDAwMGMgQ1IzOiAxMjY1YjAwMCBDUjQ6IDAwMDAwNmIwClsgICAgMC42NzI2
MTZdIFN0YWNrOgpbICAgIDAuNjcyNjE2XSAgMDAwMDAwODQgZDA0NGRkODAgZDFlMjNlZmUg
ZDA0NGRkODggZDFlMDdkMzUgZDA0NGRkYjQgZDJhYTBlODAgZDA0NGE0ZjgKWyAgICAwLjY3
MjYxNl0gIDAwMDAwMDAxIGQwNDRhMDEwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAw
MDAwMDAwIGQwNDRhMDEwIDAwMDAwMDg0ClsgICAgMC42NzI2MTZdICBkMDQ0ZGRkMCBkMWU0
ZDVlOCAyN2Y2NzZhNiAwMDAwMDAwMCAwMDAwMDAwMCBkMDQ0YTAxMCAwMDAwMDA4NCBkMDQ0
YTAxMApbICAgIDAuNjcyNjE2XSBDYWxsIFRyYWNlOgpbICAgIDAuNjcyNjE2XSAgWzxkMWUy
M2VmZT5dID8ga3ZtX2Nsb2NrX3JlYWQrMHgxMy8weDI0ClsgICAgMC42NzI2MTZdICBbPGQx
ZTA3ZDM1Pl0gPyBzY2hlZF9jbG9jaysweDgvMHhiClsgICAgMC42NzI2MTZdICBbPGQxZTRk
NWU4Pl0gPyBzY2hlZF9jbG9ja19jcHUrMHhiMS8weGQwClsgICAgMC42NzI2MTZdICBbPGQx
ZTU5OGIyPl0gX19sb2NrX2FjcXVpcmUrMHgzNTAvMHhhYTUKWyAgICAwLjY3MjYxNl0gIFs8
ZDFlNWE3NTc+XSBsb2NrX2FjcXVpcmUrMHg3Ny8weDkyClsgICAgMC42NzI2MTZdICBbPGQx
ZThlNmE4Pl0gPyBhZGp1c3RfbWFuYWdlZF9wYWdlX2NvdW50KzB4MTMvMHg0YQpbICAgIDAu
NjcyNjE2XSAgWzxkMjI4Njc4Yz5dIF9yYXdfc3Bpbl9sb2NrKzB4M2MvMHg2OQpbICAgIDAu
NjcyNjE2XSAgWzxkMWU4ZTZhOD5dID8gYWRqdXN0X21hbmFnZWRfcGFnZV9jb3VudCsweDEz
LzB4NGEKWyAgICAwLjY3MjYxNl0gIFs8ZDFlOGU2YTg+XSBhZGp1c3RfbWFuYWdlZF9wYWdl
X2NvdW50KzB4MTMvMHg0YQpbICAgIDAuNjcyNjE2XSAgWzxkMWU5MWFlMj5dIGZyZWVfcmVz
ZXJ2ZWRfYXJlYSsweDZiLzB4ZGMKWyAgICAwLjY3MjYxNl0gIFs8ZDFlMjc3ZjE+XSA/IHNl
dF9tZW1vcnlfcncrMHg0OC8weDRhClsgICAgMC42NzI2MTZdICBbPGQxZTI0YzQwPl0gZnJl
ZV9pbml0X3BhZ2VzKzB4NWIvMHg3ZQpbICAgIDAuNjcyNjE2XSAgWzxkMjVlZWNlNj5dID8g
bWF5YmVfbGluay5wYXJ0LjIrMHhlNC8weGU0ClsgICAgMC42NzI2MTZdICBbPGQyNWVlY2U2
Pl0gPyBtYXliZV9saW5rLnBhcnQuMisweGU0LzB4ZTQKWyAgICAwLjY3MjYxNl0gIFs8ZDI1
ZmI4NmM+XSBmcmVlX2luaXRyZF9tZW0rMHgyNi8weDJhClsgICAgMC42NzI2MTZdICBbPGQy
NWVlZGJkPl0gcG9wdWxhdGVfcm9vdGZzKzB4ZDcvMHhmOQpbICAgIDAuNjcyNjE2XSAgWzxk
MjVlZWNlNj5dID8gbWF5YmVfbGluay5wYXJ0LjIrMHhlNC8weGU0ClsgICAgMC42NzI2MTZd
ICBbPGQxZTAwNDI2Pl0gZG9fb25lX2luaXRjYWxsKzB4N2YvMHgxYjkKWyAgICAwLjY3MjYx
Nl0gIFs8ZDI1ZWVjZTY+XSA/IG1heWJlX2xpbmsucGFydC4yKzB4ZTQvMHhlNApbICAgIDAu
NjcyNjE2XSAgWzxkMWU1OTIxOD5dID8gdHJhY2VfaGFyZGlycXNfb25fY2FsbGVyKzB4ZWIv
MHgxYWYKWyAgICAwLjY3MjYxNl0gIFs8ZDFlNDMxZmI+XSA/IHBhcmFtZXErMHgxMy8weDVl
ClsgICAgMC42NzI2MTZdICBbPGQyNWVkNTliPl0gPyByZXBhaXJfZW52X3N0cmluZysweDEy
LzB4NTEKWyAgICAwLjY3MjYxNl0gIFs8ZDFlNDM0MmU+XSA/IHBhcnNlX2FyZ3MrMHgxZTgv
MHgzMTgKWyAgICAwLjY3MjYxNl0gIFs8ZDFlM2Q5N2E+XSA/IF9fdXNlcm1vZGVoZWxwZXJf
c2V0X2Rpc2FibGVfZGVwdGgrMHgzZS8weDQ0ClsgICAgMC42NzI2MTZdICBbPGQyNWVkY2U3
Pl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHhkZS8weDE3OApbICAgIDAuNjcyNjE2XSAgWzxk
MjVlZDU4OT5dID8gaW5pdGNhbGxfYmxhY2tsaXN0KzB4ODEvMHg4MQpbICAgIDAuNjcyNjE2
XSAgWzxkMjI3YWQzMD5dIGtlcm5lbF9pbml0KzB4Yi8weGM3ClsgICAgMC42NzI2MTZdICBb
PGQxZTRiYWVlPl0gPyBzY2hlZHVsZV90YWlsKzB4Yy8weDNhClsgICAgMC42NzI2MTZdICBb
PGQyMjg3NTQwPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDIwLzB4MzAKWyAgICAwLjY3
MjYxNl0gIFs8ZDIyN2FkMjU+XSA/IHJlc3RfaW5pdCsweGI1LzB4YjUKWyAgICAwLjY3MjYx
Nl0gQ29kZTogODkgNGQgYzQgMzkgYzcgNzQgNDEgOGIgNGQgYzggMzMgNDggMGMgOGIgNTAg
MDggMzEgZGEgMDkgZDEgMGYgODQgNTkgMDMgMDAgMDAgOGIgNTUgYzQgODkgNzUgYjggOGIg
NDUgYzggODkgNDUgYzQgZWIgMTMgOGIgNGQgYzQgPDMzPiA0OCAwYyA4YiA3MCAwOCAzMSBk
ZSAwOSBmMSAwZiA4NCAzOCAwMyAwMCAwMCA4YiA0MiAwNCA4ZCA1MApbICAgIDAuNjcyNjE2
XSBFSVA6IFs8ZDFlNTc5MzE+XSB2YWxpZGF0ZV9jaGFpbi5pc3JhLjM3KzB4YzUvMHgxMGU1
IFNTOkVTUCAwMDY4OmQwNDRkZDc0ClsgICAgMC42NzI2MTZdIENSMjogMDAwMDAwMDAwMDAw
MDAwYwpbICAgIDAuNjcyNjE2XSAtLS1bIGVuZCB0cmFjZSA1ZWFmYWY1MWZkMTdmMzlmIF0t
LS0KWyAgICAwLjY3MjYxNl0gbm90ZTogc3dhcHBlclsxXSBleGl0ZWQgd2l0aCBwcmVlbXB0
X2NvdW50IDEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzLzNmNTQxMjQ4
N2MzNzhjODQzZDE3OWY4MzU2YjQwYmE2ZmYzNDE5MzAvZG1lc2ctcXVhbnRhbC1pdmI0Mi0x
MjE6MjAxNDA3MjUxNDE5MjM6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1Mzo6Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My8zZjU0MTI0ODdjMzc4Yzg0M2QxNzlm
ODM1NmI0MGJhNmZmMzQxOTMwL2RtZXNnLXF1YW50YWwtaXZiNDItNjI6MjAxNDA3MjUxNDE5
MjM6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWliMS0wNzI1MTE1My8zZjU0MTI0ODdjMzc4Yzg0M2QxNzlmODM1NmI0MGJhNmZmMzQx
OTMwL2RtZXNnLXF1YW50YWwtdnAtMzE6MjAxNDA3MjUxNDE2MDc6aTM4Ni1yYW5kY29uZmln
LWliMS0wNzI1MTE1MzozLjE2LjAtcmM2LTAwOTc0LWczZjU0MTI0OjEKMzk3OjM6OSBhbGxf
Z29vZDpiYWQ6YWxsX2JhZCBib290cwoKG1sxOzM1bTIwMTQtMDctMjUgMTQ6MTU6NTEgYmFk
IGJpc2VjdCwgcmV0cnkgd2l0aCBpbmNyZWFzZWQgcmVwZWF0IGNvdW50IDkwMBtbMG0KUHJl
dmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgM2Y1NDEyNC4uLiBNZXJnZSByZW1vdGUtdHJhY2tp
bmcgYnJhbmNoICdiZXJsaW4vYmVybGluL2Zvci1uZXh0JwpIRUFEIGlzIG5vdyBhdCAxYTU4
ZDk5Li4uIEFkZCBsaW51eC1uZXh0IHNwZWNpZmljIGZpbGVzIGZvciAyMDE0MDcyNApnaXQg
Y2hlY2tvdXQgOWEzYzQxNDVhZjMyMTI1YzVlZTM5YzAyNzI2NjJiNDczMDdhODMyMwpscyAt
YSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1
MTE1My9uZXh0Om1hc3Rlcjo5YTNjNDE0NWFmMzIxMjVjNWVlMzljMDI3MjY2MmI0NzMwN2E4
MzIzOmJpc2VjdC1saW51eC05CgoyMDE0LTA3LTI1LTE0OjE4OjAyIDlhM2M0MTQ1YWYzMjEy
NWM1ZWUzOWMwMjcyNjYyYjQ3MzA3YTgzMjMgcmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaWIxLTA3MjUxMTUzLzlhM2M0MTQ1YWYzMjEyNWM1ZWUzOWMwMjcyNjYyYjQ3MzA3YTgz
MjMvdm1saW51ei0zLjE2LjAtcmM2CgoyMDE0LTA3LTI1LTE0OjE4OjAyIGRldGVjdGluZyBi
b290IHN0YXRlIC4uIFRFU1QgRkFJTFVSRQpbICAgIDEuMjQ1NzAzXSBQQ0k6IENMUyAwIGJ5
dGVzLCBkZWZhdWx0IDY0ClsgICAgMS4yNDczMDBdIFVucGFja2luZyBpbml0cmFtZnMuLi4K
WyAgICAxLjI1MjYxMl0gSW5pdHJhbWZzIHVucGFja2luZyBmYWlsZWQ6IGp1bmsgaW4gY29t
cHJlc3NlZCBhcmNoaXZlClsgICAgMS4yNTUwMjJdIEJVRzogTUFYX0xPQ0tERVBfS0VZUyB0
b28gbG93IQpbICAgIDEuMjU2MDM5XSB0dXJuaW5nIG9mZiB0aGUgbG9ja2luZyBjb3JyZWN0
bmVzcyB2YWxpZGF0b3IuClsgICAgMS4yNTkwMTldIFBsZWFzZSBhdHRhY2ggdGhlIG91dHB1
dCBvZiAvcHJvYy9sb2NrX3N0YXQgdG8gdGhlIGJ1ZyByZXBvcnQKWyAgICAxLjI1OTAxOV0g
Q1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTYuMC1yYzYgIzEK
WyAgICAxLjI1OTAxOV0gSGFyZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQQyAoaTQ0MEZY
ICsgUElJWCwgMTk5NiksIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDEuMjU5MDE5XSAg
MDAwMDAwMDAgMDAwMDAwMDAgZDA0MGJlY2MgZDIyODEyYzkgZDA0MGJmMGMgZDFlNTlmZjIg
ZDFlMDdkMjUgZDA0MGJmMDQKWyAgICAxLjI1OTAxOV0gIGQxZTRkMzc4IDRhY2UxOTQ3IDAw
MDAwMDAwIDAwMDAwMDAwIGQyYTkyZmMwIGQyNjZhMDhhIDAwMDAwMDA3IGQwNDBiZjY0Clsg
ICAgMS4yNTkwMTldICAwMDAwMDAwMCBkMDQ0YTAxMCBkMDQwYmY2NCAwMDAwMDAwMCBkMDQw
YmYzYyBkMWU1YTc0NyAwMDAwMDAwMCAwMDAwMDAwMQpbICAgIDEuMjU5MDE5XSBDYWxsIFRy
YWNlOgpbICAgIDEuMjU5MDE5XSAgWzxkMjI4MTJjOT5dIGR1bXBfc3RhY2srMHgxNi8weDE4
ClsgICAgMS4yNTkwMTldICBbPGQxZTU5ZmYyPl0gX19sb2NrX2FjcXVpcmUrMHhhYTAvMHhh
YTUKWyAgICAxLjI1OTAxOV0gIFs8ZDFlMDdkMjU+XSA/IHNjaGVkX2Nsb2NrKzB4OC8weGIK
WyAgICAxLjI1OTAxOV0gIFs8ZDFlNGQzNzg+XSA/IHNjaGVkX2Nsb2NrX2xvY2FsLmNvbnN0
cHJvcC41KzB4MzkvMHgxMzEKWyAgICAxLjI1OTAxOV0gIFs8ZDFlNWE3NDc+XSBsb2NrX2Fj
cXVpcmUrMHg3Ny8weDkyClsgICAgMS4yNTkwMTldICBbPGQxZTM1OWRmPl0gPyBjYWxsX3Rp
bWVyX2ZuKzB4MzYvMHhkMgpbICAgIDEuMjU5MDE5XSAgWzxkMWUzNWEwOD5dIGNhbGxfdGlt
ZXJfZm4rMHg1Zi8weGQyClsgICAgMS4yNTkwMTldICBbPGQxZTM1OWRmPl0gPyBjYWxsX3Rp
bWVyX2ZuKzB4MzYvMHhkMgpbICAgIDEuMjU5MDE5XSAgWzxkMWU1OTFiZD5dID8gdHJhY2Vf
aGFyZGlycXNfb25fY2FsbGVyKzB4YTAvMHgxYWYKWyAgICAxLjI1OTAxOV0gIFs8ZDFlMzU5
OWY+XSA/IGluaXRfdGltZXJfa2V5KzB4M2QvMHgzZApbICAgIDEuMjU5MDE5XSAgWzxkMWUz
NjE5OD5dIHJ1bl90aW1lcl9zb2Z0aXJxKzB4MTRiLzB4MWMwClsgICAgMS4yNTkwMTldICBb
PGQxZTM1OTlmPl0gPyBpbml0X3RpbWVyX2tleSsweDNkLzB4M2QKWyAgICAxLjI1OTAxOV0g
IFs8ZDFlMzBjNTI+XSBfX2RvX3NvZnRpcnErMHhkOS8weDFmNApbICAgIDEuMjU5MDE5XSAg
WzxkMWUzMGI3OT5dID8gX190YXNrbGV0X3NjaGVkdWxlKzB4NmUvMHg2ZQpbICAgIDEuMjU5
MDE5XSAgWzxkMWUwMzU3Nz5dIGRvX3NvZnRpcnFfb3duX3N0YWNrKzB4MWMvMHgyMgpbICAg
IDEuMjU5MDE5XSAgPElSUT4gIFs8ZDFlMzBmOGI+XSBpcnFfZXhpdCsweDUzLzB4NTUKWyAg
ICAxLjI1OTAxOV0gIFs8ZDFlMWY4OWY+XSBzbXBfYXBpY190aW1lcl9pbnRlcnJ1cHQrMHgz
MS8weDNhClsgICAgMS4yNTkwMTldICBbPGQyMjg3YmY5Pl0gYXBpY190aW1lcl9pbnRlcnJ1
cHQrMHgzOS8weDQwClsgICAgMS4yNTkwMTldICBbPGQyMjgwMDdiPl0gPyBleHQ0X21iX2Rp
c2NhcmRfZ3JvdXBfcHJlYWxsb2NhdGlvbnMrMHgzMC8weDMzZApbICAgIDEuMjU5MDE5XSAg
WzxkMWU4MDBlMD5dID8gY3B1X2Nsb2NrX2V2ZW50X3JlYWQrMHg4LzB4NDMKWyAgICAxLjI1
OTAxOV0gIFs8ZDFlOTFhZmU+XSA/IGZyZWVfcmVzZXJ2ZWRfYXJlYSsweDk3LzB4ZGMKWyAg
ICAxLjI1OTAxOV0gIFs8ZDFlMjc3ZTE+XSA/IHNldF9tZW1vcnlfcncrMHg0OC8weDRhClsg
ICAgMS4yNTkwMTldICBbPGQxZTI0YzMwPl0gZnJlZV9pbml0X3BhZ2VzKzB4NWIvMHg3ZQpb
ICAgIDEuMjU5MDE5XSAgWzxkMjVlZWNlNj5dID8gbWF5YmVfbGluay5wYXJ0LjIrMHhlNC8w
eGU0ClsgICAgMS4yNTkwMTldICBbPGQyNWVlY2U2Pl0gPyBtYXliZV9saW5rLnBhcnQuMisw
eGU0LzB4ZTQKWyAgICAxLjI1OTAxOV0gIFs8ZDI1ZmI4NmM+XSBmcmVlX2luaXRyZF9tZW0r
MHgyNi8weDJhClsgICAgMS4yNTkwMTldICBbPGQyNWVlZGJkPl0gcG9wdWxhdGVfcm9vdGZz
KzB4ZDcvMHhmOQpbICAgIDEuMjU5MDE5XSAgWzxkMjVlZWNlNj5dID8gbWF5YmVfbGluay5w
YXJ0LjIrMHhlNC8weGU0ClsgICAgMS4yNTkwMTldICBbPGQxZTAwNDI2Pl0gZG9fb25lX2lu
aXRjYWxsKzB4N2YvMHgxYjkKWyAgICAxLjI1OTAxOV0gIFs8ZDI1ZWVjZTY+XSA/IG1heWJl
X2xpbmsucGFydC4yKzB4ZTQvMHhlNApbICAgIDEuMjU5MDE5XSAgWzxkMWU1OTIwOD5dID8g
dHJhY2VfaGFyZGlycXNfb25fY2FsbGVyKzB4ZWIvMHgxYWYKWyAgICAxLjI1OTAxOV0gIFs8
ZDFlNDMxZWI+XSA/IHBhcmFtZXErMHgxMy8weDVlClsgICAgMS4yNTkwMTldICBbPGQyNWVk
NTliPl0gPyByZXBhaXJfZW52X3N0cmluZysweDEyLzB4NTEKWyAgICAxLjI1OTAxOV0gIFs8
ZDFlNDM0MWU+XSA/IHBhcnNlX2FyZ3MrMHgxZTgvMHgzMTgKWyAgICAxLjI1OTAxOV0gIFs8
ZDFlM2Q5NmE+XSA/IF9fdXNlcm1vZGVoZWxwZXJfc2V0X2Rpc2FibGVfZGVwdGgrMHgzZS8w
eDQ0ClsgICAgMS4yNTkwMTldICBbPGQyNWVkY2U3Pl0ga2VybmVsX2luaXRfZnJlZWFibGUr
MHhkZS8weDE3OApbICAgIDEuMjU5MDE5XSAgWzxkMjVlZDU4OT5dID8gaW5pdGNhbGxfYmxh
Y2tsaXN0KzB4ODEvMHg4MQpbICAgIDEuMjU5MDE5XSAgWzxkMjI3YWIyMD5dIGtlcm5lbF9p
bml0KzB4Yi8weGM3ClsgICAgMS4yNTkwMTldICBbPGQxZTRiYWRlPl0gPyBzY2hlZHVsZV90
YWlsKzB4Yy8weDNhClsgICAgMS4yNTkwMTldICBbPGQyMjg3MzQwPl0gcmV0X2Zyb21fa2Vy
bmVsX3RocmVhZCsweDIwLzB4MzAKWyAgICAxLjI1OTAxOV0gIFs8ZDIyN2FiMTU+XSA/IHJl
c3RfaW5pdCsweGI1LzB4YjUKCkVsYXBzZWQgdGltZTogMTAKcWVtdS1zeXN0ZW0teDg2XzY0
IC1jcHUga3ZtNjQgLWVuYWJsZS1rdm0gLWtlcm5lbCAva2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1pYjEtMDcyNTExNTMvOWEzYzQxNDVhZjMyMTI1YzVlZTM5YzAyNzI2NjJiNDczMDdhODMy
My92bWxpbnV6LTMuMTYuMC1yYzYgLWFwcGVuZCAnaHVuZ190YXNrX3BhbmljPTEgZWFybHlw
cmludGs9dHR5UzAsMTE1MjAwIGRlYnVnIGFwaWM9ZGVidWcgc3lzcnFfYWx3YXlzX2VuYWJs
ZWQgcmN1cGRhdGUucmN1X2NwdV9zdGFsbF90aW1lb3V0PTEwMCBwYW5pYz0xMCBzb2Z0bG9j
a3VwX3BhbmljPTEgbm1pX3dhdGNoZG9nPXBhbmljICBwcm9tcHRfcmFtZGlzaz0wIGNvbnNv
bGU9dHR5UzAsMTE1MjAwIGNvbnNvbGU9dHR5MCB2Z2E9bm9ybWFsICByb290PS9kZXYvcmFt
MCBydyBsaW5rPS9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
aWIxLTA3MjUxMTUzL25leHQ6bWFzdGVyOjlhM2M0MTQ1YWYzMjEyNWM1ZWUzOWMwMjcyNjYy
YjQ3MzA3YTgzMjM6YmlzZWN0LWxpbnV4LTkvLnZtbGludXotOWEzYzQxNDVhZjMyMTI1YzVl
ZTM5YzAyNzI2NjJiNDczMDdhODMyMy0yMDE0MDcyNTEyMjcyMi0xODgtaXZiNDEgYnJhbmNo
PW5leHQvbWFzdGVyIEJPT1RfSU1BR0U9L2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3
MjUxMTUzLzlhM2M0MTQ1YWYzMjEyNWM1ZWUzOWMwMjcyNjYyYjQ3MzA3YTgzMjMvdm1saW51
ei0zLjE2LjAtcmM2IGRyYmQubWlub3JfY291bnQ9OCcgIC1pbml0cmQgL2tlcm5lbC10ZXN0
cy9pbml0cmQvcXVhbnRhbC1jb3JlLWkzODYuY2d6IC1tIDMyMCAtc21wIDIgLW5ldCBuaWMs
dmxhbj0xLG1vZGVsPWUxMDAwIC1uZXQgdXNlcix2bGFuPTEgLWJvb3Qgb3JkZXI9bmMgLW5v
LXJlYm9vdCAtd2F0Y2hkb2cgaTYzMDBlc2IgLXJ0YyBiYXNlPWxvY2FsdGltZSAtcGlkZmls
ZSAvZGV2L3NobS9rYm9vdC9waWQtcXVhbnRhbC1pdmI0MS0xIC1zZXJpYWwgZmlsZTovZGV2
L3NobS9rYm9vdC9zZXJpYWwtcXVhbnRhbC1pdmI0MS0xIC1kYWVtb25pemUgLWRpc3BsYXkg
bm9uZSAtbW9uaXRvciBudWxsIAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTEx
NTMvOWEzYzQxNDVhZjMyMTI1YzVlZTM5YzAyNzI2NjJiNDczMDdhODMyMy9kbWVzZy1xdWFu
dGFsLWl2YjQxLTg3OjIwMTQwNzI1MTQxODI3OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTEx
NTM6OgoyOTU6MTo2IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpiaXNlY3Q6IGJhZCBj
b21taXQgOWEzYzQxNDVhZjMyMTI1YzVlZTM5YzAyNzI2NjJiNDczMDdhODMyMwpnaXQgY2hl
Y2tvdXQgdjMuMTUKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFu
ZGNvbmZpZy1pYjEtMDcyNTExNTMvbmV4dDptYXN0ZXI6MTg2MGUzNzk4NzVkZmU3MjcxYzY0
OTA1OGFlZGRmZmU1YWZkOWQwZDpiaXNlY3QtbGludXgtOQoKMjAxNC0wNy0yNS0xNDoyMDo1
NyAxODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVkZGZmZTVhZmQ5ZDBkIGNvbXBpbGluZwpR
dWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFu
ZGNvbmZpZy1pYjEtMDcyNTExNTMtMTg2MGUzNzk4NzVkZmU3MjcxYzY0OTA1OGFlZGRmZmU1
YWZkOWQwZApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWli
MS0wNzI1MTE1My8xODYwZTM3OTg3NWRmZTcyNzFjNjQ5MDU4YWVkZGZmZTVhZmQ5ZDBkCndh
aXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2
LXJhbmRjb25maWctaWIxLTA3MjUxMTUzLTE4NjBlMzc5ODc1ZGZlNzI3MWM2NDkwNThhZWRk
ZmZlNWFmZDlkMGQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlL2xrcC1pYjAzLXNtb2tlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMt
MTg2MGUzNzk4NzVkZmU3MjcxYzY0OTA1OGFlZGRmZmU1YWZkOWQwZAprZXJuZWw6IC9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My8xODYwZTM3OTg3NWRmZTcyNzFjNjQ5
MDU4YWVkZGZmZTVhZmQ5ZDBkL3ZtbGludXotMy4xNS4wCgoyMDE0LTA3LTI1LTE0OjM5OjU3
IGRldGVjdGluZyBib290IHN0YXRlIC4uCTEJMTAJMTQJMTUJMTcJMjUuCTI2CTMzCTQwLgk1
MQk1NAk2Mwk3MCBURVNUIEZBSUxVUkUKWyAgICAwLjgzODE3Nl0gUENJOiBDTFMgMCBieXRl
cywgZGVmYXVsdCA2NApbICAgIDAuODM5NjYzXSBVbnBhY2tpbmcgaW5pdHJhbWZzLi4uClsg
ICAgMC44NDM2NDRdIEluaXRyYW1mcyB1bnBhY2tpbmcgZmFpbGVkOiBqdW5rIGluIGNvbXBy
ZXNzZWQgYXJjaGl2ZQpbICAgIDAuODQ2MTI5XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2Vy
bmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCAwMDAwMDAwYwpbICAgIDAuODQ2Nzc2
XSBJUDogWzxkMWU1NzE3MT5dIHZhbGlkYXRlX2NoYWluLmlzcmEuMzcrMHhjNS8weDEwZTUK
WyAgICAwLjg0Njc3Nl0gKnBkcHQgPSAwMDAwMDAwMDAwMDAwMDAwICpwZGUgPSBmMDAwZmY1
M2YwMDBmZjUzIApbICAgIDAuODQ2Nzc2XSBPb3BzOiAwMDAwIFsjMV0gUFJFRU1QVCAKWyAg
ICAwLjg0Njc3Nl0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMC44NDY3NzZdIENQVTogMCBQ
SUQ6IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjE1LjAgIzEKWyAgICAwLjg0Njc3
Nl0gSGFyZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5
NiksIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDAuODQ2Nzc2XSB0YXNrOiBkMDQ0YTAx
MCB0aTogZDA0NGMwMDAgdGFzay50aTogZDA0NGMwMDAKWyAgICAwLjg0Njc3Nl0gRUlQOiAw
MDYwOls8ZDFlNTcxNzE+XSBFRkxBR1M6IDAwMDEwMDg2IENQVTogMApbICAgIDAuODQ2Nzc2
XSBFSVAgaXMgYXQgdmFsaWRhdGVfY2hhaW4uaXNyYS4zNysweGM1LzB4MTBlNQpbICAgIDAu
ODQ2Nzc2XSBFQVg6IDAwMDAwMDAwIEVCWDogMDAwMDAwODUgRUNYOiAwMDAwMDAwMCBFRFg6
IGZmZmZmZmZjClsgICAgMC44NDY3NzZdIEVTSTogZDA0NGE0ZjggRURJOiBkMjg1MTY2MCBF
QlA6IGQwNDRkZGRjIEVTUDogZDA0NGRkNzgKWyAgICAwLjg0Njc3Nl0gIERTOiAwMDdiIEVT
OiAwMDdiIEZTOiAwMDAwIEdTOiAwMGUwIFNTOiAwMDY4ClsgICAgMC44NDY3NzZdIENSMDog
ODAwNTAwM2IgQ1IyOiAwMDAwMDAwYyBDUjM6IDEyNjQ3MDAwIENSNDogMDAwMDA2YjAKWyAg
ICAwLjg0Njc3Nl0gU3RhY2s6ClsgICAgMC44NDY3NzZdICAwMDAwMDA4NSBkMDQ0ZGQ4NCBk
MWUyMzk1ZSBkMDQ0ZGQ4YyBkMWUwN2M1NSBkMDQ0ZGRiOCBkMjg3Y2YzMCBkMDQ0YTRmOApb
ICAgIDAuODQ2Nzc2XSAgMDAwMDAwMDEgZDA0NGEwMTAgMDAwMDAwMDAgMDAwMDAwMDAgMDAw
MDAwMDAgMDAwMDAwMDAgZDA0NGEwMTAgMDAwMDAwODUKWyAgICAwLjg0Njc3Nl0gIGQwNDRk
ZGQ0IGQxZTRjZWQ4IDMyNmVhN2RlIDAwMDAwMDAwIDAwMDAwMDAwIGQwNDRhMDEwIDAwMDAw
MDg1IGQwNDRhMDEwClsgICAgMC44NDY3NzZdIENhbGwgVHJhY2U6ClsgICAgMC44NDY3NzZd
ICBbPGQxZTIzOTVlPl0gPyBrdm1fY2xvY2tfcmVhZCsweDEzLzB4MjQKWyAgICAwLjg0Njc3
Nl0gIFs8ZDFlMDdjNTU+XSA/IHNjaGVkX2Nsb2NrKzB4OC8weGIKWyAgICAwLjg0Njc3Nl0g
IFs8ZDFlNGNlZDg+XSA/IHNjaGVkX2Nsb2NrX2NwdSsweGIxLzB4ZDAKWyAgICAwLjg0Njc3
Nl0gIFs8ZDFlNTkwZjI+XSBfX2xvY2tfYWNxdWlyZSsweDM1MC8weGFhNQpbICAgIDAuODQ2
Nzc2XSAgWzxkMWU1OWY5Nz5dIGxvY2tfYWNxdWlyZSsweDc3LzB4OTIKWyAgICAwLjg0Njc3
Nl0gIFs8ZDFlOGQ3Nzg+XSA/IGFkanVzdF9tYW5hZ2VkX3BhZ2VfY291bnQrMHgxMy8weDQ0
ClsgICAgMC44NDY3NzZdICBbPGQyMjdiMjljPl0gX3Jhd19zcGluX2xvY2srMHgzYy8weDY5
ClsgICAgMC44NDY3NzZdICBbPGQxZThkNzc4Pl0gPyBhZGp1c3RfbWFuYWdlZF9wYWdlX2Nv
dW50KzB4MTMvMHg0NApbICAgIDAuODQ2Nzc2XSAgWzxkMWU4ZDc3OD5dIGFkanVzdF9tYW5h
Z2VkX3BhZ2VfY291bnQrMHgxMy8weDQ0ClsgICAgMC44NDY3NzZdICBbPGQxZTkwOTdjPl0g
ZnJlZV9yZXNlcnZlZF9hcmVhKzB4NmIvMHhkYwpbICAgIDAuODQ2Nzc2XSAgWzxkMWUyNzI1
MT5dID8gc2V0X21lbW9yeV9ydysweDQ4LzB4NGEKWyAgICAwLjg0Njc3Nl0gIFs8ZDFlMjQ2
YTA+XSBmcmVlX2luaXRfcGFnZXMrMHg1Yi8weDdlClsgICAgMC44NDY3NzZdICBbPGQyNWU3
NmM0Pl0gZnJlZV9pbml0cmRfbWVtKzB4MjYvMHgyYQpbICAgIDAuODQ2Nzc2XSAgWzxkMjVk
YWNjMj5dIHBvcHVsYXRlX3Jvb3RmcysweGQ3LzB4ZjkKWyAgICAwLjg0Njc3Nl0gIFs8ZDI1
ZGFiZWI+XSA/IG1heWJlX2xpbmsucGFydC41KzB4ZTQvMHhlNApbICAgIDAuODQ2Nzc2XSAg
WzxkMWUwMDQ4Nj5dIGRvX29uZV9pbml0Y2FsbCsweGRmLzB4MTM5ClsgICAgMC44NDY3NzZd
ICBbPGQxZTU0ZWI2Pl0gPyBsb2NrX3JlbGVhc2VfaG9sZHRpbWUucGFydC4yMCsweDkzLzB4
ZjgKWyAgICAwLjg0Njc3Nl0gIFs8ZDFlNThhNTg+XSA/IHRyYWNlX2hhcmRpcnFzX29uX2Nh
bGxlcisweGViLzB4MWFmClsgICAgMC44NDY3NzZdICBbPGQxZTQyYWZiPl0gPyBwYXJhbWVx
KzB4MTMvMHg1ZQpbICAgIDAuODQ2Nzc2XSAgWzxkMjVkOTUxYT5dID8gcmVwYWlyX2Vudl9z
dHJpbmcrMHgxMi8weDUxClsgICAgMC44NDY3NzZdICBbPGQxZTQyZDA1Pl0gPyBwYXJzZV9h
cmdzKzB4MWJmLzB4MmY4ClsgICAgMC44NDY3NzZdICBbPGQxZTNkMTI1Pl0gPyBfX3VzZXJt
b2RlaGVscGVyX3NldF9kaXNhYmxlX2RlcHRoKzB4M2UvMHg0NApbICAgIDAuODQ2Nzc2XSAg
WzxkMjVkOWJlYz5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4ZGUvMHgxNzgKWyAgICAwLjg0
Njc3Nl0gIFs8ZDI1ZDk1MDg+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4NzgvMHg3OApbICAgIDAu
ODQ2Nzc2XSAgWzxkMjI2ZWE0MD5dIGtlcm5lbF9pbml0KzB4Yi8weGM3ClsgICAgMC44NDY3
NzZdICBbPGQxZTRiM2JlPl0gPyBzY2hlZHVsZV90YWlsKzB4Yy8weDNhClsgICAgMC44NDY3
NzZdICBbPGQyMjdjN2MwPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDIwLzB4MzAKWyAg
ICAwLjg0Njc3Nl0gIFs8ZDIyNmVhMzU+XSA/IHJlc3RfaW5pdCsweGI1LzB4YjUKWyAgICAw
Ljg0Njc3Nl0gQ29kZTogODkgNGQgYzQgMzkgYzcgNzQgNDEgOGIgNGQgYzggMzMgNDggMGMg
OGIgNTAgMDggMzEgZGEgMDkgZDEgMGYgODQgNTkgMDMgMDAgMDAgOGIgNTUgYzQgODkgNzUg
YjggOGIgNDUgYzggODkgNDUgYzQgZWIgMTMgOGIgNGQgYzQgPDMzPiA0OCAwYyA4YiA3MCAw
OCAzMSBkZSAwOSBmMSAwZiA4NCAzOCAwMyAwMCAwMCA4YiA0MiAwNCA4ZCA1MApbICAgIDAu
ODQ2Nzc2XSBFSVA6IFs8ZDFlNTcxNzE+XSB2YWxpZGF0ZV9jaGFpbi5pc3JhLjM3KzB4YzUv
MHgxMGU1IFNTOkVTUCAwMDY4OmQwNDRkZDc4ClsgICAgMC44NDY3NzZdIENSMjogMDAwMDAw
MDAwMDAwMDAwYwpbICAgIDAuODQ2Nzc2XSAtLS1bIGVuZCB0cmFjZSA5MThlZTg1ZTVjYzQy
M2NmIF0tLS0KWyAgICAwLjg0Njc3Nl0gbm90ZTogc3dhcHBlclsxXSBleGl0ZWQgd2l0aCBw
cmVlbXB0X2NvdW50IDEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzLzE4
NjBlMzc5ODc1ZGZlNzI3MWM2NDkwNThhZWRkZmZlNWFmZDlkMGQvZG1lc2ctcXVhbnRhbC1p
dmI0Mi02NToyMDE0MDcyNTE0NTIyNDppMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzOjoK
NzA6MToxIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpiaXNlY3Q6IGJhZCBjb21taXQg
djMuMTUKZ2l0IGNoZWNrb3V0IHYzLjE0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzL25leHQ6bWFzdGVyOjQ1NWM2ZmRi
ZDIxOTE2MWJkMDliMTE2NWYxMTY5OWQ2ZDczZGUxMWM6YmlzZWN0LWxpbnV4LTkKCjIwMTQt
MDctMjUtMTQ6NDg6MzkgNDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjExNjk5ZDZkNzNkZTEx
YyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzLTQ1NWM2ZmRiZDIxOTE2MWJkMDli
MTE2NWYxMTY5OWQ2ZDczZGUxMWMKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYt
cmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvNDU1YzZmZGJkMjE5MTYxYmQwOWIxMTY1ZjExNjk5
ZDZkNzNkZTExYwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVp
bGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My00NTVjNmZkYmQyMTkxNjFi
ZDA5YjExNjVmMTE2OTlkNmQ3M2RlMTFjCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2ti
dWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9qYWtldG93bi1jb25zdW1lci9pMzg2LXJhbmRjb25m
aWctaWIxLTA3MjUxMTUzLTQ1NWM2ZmRiZDIxOTE2MWJkMDliMTE2NWYxMTY5OWQ2ZDczZGUx
MWMKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvNDU1YzZm
ZGJkMjE5MTYxYmQwOWIxMTY1ZjExNjk5ZDZkNzNkZTExYy92bWxpbnV6LTMuMTQuMAoKMjAx
NC0wNy0yNS0xNDo1NTozOSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4JMQkyCTcJMTEJMTMJ
MTYJNDAJNTMJNTYJNTcJNjQJNjcJNzgJODMuCTEwNAkxMTYJMTE4CTEyNQkxMjcJMTM1CTE1
NQkxNzAJMTc5CTE4OAkxOTQJMTk4CTIwOQkyNDMJMjQ2CTI2MQkyNjkJMjcwCTI4MQkyODMu
CTI4NgkyOTAuCTI5MQkyOTgJMzA2Li4JMzE3CTM0OQkzNTMJMzY0CTM2OAk0MDEJNDE1CTQx
OAk0MjMJNDI4CTQzMgk0MzYJNDQ0CTQ3Mgk0NzQJNDg3CTQ5NC4JNTAzCTUwOS4uCTUxMwk1
MjAgVEVTVCBGQUlMVVJFClsgICA0My43NDE0MzldIHJ0Yy10ZXN0IHJ0Yy10ZXN0LjA6IHNl
dHRpbmcgc3lzdGVtIGNsb2NrIHRvIDIwMTQtMDctMjUgMDc6MDQ6MzEgVVRDICgxNDA2Mjcx
ODcxKQpbICAgNDMuNzQ0MTUyXSBWRlM6IENhbm5vdCBvcGVuIHJvb3QgZGV2aWNlICJyYW0w
IiBvciB1bmtub3duLWJsb2NrKDAsMCk6IGVycm9yIC02ClsgICA0My43NDYxMDZdIFBsZWFz
ZSBhcHBlbmQgYSBjb3JyZWN0ICJyb290PSIgYm9vdCBvcHRpb247IGhlcmUgYXJlIHRoZSBh
dmFpbGFibGUgcGFydGl0aW9uczoKWyAgIDQzLjc0ODI4M10gS2VybmVsIHBhbmljIC0gbm90
IHN5bmNpbmc6IFZGUzogVW5hYmxlIHRvIG1vdW50IHJvb3QgZnMgb24gdW5rbm93bi1ibG9j
aygwLDApClsgICA0My43NTAzOTNdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBOb3Qg
dGFpbnRlZCAzLjE0LjAgIzEKWyAgIDQzLjc1MTc0OV0gSGFyZHdhcmUgbmFtZTogUUVNVSBT
dGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5NiksIEJJT1MgQm9jaHMgMDEvMDEvMjAx
MQpbICAgNDMuNzUyMjIwXSAgZDAwNWRmMTAgZDAwNWRmMTAgZDAwNWRlYzQgZDFlNjQ1MmQg
ZDAwNWRlZTQgZDFlNjBjNGQgZDFmODY4MzQgZDIyM2FhNDAKWyAgIDQzLjc1MjIyMF0gIDMx
ODBhNDFhIGQwMDVkZjEwIDAwMDA4MDAwIGQzODVhMDAwIGQwMDVkZjQwIGQyMWJmZjRmIGQx
Zjc5ZTE0IGQwMDVkZjEwClsgICA0My43NTIyMjBdICBkMDA1ZGYxMCBmZmZmZmZmYSAwMDAw
MDAwMCBkMzg1YTBjYSAwMDAwMDAwMCBkMDdmMGI0MCBmZmZmZmZmYSA2ZTZiNmU3NQpbICAg
NDMuNzUyMjIwXSBDYWxsIFRyYWNlOgpbICAgNDMuNzUyMjIwXSAgWzxkMWU2NDUyZD5dIGR1
bXBfc3RhY2srMHgxNi8weDE4ClsgICA0My43NTIyMjBdICBbPGQxZTYwYzRkPl0gcGFuaWMr
MHg4Ny8weDE3NApbICAgNDMuNzUyMjIwXSAgWzxkMjFiZmY0Zj5dIG1vdW50X2Jsb2NrX3Jv
b3QrMHgyMDIvMHgyNzQKWyAgIDQzLjc1MjIyMF0gIFs8ZDFhYzBlYWY+XSA/IFN5U19ta25v
ZCsweDI4LzB4MmEKWyAgIDQzLjc1MjIyMF0gIFs8ZDIxYzAwMWM+XSBtb3VudF9yb290KzB4
NWIvMHg2MQpbICAgNDMuNzUyMjIwXSAgWzxkMjFjMDEzYz5dIHByZXBhcmVfbmFtZXNwYWNl
KzB4MTFhLzB4MTU0ClsgICA0My43NTIyMjBdICBbPGQxYWIyYThjPl0gPyBTeVNfYWNjZXNz
KzB4MjAvMHgyMgpbICAgNDMuNzUyMjIwXSAgWzxkMjFiZmM3OT5dIGtlcm5lbF9pbml0X2Zy
ZWVhYmxlKzB4MTZiLzB4MTc4ClsgICA0My43NTIyMjBdICBbPGQyMWJmNTA4Pl0gPyBkb19l
YXJseV9wYXJhbSsweDc4LzB4NzgKWyAgIDQzLjc1MjIyMF0gIFs8ZDFlNWNmOTA+XSBrZXJu
ZWxfaW5pdCsweGIvMHhjNwpbICAgNDMuNzUyMjIwXSAgWzxkMWE0YTljNT5dID8gc2NoZWR1
bGVfdGFpbCsweGMvMHgzYQpbICAgNDMuNzUyMjIwXSAgWzxkMWU2YTliNz5dIHJldF9mcm9t
X2tlcm5lbF90aHJlYWQrMHgxYi8weDI4ClsgICA0My43NTIyMjBdICBbPGQxZTVjZjg1Pl0g
PyByZXN0X2luaXQrMHhiNS8weGI1ClsgICA0My43NTIyMjBdIEtlcm5lbCBPZmZzZXQ6IDB4
MTBhMDAwMDAgZnJvbSAweGMxMDAwMDAwIChyZWxvY2F0aW9uIHJhbmdlOiAweGMwMDAwMDAw
LTB4ZDQ3ZmRmZmYpCgpFbGFwc2VkIHRpbWU6IDQ1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWliMS0wNzI1MTE1My80NTVjNmZkYmQyMTkxNjFiZDA5YjExNjVmMTE2OTlkNmQ3M2RlMTFj
L2RtZXNnLXF1YW50YWwtdnAtNzoyMDE0MDcyNTE1MzEyNzppMzg2LXJhbmRjb25maWctaWIx
LTA3MjUxMTUzOjMuMTQuMDoxCjUxNDoxOjcgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMK
CmJpc2VjdDogYmFkIGNvbW1pdCB2My4xNApnaXQgY2hlY2tvdXQgdjMuMTMKbHMgLWEgL2ti
dWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMv
bmV4dDptYXN0ZXI6ZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZTpi
aXNlY3QtbGludXgtOQoKMjAxNC0wNy0yNS0xNTozMToxNCBkOGVjMjZkN2Y4Mjg3ZjU3ODhh
NDk0ZjU2ZTg4MTQyMTBmMGU2NGJlIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMt
ZDhlYzI2ZDdmODI4N2Y1Nzg4YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZQpDaGVjayBmb3Iga2Vy
bmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My9kOGVjMjZkN2Y4
Mjg3ZjU3ODhhNDk0ZjU2ZTg4MTQyMTBmMGU2NGJlCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUx
MTUzLWQ4ZWMyNmQ3ZjgyODdmNTc4OGE0OTRmNTZlODgxNDIxMGYwZTY0YmUKa2VybmVsOiAv
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvZDhlYzI2ZDdmODI4N2Y1Nzg4
YTQ5NGY1NmU4ODE0MjEwZjBlNjRiZS92bWxpbnV6LTMuMTMuMAoKMjAxNC0wNy0yNS0xNToz
MzoxNCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMQkyCTcuCTE1CTM1CTUwCTU2CTYwCTYyCTg1
CTkwCTEwMAkxMjEJMTI0CTEyOAkxNDcJMTYyCTE2NQkyMDgJMjIyCTIyNQkyMjcJMjM1CTI3
MgkyNzkJMjg0CTI5MQkzMjYJMzY0CTM4MQk0MzEJNTAzCTU2MQk2MzAJNjQ2CTcxNQk3NzQJ
NzkzCTg5OAk5MDAgU1VDQ0VTUwoKYmlzZWN0OiBnb29kIGNvbW1pdCB2My4xMwpnaXQgYmlz
ZWN0IHN0YXJ0IHYzLjE0IHYzLjEzIC0tCi9jL2tlcm5lbC10ZXN0cy9saW5lYXItYmlzZWN0
OiBbIi1iIiwgInYzLjE0IiwgIi1nIiwgInYzLjEzIiwgIi9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2giLCAiL2MvYm9vdC1iaXNlY3QvbGludXgtOS9vYmot
YmlzZWN0Il0KQmlzZWN0aW5nOiAxMzQxNSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgMTQgc3RlcHMpCls0OTQ0NzkwMzhkOTdmMWI5Zjc2ZmM2MzNhMzYw
YTY4MWFjZGYwMzVjXSBNZXJnZSB0YWcgJ3BpbmN0cmwtdjMuMTQtMicgb2YgZ2l0Oi8vZ2l0
Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2xpbnVzdy9saW51eC1waW5j
dHJsCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aCAvYy9ib290LWJpc2VjdC9saW51eC05L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvbmV4dDptYXN0
ZXI6NDk0NDc5MDM4ZDk3ZjFiOWY3NmZjNjMzYTM2MGE2ODFhY2RmMDM1YzpiaXNlY3QtbGlu
dXgtOQoKMjAxNC0wNy0yNS0xNTo1Mzo0OCA0OTQ0NzkwMzhkOTdmMWI5Zjc2ZmM2MzNhMzYw
YTY4MWFjZGYwMzVjIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRl
c3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMtNDk0NDc5MDM4
ZDk3ZjFiOWY3NmZjNjMzYTM2MGE2ODFhY2RmMDM1YwpDaGVjayBmb3Iga2VybmVsIGluIC9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My80OTQ0NzkwMzhkOTdmMWI5Zjc2
ZmM2MzNhMzYwYTY4MWFjZGYwMzVjCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzLTQ5NDQ3
OTAzOGQ5N2YxYjlmNzZmYzYzM2EzNjBhNjgxYWNkZjAzNWMKd2FpdGluZyBmb3IgY29tcGxl
dGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2pha2V0b3duLWNvbnN1bWVyL2kz
ODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMtNDk0NDc5MDM4ZDk3ZjFiOWY3NmZjNjMzYTM2
MGE2ODFhY2RmMDM1YwpzdGF0dXM6IEZBSUw6IGJ1aWxkIGVycm9yChtbMTszNW0yMDE0LTA3
LTI1IDE2OjA5OjQ4IEtlcm5lbCBidWlsZCBmYWlsIG9yIHRpbWVvdXQbWzBtCjIwMTQtMDct
MjUtMTY6MDk6NDggNDk0NDc5MDM4ZDk3ZjFiOWY3NmZjNjMzYTM2MGE2ODFhY2RmMDM1YyBT
S0lQIEJST0tFTiBCVUlMRApDaGVjayAva2J1aWxkLXRlc3RzL2J1aWxkLXNlcnZlZC9pMzg2
LXJhbmRjb25maWctaWIxLTA3MjUxMTUzLTQ5NDQ3OTAzOGQ5N2YxYjlmNzZmYzYzM2EzNjBh
NjgxYWNkZjAzNWMKQmlzZWN0aW5nOiAxMzQxNSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgMTQgc3RlcHMpClswOWRmN2M0YzgwOTdjYTRhMTEzOTNiMWVk
ZDQ5OTdkNzg2ZGFhZDUyXSB4ODY6IFJlbW92ZSBDT05GSUdfWDg2X09PU1RPUkUKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3Qt
YmlzZWN0L2xpbnV4LTkvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My9uZXh0Om1hc3RlcjowOWRmN2M0
YzgwOTdjYTRhMTEzOTNiMWVkZDQ5OTdkNzg2ZGFhZDUyOmJpc2VjdC1saW51eC05CgoyMDE0
LTA3LTI1LTE2OjA5OjUwIDA5ZGY3YzRjODA5N2NhNGExMTM5M2IxZWRkNDk5N2Q3ODZkYWFk
NTIgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQt
cXVldWUvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My0wOWRmN2M0YzgwOTdjYTRhMTEz
OTNiMWVkZDQ5OTdkNzg2ZGFhZDUyCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctaWIxLTA3MjUxMTUzLzA5ZGY3YzRjODA5N2NhNGExMTM5M2IxZWRkNDk5
N2Q3ODZkYWFkNTIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMtMDlkZjdjNGM4MDk3Y2E0
YTExMzkzYjFlZGQ0OTk3ZDc4NmRhYWQ1Mgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtwLWliMDMtc21va2UvaTM4Ni1yYW5kY29uZmln
LWliMS0wNzI1MTE1My0wOWRmN2M0YzgwOTdjYTRhMTEzOTNiMWVkZDQ5OTdkNzg2ZGFhZDUy
Cmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzLzA5ZGY3YzRj
ODA5N2NhNGExMTM5M2IxZWRkNDk5N2Q3ODZkYWFkNTIvdm1saW51ei0zLjE0LjAtcmM2LTAw
MDE4LWcwOWRmN2M0CgoyMDE0LTA3LTI1LTE2OjE3OjUxIGRldGVjdGluZyBib290IHN0YXRl
IC4uIFRFU1QgRkFJTFVSRQpbICAgIDAuNjU1NTU4XSBQQ0k6IENMUyAwIGJ5dGVzLCBkZWZh
dWx0IDY0ClsgICAgMC42NTY5NDddIFVucGFja2luZyBpbml0cmFtZnMuLi4KWyAgICAxLjYy
NzM0Nl0gRnJlZWluZyBpbml0cmQgbWVtb3J5OiAyNDg1MksgKGQyN2FiMDAwIC0gZDNmZjAw
MDApClsgICAgMS42MjkxNTNdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBw
b2ludGVyIGRlcmVmZXJlbmNlIGF0IDAwMDAwMDNjClsgICAgMS42MzA4MjBdIElQOiBbPGNk
ZGM3NTg2Pl0gcmFwbF9wbXVfaW5pdCsweDExNi8weDE3NQpbICAgIDEuNjMyMTE5XSAqcGRw
dCA9IDAwMDAwMDAwMDAwMDAwMDAgKnBkZSA9IGYwMDBmZjUzZjAwMGZmNTMgClsgICAgMS42
MzI3MDldIE9vcHM6IDAwMDAgWyMxXSBQUkVFTVBUIApbICAgIDEuNjMyNzA5XSBNb2R1bGVz
IGxpbmtlZCBpbjoKWyAgICAxLjYzMjcwOV0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVy
IE5vdCB0YWludGVkIDMuMTQuMC1yYzYtMDAwMTgtZzA5ZGY3YzQgIzEKWyAgICAxLjYzMjcw
OV0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpb
ICAgIDEuNjMyNzA5XSB0YXNrOiBkMTA1NjAxMCB0aTogZDEwNTgwMDAgdGFzay50aTogZDEw
NTgwMDAKWyAgICAxLjYzMjcwOV0gRUlQOiAwMDYwOls8Y2RkYzc1ODY+XSBFRkxBR1M6IDAw
MDEwMjQ2IENQVTogMApbICAgIDEuNjMyNzA5XSBFSVAgaXMgYXQgcmFwbF9wbXVfaW5pdCsw
eDExNi8weDE3NQpbICAgIDEuNjMyNzA5XSBFQVg6IDAwMDAwMDAwIEVCWDogMDAwMDAwMDAg
RUNYOiAwMDAwMDAwMCBFRFg6IDAwMDAwMDAxClsgICAgMS42MzI3MDldIEVTSTogY2RkYzc0
NzAgRURJOiAwMDAwMDBkMSBFQlA6IGQxMDU5ZjAwIEVTUDogZDEwNTllZDgKWyAgICAxLjYz
MjcwOV0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMDAwIEdTOiAwMGUwIFNTOiAwMDY4Clsg
ICAgMS42MzI3MDldIENSMDogODAwNTAwMzMgQ1IyOiAwMDAwMDAzYyBDUjM6IDBkZTJkMDAw
IENSNDogMDAwNDA2YjAKWyAgICAxLjYzMjcwOV0gU3RhY2s6ClsgICAgMS42MzI3MDldICBj
ZGRjNTQ3ZSBkMTE1NTNkOCBjZGMzNWM5NCBkMTEyMjFjMCBjZGI3YTlkMSAwMDAwMDAwMiBj
ZDhlNDdhZSAwMDAwMDAwMApbICAgIDEuNjMyNzA5XSAgY2RkYzc0NzAgMDAwMDAwZDEgZDEw
NTlmNzQgY2Q2MDA0ODYgY2Q2NTQyMzYgZDEwNTlmMmMgY2Q2NTZkOWQgZDNmZjYzZDEKWyAg
ICAxLjYzMjcwOV0gIGQxMDU5ZjM0IGNkNjQyMDRiIGQzZmY2M2QxIGQxMDU5ZjAwIGNkZGJm
NTFhIGNkYzIyNzM4IDAwMDAwMGQxIGQxMDU5Zjc0ClsgICAgMS42MzI3MDldIENhbGwgVHJh
Y2U6ClsgICAgMS42MzI3MDldICBbPGNkZGM1NDdlPl0gPyBjYWNoZV9zeXNmc19pbml0KzB4
MWRkLzB4MWU3ClsgICAgMS42MzI3MDldICBbPGNkOGU0N2FlPl0gPyByZWdpc3Rlcl9zeXNj
b3JlX29wcysweDMyLzB4MzUKWyAgICAxLjYzMjcwOV0gIFs8Y2RkYzc0NzA+XSA/IGludGVs
X3VuY29yZV9pbml0KzB4MjUxLzB4MjUxClsgICAgMS42MzI3MDldICBbPGNkNjAwNDg2Pl0g
ZG9fb25lX2luaXRjYWxsKzB4ZGYvMHgxMzkKWyAgICAxLjYzMjcwOV0gIFs8Y2Q2NTQyMzY+
XSA/IGxvY2tfcmVsZWFzZV9ob2xkdGltZS5wYXJ0LjIwKzB4OTMvMHhmOApbICAgIDEuNjMy
NzA5XSAgWzxjZDY1NmQ5ZD5dID8gdHJhY2VfaGFyZGlycXNfb25fY2FsbGVyKzB4ZWIvMHgx
YWQKWyAgICAxLjYzMjcwOV0gIFs8Y2Q2NDIwNGI+XSA/IHBhcmFtZXErMHgxMy8weDVlClsg
ICAgMS42MzI3MDldICBbPGNkZGJmNTFhPl0gPyByZXBhaXJfZW52X3N0cmluZysweDEyLzB4
NTEKWyAgICAxLjYzMjcwOV0gIFs8Y2Q2NDIyNTU+XSA/IHBhcnNlX2FyZ3MrMHgxYmYvMHgy
ZjgKWyAgICAxLjYzMjcwOV0gIFs8Y2Q2M2M2YTU+XSA/IF9fdXNlcm1vZGVoZWxwZXJfc2V0
X2Rpc2FibGVfZGVwdGgrMHgzZS8weDQ0ClsgICAgMS42MzI3MDldICBbPGNkZGJmYmVjPl0g
a2VybmVsX2luaXRfZnJlZWFibGUrMHhkZS8weDE3OApbICAgIDEuNjMyNzA5XSAgWzxjZGRi
ZjUwOD5dID8gZG9fZWFybHlfcGFyYW0rMHg3OC8weDc4ClsgICAgMS42MzI3MDldICBbPGNk
YTVjOWQwPl0ga2VybmVsX2luaXQrMHhiLzB4YzcKWyAgICAxLjYzMjcwOV0gIFs8Y2Q2NGE4
M2U+XSA/IHNjaGVkdWxlX3RhaWwrMHhjLzB4M2EKWyAgICAxLjYzMjcwOV0gIFs8Y2RhNmE0
Mzc+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MWIvMHgyOApbICAgIDEuNjMyNzA5XSAg
WzxjZGE1YzljNT5dID8gcmVzdF9pbml0KzB4YjUvMHhiNQpbICAgIDEuNjMyNzA5XSBDb2Rl
OiAyNCBiYSA5MyAwMiAwMCAwMCBiOCA5NCBmYiBiNyBjZCBlOCAwYiA1NSA4NiBmZiA4OSA1
YyAyNCAwNCBjNyAwNCAyNCBkNCBmYiBiNyBjZCBlOCAzMCBhMiBjOSBmZiA4MyBjOCBmZiBl
YiA1ZCA4YiAxZCA0MCBkNyBjMyBjZCA8OGI+IDQzIDNjIDhiIDUzIDQwIGU4IGM4IDdkIDg2
IGZmIDg5IGQ2IGI5IGU4IDAzIDAwIDAwIGY3IGU5IDg5ClsgICAgMS42MzI3MDldIEVJUDog
WzxjZGRjNzU4Nj5dIHJhcGxfcG11X2luaXQrMHgxMTYvMHgxNzUgU1M6RVNQIDAwNjg6ZDEw
NTllZDgKWyAgICAxLjYzMjcwOV0gQ1IyOiAwMDAwMDAwMDAwMDAwMDNjClsgICAgMS42MzI3
MDldIC0tLVsgZW5kIHRyYWNlIDMyNWNkNjg4YmIzMjkwZjYgXS0tLQpbICAgIDEuNjMyNzA5
XSBzd2FwcGVyICgxKSB1c2VkIGdyZWF0ZXN0IHN0YWNrIGRlcHRoOiA1NzE2IGJ5dGVzIGxl
ZnQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzLzA5ZGY3YzRjODA5N2Nh
NGExMTM5M2IxZWRkNDk5N2Q3ODZkYWFkNTIvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMTA6MjAx
NDA3MjUxNjE2Mjg6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1MzozLjE0LjAtcmM2LTAw
MDE4LWcwOWRmN2M0OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzLzA5
ZGY3YzRjODA5N2NhNGExMTM5M2IxZWRkNDk5N2Q3ODZkYWFkNTIvZG1lc2ctcXVhbnRhbC1r
YnVpbGQtMTg6MjAxNDA3MjUxNjE2Mjg6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1Mzoz
LjE0LjAtcmM2LTAwMDE4LWcwOWRmN2M0OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIx
LTA3MjUxMTUzLzA5ZGY3YzRjODA5N2NhNGExMTM5M2IxZWRkNDk5N2Q3ODZkYWFkNTIvZG1l
c2ctcXVhbnRhbC1rYnVpbGQtMjM6MjAxNDA3MjUxNjE2Mjg6aTM4Ni1yYW5kY29uZmlnLWli
MS0wNzI1MTE1MzozLjE0LjAtcmM2LTAwMDE4LWcwOWRmN2M0OjEKMDozOjMgYWxsX2dvb2Q6
YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2VjdGluZzogMTMwNzMgcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDE0IHN0ZXBzKQpbMmNiZTVjNzZmYzVlMzhlOWFm
NGI3MDk1OTMxNDZlNGI4MjcyYjY5ZV0gaHBmczogcmVtZW1iZXIgZnJlZSBzcGFjZQpydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9v
dC1iaXNlY3QvbGludXgtOS9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1
ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzL25leHQ6bWFzdGVyOjJjYmU1
Yzc2ZmM1ZTM4ZTlhZjRiNzA5NTkzMTQ2ZTRiODI3MmI2OWU6YmlzZWN0LWxpbnV4LTkKCjIw
MTQtMDctMjUtMTY6MTg6NTkgMmNiZTVjNzZmYzVlMzhlOWFmNGI3MDk1OTMxNDZlNGI4Mjcy
YjY5ZSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzLTJjYmU1Yzc2ZmM1ZTM4ZTlh
ZjRiNzA5NTkzMTQ2ZTRiODI3MmI2OWUKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvMmNiZTVjNzZmYzVlMzhlOWFmNGI3MDk1OTMx
NDZlNGI4MjcyYjY5ZQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My0yY2JlNWM3NmZjNWUz
OGU5YWY0YjcwOTU5MzE0NmU0YjgyNzJiNjllCnN0YXR1czogRkFJTDogYnVpbGQgZXJyb3IK
G1sxOzM1bTIwMTQtMDctMjUgMTY6MjA6NTkgS2VybmVsIGJ1aWxkIGZhaWwgb3IgdGltZW91
dBtbMG0KMjAxNC0wNy0yNS0xNjoyMDo1OSAyY2JlNWM3NmZjNWUzOGU5YWY0YjcwOTU5MzE0
NmU0YjgyNzJiNjllIFNLSVAgQlJPS0VOIEJVSUxECkNoZWNrIC9rYnVpbGQtdGVzdHMvYnVp
bGQtc2VydmVkL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMtMmNiZTVjNzZmYzVlMzhl
OWFmNGI3MDk1OTMxNDZlNGI4MjcyYjY5ZQpCaXNlY3Rpbmc6IDEzMDczIHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxNCBzdGVwcykKWzE1YzgxMDI2MjA0
ZGE4OTdhMDU0MjRjNzkyNjNhZWE4NjFhNzgyY2NdIE1lcmdlIGJyYW5jaCAneDg2LXgzMi1m
b3ItbGludXMnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVs
L2dpdC90aXAvdGlwCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC05L29iai1iaXNlY3QKbHMgLWEgL2ti
dWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMv
bmV4dDptYXN0ZXI6MTVjODEwMjYyMDRkYTg5N2EwNTQyNGM3OTI2M2FlYTg2MWE3ODJjYzpi
aXNlY3QtbGludXgtOQoKMjAxNC0wNy0yNS0xNjoyMTowMyAxNWM4MTAyNjIwNGRhODk3YTA1
NDI0Yzc5MjYzYWVhODYxYTc4MmNjIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMt
MTVjODEwMjYyMDRkYTg5N2EwNTQyNGM3OTI2M2FlYTg2MWE3ODJjYwpDaGVjayBmb3Iga2Vy
bmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My8xNWM4MTAyNjIw
NGRhODk3YTA1NDI0Yzc5MjYzYWVhODYxYTc4MmNjCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUx
MTUzLTE1YzgxMDI2MjA0ZGE4OTdhMDU0MjRjNzkyNjNhZWE4NjFhNzgyY2MKa2VybmVsOiAv
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvMTVjODEwMjYyMDRkYTg5N2Ew
NTQyNGM3OTI2M2FlYTg2MWE3ODJjYy92bWxpbnV6LTMuMTMuMC0wMDc2Mi1nMTVjODEwMgoK
MjAxNC0wNy0yNS0xNjoyMzowMyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTIgVEVTVCBGQUlM
VVJFClsgICAgOC4xOTAwMDddIFBDSTogQ0xTIDAgYnl0ZXMsIGRlZmF1bHQgNjQKWyAgICA4
LjE5MTM4NF0gVW5wYWNraW5nIGluaXRyYW1mcy4uLgpbICAgIDkuMDI0ODQwXSBGcmVlaW5n
IGluaXRyZCBtZW1vcnk6IDI0ODUySyAoZDI3YWIwMDAgLSBkM2ZmMDAwMCkKWyAgICA5LjAy
Njg2M10gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZl
cmVuY2UgYXQgMDAwMDAwM2MKWyAgICA5LjAyODg3MV0gSVA6IFs8YzUzYjY0OGQ+XSByYXBs
X3BtdV9pbml0KzB4MTE2LzB4MTc1ClsgICAgOS4wMzA0MzNdICpwZHB0ID0gMDAwMDAwMDAw
MDAwMDAwMCAqcGRlID0gZjAwMGZmNTNmMDAwZmY1MyAKWyAgICA5LjAzMjA5Ml0gT29wczog
MDAwMCBbIzFdIFBSRUVNUFQgClsgICAgOS4wMzMxODRdIE1vZHVsZXMgbGlua2VkIGluOgpb
ICAgIDkuMDM0MzYxXSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQg
My4xMy4wLTAwNzYyLWcxNWM4MTAyICMzClsgICAgOS4wMzYxNTVdIEhhcmR3YXJlIG5hbWU6
IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICA5LjAzNzcxNV0gdGFz
azogZDEwNWEwMTAgdGk6IGQxMDVjMDAwIHRhc2sudGk6IGQxMDVjMDAwClsgICAgOS4wMzkx
OTZdIEVJUDogMDA2MDpbPGM1M2I2NDhkPl0gRUZMQUdTOiAwMDAxMDI0NiBDUFU6IDAKWyAg
ICA5LjA0MDcwM10gRUlQIGlzIGF0IHJhcGxfcG11X2luaXQrMHgxMTYvMHgxNzUKWyAgICA5
LjA0MTk4OF0gRUFYOiAwMDAwMDAwMCBFQlg6IDAwMDAwMDAwIEVDWDogMDAwMDAwMDAgRURY
OiAwMDAwMDAwMQpbICAgIDkuMDQzNjQ1XSBFU0k6IGM1M2I2Mzc3IEVESTogMDAwMDAwZDAg
RUJQOiBkMTA1ZGYwMCBFU1A6IGQxMDVkZWQ4ClsgICAgOS4wNDUzMDFdICBEUzogMDA3YiBF
UzogMDA3YiBGUzogMDAwMCBHUzogMDBlMCBTUzogMDA2OApbICAgIDkuMDQ2ODExXSBDUjA6
IDgwMDUwMDMzIENSMjogMDAwMDAwM2MgQ1IzOiAwNTQxYTAwMCBDUjQ6IDAwMDQwNmIwClsg
ICAgOS4wNDg0NTZdIFN0YWNrOgpbICAgIDkuMDQ5MTE0XSAgYzUzYjQzZDUgZDExNGY0OTgg
YzUyMjNjOTQgZDExMWQxYzAgYzUxNmE1Y2QgMDAwMDAwMDIgYzRlZTFiZmUgMDAwMDAwMDAK
WyAgICA5LjA1MjI3N10gIGM1M2I2Mzc3IDAwMDAwMGQwIGQxMDVkZjc0IGM0YzAwNDc3IGM0
ZTNlNDc1IDAwMDAwMDYwIDAwMDAwMjQ2IGQzZmY2M2NkClsgICAgOS4wNTU0MjddICBkMTA1
ZGYzNCBjNGM0MjBiYiBkM2ZmNjNjZCBkMTA1ZGYwMCBjNTNhZTUxMiBjNTIxMTYxMCAwMDAw
MDBkMCBkMTA1ZGY3NApbICAgIDkuMDU4NDM0XSBDYWxsIFRyYWNlOgpbICAgIDkuMDU5Mzk2
XSAgWzxjNTNiNDNkNT5dID8gY2FjaGVfc3lzZnNfaW5pdCsweDFkZC8weDFlNwpbICAgIDku
MDYwOTEwXSAgWzxjNGVlMWJmZT5dID8gcmVnaXN0ZXJfc3lzY29yZV9vcHMrMHgzMi8weDM1
ClsgICAgOS4wNjIyODddICBbPGM1M2I2Mzc3Pl0gPyBpbnRlbF91bmNvcmVfaW5pdCsweDI1
MS8weDI1MQpbICAgIDkuMDYzNzg2XSAgWzxjNGMwMDQ3Nz5dIGRvX29uZV9pbml0Y2FsbCsw
eGRmLzB4MTM4ClsgICAgOS4wNjUyMjhdICBbPGM0ZTNlNDc1Pl0gPyBzdHJsZW4rMHhmLzB4
MTkKWyAgICA5LjA2NjUxOF0gIFs8YzRjNDIwYmI+XSA/IHBhcmFtZXErMHgxMy8weDVlClsg
ICAgOS4wNjc4MjhdICBbPGM1M2FlNTEyPl0gPyByZXBhaXJfZW52X3N0cmluZysweDEyLzB4
NTEKWyAgICA5LjA2OTIyOV0gIFs8YzRjNDIyYzU+XSA/IHBhcnNlX2FyZ3MrMHgxYmYvMHgy
ZjgKWyAgICA5LjA3MDQ3Nl0gIFs8YzRjM2M2NTg+XSA/IF9fdXNlcm1vZGVoZWxwZXJfc2V0
X2Rpc2FibGVfZGVwdGgrMHgzZS8weDQ0ClsgICAgOS4wNzE1NDJdICBbPGM1M2FlYjQ2Pl0g
a2VybmVsX2luaXRfZnJlZWFibGUrMHhkZS8weDE3OApbICAgIDkuMDcyODA0XSAgWzxjNTNh
ZTUwMD5dID8gZG9fZWFybHlfcGFyYW0rMHg3OC8weDc4ClsgICAgOS4wNzQxNDVdICBbPGM1
MDUwZDIwPl0ga2VybmVsX2luaXQrMHhiLzB4ZWQKWyAgICA5LjA3NTEyM10gIFs8YzRjNGE4
ODI+XSA/IHNjaGVkdWxlX3RhaWwrMHhjLzB4M2EKWyAgICA5LjA3ODY4OV0gIFs8YzUwNWU1
Yjc+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MWIvMHgyOApbICAgIDkuMDc5OTIzXSAg
WzxjNTA1MGQxNT5dID8gcmVzdF9pbml0KzB4YjUvMHhiNQpbICAgIDkuMDgwODE1XSBDb2Rl
OiAyNCBiYSA5MyAwMiAwMCAwMCBiOCBjOCBmNyAxNiBjNSBlOCAxNCA2NiA4NyBmZiA4OSA1
YyAyNCAwNCBjNyAwNCAyNCAwYyBmOCAxNiBjNSBlOCA3NSBmNSBjOSBmZiA4MyBjOCBmZiBl
YiA1ZCA4YiAxZCA2MCBiNiAyMiBjNSA8OGI+IDQzIDNjIDhiIDUzIDQwIGU4IGMxIDhlIDg3
IGZmIDg5IGQ2IGI5IGU4IDAzIDAwIDAwIGY3IGU5IDg5ClsgICAgOS4wOTA5NTldIEVJUDog
WzxjNTNiNjQ4ZD5dIHJhcGxfcG11X2luaXQrMHgxMTYvMHgxNzUgU1M6RVNQIDAwNjg6ZDEw
NWRlZDgKWyAgICA5LjA5MjY0N10gQ1IyOiAwMDAwMDAwMDAwMDAwMDNjClsgICAgOS4wOTM2
NjRdIC0tLVsgZW5kIHRyYWNlIDZjNmY3MDZlZDA3Y2FmMzEgXS0tLQpbICAgIDkuMDk1MTQ5
XSBzd2FwcGVyICgxKSB1c2VkIGdyZWF0ZXN0IHN0YWNrIGRlcHRoOiA1Nzg0IGJ5dGVzIGxl
ZnQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzLzE1YzgxMDI2MjA0ZGE4
OTdhMDU0MjRjNzkyNjNhZWE4NjFhNzgyY2MvZG1lc2ctcXVhbnRhbC1rYnVpbGQtNDoyMDE0
MDcyNTE2MjE0OTppMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzOjMuMTMuMC0wMDc2Mi1n
MTVjODEwMjozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My8xNWM4MTAy
NjIwNGRhODk3YTA1NDI0Yzc5MjYzYWVhODYxYTc4MmNjL2RtZXNnLXF1YW50YWwta2J1aWxk
LTc6MjAxNDA3MjUxNjIxNDg6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1MzozLjEzLjAt
MDA3NjItZzE1YzgxMDI6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMv
MTVjODEwMjYyMDRkYTg5N2EwNTQyNGM3OTI2M2FlYTg2MWE3ODJjYy9kbWVzZy15b2N0by1r
YnVpbGQtNDoyMDE0MDcyNTE2MjE0NTppMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzOjMu
MTMuMC0wMDc2Mi1nMTVjODEwMjozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1
MTE1My8xNWM4MTAyNjIwNGRhODk3YTA1NDI0Yzc5MjYzYWVhODYxYTc4MmNjL2RtZXNnLXlv
Y3RvLWtidWlsZC01OjIwMTQwNzI1MTYyMTQxOmkzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTEx
NTM6My4xMy4wLTAwNzYyLWcxNWM4MTAyOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIx
LTA3MjUxMTUzLzE1YzgxMDI2MjA0ZGE4OTdhMDU0MjRjNzkyNjNhZWE4NjFhNzgyY2MvZG1l
c2cteW9jdG8ta2J1aWxkLTEyOjIwMTQwNzI1MTYyMTU4OmkzODYtcmFuZGNvbmZpZy1pYjEt
MDcyNTExNTM6My4xMy4wLTAwNzYyLWcxNWM4MTAyOjMKMjo1OjUgYWxsX2dvb2Q6YmFkOmFs
bF9iYWQgYm9vdHMKCkJpc2VjdGluZzogNzYyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0
ZXIgdGhpcyAocm91Z2hseSAxMCBzdGVwcykKW2EwZmExZGQzY2RiY2NlYzk1OTdmZTUzYjYx
NzdhOWFhNmUyMGYyZjhdIE1lcmdlIGJyYW5jaCAnc2NoZWQtY29yZS1mb3ItbGludXMnIG9m
IGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90aXAvdGlw
CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAv
Yy9ib290LWJpc2VjdC9saW51eC05L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9y
dW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvbmV4dDptYXN0ZXI6
YTBmYTFkZDNjZGJjY2VjOTU5N2ZlNTNiNjE3N2E5YWE2ZTIwZjJmODpiaXNlY3QtbGludXgt
OQoKMjAxNC0wNy0yNS0xNjoyNDowOSBhMGZhMWRkM2NkYmNjZWM5NTk3ZmU1M2I2MTc3YTlh
YTZlMjBmMmY4IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMtYTBmYTFkZDNjZGJj
Y2VjOTU5N2ZlNTNiNjE3N2E5YWE2ZTIwZjJmOApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My9hMGZhMWRkM2NkYmNjZWM5NTk3ZmU1
M2I2MTc3YTlhYTZlMjBmMmY4CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzLWEwZmExZGQz
Y2RiY2NlYzk1OTdmZTUzYjYxNzdhOWFhNmUyMGYyZjgKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2pha2V0b3duLWNvbnN1bWVyL2kzODYt
cmFuZGNvbmZpZy1pYjEtMDcyNTExNTMtYTBmYTFkZDNjZGJjY2VjOTU5N2ZlNTNiNjE3N2E5
YWE2ZTIwZjJmOAprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1
My9hMGZhMWRkM2NkYmNjZWM5NTk3ZmU1M2I2MTc3YTlhYTZlMjBmMmY4L3ZtbGludXotMy4x
My4wLTAwNTk0LWdhMGZhMWRkCgoyMDE0LTA3LTI1LTE2OjMzOjA5IGRldGVjdGluZyBib290
IHN0YXRlIC4gVEVTVCBGQUlMVVJFClsgICAgNi41MzU2NDhdIFBDSTogQ0xTIDAgYnl0ZXMs
IGRlZmF1bHQgNjQKWyAgICA2LjUzNzM2M10gVW5wYWNraW5nIGluaXRyYW1mcy4uLgpbICAg
IDcuNTczMDI5XSBGcmVlaW5nIGluaXRyZCBtZW1vcnk6IDI0ODUySyAoZDI3YWIwMDAgLSBk
M2ZmMDAwMCkKWyAgICA3LjU3NDkwMV0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBO
VUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQgMDAwMDAwM2MKWyAgICA3LjU3NjYzOF0gSVA6
IFs8YzA5YjQxZjI+XSByYXBsX3BtdV9pbml0KzB4MTE2LzB4MTc1ClsgICAgNy41NzgwMjNd
ICpwZHB0ID0gMDAwMDAwMDAwMDAwMDAwMCAqcGRlID0gZjAwMGZmNTNmMDAwZmY1MyAKWyAg
ICA3LjU3OTU2Ml0gT29wczogMDAwMCBbIzFdIFBSRUVNUFQgClsgICAgNy41ODA3NzddIE1v
ZHVsZXMgbGlua2VkIGluOgpbICAgIDcuNTgxNzg5XSBDUFU6IDAgUElEOiAxIENvbW06IHN3
YXBwZXIgTm90IHRhaW50ZWQgMy4xMy4wLTAwNTk0LWdhMGZhMWRkICMzClsgICAgNy41ODMz
ODFdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEK
WyAgICA3LjU4NDczOF0gdGFzazogZDEwNWEwMTAgdGk6IGQxMDVjMDAwIHRhc2sudGk6IGQx
MDVjMDAwClsgICAgNy41ODYwNDZdIEVJUDogMDA2MDpbPGMwOWI0MWYyPl0gRUZMQUdTOiAw
MDAxMDI0NiBDUFU6IDAKWyAgICA3LjU4NzMyOV0gRUlQIGlzIGF0IHJhcGxfcG11X2luaXQr
MHgxMTYvMHgxNzUKWyAgICA3LjU4ODQ2OF0gRUFYOiAwMDAwMDAwMCBFQlg6IDAwMDAwMDAw
IEVDWDogMDAwMDAwMDAgRURYOiAwMDAwMDAwMQpbICAgIDcuNTg5ODgzXSBFU0k6IGMwOWI0
MGRjIEVESTogMDAwMDAwZDAgRUJQOiBkMTA1ZGYwMCBFU1A6IGQxMDVkZWQ4ClsgICAgNy41
OTEzNDddICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDAwMCBHUzogMDBlMCBTUzogMDA2OApb
ICAgIDcuNTkyNjMwXSBDUjA6IDgwMDUwMDMzIENSMjogMDAwMDAwM2MgQ1IzOiAwMGExODAw
MCBDUjQ6IDAwMDQwNmIwClsgICAgNy41OTQwNTddIFN0YWNrOgpbICAgIDcuNTk0ODUyXSAg
YzA5YjIxM2EgZDExNGY0OTggYzA4MjFiOTQgZDExMWQyMDAgYzA3NjhkZjQgMDAwMDAwMDIg
YzA0ZTBkOWUgMDAwMDAwMDAKWyAgICA3LjU5NzU3OV0gIGMwOWI0MGRjIDAwMDAwMGQwIGQx
MDVkZjc0IGMwMjAwNDc3IGMwMjUzMmE2IGQxMDVkZjJjIGMwMjU1ZTBkIGQzZmY2M2NkClsg
ICAgNy42MDAzNDldICBkMTA1ZGYzNCBjMDI0MTFlYiBkM2ZmNjNjZCBkMTA1ZGYwMCBjMDlh
YzUxMiBjMDgwZmQxNCAwMDAwMDBkMCBkMTA1ZGY3NApbICAgIDcuNjAzMDkxXSBDYWxsIFRy
YWNlOgpbICAgIDcuNjAzOTQyXSAgWzxjMDliMjEzYT5dID8gY2FjaGVfc3lzZnNfaW5pdCsw
eDFkZC8weDFlNwpbICAgIDcuNjA1MjM0XSAgWzxjMDRlMGQ5ZT5dID8gcmVnaXN0ZXJfc3lz
Y29yZV9vcHMrMHgzMi8weDM1ClsgICAgNy42MDY1NDNdICBbPGMwOWI0MGRjPl0gPyBpbnRl
bF91bmNvcmVfaW5pdCsweDI1MS8weDI1MQpbICAgIDcuNjA3ODcxXSAgWzxjMDIwMDQ3Nz5d
IGRvX29uZV9pbml0Y2FsbCsweGRmLzB4MTM4ClsgICAgNy42MDkxMDhdICBbPGMwMjUzMmE2
Pl0gPyBsb2NrX3JlbGVhc2VfaG9sZHRpbWUucGFydC4yMCsweDkzLzB4ZjgKWyAgICA3LjYx
MDUwOF0gIFs8YzAyNTVlMGQ+XSA/IHRyYWNlX2hhcmRpcnFzX29uX2NhbGxlcisweGViLzB4
MWFkClsgICAgNy42MTE4NzRdICBbPGMwMjQxMWViPl0gPyBwYXJhbWVxKzB4MTMvMHg1ZQpb
ICAgIDcuNjEyOTU4XSAgWzxjMDlhYzUxMj5dID8gcmVwYWlyX2Vudl9zdHJpbmcrMHgxMi8w
eDUxClsgICAgNy42MTQxNzZdICBbPGMwMjQxM2Y1Pl0gPyBwYXJzZV9hcmdzKzB4MWJmLzB4
MmY4ClsgICAgNy42MTUzNzJdICBbPGMwMjNiNzg4Pl0gPyBfX3VzZXJtb2RlaGVscGVyX3Nl
dF9kaXNhYmxlX2RlcHRoKzB4M2UvMHg0NApbICAgIDcuNjE2Nzg2XSAgWzxjMDlhY2I0Nj5d
IGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4ZGUvMHgxNzgKWyAgICA3LjYxODAyNl0gIFs8YzA5
YWM1MDA+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4NzgvMHg3OApbICAgIDcuNjE5MjM1XSAgWzxj
MDY0ZmVmMD5dIGtlcm5lbF9pbml0KzB4Yi8weGVkClsgICAgNy42MjAzNDBdICBbPGMwMjQ5
OTYyPl0gPyBzY2hlZHVsZV90YWlsKzB4Yy8weDNhClsgICAgNy42MjQ1MzVdICBbPGMwNjVk
ODM3Pl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDFiLzB4MjgKWyAgICA3LjYyNTg0OV0g
IFs8YzA2NGZlZTU+XSA/IHJlc3RfaW5pdCsweGI1LzB4YjUKWyAgICA3LjYyNzA0Nl0gQ29k
ZTogMjQgYmEgOTMgMDIgMDAgMDAgYjggYWMgZGUgNzYgYzAgZTggYmYgNzkgODcgZmYgODkg
NWMgMjQgMDQgYzcgMDQgMjQgZjAgZGUgNzYgYzAgZTggNDAgMGEgY2EgZmYgODMgYzggZmYg
ZWIgNWQgOGIgMWQgNjAgOTUgODIgYzAgPDhiPiA0MyAzYyA4YiA1MyA0MCBlOCA2YyBhMiA4
NyBmZiA4OSBkNiBiOSBlOCAwMyAwMCAwMCBmNyBlOSA4OQpbICAgIDcuNjM2NjY4XSBFSVA6
IFs8YzA5YjQxZjI+XSByYXBsX3BtdV9pbml0KzB4MTE2LzB4MTc1IFNTOkVTUCAwMDY4OmQx
MDVkZWQ4ClsgICAgNy42MzgzMTNdIENSMjogMDAwMDAwMDAwMDAwMDAzYwpbICAgIDcuNjM5
MjU3XSAtLS1bIGVuZCB0cmFjZSA5MWZjNGM2N2U1YzkzYTkwIF0tLS0KWyAgICA3LjY0MDQz
NF0gc3dhcHBlciAoMSkgdXNlZCBncmVhdGVzdCBzdGFjayBkZXB0aDogNTg4NCBieXRlcyBs
ZWZ0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My9hMGZhMWRkM2NkYmNj
ZWM5NTk3ZmU1M2I2MTc3YTlhYTZlMjBmMmY4L2RtZXNnLXF1YW50YWwta2J1aWxkLTE3OjIw
MTQwNzI1MTYzMDQ4OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTM6My4xMy4wLTAwNTk0
LWdhMGZhMWRkOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzL2EwZmEx
ZGQzY2RiY2NlYzk1OTdmZTUzYjYxNzdhOWFhNmUyMGYyZjgvZG1lc2ctcXVhbnRhbC1rYnVp
bGQtMToyMDE0MDcyNTE2MzA0ODppMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzOjMuMTMu
MC0wMDU5NC1nYTBmYTFkZDozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1
My9hMGZhMWRkM2NkYmNjZWM5NTk3ZmU1M2I2MTc3YTlhYTZlMjBmMmY4L2RtZXNnLXF1YW50
YWwta2J1aWxkLTIxOjIwMTQwNzI1MTYzMDUwOmkzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTEx
NTM6My4xMy4wLTAwNTk0LWdhMGZhMWRkOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIx
LTA3MjUxMTUzL2EwZmExZGQzY2RiY2NlYzk1OTdmZTUzYjYxNzdhOWFhNmUyMGYyZjgvZG1l
c2ctcXVhbnRhbC1rYnVpbGQtMjg6MjAxNDA3MjUxNjMwNDY6aTM4Ni1yYW5kY29uZmlnLWli
MS0wNzI1MTE1MzozLjEzLjAtMDA1OTQtZ2EwZmExZGQ6Mwova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1pYjEtMDcyNTExNTMvYTBmYTFkZDNjZGJjY2VjOTU5N2ZlNTNiNjE3N2E5YWE2ZTIw
ZjJmOC9kbWVzZy15b2N0by1rYnVpbGQtMTI6MjAxNDA3MjUxNjMwNDU6aTM4Ni1yYW5kY29u
ZmlnLWliMS0wNzI1MTE1MzozLjEzLjAtMDA1OTQtZ2EwZmExZGQ6Mwova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvYTBmYTFkZDNjZGJjY2VjOTU5N2ZlNTNiNjE3N2E5
YWE2ZTIwZjJmOC9kbWVzZy15b2N0by1rYnVpbGQtNjoyMDE0MDcyNTE2MzA0MjppMzg2LXJh
bmRjb25maWctaWIxLTA3MjUxMTUzOjMuMTMuMC0wMDU5NC1nYTBmYTFkZDozCi9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My9hMGZhMWRkM2NkYmNjZWM5NTk3ZmU1M2I2
MTc3YTlhYTZlMjBmMmY4L2RtZXNnLXF1YW50YWwta2J1aWxkLTQ6MjAxNDA3MjUxNjMwNTU6
aTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1MzozLjEzLjAtMDA1OTQtZ2EwZmExZGQ6Mwov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvYTBmYTFkZDNjZGJjY2VjOTU5
N2ZlNTNiNjE3N2E5YWE2ZTIwZjJmOC9kbWVzZy15b2N0by1rYnVpbGQtMjU6MjAxNDA3MjUx
NjMxMDA6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1MzozLjEzLjAtMDA1OTQtZ2EwZmEx
ZGQ6Mwova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvYTBmYTFkZDNjZGJj
Y2VjOTU5N2ZlNTNiNjE3N2E5YWE2ZTIwZjJmOC9kbWVzZy1xdWFudGFsLWtidWlsZC0xNDoy
MDE0MDcyNTE2MzEwNDppMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzOjMuMTMuMC0wMDU5
NC1nYTBmYTFkZDozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My9hMGZh
MWRkM2NkYmNjZWM5NTk3ZmU1M2I2MTc3YTlhYTZlMjBmMmY4L2RtZXNnLXF1YW50YWwta2J1
aWxkLTIyOjIwMTQwNzI1MTYzMTA1OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTM6My4x
My4wLTAwNTk0LWdhMGZhMWRkOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUx
MTUzL2EwZmExZGQzY2RiY2NlYzk1OTdmZTUzYjYxNzdhOWFhNmUyMGYyZjgvZG1lc2cteW9j
dG8ta2J1aWxkLTI4OjIwMTQwNzI1MTYzMTAxOmkzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTEx
NTM6My4xMy4wLTAwNTk0LWdhMGZhMWRkOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIx
LTA3MjUxMTUzL2EwZmExZGQzY2RiY2NlYzk1OTdmZTUzYjYxNzdhOWFhNmUyMGYyZjgvZG1l
c2cteW9jdG8ta2J1aWxkLTI4OjIwMTQwNzI1MTYzMTEzOmkzODYtcmFuZGNvbmZpZy1pYjEt
MDcyNTExNTM6My4xMy4wLTAwNTk0LWdhMGZhMWRkOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaWIxLTA3MjUxMTUzL2EwZmExZGQzY2RiY2NlYzk1OTdmZTUzYjYxNzdhOWFhNmUyMGYy
ZjgvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMjQ6MjAxNDA3MjUxNjMxMTY6aTM4Ni1yYW5kY29u
ZmlnLWliMS0wNzI1MTE1MzozLjEzLjAtMDA1OTQtZ2EwZmExZGQ6Mwova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvYTBmYTFkZDNjZGJjY2VjOTU5N2ZlNTNiNjE3N2E5
YWE2ZTIwZjJmOC9kbWVzZy1xdWFudGFsLWtidWlsZC0yODoyMDE0MDcyNTE2MzExODppMzg2
LXJhbmRjb25maWctaWIxLTA3MjUxMTUzOjMuMTMuMC0wMDU5NC1nYTBmYTFkZDozCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My9hMGZhMWRkM2NkYmNjZWM5NTk3ZmU1
M2I2MTc3YTlhYTZlMjBmMmY4L2RtZXNnLXF1YW50YWwta2J1aWxkLTE6MjAxNDA3MjUxNjMx
MjU6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1MzozLjEzLjAtMDA1OTQtZ2EwZmExZGQ6
MwowOjE1OjE1IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDU5NCBy
ZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTAgc3RlcHMpCltl
ZGRlMWZiOGM0MWQwZGI3YzhjZTE3ZmIzMjg4NmRhMmUzODliMGNjXSBNZXJnZSB0YWcgJ2xv
Y2FsbW9kY29uZmlnLXYzLjE0JyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xp
bnV4L2tlcm5lbC9naXQvcm9zdGVkdC9saW51eC1rY29uZmlnCnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51
eC05L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYt
cmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvbmV4dDptYXN0ZXI6ZWRkZTFmYjhjNDFkMGRiN2M4
Y2UxN2ZiMzI4ODZkYTJlMzg5YjBjYzpiaXNlY3QtbGludXgtOQoKMjAxNC0wNy0yNS0xNjoz
Mzo0MSBlZGRlMWZiOGM0MWQwZGI3YzhjZTE3ZmIzMjg4NmRhMmUzODliMGNjIGNvbXBpbGlu
ZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYt
cmFuZGNvbmZpZy1pYjEtMDcyNTExNTMtZWRkZTFmYjhjNDFkMGRiN2M4Y2UxN2ZiMzI4ODZk
YTJlMzg5YjBjYwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWliMS0wNzI1MTE1My9lZGRlMWZiOGM0MWQwZGI3YzhjZTE3ZmIzMjg4NmRhMmUzODliMGNj
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9p
Mzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzLWVkZGUxZmI4YzQxZDBkYjdjOGNlMTdmYjMy
ODg2ZGEyZTM4OWIwY2MKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL2xrcC1oc3gwMS1jb25zdW1lci9pMzg2LXJhbmRjb25maWctaWIxLTA3
MjUxMTUzLWVkZGUxZmI4YzQxZDBkYjdjOGNlMTdmYjMyODg2ZGEyZTM4OWIwY2MKa2VybmVs
OiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvZWRkZTFmYjhjNDFkMGRi
N2M4Y2UxN2ZiMzI4ODZkYTJlMzg5YjBjYy92bWxpbnV6LTMuMTMuMC0wMDEyNS1nZWRkZTFm
YgoKMjAxNC0wNy0yNS0xNjozNjo0MiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4JMgk1Lgkx
MQkxNC4JMjcJMzIuLgkzNgk0Mgk0Ngk1MAk1Mi4JNjAJNzEJNzQJNzkJODIJODkuCTkzCTk2
LgkxMDIJMTA0Li4uCTEwNQkxMTEJMTE3Li4uLgkxMTgJMTIwCTEyMgkxMjUuLgkxMzMuCTEz
NAkxMzYJMTM3CTE0Mi4JMTQzCTE0NAkxNDkJMTUyCTE1NS4JMTU2Li4JMTU5Li4uCTE2My4u
LgkxNjUJMTcwCTE3Mi4JMTczLi4uCTE3NAkxNzUuCTE3NwkxODIJMTgzLgkxODUuCTE4OQkx
OTEJMTk5CTIwMi4JMjA1CTIwNgkyMDcJMjA4CTIxNAkyMjIJMjI4CTIzMgkyMzUJMjU0CTI2
MAkyNjEJMjY1CTI3MwkyNzUJMjg2CTI5NgkzMDQJMzA3Li4JMzI0CTMyNwkzMjgJMzU5CTM3
Mwk0MDMJNDExCTQzOQk0NDQJNDY4CTQ3OAk1MTIJNTI2CTU0MQk1NzUJNTk5CTYwMAk2MjUJ
NjU1CTY2Ngk2NzAJNzIwCTczNwk3NDEJNzUwCTgwMQk4MjMJODM2CTg4MQk5MDAgU1VDQ0VT
UwoKQmlzZWN0aW5nOiA0NjkgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChy
b3VnaGx5IDkgc3RlcHMpClthNjkzYzQ2ZTE0YzlmZGFkYmNkNjhkZGZhOTRhNGY3MjQ5NTUz
MWE5XSBNZXJnZSBicmFuY2ggJ2NvcmUtcmN1LWZvci1saW51cycgb2YgZ2l0Oi8vZ2l0Lmtl
cm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RpcC90aXAKcnVubmluZyAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0
L2xpbnV4LTkvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
aTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My9uZXh0Om1hc3RlcjphNjkzYzQ2ZTE0Yzlm
ZGFkYmNkNjhkZGZhOTRhNGY3MjQ5NTUzMWE5OmJpc2VjdC1saW51eC05CgoyMDE0LTA3LTI1
LTE3OjQ4OjQ5IGE2OTNjNDZlMTRjOWZkYWRiY2Q2OGRkZmE5NGE0ZjcyNDk1NTMxYTkgY29t
cGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUv
aTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My1hNjkzYzQ2ZTE0YzlmZGFkYmNkNjhkZGZh
OTRhNGY3MjQ5NTUzMWE5CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctaWIxLTA3MjUxMTUzL2E2OTNjNDZlMTRjOWZkYWRiY2Q2OGRkZmE5NGE0ZjcyNDk1
NTMxYTkKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMtYTY5M2M0NmUxNGM5ZmRhZGJjZDY4
ZGRmYTk0YTRmNzI0OTU1MzFhOQprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWli
MS0wNzI1MTE1My9hNjkzYzQ2ZTE0YzlmZGFkYmNkNjhkZGZhOTRhNGY3MjQ5NTUzMWE5L3Zt
bGludXotMy4xMy4wLTAwMjI4LWdhNjkzYzQ2CgoyMDE0LTA3LTI1LTE3OjUwOjQ5IGRldGVj
dGluZyBib290IHN0YXRlIC4JNzkJMjk4CTM3NQk0NDIJNTQzCTcxNwk3NDkJODU2CTkwMCBT
VUNDRVNTCgpCaXNlY3Rpbmc6IDM2NiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgOSBzdGVwcykKWzJjYzNmMTZjYWQxNTYxYzZmYzU1MWFlZmZmNTU5ZTUz
NzI2ZWZjOGJdIE1lcmdlIGJyYW5jaCAnaXJxLWNvcmUtZm9yLWxpbnVzJyBvZiBnaXQ6Ly9n
aXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGlwL3RpcApydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1i
aXNlY3QvbGludXgtOS9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzL25leHQ6bWFzdGVyOjJjYzNmMTZj
YWQxNTYxYzZmYzU1MWFlZmZmNTU5ZTUzNzI2ZWZjOGI6YmlzZWN0LWxpbnV4LTkKCjIwMTQt
MDctMjUtMTc6NTU6NTAgMmNjM2YxNmNhZDE1NjFjNmZjNTUxYWVmZmY1NTllNTM3MjZlZmM4
YiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzLTJjYzNmMTZjYWQxNTYxYzZmYzU1
MWFlZmZmNTU5ZTUzNzI2ZWZjOGIKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYt
cmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvMmNjM2YxNmNhZDE1NjFjNmZjNTUxYWVmZmY1NTll
NTM3MjZlZmM4Ygp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVp
bGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My0yY2MzZjE2Y2FkMTU2MWM2
ZmM1NTFhZWZmZjU1OWU1MzcyNmVmYzhiCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaWIxLTA3MjUxMTUzLzJjYzNmMTZjYWQxNTYxYzZmYzU1MWFlZmZmNTU5ZTUzNzI2ZWZj
OGIvdm1saW51ei0zLjEzLjAtMDAyMzQtZzJjYzNmMTYKCjIwMTQtMDctMjUtMTc6NTc6NTAg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTEyNAkxNTQuCTE1OQkyNTcJMjcyCTI3OAkyOTYJMzAw
CTM4MQkzOTMJNDA1CTQ1NQk1MDEJNTE0Lgk1NTIJNjIxLgk2MzQJNjUxCTc0MC4JNzc0CTg0
Mgk4NTgJODY1CTg5Ngk5MDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAzNjAgcmV2aXNpb25zIGxl
ZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDkgc3RlcHMpCls5MzI2NjU3YWJlMWE4
M2VkNGI0ZjM5NmI5MjNjYTEyMTdmZDUwY2JhXSBNZXJnZSBicmFuY2ggJ3BlcmYtY29yZS1m
b3ItbGludXMnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVs
L2dpdC90aXAvdGlwCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC05L29iai1iaXNlY3QKbHMgLWEgL2ti
dWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMv
bmV4dDptYXN0ZXI6OTMyNjY1N2FiZTFhODNlZDRiNGYzOTZiOTIzY2ExMjE3ZmQ1MGNiYTpi
aXNlY3QtbGludXgtOQoKMjAxNC0wNy0yNS0xODoxMjoyMSA5MzI2NjU3YWJlMWE4M2VkNGI0
ZjM5NmI5MjNjYTEyMTdmZDUwY2JhIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMt
OTMyNjY1N2FiZTFhODNlZDRiNGYzOTZiOTIzY2ExMjE3ZmQ1MGNiYQpDaGVjayBmb3Iga2Vy
bmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My85MzI2NjU3YWJl
MWE4M2VkNGI0ZjM5NmI5MjNjYTEyMTdmZDUwY2JhCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUx
MTUzLTkzMjY2NTdhYmUxYTgzZWQ0YjRmMzk2YjkyM2NhMTIxN2ZkNTBjYmEKd2FpdGluZyBm
b3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2pha2V0b3duLWNv
bnN1bWVyL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMtOTMyNjY1N2FiZTFhODNlZDRi
NGYzOTZiOTIzY2ExMjE3ZmQ1MGNiYQprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWliMS0wNzI1MTE1My85MzI2NjU3YWJlMWE4M2VkNGI0ZjM5NmI5MjNjYTEyMTdmZDUwY2Jh
L3ZtbGludXotMy4xMy4wLTAwNTMwLWc5MzI2NjU3CgoyMDE0LTA3LTI1LTE4OjE3OjIxIGRl
dGVjdGluZyBib290IHN0YXRlIC4uLi4uCTMJNAk5IFRFU1QgRkFJTFVSRQpbICAgIDAuNjEz
NDY1XSBQQ0k6IENMUyAwIGJ5dGVzLCBkZWZhdWx0IDY0ClsgICAgMC42MTQ3NDNdIFVucGFj
a2luZyBpbml0cmFtZnMuLi4KWyAgICAxLjUwOTM1OV0gRnJlZWluZyBpbml0cmQgbWVtb3J5
OiAyNDg1MksgKGQyN2FiMDAwIC0gZDNmZjAwMDApClsgICAgMS41MTA1NjFdIEJVRzogdW5h
YmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0IDAwMDAw
MDNjClsgICAgMS41MTE2OTddIElQOiBbPGMwOWIyMGM0Pl0gcmFwbF9wbXVfaW5pdCsweDEx
Ni8weDE3NQpbICAgIDEuNTEyMDExXSAqcGRwdCA9IDAwMDAwMDAwMDAwMDAwMDAgKnBkZSA9
IGYwMDBmZjUzZjAwMGZmNTMgClsgICAgMS41MTIwMTFdIE9vcHM6IDAwMDAgWyMxXSBQUkVF
TVBUIApbICAgIDEuNTEyMDExXSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAxLjUxMjAxMV0g
Q1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTMuMC0wMDUzMC1n
OTMyNjY1NyAjNApbICAgIDEuNTEyMDExXSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2Nocywg
QklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgMS41MTIwMTFdIHRhc2s6IGQxMDVhMDEwIHRp
OiBkMTA1YzAwMCB0YXNrLnRpOiBkMTA1YzAwMApbICAgIDEuNTEyMDExXSBFSVA6IDAwNjA6
WzxjMDliMjBjND5dIEVGTEFHUzogMDAwMTAyNDYgQ1BVOiAwClsgICAgMS41MTIwMTFdIEVJ
UCBpcyBhdCByYXBsX3BtdV9pbml0KzB4MTE2LzB4MTc1ClsgICAgMS41MTIwMTFdIEVBWDog
MDAwMDAwMDAgRUJYOiAwMDAwMDAwMCBFQ1g6IDAwMDAwMDAwIEVEWDogMDAwMDAwMDEKWyAg
ICAxLjUxMjAxMV0gRVNJOiBjMDliMWZhZSBFREk6IDAwMDAwMGQwIEVCUDogZDEwNWRmMDAg
RVNQOiBkMTA1ZGVkOApbICAgIDEuNTEyMDExXSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAw
MDAgR1M6IDAwZTAgU1M6IDAwNjgKWyAgICAxLjUxMjAxMV0gQ1IwOiA4MDA1MDAzMyBDUjI6
IDAwMDAwMDNjIENSMzogMDBhMTYwMDAgQ1I0OiAwMDA0MDZiMApbICAgIDEuNTEyMDExXSBT
dGFjazoKWyAgICAxLjUxMjAxMV0gIGMwOWIwMDBjIGQxMTRmNDk4IGMwODFmYjE0IGQxMTFk
MjAwIGMwNzY2YTk4IDAwMDAwMDAyIGMwNGRmYWVlIDAwMDAwMDAwClsgICAgMS41MTIwMTFd
ICBjMDliMWZhZSAwMDAwMDBkMCBkMTA1ZGY3NCBjMDIwMDQ3NyBjMDI1MWQyNiBkMTA1ZGYy
YyBjMDI1NDg4ZCBkM2ZmNjNjZApbICAgIDEuNTEyMDExXSAgZDEwNWRmMzQgYzAyNDExZmIg
ZDNmZjYzY2QgZDEwNWRmMDAgYzA5YWE1MTIgYzA4MGQ5NGMgMDAwMDAwZDAgZDEwNWRmNzQK
WyAgICAxLjUxMjAxMV0gQ2FsbCBUcmFjZToKWyAgICAxLjUxMjAxMV0gIFs8YzA5YjAwMGM+
XSA/IGNhY2hlX3N5c2ZzX2luaXQrMHgxZGQvMHgxZTcKWyAgICAxLjUxMjAxMV0gIFs8YzA0
ZGZhZWU+XSA/IHJlZ2lzdGVyX3N5c2NvcmVfb3BzKzB4MzIvMHgzNQpbICAgIDEuNTEyMDEx
XSAgWzxjMDliMWZhZT5dID8gaW50ZWxfdW5jb3JlX2luaXQrMHgyNTEvMHgyNTEKWyAgICAx
LjUxMjAxMV0gIFs8YzAyMDA0Nzc+XSBkb19vbmVfaW5pdGNhbGwrMHhkZi8weDEzOApbICAg
IDEuNTEyMDExXSAgWzxjMDI1MWQyNj5dID8gbG9ja19yZWxlYXNlX2hvbGR0aW1lLnBhcnQu
MjArMHg5My8weGY4ClsgICAgMS41MTIwMTFdICBbPGMwMjU0ODhkPl0gPyB0cmFjZV9oYXJk
aXJxc19vbl9jYWxsZXIrMHhlYi8weDFhZApbICAgIDEuNTEyMDExXSAgWzxjMDI0MTFmYj5d
ID8gcGFyYW1lcSsweDEzLzB4NWUKWyAgICAxLjUxMjAxMV0gIFs8YzA5YWE1MTI+XSA/IHJl
cGFpcl9lbnZfc3RyaW5nKzB4MTIvMHg1MQpbICAgIDEuNTEyMDExXSAgWzxjMDI0MTQwNT5d
ID8gcGFyc2VfYXJncysweDFiZi8weDJmOApbICAgIDEuNTEyMDExXSAgWzxjMDIzYjc5OD5d
ID8gX191c2VybW9kZWhlbHBlcl9zZXRfZGlzYWJsZV9kZXB0aCsweDNlLzB4NDQKWyAgICAx
LjUxMjAxMV0gIFs8YzA5YWFiNDY+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweGRlLzB4MTc4
ClsgICAgMS41MTIwMTFdICBbPGMwOWFhNTAwPl0gPyBkb19lYXJseV9wYXJhbSsweDc4LzB4
NzgKWyAgICAxLjUxMjAxMV0gIFs8YzA2NGU2ODA+XSBrZXJuZWxfaW5pdCsweGIvMHhlZApb
ICAgIDEuNTEyMDExXSAgWzxjMDI0OTJjOT5dID8gc2NoZWR1bGVfdGFpbCsweGMvMHgzYQpb
ICAgIDEuNTEyMDExXSAgWzxjMDY1YmZiNz5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgx
Yi8weDI4ClsgICAgMS41MTIwMTFdICBbPGMwNjRlNjc1Pl0gPyByZXN0X2luaXQrMHhiNS8w
eGI1ClsgICAgMS41MTIwMTFdIENvZGU6IDI0IGJhIDkzIDAyIDAwIDAwIGI4IDUwIGJiIDc2
IGMwIGU4IDFkIDlhIDg3IGZmIDg5IDVjIDI0IDA0IGM3IDA0IDI0IDk0IGJiIDc2IGMwIGU4
IDU3IDEzIGNhIGZmIDgzIGM4IGZmIGViIDVkIDhiIDFkIGUwIDc0IDgyIGMwIDw4Yj4gNDMg
M2MgOGIgNTMgNDAgZTggY2EgYzIgODcgZmYgODkgZDYgYjkgZTggMDMgMDAgMDAgZjcgZTkg
ODkKWyAgICAxLjUxMjAxMV0gRUlQOiBbPGMwOWIyMGM0Pl0gcmFwbF9wbXVfaW5pdCsweDEx
Ni8weDE3NSBTUzpFU1AgMDA2ODpkMTA1ZGVkOApbICAgIDEuNTEyMDExXSBDUjI6IDAwMDAw
MDAwMDAwMDAwM2MKWyAgICAxLjUxMjAxMV0gLS0tWyBlbmQgdHJhY2UgMWMzNTVkNWNiM2M5
YzY2NiBdLS0tClsgICAgMS41MTIwMTFdIHN3YXBwZXIgKDEpIHVzZWQgZ3JlYXRlc3Qgc3Rh
Y2sgZGVwdGg6IDU2MzIgYnl0ZXMgbGVmdAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEt
MDcyNTExNTMvOTMyNjY1N2FiZTFhODNlZDRiNGYzOTZiOTIzY2ExMjE3ZmQ1MGNiYS9kbWVz
Zy1xdWFudGFsLWtidWlsZC0yNzoyMDE0MDcyNTE4MTkxNDppMzg2LXJhbmRjb25maWctaWIx
LTA3MjUxMTUzOjMuMTMuMC0wMDUzMC1nOTMyNjY1Nzo0Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWliMS0wNzI1MTE1My85MzI2NjU3YWJlMWE4M2VkNGI0ZjM5NmI5MjNjYTEyMTdmZDUw
Y2JhL2RtZXNnLXF1YW50YWwta2J1aWxkLTU6MjAxNDA3MjUxODE5MTI6aTM4Ni1yYW5kY29u
ZmlnLWliMS0wNzI1MTE1MzozLjEzLjAtMDA1MzAtZzkzMjY2NTc6NAo5OjI6MiBhbGxfZ29v
ZDpiYWQ6YWxsX2JhZCBib290cwoKbGluZWFyLWJpc2VjdDogYmFkIGJyYW5jaCBtYXkgYmUg
YnJhbmNoICdwZXJmLWNvcmUtZm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9w
dWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGlwL3RpcApsaW5lYXItYmlzZWN0OiBoYW5kbGUg
b3ZlciB0byBnaXQgYmlzZWN0CmxpbmVhci1iaXNlY3Q6IGdpdCBiaXNlY3Qgc3RhcnQgOTMy
NjY1N2FiZTFhODNlZDRiNGYzOTZiOTIzY2ExMjE3ZmQ1MGNiYSAyY2MzZjE2Y2FkMTU2MWM2
ZmM1NTFhZWZmZjU1OWU1MzcyNmVmYzhiIC0tClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2Fz
IDkzMjY2NTcuLi4gTWVyZ2UgYnJhbmNoICdwZXJmLWNvcmUtZm9yLWxpbnVzJyBvZiBnaXQ6
Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGlwL3RpcApIRUFE
IGlzIG5vdyBhdCBiNGQzMzE4Li4uIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ2Ny
eXB0by9tYXN0ZXInCkJpc2VjdGluZzogMTQ3IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0
ZXIgdGhpcyAocm91Z2hseSA3IHN0ZXBzKQpbN2JiNzM1NTNlMjQ5MGFjNjY2NzM4N2VlNzIz
ZTBmYWE2MWU5ZDk5OV0gdG9vbHMgbGliIHRyYWNlZXZlbnQ6IEdldCByaWQgb2YgZGllKCkg
aW4gcmVwYXJlbnRfb3BfYXJnKCkKbGluZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBydW4gL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2Vj
dC9saW51eC05L29iai1iaXNlY3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTkvb2JqLWJpc2VjdAps
cyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWliMS0w
NzI1MTE1My9uZXh0Om1hc3Rlcjo3YmI3MzU1M2UyNDkwYWM2NjY3Mzg3ZWU3MjNlMGZhYTYx
ZTlkOTk5OmJpc2VjdC1saW51eC05CgoyMDE0LTA3LTI1LTE4OjI4OjEwIDdiYjczNTUzZTI0
OTBhYzY2NjczODdlZTcyM2UwZmFhNjFlOWQ5OTkgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0
YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWliMS0w
NzI1MTE1My03YmI3MzU1M2UyNDkwYWM2NjY3Mzg3ZWU3MjNlMGZhYTYxZTlkOTk5CkNoZWNr
IGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzLzdi
YjczNTUzZTI0OTBhYzY2NjczODdlZTcyM2UwZmFhNjFlOWQ5OTkKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1p
YjEtMDcyNTExNTMtN2JiNzM1NTNlMjQ5MGFjNjY2NzM4N2VlNzIzZTBmYWE2MWU5ZDk5OQp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtw
LWhzeDAxLWNvbnN1bWVyL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMtN2JiNzM1NTNl
MjQ5MGFjNjY2NzM4N2VlNzIzZTBmYWE2MWU5ZDk5OQprZXJuZWw6IC9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWliMS0wNzI1MTE1My83YmI3MzU1M2UyNDkwYWM2NjY3Mzg3ZWU3MjNlMGZh
YTYxZTlkOTk5L3ZtbGludXotMy4xMi4wLTA1ODUwLWc3YmI3MzU1CgoyMDE0LTA3LTI1LTE4
OjM4OjEwIGRldGVjdGluZyBib290IHN0YXRlIC4gVEVTVCBGQUlMVVJFClsgICAgMC40ODA5
NzBdIFBDSTogQ0xTIDAgYnl0ZXMsIGRlZmF1bHQgNjQKWyAgICAwLjQ4MTk5Nl0gVW5wYWNr
aW5nIGluaXRyYW1mcy4uLgpbICAgIDEuMjc5NTQ3XSBGcmVlaW5nIGluaXRyZCBtZW1vcnk6
IDI0ODUySyAoZDI3YWIwMDAgLSBkM2ZmMDAwMCkKWyAgICAxLjI4MTMyMF0gQlVHOiB1bmFi
bGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQgMDAwMDAw
M2MKWyAgICAxLjI4MjgwMV0gSVA6IFs8YzA5YjIwYzA+XSByYXBsX3BtdV9pbml0KzB4MTEz
LzB4MTcyClsgICAgMS4yODM2NzhdICpwZHB0ID0gMDAwMDAwMDAwMDAwMDAwMCAqcGRlID0g
ZjAwMGZmNTNmMDAwZmY1MyAKWyAgICAxLjI4NDcxMF0gT29wczogMDAwMCBbIzFdIFBSRUVN
UFQgClsgICAgMS4yODQ4OTNdIE1vZHVsZXMgbGlua2VkIGluOgpbICAgIDEuMjg0ODkzXSBD
UFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xMi4wLTA1ODUwLWc3
YmI3MzU1ICM3ClsgICAgMS4yODQ4OTNdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBC
SU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAxLjI4NDg5M10gdGFzazogZDEwNWEwMjAgdGk6
IGQxMDVjMDAwIHRhc2sudGk6IGQxMDVjMDAwClsgICAgMS4yODQ4OTNdIEVJUDogMDA2MDpb
PGMwOWIyMGMwPl0gRUZMQUdTOiAwMDAxMDI0NiBDUFU6IDAKWyAgICAxLjI4NDg5M10gRUlQ
IGlzIGF0IHJhcGxfcG11X2luaXQrMHgxMTMvMHgxNzIKWyAgICAxLjI4NDg5M10gRUFYOiAw
MDAwMDAwMCBFQlg6IDAwMDAwMDAwIEVDWDogMDAwMDAwMDAgRURYOiAwMDAwMDAwMQpbICAg
IDEuMjg0ODkzXSBFU0k6IGMwOWIxZmFkIEVESTogMDAwMDAwY2MgRUJQOiBkMTA1ZGYwMCBF
U1A6IGQxMDVkZWQ4ClsgICAgMS4yODQ4OTNdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDAw
MCBHUzogMDBlMCBTUzogMDA2OApbICAgIDEuMjg0ODkzXSBDUjA6IDgwMDUwMDMzIENSMjog
MDAwMDAwM2MgQ1IzOiAwMGExNjAwMCBDUjQ6IDAwMDQwNmIwClsgICAgMS4yODQ4OTNdIFN0
YWNrOgpbICAgIDEuMjg0ODkzXSAgYzA5YjAwMGMgZDExNGQ0OTggYzA4MWZhOTQgZDExNGVj
MDAgYzA3NjZlYzggMDAwMDAwMDIgYzA0ZGRiMWUgMDAwMDAwMDAKWyAgICAxLjI4NDg5M10g
IGMwOWIxZmFkIDAwMDAwMGNjIGQxMDVkZjc0IGMwMjAwNDc3IGMwMjUxYjc2IGQxMDVkZjJj
IGMwMjU0NmRkIGQzZmY2M2NiClsgICAgMS4yODQ4OTNdICBkMTA1ZGYzNCBjMDI0MTEyYiBk
M2ZmNjNjYiBkMTA1ZGYwMCBjMDlhYTUxMiBjMDgwZDczNCAwMDAwMDBjYyBkMTA1ZGY3NApb
ICAgIDEuMjg0ODkzXSBDYWxsIFRyYWNlOgpbICAgIDEuMjg0ODkzXSAgWzxjMDliMDAwYz5d
ID8gY2FjaGVfc3lzZnNfaW5pdCsweDFkZC8weDFlNwpbICAgIDEuMjg0ODkzXSAgWzxjMDRk
ZGIxZT5dID8gcmVnaXN0ZXJfc3lzY29yZV9vcHMrMHgzMi8weDM1ClsgICAgMS4yODQ4OTNd
ICBbPGMwOWIxZmFkPl0gPyBpbnRlbF91bmNvcmVfaW5pdCsweDI1MS8weDI1MQpbICAgIDEu
Mjg0ODkzXSAgWzxjMDIwMDQ3Nz5dIGRvX29uZV9pbml0Y2FsbCsweGRmLzB4MTM4ClsgICAg
MS4yODQ4OTNdICBbPGMwMjUxYjc2Pl0gPyBsb2NrX3JlbGVhc2VfaG9sZHRpbWUucGFydC4y
MCsweDkzLzB4ZjgKWyAgICAxLjI4NDg5M10gIFs8YzAyNTQ2ZGQ+XSA/IHRyYWNlX2hhcmRp
cnFzX29uX2NhbGxlcisweGViLzB4MWFkClsgICAgMS4yODQ4OTNdICBbPGMwMjQxMTJiPl0g
PyBwYXJhbWVxKzB4MTMvMHg1ZQpbICAgIDEuMjg0ODkzXSAgWzxjMDlhYTUxMj5dID8gcmVw
YWlyX2Vudl9zdHJpbmcrMHgxMi8weDUxClsgICAgMS4yODQ4OTNdICBbPGMwMjQxMzM1Pl0g
PyBwYXJzZV9hcmdzKzB4MWJmLzB4MmY4ClsgICAgMS4yODQ4OTNdICBbPGMwMjNiNzM4Pl0g
PyBfX3VzZXJtb2RlaGVscGVyX3NldF9kaXNhYmxlX2RlcHRoKzB4M2UvMHg0NApbICAgIDEu
Mjg0ODkzXSAgWzxjMDlhYWI0Nj5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4ZGUvMHgxNzgK
WyAgICAxLjI4NDg5M10gIFs8YzA5YWE1MDA+XSA/IGRvX2Vhcmx5X3BhcmFtKzB4NzgvMHg3
OApbICAgIDEuMjg0ODkzXSAgWzxjMDY0YmQ3MD5dIGtlcm5lbF9pbml0KzB4Yi8weGVkClsg
ICAgMS4yODQ4OTNdICBbPGMwMjQ5MWY5Pl0gPyBzY2hlZHVsZV90YWlsKzB4Yy8weDNhClsg
ICAgMS4yODQ4OTNdICBbPGMwNjU5NmI3Pl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDFi
LzB4MjgKWyAgICAxLjI4NDg5M10gIFs8YzA2NGJkNjU+XSA/IHJlc3RfaW5pdCsweGI1LzB4
YjUKWyAgICAxLjI4NDg5M10gQ29kZTogMjQgYmEgODEgMDIgMDAgMDAgYjggNGMgYmYgNzYg
YzAgZTggZTEgOTkgODcgZmYgODkgNWMgMjQgMDQgYzcgMDQgMjQgOTAgYmYgNzYgYzAgZTgg
M2IgZWEgYzkgZmYgODMgYzggZmYgZWIgNWQgOGIgMWQgODAgNzMgODIgYzAgPDhiPiA0MyAz
YyA4YiA1MyA0MCBlOCA4ZSBjMiA4NyBmZiA4OSBkNiBiOSBlOCAwMyAwMCAwMCBmNyBlOSA4
OQpbICAgIDEuMjg0ODkzXSBFSVA6IFs8YzA5YjIwYzA+XSByYXBsX3BtdV9pbml0KzB4MTEz
LzB4MTcyIFNTOkVTUCAwMDY4OmQxMDVkZWQ4ClsgICAgMS4yODQ4OTNdIENSMjogMDAwMDAw
MDAwMDAwMDAzYwpbICAgIDEuMjg0ODkzXSAtLS1bIGVuZCB0cmFjZSAyYmQ0YWRlMGNhZmI3
OTU1IF0tLS0KWyAgICAxLjI4NDg5M10gc3dhcHBlciAoMSkgdXNlZCBncmVhdGVzdCBzdGFj
ayBkZXB0aDogNTgwMCBieXRlcyBsZWZ0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0w
NzI1MTE1My83YmI3MzU1M2UyNDkwYWM2NjY3Mzg3ZWU3MjNlMGZhYTYxZTlkOTk5L2RtZXNn
LXF1YW50YWwta2J1aWxkLTM6MjAxNDA3MjUxODM1NDM6aTM4Ni1yYW5kY29uZmlnLWliMS0w
NzI1MTE1MzozLjEyLjAtMDU4NTAtZzdiYjczNTU6NwowOjE6MSBhbGxfZ29vZDpiYWQ6YWxs
X2JhZCBib290cwoKQmlzZWN0aW5nOiA3MyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgNiBzdGVwcykKWzNkN2MwMTQ0NDkxYmQ4YzIxZDUzYjQzMDMyMjc0
YTg1ZWZkZmU0MzRdIHBlcmYgdG9vbHM6IEFkZCBidWlsZCBhbmQgaW5zdGFsbCBwbHVnaW5z
IHRhcmdldHMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTkvb2JqLWJpc2VjdApscyAtYSAva2J1aWxk
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My9uZXh0
Om1hc3RlcjozZDdjMDE0NDQ5MWJkOGMyMWQ1M2I0MzAzMjI3NGE4NWVmZGZlNDM0OmJpc2Vj
dC1saW51eC05CgoyMDE0LTA3LTI1LTE4OjM4OjQyIDNkN2MwMTQ0NDkxYmQ4YzIxZDUzYjQz
MDMyMjc0YTg1ZWZkZmU0MzQgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVp
bGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My0zZDdj
MDE0NDQ5MWJkOGMyMWQ1M2I0MzAzMjI3NGE4NWVmZGZlNDM0CkNoZWNrIGZvciBrZXJuZWwg
aW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzLzNkN2MwMTQ0NDkxYmQ4
YzIxZDUzYjQzMDMyMjc0YTg1ZWZkZmU0MzQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMt
M2Q3YzAxNDQ0OTFiZDhjMjFkNTNiNDMwMzIyNzRhODVlZmRmZTQzNAprZXJuZWw6IC9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My8zZDdjMDE0NDQ5MWJkOGMyMWQ1M2I0
MzAzMjI3NGE4NWVmZGZlNDM0L3ZtbGludXotMy4xMi4wLTA1Nzc2LWczZDdjMDE0CgoyMDE0
LTA3LTI1LTE4OjQwOjQyIGRldGVjdGluZyBib290IHN0YXRlIAkxMSBURVNUIEZBSUxVUkUK
WyAgICAwLjU2MTU4NF0gUENJOiBDTFMgMCBieXRlcywgZGVmYXVsdCA2NApbICAgIDAuNTYy
NjI1XSBVbnBhY2tpbmcgaW5pdHJhbWZzLi4uClsgICAgMS41MzQxNzZdIEZyZWVpbmcgaW5p
dHJkIG1lbW9yeTogMjQ4NTJLIChkMjdhYjAwMCAtIGQzZmYwMDAwKQpbICAgIDEuNTM2MjA1
XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5j
ZSBhdCAwMDAwMDAzYwpbICAgIDEuNTM4MjEyXSBJUDogWzxjMDliMjBjMD5dIHJhcGxfcG11
X2luaXQrMHgxMTMvMHgxNzIKWyAgICAxLjUzOTc1OV0gKnBkcHQgPSAwMDAwMDAwMDAwMDAw
MDAwICpwZGUgPSBmMDAwZmY1M2YwMDBmZjUzIApbICAgIDEuNTQwMDI4XSBPb3BzOiAwMDAw
IFsjMV0gUFJFRU1QVCAKWyAgICAxLjU0MDAyOF0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAg
MS41NDAwMjhdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjEy
LjAtMDU3NzYtZzNkN2MwMTQgIzgKWyAgICAxLjU0MDAyOF0gSGFyZHdhcmUgbmFtZTogQm9j
aHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDEuNTQwMDI4XSB0YXNrOiBk
MTA1YTAyMCB0aTogZDEwNWMwMDAgdGFzay50aTogZDEwNWMwMDAKWyAgICAxLjU0MDAyOF0g
RUlQOiAwMDYwOls8YzA5YjIwYzA+XSBFRkxBR1M6IDAwMDEwMjQ2IENQVTogMApbICAgIDEu
NTQwMDI4XSBFSVAgaXMgYXQgcmFwbF9wbXVfaW5pdCsweDExMy8weDE3MgpbICAgIDEuNTQw
MDI4XSBFQVg6IDAwMDAwMDAwIEVCWDogMDAwMDAwMDAgRUNYOiAwMDAwMDAwMCBFRFg6IDAw
MDAwMDAxClsgICAgMS41NDAwMjhdIEVTSTogYzA5YjFmYWQgRURJOiAwMDAwMDBjYyBFQlA6
IGQxMDVkZjAwIEVTUDogZDEwNWRlZDgKWyAgICAxLjU0MDAyOF0gIERTOiAwMDdiIEVTOiAw
MDdiIEZTOiAwMDAwIEdTOiAwMGUwIFNTOiAwMDY4ClsgICAgMS41NDAwMjhdIENSMDogODAw
NTAwMzMgQ1IyOiAwMDAwMDAzYyBDUjM6IDAwYTE2MDAwIENSNDogMDAwNDA2YjAKWyAgICAx
LjU0MDAyOF0gU3RhY2s6ClsgICAgMS41NDAwMjhdICBjMDliMDAwYyBkMTE0ZDQ5OCBjMDgx
ZmE5NCBkMTE0ZWMwMCBjMDc2NmVjOCAwMDAwMDAwMiBjMDRkZGIxZSAwMDAwMDAwMApbICAg
IDEuNTQwMDI4XSAgYzA5YjFmYWQgMDAwMDAwY2MgZDEwNWRmNzQgYzAyMDA0NzcgYzAyNTFi
NzYgZDEwNWRmMmMgYzAyNTQ2ZGQgZDNmZjYzY2IKWyAgICAxLjU0MDAyOF0gIGQxMDVkZjM0
IGMwMjQxMTJiIGQzZmY2M2NiIGQxMDVkZjAwIGMwOWFhNTEyIGMwODBkNzM0IDAwMDAwMGNj
IGQxMDVkZjc0ClsgICAgMS41NDAwMjhdIENhbGwgVHJhY2U6ClsgICAgMS41NDAwMjhdICBb
PGMwOWIwMDBjPl0gPyBjYWNoZV9zeXNmc19pbml0KzB4MWRkLzB4MWU3ClsgICAgMS41NDAw
MjhdICBbPGMwNGRkYjFlPl0gPyByZWdpc3Rlcl9zeXNjb3JlX29wcysweDMyLzB4MzUKWyAg
ICAxLjU0MDAyOF0gIFs8YzA5YjFmYWQ+XSA/IGludGVsX3VuY29yZV9pbml0KzB4MjUxLzB4
MjUxClsgICAgMS41NDAwMjhdICBbPGMwMjAwNDc3Pl0gZG9fb25lX2luaXRjYWxsKzB4ZGYv
MHgxMzgKWyAgICAxLjU0MDAyOF0gIFs8YzAyNTFiNzY+XSA/IGxvY2tfcmVsZWFzZV9ob2xk
dGltZS5wYXJ0LjIwKzB4OTMvMHhmOApbICAgIDEuNTQwMDI4XSAgWzxjMDI1NDZkZD5dID8g
dHJhY2VfaGFyZGlycXNfb25fY2FsbGVyKzB4ZWIvMHgxYWQKWyAgICAxLjU0MDAyOF0gIFs8
YzAyNDExMmI+XSA/IHBhcmFtZXErMHgxMy8weDVlClsgICAgMS41NDAwMjhdICBbPGMwOWFh
NTEyPl0gPyByZXBhaXJfZW52X3N0cmluZysweDEyLzB4NTEKWyAgICAxLjU0MDAyOF0gIFs8
YzAyNDEzMzU+XSA/IHBhcnNlX2FyZ3MrMHgxYmYvMHgyZjgKWyAgICAxLjU0MDAyOF0gIFs8
YzAyM2I3Mzg+XSA/IF9fdXNlcm1vZGVoZWxwZXJfc2V0X2Rpc2FibGVfZGVwdGgrMHgzZS8w
eDQ0ClsgICAgMS41NDAwMjhdICBbPGMwOWFhYjQ2Pl0ga2VybmVsX2luaXRfZnJlZWFibGUr
MHhkZS8weDE3OApbICAgIDEuNTQwMDI4XSAgWzxjMDlhYTUwMD5dID8gZG9fZWFybHlfcGFy
YW0rMHg3OC8weDc4ClsgICAgMS41NDAwMjhdICBbPGMwNjRiZDcwPl0ga2VybmVsX2luaXQr
MHhiLzB4ZWQKWyAgICAxLjU0MDAyOF0gIFs8YzAyNDkxZjk+XSA/IHNjaGVkdWxlX3RhaWwr
MHhjLzB4M2EKWyAgICAxLjU0MDAyOF0gIFs8YzA2NTk2Yjc+XSByZXRfZnJvbV9rZXJuZWxf
dGhyZWFkKzB4MWIvMHgyOApbICAgIDEuNTQwMDI4XSAgWzxjMDY0YmQ2NT5dID8gcmVzdF9p
bml0KzB4YjUvMHhiNQpbICAgIDEuNTQwMDI4XSBDb2RlOiAyNCBiYSA4MSAwMiAwMCAwMCBi
OCA0YyBiZiA3NiBjMCBlOCBlMSA5OSA4NyBmZiA4OSA1YyAyNCAwNCBjNyAwNCAyNCA5MCBi
ZiA3NiBjMCBlOCAzYiBlYSBjOSBmZiA4MyBjOCBmZiBlYiA1ZCA4YiAxZCA4MCA3MyA4MiBj
MCA8OGI+IDQzIDNjIDhiIDUzIDQwIGU4IDhlIGMyIDg3IGZmIDg5IGQ2IGI5IGU4IDAzIDAw
IDAwIGY3IGU5IDg5ClsgICAgMS41NDAwMjhdIEVJUDogWzxjMDliMjBjMD5dIHJhcGxfcG11
X2luaXQrMHgxMTMvMHgxNzIgU1M6RVNQIDAwNjg6ZDEwNWRlZDgKWyAgICAxLjU0MDAyOF0g
Q1IyOiAwMDAwMDAwMDAwMDAwMDNjClsgICAgMS41NDAwMjhdIC0tLVsgZW5kIHRyYWNlIDYw
MWI5ZDJmYTVlZWViOTUgXS0tLQpbICAgIDEuNTQwMDI4XSBzd2FwcGVyICgxKSB1c2VkIGdy
ZWF0ZXN0IHN0YWNrIGRlcHRoOiA1ODAwIGJ5dGVzIGxlZnQKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctaWIxLTA3MjUxMTUzLzNkN2MwMTQ0NDkxYmQ4YzIxZDUzYjQzMDMyMjc0YTg1ZWZk
ZmU0MzQvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMTc6MjAxNDA3MjUxODM3Mzg6aTM4Ni1yYW5k
Y29uZmlnLWliMS0wNzI1MTE1MzozLjEyLjAtMDU3NzYtZzNkN2MwMTQ6OAova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvM2Q3YzAxNDQ0OTFiZDhjMjFkNTNiNDMwMzIy
NzRhODVlZmRmZTQzNC9kbWVzZy15b2N0by1rYnVpbGQtMTg6MjAxNDA3MjUxODM5MDk6aTM4
Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1MzozLjEyLjAtMDU3NzYtZzNkN2MwMTQ6OAova2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvM2Q3YzAxNDQ0OTFiZDhjMjFkNTNi
NDMwMzIyNzRhODVlZmRmZTQzNC9kbWVzZy15b2N0by1rYnVpbGQtMjA6MjAxNDA3MjUxODM5
MTA6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1MzozLjEyLjAtMDU3NzYtZzNkN2MwMTQ6
OAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvM2Q3YzAxNDQ0OTFiZDhj
MjFkNTNiNDMwMzIyNzRhODVlZmRmZTQzNC9kbWVzZy15b2N0by1rYnVpbGQtMjY6MjAxNDA3
MjUxODM5MDY6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1MzozLjEyLjAtMDU3NzYtZzNk
N2MwMTQ6OAoxMTo0OjQgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2VjdGluZzog
MzYgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDUgc3RlcHMp
CltiYTFkZGY0MmYzYzNhZjExMWQzYWRlZTI3NzUzNGY3M2MxZWY2YTliXSBwZXJmIHNjcmlw
dDogUHJpbnQgbW1hcFsyXSBldmVudHMgYWxzbwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgtOS9vYmot
YmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctaWIxLTA3MjUxMTUzL25leHQ6bWFzdGVyOmJhMWRkZjQyZjNjM2FmMTExZDNhZGVlMjc3
NTM0ZjczYzFlZjZhOWI6YmlzZWN0LWxpbnV4LTkKCjIwMTQtMDctMjUtMTg6NDE6MTQgYmEx
ZGRmNDJmM2MzYWYxMTFkM2FkZWUyNzc1MzRmNzNjMWVmNmE5YiBjb21waWxpbmcKUXVldWVk
IGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25m
aWctaWIxLTA3MjUxMTUzLWJhMWRkZjQyZjNjM2FmMTExZDNhZGVlMjc3NTM0ZjczYzFlZjZh
OWIKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcy
NTExNTMvYmExZGRmNDJmM2MzYWYxMTFkM2FkZWUyNzc1MzRmNzNjMWVmNmE5Ygp3YWl0aW5n
IGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5k
Y29uZmlnLWliMS0wNzI1MTE1My1iYTFkZGY0MmYzYzNhZjExMWQzYWRlZTI3NzUzNGY3M2Mx
ZWY2YTliCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzL2Jh
MWRkZjQyZjNjM2FmMTExZDNhZGVlMjc3NTM0ZjczYzFlZjZhOWIvdm1saW51ei0zLjEyLjAt
MDU3MzktZ2JhMWRkZjQKCjIwMTQtMDctMjUtMTg6NDM6MTQgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgLiBURVNUIEZBSUxVUkUKWyAgICAwLjU5OTY5M10gUENJOiBDTFMgMCBieXRlcywgZGVm
YXVsdCA2NApbICAgIDAuNjAxNzYyXSBVbnBhY2tpbmcgaW5pdHJhbWZzLi4uClsgICAgMS42
MjYyODJdIEZyZWVpbmcgaW5pdHJkIG1lbW9yeTogMjQ4NTJLIChkMjdhYjAwMCAtIGQzZmYw
MDAwKQpbICAgIDEuNjI3ODcxXSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2VybmVsIE5VTEwg
cG9pbnRlciBkZXJlZmVyZW5jZSBhdCAwMDAwMDAzYwpbICAgIDEuNjI4MDA5XSBJUDogWzxj
MDliMjBjMD5dIHJhcGxfcG11X2luaXQrMHgxMTMvMHgxNzIKWyAgICAxLjYyODAwOV0gKnBk
cHQgPSAwMDAwMDAwMDAwMDAwMDAwICpwZGUgPSBmMDAwZmY1M2YwMDBmZjUzIApbICAgIDEu
NjI4MDA5XSBPb3BzOiAwMDAwIFsjMV0gUFJFRU1QVCAKWyAgICAxLjYyODAwOV0gTW9kdWxl
cyBsaW5rZWQgaW46ClsgICAgMS42MjgwMDldIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBl
ciBOb3QgdGFpbnRlZCAzLjEyLjAtMDU3MzktZ2JhMWRkZjQgIzkKWyAgICAxLjYyODAwOV0g
SGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpbICAg
IDEuNjI4MDA5XSB0YXNrOiBkMTA1YTAyMCB0aTogZDEwNWMwMDAgdGFzay50aTogZDEwNWMw
MDAKWyAgICAxLjYyODAwOV0gRUlQOiAwMDYwOls8YzA5YjIwYzA+XSBFRkxBR1M6IDAwMDEw
MjQ2IENQVTogMApbICAgIDEuNjI4MDA5XSBFSVAgaXMgYXQgcmFwbF9wbXVfaW5pdCsweDEx
My8weDE3MgpbICAgIDEuNjI4MDA5XSBFQVg6IDAwMDAwMDAwIEVCWDogMDAwMDAwMDAgRUNY
OiAwMDAwMDAwMCBFRFg6IDAwMDAwMDAxClsgICAgMS42MjgwMDldIEVTSTogYzA5YjFmYWQg
RURJOiAwMDAwMDBjYyBFQlA6IGQxMDVkZjAwIEVTUDogZDEwNWRlZDgKWyAgICAxLjYyODAw
OV0gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMDAwIEdTOiAwMGUwIFNTOiAwMDY4ClsgICAg
MS42MjgwMDldIENSMDogODAwNTAwMzMgQ1IyOiAwMDAwMDAzYyBDUjM6IDAwYTE2MDAwIENS
NDogMDAwNDA2YjAKWyAgICAxLjYyODAwOV0gU3RhY2s6ClsgICAgMS42MjgwMDldICBjMDli
MDAwYyBkMTE0ZDQ5OCBjMDgxZmE5NCBkMTE0ZWMwMCBjMDc2NmVjOCAwMDAwMDAwMiBjMDRk
ZGIxZSAwMDAwMDAwMApbICAgIDEuNjI4MDA5XSAgYzA5YjFmYWQgMDAwMDAwY2MgZDEwNWRm
NzQgYzAyMDA0NzcgYzAyNTFiNzYgZDEwNWRmMmMgYzAyNTQ2ZGQgZDNmZjYzY2QKWyAgICAx
LjYyODAwOV0gIGQxMDVkZjM0IGMwMjQxMTJiIGQzZmY2M2NkIGQxMDVkZjAwIGMwOWFhNTEy
IGMwODBkNzJjIDAwMDAwMGNjIGQxMDVkZjc0ClsgICAgMS42MjgwMDldIENhbGwgVHJhY2U6
ClsgICAgMS42MjgwMDldICBbPGMwOWIwMDBjPl0gPyBjYWNoZV9zeXNmc19pbml0KzB4MWRk
LzB4MWU3ClsgICAgMS42MjgwMDldICBbPGMwNGRkYjFlPl0gPyByZWdpc3Rlcl9zeXNjb3Jl
X29wcysweDMyLzB4MzUKWyAgICAxLjYyODAwOV0gIFs8YzA5YjFmYWQ+XSA/IGludGVsX3Vu
Y29yZV9pbml0KzB4MjUxLzB4MjUxClsgICAgMS42MjgwMDldICBbPGMwMjAwNDc3Pl0gZG9f
b25lX2luaXRjYWxsKzB4ZGYvMHgxMzgKWyAgICAxLjYyODAwOV0gIFs8YzAyNTFiNzY+XSA/
IGxvY2tfcmVsZWFzZV9ob2xkdGltZS5wYXJ0LjIwKzB4OTMvMHhmOApbICAgIDEuNjI4MDA5
XSAgWzxjMDI1NDZkZD5dID8gdHJhY2VfaGFyZGlycXNfb25fY2FsbGVyKzB4ZWIvMHgxYWQK
WyAgICAxLjYyODAwOV0gIFs8YzAyNDExMmI+XSA/IHBhcmFtZXErMHgxMy8weDVlClsgICAg
MS42MjgwMDldICBbPGMwOWFhNTEyPl0gPyByZXBhaXJfZW52X3N0cmluZysweDEyLzB4NTEK
WyAgICAxLjYyODAwOV0gIFs8YzAyNDEzMzU+XSA/IHBhcnNlX2FyZ3MrMHgxYmYvMHgyZjgK
WyAgICAxLjYyODAwOV0gIFs8YzAyM2I3Mzg+XSA/IF9fdXNlcm1vZGVoZWxwZXJfc2V0X2Rp
c2FibGVfZGVwdGgrMHgzZS8weDQ0ClsgICAgMS42MjgwMDldICBbPGMwOWFhYjQ2Pl0ga2Vy
bmVsX2luaXRfZnJlZWFibGUrMHhkZS8weDE3OApbICAgIDEuNjI4MDA5XSAgWzxjMDlhYTUw
MD5dID8gZG9fZWFybHlfcGFyYW0rMHg3OC8weDc4ClsgICAgMS42MjgwMDldICBbPGMwNjRi
ZDcwPl0ga2VybmVsX2luaXQrMHhiLzB4ZWQKWyAgICAxLjYyODAwOV0gIFs8YzAyNDkxZjk+
XSA/IHNjaGVkdWxlX3RhaWwrMHhjLzB4M2EKWyAgICAxLjYyODAwOV0gIFs8YzA2NTk2Yjc+
XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MWIvMHgyOApbICAgIDEuNjI4MDA5XSAgWzxj
MDY0YmQ2NT5dID8gcmVzdF9pbml0KzB4YjUvMHhiNQpbICAgIDEuNjI4MDA5XSBDb2RlOiAy
NCBiYSA4MSAwMiAwMCAwMCBiOCA0YyBiZiA3NiBjMCBlOCBlMSA5OSA4NyBmZiA4OSA1YyAy
NCAwNCBjNyAwNCAyNCA5MCBiZiA3NiBjMCBlOCAzYiBlYSBjOSBmZiA4MyBjOCBmZiBlYiA1
ZCA4YiAxZCA4MCA3MyA4MiBjMCA8OGI+IDQzIDNjIDhiIDUzIDQwIGU4IDhlIGMyIDg3IGZm
IDg5IGQ2IGI5IGU4IDAzIDAwIDAwIGY3IGU5IDg5ClsgICAgMS42MjgwMDldIEVJUDogWzxj
MDliMjBjMD5dIHJhcGxfcG11X2luaXQrMHgxMTMvMHgxNzIgU1M6RVNQIDAwNjg6ZDEwNWRl
ZDgKWyAgICAxLjYyODAwOV0gQ1IyOiAwMDAwMDAwMDAwMDAwMDNjClsgICAgMS42MjgwMDld
IC0tLVsgZW5kIHRyYWNlIDg1ZDczNGU1YTk2YTk1ZTYgXS0tLQpbICAgIDEuNjI4MDA5XSBz
d2FwcGVyICgxKSB1c2VkIGdyZWF0ZXN0IHN0YWNrIGRlcHRoOiA1NjYwIGJ5dGVzIGxlZnQK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzL2JhMWRkZjQyZjNjM2FmMTEx
ZDNhZGVlMjc3NTM0ZjczYzFlZjZhOWIvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMzA6MjAxNDA3
MjUxODQwNDU6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1MzozLjEyLjAtMDU3MzktZ2Jh
MWRkZjQ6OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvYmExZGRmNDJm
M2MzYWYxMTFkM2FkZWUyNzc1MzRmNzNjMWVmNmE5Yi9kbWVzZy15b2N0by1rYnVpbGQtMjk6
MjAxNDA3MjUxODQwNDI6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1MzozLjEyLjAtMDU3
MzktZ2JhMWRkZjQ6OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvYmEx
ZGRmNDJmM2MzYWYxMTFkM2FkZWUyNzc1MzRmNzNjMWVmNmE5Yi9kbWVzZy15b2N0by1rYnVp
bGQtNToyMDE0MDcyNTE4NDA0MjppMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzOjMuMTIu
MC0wNTczOS1nYmExZGRmNDo5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1
My9iYTFkZGY0MmYzYzNhZjExMWQzYWRlZTI3NzUzNGY3M2MxZWY2YTliL2RtZXNnLXF1YW50
YWwta2J1aWxkLTMyOjIwMTQwNzI1MTg0MDQ3OmkzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTEx
NTM6My4xMi4wLTA1NzM5LWdiYTFkZGY0OjkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIx
LTA3MjUxMTUzL2JhMWRkZjQyZjNjM2FmMTExZDNhZGVlMjc3NTM0ZjczYzFlZjZhOWIvZG1l
c2ctcXVhbnRhbC1rYnVpbGQtNzoyMDE0MDcyNTE4NDA1MDppMzg2LXJhbmRjb25maWctaWIx
LTA3MjUxMTUzOjMuMTIuMC0wNTczOS1nYmExZGRmNDo5Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWliMS0wNzI1MTE1My9iYTFkZGY0MmYzYzNhZjExMWQzYWRlZTI3NzUzNGY3M2MxZWY2
YTliL2RtZXNnLXlvY3RvLWtidWlsZC0xODoyMDE0MDcyNTE4NDA0NzppMzg2LXJhbmRjb25m
aWctaWIxLTA3MjUxMTUzOjMuMTIuMC0wNTczOS1nYmExZGRmNDo5Ci9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWliMS0wNzI1MTE1My9iYTFkZGY0MmYzYzNhZjExMWQzYWRlZTI3NzUzNGY3
M2MxZWY2YTliL2RtZXNnLXlvY3RvLWtidWlsZC0zMjoyMDE0MDcyNTE4NDA0NjppMzg2LXJh
bmRjb25maWctaWIxLTA3MjUxMTUzOjMuMTIuMC0wNTczOS1nYmExZGRmNDo5Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My9iYTFkZGY0MmYzYzNhZjExMWQzYWRlZTI3
NzUzNGY3M2MxZWY2YTliL2RtZXNnLXlvY3RvLWtidWlsZC04OjIwMTQwNzI1MTg0MTA0Omkz
ODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTM6My4xMi4wLTA1NzM5LWdiYTFkZGY0OjkKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzL2JhMWRkZjQyZjNjM2FmMTExZDNh
ZGVlMjc3NTM0ZjczYzFlZjZhOWIvZG1lc2ctcXVhbnRhbC1rYnVpbGQtMjE6MjAxNDA3MjUx
ODQxMTM6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1MzozLjEyLjAtMDU3MzktZ2JhMWRk
ZjQ6OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvYmExZGRmNDJmM2Mz
YWYxMTFkM2FkZWUyNzc1MzRmNzNjMWVmNmE5Yi9kbWVzZy1xdWFudGFsLWtidWlsZC0yOToy
MDE0MDcyNTE4NDExMzppMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzOjMuMTIuMC0wNTcz
OS1nYmExZGRmNDo5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My9iYTFk
ZGY0MmYzYzNhZjExMWQzYWRlZTI3NzUzNGY3M2MxZWY2YTliL2RtZXNnLXF1YW50YWwta2J1
aWxkLTE6MjAxNDA3MjUxODQxMjU6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1MzozLjEy
LjAtMDU3MzktZ2JhMWRkZjQ6OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTEx
NTMvYmExZGRmNDJmM2MzYWYxMTFkM2FkZWUyNzc1MzRmNzNjMWVmNmE5Yi9kbWVzZy15b2N0
by1rYnVpbGQtODoyMDE0MDcyNTE4NDEyMDppMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUz
OjMuMTIuMC0wNTczOS1nYmExZGRmNDo5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0w
NzI1MTE1My9iYTFkZGY0MmYzYzNhZjExMWQzYWRlZTI3NzUzNGY3M2MxZWY2YTliL2RtZXNn
LXF1YW50YWwta2J1aWxkLTIxOjIwMTQwNzI1MTg0MTMxOmkzODYtcmFuZGNvbmZpZy1pYjEt
MDcyNTExNTM6My4xMi4wLTA1NzM5LWdiYTFkZGY0OjkKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaWIxLTA3MjUxMTUzL2JhMWRkZjQyZjNjM2FmMTExZDNhZGVlMjc3NTM0ZjczYzFlZjZh
OWIvZG1lc2cteW9jdG8ta2J1aWxkLTExOjIwMTQwNzI1MTg0MTM0OmkzODYtcmFuZGNvbmZp
Zy1pYjEtMDcyNTExNTM6My4xMi4wLTA1NzM5LWdiYTFkZGY0OjkKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctaWIxLTA3MjUxMTUzL2JhMWRkZjQyZjNjM2FmMTExZDNhZGVlMjc3NTM0Zjcz
YzFlZjZhOWIvZG1lc2cteW9jdG8ta2J1aWxkLTE4OjIwMTQwNzI1MTg0MTMzOmkzODYtcmFu
ZGNvbmZpZy1pYjEtMDcyNTExNTM6My4xMi4wLTA1NzM5LWdiYTFkZGY0OjkKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzL2JhMWRkZjQyZjNjM2FmMTExZDNhZGVlMjc3
NTM0ZjczYzFlZjZhOWIvZG1lc2cteW9jdG8ta2J1aWxkLTIwOjIwMTQwNzI1MTg0MTQxOmkz
ODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTM6My4xMi4wLTA1NzM5LWdiYTFkZGY0OjkKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzL2JhMWRkZjQyZjNjM2FmMTExZDNh
ZGVlMjc3NTM0ZjczYzFlZjZhOWIvZG1lc2cteW9jdG8ta2J1aWxkLTg6MjAxNDA3MjUxODQx
NDA6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1MzozLjEyLjAtMDU3MzktZ2JhMWRkZjQ6
OQowOjE3OjE1IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDE4IHJl
dmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA0IHN0ZXBzKQpbYThi
NGM3MDE0Y2FkZmRhY2Q0ZTFmNGM5NjMxMjg1OTNiZTZmMjBkZV0gcGVyZiBjb21wbGV0aW9u
OiBSZW5hbWUgZmlsZSB0byByZWZsZWN0IHpzaCBzdXBwb3J0CnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51
eC05L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYt
cmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvbmV4dDptYXN0ZXI6YThiNGM3MDE0Y2FkZmRhY2Q0
ZTFmNGM5NjMxMjg1OTNiZTZmMjBkZTpiaXNlY3QtbGludXgtOQoKMjAxNC0wNy0yNS0xODo0
Mzo0NSBhOGI0YzcwMTRjYWRmZGFjZDRlMWY0Yzk2MzEyODU5M2JlNmYyMGRlIGNvbXBpbGlu
ZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYt
cmFuZGNvbmZpZy1pYjEtMDcyNTExNTMtYThiNGM3MDE0Y2FkZmRhY2Q0ZTFmNGM5NjMxMjg1
OTNiZTZmMjBkZQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWliMS0wNzI1MTE1My9hOGI0YzcwMTRjYWRmZGFjZDRlMWY0Yzk2MzEyODU5M2JlNmYyMGRl
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9p
Mzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzLWE4YjRjNzAxNGNhZGZkYWNkNGUxZjRjOTYz
MTI4NTkzYmU2ZjIwZGUKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlL2xrcC1oc3gwMS1jb25zdW1lci9pMzg2LXJhbmRjb25maWctaWIxLTA3
MjUxMTUzLWE4YjRjNzAxNGNhZGZkYWNkNGUxZjRjOTYzMTI4NTkzYmU2ZjIwZGUKa2VybmVs
OiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvYThiNGM3MDE0Y2FkZmRh
Y2Q0ZTFmNGM5NjMxMjg1OTNiZTZmMjBkZS92bWxpbnV6LTMuMTIuMC0wNTcyMC1nYThiNGM3
MDEKCjIwMTQtMDctMjUtMTg6NDg6NDUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLiBURVNUIEZB
SUxVUkUKWyAgICAwLjgwMTc5N10gUENJOiBDTFMgMCBieXRlcywgZGVmYXVsdCA2NApbICAg
IDAuODAzMTM1XSBVbnBhY2tpbmcgaW5pdHJhbWZzLi4uClsgICAgMC45Njk4NTddIEZyZWVp
bmcgaW5pdHJkIG1lbW9yeTogMzI3NksgKGQzY2JkMDAwIC0gZDNmZjAwMDApClsgICAgMC45
NzE0MTNdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVm
ZXJlbmNlIGF0IDAwMDAwMDNjClsgICAgMC45NzIwMTBdIElQOiBbPGMwOWIyMGMwPl0gcmFw
bF9wbXVfaW5pdCsweDExMy8weDE3MgpbICAgIDAuOTcyMDEwXSAqcGRwdCA9IDAwMDAwMDAw
MDAwMDAwMDAgKnBkZSA9IGYwMDBmZjUzZjAwMGZmNTMgClsgICAgMC45NzIwMTBdIE9vcHM6
IDAwMDAgWyMxXSBQUkVFTVBUIApbICAgIDAuOTcyMDEwXSBNb2R1bGVzIGxpbmtlZCBpbjoK
WyAgICAwLjk3MjAxMF0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVk
IDMuMTIuMC0wNTcyMC1nYThiNGM3MDEgIzEwClsgICAgMC45NzIwMTBdIEhhcmR3YXJlIG5h
bWU6IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAwLjk3MjAxMF0g
dGFzazogZDI0NGMwMjAgdGk6IGQyNDRlMDAwIHRhc2sudGk6IGQyNDRlMDAwClsgICAgMC45
NzIwMTBdIEVJUDogMDA2MDpbPGMwOWIyMGMwPl0gRUZMQUdTOiAwMDAxMDI0NiBDUFU6IDAK
WyAgICAwLjk3MjAxMF0gRUlQIGlzIGF0IHJhcGxfcG11X2luaXQrMHgxMTMvMHgxNzIKWyAg
ICAwLjk3MjAxMF0gRUFYOiAwMDAwMDAwMCBFQlg6IDAwMDAwMDAwIEVDWDogMDAwMDAwMDAg
RURYOiAwMDAwMDAwMQpbICAgIDAuOTcyMDEwXSBFU0k6IGMwOWIxZmFkIEVESTogMDAwMDAw
Y2MgRUJQOiBkMjQ0ZmYwMCBFU1A6IGQyNDRmZWQ4ClsgICAgMC45NzIwMTBdICBEUzogMDA3
YiBFUzogMDA3YiBGUzogMDAwMCBHUzogMDBlMCBTUzogMDA2OApbICAgIDAuOTcyMDEwXSBD
UjA6IDgwMDUwMDMzIENSMjogMDAwMDAwM2MgQ1IzOiAwMGExNjAwMCBDUjQ6IDAwMDQwNmIw
ClsgICAgMC45NzIwMTBdIFN0YWNrOgpbICAgIDAuOTcyMDEwXSAgYzA5YjAwMGMgZDI1NGQ0
OTggYzA4MWZhOTQgZDI1NGVjNDAgYzA3NjZlYzggMDAwMDAwMDIgYzA0ZGRiMWUgMDAwMDAw
MDAKWyAgICAwLjk3MjAxMF0gIGMwOWIxZmFkIDAwMDAwMGNjIGQyNDRmZjc0IGMwMjAwNDc3
IGMwMjUxYjc2IGQyNDRmZjJjIGMwMjU0NmRkIGQzZmY2M2NkClsgICAgMC45NzIwMTBdICBk
MjQ0ZmYzNCBjMDI0MTEyYiBkM2ZmNjNjZCBkMjQ0ZmYwMCBjMDlhYTUxMiBjMDgwZDczYyAw
MDAwMDBjYyBkMjQ0ZmY3NApbICAgIDAuOTcyMDEwXSBDYWxsIFRyYWNlOgpbICAgIDAuOTcy
MDEwXSAgWzxjMDliMDAwYz5dID8gY2FjaGVfc3lzZnNfaW5pdCsweDFkZC8weDFlNwpbICAg
IDAuOTcyMDEwXSAgWzxjMDRkZGIxZT5dID8gcmVnaXN0ZXJfc3lzY29yZV9vcHMrMHgzMi8w
eDM1ClsgICAgMC45NzIwMTBdICBbPGMwOWIxZmFkPl0gPyBpbnRlbF91bmNvcmVfaW5pdCsw
eDI1MS8weDI1MQpbICAgIDAuOTcyMDEwXSAgWzxjMDIwMDQ3Nz5dIGRvX29uZV9pbml0Y2Fs
bCsweGRmLzB4MTM4ClsgICAgMC45NzIwMTBdICBbPGMwMjUxYjc2Pl0gPyBsb2NrX3JlbGVh
c2VfaG9sZHRpbWUucGFydC4yMCsweDkzLzB4ZjgKWyAgICAwLjk3MjAxMF0gIFs8YzAyNTQ2
ZGQ+XSA/IHRyYWNlX2hhcmRpcnFzX29uX2NhbGxlcisweGViLzB4MWFkClsgICAgMC45NzIw
MTBdICBbPGMwMjQxMTJiPl0gPyBwYXJhbWVxKzB4MTMvMHg1ZQpbICAgIDAuOTcyMDEwXSAg
WzxjMDlhYTUxMj5dID8gcmVwYWlyX2Vudl9zdHJpbmcrMHgxMi8weDUxClsgICAgMC45NzIw
MTBdICBbPGMwMjQxMzM1Pl0gPyBwYXJzZV9hcmdzKzB4MWJmLzB4MmY4ClsgICAgMC45NzIw
MTBdICBbPGMwMjNiNzM4Pl0gPyBfX3VzZXJtb2RlaGVscGVyX3NldF9kaXNhYmxlX2RlcHRo
KzB4M2UvMHg0NApbICAgIDAuOTcyMDEwXSAgWzxjMDlhYWI0Nj5dIGtlcm5lbF9pbml0X2Zy
ZWVhYmxlKzB4ZGUvMHgxNzgKWyAgICAwLjk3MjAxMF0gIFs8YzA5YWE1MDA+XSA/IGRvX2Vh
cmx5X3BhcmFtKzB4NzgvMHg3OApbICAgIDAuOTcyMDEwXSAgWzxjMDY0YmQ3MD5dIGtlcm5l
bF9pbml0KzB4Yi8weGVkClsgICAgMC45NzIwMTBdICBbPGMwMjQ5MWY5Pl0gPyBzY2hlZHVs
ZV90YWlsKzB4Yy8weDNhClsgICAgMC45NzIwMTBdICBbPGMwNjU5NmI3Pl0gcmV0X2Zyb21f
a2VybmVsX3RocmVhZCsweDFiLzB4MjgKWyAgICAwLjk3MjAxMF0gIFs8YzA2NGJkNjU+XSA/
IHJlc3RfaW5pdCsweGI1LzB4YjUKWyAgICAwLjk3MjAxMF0gQ29kZTogMjQgYmEgODEgMDIg
MDAgMDAgYjggNGMgYmYgNzYgYzAgZTggZTEgOTkgODcgZmYgODkgNWMgMjQgMDQgYzcgMDQg
MjQgOTAgYmYgNzYgYzAgZTggM2IgZWEgYzkgZmYgODMgYzggZmYgZWIgNWQgOGIgMWQgODAg
NzMgODIgYzAgPDhiPiA0MyAzYyA4YiA1MyA0MCBlOCA4ZSBjMiA4NyBmZiA4OSBkNiBiOSBl
OCAwMyAwMCAwMCBmNyBlOSA4OQpbICAgIDAuOTcyMDEwXSBFSVA6IFs8YzA5YjIwYzA+XSBy
YXBsX3BtdV9pbml0KzB4MTEzLzB4MTcyIFNTOkVTUCAwMDY4OmQyNDRmZWQ4ClsgICAgMC45
NzIwMTBdIENSMjogMDAwMDAwMDAwMDAwMDAzYwpbICAgIDAuOTcyMDEwXSAtLS1bIGVuZCB0
cmFjZSAzNDdjZWI2NWY3ODVjNWZjIF0tLS0KWyAgICAwLjk3MjAxMF0gc3dhcHBlciAoMSkg
dXNlZCBncmVhdGVzdCBzdGFjayBkZXB0aDogNTY3NiBieXRlcyBsZWZ0Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My9hOGI0YzcwMTRjYWRmZGFjZDRlMWY0Yzk2MzEy
ODU5M2JlNmYyMGRlL2RtZXNnLXlvY3RvLWtidWlsZC0xMzoyMDE0MDcyNTE4NDcwNDppMzg2
LXJhbmRjb25maWctaWIxLTA3MjUxMTUzOjMuMTIuMC0wNTcyMC1nYThiNGM3MDE6MTAKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzL2E4YjRjNzAxNGNhZGZkYWNkNGUx
ZjRjOTYzMTI4NTkzYmU2ZjIwZGUvZG1lc2cteW9jdG8ta2J1aWxkLTY6MjAxNDA3MjUxODQ3
MDM6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1MzozLjEyLjAtMDU3MjAtZ2E4YjRjNzAx
OjEwCjA6MjoyIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDggcmV2
aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDMgc3RlcHMpCls0Nzg4
ZTViNGIyMzM4Zjg1ZmE0MmE3MTJhMTgyZDhhZmQ2NWQ3YzU4XSBwZXJmL3g4NjogQWRkIElu
dGVsIFJBUEwgUE1VIHN1cHBvcnQKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTkvb2JqLWJpc2VjdAps
cyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWliMS0w
NzI1MTE1My9uZXh0Om1hc3Rlcjo0Nzg4ZTViNGIyMzM4Zjg1ZmE0MmE3MTJhMTgyZDhhZmQ2
NWQ3YzU4OmJpc2VjdC1saW51eC05CgoyMDE0LTA3LTI1LTE4OjQ5OjE4IDQ3ODhlNWI0YjIz
MzhmODVmYTQyYTcxMmExODJkOGFmZDY1ZDdjNTggY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0
YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWliMS0w
NzI1MTE1My00Nzg4ZTViNGIyMzM4Zjg1ZmE0MmE3MTJhMTgyZDhhZmQ2NWQ3YzU4CkNoZWNr
IGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzLzQ3
ODhlNWI0YjIzMzhmODVmYTQyYTcxMmExODJkOGFmZDY1ZDdjNTgKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1p
YjEtMDcyNTExNTMtNDc4OGU1YjRiMjMzOGY4NWZhNDJhNzEyYTE4MmQ4YWZkNjVkN2M1OAp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvbGtw
LWhzeDAxLWNvbnN1bWVyL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMtNDc4OGU1YjRi
MjMzOGY4NWZhNDJhNzEyYTE4MmQ4YWZkNjVkN2M1OAprZXJuZWw6IC9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWliMS0wNzI1MTE1My80Nzg4ZTViNGIyMzM4Zjg1ZmE0MmE3MTJhMTgyZDhh
ZmQ2NWQ3YzU4L3ZtbGludXotMy4xMi4wLTA1NzExLWc0Nzg4ZTViCgoyMDE0LTA3LTI1LTE4
OjUzOjE4IGRldGVjdGluZyBib290IHN0YXRlIC4gVEVTVCBGQUlMVVJFClsgICAgMC42MTMz
MDVdIFBDSTogQ0xTIDAgYnl0ZXMsIGRlZmF1bHQgNjQKWyAgICAwLjYxNDY5OV0gVW5wYWNr
aW5nIGluaXRyYW1mcy4uLgpbICAgIDAuNzMyMTg4XSBGcmVlaW5nIGluaXRyZCBtZW1vcnk6
IDMyNzZLIChkM2NiZDAwMCAtIGQzZmYwMDAwKQpbICAgIDAuNzMzODk1XSBCVUc6IHVuYWJs
ZSB0byBoYW5kbGUga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCAwMDAwMDAy
OApbICAgIDAuNzM1NjAzXSBJUDogWzxjMDliMjBjYj5dIHJhcGxfcG11X2luaXQrMHgxMWUv
MHgxMzkKWyAgICAwLjczNjAxMl0gKnBkcHQgPSAwMDAwMDAwMDAwMDAwMDAwICpwZGUgPSBm
MDAwZmY1M2YwMDBmZjUzIApbICAgIDAuNzM2MDEyXSBPb3BzOiAwMDAwIFsjMV0gUFJFRU1Q
VCAKWyAgICAwLjczNjAxMl0gTW9kdWxlcyBsaW5rZWQgaW46ClsgICAgMC43MzYwMTJdIENQ
VTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjEyLjAtMDU3MTEtZzQ3
ODhlNWIgIzExClsgICAgMC43MzYwMTJdIEhhcmR3YXJlIG5hbWU6IEJvY2hzIEJvY2hzLCBC
SU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgICAwLjczNjAxMl0gdGFzazogZDI0NGMwMjAgdGk6
IGQyNDRlMDAwIHRhc2sudGk6IGQyNDRlMDAwClsgICAgMC43MzYwMTJdIEVJUDogMDA2MDpb
PGMwOWIyMGNiPl0gRUZMQUdTOiAwMDAxMDIwMiBDUFU6IDAKWyAgICAwLjczNjAxMl0gRUlQ
IGlzIGF0IHJhcGxfcG11X2luaXQrMHgxMWUvMHgxMzkKWyAgICAwLjczNjAxMl0gRUFYOiAw
MDAwMDAwMCBFQlg6IDAwMDAwMDAwIEVDWDogMDAwMDAwMDAgRURYOiAwMDAwMDAwMQpbICAg
IDAuNzM2MDEyXSBFU0k6IGMwOWIxZmFkIEVESTogMDAwMDAwY2MgRUJQOiBkMjQ0ZmYwMCBF
U1A6IGQyNDRmZWYwClsgICAgMC43MzYwMTJdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDAw
MCBHUzogMDBlMCBTUzogMDA2OApbICAgIDAuNzM2MDEyXSBDUjA6IDgwMDUwMDMzIENSMjog
MDAwMDAwMjggQ1IzOiAwMGExNjAwMCBDUjQ6IDAwMDQwNmIwClsgICAgMC43MzYwMTJdIFN0
YWNrOgpbICAgIDAuNzM2MDEyXSAgYzA0ZGRhYmUgMDAwMDAwMDAgMDAwMDAwMDIgMDAwMDAw
MDAgZDI0NGZmNzQgYzAyMDA0NzcgYzAyNTFiMTYgZDI0NGZmMmMKWyAgICAwLjczNjAxMl0g
IGMwMjU0NjdkIGQzZmY2M2NiIGQyNDRmZjM0IGMwMjQxMGNiIGQzZmY2M2NiIGQyNDRmZjAw
IGMwOWFhNTEyIGMwODBkNzFjClsgICAgMC43MzYwMTJdICAwMDAwMDBjYyBkMjQ0ZmY3NCBj
MDI0MTJkNSBjMDgyOWZlMCAwMDAwMDI4NiBjMDIzYjZkOCAwMDAwMDI0NiAwMDA2MDAwNgpb
ICAgIDAuNzM2MDEyXSBDYWxsIFRyYWNlOgpbICAgIDAuNzM2MDEyXSAgWzxjMDRkZGFiZT5d
ID8gcmVnaXN0ZXJfc3lzY29yZV9vcHMrMHgzMi8weDM1ClsgICAgMC43MzYwMTJdICBbPGMw
MjAwNDc3Pl0gZG9fb25lX2luaXRjYWxsKzB4ZGYvMHgxMzgKWyAgICAwLjczNjAxMl0gIFs8
YzAyNTFiMTY+XSA/IGxvY2tfcmVsZWFzZV9ob2xkdGltZS5wYXJ0LjIwKzB4OTMvMHhmOApb
ICAgIDAuNzM2MDEyXSAgWzxjMDI1NDY3ZD5dID8gdHJhY2VfaGFyZGlycXNfb25fY2FsbGVy
KzB4ZWIvMHgxYWQKWyAgICAwLjczNjAxMl0gIFs8YzAyNDEwY2I+XSA/IHBhcmFtZXErMHgx
My8weDVlClsgICAgMC43MzYwMTJdICBbPGMwOWFhNTEyPl0gPyByZXBhaXJfZW52X3N0cmlu
ZysweDEyLzB4NTEKWyAgICAwLjczNjAxMl0gIFs8YzAyNDEyZDU+XSA/IHBhcnNlX2FyZ3Mr
MHgxYmYvMHgyZjgKWyAgICAwLjczNjAxMl0gIFs8YzAyM2I2ZDg+XSA/IF9fdXNlcm1vZGVo
ZWxwZXJfc2V0X2Rpc2FibGVfZGVwdGgrMHgzZS8weDQ0ClsgICAgMC43MzYwMTJdICBbPGMw
OWFhYjQ2Pl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHhkZS8weDE3OApbICAgIDAuNzM2MDEy
XSAgWzxjMDlhYTUwMD5dID8gZG9fZWFybHlfcGFyYW0rMHg3OC8weDc4ClsgICAgMC43MzYw
MTJdICBbPGMwNjRiZDEwPl0ga2VybmVsX2luaXQrMHhiLzB4ZWQKWyAgICAwLjczNjAxMl0g
IFs8YzAyNDkxOTk+XSA/IHNjaGVkdWxlX3RhaWwrMHhjLzB4M2EKWyAgICAwLjczNjAxMl0g
IFs8YzA2NTk2Mzc+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MWIvMHgyOApbICAgIDAu
NzM2MDEyXSAgWzxjMDY0YmQwNT5dID8gcmVzdF9pbml0KzB4YjUvMHhiNQpbICAgIDAuNzM2
MDEyXSBDb2RlOiA5OSA4NyBmZiA4OSA1YyAyNCAwNCBjNyAwNCAyNCA5MCBiZiA3NiBjMCBl
OCBkZCBlOSBjOSBmZiA4MyBjOCBmZiBlYiAyOCBhMSA0NCBiYyBhMSBjMCBmMyAwZiBiOCBj
MCA5MCA4OSA0NCAyNCAwOCBhMSA4MCA3MyA4MiBjMCA8OGI+IDQwIDI4IDg5IDQ0IDI0IDA0
IGM3IDA0IDI0IGQ0IGJmIDc2IGMwIGU4IGIyIGU5IGM5IGZmIDMxIGMwClsgICAgMC43MzYw
MTJdIEVJUDogWzxjMDliMjBjYj5dIHJhcGxfcG11X2luaXQrMHgxMWUvMHgxMzkgU1M6RVNQ
IDAwNjg6ZDI0NGZlZjAKWyAgICAwLjczNjAxMl0gQ1IyOiAwMDAwMDAwMDAwMDAwMDI4Clsg
ICAgMC43MzYwMTJdIC0tLVsgZW5kIHRyYWNlIDBhODE3MTJjOWZiMzZhMGEgXS0tLQpbICAg
IDAuNzM2MDEyXSBzd2FwcGVyICgxKSB1c2VkIGdyZWF0ZXN0IHN0YWNrIGRlcHRoOiA1ODAw
IGJ5dGVzIGxlZnQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzLzQ3ODhl
NWI0YjIzMzhmODVmYTQyYTcxMmExODJkOGFmZDY1ZDdjNTgvZG1lc2cteW9jdG8ta2J1aWxk
LTc6MjAxNDA3MjUxODUxMzU6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1MzozLjEyLjAt
MDU3MTEtZzQ3ODhlNWI6MTEKMDoxOjEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJp
c2VjdGluZzogNCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkg
MiBzdGVwcykKW2M5MTJkYWU2MGFlNmY2NTk0NTVmMjM5Mjk4MTEwYWRjNjdhNWYzZTldIHVw
cm9iZXM6IENsZWFudXAgIUNPTkZJR19VUFJPQkVTIGRlY2xzLCB1bmV4cG9ydCB4b2xfYXJl
YQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2MvYm9vdC1iaXNlY3QvbGludXgtOS9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzL25leHQ6bWFzdGVy
OmM5MTJkYWU2MGFlNmY2NTk0NTVmMjM5Mjk4MTEwYWRjNjdhNWYzZTk6YmlzZWN0LWxpbnV4
LTkKCjIwMTQtMDctMjUtMTg6NTM6NTMgYzkxMmRhZTYwYWU2ZjY1OTQ1NWYyMzkyOTgxMTBh
ZGM2N2E1ZjNlOSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0
cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzLWM5MTJkYWU2MGFl
NmY2NTk0NTVmMjM5Mjk4MTEwYWRjNjdhNWYzZTkKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvYzkxMmRhZTYwYWU2ZjY1OTQ1NWYy
MzkyOTgxMTBhZGM2N2E1ZjNlOQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My1jOTEyZGFl
NjBhZTZmNjU5NDU1ZjIzOTI5ODExMGFkYzY3YTVmM2U5Cmtlcm5lbDogL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctaWIxLTA3MjUxMTUzL2M5MTJkYWU2MGFlNmY2NTk0NTVmMjM5Mjk4MTEw
YWRjNjdhNWYzZTkvdm1saW51ei0zLjEyLjAtMDAzMTktZ2M5MTJkYWUKCjIwMTQtMDctMjUt
MTg6NTU6NTMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkxCTcJMTIJMTUJMTgJMjIJMjYJMjkJ
MzQJMzcuCTM4CTQwCTQ0CTQ1CTQ4CTUxCTUzCTU1CTU2CTU3Lgk2MAk2OQk4NQk4Ngk4OAk5
MwkxMDAJMTA1CTEwNgkxMjcJMTMxCTEzMwkxNTMJMTYzCTE2NAkxNzAJMTgwCTE5MQkxOTQJ
MjA5CTIxNwkyMjUJMjMzCTI1NAkyNzcJMjkzCTMxNgkzMjIJMzM1CTM0NwkzNTcJMzk4CTQw
NQk0MTAJNDIxCTQ0Mgk0NjcJNDg3CTUwMgk1MTMJNTU5CTU5NAk2MTgJNjY1CTY5Mgk3MjQJ
NzM5CTc1NAk3NzkJODE3CTg2NQk4ODQJOTAwIFNVQ0NFU1MKCkJpc2VjdGluZzogMiByZXZp
c2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMSBzdGVwKQpbMDk4OTdk
NzhkYmMzYTU0NDQyNmYyMjcyYjU2MDFjNjI5MjJjY2FiOV0gTWVyZ2UgYnJhbmNoICd1cHJv
YmVzL2NvcmUnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVs
L2dpdC9vbGVnL21pc2MgaW50byBwZXJmL2NvcmUKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4LTkvb2Jq
LWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLWliMS0wNzI1MTE1My9uZXh0Om1hc3RlcjowOTg5N2Q3OGRiYzNhNTQ0NDI2ZjIyNzJi
NTYwMWM2MjkyMmNjYWI5OmJpc2VjdC1saW51eC05CgoyMDE0LTA3LTI1LTE5OjM0OjAzIDA5
ODk3ZDc4ZGJjM2E1NDQ0MjZmMjI3MmI1NjAxYzYyOTIyY2NhYjkgY29tcGlsaW5nClF1ZXVl
ZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29u
ZmlnLWliMS0wNzI1MTE1My0wOTg5N2Q3OGRiYzNhNTQ0NDI2ZjIyNzJiNTYwMWM2MjkyMmNj
YWI5CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3
MjUxMTUzLzA5ODk3ZDc4ZGJjM2E1NDQ0MjZmMjI3MmI1NjAxYzYyOTIyY2NhYjkKd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFu
ZGNvbmZpZy1pYjEtMDcyNTExNTMtMDk4OTdkNzhkYmMzYTU0NDQyNmYyMjcyYjU2MDFjNjI5
MjJjY2FiOQprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My8w
OTg5N2Q3OGRiYzNhNTQ0NDI2ZjIyNzJiNTYwMWM2MjkyMmNjYWI5L3ZtbGludXotMy4xMi4w
LTA1NzA4LWcwOTg5N2Q3CgoyMDE0LTA3LTI1LTE5OjM2OjAzIGRldGVjdGluZyBib290IHN0
YXRlIC4uCTMxCTM1CTgzCTE0NQkxODcJMjcxCTMwNAkzMjAJNDA3CTQzMQk1NjQJNzE4CTgw
Ngk5MDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0
ZXIgdGhpcyAocm91Z2hseSAxIHN0ZXApCls0MTAxMzZmNWRkOTZiNjAxM2ZlNmQxMDExYjUy
M2IxYzI0N2UxY2NiXSB0b29scy9wZXJmL3N0YXQ6IEFkZCBldmVudCB1bml0IGFuZCBzY2Fs
ZSBzdXBwb3J0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC05L29iai1iaXNlY3QKbHMgLWEgL2tidWls
ZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvbmV4
dDptYXN0ZXI6NDEwMTM2ZjVkZDk2YjYwMTNmZTZkMTAxMWI1MjNiMWMyNDdlMWNjYjpiaXNl
Y3QtbGludXgtOQoKMjAxNC0wNy0yNS0xOTo0NDowOSA0MTAxMzZmNWRkOTZiNjAxM2ZlNmQx
MDExYjUyM2IxYzI0N2UxY2NiIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1
aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMtNDEw
MTM2ZjVkZDk2YjYwMTNmZTZkMTAxMWI1MjNiMWMyNDdlMWNjYgpDaGVjayBmb3Iga2VybmVs
IGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My80MTAxMzZmNWRkOTZi
NjAxM2ZlNmQxMDExYjUyM2IxYzI0N2UxY2NiCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2Yg
L2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUz
LTQxMDEzNmY1ZGQ5NmI2MDEzZmU2ZDEwMTFiNTIzYjFjMjQ3ZTFjY2IKa2VybmVsOiAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvNDEwMTM2ZjVkZDk2YjYwMTNmZTZk
MTAxMWI1MjNiMWMyNDdlMWNjYi92bWxpbnV6LTMuMTIuMC0wNTcxMC1nNDEwMTM2ZgoKMjAx
NC0wNy0yNS0xOTo0NjowOSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMjczCTMxMQk0MTcJNDgw
CTUzMQk1ODMJNjQ2CTc0NQk4MzMJODY5CTg4Mgk4OTkJOTAwIFNVQ0NFU1MKCjQ3ODhlNWI0
YjIzMzhmODVmYTQyYTcxMmExODJkOGFmZDY1ZDdjNTggaXMgdGhlIGZpcnN0IGJhZCBjb21t
aXQKY29tbWl0IDQ3ODhlNWI0YjIzMzhmODVmYTQyYTcxMmExODJkOGFmZDY1ZDdjNTgKQXV0
aG9yOiBTdGVwaGFuZSBFcmFuaWFuIDxlcmFuaWFuQGdvb2dsZS5jb20+CkRhdGU6ICAgVHVl
IE5vdiAxMiAxNzo1ODo1MCAyMDEzICswMTAwCgogICAgcGVyZi94ODY6IEFkZCBJbnRlbCBS
QVBMIFBNVSBzdXBwb3J0CiAgICAKICAgIFRoaXMgcGF0Y2ggYWRkcyBhIG5ldyB1bmNvcmUg
UE1VIHRvIGV4cG9zZSB0aGUgSW50ZWwKICAgIFJBUEwgZW5lcmd5IGNvbnN1bXB0aW9uIGNv
dW50ZXJzLiBVcCB0byAzIGNvdW50ZXJzLAogICAgZWFjaCBjb3VudGluZyBhIHBhcnRpY3Vs
YXIgUkFQTCBldmVudCBhcmUgZXhwb3NlZC4KICAgIAogICAgVGhlIFJBUEwgY291bnRlcnMg
YXJlIGF2YWlsYWJsZSBvbiBJbnRlbCBTYW5keUJyaWRnZSwKICAgIEl2eUJyaWRnZSwgSGFz
d2VsbC4gVGhlIHNlcnZlciBza3VzIGFkZCBhIDNyZCBjb3VudGVyLgogICAgCiAgICBUaGUg
Zm9sbG93aW5nIGV2ZW50cyBhcmUgYXZhaWxhYmxlIGFuZCBleHBvc2VkIGluIHN5c2ZzOgog
ICAgCiAgICAgIC0gcG93ZXIvZW5lcmd5LWNvcmVzOiBwb3dlciBjb25zdW1wdGlvbiBvZiBh
bGwgY29yZXMgb24gc29ja2V0CiAgICAgIC0gcG93ZXIvZW5lcmd5LXBrZzogcG93ZXIgY29u
c3VtcHRpb24gb2YgYWxsIGNvcmVzICsgTExjIGNhY2hlCiAgICAgIC0gcG93ZXIvZW5lcmd5
LWRyYW06IHBvd2VyIGNvbnN1bXB0aW9uIG9mIERSQU0gKHNlcnZlcnMgb25seSkKICAgIAog
ICAgRm9yIGVhY2ggZXZlbnQgYm90aCB0aGUgdW5pdCAoSm91bGVzKSBhbmQgc2NhbGUgKDJe
LTMyIEopCiAgICBpcyBleHBvc2VkIGluIHN5c2ZzIGZvciB1c2UgYnkgcGVyZiBzdGF0IGFu
ZCBvdGhlciB0b29scy4KICAgIFRoZSBmaWxlcyBhcmU6CiAgICAKICAgIAkvc3lzL2Rldmlj
ZXMvcG93ZXIvZXZlbnRzL2VuZXJneS0qLnVuaXQKICAgIAkvc3lzL2RldmljZXMvcG93ZXIv
ZXZlbnRzL2VuZXJneS0qLnNjYWxlCiAgICAKICAgIFRoZSBSQVBMIFBNVSBpcyB1bmNvcmUg
YnkgbmF0dXJlIGFuZCBpcyBpbXBsZW1lbnRlZCBzdWNoCiAgICB0aGF0IGl0IG9ubHkgd29y
a3MgaW4gc3lzdGVtLXdpZGUgbW9kZS4gTWVhc3VyaW5nIG9ubHkKICAgIG9uZSBDUFUgcGVy
IHNvY2tldCBpcyBzdWZmaWNpZW50LiBUaGUgL3N5cy9kZXZpY2VzL3Bvd2VyL2NwdW1hc2sK
ICAgIGZpbGUgY2FuIGJlIHVzZWQgYnkgdG9vbHMgdG8gZmlndXJlIG91dCB3aGljaCBDUFVz
IHRvIG1vbml0b3IKICAgIGJ5IGRlZmF1bHQuIEZvciBpbnN0YW5jZSwgb24gYSAyLXNvY2tl
dCBzeXN0ZW0sIDIgQ1BVcwogICAgKG9uZSBvbiBlYWNoIHNvY2tldCkgd2lsbCBiZSBzaG93
bi4KICAgIAogICAgQWxsIHRoZSBjb3VudGVycyBtZWFzdXJlIGluIHRoZSBzYW1lIHVuaXQg
KGV4cG9zZWQgdmlhIHN5c2ZzKS4KICAgIFRoZSBwZXJmX2V2ZW50cyBBUEkgZXhwb3NlcyBh
bGwgUkFQTCBjb3VudGVycyBhcyA2NC1iaXQgaW50ZWdlcnMKICAgIGNvdW50aW5nIGluIHVu
aXQgb2YgMS8yXjMyIEpvdWxlcyAoYWJvdXQgMC4yMyBuSikuIFVzZXIgbGV2ZWwgdG9vbHMK
ICAgIG11c3QgY29udmVydCB0aGUgY291bnRzIGJ5IG11bHRpcGx5aW5nIHRoZW0gYnkgMl4t
MzIgdG8gb2J0YWluCiAgICBKb3VsZXMuIFRoZSByZWFzb24gZm9yIHRoaXMgaXMgdGhhdCB0
aGUga2VybmVsIGF2b2lkcwogICAgZG9pbmcgZmxvYXRpbmcgcG9pbnQgbWF0aCB3aGVuZXZl
ciBwb3NzaWJsZSBiZWNhdXNlIGl0IGlzCiAgICBleHBlbnNpdmUgKHVzZXIgZmxvYXRpbmct
cG9pbnQgc3RhdGUgbXVzdCBiZSBzYXZlZCkuIFRoZSBtZXRob2QKICAgIHVzZWQgYXZvaWRz
IGtlcm5lbCBmbG9hdGluZy1wb2ludCB1c2FnZS4gVGhlcmUgaXMgbm8gbG9zcyBvZgogICAg
cHJlY2lzaW9uLiBUaGFua3MgdG8gUGV0ZXJaIGZvciBzdWdnZXN0aW5nIHRoaXMgYXBwcm9h
Y2guCiAgICAKICAgIFRvIGNvbnZlcnQgdGhlIHJhdyBjb3VudCBpbiBXYXR0OgogICAgICAg
VyA9IEMgKiAyLjMgLyAoMWUxMCAqIHRpbWUpCiAgICBvciBsZGV4cChDLCAtMzIpLgogICAg
CiAgICBSQVBMIFBNVSBpcyBhIG5ldyBzdGFuZGFsb25lIFBNVSB3aGljaCByZWdpc3RlcnMg
d2l0aCB0aGUKICAgIHBlcmZfZXZlbnQgY29yZSBzdWJzeXN0ZW0uIFRoZSBQTVUgdHlwZSAo
YXR0ci0+dHlwZSkgaXMKICAgIGR5bmFtaWNhbGx5IGFsbG9jYXRlZCBhbmQgaXMgYXZhaWxh
YmxlIGZyb20gL3N5cy9kZXZpY2UvcG93ZXIvdHlwZS4KICAgIAogICAgU2FtcGxpbmcgaXMg
bm90IHN1cHBvcnRlZCBieSB0aGUgUkFQTCBQTVUuIFRoZXJlIGlzIG5vCiAgICBwcml2aWxl
Z2UgbGV2ZWwgZmlsdGVyaW5nIGVpdGhlci4KICAgIAogICAgU2lnbmVkLW9mZi1ieTogU3Rl
cGhhbmUgRXJhbmlhbiA8ZXJhbmlhbkBnb29nbGUuY29tPgogICAgUmV2aWV3ZWQtYnk6IE1h
cmlhIERpbWFrb3BvdWxvdSA8bWFyaWEubi5kaW1ha29wb3Vsb3VAZ21haWwuY29tPgogICAg
UmV2aWV3ZWQtYnk6IEFuZGkgS2xlZW4gPGFrQGxpbnV4LmludGVsLmNvbT4KICAgIFNpZ25l
ZC1vZmYtYnk6IFBldGVyIFppamxzdHJhIDxwZXRlcnpAaW5mcmFkZWFkLm9yZz4KICAgIENj
OiBhY21lQHJlZGhhdC5jb20KICAgIENjOiBqb2xzYUByZWRoYXQuY29tCiAgICBDYzogemhl
bmcuei55YW5AaW50ZWwuY29tCiAgICBDYzogYnBAYWxpZW44LmRlCiAgICBMaW5rOiBodHRw
Oi8vbGttbC5rZXJuZWwub3JnL3IvMTM4NDI3NTUzMS0xMDg5Mi00LWdpdC1zZW5kLWVtYWls
LWVyYW5pYW5AZ29vZ2xlLmNvbQogICAgU2lnbmVkLW9mZi1ieTogSW5nbyBNb2xuYXIgPG1p
bmdvQGtlcm5lbC5vcmc+Cgo6MDQwMDAwIDA0MDAwMCA5OTgwYjJiMjU2NjhjYzk0YTE2NGU4
YjM3Y2YxYjQxOGYwYTNkM2NiIGExNmFiNDg1NTEzNWM4N2IyMjQ4OTI0NDQ5MjgwNjQ0ZmUw
ZGNkNjUgTQlhcmNoCmJpc2VjdCBydW4gc3VjY2VzcwpIRUFEIGlzIG5vdyBhdCA0MTAxMzZm
Li4uIHRvb2xzL3BlcmYvc3RhdDogQWRkIGV2ZW50IHVuaXQgYW5kIHNjYWxlIHN1cHBvcnQK
bHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pYjEt
MDcyNTExNTMvbmV4dDptYXN0ZXI6NDEwMTM2ZjVkZDk2YjYwMTNmZTZkMTAxMWI1MjNiMWMy
NDdlMWNjYjpiaXNlY3QtbGludXgtOQoKMjAxNC0wNy0yNS0xOTo1Mjo1OCA0MTAxMzZmNWRk
OTZiNjAxM2ZlNmQxMDExYjUyM2IxYzI0N2UxY2NiIHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWliMS0wNzI1MTE1My80MTAxMzZmNWRkOTZiNjAxM2ZlNmQxMDExYjUyM2IxYzI0
N2UxY2NiL3ZtbGludXotMy4xMi4wLTA1NzEwLWc0MTAxMzZmCgoyMDE0LTA3LTI1LTE5OjUy
OjU4IGRldGVjdGluZyBib290IHN0YXRlIC4uCTkyOAk5NjgJOTc1CTEwMDAgU1VDQ0VTUwoK
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgNDEwMTM2Zi4uLiB0b29scy9wZXJmL3N0YXQ6
IEFkZCBldmVudCB1bml0IGFuZCBzY2FsZSBzdXBwb3J0CkhFQUQgaXMgbm93IGF0IDFhNThk
OTkuLi4gQWRkIGxpbnV4LW5leHQgc3BlY2lmaWMgZmlsZXMgZm9yIDIwMTQwNzI0CmxzIC1h
IC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUx
MTUzL25leHQ6bWFzdGVyOjFhNThkOTkwOTYxMTk3MmZkMWMwODFiYjA0YTlmN2RjMjU3MWU2
MTI6YmlzZWN0LWxpbnV4LTkKIFRFU1QgRkFJTFVSRQpbICAgIDAuNjI2NTY2XSBQQ0k6IENM
UyAwIGJ5dGVzLCBkZWZhdWx0IDY0ClsgICAgMC42MjgwNTBdIFVucGFja2luZyBpbml0cmFt
ZnMuLi4KWyAgICAwLjYzMjQwOV0gSW5pdHJhbWZzIHVucGFja2luZyBmYWlsZWQ6IGp1bmsg
aW4gY29tcHJlc3NlZCBhcmNoaXZlClsgICAgMC42MzUwMTRdIEJVRzogdW5hYmxlIHRvIGhh
bmRsZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0IDAwMDAwMDBjClsgICAg
MC42MzY5NDZdIElQOiBbPGQxYzUyZDcxPl0gdmFsaWRhdGVfY2hhaW4uaXNyYS4zNysweGM1
LzB4MTBlNQpbICAgIDAuNjM4MzU3XSAqcGRwdCA9IDAwMDAwMDAwMDAwMDAwMDAgKnBkZSA9
IGYwMDBmZjUzZjAwMGZmNTMgClsgICAgMC42MzgzNTddIE9vcHM6IDAwMDAgWyMxXSBQUkVF
TVBUIApbICAgIDAuNjM4MzU3XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAwLjYzODM1N10g
Q1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTYuMC1yYzYtbmV4
dC0yMDE0MDcyNCAjODkKWyAgICAwLjYzODM1N10gSGFyZHdhcmUgbmFtZTogUUVNVSBTdGFu
ZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5NiksIEJJT1MgQm9jaHMgMDEvMDEvMjAxMQpb
ICAgIDAuNjM4MzU3XSB0YXNrOiBkMDQ0YTAxMCB0aTogZDA0NGMwMDAgdGFzay50aTogZDA0
NGMwMDAKWyAgICAwLjYzODM1N10gRUlQOiAwMDYwOls8ZDFjNTJkNzE+XSBFRkxBR1M6IDAw
MDEwMDg2IENQVTogMApbICAgIDAuNjM4MzU3XSBFSVAgaXMgYXQgdmFsaWRhdGVfY2hhaW4u
aXNyYS4zNysweGM1LzB4MTBlNQpbICAgIDAuNjM4MzU3XSBFQVg6IDAwMDAwMDAwIEVCWDog
MDAwMDAwMGUgRUNYOiAwMDAwMDAwMCBFRFg6IGZmZmZmZmZjClsgICAgMC42MzgzNTddIEVT
STogZDA0NGE0ZjQgRURJOiBkMjg4MzM0OCBFQlA6IGQwNDRkZDZjIEVTUDogZDA0NGRkMDgK
WyAgICAwLjYzODM1N10gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMDAwIEdTOiAwMGUwIFNT
OiAwMDY4ClsgICAgMC42MzgzNTddIENSMDogODAwNTAwM2IgQ1IyOiAwMDAwMDAwYyBDUjM6
IDEyNDY3MDAwIENSNDogMDAwMDA2YjAKWyAgICAwLjYzODM1N10gU3RhY2s6ClsgICAgMC42
MzgzNTddICAwMDAwMDAwZSBkMDQ0ZGQxNCBkMWMyNDNhZSBkMDQ0ZGQxYyBkMWMwN2QwNSBk
MDQ0ZGQ0OCBkMjhhMjdlMCBkMDQ0YTRmNApbICAgIDAuNjM4MzU3XSAgMDAwMDAwMDEgZDA0
NGEwMTAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgZDA0NGEwMTAgMDAw
MDAwMGUKWyAgICAwLjYzODM1N10gIGQwNDRkZDY0IGQxYzQ4OWY4IDI1ZDk0ZjJiIDAwMDAw
MDAwIDAwMDAwMDAwIGQwNDRhMDEwIDAwMDAwMDBlIGQwNDRhMDEwClsgICAgMC42MzgzNTdd
IENhbGwgVHJhY2U6ClsgICAgMC42MzgzNTddICBbPGQxYzI0M2FlPl0gPyBrdm1fY2xvY2tf
cmVhZCsweDEzLzB4MjQKWyAgICAwLjYzODM1N10gIFs8ZDFjMDdkMDU+XSA/IHNjaGVkX2Ns
b2NrKzB4OC8weGIKWyAgICAwLjYzODM1N10gIFs8ZDFjNDg5Zjg+XSA/IHNjaGVkX2Nsb2Nr
X2NwdSsweGIxLzB4ZDAKWyAgICAwLjYzODM1N10gIFs8ZDFjNTRjZjI+XSBfX2xvY2tfYWNx
dWlyZSsweDM1MC8weGFhNQpbICAgIDAuNjM4MzU3XSAgWzxkMWMyNDNhZT5dID8ga3ZtX2Ns
b2NrX3JlYWQrMHgxMy8weDI0ClsgICAgMC42MzgzNTddICBbPGQxYzA3ZDA1Pl0gPyBzY2hl
ZF9jbG9jaysweDgvMHhiClsgICAgMC42MzgzNTddICBbPGQxYzI0ZTJlPl0gPyBwdmNsb2Nr
X2Nsb2Nrc291cmNlX3JlYWQrMHhiYi8weDE0OQpbICAgIDAuNjM4MzU3XSAgWzxkMWM1NWI5
Nz5dIGxvY2tfYWNxdWlyZSsweDc3LzB4OTIKWyAgICAwLjYzODM1N10gIFs8ZDFjOTMyNGY+
XSA/IGZyZWVfcGNwcGFnZXNfYnVsaysweDFmLzB4MzBiClsgICAgMC42MzgzNTddICBbPGQy
MDhlODNjPl0gX3Jhd19zcGluX2xvY2srMHgzYy8weDY5ClsgICAgMC42MzgzNTddICBbPGQx
YzkzMjRmPl0gPyBmcmVlX3BjcHBhZ2VzX2J1bGsrMHgxZi8weDMwYgpbICAgIDAuNjM4MzU3
XSAgWzxkMWM5MzI0Zj5dIGZyZWVfcGNwcGFnZXNfYnVsaysweDFmLzB4MzBiClsgICAgMC42
MzgzNTddICBbPGQxYzkyMDE4Pl0gPyBmcmVlX3BhZ2VzX3ByZXBhcmUrMHhjMS8weGVhClsg
ICAgMC42MzgzNTddICBbPGQxYzkzNmU4Pl0gZnJlZV9ob3RfY29sZF9wYWdlKzB4MTIzLzB4
MTY0ClsgICAgMC42MzgzNTddICBbPGQxYzkzNzNjPl0gX19mcmVlX3BhZ2VzLnBhcnQuNzQr
MHgxMy8weDE4ClsgICAgMC42MzgzNTddICBbPGQxYzkzNzRmPl0gX19mcmVlX3BhZ2VzKzB4
ZS8weDEwClsgICAgMC42MzgzNTddICBbPGQxYzkzN2IwPl0gZnJlZV9yZXNlcnZlZF9hcmVh
KzB4NWYvMHhkYwpbICAgIDAuNjM4MzU3XSAgWzxkMWMyN2NhMT5dID8gc2V0X21lbW9yeV9y
dysweDQ4LzB4NGEKWyAgICAwLjYzODM1N10gIFs8ZDFjMjUwZjA+XSBmcmVlX2luaXRfcGFn
ZXMrMHg1Yi8weDdlClsgICAgMC42MzgzNTddICBbPGQyM2Y5ZDkwPl0gPyBtYXliZV9saW5r
LnBhcnQuMisweGU0LzB4ZTQKWyAgICAwLjYzODM1N10gIFs8ZDIzZjlkOTA+XSA/IG1heWJl
X2xpbmsucGFydC4yKzB4ZTQvMHhlNApbICAgIDAuNjM4MzU3XSAgWzxkMjQwNmJkMz5dIGZy
ZWVfaW5pdHJkX21lbSsweDI2LzB4MmEKWyAgICAwLjYzODM1N10gIFs8ZDIzZjllNjc+XSBw
b3B1bGF0ZV9yb290ZnMrMHhkNy8weGY5ClsgICAgMC42MzgzNTddICBbPGQyM2Y5ZDkwPl0g
PyBtYXliZV9saW5rLnBhcnQuMisweGU0LzB4ZTQKWyAgICAwLjYzODM1N10gIFs8ZDFjMDA0
MjY+XSBkb19vbmVfaW5pdGNhbGwrMHg3Zi8weDFiOQpbICAgIDAuNjM4MzU3XSAgWzxkMjNm
OWQ5MD5dID8gbWF5YmVfbGluay5wYXJ0LjIrMHhlNC8weGU0ClsgICAgMC42MzgzNTddICBb
PGQxYzU0NjU4Pl0gPyB0cmFjZV9oYXJkaXJxc19vbl9jYWxsZXIrMHhlYi8weDFhZgpbICAg
IDAuNjM4MzU3XSAgWzxkMWM0MWQ4YT5dID8gcGFyYW1lcSsweDEzLzB4NWUKWyAgICAwLjYz
ODM1N10gIFs8ZDIzZjg1OWI+XSA/IHJlcGFpcl9lbnZfc3RyaW5nKzB4MTIvMHg1MQpbICAg
IDAuNjM4MzU3XSAgWzxkMWM0MWZiZT5dID8gcGFyc2VfYXJncysweDFlOS8weDMxOQpbICAg
IDAuNjM4MzU3XSAgWzxkMWMzYzVjYT5dID8gX191c2VybW9kZWhlbHBlcl9zZXRfZGlzYWJs
ZV9kZXB0aCsweDNlLzB4NDQKWyAgICAwLjYzODM1N10gIFs8ZDIzZjhkMDk+XSBrZXJuZWxf
aW5pdF9mcmVlYWJsZSsweGRlLzB4MTc4ClsgICAgMC42MzgzNTddICBbPGQyM2Y4NTg5Pl0g
PyBpbml0Y2FsbF9ibGFja2xpc3QrMHg4MS8weDgxClsgICAgMC42MzgzNTddICBbPGQyMDgz
MGQwPl0ga2VybmVsX2luaXQrMHhiLzB4YzcKWyAgICAwLjYzODM1N10gIFs8ZDFjNDZmMDY+
XSA/IHNjaGVkdWxlX3RhaWwrMHhjLzB4M2EKWyAgICAwLjYzODM1N10gIFs8ZDIwOGY2NDA+
XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MjAvMHgzMApbICAgIDAuNjM4MzU3XSAgWzxk
MjA4MzBjNT5dID8gcmVzdF9pbml0KzB4YjUvMHhiNQpbICAgIDAuNjM4MzU3XSBDb2RlOiA4
OSA0ZCBjNCAzOSBjNyA3NCA0MSA4YiA0ZCBjOCAzMyA0OCAwYyA4YiA1MCAwOCAzMSBkYSAw
OSBkMSAwZiA4NCA1OSAwMyAwMCAwMCA4YiA1NSBjNCA4OSA3NSBiOCA4YiA0NSBjOCA4OSA0
NSBjNCBlYiAxMyA4YiA0ZCBjNCA8MzM+IDQ4IDBjIDhiIDcwIDA4IDMxIGRlIDA5IGYxIDBm
IDg0IDM4IDAzIDAwIDAwIDhiIDQyIDA0IDhkIDUwClsgICAgMC42MzgzNTddIEVJUDogWzxk
MWM1MmQ3MT5dIHZhbGlkYXRlX2NoYWluLmlzcmEuMzcrMHhjNS8weDEwZTUgU1M6RVNQIDAw
Njg6ZDA0NGRkMDgKWyAgICAwLjYzODM1N10gQ1IyOiAwMDAwMDAwMDAwMDAwMDBjClsgICAg
MC42MzgzNTddIC0tLVsgZW5kIHRyYWNlIGFmOWY5MjU0OWRiNmU1NjkgXS0tLQpbICAgIDAu
NjM4MzU3XSBub3RlOiBzd2FwcGVyWzFdIGV4aXRlZCB3aXRoIHByZWVtcHRfY291bnQgMQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvMWE1OGQ5OTA5NjExOTcyZmQx
YzA4MWJiMDRhOWY3ZGMyNTcxZTYxMi9kbWVzZy1xdWFudGFsLWl2YjQyLTk4OjIwMTQwNzI1
MTIyNDAzOmkzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTM6Ogova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1pYjEtMDcyNTExNTMvMWE1OGQ5OTA5NjExOTcyZmQxYzA4MWJiMDRhOWY3ZGMy
NTcxZTYxMi9kbWVzZy1xdWFudGFsLXZwLTI1OjIwMTQwNzI1MTE1NTEzOmkzODYtcmFuZGNv
bmZpZy1pYjEtMDcyNTExNTM6My4xNi4wLXJjNi1uZXh0LTIwMTQwNzI0Ojg5Cjc4OjI6MyBh
bGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKSEVBRCBpcyBub3cgYXQgMWE1OGQ5OSBBZGQg
bGludXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAxNDA3MjQKCj09PT09PT09PSBsaW51
cy9tYXN0ZXIgPT09PT09PT09ClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDFhNThkOTku
Li4gQWRkIGxpbnV4LW5leHQgc3BlY2lmaWMgZmlsZXMgZm9yIDIwMTQwNzI0CkhFQUQgaXMg
bm93IGF0IDgyZTEzYzcuLi4gTWVyZ2UgYnJhbmNoICdmb3ItMy4xNicgb2YgZ2l0Oi8vbGlu
dXgtbmZzLm9yZy9+YmZpZWxkcy9saW51eApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My9saW51czptYXN0ZXI6ODJlMTNj
NzFiYzY1NWI2ZGM3MTEwZGE0ZTE2NDA3OWRhZGI0NDg5MjpiaXNlY3QtbGludXgtOQoKMjAx
NC0wNy0yNS0xOTo1ODoyOCA4MmUxM2M3MWJjNjU1YjZkYzcxMTBkYTRlMTY0MDc5ZGFkYjQ0
ODkyIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMtODJlMTNjNzFiYzY1NWI2ZGM3
MTEwZGE0ZTE2NDA3OWRhZGI0NDg5MgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My84MmUxM2M3MWJjNjU1YjZkYzcxMTBkYTRlMTY0
MDc5ZGFkYjQ0ODkyCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9i
dWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzLTgyZTEzYzcxYmM2NTVi
NmRjNzExMGRhNGUxNjQwNzlkYWRiNDQ4OTIKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2pha2V0b3duLWNvbnN1bWVyL2kzODYtcmFuZGNv
bmZpZy1pYjEtMDcyNTExNTMtODJlMTNjNzFiYzY1NWI2ZGM3MTEwZGE0ZTE2NDA3OWRhZGI0
NDg5MgprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My84MmUx
M2M3MWJjNjU1YjZkYzcxMTBkYTRlMTY0MDc5ZGFkYjQ0ODkyL3ZtbGludXotMy4xNi4wLXJj
Ni0wMDExOC1nODJlMTNjNwoKMjAxNC0wNy0yNS0yMDowNDoyOSBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAuCTI1CTM4CTE4Ngk0MTAJNDQ4IFRFU1QgRkFJTFVSRQpbICAgIDAuNzQ0OTE1XSBQ
Q0k6IENMUyAwIGJ5dGVzLCBkZWZhdWx0IDY0ClsgICAgMC43NDY0NTBdIFVucGFja2luZyBp
bml0cmFtZnMuLi4KWyAgICAwLjc1MDY2OF0gSW5pdHJhbWZzIHVucGFja2luZyBmYWlsZWQ6
IGp1bmsgaW4gY29tcHJlc3NlZCBhcmNoaXZlClsgICAgMC43NTMyMzhdIEJVRzogdW5hYmxl
IHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0IDAwMDAwMDBj
ClsgICAgMC43NTUxNjRdIElQOiBbPGQxYzU3OTIxPl0gdmFsaWRhdGVfY2hhaW4uaXNyYS4z
NysweGM1LzB4MTBlNQpbICAgIDAuNzU2NzEzXSAqcGRwdCA9IDAwMDAwMDAwMDAwMDAwMDAg
KnBkZSA9IGYwMDBmZjUzZjAwMGZmNTMgClsgICAgMC43NTY3MTNdIE9vcHM6IDAwMDAgWyMx
XSBQUkVFTVBUIApbICAgIDAuNzU2NzEzXSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAgICAwLjc1
NjcxM10gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTYuMC1y
YzYtMDAxMTgtZzgyZTEzYzcgIzUKWyAgICAwLjc1NjcxM10gSGFyZHdhcmUgbmFtZTogUUVN
VSBTdGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5NiksIEJJT1MgQm9jaHMgMDEvMDEv
MjAxMQpbICAgIDAuNzU2NzEzXSB0YXNrOiBkMDQ0YTAxMCB0aTogZDA0NGMwMDAgdGFzay50
aTogZDA0NGMwMDAKWyAgICAwLjc1NjcxM10gRUlQOiAwMDYwOls8ZDFjNTc5MjE+XSBFRkxB
R1M6IDAwMDEwMDgyIENQVTogMApbICAgIDAuNzU2NzEzXSBFSVAgaXMgYXQgdmFsaWRhdGVf
Y2hhaW4uaXNyYS4zNysweGM1LzB4MTBlNQpbICAgIDAuNzU2NzEzXSBFQVg6IDAwMDAwMDAw
IEVCWDogMDAwMDAwODUgRUNYOiAwMDAwMDAwMCBFRFg6IGZmZmZmZmZjClsgICAgMC43NTY3
MTNdIEVTSTogZDA0NGE0ZjggRURJOiBkMjg1YmMwOCBFQlA6IGQwNDRkZGQ4IEVTUDogZDA0
NGRkNzQKWyAgICAwLjc1NjcxM10gIERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMDAwIEdTOiAw
MGUwIFNTOiAwMDY4ClsgICAgMC43NTY3MTNdIENSMDogODAwNTAwM2IgQ1IyOiAwMDAwMDAw
YyBDUjM6IDEyNDViMDAwIENSNDogMDAwMDA2YjAKWyAgICAwLjc1NjcxM10gU3RhY2s6Clsg
ICAgMC43NTY3MTNdICAwMDAwMDA4NSBkMDQ0ZGQ4MCBkMWMyM2VlZSBkMDQ0ZGQ4OCBkMWMw
N2QyNSBkMDQ0ZGRiNCBkMjhhMGZiMCBkMDQ0YTRmOApbICAgIDAuNzU2NzEzXSAgMDAwMDAw
MDEgZDA0NGEwMTAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgZDA0NGEw
MTAgMDAwMDAwODUKWyAgICAwLjc1NjcxM10gIGQwNDRkZGQwIGQxYzRkNWQ4IDJjZTUzZjE5
IDAwMDAwMDAwIDAwMDAwMDAwIGQwNDRhMDEwIDAwMDAwMDg1IGQwNDRhMDEwClsgICAgMC43
NTY3MTNdIENhbGwgVHJhY2U6ClsgICAgMC43NTY3MTNdICBbPGQxYzIzZWVlPl0gPyBrdm1f
Y2xvY2tfcmVhZCsweDEzLzB4MjQKWyAgICAwLjc1NjcxM10gIFs8ZDFjMDdkMjU+XSA/IHNj
aGVkX2Nsb2NrKzB4OC8weGIKWyAgICAwLjc1NjcxM10gIFs8ZDFjNGQ1ZDg+XSA/IHNjaGVk
X2Nsb2NrX2NwdSsweGIxLzB4ZDAKWyAgICAwLjc1NjcxM10gIFs8ZDFjNTk4YTI+XSBfX2xv
Y2tfYWNxdWlyZSsweDM1MC8weGFhNQpbICAgIDAuNzU2NzEzXSAgWzxkMWM1YTc0Nz5dIGxv
Y2tfYWNxdWlyZSsweDc3LzB4OTIKWyAgICAwLjc1NjcxM10gIFs8ZDFjOGU2OTg+XSA/IGFk
anVzdF9tYW5hZ2VkX3BhZ2VfY291bnQrMHgxMy8weDRhClsgICAgMC43NTY3MTNdICBbPGQy
MDg2NzdjPl0gX3Jhd19zcGluX2xvY2srMHgzYy8weDY5ClsgICAgMC43NTY3MTNdICBbPGQx
YzhlNjk4Pl0gPyBhZGp1c3RfbWFuYWdlZF9wYWdlX2NvdW50KzB4MTMvMHg0YQpbICAgIDAu
NzU2NzEzXSAgWzxkMWM4ZTY5OD5dIGFkanVzdF9tYW5hZ2VkX3BhZ2VfY291bnQrMHgxMy8w
eDRhClsgICAgMC43NTY3MTNdICBbPGQxYzkxYWQyPl0gZnJlZV9yZXNlcnZlZF9hcmVhKzB4
NmIvMHhkYwpbICAgIDAuNzU2NzEzXSAgWzxkMWMyNzdlMT5dID8gc2V0X21lbW9yeV9ydysw
eDQ4LzB4NGEKWyAgICAwLjc1NjcxM10gIFs8ZDFjMjRjMzA+XSBmcmVlX2luaXRfcGFnZXMr
MHg1Yi8weDdlClsgICAgMC43NTY3MTNdICBbPGQyM2VlY2U2Pl0gPyBtYXliZV9saW5rLnBh
cnQuMisweGU0LzB4ZTQKWyAgICAwLjc1NjcxM10gIFs8ZDIzZWVjZTY+XSA/IG1heWJlX2xp
bmsucGFydC4yKzB4ZTQvMHhlNApbICAgIDAuNzU2NzEzXSAgWzxkMjNmYjg2Yz5dIGZyZWVf
aW5pdHJkX21lbSsweDI2LzB4MmEKWyAgICAwLjc1NjcxM10gIFs8ZDIzZWVkYmQ+XSBwb3B1
bGF0ZV9yb290ZnMrMHhkNy8weGY5ClsgICAgMC43NTY3MTNdICBbPGQyM2VlY2U2Pl0gPyBt
YXliZV9saW5rLnBhcnQuMisweGU0LzB4ZTQKWyAgICAwLjc1NjcxM10gIFs8ZDFjMDA0MjY+
XSBkb19vbmVfaW5pdGNhbGwrMHg3Zi8weDFiOQpbICAgIDAuNzU2NzEzXSAgWzxkMjNlZWNl
Nj5dID8gbWF5YmVfbGluay5wYXJ0LjIrMHhlNC8weGU0ClsgICAgMC43NTY3MTNdICBbPGQx
YzQzMWViPl0gPyBwYXJhbWVxKzB4MTMvMHg1ZQpbICAgIDAuNzU2NzEzXSAgWzxkMjNlZDU5
Yj5dID8gcmVwYWlyX2Vudl9zdHJpbmcrMHgxMi8weDUxClsgICAgMC43NTY3MTNdICBbPGQx
YzQzNDFlPl0gPyBwYXJzZV9hcmdzKzB4MWU4LzB4MzE4ClsgICAgMC43NTY3MTNdICBbPGQx
YzNkOTZhPl0gPyBfX3VzZXJtb2RlaGVscGVyX3NldF9kaXNhYmxlX2RlcHRoKzB4M2UvMHg0
NApbICAgIDAuNzU2NzEzXSAgWzxkMjNlZGNlNz5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4
ZGUvMHgxNzgKWyAgICAwLjc1NjcxM10gIFs8ZDIzZWQ1ODk+XSA/IGluaXRjYWxsX2JsYWNr
bGlzdCsweDgxLzB4ODEKWyAgICAwLjc1NjcxM10gIFs8ZDIwN2FkMjA+XSBrZXJuZWxfaW5p
dCsweGIvMHhjNwpbICAgIDAuNzU2NzEzXSAgWzxkMWM0YmFkZT5dID8gc2NoZWR1bGVfdGFp
bCsweGMvMHgzYQpbICAgIDAuNzU2NzEzXSAgWzxkMjA4NzU0MD5dIHJldF9mcm9tX2tlcm5l
bF90aHJlYWQrMHgyMC8weDMwClsgICAgMC43NTY3MTNdICBbPGQyMDdhZDE1Pl0gPyByZXN0
X2luaXQrMHhiNS8weGI1ClsgICAgMC43NTY3MTNdIENvZGU6IDg5IDRkIGM0IDM5IGM3IDc0
IDQxIDhiIDRkIGM4IDMzIDQ4IDBjIDhiIDUwIDA4IDMxIGRhIDA5IGQxIDBmIDg0IDU5IDAz
IDAwIDAwIDhiIDU1IGM0IDg5IDc1IGI4IDhiIDQ1IGM4IDg5IDQ1IGM0IGViIDEzIDhiIDRk
IGM0IDwzMz4gNDggMGMgOGIgNzAgMDggMzEgZGUgMDkgZjEgMGYgODQgMzggMDMgMDAgMDAg
OGIgNDIgMDQgOGQgNTAKWyAgICAwLjc1NjcxM10gRUlQOiBbPGQxYzU3OTIxPl0gdmFsaWRh
dGVfY2hhaW4uaXNyYS4zNysweGM1LzB4MTBlNSBTUzpFU1AgMDA2ODpkMDQ0ZGQ3NApbICAg
IDAuNzU2NzEzXSBDUjI6IDAwMDAwMDAwMDAwMDAwMGMKWyAgICAwLjc1NjcxM10gLS0tWyBl
bmQgdHJhY2UgZWZhNzBjNTJjMzA5MTNjMyBdLS0tClsgICAgMC43NTY3MTNdIG5vdGU6IHN3
YXBwZXJbMV0gZXhpdGVkIHdpdGggcHJlZW1wdF9jb3VudCAxCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWliMS0wNzI1MTE1My84MmUxM2M3MWJjNjU1YjZkYzcxMTBkYTRlMTY0MDc5ZGFk
YjQ0ODkyL2RtZXNnLXF1YW50YWwtaXZiNDQtNTM6MjAxNDA3MjUyMDAxMTM6aTM4Ni1yYW5k
Y29uZmlnLWliMS0wNzI1MTE1Mzo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1
MTE1My84MmUxM2M3MWJjNjU1YjZkYzcxMTBkYTRlMTY0MDc5ZGFkYjQ0ODkyL2RtZXNnLXF1
YW50YWwtaXZiNDQtMTExOjIwMTQwNzI1MjAwMTIyOmkzODYtcmFuZGNvbmZpZy1pYjEtMDcy
NTExNTM6Ogo0NDA6MjoxMCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKCj09PT09PT09
PSBuZXh0L21hc3RlciA9PT09PT09PT0KRnJvbSBnaXQ6Ly9naXRtaXJyb3IvbmV4dAogKyAy
MThlNTljLi4uODAwOWRjOSBha3BtICAgICAgIC0+IG5leHQvYWtwbSAgKGZvcmNlZCB1cGRh
dGUpCiArIGQxYTgzZjIuLi40ZDE5NTQzIGFrcG0tYmFzZSAgLT4gbmV4dC9ha3BtLWJhc2Ug
IChmb3JjZWQgdXBkYXRlKQogKyAxYTU4ZDk5Li4uNWE3NDM5ZSBtYXN0ZXIgICAgIC0+IG5l
eHQvbWFzdGVyICAoZm9yY2VkIHVwZGF0ZSkKICAgYjI5MmQ2Yi4uODJlMTNjNyAgc3RhYmxl
ICAgICAtPiBuZXh0L3N0YWJsZQpGcm9tIGdpdDovL2dpdG1pcnJvci9uZXh0CiAqIFtuZXcg
dGFnXSAgICAgICAgIG5leHQtMjAxNDA3MjUgLT4gbmV4dC0yMDE0MDcyNQpQcmV2aW91cyBI
RUFEIHBvc2l0aW9uIHdhcyA4MmUxM2M3Li4uIE1lcmdlIGJyYW5jaCAnZm9yLTMuMTYnIG9m
IGdpdDovL2xpbnV4LW5mcy5vcmcvfmJmaWVsZHMvbGludXgKSEVBRCBpcyBub3cgYXQgNWE3
NDM5ZS4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAxNDA3MjUKbHMg
LWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcy
NTExNTMvbmV4dDptYXN0ZXI6NWE3NDM5ZWZkMWM1YzQxNmY3NjhmYzU1MDA0OGNhMTMwY2Y0
YmY5OTpiaXNlY3QtbGludXgtOQoKMjAxNC0wNy0yNS0yMDowNzo0MiA1YTc0MzllZmQxYzVj
NDE2Zjc2OGZjNTUwMDQ4Y2ExMzBjZjRiZjk5IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFz
ayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcy
NTExNTMtNWE3NDM5ZWZkMWM1YzQxNmY3NjhmYzU1MDA0OGNhMTMwY2Y0YmY5OQpDaGVjayBm
b3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My81YTc0
MzllZmQxYzVjNDE2Zjc2OGZjNTUwMDQ4Y2ExMzBjZjRiZjk5CndhaXRpbmcgZm9yIGNvbXBs
ZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaWIx
LTA3MjUxMTUzLTVhNzQzOWVmZDFjNWM0MTZmNzY4ZmM1NTAwNDhjYTEzMGNmNGJmOTkKd2Fp
dGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2pha2V0
b3duLWNvbnN1bWVyL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMtNWE3NDM5ZWZkMWM1
YzQxNmY3NjhmYzU1MDA0OGNhMTMwY2Y0YmY5OQprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWliMS0wNzI1MTE1My81YTc0MzllZmQxYzVjNDE2Zjc2OGZjNTUwMDQ4Y2ExMzBj
ZjRiZjk5L3ZtbGludXotMy4xNi4wLXJjNi1uZXh0LTIwMTQwNzI1CgoyMDE0LTA3LTI1LTIw
OjEzOjQyIGRldGVjdGluZyBib290IHN0YXRlIAkyIFRFU1QgRkFJTFVSRQpbICAgIDAuNjQ1
MTM5XSBQQ0k6IENMUyAwIGJ5dGVzLCBkZWZhdWx0IDY0ClsgICAgMC42NDY0MDVdIFVucGFj
a2luZyBpbml0cmFtZnMuLi4KWyAgICAwLjY1MDYwMF0gSW5pdHJhbWZzIHVucGFja2luZyBm
YWlsZWQ6IGp1bmsgaW4gY29tcHJlc3NlZCBhcmNoaXZlClsgICAgMC42NTI5MTBdIEJVRzog
dW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0IDAw
MDAwMDBjClsgICAgMC42NTQ1NTFdIElQOiBbPGQxYzUyZDgxPl0gdmFsaWRhdGVfY2hhaW4u
aXNyYS4zNysweGM1LzB4MTBlNQpbICAgIDAuNjU1OTIyXSAqcGRwdCA9IDAwMDAwMDAwMDAw
MDAwMDAgKnBkZSA9IGYwMDBmZjUzZjAwMGZmNTMgClsgICAgMC42NTYyMzVdIE9vcHM6IDAw
MDAgWyMxXSBQUkVFTVBUIApbICAgIDAuNjU2MjM1XSBNb2R1bGVzIGxpbmtlZCBpbjoKWyAg
ICAwLjY1NjIzNV0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMu
MTYuMC1yYzYtbmV4dC0yMDE0MDcyNSAjNgpbICAgIDAuNjU2MjM1XSBIYXJkd2FyZSBuYW1l
OiBRRU1VIFN0YW5kYXJkIFBDIChpNDQwRlggKyBQSUlYLCAxOTk2KSwgQklPUyBCb2NocyAw
MS8wMS8yMDExClsgICAgMC42NTYyMzVdIHRhc2s6IGQwNDRhMDEwIHRpOiBkMDQ0YzAwMCB0
YXNrLnRpOiBkMDQ0YzAwMApbICAgIDAuNjU2MjM1XSBFSVA6IDAwNjA6WzxkMWM1MmQ4MT5d
IEVGTEFHUzogMDAwMTAwODYgQ1BVOiAwClsgICAgMC42NTYyMzVdIEVJUCBpcyBhdCB2YWxp
ZGF0ZV9jaGFpbi5pc3JhLjM3KzB4YzUvMHgxMGU1ClsgICAgMC42NTYyMzVdIEVBWDogMDAw
MDAwMDAgRUJYOiAwMDAwMDAwZSBFQ1g6IDAwMDAwMDAwIEVEWDogZmZmZmZmZmMKWyAgICAw
LjY1NjIzNV0gRVNJOiBkMDQ0YTRmNCBFREk6IGQyODgzMzQ4IEVCUDogZDA0NGRkNmMgRVNQ
OiBkMDQ0ZGQwOApbICAgIDAuNjU2MjM1XSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwMDAg
R1M6IDAwZTAgU1M6IDAwNjgKWyAgICAwLjY1NjIzNV0gQ1IwOiA4MDA1MDAzYiBDUjI6IDAw
MDAwMDBjIENSMzogMTI0NjcwMDAgQ1I0OiAwMDAwMDZiMApbICAgIDAuNjU2MjM1XSBTdGFj
azoKWyAgICAwLjY1NjIzNV0gIDAwMDAwMDBlIGQwNDRkZDE0IGQxYzI0M2FlIGQwNDRkZDFj
IGQxYzA3ZDA1IGQwNDRkZDQ4IGQyOGEyN2UwIGQwNDRhNGY0ClsgICAgMC42NTYyMzVdICAw
MDAwMDAwMSBkMDQ0YTAxMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCAwMDAwMDAwMCBk
MDQ0YTAxMCAwMDAwMDAwZQpbICAgIDAuNjU2MjM1XSAgZDA0NGRkNjQgZDFjNDhhMDggMjZl
YTY2OTkgMDAwMDAwMDAgMDAwMDAwMDAgZDA0NGEwMTAgMDAwMDAwMGUgZDA0NGEwMTAKWyAg
ICAwLjY1NjIzNV0gQ2FsbCBUcmFjZToKWyAgICAwLjY1NjIzNV0gIFs8ZDFjMjQzYWU+XSA/
IGt2bV9jbG9ja19yZWFkKzB4MTMvMHgyNApbICAgIDAuNjU2MjM1XSAgWzxkMWMwN2QwNT5d
ID8gc2NoZWRfY2xvY2srMHg4LzB4YgpbICAgIDAuNjU2MjM1XSAgWzxkMWM0OGEwOD5dID8g
c2NoZWRfY2xvY2tfY3B1KzB4YjEvMHhkMApbICAgIDAuNjU2MjM1XSAgWzxkMWM1NGQwMj5d
IF9fbG9ja19hY3F1aXJlKzB4MzUwLzB4YWE1ClsgICAgMC42NTYyMzVdICBbPGQxYzI0M2Fl
Pl0gPyBrdm1fY2xvY2tfcmVhZCsweDEzLzB4MjQKWyAgICAwLjY1NjIzNV0gIFs8ZDFjMDdk
MDU+XSA/IHNjaGVkX2Nsb2NrKzB4OC8weGIKWyAgICAwLjY1NjIzNV0gIFs8ZDFjMjRlMmU+
XSA/IHB2Y2xvY2tfY2xvY2tzb3VyY2VfcmVhZCsweGJiLzB4MTQ5ClsgICAgMC42NTYyMzVd
ICBbPGQxYzU1YmE3Pl0gbG9ja19hY3F1aXJlKzB4NzcvMHg5MgpbICAgIDAuNjU2MjM1XSAg
WzxkMWM5NDRhZj5dID8gZnJlZV9wY3BwYWdlc19idWxrKzB4MWYvMHgzMGIKWyAgICAwLjY1
NjIzNV0gIFs8ZDIwOGU3Y2M+XSBfcmF3X3NwaW5fbG9jaysweDNjLzB4NjkKWyAgICAwLjY1
NjIzNV0gIFs8ZDFjOTQ0YWY+XSA/IGZyZWVfcGNwcGFnZXNfYnVsaysweDFmLzB4MzBiClsg
ICAgMC42NTYyMzVdICBbPGQxYzk0NGFmPl0gZnJlZV9wY3BwYWdlc19idWxrKzB4MWYvMHgz
MGIKWyAgICAwLjY1NjIzNV0gIFs8ZDFjOTMyNzg+XSA/IGZyZWVfcGFnZXNfcHJlcGFyZSsw
eGMxLzB4ZWEKWyAgICAwLjY1NjIzNV0gIFs8ZDFjOTQ5NDg+XSBmcmVlX2hvdF9jb2xkX3Bh
Z2UrMHgxMjMvMHgxNjQKWyAgICAwLjY1NjIzNV0gIFs8ZDFjOTQ5OWM+XSBfX2ZyZWVfcGFn
ZXMucGFydC43NCsweDEzLzB4MTgKWyAgICAwLjY1NjIzNV0gIFs8ZDFjOTQ5YWY+XSBfX2Zy
ZWVfcGFnZXMrMHhlLzB4MTAKWyAgICAwLjY1NjIzNV0gIFs8ZDFjOTRhMTA+XSBmcmVlX3Jl
c2VydmVkX2FyZWErMHg1Zi8weGRjClsgICAgMC42NTYyMzVdICBbPGQxYzI3Y2ExPl0gPyBz
ZXRfbWVtb3J5X3J3KzB4NDgvMHg0YQpbICAgIDAuNjU2MjM1XSAgWzxkMWMyNTBmMD5dIGZy
ZWVfaW5pdF9wYWdlcysweDViLzB4N2UKWyAgICAwLjY1NjIzNV0gIFs8ZDIzZjlkOTA+XSA/
IG1heWJlX2xpbmsucGFydC4yKzB4ZTQvMHhlNApbICAgIDAuNjU2MjM1XSAgWzxkMjNmOWQ5
MD5dID8gbWF5YmVfbGluay5wYXJ0LjIrMHhlNC8weGU0ClsgICAgMC42NTYyMzVdICBbPGQy
NDA2YmQzPl0gZnJlZV9pbml0cmRfbWVtKzB4MjYvMHgyYQpbICAgIDAuNjU2MjM1XSAgWzxk
MjNmOWU2Nz5dIHBvcHVsYXRlX3Jvb3RmcysweGQ3LzB4ZjkKWyAgICAwLjY1NjIzNV0gIFs8
ZDIzZjlkOTA+XSA/IG1heWJlX2xpbmsucGFydC4yKzB4ZTQvMHhlNApbICAgIDAuNjU2MjM1
XSAgWzxkMWMwMDQyNj5dIGRvX29uZV9pbml0Y2FsbCsweDdmLzB4MWI5ClsgICAgMC42NTYy
MzVdICBbPGQyM2Y5ZDkwPl0gPyBtYXliZV9saW5rLnBhcnQuMisweGU0LzB4ZTQKWyAgICAw
LjY1NjIzNV0gIFs8ZDFjNTQ2Njg+XSA/IHRyYWNlX2hhcmRpcnFzX29uX2NhbGxlcisweGVi
LzB4MWFmClsgICAgMC42NTYyMzVdICBbPGQxYzQxZDlhPl0gPyBwYXJhbWVxKzB4MTMvMHg1
ZQpbICAgIDAuNjU2MjM1XSAgWzxkMjNmODU5Yj5dID8gcmVwYWlyX2Vudl9zdHJpbmcrMHgx
Mi8weDUxClsgICAgMC42NTYyMzVdICBbPGQxYzQxZmNlPl0gPyBwYXJzZV9hcmdzKzB4MWU5
LzB4MzE5ClsgICAgMC42NTYyMzVdICBbPGQxYzNjNWRhPl0gPyBfX3VzZXJtb2RlaGVscGVy
X3NldF9kaXNhYmxlX2RlcHRoKzB4M2UvMHg0NApbICAgIDAuNjU2MjM1XSAgWzxkMjNmOGQw
OT5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4ZGUvMHgxNzgKWyAgICAwLjY1NjIzNV0gIFs8
ZDIzZjg1ODk+XSA/IGluaXRjYWxsX2JsYWNrbGlzdCsweDgxLzB4ODEKWyAgICAwLjY1NjIz
NV0gIFs8ZDIwODMwNjA+XSBrZXJuZWxfaW5pdCsweGIvMHhjNwpbICAgIDAuNjU2MjM1XSAg
WzxkMWM0NmYxNj5dID8gc2NoZWR1bGVfdGFpbCsweGMvMHgzYQpbICAgIDAuNjU2MjM1XSAg
WzxkMjA4ZjVjMD5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgyMC8weDMwClsgICAgMC42
NTYyMzVdICBbPGQyMDgzMDU1Pl0gPyByZXN0X2luaXQrMHhiNS8weGI1ClsgICAgMC42NTYy
MzVdIENvZGU6IDg5IDRkIGM0IDM5IGM3IDc0IDQxIDhiIDRkIGM4IDMzIDQ4IDBjIDhiIDUw
IDA4IDMxIGRhIDA5IGQxIDBmIDg0IDU5IDAzIDAwIDAwIDhiIDU1IGM0IDg5IDc1IGI4IDhi
IDQ1IGM4IDg5IDQ1IGM0IGViIDEzIDhiIDRkIGM0IDwzMz4gNDggMGMgOGIgNzAgMDggMzEg
ZGUgMDkgZjEgMGYgODQgMzggMDMgMDAgMDAgOGIgNDIgMDQgOGQgNTAKWyAgICAwLjY1NjIz
NV0gRUlQOiBbPGQxYzUyZDgxPl0gdmFsaWRhdGVfY2hhaW4uaXNyYS4zNysweGM1LzB4MTBl
NSBTUzpFU1AgMDA2ODpkMDQ0ZGQwOApbICAgIDAuNjU2MjM1XSBDUjI6IDAwMDAwMDAwMDAw
MDAwMGMKWyAgICAwLjY1NjIzNV0gLS0tWyBlbmQgdHJhY2UgYWQ5M2IxOTkzNjUyMDkwMyBd
LS0tClsgICAgMC42NTYyMzVdIG5vdGU6IHN3YXBwZXJbMV0gZXhpdGVkIHdpdGggcHJlZW1w
dF9jb3VudCAxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My81YTc0Mzll
ZmQxYzVjNDE2Zjc2OGZjNTUwMDQ4Y2ExMzBjZjRiZjk5L2RtZXNnLXF1YW50YWwtaXZiNDQt
MzE6MjAxNDA3MjUyMDA3MjQ6aTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1Mzo6Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1My81YTc0MzllZmQxYzVjNDE2Zjc2OGZj
NTUwMDQ4Y2ExMzBjZjRiZjk5L2RtZXNnLXF1YW50YWwtdnAtMTQ6MjAxNDA3MjUyMDEzNTQ6
aTM4Ni1yYW5kY29uZmlnLWliMS0wNzI1MTE1MzozLjE2LjAtcmM2LW5leHQtMjAxNDA3MjU6
Ngova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvNWE3NDM5ZWZkMWM1YzQx
NmY3NjhmYzU1MDA0OGNhMTMwY2Y0YmY5OS9kbWVzZy1xdWFudGFsLWl2YjQ0LTY4OjIwMTQw
NzI1MjAwNzUwOmkzODYtcmFuZGNvbmZpZy1pYjEtMDcyNTExNTM6Ogova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1pYjEtMDcyNTExNTMvNWE3NDM5ZWZkMWM1YzQxNmY3NjhmYzU1MDA0OGNh
MTMwY2Y0YmY5OS9kbWVzZy1xdWFudGFsLWl2YjQ0LTg5OjIwMTQwNzI1MjAwNzQzOmkzODYt
cmFuZGNvbmZpZy1pYjEtMDcyNTExNTM6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjEt
MDcyNTExNTMvNWE3NDM5ZWZkMWM1YzQxNmY3NjhmYzU1MDA0OGNhMTMwY2Y0YmY5OS9kbWVz
Zy1xdWFudGFsLWl2YjQ0LTEwMzoyMDE0MDcyNTIwMDc1ODppMzg2LXJhbmRjb25maWctaWIx
LTA3MjUxMTUzOjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzLzVhNzQz
OWVmZDFjNWM0MTZmNzY4ZmM1NTAwNDhjYTEzMGNmNGJmOTkvZG1lc2ctcXVhbnRhbC1pdmI0
NC02MDoyMDE0MDcyNTIwMDgxNzppMzg2LXJhbmRjb25maWctaWIxLTA3MjUxMTUzOjoKMjo2
OjYgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCg==

--JbKQpFqZXJ2T76Sg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.12.0-05711-g4788e5b"

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
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_FHANDLE is not set
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set
# CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
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
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
CONFIG_RCU_NOCB_CPU=y
CONFIG_RCU_NOCB_CPU_NONE=y
# CONFIG_RCU_NOCB_CPU_ZERO is not set
# CONFIG_RCU_NOCB_CPU_ALL is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_CGROUPS is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
CONFIG_USER_NS=y
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
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
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
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
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
CONFIG_ATARI_PARTITION=y
# CONFIG_MAC_PARTITION is not set
# CONFIG_MSDOS_PARTITION is not set
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
# CONFIG_CMDLINE_PARTITION is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
CONFIG_MPENTIUM4=y
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
CONFIG_X86_INTERNODE_CACHE_SHIFT=7
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_INTEL_USERCOPY=y
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
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_UP_APIC=y
# CONFIG_X86_UP_IOAPIC is not set
CONFIG_X86_LOCAL_APIC=y
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=m
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=m
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
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
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_ZBUD is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
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
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
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

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

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
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
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
# CONFIG_EISA is not set
CONFIG_SCx200=m
CONFIG_SCx200HR_TIMER=m
# CONFIG_ALIX is not set
# CONFIG_NET5501 is not set
CONFIG_GEOS=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_I82365 is not set
# CONFIG_TCIC is not set
CONFIG_PCMCIA_PROBE=y
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=m
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
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
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=y
# CONFIG_NET_IPGRE is not set
CONFIG_SYN_COOKIES=y
# CONFIG_NET_IPVTI is not set
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_INET_UDP_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
# CONFIG_TCP_CONG_HYBLA is not set
CONFIG_TCP_CONG_VEGAS=y
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=y
CONFIG_TCP_CONG_ILLINOIS=m
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=m
CONFIG_IPV6_ROUTER_PREF=y
# CONFIG_IPV6_ROUTE_INFO is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=m
# CONFIG_INET6_ESP is not set
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_VTI=m
# CONFIG_IPV6_SIT is not set
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_GRE=m
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETLABEL is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETWORK_PHY_TIMESTAMPING=y
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
CONFIG_TIPC=m
CONFIG_TIPC_PORTS=8191
CONFIG_ATM=y
# CONFIG_ATM_CLIP is not set
# CONFIG_ATM_LANE is not set
CONFIG_ATM_BR2684=y
CONFIG_ATM_BR2684_IPFILTER=y
# CONFIG_L2TP is not set
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_BRIDGE=m
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_VLAN_8021Q_MVRP is not set
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=m
CONFIG_IPX_INTERN=y
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=m
# CONFIG_LTPC is not set
# CONFIG_COPS is not set
# CONFIG_IPDDP is not set
# CONFIG_X25 is not set
CONFIG_LAPB=m
CONFIG_PHONET=y
CONFIG_IEEE802154=y
CONFIG_IEEE802154_6LOWPAN=m
CONFIG_MAC802154=y
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=y
CONFIG_NETLINK_MMAP=y
# CONFIG_NETLINK_DIAG is not set
CONFIG_NET_MPLS_GSO=m
CONFIG_HSR=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
# CONFIG_CAN_BCM is not set
CONFIG_CAN_GW=m

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
CONFIG_CAN_SLCAN=m
CONFIG_CAN_DEV=m
# CONFIG_CAN_CALC_BITTIMING is not set
# CONFIG_CAN_LEDS is not set
# CONFIG_CAN_MCP251X is not set
# CONFIG_PCH_CAN is not set
CONFIG_CAN_SJA1000=m
CONFIG_CAN_SJA1000_ISA=m
CONFIG_CAN_SJA1000_PLATFORM=m
CONFIG_CAN_EMS_PCMCIA=m
# CONFIG_CAN_EMS_PCI is not set
# CONFIG_CAN_PEAK_PCMCIA is not set
# CONFIG_CAN_PEAK_PCI is not set
# CONFIG_CAN_KVASER_PCI is not set
# CONFIG_CAN_PLX_PCI is not set
CONFIG_CAN_TSCAN1=m
# CONFIG_CAN_C_CAN is not set
# CONFIG_CAN_CC770 is not set
CONFIG_CAN_SOFTING=m
# CONFIG_CAN_SOFTING_CS is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
# CONFIG_IRCOMM is not set
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
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=m
# CONFIG_TOSHIBA_FIR is not set
# CONFIG_SMC_IRCC_FIR is not set
CONFIG_ALI_FIR=m
# CONFIG_VLSI_FIR is not set
CONFIG_VIA_FIR=m
CONFIG_BT=y
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
# CONFIG_BT_HCIUART_BCSP is not set
# CONFIG_BT_HCIUART_ATH3K is not set
CONFIG_BT_HCIUART_LL=y
# CONFIG_BT_HCIUART_3WIRE is not set
CONFIG_BT_HCIDTL1=m
# CONFIG_BT_HCIBT3C is not set
CONFIG_BT_HCIBLUECARD=y
# CONFIG_BT_HCIBTUART is not set
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=y
CONFIG_BT_MRVL_SDIO=m
# CONFIG_BT_WILINK is not set
CONFIG_AF_RXRPC=m
# CONFIG_AF_RXRPC_DEBUG is not set
# CONFIG_RXKAD is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_RFKILL_GPIO=y
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=m
CONFIG_CEPH_LIB_PRETTYDEBUG=y
# CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
# CONFIG_NFC is not set

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
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=m
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_DMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=16
CONFIG_CMA_SIZE_PERCENTAGE=10
# CONFIG_CMA_SIZE_SEL_MBYTES is not set
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
CONFIG_CMA_SIZE_SEL_MIN=y
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
CONFIG_CMA_AREAS=7

#
# Bus devices
#
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
# CONFIG_MTD is not set
CONFIG_PARPORT=m
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
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
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
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
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=m
# CONFIG_AD525X_DPOT_I2C is not set
CONFIG_AD525X_DPOT_SPI=m
CONFIG_DUMMY_IRQ=m
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=m
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=m
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=m
CONFIG_VMWARE_BALLOON=y
CONFIG_BMP085=y
# CONFIG_BMP085_I2C is not set
CONFIG_BMP085_SPI=y
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_LATTICE_ECP3_CONFIG=m
CONFIG_SRAM=y
CONFIG_C2PORT=m
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
CONFIG_EEPROM_AT25=m
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
CONFIG_EEPROM_93XX46=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_HAVE_IDE=y
CONFIG_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_LEGACY=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=m
# CONFIG_IDE_GD_ATA is not set
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECS=m
# CONFIG_BLK_DEV_DELKIN is not set
# CONFIG_BLK_DEV_IDECD is not set
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
# CONFIG_BLK_DEV_PLATFORM is not set
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
CONFIG_BLK_DEV_DTC2278=m
CONFIG_BLK_DEV_HT6560B=m
CONFIG_BLK_DEV_QD65XX=m
# CONFIG_BLK_DEV_UMC8672 is not set
# CONFIG_BLK_DEV_IDEDMA is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=m
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_ENCLOSURE is not set
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_PCMCIA_AHA152X=m
CONFIG_PCMCIA_FDOMAIN=m
CONFIG_PCMCIA_NINJA_SCSI=m
# CONFIG_PCMCIA_QLOGIC is not set
CONFIG_PCMCIA_SYM53C500=m
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_LOOPBACK_TARGET=m
CONFIG_ISCSI_TARGET=m
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
CONFIG_VHOST_NET=y
# CONFIG_VHOST_SCSI is not set
CONFIG_VHOST_RING=y
CONFIG_VHOST=y

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
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
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_INPORT is not set
# CONFIG_MOUSE_LOGIBM is not set
# CONFIG_MOUSE_PC110PAD is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=m
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PARKBD=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
# CONFIG_GAMEPORT is not set

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
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
CONFIG_N_GSM=y
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

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
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
# CONFIG_SERIAL_8250_FOURPORT is not set
CONFIG_SERIAL_8250_ACCENT=m
CONFIG_SERIAL_8250_BOCA=y
# CONFIG_SERIAL_8250_EXAR_ST16C554 is not set
CONFIG_SERIAL_8250_HUB6=m
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DW=m

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=y
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
CONFIG_SERIAL_IFX6X60=y
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=y
CONFIG_SERIAL_ARC_CONSOLE=y
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
# CONFIG_PRINTER is not set
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_NVRAM=m
CONFIG_DTLK=m
CONFIG_R3964=m
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
# CONFIG_CARDMAN_4000 is not set
CONFIG_CARDMAN_4040=m
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=m
CONFIG_PC8736x_GPIO=y
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
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=m
CONFIG_I2C_MUX_PCA9541=m
CONFIG_I2C_MUX_PCA954x=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=m
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
CONFIG_I2C_CBUS_GPIO=m
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=m
# CONFIG_I2C_KEMPLD is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=m
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_TAOS_EVM=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_ELEKTOR=m
# CONFIG_I2C_PCA_ISA is not set
# CONFIG_SCx200_I2C is not set
# CONFIG_SCx200_ACB is not set
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_LM70_LLP=m
CONFIG_SPI_OC_TINY=m
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=m
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_XCOMM=m
CONFIG_SPI_XILINX=y
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_TLE62X0 is not set
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
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_PARPORT=m
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
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=m
# CONFIG_GPIO_DA9052 is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=m
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_F7188X=m
# CONFIG_GPIO_TS5500 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=m
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_SX150X is not set
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
# CONFIG_GPIO_MCP23S08 is not set
CONFIG_GPIO_MC33880=m
# CONFIG_GPIO_74X164 is not set

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#
CONFIG_GPIO_KEMPLD=m

#
# MODULbus GPIO expanders:
#

#
# USB GPIO expanders:
#
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_DS1WM=m
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=m
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=m
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=m
CONFIG_W1_SLAVE_DS28E04=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
CONFIG_WM831X_BACKUP=m
# CONFIG_WM831X_POWER is not set
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2760=m
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=m
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_SBS=m
CONFIG_BATTERY_BQ27x00=m
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
# CONFIG_BATTERY_DA9052 is not set
CONFIG_BATTERY_MAX17040=m
CONFIG_BATTERY_MAX17042=m
CONFIG_CHARGER_PCF50633=m
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_BQ2415X=m
CONFIG_CHARGER_BQ24190=m
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_SMB347 is not set
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=m
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_ADM1021=m
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7310=m
CONFIG_SENSORS_ADT7410=m
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_G762=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=m
# CONFIG_SENSORS_HTU21 is not set
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IBMAEM=m
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=m
CONFIG_SENSORS_LINEAGE=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95234=m
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MCP3021 is not set
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_LM25066 is not set
CONFIG_SENSORS_LTC2978=m
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX34440 is not set
CONFIG_SENSORS_MAX8688=m
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
CONFIG_SENSORS_ZL6100=m
CONFIG_SENSORS_SHT15=m
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_ADS7871=m
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=m
# CONFIG_SENSORS_INA2XX is not set
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_WM831X=m
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_MC13783_ADC=m

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
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=m

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
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_HOST_SOC=y
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
CONFIG_MFD_CROS_EC=m
CONFIG_MFD_CROS_EC_I2C=m
# CONFIG_MFD_CROS_EC_SPI is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13783=m
CONFIG_MFD_MC13XXX=m
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_MFD_MC13XXX_I2C=m
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=m
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_RETU=m
CONFIG_MFD_PCF50633=m
CONFIG_PCF50633_ADC=m
# CONFIG_PCF50633_GPIO is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=m
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=m
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=m
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=m
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=m
CONFIG_MFD_LM3533=m
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=m
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_AD5398 is not set
# CONFIG_REGULATOR_DA9052 is not set
CONFIG_REGULATOR_DA9210=m
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_GPIO=m
# CONFIG_REGULATOR_ISL6271A is not set
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=m
# CONFIG_REGULATOR_LP872X is not set
# CONFIG_REGULATOR_LP8755 is not set
CONFIG_REGULATOR_MAX1586=m
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8952=m
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MC13XXX_CORE=m
# CONFIG_REGULATOR_MC13783 is not set
CONFIG_REGULATOR_MC13892=m
CONFIG_REGULATOR_PCF50633=m
CONFIG_REGULATOR_PFUZE100=m
CONFIG_REGULATOR_TPS51632=m
CONFIG_REGULATOR_TPS6105X=m
CONFIG_REGULATOR_TPS62360=m
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=m
CONFIG_REGULATOR_TPS6524X=m
# CONFIG_REGULATOR_WM831X is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_RC_SUPPORT=y
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2=m
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_V4L2_MEM2MEM_DEV=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_DMA_CONTIG=m
CONFIG_VIDEOBUF2_VMALLOC=m
CONFIG_VIDEO_V4L2_INT_DEVICE=m
CONFIG_DVB_CORE=m
CONFIG_DVB_NET=y
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
# CONFIG_DVB_DYNAMIC_MINORS is not set

#
# Media drivers
#
CONFIG_RC_CORE=m
CONFIG_RC_MAP=m
CONFIG_RC_DECODERS=y
CONFIG_LIRC=m
# CONFIG_IR_LIRC_CODEC is not set
# CONFIG_IR_NEC_DECODER is not set
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
# CONFIG_IR_JVC_DECODER is not set
CONFIG_IR_SONY_DECODER=m
# CONFIG_IR_RC5_SZ_DECODER is not set
CONFIG_IR_SANYO_DECODER=m
CONFIG_IR_MCE_KBD_DECODER=m
# CONFIG_RC_DEVICES is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
CONFIG_V4L_PLATFORM_DRIVERS=y
# CONFIG_VIDEO_CAFE_CCIC is not set
# CONFIG_VIDEO_TIMBERDALE is not set
CONFIG_SOC_CAMERA=m
# CONFIG_SOC_CAMERA_PLATFORM is not set
# CONFIG_VIDEO_RCAR_VIN is not set
CONFIG_V4L_MEM2MEM_DRIVERS=y
CONFIG_VIDEO_MEM2MEM_DEINTERLACE=m
CONFIG_VIDEO_SH_VEU=m
CONFIG_V4L_TEST_DRIVERS=y
CONFIG_VIDEO_VIVI=m
CONFIG_VIDEO_MEM2MEM_TESTDEV=m

#
# Supported MMC/SDIO adapters
#
CONFIG_SMS_SDIO_DRV=m
# CONFIG_MEDIA_PARPORT_SUPPORT is not set
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_TEA575X=m
# CONFIG_RADIO_SI470X is not set
# CONFIG_RADIO_MAXIRADIO is not set
CONFIG_I2C_SI4713=m
CONFIG_RADIO_SI4713=m
# CONFIG_RADIO_TEA5764 is not set
CONFIG_RADIO_SAA7706H=m
# CONFIG_RADIO_TEF6862 is not set
CONFIG_RADIO_WL1273=m

#
# Texas Instruments WL128x FM driver (ST based)
#
CONFIG_RADIO_WL128X=m
CONFIG_V4L_RADIO_ISA_DRIVERS=y
CONFIG_RADIO_ISA=m
# CONFIG_RADIO_CADET is not set
CONFIG_RADIO_RTRACK=m
# CONFIG_RADIO_RTRACK2 is not set
CONFIG_RADIO_AZTECH=m
CONFIG_RADIO_GEMTEK=m
# CONFIG_RADIO_SF16FMI is not set
CONFIG_RADIO_SF16FMR2=m
CONFIG_RADIO_TERRATEC=m
# CONFIG_RADIO_TRUST is not set
CONFIG_RADIO_TYPHOON=m
CONFIG_RADIO_ZOLTRIX=m
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_SMS_SIANO_MDTV=m
CONFIG_SMS_SIANO_RC=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=m

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9840=m
# CONFIG_VIDEO_TEA6415C is not set
CONFIG_VIDEO_TEA6420=m
# CONFIG_VIDEO_MSP3400 is not set
CONFIG_VIDEO_CS5345=m
# CONFIG_VIDEO_CS53L32A is not set
# CONFIG_VIDEO_TLV320AIC23B is not set
CONFIG_VIDEO_UDA1342=m
CONFIG_VIDEO_WM8775=m
# CONFIG_VIDEO_WM8739 is not set
CONFIG_VIDEO_VP27SMPX=m
CONFIG_VIDEO_SONY_BTF_MPX=m

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=m

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=m
CONFIG_VIDEO_ADV7183=m
# CONFIG_VIDEO_BT819 is not set
CONFIG_VIDEO_BT856=m
CONFIG_VIDEO_BT866=m
CONFIG_VIDEO_KS0127=m
# CONFIG_VIDEO_ML86V7667 is not set
# CONFIG_VIDEO_SAA7110 is not set
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_SAA7191=m
# CONFIG_VIDEO_TVP514X is not set
CONFIG_VIDEO_TVP5150=m
CONFIG_VIDEO_TVP7002=m
CONFIG_VIDEO_TW2804=m
CONFIG_VIDEO_TW9903=m
CONFIG_VIDEO_TW9906=m
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_CX25840=m

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m
CONFIG_VIDEO_SAA7185=m
CONFIG_VIDEO_ADV7170=m
# CONFIG_VIDEO_ADV7175 is not set
# CONFIG_VIDEO_ADV7343 is not set
CONFIG_VIDEO_ADV7393=m
CONFIG_VIDEO_AK881X=m
CONFIG_VIDEO_THS8200=m

#
# Camera sensor devices
#
CONFIG_VIDEO_OV7640=m
# CONFIG_VIDEO_OV7670 is not set
CONFIG_VIDEO_VS6624=m
# CONFIG_VIDEO_MT9V011 is not set
CONFIG_VIDEO_TCM825X=m
# CONFIG_VIDEO_SR030PC30 is not set

#
# Flash devices
#

#
# Video improvement chips
#
# CONFIG_VIDEO_UPD64031A is not set
# CONFIG_VIDEO_UPD64083 is not set

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_THS7303=m
# CONFIG_VIDEO_M52790 is not set

#
# Sensors used on soc_camera driver
#

#
# soc_camera sensor drivers
#
CONFIG_SOC_CAMERA_IMX074=m
CONFIG_SOC_CAMERA_MT9M001=m
CONFIG_SOC_CAMERA_MT9M111=m
CONFIG_SOC_CAMERA_MT9T031=m
# CONFIG_SOC_CAMERA_MT9T112 is not set
CONFIG_SOC_CAMERA_MT9V022=m
# CONFIG_SOC_CAMERA_OV2640 is not set
# CONFIG_SOC_CAMERA_OV5642 is not set
CONFIG_SOC_CAMERA_OV6650=m
# CONFIG_SOC_CAMERA_OV772X is not set
CONFIG_SOC_CAMERA_OV9640=m
CONFIG_SOC_CAMERA_OV9740=m
# CONFIG_SOC_CAMERA_RJ54N1 is not set
# CONFIG_SOC_CAMERA_TW9910 is not set
CONFIG_MEDIA_TUNER=m

#
# Customize TV tuners
#
# CONFIG_MEDIA_TUNER_SIMPLE is not set
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
# CONFIG_MEDIA_TUNER_TEA5761 is not set
CONFIG_MEDIA_TUNER_TEA5767=m
# CONFIG_MEDIA_TUNER_MT20XX is not set
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2063=m
# CONFIG_MEDIA_TUNER_MT2266 is not set
CONFIG_MEDIA_TUNER_MT2131=m
# CONFIG_MEDIA_TUNER_QT1010 is not set
# CONFIG_MEDIA_TUNER_XC2028 is not set
# CONFIG_MEDIA_TUNER_XC5000 is not set
# CONFIG_MEDIA_TUNER_XC4000 is not set
# CONFIG_MEDIA_TUNER_MXL5005S is not set
# CONFIG_MEDIA_TUNER_MXL5007T is not set
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_MAX2165=m
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_MEDIA_TUNER_FC0011=m
# CONFIG_MEDIA_TUNER_FC0012 is not set
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=m
CONFIG_MEDIA_TUNER_E4000=m
CONFIG_MEDIA_TUNER_FC2580=m
# CONFIG_MEDIA_TUNER_TUA9001 is not set
CONFIG_MEDIA_TUNER_IT913X=m
CONFIG_MEDIA_TUNER_R820T=m

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=m
CONFIG_DVB_STB6100=m
# CONFIG_DVB_STV090x is not set
# CONFIG_DVB_STV6110x is not set

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=m
CONFIG_DVB_TDA18271C2DD=m

#
# DVB-S (satellite) frontends
#
# CONFIG_DVB_CX24110 is not set
# CONFIG_DVB_CX24123 is not set
# CONFIG_DVB_MT312 is not set
CONFIG_DVB_ZL10036=m
# CONFIG_DVB_ZL10039 is not set
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
# CONFIG_DVB_STV0299 is not set
# CONFIG_DVB_STV6110 is not set
# CONFIG_DVB_STV0900 is not set
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
CONFIG_DVB_VES1X93=m
# CONFIG_DVB_TUNER_ITD1000 is not set
# CONFIG_DVB_TUNER_CX24113 is not set
# CONFIG_DVB_TDA826X is not set
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_CX24117=m
# CONFIG_DVB_SI21XX is not set
CONFIG_DVB_TS2020=m
# CONFIG_DVB_DS3000 is not set
# CONFIG_DVB_MB86A16 is not set
CONFIG_DVB_TDA10071=m

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
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
# CONFIG_DVB_DIB3000MB is not set
# CONFIG_DVB_DIB3000MC is not set
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_DIB9000=m
CONFIG_DVB_TDA10048=m
CONFIG_DVB_AF9013=m
CONFIG_DVB_EC100=m
# CONFIG_DVB_HD29L2 is not set
# CONFIG_DVB_STV0367 is not set
# CONFIG_DVB_CXD2820R is not set
CONFIG_DVB_RTL2830=m
CONFIG_DVB_RTL2832=m

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
# CONFIG_DVB_BCM3510 is not set
# CONFIG_DVB_LGDT330X is not set
# CONFIG_DVB_LGDT3305 is not set
CONFIG_DVB_LG2160=m
# CONFIG_DVB_S5H1409 is not set
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_DTV=m
CONFIG_DVB_AU8522_V4L=m
# CONFIG_DVB_S5H1411 is not set

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=m
# CONFIG_DVB_DIB8000 is not set
# CONFIG_DVB_MB86A20S is not set

#
# Digital terrestrial only tuners/PLL
#
# CONFIG_DVB_PLL is not set
# CONFIG_DVB_TUNER_DIB0070 is not set
# CONFIG_DVB_TUNER_DIB0090 is not set

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=m
# CONFIG_DVB_LNBP22 is not set
# CONFIG_DVB_ISL6405 is not set
CONFIG_DVB_ISL6421=m
# CONFIG_DVB_ISL6423 is not set
CONFIG_DVB_A8293=m
CONFIG_DVB_LGS8GL5=m
# CONFIG_DVB_LGS8GXX is not set
# CONFIG_DVB_ATBM8830 is not set
CONFIG_DVB_TDA665x=m
CONFIG_DVB_IX2505V=m
CONFIG_DVB_IT913X_FE=m
# CONFIG_DVB_M88RS2000 is not set
CONFIG_DVB_AF9033=m

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
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
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
CONFIG_FB_ARC=m
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=m
CONFIG_FB_VESA=y
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=y
CONFIG_FB_S1D13XXX=m
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
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_GOLDFISH is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=m
CONFIG_FB_AUO_K1900=m
# CONFIG_FB_AUO_K1901 is not set
CONFIG_FB_SIMPLE=y
# CONFIG_EXYNOS_VIDEO is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_MDA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=m
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
# CONFIG_SND is not set
CONFIG_SOUND_PRIME=m
# CONFIG_SOUND_MSNDCLAS is not set
# CONFIG_SOUND_MSNDPIN is not set
# CONFIG_SOUND_OSS is not set

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
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=m
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=m
CONFIG_MMC_WBSD=m
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SPI is not set
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=m
# CONFIG_LEDS_NET48XX is not set
CONFIG_LEDS_WRAP=m
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_LP5562=m
CONFIG_LEDS_LP8501=m
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_PCA9685 is not set
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_DA9052=m
CONFIG_LEDS_DAC124S085=m
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
# CONFIG_LEDS_LT3593 is not set
# CONFIG_LEDS_MC13783 is not set
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_LM355x=m
CONFIG_LEDS_OT200=y
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
# CONFIG_LEDS_TRIGGER_CAMERA is not set
# CONFIG_ACCESSIBILITY is not set
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
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_DS3232=m
# CONFIG_RTC_DRV_MAX6900 is not set
CONFIG_RTC_DRV_RS5C372=m
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_X1205=m
# CONFIG_RTC_DRV_PCF2127 is not set
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=m
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
CONFIG_RTC_DRV_EM3027=m
CONFIG_RTC_DRV_RV3029C2=m

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
CONFIG_RTC_DRV_M41T94=y
CONFIG_RTC_DRV_DS1305=m
CONFIG_RTC_DRV_DS1390=m
CONFIG_RTC_DRV_MAX6902=y
CONFIG_RTC_DRV_R9701=y
CONFIG_RTC_DRV_RS5C348=m
CONFIG_RTC_DRV_DS3234=m
CONFIG_RTC_DRV_PCF2123=m
CONFIG_RTC_DRV_RX4581=m

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=y
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_DA9052=m
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_M48T86=y
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=m
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set
CONFIG_RTC_DRV_DS2404=y
CONFIG_RTC_DRV_WM831X=m
# CONFIG_RTC_DRV_PCF50633 is not set

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MC13XXX is not set
# CONFIG_RTC_DRV_MOXART is not set

#
# HID Sensor RTC drivers
#
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=m
# CONFIG_DW_DMAC_PCI is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
# CONFIG_ASYNC_TX_DMA is not set
CONFIG_DMATEST=y
CONFIG_AUXDISPLAY=y
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
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_ECHO is not set
CONFIG_COMEDI=m
CONFIG_COMEDI_DEBUG=y
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
CONFIG_COMEDI_MISC_DRIVERS=y
# CONFIG_COMEDI_KCOMEDILIB is not set
CONFIG_COMEDI_TEST=m
# CONFIG_COMEDI_PARPORT is not set
# CONFIG_COMEDI_SERIAL2002 is not set
# CONFIG_COMEDI_SKEL is not set
CONFIG_COMEDI_SSV_DNP=m
# CONFIG_COMEDI_ISA_DRIVERS is not set
# CONFIG_COMEDI_PCI_DRIVERS is not set
# CONFIG_COMEDI_PCMCIA_DRIVERS is not set
CONFIG_COMEDI_8255=m
CONFIG_COMEDI_FC=m
CONFIG_PANEL=m
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
# CONFIG_PANEL_CHANGE_MESSAGE is not set
# CONFIG_DX_SEP is not set
# CONFIG_ZSMALLOC is not set
# CONFIG_FB_SM7XX is not set
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_SPEAKUP=y
CONFIG_SPEAKUP_SYNTH_ACNTSA=y
CONFIG_SPEAKUP_SYNTH_ACNTPC=y
CONFIG_SPEAKUP_SYNTH_APOLLO=m
CONFIG_SPEAKUP_SYNTH_AUDPTR=m
# CONFIG_SPEAKUP_SYNTH_BNS is not set
CONFIG_SPEAKUP_SYNTH_DECTLK=y
# CONFIG_SPEAKUP_SYNTH_DECEXT is not set
CONFIG_SPEAKUP_SYNTH_DECPC=m
CONFIG_SPEAKUP_SYNTH_DTLK=y
CONFIG_SPEAKUP_SYNTH_KEYPC=m
CONFIG_SPEAKUP_SYNTH_LTLK=y
CONFIG_SPEAKUP_SYNTH_SOFT=y
CONFIG_SPEAKUP_SYNTH_SPKOUT=m
CONFIG_SPEAKUP_SYNTH_TXPRT=y
# CONFIG_SPEAKUP_SYNTH_DUMMY is not set
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=m
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
CONFIG_STAGING_MEDIA=y
# CONFIG_DVB_CXD2099 is not set
# CONFIG_VIDEO_DT3155 is not set
CONFIG_LIRC_STAGING=y
# CONFIG_LIRC_BT829 is not set
CONFIG_LIRC_PARALLEL=m
CONFIG_LIRC_SERIAL=m
# CONFIG_LIRC_SERIAL_TRANSMITTER is not set
# CONFIG_LIRC_SIR is not set
# CONFIG_LIRC_ZILOG is not set

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
CONFIG_ASHMEM=y
CONFIG_ANDROID_LOGGER=y
# CONFIG_ANDROID_TIMED_OUTPUT is not set
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
# CONFIG_ANDROID_INTF_ALARM_DEV is not set
# CONFIG_SYNC is not set
CONFIG_WIMAX_GDM72XX=m
CONFIG_WIMAX_GDM72XX_QOS=y
CONFIG_WIMAX_GDM72XX_K_MODE=y
# CONFIG_WIMAX_GDM72XX_WIMAX2 is not set
CONFIG_WIMAX_GDM72XX_SDIO=y
# CONFIG_DGRP is not set
# CONFIG_LUSTRE_FS is not set
# CONFIG_XILLYBUS is not set
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
CONFIG_CHROMEOS_LAPTOP=m
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_AMILO_RFKILL is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
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
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_ARM_ARCH_TIMER_EVTSTREAM is not set
# CONFIG_MAILBOX is not set
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
CONFIG_EXTCON_GPIO=m
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=m
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=m

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=m
# CONFIG_DMIID is not set
CONFIG_DMI_SYSFS=m
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
# CONFIG_EXT2_FS_POSIX_ACL is not set
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4_USE_FOR_EXT23 is not set
CONFIG_EXT4_FS_POSIX_ACL=y
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_EXT4_DEBUG=y
CONFIG_FS_XIP=y
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
CONFIG_XFS_WARN=y
# CONFIG_XFS_DEBUG is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=m
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_FSCACHE_OBJECT_LIST=y
CONFIG_CACHEFILES=m
CONFIG_CACHEFILES_DEBUG=y
CONFIG_CACHEFILES_HISTOGRAM=y

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=m
CONFIG_ECRYPT_FS=m
CONFIG_ECRYPT_FS_MESSAGING=y
CONFIG_HFS_FS=y
# CONFIG_HFSPLUS_FS is not set
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
# CONFIG_BFS_FS is not set
CONFIG_EFS_FS=m
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
CONFIG_VXFS_FS=m
CONFIG_MINIX_FS=m
# CONFIG_OMFS_FS is not set
CONFIG_HPFS_FS=m
# CONFIG_QNX4FS_FS is not set
CONFIG_QNX6FS_FS=m
# CONFIG_QNX6FS_DEBUG is not set
CONFIG_ROMFS_FS=m
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
# CONFIG_PSTORE_RAM is not set
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
CONFIG_UFS_DEBUG=y
# CONFIG_F2FS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=m
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=m
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=m
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=m
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=m
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=m
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
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
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
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_PREEMPT is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_TRACE_IRQFLAGS=y
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
# CONFIG_PROVE_RCU is not set
# CONFIG_PROVE_RCU_DELAY is not set
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAIL_MMC_REQUEST=y
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
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
CONFIG_INTERVAL_TREE_TEST=m
CONFIG_PERCPU_TEST=m
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_KSTRTOX=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
CONFIG_DOUBLEFAULT=y
CONFIG_DEBUG_TLBFLUSH=y
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
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_NETWORK is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_YAMA=y
CONFIG_SECURITY_YAMA_STACKED=y
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
# CONFIG_INTEGRITY_AUDIT is not set
# CONFIG_IMA is not set
CONFIG_EVM=y
CONFIG_EVM_HMAC_VERSION=2
CONFIG_DEFAULT_SECURITY_YAMA=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="yama"
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
CONFIG_CRYPTO_USER=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER_X86=m
CONFIG_CRYPTO_GLUE_HELPER_X86=m

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
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=m

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
CONFIG_CRYPTO_CRC32C_INTEL=m
# CONFIG_CRYPTO_CRC32 is not set
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=m
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST_COMMON=m
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=m
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=m
CONFIG_CRYPTO_USER_API_HASH=m
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_LGUEST=m
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
CONFIG_CRC_T10DIF=m
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_AUDIT_GENERIC=y
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
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_FONT_SUPPORT=m
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y

--JbKQpFqZXJ2T76Sg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--JbKQpFqZXJ2T76Sg--
