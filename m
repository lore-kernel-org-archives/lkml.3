Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbbATQ5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:57:14 -0500
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:33364 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbbATQ5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:57:10 -0500
Date: Tue, 20 Jan 2015 17:56:55 +0100
From: Sabrina Dubroca <sd@queasysnail.net>
To: Paul Moore <pmoore@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-audit@redhat.com,
        viro@zeniv.linux.org.uk, Richard Guy Briggs <rgb@redhat.com>
Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount
 root fs
Message-ID: <20150120165655.GA10904@kria>
References: <20150120185308.53f4af4e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150120185308.53f4af4e@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Today's linux-next doesn't boot on my qemu VM:

[    1.248357] scsi 0:0:0:0: Direct-Access     ATA      QEMU HARDDISK    0    PQ: 0 ANSI: 5
[    1.255899] sd 0:0:0:0: [sda] 8388608 512-byte logical blocks: (4.29 GB/4.00 GiB)
[    1.258333] sd 0:0:0:0: [sda] Write Protect is off
[    1.259475] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.268417] scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     2.2. PQ: 0 ANSI: 5
[    1.271673]  sda: sda1
[    1.281061] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.282320] VFS: Cannot open root device "sda1" or unknown-block(8,1): error -2
[    1.283484] Please append a correct "root=" boot option; here are the available partitions:
[    1.284748] 0100            4096 ram0  (driver?)
[    1.285479] 0101            4096 ram1  (driver?)
[    1.286218] 0102            4096 ram2  (driver?)
[    1.286992] 0103            4096 ram3  (driver?)
[    1.287741] 0104            4096 ram4  (driver?)
[    1.288640] 0105            4096 ram5  (driver?)
[    1.289394] 0106            4096 ram6  (driver?)
[    1.290195] 0107            4096 ram7  (driver?)
[    1.290962] 0108            4096 ram8  (driver?)
[    1.291695] 0109            4096 ram9  (driver?)
[    1.292404] 010a            4096 ram10  (driver?)
[    1.293114] 010b            4096 ram11  (driver?)
[    1.293922] 010c            4096 ram12  (driver?)
[    1.294643] 010d            4096 ram13  (driver?)
[    1.295401] 010e            4096 ram14  (driver?)
[    1.296167] 010f            4096 ram15  (driver?)
[    1.296975] 0800         4194304 sda  driver: sd
[    1.297697]   0801         4194272 sda1 00000000-01
[    1.298418] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(8,1)
[    1.300034] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.19.0-rc5-next-20150120-dirty #410
[    1.300039] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140617_173321-var-lib-archbuild-testing-x86_64-tobias 04/01/2014
[    1.300039]  ffffea0000001340 ffff88001f673dd8 ffffffff817e1197 000000000000004e
[    1.300039]  ffffffff81a6f2c8 ffff88001f673e58 ffffffff817dfd43 ffffffff81c9a860
[    1.300039]  ffff880000000010 ffff88001f673e68 ffff88001f673e08 ffff000031616473
[    1.300039] Call Trace:
[    1.300039]  [<ffffffff817e1197>] dump_stack+0x4f/0x7b
[    1.300039]  [<ffffffff817dfd43>] panic+0xd2/0x217
[    1.300039]  [<ffffffff81efd58b>] mount_block_root+0x200/0x28d
[    1.300039]  [<ffffffff81efd78b>] mount_root+0x54/0x58
[    1.300039]  [<ffffffff81efd8f7>] prepare_namespace+0x168/0x1a1
[    1.300039]  [<ffffffff81efd2b1>] kernel_init_freeable+0x29d/0x2ad
[    1.300039]  [<ffffffff817d7440>] ? rest_init+0x140/0x140
[    1.300039]  [<ffffffff817d744e>] kernel_init+0xe/0xf0
[    1.300039]  [<ffffffff817eb87c>] ret_from_fork+0x7c/0xb0
[    1.300039]  [<ffffffff817d7440>] ? rest_init+0x140/0x140
[    1.300039] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[    1.300039] ---[ end Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(8,1)


I bisected it down to:

5dc5218840e1  fs: create proper filename objects using getname_kernel()

I reverted then reapplied each part of that patch.  It works if I
leave out the hunk for do_path_lookup:

diff --git a/fs/namei.c b/fs/namei.c
index eeb3b83661f8..c3d21b79090e 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2001,9 +2001,15 @@ static int filename_lookup(int dfd, struct filename *name,
 static int do_path_lookup(int dfd, const char *name,
 				unsigned int flags, struct nameidata *nd)
 {
-	struct filename filename = { .name = name };
+	int retval;
+	struct filename *filename;
 
-	return filename_lookup(dfd, &filename, flags, nd);
+	filename = getname_kernel(name);
+	if (unlikely(IS_ERR(filename)))
+		return PTR_ERR(filename);
+	retval = filename_lookup(dfd, filename, flags, nd);
+	putname(filename);
+	return retval;
 }
 
 /* does lookup, returns the object with parent locked */



I don't know what other info you may need.
Full dmesg for the failed boot included below.

Thanks.


[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.19.0-rc5-next-20150120-dirty (zappy@kria) (gcc version 4.9.2 20141224 (prerelease) (GCC) ) #410 SMP PREEMPT Tue Jan 20 17:27:49 CET 2015
[    0.000000] Command line: root=/dev/sda1 console=ttyS0
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001ffdffff] usable
[    0.000000] BIOS-e820: [mem 0x000000001ffe0000-0x000000001fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.8 present.
[    0.000000] Hypervisor detected: KVM
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x1ffe0 max_arch_pfn = 0x400000000
[    0.000000] PAT configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- UC  
[    0.000000] found SMP MP-table at [mem 0x000f1010-0x000f101f] mapped at [ffff8800000f1010]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000] init_memory_mapping: [mem 0x1fc00000-0x1fdfffff]
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fbfffff]
[    0.000000] init_memory_mapping: [mem 0x1fe00000-0x1ffdffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0DD0 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x000000001FFE18BC 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x000000001FFE0E48 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x000000001FFE0040 000E08 (v01 BOCHS  BXPCDSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x000000001FFE0000 000040
[    0.000000] ACPI: SSDT 0x000000001FFE0EBC 000948 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x000000001FFE1804 000080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x000000001FFE1884 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1ffdf001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x000000001ffdffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x000000000009efff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x000000001ffdffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000001000-0x000000001ffdffff]
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x20000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:16 nr_cpumask_bits:16 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 480 pages/cpu @ffff88001f800000 s1927448 r8192 d30440 u2097152
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1f80d480
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 128873
[    0.000000] Kernel command line: root=/dev/sda1 console=ttyS0
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 474712K/523768K available (8132K kernel code, 1165K rwdata, 3512K rodata, 3448K init, 17440K bss, 49056K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU lockdep checking is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=16 to nr_cpu_ids=2.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=2
[    0.000000] Running RCU self tests
[    0.000000] NR_IRQS:4352 nr_irqs:440 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8671 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
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
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
[    0.000000]                ww contexts mixing:  ok  |  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok  |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]            spinlock nest unlocked:  ok  |
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:  ok  |  ok  |  ok  |
[    0.000000]                               try:  ok  |  ok  |  ok  |
[    0.000000]                             block:  ok  |  ok  |  ok  |
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] kmemleak: Kernel memory leak detector disabled
[    0.000000] kmemleak: Early log buffer exceeded (2228), please increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE
[    0.000000] tsc: Detected 3303.292 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 6609.85 BogoMIPS (lpj=11010973)
[    0.006666] pid_max: default: 32768 minimum: 301
[    0.006666] ACPI: Core revision 20141107
[    0.076988] ACPI: All ACPI Tables successfully acquired
[    0.077988] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.078786] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 bytes)
[    0.081753] Initializing cgroup subsys blkio
[    0.082252] Initializing cgroup subsys memory
[    0.082840] Initializing cgroup subsys devices
[    0.083373] Initializing cgroup subsys freezer
[    0.083955] Initializing cgroup subsys net_cls
[    0.084524] Initializing cgroup subsys net_prio
[    0.085254] mce: CPU supports 10 MCE banks
[    0.085914] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
[    0.086671] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.087727] debug: unmapping init [mem 0xffffffff82083000-0xffffffff82089fff]
[    0.092658] ftrace: allocating 27092 entries in 106 pages
[    0.100719] Enabling x2apic
[    0.101162] Enabled x2apic
[    0.103341] Switched APIC routing to physical x2apic.
[    0.105119] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.105825] smpboot: CPU0: Intel(R) Core(TM) i3-3225 CPU @ 3.30GHz (fam: 06, model: 3a, stepping: 09)
[    0.107730] Performance Events: 16-deep LBR, IvyBridge events, Intel PMU driver.
[    0.108868] ... version:                2
[    0.109434] ... bit width:              48
[    0.109999] ... generic registers:      4
[    0.109999] ... value mask:             0000ffffffffffff
[    0.110006] ... max period:             000000007fffffff
[    0.110758] ... fixed-purpose events:   3
[    0.111331] ... event mask:             000000070000000f
[    0.112681] KVM setup paravirtual spinlock
[    0.126895] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.134087] x86: Booting SMP configuration:
[    0.135065] .... node  #0, CPUs:      #1
[    0.006666] kvm-clock: cpu 1, msr 0:1ffdf041, secondary cpu clock
[    0.150115] x86: Booted up 1 node, 2 CPUs
[    0.150112] KVM setup async PF for cpu 1
[    0.150112] kvm-stealtime: cpu 1, msr 1fa0d480
[    0.152395] smpboot: Total of 2 processors activated (13218.71 BogoMIPS)
[    0.154047] devtmpfs: initialized
[    0.167282] RTC time: 16:27:59, date: 01/20/15
[    0.169276] NET: Registered protocol family 16
[    0.183543] cpuidle: using governor ladder
[    0.196768] cpuidle: using governor menu
[    0.197725] ACPI: bus type PCI registered
[    0.198468] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.200852] PCI: Using configuration type 1 for base access
[    0.247130] ACPI: Added _OSI(Module Device)
[    0.247906] ACPI: Added _OSI(Processor Device)
[    0.248731] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.249602] ACPI: Added _OSI(Processor Aggregator Device)
[    0.275585] ACPI: Interpreter enabled
[    0.276227] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20141107/hwxface-580)
[    0.277693] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20141107/hwxface-580)
[    0.279576] ACPI: (supports S0 S3 S4 S5)
[    0.280005] ACPI: Using IOAPIC for interrupt routing
[    0.281178] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.386427] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.386704] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    0.388165] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.393142] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.405309] acpiphp: Slot [3] registered
[    0.406583] acpiphp: Slot [4] registered
[    0.407098] acpiphp: Slot [5] registered
[    0.408249] acpiphp: Slot [6] registered
[    0.409410] acpiphp: Slot [7] registered
[    0.410417] acpiphp: Slot [8] registered
[    0.411558] acpiphp: Slot [9] registered
[    0.412698] acpiphp: Slot [10] registered
[    0.413745] acpiphp: Slot [11] registered
[    0.415141] acpiphp: Slot [12] registered
[    0.416305] acpiphp: Slot [13] registered
[    0.417085] acpiphp: Slot [14] registered
[    0.418259] acpiphp: Slot [15] registered
[    0.419418] acpiphp: Slot [16] registered
[    0.420418] acpiphp: Slot [17] registered
[    0.421468] acpiphp: Slot [18] registered
[    0.422624] acpiphp: Slot [19] registered
[    0.423748] acpiphp: Slot [20] registered
[    0.424912] acpiphp: Slot [21] registered
[    0.426073] acpiphp: Slot [22] registered
[    0.427086] acpiphp: Slot [23] registered
[    0.428245] acpiphp: Slot [24] registered
[    0.429403] acpiphp: Slot [25] registered
[    0.430415] acpiphp: Slot [26] registered
[    0.431719] acpiphp: Slot [27] registered
[    0.432882] acpiphp: Slot [28] registered
[    0.433747] acpiphp: Slot [29] registered
[    0.434955] acpiphp: Slot [30] registered
[    0.436114] acpiphp: Slot [31] registered
[    0.436693] PCI host bridge to bus 0000:00
[    0.437478] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.438499] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.439658] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.440014] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.441158] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.442301] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.443348] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.444606] pci_bus 0000:00: root bus resource [mem 0x20000000-0xfebfffff]
[    0.455053] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    0.455944] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.456673] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    0.457478] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.461459] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX4 ACPI
[    0.462321] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX4 SMB
[    0.490885] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.493666] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.496381] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.498853] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.500340] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.508149] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.509804] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.509804] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.510019] vgaarb: loaded
[    0.510540] vgaarb: bridge control possible 0000:00:02.0
[    0.514298] SCSI subsystem initialized
[    0.517646] PCI: Using ACPI for IRQ routing
[    0.522170] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.523421] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.524428] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.528794] Switched to clocksource kvm-clock
[    0.669271] pnp: PnP ACPI init
[    0.682044] pnp: PnP ACPI: found 6 devices
[    0.727112] NET: Registered protocol family 2
[    0.729045] TCP established hash table entries: 4096 (order: 3, 32768 bytes)
[    0.730449] TCP bind hash table entries: 4096 (order: 6, 327680 bytes)
[    0.731884] TCP: Hash tables configured (established 4096 bind 4096)
[    0.733098] TCP: reno registered
[    0.733505] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    0.734248] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    0.735538] NET: Registered protocol family 1
[    0.737119] RPC: Registered named UNIX socket transport module.
[    0.737885] RPC: Registered udp transport module.
[    0.738466] RPC: Registered tcp transport module.
[    0.739041] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.739833] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.740752] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.741476] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.745661] microcode: CPU0 sig=0x306a9, pf=0x1, revision=0x1
[    0.746966] microcode: CPU1 sig=0x306a9, pf=0x1, revision=0x1
[    0.748421] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.749946] Scanning for low memory corruption every 60 seconds
[    0.755101] futex hash table entries: 512 (order: 4, 65536 bytes)
[    0.755925] Initialise system trusted keyring
[    0.756742] audit: initializing netlink subsys (disabled)
[    0.757523] audit: type=2000 audit(1421771279.698:1): initialized
[    0.762111] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.846035] zpool: loaded
[    0.846398] zbud: loaded
[    0.854624] VFS: Disk quotas dquot_6.5.2
[    0.855956] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.875173] NFS: Registering the id_resolver key type
[    0.875857] Key type id_resolver registered
[    0.876384] Key type id_legacy registered
[    0.876923] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    0.877781] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.884616] 9p: Installing v9fs 9p2000 file system support
[    0.888951] Key type asymmetric registered
[    0.889483] Asymmetric key parser 'x509' registered
[    0.891038] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.892203] io scheduler noop registered
[    0.892684] io scheduler deadline registered
[    0.894913] io scheduler cfq registered (default)
[    0.897956] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.899039] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.901991] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.902956] ACPI: Power Button [PWRF]
[    0.905511] GHES: HEST is not enabled!
[    0.907089] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.932140] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.940679] Linux agpgart interface v0.103
[    0.942041] [drm] Initialized drm 1.1.0 20060810
[    0.946934]  ram0: unknown partition table
[    0.949760]  ram1: unknown partition table
[    0.952405]  ram2: unknown partition table
[    0.954952]  ram3: unknown partition table
[    0.957594]  ram4: unknown partition table
[    0.960184]  ram5: unknown partition table
[    0.962753]  ram6: unknown partition table
[    0.965365]  ram7: unknown partition table
[    0.967949]  ram8: unknown partition table
[    0.970591]  ram9: unknown partition table
[    0.973145]  ram10: unknown partition table
[    0.975696]  ram11: unknown partition table
[    0.978270]  ram12: unknown partition table
[    0.980850]  ram13: unknown partition table
[    0.983490]  ram14: unknown partition table
[    0.986062]  ram15: unknown partition table
[    0.987299] brd: module loaded
[    1.012002] loop: module loaded
[    1.015014] nbd: registered device at major 43
[    1.053267]  nullb0: unknown partition table
[    1.056658]  nullb1: unknown partition table
[    1.059039] null: module loaded
[    1.073543] scsi host0: ata_piix
[    1.078934] scsi host1: ata_piix
[    1.081142] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc040 irq 14
[    1.082450] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc048 irq 15
[    1.085557] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    1.088762] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.090892] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.095813] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    1.100173] rtc_cmos 00:00: RTC can wake from S4
[    1.104933] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    1.106306] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet irqs
[    1.108350] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0x700, revision 0
[    1.110844] drop_monitor: Initializing network drop monitor service
[    1.112385] TCP: cubic registered
[    1.118817] NET: Registered protocol family 10
[    1.124642] NET: Registered protocol family 17
[    1.126381] bridge: automatic filtering via arp/ip/ip6tables has been deprecated. Update your scripts to load br_netfilter if you need this.
[    1.128949] 8021q: 802.1Q VLAN Support v1.8
[    1.129825] 9pnet: Installing 9P2000 support
[    1.130815] Key type dns_resolver registered
[    1.136875] Loading compiled-in X.509 certificates
[    1.137907] registered taskstats version 1
[    1.140583]   Magic number: 15:95:490
[    1.141050] acpi PNP0F13:00: hash matches
[    1.141650] rtc_cmos 00:00: setting system clock to 2015-01-20 16:28:00 UTC (1421771280)
[    1.143381] Warning: unable to open an initial console.
[    1.237994] ata2.00: ATAPI: QEMU DVD-ROM, 2.2.0, max UDMA/100
[    1.239917] ata1.00: ATA-7: QEMU HARDDISK, 2.2.0, max UDMA/100
[    1.241219] ata1.00: 8388608 sectors, multi 16: LBA48 
[    1.243389] ata1.00: configured for MWDMA2
[    1.245792] ata2.00: configured for MWDMA2
[    1.248357] scsi 0:0:0:0: Direct-Access     ATA      QEMU HARDDISK    0    PQ: 0 ANSI: 5
[    1.255899] sd 0:0:0:0: [sda] 8388608 512-byte logical blocks: (4.29 GB/4.00 GiB)
[    1.258333] sd 0:0:0:0: [sda] Write Protect is off
[    1.259475] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.268417] scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     2.2. PQ: 0 ANSI: 5
[    1.271673]  sda: sda1
[    1.281061] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.282320] VFS: Cannot open root device "sda1" or unknown-block(8,1): error -2
[    1.283484] Please append a correct "root=" boot option; here are the available partitions:
[    1.284748] 0100            4096 ram0  (driver?)
[    1.285479] 0101            4096 ram1  (driver?)
[    1.286218] 0102            4096 ram2  (driver?)
[    1.286992] 0103            4096 ram3  (driver?)
[    1.287741] 0104            4096 ram4  (driver?)
[    1.288640] 0105            4096 ram5  (driver?)
[    1.289394] 0106            4096 ram6  (driver?)
[    1.290195] 0107            4096 ram7  (driver?)
[    1.290962] 0108            4096 ram8  (driver?)
[    1.291695] 0109            4096 ram9  (driver?)
[    1.292404] 010a            4096 ram10  (driver?)
[    1.293114] 010b            4096 ram11  (driver?)
[    1.293922] 010c            4096 ram12  (driver?)
[    1.294643] 010d            4096 ram13  (driver?)
[    1.295401] 010e            4096 ram14  (driver?)
[    1.296167] 010f            4096 ram15  (driver?)
[    1.296975] 0800         4194304 sda  driver: sd
[    1.297697]   0801         4194272 sda1 00000000-01
[    1.298418] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(8,1)
[    1.300034] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.19.0-rc5-next-20150120-dirty #410
[    1.300039] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140617_173321-var-lib-archbuild-testing-x86_64-tobias 04/01/2014
[    1.300039]  ffffea0000001340 ffff88001f673dd8 ffffffff817e1197 000000000000004e
[    1.300039]  ffffffff81a6f2c8 ffff88001f673e58 ffffffff817dfd43 ffffffff81c9a860
[    1.300039]  ffff880000000010 ffff88001f673e68 ffff88001f673e08 ffff000031616473
[    1.300039] Call Trace:
[    1.300039]  [<ffffffff817e1197>] dump_stack+0x4f/0x7b
[    1.300039]  [<ffffffff817dfd43>] panic+0xd2/0x217
[    1.300039]  [<ffffffff81efd58b>] mount_block_root+0x200/0x28d
[    1.300039]  [<ffffffff81efd78b>] mount_root+0x54/0x58
[    1.300039]  [<ffffffff81efd8f7>] prepare_namespace+0x168/0x1a1
[    1.300039]  [<ffffffff81efd2b1>] kernel_init_freeable+0x29d/0x2ad
[    1.300039]  [<ffffffff817d7440>] ? rest_init+0x140/0x140
[    1.300039]  [<ffffffff817d744e>] kernel_init+0xe/0xf0
[    1.300039]  [<ffffffff817eb87c>] ret_from_fork+0x7c/0xb0
[    1.300039]  [<ffffffff817d7440>] ? rest_init+0x140/0x140
[    1.300039] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[    1.300039] ---[ end Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(8,1)


-- 
Sabrina
