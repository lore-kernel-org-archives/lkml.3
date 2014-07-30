Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbaG3Pxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 11:53:40 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:35717 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbaG3Pxi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 11:53:38 -0400
Date: Wed, 30 Jul 2014 08:53:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RCU] BUG: sleeping function called from invalid context at
 kernel/rcu/update.c:871
Message-ID: <20140730155332.GN11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140730034047.GA16537@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140730034047.GA16537@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14073015-1542-0000-0000-000003A55DF3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 11:40:47AM +0800, Fengguang Wu wrote:
> Greetings,
> 
> 0day kernel testing robot got the below dmesg and the first bad commit is
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu_tasks.2014.07.28d
> commit bd14ddc45614b61210fdf0ee4e94152948dd9d5e
> Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> AuthorDate: Mon Jul 28 12:41:25 2014 -0700
> Commit:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> CommitDate: Mon Jul 28 14:57:56 2014 -0700
> 
>     rcu: Make RCU-tasks track exiting tasks
>     
>     This commit adds synchronization with exiting tasks, so that RCU-tasks
>     avoids waiting on tasks that no longer exist.
>     
>     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>     
>     Conflicts:
>     	kernel/rcu/update.c
> 
> +--------------------------------------------------------------------------+------------+------------+
> |                                                                          | 4e73c5aafb | bd14ddc456 |
> +--------------------------------------------------------------------------+------------+------------+
> | boot_successes                                                           | 60         | 0          |
> | boot_failures                                                            | 0          | 20         |
> | BUG:sleeping_function_called_from_invalid_context_at_kernel/rcu/update.c | 0          | 20         |
> | backtrace:do_group_exit                                                  | 0          | 20         |
> | backtrace:SyS_exit_group                                                 | 0          | 20         |
> | backtrace:do_exit                                                        | 0          | 0          |
> +--------------------------------------------------------------------------+------------+------------+
> 
> [    4.702913] Freeing unused kernel memory: 2000K (ffff88000200c000 - ffff880002200000)
> [    4.730428] Freeing unused kernel memory: 1880K (ffff88000262a000 - ffff880002800000)
> [    4.770934] random: init urandom read with 6 bits of entropy available
> [    4.793994] BUG: sleeping function called from invalid context at kernel/rcu/update.c:871
> [    4.802080] in_atomic(): 1, irqs_disabled(): 0, pid: 94, name: hostname
> [    4.808864] CPU: 0 PID: 94 Comm: hostname Not tainted 3.16.0-rc1-00010-gbd14ddc #1
> [    4.814520] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> [    4.821278]  ffff88000f2acac0 ffff88001322fe88 ffffffff81fdcc15 ffff88000f2acad0
> [    4.829295]  ffff88001322fe98 ffffffff810cc549 ffff88001322feb0 ffffffff811099f9
> [    4.837254]  ffff88000f2ad0d8 ffff88001322fec0 ffffffff81110a01 ffff88001322ff38
> [    4.845685] Call Trace:
> [    4.849022]  [<ffffffff81fdcc15>] dump_stack+0x85/0xba
> [    4.853129]  [<ffffffff810cc549>] __might_sleep+0x129/0x180

OK, looks like I need to invoke exit_rcu_tasks() a few lines earlier
in do_exit().  Good catch!

							Thanx, Paul

> [    4.857319]  [<ffffffff811099f9>] exit_rcu_tasks+0x29/0xa0
> [    4.861615]  [<ffffffff81110a01>] exit_rcu+0x11/0x20
> [    4.865672]  [<ffffffff81097e65>] do_exit+0xa05/0xfc0
> [    4.870864]  [<ffffffff810985b6>] do_group_exit+0x46/0x130
> [    4.875191]  [<ffffffff810986b7>] SyS_exit_group+0x17/0x20
> [    4.878693]  [<ffffffff81ff1ba9>] system_call_fastpath+0x16/0x1b
> [    5.081134] init: Failed to create pty - disabling logging for job
> [    5.083491] init: Temporary process spawn error: No such file or directory
> [    5.112668] init: Failed to create pty - disabling logging for job
> 
> git bisect start d4762699d270faa2e5f8cc9b4a1feefb98270e5b 64aa90f26c06e1cb2aacfb98a7d0eccfbd6c1a91 --
> git bisect good c34f8002be490ebe4490ed028648598c8067fff7  # 10:55     16+      0  Merge 'skn/cacheinfo' into devel-hourly-2014072909
> git bisect good 27df6032094f4633a974397e845f76a6ed00bf89  # 10:58     16+      0  Merge 'jolsa-perf/perf/ctf_convert_4' into devel-hourly-2014072909
> git bisect good 93bb3907de114a5ada548126cdd99475fd2b5ae8  # 11:27     16+      0  Merge 'jcmvbkbc-xtensa/xtensa-debug' into devel-hourly-2014072909
> git bisect good 8d443796938e40aeedf7e9b38d56729fc3070d18  # 12:30     16+      0  Merge 'wireless-testing/master' into devel-hourly-2014072909
> git bisect good e45ccc6c7f65c2d6823eaf4c082417c455b9af4b  # 12:38     16+      0  Merge 'robclark/msm-next' into devel-hourly-2014072909
> git bisect  bad 21fa7826ce4c9938067972a47d8fa8fdba2805a3  # 12:41      0-     16  Merge 'rcu/rcu/rcu_tasks' into devel-hourly-2014072909
> git bisect good 41d8e02382e1e79c17a78c0898bc938531000716  # 13:05     20+      0  rcutorture: Add torture tests for RCU-tasks
> git bisect good 4e73c5aafbe9108c83de0f8f5294e6ccad2e29c3  # 13:10     20+      0  rcu: Add stall-warning checks for RCU-tasks
> git bisect  bad ebc6436166ae583e6db906eb7ffdb1c198921380  # 13:21      0-      4  rcu: Improve RCU-tasks energy efficiency
> git bisect  bad bd14ddc45614b61210fdf0ee4e94152948dd9d5e  # 13:40      0-     20  rcu: Make RCU-tasks track exiting tasks
> # first bad commit: [bd14ddc45614b61210fdf0ee4e94152948dd9d5e] rcu: Make RCU-tasks track exiting tasks
> git bisect good 4e73c5aafbe9108c83de0f8f5294e6ccad2e29c3  # 13:45     60+      0  rcu: Add stall-warning checks for RCU-tasks
> git bisect  bad d4762699d270faa2e5f8cc9b4a1feefb98270e5b  # 14:30      0-     11  0day head guard for 'devel-hourly-2014072909'
> git bisect good 31dab719fa50cf56d56d3dc25980fecd336f6ca8  # 14:38     60+      0  Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
> git bisect good e40cff4a7990e5d73eaad0a2f2593fe725e24cdd  # 15:26     60+      0  Add linux-next specific files for 20140728
> 
> 
> This script may reproduce the error.
> 
> ----------------------------------------------------------------------------
> #!/bin/bash
> 
> kernel=$1
> 
> kvm=(
> 	qemu-system-x86_64
> 	-cpu kvm64
> 	-enable-kvm
> 	-kernel $kernel
> 	-m 320
> 	-smp 2
> 	-net nic,vlan=1,model=e1000
> 	-net user,vlan=1
> 	-boot order=nc
> 	-no-reboot
> 	-watchdog i6300esb
> 	-rtc base=localtime
> 	-serial stdio
> 	-display none
> 	-monitor null 
> )
> 
> append=(
> 	hung_task_panic=1
> 	earlyprintk=ttyS0,115200
> 	debug
> 	apic=debug
> 	sysrq_always_enabled
> 	rcupdate.rcu_cpu_stall_timeout=100
> 	panic=10
> 	softlockup_panic=1
> 	nmi_watchdog=panic
> 	prompt_ramdisk=0
> 	console=ttyS0,115200
> 	console=tty0
> 	vga=normal
> 	root=/dev/ram0
> 	rw
> 	drbd.minor_count=8
> )
> 
> "${kvm[@]}" --append "${append[*]}"
> ----------------------------------------------------------------------------
> 
> Thanks,
> Fengguang

> early console in setup code
> Probing EDD (edd=off to disable)... ok
> early console in decompress_kernel
> 
> Decompressing Linux... Parsing ELF... done.
> Booting the kernel.
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.16.0-rc1-00010-gbd14ddc (kbuild@lkp-hsx01) (gcc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP Tue Jul 29 21:23:40 CST 2014
> [    0.000000] Command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa1-07291824/linux-devel:devel-hourly-2014072909:bd14ddc45614b61210fdf0ee4e94152948dd9d5e:bisect-linux-3/.vmlinuz-bd14ddc45614b61210fdf0ee4e94152948dd9d5e-20140729212442-16-lkp-nex05 branch=linux-devel/devel-hourly-2014072909 BOOT_IMAGE=/kernel/x86_64-randconfig-hsxa1-07291824/bd14ddc45614b61210fdf0ee4e94152948dd9d5e/vmlinuz-3.16.0-rc1-00010-gbd14ddc drbd.minor_count=8
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] bootconsole [earlyser0] enabled
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.4 present.
> [    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> [    0.000000] Hypervisor detected: KVM
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x13ffe max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: write-back
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 0080000000 mask FF80000000 uncachable
> [    0.000000]   1 disabled
> [    0.000000]   2 disabled
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000]   8 disabled
> [    0.000000]   9 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
> [    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
> [    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
> [    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at [ffff8800000f0eb0]
> [    0.000000]   mpc: f0ec0-f0fa4
> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x03454000, 0x03454fff] PGTABLE
> [    0.000000] BRK [0x03455000, 0x03455fff] PGTABLE
> [    0.000000] BRK [0x03456000, 0x03456fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
> [    0.000000]  [mem 0x12600000-0x127fffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
> [    0.000000]  [mem 0x10000000-0x125fffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
> [    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
> [    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
> [    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
> [    0.000000] BRK [0x03457000, 0x03457fff] PGTABLE
> [    0.000000] cma: CMA: reserved 16 MiB at 11800000
> [    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
> [    0.000000] ACPI: Early table checksum verification disabled
> [    0.000000] ACPI: RSDP 0x00000000000F0D00 000014 (v00 BOCHS )
> [    0.000000] ACPI: RSDT 0x0000000013FFFC2A 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACP 0x0000000013FFF1C0 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> [    0.000000] ACPI: DSDT 0x0000000013FFE040 001180 (v01 BOCHS  BXPCDSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACS 0x0000000013FFE000 000040
> [    0.000000] ACPI: SSDT 0x0000000013FFF234 00093E (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: APIC 0x0000000013FFFB72 000080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> [    0.000000] ACPI: HPET 0x0000000013FFFBF2 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
> [    0.000000] No NUMA configuration found
> [    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
> [    0.000000] Initmem setup node 0 [mem 0x00000000-0x13ffdfff]
> [    0.000000]   NODE_DATA [mem 0x13ff9000-0x13ffdfff]
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 0:13ff8001, primary cpu clock
> [    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880010a00000-ffff880010ffffff] on node 0
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000]   Normal   empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
> [    0.000000] On node 0 totalpages: 81820
> [    0.000000]   DMA zone: 64 pages used for memmap
> [    0.000000]   DMA zone: 21 pages reserved
> [    0.000000]   DMA zone: 3998 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 1216 pages used for memmap
> [    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
> [    0.000000] ACPI: PM-Timer IO Port: 0x608
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC INT 05
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
> [    0.000000] ACPI: IRQ5 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] ACPI: IRQ10 used by override.
> [    0.000000] ACPI: IRQ11 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on KVM
> [    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880011600000 s73792 r8192 d24512 u1048576
> [    0.000000] pcpu-alloc: s73792 r8192 d24512 u1048576 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 
> [    0.000000] KVM setup async PF for cpu 0
> [    0.000000] kvm-stealtime: cpu 0, msr 1160cf00
> [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 80519
> [    0.000000] Policy zone: DMA32
> [    0.000000] Kernel command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa1-07291824/linux-devel:devel-hourly-2014072909:bd14ddc45614b61210fdf0ee4e94152948dd9d5e:bisect-linux-3/.vmlinuz-bd14ddc45614b61210fdf0ee4e94152948dd9d5e-20140729212442-16-lkp-nex05 branch=linux-devel/devel-hourly-2014072909 BOOT_IMAGE=/kernel/x86_64-randconfig-hsxa1-07291824/bd14ddc45614b61210fdf0ee4e94152948dd9d5e/vmlinuz-3.16.0-rc1-00010-gbd14ddc drbd.minor_count=8
> [    0.000000] sysrq: sysrq always enabled.
> [    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
> [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
> [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
> [    0.000000] Memory: 243912K/327280K available (16344K kernel code, 4935K rwdata, 4264K rodata, 1124K init, 6520K bss, 83368K reserved)
> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
> [    0.000000] NR_IRQS:4352 nr_irqs:512 16
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] bootconsole [earlyser0] disabled
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.16.0-rc1-00010-gbd14ddc (kbuild@lkp-hsx01) (gcc version 4.8.2 (Debian 4.8.2-18) ) #1 SMP Tue Jul 29 21:23:40 CST 2014
> [    0.000000] Command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa1-07291824/linux-devel:devel-hourly-2014072909:bd14ddc45614b61210fdf0ee4e94152948dd9d5e:bisect-linux-3/.vmlinuz-bd14ddc45614b61210fdf0ee4e94152948dd9d5e-20140729212442-16-lkp-nex05 branch=linux-devel/devel-hourly-2014072909 BOOT_IMAGE=/kernel/x86_64-randconfig-hsxa1-07291824/bd14ddc45614b61210fdf0ee4e94152948dd9d5e/vmlinuz-3.16.0-rc1-00010-gbd14ddc drbd.minor_count=8
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] bootconsole [earlyser0] enabled
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.4 present.
> [    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> [    0.000000] Hypervisor detected: KVM
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x13ffe max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: write-back
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 0080000000 mask FF80000000 uncachable
> [    0.000000]   1 disabled
> [    0.000000]   2 disabled
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000]   8 disabled
> [    0.000000]   9 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
> [    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
> [    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
> [    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at [ffff8800000f0eb0]
> [    0.000000]   mpc: f0ec0-f0fa4
> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x03454000, 0x03454fff] PGTABLE
> [    0.000000] BRK [0x03455000, 0x03455fff] PGTABLE
> [    0.000000] BRK [0x03456000, 0x03456fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x12600000-0x127fffff]
> [    0.000000]  [mem 0x12600000-0x127fffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
> [    0.000000]  [mem 0x10000000-0x125fffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
> [    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x12800000-0x13ffdfff]
> [    0.000000]  [mem 0x12800000-0x13dfffff] page 2M
> [    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
> [    0.000000] BRK [0x03457000, 0x03457fff] PGTABLE
> [    0.000000] cma: CMA: reserved 16 MiB at 11800000
> [    0.000000] RAMDISK: [mem 0x1293d000-0x13feffff]
> [    0.000000] ACPI: Early table checksum verification disabled
> [    0.000000] ACPI: RSDP 0x00000000000F0D00 000014 (v00 BOCHS )
> [    0.000000] ACPI: RSDT 0x0000000013FFFC2A 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACP 0x0000000013FFF1C0 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> [    0.000000] ACPI: DSDT 0x0000000013FFE040 001180 (v01 BOCHS  BXPCDSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACS 0x0000000013FFE000 000040
> [    0.000000] ACPI: SSDT 0x0000000013FFF234 00093E (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: APIC 0x0000000013FFFB72 000080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> [    0.000000] ACPI: HPET 0x0000000013FFFBF2 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
> [    0.000000] No NUMA configuration found
> [    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000013ffdfff]
> [    0.000000] Initmem setup node 0 [mem 0x00000000-0x13ffdfff]
> [    0.000000]   NODE_DATA [mem 0x13ff9000-0x13ffdfff]
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 0:13ff8001, primary cpu clock
> [    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880010a00000-ffff880010ffffff] on node 0
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000]   Normal   empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
> [    0.000000] On node 0 totalpages: 81820
> [    0.000000]   DMA zone: 64 pages used for memmap
> [    0.000000]   DMA zone: 21 pages reserved
> [    0.000000]   DMA zone: 3998 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 1216 pages used for memmap
> [    0.000000]   DMA32 zone: 77822 pages, LIFO batch:15
> [    0.000000] ACPI: PM-Timer IO Port: 0x608
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC INT 05
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
> [    0.000000] ACPI: IRQ5 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] ACPI: IRQ10 used by override.
> [    0.000000] ACPI: IRQ11 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on KVM
> [    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880011600000 s73792 r8192 d24512 u1048576
> [    0.000000] pcpu-alloc: s73792 r8192 d24512 u1048576 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 
> [    0.000000] KVM setup async PF for cpu 0
> [    0.000000] kvm-stealtime: cpu 0, msr 1160cf00
> [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 80519
> [    0.000000] Policy zone: DMA32
> [    0.000000] Kernel command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa1-07291824/linux-devel:devel-hourly-2014072909:bd14ddc45614b61210fdf0ee4e94152948dd9d5e:bisect-linux-3/.vmlinuz-bd14ddc45614b61210fdf0ee4e94152948dd9d5e-20140729212442-16-lkp-nex05 branch=linux-devel/devel-hourly-2014072909 BOOT_IMAGE=/kernel/x86_64-randconfig-hsxa1-07291824/bd14ddc45614b61210fdf0ee4e94152948dd9d5e/vmlinuz-3.16.0-rc1-00010-gbd14ddc drbd.minor_count=8
> [    0.000000] sysrq: sysrq always enabled.
> [    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
> [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
> [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
> [    0.000000] Memory: 243912K/327280K available (16344K kernel code, 4935K rwdata, 4264K rodata, 1124K init, 6520K bss, 83368K reserved)
> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
> [    0.000000] NR_IRQS:4352 nr_irqs:512 16
> [    0.000000] Console: colour VGA+ 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] bootconsole [earlyser0] disabled
> [    0.000000] console [ttyS0] enabled
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Detected 1994.997 MHz processor
> [    0.003000] Calibrating delay loop (skipped) preset value.. 3989.99 BogoMIPS (lpj=1994997)
> [    0.004010] pid_max: default: 32768 minimum: 301
> [    0.005058] ACPI: Core revision 20140424
> [    0.033412] ACPI: All ACPI Tables successfully acquired
> [    0.035256] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.036391] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
> [    0.037198] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
> [    0.038025] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 bytes)
> [    0.041159] Initializing cgroup subsys net_cls
> [    0.042032] Initializing cgroup subsys blkio
> [    0.043025] Initializing cgroup subsys debug
> [    0.044197] mce: CPU supports 10 MCE banks
> [    0.046064] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.046064] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
> [    0.046064] tlb_flushall_shift: 6
> [    0.048126] Freeing SMP alternatives memory: 36K (ffffffff82dec000 - ffffffff82df5000)
> [    0.056202] Getting VERSION: 1050014
> [    0.057021] Getting VERSION: 1050014
> [    0.058019] Getting ID: 0
> [    0.059032] Getting ID: ff000000
> [    0.060027] Getting LVT0: 8700
> [    0.061016] Getting LVT1: 8400
> [    0.062128] enabled ExtINT on CPU#0
> [    0.065457] ENABLING IO-APIC IRQs
> [    0.066016] init IO_APIC IRQs
> [    0.067010]  apic 0 pin 0 not connected
> [    0.068029] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
> [    0.069048] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
> [    0.070060] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
> [    0.071047] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
> [    0.072042] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
> [    0.073044] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
> [    0.074044] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
> [    0.075053] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
> [    0.076042] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
> [    0.077042] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
> [    0.078044] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
> [    0.079041] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
> [    0.080047] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
> [    0.081043] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
> [    0.082042] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
> [    0.083038]  apic 0 pin 16 not connected
> [    0.084007]  apic 0 pin 17 not connected
> [    0.085007]  apic 0 pin 18 not connected
> [    0.086007]  apic 0 pin 19 not connected
> [    0.087006]  apic 0 pin 20 not connected
> [    0.088006]  apic 0 pin 21 not connected
> [    0.089006]  apic 0 pin 22 not connected
> [    0.090007]  apic 0 pin 23 not connected
> [    0.091265] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.092006] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
> [    0.096006] Using local APIC timer interrupts.
> [    0.096006] calibrating APIC timer ...
> [    0.098000] ... lapic delta = 6249661
> [    0.098000] ... PM-Timer delta = 357934
> [    0.098000] ... PM-Timer result ok
> [    0.098000] ..... delta 6249661
> [    0.098000] ..... mult: 268420896
> [    0.098000] ..... calibration result: 999945
> [    0.098000] ..... CPU clock speed is 1994.0819 MHz.
> [    0.098000] ..... host bus clock speed is 999.0945 MHz.
> [    0.098193] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
> [    0.105076] x86: Booting SMP configuration:
> [    0.106022] .... node  #0, CPUs:      #1
> [    0.104637] kvm-clock: cpu 1, msr 0:13ff8041, secondary cpu clock
> [    0.104637] masked ExtINT on CPU#1
> [    0.122192] x86: Booted up 1 node, 2 CPUs
> [    0.123018] smpboot: Total of 2 processors activated (7979.98 BogoMIPS)
> [    0.123045] KVM setup async PF for cpu 1
> [    0.123059] kvm-stealtime: cpu 1, msr 1170cf00
> [    0.128020] devtmpfs: initialized
> [    0.130768] gcov: version magic: 0x3430382a
> [    0.134211] xor: measuring software checksum speed
> [    0.145039]    prefetch64-sse:  6060.000 MB/sec
> [    0.156017]    generic_sse:  5280.000 MB/sec
> [    0.157010] xor: using function: prefetch64-sse (6060.000 MB/sec)
> [    0.158042] prandom: seed boundary self test passed
> [    0.161370] prandom: 100 self tests passed
> [    0.162709] regulator-dummy: no parameters
> [    0.164129] NET: Registered protocol family 16
> [    0.166818] cpuidle: using governor ladder
> [    0.167018] cpuidle: using governor menu
> [    0.169136] ACPI: bus type PCI registered
> [    0.171005] PCI: Using configuration type 1 for base access
> [    0.173203] mtrr: your CPUs had inconsistent variable MTRR settings
> [    0.174005] mtrr: your CPUs had inconsistent MTRRdefType settings
> [    0.175005] mtrr: probably your BIOS does not setup all CPUs.
> [    0.176005] mtrr: corrected configuration.
> [    0.226090] raid6: sse2x1     757 MB/s
> [    0.244021] raid6: sse2x2     937 MB/s
> [    0.262053] raid6: sse2x4     929 MB/s
> [    0.263009] raid6: using algorithm sse2x2 (937 MB/s)
> [    0.264008] raid6: using intx1 recovery algorithm
> [    0.268025] ACPI: Added _OSI(Module Device)
> [    0.269008] ACPI: Added _OSI(Processor Device)
> [    0.270007] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.272008] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.296461] ACPI: Interpreter enabled
> [    0.297058] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140424/hwxface-580)
> [    0.300026] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140424/hwxface-580)
> [    0.303060] ACPI: (supports S0 S3 S5)
> [    0.304008] ACPI: Using IOAPIC for interrupt routing
> [    0.305167] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    0.336039] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    0.337047] acpi PNP0A03:00: _OSC: OS supports [Segments]
> [    0.339051] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
> [    0.342250] PCI host bridge to bus 0000:00
> [    0.343014] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    0.344016] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    0.345014] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
> [    0.346017] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
> [    0.347017] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
> [    0.348015] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
> [    0.349019] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    0.350015] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebfffff]
> [    0.351115] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
> [    0.353846] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
> [    0.356309] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
> [    0.362011] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
> [    0.365056] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
> [    0.366009] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
> [    0.367011] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
> [    0.368009] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
> [    0.370850] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
> [    0.372083] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX4 ACPI
> [    0.373031] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX4 SMB
> [    0.375161] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
> [    0.378022] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
> [    0.381020] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
> [    0.392032] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
> [    0.395210] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
> [    0.398014] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
> [    0.402010] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
> [    0.414000] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
> [    0.417553] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
> [    0.419010] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
> [    0.435155] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
> [    0.440190] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
> [    0.446036] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
> [    0.452132] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
> [    0.456435] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
> [    0.463000] ACPI: Enabled 16 GPEs in block 00 to 0F
> [    0.464396] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.465008] vgaarb: loaded
> [    0.466007] vgaarb: bridge control possible 0000:00:02.0
> [    0.470503] SCSI subsystem initialized
> [    0.471133] libata version 3.00 loaded.
> [    0.472602] pps_core: LinuxPPS API ver. 1 registered
> [    0.473007] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    0.474070] PTP clock support registered
> [    0.476167] PCI: Using ACPI for IRQ routing
> [    0.477010] PCI: pci_cache_line_size set to 64 bytes
> [    0.478259] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
> [    0.479030] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
> [    0.481444] Bluetooth: Core ver 2.19
> [    0.482069] NET: Registered protocol family 31
> [    0.483006] Bluetooth: HCI device and connection manager initialized
> [    0.484029] Bluetooth: HCI socket layer initialized
> [    0.485020] Bluetooth: L2CAP socket layer initialized
> [    0.486061] Bluetooth: SCO socket layer initialized
> [    0.487031] NET: Registered protocol family 8
> [    0.488007] NET: Registered protocol family 20
> [    0.492531] Switched to clocksource kvm-clock
> [    0.495401] pnp: PnP ACPI init
> [    0.496919] ACPI: bus type PNP registered
> [    0.498789] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
> [    0.508625] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.524318] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
> [    0.527716] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
> [    0.530317] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
> [    0.533671] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
> [    0.536369] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
> [    0.539656] pnp 00:03: [dma 2]
> [    0.541209] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
> [    0.543900] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
> [    0.547256] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
> [    0.549937] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
> [    0.553340] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
> [    0.557964] pnp: PnP ACPI: found 6 devices
> [    0.559659] ACPI: bus type PNP unregistered
> [    0.585260] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    0.587400] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
> [    0.589668] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
> [    0.591972] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
> [    0.594092] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
> [    0.596232] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
> [    0.598291] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
> [    0.600387] NET: Registered protocol family 1
> [    0.601960] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> [    0.603898] pci 0000:00:01.0: PIIX3: Enabling Passive Release
> [    0.605796] pci 0000:00:01.0: Activating ISA DMA hang workarounds
> [    0.607759] pci 0000:00:02.0: Boot video device
> [    0.609479] PCI: CLS 0 bytes, default 64
> [    0.619527] Trying to unpack rootfs image as initramfs...
> [    2.360489] Freeing initrd memory: 23244K (ffff88001293d000 - ffff880013ff0000)
> [    2.377624] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
> [    2.381314] sha1_ssse3: Neither AVX nor AVX2 nor SSSE3 is available/usable.
> [    2.383820] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
> [    2.390327] AVX or AES-NI instructions are not detected.
> [    2.392693] AVX instructions are not detected.
> [    2.394865] AVX instructions are not detected.
> [    2.396934] AVX2 or AES-NI instructions are not detected.
> [    2.400518] futex hash table entries: 512 (order: 3, 32768 bytes)
> [    2.403289] Initialise system trusted keyring
> [    3.370397] tsc: Refined TSC clocksource calibration: 1994.996 MHz
> [    3.651229] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    3.678931] VFS: Disk quotas dquot_6.5.2
> [    3.680865] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    3.689743] QNX4 filesystem 0.2.3 registered.
> [    3.692383] JFS: nTxBlock = 2215, nTxLock = 17723
> [    3.708424] msgmni has been set to 553
> [    3.715030] NET: Registered protocol family 38
> [    3.716840] Key type asymmetric registered
> [    3.718707] Asymmetric key parser 'x509' registered
> [    3.720736] bounce: pool size: 64 pages
> [    3.722894] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
> [    3.735120] io scheduler noop registered (default)
> [    3.736957] test_string_helpers: Running tests...
> [    3.741711] hgafb: HGA card not detected.
> [    3.743451] hgafb: probe of hgafb.0 failed with error -22
> [    3.761511] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [    3.764116] ACPI: Power Button [PWRF]
> [    3.942802] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [    3.998094] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> [    4.015605] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
> [    4.017740] ac.o: No PCI boards found.
> [    4.019116] ac.o: For an ISA board you must supply memory and irq parameters.
> [    4.021518] Non-volatile memory driver v1.3
> [    4.029999] ppdev: user-space parallel port driver
> [    4.031789] telclk_interrupt = 0xf non-mcpbl0010 hw.
> [    4.037156] Linux agpgart interface v0.103
> [    4.039398] [drm] Initialized drm 1.1.0 20060810
> [    4.041272] [drm] radeon kernel modesetting enabled.
> [    4.043398] drm/i810 does not support SMP
> [    4.070340] brd: module loaded
> [    4.084262] loop: module loaded
> [    4.085794] mtip32xx Version 1.3.1
> [    4.087870]  nullb0: unknown partition table
> [    4.090306]  nullb1: unknown partition table
> [    4.092163] null: module loaded
> [    4.093966] Guest personality initialized and is inactive
> [    4.096252] VMCI host device registered (name=vmci, major=10, minor=62)
> [    4.098243] Initialized host personality
> [    4.100866] Loading iSCSI transport class v2.0-870.
> [    4.112334] alua: device handler registered
> [    4.119468] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.07.00.08-k.
> [    4.123309] mpt2sas version 16.100.00.00 loaded
> [    4.125863] GDT-HA: Storage RAID Controller Driver. Version: 3.05
> [    4.128353] 3ware 9000 Storage Controller device driver for Linux v2.26.02.014.
> [    4.131952] Broadcom NetXtreme II iSCSI Driver bnx2i v2.7.6.2 (Jun 06, 2013)
> [    4.134600] iscsi: registered transport (bnx2i)
> [    4.141201] esas2r: driver will not be loaded because no ATTO esas2r devices were found
> [    4.147318] arcnet loaded.
> [    4.148860] arcnet: COM90xx IO-mapped mode support (by David Woodhouse et el.)
> [    4.151968] E-mail me if you actually test this driver, please!
> [    4.154298]  arc%d: No autoprobe for IO mapped cards; you must specify the base address!
> [    4.158050] Atheros(R) L2 Ethernet Driver - version 2.2.3
> [    4.160199] Copyright (c) 2007 Atheros Corporation.
> [    4.162590] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.20 (March 14, 2014)
> [    4.175319] sky2: driver version 1.30
> [    4.177392] QLogic 1/10 GbE Converged/Intelligent Ethernet Driver v5.3.60
> [    4.180463] PPP generic driver version 2.4.2
> [    4.182575] PPP BSD Compression module registered
> [    4.184495] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256) (6 bit encapsulation enabled).
> [    4.188645] hdlc: HDLC support module revision 1.22
> [    4.191121] adummy: version 1.0
> [    4.193081] Fusion MPT base driver 3.04.20
> [    4.194863] Copyright (c) 1999-2008 LSI Corporation
> [    4.196938] Fusion MPT SPI Host driver 3.04.20
> [    4.198949] Fusion MPT misc device (ioctl) driver 3.04.20
> [    4.201401] mptctl: Registered with Fusion MPT base driver
> [    4.203602] mptctl: /dev/mptctl @ (major,minor=10,220)
> [    4.210983] aoe: AoE v85 initialised.
> [    4.215941] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> [    4.220909] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    4.222997] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    4.226695] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
> [    4.243191] sdhci: Secure Digital Host Controller Interface driver
> [    4.248622] sdhci: Copyright(c) Pierre Ossman
> [    4.253492] wbsd: Winbond W83L51xD SD/MMC card interface driver
> [    4.259028] wbsd: Copyright(c) Pierre Ossman
> [    4.263211] sdhci-pltfm: SDHCI platform and OF driver helper
> [    4.288144] panel: driver version 0.9.5 not yet registered
> [    4.294493] cxt1e1: No boards found
> [    4.298530] input: Speakup as /devices/virtual/input/input3
> [    4.308910] initialized device: /dev/synth, node (MAJOR 10, MINOR 25)
> [    4.316654] speakup 3.1.6: initialized
> [    4.320528] synth name on entry is: (null)
> [    4.328112] ashmem: initialized
> [    4.329697] logger: created 256K log 'log_main'
> [    4.331919] logger: created 256K log 'log_events'
> [    4.333978] logger: created 256K log 'log_radio'
> [    4.336038] logger: created 256K log 'log_system'
> [    4.338272] FPGA DOWNLOAD --->
> [    4.339596] FPGA image file name: xlinx_fpga_firmware.bit
> [    4.341864] GPIO INIT FAIL!!
> [    4.345972] intel_rapl: driver does not support CPU family 15 model 6
> [    4.350425] oprofile: using NMI interrupt.
> [    4.354180] NET: Registered protocol family 15
> [    4.358634] NET: Registered protocol family 4
> [    4.362734] NET: Registered protocol family 5
> [    4.367259] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [    4.371376] Bluetooth: BNEP filters: protocol multicast
> [    4.375403] Bluetooth: BNEP socket layer initialized
> [    4.379325] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
> [    4.383552] Bluetooth: HIDP socket layer initialized
> [    4.396996] lec:lane_module_init: lec.c: initialized
> [    4.399980] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
> [    4.409950] DECnet: Routing cache hash table of 1024 buckets, 16Kbytes
> [    4.412484] NET: Registered protocol family 12
> [    4.414448] 9pnet: Installing 9P2000 support
> [    4.423508] NET: Registered protocol family 36
> [    4.428651] batman_adv: B.A.T.M.A.N. advanced 2014.3.0 (compatibility version 15) loaded
> [    4.435888] mpls_gso: MPLS GSO support
> [    4.438649] 
> [    4.438649] printing PIC contents
> [    4.440719] ... PIC  IMR: ffff
> [    4.441693] ... PIC  IRR: 1013
> [    4.443317] ... PIC  ISR: 0000
> [    4.444590] ... PIC ELCR: 0c00
> [    4.453199] printing local APIC contents on CPU#0/0:
> [    4.454183] ... APIC ID:      00000000 (0)
> [    4.454183] ... APIC VERSION: 01050014
> [    4.454183] ... APIC TASKPRI: 00000000 (00)
> [    4.454183] ... APIC PROCPRI: 00000000
> [    4.454183] ... APIC LDR: 01000000
> [    4.454183] ... APIC DFR: ffffffff
> [    4.454183] ... APIC SPIV: 000001ff
> [    4.454183] ... APIC ISR field:
> [    4.454183] 0000000000000000000000000000000000000000000000000000000000000000
> [    4.454183] ... APIC TMR field:
> [    4.454183] 0000000002000000000000000000000000000000000000000000000000000000
> [    4.454183] ... APIC IRR field:
> [    4.454183] 0000000000000000000000000000000000000000000000000000000000000000
> [    4.454183] ... APIC ESR: 00000000
> [    4.454183] ... APIC ICR: 000008fd
> [    4.454183] ... APIC ICR2: 02000000
> [    4.454183] ... APIC LVTT: 000000ef
> [    4.454183] ... APIC LVTPC: 00010000
> [    4.454183] ... APIC LVT0: 00010700
> [    4.454183] ... APIC LVT1: 00000400
> [    4.454183] ... APIC LVTERR: 000000fe
> [    4.454183] ... APIC TMICT: 01a94235
> [    4.454183] ... APIC TMCCT: 0157779b
> [    4.454183] ... APIC TDCR: 00000003
> [    4.454183] 
> [    4.533011] number of MP IRQ sources: 15.
> [    4.534818] number of IO-APIC #0 registers: 24.
> [    4.536740] testing the IO APIC.......................
> [    4.538918] IO APIC #0......
> [    4.540306] .... register #00: 00000000
> [    4.542056] .......    : physical APIC id: 00
> [    4.543962] .......    : Delivery Type: 0
> [    4.545693] .......    : LTS          : 0
> [    4.547449] .... register #01: 00170011
> [    4.549266] .......     : max redirection entries: 17
> [    4.551369] .......     : PRQ implemented: 0
> [    4.553202] .......     : IO APIC version: 11
> [    4.555059] .... register #02: 00000000
> [    4.556722] .......     : arbitration: 00
> [    4.558471] .... IRQ redirection table:
> [    4.560138] 1    0    0   0   0    0    0    00
> [    4.562031] 0    0    0   0   0    1    1    31
> [    4.563927] 0    0    0   0   0    1    1    30
> [    4.565762] 0    0    0   0   0    1    1    33
> [    4.567526] 1    0    0   0   0    1    1    34
> [    4.569210] 1    1    0   0   0    1    1    35
> [    4.570920] 0    0    0   0   0    1    1    36
> [    4.572490] 0    0    0   0   0    1    1    37
> [    4.574180] 0    0    0   0   0    1    1    38
> [    4.576220] 0    1    0   0   0    1    1    39
> [    4.578135] 1    1    0   0   0    1    1    3A
> [    4.579820] 1    1    0   0   0    1    1    3B
> [    4.581650] 0    0    0   0   0    1    1    3C
> [    4.583607] 0    0    0   0   0    1    1    3D
> [    4.585739] 0    0    0   0   0    1    1    3E
> [    4.587642] 0    0    0   0   0    1    1    3F
> [    4.589559] 1    0    0   0   0    0    0    00
> [    4.591524] 1    0    0   0   0    0    0    00
> [    4.593380] 1    0    0   0   0    0    0    00
> [    4.595320] 1    0    0   0   0    0    0    00
> [    4.597256] 1    0    0   0   0    0    0    00
> [    4.599195] 1    0    0   0   0    0    0    00
> [    4.601367] 1    0    0   0   0    0    0    00
> [    4.603600] 1    0    0   0   0    0    0    00
> [    4.605813] IRQ to pin mappings:
> [    4.607259] IRQ0 -> 0:2
> [    4.609034] IRQ1 -> 0:1
> [    4.610869] IRQ3 -> 0:3
> [    4.612718] IRQ4 -> 0:4
> [    4.614592] IRQ5 -> 0:5
> [    4.616408] IRQ6 -> 0:6
> [    4.618218] IRQ7 -> 0:7
> [    4.620073] IRQ8 -> 0:8
> [    4.621672] IRQ9 -> 0:9
> [    4.623210] IRQ10 -> 0:10
> [    4.624709] IRQ11 -> 0:11
> [    4.626484] IRQ12 -> 0:12
> [    4.628095] IRQ13 -> 0:13
> [    4.629738] IRQ14 -> 0:14
> [    4.631653] IRQ15 -> 0:15
> [    4.633654] .................................... done.
> [    4.636895] Loading compiled-in X.509 certificates
> [    4.642322] Loaded X.509 cert 'Magrathea: Glacier signing key: de0e73dcd1d4fb71cabd58b0275980997a5773be'
> [    4.660278] Btrfs loaded, assert=on, integrity-checker=on
> [    4.670234] hd: no drives specified - use hd=cyl,head,sectors on kernel command line
> [    4.680123] Freeing unused kernel memory: 1124K (ffffffff82cd3000 - ffffffff82dec000)
> [    4.683295] Write protecting the kernel read-only data: 24576k
> [    4.702913] Freeing unused kernel memory: 2000K (ffff88000200c000 - ffff880002200000)
> [    4.730428] Freeing unused kernel memory: 1880K (ffff88000262a000 - ffff880002800000)
> [    4.770934] random: init urandom read with 6 bits of entropy available
> [    4.793994] BUG: sleeping function called from invalid context at kernel/rcu/update.c:871
> [    4.802080] in_atomic(): 1, irqs_disabled(): 0, pid: 94, name: hostname
> [    4.808864] CPU: 0 PID: 94 Comm: hostname Not tainted 3.16.0-rc1-00010-gbd14ddc #1
> [    4.814520] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> [    4.821278]  ffff88000f2acac0 ffff88001322fe88 ffffffff81fdcc15 ffff88000f2acad0
> [    4.829295]  ffff88001322fe98 ffffffff810cc549 ffff88001322feb0 ffffffff811099f9
> [    4.837254]  ffff88000f2ad0d8 ffff88001322fec0 ffffffff81110a01 ffff88001322ff38
> [    4.845685] Call Trace:
> [    4.849022]  [<ffffffff81fdcc15>] dump_stack+0x85/0xba
> [    4.853129]  [<ffffffff810cc549>] __might_sleep+0x129/0x180
> [    4.857319]  [<ffffffff811099f9>] exit_rcu_tasks+0x29/0xa0
> [    4.861615]  [<ffffffff81110a01>] exit_rcu+0x11/0x20
> [    4.865672]  [<ffffffff81097e65>] do_exit+0xa05/0xfc0
> [    4.870864]  [<ffffffff810985b6>] do_group_exit+0x46/0x130
> [    4.875191]  [<ffffffff810986b7>] SyS_exit_group+0x17/0x20
> [    4.878693]  [<ffffffff81ff1ba9>] system_call_fastpath+0x16/0x1b
> [    5.081134] init: Failed to create pty - disabling logging for job
> [    5.083491] init: Temporary process spawn error: No such file or directory
> [    5.112668] init: Failed to create pty - disabling logging for job
> [    5.116411] init: Temporary process spawn error: No such file or directory
> [    5.218761] init: Failed to create pty - disabling logging for job
> [    5.220984] init: Temporary process spawn error: No such file or directory
> [    5.227731] init: Failed to create pty - disabling logging for job
> [    5.230430] init: Temporary process spawn error: No such file or directory
> [    5.365865] init: Failed to create pty - disabling logging for job
> [    5.368282] init: Temporary process spawn error: No such file or directory
> [    5.381860] init: Failed to create pty - disabling logging for job
> [    5.397554] init: Failed to create pty - disabling logging for job
> [    5.407596] init: Failed to create pty - disabling logging for job
> [    5.420115] init: Failed to create pty - disabling logging for job
> [    5.439304] init: Failed to create pty - disabling logging for job
> [    5.455575] init: Failed to create pty - disabling logging for job
> [    5.463590] init: Failed to create pty - disabling logging for job
> [    5.847252] BUG: sleeping function called from invalid context at kernel/rcu/update.c:871
> [    5.847254] in_atomic(): 1, irqs_disabled(): 0, pid: 223, name: blkid
> [    6.233627] init: Failed to create pty - disabling logging for job
> [    6.252822] init: Failed to create pty - disabling logging for job
> [    6.408431] init: Failed to create pty - disabling logging for job
> [    6.449882] init: Failed to create pty - disabling logging for job
> [    6.850709] BUG: sleeping function called from invalid context at kernel/rcu/update.c:871
> [    6.867929] in_atomic(): 1, irqs_disabled(): 0, pid: 336, name: dd
> [    6.955156] init: Failed to create pty - disabling logging for job
> [    6.984268] init: Failed to create pty - disabling logging for job
> [    7.018709] init: Failed to create pty - disabling logging for job
> [    7.025327] init: Failed to create pty - disabling logging for job
> [    7.049876] init: Failed to create pty - disabling logging for job
> Kernel tests: Boot OK!
> [    7.477133] init: Failed to create pty - disabling logging for job
> [    7.510609] init: Failed to create pty - disabling logging for job
> [    7.528460] init: Failed to create pty - disabling logging for job
> [    7.563764] init: Failed to create pty - disabling logging for job
> 
> Elapsed time: 15
> qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig-hsxa1-07291824/bd14ddc45614b61210fdf0ee4e94152948dd9d5e/vmlinuz-3.16.0-rc1-00010-gbd14ddc -append 'hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-hsxa1-07291824/linux-devel:devel-hourly-2014072909:bd14ddc45614b61210fdf0ee4e94152948dd9d5e:bisect-linux-3/.vmlinuz-bd14ddc45614b61210fdf0ee4e94152948dd9d5e-20140729212442-16-lkp-nex05 branch=linux-devel/devel-hourly-2014072909 BOOT_IMAGE=/kernel/x86_64-randconfig-hsxa1-07291824/bd14ddc45614b61210fdf0ee4e94152948dd9d5e/vmlinuz-3.16.0-rc1-00010-gbd14ddc drbd.minor_count=8'  -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz -m 320 -smp 2 -net nic,vlan=1,model=e1000 -net user,vlan=1 -boot order=nc -no-reboot -watchdog i6300esb -rtc base=localtime -pidfile /dev/shm/kboot/pid-quantal-lkp-nex05-169 -serial file:/dev/shm/kboot/serial-quantal-lkp-nex05-169 -daemonize -display none -monitor null 


> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/x86_64 3.16.0-rc1 Kernel Configuration
> #
> CONFIG_64BIT=y
> CONFIG_X86_64=y
> CONFIG_X86=y
> CONFIG_INSTRUCTION_DECODER=y
> CONFIG_OUTPUT_FORMAT="elf64-x86-64"
> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> CONFIG_MMU=y
> CONFIG_NEED_DMA_MAP_STATE=y
> CONFIG_NEED_SG_DMA_LENGTH=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_ARCH_HAS_CPU_RELAX=y
> CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
> CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
> CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
> CONFIG_ZONE_DMA32=y
> CONFIG_AUDIT_ARCH=y
> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> CONFIG_X86_64_SMP=y
> CONFIG_X86_HT=y
> CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
> CONFIG_ARCH_SUPPORTS_UPROBES=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> CONFIG_CONSTRUCTORS=y
> CONFIG_IRQ_WORK=y
> CONFIG_BUILDTIME_EXTABLE_SORT=y
> 
> #
> # General setup
> #
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_CROSS_COMPILE=""
> # CONFIG_COMPILE_TEST is not set
> CONFIG_LOCALVERSION=""
> CONFIG_LOCALVERSION_AUTO=y
> CONFIG_HAVE_KERNEL_GZIP=y
> CONFIG_HAVE_KERNEL_BZIP2=y
> CONFIG_HAVE_KERNEL_LZMA=y
> CONFIG_HAVE_KERNEL_XZ=y
> CONFIG_HAVE_KERNEL_LZO=y
> CONFIG_HAVE_KERNEL_LZ4=y
> # CONFIG_KERNEL_GZIP is not set
> # CONFIG_KERNEL_BZIP2 is not set
> # CONFIG_KERNEL_LZMA is not set
> # CONFIG_KERNEL_XZ is not set
> CONFIG_KERNEL_LZO=y
> # CONFIG_KERNEL_LZ4 is not set
> CONFIG_DEFAULT_HOSTNAME="(none)"
> # CONFIG_SWAP is not set
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> # CONFIG_POSIX_MQUEUE is not set
> CONFIG_CROSS_MEMORY_ATTACH=y
> CONFIG_FHANDLE=y
> # CONFIG_USELIB is not set
> # CONFIG_AUDIT is not set
> CONFIG_HAVE_ARCH_AUDITSYSCALL=y
> 
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_IRQ_SHOW=y
> CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
> CONFIG_GENERIC_PENDING_IRQ=y
> CONFIG_GENERIC_IRQ_CHIP=y
> CONFIG_IRQ_DOMAIN=y
> CONFIG_IRQ_DOMAIN_DEBUG=y
> CONFIG_IRQ_FORCED_THREADING=y
> CONFIG_SPARSE_IRQ=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_ARCH_CLOCKSOURCE_DATA=y
> CONFIG_GENERIC_TIME_VSYSCALL=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> 
> #
> # Timers subsystem
> #
> CONFIG_TICK_ONESHOT=y
> CONFIG_NO_HZ_COMMON=y
> # CONFIG_HZ_PERIODIC is not set
> # CONFIG_NO_HZ_IDLE is not set
> CONFIG_NO_HZ_FULL=y
> # CONFIG_NO_HZ_FULL_ALL is not set
> CONFIG_NO_HZ_FULL_SYSIDLE=y
> CONFIG_NO_HZ_FULL_SYSIDLE_SMALL=8
> CONFIG_NO_HZ=y
> CONFIG_HIGH_RES_TIMERS=y
> 
> #
> # CPU/Task time and stats accounting
> #
> CONFIG_VIRT_CPU_ACCOUNTING=y
> CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
> CONFIG_BSD_PROCESS_ACCT=y
> CONFIG_BSD_PROCESS_ACCT_V3=y
> # CONFIG_TASKSTATS is not set
> 
> #
> # RCU Subsystem
> #
> CONFIG_TREE_RCU=y
> # CONFIG_PREEMPT_RCU is not set
> CONFIG_TASKS_RCU=y
> CONFIG_RCU_STALL_COMMON=y
> CONFIG_CONTEXT_TRACKING=y
> CONFIG_RCU_USER_QS=y
> # CONFIG_CONTEXT_TRACKING_FORCE is not set
> CONFIG_RCU_FANOUT=64
> CONFIG_RCU_FANOUT_LEAF=16
> CONFIG_RCU_FANOUT_EXACT=y
> CONFIG_RCU_FAST_NO_HZ=y
> # CONFIG_TREE_RCU_TRACE is not set
> CONFIG_RCU_NOCB_CPU=y
> CONFIG_RCU_NOCB_CPU_ALL=y
> CONFIG_IKCONFIG=y
> CONFIG_IKCONFIG_PROC=y
> CONFIG_LOG_BUF_SHIFT=17
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
> CONFIG_ARCH_SUPPORTS_INT128=y
> CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
> CONFIG_ARCH_USES_NUMA_PROT_NONE=y
> # CONFIG_NUMA_BALANCING_DEFAULT_ENABLED is not set
> CONFIG_NUMA_BALANCING=y
> CONFIG_CGROUPS=y
> CONFIG_CGROUP_DEBUG=y
> # CONFIG_CGROUP_FREEZER is not set
> # CONFIG_CGROUP_DEVICE is not set
> CONFIG_CPUSETS=y
> # CONFIG_PROC_PID_CPUSET is not set
> # CONFIG_CGROUP_CPUACCT is not set
> # CONFIG_RESOURCE_COUNTERS is not set
> # CONFIG_CGROUP_PERF is not set
> CONFIG_CGROUP_SCHED=y
> CONFIG_FAIR_GROUP_SCHED=y
> CONFIG_CFS_BANDWIDTH=y
> # CONFIG_RT_GROUP_SCHED is not set
> CONFIG_BLK_CGROUP=y
> # CONFIG_DEBUG_BLK_CGROUP is not set
> # CONFIG_CHECKPOINT_RESTORE is not set
> CONFIG_NAMESPACES=y
> CONFIG_UTS_NS=y
> # CONFIG_IPC_NS is not set
> # CONFIG_USER_NS is not set
> CONFIG_PID_NS=y
> CONFIG_NET_NS=y
> CONFIG_SCHED_AUTOGROUP=y
> # CONFIG_SYSFS_DEPRECATED is not set
> CONFIG_RELAY=y
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> CONFIG_RD_GZIP=y
> CONFIG_RD_BZIP2=y
> CONFIG_RD_LZMA=y
> CONFIG_RD_XZ=y
> CONFIG_RD_LZO=y
> CONFIG_RD_LZ4=y
> # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
> CONFIG_SYSCTL=y
> CONFIG_ANON_INODES=y
> CONFIG_HAVE_UID16=y
> CONFIG_SYSCTL_EXCEPTION_TRACE=y
> CONFIG_HAVE_PCSPKR_PLATFORM=y
> # CONFIG_EXPERT is not set
> CONFIG_UID16=y
> CONFIG_SGETMASK_SYSCALL=y
> CONFIG_SYSFS_SYSCALL=y
> # CONFIG_SYSCTL_SYSCALL is not set
> CONFIG_KALLSYMS=y
> # CONFIG_KALLSYMS_ALL is not set
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_PCSPKR_PLATFORM=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_AIO=y
> CONFIG_PCI_QUIRKS=y
> # CONFIG_EMBEDDED is not set
> CONFIG_HAVE_PERF_EVENTS=y
> 
> #
> # Kernel Performance Events And Counters
> #
> CONFIG_PERF_EVENTS=y
> # CONFIG_DEBUG_PERF_USE_VMALLOC is not set
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_SLUB_DEBUG=y
> CONFIG_COMPAT_BRK=y
> # CONFIG_SLAB is not set
> CONFIG_SLUB=y
> # CONFIG_SLUB_CPU_PARTIAL is not set
> CONFIG_SYSTEM_TRUSTED_KEYRING=y
> CONFIG_PROFILING=y
> CONFIG_OPROFILE=y
> CONFIG_OPROFILE_EVENT_MULTIPLEX=y
> CONFIG_HAVE_OPROFILE=y
> CONFIG_OPROFILE_NMI_TIMER=y
> CONFIG_KPROBES=y
> # CONFIG_JUMP_LABEL is not set
> CONFIG_OPTPROBES=y
> # CONFIG_UPROBES is not set
> # CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> CONFIG_ARCH_USE_BUILTIN_BSWAP=y
> CONFIG_KRETPROBES=y
> CONFIG_HAVE_IOREMAP_PROT=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> CONFIG_HAVE_OPTPROBES=y
> CONFIG_HAVE_KPROBES_ON_FTRACE=y
> CONFIG_HAVE_ARCH_TRACEHOOK=y
> CONFIG_HAVE_DMA_ATTRS=y
> CONFIG_HAVE_DMA_CONTIGUOUS=y
> CONFIG_GENERIC_SMP_IDLE_THREAD=y
> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
> CONFIG_HAVE_DMA_API_DEBUG=y
> CONFIG_HAVE_HW_BREAKPOINT=y
> CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
> CONFIG_HAVE_USER_RETURN_NOTIFIER=y
> CONFIG_HAVE_PERF_EVENTS_NMI=y
> CONFIG_HAVE_PERF_REGS=y
> CONFIG_HAVE_PERF_USER_STACK_DUMP=y
> CONFIG_HAVE_ARCH_JUMP_LABEL=y
> CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
> CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
> CONFIG_HAVE_CMPXCHG_LOCAL=y
> CONFIG_HAVE_CMPXCHG_DOUBLE=y
> CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
> CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
> CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
> CONFIG_HAVE_CC_STACKPROTECTOR=y
> # CONFIG_CC_STACKPROTECTOR is not set
> CONFIG_CC_STACKPROTECTOR_NONE=y
> # CONFIG_CC_STACKPROTECTOR_REGULAR is not set
> # CONFIG_CC_STACKPROTECTOR_STRONG is not set
> CONFIG_HAVE_CONTEXT_TRACKING=y
> CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
> CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
> CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
> CONFIG_HAVE_ARCH_SOFT_DIRTY=y
> CONFIG_MODULES_USE_ELF_RELA=y
> CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
> CONFIG_OLD_SIGSUSPEND3=y
> CONFIG_COMPAT_OLD_SIGACTION=y
> 
> #
> # GCOV-based kernel profiling
> #
> CONFIG_GCOV_KERNEL=y
> CONFIG_GCOV_PROFILE_ALL=y
> CONFIG_GCOV_FORMAT_AUTODETECT=y
> # CONFIG_GCOV_FORMAT_3_4 is not set
> # CONFIG_GCOV_FORMAT_4_7 is not set
> # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=0
> CONFIG_MODULES=y
> CONFIG_MODULE_FORCE_LOAD=y
> # CONFIG_MODULE_UNLOAD is not set
> CONFIG_MODVERSIONS=y
> CONFIG_MODULE_SRCVERSION_ALL=y
> CONFIG_MODULE_SIG=y
> # CONFIG_MODULE_SIG_FORCE is not set
> CONFIG_MODULE_SIG_ALL=y
> # CONFIG_MODULE_SIG_SHA1 is not set
> # CONFIG_MODULE_SIG_SHA224 is not set
> CONFIG_MODULE_SIG_SHA256=y
> # CONFIG_MODULE_SIG_SHA384 is not set
> # CONFIG_MODULE_SIG_SHA512 is not set
> CONFIG_MODULE_SIG_HASH="sha256"
> CONFIG_STOP_MACHINE=y
> CONFIG_BLOCK=y
> CONFIG_BLK_DEV_BSG=y
> CONFIG_BLK_DEV_BSGLIB=y
> CONFIG_BLK_DEV_INTEGRITY=y
> # CONFIG_BLK_DEV_THROTTLING is not set
> CONFIG_BLK_CMDLINE_PARSER=y
> 
> #
> # Partition Types
> #
> CONFIG_PARTITION_ADVANCED=y
> # CONFIG_ACORN_PARTITION is not set
> CONFIG_AIX_PARTITION=y
> CONFIG_OSF_PARTITION=y
> # CONFIG_AMIGA_PARTITION is not set
> # CONFIG_ATARI_PARTITION is not set
> # CONFIG_MAC_PARTITION is not set
> # CONFIG_MSDOS_PARTITION is not set
> CONFIG_LDM_PARTITION=y
> CONFIG_LDM_DEBUG=y
> # CONFIG_SGI_PARTITION is not set
> # CONFIG_ULTRIX_PARTITION is not set
> # CONFIG_SUN_PARTITION is not set
> # CONFIG_KARMA_PARTITION is not set
> CONFIG_EFI_PARTITION=y
> # CONFIG_SYSV68_PARTITION is not set
> CONFIG_CMDLINE_PARTITION=y
> CONFIG_BLOCK_COMPAT=y
> 
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> # CONFIG_IOSCHED_DEADLINE is not set
> # CONFIG_IOSCHED_CFQ is not set
> CONFIG_DEFAULT_NOOP=y
> CONFIG_DEFAULT_IOSCHED="noop"
> CONFIG_PADATA=y
> CONFIG_ASN1=y
> CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
> CONFIG_INLINE_READ_UNLOCK=y
> CONFIG_INLINE_READ_UNLOCK_IRQ=y
> CONFIG_INLINE_WRITE_UNLOCK=y
> CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
> CONFIG_MUTEX_SPIN_ON_OWNER=y
> CONFIG_ARCH_USE_QUEUE_RWLOCK=y
> CONFIG_QUEUE_RWLOCK=y
> CONFIG_FREEZER=y
> 
> #
> # Processor type and features
> #
> CONFIG_ZONE_DMA=y
> CONFIG_SMP=y
> CONFIG_X86_MPPARSE=y
> # CONFIG_X86_EXTENDED_PLATFORM is not set
> # CONFIG_X86_INTEL_LPSS is not set
> CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
> # CONFIG_SCHED_OMIT_FRAME_POINTER is not set
> CONFIG_HYPERVISOR_GUEST=y
> CONFIG_PARAVIRT=y
> # CONFIG_PARAVIRT_DEBUG is not set
> # CONFIG_PARAVIRT_SPINLOCKS is not set
> # CONFIG_XEN is not set
> CONFIG_KVM_GUEST=y
> # CONFIG_KVM_DEBUG_FS is not set
> # CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
> CONFIG_PARAVIRT_CLOCK=y
> CONFIG_NO_BOOTMEM=y
> CONFIG_MEMTEST=y
> # CONFIG_MK8 is not set
> # CONFIG_MPSC is not set
> # CONFIG_MCORE2 is not set
> # CONFIG_MATOM is not set
> CONFIG_GENERIC_CPU=y
> CONFIG_X86_INTERNODE_CACHE_SHIFT=6
> CONFIG_X86_L1_CACHE_SHIFT=6
> CONFIG_X86_TSC=y
> CONFIG_X86_CMPXCHG64=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=64
> CONFIG_X86_DEBUGCTLMSR=y
> CONFIG_CPU_SUP_INTEL=y
> CONFIG_CPU_SUP_AMD=y
> CONFIG_CPU_SUP_CENTAUR=y
> CONFIG_HPET_TIMER=y
> CONFIG_HPET_EMULATE_RTC=y
> CONFIG_DMI=y
> # CONFIG_GART_IOMMU is not set
> CONFIG_CALGARY_IOMMU=y
> CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
> CONFIG_SWIOTLB=y
> CONFIG_IOMMU_HELPER=y
> # CONFIG_MAXSMP is not set
> CONFIG_NR_CPUS=8
> # CONFIG_SCHED_SMT is not set
> CONFIG_SCHED_MC=y
> # CONFIG_PREEMPT_NONE is not set
> CONFIG_PREEMPT_VOLUNTARY=y
> # CONFIG_PREEMPT is not set
> CONFIG_PREEMPT_COUNT=y
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
> CONFIG_X86_MCE=y
> CONFIG_X86_MCE_INTEL=y
> # CONFIG_X86_MCE_AMD is not set
> CONFIG_X86_MCE_THRESHOLD=y
> CONFIG_X86_MCE_INJECT=m
> CONFIG_X86_THERMAL_VECTOR=y
> CONFIG_X86_16BIT=y
> CONFIG_X86_ESPFIX64=y
> CONFIG_I8K=y
> CONFIG_MICROCODE=m
> CONFIG_MICROCODE_INTEL=y
> # CONFIG_MICROCODE_AMD is not set
> CONFIG_MICROCODE_OLD_INTERFACE=y
> # CONFIG_MICROCODE_INTEL_EARLY is not set
> # CONFIG_MICROCODE_AMD_EARLY is not set
> # CONFIG_X86_MSR is not set
> CONFIG_X86_CPUID=y
> CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
> CONFIG_ARCH_DMA_ADDR_T_64BIT=y
> CONFIG_DIRECT_GBPAGES=y
> CONFIG_NUMA=y
> # CONFIG_AMD_NUMA is not set
> CONFIG_X86_64_ACPI_NUMA=y
> CONFIG_NODES_SPAN_OTHER_NODES=y
> # CONFIG_NUMA_EMU is not set
> CONFIG_NODES_SHIFT=6
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_DEFAULT=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
> CONFIG_SELECT_MEMORY_MODEL=y
> CONFIG_SPARSEMEM_MANUAL=y
> CONFIG_SPARSEMEM=y
> CONFIG_NEED_MULTIPLE_NODES=y
> CONFIG_HAVE_MEMORY_PRESENT=y
> CONFIG_SPARSEMEM_EXTREME=y
> CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
> CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
> CONFIG_SPARSEMEM_VMEMMAP=y
> CONFIG_HAVE_MEMBLOCK=y
> CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
> CONFIG_ARCH_DISCARD_MEMBLOCK=y
> CONFIG_MEMORY_ISOLATION=y
> CONFIG_MOVABLE_NODE=y
> # CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
> # CONFIG_MEMORY_HOTPLUG is not set
> CONFIG_PAGEFLAGS_EXTENDED=y
> CONFIG_SPLIT_PTLOCK_CPUS=4
> CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
> # CONFIG_COMPACTION is not set
> CONFIG_MIGRATION=y
> CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
> CONFIG_PHYS_ADDR_T_64BIT=y
> CONFIG_ZONE_DMA_FLAG=1
> CONFIG_BOUNCE=y
> CONFIG_NEED_BOUNCE_POOL=y
> CONFIG_VIRT_TO_BUS=y
> # CONFIG_KSM is not set
> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
> # CONFIG_MEMORY_FAILURE is not set
> # CONFIG_TRANSPARENT_HUGEPAGE is not set
> # CONFIG_CLEANCACHE is not set
> CONFIG_CMA=y
> # CONFIG_CMA_DEBUG is not set
> # CONFIG_ZBUD is not set
> # CONFIG_ZSMALLOC is not set
> CONFIG_GENERIC_EARLY_IOREMAP=y
> CONFIG_X86_CHECK_BIOS_CORRUPTION=y
> # CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
> CONFIG_X86_RESERVE_LOW=64
> CONFIG_MTRR=y
> CONFIG_MTRR_SANITIZER=y
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> CONFIG_X86_PAT=y
> CONFIG_ARCH_USES_PG_UNCACHED=y
> CONFIG_ARCH_RANDOM=y
> CONFIG_X86_SMAP=y
> # CONFIG_EFI is not set
> # CONFIG_SECCOMP is not set
> # CONFIG_HZ_100 is not set
> # CONFIG_HZ_250 is not set
> # CONFIG_HZ_300 is not set
> CONFIG_HZ_1000=y
> CONFIG_HZ=1000
> CONFIG_SCHED_HRTICK=y
> # CONFIG_KEXEC is not set
> CONFIG_CRASH_DUMP=y
> CONFIG_PHYSICAL_START=0x1000000
> # CONFIG_RELOCATABLE is not set
> CONFIG_PHYSICAL_ALIGN=0x200000
> CONFIG_HOTPLUG_CPU=y
> # CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
> CONFIG_DEBUG_HOTPLUG_CPU0=y
> # CONFIG_COMPAT_VDSO is not set
> # CONFIG_CMDLINE_BOOL is not set
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> CONFIG_USE_PERCPU_NUMA_NODE_ID=y
> 
> #
> # Power management and ACPI options
> #
> CONFIG_SUSPEND=y
> CONFIG_SUSPEND_FREEZER=y
> CONFIG_PM_SLEEP=y
> CONFIG_PM_SLEEP_SMP=y
> # CONFIG_PM_AUTOSLEEP is not set
> # CONFIG_PM_WAKELOCKS is not set
> # CONFIG_PM_RUNTIME is not set
> CONFIG_PM=y
> # CONFIG_PM_DEBUG is not set
> CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
> CONFIG_ACPI=y
> CONFIG_ACPI_SLEEP=y
> # CONFIG_ACPI_PROCFS_POWER is not set
> # CONFIG_ACPI_EC_DEBUGFS is not set
> CONFIG_ACPI_AC=y
> CONFIG_ACPI_BATTERY=y
> CONFIG_ACPI_BUTTON=y
> CONFIG_ACPI_VIDEO=y
> CONFIG_ACPI_FAN=y
> # CONFIG_ACPI_DOCK is not set
> CONFIG_ACPI_PROCESSOR=y
> # CONFIG_ACPI_IPMI is not set
> CONFIG_ACPI_HOTPLUG_CPU=y
> # CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
> CONFIG_ACPI_THERMAL=y
> CONFIG_ACPI_NUMA=y
> CONFIG_ACPI_CUSTOM_DSDT_FILE=""
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> # CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
> # CONFIG_ACPI_DEBUG is not set
> # CONFIG_ACPI_PCI_SLOT is not set
> CONFIG_X86_PM_TIMER=y
> CONFIG_ACPI_CONTAINER=y
> # CONFIG_ACPI_SBS is not set
> # CONFIG_ACPI_HED is not set
> # CONFIG_ACPI_CUSTOM_METHOD is not set
> # CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
> # CONFIG_ACPI_APEI is not set
> # CONFIG_ACPI_EXTLOG is not set
> # CONFIG_SFI is not set
> 
> #
> # CPU Frequency scaling
> #
> # CONFIG_CPU_FREQ is not set
> 
> #
> # CPU Idle
> #
> CONFIG_CPU_IDLE=y
> CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
> CONFIG_CPU_IDLE_GOV_LADDER=y
> CONFIG_CPU_IDLE_GOV_MENU=y
> # CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
> CONFIG_INTEL_IDLE=y
> 
> #
> # Memory power savings
> #
> CONFIG_I7300_IDLE_IOAT_CHANNEL=y
> CONFIG_I7300_IDLE=y
> 
> #
> # Bus options (PCI etc.)
> #
> CONFIG_PCI=y
> CONFIG_PCI_DIRECT=y
> # CONFIG_PCI_MMCONFIG is not set
> CONFIG_PCI_DOMAINS=y
> # CONFIG_PCIEPORTBUS is not set
> # CONFIG_PCI_MSI is not set
> # CONFIG_PCI_DEBUG is not set
> CONFIG_PCI_REALLOC_ENABLE_AUTO=y
> CONFIG_PCI_STUB=y
> CONFIG_HT_IRQ=y
> CONFIG_PCI_ATS=y
> # CONFIG_PCI_IOV is not set
> CONFIG_PCI_PRI=y
> CONFIG_PCI_PASID=y
> # CONFIG_PCI_IOAPIC is not set
> CONFIG_PCI_LABEL=y
> 
> #
> # PCI host controller drivers
> #
> CONFIG_ISA_DMA_API=y
> CONFIG_AMD_NB=y
> CONFIG_PCCARD=m
> # CONFIG_PCMCIA is not set
> CONFIG_CARDBUS=y
> 
> #
> # PC-card bridges
> #
> CONFIG_YENTA=m
> CONFIG_YENTA_O2=y
> CONFIG_YENTA_RICOH=y
> CONFIG_YENTA_TI=y
> CONFIG_YENTA_ENE_TUNE=y
> CONFIG_YENTA_TOSHIBA=y
> # CONFIG_HOTPLUG_PCI is not set
> # CONFIG_RAPIDIO is not set
> CONFIG_X86_SYSFB=y
> 
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_COMPAT_BINFMT_ELF=y
> CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
> CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
> CONFIG_BINFMT_SCRIPT=y
> # CONFIG_HAVE_AOUT is not set
> CONFIG_BINFMT_MISC=y
> CONFIG_COREDUMP=y
> CONFIG_IA32_EMULATION=y
> CONFIG_IA32_AOUT=m
> # CONFIG_X86_X32 is not set
> CONFIG_COMPAT=y
> CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
> CONFIG_SYSVIPC_COMPAT=y
> CONFIG_KEYS_COMPAT=y
> CONFIG_X86_DEV_DMA_OPS=y
> CONFIG_IOSF_MBI=m
> CONFIG_NET=y
> 
> #
> # Networking options
> #
> CONFIG_PACKET=m
> CONFIG_PACKET_DIAG=m
> CONFIG_UNIX=y
> # CONFIG_UNIX_DIAG is not set
> CONFIG_XFRM=y
> CONFIG_XFRM_ALGO=y
> CONFIG_XFRM_SUB_POLICY=y
> # CONFIG_XFRM_MIGRATE is not set
> CONFIG_NET_KEY=y
> # CONFIG_NET_KEY_MIGRATE is not set
> # CONFIG_INET is not set
> CONFIG_NETWORK_SECMARK=y
> CONFIG_NET_PTP_CLASSIFY=y
> # CONFIG_NETWORK_PHY_TIMESTAMPING is not set
> # CONFIG_NETFILTER is not set
> CONFIG_ATM=y
> CONFIG_ATM_LANE=y
> CONFIG_STP=y
> CONFIG_BRIDGE=y
> CONFIG_HAVE_NET_DSA=y
> CONFIG_NET_DSA=y
> CONFIG_NET_DSA_TAG_EDSA=y
> # CONFIG_VLAN_8021Q is not set
> CONFIG_DECNET=y
> # CONFIG_DECNET_ROUTER is not set
> CONFIG_LLC=y
> # CONFIG_LLC2 is not set
> CONFIG_IPX=y
> # CONFIG_IPX_INTERN is not set
> CONFIG_ATALK=y
> # CONFIG_DEV_APPLETALK is not set
> CONFIG_X25=m
> CONFIG_LAPB=y
> # CONFIG_PHONET is not set
> CONFIG_IEEE802154=y
> CONFIG_MAC802154=m
> # CONFIG_NET_SCHED is not set
> # CONFIG_DCB is not set
> # CONFIG_DNS_RESOLVER is not set
> CONFIG_BATMAN_ADV=y
> # CONFIG_BATMAN_ADV_NC is not set
> CONFIG_BATMAN_ADV_MCAST=y
> # CONFIG_BATMAN_ADV_DEBUG is not set
> CONFIG_OPENVSWITCH=m
> CONFIG_VSOCKETS=y
> # CONFIG_VMWARE_VMCI_VSOCKETS is not set
> CONFIG_NETLINK_MMAP=y
> # CONFIG_NETLINK_DIAG is not set
> CONFIG_NET_MPLS_GSO=y
> # CONFIG_HSR is not set
> CONFIG_RPS=y
> CONFIG_RFS_ACCEL=y
> CONFIG_XPS=y
> # CONFIG_CGROUP_NET_PRIO is not set
> CONFIG_CGROUP_NET_CLASSID=y
> CONFIG_NET_RX_BUSY_POLL=y
> CONFIG_BQL=y
> # CONFIG_BPF_JIT is not set
> CONFIG_NET_FLOW_LIMIT=y
> 
> #
> # Network testing
> #
> # CONFIG_HAMRADIO is not set
> # CONFIG_CAN is not set
> CONFIG_IRDA=m
> 
> #
> # IrDA protocols
> #
> CONFIG_IRLAN=m
> CONFIG_IRNET=m
> # CONFIG_IRCOMM is not set
> CONFIG_IRDA_ULTRA=y
> 
> #
> # IrDA options
> #
> CONFIG_IRDA_CACHE_LAST_LSAP=y
> CONFIG_IRDA_FAST_RR=y
> # CONFIG_IRDA_DEBUG is not set
> 
> #
> # Infrared-port device drivers
> #
> 
> #
> # SIR device drivers
> #
> # CONFIG_IRTTY_SIR is not set
> 
> #
> # Dongle support
> #
> 
> #
> # FIR device drivers
> #
> CONFIG_NSC_FIR=m
> # CONFIG_WINBOND_FIR is not set
> CONFIG_SMC_IRCC_FIR=m
> CONFIG_ALI_FIR=m
> # CONFIG_VLSI_FIR is not set
> CONFIG_VIA_FIR=m
> CONFIG_BT=y
> # CONFIG_BT_RFCOMM is not set
> CONFIG_BT_BNEP=y
> CONFIG_BT_BNEP_MC_FILTER=y
> CONFIG_BT_BNEP_PROTO_FILTER=y
> CONFIG_BT_HIDP=y
> 
> #
> # Bluetooth device drivers
> #
> CONFIG_BT_HCIBTSDIO=m
> CONFIG_BT_HCIUART=m
> # CONFIG_BT_HCIUART_H4 is not set
> # CONFIG_BT_HCIUART_BCSP is not set
> # CONFIG_BT_HCIUART_ATH3K is not set
> # CONFIG_BT_HCIUART_LL is not set
> # CONFIG_BT_HCIUART_3WIRE is not set
> # CONFIG_BT_HCIVHCI is not set
> CONFIG_BT_MRVL=m
> CONFIG_BT_MRVL_SDIO=m
> # CONFIG_WIRELESS is not set
> # CONFIG_WIMAX is not set
> # CONFIG_RFKILL is not set
> # CONFIG_RFKILL_REGULATOR is not set
> CONFIG_NET_9P=y
> # CONFIG_NET_9P_VIRTIO is not set
> CONFIG_NET_9P_DEBUG=y
> CONFIG_CAIF=m
> # CONFIG_CAIF_DEBUG is not set
> CONFIG_CAIF_NETDEV=m
> CONFIG_CAIF_USB=m
> CONFIG_NFC=m
> CONFIG_NFC_DIGITAL=m
> CONFIG_NFC_NCI=m
> CONFIG_NFC_HCI=m
> CONFIG_NFC_SHDLC=y
> 
> #
> # Near Field Communication (NFC) devices
> #
> CONFIG_NFC_SIM=m
> CONFIG_NFC_PN544=m
> CONFIG_NFC_PN544_I2C=m
> CONFIG_NFC_MICROREAD=m
> CONFIG_NFC_MICROREAD_I2C=m
> CONFIG_NFC_MRVL=m
> # CONFIG_NFC_ST21NFCA is not set
> CONFIG_HAVE_BPF_JIT=y
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> # CONFIG_UEVENT_HELPER is not set
> CONFIG_DEVTMPFS=y
> # CONFIG_DEVTMPFS_MOUNT is not set
> # CONFIG_STANDALONE is not set
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> # CONFIG_FIRMWARE_IN_KERNEL is not set
> CONFIG_EXTRA_FIRMWARE=""
> CONFIG_FW_LOADER_USER_HELPER=y
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_GENERIC_CPU_DEVICES is not set
> CONFIG_GENERIC_CPU_AUTOPROBE=y
> CONFIG_REGMAP=y
> CONFIG_REGMAP_I2C=y
> CONFIG_REGMAP_MMIO=y
> CONFIG_REGMAP_IRQ=y
> CONFIG_DMA_SHARED_BUFFER=y
> CONFIG_DMA_CMA=y
> 
> #
> # Default contiguous memory area size:
> #
> CONFIG_CMA_SIZE_MBYTES=16
> CONFIG_CMA_SIZE_PERCENTAGE=10
> # CONFIG_CMA_SIZE_SEL_MBYTES is not set
> # CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
> CONFIG_CMA_SIZE_SEL_MIN=y
> # CONFIG_CMA_SIZE_SEL_MAX is not set
> CONFIG_CMA_ALIGNMENT=8
> CONFIG_CMA_AREAS=7
> 
> #
> # Bus devices
> #
> CONFIG_CONNECTOR=m
> CONFIG_MTD=m
> CONFIG_MTD_TESTS=m
> # CONFIG_MTD_REDBOOT_PARTS is not set
> CONFIG_MTD_CMDLINE_PARTS=m
> CONFIG_MTD_AR7_PARTS=m
> 
> #
> # User Modules And Translation Layers
> #
> CONFIG_MTD_BLKDEVS=m
> CONFIG_MTD_BLOCK=m
> # CONFIG_MTD_BLOCK_RO is not set
> CONFIG_FTL=m
> CONFIG_NFTL=m
> CONFIG_NFTL_RW=y
> # CONFIG_INFTL is not set
> CONFIG_RFD_FTL=m
> CONFIG_SSFDC=m
> # CONFIG_SM_FTL is not set
> # CONFIG_MTD_OOPS is not set
> 
> #
> # RAM/ROM/Flash chip drivers
> #
> # CONFIG_MTD_CFI is not set
> CONFIG_MTD_JEDECPROBE=m
> CONFIG_MTD_GEN_PROBE=m
> # CONFIG_MTD_CFI_ADV_OPTIONS is not set
> CONFIG_MTD_MAP_BANK_WIDTH_1=y
> CONFIG_MTD_MAP_BANK_WIDTH_2=y
> CONFIG_MTD_MAP_BANK_WIDTH_4=y
> # CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
> # CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
> # CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
> CONFIG_MTD_CFI_I1=y
> CONFIG_MTD_CFI_I2=y
> # CONFIG_MTD_CFI_I4 is not set
> # CONFIG_MTD_CFI_I8 is not set
> CONFIG_MTD_CFI_INTELEXT=m
> # CONFIG_MTD_CFI_AMDSTD is not set
> CONFIG_MTD_CFI_STAA=m
> CONFIG_MTD_CFI_UTIL=m
> CONFIG_MTD_RAM=m
> # CONFIG_MTD_ROM is not set
> CONFIG_MTD_ABSENT=m
> 
> #
> # Mapping drivers for chip access
> #
> CONFIG_MTD_COMPLEX_MAPPINGS=y
> # CONFIG_MTD_PHYSMAP is not set
> # CONFIG_MTD_SBC_GXX is not set
> # CONFIG_MTD_AMD76XROM is not set
> CONFIG_MTD_ICHXROM=m
> # CONFIG_MTD_ESB2ROM is not set
> CONFIG_MTD_CK804XROM=m
> # CONFIG_MTD_SCB2_FLASH is not set
> CONFIG_MTD_NETtel=m
> CONFIG_MTD_L440GX=m
> # CONFIG_MTD_PCI is not set
> CONFIG_MTD_GPIO_ADDR=m
> CONFIG_MTD_INTEL_VR_NOR=m
> # CONFIG_MTD_PLATRAM is not set
> CONFIG_MTD_LATCH_ADDR=m
> 
> #
> # Self-contained MTD device drivers
> #
> CONFIG_MTD_PMC551=m
> # CONFIG_MTD_PMC551_BUGFIX is not set
> CONFIG_MTD_PMC551_DEBUG=y
> CONFIG_MTD_SLRAM=m
> CONFIG_MTD_PHRAM=m
> CONFIG_MTD_MTDRAM=m
> CONFIG_MTDRAM_TOTAL_SIZE=4096
> CONFIG_MTDRAM_ERASE_SIZE=128
> # CONFIG_MTD_BLOCK2MTD is not set
> 
> #
> # Disk-On-Chip Device Drivers
> #
> CONFIG_MTD_DOCG3=m
> CONFIG_BCH_CONST_M=14
> CONFIG_BCH_CONST_T=4
> CONFIG_MTD_NAND_ECC=m
> CONFIG_MTD_NAND_ECC_SMC=y
> CONFIG_MTD_NAND=m
> # CONFIG_MTD_NAND_ECC_BCH is not set
> # CONFIG_MTD_SM_COMMON is not set
> CONFIG_MTD_NAND_DENALI=m
> # CONFIG_MTD_NAND_DENALI_PCI is not set
> CONFIG_MTD_NAND_GPIO=m
> CONFIG_MTD_NAND_IDS=m
> # CONFIG_MTD_NAND_RICOH is not set
> # CONFIG_MTD_NAND_DISKONCHIP is not set
> CONFIG_MTD_NAND_DOCG4=m
> CONFIG_MTD_NAND_CAFE=m
> CONFIG_MTD_NAND_NANDSIM=m
> CONFIG_MTD_NAND_PLATFORM=m
> CONFIG_MTD_ONENAND=m
> CONFIG_MTD_ONENAND_VERIFY_WRITE=y
> CONFIG_MTD_ONENAND_GENERIC=m
> CONFIG_MTD_ONENAND_OTP=y
> # CONFIG_MTD_ONENAND_2X_PROGRAM is not set
> 
> #
> # LPDDR & LPDDR2 PCM memory drivers
> #
> CONFIG_MTD_LPDDR=m
> CONFIG_MTD_QINFO_PROBE=m
> CONFIG_MTD_SPI_NOR=m
> # CONFIG_MTD_UBI is not set
> CONFIG_PARPORT=y
> CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
> CONFIG_PARPORT_PC=m
> # CONFIG_PARPORT_SERIAL is not set
> # CONFIG_PARPORT_PC_FIFO is not set
> CONFIG_PARPORT_PC_SUPERIO=y
> # CONFIG_PARPORT_GSC is not set
> CONFIG_PARPORT_AX88796=y
> # CONFIG_PARPORT_1284 is not set
> CONFIG_PARPORT_NOT_PC=y
> CONFIG_PNP=y
> CONFIG_PNP_DEBUG_MESSAGES=y
> 
> #
> # Protocols
> #
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> CONFIG_BLK_DEV_NULL_BLK=y
> CONFIG_BLK_DEV_FD=m
> # CONFIG_PARIDE is not set
> CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
> CONFIG_BLK_CPQ_CISS_DA=m
> # CONFIG_CISS_SCSI_TAPE is not set
> CONFIG_BLK_DEV_DAC960=y
> # CONFIG_BLK_DEV_UMEM is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=y
> CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
> CONFIG_BLK_DEV_CRYPTOLOOP=m
> 
> #
> # DRBD disabled because PROC_FS or INET not selected
> #
> # CONFIG_BLK_DEV_NBD is not set
> CONFIG_BLK_DEV_NVME=m
> CONFIG_BLK_DEV_SKD=m
> # CONFIG_BLK_DEV_SX8 is not set
> CONFIG_BLK_DEV_RAM=y
> CONFIG_BLK_DEV_RAM_COUNT=16
> CONFIG_BLK_DEV_RAM_SIZE=4096
> CONFIG_BLK_DEV_XIP=y
> CONFIG_CDROM_PKTCDVD=m
> CONFIG_CDROM_PKTCDVD_BUFFERS=8
> CONFIG_CDROM_PKTCDVD_WCACHE=y
> CONFIG_ATA_OVER_ETH=y
> # CONFIG_VIRTIO_BLK is not set
> CONFIG_BLK_DEV_HD=y
> # CONFIG_BLK_DEV_RSXX is not set
> 
> #
> # Misc devices
> #
> CONFIG_SENSORS_LIS3LV02D=y
> # CONFIG_AD525X_DPOT is not set
> CONFIG_DUMMY_IRQ=m
> # CONFIG_IBM_ASM is not set
> CONFIG_PHANTOM=m
> # CONFIG_SGI_IOC4 is not set
> CONFIG_TIFM_CORE=y
> CONFIG_TIFM_7XX1=m
> CONFIG_ICS932S401=y
> CONFIG_ENCLOSURE_SERVICES=y
> CONFIG_CS5535_MFGPT=m
> CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
> # CONFIG_CS5535_CLOCK_EVENT_SRC is not set
> CONFIG_HP_ILO=m
> # CONFIG_APDS9802ALS is not set
> # CONFIG_ISL29003 is not set
> CONFIG_ISL29020=m
> CONFIG_SENSORS_TSL2550=y
> CONFIG_SENSORS_BH1780=m
> CONFIG_SENSORS_BH1770=y
> CONFIG_SENSORS_APDS990X=m
> # CONFIG_HMC6352 is not set
> # CONFIG_DS1682 is not set
> CONFIG_VMWARE_BALLOON=m
> CONFIG_BMP085=y
> CONFIG_BMP085_I2C=m
> CONFIG_USB_SWITCH_FSA9480=y
> CONFIG_SRAM=y
> # CONFIG_C2PORT is not set
> 
> #
> # EEPROM support
> #
> CONFIG_EEPROM_AT24=m
> CONFIG_EEPROM_LEGACY=y
> CONFIG_EEPROM_MAX6875=y
> # CONFIG_EEPROM_93CX6 is not set
> CONFIG_CB710_CORE=y
> CONFIG_CB710_DEBUG=y
> CONFIG_CB710_DEBUG_ASSUMPTIONS=y
> 
> #
> # Texas Instruments shared transport line discipline
> #
> # CONFIG_TI_ST is not set
> CONFIG_SENSORS_LIS3_I2C=y
> 
> #
> # Altera FPGA firmware download module
> #
> CONFIG_ALTERA_STAPL=y
> CONFIG_VMWARE_VMCI=y
> 
> #
> # Intel MIC Host Driver
> #
> CONFIG_INTEL_MIC_HOST=m
> 
> #
> # Intel MIC Card Driver
> #
> CONFIG_INTEL_MIC_CARD=m
> # CONFIG_GENWQE is not set
> # CONFIG_ECHO is not set
> CONFIG_HAVE_IDE=y
> # CONFIG_IDE is not set
> 
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=y
> CONFIG_RAID_ATTRS=y
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> # CONFIG_SCSI_TGT is not set
> CONFIG_SCSI_NETLINK=y
> # CONFIG_SCSI_PROC_FS is not set
> 
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> # CONFIG_BLK_DEV_SD is not set
> # CONFIG_CHR_DEV_ST is not set
> # CONFIG_CHR_DEV_OSST is not set
> CONFIG_BLK_DEV_SR=m
> CONFIG_BLK_DEV_SR_VENDOR=y
> CONFIG_CHR_DEV_SG=m
> CONFIG_CHR_DEV_SCH=m
> CONFIG_SCSI_ENCLOSURE=m
> # CONFIG_SCSI_MULTI_LUN is not set
> # CONFIG_SCSI_CONSTANTS is not set
> CONFIG_SCSI_LOGGING=y
> CONFIG_SCSI_SCAN_ASYNC=y
> 
> #
> # SCSI Transports
> #
> CONFIG_SCSI_SPI_ATTRS=y
> CONFIG_SCSI_FC_ATTRS=y
> CONFIG_SCSI_ISCSI_ATTRS=y
> CONFIG_SCSI_SAS_ATTRS=y
> CONFIG_SCSI_SAS_LIBSAS=y
> # CONFIG_SCSI_SAS_ATA is not set
> # CONFIG_SCSI_SAS_HOST_SMP is not set
> CONFIG_SCSI_SRP_ATTRS=y
> CONFIG_SCSI_LOWLEVEL=y
> CONFIG_ISCSI_BOOT_SYSFS=m
> CONFIG_SCSI_BNX2_ISCSI=y
> CONFIG_SCSI_BNX2X_FCOE=m
> CONFIG_BE2ISCSI=m
> CONFIG_BLK_DEV_3W_XXXX_RAID=m
> CONFIG_SCSI_HPSA=m
> CONFIG_SCSI_3W_9XXX=y
> # CONFIG_SCSI_3W_SAS is not set
> CONFIG_SCSI_ACARD=m
> # CONFIG_SCSI_AACRAID is not set
> # CONFIG_SCSI_AIC7XXX is not set
> CONFIG_SCSI_AIC79XX=m
> CONFIG_AIC79XX_CMDS_PER_DEVICE=32
> CONFIG_AIC79XX_RESET_DELAY_MS=5000
> CONFIG_AIC79XX_DEBUG_ENABLE=y
> CONFIG_AIC79XX_DEBUG_MASK=0
> CONFIG_AIC79XX_REG_PRETTY_PRINT=y
> CONFIG_SCSI_AIC94XX=m
> CONFIG_AIC94XX_DEBUG=y
> CONFIG_SCSI_MVSAS=y
> CONFIG_SCSI_MVSAS_DEBUG=y
> # CONFIG_SCSI_MVSAS_TASKLET is not set
> CONFIG_SCSI_MVUMI=y
> # CONFIG_SCSI_DPT_I2O is not set
> # CONFIG_SCSI_ADVANSYS is not set
> # CONFIG_SCSI_ARCMSR is not set
> CONFIG_SCSI_ESAS2R=y
> # CONFIG_MEGARAID_NEWGEN is not set
> CONFIG_MEGARAID_LEGACY=y
> # CONFIG_MEGARAID_SAS is not set
> CONFIG_SCSI_MPT2SAS=y
> CONFIG_SCSI_MPT2SAS_MAX_SGE=128
> # CONFIG_SCSI_MPT2SAS_LOGGING is not set
> # CONFIG_SCSI_MPT3SAS is not set
> CONFIG_SCSI_UFSHCD=m
> # CONFIG_SCSI_UFSHCD_PCI is not set
> CONFIG_SCSI_UFSHCD_PLATFORM=m
> # CONFIG_SCSI_HPTIOP is not set
> # CONFIG_SCSI_BUSLOGIC is not set
> # CONFIG_VMWARE_PVSCSI is not set
> CONFIG_LIBFC=y
> CONFIG_LIBFCOE=y
> CONFIG_FCOE=y
> # CONFIG_FCOE_FNIC is not set
> # CONFIG_SCSI_DMX3191D is not set
> # CONFIG_SCSI_EATA is not set
> # CONFIG_SCSI_FUTURE_DOMAIN is not set
> CONFIG_SCSI_GDTH=y
> # CONFIG_SCSI_ISCI is not set
> CONFIG_SCSI_IPS=y
> CONFIG_SCSI_INITIO=m
> CONFIG_SCSI_INIA100=y
> CONFIG_SCSI_PPA=m
> CONFIG_SCSI_IMM=m
> CONFIG_SCSI_IZIP_EPP16=y
> CONFIG_SCSI_IZIP_SLOW_CTR=y
> CONFIG_SCSI_STEX=m
> CONFIG_SCSI_SYM53C8XX_2=y
> CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
> CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
> CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
> CONFIG_SCSI_SYM53C8XX_MMIO=y
> CONFIG_SCSI_IPR=m
> # CONFIG_SCSI_IPR_TRACE is not set
> CONFIG_SCSI_IPR_DUMP=y
> CONFIG_SCSI_QLOGIC_1280=y
> CONFIG_SCSI_QLA_FC=y
> CONFIG_TCM_QLA2XXX=m
> CONFIG_SCSI_QLA_ISCSI=m
> # CONFIG_SCSI_LPFC is not set
> # CONFIG_SCSI_DC395x is not set
> CONFIG_SCSI_DC390T=m
> CONFIG_SCSI_DEBUG=m
> CONFIG_SCSI_PMCRAID=y
> CONFIG_SCSI_PM8001=y
> # CONFIG_SCSI_SRP is not set
> CONFIG_SCSI_BFA_FC=m
> CONFIG_SCSI_VIRTIO=m
> CONFIG_SCSI_CHELSIO_FCOE=m
> CONFIG_SCSI_DH=y
> # CONFIG_SCSI_DH_RDAC is not set
> CONFIG_SCSI_DH_HP_SW=m
> # CONFIG_SCSI_DH_EMC is not set
> CONFIG_SCSI_DH_ALUA=y
> CONFIG_SCSI_OSD_INITIATOR=y
> # CONFIG_SCSI_OSD_ULD is not set
> CONFIG_SCSI_OSD_DPRINT_SENSE=1
> # CONFIG_SCSI_OSD_DEBUG is not set
> CONFIG_ATA=y
> # CONFIG_ATA_NONSTANDARD is not set
> # CONFIG_ATA_VERBOSE_ERROR is not set
> CONFIG_ATA_ACPI=y
> # CONFIG_SATA_PMP is not set
> 
> #
> # Controllers with non-SFF native interface
> #
> CONFIG_SATA_AHCI=y
> # CONFIG_SATA_AHCI_PLATFORM is not set
> CONFIG_SATA_INIC162X=y
> CONFIG_SATA_ACARD_AHCI=m
> CONFIG_SATA_SIL24=m
> # CONFIG_ATA_SFF is not set
> CONFIG_MD=y
> CONFIG_BLK_DEV_MD=m
> CONFIG_MD_LINEAR=m
> # CONFIG_MD_RAID0 is not set
> # CONFIG_MD_RAID1 is not set
> CONFIG_MD_RAID10=m
> CONFIG_MD_RAID456=m
> # CONFIG_MD_MULTIPATH is not set
> CONFIG_MD_FAULTY=m
> CONFIG_BCACHE=y
> CONFIG_BCACHE_DEBUG=y
> CONFIG_BCACHE_CLOSURES_DEBUG=y
> # CONFIG_BLK_DEV_DM is not set
> CONFIG_TARGET_CORE=m
> CONFIG_TCM_IBLOCK=m
> # CONFIG_TCM_FILEIO is not set
> CONFIG_TCM_PSCSI=m
> CONFIG_LOOPBACK_TARGET=m
> CONFIG_TCM_FC=m
> # CONFIG_ISCSI_TARGET is not set
> CONFIG_FUSION=y
> CONFIG_FUSION_SPI=y
> CONFIG_FUSION_FC=m
> # CONFIG_FUSION_SAS is not set
> CONFIG_FUSION_MAX_SGE=128
> CONFIG_FUSION_CTL=y
> CONFIG_FUSION_LOGGING=y
> 
> #
> # IEEE 1394 (FireWire) support
> #
> # CONFIG_FIREWIRE is not set
> CONFIG_FIREWIRE_NOSY=m
> # CONFIG_I2O is not set
> # CONFIG_MACINTOSH_DRIVERS is not set
> CONFIG_NETDEVICES=y
> CONFIG_MII=y
> # CONFIG_NET_CORE is not set
> CONFIG_ARCNET=y
> # CONFIG_ARCNET_1201 is not set
> CONFIG_ARCNET_1051=m
> # CONFIG_ARCNET_RAW is not set
> # CONFIG_ARCNET_CAP is not set
> CONFIG_ARCNET_COM90xx=m
> CONFIG_ARCNET_COM90xxIO=y
> # CONFIG_ARCNET_RIM_I is not set
> CONFIG_ARCNET_COM20020=y
> CONFIG_ARCNET_COM20020_PCI=m
> CONFIG_ATM_DRIVERS=y
> CONFIG_ATM_DUMMY=y
> CONFIG_ATM_LANAI=y
> CONFIG_ATM_ENI=m
> CONFIG_ATM_ENI_DEBUG=y
> # CONFIG_ATM_ENI_TUNE_BURST is not set
> CONFIG_ATM_FIRESTREAM=y
> CONFIG_ATM_ZATM=y
> # CONFIG_ATM_ZATM_DEBUG is not set
> CONFIG_ATM_NICSTAR=m
> CONFIG_ATM_NICSTAR_USE_SUNI=y
> # CONFIG_ATM_NICSTAR_USE_IDT77105 is not set
> CONFIG_ATM_IDT77252=m
> CONFIG_ATM_IDT77252_DEBUG=y
> # CONFIG_ATM_IDT77252_RCV_ALL is not set
> CONFIG_ATM_IDT77252_USE_SUNI=y
> # CONFIG_ATM_AMBASSADOR is not set
> # CONFIG_ATM_HORIZON is not set
> # CONFIG_ATM_IA is not set
> CONFIG_ATM_FORE200E=m
> CONFIG_ATM_FORE200E_USE_TASKLET=y
> CONFIG_ATM_FORE200E_TX_RETRY=16
> CONFIG_ATM_FORE200E_DEBUG=0
> CONFIG_ATM_HE=y
> CONFIG_ATM_HE_USE_SUNI=y
> CONFIG_ATM_SOLOS=m
> 
> #
> # CAIF transport drivers
> #
> # CONFIG_CAIF_TTY is not set
> # CONFIG_CAIF_SPI_SLAVE is not set
> CONFIG_CAIF_HSI=m
> CONFIG_CAIF_VIRTIO=m
> CONFIG_VHOST_NET=m
> CONFIG_VHOST_SCSI=m
> CONFIG_VHOST_RING=m
> CONFIG_VHOST=m
> 
> #
> # Distributed Switch Architecture drivers
> #
> CONFIG_NET_DSA_MV88E6XXX=y
> # CONFIG_NET_DSA_MV88E6060 is not set
> # CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
> # CONFIG_NET_DSA_MV88E6131 is not set
> CONFIG_NET_DSA_MV88E6123_61_65=y
> CONFIG_ETHERNET=y
> CONFIG_MDIO=m
> CONFIG_NET_VENDOR_3COM=y
> # CONFIG_VORTEX is not set
> # CONFIG_TYPHOON is not set
> # CONFIG_NET_VENDOR_ADAPTEC is not set
> # CONFIG_NET_VENDOR_ALTEON is not set
> CONFIG_ALTERA_TSE=m
> CONFIG_NET_VENDOR_AMD=y
> CONFIG_AMD8111_ETH=m
> # CONFIG_PCNET32 is not set
> # CONFIG_NET_VENDOR_ARC is not set
> CONFIG_NET_VENDOR_ATHEROS=y
> CONFIG_ATL2=y
> # CONFIG_ATL1 is not set
> CONFIG_ATL1E=y
> # CONFIG_ATL1C is not set
> CONFIG_ALX=m
> CONFIG_NET_VENDOR_BROADCOM=y
> CONFIG_B44=m
> CONFIG_B44_PCI_AUTOSELECT=y
> CONFIG_B44_PCICORE_AUTOSELECT=y
> CONFIG_B44_PCI=y
> CONFIG_BNX2=y
> CONFIG_CNIC=y
> CONFIG_TIGON3=y
> # CONFIG_BNX2X is not set
> # CONFIG_NET_VENDOR_BROCADE is not set
> CONFIG_NET_CALXEDA_XGMAC=m
> # CONFIG_NET_VENDOR_CHELSIO is not set
> CONFIG_NET_VENDOR_CISCO=y
> CONFIG_ENIC=m
> CONFIG_CX_ECAT=m
> CONFIG_DNET=y
> # CONFIG_NET_VENDOR_DEC is not set
> CONFIG_NET_VENDOR_DLINK=y
> # CONFIG_DL2K is not set
> CONFIG_SUNDANCE=m
> CONFIG_SUNDANCE_MMIO=y
> # CONFIG_NET_VENDOR_EMULEX is not set
> # CONFIG_NET_VENDOR_EXAR is not set
> # CONFIG_NET_VENDOR_HP is not set
> # CONFIG_NET_VENDOR_INTEL is not set
> # CONFIG_IP1000 is not set
> CONFIG_JME=m
> CONFIG_NET_VENDOR_MARVELL=y
> CONFIG_MVMDIO=y
> CONFIG_SKGE=m
> CONFIG_SKGE_DEBUG=y
> # CONFIG_SKGE_GENESIS is not set
> CONFIG_SKY2=y
> CONFIG_SKY2_DEBUG=y
> CONFIG_NET_VENDOR_MELLANOX=y
> CONFIG_MLX4_EN=m
> CONFIG_MLX4_CORE=m
> CONFIG_MLX4_DEBUG=y
> # CONFIG_MLX5_CORE is not set
> # CONFIG_NET_VENDOR_MICREL is not set
> CONFIG_FEALNX=m
> CONFIG_NET_VENDOR_NATSEMI=y
> CONFIG_NATSEMI=y
> # CONFIG_NS83820 is not set
> # CONFIG_NET_VENDOR_8390 is not set
> CONFIG_NET_VENDOR_NVIDIA=y
> # CONFIG_FORCEDETH is not set
> CONFIG_NET_VENDOR_OKI=y
> # CONFIG_ETHOC is not set
> # CONFIG_NET_PACKET_ENGINE is not set
> CONFIG_NET_VENDOR_QLOGIC=y
> CONFIG_QLA3XXX=y
> CONFIG_QLCNIC=y
> CONFIG_QLCNIC_HWMON=y
> # CONFIG_QLGE is not set
> CONFIG_NETXEN_NIC=m
> # CONFIG_NET_VENDOR_REALTEK is not set
> # CONFIG_SH_ETH is not set
> CONFIG_NET_VENDOR_RDC=y
> CONFIG_R6040=m
> CONFIG_NET_VENDOR_SAMSUNG=y
> # CONFIG_SXGBE_ETH is not set
> CONFIG_NET_VENDOR_SEEQ=y
> CONFIG_NET_VENDOR_SILAN=y
> CONFIG_SC92031=y
> CONFIG_NET_VENDOR_SIS=y
> CONFIG_SIS900=y
> # CONFIG_SIS190 is not set
> CONFIG_SFC=m
> CONFIG_SFC_MTD=y
> CONFIG_SFC_MCDI_MON=y
> # CONFIG_NET_VENDOR_SMSC is not set
> CONFIG_NET_VENDOR_STMICRO=y
> CONFIG_STMMAC_ETH=y
> CONFIG_STMMAC_PLATFORM=y
> # CONFIG_STMMAC_PCI is not set
> CONFIG_STMMAC_DEBUG_FS=y
> # CONFIG_STMMAC_DA is not set
> # CONFIG_NET_VENDOR_SUN is not set
> CONFIG_NET_VENDOR_TEHUTI=y
> CONFIG_TEHUTI=m
> # CONFIG_NET_VENDOR_TI is not set
> # CONFIG_NET_VENDOR_VIA is not set
> # CONFIG_NET_VENDOR_WIZNET is not set
> CONFIG_FDDI=y
> CONFIG_DEFXX=m
> CONFIG_DEFXX_MMIO=y
> CONFIG_SKFP=m
> # CONFIG_NET_SB1000 is not set
> CONFIG_PHYLIB=y
> 
> #
> # MII PHY device drivers
> #
> CONFIG_AT803X_PHY=y
> CONFIG_AMD_PHY=m
> CONFIG_MARVELL_PHY=y
> # CONFIG_DAVICOM_PHY is not set
> CONFIG_QSEMI_PHY=y
> CONFIG_LXT_PHY=m
> # CONFIG_CICADA_PHY is not set
> CONFIG_VITESSE_PHY=y
> # CONFIG_SMSC_PHY is not set
> # CONFIG_BROADCOM_PHY is not set
> CONFIG_BCM7XXX_PHY=y
> # CONFIG_BCM87XX_PHY is not set
> CONFIG_ICPLUS_PHY=y
> # CONFIG_REALTEK_PHY is not set
> CONFIG_NATIONAL_PHY=y
> # CONFIG_STE10XP is not set
> CONFIG_LSI_ET1011C_PHY=y
> CONFIG_MICREL_PHY=m
> # CONFIG_FIXED_PHY is not set
> CONFIG_MDIO_BITBANG=m
> CONFIG_MDIO_GPIO=m
> # CONFIG_PLIP is not set
> CONFIG_PPP=y
> CONFIG_PPP_BSDCOMP=y
> CONFIG_PPP_DEFLATE=m
> # CONFIG_PPP_FILTER is not set
> CONFIG_PPP_MPPE=m
> CONFIG_PPP_MULTILINK=y
> CONFIG_PPPOATM=m
> CONFIG_PPPOE=m
> CONFIG_PPP_ASYNC=y
> CONFIG_PPP_SYNC_TTY=m
> CONFIG_SLIP=y
> CONFIG_SLHC=y
> CONFIG_SLIP_COMPRESSED=y
> # CONFIG_SLIP_SMART is not set
> CONFIG_SLIP_MODE_SLIP6=y
> # CONFIG_WLAN is not set
> 
> #
> # Enable WiMAX (Networking options) to see the WiMAX drivers
> #
> CONFIG_WAN=y
> # CONFIG_LANMEDIA is not set
> CONFIG_HDLC=y
> CONFIG_HDLC_RAW=m
> # CONFIG_HDLC_RAW_ETH is not set
> CONFIG_HDLC_CISCO=y
> # CONFIG_HDLC_FR is not set
> CONFIG_HDLC_PPP=y
> CONFIG_HDLC_X25=m
> CONFIG_PCI200SYN=y
> CONFIG_WANXL=y
> # CONFIG_PC300TOO is not set
> CONFIG_FARSYNC=y
> CONFIG_DSCC4=m
> # CONFIG_DSCC4_PCISYNC is not set
> CONFIG_DSCC4_PCI_RST=y
> # CONFIG_DLCI is not set
> CONFIG_LAPBETHER=m
> CONFIG_X25_ASY=m
> CONFIG_SBNI=y
> # CONFIG_SBNI_MULTILINE is not set
> # CONFIG_IEEE802154_DRIVERS is not set
> # CONFIG_ISDN is not set
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> CONFIG_INPUT_FF_MEMLESS=y
> CONFIG_INPUT_POLLDEV=y
> # CONFIG_INPUT_SPARSEKMAP is not set
> CONFIG_INPUT_MATRIXKMAP=y
> 
> #
> # Userland interfaces
> #
> # CONFIG_INPUT_MOUSEDEV is not set
> CONFIG_INPUT_JOYDEV=y
> # CONFIG_INPUT_EVDEV is not set
> # CONFIG_INPUT_EVBUG is not set
> 
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> # CONFIG_KEYBOARD_ADP5588 is not set
> # CONFIG_KEYBOARD_ADP5589 is not set
> CONFIG_KEYBOARD_ATKBD=y
> # CONFIG_KEYBOARD_QT1070 is not set
> # CONFIG_KEYBOARD_QT2160 is not set
> # CONFIG_KEYBOARD_LKKBD is not set
> # CONFIG_KEYBOARD_GPIO is not set
> # CONFIG_KEYBOARD_GPIO_POLLED is not set
> # CONFIG_KEYBOARD_TCA6416 is not set
> # CONFIG_KEYBOARD_TCA8418 is not set
> # CONFIG_KEYBOARD_MATRIX is not set
> # CONFIG_KEYBOARD_LM8333 is not set
> # CONFIG_KEYBOARD_MAX7359 is not set
> # CONFIG_KEYBOARD_MCS is not set
> # CONFIG_KEYBOARD_MPR121 is not set
> # CONFIG_KEYBOARD_NEWTON is not set
> # CONFIG_KEYBOARD_OPENCORES is not set
> # CONFIG_KEYBOARD_STOWAWAY is not set
> # CONFIG_KEYBOARD_SUNKBD is not set
> # CONFIG_KEYBOARD_TC3589X is not set
> # CONFIG_KEYBOARD_TWL4030 is not set
> # CONFIG_KEYBOARD_XTKBD is not set
> # CONFIG_KEYBOARD_CROS_EC is not set
> CONFIG_INPUT_MOUSE=y
> # CONFIG_MOUSE_PS2 is not set
> CONFIG_MOUSE_SERIAL=m
> # CONFIG_MOUSE_APPLETOUCH is not set
> # CONFIG_MOUSE_BCM5974 is not set
> # CONFIG_MOUSE_CYAPA is not set
> # CONFIG_MOUSE_VSXXXAA is not set
> CONFIG_MOUSE_GPIO=m
> CONFIG_MOUSE_SYNAPTICS_I2C=m
> # CONFIG_MOUSE_SYNAPTICS_USB is not set
> # CONFIG_INPUT_JOYSTICK is not set
> # CONFIG_INPUT_TABLET is not set
> CONFIG_INPUT_TOUCHSCREEN=y
> CONFIG_TOUCHSCREEN_88PM860X=y
> # CONFIG_TOUCHSCREEN_AD7879 is not set
> # CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
> CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
> # CONFIG_TOUCHSCREEN_BU21013 is not set
> CONFIG_TOUCHSCREEN_CY8CTMG110=y
> CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
> CONFIG_TOUCHSCREEN_CYTTSP_I2C=y
> CONFIG_TOUCHSCREEN_CYTTSP4_CORE=m
> CONFIG_TOUCHSCREEN_CYTTSP4_I2C=m
> CONFIG_TOUCHSCREEN_DA9034=m
> # CONFIG_TOUCHSCREEN_DA9052 is not set
> CONFIG_TOUCHSCREEN_DYNAPRO=m
> CONFIG_TOUCHSCREEN_HAMPSHIRE=m
> CONFIG_TOUCHSCREEN_EETI=m
> CONFIG_TOUCHSCREEN_FUJITSU=y
> # CONFIG_TOUCHSCREEN_ILI210X is not set
> # CONFIG_TOUCHSCREEN_GUNZE is not set
> CONFIG_TOUCHSCREEN_ELO=m
> # CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
> CONFIG_TOUCHSCREEN_WACOM_I2C=m
> # CONFIG_TOUCHSCREEN_MAX11801 is not set
> # CONFIG_TOUCHSCREEN_MCS5000 is not set
> CONFIG_TOUCHSCREEN_MMS114=m
> CONFIG_TOUCHSCREEN_MTOUCH=m
> CONFIG_TOUCHSCREEN_INEXIO=y
> CONFIG_TOUCHSCREEN_MK712=m
> CONFIG_TOUCHSCREEN_PENMOUNT=m
> CONFIG_TOUCHSCREEN_EDT_FT5X06=m
> CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
> CONFIG_TOUCHSCREEN_TOUCHWIN=y
> CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
> # CONFIG_TOUCHSCREEN_PIXCIR is not set
> # CONFIG_TOUCHSCREEN_WM831X is not set
> # CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
> CONFIG_TOUCHSCREEN_TOUCHIT213=m
> CONFIG_TOUCHSCREEN_TSC_SERIO=y
> # CONFIG_TOUCHSCREEN_TSC2007 is not set
> CONFIG_TOUCHSCREEN_ST1232=m
> CONFIG_TOUCHSCREEN_TPS6507X=m
> CONFIG_TOUCHSCREEN_ZFORCE=m
> CONFIG_INPUT_MISC=y
> CONFIG_INPUT_88PM860X_ONKEY=y
> # CONFIG_INPUT_AD714X is not set
> # CONFIG_INPUT_BMA150 is not set
> CONFIG_INPUT_PCSPKR=m
> CONFIG_INPUT_MAX8925_ONKEY=m
> # CONFIG_INPUT_MMA8450 is not set
> # CONFIG_INPUT_MPU3050 is not set
> # CONFIG_INPUT_GP2A is not set
> CONFIG_INPUT_GPIO_BEEPER=m
> # CONFIG_INPUT_GPIO_TILT_POLLED is not set
> # CONFIG_INPUT_ATLAS_BTNS is not set
> # CONFIG_INPUT_ATI_REMOTE2 is not set
> # CONFIG_INPUT_KEYSPAN_REMOTE is not set
> CONFIG_INPUT_KXTJ9=m
> CONFIG_INPUT_KXTJ9_POLLED_MODE=y
> # CONFIG_INPUT_POWERMATE is not set
> # CONFIG_INPUT_YEALINK is not set
> # CONFIG_INPUT_CM109 is not set
> CONFIG_INPUT_RETU_PWRBUTTON=m
> # CONFIG_INPUT_TWL4030_PWRBUTTON is not set
> # CONFIG_INPUT_TWL4030_VIBRA is not set
> CONFIG_INPUT_TWL6040_VIBRA=y
> CONFIG_INPUT_UINPUT=y
> # CONFIG_INPUT_PCF50633_PMU is not set
> # CONFIG_INPUT_PCF8574 is not set
> CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
> CONFIG_INPUT_DA9052_ONKEY=y
> # CONFIG_INPUT_DA9055_ONKEY is not set
> CONFIG_INPUT_WM831X_ON=m
> CONFIG_INPUT_ADXL34X=y
> CONFIG_INPUT_ADXL34X_I2C=m
> CONFIG_INPUT_CMA3000=m
> # CONFIG_INPUT_CMA3000_I2C is not set
> # CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
> CONFIG_SERIO_I8042=y
> CONFIG_SERIO_SERPORT=y
> CONFIG_SERIO_CT82C710=y
> CONFIG_SERIO_PARKBD=m
> # CONFIG_SERIO_PCIPS2 is not set
> CONFIG_SERIO_LIBPS2=y
> CONFIG_SERIO_RAW=m
> # CONFIG_SERIO_ALTERA_PS2 is not set
> CONFIG_SERIO_PS2MULT=y
> CONFIG_SERIO_ARC_PS2=y
> CONFIG_GAMEPORT=m
> CONFIG_GAMEPORT_NS558=m
> CONFIG_GAMEPORT_L4=m
> CONFIG_GAMEPORT_EMU10K1=m
> CONFIG_GAMEPORT_FM801=m
> 
> #
> # Character devices
> #
> CONFIG_TTY=y
> CONFIG_VT=y
> CONFIG_CONSOLE_TRANSLATIONS=y
> CONFIG_VT_CONSOLE=y
> CONFIG_VT_CONSOLE_SLEEP=y
> CONFIG_HW_CONSOLE=y
> CONFIG_VT_HW_CONSOLE_BINDING=y
> CONFIG_UNIX98_PTYS=y
> CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
> CONFIG_LEGACY_PTYS=y
> CONFIG_LEGACY_PTY_COUNT=256
> # CONFIG_SERIAL_NONSTANDARD is not set
> CONFIG_NOZOMI=m
> CONFIG_N_GSM=m
> # CONFIG_TRACE_SINK is not set
> # CONFIG_DEVKMEM is not set
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_EARLYCON=y
> CONFIG_SERIAL_8250=y
> # CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> # CONFIG_SERIAL_8250_EXTENDED is not set
> # CONFIG_SERIAL_8250_DW is not set
> 
> #
> # Non-8250 serial port support
> #
> CONFIG_SERIAL_MFD_HSU=y
> # CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
> CONFIG_SERIAL_UARTLITE=y
> CONFIG_SERIAL_UARTLITE_CONSOLE=y
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> CONFIG_SERIAL_JSM=y
> CONFIG_SERIAL_SCCNXP=y
> # CONFIG_SERIAL_SCCNXP_CONSOLE is not set
> CONFIG_SERIAL_SC16IS7XX=m
> CONFIG_SERIAL_ALTERA_JTAGUART=y
> # CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
> # CONFIG_SERIAL_ALTERA_UART is not set
> CONFIG_SERIAL_ARC=y
> CONFIG_SERIAL_ARC_CONSOLE=y
> CONFIG_SERIAL_ARC_NR_PORTS=1
> CONFIG_SERIAL_RP2=y
> CONFIG_SERIAL_RP2_NR_UARTS=32
> CONFIG_SERIAL_FSL_LPUART=m
> # CONFIG_SERIAL_MEN_Z135 is not set
> # CONFIG_PRINTER is not set
> CONFIG_PPDEV=y
> CONFIG_HVC_DRIVER=y
> CONFIG_VIRTIO_CONSOLE=m
> CONFIG_IPMI_HANDLER=m
> CONFIG_IPMI_PANIC_EVENT=y
> # CONFIG_IPMI_PANIC_STRING is not set
> # CONFIG_IPMI_DEVICE_INTERFACE is not set
> CONFIG_IPMI_SI=m
> CONFIG_IPMI_SI_PROBE_DEFAULTS=y
> # CONFIG_IPMI_WATCHDOG is not set
> # CONFIG_IPMI_POWEROFF is not set
> CONFIG_HW_RANDOM=y
> # CONFIG_HW_RANDOM_TIMERIOMEM is not set
> CONFIG_HW_RANDOM_INTEL=y
> CONFIG_HW_RANDOM_AMD=y
> CONFIG_HW_RANDOM_VIA=y
> CONFIG_HW_RANDOM_VIRTIO=y
> CONFIG_NVRAM=y
> # CONFIG_R3964 is not set
> CONFIG_APPLICOM=y
> CONFIG_MWAVE=m
> # CONFIG_RAW_DRIVER is not set
> # CONFIG_HPET is not set
> # CONFIG_HANGCHECK_TIMER is not set
> # CONFIG_TCG_TPM is not set
> CONFIG_TELCLOCK=y
> CONFIG_DEVPORT=y
> CONFIG_I2C=y
> CONFIG_I2C_BOARDINFO=y
> # CONFIG_I2C_COMPAT is not set
> CONFIG_I2C_CHARDEV=m
> # CONFIG_I2C_MUX is not set
> CONFIG_I2C_HELPER_AUTO=y
> CONFIG_I2C_SMBUS=m
> CONFIG_I2C_ALGOBIT=y
> CONFIG_I2C_ALGOPCA=y
> 
> #
> # I2C Hardware Bus support
> #
> 
> #
> # PC SMBus host controller drivers
> #
> # CONFIG_I2C_ALI1535 is not set
> CONFIG_I2C_ALI1563=m
> # CONFIG_I2C_ALI15X3 is not set
> # CONFIG_I2C_AMD756 is not set
> CONFIG_I2C_AMD8111=y
> # CONFIG_I2C_I801 is not set
> CONFIG_I2C_ISCH=y
> CONFIG_I2C_ISMT=m
> CONFIG_I2C_PIIX4=m
> CONFIG_I2C_NFORCE2=m
> # CONFIG_I2C_NFORCE2_S4985 is not set
> CONFIG_I2C_SIS5595=y
> # CONFIG_I2C_SIS630 is not set
> CONFIG_I2C_SIS96X=y
> CONFIG_I2C_VIA=y
> # CONFIG_I2C_VIAPRO is not set
> 
> #
> # ACPI drivers
> #
> # CONFIG_I2C_SCMI is not set
> 
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> CONFIG_I2C_CBUS_GPIO=m
> CONFIG_I2C_DESIGNWARE_CORE=y
> # CONFIG_I2C_DESIGNWARE_PLATFORM is not set
> CONFIG_I2C_DESIGNWARE_PCI=y
> CONFIG_I2C_GPIO=y
> CONFIG_I2C_KEMPLD=m
> CONFIG_I2C_OCORES=m
> CONFIG_I2C_PCA_PLATFORM=y
> # CONFIG_I2C_PXA_PCI is not set
> # CONFIG_I2C_SIMTEC is not set
> CONFIG_I2C_XILINX=m
> 
> #
> # External I2C/SMBus adapter drivers
> #
> CONFIG_I2C_PARPORT=m
> # CONFIG_I2C_PARPORT_LIGHT is not set
> # CONFIG_I2C_TAOS_EVM is not set
> 
> #
> # Other I2C/SMBus bus drivers
> #
> # CONFIG_I2C_CROS_EC_TUNNEL is not set
> # CONFIG_I2C_STUB is not set
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> # CONFIG_SPI is not set
> CONFIG_SPMI=y
> CONFIG_HSI=y
> CONFIG_HSI_BOARDINFO=y
> 
> #
> # HSI controllers
> #
> 
> #
> # HSI clients
> #
> CONFIG_HSI_CHAR=m
> 
> #
> # PPS support
> #
> CONFIG_PPS=y
> # CONFIG_PPS_DEBUG is not set
> 
> #
> # PPS clients support
> #
> CONFIG_PPS_CLIENT_KTIMER=m
> # CONFIG_PPS_CLIENT_LDISC is not set
> CONFIG_PPS_CLIENT_PARPORT=m
> # CONFIG_PPS_CLIENT_GPIO is not set
> 
> #
> # PPS generators support
> #
> 
> #
> # PTP clock support
> #
> CONFIG_PTP_1588_CLOCK=y
> 
> #
> # Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
> #
> # CONFIG_PTP_1588_CLOCK_PCH is not set
> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> CONFIG_GPIOLIB=y
> CONFIG_GPIO_DEVRES=y
> CONFIG_GPIO_ACPI=y
> CONFIG_GPIOLIB_IRQCHIP=y
> # CONFIG_DEBUG_GPIO is not set
> CONFIG_GPIO_SYSFS=y
> CONFIG_GPIO_GENERIC=y
> CONFIG_GPIO_DA9052=m
> CONFIG_GPIO_DA9055=m
> 
> #
> # Memory mapped GPIO drivers:
> #
> CONFIG_GPIO_GENERIC_PLATFORM=y
> # CONFIG_GPIO_IT8761E is not set
> CONFIG_GPIO_F7188X=m
> CONFIG_GPIO_SCH311X=m
> CONFIG_GPIO_SCH=m
> CONFIG_GPIO_ICH=m
> CONFIG_GPIO_VX855=m
> # CONFIG_GPIO_LYNXPOINT is not set
> 
> #
> # I2C GPIO expanders:
> #
> CONFIG_GPIO_ARIZONA=y
> # CONFIG_GPIO_LP3943 is not set
> # CONFIG_GPIO_MAX7300 is not set
> # CONFIG_GPIO_MAX732X is not set
> CONFIG_GPIO_PCA953X=y
> CONFIG_GPIO_PCA953X_IRQ=y
> # CONFIG_GPIO_PCF857X is not set
> CONFIG_GPIO_RC5T583=y
> # CONFIG_GPIO_SX150X is not set
> CONFIG_GPIO_TC3589X=y
> CONFIG_GPIO_TPS65912=m
> # CONFIG_GPIO_TWL4030 is not set
> CONFIG_GPIO_TWL6040=y
> CONFIG_GPIO_WM831X=m
> CONFIG_GPIO_WM8350=m
> # CONFIG_GPIO_ADP5588 is not set
> 
> #
> # PCI GPIO expanders:
> #
> # CONFIG_GPIO_CS5535 is not set
> CONFIG_GPIO_BT8XX=m
> CONFIG_GPIO_AMD8111=y
> CONFIG_GPIO_INTEL_MID=y
> CONFIG_GPIO_ML_IOH=m
> # CONFIG_GPIO_TIMBERDALE is not set
> CONFIG_GPIO_RDC321X=y
> 
> #
> # SPI GPIO expanders:
> #
> 
> #
> # AC97 GPIO expanders:
> #
> 
> #
> # LPC GPIO expanders:
> #
> CONFIG_GPIO_KEMPLD=y
> 
> #
> # MODULbus GPIO expanders:
> #
> CONFIG_GPIO_JANZ_TTL=y
> # CONFIG_GPIO_PALMAS is not set
> 
> #
> # USB GPIO expanders:
> #
> CONFIG_W1=m
> CONFIG_W1_CON=y
> 
> #
> # 1-wire Bus Masters
> #
> CONFIG_W1_MASTER_MATROX=m
> CONFIG_W1_MASTER_DS2482=m
> CONFIG_W1_MASTER_DS1WM=m
> CONFIG_W1_MASTER_GPIO=m
> 
> #
> # 1-wire Slaves
> #
> CONFIG_W1_SLAVE_THERM=m
> CONFIG_W1_SLAVE_SMEM=m
> CONFIG_W1_SLAVE_DS2408=m
> CONFIG_W1_SLAVE_DS2408_READBACK=y
> # CONFIG_W1_SLAVE_DS2413 is not set
> # CONFIG_W1_SLAVE_DS2423 is not set
> CONFIG_W1_SLAVE_DS2431=m
> CONFIG_W1_SLAVE_DS2433=m
> CONFIG_W1_SLAVE_DS2433_CRC=y
> CONFIG_W1_SLAVE_DS2760=m
> CONFIG_W1_SLAVE_DS2780=m
> # CONFIG_W1_SLAVE_DS2781 is not set
> CONFIG_W1_SLAVE_DS28E04=m
> # CONFIG_W1_SLAVE_BQ27000 is not set
> CONFIG_POWER_SUPPLY=y
> # CONFIG_POWER_SUPPLY_DEBUG is not set
> CONFIG_PDA_POWER=y
> CONFIG_MAX8925_POWER=y
> CONFIG_WM831X_BACKUP=y
> CONFIG_WM831X_POWER=y
> # CONFIG_WM8350_POWER is not set
> CONFIG_TEST_POWER=m
> CONFIG_BATTERY_88PM860X=y
> # CONFIG_BATTERY_DS2760 is not set
> # CONFIG_BATTERY_DS2780 is not set
> # CONFIG_BATTERY_DS2781 is not set
> CONFIG_BATTERY_DS2782=m
> CONFIG_BATTERY_SBS=m
> # CONFIG_BATTERY_BQ27x00 is not set
> # CONFIG_BATTERY_DA9030 is not set
> CONFIG_BATTERY_DA9052=m
> CONFIG_BATTERY_MAX17040=y
> # CONFIG_BATTERY_MAX17042 is not set
> CONFIG_CHARGER_88PM860X=y
> CONFIG_CHARGER_PCF50633=m
> # CONFIG_CHARGER_MAX8903 is not set
> CONFIG_CHARGER_TWL4030=y
> CONFIG_CHARGER_LP8727=y
> # CONFIG_CHARGER_GPIO is not set
> # CONFIG_CHARGER_MANAGER is not set
> CONFIG_CHARGER_BQ2415X=m
> # CONFIG_CHARGER_BQ24190 is not set
> CONFIG_CHARGER_BQ24735=m
> CONFIG_CHARGER_SMB347=y
> # CONFIG_CHARGER_TPS65090 is not set
> # CONFIG_POWER_RESET is not set
> # CONFIG_POWER_AVS is not set
> CONFIG_HWMON=y
> CONFIG_HWMON_VID=y
> CONFIG_HWMON_DEBUG_CHIP=y
> 
> #
> # Native drivers
> #
> # CONFIG_SENSORS_ABITUGURU is not set
> CONFIG_SENSORS_ABITUGURU3=m
> CONFIG_SENSORS_AD7414=m
> CONFIG_SENSORS_AD7418=m
> # CONFIG_SENSORS_ADM1021 is not set
> CONFIG_SENSORS_ADM1025=m
> CONFIG_SENSORS_ADM1026=m
> CONFIG_SENSORS_ADM1029=y
> # CONFIG_SENSORS_ADM1031 is not set
> CONFIG_SENSORS_ADM9240=y
> CONFIG_SENSORS_ADT7X10=m
> CONFIG_SENSORS_ADT7410=m
> CONFIG_SENSORS_ADT7411=y
> # CONFIG_SENSORS_ADT7462 is not set
> CONFIG_SENSORS_ADT7470=y
> CONFIG_SENSORS_ADT7475=y
> CONFIG_SENSORS_ASC7621=y
> CONFIG_SENSORS_K8TEMP=y
> CONFIG_SENSORS_K10TEMP=y
> CONFIG_SENSORS_FAM15H_POWER=m
> # CONFIG_SENSORS_APPLESMC is not set
> CONFIG_SENSORS_ASB100=m
> CONFIG_SENSORS_ATXP1=y
> CONFIG_SENSORS_DS620=m
> # CONFIG_SENSORS_DS1621 is not set
> # CONFIG_SENSORS_DA9052_ADC is not set
> CONFIG_SENSORS_DA9055=y
> # CONFIG_SENSORS_I5K_AMB is not set
> CONFIG_SENSORS_F71805F=y
> CONFIG_SENSORS_F71882FG=m
> CONFIG_SENSORS_F75375S=y
> CONFIG_SENSORS_FSCHMD=m
> CONFIG_SENSORS_GL518SM=y
> CONFIG_SENSORS_GL520SM=y
> CONFIG_SENSORS_G760A=m
> CONFIG_SENSORS_G762=m
> CONFIG_SENSORS_GPIO_FAN=y
> CONFIG_SENSORS_HIH6130=m
> CONFIG_SENSORS_IBMAEM=m
> # CONFIG_SENSORS_IBMPEX is not set
> # CONFIG_SENSORS_CORETEMP is not set
> # CONFIG_SENSORS_IT87 is not set
> # CONFIG_SENSORS_JC42 is not set
> # CONFIG_SENSORS_LINEAGE is not set
> CONFIG_SENSORS_LTC2945=m
> # CONFIG_SENSORS_LTC4151 is not set
> CONFIG_SENSORS_LTC4215=m
> # CONFIG_SENSORS_LTC4222 is not set
> # CONFIG_SENSORS_LTC4245 is not set
> # CONFIG_SENSORS_LTC4260 is not set
> CONFIG_SENSORS_LTC4261=m
> CONFIG_SENSORS_MAX16065=m
> CONFIG_SENSORS_MAX1619=m
> CONFIG_SENSORS_MAX1668=y
> # CONFIG_SENSORS_MAX197 is not set
> CONFIG_SENSORS_MAX6639=y
> CONFIG_SENSORS_MAX6642=y
> # CONFIG_SENSORS_MAX6650 is not set
> CONFIG_SENSORS_MAX6697=m
> CONFIG_SENSORS_HTU21=y
> # CONFIG_SENSORS_MCP3021 is not set
> CONFIG_SENSORS_LM63=y
> CONFIG_SENSORS_LM73=y
> CONFIG_SENSORS_LM75=m
> CONFIG_SENSORS_LM77=m
> CONFIG_SENSORS_LM78=m
> # CONFIG_SENSORS_LM80 is not set
> CONFIG_SENSORS_LM83=m
> # CONFIG_SENSORS_LM85 is not set
> # CONFIG_SENSORS_LM87 is not set
> CONFIG_SENSORS_LM90=m
> CONFIG_SENSORS_LM92=m
> CONFIG_SENSORS_LM93=m
> CONFIG_SENSORS_LM95234=m
> CONFIG_SENSORS_LM95241=m
> CONFIG_SENSORS_LM95245=m
> # CONFIG_SENSORS_PC87360 is not set
> # CONFIG_SENSORS_PC87427 is not set
> CONFIG_SENSORS_NTC_THERMISTOR=y
> CONFIG_SENSORS_NCT6683=y
> CONFIG_SENSORS_NCT6775=y
> # CONFIG_SENSORS_PCF8591 is not set
> # CONFIG_PMBUS is not set
> CONFIG_SENSORS_SHT15=y
> CONFIG_SENSORS_SHT21=m
> CONFIG_SENSORS_SHTC1=m
> CONFIG_SENSORS_SIS5595=y
> CONFIG_SENSORS_DME1737=y
> CONFIG_SENSORS_EMC1403=m
> # CONFIG_SENSORS_EMC2103 is not set
> CONFIG_SENSORS_EMC6W201=m
> CONFIG_SENSORS_SMSC47M1=y
> CONFIG_SENSORS_SMSC47M192=m
> CONFIG_SENSORS_SMSC47B397=y
> # CONFIG_SENSORS_SCH56XX_COMMON is not set
> # CONFIG_SENSORS_SMM665 is not set
> CONFIG_SENSORS_ADC128D818=m
> CONFIG_SENSORS_ADS1015=m
> CONFIG_SENSORS_ADS7828=y
> CONFIG_SENSORS_AMC6821=m
> CONFIG_SENSORS_INA209=y
> CONFIG_SENSORS_INA2XX=y
> CONFIG_SENSORS_THMC50=m
> # CONFIG_SENSORS_TMP102 is not set
> CONFIG_SENSORS_TMP401=y
> CONFIG_SENSORS_TMP421=m
> # CONFIG_SENSORS_VIA_CPUTEMP is not set
> CONFIG_SENSORS_VIA686A=y
> CONFIG_SENSORS_VT1211=m
> CONFIG_SENSORS_VT8231=y
> CONFIG_SENSORS_W83781D=y
> # CONFIG_SENSORS_W83791D is not set
> # CONFIG_SENSORS_W83792D is not set
> CONFIG_SENSORS_W83793=m
> CONFIG_SENSORS_W83795=m
> # CONFIG_SENSORS_W83795_FANCTRL is not set
> CONFIG_SENSORS_W83L785TS=y
> CONFIG_SENSORS_W83L786NG=y
> CONFIG_SENSORS_W83627HF=m
> CONFIG_SENSORS_W83627EHF=y
> # CONFIG_SENSORS_WM831X is not set
> # CONFIG_SENSORS_WM8350 is not set
> 
> #
> # ACPI drivers
> #
> # CONFIG_SENSORS_ACPI_POWER is not set
> # CONFIG_SENSORS_ATK0110 is not set
> CONFIG_THERMAL=y
> # CONFIG_THERMAL_HWMON is not set
> CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
> # CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
> # CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
> # CONFIG_THERMAL_GOV_FAIR_SHARE is not set
> CONFIG_THERMAL_GOV_STEP_WISE=y
> CONFIG_THERMAL_GOV_USER_SPACE=y
> # CONFIG_THERMAL_EMULATION is not set
> CONFIG_INTEL_POWERCLAMP=m
> CONFIG_X86_PKG_TEMP_THERMAL=m
> # CONFIG_ACPI_INT3403_THERMAL is not set
> # CONFIG_INTEL_SOC_DTS_THERMAL is not set
> 
> #
> # Texas Instruments thermal drivers
> #
> # CONFIG_WATCHDOG is not set
> CONFIG_SSB_POSSIBLE=y
> 
> #
> # Sonics Silicon Backplane
> #
> CONFIG_SSB=m
> CONFIG_SSB_SPROM=y
> CONFIG_SSB_PCIHOST_POSSIBLE=y
> CONFIG_SSB_PCIHOST=y
> # CONFIG_SSB_B43_PCI_BRIDGE is not set
> CONFIG_SSB_SDIOHOST_POSSIBLE=y
> # CONFIG_SSB_SDIOHOST is not set
> CONFIG_SSB_DEBUG=y
> CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
> CONFIG_SSB_DRIVER_PCICORE=y
> # CONFIG_SSB_DRIVER_GPIO is not set
> CONFIG_BCMA_POSSIBLE=y
> 
> #
> # Broadcom specific AMBA
> #
> CONFIG_BCMA=y
> CONFIG_BCMA_HOST_PCI_POSSIBLE=y
> # CONFIG_BCMA_HOST_PCI is not set
> CONFIG_BCMA_HOST_SOC=y
> # CONFIG_BCMA_DRIVER_GMAC_CMN is not set
> CONFIG_BCMA_DRIVER_GPIO=y
> # CONFIG_BCMA_DEBUG is not set
> 
> #
> # Multifunction device drivers
> #
> CONFIG_MFD_CORE=y
> CONFIG_MFD_CS5535=y
> # CONFIG_MFD_AS3711 is not set
> # CONFIG_PMIC_ADP5520 is not set
> CONFIG_MFD_AAT2870_CORE=y
> CONFIG_MFD_BCM590XX=y
> # CONFIG_MFD_AXP20X is not set
> CONFIG_MFD_CROS_EC=y
> CONFIG_MFD_CROS_EC_I2C=y
> CONFIG_PMIC_DA903X=y
> CONFIG_PMIC_DA9052=y
> CONFIG_MFD_DA9052_I2C=y
> CONFIG_MFD_DA9055=y
> CONFIG_MFD_DA9063=y
> # CONFIG_MFD_MC13XXX_I2C is not set
> # CONFIG_HTC_PASIC3 is not set
> CONFIG_HTC_I2CPLD=y
> CONFIG_LPC_ICH=m
> CONFIG_LPC_SCH=y
> CONFIG_MFD_JANZ_CMODIO=y
> CONFIG_MFD_KEMPLD=y
> # CONFIG_MFD_88PM800 is not set
> # CONFIG_MFD_88PM805 is not set
> CONFIG_MFD_88PM860X=y
> # CONFIG_MFD_MAX14577 is not set
> # CONFIG_MFD_MAX77686 is not set
> CONFIG_MFD_MAX77693=y
> # CONFIG_MFD_MAX8907 is not set
> CONFIG_MFD_MAX8925=y
> # CONFIG_MFD_MAX8997 is not set
> # CONFIG_MFD_MAX8998 is not set
> CONFIG_MFD_RETU=m
> CONFIG_MFD_PCF50633=y
> # CONFIG_PCF50633_ADC is not set
> # CONFIG_PCF50633_GPIO is not set
> CONFIG_MFD_RDC321X=y
> # CONFIG_MFD_RTSX_PCI is not set
> CONFIG_MFD_RC5T583=y
> CONFIG_MFD_SEC_CORE=y
> CONFIG_MFD_SI476X_CORE=m
> # CONFIG_MFD_SM501 is not set
> # CONFIG_MFD_SMSC is not set
> # CONFIG_ABX500_CORE is not set
> CONFIG_MFD_SYSCON=y
> CONFIG_MFD_TI_AM335X_TSCADC=y
> CONFIG_MFD_LP3943=m
> # CONFIG_MFD_LP8788 is not set
> CONFIG_MFD_PALMAS=y
> CONFIG_TPS6105X=m
> # CONFIG_TPS65010 is not set
> CONFIG_TPS6507X=m
> CONFIG_MFD_TPS65090=y
> CONFIG_MFD_TPS65217=m
> CONFIG_MFD_TPS65218=m
> # CONFIG_MFD_TPS6586X is not set
> # CONFIG_MFD_TPS65910 is not set
> CONFIG_MFD_TPS65912=y
> CONFIG_MFD_TPS65912_I2C=y
> CONFIG_MFD_TPS80031=y
> CONFIG_TWL4030_CORE=y
> # CONFIG_MFD_TWL4030_AUDIO is not set
> CONFIG_TWL6040_CORE=y
> # CONFIG_MFD_WL1273_CORE is not set
> CONFIG_MFD_LM3533=m
> CONFIG_MFD_TIMBERDALE=y
> CONFIG_MFD_TC3589X=y
> # CONFIG_MFD_TMIO is not set
> CONFIG_MFD_VX855=m
> CONFIG_MFD_ARIZONA=y
> CONFIG_MFD_ARIZONA_I2C=y
> CONFIG_MFD_WM5102=y
> CONFIG_MFD_WM5110=y
> CONFIG_MFD_WM8997=y
> CONFIG_MFD_WM8400=y
> CONFIG_MFD_WM831X=y
> CONFIG_MFD_WM831X_I2C=y
> CONFIG_MFD_WM8350=y
> CONFIG_MFD_WM8350_I2C=y
> # CONFIG_MFD_WM8994 is not set
> CONFIG_REGULATOR=y
> # CONFIG_REGULATOR_DEBUG is not set
> CONFIG_REGULATOR_FIXED_VOLTAGE=y
> # CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
> # CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
> CONFIG_REGULATOR_88PM8607=y
> CONFIG_REGULATOR_ACT8865=y
> CONFIG_REGULATOR_AD5398=y
> CONFIG_REGULATOR_ANATOP=y
> # CONFIG_REGULATOR_AAT2870 is not set
> CONFIG_REGULATOR_BCM590XX=m
> CONFIG_REGULATOR_DA903X=m
> CONFIG_REGULATOR_DA9052=m
> CONFIG_REGULATOR_DA9055=m
> CONFIG_REGULATOR_DA9063=m
> # CONFIG_REGULATOR_DA9210 is not set
> CONFIG_REGULATOR_FAN53555=y
> # CONFIG_REGULATOR_GPIO is not set
> CONFIG_REGULATOR_ISL6271A=y
> CONFIG_REGULATOR_LP3971=y
> CONFIG_REGULATOR_LP3972=m
> # CONFIG_REGULATOR_LP872X is not set
> CONFIG_REGULATOR_LP8755=m
> # CONFIG_REGULATOR_LTC3589 is not set
> # CONFIG_REGULATOR_MAX1586 is not set
> CONFIG_REGULATOR_MAX8649=m
> CONFIG_REGULATOR_MAX8660=y
> CONFIG_REGULATOR_MAX8925=m
> CONFIG_REGULATOR_MAX8952=m
> # CONFIG_REGULATOR_MAX8973 is not set
> # CONFIG_REGULATOR_MAX77693 is not set
> CONFIG_REGULATOR_PALMAS=m
> CONFIG_REGULATOR_PCF50633=y
> # CONFIG_REGULATOR_PFUZE100 is not set
> CONFIG_REGULATOR_RC5T583=m
> CONFIG_REGULATOR_S2MPA01=y
> CONFIG_REGULATOR_S2MPS11=y
> CONFIG_REGULATOR_S5M8767=m
> CONFIG_REGULATOR_TPS51632=m
> # CONFIG_REGULATOR_TPS6105X is not set
> # CONFIG_REGULATOR_TPS62360 is not set
> CONFIG_REGULATOR_TPS65023=m
> CONFIG_REGULATOR_TPS6507X=y
> CONFIG_REGULATOR_TPS65090=y
> CONFIG_REGULATOR_TPS65217=m
> # CONFIG_REGULATOR_TPS65912 is not set
> CONFIG_REGULATOR_TPS80031=y
> CONFIG_REGULATOR_TWL4030=m
> # CONFIG_REGULATOR_WM831X is not set
> # CONFIG_REGULATOR_WM8350 is not set
> CONFIG_REGULATOR_WM8400=m
> # CONFIG_MEDIA_SUPPORT is not set
> 
> #
> # Graphics support
> #
> CONFIG_AGP=y
> CONFIG_AGP_AMD64=y
> CONFIG_AGP_INTEL=y
> # CONFIG_AGP_SIS is not set
> CONFIG_AGP_VIA=m
> CONFIG_INTEL_GTT=y
> CONFIG_VGA_ARB=y
> CONFIG_VGA_ARB_MAX_GPUS=16
> # CONFIG_VGA_SWITCHEROO is not set
> 
> #
> # Direct Rendering Manager
> #
> CONFIG_DRM=y
> CONFIG_DRM_KMS_HELPER=y
> CONFIG_DRM_KMS_FB_HELPER=y
> # CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
> CONFIG_DRM_TTM=y
> 
> #
> # I2C encoder or helper chips
> #
> # CONFIG_DRM_I2C_CH7006 is not set
> # CONFIG_DRM_I2C_SIL164 is not set
> CONFIG_DRM_I2C_NXP_TDA998X=y
> CONFIG_DRM_PTN3460=m
> CONFIG_DRM_TDFX=m
> # CONFIG_DRM_R128 is not set
> CONFIG_DRM_RADEON=y
> CONFIG_DRM_RADEON_UMS=y
> # CONFIG_DRM_NOUVEAU is not set
> CONFIG_DRM_I810=y
> CONFIG_DRM_I915=y
> # CONFIG_DRM_I915_KMS is not set
> # CONFIG_DRM_I915_FBDEV is not set
> # CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT is not set
> CONFIG_DRM_MGA=y
> CONFIG_DRM_SIS=m
> CONFIG_DRM_VIA=y
> CONFIG_DRM_SAVAGE=m
> CONFIG_DRM_VMWGFX=y
> # CONFIG_DRM_VMWGFX_FBCON is not set
> CONFIG_DRM_GMA500=m
> CONFIG_DRM_GMA600=y
> CONFIG_DRM_GMA3600=y
> # CONFIG_DRM_UDL is not set
> CONFIG_DRM_AST=m
> CONFIG_DRM_MGAG200=y
> CONFIG_DRM_CIRRUS_QEMU=m
> CONFIG_DRM_QXL=m
> CONFIG_DRM_BOCHS=m
> 
> #
> # Frame buffer Devices
> #
> CONFIG_FB=y
> CONFIG_FIRMWARE_EDID=y
> CONFIG_FB_DDC=y
> # CONFIG_FB_BOOT_VESA_SUPPORT is not set
> CONFIG_FB_CFB_FILLRECT=y
> CONFIG_FB_CFB_COPYAREA=y
> CONFIG_FB_CFB_IMAGEBLIT=y
> # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
> CONFIG_FB_SYS_FILLRECT=y
> CONFIG_FB_SYS_COPYAREA=y
> CONFIG_FB_SYS_IMAGEBLIT=y
> # CONFIG_FB_FOREIGN_ENDIAN is not set
> CONFIG_FB_SYS_FOPS=y
> CONFIG_FB_DEFERRED_IO=y
> CONFIG_FB_SVGALIB=m
> # CONFIG_FB_MACMODES is not set
> CONFIG_FB_BACKLIGHT=y
> CONFIG_FB_MODE_HELPERS=y
> CONFIG_FB_TILEBLITTING=y
> 
> #
> # Frame buffer hardware drivers
> #
> # CONFIG_FB_CIRRUS is not set
> CONFIG_FB_PM2=y
> # CONFIG_FB_PM2_FIFO_DISCONNECT is not set
> CONFIG_FB_CYBER2000=y
> CONFIG_FB_CYBER2000_DDC=y
> CONFIG_FB_ARC=y
> CONFIG_FB_ASILIANT=y
> # CONFIG_FB_IMSTT is not set
> # CONFIG_FB_VGA16 is not set
> # CONFIG_FB_UVESA is not set
> # CONFIG_FB_VESA is not set
> # CONFIG_FB_N411 is not set
> CONFIG_FB_HGA=y
> CONFIG_FB_OPENCORES=y
> # CONFIG_FB_S1D13XXX is not set
> CONFIG_FB_NVIDIA=y
> CONFIG_FB_NVIDIA_I2C=y
> # CONFIG_FB_NVIDIA_DEBUG is not set
> # CONFIG_FB_NVIDIA_BACKLIGHT is not set
> # CONFIG_FB_RIVA is not set
> CONFIG_FB_I740=y
> CONFIG_FB_LE80578=m
> CONFIG_FB_CARILLO_RANCH=m
> CONFIG_FB_MATROX=y
> CONFIG_FB_MATROX_MILLENIUM=y
> CONFIG_FB_MATROX_MYSTIQUE=y
> CONFIG_FB_MATROX_G=y
> CONFIG_FB_MATROX_I2C=y
> # CONFIG_FB_MATROX_MAVEN is not set
> # CONFIG_FB_RADEON is not set
> CONFIG_FB_ATY128=m
> CONFIG_FB_ATY128_BACKLIGHT=y
> CONFIG_FB_ATY=m
> CONFIG_FB_ATY_CT=y
> # CONFIG_FB_ATY_GENERIC_LCD is not set
> CONFIG_FB_ATY_GX=y
> CONFIG_FB_ATY_BACKLIGHT=y
> # CONFIG_FB_S3 is not set
> CONFIG_FB_SAVAGE=m
> # CONFIG_FB_SAVAGE_I2C is not set
> CONFIG_FB_SAVAGE_ACCEL=y
> CONFIG_FB_SIS=m
> CONFIG_FB_SIS_300=y
> # CONFIG_FB_SIS_315 is not set
> CONFIG_FB_VIA=m
> # CONFIG_FB_VIA_DIRECT_PROCFS is not set
> CONFIG_FB_VIA_X_COMPATIBILITY=y
> CONFIG_FB_NEOMAGIC=y
> CONFIG_FB_KYRO=y
> CONFIG_FB_3DFX=y
> CONFIG_FB_3DFX_ACCEL=y
> CONFIG_FB_3DFX_I2C=y
> CONFIG_FB_VOODOO1=y
> # CONFIG_FB_VT8623 is not set
> CONFIG_FB_TRIDENT=m
> CONFIG_FB_ARK=m
> CONFIG_FB_PM3=y
> # CONFIG_FB_CARMINE is not set
> CONFIG_FB_VIRTUAL=m
> CONFIG_FB_METRONOME=y
> CONFIG_FB_MB862XX=y
> CONFIG_FB_MB862XX_PCI_GDC=y
> # CONFIG_FB_MB862XX_I2C is not set
> CONFIG_FB_BROADSHEET=y
> CONFIG_FB_AUO_K190X=y
> CONFIG_FB_AUO_K1900=m
> # CONFIG_FB_AUO_K1901 is not set
> CONFIG_FB_SIMPLE=y
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> CONFIG_LCD_CLASS_DEVICE=m
> # CONFIG_LCD_PLATFORM is not set
> CONFIG_BACKLIGHT_CLASS_DEVICE=y
> # CONFIG_BACKLIGHT_GENERIC is not set
> CONFIG_BACKLIGHT_LM3533=m
> CONFIG_BACKLIGHT_CARILLO_RANCH=m
> CONFIG_BACKLIGHT_DA903X=m
> CONFIG_BACKLIGHT_DA9052=y
> CONFIG_BACKLIGHT_MAX8925=m
> # CONFIG_BACKLIGHT_APPLE is not set
> # CONFIG_BACKLIGHT_SAHARA is not set
> CONFIG_BACKLIGHT_WM831X=m
> # CONFIG_BACKLIGHT_ADP8860 is not set
> # CONFIG_BACKLIGHT_ADP8870 is not set
> CONFIG_BACKLIGHT_88PM860X=m
> CONFIG_BACKLIGHT_PCF50633=y
> # CONFIG_BACKLIGHT_AAT2870 is not set
> # CONFIG_BACKLIGHT_LM3639 is not set
> # CONFIG_BACKLIGHT_PANDORA is not set
> CONFIG_BACKLIGHT_TPS65217=m
> # CONFIG_BACKLIGHT_GPIO is not set
> CONFIG_BACKLIGHT_LV5207LP=y
> # CONFIG_BACKLIGHT_BD6107 is not set
> CONFIG_VGASTATE=y
> CONFIG_HDMI=y
> 
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> # CONFIG_VGACON_SOFT_SCROLLBACK is not set
> CONFIG_DUMMY_CONSOLE=y
> CONFIG_FRAMEBUFFER_CONSOLE=y
> CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
> CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
> CONFIG_LOGO=y
> CONFIG_LOGO_LINUX_MONO=y
> # CONFIG_LOGO_LINUX_VGA16 is not set
> # CONFIG_LOGO_LINUX_CLUT224 is not set
> # CONFIG_SOUND is not set
> 
> #
> # HID support
> #
> CONFIG_HID=y
> # CONFIG_HID_BATTERY_STRENGTH is not set
> # CONFIG_HIDRAW is not set
> CONFIG_UHID=y
> CONFIG_HID_GENERIC=y
> 
> #
> # Special HID drivers
> #
> CONFIG_HID_A4TECH=y
> CONFIG_HID_ACRUX=m
> CONFIG_HID_ACRUX_FF=y
> CONFIG_HID_APPLE=y
> CONFIG_HID_AUREAL=y
> CONFIG_HID_BELKIN=y
> CONFIG_HID_CHERRY=y
> CONFIG_HID_CHICONY=y
> CONFIG_HID_CYPRESS=y
> # CONFIG_HID_DRAGONRISE is not set
> # CONFIG_HID_EMS_FF is not set
> # CONFIG_HID_ELECOM is not set
> CONFIG_HID_EZKEY=y
> CONFIG_HID_KEYTOUCH=m
> CONFIG_HID_KYE=y
> CONFIG_HID_UCLOGIC=m
> CONFIG_HID_WALTOP=y
> # CONFIG_HID_GYRATION is not set
> # CONFIG_HID_ICADE is not set
> CONFIG_HID_TWINHAN=y
> CONFIG_HID_KENSINGTON=y
> CONFIG_HID_LCPOWER=y
> # CONFIG_HID_LENOVO_TPKBD is not set
> CONFIG_HID_LOGITECH=y
> CONFIG_LOGITECH_FF=y
> # CONFIG_LOGIRUMBLEPAD2_FF is not set
> CONFIG_LOGIG940_FF=y
> # CONFIG_LOGIWHEELS_FF is not set
> # CONFIG_HID_MAGICMOUSE is not set
> CONFIG_HID_MICROSOFT=y
> CONFIG_HID_MONTEREY=y
> CONFIG_HID_MULTITOUCH=m
> CONFIG_HID_ORTEK=y
> CONFIG_HID_PANTHERLORD=y
> CONFIG_PANTHERLORD_FF=y
> # CONFIG_HID_PETALYNX is not set
> CONFIG_HID_PICOLCD=m
> CONFIG_HID_PICOLCD_FB=y
> CONFIG_HID_PICOLCD_BACKLIGHT=y
> CONFIG_HID_PICOLCD_LCD=y
> CONFIG_HID_PRIMAX=y
> # CONFIG_HID_SAITEK is not set
> # CONFIG_HID_SAMSUNG is not set
> # CONFIG_HID_SPEEDLINK is not set
> # CONFIG_HID_STEELSERIES is not set
> # CONFIG_HID_SUNPLUS is not set
> CONFIG_HID_RMI=m
> CONFIG_HID_GREENASIA=m
> # CONFIG_GREENASIA_FF is not set
> CONFIG_HID_SMARTJOYPLUS=m
> CONFIG_SMARTJOYPLUS_FF=y
> # CONFIG_HID_TIVO is not set
> # CONFIG_HID_TOPSEED is not set
> CONFIG_HID_THRUSTMASTER=y
> # CONFIG_THRUSTMASTER_FF is not set
> CONFIG_HID_XINMO=m
> CONFIG_HID_ZEROPLUS=y
> # CONFIG_ZEROPLUS_FF is not set
> CONFIG_HID_ZYDACRON=y
> # CONFIG_HID_SENSOR_HUB is not set
> 
> #
> # I2C HID support
> #
> CONFIG_I2C_HID=y
> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_ARCH_HAS_HCD=y
> # CONFIG_USB is not set
> 
> #
> # USB port drivers
> #
> 
> #
> # USB Physical Layer drivers
> #
> # CONFIG_USB_PHY is not set
> # CONFIG_NOP_USB_XCEIV is not set
> # CONFIG_SAMSUNG_USB2PHY is not set
> # CONFIG_SAMSUNG_USB3PHY is not set
> # CONFIG_USB_GPIO_VBUS is not set
> # CONFIG_USB_GADGET is not set
> CONFIG_UWB=y
> CONFIG_UWB_WHCI=y
> CONFIG_MMC=y
> # CONFIG_MMC_DEBUG is not set
> # CONFIG_MMC_CLKGATE is not set
> 
> #
> # MMC/SD/SDIO Card Drivers
> #
> CONFIG_MMC_BLOCK=m
> CONFIG_MMC_BLOCK_MINORS=8
> # CONFIG_MMC_BLOCK_BOUNCE is not set
> CONFIG_SDIO_UART=m
> CONFIG_MMC_TEST=m
> 
> #
> # MMC/SD/SDIO Host Controller Drivers
> #
> CONFIG_MMC_SDHCI=y
> CONFIG_MMC_SDHCI_PCI=y
> # CONFIG_MMC_RICOH_MMC is not set
> # CONFIG_MMC_SDHCI_ACPI is not set
> CONFIG_MMC_SDHCI_PLTFM=y
> CONFIG_MMC_WBSD=y
> CONFIG_MMC_TIFM_SD=y
> # CONFIG_MMC_CB710 is not set
> # CONFIG_MMC_VIA_SDMMC is not set
> CONFIG_MMC_USDHI6ROL0=y
> # CONFIG_MEMSTICK is not set
> # CONFIG_NEW_LEDS is not set
> CONFIG_ACCESSIBILITY=y
> CONFIG_A11Y_BRAILLE_CONSOLE=y
> # CONFIG_EDAC is not set
> CONFIG_RTC_LIB=y
> CONFIG_RTC_CLASS=y
> # CONFIG_RTC_HCTOSYS is not set
> # CONFIG_RTC_SYSTOHC is not set
> # CONFIG_RTC_DEBUG is not set
> 
> #
> # RTC interfaces
> #
> CONFIG_RTC_INTF_SYSFS=y
> CONFIG_RTC_INTF_PROC=y
> CONFIG_RTC_INTF_DEV=y
> CONFIG_RTC_INTF_DEV_UIE_EMUL=y
> CONFIG_RTC_DRV_TEST=m
> 
> #
> # I2C RTC drivers
> #
> CONFIG_RTC_DRV_88PM860X=y
> # CONFIG_RTC_DRV_DS1307 is not set
> # CONFIG_RTC_DRV_DS1374 is not set
> CONFIG_RTC_DRV_DS1672=y
> # CONFIG_RTC_DRV_DS3232 is not set
> # CONFIG_RTC_DRV_MAX6900 is not set
> CONFIG_RTC_DRV_MAX8925=y
> CONFIG_RTC_DRV_RS5C372=y
> CONFIG_RTC_DRV_ISL1208=m
> # CONFIG_RTC_DRV_ISL12022 is not set
> CONFIG_RTC_DRV_ISL12057=m
> CONFIG_RTC_DRV_X1205=m
> # CONFIG_RTC_DRV_PALMAS is not set
> # CONFIG_RTC_DRV_PCF2127 is not set
> CONFIG_RTC_DRV_PCF8523=y
> # CONFIG_RTC_DRV_PCF8563 is not set
> # CONFIG_RTC_DRV_PCF8583 is not set
> CONFIG_RTC_DRV_M41T80=m
> # CONFIG_RTC_DRV_M41T80_WDT is not set
> CONFIG_RTC_DRV_BQ32K=y
> CONFIG_RTC_DRV_TWL4030=m
> CONFIG_RTC_DRV_TPS80031=m
> CONFIG_RTC_DRV_RC5T583=y
> CONFIG_RTC_DRV_S35390A=y
> CONFIG_RTC_DRV_FM3130=y
> CONFIG_RTC_DRV_RX8581=m
> # CONFIG_RTC_DRV_RX8025 is not set
> CONFIG_RTC_DRV_EM3027=m
> CONFIG_RTC_DRV_RV3029C2=y
> CONFIG_RTC_DRV_S5M=m
> 
> #
> # SPI RTC drivers
> #
> 
> #
> # Platform RTC drivers
> #
> CONFIG_RTC_DRV_CMOS=m
> CONFIG_RTC_DRV_DS1286=m
> # CONFIG_RTC_DRV_DS1511 is not set
> # CONFIG_RTC_DRV_DS1553 is not set
> CONFIG_RTC_DRV_DS1742=m
> CONFIG_RTC_DRV_DA9052=m
> # CONFIG_RTC_DRV_DA9055 is not set
> # CONFIG_RTC_DRV_DA9063 is not set
> CONFIG_RTC_DRV_STK17TA8=m
> CONFIG_RTC_DRV_M48T86=y
> CONFIG_RTC_DRV_M48T35=y
> CONFIG_RTC_DRV_M48T59=m
> # CONFIG_RTC_DRV_MSM6242 is not set
> # CONFIG_RTC_DRV_BQ4802 is not set
> CONFIG_RTC_DRV_RP5C01=m
> CONFIG_RTC_DRV_V3020=y
> CONFIG_RTC_DRV_DS2404=m
> CONFIG_RTC_DRV_WM831X=y
> CONFIG_RTC_DRV_WM8350=m
> CONFIG_RTC_DRV_PCF50633=m
> 
> #
> # on-CPU RTC drivers
> #
> CONFIG_RTC_DRV_MOXART=m
> # CONFIG_RTC_DRV_XGENE is not set
> 
> #
> # HID Sensor RTC drivers
> #
> # CONFIG_DMADEVICES is not set
> CONFIG_AUXDISPLAY=y
> CONFIG_KS0108=m
> CONFIG_KS0108_PORT=0x378
> CONFIG_KS0108_DELAY=2
> CONFIG_CFAG12864B=m
> CONFIG_CFAG12864B_RATE=20
> CONFIG_UIO=y
> CONFIG_UIO_CIF=m
> # CONFIG_UIO_PDRV_GENIRQ is not set
> # CONFIG_UIO_DMEM_GENIRQ is not set
> CONFIG_UIO_AEC=m
> CONFIG_UIO_SERCOS3=m
> # CONFIG_UIO_PCI_GENERIC is not set
> CONFIG_UIO_NETX=m
> CONFIG_UIO_MF624=y
> CONFIG_VIRT_DRIVERS=y
> CONFIG_VIRTIO=y
> 
> #
> # Virtio drivers
> #
> CONFIG_VIRTIO_PCI=y
> CONFIG_VIRTIO_BALLOON=y
> CONFIG_VIRTIO_MMIO=y
> # CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set
> 
> #
> # Microsoft Hyper-V guest support
> #
> # CONFIG_HYPERV is not set
> CONFIG_STAGING=y
> # CONFIG_ET131X is not set
> CONFIG_SLICOSS=m
> # CONFIG_COMEDI is not set
> CONFIG_PANEL=y
> CONFIG_PANEL_PARPORT=0
> CONFIG_PANEL_PROFILE=5
> CONFIG_PANEL_CHANGE_MESSAGE=y
> CONFIG_PANEL_BOOT_MESSAGE=""
> CONFIG_RTS5208=m
> # CONFIG_RTS5208_DEBUG is not set
> CONFIG_DX_SEP=y
> # CONFIG_CRYSTALHD is not set
> CONFIG_CXT1E1=y
> CONFIG_SBE_PMCC4_NCOMM=y
> # CONFIG_FB_XGI is not set
> # CONFIG_ACPI_QUICKSTART is not set
> # CONFIG_FT1000 is not set
> 
> #
> # Speakup console speech
> #
> CONFIG_SPEAKUP=y
> # CONFIG_SPEAKUP_SYNTH_ACNTSA is not set
> CONFIG_SPEAKUP_SYNTH_APOLLO=m
> CONFIG_SPEAKUP_SYNTH_AUDPTR=y
> CONFIG_SPEAKUP_SYNTH_BNS=y
> CONFIG_SPEAKUP_SYNTH_DECTLK=y
> # CONFIG_SPEAKUP_SYNTH_DECEXT is not set
> CONFIG_SPEAKUP_SYNTH_LTLK=m
> # CONFIG_SPEAKUP_SYNTH_SOFT is not set
> # CONFIG_SPEAKUP_SYNTH_SPKOUT is not set
> CONFIG_SPEAKUP_SYNTH_TXPRT=y
> CONFIG_SPEAKUP_SYNTH_DUMMY=y
> CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=m
> # CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
> # CONFIG_STAGING_MEDIA is not set
> 
> #
> # Android
> #
> CONFIG_ANDROID=y
> CONFIG_ANDROID_BINDER_IPC=y
> CONFIG_ASHMEM=y
> CONFIG_ANDROID_LOGGER=y
> # CONFIG_ANDROID_TIMED_OUTPUT is not set
> CONFIG_ANDROID_LOW_MEMORY_KILLER=y
> CONFIG_ANDROID_INTF_ALARM_DEV=y
> CONFIG_SYNC=y
> # CONFIG_SW_SYNC is not set
> # CONFIG_ION is not set
> CONFIG_WIMAX_GDM72XX=y
> # CONFIG_WIMAX_GDM72XX_QOS is not set
> CONFIG_WIMAX_GDM72XX_K_MODE=y
> # CONFIG_WIMAX_GDM72XX_WIMAX2 is not set
> CONFIG_WIMAX_GDM72XX_SDIO=y
> # CONFIG_NET_VENDOR_SILICOM is not set
> # CONFIG_DGRP is not set
> # CONFIG_XILLYBUS is not set
> CONFIG_DGNC=m
> # CONFIG_DGAP is not set
> CONFIG_GS_FPGABOOT=y
> # CONFIG_CRYPTO_SKEIN is not set
> CONFIG_CRYPTO_THREEFISH=y
> # CONFIG_X86_PLATFORM_DEVICES is not set
> CONFIG_CHROME_PLATFORMS=y
> CONFIG_CHROMEOS_LAPTOP=y
> CONFIG_CHROMEOS_PSTORE=y
> 
> #
> # SOC (System On Chip) specific Drivers
> #
> 
> #
> # Hardware Spinlock drivers
> #
> CONFIG_CLKEVT_I8253=y
> CONFIG_I8253_LOCK=y
> CONFIG_CLKBLD_I8253=y
> # CONFIG_SH_TIMER_CMT is not set
> # CONFIG_SH_TIMER_MTU2 is not set
> # CONFIG_SH_TIMER_TMU is not set
> # CONFIG_EM_TIMER_STI is not set
> CONFIG_MAILBOX=y
> CONFIG_IOMMU_SUPPORT=y
> # CONFIG_AMD_IOMMU is not set
> 
> #
> # Remoteproc drivers
> #
> # CONFIG_STE_MODEM_RPROC is not set
> 
> #
> # Rpmsg drivers
> #
> # CONFIG_PM_DEVFREQ is not set
> # CONFIG_EXTCON is not set
> CONFIG_MEMORY=y
> # CONFIG_IIO is not set
> CONFIG_NTB=m
> CONFIG_VME_BUS=y
> 
> #
> # VME Bridge Drivers
> #
> # CONFIG_VME_CA91CX42 is not set
> CONFIG_VME_TSI148=m
> 
> #
> # VME Board Drivers
> #
> CONFIG_VMIVME_7805=y
> 
> #
> # VME Device Drivers
> #
> # CONFIG_VME_USER is not set
> CONFIG_VME_PIO2=m
> # CONFIG_PWM is not set
> # CONFIG_IPACK_BUS is not set
> CONFIG_RESET_CONTROLLER=y
> CONFIG_FMC=y
> CONFIG_FMC_FAKEDEV=m
> CONFIG_FMC_TRIVIAL=y
> CONFIG_FMC_WRITE_EEPROM=m
> CONFIG_FMC_CHARDEV=y
> 
> #
> # PHY Subsystem
> #
> CONFIG_GENERIC_PHY=y
> CONFIG_BCM_KONA_USB2_PHY=y
> CONFIG_PHY_SAMSUNG_USB2=y
> CONFIG_POWERCAP=y
> CONFIG_INTEL_RAPL=y
> CONFIG_MCB=y
> CONFIG_MCB_PCI=y
> 
> #
> # Firmware Drivers
> #
> CONFIG_EDD=m
> # CONFIG_EDD_OFF is not set
> CONFIG_FIRMWARE_MEMMAP=y
> CONFIG_DELL_RBU=y
> # CONFIG_DCDBAS is not set
> # CONFIG_DMIID is not set
> # CONFIG_DMI_SYSFS is not set
> CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
> # CONFIG_ISCSI_IBFT_FIND is not set
> # CONFIG_GOOGLE_FIRMWARE is not set
> 
> #
> # File systems
> #
> CONFIG_DCACHE_WORD_ACCESS=y
> CONFIG_EXT2_FS=m
> # CONFIG_EXT2_FS_XATTR is not set
> CONFIG_EXT2_FS_XIP=y
> CONFIG_EXT3_FS=y
> CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
> CONFIG_EXT3_FS_XATTR=y
> # CONFIG_EXT3_FS_POSIX_ACL is not set
> # CONFIG_EXT3_FS_SECURITY is not set
> CONFIG_EXT4_FS=y
> # CONFIG_EXT4_FS_POSIX_ACL is not set
> CONFIG_EXT4_FS_SECURITY=y
> CONFIG_EXT4_DEBUG=y
> CONFIG_FS_XIP=y
> CONFIG_JBD=y
> # CONFIG_JBD_DEBUG is not set
> CONFIG_JBD2=y
> # CONFIG_JBD2_DEBUG is not set
> CONFIG_FS_MBCACHE=y
> CONFIG_REISERFS_FS=y
> CONFIG_REISERFS_CHECK=y
> CONFIG_REISERFS_PROC_INFO=y
> # CONFIG_REISERFS_FS_XATTR is not set
> CONFIG_JFS_FS=y
> CONFIG_JFS_POSIX_ACL=y
> CONFIG_JFS_SECURITY=y
> # CONFIG_JFS_DEBUG is not set
> CONFIG_JFS_STATISTICS=y
> CONFIG_XFS_FS=m
> CONFIG_XFS_QUOTA=y
> CONFIG_XFS_POSIX_ACL=y
> CONFIG_XFS_RT=y
> CONFIG_XFS_DEBUG=y
> CONFIG_GFS2_FS=m
> CONFIG_OCFS2_FS=m
> CONFIG_OCFS2_FS_O2CB=m
> # CONFIG_OCFS2_FS_STATS is not set
> CONFIG_OCFS2_DEBUG_MASKLOG=y
> CONFIG_OCFS2_DEBUG_FS=y
> CONFIG_BTRFS_FS=y
> # CONFIG_BTRFS_FS_POSIX_ACL is not set
> CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
> # CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
> # CONFIG_BTRFS_DEBUG is not set
> CONFIG_BTRFS_ASSERT=y
> CONFIG_NILFS2_FS=m
> CONFIG_FS_POSIX_ACL=y
> CONFIG_EXPORTFS=y
> CONFIG_FILE_LOCKING=y
> CONFIG_FSNOTIFY=y
> CONFIG_DNOTIFY=y
> CONFIG_INOTIFY_USER=y
> CONFIG_FANOTIFY=y
> CONFIG_QUOTA=y
> # CONFIG_QUOTA_NETLINK_INTERFACE is not set
> # CONFIG_PRINT_QUOTA_WARNING is not set
> CONFIG_QUOTA_DEBUG=y
> CONFIG_QUOTA_TREE=m
> CONFIG_QFMT_V1=m
> # CONFIG_QFMT_V2 is not set
> CONFIG_QUOTACTL=y
> CONFIG_QUOTACTL_COMPAT=y
> CONFIG_AUTOFS4_FS=y
> CONFIG_FUSE_FS=m
> # CONFIG_CUSE is not set
> 
> #
> # Caches
> #
> # CONFIG_FSCACHE is not set
> 
> #
> # CD-ROM/DVD Filesystems
> #
> CONFIG_ISO9660_FS=m
> # CONFIG_JOLIET is not set
> # CONFIG_ZISOFS is not set
> CONFIG_UDF_FS=m
> CONFIG_UDF_NLS=y
> 
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=m
> # CONFIG_MSDOS_FS is not set
> CONFIG_VFAT_FS=m
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
> CONFIG_NTFS_FS=m
> # CONFIG_NTFS_DEBUG is not set
> # CONFIG_NTFS_RW is not set
> 
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> # CONFIG_PROC_KCORE is not set
> # CONFIG_PROC_VMCORE is not set
> CONFIG_PROC_SYSCTL=y
> CONFIG_PROC_PAGE_MONITOR=y
> CONFIG_KERNFS=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> # CONFIG_TMPFS_POSIX_ACL is not set
> # CONFIG_TMPFS_XATTR is not set
> CONFIG_HUGETLBFS=y
> CONFIG_HUGETLB_PAGE=y
> CONFIG_CONFIGFS_FS=m
> CONFIG_MISC_FILESYSTEMS=y
> CONFIG_ADFS_FS=m
> CONFIG_ADFS_FS_RW=y
> CONFIG_AFFS_FS=y
> # CONFIG_ECRYPT_FS is not set
> CONFIG_HFS_FS=y
> CONFIG_HFSPLUS_FS=y
> CONFIG_HFSPLUS_FS_POSIX_ACL=y
> CONFIG_BEFS_FS=m
> CONFIG_BEFS_DEBUG=y
> # CONFIG_BFS_FS is not set
> # CONFIG_EFS_FS is not set
> CONFIG_JFFS2_FS=m
> CONFIG_JFFS2_FS_DEBUG=0
> # CONFIG_JFFS2_FS_WRITEBUFFER is not set
> CONFIG_JFFS2_SUMMARY=y
> CONFIG_JFFS2_FS_XATTR=y
> CONFIG_JFFS2_FS_POSIX_ACL=y
> # CONFIG_JFFS2_FS_SECURITY is not set
> # CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
> CONFIG_JFFS2_ZLIB=y
> # CONFIG_JFFS2_LZO is not set
> CONFIG_JFFS2_RTIME=y
> # CONFIG_JFFS2_RUBIN is not set
> # CONFIG_LOGFS is not set
> CONFIG_CRAMFS=m
> CONFIG_SQUASHFS=m
> CONFIG_SQUASHFS_FILE_CACHE=y
> # CONFIG_SQUASHFS_FILE_DIRECT is not set
> # CONFIG_SQUASHFS_DECOMP_SINGLE is not set
> # CONFIG_SQUASHFS_DECOMP_MULTI is not set
> CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y
> CONFIG_SQUASHFS_XATTR=y
> CONFIG_SQUASHFS_ZLIB=y
> # CONFIG_SQUASHFS_LZO is not set
> CONFIG_SQUASHFS_XZ=y
> # CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
> CONFIG_SQUASHFS_EMBEDDED=y
> CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
> CONFIG_VXFS_FS=m
> CONFIG_MINIX_FS=m
> CONFIG_OMFS_FS=y
> # CONFIG_HPFS_FS is not set
> CONFIG_QNX4FS_FS=y
> CONFIG_QNX6FS_FS=m
> CONFIG_QNX6FS_DEBUG=y
> # CONFIG_ROMFS_FS is not set
> # CONFIG_PSTORE is not set
> CONFIG_SYSV_FS=m
> # CONFIG_UFS_FS is not set
> CONFIG_F2FS_FS=m
> # CONFIG_F2FS_STAT_FS is not set
> # CONFIG_F2FS_FS_XATTR is not set
> # CONFIG_F2FS_CHECK_FS is not set
> # CONFIG_NETWORK_FILESYSTEMS is not set
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="iso8859-1"
> CONFIG_NLS_CODEPAGE_437=m
> CONFIG_NLS_CODEPAGE_737=m
> CONFIG_NLS_CODEPAGE_775=y
> CONFIG_NLS_CODEPAGE_850=m
> CONFIG_NLS_CODEPAGE_852=y
> # CONFIG_NLS_CODEPAGE_855 is not set
> CONFIG_NLS_CODEPAGE_857=m
> CONFIG_NLS_CODEPAGE_860=y
> # CONFIG_NLS_CODEPAGE_861 is not set
> # CONFIG_NLS_CODEPAGE_862 is not set
> CONFIG_NLS_CODEPAGE_863=m
> CONFIG_NLS_CODEPAGE_864=m
> CONFIG_NLS_CODEPAGE_865=y
> CONFIG_NLS_CODEPAGE_866=y
> CONFIG_NLS_CODEPAGE_869=y
> CONFIG_NLS_CODEPAGE_936=y
> # CONFIG_NLS_CODEPAGE_950 is not set
> CONFIG_NLS_CODEPAGE_932=m
> CONFIG_NLS_CODEPAGE_949=y
> # CONFIG_NLS_CODEPAGE_874 is not set
> CONFIG_NLS_ISO8859_8=m
> # CONFIG_NLS_CODEPAGE_1250 is not set
> CONFIG_NLS_CODEPAGE_1251=m
> CONFIG_NLS_ASCII=y
> CONFIG_NLS_ISO8859_1=m
> CONFIG_NLS_ISO8859_2=y
> CONFIG_NLS_ISO8859_3=m
> CONFIG_NLS_ISO8859_4=y
> CONFIG_NLS_ISO8859_5=y
> CONFIG_NLS_ISO8859_6=y
> CONFIG_NLS_ISO8859_7=y
> CONFIG_NLS_ISO8859_9=y
> CONFIG_NLS_ISO8859_13=y
> CONFIG_NLS_ISO8859_14=y
> CONFIG_NLS_ISO8859_15=y
> # CONFIG_NLS_KOI8_R is not set
> CONFIG_NLS_KOI8_U=m
> CONFIG_NLS_MAC_ROMAN=y
> CONFIG_NLS_MAC_CELTIC=m
> CONFIG_NLS_MAC_CENTEURO=y
> CONFIG_NLS_MAC_CROATIAN=y
> # CONFIG_NLS_MAC_CYRILLIC is not set
> CONFIG_NLS_MAC_GAELIC=m
> # CONFIG_NLS_MAC_GREEK is not set
> # CONFIG_NLS_MAC_ICELAND is not set
> CONFIG_NLS_MAC_INUIT=m
> # CONFIG_NLS_MAC_ROMANIAN is not set
> CONFIG_NLS_MAC_TURKISH=y
> CONFIG_NLS_UTF8=y
> 
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> 
> #
> # printk and dmesg options
> #
> CONFIG_PRINTK_TIME=y
> CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
> # CONFIG_BOOT_PRINTK_DELAY is not set
> CONFIG_DYNAMIC_DEBUG=y
> 
> #
> # Compile-time checks and compiler options
> #
> # CONFIG_DEBUG_INFO is not set
> # CONFIG_ENABLE_WARN_DEPRECATED is not set
> CONFIG_ENABLE_MUST_CHECK=y
> CONFIG_FRAME_WARN=2048
> CONFIG_STRIP_ASM_SYMS=y
> # CONFIG_READABLE_ASM is not set
> # CONFIG_UNUSED_SYMBOLS is not set
> CONFIG_DEBUG_FS=y
> CONFIG_HEADERS_CHECK=y
> # CONFIG_DEBUG_SECTION_MISMATCH is not set
> CONFIG_ARCH_WANT_FRAME_POINTERS=y
> CONFIG_FRAME_POINTER=y
> # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
> CONFIG_MAGIC_SYSRQ=y
> CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
> CONFIG_DEBUG_KERNEL=y
> 
> #
> # Memory Debugging
> #
> # CONFIG_DEBUG_PAGEALLOC is not set
> # CONFIG_DEBUG_OBJECTS is not set
> CONFIG_SLUB_DEBUG_ON=y
> # CONFIG_SLUB_STATS is not set
> CONFIG_HAVE_DEBUG_KMEMLEAK=y
> # CONFIG_DEBUG_KMEMLEAK is not set
> # CONFIG_DEBUG_STACK_USAGE is not set
> # CONFIG_DEBUG_VM is not set
> # CONFIG_DEBUG_VIRTUAL is not set
> CONFIG_DEBUG_MEMORY_INIT=y
> # CONFIG_DEBUG_PER_CPU_MAPS is not set
> CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
> # CONFIG_DEBUG_STACKOVERFLOW is not set
> CONFIG_HAVE_ARCH_KMEMCHECK=y
> # CONFIG_KMEMCHECK is not set
> # CONFIG_DEBUG_SHIRQ is not set
> 
> #
> # Debug Lockups and Hangs
> #
> # CONFIG_LOCKUP_DETECTOR is not set
> # CONFIG_DETECT_HUNG_TASK is not set
> CONFIG_PANIC_ON_OOPS=y
> CONFIG_PANIC_ON_OOPS_VALUE=1
> CONFIG_PANIC_TIMEOUT=0
> CONFIG_SCHED_DEBUG=y
> # CONFIG_SCHEDSTATS is not set
> # CONFIG_TIMER_STATS is not set
> 
> #
> # Lock Debugging (spinlocks, mutexes, etc...)
> #
> # CONFIG_DEBUG_RT_MUTEXES is not set
> # CONFIG_RT_MUTEX_TESTER is not set
> # CONFIG_DEBUG_SPINLOCK is not set
> # CONFIG_DEBUG_MUTEXES is not set
> # CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
> # CONFIG_DEBUG_LOCK_ALLOC is not set
> # CONFIG_PROVE_LOCKING is not set
> # CONFIG_LOCK_STAT is not set
> CONFIG_DEBUG_ATOMIC_SLEEP=y
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> # CONFIG_LOCK_TORTURE_TEST is not set
> # CONFIG_DEBUG_KOBJECT is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> # CONFIG_DEBUG_LIST is not set
> # CONFIG_DEBUG_PI_LIST is not set
> # CONFIG_DEBUG_SG is not set
> # CONFIG_DEBUG_NOTIFIERS is not set
> # CONFIG_DEBUG_CREDENTIALS is not set
> 
> #
> # RCU Debugging
> #
> # CONFIG_SPARSE_RCU_POINTER is not set
> # CONFIG_TORTURE_TEST is not set
> # CONFIG_RCU_TORTURE_TEST is not set
> CONFIG_RCU_CPU_STALL_TIMEOUT=21
> # CONFIG_RCU_CPU_STALL_INFO is not set
> # CONFIG_RCU_TRACE is not set
> # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
> # CONFIG_NOTIFIER_ERROR_INJECTION is not set
> # CONFIG_FAULT_INJECTION is not set
> # CONFIG_LATENCYTOP is not set
> CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
> # CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
> CONFIG_USER_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
> CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
> CONFIG_HAVE_FENTRY=y
> CONFIG_HAVE_C_RECORDMCOUNT=y
> CONFIG_TRACE_CLOCK=y
> CONFIG_RING_BUFFER=y
> CONFIG_RING_BUFFER_ALLOW_SWAP=y
> CONFIG_TRACING_SUPPORT=y
> # CONFIG_FTRACE is not set
> 
> #
> # Runtime Testing
> #
> CONFIG_LKDTM=m
> # CONFIG_TEST_LIST_SORT is not set
> # CONFIG_KPROBES_SANITY_TEST is not set
> # CONFIG_BACKTRACE_SELF_TEST is not set
> # CONFIG_RBTREE_TEST is not set
> # CONFIG_INTERVAL_TREE_TEST is not set
> # CONFIG_PERCPU_TEST is not set
> # CONFIG_ATOMIC64_SELFTEST is not set
> # CONFIG_ASYNC_RAID6_TEST is not set
> CONFIG_TEST_STRING_HELPERS=y
> # CONFIG_TEST_KSTRTOX is not set
> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
> # CONFIG_BUILD_DOCSRC is not set
> # CONFIG_DMA_API_DEBUG is not set
> CONFIG_TEST_MODULE=m
> CONFIG_TEST_USER_COPY=m
> CONFIG_TEST_BPF=m
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> # CONFIG_KGDB is not set
> CONFIG_STRICT_DEVMEM=y
> CONFIG_X86_VERBOSE_BOOTUP=y
> CONFIG_EARLY_PRINTK=y
> # CONFIG_EARLY_PRINTK_DBGP is not set
> # CONFIG_X86_PTDUMP is not set
> CONFIG_DEBUG_RODATA=y
> CONFIG_DEBUG_RODATA_TEST=y
> CONFIG_DEBUG_SET_MODULE_RONX=y
> # CONFIG_DEBUG_NX_TEST is not set
> CONFIG_DOUBLEFAULT=y
> # CONFIG_DEBUG_TLBFLUSH is not set
> # CONFIG_IOMMU_STRESS is not set
> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> # CONFIG_X86_DECODER_SELFTEST is not set
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> CONFIG_IO_DELAY_0X80=y
> # CONFIG_IO_DELAY_0XED is not set
> # CONFIG_IO_DELAY_UDELAY is not set
> # CONFIG_IO_DELAY_NONE is not set
> CONFIG_DEFAULT_IO_DELAY_TYPE=0
> # CONFIG_DEBUG_BOOT_PARAMS is not set
> # CONFIG_CPA_DEBUG is not set
> # CONFIG_OPTIMIZE_INLINING is not set
> # CONFIG_DEBUG_NMI_SELFTEST is not set
> # CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set
> 
> #
> # Security options
> #
> CONFIG_KEYS=y
> CONFIG_PERSISTENT_KEYRINGS=y
> # CONFIG_BIG_KEYS is not set
> CONFIG_ENCRYPTED_KEYS=m
> # CONFIG_KEYS_DEBUG_PROC_KEYS is not set
> # CONFIG_SECURITY_DMESG_RESTRICT is not set
> # CONFIG_SECURITY is not set
> # CONFIG_SECURITYFS is not set
> CONFIG_DEFAULT_SECURITY_DAC=y
> CONFIG_DEFAULT_SECURITY=""
> CONFIG_XOR_BLOCKS=y
> CONFIG_ASYNC_CORE=m
> CONFIG_ASYNC_MEMCPY=m
> CONFIG_ASYNC_XOR=m
> CONFIG_ASYNC_PQ=m
> CONFIG_ASYNC_RAID6_RECOV=m
> CONFIG_CRYPTO=y
> 
> #
> # Crypto core or helper
> #
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_ALGAPI2=y
> CONFIG_CRYPTO_AEAD=y
> CONFIG_CRYPTO_AEAD2=y
> CONFIG_CRYPTO_BLKCIPHER=y
> CONFIG_CRYPTO_BLKCIPHER2=y
> CONFIG_CRYPTO_HASH=y
> CONFIG_CRYPTO_HASH2=y
> CONFIG_CRYPTO_RNG=y
> CONFIG_CRYPTO_RNG2=y
> CONFIG_CRYPTO_PCOMP=y
> CONFIG_CRYPTO_PCOMP2=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_MANAGER2=y
> CONFIG_CRYPTO_USER=y
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
> CONFIG_CRYPTO_GF128MUL=y
> CONFIG_CRYPTO_NULL=m
> CONFIG_CRYPTO_PCRYPT=y
> CONFIG_CRYPTO_WORKQUEUE=y
> CONFIG_CRYPTO_CRYPTD=y
> CONFIG_CRYPTO_AUTHENC=y
> # CONFIG_CRYPTO_TEST is not set
> CONFIG_CRYPTO_ABLK_HELPER=y
> CONFIG_CRYPTO_GLUE_HELPER_X86=y
> 
> #
> # Authenticated Encryption with Associated Data
> #
> CONFIG_CRYPTO_CCM=y
> # CONFIG_CRYPTO_GCM is not set
> CONFIG_CRYPTO_SEQIV=y
> 
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=m
> CONFIG_CRYPTO_CTR=y
> CONFIG_CRYPTO_CTS=y
> CONFIG_CRYPTO_ECB=y
> CONFIG_CRYPTO_LRW=y
> CONFIG_CRYPTO_PCBC=y
> CONFIG_CRYPTO_XTS=y
> 
> #
> # Hash modes
> #
> # CONFIG_CRYPTO_CMAC is not set
> CONFIG_CRYPTO_HMAC=m
> CONFIG_CRYPTO_XCBC=y
> # CONFIG_CRYPTO_VMAC is not set
> 
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=y
> CONFIG_CRYPTO_CRC32C_INTEL=m
> # CONFIG_CRYPTO_CRC32 is not set
> CONFIG_CRYPTO_CRC32_PCLMUL=m
> CONFIG_CRYPTO_CRCT10DIF=y
> CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
> CONFIG_CRYPTO_GHASH=m
> CONFIG_CRYPTO_MD4=m
> CONFIG_CRYPTO_MD5=m
> CONFIG_CRYPTO_MICHAEL_MIC=m
> CONFIG_CRYPTO_RMD128=m
> CONFIG_CRYPTO_RMD160=m
> # CONFIG_CRYPTO_RMD256 is not set
> CONFIG_CRYPTO_RMD320=m
> CONFIG_CRYPTO_SHA1=y
> CONFIG_CRYPTO_SHA1_SSSE3=y
> CONFIG_CRYPTO_SHA256_SSSE3=y
> # CONFIG_CRYPTO_SHA512_SSSE3 is not set
> CONFIG_CRYPTO_SHA256=y
> CONFIG_CRYPTO_SHA512=y
> # CONFIG_CRYPTO_TGR192 is not set
> CONFIG_CRYPTO_WP512=y
> # CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set
> 
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> CONFIG_CRYPTO_AES_X86_64=y
> CONFIG_CRYPTO_AES_NI_INTEL=m
> # CONFIG_CRYPTO_ANUBIS is not set
> CONFIG_CRYPTO_ARC4=y
> CONFIG_CRYPTO_BLOWFISH=y
> CONFIG_CRYPTO_BLOWFISH_COMMON=y
> # CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
> CONFIG_CRYPTO_CAMELLIA=m
> CONFIG_CRYPTO_CAMELLIA_X86_64=y
> CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
> CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
> CONFIG_CRYPTO_CAST_COMMON=y
> CONFIG_CRYPTO_CAST5=y
> CONFIG_CRYPTO_CAST5_AVX_X86_64=y
> CONFIG_CRYPTO_CAST6=y
> CONFIG_CRYPTO_CAST6_AVX_X86_64=y
> CONFIG_CRYPTO_DES=y
> # CONFIG_CRYPTO_FCRYPT is not set
> CONFIG_CRYPTO_KHAZAD=y
> CONFIG_CRYPTO_SALSA20=m
> CONFIG_CRYPTO_SALSA20_X86_64=m
> CONFIG_CRYPTO_SEED=m
> CONFIG_CRYPTO_SERPENT=y
> # CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
> # CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
> # CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
> CONFIG_CRYPTO_TEA=y
> # CONFIG_CRYPTO_TWOFISH is not set
> CONFIG_CRYPTO_TWOFISH_COMMON=m
> CONFIG_CRYPTO_TWOFISH_X86_64=m
> CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
> # CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set
> 
> #
> # Compression
> #
> CONFIG_CRYPTO_DEFLATE=y
> CONFIG_CRYPTO_ZLIB=y
> CONFIG_CRYPTO_LZO=y
> # CONFIG_CRYPTO_LZ4 is not set
> CONFIG_CRYPTO_LZ4HC=y
> 
> #
> # Random Number Generation
> #
> CONFIG_CRYPTO_ANSI_CPRNG=m
> CONFIG_CRYPTO_USER_API=y
> CONFIG_CRYPTO_USER_API_HASH=y
> CONFIG_CRYPTO_USER_API_SKCIPHER=y
> CONFIG_CRYPTO_HASH_INFO=y
> # CONFIG_CRYPTO_HW is not set
> CONFIG_ASYMMETRIC_KEY_TYPE=y
> CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
> CONFIG_PUBLIC_KEY_ALGO_RSA=y
> CONFIG_X509_CERTIFICATE_PARSER=y
> CONFIG_HAVE_KVM=y
> # CONFIG_VIRTUALIZATION is not set
> # CONFIG_BINARY_PRINTF is not set
> 
> #
> # Library routines
> #
> CONFIG_RAID6_PQ=y
> CONFIG_BITREVERSE=y
> CONFIG_GENERIC_STRNCPY_FROM_USER=y
> CONFIG_GENERIC_STRNLEN_USER=y
> CONFIG_GENERIC_NET_UTILS=y
> CONFIG_GENERIC_FIND_FIRST_BIT=y
> CONFIG_GENERIC_PCI_IOMAP=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_IO=y
> CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
> CONFIG_CRC_CCITT=y
> CONFIG_CRC16=y
> CONFIG_CRC_T10DIF=y
> CONFIG_CRC_ITU_T=y
> CONFIG_CRC32=y
> # CONFIG_CRC32_SELFTEST is not set
> # CONFIG_CRC32_SLICEBY8 is not set
> CONFIG_CRC32_SLICEBY4=y
> # CONFIG_CRC32_SARWATE is not set
> # CONFIG_CRC32_BIT is not set
> CONFIG_CRC7=y
> CONFIG_LIBCRC32C=y
> CONFIG_CRC8=m
> # CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
> CONFIG_RANDOM32_SELFTEST=y
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_LZO_COMPRESS=y
> CONFIG_LZO_DECOMPRESS=y
> CONFIG_LZ4HC_COMPRESS=y
> CONFIG_LZ4_DECOMPRESS=y
> CONFIG_XZ_DEC=y
> CONFIG_XZ_DEC_X86=y
> CONFIG_XZ_DEC_POWERPC=y
> CONFIG_XZ_DEC_IA64=y
> CONFIG_XZ_DEC_ARM=y
> CONFIG_XZ_DEC_ARMTHUMB=y
> CONFIG_XZ_DEC_SPARC=y
> CONFIG_XZ_DEC_BCJ=y
> CONFIG_XZ_DEC_TEST=m
> CONFIG_DECOMPRESS_GZIP=y
> CONFIG_DECOMPRESS_BZIP2=y
> CONFIG_DECOMPRESS_LZMA=y
> CONFIG_DECOMPRESS_XZ=y
> CONFIG_DECOMPRESS_LZO=y
> CONFIG_DECOMPRESS_LZ4=y
> CONFIG_GENERIC_ALLOCATOR=y
> CONFIG_REED_SOLOMON=m
> CONFIG_REED_SOLOMON_DEC16=y
> CONFIG_BCH=m
> CONFIG_BCH_CONST_PARAMS=y
> CONFIG_BTREE=y
> CONFIG_INTERVAL_TREE=y
> CONFIG_ASSOCIATIVE_ARRAY=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT_MAP=y
> CONFIG_HAS_DMA=y
> CONFIG_CHECK_SIGNATURE=y
> CONFIG_CPU_RMAP=y
> CONFIG_DQL=y
> CONFIG_NLATTR=y
> CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
> # CONFIG_AVERAGE is not set
> CONFIG_CLZ_TAB=y
> CONFIG_CORDIC=m
> CONFIG_DDR=y
> CONFIG_MPILIB=y
> CONFIG_OID_REGISTRY=y
> CONFIG_FONT_SUPPORT=y
> CONFIG_FONTS=y
> # CONFIG_FONT_8x8 is not set
> CONFIG_FONT_8x16=y
> CONFIG_FONT_6x11=y
> CONFIG_FONT_7x14=y
> CONFIG_FONT_PEARL_8x8=y
> # CONFIG_FONT_ACORN_8x8 is not set
> # CONFIG_FONT_MINI_4x6 is not set
> # CONFIG_FONT_SUN8x16 is not set
> # CONFIG_FONT_SUN12x22 is not set
> CONFIG_FONT_10x18=y

> _______________________________________________
> LKP mailing list
> LKP@linux.intel.com

