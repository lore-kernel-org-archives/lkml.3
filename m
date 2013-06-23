Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab3FWAfy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 20:35:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:58869 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab3FWAfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 20:35:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,920,1363158000"; 
   d="log'?scan'208";a="354157547"
Date: Sun, 23 Jun 2013 08:35:40 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: fengguang.wu@intel.com, Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [tip/x86/trace] INFO: suspicious RCU usage.
Message-ID: <20130623003540.GB7541@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="yNb1oOkm5a9FJOVX"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yNb1oOkm5a9FJOVX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit cf910e83ae23692fdeefc7e506e504c4c468d38a
Author: Seiji Aguchi <seiji.aguchi@hds.com>
Date:   Thu Jun 20 11:46:53 2013 -0400

    x86, trace: Add irq vector tracepoints
    
    [Purpose of this patch]
    
    As Vaibhav explained in the thread below, tracepoints for irq vectors
    are useful.
    
    http://www.spinics.net/lists/mm-commits/msg85707.html
    
    <snip>
    The current interrupt traces from irq_handler_entry and irq_handler_exit
    provide when an interrupt is handled.  They provide good data about when
    the system has switched to kernel space and how it affects the currently
    running processes.
    
    There are some IRQ vectors which trigger the system into kernel space,
    which are not handled in generic IRQ handlers.  Tracing such events gives
    us the information about IRQ interaction with other system events.
    
    The trace also tells where the system is spending its time.  We want to
    know which cores are handling interrupts and how they are affecting other
    processes in the system.  Also, the trace provides information about when
    the cores are idle and which interrupts are changing that state.
    <snip>
    
    On the other hand, my usecase is tracing just local timer event and
    getting a value of instruction pointer.
    
    I suggested to add an argument local timer event to get instruction pointer before.
    But there is another way to get it with external module like systemtap.
    So, I don't need to add any argument to irq vector tracepoints now.
    
    [Patch Description]
    
    Vaibhav's patch shared a trace point ,irq_vector_entry/irq_vector_exit, in all events.
    But there is an above use case to trace specific irq_vector rather than tracing all events.
    In this case, we are concerned about overhead due to unwanted events.
    
    So, add following tracepoints instead of introducing irq_vector_entry/exit.
    so that we can enable them independently.
       - local_timer_vector
       - reschedule_vector
       - call_function_vector
       - call_function_single_vector
       - irq_work_entry_vector
       - error_apic_vector
       - thermal_apic_vector
       - threshold_apic_vector
       - spurious_apic_vector
       - x86_platform_ipi_vector
    
    Also, introduce a logic switching IDT at enabling/disabling time so that a time penalty
    makes a zero when tracepoints are disabled. Detailed explanations are as follows.
     - Create trace irq handlers with entering_irq()/exiting_irq().
     - Create a new IDT, trace_idt_table, at boot time by adding a logic to
       _set_gate(). It is just a copy of original idt table.
     - Register the new handlers for tracpoints to the new IDT by introducing
       macros to alloc_intr_gate() called at registering time of irq_vector handlers.
     - Add checking, whether irq vector tracing is on/off, into load_current_idt().
       This has to be done below debug checking for these reasons.
       - Switching to debug IDT may be kicked while tracing is enabled.
       - On the other hands, switching to trace IDT is kicked only when debugging
         is disabled.
    
    In addition, the new IDT is created only when CONFIG_TRACING is enabled to avoid being
    used for other purposes.
    
    Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
    Link: http://lkml.kernel.org/r/51C323ED.5050708@hds.com
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
    Cc: Steven Rostedt <rostedt@goodmis.org>

[   50.721349] 
[   50.721502] ===============================
[   50.721835] [ INFO: suspicious RCU usage. ]
[   50.722169] 3.10.0-rc6-00004-gcf910e8 #190 Not tainted
[   50.722582] -------------------------------
[   50.722915] /c/kernel-tests/src/linux/arch/x86/include/asm/trace/irq_vectors.h:50 suspicious rcu_dereference_check() usage!
[   50.723770] 
[   50.723770] other info that might help us debug this:
[   50.723770] 
[   50.724385] 
[   50.724385] RCU used illegally from idle CPU!
[   50.724385] rcu_scheduler_active = 1, debug_locks = 0
[   50.725232] RCU used illegally from extended quiescent state!
[   50.725690] no locks held by swapper/0/0.
[   50.726010] 
[   50.726010] stack backtrace:
[   50.726359] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.10.0-rc6-00004-gcf910e8 #190
[   50.726965] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011

[   50.727417]  00000001 00000001 79c53f04 798bd9f9 79c53f2c 79077a70 79b412c6 79b41fd1
[   50.728159]  00000001 00000000 79c5ef8c 87147c58 00000000 79c55800 79c53f38 79010b65
[   50.728849]  79c52000 79c53f7c 798c720e 79c52000 79c5ef8c 00000004 00000000 79c55800
[   50.729532] Call Trace:
[   50.729730]  [<798bd9f9>] dump_stack+0x16/0x18
[   50.730072]  [<79077a70>] lockdep_rcu_suspicious+0xf2/0xfa
[   50.730498]  [<79010b65>] smp_trace_reschedule_interrupt+0x1c8/0x1d0
[   50.730979]  [<798c720e>] trace_reschedule_interrupt+0x36/0x3c
[   50.731214]  [<7901875f>] ? native_safe_halt+0x5/0x7
[   50.731214]  [<790085cc>] default_idle+0xb1/0x1e2
[   50.731214]  [<79008d05>] arch_cpu_idle+0xe/0x10
[   50.731214]  [<79069ddf>] cpu_startup_entry+0x1e4/0x2c3
[   50.731214]  [<798adb34>] rest_init+0x12c/0x132
[   50.731214]  [<798ada08>] ? __read_lock_failed+0x14/0x14
[   50.731214]  [<79d309e4>] start_kernel+0x38d/0x393
[   50.731214]  [<79d30489>] ? repair_env_string+0x51/0x51
[   50.731214]  [<79d302c3>] i386_start_kernel+0x79/0x7d
[   50.771947] OK
[   50.772099] Testing event reschedule_entry: OK

git bisect start cf910e83ae23692fdeefc7e506e504c4c468d38a v3.9 --
git bisect good fbcd4836d20a33209843dcf84f83a33b97b74c9a  # 16:16     52+  [SCSI] qla4xxx: Assign values using correct datatype
git bisect good 91f8575685e35f3bd021286bc82d26397458f5a9  # 17:09     52+  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client
git bisect good c4cc75c3321cad6f20d1e5325293890255c8a663  # 20:03     52+  Merge git://git.infradead.org/users/eparis/audit
git bisect good 3a5395b3d57b9e3836c755434c88f4590d5ea6f6  # 20:17     52+  net: ethernet: xilinx_emaclite: set protocol selector bits when writing ANAR
git bisect good e6395b68ad09a835f058da31bad0fe23d3882659  # 20:28     52+  Merge tag 'for-linus-v3.10-rc5' of git://oss.sgi.com/xfs/xfs
git bisect good 5402b8047b0d286b6501f9097891cbf1e06daa3a  # 20:40     52+  lib/mpi/mpicoder.c: looping issue, need stop when equal to zero, found by 'EXTRA_FLAGS=-W'.
git bisect good 2dc85bf323515e59e15dfa858d1472bb25cad0fe  # 20:53     52+  packet: packet_getname_spkt: make sure string is always 0-terminated
git bisect good 3ad2e318a24124c53cc6390b5bfbd7613d9c2145  # 21:06     52+  Merge tag 'usb-3.10-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb
git bisect good 5938930e71affa390c3fa33fa2fda52f58f850e8  # 21:17     52+  Merge branch 'merge' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc
git bisect good 323226bbb3d865af12644d66df2b7f161adf51c7  # 21:30     52+  Merge tag 'fixes-3.10-4' of git://git.infradead.org/users/jcooper/linux into fixes
git bisect good dd019897358b815f7828dab90b51d51df4d3658d  # 21:40     52+  net: sh_eth: fix incorrect RX length error if R8A7740
git bisect good e6694d984adbe8146d2f1e08d500befc1481835e  # 22:02     52+  Merge tag 'fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect good f5abaa1bfc3dbf26d19d3513f39279ca369f8d65  # 22:13     52+  tracing: Add DEFINE_EVENT_FN() macro
git bisect good 629f4f9d59a27d8e58aa612e886e6a9a63ea7aeb  # 22:24     52+  x86: Rename variables for debugging
git bisect good 629f4f9d59a27d8e58aa612e886e6a9a63ea7aeb  # 22:31    156+  x86: Rename variables for debugging
git bisect  bad 83ab85140bc1492f92de263a1c30ea04a0f465f7  # 22:31      0-  trace,x86: Move creation of irq tracepoints from apic.c to irq.c
git bisect good f71194a7d47c1da787555d27aac63973ca72323b  # 22:36    156+  Merge branch 'x86/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good a92a990789849502897e3e19c2c0e5154888edf7  # 23:55    156+  Merge branch 'perf/core'

Thanks,
Fengguang

--yNb1oOkm5a9FJOVX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-kbuild-6225-20130622055129-3.10.0-rc6-00004-gcf910e8-190"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.10.0-rc6-00004-gcf910e8 (kbuild@roam) (gcc version 4.8.1 (Debian 4.8.1-3) ) #190 SMP Sat Jun 22 05:46:39 CST 2013
[    0.000000] KERNEL supported cpus:
[    0.000000]   Centaur CentaurHauls
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x100000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at [780fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x02bfffff]
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
[    0.000000] BRK [0x02400000, 0x02400fff] PGTABLE
[    0.000000] cma: dma_contiguous_reserve(limit 00000000)
[    0.000000] cma: dma_contiguous_reserve: reserving 16 MiB for global area
[    0.000000] cma: dma_declare_contiguous(size 1000000, base 00000000, limit 00000000)
[    0.000000] cma: CMA: reserved 16 MiB at 0d400000
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128128(97%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe450 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0fffe490 011A9 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0ffff680 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0ffff640 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffff9000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] BRK [0x02401000, 0x02401fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000] free_area_init_node: node 0, pgdat 79d1d4e0, node_mem_map 8653f020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 480 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffff9000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffff8000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 11 pages/cpu @86529000 s29376 r0 d15680 u45056
[    0.000000] pcpu-alloc: s29376 r0 d15680 u45056 alloc=11*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr e52b5c0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64924
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kernel-tests/run-queue/kvm/i386-randconfig-r00-0621/tip:x86:trace/.vmlinuz-cf910e83ae23692fdeefc7e506e504c4c468d38a-20130622054730-4-kbuild branch=tip/x86/trace  BOOT_IMAGE=/kernel/i386-randconfig-r00-0621/cf910e83ae23692fdeefc7e506e504c4c468d38a/vmlinuz-3.10.0-rc6-00004-gcf910e8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 524264 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 188440k/262136k available (8994k kernel code, 73304k reserved, 4506k data, 932k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd33000 - 0xfffff000   (2864 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x887fe000 - 0xff7fe000   (1904 MB)
[    0.000000]     lowmem  : 0x78000000 - 0x87ffe000   ( 255 MB)
[    0.000000]       .init : 0x79d30000 - 0x79e19000   ( 932 kB)
[    0.000000]       .data : 0x798c88ff - 0x79d2f200   (4506 kB)
[    0.000000]       .text : 0x79000000 - 0x798c88ff   (8994 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] 
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=84802000 soft=84804000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
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
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.432 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.020000] Calibrating delay loop (skipped) preset value.. 5386.86 BogoMIPS (lpj=26934320)
[    0.020000] pid_max: default: 4096 minimum: 301
[    0.020000] Mount-cache hash table entries: 512
[    0.020000] Initializing cgroup subsys debug
[    0.020000] Initializing cgroup subsys memory
[    0.020000] Initializing cgroup subsys blkio
[    0.020000] Initializing cgroup subsys net_prio
[    0.020000] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020000] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.020000] tlb_flushall_shift: -1
[    0.020000] Freeing SMP alternatives: 32k freed
[    0.022059] ACPI: Core revision 20130328
[    0.025872] ACPI: All ACPI Tables successfully acquired
[    0.026345] ftrace: allocating 36867 entries in 73 pages
[    0.040091] Getting VERSION: 50014
[    0.040390] Getting VERSION: 50014
[    0.040669] Getting ID: 0
[    0.040890] Getting ID: f000000
[    0.041152] Getting LVT0: 8700
[    0.041409] Getting LVT1: 8400
[    0.041660] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.042141] enabled ExtINT on CPU#0
[    0.043179] ENABLING IO-APIC IRQs
[    0.043459] init IO_APIC IRQs
[    0.043700]  apic 0 pin 0 not connected
[    0.044016] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.050020] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.050663] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.051300] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.051942] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.052580] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.053217] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.053856] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.054490] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.055130] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.055786] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.056435] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.057089] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.057748] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.058394] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.059041]  apic 0 pin 16 not connected
[    0.059354]  apic 0 pin 17 not connected
[    0.060003]  apic 0 pin 18 not connected
[    0.060313]  apic 0 pin 19 not connected
[    0.060623]  apic 0 pin 20 not connected
[    0.060940]  apic 0 pin 21 not connected
[    0.061248]  apic 0 pin 22 not connected
[    0.061554]  apic 0 pin 23 not connected
[    0.062003] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.062570] smpboot: CPU0: GenuineIntel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.063441] Using local APIC timer interrupts.
[    0.063441] calibrating APIC timer ...
[    0.070000] ... lapic delta = 6249848
[    0.070000] ... PM-Timer delta = 357945
[    0.070000] ... PM-Timer result ok
[    0.070000] ..... delta 6249848
[    0.070000] ..... mult: 268428927
[    0.070000] ..... calibration result: 9999756
[    0.070000] ..... CPU clock speed is 2693.4293 MHz.
[    0.070000] ..... host bus clock speed is 999.9756 MHz.
[    0.070000] Performance Events: 
[    0.070000] Testing tracer nop: PASSED
[    0.070000] SMP alternatives: lockdep: fixing up alternatives
[    0.070000] CPU 1 irqstacks, hard=848ac000 soft=848ae000
[    0.070000] smpboot: Booting Node   0, Processors  #1 OK
[    0.010000] Initializing CPU#1
[    0.020000] kvm-clock: cpu 1, msr 0:fffd041, secondary cpu clock
[    0.020000] masked ExtINT on CPU#1
[    0.075544] Brought up 2 CPUs
[    0.075489] KVM setup async PF for cpu 1
[    0.075489] kvm-stealtime: cpu 1, msr e5365c0
[    0.076417] smpboot: Total of 2 processors activated (10773.72 BogoMIPS)
[    0.190012] Testing tracer function: PASSED
[    0.510726] Testing dynamic ftrace: PASSED
[    0.940107] Testing dynamic ftrace ops #1: (1 0 1 1 0) (1 1 2 1 0) (2 1 3 1 10) (2 2 4 1 92) PASSED
[    1.268329] Testing dynamic ftrace ops #2: (1 0 1 8 0) (1 1 2 88 0) (2 1 3 1 3) (2 2 4 79 81) PASSED
[    1.600770] Testing ftrace recursion: PASSED
[    1.625951] Testing ftrace recursion safe: PASSED
[    1.651095] Testing ftrace regs: PASSED
[    1.850009] Testing tracer wakeup: ret = 0
[    2.340048] ftrace-test (16) used greatest stack depth: 7160 bytes left
[    2.430014] PASSED
[    2.520013] Testing tracer wakeup_rt: ret = 0
[    3.110011] PASSED
[    3.111679] xor: measuring software checksum speed
[    3.204668]    pIII_sse  : 13055.200 MB/sec
[    3.304668]    prefetch64-sse: 13998.000 MB/sec
[    3.305018] xor: using function: prefetch64-sse (13998.000 MB/sec)
[    3.305480] atomic64 test passed for i586+ platform with CX8 and with SSE
[    3.306002] cma: cma_init_reserved_areas()
[    3.306315] cma: cma_create_area(base 0000d400, count 1000)
[    3.306790] cma: cma_create_area: returned 848d6bd8
[    3.307284] NET: Registered protocol family 16
[    3.310042] ACPI: bus type PCI registered
[    3.310589] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=0
[    3.311080] PCI: Using configuration type 1 for base access
[    3.320335] bio: create slab <bio-0> at 0
[    3.490014] raid6: mmxx1     5132 MB/s
[    3.660010] raid6: mmxx2     5434 MB/s
[    3.830009] raid6: sse1x1    4287 MB/s
[    4.000015] raid6: sse1x2    5229 MB/s
[    4.170006] raid6: sse2x1    8493 MB/s
[    4.340008] raid6: sse2x2   10458 MB/s
[    4.340315] raid6: using algorithm sse2x2 (10458 MB/s)
[    4.340716] raid6: using intx1 recovery algorithm
[    4.341320] ACPI: Added _OSI(Module Device)
[    4.341653] ACPI: Added _OSI(Processor Device)
[    4.341997] ACPI: Added _OSI(3.0 _SCP Extensions)
[    4.342359] ACPI: Added _OSI(Processor Aggregator Device)
[    4.343891] ACPI: EC: Look up EC in DSDT
[    4.349909] ACPI: Interpreter enabled
[    4.350031] ACPI: (supports S0 S4 S5)
[    4.350322] ACPI: Using IOAPIC for interrupt routing
[    4.350735] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    4.361930] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    4.362924] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    4.363918] PCI host bridge to bus 0000:00
[    4.364243] pci_bus 0000:00: root bus resource [bus 00-ff]
[    4.364679] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    4.365154] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    4.365624] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    4.366149] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
[    4.366719] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    4.367663] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    4.368538] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    4.371603] pci 0000:00:01.1: reg 20: [io  0xc1e0-0xc1ef]
[    4.373425] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    4.374157] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    4.374726] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    4.375449] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    4.377194] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    4.378881] pci 0000:00:02.0: reg 14: [mem 0xfebe0000-0xfebe0fff]
[    4.385250] pci 0000:00:02.0: reg 30: [mem 0xfebc0000-0xfebcffff pref]
[    4.385952] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    4.387464] pci 0000:00:03.0: reg 10: [io  0xc1c0-0xc1df]
[    4.388903] pci 0000:00:03.0: reg 14: [mem 0xfebe1000-0xfebe1fff]
[    4.394528] pci 0000:00:03.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
[    4.395333] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    4.396843] pci 0000:00:04.0: reg 10: [mem 0xfeb80000-0xfeb9ffff]
[    4.398331] pci 0000:00:04.0: reg 14: [io  0xc000-0xc03f]
[    4.403573] pci 0000:00:04.0: reg 30: [mem 0xfeba0000-0xfebbffff pref]
[    4.404260] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    4.405803] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    4.407247] pci 0000:00:05.0: reg 14: [mem 0xfebe2000-0xfebe2fff]
[    4.413401] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    4.414937] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    4.416383] pci 0000:00:06.0: reg 14: [mem 0xfebe3000-0xfebe3fff]
[    4.422371] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    4.423905] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    4.425356] pci 0000:00:07.0: reg 14: [mem 0xfebe4000-0xfebe4fff]
[    4.430830] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    4.432354] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    4.433798] pci 0000:00:08.0: reg 14: [mem 0xfebe5000-0xfebe5fff]
[    4.440199] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    4.441728] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    4.443171] pci 0000:00:09.0: reg 14: [mem 0xfebe6000-0xfebe6fff]
[    4.449110] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    4.450526] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    4.451975] pci 0000:00:0a.0: reg 14: [mem 0xfebe7000-0xfebe7fff]
[    4.457884] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    4.458891] pci 0000:00:0b.0: reg 10: [mem 0xfebe8000-0xfebe800f]
[    4.462971] pci_bus 0000:00: on NUMA node 0
[    4.463301] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    4.463913] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    4.465460] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    4.466174] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    4.466876] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    4.467570] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    4.468163] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    4.469001] ACPI: Enabled 16 GPEs in block 00 to 0F
[    4.469406] acpi root: \_SB_.PCI0 notify handler is installed
[    4.469911] Found 1 acpi root devices
[    4.471276] ACPI: No dock devices found.
[    4.471721] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    4.472334] vgaarb: loaded
[    4.472552] vgaarb: bridge control possible 0000:00:02.0
[    4.473036] tps65010: version 2 May 2005
[    4.510084] tps65010: no chip?
[    4.510633] media: Linux media interface: v0.10
[    4.511016] Linux video capture interface: v2.00
[    4.511402] pps_core: LinuxPPS API ver. 1 registered
[    4.511799] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    4.512494] PTP clock support registered
[    4.512898] PCI: Using ACPI for IRQ routing
[    4.512898] PCI: pci_cache_line_size set to 64 bytes
[    4.512898] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    4.512898] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    4.512898] Bluetooth: Core ver 2.16
[    4.512898] NET: Registered protocol family 31
[    4.512947] Bluetooth: HCI device and connection manager initialized
[    4.513441] Bluetooth: HCI socket layer initialized
[    4.513830] Bluetooth: L2CAP socket layer initialized
[    4.514228] Bluetooth: SCO socket layer initialized
[    4.514604] NET: Registered protocol family 8
[    4.514950] NET: Registered protocol family 20
[    4.515608] cfg80211: Calling CRDA to update world regulatory domain
[    4.516240] nfc: nfc_init: NFC Core ver 0.1
[    4.516600] NET: Registered protocol family 39
[    4.520343] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    4.520906] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    4.521323] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    4.527932] Switching to clocksource kvm-clock
[    4.565446] FS-Cache: Loaded
[    4.565728] pnp: PnP ACPI init
[    4.565988] ACPI: bus type PNP registered
[    4.566358] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    4.567019] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    4.567563] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    4.568215] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    4.568739] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    4.569400] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    4.569971] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    4.570615] pnp 00:03: [dma 2]
[    4.570897] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    4.571484] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    4.572151] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    4.572759] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    4.573453] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    4.574451] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    4.575419] pnp: PnP ACPI: found 7 devices
[    4.575731] ACPI: bus type PNP unregistered
[    4.611519] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    4.611941] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    4.612360] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    4.612823] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    4.613301] NET: Registered protocol family 1
[    4.613635] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    4.614083] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    4.614527] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    4.615005] pci 0000:00:02.0: Boot video device
[    4.615407] PCI: CLS 0 bytes, default 64
[    4.615845] Unpacking initramfs...
[    5.331917] Freeing initrd memory: 25284k freed
[    5.657621] DMA-API: preallocated 65536 debug entries
[    5.658032] DMA-API: debugging enabled by kernel config
[    5.659296] apm: BIOS not found.
[    5.661312] NatSemi SCx200 Driver
[    5.662621] Initializing RT-Tester: OK
[    5.662925] audit: initializing netlink socket (disabled)
[    5.663378] type=2000 audit(1371851269.660:1): initialized
[    5.664786] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    5.665383] VFS: Disk quotas dquot_6.5.2
[    5.665711] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    5.667066] NTFS driver 2.1.30 [Flags: R/O].
[    5.667425] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    5.667819] QNX4 filesystem 0.2.3 registered.
[    5.668160] QNX6 filesystem 1.0.0 registered.
[    5.668503] fuse init (API version 7.22)
[    5.669319] JFS: nTxBlock = 1797, nTxLock = 14383
[    5.670415] SGI XFS with security attributes, realtime, no debug enabled
[    5.671384] BeFS version: 0.9.3
[    5.671678] bio: create slab <bio-1> at 1
[    5.672362] Running btrfs free space cache tests
[    5.672729] Running extent only tests
[    5.673033] Running bitmap only tests
[    5.673335] Running bitmap and extent tests
[    5.673677] Free space cache tests finished
[    5.673999] Btrfs loaded
[    5.674214] msgmni has been set to 449
[    5.678887] NET: Registered protocol family 38
[    5.679277] Key type asymmetric registered
[    5.679617] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 248)
[    5.680246] io scheduler noop registered (default)
[    5.680616] list_sort_test: start testing list_sort()
[    5.681796] xz_dec_test: module loaded
[    5.682092] xz_dec_test: Create a device node with 'mknod xz_dec_test c 247 0' and write .xz files to it.
[    5.683659] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    5.684088] cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
[    5.684626] cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
[    5.685177] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    5.686246] rivafb_setup START
[    5.686575] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    5.687639] no IO addresses supplied
[    5.687995] hv_vmbus: registering driver hyperv_fb
[    5.688585] ipmi message handler version 39.2
[    5.688925] ipmi device interface
[    5.689231] IPMI System Interface driver.
[    5.689588] ipmi_si: Adding default-specified kcs state machine
[    5.690073] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[    5.690843] ipmi_si: Interface detection failed
[    5.800369] ipmi_si: Adding default-specified smic state machine
[    5.800869] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[    5.801885] ipmi_si: Interface detection failed
[    5.880099] ipmi_si: Adding default-specified bt state machine
[    5.880594] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[    5.881350] ipmi_si: Interface detection failed
[    5.950149] ipmi_si: Unable to find any System Interface(s)
[    5.950612] IPMI Watchdog: driver initialized
[    5.951181] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    5.951770] ACPI: Power Button [PWRF]
[    5.952167] GHES: HEST is not enabled!
[    5.952545] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    5.974330] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    5.976436] Cyclades driver 2.6
[    5.976711] MOXA Intellio family driver version 6.0k
[    5.977282] MOXA Smartio/Industio family driver version 2.0.5
[    5.977743] Initializing Nozomi driver 2.1d
[    5.978092] SyncLink serial driver $Revision: 4.38 $
[    5.989940] SyncLink serial driver $Revision: 4.38 $, tty major#240
[    5.991178] Non-volatile memory driver v1.3
[    5.991520] toshiba: not a supported Toshiba laptop
[    5.991918] ppdev: user-space parallel port driver
[    5.992296] scx200_gpio: no SCx200 gpio present
[    5.992687] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
[    5.993248] platform pc8736x_gpio.0: no device found
[    5.993739] nsc_gpio initializing
[    5.994011] telclk_interrupt = 0xf non-mcpbl0010 hw.
[    5.994424] smapi::smapi_init, ERROR invalid usSmapiID
[    5.994817] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[    5.995522] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[    5.996070] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    5.996591] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    5.997278] Hangcheck: Using getrawmonotonic().
[    5.998014] lkdtm: No crash points registered, enable through debugfs
[    5.998564] Phantom Linux Driver, version n0.9.8, init OK
[    5.999555] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[    6.000215] c2port c2port0: C2 port uc added
[    6.000545] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
[    6.001433] Guest personality initialized and is inactive
[    6.002036] VMCI host device registered (name=vmci, major=10, minor=59)
[    6.002552] Initialized host personality
[    6.003192] Driver for timberdale has been successfully registered.
[    6.004039] Uniform Multi-Platform E-IDE driver
[    6.004443] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
[    6.005002] piix 0000:00:01.1: not 100% native mode: will probe irqs later
[    6.006048] pci 0000:00:01.1: setting latency timer to 64
[    6.006491]     ide0: BM-DMA at 0xc1e0-0xc1e7
[    6.006856]     ide1: BM-DMA at 0xc1e8-0xc1ef
[    6.007199] Probing IDE interface ide0...
[    6.610830] Probing IDE interface ide1...
[    7.400085] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
[    8.120128] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO0
[    8.120700] hdc: MWDMA2 mode selected
[    8.121107] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    8.121511] ide1 at 0x170-0x177,0x376 on irq 15
[    8.123611] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    8.124380] ide-gd driver 1.18
[    8.124641] ide-cd driver 5.00
[    8.125441] ide-cd: hdc: ATAPI 4X DVD-ROM drive, 512kB Cache
[    8.125912] cdrom: Uniform CD-ROM driver Revision: 3.20
[    8.128283] HSI/SSI char device loaded
[    8.129154] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
[    8.132410] tun: Universal TUN/TAP device driver, 1.6
[    8.132798] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    8.133311] arcnet loaded.
[    8.133525] arcnet: RFC1201 "standard" (`a') encapsulation support loaded.
[    8.134035] arcnet: RFC1051 "simple standard" (`s') encapsulation support loaded.
[    8.134604] arcnet: cap mode (`c') encapsulation support loaded.
[    8.135055] arcnet: COM90xx chipset support
[    8.435822] S3: No ARCnet cards found.
[    8.436124] arcnet: COM20020 PCI support
[    8.437175] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256).
[    8.437727] hdlc: HDLC support module revision 1.22
[    8.438147] DLCI driver v0.35, 4 Jan 1997, mike.mclagan@linux.org.
[    8.438934] Madge ATM Horizon [Ultra] driver version 1.2.1
[    8.439643] idt77252_init: at 79d72d81
[    8.439950] Solos PCI Driver Version 1.04
[    8.440302] adummy: version 1.0
[    8.441409] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    8.442618] serio: i8042 KBD port at 0x60,0x64 irq 1
[    8.443039] serio: i8042 AUX port at 0x60,0x64 irq 12
[    8.443450] parkbd: no such parport
[    8.480643] evbug: Connected device: input0 (Power Button at LNXPWRBN/button/input0)
[    8.482715] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    8.483825] input: PC Speaker as /devices/platform/pcspkr/input/input1
[    8.484326] evbug: Connected device: input1 (PC Speaker at isa0061/input0)
[    8.485183] wistron_btns: System unknown
[    8.486908] rtc-test rtc-test.0: rtc core: registered test as rtc0
[    8.487641] rtc-test rtc-test.1: rtc core: registered test as rtc1
[    8.488791] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, revision 0
[    8.490733] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    8.491394] evbug: Connected device: input2 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
[    8.760821] i2c-parport: adapter type unspecified
[    8.761194] i2c-parport-light: adapter type unspecified
[    8.762011] lirc_dev: IR Remote Control driver registered, major 234 
[    8.762523] IR NEC protocol handler initialized
[    8.762865] IR RC5(x) protocol handler initialized
[    8.763225] IR RC6 protocol handler initialized
[    8.763574] IR JVC protocol handler initialized
[    8.763918] IR Sony protocol handler initialized
[    8.764263] IR RC5 (streamzap) protocol handler initialized
[    8.764699] IR SANYO protocol handler initialized
[    8.765051] IR MCE Keyboard/mouse protocol handler initialized
[    8.765498] IR LIRC bridge handler initialized
[    8.766089] Marvell M88ALP01 'CAFE' Camera Controller version 2
[    8.766588] Colour QuickCam for Video4Linux v0.06
[    8.767281] Driver for 1-wire Dallas network protocol.
[    8.767741] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    8.980052] w83793: Detection failed at check vendor id
[    9.040052] w83793: Detection failed at check vendor id
[    9.100053] w83793: Detection failed at check vendor id
[    9.160055] w83793: Detection failed at check vendor id
[    9.200081] i2c i2c-0: w83795: Detection failed at addr 0x2c, check bank
[    9.240055] i2c i2c-0: w83795: Detection failed at addr 0x2d, check bank
[    9.280054] i2c i2c-0: w83795: Detection failed at addr 0x2e, check bank
[    9.320052] i2c i2c-0: w83795: Detection failed at addr 0x2f, check bank
[    9.360072] i2c i2c-0: Detection of w83781d chip failed at step 3
[    9.400055] i2c i2c-0: Detection of w83781d chip failed at step 3
[    9.440050] i2c i2c-0: Detection of w83781d chip failed at step 3
[    9.480054] i2c i2c-0: Detection of w83781d chip failed at step 3
[    9.520054] i2c i2c-0: Detection of w83781d chip failed at step 3
[    9.560052] i2c i2c-0: Detection of w83781d chip failed at step 3
[    9.600078] i2c i2c-0: Detection of w83781d chip failed at step 3
[    9.640053] i2c i2c-0: Detection of w83781d chip failed at step 3
[    9.880052] detect failed, chip not detected!
[    9.960051] detect failed, chip not detected!
[   10.040067] detect failed, chip not detected!
[   10.120063] detect failed, chip not detected!
[   10.200051] detect failed, chip not detected!
[   10.280054] detect failed, chip not detected!
[   10.360051] detect failed, chip not detected!
[   10.440071] detect failed, chip not detected!
[   10.520052] detect failed, chip not detected!
[   11.360054]  (null): Wrong manufacturer ID. Got 255, expected 65
[   11.400052]  (null): Wrong manufacturer ID. Got 255, expected 65
[   11.440107]  (null): Wrong manufacturer ID. Got 255, expected 65
[   12.520105] f71882fg: Not a Fintek device
[   12.520708] f71882fg: Not a Fintek device
[   12.640076]  (null): Unknown chip type, skipping
[   12.680057]  (null): Unknown chip type, skipping
[   27.680059] i2c i2c-0: LM83 detection failed at 0x18
[   27.720059] i2c i2c-0: LM83 detection failed at 0x19
[   27.760075] i2c i2c-0: LM83 detection failed at 0x1a
[   27.800056] i2c i2c-0: LM83 detection failed at 0x29
[   27.840114] i2c i2c-0: LM83 detection failed at 0x2a
[   27.880076] i2c i2c-0: LM83 detection failed at 0x2b
[   27.920082] i2c i2c-0: LM83 detection failed at 0x4c
[   27.960051] i2c i2c-0: LM83 detection failed at 0x4d
[   28.000080] i2c i2c-0: LM83 detection failed at 0x4e
[   28.100085] i2c i2c-0: Unsupported chip at 0x18 (man_id=0xFF, chip_id=0xFF)
[   28.200074] i2c i2c-0: Unsupported chip at 0x19 (man_id=0xFF, chip_id=0xFF)
[   28.300075] i2c i2c-0: Unsupported chip at 0x1a (man_id=0xFF, chip_id=0xFF)
[   28.400092] i2c i2c-0: Unsupported chip at 0x29 (man_id=0xFF, chip_id=0xFF)
[   28.500061] i2c i2c-0: Unsupported chip at 0x2a (man_id=0xFF, chip_id=0xFF)
[   28.600080] i2c i2c-0: Unsupported chip at 0x2b (man_id=0xFF, chip_id=0xFF)
[   28.700073] i2c i2c-0: Unsupported chip at 0x48 (man_id=0xFF, chip_id=0xFF)
[   28.800073] i2c i2c-0: Unsupported chip at 0x49 (man_id=0xFF, chip_id=0xFF)
[   28.900056] i2c i2c-0: Unsupported chip at 0x4a (man_id=0xFF, chip_id=0xFF)
[   29.000057] i2c i2c-0: Unsupported chip at 0x4b (man_id=0xFF, chip_id=0xFF)
[   29.100055] i2c i2c-0: Unsupported chip at 0x4c (man_id=0xFF, chip_id=0xFF)
[   29.200066] i2c i2c-0: Unsupported chip at 0x4d (man_id=0xFF, chip_id=0xFF)
[   29.300064] i2c i2c-0: Unsupported chip at 0x4e (man_id=0xFF, chip_id=0xFF)
[   29.400060] i2c i2c-0: Unsupported chip at 0x4f (man_id=0xFF, chip_id=0xFF)
[   30.000066] i2c i2c-0: detect failed, bad manufacturer id 0xff!
[   30.040055] i2c i2c-0: detect failed, bad manufacturer id 0xff!
[   30.080068] i2c i2c-0: detect failed, bad manufacturer id 0xff!
[   30.360067] i2c i2c-0: MAX1619 detection failed at 0x18
[   30.440065] i2c i2c-0: MAX1619 detection failed at 0x19
[   30.520062] i2c i2c-0: MAX1619 detection failed at 0x1a
[   30.600065] i2c i2c-0: MAX1619 detection failed at 0x29
[   30.680078] i2c i2c-0: MAX1619 detection failed at 0x2a
[   30.760078] i2c i2c-0: MAX1619 detection failed at 0x2b
[   30.840079] i2c i2c-0: MAX1619 detection failed at 0x4c
[   30.920070] i2c i2c-0: MAX1619 detection failed at 0x4d
[   31.000076] i2c i2c-0: MAX1619 detection failed at 0x4e
[   31.680953] pc87360: PC8736x not detected, module not inserted
[   31.681771] sch56xx_common: Unsupported device id: 0xff
[   31.682180] sch56xx_common: Unsupported device id: 0xff
[   31.740055] i2c i2c-0: SMSC47M192 detection failed at 0x2c
[   31.800050] i2c i2c-0: SMSC47M192 detection failed at 0x2d
[   31.840052] i2c i2c-0: W83L786NG detection failed at 0x2e
[   31.880080] i2c i2c-0: W83L786NG detection failed at 0x2f
[   31.881577] acquirewdt: WDT driver for Acquire single board computer initialising
[   31.882248] acquirewdt: I/O address 0x0043 already in use
[   31.882657] acquirewdt: probe of acquirewdt failed with error -5
[   31.883307] advantechwdt: WDT driver for Advantech single board computer initialising
[   31.884528] advantechwdt: initialized. timeout=60 sec (nowayout=1)
[   31.885009] alim7101_wdt: Steve Hill <steve@navaho.co.uk>
[   31.885415] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[   31.885896] sp5100_tco: SP5100/SB800 TCO WatchDog Timer Driver v0.05
[   31.886457] sc520_wdt: cannot register miscdev on minor=130 (err=-16)
[   31.886977] ib700wdt: WDT driver for IB700 single board computer initialising
[   31.887829] ib700wdt: START method I/O 443 is not available
[   31.888263] ib700wdt: probe of ib700wdt failed with error -5
[   31.888847] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[   31.889783] i6300esb: cannot register miscdev on minor=130 (err=-16)
[   31.890525] i6300ESB timer: probe of 0000:00:0b.0 failed with error -16
[   31.891065] it87_wdt: no device
[   31.891325] sc1200wdt: build 20020303
[   31.891614] sc1200wdt: io parameter must be specified
[   31.892013] pc87413_wdt: Version 1.1 at io 0x2E
[   31.892355] pc87413_wdt: cannot register miscdev on minor=130 (err=-16)
[   31.892844] nv_tco: NV TCO WatchDog Timer Driver v0.01
[   31.893586] sbc60xxwdt: I/O address 0x0443 already in use
[   31.894008] sbc7240_wdt: I/O address 0x0443 already in use
[   31.894465] w83627hf_wdt: WDT driver for the Winbond(TM) W83627HF/THF/HG/DHG Super I/O chip initialising
[   31.895191] w83627hf_wdt: Watchdog already running. Resetting timeout to 60 sec
[   31.895741] w83627hf_wdt: cannot register miscdev on minor=130 (err=-16)
[   31.896239] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[   31.896694] w83697hf_wdt: watchdog not found at address 0x2e
[   31.897134] w83697hf_wdt: No W83697HF/HG could be found
[   31.897520] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Super I/O chip initialising
[   31.898178] w83697ug_wdt: No W83697UG/UF could be found
[   31.898570] w83877f_wdt: I/O address 0x0443 already in use
[   31.898985] w83977f_wdt: driver v1.00
[   31.899262] w83977f_wdt: cannot register miscdev on minor=130 (err=-16)
[   31.899777] watchdog: Software Watchdog: cannot register miscdev on minor=130 (err=-16).
[   31.900401] watchdog: Software Watchdog: a legacy watchdog module is probably present.
[   31.901057] softdog: Software Watchdog Timer: 0.08 initialized. soft_noboot=0 soft_margin=60 sec soft_panic=0 (nowayout=1)
[   31.901872] md: raid0 personality registered for level 0
[   31.902276] md: raid1 personality registered for level 1
[   31.902668] md: raid10 personality registered for level 10
[   31.903087] md: raid6 personality registered for level 6
[   31.903483] md: raid5 personality registered for level 5
[   31.903877] md: raid4 personality registered for level 4
[   31.904277] md: faulty personality registered for level -5
[   31.905522] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
[   31.907314] device-mapper: multipath: version 1.5.1 loaded
[   31.907739] device-mapper: multipath round-robin: version 1.0.0 loaded
[   31.908234] device-mapper: multipath service-time: version 0.2.0 loaded
[   31.908780] device-mapper: dm-log-userspace: version 1.1.0 loaded
[   31.909241] device-mapper: raid: Loading target version 1.5.0
[   31.909685] device-mapper: cache-policy-mq: version 1.0.0 loaded
[   31.910178] device-mapper: cache cleaner: version 1.0.0 loaded
[   31.910903] Bluetooth: Generic Bluetooth SDIO driver ver 0.1
[   31.911611] CAPI 2.0 started up with major 68 (middleware)
[   31.912062] b1pci: revision 1.1.2.2
[   31.912328] b1: revision 1.1.2.2
[   31.912568] b1dma: revision 1.1.2.3
[   31.912829] b1pci: revision 1.1.2.2
[   31.913138] t1pci: revision 1.1.2.2
[   31.913400] gigaset: Driver for Gigaset 307x
[   31.913715] gigaset: no ISDN subsystem interface
[   31.914075] lguest: mapped switcher at ffd2d000
[   31.914757] wbsd: Winbond W83L51xD SD/MMC card interface driver
[   31.915211] wbsd: Copyright(c) Pierre Ossman
[   35.650092] CPA self-test:
[   35.650588]  4k 3070 large 61 gb 0 x 3131[78000000-87ffd000] miss 0
[   35.668660]  4k 64510 large 1 gb 0 x 64511[78000000-87ffd000] miss 0
[   35.682042]  4k 64510 large 1 gb 0 x 64511[78000000-87ffd000] miss 0
[   35.682837] ok.
[   39.930136]  (null): enodev DEV ADDR = 0xFF
[   39.933248] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   39.934262] hidraw: raw HID events driver (C) Jiri Kosina
[   39.938341] compal_laptop: Motherboard not recognized (You could try the module's force-parameter)
[   39.939430] acerhdf: Acer Aspire One Fan driver, v.0.5.26
[   39.940135] acerhdf: unknown (unsupported) BIOS version Bochs/Bochs/Bochs, please report, aborting!
[   39.941902] hdaps: supported laptop not found!
[   39.942452] hdaps: driver init failed (ret=-19)!
[   39.943934] fujitsu_laptop: driver 0.6.0 successfully loaded
[   39.944633] fujitsu_tablet: Unknown (using defaults)
[   39.945759] intel_oaktrail: Platform not recognized (You could try the module's force-parameter)
[   39.946868] goldfish_pdev_bus goldfish_pdev_bus: unable to reserve Goldfish MMIO.
[   39.947832] goldfish_pdev_bus: probe of goldfish_pdev_bus failed with error -16
[   39.948786] hv_utils: Registering HyperV Utility Driver
[   39.949426] hv_vmbus: registering driver hv_util
[   39.951660] oprofile: using timer interrupt.
[   39.952267] NET: Registered protocol family 26
[   39.952879] NET: Registered protocol family 17
[   39.953514] NET: Registered protocol family 15
[   39.954139] Ebtables v2.0 registered
[   39.955683] NET: Registered protocol family 4
[   39.956067] NET: Registered protocol family 9
[   39.956454] X.25 for Linux Version 0.2
[   39.956745] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   39.957152] Bluetooth: BNEP filters: multicast
[   39.957522] Bluetooth: BNEP socket layer initialized
[   39.957903] Bluetooth: CMTP (CAPI Emulation) ver 1.0
[   39.958292] Bluetooth: CMTP socket layer initialized
[   39.958670] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   39.959117] Bluetooth: HIDP socket layer initialized
[   39.959521] lec:lane_module_init: lec.c: initialized
[   39.959903] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[   39.960604] DECnet: Routing cache hash table of 256 buckets, 9Kbytes
[   39.961105] NET: Registered protocol family 12
[   39.961482] 8021q: 802.1Q VLAN Support v1.8
[   39.961831] 9pnet: Installing 9P2000 support
[   39.962210] NET: Registered protocol family 36
[   39.962622] Key type dns_resolver registered
[   39.962956] openvswitch: Open vSwitch switching datapath
[   39.963529] NET: Registered protocol family 40
[   39.964327] 
[   39.964327] printing PIC contents
[   39.964710] ... PIC  IMR: ffff
[   39.964951] ... PIC  IRR: 9013
[   39.965207] ... PIC  ISR: 0000
[   39.965449] ... PIC ELCR: 0c00
[   39.965692] printing local APIC contents on CPU#0/0:
[   39.966077] ... APIC ID:      00000000 (0)
[   39.966404] ... APIC VERSION: 00050014
[   39.966696] ... APIC TASKPRI: 00000000 (00)
[   39.967021] ... APIC PROCPRI: 00000000
[   39.967343] ... APIC LDR: 01000000
[   39.967608] ... APIC DFR: ffffffff
[   39.967874] ... APIC SPIV: 000001ff
[   39.968142] ... APIC ISR field:
[   39.968438] 0000000000000000000000000000000000000000000000000000000000000000
[   39.969081] ... APIC TMR field:
[   39.969342] 0000000000000000000000000000000000000000000000000000000000000000
[   39.969984] ... APIC IRR field:
[   39.970245] 0000000000000000000000000000000000000000000000000000000000008000
[   39.970545] ... APIC ESR: 00000000
[   39.970545] ... APIC ICR: 000008fd
[   39.970545] ... APIC ICR2: 02000000
[   39.970545] ... APIC LVTT: 000000ef
[   39.970545] ... APIC LVTPC: 00010000
[   39.970545] ... APIC LVT0: 00010700
[   39.970545] ... APIC LVT1: 00000400
[   39.970545] ... APIC LVTERR: 000000fe
[   39.970545] ... APIC TMICT: 00090333
[   39.970545] ... APIC TMCCT: 00000000
[   39.970545] ... APIC TDCR: 00000003
[   39.970545] 
[   39.974116] number of MP IRQ sources: 15.
[   39.974433] number of IO-APIC #0 registers: 24.
[   39.974777] testing the IO APIC.......................
[   39.975189] IO APIC #0......
[   39.975414] .... register #00: 00000000
[   39.975708] .......    : physical APIC id: 00
[   39.976040] .......    : Delivery Type: 0
[   39.976385] .......    : LTS          : 0
[   39.976692] .... register #01: 00170011
[   39.976984] .......     : max redirection entries: 17
[   39.977394] .......     : PRQ implemented: 0
[   39.977718] .......     : IO APIC version: 11
[   39.978050] .... register #02: 00000000
[   39.978355] .......     : arbitration: 00
[   39.978663] .... IRQ redirection table:
[   39.978966] 1    0    0   0   0    0    0    00
[   39.979331] 0    0    0   0   0    1    1    31
[   39.979688] 0    0    0   0   0    1    1    30
[   39.980056] 0    0    0   0   0    1    1    33
[   39.980457] 1    0    0   0   0    1    1    34
[   39.980814] 1    1    0   0   0    1    1    35
[   39.981175] 0    0    0   0   0    1    1    36
[   39.981533] 0    0    0   0   0    1    1    37
[   39.981888] 0    0    0   0   0    1    1    38
[   39.982250] 0    1    0   0   0    1    1    39
[   39.982604] 1    1    0   0   0    1    1    3A
[   39.982956] 1    1    0   0   0    1    1    3B
[   39.983315] 0    0    0   0   0    1    1    3C
[   39.983669] 0    0    0   0   0    1    1    3D
[   39.984024] 0    0    0   0   0    1    1    3E
[   39.984416] 0    0    0   0   0    1    1    3F
[   39.984771] 1    0    0   0   0    0    0    00
[   39.985124] 1    0    0   0   0    0    0    00
[   39.985486] 1    0    0   0   0    0    0    00
[   39.985839] 1    0    0   0   0    0    0    00
[   39.986200] 1    0    0   0   0    0    0    00
[   39.986554] 1    0    0   0   0    0    0    00
[   39.986907] 1    0    0   0   0    0    0    00
[   39.987272] 1    0    0   0   0    0    0    00
[   39.987617] IRQ to pin mappings:
[   39.987868] IRQ0 -> 0:2
[   39.988082] IRQ1 -> 0:1
[   39.988337] IRQ3 -> 0:3
[   39.988552] IRQ4 -> 0:4
[   39.988767] IRQ5 -> 0:5
[   39.988981] IRQ6 -> 0:6
[   39.989203] IRQ7 -> 0:7
[   39.989418] IRQ8 -> 0:8
[   39.989633] IRQ9 -> 0:9
[   39.989849] IRQ10 -> 0:10
[   39.990093] IRQ11 -> 0:11
[   39.990325] IRQ12 -> 0:12
[   39.990550] IRQ13 -> 0:13
[   39.990777] IRQ14 -> 0:14
[   39.991004] IRQ15 -> 0:15
[   39.991235] .................................... done.
[   39.991623] Using IPI No-Shortcut mode
[   39.992508] PM: Hibernation image not present or could not be loaded.
[   39.993008] Running ring buffer tests...
[   49.990055] rbhammer (117) used greatest stack depth: 6968 bytes left
[   49.990699] finished
[   49.990890] CPU 0:
[   49.991049]               events:    1000
[   49.991356]        dropped bytes:    0
[   49.991652]        alloced bytes:    77328
[   49.991966]        written bytes:    75846
[   49.992279]        biggest event:    96
[   49.992580]       smallest event:    0
[   49.993255]          read events:   1000
[   49.993564]          lost events:   0
[   49.993844]         total events:   1000
[   49.994143]   recorded len bytes:   77328
[   49.994448]  recorded size bytes:   75846
[   49.994759] CPU 1:
[   49.994919]               events:    637401
[   49.995239]        dropped bytes:    0
[   49.995530]        alloced bytes:    49881564
[   49.995864]        written bytes:    48936787
[   49.996196]        biggest event:    255
[   49.996501]       smallest event:    4
[   50.001135]          read events:   11536
[   50.001460]          lost events:   625865
[   50.001778]         total events:   637401
[   50.002095]   recorded len bytes:   991768
[   50.002413]  recorded size bytes:   973973
[   50.002735]  With dropped events, record len and size may not match
[   50.002735]  alloced and written from above
[   50.003525] Ring buffer PASSED!
[   50.004157] Running tests on trace events:
[   50.004483] Testing event sys_exit: OK
[   50.040588] Testing event sys_enter: OK
[   50.080593] Testing event thermal_apic_exit: OK
[   50.120551] Testing event thermal_apic_entry: OK
[   50.160545] Testing event threshold_apic_exit: OK
[   50.200567] Testing event threshold_apic_entry: OK
[   50.240536] Testing event call_function_single_exit: OK
[   50.282277] Testing event call_function_single_entry: OK
[   50.320807] Testing event call_function_exit: OK
[   50.360587] Testing event call_function_entry: OK
[   50.400617] Testing event irq_work_exit: OK
[   50.440520] Testing event irq_work_entry: OK
[   50.480614] Testing event x86_platform_ipi_exit: OK
[   50.520548] Testing event x86_platform_ipi_entry: OK
[   50.560679] Testing event error_apic_exit: OK
[   50.600719] Testing event error_apic_entry: OK
[   50.640558] Testing event spurious_apic_exit: OK
[   50.680758] Testing event spurious_apic_entry: OK
[   50.720557] Testing event reschedule_exit: 
[   50.721349] 
[   50.721502] ===============================
[   50.721835] [ INFO: suspicious RCU usage. ]
[   50.722169] 3.10.0-rc6-00004-gcf910e8 #190 Not tainted
[   50.722582] -------------------------------
[   50.722915] /c/kernel-tests/src/linux/arch/x86/include/asm/trace/irq_vectors.h:50 suspicious rcu_dereference_check() usage!
[   50.723770] 
[   50.723770] other info that might help us debug this:
[   50.723770] 
[   50.724385] 
[   50.724385] RCU used illegally from idle CPU!
[   50.724385] rcu_scheduler_active = 1, debug_locks = 0
[   50.725232] RCU used illegally from extended quiescent state!
[   50.725690] no locks held by swapper/0/0.
[   50.726010] 
[   50.726010] stack backtrace:
[   50.726359] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.10.0-rc6-00004-gcf910e8 #190
[   50.726965] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011

[   50.727417]  00000001 00000001 79c53f04 798bd9f9 79c53f2c 79077a70 79b412c6 79b41fd1
[   50.728159]  00000001 00000000 79c5ef8c 87147c58 00000000 79c55800 79c53f38 79010b65
[   50.728849]  79c52000 79c53f7c 798c720e 79c52000 79c5ef8c 00000004 00000000 79c55800
[   50.729532] Call Trace:
[   50.729730]  [<798bd9f9>] dump_stack+0x16/0x18
[   50.730072]  [<79077a70>] lockdep_rcu_suspicious+0xf2/0xfa
[   50.730498]  [<79010b65>] smp_trace_reschedule_interrupt+0x1c8/0x1d0
[   50.730979]  [<798c720e>] trace_reschedule_interrupt+0x36/0x3c
[   50.731214]  [<7901875f>] ? native_safe_halt+0x5/0x7
[   50.731214]  [<790085cc>] default_idle+0xb1/0x1e2
[   50.731214]  [<79008d05>] arch_cpu_idle+0xe/0x10
[   50.731214]  [<79069ddf>] cpu_startup_entry+0x1e4/0x2c3
[   50.731214]  [<798adb34>] rest_init+0x12c/0x132
[   50.731214]  [<798ada08>] ? __read_lock_failed+0x14/0x14
[   50.731214]  [<79d309e4>] start_kernel+0x38d/0x393
[   50.731214]  [<79d30489>] ? repair_env_string+0x51/0x51
[   50.731214]  [<79d302c3>] i386_start_kernel+0x79/0x7d
[   50.771947] OK
[   50.772099] Testing event reschedule_entry: OK
[   50.810605] Testing event local_timer_exit: OK
[   50.850466] Testing event local_timer_entry: OK
[   50.890558] Testing event task_rename: OK
[   50.930506] Testing event task_newtask: OK
[   50.970529] Testing event console: OK
[   51.010544] Testing event softirq_raise: OK
[   51.050509] Testing event softirq_exit: OK
[   51.090443] Testing event softirq_entry: OK
[   51.130466] Testing event irq_handler_exit: OK
[   51.170459] Testing event irq_handler_entry: OK
[   51.210461] Testing event tick_stop: OK
[   51.250446] Testing event itimer_expire: OK
[   51.290698] Testing event itimer_state: OK
[   51.331676] Testing event hrtimer_cancel: OK
[   51.370606] Testing event hrtimer_expire_exit: OK
[   51.410532] Testing event hrtimer_expire_entry: OK
[   51.450608] Testing event hrtimer_start: OK
[   51.491933] Testing event hrtimer_init: OK
[   51.530655] Testing event timer_cancel: OK
[   51.570707] Testing event timer_expire_exit: OK
[   51.610672] Testing event timer_expire_entry: OK
[   51.650651] Testing event timer_start: OK
[   51.690627] Testing event timer_init: OK
[   51.730584] Testing event signal_deliver: OK
[   51.770482] Testing event signal_generate: OK
[   51.810632] Testing event workqueue_execute_end: OK
[   51.850466] Testing event workqueue_execute_start: OK
[   51.890486] Testing event workqueue_activate_work: OK
[   51.930560] Testing event workqueue_queue_work: OK
[   51.970540] Testing event rcu_barrier: OK
[   52.010509] Testing event rcu_torture_read: OK
[   52.050805] Testing event rcu_batch_end: OK
[   52.090527] Testing event rcu_invoke_kfree_callback: OK
[   52.130477] Testing event rcu_invoke_callback: OK
[   52.170553] Testing event rcu_batch_start: OK
[   52.210479] Testing event rcu_kfree_callback: OK
[   52.250463] Testing event rcu_callback: OK
[   52.290623] Testing event rcu_prep_idle: OK
[   52.330574] Testing event rcu_dyntick: OK
[   52.370883] Testing event rcu_fqs: OK
[   52.410658] Testing event rcu_quiescent_state_report: OK
[   52.450515] Testing event rcu_unlock_preempted_task: OK
[   52.490558] Testing event rcu_preempt_task: OK
[   52.530451] Testing event rcu_grace_period_init: OK
[   52.570585] Testing event rcu_future_grace_period: OK
[   52.610587] Testing event rcu_grace_period: OK
[   52.650793] Testing event rcu_utilization: OK
[   52.690876] Testing event sched_pi_setprio: OK
[   52.730688] Testing event sched_stat_runtime: OK
[   52.770569] Testing event sched_stat_blocked: OK
[   52.810523] Testing event sched_stat_iowait: OK
[   52.850478] Testing event sched_stat_sleep: OK
[   52.890669] Testing event sched_stat_wait: OK
[   52.930522] Testing event sched_process_exec: OK
[   52.970491] Testing event sched_process_fork: OK
[   53.010589] Testing event sched_process_wait: OK
[   53.050536] Testing event sched_wait_task: OK
[   53.092287] Testing event sched_process_exit: OK
[   53.132095] Testing event sched_process_free: OK
[   53.170813] Testing event sched_migrate_task: OK
[   53.210822] Testing event sched_switch: OK
[   53.250700] Testing event sched_wakeup_new: OK
[   53.290943] Testing event sched_wakeup: OK
[   53.330933] Testing event sched_kthread_stop_ret: OK
[   53.370802] Testing event sched_kthread_stop: OK
[   53.410516] Testing event lock_release: OK
[   53.450798] Testing event lock_acquire: OK
[   53.490517] Testing event ftrace_test_filter: OK
[   53.530446] Testing event power_domain_target: OK
[   53.570711] Testing event clock_set_rate: OK
[   53.610662] Testing event clock_disable: OK
[   53.650453] Testing event clock_enable: OK
[   53.690575] Testing event wakeup_source_deactivate: OK
[   53.730520] Testing event wakeup_source_activate: OK
[   53.770570] Testing event machine_suspend: OK
[   53.810507] Testing event cpu_frequency: OK
[   53.850583] Testing event cpu_idle: OK
[   53.890526] Testing event rpm_return_int: OK
[   53.930875] Testing event rpm_idle: OK
[   53.970494] Testing event rpm_resume: OK
[   54.010497] Testing event rpm_suspend: OK
[   54.050442] Testing event mm_filemap_add_to_page_cache: OK
[   54.090704] Testing event mm_filemap_delete_from_page_cache: OK
[   54.131599] Testing event oom_score_adj_update: OK
[   54.170788] Testing event mm_vmscan_lru_shrink_inactive: OK
[   54.210711] Testing event mm_vmscan_writepage: OK
[   54.250807] Testing event mm_vmscan_memcg_isolate: OK
[   54.290721] Testing event mm_vmscan_lru_isolate: OK
[   54.330751] Testing event mm_shrink_slab_end: OK
[   54.370781] Testing event mm_shrink_slab_start: OK
[   54.410760] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[   54.450576] Testing event mm_vmscan_memcg_reclaim_end: OK
[   54.490601] Testing event mm_vmscan_direct_reclaim_end: OK
[   54.530549] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[   54.570674] Testing event mm_vmscan_memcg_reclaim_begin: OK
[   54.610653] Testing event mm_vmscan_direct_reclaim_begin: OK
[   54.650599] Testing event mm_vmscan_wakeup_kswapd: OK
[   54.690648] Testing event mm_vmscan_kswapd_wake: OK
[   54.730596] Testing event mm_vmscan_kswapd_sleep: OK
[   54.770584] Testing event mm_page_alloc_extfrag: OK
[   54.810542] Testing event mm_page_pcpu_drain: OK
[   54.850603] Testing event mm_page_alloc_zone_locked: OK
[   54.890563] Testing event mm_page_alloc: OK
[   54.930764] Testing event mm_page_free_batched: OK
[   54.970748] Testing event mm_page_free: OK
[   55.010794] Testing event kmem_cache_free: OK
[   55.050578] Testing event kfree: OK
[   55.090726] Testing event kmem_cache_alloc_node: OK
[   55.130821] Testing event kmalloc_node: OK
[   55.170715] Testing event kmem_cache_alloc: OK
[   55.210525] Testing event kmalloc: OK
[   55.250550] Testing event mm_compaction_migratepages: OK
[   55.290713] Testing event mm_compaction_isolate_freepages: OK
[   55.330775] Testing event mm_compaction_isolate_migratepages: OK
[   55.370646] Testing event mm_migrate_pages: OK
[   55.410558] Testing event writeback_single_inode: OK
[   55.450599] Testing event writeback_single_inode_start: OK
[   55.490641] Testing event writeback_wait_iff_congested: OK
[   55.530811] Testing event writeback_congestion_wait: OK
[   55.570840] Testing event writeback_sb_inodes_requeue: OK
[   55.610727] Testing event balance_dirty_pages: OK
[   55.650806] Testing event bdi_dirty_ratelimit: OK
[   55.690781] Testing event global_dirty_state: OK
[   55.732244] Testing event writeback_queue_io: OK
[   55.770795] Testing event wbc_writepage: OK
[   55.810790] Testing event writeback_bdi_unregister: OK
[   55.850762] Testing event writeback_bdi_register: OK
[   55.890761] Testing event writeback_wake_background: OK
[   55.930772] Testing event writeback_nowork: OK
[   55.970773] Testing event writeback_pages_written: OK
[   56.010769] Testing event writeback_wait: OK
[   56.050713] Testing event writeback_written: OK
[   56.090762] Testing event writeback_start: OK
[   56.130782] Testing event writeback_exec: OK
[   56.170756] Testing event writeback_queue: OK
[   56.210815] Testing event writeback_write_inode: OK
[   56.250733] Testing event writeback_write_inode_start: OK
[   56.290723] Testing event writeback_dirty_inode: OK
[   56.330795] Testing event writeback_dirty_inode_start: OK
[   56.370771] Testing event writeback_dirty_page: OK
[   56.410724] Testing event ext4_es_shrink_exit: OK
[   56.450733] Testing event ext4_es_shrink_enter: OK
[   56.490744] Testing event ext4_es_lookup_extent_exit: OK
[   56.530698] Testing event ext4_es_lookup_extent_enter: OK
[   56.570740] Testing event ext4_es_find_delayed_extent_range_exit: OK
[   56.610757] Testing event ext4_es_find_delayed_extent_range_enter: OK
[   56.650745] Testing event ext4_es_remove_extent: OK
[   56.690733] Testing event ext4_es_insert_extent: OK
[   56.730714] Testing event ext4_ext_remove_space_done: OK
[   56.770722] Testing event ext4_ext_remove_space: OK
[   56.810781] Testing event ext4_ext_rm_idx: OK
[   56.850792] Testing event ext4_ext_rm_leaf: OK
[   56.890759] Testing event ext4_remove_blocks: OK
[   56.930684] Testing event ext4_ext_show_extent: OK
[   56.970733] Testing event ext4_get_reserved_cluster_alloc: OK
[   57.010738] Testing event ext4_find_delalloc_range: OK
[   57.050646] Testing event ext4_ext_in_cache: OK
[   57.090726] Testing event ext4_ext_put_in_cache: OK
[   57.130700] Testing event ext4_get_implied_cluster_alloc_exit: OK
[   57.170771] Testing event ext4_ext_handle_uninitialized_extents: OK
[   57.210808] Testing event ext4_trim_all_free: OK
[   57.250741] Testing event ext4_trim_extent: OK
[   57.290724] Testing event ext4_journal_start: OK
[   57.330784] Testing event ext4_load_inode: OK
[   57.370756] Testing event ext4_ext_load_extent: OK
[   57.410728] Testing event ext4_ind_map_blocks_exit: OK
[   57.450741] Testing event ext4_ext_map_blocks_exit: OK
[   57.490728] Testing event ext4_ind_map_blocks_enter: OK
[   57.530794] Testing event ext4_ext_map_blocks_enter: OK
[   57.570764] Testing event ext4_ext_convert_to_initialized_fastpath: OK
[   57.610795] Testing event ext4_ext_convert_to_initialized_enter: OK
[   57.650620] Testing event ext4_truncate_exit: OK
[   57.690656] Testing event ext4_truncate_enter: OK
[   57.730686] Testing event ext4_unlink_exit: OK
[   57.770774] Testing event ext4_unlink_enter: OK
[   57.810548] Testing event ext4_punch_hole: OK
[   57.850745] Testing event ext4_fallocate_exit: OK
[   57.890599] Testing event ext4_fallocate_enter: OK
[   57.930556] Testing event ext4_direct_IO_exit: OK
[   57.970551] Testing event ext4_direct_IO_enter: OK
[   58.010692] Testing event ext4_load_inode_bitmap: OK
[   58.050594] Testing event ext4_read_block_bitmap_load: OK
[   58.090607] Testing event ext4_mb_buddy_bitmap_load: OK
[   58.130739] Testing event ext4_mb_bitmap_load: OK
[   58.170617] Testing event ext4_da_release_space: OK
[   58.210785] Testing event ext4_da_reserve_space: OK
[   58.250874] Testing event ext4_da_update_reserve_space: OK
[   58.290809] Testing event ext4_forget: OK
[   58.330830] Testing event ext4_mballoc_free: OK
[   58.370784] Testing event ext4_mballoc_discard: OK
[   58.410598] Testing event ext4_mballoc_prealloc: OK
[   58.450778] Testing event ext4_mballoc_alloc: OK
[   58.490658] Testing event ext4_alloc_da_blocks: OK
[   58.530625] Testing event ext4_sync_fs: OK
[   58.570527] Testing event ext4_sync_file_exit: OK
[   58.610567] Testing event ext4_sync_file_enter: OK
[   58.650563] Testing event ext4_free_blocks: OK
[   58.690572] Testing event ext4_allocate_blocks: OK
[   58.730639] Testing event ext4_request_blocks: OK
[   58.770563] Testing event ext4_mb_discard_preallocations: OK
[   58.810580] Testing event ext4_discard_preallocations: OK
[   58.850656] Testing event ext4_mb_release_group_pa: OK
[   58.890564] Testing event ext4_mb_release_inode_pa: OK
[   58.930685] Testing event ext4_mb_new_group_pa: OK
[   58.970656] Testing event ext4_mb_new_inode_pa: OK
[   59.010582] Testing event ext4_discard_blocks: OK
[   59.050564] Testing event ext4_journalled_invalidatepage: OK
[   59.090736] Testing event ext4_invalidatepage: OK
[   59.130579] Testing event ext4_releasepage: OK
[   59.170525] Testing event ext4_readpage: OK
[   59.210570] Testing event ext4_writepage: OK
[   59.250602] Testing event ext4_da_writepages_result: OK
[   59.290548] Testing event ext4_da_write_pages: OK
[   59.330590] Testing event ext4_da_writepages: OK
[   59.370527] Testing event ext4_da_write_end: OK
[   59.410616] Testing event ext4_journalled_write_end: OK
[   59.450835] Testing event ext4_write_end: OK
[   59.490595] Testing event ext4_da_write_begin: OK
[   59.530610] Testing event ext4_write_begin: OK
[   59.570582] Testing event ext4_begin_ordered_truncate: OK
[   59.610540] Testing event ext4_mark_inode_dirty: OK
[   59.650526] Testing event ext4_drop_inode: OK
[   59.690483] Testing event ext4_evict_inode: OK
[   59.730522] Testing event ext4_allocate_inode: OK
[   59.770707] Testing event ext4_request_inode: OK
[   59.810498] Testing event ext4_free_inode: OK
[   59.850496] Testing event jbd2_lock_buffer_stall: OK
[   59.890511] Testing event jbd2_write_superblock: OK
[   59.930572] Testing event jbd2_update_log_tail: OK
[   59.970511] Testing event jbd2_checkpoint_stats: OK
[   60.010569] Testing event jbd2_run_stats: OK
[   60.050569] Testing event jbd2_handle_stats: OK
[   60.090776] Testing event jbd2_handle_extend: OK
[   60.130617] Testing event jbd2_handle_start: OK
[   60.170597] Testing event jbd2_submit_inode_data: OK
[   60.210613] Testing event jbd2_end_commit: OK
[   60.250631] Testing event jbd2_drop_transaction: OK
[   60.290632] Testing event jbd2_commit_logging: OK
[   60.330637] Testing event jbd2_commit_flushing: OK
[   60.370544] Testing event jbd2_commit_locking: OK
[   60.410785] Testing event jbd2_start_commit: OK
[   60.450622] Testing event jbd2_checkpoint: OK
[   60.490640] Testing event xfs_discard_busy: OK
[   60.530656] Testing event xfs_discard_exclude: OK
[   60.570536] Testing event xfs_discard_toosmall: OK
[   60.610721] Testing event xfs_discard_extent: OK
[   60.650605] Testing event xfs_log_recover_inode_skip: OK
[   60.690669] Testing event xfs_log_recover_inode_cancel: OK
[   60.730694] Testing event xfs_log_recover_inode_recover: OK
[   60.770676] Testing event xfs_log_recover_buf_dquot_buf: OK
[   60.810634] Testing event xfs_log_recover_buf_reg_buf: OK
[   60.850593] Testing event xfs_log_recover_buf_inode_buf: OK
[   60.890682] Testing event xfs_log_recover_buf_recover: OK
[   60.930661] Testing event xfs_log_recover_buf_cancel_ref_inc: OK
[   60.970531] Testing event xfs_log_recover_buf_cancel_add: OK
[   61.010532] Testing event xfs_log_recover_buf_cancel: OK
[   61.050536] Testing event xfs_log_recover_buf_not_cancel: OK
[   61.090602] Testing event xfs_log_recover_item_recover: OK
[   61.130596] Testing event xfs_log_recover_item_reorder_tail: OK
[   61.170567] Testing event xfs_log_recover_item_reorder_head: OK
[   61.210678] Testing event xfs_log_recover_item_add_cont: OK
[   61.250670] Testing event xfs_log_recover_item_add: OK
[   61.290615] Testing event xfs_swap_extent_after: OK
[   61.330660] Testing event xfs_swap_extent_before: OK
[   61.370639] Testing event xfs_dir2_leafn_moveents: OK
[   61.410584] Testing event xfs_dir2_shrink_inode: OK
[   61.450726] Testing event xfs_dir2_grow_inode: OK
[   61.490655] Testing event xfs_dir2_leafn_remove: OK
[   61.530581] Testing event xfs_dir2_leafn_add: OK
[   61.570647] Testing event xfs_da_path_shift: OK
[   61.610636] Testing event xfs_da_fixhashpath: OK
[   61.650550] Testing event xfs_da_shrink_inode: OK
[   61.690642] Testing event xfs_da_grow_inode: OK
[   61.730625] Testing event xfs_da_swap_lastblock: OK
[   61.770746] Testing event xfs_da_node_toosmall: OK
[   61.810645] Testing event xfs_da_node_unbalance: OK
[   61.850601] Testing event xfs_da_node_rebalance: OK
[   61.890660] Testing event xfs_da_node_remove: OK
[   61.930536] Testing event xfs_da_node_split: OK
[   61.970530] Testing event xfs_da_node_create: OK
[   62.010635] Testing event xfs_da_node_add: OK
[   62.050655] Testing event xfs_da_root_join: OK
[   62.090543] Testing event xfs_da_root_split: OK
[   62.130666] Testing event xfs_da_unlink_forward: OK
[   62.170685] Testing event xfs_da_unlink_back: OK
[   62.210660] Testing event xfs_da_link_after: OK
[   62.250591] Testing event xfs_da_link_before: OK
[   62.290521] Testing event xfs_da_join: OK
[   62.330517] Testing event xfs_da_split: OK
[   62.370572] Testing event xfs_attr_rmtval_remove: OK
[   62.410549] Testing event xfs_attr_rmtval_set: OK
[   62.450600] Testing event xfs_attr_rmtval_get: OK
[   62.490616] Testing event xfs_attr_refillstate: OK
[   62.530505] Testing event xfs_attr_fillstate: OK
[   62.570500] Testing event xfs_attr_node_removename: OK
[   62.610564] Testing event xfs_attr_node_replace: OK
[   62.650520] Testing event xfs_attr_node_lookup: OK
[   62.690462] Testing event xfs_attr_node_get: OK
[   62.730505] Testing event xfs_attr_node_addname: OK
[   62.770569] Testing event xfs_attr_leaf_toosmall: OK
[   62.810557] Testing event xfs_attr_leaf_unbalance: OK
[   62.850515] Testing event xfs_attr_leaf_rebalance: OK
[   62.890519] Testing event xfs_attr_leaf_to_node: OK
[   62.930695] Testing event xfs_attr_leaf_to_sf: OK
[   62.970669] Testing event xfs_attr_leaf_flipflags: OK
[   63.010566] Testing event xfs_attr_leaf_setflag: OK
[   63.050548] Testing event xfs_attr_leaf_clearflag: OK
[   63.090588] Testing event xfs_attr_leaf_split_after: OK
[   63.130552] Testing event xfs_attr_leaf_split_before: OK
[   63.170544] Testing event xfs_attr_leaf_split: OK
[   63.210589] Testing event xfs_attr_leaf_removename: OK
[   63.250551] Testing event xfs_attr_leaf_remove: OK
[   63.290540] Testing event xfs_attr_leaf_replace: OK
[   63.330528] Testing event xfs_attr_leaf_lookup: OK
[   63.370740] Testing event xfs_attr_leaf_get: OK
[   63.410598] Testing event xfs_attr_leaf_compact: OK
[   63.450614] Testing event xfs_attr_leaf_create: OK
[   63.490639] Testing event xfs_attr_leaf_addname: OK
[   63.530655] Testing event xfs_attr_leaf_add_work: OK
[   63.570600] Testing event xfs_attr_leaf_add_new: OK
[   63.610520] Testing event xfs_attr_leaf_add_old: OK
[   63.650513] Testing event xfs_attr_leaf_add: OK
[   63.690516] Testing event xfs_attr_sf_to_leaf: OK
[   63.730522] Testing event xfs_attr_sf_removename: OK
[   63.770499] Testing event xfs_attr_sf_remove: OK
[   63.810631] Testing event xfs_attr_sf_lookup: OK
[   63.850641] Testing event xfs_attr_sf_create: OK
[   63.890744] Testing event xfs_attr_sf_addname: OK
[   63.930570] Testing event xfs_attr_sf_add: OK
[   63.970549] Testing event xfs_dir2_node_to_leaf: OK
[   64.010526] Testing event xfs_dir2_node_removename: OK
[   64.050581] Testing event xfs_dir2_node_replace: OK
[   64.090513] Testing event xfs_dir2_node_lookup: OK
[   64.130560] Testing event xfs_dir2_node_addname: OK
[   64.170673] Testing event xfs_dir2_leaf_to_node: OK
[   64.210569] Testing event xfs_dir2_leaf_to_block: OK
[   64.250708] Testing event xfs_dir2_leaf_removename: OK
[   64.290800] Testing event xfs_dir2_leaf_replace: OK
[   64.330719] Testing event xfs_dir2_leaf_lookup: OK
[   64.370825] Testing event xfs_dir2_leaf_addname: OK
[   64.410654] Testing event xfs_dir2_block_to_leaf: OK
[   64.450613] Testing event xfs_dir2_block_to_sf: OK
[   64.490785] Testing event xfs_dir2_block_removename: OK
[   64.530783] Testing event xfs_dir2_block_replace: OK
[   64.570778] Testing event xfs_dir2_block_lookup: OK
[   64.610841] Testing event xfs_dir2_block_addname: OK
[   64.650855] Testing event xfs_dir2_sf_to_block: OK
[   64.690655] Testing event xfs_dir2_sf_toino8: OK
[   64.730643] Testing event xfs_dir2_sf_toino4: OK
[   64.770615] Testing event xfs_dir2_sf_removename: OK
[   64.810648] Testing event xfs_dir2_sf_replace: OK
[   64.850686] Testing event xfs_dir2_sf_lookup: OK
[   64.890660] Testing event xfs_dir2_sf_create: OK
[   64.930663] Testing event xfs_dir2_sf_addname: OK
[   64.970602] Testing event xfs_alloc_vextent_allfailed: OK
[   65.010641] Testing event xfs_alloc_vextent_loopfailed: OK
[   65.050616] Testing event xfs_alloc_vextent_noagbp: OK
[   65.090638] Testing event xfs_alloc_vextent_nofix: OK
[   65.130674] Testing event xfs_alloc_vextent_badargs: OK
[   65.170666] Testing event xfs_alloc_small_error: OK
[   65.210610] Testing event xfs_alloc_small_done: OK
[   65.250656] Testing event xfs_alloc_small_notenough: OK
[   65.290589] Testing event xfs_alloc_small_freelist: OK
[   65.330705] Testing event xfs_alloc_size_busy: OK
[   65.370759] Testing event xfs_alloc_size_error: OK
[   65.410767] Testing event xfs_alloc_size_done: OK
[   65.450721] Testing event xfs_alloc_size_nominleft: OK
[   65.490721] Testing event xfs_alloc_size_noentry: OK
[   65.530691] Testing event xfs_alloc_size_neither: OK
[   65.570656] Testing event xfs_alloc_near_busy: OK
[   65.610515] Testing event xfs_alloc_near_noentry: OK
[   65.650538] Testing event xfs_alloc_near_error: OK
[   65.700509] Testing event xfs_alloc_near_lesser: OK
[   65.740591] Testing event xfs_alloc_near_greater: OK
[   65.780847] Testing event xfs_alloc_near_first: OK
[   65.820995] Testing event xfs_alloc_near_nominleft: OK
[   65.861301] Testing event xfs_alloc_exact_error: OK
[   65.900604] Testing event xfs_alloc_exact_notfound: OK
[   65.940619] Testing event xfs_alloc_exact_done: OK
[   65.980729] Testing event xfs_free_extent: OK
[   66.020604] Testing event xfs_agf: OK
[   66.060606] Testing event xfs_trans_commit_lsn: OK
[   66.100498] Testing event xfs_extent_busy_trim: OK
[   66.140609] Testing event xfs_extent_busy_clear: OK
[   66.180677] Testing event xfs_extent_busy_reuse: OK
[   66.220698] Testing event xfs_extent_busy_force: OK
[   66.260734] Testing event xfs_extent_busy_enomem: OK
[   66.300674] Testing event xfs_extent_busy: OK
[   66.340647] Testing event xfs_bunmap: OK
[   66.380834] Testing event xfs_pagecache_inval: OK
[   66.420500] Testing event xfs_itruncate_extents_end: OK
[   66.460573] Testing event xfs_itruncate_extents_start: OK
[   66.500559] Testing event xfs_setfilesize: OK
[   66.540535] Testing event xfs_get_blocks_notfound: OK
[   66.580812] Testing event xfs_unwritten_convert: OK
[   66.620760] Testing event xfs_delalloc_enospc: OK
[   66.660747] Testing event xfs_get_blocks_alloc: OK
[   66.700704] Testing event xfs_get_blocks_found: OK
[   66.740732] Testing event xfs_map_blocks_alloc: OK
[   66.780913] Testing event xfs_map_blocks_found: OK
[   66.820982] Testing event xfs_invalidatepage: OK
[   66.860632] Testing event xfs_releasepage: OK
[   66.901094] Testing event xfs_writepage: OK
[   66.940793] Testing event xfs_file_splice_write: OK
[   66.980764] Testing event xfs_file_splice_read: OK
[   67.020741] Testing event xfs_file_direct_write: OK
[   67.060793] Testing event xfs_file_buffered_write: OK
[   67.100627] Testing event xfs_file_read: OK
[   67.140658] Testing event xfs_ail_flushing: OK
[   67.180731] Testing event xfs_ail_locked: OK
[   67.220819] Testing event xfs_ail_pinned: OK
[   67.260753] Testing event xfs_ail_push: OK
[   67.300655] Testing event xfs_log_force: OK
[   67.340847] Testing event xfs_log_ungrant_sub: OK
[   67.380745] Testing event xfs_log_ungrant_exit: OK
[   67.420680] Testing event xfs_log_ungrant_enter: OK
[   67.460745] Testing event xfs_log_regrant_reserve_sub: OK
[   67.500739] Testing event xfs_log_regrant_reserve_exit: OK
[   67.540671] Testing event xfs_log_regrant_reserve_enter: OK
[   67.580748] Testing event xfs_log_regrant_exit: OK
[   67.620716] Testing event xfs_log_regrant: OK
[   67.660703] Testing event xfs_log_reserve_exit: OK
[   67.700661] Testing event xfs_log_reserve: OK
[   67.740675] Testing event xfs_log_grant_wake_up: OK
[   67.780734] Testing event xfs_log_grant_wake: OK
[   67.820698] Testing event xfs_log_grant_sleep: OK
[   67.860602] Testing event xfs_log_umount_write: OK
[   67.900856] Testing event xfs_log_done_perm: OK
[   67.940754] Testing event xfs_log_done_nonperm: OK
[   67.980728] Testing event xfs_dqflush_done: OK
[   68.020696] Testing event xfs_dqflush_force: OK
[   68.060521] Testing event xfs_dqflush: OK
[   68.100621] Testing event xfs_dqrele: OK
[   68.140614] Testing event xfs_dqput_free: OK
[   68.180537] Testing event xfs_dqput_wait: OK
[   68.220655] Testing event xfs_dqput: OK
[   68.260620] Testing event xfs_dqget_dup: OK
[   68.301749] Testing event xfs_dqget_freeing: OK
[   68.340570] Testing event xfs_dqget_miss: OK
[   68.380697] Testing event xfs_dqget_hit: OK
[   68.420783] Testing event xfs_dqread_fail: OK
[   68.460639] Testing event xfs_dqread: OK
[   68.500680] Testing event xfs_dqtobp_read: OK
[   68.540609] Testing event xfs_dqalloc: OK
[   68.581044] Testing event xfs_dqattach_get: OK
[   68.620912] Testing event xfs_dqattach_found: OK
[   68.660682] Testing event xfs_dqreclaim_done: OK
[   68.700673] Testing event xfs_dqreclaim_busy: OK
[   68.740710] Testing event xfs_dqreclaim_dirty: OK
[   68.780671] Testing event xfs_dqreclaim_want: OK
[   68.820712] Testing event xfs_dqadjust: OK
[   68.860710] Testing event xfs_rename: OK
[   68.900697] Testing event xfs_symlink: OK
[   68.940699] Testing event xfs_create: OK
[   68.980707] Testing event xfs_lookup: OK
[   69.020726] Testing event xfs_link: OK
[   69.060696] Testing event xfs_remove: OK
[   69.100782] Testing event xfs_inode_unpin_nowait: OK
[   69.140878] Testing event xfs_inode_unpin: OK
[   69.180615] Testing event xfs_inode_pin: OK
[   69.220743] Testing event xfs_irele: OK
[   69.261227] Testing event xfs_ihold: OK
[   69.300727] Testing event xfs_iomap_prealloc_size: OK
[   69.340769] Testing event xfs_inode_free_eofblocks_invalid: OK
[   69.380760] Testing event xfs_inode_clear_eofblocks_tag: OK
[   69.420783] Testing event xfs_inode_set_eofblocks_tag: OK
[   69.460799] Testing event xfs_dquot_dqdetach: OK
[   69.500747] Testing event xfs_dquot_dqalloc: OK
[   69.540591] Testing event xfs_update_time: OK
[   69.580802] Testing event xfs_evict_inode: OK
[   69.620784] Testing event xfs_destroy_inode: OK
[   69.661647] Testing event xfs_file_fsync: OK
[   69.700667] Testing event xfs_dir_fsync: OK
[   69.740610] Testing event xfs_ioctl_setattr: OK
[   69.780906] Testing event xfs_file_compat_ioctl: OK
[   69.820858] Testing event xfs_file_ioctl: OK
[   69.860709] Testing event xfs_vm_bmap: OK
[   69.901314] Testing event xfs_readdir: OK
[   69.940951] Testing event xfs_free_file_space: OK
[   69.980814] Testing event xfs_alloc_file_space: OK
[   70.020751] Testing event xfs_readlink: OK
[   70.060758] Testing event xfs_setattr: OK
[   70.100803] Testing event xfs_getattr: OK
[   70.140742] Testing event xfs_iget_miss: OK
[   70.180738] Testing event xfs_iget_hit: OK
[   70.220844] Testing event xfs_iget_reclaim_fail: OK
[   70.260759] Testing event xfs_iget_reclaim: OK
[   70.300798] Testing event xfs_iget_skip: OK
[   70.340653] Testing event xfs_iunlock: OK
[   70.380740] Testing event xfs_ilock_demote: OK
[   70.420790] Testing event xfs_ilock_nowait: OK
[   70.460832] Testing event xfs_ilock: OK
[   70.500900] Testing event xfs_trans_binval: OK
[   70.540982] Testing event xfs_trans_bhold_release: OK
[   70.580626] Testing event xfs_trans_bhold: OK
[   70.620592] Testing event xfs_trans_bjoin: OK
[   70.661025] Testing event xfs_trans_brelse: OK
[   70.700986] Testing event xfs_trans_log_buf: OK
[   70.740682] Testing event xfs_trans_read_buf_recur: OK
[   70.780735] Testing event xfs_trans_read_buf: OK
[   70.820794] Testing event xfs_trans_getsb_recur: OK
[   70.860651] Testing event xfs_trans_getsb: OK
[   70.900633] Testing event xfs_trans_get_buf_recur: OK
[   70.940720] Testing event xfs_trans_get_buf: OK
[   70.980686] Testing event xfs_buf_item_push: OK
[   71.020637] Testing event xfs_buf_item_committed: OK
[   71.060656] Testing event xfs_buf_item_unlock_stale: OK
[   71.100690] Testing event xfs_buf_item_unlock: OK
[   71.140644] Testing event xfs_buf_item_unpin_stale: OK
[   71.180719] Testing event xfs_buf_item_unpin: OK
[   71.220693] Testing event xfs_buf_item_pin: OK
[   71.260794] Testing event xfs_buf_item_format_stale: OK
[   71.300672] Testing event xfs_buf_item_format: OK
[   71.340665] Testing event xfs_buf_item_size_stale: OK
[   71.380736] Testing event xfs_buf_item_size: OK
[   71.420727] Testing event xfs_buf_ioerror: OK
[   71.460779] Testing event xfs_buf_read: OK
[   71.500844] Testing event xfs_buf_get: OK
[   71.540775] Testing event xfs_buf_find: OK
[   71.580745] Testing event xfs_inode_item_push: OK
[   71.620752] Testing event xfs_reset_dqcounts: OK
[   71.660765] Testing event xfs_da_btree_corrupt: OK
[   71.700568] Testing event xfs_btree_corrupt: OK
[   71.740888] Testing event xfs_trans_read_buf_shut: OK
[   71.780697] Testing event xfs_trans_read_buf_io: OK
[   71.820683] Testing event xfs_buf_wait_buftarg: OK
[   71.860671] Testing event xfs_buf_error_relse: OK
[   71.900632] Testing event xfs_buf_item_iodone_async: OK
[   71.940956] Testing event xfs_buf_item_iodone: OK
[   71.980858] Testing event xfs_buf_item_relse: OK
[   72.020827] Testing event xfs_bdstrat_shut: OK
[   72.060991] Testing event xfs_buf_get_uncached: OK
[   72.100644] Testing event xfs_buf_delwri_split: OK
[   72.140757] Testing event xfs_buf_delwri_queued: OK
[   72.181598] Testing event xfs_buf_delwri_queue: OK
[   72.222650] Testing event xfs_buf_iowait_done: OK
[   72.260743] Testing event xfs_buf_iowait: OK
[   72.300751] Testing event xfs_buf_unlock: OK
[   72.340753] Testing event xfs_buf_trylock: OK
[   72.380592] Testing event xfs_buf_lock_done: OK
[   72.420753] Testing event xfs_buf_lock: OK
[   72.460776] Testing event xfs_buf_bawrite: OK
[   72.500833] Testing event xfs_buf_iorequest: OK
[   72.540757] Testing event xfs_buf_iodone: OK
[   72.580759] Testing event xfs_buf_rele: OK
[   72.620961] Testing event xfs_buf_hold: OK
[   72.660764] Testing event xfs_buf_free: OK
[   72.700893] Testing event xfs_buf_init: OK
[   72.740688] Testing event xfs_extlist: OK
[   72.780729] Testing event xfs_bmap_post_update: OK
[   72.821710] Testing event xfs_bmap_pre_update: OK
[   72.861598] Testing event xfs_iext_remove: OK
[   72.900699] Testing event xfs_iext_insert: OK
[   72.940685] Testing event xfs_attr_list_node_descend: OK
[   72.980890] Testing event xfs_perag_clear_eofblocks: OK
[   73.021302] Testing event xfs_perag_set_eofblocks: OK
[   73.061004] Testing event xfs_perag_clear_reclaim: OK
[   73.100912] Testing event xfs_perag_set_reclaim: OK
[   73.140918] Testing event xfs_perag_put: OK
[   73.180958] Testing event xfs_perag_get_tag: OK
[   73.220909] Testing event xfs_perag_get: OK
[   73.261614] Testing event xfs_attr_node_list: OK
[   73.300834] Testing event xfs_attr_leaf_list: OK
[   73.340876] Testing event xfs_attr_list_notfound: OK
[   73.380748] Testing event xfs_attr_list_wrong_blk: OK
[   73.420800] Testing event xfs_attr_list_add: OK
[   73.460796] Testing event xfs_attr_list_full: OK
[   73.500720] Testing event xfs_attr_list_leaf_end: OK
[   73.540704] Testing event xfs_attr_list_leaf: OK
[   73.580743] Testing event xfs_attr_list_sf_all: OK
[   73.620849] Testing event xfs_attr_list_sf: OK
[   73.660831] Testing event free_extent_state: OK
[   73.700694] Testing event alloc_extent_state: OK
[   73.740682] Testing event btrfs_setup_cluster: OK
[   73.780724] Testing event btrfs_failed_cluster_setup: OK
[   73.820723] Testing event btrfs_find_cluster: OK
[   73.860687] Testing event btrfs_reserve_extent_cluster: OK
[   73.900713] Testing event btrfs_reserve_extent: OK
[   73.940697] Testing event find_free_extent: OK
[   73.980671] Testing event btrfs_reserved_extent_free: OK
[   74.020691] Testing event btrfs_reserved_extent_alloc: OK
[   74.060731] Testing event btrfs_space_reservation: OK
[   74.101426] Testing event btrfs_cow_block: OK
[   74.140727] Testing event btrfs_chunk_free: OK
[   74.180676] Testing event btrfs_chunk_alloc: OK
[   74.220709] Testing event btrfs_delayed_ref_head: OK
[   74.260737] Testing event btrfs_delayed_data_ref: OK
[   74.300707] Testing event btrfs_delayed_tree_ref: OK
[   74.341529] Testing event btrfs_sync_fs: OK
[   74.381580] Testing event btrfs_sync_file: OK
[   74.420724] Testing event btrfs_writepage_end_io_hook: OK
[   74.460691] Testing event __extent_writepage: OK
[   74.500662] Testing event btrfs_ordered_extent_put: OK
[   74.540637] Testing event btrfs_ordered_extent_start: OK
[   74.580683] Testing event btrfs_ordered_extent_remove: OK
[   74.620657] Testing event btrfs_ordered_extent_add: OK
[   74.660640] Testing event btrfs_get_extent: OK
[   74.700657] Testing event btrfs_inode_evict: OK
[   74.740653] Testing event btrfs_inode_request: OK
[   74.780637] Testing event btrfs_inode_new: OK
[   74.820639] Testing event btrfs_transaction_commit: OK
[   74.860712] Testing event block_rq_remap: OK
[   74.900701] Testing event block_bio_remap: OK
[   74.940823] Testing event block_split: OK
[   74.980704] Testing event block_unplug: OK
[   75.020737] Testing event block_plug: OK
[   75.060755] Testing event block_sleeprq: OK
[   75.100683] Testing event block_getrq: OK
[   75.140735] Testing event block_bio_queue: OK
[   75.180782] Testing event block_bio_frontmerge: OK
[   75.220853] Testing event block_bio_backmerge: OK
[   75.260837] Testing event block_bio_complete: OK
[   75.301044] Testing event block_bio_bounce: OK
[   75.340920] Testing event block_rq_issue: OK
[   75.380817] Testing event block_rq_insert: OK
[   75.420681] Testing event block_rq_complete: OK
[   75.460634] Testing event block_rq_requeue: OK
[   75.500634] Testing event block_rq_abort: OK
[   75.540664] Testing event block_dirty_buffer: OK
[   75.580687] Testing event block_touch_buffer: OK
[   75.620664] Testing event gpio_value: OK
[   75.660730] Testing event gpio_direction: OK
[   75.700769] Testing event extract_entropy_user: OK
[   75.740660] Testing event extract_entropy: OK
[   75.780693] Testing event get_random_bytes: OK
[   75.820733] Testing event credit_entropy_bits: OK
[   75.860678] Testing event mix_pool_bytes_nolock: OK
[   75.900644] Testing event mix_pool_bytes: OK
[   75.940685] Testing event regmap_async_complete_done: OK
[   75.980685] Testing event regmap_async_complete_start: OK
[   76.020642] Testing event regmap_async_io_complete: OK
[   76.060673] Testing event regmap_async_write_start: OK
[   76.100658] Testing event regmap_cache_bypass: OK
[   76.140640] Testing event regmap_cache_only: OK
[   76.180609] Testing event regcache_sync: OK
[   76.220763] Testing event regmap_hw_write_done: OK
[   76.260685] Testing event regmap_hw_write_start: OK
[   76.300654] Testing event regmap_hw_read_done: OK
[   76.340665] Testing event regmap_hw_read_start: OK
[   76.380655] Testing event regmap_reg_read_cache: OK
[   76.420647] Testing event regmap_reg_read: OK
[   76.460668] Testing event regmap_reg_write: OK
[   76.500698] Testing event bcache_gc_end: OK
[   76.540670] Testing event bcache_gc_start: OK
[   76.580724] Testing event bcache_cache_insert: OK
[   76.620719] Testing event bcache_journal_write: OK
[   76.660683] Testing event bcache_read_moving: OK
[   76.700643] Testing event bcache_write_moving: OK
[   76.740669] Testing event bcache_read_dirty: OK
[   76.780673] Testing event bcache_write_dirty: OK
[   76.820660] Testing event bcache_btree_write: OK
[   76.860696] Testing event bcache_btree_read: OK
[   76.900660] Testing event bcache_write_skip: OK
[   76.940714] Testing event bcache_writeback: OK
[   76.980664] Testing event bcache_writethrough: OK
[   77.020698] Testing event bcache_read_retry: OK
[   77.060704] Testing event bcache_cache_miss: OK
[   77.100706] Testing event bcache_cache_hit: OK
[   77.140711] Testing event bcache_passthrough: OK
[   77.180645] Testing event bcache_request_end: OK
[   77.220665] Testing event bcache_request_start: OK
[   77.260740] Testing event udp_fail_queue_rcv_skb: OK
[   77.300610] Testing event sock_exceed_buf_limit: OK
[   77.340636] Testing event sock_rcvqueue_full: OK
[   77.380612] Testing event napi_poll: OK
[   77.420731] Testing event netif_rx: OK
[   77.460694] Testing event netif_receive_skb: OK
[   77.500621] Testing event net_dev_queue: OK
[   77.540678] Testing event net_dev_xmit: OK
[   77.580677] Testing event skb_copy_datagram_iovec: OK
[   77.620684] Testing event consume_skb: OK
[   77.660712] Testing event kfree_skb: OK
[   77.700740] Testing event cfg80211_ft_event: OK
[   77.740710] Testing event cfg80211_report_wowlan_wakeup: OK
[   77.780734] Testing event cfg80211_return_u32: OK
[   77.820699] Testing event cfg80211_return_uint: OK
[   77.860668] Testing event cfg80211_return_bss: OK
[   77.900769] Testing event cfg80211_inform_bss_frame: OK
[   77.940719] Testing event cfg80211_get_bss: OK
[   77.980666] Testing event cfg80211_sched_scan_stopped: OK
[   78.020695] Testing event cfg80211_sched_scan_results: OK
[   78.060720] Testing event cfg80211_scan_done: OK
[   78.100644] Testing event cfg80211_tdls_oper_request: OK
[   78.140677] Testing event cfg80211_report_obss_beacon: OK
[   78.180640] Testing event cfg80211_pmksa_candidate_notify: OK
[   78.220492] Testing event cfg80211_gtk_rekey_notify: OK
[   78.260496] Testing event cfg80211_cqm_pktloss_notify: OK
[   78.300490] Testing event cfg80211_probe_status: OK
[   78.340489] Testing event cfg80211_rx_unexpected_4addr_frame: OK
[   78.380691] Testing event cfg80211_rx_spurious_frame: OK
[   78.420700] Testing event cfg80211_ibss_joined: OK
[   78.460515] Testing event cfg80211_cac_event: OK
[   78.500665] Testing event cfg80211_radar_event: OK
[   78.540679] Testing event cfg80211_ch_switch_notify: OK
[   78.580663] Testing event cfg80211_chandef_dfs_required: OK
[   78.620645] Testing event cfg80211_reg_can_beacon: OK
[   78.660668] Testing event cfg80211_cqm_rssi_notify: OK
[   78.700652] Testing event cfg80211_mgmt_tx_status: OK
[   78.740695] Testing event cfg80211_rx_mgmt: OK
[   78.780671] Testing event cfg80211_del_sta: OK
[   78.820651] Testing event cfg80211_new_sta: OK
[   78.860691] Testing event cfg80211_ready_on_channel_expired: OK
[   78.900653] Testing event cfg80211_ready_on_channel: OK
[   78.940544] Testing event cfg80211_michael_mic_failure: OK
[   78.980496] Testing event cfg80211_send_assoc_timeout: OK
[   79.020617] Testing event cfg80211_send_auth_timeout: OK
[   79.060645] Testing event cfg80211_send_unprot_disassoc: OK
[   79.100491] Testing event cfg80211_send_unprot_deauth: OK
[   79.140651] Testing event __cfg80211_send_disassoc: OK
[   79.180703] Testing event __cfg80211_send_deauth: OK
[   79.220641] Testing event cfg80211_send_rx_assoc: OK
[   79.260620] Testing event cfg80211_send_rx_auth: OK
[   79.300620] Testing event cfg80211_notify_new_peer_candidate: OK
[   79.340523] Testing event cfg80211_return_bool: OK
[   79.380674] Testing event rdev_crit_proto_stop: OK
[   79.420593] Testing event rdev_crit_proto_start: OK
[   79.460555] Testing event rdev_update_ft_ies: OK
[   79.500604] Testing event rdev_set_mac_acl: OK
[   79.540726] Testing event rdev_stop_p2p_device: OK
[   79.580654] Testing event rdev_start_p2p_device: OK
[   79.620706] Testing event rdev_return_chandef: OK
[   79.660642] Testing event rdev_get_channel: OK
[   79.700660] Testing event rdev_get_et_strings: OK
[   79.740718] Testing event rdev_get_et_sset_count: OK
[   79.780589] Testing event rdev_set_noack_map: OK
[   79.820542] Testing event rdev_mgmt_tx: OK
[   79.860615] Testing event rdev_cancel_remain_on_channel: OK
[   79.900643] Testing event rdev_return_int_cookie: OK
[   79.940736] Testing event rdev_remain_on_channel: OK
[   79.980712] Testing event rdev_del_pmksa: OK
[   80.020655] Testing event rdev_set_pmksa: OK
[   80.060682] Testing event rdev_probe_client: OK
[   80.100710] Testing event rdev_tdls_oper: OK
[   80.140698] Testing event rdev_return_int_survey_info: OK
[   80.180685] Testing event rdev_dump_survey: OK
[   80.220768] Testing event rdev_tdls_mgmt: OK
[   80.260742] Testing event rdev_sched_scan_start: OK
[   80.300745] Testing event rdev_set_antenna: OK
[   80.340751] Testing event rdev_set_ringparam: OK
[   80.380695] Testing event rdev_return_void_tx_rx: OK
[   80.420727] Testing event rdev_return_int_tx_rx: OK
[   80.460571] Testing event rdev_mgmt_frame_register: OK
[   80.500629] Testing event rdev_set_bitrate_mask: OK
[   80.540602] Testing event rdev_return_int_int: OK
[   80.580564] Testing event rdev_set_tx_power: OK
[   80.620565] Testing event rdev_get_tx_power: OK
[   80.660521] Testing event rdev_set_wiphy_params: OK
[   80.700535] Testing event rdev_join_ibss: OK
[   80.740592] Testing event rdev_disconnect: OK
[   80.780596] Testing event rdev_set_cqm_txe_config: OK
[   80.820520] Testing event rdev_set_cqm_rssi_config: OK
[   80.860486] Testing event rdev_connect: OK
[   80.900534] Testing event rdev_set_power_mgmt: OK
[   80.940557] Testing event rdev_mgmt_tx_cancel_wait: OK
[   80.980498] Testing event rdev_disassoc: OK
[   81.020511] Testing event rdev_deauth: OK
[   81.060555] Testing event rdev_assoc: OK
[   81.100523] Testing event rdev_auth: OK
[   81.140584] Testing event rdev_set_monitor_channel: OK
[   81.180525] Testing event rdev_libertas_set_mesh_channel: OK
[   81.220613] Testing event rdev_set_txq_params: OK
[   81.260514] Testing event rdev_change_bss: OK
[   81.300522] Testing event rdev_join_mesh: OK
[   81.340512] Testing event rdev_update_mesh_config: OK
[   81.380540] Testing event rdev_return_int_mesh_config: OK
[   81.420518] Testing event rdev_return_int_mpath_info: OK
[   81.460619] Testing event rdev_dump_mpath: OK
[   81.500520] Testing event rdev_get_mpath: OK
[   81.540553] Testing event rdev_change_mpath: OK
[   81.580549] Testing event rdev_add_mpath: OK
[   81.620593] Testing event rdev_return_int_station_info: OK
[   81.660637] Testing event rdev_dump_station: OK
[   81.700537] Testing event rdev_set_wds_peer: OK
[   81.740664] Testing event rdev_del_mpath: OK
[   81.780500] Testing event rdev_get_station: OK
[   81.820585] Testing event rdev_del_station: OK
[   81.860536] Testing event rdev_change_station: OK
[   81.900531] Testing event rdev_add_station: OK
[   81.940552] Testing event rdev_flush_pmksa: OK
[   81.980521] Testing event rdev_leave_ibss: OK
[   82.020512] Testing event rdev_leave_mesh: OK
[   82.060548] Testing event rdev_get_mesh_config: OK
[   82.100536] Testing event rdev_set_rekey_data: OK
[   82.140536] Testing event rdev_sched_scan_stop: OK
[   82.180574] Testing event rdev_get_et_stats: OK
[   82.220519] Testing event rdev_stop_ap: OK
[   82.260577] Testing event rdev_change_beacon: OK
[   82.300531] Testing event rdev_start_ap: OK
[   82.340531] Testing event rdev_set_default_mgmt_key: OK
[   82.380558] Testing event rdev_set_default_key: OK
[   82.420533] Testing event rdev_del_key: OK
[   82.460613] Testing event rdev_get_key: OK
[   82.500513] Testing event rdev_add_key: OK
[   82.540742] Testing event rdev_change_virtual_intf: OK
[   82.580565] Testing event rdev_del_virtual_intf: OK
[   82.620734] Testing event rdev_return_wdev: OK
[   82.660589] Testing event rdev_add_virtual_intf: OK
[   82.700572] Testing event rdev_set_wakeup: OK
[   82.740614] Testing event rdev_rfkill_poll: OK
[   82.780565] Testing event rdev_get_antenna: OK
[   82.820641] Testing event rdev_get_ringparam: OK
[   82.860537] Testing event rdev_return_void: OK
[   82.900745] Testing event rdev_resume: OK
[   82.940508] Testing event rdev_scan: OK
[   82.980557] Testing event rdev_return_int: OK
[   83.022057] Testing event rdev_suspend: OK
[   83.060500] Testing event api_radar_detected: OK
[   83.100563] Testing event drv_set_default_unicast_key: OK
[   83.140636] Testing event stop_queue: OK
[   83.180580] Testing event wake_queue: OK
[   83.220510] Testing event api_eosp: OK
[   83.260486] Testing event api_enable_rssi_reports: OK
[   83.300488] Testing event api_gtk_rekey_notify: OK
[   83.340577] Testing event api_remain_on_channel_expired: OK
[   83.380533] Testing event api_ready_on_channel: OK
[   83.420521] Testing event api_chswitch_done: OK
[   83.460599] Testing event api_sta_block_awake: OK
[   83.500523] Testing event api_sched_scan_stopped: OK
[   83.540696] Testing event api_sched_scan_results: OK
[   83.580567] Testing event api_scan_completed: OK
[   83.620548] Testing event api_cqm_rssi_notify: OK
[   83.660715] Testing event api_connection_loss: OK
[   83.700523] Testing event api_beacon_loss: OK
[   83.740551] Testing event api_restart_hw: OK
[   83.780569] Testing event api_stop_tx_ba_cb: OK
[   83.820561] Testing event api_stop_tx_ba_session: OK
[   83.860530] Testing event api_start_tx_ba_cb: OK
[   83.900597] Testing event api_start_tx_ba_session: OK
[   83.940562] Testing event drv_restart_complete: OK
[   83.980548] Testing event drv_stop_ap: OK
[   84.020621] Testing event drv_start_ap: OK
[   84.060570] Testing event drv_unassign_vif_chanctx: OK
[   84.100548] Testing event drv_assign_vif_chanctx: OK
[   84.140602] Testing event drv_change_chanctx: OK
[   84.180620] Testing event drv_remove_chanctx: OK
[   84.220606] Testing event drv_add_chanctx: OK
[   84.260518] Testing event drv_mgd_prepare_tx: OK
[   84.300628] Testing event drv_get_rssi: OK
[   84.340610] Testing event drv_allow_buffered_frames: OK
[   84.380502] Testing event drv_release_buffered_frames: OK
[   84.420518] Testing event drv_rssi_callback: OK
[   84.460480] Testing event drv_set_rekey_data: OK
[   84.500512] Testing event drv_set_bitrate_mask: OK
[   84.540598] Testing event drv_offchannel_tx_cancel_wait: OK
[   84.580612] Testing event drv_tx_frames_pending: OK
[   84.620466] Testing event drv_get_ringparam: OK
[   84.660473] Testing event drv_set_ringparam: OK
[   84.700481] Testing event drv_cancel_remain_on_channel: OK
[   84.740494] Testing event drv_remain_on_channel: OK
[   84.780490] Testing event drv_get_antenna: OK
[   84.820427] Testing event drv_set_antenna: OK
[   84.860465] Testing event drv_channel_switch: OK
[   84.900454] Testing event drv_flush: OK
[   84.940514] Testing event drv_get_survey: OK
[   84.982172] Testing event drv_ampdu_action: OK
[   85.021175] Testing event drv_tx_last_beacon: OK
[   85.060680] Testing event drv_reset_tsf: OK
[   85.100896] Testing event drv_set_tsf: OK
[   85.140594] Testing event drv_get_tsf: OK
[   85.180644] Testing event drv_conf_tx: OK
[   85.220843] Testing event drv_sta_remove: OK
[   85.260893] Testing event drv_sta_add: OK
[   85.300881] Testing event drv_sta_rc_update: OK
[   85.341008] Testing event drv_sta_state: OK
[   85.380995] Testing event drv_sta_notify: OK
[   85.420833] Testing event drv_set_coverage_class: OK
[   85.460773] Testing event drv_set_rts_threshold: OK
[   85.500790] Testing event drv_set_frag_threshold: OK
[   85.540890] Testing event drv_get_tkip_seq: OK
[   85.580786] Testing event drv_get_stats: OK
[   85.620856] Testing event drv_sw_scan_complete: OK
[   85.660825] Testing event drv_sw_scan_start: OK
[   85.700830] Testing event drv_sched_scan_stop: OK
[   85.740811] Testing event drv_sched_scan_start: OK
[   85.780777] Testing event drv_cancel_hw_scan: OK
[   85.820791] Testing event drv_hw_scan: OK
[   85.860807] Testing event drv_update_tkip_key: OK
[   85.900810] Testing event drv_set_key: OK
[   85.940850] Testing event drv_set_tim: OK
[   85.980802] Testing event drv_configure_filter: OK
[   86.020890] Testing event drv_set_multicast_list: OK
[   86.060784] Testing event drv_prepare_multicast: OK
[   86.100767] Testing event drv_bss_info_changed: OK
[   86.140765] Testing event drv_config: OK
[   86.180755] Testing event drv_remove_interface: OK
[   86.220986] Testing event drv_change_interface: OK
[   86.260863] Testing event drv_add_interface: OK
[   86.300935] Testing event drv_stop: OK
[   86.340815] Testing event drv_set_wakeup: OK
[   86.380922] Testing event drv_resume: OK
[   86.420772] Testing event drv_suspend: OK
[   86.460774] Testing event drv_get_et_stats: OK
[   86.500808] Testing event drv_get_et_sset_count: OK
[   86.540799] Testing event drv_get_et_strings: OK
[   86.580831] Testing event drv_start: OK
[   86.620831] Testing event drv_return_u64: OK
[   86.660873] Testing event drv_return_bool: OK
[   86.701011] Testing event drv_return_int: OK
[   86.743250] Testing event drv_return_void: OK
[   86.782953] Testing event 9p_protocol_dump: OK
[   86.821767] Testing event 9p_client_res: OK
[   86.860581] Testing event 9p_client_req: OK
[   86.900541] Running tests on trace event systems:
[   86.900924] Testing event system 9p: OK
[   86.941676] Testing event system mac80211: OK
[   87.007313] Testing event system cfg80211: OK
[   87.079471] Testing event system skb: OK
[   87.121119] Testing event system net: OK
[   87.161280] Testing event system napi: OK
[   87.200902] Testing event system sock: OK
[   87.240751] Testing event system udp: OK
[   87.280590] Testing event system bcache: OK
[   87.322291] Testing event system regmap: OK
[   87.361985] Testing event system random: OK
[   87.401097] Testing event system gpio: OK
[   87.441254] Testing event system block: OK
[   87.485555] Testing event system btrfs: OK
[   87.537045] Testing event system xfs: OK
[   87.697841] Testing event system jbd2: OK
[   87.742658] Testing event system ext4: OK
[   87.801923] Testing event system writeback: OK
[   87.843710] Testing event system migrate: OK
[   87.880670] Testing event system compaction: OK
[   87.920898] Testing event system kmem: OK
[   87.961980] Testing event system vmscan: OK
[   88.002488] Testing event system oom: OK
[   88.040728] Testing event system filemap: OK
[   88.080795] Testing event system rpm: OK
[   88.121077] Testing event system power: OK
[   88.161261] Testing event system test: OK
[   88.200643] Testing event system lock: OK
[   88.240922] Testing event system sched: 
[   88.280101] test-events (1069) used greatest stack depth: 6820 bytes left
OK
[   88.282749] Testing event system rcu: OK
[   88.322375] Testing event system workqueue: OK
[   88.361144] Testing event system signal: OK
[   88.400792] Testing event system timer: OK
[   88.442053] Testing event system irq: OK
[   88.481316] Testing event system printk: OK
[   88.520593] Testing event system task: OK
[   88.560726] Testing event system irq_vectors: OK
[   88.602179] Testing event system raw_syscalls: OK
[   88.640946] Testing event system syscalls: OK
[   88.680998] Running tests on all trace events:
[   88.681362] Testing all events: OK
[   89.204404] Running tests again, along with the function tracer
[   89.205010] Running tests on trace events:
[   89.205387] Testing event sys_exit: 
[   89.250155] test-events (1081) used greatest stack depth: 6788 bytes left
OK
[   89.253442] Testing event sys_enter: OK
[   89.303146] Testing event thermal_apic_exit: OK
[   89.342992] Testing event thermal_apic_entry: OK
[   89.384000] Testing event threshold_apic_exit: OK
[   89.423807] Testing event threshold_apic_entry: 
[   89.460257] test-events (1086) used greatest stack depth: 6752 bytes left
OK
[   89.463637] Testing event call_function_single_exit: OK
[   89.503648] Testing event call_function_single_entry: OK
[   89.543505] Testing event call_function_exit: OK
[   89.582971] Testing event call_function_entry: OK
[   89.622515] Testing event irq_work_exit: OK
[   89.663530] Testing event irq_work_entry: OK
[   89.703661] Testing event x86_platform_ipi_exit: 
[   89.740486] test-events (1093) used greatest stack depth: 6744 bytes left
OK
[   89.744809] Testing event x86_platform_ipi_entry: OK
[   89.783642] Testing event error_apic_exit: OK
[   89.823548] Testing event error_apic_entry: OK
[   89.863781] Testing event spurious_apic_exit: OK
[   89.903528] Testing event spurious_apic_entry: OK
[   89.943708] Testing event reschedule_exit: OK
[   89.983919] Testing event reschedule_entry: OK
[   90.023657] Testing event local_timer_exit: OK
[   90.063513] Testing event local_timer_entry: OK
[   90.103649] Testing event task_rename: OK
[   90.143651] Testing event task_newtask: OK
[   90.195227] Testing event console: OK
[   90.233637] Testing event softirq_raise: 
[   90.280288] test-events (1106) used greatest stack depth: 6740 bytes left
OK
[   90.285012] Testing event softirq_exit: OK
[   90.323625] Testing event softirq_entry: OK
[   90.363493] Testing event irq_handler_exit: OK
[   90.403570] Testing event irq_handler_entry: OK
[   90.443449] Testing event tick_stop: OK
[   90.483631] Testing event itimer_expire: OK
[   90.523776] Testing event itimer_state: OK
[   90.563900] Testing event hrtimer_cancel: OK
[   90.604085] Testing event hrtimer_expire_exit: OK
[   90.643773] Testing event hrtimer_expire_entry: OK
[   90.683871] Testing event hrtimer_start: OK
[   90.723903] Testing event hrtimer_init: OK
[   90.763806] Testing event timer_cancel: OK
[   90.803884] Testing event timer_expire_exit: OK
[   90.843995] Testing event timer_expire_entry: OK
[   90.883474] Testing event timer_start: OK
[   90.923976] Testing event timer_init: OK
[   90.963409] Testing event signal_deliver: OK
[   91.004296] Testing event signal_generate: OK
[   91.043895] Testing event workqueue_execute_end: OK
[   91.083901] Testing event workqueue_execute_start: OK
[   91.123104] Testing event workqueue_activate_work: OK
[   91.164223] Testing event workqueue_queue_work: OK
[   91.202856] Testing event rcu_barrier: OK
[   91.243113] Testing event rcu_torture_read: OK
[   91.283985] Testing event rcu_batch_end: OK
[   91.334993] Testing event rcu_invoke_kfree_callback: OK
[   91.373888] Testing event rcu_invoke_callback: OK
[   91.413695] Testing event rcu_batch_start: OK
[   91.455424] Testing event rcu_kfree_callback: OK
[   91.493884] Testing event rcu_callback: OK
[   91.545356] Testing event rcu_prep_idle: OK
[   91.594009] Testing event rcu_dyntick: OK
[   91.634614] Testing event rcu_fqs: OK
[   91.674050] Testing event rcu_quiescent_state_report: OK
[   91.725202] Testing event rcu_unlock_preempted_task: OK
[   91.763707] Testing event rcu_preempt_task: OK
[   91.803746] Testing event rcu_grace_period_init: OK
[   91.852659] Testing event rcu_future_grace_period: OK
[   91.902795] Testing event rcu_grace_period: OK
[   91.944794] Testing event rcu_utilization: OK
[   91.984840] Testing event sched_pi_setprio: OK
[   92.023530] Testing event sched_stat_runtime: OK
[   92.063683] Testing event sched_stat_blocked: OK
[   92.103789] Testing event sched_stat_iowait: OK
[   92.143460] Testing event sched_stat_sleep: OK
[   92.183419] Testing event sched_stat_wait: OK
[   92.223455] Testing event sched_process_exec: OK
[   92.263670] Testing event sched_process_fork: OK
[   92.303572] Testing event sched_process_wait: OK
[   92.343648] Testing event sched_wait_task: OK
[   92.383522] Testing event sched_process_exit: OK
[   92.423549] Testing event sched_process_free: OK
[   92.463774] Testing event sched_migrate_task: OK
[   92.503543] Testing event sched_switch: OK
[   92.543696] Testing event sched_wakeup_new: OK
[   92.583459] Testing event sched_wakeup: OK
[   92.623522] Testing event sched_kthread_stop_ret: OK
[   92.663505] Testing event sched_kthread_stop: 
[   92.700274] test-events (1165) used greatest stack depth: 6712 bytes left
OK
[   92.704502] Testing event lock_release: OK
[   92.743581] Testing event lock_acquire: OK
[   92.795576] Testing event ftrace_test_filter: OK
[   92.833753] Testing event power_domain_target: OK
[   92.874122] Testing event clock_set_rate: OK
[   92.913377] Testing event clock_disable: OK
[   92.953540] Testing event clock_enable: OK
[   93.004980] Testing event wakeup_source_deactivate: OK
[   93.043614] Testing event wakeup_source_activate: OK
[   93.083342] Testing event machine_suspend: OK
[   93.122752] Testing event cpu_frequency: OK
[   93.163105] Testing event cpu_idle: OK
[   93.214728] Testing event rpm_return_int: OK
[   93.252720] Testing event rpm_idle: OK
[   93.292737] Testing event rpm_resume: OK
[   93.332889] Testing event rpm_suspend: OK
[   93.383356] Testing event mm_filemap_add_to_page_cache: OK
[   93.432571] Testing event mm_filemap_delete_from_page_cache: OK
[   93.472795] Testing event oom_score_adj_update: OK
[   93.513513] Testing event mm_vmscan_lru_shrink_inactive: OK
[   93.552322] Testing event mm_vmscan_writepage: OK
[   93.593317] Testing event mm_vmscan_memcg_isolate: OK
[   93.633501] Testing event mm_vmscan_lru_isolate: OK
[   93.673551] Testing event mm_shrink_slab_end: OK
[   93.712652] Testing event mm_shrink_slab_start: OK
[   93.752566] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[   93.792838] Testing event mm_vmscan_memcg_reclaim_end: OK
[   93.833824] Testing event mm_vmscan_direct_reclaim_end: OK
[   93.872680] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[   93.912396] Testing event mm_vmscan_memcg_reclaim_begin: OK
[   93.952531] Testing event mm_vmscan_direct_reclaim_begin: OK
[   93.992604] Testing event mm_vmscan_wakeup_kswapd: OK
[   94.034281] Testing event mm_vmscan_kswapd_wake: OK
[   94.085659] Testing event mm_vmscan_kswapd_sleep: OK
[   94.134224] Testing event mm_page_alloc_extfrag: OK
[   94.173246] Testing event mm_page_pcpu_drain: OK
[   94.213841] Testing event mm_page_alloc_zone_locked: OK
[   94.253100] Testing event mm_page_alloc: OK
[   94.293947] Testing event mm_page_free_batched: OK
[   94.332565] Testing event mm_page_free: OK
[   94.372536] Testing event kmem_cache_free: OK
[   94.413025] Testing event kfree: OK
[   94.453448] Testing event kmem_cache_alloc_node: OK
[   94.504170] Testing event kmalloc_node: OK
[   94.553754] Testing event kmem_cache_alloc: OK
[   94.593772] Testing event kmalloc: OK
[   94.633383] Testing event mm_compaction_migratepages: OK
[   94.672094] Testing event mm_compaction_isolate_freepages: OK
[   94.715091] Testing event mm_compaction_isolate_migratepages: OK
[   94.753586] Testing event mm_migrate_pages: OK
[   94.793462] Testing event writeback_single_inode: OK
[   94.833687] Testing event writeback_single_inode_start: OK
[   94.885356] Testing event writeback_wait_iff_congested: OK
[   94.923700] Testing event writeback_congestion_wait: OK
[   94.963688] Testing event writeback_sb_inodes_requeue: OK
[   95.002777] Testing event balance_dirty_pages: OK
[   95.052454] Testing event bdi_dirty_ratelimit: OK
[   95.092938] Testing event global_dirty_state: OK
[   95.132627] Testing event writeback_queue_io: OK
[   95.182809] Testing event wbc_writepage: OK
[   95.234447] Testing event writeback_bdi_unregister: OK
[   95.274421] Testing event writeback_bdi_register: OK
[   95.326898] Testing event writeback_wake_background: OK
[   95.374002] Testing event writeback_nowork: OK
[   95.415097] Testing event writeback_pages_written: OK
[   95.453835] Testing event writeback_wait: OK
[   95.492438] Testing event writeback_written: OK
[   95.532212] Testing event writeback_start: OK
[   95.572189] Testing event writeback_exec: OK
[   95.612399] Testing event writeback_queue: OK
[   95.652708] Testing event writeback_write_inode: OK
[   95.806868] Testing event writeback_write_inode_start: OK
[   95.842110] Testing event writeback_dirty_inode: OK
[   95.882168] Testing event writeback_dirty_inode_start: OK
[   95.922079] Testing event writeback_dirty_page: 
[   95.960257] test-events (1240) used greatest stack depth: 6704 bytes left
OK
[   95.962808] Testing event ext4_es_shrink_exit: OK
[   96.002026] Testing event ext4_es_shrink_enter: OK
[   96.042030] Testing event ext4_es_lookup_extent_exit: OK
[   96.082261] Testing event ext4_es_lookup_extent_enter: OK
[   96.122104] Testing event ext4_es_find_delayed_extent_range_exit: OK
[   96.162464] Testing event ext4_es_find_delayed_extent_range_enter: OK
[   96.206928] Testing event ext4_es_remove_extent: OK
[   96.272686] Testing event ext4_es_insert_extent: OK
[   96.341003] Testing event ext4_ext_remove_space_done: OK
[   96.396178] Testing event ext4_ext_remove_space: OK
[   96.465225] Testing event ext4_ext_rm_idx: OK
[   96.523958] Testing event ext4_ext_rm_leaf: OK
[   96.573671] Testing event ext4_remove_blocks: OK
[   96.623847] Testing event ext4_ext_show_extent: OK
[   96.685590] Testing event ext4_get_reserved_cluster_alloc: OK
[   96.741245] Testing event ext4_find_delalloc_range: OK
[   96.797980] Testing event ext4_ext_in_cache: OK
[   96.856365] Testing event ext4_ext_put_in_cache: OK
[   96.911001] Testing event ext4_get_implied_cluster_alloc_exit: OK
[   96.975752] Testing event ext4_ext_handle_uninitialized_extents: OK
[   97.047906] Testing event ext4_trim_all_free: OK
[   97.104532] Testing event ext4_trim_extent: OK
[   97.165302] Testing event ext4_journal_start: OK
[   97.237408] Testing event ext4_load_inode: OK
[   97.300474] Testing event ext4_ext_load_extent: OK
[   97.353462] Testing event ext4_ind_map_blocks_exit: OK
[   97.414743] Testing event ext4_ext_map_blocks_exit: OK
[   97.465080] Testing event ext4_ind_map_blocks_enter: OK
[   97.515110] Testing event ext4_ext_map_blocks_enter: OK
[   97.563416] Testing event ext4_ext_convert_to_initialized_fastpath: OK
[   97.603448] Testing event ext4_ext_convert_to_initialized_enter: OK
[   97.655917] Testing event ext4_truncate_exit: OK
[   97.693366] Testing event ext4_truncate_enter: OK
[   97.733713] Testing event ext4_unlink_exit: OK
[   97.793945] Testing event ext4_unlink_enter: OK
[   97.853750] Testing event ext4_punch_hole: OK
[   97.913870] Testing event ext4_fallocate_exit: OK
[   97.976987] Testing event ext4_fallocate_enter: OK
[   98.033572] Testing event ext4_direct_IO_exit: OK
[   98.076108] Testing event ext4_direct_IO_enter: OK
[   98.126327] Testing event ext4_load_inode_bitmap: OK
[   98.175952] Testing event ext4_read_block_bitmap_load: OK
[   98.226291] Testing event ext4_mb_buddy_bitmap_load: OK
[   98.276160] Testing event ext4_mb_bitmap_load: OK
[   98.326355] Testing event ext4_da_release_space: OK
[   98.373594] Testing event ext4_da_reserve_space: OK
[   98.426003] Testing event ext4_da_update_reserve_space: OK
[   98.476136] Testing event ext4_forget: OK
[   98.525989] Testing event ext4_mballoc_free: OK
[   98.577272] Testing event ext4_mballoc_discard: OK
[   98.626183] Testing event ext4_mballoc_prealloc: OK
[   98.675973] Testing event ext4_mballoc_alloc: OK
[   98.723328] Testing event ext4_alloc_da_blocks: OK
[   98.766380] Testing event ext4_sync_fs: OK
[   98.813386] Testing event ext4_sync_file_exit: OK
[   98.870148] Testing event ext4_sync_file_enter: OK
[   98.916327] Testing event ext4_free_blocks: OK
[   98.978112] Testing event ext4_allocate_blocks: OK
[   99.023414] Testing event ext4_request_blocks: OK
[   99.066566] Testing event ext4_mb_discard_preallocations: OK
[   99.113328] Testing event ext4_discard_preallocations: OK
[   99.166682] Testing event ext4_mb_release_group_pa: OK
[   99.252493] Testing event ext4_mb_release_inode_pa: OK
[   99.306924] Testing event ext4_mb_new_group_pa: OK
[   99.367151] Testing event ext4_mb_new_inode_pa: OK
[   99.430540] Testing event ext4_discard_blocks: OK
[   99.513596] Testing event ext4_journalled_invalidatepage: OK
[   99.563902] Testing event ext4_invalidatepage: OK
[   99.624595] Testing event ext4_releasepage: OK
[   99.684424] Testing event ext4_readpage: OK
[   99.750380] Testing event ext4_writepage: OK
[   99.811272] Testing event ext4_da_writepages_result: OK
[   99.875448] Testing event ext4_da_write_pages: OK
[   99.963731] Testing event ext4_da_writepages: OK
[  100.028561] Testing event ext4_da_write_end: OK
[  100.087004] Testing event ext4_journalled_write_end: OK
[  100.158301] Testing event ext4_write_end: OK
[  100.211365] Testing event ext4_da_write_begin: OK
[  100.266608] Testing event ext4_write_begin: OK
[  100.340569] Testing event ext4_begin_ordered_truncate: OK
[  100.414662] Testing event ext4_mark_inode_dirty: OK
[  100.484307] Testing event ext4_drop_inode: OK
[  100.566047] Testing event ext4_evict_inode: OK
[  100.636508] Testing event ext4_allocate_inode: OK
[  100.689088] Testing event ext4_request_inode: OK
[  100.750131] Testing event ext4_free_inode: OK
[  100.813673] Testing event jbd2_lock_buffer_stall: OK
[  100.874508] Testing event jbd2_write_superblock: OK
[  100.945922] Testing event jbd2_update_log_tail: OK
[  101.006610] Testing event jbd2_checkpoint_stats: OK
[  101.086972] Testing event jbd2_run_stats: OK
[  101.155580] Testing event jbd2_handle_stats: OK
[  101.216309] Testing event jbd2_handle_extend: OK
[  101.264070] Testing event jbd2_handle_start: OK
[  101.305886] Testing event jbd2_submit_inode_data: OK
[  101.354140] Testing event jbd2_end_commit: OK
[  101.393968] Testing event jbd2_drop_transaction: OK
[  101.436928] Testing event jbd2_commit_logging: OK
[  101.486751] Testing event jbd2_commit_flushing: OK
[  101.554190] Testing event jbd2_commit_locking: OK
[  101.604136] Testing event jbd2_start_commit: OK
[  101.654904] Testing event jbd2_checkpoint: OK
[  101.714503] Testing event xfs_discard_busy: OK
[  101.767312] Testing event xfs_discard_exclude: OK
[  101.828183] Testing event xfs_discard_toosmall: OK
[  101.887249] Testing event xfs_discard_extent: OK
[  101.965063] Testing event xfs_log_recover_inode_skip: OK
[  102.014664] Testing event xfs_log_recover_inode_cancel: OK
[  102.064559] Testing event xfs_log_recover_inode_recover: OK
[  102.122001] Testing event xfs_log_recover_buf_dquot_buf: OK
[  102.174389] Testing event xfs_log_recover_buf_reg_buf: OK
[  102.214006] Testing event xfs_log_recover_buf_inode_buf: OK
[  102.254080] Testing event xfs_log_recover_buf_recover: OK
[  102.304214] Testing event xfs_log_recover_buf_cancel_ref_inc: OK
[  102.355644] Testing event xfs_log_recover_buf_cancel_add: OK
[  102.436812] Testing event xfs_log_recover_buf_cancel: OK
[  102.493926] Testing event xfs_log_recover_buf_not_cancel: OK
[  102.546400] Testing event xfs_log_recover_item_recover: OK
[  102.604296] Testing event xfs_log_recover_item_reorder_tail: OK
[  102.655765] Testing event xfs_log_recover_item_reorder_head: OK
[  102.734013] Testing event xfs_log_recover_item_add_cont: OK
[  102.783773] Testing event xfs_log_recover_item_add: OK
[  102.828429] Testing event xfs_swap_extent_after: OK
[  102.877108] Testing event xfs_swap_extent_before: OK
[  102.963786] Testing event xfs_dir2_leafn_moveents: OK
[  103.016359] Testing event xfs_dir2_shrink_inode: OK
[  103.066491] Testing event xfs_dir2_grow_inode: OK
[  103.116290] Testing event xfs_dir2_leafn_remove: OK
[  103.176325] Testing event xfs_dir2_leafn_add: OK
[  103.226615] Testing event xfs_da_path_shift: OK
[  103.276530] Testing event xfs_da_fixhashpath: OK
[  103.326661] Testing event xfs_da_shrink_inode: OK
[  103.396097] Testing event xfs_da_grow_inode: OK
[  103.456883] Testing event xfs_da_swap_lastblock: OK
[  103.524729] Testing event xfs_da_node_toosmall: OK
[  103.595763] Testing event xfs_da_node_unbalance: OK
[  103.656572] Testing event xfs_da_node_rebalance: OK
[  103.739757] Testing event xfs_da_node_remove: OK
[  103.791855] Testing event xfs_da_node_split: OK
[  103.842772] Testing event xfs_da_node_create: OK
[  103.910424] Testing event xfs_da_node_add: OK
[  103.961815] Testing event xfs_da_root_join: OK
[  104.027378] Testing event xfs_da_root_split: OK
[  104.074645] Testing event xfs_da_unlink_forward: OK
[  104.134474] Testing event xfs_da_unlink_back: OK
[  104.185387] Testing event xfs_da_link_after: OK
[  104.235390] Testing event xfs_da_link_before: OK
[  104.285898] Testing event xfs_da_join: OK
[  104.335422] Testing event xfs_da_split: OK
[  104.395757] Testing event xfs_attr_rmtval_remove: OK
[  104.445736] Testing event xfs_attr_rmtval_set: OK
[  104.519253] Testing event xfs_attr_rmtval_get: OK
[  104.575680] Testing event xfs_attr_refillstate: OK
[  104.625478] Testing event xfs_attr_fillstate: OK
[  104.675663] Testing event xfs_attr_node_removename: OK
[  104.717554] Testing event xfs_attr_node_replace: OK
[  104.775099] Testing event xfs_attr_node_lookup: OK
[  104.824076] Testing event xfs_attr_node_get: OK
[  104.864376] Testing event xfs_attr_node_addname: OK
[  104.904259] Testing event xfs_attr_leaf_toosmall: OK
[  104.982744] Testing event xfs_attr_leaf_unbalance: OK
[  105.034277] Testing event xfs_attr_leaf_rebalance: OK
[  105.101506] Testing event xfs_attr_leaf_to_node: OK
[  105.143850] Testing event xfs_attr_leaf_to_sf: OK
[  105.233526] Testing event xfs_attr_leaf_flipflags: OK
[  105.281546] Testing event xfs_attr_leaf_setflag: OK
[  105.330701] Testing event xfs_attr_leaf_clearflag: OK
[  105.388566] Testing event xfs_attr_leaf_split_after: OK
[  105.464395] Testing event xfs_attr_leaf_split_before: OK
[  105.524280] Testing event xfs_attr_leaf_split: OK
[  105.584173] Testing event xfs_attr_leaf_removename: OK
[  105.654314] Testing event xfs_attr_leaf_remove: OK
[  105.704742] Testing event xfs_attr_leaf_replace: OK
[  105.754422] Testing event xfs_attr_leaf_lookup: OK
[  105.795245] Testing event xfs_attr_leaf_get: OK
[  105.844320] Testing event xfs_attr_leaf_compact: OK
[  105.894584] Testing event xfs_attr_leaf_create: OK
[  105.945570] Testing event xfs_attr_leaf_addname: OK
[  106.004532] Testing event xfs_attr_leaf_add_work: OK
[  106.063688] Testing event xfs_attr_leaf_add_new: OK
[  106.124397] Testing event xfs_attr_leaf_add_old: OK
[  106.191256] Testing event xfs_attr_leaf_add: OK
[  106.244396] Testing event xfs_attr_sf_to_leaf: OK
[  106.295573] Testing event xfs_attr_sf_removename: OK
[  106.364579] Testing event xfs_attr_sf_remove: OK
[  106.424493] Testing event xfs_attr_sf_lookup: OK
[  106.493888] Testing event xfs_attr_sf_create: OK
[  106.548658] Testing event xfs_attr_sf_addname: OK
[  106.615148] Testing event xfs_attr_sf_add: OK
[  106.681360] Testing event xfs_dir2_node_to_leaf: OK
[  106.745285] Testing event xfs_dir2_node_removename: OK
[  106.795548] Testing event xfs_dir2_node_replace: OK
[  106.866935] Testing event xfs_dir2_node_lookup: OK
[  106.934646] Testing event xfs_dir2_node_addname: OK
[  106.998625] Testing event xfs_dir2_leaf_to_node: OK
[  107.071093] Testing event xfs_dir2_leaf_to_block: OK
[  107.140580] Testing event xfs_dir2_leaf_removename: OK
[  107.195505] Testing event xfs_dir2_leaf_replace: OK
[  107.246032] Testing event xfs_dir2_leaf_lookup: OK
[  107.293696] Testing event xfs_dir2_leaf_addname: OK
[  107.343345] Testing event xfs_dir2_block_to_leaf: OK
[  107.383622] Testing event xfs_dir2_block_to_sf: OK
[  107.433972] Testing event xfs_dir2_block_removename: OK
[  107.483631] Testing event xfs_dir2_block_replace: OK
[  107.553451] Testing event xfs_dir2_block_lookup: OK
[  107.595780] Testing event xfs_dir2_block_addname: OK
[  107.643718] Testing event xfs_dir2_sf_to_block: OK
[  107.703998] Testing event xfs_dir2_sf_toino8: OK
[  107.774809] Testing event xfs_dir2_sf_toino4: OK
[  107.844191] Testing event xfs_dir2_sf_removename: OK
[  107.884618] Testing event xfs_dir2_sf_replace: OK
[  107.926478] Testing event xfs_dir2_sf_lookup: OK
[  107.976733] Testing event xfs_dir2_sf_create: OK
[  108.026609] Testing event xfs_dir2_sf_addname: OK
[  108.076510] Testing event xfs_alloc_vextent_allfailed: OK
[  108.153385] Testing event xfs_alloc_vextent_loopfailed: OK
[  108.257145] Testing event xfs_alloc_vextent_noagbp: OK
[  108.357353] Testing event xfs_alloc_vextent_nofix: OK
[  108.408134] Testing event xfs_alloc_vextent_badargs: OK
[  108.460251] Testing event xfs_alloc_small_error: OK
[  108.520154] Testing event xfs_alloc_small_done: OK
[  108.584713] Testing event xfs_alloc_small_notenough: OK
[  108.646146] Testing event xfs_alloc_small_freelist: OK
[  108.693826] Testing event xfs_alloc_size_busy: OK
[  108.774309] Testing event xfs_alloc_size_error: OK
[  108.834207] Testing event xfs_alloc_size_done: OK
[  108.904007] Testing event xfs_alloc_size_nominleft: OK
[  108.963820] Testing event xfs_alloc_size_noentry: OK
[  109.082805] Testing event xfs_alloc_size_neither: OK
[  109.147292] Testing event xfs_alloc_near_busy: OK
[  109.207288] Testing event xfs_alloc_near_noentry: OK
[  109.269660] Testing event xfs_alloc_near_error: OK
[  109.340673] Testing event xfs_alloc_near_lesser: OK
[  109.396979] Testing event xfs_alloc_near_greater: OK
[  109.457392] Testing event xfs_alloc_near_first: OK
[  109.511883] Testing event xfs_alloc_near_nominleft: OK
[  109.594977] Testing event xfs_alloc_exact_error: OK
[  109.664796] Testing event xfs_alloc_exact_notfound: OK
[  109.730796] Testing event xfs_alloc_exact_done: OK
[  109.794688] Testing event xfs_free_extent: OK
[  109.857405] Testing event xfs_agf: OK
[  109.915482] Testing event xfs_trans_commit_lsn: OK
[  109.973092] Testing event xfs_extent_busy_trim: OK
[  110.037523] Testing event xfs_extent_busy_clear: OK
[  110.124722] Testing event xfs_extent_busy_reuse: OK
[  110.194795] Testing event xfs_extent_busy_force: OK
[  110.247352] Testing event xfs_extent_busy_enomem: OK
[  110.307234] Testing event xfs_extent_busy: OK
[  110.389688] Testing event xfs_bunmap: OK
[  110.457212] Testing event xfs_pagecache_inval: OK
[  110.516956] Testing event xfs_itruncate_extents_end: OK
[  110.577121] Testing event xfs_itruncate_extents_start: OK
[  110.647262] Testing event xfs_setfilesize: OK
[  110.705416] Testing event xfs_get_blocks_notfound: OK
[  110.743691] Testing event xfs_unwritten_convert: OK
[  110.783363] Testing event xfs_delalloc_enospc: OK
[  110.835474] Testing event xfs_get_blocks_alloc: OK
[  110.883310] Testing event xfs_get_blocks_found: OK
[  110.933343] Testing event xfs_map_blocks_alloc: OK
[  110.973228] Testing event xfs_map_blocks_found: OK
[  111.013303] Testing event xfs_invalidatepage: OK
[  111.053363] Testing event xfs_releasepage: OK
[  111.093698] Testing event xfs_writepage: OK
[  111.133328] Testing event xfs_file_splice_write: OK
[  111.173623] Testing event xfs_file_splice_read: OK
[  111.223469] Testing event xfs_file_direct_write: OK
[  111.263245] Testing event xfs_file_buffered_write: OK
[  111.303230] Testing event xfs_file_read: OK
[  111.343744] Testing event xfs_ail_flushing: OK
[  111.383340] Testing event xfs_ail_locked: OK
[  111.426640] Testing event xfs_ail_pinned: OK
[  111.473601] Testing event xfs_ail_push: OK
[  111.513375] Testing event xfs_log_force: OK
[  111.553321] Testing event xfs_log_ungrant_sub: OK
[  111.593368] Testing event xfs_log_ungrant_exit: OK
[  111.633799] Testing event xfs_log_ungrant_enter: OK
[  111.693651] Testing event xfs_log_regrant_reserve_sub: OK
[  111.753635] Testing event xfs_log_regrant_reserve_exit: OK
[  111.813717] Testing event xfs_log_regrant_reserve_enter: OK
[  111.873777] Testing event xfs_log_regrant_exit: OK
[  111.943676] Testing event xfs_log_regrant: OK
[  112.003724] Testing event xfs_log_reserve_exit: OK
[  112.063903] Testing event xfs_log_reserve: OK
[  112.126416] Testing event xfs_log_grant_wake_up: OK
[  112.173938] Testing event xfs_log_grant_wake: OK
[  112.253533] Testing event xfs_log_grant_sleep: OK
[  112.317013] Testing event xfs_log_umount_write: OK
[  112.370478] Testing event xfs_log_done_perm: OK
[  112.439657] Testing event xfs_log_done_nonperm: OK
[  112.495931] Testing event xfs_dqflush_done: OK
[  112.563085] Testing event xfs_dqflush_force: OK
[  112.624502] Testing event xfs_dqflush: OK
[  112.680620] Testing event xfs_dqrele: OK
[  112.745439] Testing event xfs_dqput_free: OK
[  112.805836] Testing event xfs_dqput_wait: OK
[  112.877190] Testing event xfs_dqput: OK
[  112.923525] Testing event xfs_dqget_dup: OK
[  112.963700] Testing event xfs_dqget_freeing: OK
[  113.006429] Testing event xfs_dqget_miss: OK
[  113.079617] Testing event xfs_dqget_hit: OK
[  113.159963] Testing event xfs_dqread_fail: OK
[  113.223851] Testing event xfs_dqread: OK
[  113.269859] Testing event xfs_dqtobp_read: OK
[  113.364029] Testing event xfs_dqalloc: OK
[  113.433126] Testing event xfs_dqattach_get: OK
[  113.473073] Testing event xfs_dqattach_found: OK
[  113.513307] Testing event xfs_dqreclaim_done: OK
[  113.563110] Testing event xfs_dqreclaim_busy: OK
[  113.603186] Testing event xfs_dqreclaim_dirty: OK
[  113.644799] Testing event xfs_dqreclaim_want: OK
[  113.693084] Testing event xfs_dqadjust: OK
[  113.733062] Testing event xfs_rename: OK
[  113.773203] Testing event xfs_symlink: OK
[  113.813508] Testing event xfs_create: OK
[  113.853348] Testing event xfs_lookup: OK
[  113.893291] Testing event xfs_link: OK
[  113.933497] Testing event xfs_remove: OK
[  113.973455] Testing event xfs_inode_unpin_nowait: OK
[  114.013548] Testing event xfs_inode_unpin: OK
[  114.056074] Testing event xfs_inode_pin: OK
[  114.104349] Testing event xfs_irele: OK
[  114.161142] Testing event xfs_ihold: OK
[  114.204692] Testing event xfs_iomap_prealloc_size: OK
[  114.247450] Testing event xfs_inode_free_eofblocks_invalid: OK
[  114.307296] Testing event xfs_inode_clear_eofblocks_tag: OK
[  114.357504] Testing event xfs_inode_set_eofblocks_tag: OK
[  114.417406] Testing event xfs_dquot_dqdetach: OK
[  114.463878] Testing event xfs_dquot_dqalloc: OK
[  114.523510] Testing event xfs_update_time: OK
[  114.563488] Testing event xfs_evict_inode: OK
[  114.603528] Testing event xfs_destroy_inode: OK
[  114.643682] Testing event xfs_file_fsync: OK
[  114.683659] Testing event xfs_dir_fsync: OK
[  114.724572] Testing event xfs_ioctl_setattr: OK
[  114.784930] Testing event xfs_file_compat_ioctl: OK
[  114.850392] Testing event xfs_file_ioctl: OK
[  114.906769] Testing event xfs_vm_bmap: OK
[  114.953743] Testing event xfs_readdir: OK
[  115.024118] Testing event xfs_free_file_space: OK
[  115.093840] Testing event xfs_alloc_file_space: OK
[  115.154152] Testing event xfs_readlink: OK
[  115.214226] Testing event xfs_setattr: OK
[  115.305044] Testing event xfs_getattr: OK
[  115.344075] Testing event xfs_iget_miss: OK
[  115.403948] Testing event xfs_iget_hit: OK
[  115.463793] Testing event xfs_iget_reclaim_fail: OK
[  115.523953] Testing event xfs_iget_reclaim: OK
[  115.593805] Testing event xfs_iget_skip: OK
[  115.664216] Testing event xfs_iunlock: OK
[  115.724081] Testing event xfs_ilock_demote: OK
[  115.784088] Testing event xfs_ilock_nowait: OK
[  115.844114] Testing event xfs_ilock: OK
[  115.903755] Testing event xfs_trans_binval: OK
[  115.964069] Testing event xfs_trans_bhold_release: OK
[  116.033979] Testing event xfs_trans_bhold: OK
[  116.104049] Testing event xfs_trans_bjoin: OK
[  116.163859] Testing event xfs_trans_brelse: OK
[  116.224144] Testing event xfs_trans_log_buf: OK
[  116.284162] Testing event xfs_trans_read_buf_recur: OK
[  116.347498] Testing event xfs_trans_read_buf: OK
[  116.407584] Testing event xfs_trans_getsb_recur: OK
[  116.464058] Testing event xfs_trans_getsb: OK
[  116.530990] Testing event xfs_trans_get_buf_recur: OK
[  116.580993] Testing event xfs_trans_get_buf: OK
[  116.636750] Testing event xfs_buf_item_push: OK
[  116.702421] Testing event xfs_buf_item_committed: OK
[  116.768666] Testing event xfs_buf_item_unlock_stale: OK
[  116.816849] Testing event xfs_buf_item_unlock: OK
[  116.866642] Testing event xfs_buf_item_unpin_stale: OK
[  116.916986] Testing event xfs_buf_item_unpin: OK
[  116.966593] Testing event xfs_buf_item_pin: OK
[  117.025677] Testing event xfs_buf_item_format_stale: OK
[  117.094094] Testing event xfs_buf_item_format: OK
[  117.163550] Testing event xfs_buf_item_size_stale: OK
[  117.233687] Testing event xfs_buf_item_size: OK
[  117.332523] Testing event xfs_buf_ioerror: OK
[  117.377297] Testing event xfs_buf_read: OK
[  117.437171] Testing event xfs_buf_get: OK
[  117.499108] Testing event xfs_buf_find: OK
[  117.566186] Testing event xfs_inode_item_push: OK
[  117.667130] Testing event xfs_reset_dqcounts: OK
[  117.716815] Testing event xfs_da_btree_corrupt: OK
[  117.786639] Testing event xfs_btree_corrupt: OK
[  117.837711] Testing event xfs_trans_read_buf_shut: OK
[  117.894452] Testing event xfs_trans_read_buf_io: OK
[  117.976290] Testing event xfs_buf_wait_buftarg: OK
[  118.024602] Testing event xfs_buf_error_relse: OK
[  118.084224] Testing event xfs_buf_item_iodone_async: OK
[  118.143961] Testing event xfs_buf_item_iodone: OK
[  118.209810] Testing event xfs_buf_item_relse: OK
[  118.294825] Testing event xfs_bdstrat_shut: OK
[  118.365310] Testing event xfs_buf_get_uncached: OK
[  118.416663] Testing event xfs_buf_delwri_split: OK
[  118.490248] Testing event xfs_buf_delwri_queued: OK
[  118.563871] Testing event xfs_buf_delwri_queue: OK
[  118.634797] Testing event xfs_buf_iowait_done: OK
[  118.713883] Testing event xfs_buf_iowait: OK
[  118.786902] Testing event xfs_buf_unlock: OK
[  118.855971] Testing event xfs_buf_trylock: OK
[  118.907012] Testing event xfs_buf_lock_done: OK
[  118.953605] Testing event xfs_buf_lock: OK
[  118.993358] Testing event xfs_buf_bawrite: OK
[  119.043296] Testing event xfs_buf_iorequest: OK
[  119.083439] Testing event xfs_buf_iodone: OK
[  119.123505] Testing event xfs_buf_rele: OK
[  119.173616] Testing event xfs_buf_hold: OK
[  119.213714] Testing event xfs_buf_free: OK
[  119.253854] Testing event xfs_buf_init: OK
[  119.293623] Testing event xfs_extlist: OK
[  119.333597] Testing event xfs_bmap_post_update: OK
[  119.386960] Testing event xfs_bmap_pre_update: OK
[  119.437405] Testing event xfs_iext_remove: OK
[  119.483576] Testing event xfs_iext_insert: OK
[  119.524143] Testing event xfs_attr_list_node_descend: OK
[  119.566673] Testing event xfs_perag_clear_eofblocks: OK
[  119.616869] Testing event xfs_perag_set_eofblocks: OK
[  119.666697] Testing event xfs_perag_clear_reclaim: OK
[  119.735805] Testing event xfs_perag_set_reclaim: OK
[  119.798886] Testing event xfs_perag_put: OK
[  119.843598] Testing event xfs_perag_get_tag: OK
[  119.883682] Testing event xfs_perag_get: OK
[  119.923753] Testing event xfs_attr_node_list: OK
[  119.963514] Testing event xfs_attr_leaf_list: OK
[  120.005864] Testing event xfs_attr_list_notfound: OK
[  120.053943] Testing event xfs_attr_list_wrong_blk: OK
[  120.115755] Testing event xfs_attr_list_add: OK
[  120.172726] Testing event xfs_attr_list_full: OK
[  120.233891] Testing event xfs_attr_list_leaf_end: OK
[  120.293024] Testing event xfs_attr_list_leaf: OK
[  120.336123] Testing event xfs_attr_list_sf_all: OK
[  120.383801] Testing event xfs_attr_list_sf: OK
[  120.423528] Testing event free_extent_state: OK
[  120.473591] Testing event alloc_extent_state: OK
[  120.513529] Testing event btrfs_setup_cluster: OK
[  120.553986] Testing event btrfs_failed_cluster_setup: OK
[  120.593710] Testing event btrfs_find_cluster: OK
[  120.633583] Testing event btrfs_reserve_extent_cluster: OK
[  120.673707] Testing event btrfs_reserve_extent: OK
[  120.725070] Testing event find_free_extent: OK
[  120.775250] Testing event btrfs_reserved_extent_free: OK
[  120.814202] Testing event btrfs_reserved_extent_alloc: OK
[  120.883826] Testing event btrfs_space_reservation: OK
[  120.954934] Testing event btrfs_cow_block: OK
[  121.029681] Testing event btrfs_chunk_free: OK
[  121.086961] Testing event btrfs_chunk_alloc: OK
[  121.140597] Testing event btrfs_delayed_ref_head: OK
[  121.186878] Testing event btrfs_delayed_data_ref: OK
[  121.233726] Testing event btrfs_delayed_tree_ref: OK
[  121.280773] Testing event btrfs_sync_fs: OK
[  121.326937] Testing event btrfs_sync_file: OK
[  121.392800] Testing event btrfs_writepage_end_io_hook: OK
[  121.462740] Testing event __extent_writepage: OK
[  121.527136] Testing event btrfs_ordered_extent_put: OK
[  121.576882] Testing event btrfs_ordered_extent_start: OK
[  121.631984] Testing event btrfs_ordered_extent_remove: OK
[  121.698493] Testing event btrfs_ordered_extent_add: OK
[  121.755012] Testing event btrfs_get_extent: OK
[  121.821050] Testing event btrfs_inode_evict: OK
[  121.867880] Testing event btrfs_inode_request: OK
[  121.927057] Testing event btrfs_inode_new: OK
[  121.986280] Testing event btrfs_transaction_commit: OK
[  122.057161] Testing event block_rq_remap: OK
[  122.125326] Testing event block_bio_remap: OK
[  122.188483] Testing event block_split: OK
[  122.247692] Testing event block_unplug: OK
[  122.309447] Testing event block_plug: OK
[  122.370219] Testing event block_sleeprq: OK
[  122.416265] Testing event block_getrq: OK
[  122.477744] Testing event block_bio_queue: OK
[  122.533627] Testing event block_bio_frontmerge: OK
[  122.585692] Testing event block_bio_backmerge: OK
[  122.647173] Testing event block_bio_complete: OK
[  122.696864] Testing event block_bio_bounce: OK
[  122.744105] Testing event block_rq_issue: OK
[  122.806273] Testing event block_rq_insert: OK
[  122.855064] Testing event block_rq_complete: OK
[  122.912615] Testing event block_rq_requeue: OK
[  122.963937] Testing event block_rq_abort: OK
[  123.026920] Testing event block_dirty_buffer: OK
[  123.077144] Testing event block_touch_buffer: OK
[  123.128133] Testing event gpio_value: OK
[  123.177777] Testing event gpio_direction: OK
[  123.237794] Testing event extract_entropy_user: OK
[  123.295742] Testing event extract_entropy: OK
[  123.345040] Testing event get_random_bytes: OK
[  123.395730] Testing event credit_entropy_bits: OK
[  123.444145] Testing event mix_pool_bytes_nolock: OK
[  123.494395] Testing event mix_pool_bytes: OK
[  123.534428] Testing event regmap_async_complete_done: OK
[  123.576086] Testing event regmap_async_complete_start: OK
[  123.623348] Testing event regmap_async_io_complete: OK
[  123.663556] Testing event regmap_async_write_start: OK
[  123.704980] Testing event regmap_cache_bypass: OK
[  123.743746] Testing event regmap_cache_only: OK
[  123.796200] Testing event regcache_sync: OK
[  123.869083] Testing event regmap_hw_write_done: OK
[  123.937893] Testing event regmap_hw_write_start: OK
[  123.984563] Testing event regmap_hw_read_done: OK
[  124.033835] Testing event regmap_hw_read_start: OK
[  124.083802] Testing event regmap_reg_read_cache: OK
[  124.161663] Testing event regmap_reg_read: OK
[  124.224638] Testing event regmap_reg_write: OK
[  124.275289] Testing event bcache_gc_end: OK
[  124.335063] Testing event bcache_gc_start: OK
[  124.385580] Testing event bcache_cache_insert: OK
[  124.435982] Testing event bcache_journal_write: OK
[  124.487222] Testing event bcache_read_moving: OK
[  124.536195] Testing event bcache_write_moving: OK
[  124.591126] Testing event bcache_read_dirty: OK
[  124.641489] Testing event bcache_write_dirty: 
[  124.702884] test-events (1750) used greatest stack depth: 6632 bytes left
OK
[  124.717947] Testing event bcache_btree_write: OK
[  124.763893] Testing event bcache_btree_read: OK
[  124.817146] Testing event bcache_write_skip: OK
[  124.867290] Testing event bcache_writeback: OK
[  124.917212] Testing event bcache_writethrough: OK
[  124.964668] Testing event bcache_read_retry: OK
[  125.017090] Testing event bcache_cache_miss: OK
[  125.085259] Testing event bcache_cache_hit: OK
[  125.154361] Testing event bcache_passthrough: OK
[  125.207159] Testing event bcache_request_end: OK
[  125.267605] Testing event bcache_request_start: OK
[  125.321463] Testing event udp_fail_queue_rcv_skb: OK
[  125.369679] Testing event sock_exceed_buf_limit: OK
[  125.416526] Testing event sock_rcvqueue_full: OK
[  125.477243] Testing event napi_poll: OK
[  125.531476] Testing event netif_rx: OK
[  125.582137] Testing event netif_receive_skb: OK
[  125.630894] Testing event net_dev_queue: OK
[  125.677352] Testing event net_dev_xmit: OK
[  125.725096] Testing event skb_copy_datagram_iovec: OK
[  125.789127] Testing event consume_skb: OK
[  126.153968] Testing event kfree_skb: OK
[  126.214923] Testing event cfg80211_ft_event: OK
[  126.277777] Testing event cfg80211_report_wowlan_wakeup: OK
[  126.338027] Testing event cfg80211_return_u32: OK
[  126.387070] Testing event cfg80211_return_uint: OK
[  126.448447] Testing event cfg80211_return_bss: OK
[  126.504561] Testing event cfg80211_inform_bss_frame: OK
[  126.564085] Testing event cfg80211_get_bss: OK
[  126.617221] Testing event cfg80211_sched_scan_stopped: OK
[  126.680704] Testing event cfg80211_sched_scan_results: OK
[  126.756840] Testing event cfg80211_scan_done: OK
[  126.806696] Testing event cfg80211_tdls_oper_request: OK
[  126.855618] Testing event cfg80211_report_obss_beacon: OK
[  126.903659] Testing event cfg80211_pmksa_candidate_notify: OK
[  126.955083] Testing event cfg80211_gtk_rekey_notify: OK
[  126.993505] Testing event cfg80211_cqm_pktloss_notify: OK
[  127.043706] Testing event cfg80211_probe_status: OK
[  127.083587] Testing event cfg80211_rx_unexpected_4addr_frame: OK
[  127.123703] Testing event cfg80211_rx_spurious_frame: OK
[  127.166416] Testing event cfg80211_ibss_joined: OK
[  127.214025] Testing event cfg80211_cac_event: OK
[  127.264159] Testing event cfg80211_radar_event: OK
[  127.314015] Testing event cfg80211_ch_switch_notify: OK
[  127.373947] Testing event cfg80211_chandef_dfs_required: OK
[  127.438516] Testing event cfg80211_reg_can_beacon: OK
[  127.493384] Testing event cfg80211_cqm_rssi_notify: OK
[  127.547551] Testing event cfg80211_mgmt_tx_status: OK
[  127.607587] Testing event cfg80211_rx_mgmt: OK
[  127.672765] Testing event cfg80211_del_sta: OK
[  127.734844] Testing event cfg80211_new_sta: OK
[  127.786982] Testing event cfg80211_ready_on_channel_expired: OK
[  127.833709] Testing event cfg80211_ready_on_channel: OK
[  127.878015] Testing event cfg80211_michael_mic_failure: OK
[  127.931865] Testing event cfg80211_send_assoc_timeout: OK
[  128.000001] Testing event cfg80211_send_auth_timeout: OK
[  128.061419] Testing event cfg80211_send_unprot_disassoc: OK
[  128.134302] Testing event cfg80211_send_unprot_deauth: OK
[  128.186942] Testing event __cfg80211_send_disassoc: OK
[  128.237256] Testing event __cfg80211_send_deauth: OK
[  128.287354] Testing event cfg80211_send_rx_assoc: OK
[  128.337151] Testing event cfg80211_send_rx_auth: OK
[  128.387118] Testing event cfg80211_notify_new_peer_candidate: OK
[  128.436256] Testing event cfg80211_return_bool: OK
[  128.496528] Testing event rdev_crit_proto_stop: OK
[  128.550788] Testing event rdev_crit_proto_start: OK
[  128.609456] Testing event rdev_update_ft_ies: OK
[  128.653520] Testing event rdev_set_mac_acl: OK
[  128.696192] Testing event rdev_stop_p2p_device: OK
[  128.747909] Testing event rdev_start_p2p_device: OK
[  128.793992] Testing event rdev_return_chandef: OK
[  128.860162] Testing event rdev_get_channel: OK
[  128.913899] Testing event rdev_get_et_strings: OK
[  128.974254] Testing event rdev_get_et_sset_count: OK
[  129.044221] Testing event rdev_set_noack_map: OK
[  129.113785] Testing event rdev_mgmt_tx: OK
[  129.167550] Testing event rdev_cancel_remain_on_channel: OK
[  129.229109] Testing event rdev_return_int_cookie: OK
[  129.277692] Testing event rdev_remain_on_channel: OK
[  129.331183] Testing event rdev_del_pmksa: OK
[  129.379544] Testing event rdev_set_pmksa: OK
[  129.448895] Testing event rdev_probe_client: OK
[  129.549026] Testing event rdev_tdls_oper: OK
[  129.615019] Testing event rdev_return_int_survey_info: OK
[  129.694037] Testing event rdev_dump_survey: OK
[  129.751134] Testing event rdev_tdls_mgmt: OK
[  129.813572] Testing event rdev_sched_scan_start: OK
[  129.868882] Testing event rdev_set_antenna: OK
[  129.916708] Testing event rdev_set_ringparam: OK
[  129.970241] Testing event rdev_return_void_tx_rx: OK
[  130.023216] Testing event rdev_return_int_tx_rx: OK
[  130.077381] Testing event rdev_mgmt_frame_register: OK
[  130.136442] Testing event rdev_set_bitrate_mask: OK
[  130.190845] Testing event rdev_return_int_int: OK
[  130.234922] Testing event rdev_set_tx_power: OK
[  130.287414] Testing event rdev_get_tx_power: OK
[  130.336904] Testing event rdev_set_wiphy_params: OK
[  130.393725] Testing event rdev_join_ibss: OK
[  130.458403] Testing event rdev_disconnect: OK
[  130.506022] Testing event rdev_set_cqm_txe_config: OK
[  130.554457] Testing event rdev_set_cqm_rssi_config: OK
[  130.630238] Testing event rdev_connect: OK
[  130.697232] Testing event rdev_set_power_mgmt: OK
[  130.774104] Testing event rdev_mgmt_tx_cancel_wait: OK
[  130.855326] Testing event rdev_disassoc: OK
[  130.914464] Testing event rdev_deauth: OK
[  130.980380] Testing event rdev_assoc: OK
[  131.070108] Testing event rdev_auth: OK
[  131.136991] Testing event rdev_set_monitor_channel: OK
[  131.206028] Testing event rdev_libertas_set_mesh_channel: OK
[  131.287070] Testing event rdev_set_txq_params: OK
[  131.336673] Testing event rdev_change_bss: OK
[  131.386844] Testing event rdev_join_mesh: OK
[  131.446678] Testing event rdev_update_mesh_config: OK
[  131.494943] Testing event rdev_return_int_mesh_config: OK
[  131.547520] Testing event rdev_return_int_mpath_info: OK
[  131.615220] Testing event rdev_dump_mpath: OK
[  131.685316] Testing event rdev_get_mpath: OK
[  131.756257] Testing event rdev_change_mpath: OK
[  131.827459] Testing event rdev_add_mpath: OK
[  131.873784] Testing event rdev_return_int_station_info: OK
[  131.913737] Testing event rdev_dump_station: OK
[  131.964849] Testing event rdev_set_wds_peer: OK
[  132.016416] Testing event rdev_del_mpath: OK
[  132.066476] Testing event rdev_get_station: OK
[  132.117323] Testing event rdev_del_station: OK
[  132.167328] Testing event rdev_change_station: OK
[  132.217258] Testing event rdev_add_station: OK
[  132.267534] Testing event rdev_flush_pmksa: OK
[  132.316627] Testing event rdev_leave_ibss: OK
[  132.367232] Testing event rdev_leave_mesh: OK
[  132.417438] Testing event rdev_get_mesh_config: OK
[  132.466404] Testing event rdev_set_rekey_data: OK
[  132.516219] Testing event rdev_sched_scan_stop: OK
[  132.563766] Testing event rdev_get_et_stats: OK
[  132.603453] Testing event rdev_stop_ap: OK
[  132.643722] Testing event rdev_change_beacon: OK
[  132.683758] Testing event rdev_start_ap: OK
[  132.723577] Testing event rdev_set_default_mgmt_key: OK
[  132.764134] Testing event rdev_set_default_key: OK
[  132.824229] Testing event rdev_del_key: OK
[  132.874392] Testing event rdev_get_key: OK
[  132.924767] Testing event rdev_add_key: OK
[  132.989127] Testing event rdev_change_virtual_intf: OK
[  133.065211] Testing event rdev_del_virtual_intf: OK
[  133.145060] Testing event rdev_return_wdev: OK
[  133.201339] Testing event rdev_add_virtual_intf: OK
[  133.267504] Testing event rdev_set_wakeup: OK
[  133.337984] Testing event rdev_rfkill_poll: OK
[  133.402948] Testing event rdev_get_antenna: OK
[  133.472999] Testing event rdev_get_ringparam: OK
[  133.527262] Testing event rdev_return_void: OK
[  133.578053] Testing event rdev_resume: OK
[  133.626452] Testing event rdev_scan: OK
[  133.675507] Testing event rdev_return_int: OK
[  133.833512] Testing event rdev_suspend: OK
[  133.897241] Testing event api_radar_detected: OK
[  133.975481] Testing event drv_set_default_unicast_key: OK
[  134.033107] Testing event stop_queue: OK
[  134.097638] Testing event wake_queue: OK
[  134.188365] Testing event api_eosp: OK
[  134.255082] Testing event api_enable_rssi_reports: OK
[  134.315823] Testing event api_gtk_rekey_notify: OK
[  134.388767] Testing event api_remain_on_channel_expired: OK
[  134.447644] Testing event api_ready_on_channel: OK
[  134.497551] Testing event api_chswitch_done: OK
[  134.553449] Testing event api_sta_block_awake: OK
[  134.607448] Testing event api_sched_scan_stopped: OK
[  134.669923] Testing event api_sched_scan_results: OK
[  134.733469] Testing event api_scan_completed: OK
[  134.787547] Testing event api_cqm_rssi_notify: OK
[  134.833937] Testing event api_connection_loss: OK
[  134.883622] Testing event api_beacon_loss: OK
[  134.928438] Testing event api_restart_hw: OK
[  134.979464] Testing event api_stop_tx_ba_cb: OK
[  135.025869] Testing event api_stop_tx_ba_session: OK
[  135.096240] Testing event api_start_tx_ba_cb: OK
[  135.147253] Testing event api_start_tx_ba_session: OK
[  135.208795] Testing event drv_restart_complete: OK
[  135.267401] Testing event drv_stop_ap: OK
[  135.316306] Testing event drv_start_ap: OK
[  135.373724] Testing event drv_unassign_vif_chanctx: OK
[  135.413524] Testing event drv_assign_vif_chanctx: OK
[  135.453863] Testing event drv_change_chanctx: OK
[  135.503965] Testing event drv_remove_chanctx: OK
[  135.575132] Testing event drv_add_chanctx: OK
[  135.634042] Testing event drv_mgd_prepare_tx: OK
[  135.697333] Testing event drv_get_rssi: OK
[  135.748401] Testing event drv_allow_buffered_frames: OK
[  135.828275] Testing event drv_release_buffered_frames: OK
[  135.898141] Testing event drv_rssi_callback: OK
[  135.953383] Testing event drv_set_rekey_data: OK
[  136.015335] Testing event drv_set_bitrate_mask: OK
[  136.075162] Testing event drv_offchannel_tx_cancel_wait: OK
[  136.130945] Testing event drv_tx_frames_pending: OK
[  136.227483] Testing event drv_get_ringparam: OK
[  136.274819] Testing event drv_set_ringparam: OK
[  136.326623] Testing event drv_cancel_remain_on_channel: OK
[  136.393676] Testing event drv_remain_on_channel: OK
[  136.433736] Testing event drv_get_antenna: OK
[  136.473690] Testing event drv_set_antenna: OK
[  136.513622] Testing event drv_channel_switch: OK
[  136.553667] Testing event drv_flush: OK
[  136.593442] Testing event drv_get_survey: OK
[  136.636714] Testing event drv_ampdu_action: OK
[  136.684202] Testing event drv_tx_last_beacon: OK
[  136.723703] Testing event drv_reset_tsf: OK
[  136.763821] Testing event drv_set_tsf: OK
[  136.804125] Testing event drv_get_tsf: OK
[  136.857466] Testing event drv_conf_tx: OK
[  136.924369] Testing event drv_sta_remove: OK
[  136.973745] Testing event drv_sta_add: OK
[  137.013986] Testing event drv_sta_rc_update: OK
[  137.056944] Testing event drv_sta_state: OK
[  137.105529] Testing event drv_sta_notify: OK
[  137.173621] Testing event drv_set_coverage_class: OK
[  137.213427] Testing event drv_set_rts_threshold: OK
[  137.253746] Testing event drv_set_frag_threshold: OK
[  137.293625] Testing event drv_get_tkip_seq: OK
[  137.333522] Testing event drv_get_stats: OK
[  137.373579] Testing event drv_sw_scan_complete: OK
[  137.424848] Testing event drv_sw_scan_start: OK
[  137.463556] Testing event drv_sched_scan_stop: OK
[  137.503486] Testing event drv_sched_scan_start: OK
[  137.555312] Testing event drv_cancel_hw_scan: OK
[  137.603530] Testing event drv_hw_scan: OK
[  137.643859] Testing event drv_update_tkip_key: OK
[  137.693596] Testing event drv_set_key: OK
[  137.733624] Testing event drv_set_tim: OK
[  137.774119] Testing event drv_configure_filter: OK
[  137.837964] Testing event drv_set_multicast_list: OK
[  137.921787] Testing event drv_prepare_multicast: OK
[  137.967582] Testing event drv_bss_info_changed: OK
[  138.032206] Testing event drv_config: OK
[  138.087821] Testing event drv_remove_interface: OK
[  138.144750] Testing event drv_change_interface: OK
[  138.241878] Testing event drv_add_interface: OK
[  138.306829] Testing event drv_stop: OK
[  138.358727] Testing event drv_set_wakeup: OK
[  138.454393] Testing event drv_resume: OK
[  138.534172] Testing event drv_suspend: OK
[  138.610280] Testing event drv_get_et_stats: OK
[  138.673306] Testing event drv_get_et_sset_count: OK
[  138.735597] Testing event drv_get_et_strings: OK
[  138.811555] Testing event drv_start: OK
[  138.867907] Testing event drv_return_u64: OK
[  138.924237] Testing event drv_return_bool: OK
[  138.983623] Testing event drv_return_int: OK
[  139.063222] Testing event drv_return_void: OK
[  139.241795] Testing event 9p_protocol_dump: OK
[  139.322507] Testing event 9p_client_res: OK
[  139.398175] Testing event 9p_client_req: OK
[  139.460228] Running tests on trace event systems:
[  139.460893] Testing event system 9p: OK
[  139.554491] Testing event system mac80211: OK
[  140.245795] Testing event system cfg80211: OK
[  141.214815] Testing event system skb: OK
[  141.277602] Testing event system net: OK
[  141.369716] Testing event system napi: OK
[  141.444789] Testing event system sock: OK
[  141.508599] Testing event system udp: OK
[  141.567952] Testing event system bcache: OK
[  141.701064] Testing event system regmap: OK
[  141.846122] Testing event system random: OK
[  141.933990] Testing event system gpio: OK
[  141.994975] Testing event system block: OK
[  142.163535] Testing event system btrfs: OK
[  142.453113] Testing event system xfs: OK
[  144.610929] Testing event system jbd2: OK
[  144.721187] Testing event system ext4: OK
[  144.996987] Testing event system writeback: OK
[  145.114819] Testing event system migrate: OK
[  145.174456] Testing event system compaction: OK
[  145.225848] Testing event system kmem: OK
[  145.308017] Testing event system vmscan: OK
[  145.381512] Testing event system oom: OK
[  145.434399] Testing event system filemap: OK
[  145.485541] Testing event system rpm: OK
[  145.537559] Testing event system power: OK
[  145.610983] Testing event system test: OK
[  145.654716] Testing event system lock: OK
[  145.706145] Testing event system sched: OK
[  145.787984] Testing event system rcu: OK
[  145.906639] Testing event system workqueue: OK
[  145.970236] Testing event system signal: OK
[  146.016534] Testing event system timer: OK
[  146.086961] Testing event system irq: OK
[  146.148704] Testing event system printk: OK
[  146.194482] Testing event system task: OK
[  146.245373] Testing event system irq_vectors: OK
[  146.344527] Testing event system raw_syscalls: OK
[  146.396713] Testing event system syscalls: OK
[  146.448196] Running tests on all trace events:
[  146.448908] Testing all events: OK
[  157.291347] Testing ftrace filter: OK
[  157.311408] Key type encrypted registered
[  157.312277] raid6test: testing the 4-disk case...
[  157.312894] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
[  157.313739] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(P)  OK
[  157.314565] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(Q)  OK
[  157.315392] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(P)  OK
[  157.320300] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(Q)  OK
[  157.321136] raid6test: test_disks(2, 3): faila=  2(P)  failb=  3(Q)  OK
[  157.321988] raid6test: testing the 5-disk case...
[  157.322587] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
[  157.323408] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D)  OK
[  157.324253] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(P)  OK
[  157.325047] raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(Q)  OK
[  157.325867] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D)  OK
[  157.326662] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(P)  OK
[  157.327403] raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(Q)  OK
[  157.328206] raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(P)  OK
[  157.329092] raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(Q)  OK
[  157.329855] raid6test: test_disks(3, 4): faila=  3(P)  failb=  4(Q)  OK
[  157.330844] raid6test: testing the 11-disk case...
[  157.331481] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
[  157.332267] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D)  OK
[  157.333118] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(D)  OK
[  157.333940] raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(D)  OK
[  157.337554] raid6test: test_disks(0, 5): faila=  0(D)  failb=  5(D)  OK
[  157.338376] raid6test: test_disks(0, 6): faila=  0(D)  failb=  6(D)  OK
[  157.339238] raid6test: test_disks(0, 7): faila=  0(D)  failb=  7(D)  OK
[  157.340110] raid6test: test_disks(0, 8): faila=  0(D)  failb=  8(D)  OK
[  157.341025] raid6test: test_disks(0, 9): faila=  0(D)  failb=  9(P)  OK
[  157.341813] raid6test: test_disks(0, 10): faila=  0(D)  failb= 10(Q)  OK
[  157.342661] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D)  OK
[  157.343506] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(D)  OK
[  157.344357] raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(D)  OK
[  157.345206] raid6test: test_disks(1, 5): faila=  1(D)  failb=  5(D)  OK
[  157.346085] raid6test: test_disks(1, 6): faila=  1(D)  failb=  6(D)  OK
[  157.348978] raid6test: test_disks(1, 7): faila=  1(D)  failb=  7(D)  OK
[  157.349814] raid6test: test_disks(1, 8): faila=  1(D)  failb=  8(D)  OK
[  157.350735] raid6test: test_disks(1, 9): faila=  1(D)  failb=  9(P)  OK
[  157.351616] raid6test: test_disks(1, 10): faila=  1(D)  failb= 10(Q)  OK
[  157.352439] raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(D)  OK
[  157.353217] raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(D)  OK
[  157.354029] raid6test: test_disks(2, 5): faila=  2(D)  failb=  5(D)  OK
[  157.354831] raid6test: test_disks(2, 6): faila=  2(D)  failb=  6(D)  OK
[  157.355645] raid6test: test_disks(2, 7): faila=  2(D)  failb=  7(D)  OK
[  157.356443] raid6test: test_disks(2, 8): faila=  2(D)  failb=  8(D)  OK
[  157.357650] raid6test: test_disks(2, 9): faila=  2(D)  failb=  9(P)  OK
[  157.358446] raid6test: test_disks(2, 10): faila=  2(D)  failb= 10(Q)  OK
[  157.359322] raid6test: test_disks(3, 4): faila=  3(D)  failb=  4(D)  OK
[  157.360270] raid6test: test_disks(3, 5): faila=  3(D)  failb=  5(D)  OK
[  157.361122] raid6test: test_disks(3, 6): faila=  3(D)  failb=  6(D)  OK
[  157.361954] raid6test: test_disks(3, 7): faila=  3(D)  failb=  7(D)  OK
[  157.362827] raid6test: test_disks(3, 8): faila=  3(D)  failb=  8(D)  OK
[  157.363685] raid6test: test_disks(3, 9): faila=  3(D)  failb=  9(P)  OK
[  157.364471] raid6test: test_disks(3, 10): faila=  3(D)  failb= 10(Q)  OK
[  157.365259] raid6test: test_disks(4, 5): faila=  4(D)  failb=  5(D)  OK
[  157.366059] raid6test: test_disks(4, 6): faila=  4(D)  failb=  6(D)  OK
[  157.366879] raid6test: test_disks(4, 7): faila=  4(D)  failb=  7(D)  OK
[  157.367645] raid6test: test_disks(4, 8): faila=  4(D)  failb=  8(D)  OK
[  157.368435] raid6test: test_disks(4, 9): faila=  4(D)  failb=  9(P)  OK
[  157.369267] raid6test: test_disks(4, 10): faila=  4(D)  failb= 10(Q)  OK
[  157.370185] raid6test: test_disks(5, 6): faila=  5(D)  failb=  6(D)  OK
[  157.371090] raid6test: test_disks(5, 7): faila=  5(D)  failb=  7(D)  OK
[  157.371963] raid6test: test_disks(5, 8): faila=  5(D)  failb=  8(D)  OK
[  157.372751] raid6test: test_disks(5, 9): faila=  5(D)  failb=  9(P)  OK
[  157.373594] raid6test: test_disks(5, 10): faila=  5(D)  failb= 10(Q)  OK
[  157.374430] raid6test: test_disks(6, 7): faila=  6(D)  failb=  7(D)  OK
[  157.375261] raid6test: test_disks(6, 8): faila=  6(D)  failb=  8(D)  OK
[  157.377481] raid6test: test_disks(6, 9): faila=  6(D)  failb=  9(P)  OK
[  157.378304] raid6test: test_disks(6, 10): faila=  6(D)  failb= 10(Q)  OK
[  157.379108] raid6test: test_disks(7, 8): faila=  7(D)  failb=  8(D)  OK
[  157.379926] raid6test: test_disks(7, 9): faila=  7(D)  failb=  9(P)  OK
[  157.380792] raid6test: test_disks(7, 10): faila=  7(D)  failb= 10(Q)  OK
[  157.381700] raid6test: test_disks(8, 9): faila=  8(D)  failb=  9(P)  OK
[  157.382539] raid6test: test_disks(8, 10): faila=  8(D)  failb= 10(Q)  OK
[  157.383348] raid6test: test_disks(9, 10): faila=  9(P)  failb= 10(Q)  OK
[  157.384328] raid6test: testing the 12-disk case...
[  157.384977] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
[  157.385856] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D)  OK
[  157.386675] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(D)  OK
[  157.387428] raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(D)  OK
[  157.388223] raid6test: test_disks(0, 5): faila=  0(D)  failb=  5(D)  OK
[  157.389177] raid6test: test_disks(0, 6): faila=  0(D)  failb=  6(D)  OK
[  157.390120] raid6test: test_disks(0, 7): faila=  0(D)  failb=  7(D)  OK
[  157.391001] raid6test: test_disks(0, 8): faila=  0(D)  failb=  8(D)  OK
[  157.391866] raid6test: test_disks(0, 9): faila=  0(D)  failb=  9(D)  OK
[  157.392663] raid6test: test_disks(0, 10): faila=  0(D)  failb= 10(P)  OK
[  157.393464] raid6test: test_disks(0, 11): faila=  0(D)  failb= 11(Q)  OK
[  157.394338] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D)  OK
[  157.395176] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(D)  OK
[  157.396028] raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(D)  OK
[  157.396921] raid6test: test_disks(1, 5): faila=  1(D)  failb=  5(D)  OK
[  157.397785] raid6test: test_disks(1, 6): faila=  1(D)  failb=  6(D)  OK
[  157.398579] raid6test: test_disks(1, 7): faila=  1(D)  failb=  7(D)  OK
[  157.399408] raid6test: test_disks(1, 8): faila=  1(D)  failb=  8(D)  OK
[  157.400269] raid6test: test_disks(1, 9): faila=  1(D)  failb=  9(D)  OK
[  157.401273] raid6test: test_disks(1, 10): faila=  1(D)  failb= 10(P)  OK
[  157.402055] raid6test: test_disks(1, 11): faila=  1(D)  failb= 11(Q)  OK
[  157.402891] raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(D)  OK
[  157.403762] raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(D)  OK
[  157.404674] raid6test: test_disks(2, 5): faila=  2(D)  failb=  5(D)  OK
[  157.405583] raid6test: test_disks(2, 6): faila=  2(D)  failb=  6(D)  OK
[  157.406500] raid6test: test_disks(2, 7): faila=  2(D)  failb=  7(D)  OK
[  157.407354] raid6test: test_disks(2, 8): faila=  2(D)  failb=  8(D)  OK
[  157.408222] raid6test: test_disks(2, 9): faila=  2(D)  failb=  9(D)  OK
[  157.409019] raid6test: test_disks(2, 10): faila=  2(D)  failb= 10(P)  OK
[  157.409848] raid6test: test_disks(2, 11): faila=  2(D)  failb= 11(Q)  OK
[  157.410780] raid6test: test_disks(3, 4): faila=  3(D)  failb=  4(D)  OK
[  157.411600] raid6test: test_disks(3, 5): faila=  3(D)  failb=  5(D)  OK
[  157.412381] raid6test: test_disks(3, 6): faila=  3(D)  failb=  6(D)  OK
[  157.413266] raid6test: test_disks(3, 7): faila=  3(D)  failb=  7(D)  OK
[  157.414151] raid6test: test_disks(3, 8): faila=  3(D)  failb=  8(D)  OK
[  157.415181] raid6test: test_disks(3, 9): faila=  3(D)  failb=  9(D)  OK
[  157.416084] raid6test: test_disks(3, 10): faila=  3(D)  failb= 10(P)  OK
[  157.416995] raid6test: test_disks(3, 11): faila=  3(D)  failb= 11(Q)  OK
[  157.417926] raid6test: test_disks(4, 5): faila=  4(D)  failb=  5(D)  OK
[  157.418842] raid6test: test_disks(4, 6): faila=  4(D)  failb=  6(D)  OK
[  157.419737] raid6test: test_disks(4, 7): faila=  4(D)  failb=  7(D)  OK
[  157.420777] raid6test: test_disks(4, 8): faila=  4(D)  failb=  8(D)  OK
[  157.421598] raid6test: test_disks(4, 9): faila=  4(D)  failb=  9(D)  OK
[  157.422455] raid6test: test_disks(4, 10): faila=  4(D)  failb= 10(P)  OK
[  157.423270] raid6test: test_disks(4, 11): faila=  4(D)  failb= 11(Q)  OK
[  157.424142] raid6test: test_disks(5, 6): faila=  5(D)  failb=  6(D)  OK
[  157.425009] raid6test: test_disks(5, 7): faila=  5(D)  failb=  7(D)  OK
[  157.425907] raid6test: test_disks(5, 8): faila=  5(D)  failb=  8(D)  OK
[  157.426804] raid6test: test_disks(5, 9): faila=  5(D)  failb=  9(D)  OK
[  157.427700] raid6test: test_disks(5, 10): faila=  5(D)  failb= 10(P)  OK
[  157.428598] raid6test: test_disks(5, 11): faila=  5(D)  failb= 11(Q)  OK
[  157.429429] raid6test: test_disks(6, 7): faila=  6(D)  failb=  7(D)  OK
[  157.430287] raid6test: test_disks(6, 8): faila=  6(D)  failb=  8(D)  OK
[  157.431041] raid6test: test_disks(6, 9): faila=  6(D)  failb=  9(D)  OK
[  157.431731] raid6test: test_disks(6, 10): faila=  6(D)  failb= 10(P)  OK
[  157.432411] raid6test: test_disks(6, 11): faila=  6(D)  failb= 11(Q)  OK
[  157.433120] raid6test: test_disks(7, 8): faila=  7(D)  failb=  8(D)  OK
[  157.433819] raid6test: test_disks(7, 9): faila=  7(D)  failb=  9(D)  OK
[  157.434505] raid6test: test_disks(7, 10): faila=  7(D)  failb= 10(P)  OK
[  157.435321] raid6test: test_disks(7, 11): faila=  7(D)  failb= 11(Q)  OK
[  157.436146] raid6test: test_disks(8, 9): faila=  8(D)  failb=  9(D)  OK
[  157.437136] raid6test: test_disks(8, 10): faila=  8(D)  failb= 10(P)  OK
[  157.437990] raid6test: test_disks(8, 11): faila=  8(D)  failb= 11(Q)  OK
[  157.438848] raid6test: test_disks(9, 10): faila=  9(D)  failb= 10(P)  OK
[  157.439722] raid6test: test_disks(9, 11): faila=  9(D)  failb= 11(Q)  OK
[  157.440580] raid6test: test_disks(10, 11): faila= 10(P)  failb= 11(Q)  OK
[  157.441578] raid6test: testing the 16-disk case...
[  157.442173] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
[  157.443028] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D)  OK
[  157.443890] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(D)  OK
[  157.444731] raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(D)  OK
[  157.445633] raid6test: test_disks(0, 5): faila=  0(D)  failb=  5(D)  OK
[  157.446545] raid6test: test_disks(0, 6): faila=  0(D)  failb=  6(D)  OK
[  157.447455] raid6test: test_disks(0, 7): faila=  0(D)  failb=  7(D)  OK
[  157.448361] raid6test: test_disks(0, 8): faila=  0(D)  failb=  8(D)  OK
[  157.449228] raid6test: test_disks(0, 9): faila=  0(D)  failb=  9(D)  OK
[  157.450205] raid6test: test_disks(0, 10): faila=  0(D)  failb= 10(D)  OK
[  157.451109] raid6test: test_disks(0, 11): faila=  0(D)  failb= 11(D)  OK
[  157.452002] raid6test: test_disks(0, 12): faila=  0(D)  failb= 12(D)  OK
[  157.452917] raid6test: test_disks(0, 13): faila=  0(D)  failb= 13(D)  OK
[  157.453776] raid6test: test_disks(0, 14): faila=  0(D)  failb= 14(P)  OK
[  157.454587] raid6test: test_disks(0, 15): faila=  0(D)  failb= 15(Q)  OK
[  157.455471] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D)  OK
[  157.456333] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(D)  OK
[  157.457193] raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(D)  OK
[  157.458037] raid6test: test_disks(1, 5): faila=  1(D)  failb=  5(D)  OK
[  157.458919] raid6test: test_disks(1, 6): faila=  1(D)  failb=  6(D)  OK
[  157.459797] raid6test: test_disks(1, 7): faila=  1(D)  failb=  7(D)  OK
[  157.460758] raid6test: test_disks(1, 8): faila=  1(D)  failb=  8(D)  OK
[  157.461544] raid6test: test_disks(1, 9): faila=  1(D)  failb=  9(D)  OK
[  157.462325] raid6test: test_disks(1, 10): faila=  1(D)  failb= 10(D)  OK
[  157.463227] raid6test: test_disks(1, 11): faila=  1(D)  failb= 11(D)  OK
[  157.464129] raid6test: test_disks(1, 12): faila=  1(D)  failb= 12(D)  OK
[  157.465731] raid6test: test_disks(1, 13): faila=  1(D)  failb= 13(D)  OK
[  157.466644] raid6test: test_disks(1, 14): faila=  1(D)  failb= 14(P)  OK
[  157.467461] raid6test: test_disks(1, 15): faila=  1(D)  failb= 15(Q)  OK
[  157.468239] raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(D)  OK
[  157.469183] raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(D)  OK
[  157.470037] raid6test: test_disks(2, 5): faila=  2(D)  failb=  5(D)  OK
[  157.470901] raid6test: test_disks(2, 6): faila=  2(D)  failb=  6(D)  OK
[  157.471804] raid6test: test_disks(2, 7): faila=  2(D)  failb=  7(D)  OK
[  157.472720] raid6test: test_disks(2, 8): faila=  2(D)  failb=  8(D)  OK
[  157.473638] raid6test: test_disks(2, 9): faila=  2(D)  failb=  9(D)  OK
[  157.476596] raid6test: test_disks(2, 10): faila=  2(D)  failb= 10(D)  OK
[  157.477479] raid6test: test_disks(2, 11): faila=  2(D)  failb= 11(D)  OK
[  157.478332] raid6test: test_disks(2, 12): faila=  2(D)  failb= 12(D)  OK
[  157.479159] raid6test: test_disks(2, 13): faila=  2(D)  failb= 13(D)  OK
[  157.480000] raid6test: test_disks(2, 14): faila=  2(D)  failb= 14(P)  OK
[  157.480988] raid6test: test_disks(2, 15): faila=  2(D)  failb= 15(Q)  OK
[  157.481786] raid6test: test_disks(3, 4): faila=  3(D)  failb=  4(D)  OK
[  157.482606] raid6test: test_disks(3, 5): faila=  3(D)  failb=  5(D)  OK
[  157.483415] raid6test: test_disks(3, 6): faila=  3(D)  failb=  6(D)  OK
[  157.484288] raid6test: test_disks(3, 7): faila=  3(D)  failb=  7(D)  OK
[  157.485101] raid6test: test_disks(3, 8): faila=  3(D)  failb=  8(D)  OK
[  157.486085] raid6test: test_disks(3, 9): faila=  3(D)  failb=  9(D)  OK
[  157.486910] raid6test: test_disks(3, 10): faila=  3(D)  failb= 10(D)  OK
[  157.487779] raid6test: test_disks(3, 11): faila=  3(D)  failb= 11(D)  OK
[  157.488693] raid6test: test_disks(3, 12): faila=  3(D)  failb= 12(D)  OK
[  157.490689] raid6test: test_disks(3, 13): faila=  3(D)  failb= 13(D)  OK
[  157.491621] raid6test: test_disks(3, 14): faila=  3(D)  failb= 14(P)  OK
[  157.492412] raid6test: test_disks(3, 15): faila=  3(D)  failb= 15(Q)  OK
[  157.493259] raid6test: test_disks(4, 5): faila=  4(D)  failb=  5(D)  OK
[  157.494078] raid6test: test_disks(4, 6): faila=  4(D)  failb=  6(D)  OK
[  157.496187] raid6test: test_disks(4, 7): faila=  4(D)  failb=  7(D)  OK
[  157.497098] raid6test: test_disks(4, 8): faila=  4(D)  failb=  8(D)  OK
[  157.498017] raid6test: test_disks(4, 9): faila=  4(D)  failb=  9(D)  OK
[  157.498918] raid6test: test_disks(4, 10): faila=  4(D)  failb= 10(D)  OK
[  157.499950] raid6test: test_disks(4, 11): faila=  4(D)  failb= 11(D)  OK
[  157.500833] raid6test: test_disks(4, 12): faila=  4(D)  failb= 12(D)  OK
[  157.501681] raid6test: test_disks(4, 13): faila=  4(D)  failb= 13(D)  OK
[  157.502553] raid6test: test_disks(4, 14): faila=  4(D)  failb= 14(P)  OK
[  157.503453] raid6test: test_disks(4, 15): faila=  4(D)  failb= 15(Q)  OK
[  157.504395] raid6test: test_disks(5, 6): faila=  5(D)  failb=  6(D)  OK
[  157.505312] raid6test: test_disks(5, 7): faila=  5(D)  failb=  7(D)  OK
[  157.506229] raid6test: test_disks(5, 8): faila=  5(D)  failb=  8(D)  OK
[  157.507151] raid6test: test_disks(5, 9): faila=  5(D)  failb=  9(D)  OK
[  157.508060] raid6test: test_disks(5, 10): faila=  5(D)  failb= 10(D)  OK
[  157.508993] raid6test: test_disks(5, 11): faila=  5(D)  failb= 11(D)  OK
[  157.509865] raid6test: test_disks(5, 12): faila=  5(D)  failb= 12(D)  OK
[  157.510830] raid6test: test_disks(5, 13): faila=  5(D)  failb= 13(D)  OK
[  157.511698] raid6test: test_disks(5, 14): faila=  5(D)  failb= 14(P)  OK
[  157.512547] raid6test: test_disks(5, 15): faila=  5(D)  failb= 15(Q)  OK
[  157.513430] raid6test: test_disks(6, 7): faila=  6(D)  failb=  7(D)  OK
[  157.514282] raid6test: test_disks(6, 8): faila=  6(D)  failb=  8(D)  OK
[  157.515168] raid6test: test_disks(6, 9): faila=  6(D)  failb=  9(D)  OK
[  157.516077] raid6test: test_disks(6, 10): faila=  6(D)  failb= 10(D)  OK
[  157.517003] raid6test: test_disks(6, 11): faila=  6(D)  failb= 11(D)  OK
[  157.517936] raid6test: test_disks(6, 12): faila=  6(D)  failb= 12(D)  OK
[  157.518874] raid6test: test_disks(6, 13): faila=  6(D)  failb= 13(D)  OK
[  157.519743] raid6test: test_disks(6, 14): faila=  6(D)  failb= 14(P)  OK
[  157.520633] raid6test: test_disks(6, 15): faila=  6(D)  failb= 15(Q)  OK
[  157.521546] raid6test: test_disks(7, 8): faila=  7(D)  failb=  8(D)  OK
[  157.522424] raid6test: test_disks(7, 9): faila=  7(D)  failb=  9(D)  OK
[  157.523322] raid6test: test_disks(7, 10): faila=  7(D)  failb= 10(D)  OK
[  157.524244] raid6test: test_disks(7, 11): faila=  7(D)  failb= 11(D)  OK
[  157.525106] raid6test: test_disks(7, 12): faila=  7(D)  failb= 12(D)  OK
[  157.525974] raid6test: test_disks(7, 13): faila=  7(D)  failb= 13(D)  OK
[  157.526807] raid6test: test_disks(7, 14): faila=  7(D)  failb= 14(P)  OK
[  157.527651] raid6test: test_disks(7, 15): faila=  7(D)  failb= 15(Q)  OK
[  157.528529] raid6test: test_disks(8, 9): faila=  8(D)  failb=  9(D)  OK
[  157.529363] raid6test: test_disks(8, 10): faila=  8(D)  failb= 10(D)  OK
[  157.530327] raid6test: test_disks(8, 11): faila=  8(D)  failb= 11(D)  OK
[  157.531230] raid6test: test_disks(8, 12): faila=  8(D)  failb= 12(D)  OK
[  157.532121] raid6test: test_disks(8, 13): faila=  8(D)  failb= 13(D)  OK
[  157.532927] raid6test: test_disks(8, 14): faila=  8(D)  failb= 14(P)  OK
[  157.533727] raid6test: test_disks(8, 15): faila=  8(D)  failb= 15(Q)  OK
[  157.534564] raid6test: test_disks(9, 10): faila=  9(D)  failb= 10(D)  OK
[  157.535450] raid6test: test_disks(9, 11): faila=  9(D)  failb= 11(D)  OK
[  157.536372] raid6test: test_disks(9, 12): faila=  9(D)  failb= 12(D)  OK
[  157.537298] raid6test: test_disks(9, 13): faila=  9(D)  failb= 13(D)  OK
[  157.538218] raid6test: test_disks(9, 14): faila=  9(D)  failb= 14(P)  OK
[  157.539085] raid6test: test_disks(9, 15): faila=  9(D)  failb= 15(Q)  OK
[  157.539932] raid6test: test_disks(10, 11): faila= 10(D)  failb= 11(D)  OK
[  157.541007] raid6test: test_disks(10, 12): faila= 10(D)  failb= 12(D)  OK
[  157.541894] raid6test: test_disks(10, 13): faila= 10(D)  failb= 13(D)  OK
[  157.542777] raid6test: test_disks(10, 14): faila= 10(D)  failb= 14(P)  OK
[  157.543654] raid6test: test_disks(10, 15): faila= 10(D)  failb= 15(Q)  OK
[  157.544553] raid6test: test_disks(11, 12): faila= 11(D)  failb= 12(D)  OK
[  157.545447] raid6test: test_disks(11, 13): faila= 11(D)  failb= 13(D)  OK
[  157.546294] raid6test: test_disks(11, 14): faila= 11(D)  failb= 14(P)  OK
[  157.547134] raid6test: test_disks(11, 15): faila= 11(D)  failb= 15(Q)  OK
[  157.548018] raid6test: test_disks(12, 13): faila= 12(D)  failb= 13(D)  OK
[  157.548839] raid6test: test_disks(12, 14): faila= 12(D)  failb= 14(P)  OK
[  157.549714] raid6test: test_disks(12, 15): faila= 12(D)  failb= 15(Q)  OK
[  157.552332] raid6test: test_disks(13, 14): faila= 13(D)  failb= 14(P)  OK
[  157.553251] raid6test: test_disks(13, 15): faila= 13(D)  failb= 15(Q)  OK
[  157.554153] raid6test: test_disks(14, 15): faila= 14(P)  failb= 15(Q)  OK
[  157.555020] raid6test: 
[  157.555339] raid6test: complete (257 tests, 0 failures)
[  157.570638] console [netcon0] enabled
[  157.571138] netconsole: network logging started
[  157.571744] rtc-test rtc-test.0: setting system clock to 2013-06-21 21:50:21 UTC (1371851421)
[  157.574417] Freeing unused kernel memory: 932k freed
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
 * Asking all remaining processes to terminate...       
killall5[2089]: mount returned non-zero exit status
killall5[2089]: /proc not mounted, failed to mount.

[  217.804031] initctl (2094) used greatest stack depth: 6436 bytes left
mount: proc has wrong device number or fs type proc not supported
killall5[2097]: mount returned non-zero exit status
killall5[2097]: /proc not mounted, failed to mount.
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
 * Will now restart
[  223.174270] Unregister pv shared memory for cpu 0
[  223.171553] Unregister pv shared memory for cpu 1
[  223.185421] Restarting system.
[  223.185760] reboot: machine restart
Elapsed time: 225

--yNb1oOkm5a9FJOVX
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="bisect-cf910e83ae23692fdeefc7e506e504c4c468d38a-i386-randconfig-r00-0621-INFO:-suspicious-RCU-usage--113135.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IGNmOTEwZTgzYWUyMzY5MmZkZWVmYzdlNTA2ZTUwNGM0YzQ2OGQzOGEK
SEVBRCBpcyBub3cgYXQgY2Y5MTBlOC4uLiB4ODYsIHRyYWNlOiBBZGQgaXJxIHZlY3RvciB0
cmFjZXBvaW50cwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5k
Y29uZmlnLXIwMC0wNjIxL3RpcDp4ODY6dHJhY2U6Y2Y5MTBlODNhZTIzNjkyZmRlZWZjN2U1
MDZlNTA0YzRjNDY4ZDM4YTpiaXNlY3Qtc3RhYmxlCiBURVNUIEZBSUxVUkUKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctcjAwLTA2MjEvY2Y5MTBlODNhZTIzNjkyZmRlZWZjN2U1MDZlNTA0
YzRjNDY4ZDM4YS9kbWVzZy1rdm0ta2J1aWxkLTYyMjUtMjAxMzA2MjIwNTUxMjktMy4xMC4w
LXJjNi0wMDAwNC1nY2Y5MTBlOC0xOTAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAwLTA2
MjEvY2Y5MTBlODNhZTIzNjkyZmRlZWZjN2U1MDZlNTA0YzRjNDY4ZDM4YS9kbWVzZy1rdm0t
bGtwLW5leDA0LTIwODEtMjAxMzA2MjIxNTI3NTYtMy4xMC4wLXJjNi0wMDAwNC1nY2Y5MTBl
OC0xOTAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAwLTA2MjEvY2Y5MTBlODNhZTIzNjky
ZmRlZWZjN2U1MDZlNTA0YzRjNDY4ZDM4YS9kbWVzZy1rdm0tc25iLTE0NzI1LTIwMTMwNjIy
MDUyMzUwLTMuMTAuMC1yYzYtMDAwMDQtZ2NmOTEwZTgtMTg5Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXIwMC0wNjIxL2NmOTEwZTgzYWUyMzY5MmZkZWVmYzdlNTA2ZTUwNGM0YzQ2OGQz
OGEvZG1lc2cta3ZtLXNuYi0xOTM1My0yMDEzMDYyMjA1MjMyMi0zLjEwLjAtcmM2LTAwMDA0
LWdjZjkxMGU4LTE4OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMDAtMDYyMS9jZjkxMGU4
M2FlMjM2OTJmZGVlZmM3ZTUwNmU1MDRjNGM0NjhkMzhhL2RtZXNnLWt2bS1zbmItMjU1Nzct
MjAxMzA2MjIwNjAwMjUtMy4xMC4wLXJjNi0wMDAwNC1nY2Y5MTBlOC0xOTAKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctcjAwLTA2MjEvY2Y5MTBlODNhZTIzNjkyZmRlZWZjN2U1MDZlNTA0
YzRjNDY4ZDM4YS9kbWVzZy1rdm0tc25iLTI3NTY1LTIwMTMwNjIyMDUyMzIyLTMuMTAuMC1y
YzYtMDAwMDQtZ2NmOTEwZTgtMTg5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIwMC0wNjIx
L2NmOTEwZTgzYWUyMzY5MmZkZWVmYzdlNTA2ZTUwNGM0YzQ2OGQzOGEvZG1lc2cta3ZtLXNu
Yi0zMjc4NC0yMDEzMDYyMjA1MjM0Ni0zLjEwLjAtcmM2LTAwMDA0LWdjZjkxMGU4LTE4OQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMDAtMDYyMS9jZjkxMGU4M2FlMjM2OTJmZGVlZmM3
ZTUwNmU1MDRjNGM0NjhkMzhhL2RtZXNnLWt2bS1zdG9ha2xleS01NjE5LTIwMTMwNjIyMDU1
MzUzLTMuMTAuMC1yYzYtMDAwMDQtZ2NmOTEwZTgtMTkwCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLXIwMC0wNjIxL2NmOTEwZTgzYWUyMzY5MmZkZWVmYzdlNTA2ZTUwNGM0YzQ2OGQzOGEv
ZG1lc2cta3ZtLXN0b2FrbGV5LTU3MjctMjAxMzA2MjIwNTUzMDYtMy4xMC4wLXJjNi0wMDAw
NC1nY2Y5MTBlOC0xOTAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAwLTA2MjEvY2Y5MTBl
ODNhZTIzNjkyZmRlZWZjN2U1MDZlNTA0YzRjNDY4ZDM4YS9kbWVzZy1rdm0tdnAtMTAyNjUt
MjAxMzA2MjIwNTIxMjItMy4xMC4wLXJjNi0wMDAwNC1nY2Y5MTBlOC0xODkKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctcjAwLTA2MjEvY2Y5MTBlODNhZTIzNjkyZmRlZWZjN2U1MDZlNTA0
YzRjNDY4ZDM4YS9kbWVzZy1rdm0tdnAtMTA4MDgtMjAxMzA2MjIwNTIxMTUtMy4xMC4wLXJj
Ni0wMDAwNC1nY2Y5MTBlOC0xODkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAwLTA2MjEv
Y2Y5MTBlODNhZTIzNjkyZmRlZWZjN2U1MDZlNTA0YzRjNDY4ZDM4YS9kbWVzZy1rdm0tdnAt
MTEwMDctMjAxMzA2MjIwNTU1MTQtMy4xMC4wLXJjNi0wMDAwNC1nY2Y5MTBlOC0xOTAKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctcjAwLTA2MjEvY2Y5MTBlODNhZTIzNjkyZmRlZWZjN2U1
MDZlNTA0YzRjNDY4ZDM4YS9kbWVzZy1rdm0tdnAtMTM2NjktMjAxMzA2MjIxNTI3NTUtMy4x
MC4wLXJjNi0wMDAwNC1nY2Y5MTBlOC0xOTAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAw
LTA2MjEvY2Y5MTBlODNhZTIzNjkyZmRlZWZjN2U1MDZlNTA0YzRjNDY4ZDM4YS9kbWVzZy1r
dm0tdnAtMTYxNjYtMjAxMzA2MjIwNTIxMzctMy4xMC4wLXJjNi0wMDAwNC1nY2Y5MTBlOC0x
ODkKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAwLTA2MjEvY2Y5MTBlODNhZTIzNjkyZmRl
ZWZjN2U1MDZlNTA0YzRjNDY4ZDM4YS9kbWVzZy1rdm0tdnAtMjE1NjEtMjAxMzA2MjIwNTIx
MjItMy4xMC4wLXJjNi0wMDAwNC1nY2Y5MTBlOC0xODkKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctcjAwLTA2MjEvY2Y5MTBlODNhZTIzNjkyZmRlZWZjN2U1MDZlNTA0YzRjNDY4ZDM4YS9k
bWVzZy1rdm0tdnAtNTIzMS0yMDEzMDYyMjA1MjEzNi0zLjEwLjAtcmM2LTAwMDA0LWdjZjkx
MGU4LTE4OQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMDAtMDYyMS9jZjkxMGU4M2FlMjM2
OTJmZGVlZmM3ZTUwNmU1MDRjNGM0NjhkMzhhL2RtZXNnLWt2bS14Z3dvLTMyMTktMjAxMzA2
MjIwNTU1NTktMy4xMC4wLXJjNi0wMDAwNC1nY2Y5MTBlOC0xOTAKCmJpc2VjdDogYmFkIGNv
bW1pdCBjZjkxMGU4M2FlMjM2OTJmZGVlZmM3ZTUwNmU1MDRjNGM0NjhkMzhhCmdpdCBjaGVj
a291dCB2My45ClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIGNmOTEwZTguLi4geDg2LCB0
cmFjZTogQWRkIGlycSB2ZWN0b3IgdHJhY2Vwb2ludHMKSEVBRCBpcyBub3cgYXQgYzFiZTVh
NS4uLiBMaW51eCAzLjkKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYt
cmFuZGNvbmZpZy1yMDAtMDYyMS90aXA6eDg2OnRyYWNlOmMxYmU1YTViMWIzNTVkNDBlNmNm
NzljYzk3OWViNjZkYWZhMjRhZDE6YmlzZWN0LXN0YWJsZQoKMjAxMy0wNi0yMi0xNToyODoy
MyBjMWJlNWE1YjFiMzU1ZDQwZTZjZjc5Y2M5NzllYjY2ZGFmYTI0YWQxIGNvbXBpbGluZwo0
MjkgcmVhbCAgMTQwMyB1c2VyICAxMzAgc3lzICAzNTcuNTIlIGNwdSAJaTM4Ni1yYW5kY29u
ZmlnLXIwMC0wNjIxCgoyMDEzLTA2LTIyLTE1OjM3OjQ3IGRldGVjdGluZyBib290IHN0YXRl
IDMuOS4wLi4uLi4uLi4uLi4JMi4JMwk1CTgJMTAJMTEuCTEzLgkxNS4JMTgJMjAJMjIJMjYu
CTI5CTM2CTM5Lgk0MAk0NQk0OAk1MiBTVUNDRVNTCgpiaXNlY3Q6IGdvb2QgY29tbWl0IHYz
LjkKZ2l0IGJpc2VjdCBzdGFydCBjZjkxMGU4M2FlMjM2OTJmZGVlZmM3ZTUwNmU1MDRjNGM0
NjhkMzhhIHYzLjkgLS0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgYzFiZTVhNS4uLiBM
aW51eCAzLjkKSEVBRCBpcyBub3cgYXQgNTIxY2I0MC4uLiBMaW51eCAyLjYuMzgKQmlzZWN0
aW5nOiA3MjA1IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAx
MyBzdGVwcykKW2ZiY2Q0ODM2ZDIwYTMzMjA5ODQzZGNmODRmODNhMzNiOTdiNzRjOWFdIFtT
Q1NJXSBxbGE0eHh4OiBBc3NpZ24gdmFsdWVzIHVzaW5nIGNvcnJlY3QgZGF0YXR5cGUKZ2l0
IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aCAvaG9tZS93Zmcvc3RhYmxlL29iai1iaXNlY3QKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9zdGFibGUvb2JqLWJpc2Vj
dApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXIw
MC0wNjIxL3RpcDp4ODY6dHJhY2U6ZmJjZDQ4MzZkMjBhMzMyMDk4NDNkY2Y4NGY4M2EzM2I5
N2I3NGM5YTpiaXNlY3Qtc3RhYmxlCgoyMDEzLTA2LTIyLTE1OjU2OjI1IGZiY2Q0ODM2ZDIw
YTMzMjA5ODQzZGNmODRmODNhMzNiOTdiNzRjOWEgY29tcGlsaW5nCjI4MCByZWFsICAxNTEx
IHVzZXIgIDEzNiBzeXMgIDU4Ny4yNSUgY3B1IAlpMzg2LXJhbmRjb25maWctcjAwLTA2MjEK
CjIwMTMtMDYtMjItMTY6MDI6NDQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy45LjAtMDcyMDUt
Z2ZiY2Q0ODMuLi4uLi4uLi4uCTIJNAk2CTcJMTEJMTcJMTgJMjIJMjQJMzAuCTMyCTMzCTM3
CTQ2CTQ5CTUwCTUyIFNVQ0NFU1MKCkJpc2VjdGluZzogMzU3MCByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTIgc3RlcHMpCls5MWY4NTc1Njg1ZTM1ZjNi
ZDAyMTI4NmJjODJkMjYzOTc0NThmNWE5XSBNZXJnZSBicmFuY2ggJ2Zvci1saW51cycgb2Yg
Z2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3NhZ2UvY2Vw
aC1jbGllbnQKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9ob21lL3dmZy9zdGFibGUvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXIwMC0wNjIxL3RpcDp4ODY6dHJhY2U6
OTFmODU3NTY4NWUzNWYzYmQwMjEyODZiYzgyZDI2Mzk3NDU4ZjVhOTpiaXNlY3Qtc3RhYmxl
CgoyMDEzLTA2LTIyLTE2OjE2OjQ4IDkxZjg1NzU2ODVlMzVmM2JkMDIxMjg2YmM4MmQyNjM5
NzQ1OGY1YTkgY29tcGlsaW5nCjE3NSByZWFsICAxNTE5IHVzZXIgIDE0OSBzeXMgIDk1My4z
MiUgY3B1IAlpMzg2LXJhbmRjb25maWctcjAwLTA2MjEKCjIwMTMtMDYtMjItMTY6MjA6NTIg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy45LjAtMTA4MDMtZzkxZjg1NzUuLi4uLi4uLi4uLgky
CTQJNgk5CTE0CTE4CTIxCTIyCTIzCTI2CTI3Li4JMzIJMzYJMzkJNDAJNDIuCTQ5CTUxLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4JNTIgU1VDQ0VTUwoKQmlzZWN0aW5nOiAxNzg2IHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMSBzdGVwcykKW2M0Y2M3NWMzMzIxY2FkNmYy
MGQxZTUzMjUyOTM4OTAyNTVjOGE2NjNdIE1lcmdlIGdpdDovL2dpdC5pbmZyYWRlYWQub3Jn
L3VzZXJzL2VwYXJpcy9hdWRpdApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVz
dC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3N0YWJsZS9vYmotYmlzZWN0CmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctcjAwLTA2MjEvdGlw
Ong4Njp0cmFjZTpjNGNjNzVjMzMyMWNhZDZmMjBkMWU1MzI1MjkzODkwMjU1YzhhNjYzOmJp
c2VjdC1zdGFibGUKCjIwMTMtMDYtMjItMTc6MDk6NTUgYzRjYzc1YzMzMjFjYWQ2ZjIwZDFl
NTMyNTI5Mzg5MDI1NWM4YTY2MyBjb21waWxpbmcKMTc3IHJlYWwgIDE1MTIgdXNlciAgMTM3
IHN5cyAgOTI4Ljc3JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1yMDAtMDYyMQoKMjAxMy0wNi0y
Mi0xNzoxMzoxMCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjkuMC0xMjU4Ny1nYzRjYzc1Yy4u
Li4uLi4uLi4JMQk0CTYJOQkxNgkxNwkyMwkyNAkyNgkzMAkzNQk0MAk0NAk0Nwk1MAk1MS4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4bWzE7MzVtYWRkX3RvX3J1bl9xdWV1ZSAx
G1swbQouLi4uLi4uLi4uLi4JNTIgU1VDQ0VTUwoKQmlzZWN0aW5nOiA4OTMgcmV2aXNpb25z
IGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEwIHN0ZXBzKQpbM2E1Mzk1YjNk
NTdiOWUzODM2Yzc1NTQzNGM4OGY0NTkwZDVlYTZmNl0gbmV0OiBldGhlcm5ldDogeGlsaW54
X2VtYWNsaXRlOiBzZXQgcHJvdG9jb2wgc2VsZWN0b3IgYml0cyB3aGVuIHdyaXRpbmcgQU5B
UgpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2hvbWUvd2ZnL3N0YWJsZS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctcjAwLTA2MjEvdGlwOng4Njp0cmFjZTozYTUzOTVi
M2Q1N2I5ZTM4MzZjNzU1NDM0Yzg4ZjQ1OTBkNWVhNmY2OmJpc2VjdC1zdGFibGUKCjIwMTMt
MDYtMjItMjA6MDM6MTUgM2E1Mzk1YjNkNTdiOWUzODM2Yzc1NTQzNGM4OGY0NTkwZDVlYTZm
NiBjb21waWxpbmcKMjE0IHJlYWwgIDE1MDYgdXNlciAgMTMwIHN5cyAgNzYyLjIyJSBjcHUg
CWkzODYtcmFuZGNvbmZpZy1yMDAtMDYyMQoKMjAxMy0wNi0yMi0yMDowNzowMiBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAzLjEwLjAtcmMyLTAwNDAwLWczYTUzOTViLi4uLi4uLi4uCTIJMwk3
CTE1CTMyCTUwLi4JNTEuCTUyIFNVQ0NFU1MKCkJpc2VjdGluZzogNDQ1IHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA5IHN0ZXBzKQpbZTYzOTViNjhhZDA5
YTgzNWYwNThkYTMxYmFkMGZlMjNkMzg4MjY1OV0gTWVyZ2UgdGFnICdmb3ItbGludXMtdjMu
MTAtcmM1JyBvZiBnaXQ6Ly9vc3Muc2dpLmNvbS94ZnMveGZzCnJ1bm5pbmcgL2Mva2VybmVs
LXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcvc3RhYmxlL29i
ai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNv
bmZpZy1yMDAtMDYyMS90aXA6eDg2OnRyYWNlOmU2Mzk1YjY4YWQwOWE4MzVmMDU4ZGEzMWJh
ZDBmZTIzZDM4ODI2NTk6YmlzZWN0LXN0YWJsZQoKMjAxMy0wNi0yMi0yMDoxNzowNCBlNjM5
NWI2OGFkMDlhODM1ZjA1OGRhMzFiYWQwZmUyM2QzODgyNjU5IGNvbXBpbGluZwoxNjMgcmVh
bCAgMTUwNCB1c2VyICAxMzEgc3lzICAxMDAwLjk3JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1y
MDAtMDYyMQoKMjAxMy0wNi0yMi0yMDoyMDowMiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEw
LjAtcmM0LTAwMTY0LWdlNjM5NWI2Li4uLi4uLi4uCTEJNAkxOQkyMQkyNgk1MAk1MiBTVUND
RVNTCgpCaXNlY3Rpbmc6IDIyMiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgOCBzdGVwcykKWzU0MDJiODA0N2IwZDI4NmI2NTAxZjkwOTc4OTFjYmYxZTA2
ZGFhM2FdIGxpYi9tcGkvbXBpY29kZXIuYzogbG9vcGluZyBpc3N1ZSwgbmVlZCBzdG9wIHdo
ZW4gZXF1YWwgdG8gemVybywgZm91bmQgYnkgJ0VYVFJBX0ZMQUdTPS1XJy4KcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9z
dGFibGUvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4
Ni1yYW5kY29uZmlnLXIwMC0wNjIxL3RpcDp4ODY6dHJhY2U6NTQwMmI4MDQ3YjBkMjg2YjY1
MDFmOTA5Nzg5MWNiZjFlMDZkYWEzYTpiaXNlY3Qtc3RhYmxlCgoyMDEzLTA2LTIyLTIwOjI4
OjA3IDU0MDJiODA0N2IwZDI4NmI2NTAxZjkwOTc4OTFjYmYxZTA2ZGFhM2EgY29tcGlsaW5n
CjE3MyByZWFsICAxNTAzIHVzZXIgIDEzMiBzeXMgIDk0NS4xMyUgY3B1IAlpMzg2LXJhbmRj
b25maWctcjAwLTA2MjEKCjIwMTMtMDYtMjItMjA6MzI6MzcgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgMy4xMC4wLXJjNS0wMDA2NS1nNTQwMmI4MC4uLi4uLi4uLi4JOAkxMwkxNAkzMgk0Ngk1
MiBTVUNDRVNTCgpCaXNlY3Rpbmc6IDExMSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVy
IHRoaXMgKHJvdWdobHkgNyBzdGVwcykKWzJkYzg1YmYzMjM1MTVlNTllMTVkZmE4NThkMTQ3
MmJiMjVjYWQwZmVdIHBhY2tldDogcGFja2V0X2dldG5hbWVfc3BrdDogbWFrZSBzdXJlIHN0
cmluZyBpcyBhbHdheXMgMC10ZXJtaW5hdGVkCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcvc3RhYmxlL29iai1iaXNlY3QK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yMDAt
MDYyMS90aXA6eDg2OnRyYWNlOjJkYzg1YmYzMjM1MTVlNTllMTVkZmE4NThkMTQ3MmJiMjVj
YWQwZmU6YmlzZWN0LXN0YWJsZQoKMjAxMy0wNi0yMi0yMDo0MDozOCAyZGM4NWJmMzIzNTE1
ZTU5ZTE1ZGZhODU4ZDE0NzJiYjI1Y2FkMGZlIGNvbXBpbGluZwoxNTMgcmVhbCAgMTUxNCB1
c2VyICAxMzQgc3lzICAxMDcxLjgwJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1yMDAtMDYyMQoK
MjAxMy0wNi0yMi0yMDo0MzoyMiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEwLjAtcmM1LTAw
MTc2LWcyZGM4NWJmLi4uLi4uLi4uLgkyCTIwCTI5CTMyCTMzCTM4CTQ0CTQ4CTUxLgk1MiBT
VUNDRVNTCgpCaXNlY3Rpbmc6IDUzIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSA2IHN0ZXBzKQpbM2FkMmUzMThhMjQxMjRjNTNjYzYzOTBiNWJmYmQ3NjEz
ZDljMjE0NV0gTWVyZ2UgdGFnICd1c2ItMy4xMC1yYzUnIG9mIGdpdDovL2dpdC5rZXJuZWwu
b3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9ncmVna2gvdXNiCnJ1bm5pbmcgL2Mva2Vy
bmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcvc3RhYmxl
L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFu
ZGNvbmZpZy1yMDAtMDYyMS90aXA6eDg2OnRyYWNlOjNhZDJlMzE4YTI0MTI0YzUzY2M2Mzkw
YjViZmJkNzYxM2Q5YzIxNDU6YmlzZWN0LXN0YWJsZQoKMjAxMy0wNi0yMi0yMDo1Mzo1MyAz
YWQyZTMxOGEyNDEyNGM1M2NjNjM5MGI1YmZiZDc2MTNkOWMyMTQ1IGNvbXBpbGluZwoxNTgg
cmVhbCAgMTUxNyB1c2VyICAxNDggc3lzICAxMDUxLjM2JSBjcHUgCWkzODYtcmFuZGNvbmZp
Zy1yMDAtMDYyMQoKMjAxMy0wNi0yMi0yMDo1Njo0MSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAz
LjEwLjAtcmM1LTAwMjI1LWczYWQyZTMxLi4uLi4uLi4JMS4JOQkyMgkzMgkzNQk0OAk1MC4J
NTEJNTIgU1VDQ0VTUwoKQmlzZWN0aW5nOiAzMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgNSBzdGVwcykKWzU5Mzg5MzBlNzFhZmZhMzkwYzNmYTMzZmEy
ZmRhNTJmNThmODUwZThdIE1lcmdlIGJyYW5jaCAnbWVyZ2UnIG9mIGdpdDovL2dpdC5rZXJu
ZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9iZW5oL3Bvd2VycGMKcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9z
dGFibGUvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4
Ni1yYW5kY29uZmlnLXIwMC0wNjIxL3RpcDp4ODY6dHJhY2U6NTkzODkzMGU3MWFmZmEzOTBj
M2ZhMzNmYTJmZGE1MmY1OGY4NTBlODpiaXNlY3Qtc3RhYmxlCgoyMDEzLTA2LTIyLTIxOjA2
OjEyIDU5Mzg5MzBlNzFhZmZhMzkwYzNmYTMzZmEyZmRhNTJmNThmODUwZTggY29tcGlsaW5n
CjE1MiByZWFsICAxNTE4IHVzZXIgIDEzMiBzeXMgIDEwODIuOTMlIGNwdSAJaTM4Ni1yYW5k
Y29uZmlnLXIwMC0wNjIxCgoyMDEzLTA2LTIyLTIxOjA4OjU2IGRldGVjdGluZyBib290IHN0
YXRlIDMuMTAuMC1yYzUtMDAyNDUtZzU5Mzg5MzAuLi4uLi4uLi4JMQk3CTExCTE2CTI2CTM4
CTQ2CTUyIFNVQ0NFU1MKCkJpc2VjdGluZzogMTkgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDQgc3RlcHMpClszMjMyMjZiYmIzZDg2NWFmMTI2NDRkNjZk
ZjJiN2YxNjFhZGY1MWM3XSBNZXJnZSB0YWcgJ2ZpeGVzLTMuMTAtNCcgb2YgZ2l0Oi8vZ2l0
LmluZnJhZGVhZC5vcmcvdXNlcnMvamNvb3Blci9saW51eCBpbnRvIGZpeGVzCnJ1bm5pbmcg
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93Zmcv
c3RhYmxlL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kz
ODYtcmFuZGNvbmZpZy1yMDAtMDYyMS90aXA6eDg2OnRyYWNlOjMyMzIyNmJiYjNkODY1YWYx
MjY0NGQ2NmRmMmI3ZjE2MWFkZjUxYzc6YmlzZWN0LXN0YWJsZQoKMjAxMy0wNi0yMi0yMTox
NzoyOCAzMjMyMjZiYmIzZDg2NWFmMTI2NDRkNjZkZjJiN2YxNjFhZGY1MWM3IGNvbXBpbGlu
ZwoxNTUgcmVhbCAgMTUyOCB1c2VyICAxNDEgc3lzICAxMDc3LjcyJSBjcHUgCWkzODYtcmFu
ZGNvbmZpZy1yMDAtMDYyMQoKMjAxMy0wNi0yMi0yMToyMDoxNyBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAzLjEwLjAtcmM0LTAwMDMyLWczMjMyMjZiLi4uLi4uLi4uLgk0CTIxCTMwCTMyCTQy
CTUxLi4uLgk1MiBTVUNDRVNTCgpCaXNlY3Rpbmc6IDkgcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDMgc3RlcHMpCltkZDAxOTg5NzM1OGI4MTVmNzgyOGRh
YjkwYjUxZDUxZGY0ZDM2NThkXSBuZXQ6IHNoX2V0aDogZml4IGluY29ycmVjdCBSWCBsZW5n
dGggZXJyb3IgaWYgUjhBNzc0MApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVz
dC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3N0YWJsZS9vYmotYmlzZWN0CmxzIC1hIC9r
ZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctcjAwLTA2MjEvdGlw
Ong4Njp0cmFjZTpkZDAxOTg5NzM1OGI4MTVmNzgyOGRhYjkwYjUxZDUxZGY0ZDM2NThkOmJp
c2VjdC1zdGFibGUKCjIwMTMtMDYtMjItMjE6MzA6NDggZGQwMTk4OTczNThiODE1Zjc4Mjhk
YWI5MGI1MWQ1MWRmNGQzNjU4ZCBjb21waWxpbmcKMTU4IHJlYWwgIDE1MDggdXNlciAgMTMy
IHN5cyAgMTAzNS40OCUgY3B1IAlpMzg2LXJhbmRjb25maWctcjAwLTA2MjEKCjIwMTMtMDYt
MjItMjE6MzM6NDIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMC4wLXJjNS0wMDE4Ni1nZGQw
MTk4OS4uLi4uLi4uCTIJMTAJMjYJNDQJNTIgU1VDQ0VTUwoKQmlzZWN0aW5nOiA0IHJldmlz
aW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAyIHN0ZXBzKQpbZTY2OTRk
OTg0YWRiZTgxNDZkMmYxZTA4ZDUwMGJlZmMxNDgxODM1ZV0gTWVyZ2UgdGFnICdmaXhlcy1m
b3ItbGludXMnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVs
L2dpdC9hcm0vYXJtLXNvYwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1i
b290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3N0YWJsZS9vYmotYmlzZWN0CmxzIC1hIC9rZXJu
ZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctcjAwLTA2MjEvdGlwOng4
Njp0cmFjZTplNjY5NGQ5ODRhZGJlODE0NmQyZjFlMDhkNTAwYmVmYzE0ODE4MzVlOmJpc2Vj
dC1zdGFibGUKCjIwMTMtMDYtMjItMjE6NDA6MTQgZTY2OTRkOTg0YWRiZTgxNDZkMmYxZTA4
ZDUwMGJlZmMxNDgxODM1ZSBjb21waWxpbmcKMTU4IHJlYWwgIDE1MDcgdXNlciAgMTM4IHN5
cyAgMTA0MC43NSUgY3B1IAlpMzg2LXJhbmRjb25maWctcjAwLTA2MjEKCjIwMTMtMDYtMjIt
MjE6NDM6MDAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMC4wLXJjNS0wMDI4My1nZTY2OTRk
OS4uLi4uLi4uCTIJNgkxNgkyMgkzMwk0OAk0OS4uCTUxLi4uLi4uLi4uLi4uLi4uLi4uLgk1
MiBTVUNDRVNTCgpCaXNlY3Rpbmc6IDIgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0
aGlzIChyb3VnaGx5IDEgc3RlcCkKW2Y1YWJhYTFiZmMzZGJmMjZkMTlkMzUxM2YzOTI3OWNh
MzY5ZjhkNjVdIHRyYWNpbmc6IEFkZCBERUZJTkVfRVZFTlRfRk4oKSBtYWNybwpydW5uaW5n
IC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2Zn
L3N0YWJsZS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9p
Mzg2LXJhbmRjb25maWctcjAwLTA2MjEvdGlwOng4Njp0cmFjZTpmNWFiYWExYmZjM2RiZjI2
ZDE5ZDM1MTNmMzkyNzljYTM2OWY4ZDY1OmJpc2VjdC1zdGFibGUKCjIwMTMtMDYtMjItMjI6
MDI6MDQgZjVhYmFhMWJmYzNkYmYyNmQxOWQzNTEzZjM5Mjc5Y2EzNjlmOGQ2NSBjb21waWxp
bmcKMTQwIHJlYWwgIDExMDMgdXNlciAgOTggc3lzICA4NTYuMDMlIGNwdSAJaTM4Ni1yYW5k
Y29uZmlnLXIwMC0wNjIxCgoyMDEzLTA2LTIyLTIyOjA2OjUzIGRldGVjdGluZyBib290IHN0
YXRlIDMuMTAuMC1yYzYtMDAwMDEtZ2Y1YWJhYTEuLi4uLi4uCTEJMjcJNTEuLi4JNTIgU1VD
Q0VTUwoKQmlzZWN0aW5nOiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAo
cm91Z2hseSAxIHN0ZXApCls2MjlmNGY5ZDU5YTI3ZDhlNThhYTYxMmU4ODZlNmE5YTYzZWE3
YWViXSB4ODY6IFJlbmFtZSB2YXJpYWJsZXMgZm9yIGRlYnVnZ2luZwpydW5uaW5nIC9jL2tl
cm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL3N0YWJs
ZS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJh
bmRjb25maWctcjAwLTA2MjEvdGlwOng4Njp0cmFjZTo2MjlmNGY5ZDU5YTI3ZDhlNThhYTYx
MmU4ODZlNmE5YTYzZWE3YWViOmJpc2VjdC1zdGFibGUKCjIwMTMtMDYtMjItMjI6MTM6NTYg
NjI5ZjRmOWQ1OWEyN2Q4ZTU4YWE2MTJlODg2ZTZhOWE2M2VhN2FlYiBjb21waWxpbmcKMTc0
IHJlYWwgIDE1MDIgdXNlciAgMTQ4IHN5cyAgOTQ0LjE1JSBjcHUgCWkzODYtcmFuZGNvbmZp
Zy1yMDAtMDYyMQoKMjAxMy0wNi0yMi0yMjoxNzowMiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAz
LjEwLjAtcmM2LTAwMDAzLWc2MjlmNGY5Li4uLi4uLgkxCTEyLgkyNQk0NS4JNTIgU1VDQ0VT
UwoKY2Y5MTBlODNhZTIzNjkyZmRlZWZjN2U1MDZlNTA0YzRjNDY4ZDM4YSBpcyB0aGUgZmly
c3QgYmFkIGNvbW1pdApjb21taXQgY2Y5MTBlODNhZTIzNjkyZmRlZWZjN2U1MDZlNTA0YzRj
NDY4ZDM4YQpBdXRob3I6IFNlaWppIEFndWNoaSA8c2VpamkuYWd1Y2hpQGhkcy5jb20+CkRh
dGU6ICAgVGh1IEp1biAyMCAxMTo0Njo1MyAyMDEzIC0wNDAwCgogICAgeDg2LCB0cmFjZTog
QWRkIGlycSB2ZWN0b3IgdHJhY2Vwb2ludHMKICAgIAogICAgW1B1cnBvc2Ugb2YgdGhpcyBw
YXRjaF0KICAgIAogICAgQXMgVmFpYmhhdiBleHBsYWluZWQgaW4gdGhlIHRocmVhZCBiZWxv
dywgdHJhY2Vwb2ludHMgZm9yIGlycSB2ZWN0b3JzCiAgICBhcmUgdXNlZnVsLgogICAgCiAg
ICBodHRwOi8vd3d3LnNwaW5pY3MubmV0L2xpc3RzL21tLWNvbW1pdHMvbXNnODU3MDcuaHRt
bAogICAgCiAgICA8c25pcD4KICAgIFRoZSBjdXJyZW50IGludGVycnVwdCB0cmFjZXMgZnJv
bSBpcnFfaGFuZGxlcl9lbnRyeSBhbmQgaXJxX2hhbmRsZXJfZXhpdAogICAgcHJvdmlkZSB3
aGVuIGFuIGludGVycnVwdCBpcyBoYW5kbGVkLiAgVGhleSBwcm92aWRlIGdvb2QgZGF0YSBh
Ym91dCB3aGVuCiAgICB0aGUgc3lzdGVtIGhhcyBzd2l0Y2hlZCB0byBrZXJuZWwgc3BhY2Ug
YW5kIGhvdyBpdCBhZmZlY3RzIHRoZSBjdXJyZW50bHkKICAgIHJ1bm5pbmcgcHJvY2Vzc2Vz
LgogICAgCiAgICBUaGVyZSBhcmUgc29tZSBJUlEgdmVjdG9ycyB3aGljaCB0cmlnZ2VyIHRo
ZSBzeXN0ZW0gaW50byBrZXJuZWwgc3BhY2UsCiAgICB3aGljaCBhcmUgbm90IGhhbmRsZWQg
aW4gZ2VuZXJpYyBJUlEgaGFuZGxlcnMuICBUcmFjaW5nIHN1Y2ggZXZlbnRzIGdpdmVzCiAg
ICB1cyB0aGUgaW5mb3JtYXRpb24gYWJvdXQgSVJRIGludGVyYWN0aW9uIHdpdGggb3RoZXIg
c3lzdGVtIGV2ZW50cy4KICAgIAogICAgVGhlIHRyYWNlIGFsc28gdGVsbHMgd2hlcmUgdGhl
IHN5c3RlbSBpcyBzcGVuZGluZyBpdHMgdGltZS4gIFdlIHdhbnQgdG8KICAgIGtub3cgd2hp
Y2ggY29yZXMgYXJlIGhhbmRsaW5nIGludGVycnVwdHMgYW5kIGhvdyB0aGV5IGFyZSBhZmZl
Y3Rpbmcgb3RoZXIKICAgIHByb2Nlc3NlcyBpbiB0aGUgc3lzdGVtLiAgQWxzbywgdGhlIHRy
YWNlIHByb3ZpZGVzIGluZm9ybWF0aW9uIGFib3V0IHdoZW4KICAgIHRoZSBjb3JlcyBhcmUg
aWRsZSBhbmQgd2hpY2ggaW50ZXJydXB0cyBhcmUgY2hhbmdpbmcgdGhhdCBzdGF0ZS4KICAg
IDxzbmlwPgogICAgCiAgICBPbiB0aGUgb3RoZXIgaGFuZCwgbXkgdXNlY2FzZSBpcyB0cmFj
aW5nIGp1c3QgbG9jYWwgdGltZXIgZXZlbnQgYW5kCiAgICBnZXR0aW5nIGEgdmFsdWUgb2Yg
aW5zdHJ1Y3Rpb24gcG9pbnRlci4KICAgIAogICAgSSBzdWdnZXN0ZWQgdG8gYWRkIGFuIGFy
Z3VtZW50IGxvY2FsIHRpbWVyIGV2ZW50IHRvIGdldCBpbnN0cnVjdGlvbiBwb2ludGVyIGJl
Zm9yZS4KICAgIEJ1dCB0aGVyZSBpcyBhbm90aGVyIHdheSB0byBnZXQgaXQgd2l0aCBleHRl
cm5hbCBtb2R1bGUgbGlrZSBzeXN0ZW10YXAuCiAgICBTbywgSSBkb24ndCBuZWVkIHRvIGFk
ZCBhbnkgYXJndW1lbnQgdG8gaXJxIHZlY3RvciB0cmFjZXBvaW50cyBub3cuCiAgICAKICAg
IFtQYXRjaCBEZXNjcmlwdGlvbl0KICAgIAogICAgVmFpYmhhdidzIHBhdGNoIHNoYXJlZCBh
IHRyYWNlIHBvaW50ICxpcnFfdmVjdG9yX2VudHJ5L2lycV92ZWN0b3JfZXhpdCwgaW4gYWxs
IGV2ZW50cy4KICAgIEJ1dCB0aGVyZSBpcyBhbiBhYm92ZSB1c2UgY2FzZSB0byB0cmFjZSBz
cGVjaWZpYyBpcnFfdmVjdG9yIHJhdGhlciB0aGFuIHRyYWNpbmcgYWxsIGV2ZW50cy4KICAg
IEluIHRoaXMgY2FzZSwgd2UgYXJlIGNvbmNlcm5lZCBhYm91dCBvdmVyaGVhZCBkdWUgdG8g
dW53YW50ZWQgZXZlbnRzLgogICAgCiAgICBTbywgYWRkIGZvbGxvd2luZyB0cmFjZXBvaW50
cyBpbnN0ZWFkIG9mIGludHJvZHVjaW5nIGlycV92ZWN0b3JfZW50cnkvZXhpdC4KICAgIHNv
IHRoYXQgd2UgY2FuIGVuYWJsZSB0aGVtIGluZGVwZW5kZW50bHkuCiAgICAgICAtIGxvY2Fs
X3RpbWVyX3ZlY3RvcgogICAgICAgLSByZXNjaGVkdWxlX3ZlY3RvcgogICAgICAgLSBjYWxs
X2Z1bmN0aW9uX3ZlY3RvcgogICAgICAgLSBjYWxsX2Z1bmN0aW9uX3NpbmdsZV92ZWN0b3IK
ICAgICAgIC0gaXJxX3dvcmtfZW50cnlfdmVjdG9yCiAgICAgICAtIGVycm9yX2FwaWNfdmVj
dG9yCiAgICAgICAtIHRoZXJtYWxfYXBpY192ZWN0b3IKICAgICAgIC0gdGhyZXNob2xkX2Fw
aWNfdmVjdG9yCiAgICAgICAtIHNwdXJpb3VzX2FwaWNfdmVjdG9yCiAgICAgICAtIHg4Nl9w
bGF0Zm9ybV9pcGlfdmVjdG9yCiAgICAKICAgIEFsc28sIGludHJvZHVjZSBhIGxvZ2ljIHN3
aXRjaGluZyBJRFQgYXQgZW5hYmxpbmcvZGlzYWJsaW5nIHRpbWUgc28gdGhhdCBhIHRpbWUg
cGVuYWx0eQogICAgbWFrZXMgYSB6ZXJvIHdoZW4gdHJhY2Vwb2ludHMgYXJlIGRpc2FibGVk
LiBEZXRhaWxlZCBleHBsYW5hdGlvbnMgYXJlIGFzIGZvbGxvd3MuCiAgICAgLSBDcmVhdGUg
dHJhY2UgaXJxIGhhbmRsZXJzIHdpdGggZW50ZXJpbmdfaXJxKCkvZXhpdGluZ19pcnEoKS4K
ICAgICAtIENyZWF0ZSBhIG5ldyBJRFQsIHRyYWNlX2lkdF90YWJsZSwgYXQgYm9vdCB0aW1l
IGJ5IGFkZGluZyBhIGxvZ2ljIHRvCiAgICAgICBfc2V0X2dhdGUoKS4gSXQgaXMganVzdCBh
IGNvcHkgb2Ygb3JpZ2luYWwgaWR0IHRhYmxlLgogICAgIC0gUmVnaXN0ZXIgdGhlIG5ldyBo
YW5kbGVycyBmb3IgdHJhY3BvaW50cyB0byB0aGUgbmV3IElEVCBieSBpbnRyb2R1Y2luZwog
ICAgICAgbWFjcm9zIHRvIGFsbG9jX2ludHJfZ2F0ZSgpIGNhbGxlZCBhdCByZWdpc3Rlcmlu
ZyB0aW1lIG9mIGlycV92ZWN0b3IgaGFuZGxlcnMuCiAgICAgLSBBZGQgY2hlY2tpbmcsIHdo
ZXRoZXIgaXJxIHZlY3RvciB0cmFjaW5nIGlzIG9uL29mZiwgaW50byBsb2FkX2N1cnJlbnRf
aWR0KCkuCiAgICAgICBUaGlzIGhhcyB0byBiZSBkb25lIGJlbG93IGRlYnVnIGNoZWNraW5n
IGZvciB0aGVzZSByZWFzb25zLgogICAgICAgLSBTd2l0Y2hpbmcgdG8gZGVidWcgSURUIG1h
eSBiZSBraWNrZWQgd2hpbGUgdHJhY2luZyBpcyBlbmFibGVkLgogICAgICAgLSBPbiB0aGUg
b3RoZXIgaGFuZHMsIHN3aXRjaGluZyB0byB0cmFjZSBJRFQgaXMga2lja2VkIG9ubHkgd2hl
biBkZWJ1Z2dpbmcKICAgICAgICAgaXMgZGlzYWJsZWQuCiAgICAKICAgIEluIGFkZGl0aW9u
LCB0aGUgbmV3IElEVCBpcyBjcmVhdGVkIG9ubHkgd2hlbiBDT05GSUdfVFJBQ0lORyBpcyBl
bmFibGVkIHRvIGF2b2lkIGJlaW5nCiAgICB1c2VkIGZvciBvdGhlciBwdXJwb3Nlcy4KICAg
IAogICAgU2lnbmVkLW9mZi1ieTogU2VpamkgQWd1Y2hpIDxzZWlqaS5hZ3VjaGlAaGRzLmNv
bT4KICAgIExpbms6IGh0dHA6Ly9sa21sLmtlcm5lbC5vcmcvci81MUMzMjNFRC41MDUwNzA4
QGhkcy5jb20KICAgIFNpZ25lZC1vZmYtYnk6IEguIFBldGVyIEFudmluIDxocGFAbGludXgu
aW50ZWwuY29tPgogICAgQ2M6IFN0ZXZlbiBSb3N0ZWR0IDxyb3N0ZWR0QGdvb2RtaXMub3Jn
PgoKOjA0MDAwMCAwNDAwMDAgMjNkNWVmMTQ2MTU4YjQxMDEwMTZlZDJkMGViMTFlNGQyODcx
MjA0NCBlYzMzYzdiNjM5YjEzNmUxZjE2MWQ0MWU2Y2JlZTQ2YzQxYmQ1OGQ3IE0JYXJjaAo6
MDQwMDAwIDA0MDAwMCBkMTkyMzI0ZTM1ZDQxNDJlZGI0MjZmMjQ4OWI4NmY3NWViMTllNjcx
IDBkMTNiM2RhYTc1YzFlZTg2MmU4Nzc0MDliNzJkOGE0NWIyOTdhOWEgTQlpbmNsdWRlCmJp
c2VjdCBydW4gc3VjY2VzcwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4
Ni1yYW5kY29uZmlnLXIwMC0wNjIxL3RpcDp4ODY6dHJhY2U6NjI5ZjRmOWQ1OWEyN2Q4ZTU4
YWE2MTJlODg2ZTZhOWE2M2VhN2FlYjpiaXNlY3Qtc3RhYmxlCgoyMDEzLTA2LTIyLTIyOjI0
OjA1IDYyOWY0ZjlkNTlhMjdkOGU1OGFhNjEyZTg4NmU2YTlhNjNlYTdhZWIgcmV1c2UgL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctcjAwLTA2MjEvNjI5ZjRmOWQ1OWEyN2Q4ZTU4YWE2MTJl
ODg2ZTZhOWE2M2VhN2FlYi92bWxpbnV6LTMuMTAuMC1yYzYtMDAwMDMtZzYyOWY0ZjkKCjIw
MTMtMDYtMjItMjI6MjQ6MDUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLgk1Mwk2Ngk5
NgkxNDIJMTU1LgkxNTYgU1VDQ0VTUwoKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUv
a3ZtL2kzODYtcmFuZGNvbmZpZy1yMDAtMDYyMS90aXA6eDg2OnRyYWNlOjgzYWI4NTE0MGJj
MTQ5MmY5MmRlMjYzYTFjMzBlYTA0YTBmNDY1Zjc6YmlzZWN0LXN0YWJsZQogVEVTVCBGQUlM
VVJFCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIwMC0wNjIxLzgzYWI4NTE0MGJjMTQ5MmY5
MmRlMjYzYTFjMzBlYTA0YTBmNDY1ZjcvZG1lc2cta3ZtLWtidWlsZC0xMTk1Mi0yMDEzMDYy
MjA1MDkyOC0zLjEwLjAtcmM2LTAwMDA1LWc4M2FiODUxLTE4OAova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1yMDAtMDYyMS84M2FiODUxNDBiYzE0OTJmOTJkZTI2M2ExYzMwZWEwNGEwZjQ2
NWY3L2RtZXNnLWt2bS1rYnVpbGQtNTczMTUtMjAxMzA2MjIwNTA5MDktMy4xMC4wLXJjNi0w
MDAwNS1nODNhYjg1MS0xODgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAwLTA2MjEvODNh
Yjg1MTQwYmMxNDkyZjkyZGUyNjNhMWMzMGVhMDRhMGY0NjVmNy9kbWVzZy1rdm0tc25iLTI3
ODg1LTIwMTMwNjIyMDUxODQzLTMuMTAuMC1yYzYtMDAwMDUtZzgzYWI4NTEtMTg4Ci9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXIwMC0wNjIxLzgzYWI4NTE0MGJjMTQ5MmY5MmRlMjYzYTFj
MzBlYTA0YTBmNDY1ZjcvZG1lc2cta3ZtLXZwLTEyODk2LTIwMTMwNjIyMDUxNTM0LTMuMTAu
MC1yYzYtMDAwMDUtZzgzYWI4NTEtMTg4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIwMC0w
NjIxLzgzYWI4NTE0MGJjMTQ5MmY5MmRlMjYzYTFjMzBlYTA0YTBmNDY1ZjcvZG1lc2cta3Zt
LXZwLTIyNDE0LTIwMTMwNjIyMDUxNTU2LTMuMTAuMC1yYzYtMDAwMDUtZzgzYWI4NTEtMTg4
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIwMC0wNjIxLzgzYWI4NTE0MGJjMTQ5MmY5MmRl
MjYzYTFjMzBlYTA0YTBmNDY1ZjcvZG1lc2cta3ZtLXZwLTIyOTgyLTIwMTMwNjIyMDUxNTM0
LTMuMTAuMC1yYzYtMDAwMDUtZzgzYWI4NTEtMTg4Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LXIwMC0wNjIxLzgzYWI4NTE0MGJjMTQ5MmY5MmRlMjYzYTFjMzBlYTA0YTBmNDY1ZjcvZG1l
c2cta3ZtLXZwLTUyMzEtMjAxMzA2MjIwNTE1NDQtMy4xMC4wLXJjNi0wMDAwNS1nODNhYjg1
MS0xODgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjAwLTA2MjEvODNhYjg1MTQwYmMxNDky
ZjkyZGUyNjNhMWMzMGVhMDRhMGY0NjVmNy9kbWVzZy1rdm0tdnAtNTQ5Mi0yMDEzMDYyMjA1
MTU1Ni0zLjEwLjAtcmM2LTAwMDA1LWc4M2FiODUxLTE4OAova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1yMDAtMDYyMS84M2FiODUxNDBiYzE0OTJmOTJkZTI2M2ExYzMwZWEwNGEwZjQ2NWY3
L2RtZXNnLWt2bS12cC02MzQ0LTIwMTMwNjIyMDUxNjEyLTMuMTAuMC1yYzYtMDAwMDUtZzgz
YWI4NTEtMTg4CgpIRUFEIGlzIG5vdyBhdCA4M2FiODUxIHRyYWNlLHg4NjogTW92ZSBjcmVh
dGlvbiBvZiBpcnEgdHJhY2Vwb2ludHMgZnJvbSBhcGljLmMgdG8gaXJxLmMKCj09PT09PT09
PSB1cHN0cmVhbSA9PT09PT09PT0KRmV0Y2hpbmcgbGludXMKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yMDAtMDYyMS90aXA6eDg2OnRyYWNl
OmY3MTE5NGE3ZDQ3YzFkYTc4NzU1NWQyN2FhYzYzOTczY2E3MjMyM2I6YmlzZWN0LXN0YWJs
ZQoKMjAxMy0wNi0yMi0yMjozMToxNyBmNzExOTRhN2Q0N2MxZGE3ODc1NTVkMjdhYWM2Mzk3
M2NhNzIzMjNiIHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIwMC0wNjIxL2Y3MTE5
NGE3ZDQ3YzFkYTc4NzU1NWQyN2FhYzYzOTczY2E3MjMyM2Ivdm1saW51ei0zLjEwLjAtcmM2
LTAwMTMyLWdmNzExOTRhCgoyMDEzLTA2LTIyLTIyOjMxOjE3IGRldGVjdGluZyBib290IHN0
YXRlIC4uLi4uLgkxMAkxMQk3MAkxNDgJMTU2IFNVQ0NFU1MKCgo9PT09PT09PT0gbGludXgt
bmV4dCA9PT09PT09PT0KRmV0Y2hpbmcgbmV4dApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1x
dWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXIwMC0wNjIxL3RpcDp4ODY6dHJhY2U6ZTFhODY1
Nzg3NDczNzZmMDg5ODU2MjdjODRkZjA4OGE1ZDBkMWU5MjpiaXNlY3Qtc3RhYmxlCgoyMDEz
LTA2LTIyLTIzOjA2OjU1IGUxYTg2NTc4NzQ3Mzc2ZjA4OTg1NjI3Yzg0ZGYwODhhNWQwZDFl
OTIgY29tcGlsaW5nCjIwMTMtMDYtMjItMjM6MTA6NDAgZTFhODY1Nzg3NDczNzZmMDg5ODU2
MjdjODRkZjA4OGE1ZDBkMWU5MiBTS0lQIEJST0tFTiBCVUlMRApDaGVjayBlcnJvcyBpbiAv
Y2Mvd2ZnL3N0YWJsZS1iaXNlY3QgYW5kIC90bXAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1y
MDAtMDYyMS9lMWE4NjU3ODc0NzM3NmYwODk4NTYyN2M4NGRmMDg4YTVkMGQxZTkyCgo9PT09
PT09PT0gdGlwL21hc3RlciA9PT09PT09PT0KRmV0Y2hpbmcgdGlwCmxzIC1hIC9rZXJuZWwt
dGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctcjAwLTA2MjEvdGlwOng4Njp0
cmFjZTphOTJhOTkwNzg5ODQ5NTAyODk3ZTNlMTljMmMwZTUxNTQ4ODhlZGY3OmJpc2VjdC1z
dGFibGUKCjIwMTMtMDYtMjItMjM6MTA6NDQgYTkyYTk5MDc4OTg0OTUwMjg5N2UzZTE5YzJj
MGU1MTU0ODg4ZWRmNyByZXVzZSAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMDAtMDYyMS9h
OTJhOTkwNzg5ODQ5NTAyODk3ZTNlMTljMmMwZTUxNTQ4ODhlZGY3L3ZtbGludXotMy4xMC4w
LXJjNi0wMTc2NC1nYTkyYTk5MAoKMjAxMy0wNi0yMi0yMzoxMDo0NCBkZXRlY3RpbmcgYm9v
dCBzdGF0ZSAuLi4uLi4uCTE3CTUwCTY2CTkwCTEzOAkxNDQJMTQ3Li4JMTQ4Li4uLi4uLi4J
MTUwLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTE1NC4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uCTE1NiBTVUNDRVNTCgo=

--yNb1oOkm5a9FJOVX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.10.0-rc6 Kernel Configuration
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
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
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
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_POSIX_MQUEUE=y
# CONFIG_FHANDLE is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
CONFIG_AUDIT_LOGINUID_IMMUTABLE=y
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
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
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
CONFIG_RCU_FAST_NO_HZ=y
CONFIG_TREE_RCU_TRACE=y
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
# CONFIG_MEMCG_SWAP is not set
# CONFIG_CGROUP_HUGETLB is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
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
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HOTPLUG=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
# CONFIG_AIO is not set
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
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
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
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
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
# CONFIG_GCOV_PROFILE_ALL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
# CONFIG_BLK_DEV_INTEGRITY is not set
# CONFIG_BLK_DEV_THROTTLING is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
CONFIG_ACORN_PARTITION_EESOX=y
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
CONFIG_ACORN_PARTITION_POWERTEC=y
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
# CONFIG_MSDOS_PARTITION is not set
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
CONFIG_SYSV68_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_BIGSMP=y
CONFIG_GOLDFISH=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_GOLDFISH=y
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
CONFIG_LGUEST_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
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
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
# CONFIG_CPU_SUP_CYRIX_32 is not set
# CONFIG_CPU_SUP_AMD is not set
CONFIG_CPU_SUP_CENTAUR=y
# CONFIG_CPU_SUP_TRANSMETA_32 is not set
# CONFIG_CPU_SUP_UMC_32 is not set
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=y
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
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
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
CONFIG_HIGHPTE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_I2C=y
# CONFIG_ACPI_PROCESSOR is not set
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_INITRD_TABLE_OVERRIDE=y
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
# CONFIG_ACPI_APEI_EINJ is not set
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
CONFIG_APM_IGNORE_USER_SUSPEND=y
CONFIG_APM_DO_ENABLE=y
# CONFIG_APM_DISPLAY_BLANK is not set
# CONFIG_APM_ALLOW_INTS is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
# CONFIG_CPU_IDLE is not set
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_OLPC=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
# CONFIG_PCI_ATS is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_SCx200=y
# CONFIG_SCx200HR_TIMER is not set
CONFIG_OLPC=y
# CONFIG_OLPC_XO1_PM is not set
# CONFIG_OLPC_XO15_SCI is not set
CONFIG_ALIX=y
CONFIG_NET5501=y
CONFIG_GEOS=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PD6729=y
CONFIG_I82092=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_COMPAQ=y
# CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM is not set
# CONFIG_HOTPLUG_PCI_IBM is not set
# CONFIG_HOTPLUG_PCI_ACPI is not set
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=y
# CONFIG_HOTPLUG_PCI_CPCI_GENERIC is not set
CONFIG_HOTPLUG_PCI_SHPC=y
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
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
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_NETFILTER_XTABLES=y

#
# DECnet: Netfilter Configuration
#
# CONFIG_DECNET_NF_GRABULATOR is not set
CONFIG_BRIDGE_NF_EBTABLES=y
# CONFIG_BRIDGE_EBT_BROUTE is not set
# CONFIG_BRIDGE_EBT_T_FILTER is not set
CONFIG_BRIDGE_EBT_T_NAT=y
CONFIG_BRIDGE_EBT_802_3=y
# CONFIG_BRIDGE_EBT_AMONG is not set
# CONFIG_BRIDGE_EBT_ARP is not set
CONFIG_BRIDGE_EBT_IP=y
CONFIG_BRIDGE_EBT_LIMIT=y
# CONFIG_BRIDGE_EBT_MARK is not set
CONFIG_BRIDGE_EBT_PKTTYPE=y
# CONFIG_BRIDGE_EBT_STP is not set
# CONFIG_BRIDGE_EBT_VLAN is not set
CONFIG_BRIDGE_EBT_DNAT=y
CONFIG_BRIDGE_EBT_MARK_T=y
CONFIG_BRIDGE_EBT_REDIRECT=y
CONFIG_BRIDGE_EBT_SNAT=y
CONFIG_BRIDGE_EBT_LOG=y
# CONFIG_BRIDGE_EBT_ULOG is not set
CONFIG_BRIDGE_EBT_NFLOG=y
CONFIG_ATM=y
CONFIG_ATM_LANE=y
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_VLAN_8021Q_MVRP is not set
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
CONFIG_IPX_INTERN=y
# CONFIG_ATALK is not set
CONFIG_X25=y
# CONFIG_LAPB is not set
CONFIG_PHONET=y
CONFIG_IEEE802154=y
CONFIG_MAC802154=y
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
CONFIG_VMWARE_VMCI_VSOCKETS=y
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NETPRIO_CGROUP=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=y
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=y
CONFIG_BT_BNEP_MC_FILTER=y
# CONFIG_BT_BNEP_PROTO_FILTER is not set
CONFIG_BT_CMTP=y
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTSDIO=y
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIDTL1 is not set
# CONFIG_BT_HCIBT3C is not set
CONFIG_BT_HCIBLUECARD=y
CONFIG_BT_HCIBTUART=y
# CONFIG_BT_HCIVHCI is not set
# CONFIG_BT_MRVL is not set
CONFIG_BT_WILINK=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
# CONFIG_CFG80211_REG_DEBUG is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_PID=y
# CONFIG_MAC80211_RC_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT_PID=y
CONFIG_MAC80211_RC_DEFAULT="pid"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
CONFIG_MAC80211_DEBUG_MENU=y
# CONFIG_MAC80211_NOINLINE is not set
# CONFIG_MAC80211_VERBOSE_DEBUG is not set
CONFIG_MAC80211_MLME_DEBUG=y
CONFIG_MAC80211_STA_DEBUG=y
CONFIG_MAC80211_HT_DEBUG=y
CONFIG_MAC80211_IBSS_DEBUG=y
# CONFIG_MAC80211_PS_DEBUG is not set
# CONFIG_MAC80211_TDLS_DEBUG is not set
CONFIG_MAC80211_DEBUG_COUNTERS=y
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_NET_9P_DEBUG=y
# CONFIG_CAIF is not set
CONFIG_NFC=y
CONFIG_NFC_NCI=y
CONFIG_NFC_HCI=y
# CONFIG_NFC_SHDLC is not set

#
# Near Field Communication (NFC) devices
#
# CONFIG_NFC_WILINK is not set
# CONFIG_NFC_MEI_PHY is not set
# CONFIG_NFC_PN544 is not set
CONFIG_NFC_MICROREAD=y

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
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=16
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
CONFIG_CMA_AREAS=7

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
# CONFIG_OF_SELFTEST is not set
CONFIG_OF_PROMTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_DEVICE=y
CONFIG_OF_I2C=y
CONFIG_OF_NET=y
CONFIG_OF_MDIO=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
CONFIG_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

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
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
CONFIG_INTEL_MID_PTI=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_CS5535_MFGPT is not set
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_SRAM=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
CONFIG_VMWARE_VMCI=y
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
CONFIG_IDE_GD_ATAPI=y
# CONFIG_BLK_DEV_IDECS is not set
CONFIG_BLK_DEV_DELKIN=y
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
CONFIG_BLK_DEV_PLATFORM=y
# CONFIG_BLK_DEV_CMD640 is not set
CONFIG_BLK_DEV_IDEPNP=y
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
CONFIG_BLK_DEV_OFFBOARD=y
CONFIG_BLK_DEV_GENERIC=y
# CONFIG_BLK_DEV_OPTI621 is not set
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=y
CONFIG_BLK_DEV_ALI15X3=y
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
CONFIG_BLK_DEV_TRIFLEX=y
# CONFIG_BLK_DEV_CS5520 is not set
CONFIG_BLK_DEV_CS5530=y
CONFIG_BLK_DEV_CS5535=y
# CONFIG_BLK_DEV_CS5536 is not set
CONFIG_BLK_DEV_HPT366=y
CONFIG_BLK_DEV_JMICRON=y
CONFIG_BLK_DEV_SC1200=y
CONFIG_BLK_DEV_PIIX=y
# CONFIG_BLK_DEV_IT8172 is not set
CONFIG_BLK_DEV_IT8213=y
CONFIG_BLK_DEV_IT821X=y
CONFIG_BLK_DEV_NS87415=y
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
CONFIG_BLK_DEV_SLC90E66=y
# CONFIG_BLK_DEV_TRM290 is not set
CONFIG_BLK_DEV_VIA82CXXX=y
CONFIG_BLK_DEV_TC86C001=y
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_ATA is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_AUTODETECT is not set
# CONFIG_MD_LINEAR is not set
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
# CONFIG_MD_MULTIPATH is not set
CONFIG_MD_FAULTY=y
CONFIG_BCACHE=y
# CONFIG_BCACHE_DEBUG is not set
CONFIG_BCACHE_EDEBUG=y
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=y
CONFIG_DM_BIO_PRISON=y
CONFIG_DM_PERSISTENT_DATA=y
# CONFIG_DM_CRYPT is not set
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_THIN_PROVISIONING=y
CONFIG_DM_DEBUG_BLOCK_STACK_TRACING=y
CONFIG_DM_CACHE=y
CONFIG_DM_CACHE_MQ=y
CONFIG_DM_CACHE_CLEANER=y
CONFIG_DM_MIRROR=y
CONFIG_DM_RAID=y
CONFIG_DM_LOG_USERSPACE=y
# CONFIG_DM_ZERO is not set
CONFIG_DM_MULTIPATH=y
# CONFIG_DM_MULTIPATH_QL is not set
CONFIG_DM_MULTIPATH_ST=y
CONFIG_DM_DELAY=y
# CONFIG_DM_UEVENT is not set
# CONFIG_DM_FLAKEY is not set
CONFIG_DM_VERITY=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_NOSY=y
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_DUMMY=y
CONFIG_EQUALIZER=y
# CONFIG_MII is not set
CONFIG_NET_TEAM=y
# CONFIG_NET_TEAM_MODE_BROADCAST is not set
# CONFIG_NET_TEAM_MODE_ROUNDROBIN is not set
CONFIG_NET_TEAM_MODE_RANDOM=y
# CONFIG_NET_TEAM_MODE_ACTIVEBACKUP is not set
CONFIG_NET_TEAM_MODE_LOADBALANCE=y
CONFIG_MACVLAN=y
# CONFIG_MACVTAP is not set
CONFIG_NETCONSOLE=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=y
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=y
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
CONFIG_ARCNET_1051=y
# CONFIG_ARCNET_RAW is not set
CONFIG_ARCNET_CAP=y
CONFIG_ARCNET_COM90xx=y
# CONFIG_ARCNET_COM90xxIO is not set
# CONFIG_ARCNET_RIM_I is not set
CONFIG_ARCNET_COM20020=y
CONFIG_ARCNET_COM20020_PCI=y
CONFIG_ARCNET_COM20020_CS=y
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=y
CONFIG_ATM_LANAI=y
CONFIG_ATM_ENI=y
CONFIG_ATM_ENI_DEBUG=y
CONFIG_ATM_ENI_TUNE_BURST=y
CONFIG_ATM_ENI_BURST_TX_16W=y
CONFIG_ATM_ENI_BURST_TX_8W=y
CONFIG_ATM_ENI_BURST_TX_4W=y
CONFIG_ATM_ENI_BURST_TX_2W=y
# CONFIG_ATM_ENI_BURST_RX_16W is not set
# CONFIG_ATM_ENI_BURST_RX_8W is not set
# CONFIG_ATM_ENI_BURST_RX_4W is not set
CONFIG_ATM_ENI_BURST_RX_2W=y
# CONFIG_ATM_FIRESTREAM is not set
CONFIG_ATM_ZATM=y
# CONFIG_ATM_ZATM_DEBUG is not set
CONFIG_ATM_NICSTAR=y
CONFIG_ATM_NICSTAR_USE_SUNI=y
CONFIG_ATM_NICSTAR_USE_IDT77105=y
CONFIG_ATM_IDT77252=y
CONFIG_ATM_IDT77252_DEBUG=y
# CONFIG_ATM_IDT77252_RCV_ALL is not set
CONFIG_ATM_IDT77252_USE_SUNI=y
# CONFIG_ATM_AMBASSADOR is not set
CONFIG_ATM_HORIZON=y
# CONFIG_ATM_HORIZON_DEBUG is not set
CONFIG_ATM_IA=y
# CONFIG_ATM_IA_DEBUG is not set
# CONFIG_ATM_FORE200E is not set
CONFIG_ATM_HE=y
# CONFIG_ATM_HE_USE_SUNI is not set
CONFIG_ATM_SOLOS=y

#
# CAIF transport drivers
#
# CONFIG_VHOST_NET is not set

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
# CONFIG_ETHERNET is not set
CONFIG_FDDI=y
CONFIG_DEFXX=y
CONFIG_DEFXX_MMIO=y
CONFIG_SKFP=y
CONFIG_NET_SB1000=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=y
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
# CONFIG_SMSC_PHY is not set
CONFIG_BROADCOM_PHY=y
# CONFIG_BCM87XX_PHY is not set
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
# CONFIG_STE10XP is not set
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MICREL_PHY=y
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_GPIO=y
# CONFIG_MDIO_BUS_MUX_GPIO is not set
# CONFIG_MDIO_BUS_MUX_MMIOREG is not set
CONFIG_PLIP=y
# CONFIG_PPP is not set
CONFIG_SLIP=y
# CONFIG_SLIP_COMPRESSED is not set
# CONFIG_SLIP_SMART is not set
# CONFIG_SLIP_MODE_SLIP6 is not set
# CONFIG_WLAN is not set

#
# WiMAX Wireless Broadband devices
#

#
# Enable USB support to see WiMAX USB drivers
#
CONFIG_WAN=y
CONFIG_LANMEDIA=y
CONFIG_HDLC=y
# CONFIG_HDLC_RAW is not set
# CONFIG_HDLC_RAW_ETH is not set
CONFIG_HDLC_CISCO=y
CONFIG_HDLC_FR=y
CONFIG_HDLC_PPP=y

#
# X.25/LAPB support is disabled
#
# CONFIG_PCI200SYN is not set
CONFIG_WANXL=y
CONFIG_PC300TOO=y
CONFIG_FARSYNC=y
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
# CONFIG_SBNI is not set
# CONFIG_IEEE802154_DRIVERS is not set
# CONFIG_HYPERV_NET is not set
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
CONFIG_ISDN_CAPI=y
# CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON is not set
# CONFIG_CAPI_TRACE is not set
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPI20=y

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
CONFIG_ISDN_DRV_AVMB1_B1PCI=y
# CONFIG_ISDN_DRV_AVMB1_B1PCIV4 is not set
CONFIG_ISDN_DRV_AVMB1_B1PCMCIA=y
CONFIG_ISDN_DRV_AVMB1_AVM_CS=y
CONFIG_ISDN_DRV_AVMB1_T1PCI=y
# CONFIG_ISDN_DRV_AVMB1_C4 is not set
# CONFIG_CAPI_EICON is not set
CONFIG_ISDN_DRV_GIGASET=y
# CONFIG_GIGASET_CAPI is not set
CONFIG_GIGASET_DUMMYLL=y
# CONFIG_GIGASET_M101 is not set
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
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ADP5589=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=y
# CONFIG_KEYBOARD_QT2160 is not set
CONFIG_KEYBOARD_LKKBD=y
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
CONFIG_KEYBOARD_LM8333=y
CONFIG_KEYBOARD_MAX7359=y
# CONFIG_KEYBOARD_MCS is not set
CONFIG_KEYBOARD_MPR121=y
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_OPENCORES=y
CONFIG_KEYBOARD_GOLDFISH_EVENTS=y
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_STMPE=y
CONFIG_KEYBOARD_TC3589X=y
CONFIG_KEYBOARD_TWL4030=y
CONFIG_KEYBOARD_XTKBD=y
CONFIG_KEYBOARD_CROS_EC=y
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
CONFIG_JOYSTICK_A3D=y
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=y
CONFIG_JOYSTICK_IFORCE=y
# CONFIG_JOYSTICK_IFORCE_232 is not set
CONFIG_JOYSTICK_WARRIOR=y
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_DB9=y
CONFIG_JOYSTICK_GAMECON=y
CONFIG_JOYSTICK_TURBOGRAFX=y
CONFIG_JOYSTICK_AS5011=y
CONFIG_JOYSTICK_JOYDUMP=y
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM80X_ONKEY=y
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_BMA150=y
CONFIG_INPUT_PCSPKR=y
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
# CONFIG_INPUT_GP2A is not set
CONFIG_INPUT_GPIO_TILT_POLLED=y
CONFIG_INPUT_WISTRON_BTNS=y
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=y
CONFIG_INPUT_KXTJ9_POLLED_MODE=y
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_RETU_PWRBUTTON=y
CONFIG_INPUT_TWL4030_PWRBUTTON=y
CONFIG_INPUT_TWL4030_VIBRA=y
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF50633_PMU=y
CONFIG_INPUT_PCF8574=y
CONFIG_INPUT_PWM_BEEPER=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_DA9052_ONKEY=y
CONFIG_INPUT_WM831X_ON=y
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=y
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
# CONFIG_SERIO_APBPS2 is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=y
CONFIG_CYZ_INTR=y
CONFIG_MOXA_INTELLIO=y
CONFIG_MOXA_SMARTIO=y
CONFIG_SYNCLINK=y
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
CONFIG_NOZOMI=y
# CONFIG_ISI is not set
# CONFIG_N_HDLC is not set
CONFIG_N_GSM=y
CONFIG_TRACE_ROUTER=y
CONFIG_TRACE_SINK=y
CONFIG_GOLDFISH_TTY=y
# CONFIG_DEVKMEM is not set
# CONFIG_STALDRV is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
# CONFIG_SERIAL_8250_PNP is not set
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
CONFIG_SERIAL_MFD_HSU=y
CONFIG_SERIAL_MFD_HSU_CONSOLE=y
CONFIG_SERIAL_UARTLITE=y
# CONFIG_SERIAL_UARTLITE_CONSOLE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_OF_PLATFORM=y
CONFIG_SERIAL_SCCNXP=y
CONFIG_SERIAL_SCCNXP_CONSOLE=y
CONFIG_SERIAL_TIMBERDALE=y
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
CONFIG_SERIAL_PCH_UART=y
CONFIG_SERIAL_PCH_UART_CONSOLE=y
# CONFIG_SERIAL_XILINX_PS_UART is not set
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
# CONFIG_TTY_PRINTK is not set
# CONFIG_PRINTER is not set
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
# CONFIG_IPMI_POWEROFF is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
CONFIG_CARDMAN_4040=y
# CONFIG_IPWIRELESS is not set
CONFIG_MWAVE=y
CONFIG_SCx200_GPIO=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
CONFIG_HANGCHECK_TIMER=y
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
CONFIG_I2C_ARB_GPIO_CHALLENGE=y
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
CONFIG_I2C_AMD756=y
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
# CONFIG_I2C_ISMT is not set
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
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
CONFIG_I2C_EG20T=y
CONFIG_I2C_GPIO=y
CONFIG_I2C_INTEL_MID=y
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_TAOS_EVM=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_SCx200_I2C is not set
CONFIG_SCx200_ACB=y
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set

#
# Qualcomm MSM SSBI bus support
#
CONFIG_SSBI=y
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=y

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
# CONFIG_PPS_CLIENT_PARPORT is not set
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
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIOLIB=y
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
# CONFIG_GPIO_TS5500 is not set
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=y
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set
CONFIG_GPIO_GRGPIO=y

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX7300=y
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_RC5T583=y
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_STMPE=y
# CONFIG_GPIO_TC3589X is not set
CONFIG_GPIO_TWL4030=y
CONFIG_GPIO_WM831X=y
# CONFIG_GPIO_WM8350 is not set
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set
CONFIG_GPIO_ADNP=y

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_CS5535 is not set
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_LANGWELL=y
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_SODAVILLE is not set
# CONFIG_GPIO_TIMBERDALE is not set
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MCP23S08=y

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_PALMAS=y
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
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
CONFIG_WM8350_POWER=y
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_OLPC is not set
CONFIG_BATTERY_SBS=y
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9052=y
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_PCF50633=y
# CONFIG_BATTERY_RX51 is not set
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_TWL4030 is not set
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_SMB347=y
CONFIG_BATTERY_GOLDFISH=y
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
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
# CONFIG_SENSORS_ADT7462 is not set
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
CONFIG_SENSORS_FAM15H_POWER=y
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
# CONFIG_SENSORS_DA9052_ADC is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IBMAEM=y
CONFIG_SENSORS_IBMPEX=y
# CONFIG_SENSORS_IIO_HWMON is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=y
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NCT6775=y
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=y
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SIS5595=y
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
CONFIG_SENSORS_SCH5636=y
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=y
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_TWL4030_MADC=y
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_WM8350=y
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=y
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
CONFIG_THERMAL_EMULATION=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
# CONFIG_DA9052_WATCHDOG is not set
# CONFIG_WM831X_WATCHDOG is not set
# CONFIG_WM8350_WATCHDOG is not set
CONFIG_TWL4030_WATCHDOG=y
CONFIG_RETU_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=y
CONFIG_F71808E_WDT=y
CONFIG_SP5100_TCO=y
CONFIG_SC520_WDT=y
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
CONFIG_IT87_WDT=y
CONFIG_HP_WATCHDOG=y
# CONFIG_HPWDT_NMI_DECODING is not set
CONFIG_SC1200_WDT=y
CONFIG_SCx200_WDT=y
CONFIG_PC87413_WDT=y
CONFIG_NV_TCO=y
CONFIG_60XX_WDT=y
# CONFIG_SBC8360_WDT is not set
CONFIG_SBC7240_WDT=y
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=y
# CONFIG_SMSC37B787_WDT is not set
CONFIG_VIA_WDT=y
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=y
CONFIG_W83697UG_WDT=y
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
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
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

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
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
CONFIG_MFD_RDC321X=y
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
# CONFIG_MFD_SM501 is not set
CONFIG_MFD_SMSC=y
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_PALMAS=y
# CONFIG_TPS6105X is not set
CONFIG_TPS65010=y
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
CONFIG_TWL4030_MADC=y
CONFIG_MFD_TWL4030_AUDIO=y
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
CONFIG_MFD_TIMBERDALE=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
# CONFIG_MFD_WM8994 is not set
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_SG=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_CONTIG=y
CONFIG_VIDEOBUF2_VMALLOC=y
CONFIG_VIDEO_V4L2_INT_DEVICE=y
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_RC_CORE=y
CONFIG_RC_MAP=y
CONFIG_RC_DECODERS=y
CONFIG_LIRC=y
CONFIG_IR_LIRC_CODEC=y
CONFIG_IR_NEC_DECODER=y
CONFIG_IR_RC5_DECODER=y
CONFIG_IR_RC6_DECODER=y
CONFIG_IR_JVC_DECODER=y
CONFIG_IR_SONY_DECODER=y
CONFIG_IR_RC5_SZ_DECODER=y
CONFIG_IR_SANYO_DECODER=y
CONFIG_IR_MCE_KBD_DECODER=y
# CONFIG_RC_DEVICES is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
CONFIG_V4L_PLATFORM_DRIVERS=y
CONFIG_VIDEO_CAFE_CCIC=y
CONFIG_VIDEO_VIA_CAMERA=y
# CONFIG_SOC_CAMERA is not set
CONFIG_V4L_MEM2MEM_DRIVERS=y
# CONFIG_VIDEO_SH_VEU is not set
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_MEDIA_PARPORT_SUPPORT=y
CONFIG_VIDEO_BWQCAM=y
CONFIG_VIDEO_CQCAM=y
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_SI470X is not set
# CONFIG_RADIO_SI476X is not set
CONFIG_I2C_SI4713=y
CONFIG_RADIO_SI4713=y
CONFIG_RADIO_TEA5764=y
# CONFIG_RADIO_TEA5764_XTAL is not set
CONFIG_RADIO_SAA7706H=y
CONFIG_RADIO_TEF6862=y
CONFIG_RADIO_TIMBERDALE=y
# CONFIG_RADIO_WL1273 is not set

#
# Texas Instruments WL128x FM driver (ST based)
#
# CONFIG_RADIO_WL128X is not set

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
CONFIG_VIDEO_OV7670=y

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
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
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
CONFIG_VGA_SWITCHEROO=y
# CONFIG_DRM is not set
CONFIG_VGASTATE=y
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
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
# CONFIG_FB_BOTH_ENDIAN is not set
CONFIG_FB_BIG_ENDIAN=y
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
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=y
CONFIG_FB_PM2_FIFO_DISCONNECT=y
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
CONFIG_FB_ASILIANT=y
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
CONFIG_FB_N411=y
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=y
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
CONFIG_FB_RIVA=y
# CONFIG_FB_RIVA_I2C is not set
CONFIG_FB_RIVA_DEBUG=y
CONFIG_FB_RIVA_BACKLIGHT=y
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=y
# CONFIG_FB_ATY_CT is not set
# CONFIG_FB_ATY_GX is not set
# CONFIG_FB_ATY_BACKLIGHT is not set
CONFIG_FB_S3=y
CONFIG_FB_S3_DDC=y
CONFIG_FB_SAVAGE=y
CONFIG_FB_SAVAGE_I2C=y
# CONFIG_FB_SAVAGE_ACCEL is not set
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
CONFIG_FB_VIA=y
CONFIG_FB_VIA_DIRECT_PROCFS=y
CONFIG_FB_VIA_X_COMPATIBILITY=y
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
CONFIG_FB_CARMINE_DRAM_EVAL=y
# CONFIG_CARMINE_DRAM_CUSTOM is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
# CONFIG_FB_AUO_K1901 is not set
CONFIG_FB_HYPERV=y
CONFIG_FB_SIMPLE=y
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_PWM=y
# CONFIG_BACKLIGHT_DA9052 is not set
CONFIG_BACKLIGHT_APPLE=y
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=y
# CONFIG_BACKLIGHT_PCF50633 is not set
CONFIG_BACKLIGHT_LM3630=y
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_PANDORA=y
CONFIG_BACKLIGHT_TPS65217=y
# CONFIG_BACKLIGHT_AS3711 is not set
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
# CONFIG_LOGO_LINUX_CLUT224 is not set
# CONFIG_FB_SSD1307 is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
CONFIG_UHID=y
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_CYPRESS is not set
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
# CONFIG_HID_PICOLCD_BACKLIGHT is not set
# CONFIG_HID_PICOLCD_LEDS is not set
# CONFIG_HID_PICOLCD_CIR is not set
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_PS3REMOTE=y
CONFIG_HID_SAITEK=y
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_HYPERV_MOUSE is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=y
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=y
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
# CONFIG_MMC_BLOCK_BOUNCE is not set
CONFIG_SDIO_UART=y
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_SDHCI is not set
CONFIG_MMC_WBSD=y
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_GOLDFISH=y
CONFIG_MMC_SDRICOH_CS=y
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_LM3530=y
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_NET48XX is not set
CONFIG_LEDS_WRAP=y
CONFIG_LEDS_PCA9532=y
CONFIG_LEDS_PCA9532_GPIO=y
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA9633=y
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_WM8350=y
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_PWM=y
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_MAX8997 is not set
CONFIG_LEDS_LM355x=y
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_IDE_DISK=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
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
# CONFIG_RTC_SYSTOHC is not set
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM80X=y
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
# CONFIG_RTC_DRV_DS1672 is not set
CONFIG_RTC_DRV_DS3232=y
CONFIG_RTC_DRV_MAX6900=y
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
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_TWL4030=y
# CONFIG_RTC_DRV_TPS6586X is not set
# CONFIG_RTC_DRV_RC5T583 is not set
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=y
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
# CONFIG_RTC_DRV_DS1286 is not set
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_DA9052=y
CONFIG_RTC_DRV_STK17TA8=y
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_DS2404=y
CONFIG_RTC_DRV_WM831X=y
# CONFIG_RTC_DRV_WM8350 is not set
CONFIG_RTC_DRV_PCF50633=y

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_SNVS=y

#
# HID Sensor RTC drivers
#
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set
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
CONFIG_HYPERV=y
CONFIG_HYPERV_UTILS=y
# CONFIG_HYPERV_BALLOON is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACERHDF=y
CONFIG_ASUS_LAPTOP=y
CONFIG_CHROMEOS_LAPTOP=y
# CONFIG_DELL_LAPTOP is not set
CONFIG_FUJITSU_LAPTOP=y
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
CONFIG_FUJITSU_TABLET=y
CONFIG_AMILO_RFKILL=y
CONFIG_HP_ACCEL=y
# CONFIG_MSI_LAPTOP is not set
CONFIG_PANASONIC_LAPTOP=y
CONFIG_COMPAL_LAPTOP=y
CONFIG_SONY_LAPTOP=y
# CONFIG_SONYPI_COMPAT is not set
# CONFIG_IDEAPAD_LAPTOP is not set
CONFIG_THINKPAD_ACPI=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
# CONFIG_THINKPAD_ACPI_VIDEO is not set
# CONFIG_THINKPAD_ACPI_HOTKEY_POLL is not set
CONFIG_SENSORS_HDAPS=y
CONFIG_EEEPC_LAPTOP=y
# CONFIG_ACPI_WMI is not set
CONFIG_TOPSTAR_LAPTOP=y
CONFIG_TOSHIBA_BT_RFKILL=y
CONFIG_ACPI_CMPC=y
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
CONFIG_XO1_RFKILL=y
CONFIG_XO15_EBOOK=y
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_INTEL_OAKTRAIL=y
# CONFIG_SAMSUNG_Q10 is not set
CONFIG_APPLE_GMUX=y
# CONFIG_PVPANIC is not set
# CONFIG_GOLDFISH_PIPE is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y
CONFIG_OF_IOMMU=y
# CONFIG_INTEL_IOMMU is not set

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
CONFIG_EXTCON_ADC_JACK=y
# CONFIG_EXTCON_MAX77693 is not set
CONFIG_EXTCON_MAX8997=y
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
# CONFIG_IIO_ST_ACCEL_3AXIS is not set

#
# Analog to digital converters
#
# CONFIG_EXYNOS_ADC is not set
CONFIG_MAX1363=y
CONFIG_TI_ADC081C=y
CONFIG_TI_AM335X_ADC=y

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
CONFIG_AD5446=y
CONFIG_MAX517=y
CONFIG_MCP4725=y

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
CONFIG_ITG3200=y

#
# Inertial measurement units
#
# CONFIG_INV_MPU6050_IIO is not set

#
# Light sensors
#
CONFIG_ADJD_S311=y
CONFIG_SENSORS_LM3533=y
# CONFIG_SENSORS_TSL2563 is not set
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
CONFIG_AK8975=y
# CONFIG_IIO_ST_MAGN_3AXIS is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
# CONFIG_PWM_TWL is not set
CONFIG_PWM_TWL_LED=y
CONFIG_IRQCHIP=y
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
CONFIG_EXT4_FS_POSIX_ACL=y
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_FS_XATTR=y
# CONFIG_REISERFS_FS_POSIX_ACL is not set
# CONFIG_REISERFS_FS_SECURITY is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
CONFIG_XFS_RT=y
CONFIG_XFS_WARN=y
# CONFIG_XFS_DEBUG is not set
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y
CONFIG_BTRFS_DEBUG=y
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=y
CONFIG_ECRYPT_FS_MESSAGING=y
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
CONFIG_QNX6FS_FS=y
# CONFIG_QNX6FS_DEBUG is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_FTRACE=y
# CONFIG_PSTORE_RAM is not set
CONFIG_SYSV_FS=y
# CONFIG_UFS_FS is not set
# CONFIG_F2FS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
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
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
CONFIG_TEST_LIST_SORT=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_LKDTM=y
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
# CONFIG_FAULT_INJECTION is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
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
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_STACK_TRACER=y
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
# CONFIG_EVENT_TRACE_TEST_SYSCALLS is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
CONFIG_RING_BUFFER_STARTUP_TEST=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_FIREWIRE_OHCI_REMOTE_DMA=y
CONFIG_BUILD_DOCSRC=y
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_ASYNC_RAID6_TEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_STRICT_DEVMEM is not set
# CONFIG_X86_VERBOSE_BOOTUP is not set
# CONFIG_EARLY_PRINTK is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
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
CONFIG_CPA_DEBUG=y
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
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
CONFIG_CRYPTO_USER=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
CONFIG_CRYPTO_ABLK_HELPER_X86=y
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
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
# CONFIG_PUBLIC_KEY_ALGO_RSA is not set
# CONFIG_X509_CERTIFICATE_PARSER is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_LGUEST=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
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
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
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
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
# CONFIG_CPUMASK_OFFSTACK is not set
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
CONFIG_DDR=y
CONFIG_MPILIB=y
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_ATA_SFF is not set
# CONFIG_DRM_TTM is not set
# CONFIG_ISDN_DRV_LOOP is not set

--yNb1oOkm5a9FJOVX--
