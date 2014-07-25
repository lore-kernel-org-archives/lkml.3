Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145AbaGYX3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 19:29:47 -0400
Received: from mail-yk0-f169.google.com ([209.85.160.169]:41197 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaGYX3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 19:29:43 -0400
Message-ID: <53D2E861.2060000@gmail.com>
Date: Fri, 25 Jul 2014 19:29:37 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/1] rcu: Use rcu_gp_kthread_wake() to wake up kthreads
References: <1406264818-2296-1-git-send-email-bobby.prani@gmail.com> <CAJhHMCDQe5tSs7576uy8fRBW0txXoyUa6RiQdpg48UJs5TPsog@mail.gmail.com> <20140725150248.GZ11241@linux.vnet.ibm.com> <CAJhHMCDEFgwNVcd_ZaZ_1Eohv_eH9tCnjedxeQg122ACNdX2cQ@mail.gmail.com> <20140725231535.GH11241@linux.vnet.ibm.com>
In-Reply-To: <20140725231535.GH11241@linux.vnet.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------000105020908060809000306"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000105020908060809000306
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


On 07/25/2014 07:15 PM, Paul E. McKenney wrote:
> On Fri, Jul 25, 2014 at 06:23:41PM -0400, Pranith Kumar wrote:
>> Here total is the total number of times we enter th function rcu_report_qs_rsp()
>> and unnecessary is the times we call wake_up() unnecessarily.
>> case1, 2, 3 are the cases I listed above.
>>
>> Note that the frequency has gone way up than before, I am not sure why that is.
>>
>> *ALL* the wakeups seem to be unnecessary from that location. And the
>> main reason is that gp_flags is 0.
>>
>> My rcugp file has the following:
>>
>> completed=257515  gpnum=257516  age=1  max=1684
>>
>> Thoughts?
> Hard to believe in the rcutorture case.  My guess was that rcutorture was
> doing about 9000 wakeups, 2000 of which were unnecessary.  Which would
> of course still tilt things very much in favor of your patch.
>
> I am not surprised in the mostly-idle case, as the RCU grace-period
> kthread would most likely be the one ending the grace period, which
> would therefore almost always be a self-wakeup.
>
> Any chance of a peek at your debugging code?
>
> 							Thanx, Paul
>

Sure, I am also attaching my dmesg output. Hope it helps!

--
Pranith

---
 kernel/rcu/tree.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 946d47b..10ac44e 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1936,8 +1936,27 @@ static bool rcu_start_gp(struct rcu_state *rsp)
 static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
     __releases(rcu_get_root(rsp)->lock)
 {
+    static unsigned long total_wakeups = 0, unnecessary_wakeups = 0;
+    static unsigned long case1 = 0, case2 = 0, case3 = 0;
+
     WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
     raw_spin_unlock_irqrestore(&rcu_get_root(rsp)->lock, flags);
+    total_wakeups++;
+
+    if (current == rsp->gp_kthread ||
+        !ACCESS_ONCE(rsp->gp_flags) ||
+        !rsp->gp_kthread) {
+
+        unnecessary_wakeups++;
+        if (current == rsp->gp_kthread) case1++;
+        if (!ACCESS_ONCE(rsp->gp_flags)) case2++;
+        if (!rsp->gp_kthread) case3++;
+
+        if (unnecessary_wakeups % 2000 == 0)
+            pr_info("Total:%lu, unnecessary:%lu, case1:%lu, case2:%lu, case3:%lu\n",
+                    total_wakeups, unnecessary_wakeups, case1, case2, case3);
+
+    }
     wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
 }
 
-- 
2.0.1

--------------000105020908060809000306
Content-Type: text/plain; charset=UTF-8;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.16.0-rc6-next-20140725+ (pranith@homedesk) (gcc version 4.9.1 (Debian 4.9.1-1) ) #10 SMP Fri Jul 25 16:53:16 EDT 2014
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.16.0-rc6-next-20140725+ root=UUID=3a4fa5bb-491b-41db-829c-a075c262c775 ro quiet
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009c3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009c400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000de881fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000de882000-0x00000000dea7ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dea80000-0x00000000dea8ffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000dea90000-0x00000000deba0fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000deba1000-0x00000000dee8efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dee8f000-0x00000000dee8ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dee90000-0x00000000deed2fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000deed3000-0x00000000df7fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000f0000000-0x00000000f7ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000041effffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI:                  /DZ77GA-70K, BIOS GAZ7711H.86A.0059.2012.1106.1053 11/06/2012
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x41f000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask C00000000 write-back
[    0.000000]   1 base 400000000 mask FF0000000 write-back
[    0.000000]   2 base 410000000 mask FF8000000 write-back
[    0.000000]   3 base 418000000 mask FFC000000 write-back
[    0.000000]   4 base 41C000000 mask FFE000000 write-back
[    0.000000]   5 base 41E000000 mask FFF000000 write-back
[    0.000000]   6 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xe0000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xdf800 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd810-0x000fd81f] mapped at [ffff8800000fd810]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02153000, 0x02153fff] PGTABLE
[    0.000000] BRK [0x02154000, 0x02154fff] PGTABLE
[    0.000000] BRK [0x02155000, 0x02155fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x41ee00000-0x41effffff]
[    0.000000]  [mem 0x41ee00000-0x41effffff] page 2M
[    0.000000] BRK [0x02156000, 0x02156fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x41c000000-0x41edfffff]
[    0.000000]  [mem 0x41c000000-0x41edfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x400000000-0x41bffffff]
[    0.000000]  [mem 0x400000000-0x41bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xde881fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xde7fffff] page 2M
[    0.000000]  [mem 0xde800000-0xde881fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdee8f000-0xdee8ffff]
[    0.000000]  [mem 0xdee8f000-0xdee8ffff] page 4k
[    0.000000] BRK [0x02157000, 0x02157fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xdeed3000-0xdf7fffff]
[    0.000000]  [mem 0xdeed3000-0xdeffffff] page 4k
[    0.000000]  [mem 0xdf000000-0xdf7fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
[    0.000000]  [mem 0x100000000-0x3ffffffff] page 2M
[    0.000000] BRK [0x02158000, 0x02158fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x37a44000-0x37d19fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0490 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 0x00000000DEA83070 00005C (v01 INTEL  DZ77GA   0000003B AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000DEA8D788 00010C (v05 INTEL  DZ77GA   0000003B AMI  00010013)
[    0.000000] ACPI: DSDT 0x00000000DEA83158 00A62F (v02 INTEL  DZ77GA   00000022 INTL 20051117)
[    0.000000] ACPI: FACS 0x00000000DEB9F080 000040
[    0.000000] ACPI: APIC 0x00000000DEA8D898 000092 (v03 INTEL  DZ77GA   0000003B AMI  00010013)
[    0.000000] ACPI: FPDT 0x00000000DEA8D930 000044 (v01 INTEL  DZ77GA   0000003B AMI  00010013)
[    0.000000] ACPI: MCFG 0x00000000DEA8D978 00003C (v01 INTEL  DZ77GA   0000003B MSFT 00000097)
[    0.000000] ACPI: SSDT 0x00000000DEA8D9B8 00036D (v01 SataRe SataTabl 00001000 INTL 20091112)
[    0.000000] ACPI: SSDT 0x00000000DEA8DD28 0009AA (v01 PmRef  Cpu0Ist  00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 0x00000000DEA8E6D8 000A92 (v01 PmRef  CpuPm    00003000 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000041effffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x41efed000-0x41eff0fff]
[    0.000000]  [ffffea0000000000-ffffea00107fffff] PMD -> [ffff88040e600000-ffff88041e5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x41effffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009bfff]
[    0.000000]   node   0: [mem 0x00100000-0xde881fff]
[    0.000000]   node   0: [mem 0xdee8f000-0xdee8ffff]
[    0.000000]   node   0: [mem 0xdeed3000-0xdf7fffff]
[    0.000000]   node   0: [mem 0x100000000-0x41effffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x41effffff]
[    0.000000] On node 0 totalpages: 4186443
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3995 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14215 pages used for memmap
[    0.000000]   DMA32 zone: 909744 pages, LIFO batch:31
[    0.000000]   Normal zone: 51136 pages used for memmap
[    0.000000]   Normal zone: 3272704 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x0009c000-0x0009cfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xde882000-0xdea7ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdea80000-0xdea8ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdea90000-0xdeba0fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdeba1000-0xdee8efff]
[    0.000000] PM: Registered nosave memory: [mem 0xdee90000-0xdeed2fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdf800000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xdf800000-0xefffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88041ec00000 s80768 r8192 d21632 u262144
[    0.000000] pcpu-alloc: s80768 r8192 d21632 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4121007
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.16.0-rc6-next-20140725+ root=UUID=3a4fa5bb-491b-41db-829c-a075c262c775 ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 16395728K/16745772K available (8445K kernel code, 1147K rwdata, 2776K rodata, 1320K init, 896K bss, 350044K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU debugfs-based tracing is enabled.
[    0.000000] 	Hierarchical RCU autobalancing is disabled.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	Additional per-CPU info printed with stalls.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=64 to nr_cpu_ids=8.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-7.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
[    0.000000] NR_IRQS:4352 nr_irqs:488 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3492.349 MHz processor
[    0.000028] Calibrating delay loop (skipped), value calculated using timer frequency.. 6984.69 BogoMIPS (lpj=3492349)
[    0.000030] pid_max: default: 32768 minimum: 301
[    0.000033] ACPI: Core revision 20140627
[    0.004594] ACPI: All ACPI Tables successfully acquired
[    0.008063] Security Framework initialized
[    0.008676] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.011471] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.012721] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.012732] Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.012886] Initializing cgroup subsys freezer
[    0.012901] CPU: Physical Processor ID: 0
[    0.012902] CPU: Processor Core ID: 0
[    0.012905] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.012905] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.013170] mce: CPU supports 9 MCE banks
[    0.013179] CPU0: Thermal monitoring enabled (TM1)
[    0.013185] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
[    0.013185] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.013185] tlb_flushall_shift: 2
[    0.013295] Freeing SMP alternatives memory: 28K (ffffffff8206a000 - ffffffff82071000)
[    0.013297] ftrace: allocating 31008 entries in 122 pages
[    0.024335] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.034330] smpboot: CPU0: Intel(R) Core(TM) i7-3770K CPU @ 3.50GHz (fam: 06, model: 3a, stepping: 09)
[    0.034343] TSC deadline timer enabled
[    0.034356] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
[    0.034370] ... version:                3
[    0.034370] ... bit width:              48
[    0.034371] ... generic registers:      4
[    0.034372] ... value mask:             0000ffffffffffff
[    0.034372] ... max period:             0000ffffffffffff
[    0.034373] ... fixed-purpose events:   3
[    0.034373] ... event mask:             000000070000000f
[    0.035046] x86: Booting SMP configuration:
[    0.035048] .... node  #0, CPUs:      #1 #2 #3 #4 #5 #6 #7
[    0.129455] x86: Booted up 1 node, 8 CPUs
[    0.129458] smpboot: Total of 8 processors activated (55877.58 BogoMIPS)
[    0.134962] devtmpfs: initialized
[    0.135081] PM: Registering ACPI NVS region [mem 0xdea90000-0xdeba0fff] (1118208 bytes)
[    0.135091] PM: Registering ACPI NVS region [mem 0xdee90000-0xdeed2fff] (274432 bytes)
[    0.135165] kworker/u16:0 (58) used greatest stack depth: 14064 bytes left
[    0.135707] RTC time: 20:56:05, date: 07/25/14
[    0.135741] NET: Registered protocol family 16
[    0.135828] cpuidle: using governor ladder
[    0.135830] cpuidle: using governor menu
[    0.135863] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.135864] ACPI: bus type PCI registered
[    0.135896] PCI: MMCONFIG for domain 0000 [bus 00-7f] at [mem 0xf0000000-0xf7ffffff] (base 0xf0000000)
[    0.135898] PCI: MMCONFIG at [mem 0xf0000000-0xf7ffffff] reserved in E820
[    0.135964] PCI: Using configuration type 1 for base access
[    0.145094] ACPI: Added _OSI(Module Device)
[    0.145096] ACPI: Added _OSI(Processor Device)
[    0.145096] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.145097] ACPI: Added _OSI(Processor Aggregator Device)
[    0.146932] ACPI: Executed 1 blocks of module-level executable AML code
[    0.152104] ACPI: Dynamic OEM Table Load:
[    0.152109] ACPI: SSDT 0xFFFF88040BDCB000 00083B (v01 PmRef  Cpu0Cst  00003001 INTL 20051117)
[    0.162017] ACPI: Dynamic OEM Table Load:
[    0.162020] ACPI: SSDT 0xFFFF88040E025400 000303 (v01 PmRef  ApIst    00003000 INTL 20051117)
[    0.163945] ACPI: Dynamic OEM Table Load:
[    0.163948] ACPI: SSDT 0xFFFF88040BC02E00 000119 (v01 PmRef  ApCst    00003000 INTL 20051117)
[    0.166575] ACPI: Interpreter enabled
[    0.166579] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140627/hwxface-580)
[    0.166582] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140627/hwxface-580)
[    0.166590] ACPI: (supports S0 S3 S4 S5)
[    0.166591] ACPI: Using IOAPIC for interrupt routing
[    0.166610] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.170627] ACPI: Power Resource [FN00] (off)
[    0.170672] ACPI: Power Resource [FN01] (off)
[    0.170714] ACPI: Power Resource [FN02] (off)
[    0.170757] ACPI: Power Resource [FN03] (off)
[    0.170801] ACPI: Power Resource [FN04] (off)
[    0.171143] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7e])
[    0.171146] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.171279] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME]
[    0.171354] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
[    0.171621] PCI host bridge to bus 0000:00
[    0.171623] pci_bus 0000:00: root bus resource [bus 00-7e]
[    0.171625] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.171626] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.171627] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.171628] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.171629] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.171630] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.171631] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.171632] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.171633] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfeafffff]
[    0.171639] pci 0000:00:00.0: [8086:0150] type 00 class 0x060000
[    0.171697] pci 0000:00:01.0: [8086:0151] type 01 class 0x060400
[    0.171720] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.171746] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.171792] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
[    0.171812] pci 0000:00:14.0: reg 0x10: [mem 0xef720000-0xef72ffff 64bit]
[    0.171878] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.171909] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.171937] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    0.171957] pci 0000:00:16.0: reg 0x10: [mem 0xef73b000-0xef73b00f 64bit]
[    0.172027] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.172087] pci 0000:00:19.0: [8086:1503] type 00 class 0x020000
[    0.172104] pci 0000:00:19.0: reg 0x10: [mem 0xef700000-0xef71ffff]
[    0.172111] pci 0000:00:19.0: reg 0x14: [mem 0xef739000-0xef739fff]
[    0.172118] pci 0000:00:19.0: reg 0x18: [io  0xf040-0xf05f]
[    0.172175] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.172205] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.172232] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
[    0.172251] pci 0000:00:1a.0: reg 0x10: [mem 0xef738000-0xef7383ff]
[    0.172333] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.172374] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.172401] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
[    0.172416] pci 0000:00:1b.0: reg 0x10: [mem 0xef730000-0xef733fff 64bit]
[    0.172483] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.172514] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.172543] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    0.172678] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.172721] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.172748] pci 0000:00:1c.4: [8086:1e18] type 01 class 0x060400
[    0.172823] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.172856] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.172885] pci 0000:00:1c.5: [8086:1e1a] type 01 class 0x060400
[    0.172960] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.172994] pci 0000:00:1c.5: System wakeup disabled by ACPI
[    0.173019] pci 0000:00:1c.7: [8086:1e1e] type 01 class 0x060400
[    0.173094] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    0.173127] pci 0000:00:1c.7: System wakeup disabled by ACPI
[    0.173155] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    0.173174] pci 0000:00:1d.0: reg 0x10: [mem 0xef737000-0xef7373ff]
[    0.173256] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.173296] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.173323] pci 0000:00:1f.0: [8086:1e44] type 00 class 0x060100
[    0.173468] pci 0000:00:1f.2: [8086:1e02] type 00 class 0x010601
[    0.173484] pci 0000:00:1f.2: reg 0x10: [io  0xf090-0xf097]
[    0.173491] pci 0000:00:1f.2: reg 0x14: [io  0xf080-0xf083]
[    0.173498] pci 0000:00:1f.2: reg 0x18: [io  0xf070-0xf077]
[    0.173504] pci 0000:00:1f.2: reg 0x1c: [io  0xf060-0xf063]
[    0.173511] pci 0000:00:1f.2: reg 0x20: [io  0xf020-0xf03f]
[    0.173519] pci 0000:00:1f.2: reg 0x24: [mem 0xef736000-0xef7367ff]
[    0.173558] pci 0000:00:1f.2: PME# supported from D3hot
[    0.173607] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    0.173621] pci 0000:00:1f.3: reg 0x10: [mem 0xef735000-0xef7350ff 64bit]
[    0.173639] pci 0000:00:1f.3: reg 0x20: [io  0xf000-0xf01f]
[    0.173723] pci 0000:01:00.0: [10de:1183] type 00 class 0x030000
[    0.173733] pci 0000:01:00.0: reg 0x10: [mem 0xee000000-0xeeffffff]
[    0.173741] pci 0000:01:00.0: reg 0x14: [mem 0xe0000000-0xe7ffffff 64bit pref]
[    0.173750] pci 0000:01:00.0: reg 0x1c: [mem 0xe8000000-0xe9ffffff 64bit pref]
[    0.173756] pci 0000:01:00.0: reg 0x24: [io  0xe000-0xe07f]
[    0.173762] pci 0000:01:00.0: reg 0x30: [mem 0xef000000-0xef07ffff pref]
[    0.173823] pci 0000:01:00.1: [10de:0e0a] type 00 class 0x040300
[    0.173832] pci 0000:01:00.1: reg 0x10: [mem 0xef080000-0xef083fff]
[    0.175895] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.175899] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.175903] pci 0000:00:01.0:   bridge window [mem 0xee000000-0xef0fffff]
[    0.175907] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xe9ffffff 64bit pref]
[    0.175990] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.176151] pci 0000:03:00.0: [8086:10d3] type 00 class 0x020000
[    0.176193] pci 0000:03:00.0: reg 0x10: [mem 0xef620000-0xef63ffff]
[    0.176218] pci 0000:03:00.0: reg 0x14: [mem 0xef600000-0xef61ffff]
[    0.176244] pci 0000:03:00.0: reg 0x18: [io  0xd000-0xd01f]
[    0.176269] pci 0000:03:00.0: reg 0x1c: [mem 0xef640000-0xef643fff]
[    0.176497] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.176544] pci 0000:03:00.0: System wakeup disabled by ACPI
[    0.177908] pci 0000:00:1c.4: PCI bridge to [bus 03]
[    0.177913] pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
[    0.177918] pci 0000:00:1c.4:   bridge window [mem 0xef600000-0xef6fffff]
[    0.178016] pci 0000:04:00.0: [10b5:8606] type 01 class 0x060400
[    0.178054] pci 0000:04:00.0: reg 0x10: [mem 0xef400000-0xef41ffff]
[    0.178323] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    0.178367] pci 0000:04:00.0: System wakeup disabled by ACPI
[    0.179907] pci 0000:00:1c.5: PCI bridge to [bus 04-0b]
[    0.179921] pci 0000:00:1c.5:   bridge window [io  0xc000-0xcfff]
[    0.179924] pci 0000:00:1c.5:   bridge window [mem 0xef100000-0xef4fffff]
[    0.180090] pci 0000:05:01.0: [10b5:8606] type 01 class 0x060400
[    0.180388] pci 0000:05:01.0: PME# supported from D0 D3hot D3cold
[    0.180486] pci 0000:05:04.0: [10b5:8606] type 01 class 0x060400
[    0.180785] pci 0000:05:04.0: PME# supported from D0 D3hot D3cold
[    0.180878] pci 0000:05:05.0: [10b5:8606] type 01 class 0x060400
[    0.181177] pci 0000:05:05.0: PME# supported from D0 D3hot D3cold
[    0.181273] pci 0000:05:07.0: [10b5:8606] type 01 class 0x060400
[    0.181572] pci 0000:05:07.0: PME# supported from D0 D3hot D3cold
[    0.181667] pci 0000:05:09.0: [10b5:8606] type 01 class 0x060400
[    0.181966] pci 0000:05:09.0: PME# supported from D0 D3hot D3cold
[    0.182087] pci 0000:04:00.0: PCI bridge to [bus 05-0b]
[    0.182101] pci 0000:04:00.0:   bridge window [io  0xc000-0xcfff]
[    0.182109] pci 0000:04:00.0:   bridge window [mem 0xef100000-0xef3fffff]
[    0.182283] pci 0000:06:00.0: [1814:3090] type 00 class 0x028000
[    0.182324] pci 0000:06:00.0: reg 0x10: [mem 0xef300000-0xef30ffff]
[    0.182627] pci 0000:06:00.0: PME# supported from D0 D3hot
[    0.182745] pci 0000:05:01.0: PCI bridge to [bus 06]
[    0.182765] pci 0000:05:01.0:   bridge window [mem 0xef300000-0xef3fffff]
[    0.182944] pci 0000:07:00.0: [1b4b:9172] type 00 class 0x010601
[    0.182986] pci 0000:07:00.0: reg 0x10: [io  0xc040-0xc047]
[    0.183012] pci 0000:07:00.0: reg 0x14: [io  0xc030-0xc033]
[    0.183037] pci 0000:07:00.0: reg 0x18: [io  0xc020-0xc027]
[    0.183062] pci 0000:07:00.0: reg 0x1c: [io  0xc010-0xc013]
[    0.183088] pci 0000:07:00.0: reg 0x20: [io  0xc000-0xc00f]
[    0.183114] pci 0000:07:00.0: reg 0x24: [mem 0xef220000-0xef2201ff]
[    0.183140] pci 0000:07:00.0: reg 0x30: [mem 0xef200000-0xef21ffff pref]
[    0.183274] pci 0000:07:00.0: PME# supported from D3hot
[    0.183389] pci 0000:05:04.0: PCI bridge to [bus 07]
[    0.183403] pci 0000:05:04.0:   bridge window [io  0xc000-0xcfff]
[    0.183411] pci 0000:05:04.0:   bridge window [mem 0xef200000-0xef2fffff]
[    0.183548] pci 0000:05:05.0: PCI bridge to [bus 08]
[    0.183700] pci 0000:05:07.0: PCI bridge to [bus 09]
[    0.183893] pci 0000:0a:00.0: [1283:8892] type 01 class 0x060401
[    0.184167] pci 0000:0a:00.0: supports D1 D2
[    0.184168] pci 0000:0a:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.184226] pci 0000:05:09.0: PCI bridge to [bus 0a-0b]
[    0.184246] pci 0000:05:09.0:   bridge window [mem 0xef100000-0xef1fffff]
[    0.184401] pci 0000:0b:02.0: [104c:8023] type 00 class 0x0c0010
[    0.184461] pci 0000:0b:02.0: reg 0x10: [mem 0xef104000-0xef1047ff]
[    0.184495] pci 0000:0b:02.0: reg 0x14: [mem 0xef100000-0xef103fff]
[    0.184755] pci 0000:0b:02.0: supports D1 D2
[    0.184756] pci 0000:0b:02.0: PME# supported from D0 D1 D2 D3hot
[    0.184933] pci 0000:0a:00.0: PCI bridge to [bus 0b] (subtractive decode)
[    0.184961] pci 0000:0a:00.0:   bridge window [mem 0xef100000-0xef1fffff]
[    0.184981] pci 0000:0a:00.0:   bridge window [mem 0xef100000-0xef1fffff] (subtractive decode)
[    0.185150] pci 0000:0c:00.0: [1b4b:9172] type 00 class 0x010601
[    0.185172] pci 0000:0c:00.0: reg 0x10: [io  0xb040-0xb047]
[    0.185186] pci 0000:0c:00.0: reg 0x14: [io  0xb030-0xb033]
[    0.185199] pci 0000:0c:00.0: reg 0x18: [io  0xb020-0xb027]
[    0.185213] pci 0000:0c:00.0: reg 0x1c: [io  0xb010-0xb013]
[    0.185226] pci 0000:0c:00.0: reg 0x20: [io  0xb000-0xb00f]
[    0.185240] pci 0000:0c:00.0: reg 0x24: [mem 0xef520000-0xef5201ff]
[    0.185254] pci 0000:0c:00.0: reg 0x30: [mem 0xef500000-0xef51ffff pref]
[    0.185323] pci 0000:0c:00.0: PME# supported from D3hot
[    0.185347] pci 0000:0c:00.0: System wakeup disabled by ACPI
[    0.186915] pci 0000:00:1c.7: PCI bridge to [bus 0c]
[    0.186921] pci 0000:00:1c.7:   bridge window [io  0xb000-0xbfff]
[    0.186926] pci 0000:00:1c.7:   bridge window [mem 0xef500000-0xef5fffff]
[    0.187086] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
[    0.187412] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.187444] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.187475] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.187506] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.187537] ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 6 10 11 12 14 15)
[    0.187568] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.187599] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.187630] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.187756] ACPI: Enabled 4 GPEs in block 00 to 3F
[    0.187817] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.187819] vgaarb: loaded
[    0.187819] vgaarb: bridge control possible 0000:01:00.0
[    0.187864] SCSI subsystem initialized
[    0.187902] libata version 3.00 loaded.
[    0.187924] ACPI: bus type USB registered
[    0.187940] usbcore: registered new interface driver usbfs
[    0.187946] usbcore: registered new interface driver hub
[    0.187962] usbcore: registered new device driver usb
[    0.187985] pps_core: LinuxPPS API ver. 1 registered
[    0.187986] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.187989] PTP clock support registered
[    0.188060] Advanced Linux Sound Architecture Driver Initialized.
[    0.188062] PCI: Using ACPI for IRQ routing
[    0.190731] PCI: pci_cache_line_size set to 64 bytes
[    0.190821] e820: reserve RAM buffer [mem 0x0009c400-0x0009ffff]
[    0.190822] e820: reserve RAM buffer [mem 0xde882000-0xdfffffff]
[    0.190823] e820: reserve RAM buffer [mem 0xdee90000-0xdfffffff]
[    0.190824] e820: reserve RAM buffer [mem 0xdf800000-0xdfffffff]
[    0.190824] e820: reserve RAM buffer [mem 0x41f000000-0x41fffffff]
[    0.190937] cfg80211: Calling CRDA to update world regulatory domain
[    0.190949] NetLabel: Initializing
[    0.190951] NetLabel:  domain hash size = 128
[    0.190952] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.190964] NetLabel:  unlabeled traffic allowed by default
[    0.191030] Switched to clocksource refined-jiffies
[    0.195623] pnp: PnP ACPI init
[    0.195694] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.195696] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.195748] system 00:01: [io  0x0680-0x069f] has been reserved
[    0.195750] system 00:01: [io  0x1000-0x100f] has been reserved
[    0.195751] system 00:01: [io  0xffff] has been reserved
[    0.195752] system 00:01: [io  0xffff] has been reserved
[    0.195753] system 00:01: [io  0x0400-0x0453] could not be reserved
[    0.195754] system 00:01: [io  0x0458-0x047f] has been reserved
[    0.195756] system 00:01: [io  0x0500-0x057f] has been reserved
[    0.195757] system 00:01: [io  0x164e-0x164f] has been reserved
[    0.195758] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.195771] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.195800] system 00:03: [io  0x0454-0x0457] has been reserved
[    0.195801] system 00:03: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.195849] system 00:04: [io  0x0a00-0x0a0f] has been reserved
[    0.195850] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.196004] pnp 00:05: [dma 0 disabled]
[    0.196031] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.196066] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    0.196068] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.196256] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.196257] system 00:07: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.196258] system 00:07: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.196260] system 00:07: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.196261] system 00:07: [mem 0xf0000000-0xf7ffffff] has been reserved
[    0.196262] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.196263] system 00:07: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.196264] system 00:07: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.196266] system 00:07: [mem 0xff000000-0xffffffff] has been reserved
[    0.196267] system 00:07: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.196268] system 00:07: [mem 0xea000000-0xea000fff] has been reserved
[    0.196269] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.196343] pnp: PnP ACPI: found 8 devices
[    0.201755] Switched to clocksource acpi_pm
[    0.201895] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.201899] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.201904] pci 0000:00:01.0:   bridge window [mem 0xee000000-0xef0fffff]
[    0.201906] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xe9ffffff 64bit pref]
[    0.201911] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.201929] pci 0000:00:1c.4: PCI bridge to [bus 03]
[    0.201932] pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
[    0.201936] pci 0000:00:1c.4:   bridge window [mem 0xef600000-0xef6fffff]
[    0.201944] pci 0000:05:01.0: PCI bridge to [bus 06]
[    0.201950] pci 0000:05:01.0:   bridge window [mem 0xef300000-0xef3fffff]
[    0.201961] pci 0000:05:04.0: PCI bridge to [bus 07]
[    0.201964] pci 0000:05:04.0:   bridge window [io  0xc000-0xcfff]
[    0.201970] pci 0000:05:04.0:   bridge window [mem 0xef200000-0xef2fffff]
[    0.201980] pci 0000:05:05.0: PCI bridge to [bus 08]
[    0.201996] pci 0000:05:07.0: PCI bridge to [bus 09]
[    0.202011] pci 0000:0a:00.0: PCI bridge to [bus 0b]
[    0.202022] pci 0000:0a:00.0:   bridge window [mem 0xef100000-0xef1fffff]
[    0.202044] pci 0000:05:09.0: PCI bridge to [bus 0a-0b]
[    0.202051] pci 0000:05:09.0:   bridge window [mem 0xef100000-0xef1fffff]
[    0.202061] pci 0000:04:00.0: PCI bridge to [bus 05-0b]
[    0.202064] pci 0000:04:00.0:   bridge window [io  0xc000-0xcfff]
[    0.202070] pci 0000:04:00.0:   bridge window [mem 0xef100000-0xef3fffff]
[    0.202080] pci 0000:00:1c.5: PCI bridge to [bus 04-0b]
[    0.202083] pci 0000:00:1c.5:   bridge window [io  0xc000-0xcfff]
[    0.202088] pci 0000:00:1c.5:   bridge window [mem 0xef100000-0xef4fffff]
[    0.202095] pci 0000:00:1c.7: PCI bridge to [bus 0c]
[    0.202098] pci 0000:00:1c.7:   bridge window [io  0xb000-0xbfff]
[    0.202102] pci 0000:00:1c.7:   bridge window [mem 0xef500000-0xef5fffff]
[    0.202110] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.202111] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.202112] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.202113] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.202114] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.202115] pci_bus 0000:00: resource 9 [mem 0x000dc000-0x000dffff]
[    0.202116] pci_bus 0000:00: resource 10 [mem 0x000e0000-0x000e3fff]
[    0.202118] pci_bus 0000:00: resource 11 [mem 0x000e4000-0x000e7fff]
[    0.202119] pci_bus 0000:00: resource 12 [mem 0xe0000000-0xfeafffff]
[    0.202120] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.202121] pci_bus 0000:01: resource 1 [mem 0xee000000-0xef0fffff]
[    0.202122] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xe9ffffff 64bit pref]
[    0.202123] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    0.202124] pci_bus 0000:03: resource 1 [mem 0xef600000-0xef6fffff]
[    0.202125] pci_bus 0000:04: resource 0 [io  0xc000-0xcfff]
[    0.202126] pci_bus 0000:04: resource 1 [mem 0xef100000-0xef4fffff]
[    0.202127] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    0.202128] pci_bus 0000:05: resource 1 [mem 0xef100000-0xef3fffff]
[    0.202129] pci_bus 0000:06: resource 1 [mem 0xef300000-0xef3fffff]
[    0.202130] pci_bus 0000:07: resource 0 [io  0xc000-0xcfff]
[    0.202131] pci_bus 0000:07: resource 1 [mem 0xef200000-0xef2fffff]
[    0.202133] pci_bus 0000:0a: resource 1 [mem 0xef100000-0xef1fffff]
[    0.202134] pci_bus 0000:0b: resource 1 [mem 0xef100000-0xef1fffff]
[    0.202135] pci_bus 0000:0b: resource 4 [mem 0xef100000-0xef1fffff]
[    0.202136] pci_bus 0000:0c: resource 0 [io  0xb000-0xbfff]
[    0.202137] pci_bus 0000:0c: resource 1 [mem 0xef500000-0xef5fffff]
[    0.202159] NET: Registered protocol family 2
[    0.202292] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.202445] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.202535] TCP: Hash tables configured (established 131072 bind 65536)
[    0.202545] TCP: reno registered
[    0.202558] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.202593] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.202644] NET: Registered protocol family 1
[    0.202704] RPC: Registered named UNIX socket transport module.
[    0.202705] RPC: Registered udp transport module.
[    0.202705] RPC: Registered tcp transport module.
[    0.202706] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.202803] pci 0000:00:14.0: CONFIG_USB_XHCI_HCD is turned off, defaulting to EHCI.
[    0.202804] pci 0000:00:14.0: USB 3.0 devices will work at USB 2.0 speeds.
[    0.233834] pci 0000:01:00.0: Boot video device
[    0.233878] PCI: CLS 64 bytes, default 64
[    0.233910] Unpacking initramfs...
[    0.266718] Freeing initrd memory: 2904K (ffff880037a44000 - ffff880037d1a000)
[    0.266726] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.266727] software IO TLB [mem 0xda882000-0xde882000] (64MB) mapped at [ffff8800da882000-ffff8800de881fff]
[    0.266940] RAPL PMU detected, hw unit 2^-16 Joules, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
[    0.266974] microcode: CPU0 sig=0x306a9, pf=0x2, revision=0x15
[    0.266980] microcode: CPU1 sig=0x306a9, pf=0x2, revision=0x15
[    0.266983] microcode: CPU2 sig=0x306a9, pf=0x2, revision=0x15
[    0.266988] microcode: CPU3 sig=0x306a9, pf=0x2, revision=0x15
[    0.266995] microcode: CPU4 sig=0x306a9, pf=0x2, revision=0x15
[    0.266999] microcode: CPU5 sig=0x306a9, pf=0x2, revision=0x15
[    0.267003] microcode: CPU6 sig=0x306a9, pf=0x2, revision=0x15
[    0.267009] microcode: CPU7 sig=0x306a9, pf=0x2, revision=0x15
[    0.267040] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.267379] Scanning for low memory corruption every 60 seconds
[    0.267548] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    0.267572] audit: initializing netlink subsys (disabled)
[    0.267583] audit: type=2000 audit(1406321765.245:1): initialized
[    0.267721] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.268706] VFS: Disk quotas dquot_6.5.2
[    0.268727] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.269044] NFS: Registering the id_resolver key type
[    0.269049] Key type id_resolver registered
[    0.269050] Key type id_legacy registered
[    0.269087] msgmni has been set to 32028
[    0.269472] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    0.269475] io scheduler noop registered
[    0.269477] io scheduler deadline registered
[    0.269494] io scheduler cfq registered (default)
[    0.269608] pcieport 0000:00:01.0: irq 24 for MSI/MSI-X
[    0.270046] pcieport 0000:04:00.0: irq 25 for MSI/MSI-X
[    0.270222] pcieport 0000:05:01.0: irq 26 for MSI/MSI-X
[    0.270384] pcieport 0000:05:04.0: irq 27 for MSI/MSI-X
[    0.270547] pcieport 0000:05:05.0: irq 28 for MSI/MSI-X
[    0.270716] pcieport 0000:05:07.0: irq 29 for MSI/MSI-X
[    0.270882] pcieport 0000:05:09.0: irq 30 for MSI/MSI-X
[    0.271009] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.271082] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.271084] ACPI: Power Button [PWRB]
[    0.271104] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.271105] ACPI: Power Button [PWRF]
[    0.271146] ACPI: Fan [FAN0] (off)
[    0.271160] ACPI: Fan [FAN1] (off)
[    0.271176] ACPI: Fan [FAN2] (off)
[    0.271189] ACPI: Fan [FAN3] (off)
[    0.271203] ACPI: Fan [FAN4] (off)
[    0.282866] Monitor-Mwait will be used to enter C-1 state
[    0.282878] Monitor-Mwait will be used to enter C-2 state
[    0.282888] ACPI: acpi_idle registered with cpuidle
[    0.294938] thermal LNXTHERM:00: registered as thermal_zone0
[    0.294940] ACPI: Thermal Zone [TZ00] (28 C)
[    0.295070] thermal LNXTHERM:01: registered as thermal_zone1
[    0.295071] ACPI: Thermal Zone [TZ01] (30 C)
[    0.295132] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.315748] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.316015] Non-volatile memory driver v1.3
[    0.316019] Linux agpgart interface v0.103
[    0.316059] [drm] Initialized drm 1.1.0 20060810
[    0.316545] loop: module loaded
[    0.316594] ahci 0000:00:1f.2: version 3.0
[    0.316669] ahci 0000:00:1f.2: forcing PORTS_IMPL to 0x3f
[    0.316688] ahci 0000:00:1f.2: irq 31 for MSI/MSI-X
[    0.316732] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3f impl SATA mode
[    0.316734] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part ems apst 
[    0.317068] scsi host0: ahci
[    0.317157] scsi host1: ahci
[    0.317236] scsi host2: ahci
[    0.317311] scsi host3: ahci
[    0.317382] scsi host4: ahci
[    0.317466] scsi host5: ahci
[    0.317501] ata1: SATA max UDMA/133 abar m2048@0xef736000 port 0xef736100 irq 31
[    0.317504] ata2: SATA max UDMA/133 abar m2048@0xef736000 port 0xef736180 irq 31
[    0.317505] ata3: SATA max UDMA/133 abar m2048@0xef736000 port 0xef736200 irq 31
[    0.317508] ata4: SATA max UDMA/133 abar m2048@0xef736000 port 0xef736280 irq 31
[    0.317510] ata5: SATA max UDMA/133 abar m2048@0xef736000 port 0xef736300 irq 31
[    0.317512] ata6: SATA max UDMA/133 abar m2048@0xef736000 port 0xef736380 irq 31
[    0.317615] ahci 0000:07:00.0: irq 32 for MSI/MSI-X
[    0.317722] ahci 0000:07:00.0: AHCI 0001.0000 32 slots 2 ports 6 Gbps 0x3 impl SATA mode
[    0.317724] ahci 0000:07:00.0: flags: 64bit ncq sntf led only pmp fbs pio slum part sxs 
[    0.317891] scsi host6: ahci
[    0.317968] scsi host7: ahci
[    0.317995] ata7: SATA max UDMA/133 abar m512@0xef220000 port 0xef220100 irq 32
[    0.317998] ata8: SATA max UDMA/133 abar m512@0xef220000 port 0xef220180 irq 32
[    0.318091] ahci 0000:0c:00.0: irq 33 for MSI/MSI-X
[    0.318133] ahci 0000:0c:00.0: AHCI 0001.0000 32 slots 2 ports 6 Gbps 0x3 impl SATA mode
[    0.318135] ahci 0000:0c:00.0: flags: 64bit ncq sntf led only pmp fbs pio slum part sxs 
[    0.318286] scsi host8: ahci
[    0.318358] scsi host9: ahci
[    0.318380] ata9: SATA max UDMA/133 abar m512@0xef520000 port 0xef520100 irq 33
[    0.318383] ata10: SATA max UDMA/133 abar m512@0xef520000 port 0xef520180 irq 33
[    0.318444] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    0.318444] e100: Copyright(c) 1999-2006 Intel Corporation
[    0.318454] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    0.318455] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    0.318465] sky2: driver version 1.30
[    0.318547] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.318548] ehci-pci: EHCI PCI platform driver
[    0.318615] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    0.318643] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.318658] ehci-pci 0000:00:1a.0: debug port 2
[    0.322571] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    0.322582] ehci-pci 0000:00:1a.0: irq 16, io mem 0xef738000
[    0.327677] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.327718] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.327720] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.327721] usb usb1: Product: EHCI Host Controller
[    0.327722] usb usb1: Manufacturer: Linux 3.16.0-rc6-next-20140725+ ehci_hcd
[    0.327723] usb usb1: SerialNumber: 0000:00:1a.0
[    0.327793] hub 1-0:1.0: USB hub found
[    0.327798] hub 1-0:1.0: 2 ports detected
[    0.327918] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    0.327979] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.327990] ehci-pci 0000:00:1d.0: debug port 2
[    0.331872] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    0.331882] ehci-pci 0000:00:1d.0: irq 23, io mem 0xef737000
[    0.337672] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.337713] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.337715] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.337716] usb usb2: Product: EHCI Host Controller
[    0.337717] usb usb2: Manufacturer: Linux 3.16.0-rc6-next-20140725+ ehci_hcd
[    0.337718] usb usb2: SerialNumber: 0000:00:1d.0
[    0.337810] hub 2-0:1.0: USB hub found
[    0.337815] hub 2-0:1.0: 2 ports detected
[    0.337876] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.337879] ohci-pci: OHCI PCI platform driver
[    0.337887] uhci_hcd: USB Universal Host Controller Interface driver
[    0.337904] usbcore: registered new interface driver usblp
[    0.337916] usbcore: registered new interface driver usb-storage
[    0.337935] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.340931] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.340935] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.340991] mousedev: PS/2 mouse device common for all mice
[    0.341113] rtc_cmos 00:02: RTC can wake from S4
[    0.341228] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    0.341258] rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes nvram
[    0.341318] ACPI Warning: SystemIO range 0x000000000000f000-0x000000000000f01f conflicts with OpRegion 0x000000000000f000-0x000000000000f00f (\_SB_.PCI0.SBUS.SMBI) (20140627/utaddress-258)
[    0.341321] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    0.341382] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    0.341392] Intel P-state driver initializing.
[    0.341403] Intel pstate controlling: cpu 0
[    0.341418] Intel pstate controlling: cpu 1
[    0.341427] Intel pstate controlling: cpu 2
[    0.341441] Intel pstate controlling: cpu 3
[    0.341465] Intel pstate controlling: cpu 4
[    0.341507] Intel pstate controlling: cpu 5
[    0.341531] Intel pstate controlling: cpu 6
[    0.341559] Intel pstate controlling: cpu 7
[    0.341621] hidraw: raw HID events driver (C) Jiri Kosina
[    0.341885] usbcore: registered new interface driver usbhid
[    0.341886] usbhid: USB HID core driver
[    0.342314] snd_hda_intel 0000:01:00.1: Disabling MSI
[    0.342350] Netfilter messages via NETLINK v0.30.
[    0.342362] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    0.342461] ctnetlink v0.93: registering with nfnetlink.
[    0.343056] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.343180] TCP: cubic registered
[    0.343185] Initializing XFRM netlink socket
[    0.343348] NET: Registered protocol family 10
[    0.343522] snd_hda_intel 0000:00:1b.0: irq 34 for MSI/MSI-X
[    0.343586] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    0.344237] sit: IPv6 over IPv4 tunneling driver
[    0.344393] NET: Registered protocol family 17
[    0.344422] Key type dns_resolver registered
[    0.344887] registered taskstats version 1
[    0.345637]   Magic number: 6:897:953
[    0.345717] console [netcon0] enabled
[    0.345719] netconsole: network logging started
[    0.345806] PM: Hibernation image not present or could not be loaded.
[    0.345811] ALSA device list:
[    0.345812]   No soundcards found.
[    0.352532] sound hdaudioC0D2: autoconfig: line_outs=3 (0x14/0x15/0x16/0x0/0x0) type:line
[    0.352535] sound hdaudioC0D2:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    0.352537] sound hdaudioC0D2:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    0.352539] sound hdaudioC0D2:    mono: mono_out=0x0
[    0.352541] sound hdaudioC0D2:    dig-out=0x11/0x1e
[    0.352542] sound hdaudioC0D2:    inputs:
[    0.352545] sound hdaudioC0D2:      Front Mic=0x19
[    0.352547] sound hdaudioC0D2:      Rear Mic=0x18
[    0.352549] sound hdaudioC0D2:      Line=0x1a
[    0.440598] sound hdaudioC1D0: ignore pin 0x6, too many assigned pins
[    0.443591] sound hdaudioC1D0: ignore pin 0x7, too many assigned pins
[    0.443595] sound hdaudioC1D0: autoconfig: line_outs=0 (0x0/0x0/0x0/0x0/0x0) type:line
[    0.443597] sound hdaudioC1D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    0.443600] sound hdaudioC1D0:    hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    0.443601] sound hdaudioC1D0:    mono: mono_out=0x0
[    0.443603] sound hdaudioC1D0:    dig-out=0x4/0x5
[    0.443605] sound hdaudioC1D0:    inputs:
[    0.622486] ata8: SATA link down (SStatus 0 SControl 300)
[    0.622558] ata7: SATA link down (SStatus 0 SControl 300)
[    0.629481] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    0.743696] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    0.743699] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    0.743955] hub 1-1:1.0: USB hub found
[    0.744041] hub 1-1:1.0: 6 ports detected
[    0.777354] ata10: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    0.777380] ata9: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    0.783530] ata9.00: ATA-8: WDC WD20EARX-00PASB0, 51.0AB51, max UDMA/133
[    0.783534] ata9.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    0.788487] ata10.00: ATA-9: INTEL SSDSC2CW180A3, 400i, max UDMA/133
[    0.788489] ata10.00: 351651888 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    0.789567] ata9.00: configured for UDMA/133
[    0.798440] ata10.00: configured for UDMA/133
[    0.847285] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    0.961643] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    0.961646] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    0.961909] hub 2-1:1.0: USB hub found
[    0.962008] hub 2-1:1.0: 8 ports detected
[    1.036192] usb 1-1.1: new high-speed USB device number 3 using ehci-pci
[    1.140896] usb 1-1.1: New USB device found, idVendor=0db0, idProduct=3871
[    1.140899] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.140901] usb 1-1.1: Product: 802.11 n WLAN
[    1.140903] usb 1-1.1: Manufacturer: Ralink
[    1.140905] usb 1-1.1: SerialNumber: 1.0
[    1.215047] usb 1-1.2: new full-speed USB device number 4 using ehci-pci
[    1.266954] tsc: Refined TSC clocksource calibration: 3492.067 MHz
[    1.322906] ata2: failed to resume link (SControl 0)
[    1.322927] ata2: SATA link down (SStatus 0 SControl 0)
[    1.322939] ata4: failed to resume link (SControl 0)
[    1.322953] ata4: SATA link down (SStatus 0 SControl 0)
[    1.322968] ata3: failed to resume link (SControl 0)
[    1.322982] ata3: SATA link down (SStatus 0 SControl 0)
[    1.322995] ata1: failed to resume link (SControl 0)
[    1.323005] ata1: SATA link down (SStatus 0 SControl 0)
[    1.323868] ata6: failed to resume link (SControl 0)
[    1.323878] ata6: SATA link down (SStatus 0 SControl 0)
[    1.323888] ata5: failed to resume link (SControl 0)
[    1.323899] ata5: SATA link down (SStatus 0 SControl 0)
[    1.324190] scsi 8:0:0:0: Direct-Access     ATA      WDC WD20EARX-00P AB51 PQ: 0 ANSI: 5
[    1.324537] sd 8:0:0:0: Attached scsi generic sg0 type 0
[    1.324542] sd 8:0:0:0: [sda] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    1.324545] sd 8:0:0:0: [sda] 4096-byte physical blocks
[    1.324709] sd 8:0:0:0: [sda] Write Protect is off
[    1.324713] sd 8:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.324745] scsi 9:0:0:0: Direct-Access     ATA      INTEL SSDSC2CW18 400i PQ: 0 ANSI: 5
[    1.324805] sd 8:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.324939] sd 9:0:0:0: [sdb] 351651888 512-byte logical blocks: (180 GB/167 GiB)
[    1.324949] sd 9:0:0:0: Attached scsi generic sg1 type 0
[    1.325026] sd 9:0:0:0: [sdb] Write Protect is off
[    1.325029] sd 9:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.325047] sd 9:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.325983]  sdb: sdb1 sdb2 < sdb5 sdb6 > sdb3 sdb4
[    1.326404] sd 9:0:0:0: [sdb] Attached SCSI disk
[    1.339603]  sda: sda1 sda2
[    1.340104] sd 8:0:0:0: [sda] Attached SCSI disk
[    1.341267] Freeing unused kernel memory: 1320K (ffffffff81f20000 - ffffffff8206a000)
[    1.341270] Write protecting the kernel read-only data: 14336k
[    1.346697] Freeing unused kernel memory: 1784K (ffff880001842000 - ffff880001a00000)
[    1.350354] Freeing unused kernel memory: 1320K (ffff880001cb6000 - ffff880001e00000)
[    1.353999] exe (1236) used greatest stack depth: 14024 bytes left
[    1.362732] systemd-udevd[1248]: starting version 208
[    1.363171] random: systemd-udevd urandom read with 35 bits of entropy available
[    1.386605] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    1.386608] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    1.386798] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    1.386843] e1000e 0000:00:19.0: irq 35 for MSI/MSI-X
[    1.400418] ata_id (1277) used greatest stack depth: 13960 bytes left
[    1.441871] firewire_ohci 0000:0b:02.0: added OHCI v1.10 device as card 0, 4 IR + 8 IT contexts, quirks 0x2
[    1.470123] usb 1-1.2: New USB device found, idVendor=0db0, idProduct=a871
[    1.470127] usb 1-1.2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.543791] usb 1-1.6: new full-speed USB device number 5 using ehci-pci
[    1.634734] usb 1-1.6: New USB device found, idVendor=045e, idProduct=0745
[    1.634739] usb 1-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.634751] usb 1-1.6: Product: Microsoft\xffffffc2\xffffffae\xffffffae 2.4GHz Transceiver v6.0
[    1.634753] usb 1-1.6: Manufacturer: Microsoft
[    1.636355] e1000e 0000:00:19.0 eth0: registered PHC clock
[    1.636358] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:22:4d:81:ba:2e
[    1.636360] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    1.636417] e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No: FFFFFF-0FF
[    1.636630] e1000e 0000:03:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    1.636656] e1000e 0000:03:00.0: irq 36 for MSI/MSI-X
[    1.636659] e1000e 0000:03:00.0: irq 37 for MSI/MSI-X
[    1.636662] e1000e 0000:03:00.0: irq 38 for MSI/MSI-X
[    1.637689] input: Microsoft Microsoft\xffffffc2\xffffffae\xffffffae 2.4GHz Transceiver v6.0 as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/0003:045E:0745.0001/input/input5
[    1.637883] hid-generic 0003:045E:0745.0001: input,hidraw0: USB HID v1.11 Keyboard [Microsoft Microsoft\xffffffc2\xffffffae\xffffffae 2.4GHz Transceiver v6.0] on usb-0000:00:1a.0-1.6/input0
[    1.643722] input: Microsoft Microsoft\xffffffc2\xffffffae\xffffffae 2.4GHz Transceiver v6.0 as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.1/0003:045E:0745.0002/input/input6
[    1.643915] hid-generic 0003:045E:0745.0002: input,hidraw1: USB HID v1.11 Mouse [Microsoft Microsoft\xffffffc2\xffffffae\xffffffae 2.4GHz Transceiver v6.0] on usb-0000:00:1a.0-1.6/input1
[    1.659412] input: Microsoft Microsoft\xffffffc2\xffffffae\xffffffae 2.4GHz Transceiver v6.0 as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.2/0003:045E:0745.0003/input/input7
[    1.669656] input: failed to attach handler kbd to device input7, error: -16
[    1.672655] sysrq: Failed to open input device, error -16
[    1.675645] input: failed to attach handler sysrq to device input7, error: -16
[    1.675856] hid-generic 0003:045E:0745.0003: input,hiddev0,hidraw2: USB HID v1.11 Device [Microsoft Microsoft\xffffffc2\xffffffae\xffffffae 2.4GHz Transceiver v6.0] on usb-0000:00:1a.0-1.6/input2
[    1.741151] e1000e 0000:03:00.0 eth1: registered PHC clock
[    1.741156] e1000e 0000:03:00.0 eth1: (PCI Express:2.5GT/s:Width x1) 00:22:4d:81:ba:32
[    1.741158] e1000e 0000:03:00.0 eth1: Intel(R) PRO/1000 Network Connection
[    1.741177] e1000e 0000:03:00.0 eth1: MAC: 3, PHY: 8, PBA No: FFFFFF-0FF
[    1.748638] usb 2-1.1: new high-speed USB device number 3 using ehci-pci
[    1.753011] PM: Starting manual resume from disk
[    1.753014] PM: Hibernation image partition 8:21 present
[    1.753016] PM: Looking for hibernation image.
[    1.753185] PM: Image not found (code -22)
[    1.753189] PM: Hibernation image not present or could not be loaded.
[    1.756812] EXT4-fs (sdb6): mounted filesystem with ordered data mode. Opts: (null)
[    1.756907] exe (1298) used greatest stack depth: 13608 bytes left
[    1.760198] systemd-udevd (1255) used greatest stack depth: 13352 bytes left
[    1.786314] readlink (1309) used greatest stack depth: 13288 bytes left
[    1.817881] systemd[1]: systemd 208 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    1.818372] systemd[1]: Set hostname to <homedesk>.
[    1.840524] usb 2-1.1: New USB device found, idVendor=05e3, idProduct=0610
[    1.840527] usb 2-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.840530] usb 2-1.1: Product: USB2.0 Hub 456
[    1.840531] usb 2-1.1: Manufacturer: GenesysLogic
[    1.841561] hub 2-1.1:1.0: USB hub found
[    1.842667] hub 2-1.1:1.0: 3 ports detected
[    1.901971] systemd[1]: Starting Syslog Socket.
[    1.902016] systemd[1]: Listening on Syslog Socket.
[    1.902033] systemd[1]: Starting Forward Password Requests to Wall Directory Watch.
[    1.902098] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
[    1.902113] systemd[1]: Starting Remote File Systems (Pre).
[    1.902128] systemd[1]: Reached target Remote File Systems (Pre).
[    1.902141] systemd[1]: Starting Delayed Shutdown Socket.
[    1.902169] systemd[1]: Listening on Delayed Shutdown Socket.
[    1.902182] systemd[1]: Starting /dev/initctl Compatibility Named Pipe.
[    1.902208] systemd[1]: Listening on /dev/initctl Compatibility Named Pipe.
[    1.902222] systemd[1]: Starting Encrypted Volumes.
[    1.902236] systemd[1]: Reached target Encrypted Volumes.
[    1.902251] systemd[1]: Starting Dispatch Password Requests to Console Directory Watch.
[    1.902289] systemd[1]: Started Dispatch Password Requests to Console Directory Watch.
[    1.902302] systemd[1]: Starting Paths.
[    1.902316] systemd[1]: Reached target Paths.
[    1.902331] systemd[1]: Starting Journal Socket.
[    1.902380] systemd[1]: Listening on Journal Socket.
[    1.902411] systemd[1]: Starting Nameserver information manager...
[    1.902785] systemd[1]: Starting Syslog.
[    1.902801] systemd[1]: Reached target Syslog.
[    1.902840] systemd[1]: Mounting Huge Pages File System...
[    1.905271] systemd[1]: Starting Load Kernel Modules...
[    1.908110] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[    1.908518] systemd[1]: Mounting Debug File System...
[    1.908820] systemd[1]: Starting Journal Service...
[    1.909308] systemd[1]: Started Journal Service.
[    1.913523] mkdir (1322) used greatest stack depth: 13056 bytes left
[    1.921482] usb 2-1.4: new high-speed USB device number 4 using ehci-pci
[    1.924303] random: nonblocking pool is initialized
[    1.942447] firewire_core 0000:0b:02.0: created device fw0: GUID 00224dffff7e5fd1, S400
[    1.979493] systemd-udevd[1361]: starting version 208
[    2.013397] usb 2-1.4: New USB device found, idVendor=05e3, idProduct=0610
[    2.013400] usb 2-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.013401] usb 2-1.4: Product: USB2.0 Hub 456
[    2.013403] usb 2-1.4: Manufacturer: GenesysLogic
[    2.014429] hub 2-1.4:1.0: USB hub found
[    2.015518] hub 2-1.4:1.0: 3 ports detected
[    2.039029] wmi: Mapper loaded
[    2.059162] ACPI Warning: SystemIO range 0x0000000000000428-0x000000000000042f conflicts with OpRegion 0x0000000000000400-0x000000000000047f (\PMIO) (20140627/utaddress-258)
[    2.059169] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    2.059172] ACPI Warning: SystemIO range 0x0000000000000540-0x000000000000054f conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20140627/utaddress-258)
[    2.059175] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    2.059176] ACPI Warning: SystemIO range 0x0000000000000530-0x000000000000053f conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20140627/utaddress-258)
[    2.059179] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    2.059180] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x0000000000000500-0x0000000000000563 (\GPIO) (20140627/utaddress-258)
[    2.059183] ACPI Warning: SystemIO range 0x0000000000000500-0x000000000000052f conflicts with OpRegion 0x000000000000050f-0x000000000000050f (\_SB_.PCI0.RLED.DBG0) (20140627/utaddress-258)
[    2.059186] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    2.059187] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    2.060126] nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x0e4030a2
[    2.060129] nouveau  [  DEVICE][0000:01:00.0] Chipset: GK104 (NVE4)
[    2.060131] nouveau  [  DEVICE][0000:01:00.0] Family : NVE0
[    2.060144] nouveau  [   VBIOS][0000:01:00.0] checking PRAMIN for image...
[    2.060152] nouveau  [   VBIOS][0000:01:00.0] ... signature not found
[    2.060153] nouveau  [   VBIOS][0000:01:00.0] checking PROM for image...
[    2.069569] EXT4-fs (sdb6): re-mounted. Opts: errors=remount-ro
[    2.080435] AVX version of gcm_enc/dec engaged.
[    2.080437] AES CTR mode by8 optimization enabled
[    2.103873] nouveau  [   VBIOS][0000:01:00.0] ... appears to be valid
[    2.103875] nouveau  [   VBIOS][0000:01:00.0] using image from PROM
[    2.103948] nouveau  [   VBIOS][0000:01:00.0] BIT signature found
[    2.103951] nouveau  [   VBIOS][0000:01:00.0] version 80.04.4b.00.27
[    2.104187] nouveau 0000:01:00.0: irq 39 for MSI/MSI-X
[    2.104194] nouveau  [     PMC][0000:01:00.0] MSI interrupts enabled
[    2.104270] nouveau  [     PFB][0000:01:00.0] RAM type: GDDR5
[    2.104272] nouveau  [     PFB][0000:01:00.0] RAM size: 2048 MiB
[    2.104273] nouveau  [     PFB][0000:01:00.0]    ZCOMP: 0 tags
[    2.105716] iTCO_vendor_support: vendor-support=0
[    2.105956] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    2.105974] iTCO_wdt: Found a Panther Point TCO device (Version=2, TCOBASE=0x0460)
[    2.106064] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    2.106348] nouveau  [    VOLT][0000:01:00.0] GPU voltage: 987500uv
[    2.135033] nouveau  [  PTHERM][0000:01:00.0] FAN control: PWM
[    2.135047] nouveau  [  PTHERM][0000:01:00.0] fan management: automatic
[    2.135081] nouveau  [  PTHERM][0000:01:00.0] internal sensor: yes
[    2.135112] nouveau  [     CLK][0000:01:00.0] 07: core 324 MHz memory 648 MHz 
[    2.135133] nouveau  [     CLK][0000:01:00.0] 0a: core 324-862 MHz memory 1620 MHz 
[    2.135187] nouveau  [     CLK][0000:01:00.0] 0d: core 540-1267 MHz memory 6008 MHz 
[    2.135260] nouveau  [     CLK][0000:01:00.0] 0f: core 540-1267 MHz memory 6008 MHz 
[    2.135350] nouveau  [     CLK][0000:01:00.0] --: core 324 MHz memory 648 MHz 
[    2.153900] Adding 1951740k swap on /dev/sdb5.  Priority:-1 extents:1 across:1951740k SS
[    2.155996] EXT4-fs (sdb4): mounted filesystem with ordered data mode. Opts: (null)
[    2.157130] [TTM] Zone  kernel: Available graphics memory: 8201542 kiB
[    2.157131] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    2.157132] [TTM] Initializing pool allocator
[    2.157134] [TTM] Initializing DMA pool allocator
[    2.157140] nouveau  [     DRM] VRAM: 2048 MiB
[    2.157140] nouveau  [     DRM] GART: 1048576 MiB
[    2.157143] nouveau  [     DRM] TMDS table version 2.0
[    2.157144] nouveau  [     DRM] DCB version 4.0
[    2.157145] nouveau  [     DRM] DCB outp 00: 01000f02 00020030
[    2.157146] nouveau  [     DRM] DCB outp 01: 02000f00 00000000
[    2.157147] nouveau  [     DRM] DCB outp 02: 08011f82 00020030
[    2.157148] nouveau  [     DRM] DCB outp 03: 02822f62 0f420010
[    2.157148] nouveau  [     DRM] DCB outp 05: 04833fb6 0f420010
[    2.157149] nouveau  [     DRM] DCB outp 06: 04033f72 00020010
[    2.157150] nouveau  [     DRM] DCB conn 00: 00001030
[    2.157152] nouveau  [     DRM] DCB conn 01: 00020131
[    2.157152] nouveau  [     DRM] DCB conn 02: 00002261
[    2.157153] nouveau  [     DRM] DCB conn 03: 00010346
[    2.157154] nouveau  [     DRM] DCB conn 04: 00000460
[    2.158069] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    2.158069] [drm] Driver supports precise vblank timestamp query.
[    2.162063] nouveau  [     DRM] MM: using COPY for buffer copies
[    2.170702] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    2.172988] systemd-journald[1327]: Received request to flush runtime journal from PID 1
[    2.252722] tun: Universal TUN/TAP device driver, 1.6
[    2.252725] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    2.268280] Switched to clocksource tsc
[    2.321898] nouveau  [     DRM] allocated 1920x1080 fb: 0x80000, bo ffff88040a573400
[    2.321937] fbcon: nouveaufb (fb0) is primary device
[    2.563662] Console: switching to colour frame buffer device 240x67
[    2.564539] nouveau 0000:01:00.0: fb0: nouveaufb frame buffer device
[    2.564539] nouveau 0000:01:00.0: registered panic notifier
[    2.566886] [drm] Initialized nouveau 1.1.1 20120801 for 0000:01:00.0 on minor 0
[    2.729006] e1000e 0000:00:19.0: irq 35 for MSI/MSI-X
[    2.829679] e1000e 0000:00:19.0: irq 35 for MSI/MSI-X
[    2.829761] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    2.905875] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[    3.086114] systemd-udevd (1422) used greatest stack depth: 12024 bytes left
[    4.369680] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: None
[    4.369687] e1000e 0000:00:19.0 eth0: 10/100 speed: disabling TSO
[    4.369723] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   14.839214] Total:2000, unnecessary:2000, case1:1741, case2:2000, case3:0
[  224.284633] Total:4000, unnecessary:4000, case1:3652, case2:4000, case3:0
[  244.159021] Total:6000, unnecessary:6000, case1:5539, case2:6000, case3:0
[  260.522175] Total:8000, unnecessary:8000, case1:7447, case2:8000, case3:0
[  268.293058] Total:10000, unnecessary:10000, case1:9317, case2:10000, case3:0
[  275.962033] Total:12000, unnecessary:12000, case1:11159, case2:12000, case3:0
[  287.411032] Total:14000, unnecessary:14000, case1:13008, case2:14000, case3:0
[  304.868334] Total:16000, unnecessary:16000, case1:14885, case2:16000, case3:0
[  318.090930] Total:18000, unnecessary:18000, case1:16747, case2:18000, case3:0
[  333.423876] Total:20000, unnecessary:20000, case1:18631, case2:20000, case3:0
[  346.775399] Total:22000, unnecessary:22000, case1:20502, case2:22000, case3:0
[  362.867751] Total:24000, unnecessary:24000, case1:22386, case2:24000, case3:0
[  376.777817] Total:26000, unnecessary:26000, case1:24251, case2:26000, case3:0
[  391.839994] Total:28000, unnecessary:28000, case1:26118, case2:28000, case3:0
[  406.559406] Total:30000, unnecessary:30000, case1:27983, case2:30000, case3:0
[  419.973867] Total:32000, unnecessary:32000, case1:29855, case2:32000, case3:0
[  435.080002] Total:34000, unnecessary:34000, case1:31740, case2:34000, case3:0
[  449.077018] Total:36000, unnecessary:36000, case1:33588, case2:36000, case3:0
[  464.418942] Total:38000, unnecessary:38000, case1:35460, case2:38000, case3:0
[  478.654755] Total:40000, unnecessary:40000, case1:37326, case2:40000, case3:0
[  494.650198] Total:42000, unnecessary:42000, case1:39232, case2:42000, case3:0
[  508.594240] Total:44000, unnecessary:44000, case1:41134, case2:44000, case3:0
[  524.273907] Total:46000, unnecessary:46000, case1:43039, case2:46000, case3:0
[  537.227731] Total:48000, unnecessary:48000, case1:44916, case2:48000, case3:0
[  552.963362] Total:50000, unnecessary:50000, case1:46805, case2:50000, case3:0
[  567.333075] Total:52000, unnecessary:52000, case1:48662, case2:52000, case3:0
[  581.811693] Total:54000, unnecessary:54000, case1:50550, case2:54000, case3:0
[  596.404233] Total:56000, unnecessary:56000, case1:52417, case2:56000, case3:0
[  610.249344] Total:58000, unnecessary:58000, case1:54309, case2:58000, case3:0
[  625.682220] Total:60000, unnecessary:60000, case1:56190, case2:60000, case3:0
[  640.784361] Total:62000, unnecessary:62000, case1:58069, case2:62000, case3:0
[  656.142299] Total:64000, unnecessary:64000, case1:59953, case2:64000, case3:0
[  670.026376] Total:66000, unnecessary:66000, case1:61827, case2:66000, case3:0
[  685.972862] Total:68000, unnecessary:68000, case1:63696, case2:68000, case3:0
[  700.196668] Total:70000, unnecessary:70000, case1:65566, case2:70000, case3:0
[  715.817391] Total:72000, unnecessary:72000, case1:67479, case2:72000, case3:0
[  729.864351] Total:74000, unnecessary:74000, case1:69361, case2:74000, case3:0
[  745.938723] Total:76000, unnecessary:76000, case1:71235, case2:76000, case3:0
[  759.345184] Total:78000, unnecessary:78000, case1:73110, case2:78000, case3:0
[  774.623193] Total:80000, unnecessary:80000, case1:74977, case2:80000, case3:0
[  789.257682] Total:82000, unnecessary:82000, case1:76871, case2:82000, case3:0
[  806.942791] Total:84000, unnecessary:84000, case1:78771, case2:84000, case3:0
[  826.439457] Total:86000, unnecessary:86000, case1:80623, case2:86000, case3:0
[  841.527610] Total:88000, unnecessary:88000, case1:82497, case2:88000, case3:0
[  856.595773] Total:90000, unnecessary:90000, case1:84358, case2:90000, case3:0
[  869.957271] Total:92000, unnecessary:92000, case1:86214, case2:92000, case3:0
[  884.523830] Total:94000, unnecessary:94000, case1:88106, case2:94000, case3:0
[  899.798824] Total:96000, unnecessary:96000, case1:89991, case2:96000, case3:0
[  913.874762] Total:98000, unnecessary:98000, case1:91854, case2:98000, case3:0
[  929.905214] Total:100000, unnecessary:100000, case1:93749, case2:100000, case3:0
[  943.377731] Total:102000, unnecessary:102000, case1:95630, case2:102000, case3:0
[  958.239180] Total:104000, unnecessary:104000, case1:97508, case2:104000, case3:0
[  971.876567] Total:106000, unnecessary:106000, case1:99374, case2:106000, case3:0
[  986.619096] Total:108000, unnecessary:108000, case1:101260, case2:108000, case3:0
[ 1001.759322] Total:110000, unnecessary:110000, case1:103145, case2:110000, case3:0
[ 1015.213868] Total:112000, unnecessary:112000, case1:105014, case2:112000, case3:0
[ 1030.117263] Total:114000, unnecessary:114000, case1:106890, case2:114000, case3:0
[ 1045.126585] Total:116000, unnecessary:116000, case1:108769, case2:116000, case3:0
[ 1060.500669] Total:118000, unnecessary:118000, case1:110617, case2:118000, case3:0
[ 1075.672116] Total:120000, unnecessary:120000, case1:112520, case2:120000, case3:0
[ 1091.335187] Total:122000, unnecessary:122000, case1:114442, case2:122000, case3:0
[ 1109.634209] Total:124000, unnecessary:124000, case1:116370, case2:124000, case3:0
[ 1126.381405] Total:126000, unnecessary:126000, case1:118296, case2:126000, case3:0
[ 1143.507306] Total:128000, unnecessary:128000, case1:120232, case2:128000, case3:0
[ 1160.711134] Total:130000, unnecessary:130000, case1:122148, case2:130000, case3:0
[ 1176.688871] Total:132000, unnecessary:132000, case1:124067, case2:132000, case3:0
[ 1193.612919] Total:134000, unnecessary:134000, case1:125996, case2:134000, case3:0
[ 1211.111445] Total:136000, unnecessary:136000, case1:127925, case2:136000, case3:0
[ 1240.889578] Total:138000, unnecessary:138000, case1:129886, case2:138000, case3:0
[ 1261.389791] Total:140000, unnecessary:140000, case1:131815, case2:140000, case3:0
[ 1274.340752] Total:142000, unnecessary:142000, case1:133713, case2:142000, case3:0
[ 1281.765016] Total:144000, unnecessary:144000, case1:135559, case2:144000, case3:0
[ 1290.577197] Total:146000, unnecessary:146000, case1:137416, case2:146000, case3:0
[ 1303.099524] Total:148000, unnecessary:148000, case1:139290, case2:148000, case3:0
[ 1315.506903] Total:150000, unnecessary:150000, case1:141159, case2:150000, case3:0
[ 1331.213741] Total:152000, unnecessary:152000, case1:143023, case2:152000, case3:0
[ 1348.411423] Total:154000, unnecessary:154000, case1:144874, case2:154000, case3:0
[ 1367.914316] Total:156000, unnecessary:156000, case1:146740, case2:156000, case3:0
[ 1386.898606] Total:158000, unnecessary:158000, case1:148602, case2:158000, case3:0
[ 1403.531718] Total:160000, unnecessary:160000, case1:150473, case2:160000, case3:0
[ 1422.532990] Total:162000, unnecessary:162000, case1:152353, case2:162000, case3:0
[ 1439.014211] Total:164000, unnecessary:164000, case1:154237, case2:164000, case3:0
[ 1464.862179] Total:166000, unnecessary:166000, case1:156194, case2:166000, case3:0
[ 1488.251031] Total:168000, unnecessary:168000, case1:158144, case2:168000, case3:0
[ 1509.017936] Total:170000, unnecessary:170000, case1:160066, case2:170000, case3:0
[ 1528.915502] Total:172000, unnecessary:172000, case1:161929, case2:172000, case3:0
[ 1548.582235] Total:174000, unnecessary:174000, case1:163788, case2:174000, case3:0
[ 1564.248072] Total:176000, unnecessary:176000, case1:165659, case2:176000, case3:0
[ 1580.387542] Total:178000, unnecessary:178000, case1:167513, case2:178000, case3:0
[ 1596.091362] Total:180000, unnecessary:180000, case1:169370, case2:180000, case3:0
[ 1612.082955] Total:182000, unnecessary:182000, case1:171241, case2:182000, case3:0
[ 1628.515189] Total:184000, unnecessary:184000, case1:173127, case2:184000, case3:0
[ 1644.023155] Total:186000, unnecessary:186000, case1:174992, case2:186000, case3:0
[ 1659.668006] Total:188000, unnecessary:188000, case1:176870, case2:188000, case3:0
[ 1676.205994] Total:190000, unnecessary:190000, case1:178721, case2:190000, case3:0
[ 1693.268531] Total:192000, unnecessary:192000, case1:180606, case2:192000, case3:0
[ 1709.880451] Total:194000, unnecessary:194000, case1:182466, case2:194000, case3:0
[ 1725.783933] Total:196000, unnecessary:196000, case1:184330, case2:196000, case3:0
[ 1741.542539] Total:198000, unnecessary:198000, case1:186195, case2:198000, case3:0
[ 1759.013808] Total:200000, unnecessary:200000, case1:188056, case2:200000, case3:0
[ 1779.917408] Total:202000, unnecessary:202000, case1:189938, case2:202000, case3:0
[ 1788.786726] rcu-torture:--- Start of test: nreaders=7 nfakewriters=4 stat_interval=60 verbose=1 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 stall_cpu=0 stall_cpu_holdoff=10 n_barrier_cbs=0 onoff_interval=0 onoff_holdoff=0
[ 1788.786734] rcu-torture: Creating rcu_torture_writer task
[ 1788.786767] rcu-torture: Creating rcu_torture_fakewriter task
[ 1788.786770] rcu-torture: rcu_torture_writer task started
[ 1788.786789] rcu-torture: Creating rcu_torture_fakewriter task
[ 1788.786791] rcu-torture: rcu_torture_fakewriter task started
[ 1788.786809] rcu-torture: Creating rcu_torture_fakewriter task
[ 1788.786811] rcu-torture: rcu_torture_fakewriter task started
[ 1788.786829] rcu-torture: Creating rcu_torture_fakewriter task
[ 1788.786831] rcu-torture: rcu_torture_fakewriter task started
[ 1788.786849] rcu-torture: Creating rcu_torture_reader task
[ 1788.786851] rcu-torture: rcu_torture_fakewriter task started
[ 1788.786869] rcu-torture: Creating rcu_torture_reader task
[ 1788.786871] rcu-torture: rcu_torture_reader task started
[ 1788.786888] rcu-torture: Creating rcu_torture_reader task
[ 1788.786890] rcu-torture: rcu_torture_reader task started
[ 1788.786907] rcu-torture: Creating rcu_torture_reader task
[ 1788.786909] rcu-torture: rcu_torture_reader task started
[ 1788.786926] rcu-torture: Creating rcu_torture_reader task
[ 1788.786928] rcu-torture: rcu_torture_reader task started
[ 1788.786945] rcu-torture: Creating rcu_torture_reader task
[ 1788.786947] rcu-torture: rcu_torture_reader task started
[ 1788.786965] rcu-torture: Creating rcu_torture_reader task
[ 1788.786967] rcu-torture: rcu_torture_reader task started
[ 1788.786985] rcu-torture: Creating rcu_torture_stats task
[ 1788.786987] rcu-torture: rcu_torture_reader task started
[ 1788.787004] rcu-torture: Creating torture_shuffle task
[ 1788.787006] rcu-torture: rcu_torture_stats task started
[ 1788.787023] rcu-torture: Creating torture_stutter task
[ 1788.787025] rcu-torture: torture_shuffle task started
[ 1788.787043] rcu-torture: torture_stutter task started
[ 1848.739418] rcu-torture: rtc: ffffffffa09f36b0 ver: 426 tfle: 0 rta: 426 rtaf: 0 rtf: 417 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 129060 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 1848.739418] rcu-torture: Reader Pipe:  1061847232 1030 0 0 0 0 0 0 0 0 0
[ 1848.739418] rcu-torture: Reader Batch:  1061845199 3063 0 0 0 0 0 0 0 0 0
[ 1848.739418] rcu-torture: Free-Block Circulation:  425 425 424 423 422 421 420 419 418 417 0
[ 1852.911133] Total:204000, unnecessary:204000, case1:190740, case2:204000, case3:0
[ 1908.692469] rcu-torture: rtc: ffffffffa09f4310 ver: 689 tfle: 0 rta: 689 rtaf: 0 rtf: 680 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 261620 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 1908.692469] rcu-torture: Reader Pipe:  2149758408 2025 0 0 0 0 0 0 0 0 0
[ 1908.692469] rcu-torture: Reader Batch:  2149754206 6227 0 0 0 0 0 0 0 0 0
[ 1908.692469] rcu-torture: Free-Block Circulation:  688 688 687 686 685 684 683 682 681 680 0
[ 1961.719997] Total:206000, unnecessary:206000, case1:190755, case2:206000, case3:0
[ 1968.645598] rcu-torture: rtc: ffffffffa09f3c80 ver: 958 tfle: 0 rta: 958 rtaf: 0 rtf: 949 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 394174 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 1968.645598] rcu-torture: Reader Pipe:  3235617850 3112 0 0 0 0 0 0 0 0 0
[ 1968.645598] rcu-torture: Reader Batch:  3235611488 9474 0 0 0 0 0 0 0 0 0
[ 1968.645598] rcu-torture: Free-Block Circulation:  957 957 956 955 954 953 952 951 950 949 0
[ 2028.598762] rcu-torture: rtc: ffffffffa09f3a10 ver: 1229 tfle: 0 rta: 1229 rtaf: 0 rtf: 1220 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 524280 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2028.598762] rcu-torture: Reader Pipe:  4301320654 4180 0 0 0 0 0 0 0 0 0
[ 2028.598762] rcu-torture: Reader Batch:  4301312150 12684 0 0 0 0 0 0 0 0 0
[ 2028.598762] rcu-torture: Free-Block Circulation:  1228 1228 1227 1226 1225 1224 1223 1222 1221 1220 0
[ 2068.887298] Total:208000, unnecessary:208000, case1:190768, case2:208000, case3:0
[ 2088.551963] rcu-torture: rtc: ffffffffa09f3320 ver: 1517 tfle: 0 rta: 1517 rtaf: 0 rtf: 1508 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 654850 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2088.551963] rcu-torture: Reader Pipe:  5377407467 5310 0 0 0 0 0 0 0 0 0
[ 2088.551963] rcu-torture: Reader Batch:  5377396833 15944 0 0 0 0 0 0 0 0 0
[ 2088.551963] rcu-torture: Free-Block Circulation:  1516 1516 1515 1514 1513 1512 1511 1510 1509 1508 0
[ 2148.505199] rcu-torture: rtc: ffffffffa09f4250 ver: 1782 tfle: 0 rta: 1782 rtaf: 0 rtf: 1773 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 786847 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2148.505199] rcu-torture: Reader Pipe:  6455972019 6310 0 0 0 0 0 0 0 0 0
[ 2148.505199] rcu-torture: Reader Batch:  6455959206 19123 0 0 0 0 0 0 0 0 0
[ 2148.505199] rcu-torture: Free-Block Circulation:  1781 1781 1780 1779 1778 1777 1776 1775 1774 1773 0
[ 2178.757597] Total:210000, unnecessary:210000, case1:190782, case2:210000, case3:0
[ 2208.458315] rcu-torture: rtc: ffffffffa09f3c20 ver: 2060 tfle: 0 rta: 2060 rtaf: 0 rtf: 2051 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 916948 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2208.458315] rcu-torture: Reader Pipe:  7521403737 7409 0 0 0 0 0 0 0 0 0
[ 2208.458315] rcu-torture: Reader Batch:  7521388834 22312 0 0 0 0 0 0 0 0 0
[ 2208.458315] rcu-torture: Free-Block Circulation:  2059 2059 2058 2057 2056 2055 2054 2053 2052 2051 0
[ 2268.410257] rcu-torture: rtc: ffffffffa09f39e0 ver: 2331 tfle: 0 rta: 2331 rtaf: 0 rtf: 2322 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1048796 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2268.410257] rcu-torture: Reader Pipe:  8607753540 8472 0 0 0 0 0 0 0 0 0
[ 2268.410257] rcu-torture: Reader Batch:  8607736628 25384 0 0 0 0 0 0 0 0 0
[ 2268.410257] rcu-torture: Free-Block Circulation:  2330 2330 2329 2328 2327 2326 2325 2324 2323 2322 0
[ 2288.313349] Total:212000, unnecessary:212000, case1:190796, case2:212000, case3:0
[ 2328.362455] rcu-torture: rtc: ffffffffa09f36b0 ver: 2613 tfle: 0 rta: 2613 rtaf: 0 rtf: 2604 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1181873 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2328.362455] rcu-torture: Reader Pipe:  9702779728 9545 0 0 0 0 0 0 0 0 0
[ 2328.362455] rcu-torture: Reader Batch:  9702760733 28540 0 0 0 0 0 0 0 0 0
[ 2328.362455] rcu-torture: Free-Block Circulation:  2612 2612 2611 2610 2609 2608 2607 2606 2605 2604 0
[ 2388.314486] rcu-torture: rtc: ffffffffa09f4010 ver: 2891 tfle: 0 rta: 2891 rtaf: 0 rtf: 2882 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1313231 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2388.314486] rcu-torture: Reader Pipe:  10788919028 10649 0 0 0 0 0 0 0 0 0
[ 2388.314486] rcu-torture: Reader Batch:  10788897998 31679 0 0 0 0 0 0 0 0 0
[ 2388.314486] rcu-torture: Free-Block Circulation:  2890 2890 2889 2888 2887 2886 2885 2884 2883 2882 0
[ 2399.085876] Total:214000, unnecessary:214000, case1:190812, case2:214000, case3:0
[ 2448.266711] rcu-torture: rtc: ffffffffa09f3cb0 ver: 3156 tfle: 0 rta: 3156 rtaf: 0 rtf: 3147 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1445513 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2448.266711] rcu-torture: Reader Pipe:  11880904194 11686 0 0 0 0 0 0 0 0 0
[ 2448.266711] rcu-torture: Reader Batch:  11880881078 34802 0 0 0 0 0 0 0 0 0
[ 2448.266711] rcu-torture: Free-Block Circulation:  3155 3155 3154 3153 3152 3151 3150 3149 3148 3147 0
[ 2508.219123] rcu-torture: rtc: ffffffffa09f34d0 ver: 3406 tfle: 0 rta: 3406 rtaf: 0 rtf: 3397 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1577895 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2508.219123] rcu-torture: Reader Pipe:  12974146558 12625 0 0 0 0 0 0 0 0 0
[ 2508.219123] rcu-torture: Reader Batch:  12974121236 37947 0 0 0 0 0 0 0 0 0
[ 2508.219123] rcu-torture: Free-Block Circulation:  3405 3405 3404 3403 3402 3401 3400 3399 3398 3397 0
[ 2508.962521] Total:216000, unnecessary:216000, case1:190827, case2:216000, case3:0
[ 2568.171683] rcu-torture: rtc: ffffffffa09f4070 ver: 3669 tfle: 0 rta: 3669 rtaf: 0 rtf: 3660 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1710771 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2568.171683] rcu-torture: Reader Pipe:  14073632251 13687 0 0 0 0 0 0 0 0 0
[ 2568.171683] rcu-torture: Reader Batch:  14073604855 41083 0 0 0 0 0 0 0 0 0
[ 2568.171683] rcu-torture: Free-Block Circulation:  3668 3668 3667 3666 3665 3664 3663 3662 3661 3660 0
[ 2619.643041] Total:218000, unnecessary:218000, case1:190850, case2:218000, case3:0
[ 2628.124365] rcu-torture: rtc: ffffffffa09f3e60 ver: 3973 tfle: 0 rta: 3973 rtaf: 0 rtf: 3964 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1843554 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2628.124365] rcu-torture: Reader Pipe:  15169801907 14871 0 0 0 0 0 0 0 0 0
[ 2628.124365] rcu-torture: Reader Batch:  15169772341 44437 0 0 0 0 0 0 0 0 0
[ 2628.124365] rcu-torture: Free-Block Circulation:  3972 3972 3971 3970 3969 3968 3967 3966 3965 3964 0
[ 2688.077137] rcu-torture: rtc: ffffffffa09f3cb0 ver: 4259 tfle: 0 rta: 4259 rtaf: 0 rtf: 4250 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 1973823 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2688.077137] rcu-torture: Reader Pipe:  16251905189 16009 0 0 0 0 0 0 0 0 0
[ 2688.077137] rcu-torture: Reader Batch:  16251873693 47505 0 0 0 0 0 0 0 0 0
[ 2688.077137] rcu-torture: Free-Block Circulation:  4258 4258 4257 4256 4255 4254 4253 4252 4251 4250 0
[ 2729.868252] Total:220000, unnecessary:220000, case1:190862, case2:220000, case3:0
[ 2748.029987] rcu-torture: rtc: ffffffffa09f3500 ver: 4524 tfle: 0 rta: 4524 rtaf: 0 rtf: 4515 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2107457 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2748.029987] rcu-torture: Reader Pipe:  17357138329 17026 0 0 0 0 0 0 0 0 0
[ 2748.029987] rcu-torture: Reader Batch:  17357104621 50734 0 0 0 0 0 0 0 0 0
[ 2748.029987] rcu-torture: Free-Block Circulation:  4523 4523 4522 4521 4520 4519 4518 4517 4516 4515 0
[ 2807.982896] rcu-torture: rtc: ffffffffa09f3a40 ver: 4828 tfle: 0 rta: 4828 rtaf: 0 rtf: 4819 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2242036 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2807.982896] rcu-torture: Reader Pipe:  18468484803 18234 0 0 0 0 0 0 0 0 0
[ 2807.982896] rcu-torture: Reader Batch:  18468449167 53870 0 0 0 0 0 0 0 0 0
[ 2807.982896] rcu-torture: Free-Block Circulation:  4827 4827 4826 4825 4824 4823 4822 4821 4820 4819 0
[ 2836.158767] Total:222000, unnecessary:222000, case1:190878, case2:222000, case3:0
[ 2867.935847] rcu-torture: rtc: ffffffffa09f33e0 ver: 5120 tfle: 0 rta: 5120 rtaf: 0 rtf: 5111 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2375170 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2867.935847] rcu-torture: Reader Pipe:  19566763383 19344 0 0 0 0 0 0 0 0 0
[ 2867.935847] rcu-torture: Reader Batch:  19566725559 57168 0 0 0 0 0 0 0 0 0
[ 2867.935847] rcu-torture: Free-Block Circulation:  5119 5119 5118 5117 5116 5115 5114 5113 5112 5111 0
[ 2927.888838] rcu-torture: rtc: ffffffffa09f3200 ver: 5384 tfle: 0 rta: 5384 rtaf: 0 rtf: 5375 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2506239 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2927.888838] rcu-torture: Reader Pipe:  20646062765 20366 0 0 0 0 0 0 0 0 0
[ 2927.888838] rcu-torture: Reader Batch:  20646022772 60359 0 0 0 0 0 0 0 0 0
[ 2927.888838] rcu-torture: Free-Block Circulation:  5383 5383 5382 5381 5380 5379 5378 5377 5376 5375 0
[ 2943.199824] Total:224000, unnecessary:224000, case1:190893, case2:224000, case3:0
[ 2987.841855] rcu-torture: rtc: ffffffffa09f3bf0 ver: 5663 tfle: 0 rta: 5663 rtaf: 0 rtf: 5654 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2639256 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 2987.841855] rcu-torture: Reader Pipe:  21738501909 21421 0 0 0 0 0 0 0 0 0
[ 2987.841855] rcu-torture: Reader Batch:  21738459641 63689 0 0 0 0 0 0 0 0 0
[ 2987.841855] rcu-torture: Free-Block Circulation:  5662 5662 5661 5660 5659 5658 5657 5656 5655 5654 0
[ 3047.794893] rcu-torture: rtc: ffffffffa09f3980 ver: 5921 tfle: 0 rta: 5921 rtaf: 0 rtf: 5912 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2771785 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3047.794893] rcu-torture: Reader Pipe:  22830816867 22391 0 0 0 0 0 0 0 0 0
[ 3047.794893] rcu-torture: Reader Batch:  22830772304 66954 0 0 0 0 0 0 0 0 0
[ 3047.794893] rcu-torture: Free-Block Circulation:  5920 5920 5919 5918 5917 5916 5915 5914 5913 5912 0
[ 3049.642438] Total:226000, unnecessary:226000, case1:190906, case2:226000, case3:0
[ 3107.747958] rcu-torture: rtc: ffffffffa09f35c0 ver: 6225 tfle: 0 rta: 6225 rtaf: 0 rtf: 6216 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 2904470 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3107.747958] rcu-torture: Reader Pipe:  23924796577 23571 0 0 0 0 0 0 0 0 0
[ 3107.747958] rcu-torture: Reader Batch:  23924750021 70127 0 0 0 0 0 0 0 0 0
[ 3107.747958] rcu-torture: Free-Block Circulation:  6224 6224 6223 6222 6221 6220 6219 6218 6217 6216 0
[ 3158.407291] Total:228000, unnecessary:228000, case1:190918, case2:228000, case3:0
[ 3167.701031] rcu-torture: rtc: ffffffffa09f3230 ver: 6505 tfle: 0 rta: 6505 rtaf: 0 rtf: 6496 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 3034002 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3167.701031] rcu-torture: Reader Pipe:  24987867668 24634 0 0 0 0 0 0 0 0 0
[ 3167.701031] rcu-torture: Reader Batch:  24987818969 73333 0 0 0 0 0 0 0 0 0
[ 3167.701031] rcu-torture: Free-Block Circulation:  6504 6504 6503 6502 6501 6500 6499 6498 6497 6496 0
[ 3227.654113] rcu-torture: rtc: ffffffffa09f3e90 ver: 6775 tfle: 0 rta: 6775 rtaf: 0 rtf: 6766 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 3164762 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3227.654113] rcu-torture: Reader Pipe:  26060705392 25672 0 0 0 0 0 0 0 0 0
[ 3227.654113] rcu-torture: Reader Batch:  26060654570 76494 0 0 0 0 0 0 0 0 0
[ 3227.654113] rcu-torture: Free-Block Circulation:  6774 6774 6773 6772 6771 6770 6769 6768 6767 6766 0
[ 3268.848871] Total:230000, unnecessary:230000, case1:190930, case2:230000, case3:0
[ 3287.607209] rcu-torture: rtc: ffffffffa09f3920 ver: 7029 tfle: 0 rta: 7029 rtaf: 0 rtf: 7020 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 3297777 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3287.607209] rcu-torture: Reader Pipe:  27151897250 26641 0 0 0 0 0 0 0 0 0
[ 3287.607209] rcu-torture: Reader Batch:  27151844177 79714 0 0 0 0 0 0 0 0 0
[ 3287.607209] rcu-torture: Free-Block Circulation:  7028 7028 7027 7026 7025 7024 7023 7022 7021 7020 0
[ 3347.560153] rcu-torture: rtc: ffffffffa09f43d0 ver: 7294 tfle: 0 rta: 7294 rtaf: 0 rtf: 7285 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 3431278 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3347.560153] rcu-torture: Reader Pipe:  28248934483 27649 0 0 0 0 0 0 0 0 0
[ 3347.560153] rcu-torture: Reader Batch:  28248879208 82924 0 0 0 0 0 0 0 0 0
[ 3347.560153] rcu-torture: Free-Block Circulation:  7293 7293 7292 7291 7290 7289 7288 7287 7286 7285 0
[ 3377.019911] Total:232000, unnecessary:232000, case1:190940, case2:232000, case3:0
[ 3407.512889] rcu-torture: rtc: ffffffffa09f40a0 ver: 7577 tfle: 0 rta: 7577 rtaf: 0 rtf: 7568 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 3563922 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3407.512889] rcu-torture: Reader Pipe:  29338087356 28742 0 0 0 0 0 0 0 0 0
[ 3407.512889] rcu-torture: Reader Batch:  29338030006 86092 0 0 0 0 0 0 0 0 0
[ 3407.512889] rcu-torture: Free-Block Circulation:  7576 7576 7575 7574 7573 7572 7571 7570 7569 7568 0
[ 3467.465662] rcu-torture: rtc: ffffffffa09f3dd0 ver: 7851 tfle: 0 rta: 7851 rtaf: 0 rtf: 7842 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 3695609 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3467.465662] rcu-torture: Reader Pipe:  30420556434 29884 0 0 0 0 0 0 0 0 0
[ 3467.465662] rcu-torture: Reader Batch:  30420497037 89281 0 0 0 0 0 0 0 0 0
[ 3467.465662] rcu-torture: Free-Block Circulation:  7850 7850 7849 7848 7847 7846 7845 7844 7843 7842 0
[ 3486.013047] Total:234000, unnecessary:234000, case1:190953, case2:234000, case3:0
[ 3527.418473] rcu-torture: rtc: ffffffffa09f3b00 ver: 8148 tfle: 0 rta: 8148 rtaf: 0 rtf: 8139 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 3828257 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3527.418473] rcu-torture: Reader Pipe:  31511115226 30989 0 0 0 0 0 0 0 0 0
[ 3527.418473] rcu-torture: Reader Batch:  31511053838 92377 0 0 0 0 0 0 0 0 0
[ 3527.418473] rcu-torture: Free-Block Circulation:  8147 8147 8146 8145 8144 8143 8142 8141 8140 8139 0
[ 3587.371310] rcu-torture: rtc: ffffffffa09f35f0 ver: 8445 tfle: 0 rta: 8445 rtaf: 0 rtf: 8436 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 3961411 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3587.371310] rcu-torture: Reader Pipe:  32603962971 32113 0 0 0 0 0 0 0 0 0
[ 3587.371310] rcu-torture: Reader Batch:  32603899498 95586 0 0 0 0 0 0 0 0 0
[ 3587.371310] rcu-torture: Free-Block Circulation:  8444 8444 8443 8442 8441 8440 8439 8438 8437 8436 0
[ 3595.040267] Total:236000, unnecessary:236000, case1:190965, case2:236000, case3:0
[ 3647.324176] rcu-torture: rtc: ffffffffa09f3bc0 ver: 8750 tfle: 0 rta: 8750 rtaf: 0 rtf: 8741 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4092199 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3647.324176] rcu-torture: Reader Pipe:  33679583186 33271 0 0 0 0 0 0 0 0 0
[ 3647.324176] rcu-torture: Reader Batch:  33679517766 98691 0 0 0 0 0 0 0 0 0
[ 3647.324176] rcu-torture: Free-Block Circulation:  8749 8749 8748 8747 8746 8745 8744 8743 8742 8741 0
[ 3705.480463] Total:238000, unnecessary:238000, case1:190975, case2:238000, case3:0
[ 3707.277068] rcu-torture: rtc: ffffffffa09f3650 ver: 9048 tfle: 0 rta: 9048 rtaf: 0 rtf: 9039 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4224514 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3707.277068] rcu-torture: Reader Pipe:  34766249799 34431 0 0 0 0 0 0 0 0 0
[ 3707.277068] rcu-torture: Reader Batch:  34766182447 101783 0 0 0 0 0 0 0 0 0
[ 3707.277068] rcu-torture: Free-Block Circulation:  9047 9047 9046 9045 9044 9043 9042 9041 9040 9039 0
[ 3767.229900] rcu-torture: rtc: ffffffffa09f43a0 ver: 9323 tfle: 0 rta: 9323 rtaf: 0 rtf: 9314 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4357326 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3767.229900] rcu-torture: Reader Pipe:  35856908659 35512 0 0 0 0 0 0 0 0 0
[ 3767.229900] rcu-torture: Reader Batch:  35856839237 104934 0 0 0 0 0 0 0 0 0
[ 3767.229900] rcu-torture: Free-Block Circulation:  9322 9322 9321 9320 9319 9318 9317 9316 9315 9314 0
[ 3815.442947] Total:240000, unnecessary:240000, case1:190989, case2:240000, case3:0
[ 3827.182722] rcu-torture: rtc: ffffffffa09f3470 ver: 9609 tfle: 0 rta: 9609 rtaf: 0 rtf: 9600 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4489850 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3827.182722] rcu-torture: Reader Pipe:  36946268025 36641 0 0 0 0 0 0 0 0 0
[ 3827.182722] rcu-torture: Reader Batch:  36946196582 108084 0 0 0 0 0 0 0 0 0
[ 3827.182722] rcu-torture: Free-Block Circulation:  9608 9608 9607 9606 9605 9604 9603 9602 9601 9600 0
[ 3887.135578] rcu-torture: rtc: ffffffffa09f3d40 ver: 9872 tfle: 0 rta: 9872 rtaf: 0 rtf: 9863 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4622265 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3887.135578] rcu-torture: Reader Pipe:  38033675969 37640 0 0 0 0 0 0 0 0 0
[ 3887.135578] rcu-torture: Reader Batch:  38033602510 111099 0 0 0 0 0 0 0 0 0
[ 3887.135578] rcu-torture: Free-Block Circulation:  9871 9871 9870 9869 9868 9867 9866 9865 9864 9863 0
[ 3926.016003] Total:242000, unnecessary:242000, case1:191008, case2:242000, case3:0
[ 3947.088459] rcu-torture: rtc: ffffffffa09f3890 ver: 10146 tfle: 0 rta: 10146 rtaf: 0 rtf: 10137 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4754806 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 3947.088459] rcu-torture: Reader Pipe:  39122642338 38680 0 0 0 0 0 0 0 0 0
[ 3947.088459] rcu-torture: Reader Batch:  39122566865 114153 0 0 0 0 0 0 0 0 0
[ 3947.088459] rcu-torture: Free-Block Circulation:  10145 10145 10144 10143 10142 10141 10140 10139 10138 10137 0
[ 4007.041358] rcu-torture: rtc: ffffffffa09f33e0 ver: 10416 tfle: 0 rta: 10416 rtaf: 0 rtf: 10407 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 4887391 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 4007.041358] rcu-torture: Reader Pipe:  40210839790 39732 0 0 0 0 0 0 0 0 0
[ 4007.041358] rcu-torture: Reader Batch:  40210762185 117337 0 0 0 0 0 0 0 0 0
[ 4007.041358] rcu-torture: Free-Block Circulation:  10415 10415 10414 10413 10412 10411 10410 10409 10408 10407 0
[ 4043.734519] Total:244000, unnecessary:244000, case1:191019, case2:244000, case3:0
[ 4066.994280] rcu-torture: rtc: ffffffffa09f3fe0 ver: 10700 tfle: 0 rta: 10700 rtaf: 0 rtf: 10691 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 5018349 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 4066.994280] rcu-torture: Reader Pipe:  41294800563 40871 0 0 0 0 0 0 0 0 0
[ 4066.994280] rcu-torture: Reader Batch:  41294720952 120482 0 0 0 0 0 0 0 0 0
[ 4066.994280] rcu-torture: Free-Block Circulation:  10699 10699 10698 10697 10696 10695 10694 10693 10692 10691 0
[ 4090.921238] rcu-torture: Stopping rcu_torture_reader
[ 4090.921238] rcu-torture: Stopping rcu_torture_reader
[ 4090.921239] rcu-torture: Stopping rcu_torture_reader
[ 4090.921239] rcu-torture: Stopping rcu_torture_reader
[ 4090.921240] rcu-torture: Stopping rcu_torture_reader
[ 4090.921240] rcu-torture: Stopping rcu_torture_reader
[ 4090.921241] rcu-torture: Stopping rcu_torture_reader
[ 4090.921241] rcu-torture: Stopping torture_shuffle task
[ 4090.921244] rcu-torture: Stopping torture_shuffle
[ 4090.921248] rcu-torture: Stopping torture_stutter task
[ 4090.921493] rcu-torture: Stopping torture_stutter
[ 4090.921513] rcu-torture: Stopping rcu_torture_fakewriter
[ 4090.921516] (null)-torture: Stopping rcu_torture_writer task
[ 4090.921529] (null)-torture: Stopping rcu_torture_fakewriter
[ 4090.921596] (null)-torture: Stopping rcu_torture_fakewriter
[ 4090.924516] (null)-torture: Stopping rcu_torture_fakewriter
[ 4090.932494] (null)-torture: Stopping rcu_torture_writer
[ 4090.932509] (null)-torture: Stopping rcu_torture_reader task
[ 4090.932581] (null)-torture: Stopping rcu_torture_reader task
[ 4090.932605] (null)-torture: Stopping rcu_torture_reader task
[ 4090.932667] (null)-torture: Stopping rcu_torture_reader task
[ 4090.932682] (null)-torture: Stopping rcu_torture_reader task
[ 4090.932780] (null)-torture: Stopping rcu_torture_reader task
[ 4090.932785] (null)-torture: Stopping rcu_torture_reader task
[ 4090.932789] (null)-torture: Stopping rcu_torture_fakewriter task
[ 4090.932794] (null)-torture: Stopping rcu_torture_fakewriter task
[ 4090.932814] (null)-torture: Stopping rcu_torture_fakewriter task
[ 4090.932835] (null)-torture: Stopping rcu_torture_fakewriter task
[ 4090.932855] (null)-torture: Stopping rcu_torture_stats task
[ 4090.932876] rcu-torture: rtc:           (null) ver: 10795 tfle: 0 rta: 10795 rtaf: 0 rtf: 10781 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 5071613 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 4090.932876] rcu-torture: Reader Pipe:  41736039587 41251 0 0 0 0 0 0 0 0 0
[ 4090.932876] rcu-torture: Reader Batch:  41735959128 121710 0 0 0 0 0 0 0 0 0
[ 4090.932876] rcu-torture: Free-Block Circulation:  10794 10794 10792 10790 10789 10788 10787 10784 10782 10781 0
[ 4090.932879] (null)-torture: Stopping rcu_torture_stats
[ 4090.944524] rcu-torture: rtc:           (null) ver: 10795 tfle: 0 rta: 10795 rtaf: 0 rtf: 10781 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 5071613 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=1000) barrier: 0/0:0
[ 4090.944524] rcu-torture: Reader Pipe:  41736039587 41251 0 0 0 0 0 0 0 0 0
[ 4090.944524] rcu-torture: Reader Batch:  41735959128 121710 0 0 0 0 0 0 0 0 0
[ 4090.944524] rcu-torture: Free-Block Circulation:  10794 10794 10792 10790 10789 10788 10787 10784 10782 10781 0
[ 4090.944529] rcu-torture:--- End of test: SUCCESS: nreaders=7 nfakewriters=4 stat_interval=60 verbose=1 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 stall_cpu=0 stall_cpu_holdoff=10 n_barrier_cbs=0 onoff_interval=0 onoff_holdoff=0
[ 4196.864328] Total:246000, unnecessary:246000, case1:192344, case2:246000, case3:0
[ 4336.699631] Total:248000, unnecessary:248000, case1:194221, case2:248000, case3:0
[ 4456.718535] Total:250000, unnecessary:250000, case1:196099, case2:250000, case3:0
[ 4627.778057] Total:252000, unnecessary:252000, case1:198015, case2:252000, case3:0
[ 4822.084236] Total:254000, unnecessary:254000, case1:199913, case2:254000, case3:0
[ 4877.761413] Total:256000, unnecessary:256000, case1:201784, case2:256000, case3:0
[ 5029.308243] Total:258000, unnecessary:258000, case1:203676, case2:258000, case3:0
[ 5106.189843] Total:260000, unnecessary:260000, case1:205559, case2:260000, case3:0
[ 5159.116287] Total:262000, unnecessary:262000, case1:207394, case2:262000, case3:0
[ 5242.264983] Total:264000, unnecessary:264000, case1:209329, case2:264000, case3:0
[ 5364.694906] Total:266000, unnecessary:266000, case1:211207, case2:266000, case3:0
[ 5563.267128] Total:268000, unnecessary:268000, case1:213150, case2:268000, case3:0
[ 5599.466740] Total:270000, unnecessary:270000, case1:215021, case2:270000, case3:0
[ 5608.630543] Total:272000, unnecessary:272000, case1:216908, case2:272000, case3:0
[ 5616.125674] Total:274000, unnecessary:274000, case1:218751, case2:274000, case3:0
[ 5625.333454] Total:276000, unnecessary:276000, case1:220592, case2:276000, case3:0
[ 5640.628464] Total:278000, unnecessary:278000, case1:222447, case2:278000, case3:0
[ 5655.251992] Total:280000, unnecessary:280000, case1:224311, case2:280000, case3:0
[ 5673.643576] Total:282000, unnecessary:282000, case1:226188, case2:282000, case3:0
[ 5688.910606] Total:284000, unnecessary:284000, case1:228044, case2:284000, case3:0
[ 5704.448413] Total:286000, unnecessary:286000, case1:229905, case2:286000, case3:0
[ 5719.641510] Total:288000, unnecessary:288000, case1:231755, case2:288000, case3:0
[ 5732.759222] Total:290000, unnecessary:290000, case1:233624, case2:290000, case3:0
[ 5746.615358] Total:292000, unnecessary:292000, case1:235478, case2:292000, case3:0
[ 5762.167169] Total:294000, unnecessary:294000, case1:237350, case2:294000, case3:0
[ 5780.174050] Total:296000, unnecessary:296000, case1:239205, case2:296000, case3:0
[ 5797.092785] Total:298000, unnecessary:298000, case1:241074, case2:298000, case3:0
[ 5811.592426] Total:300000, unnecessary:300000, case1:242924, case2:300000, case3:0
[ 5828.736924] Total:302000, unnecessary:302000, case1:244779, case2:302000, case3:0
[ 5843.599204] Total:304000, unnecessary:304000, case1:246655, case2:304000, case3:0
[ 5858.580389] Total:306000, unnecessary:306000, case1:248523, case2:306000, case3:0
[ 5873.313775] Total:308000, unnecessary:308000, case1:250379, case2:308000, case3:0
[ 5889.284185] Total:310000, unnecessary:310000, case1:252224, case2:310000, case3:0
[ 5904.781965] Total:312000, unnecessary:312000, case1:254075, case2:312000, case3:0
[ 5922.777788] Total:314000, unnecessary:314000, case1:255923, case2:314000, case3:0
[ 5944.681528] Total:316000, unnecessary:316000, case1:257771, case2:316000, case3:0
[ 5967.901234] Total:318000, unnecessary:318000, case1:259611, case2:318000, case3:0
[ 5975.538242] Total:320000, unnecessary:320000, case1:261490, case2:320000, case3:0
[ 5983.263147] Total:322000, unnecessary:322000, case1:263328, case2:322000, case3:0
[ 5993.437137] Total:324000, unnecessary:324000, case1:265156, case2:324000, case3:0
[ 6005.166895] Total:326000, unnecessary:326000, case1:267005, case2:326000, case3:0
[ 6017.374282] Total:328000, unnecessary:328000, case1:268864, case2:328000, case3:0
[ 6029.044968] kupfer[2545]: segfault at 5ba7e2 ip 00007f682759b4fa sp 00007fffe29c7290 error 7 in libglib-2.0.so.0.4000.0[7f6827556000+106000]
[ 6034.389883] Total:330000, unnecessary:330000, case1:270705, case2:330000, case3:0
[ 6050.048567] Total:332000, unnecessary:332000, case1:272568, case2:332000, case3:0
[ 6065.225620] Total:334000, unnecessary:334000, case1:274432, case2:334000, case3:0
[ 6080.957240] Total:336000, unnecessary:336000, case1:276281, case2:336000, case3:0
[ 6098.138716] Total:338000, unnecessary:338000, case1:278144, case2:338000, case3:0
[ 6118.421760] Total:340000, unnecessary:340000, case1:279979, case2:340000, case3:0
[ 6175.431917] Total:342000, unnecessary:342000, case1:281843, case2:342000, case3:0
[ 6259.766617] Total:344000, unnecessary:344000, case1:283629, case2:344000, case3:0
[ 7198.604721] Total:346000, unnecessary:346000, case1:285605, case2:346000, case3:0
[ 8438.462404] Total:348000, unnecessary:348000, case1:287585, case2:348000, case3:0

--------------000105020908060809000306--
