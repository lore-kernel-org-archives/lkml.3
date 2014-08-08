Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbaHHRit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 13:38:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbaHHRir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 13:38:47 -0400
Date: Fri, 8 Aug 2014 23:07:10 +0530
From: Amit Shah <amit.shah@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 1/2] rcu: Parallelize and economize NOCB
 kthread wakeups
Message-ID: <20140808173710.GA13483@grmbl.mre>
References: <20140707224841.GA10101@linux.vnet.ibm.com>
 <1405085703-14822-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <53E48D18.8080007@redhat.com>
 <20140808162502.GX5821@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <20140808162502.GX5821@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On (Fri) 08 Aug 2014 [09:25:02], Paul E. McKenney wrote:
> On Fri, Aug 08, 2014 at 02:10:56PM +0530, Amit Shah wrote:
> > On Friday 11 July 2014 07:05 PM, Paul E. McKenney wrote:
> > >From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > >
> > >An 80-CPU system with a context-switch-heavy workload can require so
> > >many NOCB kthread wakeups that the RCU grace-period kthreads spend several
> > >tens of percent of a CPU just awakening things.  This clearly will not
> > >scale well: If you add enough CPUs, the RCU grace-period kthreads would
> > >get behind, increasing grace-period latency.
> > >
> > >To avoid this problem, this commit divides the NOCB kthreads into leaders
> > >and followers, where the grace-period kthreads awaken the leaders each of
> > >whom in turn awakens its followers.  By default, the number of groups of
> > >kthreads is the square root of the number of CPUs, but this default may
> > >be overridden using the rcutree.rcu_nocb_leader_stride boot parameter.
> > >This reduces the number of wakeups done per grace period by the RCU
> > >grace-period kthread by the square root of the number of CPUs, but of
> > >course by shifting those wakeups to the leaders.  In addition, because
> > >the leaders do grace periods on behalf of their respective followers,
> > >the number of wakeups of the followers decreases by up to a factor of two.
> > >Instead of being awakened once when new callbacks arrive and again
> > >at the end of the grace period, the followers are awakened only at
> > >the end of the grace period.
> > >
> > >For a numerical example, in a 4096-CPU system, the grace-period kthread
> > >would awaken 64 leaders, each of which would awaken its 63 followers
> > >at the end of the grace period.  This compares favorably with the 79
> > >wakeups for the grace-period kthread on an 80-CPU system.
> > >
> > >Reported-by: Rik van Riel <riel@redhat.com>
> > >Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > This patch causes KVM guest boot to not proceed after a while.
> > .config is attached, and boot messages are appeneded.  This commit
> > was pointed to by bisect, and reverting on current master (while
> > addressing a trivial conflict) makes the boot work again.
> > 
> > The qemu cmdline is
> > 
> > ./x86_64-softmmu/qemu-system-x86_64 -m 512 -smp 2 -cpu
> > host,+kvmclock,+x2apic -enable-kvm  -kernel
> > ~/src/linux/arch/x86/boot/bzImage /guests/f11-auto.qcow2  -append
> > 'root=/dev/sda2 console=ttyS0 console=tty0' -snapshot -serial stdio
> 
> I cannot reproduce this.  I am at commit a7d7a143d0b4c, in case that
> makes a difference.

Yea; I'm at that commit too.  And the version of qemu doesn't matter;
happens on F20's qemu-kvm-1.6.2-7.fc20.x86_64 as well as qemu.git
compiled locally.

> There are some things in your dmesg that look quite strange to me, though.
> 
> You have "--smp 2" above, but in your dmesg I see the following:
> 
> 	[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4
> 	nr_cpu_ids:1 nr_node_ids:1
> 
> So your run somehow only has one CPU.  RCU agrees that there is only
> one CPU:

Yea; indeed.  There are MTRR warnings too; attaching the boot log of
failed run and diff to the successful run (rcu-good-notime.txt).

The failed run is on commit a7d7a143d0b4cb1914705884ca5c25e322dba693
and the successful run has these reverted on top:

187497fa5e9e9383820d33e48b87f8200a747c2a
b58cc46c5f6b57f1c814e374dbc47176e6b4938e
fbce7497ee5af800a1c350c73f3c3f103cb27a15

That is rcu-bad-notime.txt.

> 	[    0.000000] Preemptible hierarchical RCU implementation.
> 	[    0.000000] 	RCU debugfs-based tracing is enabled.
> 	[    0.000000] 	RCU lockdep checking is enabled.
> 	[    0.000000] 	Additional per-CPU info printed with stalls.
> 	[    0.000000] 	RCU restricting CPUs from NR_CPUS=4 to nr_cpu_ids=1.
> 	[    0.000000] 	Offload RCU callbacks from all CPUs
> 	[    0.000000] 	Offload RCU callbacks from CPUs: 0.
> 	[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=1
> 	[    0.000000] NO_HZ: Full dynticks CPUs: 1-3.
> 
> But NO_HZ thinks that there are four.  This appears to be due to NO_HZ
> looking at the compile-time constants, and I doubt that this would cause
> a problem.  But if there really is a CPU 1 that RCU doesn't know about,
> and it queues a callback, that callback will never be invoked, and you
> could easily see hangs.
> 
> Give that your .config says CONFIG_NR_CPUS=4 and your qemu says "--smp 2",
> why does nr_cpu_ids think that there is only one CPU?  Are you running
> this on a non-x86_64 CPU so that qemu only does UP or some such?

No; this is "Intel(R) Core(TM) i7-2640M CPU @ 2.80GHz" on a ThinkPad
T420s.

In my attached boot logs, RCU does detect two cpus.  Here's the diff
between them.  I recompiled to remove the timing info so the diffs are
comparable:

$ diff -u /var/tmp/rcu-bad-notime.txt /var/tmp/rcu-good-notime.txt 
--- /var/tmp/rcu-bad-notime.txt	       2014-08-08 22:49:37.207745682 +0530
+++ /var/tmp/rcu-good-notime.txt       2014-08-08 22:49:04.886653844 +0530
@@ -1,6 +1,6 @@
 $ ./x86_64-softmmu/qemu-system-x86_64 -m 512 -smp 2 -cpu host,+kvmclock,+x2apic -enable-kvm  -kernel ~/src/linux/arch/x86/boot/bzImage /guests/f11-auto.qcow2  -append 'root=/dev/sda2 console=ttyS0 console=tty0'  -snapshot  -serial stdio
 Initializing cgroup subsys cpu
-Linux version 3.16.0+ (amit@grmbl.mre) (gcc version 4.8.3 20140624 (Red Hat 4.8.3-1) (GCC) ) #79 SMP PREEMPT Fri Aug 8 22:47:38 IST 2014
+Linux version 3.16.0+ (amit@grmbl.mre) (gcc version 4.8.3 20140624 (Red Hat 4.8.3-1) (GCC) ) #78 SMP PREEMPT Fri Aug 8 22:46:28 IST 2014
 Command line: root=/dev/sda2 console=ttyS0 console=tty0
 e820: BIOS-provided physical RAM map:
 BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
@@ -60,7 +60,7 @@
 e820: [mem 0x20000000-0xfeffbfff] available for PCI devices
 Booting paravirtualized kernel on KVM
 setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:2 nr_node_ids:1
-PERCPU: Embedded 475 pages/cpu @ffff88001f800000 s1916544 r8192 d20864 u2097152
+PERCPU: Embedded 475 pages/cpu @ffff88001f800000 s1915904 r8192 d21504 u2097152
 KVM setup async PF for cpu 0
 kvm-stealtime: cpu 0, msr 1f80cbc0
 Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 128873
@@ -71,7 +71,7 @@
 xsave: enabled xstate_bv 0x7, cntxt size 0x340
 AGP: Checking aperture...
 AGP: No AGP bridge found
-Memory: 483812K/523768K available (4029K kernel code, 727K rwdata, 2184K rodata, 2872K init, 14172K bss, 39956K reserved)
+Memory: 483812K/523768K available (4028K kernel code, 727K rwdata, 2184K rodata, 2872K init, 14172K bss, 39956K reserved)
 SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
 Preemptible hierarchical RCU implementation.
 	     RCU debugfs-based tracing is enabled.
@@ -106,7 +106,7 @@
 Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
 Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
 debug: unmapping init [mem 0xffffffff81b85000-0xffffffff81b87fff]
-ftrace: allocating 17857 entries in 70 pages
+ftrace: allocating 17856 entries in 70 pages
 ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
 smpboot: CPU0: Intel(R) Core(TM) i7-2640M CPU @ 2.80GHz (fam: 06, model: 2a, stepping: 07)
 Performance Events: 16-deep LBR, SandyBridge events, Intel PMU driver.
@@ -138,4 +138,207 @@
 mtrr: your CPUs had inconsistent MTRRdefType settings
 mtrr: probably your BIOS does not setup all CPUs.
 mtrr: corrected configuration.
+ACPI: Added _OSI(Module Device)
+ACPI: Added _OSI(Processor Device)
+ACPI: Added _OSI(3.0 _SCP Extensions)
+ACPI: Added _OSI(Processor Aggregator Device)
+ACPI: Interpreter enabled
+ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140724/hwxface-580)
+ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140724/hwxface-580)
+ACPI: (supports S0 S3 S4 S5)
+ACPI: Using IOAPIC for interrupt routing
+PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
+ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
+acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
+acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM

<followed by more bootup messages>

> The following is what I get (and what I would expect) with that setup:
> 
> 	[    0.000000] Hierarchical RCU implementation.
> 	[    0.000000]  RCU debugfs-based tracing is enabled.
> 	[    0.000000]  RCU lockdep checking is enabled.
> 	[    0.000000]  Additional per-CPU info printed with stalls.
> 	[    0.000000]  RCU restricting CPUs from NR_CPUS=4 to nr_cpu_ids=2.
> 	[    0.000000]  Offload RCU callbacks from all CPUs
> 	[    0.000000]  Offload RCU callbacks from CPUs: 0-1.
> 	[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
> 	[    0.000000] NO_HZ: Full dynticks CPUs: 1-3.
> 
> So whatever did you do with CPU 1?  ;-)

Dunno; let's use the current logs here.

> Of course, if I tell qemu "--smp 1" instead of "--smp 2", then RCU thinks
> that there is only one CPU:
> 
> 	[    0.000000] Hierarchical RCU implementation.
> 	[    0.000000]  RCU debugfs-based tracing is enabled.
> 	[    0.000000]  RCU lockdep checking is enabled.
> 	[    0.000000]  Additional per-CPU info printed with stalls.
> 	[    0.000000]  RCU restricting CPUs from NR_CPUS=4 to nr_cpu_ids=1.
> 	[    0.000000]  Offload RCU callbacks from all CPUs
> 	[    0.000000]  Offload RCU callbacks from CPUs: 0.
> 	[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=1
> 	[    0.000000] NO_HZ: Full dynticks CPUs: 1-3.
> 
> But it still works fine for me.
> 
> > Using qemu.git.
> > 
> > Rik suggested collecting qemu stack traces, here they are:
> 
> And they do look like the system is waiting.
> 
> You do have a warning below.
> 
> [    0.000000] WARNING: CPU: 0 PID: 0 at mm/early_ioremap.c:136 __early_ioremap+0xf5/0x1c4()
> 
> Not sure if this is related, but it might be good to fix this one anyway.
> 
> 							Thanx, Paul




		Amit

--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="rcu-good-notime.txt"

$ ./x86_64-softmmu/qemu-system-x86_64 -m 512 -smp 2 -cpu host,+kvmclock,+x2apic -enable-kvm  -kernel ~/src/linux/arch/x86/boot/bzImage /guests/f11-auto.qcow2  -append 'root=/dev/sda2 console=ttyS0 console=tty0'  -snapshot  -serial stdio
Initializing cgroup subsys cpu
Linux version 3.16.0+ (amit@grmbl.mre) (gcc version 4.8.3 20140624 (Red Hat 4.8.3-1) (GCC) ) #78 SMP PREEMPT Fri Aug 8 22:46:28 IST 2014
Command line: root=/dev/sda2 console=ttyS0 console=tty0
e820: BIOS-provided physical RAM map:
BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
BIOS-e820: [mem 0x0000000000100000-0x000000001ffdffff] usable
BIOS-e820: [mem 0x000000001ffe0000-0x000000001fffffff] reserved
BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
NX (Execute Disable) protection: active
SMBIOS 2.8 present.
Hypervisor detected: KVM
AGP: No AGP bridge found
e820: last_pfn = 0x1ffe0 max_arch_pfn = 0x400000000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping: [mem 0x00000000-0x000fffff]
init_memory_mapping: [mem 0x1fc00000-0x1fdfffff]
init_memory_mapping: [mem 0x1c000000-0x1fbfffff]
init_memory_mapping: [mem 0x00100000-0x1bffffff]
init_memory_mapping: [mem 0x1fe00000-0x1ffdffff]
ACPI: Early table checksum verification disabled
ACPI: RSDP 0x00000000000F0C50 000014 (v00 BOCHS )
ACPI: RSDT 0x000000001FFE18BD 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
ACPI: FACP 0x000000001FFE0B37 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
ACPI: DSDT 0x000000001FFE0040 000AF7 (v01 BOCHS  BXPCDSDT 00000001 BXPC 00000001)
ACPI: FACS 0x000000001FFE0000 000040
ACPI: SSDT 0x000000001FFE0BAB 000C5A (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
ACPI: APIC 0x000000001FFE1805 000080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
ACPI: HPET 0x000000001FFE1885 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
kvm-clock: Using msrs 4b564d01 and 4b564d00
kvm-clock: cpu 0, msr 0:1ffdf001, primary cpu clock
Zone ranges:
  DMA      [mem 0x00001000-0x00ffffff]
  DMA32    [mem 0x01000000-0xffffffff]
  Normal   empty
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x00001000-0x0009efff]
  node   0: [mem 0x00100000-0x1ffdffff]
ACPI: PM-Timer IO Port: 0x608
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
smpboot: Allowing 2 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
e820: [mem 0x20000000-0xfeffbfff] available for PCI devices
Booting paravirtualized kernel on KVM
setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 475 pages/cpu @ffff88001f800000 s1915904 r8192 d21504 u2097152
KVM setup async PF for cpu 0
kvm-stealtime: cpu 0, msr 1f80cbc0
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 128873
Kernel command line: root=/dev/sda2 console=ttyS0 console=tty0
PID hash table entries: 2048 (order: 2, 16384 bytes)
Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
xsave: enabled xstate_bv 0x7, cntxt size 0x340
AGP: Checking aperture...
AGP: No AGP bridge found
Memory: 483812K/523768K available (4028K kernel code, 727K rwdata, 2184K rodata, 2872K init, 14172K bss, 39956K reserved)
SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Preemptible hierarchical RCU implementation.
	RCU debugfs-based tracing is enabled.
	RCU lockdep checking is enabled.
	Additional per-CPU info printed with stalls.
	RCU restricting CPUs from NR_CPUS=4 to nr_cpu_ids=2.
	Offload RCU callbacks from all CPUs
	Offload RCU callbacks from CPUs: 0-1.
RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
NO_HZ: Full dynticks CPUs: 1-3.
NR_IRQS:4352 nr_irqs:512 16
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     32768
... MAX_LOCKDEP_CHAINS:      65536
... CHAINHASH_SIZE:          32768
 memory used by lock dependency info: 8671 kB
 per task-struct memory footprint: 2688 bytes
tsc: Detected 2790.934 MHz processor
Calibrating delay loop (skipped) preset value.. 5581.86 BogoMIPS (lpj=11163736)
pid_max: default: 32768 minimum: 301
ACPI: Core revision 20140724
ACPI: All ACPI Tables successfully acquired
Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
Mountpoint-cache hash table entries: 1024 (order: 1, 8192 bytes)
Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
debug: unmapping init [mem 0xffffffff81b85000-0xffffffff81b87fff]
ftrace: allocating 17856 entries in 70 pages
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
smpboot: CPU0: Intel(R) Core(TM) i7-2640M CPU @ 2.80GHz (fam: 06, model: 2a, stepping: 07)
Performance Events: 16-deep LBR, SandyBridge events, Intel PMU driver.
perf_event_intel: PEBS disabled due to CPU errata, please upgrade microcode
... version:                2
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
KVM setup paravirtual spinlock
x86: Booting SMP configuration:
.... node  #0, CPUs:      #1
kvm-clock: cpu 1, msr 0:1ffdf041, secondary cpu clock
x86: Booted up 1 node, 2 CPUs
KVM setup async PF for cpu 1
kvm-stealtime: cpu 1, msr 1fa0cbc0
smpboot: Total of 2 processors activated (11163.73 BogoMIPS)
prandom: seed boundary self test passed
prandom: 100 self tests passed
NET: Registered protocol family 16
cpuidle: using governor ladder
cpuidle: using governor menu
ACPI: bus type PCI registered
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
PCI: Using configuration type 1 for base access
mtrr: your CPUs had inconsistent variable MTRR settings
mtrr: your CPUs had inconsistent MTRRdefType settings
mtrr: probably your BIOS does not setup all CPUs.
mtrr: corrected configuration.
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: Interpreter enabled
ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140724/hwxface-580)
ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140724/hwxface-580)
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
acpiphp: Slot [3] registered
acpiphp: Slot [4] registered
acpiphp: Slot [5] registered
acpiphp: Slot [6] registered
acpiphp: Slot [7] registered
acpiphp: Slot [8] registered
acpiphp: Slot [9] registered
acpiphp: Slot [10] registered
acpiphp: Slot [11] registered
acpiphp: Slot [12] registered
acpiphp: Slot [13] registered
acpiphp: Slot [14] registered
acpiphp: Slot [15] registered
acpiphp: Slot [16] registered
acpiphp: Slot [17] registered
acpiphp: Slot [18] registered
acpiphp: Slot [19] registered
acpiphp: Slot [20] registered
acpiphp: Slot [21] registered
acpiphp: Slot [22] registered
acpiphp: Slot [23] registered
acpiphp: Slot [24] registered
acpiphp: Slot [25] registered
acpiphp: Slot [26] registered
acpiphp: Slot [27] registered
acpiphp: Slot [28] registered
acpiphp: Slot [29] registered
acpiphp: Slot [30] registered
acpiphp: Slot [31] registered
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [bus 00-ff]
pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: root bus resource [mem 0x20000000-0xfebfffff]
pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX4 ACPI
pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX4 SMB
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
ACPI: Enabled 16 GPEs in block 00 to 0F
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:00:02.0
SCSI subsystem initialized
pps_core: LinuxPPS API ver. 1 registered
pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
PTP clock support registered
PCI: Using ACPI for IRQ routing
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Switched to clocksource kvm-clock
pnp: PnP ACPI init
pnp: PnP ACPI: found 6 devices
NET: Registered protocol family 2
TCP established hash table entries: 4096 (order: 3, 32768 bytes)
TCP bind hash table entries: 4096 (order: 6, 327680 bytes)
TCP: Hash tables configured (established 4096 bind 4096)
TCP: reno registered
UDP hash table entries: 256 (order: 3, 49152 bytes)
UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
NET: Registered protocol family 1
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
pci 0000:00:01.0: PIIX3: Enabling Passive Release
pci 0000:00:01.0: Activating ISA DMA hang workarounds
rcu-torture:--- Start of test: nreaders=1 nfakewriters=4 stat_interval=60 verbose=1 test_no_idle_hz=1 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 stall_cpu=0 stall_cpu_holdoff=10 n_barrier_cbs=0 onoff_interval=0 onoff_holdoff=0
rcu-torture: Creating rcu_torture_writer task
rcu-torture: Creating rcu_torture_fakewriter task
rcu-torture: rcu_torture_writer task started
rcu-torture: Creating rcu_torture_fakewriter task
rcu-torture: rcu_torture_fakewriter task started
rcu-torture: Creating rcu_torture_fakewriter task
rcu-torture: rcu_torture_fakewriter task started
rcu-torture: Creating rcu_torture_fakewriter task
rcu-torture: rcu_torture_fakewriter task started
rcu-torture: Creating rcu_torture_reader task
rcu-torture: rcu_torture_fakewriter task started
rcu-torture: Creating rcu_torture_stats task
rcu-torture: rcu_torture_reader task started
rcu-torture: Creating torture_shuffle task
rcu-torture: rcu_torture_stats task started
rcu-torture: Creating torture_stutter task
rcu-torture: torture_shuffle task started
rcu-torture: torture_stutter task started
futex hash table entries: 512 (order: 4, 65536 bytes)
audit: initializing netlink subsys (disabled)
audit: type=2000 audit(1407518207.595:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
msgmni has been set to 944
------------[ cut here ]------------
WARNING: CPU: 1 PID: 47 at kernel/time/tick-sched.c:192 can_stop_full_tick+0xc0/0xcc()
NO_HZ FULL will not work with unstable sched clock
Modules linked in:
CPU: 1 PID: 47 Comm: kworker/u4:1 Not tainted 3.16.0+ #78
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
 0000000000000000 0000000030a09456 ffff88001fa03ea0 ffffffff813e50b9
 ffff88001fa03ee8 ffff88001fa03ed8 ffffffff81038ed4 ffffffff810a15e0
 0000000000000000 0000000000000001 ffff88001f9d2e00 0000000000000000
Call Trace:
 <IRQ>  [<ffffffff813e50b9>] dump_stack+0x4e/0x7a
 [<ffffffff81038ed4>] warn_slowpath_common+0x7f/0x98
 [<ffffffff810a15e0>] ? can_stop_full_tick+0xc0/0xcc
 [<ffffffff81038f49>] warn_slowpath_fmt+0x5c/0x73
 [<ffffffff810a15e0>] can_stop_full_tick+0xc0/0xcc
 [<ffffffff810a20e1>] tick_nohz_irq_exit+0x68/0x84
 [<ffffffff8103cbea>] irq_exit+0xc3/0xda
 [<ffffffff813ee860>] smp_apic_timer_interrupt+0x35/0x41
 [<ffffffff813ed402>] apic_timer_interrupt+0x72/0x80
 <EOI>  [<ffffffff81044417>] ? __lock_task_sighand+0xbf/0x114
 [<ffffffff81074627>] ? arch_local_irq_restore+0x12/0x19
 [<ffffffff813ebe18>] _raw_spin_unlock_irqrestore+0x4d/0x6d
 [<ffffffff81057805>] task_rq_unlock+0x22/0x27
 [<ffffffff8105cf09>] wake_up_new_task+0xe4/0x14a
 [<ffffffff8103842b>] do_fork+0x1be/0x30f
 [<ffffffff813ebf3e>] ? _raw_spin_unlock_irq+0x2c/0x4f
 [<ffffffff81071661>] ? trace_hardirqs_on_caller+0x171/0x18d
 [<ffffffff8107168a>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff813ebf4d>] ? _raw_spin_unlock_irq+0x3b/0x4f
 [<ffffffff810385a2>] kernel_thread+0x26/0x28
 [<ffffffff81049b0a>] wait_for_helper+0x40/0x73
 [<ffffffff8105abf7>] ? schedule_tail+0x30/0x76
 [<ffffffff81049aca>] ? __call_usermodehelper+0x80/0x80
 [<ffffffff813ec37c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81049aca>] ? __call_usermodehelper+0x80/0x80
---[ end trace 71e38ccd169ffd84 ]---
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered (default)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button [PWRF]
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
brd: module loaded
loop: module loaded
scsi host0: ata_piix
scsi host1: ata_piix
ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc040 irq 14
ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc048 irq 15
libphy: Fixed MDIO Bus: probed
e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
e1000: Copyright (c) 1999-2006 Intel Corporation.
ata2.00: ATAPI: QEMU DVD-ROM, 2.1.50, max UDMA/100
ata1.00: ATA-7: QEMU HARDDISK, 2.1.50, max UDMA/100
ata1.00: 10485760 sectors, multi 16: LBA48 
ata2.00: configured for MWDMA2
ata1.00: configured for MWDMA2
scsi 0:0:0:0: Direct-Access     ATA      QEMU HARDDISK    50   PQ: 0 ANSI: 5
scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     2.1. PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 10485760 512-byte logical blocks: (5.36 GB/5.00 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sr 1:0:0:0: [sr0] scsi3-mmc drive: 4x/4x cd/rw xa/form2 tray
cdrom: Uniform CD-ROM driver Revision: 3.20
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
tsc: Refined TSC clocksource calibration: 2790.922 MHz
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56
e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
pps pps0: new PPS source ktimer
pps pps0: ktimer PPS source registered
pps_ldisc: PPS line discipline registered
device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
TCP: cubic registered
NET: Registered protocol family 17
kmemleak: Kernel memory leak detector initialized
kmemleak: Automatic memory scanning thread started
EXT4-fs (sda2): couldn't mount as ext3 due to feature incompatibilities
EXT4-fs (sda2): couldn't mount as ext2 due to feature incompatibilities
EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
VFS: Mounted root (ext4 filesystem) readonly on device 8:2.
debug: unmapping init [mem 0xffffffff818b7000-0xffffffff81b84fff]
Write protecting the kernel read-only data: 8192k
debug: unmapping init [mem 0xffff8800013f0000-0xffff8800013fffff]
debug: unmapping init [mem 0xffff880001622000-0xffff8800017fffff]
qemu: terminating on signal 2

--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="rcu-bad-notime.txt"

$ ./x86_64-softmmu/qemu-system-x86_64 -m 512 -smp 2 -cpu host,+kvmclock,+x2apic -enable-kvm  -kernel ~/src/linux/arch/x86/boot/bzImage /guests/f11-auto.qcow2  -append 'root=/dev/sda2 console=ttyS0 console=tty0'  -snapshot  -serial stdio
Initializing cgroup subsys cpu
Linux version 3.16.0+ (amit@grmbl.mre) (gcc version 4.8.3 20140624 (Red Hat 4.8.3-1) (GCC) ) #79 SMP PREEMPT Fri Aug 8 22:47:38 IST 2014
Command line: root=/dev/sda2 console=ttyS0 console=tty0
e820: BIOS-provided physical RAM map:
BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
BIOS-e820: [mem 0x0000000000100000-0x000000001ffdffff] usable
BIOS-e820: [mem 0x000000001ffe0000-0x000000001fffffff] reserved
BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
NX (Execute Disable) protection: active
SMBIOS 2.8 present.
Hypervisor detected: KVM
AGP: No AGP bridge found
e820: last_pfn = 0x1ffe0 max_arch_pfn = 0x400000000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping: [mem 0x00000000-0x000fffff]
init_memory_mapping: [mem 0x1fc00000-0x1fdfffff]
init_memory_mapping: [mem 0x1c000000-0x1fbfffff]
init_memory_mapping: [mem 0x00100000-0x1bffffff]
init_memory_mapping: [mem 0x1fe00000-0x1ffdffff]
ACPI: Early table checksum verification disabled
ACPI: RSDP 0x00000000000F0C50 000014 (v00 BOCHS )
ACPI: RSDT 0x000000001FFE18BD 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
ACPI: FACP 0x000000001FFE0B37 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
ACPI: DSDT 0x000000001FFE0040 000AF7 (v01 BOCHS  BXPCDSDT 00000001 BXPC 00000001)
ACPI: FACS 0x000000001FFE0000 000040
ACPI: SSDT 0x000000001FFE0BAB 000C5A (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
ACPI: APIC 0x000000001FFE1805 000080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
ACPI: HPET 0x000000001FFE1885 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
kvm-clock: Using msrs 4b564d01 and 4b564d00
kvm-clock: cpu 0, msr 0:1ffdf001, primary cpu clock
Zone ranges:
  DMA      [mem 0x00001000-0x00ffffff]
  DMA32    [mem 0x01000000-0xffffffff]
  Normal   empty
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x00001000-0x0009efff]
  node   0: [mem 0x00100000-0x1ffdffff]
ACPI: PM-Timer IO Port: 0x608
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
smpboot: Allowing 2 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
e820: [mem 0x20000000-0xfeffbfff] available for PCI devices
Booting paravirtualized kernel on KVM
setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 475 pages/cpu @ffff88001f800000 s1916544 r8192 d20864 u2097152
KVM setup async PF for cpu 0
kvm-stealtime: cpu 0, msr 1f80cbc0
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 128873
Kernel command line: root=/dev/sda2 console=ttyS0 console=tty0
PID hash table entries: 2048 (order: 2, 16384 bytes)
Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
xsave: enabled xstate_bv 0x7, cntxt size 0x340
AGP: Checking aperture...
AGP: No AGP bridge found
Memory: 483812K/523768K available (4029K kernel code, 727K rwdata, 2184K rodata, 2872K init, 14172K bss, 39956K reserved)
SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Preemptible hierarchical RCU implementation.
	RCU debugfs-based tracing is enabled.
	RCU lockdep checking is enabled.
	Additional per-CPU info printed with stalls.
	RCU restricting CPUs from NR_CPUS=4 to nr_cpu_ids=2.
	Offload RCU callbacks from all CPUs
	Offload RCU callbacks from CPUs: 0-1.
RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
NO_HZ: Full dynticks CPUs: 1-3.
NR_IRQS:4352 nr_irqs:512 16
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     32768
... MAX_LOCKDEP_CHAINS:      65536
... CHAINHASH_SIZE:          32768
 memory used by lock dependency info: 8671 kB
 per task-struct memory footprint: 2688 bytes
tsc: Detected 2790.934 MHz processor
Calibrating delay loop (skipped) preset value.. 5581.86 BogoMIPS (lpj=11163736)
pid_max: default: 32768 minimum: 301
ACPI: Core revision 20140724
ACPI: All ACPI Tables successfully acquired
Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
Mountpoint-cache hash table entries: 1024 (order: 1, 8192 bytes)
Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
debug: unmapping init [mem 0xffffffff81b85000-0xffffffff81b87fff]
ftrace: allocating 17857 entries in 70 pages
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
smpboot: CPU0: Intel(R) Core(TM) i7-2640M CPU @ 2.80GHz (fam: 06, model: 2a, stepping: 07)
Performance Events: 16-deep LBR, SandyBridge events, Intel PMU driver.
perf_event_intel: PEBS disabled due to CPU errata, please upgrade microcode
... version:                2
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
KVM setup paravirtual spinlock
x86: Booting SMP configuration:
.... node  #0, CPUs:      #1
kvm-clock: cpu 1, msr 0:1ffdf041, secondary cpu clock
x86: Booted up 1 node, 2 CPUs
KVM setup async PF for cpu 1
kvm-stealtime: cpu 1, msr 1fa0cbc0
smpboot: Total of 2 processors activated (11163.73 BogoMIPS)
prandom: seed boundary self test passed
prandom: 100 self tests passed
NET: Registered protocol family 16
cpuidle: using governor ladder
cpuidle: using governor menu
ACPI: bus type PCI registered
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
PCI: Using configuration type 1 for base access
mtrr: your CPUs had inconsistent variable MTRR settings
mtrr: your CPUs had inconsistent MTRRdefType settings
mtrr: probably your BIOS does not setup all CPUs.
mtrr: corrected configuration.
qemu: terminating on signal 2

--mYCpIKhGyMATD0i+--
