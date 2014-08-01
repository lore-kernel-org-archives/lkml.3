Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287AbaHAVZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 17:25:54 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:50102 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620AbaHAVZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 17:25:51 -0400
Date: Fri, 1 Aug 2014 14:24:47 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: "peterz@infrdead.org" <peterz@infrdead.org>,
        "bruno@wolff.to" <bruno@wolff.to>,
        "jwboyer@redhat.com" <jwboyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Michael Ellerman <michaele@au1.ibm.com>
Subject: Re: scheduler crash on Power
Message-ID: <20140801212447.GA25435@us.ibm.com>
References: <20140730072242.GA21516@us.ibm.com>
 <53DA2F15.1070605@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53DA2F15.1070605@arm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080121-5806-0000-0000-0000002115F0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dietmar Eggemann [dietmar.eggemann@arm.com] wrote:
| > ltcbrazos2-lp07 login: [  181.915974] ------------[ cut here ]------------
| > [  181.915991] WARNING: at ../kernel/sched/core.c:5881
| 
| This warning indicates the problem. One of the struct sched_domains does
| not have it's groups member set.
| 
| And its happening during a rebuild of the sched domain hierarchy, not
| during the initial build.
| 
| You could run your system with the following patch-let (on top of
| https://lkml.org/lkml/2014/7/17/288)  w/ and w/o the perf related
| patches (w/ CONFIG_SCHED_DEBUG enabled).
| 
| @@ -5882,6 +5882,9 @@ static void init_sched_groups_capacity(int cpu,
| struct sched_domain *sd)
|  {
|         struct sched_group *sg = sd->groups;
| 
| +#ifdef CONFIG_SCHED_DEBUG
| +       printk("sd name: %s span: %pc\n", sd->name, sd->span);
| +#endif
|         WARN_ON(!sg);
| 
|         do {
| 
| This will show if the rebuild of the sched domain hierarchy happens on
| both systems and hopefully indicate for which sched_domain the
| sd->groups is not set.

Thanks for the patch. It appears that the NUMA sched domain does not
have the sd->groups set - snippet of the error (with your patch and
Peter's patch)

[  181.914494] build_sched_groups: got group c000000006da0000 with cpus: 
[  181.914498] build_sched_groups: got group c0000000dd830000 with cpus: 
[  181.915234] sd name: SMT span: 8-15
[  181.915239] sd name: DIE span: 0-7
[  181.915242] sd name: NUMA span: 0-15
[  181.915250] ------------[ cut here ]------------
[  181.915253] WARNING: at ../kernel/sched/core.c:5891

Patched code:

	5884 static void init_sched_groups_capacity(int cpu, struct sched_domain *sd)
	5885 {
	5886         struct sched_group *sg = sd->groups;
	5887 
	5888 #ifdef CONFIG_SCHED_DEBUG
	5889         printk("sd name: %s span: %pc\n", sd->name, sd->span);
	5890 #endif
	5891         WARN_ON(!sg);

Complete log below.

I was able to bisect it down to this patch in the 24x7 patchset

	https://lkml.org/lkml/2014/5/27/804

I replaced the kfree(page) calls in the patch with
kmem_cache_free(hv_page_cache, page).

The problem sems to disappear if the call to create_events_from_catalog()
in hv_24x7_init() is skipped. I am continuing to debug the 24x7 patch.

While the patched kernel often crashes before the first ssh into it,
the unpatched kernel has been stable through multiple kernel builds.

Are there any scheduler specific tests I can run on the unpatched kernel ?

Sukadev

Complete log:

OF stdout device is: /vdevice/vty@30000000
Preparing to boot Linux version 3.16.0-rc7-24x7-dbg+ (root@ltcbrazos2-lp07.austin.ibm.com) (gcc version 4.8.2 20140120 (Red Hat 4.8.2-16) (GCC) ) #38 SMP Fri Aug 1 12:14:18 EDT 2014
Detected machine type: 0000000000000101
Max number of cores passed to firmware: 256 (NR_CPUS = 2048)
Calling ibm,client-architecture-support... done
command line: BOOT_IMAGE=/vmlinux-3.16.0-rc7-24x7-dbg+ root=UUID=e72c49fa-e137-43ff-ab41-44f3124572eb ro vconsole.keymap=us rd.lvm.lv=rhel_ltcbrazos2-lp07/root rd.lvm.lv=rhel_ltcbrazos2-lp07/swap crashkernel=auto vconsole.font=latarcyrheb-sun16
memory layout at init:
  memory_limit : 0000000000000000 (16 MB aligned)
  alloc_bottom : 000000000a5f0000
  alloc_top    : 0000000010000000
  alloc_top_hi : 0000000010000000
  rmo_top      : 0000000010000000
  ram_top      : 0000000010000000
instantiating rtas at 0x000000000ee20000... done
prom_hold_cpus: skipped
copying OF device tree...
Building dt strings...
Building dt structure...
Device tree strings 0x000000000a600000 -> 0x000000000a6016d4
Device tree struct  0x000000000a610000 -> 0x000000000a640000
Calling quiesce...
returning from prom_init
[    0.000000] crashkernel: memory value expected
[    0.000000] Using pSeries machine description
[    0.000000] Page sizes from device-tree:
[    0.000000] base_shift=12: shift=12, sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=0
[    0.000000] base_shift=12: shift=16, sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=7
[    0.000000] base_shift=12: shift=24, sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=56
[    0.000000] base_shift=16: shift=16, sllp=0x0110, avpnm=0x00000000, tlbiel=1, penc=1
[    0.000000] base_shift=16: shift=24, sllp=0x0110, avpnm=0x00000000, tlbiel=1, penc=8
[    0.000000] base_shift=24: shift=24, sllp=0x0100, avpnm=0x00000001, tlbiel=0, penc=0
[    0.000000] base_shift=34: shift=34, sllp=0x0120, avpnm=0x000007ff, tlbiel=0, penc=3
[    0.000000] Using 1TB segments
[    0.000000] kvm_cma: CMA: reserved 256 MiB
[    0.000000] Found initrd at 0xc000000009a00000:0xc00000000a5ebcf8
[    0.000000] bootconsole [udbg0] enabled
[    0.000000] Partition configured for 32 cpus.
[    0.000000] CPU maps initialized for 8 threads per core
 -> smp_release_cpus()
spinning_secondaries = 15
 <- smp_release_cpus()
[    0.000000] Starting Linux PPC64 #38 SMP Fri Aug 1 12:14:18 EDT 2014
[    0.000000] -----------------------------------------------------
[    0.000000] ppc64_pft_size                = 0x1a
[    0.000000] physicalMemorySize            = 0x100000000
[    0.000000] htab_hash_mask                = 0x7ffff
[    0.000000] -----------------------------------------------------
 <- setup_system()
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.16.0-rc7-24x7-dbg+ (root@ltcbrazos2-lp07.austin.ibm.com) (gcc version 4.8.2 20140120 (Red Hat 4.8.2-16) (GCC) ) #38 SMP Fri Aug 1 12:14:18 EDT 2014
[    0.000000] [boot]0012 Setup Arch
[    0.000000] PPC64 nvram contains 15360 bytes
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   1: [mem 0x00000000-0xffffffff]
[    0.000000] Could not find start_pfn for node 0
[    0.000000] [boot]0015 Setup Done
[    0.000000] PERCPU: Embedded 2 pages/cpu @c000000001200000 s102272 r0 d28800 u131072
[    0.000000] Built 2 zonelists in Node order, mobility grouping on.  Total pages: 65480
[    0.000000] Policy zone: DMA
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinux-3.16.0-rc7-24x7-dbg+ root=UUID=e72c49fa-e137-43ff-ab41-44f3124572eb ro vconsole.keymap=us rd.lvm.lv=rhel_ltcbrazos2-lp07/root rd.lvm.lv=rhel_ltcbrazos2-lp07/swap crashkernel=auto vconsole.font=latarcyrheb-sun16
[    0.000000] PID hash table entries: 4096 (order: -1, 32768 bytes)
[    0.000000] Sorting __ex_table...
[    0.000000] Memory: 3793664K/4194304K available (7488K kernel code, 1728K rwdata, 1800K rodata, 4352K init, 2435K bss, 400640K reserved)
[    0.000000] SLUB: HWalign=128, Order=0-3, MinObjects=0, CPUs=32, Nodes=256
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=2048 to nr_cpu_ids=32.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-31.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=32
[    0.000000] NR_IRQS:512 nr_irqs:512 16
[    0.000001] clocksource: timebase mult[1f40000] shift[24] registered
[    0.000122] Console: colour dummy device 80x25
[    0.000142] console [hvc0] enabled
[    0.000142] console [hvc0] enabled
[    0.000157] bootconsole [udbg0] disabled
[    0.000157] bootconsole [udbg0] disabled
[    0.001245] allocated 1048576 bytes of page_cgroup
[    0.001253] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.001290] mempolicy: Enabling automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl
[    0.001296] pid_max: default: 32768 minimum: 301
[    0.001331] Security Framework initialized
[    0.001340] SELinux:  Initializing.
[    0.001404] Dentry cache hash table entries: 524288 (order: 6, 4194304 bytes)
[    0.002068] Inode-cache hash table entries: 262144 (order: 5, 2097152 bytes)
[    0.002394] Mount-cache hash table entries: 8192 (order: 0, 65536 bytes)
[    0.002398] Mountpoint-cache hash table entries: 8192 (order: 0, 65536 bytes)
[    0.002622] Initializing cgroup subsys memory
[    0.002686] Initializing cgroup subsys devices
[    0.002693] Initializing cgroup subsys freezer
[    0.002697] Initializing cgroup subsys net_cls
[    0.002702] Initializing cgroup subsys blkio
[    0.002707] Initializing cgroup subsys perf_event
[    0.002710] Initializing cgroup subsys hugetlb
[    0.002824] EEH: pSeries platform initialized
[    0.002837] POWER8 performance monitor hardware support registered
[    0.029685] Brought up 16 CPUs
[    0.032229] __sdt_alloc: allocated c0000000e7ab0000 with cpus: 
[    0.032262] __sdt_alloc: allocated c0000000e7ae0000 with cpus: 
[    0.032295] __sdt_alloc: allocated c0000000e7b10000 with cpus: 
[    0.032327] __sdt_alloc: allocated c0000000e7b40000 with cpus: 
[    0.032359] __sdt_alloc: allocated c0000000e7b70000 with cpus: 
[    0.032392] __sdt_alloc: allocated c0000000e7ba0000 with cpus: 
[    0.032424] __sdt_alloc: allocated c0000000e7bd0000 with cpus: 
[    0.032456] __sdt_alloc: allocated c0000000e7c00000 with cpus: 
[    0.032489] __sdt_alloc: allocated c0000000e7c30000 with cpus: 
[    0.032521] __sdt_alloc: allocated c0000000e7c60000 with cpus: 
[    0.032557] __sdt_alloc: allocated c0000000e7c90000 with cpus: 
[    0.032590] __sdt_alloc: allocated c0000000e7cc0000 with cpus: 
[    0.032622] __sdt_alloc: allocated c0000000e7cf0000 with cpus: 
[    0.032654] __sdt_alloc: allocated c0000000e7d20000 with cpus: 
[    0.032686] __sdt_alloc: allocated c0000000e7d50000 with cpus: 
[    0.032718] __sdt_alloc: allocated c0000000e7d80000 with cpus: 
[    0.032752] __sdt_alloc: allocated c0000000e7db0000 with cpus: 
[    0.032785] __sdt_alloc: allocated c0000000e7de0000 with cpus: 
[    0.032817] __sdt_alloc: allocated c0000000e7e10000 with cpus: 
[    0.032849] __sdt_alloc: allocated c0000000e7e40000 with cpus: 
[    0.032881] __sdt_alloc: allocated c0000000e7e70000 with cpus: 
[    0.032913] __sdt_alloc: allocated c0000000e7ea0000 with cpus: 
[    0.032945] __sdt_alloc: allocated c0000000e7ed0000 with cpus: 
[    0.032977] __sdt_alloc: allocated c0000000e7f00000 with cpus: 
[    0.033009] __sdt_alloc: allocated c0000000e7f30000 with cpus: 
[    0.033041] __sdt_alloc: allocated c0000000e7f60000 with cpus: 
[    0.033073] __sdt_alloc: allocated c0000000e7f90000 with cpus: 
[    0.033104] __sdt_alloc: allocated c0000000e7fc0000 with cpus: 
[    0.033136] __sdt_alloc: allocated c0000000e7ff0000 with cpus: 
[    0.033169] __sdt_alloc: allocated c0000000e6020000 with cpus: 
[    0.033201] __sdt_alloc: allocated c0000000e6050000 with cpus: 
[    0.033234] __sdt_alloc: allocated c0000000e6080000 with cpus: 
[    0.033268] __sdt_alloc: allocated c0000000e60b0000 with cpus: 
[    0.033300] __sdt_alloc: allocated c0000000e60e0000 with cpus: 
[    0.033333] __sdt_alloc: allocated c0000000e6110000 with cpus: 
[    0.033366] __sdt_alloc: allocated c0000000e6140000 with cpus: 
[    0.033398] __sdt_alloc: allocated c0000000e6170000 with cpus: 
[    0.033430] __sdt_alloc: allocated c0000000e61a0000 with cpus: 
[    0.033462] __sdt_alloc: allocated c0000000e61d0000 with cpus: 
[    0.033495] __sdt_alloc: allocated c0000000e6200000 with cpus: 
[    0.033527] __sdt_alloc: allocated c0000000e6230000 with cpus: 
[    0.033559] __sdt_alloc: allocated c0000000e6260000 with cpus: 
[    0.033591] __sdt_alloc: allocated c0000000e6290000 with cpus: 
[    0.033623] __sdt_alloc: allocated c0000000e62c0000 with cpus: 
[    0.033656] __sdt_alloc: allocated c0000000e62f0000 with cpus: 
[    0.033688] __sdt_alloc: allocated c0000000e6320000 with cpus: 
[    0.033720] __sdt_alloc: allocated c0000000e6350000 with cpus: 
[    0.033751] __sdt_alloc: allocated c0000000e6380000 with cpus: 
[    0.033779] build_sched_groups: got group c0000000e7ab0000 with cpus: 
[    0.033782] build_sched_groups: got group c0000000e7ae0000 with cpus: 
[    0.033785] build_sched_groups: got group c0000000e7b10000 with cpus: 
[    0.033788] build_sched_groups: got group c0000000e7b40000 with cpus: 
[    0.033791] build_sched_groups: got group c0000000e7b70000 with cpus: 
[    0.033794] build_sched_groups: got group c0000000e7ba0000 with cpus: 
[    0.033797] build_sched_groups: got group c0000000e7bd0000 with cpus: 
[    0.033801] build_sched_groups: got group c0000000e7c00000 with cpus: 
[    0.033804] build_sched_groups: got group c0000000e7db0000 with cpus: 
[    0.033808] build_sched_groups: got group c0000000e7f30000 with cpus: 
[    0.033814] build_sched_groups: got group c0000000e7c30000 with cpus: 
[    0.033817] build_sched_groups: got group c0000000e7c60000 with cpus: 
[    0.033820] build_sched_groups: got group c0000000e7c90000 with cpus: 
[    0.033823] build_sched_groups: got group c0000000e7cc0000 with cpus: 
[    0.033826] build_sched_groups: got group c0000000e7cf0000 with cpus: 
[    0.033829] build_sched_groups: got group c0000000e7d20000 with cpus: 
[    0.033832] build_sched_groups: got group c0000000e7d50000 with cpus: 
[    0.033835] build_sched_groups: got group c0000000e7d80000 with cpus: 
[    0.033844] sd name: SMT span: 8-15
[    0.033847] sd name: DIE span: 0-15
[    0.033850] sd name: SMT span: 8-15
[    0.033853] sd name: DIE span: 0-15
[    0.033855] sd name: SMT span: 8-15
[    0.033858] sd name: DIE span: 0-15
[    0.033860] sd name: SMT span: 8-15
[    0.033863] sd name: DIE span: 0-15
[    0.033865] sd name: SMT span: 8-15
[    0.033868] sd name: DIE span: 0-15
[    0.033871] sd name: SMT span: 8-15
[    0.033873] sd name: DIE span: 0-15
[    0.033876] sd name: SMT span: 8-15
[    0.033879] sd name: DIE span: 0-15
[    0.033881] sd name: SMT span: 8-15
[    0.033884] sd name: DIE span: 0-15
[    0.033886] sd name: SMT span: 0-7
[    0.033889] sd name: DIE span: 0-15
[    0.033891] sd name: SMT span: 0-7
[    0.033894] sd name: DIE span: 0-15
[    0.033897] sd name: SMT span: 0-7
[    0.033900] sd name: DIE span: 0-15
[    0.033902] sd name: SMT span: 0-7
[    0.033905] sd name: DIE span: 0-15
[    0.033907] sd name: SMT span: 0-7
[    0.033910] sd name: DIE span: 0-15
[    0.033912] sd name: SMT span: 0-7
[    0.033915] sd name: DIE span: 0-15
[    0.033917] sd name: SMT span: 0-7
[    0.033920] sd name: DIE span: 0-15
[    0.033923] sd name: SMT span: 0-7
[    0.033926] sd name: DIE span: 0-15
[    0.034722] devtmpfs: initialized
[    0.042415] EEH: devices created
[    0.042814] atomic64_test: passed
[    0.043378] NET: Registered protocol family 16
[    0.043512] EEH: No capable adapters found
[    0.043556] IBM eBus Device Driver
[    0.043659] cpuidle: using governor menu
[    0.043771] pstore: Registered nvram as persistent store backend
[    0.045476] PCI: Probing PCI hardware
[    0.045485] opal: Node not found
[    0.045490] opal_async_comp_init: Opal node not found
[    0.045574] pseries-rng: Registering arch random hook.
[    0.050977] vgaarb: loaded
[    0.051039] SCSI subsystem initialized
[    0.051074] usbcore: registered new interface driver usbfs
[    0.051083] usbcore: registered new interface driver hub
[    0.051133] usbcore: registered new device driver usb
[    0.051338] NetLabel: Initializing
[    0.051340] NetLabel:  domain hash size = 128
[    0.051343] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.051353] NetLabel:  unlabeled traffic allowed by default
[    0.051462] Switched to clocksource timebase
[    0.056986] NET: Registered protocol family 2
[    0.057176] TCP established hash table entries: 32768 (order: 2, 262144 bytes)
[    0.057237] TCP bind hash table entries: 32768 (order: 3, 524288 bytes)
[    0.057301] TCP: Hash tables configured (established 32768 bind 32768)
[    0.057311] TCP: reno registered
[    0.057318] UDP hash table entries: 2048 (order: 0, 65536 bytes)
[    0.057329] UDP-Lite hash table entries: 2048 (order: 0, 65536 bytes)
[    0.057411] NET: Registered protocol family 1
[    0.057455] Unpacking initramfs...
[    0.207096] Freeing initrd memory: 12160K (c000000009a00000 - c00000000a5e0000)
[    0.211424] IOMMU table initialized, virtual merging enabled
[    0.239364] hv-24x7: read 1246 catalog entries, created 1265 event attrs (0 failures), 127 descs
[    0.239802] futex hash table entries: 8192 (order: 4, 1048576 bytes)
[    0.239932] Initialise system trusted keyring
[    0.239952] audit: initializing netlink subsys (disabled)
[    0.239968] audit: type=2000 audit(1406910527.230:1): initialized
[    0.241068] HugeTLB registered 16 MB page size, pre-allocated 0 pages
[    0.241072] HugeTLB registered 16 GB page size, pre-allocated 0 pages
[    0.242558] zbud: loaded
[    0.242786] VFS: Disk quotas dquot_6.5.2
[    0.242838] Dquot-cache hash table entries: 8192 (order 0, 65536 bytes)
[    0.243065] msgmni has been set to 8076
[    0.243120] Key type big_key registered
[    0.244621] alg: No test for stdrng (krng)
[    0.244663] NET: Registered protocol family 38
[    0.244671] Key type asymmetric registered
[    0.244674] Asymmetric key parser 'x509' registered
[    0.244713] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.244878] io scheduler noop registered
[    0.244882] io scheduler deadline registered (default)
[    0.244924] io scheduler cfq registered
[    0.244989] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.244996] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.245000] rpaphp: RPA HOT Plug PCI Controller Driver version: 0.1
[    0.245855] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.246359] Linux agpgart interface v0.103
[    0.246435] rdac: device handler registered
[    0.246629] hp_sw: device handler registered
[    0.246633] emc: device handler registered
[    0.246635] alua: device handler registered
[    0.246665] libphy: Fixed MDIO Bus: probed
[    0.246757] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.246766] ehci-pci: EHCI PCI platform driver
[    0.246775] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.246783] ohci-pci: OHCI PCI platform driver
[    0.246791] uhci_hcd: USB Universal Host Controller Interface driver
[    0.246830] usbcore: registered new interface driver usbserial
[    0.246837] usbcore: registered new interface driver usbserial_generic
[    0.246845] usbserial: USB Serial support registered for generic
[    0.246973] mousedev: PS/2 mouse device common for all mice
[    0.247221] rtc-generic rtc-generic: rtc core: registered rtc-generic as rtc0
[    0.247239] powernv-cpufreq: power-mgt node not found
[    0.247242] powernv-cpufreq: powernv-cpufreq disabled. System does not support PState control
[    0.247455] hidraw: raw HID events driver (C) Jiri Kosina
[    0.247542] usbcore: registered new interface driver usbhid
[    0.247545] usbhid: USB HID core driver
[    0.247554] drop_monitor: Initializing network drop monitor service
[    0.247612] TCP: cubic registered
[    0.247622] Initializing XFRM netlink socket
[    0.247716] NET: Registered protocol family 10
[    0.247982] NET: Registered protocol family 17
[    0.248239] Loading compiled-in X.509 certificates
[    0.248810] Loaded X.509 cert 'Magrathea: Glacier signing key: 60ef07e620363bf1993b6d295d264cddf46db0ea'
[    0.248825] registered taskstats version 1
[    0.249232] rtc-generic rtc-generic: setting system clock to 2014-08-01 16:28:48 UTC (1406910528)
[    0.249683] Freeing unused kernel memory: 4352K (c000000000920000 - c000000000d60000)
[    0.259584] systemd[1]: systemd 208 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    0.259654] systemd[1]: Running in initial RAM disk.

Welcome to Red Hat Enterprise Linux Server 7.0 (Maipo) dracut-033-161.el7 (Initramfs)!

[    0.259878] systemd[1]: Set hostname to <ltcbrazos2-lp07.austin.ibm.com>.
[    0.260397] random: systemd urandom read with 17 bits of entropy available
[    0.283463] systemd[1]: Expecting device dev-disk-by\x2duuid-e72c49fa\x2de137\x2d43ff\x2dab41\x2d44f3124572eb.device...
         Expecting device dev-disk-by\x2duuid-e72c49fa\x2de13...572eb.device...
[    0.283699] systemd[1]: Starting -.slice.
[  OK  ] Created slice -.slice.
[    0.284073] systemd[1]: Created slice -.slice.
[    0.284104] systemd[1]: Starting System Slice.
[  OK  ] Created slice System Slice.
[    0.284303] systemd[1]: Created slice System Slice.
[    0.284333] systemd[1]: Starting Slices.
[  OK  ] Reached target Slices.
[    0.284471] systemd[1]: Reached target Slices.
[    0.284500] systemd[1]: Starting Timers.
[  OK  ] Reached target Timers.
[    0.284638] systemd[1]: Reached target Timers.
[    0.284667] systemd[1]: Starting Journal Socket.
[  OK  ] Listening on Journal Socket.
[    0.284840] systemd[1]: Listening on Journal Socket.
[    0.284987] systemd[1]: Starting dracut cmdline hook...
         Starting dracut cmdline hook...
[    0.285635] systemd[1]: Started Load Kernel Modules.
[    0.285651] systemd[1]: Starting Setup Virtual Console...
         Starting Setup Virtual Console...
[    0.286252] systemd[1]: Starting Journal Service...
         Starting Journal Service...
[  OK  ] Started Journal Service.
[    0.288168] systemd[1]: Started Journal Service.
[  OK  ] Listening on udev Kernel Socket.
[  OK  ] Listening on udev Control Socket.
[  OK  ] Reached target Sockets.
         Starting Create list of required static device nodes...rrent kernel...
         Starting Apply Kernel Variables...
[  OK  ] Reached target Swap.
[  OK  ] Reached target Local File Systems.
[    0.310520] systemd-journald[190]: Vacuuming done, freed 0 bytes
[  OK  ] Started Setup Virtual Console.
[  OK  ] Started Apply Kernel Variables.
[  OK  ] Started Create list of required static device nodes ...current kernel.
         Starting Create static device nodes in /dev...
[  OK  ] Started Create static device nodes in /dev.
[  OK  ] Started dracut cmdline hook.
         Starting dracut pre-udev hook...
[    0.427576] device-mapper: uevent: version 1.0.3
[    0.427741] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[  OK  ] Started dracut pre-udev hook.
         Starting udev Kernel Device Manager...
[    0.452095] systemd-udevd[321]: starting version 208
[  OK  ] Started udev Kernel Device Manager.
         Starting udev Coldplug all Devices...
         Mounting Configuration File System...
[  OK  ] Mounted Configuration File System.
[  OK  ] Started udev Coldplug all Devices.
         Starting dracut initqueue hook...
[  OK  ] Reached target System Initialization.
         Starting Show Plymouth Boot Screen...
[    0.500510] ibmvscsi 30000003: SRP_VERSION: 16.a
[    0.500675] scsi0 : IBM POWER Virtual SCSI Adapter 1.5.9
[    0.500859] ibmvscsi 30000003: partner initialization complete
[    0.500918] ibmvscsi 30000003: host srp version: 16.a, host partition ltcbrazos2-vios (1), OS 3, max io 262144
[    0.501006] ibmvscsi 30000003: Client reserve enabled
[    0.501024] ibmvscsi 30000003: sent SRP login
[    0.501059] ibmvscsi 30000003: SRP_LOGIN succeeded
[    0.511692] ibmvscsi 30000004: SRP_VERSION: 16.a
[    0.511798] scsi 0:0:1:0: Direct-Access     AIX      VDASD            0001 PQ: 0 ANSI: 3
[    0.511844] scsi1 : IBM POWER Virtual SCSI Adapter 1.5.9
[    0.511947] ibmvscsi 30000004: partner initialization complete
[    0.511991] ibmvscsi 30000004: host srp version: 16.a, host partition ltcbrazos2-vios (1), OS 3, max io 262144
[    0.512071] ibmvscsi 30000004: Client reserve enabled
[    0.512080] ibmvscsi 30000004: sent SRP login
[    0.512116] ibmvscsi 30000004: SRP_LOGIN succeeded
[  OK  ] Started Show Plymouth Boot Screen.
[  OK  ] Reached target Paths.
[  OK  ] Reached target Basic System.
[    0.531785] scsi 1:0:1:0: Direct-Access     AIX      VDASD            0001 PQ: 0 ANSI: 3
         Starting File System Check on /dev/disk/by-uuid/e72c...44f3124572eb...
[    0.567629] sd 0:0:1:0: [sda] 41943040 512-byte logical blocks: (21.4 GB/20.0 GiB)
[    0.567644] sd 1:0:1:0: [sdb] 41943040 512-byte logical blocks: (21.4 GB/20.0 GiB)
[    0.567702] sd 0:0:1:0: [sda] Write Protect is off
[    0.567711] sd 1:0:1:0: [sdb] Write Protect is off
[    0.567766] sd 0:0:1:0: [sda] Cache data unavailable
[    0.567773] sd 0:0:1:0: [sda] Assuming drive cache: write through
[    0.567775] sd 1:0:1:0: [sdb] Cache data unavailable
[    0.567776] sd 1:0:1:0: [sdb] Assuming drive cache: write through
[    0.568817]  sdb: sdb1
[    0.568818]  sda: sda1 sda2 sda3
[    0.569224] sd 1:0:1:0: [sdb] Attached SCSI disk
[    0.569315] sd 0:0:1:0: [sda] Attached SCSI disk
systemd-fsck[381]: fsck: error 2 (No such file or directory) while executing fsck.ext2 for /dev/disk/by-uuid/e72c49fa-e137-43ff-ab41-44f3124572eb
[  OK  ] Started File System Check on /dev/disk/by-uuid/e72c4...1-44f3124572eb.
[  OK  ] Started dracut initqueue hook.
         Mounting /sysroot...
[    1.292445] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    1.294315] XFS (dm-0): Mounting V4 Filesystem
[    1.399504] XFS (dm-0): Ending clean mount
[  OK  ] Mounted /sysroot.
[  OK  ] Reached target Initrd Root File System.
         Starting Reload Configuration from the Real Root...
[  OK  ] Started Reload Configuration from the Real Root.
[  OK  ] Reached target Initrd File Systems.
[  OK  ] Reached target Initrd Default Target.
[    1.544842] systemd-journald[190]: Received SIGTERM
[    1.710946] SELinux:  Disabled at runtime.
[    1.801479] audit: type=1404 audit(1406910530.050:2): selinux=0 auid=4294967295 ses=4294967295

Welcome to Red Hat Enterprise Linux Server 7.0 (Maipo)!

[  OK  ] Stopped Switch Root.
[  OK  ] Stopped target Switch Root.
[  OK  ] Stopped target Initrd File Systems.
         Stopping File System Check on /dev/disk/by-uuid/e72c...44f3124572eb...
[  OK  ] Stopped File System Check on /dev/disk/by-uuid/e72c4...1-44f3124572eb.
[  OK  ] Stopped target Initrd Root File System.
[  OK  ] Created slice User and Session Slice.
[  OK  ] Created slice system-serial\x2dgetty.slice.
         Expecting device dev-hvc0.device...
[  OK  ] Created slice system-getty.slice.
[  OK  ] Reached target Remote File Systems.
         Starting Collect Read-Ahead Data...
         Starting Replay Read-Ahead Data...
[  OK  ] Reached target Slices.
[  OK  ] Listening on Delayed Shutdown Socket.
[  OK  ] Listening on /dev/initctl Compatibility Named Pipe.
[  OK  ] Listening on udev Kernel Socket.
[  OK  ] Listening on udev Control Socket.
         Starting udev Coldplug all Devices...
         Mounting Debug File System...
[  OK  ] Set up automount Arbitrary Executable File Formats F...utomount Point.
         Starting Create list of required static device nodes...rrent kernel...
         Mounting POSIX Message Queue File System...
         Mounting Huge Pages File System...
[  OK  ] Reached target Encrypted Volumes.
[  OK  ] Listening on LVM2 metadata daemon socket.
[  OK  ] Listening on Device-mapper event daemon FIFOs.
         Starting Monitoring of LVM2 mirrors, snapshots etc. ...ress polling...
         Expecting device dev-mapper-rhel_ltcbrazos2\x2d\x2dl...dswap.device...
         Expecting device dev-disk-by\x2duuid-5db39dc3\x2df94...1ffc1.device...
[  OK  ] Stopped Trigger Flushing of Journal to Persistent Storage.
         Stopping Journal Service...
[  OK  ] Stopped Journal Service.
         Starting Journal Service...
[  OK  ] Started Journal Service.
[  OK  ] Started Collect Read-Ahead Data.
[  OK  ] Started Replay Read-Ahead Data.
         Starting Apply Kernel Variables...
[    2.276299] random: nonblocking pool is initialized
[    2.298061] systemd-journald[587]: Vacuuming done, freed 0 bytes
         Starting File System Check on Root Device...
[  OK  ] Started Apply Kernel Variables.
[  OK  ] Started udev Coldplug all Devices.
         Starting LVM2 metadata daemon...
[  OK  ] Started LVM2 metadata daemon.
[  OK  ] Mounted Debug File System.
[  OK  ] Mounted POSIX Message Queue File System.
[  OK  ] Mounted Huge Pages File System.
[  OK  ] Started Create list of required static device nodes ...current kernel.
         Starting Create static device nodes in /dev...
systemd-fsck[591]: /sbin/fsck.xfs: XFS file system.
[  OK  ] Started File System Check on Root Device.
         Starting Remount Root and Kernel File Systems...
[  OK  ] Started Create static device nodes in /dev.
         Starting udev Kernel Device Manager...
[  OK  ] Started Remount Root and Kernel File Systems.
         Starting Import network configuration from initramfs...
         Starting Configure read-only root support...
         Starting Load/Save Random Seed...
[  OK  ] Reached target Local File Systems (Pre).
[    2.371753] systemd-udevd[609]: starting version 208
[  OK  ] Started udev Kernel Device Manager.
[  OK  ] Started Import network configuration from initramfs.
[  OK  ] Started Load/Save Random Seed.
[  OK  ] Started Configure read-only root support.
[    2.618300] Registering IBM pSeries RNG driver
[  OK  ] Found device /dev/hvc0.
         Starting LVM2 PV scan on device 8:17...
[  OK  ] Started LVM2 PV scan on device 8:17.
[  OK  ] Found device /dev/mapper/rhel_ltcbrazos2--lp07-swap.
         Activating swap /dev/mapper/rhel_ltcbrazos2--lp07-swap...
[  OK  ] Started Monitoring of LVM2 mirrors, snapshots etc. u...ogress polling.
[    2.735042] Adding 4194240k swap on /dev/mapper/rhel_ltcbrazos2--lp07-swap.  Priority:-1 extents:1 across:4194240k FS
[  OK  ] Activated swap /dev/mapper/rhel_ltcbrazos2--lp07-swap.
[  OK  ] Reached target Swap.
         Starting LVM2 PV scan on device 8:3...
[  OK  ] Started LVM2 PV scan on device 8:3.
[  OK  ] Found device VDASD.
         Starting File System Check on /dev/disk/by-uuid/5db3...55e1b851ffc1...
systemd-fsck[1082]: /sbin/fsck.xfs: XFS file system.
[  OK  ] Started File System Check on /dev/disk/by-uuid/5db39...7-55e1b851ffc1.
         Mounting /boot...
[    2.792345] XFS (sda2): Mounting V4 Filesystem
[    4.370580] XFS (sda2): Ending clean mount
[  OK  ] Mounted /boot.
[  OK  ] Reached target Local File Systems.
         Starting Trigger Flushing of Journal to Persistent Storage...
         Starting Create Volatile Files and Directories...
         Starting Security Auditing Service...
         Starting Tell Plymouth To Write Out Runtime Data...
[    4.379516] systemd-journald[587]: Received request to flush runtime journal from PID 1
[  OK  ] Started Trigger Flushing of Journal to Persistent Storage.
[    4.392589] audit: type=1305 audit(1406910532.640:3): audit_pid=1098 old=0 auid=4294967295 ses=4294967295 res=1
[  OK  ] Started Security Auditing Service.
[  OK  ] Started Tell Plymouth To Write Out Runtime Data.
[  OK  ] Started Create Volatile Files and Directories.
         Starting Update UTMP about System Reboot/Shutdown...
[  OK  ] Started Update UTMP about System Reboot/Shutdown.
[  OK  ] Reached target System Initialization.
[  OK  ] Reached target Timers.
[  OK  ] Listening on Avahi mDNS/DNS-SD Stack Activation Socket.
[  OK  ] Listening on D-Bus System Message Bus Socket.
[  OK  ] Reached target Sockets.
[  OK  ] Reached target Paths.
[  OK  ] Reached target Basic System.
         Starting LSB: Start the iprupdate utility...
         Starting Dump dmesg to /var/log/dmesg...

Red Hat Enterprise Linux Server 7.0 (Maipo)
Kernel 3.16.0-rc7-24x7-dbg+ on an ppc64

ltcbrazos2-lp07 login: [  181.912190] __sdt_alloc: allocated c0000000e59c0000 with cpus: 
[  181.912231] __sdt_alloc: allocated c0000000cca60000 with cpus: 
[  181.912258] __sdt_alloc: allocated c0000000df0e0000 with cpus: 
[  181.912288] __sdt_alloc: allocated c0000000dc280000 with cpus: 
[  181.912319] __sdt_alloc: allocated c0000000daef0000 with cpus: 
[  181.912349] __sdt_alloc: allocated c0000000da9e0000 with cpus: 
[  181.912382] __sdt_alloc: allocated c0000000074d0000 with cpus: 
[  181.912413] __sdt_alloc: allocated c0000000e4590000 with cpus: 
[  181.912446] __sdt_alloc: allocated c0000000ddc00000 with cpus: 
[  181.912478] __sdt_alloc: allocated c0000000dd8c0000 with cpus: 
[  181.912510] __sdt_alloc: allocated c0000000e35c0000 with cpus: 
[  181.912541] __sdt_alloc: allocated c0000000e3420000 with cpus: 
[  181.912573] __sdt_alloc: allocated c0000000e3180000 with cpus: 
[  181.912605] __sdt_alloc: allocated c0000000e3010000 with cpus: 
[  181.912637] __sdt_alloc: allocated c000000006da0000 with cpus: 
[  181.912669] __sdt_alloc: allocated c0000000dd830000 with cpus: 
[  181.912704] __sdt_alloc: allocated c0000000e6970000 with cpus: 
[  181.912737] __sdt_alloc: allocated c0000000dda60000 with cpus: 
[  181.912768] __sdt_alloc: allocated c0000000db050000 with cpus: 
[  181.912799] __sdt_alloc: allocated c0000000ddfc0000 with cpus: 
[  181.912831] __sdt_alloc: allocated c0000000da250000 with cpus: 
[  181.912861] __sdt_alloc: allocated c000000007750000 with cpus: 
[  181.912891] __sdt_alloc: allocated c0000000e3510000 with cpus: 
[  181.912922] __sdt_alloc: allocated c000000007570000 with cpus: 
[  181.912953] __sdt_alloc: allocated c0000000da0c0000 with cpus: 
[  181.912984] __sdt_alloc: allocated c0000000dbf60000 with cpus: 
[  181.913015] __sdt_alloc: allocated c0000000e0a30000 with cpus: 
[  181.913047] __sdt_alloc: allocated c0000000da7d0000 with cpus: 
[  181.913078] __sdt_alloc: allocated c0000000e0bf0000 with cpus: 
[  181.913109] __sdt_alloc: allocated c0000000e00c0000 with cpus: 
[  181.913140] __sdt_alloc: allocated c0000000dc0d0000 with cpus: 
[  181.913172] __sdt_alloc: allocated c0000000e32f0000 with cpus: 
[  181.913211] __sdt_alloc: allocated c0000000d1420000 with cpus: 
[  181.913242] __sdt_alloc: allocated c0000000cc7a0000 with cpus: 
[  181.913275] __sdt_alloc: allocated c0000000cc4f0000 with cpus: 
[  181.913306] __sdt_alloc: allocated c0000000e4780000 with cpus: 
[  181.913338] __sdt_alloc: allocated c0000000da0e0000 with cpus: 
[  181.913370] __sdt_alloc: allocated c0000000e6c10000 with cpus: 
[  181.913401] __sdt_alloc: allocated c000000007810000 with cpus: 
[  181.913432] __sdt_alloc: allocated c0000000dc3e0000 with cpus: 
[  181.913464] __sdt_alloc: allocated c0000000d9a50000 with cpus: 
[  181.913496] __sdt_alloc: allocated c0000000dbb50000 with cpus: 
[  181.913527] __sdt_alloc: allocated c0000000cc500000 with cpus: 
[  181.913559] __sdt_alloc: allocated c0000000e4cd0000 with cpus: 
[  181.913591] __sdt_alloc: allocated c0000000dab10000 with cpus: 
[  181.913625] __sdt_alloc: allocated c0000000da5a0000 with cpus: 
[  181.913657] __sdt_alloc: allocated c0000000dabb0000 with cpus: 
[  181.913688] __sdt_alloc: allocated c0000000da3a0000 with cpus: 
[  181.913721] build_sched_groups: got group c0000000e59c0000 with cpus: 
[  181.913724] build_sched_groups: got group c0000000cca60000 with cpus: 
[  181.913728] build_sched_groups: got group c0000000df0e0000 with cpus: 
[  181.913731] build_sched_groups: got group c0000000dc280000 with cpus: 
[  181.913734] build_sched_groups: got group c0000000daef0000 with cpus: 
[  181.913737] build_sched_groups: got group c0000000da9e0000 with cpus: 
[  181.913740] build_sched_groups: got group c0000000074d0000 with cpus: 
[  181.913744] build_sched_groups: got group c0000000e4590000 with cpus: 
[  181.913747] build_sched_groups: got group c0000000e6970000 with cpus: 
[  181.914474] build_sched_groups: got group c0000000ddc00000 with cpus: 
[  181.914478] build_sched_groups: got group c0000000dd8c0000 with cpus: 
[  181.914481] build_sched_groups: got group c0000000e35c0000 with cpus: 
[  181.914485] build_sched_groups: got group c0000000e3420000 with cpus: 
[  181.914488] build_sched_groups: got group c0000000e3180000 with cpus: 
[  181.914491] build_sched_groups: got group c0000000e3010000 with cpus: 
[  181.914494] build_sched_groups: got group c000000006da0000 with cpus: 
[  181.914498] build_sched_groups: got group c0000000dd830000 with cpus: 
[  181.915234] sd name: SMT span: 8-15
[  181.915239] sd name: DIE span: 0-7
[  181.915242] sd name: NUMA span: 0-15
[  181.915250] ------------[ cut here ]------------
[  181.915253] WARNING: at ../kernel/sched/core.c:5891
[  181.915255] Modules linked in: sg cfg80211 rfkill ibmveth pseries_rng nx_crypto xfs libcrc32c sd_mod crc_t10dif crct10dif_common ibmvscsi scsi_transport_srp scsi_tgt dm_mirror dm_region_hash dm_log dm_mod
[  181.915277] CPU: 4 PID: 392 Comm: kworker/4:2 Not tainted 3.16.0-rc7-24x7-dbg+ #38
[  181.915286] Workqueue: events .topology_work_fn
[  181.915289] task: c0000000dd840000 ti: c0000000ddb00000 task.ti: c0000000ddb00000
[  181.915292] NIP: c0000000000d73dc LR: c0000000000d73d0 CTR: 0000000000738edc
[  181.915296] REGS: c0000000ddb03570 TRAP: 0700   Not tainted  (3.16.0-rc7-24x7-dbg+)
[  181.915299] MSR: 8000000100029032 <SF,EE,ME,IR,DR,RI>  CR: 28484024  XER: 00000009
[  181.915307] CFAR: c00000000073fc44 SOFTE: 1 
GPR00: c0000000000d73d0 c0000000ddb037f0 c000000000ea98f0 0000000000000018 
GPR04: 0000000000000000 0000000000000000 0003bece11fee927 000000000000005c 
GPR08: 0000000000000001 0000000000000001 0000000000000000 0000000000000080 
GPR12: 0000000028484024 c00000000ebe1200 0000000000000000 c0000000cc430018 
GPR16: 0000000000000078 c000000000ef0a68 0000000000000078 c0000000cc430000 
GPR20: 0000000000000000 0000000000000000 0000000000000001 c000000000db4182 
GPR24: c0000000008419a8 000000000000000f 0000000000000000 c000000000ef0ae0 
GPR28: c000000007868100 c0000000ddbd0000 0000000000000000 c000000000ef4f7c 
[  181.915350] NIP [c0000000000d73dc] .build_sched_domains+0xadc/0xe30
[  181.915353] LR [c0000000000d73d0] .build_sched_domains+0xad0/0xe30
[  181.915356] Call Trace:
[  181.915358] [c0000000ddb037f0] [c0000000000d73d0] .build_sched_domains+0xad0/0xe30 (unreliable)
[  181.915364] [c0000000ddb03950] [c0000000000d79f0] .partition_sched_domains+0x260/0x3f0
[  181.915370] [c0000000ddb03a30] [c0000000001417a4] .rebuild_sched_domains_locked+0x54/0x70
[  181.915375] [c0000000ddb03ab0] [c000000000143b38] .rebuild_sched_domains+0x28/0x50
[  181.915379] [c0000000ddb03b30] [c00000000004f250] .topology_work_fn+0x10/0x30
[  181.915384] [c0000000ddb03ba0] [c0000000000b7100] .process_one_work+0x1a0/0x4c0
[  181.915389] [c0000000ddb03c40] [c0000000000b7970] .worker_thread+0x180/0x630
[  181.915394] [c0000000ddb03d30] [c0000000000bfc88] .kthread+0x108/0x130
[  181.915401] [c0000000ddb03e30] [c00000000000a3e4] .ret_from_kernel_thread+0x58/0x74
[  181.915404] Instruction dump:
[  181.915407] 814a0000 2f8a0000 419e008c 7f48492a 7f03c378 38bd0098 ebdd0010 e89d0078 
[  181.915413] 48668825 60000000 7fc90074 7929d182 <0b090000> 387e0018 38800800 482c5e49 
[  181.915419] ---[ end trace 64757d4660d79fd7 ]---
[  181.915424] Unable to handle kernel paging request for data at address 0x00000018
[  181.915428] Faulting instruction address: 0xc00000000039d2a0
[  181.915432] Oops: Kernel access of bad area, sig: 11 [#1]
[  181.915434] SMP NR_CPUS=2048 NUMA pSeries
[  181.915437] Modules linked in: sg cfg80211 rfkill ibmveth pseries_rng nx_crypto xfs libcrc32c sd_mod crc_t10dif crct10dif_common ibmvscsi scsi_transport_srp scsi_tgt dm_mirror dm_region_hash dm_log dm_mod
[  181.915453] CPU: 4 PID: 392 Comm: kworker/4:2 Tainted: G        W     3.16.0-rc7-24x7-dbg+ #38
[  181.915457] Workqueue: events .topology_work_fn
[  181.915460] task: c0000000dd840000 ti: c0000000ddb00000 task.ti: c0000000ddb00000
[  181.915463] NIP: c00000000039d2a0 LR: c0000000000d73ec CTR: 0000000000738edc
[  181.915467] REGS: c0000000ddb034c0 TRAP: 0300   Tainted: G        W      (3.16.0-rc7-24x7-dbg+)
[  181.915470] MSR: 8000000100009032 <SF,EE,ME,IR,DR,RI>  CR: 28484024  XER: 00000009
[  181.915478] CFAR: c000000000009358 DAR: 0000000000000018 DSISR: 40000000 SOFTE: 1 
GPR00: c0000000000d73ec c0000000ddb03740 c000000000ea98f0 0000000000000018 
GPR04: 0000000000000800 0000000000000000 0003bece11fee927 000000000000005c 
GPR08: 0000000000000001 0000000000000001 0000000000000000 0000000000000080 
GPR12: 0000000028484024 c00000000ebe1200 0000000000000000 c0000000cc430018 
GPR16: 0000000000000078 c000000000ef0a68 0000000000000078 c0000000cc430000 
GPR20: 0000000000000000 0000000000000000 0000000000000001 c000000000db4182 
GPR24: c0000000008419a8 0000000000000020 0000000000000018 0000000000000800 
GPR28: 0000000000000020 0000000000000110 0000000000000000 0000000000000010 
[  181.915521] NIP [c00000000039d2a0] .__bitmap_weight+0x70/0x100
[  181.915525] LR [c0000000000d73ec] .build_sched_domains+0xaec/0xe30
[  181.915528] Call Trace:
[  181.915530] [c0000000ddb037f0] [c0000000000d73ec] .build_sched_domains+0xaec/0xe30
[  181.915534] [c0000000ddb03950] [c0000000000d79f0] .partition_sched_domains+0x260/0x3f0
[  181.915539] [c0000000ddb03a30] [c0000000001417a4] .rebuild_sched_domains_locked+0x54/0x70
[  181.915543] [c0000000ddb03ab0] [c000000000143b38] .rebuild_sched_domains+0x28/0x50
[  181.915547] [c0000000ddb03b30] [c00000000004f250] .topology_work_fn+0x10/0x30
[  181.915551] [c0000000ddb03ba0] [c0000000000b7100] .process_one_work+0x1a0/0x4c0
[  181.915555] [c0000000ddb03c40] [c0000000000b7970] .worker_thread+0x180/0x630
[  181.915559] [c0000000ddb03d30] [c0000000000bfc88] .kthread+0x108/0x130
[  181.915563] [c0000000ddb03e30] [c00000000000a3e4] .ret_from_kernel_thread+0x58/0x74
[  181.915567] Instruction dump:
[  181.915569] 409d00b4 3bbcffff 3be3fff8 7bbd1f48 3bc00000 7fa3ea14 48000018 60000000 
[  181.915575] 60000000 60000000 60000000 60420000 <e87f0009> 4bcb7409 60000000 7fbfe840 
[  181.915582] ---[ end trace 64757d4660d79fd8 ]---
[  181.921853] 
[  183.931867] Kernel panic - not syncing: Fatal exception
[  183.959943] Rebooting in 10 seconds..

