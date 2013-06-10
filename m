Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab3FJOwG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 10:52:06 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:46387 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab3FJOv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 10:51:59 -0400
Date: Mon, 10 Jun 2013 07:51:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: WARNING: at kernel/rcutorture.c:1243 rcu_torture_printk
Message-ID: <20130610145110.GL5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130610074728.GA20886@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130610074728.GA20886@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061014-2876-0000-0000-000009AF185E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 03:47:28PM +0800, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 
> commit 911af505ef407c2511106c224dd640f882f0f590
> Author: Paul E. McKenney <paul.mckenney@linaro.org>
> Date:   Mon Feb 11 10:23:27 2013 -0800
> 
>     rcu: Provide compile-time control for no-CBs CPUs
>     
>     Currently, the only way to specify no-CBs CPUs is via the rcu_nocbs
>     kernel command-line parameter.  This is inconvenient in some cases,
>     particularly for randconfig testing, so this commit adds a new set of
>     kernel configuration parameters.  CONFIG_RCU_NOCB_CPU_NONE (the default)
>     retains the old behavior, CONFIG_RCU_NOCB_CPU_ZERO offloads callback
>     processing from CPU 0 (along with any other CPUs specified by the
>     rcu_nocbs boot-time parameter), and CONFIG_RCU_NOCB_CPU_ALL offloads
>     callback processing from all CPUs.
>     
>     Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
>     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> However I guess it's a wrong bisect, the commit should be unmasking an
> old bug because it merely provides more kconfig options.
> 
> This warning happened only once in 74 boots of the kernel.
> 
> I also attached the 2nd dmesg which shows boot hang for the same
> kernel.
> 
> Note that there are also 2 kernel hangs in the 74 boots.  It should
> not be an RCU problem, however for completeness, I also attach a dmesg
> for your reference when considering this RCU warning.

Either way, that is a nasty warning!  You get this on recent kernels as
well, I take it?

							Thanx, Paul

> [   33.965802] [sched_delayed] sched: RT throttling activated
> [   72.137331] ------------[ cut here ]------------
> [   72.138849] WARNING: at /c/kernel-tests/src/tip/kernel/rcutorture.c:1243 rcu_torture_printk.constprop.12+0x33e/0x4ee()
> [   72.154837] CPU: 0 PID: 45 Comm: rcu_torture_sta Not tainted 3.10.0-rc3-03071-gf43e7a3 #16
> [   72.174776] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [   72.176561]  ffffffff81b1fd19 ffff880006c41cb8 ffffffff81682d33 ffff880006c41cf8
> [   72.183113]  ffffffff810c786e ffff880006c41d18 0000000000000000 00000000000000ca
> [   72.199701]  0000000000000001 ffffffff8114cebe 0000000000000000 ffff880006c41d08
> [   72.216691] Call Trace:
> [   72.220868]  [<ffffffff81682d33>] dump_stack+0x27/0x30
> [   72.229095]  [<ffffffff810c786e>] warn_slowpath_common+0x80/0xb0
> [   72.245097]  [<ffffffff8114cebe>] ? rcu_torture_shutdown+0x15c/0x15c
> [   72.247116]  [<ffffffff810c79a0>] warn_slowpath_null+0x23/0x2c
> [   72.257065]  [<ffffffff8114c29f>] rcu_torture_printk.constprop.12+0x33e/0x4ee
> [   72.267641]  [<ffffffff8114c45f>] rcu_torture_stats_print+0x10/0x35
> [   72.276533]  [<ffffffff8114cf13>] rcu_torture_stats+0x55/0xb8
> [   72.288540]  [<ffffffff810ede18>] kthread+0x113/0x122
> [   72.290221]  [<ffffffff8168b9d8>] ? __schedule+0xe4/0xaf8
> [   72.319276]  [<ffffffff810edd05>] ? __kthread_parkme+0x91/0x91
> [   72.321293]  [<ffffffff8168fbfc>] ret_from_fork+0x7c/0xb0
> [   72.333161]  [<ffffffff810edd05>] ? __kthread_parkme+0x91/0x91
> [   72.356133] ---[ end trace 078d362d19f1dfc1 ]---
> 
> git bisect start f43e7a34255a387930bc2bb826ec17c052ce975e f8c6512a0cdee9098c807b3ca4480f372de95583 --
> git bisect  bad 251df49db3327c64bf917bfdba94491fde2b4ee0  #   140  2013-06-07 11:24:55  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input
> git bisect good 507ffe4f3840ac24890a8123c702cf1b7fe4d33c  #   476  2013-06-07 11:53:22  Merge tag 'tty-3.10-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
> git bisect  bad e486b4c4ba601410772136ba0f8337bf545dccad  #    19  2013-06-07 11:58:29  Merge branch 'x86-asm-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good 87e7d520edba936fe6d1102e9fcc7530a478c07c  #   476  2013-06-07 12:20:43  rtc: rtc-bfin: use devm_*() functions
> git bisect good 46d9be3e5eb01f71fc02653755d970247174b400  #   476  2013-06-07 12:50:45  Merge branch 'for-3.10' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq
> git bisect  bad e0972916e8fe943f342b0dd1c9d43dbf5bc261c2  #    89  2013-06-07 13:00:48  Merge branch 'perf-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect  bad 1f889ec62c3f0d8913f3c32f9aff2a1e15099346  #     6  2013-06-07 13:08:01  Merge branch 'core-rcu-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good 8d564368a9a3197f43e56dadf4a18c5738849f94  #   900  2013-06-07 13:51:27  net: rename random32 to prandom
> git bisect good e57d5cf2f894e3f2727f8cf74bed0bc81cae70c8  #   900  2013-06-07 15:28:21  devcg: remove parent_cgroup.
> git bisect  bad 910ee45db2f4837c8440e770474758493ab94bf7  #    10  2013-06-07 15:34:32  rcu: Make rcu_accelerate_cbs() note need for future grace periods
> git bisect  bad 5e44ce35a6ec1a16522fa2099dda27aefd8a584e  #    74  2013-06-07 15:47:33  rcu: Export RCU_FAST_NO_HZ parameters to sysfs
> git bisect  bad dae6e64d2bcfd4b06304ab864c7e3a4f6b5fedf4  #    11  2013-06-07 15:56:02  rcu: Introduce proper blocking to no-CBs kthreads GP waits
> git bisect  bad 911af505ef407c2511106c224dd640f882f0f590  #    65  2013-06-07 16:14:41  rcu: Provide compile-time control for no-CBs CPUs
> git bisect good 34ed62461ae4970695974afb9a60ac3df0086830  #   900  2013-06-08 04:57:34  rcu: Remove restrictions on no-CBs CPUs
> git bisect good 34ed62461ae4970695974afb9a60ac3df0086830  #  2700  2013-06-10 14:33:56  rcu: Remove restrictions on no-CBs CPUs
> git bisect  bad f43e7a34255a387930bc2bb826ec17c052ce975e  # 14:34      0  Merge branch 'for-next'
> git bisect  bad c04efed734409f5a44715b54a6ca1b54b0ccf215  # 14:41     11  Add linux-next specific files for 20130607
> 
> Thanks,
> Fengguang

> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.10.0-rc3-03071-gf43e7a3 (kbuild@cairo) (gcc version 4.7.2 (Debian 4.7.2-4) ) #16 SMP PREEMPT Fri Jun 7 08:21:55 CST 2013
> [    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-c01-0606/sound:master/.vmlinuz-f43e7a34255a387930bc2bb826ec17c052ce975e-20130607082218-7-xgwo branch=sound/master  BOOT_IMAGE=/kernel/x86_64-randconfig-c01-0606/f43e7a34255a387930bc2bb826ec17c052ce975e/vmlinuz-3.10.0-rc3-03071-gf43e7a3
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] debug: ignoring loglevel setting.
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.4 present.
> [    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
> [    0.000000] Hypervisor detected: KVM
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] No AGP bridge found
> [    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: write-back
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
> [    0.000000]   1 disabled
> [    0.000000]   2 disabled
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
> [    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
> [    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
> [    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
> [    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at [ffff8800000fdab0]
> [    0.000000]   mpc: fdac0-fdbe4
> [    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x02eab000, 0x02eabfff] PGTABLE
> [    0.000000] BRK [0x02eac000, 0x02eacfff] PGTABLE
> [    0.000000] BRK [0x02ead000, 0x02eadfff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
> [    0.000000]  [mem 0x0e600000-0x0e7fffff] page 4k
> [    0.000000] BRK [0x02eae000, 0x02eaefff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
> [    0.000000]  [mem 0x0c000000-0x0e5fffff] page 4k
> [    0.000000] BRK [0x02eaf000, 0x02eaffff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
> [    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
> [    0.000000]  [mem 0x0e800000-0x0fffdfff] page 4k
> [    0.000000] log_buf_len: 8388608
> [    0.000000] early log buf free: 127388(97%)
> [    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
> [    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
> [    0.000000] ACPI: RSDT 000000000fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> [    0.000000] ACPI: DSDT 000000000fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
> [    0.000000] ACPI: FACS 000000000fffff40 00040
> [    0.000000] ACPI: SSDT 000000000ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: APIC 000000000ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> [    0.000000] ACPI: HPET 000000000ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
> [    0.000000] ACPI: SSDT 000000000ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
> [    0.000000] No NUMA configuration found
> [    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
> [    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
> [    0.000000]   NODE_DATA [mem 0x0fffa000-0x0fffdfff]
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 0:fff9001, boot clock
> [    0.000000] Zone ranges:
> [    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
> [    0.000000]   Normal   empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x00092fff]
> [    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
> [    0.000000] On node 0 totalpages: 65424
> [    0.000000]   DMA32 zone: 1024 pages used for memmap
> [    0.000000]   DMA32 zone: 21 pages reserved
> [    0.000000]   DMA32 zone: 65424 pages, LIFO batch:15
> [    0.000000] ACPI: PM-Timer IO Port: 0xb008
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC INT 05
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
> [    0.000000] ACPI: IRQ5 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] ACPI: IRQ10 used by override.
> [    0.000000] ACPI: IRQ11 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on KVM
> [    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 472 pages/cpu @ffff88000da00000 s1911616 r0 d21696 u2097152
> [    0.000000] pcpu-alloc: s1911616 r0 d21696 u2097152 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 [0] 1 
> [    0.000000] kvm-clock: cpu 0, msr 0:fff9001, primary cpu clock
> [    0.000000] KVM setup async PF for cpu 0
> [    0.000000] kvm-stealtime: cpu 0, msr da0ce80
> [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 64379
> [    0.000000] Policy zone: DMA32
> [    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-c01-0606/sound:master/.vmlinuz-f43e7a34255a387930bc2bb826ec17c052ce975e-20130607082218-7-xgwo branch=sound/master  BOOT_IMAGE=/kernel/x86_64-randconfig-c01-0606/f43e7a34255a387930bc2bb826ec17c052ce975e/vmlinuz-3.10.0-rc3-03071-gf43e7a3
> [    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Memory: 189576k/262136k available (6726k kernel code, 440k absent, 72120k reserved, 8295k data, 2804k init)
> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> [    0.000000] Preemptible hierarchical RCU implementation.
> [    0.000000] 
> [    0.000000] 
> [    0.000000] 
> [    0.000000] 
> [    0.000000] 
> [    0.000000] NR_IRQS:4352 nr_irqs:512 16
> [    0.000000] console [ttyS0] enabled
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
> [    0.000000] ... CHAINHASH_SIZE:          16384
> [    0.000000]  memory used by lock dependency info: 6367 kB
> [    0.000000]  per task-struct memory footprint: 2688 bytes
> [    0.000000] allocated 1048576 bytes of page_cgroup
> [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
> [    0.000000] ODEBUG: 15 of 15 active objects replaced
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Detected 2666.718 MHz processor
> [    0.009999] Calibrating delay loop (skipped) preset value.. 5335.66 BogoMIPS (lpj=8889060)
> [    0.010923] pid_max: default: 4096 minimum: 301
> [    0.013400] Security Framework initialized
> [    0.016666] AppArmor: AppArmor disabled by boot time parameter
> [    0.016697] Yama: becoming mindful.
> [    0.022381] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
> [    0.030275] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
> [    0.032760] Mount-cache hash table entries: 256
> [    0.034752] Initializing cgroup subsys debug
> [    0.036726] Initializing cgroup subsys memory
> [    0.040271] Initializing cgroup subsys freezer
> [    0.043649] mce: CPU supports 10 MCE banks
> [    0.046851] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.046851] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.046851] tlb_flushall_shift: 6
> [    0.050079] debug: unmapping init [mem 0xffffffff8216e000-0xffffffff82172fff]
> [    0.064840] ACPI: Core revision 20130328
> [    0.071080] ACPI: All ACPI Tables successfully acquired
> [    0.075242] Getting VERSION: 50014
> [    0.076690] Getting VERSION: 50014
> [    0.077799] Getting ID: 0
> [    0.078667] Getting ID: ff000000
> [    0.080026] Getting LVT0: 8700
> [    0.081108] Getting LVT1: 8400
> [    0.082330] enabled ExtINT on CPU#0
> [    0.090034] ENABLING IO-APIC IRQs
> [    0.091091] init IO_APIC IRQs
> [    0.092035]  apic 2 pin 0 not connected
> [    0.093375] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
> [    0.096718] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
> [    0.100046] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
> [    0.103376] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
> [    0.106710] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
> [    0.110044] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
> [    0.113373] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
> [    0.116710] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
> [    0.120042] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
> [    0.123380] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
> [    0.126717] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
> [    0.130078] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
> [    0.133392] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
> [    0.136745] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
> [    0.140078] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
> [    0.143404]  apic 2 pin 16 not connected
> [    0.146681]  apic 2 pin 17 not connected
> [    0.150023]  apic 2 pin 18 not connected
> [    0.156684]  apic 2 pin 19 not connected
> [    0.157930]  apic 2 pin 20 not connected
> [    0.160019]  apic 2 pin 21 not connected
> [    0.163356]  apic 2 pin 22 not connected
> [    0.166680]  apic 2 pin 23 not connected
> [    0.169999] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.170023] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
> [    0.184234] Using local APIC timer interrupts.
> [    0.184234] calibrating APIC timer ...
> [    0.189999] ... lapic delta = 11007614
> [    0.189999] ... PM-Timer delta = 630451
> [    0.189999] APIC calibration not consistent with PM-Timer: 176ms instead of 100ms
> [    0.189999] APIC delta adjusted to PM-Timer: 6249842 (11007614)
> [    0.189999] TSC delta adjusted to PM-Timer: 266675410 (469685432)
> [    0.189999] ..... delta 6249842
> [    0.189999] ..... mult: 268428696
> [    0.189999] ..... calibration result: 3333249
> [    0.189999] ..... CPU clock speed is 2667.0069 MHz.
> [    0.189999] ..... host bus clock speed is 1000.0249 MHz.
> [    0.190259] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
> [    0.224086] SMP alternatives: lockdep: fixing up alternatives
> [    0.225941] smpboot: Booting Node   0, Processors  #1 OK
> [    0.009999] kvm-clock: cpu 1, msr 0:fff9041, secondary cpu clock
> [    0.009999] masked ExtINT on CPU#1
> [    0.266887] Brought up 2 CPUs
> [    0.267879] smpboot: Total of 2 processors activated (10671.32 BogoMIPS)
> [    0.266808] KVM setup async PF for cpu 1
> [    0.266808] kvm-stealtime: cpu 1, msr dc0ce80
> [    0.285792] atomic64 test passed for x86-64 platform with CX8 and with SSE
> [    0.294366] regulator-dummy: no parameters
> [    0.301258] NET: Registered protocol family 16
> [    0.308234] ACPI: bus type PCI registered
> [    0.313402] PCI: Using configuration type 1 for base access
> [    0.354639] ACPI: Added _OSI(Module Device)
> [    0.356687] ACPI: Added _OSI(Processor Device)
> [    0.360015] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.363347] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.380820] ACPI: EC: Look up EC in DSDT
> [    0.411065] ACPI: Interpreter enabled
> [    0.413362] ACPI: (supports S0 S5)
> [    0.414468] ACPI: Using IOAPIC for interrupt routing
> [    0.416764] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
> [    0.454921] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    0.456810] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
> [    0.459083] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
> [    0.460007] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
> [    0.466733] acpi PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
> [    0.470011] PCI: root bus 00: using default resources
> [    0.471882] PCI host bridge to bus 0000:00
> [    0.473357] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    0.475117] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
> [    0.476674] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
> [    0.479106] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
> [    0.483724] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
> [    0.491038] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
> [    0.495436] pci 0000:00:01.1: reg 20: [io  0xc1e0-0xc1ef]
> [    0.501996] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
> [    0.511732] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
> [    0.513384] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
> [    0.517037] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
> [    0.526732] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
> [    0.530162] pci 0000:00:02.0: reg 14: [mem 0xfebe0000-0xfebe0fff]
> [    0.544024] pci 0000:00:02.0: reg 30: [mem 0xfebc0000-0xfebcffff pref]
> [    0.550034] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
> [    0.554395] pci 0000:00:03.0: reg 10: [io  0xc1c0-0xc1df]
> [    0.560009] pci 0000:00:03.0: reg 14: [mem 0xfebe1000-0xfebe1fff]
> [    0.566121] pci 0000:00:03.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
> [    0.567526] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
> [    0.570886] pci 0000:00:04.0: reg 10: [mem 0xfeb80000-0xfeb9ffff]
> [    0.577096] pci 0000:00:04.0: reg 14: [io  0xc000-0xc03f]
> [    0.589840] pci 0000:00:04.0: reg 30: [mem 0xfeba0000-0xfebbffff pref]
> [    0.593988] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
> [    0.597126] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
> [    0.600821] pci 0000:00:05.0: reg 14: [mem 0xfebe2000-0xfebe2fff]
> [    0.610126] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
> [    0.616679] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
> [    0.620420] pci 0000:00:06.0: reg 14: [mem 0xfebe3000-0xfebe3fff]
> [    0.631372] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
> [    0.634259] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
> [    0.640023] pci 0000:00:07.0: reg 14: [mem 0xfebe4000-0xfebe4fff]
> [    0.653815] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
> [    0.657623] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
> [    0.663677] pci 0000:00:08.0: reg 14: [mem 0xfebe5000-0xfebe5fff]
> [    0.678711] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
> [    0.683344] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
> [    0.690515] pci 0000:00:09.0: reg 14: [mem 0xfebe6000-0xfebe6fff]
> [    0.700149] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
> [    0.703814] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
> [    0.710014] pci 0000:00:0a.0: reg 14: [mem 0xfebe7000-0xfebe7fff]
> [    0.720547] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
> [    0.723916] pci 0000:00:0b.0: reg 10: [mem 0xfebe8000-0xfebe800f]
> [    0.733979] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
> [    0.747475] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
> [    0.750997] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
> [    0.756865] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
> [    0.763586] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
> [    0.767669] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
> [    0.774786] ACPI: Enabled 16 GPEs in block 00 to 0F
> [    0.776701] acpi root: \_SB_.PCI0 notify handler is installed
> [    0.780301] Found 1 acpi root devices
> [    0.785335] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.786708] vgaarb: loaded
> [    0.789999] vgaarb: bridge control possible 0000:00:02.0
> [    0.790139] Error: Driver '88PM80X' is already registered, aborting...
> [    0.800319] pps_core: LinuxPPS API ver. 1 registered
> [    0.803352] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    0.806716] PTP clock support registered
> [    0.810204] EDAC MC: Ver: 3.0.0
> [    0.823997] Advanced Linux Sound Architecture Driver Initialized.
> [    0.826687] PCI: Using ACPI for IRQ routing
> [    0.828041] PCI: pci_cache_line_size set to 64 bytes
> [    0.830730] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
> [    0.836685] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
> [    0.846687] NET: Registered protocol family 23
> [    0.848301] NET: Registered protocol family 8
> [    0.850015] NET: Registered protocol family 20
> [    0.853573] nfc: nfc_init: NFC Core ver 0.1
> [    0.860161] NET: Registered protocol family 39
> [    0.866952] Switching to clocksource kvm-clock
> [    0.890365] FS-Cache: Loaded
> [    0.891435] pnp: PnP ACPI init
> [    0.896840] ACPI: bus type PNP registered
> [    0.898291] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
> [    0.905322] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.911004] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
> [    0.927181] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
> [    0.929330] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
> [    0.943852] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
> [    0.956928] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
> [    0.959522] pnp 00:03: [dma 2]
> [    0.966646] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
> [    0.968966] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
> [    0.977692] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
> [    0.979976] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
> [    0.985672] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
> [    0.992446] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
> [    0.998462] pnp: PnP ACPI: found 7 devices
> [    0.999761] ACPI: bus type PNP unregistered
> [    1.015272] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
> [    1.020456] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
> [    1.024030] NET: Registered protocol family 1
> [    1.025421] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> [    1.031437] pci 0000:00:01.0: PIIX3: Enabling Passive Release
> [    1.033288] pci 0000:00:01.0: Activating ISA DMA hang workarounds
> [    1.038818] pci 0000:00:02.0: Boot video device
> [    1.042596] PCI: CLS 0 bytes, default 64
> [    1.058648] Unpacking initramfs...
> [   11.847946] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffeffff]
> [   11.855192] has_svm: not amd
> [   11.856137] kvm: no hardware support
> [   11.864680] Machine check injector initialized
> [   11.870679] microcode: CPU0 sig=0xf61, pf=0x1, revision=0x1
> [   11.875121] microcode: CPU1 sig=0xf61, pf=0x1, revision=0x1
> [   11.877713] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [   11.883940] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
> [   11.890171] blowfish-x86_64: performance on this CPU would be suboptimal: disabling blowfish-x86_64.
> [   11.907619] twofish-x86_64-3way: performance on this CPU would be suboptimal: disabling twofish-x86_64-3way.
> [   11.910679] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
> [   11.919723] cryptomgr_test (26) used greatest stack depth: 5840 bytes left
> [   11.930206] PCLMULQDQ-NI instructions are not detected.
> [   11.931857] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
> [   11.953522] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
> [   11.955547] AVX or AES-NI instructions are not detected.
> [   11.960626] AVX instructions are not detected.
> [   11.962011] AVX instructions are not detected.
> [   11.978494] AVX instructions are not detected.
> [   11.981182] AVX2 instructions are not detected.
> [   11.988648] AVX2 or AES-NI instructions are not detected.
> [   11.990342] AVX2 instructions are not detected.
> [   11.997826] AVX2 instructions are not detected.
> [   12.021972] Initializing RT-Tester: OK
> [   12.024867] audit: initializing netlink socket (disabled)
> [   12.027120] type=2000 audit(1370564504.026:1): initialized
> [   12.030313] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=60 verbose=0 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/1 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 stall_cpu=0 stall_cpu_holdoff=10 n_barrier_cbs=0 onoff_interval=0 onoff_holdoff=0
> [   12.276471] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [   12.414607] fuse init (API version 7.22)
> [   12.452783] cryptomgr_test (58) used greatest stack depth: 5632 bytes left
> [   12.530923] cryptomgr_test (59) used greatest stack depth: 4720 bytes left
> [   12.869865] tsc: Refined TSC clocksource calibration: 2666.760 MHz
> [   13.706448] alg: No test for crc32 (crc32-table)
> [   13.730344] alg: No test for stdrng (krng)
> [   13.874920] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
> [   13.903007] NET: Registered protocol family 38
> [   13.914688] Key type asymmetric registered
> [   13.924914] crc32: CRC_LE_BITS = 8, CRC_BE BITS = 8
> [   13.931641] crc32: self tests passed, processed 225944 bytes in 2884767 nsec
> [   13.945602] crc32c: CRC_LE_BITS = 8
> [   13.952077] crc32c: self tests passed, processed 225944 bytes in 361535 nsec
> [   13.969427] ipmi message handler version 39.2
> [   13.987912] IPMI System Interface driver.
> [   13.989442] ipmi_si: Adding default-specified kcs state machine
> [   13.996916] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
> [   14.015070] ipmi_si: Interface detection failed
> [   14.026497] ipmi_si: Adding default-specified smic state machine
> [   14.032547] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
> [   14.051070] ipmi_si: Interface detection failed
> [   14.077862] ipmi_si: Adding default-specified bt state machine
> [   14.087915] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
> [   14.094099] ipmi_si: Interface detection failed
> [   14.122092] ipmi_si: Unable to find any System Interface(s)
> [   14.129301] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
> [   14.149261] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [   14.166791] ACPI: Power Button [PWRF]
> [   14.374001] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> [   14.492646] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [   14.508949] lp: driver loaded but no devices found
> [   14.519299] Non-volatile memory driver v1.3
> [   14.528149] ppdev: user-space parallel port driver
> [   14.538272] telclk_interrupt = 0xf non-mcpbl0010 hw.
> [   14.539962] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
> [   14.556773] Hangcheck: Using getrawmonotonic().
> [   14.600376] mtdoops: mtd device (mtddev=name/number) must be supplied
> [   14.622999] platform physmap-flash.0: failed to claim resource 0
> [   14.625003] Could not find PAR responsible for SC520CDP Flash Bank #0
> [   14.652610] Trying default address 0x8400000
> [   14.670520] Could not find PAR responsible for SC520CDP Flash Bank #1
> [   14.672535] Trying default address 0x8c00000
> [   14.690743] Could not find PAR responsible for SC520CDP DIL Flash
> [   14.692620] Trying default address 0x9400000
> [   14.710918] SC520 CDP flash device: 0x800000 at 0x8400000
> [   14.712602] Failed to ioremap_nocache
> [   14.734948] NetSc520 flash device: 0x100000 at 0x200000
> [   14.743416] Failed to ioremap_nocache
> [   14.864979] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
> [   14.876361] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
> [   14.883554] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
> [   14.892060] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
> [   14.907379] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
> [   14.923751] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
> [   14.941274] NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba NAND 128MiB 1,8V 8-bit), 128MiB, page size: 512, OOB size: 16
> [   14.949536] flash size: 128 MiB
> [   14.959057] page size: 512 bytes
> [   14.960176] OOB area size: 16 bytes
> [   14.961288] sector size: 16 KiB
> [   14.974755] pages number: 262144
> [   14.975805] pages per sector: 32
> [   14.976872] bus width: 8
> [   14.977689] bits in sector size: 14
> [   14.989887] bits in page size: 9
> [   15.005531] bits in OOB size: 4
> [   15.009767] flash size with OOB: 135168 KiB
> [   15.015467] page address bytes: 4
> [   15.016541] sector address bytes: 3
> [   15.017721] options: 0x42
> [   15.105314] Scanning device for bad blocks
> [   15.478841] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
> [   15.488201] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
> [   15.504216] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
> [   15.535250] libphy: Fixed MDIO Bus: probed
> [   15.536802] CAN device driver interface
> [   15.546976] sja1000 CAN netdevice driver
> [   15.552217] cc770: CAN netdevice driver
> [   15.565715] PPP generic driver version 2.4.2
> [   15.576151] PPP Deflate Compression module registered
> [   15.586855] PPP MPPE Compression module registered
> [   15.591940] NET: Registered protocol family 24
> [   15.604933] ieee802154hardmac ieee802154hardmac: Added ieee802154 HardMAC hardware
> [   15.616583] ieee802154fakelb ieee802154fakelb: added ieee802154 hardware
> [   15.635001] adummy: version 1.0
> [   15.636618] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> [   15.662458] serio: i8042 KBD port at 0x60,0x64 irq 1
> [   15.681329] serio: i8042 AUX port at 0x60,0x64 irq 12
> [   15.683264] parkbd: no such parport
> [   16.462273] evbug: Connected device: input0 (Power Button at LNXPWRBN/button/input0)
> [   16.476458] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
> [   16.502823] evbug: Connected device: input1 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
> [   16.567090] i2c /dev entries driver
> [   16.588192] i2c-parport: adapter type unspecified
> [   16.589961] pps pps0: new PPS source ktimer
> [   16.630360] pps pps0: ktimer PPS source registered
> [   16.635681] pps_parport: parallel port PPS client
> [   16.637350] Driver for 1-wire Dallas network protocol.
> [   16.649484] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
> [   16.663818] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
> [   16.683811] sc520_wdt: WDT driver for SC520 initialised. timeout=30 sec (nowayout=1)
> [   16.700053] wafer5823wdt: WDT driver for Wafer 5823 single board computer initialising
> [   16.712788] wafer5823wdt: cannot register miscdev on minor=130 (err=-16)
> [   16.732432] it87_wdt: no device
> [   16.733500] sc1200wdt: build 20020303
> [   16.744991] sc1200wdt: io parameter must be specified
> [   16.758865] pc87413_wdt: Version 1.1 at io 0x2E
> [   16.760365] pc87413_wdt: cannot register miscdev on minor=130 (err=-16)
> [   16.769571] sbc60xxwdt: cannot register miscdev on minor=130 (err=-16)
> [   16.786150] cpu5wdt: misc_register failed
> [   16.787470] w83627hf_wdt: WDT driver for the Winbond(TM) W83627HF/THF/HG/DHG Super I/O chip initialising
> [   16.815025] w83627hf_wdt: Watchdog already running. Resetting timeout to 60 sec
> [   16.817472] w83627hf_wdt: cannot register miscdev on minor=130 (err=-16)
> [   16.850511] w83697hf_wdt: WDT driver for W83697HF/HG initializing
> [   16.865451] w83697hf_wdt: watchdog not found at address 0x2e
> [   16.872472] w83697hf_wdt: No W83697HF/HG could be found
> [   16.890332] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Super I/O chip initialising
> [   16.908137] w83697ug_wdt: No W83697UG/UF could be found
> [   16.922496] w83877f_wdt: cannot register miscdev on minor=130 (err=-16)
> [   16.932460] w83977f_wdt: driver v1.00
> [   16.933685] w83977f_wdt: cannot register miscdev on minor=130 (err=-16)
> [   16.952348] machzwd: MachZ ZF-Logic Watchdog driver initializing
> [   16.968223] machzwd: no ZF-Logic found
> [   16.979034] sbc_epx_c3: cannot register miscdev on minor=130 (err=-16)
> [   16.990768] Modular ISDN core version 1.1.29
> [   17.002798] NET: Registered protocol family 34
> [   17.004247] DSP module 2.0
> [   17.012918] mISDN_dsp: DSP clocks every 80 samples. This equals 3 jiffies.
> [   17.047213] mISDN: Layer-1-over-IP driver Rev. 2.00
> [   17.063608] 0 virtual devices registered
> [   17.088660] cpuidle: using governor ladder
> [   17.090082] cpuidle: using governor menu
> [   17.163260] no UART detected at 0x1
> [   17.187538] Motu MidiTimePiece on parallel port irq: 7 ioport: 0x378
> [   17.203292] NET: Registered protocol family 26
> [   17.232165] netem: version 1.3
> [   17.233383] NET: Registered protocol family 15
> [   17.250373] NET: Registered protocol family 4
> [   17.254946] NET: Registered protocol family 5
> [   17.270364] NET: Registered protocol family 9
> [   17.276374] X.25 for Linux Version 0.2
> [   17.284861] can: controller area network core (rev 20120528 abi 9)
> [   17.295389] can: failed to create /proc/net/can . CONFIG_PROC_FS missing?
> [   17.317948] NET: Registered protocol family 29
> [   17.328760] lec:lane_module_init: lec.c: initialized
> [   17.330447] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
> [   17.354614] DECnet: Routing cache hash table of 64 buckets, 5Kbytes
> [   17.363199] NET: Registered protocol family 12
> [   17.399932] NET: Registered protocol family 36
> [   17.412302] batman_adv: B.A.T.M.A.N. advanced 2013.2.0 (compatibility version 14) loaded
> [   17.433440] openvswitch: Open vSwitch switching datapath
> [   17.466612] 
> [   17.466612] printing PIC contents
> [   17.468200] ... PIC  IMR: ffff
> [   17.471501] ... PIC  IRR: 1013
> [   17.514388] ... PIC  ISR: 0000
> [   17.515477] ... PIC ELCR: 0c00
> [   17.491829] printing local APIC contents on CPU#0/0:
> [   17.491829] ... APIC ID:      00000000 (0)
> [   17.491829] ... APIC VERSION: 00050014
> [   17.491829] ... APIC TASKPRI: 00000000 (00)
> [   17.491829] ... APIC PROCPRI: 00000000
> [   17.491829] ... APIC LDR: 01000000
> [   17.491829] ... APIC DFR: ffffffff
> [   17.491829] ... APIC SPIV: 000001ff
> [   17.491829] ... APIC ISR field:
> [   17.491829] 0000000000000000000000000000000000000000000000000000000000000000
> [   17.491829] ... APIC TMR field:
> [   17.491829] 0000000000000000000000000000000000000000000000000000000000000000
> [   17.491829] ... APIC IRR field:
> [   17.491829] 0000000000000000000000000000000000000000000000000000000000008000
> [   17.491829] ... APIC ESR: 00000000
> [   17.491829] ... APIC ICR: 000008fd
> [   17.491829] ... APIC ICR2: 02000000
> [   17.491829] ... APIC LVTT: 000000ef
> [   17.491829] ... APIC LVTPC: 00010000
> [   17.491829] ... APIC LVT0: 00010700
> [   17.491829] ... APIC LVT1: 00000400
> [   17.491829] ... APIC LVTERR: 000000fe
> [   17.491829] ... APIC TMICT: 00016da2
> [   17.491829] ... APIC TMCCT: 00000000
> [   17.491829] ... APIC TDCR: 00000003
> [   17.491829] 
> [   17.731685] number of MP IRQ sources: 15.
> [   17.734255] number of IO-APIC #2 registers: 24.
> [   17.735749] testing the IO APIC.......................
> [   17.737425] IO APIC #2......
> [   17.740105] .... register #00: 00000000
> [   17.746582] .......    : physical APIC id: 00
> [   17.754466] .......    : Delivery Type: 0
> [   17.759383] .......    : LTS          : 0
> [   17.760698] .... register #01: 00170011
> [   17.771622] .......     : max redirection entries: 17
> [   17.776264] .......     : PRQ implemented: 0
> [   17.777692] .......     : IO APIC version: 11
> [   17.779063] .... register #02: 00000000
> [   17.789626] .......     : arbitration: 00
> [   17.793933] .... IRQ redirection table:
> [   17.795188] 1    0    0   0   0    0    0    00
> [   17.797142] 0    0    0   0   0    1    1    31
> [   17.802034] 0    0    0   0   0    1    1    30
> [   17.803478] 0    0    0   0   0    1    1    33
> [   17.804906] 1    0    0   0   0    1    1    34
> [   17.829684] 1    1    0   0   0    1    1    35
> [   17.833777] 0    0    0   0   0    1    1    36
> [   17.842146] 0    0    0   0   0    1    1    37
> [   17.845383] 0    0    0   0   0    1    1    38
> [   17.859823] 0    1    0   0   0    1    1    39
> [   17.861352] 1    1    0   0   0    1    1    3A
> [   17.872796] 1    1    0   0   0    1    1    3B
> [   17.874362] 0    0    0   0   0    1    1    3C
> [   17.875834] 0    0    0   0   0    1    1    3D
> [   17.877311] 0    0    0   0   0    1    1    3E
> [   17.878780] 0    0    0   0   0    1    1    3F
> [   17.880269] 1    0    0   0   0    0    0    00
> [   17.902080] 1    0    0   0   0    0    0    00
> [   17.904803] 1    0    0   0   0    0    0    00
> [   17.912976] 1    0    0   0   0    0    0    00
> [   17.914547] 1    0    0   0   0    0    0    00
> [   17.933808] 1    0    0   0   0    0    0    00
> [   17.935269] 1    0    0   0   0    0    0    00
> [   17.939967] 1    0    0   0   0    0    0    00
> [   17.941449] IRQ to pin mappings:
> [   17.942484] IRQ0 -> 0:2
> [   17.955076] IRQ1 -> 0:1
> [   17.955965] IRQ3 -> 0:3
> [   17.956939] IRQ4 -> 0:4[   17.960491] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
> [   17.960520] evbug: Connected device: input2 (ImExPS/2 Generic Explorer Mouse at isa0060/serio1/input0)
> 
> [   17.973665] IRQ5 -> 0:5
> [   17.974539] IRQ6 -> 0:6
> [   17.980140] IRQ7 -> 0:7
> [   17.983931] IRQ8 -> 0:8
> [   17.984802] IRQ9 -> 0:9
> [   17.985684] IRQ10 -> 0:10
> [   17.997159] IRQ11 -> 0:11
> [   18.002508] IRQ12 -> 0:12
> [   18.007805] IRQ13 -> 0:13
> [   18.009322] IRQ14 -> 0:14
> [   18.011976] IRQ15 -> 0:15
> [   18.015517] .................................... done.
> [   18.017944] registered taskstats version 1
> [   18.047769] Key type encrypted registered
> [   18.049469] IMA: No TPM chip found, activating TPM-bypass!
> [   18.075378] ALSA device list:
> [   18.076392]   #0: Dummy 1
> [   18.079380]   #1: Loopback 1
> [   18.080354]   #2: MTPAV on parallel port at 0x378
> [   18.103758] debug: unmapping init [mem 0xffffffff81eb1000-0xffffffff8216dfff]
> [   18.127231] Write protecting the kernel read-only data: 12288k
> [   18.155114] debug: unmapping init [mem 0xffff88000169b000-0xffff8800017fffff]
> [   18.191656] debug: unmapping init [mem 0xffff880001bab000-0xffff880001bfffff]
> /bin/sh: /proc/self/fd/9: No such file or directory
> /bin/sh: /proc/self/fd/9: No such file or directory
> /bin/sh: /proc/self/fd/9: No such file or directory
> [   33.965802] [sched_delayed] sched: RT throttling activated
> [   72.137331] ------------[ cut here ]------------
> [   72.138849] WARNING: at /c/kernel-tests/src/tip/kernel/rcutorture.c:1243 rcu_torture_printk.constprop.12+0x33e/0x4ee()
> [   72.154837] CPU: 0 PID: 45 Comm: rcu_torture_sta Not tainted 3.10.0-rc3-03071-gf43e7a3 #16
> [   72.174776] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [   72.176561]  ffffffff81b1fd19 ffff880006c41cb8 ffffffff81682d33 ffff880006c41cf8
> [   72.183113]  ffffffff810c786e ffff880006c41d18 0000000000000000 00000000000000ca
> [   72.199701]  0000000000000001 ffffffff8114cebe 0000000000000000 ffff880006c41d08
> [   72.216691] Call Trace:
> [   72.220868]  [<ffffffff81682d33>] dump_stack+0x27/0x30
> [   72.229095]  [<ffffffff810c786e>] warn_slowpath_common+0x80/0xb0
> [   72.245097]  [<ffffffff8114cebe>] ? rcu_torture_shutdown+0x15c/0x15c
> [   72.247116]  [<ffffffff810c79a0>] warn_slowpath_null+0x23/0x2c
> [   72.257065]  [<ffffffff8114c29f>] rcu_torture_printk.constprop.12+0x33e/0x4ee
> [   72.267641]  [<ffffffff8114c45f>] rcu_torture_stats_print+0x10/0x35
> [   72.276533]  [<ffffffff8114cf13>] rcu_torture_stats+0x55/0xb8
> [   72.288540]  [<ffffffff810ede18>] kthread+0x113/0x122
> [   72.290221]  [<ffffffff8168b9d8>] ? __schedule+0xe4/0xaf8
> [   72.319276]  [<ffffffff810edd05>] ? __kthread_parkme+0x91/0x91
> [   72.321293]  [<ffffffff8168fbfc>] ret_from_fork+0x7c/0xb0
> [   72.333161]  [<ffffffff810edd05>] ? __kthread_parkme+0x91/0x91
> [   72.356133] ---[ end trace 078d362d19f1dfc1 ]---
> [   72.357702] rcu-torture: rtc: ffffffff82add170 ver: 1072 tfle: 0 rta: 1072 rtaf: 0 rtf: 1071 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 1 rtb: 5 nt: 3583 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=300) barrier: 0/0:0
> [   72.357702] rcu-torture: !!! Reader Pipe:  1183231 74 0 0 0 0 0 0 0 0 0
> [   72.357702] rcu-torture: Reader Batch:  1183240 65 0 0 0 0 0 0 0 0 0
> [   72.357702] rcu-torture: Free-Block Circulation:  1079 1076 1073 1071 1071 1071 1071 1071 1071 1071 0
> [   79.199563] run-parts (117) used greatest stack depth: 4640 bytes left
> [   79.457057] rc.local (112) used greatest stack depth: 4256 bytes left
>  * Asking all remaining processes to terminate...       
> killall5[153]: mount returned non-zero exit status
> killall5[153]: /proc not mounted, failed to mount.
> 
> mount: proc has wrong device number or fs type proc not supported
> killall5[161]: mount returned non-zero exit status
> killall5[161]: /proc not mounted, failed to mount.
>  * All processes ended within 1 seconds....       
> /etc/rc6.d/S40umountfs: line 20: /proc/mounts: No such file or directory
> cat: /proc/1/maps: No such file or directory
> cat: /proc/1/maps: No such file or directory
> cat: /proc/1/maps: No such file or directory
> cat: /proc/1/maps: No such file or directory
> cat: /proc/1/maps: No such file or directory
> cat: /proc/1/maps: No such file or directory
> umount: /var/run: not mounted
> umount: /var/lock: not mounted
> umount: /dev/shm: not mounted
>  * Will now restart
> [   92.193353] Unregister pv shared memory for cpu 1
> [   92.213517] Unregister pv shared memory for cpu 0
> [   92.215284] sc520_wdt: Watchdog timer is now disabled...
> [   92.216988] rcutorture thread rcu_torture_boost parking due to system shutdown
> [   92.217887] rcutorture thread rcu_torture_boost parking due to system shutdown
> [   92.217897] rcutorture thread rcu_torture_fakewriter parking due to system shutdown
> [   92.217905] rcutorture thread rcu_torture_reader parking due to system shutdown
> [   92.217913] rcutorture thread rcu_torture_writer parking due to system shutdown
> [   92.217921] rcutorture thread rcu_torture_fakewriter parking due to system shutdown
> [   92.217929] rcutorture thread rcu_torture_fakewriter parking due to system shutdown
> [   92.217936] rcutorture thread rcu_torture_reader parking due to system shutdown
> [   92.217944] rcutorture thread rcu_torture_fakewriter parking due to system shutdown
> [   92.217952] rcutorture thread rcu_torture_reader parking due to system shutdown
> [   92.217959] rcutorture thread rcu_torture_reader parking due to system shutdown
> [   92.407141] Restarting system.
> [   92.408137] reboot: machine restart
> Elapsed time: 110


> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/x86_64 3.10.0-rc3 Kernel Configuration
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
> CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
> CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> CONFIG_ZONE_DMA32=y
> CONFIG_AUDIT_ARCH=y
> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> CONFIG_X86_64_SMP=y
> CONFIG_X86_HT=y
> CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
> CONFIG_ARCH_SUPPORTS_UPROBES=y
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
> CONFIG_LOCALVERSION=""
> CONFIG_LOCALVERSION_AUTO=y
> CONFIG_HAVE_KERNEL_GZIP=y
> CONFIG_HAVE_KERNEL_BZIP2=y
> CONFIG_HAVE_KERNEL_LZMA=y
> CONFIG_HAVE_KERNEL_XZ=y
> CONFIG_HAVE_KERNEL_LZO=y
> # CONFIG_KERNEL_GZIP is not set
> CONFIG_KERNEL_BZIP2=y
> # CONFIG_KERNEL_LZMA is not set
> # CONFIG_KERNEL_XZ is not set
> # CONFIG_KERNEL_LZO is not set
> CONFIG_DEFAULT_HOSTNAME="(none)"
> # CONFIG_SYSVIPC is not set
> # CONFIG_POSIX_MQUEUE is not set
> # CONFIG_FHANDLE is not set
> CONFIG_AUDIT=y
> CONFIG_AUDITSYSCALL=y
> CONFIG_AUDIT_WATCH=y
> CONFIG_AUDIT_TREE=y
> CONFIG_AUDIT_LOGINUID_IMMUTABLE=y
> CONFIG_HAVE_GENERIC_HARDIRQS=y
> 
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_HARDIRQS=y
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_IRQ_SHOW=y
> CONFIG_GENERIC_PENDING_IRQ=y
> CONFIG_IRQ_DOMAIN=y
> # CONFIG_IRQ_DOMAIN_DEBUG is not set
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
> CONFIG_HZ_PERIODIC=y
> # CONFIG_NO_HZ_IDLE is not set
> # CONFIG_NO_HZ_FULL is not set
> CONFIG_NO_HZ=y
> CONFIG_HIGH_RES_TIMERS=y
> 
> #
> # CPU/Task time and stats accounting
> #
> CONFIG_TICK_CPU_ACCOUNTING=y
> # CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
> # CONFIG_IRQ_TIME_ACCOUNTING is not set
> CONFIG_BSD_PROCESS_ACCT=y
> # CONFIG_BSD_PROCESS_ACCT_V3 is not set
> CONFIG_TASKSTATS=y
> CONFIG_TASK_DELAY_ACCT=y
> CONFIG_TASK_XACCT=y
> # CONFIG_TASK_IO_ACCOUNTING is not set
> 
> #
> # RCU Subsystem
> #
> CONFIG_TREE_PREEMPT_RCU=y
> CONFIG_PREEMPT_RCU=y
> CONFIG_RCU_STALL_COMMON=y
> # CONFIG_RCU_USER_QS is not set
> CONFIG_RCU_FANOUT=64
> CONFIG_RCU_FANOUT_LEAF=16
> # CONFIG_RCU_FANOUT_EXACT is not set
> # CONFIG_TREE_RCU_TRACE is not set
> CONFIG_RCU_BOOST=y
> CONFIG_RCU_BOOST_PRIO=1
> CONFIG_RCU_BOOST_DELAY=500
> CONFIG_RCU_NOCB_CPU=y
> # CONFIG_RCU_NOCB_CPU_NONE is not set
> CONFIG_RCU_NOCB_CPU_ZERO=y
> # CONFIG_RCU_NOCB_CPU_ALL is not set
> CONFIG_IKCONFIG=y
> CONFIG_LOG_BUF_SHIFT=17
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
> CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
> # CONFIG_NUMA_BALANCING is not set
> CONFIG_CGROUPS=y
> CONFIG_CGROUP_DEBUG=y
> CONFIG_CGROUP_FREEZER=y
> # CONFIG_CGROUP_DEVICE is not set
> # CONFIG_CPUSETS is not set
> # CONFIG_CGROUP_CPUACCT is not set
> CONFIG_RESOURCE_COUNTERS=y
> CONFIG_MEMCG=y
> # CONFIG_MEMCG_KMEM is not set
> # CONFIG_CGROUP_HUGETLB is not set
> # CONFIG_CGROUP_PERF is not set
> CONFIG_CGROUP_SCHED=y
> CONFIG_FAIR_GROUP_SCHED=y
> CONFIG_CFS_BANDWIDTH=y
> # CONFIG_RT_GROUP_SCHED is not set
> CONFIG_CHECKPOINT_RESTORE=y
> # CONFIG_NAMESPACES is not set
> CONFIG_UIDGID_CONVERTED=y
> CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
> CONFIG_SCHED_AUTOGROUP=y
> CONFIG_MM_OWNER=y
> # CONFIG_SYSFS_DEPRECATED is not set
> CONFIG_RELAY=y
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> CONFIG_RD_GZIP=y
> CONFIG_RD_BZIP2=y
> # CONFIG_RD_LZMA is not set
> # CONFIG_RD_XZ is not set
> # CONFIG_RD_LZO is not set
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> CONFIG_ANON_INODES=y
> CONFIG_SYSCTL_EXCEPTION_TRACE=y
> CONFIG_HOTPLUG=y
> CONFIG_HAVE_PCSPKR_PLATFORM=y
> CONFIG_EXPERT=y
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_ALL=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> # CONFIG_PCSPKR_PLATFORM is not set
> # CONFIG_BASE_FULL is not set
> CONFIG_FUTEX=y
> CONFIG_EPOLL=y
> # CONFIG_SIGNALFD is not set
> # CONFIG_TIMERFD is not set
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
> # CONFIG_VM_EVENT_COUNTERS is not set
> # CONFIG_SLUB_DEBUG is not set
> CONFIG_COMPAT_BRK=y
> # CONFIG_SLAB is not set
> CONFIG_SLUB=y
> # CONFIG_SLOB is not set
> # CONFIG_PROFILING is not set
> CONFIG_HAVE_OPROFILE=y
> CONFIG_OPROFILE_NMI_TIMER=y
> # CONFIG_JUMP_LABEL is not set
> # CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> CONFIG_ARCH_USE_BUILTIN_BSWAP=y
> CONFIG_USER_RETURN_NOTIFIER=y
> CONFIG_HAVE_IOREMAP_PROT=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> CONFIG_HAVE_OPTPROBES=y
> CONFIG_HAVE_KPROBES_ON_FTRACE=y
> CONFIG_HAVE_ARCH_TRACEHOOK=y
> CONFIG_HAVE_DMA_ATTRS=y
> CONFIG_USE_GENERIC_SMP_HELPERS=y
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
> CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
> CONFIG_SECCOMP_FILTER=y
> CONFIG_HAVE_CONTEXT_TRACKING=y
> CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
> CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
> CONFIG_MODULES_USE_ELF_RELA=y
> 
> #
> # GCOV-based kernel profiling
> #
> CONFIG_GCOV_KERNEL=y
> CONFIG_GCOV_PROFILE_ALL=y
> # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=1
> # CONFIG_MODULES is not set
> CONFIG_STOP_MACHINE=y
> # CONFIG_BLOCK is not set
> CONFIG_PREEMPT_NOTIFIERS=y
> CONFIG_PADATA=y
> CONFIG_UNINLINE_SPIN_UNLOCK=y
> CONFIG_FREEZER=y
> 
> #
> # Processor type and features
> #
> # CONFIG_ZONE_DMA is not set
> CONFIG_SMP=y
> CONFIG_X86_MPPARSE=y
> CONFIG_X86_EXTENDED_PLATFORM=y
> # CONFIG_X86_VSMP is not set
> # CONFIG_X86_INTEL_LPSS is not set
> CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
> # CONFIG_SCHED_OMIT_FRAME_POINTER is not set
> CONFIG_HYPERVISOR_GUEST=y
> CONFIG_PARAVIRT=y
> # CONFIG_PARAVIRT_DEBUG is not set
> # CONFIG_PARAVIRT_SPINLOCKS is not set
> # CONFIG_XEN is not set
> # CONFIG_XEN_PRIVILEGED_GUEST is not set
> CONFIG_KVM_GUEST=y
> # CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
> CONFIG_PARAVIRT_CLOCK=y
> CONFIG_NO_BOOTMEM=y
> # CONFIG_MEMTEST is not set
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
> # CONFIG_PROCESSOR_SELECT is not set
> CONFIG_CPU_SUP_INTEL=y
> CONFIG_CPU_SUP_AMD=y
> CONFIG_CPU_SUP_CENTAUR=y
> CONFIG_HPET_TIMER=y
> CONFIG_DMI=y
> CONFIG_GART_IOMMU=y
> # CONFIG_CALGARY_IOMMU is not set
> CONFIG_SWIOTLB=y
> CONFIG_IOMMU_HELPER=y
> # CONFIG_MAXSMP is not set
> CONFIG_NR_CPUS=8
> CONFIG_SCHED_SMT=y
> CONFIG_SCHED_MC=y
> # CONFIG_PREEMPT_NONE is not set
> # CONFIG_PREEMPT_VOLUNTARY is not set
> CONFIG_PREEMPT=y
> CONFIG_PREEMPT_COUNT=y
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
> CONFIG_X86_MCE=y
> CONFIG_X86_MCE_INTEL=y
> # CONFIG_X86_MCE_AMD is not set
> CONFIG_X86_MCE_THRESHOLD=y
> CONFIG_X86_MCE_INJECT=y
> CONFIG_X86_THERMAL_VECTOR=y
> # CONFIG_I8K is not set
> CONFIG_MICROCODE=y
> CONFIG_MICROCODE_INTEL=y
> CONFIG_MICROCODE_AMD=y
> CONFIG_MICROCODE_OLD_INTERFACE=y
> CONFIG_MICROCODE_INTEL_LIB=y
> CONFIG_MICROCODE_INTEL_EARLY=y
> CONFIG_MICROCODE_EARLY=y
> CONFIG_X86_MSR=y
> CONFIG_X86_CPUID=y
> CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
> CONFIG_ARCH_DMA_ADDR_T_64BIT=y
> CONFIG_DIRECT_GBPAGES=y
> CONFIG_NUMA=y
> CONFIG_AMD_NUMA=y
> CONFIG_X86_64_ACPI_NUMA=y
> CONFIG_NODES_SPAN_OTHER_NODES=y
> # CONFIG_NUMA_EMU is not set
> CONFIG_NODES_SHIFT=6
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_DEFAULT=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_ARCH_MEMORY_PROBE=y
> CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
> CONFIG_SELECT_MEMORY_MODEL=y
> CONFIG_SPARSEMEM_MANUAL=y
> CONFIG_SPARSEMEM=y
> CONFIG_NEED_MULTIPLE_NODES=y
> CONFIG_HAVE_MEMORY_PRESENT=y
> CONFIG_SPARSEMEM_EXTREME=y
> CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
> CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
> # CONFIG_SPARSEMEM_VMEMMAP is not set
> CONFIG_HAVE_MEMBLOCK=y
> CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
> CONFIG_ARCH_DISCARD_MEMBLOCK=y
> CONFIG_MEMORY_ISOLATION=y
> # CONFIG_MOVABLE_NODE is not set
> CONFIG_HAVE_BOOTMEM_INFO_NODE=y
> CONFIG_MEMORY_HOTPLUG=y
> CONFIG_MEMORY_HOTPLUG_SPARSE=y
> CONFIG_MEMORY_HOTREMOVE=y
> CONFIG_PAGEFLAGS_EXTENDED=y
> CONFIG_SPLIT_PTLOCK_CPUS=999999
> # CONFIG_BALLOON_COMPACTION is not set
> CONFIG_COMPACTION=y
> CONFIG_MIGRATION=y
> CONFIG_PHYS_ADDR_T_64BIT=y
> CONFIG_ZONE_DMA_FLAG=0
> CONFIG_VIRT_TO_BUS=y
> CONFIG_MMU_NOTIFIER=y
> CONFIG_KSM=y
> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
> CONFIG_MEMORY_FAILURE=y
> # CONFIG_TRANSPARENT_HUGEPAGE is not set
> # CONFIG_CROSS_MEMORY_ATTACH is not set
> CONFIG_CLEANCACHE=y
> # CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
> CONFIG_X86_RESERVE_LOW=64
> CONFIG_MTRR=y
> # CONFIG_MTRR_SANITIZER is not set
> CONFIG_X86_PAT=y
> CONFIG_ARCH_USES_PG_UNCACHED=y
> # CONFIG_ARCH_RANDOM is not set
> # CONFIG_X86_SMAP is not set
> # CONFIG_EFI is not set
> CONFIG_SECCOMP=y
> CONFIG_CC_STACKPROTECTOR=y
> # CONFIG_HZ_100 is not set
> # CONFIG_HZ_250 is not set
> CONFIG_HZ_300=y
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=300
> CONFIG_SCHED_HRTICK=y
> # CONFIG_KEXEC is not set
> # CONFIG_CRASH_DUMP is not set
> CONFIG_PHYSICAL_START=0x1000000
> CONFIG_RELOCATABLE=y
> CONFIG_PHYSICAL_ALIGN=0x1000000
> # CONFIG_HOTPLUG_CPU is not set
> # CONFIG_CMDLINE_BOOL is not set
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
> CONFIG_USE_PERCPU_NUMA_NODE_ID=y
> 
> #
> # Power management and ACPI options
> #
> # CONFIG_SUSPEND is not set
> # CONFIG_PM_RUNTIME is not set
> CONFIG_ACPI=y
> # CONFIG_ACPI_EC_DEBUGFS is not set
> CONFIG_ACPI_AC=y
> CONFIG_ACPI_BATTERY=y
> CONFIG_ACPI_BUTTON=y
> CONFIG_ACPI_FAN=y
> # CONFIG_ACPI_DOCK is not set
> CONFIG_ACPI_I2C=y
> CONFIG_ACPI_PROCESSOR=y
> # CONFIG_ACPI_IPMI is not set
> # CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
> CONFIG_ACPI_THERMAL=y
> CONFIG_ACPI_NUMA=y
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> # CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
> CONFIG_ACPI_BLACKLIST_YEAR=0
> # CONFIG_ACPI_DEBUG is not set
> # CONFIG_ACPI_PCI_SLOT is not set
> CONFIG_X86_PM_TIMER=y
> # CONFIG_ACPI_CONTAINER is not set
> # CONFIG_ACPI_HOTPLUG_MEMORY is not set
> # CONFIG_ACPI_SBS is not set
> # CONFIG_ACPI_HED is not set
> # CONFIG_ACPI_CUSTOM_METHOD is not set
> # CONFIG_ACPI_APEI is not set
> # CONFIG_SFI is not set
> 
> #
> # CPU Frequency scaling
> #
> CONFIG_CPU_FREQ=y
> CONFIG_CPU_FREQ_TABLE=y
> CONFIG_CPU_FREQ_GOV_COMMON=y
> CONFIG_CPU_FREQ_STAT=y
> CONFIG_CPU_FREQ_STAT_DETAILS=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
> CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
> # CONFIG_CPU_FREQ_GOV_PERFORMANCE is not set
> CONFIG_CPU_FREQ_GOV_POWERSAVE=y
> CONFIG_CPU_FREQ_GOV_USERSPACE=y
> CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> # CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set
> 
> #
> # x86 CPU frequency scaling drivers
> #
> CONFIG_X86_INTEL_PSTATE=y
> # CONFIG_X86_PCC_CPUFREQ is not set
> # CONFIG_X86_ACPI_CPUFREQ is not set
> # CONFIG_X86_SPEEDSTEP_CENTRINO is not set
> CONFIG_X86_P4_CLOCKMOD=y
> 
> #
> # shared options
> #
> CONFIG_X86_SPEEDSTEP_LIB=y
> CONFIG_CPU_IDLE=y
> # CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
> CONFIG_CPU_IDLE_GOV_LADDER=y
> CONFIG_CPU_IDLE_GOV_MENU=y
> # CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
> # CONFIG_INTEL_IDLE is not set
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
> # CONFIG_PCI_CNB20LE_QUIRK is not set
> # CONFIG_PCIEPORTBUS is not set
> CONFIG_ARCH_SUPPORTS_MSI=y
> # CONFIG_PCI_MSI is not set
> # CONFIG_PCI_DEBUG is not set
> # CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
> # CONFIG_PCI_STUB is not set
> CONFIG_HT_IRQ=y
> # CONFIG_PCI_IOV is not set
> # CONFIG_PCI_PRI is not set
> # CONFIG_PCI_PASID is not set
> # CONFIG_PCI_IOAPIC is not set
> CONFIG_PCI_LABEL=y
> CONFIG_ISA_DMA_API=y
> CONFIG_AMD_NB=y
> CONFIG_PCCARD=y
> # CONFIG_PCMCIA is not set
> CONFIG_CARDBUS=y
> 
> #
> # PC-card bridges
> #
> # CONFIG_YENTA is not set
> # CONFIG_HOTPLUG_PCI is not set
> # CONFIG_RAPIDIO is not set
> 
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
> CONFIG_BINFMT_SCRIPT=y
> # CONFIG_HAVE_AOUT is not set
> CONFIG_BINFMT_MISC=y
> # CONFIG_COREDUMP is not set
> # CONFIG_IA32_EMULATION is not set
> CONFIG_HAVE_TEXT_POKE_SMP=y
> CONFIG_X86_DEV_DMA_OPS=y
> CONFIG_NET=y
> 
> #
> # Networking options
> #
> # CONFIG_PACKET is not set
> CONFIG_UNIX=y
> # CONFIG_UNIX_DIAG is not set
> CONFIG_XFRM=y
> CONFIG_XFRM_ALGO=y
> CONFIG_XFRM_SUB_POLICY=y
> CONFIG_XFRM_MIGRATE=y
> CONFIG_NET_KEY=y
> CONFIG_NET_KEY_MIGRATE=y
> # CONFIG_INET is not set
> CONFIG_NETWORK_SECMARK=y
> CONFIG_NETWORK_PHY_TIMESTAMPING=y
> CONFIG_NETFILTER=y
> # CONFIG_NETFILTER_DEBUG is not set
> CONFIG_NETFILTER_ADVANCED=y
> 
> #
> # DECnet: Netfilter Configuration
> #
> # CONFIG_DECNET_NF_GRABULATOR is not set
> CONFIG_ATM=y
> CONFIG_ATM_LANE=y
> # CONFIG_BRIDGE is not set
> CONFIG_HAVE_NET_DSA=y
> CONFIG_NET_DSA=y
> CONFIG_NET_DSA_TAG_DSA=y
> CONFIG_NET_DSA_TAG_EDSA=y
> # CONFIG_VLAN_8021Q is not set
> CONFIG_DECNET=y
> CONFIG_DECNET_ROUTER=y
> CONFIG_LLC=y
> CONFIG_LLC2=y
> CONFIG_IPX=y
> CONFIG_IPX_INTERN=y
> CONFIG_ATALK=y
> CONFIG_DEV_APPLETALK=y
> # CONFIG_IPDDP is not set
> CONFIG_X25=y
> # CONFIG_LAPB is not set
> CONFIG_PHONET=y
> CONFIG_IEEE802154=y
> CONFIG_MAC802154=y
> CONFIG_NET_SCHED=y
> 
> #
> # Queueing/Scheduling
> #
> # CONFIG_NET_SCH_CBQ is not set
> CONFIG_NET_SCH_HTB=y
> CONFIG_NET_SCH_HFSC=y
> CONFIG_NET_SCH_ATM=y
> CONFIG_NET_SCH_PRIO=y
> CONFIG_NET_SCH_MULTIQ=y
> # CONFIG_NET_SCH_RED is not set
> CONFIG_NET_SCH_SFB=y
> CONFIG_NET_SCH_SFQ=y
> # CONFIG_NET_SCH_TEQL is not set
> CONFIG_NET_SCH_TBF=y
> CONFIG_NET_SCH_GRED=y
> # CONFIG_NET_SCH_DSMARK is not set
> CONFIG_NET_SCH_NETEM=y
> CONFIG_NET_SCH_DRR=y
> CONFIG_NET_SCH_MQPRIO=y
> CONFIG_NET_SCH_CHOKE=y
> # CONFIG_NET_SCH_QFQ is not set
> # CONFIG_NET_SCH_CODEL is not set
> CONFIG_NET_SCH_FQ_CODEL=y
> CONFIG_NET_SCH_PLUG=y
> 
> #
> # Classification
> #
> CONFIG_NET_CLS=y
> CONFIG_NET_CLS_BASIC=y
> CONFIG_NET_CLS_TCINDEX=y
> CONFIG_NET_CLS_FW=y
> # CONFIG_NET_CLS_U32 is not set
> CONFIG_NET_CLS_RSVP=y
> CONFIG_NET_CLS_RSVP6=y
> CONFIG_NET_CLS_FLOW=y
> # CONFIG_NET_CLS_CGROUP is not set
> CONFIG_NET_EMATCH=y
> CONFIG_NET_EMATCH_STACK=32
> CONFIG_NET_EMATCH_CMP=y
> # CONFIG_NET_EMATCH_NBYTE is not set
> CONFIG_NET_EMATCH_U32=y
> CONFIG_NET_EMATCH_META=y
> CONFIG_NET_EMATCH_TEXT=y
> CONFIG_NET_EMATCH_CANID=y
> # CONFIG_NET_CLS_ACT is not set
> CONFIG_NET_CLS_IND=y
> CONFIG_NET_SCH_FIFO=y
> # CONFIG_DCB is not set
> # CONFIG_DNS_RESOLVER is not set
> CONFIG_BATMAN_ADV=y
> CONFIG_BATMAN_ADV_NC=y
> CONFIG_BATMAN_ADV_DEBUG=y
> CONFIG_OPENVSWITCH=y
> CONFIG_VSOCKETS=y
> CONFIG_NETLINK_MMAP=y
> CONFIG_NETLINK_DIAG=y
> CONFIG_RPS=y
> CONFIG_RFS_ACCEL=y
> CONFIG_XPS=y
> # CONFIG_NETPRIO_CGROUP is not set
> CONFIG_BQL=y
> 
> #
> # Network testing
> #
> # CONFIG_HAMRADIO is not set
> CONFIG_CAN=y
> # CONFIG_CAN_RAW is not set
> # CONFIG_CAN_BCM is not set
> # CONFIG_CAN_GW is not set
> 
> #
> # CAN Device Drivers
> #
> # CONFIG_CAN_VCAN is not set
> # CONFIG_CAN_SLCAN is not set
> CONFIG_CAN_DEV=y
> CONFIG_CAN_CALC_BITTIMING=y
> # CONFIG_PCH_CAN is not set
> CONFIG_CAN_SJA1000=y
> # CONFIG_CAN_SJA1000_ISA is not set
> CONFIG_CAN_SJA1000_PLATFORM=y
> # CONFIG_CAN_EMS_PCI is not set
> # CONFIG_CAN_PEAK_PCI is not set
> # CONFIG_CAN_KVASER_PCI is not set
> # CONFIG_CAN_PLX_PCI is not set
> CONFIG_CAN_C_CAN=y
> CONFIG_CAN_C_CAN_PLATFORM=y
> # CONFIG_CAN_C_CAN_PCI is not set
> CONFIG_CAN_CC770=y
> # CONFIG_CAN_CC770_ISA is not set
> # CONFIG_CAN_CC770_PLATFORM is not set
> # CONFIG_CAN_SOFTING is not set
> # CONFIG_CAN_DEBUG_DEVICES is not set
> CONFIG_IRDA=y
> 
> #
> # IrDA protocols
> #
> # CONFIG_IRLAN is not set
> # CONFIG_IRNET is not set
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
> # CONFIG_NSC_FIR is not set
> # CONFIG_WINBOND_FIR is not set
> CONFIG_SMC_IRCC_FIR=y
> CONFIG_ALI_FIR=y
> # CONFIG_VLSI_FIR is not set
> CONFIG_VIA_FIR=y
> # CONFIG_BT is not set
> CONFIG_FIB_RULES=y
> # CONFIG_WIRELESS is not set
> CONFIG_WIMAX=y
> CONFIG_WIMAX_DEBUG_LEVEL=8
> CONFIG_RFKILL=y
> # CONFIG_RFKILL_INPUT is not set
> CONFIG_RFKILL_REGULATOR=y
> # CONFIG_NET_9P is not set
> # CONFIG_CAIF is not set
> CONFIG_NFC=y
> CONFIG_NFC_NCI=y
> CONFIG_NFC_HCI=y
> CONFIG_NFC_SHDLC=y
> 
> #
> # Near Field Communication (NFC) devices
> #
> # CONFIG_NFC_PN544 is not set
> # CONFIG_NFC_MICROREAD is not set
> CONFIG_HAVE_BPF_JIT=y
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER_PATH=""
> # CONFIG_DEVTMPFS is not set
> CONFIG_STANDALONE=y
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> CONFIG_FIRMWARE_IN_KERNEL=y
> CONFIG_EXTRA_FIRMWARE=""
> CONFIG_FW_LOADER_USER_HELPER=y
> # CONFIG_DEBUG_DRIVER is not set
> CONFIG_DEBUG_DEVRES=y
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_GENERIC_CPU_DEVICES is not set
> CONFIG_REGMAP=y
> CONFIG_REGMAP_I2C=y
> CONFIG_REGMAP_MMIO=y
> CONFIG_REGMAP_IRQ=y
> # CONFIG_DMA_SHARED_BUFFER is not set
> 
> #
> # Bus devices
> #
> # CONFIG_CONNECTOR is not set
> CONFIG_MTD=y
> # CONFIG_MTD_REDBOOT_PARTS is not set
> CONFIG_MTD_CMDLINE_PARTS=y
> CONFIG_MTD_AR7_PARTS=y
> 
> #
> # User Modules And Translation Layers
> #
> CONFIG_MTD_OOPS=y
> 
> #
> # RAM/ROM/Flash chip drivers
> #
> CONFIG_MTD_CFI=y
> CONFIG_MTD_JEDECPROBE=y
> CONFIG_MTD_GEN_PROBE=y
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
> CONFIG_MTD_CFI_INTELEXT=y
> CONFIG_MTD_CFI_AMDSTD=y
> CONFIG_MTD_CFI_STAA=y
> CONFIG_MTD_CFI_UTIL=y
> # CONFIG_MTD_RAM is not set
> CONFIG_MTD_ROM=y
> CONFIG_MTD_ABSENT=y
> 
> #
> # Mapping drivers for chip access
> #
> # CONFIG_MTD_COMPLEX_MAPPINGS is not set
> CONFIG_MTD_PHYSMAP=y
> CONFIG_MTD_PHYSMAP_COMPAT=y
> CONFIG_MTD_PHYSMAP_START=0x8000000
> CONFIG_MTD_PHYSMAP_LEN=0
> CONFIG_MTD_PHYSMAP_BANKWIDTH=2
> CONFIG_MTD_SC520CDP=y
> CONFIG_MTD_NETSC520=y
> # CONFIG_MTD_TS5500 is not set
> CONFIG_MTD_AMD76XROM=y
> CONFIG_MTD_ICHXROM=y
> # CONFIG_MTD_ESB2ROM is not set
> # CONFIG_MTD_CK804XROM is not set
> # CONFIG_MTD_SCB2_FLASH is not set
> # CONFIG_MTD_NETtel is not set
> # CONFIG_MTD_L440GX is not set
> # CONFIG_MTD_INTEL_VR_NOR is not set
> # CONFIG_MTD_PLATRAM is not set
> 
> #
> # Self-contained MTD device drivers
> #
> # CONFIG_MTD_PMC551 is not set
> # CONFIG_MTD_SLRAM is not set
> CONFIG_MTD_PHRAM=y
> CONFIG_MTD_MTDRAM=y
> CONFIG_MTDRAM_TOTAL_SIZE=4096
> CONFIG_MTDRAM_ERASE_SIZE=128
> CONFIG_MTDRAM_ABS_POS=0
> 
> #
> # Disk-On-Chip Device Drivers
> #
> CONFIG_MTD_DOCG3=y
> CONFIG_BCH_CONST_M=14
> CONFIG_BCH_CONST_T=4
> CONFIG_MTD_NAND_ECC=y
> CONFIG_MTD_NAND_ECC_SMC=y
> CONFIG_MTD_NAND=y
> CONFIG_MTD_NAND_BCH=y
> CONFIG_MTD_NAND_ECC_BCH=y
> # CONFIG_MTD_SM_COMMON is not set
> # CONFIG_MTD_NAND_DENALI is not set
> CONFIG_MTD_NAND_IDS=y
> # CONFIG_MTD_NAND_RICOH is not set
> # CONFIG_MTD_NAND_DISKONCHIP is not set
> # CONFIG_MTD_NAND_DOCG4 is not set
> # CONFIG_MTD_NAND_CAFE is not set
> CONFIG_MTD_NAND_NANDSIM=y
> # CONFIG_MTD_NAND_PLATFORM is not set
> CONFIG_MTD_ONENAND=y
> # CONFIG_MTD_ONENAND_VERIFY_WRITE is not set
> # CONFIG_MTD_ONENAND_GENERIC is not set
> # CONFIG_MTD_ONENAND_OTP is not set
> # CONFIG_MTD_ONENAND_2X_PROGRAM is not set
> 
> #
> # LPDDR flash memory drivers
> #
> CONFIG_MTD_LPDDR=y
> CONFIG_MTD_QINFO_PROBE=y
> CONFIG_MTD_UBI=y
> CONFIG_MTD_UBI_WL_THRESHOLD=4096
> CONFIG_MTD_UBI_BEB_LIMIT=20
> CONFIG_MTD_UBI_FASTMAP=y
> # CONFIG_MTD_UBI_GLUEBI is not set
> CONFIG_PARPORT=y
> # CONFIG_PARPORT_PC is not set
> # CONFIG_PARPORT_GSC is not set
> CONFIG_PARPORT_AX88796=y
> CONFIG_PARPORT_1284=y
> CONFIG_PARPORT_NOT_PC=y
> CONFIG_PNP=y
> CONFIG_PNP_DEBUG_MESSAGES=y
> 
> #
> # Protocols
> #
> CONFIG_PNPACPI=y
> 
> #
> # Misc devices
> #
> CONFIG_SENSORS_LIS3LV02D=y
> # CONFIG_AD525X_DPOT is not set
> # CONFIG_DUMMY_IRQ is not set
> # CONFIG_IBM_ASM is not set
> # CONFIG_PHANTOM is not set
> # CONFIG_INTEL_MID_PTI is not set
> # CONFIG_SGI_IOC4 is not set
> # CONFIG_TIFM_CORE is not set
> CONFIG_ICS932S401=y
> CONFIG_ATMEL_SSC=y
> CONFIG_ENCLOSURE_SERVICES=y
> # CONFIG_HP_ILO is not set
> CONFIG_APDS9802ALS=y
> # CONFIG_ISL29003 is not set
> # CONFIG_ISL29020 is not set
> # CONFIG_SENSORS_TSL2550 is not set
> CONFIG_SENSORS_BH1780=y
> CONFIG_SENSORS_BH1770=y
> # CONFIG_SENSORS_APDS990X is not set
> CONFIG_HMC6352=y
> CONFIG_DS1682=y
> CONFIG_VMWARE_BALLOON=y
> CONFIG_BMP085=y
> CONFIG_BMP085_I2C=y
> # CONFIG_PCH_PHUB is not set
> # CONFIG_USB_SWITCH_FSA9480 is not set
> CONFIG_SRAM=y
> # CONFIG_C2PORT is not set
> 
> #
> # EEPROM support
> #
> CONFIG_EEPROM_AT24=y
> CONFIG_EEPROM_LEGACY=y
> # CONFIG_EEPROM_MAX6875 is not set
> CONFIG_EEPROM_93CX6=y
> # CONFIG_CB710_CORE is not set
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
> # CONFIG_INTEL_MEI is not set
> # CONFIG_INTEL_MEI_ME is not set
> # CONFIG_VMWARE_VMCI is not set
> CONFIG_HAVE_IDE=y
> 
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=y
> # CONFIG_SCSI_DMA is not set
> # CONFIG_SCSI_NETLINK is not set
> # CONFIG_FUSION is not set
> 
> #
> # IEEE 1394 (FireWire) support
> #
> # CONFIG_FIREWIRE is not set
> # CONFIG_FIREWIRE_NOSY is not set
> # CONFIG_I2O is not set
> CONFIG_MACINTOSH_DRIVERS=y
> CONFIG_NETDEVICES=y
> CONFIG_NET_CORE=y
> CONFIG_DUMMY=y
> CONFIG_EQUALIZER=y
> CONFIG_MII=y
> CONFIG_NET_TEAM=y
> CONFIG_NET_TEAM_MODE_BROADCAST=y
> CONFIG_NET_TEAM_MODE_ROUNDROBIN=y
> CONFIG_NET_TEAM_MODE_RANDOM=y
> CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=y
> # CONFIG_NET_TEAM_MODE_LOADBALANCE is not set
> CONFIG_MACVLAN=y
> # CONFIG_MACVTAP is not set
> # CONFIG_NETCONSOLE is not set
> # CONFIG_NETPOLL is not set
> # CONFIG_NET_POLL_CONTROLLER is not set
> # CONFIG_TUN is not set
> # CONFIG_VETH is not set
> CONFIG_VIRTIO_NET=y
> # CONFIG_ARCNET is not set
> CONFIG_ATM_DRIVERS=y
> CONFIG_ATM_DUMMY=y
> # CONFIG_ATM_LANAI is not set
> # CONFIG_ATM_ENI is not set
> # CONFIG_ATM_FIRESTREAM is not set
> # CONFIG_ATM_ZATM is not set
> # CONFIG_ATM_NICSTAR is not set
> # CONFIG_ATM_IDT77252 is not set
> # CONFIG_ATM_AMBASSADOR is not set
> # CONFIG_ATM_HORIZON is not set
> # CONFIG_ATM_IA is not set
> # CONFIG_ATM_FORE200E is not set
> # CONFIG_ATM_HE is not set
> # CONFIG_ATM_SOLOS is not set
> 
> #
> # CAIF transport drivers
> #
> CONFIG_VHOST_NET=y
> CONFIG_VHOST_RING=y
> 
> #
> # Distributed Switch Architecture drivers
> #
> CONFIG_NET_DSA_MV88E6XXX=y
> # CONFIG_NET_DSA_MV88E6060 is not set
> CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
> CONFIG_NET_DSA_MV88E6131=y
> CONFIG_NET_DSA_MV88E6123_61_65=y
> CONFIG_ETHERNET=y
> CONFIG_NET_VENDOR_3COM=y
> # CONFIG_VORTEX is not set
> # CONFIG_TYPHOON is not set
> CONFIG_NET_VENDOR_ADAPTEC=y
> # CONFIG_ADAPTEC_STARFIRE is not set
> CONFIG_NET_VENDOR_ALTEON=y
> # CONFIG_ACENIC is not set
> CONFIG_NET_VENDOR_AMD=y
> # CONFIG_AMD8111_ETH is not set
> # CONFIG_PCNET32 is not set
> CONFIG_NET_VENDOR_ATHEROS=y
> # CONFIG_ATL2 is not set
> # CONFIG_ATL1 is not set
> # CONFIG_ATL1E is not set
> # CONFIG_ATL1C is not set
> CONFIG_NET_CADENCE=y
> CONFIG_ARM_AT91_ETHER=y
> CONFIG_MACB=y
> # CONFIG_NET_VENDOR_BROADCOM is not set
> CONFIG_NET_VENDOR_BROCADE=y
> # CONFIG_BNA is not set
> CONFIG_NET_CALXEDA_XGMAC=y
> CONFIG_NET_VENDOR_CHELSIO=y
> # CONFIG_CHELSIO_T1 is not set
> # CONFIG_CHELSIO_T4 is not set
> # CONFIG_CHELSIO_T4VF is not set
> CONFIG_NET_VENDOR_CISCO=y
> # CONFIG_ENIC is not set
> CONFIG_DNET=y
> CONFIG_NET_VENDOR_DEC=y
> # CONFIG_NET_TULIP is not set
> CONFIG_NET_VENDOR_DLINK=y
> # CONFIG_DL2K is not set
> # CONFIG_SUNDANCE is not set
> CONFIG_NET_VENDOR_EMULEX=y
> # CONFIG_BE2NET is not set
> CONFIG_NET_VENDOR_EXAR=y
> # CONFIG_S2IO is not set
> # CONFIG_VXGE is not set
> CONFIG_NET_VENDOR_HP=y
> # CONFIG_HP100 is not set
> # CONFIG_NET_VENDOR_INTEL is not set
> # CONFIG_IP1000 is not set
> # CONFIG_JME is not set
> CONFIG_NET_VENDOR_MARVELL=y
> # CONFIG_MVMDIO is not set
> # CONFIG_SKGE is not set
> # CONFIG_SKY2 is not set
> CONFIG_NET_VENDOR_MELLANOX=y
> # CONFIG_MLX4_EN is not set
> # CONFIG_MLX4_CORE is not set
> CONFIG_NET_VENDOR_MICREL=y
> CONFIG_KS8851_MLL=y
> # CONFIG_KSZ884X_PCI is not set
> # CONFIG_FEALNX is not set
> # CONFIG_NET_VENDOR_NATSEMI is not set
> CONFIG_NET_VENDOR_NVIDIA=y
> # CONFIG_FORCEDETH is not set
> CONFIG_NET_VENDOR_OKI=y
> # CONFIG_PCH_GBE is not set
> # CONFIG_ETHOC is not set
> CONFIG_NET_PACKET_ENGINE=y
> # CONFIG_HAMACHI is not set
> # CONFIG_YELLOWFIN is not set
> CONFIG_NET_VENDOR_QLOGIC=y
> # CONFIG_QLA3XXX is not set
> # CONFIG_QLCNIC is not set
> # CONFIG_QLGE is not set
> # CONFIG_NETXEN_NIC is not set
> # CONFIG_NET_VENDOR_REALTEK is not set
> CONFIG_NET_VENDOR_RDC=y
> # CONFIG_R6040 is not set
> CONFIG_NET_VENDOR_SEEQ=y
> CONFIG_NET_VENDOR_SILAN=y
> # CONFIG_SC92031 is not set
> CONFIG_NET_VENDOR_SIS=y
> # CONFIG_SIS900 is not set
> # CONFIG_SIS190 is not set
> # CONFIG_SFC is not set
> CONFIG_NET_VENDOR_SMSC=y
> # CONFIG_EPIC100 is not set
> # CONFIG_SMSC9420 is not set
> # CONFIG_NET_VENDOR_STMICRO is not set
> CONFIG_NET_VENDOR_SUN=y
> # CONFIG_HAPPYMEAL is not set
> # CONFIG_SUNGEM is not set
> # CONFIG_CASSINI is not set
> # CONFIG_NIU is not set
> CONFIG_NET_VENDOR_TEHUTI=y
> # CONFIG_TEHUTI is not set
> CONFIG_NET_VENDOR_TI=y
> # CONFIG_TLAN is not set
> CONFIG_NET_VENDOR_VIA=y
> # CONFIG_VIA_RHINE is not set
> # CONFIG_VIA_VELOCITY is not set
> CONFIG_NET_VENDOR_WIZNET=y
> # CONFIG_WIZNET_W5100 is not set
> CONFIG_WIZNET_W5300=y
> # CONFIG_WIZNET_BUS_DIRECT is not set
> # CONFIG_WIZNET_BUS_INDIRECT is not set
> CONFIG_WIZNET_BUS_ANY=y
> # CONFIG_FDDI is not set
> # CONFIG_NET_SB1000 is not set
> CONFIG_PHYLIB=y
> 
> #
> # MII PHY device drivers
> #
> # CONFIG_AT803X_PHY is not set
> CONFIG_AMD_PHY=y
> CONFIG_MARVELL_PHY=y
> CONFIG_DAVICOM_PHY=y
> CONFIG_QSEMI_PHY=y
> CONFIG_LXT_PHY=y
> CONFIG_CICADA_PHY=y
> CONFIG_VITESSE_PHY=y
> # CONFIG_SMSC_PHY is not set
> CONFIG_BROADCOM_PHY=y
> # CONFIG_BCM87XX_PHY is not set
> # CONFIG_ICPLUS_PHY is not set
> # CONFIG_REALTEK_PHY is not set
> CONFIG_NATIONAL_PHY=y
> # CONFIG_STE10XP is not set
> CONFIG_LSI_ET1011C_PHY=y
> # CONFIG_MICREL_PHY is not set
> CONFIG_FIXED_PHY=y
> # CONFIG_MDIO_BITBANG is not set
> CONFIG_PLIP=y
> CONFIG_PPP=y
> # CONFIG_PPP_BSDCOMP is not set
> CONFIG_PPP_DEFLATE=y
> CONFIG_PPP_FILTER=y
> CONFIG_PPP_MPPE=y
> # CONFIG_PPP_MULTILINK is not set
> CONFIG_PPPOATM=y
> CONFIG_PPPOE=y
> # CONFIG_PPP_ASYNC is not set
> # CONFIG_PPP_SYNC_TTY is not set
> # CONFIG_SLIP is not set
> CONFIG_SLHC=y
> # CONFIG_WLAN is not set
> 
> #
> # WiMAX Wireless Broadband devices
> #
> 
> #
> # Enable USB support to see WiMAX USB drivers
> #
> # CONFIG_WAN is not set
> CONFIG_IEEE802154_DRIVERS=y
> CONFIG_IEEE802154_FAKEHARD=y
> CONFIG_IEEE802154_FAKELB=y
> CONFIG_ISDN=y
> # CONFIG_ISDN_I4L is not set
> CONFIG_ISDN_CAPI=y
> # CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON is not set
> CONFIG_CAPI_TRACE=y
> # CONFIG_ISDN_CAPI_MIDDLEWARE is not set
> # CONFIG_ISDN_CAPI_CAPI20 is not set
> 
> #
> # CAPI hardware drivers
> #
> CONFIG_CAPI_AVM=y
> # CONFIG_ISDN_DRV_AVMB1_B1PCI is not set
> # CONFIG_ISDN_DRV_AVMB1_T1PCI is not set
> # CONFIG_ISDN_DRV_AVMB1_C4 is not set
> # CONFIG_CAPI_EICON is not set
> # CONFIG_ISDN_DRV_GIGASET is not set
> CONFIG_MISDN=y
> CONFIG_MISDN_DSP=y
> CONFIG_MISDN_L1OIP=y
> 
> #
> # mISDN hardware drivers
> #
> # CONFIG_MISDN_HFCPCI is not set
> # CONFIG_MISDN_HFCMULTI is not set
> # CONFIG_MISDN_AVMFRITZ is not set
> # CONFIG_MISDN_SPEEDFAX is not set
> # CONFIG_MISDN_INFINEON is not set
> # CONFIG_MISDN_W6692 is not set
> # CONFIG_MISDN_NETJET is not set
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> CONFIG_INPUT_FF_MEMLESS=y
> CONFIG_INPUT_POLLDEV=y
> CONFIG_INPUT_SPARSEKMAP=y
> CONFIG_INPUT_MATRIXKMAP=y
> 
> #
> # Userland interfaces
> #
> # CONFIG_INPUT_MOUSEDEV is not set
> # CONFIG_INPUT_JOYDEV is not set
> # CONFIG_INPUT_EVDEV is not set
> CONFIG_INPUT_EVBUG=y
> 
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> CONFIG_KEYBOARD_ADP5520=y
> # CONFIG_KEYBOARD_ADP5588 is not set
> # CONFIG_KEYBOARD_ADP5589 is not set
> CONFIG_KEYBOARD_ATKBD=y
> # CONFIG_KEYBOARD_QT1070 is not set
> # CONFIG_KEYBOARD_QT2160 is not set
> # CONFIG_KEYBOARD_LKKBD is not set
> CONFIG_KEYBOARD_GPIO=y
> CONFIG_KEYBOARD_GPIO_POLLED=y
> CONFIG_KEYBOARD_TCA6416=y
> CONFIG_KEYBOARD_TCA8418=y
> # CONFIG_KEYBOARD_MATRIX is not set
> CONFIG_KEYBOARD_LM8333=y
> CONFIG_KEYBOARD_MAX7359=y
> CONFIG_KEYBOARD_MCS=y
> # CONFIG_KEYBOARD_MPR121 is not set
> CONFIG_KEYBOARD_NEWTON=y
> CONFIG_KEYBOARD_OPENCORES=y
> # CONFIG_KEYBOARD_STOWAWAY is not set
> CONFIG_KEYBOARD_SUNKBD=y
> # CONFIG_KEYBOARD_STMPE is not set
> # CONFIG_KEYBOARD_TWL4030 is not set
> CONFIG_KEYBOARD_XTKBD=y
> CONFIG_INPUT_MOUSE=y
> CONFIG_MOUSE_PS2=y
> CONFIG_MOUSE_PS2_ALPS=y
> CONFIG_MOUSE_PS2_LOGIPS2PP=y
> # CONFIG_MOUSE_PS2_SYNAPTICS is not set
> CONFIG_MOUSE_PS2_CYPRESS=y
> # CONFIG_MOUSE_PS2_LIFEBOOK is not set
> # CONFIG_MOUSE_PS2_TRACKPOINT is not set
> CONFIG_MOUSE_PS2_ELANTECH=y
> CONFIG_MOUSE_PS2_SENTELIC=y
> # CONFIG_MOUSE_PS2_TOUCHKIT is not set
> CONFIG_MOUSE_SERIAL=y
> # CONFIG_MOUSE_APPLETOUCH is not set
> # CONFIG_MOUSE_BCM5974 is not set
> CONFIG_MOUSE_CYAPA=y
> CONFIG_MOUSE_VSXXXAA=y
> CONFIG_MOUSE_GPIO=y
> CONFIG_MOUSE_SYNAPTICS_I2C=y
> # CONFIG_MOUSE_SYNAPTICS_USB is not set
> CONFIG_INPUT_JOYSTICK=y
> # CONFIG_JOYSTICK_ANALOG is not set
> # CONFIG_JOYSTICK_A3D is not set
> CONFIG_JOYSTICK_ADI=y
> CONFIG_JOYSTICK_COBRA=y
> CONFIG_JOYSTICK_GF2K=y
> CONFIG_JOYSTICK_GRIP=y
> CONFIG_JOYSTICK_GRIP_MP=y
> CONFIG_JOYSTICK_GUILLEMOT=y
> # CONFIG_JOYSTICK_INTERACT is not set
> CONFIG_JOYSTICK_SIDEWINDER=y
> # CONFIG_JOYSTICK_TMDC is not set
> CONFIG_JOYSTICK_IFORCE=y
> CONFIG_JOYSTICK_IFORCE_232=y
> CONFIG_JOYSTICK_WARRIOR=y
> CONFIG_JOYSTICK_MAGELLAN=y
> CONFIG_JOYSTICK_SPACEORB=y
> # CONFIG_JOYSTICK_SPACEBALL is not set
> CONFIG_JOYSTICK_STINGER=y
> CONFIG_JOYSTICK_TWIDJOY=y
> CONFIG_JOYSTICK_ZHENHUA=y
> CONFIG_JOYSTICK_DB9=y
> CONFIG_JOYSTICK_GAMECON=y
> CONFIG_JOYSTICK_TURBOGRAFX=y
> # CONFIG_JOYSTICK_AS5011 is not set
> # CONFIG_JOYSTICK_JOYDUMP is not set
> # CONFIG_JOYSTICK_XPAD is not set
> # CONFIG_JOYSTICK_WALKERA0701 is not set
> CONFIG_INPUT_TABLET=y
> # CONFIG_TABLET_USB_ACECAD is not set
> # CONFIG_TABLET_USB_AIPTEK is not set
> # CONFIG_TABLET_USB_HANWANG is not set
> # CONFIG_TABLET_USB_KBTAB is not set
> # CONFIG_TABLET_USB_WACOM is not set
> # CONFIG_INPUT_TOUCHSCREEN is not set
> CONFIG_INPUT_MISC=y
> CONFIG_INPUT_88PM860X_ONKEY=y
> CONFIG_INPUT_88PM80X_ONKEY=y
> CONFIG_INPUT_AD714X=y
> # CONFIG_INPUT_AD714X_I2C is not set
> CONFIG_INPUT_BMA150=y
> # CONFIG_INPUT_MAX8925_ONKEY is not set
> CONFIG_INPUT_MMA8450=y
> # CONFIG_INPUT_MPU3050 is not set
> CONFIG_INPUT_GP2A=y
> CONFIG_INPUT_GPIO_TILT_POLLED=y
> # CONFIG_INPUT_ATLAS_BTNS is not set
> # CONFIG_INPUT_ATI_REMOTE2 is not set
> # CONFIG_INPUT_KEYSPAN_REMOTE is not set
> # CONFIG_INPUT_KXTJ9 is not set
> # CONFIG_INPUT_POWERMATE is not set
> # CONFIG_INPUT_YEALINK is not set
> # CONFIG_INPUT_CM109 is not set
> CONFIG_INPUT_RETU_PWRBUTTON=y
> CONFIG_INPUT_TWL4030_PWRBUTTON=y
> # CONFIG_INPUT_TWL4030_VIBRA is not set
> CONFIG_INPUT_TWL6040_VIBRA=y
> CONFIG_INPUT_UINPUT=y
> CONFIG_INPUT_PCF8574=y
> CONFIG_INPUT_PWM_BEEPER=y
> CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
> # CONFIG_INPUT_DA9055_ONKEY is not set
> # CONFIG_INPUT_ADXL34X is not set
> # CONFIG_INPUT_CMA3000 is not set
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_SERIO_I8042=y
> CONFIG_SERIO_SERPORT=y
> CONFIG_SERIO_CT82C710=y
> CONFIG_SERIO_PARKBD=y
> # CONFIG_SERIO_PCIPS2 is not set
> CONFIG_SERIO_LIBPS2=y
> CONFIG_SERIO_RAW=y
> # CONFIG_SERIO_ALTERA_PS2 is not set
> # CONFIG_SERIO_PS2MULT is not set
> CONFIG_SERIO_ARC_PS2=y
> CONFIG_GAMEPORT=y
> CONFIG_GAMEPORT_NS558=y
> CONFIG_GAMEPORT_L4=y
> # CONFIG_GAMEPORT_EMU10K1 is not set
> # CONFIG_GAMEPORT_FM801 is not set
> 
> #
> # Character devices
> #
> CONFIG_TTY=y
> # CONFIG_VT is not set
> CONFIG_UNIX98_PTYS=y
> # CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
> CONFIG_LEGACY_PTYS=y
> CONFIG_LEGACY_PTY_COUNT=256
> # CONFIG_SERIAL_NONSTANDARD is not set
> # CONFIG_NOZOMI is not set
> # CONFIG_N_GSM is not set
> # CONFIG_TRACE_SINK is not set
> CONFIG_DEVKMEM=y
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> # CONFIG_SERIAL_8250_EXTENDED is not set
> # CONFIG_SERIAL_8250_DW is not set
> 
> #
> # Non-8250 serial port support
> #
> # CONFIG_SERIAL_MFD_HSU is not set
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> # CONFIG_SERIAL_JSM is not set
> # CONFIG_SERIAL_SCCNXP is not set
> # CONFIG_SERIAL_TIMBERDALE is not set
> # CONFIG_SERIAL_ALTERA_JTAGUART is not set
> # CONFIG_SERIAL_ALTERA_UART is not set
> # CONFIG_SERIAL_PCH_UART is not set
> # CONFIG_SERIAL_ARC is not set
> # CONFIG_SERIAL_RP2 is not set
> # CONFIG_TTY_PRINTK is not set
> CONFIG_PRINTER=y
> CONFIG_LP_CONSOLE=y
> CONFIG_PPDEV=y
> # CONFIG_VIRTIO_CONSOLE is not set
> CONFIG_IPMI_HANDLER=y
> # CONFIG_IPMI_PANIC_EVENT is not set
> # CONFIG_IPMI_DEVICE_INTERFACE is not set
> CONFIG_IPMI_SI=y
> # CONFIG_IPMI_WATCHDOG is not set
> CONFIG_IPMI_POWEROFF=y
> # CONFIG_HW_RANDOM is not set
> CONFIG_NVRAM=y
> # CONFIG_R3964 is not set
> # CONFIG_APPLICOM is not set
> # CONFIG_MWAVE is not set
> # CONFIG_HPET is not set
> CONFIG_HANGCHECK_TIMER=y
> CONFIG_TCG_TPM=y
> CONFIG_TCG_TIS=y
> CONFIG_TCG_TIS_I2C_INFINEON=y
> # CONFIG_TCG_NSC is not set
> CONFIG_TCG_ATMEL=y
> # CONFIG_TCG_INFINEON is not set
> # CONFIG_TCG_ST33_I2C is not set
> CONFIG_TELCLOCK=y
> CONFIG_DEVPORT=y
> CONFIG_I2C=y
> CONFIG_I2C_BOARDINFO=y
> # CONFIG_I2C_COMPAT is not set
> CONFIG_I2C_CHARDEV=y
> # CONFIG_I2C_MUX is not set
> CONFIG_I2C_HELPER_AUTO=y
> CONFIG_I2C_SMBUS=y
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
> # CONFIG_I2C_ALI1563 is not set
> # CONFIG_I2C_ALI15X3 is not set
> # CONFIG_I2C_AMD756 is not set
> # CONFIG_I2C_AMD8111 is not set
> # CONFIG_I2C_I801 is not set
> # CONFIG_I2C_ISCH is not set
> # CONFIG_I2C_ISMT is not set
> # CONFIG_I2C_PIIX4 is not set
> # CONFIG_I2C_NFORCE2 is not set
> # CONFIG_I2C_SIS5595 is not set
> # CONFIG_I2C_SIS630 is not set
> # CONFIG_I2C_SIS96X is not set
> # CONFIG_I2C_VIA is not set
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
> CONFIG_I2C_CBUS_GPIO=y
> # CONFIG_I2C_DESIGNWARE_PCI is not set
> # CONFIG_I2C_EG20T is not set
> # CONFIG_I2C_GPIO is not set
> # CONFIG_I2C_INTEL_MID is not set
> CONFIG_I2C_OCORES=y
> CONFIG_I2C_PCA_PLATFORM=y
> # CONFIG_I2C_PXA_PCI is not set
> # CONFIG_I2C_SIMTEC is not set
> CONFIG_I2C_XILINX=y
> 
> #
> # External I2C/SMBus adapter drivers
> #
> CONFIG_I2C_PARPORT=y
> # CONFIG_I2C_PARPORT_LIGHT is not set
> # CONFIG_I2C_TAOS_EVM is not set
> 
> #
> # Other I2C/SMBus bus drivers
> #
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> # CONFIG_SPI is not set
> 
> #
> # Qualcomm MSM SSBI bus support
> #
> CONFIG_SSBI=y
> # CONFIG_HSI is not set
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
> CONFIG_PPS_CLIENT_KTIMER=y
> # CONFIG_PPS_CLIENT_LDISC is not set
> CONFIG_PPS_CLIENT_PARPORT=y
> CONFIG_PPS_CLIENT_GPIO=y
> 
> #
> # PPS generators support
> #
> 
> #
> # PTP clock support
> #
> CONFIG_PTP_1588_CLOCK=y
> # CONFIG_DP83640_PHY is not set
> CONFIG_PTP_1588_CLOCK_PCH=y
> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> CONFIG_GPIO_DEVRES=y
> CONFIG_GPIOLIB=y
> CONFIG_GPIO_ACPI=y
> CONFIG_DEBUG_GPIO=y
> CONFIG_GPIO_SYSFS=y
> CONFIG_GPIO_GENERIC=y
> # CONFIG_GPIO_DA9055 is not set
> CONFIG_GPIO_MAX730X=y
> 
> #
> # Memory mapped GPIO drivers:
> #
> CONFIG_GPIO_GENERIC_PLATFORM=y
> CONFIG_GPIO_IT8761E=y
> # CONFIG_GPIO_TS5500 is not set
> # CONFIG_GPIO_SCH is not set
> # CONFIG_GPIO_ICH is not set
> # CONFIG_GPIO_VX855 is not set
> # CONFIG_GPIO_LYNXPOINT is not set
> 
> #
> # I2C GPIO expanders:
> #
> # CONFIG_GPIO_ARIZONA is not set
> CONFIG_GPIO_MAX7300=y
> # CONFIG_GPIO_MAX732X is not set
> CONFIG_GPIO_PCA953X=y
> CONFIG_GPIO_PCA953X_IRQ=y
> CONFIG_GPIO_PCF857X=y
> # CONFIG_GPIO_RC5T583 is not set
> # CONFIG_GPIO_SX150X is not set
> CONFIG_GPIO_STMPE=y
> CONFIG_GPIO_TPS65912=y
> CONFIG_GPIO_TWL4030=y
> CONFIG_GPIO_TWL6040=y
> CONFIG_GPIO_WM8350=y
> CONFIG_GPIO_ADP5520=y
> CONFIG_GPIO_ADP5588=y
> CONFIG_GPIO_ADP5588_IRQ=y
> 
> #
> # PCI GPIO expanders:
> #
> # CONFIG_GPIO_BT8XX is not set
> # CONFIG_GPIO_AMD8111 is not set
> # CONFIG_GPIO_LANGWELL is not set
> # CONFIG_GPIO_PCH is not set
> # CONFIG_GPIO_ML_IOH is not set
> # CONFIG_GPIO_RDC321X is not set
> 
> #
> # SPI GPIO expanders:
> #
> # CONFIG_GPIO_MCP23S08 is not set
> 
> #
> # AC97 GPIO expanders:
> #
> 
> #
> # MODULbus GPIO expanders:
> #
> CONFIG_GPIO_PALMAS=y
> 
> #
> # USB GPIO expanders:
> #
> CONFIG_W1=y
> 
> #
> # 1-wire Bus Masters
> #
> # CONFIG_W1_MASTER_MATROX is not set
> CONFIG_W1_MASTER_DS2482=y
> CONFIG_W1_MASTER_DS1WM=y
> CONFIG_W1_MASTER_GPIO=y
> 
> #
> # 1-wire Slaves
> #
> # CONFIG_W1_SLAVE_THERM is not set
> CONFIG_W1_SLAVE_SMEM=y
> CONFIG_W1_SLAVE_DS2408=y
> # CONFIG_W1_SLAVE_DS2408_READBACK is not set
> CONFIG_W1_SLAVE_DS2413=y
> # CONFIG_W1_SLAVE_DS2423 is not set
> CONFIG_W1_SLAVE_DS2431=y
> CONFIG_W1_SLAVE_DS2433=y
> # CONFIG_W1_SLAVE_DS2433_CRC is not set
> CONFIG_W1_SLAVE_DS2760=y
> # CONFIG_W1_SLAVE_DS2780 is not set
> CONFIG_W1_SLAVE_DS2781=y
> CONFIG_W1_SLAVE_DS28E04=y
> # CONFIG_W1_SLAVE_BQ27000 is not set
> CONFIG_POWER_SUPPLY=y
> # CONFIG_POWER_SUPPLY_DEBUG is not set
> # CONFIG_PDA_POWER is not set
> # CONFIG_MAX8925_POWER is not set
> # CONFIG_WM8350_POWER is not set
> # CONFIG_TEST_POWER is not set
> # CONFIG_BATTERY_88PM860X is not set
> # CONFIG_BATTERY_DS2760 is not set
> # CONFIG_BATTERY_DS2780 is not set
> # CONFIG_BATTERY_DS2781 is not set
> # CONFIG_BATTERY_DS2782 is not set
> # CONFIG_BATTERY_SBS is not set
> # CONFIG_BATTERY_BQ27x00 is not set
> # CONFIG_BATTERY_DA9030 is not set
> # CONFIG_BATTERY_MAX17040 is not set
> # CONFIG_BATTERY_MAX17042 is not set
> # CONFIG_CHARGER_MAX8903 is not set
> # CONFIG_CHARGER_TWL4030 is not set
> # CONFIG_CHARGER_LP8727 is not set
> # CONFIG_CHARGER_GPIO is not set
> # CONFIG_CHARGER_BQ2415X is not set
> # CONFIG_CHARGER_SMB347 is not set
> # CONFIG_BATTERY_GOLDFISH is not set
> # CONFIG_POWER_RESET is not set
> CONFIG_POWER_AVS=y
> # CONFIG_HWMON is not set
> CONFIG_THERMAL=y
> CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
> # CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
> # CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
> # CONFIG_THERMAL_GOV_FAIR_SHARE is not set
> CONFIG_THERMAL_GOV_STEP_WISE=y
> # CONFIG_THERMAL_GOV_USER_SPACE is not set
> # CONFIG_CPU_THERMAL is not set
> # CONFIG_THERMAL_EMULATION is not set
> # CONFIG_INTEL_POWERCLAMP is not set
> CONFIG_WATCHDOG=y
> CONFIG_WATCHDOG_CORE=y
> CONFIG_WATCHDOG_NOWAYOUT=y
> 
> #
> # Watchdog Device Drivers
> #
> # CONFIG_SOFT_WATCHDOG is not set
> CONFIG_DA9055_WATCHDOG=y
> CONFIG_WM8350_WATCHDOG=y
> CONFIG_TWL4030_WATCHDOG=y
> # CONFIG_RETU_WATCHDOG is not set
> # CONFIG_ACQUIRE_WDT is not set
> # CONFIG_ADVANTECH_WDT is not set
> # CONFIG_ALIM1535_WDT is not set
> # CONFIG_ALIM7101_WDT is not set
> CONFIG_F71808E_WDT=y
> # CONFIG_SP5100_TCO is not set
> CONFIG_SC520_WDT=y
> # CONFIG_SBC_FITPC2_WATCHDOG is not set
> # CONFIG_EUROTECH_WDT is not set
> # CONFIG_IB700_WDT is not set
> # CONFIG_IBMASR is not set
> CONFIG_WAFER_WDT=y
> # CONFIG_I6300ESB_WDT is not set
> # CONFIG_IE6XX_WDT is not set
> # CONFIG_ITCO_WDT is not set
> # CONFIG_IT8712F_WDT is not set
> CONFIG_IT87_WDT=y
> # CONFIG_HP_WATCHDOG is not set
> CONFIG_SC1200_WDT=y
> CONFIG_PC87413_WDT=y
> # CONFIG_NV_TCO is not set
> CONFIG_60XX_WDT=y
> # CONFIG_SBC8360_WDT is not set
> CONFIG_CPU5_WDT=y
> # CONFIG_SMSC_SCH311X_WDT is not set
> # CONFIG_SMSC37B787_WDT is not set
> # CONFIG_VIA_WDT is not set
> CONFIG_W83627HF_WDT=y
> CONFIG_W83697HF_WDT=y
> CONFIG_W83697UG_WDT=y
> CONFIG_W83877F_WDT=y
> CONFIG_W83977F_WDT=y
> CONFIG_MACHZ_WDT=y
> CONFIG_SBC_EPX_C3_WATCHDOG=y
> 
> #
> # PCI-based Watchdog Cards
> #
> # CONFIG_PCIPCWATCHDOG is not set
> # CONFIG_WDTPCI is not set
> CONFIG_SSB_POSSIBLE=y
> 
> #
> # Sonics Silicon Backplane
> #
> CONFIG_SSB=y
> CONFIG_SSB_SPROM=y
> CONFIG_SSB_PCIHOST_POSSIBLE=y
> CONFIG_SSB_PCIHOST=y
> # CONFIG_SSB_B43_PCI_BRIDGE is not set
> # CONFIG_SSB_SILENT is not set
> CONFIG_SSB_DEBUG=y
> CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
> # CONFIG_SSB_DRIVER_PCICORE is not set
> # CONFIG_SSB_DRIVER_GPIO is not set
> CONFIG_BCMA_POSSIBLE=y
> 
> #
> # Broadcom specific AMBA
> #
> # CONFIG_BCMA is not set
> 
> #
> # Multifunction device drivers
> #
> CONFIG_MFD_CORE=y
> # CONFIG_MFD_CS5535 is not set
> CONFIG_MFD_AS3711=y
> CONFIG_PMIC_ADP5520=y
> # CONFIG_MFD_AAT2870_CORE is not set
> # CONFIG_MFD_CROS_EC is not set
> CONFIG_PMIC_DA903X=y
> # CONFIG_MFD_DA9052_I2C is not set
> CONFIG_MFD_DA9055=y
> # CONFIG_MFD_MC13XXX_I2C is not set
> # CONFIG_HTC_PASIC3 is not set
> # CONFIG_HTC_I2CPLD is not set
> # CONFIG_LPC_ICH is not set
> # CONFIG_LPC_SCH is not set
> # CONFIG_MFD_JANZ_CMODIO is not set
> CONFIG_MFD_88PM800=y
> CONFIG_MFD_88PM805=y
> CONFIG_MFD_88PM860X=y
> CONFIG_MFD_MAX77686=y
> CONFIG_MFD_MAX77693=y
> # CONFIG_MFD_MAX8907 is not set
> CONFIG_MFD_MAX8925=y
> # CONFIG_MFD_MAX8997 is not set
> # CONFIG_MFD_MAX8998 is not set
> CONFIG_MFD_RETU=y
> # CONFIG_MFD_PCF50633 is not set
> # CONFIG_MFD_RDC321X is not set
> # CONFIG_MFD_RTSX_PCI is not set
> CONFIG_MFD_RC5T583=y
> CONFIG_MFD_SEC_CORE=y
> CONFIG_MFD_SI476X_CORE=y
> CONFIG_MFD_SM501=y
> CONFIG_MFD_SM501_GPIO=y
> # CONFIG_MFD_SMSC is not set
> CONFIG_ABX500_CORE=y
> # CONFIG_AB3100_CORE is not set
> CONFIG_MFD_STMPE=y
> 
> #
> # STMicroelectronics STMPE Interface Drivers
> #
> # CONFIG_STMPE_I2C is not set
> # CONFIG_MFD_SYSCON is not set
> CONFIG_MFD_TI_AM335X_TSCADC=y
> CONFIG_MFD_LP8788=y
> CONFIG_MFD_PALMAS=y
> CONFIG_TPS6105X=y
> # CONFIG_TPS65010 is not set
> CONFIG_TPS6507X=y
> # CONFIG_MFD_TPS65090 is not set
> CONFIG_MFD_TPS65217=y
> # CONFIG_MFD_TPS6586X is not set
> # CONFIG_MFD_TPS65910 is not set
> CONFIG_MFD_TPS65912=y
> CONFIG_MFD_TPS65912_I2C=y
> CONFIG_MFD_TPS80031=y
> CONFIG_TWL4030_CORE=y
> # CONFIG_TWL4030_MADC is not set
> CONFIG_MFD_TWL4030_AUDIO=y
> CONFIG_TWL6040_CORE=y
> # CONFIG_MFD_WL1273_CORE is not set
> CONFIG_MFD_LM3533=y
> # CONFIG_MFD_TIMBERDALE is not set
> # CONFIG_MFD_TC3589X is not set
> # CONFIG_MFD_TMIO is not set
> # CONFIG_MFD_VX855 is not set
> CONFIG_MFD_ARIZONA=y
> CONFIG_MFD_ARIZONA_I2C=y
> # CONFIG_MFD_WM5102 is not set
> # CONFIG_MFD_WM5110 is not set
> # CONFIG_MFD_WM8400 is not set
> # CONFIG_MFD_WM831X_I2C is not set
> CONFIG_MFD_WM8350=y
> CONFIG_MFD_WM8350_I2C=y
> # CONFIG_MFD_WM8994 is not set
> CONFIG_REGULATOR=y
> CONFIG_REGULATOR_DEBUG=y
> CONFIG_REGULATOR_DUMMY=y
> CONFIG_REGULATOR_FIXED_VOLTAGE=y
> CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
> CONFIG_REGULATOR_USERSPACE_CONSUMER=y
> CONFIG_REGULATOR_GPIO=y
> CONFIG_REGULATOR_AD5398=y
> CONFIG_REGULATOR_DA903X=y
> CONFIG_REGULATOR_DA9055=y
> CONFIG_REGULATOR_FAN53555=y
> CONFIG_REGULATOR_ISL6271A=y
> CONFIG_REGULATOR_88PM8607=y
> CONFIG_REGULATOR_MAX1586=y
> CONFIG_REGULATOR_MAX8649=y
> CONFIG_REGULATOR_MAX8660=y
> CONFIG_REGULATOR_MAX8925=y
> CONFIG_REGULATOR_MAX8952=y
> # CONFIG_REGULATOR_MAX8973 is not set
> CONFIG_REGULATOR_MAX77686=y
> # CONFIG_REGULATOR_LP3971 is not set
> CONFIG_REGULATOR_LP3972=y
> CONFIG_REGULATOR_LP872X=y
> CONFIG_REGULATOR_LP8755=y
> # CONFIG_REGULATOR_LP8788 is not set
> CONFIG_REGULATOR_RC5T583=y
> CONFIG_REGULATOR_S2MPS11=y
> CONFIG_REGULATOR_S5M8767=y
> CONFIG_REGULATOR_PALMAS=y
> CONFIG_REGULATOR_TPS51632=y
> CONFIG_REGULATOR_TPS6105X=y
> # CONFIG_REGULATOR_TPS62360 is not set
> CONFIG_REGULATOR_TPS65023=y
> # CONFIG_REGULATOR_TPS6507X is not set
> CONFIG_REGULATOR_TPS65217=y
> # CONFIG_REGULATOR_TPS65912 is not set
> CONFIG_REGULATOR_TPS80031=y
> # CONFIG_REGULATOR_TWL4030 is not set
> CONFIG_REGULATOR_WM8350=y
> CONFIG_REGULATOR_AS3711=y
> # CONFIG_MEDIA_SUPPORT is not set
> 
> #
> # Graphics support
> #
> # CONFIG_AGP is not set
> CONFIG_VGA_ARB=y
> CONFIG_VGA_ARB_MAX_GPUS=16
> # CONFIG_VGA_SWITCHEROO is not set
> # CONFIG_DRM is not set
> # CONFIG_VGASTATE is not set
> CONFIG_VIDEO_OUTPUT_CONTROL=y
> # CONFIG_FB is not set
> # CONFIG_EXYNOS_VIDEO is not set
> # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
> CONFIG_SOUND=y
> CONFIG_SOUND_OSS_CORE=y
> # CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
> CONFIG_SND=y
> CONFIG_SND_TIMER=y
> CONFIG_SND_PCM=y
> CONFIG_SND_RAWMIDI=y
> # CONFIG_SND_SEQUENCER is not set
> CONFIG_SND_OSSEMUL=y
> CONFIG_SND_MIXER_OSS=y
> CONFIG_SND_PCM_OSS=y
> CONFIG_SND_PCM_OSS_PLUGINS=y
> # CONFIG_SND_HRTIMER is not set
> CONFIG_SND_DYNAMIC_MINORS=y
> CONFIG_SND_MAX_CARDS=32
> # CONFIG_SND_SUPPORT_OLD_API is not set
> # CONFIG_SND_VERBOSE_PRINTK is not set
> # CONFIG_SND_DEBUG is not set
> CONFIG_SND_DMA_SGBUF=y
> # CONFIG_SND_RAWMIDI_SEQ is not set
> # CONFIG_SND_OPL3_LIB_SEQ is not set
> # CONFIG_SND_OPL4_LIB_SEQ is not set
> # CONFIG_SND_SBAWE_SEQ is not set
> # CONFIG_SND_EMU10K1_SEQ is not set
> CONFIG_SND_DRIVERS=y
> CONFIG_SND_DUMMY=y
> CONFIG_SND_ALOOP=y
> CONFIG_SND_MTPAV=y
> CONFIG_SND_MTS64=y
> CONFIG_SND_SERIAL_U16550=y
> # CONFIG_SND_MPU401 is not set
> CONFIG_SND_PORTMAN2X4=y
> CONFIG_SND_PCI=y
> # CONFIG_SND_AD1889 is not set
> # CONFIG_SND_ALS300 is not set
> # CONFIG_SND_ALS4000 is not set
> # CONFIG_SND_ALI5451 is not set
> # CONFIG_SND_ASIHPI is not set
> # CONFIG_SND_ATIIXP is not set
> # CONFIG_SND_ATIIXP_MODEM is not set
> # CONFIG_SND_AU8810 is not set
> # CONFIG_SND_AU8820 is not set
> # CONFIG_SND_AU8830 is not set
> # CONFIG_SND_AW2 is not set
> # CONFIG_SND_AZT3328 is not set
> # CONFIG_SND_BT87X is not set
> # CONFIG_SND_CA0106 is not set
> # CONFIG_SND_CMIPCI is not set
> # CONFIG_SND_OXYGEN is not set
> # CONFIG_SND_CS4281 is not set
> # CONFIG_SND_CS46XX is not set
> # CONFIG_SND_CS5530 is not set
> # CONFIG_SND_CS5535AUDIO is not set
> # CONFIG_SND_CTXFI is not set
> # CONFIG_SND_DARLA20 is not set
> # CONFIG_SND_GINA20 is not set
> # CONFIG_SND_LAYLA20 is not set
> # CONFIG_SND_DARLA24 is not set
> # CONFIG_SND_GINA24 is not set
> # CONFIG_SND_LAYLA24 is not set
> # CONFIG_SND_MONA is not set
> # CONFIG_SND_MIA is not set
> # CONFIG_SND_ECHO3G is not set
> # CONFIG_SND_INDIGO is not set
> # CONFIG_SND_INDIGOIO is not set
> # CONFIG_SND_INDIGODJ is not set
> # CONFIG_SND_INDIGOIOX is not set
> # CONFIG_SND_INDIGODJX is not set
> # CONFIG_SND_EMU10K1 is not set
> # CONFIG_SND_EMU10K1X is not set
> # CONFIG_SND_ENS1370 is not set
> # CONFIG_SND_ENS1371 is not set
> # CONFIG_SND_ES1938 is not set
> # CONFIG_SND_ES1968 is not set
> # CONFIG_SND_FM801 is not set
> # CONFIG_SND_HDA_INTEL is not set
> # CONFIG_SND_HDSP is not set
> # CONFIG_SND_HDSPM is not set
> # CONFIG_SND_ICE1712 is not set
> # CONFIG_SND_ICE1724 is not set
> # CONFIG_SND_INTEL8X0 is not set
> # CONFIG_SND_INTEL8X0M is not set
> # CONFIG_SND_KORG1212 is not set
> # CONFIG_SND_LOLA is not set
> # CONFIG_SND_LX6464ES is not set
> # CONFIG_SND_MAESTRO3 is not set
> # CONFIG_SND_MIXART is not set
> # CONFIG_SND_NM256 is not set
> # CONFIG_SND_PCXHR is not set
> # CONFIG_SND_RIPTIDE is not set
> # CONFIG_SND_RME32 is not set
> # CONFIG_SND_RME96 is not set
> # CONFIG_SND_RME9652 is not set
> # CONFIG_SND_SONICVIBES is not set
> # CONFIG_SND_TRIDENT is not set
> # CONFIG_SND_VIA82XX is not set
> # CONFIG_SND_VIA82XX_MODEM is not set
> # CONFIG_SND_VIRTUOSO is not set
> # CONFIG_SND_VX222 is not set
> # CONFIG_SND_YMFPCI is not set
> # CONFIG_SND_SOC is not set
> # CONFIG_SOUND_PRIME is not set
> 
> #
> # HID support
> #
> CONFIG_HID=y
> # CONFIG_HID_BATTERY_STRENGTH is not set
> # CONFIG_HIDRAW is not set
> # CONFIG_UHID is not set
> CONFIG_HID_GENERIC=y
> 
> #
> # Special HID drivers
> #
> CONFIG_HID_A4TECH=y
> CONFIG_HID_ACRUX=y
> CONFIG_HID_ACRUX_FF=y
> CONFIG_HID_APPLE=y
> CONFIG_HID_AUREAL=y
> # CONFIG_HID_BELKIN is not set
> # CONFIG_HID_CHERRY is not set
> CONFIG_HID_CHICONY=y
> # CONFIG_HID_PRODIKEYS is not set
> # CONFIG_HID_CYPRESS is not set
> CONFIG_HID_DRAGONRISE=y
> CONFIG_DRAGONRISE_FF=y
> CONFIG_HID_EMS_FF=y
> # CONFIG_HID_ELECOM is not set
> # CONFIG_HID_EZKEY is not set
> CONFIG_HID_KEYTOUCH=y
> CONFIG_HID_KYE=y
> CONFIG_HID_UCLOGIC=y
> CONFIG_HID_WALTOP=y
> CONFIG_HID_GYRATION=y
> CONFIG_HID_ICADE=y
> # CONFIG_HID_TWINHAN is not set
> CONFIG_HID_KENSINGTON=y
> CONFIG_HID_LCPOWER=y
> CONFIG_HID_LOGITECH=y
> # CONFIG_HID_LOGITECH_DJ is not set
> # CONFIG_LOGITECH_FF is not set
> # CONFIG_LOGIRUMBLEPAD2_FF is not set
> CONFIG_LOGIG940_FF=y
> CONFIG_LOGIWHEELS_FF=y
> # CONFIG_HID_MAGICMOUSE is not set
> CONFIG_HID_MICROSOFT=y
> # CONFIG_HID_MONTEREY is not set
> CONFIG_HID_MULTITOUCH=y
> # CONFIG_HID_ORTEK is not set
> # CONFIG_HID_PANTHERLORD is not set
> # CONFIG_HID_PETALYNX is not set
> # CONFIG_HID_PICOLCD is not set
> CONFIG_HID_PRIMAX=y
> # CONFIG_HID_PS3REMOTE is not set
> CONFIG_HID_SAITEK=y
> # CONFIG_HID_SAMSUNG is not set
> # CONFIG_HID_SPEEDLINK is not set
> CONFIG_HID_STEELSERIES=y
> CONFIG_HID_SUNPLUS=y
> CONFIG_HID_GREENASIA=y
> CONFIG_GREENASIA_FF=y
> # CONFIG_HID_SMARTJOYPLUS is not set
> CONFIG_HID_TIVO=y
> CONFIG_HID_TOPSEED=y
> # CONFIG_HID_THRUSTMASTER is not set
> CONFIG_HID_ZEROPLUS=y
> CONFIG_ZEROPLUS_FF=y
> # CONFIG_HID_ZYDACRON is not set
> # CONFIG_HID_SENSOR_HUB is not set
> 
> #
> # I2C HID support
> #
> CONFIG_I2C_HID=y
> CONFIG_USB_ARCH_HAS_OHCI=y
> CONFIG_USB_ARCH_HAS_EHCI=y
> CONFIG_USB_ARCH_HAS_XHCI=y
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_ARCH_HAS_HCD=y
> # CONFIG_USB is not set
> 
> #
> # USB port drivers
> #
> # CONFIG_USB_PHY is not set
> # CONFIG_USB_GADGET is not set
> # CONFIG_UWB is not set
> # CONFIG_MMC is not set
> CONFIG_MEMSTICK=y
> # CONFIG_MEMSTICK_DEBUG is not set
> 
> #
> # MemoryStick drivers
> #
> # CONFIG_MEMSTICK_UNSAFE_RESUME is not set
> 
> #
> # MemoryStick Host Controller Drivers
> #
> # CONFIG_MEMSTICK_TIFM_MS is not set
> # CONFIG_MEMSTICK_JMICRON_38X is not set
> # CONFIG_MEMSTICK_R592 is not set
> # CONFIG_NEW_LEDS is not set
> CONFIG_ACCESSIBILITY=y
> # CONFIG_INFINIBAND is not set
> CONFIG_EDAC=y
> CONFIG_EDAC_LEGACY_SYSFS=y
> # CONFIG_EDAC_DEBUG is not set
> CONFIG_EDAC_MM_EDAC=y
> # CONFIG_EDAC_E752X is not set
> # CONFIG_EDAC_I82975X is not set
> # CONFIG_EDAC_I3000 is not set
> # CONFIG_EDAC_I3200 is not set
> # CONFIG_EDAC_X38 is not set
> # CONFIG_EDAC_I5400 is not set
> # CONFIG_EDAC_I7CORE is not set
> # CONFIG_EDAC_I5000 is not set
> # CONFIG_EDAC_I5100 is not set
> # CONFIG_EDAC_I7300 is not set
> CONFIG_RTC_LIB=y
> # CONFIG_RTC_CLASS is not set
> # CONFIG_DMADEVICES is not set
> # CONFIG_AUXDISPLAY is not set
> CONFIG_UIO=y
> # CONFIG_UIO_CIF is not set
> CONFIG_UIO_PDRV=y
> CONFIG_UIO_PDRV_GENIRQ=y
> CONFIG_UIO_DMEM_GENIRQ=y
> # CONFIG_UIO_AEC is not set
> # CONFIG_UIO_SERCOS3 is not set
> # CONFIG_UIO_PCI_GENERIC is not set
> # CONFIG_UIO_NETX is not set
> # CONFIG_VIRT_DRIVERS is not set
> CONFIG_VIRTIO=y
> 
> #
> # Virtio drivers
> #
> # CONFIG_VIRTIO_PCI is not set
> CONFIG_VIRTIO_BALLOON=y
> CONFIG_VIRTIO_MMIO=y
> CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y
> 
> #
> # Microsoft Hyper-V guest support
> #
> # CONFIG_HYPERV is not set
> # CONFIG_STAGING is not set
> # CONFIG_X86_PLATFORM_DEVICES is not set
> 
> #
> # Hardware Spinlock drivers
> #
> CONFIG_CLKEVT_I8253=y
> CONFIG_CLKBLD_I8253=y
> CONFIG_MAILBOX=y
> # CONFIG_IOMMU_SUPPORT is not set
> 
> #
> # Remoteproc drivers
> #
> CONFIG_REMOTEPROC=y
> CONFIG_STE_MODEM_RPROC=y
> 
> #
> # Rpmsg drivers
> #
> CONFIG_PM_DEVFREQ=y
> 
> #
> # DEVFREQ Governors
> #
> CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
> # CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
> CONFIG_DEVFREQ_GOV_POWERSAVE=y
> # CONFIG_DEVFREQ_GOV_USERSPACE is not set
> 
> #
> # DEVFREQ Drivers
> #
> CONFIG_EXTCON=y
> 
> #
> # Extcon Device Drivers
> #
> CONFIG_EXTCON_GPIO=y
> CONFIG_EXTCON_MAX77693=y
> # CONFIG_MEMORY is not set
> # CONFIG_IIO is not set
> # CONFIG_NTB is not set
> # CONFIG_VME_BUS is not set
> CONFIG_PWM=y
> CONFIG_PWM_TWL=y
> CONFIG_PWM_TWL_LED=y
> CONFIG_IPACK_BUS=y
> # CONFIG_BOARD_TPCI200 is not set
> # CONFIG_SERIAL_IPOCTAL is not set
> CONFIG_RESET_CONTROLLER=y
> 
> #
> # Firmware Drivers
> #
> # CONFIG_EDD is not set
> CONFIG_FIRMWARE_MEMMAP=y
> # CONFIG_DELL_RBU is not set
> # CONFIG_DCDBAS is not set
> CONFIG_DMIID=y
> # CONFIG_DMI_SYSFS is not set
> CONFIG_ISCSI_IBFT_FIND=y
> CONFIG_GOOGLE_FIRMWARE=y
> 
> #
> # Google Firmware Drivers
> #
> # CONFIG_GOOGLE_SMI is not set
> CONFIG_GOOGLE_MEMCONSOLE=y
> 
> #
> # File systems
> #
> CONFIG_DCACHE_WORD_ACCESS=y
> # CONFIG_FS_POSIX_ACL is not set
> # CONFIG_FILE_LOCKING is not set
> CONFIG_FSNOTIFY=y
> CONFIG_DNOTIFY=y
> # CONFIG_INOTIFY_USER is not set
> CONFIG_FANOTIFY=y
> CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
> # CONFIG_QUOTA is not set
> # CONFIG_QUOTACTL is not set
> CONFIG_AUTOFS4_FS=y
> CONFIG_FUSE_FS=y
> CONFIG_CUSE=y
> 
> #
> # Caches
> #
> CONFIG_FSCACHE=y
> # CONFIG_FSCACHE_DEBUG is not set
> 
> #
> # Pseudo filesystems
> #
> # CONFIG_PROC_FS is not set
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> # CONFIG_TMPFS_POSIX_ACL is not set
> # CONFIG_TMPFS_XATTR is not set
> CONFIG_HUGETLBFS=y
> CONFIG_HUGETLB_PAGE=y
> # CONFIG_CONFIGFS_FS is not set
> # CONFIG_MISC_FILESYSTEMS is not set
> CONFIG_NETWORK_FILESYSTEMS=y
> CONFIG_NCP_FS=y
> # CONFIG_NCPFS_PACKET_SIGNING is not set
> # CONFIG_NCPFS_IOCTL_LOCKING is not set
> CONFIG_NCPFS_STRONG=y
> CONFIG_NCPFS_NFS_NS=y
> # CONFIG_NCPFS_OS2_NS is not set
> # CONFIG_NCPFS_SMALLDOS is not set
> # CONFIG_NCPFS_NLS is not set
> CONFIG_NCPFS_EXTRAS=y
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="iso8859-1"
> CONFIG_NLS_CODEPAGE_437=y
> CONFIG_NLS_CODEPAGE_737=y
> CONFIG_NLS_CODEPAGE_775=y
> CONFIG_NLS_CODEPAGE_850=y
> # CONFIG_NLS_CODEPAGE_852 is not set
> CONFIG_NLS_CODEPAGE_855=y
> # CONFIG_NLS_CODEPAGE_857 is not set
> # CONFIG_NLS_CODEPAGE_860 is not set
> CONFIG_NLS_CODEPAGE_861=y
> CONFIG_NLS_CODEPAGE_862=y
> CONFIG_NLS_CODEPAGE_863=y
> # CONFIG_NLS_CODEPAGE_864 is not set
> CONFIG_NLS_CODEPAGE_865=y
> CONFIG_NLS_CODEPAGE_866=y
> CONFIG_NLS_CODEPAGE_869=y
> CONFIG_NLS_CODEPAGE_936=y
> # CONFIG_NLS_CODEPAGE_950 is not set
> # CONFIG_NLS_CODEPAGE_932 is not set
> CONFIG_NLS_CODEPAGE_949=y
> CONFIG_NLS_CODEPAGE_874=y
> # CONFIG_NLS_ISO8859_8 is not set
> CONFIG_NLS_CODEPAGE_1250=y
> # CONFIG_NLS_CODEPAGE_1251 is not set
> CONFIG_NLS_ASCII=y
> CONFIG_NLS_ISO8859_1=y
> CONFIG_NLS_ISO8859_2=y
> # CONFIG_NLS_ISO8859_3 is not set
> CONFIG_NLS_ISO8859_4=y
> CONFIG_NLS_ISO8859_5=y
> # CONFIG_NLS_ISO8859_6 is not set
> CONFIG_NLS_ISO8859_7=y
> CONFIG_NLS_ISO8859_9=y
> # CONFIG_NLS_ISO8859_13 is not set
> # CONFIG_NLS_ISO8859_14 is not set
> CONFIG_NLS_ISO8859_15=y
> CONFIG_NLS_KOI8_R=y
> # CONFIG_NLS_KOI8_U is not set
> CONFIG_NLS_MAC_ROMAN=y
> CONFIG_NLS_MAC_CELTIC=y
> CONFIG_NLS_MAC_CENTEURO=y
> # CONFIG_NLS_MAC_CROATIAN is not set
> CONFIG_NLS_MAC_CYRILLIC=y
> CONFIG_NLS_MAC_GAELIC=y
> CONFIG_NLS_MAC_GREEK=y
> CONFIG_NLS_MAC_ICELAND=y
> # CONFIG_NLS_MAC_INUIT is not set
> CONFIG_NLS_MAC_ROMANIAN=y
> # CONFIG_NLS_MAC_TURKISH is not set
> CONFIG_NLS_UTF8=y
> 
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> CONFIG_PRINTK_TIME=y
> CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
> CONFIG_ENABLE_WARN_DEPRECATED=y
> # CONFIG_ENABLE_MUST_CHECK is not set
> CONFIG_FRAME_WARN=2048
> # CONFIG_MAGIC_SYSRQ is not set
> # CONFIG_STRIP_ASM_SYMS is not set
> # CONFIG_READABLE_ASM is not set
> # CONFIG_UNUSED_SYMBOLS is not set
> CONFIG_DEBUG_FS=y
> # CONFIG_HEADERS_CHECK is not set
> CONFIG_DEBUG_SECTION_MISMATCH=y
> CONFIG_DEBUG_KERNEL=y
> # CONFIG_DEBUG_SHIRQ is not set
> # CONFIG_LOCKUP_DETECTOR is not set
> # CONFIG_PANIC_ON_OOPS is not set
> CONFIG_PANIC_ON_OOPS_VALUE=0
> CONFIG_DETECT_HUNG_TASK=y
> CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
> CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
> CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
> CONFIG_DEBUG_OBJECTS=y
> # CONFIG_DEBUG_OBJECTS_SELFTEST is not set
> CONFIG_DEBUG_OBJECTS_FREE=y
> CONFIG_DEBUG_OBJECTS_TIMERS=y
> CONFIG_DEBUG_OBJECTS_WORK=y
> # CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
> CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
> CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
> CONFIG_SLUB_STATS=y
> CONFIG_HAVE_DEBUG_KMEMLEAK=y
> # CONFIG_DEBUG_KMEMLEAK is not set
> # CONFIG_DEBUG_PREEMPT is not set
> # CONFIG_DEBUG_RT_MUTEXES is not set
> CONFIG_RT_MUTEX_TESTER=y
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> CONFIG_DEBUG_LOCK_ALLOC=y
> CONFIG_PROVE_LOCKING=y
> CONFIG_LOCKDEP=y
> CONFIG_LOCK_STAT=y
> CONFIG_DEBUG_LOCKDEP=y
> CONFIG_TRACE_IRQFLAGS=y
> CONFIG_DEBUG_ATOMIC_SLEEP=y
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> CONFIG_STACKTRACE=y
> CONFIG_DEBUG_STACK_USAGE=y
> # CONFIG_DEBUG_KOBJECT is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> CONFIG_DEBUG_INFO=y
> # CONFIG_DEBUG_VM is not set
> CONFIG_DEBUG_VIRTUAL=y
> CONFIG_DEBUG_WRITECOUNT=y
> CONFIG_DEBUG_MEMORY_INIT=y
> CONFIG_DEBUG_LIST=y
> # CONFIG_TEST_LIST_SORT is not set
> # CONFIG_DEBUG_SG is not set
> # CONFIG_DEBUG_NOTIFIERS is not set
> # CONFIG_DEBUG_CREDENTIALS is not set
> CONFIG_ARCH_WANT_FRAME_POINTERS=y
> CONFIG_FRAME_POINTER=y
> # CONFIG_BOOT_PRINTK_DELAY is not set
> 
> #
> # RCU Debugging
> #
> # CONFIG_PROVE_RCU is not set
> # CONFIG_PROVE_RCU_DELAY is not set
> # CONFIG_SPARSE_RCU_POINTER is not set
> CONFIG_RCU_TORTURE_TEST=y
> CONFIG_RCU_TORTURE_TEST_RUNNABLE=y
> CONFIG_RCU_CPU_STALL_TIMEOUT=21
> CONFIG_RCU_CPU_STALL_VERBOSE=y
> CONFIG_RCU_CPU_STALL_INFO=y
> # CONFIG_RCU_TRACE is not set
> # CONFIG_BACKTRACE_SELF_TEST is not set
> # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
> # CONFIG_DEBUG_PER_CPU_MAPS is not set
> CONFIG_NOTIFIER_ERROR_INJECTION=y
> CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=y
> # CONFIG_FAULT_INJECTION is not set
> CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
> # CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
> CONFIG_DEBUG_PAGEALLOC=y
> CONFIG_WANT_PAGE_DEBUG_FLAGS=y
> CONFIG_PAGE_GUARD=y
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
> CONFIG_TRACING_SUPPORT=y
> # CONFIG_FTRACE is not set
> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
> # CONFIG_DYNAMIC_DEBUG is not set
> # CONFIG_DMA_API_DEBUG is not set
> CONFIG_ATOMIC64_SELFTEST=y
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> # CONFIG_KGDB is not set
> CONFIG_HAVE_ARCH_KMEMCHECK=y
> # CONFIG_TEST_STRING_HELPERS is not set
> CONFIG_TEST_KSTRTOX=y
> CONFIG_STRICT_DEVMEM=y
> # CONFIG_X86_VERBOSE_BOOTUP is not set
> CONFIG_EARLY_PRINTK=y
> # CONFIG_EARLY_PRINTK_DBGP is not set
> CONFIG_DEBUG_STACKOVERFLOW=y
> # CONFIG_X86_PTDUMP is not set
> CONFIG_DEBUG_RODATA=y
> # CONFIG_DEBUG_RODATA_TEST is not set
> CONFIG_DEBUG_TLBFLUSH=y
> # CONFIG_IOMMU_DEBUG is not set
> # CONFIG_IOMMU_STRESS is not set
> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> # CONFIG_IO_DELAY_0X80 is not set
> # CONFIG_IO_DELAY_0XED is not set
> CONFIG_IO_DELAY_UDELAY=y
> # CONFIG_IO_DELAY_NONE is not set
> CONFIG_DEFAULT_IO_DELAY_TYPE=2
> CONFIG_DEBUG_BOOT_PARAMS=y
> # CONFIG_CPA_DEBUG is not set
> # CONFIG_OPTIMIZE_INLINING is not set
> # CONFIG_DEBUG_NMI_SELFTEST is not set
> 
> #
> # Security options
> #
> CONFIG_KEYS=y
> # CONFIG_TRUSTED_KEYS is not set
> CONFIG_ENCRYPTED_KEYS=y
> CONFIG_KEYS_DEBUG_PROC_KEYS=y
> CONFIG_SECURITY_DMESG_RESTRICT=y
> CONFIG_SECURITY=y
> CONFIG_SECURITYFS=y
> CONFIG_SECURITY_NETWORK=y
> CONFIG_SECURITY_NETWORK_XFRM=y
> CONFIG_SECURITY_PATH=y
> # CONFIG_SECURITY_TOMOYO is not set
> CONFIG_SECURITY_APPARMOR=y
> CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
> CONFIG_SECURITY_YAMA=y
> CONFIG_SECURITY_YAMA_STACKED=y
> CONFIG_INTEGRITY=y
> CONFIG_INTEGRITY_SIGNATURE=y
> # CONFIG_INTEGRITY_ASYMMETRIC_KEYS is not set
> CONFIG_IMA=y
> CONFIG_IMA_MEASURE_PCR_IDX=10
> CONFIG_IMA_AUDIT=y
> # CONFIG_IMA_APPRAISE is not set
> # CONFIG_EVM is not set
> # CONFIG_DEFAULT_SECURITY_APPARMOR is not set
> # CONFIG_DEFAULT_SECURITY_YAMA is not set
> CONFIG_DEFAULT_SECURITY_DAC=y
> CONFIG_DEFAULT_SECURITY=""
> CONFIG_CRYPTO=y
> 
> #
> # Crypto core or helper
> #
> CONFIG_CRYPTO_FIPS=y
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
> # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
> CONFIG_CRYPTO_GF128MUL=y
> CONFIG_CRYPTO_NULL=y
> CONFIG_CRYPTO_PCRYPT=y
> CONFIG_CRYPTO_WORKQUEUE=y
> CONFIG_CRYPTO_CRYPTD=y
> CONFIG_CRYPTO_AUTHENC=y
> CONFIG_CRYPTO_ABLK_HELPER_X86=y
> CONFIG_CRYPTO_GLUE_HELPER_X86=y
> 
> #
> # Authenticated Encryption with Associated Data
> #
> CONFIG_CRYPTO_CCM=y
> CONFIG_CRYPTO_GCM=y
> CONFIG_CRYPTO_SEQIV=y
> 
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=y
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
> CONFIG_CRYPTO_CMAC=y
> CONFIG_CRYPTO_HMAC=y
> # CONFIG_CRYPTO_XCBC is not set
> CONFIG_CRYPTO_VMAC=y
> 
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=y
> CONFIG_CRYPTO_CRC32C_INTEL=y
> CONFIG_CRYPTO_CRC32=y
> CONFIG_CRYPTO_CRC32_PCLMUL=y
> CONFIG_CRYPTO_GHASH=y
> CONFIG_CRYPTO_MD4=y
> CONFIG_CRYPTO_MD5=y
> # CONFIG_CRYPTO_MICHAEL_MIC is not set
> CONFIG_CRYPTO_RMD128=y
> CONFIG_CRYPTO_RMD160=y
> # CONFIG_CRYPTO_RMD256 is not set
> CONFIG_CRYPTO_RMD320=y
> CONFIG_CRYPTO_SHA1=y
> CONFIG_CRYPTO_SHA1_SSSE3=y
> CONFIG_CRYPTO_SHA256_SSSE3=y
> CONFIG_CRYPTO_SHA512_SSSE3=y
> CONFIG_CRYPTO_SHA256=y
> CONFIG_CRYPTO_SHA512=y
> CONFIG_CRYPTO_TGR192=y
> CONFIG_CRYPTO_WP512=y
> CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y
> 
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> # CONFIG_CRYPTO_AES_X86_64 is not set
> # CONFIG_CRYPTO_AES_NI_INTEL is not set
> CONFIG_CRYPTO_ANUBIS=y
> CONFIG_CRYPTO_ARC4=y
> CONFIG_CRYPTO_BLOWFISH=y
> CONFIG_CRYPTO_BLOWFISH_COMMON=y
> CONFIG_CRYPTO_BLOWFISH_X86_64=y
> CONFIG_CRYPTO_BLOWFISH_AVX2_X86_64=y
> CONFIG_CRYPTO_CAMELLIA=y
> CONFIG_CRYPTO_CAMELLIA_X86_64=y
> CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
> CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
> CONFIG_CRYPTO_CAST_COMMON=y
> CONFIG_CRYPTO_CAST5=y
> CONFIG_CRYPTO_CAST5_AVX_X86_64=y
> CONFIG_CRYPTO_CAST6=y
> # CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
> CONFIG_CRYPTO_DES=y
> CONFIG_CRYPTO_FCRYPT=y
> CONFIG_CRYPTO_KHAZAD=y
> CONFIG_CRYPTO_SALSA20=y
> # CONFIG_CRYPTO_SALSA20_X86_64 is not set
> CONFIG_CRYPTO_SEED=y
> CONFIG_CRYPTO_SERPENT=y
> # CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
> CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
> CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
> # CONFIG_CRYPTO_TEA is not set
> # CONFIG_CRYPTO_TWOFISH is not set
> CONFIG_CRYPTO_TWOFISH_COMMON=y
> CONFIG_CRYPTO_TWOFISH_X86_64=y
> CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
> CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y
> CONFIG_CRYPTO_TWOFISH_AVX2_X86_64=y
> 
> #
> # Compression
> #
> CONFIG_CRYPTO_DEFLATE=y
> CONFIG_CRYPTO_ZLIB=y
> # CONFIG_CRYPTO_LZO is not set
> 
> #
> # Random Number Generation
> #
> CONFIG_CRYPTO_ANSI_CPRNG=y
> CONFIG_CRYPTO_USER_API=y
> CONFIG_CRYPTO_USER_API_HASH=y
> CONFIG_CRYPTO_USER_API_SKCIPHER=y
> CONFIG_CRYPTO_HW=y
> CONFIG_CRYPTO_DEV_PADLOCK=y
> CONFIG_CRYPTO_DEV_PADLOCK_AES=y
> # CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
> CONFIG_ASYMMETRIC_KEY_TYPE=y
> CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
> # CONFIG_PUBLIC_KEY_ALGO_RSA is not set
> # CONFIG_X509_CERTIFICATE_PARSER is not set
> CONFIG_HAVE_KVM=y
> CONFIG_HAVE_KVM_IRQCHIP=y
> CONFIG_HAVE_KVM_IRQ_ROUTING=y
> CONFIG_HAVE_KVM_EVENTFD=y
> CONFIG_KVM_APIC_ARCHITECTURE=y
> CONFIG_KVM_MMIO=y
> CONFIG_KVM_ASYNC_PF=y
> CONFIG_HAVE_KVM_MSI=y
> CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
> CONFIG_VIRTUALIZATION=y
> CONFIG_KVM=y
> # CONFIG_KVM_INTEL is not set
> CONFIG_KVM_AMD=y
> # CONFIG_BINARY_PRINTF is not set
> 
> #
> # Library routines
> #
> CONFIG_BITREVERSE=y
> CONFIG_GENERIC_STRNCPY_FROM_USER=y
> CONFIG_GENERIC_STRNLEN_USER=y
> CONFIG_GENERIC_FIND_FIRST_BIT=y
> CONFIG_GENERIC_PCI_IOMAP=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_IO=y
> CONFIG_CRC_CCITT=y
> CONFIG_CRC16=y
> # CONFIG_CRC_T10DIF is not set
> CONFIG_CRC_ITU_T=y
> CONFIG_CRC32=y
> CONFIG_CRC32_SELFTEST=y
> # CONFIG_CRC32_SLICEBY8 is not set
> # CONFIG_CRC32_SLICEBY4 is not set
> CONFIG_CRC32_SARWATE=y
> # CONFIG_CRC32_BIT is not set
> CONFIG_CRC7=y
> CONFIG_LIBCRC32C=y
> CONFIG_CRC8=y
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_LZO_COMPRESS=y
> CONFIG_LZO_DECOMPRESS=y
> CONFIG_XZ_DEC=y
> # CONFIG_XZ_DEC_X86 is not set
> # CONFIG_XZ_DEC_POWERPC is not set
> CONFIG_XZ_DEC_IA64=y
> # CONFIG_XZ_DEC_ARM is not set
> # CONFIG_XZ_DEC_ARMTHUMB is not set
> # CONFIG_XZ_DEC_SPARC is not set
> CONFIG_XZ_DEC_BCJ=y
> # CONFIG_XZ_DEC_TEST is not set
> CONFIG_DECOMPRESS_GZIP=y
> CONFIG_DECOMPRESS_BZIP2=y
> CONFIG_GENERIC_ALLOCATOR=y
> CONFIG_BCH=y
> CONFIG_BCH_CONST_PARAMS=y
> CONFIG_TEXTSEARCH=y
> CONFIG_TEXTSEARCH_KMP=y
> CONFIG_TEXTSEARCH_BM=y
> CONFIG_TEXTSEARCH_FSM=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y
> CONFIG_CPU_RMAP=y
> CONFIG_DQL=y
> CONFIG_NLATTR=y
> CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
> CONFIG_AVERAGE=y
> CONFIG_CLZ_TAB=y
> # CONFIG_CORDIC is not set
> CONFIG_DDR=y
> CONFIG_MPILIB=y
> CONFIG_SIGNATURE=y
> # CONFIG_IIO_SIMPLE_DUMMY is not set
> # CONFIG_ATA_SFF is not set
> # CONFIG_DRM_TTM is not set
> # CONFIG_ISDN_DRV_LOOP is not set
> # CONFIG_PCI_ATS is not set

> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.9.0-rc2-00002-g911af50 (wfg@bee) (gcc version 4.7.2 (Debian 4.7.2-4) ) #36 SMP PREEMPT Fri Jun 7 15:57:44 CST 2013
> [    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-c01-0606/sound:master:911af505ef407c2511106c224dd640f882f0f590:bisect-mmotm/.vmlinuz-911af505ef407c2511106c224dd640f882f0f590-20130607155803-737-ant branch=sound/master noapic nolapic nohz=off BOOT_IMAGE=/kernel/x86_64-randconfig-c01-0606/911af505ef407c2511106c224dd640f882f0f590/vmlinuz-3.9.0-rc2-00002-g911af50
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] debug: ignoring loglevel setting.
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.4 present.
> [    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] No AGP bridge found
> [    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: write-back
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
> [    0.000000]   1 disabled
> [    0.000000]   2 disabled
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
> [    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
> [    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
> [    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at [ffff8800000fdab0]
> [    0.000000]   mpc: fdac0-fdbe4
> [    0.000000] Base memory trampoline at [ffff88000008d000] 8d000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x02e7b000, 0x02e7bfff] PGTABLE
> [    0.000000] BRK [0x02e7c000, 0x02e7cfff] PGTABLE
> [    0.000000] BRK [0x02e7d000, 0x02e7dfff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
> [    0.000000]  [mem 0x0e600000-0x0e7fffff] page 4k
> [    0.000000] BRK [0x02e7e000, 0x02e7efff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
> [    0.000000]  [mem 0x0c000000-0x0e5fffff] page 4k
> [    0.000000] BRK [0x02e7f000, 0x02e7ffff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
> [    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
> [    0.000000]  [mem 0x0e800000-0x0fffdfff] page 4k
> [    0.000000] log_buf_len: 8388608
> [    0.000000] early log buf free: 127428(97%)
> [    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
> [    0.000000] ACPI: RSDP 00000000000fd920 00014 (v00 BOCHS )
> [    0.000000] ACPI: RSDT 000000000fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> [    0.000000] ACPI: DSDT 000000000fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
> [    0.000000] ACPI: FACS 000000000fffff40 00040
> [    0.000000] ACPI: SSDT 000000000ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: APIC 000000000ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> [    0.000000] ACPI: HPET 000000000ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
> [    0.000000] ACPI: SSDT 000000000ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
> [    0.000000] No NUMA configuration found
> [    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
> [    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
> [    0.000000]   NODE_DATA [mem 0x0fffa000-0x0fffdfff]
> [    0.000000] Zone ranges:
> [    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
> [    0.000000]   Normal   empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x00092fff]
> [    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
> [    0.000000] On node 0 totalpages: 65424
> [    0.000000]   DMA32 zone: 1024 pages used for memmap
> [    0.000000]   DMA32 zone: 21 pages reserved
> [    0.000000]   DMA32 zone: 65424 pages, LIFO batch:15
> [    0.000000] ACPI: PM-Timer IO Port: 0xb008
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] Intel MultiProcessor Specification v1.4
> [    0.000000]   mpc: fdac0-fdbe4
> [    0.000000] MPTABLE: OEM ID: BOCHSCPU
> [    0.000000] MPTABLE: Product ID: 0.1         
> [    0.000000] MPTABLE: APIC at: 0xFEE00000
> [    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
> [    0.000000] Processor #0 (Bootup-CPU)
> [    0.000000] Processor #1
> [    0.000000] Bus #0 is PCI   
> [    0.000000] Bus #1 is ISA   
> [    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
> [    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 09
> [    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0b
> [    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 10, APIC ID 2, APIC INT 0b
> [    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 14, APIC ID 2, APIC INT 0a
> [    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 18, APIC ID 2, APIC INT 0a
> [    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 1c, APIC ID 2, APIC INT 0b
> [    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 20, APIC ID 2, APIC INT 0b
> [    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 24, APIC ID 2, APIC INT 0a
> [    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 28, APIC ID 2, APIC INT 0a
> [    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 00, APIC ID 2, APIC INT 02
> [    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 01, APIC ID 2, APIC INT 01
> [    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 03, APIC ID 2, APIC INT 03
> [    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 04, APIC ID 2, APIC INT 04
> [    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 05, APIC ID 2, APIC INT 05
> [    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 06, APIC ID 2, APIC INT 06
> [    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 07, APIC ID 2, APIC INT 07
> [    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 08, APIC ID 2, APIC INT 08
> [    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0c, APIC ID 2, APIC INT 0c
> [    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0d, APIC ID 2, APIC INT 0d
> [    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0e, APIC ID 2, APIC INT 0e
> [    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0f, APIC ID 2, APIC INT 0f
> [    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC LINT 00
> [    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID ff, APIC LINT 01
> [    0.000000] Processors: 2
> [    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] e820: [mem 0x10000000-0xfffbffff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 472 pages/cpu @ffff88000da00000 s1910592 r0 d22720 u2097152
> [    0.000000] pcpu-alloc: s1910592 r0 d22720 u2097152 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 [0] 1 
> [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 64379
> [    0.000000] Policy zone: DMA32
> [    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/x86_64-randconfig-c01-0606/sound:master:911af505ef407c2511106c224dd640f882f0f590:bisect-mmotm/.vmlinuz-911af505ef407c2511106c224dd640f882f0f590-20130607155803-737-ant branch=sound/master noapic nolapic nohz=off BOOT_IMAGE=/kernel/x86_64-randconfig-c01-0606/911af505ef407c2511106c224dd640f882f0f590/vmlinuz-3.9.0-rc2-00002-g911af50
> [    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
> [    0.000000] __ex_table already sorted, skipping sort
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Memory: 189772k/262136k available (6458k kernel code, 440k absent, 71924k reserved, 8466k data, 2796k init)
> [    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> [    0.000000] Preemptible hierarchical RCU implementation.
> [    0.000000] 
> [    0.000000] 
> [    0.000000] 
> [    0.000000] 
> [    0.000000] 
> [    0.000000] NR_IRQS:4352 nr_irqs:512 16
> [    0.000000] console [ttyS0] enabled
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
> [    0.000000] ... CHAINHASH_SIZE:          16384
> [    0.000000]  memory used by lock dependency info: 6367 kB
> [    0.000000]  per task-struct memory footprint: 2688 bytes
> [    0.000000] allocated 1048576 bytes of page_cgroup
> [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
> [    0.000000] ODEBUG: 13 of 13 active objects replaced
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Fast TSC calibration failed
> [    0.000000] tsc: Unable to calibrate against PIT
> [    0.000000] tsc: using HPET reference calibration
> [    0.000000] tsc: Detected 3192.044 MHz processor
> [    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
> [    0.089999] Calibrating delay loop (skipped), value calculated using timer frequency.. 6386.09 BogoMIPS (lpj=10640146)
> [    0.097676] pid_max: default: 4096 minimum: 301
> [    0.129999] Security Framework initialized
> [    0.157444] AppArmor: AppArmor disabled by boot time parameter
> [    0.160750] Yama: becoming mindful.
> [    0.202020] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
> [    0.234693] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
> [    0.251616] Mount-cache hash table entries: 256
> [    0.601409] Initializing cgroup subsys debug
> [    0.611342] Initializing cgroup subsys memory
> [    0.654260] Initializing cgroup subsys freezer
> [    0.724785] mce: CPU supports 10 MCE banks
> [    0.747608] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.747608] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.747608] tlb_flushall_shift: -1
> [    0.784564] debug: unmapping init [mem 0xffffffff82153000-0xffffffff82157fff]
> [    0.988577] ACPI: Core revision 20130117
> [    1.858405] ACPI: All ACPI Tables successfully acquired
> [    1.864332] ACPI: setting ELCR to 0200 (from 0c00)
> [    1.987896] smpboot: SMP disabled
> [    1.995309] Performance Events: 
> [    2.007150] no APIC, boot with the "lapic" boot parameter to force-enable it.
> [    2.010481] no hardware sampling interrupt available.
> [    2.012068] Broken PMU hardware detected, using software events only.
> [    2.014046] Failed to access perfctr msr (MSR c0010004 is 0)
> [    2.315069] Brought up 1 CPUs
> [    2.318488] smpboot: Total of 1 processors activated (6386.09 BogoMIPS)
> [    2.835233] atomic64 test passed for x86-64 platform with CX8 and with SSE
> [    3.067345] regulator-dummy: no parameters
> [    3.168276] NET: Registered protocol family 16
> [    3.351729] ACPI: bus type PCI registered
> [    3.404120] PCI: Using configuration type 1 for base access
> [    5.397920] ACPI: Added _OSI(Module Device)
> [    5.400691] ACPI: Added _OSI(Processor Device)
> [    5.401631] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    5.403856] ACPI: Added _OSI(Processor Aggregator Device)
> [    6.131270] ACPI: EC: Look up EC in DSDT
> [    7.672547] ACPI: Interpreter enabled
> [    7.679401] ACPI: (supports S0 S5)
> [    7.680649] ACPI: Using PIC for interrupt routing
> [    7.693953] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
> [   10.071460] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [   10.075310] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
> [   10.090830] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
> [   10.093333] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
> [   10.098079] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
> [   10.100613] acpi PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
> [   10.104448] PCI: root bus 00: using default resources
> [   10.126666] PCI host bridge to bus 0000:00
> [   10.130788] pci_bus 0000:00: root bus resource [bus 00-ff]
> [   10.133988] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
> [   10.135080] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
> [   10.147465] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
> [   10.251738] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
> [   10.308453] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
> [   10.364192] pci 0000:00:01.1: reg 20: [io  0xc1e0-0xc1ef]
> [   10.468414] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
> [   10.485208] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
> [   10.490626] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
> [   10.521375] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
> [   10.530884] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
> [   10.541866] pci 0000:00:02.0: reg 14: [mem 0xfebe0000-0xfebe0fff]
> [   10.570686] pci 0000:00:02.0: reg 30: [mem 0xfebc0000-0xfebcffff pref]
> [   10.601890] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
> [   10.610712] pci 0000:00:03.0: reg 10: [io  0xc1c0-0xc1df]
> [   10.623989] pci 0000:00:03.0: reg 14: [mem 0xfebe1000-0xfebe1fff]
> [   10.658332] pci 0000:00:03.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
> [   10.691551] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
> [   10.700744] pci 0000:00:04.0: reg 10: [mem 0xfeb80000-0xfeb9ffff]
> [   10.708603] pci 0000:00:04.0: reg 14: [io  0xc000-0xc03f]
> [   10.743904] pci 0000:00:04.0: reg 30: [mem 0xfeba0000-0xfebbffff pref]
> [   10.780472] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
> [   10.794018] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
> [   10.803876] pci 0000:00:05.0: reg 14: [mem 0xfebe2000-0xfebe2fff]
> [   10.877553] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
> [   10.885561] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
> [   10.891976] pci 0000:00:06.0: reg 14: [mem 0xfebe3000-0xfebe3fff]
> [   10.972200] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
> [   10.983333] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
> [   10.990552] pci 0000:00:07.0: reg 14: [mem 0xfebe4000-0xfebe4fff]
> [   11.087343] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
> [   11.104913] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
> [   11.118215] pci 0000:00:08.0: reg 14: [mem 0xfebe5000-0xfebe5fff]
> [   11.225511] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
> [   11.238367] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
> [   11.251485] pci 0000:00:09.0: reg 14: [mem 0xfebe6000-0xfebe6fff]
> [   11.401714] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
> [   11.413973] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
> [   11.418801] pci 0000:00:0a.0: reg 14: [mem 0xfebe7000-0xfebe7fff]
> [   11.510650] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
> [   11.520551] pci 0000:00:0b.0: reg 10: [mem 0xfebe8000-0xfebe800f]
> [   11.614201] ACPI _OSC control for PCIe not granted, disabling ASPM
> [   11.985780] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
> [   12.021004] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
> [   12.045649] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
> [   12.081847] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
> [   12.114996] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
> [   12.179999] ACPI: Enabled 16 GPEs in block 00 to 0F
> [   12.189003] acpi root: \_SB_.PCI0 notify handler is installed
> [   12.229999] Found 1 acpi root devices
> [   12.359999] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> [   12.368487] vgaarb: loaded
> [   12.370562] vgaarb: bridge control possible 0000:00:02.0
> [   12.387391] Error: Driver '88PM80X' is already registered, aborting...
> [   12.534649] pps_core: LinuxPPS API ver. 1 registered
> [   12.537184] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [   12.544137] PTP clock support registered
> [   12.549120] EDAC MC: Ver: 3.0.0
> [   12.615666] Advanced Linux Sound Architecture Driver Initialized.
> [   12.617388] PCI: Using ACPI for IRQ routing
> [   12.620934] PCI: pci_cache_line_size set to 64 bytes
> [   12.643764] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
> [   12.645506] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
> [   12.774218] NET: Registered protocol family 23
> [   12.782176] NET: Registered protocol family 8
> [   12.783934] NET: Registered protocol family 20
> [   12.807293] nfc: nfc_init: NFC Core ver 0.1
> [   12.818269] NET: Registered protocol family 39
> [   12.840946] Switching to clocksource hpet
> [   12.861485] CE: hpet increased min_delta_ns to 5000 nsec
> [   12.861485] CE: hpet increased min_delta_ns to 7500 nsec
> [   12.861485] CE: hpet increased min_delta_ns to 11250 nsec
> [   13.036677] FS-Cache: Loaded
> [   13.079348] pnp: PnP ACPI init
> [   13.109837] ACPI: bus type PNP registered
> [   13.234349] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
> [   13.332636] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
> [   13.410015] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
> [   13.476318] pnp 00:03: [dma 2]
> [   13.509149] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
> [   13.662742] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
> [   13.778555] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
> [   14.229652] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
> [   14.433336] pnp: PnP ACPI: found 7 devices
> [   14.449887] ACPI: bus type PNP unregistered
> [   14.999864] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
> [   15.018140] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
> [   15.035204] NET: Registered protocol family 1
> [   15.045912] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> [   15.062441] pci 0000:00:01.0: PIIX3: Enabling Passive Release
> [   15.083107] pci 0000:00:01.0: Activating ISA DMA hang workarounds
> [   15.108903] pci 0000:00:02.0: Boot video device
> [   15.133216] PCI: CLS 0 bytes, default 64
> [   16.049613] Unpacking initramfs...
> [   19.820527] hrtimer: interrupt took 8885131 ns
> 
> BUG: kernel freezed
> Elapsed time: 810

